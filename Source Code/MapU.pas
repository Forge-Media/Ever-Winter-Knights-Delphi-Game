unit MapU;

interface

uses CharacterU, DBU, sysutils, Dialogs, Controls;

  Type TMap = class

    Private        //Grid is wider than hieght. (X;Y) Co-Ordinates
      ObjArr: Array[1..32,1..20] of string; //Holds values of 'Y',''N','I' for each grid position.
      SizeX, SizeY: Integer;  //Numerical valuea that stores the “size” of the array on the X&Y axis.
      MapName: String; //Used to identify which map player is located at
    Protected

    Public
      Constructor Create(MNa:String);
      //Accessor
      Function GetMapName: String;
      //Mutator
      Procedure SetMapName(MNa:String);
      //Other
      Procedure Extract(FLine: String);
      Procedure CalcVirtualGrid;
      Function CalcMovment(Direction: Char): Boolean;
      Function CalcDiagMovment(Direction: Char): Boolean;
      Function CalcCollision(FX,FY: Integer): Boolean;
      Function CalcDiagCollision(FX,FY: Integer): Boolean;
      Procedure CalcMapMove(New:String);
      Function CalcIsQuestItem(FRef: String): Boolean;
      Function CalcItem: Boolean;
      Procedure Heal;
  end;

Var
  TheMap: TMap;
implementation

{ TMap }

Uses
  EntityU, GameUI;


//Extracts each value from text file to be inserted into the 2D array.
//Used in conjunction with CalcVirtualGrid. WORKS
Procedure TMap.Extract(FLine: String);
var
  Posi: Integer;
begin
  SizeX:= 0;
  While Length(FLine) > 0 do
    begin
      Posi:= pos(',',FLine);
      Inc(SizeX);
      ObjArr[SizeX,SizeY]:= Copy(FLine,1,Posi-1);
      Delete(Fline,1,posi)
    end;
end;

//Builds up the 2D array from a corresponding text file
//WORKS
procedure TMap.CalcVirtualGrid;
Var
  RamFile: TextFile;
  Line: String;
begin
  SizeY:= 0;
  AssignFile(RamFile,'tdMaps/'+(inttostr(TheCharacter.GetMap)+'.txt'));
  If FileExists('tdMaps/'+(inttostr(TheCharacter.GetMap))+'.txt')
    Then Reset(RamFile)
    Else Rewrite(RamFile);
  Reset(RamFile);
  While not EOF(RamFile) do
    Begin
      ReadLN(RamFile,Line);
      Inc(SizeY);
      Extract(Line);
    End;
  CloseFile(RamFile)
end;


//Used to calculate the characters movement in conjunction with the CalcCollision
function TMap.CalcMovment(Direction: Char): Boolean;
Var
  Xpos,YPos, NewMapNum: Integer;
  MapNameSQL, MapName: String;
begin
  XPos:= TheCharacter.GetXPos;
  YPos:= TheCharacter.GetYPos;
  If Direction = 'W'
    Then Ypos:= Ypos-1
    Else If Direction = 'S'
      Then Ypos:= Ypos+1
      Else If Direction = 'D'
        Then Xpos:= Xpos+1
        Else Xpos:= Xpos-1;
  If CalcCollision(XPos,YPos) = True //Calls collision checker.
    Then Begin
      TheCharacter.SetXPos(Xpos);
      TheCharacter.SetYPos(Ypos);
      If Uppercase(ObjArr[XPos,YPos][1]) = 'M'
        Then begin
          NewMapNum:= strtoint(Copy((ObjArr[XPos,YPos][2]),1,1));;
          MapNameSQL:= 'SELECT MapName FROM tblMaps WHERE MapNumber LIKE "'+inttostr(NewMapNum)+'"';
          MapName:= (Query(MapNameSQL));
            If (MessageDlg('Travel to: '+MapName+'?',
                mtConfirmation, [mbYes, mbNo],0) = mrYes)
              Then CalcMapMove(ObjArr[XPos,YPos]);
        end;
      Result:= True; //On screen movement can take place.
    End
    Else Result:= False;
end;

//Used to calculate the characters diagonal movement in conjunction with the CalcDiagCollision
function TMap.CalcDiagMovment(Direction: Char): Boolean;
Var
  Xpos,YPos: Integer;
begin
  XPos:= TheCharacter.GetXPos;
  YPos:= TheCharacter.GetYPos;
  If Direction = 'Q'
    Then Begin
      Ypos:= Ypos-1;
      Xpos:= Xpos-1
    End
    Else If Direction = 'E'
      Then Begin
        Ypos:= Ypos-1;
        Xpos:= Xpos+1
      End
      Else If Direction = 'Z'
        Then Begin
          Ypos:= Ypos+1;
          Xpos:= Xpos-1
        End
        Else begin
           Ypos:= Ypos+1;
           Xpos:= Xpos+1;
        end;
  If CalcDiagCollision(XPos,YPos) = True //Calls collision checker.
    Then Begin
      TheCharacter.SetXPos(Xpos);
      TheCharacter.SetYPos(Ypos);
      Result:= True; //On screen movement can take place.
    End
    Else Result:= False;
end;


//DO NOT ALTER IN ANY WAY (true - false) not (false - true)
//Used to calculate whether a collision will occur for next movement.
//Returns a true or false value.
function TMap.CalcCollision(FX, FY: Integer): Boolean;
begin
  If (Fx >= 1) AND (Fx <= (SizeX))
    Then If (FY >= 1) AND (FY <= (SizeY))
      Then If Uppercase(ObjArr[Fx,Fy]) <> 'N'
      Then If (TheEntity.CalcOppCollision(Fx,Fy) = False)
        Then Result:= True
        Else Result:= False;
end;

//Used to calculate whether a collision will occur for next DIAGONAL movement.
function TMap.CalcDiagCollision(FX, FY: Integer): Boolean;
begin
  If (Fx >= 1) AND (Fx <= (SizeX))
    Then If (FY >= 1) AND (FY <= (SizeY))
      Then If Uppercase(ObjArr[Fx,Fy]) = 'D'
        Then If (TheEntity.CalcOppCollision(Fx,Fy) = False)
        Then Result:= True
        Else Result:= False;
end;

//DO NOT ALTER IN ANY WAY!!
procedure TMap.CalcMapMove(New: String);
Var
  NewMapNumber: Integer;
  CopyMapLeng, CopyXleng, CopyYleng: Integer;
  NewXPos, NewYPos: Integer;
  Loop: Integer;
begin
  CopyMapLeng:= pos('(',New);
  NewMapNumber:= strtoint(Copy(New,2,CopyMapLeng-2));

  Delete(New,1,CopyMapLeng-1);

  CopyXleng:= pos(':',New);
  NewXPos:= strtoint(Copy(New,2,CopyXleng-2));

  CopyYleng:= Length(New)-CopyXleng;
  NewYPos:= strtoint(Copy(New,CopyXleng+1,CopyYleng-1));

  //Showmessage(inttostr(NewMapNumber));
  //Showmessage(inttostr(NewXPos));        //Used for debuging!
  //Showmessage(inttostr(NewYPos));
  TheCharacter.SetMap(NewMapNumber);
  TheCharacter.SetXPos(NewXPos);
  TheCharacter.SetYPos(NewYPos);
  CalcVirtualGrid;
  Heal;
  With FrmGameUI do
    begin
      For Loop:= 1 to cnt do
        begin
          ImgArr[loop].Destroy; //Clear array of opp images.
        end;
      Cnt:= 0;
      TimOppAI.Enabled:= False; //While destroying Entity.
    end;

    TheEntity.CalcOpponentArray; //Should call entity create and new opp for new map.
    FrmGameUI.TimOppAI.Enabled:= True; //Re-enables running of opponent procedures.

end;

procedure TMap.Heal;
Var
  SavedHPSQL: string;
  SavedHP: string;
begin
      SavedHPSQL:= 'SELECT SavedLife FROM tblSavedGame WHERE SavedTime LIKE "'+TheCharacter.GetSaveID+'"';
      SavedHP:= Query(SavedHPSQL);
      //Showmessage(TheCharacter.GetSaveID);
      //Showmessage('"'+SavedHP+'"');
      If SavedHP <> ''
        Then TheCharacter.SetLife(strtoint(SavedHP));
end;

function TMap.CalcIsQuestItem(FRef: String): Boolean;
Var
  QuestItemSQL, QuestNumberSQL, QuestItem: String;
  QuestNumber: Integer;
begin
  QuestItemSQL:= 'SELECT QuestItemRef FROM tblQuests WHERE QuestNumber LIKE "'+inttostr(TheCharacter.GetQuest)+'"';
  QuestItem:= (Query(QuestItemSQL)); //What Item does your current quest require?

  QuestNumberSQL:= 'SELECT QuestNumber FROM tblQuests WHERE QuestItemRef LIKE "'+FRef+'"';
  QuestNumber:= strtoint(Query(QuestNumberSQL));

  If (QuestItem = FRef) AND (QuestNumber = TheCharacter.GetQuest) //Is the required quest item the item in 'passed' position?
    Then Result:= True //Yes it is
    Else Result:= False; //No its not.

end;

function TMap.CalcItem: Boolean;
Var
  Xpos,YPos: Integer;
  Cell, ItemNameSQL, ItemName, ItemRef, ItemSQL, MessageSQL, TheMessage, QuestSQL, QuestMessage: String;
  NewATPoints, CheckATP, NewQuest, NewLevel, NewHP: Integer;

begin
  XPos:= TheCharacter.GetXPos;
  YPos:= TheCharacter.GetYPos;
  Cell:= Uppercase(ObjArr[XPos,YPos]);

  If upcase(Cell[1]) = 'I' //Does this position hold an item?
    Then Begin
      ItemRef:= Copy(Cell,2,(Length(Cell)-1)); //What item is held in this possition.
      If (CalcIsQuestItem(ItemRef) = True) //Is this Item a quest item?
        Then Begin //Was a quest item.
          QuestSQL:= 'SELECT QuestName FROM tblQuests WHERE QuestNumber LIKE "'+inttostr(TheCharacter.GetQuest)+'"';
          QuestMessage:= Query(QuestSQL);  //The quest name you have completed.

          ItemNameSQL:= 'SELECT ItemName FROM tblItems WHERE ItemRef LIKE "'+ItemRef+'"';
          ItemName:= Query(ItemNameSQL); //what item have you aquired?

          Showmessage('MISSION COMPLETED!'+#13+QuestMessage+#13+'Item Name: '+ItemName);

          ItemSQL:= 'SELECT ItemATPoints FROM tblItems WHERE ItemRef LIKE "'+ItemRef+'"';
          CheckATP:= strtoint(Query(ItemSQL)); //Does this quest item have an ATP value?

          If (CheckATP <> 0) //Checks that you can't accept an Item with 0 ATP value.
            Then begin
              MessageSQL:= 'SELECT ItemName,ItemATPoints FROM tblItems WHERE ItemRef LIKE "'+ItemRef+'"';
              TheMessage:= 'Item Name:'+#9+'Item AT Points:'+#13+StructuredQuery(MessageSQL);
              //Details of the item!
              If (MessageDlg('Pick up item?'+#13+TheMessage,
              mtConfirmation, [mbYes, mbNo],0) = mrYes) //Do you want this item?
              Then begin
                NewATPoints:= strtoint((Query(ItemSQL)));
                TheCharacter.SetATPoints(NewATPoints);
                Result:= True;
              end;
            end;

          NewQuest:= (TheCharacter.GetQuest)+1;
          TheCharacter.SetQuest(NewQuest); //Ensures a quest item with o ATP will still activate the next quest.

          NewLevel:= (TheCharacter.GetLevel)+1;
          TheCharacter.SetLevel(NewLevel); //Ensures player allways gains level for completing quest.

          NewHP:= (TheCharacter.GetLevel)*(TheCharacter.GetLevel);
          TheCharacter.SetLife(NewHP); //HP is the product of LVL*LVL //Req. Debugging.

          TheEntity.CalcGameWin;
          TheEntity.SaveGame; //Save process after each quest.
        End
        Else Begin //Was not a quest item
          MessageSQL:= 'SELECT ItemName,ItemATPoints FROM tblItems WHERE ItemRef LIKE "'+ItemRef+'"';
          //Is a message and requires structure (#9 & #13)
          TheMessage:= 'Item Name:'+#9+'Item AT Points:'+#13+StructuredQuery(MessageSQL);

          If (MessageDlg('Pick up item?'+#13+TheMessage,
              mtConfirmation, [mbYes, mbNo],0) = mrYes)
            Then begin
              ItemSQL:= 'SELECT ItemATPoints FROM tblItems WHERE ItemRef LIKE "'+ItemRef+'"';
              NewATPoints:= strtoint((Query(ItemSQL)));
              TheCharacter.SetATPoints(NewATPoints);
              Result:= True;
            End;
        end;
end;
end;

//Instantiates the object with the:
//Map Number & Map Name data passed as parameters
constructor TMap.Create(MNa: String);
begin
  MapName:= MNa;
end;

//Returns the Field value
function TMap.GetMapName: String;
begin
  Result:= MapName;
end;

//Changes the Filed value
procedure TMap.SetMapName(MNa: String);
begin
  MapName:= MNa;
end;

end.
