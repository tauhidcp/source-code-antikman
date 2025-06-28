unit uexportuser;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, intentmanager, libjpfpdf,
  RouterOSAPI;
  
type

  { TMExportUser }

  TMExportUser = class(jForm)
    BExportPDF: jButton;
    BExportHTML: jButton;
    IntentManager1: jIntentManager;
    PanelExport: jPanel;
    TextOut: jTextView;
    procedure BExportHTMLClick(Sender: TObject);
    procedure BExportPDFClick(Sender: TObject);
    procedure MExportUserJNIPrompt(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  MExportUser: TMExportUser;

  
implementation

uses umain;
  
  
{$R *.lfm}
  

  
{ TMExportUser }

function SaveAsHTMLFile(Res : TRosApiResult; AFileName: string): Boolean;
var
  filex : TextFile;
  after1, after2: string;
  i : integer;
begin
  Result := False;
  try
     AssignFile(filex,AFileName);
     Rewrite(filex);
     Writeln(filex,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><title>HTML Voucher</title></head><body>');

     for i := 1 to Res.RowsCount do
     begin
       after1  := stringreplace('<table align="center" style="color: black; font-size: 11px;"><tr height="5px"><td colspan="3"></td></tr><tr><td>Username :</td><td><b>%username%</b></td></tr><tr><td>Password :</td><td><font face="courier new"><b>%password%</b></font></td></tr><tr height="5px"><td colspan="3"></td></tr></table>', '%username%', Res.ValueByName['name'],[rfReplaceAll, rfIgnoreCase]);
       after2  := stringreplace(after1, '%password%', Res.ValueByName['password'],[rfReplaceAll, rfIgnoreCase]);
       Writeln(filex,after2);
       after1:='';
       after2:='';
       Res.Next;
     end;

     Writeln(filex,'</body></html>');

     Result := True;

  finally
    CloseFile(filex);
  end;
end;

function SaveAsPDFFile(Res : TRosApiResult; AFileName: string): Boolean;
var
JPFpdf1 : TJPFpdf;
i : integer;
begin
  Result := False;
  try
  JPFpdf1 := TJPFpdf.Create;
  with JPFpdf1 do begin
    AddPage;
    SetFont(ffTimes,fsBold,16);
    SetLineWidth(0.3);
    Cell(0, 10, 'Hotspot User','1',0,'C',0);
    Ln(15);
    SetFont(ffHelvetica,fsNormal,12);
    Cell(10,7,'No','1',0,'C',0);
    Cell(40,7,'Userlogin','1',0,'C',0);
    Cell(50,7,'Profile','1',0,'C',0);
    Cell(50,7,'Time Limit','1',0,'C',0);
    Cell(40,7,'Password','1',0,'C',0);
    for i := 1 to Res.RowsCount do begin
    Ln(7);
    Cell(10,7,IntToStr(i),'1',0,'C',0);
    Cell(40,7,Res.ValueByName['name'],'1',0,'C',0);
    Cell(50,7,Res.ValueByName['profile'],'1',0,'C',0);
    Cell(50,7,Res.ValueByName['uptime'],'1',0,'C',0);
    Cell(40,7,Res.ValueByName['password'],'1',0,'C',0);
    Res.Next;
    end;
    SetAuthor('antikman');
    SaveToFile(AFileName);
    Result := True;
    end;
    finally
    JPFpdf1.Free;
  end;
end;

procedure TMExportUser.BExportPDFClick(Sender: TObject);
begin
    MMain.Res := MMain.ROS.Query(['/ip/hotspot/user/print'], True);
    if SaveAsPDFFile(MMain.Res,Self.GetEnvironmentDirectoryPath(dirDownloads)+'/'+'hotspot_user.pdf') then
       begin
       TextOut.Text:='Success Export To PDF!'+sLineBreak+'Location : '+Self.GetEnvironmentDirectoryPath(dirDownloads)+'/'+'hotspot_user.pdf';
       //IntentManager1.SetAction(iaView);
      // IntentManager1.SetDataUri(GetUriFromFile(Self.GetEnvironmentDirectoryPath(dirDownloads)+'/'+'hotspot_user.pdf'));
      // IntentManager1.SetMimeType('application/pdf');
      // IntentManager1.StartActivity();
       end;
end;

procedure TMExportUser.BExportHTMLClick(Sender: TObject);
begin
   MMain.Res := MMain.ROS.Query(['/ip/hotspot/user/print'], True);
   if SaveAsHTMLFile(MMain.Res,Self.GetEnvironmentDirectoryPath(dirDownloads)+'/'+'hotspot_user.html') then
       begin
       TextOut.Text:='Success Export To HTML!'+sLineBreak+'Location : '+Self.GetEnvironmentDirectoryPath(dirDownloads)+'/'+'hotspot_user.html';
       //IntentManager1.SetAction(iaView);
      // IntentManager1.SetDataUri(GetUriFromFile(Self.GetEnvironmentDirectoryPath(dirDownloads)+'/'+'hotspot_user.html'));
      // IntentManager1.SetMimeType('text/html');
      // IntentManager1.StartActivity();
       end;
end;

procedure TMExportUser.MExportUserJNIPrompt(Sender: TObject);
var
  manifestPermissions: array of string;
begin
   // Request Permission For Export User to PDF and HTML
    if IsRuntimePermissionNeed() then
   begin
      SetLength(manifestPermissions, 1);
      manifestPermissions[0]:= 'android.permission.WRITE_EXTERNAL_STORAGE';
      Self.RequestRuntimePermission(manifestPermissions, 6001);
      SetLength(manifestPermissions, 0);
   end;

end;

end.
