package sena.adso.model;

public class Autor {

    private int id;
    private String nombres;
    private String apellidos;
    private String nacionalidad;
    private String fechaNacimiento; // formato ISO: YYYY-MM-DD

    public Autor() {
    }

    private Autor(Builder builder) {
        this.id = builder.id;
        this.nombres = builder.nombres;
        this.apellidos = builder.apellidos;
        this.nacionalidad = builder.nacionalidad;
        this.fechaNacimiento = builder.fechaNacimiento;
    }

    public static class Builder {

        private int id;
        private String nombres;
        private String apellidos;
        private String nacionalidad;
        private String fechaNacimiento;

        public Builder id(int id) {
            this.id = id;
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

        public Builder nacionalidad(String nacionalidad) {
            this.nacionalidad = nacionalidad;
            return this;
        }

        public Builder fechaNacimiento(String fechaNac) {
            this.fechaNacimiento = fechaNac;
            return this;
        }

        public Autor build() {
            return new Autor(this);
        }
    }

    @Override
    public String toString() {
        return "Autor{" +
                "id=" + id +
                ", nombres='" + nombres + '\'' +
                ", apellidos='" + apellidos + '\'' +
                ", nacionalidad='" + nacionalidad + '\'' +
                '}';
    }

    /* GETTERS */
    public int getId() {
        return id;
    }

    public String getNombres() {
        return nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public String getNacionalidad() {
        return nacionalidad;
    }

    public String getFechaNacimiento() {
        return fechaNacimiento;
    }

    /* SETTERS */
    public void setId(int id) {
        this.id = id;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public void setNacionalidad(String nacionalidad) {
        this.nacionalidad = nacionalidad;
    }

    public void setFechaNacimiento(String fechaNac) {
        this.fechaNacimiento = fechaNac;
    }
}
