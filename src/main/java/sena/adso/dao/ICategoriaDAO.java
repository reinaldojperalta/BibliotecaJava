package sena.adso.dao;

import sena.adso.model.Categoria;
import java.util.List;
import java.util.Optional;

public interface ICategoriaDAO {

    boolean             insertar(Categoria categoria);
    boolean             actualizar(Categoria categoria);
    boolean             eliminar(int id);
    Optional<Categoria> buscarPorId(int id);
    List<Categoria>     listarTodos();
}
