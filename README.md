# kdbg
FreeBSD kernel debugging scripts

This simple repository holds things I find useful for kernel debugging on FreeBSD.

## gdb/

The gdb/ subdirectory holds a set of scripts useful with the kgdb front-end to gdb.  To use these scripts, do the following in kgdb:

```
% git clone https://github.com/bsdjhb/kdbg.git
% cd kdbg/gdb
% kgdb
....
(kgdb) source gdb6
```

Filename | Description
--- | ---
chelsio | Commands for use with the cxgb(4) and cxgbe(4) drivers (Chelsio T3/T4/T5 NICs).  Requires gdb6.
dot.gdbinit.kernel | Older scripts from the main source tree.  My plan is to eventually move useful scripts out of here to gdb6 and remove this.
dot.gdbinit.paths | See above.
gdb4 | General commands for use with FreeBSD 4.x
gdb6 | General commands for use with FreeBSD 6.x and later
gdb6.amd64 | amd64-specific commands for gdb6.  Included automatically by gdb6 on amd64 kernels.
gdb6.i386 | i386-specific commands for gdb6.  Included automatically by gdb6 on i386 kernels.

## dtrace/

The dtrace/ subdirectory holds various DTrace scripts.

Filename | Description
--- | ---
eperm.d | Determine the source of an `EPERM` error from `stat()`

