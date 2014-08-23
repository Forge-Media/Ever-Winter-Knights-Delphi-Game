unit QuestUI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, jpeg, ExtCtrls, CharacterU, DBU;

type
  TFrmQuestUI = class(TForm)
    ImgQuest: TImage;
    LstCompQuests: TListBox;
    RchActiveQuest: TRichEdit;
    procedure FormShow(Sender: TObject);
  private
    Procedure GetActiveQuest;
    Procedure GetCompletedQuests;
  public
    { Public declarations }
  end;

var
  FrmQuestUI: TFrmQuestUI;

implementation

{$R *.dfm}
procedure TFrmQuestUI.GetActiveQuest;
Var
  QuestNameSQL, QuestDesSQL, QuestExpSQL, QuestAwdSQL: String;
  QuestName, QuestDes, QuestExp, QuestAwd: String;
  StructuredOutcome: String;
begin
  QuestNameSQL:= 'SELECT QuestName FROM tblQuests WHERE QuestNumber LIKE "'+inttostr(TheCharacter.GetQuest)+'"';
  QuestName:= (Query(QuestNameSQL));

  QuestDesSQL:= 'SELECT QuestDescription FROM tblQuests WHERE QuestNumber LIKE "'+inttostr(TheCharacter.GetQuest)+'"';
  QuestDes:= (Query(QuestDesSQL));

  QuestExpSQL:= 'SELECT QuestExpLvl FROM tblQuests WHERE QuestNumber LIKE "'+inttostr(TheCharacter.GetQuest)+'"';
  QuestExp:= (Query(QuestExpSQL));

  QuestAwdSQL:= 'SELECT QuestAwdLvl FROM tblQuests WHERE QuestNumber LIKE "'+inttostr(TheCharacter.GetQuest)+'"';
  QuestAwd:= (Query(QuestAwdSQL));

  StructuredOutcome:= QuestName+#13+#13+'Quest Description:'+#13+QuestDes+#13+#13+'Expected Level:'+#9+QuestExp+#13+#13+'Awarded Level:'+#9+QuestAwd;
  RchActiveQuest.Clear;
  RchActiveQuest.Lines.Add(StructuredOutcome);
end;

procedure TFrmQuestUI.GetCompletedQuests;
Var
  QuestSQL, Quest, Temp: String;
  Loop: integer;
begin
  LstCompQuests.Clear;
  LstCompQuests.Items.Add('Quest Name:                              Saved:');
  For Loop:= 1 to TheCharacter.GetQuest-1 do
    begin
      QuestSQL:= 'SELECT QuestName FROM tblQuests WHERE QuestNumber LIKE "'+inttostr(Loop)+'"';
      Change(QuestSQL);
  MyDb.Open;
  MyDb.First;
  While not myDB.Eof do
    Begin
      Quest:= MyDb.Fields.FieldByName('QuestName').AsString;
      Temp:= Quest+'     '+'Saved';
      LstCompQuests.Items.Append(Temp);
      MyDB.Next;
    end;
  end;
end;

procedure TFrmQuestUI.FormShow(Sender: TObject);
begin
  GetActiveQuest;
  GetCompletedQuests;
end;


end.
