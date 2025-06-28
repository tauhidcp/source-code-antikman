unit uuseractive;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, RouterOSAPI;
  
type

  { TMUserActive }

  TMUserActive = class(jForm)
    BEdit: jButton;
    BHapus: jButton;
    ListUserActive: jListView;
    PanelButtonLeft: jPanel;
    PanelButtonRight: jPanel;
    PanelListUserActive: jPanel;
    PanelUserActive: jPanel;
  private
    {private declarations}
  public
    {public declarations}
    procedure getDataUserActive;
  end;

var
  MUserActive: TMUserActive;

  
implementation

uses umain;
  
  
{$R *.lfm}

{ TMUserActive }

procedure TMUserActive.getDataUserActive;
var
  i: integer;
begin
 MMain.Res := MMain.ROS.Query(['/ip/hotspot/active/print'], True);
 for i := 1 to MMain.Res.RowsCount do
    begin
      ListUserActive.Add(MMain.Res.ValueByName['.id']+'|'+
                   MMain.Res.ValueByName['server']+'|'+
                   MMain.Res.ValueByName['user']+'|'+
                   MMain.Res.ValueByName['address']);
      MMain.Res.Next;
    end;
end;
  

  
end.
