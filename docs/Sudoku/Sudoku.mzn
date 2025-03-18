include "alldifferent.mzn";

%Tamaño por subcuadrante 'S', y tamaño de tablero completo 'N'
int: S;
int: N = S * S;

set of int: Values = 1..N;

% Definición de la matriz de decisión
array[Values, Values] of var Values: puzzle;
% Definición de los valores fijos iniciales
array[Values, Values] of 0..N: start;

% RESTRICCIONES

% Inicializa el juego | Asigna los valores fijos
constraint forall(i, j in Values) (
    if start[i, j] > 0 then puzzle[i, j] = start[i, j] endif
);

% Cada fila debe contener valores diferentes
constraint forall(i in Values) (
    alldifferent([puzzle[i, j] | j in Values])
);

% Cada columna debe contener valores diferentes
constraint forall(j in Values) (
    alldifferent([puzzle[i, j] | i in Values])
);

% Cada subcuadrante debe contener valores diferentes
constraint forall(a, b in 1..S) (
    alldifferent([
        puzzle[(a-1) * S + i, (b-1) * S + j] | i, j in 1..S
    ])
);

%solve :: int_search([puzzle[i,j] | i,j in Values], first_fail, indomain_min) satisfy;
%solve :: int_search([puzzle[i,j] | i,j in Values], most_constrained, indomain_min) satisfy;
solve :: int_search([puzzle[i,j] | i,j in Values], input_order, indomain_min) satisfy;


% Formato de salida
output [ 
  show_int(1, puzzle[i, j]) ++ " " ++
    if j mod S == 0 then "     " else "" endif ++
    if j == N /\ i != N then
      if i mod S == 0 then "\n\n" else "\n" endif
    else "" endif
  | i,j in Values ] ++ 
  ["\n\n"];
