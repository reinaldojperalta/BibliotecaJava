package sena.adso.util;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.time.LocalDate;

/**
 * Utilidad centralizada para convertir fechas entre LocalDate (Java)
 */
public class FechaHelper {

    private FechaHelper() {
    }

    public static LocalDate leer(ResultSet rs, String columna) throws SQLException {
        String valor = rs.getString(columna);
        return (valor != null) ? LocalDate.parse(valor) : null;
    }

    public static void escribir(PreparedStatement ps, int indice, LocalDate fecha)
            throws SQLException {
        if (fecha != null)
            ps.setString(indice, fecha.toString());
        else
            ps.setNull(indice, Types.VARCHAR);
    }
}
