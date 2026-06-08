% ==========================================
% ITERA PROLOG - Logic Server
% ==========================================

:- use_module(library(http/http_server)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/json)).
:- use_module(library(http/http_json)).

% Import business rules (which includes facts.pl)
:- include('rules/business_rules.pl').

% ==========================================
% CONFIGURATION
% ==========================================

:- initialization(main).

main :-
    Port = 9000,
    http_server(http_dispatch, [port(Port)]),
    format('✅ Itera Logic Server running on port ~w~n', [Port]),
    thread_get_message(_).

% ==========================================
% HTTP HANDLERS
% ==========================================

% GET /health
:- http_handler(root(health), handle_health, []).

handle_health(_Request) :-
    reply_json(_{status: ok, service: 'itera-prolog'}).

% POST /roadmap
% Body: { "student_id": "uuid", "approved_nodes": ["ID1", ...], "skills": ["Skill1", ...], "hours": 20, "pace": "fast_track", "market_gaps": [{"node_id": "ID", "urgency": 5}, ...] }
:- http_handler(root(roadmap), handle_roadmap, [methods([post])]).

handle_roadmap(Request) :-
    http_read_json_dict(Request, Dict),
    (
        StudentId = Dict.get(student_id),
        ApprovedNodes = Dict.get(approved_nodes, []),
        Skills = Dict.get(skills, []),
        Hours = Dict.get(hours, 20),
        Pace = Dict.get(pace, 'normal'),
        MarketGaps = Dict.get(market_gaps, []),
        
        % Setup dynamic facts
        setup_context(StudentId, ApprovedNodes, Skills, Hours, Pace, MarketGaps),
        
        generate_custom_roadmap(StudentId, Roadmap),
        
        % RF-12: Advanced Recommendation (Prioritized Nodes)
        prioritized_nodes(StudentId, Recommendations),
        
        % RF-16: Projection
        (project_completion_time(StudentId, EstimatedWeeks) -> Projection = EstimatedWeeks ; Projection = 0),
        
        % Cleanup
        cleanup_context(StudentId),
        
        reply_json(_{
            success: true,
            student_id: StudentId,
            roadmap: Roadmap,
            recommendations: Recommendations,
            projection: _{
                estimated_weeks: Projection,
                pace: Pace,
                hours_per_week: Hours
            }
        })
    ;
        reply_json(_{success: false, error: 'Missing student_id'}, [status(400)])
    ).

% ==========================================
% CONTEXT MANAGEMENT
% ==========================================

setup_context(StudentId, ApprovedNodes, Skills, Hours, Pace, MarketGaps) :-
    cleanup_context(StudentId),
    forall(member(Node, ApprovedNodes), assertz(approved_node(StudentId, Node))),
    forall(member(Skill, Skills), assertz(prior_skill(StudentId, Skill))),
    assertz(available_hours(StudentId, Hours)),
    assertz(chosen_pace(StudentId, Pace)),
    forall(member(Gap, MarketGaps), 
           (GId = Gap.get(node_id), GUrgency = Gap.get(urgency), assertz(market_gap_ai(StudentId, GId, GUrgency)))).

cleanup_context(StudentId) :-
    retractall(approved_node(StudentId, _)),
    retractall(prior_skill(StudentId, _)),
    retractall(available_hours(StudentId, _)),
    retractall(chosen_pace(StudentId, _)),
    retractall(market_gap_ai(StudentId, _, _)).
