{
  Curso: Graficos en Pascal (MS-DOS), Programa 1
  Autor: Juan Carlos Perez Casal (Chou)

  Este programa explica como se inicia el modo grafico en SVGA
  y como funciona el tipo tImagen, que almacena graficos

  Este curso necesita que se compilen los archivos imagen, pcx y teclas
  Hay que poner los archivos TPU resultantes en la ruta de los
  "Unit directories", dentro de Options->Directories
}

program CursoGrafico1;
uses
  crt, graph, imagen;
var
  x,error:integer;
  cuadrado:tImagen; {tipo que contine una imagen a 256 colores (unidad imagen)}

begin
  clrscr;

  {Empezamos iniciando el modo grafico con un procedim de la unidad imagen}
  IniciaSVGA256(3, '', error);
  {IniciaSVGA256(iModo:integer; sPath:string; var iError:integer);
   iModo: es el modo grafico (resolucion), es de 0 a 4
     0 -  320*200*256 (Nง puntos ancho * Nง puntos alto * Nง colores)
     1 -  640*400*256
     2 -  640*480*256
     3 -  800*600*256
     4 - 1024*768*256
   sPath: es la ruta del archivo svga256.bgi, la interfaz grafica de borland.
     Por ejemplo 'c:\tp\bgi' o '' si esta en el directorio actual
   iError: dice si hay un error (no se puede iniciar el modo grafico)
     es el resultado de GraphResult, una funcion la unidad Graph que viene en
     la ayuda. Si no hay errores iError=GrOk}

  {Salimos si hay errores y ponemos mensaje con el tipo de error}
  if error <> GrOK then {GrOk=0 es no error}
    begin
      writeln('Error de inicializacion SVGA: ', GraphErrorMsg(error));
      repeat
      until KeyPressed; {espera a que se pulse una tecla}
      halt; {sale del programa}
    end;
  {La funcion GraphErrorMsg y la constante GrOk son de la unidad Graph}


  {Ahora ya estamos en modo grafico (a 800x600), las coordenadas (x,y) son
     ษออออออออออออออออออออออออออออออออป
     บ (0,0)                  (799,0) บ
     บ                                บ
     บ                                บ
     บ (0,599)              (799,599) บ
     ศออออออออออออออออออออออออออออออออผ
  Vamos a llenar la pantalla de lineas de colores}
  for x:=0 to GetMaxX do {GetMaxX es la posic del punto mas a la derecha (799)}
    begin
      SetColor(x); {escoge el color del que se pintan las lineas}
      {Hay 256 colores (0..255) que forman un byte. A partir del ultimo
      color (255) los colores dan la vuelta (vuelven a cero)}
      line(x, 0, x, GetMaxY); {lineas verticales, van de (i,0) a (i,599)}
    end;
  {Las funciones GetMaxX, GetMaxY, SetColor y Line son de la unidad Graph}

  {Ahora usamos la variable tipo tImagen cuadrado para guardar un trozo
   cuadrado de la pantalla, cogeremos por ejemplo el de (50,0) de tamaคo 100}
  GetImagen(50, 0, 150, 100, cuadrado);
  {GetImagen(iXini,iYini,iXfin,iYfin:integer; var Imagen:tImagen);
   (iXini,iYini) es la coordenada izquierda superior del rectangulo
   (iXfin,iYfin) es la coordenada derechada inferior del rectangulo
   Imagen: guarda el rectangulo elegido de la pantalla}

  readln; {espera a que se pulse Enter}


  ClearViewPort; {Borra la pantalla}
  {ClearDevice;  {tambien la borra}

  {Vamos a explorar las diferentes formas de poner una imagen en la pantalla}

  {ponemos la imagen en la parte arriba izquierda pantalla
   de la forma normal (copiandola como es)}
  PutImagenXY(0, 0, cuadrado);
  {PutImagenXY(iXini,iYini:integer; Imagen:tImagen);
   (iXini,iYini) es la coordenada donde se pone la imagen
   Imagen: es la imagen que vamos a poner}

  {ponemos la imagen en la parte arriba derecha pantalla
   solo se dibuja una parte de la imagen}
  PutImagenXYXY(600, 0, 0, 0, 50, 50, cuadrado);
  {PutImagenXYXY(iX,iY,iXini,iYini,iXfin,iYfin:integer; Imagen:tImagen);
   (iX,iY) es la coordenada donde se pone la imagen
   (iXini,iYini) es la coordenada izquierda superior del rectangulo
   (iXfin,iYfin) es la coordenada derechada inferior del rectangulo
   el rectangulo se refiere al trozo de imagen que se pondra en pantalla}

  {ponemos la imagen en la parte abajo izquierda pantalla
   se dibuja toda la imagen menos un color (si ese color no esta en la imagen no pasa nada)
   Esta opcion se usa para no dibujar el color de fondo de una imagen}
  PutImagenXYSin(0, 400, cuadrado, 90);
  {procedure PutImagenXYSin(iXini,iYini:integer; Imagen:tImagen; iSin:integer);
   (iXini,iYini) es la coordenada donde se pone la imagen
   iSin: color que no se dibujara}

  {ponemos la imagen en la parte abajo derecha pantalla
   se dibuja la imagen el doble, triple... de grande (Radio veces mas grande)}
  PutImagenXYBig(600, 400, cuadrado, 2);
  {PutImagenXYBig(iX,iY:integer; Imagen:tImagen; iRadio:integer);
   (iX,iY) es la coordenada donde se pone la imagen
   iRadio: multiplica el tamaคo de cada punto de la imagen}

  readln; {espera a que se pulse Enter}


  {Hagamos una animacion muy simple, mover el cuadrado de izquierda a derecha}
  {Esta animacion tiene varios defectos que solucionaremos mas adelante}
  x:=0;
  repeat
    ClearViewPort; {Borra la pantalla}
    PutImagenXY(x, 200, cuadrado); {Pone la imagen}
    x:=x+10; {mueve la imagen 10 puntos a la derecha}
  until x+cuadrado.TamanoX >= GetMaxX;
  {acabar cuando la parte derecha del cuadrado salga fuera de la pantalla}

  {Las variables tipo tImagen disponen de informacion sobre su tamaคo
   Imagen.TamanoX = Nง puntos de ancho, Imagen.TamanoY = Nง puntos de alto}


  readln;
  CloseGraph; {volvemos al modo texto}
end.
