📚 ARS Biblioteca | Sistema de Gestión Documental

[![Java](https://img.shields.io/badge/Java-17-orange?style=for-the-badge&logo=java)](https://www.java.com/)
[![JSP](https://img.shields.io/badge/JSP-Servlets-blue?style=for-the-badge&logo=apache)](https://tomcat.apache.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?style=for-the-badge&logo=mysql)](https://www.mysql.com/)
[![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3-purple?style=for-the-badge&logo=bootstrap)](https://getbootstrap.com/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

> *"Custodiando el conocimiento con precisión absoluta desde 2026"*

Sistema integral de gestión bibliotecaria desarrollado para el **SENA ADSO**. ARS Biblioteca combina la robustez de Java EE con una interfaz futurista glassmorphism, ofreciendo control total sobre préstamos, inventario y usuarios con un toque esotérico-pagano.

![ARS Preview](https://via.placeholder.com/800x400/0a0a0a/c9b037?text=ARS+Biblioteca+Interface)

## ✨ Características Principales

### 🎨 Interfaz de Usuario
- **Diseño Glassmorphism**: Transparencias, blur y bordes dorados (#c9b037)
- **Tema Oscuro**: Estética cyberpunk/esotérica con Matrix background animado
- **Responsive**: Adaptable a móviles, tablets y desktop
- **Animaciones AOS**: Transiciones suaves al hacer scroll
- **DataTables**: Búsqueda, paginación y ordenamiento en tiempo real

### 📖 Gestión Bibliotecaria
- **Inventario Completo**: Libros con ISBN, autores, categorías y editoriales
- **Estados Inteligentes**: Disponible, Prestado, Mantenimiento, Dado de Baja
- **Búsqueda Avanzada**: Por título, ISBN, autor o categoría
- **Portadas Dinámicas**: Sistema preparado para integración de imágenes

### 🔄 Sistema de Préstamos
- **Plazo Estándar**: 15 días naturales desde la solicitud
- **Préstamos Ilimitados**: Un lector puede tener múltiples libros simultáneamente
- **Estados**: Activo, Devuelto, Vencido
- **Cálculo Automático**: Detección de vencimientos y generación de multas

### 💰 Gestión de Multas
- **Tarifa**: $1,000 pesos por día de retraso
- **Estados**: Pendiente, Pagada, Exonerada
- **Historial**: Seguimiento completo de sanciones por usuario
- **Dashboard**: Visualización de deudas totales y pendientes

### 🤖 Don Archibaldo (Chatbot IA)
Asistente virtual con personalidad de bibliotecario veterano de 60 años:
- **Personalidad Única**: Sarcástico, perezoso pero sabio
- **Consultas en Tiempo Real**: Accede a tu préstamos y multas instantáneamente
- **Contexto Esotérico**: Cada libro es un "grimorio", cada préstamo un "ritual"
- **Integración Grok/Gemini**: Respuestas inteligentes sobre el sistema

## 🛠️ Stack Tecnológico

| Capa | Tecnología |
|------|------------|
| **Backend** | Java 17, Servlets 4.0, JSP 2.3 |
| **Frontend** | HTML5, CSS3, JavaScript (ES6+), Bootstrap 5 |
| **Base de Datos** | MySQL 8.0 / MariaDB 10.4 |
| **Librerías** | DataTables 1.13, AOS Animation, Iconify |
| **Servidor** | Apache Tomcat 9+ |
| **APIs** | xAI (Grok) / Google Gemini |

## 🚀 Instalación

### Prerrequisitos
- JDK 17 o superior
- Apache Tomcat 9+
- MySQL 8.0+ o MariaDB 10.4+
- Maven (opcional, para gestión de dependencias)

### 1. Clonar Repositorio
```bash
git clone https://github.com/tuusuario/ars-biblioteca.git
cd ars-biblioteca
```

### 2. Configurar Base de Datos
```bash
# Crear base de datos
mysql -u root -p -e "CREATE DATABASE bibliotecadb CHARACTER SET utf8mb4;"

# Importar esquema
mysql -u root -p bibliotecadb < database/bibliotecadb.sql
```

### 3. Configurar Conexión
Editar `src/main/resources/config.properties`:
```properties
db.url=jdbc:mysql://localhost:3306/bibliotecadb
db.user=root
db.password=tu_password
db.driver=com.mysql.cj.jdbc.Driver
```

### 4. Configurar API de Chatbot
En `ChatbotServlet.java`, agregar tu API key:
```java
private String apiKey = "tu_api_key_de_grok_o_gemini";
```

### 5. Desplegar
```bash
# Compilar WAR
mvn clean package

# O manualmente copiar a webapps de Tomcat
cp target/ars-biblioteca.war $TOMCAT_HOME/webapps/
```

## 👥 Roles y Permisos

| Rol | Permisos |
|-----|----------|
| 👑 **Administrador** | CRUD completo de usuarios, libros, préstamos y multas. Acceso a dashboard de estadísticas |
| 📚 **Bibliotecario** | Gestión de préstamos, multas e inventario. Vista histórica completa |
| 👤 **Lector** | Consultar catálogo, solicitar préstamos, ver propios préstamos y multas |

### Usuarios por Defecto

| Usuario | Contraseña | Rol |
|---------|------------|-----|
| admin@admin.com | admin | Administrador |
| bibli@bibli.com | bibli | Bibliotecario |
| lector@lector.com | lector | Lector |

## 📁 Estructura del Proyecto
```
ars-biblioteca/
├── src/
│   └── main/
│       ├── java/
│       │   └── sena/adso/
│       │       ├── controller/    # Servlets (LibroServlet, PrestamoServlet...)
│       │       ├── dao/           # Interfaces e implementaciones DAO
│       │       ├── model/         # Entidades (Libro, Usuario, Prestamo...)
│       │       └── util/          # Conexión y helpers
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── views/         # JSPs (libros.jsp, resumen.jsp...)
│           │   └── includes/      # Componentes reutilizables
│           └── assets/
│               ├── css/           # Estilos personalizados
│               ├── js/            # Scripts del chatbot y utilidades
│               └── libs/          # Bootstrap, DataTables, AOS
├── database/
│   └── bibliotecadb.sql           # Esquema completo
└── README.md
```

## 💬 Uso del Chatbot

Don Archibaldo entiende comandos naturales:

| Comando | Descripción |
|---------|-------------|
| `"¿Qué préstamos tengo?"` | Lista tus libros activos con fechas de devolución |
| `"¿Cuánto debo?"` | Muestra multas pendientes y total adeudado |
| `"Libros disponibles"` | Catálogo actual de grimorios disponibles |
| `"Estadísticas"` | Números generales del sistema |
| `"Ayuda"` | Lista de comandos disponibles |

## 🎨 Personalización

### Cambiar Colores
Editar variables CSS en `style.css`:
```css
:root {
    --gold-bright: #FFD700;    /* Dorado principal */
    --gold-dark: #B8860B;      /* Dorado oscuro */
    --glass-bg: rgba(0,0,0,0.8); /* Fondo glass */
}
```

### Modificar Plazo de Préstamo
En `PrestamoServlet.java`:
```java
.fechaDevolucionEsperada(LocalDate.now().plusDays(15)) // Cambiar 15 por días deseados
```

### Tarifa de Multa
En `PrestamoServlet.java`:
```java
private static final double MONTO_MULTA_POR_DIA = 1000.0; // Valor en pesos
```

## 📸 Capturas de Pantalla

| Vista | Imagen |
|-------|--------|
| Dashboard Administrativo | ![Dashboard](https://via.placeholder.com/600x300/0a0a0a/c9b037?text=Dashboard+con+Estadísticas) |
| Catálogo de Libros | ![Catálogo](https://via.placeholder.com/600x300/0a0a0a/c9b037?text=Catálogo+Glassmorphism) |
| Chat con Don Archibaldo | ![Chatbot](https://via.placeholder.com/600x300/0a0a0a/c9b037?text=Don+Archibaldo+Chat) |

## 🤝 Contribución

1. Fork el proyecto
2. Crea tu Feature Branch (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -m 'Add: Nueva funcionalidad'`)
4. Push a la Branch (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 🙏 Agradecimientos

- **SENA ADSO** - Por la formación y el espacio de desarrollo
- **xAI / Google** - Por las APIs de inteligencia artificial
- **Bootstrap Team** - Por el framework CSS
- **DataTables** - Por la magia de las tablas interactivas
