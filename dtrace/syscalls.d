#!/usr/sbin/dtrace -s

syscall:::entry
{
	@counts[probefunc] = count()
}