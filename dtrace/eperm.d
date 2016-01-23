syscall::lstat:entry
{
    self->trace = 1
}

syscall:::return
{
    self->trace = 0
}

fbt::namei:return
/self->trace == 1 && curthread->td_proc->p_comm == "stat"/
{
    printf("namei returned %d", arg1);
}

fbt::vn_stat:return
/self->trace == 1 && curthread->td_proc->p_comm == "stat"/
{
    printf("vn_stat returned %d", arg1);
}

fbt:::return
/self->trace == 2 && arg1 == EPERM && curthread->td_proc->p_comm == "stat"/
{
    printf("%s returned EPERM.", probefunc);
}
