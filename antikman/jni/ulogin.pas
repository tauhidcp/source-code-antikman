unit ulogin;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, cmikrotikrouteros, Laz_And_Controls, umain, RouterOSAPI;
  
type

  { TMMain }

  { TMLogin }

  TMLogin = class(jForm)
    BLogin: jButton;
    BClose: jButton;
    EHost: jEditText;
    EPort: jEditText;
    EUser: jEditText;
    EPass: jEditText;
    ImgLogoTop: jImageView;
    LoginPanel: jPanel;
    PanelMainLogin: jPanel;
    PanelLeft: jPanel;
    PanelRight: jPanel;
    PanelTop: jPanel;
    TextHost: jTextView;
    TextPort: jTextView;
    TextUser: jTextView;
    TextPass: jTextView;
    procedure BCloseClick(Sender: TObject);
    procedure BLoginClick(Sender: TObject);
    procedure MLoginJNIPrompt(Sender: TObject);
    procedure MLoginSpecialKeyDown(Sender: TObject; keyChar: char;
      keyCode: integer; keyCodeString: string; var mute: boolean);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  MLogin: TMLogin;

  
implementation
  
  
{$R *.lfm}
  

  
{ TMLogin }

procedure TMLogin.MLoginJNIPrompt(Sender: TObject);
begin
  if MMain = nil then
     begin
       gApp.CreateForm(TMMain, MMain);
       MMain.Init;
       MMain.MakeToolBarAndMenu;
     end;
end;

procedure TMLogin.BLoginClick(Sender: TObject);
var
  Res    : TRosApiResult;
  login  : Boolean;
  ROS    : TRosApiClient;
begin
  ROS := TRosApiClient.Create;
  if ((EHost.Text='') or (EPort.Text='') or (EUser.Text='') or (EPass.Text='')) then
     ShowMessage('Jangan Kosongkan Inputan!')
     else begin
      login := ROS.Connect(EHost.Text, EUser.Text, EPass.Text, EPort.Text);
      if login then
      begin
        MMain.ROS:=ROS;
        MMain.Res:=Res;
        Self.PanelMainLogin.Visible:=False;
        MMain.Show();
      end
      else
      begin
        ShowMessage('Login Gagal!');
        Exit;
      end;
     end;
  end;

procedure TMLogin.BCloseClick(Sender: TObject);
begin
Halt(0);
end;

procedure TMLogin.MLoginSpecialKeyDown(Sender: TObject; keyChar: char;
  keyCode: integer; keyCodeString: string; var mute: boolean);
begin
 mute := True;
 Self.Minimize();
end;

end.
