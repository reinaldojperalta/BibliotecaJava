<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="sena.adso.model.Libro" %>
<%@ page import="sena.adso.model.Editorial" %>
<%@ page import="sena.adso.model.Categoria" %>
<%@ page import="sena.adso.model.Usuario" %>
<%@ page import="sena.adso.model.enums.EstadoLibro" %>
<%@ page import="java.util.List" %>

<%
    Usuario usuarioActivo = (Usuario) session.getAttribute("usuarioActivo");
    String rolLibrosStr = usuarioActivo.getRol().toDb();
    boolean esEditor = "admin".equals(rolLibrosStr) || "bibliotecario".equals(rolLibrosStr);

    List<Libro> libros = (List<Libro>) request.getAttribute("libros");
    List<Editorial> editoriales = (List<Editorial>) request.getAttribute("editoriales");
    List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
    Libro libroEditar = (Libro) request.getAttribute("libro");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catálogo de Libros - ARS BIBLIOTECA</title>
    
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;600;700;800&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <!-- DataTables -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    
    <style>
        /* Override para fuente más legible en este módulo */
        body {
            font-family: 'Inter', sans-serif;
            font-size: 1rem;
            line-height: 1.6;
        }
        
        .font-mono {
            font-family: 'JetBrains Mono', monospace;
        }
        
        /* Títulos grandes y nítidos */
        .page-title {
            font-family: 'Montserrat', sans-serif;
            font-weight: 800;
            font-size: 2rem;
            letter-spacing: -0.5px;
        }
        
        /* Glass Card mejorado */
        .glass-card {
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(201, 176, 55, 0.15);
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }
        
        /* Formulario tipo grid */
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
        
        /* Badges de estado */
        .estado-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .estado-disponible { 
            background: rgba(40, 167, 69, 0.2); 
            color: #28a745; 
            border: 1px solid rgba(40, 167, 69, 0.4);
        }
        .estado-prestado { 
            background: rgba(255, 193, 7, 0.2); 
            color: #ffc107; 
            border: 1px solid rgba(255, 193, 7, 0.4);
        }
        .estado-mantenimiento { 
            background: rgba(255, 123, 0, 0.2); 
            color: #ff7b00; 
            border: 1px solid rgba(255, 123, 0, 0.4);
        }
        .estado-baja { 
            background: rgba(220, 53, 69, 0.2); 
            color: #dc3545; 
            border: 1px solid rgba(220, 53, 69, 0.4);
        }
        
        /* Botones de acción */
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
        }
        
        .btn-danger-glass:hover {
            background: #dc3545;
            color: #fff;
        }
        
        .btn-success-glass {
            background: rgba(40, 167, 69, 0.2);
            border: 1px solid #28a745;
            color: #28a745;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            transition: all 0.3s ease;
        }
        
        .btn-success-glass:hover {
            background: #28a745;
            color: #fff;
        }
        
        /* Tabla más legible */
        .table-glass {
            font-size: 0.95rem;
        }
        
        .table-glass th {
            font-family: 'Montserrat', sans-serif;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 0.85rem;
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
        <div class="alert glass-card border-success text-success mb-4" style="background: rgba(40, 167, 69, 0.1);">
            <iconify-icon icon="solar:check-circle-bold" class="me-2"></iconify-icon>
            <%= request.getParameter("msg") %>
        </div>
    <% } %>

    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mt-5 mb-5">
        <div>
            <span class="d-block mb-2 text-uppercase" style="color: #888; font-size: 0.85rem; letter-spacing: 3px;">
                Inventario Documental
            </span>
            <h1 class="page-title text-gold m-0 glow-text">
                <%= libroEditar != null ? "EDITAR VOLUMEN" : "CATÁLOGO GENERAL" %>
            </h1>
        </div>
        <% if (esEditor) { %>
            <span class="badge border border-gold text-gold p-2 font-mono" style="letter-spacing: 2px;">
                MODO EDICIÓN ACTIVO
            </span>
        <% } %>
    </div>

    <!-- Formulario CREAR / EDITAR (solo admin y bibliotecario) -->
    <% if (esEditor) { %>
    <div class="glass-card p-4 mb-5">
        <h3 class="text-gold mb-4 font-mono" style="font-size: 1.1rem; letter-spacing: 1px;">
            <iconify-icon icon="solar:pen-new-square-bold" class="me-2"></iconify-icon>
            <%= libroEditar != null ? "MODIFICAR REGISTRO #" + libroEditar.getId() : "NUEVO REGISTRO" %>
        </h3>
        
        <form method="post" action="<%= request.getContextPath() %>/libros">
            <input type="hidden" name="action" value="<%= libroEditar != null ? "actualizar" : "crear" %>">
            <% if (libroEditar != null) { %>
                <input type="hidden" name="id" value="<%= libroEditar.getId() %>">
            <% } %>

            <div class="form-grid">
                <div class="form-group">
                    <label>Título del Volumen</label>
                    <input type="text" name="titulo" class="form-control" required 
                           value="<%= libroEditar != null ? libroEditar.getTitulo() : "" %>"
                           placeholder="Ingrese el título completo">
                </div>

                <div class="form-group">
                    <label>ISBN</label>
                    <input type="text" name="isbn" class="form-control" 
                           value="<%= libroEditar != null ? libroEditar.getIsbn() : "" %>"
                           placeholder="978-3-16-148410-0">
                </div>

                <div class="form-group">
                    <label>Año de Publicación</label>
                    <input type="number" name="anioPublicacion" class="form-control" 
                           value="<%= libroEditar != null ? libroEditar.getAnioPublicacion() : "" %>"
                           placeholder="2024">
                </div>

                <div class="form-group">
                    <label>Número de Páginas</label>
                    <input type="number" name="numPaginas" class="form-control" 
                           value="<%= libroEditar != null ? libroEditar.getNumPaginas() : "" %>"
                           placeholder="0">
                </div>

                <div class="form-group">
                    <label>Editorial</label>
                    <select name="idEditorial" class="form-select">
                        <% if (editoriales != null) for (Editorial e : editoriales) { %>
                            <option value="<%= e.getId() %>"
                                <%= libroEditar != null && libroEditar.getIdEditorial() == e.getId() ? "selected" : "" %>>
                                <%= e.getNombre() %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Categoría</label>
                    <select name="idCategoria" class="form-select">
                        <% if (categorias != null) for (Categoria c : categorias) { %>
                            <option value="<%= c.getId() %>"
                                <%= libroEditar != null && libroEditar.getIdCategoria() == c.getId() ? "selected" : "" %>>
                                <%= c.getNombre() %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Estado Actual</label>
                    <select name="estado" class="form-select">
                        <% 
                            String estadoLibroActual = libroEditar != null ? libroEditar.getEstado().toDb() : "disponible";
                        %>
                        <option value="disponible" <%= "disponible".equals(estadoLibroActual) ? "selected" : "" %>>Disponible</option>
                        <option value="prestado" <%= "prestado".equals(estadoLibroActual) ? "selected" : "" %>>Prestado</option>
                        <option value="mantenimiento" <%= "mantenimiento".equals(estadoLibroActual) ? "selected" : "" %>>Mantenimiento</option>
                        <option value="dado_de_baja" <%= "dado_de_baja".equals(estadoLibroActual) ? "selected" : "" %>>Dado de Baja</option>
                    </select>
                </div>
            </div>

            <div class="mt-4 d-flex gap-3">
                <button type="submit" class="btn-gold">
                    <iconify-icon icon="solar:disk-bold"></iconify-icon>
                    <%= libroEditar != null ? "ACTUALIZAR REGISTRO" : "GUARDAR NUEVO" %>
                </button>
                <% if (libroEditar != null) { %>
                    <a href="<%= request.getContextPath() %>/libros?action=listar" class="btn-gold" style="background: transparent; color: #888; border-color: #555;">
                        <iconify-icon icon="solar:close-circle-bold"></iconify-icon>
                        Cancelar
                    </a>
                <% } %>
            </div>
        </form>
    </div>
    <% } %>

    <!-- Listado de Libros -->
    <div class="glass-card p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="text-gold m-0 font-mono" style="font-size: 1.1rem; letter-spacing: 1px;">
                <iconify-icon icon="solar:book-bold" class="me-2"></iconify-icon>
                REGISTROS BIBLIOGRÁFICOS
            </h3>
            <span class="text-muted font-mono" style="font-size: 0.85rem;">
                TOTAL: <%= libros != null ? libros.size() : 0 %> volúmenes
            </span>
        </div>
        
        <% if (libros == null || libros.isEmpty()) { %>
            <div class="text-center py-5">
                <iconify-icon icon="solar:box-minimalistic-bold" style="font-size: 3rem; color: #555;"></iconify-icon>
                <p class="text-muted mt-3">No hay registros en el sistema.</p>
            </div>
        <% } else { %>
        <div class="table-responsive">
            <table id="tablaLibros" class="table table-dark table-hover align-middle table-glass" style="width:100%">
                <thead>
                    <tr>
                        <th class="text-gold">ID</th>
                        <th class="text-gold">VOLUMEN</th>
                        <th class="text-gold">ISBN</th>
                        <th class="text-gold">AÑO</th>
                        <th class="text-gold">ESTADO</th>
                        <th class="text-gold text-center">ACCIONES</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Libro l : libros) { 
                        String estadoClass = "";
                        String estadoDb = l.getEstado().toDb();
                        String estadoText = estadoDb.replace("_", " ");
                        
                        if ("disponible".equals(estadoDb)) {
                            estadoClass = "estado-disponible";
                        } else if ("prestado".equals(estadoDb)) {
                            estadoClass = "estado-prestado";
                        } else if ("mantenimiento".equals(estadoDb)) {
                            estadoClass = "estado-mantenimiento";
                        } else if ("dado_de_baja".equals(estadoDb)) {
                            estadoClass = "estado-baja";
                        }
                    %>
                    <tr>
                        <td class="font-mono text-gold">#<%= l.getId() %></td>
                        <td class="fw-bold"><%= l.getTitulo() %></td>
                        <td class="font-mono text-gold"><%= l.getIsbn() != null ? l.getIsbn() : "N/A" %></td>
                        <td><%= l.getAnioPublicacion() %></td>
                        <td>
                            <span class="estado-badge <%= estadoClass %>">
                                <%= estadoText %>
                            </span>
                        </td>
                        <td class="text-center">
                            <div class="d-flex gap-2 justify-content-center">
                                <% if (esEditor) { %>
                                    <a href="<%= request.getContextPath() %>/libros?action=editar&id=<%= l.getId() %>" 
                                       class="btn-gold" style="padding: 0.4rem 0.8rem; font-size: 0.85rem;">
                                        <iconify-icon icon="solar:pen-bold"></iconify-icon>
                                    </a>
                                    
                                    <form method="get" action="<%= request.getContextPath() %>/libros" style="display: inline;">
                                        <input type="hidden" name="action" value="eliminar">
                                        <input type="hidden" name="id" value="<%= l.getId() %>">
                                        <button type="submit" class="btn-danger-glass" 
                                                style="padding: 0.4rem 0.8rem; font-size: 0.85rem;"
                                                onclick="return confirm('¿Eliminar permanentemente este registro?')">
                                            <iconify-icon icon="solar:trash-bin-trash-bold"></iconify-icon>
                                        </button>
                                    </form>
                                <% } %>
                                
                                <% if ("lector".equals(rolLibrosStr) && "disponible".equals(l.getEstado().toDb())) { %>
                                    <form method="post" action="<%= request.getContextPath() %>/libros" style="display: inline;">
                                        <input type="hidden" name="action" value="asignar">
                                        <input type="hidden" name="idLibro" value="<%= l.getId() %>">
                                        <button type="submit" class="btn-success-glass" style="padding: 0.4rem 0.8rem; font-size: 0.85rem;">
                                            <iconify-icon icon="solar:book-bookmark-bold" class="me-1"></iconify-icon>
                                            Reservar
                                        </button>
                                    </form>
                                <% } %>
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
    // Inicializar DataTable con estilo glass
    $('#tablaLibros').DataTable({
        pageLength: 10,
        ordering: true,
        language: {
            url: "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json",
            search: "BUSCAR VOLUMEN:",
            lengthMenu: "Mostrar _MENU_ registros",
            info: "Mostrando _START_ a _END_ de _TOTAL_ volúmenes"
        },
        columnDefs: [
            { orderable: false, targets: 5 } // Desactivar ordenar en columna Acciones
        ]
    });
    
    // Hack para glass en filas (si el CSS externo no pega)
    setTimeout(function() {
        $('table.dataTable tbody tr').css({
            'background': 'rgba(255, 255, 255, 0.03)',
            'backdrop-filter': 'blur(5px)'
        });
    }, 100);
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