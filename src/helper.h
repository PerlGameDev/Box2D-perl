
void * stack_to_object( SV* arg )
{

	void * var = NULL;
	if( sv_isobject(arg) && (SvTYPE(SvRV(arg)) == SVt_PVMG) )
	{
		var = (void *)SvIV((SV*)SvRV( arg ));
	}


	return var;

}
