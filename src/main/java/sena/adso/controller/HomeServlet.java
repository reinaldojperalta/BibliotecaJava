package sena.adso.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sena.adso.dao.ILibroDAO;
import sena.adso.dao.IMultaDAO;
import sena.adso.dao.IPrestamoDAO;
import sena.adso.dao.IUsuarioDAO;
import sena.adso.dao.impl.LibroDAO;
import sena.adso.dao.impl.MultaDAO;
import sena.adso.dao.impl.PrestamoDAO;
import sena.adso.dao.impl.UsuarioDAO;
import sena.adso.model.Libro;

@WebServlet(value = { "/home", "" })
public class HomeServlet extends HttpServlet {

    private ILibroDAO libroDAO;
    private IPrestamoDAO prestamoDAO;
    private IUsuarioDAO usuarioDAO;
    private IMultaDAO multaDAO;
    private String folder;

    @Override
    public void init() {
        libroDAO = new LibroDAO("mysql");
        prestamoDAO = new PrestamoDAO("mysql");
        usuarioDAO = new UsuarioDAO("mysql"); // Ajusta según tu implementación
        multaDAO = new MultaDAO("mysql");
        this.folder = getServletContext().getInitParameter("vistasPath");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Datos reales eficientes
        int totalLibros = libroDAO.contarTotal();
        int totalPrestamosActivos = prestamoDAO.contarActivos(); // o contarPorEstado("activo")
        int totalUsuarios = usuarioDAO.contarTotal();
        double totalMultasPendientes = multaDAO.sumarPendientes();
        List<Libro> librosDestacados = libroDAO.listarRecientes(6);

        req.setAttribute("totalLibros", totalLibros);
        req.setAttribute("totalPrestamos", totalPrestamosActivos);
        req.setAttribute("totalUsuarios", totalUsuarios);
        req.setAttribute("totalMultas", totalMultasPendientes);
        req.setAttribute("librosDestacados", librosDestacados);

        req.getRequestDispatcher(folder + "home.jsp").forward(req, res);
    }
}