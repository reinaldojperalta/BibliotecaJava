<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>ARS Biblioteca | Archivo Central</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;700;800&family=JetBrains+Mono&display=swap" rel="stylesheet">
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/libs/bootstrap/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>
<body>

    <jsp:include page="/WEB-INF/includes/matrix-bg.jsp" />

    <jsp:include page="/WEB-INF/views/nav.jsp" />

<main class="container vh-100 d-flex align-items-end justify-content-start pb-5 ps-5" style="position: relative; z-index: 10;">
    <div class="text-start"> <h1 class="display-1 fw-bolder mb-3 glow-text" style="letter-spacing: -2px;">ARS BIBLIOTECA<span class="text-gold">.</span></h1>
        <p class="lead text-light mb-0 font-mono opacity-75">
            Custodiando el conocimiento. Administra libros, préstamos y registros<br>con precisión absoluta.
        </p>
    </div>
</main>

    <section class="py-5" style="background: rgba(15,15,15,0.9); border-top: 1px solid var(--studiova-gray); position: relative; z-index: 10;">
        <div class="container py-5">
            <div class="row align-items-center">
                
                <div class="col-lg-5 mb-5 mb-lg-0">
                    <span class="text-gold font-mono mb-2 d-block">CATÁLOGO ACTIVO</span>
                    <h2 class="display-5 fw-bold mb-4">Conocimiento estructurado y a tu alcance.</h2>
                    <p class="text-secondary mb-5">
                        Explora nuestra vasta colección de archivos. Solicita tomos, revisa tu historial de vinculación y gestiona los plazos desde tu terminal personal.
                    </p>
                    <a href="<%= request.getContextPath() %>/libros" class="btn btn-gold px-4 py-3 rounded-pill d-inline-flex align-items-center gap-2 glow-box">
                        Solicitar Préstamo <iconify-icon icon="solar:arrow-right-up-linear"></iconify-icon>
                    </a>
                </div>

                <div class="col-lg-6 offset-lg-1">
                    <div class="row g-4 text-center text-lg-start">
                        <div class="col-sm-6">
                            <h3 class="stat-number">1,204</h3>
                            <p class="text-gray-metal font-mono mt-2">Volúmenes Indexados</p>
                        </div>
                        <div class="col-sm-6">
                            <h3 class="stat-number text-gold glow-text">145</h3>
                            <p class="text-gray-metal font-mono mt-2">Vínculos (Préstamos)</p>
                        </div>
                        <div class="col-sm-6 mt-lg-5">
                            <h3 class="stat-number">380</h3>
                            <p class="text-gray-metal font-mono mt-2">Buscadores de Verdad</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer class="glass-footer" style="position: relative; z-index: 10;">
        <div class="container">
            <div class="row g-5">
                <div class="col-lg-5">
                    <h2 class="fw-bold mb-4">¿Buscas un<br>conocimiento específico?</h2>
                    <div class="d-flex flex-column gap-3 font-mono">
                        <a href="#" class="text-gold text-decoration-none d-flex align-items-center gap-2">
                            <iconify-icon icon="solar:letter-bold-duotone"></iconify-icon> archivos@arsbiblioteca.sena.edu.co
                        </a>
                        <a href="#" class="text-white text-decoration-none d-flex align-items-center gap-2 opacity-75">
                            <iconify-icon icon="solar:map-point-bold-duotone"></iconify-icon> Sede Central ADSO
                        </a>
                    </div>
                </div>

                <div class="col-lg-4">
                    <h5 class="text-gray-metal font-mono mb-4">SOBRE EL SISTEMA</h5>
                    <p class="text-secondary small" style="line-height: 1.8;">
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit.
                    </p>
                </div>

                <div class="col-lg-3">
                    <h5 class="text-gray-metal font-mono mb-4">ENLACES RÁPIDOS</h5>
                    <ul class="list-unstyled d-flex flex-column gap-3 small">
                        <li><a href="<%= request.getContextPath() %>/libros" class="text-white text-decoration-none hover-gold">Catálogo Completo</a></li>
                        <li><a href="<%= request.getContextPath() %>/prestamos" class="text-white text-decoration-none hover-gold">Normativa de Préstamos</a></li>
                        <li><a href="<%= request.getContextPath() %>/login" class="text-white text-decoration-none hover-gold">Portal de Ingreso</a></li>
                    </ul>
                </div>
            </div>

            <div class="border-top border-secondary mt-5 pt-4 d-flex flex-column flex-md-row justify-content-between align-items-center">
                <span class="text-secondary small">Diseñado para SENA ADSO - 2026</span>
                <span class="text-secondary small font-mono">© ARS Biblioteca Copyright 2026</span>
            </div>
        </div>
    </footer>

    <script src="<%= request.getContextPath() %>/assets/libs/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>