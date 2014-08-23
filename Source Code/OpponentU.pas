unit OpponentU;
//The opponent class which inherits fields from the Base Class.
interface

  uses BaseU, Sysutils, Graphics, jpeg,  GameUI, ExtCtrls;

  Type TOpponent = class(TBase)
    Private
    Protected
      XPos, YPos: Integer;
      Enemy: TBitmap;
    Public
    Constructor Create(Lvl,HP,ATP,M,XP,YP: Integer);

  end;

Var
  AnOpponent: TOpponent;

implementation

{ TOpponent }

constructor TOpponent.Create(Lvl, HP, ATP, M, XP, YP: Integer);
begin
  Inherited Create(Lvl,HP,ATP,M,XP,YP);
  Xpos:= ((25*XP)-25);
  YPos:= ((25*YP)+15);
  With FrmGameUI do
    begin
      Inc(Cnt);
      ImgArr[cnt]:= TImage.create(FrmGameUI);
      ImgArr[Cnt].Parent:= FrmGameUI;
      ImgArr[Cnt].Picture.LoadFromFile('tdGame/images/opponents/'+inttostr(Lvl)+'.bmp');
      ImgArr[cnt].AutoSize:= True;
      ImgArr[cnt].Transparent:= True;
      ImgArr[cnt].ShowHint:= True;
      ImgArr[cnt].Hint:= 'LVL:'+inttostr(LVL)+' HP:'+inttostr(HP);
      ImgArr[cnt].Left:= Xpos;
      ImgArr[cnt].Top:= YPos;

    end;
end;

end.
