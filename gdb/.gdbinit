set breakpoint pending on
set debuginfod enabled on
set auto-load safe-path /
set history filename = $HOME/.gdbhistory
set history save
set history size 1000
#set debug-file-directory /usr/lib/debug/usr/bin/
#set directories /usr/src/debug/openssl-3.2.3
set remotetimeout 60
b main

