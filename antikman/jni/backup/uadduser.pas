unit uadduser;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, Spinner;
  
type

  { TMAddUser }

  TMAddUser = class(jForm)
    BClear: jButton;
    BAddUser: jButton;
    EPass: jEditText;
    EUser: jEditText;
    ImgLogoTop: jImageView;
    AddUserPanel: jPanel;
    PanelLeft: jPanel;
    PanelAddUser: jPanel;
    PanelRight: jPanel;
    SpinProfile: jSpinner;
    SpinServer: jSpinner;
    TextServer: jTextView;
    TextPass: jTextView;
    TextProfile: jTextView;
    TextUser: jTextView;
    TextID: jTextView;
    UserAction: jTextView;
    procedure BAddUserClick(Sender: TObject);
    procedure BClearClick(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
    procedure getServer;
    procedure getProfile;
    procedure ClearInput;
  end;

var
  MAddUser: TMAddUser;

  
implementation

uses umain;
  
  
{$R *.lfm}

{ TMAddUser }

procedure TMAddUser.BClearClick(Sender: TObject);
begin
ClearInput;
end;

procedure TMAddUser.BAddUserClick(Sender: TObject);
var
  cmd : array of AnsiString;
  perintah : array[1..6] of String;
  i, ulang : integer;
  s : String;
begin
 if not (EUser.Text='') or not (EPass.Text='') then
    begin
    if (UserAction.Text='Save') then
        begin
        // Pecah Perintah Kedalam Array
        perintah[1]:='/ip/hotspot/user/add';
        perintah[2]:='=name='+EUser.Text;
        perintah[3]:='=profile='+SpinProfile.Text;
        perintah[4]:='=password='+EPass.Text;
        perintah[5]:='=server='+SpinServer.Text;
        perintah[6]:='=disabled=no';
        ulang := 6;
        end else
        if (UserAction.Text='Update') then
        begin
        // Pecah Perintah Kedalam Array
        perintah[1]:='/ip/hotspot/user/set';
        perintah[2]:='=name='+EUser.Text;
        perintah[3]:='=profile='+SpinProfile.Text;
        perintah[4]:='=password='+EPass.Text;
        perintah[5]:='=server='+SpinServer.Text;
        perintah[6]:='=.id='+TextID.Text;
        ulang := 6;
        end;
        // Menyimpan Perintah Kedalam Variabel cmd
        SetLength(cmd, 0);
        for i := 1 to ulang do
        begin
          s := Trim(perintah[i]);
          if s <> '' then
          begin
            SetLength(cmd, High(cmd) + 2);
            cmd[High(cmd)] := s;
          end;
        end;
        // Eksekusi Perintah
        if High(cmd) >= 0 then
          MMain.ROS.Execute(cmd)
          else
          begin
            ShowMessage('ERROR : ' + MMain.ROS.LastError);
            Exit;
          end;
        // Cek Apakah ada Error
        if MMain.ROS.LastError <> '' then ShowMessage('ERROR : ' + MMain.ROS.LastError)
        else
          begin
          ShowMessage(BAddUser.Text.ToUpper+' User Hotspot Berhasil!');
          ClearInput;
          end;
    end else
    ShowMessage('Jangan Kosongkan Inputan!');
end;

procedure TMAddUser.getServer;
var
  i: integer;
begin
 MMain.Res := MMain.ROS.Query(['/ip/hotspot/print'], True);
 SpinServer.Clear();
 SpinServer.Add('all');
 for i := 1 to MMain.Res.RowsCount do
    begin
      SpinServer.Items.Add(MMain.Res.ValueByName['name']);
      MMain.Res.Next;
    end;
end;

procedure TMAddUser.getProfile;
var
  i: integer;
begin
 MMain.Res := MMain.ROS.Query(['/ip/hotspot/user/profile/print'], True);
 SpinProfile.Clear();
 SpinProfile.Add('default');
 for i := 1 to MMain.Res.RowsCount do
    begin
      SpinProfile.Items.Add(MMain.Res.ValueByName['name']);
      MMain.Res.Next;
    end;
end;

procedure TMAddUser.ClearInput;
begin
  EUser.Text:='';
  EPass.Text:='';
  EUser.SetFocus;
end;
  

  
end.
