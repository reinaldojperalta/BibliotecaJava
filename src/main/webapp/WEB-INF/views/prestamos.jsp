<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="sena.adso.model.Prestamo" %>
<%@ page import="sena.adso.model.Multa" %>
<%@ page import="sena.adso.model.Usuario" %>
<%@ page import="sena.adso.model.enums.EstadoPrestamo" %>
<%@ page import="sena.adso.model.enums.EstadoMulta" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.ChronoUnit" %>

<%
    Usuario usuarioActivo = (Usuario) session.getAttribute("usuarioActivo");
    String rolPrestamosStr = usuarioActivo.getRol().toDb();
    boolean esEditorP = "admin".equals(rolPrestamosStr) || "bibliotecario".equals(rolPrestamosStr);

    List<Prestamo> prestamos = (List<Prestamo>) request.getAttribute("prestamos");
    List<Multa> multas = (List<Multa>) request.getAttribute("multas");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Préstamos - ARS BIBLIOTECA</title>
    
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;600;700;800&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <!-- DataTables -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    
    <style>
        /* Fuente base más legible */
        body {
            font-family: 'Inter', sans-serif;
            font-size: 1rem;
            line-height: 1.6;
        }
        
        .font-mono {
            font-family: 'JetBrains Mono', monospace;
        }
        
        .page-title {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 2rem;
            letter-spacing: -0.5px;
        }
        
        .text-gold { color: #c9b037 !important; }
        .border-gold { border-color: #c9b037 !important; }
        .glow-text { text-shadow: 0 0 20px rgba(201, 176, 55, 0.3); }
        
        /* Glass Cards */
        .glass-card {
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(201, 176, 55, 0.15);
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }
        
        /* Badges de Estado - Préstamos */
        .badge-prestamo {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: 1px solid;
        }
        
        .estado-activo { 
            background: rgba(255, 193, 7, 0.15); 
            color: #ffc107; 
            border-color: rgba(255, 193, 7, 0.4);
        }
        .estado-devuelto { 
            background: rgba(40, 167, 69, 0.15); 
            color: #28a745; 
            border-color: rgba(40, 167, 69, 0.4);
        }
        .estado-vencido { 
            background: rgba(220, 53, 69, 0.15); 
            color: #dc3545; 
            border-color: rgba(220, 53, 69, 0.4);
        }
        
        /* Badges de Estado - Multas */
        .estado-pendiente { 
            background: rgba(220, 53, 69, 0.15); 
            color: #ff6b6b; 
            border-color: rgba(220, 53, 69, 0.4);
        }
        .estado-pagada { 
            background: rgba(40, 167, 69, 0.15); 
            color: #51cf66; 
            border-color: rgba(40, 167, 69, 0.4);
        }
        .estado-exonerada { 
            background: rgba(108, 117, 125, 0.15); 
            color: #adb5bd; 
            border-color: rgba(108, 117, 125, 0.4);
        }
        
        /* Botones de acción glass */
        .btn-gold {
            background: rgba(201, 176, 55, 0.2);
            border: 1px solid #c9b037;
            color: #c9b037;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.85rem;
            cursor: pointer;
        }
        
        .btn-gold:hover {
            background: #c9b037;
            color: #000;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(201, 176, 55, 0.4);
        }
        
        .btn-success-glass {
            background: rgba(40, 167, 69, 0.2);
            border: 1px solid #28a745;
            color: #28a745;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            transition: all 0.3s ease;
            font-size: 0.85rem;
            cursor: pointer;
        }
        
        .btn-success-glass:hover {
            background: #28a745;
            color: #fff;
            transform: translateY(-2px);
        }
        
        .btn-danger-glass {
            background: rgba(220, 53, 69, 0.2);
            border: 1px solid #dc3545;
            color: #dc3545;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            transition: all 0.3s ease;
            font-size: 0.85rem;
            cursor: pointer;
        }
        
        .btn-danger-glass:hover {
            background: #dc3545;
            color: #fff;
            transform: translateY(-2px);
        }
        
        .btn-secondary-glass {
            background: rgba(108, 117, 125, 0.2);
            border: 1px solid #6c757d;
            color: #adb5bd;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            transition: all 0.3s ease;
            font-size: 0.85rem;
            cursor: pointer;
        }
        
        .btn-secondary-glass:hover {
            background: #6c757d;
            color: #fff;
            transform: translateY(-2px);
        }
        
        /* Formularios inline compactos */
        .form-select-sm {
            background: rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(201, 176, 55, 0.3);
            color: #fff;
            border-radius: 6px;
            padding: 0.4rem;
            font-size: 0.85rem;
        }
        
        /* Indicador de días */
        .dias-restantes {
            font-size: 0.75rem;
            font-family: 'JetBrains Mono', monospace;
            margin-top: 0.25rem;
        }
        .dias-ok { color: #28a745; }
        .dias-peligro { color: #ffc107; }
        .dias-vencido { color: #dc3545; font-weight: bold; }
        
        /* Tablas */
        .table-glass {
            font-size: 0.95rem;
        }
        .table-glass th {
            font-family: 'Montserrat', sans-serif;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 0.8rem;
            color: #c9b037 !important;
        }
        .table-glass td {
            padding: 1rem 0.75rem;
            vertical-align: middle;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/includes/matrix-bg.jsp" />
<jsp:include page="/WEB-INF/views/nav.jsp" />

<main class="container py-5">
    
    <!-- Mensajes -->
    <% if (request.getParameter("msg") != null) { %>
        <% 
            String msg = request.getParameter("msg");
            String alertClass = "border-success text-success";
            String icon = "check-circle-bold";
            
            if (msg.contains("error") || msg.contains("Error")) {
                alertClass = "border-danger text-danger";
                icon = "shield-warning-bold";
            } else if (msg.contains("devolucion")) {
                alertClass = "border-info text-info";
                icon = "check-circle-bold";
            } else if (msg.contains("multa")) {
                alertClass = "border-warning text-warning";
                icon = "wallet-money-bold";
            }
        %>
        <div class="alert glass-card <%= alertClass %> mb-4" style="background: rgba(0,0,0,0.2);">
            <iconify-icon icon="solar:<%= icon %>" class="me-2"></iconify-icon>
            <%= msg %>
        </div>
    <% } %>

    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mt-5 mb-5">
        <div>
            <span class="d-block mb-2 text-uppercase" style="color: #888; font-size: 0.85rem; letter-spacing: 3px;">
                Control de Circulación
            </span>
            <h1 class="page-title text-gold m-0 glow-text">
                <%= esEditorP ? "GESTIÓN DE PRÉSTAMOS" : "MIS VÍNCULOS ACTIVOS" %>
            </h1>
        </div>
        <div class="text-end">
            <span class="badge border border-gold text-gold p-2 font-mono" style="letter-spacing: 2px;">
                ROL: <%= usuarioActivo.getRol() %>
            </span>
        </div>
    </div>

    <!-- SECCIÓN PRÉSTAMOS -->
    <div class="glass-card p-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="text-gold m-0 font-mono" style="font-size: 1.1rem; letter-spacing: 1px;">
                <iconify-icon icon="solar:clock-circle-bold" class="me-2"></iconify-icon>
                REGISTROS DE PRÉSTAMO
            </h3>
            <span class="text-muted font-mono" style="font-size: 0.85rem;">
                TOTAL: <%= prestamos != null ? prestamos.size() : 0 %> registros
            </span>
        </div>
        
        <% if (prestamos == null || prestamos.isEmpty()) { %>
            <div class="text-center py-5">
                <iconify-icon icon="solar:inbox-line-bold" style="font-size: 3rem; color: #555;"></iconify-icon>
                <p class="text-muted mt-3">No hay préstamos activos en el sistema.</p>
            </div>
        <% } else { %>
        <div class="table-responsive">
            <table id="tablaPrestamos" class="table table-dark table-hover align-middle table-glass" style="width:100%">
                <thead>
                    <tr>
                        <th>REF</th>
                        <th>ID LIBRO</th>
                        <th>ID USUARIO</th>
                        <th>INICIO</th>
                        <th>DEVOLUCIÓN ESPERADA</th>
                        <th>DEVOLUCIÓN REAL</th>
                        <th>ESTADO</th>
                        <% if (esEditorP) { %><th class="text-center">OPERACIONES</th><% } %>
                    </tr>
                </thead>
                <tbody>
                    <% for (Prestamo p : prestamos) { 
                        String estadoDb = p.getEstado().toDb();
                        String estadoClass = "";
                        
                        if ("activo".equals(estadoDb)) {
                            estadoClass = "estado-activo";
                        } else if ("devuelto".equals(estadoDb)) {
                            estadoClass = "estado-devuelto";
                        } else if ("vencido".equals(estadoDb)) {
                            estadoClass = "estado-vencido";
                        }
                        
                        // Calcular días restantes para préstamos activos
                        String diasTexto = "";
                        if ("activo".equals(estadoDb) && p.getFechaDevolucionEsperada() != null) {
                            LocalDate hoy = LocalDate.now();
                            long dias = ChronoUnit.DAYS.between(hoy, p.getFechaDevolucionEsperada());
                            if (dias > 3) {
                                diasTexto = "<div class='dias-restantes dias-ok'>(" + dias + " días)</div>";
                            } else if (dias >= 0) {
                                diasTexto = "<div class='dias-restantes dias-peligro'>(" + dias + " días)</div>";
                            } else {
                                diasTexto = "<div class='dias-restantes dias-vencido'>(" + Math.abs(dias) + " días vencido)</div>";
                            }
                        }
                    %>
                    <tr>
                        <td class="font-mono text-gold">#<%= p.getId() %></td>
                        <td class="font-mono"><%= p.getIdLibro() %></td>
                        <td class="font-mono"><%= p.getIdUsuario() %></td>
                        <td><%= p.getFechaPrestamo() %></td>
                        <td>
                            <%= p.getFechaDevolucionEsperada() %>
                            <%= diasTexto %>
                        </td>
                        <td class="font-mono <%= p.getFechaDevolucionReal() != null ? "text-success" : "text-muted" %>">
                            <%= p.getFechaDevolucionReal() != null ? p.getFechaDevolucionReal() : "—" %>
                        </td>
                        <td>
                            <span class="badge-prestamo <%= estadoClass %>">
                                <%= estadoDb %>
                            </span>
                        </td>
                        <% if (esEditorP) { %>
                        <td class="text-center">
                            <div class="d-flex gap-2 justify-content-center align-items-center">
                                <% if ("activo".equals(estadoDb)) { %>
                                    <form method="get" action="<%= request.getContextPath() %>/prestamos" style="display: inline;">
                                        <input type="hidden" name="action" value="devolver">
                                        <input type="hidden" name="id" value="<%= p.getId() %>">
                                        <button type="submit" class="btn-success-glass" title="Registrar Devolución">
                                            <iconify-icon icon="solar:check-circle-bold"></iconify-icon>
                                        </button>
                                    </form>
                                <% } %>
                                
                                <form method="post" action="<%= request.getContextPath() %>/prestamos" style="display: inline-flex; gap: 0.5rem;">
                                    <input type="hidden" name="action" value="actualizarPrestamo">
                                    <input type="hidden" name="id" value="<%= p.getId() %>">
                                    <select name="estado" class="form-select-sm">
                                        <option value="activo" <%= "activo".equals(estadoDb) ? "selected" : "" %>>Activo</option>
                                        <option value="devuelto" <%= "devuelto".equals(estadoDb) ? "selected" : "" %>>Devuelto</option>
                                        <option value="vencido" <%= "vencido".equals(estadoDb) ? "selected" : "" %>>Vencido</option>
                                    </select>
                                    <button type="submit" class="btn-gold" style="padding: 0.4rem 0.6rem;" title="Actualizar Estado">
                                        <iconify-icon icon="solar:pen-bold"></iconify-icon>
                                    </button>
                                </form>
                                
                                <form method="get" action="<%= request.getContextPath() %>/prestamos" style="display: inline;">
                                    <input type="hidden" name="action" value="eliminar">
                                    <input type="hidden" name="id" value="<%= p.getId() %>">
                                    <button type="submit" class="btn-danger-glass" title="Eliminar Registro"
                                            onclick="return confirm('¿Eliminar permanentemente este préstamo?')">
                                        <iconify-icon icon="solar:trash-bin-trash-bold"></iconify-icon>
                                    </button>
                                </form>
                            </div>
                        </td>
                        <% } %>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>

    <!-- SECCIÓN MULTAS -->
    <div class="glass-card p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="text-gold m-0 font-mono" style="font-size: 1.1rem; letter-spacing: 1px;">
                <iconify-icon icon="solar:wallet-money-bold" class="me-2"></iconify-icon>
                SANCIONES ECONÓMICAS
            </h3>
            <span class="text-muted font-mono" style="font-size: 0.85rem;">
                TOTAL: <%= multas != null ? multas.size() : 0 %> registros
            </span>
        </div>
        
        <% if (multas == null || multas.isEmpty()) { %>
            <div class="text-center py-5">
                <iconify-icon icon="solar:shield-check-bold" style="font-size: 3rem; color: #28a745;"></iconify-icon>
                <p class="text-muted mt-3">No hay sanciones registradas. Sistema limpio.</p>
            </div>
        <% } else { %>
        <div class="table-responsive">
            <table id="tablaMultas" class="table table-dark table-hover align-middle table-glass" style="width:100%">
                <thead>
                    <tr>
                        <th>REF</th>
                        <th>ID PRÉSTAMO</th>
                        <th>MONTO</th>
                        <th>GENERACIÓN</th>
                        <th>PAGO</th>
                        <th>ESTADO</th>
                        <% if (esEditorP) { %><th class="text-center">OPERACIONES</th><% } %>
                    </tr>
                </thead>
                <tbody>
                    <% for (Multa m : multas) { 
                        String estadoMultaDb = m.getEstado().toDb();
                        String estadoMultaClass = "";
                        
                        if ("pendiente".equals(estadoMultaDb)) {
                            estadoMultaClass = "estado-pendiente";
                        } else if ("pagada".equals(estadoMultaDb)) {
                            estadoMultaClass = "estado-pagada";
                        } else if ("exonerada".equals(estadoMultaDb)) {
                            estadoMultaClass = "estado-exonerada";
                        }
                    %>
                    <tr>
                        <td class="font-mono text-gold">#<%= m.getId() %></td>
                        <td class="font-mono">#<%= m.getIdPrestamo() %></td>
                        <td class="fw-bold text-danger">$<%= String.format("%.2f", m.getMonto()) %></td>
                        <td><%= m.getFechaGeneracion() %></td>
                        <td class="<%= m.getFechaPago() != null ? "text-success" : "text-muted" %>">
                            <%= m.getFechaPago() != null ? m.getFechaPago() : "—" %>
                        </td>
                        <td>
                            <span class="badge-prestamo <%= estadoMultaClass %>">
                                <%= estadoMultaDb %>
                            </span>
                        </td>
                        <% if (esEditorP) { %>
                        <td class="text-center">
                            <div class="d-flex gap-2 justify-content-center">
                                <% if ("pendiente".equals(estadoMultaDb)) { %>
                                    <form method="post" action="<%= request.getContextPath() %>/prestamos" style="display: inline;">
                                        <input type="hidden" name="action" value="pagarMulta">
                                        <input type="hidden" name="idMulta" value="<%= m.getId() %>">
                                        <button type="submit" class="btn-success-glass" title="Marcar como Pagada">
                                            <iconify-icon icon="solar:check-circle-bold" class="me-1"></iconify-icon>
                                            Pagar
                                        </button>
                                    </form>
                                    
                                    <form method="post" action="<%= request.getContextPath() %>/prestamos" style="display: inline;">
                                        <input type="hidden" name="action" value="exonerarMulta">
                                        <input type="hidden" name="idMulta" value="<%= m.getId() %>">
                                        <button type="submit" class="btn-secondary-glass" title="Exonerar Multa">
                                            <iconify-icon icon="solar:close-circle-bold" class="me-1"></iconify-icon>
                                            Exonerar
                                        </button>
                                    </form>
                                <% } else { %>
                                    <span class="text-muted font-mono" style="font-size: 0.8rem;">SIN ACCIONES</span>
                                <% } %>
                            </div>
                        </td>
                        <% } %>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</main>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>

<script>
$(document).ready(function() {
    // DataTable Préstamos
    $('#tablaPrestamos').DataTable({
        pageLength: 10,
        ordering: true,
        language: {
            url: "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json",
            search: "BUSCAR PRÉSTAMO:",
            lengthMenu: "Mostrar _MENU_ registros",
            info: "Mostrando _START_ a _END_ de _TOTAL_ préstamos"
        },
        columnDefs: [
            { orderable: false, targets: <%= esEditorP ? 7 : 6 %> }
        ]
    });
    
    // DataTable Multas
    $('#tablaMultas').DataTable({
        pageLength: 5,
        ordering: true,
        language: {
            url: "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json",
            search: "BUSCAR MULTA:",
            lengthMenu: "Mostrar _MENU_ registros",
            info: "Mostrando _START_ a _END_ de _TOTAL_ sanciones"
        },
        columnDefs: [
            { orderable: false, targets: <%= esEditorP ? 6 : 5 %> }
        ]
    });
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