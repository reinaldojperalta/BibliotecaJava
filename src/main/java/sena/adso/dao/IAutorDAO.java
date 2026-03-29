package sena.adso.dao;

import sena.adso.model.Autor;
import java.util.List;
import java.util.Optional;

public interface IAutorDAO {

    boolean         insertar(Autor autor);
    boolean         actualizar(Autor autor);
    boolean         eliminar(int id);
    Optional<Autor> buscarPorId(int id);
    List<Autor>     listarTodos();

    // Consultas específicas
    List<Autor>     buscarPorApellido(String apellido);
    List<Autor>     listarPorLibro(int idLibro);        // via tabla libro_autor
}
