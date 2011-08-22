#ifndef __PERLRAYCASTCALLBACK_H__
#define __PERLRAYCASTCALLBACK_H__

#include <Box2D/Box2D.h>
#include <helper.h>

class PerlRayCastCallback : public b2RayCastCallback
{

protected:
	SV* reportFixture;

public:
	PerlRayCastCallback( void* ourSub ) {
		reportFixture = newSVsv( (SV*)ourSub );
	}

	~PerlRayCastCallback(){};

	virtual float32 ReportFixture( b2Fixture *fixture, const b2Vec2 &point, const b2Vec2 &normal, float32 fraction )
	{
		float32 rv = 0.0;
		int count;

		dSP;

		ENTER;
		SAVETMPS;

		PUSHMARK(SP);
		XPUSHs( sv_2mortal(object_to_stack( sizeof(b2Fixture*), (void*)fixture, "Box2D::b2Fixture" )) );
		XPUSHs( sv_2mortal(object_to_stack( sizeof(b2Vec2*),    (void*)&point,  "Box2D::b2Vec2" )) );
		XPUSHs( sv_2mortal(object_to_stack( sizeof(b2Vec2*),    (void*)&normal, "Box2D::b2Vec2" )) );
		XPUSHs( sv_2mortal(newSVnv(fraction)) );
		PUTBACK;

		count = call_sv( reportFixture, G_SCALAR );

		SPAGAIN;

		if ( count != 0 ) {
			rv = POPn;
		}

		PUTBACK;
		FREETMPS;
		LEAVE;

		return rv;
	}

	void SetReportFixtureSub( void* ourSub ) {
		SvSetSV( reportFixture, (SV*)ourSub );
	}
};

#endif
