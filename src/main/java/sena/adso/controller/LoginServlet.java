package sena.adso.controller;

import java.io.IOException;
import java.util.Optional;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sena.adso.dao.ILoginDAO;
import sena.adso.dao.impl.LoginDAO;
import sena.adso.model.Usuario;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private ILoginDAO loginDAO;
    private String folder;

    @Override
    public void init() {
        loginDAO = new LoginDAO("mysql");
        this.folder = getServletContext().getInitParameter("vistasPath");

    }

    // GET → mostrar formulario de login
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Si ya hay sesión activa, redirigir directo al resumen
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("usuarioActivo") != null) {
            req.getRequestDispatcher(folder + "/resumen").forward(req, res);
            return;
        }
        req.getRequestDispatcher(folder + "login.jsp").forward(req, res);
    }

    // POST → procesar credenciales
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        // Validación básica de campos vacíos
        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            req.setAttribute("error", "Email y contraseña son obligatorios");
            req.getRequestDispatcher(folder + "/login.jsp").forward(req, res);
            return;
        }

        // Hashear password antes de consultar la BD
        // String passwordHash = hashear(password);

        System.out.println("Email recibido: " + email);
        System.out.println("Password hash generado: " + password);

        Optional<Usuario> resultado = loginDAO.validarLogin(email.trim(), password);

        if (resultado.isPresent()) {
            Usuario usuario = resultado.get();
            System.out.println("¡Login exitoso para: " + resultado.get().getNombres() + "!");
            // Crear sesión y guardar usuario
            HttpSession session = req.getSession(true);
            session.setAttribute("usuarioActivo", usuario);
            session.setMaxInactiveInterval(30 * 60); // 30 minutos

            res.sendRedirect(req.getContextPath() + "/resumen");
        } else {
            System.out.println("Login fallido: No se encontró el usuario con esas credenciales.");
            req.setAttribute("error", "Credenciales incorrectas o usuario inactivo");
            req.getRequestDispatcher(folder + "login.jsp").forward(req, res);
        }
    }

    /**
     * TODO: reemplazar con BCrypt u otro algoritmo seguro.
     * Por ahora usa SHA-256 simple para la pre-alpha.
     */
    /*
     * private String hashear(String password) {
     * try {
     * var digest = java.security.MessageDigest.getInstance("SHA-256");
     * byte[] hash =
     * digest.digest(password.getBytes(java.nio.charset.StandardCharsets.UTF_8));
     * StringBuilder sb = new StringBuilder();
     * for (byte b : hash)
     * sb.append(String.format("%02x", b));
     * return sb.toString();
     * } catch (Exception e) {
     * throw new RuntimeException("Error al hashear password", e);
     * }
     * }
     */
}
