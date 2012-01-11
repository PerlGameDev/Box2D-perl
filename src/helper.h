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

void _exporting_tag( HV* export_tags, SV* export_name, const char* tag )
{
	SV** tag_ref = hv_fetch( export_tags, tag, strlen(tag), 1);
	AV* tag_list;
	if(SvOK(*tag_ref)) {
		tag_list = (AV*) SvRV(*tag_ref);
	}
	else {
		tag_list = newAV();
		*tag_ref = newRV_inc((SV*) tag_list);
	}
	av_push( tag_list, export_name );
}

void constsub_exporting( HV* stash, const char* name, SV* sv, const char* tag )
{
	newCONSTSUB( stash, name, sv );

	SV* export_name = newSVpvf( "%s::%s", HvNAME(stash), name );
	
	AV* export_ok = get_av( "Box2D::EXPORT_OK", GV_ADD );
	av_push( export_ok, export_name );
	
	HV* export_tags = get_hv( "Box2D::EXPORT_TAGS", GV_ADD );
	_exporting_tag( export_tags, export_name, ":constants" );
	_exporting_tag( export_tags, export_name, tag );
}

#endif
