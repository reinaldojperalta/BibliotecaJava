package sena.adso.dao;

import sena.adso.model.Editorial;
import java.util.List;
import java.util.Optional;

public interface IEditorialDAO {

    boolean             insertar(Editorial editorial);
    boolean             actualizar(Editorial editorial);
    boolean             eliminar(int id);
    Optional<Editorial> buscarPorId(int id);
    List<Editorial>     listarTodos();
}
