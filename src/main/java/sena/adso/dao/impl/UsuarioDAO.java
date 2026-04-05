package sena.adso.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import sena.adso.dao.IUsuarioDAO;
import sena.adso.model.Usuario;
import sena.adso.model.enums.EstadoUsuario;
import sena.adso.model.enums.RolUsuario;
import sena.adso.util.ConexionFactory;
import sena.adso.util.IConexion;

public class UsuarioDAO implements IUsuarioDAO {

    // -------------------------------------------------------------------------
    // Conexión — se inyecta el motor desde fuera, el DAO no sabe cuál es
    // -------------------------------------------------------------------------
    private final IConexion conexion;

    /** Uso normal: new UsuarioDAO("sqlite") | "mysql" | "postgres" */
    public UsuarioDAO(String motorDB) {
        this.conexion = ConexionFactory.getConexion("mysql");
    }

    /** Constructor alternativo que recibe un IConexion directo (útil para tests) */
    public UsuarioDAO(IConexion conexion) {
        this.conexion = conexion;
    }

    private static final String SQL_CONTAR_TOTAL = "SELECT COUNT(*) FROM usuario";
    private static final String SQL_INSERTAR = "INSERT INTO usuario (documento, nombres, apellidos, email, telefono, tipo_usuario, estado, password) "
            +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String SQL_ACTUALIZAR = "UPDATE usuario SET documento = ?, nombres = ?, apellidos = ?, email = ?, "
            +
            "telefono = ?, tipo_usuario = ?, estado = ? WHERE id_usuario = ?";

    private static final String SQL_ELIMINAR = "DELETE FROM usuario WHERE id_usuario = ?";

    private static final String SQL_BUSCAR_POR_ID = "SELECT * FROM usuario WHERE id_usuario = ?";

    private static final String SQL_LISTAR_TODOS = "SELECT * FROM usuario ORDER BY apellidos, nombres";

    private static final String SQL_BUSCAR_POR_DOCUMENTO = "SELECT * FROM usuario WHERE documento = ?";

    @Override
    public boolean insertar(Usuario usuario) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_INSERTAR)) {

            ps.setString(1, usuario.getCedula());
            ps.setString(2, usuario.getNombres());
            ps.setString(3, usuario.getApellidos());
            ps.setString(4, usuario.getEmail());
            ps.setString(5, usuario.getTelefono());
            ps.setString(6, usuario.getRol().toDb());
            ps.setString(7, usuario.getEstado().toDb());
            ps.setString(8, usuario.getCedula());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[UsuarioDAO] Error al insertar: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean actualizar(Usuario usuario) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_ACTUALIZAR)) {

            ps.setString(1, usuario.getCedula());
            ps.setString(2, usuario.getNombres());
            ps.setString(3, usuario.getApellidos());
            ps.setString(4, usuario.getEmail());
            ps.setString(5, usuario.getTelefono());
            ps.setString(6, usuario.getRol().toDb());
            ps.setString(7, usuario.getEstado().toDb());
            ps.setInt(8, usuario.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[UsuarioDAO] Error al actualizar: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean eliminar(int id) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_ELIMINAR)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[UsuarioDAO] Error al eliminar: " + e.getMessage());
            return false;
        }
    }

    @Override
    public Optional<Usuario> buscarPorId(int id) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_BUSCAR_POR_ID)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return Optional.of(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[UsuarioDAO] Error al buscar por id: " + e.getMessage());
        }
        return Optional.empty();
    }

    @Override
    public List<Usuario> listarTodos() {
        List<Usuario> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_LISTAR_TODOS);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next())
                lista.add(mapear(rs));

        } catch (SQLException e) {
            System.err.println("[UsuarioDAO] Error al listar: " + e.getMessage());
        }
        return lista;
    }

    @Override
    public Optional<Usuario> buscarPorDocumento(String documento) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_BUSCAR_POR_DOCUMENTO)) {

            ps.setString(1, documento);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return Optional.of(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[UsuarioDAO] Error al buscar por documento: " + e.getMessage());
        }
        return Optional.empty();
    }

    @Override
    public int contarTotal() {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_CONTAR_TOTAL);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[UsuarioDAO] Error al contar: " + e.getMessage());
        }
        return 0;
    }

    private Usuario mapear(ResultSet rs) throws SQLException {
        return new Usuario.Builder()
                .id(rs.getInt("id_usuario"))
                .documento(rs.getString("documento"))
                .nombres(rs.getString("nombres"))
                .apellidos(rs.getString("apellidos"))
                .email(rs.getString("email"))
                .telefono(rs.getString("telefono"))
                .rol(RolUsuario.fromDb(rs.getString("tipo_usuario")))
                .estado(EstadoUsuario.fromDb(rs.getString("estado")))
                .build();
    }
}