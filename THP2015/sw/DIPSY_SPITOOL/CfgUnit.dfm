object SetupForm: TSetupForm
  Left = 332
  Top = 256
  BorderStyle = bsDialog
  Caption = 'Configuration Options'
  ClientHeight = 273
  ClientWidth = 556
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 160
    Top = 216
    Width = 97
    Height = 33
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 16
    Width = 201
    Height = 185
    Caption = ' Data '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 36
      Width = 64
      Height = 16
      Caption = 'Baud Rate'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 24
      Top = 68
      Width = 54
      Height = 16
      Caption = 'Data Bits'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 24
      Top = 100
      Width = 53
      Height = 16
      Caption = 'Stop Bits'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 40
      Top = 132
      Width = 34
      Height = 16
      Caption = 'Parity'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object BaudSelect: TComboBox
      Left = 88
      Top = 32
      Width = 89
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      TabOrder = 0
      Text = '115,200'
      Items.Strings = (
        '300'
        '600'
        '1,200'
        '2,400'
        '4,800'
        '9,600'
        '19,200'
        '38,400'
        '57,600'
        '115,200'
        '230,400'
        '460,800'
        '921,600')
    end
    object DataBits: TComboBox
      Left = 88
      Top = 64
      Width = 89
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      TabOrder = 1
      Text = '8 bits'
      Items.Strings = (
        '7 bits'
        '8 bits')
    end
    object StopBits: TComboBox
      Left = 88
      Top = 96
      Width = 89
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      TabOrder = 2
      Text = '1 bit'
      Items.Strings = (
        '1 bit'
        '2 bits')
    end
    object Parity: TComboBox
      Left = 88
      Top = 128
      Width = 89
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      TabOrder = 3
      Text = 'None'
      Items.Strings = (
        'None'
        'Odd'
        'Even'
        'Mark'
        'Space')
    end
  end
  object GroupBox2: TGroupBox
    Left = 200
    Top = 16
    Width = 201
    Height = 185
    Caption = ' Handshaking '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Label5: TLabel
      Left = 8
      Top = 36
      Width = 73
      Height = 16
      Caption = 'Flow Control'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 48
      Top = 104
      Width = 28
      Height = 16
      Caption = 'RTS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 48
      Top = 128
      Width = 29
      Height = 16
      Caption = 'DTR'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object FlowControl: TComboBox
      Left = 88
      Top = 32
      Width = 89
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      TabOrder = 0
      Text = 'None'
      Items.Strings = (
        'None'
        'RTS/CTS'
        'DTR/DSR'
        'X-On/X-Off')
    end
    object RTS_On: TCheckBox
      Left = 88
      Top = 104
      Width = 97
      Height = 17
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object DTR_On: TCheckBox
      Left = 88
      Top = 128
      Width = 97
      Height = 17
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object GroupBox3: TGroupBox
    Left = 400
    Top = 16
    Width = 153
    Height = 185
    Caption = ' Special Chars '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object Label8: TLabel
      Left = 32
      Top = 36
      Width = 29
      Height = 16
      Caption = 'X-On'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 28
      Top = 100
      Width = 34
      Height = 16
      Caption = 'Event'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 32
      Top = 132
      Width = 29
      Height = 16
      Caption = 'Error'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 32
      Top = 68
      Width = 28
      Height = 16
      Caption = 'X-Off'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Event_On: TCheckBox
      Left = 128
      Top = 96
      Width = 17
      Height = 17
      TabOrder = 0
      OnClick = Event_OnClick
    end
    object Error_On: TCheckBox
      Left = 128
      Top = 128
      Width = 17
      Height = 17
      TabOrder = 1
      OnClick = Error_OnClick
    end
    object XON_Val: TMaskEdit
      Left = 72
      Top = 32
      Width = 49
      Height = 24
      EditMask = 'AA;1;_'
      MaxLength = 2
      TabOrder = 2
      Text = '11'
    end
    object XOFF_Val: TMaskEdit
      Left = 72
      Top = 64
      Width = 49
      Height = 24
      EditMask = 'AA;1;_'
      MaxLength = 2
      TabOrder = 3
      Text = '13'
    end
    object Event_Val: TMaskEdit
      Left = 72
      Top = 96
      Width = 49
      Height = 24
      Enabled = False
      EditMask = 'AA;1;_'
      MaxLength = 2
      TabOrder = 4
      Text = '00'
    end
    object Error_Val: TMaskEdit
      Left = 72
      Top = 128
      Width = 49
      Height = 24
      Enabled = False
      EditMask = 'AA;1;_'
      MaxLength = 2
      TabOrder = 5
      Text = '00'
    end
  end
  object Button2: TButton
    Left = 320
    Top = 216
    Width = 97
    Height = 33
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = Button2Click
  end
end
