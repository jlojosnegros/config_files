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
| `<leader>cn` | Navbuddy               | Navegador de símbolos   |
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

#### **Navegación Básica**
| Tecla        | Acción           | Descripción      |
| ------------ | ---------------- | ---------------- |
| `<leader>bn` | Siguiente buffer | Navegar adelante |
| `<leader>bp` | Buffer anterior  | Navegar atrás    |
| `<leader>bd` | Cerrar buffer    | Cerrar actual    |
| `<leader>bo` | Cerrar otros     | Solo el actual   |
| `<leader>bb` | Alternar buffer  | Último usado     |
| `<leader>bl` | Lista buffers    | Telescope picker |

### **📊 BUFFERLINE (Navegación Avanzada) - `<leader>B`**

#### **Navegación por Número**
| Tecla        | Acción           | Descripción              |
| ------------ | ---------------- | ------------------------ |
| `<leader>B1` | Ir a buffer 1    | Salto directo al buffer 1|
| `<leader>B2` | Ir a buffer 2    | Salto directo al buffer 2|
| `<leader>B3` | Ir a buffer 3    | Salto directo al buffer 3|
| `<leader>B4` | Ir a buffer 4    | Salto directo al buffer 4|
| `<leader>B5` | Ir a buffer 5    | Salto directo al buffer 5|
| `<leader>B6` | Ir a buffer 6    | Salto directo al buffer 6|
| `<leader>B7` | Ir a buffer 7    | Salto directo al buffer 7|
| `<leader>B8` | Ir a buffer 8    | Salto directo al buffer 8|
| `<leader>B9` | Ir a buffer 9    | Salto directo al buffer 9|
| `]b`         | Siguiente buffer | Cycle adelante           |
| `[b`         | Buffer anterior  | Cycle atrás              |
| `<leader>Bf` | Primer buffer    | Ir al primero            |
| `<leader>BL` | Último buffer    | Ir al último             |

#### **Gestión de Buffers**
| Tecla        | Acción                    | Descripción                |
| ------------ | ------------------------- | -------------------------- |
| `<leader>Bp` | Seleccionar buffer        | Picker interactivo         |
| `<leader>BC` | Seleccionar para cerrar   | Picker para cerrar         |
| `<leader>Bc` | Cerrar otros buffers      | Mantener solo el actual    |
| `<leader>Bl` | Cerrar buffers izquierda  | Cerrar todos a la izquierda|
| `<leader>Br` | Cerrar buffers derecha    | Cerrar todos a la derecha  |

#### **Organización**
| Tecla        | Acción                    | Descripción                |
| ------------ | ------------------------- | -------------------------- |
| `<leader>B>` | Mover buffer a derecha    | Reordenar en bufferline    |
| `<leader>B<` | Mover buffer a izquierda  | Reordenar en bufferline    |
| `<leader>Bg` | Toggle agrupación         | Agrupar/desagrupar buffers |

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

### **📑 PESTAÑAS (TABS) - `<leader>t`**

#### **Crear y Gestionar**
| Tecla        | Acción               | Descripción              |
| ------------ | -------------------- | ------------------------ |
| `<leader>tn` | Nueva pestaña        | Crear pestaña vacía      |
| `<leader>tc` | Cerrar pestaña       | Cerrar actual            |
| `<leader>to` | Cerrar otras         | Solo mantener actual     |
| `<leader>tm` | Mover pestaña        | Mover al final           |

#### **Navegación**
| Tecla        | Acción               | Descripción              |
| ------------ | -------------------- | ------------------------ |
| `<leader>tj` | Siguiente pestaña    | Navegar adelante         |
| `<leader>tk` | Pestaña anterior     | Navegar atrás            |
| `<leader>tl` | Última pestaña       | Ir al final              |
| `<leader>tf` | Primera pestaña      | Ir al inicio             |
| `<A-j>`      | Siguiente (rápido)   | Alt + j                  |
| `<A-k>`      | Anterior (rápido)    | Alt + k                  |
| `<A-n>`      | Nueva (rápido)       | Alt + n                  |
| `<A-c>`      | Cerrar (rápido)      | Alt + c                  |

#### **Acceso Directo**
| Tecla        | Acción               | Descripción              |
| ------------ | -------------------- | ------------------------ |
| `<leader>t1` | Ir a pestaña 1       | Acceso directo           |
| `<leader>t2` | Ir a pestaña 2       | Acceso directo           |
| `<leader>t3` | Ir a pestaña 3       | Acceso directo           |
| `<leader>t4` | Ir a pestaña 4       | Acceso directo           |
| `<leader>t5` | Ir a pestaña 5       | Acceso directo           |
| `<leader>t6` | Ir a pestaña 6       | Acceso directo           |
| `<leader>t7` | Ir a pestaña 7       | Acceso directo           |
| `<leader>t8` | Ir a pestaña 8       | Acceso directo           |
| `<leader>t9` | Ir a pestaña 9       | Acceso directo           |

#### **Información**
| Tecla        | Acción               | Descripción              |
| ------------ | -------------------- | ------------------------ |
| `<leader>tL` | Listar pestañas      | Selector interactivo     |
| `<leader>ti` | Info pestaña         | Mostrar información      |

### **🔍 DIFF/COMPARACIÓN - `<leader>D`**

#### **Crear Comparaciones**
| Tecla        | Acción                   | Descripción                    |
| ------------ | ------------------------ | ------------------------------ |
| `<leader>Df` | Diff con archivo         | Comparar buffer con otro archivo |
| `<leader>DD` | Diff dos archivos        | Comparar dos archivos nuevos   |
| `<leader>Dg` | Diff con git             | Comparar con versión de commit |

#### **Navegación**
| Tecla        | Acción                   | Descripción                    |
| ------------ | ------------------------ | ------------------------------ |
| `<leader>Dn` | Siguiente diferencia     | Ir a próximo cambio            |
| `<leader>DP` | Diferencia anterior      | Ir a cambio previo             |

#### **Aplicar Cambios**
| Tecla        | Acción                   | Descripción                    |
| ------------ | ------------------------ | ------------------------------ |
| `<leader>Do` | Obtener cambio           | Copiar cambio desde otro lado  |
| `<leader>Dp` | Poner cambio             | Enviar cambio al otro lado     |

#### **Gestión**
| Tecla        | Acción                   | Descripción                    |
| ------------ | ------------------------ | ------------------------------ |
| `<leader>Du` | Actualizar diff          | Refrescar comparación          |
| `<leader>Dt` | Toggle diff              | Activar/desactivar en buffer   |
| `<leader>Dq` | Salir de diff            | Desactivar modo comparación    |
| `<leader>Di` | Info diff                | Estado actual de comparación   |

### **🔍 BÚSQUEDA AVANZADA - `<leader>S`**

#### **Tipos de Búsqueda**
| Tecla        | Acción                   | Descripción                    |
| ------------ | ------------------------ | ------------------------------ |
| `<leader>Ss` | Buscar texto             | Búsqueda simple con smartcase  |
| `<leader>Sr` | Buscar regex             | Búsqueda con expresión regular |
| `<leader>Sw` | Buscar palabra           | Palabra completa bajo cursor   |

> **Smartcase**: Si el patrón está en minúsculas → case-insensitive. Si contiene mayúsculas → case-sensitive.

#### **Navegación en Resultados**
| Tecla        | Acción                   | Descripción                    |
| ------------ | ------------------------ | ------------------------------ |
| `<leader>Sn` | Siguiente resultado      | Ir al próximo resultado        |
| `<leader>Sp` | Resultado anterior       | Ir al resultado previo         |

#### **Gestión**
| Tecla        | Acción                   | Descripción                    |
| ------------ | ------------------------ | ------------------------------ |
| `<leader>Sc` | Cerrar búsqueda          | Cerrar ventana de resultados   |
| `<leader>SR` | Refrescar búsqueda       | Actualizar resultados          |
| `<leader>Si` | Info de búsqueda         | Estado actual de búsqueda      |

#### **Controles en Ventana de Resultados**
| Tecla   | Acción                   | Descripción                    |
| ------- | ------------------------ | ------------------------------ |
| `<CR>`  | Ir a resultado           | Saltar a línea seleccionada    |
| `<C-n>` | Siguiente (local)        | Próximo resultado              |
| `<C-p>` | Anterior (local)         | Resultado previo               |
| `q`     | Cerrar                   | Cerrar ventana de búsqueda     |
| `r`     | Refrescar                | Actualizar búsqueda            |

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

**Total: 193 atajos de teclado personalizados** organizados en grupos lógicos para máxima productividad.

## Notas Adicionales

- **Tecla Líder**: `<Espacio>` (Space)
- **Configuración base**: NvChad con personalizaciones
- **Organización**: Prefijos lógicos para cada categoría de funciones
- **Herramientas principales**: Telescope, LSP, DAP, Gitsigns, Flash, Bufferline, Navbuddy

### Atajos por Categoría

| Categoría    | Prefijo     | Cantidad |
| ------------ | ----------- | -------- |
| Búsquedas    | `<leader>s` | 11       |
| Git          | `<leader>g` | 12       |
| Código/LSP   | `<leader>c` | 18       |
| Debug        | `<leader>d` | 9        |
| Perfiles     | `<leader>p` | 6        |
| Buffers      | `<leader>b` | 6        |
| Bufferline   | `<leader>B` | 24       |
| Navegación   | `<leader>j` | 7        |
| Vista        | `<leader>z` | 3        |
| Ventanas     | `<leader>w` | 26       |
| Pestañas     | `<leader>t` | 25       |
| Diff         | `<leader>D` | 12       |
| Búsq. Avanz. | `<leader>S` | 16       |
| Flash        | Varios      | 9        |
| Utilidades   | Varios      | 2        |

### Nuevas Funcionalidades (Bufferline + Navbuddy)

- **Bufferline**: Barra superior con todos los buffers visibles y navegación mejorada
- **Navbuddy**: Navegador visual jerárquico de símbolos LSP (`<leader>cn`)
- **Winbar**: Cada ventana muestra breadcrumbs LSP + nombre del archivo
- **Navegación por número**: `<leader>B1-9` para saltar directamente a buffers

> **Tip**: Usa `<leader>sk` para ver todos los keymaps disponibles en tiempo real desde dentro de Neovim.
