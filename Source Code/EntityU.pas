unit EntityU;
//This class holds all the opponent classes.
interface

  uses Sysutils, Dialogs, MapU, CharacterU, OpponentU, BaseU, GameUI, DBU, MMSystem;

  Type TEntity = class

    Private
      OppArr: Array[1..20] of TBase;
      Size: Integer;
      Index: Integer; //Which opponent in array to attack.
    Protected
    Public
      Constructor Create;
      //Other
      Procedure CalcOpponentArray;
      Function CalcOppCollision(FX, FY: Integer): Boolean;
      Procedure CalcCharAction;
      Procedure CalcOppAction;
      Function CalcAttack: Boolean;
      Procedure CalcOppDeath;
      Procedure CalcGameWin;
      Procedure CalcGameLoss;
      Procedure SaveGame;

  end;

Var
  TheEntity: TEntity;

implementation

{ TEntity }

Uses MenuUI;

constructor TEntity.Create;
begin

end;

procedure TEntity.CalcOpponentArray;
Var
  OppCntSQL, OppMapSQL, OppLVLSQL,OppHPSQL, OppATPSQL, OppXPosSQL, OppYPosSQL :String;
  OppCnt, Loop, OppMap, OppLVL, OppHP, OppATP, OppXPos, OppYPos: Integer;
begin
  loop:= 1;
  Size:= 0;
  index:= 0;
  OppCntSQL:= 'SELECT Count(OppNumber) AS OppCnt FROM tblOpponents';
  OppCnt:= strtoint((Query(OppCntSQL)));
  For loop:= 1 to OppCnt do
    Begin
    OppMapSQL:= 'SELECT OppMap FROM tblOpponents WHERE OppNumber LIKE "'+inttostr(loop)+'"';
    OppMap:= strtoint((Query(OppMapSQL)));
      If OppMap = TheCharacter.GetMap
        Then begin
          OppLVLSQL:= 'SELECT OppLVL FROM tblOpponents WHERE OppNumber LIKE "'+inttostr(loop)+'"';
          OppHPSQL:= 'SELECT OppHP FROM tblOpponents WHERE OppNumber LIKE "'+inttostr(loop)+'"';
          OppATPSQL:= 'SELECT OppATP FROM tblOpponents WHERE OppNumber LIKE "'+inttostr(loop)+'"';
          OppXPosSQL:= 'SELECT OppXPos FROM tblOpponents WHERE OppNumber LIKE "'+inttostr(loop)+'"';
          OppYPosSQL:= 'SELECT OppYPos FROM tblOpponents WHERE OppNumber LIKE "'+inttostr(loop)+'"';
          OppLVL:= strtoint((Query(OppLVLSQL)));
          OppHP:= strtoint((Query(OppHPSQL)));
          OppATP:= strtoint((Query(OppATPSQL)));
          OppXPos:= strtoint((Query(OppXPosSQL)));
          OppYPos:= strtoint((Query(OppYPosSQL)));
          Inc(Size); //increase size of array.
          OppArr[Size]:= TOpponent.Create(OppLVL, OppHP, OppATP, OppMap, OppXPos, OppYPos);
        end;
    End;
end;

function TEntity.CalcOppCollision(FX, FY: Integer): Boolean;
Var
  Flag:Boolean;
begin
  Index:=1;
  Flag:= False;
    While (Flag = False) AND (Index <= Size) do
      Begin If ((OppArr[Index].GetXPos) = FX) AND ((OppArr[Index].GetYPos) = FY)
        Then Flag:= True
        Else Inc(Index)
      End;

  If Flag = true
    Then Result:= True //Yes you have collided with an opponnent
    Else Result:= False; //No you have collided with an opponnent
end;


Function TEntity.CalcAttack: Boolean; //The characters attack.
Var
  Flag: boolean;
begin
  Flag:= False;
  If (TheCharacter.GetXPos-1 <> 0) OR (TheCharacter.GetXPos+1 <> 32)
    Then If (TheCharacter.GetYPos-1 <> 0) OR (TheCharacter.GetXPos+1 <> 21)
      Then Begin
        If CalcOppCollision(TheCharacter.GetXPos-1,TheCharacter.GetYPos) = true
          Then Flag:= True
          Else If CalcOppCollision(TheCharacter.GetXPos+1,TheCharacter.GetYPos) = true
            Then Flag:= True
            Else If CalcOppCollision(TheCharacter.GetXPos,TheCharacter.GetYPos-1) = true
              Then Flag:= True
              Else If CalcOppCollision(TheCharacter.GetXPos,TheCharacter.GetYPos+1) = true
                Then Flag:= True;
      End;
  Result:= Flag;
end;

procedure TEntity.CalcOppAction;
begin
  If CalcAttack = True
    Then Begin
      TheCharacter.SetLife(TheCharacter.GetLife - OppArr[Index].GetATPoints);
      CalcGameLoss;
    End;
end;

procedure TEntity.CalcCharAction;
begin
  If CalcAttack = True
    Then begin
      OppArr[Index].SetLife(OppArr[Index].GetLife - TheCharacter.GetATPoints);
      If OppArr[Index].GetLife < 1
        Then CalcOppDeath;  //CODE FOR DELETION.
    end;
end;

procedure TEntity.CalcOppDeath;
Var
  loop: Integer;
  Temp: TBase;

begin
  OppArr[Index].Destroy; //Destroy opponent class.
  For loop:= Index+1 to size do
    begin
      Temp:= OppArr[loop];
      OppArr[loop-1]:= temp;
    end;
      Dec(size);
      FrmGameUI.SortImgArr(Index);
end;

procedure TEntity.CalcGameLoss;
Var
  Loop: Integer;
begin
  If TheCharacter.GetLife < 1
    Then Begin
      FrmGameUI.TimOppAI.Enabled:= False; //Must happen first.
      FrmGameUI.TimAttack.Enabled:= False;
      FrmGameUI.TimAnimator.Enabled:= False;
      FrmGameUI.ImgChar.Picture.LoadFromFile('tdGame/images/chars/CharDeath.bmp');
      FrmGameUI.ImgChar.Left:= FrmGameUI.ImgChar.Left - 25;
      FrmGameUI.ImgChar.Top:= FrmGameUI.ImgChar.top + 25;
      Showmessage('Active Quest Failed');
      TheCharacter.Destroy;
      TheMap.Destroy;
      TheEntity.Destroy;
      With FrmGameUI do
      begin
        For Loop:= 1 to cnt do
          begin
            ImgArr[loop].Destroy; //Clear array of opp images.
          end;
        Cnt:= 0;
    end;
      FrmGameUI.Hide; //Or maybe just reload from prviouse save.
      sndPlaySound(nil, SND_ASYNC or SND_LOOP);
      FrmMenuUI.Show;
    End;
end;


//Only called when completing a quest.
procedure TEntity.CalcGameWin;
Var
  CheckSQL: String;
  GameWin: Integer;
begin
  CheckSQL:= 'SELECT Count(*) AS FinalQuest FROM tblQuests';
  GameWin:= strtoint(Query(CheckSQL));
  //Showmessage(inttostr(GameWin));
  //Checks to see if the player’s quest is the same as that of the final quest
  If TheCharacter.GetQuest = GameWin+1
    Then begin
      Showmessage('Congratulations on finishing Ever Winter Knights'+#13+'Finally after decades of winter you have restored summer');
      TheMap.CalcMapMove('I5(1:18)');
      FrmGameUI.UpdateForm;
    end;

end;

procedure TEntity.SaveGame;
Var
  CheckSQL, SaveSQL, TempID: String;
  SavedTime: String; //Used for a new save!
begin
  SavedTime:= DateToStr(Date)+' '+TimeToStr(Time);

  CheckSQL:= 'SELECT SavedTime FROM tblSavedGame WHERE SavedTime Like "'+TheCharacter.GetSaveID+'"';
  TempID:= (Query(CheckSQL));

  //Checks to see if player has previous save
  If TempID = TheCharacter.GetSaveID
  Then begin //Will only update their previous save
    SaveSQL:= 'UPDATE tblSavedGame SET ' +
    'SavedTime = "'+SavedTime+'" ,' +
    'SavedName = "'+TheCharacter.GetNaam+'" ,' +
    'SavedQuest = "'+inttostr(TheCharacter.GetQuest)+'" ,' +
    'SavedLocation = "'+inttostr(TheCharacter.GetMap)+'" ,' +
    'SavedLevel = "'+inttostr(TheCharacter.GetLevel)+'" ,' +
    'SavedLife = "'+inttostr(TheCharacter.GetLife)+'" ,' +
    'SavedATPoints = "'+inttostr(TheCharacter.GetATPoints)+'" ,' +
    'SavedXPos = "'+inttostr(TheCharacter.GetXpos)+'" ,' +
    'SavedYPos = "'+inttostr(TheCharacter.GetYpos)+'" WHERE SavedTime LIKE "'+TheCharacter.GetSaveID+'"';
    Change(SaveSQL)
  end
  Else
    begin
      SaveSQL:= 'INSERT INTO tblSavedGame VALUES("'+SavedTime+'","'+TheCharacter.GetNaam+'","'+inttostr(TheCharacter.GetQuest)+'","'+inttostr(TheCharacter.GetMap)+'","'+inttostr(TheCharacter.GetLevel)+'","'+inttostr(TheCharacter.GetLife)+'","'+inttostr(TheCharacter.GetATPoints)+'","'+inttostr(TheCharacter.GetXPos)+'","'+inttostr(TheCharacter.GetYPos)+'")';
      Change(SaveSQL)
    end;
    TheCharacter.SetSaveID(SavedTime);
    Showmessage('Game Saved!');
end;

end.
