unit udatauser;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, RouterOSAPI;
  
type

  { TMDataUser }

  TMDataUser = class(jForm)
    BHapus: jButton;
    BEdit: jButton;
    ListUser: jListView;
    PanelListUser: jPanel;
    PanelButton: jPanel;
    PanelUser: jPanel;
    PanelButtonLeft: jPanel;
    PanelButtonRight: jPanel;
    Index: jTextView;
    IDText: jTextView;
    ProfileText: jTextView;
    PassText: jTextView;
    UserText: jTextView;
    procedure BEditClick(Sender: TObject);
    procedure BHapusClick(Sender: TObject);
    procedure ListUserClickItem(Sender: TObject; itemIndex: integer;
      itemCaption: string);
  private
    {private declarations}

  public
    {public declarations}
    procedure getDataUser;
    procedure ClearData;
  end;

var
  MDataUser: TMDataUser;

  
implementation

uses umain, uadduser;
  
  
{$R *.lfm}
  

  
{ TMDataUser }

procedure TMDataUser.BHapusClick(Sender: TObject);
var
  cmd : array of AnsiString;
  perintah : array[1..2] of String;
  i, ulang : integer;
  s : String;
begin

 if not (IDText.Text='') then
    begin

     perintah[1]:='/ip/hotspot/user/remove';
     perintah[2]:='=.id='+IDText.Text;
     ulang:=2;
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
          ShowMessage('HAPUS User Hotspot Berhasil!');
          ListUser.Delete(StrToInt(Index.Text));
          ClearData;
          end;
    end else
    ShowMessage('Pilih Data User Terlebih Dahulu!');

end;

procedure TMDataUser.BEditClick(Sender: TObject);
begin
   if not (IDText.Text='') then
    begin
    MAddUser.TextID.Text:=IDText.Text;
    MAddUser.EUser.Text:=UserText.Text;
    MAddUser.EPass.Text:=PassText.Text;
    MAddUser.UserAction.Text:='Update';
    MAddUser.BAddUser.Text:='Update';
    MAddUser.getProfile;
    MAddUser.getServer;
    MMain.ClosePanel;
    MMain.ActiveScene:=103;
    MAddUser.PanelAddUser.Visible:=True;
    end else
    ShowMessage('Pilih Data User Terlebih Dahulu!');
end;

procedure TMDataUser.ListUserClickItem(Sender: TObject; itemIndex: integer;
  itemCaption: string);
begin
  Index.SetText(IntToStr(itemIndex));
  IDText.SetText(ListUser.GetItemText(itemIndex).split('|')[0]);
  UserText.SetText(ListUser.GetItemText(itemIndex).split('|')[1]);
  ProfileText.SetText(ListUser.GetItemText(itemIndex).split('|')[2]);
  PassText.SetText(ListUser.GetItemText(itemIndex).split('|')[3]);
end;

procedure TMDataUser.getDataUser;
var
  i: integer;
begin
 ListUser.Clear;
 MMain.Res := MMain.ROS.Query(['/ip/hotspot/user/print'], True);
 for i := 1 to MMain.Res.RowsCount do
    begin
      ListUser.Add(MMain.Res.ValueByName['.id']+'|'+
                   MMain.Res.ValueByName['name']+'|'+
                   MMain.Res.ValueByName['profile']+'|'+
                   MMain.Res.ValueByName['password']);
      MMain.Res.Next;
    end;
end;

procedure TMDataUser.ClearData;
begin
  Index.Text:='';
  IDText.Text:='';
  UserText.Text:='';
  ProfileText.Text:='';
  PassText.Text:='';
end;

end.
