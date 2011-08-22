#ifndef __PERLRAYCASTCALLBACK_H__
#define __PERLRAYCASTCALLBACK_H__

#include <Box2D/Box2D.h>
#include <helper.h>

class PerlRayCastCallback : public b2RayCastCallback
{

protected:
	SV* reportFixture;

public:
	PerlRayCastCallback() : reportFixture(NULL) {}

	~PerlRayCastCallback(){};

	virtual float32 ReportFixture( b2Fixture *fixture, const b2Vec2 &point, const b2Vec2 &normal, float32 fraction )
	{
		float32 rv = 0.0;

		if (reportFixture) {
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
		}

		return rv;
	}

	void SetReportFixtureSub( void * ourSub ) {
		/* Take a copy of the callback */
		if ( reportFixture == NULL ) {
			/* First time, so create a new SV */
			reportFixture = newSVsv( (SV*)ourSub );
		} else {
			/* Been here before, so overwrite */
			SvSetSV( reportFixture, (SV*)ourSub );
		}
	}
};

#endif
