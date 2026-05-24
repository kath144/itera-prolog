% Base de conocimientos para la carrera de Ingenieria de Software

curso(curso_intro_programacion, 'Introduccion a Programacion', basico).
curso(curso_programacion_estructurada, 'Programacion Estructurada', basico).
curso(curso_estructuras_datos, 'Estructuras de Datos', intermedio).
curso(curso_bases_datos, 'Bases de Datos', intermedio).
curso(curso_analisis_diseno, 'Analisis y Diseno de Software', intermedio).
curso(curso_ingenieria_software, 'Ingenieria de Software', avanzado).
curso(curso_arquitectura_software, 'Arquitectura de Software', avanzado).
curso(curso_inteligencia_artificial, 'Inteligencia Artificial', avanzado).

prerrequisito(curso_intro_programacion, curso_programacion_estructurada).
prerrequisito(curso_programacion_estructurada, curso_estructuras_datos).
prerrequisito(curso_estructuras_datos, curso_bases_datos).
prerrequisito(curso_programacion_estructurada, curso_analisis_diseno).
prerrequisito(curso_analisis_diseno, curso_ingenieria_software).
prerrequisito(curso_ingenieria_software, curso_arquitectura_software).
prerrequisito(curso_estructuras_datos, curso_inteligencia_artificial).
