% Servidor HTTP basico de SWI-Prolog

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_json)).

:- consult('reglas.pl').

:- http_handler(root(api/test), handle_test, [methods([get])]).
:- http_handler(root(api/roadmap), handle_roadmap, [methods([get])]).

:- initialization(main).

main :-
    Port = 8080,
    http_server(http_dispatch, [port(Port)]),
    format('Servidor activo en http://localhost:~w/~n', [Port]),
    thread_get_message(_).

handle_test(_Request) :-
    reply_json(_{status:"ok", message:"Servicio activo"}).

handle_roadmap(Request) :-
    (
        catch(http_parameters(Request, [curso(CursoId, [atom])]), _, fail)
    ->
        (
            curso(CursoId, NombreCurso, NivelCurso)
        ->
            obtener_ruta(CursoId, RutaIds),
            findall(
                _{id:Id, nombre:Nombre, nivel:Nivel},
                ( member(Id, RutaIds), curso(Id, Nombre, Nivel) ),
                CursosRuta
            ),
            reply_json(_{
                curso_objetivo: _{id:CursoId, nombre:NombreCurso, nivel:NivelCurso},
                ruta: CursosRuta
            })
        ;
            reply_json(_{error:"Curso no encontrado"})
        )
    ;
        reply_json(_{error:"Parametro curso requerido"})
    ).
