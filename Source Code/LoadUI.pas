unit LoadUI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, DBU, ComCtrls, MMSystem;

type
  TFrmLoadUI = class(TForm)
    ImgLoadGame: TImage;
    ImgLoad: TImage;
    ImgDelete: TImage;
    ImgDeleteAll: TImage;
    LstLoad: TListBox;
    procedure ImgLoadMouseEnter(Sender: TObject);
    procedure ImgLoadMouseLeave(Sender: TObject);
    procedure ImgDeleteMouseEnter(Sender: TObject);
    procedure ImgDeleteMouseLeave(Sender: TObject);
    procedure ImgDeleteAllMouseEnter(Sender: TObject);
    procedure ImgDeleteAllMouseLeave(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImgDeleteClick(Sender: TObject);
    procedure LstLoadClick(Sender: TObject);
    procedure ImgDeleteAllClick(Sender: TObject);
    procedure ImgLoadClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    Procedure Load;
  public
    { Public declarations }
  end;

var
  FrmLoadUI: TFrmLoadUI;
  Index: Integer;
implementation

{$R *.dfm}

uses MenuUI;

//Menu option mouse effects
procedure TFrmLoadUI.Load;
Var
  LoadSQL, Temp, Time, Name: String;
begin
  LstLoad.Clear;
  LstLoad.Items.Add('Saved Time:                       Saved Name:');

  LoadSQL:= 'SELECT SavedTime, SavedName FROM tblSavedGame';
  Change(LoadSQL);
  MyDb.Open;
  MyDb.First;
  While not myDB.Eof do
    Begin
      Time:= MyDb.Fields.FieldByName('SavedTime').AsString;
      Name:= MyDb.Fields.FieldByName('SavedName').AsString;
      Temp:= Time+'     '+Name;
      LstLoad.Items.Append(Temp);
      MyDB.Next;
    end;
end;

//Sets up the form using the load procedure.
procedure TFrmLoadUI.FormHide(Sender: TObject);
begin
  FrmMenuUI.Enabled:= True;;
end;

procedure TFrmLoadUI.FormShow(Sender: TObject);
begin
  Load;
  FrmMenuUI.Enabled:= False;
end;

Function TimeExtract(FLine: String): String;
Var
  Posi: Integer;
begin
  Posi:= Pos('M',FLine);
  Result:= Copy(FLine,1,Posi)
end;

//Selection based save deletion.
procedure TFrmLoadUI.ImgDeleteClick(Sender: TObject);
Var
  Save, DeleteSQL: String;
begin
 If Index = 0
    Then Showmessage('Invalid Selection')
    Else
      If (MessageDlg('Delete Selected Save?'+' Yes or No?'+#13+'Deleted save will be lost forever!',
        mtConfirmation, [mbYes, mbNo],0) = mrYes)
          Then begin //Deletion based on SavedTime.
            Save:= TimeExtract(LstLoad.Items[Index]);
            DeleteSQL:= 'DELETE * FROM tblSavedGame WHERE SavedTime LIKE "'+Save+'"';
            Change(DeleteSQL);
            Load;
          end;

end;

//All save deletion.
procedure TFrmLoadUI.ImgDeleteAllClick(Sender: TObject);
Var
  DeleteSQL: String;
begin
  If (MessageDlg('Delete All Saves?'+' Yes or No?'+#13+'Deleted saves will be lost forever!',
    mtConfirmation, [mbYes, mbNo],0) = mrYes)
      Then begin //Deletes every save.
        DeleteSQL:= 'DELETE * FROM tblSavedGame';
        Change(DeleteSQL);
        Load;
      end;
end;

procedure TFrmLoadUI.ImgDeleteAllMouseEnter(Sender: TObject);
begin
  ImgDeleteAll.Picture.LoadFromFile('tdGame\images\buttons\Delete_All_Over.jpg');
end;

procedure TFrmLoadUI.ImgDeleteAllMouseLeave(Sender: TObject);
begin
  ImgDeleteAll.Picture.LoadFromFile('tdGame\images\buttons\Delete_All.jpg');
end;

procedure TFrmLoadUI.ImgDeleteMouseEnter(Sender: TObject);
begin
  ImgDelete.Picture.LoadFromFile('tdGame\images\buttons\Delete_Over.jpg');
end;

procedure TFrmLoadUI.ImgDeleteMouseLeave(Sender: TObject);
begin
  ImgDelete.Picture.LoadFromFile('tdGame\images\buttons\Delete.jpg');
end;

procedure TFrmLoadUI.ImgLoadClick(Sender: TObject);
Var
  Load: String;
  isLoad: Boolean;
begin
  isLoad:= False;
  If Index = 0
    Then Showmessage('Invalid Selection')
    Else
      If (MessageDlg('Load the selected save?'+' Yes or No?'+#13+TimeExtract(LstLoad.Items[Index]),
        mtConfirmation, [mbYes, mbNo],0) = mrYes)
          Then begin //Deletion based on SavedTime.
            Load:= TimeExtract(LstLoad.Items[Index]);
            FrmMenuUI.BuildGame(isLoad,Load);
            Hide;
          end;
end;

procedure TFrmLoadUI.ImgLoadMouseEnter(Sender: TObject);
begin
  ImgLoad.Picture.LoadFromFile('tdGame\images\buttons\Load_Over.jpg');
end;

procedure TFrmLoadUI.ImgLoadMouseLeave(Sender: TObject);
begin
  ImgLoad.Picture.LoadFromFile('tdGame\images\buttons\Load.jpg');
end;

//Recieve Listbox selection index.
procedure TFrmLoadUI.LstLoadClick(Sender: TObject);
begin
  Index:= LstLoad.ItemIndex;
end;

end.
