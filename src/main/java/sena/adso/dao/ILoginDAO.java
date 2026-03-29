package sena.adso.dao;

import java.util.Optional;

import sena.adso.model.Usuario;

public interface ILoginDAO {

    Optional<Usuario> validarLogin(String email, String password);
}
