#!/usr/sbin/dtrace -s

/*
 * $1 = system call to look for errors
 * $2 = error value to find
 * $3 = binary name
 */

syscall::$$1:entry
/curthread->td_proc->p_comm == $$3/
{
    self->trace = 1
}

syscall:::return
/self->trace == 1/
{
    self->trace = 0
}

fbt:::return
/self->trace == 1 && arg1 == $2/
{
    printf("%s returned %d.", probefunc, $2);
}

