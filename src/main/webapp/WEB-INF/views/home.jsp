<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="sena.adso.model.Libro" %>
<%@ page import="sena.adso.model.Usuario" %>
<%@ page import="java.util.List" %>

<%
    // Datos del servlet (con valores por defecto si vienen vacíos)
    Integer totalLibros = (Integer) request.getAttribute("totalLibros");
    Integer totalPrestamos = (Integer) request.getAttribute("totalPrestamos");
    Integer totalUsuarios = (Integer) request.getAttribute("totalUsuarios");
    Double totalMultas = (Double) request.getAttribute("totalMultas");
    List<Libro> librosDestacados = (List<Libro>) request.getAttribute("librosDestacados");
    
    if (totalLibros == null) totalLibros = 0;
    if (totalPrestamos == null) totalPrestamos = 0;
    if (totalUsuarios == null) totalUsuarios = 0;
    if (totalMultas == null) totalMultas = 0.0;
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ARS Biblioteca | Archivo Central</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;600;700;800;900&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet">
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- AOS Animation Library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <!-- Iconify -->
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    
    <style>
        :root {
            --gold: #c9b037;
            --gold-bright: #ffd700;
            --dark-bg: #0a0a0a;
            --glass-bg: rgba(255, 255, 255, 0.03);
            --glass-border: rgba(201, 176, 55, 0.2);
        }
        
        body {
            background: var(--dark-bg);
            color: #fff;
            font-family: 'Inter', sans-serif;
            overflow-x: hidden;
        }
        
        /* HERO SECTION MEJORADO */
        .hero-section {
            min-height: 100vh;
            position: relative;
            display: flex;
            align-items: flex-end;
            padding-bottom: 5rem;
            z-index: 10;
        }
        
        .hero-title {
            font-family: 'Montserrat', sans-serif;
            font-weight: 900;
            font-size: clamp(3rem, 10vw, 8rem);
            line-height: 0.9;
            letter-spacing: -0.05em;
            background: linear-gradient(135deg, #fff 0%, var(--gold) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            position: relative;
        }
        
        .hero-title::after {
            content: 'ARS BIBLIOTECA';
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, transparent 0%, rgba(201, 176, 55, 0.3) 50%, transparent 100%);
            -webkit-background-clip: text;
            filter: blur(20px);
            opacity: 0;
            animation: glowPulse 3s ease-in-out infinite;
        }
        
        @keyframes glowPulse {
            0%, 100% { opacity: 0; }
            50% { opacity: 0.5; }
        }
        
        .hero-subtitle {
            font-family: 'JetBrains Mono', monospace;
            font-size: 1.1rem;
            color: rgba(255,255,255,0.7);
            border-left: 3px solid var(--gold);
            padding-left: 1.5rem;
            margin-top: 2rem;
        }
        
        .scroll-indicator {
            position: absolute;
            bottom: 2rem;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.5rem;
            color: var(--gold);
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.8rem;
            animation: bounce 2s infinite;
            cursor: pointer;
        }
        
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateX(-50%) translateY(0); }
            40% { transform: translateX(-50%) translateY(-10px); }
            60% { transform: translateX(-50%) translateY(-5px); }
        }
        
        /* STATS COUNTER SECTION */
        .stats-section {
            background: linear-gradient(180deg, rgba(10,10,10,0) 0%, rgba(201, 176, 55, 0.05) 50%, rgba(10,10,10,0) 100%);
            padding: 6rem 0;
            position: relative;
            overflow: hidden;
        }
        
        .stats-section::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            width: 100%;
            height: 1px;
            background: linear-gradient(90deg, transparent, var(--gold), transparent);
            opacity: 0.3;
        }
        
        .stat-card {
            text-align: center;
            padding: 2rem;
            position: relative;
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .stat-card:hover {
            transform: translateY(-10px);
            border-color: var(--gold);
            box-shadow: 0 20px 40px rgba(201, 176, 55, 0.2);
        }
        
        .stat-icon {
            font-size: 2.5rem;
            color: var(--gold);
            margin-bottom: 1rem;
            display: inline-block;
        }
        
        .stat-number {
            font-family: 'Montserrat', sans-serif;
            font-size: 3.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, #fff, var(--gold));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            line-height: 1;
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.9rem;
            color: rgba(255,255,255,0.6);
            text-transform: uppercase;
            letter-spacing: 2px;
        }
        
        /* FEATURES SECTION - GLASS CARDS */
        .features-section {
            padding: 6rem 0;
            position: relative;
        }
        
        .section-header {
            text-align: center;
            margin-bottom: 4rem;
        }
        
        .section-tag {
            font-family: 'JetBrains Mono', monospace;
            color: var(--gold);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 3px;
            display: block;
            margin-bottom: 1rem;
        }
        
        .section-title {
            font-family: 'Montserrat', sans-serif;
            font-size: 3rem;
            font-weight: 800;
            margin-bottom: 1.5rem;
        }
        
        .feature-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 24px;
            padding: 3rem 2rem;
            height: 100%;
            position: relative;
            overflow: hidden;
            transition: all 0.4s ease;
        }
        
        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(201, 176, 55, 0.1), transparent);
            transition: left 0.5s;
        }
        
        .feature-card:hover::before {
            left: 100%;
        }
        
        .feature-card:hover {
            border-color: var(--gold);
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0,0,0,0.4);
        }
        
        .feature-icon-wrapper {
            width: 80px;
            height: 80px;
            background: rgba(201, 176, 55, 0.1);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 2rem;
            font-size: 2.5rem;
            color: var(--gold);
            transition: all 0.3s ease;
        }
        
        .feature-card:hover .feature-icon-wrapper {
            background: var(--gold);
            color: #000;
            transform: rotateY(360deg);
        }
        
        .feature-title {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        
        .feature-text {
            color: rgba(255,255,255,0.7);
            line-height: 1.8;
        }
        
        /* LIBROS DESTACADOS - GRID */
        .books-section {
            padding: 6rem 0;
            background: radial-gradient(circle at center, rgba(201, 176, 55, 0.05) 0%, transparent 70%);
        }
        
        .book-card {
            position: relative;
            border-radius: 16px;
            overflow: hidden;
            aspect-ratio: 2/3;
            background: var(--glass-bg);
            border: 1px solid rgba(255,255,255,0.1);
            transition: all 0.4s ease;
        }
        
        .book-card:hover {
            transform: translateY(-10px) scale(1.02);
            border-color: var(--gold);
            box-shadow: 0 30px 60px rgba(201, 176, 55, 0.2);
        }
        
        .book-cover {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }
        
        .book-card:hover .book-cover {
            transform: scale(1.1);
        }
        
        .book-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(to top, rgba(0,0,0,0.9), transparent);
            padding: 2rem 1.5rem 1.5rem;
            transform: translateY(100%);
            transition: transform 0.4s ease;
        }
        
        .book-card:hover .book-overlay {
            transform: translateY(0);
        }
        
        .book-title {
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
            color: #fff;
        }
        
        .book-author {
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.85rem;
            color: var(--gold);
        }
        
        /* CTA SECTION */
        .cta-section {
            padding: 8rem 0;
            position: relative;
            overflow: hidden;
        }
        
        .cta-glow {
            position: absolute;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(201, 176, 55, 0.3) 0%, transparent 70%);
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            pointer-events: none;
            animation: pulseGlow 4s ease-in-out infinite;
        }
        
        @keyframes pulseGlow {
            0%, 100% { transform: translate(-50%, -50%) scale(1); opacity: 0.5; }
            50% { transform: translate(-50%, -50%) scale(1.2); opacity: 0.8; }
        }
        
        .cta-content {
            text-align: center;
            position: relative;
            z-index: 2;
        }
        
        .cta-title {
            font-family: 'Montserrat', sans-serif;
            font-size: 4rem;
            font-weight: 900;
            margin-bottom: 2rem;
            line-height: 1.1;
        }
        
        .btn-gold-large {
            display: inline-flex;
            align-items: center;
            gap: 1rem;
            background: linear-gradient(135deg, var(--gold), #a88b20);
            color: #000;
            padding: 1.2rem 3rem;
            border-radius: 50px;
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
            text-decoration: none;
            font-size: 1.1rem;
            border: 2px solid transparent;
            transition: all 0.3s ease;
            box-shadow: 0 10px 30px rgba(201, 176, 55, 0.3);
        }
        
        .btn-gold-large:hover {
            background: transparent;
            color: var(--gold);
            border-color: var(--gold);
            transform: translateY(-3px);
            box-shadow: 0 20px 40px rgba(201, 176, 55, 0.4);
        }
        
        /* FOOTER MEJORADO */
        .footer-section {
            background: rgba(0,0,0,0.8);
            backdrop-filter: blur(20px);
            border-top: 1px solid var(--glass-border);
            padding: 5rem 0 2rem;
            position: relative;
        }
        
        .footer-brand {
            font-family: 'Montserrat', sans-serif;
            font-size: 2rem;
            font-weight: 800;
            color: var(--gold);
            margin-bottom: 1rem;
            display: inline-block;
        }
        
        .social-links {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }
        
        .social-link {
            width: 50px;
            height: 50px;
            border: 1px solid var(--glass-border);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 1.5rem;
            transition: all 0.3s ease;
            text-decoration: none;
        }
        
        .social-link:hover {
            background: var(--gold);
            color: #000;
            border-color: var(--gold);
            transform: translateY(-5px) rotate(360deg);
        }
        
        .footer-title {
            font-family: 'JetBrains Mono', monospace;
            color: var(--gold);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 2px;
            margin-bottom: 1.5rem;
        }
        
        .footer-links {
            list-style: none;
            padding: 0;
        }
        
        .footer-links li {
            margin-bottom: 0.8rem;
        }
        
        .footer-links a {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .footer-links a:hover {
            color: var(--gold);
            transform: translateX(5px);
        }
        
        .footer-bottom {
            border-top: 1px solid rgba(255,255,255,0.1);
            margin-top: 4rem;
            padding-top: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        /* DECORATIVE ELEMENTS */
        .floating-shapes {
            position: fixed;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            pointer-events: none;
            z-index: 0;
            overflow: hidden;
        }
        
        .shape {
            position: absolute;
            border: 1px solid rgba(201, 176, 55, 0.1);
            border-radius: 50%;
        }
        
        .shape-1 {
            width: 300px;
            height: 300px;
            top: 10%;
            right: -100px;
            animation: float 20s infinite ease-in-out;
        }
        
        .shape-2 {
            width: 200px;
            height: 200px;
            bottom: 20%;
            left: -50px;
            animation: float 15s infinite ease-in-out reverse;
        }
        
        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            33% { transform: translate(30px, -30px) rotate(120deg); }
            66% { transform: translate(-20px, 20px) rotate(240deg); }
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/matrix-bg.jsp" />
    

    <!-- SHAPES DECORATIVAS -->
    <div class="floating-shapes">
        <div class="shape shape-1"></div>
        <div class="shape shape-2"></div>
    </div>

    

    <!-- HERO SECTION -->
    <section class="hero-section container">
        <div class="row w-100">
            <div class="col-lg-8" data-aos="fade-up" data-aos-duration="1000">
                <h1 class="hero-title mb-4">
                    ARS<br>BIBLIOTECA<span style="color: var(--gold);">.</span>
                </h1>
                <p class="hero-subtitle">
                    Sistema de Gestión Documental Inteligente.<br>
                    Custodiando el conocimiento con precisión absoluta desde 2024.
                </p>
                <div class="mt-5 d-flex gap-3 flex-wrap">
                    <a href="<%= request.getContextPath() %>/libros" class="btn-gold-large" style="padding: 1rem 2rem; font-size: 1rem;">
                        Explorar Catálogo
                        <iconify-icon icon="solar:arrow-right-bold"></iconify-icon>
                    </a>
                    
                    <!-- REEMPLAZA ESTA PARTE -->
                    <% 
                        Usuario usuarioActivo  = (Usuario) session.getAttribute("usuarioActivo");
                        if (usuarioActivo  == null) { 
                    %>
                        <a href="<%= request.getContextPath() %>/login" class="btn-gold-large" style="background: transparent; color: var(--gold); border: 2px solid var(--gold); padding: 1rem 2rem; font-size: 1rem;">
                            Acceder al Sistema
                        </a>
                    <% 
                        } else { 
                    %>
                        <a href="<%= request.getContextPath() %>/logout" class="btn-gold-large" style="background: transparent; color: #ff4d4d; border: 2px solid #ff4d4d; padding: 1rem 2rem; font-size: 1rem;">
                            Cerrar Sesión
                        </a>
                    <% 
                        } 
                    %>
                </div>
            </div>
        </div>
        
        <div class="scroll-indicator" onclick="document.getElementById('stats').scrollIntoView({behavior: 'smooth'})">
            <span>SCROLL</span>
            <iconify-icon icon="solar:arrow-down-bold" style="font-size: 1.5rem;"></iconify-icon>
        </div>
    </section>

    <!-- STATS SECTION -->
    <section id="stats" class="stats-section">
        <div class="container">
            <div class="row g-4 justify-content-center">
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="0">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <iconify-icon icon="solar:book-bookmark-bold"></iconify-icon>
                        </div>
                        <div class="stat-number" data-count="<%= totalLibros %>">0</div>
                        <div class="stat-label">Volúmenes Únicos</div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <iconify-icon icon="solar:clock-circle-bold"></iconify-icon>
                        </div>
                        <div class="stat-number" data-count="<%= totalPrestamos %>">0</div>
                        <div class="stat-label">Préstamos Activos</div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <iconify-icon icon="solar:users-group-rounded-bold"></iconify-icon>
                        </div>
                        <div class="stat-number" data-count="<%= totalUsuarios %>">0</div>
                        <div class="stat-label">Investigadores</div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- FEATURES SECTION -->
    <section class="features-section">
        <div class="container">
            <div class="section-header" data-aos="fade-up">
                <span class="section-tag">/// Funcionalidades</span>
                <h2 class="section-title">Un sistema diseñado para<br>la excelencia documental</h2>
            </div>
            
            <div class="row g-4">
                <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="0">
                    <div class="feature-card">
                        <div class="feature-icon-wrapper">
                            <iconify-icon icon="solar:search-bold"></iconify-icon>
                        </div>
                        <h3 class="feature-title">Búsqueda Avanzada</h3>
                        <p class="feature-text">
                            Sistema de indexación inteligente que permite localizar volúmenes por título, autor, ISBN o categoría en milisegundos.
                        </p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="feature-card">
                        <div class="feature-icon-wrapper">
                            <iconify-icon icon="solar:calendar-bold"></iconify-icon>
                        </div>
                        <h3 class="feature-title">Gestión Temporal</h3>
                        <p class="feature-text">
                            Control automático de plazos, renovaciones y devoluciones con alertas inteligentes de vencimiento.
                        </p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="feature-card">
                        <div class="feature-icon-wrapper">
                            <iconify-icon icon="solar:shield-check-bold"></iconify-icon>
                        </div>
                        <h3 class="feature-title">Roles Seguros</h3>
                        <p class="feature-text">
                            Sistema de permisos granular: Administradores, Bibliotecarios y Lectores con accesos diferenciados.
                        </p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="300">
                    <div class="feature-card">
                        <div class="feature-icon-wrapper">
                            <iconify-icon icon="solar:chart-2-bold"></iconify-icon>
                        </div>
                        <h3 class="feature-title">Analytics en Tiempo Real</h3>
                        <p class="feature-text">
                            Dashboards dinámicos con estadísticas de uso, préstamos activos y estado de la colección.
                        </p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="400">
                    <div class="feature-card">
                        <div class="feature-icon-wrapper">
                            <iconify-icon icon="solar:bill-list-bold"></iconify-icon>
                        </div>
                        <h3 class="feature-title">Gestión de Multas</h3>
                        <p class="feature-text">
                            Cálculo automático de sanciones por mora, historial de pagos y sistema de exoneraciones.
                        </p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="500">
                    <div class="feature-card">
                        <div class="feature-icon-wrapper">
                            <iconify-icon icon="solar:code-scan-bold"></iconify-icon>
                        </div>
                        <h3 class="feature-title">Tracking Digital</h3>
                        <p class="feature-text">
                            Cada volumen tiene identificador único con historial completo de movimientos y estados.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- LIBROS DESTACADOS -->
    <section class="books-section">
        <div class="container">
            <div class="section-header" data-aos="fade-up">
                <span class="section-tag">/// Adquisiciones Recientes</span>
                <h2 class="section-title">Nuevos volúmenes en el archivo</h2>
            </div>
            
            <div class="row g-4">
                <% if (librosDestacados != null && !librosDestacados.isEmpty()) {
                    for (int i = 0; i < librosDestacados.size() && i < 6; i++) {
                        Libro libro = librosDestacados.get(i);
                %>
                <div class="col-6 col-md-4 col-lg-2" data-aos="fade-up" data-aos-delay="<%= i * 100 %>">
                    <div class="book-card">
                        <!-- Placeholder para portada - reemplazar con imagen real si existe -->
                        <div class="book-cover" style="background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%); display: flex; align-items: center; justify-content: center;">
                            <iconify-icon icon="solar:book-bold" style="font-size: 3rem; color: var(--gold); opacity: 0.5;"></iconify-icon>
                        </div>
                        <div class="book-overlay">
                            <div class="book-title"><%= libro.getTitulo() %></div>
                            <div class="book-author"><%= libro.getAnioPublicacion() %></div>
                        </div>
                    </div>
                </div>
                <% } } else { %>
                <div class="col-12 text-center" data-aos="fade-up">
                    <p class="text-muted">No hay libros recientes para mostrar.</p>
                </div>
                <% } %>
            </div>
            
            <div class="text-center mt-5" data-aos="fade-up">
                <a href="<%= request.getContextPath() %>/libros" class="btn-gold-large" style="padding: 0.8rem 2rem; font-size: 0.9rem;">
                    Ver Catálogo Completo
                    <iconify-icon icon="solar:arrow-right-bold"></iconify-icon>
                </a>
            </div>
        </div>
    </section>

    <!-- CTA SECTION -->
    <section class="cta-section">
        <div class="cta-glow"></div>
        <div class="container">
            <div class="cta-content" data-aos="zoom-in">
                <h2 class="cta-title">¿Listo para comenzar<br>tu investigación?</h2>
                <p class="lead text-secondary mb-5" style="max-width: 600px; margin: 0 auto 3rem;">
                    Accede al sistema con tus credenciales y explora nuestro universo documental. 
                    Más de <%= totalLibros %> volúmenes te esperan.
                </p>
                <div>
                                    <% 
                        
                        if (usuarioActivo  == null) { 
                    %>
                        <a href="<%= request.getContextPath() %>/login" class="btn-gold-large" style="background: transparent; color: var(--gold); border: 2px solid var(--gold); padding: 1rem 2rem; font-size: 1rem;">
                            Acceder al Sistema
                            <iconify-icon icon="solar:login-3-bold"></iconify-icon>
                        </a>
                    <% 
                        } else { 
                    %>
                        <a href="<%= request.getContextPath() %>/logout" class="btn-gold-large" style="background: transparent; color: #ff4d4d; border: 2px solid #ff4d4d; padding: 1rem 2rem; font-size: 1rem;">
                            Cerrar Sesión
                        </a>
                    <% 
                        } 
                    %>
                
                </div>
            </div>
        </div>
    </section>
    
    <!-- FOOTER -->
    <footer class="footer-section">
        <div class="container">
            <div class="row g-5">
                <div class="col-lg-4">
                    <span class="footer-brand">ARS<span style="color: #fff;">.</span></span>
                    <p class="text-secondary mb-4" style="line-height: 1.8;">
                        Sistema integral de gestión bibliotecaria desarrollado para el SENA ADSO. 
                        Precisión, elegancia y control documental.
                    </p>
                    <div class="social-links">
                        <a href="#" class="social-link"><iconify-icon icon="solar:letter-bold"></iconify-icon></a>
                        <a href="#" class="social-link"><iconify-icon icon="solar:phone-bold"></iconify-icon></a>
                        <a href="#" class="social-link"><iconify-icon icon="solar:map-point-bold"></iconify-icon></a>
                    </div>
                </div>
                
                <div class="col-lg-2 col-md-4">
                    <h4 class="footer-title">Navegación</h4>
                    <ul class="footer-links">
                        <li><a href="<%= request.getContextPath() %>/home">Inicio</a></li>
                        <li><a href="<%= request.getContextPath() %>/libros">Catálogo</a></li>
                        <li><a href="<%= request.getContextPath() %>/prestamos">Préstamos</a></li>
                        <li><a href="<%= request.getContextPath() %>/resumen">Dashboard</a></li>
                    </ul>
                </div>
                
                <div class="col-lg-2 col-md-4">
                    <h4 class="footer-title">Legal</h4>
                    <ul class="footer-links">
                        <li><a href="#">Términos de Uso</a></li>
                        <li><a href="#">Privacidad</a></li>
                        <li><a href="#">Normativa</a></li>
                    </ul>
                </div>
                
                <div class="col-lg-4 col-md-4">
                    <h4 class="footer-title">Contacto Directo</h4>
                    <ul class="footer-links">
                        <li>
                            <a href="mailto:archivos@arsbiblioteca.sena.edu.co">
                                <iconify-icon icon="solar:letter-bold"></iconify-icon>
                                archivos@arsbiblioteca.sena.edu.co
                            </a>
                        </li>
                        <li>
                            <a href="#">
                                <iconify-icon icon="solar:map-point-bold"></iconify-icon>
                                Sede Central ADSO - SENA
                            </a>
                        </li>
                        <li>
                            <a href="#">
                                <iconify-icon icon="solar:clock-circle-bold"></iconify-icon>
                                Lunes a Viernes: 7:00 - 19:00
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            
            <div class="footer-bottom">
                <span class="text-secondary small">Diseñado para SENA ADSO - 2026</span>
                <span class="text-secondary small font-mono">ARS Biblioteca © 2026 - Todos los derechos reservados</span>
            </div>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    
    <script>
        // Inicializar AOS (Animate On Scroll)
        AOS.init({
            duration: 800,
            once: true,
            mirror: false,
            offset: 100
        });
        
        // Contadores animados
        function animateCounters() {
            const counters = document.querySelectorAll('.stat-number[data-count]');
            
            counters.forEach(counter => {
                const target = parseInt(counter.getAttribute('data-count'));
                const duration = 2000;
                const increment = target / (duration / 16);
                let current = 0;
                
                const updateCounter = () => {
                    current += increment;
                    if (current < target) {
                        counter.innerText = Math.floor(current).toLocaleString();
                        requestAnimationFrame(updateCounter);
                    } else {
                        counter.innerText = target.toLocaleString();
                    }
                };
                
                // Intersection Observer para iniciar cuando sea visible
                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            updateCounter();
                            observer.unobserve(entry.target);
                        }
                    });
                });
                
                observer.observe(counter);
            });
        }
        
        // Iniciar contadores cuando el DOM esté listo
        document.addEventListener('DOMContentLoaded', animateCounters);
        
        // Efecto parallax suave en el hero
        window.addEventListener('scroll', () => {
            const scrolled = window.pageYOffset;
            const heroTitle = document.querySelector('.hero-title');
            if (heroTitle) {
                heroTitle.style.transform = `translateY(${scrolled * 0.3}px)`;
            }
        });
    </script>


<div id="ars-chat-widget" style="
    position: fixed;
    width: 60px;
    bottom: 30px;
    right: 30px;
    z-index: 9999;
    font-family: 'JetBrains Mono', monospace;
">

    <!-- Botón flotante -->
    <button id="ars-chat-btn" style="
        width: 60px;
        height: 60px;
        border-radius: 50%;
        background: rgba(201, 176, 55, 0.15);
        border: 2px solid #c9b037;
        color: #c9b037;
        cursor: pointer;
        transition: all 0.3s ease;
        backdrop-filter: blur(10px);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
        box-shadow: 0 4px 20px rgba(201, 176, 55, 0.3);
    ">&#128218;</button>

    <!-- Ventana de chat -->
    <div id="ars-chat-window" style="
        display: none;
        position: absolute;
        bottom: 75px;
        right: 0;
        width: 380px;
        height: 500px;
        background: rgba(10, 10, 10, 0.95);
        border: 1px solid rgba(201, 176, 55, 0.4);
        border-radius: 20px;
        backdrop-filter: blur(20px);
        box-shadow: 0 20px 50px rgba(0,0,0,0.9), 0 0 30px rgba(201, 176, 55, 0.1);
        flex-direction: column;
        overflow: hidden;
    ">

        <!-- Header -->
        <div id="ars-chat-header" style="
            padding: 1.2rem;
            background: rgba(201, 176, 55, 0.1);
            border-bottom: 1px solid rgba(201, 176, 55, 0.3);
            display: flex;
            justify-content: space-between;
            align-items: center;
        ">
            <div style="display: flex; align-items: center; gap: 0.8rem;">
                <div style="
                    width: 40px; height: 40px;
                    border-radius: 50%;
                    background: rgba(201, 176, 55, 0.2);
                    border: 2px solid #c9b037;
                    display: flex; align-items: center; justify-content: center;
                    font-size: 1.2rem;
                ">&#128564;</div>
                <div>
                    <div style="color: #c9b037; font-weight: 700; font-size: 0.95rem;">Don Archibaldo</div>
                    <div style="color: #666; font-size: 0.7rem;">Bibliotecario &middot; <span id="ars-status">durmiendo</span></div>
                </div>
            </div>
            <button id="ars-chat-close" style="
                background: none; border: none; color: #888;
                font-size: 1.5rem; cursor: pointer; padding: 0; width: 30px;
            ">&times;</button>
        </div>

        <!-- Area de mensajes -->
        <div id="ars-messages" style="
            flex: 1;
            overflow-y: auto;
            padding: 1.2rem;
            display: flex;
            flex-direction: column;
            gap: 1rem;
            background: rgba(0,0,0,0.3);
        ">
            <!-- Mensaje de bienvenida -->
            <div id="ars-welcome-msg" style="
                max-width: 85%;
                padding: 1rem;
                background: rgba(255,255,255,0.05);
                border: 1px solid rgba(255,255,255,0.1);
                border-radius: 15px 15px 15px 5px;
                color: #ccc;
                font-size: 0.9rem;
                line-height: 1.5;
                align-self: flex-start;
            "></div>
        </div>

        <!-- Input -->
        <div style="
            padding: 1rem;
            border-top: 1px solid rgba(201, 176, 55, 0.3);
            background: rgba(0,0,0,0.5);
            display: flex;
            gap: 0.5rem;
        ">
            <input type="text" id="ars-input" placeholder="Pregunta algo facil, por favor..." style="
                flex: 1;
                background: rgba(255,255,255,0.05);
                border: 1px solid rgba(201, 176, 55, 0.3);
                border-radius: 25px;
                padding: 0.8rem 1.2rem;
                color: #fff;
                font-family: inherit;
                font-size: 0.9rem;
                outline: none;
            ">
            <button id="ars-send-btn" style="
                width: 45px; height: 45px;
                border-radius: 50%;
                background: #c9b037;
                border: none;
                color: #000;
                cursor: pointer;
                display: flex; align-items: center; justify-content: center;
                font-size: 1.2rem;
                transition: all 0.3s;
            ">&#10148;</button>
        </div>

        <!-- Typing indicator -->
        <div id="ars-typing" style="
            display: none;
            padding: 0 1.2rem 0.5rem;
            color: #666;
            font-size: 0.8rem;
            font-style: italic;
        ">
            Don Archibaldo esta buscando en sus notas...
        </div>
    </div>
</div>

<!-- CHATBOT: CSS scoped -->
<style>
#ars-messages::-webkit-scrollbar { width: 6px; }
#ars-messages::-webkit-scrollbar-track { background: rgba(0,0,0,0.2); border-radius: 3px; }
#ars-messages::-webkit-scrollbar-thumb { background: rgba(201,176,55,0.3); border-radius: 3px; }
#ars-messages::-webkit-scrollbar-thumb:hover { background: rgba(201,176,55,0.5); }

@keyframes ars-fade-in {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}
.ars-msg-anim { animation: ars-fade-in 0.3s ease; }

#ars-chat-btn:hover {
    transform: scale(1.1) rotate(10deg);
    background: rgba(201,176,55,0.3);
}
#ars-chat-close:hover { color: #c9b037; }
#ars-send-btn:hover { transform: scale(1.1); }
</style>

<!-- CHATBOT: JS autocontenido (IIFE para no contaminar scope global) -->
<script>
(function() {
    // === CONFIG ===
    var ARS_CONTEXT = '<%= request.getContextPath() %>';
    var ARS_USER = '<%= usuarioActivo  != null && usuarioActivo .getNombres() != null && !usuarioActivo .getNombres().trim().isEmpty() ? usuarioActivo .getNombres().split(" ")[0] : "extrano" %>';

    // === DOM REFS (con nombres seguros, sin shadowear 'window') ===
    var chatBtn = document.getElementById('ars-chat-btn');
    var chatClose = document.getElementById('ars-chat-close');
    var chatWin = document.getElementById('ars-chat-window');
    var chatInput = document.getElementById('ars-input');
    var sendBtn = document.getElementById('ars-send-btn');
    var messagesBox = document.getElementById('ars-messages');
    var typingEl = document.getElementById('ars-typing');
    var statusEl = document.getElementById('ars-status');
    var welcomeMsg = document.getElementById('ars-welcome-msg');
    var widget = document.getElementById('ars-chat-widget');

    var isOpen = false;

    // === Bienvenida ===
    if (welcomeMsg) {
        welcomeMsg.innerHTML = '*<em>bosteza</em>*<br><br>Ah... eres t\u00fa, '
            + ARS_USER
            + '. \u00bfQu\u00e9 quieres? Estaba teniendo un sue\u00f1o muy agradable sobre un mundo sin usuarios que pierden libros...<br><br>Pregunta r\u00e1pido, que tengo que inventariar 200 vol\u00famenes y honestamente no me apetece.';
    }

    // === Toggle chat ===
    function toggle() {
        isOpen = !isOpen;
        chatWin.style.display = isOpen ? 'flex' : 'none';
        statusEl.innerText = isOpen ? 'molesto' : 'durmiendo';
        if (isOpen) chatInput.focus();
    }

    // === Escape HTML ===
    function esc(text) {
        var d = document.createElement('div');
        d.textContent = text;
        return d.innerHTML;
    }

    // === Enviar mensaje ===
    function sendMessage() {
        var msg = chatInput.value.trim();
        if (!msg) return;

        // Burbuja del usuario
        var userDiv = document.createElement('div');
        userDiv.className = 'ars-msg-anim';
        userDiv.style.cssText = 'max-width:85%;padding:1rem;background:rgba(201,176,55,0.15);'
            + 'border:1px solid rgba(201,176,55,0.4);border-radius:15px 15px 5px 15px;'
            + 'color:#fff;font-size:0.9rem;align-self:flex-end;';
        userDiv.textContent = msg;
        messagesBox.appendChild(userDiv);

        chatInput.value = '';
        messagesBox.scrollTop = messagesBox.scrollHeight;
        typingEl.style.display = 'block';

        fetch(ARS_CONTEXT + '/chatbot', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ question: msg, user: ARS_USER })
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            setTimeout(function() {
                typingEl.style.display = 'none';
                var botDiv = document.createElement('div');
                botDiv.className = 'ars-msg-anim';
                botDiv.style.cssText = 'max-width:85%;padding:1rem;background:rgba(255,255,255,0.05);'
                    + 'border:1px solid rgba(255,255,255,0.1);border-radius:15px 15px 15px 5px;'
                    + 'color:#ccc;font-size:0.9rem;line-height:1.5;align-self:flex-start;';
                botDiv.innerHTML = data.answer;
                messagesBox.appendChild(botDiv);
                messagesBox.scrollTop = messagesBox.scrollHeight;
            }, 1000 + Math.random() * 1000);
        })
        .catch(function(err) {
                console.error('ERROR FETCH:', err);
    typingEl.style.display = 'none';
            typingEl.style.display = 'none';
            var errDiv = document.createElement('div');
            errDiv.className = 'ars-msg-anim';
            errDiv.style.cssText = 'max-width:85%;padding:1rem;background:rgba(255,0,0,0.1);'
                + 'border:1px solid rgba(255,0,0,0.3);border-radius:15px;'
                + 'color:#ff6b6b;font-size:0.9rem;align-self:flex-start;';
            errDiv.innerHTML = '*<em>suspira</em>*<br>Mira, mi cerebro dej\u00f3 de funcionar temporalmente... vuelve a intentarlo o preg\u00fantale a otro. Yo no fui.';
            messagesBox.appendChild(errDiv);
            messagesBox.scrollTop = messagesBox.scrollHeight;
        });
    }

    // === EVENT LISTENERS (usando addEventListener, no inline onclick) ===
    chatBtn.addEventListener('click', function(e) {
        e.stopPropagation();
        toggle();
    });

    chatClose.addEventListener('click', function(e) {
        e.stopPropagation();
        toggle();
    });

    sendBtn.addEventListener('click', function(e) {
        e.stopPropagation();
        sendMessage();
    });

    chatInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            e.stopPropagation();
            sendMessage();
        }
    });

    // Cerrar al click fuera del widget
    document.addEventListener('click', function(e) {
        if (isOpen && widget && !widget.contains(e.target)) {
            toggle();
        }
    });
})();
</script>
<!-- FIN CHATBOT INLINE -->
</body>
</html>