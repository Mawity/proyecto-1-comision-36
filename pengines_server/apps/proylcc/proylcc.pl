:- module(proylcc,
	[  
		put/8
	]).

:-use_module(library(lists)).
:-use_module(library(clpfd)).





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% replace(+Position, +Pintar, +Grilla, -GrillaRes)
% Reemplaza el valor de una Position dada de una Grilla con Pintar. Si el valor 
% en la posicion Position de Grilla es igual a Pintar, se reemplaza por _.
%

replace([0, C], Pintar, [G|Gs], [Res|Gs]):-
    pintarEnFila(G, C, Pintar, Res),
    !.

replace([F, C], Pintar, [G|Gs], [G|Rs]):-
    F>0,
    FAux is F - 1,
    replace([FAux, C], Pintar, Gs, Rs).
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% pintarEnFila(+Position, +Index, +Simbolo, -GrillaRes)
% Reemplaza el valor de una Lista en posicion Index dado con Simbolo. Si Index
% es 0 entonces devuelve Lista con el primer elemento igual a _ o Simbolo, 
% dependiendo de si el primer elemento de la lista es igual a Simbolo.  
%

pintarEnFila([F|Fs], 0, Simbolo, [QuedaPintado|Fs]):-
    (F == Simbolo -> QuedaPintado = "_"; QuedaPintado = Simbolo).


pintarEnFila([F|Fs], Index, Simbolo, [F|Rs]):-
    Index>0,
    IndexAux is Index - 1,
    pintarEnFila(Fs, IndexAux, Simbolo, Rs).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% filaEsCorrecta(+Fila, +PistasFilas)
% Es verdadero si Fila cumple las condiciones dadas por PistasFilas.
% 
%

filaEsCorrecta([],[]).

filaEsCorrecta(Fila, [Part|Rest]) :-
    Rest \= [],
    saltearEspaciosIniciales(Fila, Fila2),
    parteEsCorrecta(Fila2, Fila3, Part),
    espacioObligatorio(Fila3, Fila4),
    filaEsCorrecta(Fila4, Rest).

filaEsCorrecta(Fila, [Part|[]]) :-
    saltearEspaciosIniciales(Fila, Fila2),
    parteEsCorrecta(Fila2, Fila3, Part),
    saltearEspaciosIniciales(Fila3, Fila4),
    filaEsCorrecta(Fila4, []).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% parteEsCorrecta(+Fila, -RestFila, +N)
% Es verdadero si Fila tiene N '#'. Una vez leidos N #, devuelve el resto de la 
% fila RestFila.
%

parteEsCorrecta(Fila, Fila, 0).


parteEsCorrecta([X|Fila], RestFila, N) :-
    X == "#",
    N > 0,
    N1 is N - 1,
    parteEsCorrecta(Fila, RestFila, N1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% espacioObligario(+Lista, -RestFila)
% Es verdadero si el primer elemento de Lista es _ o 'X'. Devuelve la sublista 
% Fila, que es Lista sin su primer elemento.
%

espacioObligatorio(["_"|Fila],Fila).

espacioObligatorio(["X"|Fila],Fila).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% saltearEspaciosIniciales(+Fila, -RestFila)
% Se encarga de eliminar los _ o 'X' que se encuentran al comienzo de una lista 
% Fila. Devuelve Fila sin _ o 'X' al comienzo. 
%

saltearEspaciosIniciales(["#"|Resto], ["#"|Resto]).

saltearEspaciosIniciales([], []).

saltearEspaciosIniciales(["_"|Fila],RestFila) :-
    saltearEspaciosIniciales(Fila, RestFila).

saltearEspaciosIniciales(["X"|Fila],RestFila) :-
    saltearEspaciosIniciales(Fila, RestFila).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% crearMatrizVacia(+NFilas, +NCols, -Filas, -Columnas)
% Genera una matriz de NFilas x NCols de variables anonimas, las cuales pueden ser 
% accedidas a traves de Filas y Columnas, ambas siendo listas de filas o columnas
%

crearMatrizVacia(NFilas, NCols, Filas, Columnas) :-
    generarFilas(NFilas, NCols, Filas),
    transpose(Filas, Columnas).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% generarFilas(+NFilas, +NCols, -Filas)
% Genera una matriz de NFilas x NCols de variables anonimas como una lista de lista
% de filas.
%
generarFilas(NFilas, NCols, Filas) :-
    length(Filas, NFilas),
	maplist(crearFila(NCols),Filas).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% crearFila(+NCols, -Col)
% Se creo este predicado debido a la sintaxis de length, ya que al usar maplist en 
% generarFilas/3 se debe poner el predicado primero
%

crearFila(NCols,Col) :-
    length(Col,NCols).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% resolver(+Linea, +Pistas)
% Recibe una lista de lineas y una lista de pistas. La lista de lineas es modificada
% a lo largo del algoritmo para que eventualmente todas las lineas tengan una 
% configuracion que cumpla con todas las Pistas.
% Linea puede ser tanto una fila como una columna.
%

resolver(Linea, Pistas) :-
    juntar(Linea, Pistas, Paquete),
    sort(Paquete, SortedPaquete),
    resolver(SortedPaquete).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% resolver(+Linea)
% Recibe una lista de lineaInfo, que son terminos compuestos que guardan la cantidad 
% de configuraciones de una linea (Count), la Linea en si y la Pista que le corresponde.
% Dada esa Linea y Pista, generarFilaCorrecta y pasa al siguiente. El algoritmo es eficiente
% cuando la lista esta ordenada de menor a mayor Count.
% Linea puede ser tanto una fila como una columna.
%
resolver([]).
resolver([lineaInfo(_, Linea, Pista)|Rest]) :-
    generarFilaCorrecta(Linea, Pista),
    resolver(Rest).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% juntar(+Lineas, +Pistas, -LineasInfo)
% Recibe una lista de Lineas y una lista de Pistas, que son utilizadas para calcular
% la cantidad de combinaciones posibles que tiene una Linea dada cierta Pista. Esta 
% informacion es posteriormente juntada en un termino compuesto lineaInfo. Devuelve
% una lista de estos terminos, conteniendo asi todas las Lineas, Pistas y combinaciones 
% posibles en un mismo paquete para cada Linea.
% Linea puede ser tanto una fila como una columna.
%

juntar([], [], []).
juntar([Linea|Lineas], [Pista|Pistas], [lineaInfo(Count, Linea, Pista)|Result]) :-
    length(Linea, LineaLength),
    length(LineaPosible, LineaLength),
    findall(LineaPosible, generarFilaCorrecta(LineaPosible, Pista), LineasPosibles),
    length(LineasPosibles, Count),
    juntar(Lineas, Pistas, Result).   



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% generarFilaCorrecta(+Linea, -RestLinea)
% Este predicado y todos los que utiliza tienen escencialmente el mismo comportamiento
% que filaEsCorrecta/3 y los que estos utiliza, respectivamente, pero sin considerar 
% las "X" como espacio vacio, ya que esto causaba una cantidad innecesaria de posibilidades 
% de estados correctos de una fila. 
% Su unico proposito es generar todas las combinaciones de # en una linea dada una lista
% de restricciones. Linea puede ser tanto una fila como una columna.
%

generarFilaCorrecta([],[]) :- !.

generarFilaCorrecta(Linea, [Part|Rest]) :-
    Rest \= [],
    agregarEspacioOpcional(Linea, Linea2),
    generarParte(Linea2, Linea3, Part),
    agregarEspacioSeparador(Linea3, Linea4),
    generarFilaCorrecta(Linea4, Rest).

generarFilaCorrecta(Linea, [Part|[]]) :-
    agregarEspacioOpcional(Linea, Linea2),
    generarParte(Linea2, Linea3, Part),
    agregarEspacioOpcional(Linea3, Linea4),
    generarFilaCorrecta(Linea4, []).


agregarEspacioSeparador(["_"|Linea],Linea).


agregarEspacioOpcional(Linea, Linea).

agregarEspacioOpcional(["_"|Linea],RestLinea) :-
    agregarEspacioOpcional(Linea, RestLinea).


generarParte(Linea, Linea, 0).

generarParte(["#"|Linea], RestLinea, N) :-
    N > 0,
    N1 is N - 1,
    generarParte(Linea, RestLinea, N1).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% put(+Contenido, +Pos, +PistasFilas, +PistasColumnas, +Grilla, -GrillaRes, -FilaSat, -ColSat)
%

put(Contenido, [F, C], PistasFilas, PistasColumnas, Grilla, GrillaRes, FilaSat, ColSat):-
    
    % Se consigue GrillaRes, que es Grilla pero con el elemento en la posicion (F,C)
    % cambiado por Contenido.
    replace([F,C], Contenido, Grilla, GrillaRes),

    % Se consigue FilaPos (fila numero F de GrillaRes)
    % Se consigue PistasFilaPos (fila que representa las pistas asociadas a FilaPos)
    nth0(F, GrillaRes, FilaPos),
    nth0(F, PistasFilas, PistasFilaPos),
    % Si la FilaPos es correcta (respeta PistasFilaPos), entonces FilaSat es 1, sino es 0
    (filaEsCorrecta(FilaPos, PistasFilaPos) -> FilaSat = 1; FilaSat = 0),

    % Se consigue GrillaTraspuesta para poder acceder a las columnas con facilidad
    transpose(GrillaRes, GrillaTraspuesta),

    % Se consigue ColPos (fila numero C de GrillaTraspuesta)
    % Se consigue PistasColPos (fila que representa las pistas asociadas a ColPos)
    nth0(C, GrillaTraspuesta, ColPos),
    nth0(C, PistasColumnas, PistasColPos),
    % Si la ColPos es correcta (respeta PistasColPos), entonces ColSat es 1, sino es 0 
    (filaEsCorrecta(ColPos, PistasColPos) -> ColSat = 1; ColSat = 0).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% getSolution(+PistasFilas, +PistasColumnas, -Filas)
%
getSolution(PistasFilas, PistasColumnas, Solution):-
	% Se consigue NFilas y NCols (cantidad de pistas de filas y columnas)
	length(PistasFilas, NFilas),
    length(PistasColumnas, NCols),
    % Se crea una lista de listas de variables anoimas, del orden NFilas X NCols.
    % Estas variables son accesibles mediante Filas y Columnas, las dos listas que 
    % contienen las variables anoimas creadas, pero en el orden correspondiente.
    crearMatrizVacia(NFilas, NCols, Filas, Columnas),
    % Se concatenan las listas de PistasFilas y PistasColumnas para tener una unica lista PistasTotales
    append(PistasFilas, PistasColumnas, PistasTotales),
    % Se concatenan las listas de Filas y Columnas para tener una unica lista FilasYColumnas
    append(Filas, Columnas, FilasYColumnas),
    % resolver analiza combinaciones de estados de juego. Cuando de verdadero significa que resolvio
    % el nonograma y entonces devuelvo Filas como la matriz resultante, ya que fueron las variables en 
    % Filas las que cambiaron durante el algoritmo.
    resolver(FilasYColumnas, PistasTotales),
    % Si resolver da verdadero, entonces la solucion es la lista Filas con las combinaciones de esa iteracion
    Solution = Filas.

