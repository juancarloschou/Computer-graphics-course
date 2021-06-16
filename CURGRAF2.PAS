{
  Curso: Graficos en Pascal (MS-DOS), Programa 2
  Autor: Juan Carlos Perez Casal (Chou)

  Este programa explica el uso de archivos de imagen Pcx,
  de la Paleta y de Pantallas Virtuales

  Este curso necesita que se compilen los archivos imagen, pcx y teclas
  Hay que poner los archivos TPU resultantes en la ruta de los
  "Unit directories", dentro de Options->Directories
}

program CursoGrafico2;
uses
  crt, graph, imagen, pcx;
var
  x,error:integer;
  Derecha:boolean; {Direccion de la animacion}
  Penta,JinJan,Platillo:tImagen; {Usaremos 3 imagenes}
  Paleta:tPaleta; {Usamos una paleta para coger la paleta que usa cada Pcx}
  wPant:word; {La pantalla virtual}

begin
  clrscr;

  IniciaSVGA256(0, '', error); {inicia el modo grafico a 320*200}
  if error <> GrOK then
    begin
      writeln('Error de inicializacion SVGA: ', GraphErrorMsg(error));
      repeat
      until KeyPressed; {espera a que se pulse una tecla}
      halt; {sale del programa}
    end;


  {Vamos a usar tImagen para coger un grafico de un archivo PCX. (Unit Pcx)
   Los Pcx son ficheros de imagenes como los jpg,gif,bmp,tga,png...
   si tenemos un formato diferente hay que convertirlo a Pcx de 256 colores.
   El Deluxe Paint 2 incluido en el curso es un editor grafico que trabaja
   con Pcx y Lbm, usa 320*200*256, es peque¤o y bueno pero es muy viejo}

  LoadImagenPcxXY('penta.pcx', '', 0, 0, 60, 60, Penta, error); {Pentagrama}
  {LoadImagenPcxXY(sNombre,sPath:string; iXini,iYini,iXfin,iYfin:integer;
                   var Imagen:tImagen; var iError:integer);
   sNombre,sPath: Nombre y direccion (ruta) del archivo Pcx
   (iXini,iYini) es la coordenada izquierda superior del rectangulo
   (iXfin,iYfin) es la coordenada derechada inferior del rectangulo
   Imagen: recibe el rectangulo elegido del archivo Pcx
   iError: codigo de error, 0=no error, 1=archivo no existe}


  {Una Paleta es una tabla donde se define el color que corresponde a cada
  uno de los 256 posibles. Cada color esta formado por 3 bytes, uno para el
  rojo, otro el verde y el ultimo azul, sus valores van de 0 a 63.
  Asi el color 0 (negro) sera (0,0,0) y el 15 (blanco) es (63,63,63).
  Las utilidades para paletas se incluyen en la Unit Imagen}

  GetPalPcx('penta.pcx', '', Paleta, error); {Cogemos la paleta del pcx}
  {GetPalPcx(sNombre,sPath:string; var Paleta:tPaleta; var iError:integer);
   sNombre,sPath: Nombre y direccion (ruta) del archivo Pcx
   Paleta: recibe la paleta del archivo Pcx
   iError: codigo de error, 0=no error, 1=archivo no existe}

  SetPaleta(Paleta);
  {activa la paleta y ahora podemos dibujar la imagen con sus colores reales}

  PutImagenXYSin(130,70,Penta,255); {Pone la imagen en la posicion (130,70)}
  {El color 255 (ultimo) no se dibuja}

  readln;


  {Este ejemplo dibuja una imagen Pcx directamente en pantalla sin usar tImagen}
  ClearDevice; {Borra pantalla}

  {Dibuja en pantalla un archivo Pcx, no se puede quitar el color de fondo}
  LoadPcxXY('tierra.pcx', '', 0, 0, true, error);
  {LoadPcxXY(sNombre,sPath:string; iX,iY:integer;
                    bLoadPal:boolean; var iError:integer);
   sNombre,sPath: Nombre y direccion (ruta) del archivo Pcx
   (iX,iY) posicion de pantalla donde se dibuja
   bLoadPal: si true se activa la paleta del archivo Pcx
   iError: codigo de error, 0=no error, 1=archivo no existe}

  readln;


  {Ahora es el momento de aprender a usar Pantallas Virtuales: (unit Imagen)
   La pantalla es un conjunto de 320*200 puntos y cada punto tiene 256 colores
   para almacenar esto en una variable necesitamos 64000 bytes (320*200)
   y 64000 bytes es casi el maximo tama¤o posible de una varible en Turbo
   Pascal, asi que estamos limitados a esa resolucion y a 256 colores.
   La pantalla virtual es una variable que contiene una pantalla en memoria,
   diferente a la pantalla del monitor que se identifica por SegA000.
   Se pueden usar las funciones para pantalla virtual con SegA000 de
   parametro para que dibuje el resultado en el monitor}

  {Este ejemplo crea una pant virtual y dibuja una imagen en ella,
   despues copia la pant virtual en la pantalla real (monitor)}

  wPant:=CrearPantalla;
  {Crea una pantalla virtual identificada por wPant de tipo word (0..65535)}

  {Borramos la pantalla virtual wPant, porque puede tener basura}
  ClsWhere(0, wPant); {llena la pantalla del color elegido (0=negro)}
  {ClsWhere(yColor:Byte ;where:word);}

  LoadImagenPcx('jinjan.pcx', '', JinJan, error); {crea Imagen de un Pcx}
  {No tiene parametros del rectangulo y se coge la imagen completa}
  GetPalPcx('jinjan.pcx', '', Paleta, error); {Cogemos la paleta del pcx}
  SetPaleta(Paleta); {activa la paleta}

  {Pone la imagen en posicion (50,0) sin el color 255 en la pantalla wPant}
  PutImagenXYSinWhere(100, 0, JinJan, 255, wPant); {Where representa una Pantalla}
  {PutImagenXYSinWhere(iXini,iYini:integer; Imagen:tImagen;
                       iSin:integer; where:word);}

  {Ahora la imagen esta en la pantalla wPant, para verla por el monitor
   copiamos la pant virtual wPant en la pantalla real SegA000}
  flip(wPant, SegA000);
  {flip(wDesde,wHasta:Word); {Copia el contenido de una pantalla en otra}

  readln;


  {Por ultimo vamos a mejorar la animacion con pcx y con una pantalla virtual
   Mover un platillo volante de izquierda a derecha y que de la vuelta}

  LoadImagenPcxXY('platillo.pcx', '', 3, 2, 143, 51, Platillo, error);
  {El rectangulo de la imagen hay que mirarlo editando el Pcx, (3,2)-(143,51)}
  {En el Deluxe Paint 2 activar Misc->Coordinates para ver la posicion cursor}
  GetPalPcx('platillo.pcx', '', Paleta, error); {coge paleta del pcx}
  SetPaleta(Paleta); {Pone la paleta}

  x:=0; {Posicion horizontal empieza en 0}
  Derecha:=true; {Va en direccion hacia la derecha}
  repeat
    ClsWhere(237, wPant); {Llena la pantalla de color azul}
    PutImagenXYSinWhere(x, 50, Platillo, 255, wPant); {Pone la imagen en wPant}
    flip(wPant, SegA000); {visualiza la pantalla virtual wPant}

    if Derecha then
      begin
        x:=x+1; {mueve la imagen 1 punto a la derecha}
        if x+Platillo.TamanoX > GetMaxX then
          Derecha:=false; {da la vuelta}
      end
    else
      begin
        x:=x-1; {mueve la imagen 1 punto a la izquierda}
        if x < 0 then
          Derecha:=true; {da la vuelta}
      end;

  until KeyPressed; {Si se pulsa una tecla}


  readln;
  CloseGraph; {termina el modo grafico}
end.
