#Version 8
#BeginDescription

Version 1.0 29-11-2022 Initial version Ronald van Wijngaarden
Version 1.1 13-12-2022 Add showInDxa to the display, to show the tsl in hsbmake Ronald van Wijngaarden
Version 1.2 29-3-2023 Add check for multiple instances of this tsl. If present, delete them. Ronald van Wijngaarden



Version 1.3 5-2-2025 Add property to choose the sublayer to assign the tsl to. Ronald van Wijngaarden
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl shows opening info in modelspace
/// </summary>

/// <insert>
/// Select a element
/// </insert>


//#Versions
//1.3 5-2-2025 Add property to choose the sublayer to assign the tsl to. Ronald van Wijngaarden
//1.2 29-3-2023 Add check for multiple instances of this tsl. If present, delete them. Ronald van Wijngaarden
//1.1 13-12-2022 Add showInDxa to the display, to show the tsl in hsbmake Ronald van Wijngaarden
//1.0 29-11-2022 Initial version Ronald van Wijngaarden



Unit(1,"mm"); // script uses mm
double dEps = U(0.1);
double vectorTolerance = U(0.01);

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};
String category = T("|General|");
int bDebug=_bOnDebug;
bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
String sLastInserted =T("|_LastInserted|");	
String executeKey = "ManualInsert";

String layers[] = {
	T("|T|"),
	T("|I|"),
	T("|G|")
};

category = T("|Information|");
String arSInfo[] = {
	T("|Description|"),
	T("|Description| & ") + T("|Header|"),
	T("|Description| & ") +T("|Size|"),
	T("|None|")
};

PropString sInformationToShow(1, arSInfo, "     "+T("|Information|"));
sInformationToShow.setCategory(category);

PropString sCustomText(5, "", "     "+T("|Custom text|"));
sCustomText.setCategory(category);

PropString sLayer(8, layers, "     "+T("|Assign to layer|"), 0);
sLayer.setCategory(category);

category = T("|Layout|");
PropString sDimStyle(3, _DimStyles, "     "+T("|Dimension style|"));
sDimStyle.setCategory(category);

PropDouble dTextHeight(0, 0, "     "+T("|Text height|"));
dTextHeight.setDescription(T("|0=Default from dimstyle|"));
dTextHeight.setCategory(category);

PropString sDimensionBeamsBesideOpening (7, arSYesNo, "     "+T("|Dimension opening beams|"), 1);
sDimensionBeamsBesideOpening.setDescription(T("|This option will take the opening dimensions looking at the beams around the opening. This will take the gap as set in the openingDetails into account.|"));
sDimensionBeamsBesideOpening.setCategory(category);

PropString sWithCross(4, arSYesNo, "     "+T("|With cross|"));
sWithCross.setCategory(category);

PropString sWithFrame(6, arSYesNo, "     "+T("|With frame|"));
sWithFrame.setCategory(category);

PropInt colorCross(5, -1, "     "+T("|Color cross|"));
colorCross.setCategory(category);

PropInt colorDescription(6, -1, "     "+T("|Color description|"));
colorDescription.setCategory(category);

PropInt colorFrame(7, -1, "     "+T("|Color frame|"));
colorFrame.setCategory(category);

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( _bOnDbCreated && catalogNames.find(_kExecuteKey) != -1 ) 
{
	setPropValuesFromCatalog(_kExecuteKey);	
}



// bOnInsert
if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
				
// silent/dialog
	String sKey = _kExecuteKey;
	sKey.makeUpper();

	if (sKey.length()>0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for(int i=0;i<sEntries.length();i++)
		{
			sEntries[i] = sEntries[i].makeUpper();	
		}
		
		if (sEntries.find(sKey)>-1)
		{
			setPropValuesFromCatalog(sKey);
		}
		else
		{
			setPropValuesFromCatalog(sLastInserted);
		}
	}	
	else	
	{
		showDialog();
		setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
	}
	
// prompt for elements
	PrEntity ssE(T("|Select element(s)|"), Element());
  	if (ssE.go())
  	{
		_Element.append(ssE.elementSet());
  	}

// prepare tsl cloning
	TslInst tslNew;
	Vector3d vecXTsl= _XE;
	Vector3d vecYTsl= _YE;
	GenBeam gbsTsl[] = {};
	Entity entsTsl[1] ;
	Point3d ptsTsl[1];
	int nProps[]={};
	double dProps[]={};
	String sProps[]={};
	Map mapTsl;	
	String sScriptname = scriptName();	

// insert per element
	for(int i=0;i<_Element.length();i++)
	{
		entsTsl[0]= _Element[i];	
		ptsTsl[0]=_Element[i].ptOrg();
		
		tslNew.dbCreate(scriptName(), vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, sLastInserted, true, mapTsl, executeKey, "");
		
		if(bDebug && tslNew.bIsValid())reportMessage("\n"+ scriptName() + " created for " +_Element[i].number());
	}

	eraseInstance();
	return;
}	
// end on insert	__________________


if( _Element.length()==0 ){
	eraseInstance();
	return;
}
Element el = _Element[0];
if( !el.bIsValid() )
	return;

char sublayer = sLayer == "T" ? 'T' : sLayer == "G" ? 'G' : 'I';

CoordSys csEl = el.coordSys();
Point3d ptElOrg = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
//assignToElementGroup(el,true, 0, 'T');// assign to element tool sublayer
assignToElementGroup(el,true, 0, sublayer);// assign to element sublayer

PlaneProfile ppEl(el.plOutlineWall());
LineSeg ls=ppEl.extentInDir(vxEl);
double dElLength=abs(vxEl.dotProduct(ls.ptStart()-ls.ptEnd()));

//Check for multiple of the same tsl's on one element.
TslInst elementTsls[] = el.tslInst();
for ( int t = 0; t < elementTsls.length(); t++) 
{
	TslInst tsl = elementTsls[t];
	String nameToCheck = tsl.scriptName();
	if ( tsl.scriptName() == "hsb_OpeningInfo" && tsl.handle() != _ThisInst.handle())
		tsl.dbErase();
}

int bZoneZeroWidthOnly=true, nZone=99;
if(bZoneZeroWidthOnly)
	nZone=1;
ElemZone elzStart= el.zone(-nZone);
ElemZone elzEnd= el.zone(nZone);
double dElWidth=abs(vzEl.dotProduct(elzStart.coordSys().ptOrg()-elzEnd.coordSys().ptOrg()));
Beam elBeams[] = el.beam();

Point3d ptElBack= ptElOrg+vxEl*dElLength-vzEl*dElWidth; // Back and to the right

Line lnX(ptElOrg, vxEl);
Line lnY(ptElOrg, vyEl);

// resolve properties
int bWithCross = arNYesNo[arSYesNo.find(sWithCross,0)];
int bWithFrame = arNYesNo[arSYesNo.find(sWithFrame,0)];
int nInfo = arSInfo.find(sInformationToShow, 0);
int nDimBeamsBeside = arNYesNo[arSYesNo.find(sDimensionBeamsBesideOpening, 1)];


Display dp(colorDescription);
dp.showInDxa(true);
dp.dimStyle(sDimStyle);
if(dTextHeight>0)
{
	dp.textHeight(dTextHeight);
}

Display dpFrame(-1);
dpFrame.color(colorFrame);
dpFrame.showInDxa(true);
Display dpCross(-1);
dpCross.color(colorCross);

int arNHeaderType[] = {
	_kHeader
};
Beam arBm[] = el.beam();
Beam arBmHeader[0];
for( int i=0;i<arBm.length(); i++ ){
	Beam bm = arBm[i];
	if( arNHeaderType.find(bm.type()) != -1 )
		arBmHeader.append(bm);
}

Opening arOp[] = el.opening();
for( int i=0;i<arOp.length();i++ )
{
	Opening op = arOp[i];
	CoordSys openingCoordSys = op.coordSys();
	PLine plOp = op.plShape();
	
	PlaneProfile ppOpening (plOp);
	Point3d midPointOpening = ppOpening.ptMid();
	
	Point3d openingVertexPoints[] = ppOpening.getGripVertexPoints();
	openingVertexPoints.append(openingVertexPoints[0]);
	
	Point3d openingOutlineMidpoints[] = ppOpening.getGripEdgeMidPoints();
	
	//If closest beams should be dimensioned instead of the opening pLine.
	if (nDimBeamsBeside)
	{		
		for (int p = 0; p < openingVertexPoints.length() - 1; p++)
		{
			Point3d openingVertexPoint = openingVertexPoints[p];
			Point3d nextPoint = openingVertexPoints[p + 1];
			Point3d midPoint = (nextPoint + openingVertexPoint) / 2;
			Vector3d vecDir = nextPoint - openingVertexPoint;
			vecDir.normalize();
			
			Vector3d vecNormal = vecDir.crossProduct(vzEl);
			if (vecNormal.dotProduct(midPoint - midPointOpening) < 0)
			{
				vecNormal *= -1;
			}
			
			//Find closest beams
			Beam beamsClosest[] = Beam().filterBeamsHalfLineIntersectSort(elBeams, midPoint, vecNormal);
			if (beamsClosest.length() < 1) continue;
			Beam closestBeam = beamsClosest[0];
			//Move point to the inside of the opening
			Point3d ptInside = closestBeam.ptCenSolid() - vecNormal * 0.5 * closestBeam.dD(vecNormal);
			ppOpening.moveGripEdgeMidPointAt(openingOutlineMidpoints.find(midPoint), vecNormal * vecNormal.dotProduct(ptInside - midPoint));
		}//next p
		
		PLine ppPlines[] = ppOpening.allRings();
		//check for length
		if (ppPlines.length() > 1)
		{
			plOp = ppPlines[0];
		}
	}
	
	Point3d vertexPoints[] = plOp.vertexPoints(true);
	double beamHeight = el.dBeamWidth();
	if (beamHeight < dEps)
	{
		beamHeight = arBm[0].dD(el.vecZ());
	}
	if (beamHeight < dEps) continue;
 	plOp.transformBy(el.vecZ() * el.vecZ().dotProduct(el.zone(0).coordSys().ptOrg() - vertexPoints[0]));
	Body bdOp(plOp, el.vecZ() * beamHeight);
	
	LineSeg lineSegToDraw[0];
	Plane elementPlane(el.ptOrg(), el.vecZ());
	PlaneProfile bodyProfile = bdOp.shadowProfile(elementPlane);
	if( bWithCross )	{
		
		lineSegToDraw.append(bodyProfile.extentInDir(vxEl));
		lineSegToDraw.append(bodyProfile.extentInDir(vyEl));
		
		lineSegToDraw = bodyProfile.splitSegments(lineSegToDraw, true);
		for (int index=0;index<lineSegToDraw.length();index++) 
		{ 
			LineSeg ls = lineSegToDraw[index]; 
			PLine pline(ls.ptStart(), ls.ptEnd());
			dpCross.draw(pline);
		}
	}
	
	if( bWithFrame )
	{
		for (int index=0;index<lineSegToDraw.length();index++) 
		{ 
			LineSeg ls = lineSegToDraw[index]; 
			PLine pline(ls.ptStart(), ls.ptEnd());
			dpFrame.draw(pline);
		}	
	}

	String sInfo = op.openingDescr();
	
	Point3d ptOp = bdOp.ptCen();
	Point3d ptOpPS = ptOp;
	
	if(nInfo<arSInfo.length()-1)
		dp.draw(sInfo, ptOpPS, vxEl, vyEl, 0, 0);

	if( nInfo == 1 )
	{
		
		for( int j=0;j<arBmHeader.length();j++ ){
			Beam bm = arBmHeader[j];
			Point3d ptBmMin = bm.ptRef() + bm.vecX() * bm.dLMin();
			Point3d ptBmMax = bm.ptRef() + bm.vecX() * bm.dLMax();
			
			if( (bm.vecX().dotProduct(ptBmMin - ptOp) * bm.vecX().dotProduct(ptBmMax - ptOp)) > 0 )
				continue;
			
			Vector3d vxBmPS = bm.vecX();
			Point3d ptTxt = ptBmMin;
			if( vxBmPS.dotProduct(vxEl) < 0 )
				ptTxt = ptBmMax;
			
			dp.draw(bm.material(), ptTxt, vxEl, vyEl, 0, -3);
		}
	}
	else if( nInfo == 2 )
	{		
		double dOpW = vxEl.dotProduct(ppOpening.extentInDir(vxEl).ptEnd() - ppOpening.extentInDir(vxEl).ptStart());
		double dOpH = vyEl.dotProduct(ppOpening.extentInDir(vyEl).ptEnd() - ppOpening.extentInDir(vyEl).ptStart());
		
		String sOpW;
		sOpW.formatUnit(dOpW, 2, 0);
		String sOpH;
		sOpH.formatUnit(dOpH, 2, 0);
		
		String sTxt = sOpW + "x" + sOpH;
		
		dp.draw(sTxt, ptOpPS, vxEl, vyEl, 0, -3);
	}
	
	// Draw custom text
	int nCustomTextDrawingFlag=-3;
	if(nInfo==2)
		nCustomTextDrawingFlag=-6;
	if(nInfo==arSInfo.length()-1)
		nCustomTextDrawingFlag=0;

	dp.draw(sCustomText, ptOpPS, vxEl, vyEl, 0, nCustomTextDrawingFlag);
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
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add property to choose the sublayer to assign the tsl to." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="2/5/2025 10:23:16 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add check for multiple instances of this tsl. If present, delete them." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="3/29/2023 2:39:40 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add showInDxa to the display, to show the tsl in hsbmake" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="12/13/2022 10:46:51 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Initial version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="11/29/2022 9:57:50 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End