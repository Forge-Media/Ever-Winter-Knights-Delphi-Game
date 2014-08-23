unit GameUI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, HelpUI, QuestUI, BaseU, CharacterU, MapU,
  ComCtrls, MMSystem, CommCtrl;

type
  TFrmGameUI = class(TForm)
    ImgStatsBar: TImage;
    LblCharName: TLabel;
    LblHP: TLabel;
    LblAT: TLabel;
    ImgQuest: TImage;
    ImgExit: TImage;
    ImgHelp: TImage;
    LblLvl: TLabel;
    ImgMap: TImage;
    ImgChar: TImage;
    TimOppAI: TTimer;
    TimATControl: TTimer;
    PBATP: TProgressBar;
    TimAnimator: TTimer;
    TimAttack: TTimer;
    procedure ImgQuestMouseEnter(Sender: TObject);
    procedure ImgQuestMouseLeave(Sender: TObject);
    procedure ImgHelpMouseLeave(Sender: TObject);
    procedure ImgHelpMouseEnter(Sender: TObject);
    procedure ImgExitMouseEnter(Sender: TObject);
    procedure ImgExitMouseLeave(Sender: TObject);
    procedure ImgHelpClick(Sender: TObject);
    procedure ImgExitClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ImgCharMouseEnter(Sender: TObject);
    procedure ImgQuestClick(Sender: TObject);
    procedure TimATControlTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimOppAITimer(Sender: TObject);
    procedure TimAnimatorTimer(Sender: TObject);
    procedure TimAttackTimer(Sender: TObject);
  private
    { Private declarations }
  public
    Procedure UpdateForm;
    Procedure SortImgArr(PIndex:Integer);
    Procedure StandardMov(PKey: Char);
    Procedure DiagMov(PKey: Char);
  end;

var
  FrmGameUI: TFrmGameUI;
  ImgArr: Array[1..6] of TImage;
  Cnt: Integer;
  Timer: Integer;
  AITimer: Integer;
  AniCnt, AttCnt: Integer;
  Direction: String;
implementation

{$R *.dfm}

  Uses EntityU;

Procedure TFrmGameUI.StandardMov(PKey: Char);
begin
      Case PKey of
      'A':Direction:= 'Left';
      'D':Direction:= 'Right';
      'W':Direction:= 'Up';
      'S':Direction:= 'Down';
      End;
      TimAnimator.Enabled:= True;
      UpdateForm;
end;

procedure TFrmGameUI.DiagMov(PKey: Char);
begin
      Case PKey of
      'Q':Direction:= 'Left';
      'E':Direction:= 'Right';
      'Z':Direction:= 'Left';
      'C':Direction:= 'Right';
      End;
      TimAnimator.Enabled:= True;
      UpdateForm;
end;

procedure TFrmGameUI.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Upcase(chr(key)) IN ['A','W','S','D']
  Then If (TheMap.CalcMovment(chr(key)) = true) AND (TimAttack.Enabled = False)
    Then StandardMov(chr(key));

  If Upcase(chr(key)) IN ['Q','E','Z','C']
  Then If (TheMap.CalcDiagMovment(chr(key)) = true) AND (TimAttack.Enabled = False)
      Then DiagMov(chr(key));

  IF Upcase(chr(key)) = 'I'
    Then If TheMap.CalcItem = true
      Then UpdateForm;

  IF Upcase(chr(key)) = 'O'
    Then If (TimATControl.Enabled = False) AND (TheCharacter.GetATPoints > 0)
      Then begin
        TimATControl.Enabled:= True;
        TimAttack.Enabled:= True;
        ImgChar.Picture:= (nil);
        ImgChar.Left:= ImgChar.Left - 50;
        ImgChar.Top:=  ImgChar.Top - 50;
        ImgChar.Picture.LoadFromFile('tdGame\images\chars\Attack\1.bmp');
        TheEntity.CalcCharAction;
        PBATP.Position:= 0;
      end;
end;

procedure TFrmGameUI.FormShow(Sender: TObject);
begin
    ImgChar.Picture.LoadFromFile('tdGame\images\chars\Walking\Right\1.bmp');
    TimOppAI.Enabled:= True; //Initiates constant A.I. running.
    Timer:= 20;   //Players AT speed.
    AITimer:= 40; //Opps AT Speed.
    PBATP.Position:= timer;
    PBATP.Brush.Color := clBlue;
    Cnt:= 0;
    AniCnt:= 4;
    AttCnt:= 5;
    Direction:= 'Right';
    sndPlaySound('tdGame\music\EverWinterKnightsPlay.wav', SND_ASYNC or SND_LOOP);
end;

procedure TFrmGameUI.ImgCharMouseEnter(Sender: TObject);
begin
  //ImgChar.ShowHint:= True;
  //ImgChar.Hint:=('Left: '+inttostr(TheCharacter.GetXPos)+'Top: '+inttostr(TheCharacter.GetYPos))
  //for debuging
end;

procedure TFrmGameUI.ImgExitClick(Sender: TObject);
begin
  If (MessageDlg('Are you sure you wish to exit?'+' Yes or No?'+#13+'Any unsaved progress will be lost!',
    mtConfirmation, [mbYes, mbNo],0) = mrYes)
    Then begin
      sndPlaySound(nil, SND_ASYNC or SND_LOOP);
      TheCharacter.Destroy;
      TheMap.Destroy;
      TheEntity.Destroy;
      Application.Terminate
    end;
end;

procedure TFrmGameUI.ImgExitMouseEnter(Sender: TObject);
begin
  ImgExit.Picture.LoadFromFile('tdGame\images\buttons\In_Game_Exit_Over.jpg');
end;

procedure TFrmGameUI.ImgExitMouseLeave(Sender: TObject);
begin
  ImgExit.Picture.LoadFromFile('tdGame\images\buttons\In_Game_Exit.jpg');
end;

procedure TFrmGameUI.ImgHelpClick(Sender: TObject);
begin
  FrmHelpUI.Show;
end;

procedure TFrmGameUI.ImgHelpMouseEnter(Sender: TObject);
begin
  ImgHelp.Picture.LoadFromFile('tdGame\images\buttons\In_Game_Help_Over.jpg');
end;

procedure TFrmGameUI.ImgHelpMouseLeave(Sender: TObject);
begin
  ImgHelp.Picture.LoadFromFile('tdGame\images\buttons\In_Game_Help.jpg');
end;

procedure TFrmGameUI.ImgQuestClick(Sender: TObject);
begin
  FrmQuestUI.Show;
end;

procedure TFrmGameUI.ImgQuestMouseEnter(Sender: TObject);
begin
  ImgQuest.Picture.LoadFromFile('tdGame\images\buttons\In_Game_Quest_Over.jpg');
end;

procedure TFrmGameUI.ImgQuestMouseLeave(Sender: TObject);
begin
  ImgQuest.Picture.LoadFromFile('tdGame\images\buttons\In_Game_Quest.jpg');
end;

procedure TFrmGameUI.SortImgArr(PIndex: Integer); //Matches opp image arr to opp class array.
Var
  Loop: Integer;
  Temp: TImage;
begin
  //Showmessage(inttostr(PIndex)); //Debugging;
  ImgArr[PIndex].Destroy; //Destroy opponent image.
  For loop:= PIndex+1 to Cnt do
    begin
      Temp:= ImgArr[loop];
      ImgArr[loop-1]:= temp;
    end;
      Dec(Cnt);

end;

procedure TFrmGameUI.TimAnimatorTimer(Sender: TObject);
begin
  If (AniCnt <> 4)
    Then begin
      Inc(AniCnt);
      ImgChar.Picture.LoadFromFile('tdGame\images\chars\Walking\'+Direction+'\'+inttostr(Anicnt)+'.bmp');
    end
    Else begin
      AniCnt:= 0;
      TimAnimator.Enabled:= False;
    end;
end;

procedure TFrmGameUI.TimATControlTimer(Sender: TObject);
begin
    If Timer = 0
      then begin
      TimATControl.Enabled:= False;
      timer:= 20;
      UpdateForm;
      end
      else begin
        dec(timer);
        PBATP.Position:= PBATP.Position + 1
      end;
end;

procedure TFrmGameUI.TimAttackTimer(Sender: TObject);
begin
  If AttCnt <> 5
    Then begin
      Inc(AttCnt);
      ImgChar.Picture.LoadFromFile('tdGame\images\chars\Attack\'+inttostr(AttCnt)+'.bmp');
      If Attcnt = 5
        Then begin
          TimAttack.Enabled:= False;
          ImgChar.Picture:= (nil);
          ImgChar.Top:= ((25*TheCharacter.GetYPos)+10);
          ImgChar.Left:=((25*TheCharacter.GetXPos)-25);
          ImgChar.Picture.LoadFromFile('tdGame\images\chars\Walking\'+Direction+'\1.bmp');
        end;
    end
    Else AttCnt:= 0;
end;

procedure TFrmGameUI.TimOppAITimer(Sender: TObject);
begin
  If AITimer = 0
    Then begin
      TimOppAI.Enabled:= True; //continues timer.
      AITimer:= 40;
      TheEntity.CalcOppAction;
      UpdateForm;
    end
    else dec(AITimer)
end;

//Updates all changable details on the form.
procedure TFrmGameUI.UpdateForm;
begin
 With FrmGameUI do
    begin
      LblCharName.Caption:= TheCharacter.GetNaam;
      LblHP.Caption:= inttostr(TheCharacter.GetLife);
      LblLvl.Caption:= inttostr(TheCharacter.Getlevel);
      LblAT.Caption:= inttostr(TheCharacter.GetATPoints);
      ImgMap.Picture.LoadFromFile('tdMaps/'+(inttostr(TheCharacter.GetMap))+'.JPG');
      ImgChar.Top:= ((25*TheCharacter.GetYPos)+10);
      ImgChar.Left:=((25*TheCharacter.GetXPos)-25);
    end;
end;

end.
