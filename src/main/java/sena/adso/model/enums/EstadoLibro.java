package sena.adso.model.enums;

public enum EstadoLibro {
    DISPONIBLE,
    PRESTADO,
    MANTENIMIENTO,
    DADO_DE_BAJA;

    /** Convierte el TEXT de SQLite al enum correspondiente. */
    public static EstadoLibro fromDb(String valor) {
        return switch (valor.toLowerCase()) {
            case "disponible" -> DISPONIBLE;
            case "prestado" -> PRESTADO;
            case "mantenimiento" -> MANTENIMIENTO;
            case "dado_de_baja" -> DADO_DE_BAJA;
            default -> throw new IllegalArgumentException("EstadoLibro desconocido: " + valor);
        };
    }

    /** Devuelve el string exacto que se guarda en la BD. */
    public String toDb() {
        return this.name().toLowerCase();
    }
}
