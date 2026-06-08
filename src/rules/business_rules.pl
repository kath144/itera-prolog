% ===========================================
% PROLOG MICROSERVICE - INFERENCE ENGINE
% Core Academic Rules & Recommendation Logic
% ===========================================

:- include('facts.pl').

% ===========================================
% CORE ACADEMIC RULES [icon: cpu]
% ===========================================

% can_enroll(Student_Id, Node_Id)
can_enroll(StudentId, NodeId) :-
    node(NodeId, _, _, _),
    \+ approved_node(StudentId, NodeId),
    \+ evaluate_skill_exemption(StudentId, NodeId), % If exempt, no need to enroll
    recursive_check_prerequisites(StudentId, NodeId).

% recursive_check_prerequisites(Student_Id, Node_Id)
recursive_check_prerequisites(StudentId, NodeId) :-
    forall(prerequisite(PrevNode, NodeId), 
           (approved_node(StudentId, PrevNode) ; 
            evaluate_skill_exemption(StudentId, PrevNode) ;
            meets_alternative_requirement(StudentId, PrevNode))).

% RF-15: Dynamic Validation (Skill Exemption)
evaluate_skill_exemption(StudentId, NodeId) :-
    validates_with(Skill, NodeId),
    prior_skill(StudentId, Skill).

% meets_alternative_requirement(Student_Id, Node_Id)
meets_alternative_requirement(StudentId, NodeId) :-
    is_alternative(NodeId, AltNode),
    approved_node(StudentId, AltNode).
meets_alternative_requirement(StudentId, NodeId) :-
    is_alternative(AltNode, NodeId),
    approved_node(StudentId, AltNode).

% ===========================================
% ADVANCED RECOMMENDATION RULES [icon: cpu]
% ===========================================

% RF-12 Prioritization: prioritize_nodes_by_market_gap
prioritized_nodes(StudentId, SortedNodes) :-
    findall(Urgency-NodeId, 
            (can_enroll(StudentId, NodeId), (market_gap_ai(StudentId, NodeId, Urgency) ; Urgency = 0)), 
            Pairs),
    keysort(Pairs, SortedPairs),
    reverse(SortedPairs, FinalPairs),
    pairs_values(FinalPairs, SortedNodes).

% visual_node_state(Student_Id, Node_Id, State)
visual_node_state(StudentId, NodeId, 'completed') :-
    approved_node(StudentId, NodeId), !.
visual_node_state(StudentId, NodeId, 'completed') :-
    evaluate_skill_exemption(StudentId, NodeId), !.
visual_node_state(StudentId, NodeId, 'available') :-
    can_enroll(StudentId, NodeId), !.
visual_node_state(_, _, 'locked').

% RF-16: Time Projection
calculate_total_pending_difficulty(StudentId, TotalDifficulty) :-
    findall(Diff, (node(NodeId, _, _, Diff), \+ approved_node(StudentId, NodeId), \+ evaluate_skill_exemption(StudentId, NodeId)), Difficulties),
    sum_list(Difficulties, TotalDifficulty).

project_completion_time(StudentId, Weeks) :-
    available_hours(StudentId, Hours),
    Hours > 0,
    calculate_total_pending_difficulty(StudentId, TotalDiff),
    (chosen_pace(StudentId, Pace) ; Pace = 'normal'),
    pace_multiplier(Pace, Multiplier),
    Weeks is (TotalDiff * 10 * Multiplier) / Hours.

pace_multiplier('fast_track', 0.7).
pace_multiplier('deep', 1.3).
pace_multiplier(_, 1.0).

% ===========================================
% API ENTRY POINTS
% ===========================================

% generate_custom_roadmap(Student_Id, Roadmap)
generate_custom_roadmap(StudentId, Roadmap) :-
    findall(_{id: NodeId, name: Name, category: Cat, state: State},
            (node(NodeId, Name, Cat, _), visual_node_state(StudentId, NodeId, State)),
            Roadmap).

% Helpers
pairs_values([], []).
pairs_values([_-V|T], [V|VT]) :- pairs_values(T, VT).

sum_list([], 0).
sum_list([H|T], Sum) :- sum_list(T, Rest), Sum is H + Rest.
