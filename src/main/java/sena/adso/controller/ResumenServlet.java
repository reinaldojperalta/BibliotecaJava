package sena.adso.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import sena.adso.model.Prestamo;
import sena.adso.model.Usuario;
import sena.adso.model.enums.EstadoMulta;
import sena.adso.model.enums.EstadoPrestamo;
import sena.adso.model.enums.RolUsuario;

@WebServlet("/resumen")
public class ResumenServlet extends HttpServlet {

    private IPrestamoDAO prestamoDAO;
    private IMultaDAO multaDAO;
    private ILibroDAO libroDAO; // NUEVO
    private String folder;

    @Override
    public void init() {
        prestamoDAO = new PrestamoDAO("mysql");
        multaDAO = new MultaDAO("mysql");
        libroDAO = new LibroDAO("mysql"); // NUEVO
        this.folder = getServletContext().getInitParameter("vistasPath");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Usuario usuario = (Usuario) req.getSession().getAttribute("usuarioActivo");
        RolUsuario rol = usuario.getRol();

        List<Prestamo> prestamos;

        if (rol == RolUsuario.LECTOR) {
            // Lector: solo ve sus propios préstamos activos y multas pendientes
            prestamos = prestamoDAO.listarPorEstado(EstadoPrestamo.ACTIVO.toDb())
                    .stream()
                    .filter(p -> p.getIdUsuario() == usuario.getId())
                    .toList();

            req.setAttribute("multas",
                    multaDAO.listarPendientesPorUsuario(usuario.getId()));

        } else {
            // ADMIN o BIBLIOTECARIO: ven todos los préstamos activos y multas pendientes
            prestamos = prestamoDAO.listarPorEstado(EstadoPrestamo.ACTIVO.toDb());

            req.setAttribute("multas",
                    multaDAO.listarPorEstado(EstadoMulta.PENDIENTE.toDb()));
        }

        // NUEVO: Cargar mapa de libros para obtener los nombres
        Map<Integer, String> nombresLibros = new HashMap<>();
        for (Prestamo p : prestamos) {
            libroDAO.buscarPorId(p.getIdLibro()).ifPresent(libro -> {
                nombresLibros.put(p.getIdLibro(), libro.getTitulo());
            });
        }

        req.setAttribute("prestamos", prestamos);
        req.setAttribute("nombresLibros", nombresLibros); // NUEVO
        req.setAttribute("rol", rol.name());
        req.getRequestDispatcher(folder + "resumen.jsp").forward(req, res);
    }
}