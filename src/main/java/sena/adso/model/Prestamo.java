package sena.adso.model;

import java.time.LocalDate;

import sena.adso.model.enums.EstadoPrestamo;

public class Prestamo {

    private int id;
    private int idLibro;
    private int idUsuario;
    private LocalDate fechaPrestamo;
    private LocalDate fechaDevolucionEsperada;
    private LocalDate fechaDevolucionReal;
    private EstadoPrestamo estado;

    public Prestamo() {
    }

    private Prestamo(Builder builder) {
        this.id = builder.id;
        this.idLibro = builder.idLibro;
        this.idUsuario = builder.idUsuario;
        this.fechaPrestamo = builder.fechaPrestamo;
        this.fechaDevolucionEsperada = builder.fechaDevolucionEsperada;
        this.fechaDevolucionReal = builder.fechaDevolucionReal;
        this.estado = builder.estado;
    }

    public static class Builder {

        private int id;
        private int idLibro;
        private int idUsuario;
        private LocalDate fechaPrestamo;
        private LocalDate fechaDevolucionEsperada;
        private LocalDate fechaDevolucionReal;
        private EstadoPrestamo estado;

        public Builder id(int id) {
            this.id = id;
            return this;
        }

        public Builder idLibro(int idLibro) {
            this.idLibro = idLibro;
            return this;
        }

        public Builder idUsuario(int idUsuario) {
            this.idUsuario = idUsuario;
            return this;
        }

        public Builder fechaPrestamo(LocalDate fechaPrestamo) {
            this.fechaPrestamo = fechaPrestamo;
            return this;
        }

        public Builder fechaDevolucionEsperada(LocalDate fechaEsperada) {
            this.fechaDevolucionEsperada = fechaEsperada;
            return this;
        }

        public Builder fechaDevolucionReal(LocalDate fechaReal) {
            this.fechaDevolucionReal = fechaReal;
            return this;
        }

        public Builder estado(EstadoPrestamo estado) {
            this.estado = estado;
            return this;
        }

        public Prestamo build() {
            return new Prestamo(this);
        }
    }

    @Override
    public String toString() {
        return "Prestamo{" +
                "id=" + id +
                ", idLibro=" + idLibro +
                ", idUsuario=" + idUsuario +
                ", fechaPrestamo='" + fechaPrestamo + '\'' +
                ", fechaDevolucionEsperada='" + fechaDevolucionEsperada + '\'' +
                ", estado=" + estado +
                '}';
    }

    /* GETTERS */
    public int getId() {
        return id;
    }

    public int getIdLibro() {
        return idLibro;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public LocalDate getFechaPrestamo() {
        return fechaPrestamo;
    }

    public LocalDate getFechaDevolucionEsperada() {
        return fechaDevolucionEsperada;
    }

    public LocalDate getFechaDevolucionReal() {
        return fechaDevolucionReal;
    }

    public EstadoPrestamo getEstado() {
        return estado;
    }

    /* SETTERS */
    public void setId(int id) {
        this.id = id;
    }

    public void setIdLibro(int idLibro) {
        this.idLibro = idLibro;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public void setFechaPrestamo(LocalDate fechaPrestamo) {
        this.fechaPrestamo = fechaPrestamo;
    }

    public void setFechaDevolucionEsperada(LocalDate fechaEsperada) {
        this.fechaDevolucionEsperada = fechaEsperada;
    }

    public void setFechaDevolucionReal(LocalDate fechaReal) {
        this.fechaDevolucionReal = fechaReal;
    }

    public void setEstado(EstadoPrestamo estado) {
        this.estado = estado;
    }
}
