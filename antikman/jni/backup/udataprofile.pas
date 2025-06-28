unit udataprofile;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, RouterOSAPI;
  
type

  { TMDataProfile }

  TMDataProfile = class(jForm)
    BEdit: jButton;
    BHapus: jButton;
    IDText: jTextView;
    Index: jTextView;
    ListProfile: jListView;
    PanelButton: jPanel;
    PanelButtonLeft: jPanel;
    PanelButtonRight: jPanel;
    PanelListProfile: jPanel;
    PanelProfile: jPanel;
    DownloadText: jTextView;
    NamaText: jTextView;
    SharedText: jTextView;
    UploadText: jTextView;
    procedure BEditClick(Sender: TObject);
    procedure BHapusClick(Sender: TObject);
    procedure ListProfileClickItem(Sender: TObject; itemIndex: integer;
      itemCaption: string);
  private
    {private declarations}
  public
    {public declarations}
    procedure getDataProfile;
    procedure ClearData;
  end;

var
  MDataProfile: TMDataProfile;

  
implementation

uses umain, uaddprofile;
  
  
{$R *.lfm}

{ TMDataProfile }

procedure TMDataProfile.ListProfileClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
begin
  Index.SetText(IntToStr(itemIndex));
  IDText.SetText(ListProfile.GetItemText(itemIndex).split('|')[0]);
  NamaText.SetText(ListProfile.GetItemText(itemIndex).split('|')[1]);
  SharedText.SetText(ListProfile.GetItemText(itemIndex).split('|')[2]);
  if (ListProfile.GetItemText(itemIndex).split('|')[3] <> '') then
  begin
  UploadText.SetText(ListProfile.GetItemText(itemIndex).split('|')[3].Split('/')[0]);
  DownloadText.SetText(ListProfile.GetItemText(itemIndex).split('|')[3].Split('/')[1]);
  end;
end;

procedure TMDataProfile.BHapusClick(Sender: TObject);
var
  cmd : array of AnsiString;
  perintah : array[1..2] of String;
  i, ulang : integer;
  s : String;
begin

 if not (IDText.Text='') then
    begin

     perintah[1]:='/ip/hotspot/user/profile/remove';
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
          ShowMessage('HAPUS Profile Hotspot Berhasil!');
          ListProfile.Delete(StrToInt(Index.Text));
          ClearData;
          end;
    end else
    ShowMessage('Pilih Data Profile Terlebih Dahulu!');

end;

procedure TMDataProfile.BEditClick(Sender: TObject);
begin
   if not (IDText.Text='') then
    begin
    MAddProfile.TextID.Text:=IDText.Text;
    MAddProfile.ENama.Text:=NamaText.Text;
    MAddProfile.EShared.Text:=SharedText.Text;
    MAddProfile.EUpload.Text:=UploadText.Text;
    MAddProfile.EDownload.Text:=DownloadText.Text;
    MAddProfile.UserAction.Text:='Update';
    MAddProfile.BAddProfile.Text:='Update';
    MMain.ClosePanel;
    MMain.ActiveScene:=106;
    MAddProfile.PanelAddProfile.Visible:=True;
    end else
    ShowMessage('Pilih Data Profile Terlebih Dahulu!');
end;

procedure TMDataProfile.getDataProfile;
var
  i: integer;
begin
 ListProfile.Clear;
 MMain.Res := MMain.ROS.Query(['/ip/hotspot/user/profile/print'], True);
 for i := 1 to MMain.Res.RowsCount do
    begin
      ListProfile.Add(MMain.Res.ValueByName['.id']+'|'+
                   MMain.Res.ValueByName['name']+'|'+
                   MMain.Res.ValueByName['shared-users']+'|'+
                   MMain.Res.ValueByName['rate-limit']);
      MMain.Res.Next;
    end;
end;

procedure TMDataProfile.ClearData;
begin
 Index.Text:='';
 IDText.Text:='';
 NamaText.Text:='';
 UploadText.Text:='';
 DownloadText.Text:='';
 SharedText.Text:='';
end;
  

  
end.
