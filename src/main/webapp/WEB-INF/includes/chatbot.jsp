<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="sena.adso.model.Usuario" %>

<%
    Usuario userChat = (Usuario) session.getAttribute("usuarioActivo");
    String nombreUser = "extraño";
    if (userChat != null && userChat.getNombres() != null && !userChat.getNombres().trim().isEmpty()) {
        nombreUser = userChat.getNombres().split(" ")[0];
    }
%>

<!-- CHATBOT BIBLIOTECARIO PEREZOSO - Include Autocontenido -->
<div id="ars-chat-widget" style="
    position: fixed;
     
    bottom: 30px; 
    right: 30px; 
    z-index: 9999; 
    font-family: 'JetBrains Mono', monospace;
">
    
    <!-- Botón flotante -->
    <button onclick="toggleARSChat()" style="
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
        font-size: 1.8rem;
        box-shadow: 0 4px 20px rgba(201, 176, 55, 0.3);
    " onmouseover="this.style.transform='scale(1.1) rotate(10deg)'; this.style.background='rgba(201, 176, 55, 0.3)'" 
       onmouseout="this.style.transform='scale(1) rotate(0deg)'; this.style.background='rgba(201, 176, 55, 0.15)'">
        <span style="font-size: 1.5rem;">📚</span>
    </button>

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
        <div style="
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
                ">😴</div>
                <div>
                    <div style="color: #c9b037; font-weight: 700; font-size: 0.95rem;">Don Archibaldo</div>
                    <div style="color: #666; font-size: 0.7rem;">Bibliotecario · <span id="ars-status">durmiendo</span></div>
                </div>
            </div>
            <button onclick="toggleARSChat()" style="
                background: none; border: none; color: #888; 
                font-size: 1.5rem; cursor: pointer; padding: 0; width: 30px;
            " onmouseover="this.style.color='#c9b037'" onmouseout="this.style.color='#888'">×</button>
        </div>

        <!-- Área de mensajes -->
        <div id="ars-messages" style="
            flex: 1; 
            overflow-y: auto; 
            padding: 1.2rem;
            display: flex; 
            flex-direction: column; 
            gap: 1rem;
            background: rgba(0,0,0,0.3);
        ">
            <!-- Mensaje inicial del bibliotecario perezoso -->
            <div style="
                max-width: 85%; 
                padding: 1rem;
                background: rgba(255,255,255,0.05);
                border: 1px solid rgba(255,255,255,0.1);
                border-radius: 15px 15px 15px 5px;
                color: #ccc;
                font-size: 0.9rem;
                line-height: 1.5;
                align-self: flex-start;
            ">
                *<em>bosteza</em>*<br><br>
                Ah... eres tú, <%= nombreUser %>. ¿Qué quieres? Estaba teniendo un sueño muy agradable sobre un mundo sin usuarios que pierden libros...<br><br>
                Pregunta rápido, que tengo que inventariar 200 volúmenes y honestamente no me apetece.
            </div>
        </div>

        <!-- Input -->
        <div style="
            padding: 1rem; 
            border-top: 1px solid rgba(201, 176, 55, 0.3);
            background: rgba(0,0,0,0.5);
            display: flex; 
            gap: 0.5rem;
        ">
            <input type="text" id="ars-input" placeholder="Pregunta algo fácil, por favor..." style="
                flex: 1; 
                background: rgba(255,255,255,0.05);
                border: 1px solid rgba(201, 176, 55, 0.3);
                border-radius: 25px;
                padding: 0.8rem 1.2rem;
                color: #fff;
                font-family: inherit;
                font-size: 0.9rem;
                outline: none;
            " onkeypress="if(event.key==='Enter') sendARSMessage()">
            
            <button onclick="sendARSMessage()" style="
                width: 45px; height: 45px;
                border-radius: 50%;
                background: #c9b037;
                border: none;
                color: #000;
                cursor: pointer;
                display: flex; align-items: center; justify-content: center;
                font-size: 1.2rem;
                transition: all 0.3s;
            " onmouseover="this.style.transform='scale(1.1)'" onmouseout="this.style.transform='scale(1)'">
                ➤
            </button>
        </div>
        
        <!-- Typing indicator (oculto por defecto) -->
        <div id="ars-typing" style="
            display: none;
            padding: 0 1.2rem 0.5rem;
            color: #666;
            font-size: 0.8rem;
            font-style: italic;
        ">
            Don Archibaldo está buscando en sus notas...
        </div>
    </div>
</div>

<style>
/* Scrollbar personalizado para el chat */
#ars-messages::-webkit-scrollbar {
    width: 6px;
}
#ars-messages::-webkit-scrollbar-track {
    background: rgba(0,0,0,0.2);
    border-radius: 3px;
}
#ars-messages::-webkit-scrollbar-thumb {
    background: rgba(201, 176, 55, 0.3);
    border-radius: 3px;
}
#ars-messages::-webkit-scrollbar-thumb:hover {
    background: rgba(201, 176, 55, 0.5);
}

/* Animación de entrada para mensajes */
@keyframes ars-fade-in {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}
.ars-msg-anim {
    animation: ars-fade-in 0.3s ease;
}
</style>

<script>
let arsChatOpen = false;

function toggleARSChat() {
    const window = document.getElementById('ars-chat-window');
    const status = document.getElementById('ars-status');
    
    arsChatOpen = !arsChatOpen;
    window.style.display = arsChatOpen ? 'flex' : 'none';
    status.innerText = arsChatOpen ? 'molesto' : 'durmiendo';
    
    if (arsChatOpen) {
        document.getElementById('ars-input').focus();
    }
}

async function sendARSMessage() {
    const input = document.getElementById('ars-input');
    const msg = input.value.trim();
    if (!msg) return;
    
    const chatBox = document.getElementById('ars-messages');
    const typing = document.getElementById('ars-typing');
    
    // Mensaje del usuario (derecha)
    chatBox.innerHTML += `
        <div class="ars-msg-anim" style="
            max-width: 85%; 
            padding: 1rem;
            background: rgba(201, 176, 55, 0.15);
            border: 1px solid rgba(201, 176, 55, 0.4);
            border-radius: 15px 15px 5px 15px;
            color: #fff;
            font-size: 0.9rem;
            align-self: flex-end;
        ">${escapeHtml(msg)}</div>
    `;
    
    input.value = '';
    chatBox.scrollTop = chatBox.scrollHeight;
    
    // Mostrar "escribiendo..."
    typing.style.display = 'block';
    
    try {
        const response = await fetch('<%= request.getContextPath() %>/chatbot', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({
                question: msg,
                user: '<%= nombreUser %>'
            })
        });
        
        const data = await response.json();
        
        // Ocultar typing y mostrar respuesta con delay para simular pereza
        setTimeout(() => {
            typing.style.display = 'none';
            chatBox.innerHTML += `
                <div class="ars-msg-anim" style="
                    max-width: 85%; 
                    padding: 1rem;
                    background: rgba(255,255,255,0.05);
                    border: 1px solid rgba(255,255,255,0.1);
                    border-radius: 15px 15px 15px 5px;
                    color: #ccc;
                    font-size: 0.9rem;
                    line-height: 1.5;
                    align-self: flex-start;
                ">${data.answer}</div>
            `;
            chatBox.scrollTop = chatBox.scrollHeight;
        }, 1000 + Math.random() * 1000); // Delay de 1-2 segundos (pereza)
        
    } catch (e) {
        typing.style.display = 'none';
        chatBox.innerHTML += `
            <div class="ars-msg-anim" style="
                max-width: 85%; 
                padding: 1rem;
                background: rgba(255,0,0,0.1);
                border: 1px solid rgba(255,0,0,0.3);
                border-radius: 15px;
                color: #ff6b6b;
                font-size: 0.9rem;
                align-self: flex-start;
            ">
                *<em>suspira</em>*<br>
                Mira, mi cerebro dejó de funcionar temporalmente... vuelve a intentarlo o pregúntale a otro. Yo no fui.
            </div>
        `;
        chatBox.scrollTop = chatBox.scrollHeight;
    }
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Cerrar al hacer click fuera
document.addEventListener('click', function(event) {
    const widget = document.getElementById('ars-chat-widget');
    if (arsChatOpen && !widget.contains(event.target)) {
        toggleARSChat();
    }
});
</script>