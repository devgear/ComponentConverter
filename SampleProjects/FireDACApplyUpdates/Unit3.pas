unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls;

type
  TForm3 = class(TForm)
    qry_EnvSetup: TFDQuery;
    qry_EnvSetupStringField: TStringField;
    qry_EnvSetupStringField2: TStringField;
    qry_EnvSetupStringField3: TStringField;
    qry_EnvSetupStringField4: TStringField;
    qry_EnvSetupStringField5: TStringField;
    qry_EnvSetupTeacher: TStringField;
    qry_EnvSetupAudio: TStringField;
    qry_EnvSetupVideo: TStringField;
    qry_EnvSetupFloatField: TFloatField;
    ds_EnvSetup: TDataSource;
    UpdateSQL_Record: TFDUpdateSQL;
    DBKatasBusDB2: TFDConnection;
    Button1: TButton;
    DBGrid1: TDBGrid;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OnException(Sender: TObject; E: Exception);
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
  I, ErrCnt: Integer;
  DataBase : TFDConnection;
  E: Exception;
begin
  Database := DBKatasBusDB2;
  DataBase.StartTransaction;
  try
    qry_EnvSetup.DisableControls;

    qry_EnvSetup.Insert;
    qry_EnvSetup.FieldByName('작업년도').AsString := '07';
    qry_EnvSetup.FieldByName('조합코드').AsString := 'CX';
    qry_EnvSetup.FieldByName('조합명').AsString := 'AAAAA';

    ErrCnt := qry_EnvSetup.ApplyUpdates(0);
    if ErrCnt > 0 then
    begin
//      ShowMessage(qry_EnvSetup.RowError.Message);
//      raise Exception.Create();
//      E := EFDException.Create('');
      E := qry_EnvSetup.RowError;
      Application.OnException(nil, E);
      DataBase.Rollback;
//      raise E;
    end
    else
    begin
      DataBase.Commit;
      qry_EnvSetup.CommitUpdates;
      qry_EnvSetup.EnableControls;
    end;

  except
    begin
      DataBase.Rollback;
      ShowMessage('except');
      raise;
    end;
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Application.OnException := OnException;
end;

procedure TForm3.OnException(Sender: TObject; E: Exception);
begin
  ShowMessage('App.OnException: ' + E.Message);
end;

end.
