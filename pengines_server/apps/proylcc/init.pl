:- module(proylcc,
	[  
		init/3,
	]).

:-use_module(library(lists)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% init(PistasFilas, PistasColumnas, Grilla)
%

init(
[[5], [2,2], [3], [1], [5]],
[[2,1], [3,1], [1,3], [3,1], [2,1]],
[[ _ , _ , _ , _ ,"#"],
 [ _ , _ , _ , _ , _ ],
 ["X", _ , _ , _ , _ ],
 ["X", _ ,"#", _ , _ ],
 [ _ , _ ,"#","#","#"]
]
).