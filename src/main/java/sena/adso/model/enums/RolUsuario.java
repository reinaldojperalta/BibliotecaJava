package sena.adso.model.enums;

public enum RolUsuario {
    ADMINISTRADOR,
    BIBLIOTECARIO,
    ESTUDIANTE;

        /** Convierte el TEXT de SQLite al enum correspondiente. */
    public static RolUsuario fromDb(String valor) {
        return switch (valor.toLowerCase()) {
            case "admin" -> ADMINISTRADOR;
            case "usuario" -> BIBLIOTECARIO;
            case "lector" -> ESTUDIANTE;
            default -> throw new IllegalArgumentException("EstadoLibro desconocido: " + valor);
        };
    }

    /** Devuelve el string exacto que se guarda en la BD. */
    public String toDb() {
        return this.name().toLowerCase();
    }
}
}
