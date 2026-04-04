<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="sena.adso.model.Usuario" %>
<%
    Usuario usuarioNav = (Usuario) session.getAttribute("usuarioActivo");
    String rolNavStr   = "";
    if (usuarioNav != null && usuarioNav.getRol() != null) {
        rolNavStr = usuarioNav.getRol().toDb(); // "admin", "bibliotecario" o "lector"
    }
%>

<header class="glass-nav position-fixed start-0 top-0 w-100 py-3">
    <div class="container">
        <div class="d-flex align-items-center justify-content-between">
            
            <div class="logo">
                <a href="<%= request.getContextPath() %>/index.jsp" class="d-flex align-items-center gap-2">
                    
                    <span class="logo-text">ARS BIBLIOTECA</span>
                </a>
            </div>

            <div class="d-flex align-items-center gap-4">
                
                <% if (usuarioNav != null) { %>
                <div class="d-none d-md-block text-end font-mono">
                    <span class="d-block text-white" style="font-size: 0.85rem;"><%= usuarioNav.getNombres() %></span>
                    <span class="text-gold" style="font-size: 0.7rem; letter-spacing: 1px;"><%= rolNavStr.toUpperCase() %></span>
                </div>
                <% } %>

                <div class="btn-group">
                    <button class="btn menu-trigger" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <iconify-icon icon="solar:hamburger-menu-line-duotone" class="fs-5"></iconify-icon>
                    </button>

                    <ul class="dropdown-menu dropdown-menu-end studiova-dropdown p-4" style="min-width: 300px; border-radius: 15px;">
                        <div class="d-flex flex-column gap-3">
                            <div class="border-bottom border-secondary pb-2 mb-2 d-flex justify-content-between">
                                <span class="text-gray-metal font-mono" style="font-size: 0.75rem;">ÍNDICE DEL SISTEMA</span>
                            </div>

                            <a href="<%= request.getContextPath() %>/login" class="header-link">
                                <iconify-icon icon="solar:key-minimalistic-bold-duotone"></iconify-icon> Portal de Acceso (Login)
                            </a>
                            <a href="<%= request.getContextPath() %>/resumen" class="header-link">
                                <iconify-icon icon="solar:widget-bold-duotone"></iconify-icon> Resumen
                            </a>
                            <a href="<%= request.getContextPath() %>/libros" class="header-link">
                                <iconify-icon icon="solar:library-bold-duotone"></iconify-icon> Catálogo de Libros
                            </a>
                            <a href="<%= request.getContextPath() %>/prestamos" class="header-link">
                                <iconify-icon icon="solar:document-text-bold-duotone"></iconify-icon> Registro de Préstamos
                            </a>

                            <% if ("admin".equals(rolNavStr)) { %>
                            <a href="<%= request.getContextPath() %>/dashboard" class="header-link text-gold">
                                <iconify-icon icon="solar:crown-star-bold-duotone"></iconify-icon> Dashboard (Admin)
                            </a>
                            <% } %>

                            <div class="mt-3">
                                <% if (usuarioNav != null) { %>
                                    <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-danger w-100 font-mono" style="font-size: 0.8rem;">CERRAR SESIÓN</a>
                                <% } else { %>
                                    <a href="<%= request.getContextPath() %>/login" class="btn btn-gold w-100 font-mono" style="font-size: 0.8rem;">INICIAR SESIÓN</a>
                                <% } %>
                            </div>
                        </div>
                    </ul>
                </div>

            </div>
        </div>
    </div>
</header>