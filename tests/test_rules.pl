% ==========================================
% TESTS - Pruebas de Reglas
% ==========================================

:- include('../src/rules/business_rules.pl').

% Ejecutar tests
:- initialization(run_tests).

run_tests :-
    format('~n🧪 Ejecutando tests...~n~n', []),
    
    test_miembro,
    test_adulto,
    test_clasificar_edad,
    test_en_rango,
    test_operaciones,
    
    format('~n✅ Tests completados~n~n', []).

% ==========================================
% TEST: Miembro
% ==========================================

test_miembro :-
    format('📝 Test: miembro/2~n', []),
    
    (miembro(2, [1,2,3]) -> 
        format('  ✅ miembro(2, [1,2,3]) - OK~n', []) 
    ; 
        format('  ❌ miembro(2, [1,2,3]) - FAIL~n', [])
    ),
    
    (miembro(4, [1,2,3]) -> 
        format('  ❌ miembro(4, [1,2,3]) - FAIL~n', [])
    ; 
        format('  ✅ miembro(4, [1,2,3]) - OK (no encontrado)~n', [])
    ).

% ==========================================
% TEST: Adulto
% ==========================================

test_adulto :-
    format('📝 Test: adulto/1~n', []),
    
    (adulto(25) -> 
        format('  ✅ adulto(25) - OK~n', []) 
    ; 
        format('  ❌ adulto(25) - FAIL~n', [])
    ),
    
    (adulto(15) -> 
        format('  ❌ adulto(15) - FAIL~n', [])
    ; 
        format('  ✅ adulto(15) - OK (no es adulto)~n', [])
    ).

% ==========================================
% TEST: Clasificar edad
% ==========================================

test_clasificar_edad :-
    format('📝 Test: clasificar_edad/2~n', []),
    
    (clasificar_edad(15, 'Menor') -> 
        format('  ✅ clasificar_edad(15, Menor) - OK~n', []) 
    ; 
        format('  ❌ clasificar_edad(15, Menor) - FAIL~n', [])
    ),
    
    (clasificar_edad(35, 'Adulto') -> 
        format('  ✅ clasificar_edad(35, Adulto) - OK~n', []) 
    ; 
        format('  ❌ clasificar_edad(35, Adulto) - FAIL~n', [])
    ).

% ==========================================
% TEST: En rango
% ==========================================

test_en_rango :-
    format('📝 Test: en_rango/3~n', []),
    
    (en_rango(50, 0, 100) -> 
        format('  ✅ en_rango(50, 0, 100) - OK~n', []) 
    ; 
        format('  ❌ en_rango(50, 0, 100) - FAIL~n', [])
    ),
    
    (en_rango(150, 0, 100) -> 
        format('  ❌ en_rango(150, 0, 100) - FAIL~n', [])
    ; 
        format('  ✅ en_rango(150, 0, 100) - OK (fuera de rango)~n', [])
    ).

% ==========================================
% TEST: Operaciones
% ==========================================

test_operaciones :-
    format('📝 Test: operaciones~n', []),
    
    (suma(5, 3, 8) -> 
        format('  ✅ suma(5, 3, 8) - OK~n', []) 
    ; 
        format('  ❌ suma(5, 3, 8) - FAIL~n', [])
    ),
    
    (multiplicar(4, 5, 20) -> 
        format('  ✅ multiplicar(4, 5, 20) - OK~n', []) 
    ; 
        format('  ❌ multiplicar(4, 5, 20) - FAIL~n', [])
    ).
