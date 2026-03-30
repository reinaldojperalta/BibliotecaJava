<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="sena.adso.model.Usuario" %>

<%@ page import="sena.adso.model.enums.EstadoUsuario" %>
<%@ page import="java.util.List" %>
<%
    List<Usuario> usuarios     = (List<Usuario>) request.getAttribute("usuarios");
    Usuario       usuarioEditar = (Usuario)       request.getAttribute("usuario");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Biblioteca</title>
    <style>
        body { font-family: sans-serif; margin: 0; }
        .contenido { padding: 20px; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 30px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f0f0f0; }
        h2 { border-bottom: 2px solid #333; padding-bottom: 6px; }
        form.inline { display: inline; }
        input, select { padding: 6px; margin: 4px 0; width: 100%; box-sizing: border-box; }
        button { padding: 6px 12px; cursor: pointer; }
        .btn-peligro { background: #c00; color: white; border: none; }
        .formulario { background: #f9f9f9; border: 1px solid #ccc; padding: 16px; max-width: 500px; margin-bottom: 30px; }
        .msg { color: green; }
    </style>
</head>
<body>
<%@ include file="nav.jsp" %>
<div class="contenido">

    <% if (request.getParameter("msg") != null) { %>
        <p class="msg"><%= request.getParameter("msg") %></p>
    <% } %>

    <!-- Formulario CREAR / EDITAR usuario -->
    <div class="formulario">
        <h3><%= usuarioEditar != null ? "Editar usuario" : "Nuevo usuario" %></h3>
        <form method="post" action="<%= request.getContextPath() %>/dashboard">
            <input type="hidden" name="action" value="<%= usuarioEditar != null ? "actualizar" : "crear" %>">
            <% if (usuarioEditar != null) { %>
                <input type="hidden" name="id" value="<%= usuarioEditar.getId() %>">
            <% } %>

            <label>Documento</label>
            <input type="text" name="documento" required
                value="<%= usuarioEditar != null ? usuarioEditar.getCedula() : "" %>">

            <label>Nombres</label>
            <input type="text" name="nombres" required
                value="<%= usuarioEditar != null ? usuarioEditar.getNombres() : "" %>">

            <label>Apellidos</label>
            <input type="text" name="apellidos" required
                value="<%= usuarioEditar != null ? usuarioEditar.getApellidos() : "" %>">

            <label>Email</label>
            <input type="email" name="email" required
                value="<%= usuarioEditar != null ? usuarioEditar.getEmail() : "" %>">

            <label>Teléfono</label>
            <input type="text" name="telefono"
                value="<%= usuarioEditar != null ? usuarioEditar.getTelefono() : "" %>">

            <label>Rol</label>
            <%
                String rolActual = usuarioEditar != null ? usuarioEditar.getRol().toDb() : "";
            %>
            <select name="rol">
                <option value="lector"        <%= "lector".equals(rolActual)        ? "selected" : "" %>>lector</option>
                <option value="bibliotecario" <%= "bibliotecario".equals(rolActual) ? "selected" : "" %>>bibliotecario</option>
                <option value="admin"         <%= "admin".equals(rolActual)         ? "selected" : "" %>>admin</option>
            </select>

            <label>Estado</label>
            <%
                String estadoActual = usuarioEditar != null ? usuarioEditar.getEstado().toDb() : "";
            %>
            <select name="estado">
                <option value="activo"      <%= "activo".equals(estadoActual)      ? "selected" : "" %>>activo</option>
                <option value="inactivo"    <%= "inactivo".equals(estadoActual)    ? "selected" : "" %>>inactivo</option>
                <option value="suspendido"  <%= "suspendido".equals(estadoActual)  ? "selected" : "" %>>suspendido</option>
            </select>

            <br><br>
            <button type="submit"><%= usuarioEditar != null ? "Actualizar" : "Guardar" %></button>
            <% if (usuarioEditar != null) { %>
                <a href="<%= request.getContextPath() %>/dashboard?action=listar">Cancelar</a>
            <% } %>
        </form>
    </div>

    <!-- Listado de usuarios -->
    <h2>Usuarios registrados</h2>
    <% if (usuarios == null || usuarios.isEmpty()) { %>
        <p>No hay usuarios registrados.</p>
    <% } else { %>
    <table>
        <tr>
            <th>ID</th><th>Documento</th><th>Nombres</th><th>Apellidos</th>
            <th>Email</th><th>Rol</th><th>Estado</th><th>Acciones</th>
        </tr>
        <% for (Usuario u : usuarios) { %>
        <tr>
            <td><%= u.getId() %></td>
            <td><%= u.getCedula() %></td>
            <td><%= u.getNombres() %></td>
            <td><%= u.getApellidos() %></td>
            <td><%= u.getEmail() %></td>
            <td><%= u.getRol() %></td>
            <td><%= u.getEstado() %></td>
            <td>
                <a href="<%= request.getContextPath() %>/dashboard?action=editar&id=<%= u.getId() %>">Editar</a> |
                <form class="inline" method="get" action="<%= request.getContextPath() %>/dashboard">
                    <input type="hidden" name="action" value="eliminar">
                    <input type="hidden" name="id" value="<%= u.getId() %>">
                    <button class="btn-peligro" type="submit"
                        onclick="return confirm('¿Eliminar usuario <%= u.getNombres() %>?')">Eliminar</button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>
    <% } %>

</div>
</body>
</html>
