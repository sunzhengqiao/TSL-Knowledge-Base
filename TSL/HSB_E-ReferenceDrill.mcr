#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
30.06.2016  -  version 1.05







Version 1.6 17-7-2025 Add display visalization (showInDxa) for the grid to be shown in hsbView. Ronald van Wijngaarden
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl inserts drills as a reference position. The drills are placed along a vertical and/or horizontal line. 
/// This lines are offsetted from the element origin and can be moved with a grippoint afterwards. The drills are placed in the center of the beams.  
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="1.05" date="30.06.2016"></version>

/// <history>
/// AS - 1.00 - 23.04.2014 	- Pilot version
/// AS - 1.01 - 20.06.2014 	- Drill smallest side
/// AS - 1.02 - 20.06.2014 	- Correct vector
/// AS - 1.03 - 17.02.2015 	- Change defaults for 'GH_Dak_Revisie'.
/// AS - 1.04 - 14.04.2015	- Change defaults for 'GH_Dak_Revisie' (again).
/// AS - 1.05 - 30.06.2016	- Add offset for visualisation in multi elements
/// </history>

//#Versions
//1.6 17-7-2025 Add display visalization (showInDxa) for the grid to be shown in hsbView. Ronald van Wijngaarden


double dEps = Unit(0.01, "mm");

int arBExclude[] = {_kNo, _kYes};
String arSFilterType[] = {T("|Include|"), T("|Exclude|")};


PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);
PropString sFilterType(1, arSFilterType, "     "+T("|Filter type|"));
PropString sFilterBC(2, "", "     "+T("|Filter beams with beamcode|"));


PropString sSeperator02(3, "", T("|Position|"));
sSeperator02.setReadOnly(true);
PropString sHorizontalPlanePositions(4, "", "     "+T("|Horizontal positions|"));
PropString sVerticalPlanePositions(5, "500","     "+T("|Vertical positions|"));


PropString sSeperator03(6, "", T("|Drill|"));
sSeperator03.setReadOnly(true);
PropDouble dDiameterDrill(0, U(18),"     "+T("|Diameter|"));


PropString sSeperator04(7, "", T("|Visualisation|"));
sSeperator04.setReadOnly(true);

PropInt nColor(0, 4, "     "+T("|Color|"));
PropDouble dSymbolSize(1, U(40), "     "+T("|Symbol size|"));


double dGripOffset = U(400);


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-ReferenceDrill");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	PrEntity ssE(T("Select a set of elements"), Element());
	
	if( ssE.go() ){
		Element arSelectedElement[] = ssE.elementSet();
		
		String strScriptName = "HSB_E-ReferenceDrill"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Element lstElements[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", TRUE);
		setCatalogFromPropValues("MasterToSatellite");
		mapTsl.setInt("ExecuteMode", 1);// 1 == recalc	
		for( int e=0;e<arSelectedElement.length();e++ ){
			Element el = arSelectedElement[e];
			lstElements[0] = el;
			
			TslInst arTsl[] = el.tslInst();
			for( int i=0;i<arTsl.length();i++ ){
				TslInst tsl = arTsl[i];
				if( tsl.scriptName() == strScriptName ){
					tsl.dbErase();
				}
			}
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}
	}
	
	eraseInstance();
	return;
}

if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", TRUE);
	}
}


if( _Element.length() == 0 ){
	eraseInstance();
	return;
}

Element el = _Element[0];

// Assign tsl to the default element layer.
assignToElementGroup(el, true, 0, 'E');


ElementMulti elMulti = (ElementMulti)el;
int bIsElMulti = elMulti.bIsValid();


//selection
int bAllFiltersEmpty = true;
int bExclude = arBExclude[arSFilterType.find(sFilterType,1)];

String arSFilterBmCode[0];
String sList = sFilterBC + ";";
int nTokenIndex = 0; 
int nCharacterIndex = 0;
while(nCharacterIndex < sList.length()-1){
	String sListItem = sList.token(nTokenIndex,";");
	nTokenIndex++;
	if(sListItem.length()==0){
		nCharacterIndex++;
		continue;
	}
	nCharacterIndex = sList.find(sListItem,0);
	sListItem.trimLeft();
	sListItem.trimRight();
	arSFilterBmCode.append(sListItem);
}
if( arSFilterBmCode.length() > 0 )
	bAllFiltersEmpty = false;


double arDHorizontalPositions[0];
sList = sHorizontalPlanePositions + ";";
sList.makeUpper();
nTokenIndex = 0; 
nCharacterIndex = 0;
while(nCharacterIndex < sList.length()-1){
	String sListItem = sList.token(nTokenIndex);
	nTokenIndex++;
	if(sListItem.length()==0){
		nCharacterIndex++;
		continue;
	}
	nCharacterIndex = sList.find(sListItem,0);
	sListItem.trimLeft();
	sListItem.trimRight();
	arDHorizontalPositions.append(sListItem.atof());
}

double arDVerticalPositions[0];
sList = sVerticalPlanePositions + ";";
sList.makeUpper();
nTokenIndex = 0; 
nCharacterIndex = 0;
while(nCharacterIndex < sList.length()-1){
	String sListItem = sList.token(nTokenIndex);
	nTokenIndex++;
	if(sListItem.length()==0){
		nCharacterIndex++;
		continue;
	}
	nCharacterIndex = sList.find(sListItem,0);
	sListItem.trimLeft();
	sListItem.trimRight();
	arDVerticalPositions.append(sListItem.atof());
}


CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
_Pt0 = ptEl;


Beam arBm[0];
Point3d arPtBm[0];
GenBeam arGBmAll[] = el.genBeam();
for(int i=0;i<arGBmAll.length();i++){
	GenBeam gBm = arGBmAll[i];
	int bFilterGenBeam = false;
	
	//Filter dummies
	if( gBm.bIsDummy() )
		continue;
	
	//Filter beamcodes
	if( !bFilterGenBeam ){
		String sBmCode = gBm.beamCode().token(0).makeUpper();
		sBmCode.trimLeft();
		sBmCode.trimRight();
		
		if( arSFilterBmCode.find(sBmCode)!= -1 ){
			bFilterGenBeam = true;
		}
		else{
			for( int j=0;j<arSFilterBmCode.length();j++ ){
				String sFltrBC = arSFilterBmCode[j];
				String sFltrBCTrimmed = sFltrBC;
				sFltrBCTrimmed.trimLeft("*");
				sFltrBCTrimmed.trimRight("*");
				if( sFltrBCTrimmed == "" ){
					if( sFltrBC == "*" && sBmCode != "" )
						bFilterGenBeam = true;
					else
						continue;
				}
				else{
					if( sFltrBC.left(1) == "*" && sFltrBC.right(1) == "*" && sBmCode.find(sFltrBCTrimmed, 0) != -1 )
						bFilterGenBeam = true;
					else if( sFltrBC.left(1) == "*" && sBmCode.right(sFltrBC.length() - 1) == sFltrBCTrimmed )
						bFilterGenBeam = true;
					else if( sFltrBC.right(1) == "*" && sBmCode.left(sFltrBC.length() - 1) == sFltrBCTrimmed )
						bFilterGenBeam = true;
				}
			}
		}
	}
	
	if( !bAllFiltersEmpty && ((bFilterGenBeam && bExclude) || (!bFilterGenBeam && !bExclude)) )
		continue;
	
	Beam bm = (Beam)gBm;
	if( bm.bIsValid() )
		arBm.append(bm);
		
	arPtBm.append(bm.envelopeBody(false, true).allVertices());
}

// Reference points
Line lnElX(ptEl, vxEl);
Line lnElY(ptEl, vyEl);
// Ordered along x and y axis of element.
Point3d arPtBmX[] = lnElX.orderPoints(arPtBm);
Point3d arPtBmY[] = lnElY.orderPoints(arPtBm);
if( (arPtBmX.length() * arPtBmY.length()) == 0 )
	return;
// Reference points.
Point3d ptBL = arPtBmX[0];
ptBL += vyEl * vyEl.dotProduct(arPtBmY[0] - ptBL);
Point3d ptTR = arPtBmX[arPtBmX.length() - 1];
ptTR += vyEl * vyEl.dotProduct(arPtBmY[arPtBmY.length() - 1] - ptTR);	

Point3d ptReference = ptBL;

if( _kNameLastChangedProp.left(4) == "_PtG" ){
	int nGripIndex = _kNameLastChangedProp.right(_kNameLastChangedProp.length() - 4).atoi();
	
	if( arDHorizontalPositions.length() > 0 && nGripIndex < arDHorizontalPositions.length() ){
		// Update horizontal list, property will be updated at the end of the tsl.
		arDHorizontalPositions[nGripIndex] = vyEl.dotProduct(_PtG[nGripIndex] - ptReference);
	}
	else{
		// Update vertical list.
		arDVerticalPositions[nGripIndex - arDHorizontalPositions.length()] = vxEl.dotProduct(_PtG[nGripIndex] - ptReference);
	}
}

// Get the stored planes.
Vector3d arVNormal[0];
_PtG.setLength(0);
int arBIsHorizontalPn[0];
// Horizontal planes.
for( int i=0;i<arDHorizontalPositions.length();i++ ){
	double dHorizontalPosition = arDHorizontalPositions[i];
	
	_PtG.append(ptReference + vyEl * dHorizontalPosition);
	arVNormal.append(vyEl);
	arBIsHorizontalPn.append(true);
}
// Vertical planes.
for( int i=0;i<arDVerticalPositions.length();i++ ){
	double dVerticalPosition = arDVerticalPositions[i];
	
	_PtG.append(ptReference + vxEl * dVerticalPosition);
	arVNormal.append(vxEl);
	arBIsHorizontalPn.append(false);
}

/*
for( int i=0;i<_Map.length();i++ ){
	if( !_Map.hasMap(i) && _Map.keyAt(i) != "Plane" )
		continue;
	
	Map mapPlane = _Map.getMap(i);
	_PtG.append(mapPlane.getPoint3d("PtOrg"));
	
	int bIsHorizontalPn = mapPlane.getInt("IsHorizontal");
	
	Vector3d vNormal = vxEl;
	if( bIsHorizontalPn )
		vNormal = vyEl;
	arVNormal.append(vNormal);
	
	arBIsHorizontalPn.append(bIsHorizontalPn);
}
*/

// Keep grips at the element (offsetted) edges. Get the planes and draw the lines.
Display dpGrid(12);
dpGrid.elemZone(el, 0, 'T');
dpGrid.showInDxa(true);

Plane arPnIntersect[0];
for( int i=0;i<_PtG.length();i++ ){
	int bIsHorizontalPn = arBIsHorizontalPn[i];
	
	Vector3d vLnSeg;
	if( bIsHorizontalPn ){
		_PtG[i] += vxEl * vxEl.dotProduct((ptReference - vxEl * dGripOffset) - _PtG[i]);
		vLnSeg = vxEl;
	}
	else{
		_PtG[i] += vyEl * vyEl.dotProduct((ptReference - vyEl * dGripOffset) - _PtG[i]);
		vLnSeg = vyEl;
	}

	arPnIntersect.append(Plane(_PtG[i], arVNormal[i]));
	
	LineSeg lnSegGrid(_PtG[i], _PtG[i] + vLnSeg * vLnSeg.dotProduct((ptTR + vLnSeg * dGripOffset) - _PtG[i]));
	dpGrid.draw(lnSegGrid);
}

for( int i=0;i<arBm.length();i++ ){
	Beam bm = arBm[i];
	Vector3d vxBm = bm.vecX();
	
	Point3d ptBmMin = bm.ptCenSolid() - vxBm * 0.5 * bm.solidLength();
	Point3d ptBmMax = bm.ptCenSolid() + vxBm * 0.5 * bm.solidLength();
	
	Line lnBmX(bm.ptCen(), vxBm);
	
	for( int j=0;j<arPnIntersect.length();j++ ){
		Plane pnIntersect = arPnIntersect[j];
		Vector3d vNormalPn = pnIntersect.normal();
		if( abs(vxBm.dotProduct(vNormalPn)) < dEps )
			continue;
		
		Point3d ptIntersect = lnBmX.intersect(pnIntersect, U(0));
		if( (vxBm.dotProduct(ptIntersect - ptBmMin) * vxBm.dotProduct(ptIntersect - ptBmMax)) > 0 )
			continue;
		
		Vector3d vDrill = vNormalPn.crossProduct(vzEl);
		vDrill.normalize();
		
		Vector3d vBmDrill = bm.vecD(vDrill);
		Vector3d vOtherBmDrill = bm.vecX().crossProduct(vBmDrill);
		double dBmDrill = bm.dD(vBmDrill);
		double dOtherBmDrill = bm.dD(vOtherBmDrill);
		if (dOtherBmDrill < dBmDrill) 
			vBmDrill = vOtherBmDrill;
		
		Point3d ptStartDrill = ptIntersect - vBmDrill * 0.51 * bm.dD(vBmDrill);
		Point3d ptEndDrill = ptIntersect + vBmDrill * 0.51 * bm.dD(vBmDrill);
		Drill drill(ptStartDrill, ptEndDrill, 0.5 * dDiameterDrill);
		
		bm.addTool(drill);
	}	
}

// Store current planes.
String sHorizontalPositions;
String sVerticalPositions;
for( int i=0;i<_PtG.length();i++ ){
	Point3d pt = _PtG[i];
	int bIsHorizontalPlane = arBIsHorizontalPn[i];
	
	if( bIsHorizontalPlane ){
		double dOffset = vyEl.dotProduct(pt - ptReference);
		String sOffset;
		sOffset.formatUnit(dOffset, 2, 1);
		sHorizontalPositions += (sOffset + ";");
	}
	else{
		double dOffset = vxEl.dotProduct(pt - ptReference);
		String sOffset;
		sOffset.formatUnit(dOffset, 2, 1);		
		sVerticalPositions += (sOffset + ";");
	}
}
sHorizontalPositions.trimRight(";");
sHorizontalPlanePositions.set(sHorizontalPositions);

sVerticalPositions.trimRight(";");
sVerticalPlanePositions.set(sVerticalPositions);

// visualisation
Display dpVisualisation(nColor);
dpVisualisation.textHeight(U(4));
dpVisualisation.addHideDirection(vyEl);
dpVisualisation.addHideDirection(-vyEl);
dpVisualisation.elemZone(el, 0, 'I');

double dMEOffset = U(0);
if (bIsElMulti)
	dMEOffset = U(200);

Point3d ptSymbol01 = _Pt0 - vyEl * 2 * dSymbolSize - vxEl * dMEOffset;
Point3d ptSymbol02 = ptSymbol01 - (vxEl + vyEl) * dSymbolSize;
Point3d ptSymbol03 = ptSymbol01 + (vxEl - vyEl) * dSymbolSize;

PLine plSymbol01(vzEl);
plSymbol01.addVertex(_Pt0 - vxEl * dMEOffset);
plSymbol01.addVertex(ptSymbol01);
PLine plSymbol02(vzEl);
plSymbol02.addVertex(ptSymbol02);
plSymbol02.addVertex(ptSymbol01);
plSymbol02.addVertex(ptSymbol03);

dpVisualisation.draw(plSymbol01);
dpVisualisation.draw(plSymbol02);

Vector3d vxTxt = vxEl + vyEl;
vxTxt.normalize();
Vector3d vyTxt = vzEl.crossProduct(vxTxt);
dpVisualisation.draw(scriptName(), ptSymbol01, vxTxt, vyTxt, -1.1, 1.75);

{
	Display dpVisualisationPlan(nColor);
	dpVisualisationPlan.textHeight(U(4));
	dpVisualisationPlan.addViewDirection(vyEl);
	dpVisualisationPlan.addViewDirection(-vyEl);
	dpVisualisationPlan.elemZone(el, 0, 'I');
	
	Point3d ptSymbol01 = _Pt0 + vzEl * 2 * dSymbolSize - vxEl * dMEOffset;
	Point3d ptSymbol02 = ptSymbol01 - (vxEl - vzEl) * dSymbolSize;
	Point3d ptSymbol03 = ptSymbol01 + (vxEl + vzEl) * dSymbolSize;
	
	PLine plSymbol01(vyEl);
	plSymbol01.addVertex(_Pt0 - vxEl * dMEOffset);
	plSymbol01.addVertex(ptSymbol01);
	PLine plSymbol02(vyEl);
	plSymbol02.addVertex(ptSymbol02);
	plSymbol02.addVertex(ptSymbol01);
	plSymbol02.addVertex(ptSymbol03);
	
	dpVisualisationPlan.draw(plSymbol01);
	dpVisualisationPlan.draw(plSymbol02);
	
	Vector3d vxTxt = vxEl - vzEl;
	vxTxt.normalize();
	Vector3d vyTxt = vyEl.crossProduct(vxTxt);
	dpVisualisationPlan.draw(scriptName(), ptSymbol01, vxTxt, vyTxt, -1.1, 1.75);
}


/*
_Map = Map();
for( int i=0;i<arPnIntersect.length();i++ ){
	Plane pnIntersect = arPnIntersect[i];
	
	Point3d ptPn = pnIntersect.ptOrg();
	Vector3d vNormalPn = pnIntersect.normal();
	
	int bIsHorizontalPn = abs(abs(vNormalPn.dotProduct(vyEl)) - 1) < dEps;
	if( bIsHorizontalPn )
		ptPn = ptEl - vxEl * dGripOffset;
	else
		ptPn = ptEl - vyEl * dGripOffset;

	Map mapPlane;
	mapPlane.setPoint3d("PtOrg", ptPn, _kAbsolute);
	mapPlane.setInt("IsHorizontal", bIsHorizontalPn);
	
	_Map.appendMap("Plane", mapPlane);
}
*/



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
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add display visalization (showInDxa) for the grid to be shown in hsbView." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="7/17/2025 11:34:04 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End