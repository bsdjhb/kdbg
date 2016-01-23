#!/usr/sbin/dtrace -s

/* /args[0] == g_new_provider_event/ */
fbt::smp_rendezvous_cpus:entry
{
    @stacks[stack()] = count();
    @counts[execname, curthread->td_proc->p_pid] = count();
}
