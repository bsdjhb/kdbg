callout_execute:::callout-start
{
	self->start = timestamp;
	self->func = args[0]->c_func;
	@funcs[self->func] = count();
}

callout_execute:::callout-end
{
	@functimes[self->func] = sum(timestamp - self->start);
}

END
{
	printf("\n\nCallout function counts:\n");
	printa("%@8u %a\n", @funcs);
	printf("\nCallout function runtime:\n");
	printa("%@d %a\n", @functimes);
}
