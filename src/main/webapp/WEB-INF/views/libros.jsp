<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="sena.adso.model.Libro" %>
<%@ page import="sena.adso.model.Editorial" %>
<%@ page import="sena.adso.model.Categoria" %>
<%@ page import="sena.adso.model.Usuario" %>

<%@ page import="sena.adso.model.enums.EstadoLibro" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuarioLibros = (Usuario) session.getAttribute("usuarioActivo");
    String rolLibrosStr = usuarioLibros.getRol().toDb();
    boolean esEditor = "admin".equals(rolLibrosStr) || "bibliotecario".equals(rolLibrosStr);

    List<Libro>     libros      = (List<Libro>)     request.getAttribute("libros");
    List<Editorial> editoriales = (List<Editorial>) request.getAttribute("editoriales");
    List<Categoria> categorias  = (List<Categoria>) request.getAttribute("categorias");
    Libro           libroEditar = (Libro)            request.getAttribute("libro");   // solo en modo editar
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Libros - Biblioteca</title>
    <style>
        body { font-family: sans-serif; margin: 0; }
        .contenido { padding: 20px; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 30px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f0f0f0; }
        h2 { border-bottom: 2px solid #333; padding-bottom: 6px; }
        form.inline { display: inline; }
        input, select { padding: 6px; margin: 4px 0; width: 100%; box-sizing: border-box; }
        button, .btn { padding: 6px 12px; cursor: pointer; }
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

    <!-- Formulario CREAR / EDITAR (solo admin y bibliotecario) -->
    <% if (esEditor) { %>
    <div class="formulario">
        <h3><%= libroEditar != null ? "Editar libro" : "Nuevo libro" %></h3>
        <form method="post" action="<%= request.getContextPath() %>/libros">
            <input type="hidden" name="action" value="<%= libroEditar != null ? "actualizar" : "crear" %>">
            <% if (libroEditar != null) { %>
                <input type="hidden" name="id" value="<%= libroEditar.getId() %>">
            <% } %>

            <label>Título</label>
            <input type="text" name="titulo" required value="<%= libroEditar != null ? libroEditar.getTitulo() : "" %>">

            <label>ISBN</label>
            <input type="text" name="isbn" value="<%= libroEditar != null ? libroEditar.getIsbn() : "" %>">

            <label>Año publicación</label>
            <input type="number" name="anioPublicacion" value="<%= libroEditar != null ? libroEditar.getAnioPublicacion() : "" %>">

            <label>Núm. páginas</label>
            <input type="number" name="numPaginas" value="<%= libroEditar != null ? libroEditar.getNumPaginas() : "" %>">

            <label>Editorial</label>
            <select name="idEditorial">
                <% if (editoriales != null) for (Editorial e : editoriales) { %>
                    <option value="<%= e.getId() %>"
                        <%= libroEditar != null && libroEditar.getIdEditorial() == e.getId() ? "selected" : "" %>>
                        <%= e.getNombre() %>
                    </option>
                <% } %>
            </select>

            <label>Categoría</label>
            <select name="idCategoria">
                <% if (categorias != null) for (Categoria c : categorias) { %>
                    <option value="<%= c.getId() %>"
                        <%= libroEditar != null && libroEditar.getIdCategoria() == c.getId() ? "selected" : "" %>>
                        <%= c.getNombre() %>
                    </option>
                <% } %>
            </select>

            <label>Estado</label>
            <%
                String estadoLibroActual = libroEditar != null ? libroEditar.getEstado().toDb() : "disponible";
            %>
            <select name="estado">
                <option value="disponible"   <%= "disponible".equals(estadoLibroActual)   ? "selected" : "" %>>disponible</option>
                <option value="prestado"     <%= "prestado".equals(estadoLibroActual)     ? "selected" : "" %>>prestado</option>
                <option value="mantenimiento"<%= "mantenimiento".equals(estadoLibroActual)? "selected" : "" %>>mantenimiento</option>
                <option value="dado_de_baja" <%= "dado_de_baja".equals(estadoLibroActual) ? "selected" : "" %>>dado_de_baja</option>
            </select>

            <br><br>
            <button type="submit"><%= libroEditar != null ? "Actualizar" : "Guardar" %></button>
            <% if (libroEditar != null) { %>
                <a href="<%= request.getContextPath() %>/libros?action=listar">Cancelar</a>
            <% } %>
        </form>
    </div>
    <% } %>

    <!-- Listado de libros -->
    <h2>Libros</h2>
    <% if (libros == null || libros.isEmpty()) { %>
        <p>No hay libros registrados.</p>
    <% } else { %>
    <table>
        <tr>
            <th>ID</th><th>Título</th><th>ISBN</th><th>Año</th>
            <th>Estado</th><th>Acciones</th>
        </tr>
        <% for (Libro l : libros) { %>
        <tr>
            <td><%= l.getId() %></td>
            <td><%= l.getTitulo() %></td>
            <td><%= l.getIsbn() %></td>
            <td><%= l.getAnioPublicacion() %></td>
            <td><%= l.getEstado() %></td>
            <td>
                <% if (esEditor) { %>
                    <a href="<%= request.getContextPath() %>/libros?action=editar&id=<%= l.getId() %>">Editar</a> |
                    <form class="inline" method="get" action="<%= request.getContextPath() %>/libros">
                        <input type="hidden" name="action" value="eliminar">
                        <input type="hidden" name="id" value="<%= l.getId() %>">
                        <button class="btn-peligro" type="submit"
                            onclick="return confirm('¿Eliminar este libro?')">Eliminar</button>
                    </form>
                <% } %>
                <% if ("lector".equals(rolLibrosStr) && "disponible".equals(l.getEstado().toDb())) { %>
                    <form class="inline" method="post" action="<%= request.getContextPath() %>/libros">
                        <input type="hidden" name="action"  value="asignar">
                        <input type="hidden" name="idLibro" value="<%= l.getId() %>">
                        <button type="submit">Tomar prestado</button>
                    </form>
                <% } %>
            </td>
        </tr>
        <% } %>
    </table>
    <% } %>

</div>
</body>
</html>
