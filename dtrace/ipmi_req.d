#!/usr/sbin/dtrace -s

fbt::ipmi_ioctl:entry
{
    printf("IPMI request by pid %d (%s)",
       curthread->td_proc->p_pid, curthread->td_proc->p_comm);
    /* stack(); */
}
