<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="sena.adso.model.Prestamo" %>
<%@ page import="sena.adso.model.Multa" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Resumen - Biblioteca</title>
    <style>
        body { font-family: sans-serif; margin: 0; }
        .contenido { padding: 20px; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 30px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f0f0f0; }
        h2 { border-bottom: 2px solid #333; padding-bottom: 6px; }
        .msg-error { color: red; }
    </style>
</head>
<body>
<%@ include file="nav.jsp" %>
<div class="contenido">

    <% if (request.getParameter("error") != null) { %>
        <p class="msg-error">Acceso denegado.</p>
    <% } %>

    <h2>Préstamos activos</h2>
    <%
        List<Prestamo> prestamos = (List<Prestamo>) request.getAttribute("prestamos");
        if (prestamos == null || prestamos.isEmpty()) {
    %>
        <p>No hay préstamos activos.</p>
    <% } else { %>
        <table>
            <tr><th>ID</th><th>ID Libro</th><th>ID Usuario</th><th>Fecha préstamo</th><th>Devolución esperada</th><th>Estado</th></tr>
            <% for (Prestamo p : prestamos) { %>
            <tr>
                <td><%= p.getId() %></td>
                <td><%= p.getIdLibro() %></td>
                <td><%= p.getIdUsuario() %></td>
                <td><%= p.getFechaPrestamo() %></td>
                <td><%= p.getFechaDevolucionEsperada() %></td>
                <td><%= p.getEstado() %></td>
            </tr>
            <% } %>
        </table>
    <% } %>

    <h2>Multas pendientes</h2>
    <%
        List<Multa> multas = (List<Multa>) request.getAttribute("multas");
        if (multas == null || multas.isEmpty()) {
    %>
        <p>No hay multas pendientes.</p>
    <% } else { %>
        <table>
            <tr><th>ID</th><th>ID Préstamo</th><th>Monto</th><th>Fecha generación</th><th>Estado</th></tr>
            <% for (Multa m : multas) { %>
            <tr>
                <td><%= m.getId() %></td>
                <td><%= m.getIdPrestamo() %></td>
                <td>$<%= m.getMonto() %></td>
                <td><%= m.getFechaGeneracion() %></td>
                <td><%= m.getEstado() %></td>
            </tr>
            <% } %>
        </table>
    <% } %>

</div>
</body>
</html>
