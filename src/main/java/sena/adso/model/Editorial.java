package sena.adso.model;

public class Editorial {

    private int id;
    private String nombre;
    private String pais;
    private String sitioWeb;

    public Editorial() {
    }

    private Editorial(Builder builder) {
        this.id = builder.id;
        this.nombre = builder.nombre;
        this.pais = builder.pais;
        this.sitioWeb = builder.sitioWeb;
    }

    public static class Builder {

        private int id;
        private String nombre;
        private String pais;
        private String sitioWeb;

        public Builder id(int id) {
            this.id = id;
            return this;
        }

        public Builder nombre(String nombre) {
            this.nombre = nombre;
            return this;
        }

        public Builder pais(String pais) {
            this.pais = pais;
            return this;
        }

        public Builder sitioWeb(String sitioWeb) {
            this.sitioWeb = sitioWeb;
            return this;
        }

        public Editorial build() {
            return new Editorial(this);
        }
    }

    @Override
    public String toString() {
        return "Editorial{"
                + "id=" + id
                + ", nombre='" + nombre + '\''
                + ", pais='" + pais + '\''
                + '}';
    }

    /* GETTERS */
    public int getId() {
        return id;
    }

    public String getNombre() {
        return nombre;
    }

    public String getPais() {
        return pais;
    }

    public String getSitioWeb() {
        return sitioWeb;
    }

    /* SETTERS */
    public void setId(int id) {
        this.id = id;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public void setPais(String pais) {
        this.pais = pais;
    }

    public void setSitioWeb(String sitioWeb) {
        this.sitioWeb = sitioWeb;
    }
}
