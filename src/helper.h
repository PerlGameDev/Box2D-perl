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

void _exporting_tag( SV* full_name, const char* tag )
{
	HV* export_tags = get_hv( "Box2D::EXPORT_TAGS", GV_ADD );
	SV** tag_ref = hv_fetch( export_tags, tag, strlen(tag), 1);
	AV* tag_list;
	if(SvOK(*tag_ref)) {
		tag_list = (AV*) SvRV(*tag_ref);
	}
	else {
		tag_list = newAV();
		*tag_ref = newRV_inc((SV*) tag_list);
	}
	av_push( tag_list, full_name );
}

void exporting( char* package_and_name, const char* category, const char* tag )
{
	AV* export_ok = get_av( "Box2D::EXPORT_OK", GV_ADD );
	SV* full_name = newSVpv( package_and_name, 0 );
	av_push( export_ok, full_name );
	
	_exporting_tag( full_name, category );
	_exporting_tag( full_name, tag );
}

void constsub_exporting( HV* stash, const char* name, SV* sv, const char* tag )
{
	newCONSTSUB( stash, name, sv );

	char* package_and_name;
	sprintf( package_and_name, "%s::%s", HvNAME(stash), name );
	exporting( package_and_name, ":constants", tag );
}

#endif
