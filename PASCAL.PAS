unit pascal;
{$P+}

interface



TYPE
tTecla=(TeclaNula,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,RetornoCarro,Tabulador,
        MayusTab,Retroceso,FlechaArriba,FlechaAbajo,FlechaDer,FlechaIzq,
        Supr,Ins,Inicio,Fin,RePag,AvPag,Esc,Letra,Numero,Espacio);



VAR
wSegVid:word;




procedure ReemplazaCadena(sCadBuscada,sCadReemplaza:string;
                          var sCadenaLarga:string);
procedure WriteConNombre(sCadena,sNombre:string);
procedure WriteConNombreLn(sCadena,sNombre:string);
function LeerEntero(sMensaje:string):integer;
procedure PonMayusculas(var sCadena:string);
procedure PonMinusculas(var sCadena:string);
function Mayusculas(sCadena:string):string;
function Minusculas(sCadena:string):string;
procedure QuitarBlancosIni(var sCadena:string);
procedure QuitarBlancosFin(var sCadena:string);
function Extension(sNombre:string):string;
function QuitaExtension(sNombre:string):string;
function Chars(yChar:byte; wNum:word):string;


function RealAFrac(rNum:real;iDenominador:integer):string;
function FracAReal(sFrac:string; var iCodigo:integer):real;
function ByteAHex(y:byte):string;
function WordAHex(w:word):string;
function Hex(i:longint):string;
function ByteABin(y:byte):string;
function ASCII(y:byte):char;


procedure DimCursor(iDimension:integer);
procedure WriteRapido(X,Y:byte;c:char;yColor,yFondo:byte);
procedure Beep(iFrec,iTiempo:integer);
procedure Pausa(wMilesimas:word);
procedure LeerCadena(var sCad:string;iLongVentana,iLongitudMax,iX,iY:integer;
                     cTextONum:char;iCarFondo:integer);
procedure CopyFichero(sNombre1,sPath1,sNombre2,sPath2:string;
                      bSobreEscribir:boolean; var iError:integer);





implementation

uses crt,dos;





{   *****   S T R I N G S    &    C A D E N A S   *****   }





procedure ReemplazaCadena(sCadBuscada,sCadReemplaza:string;
                          var sCadenaLarga:string);
var
 iI:integer;
begin
iI:=pos(sCadBuscada,sCadenaLarga);
if iI>0 then
  begin
   delete(sCadenaLarga,iI,length(sCadBuscada));
   insert(sCadReemplaza,sCadenaLarga,iI);
  end;
end; (*procedure ReemplazaCadena*)





procedure writeConNombre(sCadena,sNombre:string);

{Mejorar para que si ponemos @ lo cambie,
pero si ponemos @@ escriba una arroba y no lo cambie}

var
 iI:integer;
begin
while pos('@',sCadena)<>0 do
  ReemplazaCadena('@',sNombre,sCadena);

write(sCadena);
end; (*procedure writeConNombre*)





procedure writeConNombreLN(sCadena,sNombre:string);
var
 iI:integer;
begin
while pos('@',sCadena)<>0 do
  ReemplazaCadena('@',sNombre,sCadena);

writeln(sCadena);
end; (*procedure writeConNombreLN*)





function LeerEntero(sMensaje:string):integer;

{ponerle maximos y minimos (32000)...}
{hacer uno para reales. (ver RealAFrac)}

var
 iNumero,iCodigo:integer;
 sCadNumero:string[20];
begin
repeat
  write(sMensaje);
  readln(sCadNumero);
  Val(sCadNumero, iNumero, iCodigo);
  if iCodigo<>0 then write(^g); {suena un pitido}
until iCodigo=0;
LeerEntero:=iNumero;
end; (*function LeerEntero*)





procedure PonMayusculas(var sCadena:string);
var
 wI:word;

begin
for wI:=1 to length(sCadena) do
  if (Ord(sCadena[wI])>=97) and (Ord(sCadena[wI])<=122) then
    sCadena[wI]:=Chr(Ord(sCadena[wI])-32);
end; (*procedure PonMayusculas*)





procedure PonMinusculas(var sCadena:string);
var
 wI:word;

begin
for wI:=1 to length(sCadena) do
  if (Ord(sCadena[wI])>=65) and (Ord(sCadena[wI])<=90) then
    sCadena[wI]:=Chr(Ord(sCadena[wI])+32);
end; (*procedure PonMinusculas*)





function Mayusculas(sCadena:string):string;
var
 wI:word;

begin
Mayusculas:=sCadena;
for wI:=1 to length(sCadena) do
  if (Ord(sCadena[wI])>=97) and (Ord(sCadena[wI])<=122) then
    Mayusculas[wI]:=Chr(Ord(sCadena[wI])-32)
  else Mayusculas[wI]:=sCadena[wI];
end; (*function Mayusculas*)





function Minusculas(sCadena:string):string;
var
 wI:word;

begin
Minusculas:=sCadena;
for wI:=1 to length(sCadena) do
  if (Ord(sCadena[wI])>=65) and (Ord(sCadena[wI])<=90) then
    Minusculas[wI]:=Chr(Ord(sCadena[wI])+32)
  else Minusculas[wI]:=sCadena[wI];
end; (*function Minusculas*)





procedure QuitarBlancosIni(var sCadena:string);
begin
while (length(sCadena)>0) and (sCadena[1]=' ') do
  delete(sCadena,1,1);
end; (*procedure QuitarBlancosIni*)





procedure QuitarBlancosFin(var sCadena:string);
begin
while sCadena[length(sCadena)]=' ' do
  delete(sCadena,length(sCadena),1);
end; (*procedure quitarBlancosFin*)





function Extension(sNombre:string):string;
var
 sExt:string;

begin
if pos('.',sNombre)=0 then Extension:='' {No hay extension}
else
  begin
    sExt:=(copy(sNombre,pos('.',sNombre)+1,3));
    QuitarBlancosFin(sExt);
    Extension:=sExt;
  end;
end; (*function Extension*)





function QuitaExtension(sNombre:string):string;
begin
if pos('.',sNombre)=0 then QuitaExtension:=sNombre {No hay extension}
  else QuitaExtension:=copy(sNombre,1,pos('.',sNombre)-1);
end; (*function QuitaExtension*)





function Chars(yChar:byte; wNum:word):string;
var
 s:string;
 w:word;

begin
s:='';
for w:=1 to wNum do s:=s+chr(yChar);
Chars:=s;
end; (*function Chars*)





{   *****   R U T I N A S    M A T E M A T I C A S   *****   }





function RealAFrac(rNum:real;iDenominador:integer):string;
var
 sInt,sNumer,sDenom,s1,s2:string[20];
 r2,rParteEnt,rParteFrac:real;
 iCodigo,iPos,iNumer:integer;
begin
if rNum=0 then
  begin
   RealAFrac:='0';
   Exit;
  end;
sInt:='0';
sDenom:='0';
sNumer:='0';

str(rNum:0:8,s2);
iPos:=pos('.',s2);
if iPos>0 then
  s1:=copy(s2,1,iPos-1);

delete(s2,1,iPos-1);
val(s1,rParteEnt, iCodigo);
str(rParteEnt:0:0,sInt);

val(s2, rParteFrac, iCodigo);
if rParteFrac>0.0 then
  begin
   iNumer:=0;
   repeat
     iNumer:=iNumer+1;
     r2:=iNumer/iDenominador;
   until r2>=rParteFrac;
   if (r2-rParteFrac)>(1.0/(iDenominador*2.0)) then
     iNumer:=iNumer-1;
   while (not Odd(iNumer)) and (iNumer>0) do
     begin
      iNumer:=iNumer div 2;
      iDenominador:=iDenominador div 2;
     end;
   str(iNumer:0,sNumer);
   str(iDenominador:0,sDenom);
  end;

if (sNumer='1') and (sDenom='1') then
  begin
   sNumer:='0';
   val(sInt,r2,iCodigo);
   r2:=r2+1;
   str(r2:0:0,sInt);
  end;

if (sInt='0') and (sNumer='0') then
  RealAFrac:='0'
else if sNumer='0' then RealAFrac:=sInt
  else if sInt='0' then
    begin
      if (sNumer='1') and (sDenom='1') then
        RealAFrac:='1'
      else RealAFrac:=sNumer+'/'+sDenom;
    end
    else RealAFrac:=sInt+' '+sNumer+'/'+sDenom;
end; (*function RealAFrac*)





function FracAReal(sFrac:string; var iCodigo:integer):real;
{Ejemplos de Entradas correctas:
14 1/2
3/16
29}

var
 rNumer,rDenom,rParteEnt:real;
 sNumer,sDenom,sInt:string[8];
 iPosBarra,iPosEspacio,iP,iJ:integer;

begin
while (sFrac[1]=' ') and (length(sFrac)>0) do
  delete(sFrac,1,1);
if sFrac='' then
  begin
   FracAReal:=0;
   exit;
  end;

iPosBarra:=pos('/',sFrac);
iPosEspacio:=pos(' ',sFrac);
sInt:='';
sNumer:='';
sDenom:='';

if (iPosBarra>0) and (iPosEspacio>0) then
  begin {barra y espacio}
   for iJ:=1 to iPosEspacio-1 do
     sInt:=sInt+sFrac[iJ];
   for iJ:=iPosEspacio+1 to iPosBarra-1 do
     sNumer:=sNumer+sFrac[iJ];
   for iJ:=iPosBarra+1 to length(sFrac) do
     sDenom:=sDenom+sFrac[iJ];
   val(sInt,rParteEnt,iCodigo);
   val(sNumer,rNumer,iCodigo);
   val(sDenom,rDenom,iCodigo);
   FracAReal:=rParteEnt+rNumer/rDenom;
  end

else
  if iPosBarra>0 then
    begin {ni barra ni espacio}
     for iJ:=iPosEspacio+1 to iPosBarra-1 do
       sNumer:=sNumer+sFrac[iJ];
     for iJ:=iPosBarra+1 to length(sFrac) do
       sDenom:=sDenom+sFrac[iJ];
     val(sNumer,rNumer,iCodigo);
     val(sDenom,rDenom,iCodigo);
     FracAReal:=rNumer/rDenom;
    end

  else
    if iPosEspacio=0 then
      begin {ni barra ni espacio}
       for iJ:=1 to iPosEspacio-1 do
         sInt:=sInt+sFrac[iJ];
       val(sInt,rParteEnt,iCodigo);
       FracAReal:=rParteEnt;
      end

    else
      begin {ni barra ni espacio}
       sInt:=sInt+sFrac;
       val(sInt,rParteEnt,iCodigo);
       FracAReal:=rParteEnt;
      end;
end; (*function FracAReal*)





function ByteAHex(y:byte):string;
var
 sHex:string;


  function Traducir(y:byte):char;
  begin
  if y<10
  then Traducir:=chr(y+48)  {Ord('0')=48}
  else Traducir:=chr(y+55); {Ord('A')=65. 65-10=55}
  end; (*function traducir*)


begin
sHex:='';
sHex:=sHex+Traducir(y shr 4);  { $12 shr 4  = $1 }
sHex:=sHex+Traducir(y and 15); { $12 and $F = $2 } {15=$F=00001111}

ByteAHex:=sHex;
end; (*function ByteAHex*)





function WordAHex(w:word):string;
var
 sHex:string;


  function Traducir(y:byte):char;
  begin
  if y<10
  then Traducir:=chr(y+48)  {Ord('0')=48}
  else Traducir:=chr(y+55); {Ord('A')=65. 65-10=55}
  end; (*function traducir*)


begin
sHex:='';
{ Hi($1234) = $12 }
sHex:=sHex+Traducir(Hi(w) shr 4);  { $12 shr 4  = $1 }
sHex:=sHex+Traducir(Hi(w) and $F); { $12 and $F = $2 }
{ Lo($1234) = $34 }
sHex:=sHex+Traducir(Lo(w) shr 4);  { shr 4  }
sHex:=sHex+Traducir(Lo(w) and $F); { shr 15 }

WordAHex:=sHex;
end; (*function WordAHex*)





function Hex(i:longint):string;
var
 sHex:string;
 aiHex:array[1..8] of byte;
 bPonCero:boolean;


  function Traducir(b:byte):char;
  begin
  if b<10 then
    Traducir:=chr(b+48)  {Ord('0')=48}
  else
    Traducir:=chr(b+55); {Ord('A')=65}
  end; (*function traducir*)


begin

{HACERLO BIEN, Y QUE PONGA 0 SI ENTRA UN CERO}

{ESTE CACHO ESTA MAL, AL ACABAR HACER aiHex[]:=iI div 16}

aiHex[1]:=i mod 16;
i:=i div 16;
aiHex[2]:=i mod 16;
i:=i div 16;
aiHex[3]:=i mod 16;
i:=i div 16;
aiHex[4]:=i mod 16;
i:=i div 16;
aiHex[5]:=i mod 16;
i:=i div 16;
aiHex[6]:=i mod 16;
i:=i div 16;
aiHex[7]:=i mod 16;
i:=i div 16;
aiHex[8]:=i mod 16;

sHex:='';
bPonCero:=false;
if (aiHex[8]<>0) or bPonCero then
  begin
    sHex:=sHex+Traducir(aiHex[8]);
    bPonCero:=true;
  end;
if (aiHex[7]<>0) or bPonCero then
  begin
    sHex:=sHex+Traducir(aiHex[7]);
    bPonCero:=true;
  end;
if (aiHex[6]<>0) or bPonCero then
  begin
    sHex:=sHex+Traducir(aiHex[6]);
    bPonCero:=true;
  end;
if (aiHex[5]<>0) or bPonCero then
  begin
    sHex:=sHex+Traducir(aiHex[5]);
    bPonCero:=true;
  end;
if (aiHex[4]<>0) or bPonCero then
  begin
    sHex:=sHex+Traducir(aiHex[4]);
    bPonCero:=true;
  end;
if (aiHex[3]<>0) or bPonCero then
  begin
    sHex:=sHex+Traducir(aiHex[3]);
    bPonCero:=true;
  end;
if (aiHex[2]<>0) or bPonCero then
  begin
    sHex:=sHex+Traducir(aiHex[2]);
    bPonCero:=true;
  end;
if (aiHex[1]<>0) or bPonCero then
  begin
    sHex:=sHex+Traducir(aiHex[1]);
    bPonCero:=true;
  end;

Hex:=sHex;
end; (*function Hex*)





function ByteABin(y:byte):string;
var
 sBin:string;
 i:integer;

begin
sBin:='';
for i:=7 downto 0 do
  if y and (1 shl i)<>0
  then sBin:=sBin+'1'
  else sBin:=sBin+'0';

ByteABin:=sBin;
end; (*ByteABin*)





function ASCII(y:byte):char;
begin
if (y<>10) and (y<>7) and (y<>8) and (y<>13)
then ASCII:=chr(y)
else ASCII:=chr(32);
end; (*ASCII*)





{   *****   E N T R A D A   /   S A L I D A   *****   }





procedure DimCursor(iDimension:integer);
var
 regs:Registers;
 iI:integer;

begin
if Byte(Ptr(Seg0040, $49)^)=7
then iI:=6  {monocromo}
else iI:=0; {color}


Regs.AH:=$01;

if iDimension=0 then
  begin
    Regs.CH:=$20;
    Regs.CL:=$20;
  end
else
  if iDimension=2 then
    begin
      Regs.CH:=$0;
      Regs.CL:=$7+iI;
    end
  else
    begin
      Regs.CH:=$6+iI;
      Regs.CL:=$7+iI;
    end;

Intr($10,Regs);
end; (*procedure DimCursor*)





function SegVid:word;
begin
if mem[$0000:$0449]=7 then SegVid:=$B000
  else SegVid:=$B800;
end; (*function SegVid*)





procedure WriteRapido(X,Y:byte;c:char;yColor,yFondo:byte);
{yColor es el color del caracter, yFondo del fondo}
var
 w:word;
 i,ColAtr:byte;
begin
ColAtr:=(yFondo shl 4)+ yColor; {byte de atributos}
w:=((y-1)*80+(x-1))*2;      {calculo de desplazamiento}
MemW[wSegVid:w]:=(ColAtr shl 8)+Ord(c);
end; (*procedure WriteRapido*)





procedure Beep(iFrec,iTiempo:integer);
begin
sound(iFrec);
Delay(iTiempo);
NoSound;
end; (*procedure Beep*)





procedure Pausa(wMilesimas:word);
var
 wCronoH,wCronoM,wCronoS,wCronoS100:word;
 rParada:real; {en segundos}
 rObjetivo:real;

begin
getTime(wCronoH,wCronoM,wCronoS,wCronoS100);
rParada:=wCronoH*3600+wCronoM*60+wCronoS+wCronoS100/100;

rObjetivo:=rParada+wMilesimas/1000;

if wMilesimas>0
then
  repeat
    getTime(wCronoH,wCronoM,wCronoS,wCronoS100);
  until wCronoH*3600+wCronoM*60+wCronoS+wCronoS100/100>=rObjetivo;

end; (*procedure Pausa*)





procedure Teclapulsada(var bEsEspecial:boolean;var TeclaEspecial:tTecla;
                       var cCar:char);
begin
bEsEspecial:=false;
cCar:=ReadKey;
if (cCar=#0) then
  begin
   bEsEspecial:=true;
   cCar:=ReadKey;
  end;
if bEsEspecial then
  case Ord(cCar) of
    15: TeclaEspecial:=MayusTab;
    72: TeclaEspecial:=FlechaArriba;
    80: TeclaEspecial:=FlechaAbajo;
    75: TeclaEspecial:=FlechaIzq;
    77: TeclaEspecial:=FlechaDer;
    73: TeclaEspecial:=RePag;
    81: TeclaEspecial:=AvPag;
    71: TeclaEspecial:=Inicio;
    79: TeclaEspecial:=Fin;
    83: TeclaEspecial:=Supr;
    82: TeclaEspecial:=Ins;
    59: TeclaEspecial:=F1;
    60: TeclaEspecial:=F2;
    61: TeclaEspecial:=F3;
    62: TeclaEspecial:=F4;
    63: TeclaEspecial:=F5;
    64: TeclaEspecial:=F6;
    65: TeclaEspecial:=F7;
    66: TeclaEspecial:=F8;
    67: TeclaEspecial:=F9;
    68: TeclaEspecial:=F10;
  end
else
  case Ord(cCar) of
    8: TeclaEspecial:=Retroceso;
    9: TeclaEspecial:=Tabulador;
    13: TeclaEspecial:=RetornoCarro;
    27: TeclaEspecial:=Esc;
    32: TeclaEspecial:=Espacio;
    45..46, 48..59: TeclaEspecial:=Numero;
    else TeclaEspecial:=Letra;
  end;
end; (*procedure TeclaPulsada*)





procedure LeerCadena(var sCad:string;iLongVentana,iLongitudMax,iX,iY:integer;
                     cTextONum:char;iCarFondo:integer);

{LEE Y EDITA UNA CADENA
 iLongVentana:Tama¤o del campo de entrada de datos (1-255)
 iLongitudMax:Longitud maxima de la cadena (1-255)
 iX,iY:Coordenadas de la pantalla correspondientes al primer caracter
 cTextONum:Especifica el campo. Puede ser 'T' para texto o 'N' para numerico
 iCarFondo:Numero ASCII del caracter de fondo (176)}

var
 iX2,iI,iJ,iP:integer;
 cCar:char;
 bInsercion,bTeclaEspecial:boolean;
 LaTecla:TTecla;
 iDesplaz:integer;


  procedure xy(iX,iY:integer);
  var
   iXpeq:integer;
  begin
  repeat
    iXpeq:=iX-80;
    if iXpeq>0 then
      begin
       iY:=iY+1;
       iX:=iXpeq;
      end;
  until iXpeq<=0;
  gotoxy(iX,iY);
  end; (*procedure xy*)


  procedure EstCadena;
  {quita los caracteres color fondo del final}
  var
   iI:integer;
  begin
  iI:=length(sCad);
  while sCad[iI]=chr(iCarFondo) do iI:=iI-1;
  sCad[0]:=chr(iI);
  end; (*procedure EstCadena*)


  function longitud(sCad:string):integer;
  var
   iI:integer;
  begin
  iI:=length(sCad);
  while sCad[iI]=chr(iCarFondo) do iI:=iI-1;
  longitud:=iI;
  end; (*function longitud*)


begin {LeerCadena}

iJ:=length(sCad)+1;
for iI:=iJ to iLongitudMax do sCad[iI]:=chr(iCarFondo);
sCad[0]:=chr(iLongitudMax);

iX:=iX-1;
for iI:=1 to iLongVentana do
  WriteRapido(iX+iI,iY,sCad[iI],Yellow,Black);
iP:=1;
iDesplaz:=0;
bInsercion:=true;


repeat
  iX2:=iX+(iP-iDesplaz);
  if (iP-iDesplaz)=iLongVentana+1 then iX2:=iX2-1;
  xy(iX2,iY);

  TeclaPulsada(bTeclaEspecial,LaTecla,cCar);

  if (cTextONum='n') or (cTextONum='N') then
    begin
     if (LaTecla=Letra) or ((cCar='-') and ((iP>1) or (sCad[1]='-'))) then
       begin
         Beep(100,100);
         LaTecla:=TeclaNula;
       end
     else if (cCar='.') then
       begin
        if not((Pos('.',sCad)=0) or (pos('.',sCad)=iP))
        then
          begin
            Beep(100,100);
            LaTecla:=TeclaNula;
          end
        else
          if (Pos('.',sCad)=iP)
          then Delete(sCad,iP,1);
       end;
    end;

  case LaTecla of
    Numero,Letra,Espacio:
      if longitud(sCad)=iLongitudMax then {es el ultimo caracter}
        begin
         if iP=iLongitudMax then
           begin
             Delete(sCad,iLongitudMax,1);
             sCad:=sCad+cCar;
             if iP=iLongVentana+iDesplaz+1 then
               iDesplaz:=iDesplaz+1;
             for iI:=1 to iLongVentana do
               Writerapido(iX+iI,iY,sCad[iI+iDesplaz],Yellow,Black);
           end
         else
           begin
            if bInsercion then
              begin
                Delete(sCad,iLongitudMax,1);
                Insert(cCar,sCad,iP);
                if iP=iLongVentana+iDesplaz then
                  iDesplaz:=iDesplaz+1;
                if iP<iLongitudMax then
                  iP:=iP+1;
                for iI:=1 to iLongVentana do
                  WriteRapido(iX+iI,iY,sCad[iI+iDesplaz],yellow,black);
              end
            else
              begin {sobreescritura}
                Delete(sCad,iP,1);
                Insert(cCar,sCad,iP);
                if iP=iLongVentana+iDesplaz then
                  iDesplaz:=iDesplaz+1;
                if iP<iLongitudMax then
                  iP:=iP+1;
                for iI:=1 to iLongVentana do
                  WriteRapido(iX+iI,iY,sCad[iI+iDesplaz],Yellow,Black);
              end
           end;
        end

      else {no es el ultimo caracter}
        begin
         if bInsercion
         then
           Insert(cCar,sCad,iP)
         else
           begin
             Delete(sCad,iP,1);
             Insert(cCar,sCad,iP);
           end;
         if iP=iLongVentana+iDesplaz
         then
           iDesplaz:=iDesplaz+1;
         if iP<iLongitudMax
         then
           iP:=iP+1;
         for iI:=1 to iLongVentana do
           WriteRapido(iX+iI,iY,sCad[iI+iDesplaz],Yellow,Black);
        end;

    Retroceso:
      if iP>1 then
        begin
          iP:=iP-1;
          delete(sCad,iP,1);
          sCad:=sCad+Chr(iCarFondo);
          if iDesplaz>1 then iDesplaz:=iDesplaz-1;
          for iI:=1 to iLongVentana do
            writeRapido(iX+iI,iY,sCad[iI+iDesplaz],yellow,black);
          cCar:=' ';
        end
      else
        begin
          Beep(100,100);
          cCar:=' ';
          iP:=1;
        end;

    FlechaIzq:
      if iP>1 then
        begin
          iP:=iP-1;
          if iP<=iDesplaz then
            begin
              iDesplaz:=iDesplaz-1;
              for iI:=1 to iLongVentana do
                WriteRapido(iX+iI,iY,sCad[iI+iDesplaz],yellow,black);
            end
        end
      else
        begin
          Beep(100,100);
        end;

    FlechaDer:
      if (sCad[iP]<>chr(iCarFondo)) and (iP<iLongitudMax) then
        begin
          iP:=iP+1;
          if iP>=(iLongVentana+iDesplaz+1) then
            begin
              iDesplaz:=iDesplaz+1;
              for iI:=1 to iLongVentana do
                WriteRapido(iX+iI,iY,sCad[iI+iDesplaz],yellow,black);
            end;
        end
      else
        begin
          Beep(100,100);
        end;

    Supr:
      begin
       delete(sCad,iP,1);
       sCad:=sCad+chr(iCarFondo);
       for iI:=1 to iLongVentana do
         writeRapido(iX+iI,iY,sCad[iI+iDesplaz],yellow,black);
      end;

    Ins:
      if bInsercion then
        begin
          bInsercion:=false;
          DimCursor(2); {cursor Grande}
        end
      else
        begin
          bInsercion:=true;
          DimCursor(1); {cursor Peque¤o}
        end;

    else (*case*)
      if not(LaTecla in [RetornoCarro,FlechaArriba,FlechaAbajo,
                         RePag,AvPag,Esc,Tabulador,TeclaNula,
                         F1,F2,F3,F4,F5,F6,F7,F8,F9,F10])
        then Beep(100,100)
  end; (*case*)

until (LaTecla in [RetornoCarro,FlechaArriba,FlechaAbajo,
                   RePag,AvPag,Esc,Tabulador,
                   F1,F2,F3,F4,F5,F6,F7,F8,F9,F10]);

EstCadena;
end; (*procedure LeerCadena*)





procedure CopyFichero(sNombre1,sPath1,sNombre2,sPath2:string;
                      bSobreEscribir:boolean; var iError:integer);
var
 f1,f2:file;
 w1,w2:word;
 buffer:array[0..1023] of byte;

begin
iError:=0;

assign(f1,sPath1+sNombre1);
{$I-}
reset(f1,1);
if IOResult<>0
then
  begin
    iError:=1;
    exit;
  end;

assign(f2,sPath2+sNombre2);
reset(f2,1);
if IOResult=0
then
  if bSobreEscribir
  then
    begin
      iError:=-1;
      close(f2);
    end
  else
    begin
      iError:=3;
      close(f2);
      exit;
    end;
{$I+}
rewrite(f2,1);

while not eof(f1) do
  begin
    BlockRead(f1,buffer,SizeOf(buffer),w1);
    BlockWrite(f2,buffer,w1,w2);
  end;

close(f1);
close(f2);
end; (*procedure CopyFichero*)





begin

wSegVid:=SegVid;

end.


