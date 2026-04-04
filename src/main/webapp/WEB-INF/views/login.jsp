<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SENA | StudioVA Login</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;700&family=Noto+Sans+Hebrew:wght@400;700&family=JetBrains+Mono&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <jsp:include page="/WEB-INF/includes/matrix-bg.jsp" />

    <main class="studiova-wrapper">
        <div class="login-card">
            
            <div class="card-glow"></div>

            <header class="form-header">
                <div class="logo-area">
                    <span class="symbol">✧</span>
                    <h1>BIBLIOTECA</h1>
                    <span class="sub-title">SISTEMA ADSO 2026</span>
                </div>
            </header>

            <% if (request.getParameter("error") != null) { %>
                <div class="error-toast">
                    <span class="icon">!</span> ACCESO DENEGADO
                </div>
            <% } %>

            <form class="studiova-form" method="post" action="${pageContext.request.contextPath}/login">
                
                <div class="input-group">
                    <label>IDENTIFICADOR DE RED</label>
                    <div class="input-wrapper">
                        <input type="email" name="email" placeholder="usuario@sena.edu.co" required autofocus>
                        <div class="input-line"></div>
                    </div>
                </div>

                <div class="input-group">
                    <label>CLAVE DE ACCESO</label>
                    <div class="input-wrapper">
                        <input type="password" name="password" placeholder="••••••••" required>
                        <div class="input-line"></div>
                    </div>
                </div>

                <button type="submit" class="btn-studiova">
                    <span class="btn-text">INICIAR SESIÓN</span>
                    <div class="btn-shimmer"></div>
                </button>
                
            </form>

            <footer class="card-footer">
                
            </div>
        </div>
    </main>

</body>
</html>