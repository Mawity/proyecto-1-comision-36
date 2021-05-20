:- module(proylcc,
	[  
		put/8
	]).

:-use_module(library(lists)).
:-use_module(library(clpfd)).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% replace(?X, +XIndex, +Y, +Xs, -XsY)
%
% XsY es el resultado de reemplazar la ocurrencia de X en la posición XIndex de Xs por Y.

replace(X, 0, Y, [X|Xs], [Y|Xs]).

replace(X, XIndex, Y, [Xi|Xs], [Xi|XsY]):-
    XIndex > 0,
    XIndexS is XIndex - 1,
    replace(X, XIndexS, Y, Xs, XsY).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% filaEsCorrecta(+Fila, +PistasFilas)
%

filaEsCorrecta([],[]) :- !.

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
% parteEsCorrecta(+Fila, +PistasFilas)
%
%
parteEsCorrecta(Fila, Fila, 0).

parteEsCorrecta(['#'|Fila], RestFila, N) :-
    N > 0,
    N1 is N - 1,
    parteEsCorrecta(Fila, RestFila, N1).


espacioObligatorio(['_'|Fila],Fila).

espacioObligatorio(['X'|Fila],Fila).


saltearEspaciosIniciales(Fila, Fila).

saltearEspaciosIniciales(['_'|Fila],RestFila) :-
    saltearEspaciosIniciales(Fila, RestFila).

saltearEspaciosIniciales(['X'|Fila],RestFila) :-
    saltearEspaciosIniciales(Fila, RestFila).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% put(+Contenido, +Pos, +PistasFilas, +PistasColumnas, +Grilla, -GrillaRes, -FilaSat, -ColSat)
%

put(Contenido, [F, C], PistasFilas, PistasColumnas, Grilla, GrillaRes, FilaSat, ColSat):-

	% GrillaRes es el resultado de reemplazar la fila Row en la posición RowN de Grilla
	% (RowN-ésima fila de Grilla), por una fila nueva NewRow.
	
	replace(Row, F, NewRow, Grilla, GrillaRes),

	% NewRow es el resultado de reemplazar la celda Cell en la posición ColN de Row por _,
	% siempre y cuando Cell coincida con Contenido (Cell se instancia en la llamada al replace/5).
	% En caso contrario (;)
	% NewRow es el resultado de reemplazar lo que se que haya (_Cell) en la posición ColN de Row por Conenido.	 
	
	(replace(Cell, C, _, Row, NewRow), Cell == Contenido; replace(_Cell, C, Contenido, Row, NewRow)),


    nth0(F, PistasFilas, PistasFilaPos),
	(filaEsCorrecta(NewRow, PistasFilaPos) -> FilaSat = 1; FilaSat = 0),

	transpose(GrillaRes, GrillaTraspuesta),

    nth0(C, GrillaTraspuesta, ColPos),
    nth0(C, PistasColumnas, PistasColPos),
	(filaEsCorrecta(ColPos, PistasColPos) -> ColSat = 1; ColSat = 0).


%put(#, [0,0], [[2],[],[],[],[]], [3,1], [['',#,#,'',''],[],[],[],[]], GrillaRes, FilaSat, ColSat).
