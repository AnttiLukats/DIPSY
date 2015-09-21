unit AboutSpiPro;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls;

type
  TAboutSpiProForm = class(TForm)
    Image1: TImage;
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutSpiProForm: TAboutSpiProForm;

implementation

{$R *.dfm}

procedure TAboutSpiProForm.Image1Click(Sender: TObject);
begin
  Close;
end;

end.
