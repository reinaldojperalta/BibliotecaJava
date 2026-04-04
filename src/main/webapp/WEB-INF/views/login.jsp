<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Biblioteca</title>
    <style>
        body { font-family: sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; background: #f0f0f0; }
        .caja { background: white; padding: 2rem; border: 1px solid #ccc; width: 300px; }
        h2 { margin-top: 0; }
        input { width: 100%; padding: 8px; margin: 6px 0 12px; box-sizing: border-box; }
        button { width: 100%; padding: 8px; background: #333; color: white; border: none; cursor: pointer; }
        .error { color: red; font-size: 0.9rem; }
    </style>
</head>
<body>
<div class="caja">
    <h2>Biblioteca SENA</h2>

    <% if (request.getParameter("error") != null) { %>
        <p class="error">${error}</p>
    <% } %>

    <form method="post" action="<%= request.getContextPath() %>/login">
        <label>Email</label>
        <input type="email" name="email" required autofocus>

        <label>Contraseña</label>
        <input type="password" name="password" required>

        <button type="submit">Ingresar</button>
    </form>
</div>
</body>
</html>
