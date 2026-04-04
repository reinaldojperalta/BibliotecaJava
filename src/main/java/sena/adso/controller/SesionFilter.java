package sena.adso.controller;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sena.adso.model.Usuario;
import sena.adso.model.enums.RolUsuario;

/**
 * Intercepta todas las rutas del proyecto.
 * Reglas:
 * - Sin sesión activa → redirige a login.jsp
 * - /dashboard sin ser ADMIN → redirige a resumen.jsp con error
 * - Rutas públicas (login) → dejar pasar siempre
 */
@WebFilter("/*")
public class SesionFilter implements Filter {

    // Rutas que no requieren sesión
    private static final String[] RUTAS_PUBLICAS = { "/login" };
    // Rutas exclusivas de ADMIN
    private static final String[] RUTAS_ADMIN = {
            "/dashboard", "/DashboardServlet"
    };

    // Rutas exclusivas de ADMIN y BIBLIOTECARIO
    private static final String[] RUTAS_ADMIN_BIBLIOTECARIO = {
            "/UsuarioServlet"
    };

    private static final String[] EXTENSIONES_ESTATICAS = { ".css", ".js", ".png", ".jpg", ".svg", ".ico" };

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        String ruta = req.getServletPath();

        // 1. Dejar pasar recursos estáticos (Tailwind, imágenes)
        if (esRecursoEstatico(ruta)) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Dejar pasar rutas públicas
        if (esRutaPublica(ruta)) {
            chain.doFilter(request, response);
            return;
        }

        // 3. Sin sesión -> Redirigir a la URL del Servlet de login
        if (session == null || session.getAttribute("usuarioActivo") == null) {
            res.sendRedirect(req.getContextPath() + "/login"); // Sin .jsp
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuarioActivo");
        RolUsuario rol = usuario.getRol();

        // 4. Protección de rutas por Rol
        // Redirigir a /resumen (la URL del servlet), no al archivo físico
        if (esRuta(ruta, RUTAS_ADMIN) && rol != RolUsuario.ADMINISTRADOR) {
            res.sendRedirect(req.getContextPath() + "/resumen?error=acceso_denegado");
            return;
        }

        if (esRuta(ruta, RUTAS_ADMIN_BIBLIOTECARIO)
                && rol != RolUsuario.ADMINISTRADOR
                && rol != RolUsuario.BIBLIOTECARIO) {
            res.sendRedirect(req.getContextPath() + "/resumen?error=acceso_denegado");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean esRecursoEstatico(String ruta) {
        for (String ext : EXTENSIONES_ESTATICAS) {
            if (ruta.toLowerCase().endsWith(ext))
                return true;
        }
        return false;
    }

    // -------------------------------------------------------------------------
    // Helpers privados
    // -------------------------------------------------------------------------

    private boolean esRutaPublica(String ruta) {
        for (String publica : RUTAS_PUBLICAS) {
            if (ruta.equalsIgnoreCase(publica))
                return true;
        }
        return false;
    }

    private boolean esRuta(String ruta, String[] rutas) {
        for (String r : rutas) {
            if (ruta.startsWith(r))
                return true;
        }
        return false;
    }

    @Override
    public void init(FilterConfig config) {
    }

    @Override
    public void destroy() {
    }
}
