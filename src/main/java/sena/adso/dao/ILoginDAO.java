package sena.adso.dao;

import sena.adso.model.Usuario;
import java.util.Optional;

public interface ILoginDAO {

    /**
     * Valida las credenciales de acceso.
     * El password debe llegar hasheado desde la capa de servicio.
     * Retorna el usuario solo si existe, el hash coincide
     * y el estado es 'activo'.
     */
    Optional<Usuario> validarLogin(String email, String password);
}
