package sena.adso.dao;

import sena.adso.model.Libro;
import java.util.List;
import java.util.Optional;

public interface ILibroDAO {

    boolean           insertar(Libro libro);
    boolean           actualizar(Libro libro);
    boolean           eliminar(int id);
    Optional<Libro>   buscarPorId(int id);
    List<Libro>       listarTodos();

    // Consultas específicas
    Optional<Libro>   buscarPorIsbn(String isbn);
    List<Libro>       buscarPorTitulo(String titulo);
    List<Libro>       listarPorCategoria(int idCategoria);
    List<Libro>       listarPorEstado(String estado);       // usa EstadoLibro.toDb()
}
