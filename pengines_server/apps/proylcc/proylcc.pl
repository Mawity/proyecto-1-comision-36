:- module(proylcc,
	[  
		put/8,
		gameStatus/2
	]).

:-use_module(library(lists)).
:-use_module(library(clpfd)).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% replace(+Position, +Content, +Grilla, -GrillaRes)
%

replace([0, C], Pintar, [G|Gs], [Res|Gs]):-
	pintarEnFila(G, C, Pintar, Res).

replace([F, C], Pintar, [G|Gs], [G|Rs]):-
	F>0,
	FAux is F - 1,
	replace([FAux, C], Pintar, Gs, Rs).
	

pintarEnFila([F|Fs], 0, Simbolo, [QuedaPintado|Fs]):-
	(F = Simbolo -> QuedaPintado is ''; QuedaPintado is Simbolo).

%pintarEnFila(['X'|Fs], 0, 'X', [''|Fs]).

%pintarEnFila(['#'|Fs], 0, '#', [''|Fs]).

pintarEnFila([F|Fs], Index, Simbolo, [F|Rs]):-
	Index>0,
	IndexAux is Index - 1,
	pintarEnFila(Fs, IndexAux, Simbolo, Rs).






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

parteEsCorrecta(Fila, Fila, 0).

parteEsCorrecta(['#'|Fila], RestFila, N) :-
    N > 0,
    N1 is N - 1,
    parteEsCorrecta(Fila, RestFila, N1).


espacioObligatorio([''|Fila],Fila).

espacioObligatorio(['X'|Fila],Fila).


saltearEspaciosIniciales(Fila, Fila).

saltearEspaciosIniciales([''|Fila],RestFila) :-
    saltearEspaciosIniciales(Fila, RestFila).

saltearEspaciosIniciales(['X'|Fila],RestFila) :-
    saltearEspaciosIniciales(Fila, RestFila).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% put(+Contenido, +Pos, +PistasFilas, +PistasColumnas, +Grilla, -GrillaRes, -FilaSat, -ColSat)
%

put(Contenido, [F, C], PistasFilas, PistasColumnas, Grilla, GrillaRes, FilaSat, ColSat):-

	replace([F,C], Contenido, Grilla, GrillaRes),

	nth0(F, Grilla, FilaPos),
    nth0(F, PistasFilas, PistasFilaPos),
	(filaEsCorrecta(FilaPos, PistasFilaPos) -> FilaSat = 1; FilaSat = 0),

	transpose(Grilla, GrillaTraspuesta),

    nth0(C, GrillaTraspuesta, ColPos),
    nth0(C, PistasColumnas, PistasColPos),
	(filaEsCorrecta(ColPos, PistasColPos) -> ColSat = 1; ColSat = 0).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% gameStatus(+Board, +Status)
%

gameStatus(Board, Winner):-
	Filas = [
    	[0, 1, 2],
		[3, 4, 5],
		[6, 7, 8],
		[0, 3, 6],
		[1, 4, 7],
		[2, 5, 8],
		[0, 4, 8],
		[2, 4, 6]
  	],
  	member([C1, C2, C3], Filas),
	nth0(C1, Board, Winner),
	Winner \= "-",
	nth0(C2, Board, Winner),
	nth0(C3, Board, Winner),
	!.  

gameStatus(Board, "?"):-
	member("-", Board),
	!.



%put(#, [0,0], [[2],[],[],[],[]], [3,1], [['',#,#,'',''],[],[],[],[]], GrillaRes, FilaSat, ColSat).
