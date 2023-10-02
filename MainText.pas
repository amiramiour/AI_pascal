Unit MainText;

interface

Const Nmax = 24;
Type  Tab = array[1..Nmax] of string;

procedure TextRead(name : string; var T:Tab); // read data from a text file and put it in an array
procedure TextWrite(name : string; T : tab);  // creates a text file in order to save the data of an array

implementation

procedure TextRead(name : string; var T : tab);
var i: integer;
Fin : text;
begin

assign(Fin, name);
reset(Fin);

for i:=1 to Nmax do
    begin
        readln(Fin, T[i]);
        writeln('Reading line : ', i, 'from ', name);
    end;

close(Fin);
end;

procedure TextWrite(name : string; T : tab);
var i: integer;
Fout : text;

begin
assign(Fout, name);
Rewrite(Fout);

for i:=1 to Nmax do
    begin
        writeln(Fout, T[i]);
        writeln('Writing line : ', i, 'from ', name);
    end;

close(Fout);
end;

end.
