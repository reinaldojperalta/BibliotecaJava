package sena.adso.dao;

import sena.adso.model.Multa;
import java.util.List;
import java.util.Optional;

public interface IMultaDAO {

    boolean           insertar(Multa multa);
    boolean           actualizar(Multa multa);
    boolean           eliminar(int id);
    Optional<Multa>   buscarPorId(int id);
    List<Multa>       listarTodos();

    // Consultas específicas
    Optional<Multa>   buscarPorPrestamo(int idPrestamo);   // max 1 multa por préstamo
    List<Multa>       listarPorEstado(String estado);      // usa EstadoMulta.toDb()
    List<Multa>       listarPendientesPorUsuario(int idUsuario);
}
