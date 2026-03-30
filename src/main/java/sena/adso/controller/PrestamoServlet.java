package sena.adso.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Optional;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sena.adso.dao.ILibroDAO;
import sena.adso.dao.IMultaDAO;
import sena.adso.dao.IPrestamoDAO;
import sena.adso.dao.impl.LibroDAO;
import sena.adso.dao.impl.MultaDAO;
import sena.adso.dao.impl.PrestamoDAO;
import sena.adso.model.Multa;
import sena.adso.model.Prestamo;
import sena.adso.model.Usuario;
import sena.adso.model.enums.EstadoLibro;
import sena.adso.model.enums.EstadoMulta;
import sena.adso.model.enums.EstadoPrestamo;
import sena.adso.model.enums.RolUsuario;

@WebServlet("/prestamos")
public class PrestamoServlet extends HttpServlet {

    private static final double MONTO_MULTA_POR_DIA = 1000.0;

    private IPrestamoDAO prestamoDAO;
    private IMultaDAO multaDAO;
    private ILibroDAO libroDAO;

    @Override
    public void init() {
        prestamoDAO = new PrestamoDAO("sqlite");
        multaDAO = new MultaDAO("sqlite");
        libroDAO = new LibroDAO("sqlite");
    }

    // GET → listar según rol
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null)
            action = "listar";

        Usuario usuario = (Usuario) req.getSession().getAttribute("usuarioActivo");
        RolUsuario rol = usuario.getRol();

        switch (action) {

            case "listar" -> {
                if (rol == RolUsuario.LECTOR) {
                    // Lector: solo sus préstamos
                    req.setAttribute("prestamos", prestamoDAO.listarPorUsuario(usuario.getId()));
                    req.setAttribute("multas", multaDAO.listarPendientesPorUsuario(usuario.getId()));
                } else {
                    // Admin / Bibliotecario: todos
                    req.setAttribute("prestamos", prestamoDAO.listarTodos());
                    req.setAttribute("multas", multaDAO.listarTodos());
                }
                req.getRequestDispatcher("/prestamos.jsp").forward(req, res);
            }

            case "devolver" -> {
                soloAdminBibliotecario(req, res);
                int idPrestamo = Integer.parseInt(req.getParameter("id"));
                procesarDevolucion(idPrestamo);
                res.sendRedirect(req.getContextPath() + "/prestamos?action=listar&msg=devolucion_ok");
            }

            case "eliminar" -> {
                soloAdminBibliotecario(req, res);
                int id = Integer.parseInt(req.getParameter("id"));
                prestamoDAO.eliminar(id);
                res.sendRedirect(req.getContextPath() + "/prestamos?action=listar");
            }

            default -> res.sendRedirect(req.getContextPath() + "/prestamos?action=listar");
        }
    }

    // POST → actualizar estado de préstamo o multa
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        soloAdminBibliotecario(req, res);
        String action = req.getParameter("action");
        if (action == null)
            action = "";

        switch (action) {

            case "actualizarPrestamo" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                String est = req.getParameter("estado");
                prestamoDAO.buscarPorId(id).ifPresent(p -> {
                    p.setEstado(EstadoPrestamo.fromDb(est));
                    prestamoDAO.actualizar(p);
                });
                res.sendRedirect(req.getContextPath() + "/prestamos?action=listar");
            }

            case "pagarMulta" -> {
                int idMulta = Integer.parseInt(req.getParameter("idMulta"));
                multaDAO.buscarPorId(idMulta).ifPresent(m -> {
                    m.setEstado(EstadoMulta.PAGADA);
                    m.setFechaPago(LocalDate.now());
                    multaDAO.actualizar(m);
                });
                res.sendRedirect(req.getContextPath() + "/prestamos?action=listar&msg=multa_pagada");
            }

            case "exonerarMulta" -> {
                int idMulta = Integer.parseInt(req.getParameter("idMulta"));
                multaDAO.buscarPorId(idMulta).ifPresent(m -> {
                    m.setEstado(EstadoMulta.EXONERADA);
                    multaDAO.actualizar(m);
                });
                res.sendRedirect(req.getContextPath() + "/prestamos?action=listar&msg=multa_exonerada");
            }

            default -> res.sendRedirect(req.getContextPath() + "/prestamos?action=listar");
        }
    }

    // -------------------------------------------------------------------------
    // Helpers privados
    // -------------------------------------------------------------------------

    /**
     * Procesa la devolución de un préstamo:
     * 1. Marca el préstamo como DEVUELTO con la fecha real de hoy.
     * 2. Libera el libro (estado → DISPONIBLE).
     * 3. Si se devuelve tarde, genera la multa automáticamente.
     */
    private void procesarDevolucion(int idPrestamo) {
        Optional<Prestamo> opt = prestamoDAO.buscarPorId(idPrestamo);
        if (opt.isEmpty())
            return;

        Prestamo prestamo = opt.get();
        LocalDate hoy = LocalDate.now();
        LocalDate esperada = prestamo.getFechaDevolucionEsperada();

        // 1 — Actualizar préstamo
        prestamo.setFechaDevolucionReal(hoy);
        prestamo.setEstado(EstadoPrestamo.DEVUELTO);
        prestamoDAO.actualizar(prestamo);

        // 2 — Liberar libro
        libroDAO.buscarPorId(prestamo.getIdLibro()).ifPresent(libro -> {
            libro.setEstado(EstadoLibro.DISPONIBLE);
            libroDAO.actualizar(libro);
        });

        // 3 — Generar multa si se devuelve tarde
        if (hoy.isAfter(esperada)) {
            long diasRetraso = ChronoUnit.DAYS.between(esperada, hoy);
            double monto = diasRetraso * MONTO_MULTA_POR_DIA;

            Multa multa = new Multa.Builder()
                    .idPrestamo(idPrestamo)
                    .monto(monto)
                    .fechaGeneracion(hoy)
                    .estado(EstadoMulta.PENDIENTE)
                    .build();

            multaDAO.insertar(multa);
        }
    }

    /** Redirige a resumen si el usuario no es ADMIN o BIBLIOTECARIO */
    private void soloAdminBibliotecario(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        Usuario usuario = (Usuario) req.getSession().getAttribute("usuarioActivo");
        RolUsuario rol = usuario.getRol();
        if (rol != RolUsuario.ADMINISTRADOR && rol != RolUsuario.BIBLIOTECARIO) {
            res.sendRedirect(req.getContextPath() + "/resumen.jsp?error=acceso_denegado");
        }
    }
}
