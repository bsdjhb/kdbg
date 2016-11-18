#pragma D option quiet
#pragma D option bufpolicy=ring

inline int TDF_IDLETD = 0x00000020;

/*
 * Reasons that the current thread can not be run yet.
 * More than one may apply.
 */
inline int TDI_SUSPENDED = 0x0001;	/* On suspension queue. */
inline int TDI_SLEEPING = 0x0002;	/* Actually asleep! (tricky). */
inline int TDI_SWAPPED = 0x0004;	/* Stack not in mem.  Bad juju if run. */
inline int TDI_LOCK = 0x0008;		/* Stopped on a lock. */
inline int TDI_IWAIT = 0x0010;		/* Awaiting interrupt. */

inline string KTDSTATE[struct thread * td] = \
	(((td)->td_inhibitors & TDI_SLEEPING) != 0 ? "sleep"  :		\
	((td)->td_inhibitors & TDI_SUSPENDED) != 0 ? "suspended" :	\
	((td)->td_inhibitors & TDI_SWAPPED) != 0 ? "swapped" :		\
	((td)->td_inhibitors & TDI_LOCK) != 0 ? "blocked" :		\
	((td)->td_inhibitors & TDI_IWAIT) != 0 ? "iwait" : "yielding");

inline int NOCPU = 0xff;

sched:::load-change
/ args[0] == NOCPU /
{
	printf("%d %d KTRGRAPH group:\"load\", id:\"global load\", counter:\"%d\", attributes: \"none\"\n", cpu, timestamp, args[1]);
}

sched:::load-change
/ args[0] != NOCPU /
{
	printf("%d %d KTRGRAPH group:\"load\", id:\"CPU %d load\", counter:\"%d\", attributes: \"none\"\n", cpu, timestamp, args[0], args[1]);

}

proc:::exit
{
	printf("%d %d KTRGRAPH group:\"thread\", id:\"%s/%s tid %d\", state:\"proc exit\", attributes: prio:td\n", cpu, timestamp, curthread->td_proc->p_comm, curthread->td_name, curthread->td_tid);
}

proc:::lwp-exit
{
	printf("%d %d KTRGRAPH group:\"thread\", id:\"%s/%s tid %d\", state:\"exit\", attributes: prio:td\n", cpu, timestamp, curthread->td_proc->p_comm, curthread->td_name, curthread->td_tid);
}

sched:::change-pri
{
	printf("%d %d KTRGRAPH group:\"thread\", id:\"%s/%s tid %d\", point:\"priority change\", attributes: prio:%d, new prio:%d, linkedto:\"%s/%s tid %d\"\n", cpu, timestamp, args[0]->td_proc->p_comm, args[0]->td_name, args[0]->td_tid, args[0]->td_priority, arg2, curthread->td_proc->p_comm, curthread->td_name, curthread->td_tid);
}

sched:::lend-pri
{
	printf("%d %d KTRGRAPH group:\"thread\", id:\"%s/%s tid %d\", point:\"lend prio\", attributes: prio:%d, new prio:%d, linkedto:\"%s/%s tid %d\"\n", cpu, timestamp, curthread->td_proc->p_comm, curthread->td_name, curthread->td_tid, args[0]->td_priority, arg2, args[0]->td_proc->p_comm, args[0]->td_name, args[0]->td_tid);
}

sched:::enqueue
{
	printf("%d %d KTRGRAPH group:\"thread\", id:\"%s/%s tid %d\", state:\"runq add\", attributes: prio:%d, linkedto:\"%s/%s tid %d\"\n", cpu, timestamp, args[0]->td_proc->p_comm, args[0]->td_name, args[0]->td_tid, args[0]->td_priority, curthread->td_proc->p_comm, curthread->td_name, curthread->td_tid);
	printf("%d %d KTRGRAPH group:\"thread\", id:\"%s/%s tid %d\", point:\"wokeup\", attributes: linkedto:\"%s/%s tid %d\"\n", cpu, timestamp, curthread->td_proc->p_comm, curthread->td_name, curthread->td_tid, args[0]->td_proc->p_comm, args[0]->td_name, args[0]->td_tid);
}

sched:::dequeue
{
	printf("%d %d KTRGRAPH group:\"thread\", id:\"%s/%s tid %d\", state:\"runq rem\", attributes: prio:%d, linkedto:\"%s/%s tid %d\"\n", cpu, timestamp, args[0]->td_proc->p_comm, args[0]->td_name, args[0]->td_tid, args[0]->td_priority, curthread->td_proc->p_comm, curthread->td_name, curthread->td_tid);
}

sched:::tick
{
	printf("%d %d KTRGRAPH group:\"thread\", id:\"%s/%s tid %d\", point:\"statclock\", attributes: prio:%d, stathz:%d\n", cpu, timestamp, args[0]->td_proc->p_comm, args[0]->td_name, args[0]->td_tid, args[0]->td_priority, `stathz ? `stathz : `hz);
}

sched:::off-cpu
/ curthread->td_flags & TDF_IDLETD /
{
	printf("%d %d KTRGRAPH group:\"thread\", id:\"%s/%s tid %d\", state:\"idle\", attributes: prio:%d\n", cpu, timestamp, curthread->td_proc->p_comm, curthread->td_name, curthread->td_tid, curthread->td_priority);
}

sched:::off-cpu
/ (curthread->td_flags & TDF_IDLETD) == 0 /
{
	printf("%d %d KTRGRAPH group:\"thread\", id:\"%s/%s tid %d\", state:\"%s\", attributes: prio:%d, wmesg:\"%s\", lockname:\"%s\"\n", cpu, timestamp, curthread->td_proc->p_comm, curthread->td_name, curthread->td_tid, KTDSTATE[curthread], curthread->td_priority, curthread->td_wmesg ? stringof(curthread->td_wmesg) : "(null)", curthread->td_lockname ? stringof(curthread->td_lockname) : "(null)");
}

sched:::on-cpu
{
	printf("%d %d KTRGRAPH group:\"thread\", id:\"%s/%s tid %d\", state:\"running\", attributes: prio:%d\n", cpu, timestamp, curthread->td_proc->p_comm, curthread->td_name, curthread->td_tid, curthread->td_priority);
}

callout_execute:::callout-start
{
	printf("%d %d KTRGRAPH group:\"callout\", id:\"callout %s\", state:\"running\", attributes: func:%a, arg:%p\n", cpu, timestamp, curthread->td_name, args[0]->c_func, args[0]->c_arg);
}

callout_execute:::callout-end
{
	printf("%d %d KTRGRAPH group:\"callout\", id:\"callout %s\", state:\"idle\"\n", cpu, timestamp, curthread->td_name, attributes: \"none\");
}

tick-5s
{
	exit(0);
}

