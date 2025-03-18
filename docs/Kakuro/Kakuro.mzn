include "alldifferent.mzn";

% Parámetros del problema
int: N;

% Suma objetivo de cada fila
array[1..N] of int: suma_fila;    

% Suma objetivo de cada columna
array[1..N] of int: suma_columna;

% Matriz que indica celdas jugables
array[1..N, 1..N] of bool: white;

% Conjunto de valores posibles para las celdas jugables
set of int: Values = 1..9;

% Matriz de decisión: representa las celdas del tablero.
array[1..N, 1..N] of var Values: puzzle;

% Matriz de valores iniciales
array[1..N, 1..N] of 0..9: start;

% ----------------------------------------------------------------

% Restricción de celdas fijas: Si en start hay un valor
constraint forall(i, j in 1..N) (
    if start[i, j] > 0 then puzzle[i, j] = start[i, j] else true endif
);

% Restricción de suma para filas.
constraint forall(i in 1..N) (
    sum([puzzle[i, j] | j in 1..N where white[i, j] /\ start[i, j] == 0]) = suma_fila[i]
);

% Restricción de suma para columnas
constraint forall(j in 1..N) (
    sum([puzzle[i, j] | i in 1..N where white[i, j] /\ start[i, j] == 0]) = suma_columna[j]
);

% Restricción de unicidad para las celdas libres de cada fila.
constraint forall(i in 1..N) (
    alldifferent([puzzle[i, j] | j in 1..N where white[i, j] /\ start[i, j] == 0])
);

% Restricción de unicidad para las celdas libres de cada columna.
constraint forall(j in 1..N) (
    alldifferent([puzzle[i, j] | i in 1..N where white[i, j] /\ start[i, j] == 0])
);

% ----------------------------------------------------------------

% Selección del orden de asignación


% La variable de búsqueda es la lista de celdas libres
array[1..N, 1..N] of var Values: X = puzzle;

% Lista de variables sobre las que se realizará la búsqueda:
var int: dummy; 
array[int] of var Values: vars = [ puzzle[i,j] | i,j in 1..N where white[i,j] /\ start[i,j] == 0 ];


%-------------------------------------- Lista de estrategias :D

% Estrategia 1: first_fail
%solve :: int_search(vars, first_fail, indomain_min) satisfy;

% Estrategia 2: most_constrained
% solve :: int_search(vars, most_constrained, indomain_min) satisfy;

% Estrategia 3: input_order
%solve :: int_search(vars, input_order, indomain_min) satisfy;


% ----------------------------------------------------------------

% En la salida el valor "x" representa las celdas que no son jugables, mas especificamente las casillas negras
output [
    if white[i, j] then show(puzzle[i, j]) else "X" endif ++
    if j = N then "\n" else " " endif
    | i, j in 1..N
];
