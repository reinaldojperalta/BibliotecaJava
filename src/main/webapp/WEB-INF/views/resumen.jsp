<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="sena.adso.model.Prestamo" %>
<%@ page import="sena.adso.model.Multa" %>
<%@ page import="sena.adso.model.Usuario" %>
<%@ page import="sena.adso.model.enums.RolUsuario" %>
<%@ page import="sena.adso.model.enums.EstadoPrestamo" %>
<%@ page import="sena.adso.model.enums.EstadoMulta" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    Usuario usuarioActivo = (Usuario) session.getAttribute("usuarioActivo");
    boolean esAdmin = (usuarioActivo.getRol() == RolUsuario.ADMINISTRADOR || usuarioActivo.getRol() == RolUsuario.BIBLIOTECARIO); 
    
    List<Prestamo> prestamos = (List<Prestamo>) request.getAttribute("prestamos");
    List<Multa> multas = (List<Multa>) request.getAttribute("multas"); 
    
    // Map de nombres de libros
    Map<Integer, String> nombresLibros = (Map<Integer, String>) request.getAttribute("nombresLibros");
    if (nombresLibros == null) nombresLibros = new HashMap<Integer, String>();
    
    int totalPrestamos = (prestamos != null) ? prestamos.size() : 0; 
    double totalDeuda = 0;
    int multasPendientes = 0;
    
    if (multas != null) {
        for(Multa m : multas) {
            totalDeuda += m.getMonto();
            if(m.getEstado() != EstadoMulta.PAGADA) { 
                multasPendientes++;
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resumen - ARS BIBLIOTECA</title>
    
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;700;800&family=JetBrains+Mono&display=swap" rel="stylesheet">
    <!-- DataTables -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
    <!-- Custom CSS (tu style.css) -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    
    <style>
        /* Estilos específicos de esta página (no relacionados con tablas) */
        .resumen-kpi-title {
            color: var(--studiova-gray, #888);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 2px;
            margin-bottom: 0.5rem;
        }
        .resumen-kpi-value {
            font-size: 2.5rem;
            font-weight: 800;
            color: #fff;
            line-height: 1;
            margin-bottom: 0.5rem;
        }
        .resumen-subtext {
            color: var(--studiova-gray, #666);
            font-size: 0.7rem;
        }
        .text-gold { color: #c9b037 !important; }
        .border-gold { border-color: #c9b037 !important; }
        .glow-text {
            text-shadow: 0 0 20px rgba(201, 176, 55, 0.3);
        }
        
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/includes/matrix-bg.jsp" />
<jsp:include page="/WEB-INF/views/nav.jsp" />

<main class="resumen-main-content">
    <div class="container pb-5">
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger bg-danger text-white border-0 mb-4 font-mono" style="font-size: 0.8rem;">
                ⚠️ ADVERTENCIA: ACCESO DENEGADO A LA ZONA SOLICITADA. 
            </div>
        <% } %>

        <!-- Header -->
        <div class="d-flex justify-content-between align-items-end mb-5">
            <div>
                <span class="d-block mb-1 text-uppercase" style="color: #888; font-size: 0.7rem; letter-spacing: 3px;">Central de Inteligencia</span>
                <h2 class="text-gold m-0 glow-text" style="font-family: 'Montserrat', sans-serif; font-weight: 800;">
                    <%= esAdmin ? "PANEL ADMINISTRATIVO" : "MI BÓVEDA DE LECTURA" %> 
                </h2>
            </div>
            <div class="text-end">
                <span class="badge border border-gold text-gold p-2 font-mono" style="letter-spacing: 2px; font-size: 0.7rem;">
                    ACCESO: <%= usuarioActivo.getRol() %>
                </span>
            </div>
        </div>

        <!-- KPIs -->
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="ars-card p-4">
                    <h6 class="resumen-kpi-title">Volúmenes Indexados</h6> 
                    <div class="resumen-kpi-value"><%= totalPrestamos %></div>
                    <small class="resumen-subtext">
                        <%= esAdmin ? "Registros totales en sistema" : "Vinculados a tu cuenta" %> 
                    </small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="ars-card p-4">
                    <h6 class="resumen-kpi-title">Vínculos Activos</h6>
                    <div class="resumen-kpi-value" style="color: #ff4d4d !important;"><%= multasPendientes %></div>
                    <small class="resumen-subtext">Requieren atención inmediata</small> 
                </div>
            </div>
            <div class="col-md-4">
                <div class="ars-card p-4">
                    <h6 class="resumen-kpi-title">Deuda Acumulada</h6>
                    <div class="resumen-kpi-value text-gold">$<%= String.format("%.2f", totalDeuda) %></div> 
                    <small class="resumen-subtext">Saldo total a liquidar</small>
                </div>
            </div>
        </div>

        <!-- Gráfico -->
        <div class="row mb-5">
            <div class="col-12">
                <div class="ars-card p-4">
                    <h5 class="text-gold mb-4 font-mono" style="font-size: 0.9rem;">
                        <iconify-icon icon="solar:chart-line-duotone" class="me-2"></iconify-icon>
                        FRECUENCIA DE ENLACE TEMPORAL 
                    </h5>
                    <div id="chart-prestamos" style="min-height: 350px;"></div>
                </div>
            </div>
        </div>

        <!-- Tablas -->
        <div class="row g-4">
            <!-- Tabla Préstamos -->
            <div class="col-xl-7">
                <div class="ars-card p-4 h-100">
                    <h5 class="text-gold mb-4 font-mono" style="font-size: 0.9rem;">
                        <%= esAdmin ? "REGISTRO GLOBAL" : "MIS PRÉSTAMOS" %> 
                    </h5>
                    <div class="table-responsive">
                        <% if (prestamos == null || prestamos.isEmpty()) { %>
                            <p class="text-muted fst-italic font-mono" style="font-size: 0.75rem;">No hay registros en los archivos.</p> 
                        <% } else { %>
                            <table id="tablaPrestamos" class="table table-dark table-hover align-middle font-mono" style="font-size: 0.75rem;">
                                <thead>
                                    <tr>
                                        <th>REF</th> 
                                        <th>VOLUMEN (ID.TITULO)</th> 
                                        <th><%= esAdmin ? "ID_USUARIO" : "LECTOR_ACTIVO" %></th> 
                                        <th>FECHA_ENLACE</th> 
                                        <th>ESTADO</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Prestamo p : prestamos) { 
                                        String tituloFull = nombresLibros.getOrDefault(p.getIdLibro(), "DESCONOCIDO");
                                        String primerPalabraLibro = tituloFull.split(" ")[0].toLowerCase();
                                        String displayLibro = p.getIdLibro() + "." + primerPalabraLibro;

                                        String displayUser;
                                        if (esAdmin) {
                                            displayUser = "ID:" + p.getIdUsuario();
                                        } else {
                                            // Ajusta aquí el método según tu clase Usuario (getNombres, getNombre, etc.)
                                            String nombreSesion = usuarioActivo.getNombres().split(" ")[0].toLowerCase();
                                            displayUser = usuarioActivo.getId() + "." + nombreSesion;
                                        }
                                    %>
                                    <tr>
                                        <td class="text-gold">#<%= p.getId() %></td>
                                        <td class="text-white fw-bold"><%= displayLibro %></td>
                                        <td class="text-info"><%= displayUser %></td>
                                        <td><%= p.getFechaPrestamo() %></td>
                                        <td>
                                            <span class="badge <%= p.getEstado() == EstadoPrestamo.DEVUELTO ? "bg-success" : "bg-warning text-dark" %>">
                                                <%= p.getEstado() %>
                                            </span>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Tabla Multas -->
            <div class="col-xl-5">
                <div class="ars-card p-4 h-100">
                    <h5 class="text-gold mb-4 font-mono" style="font-size: 0.9rem;">
                        <iconify-icon icon="solar:shield-warning-bold" class="me-2"></iconify-icon>
                        SANCIONES
                    </h5> 
                    <div class="table-responsive">
                        <% if (multas == null || multas.isEmpty()) { %>
                            <p class="text-muted fst-italic font-mono" style="font-size: 0.75rem;">Usuario en paz con el sistema.</p> 
                        <% } else { %>
                            <table id="tablaMultas" class="table table-dark align-middle font-mono" style="font-size: 0.75rem;">
                                <thead>
                                    <tr>
                                        <th>REF</th>
                                        <th>MONTO</th>
                                        <th>ESTADO</th> 
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Multa m : multas) { %>
                                    <tr>
                                        <td>#<%= m.getIdPrestamo() %></td> 
                                        <td class="text-danger fw-bold">$<%= String.format("%.2f", m.getMonto()) %></td> 
                                        <td>
                                            <span class="badge border <%= m.getEstado() == EstadoMulta.PAGADA ? "border-success text-success" : "border-danger text-danger" %>">
                                                <%= m.getEstado() %> 
                                            </span>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
<script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>

<script>
$(document).ready(function() {
    // DataTable Préstamos
    $('#tablaPrestamos').DataTable({
        pageLength: 10,
        ordering: true,
        language: {
            url: "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json",
            search: "FILTRAR:",
            lengthMenu: "_MENU_ REG",
            info: "_START_-_END_/_TOTAL_"
        }
    });
    
    // DataTable Multas
    $('#tablaMultas').DataTable({
        pageLength: 5,
        ordering: true,
        searching: true,
        language: {
            url: "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json",
            lengthMenu: "_MENU_ REG",
            info: "_START_-_END_/_TOTAL_",
            paginate: {
                next: "→",
                previous: "←"
            }
        }
    });
    
    // Gráfico ApexCharts
    const fechasPrestamos = [
        <% if (prestamos != null) { 
            for (Prestamo p : prestamos) { %>
                "<%= p.getFechaPrestamo() %>",
        <%  } 
        } %>
    ];

    const conteoPorFecha = fechasPrestamos.reduce((acc, fecha) => {
        const fechaCorta = fecha.split(' ')[0]; 
        acc[fechaCorta] = (acc[fechaCorta] || 0) + 1;
        return acc;
    }, {});

    const categorias = Object.keys(conteoPorFecha).sort();
    const datos = categorias.map(fecha => conteoPorFecha[fecha]);

    const options = {
        series: [{
            name: 'Préstamos',
            data: datos.length > 0 ? datos : [0]
        }],
        chart: {
            type: 'area',
            height: 350,
            background: 'transparent',
            toolbar: { show: false },
            fontFamily: 'JetBrains Mono'
        },
        colors: ['#ccff00'],
        fill: {
            type: 'gradient',
            gradient: {
                shadeIntensity: 1,
                opacityFrom: 0.4,
                opacityTo: 0.05,
                stops: [0, 90, 100]
            }
        },
        dataLabels: { enabled: false },
        stroke: { curve: 'smooth', width: 2 },
        xaxis: {
            categories: categorias.length > 0 ? categorias : ['Sin datos'],
            axisBorder: { show: false },
            axisTicks: { show: false },
            labels: { style: { colors: '#888' } }
        },
        yaxis: {
            labels: { style: { colors: '#888' } },
            title: { text: 'Volúmenes', style: { color: '#c9b037' } }
        },
        grid: {
            borderColor: '#333',
            strokeDashArray: 4,
            yaxis: { lines: { show: true } }
        },
        theme: { mode: 'dark' }
    };

    const chart = new ApexCharts(document.querySelector("#chart-prestamos"), options);
    chart.render();
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
<!-- FIN CHATBOT INLINE --><!-- FIN CHATBOT INLINE -->
</body>
</html>