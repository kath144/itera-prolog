% ==========================================
% ITERA PROLOG - Servidor HTTP
% ==========================================
% Servidor HTTP para consultas Prolog
% Puerto: 9000

:- use_module(library(http/http_server)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/json)).
:- use_module(library(http/http_json)).

% Importar reglas de negocio
:- include('rules/business_rules.pl').

% ==========================================
% CONFIGURACIÓN
% ==========================================

:- initialization(main).

main :-
    format('~n🧠 Iniciando servidor Itera Prolog...~n', []),
    Port = 9000,
    http_server(http_dispatch, [port(Port)]),
    format('✅ Servidor escuchando en http://localhost:~w~n~n', [Port]),
    thread_get_message(_).

% ==========================================
% RUTAS HTTP
% ==========================================

% GET /health - Health check
:- http_handler(root(health), handle_health, []).

handle_health(Request) :-
    http_read_json_dict(Request, _),
    reply_json(_{
        status: ok,
        service: 'itera-prolog',
        version: '1.0.0',
        timestamp: _
    }).

% POST /query - Consultar Prolog
:- http_handler(root(query), handle_query, [methods([post])]).

handle_query(Request) :-
    http_read_json_dict(Request, Dict),
    (
        _ = Dict.get(query)
    ->
        Query = Dict.get(query),
        Timeout = Dict.get(timeout, 30000),
        execute_query(Query, Timeout, Solutions),
        reply_json(_{
            success: true,
            solutions: Solutions,
            count: (length(Solutions, N) -> N ; 0)
        })
    ;
        http_status_reply(bad_request, _, _, 
            'Missing "query" parameter')
    ).

% ==========================================
% LÓGICA DE CONSULTA
% ==========================================

% Ejecutar una consulta Prolog
execute_query(QueryStr, Timeout, Solutions) :-
    atom_string(Query, QueryStr),
    !,
    (
        call_with_depth_limit(
            findall(
                _{},
                call(Query),
                Solutions
            ),
            1000
        )
    ->
        true
    ;
        Solutions = []
    ).

execute_query(_, _, []).

% ==========================================
% UTILIDADES
% ==========================================

% Convertir resultado a JSON
result_to_json(Result, JSON) :-
    JSON = Result.

% ==========================================
% MANEJO DE ERRORES
% ==========================================

http_status_reply(Status, Request, Reply, Message) :-
    format('Error: ~w~n', [Message]),
    http_status_reply(Status, Request, Reply).

:- http_handler(/, serve_root, [prefix]).

serve_root(Request) :-
    http_status_reply(not_found, Request, _, 
        'Endpoint no encontrado. Usa /health o /query').

% ==========================================
% LOG
% ==========================================

:- dynamic(log_level/1).
log_level(info).

log(Level, Format, Args) :-
    (
        log_level(CurrentLevel),
        compare_levels(Level, CurrentLevel)
    ->
        format(Format, Args)
    ;
        true
    ).

compare_levels(info, _) :- !.
compare_levels(warn, error) :- !, fail.
compare_levels(warn, _) :- !.
compare_levels(error, _) :- !.
