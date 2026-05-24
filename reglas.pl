:- consult('datos.pl').

depende_de(Requisito, Objetivo) :-
    prerrequisito(Requisito, Objetivo).

depende_de(Requisito, Objetivo) :-
    prerrequisito(Intermedio, Objetivo),
    depende_de(Requisito, Intermedio).

obtener_ruta(CursoDestino, ListaRuta) :-
    findall(Requisito, depende_de(Requisito, CursoDestino), RutaBruta),
    reverse(RutaBruta, ListaRuta).