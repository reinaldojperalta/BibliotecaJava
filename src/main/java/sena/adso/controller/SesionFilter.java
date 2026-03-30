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
    private static final String[] RUTAS_PUBLICAS = {
            "/login", "/login.jsp", "/index.jsp"
    };

    // Rutas exclusivas de ADMIN
    private static final String[] RUTAS_ADMIN = {
            "/dashboard", "/DashboardServlet"
    };

    // Rutas exclusivas de ADMIN y BIBLIOTECARIO
    private static final String[] RUTAS_ADMIN_BIBLIOTECARIO = {
            "/UsuarioServlet"
    };

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String ruta = req.getServletPath();

        // 1 — Dejar pasar rutas públicas siempre
        if (esRutaPublica(ruta)) {
            chain.doFilter(request, response);
            return;
        }

        // 2 — Sin sesión → login
        if (session == null || session.getAttribute("usuarioActivo") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuarioActivo");
        RolUsuario rol = usuario.getRol();

        // 3 — Ruta exclusiva ADMIN
        if (esRuta(ruta, RUTAS_ADMIN) && rol != RolUsuario.ADMINISTRADOR) {
            res.sendRedirect(req.getContextPath() + "/resumen.jsp?error=acceso_denegado");
            return;
        }

        // 4 — Ruta exclusiva ADMIN o BIBLIOTECARIO
        if (esRuta(ruta, RUTAS_ADMIN_BIBLIOTECARIO)
                && rol != RolUsuario.ADMINISTRADOR
                && rol != RolUsuario.BIBLIOTECARIO) {
            res.sendRedirect(req.getContextPath() + "/resumen.jsp?error=acceso_denegado");
            return;
        }

        // 5 — Sesión válida y rol permitido → continuar
        chain.doFilter(request, response);
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
