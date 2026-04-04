<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="sena.adso.model.Usuario" %>
<%
    Usuario usuarioNav = (Usuario) session.getAttribute("usuarioActivo");
    String rolNavStr   = "";
    if (usuarioNav != null && usuarioNav.getRol() != null) {
        rolNavStr = usuarioNav.getRol().toDb(); // "admin", "bibliotecario" o "lector"
    }
%>
<nav style="background:#333; padding:10px 20px; display:flex; gap:16px; align-items:center;">
    <span style="color:#aaa; font-size:0.85rem;">
        <%= usuarioNav != null ? usuarioNav.getNombres() + " | " + rolNavStr : "" %>
    </span>

    <a href="<%= request.getContextPath() %>/resumen"   style="color:white; text-decoration:none;">Resumen</a>
    <a href="<%= request.getContextPath() %>/libros"    style="color:white; text-decoration:none;">Libros</a>
    <a href="<%= request.getContextPath() %>/prestamos" style="color:white; text-decoration:none;">Préstamos</a>

    <% if ("admin".equals(rolNavStr)) { %>
        <a href="<%= request.getContextPath() %>/dashboard" style="color:#ffd700; text-decoration:none;">Dashboard</a>
    <% } %>

    <a href="<%= request.getContextPath() %>/logout" style="color:#f88; text-decoration:none; margin-left:auto;">Salir</a>
</nav>
