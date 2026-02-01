#Version 8
#BeginDescription


Version 2.3 25-3-2022 Add option to take the opening dimension looking at the beams around the opening. Doing this will also take the gap as set in the details into account. Ronald van Wijngaarden

Version2.4 1-8-2022 Fix issue, where the pLine of the opening was not changed when dimensioning closest beams. Ronald van Wijngaarden
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl shows opening info
/// </summary>

/// <insert>
/// Select a viewport
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="2.02" date="06.12.2019"></version>

/// <history>
/// AS - 1.00 - 23.08.2011 - Pilot version
/// AS - 1.01 - 27.06.2012 - Check if viewport has hsbCAD data
/// AS - 1.02 - 17.07.2012 - Align properties
/// AS - 1.03 - 05.06.2013 - Add size as an option
/// AS - 1.04 - 04.02.2015 - Swap opening width and height
/// AS - 1.05 - 12.10.2015 - Add porperty to set the color of the description and cross.
/// DR - 1.60 - 13.04.2017	- Add 3D view and frame. Version correction to 1.6
/// DR - 1.70 - 15.04.2017	- Added properties: Show frame (Yes/No), Color frame (int)
///						- Independent views to show cross and frame separated. 
///						- Display of custom text
/// DR - 1.80 - 19.04.2017	- Added <Text Height> property
/// DR - 1.90 - 02.05.2017	- Reference to Wall().baseHeight() removed to avoid error message on update since some customers are already using this TSL for roofs (unproperly but using it anyway) 
/// 						- Added description
/// DR - 1.91 - 12.05.2017 - Versioning corrected
/// RP - 2.00 - 04.01.2019 - Tsl can be used for non rectangular shapes
/// RP - 2.01 - 11.02.2019 - Make sure tsl will work on non generated walls
/// RP - 2.02 - 06.12.2019 - Only skip openingroof
/// </history>


//#Versions
//2.4 1-8-2022 Fix issue, where the pLine of the opening was not changed when dimensioning closest beams. Ronald van Wijngaarden
//2.3 25-3-2022 Add option to take the opening dimension looking at the beams around the opening. Doing this will also take the gap as set in the details into account. Ronald van Wijngaarden




Unit(1,"mm"); // script uses mm
double dEps = U(0.1);
double vectorTolerance = U(0.01);
int bOnDebug=true;

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

PropString sSeperator01(0, "", T("|Information|"));
sSeperator01.setReadOnly(true);
String arSInfo[] = {
	T("|Description|"),
	T("|Description| & ") + T("|Header|"),
	T("|Description| & ") +T("|Size|"),
	T("|None|")
};
PropString sInformationToShow(1, arSInfo, "     "+T("|Information|"));
PropString sCustomText(5, "", "     "+T("|Custom text|"));

PropString sSeperator02(2, "", T("|Layout|"));
sSeperator02.setReadOnly(true);
PropString sDimStyle(3, _DimStyles, "     "+T("|Dimension style|"));
PropDouble dTextHeight(0, 0, "     "+T("|Text height|"));
	dTextHeight.setDescription(T("|0=Default from dimstyle|"));

PropString sDimensionBeamsBesideOpening (7, arSYesNo, "     "+T("|Dimension opening beams|"), 1);
sDimensionBeamsBesideOpening.setDescription(T("|This option will take the opening dimensions looking at the beams around the opening. This will take the gap as set in the openingDetails into account.|"));

PropString sWithCross(4, arSYesNo, "     "+T("|With cross|"));
PropString sWithFrame(6, arSYesNo, "     "+T("|With frame|"));
PropInt colorCross(5, -1, "     "+T("|Color cross|"));
PropInt colorDescription(6, -1, "     "+T("|Color description|"));
PropInt colorFrame(7, -1, "     "+T("|Color frame|"));

if (_bOnInsert) {
	Viewport vp = getViewport(T("|Select a viewport|")); // select viewport
	_Viewport.append(vp);

	showDialogOnce();
	return;
}

// do something for the last appended viewport only
if( _Viewport.length()==0 ){
	eraseInstance();
	return;
}
Viewport vp = _Viewport[0];

Element el = vp.element();
if( !el.bIsValid() )
	return;
CoordSys csEl = el.coordSys();
Point3d ptElOrg = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

PlaneProfile ppEl(el.plOutlineWall());
LineSeg ls=ppEl.extentInDir(vxEl);
double dElLength=abs(vxEl.dotProduct(ls.ptStart()-ls.ptEnd()));

int bZoneZeroWidthOnly=true, nZone=99;
if(bZoneZeroWidthOnly)
	nZone=1;
ElemZone elzStart= el.zone(-nZone);
ElemZone elzEnd= el.zone(nZone);
double dElWidth=abs(vzEl.dotProduct(elzStart.coordSys().ptOrg()-elzEnd.coordSys().ptOrg()));
Beam elBeams[] = el.beam();

//double dElHeight= ((Wall)el).baseHeight();

Point3d ptElBack= ptElOrg+vxEl*dElLength-vzEl*dElWidth; // Back and to the right
//Point3d ptElCenter= ptElOrg+vxEl*dElLength*.5+vyEl*dElHeight*.5-vzEl*dElWidth*.5;	
//aa
Line lnX(ptElOrg, vxEl);
Line lnY(ptElOrg, vyEl);

// check if the viewport has hsb data
if( !el.bIsValid() )
	return;

// resolve properties
int bWithCross = arNYesNo[arSYesNo.find(sWithCross,0)];
int bWithFrame = arNYesNo[arSYesNo.find(sWithFrame,0)];
int nInfo = arSInfo.find(sInformationToShow, 0);
int nDimBeamsBeside = arNYesNo[arSYesNo.find(sDimensionBeamsBesideOpening, 1)];

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps

double dScale = ps2ms.scale();

Display dp(colorDescription);
dp.dimStyle(sDimStyle, dScale); // dimstyle was adjusted for display in paper space, sets textHeight
if(dTextHeight>0)
{
	dp.textHeight(dTextHeight);
}

Display dpFrame(-1);
dpFrame.color(colorFrame);
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
	OpeningRoof opRoof = (OpeningRoof)op;
	if( opRoof.bIsValid() )
		continue;
	CoordSys openingCoordSys = op.coordSys();
	openingCoordSys.transformBy(ms2ps);
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
		if (ppPlines.length() > 0)
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
	bdOp.transformBy(ms2ps);
	bdOp.vis(1);
	LineSeg lineSegToDraw[0];
	CoordSys world(_PtW, _XW, _YW, _ZW);
	Plane worldPlane(world.ptOrg(), _ZW);
	PlaneProfile bodyProfile = bdOp.shadowProfile(worldPlane);
	
	if( bWithCross )	{
		
		lineSegToDraw.append(bodyProfile.extentInDir(_XW));
		lineSegToDraw.append(bodyProfile.extentInDir(_YW));
		
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
		lineSegToDraw = bdOp.hideDisplay(world, false, true, false);
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
		dp.draw(sInfo, ptOpPS, _XW, _YW, 0, 0);
//aa
	if( nInfo == 1 )
	{
		
		for( int j=0;j<arBmHeader.length();j++ ){
			Beam bm = arBmHeader[j];
			Point3d ptBmMin = bm.ptRef() + bm.vecX() * bm.dLMin();
			Point3d ptBmMax = bm.ptRef() + bm.vecX() * bm.dLMax();
			
			if( (bm.vecX().dotProduct(ptBmMin - ptOp) * bm.vecX().dotProduct(ptBmMax - ptOp)) > 0 )
				continue;
			
			Vector3d vxBmPS = bm.vecX();
			vxBmPS.transformBy(ms2ps);
			Point3d ptTxt = ptBmMin;
			if( vxBmPS.dotProduct(_XW) < 0 )
				ptTxt = ptBmMax;
			
			ptTxt.transformBy(ms2ps);
			
			
			dp.draw(bm.material(), ptTxt, _XW, _YW, 0, -3);
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
		
		dp.draw(sTxt, ptOpPS, _XW, _YW, 0, -3);
	}
	
	// Draw custom text
	int nCustomTextDrawingFlag=-3;
	if(nInfo==2)
		nCustomTextDrawingFlag=-6;
	if(nInfo==arSInfo.length()-1)
		nCustomTextDrawingFlag=0;

	dp.draw(sCustomText, ptOpPS, _XW, _YW, 0, nCustomTextDrawingFlag);
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
    <lst nm="Version">
      <str nm="Comment" vl="Fix issue, where the pLine of the opening was not changed when dimensioning closest beams." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="8/1/2022 11:37:43 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to take the opening dimension looking at the beams around the opening. Doing this will also take the gap as set in the details into account." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="3/25/2022 1:57:57 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="3/25/2022 1:57:21 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End