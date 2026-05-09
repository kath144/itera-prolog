% ==========================================
% FUNCIONES AUXILIARES
% ==========================================

% Imprimir con formato
print_result(Key, Value) :-
    format('~w: ~w~n', [Key, Value]).

% Validar que no sea vacío
not_empty(X) :- X \= [].

% Obtener primer elemento
first([H|_], H).

% Obtener último elemento
last([X], X) :- !.
last([_|T], X) :- last(T, X).

% Longitud de lista
list_length([], 0).
list_length([_|T], N) :- list_length(T, N1), N is N1 + 1.

% Invertir lista
reverse_list([], []).
reverse_list([H|T], R) :- 
    reverse_list(T, RT),
    append(RT, [H], R).

% Elemento en posición
element_at([H|_], 0, H) :- !.
element_at([_|T], N, E) :- 
    N > 0,
    N1 is N - 1,
    element_at(T, N1, E).

% Filtrar lista
filter([], _, []).
filter([H|T], Pred, [H|R]) :-
    call(Pred, H), !,
    filter(T, Pred, R).
filter([_|T], Pred, R) :-
    filter(T, Pred, R).

% Mapear lista
map([], _, []).
map([H|T], Pred, [R|RT]) :-
    call(Pred, H, R),
    map(T, Pred, RT).

% Sumar lista
sum_list([], 0).
sum_list([H|T], Sum) :-
    sum_list(T, S),
    Sum is H + S.

% Máximo de lista
max_list([X], X) :- !.
max_list([H|T], Max) :-
    max_list(T, MaxT),
    (H > MaxT -> Max = H ; Max = MaxT).

% Mínimo de lista
min_list([X], X) :- !.
min_list([H|T], Min) :-
    min_list(T, MinT),
    (H < MinT -> Min = H ; Min = MinT).
