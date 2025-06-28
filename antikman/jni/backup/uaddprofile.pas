unit uaddprofile;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, autocompletetextview,
  RouterOSAPI;
  
type

  { TMAddProfile }

  TMAddProfile = class(jForm)
    AddProfilePanel: jPanel;
    BAddProfile: jButton;
    BClear: jButton;
    ENama: jEditText;
    EShared: jEditText;
    EDownload: jEditText;
    EUpload: jEditText;
    PanelAddProfile: jPanel;
    PanelLeft: jPanel;
    PanelRight: jPanel;
    TextID: jTextView;
    TextDownload: jTextView;
    TextShared: jTextView;
    TextNama: jTextView;
    TextUpload: jTextView;
    UserAction: jTextView;
    procedure BAddProfileClick(Sender: TObject);
    procedure BClearClick(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
    procedure ClearInput;
  end;

var
  MAddProfile: TMAddProfile;

  
implementation

uses umain;
  
  
{$R *.lfm}

{ TMAddProfile }

procedure TMAddProfile.BClearClick(Sender: TObject);
begin
ClearInput;
end;

procedure TMAddProfile.BAddProfileClick(Sender: TObject);
var
  cmd : array of AnsiString;
  perintah : array[1..5] of String;
  i, ulang : integer;
  s : String;
begin
 if not (ENama.Text='') or not (EShared.Text='') or not (EUpload.Text='') or not (EDownload.Text='') then
    begin
    if (UserAction.Text='Save') then
        begin
        // Pecah Perintah Kedalam Array
        perintah[1]:='/ip/hotspot/user/profile/add';
        perintah[2]:='=name='+ENama.Text;
        perintah[3]:='=shared-users='+EShared.Text;
        perintah[4]:='=rate-limit='+EUpload.Text+'/'+EDownload.Text+'';
        ulang := 4;
        end else
        if (UserAction.Text='Update') then
        begin
        // Pecah Perintah Kedalam Array
        perintah[1]:='/ip/hotspot/user/profile/set';
        perintah[2]:='=name='+ENama.Text;
        perintah[3]:='=shared-users='+EShared.Text;
        perintah[4]:='=rate-limit='+EUpload.Text+'/'+EDownload.Text+'';
        perintah[5]:='=.id='+TextID.Text;
        ulang := 5;
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
          ShowMessage(BAddProfile.Text.ToUpper+' Profile Hotspot Berhasil!');
          end;
    end else
    ShowMessage('Jangan Kosongkan Inputan!');
end;

procedure TMAddProfile.ClearInput;
begin
  ENama.Text:='';
  EShared.Text:='';
  EUpload.Text:='';
  EDownload.Text:='';
end;
  

  
end.
