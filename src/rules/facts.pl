% ===========================================
% PROLOG MICROSERVICE - INFERENCE ENGINE
% Consolidated Knowledge Base - Facts
% ===========================================

% ===========================================
% STATIC MESH FACTS [icon: book]
% ===========================================

% node(Id, Name, Category, Difficulty)
node('CS101', 'Introducción a la Programación', 'CS', 1).
node('CS102', 'Estructuras de Datos', 'CS', 2).
node('CS201', 'Algoritmos Avanzados', 'CS', 3).
node('CS202', 'Bases de Datos I', 'DB', 2).
node('CS301', 'Ingeniería de Software', 'SE', 3).
node('AI101', 'Inteligencia Artificial Básica', 'AI', 3).
node('WEB101', 'Desarrollo Web Base', 'WEB', 1).
node('WEB102', 'Angular & TypeScript', 'WEB', 2).

% prerequisite(Previous_Node, Next_Node)
prerequisite('CS101', 'CS102').
prerequisite('CS102', 'CS201').
prerequisite('CS102', 'CS301').
prerequisite('CS202', 'CS301').
prerequisite('CS102', 'AI101').
prerequisite('WEB101', 'WEB102').

% is_alternative(Node_A, Node_B)
% Meaning: You can take either A or B to satisfy a requirement
is_alternative('CS202', 'DB_ALT_101').

% is_elective(Node_Id)
is_elective('AI101').

% validates_with(Skill_Text, Node_Id)
validates_with('Programming basics', 'CS101').
validates_with('SQL basics', 'CS202').
validates_with('Frontend basics', 'WEB101').

% ===========================================
% DYNAMIC CONTEXT FACTS [icon: user]
% ===========================================

:- dynamic(approved_node/2).      % approved_node(Student_Id, Node_Id)
:- dynamic(prior_skill/2).        % prior_skill(Student_Id, Skill_Text)
:- dynamic(market_gap_ai/3).     % market_gap_ai(Student_Id, Node_Id, Urgency)
:- dynamic(available_hours/2).    % available_hours(Student_Id, Hours)
:- dynamic(chosen_pace/2).       % chosen_pace(Student_Id, fast_track | deep)
