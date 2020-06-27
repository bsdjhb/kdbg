fbt::crypto_newsession:entry
{
    print(*args[1]);
}

fbt::crypto_newsession:return
/arg1 != 0/
{
    printf("returned %d", arg1);
}

/*
fbt::crypto_checkdriver:entry
{
    printf("(0x%x)", arg1)
}

fbt::crypto_checkdriver:return
{
    printf("=> %p", (void *)arg1)
}

fbt::crypto_select_driver:entry
{
    printf("(%p, 0x%x)", arg1, arg2)
}

fbt::crypto_select_driver:return
{
    printf("=> %p", (void *)arg1)
}

fbt::driver_suitable:entry
{
    printf("(%p, %p)", arg1, arg2);
}

fbt::driver_suitable:return
{
    printf("=> %d", arg1)
}
*/

fbt::swcr_setup_auth:return
/arg1 != 0/
{
    printf("returned %d", arg1);
}

fbt::swcr_setup_cipher:return
/arg1 != 0/
{
    printf("returned %d", arg1);
}

/*
fbt::swcr_setup_gcm:return
/arg1 != 0/
{
    printf("returned %d", arg1);
}
*/

fbt::swcr_probesession:return
{
    printf("returned %d", arg1);
}

fbt::check_csp:return
{
    printf("returned %d", arg1);
}

fbt::swcr_newsession:entry
{
    printf("called");
}

fbt::swcr_newsession:return
/arg1 != 0/
{
    printf("returned %d", arg1);
}

/*
fbt::ccr_aes_setkey:return
/arg1 != 0/
{
    printf("returned %d", arg1);
}
*/

fbt::ccr_probesession:return
{
    printf("returned %d", arg1);
}

fbt::ccr_newsession:return
/arg1 != 0/
{
    printf("returned %d", arg1);
}

fbt::aesni_probesession:return
{
    printf("returned %d", arg1);
}

fbt::aesni_newsession:return
/arg1 != 0/
{
    printf("returned %d", arg1);
}

fbt::isal_probesession:return
{
    printf("returned %d", arg1);
}

fbt::isal_newsession:return
/arg1 != 0/
{
    printf("returned %d", arg1);
}
