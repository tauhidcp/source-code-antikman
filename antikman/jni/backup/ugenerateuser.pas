unit ugenerateuser;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, Spinner, RouterOSAPI;
  
type

  { TMGenerateUser }

  TMGenerateUser = class(jForm)
    EJumlah: jEditText;
    EKet: jEditText;
    GenerateUserPanel: jPanel;
    BGenerate: jButton;
    BClear: jButton;
    PanelGenerateUser: jPanel;
    PanelLeft: jPanel;
    PanelRight: jPanel;
    SpinUser: jSpinner;
    SpinPass: jSpinner;
    SpinProfile: jSpinner;
    SpinServer: jSpinner;
    TextPass: jTextView;
    TextProfile: jTextView;
    TextServer: jTextView;
    TextUser: jTextView;
    TextJumlah: jTextView;
    TextKet: jTextView;
    procedure BClearClick(Sender: TObject);
    procedure BGenerateClick(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
    procedure getServer;
    procedure getProfile;
    procedure ClearInput;

  end;

var
  MGenerateUser: TMGenerateUser;

  
implementation

uses umain;
  
  
{$R *.lfm}

{ TMGenerateUser }

function RandomPassword(PLen: Integer): string;
var
  str: string;
begin
  Randomize;
  str := 'abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Result := '';
  repeat
    Result := Result + str[Random(Length(str)) + 1];
  until (Length(Result) = PLen)
end;

function RandomUser(PLen: Integer): string;
var
  str: string;
begin
  Randomize;
  str := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Result := '';
  repeat
    Result := Result + str[Random(Length(str)) + 1];
  until (Length(Result) = PLen)
end;

procedure TMGenerateUser.BGenerateClick(Sender: TObject);
var
  cmd : array of AnsiString;
  perintah : array[1..7] of String;
  i, j, ulang : integer;
  s : String;
begin
  if not (EJumlah.Text='') or not (EKet.Text='') then
  begin

       for j := 0 to StrToInt(EJumlah.Text) do
        begin
  // Pecah Perintah Kedalam Array
        perintah[1]:='/ip/hotspot/user/add';
        perintah[2]:='=name='+RandomUser(StrToInt(SpinUser.Text.Split(' ')[0]));
        perintah[3]:='=profile='+SpinProfile.Text;
        perintah[4]:='=password='+RandomPassword(StrToInt(SpinPass.Text.Split(' ')[0]));
        perintah[5]:='=server='+SpinServer.Text;
        perintah[6]:='=comment='+EKet.Text;
        perintah[7]:='=disabled=no';
        ulang := 7;
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
        //else
        //  begin
         // ShowMessage('GENERATE User Hotspot Berhasil!');
         // end;

        end;
  ShowMessage('GENERATE '+EJumlah.Text+' User Hotspot Berhasil!');
  end else
      ShowMessage('Jangan Kosongkan Inputan!');
end;

procedure TMGenerateUser.BClearClick(Sender: TObject);
begin
  ClearInput;
end;

procedure TMGenerateUser.getServer;
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

procedure TMGenerateUser.getProfile;
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

procedure TMGenerateUser.ClearInput;
begin
  EJumlah.Text:='';
  EKet.Text:='';
end;
  

  
end.
