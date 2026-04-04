<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Matrix 3D - Sistema MVC</title>
    
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Hebrew:wght@400;700&display=swap" rel="stylesheet">
    
    <style>
        /* Solo estilos para el contenido, el fondo lo maneja el include */
        body { background-color: #000; margin: 0; overflow: hidden; }
        
        .content-layer {
            position: relative;
            z-index: 20; /* Por encima del fondo matrix */
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>
</head>
<body>

    <%-- Asegúrate de que la ruta coincida con donde guardaste el archivo --%>
    <jsp:include page="/WEB-INF/includes/matrix-bg.jsp" />

    <div class="content-layer">
        <div class="text-center p-10 bg-black/60 backdrop-blur-md rounded-3xl border border-yellow-500/30 shadow-[0_0_20px_rgba(255,215,0,0.1)]">
            <h1 class="text-6xl font-black mb-4 text-transparent bg-clip-text bg-gradient-to-b from-yellow-100 via-yellow-400 to-yellow-700 tracking-tighter">
                SISTEMA MVC
            </h1>
            <p class="text-yellow-500/70 font-mono text-sm tracking-[0.2em] uppercase">
                Bienvenido a la red ADSO
            </p>
        </div>
    </div>

</body>
</html>