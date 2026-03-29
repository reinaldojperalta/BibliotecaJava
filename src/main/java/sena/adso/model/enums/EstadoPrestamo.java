package sena.adso.model.enums;

public enum EstadoPrestamo {
    ACTIVO,
    DEVUELTO,
    VENCIDO;

    /** Convierte el TEXT de SQLite al enum correspondiente. */
    public static EstadoPrestamo fromDb(String valor) {
        return switch (valor.toLowerCase()) {
            case "activo" -> ACTIVO;
            case "devuelto" -> DEVUELTO;
            case "vencido" -> VENCIDO;
            default -> throw new IllegalArgumentException("EstadoLibro desconocido: " + valor);
        };
    }

    /** Devuelve el string exacto que se guarda en la BD. */
    public String toDb() {
        return this.name().toLowerCase();
    }
}
