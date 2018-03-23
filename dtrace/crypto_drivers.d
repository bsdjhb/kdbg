#!/usr/sbin/dtrace -s

fbt::crypto_invoke:entry
{
    @[stringof(((struct cryptocap *)arg0)->cc_dev->nameunit)] = count();
}


