unit HelpUI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, ComCtrls, MPlayer;

type
  TFrmHelpUI = class(TForm)
    ImgHelp: TImage;
    RchGameHelp: TRichEdit;
    AniMov: TAnimate;
    LblInstA: TLabel;
    LblLeftRight: TLabel;
    LblUpDown: TLabel;
    LblDiag: TLabel;
    LblItem: TLabel;
    LblAttack: TLabel;
    MPActMov: TMediaPlayer;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LblLeftRightClick(Sender: TObject);
    procedure LblUpDownClick(Sender: TObject);
    procedure LblDiagClick(Sender: TObject);
    procedure LblItemClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure LblAttackClick(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  FrmHelpUI: TFrmHelpUI;
implementation

{$R *.dfm}

procedure TFrmHelpUI.FormCreate(Sender: TObject);
Var
  RamFile: TextFile;
  Line: String;
  Size: Integer;
begin
  Size:= 0;
  AssignFile(RamFile,'tdGame\help\Help.txt');
  If FileExists('tdGame\help\Help.txt')
    Then Reset(RamFile)
    Else Rewrite(RamFile);
  Reset(RamFile);
  While not EOF(RamFile) do
    begin
      ReadLN(RamFile,Line);
      RchGameHelp.Lines.Add(Line)
    end;
  CloseFile(RamFile);
end;

procedure TFrmHelpUI.FormHide(Sender: TObject);
begin
  MPActMov.Close;
  MPActMov.Enabled:= False;
end;

procedure TFrmHelpUI.FormShow(Sender: TObject);
begin
    MPActMov.Enabled:= True;
    MPActMov.AutoRewind:= true;
    MPActMov.FileName:= 'tdGame\movies\LeftRight.avi';
    MPActMov.Open;
    MPActMov.Play;
end;

procedure TFrmHelpUI.LblAttackClick(Sender: TObject);
begin
  MPActMov.FileName:= 'tdGame\movies\Attack.avi';
  MPActMov.Open;
  MPActMov.Play;
end;

procedure TFrmHelpUI.LblDiagClick(Sender: TObject);
begin
  MPActMov.FileName:= 'tdGame\movies\Diag.avi';
  MPActMov.Open;
  MPActMov.Play
end;

procedure TFrmHelpUI.LblItemClick(Sender: TObject);
begin
  MPActMov.FileName:= 'tdGame\movies\Item.avi';
  MPActMov.Open;
  MPActMov.Play
end;

procedure TFrmHelpUI.LblLeftRightClick(Sender: TObject);
begin
  MPActMov.FileName:= 'tdGame\movies\LeftRight.avi';
  MPActMov.Open;
  MPActMov.Play
end;

procedure TFrmHelpUI.LblUpDownClick(Sender: TObject);
begin
  MPActMov.FileName:= 'tdGame\movies\UpDown.avi';
  MPActMov.Open;
  MPActMov.Play
end;

end.
