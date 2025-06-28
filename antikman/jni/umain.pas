unit umain;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, cmikrotikrouteros, snavigationview,
  sdrawerlayout, Laz_And_Controls, stoolbar, udatauser, uuseractive, uadduser,
  ugenerateuser, udataprofile, uaddprofile, uexportuser, RouterOSAPI;
  
type

  { TMMain }

  TMMain = class(jForm)
    DrawerLayout: jsDrawerLayout;
    ImgBack: jImageView;
    NavigationView: jsNavigationView;
    Container: jPanel;
    PanelMain: jPanel;
    PanelInsideMain: jPanel;
    PanelContainer: jPanel;
    Toolbar: jsToolbar;
    procedure MMainSpecialKeyDown(Sender: TObject; keyChar: char;
      keyCode: integer; keyCodeString: string; var mute: boolean);
    procedure NavigationViewClickItem(Sender: TObject; itemId: integer;
      itemCaption: string);
    procedure ToolbarClickNavigationIcon(Sender: TObject);
  private
    {private declarations}

  public
    ActiveScene: integer;
   ROS : TRosApiClient;
   Res : TRosApiResult;
    procedure MakeToolBarAndMenu;
    procedure CreateModule;
    procedure ClosePanel;
    {public declarations}
  end;

var
  MMain: TMMain;
  
implementation
  
{$R *.lfm}
  
{ TMMain }


procedure TMMain.NavigationViewClickItem(Sender: TObject; itemId: integer;
  itemCaption: string);
begin

  if itemId =  101 then
  begin
       MDataUser.ClearData;
       MDataUser.getDataUser;
       ActiveScene:= 101;
       ClosePanel;
       MDataUser.PanelUser.Visible:=True;
  end;
  if itemId =  102 then
  begin
       MUserActive.getDataUserActive;
       ActiveScene:= 102;
       ClosePanel;
       MUserActive.PanelUserActive.Visible:=True;
  end;
  if itemId =  103 then
  begin
       MAddUser.ClearInput;
       MAddUser.getProfile;
       MAddUser.getServer;
       ActiveScene:= 103;
       ClosePanel;
       MAddUser.UserAction.Text:='Save';
       MAddUser.BAddUser.Text:='Simpan';
       MAddUser.PanelAddUser.Visible:=True;
  end;
  if itemId =  104 then
  begin
       MGenerateUser.ClearInput;
       MGenerateUser.getProfile;
       MGenerateUser.getServer;
       ActiveScene:= 104;
       ClosePanel;
       MGenerateUser.PanelGenerateUser.Visible:=True;
  end;
  if itemId =  105 then
  begin
       MDataProfile.ClearData;
       MDataProfile.getDataProfile;
       ActiveScene:= 105;
       ClosePanel;
       MDataProfile.PanelProfile.Visible:=True;
  end;
  if itemId =  106 then
  begin
       MAddProfile.ClearInput;
       ActiveScene:= 106;
       ClosePanel;
       MAddProfile.UserAction.Text:='Save';
       MAddProfile.BAddProfile.Text:='Simpan';
       MAddProfile.PanelAddProfile.Visible:=True;
  end;
  if itemId =  107 then
  begin
       ActiveScene:= 107;
       MExportUser.BExportHTML.Visible:=False;
       MExportUser.BExportPDF.Visible:=True;
       ClosePanel;
       MExportUser.TextOut.Text:='';
       MExportUser.PanelExport.Visible:=True;
  end;
  if itemId =  108 then
  begin
       ActiveScene:= 108;
       MExportUser.BExportPDF.Visible:=False;
       MExportUser.BExportHTML.Visible:=True;
       ClosePanel;
       MExportUser.TextOut.Text:='';
       MExportUser.PanelExport.Visible:=True;
  end;
  DrawerLayout.CloseDrawers();
end;

procedure TMMain.MMainSpecialKeyDown(Sender: TObject; keyChar: char;
  keyCode: integer; keyCodeString: string; var mute: boolean);
begin
  Halt(0);
end;

procedure TMMain.ToolbarClickNavigationIcon(Sender: TObject);
begin
  DrawerLayout.OpenDrawer();
end;

procedure TMMain.MakeToolBarAndMenu;
var
  userMenu, exportMenu, profileMenu : jObjectRef;
begin

  Toolbar.SetFitsSystemWindows(True);
  Toolbar.SetBackgroundToPrimaryColor();
  Toolbar.NavigationIconIdentifier:= 'ic_menu_white_36dp';
  Toolbar.SetTitleTextColor(colbrWhite);
  Toolbar.SetTitle('AnTikMan');
  Toolbar.SetSubtitleTextColor(colbrWhite);
  Toolbar.SetSubtitle('Android Mikrotik Hotspot Manajemen');

  NavigationView.AddHeaderView('bg_blue', 'ic_mikrotik', 'AnTikMan|Android Mikrotik Hotspot Manajemen', 240);

  userMenu:= NavigationView.AddMenu('Hotspot User');
  NavigationView.AddItem(userMenu, 101, 'Hotspot User', 'ic_users');
  NavigationView.AddItem(userMenu, 102, 'Active User', 'ic_active');
  NavigationView.AddItem(userMenu, 103, 'Add User', 'ic_add_user');
  NavigationView.AddItem(userMenu, 104, 'Generate Users', 'ic_generate');

  profileMenu:= NavigationView.AddMenu('User Profile');
  NavigationView.AddItem(profileMenu, 105, 'Data User Profile', 'ic_profile');
  NavigationView.AddItem(profileMenu, 106, 'Add User Profile', 'ic_profile_add');

  exportMenu:= NavigationView.AddMenu('Export User');
  NavigationView.AddItem(exportMenu, 107, 'Export as PDF', 'ic_pdf');
  NavigationView.AddItem(exportMenu, 108, 'Export as HTML', 'ic_html');
  CreateModule;
  ClosePanel;
  ActiveScene:= 100;
  Self.ImgBack.Visible:=True;
end;

procedure TMMain.CreateModule;
begin
     if MDataUser = nil then
       begin
         gApp.CreateForm(TMDataUser, MDataUser);
         MDataUser.Init;
         MDataUser.PanelUser.Parent:= Self.Container;
         MDataUser.PanelUser.SetViewParent(Self.Container.View);
       end;
       if MUserActive = nil then
       begin
         gApp.CreateForm(TMUserActive, MUserActive);
         MUserActive.Init;
         MUserActive.PanelUserActive.Parent:= Self.Container;
         MUserActive.PanelUserActive.SetViewParent(Self.Container.View);
       end;
     if MAddUser = nil then
       begin
         gApp.CreateForm(TMAddUser, MAddUser);
         MAddUser.Init;
         MAddUser.PanelAddUser.Parent:= Self.Container;
         MAddUser.PanelAddUser.SetViewParent(Self.Container.View);
       end;
       if MExportUser = nil then
       begin
         gApp.CreateForm(TMExportUser, MExportUser);
         MExportUser.Init;
         MExportUser.PanelExport.Parent:= Self.Container;
         MExportUser.PanelExport.SetViewParent(Self.Container.View);
       end;
       if MDataProfile = nil then
       begin
         gApp.CreateForm(TMDataProfile, MDataProfile);
         MDataProfile.Init;
         MDataProfile.PanelProfile.Parent:= Self.Container;
         MDataProfile.PanelProfile.SetViewParent(Self.Container.View);
       end;
       if MAddProfile = nil then
       begin
         gApp.CreateForm(TMAddProfile, MAddProfile);
         MAddProfile.Init;
         MAddProfile.PanelAddProfile.Parent:= Self.Container;
         MAddProfile.PanelAddProfile.SetViewParent(Self.Container.View);
       end;
       if MGenerateUser = nil then
       begin
         gApp.CreateForm(TMGenerateUser, MGenerateUser);
         MGenerateUser.Init;
         MGenerateUser.PanelGenerateUser.Parent:= Self.Container;
         MGenerateUser.PanelGenerateUser.SetViewParent(Self.Container.View);
       end;
end;

procedure TMMain.ClosePanel;
begin
  Self.ImgBack.Visible:=False;
  MDataUser.PanelUser.Visible:=False;
  MExportUser.PanelExport.Visible:=False;
  MUserActive.PanelUserActive.Visible:=False;
  MAddUser.PanelAddUser.Visible:=False;
  MDataProfile.PanelProfile.Visible:=False;
  MAddProfile.PanelAddProfile.Visible:=False;
  MGenerateUser.PanelGenerateUser.Visible:=False;
end;

end.
