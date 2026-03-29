package sena.adso.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import sena.adso.dao.IAutorDAO;
import sena.adso.model.Autor;
import sena.adso.util.ConexionFactory;
import sena.adso.util.FechaHelper;
import sena.adso.util.IConexion;

public class AutorDAO implements IAutorDAO {

    private final IConexion conexion;

    public AutorDAO(String motorDB) {
        this.conexion = ConexionFactory.getConexion("sqlite");
    }

    public AutorDAO(IConexion conexion) {
        this.conexion = conexion;
    }

    // -------------------------------------------------------------------------
    // SQL
    // -------------------------------------------------------------------------
    private static final String SQL_INSERTAR = "INSERT INTO autor (nombres, apellidos, nacionalidad, fecha_nacimiento) "
            +
            "VALUES (?, ?, ?, ?)";

    private static final String SQL_ACTUALIZAR = "UPDATE autor SET nombres = ?, apellidos = ?, nacionalidad = ?, " +
            "fecha_nacimiento = ? WHERE id_autor = ?";

    private static final String SQL_ELIMINAR = "DELETE FROM autor WHERE id_autor = ?";

    private static final String SQL_BUSCAR_POR_ID = "SELECT * FROM autor WHERE id_autor = ?";

    private static final String SQL_LISTAR_TODOS = "SELECT * FROM autor ORDER BY apellidos, nombres";

    private static final String SQL_BUSCAR_POR_APELLIDO = "SELECT * FROM autor WHERE apellidos LIKE ? ORDER BY apellidos, nombres";

    // Cruza libro_autor para obtener los autores de un libro específico
    private static final String SQL_LISTAR_POR_LIBRO = "SELECT a.* FROM autor a " +
            "INNER JOIN libro_autor la ON a.id_autor = la.id_autor " +
            "WHERE la.id_libro = ? " +
            "ORDER BY a.apellidos, a.nombres";

    // -------------------------------------------------------------------------
    // CRUD
    // -------------------------------------------------------------------------

    @Override
    public boolean insertar(Autor autor) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_INSERTAR)) {

            ps.setString(1, autor.getNombres());
            ps.setString(2, autor.getApellidos());
            ps.setString(3, autor.getNacionalidad());
            FechaHelper.escribir(ps, 4, autor.getFechaNacimiento());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[AutorDAO] Error al insertar: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean actualizar(Autor autor) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_ACTUALIZAR)) {

            ps.setString(1, autor.getNombres());
            ps.setString(2, autor.getApellidos());
            ps.setString(3, autor.getNacionalidad());
            FechaHelper.escribir(ps, 4, autor.getFechaNacimiento());
            ps.setInt(5, autor.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[AutorDAO] Error al actualizar: " + e.getMessage());
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
            System.err.println("[AutorDAO] Error al eliminar: " + e.getMessage());
            return false;
        }
    }

    @Override
    public Optional<Autor> buscarPorId(int id) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_BUSCAR_POR_ID)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return Optional.of(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[AutorDAO] Error al buscar por id: " + e.getMessage());
        }
        return Optional.empty();
    }

    @Override
    public List<Autor> listarTodos() {
        List<Autor> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_LISTAR_TODOS);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next())
                lista.add(mapear(rs));

        } catch (SQLException e) {
            System.err.println("[AutorDAO] Error al listar: " + e.getMessage());
        }
        return lista;
    }

    // -------------------------------------------------------------------------
    // Consultas específicas
    // -------------------------------------------------------------------------

    @Override
    public List<Autor> buscarPorApellido(String apellido) {
        List<Autor> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_BUSCAR_POR_APELLIDO)) {

            ps.setString(1, "%" + apellido + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[AutorDAO] Error al buscar por apellido: " + e.getMessage());
        }
        return lista;
    }

    @Override
    public List<Autor> listarPorLibro(int idLibro) {
        List<Autor> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_LISTAR_POR_LIBRO)) {

            ps.setInt(1, idLibro);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[AutorDAO] Error al listar por libro: " + e.getMessage());
        }
        return lista;
    }

    // -------------------------------------------------------------------------
    // Mapper privado — ResultSet → Autor
    // -------------------------------------------------------------------------

    private Autor mapear(ResultSet rs) throws SQLException {
        return new Autor.Builder()
                .id(rs.getInt("id_autor"))
                .nombres(rs.getString("nombres"))
                .apellidos(rs.getString("apellidos"))
                .nacionalidad(rs.getString("nacionalidad"))
                .fechaNacimiento(FechaHelper.leer(rs, "fecha_nacimiento"))
                .build();
    }
}
