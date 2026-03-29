package sena.adso.model;

import java.time.LocalDate;

import sena.adso.model.enums.EstadoMulta;

public class Multa {

    private int id;
    private int idPrestamo;
    private double monto;
    private LocalDate fechaGeneracion;
    private LocalDate fechaPago;
    private EstadoMulta estado;

    public Multa() {
    }

    private Multa(Builder builder) {
        this.id = builder.id;
        this.idPrestamo = builder.idPrestamo;
        this.monto = builder.monto;
        this.fechaGeneracion = builder.fechaGeneracion;
        this.fechaPago = builder.fechaPago;
        this.estado = builder.estado;
    }

    public static class Builder {

        private int id;
        private int idPrestamo;
        private double monto;
        private LocalDate fechaGeneracion;
        private LocalDate fechaPago;
        private EstadoMulta estado;

        public Builder id(int id) {
            this.id = id;
            return this;
        }

        public Builder idPrestamo(int idPrestamo) {
            this.idPrestamo = idPrestamo;
            return this;
        }

        public Builder monto(double monto) {
            this.monto = monto;
            return this;
        }

        public Builder fechaGeneracion(LocalDate fechaGen) {
            this.fechaGeneracion = fechaGen;
            return this;
        }

        public Builder fechaPago(LocalDate fechaPago) {
            this.fechaPago = fechaPago;
            return this;
        }

        public Builder estado(EstadoMulta estado) {
            this.estado = estado;
            return this;
        }

        public Multa build() {
            return new Multa(this);
        }
    }

    @Override
    public String toString() {
        return "Multa{" +
                "id=" + id +
                ", idPrestamo=" + idPrestamo +
                ", monto=" + monto +
                ", estado=" + estado +
                '}';
    }

    /* GETTERS */
    public int getId() {
        return id;
    }

    public int getIdPrestamo() {
        return idPrestamo;
    }

    public double getMonto() {
        return monto;
    }

    public LocalDate getFechaGeneracion() {
        return fechaGeneracion;
    }

    public LocalDate getFechaPago() {
        return fechaPago;
    }

    public EstadoMulta getEstado() {
        return estado;
    }

    /* SETTERS */
    public void setId(int id) {
        this.id = id;
    }

    public void setIdPrestamo(int idPrestamo) {
        this.idPrestamo = idPrestamo;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }

    public void setFechaGeneracion(LocalDate fechaGen) {
        this.fechaGeneracion = fechaGen;
    }

    public void setFechaPago(LocalDate fechaPago) {
        this.fechaPago = fechaPago;
    }

    public void setEstado(EstadoMulta estado) {
        this.estado = estado;
    }
}
