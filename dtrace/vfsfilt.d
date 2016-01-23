#!/usr/sbin/dtrace -s

fbt::filt_vfsvnode:entry
{
	printf("vnode filter %#x for %p", args[1], args[0]->kn_hook);
}