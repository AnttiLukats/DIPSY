unit TF_FTDI;

interface

uses
  D2XXUnit,
  JEDEC_SPI;

var
  DevicePresent : Boolean;
  Selected_Device_Serial_Number : AnsiString;
  Selected_Device_Description : AnsiString;

  lastval: byte;

  EE_AddrBits : integer = 7; // 128 byte
  EE_Size : integer = 128; // 128 byte


  PageOffset: integer = 256;


  PageBuffer : Array[0..$FFFF] of byte;
  CommandBuffer : Array[0..$F] of byte;

  BigBuffer : Array[0..$1FFFFFF] of byte; // 32MB

  JEDEC_ID: cardinal;

  FilePages: integer;
  FileSize: integer;

  InternalFlash: boolean;

  ftdi_cache : boolean = false;
  ftdi_numb : integer = 0;

  use_MPSSE : boolean = true;

  DF_has_stat2 : boolean = false;

  CS_NUM: integer = 1;



function bitswap(b: byte): byte;



procedure spi_CS(value: integer);
function spi_MISO: integer;
procedure spi_MOSI(value: integer);
procedure spi_SCL(value: integer);
function spi_xfer(value: byte): byte;
procedure spi_xmit(value: byte);
function spi_rd8(value: byte): byte;
function spi_rd16(value: byte): byte;
function spi_rd32(value: byte): byte;

procedure spi_cmd(cmd: byte);
procedure spi_cmd2(cmd: byte; value: byte);
procedure spi_cmd3(cmd: byte; addr: cardinal);
procedure SPI_ProgramByte(addr: integer; data: byte);
//
function JEDEC_ID_READ: cardinal;


//


function DF_Identify: cardinal;
function DF_Identify2: cardinal;

function SPI_Status: byte;
function SPI_Status2: byte;
function DF_Status: byte;
function DF_Status2: byte;

procedure DF_Powerdown;
procedure DF_Wakeup;


procedure DF_ReadSecurityPage;
procedure DF_ReadPage(addr: cardinal);
procedure DF_ErasePage(addr: cardinal);

procedure DF_ReadPageBuffer(buf: integer);
procedure DF_WritePageBuffer(buf: integer);


function DF_ComparePageBuffer(buf: integer; addr: integer): boolean;
procedure DF_TransferPageBuffer(buf: integer; addr: integer);
procedure DF_ProgramPageBuffer(buf: integer; addr: integer);
procedure DF_ProgramWithErasePageBuffer(buf: integer; addr: integer);
procedure DF_Blow512;

procedure SPI_ProgramPageBuffer(addr: integer);
procedure SPI_ChipErase;


procedure BL_Reset;

//
procedure ee_CS(value: integer);
procedure ee_SCL(value: integer);
procedure ee_MOSI(value: integer);
function  ee_MISO: integer;

function ee_readbyte: byte;
procedure ee_writebyte(value: byte);

procedure ee_cmd(value: integer; addr: integer);
procedure ee_ERASE(addr: integer);
procedure ee_ERAL;
procedure ee_EWDS;
procedure ee_EWEN;
function ee_READ(addr: integer): byte;
procedure ee_WRITE(value: byte; addr: integer);
procedure ee_WRAL(value: byte);

procedure ee_ReadBuffer;
procedure ee_WriteBuffer;
procedure ee_BUSY;

function ftdi_xfer(value: byte): byte;
procedure ftdi_xmit(value: byte);
function ftdi_result: byte;
procedure ftdi_flush;


procedure mcu_EN;
procedure mcu_DIS;
function mcu_CALL: byte;
procedure mcu_BYTE(value: byte);
procedure mcu_ADDR(addr: integer);
procedure mcu_ADDR8(addr: integer);
function mcu_READ: byte;
procedure mcu_WRITE(value: byte);

procedure spi_SHADOW(value: byte);

// MPSSE
function Read_JEDEC: integer;
function Init_MPSSE: boolean;

//
function ICE_RESET: boolean;
function ICE_CONFIG(size:integer): boolean;


function WS_TEST(r,g,b: byte): boolean;

Type
  DataBuff = Array[0..$FFFF] of byte;
  Data_Ptr = ^DataBuff;


Var
//  Saved_Handle: DWord;
  PortAIsOpen : boolean;
  OutIndex : integer;
  PageData : Array[0..511] of Byte;
  speed : integer;
  Out_Buff : DataBuff;
  In_Buff : DataBuff;
  Saved_Port_Value : byte;

  //  RBFFileName : TfileName;

const USBBuffSize : integer = $4000;



implementation

function bitswap(b: byte): byte;
begin
  result :=
  ((b shr 7) and $01) or
  ((b shr 5) and $02) or
  ((b shr 3) and $04) or
  ((b shr 1) and $08) or
  ((b shl 1) and $10) or
  ((b shl 3) and $20) or
  ((b shl 5) and $40) or
  ((b shl 7) and $80);
end;

/////////////////


procedure SendBytes(NumberOfBytes : integer);
var i : integer;
begin
i := Write_USB_Device_Buffer( NumberOfBytes);
OutIndex := OutIndex - i;
end;


procedure AddToBuffer(I:integer);
begin
FT_Out_Buffer[OutIndex]:= I AND $FF;
inc(OutIndex);
end;

procedure Read_Data(in_buff : data_ptr;BitCount : word);
//
// This will work out the number of whole bytes to read
//
var res : FT_Result;
NoBytes,i,j : integer;
BitShift,Mod_BitCount : integer;
Last_Bit : byte;
Temp_Buffer : array[0..64000] of byte;
TotalBytes : integer;
begin
i := 0;
Mod_BitCount := BitCount - 1; // adjust for bit count of 1 less than no of bits
NoBytes := Mod_BitCount DIV 8;  // get whole bytes
BitShift := Mod_BitCount MOD 8; // get remaining bits
if BitShift > 0 then NoBytes := NoBytes + 1; // bump whole bytes if bits left over
i := 0;
TotalBytes := 0;
repeat
  repeat
    res := Get_USB_Device_QueueStatus;
  until FT_Q_Bytes > 0;
  j := Read_USB_Device_Buffer(FT_Q_Bytes);
  for i := 0 to (j-1) do
    begin
    Temp_Buffer[TotalBytes] := FT_In_Buffer[i];
    TotalBytes := TotalBytes + 1;
    end;
until TotalBytes >= NoBytes;

for j := 0 to (NoBytes-1) do
  begin
  in_buff[j] := Temp_Buffer[j];
  end;
end;



function Sync_To_MPSSE : boolean;
//
// This should satisfy outstanding commands.
//
// We will use $AA and $AB as commands which
// are invalid so that the MPSSE block should echo these
// back to us preceded with an $FA
//
var res : FT_Result;
i,j : integer;
Done : boolean;
begin
Sync_To_MPSSE := false;
res := Get_USB_Device_QueueStatus;
if res <> FT_OK then exit;
if (FT_Q_Bytes > 0) then
  i := Read_USB_Device_Buffer(FT_Q_Bytes);
  repeat
  OutIndex := 0;
  AddToBuffer($AA); // bad command
  SendBytes(OutIndex);
  res := Get_USB_Device_QueueStatus;
  until (FT_Q_Bytes > 0) or (res <> FT_OK); // or timeout
if res <> FT_OK then exit;
i := Read_USB_Device_Buffer(FT_Q_Bytes);
j := 0;
Done := False;
  repeat
  if (FT_In_Buffer[j] = $FA) then
    begin
    if (j < (i-2)) then
      begin
      if (FT_In_Buffer[j+1] = $AA) then Done := true;
      end;
    end;
  j := j + 1;
  until (j=i) or Done;
OutIndex := 0;
AddToBuffer($AB); // bad command
SendBytes(OutIndex);
  repeat
  res := Get_USB_Device_QueueStatus;
  until (FT_Q_Bytes > 0) or (res <> FT_OK); // or timeout
if res <> FT_OK then exit;
i := Read_USB_Device_Buffer(FT_Q_Bytes);
j := 0;
Done := False;
  repeat
  if (FT_In_Buffer[j] = $FA) then
    begin
    if (j <= (i-2)) then
      begin
      if (FT_In_Buffer[j+1] = $AB) then Done := true;
      end;
    end;
  j := j + 1;
  until (j=i) or Done;

if Done then Sync_To_MPSSE := true;
end;

function Set_CS_High : boolean;
begin
Set_CS_High := false;
if PortAIsOpen then
  begin
  if (CS_NUM=0) then
  begin
    Saved_Port_Value := Saved_Port_Value OR $88;
  end else begin
    Saved_Port_Value := Saved_Port_Value OR $90;
  end;


  AddToBuffer($80); // set SK,DO,CS as out
  AddToBuffer(Saved_Port_Value);
  AddToBuffer($9B);
  Set_CS_High := true;
  end;
end;

function ReleasePort : boolean;
begin
end;

// MPSSE MODE

function Set_CS_Low : boolean;
begin
Set_CS_Low := false;
if PortAIsOpen then
  begin
  if (CS_NUM=0) then
  begin
    Saved_Port_Value := (Saved_Port_Value AND $F7) OR $80;
  end else begin
    Saved_Port_Value := (Saved_Port_Value AND $EF) OR $80;
  end;

  AddToBuffer($80); // set SK,DO,CS as out

  AddToBuffer(Saved_Port_Value);
  AddToBuffer($9B);
  Set_CS_Low := true;
  end;
end;

function ScanIn_Out(BitCount : integer;OutBuffPtr : Data_Ptr ) : Boolean;
var Mod_BitCount,i,j : integer;
begin
ScanIn_Out := False;
if PortAIsOpen then
  begin
  j := 0;
  // adjust count value
  Mod_BitCount := BitCount - 1;
  if Mod_BitCount div 8 > 0 then
    begin // do whole bytes
    i := (Mod_BitCount div 8) - 1;
    AddToBuffer($35); // clk data bytes out on -ve in -ve clk MSB
    AddToBuffer(i AND $FF);
    AddToBuffer((i DIV 256) AND $FF);
    // now add the data bytes to go out
      repeat
      AddToBuffer(OutBuffPtr[j]);
      j := j + 1;
      until j > i;
    end;
  if Mod_BitCount mod 8 > 0 then
    begin // do remaining bits
    i := (Mod_BitCount mod 8);
    AddToBuffer($37); // clk data bits out on -ve in -ve clk MSB
    AddToBuffer(i AND $FF);
    // now add the data bits to go out
    AddToBuffer(OutBuffPtr[j]);
    end;
  end;
end;


function ScanIn(BitCount : integer ) : Boolean;
var Mod_BitCount,i,j : integer;
begin
ScanIn := False;
if PortAIsOpen then
  begin
  j := 0;
  // adjust count value
  Mod_BitCount := BitCount - 1;
  if Mod_BitCount div 8 > 0 then
    begin // do whole bytes
    i := (Mod_BitCount div 8) - 1;
    AddToBuffer($25); // clk data bytes in -ve clk MSB
    AddToBuffer(i AND $FF);
    AddToBuffer((i DIV 256) AND $FF);
    end;
  if Mod_BitCount mod 8 > 0 then
    begin // do remaining bits
    i := (Mod_BitCount mod 8);
    AddToBuffer($27); // clk data bits in -ve clk MSB
    AddToBuffer(i AND $FF);
    end;
  end;
end;


function ScanOut(BitCount : integer;OutBuffPtr : Data_Ptr ) : Boolean;
var Mod_BitCount,i,j : integer;
begin
ScanOut := False;
if PortAIsOpen then
  begin
  j := 0;
  // adjust count value
  Mod_BitCount := BitCount - 1;
  if Mod_BitCount div 8 > 0 then
    begin // do whole bytes
    i := (Mod_BitCount div 8) - 1;
    AddToBuffer($11); // clk data bytes out on -ve MSB
    AddToBuffer(i AND $FF);
    AddToBuffer((i DIV 256) AND $FF);
    // now add the data bytes to go out
      repeat
      AddToBuffer(OutBuffPtr[j]);
      j := j + 1;
      until j > i;
    end;
  if Mod_BitCount mod 8 > 0 then
    begin // do remaining bits
    i := (Mod_BitCount mod 8);
    AddToBuffer($13); // clk data bits out on -ve MSB
    AddToBuffer(i AND $FF);
    // now add the data bits to go out
    AddToBuffer(OutBuffPtr[j]);
    end;
  end;
end;


function Check_DO_Level : boolean;
var passed : boolean;
i : integer;
begin
Check_DO_Level := false;
AddToBuffer($81);
AddToBuffer($87);
SendBytes(OutIndex); // send off the command
Read_Data(@In_Buff,8);
i := In_Buff[0] AND $04;
if (i <> 0 ) then Check_DO_Level := true;
end;


function Init_MPSSE: boolean;
var passed : boolean;
res : FT_Result;
begin

  if PortAIsOpen then begin
    Init_MPSSE := True;
    exit;
  end;


  Init_MPSSE := false;
//passed := OpenPort(DName);

passed := True;
PortAIsOpen := True;



if passed then
  begin
  res := Set_USB_Device_LatencyTimer(16);
  res := Set_USB_Device_BitMode($00,$00); // reset controller
  res := Set_USB_Device_BitMode($00,$02); // enable JTAG controller
  passed := Sync_To_MPSSE;
  end;
if passed then
  begin
  OutIndex := 0;
//  sleep(20); // wait for all the USB stuff to complete

  // set Out LOW
  AddToBuffer($80); // set SK,DO,CS as out
    AddToBuffer($88); // all low  CS high
    Saved_Port_Value := $88;
    AddToBuffer($9B); // inputs on GPIO11-14


  // set OUT High
  AddToBuffer($82); // outputs on GPIO21-24
    AddToBuffer($0F);
    AddToBuffer($0F);

  AddToBuffer($86); // set clk divisor
    AddToBuffer(speed AND $FF);
    AddToBuffer(speed SHR 8);
  AddToBuffer($8A); // disable DIV 5


  // turn off loop back
  AddToBuffer($85);
  SendBytes(OutIndex); // send off the command
  Init_MPSSE := true;
  end;
end;


function Read_JEDEC: integer;
var passed : boolean;
i : integer;
begin

  Init_MPSSE;

  Read_JEDEC := 0;
  OutIndex := 0;
  Out_Buff[0] := $9F; //90;

  passed := Set_CS_Low;
  passed := ScanOut(8,@Out_Buff);

  passed := ScanIn(8*5);
  passed := Set_CS_High;

  AddToBuffer($87);
  SendBytes(OutIndex); // send off the command

  Read_Data(@In_Buff,8*5);
  //Read_Location := (In_Buff[0] * 256) or In_Buff[1];
  Read_JEDEC := (In_Buff[3] shl 24 or In_Buff[0] shl 16 or In_Buff[1] * 256) or In_Buff[2];

end;

function Read_STATUS: integer;
var passed : boolean;
i : integer;
begin

Init_MPSSE;

Read_STATUS := 0;
OutIndex := 0;
Out_Buff[0] := $05; //90;
passed := Set_CS_Low;
passed := ScanOut(8,@Out_Buff);
passed := ScanIn(8*1);
passed := Set_CS_High;
AddToBuffer($87);
SendBytes(OutIndex); // send off the command
Read_Data(@In_Buff,8*1);
//Read_Location := (In_Buff[0] * 256) or In_Buff[1];
Read_STATUS := In_Buff[0];


//Read_Location := In_Buff[0];

end;



////////////////////
















procedure spi_CS(value: integer);
begin
  if InternalFlash then
    lastval := lastval and $DF else
    lastval := lastval or $20;

  lastval := lastval and $35;
  if value<>0 then lastval := lastval or $08;

//  lastval := lastval and $35;
//  if value<>0 then lastval := lastval or $02;
  //lastval := lastval or $08;

//  FT_Out_Buffer[0] := lastval;
//  Write_USB_Device_Buffer(1);

  ftdi_xmit(lastval);
  ftdi_flush;
end;

function spi_MISO: integer;
begin
  if InternalFlash then lastval := lastval and $DF else lastval := lastval or $20;

  lastval := lastval or $40; // echo bit

  //FT_Out_Buffer[0] := lastval;
  //Write_USB_Device_Buffer(1);

  ftdi_xmit(lastval);
  //ftdi_flush;

  //Read_USB_Device_Buffer(1);
  //result := (FT_In_Buffer[0] shr 1) and $01;

  result := (ftdi_result shr 1) and 1;
  lastval := lastval and $3F;
end;

procedure spi_MOSI(value: integer);
begin
  if InternalFlash then lastval := lastval and $DF else lastval := lastval or $20;

  lastval := lastval and $2F;
  if value<>0 then lastval := lastval or $10;

  //FT_Out_Buffer[0] := lastval;
  //Write_USB_Device_Buffer(1);

  ftdi_xmit(lastval);
end;

procedure spi_SCL(value: integer);
begin
  if InternalFlash then lastval := lastval and $DF else lastval := lastval or $20;

  lastval := lastval and $3E;
  if value<>0 then lastval := lastval or $01;

  //FT_Out_Buffer[0] := lastval;
  //Write_USB_Device_Buffer(1);

  ftdi_xmit(lastval);
end;

function spi_xfer(value: byte): byte;
var
  PortStatus,
  i: integer;
  r: byte;
begin
  FT_Out_Buffer[0] := $C1;    // send 8 bits
  FT_Out_Buffer[1] := bitswap(value);  // send
  Write_USB_Device_Buffer(2);

//  Repeat
//  PortStatus := Get_USB_Device_QueueStatus;
//  If PortStatus <> FT_OK then     // Device no longer present ...
//    Begin
//      caption := 'err';
//    End;
//  Until FT_Q_Bytes > 0;

  Read_USB_Device_Buffer(1);
  result := bitswap(FT_In_Buffer[0]);
end;

procedure spi_xmit(value: byte);
var
  PortStatus,
  i: integer;
  r: byte;
begin
  FT_Out_Buffer[0] := $81;    // send 8 bits
  FT_Out_Buffer[1] := bitswap(value);  // send
  Write_USB_Device_Buffer(2);
end;

procedure spi_cmd(cmd: byte);
var
  PortStatus,
  i: integer;
  r: byte;
  passed : boolean;
begin
  if use_MPSSE then
  begin

    Init_MPSSE;

    OutIndex := 0;
    Out_Buff[0] := cmd; //90;

    passed := Set_CS_Low;
    passed := ScanOut(8,@Out_Buff);

    passed := ScanIn(8*4);
    passed := Set_CS_High;

    AddToBuffer($87);
    SendBytes(OutIndex); // send off the command

  end else begin
    lastval := lastval or $20;
    lastval := lastval and $35; // CS=0

    FT_Out_Buffer[0] := lastval;

    FT_Out_Buffer[1] := $81;    //
    FT_Out_Buffer[2] := bitswap(cmd);  // send

    lastval := lastval or $08;  // CS=1
    FT_Out_Buffer[3] := lastval;

    Write_USB_Device_Buffer(4);
  end;
end;

procedure spi_cmd2(cmd: byte; value: byte);
var
  PortStatus,
  i: integer;
  r: byte;
begin
  //
  if use_MPSSE then
  begin

    Init_MPSSE;

    OutIndex := 0;

      // WR
      Out_Buff[0] := cmd;
      Out_Buff[1] := value;
      Set_CS_Low;
      ScanOut(16,@Out_Buff);
      Set_CS_High;

      AddToBuffer($87);
      SendBytes(OutIndex); // send off the command
  end;
exit;

  lastval := lastval or $20;
  lastval := lastval and $35; // CS=0

  FT_Out_Buffer[0] := lastval;

  FT_Out_Buffer[1] := $82;    //
  FT_Out_Buffer[2] := bitswap(cmd);  // send
  FT_Out_Buffer[3] := bitswap(value);  // send

  lastval := lastval or $08;  // CS=1
  FT_Out_Buffer[4] := lastval;

  Write_USB_Device_Buffer(5);


end;

procedure SPI_ProgramByte(addr: integer; data: byte);
var
  PortStatus,
  i: integer;
  r: byte;
begin
  lastval := lastval and $35; // CS=0
  FT_Out_Buffer[0] := lastval;
  FT_Out_Buffer[1] := $81;    //
  FT_Out_Buffer[2] := bitswap(06);  // WREN
  lastval := lastval or $08;  // CS=1
  FT_Out_Buffer[3] := lastval;
  //
  lastval := lastval and $35; // CS=0
  FT_Out_Buffer[4] := lastval;
  FT_Out_Buffer[5] := $85;    //
  FT_Out_Buffer[6] := bitswap(02);  // Program byte
  FT_Out_Buffer[7] := bitswap(addr shr 16);  //
  FT_Out_Buffer[8] := bitswap(addr shr 8);  //
  FT_Out_Buffer[9] := bitswap(addr);  //
  FT_Out_Buffer[10] := bitswap(data);  // send
  lastval := lastval or $08;  // CS=1
  FT_Out_Buffer[11] := lastval;

  Write_USB_Device_Buffer(12);
end;

procedure SPI_ProgramPageBuffer(addr: integer);
var
  i, j: integer;
  status: byte;
begin
  //
  if Feature_PP then
  begin
    if use_MPSSE then
    begin
       // WREN
       // 02 ADDR
       // 256
       // poll status


      Init_MPSSE;

      // WREN
      OutIndex := 0;
      Out_Buff[0] := $06;
      Set_CS_Low;
      ScanOut(8,@Out_Buff);
      Set_CS_High;

      // WR Status 1, 00
      Out_Buff[0] := $01;
      Out_Buff[1] := $00;
      Set_CS_Low;
      ScanOut(16,@Out_Buff);
      Set_CS_High;


      // WREN
      Out_Buff[0] := $06;
      Set_CS_Low;
      ScanOut(8,@Out_Buff);
      Set_CS_High;


      // page program
      Out_Buff[0] := $02; //90;
      Out_Buff[1] := addr shr 16;
      Out_Buff[2] := addr shr 8;
      Out_Buff[3] := addr;

      for I := 0 to 256-1 do
        begin
          Out_Buff[4+i] := PageBuffer[i];
        end;


      Set_CS_Low;
      ScanOut(8*(256+4),@Out_Buff);
      Set_CS_High;

      AddToBuffer($87);
      SendBytes(OutIndex); // send off the command


    end else begin

      ftdi_flush;
      ftdi_cache := true;

      lastval           := lastval and $35; // CS=0
      FT_Out_Buffer[0]  := lastval;
      FT_Out_Buffer[1]  := $81;    //
      FT_Out_Buffer[2]  := bitswap(06);  // WREN
      lastval           := lastval or $08;  // CS=1
      FT_Out_Buffer[3]  := lastval;

      j := 8;
      lastval := lastval and $35; // CS=0
      FT_Out_Buffer[4] := lastval;
      FT_Out_Buffer[5] := $80+4+j;    //
      FT_Out_Buffer[6] := bitswap(02);  // Program byte
      FT_Out_Buffer[7] := bitswap(addr shr 16);  //
      FT_Out_Buffer[8] := bitswap(addr shr 8);  //
      FT_Out_Buffer[9] := bitswap(addr);  //
      //
      for I := 0 to j-1 do
        begin
          FT_Out_Buffer[10+i] := bitswap(PageBuffer[i]);
        end;
      Write_USB_Device_Buffer(10+j);
      // xx bytes sent


      FT_Out_Buffer[0] := $80+62;    //
      for I := 0 to 62-1 do
        begin
          FT_Out_Buffer[1+i] := bitswap(PageBuffer[j+i]);
        end;
      Write_USB_Device_Buffer(1+62);
      j := j + 62;
      // xx + 62

      FT_Out_Buffer[0] := $80+62;    //
      for I := 0 to 62-1 do
        begin
          FT_Out_Buffer[1+i] := bitswap(PageBuffer[j+i]);
        end;
      Write_USB_Device_Buffer(1+62);
      j := j + 62;
      // xx + 62 + 62

      FT_Out_Buffer[0] := $80+62;    //
      for I := 0 to 62-1 do
        begin
          FT_Out_Buffer[1+i] := bitswap(PageBuffer[j+i]);
        end;
      Write_USB_Device_Buffer(1+62);
      j := j + 62;
      // xx + 62 + 62 + 62

      FT_Out_Buffer[0] := $80+62;    //
      for I := 0 to 62-1 do
        begin
          FT_Out_Buffer[1+i] := bitswap(PageBuffer[j+i]);
        end;
      Write_USB_Device_Buffer(1+62);
      j := j + 62;
      // xx + 62 + 62 + 62 + 62

      // CS=0
      //lastval := lastval or $08;  // CS=1
      //FT_Out_Buffer[0] := lastval;
      //Write_USB_Device_Buffer(0+1);
      spi_CS(1);

      // wait
      repeat
      until (SPI_Status and 1)=0;


    end;
  end else begin
    for i := 0 to PageSize - 1 do
    begin
      SPI_ProgramByte(addr + i, PageBuffer[i]);
    end;
  end;
end;


procedure spi_cmd3(cmd: byte; addr: cardinal);
var
  PortStatus,
  i: integer;
  r: byte;
begin
      // WR
  if use_MPSSE then
  begin

    Init_MPSSE;

      OutIndex := 0;

      Out_Buff[0] := cmd;
      Out_Buff[1] := addr shr 16;
      Out_Buff[2] := addr shr 8;
      Out_Buff[3] := addr;

      Set_CS_Low;
      ScanOut(32,@Out_Buff);
      Set_CS_High;

      AddToBuffer($87);
      SendBytes(OutIndex); // send off the command
  end;
      exit;

  // CS = 0
//  spi_CS(0);

//  lastval := lastval or $20; // enable ext bus!
  if InternalFlash then lastval := lastval and $DF else lastval := lastval or $20;

  lastval := lastval and $35;
  //if value<>0 then lastval := lastval or $08;

  FT_Out_Buffer[0] := lastval;

  // Send CMD
  FT_Out_Buffer[1] := $84;    //
  FT_Out_Buffer[2] := bitswap(cmd);  // send

  //  Write_USB_Device_Buffer(2);
// Send Addr
//  spi_xmit(addr shr 16);
//  spi_xmit(addr shr 8);
//  spi_xmit(addr);
  FT_Out_Buffer[3] := bitswap(addr shr 16);  //
  FT_Out_Buffer[4] := bitswap(addr shr 8);  //
  FT_Out_Buffer[5] := bitswap(addr);  //

  Write_USB_Device_Buffer(6);
end;

function spi_rd8(value: byte): byte;
var
  PortStatus,
  i: integer;
  r: byte;
begin
  FT_Out_Buffer[0] := $C8;    // send 8 bits
  FT_Out_Buffer[1] := bitswap(value);  // send
  FT_Out_Buffer[2] := bitswap(value);  // send
  FT_Out_Buffer[3] := bitswap(value);  // send
  FT_Out_Buffer[4] := bitswap(value);  // send
  FT_Out_Buffer[5] := bitswap(value);  // send
  FT_Out_Buffer[6] := bitswap(value);  // send
  FT_Out_Buffer[7] := bitswap(value);  // send
  FT_Out_Buffer[8] := bitswap(value);  // send

  Write_USB_Device_Buffer(9);
  Read_USB_Device_Buffer(8);
end;

function spi_rd16(value: byte): byte;
var
  PortStatus,
  i: integer;
  r: byte;
begin
  FT_Out_Buffer[0] := $D0;    // send 8 bits
  for i := 1 to 16 do FT_Out_Buffer[i] := bitswap(value);  // send

  Write_USB_Device_Buffer(16+1);
  Read_USB_Device_Buffer(16);
end;

function spi_rd32(value: byte): byte;
var
  PortStatus,
  i: integer;
  r: byte;
begin
  FT_Out_Buffer[0] := $E0;    // send 8 bits
  for i := 1 to 32 do FT_Out_Buffer[i] := bitswap(value);  // send

  Write_USB_Device_Buffer(32+1);
  Read_USB_Device_Buffer(32);
end;

function spi_rd62(value: byte): byte;
var
  PortStatus,
  i: integer;
  r: byte;
begin
  FT_Out_Buffer[0] := $FE;    // send 62
  for i := 1 to 62 do
    FT_Out_Buffer[i] := bitswap(value);  // send

  Write_USB_Device_Buffer(62+1);
  Read_USB_Device_Buffer(62);
end;

function spi_rq8(value: byte): byte;
var
  PortStatus,
  i: integer;
  r: byte;
begin
  FT_Out_Buffer[0] := $C8;    // send 8 bits
  for i := 1 to 8 do FT_Out_Buffer[i] := bitswap(value);  // send
  Write_USB_Device_Buffer(9);
end;


function spi_rq16(value: byte): byte;
var
  PortStatus,
  i: integer;
  r: byte;
begin
  FT_Out_Buffer[0] := $D0;    // send 8 bits
  for i := 1 to 16 do FT_Out_Buffer[i] := bitswap(value);  // send
  Write_USB_Device_Buffer(9+8);
end;

function spi_rq32(value: byte): byte;
var
  PortStatus,
  i: integer;
  r: byte;
begin
  FT_Out_Buffer[0] := $E0;    // send 8 bits
  for i := 1 to 32 do FT_Out_Buffer[i] := bitswap(value);  // send
  Write_USB_Device_Buffer(1+32);
end;

function spi_rq62(value: byte): byte;
var
  PortStatus,
  i: integer;
  r: byte;
begin
  FT_Out_Buffer[0] := $FE;    // send 62
  for i := 1 to 62 do FT_Out_Buffer[i] := bitswap(value);  // send
  Write_USB_Device_Buffer(1+62);
end;

procedure spi_tx8;
var
  PortStatus,
  i: integer;
  r: byte;
begin
  FT_Out_Buffer[0] := $88;    //
//  for i := 1 to 16 do FT_Out_Buffer[i] := bitswap(PageBuffer[i-1]);  // send
  Write_USB_Device_Buffer(8+1);
end;


procedure spi_tx16;
var
  PortStatus,
  i: integer;
  r: byte;
begin
  FT_Out_Buffer[0] := $90;    //
//  for i := 1 to 16 do FT_Out_Buffer[i] := bitswap(PageBuffer[i-1]);  // send
  Write_USB_Device_Buffer(16+1);
end;

procedure spi_tx32;
var
  PortStatus,
  i: integer;
  r: byte;
begin
  FT_Out_Buffer[0] := $A0;    //
//  for i := 1 to 32 do FT_Out_Buffer[i] := bitswap(PageBuffer[i-1]);  // send
  Write_USB_Device_Buffer(32+1);
end;

procedure spi_tx62;
var
  PortStatus,
  i: integer;
  r: byte;
begin
  FT_Out_Buffer[0] := $BE;    //
//  for i := 1 to 62 do FT_Out_Buffer[i] := bitswap(PageBuffer[i-1]);  // send
  Write_USB_Device_Buffer(62+1);
end;

function JEDEC_ID_READ: cardinal;
var
  st: byte;
begin
//  lastval := $20;
//  lastval := $0;

  if use_MPSSE then begin
    result := Read_JEDEC;
  end else begin



    Purge_USB_Device_Out;
    Purge_USB_Device_In;

    spi_CS(1);
    spi_MOSI(1);

    // mode 3
    spi_SCL(0);
    spi_CS(0);
    spi_SCL(0);

    spi_xfer($9F);
    result := 0;
    result := result or spi_xfer($ff); result := result shl 8;
    result := result or spi_xfer($ff); result := result shl 8;
    result := result or spi_xfer($ff);
    spi_CS(1);

  end;
end;


function DF_Identify: cardinal;
var
  st: byte;
begin

  DF_has_stat2 := false;

  IsDataflash := false;
  Feature_PP := false;
  Feature_AAI := false;
  PageSize := 256;

  if use_MPSSE then
  begin
    result := Read_JEDEC;
    JEDEC_ID := result;

  end else begin

    Purge_USB_Device_Out;
    Purge_USB_Device_In;

    spi_CS(1);
    spi_SCL(0);
    spi_SCL(1);  spi_SCL(0);
    spi_SCL(1);  spi_SCL(0);
    spi_MOSI(1);

    // mode 3
    spi_SCL(0);
    spi_CS(0);
    spi_SCL(0);

    spi_xfer($9F);
    result := 0;
    result := result or spi_xfer($ff); result := result shl 8;
    result := result or spi_xfer($ff); result := result shl 8;
    result := result or spi_xfer($ff);
    JEDEC_ID := result;
    spi_CS(1);
  end;





  if result = $1F2600 then begin
    IsDataflash := true;

    DF_has_stat2 := true;

    PageCount := 4096;
    PageSize := 512;
  end;

  if result = $11F2600 then begin
    IsDataflash := true;

    PageCount := 4096;
    PageSize := 512;
  end;

  if result=$1F2500 then begin
    IsDataflash := true;

    PageCount := 4096;
    PageSize := 256;
  end;

  if result = $BF2541 then begin

    PageCount := 1024*4*2;
    PageSize := 256;
    Feature_AAI := true;
  end;

  if result = $EF4015 then begin
    PageCount := 1024*4*2;
    PageSize := 256;
    Feature_PP := true;
  end;

  if result = $7F9D14 then begin
    PageCount := 1024*4*2;
    PageSize := 256;
    Feature_PP := true;
  end;

  if result = $7F9D13 then begin
    PageCount := 1024*4;
    PageSize := 256;
    Feature_PP := true;
  end;
  // ESMT F25L004A
  if result = $8C2013 then begin
    PageCount := 512*4;
    PageSize := 256;
    Feature_AAI := true;
  end;

  // S25FL127S
  if result = $4D012018 then begin
    PageCount := 16*1024*4;
    PageSize := 256;
    Feature_PP := true;
  end;



  DetectWithJEDEC(JEDEC_ID);

  PageOffset := PageSize;
  if IsDataflash then
  begin
    st := DF_Status;
    if (st and $01)=0 then
    begin
      PageOffset := PageSize*2;
      if PageSize=256 then
        PageSize := 264 else
        PageSize := 528;
    end else
    begin
      PageOffset := PageSize;
    end;
  end;

end;

function DF_Identify2: cardinal;
var
  st: byte;
begin
//  lastval := $20;
//  lastval := $0;

  if use_MPSSE then
  begin
    result := DF_Identify;
    exit;
  end;

  Purge_USB_Device_Out;
  Purge_USB_Device_In;

  spi_CS(1);
  spi_MOSI(1);

  // mode 3
  spi_SCL(0);
  spi_CS(0);
  spi_SCL(0);

  spi_xfer($AB);
  spi_xfer($ff);
  spi_xfer($ff);
  spi_xfer($ff);

  result := 0;
  result := result or spi_xfer($ff); result := result shl 8;
  result := result or spi_xfer($ff); result := result shl 8;
  result := result or spi_xfer($ff); result := result shl 8;
  result := result or spi_xfer($ff);
  spi_CS(1);

  if result = $1F260000 then begin
    PageCount := 4096;
    PageSize := 512;
  end;
  if result=$1F250000 then begin
    PageCount := 4096;
    PageSize := 256;
  end;

  st := DF_Status;

  if (st and $01)=0 then
  begin
    PageOffset := PageSize*2;
    if PageSize=256 then
      PageSize := 264 else
      PageSize := 528;
  end else
  begin
    PageOffset := PageSize;
  end;

end;

function SPI_Status: byte;
begin
  if use_MPSSE then begin
     result := Read_STATUS;




  end else begin

  //  SPI_SCL(1);
    ftdi_flush;

    lastval := lastval or $20;
    lastval := lastval and $35;

    FT_Out_Buffer[0] := lastval; // CS = 0
    FT_Out_Buffer[1] := $81; // 1 byte
    FT_Out_Buffer[2] := bitswap($05);

    FT_Out_Buffer[3] := $C1; // 1 byte read
    FT_Out_Buffer[4] := $FF;
    lastval := lastval or $08;
    FT_Out_Buffer[5] := lastval; // CS = 1
    //
    Write_USB_Device_Buffer(6);
    Read_USB_Device_Buffer(1);

    result := bitswap(FT_In_Buffer[0]);
  end;
end;

function SPI_Status2: byte;
var
  st: byte;
begin
 if use_MPSSE then begin
     result := Read_STATUS;




  end else begin


  Purge_USB_Device_Out;
  Purge_USB_Device_In;

  spi_CS(1);
  spi_MOSI(1);

  // mode 3
  spi_SCL(1);
  spi_CS(0);
  spi_SCL(0);

  spi_xmit($05);
  result := spi_xfer($ff);
  spi_CS(1);

  end;
end;

function DF_Status: byte;
begin
  if use_MPSSE then
  begin

    Init_MPSSE;

    result := 0;
    OutIndex := 0;
    Out_Buff[0] := $D7; //
    Set_CS_Low;
    ScanOut(8,@Out_Buff);
    ScanIn(8*1);
    Set_CS_High;
    AddToBuffer($87);
    SendBytes(OutIndex); // send off the command
    Read_Data(@In_Buff,8*1);
    result := In_Buff[0];


  end else begin
    if InternalFlash then lastval := lastval and $DF else lastval := lastval or $20;

    lastval := lastval and $35;

    FT_Out_Buffer[0] := lastval; // CS = 0
    FT_Out_Buffer[1] := $81; // 1 byte
    FT_Out_Buffer[2] := bitswap($D7);

    FT_Out_Buffer[3] := $C1; // 1 byte read
    FT_Out_Buffer[4] := $FF;
    lastval := lastval or $08;
    FT_Out_Buffer[5] := lastval; // CS = 1
    //
    Write_USB_Device_Buffer(6);
    Read_USB_Device_Buffer(1);

    result := bitswap(FT_In_Buffer[0]);
  end;
end;

function DF_Status2: byte;
begin

  if use_MPSSE then
  begin
    if not DF_has_stat2 then
    begin
      result := DF_STatus;
      exit;
    end;

    Init_MPSSE;

    result := 0;
    OutIndex := 0;
    Out_Buff[0] := $D7; //
    Set_CS_Low;
    ScanOut(8,@Out_Buff);
    ScanIn(8*2);
    Set_CS_High;
    AddToBuffer($87);
    SendBytes(OutIndex); // send off the command
    Read_Data(@In_Buff,8*2);
    result := In_Buff[1];


  end else begin
    if InternalFlash then lastval := lastval and $DF else lastval := lastval or $20;

    lastval := lastval and $35;

    FT_Out_Buffer[0] := lastval; // CS = 0
    FT_Out_Buffer[1] := $81; // 1 byte
    FT_Out_Buffer[2] := bitswap($D7);

    FT_Out_Buffer[3] := $C1; // 1 byte read
    FT_Out_Buffer[4] := $FF;
    lastval := lastval or $08;
    FT_Out_Buffer[5] := lastval; // CS = 1
    //
    Write_USB_Device_Buffer(6);
    Read_USB_Device_Buffer(1);

    result := bitswap(FT_In_Buffer[0]);
  end;



  exit;

//  spi_CS(0);
//  spi_xmit($D7);
//  result := spi_xfer($ff);
//  spi_CS(1);

//  lastval := lastval or $20; // enable ext bus!
  if InternalFlash then lastval := lastval and $DF else lastval := lastval or $20;

  lastval := lastval and $37;

  FT_Out_Buffer[0] := lastval; // CS = 0
  FT_Out_Buffer[1] := $83; // 1 byte
  FT_Out_Buffer[2] := bitswap($D7);
  FT_Out_Buffer[3] := bitswap($FF);
  FT_Out_Buffer[4] := bitswap($FF);

  FT_Out_Buffer[5] := bitswap($FF);
  FT_Out_Buffer[6] := bitswap($FF);

  FT_Out_Buffer[7] := bitswap($FF);
  FT_Out_Buffer[8] := bitswap($FF);
  FT_Out_Buffer[9] := bitswap($FF);
  FT_Out_Buffer[10] := bitswap($FF);

  FT_Out_Buffer[4] := $C1; // 1 byte read
  FT_Out_Buffer[5] := $FF;
  lastval := lastval or $08;
  FT_Out_Buffer[6] := lastval; // CS = 1
  //
  Write_USB_Device_Buffer(7);
  Read_USB_Device_Buffer(1);

  result := bitswap(FT_In_Buffer[0]);
end;

procedure DF_Powerdown;
begin
  spi_CS(0);
  spi_xmit($B9);
  spi_CS(1);
end;

procedure DF_Wakeup;
begin
  spi_CS(0);
  spi_xfer($AB);
  spi_CS(1);
end;


procedure BL_Reset;
var
  i: integer;
begin
  if use_MPSSE then Exit;


  lastval := 0;
  InternalFlash := false;
  ftdi_cache := false;

  FT_Out_Buffer[0] := 0;
  for I := 0 to 64 - 1 do
    Write_USB_Device_Buffer( 1 );

  Purge_USB_Device_Out;
  Purge_USB_Device_In;

//  lastval := $20; // ?
//  spi_CS(1);
  ftdi_numb := 0;
//  ftdi_cache := true;

end;

procedure DF_ReadSecurityPage;
var
  i, j: integer;
begin
  spi_cmd3($77, 0);

  for i := 0 to 4 - 1 do
  begin
    spi_rd32($FF);
    for j := 0 to 31 do
      PageBuffer[i*32+j] := bitswap(FT_In_Buffer[j]);
  end;

  spi_CS(1);
end;

procedure DF_ReadPage(addr: cardinal);
var
  i, j: integer;
  passed : boolean;
begin
  if use_MPSSE then
  begin
    Init_MPSSE;


    OutIndex := 0;

    Out_Buff[0] := $03; //90;
    Out_Buff[1] := (addr*PageOffset) shr 16;
    Out_Buff[2] := (addr*PageOffset) shr 8;
    Out_Buff[3] := (addr*PageOffset);
    //Out_Buff[4] := $0;

    passed := Set_CS_Low;
    passed := ScanOut(32,@Out_Buff);


    passed := ScanIn(8*PageSize);
    passed := Set_CS_High;

    AddToBuffer($87);
    SendBytes(OutIndex); // send off the command

    Read_Data(@PageBuffer,8*PageSize);

    //


  end else begin

    spi_cmd3($03, addr*PageOffset);

    if PageSize>=512 then
    begin
      for i := 0 to 8 - 1 do
      begin
        spi_rq62($FF);
      end;
    end else begin
      for i := 0 to 4 - 1 do
      begin
        spi_rq62($FF);
      end;
    end;

    if PageSize=256 then
    begin
      spi_rq8($FF);
      Read_USB_Device_Buffer(256);
      for j := 0 to 256-1 do PageBuffer[j] := bitswap(FT_In_Buffer[j]);
    end;

    if PageSize=264 then
    begin
      spi_rq16($FF);
      Read_USB_Device_Buffer(264);
      for j := 0 to 264-1 do PageBuffer[j] := bitswap(FT_In_Buffer[j]);
    end;

    if PageSize=512 then
    begin
      spi_rq16($FF);
      Read_USB_Device_Buffer(512);
      for j := 0 to 512-1 do PageBuffer[j] := bitswap(FT_In_Buffer[j]);
    end;

    if PageSize=528 then
    begin
      spi_rq32($FF);
      Read_USB_Device_Buffer(528);
      for j := 0 to 528-1 do PageBuffer[j] := bitswap(FT_In_Buffer[j]);
    end;

    spi_CS(1);

  end;

end;

procedure DF_ReadPageBuffer(buf: integer);
var
  i, j: integer;
begin
  if buf=0 then spi_cmd3($D1, 0) else spi_cmd3($D6, 0);

  if PageSize>=512 then
  begin
    for i := 0 to 8 - 1 do
    begin
      spi_rq62($FF);
    end;
  end else begin
    for i := 0 to 4 - 1 do
    begin
      spi_rq62($FF);
    end;
  end;

  if PageSize=256 then
  begin
    spi_rq8($FF);
    Read_USB_Device_Buffer(256);
    for j := 0 to 256-1 do PageBuffer[j] := bitswap(FT_In_Buffer[j]);
  end;

  if PageSize=264 then
  begin
    spi_rq16($FF);
    Read_USB_Device_Buffer(264);
    for j := 0 to 264-1 do PageBuffer[j] := bitswap(FT_In_Buffer[j]);
  end;

  if PageSize=512 then
  begin
    spi_rq16($FF);
    Read_USB_Device_Buffer(512);
    for j := 0 to 512-1 do PageBuffer[j] := bitswap(FT_In_Buffer[j]);
  end;

  if PageSize=528 then
  begin
    spi_rq32($FF);
    Read_USB_Device_Buffer(528);
    for j := 0 to 528-1 do PageBuffer[j] := bitswap(FT_In_Buffer[j]);
  end;

  spi_CS(1);
end;

procedure DF_WritePageBuffer(buf: integer);
var
  i, j: integer;
begin

  if use_MPSSE then
  begin
      if buf=0 then Out_Buff[0] := $84 else Out_Buff[0] := $87;
      Out_Buff[1] := 0;
      Out_Buff[2] := 0;
      Out_Buff[3] := 0;

      for I := 0 to PageSize-1 do
        begin
          Out_Buff[4+i] := PageBuffer[i];
        end;

      Set_CS_Low;
      ScanOut(8*(PageSize+4),@Out_Buff);
      Set_CS_High;

      AddToBuffer($87);
      SendBytes(OutIndex); // send off the command


  end else begin

    if buf=0 then spi_cmd3($84, 0) else spi_cmd3($87, 0);


    if PageSize>=512 then
    begin
      for i := 0 to 8 - 1 do
      begin
        for j := 0 to 62-1 do FT_Out_Buffer[j+1] := bitswap(PageBuffer[i*62+j]);
        spi_tx62;
      end;
    end else begin
      for i := 0 to 4 - 1 do
      begin
        for j := 0 to 62-1 do FT_Out_Buffer[j+1] := bitswap(PageBuffer[i*62+j]);
        spi_tx62;
      end;
    end;

    if PageSize=256 then
    begin
      for j := 0 to 8-1 do FT_Out_Buffer[j+1] := bitswap(PageBuffer[4*62+j]);
      spi_tx8;
    end;

    if PageSize=264 then
    begin
      for j := 0 to 16-1 do FT_Out_Buffer[j+1] := bitswap(PageBuffer[4*62+j]);
      spi_tx16;
    end;

    if PageSize=512 then
    begin
      for j := 0 to 16-1 do FT_Out_Buffer[j+1] := bitswap(PageBuffer[8*62+j]);
      spi_tx16;
    end;

    if PageSize=528 then
    begin
      for j := 0 to 32-1 do FT_Out_Buffer[j+1] := bitswap(PageBuffer[8*62+j]);
      spi_tx32;
    end;

    spi_CS(1);

  end;

end;

procedure DF_TransferPageBuffer(buf: integer; addr: integer);
var
  i, j: integer;
  status: byte;
begin
  if buf=0 then spi_cmd3($53, addr*PageOffset) else spi_cmd3($55, addr*PageOffset);
  spi_CS(1);

//  status := DF_Status;
//  if (status and $80)=0 then status := DF_Status;
end;

function DF_ComparePageBuffer(buf: integer; addr: integer): boolean;
var
  i, j: integer;
  status: byte;
begin
  result := false;

  if use_MPSSE then
  begin

      if buf=0 then Out_Buff[0] := $60 else Out_Buff[0] := $61;

      Out_Buff[1] := (addr*PageOffset) shr 16;
      Out_Buff[2] := (addr*PageOffset) shr 8;
      Out_Buff[3] := (addr*PageOffset);

      Set_CS_Low;
      ScanOut(8*4,@Out_Buff);
      Set_CS_High;

      AddToBuffer($87);
      SendBytes(OutIndex); // send off the command



  end else begin
    //Buffer compare
    if buf=0 then spi_cmd3($60, addr*PageOffset) else spi_cmd3($61, addr*PageOffset);
    spi_CS(1);
  end;

  //  status := DF_Status2;
  status := DF_Status;
  while (status and $80)=0 do status := DF_Status;

  if (status and $80)=0 then exit;
  if (status and $40)=0 then result := true;

end;



procedure DF_ProgramPageBuffer(buf: integer; addr: integer);
var
  i, j: integer;
  status: byte;
begin
  if buf=0 then spi_cmd3($88, addr*PageOffset) else spi_cmd3($89, addr*PageOffset);
  spi_CS(1);

//  status := DF_Status;
//  if (status and $80)=0 then status := DF_Status;
end;

procedure DF_ProgramWithErasePageBuffer(buf: integer; addr: integer);
var
  i, j: integer;
  status: byte;
begin
  if use_MPSSE then
  begin

      if buf=0 then Out_Buff[0] := $83 else Out_Buff[0] := $86;

      Out_Buff[1] := (addr*PageOffset) shr 16;
      Out_Buff[2] := (addr*PageOffset) shr 8;
      Out_Buff[3] := (addr*PageOffset);

      for I := 0 to PageSize-1 do
        begin
          Out_Buff[4+i] := PageBuffer[i];
        end;

      Set_CS_Low;
      ScanOut(8*(PageSize+4),@Out_Buff);
      Set_CS_High;

      AddToBuffer($87);
      SendBytes(OutIndex); // send off the command

  end else begin
    if buf=0 then spi_cmd3($83, addr*PageOffset) else spi_cmd3($86, addr*PageOffset);
    spi_CS(1);
  end;


//  status := DF_Status;
//  if (status and $80)=0 then status := DF_Status;
end;

procedure DF_ErasePage(addr: cardinal);
begin
  if use_MPSSE then
  begin

      Out_Buff[0] := $81;

      Out_Buff[1] := (addr*PageOffset) shr 16;
      Out_Buff[2] := (addr*PageOffset) shr 8;
      Out_Buff[3] := (addr*PageOffset);

      Set_CS_Low;
      ScanOut(8*4,@Out_Buff);
      Set_CS_High;

      AddToBuffer($87);
      SendBytes(OutIndex); // send off the command



  end else begin
    spi_cmd3($81, addr*PageOffset);
    spi_CS(1);
  end;


end;

procedure SPI_ChipErase;
begin
  spi_cmd($06); // WREN
  spi_cmd($C7); // ChipErase

end;

///////////////////////
///
///
///

procedure ee_CS(value: integer);
begin
  lastval := lastval and $17;
  if value<>0 then lastval := lastval or $08;

  //FT_Out_Buffer[0] := lastval;
  //Write_USB_Device_Buffer(1);

  ftdi_xmit(lastval);
end;

function ee_MISO: integer;
begin
  lastval := lastval or $40; // echo bit
  FT_Out_Buffer[0] := lastval;
  Write_USB_Device_Buffer(1);

  Read_USB_Device_Buffer(1);

  result := (FT_In_Buffer[0] shr 1) and $01;

  lastval := lastval and $1F;
end;

procedure ee_MOSI(value: integer);
begin
  lastval := lastval and $0F;
  if value<>0 then lastval := lastval or $10;

//  FT_Out_Buffer[0] := lastval;
//  Write_USB_Device_Buffer(1);
  ftdi_xmit(lastval);
end;

procedure ee_SCL(value: integer);
begin
  lastval := lastval and $1E;
  if value<>0 then lastval := lastval or $01;

//  FT_Out_Buffer[0] := lastval;
//  Write_USB_Device_Buffer(1);

  ftdi_xmit(lastval);
end;

function ee_readbyte: byte;
var
  i: integer;
  b: byte;
begin
  for i := 0 to 8 - 1 do
  begin
    ee_SCL(1); ee_SCL(0);
    b := b shl 1;
    b := b or (ee_MISO and 1);
//    ee_SCL(1); ee_SCL(0);
  end;
  result := b;
end;

procedure ee_writebyte(value: byte);
var
  i: integer;
  b: byte;
begin
  for i :=  8 - 1 downto 0 do
  begin
    ee_MOSI((value shr i) and 1);  ee_SCL(1); ee_SCL(0);
  end;
end;

procedure ee_cmd(value: integer; addr: integer);
var
  i: integer;
begin
  ee_CS(0); ee_SCL(0);
  ee_MOSI(1);
  // select
  ee_CS(1);
  // SB
  ee_SCL(1); ee_SCL(0);
  // send 2 bits command
  ee_MOSI((value shr 1) and 1);  ee_SCL(1); ee_SCL(0);
  ee_MOSI( value        and 1);  ee_SCL(1); ee_SCL(0);
  // send addr

  for i := EE_AddrBits - 1 downto 0 do
  begin
    ee_MOSI((addr shr i) and 1);
    ee_SCL(1); ee_SCL(0);
  end;
  ee_MOSI(0);

//  ee_CS(0);

end;

procedure ee_ERASE(addr: integer);
begin
  ee_cmd(3, addr);
  ee_CS(0);
end;

procedure ee_ERAL;
begin
  ee_cmd(0, 2 shl (EE_AddrBits-2));
  ee_CS(0);
end;

procedure ee_EWDS;
begin
  ee_cmd(0, 0 shl (EE_AddrBits-2));
  ee_CS(0);
end;

procedure ee_EWEN;
begin
  ee_cmd(0, 3 shl (EE_AddrBits-2));
  ee_CS(0);
end;

function ee_READ(addr: integer): byte;
begin
  ee_cmd(2, addr);

  result := ee_readbyte;

  ee_CS(0);
end;

procedure ee_WRITE(value: byte; addr: integer);
begin
  ee_cmd(1, addr);

  // write data!
  ee_writebyte(value);

  ee_CS(0);
end;

procedure ee_WRAL(value: byte);
begin
  ee_cmd(0, 1 shl (EE_AddrBits-2));

  // write data!
  ee_writebyte(value);

  ee_CS(0);
end;

procedure ee_ReadBuffer;
var
  i: integer;
begin

  for I := 0 to EE_Size-1 do
  begin
    ee_cmd(2, i);
    BigBuffer[i] := ee_readbyte;
    ee_CS(0);
  end;

end;

procedure ee_WriteBuffer;
var
  i: integer;
begin
  for I := 0 to EE_Size-1 do
  begin
    ee_EWEN;
    ee_WRITE(BigBuffer[i], I );
    ee_BUSY;
  end;
end;

procedure ee_BUSY;
begin
  Repeat

  Until ee_MISO<>0;
end;

procedure mcu_BYTE(value: byte);
begin
  ftdi_xfer((value shr 4) and $0F);
  ftdi_xfer(value and $0F);
end;

procedure mcu_ADDR(addr: integer);
begin
  mcu_BYTE(addr shr 8);
  ftdi_xfer($1D);

  mcu_BYTE(addr);
  ftdi_xfer($1C);
end;

procedure mcu_ADDR8(addr: integer);
begin
  mcu_BYTE(addr);
  ftdi_xfer($1C);
end;

function mcu_READ: byte;
begin
  result := ftdi_xfer($1E);
end;

procedure mcu_WRITE(value: byte);
begin
  mcu_BYTE(value);
  ftdi_xfer($1F);
end;

function mcu_CALL: byte;
begin
//  ftdi_xfer($1E);
  FT_Out_Buffer[0] := $18;
  Write_USB_Device_Buffer(1);
  //
  result := 0;
end;

procedure mcu_DIS;
begin
//  ftdi_xfer($1E);
  FT_Out_Buffer[0] := $19;
  Write_USB_Device_Buffer(1);
end;

procedure mcu_EN;
begin
  spi_SHADOW($04);
  spi_SHADOW($00);
end;

procedure spi_SHADOW(value: byte);
begin
  SPI_CS(1);

  SPI_CS(0);
  spi_xmit($AB);
  spi_xmit($FF);
  spi_xmit($FF);
  spi_xmit($FF);
  SPI_CS(1);

  SPI_CS(0);
  spi_xmit($AB);
  spi_xmit($00);
  spi_xmit($00);
  spi_xmit(value);
  SPI_CS(1);
end;

procedure DF_Blow512;
begin
  SPI_CS(0);
  spi_xmit($3D);
  spi_xmit($2A);
  spi_xmit($80);
  spi_xmit($A6);
  SPI_CS(1);
end;

function ftdi_result: byte;
begin
  ftdi_flush;

  Read_USB_Device_Buffer(1);
  result := FT_In_Buffer[0];
end;

function ftdi_xfer(value: byte): byte;
begin
  ftdi_flush;
  FT_Out_Buffer[0] := value;
  Write_USB_Device_Buffer(1);
  //
  //Read_USB_Device_Buffer(1);
  //result := FT_In_Buffer[0];

  result := ftdi_result;
end;

procedure ftdi_xmit(value: byte);
begin
  if ftdi_cache then
  begin
    if ftdi_numb > 62 then ftdi_flush;

    FT_Out_Buffer[ftdi_numb] := value;
    ftdi_numb := ftdi_numb + 1;
  end else begin
    FT_Out_Buffer[0] := value;
    Write_USB_Device_Buffer(1);
  end;
end;

procedure ftdi_flush;
begin
  //
  if ftdi_numb > 0 then
    Write_USB_Device_Buffer(ftdi_numb);

  ftdi_numb := 0;
end;

//
function ICE_RESET: boolean;
begin
  Init_MPSSE;

result := false;
if PortAIsOpen then
  begin
    if (CS_NUM=0) then
    begin
      Saved_Port_Value := Saved_Port_Value AND $77;
    end else begin
      Saved_Port_Value := Saved_Port_Value AND $6F;
    end;

    // CS Low, CRESETB low
    AddToBuffer($80); AddToBuffer(Saved_Port_Value); AddToBuffer($9B);
    AddToBuffer($80); AddToBuffer(Saved_Port_Value); AddToBuffer($9B);
    AddToBuffer($80); AddToBuffer(Saved_Port_Value); AddToBuffer($9B);
    SendBytes(OutIndex); // send off the command

    Saved_Port_Value := Saved_Port_Value OR $80;

    AddToBuffer($80); AddToBuffer(Saved_Port_Value); AddToBuffer($9B);
    AddToBuffer($80); AddToBuffer(Saved_Port_Value); AddToBuffer($9B);
    AddToBuffer($80); AddToBuffer(Saved_Port_Value); AddToBuffer($9B);

    SendBytes(OutIndex); // send off the command

    result := true;
  end;

end;


function ICE_CONFIG(size:integer): boolean;
begin
  ICE_RESET;

  ScanOut((size+10) * 8,@BigBuffer[0]);
  SendBytes(OutIndex); // send off the command

end;


function WS_TEST(r,g,b: byte): boolean;
var
  wsbuf: array[0 .. 1024*3] of byte;
  i: integer;

begin
  Init_MPSSE;

result := false;
if PortAIsOpen then
  begin
    Set_CS_Low;

    for i := 0 to 64 do
    begin
      wsbuf[i*3+0] := r;
      wsbuf[i*3+1] := g;
      wsbuf[i*3+2] := b;

      //r := r + 1;
      //g := g + 1;
      //b := b + 1;
    end;


    ScanOut(64*3 * 8,@wsbuf[0]);

    SendBytes(OutIndex); // send off the command

    Set_CS_High;

    result := true;
  end;

end;




end.
