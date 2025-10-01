# Navegación y Visualización de Buffers Mejorada

## Cambios Implementados

Se han realizado los siguientes cambios para mejorar la identificación de buffers:

### 1. Bufferline.nvim (Barra superior de buffers)

**Ubicación:** Parte superior de la ventana
**Plugin:** `akinsho/bufferline.nvim`

**Características:**
- Muestra todos los buffers abiertos con separadores visuales tipo "slant"
- Números ordinales para saltar rápido (1, 2, 3, etc.)
- Diagnósticos LSP integrados (errores/warnings por buffer)
- Icono "●" para buffers modificados
- Hover para ver ruta completa del archivo
- Offset automático para NvimTree

**Keymaps nuevos:**
```vim
<leader>B1-9    " Ir directamente al buffer número N (B mayúscula)
]b              " Siguiente buffer (cycle)
[b              " Buffer anterior (cycle)
<leader>Bp      " Seleccionar buffer interactivamente
<leader>BC      " Seleccionar buffer para cerrar
<leader>B>      " Mover buffer a la derecha
<leader>B<      " Mover buffer a la izquierda
<leader>Bc      " Cerrar otros buffers
<leader>Bl      " Cerrar buffers a la izquierda
<leader>Br      " Cerrar buffers a la derecha
<leader>Bf      " Ir al primer buffer
<leader>BL      " Ir al último buffer
<leader>Bg      " Toggle agrupación de buffers
```

**Nota:** Se usa `<leader>B` (B mayúscula) para bufferline y `<leader>b` (b minúscula)
para comandos genéricos de buffers, evitando conflicto con `<leader>t1-9` (tabs).

### 2. Nvim-navic + Winbar (Breadcrumbs en cada ventana)

**Ubicación:** Parte superior de cada ventana/split
**Plugins:** `SmiteshP/nvim-navic` + configuración custom de winbar

**Características:**
- Muestra contexto LSP (Clase > Función > Bloque) en cada ventana
- Muestra nombre del archivo con ruta relativa
- Indica si el archivo está modificado (●)
- Se actualiza automáticamente al mover el cursor
- Se oculta en ventanas especiales (NvimTree, Lazy, etc.)

**Formato del winbar:**
```
MyClass > myFunction() > if block │ src/utils.lua ●
```

### 3. Nvim-navbuddy (Navegador de símbolos)

**Plugin:** `SmiteshP/nvim-navbuddy`

**Características:**
- Navegador visual de símbolos LSP
- Vista jerárquica de clases, funciones, variables, etc.
- Integrado con nvim-navic

**Keymap:**
```vim
<leader>cn      " Abrir navegador de símbolos (Navbuddy)
```

## Archivos Modificados

1. **lua/plugins/ui-navigation.lua** (NUEVO)
   - Configuración de bufferline.nvim
   - Configuración de nvim-navic
   - Configuración de nvim-navbuddy

2. **lua/plugins/init.lua**
   - Añadido import de `plugins.ui-navigation`

3. **lua/options.lua**
   - Añadido autocmd para winbar con breadcrumbs + filename

4. **lua/autocmds.lua**
   - Añadido autocmd para adjuntar nvim-navic a LSP servers

5. **lua/chadrc.lua**
   - Deshabilitado tabufline de NvChad (evitar conflicto con bufferline)
   - Añadidos highlights para WinBar y WinBarPath

## Cómo se ve ahora

```
┌───────────────────────────────────────────────────────────────────────┐
│ BUFFERLINE                                                            │
│ 1  src/utils.lua  | 2  tests/utils.lua  | 3  lib/config.lua        │
├─────────────────────────────────────┬─────────────────────────────────┤
│ SPLIT IZQUIERDO                     │ SPLIT DERECHO                   │
│ MyClass > myFunction()  src/utils.lua│ describe > test  tests/utils.lua│ <- WINBAR
│                                     │                                 │
│ function myFunction() {             │ describe('utils', () => {       │
│   const data = ...                  │   test('should...', () => {     │
│ }                                   │   });                           │
│                                     │                                 │
└─────────────────────────────────────┴─────────────────────────────────┘
```

## Uso Recomendado

### Navegación entre buffers:
1. **Visual rápida:** Mira la bufferline arriba para ver todos los buffers
2. **Salto directo:** Usa `<leader>B1` a `<leader>B9` para ir al buffer por número
3. **Cycle:** Usa `]b` / `[b` para ir al siguiente/anterior
4. **Picker:** Usa `<leader>Bp` para seleccionar interactivamente
5. **Básica:** Los comandos `<leader>bn/bp/bd/bo` siguen funcionando (definidos antes)

### Identificación en splits:
1. Mira el **winbar** (línea superior de cada ventana)
2. El winbar muestra: `contexto LSP │ ruta/archivo`
3. Si el archivo está modificado, verás el símbolo `●`

### Navegación por símbolos:
1. Usa `<leader>cn` para abrir Navbuddy
2. Navega por la estructura del código jerárquicamente
3. Enter para saltar al símbolo seleccionado

## Personalización

### Cambiar colores del winbar:
Edita `lua/chadrc.lua` en la sección `hl_override`:

```lua
WinBar = { fg = "light_grey", bg = "NONE" },     -- Breadcrumbs
WinBarPath = { fg = "blue", bg = "NONE", bold = true },  -- Filename
```

### Cambiar separador de bufferline:
Edita `lua/plugins/ui-navigation.lua`:

```lua
separator_style = "slant",  -- Opciones: "slant", "thick", "thin", "padded_slant"
```

### Desactivar winbar en ciertos filetypes:
Edita la lista `winbar_filetype_exclude` en `lua/options.lua`

## Solución de Problemas

### No veo los breadcrumbs en el winbar:
- Asegúrate de que el LSP server esté activo (`:LspInfo`)
- Algunos lenguajes/servers no soportan `documentSymbolProvider`
- El winbar mostrará solo el filename si no hay breadcrumbs disponibles

### Bufferline no aparece:
- Reinicia Neovim completamente
- Ejecuta `:Lazy sync` para instalar los nuevos plugins
- Verifica que tabufline de NvChad esté deshabilitado en `chadrc.lua`

### Conflicto con tabufline de NvChad:
- Ya está deshabilitado en `chadrc.lua`
- Si aún aparece, ejecuta `:NvChadUpdate`

## Primeros Pasos

1. **Cierra Neovim** si está abierto
2. **Reabre Neovim** - Lazy.nvim instalará los nuevos plugins automáticamente
3. **Espera** a que los plugins se instalen
4. **Abre múltiples archivos** para ver bufferline en acción
5. **Abre splits** con `<leader>wv` o `<leader>wh` para ver el winbar en cada ventana
