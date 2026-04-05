<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="sena.adso.model.Usuario" %>
<%@ page import="sena.adso.model.enums.EstadoUsuario" %>
<%@ page import="java.util.List" %>

<%
    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
    Usuario usuarioEditar = (Usuario) request.getAttribute("usuario");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administración de Usuarios - ARS BIBLIOTECA</title>
    
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;600;700;800&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <!-- DataTables -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    
    <style>
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
        
        .glass-card {
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(201, 176, 55, 0.15);
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }
        
        .form-group label {
            color: #c9b037;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 0.5rem;
            font-weight: 600;
        }
        
        .form-control, .form-select {
            background: rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(201, 176, 55, 0.3);
            color: #fff;
            font-size: 1rem;
            padding: 0.75rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            background: rgba(0, 0, 0, 0.5);
            border-color: #c9b037;
            box-shadow: 0 0 0 0.2rem rgba(201, 176, 55, 0.25);
            color: #fff;
        }
        
        /* Badges de Rol */
        .badge-rol {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: 1px solid;
        }
        
        .rol-admin { 
            background: rgba(201, 176, 55, 0.2); 
            color: #c9b037; 
            border-color: rgba(201, 176, 55, 0.5);
        }
        .rol-bibliotecario { 
            background: rgba(77, 171, 247, 0.2); 
            color: #4dabf7; 
            border-color: rgba(77, 171, 247, 0.5);
        }
        .rol-lector { 
            background: rgba(173, 181, 189, 0.2); 
            color: #adb5bd; 
            border-color: rgba(173, 181, 189, 0.5);
        }
        
        /* Badges de Estado */
        .estado-activo { 
            background: rgba(40, 167, 69, 0.2); 
            color: #28a745; 
            border-color: rgba(40, 167, 69, 0.5);
        }
        .estado-inactivo { 
            background: rgba(108, 117, 125, 0.2); 
            color: #6c757d; 
            border-color: rgba(108, 117, 125, 0.5);
        }
        .estado-suspendido { 
            background: rgba(220, 53, 69, 0.2); 
            color: #dc3545; 
            border-color: rgba(220, 53, 69, 0.5);
        }
        
        /* Botones */
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
        }
        
        .btn-gold:hover {
            background: #c9b037;
            color: #000;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(201, 176, 55, 0.4);
        }
        
        .btn-danger-glass {
            background: rgba(220, 53, 69, 0.2);
            border: 1px solid #dc3545;
            color: #dc3545;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .btn-danger-glass:hover {
            background: #dc3545;
            color: #fff;
            transform: translateY(-2px);
        }
        
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
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(201, 176, 55, 0.2);
            border: 1px solid rgba(201, 176, 55, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #c9b037;
            font-weight: 600;
            font-size: 1rem;
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
            } else if (msg.contains("eliminar") || msg.contains("Eliminar")) {
                alertClass = "border-warning text-warning";
                icon = "trash-bin-trash-bold";
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
                Administración del Sistema
            </span>
            <h1 class="page-title text-gold m-0 glow-text">
                <%= usuarioEditar != null ? "EDITAR USUARIO" : "GESTIÓN DE USUARIOS" %>
            </h1>
        </div>
        <div class="text-end">
            <span class="badge border border-gold text-gold p-2 font-mono" style="letter-spacing: 2px;">
                ACCESO: ADMINISTRADOR
            </span>
        </div>
    </div>

    <!-- Formulario CREAR / EDITAR -->
    <div class="glass-card p-4 mb-5">
        <h3 class="text-gold mb-4 font-mono" style="font-size: 1.1rem; letter-spacing: 1px;">
            <iconify-icon icon="solar:user-id-bold" class="me-2"></iconify-icon>
            <%= usuarioEditar != null ? "MODIFICAR REGISTRO #" + usuarioEditar.getId() : "NUEVO REGISTRO" %>
        </h3>
        
        <form method="post" action="<%= request.getContextPath() %>/dashboard">
            <input type="hidden" name="action" value="<%= usuarioEditar != null ? "actualizar" : "crear" %>">
            <% if (usuarioEditar != null) { %>
                <input type="hidden" name="id" value="<%= usuarioEditar.getId() %>">
            <% } %>

            <div class="form-grid">
                <div class="form-group">
                    <label>Documento de Identidad</label>
                    <input type="text" name="documento" class="form-control" required 
                           value="<%= usuarioEditar != null ? usuarioEditar.getCedula() : "" %>"
                           placeholder="1234567890">
                </div>

                <div class="form-group">
                    <label>Nombres</label>
                    <input type="text" name="nombres" class="form-control" required 
                           value="<%= usuarioEditar != null ? usuarioEditar.getNombres() : "" %>"
                           placeholder="Nombre completo">
                </div>

                <div class="form-group">
                    <label>Apellidos</label>
                    <input type="text" name="apellidos" class="form-control" required 
                           value="<%= usuarioEditar != null ? usuarioEditar.getApellidos() : "" %>"
                           placeholder="Apellidos">
                </div>

                <div class="form-group">
                    <label>Correo Electrónico</label>
                    <input type="email" name="email" class="form-control" required 
                           value="<%= usuarioEditar != null ? usuarioEditar.getEmail() : "" %>"
                           placeholder="usuario@email.com">
                </div>

                <div class="form-group">
                    <label>Teléfono</label>
                    <input type="text" name="telefono" class="form-control" 
                           value="<%= usuarioEditar != null ? usuarioEditar.getTelefono() : "" %>"
                           placeholder="3001234567">
                </div>

                <div class="form-group">
                    <label>Rol del Sistema</label>
                    <select name="rol" class="form-select">
                        <% 
                            String rolActual = usuarioEditar != null ? usuarioEditar.getRol().toDb() : "lector";
                        %>
                        <option value="lector" <%= "lector".equals(rolActual) ? "selected" : "" %>>Lector</option>
                        <option value="bibliotecario" <%= "bibliotecario".equals(rolActual) ? "selected" : "" %>>Bibliotecario</option>
                        <option value="admin" <%= "admin".equals(rolActual) ? "selected" : "" %>>Administrador</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Estado de la Cuenta</label>
                    <select name="estado" class="form-select">
                        <% 
                            String estadoActual = usuarioEditar != null ? usuarioEditar.getEstado().toDb() : "activo";
                        %>
                        <option value="activo" <%= "activo".equals(estadoActual) ? "selected" : "" %>>Activo</option>
                        <option value="inactivo" <%= "inactivo".equals(estadoActual) ? "selected" : "" %>>Inactivo</option>
                        <option value="suspendido" <%= "suspendido".equals(estadoActual) ? "selected" : "" %>>Suspendido</option>
                    </select>
                </div>
            </div>

            <div class="mt-4 d-flex gap-3">
                <button type="submit" class="btn-gold">
                    <iconify-icon icon="solar:disk-bold"></iconify-icon>
                    <%= usuarioEditar != null ? "ACTUALIZAR USUARIO" : "CREAR USUARIO" %>
                </button>
                <% if (usuarioEditar != null) { %>
                    <a href="<%= request.getContextPath() %>/dashboard?action=listar" class="btn-gold" style="background: transparent; color: #888; border-color: #555;">
                        <iconify-icon icon="solar:close-circle-bold"></iconify-icon>
                        Cancelar Edición
                    </a>
                <% } %>
            </div>
        </form>
    </div>

    <!-- Listado de Usuarios -->
    <div class="glass-card p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="text-gold m-0 font-mono" style="font-size: 1.1rem; letter-spacing: 1px;">
                <iconify-icon icon="solar:users-group-rounded-bold" class="me-2"></iconify-icon>
                REGISTROS DE USUARIOS
            </h3>
            <span class="text-muted font-mono" style="font-size: 0.85rem;">
                TOTAL: <%= usuarios != null ? usuarios.size() : 0 %> usuarios
            </span>
        </div>
        
        <% if (usuarios == null || usuarios.isEmpty()) { %>
            <div class="text-center py-5">
                <iconify-icon icon="solar:users-group-rounded-bold" style="font-size: 3rem; color: #555;"></iconify-icon>
                <p class="text-muted mt-3">No hay usuarios registrados en el sistema.</p>
            </div>
        <% } else { %>
        <div class="table-responsive">
            <table id="tablaUsuarios" class="table table-dark table-hover align-middle table-glass" style="width:100%">
                <thead>
                    <tr>
                        <th class="text-center">ID</th>
                        <th>DOCUMENTO</th>
                        <th>NOMBRE COMPLETO</th>
                        <th>EMAIL</th>
                        <th>ROL</th>
                        <th>ESTADO</th>
                        <th class="text-center">ACCIONES</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Usuario u : usuarios) { 
                        String rolDb = u.getRol().toDb();
                        String estadoDb = u.getEstado().toDb();
                        
                        String rolClass = "";
                        if ("admin".equals(rolDb)) {
                            rolClass = "rol-admin";
                        } else if ("bibliotecario".equals(rolDb)) {
                            rolClass = "rol-bibliotecario";
                        } else {
                            rolClass = "rol-lector";
                        }
                        
                        String estadoClass = "";
                        if ("activo".equals(estadoDb)) {
                            estadoClass = "estado-activo";
                        } else if ("inactivo".equals(estadoDb)) {
                            estadoClass = "estado-inactivo";
                        } else if ("suspendido".equals(estadoDb)) {
                            estadoClass = "estado-suspendido";
                        }
                        
                        String iniciales = "";
                        if (u.getNombres() != null && !u.getNombres().isEmpty()) {
                            iniciales += u.getNombres().charAt(0);
                        }
                        if (u.getApellidos() != null && !u.getApellidos().isEmpty()) {
                            iniciales += u.getApellidos().charAt(0);
                        }
                        iniciales = iniciales.toUpperCase();
                    %>
                    <tr>
                        <td class="text-center">
                            <div class="d-flex justify-content-center">
                                <div class="user-avatar"><%= iniciales %></div>
                            </div>
                            <span class="font-mono text-gold d-block mt-1" style="font-size: 0.8rem;">#<%= u.getId() %></span>
                        </td>
                        <td class="font-mono"><%= u.getCedula() %></td>
                        <td class="fw-bold">
                            <%= u.getNombres() %> <%= u.getApellidos() %>
                        </td>
                        <td class="font-mono" style="font-size: 0.9rem;"><%= u.getEmail() %></td>
                        <td>
                            <span class="badge-rol <%= rolClass %>">
                                <%= rolDb %>
                            </span>
                        </td>
                        <td>
                            <span class="badge-rol <%= estadoClass %>">
                                <%= estadoDb %>
                            </span>
                        </td>
                        <td class="text-center">
                            <div class="d-flex gap-2 justify-content-center">
                                <a href="<%= request.getContextPath() %>/dashboard?action=editar&id=<%= u.getId() %>" 
                                   class="btn-gold" style="padding: 0.4rem 0.8rem; font-size: 0.85rem;" title="Editar Usuario">
                                    <iconify-icon icon="solar:pen-bold"></iconify-icon>
                                </a>
                                
                                <form method="get" action="<%= request.getContextPath() %>/dashboard" style="display: inline;">
                                    <input type="hidden" name="action" value="eliminar">
                                    <input type="hidden" name="id" value="<%= u.getId() %>">
                                    <button type="submit" class="btn-danger-glass" 
                                            style="padding: 0.4rem 0.8rem; font-size: 0.85rem;"
                                            onclick="return confirm('¿Eliminar permanentemente al usuario <%= u.getNombres() %> <%= u.getApellidos() %>?')"
                                            title="Eliminar Usuario">
                                        <iconify-icon icon="solar:trash-bin-trash-bold"></iconify-icon>
                                    </button>
                                </form>
                            </div>
                        </td>
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
    $('#tablaUsuarios').DataTable({
        pageLength: 10,
        ordering: true,
        language: {
            url: "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json",
            search: "BUSCAR USUARIO:",
            lengthMenu: "Mostrar _MENU_ registros",
            info: "Mostrando _START_ a _END_ de _TOTAL_ usuarios"
        },
        columnDefs: [
            { orderable: false, targets: 6 } // Desactivar ordenar en columna Acciones
        ]
    });
});
</script>
    <!-- CHATBOT: JS autocontenido (IIFE para no contaminar scope global) -->
<script>
(function() {
    // === CONFIG ===
    var ARS_CONTEXT = '<%= request.getContextPath() %>';
    var ARS_USER = var ARS_USER = '<%= ((sena.adso.model.Usuario)session.getAttribute("usuarioActivo")) != null ? ((sena.adso.model.Usuario)session.getAttribute("usuarioActivo")).getNombres().split(" ")[0] : "extrano" %>';

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