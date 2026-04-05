package sena.adso.dao;

import java.util.List;
import java.util.Optional;

import sena.adso.model.Prestamo;

public interface IPrestamoDAO {

    boolean insertar(Prestamo prestamo);

    boolean actualizar(Prestamo prestamo);

    boolean eliminar(int id);

    Optional<Prestamo> buscarPorId(int id);

    List<Prestamo> listarTodos();

    // Consultas específicas
    List<Prestamo> listarPorUsuario(int idUsuario);

    List<Prestamo> listarPorEstado(String estado); // usa EstadoPrestamo.toDb()

    List<Prestamo> listarVencidos(); // estado = 'vencido'

    List<Prestamo> listarActivosPorLibro(int idLibro);

    int contarActivos();
}
