program EverWinterKnightsP;

{%TogetherDiagram 'ModelSupport_EverWinterKnightsP\default.txaPackage'}

uses
  Forms,
  MenuUI in 'MenuUI.pas' {FrmMenuUI},
  LoadUI in 'LoadUI.pas' {FrmLoadUI},
  MapU in 'MapU.pas',
  GameUI in 'GameUI.pas' {FrmGameUI},
  HelpUI in 'HelpUI.pas' {FrmHelpUI},
  EntityU in 'EntityU.pas',
  OpponentU in 'OpponentU.pas',
  BaseU in 'BaseU.pas',
  CharacterU in 'CharacterU.pas',
  DBU in 'DBU.pas',
  QuestUI in 'QuestUI.pas' {FrmQuestUI};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Ever Winter Knights';
  Application.CreateForm(TFrmMenuUI, FrmMenuUI);
  Application.CreateForm(TFrmLoadUI, FrmLoadUI);
  Application.CreateForm(TFrmGameUI, FrmGameUI);
  Application.CreateForm(TFrmHelpUI, FrmHelpUI);
  Application.CreateForm(TFrmQuestUI, FrmQuestUI);
  Application.Run;
end.
