% ==========================================
% HECHOS BASE - Itera
% ==========================================
% Definición de hechos/datos iniciales

% Usuarios de ejemplo
usuario(1, 'Juan', 25).
usuario(2, 'María', 30).
usuario(3, 'Carlos', 17).

% Roles
rol(usuario, 'Permisos básicos').
rol(admin, 'Acceso total').
rol(moderador, 'Gestión de contenido').

% Permisos
permiso(usuario, ver_contenido).
permiso(admin, ver_contenido).
permiso(admin, editar_contenido).
permiso(admin, eliminar_contenido).
permiso(moderador, ver_contenido).
permiso(moderador, editar_contenido).

% Estados
estado(activo, 'Servicio activo').
estado(inactivo, 'Servicio inactivo').
estado(mantenimiento, 'En mantenimiento').
