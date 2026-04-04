<%@ page contentType="text/html; charset=UTF-8" language="java" %>


<div id="matrix-bg-system" aria-hidden="true">
    <canvas id="matrix-back" class="matrix-layer" data-layer="back"></canvas>
    <canvas id="matrix-mid" class="matrix-layer" data-layer="mid"></canvas>
    <canvas id="matrix-front" class="matrix-layer" data-layer="front"></canvas>
</div>

<style>
    /* Contenedor principal - Fixed detrás de todo */
    #matrix-bg-system {
        position: fixed;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        pointer-events: none; /* Deja pasar clicks al contenido */
        z-index: -1; /* Detrás de todo el contenido */
        overflow: hidden;
        background-color: #050505;
    }
    
    /* Reset de canvas para evitar conflictos con otros estilos */
    #matrix-bg-system canvas {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        margin: 0;
        padding: 0;
        border: none;
        display: block;
        /* Performance optimizaciones */
        will-change: transform; 
        backface-visibility: hidden;
        transform: translateZ(0);
    }
    
    /* Capa Back - Velocidad lenta, opaca */
    #matrix-back {
        z-index: 1;
        opacity: 1; /* 100% - Fondo sólido */
    }
    
    /* Capa Mid - Velocidad media, semi-transparente */
    #matrix-mid {
        z-index: 2;
        opacity: 0.4; /* 40% - Overlay medio */
    }
    
    /* Capa Front - Velocidad rápida, muy transparente */
    #matrix-front {
        z-index: 3;
        opacity: 0.2; /* 20% - Efecto cercano sutil */
    }
    
    /* Media query para reducir efecto en móviles (ahorro batería) */
    @media (hover: none) and (pointer: coarse) {
        #matrix-bg-system {
            opacity: 0.7; /* Más tenue en móviles */
        }
        #matrix-front { display: none; } /* Ocultar capa front en móvil */
    }
</style>

<script>

(function() {
    'use strict';
    
    // ==========================================
    // CONFIGURACIÓN (Tus valores funcionales)
    // ==========================================
    const CONFIG = {
        debug: false, // Cambiar a true para ver logs en consola
        hebrewChars: 'אבגדהוזחטיכלמנסעפצקרשתךםןףץיהוהאלכימיהספירות',
        layers: [
            {
                id: 'matrix-back',
                speed: 0.02,        // Parallax: Lento (lejos)
                fontSize: 30,       // Tamaño pequeño
                fallSpeed: 1,       // Caída lenta
                colorHead: '#FFD700' // Dorado
            },
            {
                id: 'matrix-mid',
                speed: 0.03,        // Parallax: Medio
                fontSize: 120,      // Grande
                fallSpeed: 1.4,     // Caída media
                colorHead: '#FFD700'
            },
            {
                id: 'matrix-front',
                speed: 0.05,        // Parallax: Rápido (cerca)
                fontSize: 180,      // Muy grande
                fallSpeed: 1.9,     // Caída rápida
                colorHead: '#FFD700'
            }
        ]
    };
    
    // ==========================================
    // VARIABLES DEL SISTEMA
    // ==========================================
    let layers = [];
    let mouseX = 0;
    let mouseY = 0;
    let animationId = null;
    let isInitialized = false;
    
    // ==========================================
    // UTILIDADES
    // ==========================================
    function log(msg, data) {
        if (CONFIG.debug && console) {
            console.log('[MatrixBG]', msg, data || '');
        }
    }
    
    // ==========================================
    // INICIALIZACIÓN DE CAPAS
    // ==========================================
    function initLayers() {
        const container = document.getElementById('matrix-bg-system');
        if (!container) {
            console.error('[MatrixBG] Error: Contenedor no encontrado');
            return false;
        }
        
        CONFIG.layers.forEach((cfg, index) => {
            const canvas = document.getElementById(cfg.id);
            if (!canvas) {
                log('Canvas no encontrado:', cfg.id);
                return;
            }
            
            const ctx = canvas.getContext('2d');
            if (!ctx) {
                log('Contexto 2D no disponible');
                return;
            }
            
            // Objeto de capa
            const layer = {
                canvas: canvas,
                ctx: ctx,
                config: cfg,
                drops: [],
                charStorage: [],
                columns: 0,
                // Para el parallax suavizado
                currentX: 0,
                currentY: 0
            };
            
            resizeLayer(layer);
            layers.push(layer);
            log(`Capa ${index + 1} inicializada:`, cfg.id);
        });
        
        return layers.length > 0;
    }
    
    // ==========================================
    // RESIZE RESPONSIVO
    // ==========================================
    function resizeLayer(layer) {
        // Guardar dimensiones actuales
        const oldWidth = layer.canvas.width;
        
        // Ajustar a ventana actual
        layer.canvas.width = window.innerWidth;
        layer.canvas.height = window.innerHeight;
        
        // Recalcular columnas según nuevo ancho
        layer.columns = Math.ceil(layer.canvas.width / layer.config.fontSize);
        
        // Reinicializar gotas solo si es necesario (primera vez o cambio drástico)
        if (layer.drops.length === 0 || Math.abs(oldWidth - layer.canvas.width) > 100) {
            layer.drops = new Array(layer.columns);
            for (let i = 0; i < layer.columns; i++) {
                // Posiciones aleatorias iniciales para desincronizar
                layer.drops[i] = Math.random() * -layer.canvas.height;
            }
            layer.charStorage = new Array(layer.columns).fill(null);
        }
    }
    
    function handleResize() {
        layers.forEach(resizeLayer);
        log('Resize ejecutado');
    }
    
    // ==========================================
    // SISTEMA PARALLAX (Mouse)
    // ==========================================
    function setupEvents() {
        // Capturar movimiento del mouse
        document.addEventListener('mousemove', function(e) {
            const centerX = window.innerWidth / 2;
            const centerY = window.innerHeight / 2;
            mouseX = e.clientX - centerX;
            mouseY = e.clientY - centerY;
        }, { passive: true });
        
        // Resize responsivo con debounce
        let resizeTimer;
        window.addEventListener('resize', function() {
            clearTimeout(resizeTimer);
            resizeTimer = setTimeout(handleResize, 250);
        }, { passive: true });
        
        // Pausar cuando la pestaña no está visible (ahorro CPU)
        document.addEventListener('visibilitychange', function() {
            if (document.hidden) {
                pauseAnimation();
            } else {
                resumeAnimation();
            }
        });
    }
    
    function updateParallax() {
        layers.forEach(function(layer) {
            const targetX = mouseX * layer.config.speed;
            const targetY = mouseY * layer.config.speed;
            
            // Interpolación suave (lerp) para movimiento fluido
            layer.currentX += (targetX - layer.currentX) * 0.12;
            layer.currentY += (targetY - layer.currentY) * 0.12;
            
            // Aplicar transformación directa (más rápido que CSS transitions)
            const transform = 'translate3d(' + layer.currentX.toFixed(2) + 'px, ' + 
                             layer.currentY.toFixed(2) + 'px, 0)';
            layer.canvas.style.transform = transform;
        });
    }
    
    // ==========================================
    // RENDERIZADO DEL MATRIX
    // ==========================================
    function drawMatrix(layer) {
        const ctx = layer.ctx;
        const canvas = layer.canvas;
        const cfg = layer.config;
        const drops = layer.drops;
        
        // Trail effect (rastro)
        ctx.fillStyle = 'rgba(0, 0, 0, 0.05)';
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        
        // Configurar fuente
        ctx.font = cfg.fontSize + 'px "Noto Sans Hebrew", monospace';
        ctx.textAlign = 'left';
        ctx.textBaseline = 'top';
        
        // Dibujar cada columna
        for (let i = 0; i < drops.length; i++) {
            const x = i * cfg.fontSize;
            const y = drops[i];
            
            // Cambiar carácter aleatoriamente (efecto "digital")
            if (!layer.charStorage[i] || Math.random() > 0.8) {
                const charIndex = Math.floor(Math.random() * CONFIG.hebrewChars.length);
                layer.charStorage[i] = CONFIG.hebrewChars[charIndex];
            }
            
            const char = layer.charStorage[i];
            
            // Efecto neón/brillo
            ctx.shadowColor = '#ffaa42';
            ctx.shadowBlur = 15;
            
            // Gradiente dorado metálico
            const gradient = ctx.createLinearGradient(x, y, x, y + cfg.fontSize);
            gradient.addColorStop(0, '#FFFACD');   // Amarillo claro
            gradient.addColorStop(0.2, '#FFD700'); // Oro
            gradient.addColorStop(0.5, '#B8860B'); // Oro oscuro
            gradient.addColorStop(1, '#554000');   // Marrón dorado
            
            ctx.fillStyle = gradient;
            ctx.fillText(char, x, y);
            
            // Resetear shadow para performance
            ctx.shadowBlur = 0;
            
            // Actualizar posición de caída
            if (y > canvas.height) {
                drops[i] = Math.random() * -100; // Reset con offset aleatorio
            } else {
                drops[i] += cfg.fallSpeed;
            }
        }
    }
    
    // ==========================================
    // LOOP DE ANIMACIÓN
    // ==========================================
    function animate() {
        if (!isInitialized) return;
        
        updateParallax();
        layers.forEach(drawMatrix);
        
        animationId = requestAnimationFrame(animate);
    }
    
    function pauseAnimation() {
        if (animationId) {
            cancelAnimationFrame(animationId);
            animationId = null;
            log('Animación pausada (tab inactiva)');
        }
    }
    
    function resumeAnimation() {
        if (!animationId && isInitialized) {
            animate();
            log('Animación reanudada');
        }
    }
    
    // ==========================================
    // INICIALIZACIÓN GLOBAL
    // ==========================================
    function init() {
        // Evitar doble inicialización si el include se carga dos veces por error
        if (isInitialized || window.matrixBgInitialized) {
            log('Ya inicializado, ignorando...');
            return;
        }
        
        log('Iniciando sistema Matrix...');
        
        if (!initLayers()) {
            console.error('[MatrixBG] No se pudieron inicializar las capas');
            return;
        }
        
        setupEvents();
        isInitialized = true;
        window.matrixBgInitialized = true; // Flag global para evitar duplicados
        
        animate();
        log('Sistema iniciado correctamente');
    }
    
    // ==========================================
    // ARRANQUE
    // ==========================================
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        // DOM ya listo, iniciar inmediatamente
        init();
    }
    
})();
</script>