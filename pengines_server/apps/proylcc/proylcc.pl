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
% sacar comillas
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

