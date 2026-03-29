package sena.adso.model.enums;

public enum EstadoMulta {
    PENDIENTE,
    PAGADA,
    EXONERADA;

    /** Convierte el TEXT de SQLite al enum correspondiente. */
    public static EstadoMulta fromDb(String valor) {
        return switch (valor.toLowerCase()) {
            case "pendiente" -> PENDIENTE;
            case "pagada" -> PAGADA;
            case "exonerada" -> EXONERADA;
            default -> throw new IllegalArgumentException("EstadoMulta desconocido: " + valor);
        };
    }

    /** Devuelve el string exacto que se guarda en la BD. */
    public String toDb() {
        return this.name().toLowerCase();
    }

}
