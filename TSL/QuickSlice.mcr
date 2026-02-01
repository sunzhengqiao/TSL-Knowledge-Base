#Version 8
#BeginDescription
Creates a polyline by projecting a user defined plane through a beam.  
Responds dynamically to grips, circled grip moves entire plane 
without rotation.  Assigned to Defpoints to prevent plotting.
©Craig Colomb__ 2006___cc@craigcad.us
V2.0 __ 9MARCH2007__Conversion of original QuickSlice to use HSB standard plane selection.



V2.1 2/23/2023 New and Improved! Bugfixes on grip behavior. Rt-click options to lock vertical, and commit Plines. Works from set of Entities cc
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 1
#KeyWords 
#BeginContents
/*

<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>

Creates a polyline by projecting a user defined plane through a beam.  
Responds dynamically to grips, circled grip moves entire plane 
without rotation.  Assigned to Defpoints to prevent plotting.

V2.0 _ 9MARCH2007__Conversion of original QuickSlice to use HSB standard plane selection.

Email  cc@craigcad.us
© Craig Colomb 2006

<>--<>--<>--<>--<>--<>--<>--<>_____  craigcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>
*/

 
// ** Change layer name if desired **
assignToLayer( "DEFPOINTS" ) ;// ** Comment or erase this line to remove auto-layering.**

Point3d ptPick[0] ;
PropInt piColor(0, 4, "Color");

if (_bOnInsert) {
	
	Point3d ptLast = _Pt0;
	PrEntity pre("Select Entities");
	if (pre.go() == _kOk)
	{
		Entity ents[] = pre.set();
		for(int i=0; i<ents.length(); i++)
		{
			Entity ent = ents[i];
			Body bd = ent.realBodyTry();
			if (bd.isNull()) continue;
			_Entity.append(ent);
		}
	}
	else
	{ 
		eraseInstance();
		return;
	}
	
	_Pt0 = getPoint("\nSelect start point");
	ptLast = _Pt0 ;

  	while (1) {  //-------Loop through selections until user break;

   		PrPoint ssP2("\nSelect next point",ptLast); 
	
		if (ssP2.go()==_kOk)// do the actual query 
		{ 
	 		ptLast = ssP2.value(); // retrieve point
			_PtG.append(ptLast); // append to  _PtG
			if ( _PtG.length() == 2 ) break ; // Continue to query until return or 3 total selections
		}
		else break; // not selecting, break out of infinite while
     } //------Close while loop
	
	return;	
} 
//------------- end insert routine


//-------------------Declare variables, convert get beam realbody for slicing.


String stLockVerticalCommand = T("|Lock Vertical plane|");
addRecalcTrigger(_kContextRoot, stLockVerticalCommand);
if(_kExecuteKey == stLockVerticalCommand)
{ 
	_Map.setInt("iLockPlumb", 1);
}

//---------------------Construct slicing plane, construction dependant on number of selected points

Plane pnSlice;
int bLocked = _Map.getInt("iLockPlumb") ;
if(bLocked || _PtG.length() == 1)
{ 
	Vector3d vBaseNorm = bLocked ? _ZW : _ZU;
	Plane pnBase(_Pt0, vBaseNorm);
	bLocked = true;
	_PtG.setLength(1);
	_PtG[0] = pnBase.closestPointTo(_PtG[0]);
	
	Vector3d vGrip0 = _PtG[0] - _Pt0;
	if (vGrip0.length() < U(.1, "inch")) vGrip0 = _Map.getVector3d("vGrip0");
	Vector3d vNorm = (vGrip0).crossProduct(vBaseNorm);
	pnSlice = Plane(_Pt0, vNorm);
}
else
{ 
	Vector3d vGrip0 = _PtG[0] - _Pt0;
	if (vGrip0.length() < U(.1, "inch")) vGrip0 = _Map.getVector3d("vGrip0");
	Vector3d vGrip1 = _PtG[1] - _Pt0;
	if (vGrip1.length() < U(.1, "inch")) vGrip1 = _Map.getVector3d("vGrip1");
	pnSlice = Plane(_Pt0, _PtG[0], _PtG[1]);
}

Vector3d vNorm = pnSlice.normal();

//------------------Create circles to show _Pt0
PLine pCirBig;
pCirBig.createCircle(_Pt0,vNorm,U(1.5 ) ) ;
PLine pCirSmall;
pCirSmall.createCircle(_Pt0,vNorm, U(.75 ) ) ;

int bCommitLines;
String stCommitPLinesCommand = T("|Commit Lines|");
addRecalcTrigger(_kContextRoot, stCommitPLinesCommand);
if (_kExecuteKey == stCommitPLinesCommand) bCommitLines = true;

pnSlice.vis(2);

//--------------------Display creation, do slicing!
Display dp (piColor) ;
Entity entsValid[0];
for(int i=0; i<_Entity.length(); i++)
{
	Entity ent = _Entity[i];
	Body bd = ent.realBodyTry();
	if (bd.isNull()) continue;
	entsValid.append(ent);
	
	PlaneProfile pp = bd.getSlice(pnSlice);
	dp.draw(pp);
	
	if(bCommitLines)
	{ 
		PLine rings[] = pp.allRings();
		for(int i=0; i<rings.length(); i++)
		{
			PLine ring = rings[i];
			EntPLine epl;
			epl.dbCreate(ring);
		}
	}
}

if(bCommitLines)
{ 
	eraseInstance();
	return;
}

dp.draw( pCirBig ) ;
dp.draw( pCirSmall ) ;

Vector3d vGrip0 = _PtG[0] - _Pt0;
vGrip0.normalize();
_Map.setVector3d("vGrip0", vGrip0);

if(_PtG.length() > 1)
{ 
	Vector3d vGrip1 = _PtG[1] - _Pt0;
	vGrip1.normalize();
	_Map.setVector3d("vGrip1", vGrip1);
}





#End
#BeginThumbnail





#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="0.00155" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="New and Improved! Bugfixes on grip behavior. Rt-click options to lock vertical, and commit Plines. Works from set of Entities" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="2/23/2023 11:39:10 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End