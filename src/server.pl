% ==========================================
% ITERA PROLOG - Servidor HTTP
% ==========================================

:- use_module(library(http/http_server)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_error)).
:- use_module(library(apply)).

:- absolute_file_name('src/rules/business_rules.pl', RulesFile),
    consult(RulesFile).

:- initialization(main).

:- http_handler(root(health), handle_health, [method(get)]).
:- http_handler(root(query), handle_query, [method(post)]).
:- http_handler(root(.), handle_not_found, [prefix]).

main :-
    prolog_port(Port),
    format('~nIniciando servidor Itera Prolog en el puerto ~w...~n', [Port]),
    http_server(http_dispatch, [port(Port)]),
    format('Servidor escuchando en http://localhost:~w~n', [Port]),
    thread_get_message(_).

prolog_port(Port) :-
    (   getenv('PROLOG_PORT', PortText),
        PortText \= ''
    ->
        number_string(Port, PortText)
    ;
        Port = 9000
    ).

handle_health(_Request) :-
    reply_json_dict(_{
        status: "ok",
        service: "itera-prolog",
        version: "1.0.0"
    }).

handle_query(Request) :-
    catch(
        (   http_read_json_dict(Request, Body),
            (   get_dict(query, Body, QueryText)
            ->
                timeout_value(Body, Timeout),
                query_solutions(QueryText, Timeout, Solutions),
                (   Solutions \= []
                ->
                    reply_json_dict(_{success: true, solutions: Solutions})
                ;
                    reply_json_dict(_{success: false, solutions: []})
                )
            ;
                throw(http_reply(bad_request('Missing "query" parameter')))
            )
        ),
        Error,
        handle_http_error(Error)
    ).

timeout_value(Body, Timeout) :-
    (   get_dict(timeout, Body, TimeoutText)
    ->
        (   number(TimeoutText)
        ->
            Timeout = TimeoutText
        ;   atom(TimeoutText)
        ->
            atom_number(TimeoutText, Timeout)
        ;   string(TimeoutText)
        ->
            number_string(Timeout, TimeoutText)
        ;
            Timeout = 30000
        )
    ;
        Timeout = 30000
    ).

query_solutions(QueryText, _Timeout, Solutions) :-
    catch(
        query_solutions_(QueryText, Solutions),
        _,
        Solutions = []
    ).

query_solutions_(QueryText, Solutions) :-
    normalize_query(QueryText, QueryAtom),
    read_term_from_atom(QueryAtom, Goal, [variable_names(VariableNames)]),
    findall(
        SolutionDict,
        (
            call(user:Goal),
            solution_dict(VariableNames, SolutionDict)
        ),
        Solutions
    ).

normalize_query(QueryText, QueryAtom) :-
    (   atom(QueryText)
    ->
        QueryAtom = QueryText
    ;   string(QueryText)
    ->
        atom_string(QueryAtom, QueryText)
    ).

solution_dict(VariableNames, SolutionDict) :-
    maplist(variable_binding_pair, VariableNames, Pairs),
    dict_create(SolutionDict, _, Pairs).

variable_binding_pair(Name=Value, Name-JsonValue) :-
    term_string(Value, JsonValue).

handle_not_found(_Request) :-
    throw(http_reply(not_found('Endpoint no encontrado. Usa /health o /query'))).

handle_http_error(http_reply(bad_request(Message))) :-
    reply_json_dict(_{success: false, error: Message}, [status(400)]).

handle_http_error(http_reply(not_found(Message))) :-
    reply_json_dict(_{success: false, error: Message}, [status(404)]).

handle_http_error(Error) :-
    print_message(error, Error),
    reply_json_dict(_{success: false, error: "Internal server error"}, [status(500)]).
