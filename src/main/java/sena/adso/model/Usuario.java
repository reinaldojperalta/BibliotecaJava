package sena.adso.model;

import sena.adso.model.enums.EstadoUsuario;
import sena.adso.model.enums.RolUsuario;

public class Usuario {
    private int id;
    private String documento;
    private String password;
    private String nombres;
    private String apellidos;
    private String email;
    private String telefono;
    private RolUsuario rol;
    private EstadoUsuario estado;

    public Usuario() {
    }

    private Usuario(Builder builder) {
        this.id = builder.id;
        this.documento = builder.documento;
        this.password = builder.password;
        this.nombres = builder.nombres;
        this.apellidos = builder.apellidos;
        this.email = builder.email;
        this.telefono = builder.telefono;
        this.rol = builder.rol;
        this.estado = builder.estado;

    }

    public static class Builder {
        private int id;
        private String documento;
        private String password;
        private String nombres;
        private String apellidos;
        private String email;
        private String telefono;
        private RolUsuario rol;
        private EstadoUsuario estado;

        public Builder id(int id) {
            this.id = id;
            return this;
        }

        public Builder documento(String documento) {
            this.documento = documento;
            return this;
        }

        public Builder password(String password) {
            this.password = password;
            return this;
        }

        public Builder nombres(String nombres) {
            this.nombres = nombres;
            return this;
        }

        public Builder apellidos(String apellidos) {
            this.apellidos = apellidos;
            return this;
        }

        public Builder email(String email) {
            this.email = email;
            return this;
        }

        public Builder telefono(String telefono) {
            this.telefono = telefono;
            return this;
        }

        public Builder rol(RolUsuario rol) {
            this.rol = rol;
            return this;
        }

        public Builder estado(EstadoUsuario estado) {
            this.estado = estado;
            return this;
        }

        public Usuario build() {
            return new Usuario(this);
        }
    }

    @Override
    public String toString() {
        return "Usuario{" + "id=" + id + ", nombres='" + nombres + '\'' + ", rol=" + rol + '}';
    }

    /* GETTERS */

    public int getId() {
        return id;
    }

    public String getCedula() {
        return documento;
    }

    public String getPassword() {
        return password;
    }

    public String getNombres() {
        return nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public String getEmail() {
        return email;
    }

    public String getTelefono() {
        return telefono;
    }

    public RolUsuario getRol() {
        return rol;
    }

    public EstadoUsuario getEstado() {
        return estado;
    }

    /* SETTERS */
    public void setId(int id) {
        this.id = id;
    }

    public void setCedula(String documento) {
        this.documento = documento;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public void setRol(RolUsuario rol) {
        this.rol = rol;
    }

    public void setEstado(EstadoUsuario estado) {
        this.estado = estado;
    }

}
