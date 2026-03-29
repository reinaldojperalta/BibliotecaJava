package sena.adso.model;

import sena.adso.model.enums.EstadoLibro;

public class Libro {

    private int id;
    private String titulo;
    private String isbn;
    private int anioPublicacion;
    private int numPaginas;
    private int idEditorial;
    private int idCategoria;
    private EstadoLibro estado;

    public Libro() {
    }

    private Libro(Builder builder) {
        this.id = builder.id;
        this.titulo = builder.titulo;
        this.isbn = builder.isbn;
        this.anioPublicacion = builder.anioPublicacion;
        this.numPaginas = builder.numPaginas;
        this.idEditorial = builder.idEditorial;
        this.idCategoria = builder.idCategoria;
        this.estado = builder.estado;
    }

    public static class Builder {

        private int id;
        private String titulo;
        private String isbn;
        private int anioPublicacion;
        private int numPaginas;
        private int idEditorial;
        private int idCategoria;
        private EstadoLibro estado;

        public Builder id(int id) {
            this.id = id;
            return this;
        }

        public Builder titulo(String titulo) {
            this.titulo = titulo;
            return this;
        }

        public Builder isbn(String isbn) {
            this.isbn = isbn;
            return this;
        }

        public Builder anioPublicacion(int anio) {
            this.anioPublicacion = anio;
            return this;
        }

        public Builder numPaginas(int numPaginas) {
            this.numPaginas = numPaginas;
            return this;
        }

        public Builder idEditorial(int idEditorial) {
            this.idEditorial = idEditorial;
            return this;
        }

        public Builder idCategoria(int idCategoria) {
            this.idCategoria = idCategoria;
            return this;
        }

        public Builder estado(EstadoLibro estado) {
            this.estado = estado;
            return this;
        }

        public Libro build() {
            return new Libro(this);
        }
    }

    /* GETTERS */
    public int getId() {
        return id;
    }

    public String getTitulo() {
        return titulo;
    }

    public String getIsbn() {
        return isbn;
    }

    public int getAnioPublicacion() {
        return anioPublicacion;
    }

    public int getNumPaginas() {
        return numPaginas;
    }

    public int getIdEditorial() {
        return idEditorial;
    }

    public int getIdCategoria() {
        return idCategoria;
    }

    public EstadoLibro getEstado() {
        return estado;
    }

    /* SETTERS */
    public void setId(int id) {
        this.id = id;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public void setAnioPublicacion(int anioPublicacion) {
        this.anioPublicacion = anioPublicacion;
    }

    public void setNumPaginas(int numPaginas) {
        this.numPaginas = numPaginas;
    }

    public void setIdEditorial(int idEditorial) {
        this.idEditorial = idEditorial;
    }

    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
    }

    public void setEstado(EstadoLibro estado) {
        this.estado = estado;
    }

    @Override
    public String toString() {
        return "Libro{" + "id=" + id + ", titulo='" + titulo + '\'' + ", isbn='" + isbn + '\'' + ", estado=" + estado
                + '}';
    }
}