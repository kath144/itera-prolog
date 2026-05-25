:- use_module(library(plunit)).
:- include('../src/rules/business_rules.pl').

:- begin_tests(reglas_negocio).

test(miembro_exito, [nondet]) :-
    miembro(2, [1,2,3]).

test(miembro_fallo, [fail]) :-
    miembro(4, [1,2,3]).

test(adulto_exito) :-
    adulto(25).

test(adulto_fallo, [fail]) :-
    adulto(15).

test(clasificar_mayor) :-
    clasificar(15, mayor).

test(clasificar_menor) :-
    clasificar(5, menor).

:- end_tests(reglas_negocio).

:- initialization(run_tests).
