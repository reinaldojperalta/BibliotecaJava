package sena.adso.util;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

/**
 * Utilidad centralizada para convertir fechas entre LocalDate (Java)
 */
public class FechaHelper {

    private FechaHelper() {
    }

    public static LocalDate leer(ResultSet rs, String columna) throws SQLException {
        // Intentamos leer como objeto de fecha primero (Funciona en MySQL)
        java.sql.Date fechaSql = rs.getDate(columna);
        if (fechaSql != null) {
            return fechaSql.toLocalDate();
        }

        // Si rs.getDate falla o devuelve null porque es SQLite/Texto
        String valor = rs.getString(columna);
        return (valor != null && !valor.isEmpty()) ? LocalDate.parse(valor) : null;
    }

    public static void escribir(PreparedStatement ps, int indice, LocalDate fecha) throws SQLException {
        if (fecha != null) {
            // java.sql.Date es el puente estándar que entienden casi todos los motores
            ps.setDate(indice, java.sql.Date.valueOf(fecha));
        } else {
            ps.setNull(indice, java.sql.Types.DATE);
        }
    }
}
