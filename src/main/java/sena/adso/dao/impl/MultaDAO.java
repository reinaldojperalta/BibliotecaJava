package sena.adso.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import sena.adso.dao.IMultaDAO;
import sena.adso.model.Multa;
import sena.adso.model.enums.EstadoMulta;
import sena.adso.util.ConexionFactory;
import sena.adso.util.FechaHelper;
import sena.adso.util.IConexion;

public class MultaDAO implements IMultaDAO {

    private final IConexion conexion;

    public MultaDAO(String motorDB) {
        this.conexion = ConexionFactory.getConexion("sqlite");
    }

    public MultaDAO(IConexion conexion) {
        this.conexion = conexion;
    }

    // -------------------------------------------------------------------------
    // SQL
    // -------------------------------------------------------------------------
    private static final String SQL_INSERTAR = "INSERT INTO multa (id_prestamo, monto, fecha_generacion, fecha_pago, estado) "
            +
            "VALUES (?, ?, ?, ?, ?)";

    private static final String SQL_ACTUALIZAR = "UPDATE multa SET id_prestamo = ?, monto = ?, fecha_generacion = ?, " +
            "fecha_pago = ?, estado = ? WHERE id_multa = ?";

    private static final String SQL_ELIMINAR = "DELETE FROM multa WHERE id_multa = ?";

    private static final String SQL_BUSCAR_POR_ID = "SELECT * FROM multa WHERE id_multa = ?";

    private static final String SQL_LISTAR_TODOS = "SELECT * FROM multa ORDER BY fecha_generacion DESC";

    private static final String SQL_BUSCAR_POR_PRESTAMO = "SELECT * FROM multa WHERE id_prestamo = ?";

    private static final String SQL_LISTAR_POR_ESTADO = "SELECT * FROM multa WHERE estado = ? ORDER BY fecha_generacion DESC";

    // Cruza prestamo para llegar hasta el usuario
    private static final String SQL_LISTAR_PENDIENTES_POR_USUARIO = "SELECT m.* FROM multa m " +
            "INNER JOIN prestamo p ON m.id_prestamo = p.id_prestamo " +
            "WHERE p.id_usuario = ? AND m.estado = 'pendiente' " +
            "ORDER BY m.fecha_generacion DESC";

    // -------------------------------------------------------------------------
    // CRUD
    // -------------------------------------------------------------------------

    @Override
    public boolean insertar(Multa multa) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_INSERTAR)) {

            ps.setInt(1, multa.getIdPrestamo());
            ps.setDouble(2, multa.getMonto());
            FechaHelper.escribir(ps, 3, multa.getFechaGeneracion());
            FechaHelper.escribir(ps, 4, multa.getFechaPago()); // puede ser null
            ps.setString(5, multa.getEstado().toDb());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MultaDAO] Error al insertar: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean actualizar(Multa multa) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_ACTUALIZAR)) {

            ps.setInt(1, multa.getIdPrestamo());
            ps.setDouble(2, multa.getMonto());
            FechaHelper.escribir(ps, 3, multa.getFechaGeneracion());
            FechaHelper.escribir(ps, 4, multa.getFechaPago()); // puede ser null
            ps.setString(5, multa.getEstado().toDb());
            ps.setInt(6, multa.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MultaDAO] Error al actualizar: " + e.getMessage());
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
            System.err.println("[MultaDAO] Error al eliminar: " + e.getMessage());
            return false;
        }
    }

    @Override
    public Optional<Multa> buscarPorId(int id) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_BUSCAR_POR_ID)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return Optional.of(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[MultaDAO] Error al buscar por id: " + e.getMessage());
        }
        return Optional.empty();
    }

    @Override
    public List<Multa> listarTodos() {
        List<Multa> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_LISTAR_TODOS);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next())
                lista.add(mapear(rs));

        } catch (SQLException e) {
            System.err.println("[MultaDAO] Error al listar: " + e.getMessage());
        }
        return lista;
    }

    // -------------------------------------------------------------------------
    // Consultas específicas
    // -------------------------------------------------------------------------

    @Override
    public Optional<Multa> buscarPorPrestamo(int idPrestamo) {
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_BUSCAR_POR_PRESTAMO)) {

            ps.setInt(1, idPrestamo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return Optional.of(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[MultaDAO] Error al buscar por préstamo: " + e.getMessage());
        }
        return Optional.empty();
    }

    @Override
    public List<Multa> listarPorEstado(String estado) {
        List<Multa> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_LISTAR_POR_ESTADO)) {

            ps.setString(1, estado);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[MultaDAO] Error al listar por estado: " + e.getMessage());
        }
        return lista;
    }

    @Override
    public List<Multa> listarPendientesPorUsuario(int idUsuario) {
        List<Multa> lista = new ArrayList<>();
        try (Connection con = conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(SQL_LISTAR_PENDIENTES_POR_USUARIO)) {

            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    lista.add(mapear(rs));
            }

        } catch (SQLException e) {
            System.err.println("[MultaDAO] Error al listar pendientes por usuario: " + e.getMessage());
        }
        return lista;
    }

    // -------------------------------------------------------------------------
    // Mapper privado — ResultSet → Multa
    // -------------------------------------------------------------------------

    private Multa mapear(ResultSet rs) throws SQLException {
        return new Multa.Builder()
                .id(rs.getInt("id_multa"))
                .idPrestamo(rs.getInt("id_prestamo"))
                .monto(rs.getDouble("monto"))
                .fechaGeneracion(FechaHelper.leer(rs, "fecha_generacion"))
                .fechaPago(FechaHelper.leer(rs, "fecha_pago")) // puede ser null
                .estado(EstadoMulta.fromDb(rs.getString("estado")))
                .build();
    }
}
