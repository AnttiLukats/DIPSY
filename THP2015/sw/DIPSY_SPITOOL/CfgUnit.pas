unit CfgUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls,D2XXUnit, Mask;

type
  TSetupForm = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    BaudSelect: TComboBox;
    Label1: TLabel;
    DataBits: TComboBox;
    StopBits: TComboBox;
    Parity: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    FlowControl: TComboBox;
    RTS_On: TCheckBox;
    Label6: TLabel;
    Label7: TLabel;
    DTR_On: TCheckBox;
    GroupBox3: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Event_On: TCheckBox;
    Error_On: TCheckBox;
    Label11: TLabel;
    Button2: TButton;
    XON_Val: TMaskEdit;
    XOFF_Val: TMaskEdit;
    Event_Val: TMaskEdit;
    Error_Val: TMaskEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Event_OnClick(Sender: TObject);
    procedure Error_OnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetupForm: TSetupForm;

implementation

{$R *.DFM}

Procedure SetUpBaudRate;
Var Str : String;
Begin
Str := SetupForm.BaudSelect.Text;
If Str = '300' then FT_Current_Baud := FT_BAUD_300 else
If Str = '600' then FT_Current_Baud := FT_BAUD_600 else
If Str = '1,200' then FT_Current_Baud := FT_BAUD_1200 else
If Str = '2,400' then FT_Current_Baud := FT_BAUD_2400 else
If Str = '4,800' then FT_Current_Baud := FT_BAUD_4800 else
If Str = '9,600' then FT_Current_Baud := FT_BAUD_9600 else
If Str = '19,200' then FT_Current_Baud := FT_BAUD_19200 else
If Str = '38,400' then FT_Current_Baud := FT_BAUD_38400 else
If Str = '57,600' then FT_Current_Baud := FT_BAUD_57600 else
If Str = '115,200' then FT_Current_Baud := FT_BAUD_115200 else
If Str = '230,400' then FT_Current_Baud := FT_BAUD_230400 else
If Str = '460,800' then FT_Current_Baud := FT_BAUD_460800 else
If Str = '921,600' then FT_Current_Baud := FT_BAUD_921600 else
FT_SetupError := True;
End;

Procedure SetUpDataBits;
Var Str : String;
Begin
Str := SetupForm.DataBits.Text;
If Str = '7 bits' then FT_Current_DataBits := FT_DATA_BITS_7 else
If Str = '8 bits' then FT_Current_DataBits := FT_DATA_BITS_8 else
FT_SetupError := True;
End;

Procedure SetUpStopBits;
Var Str : String;
Begin
Str := SetupForm.StopBits.Text;
If Str = '1 bit' then FT_Current_StopBits := FT_STOP_BITS_1 else
If Str = '2 bits' then FT_Current_StopBits := FT_STOP_BITS_2 else
FT_SetupError := True;
End;

Procedure SetUpParity;
Var Str : String;
Begin
Str := SetupForm.Parity.Text;
If Str = 'None' then FT_Current_Parity := FT_PARITY_NONE else
If Str = 'Odd' then FT_Current_Parity := FT_PARITY_ODD else
If Str = 'Even' then FT_Current_Parity := FT_PARITY_EVEN else
If Str = 'Mark' then FT_Current_Parity := FT_PARITY_MARK else
If Str = 'Space' then FT_Current_Parity := FT_PARITY_SPACE else
FT_SetupError := True;
End;

Procedure SetUpFlowControl;
Var Str : String;
Begin
Str := SetupForm.FlowControl.Text;
If Str = 'None' then FT_Current_FlowControl := FT_FLOW_NONE else
If Str = 'RTS/CTS' then FT_Current_FlowControl := FT_FLOW_RTS_CTS else
If Str = 'DTR/DSR' then FT_Current_FlowControl := FT_FLOW_DTR_DSR else
If Str = 'X-On/X-Off' then FT_Current_FlowControl := FT_FLOW_XON_XOFF else
FT_SetupError := True;
End;

Function HexToByte( Str1 : String; Var HexVal : Byte ) : Boolean;
Var Str2 : String;
Begin
Str2 := UpperCase(Str1);
HexVal := 0;
If (( Str2[1] in ['0'..'9'] ) or ( Str2[1] in ['A'..'F'] )) and
   (( Str2[2] in ['0'..'9'] ) or ( Str2[2] in ['A'..'F'] )) then
  Begin
  Result := true;
  If ( Str2[1] in ['0'..'9'] ) then Hexval := Ord(Str2[1])-Ord('0')
                                else Hexval := Ord(Str2[1])-Ord('A')+10;
  Hexval := HexVal * 16;
  If ( Str2[2] in ['0'..'9'] ) then Hexval := HexVal + Ord(Str2[2])-Ord('0')
                                else Hexval := Hexval + Ord(Str2[2])-Ord('A')+10;
  End
else Result := false;
End;

procedure TSetupForm.Button1Click(Sender: TObject);
var Str : String;
begin
FT_SetupError := False;
SetUpBaudRate;
SetUpDataBits;
SetUpStopBits;
SetUpParity;
SetUpFlowControl;
FT_RTS_On := RTS_On.Checked;
FT_DTR_On := DTR_On.Checked;
FT_Event_On := Event_On.Checked;
FT_Error_On := Error_On.Checked;
Str := XON_Val.Text;
If Not HexToByte(Str,FT_XON_Value ) then FT_SetupError := True;
Str := XOFF_Val.Text;
If Not HexToByte(Str,FT_XOFF_Value ) then FT_SetupError := True;
Str := Event_Val.Text;
If Not HexToByte(Str,FT_EVENT_Value ) then FT_SetupError := True;
Str := Error_Val.Text;
If Not HexToByte(Str,FT_ERROR_Value ) then FT_SetupError := True;
ModalResult := MrOK;
end;

procedure TSetupForm.Button2Click(Sender: TObject);
begin
ModalResult := MrCancel;
end;

procedure TSetupForm.Event_OnClick(Sender: TObject);
begin
Event_Val.Enabled := Event_On.Checked;
Label9.Enabled := Event_On.Checked;
end;

procedure TSetupForm.Error_OnClick(Sender: TObject);
begin
Error_Val.Enabled := Error_On.Checked;
Label10.Enabled := Error_On.Checked;
end;

end.
