package sena.adso.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import sena.adso.dao.IPrestamoDAO;
import sena.adso.model.Prestamo;
import sena.adso.model.enums.EstadoPrestamo;
import sena.adso.util.ConexionFactory;
import sena.adso.util.IConexion;

public class PrestamoDAO implements IPrestamoDAO {

    private final IConexion conexion;

    public PrestamoDAO(String motorDB) {
        this.conexion = ConexionFactory.getConexion("sqlite");
    }

    public PrestamoDAO(IConexion conexion) {
        this.conexion = conexion;
    }

    // -------------------------------------------------------------------------
    // SQL
    // -------------------------------------------------------------------------
    private static final String SQL_INSERTAR = "INSERT INTO prestamo (id_libro, id_usuario, fecha_prestamo, " +
            "                      fecha_devolucion_esperada, fecha_devolucion_real, estado) " +
            "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SQL_ACTUALIZAR = "UPDATE prestamo SET id_libro = ?, id_usuario = ?, fecha_prestamo = ?, "
            +
            "fecha_devolucion_esperada = ?, fecha_devolucion_real = ?, estado = ? " +
            "WHERE id_prestamo = ?";

    private static final String SQL_ELIMINAR = "DELETE FROM prestamo WHERE id_prestamo = ?";

    private static final String SQL_BUSCAR_POR_ID = "SELECT * FROM prestamo WHERE id_prestamo = ?";

    private static final String SQL_LISTAR_TODOS = "SELECT * FROM prestamo ORDER BY fecha_prestamo DESC";

    private static final String SQL_LISTAR_POR_USUARIO = "SELECT * FROM prestamo WHERE id_usuario = ? ORDER BY fecha_prestamo DESC";

    private static final String SQL_LISTAR_POR_ESTADO = "SELECT * FROM prestamo WHERE estado = ? ORDER BY fecha_prestamo DESC";

    private static final String SQL_LISTAR_VENCIDOS = "SELECT * FROM prestamo WHERE estado = 'vencido' ORDER BY fecha_devolucion_esperada";

    private static final String SQL_LISTAR_ACTIVOS_POR_LIBRO = "SELECT * FROM prestamo WHERE id_libro = ? AND estado = 'activo'";

    // -------------------------------------------------------------------------
    // CRUD
    // -------------------------------------------------------------------------

    @Override
    public boolean insertar(Prestamo prestamo) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_INSERTAR)) {

            ps.setInt(1, prestamo.getIdLibro());
            ps.setInt(2, prestamo.getIdUsuario());
            ps.setObject(3, prestamo.getFechaPrestamo());
            ps.setObject(4, prestamo.getFechaDevolucionEsperada());
            ps.setObject(5, prestamo.getFechaDevolucionReal()); // puede ser null
            ps.setString(6, prestamo.getEstado().toDb());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[PrestamoDAO] Error al insertar: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean actualizar(Prestamo prestamo) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_ACTUALIZAR)) {

            ps.setInt(1, prestamo.getIdLibro());
            ps.setInt(2, prestamo.getIdUsuario());
            ps.setObject(3, prestamo.getFechaPrestamo());
            ps.setObject(4, prestamo.getFechaDevolucionEsperada());
            ps.setObject(5, prestamo.getFechaDevolucionReal()); // puede ser null
            ps.setObject(6, prestamo.getEstado().toDb());
            ps.setInt(7, prestamo.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[PrestamoDAO] Error al actualizar: " + e.getMessage());
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
            System.err.println("[PrestamoDAO] Error al eliminar: " + e.getMessage());
            return false;
        }
    }

    @Override
    public Optional<Prestamo> buscarPorId(int id) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_BUSCAR_POR_ID)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return Optional.of(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[PrestamoDAO] Error al buscar por id: " + e.getMessage());
        }
        return Optional.empty();
    }

    @Override
    public List<Prestamo> listarTodos() {
        List<Prestamo> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_LISTAR_TODOS);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next())
                lista.add(mapear(rs));

        } catch (SQLException e) {
            System.err.println("[PrestamoDAO] Error al listar: " + e.getMessage());
        }
        return lista;
    }

    // -------------------------------------------------------------------------
    // Consultas específicas
    // -------------------------------------------------------------------------

    @Override
    public List<Prestamo> listarPorUsuario(int idUsuario) {
        List<Prestamo> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_LISTAR_POR_USUARIO)) {

            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[PrestamoDAO] Error al listar por usuario: " + e.getMessage());
        }
        return lista;
    }

    @Override
    public List<Prestamo> listarPorEstado(String estado) {
        List<Prestamo> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_LISTAR_POR_ESTADO)) {

            ps.setString(1, estado);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[PrestamoDAO] Error al listar por estado: " + e.getMessage());
        }
        return lista;
    }

    @Override
    public List<Prestamo> listarVencidos() {
        List<Prestamo> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_LISTAR_VENCIDOS);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next())
                lista.add(mapear(rs));

        } catch (SQLException e) {
            System.err.println("[PrestamoDAO] Error al listar vencidos: " + e.getMessage());
        }
        return lista;
    }

    @Override
    public List<Prestamo> listarActivosPorLibro(int idLibro) {
        List<Prestamo> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_LISTAR_ACTIVOS_POR_LIBRO)) {

            ps.setInt(1, idLibro);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[PrestamoDAO] Error al listar activos por libro: " + e.getMessage());
        }
        return lista;
    }

    // -------------------------------------------------------------------------
    // Mapper privado — ResultSet → Prestamo
    // -------------------------------------------------------------------------

    private Prestamo mapear(ResultSet rs) throws SQLException {
        return new Prestamo.Builder()
                .id(rs.getInt("id_prestamo"))
                .idLibro(rs.getInt("id_libro"))
                .idUsuario(rs.getInt("id_usuario"))
                .fechaPrestamo(rs.getObject("fecha_prestamo", LocalDate.class))
                .fechaDevolucionEsperada(rs.getObject("fecha_devolucion_esperada", LocalDate.class))
                .fechaDevolucionReal(rs.getObject("fecha_devolucion_real", LocalDate.class)) // puede ser null
                .estado(EstadoPrestamo.fromDb(rs.getString("estado")))
                .build();
    }
}
