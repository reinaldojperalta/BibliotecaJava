package sena.adso.model.enums;

public enum EstadoUsuario {
    ACTIVO,
    INACTIVO,
    SUSPENDIDO;

    /** Convierte el TEXT de SQLite al enum correspondiente. */
    public static EstadoUsuario fromDb(String valor) {
        return switch (valor.toLowerCase()) {
            case "activo" -> ACTIVO;
            case "inactivo" -> INACTIVO;
            case "suspendido" -> SUSPENDIDO;
            default -> throw new IllegalArgumentException("EstadoLibro desconocido: " + valor);
        };
    }

    /** Devuelve el string exacto que se guarda en la BD. */
    public String toDb() {
        return this.name().toLowerCase();
    }

}
