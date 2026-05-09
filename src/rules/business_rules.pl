% ==========================================
% REGLAS DE NEGOCIO - Itera
% ==========================================
% Aquí van las reglas lógicas del dominio

% ==========================================
% HECHOS BASE
% ==========================================

% Hechos de ejemplo
miembro(X, [X|_]).
miembro(X, [_|T]) :- miembro(X, T).

% ==========================================
% PREDICADOS BÁSICOS
% ==========================================

% Adulto
adulto(Edad) :- Edad >= 18.

% Mayor de edad
mayor_edad(Edad) :- Edad >= 21.

% Menor de edad
menor_edad(Edad) :- Edad < 18.

% ==========================================
% REGLAS DE NEGOCIO
% ==========================================

% Clasificar por edad
clasificar_edad(Edad, 'Menor') :- Edad < 18, !.
clasificar_edad(Edad, 'Adulto') :- Edad < 65, !.
clasificar_edad(_, 'Senior').

% Validar número
es_valido(N) :- number(N), N > 0.

% ==========================================
% LÓGICA CONDICIONAL
% ==========================================

% Mayor que
mayor(X, Y) :- X > Y.

% Menor que
menor(X, Y) :- X < Y.

% Entre rango
en_rango(X, Min, Max) :- X >= Min, X =< Max.

% ==========================================
% OPERACIONES
% ==========================================

% Suma
suma(A, B, R) :- R is A + B.

% Multiplicación
multiplicar(A, B, R) :- R is A * B.

% ==========================================
% PLANTILLAS PARA AGREGAR REGLAS
% ==========================================

% TODO: Agregar reglas específicas del dominio
%
% Ejemplo:
% regla_ejemplo(Input, Output) :- 
%     condicion1(Input),
%     condicion2(Input),
%     Output = resultado.
