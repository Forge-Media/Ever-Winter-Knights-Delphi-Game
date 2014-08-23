unit CharacterU;
//The character class which inherits fields from the Base Class.
interface

  uses BaseU, Sysutils, Dialogs;

  Type TCharacter = class(TBase)
    Private
      SaveID: String; //A date & time ID value used to check if player has past save.
      Naam: String;
      Quest: Integer;
    Protected
    Public
      Constructor Create(Lvl,HP,ATP,M,XP,YP,Q: Integer; Na,ID: String);
      //Accessor
      Function GetSaveID: String;
      Function GetNaam: String;
      Function GetQuest: Integer;
      //Mutator
      Procedure SetSaveID(ID: String);
      Procedure SetNaam(Na: String);
      Procedure SetQuest(Q: Integer);
      //Other
  end;

Var
  TheCharacter: TCharacter;

implementation

{ TCharacter }

constructor TCharacter.Create(Lvl,HP,ATP,M,XP,YP,Q: Integer; Na,ID: String);
begin
  Inherited Create(Lvl,HP,ATP,M,XP,YP);
  SaveID:= ID;
  Naam:= Na;
  Quest:= Q;
end;

//Accessor Methods
function TCharacter.GetNaam: String;
begin
  Result:= Naam;
end;

function TCharacter.GetQuest: Integer;
begin
  Result:= Quest
end;

function TCharacter.GetSaveID: String;
begin
  Result:= SaveID;
end;

//Mutator Methods
procedure TCharacter.SetNaam(Na: String);
begin
  Naam:= Na;
end;

procedure TCharacter.SetQuest(Q: Integer);
begin
  Quest:= Q;
end;

procedure TCharacter.SetSaveID(ID: String);
begin
  SaveID:= ID;
end;

end.
