#Version 8
#BeginDescription
Version 2.6 13-10-2022 Add option to add a prefix to the detailName Ronald van Wijngaarden

Version 3.0 7-3-2025 Set the visualization for the display instead of the _ThisInstance. Set this instance default to the zone0 layer. Ronald van Wijngaarden
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl draws production details in paperspace
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <history>
/// AS - 1.00 - 06.07.2006	- Pilot version
/// AS - 1.01 - 31.10.2006	- Add description under detail name
/// AS - 1.02 - 31.10.2006	- Text always on the outside of the element
/// AS - 1.03 - 31.10.2006	- Add small arrows
/// AS - 1.04 - 08.12.2009	- Change layer from tooling to info
/// AS - 1.05 - 08.12.2009	- Add hide directions
/// AS - 1.06 - 14.01.2010	- Add depth
/// AS - 1.07 - 31.03.2010	- Remove small arrows
/// AS - 1.08 - 12.10.2010	- Add auto insert
/// AS - 1.09 - 12.10.2010	- Add properties for default text and properties to show or hide specific details
/// AS - 1.10 - 13.10.2010	- Add offset
/// AS - 1.11 - 16.11.2010	- Change the way the profNetto is retrieved.
/// EZ - 1.12 - 30.11.2012	- Add color to text and Pline 
/// AS - 1.13 - 24.12.2012	- Add opening info to detail
/// AS - 1.14 - 03.01.2013	- Add option to context menu to 'toggle opening detail'
/// AS - 1.15 - 22.01.2013	- Add side text and opening index to opening text
/// AS - 1.16 - 31.01.2013	- Assign tsl to E0 layer. Displays are on I0 layer. Set layer "0" as base layer.
/// AS - 1.17 - 22.02.2013	- Check if plEl runs CCWise
/// AS - 1.18 - 25.02.2013	- Correct pline check if opening is a door.
/// AS - 1.19 - 26.11.2013	- Also sent colors to child tsl, change text orientation.
/// AS - 1.20 - 10.12.2013	- Add to option to hide the section line.
/// AS - 1.21 - 13.12.2013	- Pass draw line prop from master to satalite 
/// AS - 1.22 - 06.01.2015	- Set properties from catalog
/// AS - 1.23 - 21.09.2015	- Make opening details optional (FogBugzId 1211)
/// AS - 1.24 - 15.05.2017	- Store vector as point in map to support transformations. E.g. mirroring.
/// AS - 1.25 - 13.06.2017	- Store reference vectors to proper mirroring
/// AS - 1.26 - 19.12.2017	- Add property for text offset.
/// DR - 1.27 - 24.01.2018	- Added option to rotate text
/// DR - 1.28 - 18.02.2018	- Description property brought back
/// DR - 1.29 - 20.02.2018	- Added option to have text aligned to Detail (Set as default)
/// DR - 1.30 - 28.02.2018	- Set values to be loaded by default catalog
/// DR - 1.31 - 12.03.2018	- Set to align to device when default view is set (Bugfix))
/// DR - 2.00 - 12.03.2018	- Fixed issues due to Props indexing (ghost props after insertion).
///							- Text direction options: Aligned to screen; Aligned to screen and horizontal; Aligned to detail
/// DR - 2.01 - 28.03.2018	- Rolled back to v1.26, another TSL will be created to have new features
/// AS - 2.02 - 10.07.2018	- Expose detail name for ElementViewClient
/// DL - 2.03 - 21.09.2020	- Add the option to put the tsl on a specific zone
/// DL - 2.04 - 25.09.2020	- Change ElementZone of Display
/// DL - 2.05 - 01.10.2020	- bOnInsert pass through new properties
/// </history>

//#Versions
//3.0 7-3-2025 Set the visualization for the display instead of the _ThisInstance. Set this instance default to the zone0 layer. Ronald van Wijngaarden
//2.6 13-10-2022 Add option to add a prefix to the detailName Ronald van Wijngaarden



double dEps = U(.1, "mm");

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

PropDouble dSizeDetail(0, U(500), T("|Size|"));
PropDouble dSectionDepth(1, U(500), T("|Depth|"));
PropDouble textOffsetProp(2, U(0), T("|Text offset|"));

PropString sDetailName(0, "A", T("|Detail name|"));

PropString detailPrefix(31, "",T("|Detail filename prefix|"));
detailPrefix.setDescription(T("|Sets the prefix for the filename. E.g. If the prefix is set to 'Det' and the detail name is '05', the file linked to it should be named 'Det05'.|"));

if(_Map.hasString("detailPrefix"))
{
	detailPrefix.set(_Map.getString("detailPrefix"));
	_Map.removeAt("detailPrefix", true);
}

PropString sDetailDescription(1, "", T("|Detail description|"));

PropString sDimStyle(2, _DimStyles, T("Dimension style"));

PropInt nColorLine(0, 1, T("Line color"));
PropInt nColorText(1, 7, T("Text color"));

PropString sDrawSectionLine(3, arSYesNo, T("|Draw section line|"));

String arSZnForDetails[] = 
{
	"Zone 0",
	"Zone 1",
	"Zone 2",
	"Zone 3",
	"Zone 4",
	"Zone 5",
	"Zone 6",
	"Zone 7",
	"Zone 8",
	"Zone 9",
	"Zone 10"
};
int arNZnForDetails[] = 
{
	0,
	1,
	2,
	3,
	4,
	5,
	-1,
	-2,
	-3,
	-4,
	-5
};

PropString sApplyDetailsTo(4, arSZnForDetails,T("|Apply Details to|"),2);

String arSZoneCharacter[] =
{ 
	"'E' for element tools",
	"'Z' for general items",
	"'T' for beam tools",
	"'I' for information",
	"'C' for construction",
	"'D' for dimension",
	"'J' for automic info"
};
char arCZoneCharacter[] =
{ 
	'E',
	'Z',
	'T',
	'I',
	'C',
	'D',
	'J'
};

PropString sZoneCharacter(5, arSZoneCharacter, T("|Zone character|"), 1);

String arSTrigger[] = {
	T("|Toggle opening detail|")
};
for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );


if( _bOnInsert ){
	
	PropString sAutoMode(6, arSYesNo, T("|Auto insert|"));
	
	PropDouble dOffsetFromCenter(3, U(100), T("|Offset from center|"));
	
	PropString sTopLeft(7, arSYesNo, T("|Top-Left|"));
	PropString sDefaultTextTopLeft(8, "TL", T("|Default text Top-Left|"));
	
	PropString sLeft(9, arSYesNo, T("|Left|"));
	PropString sDefaultTextLeft(10, "L", T("|Default text Left|"));
	
	PropString sBottomLeft(11, arSYesNo, T("|Bottom-Left|"));
	PropString sDefaultTextBottomLeft(12, "BL", T("|Default text Bottom-Left|"));
	
	PropString sBottom(13, arSYesNo, T("|Bottom|"));
	PropString sDefaultTextBottom(14, "B", T("|Default text Bottom|"));
	
	PropString sBottomRight(15, arSYesNo, T("|Bottom-Right|"));
	PropString sDefaultTextBottomRight(16, "BR", T("|Default text Bottom-Right|"));
	
	PropString sRight(17, arSYesNo, T("|Right|"));
	PropString sDefaultTextRight(18, "R", T("|Default text Right|"));
	
	PropString sTopRight(19, arSYesNo, T("|Top-Right|"));
	PropString sDefaultTextTopRight(20, "TR", T("|Default text Top-Right|"));
	
	PropString sTop(21, arSYesNo, T("|Top|"));
	PropString sDefaultTextTop(22, "T", T("|Default text Top|"));
	
	PropString sOpeningLeft(23, arSYesNo, T("|Opening Left|"));
	PropString sDefaultTextOpeningLeft(24, "OL", T("|Default text Opening Left|"));
	
	PropString sOpeningBottom(25, arSYesNo, T("|Opening Bottom|"));
	PropString sDefaultTextOpeningBottom(26, "OB", T("|Default text Opening Bottom|"));
	
	PropString sOpeningRight(27, arSYesNo, T("|Opening Right|"));
	PropString sDefaultTextOpeningRight(28, "OR", T("|Default text Opening Right|"));

	PropString sOpeningTop(29, arSYesNo, T("|Opening Top|"));
	PropString sDefaultTextOpeningTop(30, "OT", T("|Default text Opening Top|"));

	// Set properties if inserted with an execute key
	String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB-Production details (MS)");
	if( _kExecuteKey != "" && arSCatalogNames.find(_kExecuteKey) != -1 ) 
		setPropValuesFromCatalog(_kExecuteKey);
	else
		showDialog();
	
	int bAutoMode = arNYesNo[arSYesNo.find(sAutoMode,0)];
	int bAtTopLeft = arNYesNo[arSYesNo.find(sTopLeft,0)];
	int bAtLeft = arNYesNo[arSYesNo.find(sLeft,0)];
	int bAtBottomLeft = arNYesNo[arSYesNo.find(sBottomLeft,0)];
	int bAtBottom = arNYesNo[arSYesNo.find(sBottom,0)];
	int bAtBottomRight = arNYesNo[arSYesNo.find(sBottomRight,0)];
	int bAtRight = arNYesNo[arSYesNo.find(sRight,0)];
	int bAtTopRight = arNYesNo[arSYesNo.find(sTopRight,0)];
	int bAtTop = arNYesNo[arSYesNo.find(sTop,0)];
	int bAtOpeningLeft = arNYesNo[arSYesNo.find(sOpeningLeft,0)];
	int bAtOpeningBottom = arNYesNo[arSYesNo.find(sOpeningBottom,0)];
	int bAtOpeningRight = arNYesNo[arSYesNo.find(sOpeningRight,0)];
	int bAtOpeningTop = arNYesNo[arSYesNo.find(sOpeningTop,0)];
	
	if( bAutoMode ){
		PrEntity ssE(T("|Select element(s)|"), Element());
		if( ssE.go() ){
			Element arElSelected[] = ssE.elementSet();
			
			String strScriptName = "HSB-Production details (MS)"; // name of the script
			Vector3d vecUcsX(1,0,0);
			Vector3d vecUcsY(0,1,0);
			Beam lstBeams[0];
			Element lstElements[1];
			
			Point3d lstPoints[1];
			int lstPropInt[] = {nColorLine, nColorText};
			double lstPropDouble[] = {dSizeDetail, dSectionDepth, textOffsetProp};
			String lstPropString[] = {"", "", sDimStyle, sDrawSectionLine, sApplyDetailsTo, sZoneCharacter};
			Map mapTsl;
		
			for( int i=0;i<arElSelected.length();i++ ){
				Element elSelected = arElSelected[i];
				lstElements[0] = elSelected;
				
				// remove previously inserted tsls
				TslInst arTsl[] = elSelected.tslInst();
				for( int i=0;i<arTsl.length();i++ ){
					TslInst tsl = arTsl[i];
					if( tsl.scriptName() == strScriptName ){
						tsl.dbErase();
					}
				}
				
				PlaneProfile ppBrutto = elSelected.profBrutto(0);
				PlaneProfile ppNetto = elSelected.profNetto(0);
				PlaneProfile ppOpening = ppBrutto;
				ppOpening.subtractProfile(ppNetto);
				ppOpening.shrink(U(0.01));
				PlaneProfile ppEl = ppBrutto;
				ppEl.subtractProfile(ppOpening);
				
				//PlaneProfile ppEl = elSelected.profNetto(0);
				PLine arPlEl[] = ppEl.allRings();
				int arBRingIsOpening[] = ppEl.ringIsOpening();
				int nOpeningIndex = -1;
				
				for( int j=0;j<arPlEl.length();j++ ){
					PLine plEl = arPlEl[j];
					int bRingIsOpening = arBRingIsOpening[j];
					Point3d arPtPLine[] = plEl.vertexPoints(false);
	
					int nIsOpening = false;
					if( bRingIsOpening ){
						nOpeningIndex++;
						nIsOpening = true;
					}
					
					for( int k=0;k<(arPtPLine.length() - 1);k++ ){
						Point3d ptThis = arPtPLine[k];
						Point3d ptNext = arPtPLine[k+1];
						Point3d ptSection = (ptThis + ptNext) / 2;
						
						Vector3d vThisSection = ptNext - ptThis;
						vThisSection.normalize();
						
						Vector3d vPerp = elSelected.vecZ().crossProduct(vThisSection);
						if( 
							(!nIsOpening && ppBrutto.pointInProfile(ptSection + vPerp) == _kPointInProfile) ||
							(nIsOpening && PlaneProfile(plEl).pointInProfile(ptSection + vPerp) != _kPointInProfile)
						){
							vThisSection *= -1;
						}
						if( nIsOpening )
							vThisSection *= -1;
						
						Vector3d vOffset = vThisSection;
						if( vOffset.dotProduct(elSelected.vecX() + elSelected.vecY()) < 0 )
							vOffset *= -1;
						
						ptSection += vOffset * dOffsetFromCenter;
						lstPoints[0] = ptSection;
						
						Map mapTsl;
						mapTsl.setPoint3d("Reference", _PtW);
						mapTsl.setPoint3d("vSection", vThisSection);
						mapTsl.setPoint3d("vSectionPerp", elSelected.vecZ().crossProduct(vThisSection));
						mapTsl.setInt("IsOpening", nIsOpening);
						
						double dx = vThisSection.dotProduct(elSelected.vecX());
						double dy = vThisSection.dotProduct(elSelected.vecY());
						
						String sText;
						
						if( abs(dy) < dEps ){// Top or Bottom
							if( dx < dEps ){
								// Bottom
								if( (!bAtBottom && !nIsOpening) || (!bAtOpeningBottom && nIsOpening) )
									continue;
								sText = sDefaultTextBottom;
								if (nIsOpening)
									sText = sDefaultTextOpeningBottom;
								
							}
							else{
								// Top
								if( (!bAtTop && !nIsOpening) || (!bAtOpeningTop && nIsOpening) )
									continue;
								sText = sDefaultTextTop;
								if (nIsOpening)
									sText = sDefaultTextOpeningTop;
							}
						}
						else if( dy > dEps ){ // Left hand side
							if( abs(dx) < dEps ){
								// Left 
								if( (!bAtLeft && !nIsOpening) || (!bAtOpeningLeft && nIsOpening) )
									continue;
								sText = sDefaultTextLeft;
								if (nIsOpening)
									sText = sDefaultTextOpeningLeft;
							}
							else if( dx > dEps ){
								// Top-Left
								if( !bAtTopLeft )
									continue;
								sText = sDefaultTextTopLeft;
							}
							else{
								// Bottom-Left
								if( !bAtBottomLeft )
									continue;
								sText = sDefaultTextBottomLeft;
							}
						}
						else{ // Right hand side
							if( abs(dx) < dEps ){
								// Right
								if( (!bAtRight && !nIsOpening) || (!bAtOpeningRight && nIsOpening) )
									continue;
								sText = sDefaultTextRight;
								if (nIsOpening)
									sText = sDefaultTextOpeningRight;
							}
							else if( dx > dEps ){
								// Top-Right
								if( !bAtTopRight )
									continue;
								sText = sDefaultTextTopRight;
							}
							else{
								// Bottom-Right
								if( !bAtBottomRight )
									continue;
								sText = sDefaultTextBottomRight;
							}
						}						
						
						lstPropString[0] = sText;
						mapTsl.setString("detailPrefix", detailPrefix);
						
						// insert satelite
						TslInst tsl;
						tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
					}
				}			
			}
			
			eraseInstance();
			return;
		}
	}
	else{
		Element elSelected = getElement(T("Select an element"));
		_Pt0 = getPoint(T("Select an insertion point"));
			
		PlaneProfile ppEl = elSelected.profNetto(0);//plEnvelope();
		PLine arPlEl[] = ppEl.allRings();
		int arBRingIsOpening[] = ppEl.ringIsOpening();
			
		_Pt0 = ppEl.closestPointTo(_Pt0);
		
		Vector3d vThisSection;
		for( int i=0;i<arPlEl.length();i++ ){
			PLine plEl = arPlEl[i];
			int bIsOpening = arBRingIsOpening[i];
			
			Point3d arPtPLine[] = plEl.vertexPoints(FALSE);
			for( int j=0;j<(arPtPLine.length() - 1);j++ ){
				Point3d ptThis = arPtPLine[j];
				Point3d ptNext = arPtPLine[j+1];
				
				LineSeg lnSegPLine(ptThis, ptNext);
			
				Point3d ptSection = lnSegPLine.closestPointTo(_Pt0);
				double d = (Vector3d(ptSection - _Pt0)).length();
				if( (Vector3d(ptSection - _Pt0)).length() < dEps ){
					vThisSection = ptNext - ptThis;
					vThisSection.normalize();
					
					Vector3d vPerp = elSelected.vecZ().crossProduct(vThisSection);
					PlaneProfile ppEl(plEl);
					if( ppEl.pointInProfile(_Pt0 + vPerp) )
						vThisSection *= -1;
					if( bIsOpening )
						vThisSection *= -1;
					
					
					_Map.setPoint3d("Reference", _PtW);
					_Map.setPoint3d("vSection", vThisSection);
					_Map.setPoint3d("vSectionPerp", elSelected.vecZ().crossProduct(vThisSection));
					_Map.setInt("IsOpening", bIsOpening);
					i=arPlEl.length();
					break;
				}
			}
		}
	
		_Element.append(elSelected);
	}
	
	return;
}

Point3d p = _XW;

if( _Element.length() == 0 ){
	eraseInstance();
	return;
}
Element el = _Element[0];

int bDrawSectionLine = arNYesNo[arSYesNo.find(sDrawSectionLine,0)];

//Find selected zone and convert to index number
int nZnForDetails = arNZnForDetails[arSZnForDetails.find(sApplyDetailsTo, 5)];
char cZoneCharacter = arCZoneCharacter[arSZoneCharacter.find(sZoneCharacter, 1)];

//Force this tsl to the E0 layer of the element. Set layer "0" as base layer.
//_ThisInst.assignToLayer("0");
_ThisInst.assignToElementGroup(el, true, 0, 'E');

_Pt0 += el.vecZ() * el.vecZ().dotProduct( (el.ptOrg() - el.vecZ() * .5 * el.zone(0).dH()) - _Pt0 );

if( _kExecuteKey == arSTrigger[0] ){
	int bIsOpDet = false;
	bIsOpDet = _Map.getInt("IsOpening");
	_Map.setInt("IsOpening", !bIsOpDet);
}

Vector3d vSection;
Vector3d vSectionPerp;
int bIsOpeningDetail = false;
if( _Map.hasPoint3d("vSection") )
{
	Point3d reference = _Map.getPoint3d("Reference");
	Point3d direction = _Map.getPoint3d("vSection");
	Point3d directionPerp = _Map.getPoint3d("vSectionPerp");
	vSectionPerp = (directionPerp - reference);
	vSection = vSectionPerp.crossProduct(el.vecZ());
		
	// Just to be sure
	vSectionPerp.normalize();
	vSection.normalize();
	
	bIsOpeningDetail = _Map.getInt("IsOpening");
}
else{
	reportMessage(T("No vector set! TSL is removed!"));
	eraseInstance();
	return;
}
vSection.vis(_Pt0,150);
vSectionPerp.vis(_Pt0,3);
if( _bOnInsert ){
	_PtG.append(_Pt0 + vSectionPerp * .5 * dSizeDetail);
	return;
}

if( _PtG.length() == 0 ){
	_PtG.append(_Pt0);
}

Display dppl(nColorLine);
dppl.elemZone(el, nZnForDetails, cZoneCharacter);
dppl.showInDxa(true);
Display dptx(nColorText);
dptx.elemZone(el, nZnForDetails, cZoneCharacter);
dptx.showInDxa(true);

// hide in section views
//dppl.color(1);
dppl.addHideDirection(el.vecX());
dppl.addHideDirection(-el.vecX());
dppl.addHideDirection(el.vecY());
dppl.addHideDirection(-el.vecY());

if( _Map.hasPLine("pl") ){
	PLine pl = _Map.getPLine("pl");
	dppl.draw(pl);
}
//dptx.color(7);
int nTextSide = 1;
if( bIsOpeningDetail )
	nTextSide *= -1;

double textOffset = .4 * dSizeDetail;
if (textOffsetProp != 0)
{
	textOffset = textOffsetProp;
}

Vector3d vxTxt = el.vecX();
Vector3d vyTxt = el.vecY();
Point3d ptTxt = _PtG[0] + vSectionPerp * nTextSide * textOffset;

dptx.dimStyle(sDimStyle);
dptx.draw(sDetailName, ptTxt, vxTxt, vyTxt, 0, 0, _kDevice);
dptx.draw(sDetailDescription, ptTxt, vxTxt, vyTxt, 0, -5, _kDevice);// vSectionPerp, vSection, 1, -2.5, _kDevice);


double dHEl;
for( int i=-5;i<6;i++ ){
	dHEl += el.zone(i).dH();
}

if (bDrawSectionLine) {
	PLine plSection(vSection);
	plSection.addVertex(_Pt0 - vSectionPerp * .5 * dSizeDetail - el.vecZ() * dHEl);
	plSection.addVertex(_Pt0 + vSectionPerp * .3 * dSizeDetail - el.vecZ() * dHEl);
	plSection.addVertex(_Pt0 + vSectionPerp * .3 * dSizeDetail + el.vecZ() * dHEl);
	plSection.addVertex(_Pt0 - vSectionPerp * .5 * dSizeDetail + el.vecZ() * dHEl);
	plSection.close();
	dppl.draw(plSection);
}

_Map.setString("DetailName", sDetailName);

// Store detail in MapX of the element.
// Find all other detail tsl's attached to this element.
TslInst arTsl[] = el.tslInst();
String arSElementDetails[] = 
{
	sDetailName
};
for( int i=0;i<arTsl.length();i++ )
{
	TslInst tsl = arTsl[i];
//	if( tsl.scriptName() != _ThisInst.scriptName() )
//		continue;
	
	Map mapTsl = tsl.map();
	if(mapTsl.hasString("DetailName") && arSElementDetails.find(mapTsl.getString("DetailName")) != -1 )
	{
		continue;
	}
	
	arSElementDetails.append(mapTsl.getString("DetailName"));
}

Map mapDetails;
for( int i=0;i<arSElementDetails.length();i++ )
{
	String detailName = arSElementDetails[i];
	if (detailName.length() > 0)
	{
		mapDetails.appendString("Detail", detailPrefix + detailName);
	}
}

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
    <lst nm="Version">
      <str nm="Comment" vl="Set the visualization for the display instead of the _ThisInstance. Set this instance default to the zone0 layer." />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="3/7/2025 2:48:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to add a prefix to the detailName" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="10/13/2022 3:16:52 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End