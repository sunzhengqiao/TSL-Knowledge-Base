#Version 8
#BeginDescription
1.16 24/05/2023 Allow other tsls to contribute to the list of detail names. - Author: Anno Sportel

1.17 21/09/2023 Add prefix to stored detail name - Author: Anno Sportel
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 17
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl places detail texts at a given position.
/// </summary>

/// <insert>
/// Auto: Attach the tsl HSB_E-InsertDetailNames to the element definition
/// Manual: Select element and position
/// </insert>

/// <remark Lang=en>
/// -
/// </remark>

/// <version  value="1.15" date="25.09.2019"></version>

/// <history>
/// AS - 1.00 - 20.01.2012 -	Pilot version
/// AS - 1.01 - 23.01.2012 -	Add info for section drawing in paperspace
/// AS - 1.02 - 25.01.2012 -	Update text orienatation and alignment
/// AS - 1.03 - 25.01.2012 -	Align text different when readdirection forces a change.
/// AS - 1.04 - 30.01.2012 -	Add options for readdirection
/// AS - 1.05 - 20.04.2012 -	Make detail movable
/// AS - 1.06 - 22.05.2012 -	Add vxEl as hide direction
/// AS - 1.07 - 21.11.2012 -	Add support for element mirror.
/// AS - 1.08 - 20.12.2012 -	Add support for viewing the element from the inside
/// AS - 1.09 - 01.03.2013 -	Add vyEl as hide direction
/// AS - 1.10 - 23.06.2014 -	Add visualization options
/// AS - 1.11 - 20.10.2014 -	Add option to place detail in middle of zone.
/// AS - 1.12 - 11.05.2016 -	Store detail names as mapX data at element. Draw in dxa enabled
/// AS - 1.13 - 05.03.2019 -	Add option for file name prefix.
//RVW-	1.14 - 30.04.2019 -	Add check if tsl instance is valid before mapping the tsls
//RVW- 1.15 - 25.09.2019 -	Add option for readdirection "Align text with view", make it dependend to the view from user using _kDevice. 
/// </history>

double dEps = Unit(0.1, "mm");

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

String arSDetailPosition[] = {T("|On detail line|"), T("|Element middle|"), T("|Free|")};

PropString sSeperator01(0, "", T("|Detail|"));
sSeperator01.setReadOnly(true);
PropString sDetailName(1, "", "     "+T("|Name|"));
PropString sDetailDescription(2, "", "     "+T("|Description|"));
PropDouble dDetailSize(0, U(500), "     "+T("|Size|"));
PropDouble dDetailDepth(1, U(500), "     "+T("|Depth|"));
PropString detailPrefix(13, "", "     "+T("|Detail filename prefix|"));
detailPrefix.setDescription(T("|Sets the prefix for the filename. E.g. If the prefix is set to 'Det' and the detail name is '05', the file linked to it should be named 'Det05'."));

PropString sSeperator02(3, "", T("|Position|"));
sSeperator02.setReadOnly(true);
PropDouble dxOffset(2, U(100), "     "+T("|Offset, perpendicular to detail|"));
PropDouble dyOffset(3, U(500), "     "+T("|Offset, aligned with detail|"));
PropString sDetailPosition(11, arSDetailPosition, "     "+T("|Detail position|"));

PropString sSeperator03(4, "", T("|Textposition|"));
sSeperator03.setReadOnly(true);
PropDouble dxOffsetTxt(4, U(0), "     "+T("|Text offset, perpendicular to detail|"));
PropDouble dyOffsetTxt(5, U(350), "     "+T("Text offset, aligned with detail|"));
String arSTextOrientation[] = {
	T("|Aligned with detail|"),
	T("|Perpendicular to detail|")
};
PropString sTextOrientation(6, arSTextOrientation, "     "+T("|Text orientation|"));
String arSReadDirection[] = {
	T("|Top-Left|"),
	T("|Bottom-Left|"),
	T("|Bottom-Right|"),
	T("|Top-Right|"),
	T("|Left|"),
	T("|Right|"),
	T("|Top|"),
	T("|Bottom|"),
	T("|Keep text horizontal|"),
	T("|Align text with view|")
};

String arSTextAlignmentX[] = {
	T("|From textposition|"),
	T("|Centered|"),
	T("|Towards textposition|")
};
String arSTextAlignmentY[] = {
	T("|Above textposition|"),
	T("|Centered|"),
	T("|Below textposition|")
};
double arDTextAlignment[] = {
	1,
	0,
	-1
};
PropString sTextAlignmentX(7, arSTextAlignmentX, "     "+T("|Text alignment| X"),1);
PropString sTextAlignmentY(8, arSTextAlignmentY, "     "+T("|Text alignment| Y"),1);

PropString sReadDirection(5, arSReadDirection, "     "+T("|Readdirection|"));

PropString sSeperator04(9, "", T("|Style|"));
sSeperator04.setReadOnly(true);
PropInt nColorDetail(0, 3, "     "+T("|Color detail|"));
PropInt nTextColor(1, 1, "     "+T("|Color Text|"));
PropString sDimstyleText(10, _DimStyles, "     "+T("|Dimensionstyle|"));
PropString sShowLine(12, arSYesNo, "     "+T("|Show line|"),1);
sShowLine.setDescription(T("|Toggles the visualization of the line|"));
PropDouble dTxtSize(6, U(-1), "     "+T("|Text size|"));
dTxtSize.setDescription(T("|Sets the text size.|") + 
								TN("|The text size specified in the dimension style is used if the size is zero, or less.|"));


if( _bOnElementDeleted ){
	eraseInstance();
	return;
}

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	Element el = getElement(T("|Select an element|"));
	Point3d ptPosition = getPoint(T("|Select a position|") + TN("NOTE: |Points are projected to element, projection is done perpendicular to element XY plane|."));
	Point3d ptNormal = ptPosition;
	PrPoint ssPt(T("|Select a point for the direction|"), ptPosition);
	if( ssPt.go() )
		ptNormal = ssPt.value();
	
	CoordSys csEl = el.coordSys();
	Point3d ptEl = csEl.ptOrg();
	Vector3d vzEl = csEl.vecZ();
	
	Plane pnZ(ptEl - vzEl * 0.5 * el.zone(0).dH(), vzEl);
	ptPosition = ptPosition.projectPoint(pnZ, 0);
	ptNormal = ptNormal.projectPoint(pnZ, 0);
	
	if( (ptPosition - ptNormal).length() < dEps ){
		reportError(TN("|Invalid direction selected|!"));
		eraseInstance();
		return;
	}
	
	_Map.setPoint3d("Position", ptPosition);
	_Map.setPoint3d("Normal", ptNormal);
	
	_Element.append(el);
	_Pt0 = ptPosition;
	
	return;
}

if( _Element.length() == 0 ){
	reportMessage(TN("|No, or invalid, element selected|."));
	eraseInstance();
	return;
}

int nReadDirection = arSReadDirection.find(sReadDirection,0);
int nTextOrientation = arSTextOrientation.find(sTextOrientation,0);

int bOnDetailLine = arSDetailPosition.find(sDetailPosition,0) == 0;
int bInElementMiddle = arSDetailPosition.find(sDetailPosition,0) == 1;

int bShowLine= arNYesNo[arSYesNo.find(sShowLine,1)];

Element el = _Element[0];
assignToElementGroup(el, true, 0, 'I');

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Line lnX(ptEl, vxEl);
Line lnY(ptEl, vyEl);

Point3d arPtEl[] = el.profNetto(0).getGripVertexPoints();
Point3d arPtElX[] = lnX.orderPoints(arPtEl);
Point3d arPtElY[] = lnY.orderPoints(arPtEl);
if( (arPtElX.length() * arPtElY.length()) == 0 ){
	reportMessage(TN("|Invalid, element selected|."));
	eraseInstance();
	return;
}
Point3d ptL = arPtElX[0];
Point3d ptR = arPtElX[arPtElX.length() - 1];
Point3d ptB = arPtElY[0];
Point3d ptT = arPtElY[arPtElY.length() - 1];
Point3d ptC = (ptL + ptR)/2;
ptC += vyEl * vyEl.dotProduct((ptB+ptT)/2 - ptC);
ptC.vis();

Point3d ptElMid = ptEl - vzEl * 0.5 * el.zone(0).dH();

Point3d ptPosition = _Map.getPoint3d("Position");
Point3d ptNormal = _Map.getPoint3d("Normal");
Vector3d vNormal(ptNormal - ptPosition);
vNormal.normalize();
Point3d ptElementMiddle = ptPosition;
ptElementMiddle += vzEl * vzEl.dotProduct(ptElMid - ptElementMiddle);

Line lnNormal(ptPosition, vNormal);
Line lnNormalElementMiddle(ptElementMiddle, vNormal);
Plane pnDetail(ptPosition, vzEl);

if( bOnDetailLine )
	_Pt0 = lnNormal.closestPointTo(_Pt0);
else if (bInElementMiddle)
	_Pt0 = lnNormalElementMiddle.closestPointTo(_Pt0);
else
	_Pt0 = pnDetail.closestPointTo(_Pt0);

Vector3d vDetail = vzEl.crossProduct(vNormal);
if( _Map.hasPoint3d("Detail") ){
	Point3d pt = _Map.getPoint3d("Detail");
	vDetail = Vector3d(pt - ptPosition);
	vDetail.normalize();
}

Vector3d vzDetail = vzEl;
int bIsMirrored = false;
if( vDetail.dotProduct(vzEl.crossProduct(vNormal)) < 0 ){//Mirrored element
	vzDetail *= -1;
	bIsMirrored = true;
}

//if( vDetail.dotProduct(ptC - _Pt0) > 0 ){
//	vDetail *= -1;
//	vNormal *= -1;
//}
CoordSys csDet(_Pt0, -vNormal, -vDetail, vzDetail);
Vector3d vxDet = csDet.vecX();
Vector3d vyDet = csDet.vecY();
Vector3d vzDet = csDet.vecZ();
csDet.vis();
Point3d ptDetail = _Pt0 + vxDet * dxOffset + vyDet * dyOffset;

PLine plDetail(vxDet);
plDetail.createRectangle(LineSeg(ptDetail - (vyDet + vzDet) * 0.5 * dDetailSize, ptDetail + (vyDet + vzDet) * 0.5 * dDetailSize), vyDet, vzDet);
plDetail.vis();

Display dpDetail(nColorDetail);
dpDetail.addHideDirection(vxEl);
dpDetail.addHideDirection(-vxEl);
dpDetail.addHideDirection(vyEl);
dpDetail.addHideDirection(-vyEl);
dpDetail.showInDxa(true);

Display dpText(nTextColor);
dpText.dimStyle(sDimstyleText);
if (dTxtSize > 0)
	dpText.textHeight(dTxtSize);
dpText.addHideDirection(vxEl);
dpText.addHideDirection(-vxEl);
dpText.addHideDirection(vyEl);
dpText.addHideDirection(-vyEl);
dpText.showInDxa(true);
if (nReadDirection < 8)
	dpText.addHideDirection(-vzEl);

Display dpTextBack(nTextColor);
dpTextBack.dimStyle(sDimstyleText);
if (dTxtSize > 0)
	dpTextBack.textHeight(dTxtSize);
dpTextBack.addViewDirection(-vzEl);

double dTextAlignmentX = arDTextAlignment[arSTextAlignmentX.find(sTextAlignmentX,1)];
double dTextAlignmentY = arDTextAlignment[arSTextAlignmentY.find(sTextAlignmentY,1)];

Vector3d vxTxt = -vyDet;
Vector3d vyTxt = vxDet;

Vector3d vxTxtOffset = vxDet;
Vector3d vyTxtOffset = vyDet;

if (nReadDirection < 8) {
	Vector3d arVReadDirection[] = {
		-vxEl + vyEl,
		-vxEl - vyEl,
		vxEl - vyEl,
		vxEl + vyEl,
		-vxEl,
		vxEl,
		vyEl,
		-vyEl
	};
	Vector3d vReadDirection = arVReadDirection[nReadDirection];
	vReadDirection.normalize();
	
	if( nTextOrientation == 1 ){
		vxTxt = vxDet;
		vyTxt = vyDet;
	}
	if( vyTxt.dotProduct(vReadDirection) < 0 ){
		vxTxt *= -1;
		vyTxt *= -1;
		dTextAlignmentX *= -1;
			
		vxTxtOffset *= -1;
	}
	if( bIsMirrored ){
		vxTxt *= -1;
		dTextAlignmentX *= -1;
	}
}

Point3d ptTxt = ptDetail + vxTxtOffset * dxOffsetTxt + vyTxtOffset * dyOffsetTxt;

if (nReadDirection < 8) {
	dpText.draw(sDetailName, ptTxt, vxTxt, vyTxt, dTextAlignmentX, dTextAlignmentY);
	dpTextBack.draw(sDetailName, ptTxt, -vxTxt, vyTxt, dTextAlignmentX, dTextAlignmentY);
}
else if (nReadDirection < 9){
	dpText.draw(sDetailName, ptTxt, vxTxt, vyTxt, dTextAlignmentX, dTextAlignmentY, _kDeviceX);
}
else
{
	dpText.draw(sDetailName, ptTxt, vxTxt, vyTxt, dTextAlignmentX, dTextAlignmentY, _kDevice);	
}

if (bShowLine)
	dpDetail.draw(plDetail);

String detailName = sDetailName;
detailName = detailPrefix + detailName;
_Map.setString("DetailName", detailName);

// Store detail in MapX of the element.
// Find all other detail tsl's attached to this element.
TslInst arTsl[] = el.tslInst();
String arSElementDetails[] = {
	detailName
};
for( int i=0;i<arTsl.length();i++ ){
	TslInst tsl = arTsl[i];
	if ( ! tsl.bIsValid()) continue;

	// We already added the content for this tsl. And the content might be updated in this instance.
	if (tsl.handle() == _ThisInst.handle()) continue;
	
	//if( tsl.scriptName() != _ThisInst.scriptName()) continue;
	
	Map mapTsl = tsl.map();
	if(!mapTsl.hasString("DetailName") || arSElementDetails.find(mapTsl.getString("DetailName")) != -1 )
		continue;
	
	arSElementDetails.append(mapTsl.getString("DetailName"));
}	

Map mapDetails;
for( int i=0;i<arSElementDetails.length();i++ )
	mapDetails.appendString("Detail", arSElementDetails[i]);

el.setSubMapX("Details", mapDetails);










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
      <str nm="COMMENT" vl="Add prefix to stored detail name" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="17" />
      <str nm="DATE" vl="9/21/2023 8:54:36 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Allow other tsls to contribute to the list of detail names." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="16" />
      <str nm="DATE" vl="5/24/2023 7:54:24 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End