# Mapa de Teclado Completo - Configuración NvChad

## **Tecla Líder: `<Espacio>`**

### **🔍 BÚSQUEDAS (Telescope) - `<leader>s`**

| Tecla        | Acción                   | Descripción                 |
| ------------ | ------------------------ | --------------------------- |
| `<leader>sf` | Buscar archivos          | Telescope: find_files       |
| `<leader>sg` | Grep en vivo             | Buscar texto en el proyecto |
| `<leader>bl` | Buffers                  | Lista de buffers abiertos   |
| `<leader>sh` | Ayuda                    | Tags de ayuda               |
| `<leader>sk` | Keymaps                  | Ver todos los atajos        |
| `<leader>so` | Archivos recientes       | oldfiles                    |
| `<leader>sc` | Comandos                 | Lista de comandos           |
| `<leader>sd` | Diagnósticos (buffer)    | Del buffer actual           |
| `<leader>sD` | Diagnósticos (workspace) | De todo el workspace        |
| `<leader>sr` | Referencias LSP          | Referencias del símbolo     |
| `<leader>ss` | Símbolos (buffer)        | Símbolos del archivo        |
| `<leader>sS` | Símbolos (workspace)     | Símbolos del proyecto       |

### **🔄 GIT - `<leader>g`**

| Tecla        | Acción             | Descripción          |
| ------------ | ------------------ | -------------------- |
| `<leader>gs` | Git status         | Estado con Telescope |
| `<leader>gc` | Commits            | Historia de commits  |
| `<leader>gC` | Commits del buffer | Del archivo actual   |
| `<leader>gb` | Branches           | Lista de ramas       |
| `<leader>gS` | Stage hunk         | Preparar cambio      |
| `<leader>gR` | Reset hunk         | Deshacer cambio      |
| `<leader>gP` | Preview hunk       | Vista previa         |
| `<leader>gB` | Blame línea        | Quién modificó       |
| `<leader>gd` | Diff contra HEAD   | Ver diferencias      |
| `<leader>lg` | Abrir LazyGit      | Ventana flotante     |
| `]h`         | Siguiente hunk     | Navegar adelante     |
| `[h`         | Hunk anterior      | Navegar atrás        |

### **💻 CÓDIGO/LSP - `<leader>c`**

| Tecla        | Acción                 | Descripción             |
| ------------ | ---------------------- | ----------------------- |
| `K`          | Hover                  | Información del símbolo |
| `gd`         | Ir a definición        | Definición del símbolo  |
| `gD`         | Ir a declaración       | Declaración             |
| `gi`         | Implementaciones       | Implementaciones        |
| `gr`         | Referencias            | Ver referencias         |
| `<leader>cr` | Rename                 | Renombrar símbolo       |
| `<leader>ca` | Code action            | Acciones de código      |
| `<leader>cf` | Formatear              | Formatear buffer        |
| `<leader>cF` | Toggle format (buffer) | Auto-formato buffer     |
| `<leader>cG` | Toggle format (global) | Auto-formato global     |
| `<leader>cl` | Lanzar linter          | Ejecutar linter         |
| `<leader>cL` | Lista diagnósticos     | Abrir lista             |
| `<leader>cd` | Diagnóstico línea      | Mensaje flotante        |
| `]d`         | Siguiente diagnóstico  | Navegar adelante        |
| `[d`         | Diagnóstico anterior   | Navegar atrás           |

### **🐛 DEBUG (DAP) - `<leader>d`**

| Tecla        | Acción            | Descripción           |
| ------------ | ----------------- | --------------------- |
| `<F5>`       | Continue          | Continuar ejecución   |
| `<F10>`      | Step Over         | Paso por encima       |
| `<F11>`      | Step Into         | Entrar en función     |
| `<F12>`      | Step Out          | Salir de función      |
| `<leader>db` | Toggle Breakpoint | Punto de interrupción |
| `<leader>du` | Toggle DAP UI     | Interfaz de debug     |
| `<leader>dr` | Toggle REPL       | Consola interactiva   |
| `<leader>dk` | Stack up          | Subir en el stack     |
| `<leader>dj` | Stack down        | Bajar en el stack     |

### **📋 PERFILES - `<leader>p`**

| Tecla        | Acción            | Descripción         |
| ------------ | ----------------- | ------------------- |
| `<leader>pP` | Selector perfiles | Elegir perfil       |
| `<leader>p1` | Perfil C++        | Activar C++         |
| `<leader>p2` | Perfil Rust       | Activar Rust        |
| `<leader>pB` | Build             | Compilar con perfil |
| `<leader>pT` | Test              | Ejecutar tests      |
| `<leader>pR` | Debug/Run         | Ejecutar/depurar    |

### **📁 BUFFERS - `<leader>b`**

| Tecla        | Acción           | Descripción      |
| ------------ | ---------------- | ---------------- |
| `<leader>bn` | Siguiente buffer | Navegar adelante |
| `<leader>bp` | Buffer anterior  | Navegar atrás    |
| `<leader>bd` | Cerrar buffer    | Cerrar actual    |
| `<leader>bo` | Cerrar otros     | Solo el actual   |
| `<leader>bb` | Alternar buffer  | Último usado     |

### **🧭 NAVEGACIÓN - `<leader>j`**

| Tecla        | Acción              | Descripción         |
| ------------ | ------------------- | ------------------- |
| `<leader>jb` | Volver              | Jumplist back       |
| `<leader>jf` | Adelante            | Jumplist forward    |
| `<leader>jj` | Ver jumplist        | Lista completa      |
| `<leader>jd` | Ir a definición     | Con marca de vuelta |
| `<leader>jD` | Ir a declaración    | Con marca           |
| `<leader>ji` | Ir a implementación | Con marca           |
| `<leader>jt` | Ir a type def       | Con marca           |

### **👁️ VISTA - `<leader>z`**

| Tecla        | Acción        | Descripción |
| ------------ | ------------- | ----------- |
| `<leader>zm` | Centrar línea | En el medio |
| `<leader>zt` | Línea arriba  | Top         |
| `<leader>zb` | Línea abajo   | Bottom      |

### **🪟 VENTANAS (SPLITS) - `<leader>w`**

#### **Crear Splits**
| Tecla        | Acción           | Descripción            |
| ------------ | ---------------- | ---------------------- |
| `<leader>wv` | Split vertical   | Dividir verticalmente  |
| `<leader>wh` | Split horizontal | Dividir horizontalmente|
| `<leader>wt` | Nueva pestaña    | Crear nueva tab        |

#### **Navegación**
| Tecla        | Acción             | Descripción           |
| ------------ | ------------------ | --------------------- |
| `<leader>ww` | Siguiente ventana  | Ciclar ventanas       |
| `<leader>wj` | Ventana abajo      | Ir hacia abajo        |
| `<leader>wk` | Ventana arriba     | Ir hacia arriba       |
| `<leader>wl` | Ventana derecha    | Ir hacia la derecha   |
| `<leader>wJ` | Ventana izquierda  | Ir hacia la izquierda |
| `<C-h>`      | Ir izquierda       | Navegación rápida     |
| `<C-j>`      | Ir abajo           | Navegación rápida     |
| `<C-k>`      | Ir arriba          | Navegación rápida     |
| `<C-l>`      | Ir derecha         | Navegación rápida     |

#### **Redimensionar**
| Tecla        | Acción               | Descripción              |
| ------------ | -------------------- | ------------------------ |
| `<leader>w=` | Igualar tamaños      | Mismo tamaño todas       |
| `<leader>w+` | Aumentar altura      | +5 líneas                |
| `<leader>w-` | Disminuir altura     | -5 líneas                |
| `<leader>w>` | Aumentar ancho       | +5 columnas              |
| `<leader>w<` | Disminuir ancho      | -5 columnas              |

#### **Gestión**
| Tecla        | Acción               | Descripción              |
| ------------ | -------------------- | ------------------------ |
| `<leader>wc` | Cerrar ventana       | Cerrar actual            |
| `<leader>wo` | Cerrar otras         | Solo mantener actual     |
| `<leader>wx` | Cerrar ventana       | Alternativo              |
| `<leader>wm` | Toggle maximizar     | Maximizar/restaurar      |

#### **Mover y Rotar**
| Tecla        | Acción               | Descripción              |
| ------------ | -------------------- | ------------------------ |
| `<leader>wH` | Mover izquierda      | Reposicionar ventana     |
| `<leader>wK` | Mover arriba         | Reposicionar ventana     |
| `<leader>wL` | Mover derecha        | Reposicionar ventana     |
| `<leader>wM` | Mover abajo          | Reposicionar ventana     |
| `<leader>wr` | Rotar hacia derecha  | Cambiar orden            |
| `<leader>wR` | Rotar hacia izquierda| Cambiar orden            |
| `<leader>wT` | Mover a nueva tab    | Convertir en pestaña     |
| `<leader>ws` | Cambiar orientación  | Horizontal ↔ Vertical    |

### **⚡ FLASH (Movimiento rápido)**

| Tecla   | Modo            | Acción            |
| ------- | --------------- | ----------------- |
| `s`     | Normal/Visual   | Salto Flash       |
| `S`     | Normal/Visual   | Flash Treesitter  |
| `r`     | Operator        | Remote Flash      |
| `R`     | Operator/Visual | Treesitter Search |
| `<C-s>` | Command         | Toggle Flash      |

### **⚙️ UTILIDADES**

| Tecla | Modo   | Acción                |
| ----- | ------ | --------------------- |
| `;`   | Normal | Entrar a modo comando |
| `jk`  | Insert | Salir a modo normal   |

---

**Total: 115 atajos de teclado personalizados** organizados en grupos lógicos para máxima productividad.

## Notas Adicionales

- **Tecla Líder**: `<Espacio>` (Space)
- **Configuración base**: NvChad con personalizaciones
- **Organización**: Prefijos lógicos para cada categoría de funciones
- **Herramientas principales**: Telescope, LSP, DAP, Gitsigns, Flash

### Atajos por Categoría

| Categoría  | Prefijo     | Cantidad |
| ---------- | ----------- | -------- |
| Búsquedas  | `<leader>s` | 11       |
| Git        | `<leader>g` | 12       |
| Código/LSP | `<leader>c` | 17       |
| Debug      | `<leader>d` | 9        |
| Perfiles   | `<leader>p` | 6        |
| Buffers    | `<leader>b` | 5        |
| Navegación | `<leader>j` | 7        |
| Vista      | `<leader>z` | 3        |
| Ventanas   | `<leader>w` | 25       |
| Flash      | Varios      | 9        |
| Utilidades | Varios      | 2        |

> **Tip**: Usa `<leader>sk` para ver todos los keymaps disponibles en tiempo real desde dentro de Neovim.
