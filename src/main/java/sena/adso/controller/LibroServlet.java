package sena.adso.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Optional;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sena.adso.dao.ICategoriaDAO;
import sena.adso.dao.IEditorialDAO;
import sena.adso.dao.ILibroDAO;
import sena.adso.dao.IPrestamoDAO;
import sena.adso.dao.impl.CategoriaDAO;
import sena.adso.dao.impl.EditorialDAO;
import sena.adso.dao.impl.LibroDAO;
import sena.adso.dao.impl.PrestamoDAO;
import sena.adso.model.Libro;
import sena.adso.model.Prestamo;
import sena.adso.model.Usuario;
import sena.adso.model.enums.EstadoLibro;
import sena.adso.model.enums.EstadoPrestamo;
import sena.adso.model.enums.RolUsuario;

@WebServlet("/libros")
public class LibroServlet extends HttpServlet {

    private ILibroDAO libroDAO;
    private IPrestamoDAO prestamoDAO;
    private IEditorialDAO editorialDAO;
    private ICategoriaDAO categoriaDAO;

    @Override
    public void init() {
        libroDAO = new LibroDAO("sqlite");
        prestamoDAO = new PrestamoDAO("sqlite");
        editorialDAO = new EditorialDAO("sqlite");
        categoriaDAO = new CategoriaDAO("sqlite");
    }

    // GET → listar libros o mostrar formulario
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null)
            action = "listar";

        switch (action) {

            case "listar" -> {
                req.setAttribute("libros", libroDAO.listarTodos());
                req.setAttribute("editoriales", editorialDAO.listarTodos());
                req.setAttribute("categorias", categoriaDAO.listarTodos());
                req.getRequestDispatcher("/libros.jsp").forward(req, res);
            }

            case "editar" -> {
                soloAdminBibliotecario(req, res);
                int id = Integer.parseInt(req.getParameter("id"));
                libroDAO.buscarPorId(id).ifPresent(l -> req.setAttribute("libro", l));
                req.setAttribute("editoriales", editorialDAO.listarTodos());
                req.setAttribute("categorias", categoriaDAO.listarTodos());
                req.getRequestDispatcher("/libros.jsp").forward(req, res);
            }

            case "eliminar" -> {
                soloAdminBibliotecario(req, res);
                int id = Integer.parseInt(req.getParameter("id"));
                libroDAO.eliminar(id);
                res.sendRedirect(req.getContextPath() + "/libros?action=listar");
            }

            default -> res.sendRedirect(req.getContextPath() + "/libros?action=listar");
        }
    }

    // POST → crear, actualizar o asignar préstamo
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null)
            action = "";

        switch (action) {

            case "crear" -> {
                soloAdminBibliotecario(req, res);
                Libro libro = construirDesdeForm(req);
                boolean ok = libroDAO.insertar(libro);
                String msg = ok ? "Libro creado correctamente" : "Error al crear el libro";
                res.sendRedirect(req.getContextPath() + "/libros?action=listar&msg=" + msg);
            }

            case "actualizar" -> {
                soloAdminBibliotecario(req, res);
                int id = Integer.parseInt(req.getParameter("id"));
                Libro libro = construirDesdeForm(req);
                libro.setId(id);
                boolean ok = libroDAO.actualizar(libro);
                String msg = ok ? "Libro actualizado" : "Error al actualizar";
                res.sendRedirect(req.getContextPath() + "/libros?action=listar&msg=" + msg);
            }

            // Lector se asigna un libro: crea un préstamo
            case "asignar" -> {
                Usuario usuario = (Usuario) req.getSession().getAttribute("usuarioActivo");
                int idLibro = Integer.parseInt(req.getParameter("idLibro"));

                Optional<Libro> optLibro = libroDAO.buscarPorId(idLibro);
                if (optLibro.isEmpty() || optLibro.get().getEstado() != EstadoLibro.DISPONIBLE) {
                    res.sendRedirect(req.getContextPath() + "/libros?action=listar&msg=libro_no_disponible");
                    return;
                }

                // Crear préstamo con 15 días por defecto
                Prestamo prestamo = new Prestamo.Builder()
                        .idLibro(idLibro)
                        .idUsuario(usuario.getId())
                        .fechaPrestamo(LocalDate.now())
                        .fechaDevolucionEsperada(LocalDate.now().plusDays(15))
                        .estado(EstadoPrestamo.ACTIVO)
                        .build();

                boolean ok = prestamoDAO.insertar(prestamo);

                if (ok) {
                    // Actualizar estado del libro a PRESTADO
                    Libro libro = optLibro.get();
                    libro.setEstado(EstadoLibro.PRESTADO);
                    libroDAO.actualizar(libro);
                }

                String msg = ok ? "Libro asignado correctamente" : "Error al asignar libro";
                res.sendRedirect(req.getContextPath() + "/libros?action=listar&msg=" + msg);
            }

            default -> res.sendRedirect(req.getContextPath() + "/libros?action=listar");
        }
    }

    // -------------------------------------------------------------------------
    // Helpers privados
    // -------------------------------------------------------------------------

    /** Construye un Libro desde los parámetros del formulario */
    private Libro construirDesdeForm(HttpServletRequest req) {
        return new Libro.Builder()
                .titulo(req.getParameter("titulo"))
                .isbn(req.getParameter("isbn"))
                .anioPublicacion(Integer.parseInt(req.getParameter("anioPublicacion")))
                .numPaginas(Integer.parseInt(req.getParameter("numPaginas")))
                .idEditorial(Integer.parseInt(req.getParameter("idEditorial")))
                .idCategoria(Integer.parseInt(req.getParameter("idCategoria")))
                .estado(EstadoLibro.fromDb(req.getParameter("estado")))
                .build();
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
