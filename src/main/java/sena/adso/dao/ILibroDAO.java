package sena.adso.dao;

import java.util.List;
import java.util.Optional;

import sena.adso.model.Libro;

public interface ILibroDAO {

    boolean insertar(Libro libro);

    boolean actualizar(Libro libro);

    boolean eliminar(int id);

    Optional<Libro> buscarPorId(int id);

    List<Libro> listarTodos();

    // Consultas específicas
    Optional<Libro> buscarPorIsbn(String isbn);

    List<Libro> buscarPorTitulo(String titulo);

    List<Libro> listarPorCategoria(int idCategoria);

    List<Libro> listarPorEstado(String estado); // usa EstadoLibro.toDb()

    int contarTotal();

    List<Libro> listarRecientes(int i);

}
