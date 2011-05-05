#ifndef __PERLCONTACTLISTENER_H__
#define __PERLCONTACTLISTENER_H__

#include <Box2D/Box2D.h>
#include <helper.h>

class PerlContactListener : public b2ContactListener
{
  public:
  void * beginContact;
  void * endContact;
  void * preSolve;
  void * postSolve;
  
  PerlContactListener( ):
    beginContact(NULL),
    endContact(NULL),
    preSolve(NULL),
    postSolve(NULL) {}
  
    ~PerlContactListener(){};
  
//  void SetBeginContactSub( void * ourSub ) {
//    /* Take a copy of the callback */
//      if (beginContact == (SV*)NULL)
//        /* First time, so create a new SV */
//        beginContact = newSVsv( ourSub ) ;
//      else
//        /* Been here before, so overwrite */
//        SvSetSV(beginContact,  ourSub ) ;
//  }
//  void SetEndContactSub( void * s) {
//    /* Take a copy of the callback */
//      if (endContact == (SV*)NULL)
//        /* First time, so create a new SV */
//        endContact = newSVsv(s) ;
//      else
//        /* Been here before, so overwrite */
//        SvSetSV(endContact, s) ;
//  }
//  void SetPreSolveSub( void * s ) {
//    /* Take a copy of the callback */
//      if (preSolve == (SV*)NULL)
//        /* First time, so create a new SV */
//        preSolve = newSVsv(s) ;
//      else
//        /* Been here before, so overwrite */
//        SvSetSV(preSolve, s) ;
//  }
//  void SetPostSolveSub( void * s) {
//
//      if (postSolve == (SV*)NULL)
//        /* First time, so create a new SV */
//        postSolve = newSVsv(s) ;
//      else
//        /* Been here before, so overwrite */
//        SvSetSV(postSolve, s) ;
//  }

  b2Contact * ourContact( b2Contact * c );
  b2Manifold * ourManifold( b2Manifold * c );
  b2ContactImpulse * ourContactImpulse( b2ContactImpulse * c );


  void BeginContact(b2Contact* contact)
  { 
    if (!beginContact) {
      dSP;
      ENTER;
      SAVETMPS;
      PUSHMARK(SP);
      XPUSHs( sv_2mortal( newSVpv( "Begin",0 )));
      PUTBACK;
      call_sv( (SV*)beginContact, G_DISCARD );
      FREETMPS;
      LEAVE;
    }
  }
  
  void EndContact(b2Contact* contact)
  { 
    if (!endContact) {
      dSP;
      ENTER;
      SAVETMPS;
      PUSHMARK(SP);
      XPUSHs( sv_2mortal( newSVpv( "End",0)));//ourContact(contact), 0 )));
      PUTBACK;
      call_sv( (SV*)endContact, G_DISCARD );
      FREETMPS;
      LEAVE;
    }
  }
  
  void PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
  { 
    if (!preSolve) {
      dSP;
      ENTER;
      SAVETMPS;
      PUSHMARK(SP);
      XPUSHs( sv_2mortal( newSVpv( "preC",0)));//ourContact(contact), 0 )));
      XPUSHs( sv_2mortal( newSVpv( "preM",0)));//ourManifold(oldManifold), 0 )));
      PUTBACK;
      call_sv( (SV*)preSolve, G_DISCARD );
      FREETMPS;
      LEAVE;
      
    }
  }

  void PostSolve(b2Contact* contact, const b2Manifold* oldManifold)
  { 
    if (!preSolve) {
      dSP;
      ENTER;
      SAVETMPS;
      PUSHMARK(SP);
      XPUSHs( sv_2mortal( newSVpv( "postC",0)));//ourContact(contact), 0 )));
      XPUSHs( sv_2mortal( newSVpv( "postM",0)));//ourManifold(oldManifold), 0 )));
      PUTBACK;
      call_sv( (SV*)postSolve, G_DISCARD );
      FREETMPS;
      LEAVE;
      
    }
  }

};

#endif
