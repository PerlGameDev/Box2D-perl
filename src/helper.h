#ifndef __HELPER_H__
#define __HELPER_H__

void* stack_to_object( SV* arg )
{
	if ( sv_isobject(arg) && ( SvTYPE(SvRV(arg)) == SVt_PVMG ) )
	{
		return (void*)SvIV( (SV*)SvRV(arg) );
	}

	return NULL;
}

SV* object_to_stack( void* obj, const char* CLASS )
{
	SV* objref = sv_newmortal();
	sv_setref_pv( objref, CLASS, obj );
	return objref;
}

SV* new_data( SV* thing )
{
	if ( SvROK(thing) ) {
		return newRV_inc( SvRV(thing) );
	} else {
		return SvREFCNT_inc(thing);
	}
}

#endif
