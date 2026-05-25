% Hechos
miembro(X, [X|_]).
miembro(X, [_|T]) :- miembro(X, T).

% Reglas
adulto(Edad) :- Edad >= 18.

% Condicionales
clasificar(X, mayor) :- X > 10, !.
clasificar(_, menor).
