package sena.adso.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sena.adso.dao.IUsuarioDAO;
import sena.adso.dao.impl.UsuarioDAO;
import sena.adso.model.Usuario;
import sena.adso.model.enums.EstadoUsuario;
import sena.adso.model.enums.RolUsuario;

/**
 * Solo accesible para ADMIN.
 * El SesionFilter ya bloquea cualquier otro rol antes de llegar aquí.
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private IUsuarioDAO usuarioDAO;
    private String folder;

    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO("mysql");
        this.folder = getServletContext().getInitParameter("vistasPath");
    }

    // GET → listar usuarios o mostrar formulario de edición
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null)
            action = "listar";

        switch (action) {

            case "listar" -> {
                req.setAttribute("usuarios", usuarioDAO.listarTodos());
                req.getRequestDispatcher(folder + "dashboard.jsp").forward(req, res);
            }

            case "editar" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                usuarioDAO.buscarPorId(id).ifPresent(u -> req.setAttribute("usuario", u));
                req.getRequestDispatcher(folder + "dashboard.jsp").forward(req, res);
            }

            case "eliminar" -> {

                int id = Integer.parseInt(req.getParameter("id"));
                Usuario actual = (Usuario) req.getSession().getAttribute("usuarioActivo");
                if (actual.getId() == id) {
                    res.sendRedirect(req.getContextPath() + "/dashboard?action=listar&msg=no_puedes_eliminarte");
                    return;
                } else {
                    usuarioDAO.eliminar(id);
                    res.sendRedirect(req.getContextPath() + "/dashboard?action=listar");
                }
            }

            default -> res.sendRedirect(req.getContextPath() + "/dashboard?action=listar");
        }
    }

    // POST → crear o actualizar usuario
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null)
            action = "";

        switch (action) {

            case "crear" -> {
                Usuario nuevo = construirDesdeForm(req);
                boolean ok = usuarioDAO.insertar(nuevo);
                String msg = ok ? "Usuario creado correctamente" : "Error al crear usuario";
                res.sendRedirect(req.getContextPath() + "/dashboard?action=listar&msg=" + msg);
            }

            case "actualizar" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                Usuario usuario = construirDesdeForm(req);
                usuario.setId(id);
                boolean ok = usuarioDAO.actualizar(usuario);
                String msg = ok ? "Usuario actualizado" : "Error al actualizar";
                res.sendRedirect(req.getContextPath() + "/dashboard?action=listar&msg=" + msg);
            }

            default -> res.sendRedirect(req.getContextPath() + "/dashboard?action=listar");
        }
    }

    // -------------------------------------------------------------------------
    // Helper privado
    // -------------------------------------------------------------------------

    private Usuario construirDesdeForm(HttpServletRequest req) {
        return new Usuario.Builder()
                .documento(req.getParameter("documento"))
                .nombres(req.getParameter("nombres"))
                .apellidos(req.getParameter("apellidos"))
                .email(req.getParameter("email"))
                .telefono(req.getParameter("telefono"))
                .rol(RolUsuario.fromDb(req.getParameter("rol")))
                .estado(EstadoUsuario.fromDb(req.getParameter("estado")))
                .build();
        // Nota: el password se hashea y asigna en una operación separada,
        // no desde este formulario general de edición.
    }
}
