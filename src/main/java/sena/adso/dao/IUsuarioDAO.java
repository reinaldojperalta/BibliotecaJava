package sena.adso.dao;

import java.util.List;
import java.util.Optional;

import sena.adso.model.Usuario;

public interface IUsuarioDAO {

    boolean insertar(Usuario usuario);

    boolean actualizar(Usuario usuario);

    boolean eliminar(int id);

    Optional<Usuario> buscarPorId(int id);

    List<Usuario> listarTodos();

    Optional<Usuario> buscarPorDocumento(String documento);

}