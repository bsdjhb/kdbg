#!/usr/sbin/dtrace -s

/* /args[0] == g_new_provider_event/ */
fbt::g_post_event:entry
{
    printf("geom event scheduled by pid %d (%s)",
       curthread->td_proc->p_pid, curthread->td_proc->p_comm);
    /* stack(); */
}

/* / arg0 == 4 / */

fbt::spa_async_request:entry
{
    printf("SPA_PROBE requested by pid %d (%s)",
       curthread->td_proc->p_pid, curthread->td_proc->p_comm);
    stack();
}
