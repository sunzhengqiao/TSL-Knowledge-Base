#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
08.11.2017 - version 1.16
Places detail texts at a given position. Catalog for this tsl can be set from DSP; argument to pass should be "DspToTsl; <catalog-name>"

1.17 01/04/2025 Add display for hsbview Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 1
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 17
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Places detail texts at a given position. Catalog for this tsl can be set from DSP; argument to pass should be "DspToTsl; <catalog-name>"
/// </summary>

/// <insert>
/// Auto: Attach the tsl to a DSP detail
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.15" date="02.11.2017"></version>
/// <history>
/// AS - 1.00 - 06.07.2011 - Pilot version
/// AS - 1.01 - 20.03.2012 - Update text orientation
/// AS - 1.02 - 13.11.2014 - Erase tsl if catalog name is empty
/// AS - 1.03 - 20.11.2014 - Add logging. Replace isParallel check with a check with tolerance. (FogbugzId: 519)
/// AS - 1.04 - 20.11.2014 - Erase tsl if key is not found in detail string. (FogbugzId: 519)
/// AS - 1.05 - 10.03.2015 - Add offset and text alignment
/// AS - 1.06 - 07.04.2015 - Generator now passes an extra grippoint on the detail line. Add support for this. (FogBugzId 1090).
/// AS - 1.07 - 07.04.2015 - Make detail output for layouts optional (FogBugzId 1090).
/// AS - 1.08 - 07.04.2015 - Publish detail info is now defaulted to 'No' (FogBugzId 1090).
/// AS - 1.09 - 08.05.2015 - Add supporting details as detail lines to analyze (FogBugzId 1090).
/// AS - 1.10 - 20.07.2015 - Make property dialog available to create catalog values during manual insert.
/// AS - 1.11 - 05.02.2016 - Always export detail data.
/// AS - 1.12 - 19.10.2016 - Resolve properties after they are set internaly.
/// DR - 1.13 - 02.05.2017 - Added extra descriptions 2,3 and 4 (in props and map to be consumed by generator)
///						- Text display reorganized to grow according to info provided
/// DR - 1.14 - 12.05.2017 - All text reports (but debug) will be in new lines and will include scriptname to know who is sending the message. Description updated.
/// AS - 1.15 - 02.11.2017 - Take openings into account.
/// DR - 1.16 - 08.11.2017	- Added extra description 5
/// </history>

//#Versions
//1.17 01/04/2025 Add display for hsbview Author: Robert Pol

if( _bOnElementDeleted ){
	eraseInstance();
	return;
}

Unit (1,"mm");
double dEps = U(0.1);
double vectorTolerance = U(0.1);

String sNoYes[] = {T("|No|"),T("|Yes|")};;

PropString sSeperator01(0, "", "Information");
sSeperator01.setReadOnly(true);
PropString sName(1, "Line A", "     "+T("|Detail name|"));
PropString sDescription(2, "Line B", "     "+T("|Description|"));
PropString sExtraDescription(7, "", "     "+T("|Extra description|"));
PropString sExtraDescription2(9, "", "     "+T("|Extra description 2|"));
PropString sExtraDescription3(10, "", "     "+T("|Extra description 3|"));
PropString sExtraDescription4(11, "", "     "+T("|Extra description 4|"));
PropString sExtraDescription5(13, "", "     "+T("|Extra description 5|"));

PropString sSeperator02(3, "", "Presentation");
sSeperator02.setReadOnly(true);
PropString sDimStyle(4, _DimStyles, "     "+T("|Dimension style|"));
PropInt nColor(0, -1, "     "+T("|Color|"));

String arSTextAlignment[] = {T("|Left|"), T("|Right|"), T("|Center|")};
double arDTextAlignment[] = {1, -1, 0};
PropString sHorizontalTextAlignment(5, arSTextAlignment, "     "+T("|Horizontal text alignment|"));
PropDouble dxOffset(0, U(0), "     "+T("|Horizontal text offset|"));
PropString sVisibleOnTopViewOnly(12, sNoYes, "     "+T("|Visible on top view only|"),1);

String arSZoneLayer[] = {
	"Tooling",
	"Information",
	"Zone",
	"Element"
};
char arChZoneCharacter[] = {
	'T',
	'I',
	'Z',
	'E'
};
int arNZoneIndex[] = {0,1,2,3,4,5,6,7,8,9};
PropString sZoneLayer(8, arSZoneLayer, "     "+T("|Assign to layer|"));
PropInt nZnIndex(1, arNZoneIndex, "     "+T("|Zone index|"));

// Only allow insert to create and edit the catalog entries. Show a warning and erase tsl after the dialog has closed.
if (_bOnInsert)
{
	showDialog();
	reportWarning(T("|This tsl should be attached to a DSP detail and cannot be inserted manually!|"));
	eraseInstance();
	return;
}

if (_PtG.length() == 0) 
{
	reportMessage("\n" + scriptName() + ": " +T("|No grippoints found. TSL Will be erased|"));
	eraseInstance();
	return;
}

_Pt0.vis(1);
for (int i=0;i<_PtG.length();i++)
	_PtG[i].vis(2+i);

if (_PtG.length() < 2)
	_PtG.append((_Pt0 + _PtG[0])/2);

if (_Map.hasPoint3d("PtG0") && _Map.hasPoint3d("PtG1")) {
	// Reset the grippoints to the detail line.
	_PtG[0] = _Map.getPoint3d("PtG0");
	_PtG[1] = _Map.getPoint3d("PtG1");
}
else {
	// Reorganize the points passed in through the generator. 
	// _Pt0 muts become the anchor for the text. The grippoints will be the 2 points on the detail line.
	Point3d ptOrg = _PtG[1];
	Point3d ptGrip0 = _Pt0;
	Point3d ptGrip1 = _PtG[0];

	Vector3d vLn(ptGrip0 - ptGrip1);
	vLn.normalize();
	Line lnDetail(_PtG[1], vLn);
	Line lnText(_Pt0, vLn);
	
	ptGrip0 = lnDetail.closestPointTo(ptGrip0);
	ptGrip1 = lnDetail.closestPointTo(ptGrip1);
	ptOrg = lnText.closestPointTo(ptOrg);
	
	// Store the points on the detail line.
	_Map.setPoint3d("PtG0", ptGrip0, _kAbsolute);
	_Map.setPoint3d("PtG1", ptGrip1, _kAbsolute);
	
	// Set _Pt0 to the text position and the grippoints to the start and end of the detail.
	_Pt0 = ptOrg;
	_PtG[0] = ptGrip0;
	_PtG[1] = ptGrip1;
}

int nLog = 0;
if (_bOnDebug)
	nLog = 1;
if (nLog == 1)
	reportNotice("\n\t****\n" + _ThisInst.handle());

// Set properties from dsp
int nSetPropsFromDspVariable = -1;
if( _Map.hasString("DspToTsl") ){
	String sCatalogName;
	String sArgument = _Map.getString("DspToTsl");
	
	if (nLog == 1)
		reportNotice(TN("|Argument set in DSP detail|: ")+sArgument);
	if( sArgument.left(3).makeUpper() == "VAR" ){
		nSetPropsFromDspVariable = sArgument.right(sArgument.length() - 3).atoi();
	}
	else{
		sCatalogName = sArgument;
		if (sCatalogName == "" ) 
		{
			reportMessage("\n" + scriptName() + ": " +T("|No catalogname specified|"));
			eraseInstance();
			return;
		}
		
		setPropValuesFromCatalog(sCatalogName);
	}

	_Map.removeAt("DspToTsl", true);
}

if (nLog == 1)
	reportNotice(TN("|Take catalog key from|: ")+nSetPropsFromDspVariable);

if( _bOnDbCreated && _kExecuteKey != "" )
	setPropValuesFromCatalog(_kExecuteKey);

if(_Element.length()==0||_PtG.length()<1)return;

Element el = _Element[0];
assignToElementGroup(el, true, 0, 'E');

//int bPublishDetailInformation = arNYesNo[arSYesNo.find(sPublishDetailInformation, 1)];

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
Plane zPlane(ptEl, vzEl);
Line lnX(ptEl, vxEl);

PLine plElOutline = el.plEnvelope();
plElOutline.transformBy(-vzEl * el.dBeamWidth());
plElOutline.vis();

// Find roofedge for this tsl and get the construction detail.
Vector3d vY = (_PtG[1] - _PtG[0]);
vY.normalize();
Vector3d vZ = el.vecZ();
Vector3d vX = vY.crossProduct(vZ);

Group elementGroup = el.elementGroup();
Entity roofOpeningEntities[] = Group(elementGroup.namePart(0), elementGroup.namePart(1), "").collectEntities(true, OpeningRoof(), _kModelSpace);

//Display dpDebug(1);
//dpDebug.textHeight(U(25));
//dpDebug.draw(scriptName(), _Pt0, _XW, _YW, 0, 0);

Point3d ptOnDetailLine = (_PtG[1] + _PtG[0])/2;
if( el.bIsKindOf(ElementRoof()) ){
	ElementRoof elR = (ElementRoof)el;
	ElemRoofEdge arElRoofEdge[]=elR.elemRoofEdges();
	
	OpeningRoof roofOpenings[0];
	PlaneProfile elementProfile(csEl);
	elementProfile.joinRing(el.plEnvelope(), _kAdd);
	elementProfile.vis(1);
	// Find the openings for this roof element and add the detail line information for these details.
	for (int e=0;e<roofOpeningEntities.length();e++)
	{
		OpeningRoof roofOpening = (OpeningRoof)roofOpeningEntities[e];
		PLine roofOpeningShape = roofOpening.plShape();
		roofOpeningShape.projectPointsToPlane(zPlane, _ZW);
		
		PlaneProfile openingProfile(csEl);
		openingProfile.joinRing(roofOpeningShape, _kAdd);
		openingProfile.vis(e);
		
		if (openingProfile.intersectWith(elementProfile))
		{
			roofOpenings.append(roofOpening);
		}
	}	
	
	Vector3d arVDirection[0];
	Point3d arPtNode[0];
	Point3d arPtNodeOther[0];
	String arSDetail[0];
	
	for (int r=0;r<roofOpenings.length();r++)
	{
		OpeningRoof roofOpening = roofOpenings[r];
		PLine openingShape = roofOpening.plShape();
		openingShape.projectPointsToPlane(zPlane, _ZW);
		
		Point3d openingVertices[] = openingShape.vertexPoints(false);
		for (int v = 0; v < (openingVertices.length() - 1); v++)
		{
			Point3d from = openingVertices[v];
			Point3d to = openingVertices[v + 1];
			to.vis(1);
			from.vis(1);
			Vector3d direction(to - from);
			direction.normalize();
			Vector3d normal = vzEl.crossProduct(direction);
			double xComponent = vxEl.dotProduct(normal);
			double yComponent = vyEl.dotProduct(normal);
			
			arVDirection.append(direction);
			arPtNode.append(from);
			arPtNodeOther.append(to);
			String detail;
			if (abs(xComponent) < vectorTolerance)
			{
				if (yComponent > vectorTolerance)
				{
					detail = roofOpening.constrDetailBottom();
				}
				else
				{
					detail = roofOpening.constrDetailTop();
				}
			}
			else if (abs(yComponent) < vectorTolerance)
			{
				if (xComponent > vectorTolerance)
				{
					detail = roofOpening.constrDetailLeft();
				}
				else
				{
					detail = roofOpening.constrDetailRight();
				}
			}
			else
			{
				if (yComponent > vectorTolerance)
				{
					detail = roofOpening.constrDetailBottomAngled();
				}
				else
				{
					detail = roofOpening.constrDetailTopAngled();
				}
			}
			arSDetail.append(detail);
//			dpDebug.draw(PLine(to, from));
		}
	}
	
	for( int j=0;j<arElRoofEdge.length();j++ ){
		ElemRoofEdge elRoofEdge = arElRoofEdge[j];
		arVDirection.append(elRoofEdge.vecDir());
		arPtNode.append(elRoofEdge.ptNode());
		arPtNodeOther.append(elRoofEdge.ptNodeOther());
		arSDetail.append(elRoofEdge.constrDetail());
		
		
	}
	
	
	
	// Add the suporting details....
	double arDHSupportingDetail[0];
	String arSSupportingDetail[0];
	arDHSupportingDetail.append(elR.dKneeWallHeight());		arSSupportingDetail.append(elR.constrDetailKneeWall());
	arDHSupportingDetail.append(elR.dKneeWallHeight2());	arSSupportingDetail.append(elR.constrDetailKneeWall2());
	arDHSupportingDetail.append(elR.dWallPlateHeight());		arSSupportingDetail.append(elR.constrDetailWallPlate());
	arDHSupportingDetail.append(elR.dWallPlateHeight2());	arSSupportingDetail.append(elR.constrDetailWallPlate2());
	arDHSupportingDetail.append(elR.dStrutHeight());			arSSupportingDetail.append(elR.constrDetailStrut());
	arDHSupportingDetail.append(elR.dStrutHeight2());			arSSupportingDetail.append(elR.constrDetailStrut2());
	
	for (int j=0;j<arDHSupportingDetail.length();j++) {
		double dDetailH = arDHSupportingDetail[j];
		String sDetail = arSSupportingDetail[j];
		if (sDetail.length() == 0)
			continue;
		
		Plane pn(_PtW + _ZW * dDetailH, _ZW);
		Point3d arPtDetail[] = plElOutline.intersectPoints(pn);
		arPtDetail = lnX.orderPoints(arPtDetail);
		
		if (arPtDetail.length() < 2)
			continue;
		
		arVDirection.append(vxEl);
		arPtNode.append(arPtDetail[0]);
		arPtNodeOther.append(arPtDetail[arPtDetail.length() - 1]);
		arSDetail.append(sDetail);
	}

	double dMin = U(9999999);
	for( int j=0;j<arVDirection.length();j++ ){
		Vector3d vDirection = arVDirection[j];
		Point3d ptNode = arPtNode[j];
		Point3d ptNodeOther = arPtNodeOther[j];
		String sDetail = arSDetail[j];
		
		if( abs(abs(vY.dotProduct(vDirection)) - 1) < dEps ){
			double dDist = vX.dotProduct(ptOnDetailLine - ptNode);
			if( abs(dDist) < dMin ){
				dMin = abs(dDist);
				_Map.setString("DET", sDetail);
				_PtG[0] = ptNode;
				_PtG[1] = ptNodeOther;
			}
		}
	}
}

//_Pt0 += vY * vY.dotProduct((_PtG[0] + _PtG[1])/2 - _Pt0);
//Line ln(_PtG[0], vY);
//for( int i=0;i<_PtG.length();i++ ){
	//_PtG[i] = ln.closestPointTo(_PtG[i]);
//}

// Set properties if this tsl was inserted from DSP. This check is only done after the first run.
if( nSetPropsFromDspVariable > -1 ){
	String sCatalogName;
	if( _Map.hasString("DET") ) {
		sCatalogName = _Map.getString("DET");
		
		if (nLog == 1)
			reportNotice(TN("|Catalog name taken from map|: ")+sCatalogName);
	}

	
	if( sCatalogName.token(0) == "\CODE" ){
		if( nSetPropsFromDspVariable == 0 ){
			sCatalogName = sCatalogName.token(1);
			
			if (nLog == 1)
				reportNotice(TN("|Catalog name taken dsp variable| ") + nSetPropsFromDspVariable + T("|Catalog name|: ")+sCatalogName);
		}
		else{
			String sKey = "STRVAR"+(nSetPropsFromDspVariable-1);
			
			if (nLog == 1)
				reportNotice(TN("|Search for catalog name by key|: ") + sKey);
				
			int nIndex = sCatalogName.find(sKey, 0);
			if (nIndex == -1 ){
				reportMessage("\n" + scriptName() + ": " +T("|Catalog index not found|"));
				eraseInstance();
				return;
			}
			nIndex += sKey.length() + 1;
			sCatalogName = sCatalogName.mid(nIndex, sCatalogName.length() - 1);
			sCatalogName = sCatalogName.token(0);
			
			if (nLog == 1)
				reportNotice(TN("|Catalog found at index|: ") + nIndex + " = " + sCatalogName);
		}
	}
	else{
		sCatalogName = sCatalogName.token(nSetPropsFromDspVariable);
		
		if (nLog == 1)
			reportNotice(TN("|Catalog name taken from index|: ")+ nSetPropsFromDspVariable + " = " + sCatalogName);
	}
	
	if (sCatalogName == "" ) 
	{
		reportMessage("\n" + scriptName() + ": " +T("|Catalogname not found|"));
		eraseInstance();
		return;
	}
	
	reportMessage("\n" + scriptName() + ": " +T("|Properties set with catalog|")+sCatalogName);
	int propsSet = setPropValuesFromCatalog(sCatalogName);
	reportMessage("\n" + scriptName() + ": " +T("|PropsSet|")+propsSet);
}

nSetPropsFromDspVariable > -1;

char chZoneCharacterTube = arChZoneCharacter[arSZoneLayer.find(sZoneLayer,0)];
int znIndex = nZnIndex;
if (znIndex > 5)
	znIndex = 5-znIndex;

double dxFlag = arDTextAlignment[arSTextAlignment.find(sHorizontalTextAlignment, 0)];
int bVisibleOnTopViewOnly= sNoYes.find(sVisibleOnTopViewOnly,0);

Display dp(nColor);
dp.showInDxa(true);
dp.dimStyle(sDimStyle);
dp.elemZone(el, znIndex, chZoneCharacterTube);
if(bVisibleOnTopViewOnly)
{ 
	dp.addViewDirection(vzEl);
}

Vector3d vxTxt = vY;
double dx = vxEl.dotProduct(vxTxt);
double dy = vyEl.dotProduct(vxTxt);
if( dx < -dEps ){
	vxTxt *= -1;
}
else if( abs(dx) < dEps && dy < -dEps ){
	vxTxt *= -1;
}

Vector3d vyTxt = vzEl.crossProduct(vxTxt);
vxTxt.vis(_Pt0, 1);

int nSide = 1;
if( vX.dotProduct(vyTxt) > 0 )
	nSide *= -1;

String sInfoToDraw[0];
if(sDescription!="") sInfoToDraw.append(sDescription);
if(sExtraDescription!="") sInfoToDraw.append(sExtraDescription);
if(sExtraDescription2!="") sInfoToDraw.append(sExtraDescription2);
if(sExtraDescription3!="") sInfoToDraw.append(sExtraDescription3);
if(sExtraDescription4!="") sInfoToDraw.append(sExtraDescription4);
if(sExtraDescription5!="") sInfoToDraw.append(sExtraDescription5);
if(sName!="") sInfoToDraw.append(sName);

Point3d ptTxt = _Pt0 + vxTxt * dxOffset;
double dSpacing=3;
for (int s=0;s<sInfoToDraw.length();s++) 
{ 
	String sInfo = sInfoToDraw[s]; 
	dp.draw(sInfo, ptTxt , vxTxt, vyTxt, dxFlag, nSide * dSpacing*s, _kDevice);
	 
}
//setExecutionLoops(2);

int bPublishDetailInformation = true;
if (bPublishDetailInformation) {
	Point3d ptDetail = ptOnDetailLine;
	_Map.setPoint3d("Position", ptDetail, _kAbsolute);
	_Map.setPoint3d("Normal", vY, _kAbsolute);
	
	_Map.setString("DetailInfo", sName + "\n" + sDescription + "\n" + sExtraDescription+ "\n" + sExtraDescription2+ "\n" + sExtraDescription3+ "\n" + sExtraDescription4+ "\n" + sExtraDescription5);
	_Map.setString("DetailName", sName);
	_Map.setString("Description", sDescription);
	_Map.setString("ExtraDescription", sExtraDescription);
	_Map.setString("ExtraDescription2", sExtraDescription2);
	_Map.setString("ExtraDescription3", sExtraDescription3);
	_Map.setString("ExtraDescription4", sExtraDescription4);
	_Map.setString("ExtraDescription5", sExtraDescription5);
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
      <str nm="Comment" vl="Add display for hsbview" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="4/1/2025 11:45:31 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End