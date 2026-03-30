package sena.adso.dao.impl;

import sena.adso.dao.IEditorialDAO;
import sena.adso.model.Editorial;
import sena.adso.util.ConexionFactory;
import sena.adso.util.IConexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class EditorialDAO implements IEditorialDAO {

    private final IConexion conexion;

    public EditorialDAO(String motorDB) {
        this.conexion = ConexionFactory.getConexion(motorDB);
    }

    public EditorialDAO(IConexion conexion) {
        this.conexion = conexion;
    }

    // -------------------------------------------------------------------------
    // SQL
    // -------------------------------------------------------------------------
    private static final String SQL_INSERTAR =
            "INSERT INTO editorial (nombre, pais, sitio_web) VALUES (?, ?, ?)";

    private static final String SQL_ACTUALIZAR =
            "UPDATE editorial SET nombre = ?, pais = ?, sitio_web = ? " +
            "WHERE id_editorial = ?";

    private static final String SQL_ELIMINAR =
            "DELETE FROM editorial WHERE id_editorial = ?";

    private static final String SQL_BUSCAR_POR_ID =
            "SELECT * FROM editorial WHERE id_editorial = ?";

    private static final String SQL_LISTAR_TODOS =
            "SELECT * FROM editorial ORDER BY nombre";

    // -------------------------------------------------------------------------
    // CRUD
    // -------------------------------------------------------------------------

    @Override
    public boolean insertar(Editorial editorial) {
        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_INSERTAR)) {

            ps.setString(1, editorial.getNombre());
            ps.setString(2, editorial.getPais());
            ps.setString(3, editorial.getSitioWeb());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[EditorialDAO] Error al insertar: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean actualizar(Editorial editorial) {
        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_ACTUALIZAR)) {

            ps.setString(1, editorial.getNombre());
            ps.setString(2, editorial.getPais());
            ps.setString(3, editorial.getSitioWeb());
            ps.setInt   (4, editorial.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[EditorialDAO] Error al actualizar: " + e.getMessage());
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
            System.err.println("[EditorialDAO] Error al eliminar: " + e.getMessage());
            return false;
        }
    }

    @Override
    public Optional<Editorial> buscarPorId(int id) {
        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_BUSCAR_POR_ID)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[EditorialDAO] Error al buscar por id: " + e.getMessage());
        }
        return Optional.empty();
    }

    @Override
    public List<Editorial> listarTodos() {
        List<Editorial> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_LISTAR_TODOS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) lista.add(mapear(rs));

        } catch (SQLException e) {
            System.err.println("[EditorialDAO] Error al listar: " + e.getMessage());
        }
        return lista;
    }

    // -------------------------------------------------------------------------
    // Mapper privado — ResultSet → Editorial
    // -------------------------------------------------------------------------

    private Editorial mapear(ResultSet rs) throws SQLException {
        return new Editorial.Builder()
                .id      (rs.getInt   ("id_editorial"))
                .nombre  (rs.getString("nombre"))
                .pais    (rs.getString("pais"))
                .sitioWeb(rs.getString("sitio_web"))
                .build();
    }
}
