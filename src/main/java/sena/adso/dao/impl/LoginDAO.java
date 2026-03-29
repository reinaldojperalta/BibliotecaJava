package sena.adso.dao.impl;

import sena.adso.dao.ILoginDAO;
import sena.adso.model.Usuario;
import sena.adso.model.enums.EstadoUsuario;
import sena.adso.model.enums.RolUsuario;
import sena.adso.util.ConexionFactory;
import sena.adso.util.IConexion;

import java.sql.*;
import java.util.Optional;

public class LoginDAO implements ILoginDAO {

    // -------------------------------------------------------------------------
    // Conexión
    // -------------------------------------------------------------------------
    private final IConexion conexion;

    public LoginDAO(String motorDB) {
        this.conexion = ConexionFactory.getConexion(motorDB);
    }

    public LoginDAO(IConexion conexion) {
        this.conexion = conexion;
    }

    // -------------------------------------------------------------------------
    // SQL
    // -------------------------------------------------------------------------

    /*
     * Filtra por email, password (hasheado) y estado 'activo' en una sola
     * consulta. Si el usuario existe pero está inactivo o suspendido,
     * la query no devuelve filas — no hay que verificarlo en Java.
     */
    private static final String SQL_VALIDAR_LOGIN =
            "SELECT id_usuario, documento, nombres, apellidos, email, " +
            "       telefono, tipo_usuario, estado " +
            "FROM   usuario " +
            "WHERE  email    = ? " +
            "  AND  password = ? " +
            "  AND  estado   = 'activo'";

    // -------------------------------------------------------------------------
    // Implementación
    // -------------------------------------------------------------------------

    @Override
    public Optional<Usuario> validarLogin(String email, String password) {
        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_VALIDAR_LOGIN)) {

            ps.setString(1, email);
            ps.setString(2, password);   // debe llegar hasheado desde el servlet

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[LoginDAO] Error al validar login: " + e.getMessage());
        }
        return Optional.empty();
    }

    // -------------------------------------------------------------------------
    // Mapper privado — ResultSet → Usuario
    // -------------------------------------------------------------------------

    private Usuario mapear(ResultSet rs) throws SQLException {
        return new Usuario.Builder()
                .id       (rs.getInt   ("id_usuario"))
                .documento(rs.getString("documento"))
                .nombres  (rs.getString("nombres"))
                .apellidos(rs.getString("apellidos"))
                .email    (rs.getString("email"))
                .telefono (rs.getString("telefono"))
                .rol      (RolUsuario   .fromDb(rs.getString("tipo_usuario")))
                .estado   (EstadoUsuario.fromDb(rs.getString("estado")))
                .build();
    }
}
