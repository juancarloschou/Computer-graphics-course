{
  Curso: Graficos en Pascal (MS-DOS), Programa 4
  Autor: Juan Carlos Perez Casal (Chou)

  Este programa mejora la animacion del pegaso manejable por teclado,
  con las teclas + y - se puede cambiar la imagen animada.

  Este curso necesita que se compilen los archivos imagen, pcx y teclas
  Hay que poner los archivos TPU resultantes en la ruta de los
  "Unit directories", dentro de Options->Directories
}

program CursoGrafico4;
uses
  crt, graph, imagen, pcx, teclas;

type
  tDirec=(Arr,ArrDer,Der,AbaDer,Aba,AbaIzq,Izq,ArrIzq); {Las 8 direcciones}

var
  i,j,error:integer;
  x,y,                       {Posicion del pegaso}
  Imag,ContImag,RetrasoImag, {Se usan para el cambio de imagen (aleteo)}
  cont,Retraso:integer;      {Retraso de la velocidad de movimiento}
  Direc:tDirec;              {Direccion del pegaso}
  Pegaso:array[0..7,0..3] of tImagen; {Las 32 imagenes individuales}
  ImgGrande,ImgGrande2:tImagen;       {Conjunto de todas las imagenes}
  Paleta:tPaleta;  {Usamos una paleta para coger la paleta que usa cada Pcx}
  wPant:word;      {La pantalla virtual}
  str1,            {Para escibir en la pantalla virtual}
  sFichPcx:string; {Nombre del archivo que contiene todas las imagenes}
  Fich:integer;    {Identifica el archivo usado actualmente}
  col8:tColor8;    {Usado por WriteColorWhere, son 8 colores para las letras}



procedure CargarImagenes;
  {Lo primero que voy a cambiar es la forma de cargar las imagenes porque
  tardaba mucho (se leia 32 veces el archivo Pcx). Lo ideal es leerlo una
  vez y dividirlo en las 32 imagenes individuales con GetImagenImagen
  que pone una parte de una imagen (Desde) en otra imagen (Hasta).
  Pero una imagen tiene un tama¤o maximo de 64000 bytes (320*200) y la del
  fichero Pcx ocupa (519-128)*(195-0) = 76245 bytes, se usan 2 imagenes}

begin
  gotoxy(1,1);
  writeln('Cargando la 1¦ imagen grande');
  gotoxy(1,5);
  writeln('Memoria=',MemAvail);

  LoadImagenPcxXY(sFichPcx, 'anim', 128, 0, 323, 195, ImgGrande, error);
  if error<>0 then
    begin
      gotoxy(1,3);
      writeln('Error=',error);
      PausaUnitTeclas;
      halt;
    end;

  gotoxy(1,1);
  writeln('Cargando la 2¦ imagen grande');
  gotoxy(1,5);
  writeln('Memoria=',MemAvail);

  LoadImagenPcxXY(sFichPcx, 'anim', 324, 0, 519, 195, ImgGrande2, error);
  if error<>0 then
    begin
      gotoxy(1,3);
      writeln('Error=',error);
      PausaUnitTeclas;
      halt;
    end;

  gotoxy(1,1);
  writeln('Cargando las imagenes       ');
  gotoxy(1,5);
  writeln('Memoria=',MemAvail);

  for j:=0 to 7 do {cada direccion}
    for i:=0 to 3 do {cada imagen de la direccion}
      begin
        {FreeImagen(var Imagen:tImagen);
         Hasta: Imagen que se libera de la memoria (se elimina la imagen)}
        FreeImagen(Pegaso[j,i]); {Liberamos todas las imag de la animacion}

        {GetImagenImagen(iXini,iYini,iXfin,iYfin:integer; var Hasta:tImagen;
                         var Desde:tImagen);
         (iXini,iYini) posicion esquina arriba izquierda rectangulo
         (iXfin,iYfin) posicion esquina abajo derecha rectangulo
         Hasta: Imagen recibe el rectangulo
         Desde: Imagen de donde procede el rectangulo}

        if j<4 then
          GetImagenImagen(49*j+2, 49*i+1, 49*j+48, 49*i+48, Pegaso[j,i],
                          ImgGrande) {Tama¤o 48*48}
        else
          GetImagenImagen(49*(j-4)+2, 49*i+1, 49*(j-4)+48, 49*i+48, Pegaso[j,i],
                          ImgGrande2); {Tama¤o 48*48}

        gotoxy(1,3);
        writeln('Direccion=',j,',Imagen=',i);
        gotoxy(1,5);
        writeln('Memoria=',MemAvail);
      end;

  gotoxy(1,1);
  writeln('Borrando las imagenes       ');
  gotoxy(1,5);
  writeln('Memoria=',MemAvail);

  FreeImagen(ImgGrande); {liberamos las imagenes grandes}
  FreeImagen(ImgGrande2);

end; {CargarImagenes}



begin
  clrscr;

  NewKeyInt; {Activa el modo de teclado especial, desactiva funciones teclado}


  sFichPcx:='pegasi.pcx'; {La primera animacion sera la del pegaso}

  CargarImagenes;


  wPant:=CrearPantalla; {Crea una pantalla virtual identificada por wPant}


  IniciaSVGA256(0, '', error); {inicia el modo grafico a 320*200}
  if error <> GrOK then
    begin
      writeln('Error de inicializacion SVGA: ', GraphErrorMsg(error));
      repeat
      until TeclaPulsada; {espera a que se pulse una tecla}
      halt; {sale del programa}
    end;

  GetPalPcx(sFichPcx, 'anim', Paleta, error); {coge paleta del pcx}
  SetPaleta(Paleta); {Pone la paleta}


  Fich:=20; {Empieza con el archivo del pegaso}

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

  ClearWasDownArray; {Pone a false el array WasDown}


  repeat
    ClsWhere(34, wPant); {llena la pantalla con color azul}

    {Vamos a poner el nombre del fichero Pcx en la pantalla virtual}
    WriteWhere(200, 190, 52, -1, QuitaExtension(sFichPcx), wPant);

    for i:=0 to 7 do
      col8[i]:=82+i; {Define un grupo de colores de rojizo a amarillo}
    str1:='X='+IntAStr(x)+',Y='+IntAStr(y); {IntAStr: entero a string}
    WriteColorWhere(20, 190, -1, str1, col8, wPant);

    {WriteWhere(125, 180, 60, -1, IntAStr(MemAvail), wPant);}

    PutImagenXYSinWhere320(x, y, Pegaso[ord(Direc),Imag], 11, wPant);

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


    {Cambiar de archivo de imagenes}
    if KeyDown[ScanOf('+')] or KeyDown[MasScan] or
       KeyDown[ScanOf('-')] or KeyDown[MenosScan] then
    {ScanOf(+/-) son las teclas +/- blancas, a la izquierda del Enter
     Mas/MenosScan son las teclas +/- grises, en el extremo derecho}
      begin
        if KeyDown[ScanOf('+')] or KeyDown[MasScan] then
          begin
            Fich:=Fich+1;
            if Fich>29 then
              Fich:=0;
          end;
        if KeyDown[ScanOf('-')] or KeyDown[MenosScan] then
          begin
            Fich:=Fich-1;
            if Fich<0 then
              Fich:=29;
          end;

        case Fich of
          0: sFichPcx:='archons.pcx';
          1: sFichPcx:='barge.pcx';
          2: sFichPcx:='bats.pcx';
          3: sFichPcx:='boneship.pcx';
          4: sFichPcx:='cavewyrm.pcx';
          5: sFichPcx:='dragon.pcx';
          6: sFichPcx:='dwarfmut.pcx';
          7: sFichPcx:='eagles.pcx';
          8: sFichPcx:='elem_fir.pcx';
          9: sFichPcx:='elephant.pcx';
          10: sFichPcx:='fdemon.pcx';
          11: sFichPcx:='giants.pcx';
          12: sFichPcx:='griffons.pcx';
          13: sFichPcx:='icegard.pcx';
          14: sFichPcx:='liche.pcx';
          15: sFichPcx:='lightcav.pcx';
          16: sFichPcx:='minotaur.pcx';
          17: sFichPcx:='moongard.pcx';
          18: sFichPcx:='ogres.pcx';
          19: sFichPcx:='orogs.pcx';
          20: sFichPcx:='pegasi.pcx';
          21: sFichPcx:='plague_c.pcx';
          22: sFichPcx:='slayers.pcx';
          23: sFichPcx:='spiders.pcx';
          24: sFichPcx:='treants.pcx';
          25: sFichPcx:='trolls.pcx';
          26: sFichPcx:='undead_b.pcx';
          27: sFichPcx:='wargs.pcx';
          28: sFichPcx:='warship.pcx';
          29: sFichPcx:='wolfrdr.pcx';
        end;

        CargarImagenes;
      end;


    {Permite el movimiento cada Retraso vueltas del bucle}
    cont:=cont+1;
    if cont >= Retraso then
      begin
        cont:=0;

        {Mover la imagen}
        if KeyDown[rightScan] and (x+Pegaso[0,0].TamanoX<GetMaxX) then
          x:=x+1;
        if KeyDown[leftScan] and (x>0) then
          x:=x-1;
        if KeyDown[downScan] and (y+Pegaso[0,0].TamanoY<GetMaxY) then
          y:=y+1;
        if KeyDown[upScan] and (y>0) then
          y:=y-1;

        {Calcular la Direccion}
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

  until WasDown[escScan]; {Sale si se ha pulsado la tecla escape}
  {KeyDown,WasDown:array[0..127] of boolean; (unit Teclas)}
  {WasDown es una varible global que contiene un array de 128 teclas
   de las que guarda un boleano que indica si esa tecla ha sido
   pulsada desde la ultima vez que se hizo un ClearWasDownArray,
   que pone todo el array a false. La pega es que no funciona con
   varias teclas pulsadas al mismo tiempo}
  {La diferencia en este caso es que se mira si la tecla escape ha sido
   pulsada en algun momento desde que empezo el bucle}


  repeat
  until not TeclaPulsada; {Espera a que no se pulse ninguna tecla}


  OldKeyInt; {Activa el modo de teclado normal, desactiva KeyDown...}
  CloseGraph; {termina el modo grafico}
end.
