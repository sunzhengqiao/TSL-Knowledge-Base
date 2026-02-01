#Version 8
#BeginDescription
Last modified by: Robert Pol (support.nl@hsbcad.com)
10.01.2020- version 2.10
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 10
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl hatches specified beams on a layout. The beams can be specified by filter options.
/// </summary>

/// <insert>
/// Select a viewport
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="2.10" date="10.01.2020"></version>

/// <history>
/// AS - 1.00 - 25.11.2011 -	Pilot version
/// AS - 1.01 - 07.12.2011 -	No hatch at text location
/// AS - 1.02 - 08.12.2011 -	Align hatch with beam
/// AS - 1.03 - 26.03.2012 -	Add filters
/// AS - 1.04 - 03.05.2012 -	Hatch specific beams
/// AS - 1.05 - 06.06.2013 -	Add options for hatching beams which are at the arrow, or non-arrow side.
/// AS - 1.06 - 22.12.2016 -	Correct summary.
/// YB - 2.00 - 27.02.2017 -    Changed filter definition, added support for sheeting.
/// YB - 2.01 - 28.06.2017 - 	Add hatch mode and face type.
/// AS - 2.02 - 28.06.2017 - 	Correct index of hatch mode. Respect exrusion profile while getting the envelope body.
/// DR - 2.03 - 26.10.2017	- Corrected <normal> reference vector to be aligned to element's vz
/// RP - 2.04 - 04.01.2019	- Always transform body first to world (HSB-3947)
/// RP - 2.05 - 11.06.2019	- Hatch was aligned to world cs, should be coordsys of each individual genbeam
/// RP - 2.06 - 17.06.2019	- Always take vecX with _ZW as base for planeProfile, because of wrong coordsys of some sheets on generation...
/// RP - 2.07 - 03.09.2019	- Do a check if vecx is not aligned with ZW
/// RP - 2.08 - 03.09.2019	- Get vec most aligned with viewport ucs
/// RP - 2.09 - 29.11.2019	- Normalized vecs from previous check and get the absolute value, otherwise horizontal genbeams are wrong
/// RP - 2.10 - 10.01.2020	- Add dimstyle/textheight and color for text
/// </history>

double dEps = Unit(0.01, "mm");

String categories[] = 
{
	T("|Filters|"),
	T("|Hatching|"),
	T("|Display|"),
	T("|Text|")
};

// Properties
String arSFilterMode[] = {
	T("|Include|"),
	T("|Exclude|")
};

String arSHatchObject[] = {
	T("|Result from filter|"),
	T("|GenBeams at arrow side|"),
	T("|GenBeams at non-arrow side|")
};
String arSHatchPattern[] = {
	T("HSB-|Single diagonal line|")
};
arSHatchPattern.append(_HatchPatterns);

String arSHatchMode[] = 
{
	T("|Body|"),
	T("|Tools|"),
	T("|Face|")
};

String arSFaceType[] = 
{
	T("|Front|"),
	T("|Back|"),
	T("|Both|")
};

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);

PropString filterDefinition(0, filterDefinitions, T("|Filter definition|"));
filterDefinition.setDescription(T("|Filter definition.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
filterDefinition.setCategory(categories[0]);

// Hatch
PropString sHatchObject(1, arSHatchObject, T("|Hatch objects|"));
sHatchObject.setDescription(T("|Define to hatch objects from filter, or objects at arrow|")+T("/|non-arrow side|."));
sHatchObject.setCategory(categories[1]);
PropString sHatchPattern(2, arSHatchPattern, T("|Hatch pattern|"));
sHatchPattern.setDescription(T("|Define hatch pattern used to hatch the GenBeams.|"));
sHatchPattern.setCategory(categories[1]);
PropString sHatchMode(3, arSHatchMode, T("|Hatch mode|"));
sHatchMode.setCategory(categories[1]);
sHatchMode.setDescription(T("|Specifies the hatch mode.|") + TN("|If body: Hatch beam body without tools|") + TN("If tools: Hatch tools.") + TN("|If face: Hatch a specific face.|"));
PropString sFaceType(4, arSFaceType, T("|Face type|"));
sFaceType.setCategory(categories[1]);
sFaceType.setDescription(T("|Specifies the face type|") + TN("|If front: Hatch front face.|") + TN("|If back: Hatch back face.|") + TN("|If both: Hatch both faces.|"));

// Display
PropDouble dHatchScale(0, 1, T("|Hatch scale|"));
dHatchScale.setCategory(categories[2]);
dHatchScale.setDescription(T("|Define the scale of the hatch.|"));
PropInt nHatchColor(0, -1, T("|Hatch color|"));
nHatchColor.setCategory(categories[2]);
nHatchColor.setDescription(T("|Define the color of the hatch|"));

PropString sDimStyleName(5, _DimStyles, T("|Dimension style|"));
sDimStyleName.setCategory(categories[3]);
PropInt nNameColor(1, -1, T("|Text color|"));
nNameColor.setCategory(categories[3]);
PropDouble dNameHeight(1, U(5), T("|Text height|"));
dNameHeight.setCategory(categories[3]);

String arSTrigger[] = {
	T("|Filter this element|"),
	"     ----------",
	T("|Remove filter for this element|"),
	T("|Remove filter for all elements|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );


if( _bOnInsert ){
	_Viewport.append(getViewport(T("Select a viewport")));
	_Pt0 = getPoint(T("Select a point"));
	showDialog();
	return;
}

if( _Viewport.length() == 0 ){
	eraseInstance();
	return; 
}
Viewport vp = _Viewport[0];
Element el = vp.element();

Display dpName(nNameColor);
dpName.dimStyle(sDimStyleName);
dpName.textHeight(dNameHeight);
dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);

// check if the viewport has hsb data
if( !el.bIsValid() )
	return;

// Add filter
if( _kExecuteKey == arSTrigger[0] ){
	Map mapFilterElements;
	if( _Map.hasMap("FilterElements") )
		mapFilterElements = _Map.getMap("FilterElements");
	
	mapFilterElements.setString(el.handle(), "Element Filter");
	_Map.setMap("FilterElements", mapFilterElements);
}

// Remove single filteer
if( _kExecuteKey == arSTrigger[2] ){
	Map mapFilterElements;
	if( _Map.hasMap("FilterElements") ){
		mapFilterElements = _Map.getMap("FilterElements");
		
		if( mapFilterElements.hasString(el.handle()) )
			mapFilterElements.removeAt(el.handle(), true);
		_Map.setMap("FilterElements", mapFilterElements);
	}
}

// Remove all filteer
if( _kExecuteKey == arSTrigger[3] ){
	if( _Map.hasMap("FilterElements") )
		_Map.removeAt("FilterElements", true);
}

Map mapFilterElements;
if( _Map.hasMap("FilterElements") )
	mapFilterElements = _Map.getMap("FilterElements");
if( mapFilterElements.length() > 0 ){
	if( mapFilterElements.hasString(el.handle()) ){
		dpName.color(1);
		dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
		dpName.textHeight(U(2.5));
		dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
		return;
	}
	else{
		dpName.color(30);
		dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);
		dpName.textHeight(U(2.5));
		dpName.draw(T("|Active filter|"), _Pt0, _XW, _YW, 1, 1);
	}
}

int nHatchObject = arSHatchObject.find(sHatchObject,0);

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert();
double dVpScale = ps2ms.scale();

//Display dpTxt(nTxtColor);
//dpTxt.dimStyle(sDimStyleTxt, dVpScale);
//dpTxt.textHeight(dTxtHeight/dVpScale);

Display dpHatch(nHatchColor);
//dpHatch.dimStyle(sDimStyleTxt, dVpScale);

Hatch hatch(sHatchPattern, dHatchScale);

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Plane pnElZ(ptEl, vzEl);

double dElBmH = el.dBeamHeight();
double dElBmW = el.dBeamWidth();

GenBeam genBeams[] = el.genBeam();

Entity hatchEntities[0];
for (int b=0;b<genBeams.length();b++)
	hatchEntities.append(genBeams[b]);

Vector3d normal = _ZW;
	
if (nHatchObject == 0)
{
	Map filterGenBeamsMap;
	filterGenBeamsMap.setEntityArray(hatchEntities, false, "GenBeams", "GenBeams", "GenBeam");
	int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterDefinition, filterGenBeamsMap);
	
	if (!successfullyFiltered) {
		reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
		eraseInstance();
		return;
	} 
	
	hatchEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
}

CoordSys world(_PtW, _XW, _YW, _ZW);

for(int i=0;i<hatchEntities.length();i++)
{
	GenBeam gBm = (GenBeam)hatchEntities[i];
	if(!gBm.bIsValid())
		continue;
		
	if( nHatchObject == 1 || nHatchObject == 2 )
	{
		// It has to be a beam in this case.
		if (!gBm.bIsKindOf(Beam()))
			continue;
		
		// Check if beam is on the front or the back of the element
		int bHatchBeam = false;
		
		int nSide = 1;
		if (nHatchObject == 2)
			nSide *= -1;
		Point3d ptSide = el.zone(nSide).coordSys().ptOrg();
		Point3d ptOtherSide = el.zone(-nSide).coordSys().ptOrg();
		
		double dToThisSide = (vzEl * nSide).dotProduct(ptSide - gBm.ptCen());
		double dToOtherSide = (vzEl * -nSide).dotProduct(ptOtherSide - gBm.ptCen());
		
		if( (dToThisSide - 0.5 * gBm.dD(vzEl)) < dEps && (dToOtherSide - 0.5 * gBm.dD(vzEl)) > dEps )
			bHatchBeam = true;
		
		if (!bHatchBeam) 
			continue;
	}
	
	int bDrawAll = arSHatchMode.find(sHatchMode, 0) == 0;
	int bDrawTools = arSHatchMode.find(sHatchMode, 0) == 1;
	int bDrawFace = arSHatchMode.find(sHatchMode, 0) == 2;
	
	int bDrawFront = arSFaceType.find(sFaceType, 0) == 0;
	int bDrawBack = arSFaceType.find(sFaceType, 0) == 1;
	int bDrawBoth = arSFaceType.find(sFaceType, 0) == 2;
	
	Body bdBm;
	
	Body realB = gBm.realBody();
	Body envelopeB = gBm.envelopeBody(true, true);
	realB.transformBy(ms2ps);
	realB.vis(3);
	envelopeB.transformBy(ms2ps);
	if(bDrawAll)
		bdBm = realB;
	else if(bDrawTools)
		bdBm = envelopeB - realB;	
		
	CoordSys genBeamCoordSys = gBm.coordSys();
	genBeamCoordSys.transformBy(ms2ps);
	Vector3d genBeamX = genBeamCoordSys.vecX();
	genBeamX.normalize();
	Vector3d genBeamY = genBeamCoordSys.vecY();
	genBeamY.normalize();
	Vector3d genBeamZ = genBeamCoordSys.vecZ();
	genBeamZ.normalize();
	double testX = abs(genBeamX.dotProduct(_ZW));
	double testY = abs(genBeamY.dotProduct(_ZW));
	double testZ = abs(genBeamZ.dotProduct(_ZW));

	// get the vec most aligned with viewport ucs
	if (testY < testX - dEps)
	{
		genBeamX = genBeamY;
	}	
	else if (testZ < testX - dEps)
	{
		genBeamX = genBeamZ;
	}
	
	CoordSys correctedCoordsys(genBeamCoordSys.ptOrg(), genBeamX, genBeamX.crossProduct(_ZW), _ZW);
	PlaneProfile ppBm(correctedCoordsys);
	
	if(!bDrawFace)
		int bUnioned = ppBm.unionWith(bdBm.shadowProfile(Plane(world.ptOrg(), normal)));
	else
	{
		Point3d faceOrigins[0];
		
		// TODO If front or back use envelopebody - realbody
		
		
		if(bDrawFront || bDrawBoth)
			faceOrigins.append(envelopeB.ptCen() + normal * 0.5 * envelopeB.lengthInDirection(normal));
		if(bDrawBack || bDrawBoth)
			faceOrigins.append(envelopeB.ptCen() - normal * 0.5 * envelopeB.lengthInDirection(normal));
			
		if(bDrawBoth)
		{ 
			if(faceOrigins.length() != 2)
				break;
			PlaneProfile ppTotal;
			for(int p = 0; p < faceOrigins.length(); p++)
			{
				Plane pl(faceOrigins[p], normal);
				PlaneProfile realProfile = realB.extractContactFaceInPlane(pl, U(10));
				PlaneProfile envelopeProfile = envelopeB.extractContactFaceInPlane(pl, U(10));
				int substracted = envelopeProfile.subtractProfile(realProfile);
			
				ppTotal.unionWith(envelopeProfile);
			}
			
			ppBm = ppTotal;
		}
		else
		{
			if(faceOrigins.length() != 1)
				break;
			Plane pl(faceOrigins[0], normal);
			PlaneProfile realProfile = realB.extractContactFaceInPlane(pl, U(10));
			PlaneProfile envelopeProfile = envelopeB.extractContactFaceInPlane(pl, U(10));
			int substracted = envelopeProfile.subtractProfile(realProfile);
			
			ppBm = envelopeProfile;
		}

	}

	if( arSHatchPattern.find(sHatchPattern) == 0 )
	{
		Point3d arPtBm[] = ppBm.getGripVertexPoints();
		Vector3d vxBm = gBm.vecX();
		Vector3d vyBm = gBm.vecD(vzEl.crossProduct(vxBm));
		Line lnBmX(gBm.ptCen(), vxBm);
		Line lnBmY(gBm.ptCen(), vyBm);
		
		Point3d arPtBmX[] = lnBmX.orderPoints(arPtBm);
		Point3d arPtBmY[] = lnBmY.orderPoints(arPtBm);
		
		if( (arPtBmX.length() * arPtBmY.length()) == 0 )
			continue;
		
		Point3d ptBL = arPtBmX[0];
		ptBL += vyBm * vyBm.dotProduct(arPtBmY[0] - ptBL);
		Point3d ptTR = arPtBmX[arPtBmX.length() - 1];
		ptTR += vyBm * vyBm.dotProduct(arPtBmY[arPtBmY.length() - 1] - ptTR);
		
		LineSeg lnSeg = ppBm.extentInDir(vxBm);
		dpHatch.draw(lnSeg);
	}
	else
	{
		dpHatch.draw(ppBm, hatch);
	}	
}




#End
#BeginThumbnail



















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End