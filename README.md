# config_files

Utilizar `stow` para poder usarlos directamente sin necesidad de tener que andar copiando.

Stow basicamente pone una serie de links desde el directorio que le digamos hasta el que le digamos.
Hay que tener en cuenta que `stow` tiene el concepto de "modulos", que no son mas que subdirectorios
en el directorio que le demos.

Tenemos que decirle 
- Que directorio queremos se sea la fuente
- Que directorio queremos que sea el destino
- Que "modulos" dentro de la fuente tiene que "stowear" ( enlazar)

Así por ejemplo si tenemos los ficheros de configuracion de git en `$HOME/source/mine/config_files/git`
y queremos hacer que se enlacen en nuestro HOME tenemos que poner

```shell
stow -d $HOME/source/mine/config_files -t $HOME git
```

Donde:
- `-d` marca el directorio fuente donde están los modulos
- `-t` marca el directorio de destino
- `git` es el nombre del modulo que queremos "stowear"


### NOTA:

```shell
stow -n -v
```

- `-n` no hacer cambios --> Este ayuda para ver lo que va a hacer ( junto con -v) antes de hacerlo
- `-v` verbose  --> Este es bueno añadirlo siempre



### Guia rápida para configurar y borrar
OJO: es importante quedarse con los comandos de stow que se hacen para luego poder deshacerlos cuando sea necesario
#### Creacion
```shell
❯ stow -v -d /home/jojosneg/source/mine/config_files/ -t /home/jojosneg/.config/nvim nvim
❯ stow -v -d /home/jojosneg/source/mine/config_files/ -t /home/jojosneg/.config/tmux tmux
❯ stow -v -d /home/jojosneg/source/mine/config_files/linux_shell -t /home/jojosneg zsh
❯ stow -v -d /home/jojosneg/source/mine/config_files -t /home/jojosneg git
```

#### Borrado
```shell
❯ stow -v -d /home/jojosneg/source/mine/config_files/ -t /home/jojosneg/.config/nvim -D nvim
❯ stow -v -d /home/jojosneg/source/mine/config_files/ -t /home/jojosneg/.config/tmux -D tmux
❯ stow -v -d /home/jojosneg/source/mine/config_files/linux_shell -t /home/jojosneg -D zsh
❯ stow -v -d /home/jojosneg/source/mine/config_files -t /home/jojosneg -D git
```
