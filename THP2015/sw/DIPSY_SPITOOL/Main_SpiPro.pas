unit Main_SpiPro;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ImgList, ToolWin, ComCtrls, StdCtrls, ExtCtrls, ActnList, Buttons, jpeg,
  StdActns, PlatformDefaultStyleActnCtrls, ActnMan, ActnCtrls, ActnMenus,
  ExtActns, System.Actions, Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    sb: TStatusBar;
    Panel1: TPanel;
    Timer1: TTimer;
    ActionMainMenuBar1: TActionMainMenuBar;
    BalloonHint1: TBalloonHint;
    Memo1: TMemo;
    ActionToolBar1: TActionToolBar;
    ActionManager1: TActionManager;
    FileOpen1: TFileOpen;
    FileSaveAs1: TFileSaveAs;
    FileExit1: TFileExit;
    actIdentify: TAction;
    actReadSecurityPage: TAction;
    actReadArray: TAction;
    actErase: TAction;
    actProgramArray: TAction;
    Action5: TAction;
    Action6: TAction;
    Action12: TAction;
    Action13: TAction;
    actCompareArray: TAction;
    actBlankCheck: TAction;
    Action16: TAction;
    Action18: TAction;
    Action17: TAction;
    Action19: TAction;
    actSCK0: TAction;
    actSCK1: TAction;
    actSEL0: TAction;
    actSEL1: TAction;
    actMOSI0: TAction;
    actMOSI1: TAction;
    actMISO: TAction;
    actMCUread: TAction;
    Action2: TAction;
    Action3: TAction;
    actMCUledOFF: TAction;
    actMCUledON: TAction;
    actMCUtest: TAction;
    actGetResult: TAction;
    actMCUactivate: TAction;
    actMCUdisable: TAction;
    browseOnlineHelp: TBrowseURL;
    actAbout: TAction;
    actAuto: TAction;
    ActionConfig: TAction;
    ActionReset: TAction;
    Image1: TImage;
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure FormShow(Sender: TObject);
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
    procedure FTPort_ConfigureExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FTQuitExecute(Sender: TObject);
    procedure FTResendExecute(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure actIdentifyExecute(Sender: TObject);
    procedure actReadSecurityPageExecute(Sender: TObject);
    procedure Action7Execute(Sender: TObject);
    procedure Action8Execute(Sender: TObject);
    procedure actReadArrayExecute(Sender: TObject);
    procedure actProgramArrayExecute(Sender: TObject);
    procedure actBlow512Execute(Sender: TObject);
    procedure FileSaveAs1Accept(Sender: TObject);
    procedure Action12Execute(Sender: TObject);
    procedure actCompareArrayExecute(Sender: TObject);
    procedure FileOpen1Accept(Sender: TObject);
    procedure actBlankCheckExecute(Sender: TObject);
    procedure actEraseExecute(Sender: TObject);
    procedure Action16Execute(Sender: TObject);
    procedure Action18Execute(Sender: TObject);
    procedure Action17Execute(Sender: TObject);
    procedure Action19Execute(Sender: TObject);
    procedure actEraseEEExecute(Sender: TObject);
    procedure actMCUledONExecute(Sender: TObject);
    procedure actMCUledOFFExecute(Sender: TObject);
    procedure actMCUreadExecute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure actMCUtestExecute(Sender: TObject);
    procedure actMCUactivateExecute(Sender: TObject);
    procedure actMCUdisableExecute(Sender: TObject);
    procedure actBOOT0Execute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
    procedure actMISOExecute(Sender: TObject);
    procedure Action10Execute(Sender: TObject);
    procedure sbDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure FormResize(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actAutoExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ud1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure ActionConfigExecute(Sender: TObject);
    procedure ActionResetExecute(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }

      DeviceIndex : DWord;
//    procedure ee_CS(value: integer);
//    procedure ee_SCL(value: integer);
//    procedure ee_MOSI(value: integer);
//    function  ee_MISO: integer;

//    procedure spi_CS(value: integer);
//    procedure spi_SCL(value: integer);
//    procedure spi_MOSI(value: integer);
//    function  spi_MISO: integer;
//    function  spi_xfer(value: byte): byte;

    procedure LoadMCS(filename: string);

    procedure Status(msg: string);
    procedure update_actions;
    procedure set_percent(last, value: integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  CfgUnit,D2XXUnit, TF_FTDI, JEDEC_SPI, AboutSpiPro;



{$R *.DFM}



procedure TForm1.FileOpen1Accept(Sender: TObject);
var
  F: TFileStream;
  ofs: cardinal;
begin
  //caption := FileSaveAs1.Dialog.FileName;
//  caption := 'SPiPro ['+FileOpen1.Dialog.FileName+']';

  Memo1.Lines.Add('DIPSY configuration: ' + FileOpen1.Dialog.FileName);

  fillchar(BigBuffer, SizeOf(BigBuffer), $FF);

  if (FileOpen1.Dialog.FilterIndex=1) or (FileOpen1.Dialog.FilterIndex=4) then
  begin
    F := TFileStream.Create(FileOpen1.Dialog.FileName, fmOpenRead);
    FileSize := F.Size;

    //F.Read(BigBuffer[4096], PageSize*PageCount);
    F.Read(BigBuffer, PageSize*PageCount);
    F.Free;
    //caption := 'loaded bin';
  end;

  if (FileOpen1.Dialog.FilterIndex=2)  or (FileOpen1.Dialog.FilterIndex=3) then
  begin
    LoadMCS(FileOpen1.Dialog.FileName);
    //caption := 'loaded hex';
  end;


//  F := TFileStream.Create('image2.bin', fmOpenRead);
//  F.Read(BigBuffer[$20000], PageSize*PageCount);
//  F.Free;
//
//  F := TFileStream.Create('image3.bin', fmOpenRead);
//  F.Read(BigBuffer[$40000], PageSize*PageCount);
//  F.Free;
//
//  F := TFileStream.Create('image4.bin', fmOpenRead);
//  F.Read(BigBuffer[$60000], PageSize*PageCount);
//  F.Free;

//  F := TFileStream.Create('image4.bin', fmOpenRead);
//  F.Read(BigBuffer[$80000], PageSize*PageCount);
//  F.Free;

  //FileSize := $A0000;

  exit;


  //FileSize := 512;



(*
0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f  10
7e aa 99 7e 92 00 30 01 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
7e aa 99 7e 92 00 00 44 03 00 10 00 82 00 00 01 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*)

  //
  BigBuffer[$00] := $7E;  BigBuffer[$01] := $AA;  BigBuffer[$02] := $99;  BigBuffer[$03] := $7E;
  BigBuffer[$04] := $92;  BigBuffer[$05] := $00;  BigBuffer[$06] := $30;
  BigBuffer[$07] := $01;  BigBuffer[$08] := $08;
  //
  // 0 02_0000
  ofs := $20;
  BigBuffer[ofs+$0] := $7E;  BigBuffer[ofs+$1] := $AA;  BigBuffer[ofs+$2] := $99;  BigBuffer[ofs+$3] := $7E;
  BigBuffer[ofs+$4] := $92;  BigBuffer[ofs+$5] := $00;  BigBuffer[ofs+$6] := $00;
  BigBuffer[ofs+$7] := $44;  BigBuffer[ofs+$8] := $03;

  BigBuffer[ofs+$9] := $02;  BigBuffer[ofs+$A] := $00;  BigBuffer[ofs+$B] := $00;
  //BigBuffer[ofs+$9] := $00;  BigBuffer[ofs+$A] := $10;  BigBuffer[ofs+$B] := $00;

  BigBuffer[ofs+$C] := $82;  BigBuffer[ofs+$D] := $00;  BigBuffer[ofs+$E] := $00;
  BigBuffer[ofs+$F] := $01;  BigBuffer[ofs+$10] := $08;

  // 1 04_0000
  ofs := $40;
  BigBuffer[ofs+$0] := $7E;  BigBuffer[ofs+$1] := $AA;  BigBuffer[ofs+$2] := $99;  BigBuffer[ofs+$3] := $7E;
  BigBuffer[ofs+$4] := $92;  BigBuffer[ofs+$5] := $00;  BigBuffer[ofs+$6] := $00;
  BigBuffer[ofs+$7] := $44;  BigBuffer[ofs+$8] := $03;

  //BigBuffer[ofs+$9] := $00;  BigBuffer[ofs+$A] := $10;  BigBuffer[ofs+$B] := $00;
  BigBuffer[ofs+$9] := $04;  BigBuffer[ofs+$A] := $00;  BigBuffer[ofs+$B] := $00;

  BigBuffer[ofs+$C] := $82;  BigBuffer[ofs+$D] := $00;  BigBuffer[ofs+$E] := $00;
  BigBuffer[ofs+$F] := $01;  BigBuffer[ofs+$10] := $08;

  // 2 06_0000
  ofs := $60;
  BigBuffer[ofs+$0] := $7E;  BigBuffer[ofs+$1] := $AA;  BigBuffer[ofs+$2] := $99;  BigBuffer[ofs+$3] := $7E;
  BigBuffer[ofs+$4] := $92;  BigBuffer[ofs+$5] := $00;  BigBuffer[ofs+$6] := $00;
  BigBuffer[ofs+$7] := $44;  BigBuffer[ofs+$8] := $03;

  //BigBuffer[ofs+$9] := $00;  BigBuffer[ofs+$A] := $10;  BigBuffer[ofs+$B] := $00;
  BigBuffer[ofs+$9] := $06;  BigBuffer[ofs+$A] := $00;  BigBuffer[ofs+$B] := $00;

  BigBuffer[ofs+$C] := $82;  BigBuffer[ofs+$D] := $00;  BigBuffer[ofs+$E] := $00;
  BigBuffer[ofs+$F] := $01;  BigBuffer[ofs+$10] := $08;

  // 3 00_1000
  ofs := $80;
  BigBuffer[ofs+$0] := $7E;  BigBuffer[ofs+$1] := $AA;  BigBuffer[ofs+$2] := $99;  BigBuffer[ofs+$3] := $7E;
  BigBuffer[ofs+$4] := $92;  BigBuffer[ofs+$5] := $00;  BigBuffer[ofs+$6] := $00;
  BigBuffer[ofs+$7] := $44;  BigBuffer[ofs+$8] := $03;

  BigBuffer[ofs+$9] := $00;  BigBuffer[ofs+$A] := $10;  BigBuffer[ofs+$B] := $00;
  //BigBuffer[ofs+$9] := $02;  BigBuffer[ofs+$A] := $00;  BigBuffer[ofs+$B] := $00;

  BigBuffer[ofs+$C] := $82;  BigBuffer[ofs+$D] := $00;  BigBuffer[ofs+$E] := $00;
  BigBuffer[ofs+$F] := $01;  BigBuffer[ofs+$10] := $08;




end;

procedure TForm1.FileSaveAs1Accept(Sender: TObject);
var
  F: TFileStream;
begin
  //caption := FileSaveAs1.Dialog.FileName;
  F := TFileStream.Create(FileSaveAs1.Dialog.FileName, fmCreate);

  F.Write(BigBuffer, PageSize*PageCount);
  F.Free;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
   sb.Panels[1].Width := width - 130;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  S : AnsiString;
  I : Integer;
  //LV : TListItem;
begin
  Timer1.Enabled := True;

  Memo1.Clear;
  FT_Enable_Error_Report := false; // Error reporting = on
  FileSaveAs1.Dialog.InitialDir := ExtractFilePath(Application.ExeName);
  //OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName);


  FileSize := 0; // not loaded
  speed := 3;

  DevicePresent := False;

  GetFTDeviceCount;
  S := IntToStr(FT_Device_Count);
  Caption := 'SpiPro - '+S+' Device(s) Present ...';
  DeviceIndex := 0;



//If (FT_Device_Count = 1) or (FT_Device_Count = 2) then
If (FT_Device_Count > 0) then
begin
  // Auto connect
  DeviceIndex := 0;
  For I := 0 to FT_Device_Count-1 do
  Begin
//    LV := ListView1.Items.Add;
//    LV.Caption := 'Device '+IntToStr(I);
//    GetFTDeviceSerialNo( 0 );
    //LV.SubItems.Add(FT_Device_String);
    if (GetFTDeviceDescription ( I ) = FT_OK) then
    begin
//    memo1.lines.Add(inttostr(i) + ' ' + FT_Device_String);
//    DeviceIndex := DeviceIndex + 1;
      if FT_Device_String='USB-Blaster'  then
      begin
        DeviceIndex := I;
      end;
    end;
  End;

//  GetFTDeviceDescription ( 1 );
//  Caption := FT_Device_String;
//  If Open_USB_Device_By_Serial_Number('00SIZYHG') = FT_OK then
//  If Open_USB_Device_By_Serial_Number(FT_Device_String) = FT_OK then

    //Caption := Selected_Device_Description;
  GetFTDeviceDescription ( DeviceIndex );

  If Open_USB_Device_By_Device_Description(FT_Device_String) = FT_OK then
  Begin
     Caption := 'SpiPro - autoconnected to device: ' + FT_Device_String;

      FT_Enable_Error_Report := true;
      FT_Current_Baud := FT_BAUD_921600;
      Set_USB_Device_BaudRate;
      Set_USB_Device_LatencyTimer(2);
      BL_Reset;

//      FT_Enable_Error_Report := true; // Error reporting = on

  End else begin
      //Caption := 'SpiPro - error with connect!';
  end;
  ;

  update_actions;

end;

(*
If FT_Device_Count > 1 then
begin
  For I := 1 to FT_Device_Count do
  Begin
//    LV := ListView1.Items.Add;
  //  LV.Caption := 'Device '+IntToStr(I);
    GetFTDeviceSerialNo( DeviceIndex );
    //LV.SubItems.Add(FT_Device_String);
    GetFTDeviceDescription ( DeviceIndex );
    //LV.SubItems.Add(FT_Device_String);
    DeviceIndex := DeviceIndex + 1;
  End;
end;
*)


end;

procedure TForm1.Memo1KeyPress(Sender: TObject; var Key: Char);
begin
// Caption := Key;
Key := Chr(0);
end;

procedure TForm1.sbDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
  const Rect: TRect);
begin
   //StatusBar.Canvas.Pen.Style := psClear;

   StatusBar.Canvas.Brush.Style := bsSolid;
   //StatusBar.Canvas.Brush.Color := sbColor;
   StatusBar.Canvas.Brush.Color := clRed;
   StatusBar.Canvas.Pen.Style := psSolid;
   StatusBar.Canvas.Pen.Color := StatusBar.Canvas.Brush.Color;

   StatusBar.Canvas.Rectangle(Rect.Left, Rect.Top, Rect.Right, rect.Bottom)
end;

procedure TForm1.set_percent(last, value: integer);
var
  p: integer;
begin
  //
  sb.Panels[1].Text := 'Done ' + inttostr((value * 100) div (last)) + ' %';
end;

procedure TForm1.Status(msg: string);
begin
  //
  sb.Panels[0].Text := msg;
end;

procedure TForm1.FTPort_ConfigureExecute(Sender: TObject);
begin
Repeat
SetupForm.ShowModal;
If FT_SetUperror then
  MessageDlg('Configuration Error ...', mtError, [mbOk], 0);
Until Not FT_SetUpError;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
Var PortStatus : FT_Result;  S : AnsiString; DeviceIndex : DWord;  I : Integer;
begin

Exit; //debug

FT_Enable_Error_Report := False; // Turn off error dialog
If Not DevicePresent then
  Begin
  PortStatus := Close_USB_Device; // In case device was already open
  PortStatus := Open_USB_Device;  // Try and open device
  If PortStatus = FT_OK then      // Device is Now Present !
    Begin
    DevicePresent := True;
    Caption := 'SpiPro - Device Present ...';
    Memo1.Enabled := True;
//    FTPort_Configure.Enabled := True;
//    FTSendFile.Enabled := True;
//    FTReceiveFile.Enabled := True;
    Reset_USB_Device;     // warning - this will destroy any pending data.
    Set_USB_Device_TimeOuts(500,500); // read and write timeouts = 500mS
    End;
  End
else
  Begin
  PortStatus := Get_USB_Device_QueueStatus;
  If PortStatus <> FT_OK then
    Begin   // Device has been Unplugged
    DevicePresent := False;
    Caption := 'SpiPro - No Device Present ...';
    Memo1.Enabled := False;
//    FTSendFile.Enabled := False;
//    FTReceiveFile.Enabled := False;
//    FTPort_Configure.Enabled := False;
    End;
  End;

end;

procedure TForm1.update_actions;
begin
//  actBlow512.Enabled := IsDataFlash;
end;

procedure TForm1.ud1Changing(Sender: TObject; var AllowChange: Boolean);
begin
  //
  AllowChange := True;
  speed := 3; //ud1.position;

  PortAIsOpen := False;
  Init_MPSSE;

//  edit1.text := inttostr(speed);

end;

procedure TForm1.FTQuitExecute(Sender: TObject);
begin
If DevicePresent then Close_USB_Device;
Close;
end;

procedure TForm1.FTResendExecute(Sender: TObject);
Var SaveFile,OpenFile : File;
    BytesWrote,Total,I,FC1: Integer;
    SaveFileName,S : String;
    PortStatus : FT_Result;
begin
FT_Enable_Error_Report := false; // Disable Error Reporting
Timer1.Enabled := False;  // Stop Polling for Device Present
SaveFileName := 'SaveFile.tmp';
AssignFile(SaveFile,SaveFileName);
ReWrite(SaveFile,1);
Total := 0;
//sbStatusBar1.Panels[0].Text := 'Waiting for Data ...';

Repeat
Application.ProcessMessages;
PortStatus := Get_USB_Device_QueueStatus;

If PortStatus <> FT_OK then     // Device no longer present ...
  Begin
  CloseFile(SaveFile);
  Timer1.Enabled := True;
//  StatusBar1.Panels[0].Text := '';
  Exit;
  End;
Until FT_Q_Bytes > 0;

Repeat
Application.ProcessMessages;
I := Read_USB_Device_Buffer(FT_In_Buffer_Size);
Total := Total + I;
//StatusBar1.Panels[0].Text := 'Bytes Received = '+IntToStr(Total);
If I > 0 then BlockWrite(SaveFile,FT_In_Buffer,I,BytesWrote);
Until I = 0; // Nothing more to read !!!

CloseFile(SaveFile);
Total := 0;
Memo1.Lines.Add('Opening - '+SaveFileName);
AssignFile(OpenFile,SaveFileName);
Reset(OpenFile,1);
Repeat
Application.ProcessMessages;
BlockRead(OpenFile,FT_Out_Buffer,FT_Out_Buffer_Size,FC1);
Total := Total + FC1;
//StatusBar1.Panels[0].Text := '   Bytes Sent = '+IntToStr(Total);
If FC1 <> 0 then
  Begin
  I := Write_USB_Device_Buffer( FC1 );
  If I <> FC1 then Memo1.Lines.Add('USB Device Write TimeOut ...');
  End;
Until ( FC1 <> FT_Out_Buffer_Size ); // Last Block of File ...
S := IntToStr(Total)+ ' Bytes Sent ...';
Memo1.Lines.Add(S);
CloseFile(OpenFile);
Timer1.Enabled := True;  // Resume Polling for Device Present
end;

procedure TForm1.LoadMCS(filename: string);
var
  F: TStringList;
  FS: TFileStream;
  i,j,k: integer;
  S, S2, S3: string;
  addr, addr_offset: cardinal;
  b: byte;
begin
//  FileName := ExtractFilePath(Application.ExeName);
//  FileName := FileName + '\prog.mcs';

  F := TStringList.Create;
  F.LoadFromFile(FileName);
  //caption := inttostr(F.Count);

  FillChar(Bigbuffer, sizeof(Bigbuffer), $FF);
  addr := 0;
  addr_offset := $0;

  for i:=0 to F.Count-1 do
  begin
    S := F[i];
    (*
    // Addr records
    //123456789
    //:020000040001F9
    if pos(':02', S) = 1 then
    begin
      S2 := copy(S,10,4);
      addr := strtoint('$'+S2);
      addr := addr shl 16;
      // paranoia
      addr := addr and $FFFFF;
      //log.lines.add(inttostr(addr));
    end;
    *)
    // end record
    if pos(':00', S) = 1 then
    begin

    end else begin
      //123456789
      //:020000040001f9
      //123456789
      //:10000000FFFFFFFF5599AA660C000180000000E089
      if pos(':', S) = 1 then
      begin
        if S[9] <> '0' then
        begin
          // OFFSET
          if S[9] = '4' then
          begin
            // get offset
            S3 :=copy(S,10,4);
            addr_offset := strtoint('$'+S3); // size

            addr_offset := addr_offset * $10000;
            addr := 0;
          end;
        end else begin
          // data records, TYPE 00
          S3 :=copy(S,2,2);
          k := strtoint('$'+S3); // size
          for j := 0 to k-1 do
          begin
            S2 :=copy(S,10+j*2,2);
            b := strtoint('$'+S2);
            bigbuffer[addr or addr_offset] := b;
            inc(addr);
            addr := addr and $FFFF;
          end;
        end;
      end;
    end;
  end;

  FileSize := addr or addr_offset;
  // .MCS file is loaded...
  F.Free;

//  i := sizeof(bigbuffer);
//  repeat
//    dec(i);
//  until (i=0) or (bigbuffer[i] <> $FF);

//  if i>1 then begin
//      for j:= 0 to i do
//      begin
//        write(inttohex((bigbuffer[j] shr 7) and 1,1) );
//        write(inttohex((bigbuffer[j] shr 6) and 1,1) );
//        write(inttohex((bigbuffer[j] shr 5) and 1,1) );
//        write(inttohex((bigbuffer[j] shr 4) and 1,1) );
//
//        write(inttohex((bigbuffer[j] shr 3) and 1,1) );
//        write(inttohex((bigbuffer[j] shr 2) and 1,1) );
//        write(inttohex((bigbuffer[j] shr 1) and 1,1) );
//        write(inttohex((bigbuffer[j]      ) and 1,1) );
//      end;
//  end;

//  if i>1 then begin
//      for j:= 0 to i do
//      begin
//        writeln(inttohex(buf[j],2) );
//      end;
//  end;


//	FS := TFileStream.Create('output.bin', fmCreate);
//	for i:=0 to 6000-1 do
//	begin
//		FS.Write(Buf, 512);
//	end;
//	FS.Free;







end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  //
  WS_test(
  strtoint(edit1.Text),
  strtoint(edit2.Text),
  strtoint(edit3.Text))
  ;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var S:String; DeviceIndex : DWord; I : Integer; LV : TListItem;
begin
//ListView1.Items.clear;
GetFTDeviceCount;
S := IntToStr(FT_Device_Count);
Caption := 'SpiPro - '+S+' Device(s) Present ...';
DeviceIndex := 0;
If FT_Device_Count > 0 then
  For I := 1 to FT_Device_Count do
  Begin
//  LV := ListView1.Items.Add;
  //LV.Caption := 'Device '+IntToStr(I);
  GetFTDeviceSerialNo( DeviceIndex );
//  LV.SubItems.Add(FT_Device_String);
  GetFTDeviceDescription ( DeviceIndex );
  //LV.SubItems.Add(FT_Device_String);
  DeviceIndex := DeviceIndex + 1;
  End;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  t: integer;
begin
  t := GetTickCount;


end;

procedure TForm1.actBlow512Execute(Sender: TObject);
begin
  DF_Identify;

  if MessageDlgPos(
   'Warning - this is operation will blow a one-time programmable fuse!'+#10+
   'It is not possible to revert back! Press OK to continue or Cancel.',
  mtCustom, [mbOK, mbCancel], 0, -1, -1)=1 then
  begin
    Memo1.Lines.Clear;
    Memo1.Lines.Add('Please power cycle (ON/OFF) the SPI Flash IC!');

    //
    DF_Blow512;


  end else begin

  end;

end;

procedure TForm1.actBOOT0Execute(Sender: TObject);
begin
  //
//  spi_SHADOW($00);
  spi_SHADOW($80);
//  spi_SHADOW($00);
end;

procedure TForm1.Action10Execute(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to 4096 - 1 do
  begin
    SPI_ProgramByte($1E1000+i, BigBuffer[i]);
  end;



end;

procedure TForm1.actAboutExecute(Sender: TObject);
begin
  //
  AboutSpiProForm.ShowModal;
end;

procedure TForm1.Action12Execute(Sender: TObject);
begin
  Cycle_USB_Port;

//  Status('Please Restart the U2TOOL');
end;

procedure TForm1.actCompareArrayExecute(Sender: TObject);
var
 p,i, j: integer;
 ok: boolean;
 s: string;
begin
  DF_Identify;

  Status ('Verify...');
  ok := true;

  if IsDataFlash then
  begin
    i := 0;
    repeat
        move(BigBuffer[I * PageSize], PageBuffer, PageSize);
        DF_WritePageBuffer(0);
        if not DF_ComparePageBuffer(0, I) then ok := false;

        if (i mod 50)=0 then
        begin
          //Caption := inttostr(i);
          set_percent(PageCount, i);
          Application.ProcessMessages;
        end;
        inc(i);
    until (i>=PageCount) or not ok;
    if ok then
      memo1.Lines.Add('OK') else
      memo1.Lines.Add('Verify Error at: 0x'+inttohex(PageSize*i-1,6));
  end else begin
    I := 0;
    ok := true;
    repeat
      DF_ReadPage(I);
      //
      for j := 0 to PageSize - 1 do
        begin
          p := I * PageSize+j;
          if PageBuffer[j] <> BigBuffer[p] then
          begin
            ok := false;
          end;
        end;
      if (i mod 50)=0 then
      begin
        //Caption := inttostr(i);
        set_percent(PageCount, i);
        Application.ProcessMessages;
      end;
      inc(i);
    until (i >= PageCount) or not ok;
    if ok then
      memo1.Lines.Add('OK') else
      memo1.Lines.Add('Verify Error at: '+inttostr(p) + ' 0x'+inttohex(p,8) );
  end;

  Status ('Done');
end;

procedure TForm1.actAutoExecute(Sender: TObject);
begin
  //
  (*
  actIdentify.Execute;
  if JEDEC_ID <> $FFFFFF then
  begin
    actErase.Execute;
    actProgramArray.Execute;
  end else begin
    memo1.Lines.Add('No chip detected...')
  end;
  *)
  ICE_CONFIG(32000);
  Memo1.Lines.Add('Configuration sent to RAM');

end;

procedure TForm1.actBlankCheckExecute(Sender: TObject);
var
 i, j: integer;
 ok: boolean;
 s: string;
begin
  DF_Identify;

//memo1.Lines.Add(inttostr(PageSize));

  ok := true;
  if IsDataFlash then
  begin
    // Dataflash can use fast BLANK CHECK

    FillChar(PageBuffer, PageSize, $FF);
    DF_WritePageBuffer(0);

    i := 0;
    repeat
        if not DF_ComparePageBuffer(0, I) then ok := false;
        if (i mod 100)=0 then
        begin
          //Caption := inttostr(i);
          set_percent(PageCount, i);
          Application.ProcessMessages;
        end;
        inc(i);
    until (i>=PageCount) or not ok;

    if ok then
      memo1.Lines.Add('OK') else
      memo1.Lines.Add('Blank Check Error at: '+inttostr(i-1));
  end else begin
    // we just read and verify

    Status ('Blank check...');
    I := 0;
    ok := true;
    repeat
      DF_ReadPage(I);
      //
      for j := 0 to PageSize - 1 do
        begin
          if PageBuffer[j] <> $FF then ok := false;
        end;
      if (i mod 50)=0 then
      begin
        //Caption := inttostr(i);
        set_percent(PageCount, i);
        Application.ProcessMessages;
      end;
      inc(i);
    until (i >= PageCount) or not ok;

    if ok then
    begin
      memo1.Lines.Add('OK');
      set_percent(1, 1);
    end else
      memo1.Lines.Add('Blank Check Error at: '+inttostr(i*PageSize-1));
  end;
  Status('Done');
end;

procedure TForm1.Action16Execute(Sender: TObject);
begin
   //
   ee_CS(1); ee_MOSI(0); ee_SCL(1);
end;

procedure TForm1.Action17Execute(Sender: TObject);
begin
   ee_CS(1); ee_MOSI(0); ee_SCL(0);
end;

procedure TForm1.Action18Execute(Sender: TObject);
begin
   ee_CS(1); ee_MOSI(1); ee_SCL(0);
end;

procedure TForm1.Action19Execute(Sender: TObject);
begin
   ee_CS(1); ee_MOSI(1); ee_SCL(1);
   //
   //DF_Identify;
end;

procedure TForm1.Action1Execute(Sender: TObject);
begin
  //
//  spi_SHADOW($01);
  spi_SHADOW($81);
//  spi_SHADOW($01);

end;

procedure TForm1.Action2Execute(Sender: TObject);
var
  i,j: integer;
  s: string;
begin
  mcu_ADDR($200);
  for I := 0 to 256 - 1 do mcu_WRITE(BigBuffer[i]);

// mcu_WRITE($33);

end;

procedure TForm1.Action3Execute(Sender: TObject);
begin
  mcu_CALL;
end;

procedure TForm1.Action4Execute(Sender: TObject);
begin
  //
//  spi_SHADOW($02);
  spi_SHADOW($82);
//  spi_SHADOW($02);

end;

procedure TForm1.actMCUreadExecute(Sender: TObject);
var
  a,i,j: integer;
  s: string;
begin
  memo1.Lines.Clear;
  //memo1.Lines.BeginUpdate;

  Purge_USB_Device_Out;
  Purge_USB_Device_In;


  for I := 0 to 64 - 1 do
    begin
      a := i*16;
      if (a and $FF)=0 then
      begin
        //memo1.Lines.Add('-'+inttohex(a, 4));
        mcu_ADDR(a);
      end;

      s := inttohex(a, 4)+': ';
      for j := 0 to 16 - 1 do
      begin
        s := s + inttohex(mcu_READ, 2) + ' ';
      end;
      memo1.Lines.Add(s);
    end;

//  mcu_ADDR($200);
//  for I := 0 to 8 - 1 do
//    begin
//      s := inttohex($200 + i*16, 4)+': ';
//      for j := 0 to 16 - 1 do
//      begin
//        s := s + inttohex(mcu_READ, 2) + ' ';
//      end;
//      memo1.Lines.Add(s);
//    end;
//  memo1.Lines.EndUpdate;
end;

procedure TForm1.actMCUtestExecute(Sender: TObject);
var
  a,i,j,n: integer;
  s: string;
  b : byte;
begin
  memo1.Lines.Clear;
  Purge_USB_Device_Out;
  Purge_USB_Device_In;

  n := 1024;
  //n := 8;

  mcu_ADDR($200);
  i := 0;
  repeat
    //

    if (i and $F)=0 then
    begin
      caption := '-'+inttohex(i, 4);
    end;

    inc(i);
    mcu_ADDR8($7f); mcu_WRITE(i and $FF);
    mcu_ADDR8($7f); b := mcu_READ;

    Get_USB_Device_QueueStatus;
    if FT_Q_Bytes > 0 then
    begin
      memo1.Lines.Add('err extra byte');
    end;

    if b<>(i and $FF) then
    begin
      memo1.Lines.Add('err ' + inttostr(i) + ' ' + inttostr(n) + ' ' + inttohex(b,2) + ' ' + inttohex(i and $FF,2));
      mcu_ADDR8($7f); b := mcu_READ;
    end;


  until (i>n) or (b<>(i and $FF));

  memo1.Lines.Add('test ' + inttostr(i) + ' ' + inttostr(n) + ' ' + inttohex(b,2) + ' ' + inttohex(i and $FF,2));


end;

procedure TForm1.actMISOExecute(Sender: TObject);
begin
  caption := inttostr(spi_MISO);
end;

procedure TForm1.actMCUactivateExecute(Sender: TObject);
var
  i,j: integer;
begin
//  FT_Out_Buffer[0] := $1B;
//  Write_USB_Device_Buffer( 1 );
//
//  Set_USB_Device_BitMode($3F, $01);
//
//  for I := 0 to 128 do
//    begin
//      FT_Out_Buffer[0] := $1B;
//      Write_USB_Device_Buffer( 1 );
//
//      FT_Out_Buffer[0] := $1A;
//      Write_USB_Device_Buffer( 1 );
//    end;
//
//
//  Set_USB_Device_BitMode($FF, $00);
//  Purge_USB_Device_Out;
//  Purge_USB_Device_In;


  mcu_EN;


end;

procedure TForm1.actMCUdisableExecute(Sender: TObject);
begin
  Set_USB_Device_BitMode($FF, $00);
  Purge_USB_Device_Out;
  Purge_USB_Device_In;

  mcu_DIS;
  BL_Reset;
  BL_Reset;
  mcu_DIS;

end;

procedure TForm1.actMCUledOFFExecute(Sender: TObject);
begin
  //
  memo1.Lines.Add(inttohex(ftdi_xfer($10),2));
end;

procedure TForm1.actMCUledONExecute(Sender: TObject);
begin
  memo1.Lines.Add(inttohex(ftdi_xfer($11),2));
end;

procedure TForm1.actIdentifyExecute(Sender: TObject);
var
  id, id2, st: cardinal;
  mid: integer;
  sSize,
  sVendor,
  s: string;
  ok : boolean;
begin
  memo1.Lines.Clear;

  // dummy
  id  := DF_Identify;

  id  := DF_Identify;
  id2 := DF_Identify;

  if id <> id2 then
  begin
    memo1.Lines.Add('Warning: JEDEC ID read not constant: '+ inttohex(id, 8) + ' ' +inttohex(id2,8));
  end;

  JEDEC_ID := DF_Identify;
  id := JEDEC_ID;

  if JEDEC_ID = $FFFFFF then
  begin
    //spi_cmd($04); // WRDI
  end;

  JEDEC_ID := DF_Identify;
  id := JEDEC_ID;


  if (JEDEC_ID and $FFFFFF) = $FFFFFF then
  begin
    memo1.Lines.Add('No chip detected, MISO stuck 1!');
    exit;
  end;

  if JEDEC_ID = $000000 then
  begin
    memo1.Lines.Add('No chip detected, MISO stuck 0!');
    exit;
  end;

  if IsDataFlash then
  begin
    st := DF_Status;
  end else begin
    spi_cmd($04); // WRDI ?
    st := SPI_Status;
  end;


  mid := JEDEC_ID shr 16 and $FF;
  sSize := '? bit';

  sVendor := JedecVendor;


//  4D012018

  case mid of
    $7F: begin
      // Page 2
      case (JEDEC_ID shr 8 and $FF) of
        $9D: begin
          sVendor := 'PMC';
          case (JEDEC_ID and $FF) of
            // 1M
            $13: begin
                PageCount := 1024*4;
                sSize := '8 MBit';
            end;
            // 2M
            $14: begin
                PageCount := 1024*4*2;
                sSize := '16 MBit';
            end;
          end;
        end else begin
          //
          sVendor := 'Vendor(P1.'+inttohex(mid, 2)+')';
        end;
      end;
    end;
    $BF: begin
//      sVendor := 'SST';
    end;

    $01: begin
      sVendor := 'Spansion';

    end;


    $EF: begin
//      sVendor := 'Winbond';

          case (JEDEC_ID and $FF) of
            // 1M
            $13: begin
                PageCount := 1024*4;
                sSize := '8 MBit';
            end;
            // 2M
            $14: begin
                PageCount := 1024*4*2;
                sSize := '16 MBit';
            end;
          end;

    end;
    $1F: begin
//      sVendor := 'Atmel';
    end else begin
//      sVendor := 'Vendor('+inttohex(mid, 2)+')';
    end;

  end;

  ok := false;
  s := 'JEDEC ID: ' + Inttohex(JEDEC_ID and $FFFFFF,6) + ' ';

  if id=$1F2600 then begin
    sSize := '16 MBit';
    s := s + 'Atmel AT45DB161D';
    ok := true;
  end;

  if id=$11F2600 then begin
    sSize := '16 MBit';
    s := s + 'Atmel AT45DB161E';
    ok := true;
  end;

  if id=$1F2500 then begin
    sSize := '8 MBit';
    s := s + 'Atmel AT45DB081D';
    ok := true;
  end;

  if id=$1F4800 then begin
    sSize := '64 MBit';
    s := s + 'AT25DF641';
    ok := true;
  end;


  if id=$BF2541 then begin
    sSize := '16 MBit';
    s := s + 'SST25VF016B';
    ok := true;
  end;



  if id=$EF4015 then begin
    sSize := '16 MBit';
    s := s + 'W25Q16BV';
    ok := true;
  end;

  if id=$EF4017 then begin
    sSize := '64 MBit';
    s := s + 'W25Q64BV';
    ok := true;
  end;


  if id=$7F9D14 then begin
    sSize := '16 MBit';
    s := s + 'PM25LV016';
    ok := true;
  end;

  if id=$7F9D13 then begin
    sSize := '8 MBit';
    s := s + 'PM25LV080';
    ok := true;
  end;

  if id=$8C2013 then begin
    sSize := '8 MBit';
    s := s + 'F25L004A';
    ok := true;
  end;

  if id=$C83014 then begin
    sSize := '8 MBit';
    s := s + 'GD25D80';
    ok := true;
  end;

  if id=$C22015 then begin
    sSize := '16 MBit';
    s := s + 'MX25L1606E';
    ok := true;
  end;

  if id=$1C3115 then begin
    sSize := '16 MBit';
    s := s + 'EN25F16';
    ok := true;
  end;

  id := id and $FFFFFF;

  if id=$012018 then begin
    sSize := '128 MBit';
    s := s + 'S25FL127S';
    ok := true;
  end;


  if not ok then
  begin
    memo1.Lines.Add('Identify fail');
    DF_Identify2;
  end;

  if PageSize=0 then
    PageSize := 256;

  if isDataflash then
  begin
    if (st and $02)=0 then
    s := s + ' Protect=OFF' else
    s := s + ' Protect=ON';
    s := s + ' Page='+inttostr(PageSize);
  end else begin
    s := s + ' SR=0x'+inttohex(st,2);
  end;

  memo1.Lines.Add('Chip vendor: ' + sVendor);
  memo1.Lines.Add('Capacity: ' + inttostr( ((8*PageCount*PageSize) div (1024*1024)) ) + ' MBit');
  if IsDataflash then
    memo1.Lines.Add('Algorithm: Dataflash') else
  if Feature_PP then
    memo1.Lines.Add('Algorithm: PP (Page Program)') else
  if Feature_AAI then
    memo1.Lines.Add('Algorithm: AAI (Auto Address Increment)') else
    memo1.Lines.Add('Algorithm: BP (Byte Program)');


  memo1.Lines.Add(s);

//  memo1.Lines.Add('ID ' + inttohex(JEDEC_ID, 8));



//  spi_CS(0);
  update_actions;
end;

procedure TForm1.actEraseEEExecute(Sender: TObject);
begin
//
  ee_EWEN;
  ee_ERAL;
end;

procedure TForm1.actEraseExecute(Sender: TObject);
var
  i, j: integer;
  PageOffset: cardinal;
  s: string;
begin
  memo1.Lines.Clear;
//  DF_Identify;
  DF_Identify;
  DF_Identify;

  if IsDataflash then
  begin
    DF_Identify;
    Status('Erasing...');
    Application.ProcessMessages;


    for I := 0 to PageCount - 1 do
    begin
      DF_ErasePage(I);
      repeat until (DF_Status and $80)<>0;

      if (i mod 10)=0 then
      begin
        //Caption := inttostr(i);
        set_percent(PageCount-1,i);
        Application.ProcessMessages;
      end;
    end;
    exit;

  end else begin
    if (SPI_Status and $3C) <> 0 then
    begin
      spi_cmd($06); // EWSR
//    spi_cmd($50); // EWSR
//    spi_cmd2($01, $1C); // WRSR
      spi_cmd2($01, $00); // WRSR
      Status('Clear protection bits');
      if GD_fix then
      begin
        repeat
          memo1.Lines.Add(inttohex(SPI_Status2, 2));
        until (SPI_Status2 and 3) = 0;
      end else begin
        repeat

        until (SPI_Status and 1) = 0;
      end;

    end else begin

    end;


    Status('Erasing...');
    Application.ProcessMessages;

    // SPI standard flash
    SPI_ChipErase;

    if GD_fix then
    begin
      repeat
        //memo1.Lines.Add(inttohex(SPI_Status2, 2));
      until (SPI_Status2 and 3) = 0;
    end else begin

//      memo1.Lines.Add(inttohex(SPI_Status, 2));
//      memo1.Lines.Add(inttohex(SPI_Status, 2));

      i := 0;
      repeat
        //
//        memo1.Lines.Add(inttohex(SPI_Status, 2));

        s := 'erasing... ' + inttostr(i) + inttohex(SPI_Status, 2);
        inc(i);
        StatuS(s);
      Application.ProcessMessages;

      until (SPI_Status and 1) = 0;
    end;




    // TODO
    // Wait
  end;

  Status('Done..');
end;

procedure TForm1.actProgramArrayExecute(Sender: TObject);
var
  s: string;
  w, i, j: integer;
  ofs: cardinal;
  aai_new,
  force: boolean;
  st: byte;
begin
  DF_Identify;
  DF_Identify;

  //force := actForcePolling.Checked;


  status('Programming...');

  if FileSize > PageCount*PageSize then
  begin
    FileSize := PageCount*PageSize;
  end;
   //ofs := $20000;
  if IsDataflash then
  begin
   ofs := 0;
   if FileSize=0 then FilePages := PageCount
   else FilePages := (FileSize+1024) div PageSize;

   if FilePages>PageCount then FilePages := PageCount;

   for i := 0 to (FilePages div 2) - 1 do
   begin
     // Copy page
     for j := 0 to PageSize - 1 do PageBuffer[j] := BigBuffer[PageSize*(i*2)+j];
     // transfer to Page buffer
     DF_WritePageBuffer(0);
     // must be ready!
     repeat until (DF_Status and $80)<>0;
     // program page
     DF_ProgramWithErasePageBuffer(0, i*2 + (ofs div PageOffset) );
     // Start write #0

     // Copy page
     for j := 0 to PageSize - 1 do PageBuffer[j] := BigBuffer[PageSize*(i*2+1)+j];
     // transfer to Page buffer
     DF_WritePageBuffer(1);
     // must be ready!

     repeat
      st := DF_Status2;
     until (st and $80)<>0;
     if DF_has_stat2 and ((st and $20)<>0) then
     begin
       //
       memo1.Lines.Add('Error writing page: ' + inttohex(i*PageSize*2,8));
     end;


     // program page
     DF_ProgramWithErasePageBuffer(1, i*2+1  + (ofs div PageOffset));
     // Start write #1

     if (i mod 5)=0 then
     begin
//       Caption := inttostr(i*2);
       set_percent(FilePages div 2, i);
       Application.ProcessMessages;
     end;
   end;

  end else begin
    // SPI standard flash
   ofs := 0;
   if FileSize=0 then FilePages := PageCount
   else FilePages := (FileSize+256) div PageSize;
   if FilePages>PageCount then FilePages := PageCount;

//   for i := 0 to FilePages  - 1 do
//   for i := 0 to 0 do
//   begin
//     for j := 0 to PageSize - 1 do PageBuffer[j] := BigBuffer[PageSize*i+j];
//     SPI_ProgramPageBuffer(i * PageSize );
//
//     if (i mod 5)=0 then
//     begin
//       Caption := inttostr(i*2);
//       Application.ProcessMessages;
//     end;
//   end;

    if Feature_AAI then
    begin
      ftdi_cache := true;
      // unprotect!
      spi_cmd($06); // EWSR
      spi_cmd2($01, $00); // WRSR
      // program first 2 bytes!
//    memo1.Lines.Add(inttohex(SPI_Status, 2));

//      w := 0;

      //

//      spi_cmd3($AD, 0);
//      spi_xmit(BigBuffer[0]);
//      spi_xmit(BigBuffer[1]);
//      spi_CS(1);

//      if ((SPI_Status and $40) <> $40) then
//      begin
//        memo1.Lines.Add('Error, AAI flag not set, can not use AAI algorithm');
//        Exit;
//      end;

      //ftdi_xmit(lastval or $08);
      lastval := lastval or $08;

      i := 0;
      w := 0;
      aai_new := true;
      repeat
        //spi_CS(0);
        // Delau.. 10uS ?

        // need adjust ?

        // FFFF ?
        if (BigBuffer[i] <> $FF) or (BigBuffer[i+1] <> $FF) then
        begin
          if aai_new then
          begin
              ftdi_flush;

              spi_cmd(4); // wrdi
              spi_cmd(6); // wren

              spi_cmd3($AD, i);
              spi_xmit(BigBuffer[i]); inc(i);
              spi_xmit(BigBuffer[i]); inc(i);
              spi_CS(1);

              lastval := lastval or $08;
              ftdi_xmit(lastval);

              aai_new := false;
              repeat
                //
              until (SPI_Status and $01)=0;

          end else begin
            lastval := lastval and $35;
            ftdi_xmit(lastval);
            ftdi_xmit($83);
            ftdi_xmit(bitswap($AD));
            ftdi_xmit(bitswap(BigBuffer[i])); inc(i);
            ftdi_xmit(bitswap(BigBuffer[i])); inc(i);

            lastval := lastval or $08;
            ftdi_xmit(lastval);

            if force then
            begin
              //
              repeat
                //
              until (SPI_Status and $01)=0;
            end else begin
              // fixed delay
              lastval := lastval or $08;
              for j := 0 to 10 do ftdi_xmit(lastval);
            end;
          end;
          w := w + 2;

        end else begin
          // we skipped, so need send AAI address
          aai_new := true;
          w := w + 2;
          i := i + 2;
        end;

        if (i mod 5000)=0 then
        begin
          //Caption := inttostr(i);
          set_percent(FileSize, i);
          Application.ProcessMessages;
        end;
//      until i > 400; // make sure last byte is written too
      until i >= (FileSize); // make sure last byte is written too

      repeat
          //
      until (SPI_Status and $01)=0;


//      if ((SPI_Status and $40) <> $40) then
//      begin
//        memo1.Lines.Add('Error, AAI flag not set after programming');
//      end;

//      memo1.Lines.Add('SPI SR 0x' + inttohex(SPI_Status,8));

      memo1.Lines.Add('Written ' +inttostr(w) + ' 0x' + inttohex(w,8));
//    memo1.Lines.Add(inttohex(SPI_Status, 2));

      spi_cmd(4); // wrdi

      BL_Reset;
      spi_cmd(4); // wrdi

      DF_Identify;
      DF_Identify;

    end else begin
      if Feature_PP then
      begin
         //
         if FileSize=0 then FilePages := PageCount
         else FilePages := (FileSize+255) div PageSize;
         if FilePages>PageCount then FilePages := PageCount;

         for i := 0 to FilePages - 1 do
         begin
           for j := 0 to PageSize - 1 do PageBuffer[j] := BigBuffer[PageSize*i+j];
           SPI_ProgramPageBuffer(i*PageSize);

          repeat
          until (SPI_Status and 1)=0;

           if (i mod 100)=0 then
           begin
             //Caption := inttostr(i);
             set_percent(FilePages, i);
             Application.ProcessMessages;
           end;

         end;
         BL_Reset;

      end else begin
        for I := 0 to FileSize - 1 do
        begin
          //spi_cmd(6); // wren
          //spi_cmd3(2, i);
          //spi_xmit(BigBuffer[i]);
          //spi_CS(1);
          SPI_ProgramByte(i, BigBuffer[i]);
          repeat
          until (SPI_Status and 1)=0;

          if (i mod 100)=0 then
          begin
//            Caption := inttostr(i);
            set_percent(FileSize, i);
            Application.ProcessMessages;
          end;
        end;
      end;
    end;
  end;
  set_percent(1, 1);
  status('Done...');
end;

procedure TForm1.actReadSecurityPageExecute(Sender: TObject);
var
  i, j: integer;
  s: string;
begin
  DF_Identify;
  DF_Identify;

  memo1.Lines.Clear;
  if IsDataflash then
  begin
    DF_ReadSecurityPage;
    for I := 0 to 8 - 1 do
    begin
      s := '';
      for j := 0 to 16 - 1 do
      begin
        s := s + inttohex(PageBuffer[i*16+j], 2) + ' ';
      end;
      memo1.Lines.Add(s);
    end;
  end;

  if JEDEC_ID=$EF4015 then
  begin
    //DF_ReadSecurityPage;

    spi_cmd3($4B, 0);
    spi_xfer(0); // dummy
    for I := 0 to 8 - 1 do
    begin
      PageBuffer[i] := spi_xfer(0);
    end;
    spi_CS(1);

    //for I := 0 to 4 - 1 do
    begin
      s := '';
      for j := 0 to 8 - 1 do
      begin
        s := s + inttohex(PageBuffer[j], 2) + ' ';
      end;
      memo1.Lines.Add(s);
    end;
  end;

end;

procedure TForm1.Action7Execute(Sender: TObject);
begin
  DF_Powerdown;
end;

procedure TForm1.Action8Execute(Sender: TObject);
begin
  DF_Wakeup;
end;

procedure TForm1.ActionConfigExecute(Sender: TObject);
begin
  ICE_CONFIG(32000);
  Memo1.Lines.Add('Configuration sent to RAM');
end;

procedure TForm1.ActionResetExecute(Sender: TObject);
begin
  ICE_RESET;
end;

procedure TForm1.actReadArrayExecute(Sender: TObject);
var
  i, j: integer;
  PageOffset: cardinal;
  s: string;
begin
  // TODO use SPI standard READ command...
  memo1.Lines.Clear;

  DF_Identify;
  DF_Identify;

  if IsDataflash then
  begin
    Status ('Reading...');
    for I := 0 to PageCount - 1 do
    begin
      DF_ReadPage(I);
      move(PageBuffer, BigBuffer[I * PageSize], PageSize);
      if (i mod 50)=0 then
      begin
        //Caption := inttostr(i);
        set_percent(PageCount-1, i);
        Application.ProcessMessages;
      end;
    end;
  end else begin
    // SPI standard flash
    Status ('Reading...');
    for I := 0 to PageCount - 1 do
//    for I := $1E10 to $1E10 do
//    for I := 0 to 0 do
    begin
      DF_ReadPage(I);
      move(PageBuffer, BigBuffer[I * PageSize], PageSize);
      if (i mod 50)=0 then
      begin
        //Caption := inttostr(i);
        set_percent(PageCount-1, i);
        Application.ProcessMessages;
      end;
    end;

//    for I := 0 to 16 - 1 do
//    begin
//      s := inttohex(i*16,2)+': ';
//      for j := 0 to 16 - 1 do
//      begin
////        s := s + inttohex(BigBuffer[i*16+j], 2) + ' ';
//       s := s + inttohex(PageBuffer[i*16+j], 2) + ' ';
//      end;
//      memo1.Lines.Add(s);
//    end;


  end;
  set_percent(1, 1);
  ftdi_flush;

  Status ('Done');
end;

end.
