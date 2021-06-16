{
  Curso: Graficos en Pascal (MS-DOS), Programa 3
  Autor: Juan Carlos Perez Casal (Chou)

  Este programa explica el uso de la unidad Teclas y es una animacion
  de un pegaso (32 imagenes) manejable por teclado (cursores)

  Este curso necesita que se compilen los archivos imagen, pcx y teclas
  Hay que poner los archivos TPU resultantes en la ruta de los
  "Unit directories", dentro de Options->Directories
}

program CursoGrafico3;
uses
  crt, graph, imagen, pcx, teclas;

type
  tDirec=(Arr,ArrDer,Der,AbaDer,Aba,AbaIzq,Izq,ArrIzq); {Las 8 direcciones}

var
  i,error:integer;
  x,y,                       {Posicion del pegaso}
  Imag,ContImag,RetrasoImag, {Se usan para el cambio de imagen (aleteo)}
  cont,Retraso:integer;      {Retraso de la velocidad de movimiento}
  Direc:tDirec;              {Direccion del pegaso}
  Pegaso:array[0..7,0..3] of tImagen; {Usamos 4 imagenes para cada direccion}
  Paleta:tPaleta; {Usamos una paleta para coger la paleta que usa cada Pcx}
  wPant:word;     {La pantalla virtual}
  str1:string;    {Para escibir en la pantalla virtual}
  col8:tColor8;   {Usado por WriteColorWhere, son 8 colores para las letras}

begin
  clrscr;


  for x:=0 to 7 do {cada direccion}
    for i:=0 to 3 do {cada imagen de la direccion}
      begin
        LoadImagenPcxXY('pegasi.pcx', 'anim', 129+49*x, 49*i+1, 129+49*x+47, 49*i+48,
                        Pegaso[x,i], error); {Tama¤o 48*48}

        gotoxy(1,1);
        writeln('Cargando las imagenes');
        gotoxy(1,3);
        writeln('Direccion=',x,',Imagen=',i);
        gotoxy(1,5);
        writeln('Memoria=',MemAvail);
      end;

  gotoxy(1,1);
  writeln('Creando la pantalla virtual');
  gotoxy(1,5);
  writeln('Memoria=',MemAvail);

  wPant:=CrearPantalla; {Crea una pantalla virtual identificada por wPant}


  {La Unit Teclas proporciona un control total del teclado, podemos
   saber que teclas estan pulsadas en un determinado momento (KeyDown)
   y cuales se pulsaron durante un periodo (ClearWasDownArray - WasDown).
   Funciona si se pulsan varias teclas la vez, pero no demasiadas.
   Mientras este activado no se pueden usar las funciones de entrada de
   datos por teclado (read,keypressed), solo las de la unit Teclas}
  NewKeyInt; {Activa el modo de teclado especial, desactiva funciones teclado}


  IniciaSVGA256(0, '', error); {inicia el modo grafico a 320*200}
  if error <> GrOK then
    begin
      writeln('Error de inicializacion SVGA: ', GraphErrorMsg(error));
      repeat
      until KeyPressed; {espera a que se pulse una tecla}
      halt; {sale del programa}
    end;

  GetPalPcx('pegasi.pcx', 'anim', Paleta, error); {coge paleta del pcx}
  SetPaleta(Paleta); {Pone la paleta}


  {Pegaso empieza en el centro de la pantalla}
  x:=(GetMaxX - Pegaso[0,0].TamanoX) div 2;
  y:=(GetMaxY - Pegaso[0,0].TamanoY) div 2;

  Imag:=0;         {pone la 1¦ imagen de las 4}
  contImag:=0;     {cuenta las vueltas del bucle}
  RetrasoImag:=50; {cada RetrasoImag vueltas se cambia la imagen pegaso}

  Direc:=Der; {empieza apuntando a la derecha}
  cont:=0;    {cuenta las vueltas del bucle}
  Retraso:=4; {cada Retraso vueltas se puede mover el pegaso, a mayor
               retraso menor velocidad, retraso 1 es velocidad maxima}

  repeat
    ClsWhere(0, wPant); {llena la pantalla con color negro}


    {Vamos a poner la memoria libre en la pantalla virtual en verde}
    str(MemAvail,str1);
    WriteWhere(200, 190, 52, -1, str1, wPant);
    {WriteWhere(iX,iY,iColor,iFondo:integer; sText:string; where:word);
     (iX,iY): Posicion dibuja Texto
     iColor: Color del que dibuja las letras, -1 no las dibuja
     iFondo: Color del fondo de las letras, -1 no lo dibuja
     sTexto: Cadena que se escribe
     where: Pantalla donde se escribe}

    for i:=0 to 7 do
      col8[i]:=82+i; {Define un grupo de colores de rojizo a amarillo}
    str1:='X='+IntAStr(x)+',Y='+IntAStr(y); {IntAStr: entero a string}
    WriteColorWhere(20, 190, -1, str1, col8, wPant);
    {WriteColorWhere(iX,iY,iFondo:integer; sText:string;
                     color:tColor8; where:word);
     (iX,iY): Posicion dibuja Texto
     iFondo: Color del fondo de las letras, -1 no lo dibuja
     sTexto: Cadena que se escribe
     color: Las letras usan 8 colores en vertical (un color para lineas horiz)
     where: Pantalla donde se escribe}


    PutImagenXYSinWhere320(x, y, Pegaso[ord(Direc),Imag], 11, wPant);
    {PutImagenXYSinWhere320(iXini,iYini:integer; Imagen:tImagen;
                            iSin:integer; where:word);
     Esta version 320 no dibuja nada fuera de los bordes pantalla 320*200.
     Si no, lo que sobresale del margen derecho aparece en el izquierdo
     y lo de arriba sale abajo, prueba a quitar el 320 para verlo}

    flip(wPant, SegA000); {visualiza la pantalla virtual}


    {Cambia las imagenes del pegaso (hace el efecto de mover las alas)}
    ContImag:=ContImag+1;
    if ContImag >= RetrasoImag then
      begin
        ContImag:=0;
        Imag:=Imag+1;
        if Imag > 3 then
          Imag:=0;
      end;


    {Permite el movimiento cada Retraso vueltas del bucle}
    cont:=cont+1;
    if cont >= Retraso then
      begin
        cont:=0;

        {KeyDown,WasDown:array[0..127] of boolean; (unit Teclas)}
        {KeyDown es una variable global que contiene un array de 128 teclas
         de las que guarda un boleano que indica si esa tecla esta pulsada.
         Hay constantes definidas para saber que posicion ocupan en el
         array de teclas, por ej: entScan,backScan(Del),rshScan(Shift der)
         Para las teclas normales (letras, numeros y en general las que
         escriben algun caracter cuando las pulsas) se usa la funcion
         ScanOf(CaracterDeLaTecla) que devuelve la posicion en el array}

        if KeyDown[rightScan] then
          x:=x+1;
        if KeyDown[leftScan] then
          x:=x-1;
        if KeyDown[downScan] then
          y:=y+1;
        if KeyDown[upScan] then
          y:=y-1;

        {Calcula la Direccion}
        if KeyDown[rightScan] then
          if KeyDown[upScan] then
            Direc:=ArrDer
          else
            if KeyDown[downScan] then
              Direc:=AbaDer
            else
              Direc:=Der
        else
          if KeyDown[leftScan] then
            if KeyDown[upScan] then
              Direc:=ArrIzq
            else
              if KeyDown[downScan] then
                Direc:=AbaIzq
              else
                Direc:=Izq
          else
            if KeyDown[upScan] then
              Direc:=Arr
            else
              if KeyDown[downScan] then
                Direc:=Aba;
      end;

  until KeyDown[escScan]; {Sale si la tecla escape esta pulsada}


  repeat
  until not TeclaPulsada; {Espera a que no se pulse ninguna tecla}


  OldKeyInt; {Activa el modo de teclado normal, desactiva KeyDown...}
  CloseGraph; {termina el modo grafico}
end.
