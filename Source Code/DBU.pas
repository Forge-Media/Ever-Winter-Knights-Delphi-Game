unit DBU;

interface

uses DB, ADODB, forms;

var MyDB : TADOQuery;

procedure opendb;
Function Query(TSQL: String): String;
Function StructuredQuery(TSQL: String): String;
Procedure change(TSQL: String);

implementation

procedure opendb;
begin
  MyDB := TADOQuery.Create(Application);
  MyDB.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' +
    '"tdGame/GameDB.mdb";Persist Security Info=False'; //Used to link to MS access database
end;


Procedure change(TSQL: String);
begin
  begin
    MyDB.Close;
    MyDB.SQL.Text:= TSQL;
    MyDB.ExecSQL;
  end;
end;

Function StructuredQuery(TSQL: String): String;
Var
  temp: String;
  Loop: Integer;
begin
  temp:='';
    Change(TSQL);  //Essential before a new SQL statement is used. Closes the Data-Set
    MyDb.Open;  //Open Data-Set so you can use it.
    MyDb.First; //Internal pointer set to first data-set.
    While not MyDB.Eof do //EOF -End of File.
    Begin //Extracting each field, by heading.
      For loop:= 1 to MyDB.FieldCount do
        Temp:= Temp+MyDB.Fields.FieldByNumber(loop).AsString+#9;
        MyDb.Next;
        Temp:= Temp+#13
    End;
  Result:= temp;
end;

Function Query(TSQL: String): String;
Var
  temp: String;
  Loop: Integer;
begin
  temp:='';
    Change(TSQL);  //Essential before a new SQL statement is used. Closes the Data-Set
    MyDb.Open;  //Open Data-Set so you can use it.
    MyDb.First; //Internal pointer set to first data-set.
    While not MyDB.Eof do //EOF -End of File.
    Begin //Extracting each field, by heading.
      For loop:= 1 to MyDB.FieldCount do
        Temp:= Temp+MyDB.Fields.FieldByNumber(loop).AsString;
        MyDb.Next;
    End;
  Result:= temp;
end;

end.
