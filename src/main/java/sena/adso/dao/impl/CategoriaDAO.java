package sena.adso.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import sena.adso.dao.ICategoriaDAO;
import sena.adso.model.Categoria;
import sena.adso.util.ConexionFactory;
import sena.adso.util.IConexion;

public class CategoriaDAO implements ICategoriaDAO {

    private final IConexion conexion;

    public CategoriaDAO(String motorDB) {
        this.conexion = ConexionFactory.getConexion("mysql");
    }

    public CategoriaDAO(IConexion conexion) {
        this.conexion = conexion;
    }

    // -------------------------------------------------------------------------
    // SQL
    // -------------------------------------------------------------------------
    private static final String SQL_INSERTAR = "INSERT INTO categoria (nombre, descripcion) VALUES (?, ?)";

    private static final String SQL_ACTUALIZAR = "UPDATE categoria SET nombre = ?, descripcion = ? WHERE id_categoria = ?";

    private static final String SQL_ELIMINAR = "DELETE FROM categoria WHERE id_categoria = ?";

    private static final String SQL_BUSCAR_POR_ID = "SELECT * FROM categoria WHERE id_categoria = ?";

    private static final String SQL_LISTAR_TODOS = "SELECT * FROM categoria ORDER BY nombre";

    // -------------------------------------------------------------------------
    // CRUD
    // -------------------------------------------------------------------------

    @Override
    public boolean insertar(Categoria categoria) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_INSERTAR)) {

            ps.setString(1, categoria.getNombre());
            ps.setString(2, categoria.getDescripcion());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[CategoriaDAO] Error al insertar: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean actualizar(Categoria categoria) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_ACTUALIZAR)) {

            ps.setString(1, categoria.getNombre());
            ps.setString(2, categoria.getDescripcion());
            ps.setInt(3, categoria.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[CategoriaDAO] Error al actualizar: " + e.getMessage());
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
            System.err.println("[CategoriaDAO] Error al eliminar: " + e.getMessage());
            return false;
        }
    }

    @Override
    public Optional<Categoria> buscarPorId(int id) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_BUSCAR_POR_ID)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return Optional.of(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[CategoriaDAO] Error al buscar por id: " + e.getMessage());
        }
        return Optional.empty();
    }

    @Override
    public List<Categoria> listarTodos() {
        List<Categoria> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_LISTAR_TODOS);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next())
                lista.add(mapear(rs));

        } catch (SQLException e) {
            System.err.println("[CategoriaDAO] Error al listar: " + e.getMessage());
        }
        return lista;
    }

    // -------------------------------------------------------------------------
    // Mapper privado — ResultSet → Categoria
    // -------------------------------------------------------------------------

    private Categoria mapear(ResultSet rs) throws SQLException {
        return new Categoria.Builder()
                .id(rs.getInt("id_categoria"))
                .nombre(rs.getString("nombre"))
                .descripcion(rs.getString("descripcion"))
                .build();
    }
}
