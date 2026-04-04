<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Matrix 3D Configurable</title>
    
    <!-- Tailwind CDN (para desarrollo) -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Hebrew:wght@400;700&display=swap" rel="stylesheet">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            background: #000000;
            overflow: hidden; /* Sin scroll */
            height: 100vh;
            width: 100vw;
        }

        .matrix-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 10;
        }

        .matrix-layer {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            transition: transform 0.15s ease-out;
            will-change: transform;
        }

        /* Capa Back: 75% opacidad - Azul */
        .matrix-back {
            z-index: 11;
            opacity: 9;
        }

        /* Capa Mid: 55% opacidad - Verde */
        .matrix-mid {
            z-index: 12;
            opacity: 0.6;
        }

        /* Capa Front: 45% opacidad - Rojo */
        .matrix-front {
            z-index: 13;
            opacity: 0.5;
        }

        .content-layer {
            position: relative;
            z-index: 20;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-family: sans-serif;
        }
    </style>
</head>
<body>

    <div class="matrix-container">
        <canvas id="matrix-back" class="matrix-layer matrix-back"></canvas>
        <canvas id="matrix-mid" class="matrix-layer matrix-mid"></canvas>
        <canvas id="matrix-front" class="matrix-layer matrix-front"></canvas>
    </div>

    <div class="content-layer">
        <div class="text-center p-8 bg-black/80 backdrop-blur rounded-2xl border border-white/10">
            <h1 class="text-5xl font-bold mb-4 text-white tracking-wider">SISTEMA MVC</h1>
            <p class="text-gray-400 font-mono">Mueve el mouse para ver el efecto 3D</p>
        </div>
    </div>

    <script>
        /* ============================================
           CONFIGURACIÓN DE CAPAS (Editar estos valores)
           ============================================ */
        const LAYER_CONFIG = [
            {
                id: 'matrix-back',
                name: 'BACK',
                parallaxSpeed: 0.01,    // Lento (lejos)
                fontSize: 24,
                fallSpeed: 0.5,
                colorHead: '#00ffff',    // Cyan
                colorBody: '#0088ff',    // Azul
                colorTail: '#002244',    // Azul oscuro
                opacityHead: 1.0,
                opacityBody: 0.7,
                opacityTail: 0.3
            },
            {
                id: 'matrix-mid',
                name: 'MID',
                parallaxSpeed: 0.03,    // Medio
                fontSize: 40,
                fallSpeed: 0.23,
                colorHead: '#ffffff',    // Blanco
                colorBody: '#00ff41',    // Verde Matrix
                colorTail: '#004400',    // Verde oscuro
                opacityHead: 1.0,
                opacityBody: 0.8,
                opacityTail: 0.4
            },
            {
                id: 'matrix-front',
                name: 'FRONT',
                parallaxSpeed: 0.06,    // Rápido (cerca)
                fontSize: 70,
                fallSpeed: 0.1,
                colorHead: '#ff0080',    // Rosa/Magenta
                colorBody: '#ff0040',    // Rojo
                colorTail: '#440011',    // Rojo oscuro
                opacityHead: 1.0,
                opacityBody: 0.9,
                opacityTail: 0.5
            }
        ];

        const HEBREW_CHARS = 'אבגדהוזחטיכלמנסעפצקרשת' + 
                            'ךםןףץ' + 
                            'יהוה' + 
                            'אלכימיהספירות';

        /* ============================================
           VARIABLES GLOBALES
           ============================================ */
        let layers = [];                    // Array de objetos capa
        let currentPos = [];                // Posiciones actuales del parallax
        let mouseX = 0, mouseY = 0;         // Posición del mouse
        let animationId = null;             // ID para cancelar animación si es necesario

        /* ============================================
           INICIALIZACIÓN
           ============================================ */
        function init() {
            // 1. Inicializar arrays de posición basados en la configuración
            currentPos = LAYER_CONFIG.map(() => ({ x: 0, y: 0 }));
            
            // 2. Crear capas
            LAYER_CONFIG.forEach((config, index) => {
                const canvas = document.getElementById(config.id);
                if (!canvas) {
                    console.error(`Canvas #${config.id} no encontrado`);
                    return;
                }
                
                const ctx = canvas.getContext('2d');
                
                const layer = {
                    canvas: canvas,
                    ctx: ctx,
                    config: config,
                    drops: [],
                    columns: 0
                };
                
                resizeLayer(layer);
                layers.push(layer);
            });
            
            // 3. Verificar que todo esté correcto
            if (layers.length !== currentPos.length) {
                console.error('Error: Mismatch entre layers y currentPos');
                return;
            }
            
            // 4. Iniciar eventos
            setupEvents();
            
            // 5. Iniciar loop
            animate();
            
            console.log(`Inicializadas ${layers.length} capas correctamente`);
        }

        /* ============================================
           RESIZE
           ============================================ */
        function resizeLayer(layer) {
            const { canvas, config } = layer;
            
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
            layer.columns = Math.floor(canvas.width / config.fontSize);
            
            // Reiniciar gotas
            layer.drops = [];
            for (let i = 0; i < layer.columns; i++) {
                layer.drops[i] = Math.random() * -100;
            }
        }

        function handleResize() {
            layers.forEach(resizeLayer);
        }

        /* ============================================
           EVENTOS
           ============================================ */
        function setupEvents() {
            // Mouse move con throttling básico
            let ticking = false;
            
            document.addEventListener('mousemove', (e) => {
                if (!ticking) {
                    window.requestAnimationFrame(() => {
                        const centerX = window.innerWidth / 2;
                        const centerY = window.innerHeight / 2;
                        mouseX = e.clientX - centerX;
                        mouseY = e.clientY - centerY;
                        ticking = false;
                    });
                    ticking = true;
                }
            });
            
            // Resize
            window.addEventListener('resize', handleResize);
        }

        /* ============================================
           PARALLAX
           ============================================ */
        function updateParallax() {
            // Validación de seguridad
            if (!layers.length || !currentPos.length) return;
            
            layers.forEach((layer, index) => {
                // Validar que existe la posición
                if (!currentPos[index]) {
                    currentPos[index] = { x: 0, y: 0 };
                }
                
                const speed = layer.config.parallaxSpeed;
                const targetX = mouseX * speed;
                const targetY = mouseY * speed;
                
                // Suavizado (lerp)
                const smoothFactor = 0.12;
                currentPos[index].x += (targetX - currentPos[index].x) * smoothFactor;
                currentPos[index].y += (targetY - currentPos[index].y) * smoothFactor;
                
                // Aplicar transform
                const x = currentPos[index].x;
                const y = currentPos[index].y;
                layer.canvas.style.transform = `translate3d(${x}px, ${y}px, 0)`;
            });
        }

        /* ============================================
           DIBUJO
           ============================================ */
        function drawMatrix(layer) {
            const { ctx, canvas, config, drops } = layer;
            const { fontSize, fallSpeed, colorHead, colorBody, colorTail, 
                    opacityHead, opacityBody, opacityTail } = config;
            
            // Trail
            ctx.fillStyle = 'rgba(0, 0, 0, 0.08)';
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            
            ctx.font = `${fontSize}px "Noto Sans Hebrew", monospace`;
            
            for (let i = 0; i < drops.length; i++) {
                const char = HEBREW_CHARS[Math.floor(Math.random() * HEBREW_CHARS.length)];
                const x = i * fontSize;
                const y = drops[i] * fontSize;
                
                // Determinar tipo de carácter
                const rand = Math.random();
                let color, alpha;
                
                if (rand > 0.95) {
                    color = colorHead;
                    alpha = opacityHead;
                } else if (rand > 0.70) {
                    color = colorBody;
                    alpha = opacityBody;
                } else {
                    color = colorTail;
                    alpha = opacityTail;
                }
                
                ctx.globalAlpha = alpha;
                ctx.fillStyle = color;
                ctx.fillText(char, x, y);
                
                // Reset
                if (y > canvas.height && Math.random() > 0.975) {
                    drops[i] = 0;
                }
                
                drops[i] += fallSpeed * 0.5;
            }
            
            ctx.globalAlpha = 1.0;
        }

        /* ============================================
           ANIMACIÓN
           ============================================ */
        function animate() {
            try {
                updateParallax();
                layers.forEach(drawMatrix);
                animationId = requestAnimationFrame(animate);
            } catch (error) {
                console.error('Error en animación:', error);
                if (animationId) cancelAnimationFrame(animationId);
            }
        }

        /* ============================================
           ARRANQUE
           ============================================ */
        // Esperar a que DOM esté listo
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', init);
        } else {
            init();
        }
    </script>
</body>
</html>