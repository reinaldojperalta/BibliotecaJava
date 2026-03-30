<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="sena.adso.model.Prestamo" %>
<%@ page import="sena.adso.model.Multa" %>
<%@ page import="sena.adso.model.Usuario" %>

<%@ page import="sena.adso.model.enums.EstadoPrestamo" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuarioPrestamos = (Usuario) session.getAttribute("usuarioActivo");
    String rolPrestamosStr = usuarioPrestamos.getRol().toDb();
    boolean esEditorP = "admin".equals(rolPrestamosStr) || "bibliotecario".equals(rolPrestamosStr);

    List<Prestamo> prestamos = (List<Prestamo>) request.getAttribute("prestamos");
    List<Multa>    multas    = (List<Multa>)    request.getAttribute("multas");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Préstamos - Biblioteca</title>
    <style>
        body { font-family: sans-serif; margin: 0; }
        .contenido { padding: 20px; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 30px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f0f0f0; }
        h2 { border-bottom: 2px solid #333; padding-bottom: 6px; }
        form.inline { display: inline; }
        button { padding: 5px 10px; cursor: pointer; }
        .btn-peligro { background: #c00; color: white; border: none; }
        .btn-ok { background: #060; color: white; border: none; }
        .msg { color: green; }
    </style>
</head>
<body>
<%@ include file="nav.jsp" %>
<div class="contenido">

    <% if (request.getParameter("msg") != null) { %>
        <p class="msg"><%= request.getParameter("msg") %></p>
    <% } %>

    <!-- PRÉSTAMOS -->
    <h2>Préstamos</h2>
    <% if (prestamos == null || prestamos.isEmpty()) { %>
        <p>No hay préstamos para mostrar.</p>
    <% } else { %>
    <table>
        <tr>
            <th>ID</th><th>ID Libro</th><th>ID Usuario</th>
            <th>Fecha préstamo</th><th>Devolución esperada</th>
            <th>Devolución real</th><th>Estado</th>
            <% if (esEditorP) { %><th>Acciones</th><% } %>
        </tr>
        <% for (Prestamo p : prestamos) { %>
        <tr>
            <td><%= p.getId() %></td>
            <td><%= p.getIdLibro() %></td>
            <td><%= p.getIdUsuario() %></td>
            <td><%= p.getFechaPrestamo() %></td>
            <td><%= p.getFechaDevolucionEsperada() %></td>
            <td><%= p.getFechaDevolucionReal() != null ? p.getFechaDevolucionReal() : "-" %></td>
            <td><%= p.getEstado() %></td>
            <% if (esEditorP) { %>
            <td>
                <% if ("activo".equals(p.getEstado().toDb())) { %>
                    <!-- Registrar devolución -->
                    <form class="inline" method="get" action="<%= request.getContextPath() %>/prestamos">
                        <input type="hidden" name="action" value="devolver">
                        <input type="hidden" name="id" value="<%= p.getId() %>">
                        <button class="btn-ok" type="submit">Devolver</button>
                    </form>
                <% } %>
                <!-- Cambiar estado manualmente -->
                <form class="inline" method="post" action="<%= request.getContextPath() %>/prestamos">
                    <input type="hidden" name="action" value="actualizarPrestamo">
                    <input type="hidden" name="id" value="<%= p.getId() %>">
                    <select name="estado">
                        <option value="activo"   <%= "activo".equals(p.getEstado().toDb())   ? "selected" : "" %>>activo</option>
                        <option value="devuelto" <%= "devuelto".equals(p.getEstado().toDb()) ? "selected" : "" %>>devuelto</option>
                        <option value="vencido"  <%= "vencido".equals(p.getEstado().toDb())  ? "selected" : "" %>>vencido</option>
                    </select>
                    <button type="submit">Actualizar</button>
                </form> |
                <form class="inline" method="get" action="<%= request.getContextPath() %>/prestamos">
                    <input type="hidden" name="action" value="eliminar">
                    <input type="hidden" name="id" value="<%= p.getId() %>">
                    <button class="btn-peligro" type="submit"
                        onclick="return confirm('¿Eliminar préstamo?')">Eliminar</button>
                </form>
            </td>
            <% } %>
        </tr>
        <% } %>
    </table>
    <% } %>

    <!-- MULTAS -->
    <h2>Multas</h2>
    <% if (multas == null || multas.isEmpty()) { %>
        <p>No hay multas para mostrar.</p>
    <% } else { %>
    <table>
        <tr>
            <th>ID</th><th>ID Préstamo</th><th>Monto</th>
            <th>Fecha generación</th><th>Fecha pago</th><th>Estado</th>
            <% if (esEditorP) { %><th>Acciones</th><% } %>
        </tr>
        <% for (Multa m : multas) { %>
        <tr>
            <td><%= m.getId() %></td>
            <td><%= m.getIdPrestamo() %></td>
            <td>$<%= m.getMonto() %></td>
            <td><%= m.getFechaGeneracion() %></td>
            <td><%= m.getFechaPago() != null ? m.getFechaPago() : "-" %></td>
            <td><%= m.getEstado() %></td>
            <% if (esEditorP) { %>
            <td>
                <form class="inline" method="post" action="<%= request.getContextPath() %>/prestamos">
                    <input type="hidden" name="action"  value="pagarMulta">
                    <input type="hidden" name="idMulta" value="<%= m.getId() %>">
                    <button class="btn-ok" type="submit">Marcar pagada</button>
                </form>
                <form class="inline" method="post" action="<%= request.getContextPath() %>/prestamos">
                    <input type="hidden" name="action"  value="exonerarMulta">
                    <input type="hidden" name="idMulta" value="<%= m.getId() %>">
                    <button type="submit">Exonerar</button>
                </form>
            </td>
            <% } %>
        </tr>
        <% } %>
    </table>
    <% } %>

</div>
</body>
</html>
