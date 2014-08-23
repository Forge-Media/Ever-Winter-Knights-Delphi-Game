unit MenuUI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, CharacterU, LoadUI, HelpUI, GameUI, EntityU, MapU, DBU, MMSystem;

type
  TFrmMenuUI = class(TForm)
    ImgMenu: TImage;
    ImgNewGame: TImage;
    ImgLoadGame: TImage;
    ImgHelp: TImage;
    FadeTimer: TTimer;
    procedure ImgNewGameMouseEnter(Sender: TObject);
    procedure ImgNewGameMouseLeave(Sender: TObject);
    procedure ImgLoadGameMouseEnter(Sender: TObject);
    procedure ImgLoadGameMouseLeave(Sender: TObject);
    procedure ImgHelpMouseEnter(Sender: TObject);
    procedure ImgHelpMouseLeave(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FadeTimerTimer(Sender: TObject);
    procedure ImgNewGameClick(Sender: TObject);
    procedure ImgLoadGameClick(Sender: TObject);
    procedure ImgHelpClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    Procedure BuildGame(var IsNew: Boolean; WhSave: String);
  end;

var
  FrmMenuUI: TFrmMenuUI;

implementation

{$R *.dfm}

//The method used to load all forms, call all constructor methods
//when starting a new game or loaded one.
procedure TFrmMenuUI.BuildGame(var IsNew: Boolean; WhSave: String);
var
  Naam,SaveID , NaamSQL, MapNaam, MapNaamSQL: String;
  Quest, Level, Life, ATPoints, Map, XPos, YPos: Integer;
  QuestSQl, LevelSQL, LifeSQL, ATPointsSQL, MapSQL, XPosSQL, YPosSQL: String;

begin

  If IsNew = True //Checks if this is a new game or a loaded game.
    Then Begin
      Naam:= Inputbox('Please Enter:','Your Character Name','Ichigo Kurosaki');
      While Length(Naam) > 20 do
        Begin
          Naam:= Inputbox('Please Enter:','Your Character Name'+#13+'Name can not be longer than 20 characters','Sherlock Holmes');
        End;
      SaveID:= DateToStr(Date)+' '+TimeToStr(Time);
      Quest:= 1;
      Level:= 1;
      Life:= 1;
      ATPoints:= 0;
      Map:= 1;
      XPos:= 1; //Determined by the starting location of starting map.
      YPos:= 18; //Determined by the starting location of starting map.
    End
    Else begin
      SaveID:= WhSave;

      NaamSQL:= 'SELECT SavedName FROM tblSavedGame WHERE SavedTime LIKE "'+WhSave+'"';
      Naam:=  (Query(NaamSQL));

      NaamSQL:= 'SELECT SavedName FROM tblSavedGame WHERE SavedTime LIKE "'+WhSave+'"';
      Naam:=  (Query(NaamSQL));

      QuestSQL:= 'SELECT SavedQuest FROM tblSavedGame WHERE SavedTime LIKE "'+WhSave+'"';
      Quest:= strtoint((Query(QuestSQL)));

      LevelSQL:= 'SELECT SavedLevel FROM tblSavedGame WHERE SavedTime LIKE "'+WhSave+'"';
      Level:= strtoint((Query(LevelSQL)));

      LifeSQL:= 'SELECT SavedLife FROM tblSavedGame WHERE SavedTime LIKE "'+WhSave+'"';
      Life:=  strtoint((Query(LifeSQL)));

      ATPointsSQL:= 'SELECT SavedATPoints FROM tblSavedGame WHERE SavedTime LIKE "'+WhSave+'"';
      ATPoints:=  strtoint((Query(ATPointsSQL)));

      MapSQL:= 'SELECT SavedLocation FROM tblSavedGame WHERE SavedTime LIKE "'+WhSave+'"';
      Map:= strtoint((Query(MapSQL)));

      XPosSQL:= 'SELECT SavedXPos FROM tblSavedGame WHERE SavedTime LIKE "'+WhSave+'"';
      XPos:=  strtoint((Query(XPosSQL)));

      YPosSQL:= 'SELECT SavedYPos FROM tblSavedGame WHERE SavedTime LIKE "'+WhSave+'"';
      YPos:=  strtoint((Query(YPosSQL)));
    end;
  FrmMenuUI.Hide;
  sndPlaySound(nil, SND_ASYNC or SND_LOOP);
  FrmGameUI.Show;
  TheCharacter:= TCharacter.Create(Level, Life, ATPoints, Map, XPos, YPos, Quest, Naam, SaveID);
  TheEntity:= TEntity.Create;
  TheEntity.CalcOpponentArray;

  //Neccissary to always be loaded, independant on new game or load game.
  MapNaamSQL:= 'SELECT MapName FROM tblMaps WHERE MapNumber LIKE "'+inttostr(Map)+'"';
  MapNaam:= (Query(MapNaamSQL));

  TheMap:= TMap.Create(MapNaam);

  //Setts up form.
  TheMap.CalcVirtualGrid; //Used to populate the virtual grid.
  FrmGameUI.UpdateForm;
end;

//Play music on form create
procedure TFrmMenuUI.FormCreate(Sender: TObject);
begin
  
  OpenDB;
end;

procedure TFrmMenuUI.FormShow(Sender: TObject);
begin
  sndPlaySound('tdGame\music\EverWinterKnights.wav', SND_ASYNC or SND_LOOP);
end;

//Start a new game
procedure TFrmMenuUI.ImgNewGameClick(Sender: TObject);
var
  isNew: Boolean;
begin
  isNew:= True;
  BuildGame(isNew,'');
end;

//Load game form
procedure TFrmMenuUI.ImgLoadGameClick(Sender: TObject);
begin
  FrmLoadUI.Show;
end;

//Menu option mouse effects
procedure TFrmMenuUI.ImgLoadGameMouseEnter(Sender: TObject);
begin
  imgLoadGame.Picture.LoadFromFile('tdGame\images\buttons\Load_Game_Over.jpg');
end;

procedure TFrmMenuUI.ImgLoadGameMouseLeave(Sender: TObject);
begin
  imgLoadGame.Picture.LoadFromFile('tdGame\images\buttons\Load_Game.jpg');
end;

procedure TFrmMenuUI.ImgNewGameMouseEnter(Sender: TObject);
begin
  imgNewGame.Picture.LoadFromFile('tdGame\images\buttons\New_Game_Over.jpg');
end;

procedure TFrmMenuUI.ImgNewGameMouseLeave(Sender: TObject);
begin
  imgNewGame.Picture.LoadFromFile('tdGame\images\buttons\New_Game.jpg');
end;

procedure TFrmMenuUI.ImgHelpClick(Sender: TObject);
begin
  FrmHelpUI.Show;
end;

procedure TFrmMenuUI.ImgHelpMouseEnter(Sender: TObject);
begin
  imgHelp.Picture.LoadFromFile('tdGame\images\buttons\Help_Over.jpg');
end;

procedure TFrmMenuUI.ImgHelpMouseLeave(Sender: TObject);
begin
  imgHelp.Picture.LoadFromFile('tdGame\images\buttons\Help.jpg');
end;

//Menu fader
procedure TFrmMenuUI.FadeTimerTimer(Sender: TObject);
begin
  if FrmMenuUI.AlphaBlendValue >= 255
    then FadeTimer.Enabled := false
    else FrmMenuUI.AlphaBlendValue := FrmMenuUI.AlphaBlendValue + 3;
end;

end.


