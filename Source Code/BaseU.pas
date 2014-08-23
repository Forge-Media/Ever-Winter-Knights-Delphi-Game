unit BaseU;
//This class is the basic structure of both the character and the opponent classes.
interface

Type TBase= class

    Private
    Protected
      Level, Life, ATPoints, Map, XPos, YPos: Integer ; //Inherited fields
    Public
      Constructor Create(Lvl,HP,ATP,M,XP,YP: Integer);
      //Accessor
      Function GetLevel: Integer;
      Function GetLife: Integer;
      Function GetATPoints: Integer;
      Function GetMap: Integer;
      Function GetXPos: Integer;
      Function GetYPos: Integer;
      //Mutator
      Procedure SetLevel(Lvl: Integer);
      Procedure SetLife(HP: Integer);
      Procedure SetATPoints(ATP: Integer);
      Procedure SetMap(M: Integer);
      Procedure SetXPos(XP: Integer);
      Procedure SetYPos(YP: Integer);
  end;

Var
  TheBase: TBase;

implementation

{ TBase }

constructor TBase.Create(Lvl, HP, ATP, M, XP, YP: Integer);
begin
  Level:= lvl;
  Life:= HP;
  ATPoints:= ATP;
  Map:= M;
  Xpos:= XP;
  YPos:= YP;
end;

//Accessor Methods
function TBase.GetATPoints: Integer;
begin
  Result:= ATPoints;
end;

function TBase.GetLevel: Integer;
begin
  Result:= Level;
end;

function TBase.GetLife: Integer;
begin
  Result:= Life;
end;

function TBase.GetMap: Integer;
begin
  Result:= Map;
end;

function TBase.GetXPos: Integer;
begin
  Result:= XPos;
end;

function TBase.GetYPos: Integer;
begin
  Result:= YPos;
end;

//Mutator Methods
procedure TBase.SetATPoints(ATP: Integer);
begin
  ATPoints:= ATP;
end;

procedure TBase.SetLevel(Lvl: Integer);
begin
  Level:= Lvl;
end;

procedure TBase.SetLife(HP: Integer);
begin
  Life:= HP;
end;

procedure TBase.SetMap(M: Integer);
begin
  Map:= M;
end;

procedure TBase.SetXPos(XP: Integer);
begin
  XPos:= XP;
end;

procedure TBase.SetYPos(YP: Integer);
begin
  YPos:= YP;
end;

end.
