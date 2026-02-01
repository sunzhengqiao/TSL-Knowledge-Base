#Version 8
#BeginDescription
v1.04__17Mar2020__Changed from T to O type to preserve it after element generation
V1.3__3 Mar 2020__Added 1.5x1.5x5 size clip
V1.2__2 Feb 2020__Swaped values for Leg1 and Width
V1.1__30 Jan 2020__Added info for schedule
#End
#Type O
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/*
<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>

								craig.colomb@hsbcad.com
                                                       
<>--<>--<>--<>--<>--<>--<>--<>_____  craigcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>

*/

//###################################################################################
//########################## Constants and Properties #########################################
String stLeg1Key = "Leg1Length";
String stLeg2Key = "Leg2Length";
String stWidthKey = "Width";
String stTypeKey = "Type";
String stClipType = "Clip";
String stHangerType = "Hanger";

int bIsMetricDwg = U(1, "mm") == 1;

int bInDebug, bDebug = false;
if(_bOnDebug) bInDebug = true;
//bInDebug = true;

// Properties
Map mpClips, mpClip;
mpClip.setDouble(stLeg1Key, 1.5);
mpClip.setDouble(stLeg2Key, 1.5);
mpClip.setDouble(stWidthKey, 5);
mpClip.setString(stTypeKey, stClipType);
mpClips.setMap("1.5x1.5x5", mpClip);
	
mpClip.setDouble(stLeg1Key, 1.5);
mpClip.setDouble(stLeg2Key, 1.5);
mpClip.setDouble(stWidthKey, 6);
mpClip.setString(stTypeKey, stClipType);
mpClips.setMap("1.5x1.5x6", mpClip);

mpClip.setDouble(stLeg1Key, 1.5);
mpClip.setDouble(stLeg2Key, 1.5);
mpClip.setDouble(stWidthKey, 8);
mpClip.setString(stTypeKey, stHangerType);
mpClips.setMap("1.5x1.5x8", mpClip);

mpClip.setDouble(stLeg1Key, 4);
mpClip.setDouble(stLeg2Key, 1.5);
mpClip.setDouble(stWidthKey, 6);
mpClip.setString(stTypeKey, stClipType);
mpClips.setMap("1.5x4x6", mpClip);

mpClip.setDouble(stLeg1Key, 4.5);
mpClip.setDouble(stLeg2Key, 2.1875);
mpClip.setDouble(stWidthKey, 8.25);
mpClip.setString(stTypeKey, stClipType);
mpClips.setMap("SJC8.25", mpClip);

String stYN[] = { T("|Yes|"), T("|No|")};
String stFaces[] = { T("|Outside|"), T("|Inside|")};
String stClipNames[0];
for (int i=0;i<mpClips.length();i++) 
{ 
	String name = mpClips.keyAt(i); 
	stClipNames.append(name);
}

String stPropertiesCategory = T("|Clip Geometry|");
PropString psClipName (0, stClipNames, T("|Clip|"));
PropString psFace(2, stFaces, T("|Attachment Face|"));
PropDouble pdLeg1 (0, 0, T("|Leg 1|"));
PropDouble pdLeg2 (1, 0, T("|Leg 2|"));
PropDouble pdWidth (2, 0, T("|Width|"));
PropString psType (1, "", T("|Type|")
);
pdLeg1.setCategory(stPropertiesCategory);
pdLeg1.setReadOnly(true);
pdLeg2.setCategory(stPropertiesCategory);
pdLeg2.setReadOnly(true);
pdWidth.setCategory(stPropertiesCategory);
pdWidth.setReadOnly(true);
psType.setCategory(stPropertiesCategory);
psType.setReadOnly(true);

if(_bOnMapIO )
{ 
	eraseInstance();
	return;
}

// bOnInsert
if (_bOnInsert)
{
	// prompt for male beamMales
	Beam beamMales[0];
	PrEntity ssE(T("|Select male beam(s)|"), Beam());
	if (ssE.go())
		beamMales.append(ssE.beamSet());
		
	if(beamMales.length() ==0)
	{ 
		eraseInstance();
		return;
	}
	
	Beam beamFemale = getBeam(T("|Select female beam|"));
	if(!beamFemale.bIsValid())
	{ 
		eraseInstance();
		return;
	}
	
	Element element = beamFemale.element();
	if(!element.bIsValid())
	{ 
		reportMessage("\n" + scriptName() + "_" + _ThisInst.handle() + " " + T("|has been deleted because female beam does not belong to a valid element|\n")); 
		eraseInstance();
		return;
	}
	
	// create TSL
	TslInst tslNew;				Vector3d vecXTsl = _XW;			Vector3d vecYTsl = _YW;
	Entity entsTsl[] = { element};			Point3d ptsTsl[] = { };
	int nProps[] ={ };			double dProps[] ={ };				String sProps[] ={ };
	Map mapTsl;
	
	for (int b = 0; b < beamMales.length(); b++)
	{
		Beam beamMale = beamMales[b];
		if(!beamMale.bIsValid())
			continue;
		
		GenBeam gbsTsl[] = { beamMale, beamFemale};
		tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
	}//next b
	
	eraseInstance();
	return;
}
// end on insert	__________________

// set properties
if(_Map.hasMap("mpMasterInstructions"))//___FLR_LadderCFS will make this entry when inserting this script
{ 
	Map mpMasterInstructions = _Map.getMap("mpMasterInstructions");
	psClipName.set(mpMasterInstructions.getString("stClipName"));
	psFace.set(mpMasterInstructions.getString("stFace"));
	_Map.removeAt("mpMasterInstructions", true);
}

mpClip = mpClips.getMap(psClipName);
pdLeg1.set(mpClip.getDouble(stLeg1Key));
pdLeg2.set(mpClip.getDouble(stLeg2Key));
pdWidth.set(mpClip.getDouble(stWidthKey));
psType.set(mpClip.getString(stTypeKey));

//######################## End Constants and Properties #########################################
//###################################################################################

// validations
if (_Entity.length() == 0) //WARNING : it's assumed that female beam always belongs to an element
{
	if (_Beam.length() == 2) // this is a former version of this TSL which was a T type and did not collect element info. need to be replace by an O type with new references
	{
		Beam bmMale = _Beam[0];
		if(!bmMale.bIsValid())
		{ 
			if (bDebug) { reportMessage("\n" + scriptName() + "_" + _ThisInst.handle() + " " + T("|has been deleted because male beam was not valid when trying to clone|\n")); }
			eraseInstance();
			return;
			
		}
		Beam bmFemale = _Beam[1];
		if ( ! bmFemale.bIsValid())
		{
			if (bDebug) { reportMessage("\n" + scriptName() + "_" + _ThisInst.handle() + " " + T("|has been deleted because female beam was not valid when trying to clone|\n")); }
			eraseInstance();
			return;
		}
		
		Element element = bmFemale.element();
		if ( ! element.bIsValid())
		{
			if (bDebug) { reportMessage("\n" + scriptName() + "_" + _ThisInst.handle() + " " + T("|has been deleted because element was not valid when trying to clone|\n")); }
			eraseInstance();
			return;			
		}
		
		// create TSL
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {bmMale, bmFemale};		Entity entsTsl[] = {element};			Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};			double dProps[]={};				String sProps[]={};
		Map mapTsl;	
					
		tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
		tslNew.setPropValuesFromMap(_ThisInst.mapWithPropValues());
		
		eraseInstance();
		return;
	}
	else
	{
		if (bDebug) {reportMessage("\n" + scriptName() + "_" + _ThisInst.handle() + " " + T("|has been deleted because there was not a valid entity and 2 beams|\n"));}
		eraseInstance();
		return;
	}
}

Element element = (Element)_Entity[0];
if(!element.bIsValid())
{ 
	if (bDebug){reportMessage("\n" + scriptName() + "_" + _ThisInst.handle() + " " + T("|has been deleted because there was not a valid element|\n"));}
	eraseInstance();
	return;
}

assignToElementGroup(element, true,0,'E');

if(_Beam.length() == 0)
{
	if (bDebug) { reportMessage("\n" + scriptName() + "_" + _ThisInst.handle() + " " + T("|has been deleted because _Beam.length() should be != 0 and is|"+_Beam.length()+"\n")); }
	eraseInstance();
	return;
}

Beam bmMale = _Beam[0]; 
if ( ! bmMale.bIsValid() )
{
	if (bDebug) { reportMessage("\n" + scriptName() + "_" + _ThisInst.handle() + " " + T("|has been deleted because male beam is not valid|\n")); }
	eraseInstance();
	return;
}
	
if ( _bOnElementConstructed ) //get new female beam
{
	Vector3d vMaleX = bmMale.vecX();	
	if (vMaleX.dotProduct(_Pt0 - bmMale.ptCen()) < 0)
		vMaleX = - vMaleX;

	Beam beams [] = element.beam();
	beams.removeAt(beams.find(bmMale, - 1));
	
	Beam beamIntersects [] = Beam().filterBeamsHalfLineIntersectSort(beams, bmMale.ptCenSolid(), vMaleX);
	if (beamIntersects.length() > 0)
	{
		Beam beamFemale = beamIntersects[0];
		if ( beamFemale.bIsValid())
		{
			_Beam.append(beamFemale);
		}
	}
}

Beam bmFemale;
int bFemaleFound;
if (_Beam.length() > 1)
{
	bmFemale = _Beam[1];
	if ( bmFemale.bIsValid())
	{
		bFemaleFound = true;
	}	
}

if ( ! bFemaleFound)
{
	Vector3d vMaleX = bmMale.vecX();	
	if (vMaleX.dotProduct(_Pt0 - bmMale.ptCen()) < 0) // at this point _Pt0 was already placed in the correct male end
		vMaleX = - vMaleX;
		
	_Pt0 = bmMale.ptCenSolid() + vMaleX * bmMale.solidLength() * .5;
	return;
}

//region  Basic Geometry
//################################################################
//################################################################
Vector3d vFemaleX = bmFemale.vecX();
Vector3d vMaleX = bmMale.vecX();
if(vMaleX.dotProduct(bmFemale.ptCen() - bmMale.ptCen()) < 0)
	vMaleX = - vMaleX;
Vector3d vMaleY = bmMale.vecD(vFemaleX);
Vector3d vMaleZ = vMaleX.crossProduct(vMaleY);
_Pt0 = bmMale.ptCenSolid() + vMaleX * bmMale.solidLength() * .5;

if(abs(vMaleX.dotProduct(bmFemale.ptCen()-_Pt0)) > bmFemale.dD(vMaleX))
{ 
	return;
}

Body bdMale = bmMale.envelopeBody(true, true);
Body bdFemale = bmFemale.envelopeBody(true, true);
Line lnMaleAxis(bmMale.ptCen(), vMaleX);
Line lnFemaleParallel(bmMale.ptCen(), vFemaleX);
Point3d ptsMaleIntersect[] = bdMale.intersectPoints(lnFemaleParallel);
Point3d ptsFemaleIntersect[] = bdFemale.intersectPoints(lnMaleAxis);

_Pt0 = ptsFemaleIntersect.first();
Point3d ptIntersectAverage;
ptIntersectAverage.setToAverage(ptsMaleIntersect);
Vector3d vToIntersect = ptIntersectAverage - bmMale.ptCen();

//__Construction of vToIntersect will fail with symmetric profiles
if(vToIntersect.length() < .000001)
{ 
	reportMessage("ClipHanger cannot analyze male geometry, self destructing");
	eraseInstance();
	return;
}

Vector3d vToOutside = vMaleY;
if (vToOutside.dotProduct(vToIntersect) < 0) vToOutside *= -1;
Line lnToOutside (bmMale.ptCen(), vToOutside);
ptsMaleIntersect = lnToOutside.orderPoints(ptsMaleIntersect);

Point3d ptMaleInside = ptsMaleIntersect.first();
Point3d ptMaleOutside = ptsMaleIntersect.last();
//Plane pnWebInside(pt, vToOutside);
//Plane pnWebOutside(ptsMaleIntersect.last(), vToOutside);
Plane pnFemaleWebFace(ptsFemaleIntersect.first(), bmFemale.vecD(vMaleX));

Point3d ptClipCorner = pnFemaleWebFace.closestPointTo(ptMaleInside);
Vector3d vToLeg1 = - vMaleX;
Vector3d vToLeg2 = - vToOutside;
if (psFace == stFaces[0]) 
{
	ptClipCorner = pnFemaleWebFace.closestPointTo(ptMaleOutside);
	vToLeg2 = vToOutside;
}

//################################################################
//################################################################
//   End Basic Geometry
//endregion    

//region  Declare Display
//################################################################
//################################################################

Point3d ptLeg1Cen = ptClipCorner + vToLeg1 * pdLeg1 / 2;
MetalPart mpLeg1(ptLeg1Cen, vToLeg1, vToLeg2, vMaleZ, pdLeg1, U(.1), pdWidth, 0, 1, 0);
Point3d ptLeg2Cen = ptClipCorner + vToLeg2 * pdLeg2 / 2;
MetalPart mtpClip(ptLeg2Cen, vToLeg2, - vMaleX, vMaleZ, pdLeg2, U(.1), pdWidth, 0, 1, 0);
mtpClip.addPart(mpLeg1);

//################################################################
//################################################################
//   End Declare Display
//endregion    
 
 //region  Schedule data
//################################################################
//################################################################

_Map.setInt("HANGER_SCHEDULE", 1);
_Map.setInt("HANGER_QTY", 1);
_Map.setString("HANGER_MODEL", psClipName );
//
// if(tsl.bIsValid() && map.hasInt("HANGER_SCHEDULE")>0)
//{
//	entHangerXref.append(tsl.blockRef());
//	arTSL.append(tsl);
//	arIntQTY.append(map.getInt("HANGER_QTY"));
//	
//	String strMod=map.getString("HANGER_MODEL");
//	if(map.getInt("HANGER_LOOSE") == 1)strMod = "Loose - " + strMod;
//	arModel.append(strMod);	
//	
//	String stTopNails = tsl.propString("Top Nails");
//	String stFaceNails = tsl.propString("Face Nails");
//	String stJoistNails = tsl.propString("Joist Nails");
//	int iTopNailsQty = tsl.propInt("Top Nails Qty");
//	int iFaceNailsQty = tsl.propInt("Face Nails Qty");
//	int iJoistNailsQty = tsl.propInt("Joist Nails Qty");
//	if (iTopNailsQty && stTopNails != "") stTopNails = "(" + iTopNailsQty + ") " + stTopNails;
//	if (iFaceNailsQty && stFaceNails != "") stFaceNails = "(" + iFaceNailsQty + ") " + stFaceNails;
//	if (iJoistNailsQty && stJoistNails != "") stJoistNails = "(" + iJoistNailsQty + ") " + stJoistNails;
//	arTopNails.append(stTopNails);
//	arFaceNails.append(stFaceNails);
//	arJoistNails.append(stJoistNails);
//		
//	Point3d arPt[]=map.getPoint3dArray("HANGER_POINTS");
//	
//	for (int p=0; p<arPt.length(); p++) {
//		arVOff.append(map.getVector3d("HANGER_VECTOR"));
//		arModelForPoints.append(strMod);
//		
//		arPointLabel.append(arPt[p]);
//	}
//}
//	
	
//################################################################
//################################################################
//   End Schedule data
//endregion    

if(bInDebug)
{
	Display dp(-1);
	PLine plHandle ;
	plHandle.createCircle( _Pt0, _ZW, U(30, "mm") ) ; // TODO: _Pt0 must be calculated
	dp.draw( plHandle ) ;
	dp.color( 3 ) ;
	plHandle.createCircle( _Pt0, _ZW, U(40, "mm") ) ; // TODO: _Pt0 must be calculated
	dp.draw( plHandle ) ;
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
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End