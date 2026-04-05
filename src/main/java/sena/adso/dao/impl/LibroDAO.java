package sena.adso.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import sena.adso.dao.ILibroDAO;
import sena.adso.model.Libro;
import sena.adso.model.enums.EstadoLibro;
import sena.adso.util.ConexionFactory;
import sena.adso.util.IConexion;

public class LibroDAO implements ILibroDAO {

    private final IConexion conexion;

    public LibroDAO(String motorDB) {
        this.conexion = ConexionFactory.getConexion("mysql");
    }

    public LibroDAO(IConexion conexion) {
        this.conexion = conexion;
    }

    // -------------------------------------------------------------------------
    // SQL
    // -------------------------------------------------------------------------

    private static final String SQL_CONTAR_TOTAL = "SELECT COUNT(*) FROM libro";

    private static final String SQL_LISTAR_RECIENTES = "SELECT * FROM libro ORDER BY id_libro DESC LIMIT ?";

    private static final String SQL_INSERTAR = "INSERT INTO libro (titulo, isbn, anio_publicacion, num_paginas, " +
            "                   id_editorial, id_categoria, estado) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?)";

    private static final String SQL_ACTUALIZAR = "UPDATE libro SET titulo = ?, isbn = ?, anio_publicacion = ?, " +
            "num_paginas = ?, id_editorial = ?, id_categoria = ?, estado = ? " +
            "WHERE id_libro = ?";

    private static final String SQL_ELIMINAR = "DELETE FROM libro WHERE id_libro = ?";

    private static final String SQL_BUSCAR_POR_ID = "SELECT * FROM libro WHERE id_libro = ?";

    private static final String SQL_LISTAR_TODOS = "SELECT * FROM libro ORDER BY titulo";

    private static final String SQL_BUSCAR_POR_ISBN = "SELECT * FROM libro WHERE isbn = ?";

    private static final String SQL_BUSCAR_POR_TITULO = "SELECT * FROM libro WHERE titulo LIKE ? ORDER BY titulo";

    private static final String SQL_LISTAR_POR_CATEGORIA = "SELECT * FROM libro WHERE id_categoria = ? ORDER BY titulo";

    private static final String SQL_LISTAR_POR_ESTADO = "SELECT * FROM libro WHERE estado = ? ORDER BY titulo";

    // -------------------------------------------------------------------------
    // CRUD
    // -------------------------------------------------------------------------

    @Override
    public boolean insertar(Libro libro) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_INSERTAR)) {

            ps.setString(1, libro.getTitulo());
            ps.setString(2, libro.getIsbn());
            ps.setInt(3, libro.getAnioPublicacion());
            ps.setInt(4, libro.getNumPaginas());
            ps.setInt(5, libro.getIdEditorial());
            ps.setInt(6, libro.getIdCategoria());
            ps.setString(7, libro.getEstado().toDb());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[LibroDAO] Error al insertar: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean actualizar(Libro libro) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_ACTUALIZAR)) {

            ps.setString(1, libro.getTitulo());
            ps.setString(2, libro.getIsbn());
            ps.setInt(3, libro.getAnioPublicacion());
            ps.setInt(4, libro.getNumPaginas());
            ps.setInt(5, libro.getIdEditorial());
            ps.setInt(6, libro.getIdCategoria());
            ps.setString(7, libro.getEstado().toDb());
            ps.setInt(8, libro.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[LibroDAO] Error al actualizar: " + e.getMessage());
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
            System.err.println("[LibroDAO] Error al eliminar: " + e.getMessage());
            return false;
        }
    }

    @Override
    public Optional<Libro> buscarPorId(int id) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_BUSCAR_POR_ID)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return Optional.of(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[LibroDAO] Error al buscar por id: " + e.getMessage());
        }
        return Optional.empty();
    }

    @Override
    public List<Libro> listarTodos() {
        List<Libro> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_LISTAR_TODOS);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next())
                lista.add(mapear(rs));

        } catch (SQLException e) {
            System.err.println("[LibroDAO] Error al listar: " + e.getMessage());
        }
        return lista;
    }

    // -------------------------------------------------------------------------
    // Consultas específicas
    // -------------------------------------------------------------------------

    @Override
    public Optional<Libro> buscarPorIsbn(String isbn) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_BUSCAR_POR_ISBN)) {

            ps.setString(1, isbn);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return Optional.of(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[LibroDAO] Error al buscar por isbn: " + e.getMessage());
        }
        return Optional.empty();
    }

    @Override
    public List<Libro> buscarPorTitulo(String titulo) {
        List<Libro> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_BUSCAR_POR_TITULO)) {

            ps.setString(1, "%" + titulo + "%"); // búsqueda parcial
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[LibroDAO] Error al buscar por título: " + e.getMessage());
        }
        return lista;
    }

    @Override
    public List<Libro> listarPorCategoria(int idCategoria) {
        List<Libro> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_LISTAR_POR_CATEGORIA)) {

            ps.setInt(1, idCategoria);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[LibroDAO] Error al listar por categoría: " + e.getMessage());
        }
        return lista;
    }

    @Override
    public List<Libro> listarPorEstado(String estado) {
        List<Libro> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_LISTAR_POR_ESTADO)) {

            ps.setString(1, estado);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[LibroDAO] Error al listar por estado: " + e.getMessage());
        }
        return lista;
    }

    @Override
    public int contarTotal() {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_CONTAR_TOTAL);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[LibroDAO] Error al contar: " + e.getMessage());
        }
        return 0;
    }

    @Override
    public List<Libro> listarRecientes(int limite) {
        List<Libro> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_LISTAR_RECIENTES)) {

            ps.setInt(1, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("[LibroDAO] Error al listar recientes: " + e.getMessage());
        }
        return lista;
    }

    // -------------------------------------------------------------------------
    // Mapper privado — ResultSet → Libro
    // -------------------------------------------------------------------------

    private Libro mapear(ResultSet rs) throws SQLException {
        return new Libro.Builder()
                .id(rs.getInt("id_libro"))
                .titulo(rs.getString("titulo"))
                .isbn(rs.getString("isbn"))
                .anioPublicacion(rs.getInt("anio_publicacion"))
                .numPaginas(rs.getInt("num_paginas"))
                .idEditorial(rs.getInt("id_editorial"))
                .idCategoria(rs.getInt("id_categoria"))
                .estado(EstadoLibro.fromDb(rs.getString("estado")))
                .build();
    }
}
