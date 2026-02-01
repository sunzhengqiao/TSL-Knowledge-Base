#Version 8
#BeginDescription
1.05 - 19.06.2021 - HSB-12182: add trigger to add/remove connecting beams
Version 1.6 3-11-2023 Change property name, diameter to radius. Ronald van Wijngaarden

Creates lifting for a single beam

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL creates a lifting.
/// </summary>

/// <insert>
/// Select a vertical beam, and a position.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.04" date="20.06.2017"></version>

/// <history>
// #Versions
// 1.6 3-11-2023 Change property name, diameter to radius. Ronald van Wijngaarden
/// YB -	1.00 -	19.04.2017 - Pilot version
/// DR -	1.01 -	07.06.2017 - Added multi insertion, display, and enhanced to set element's zone number and character that it belongs to
/// AS -	1.02 -	08.06.2017 - Simplify insert
/// YB - 	1.03 -	14.06.2017 - Add a drill to adjacent beams
/// YB - 	1.04 -	20.06.2017 - Changed display according to adjacent beams, changed Pt0 to centerpoint of beams.
/// MN - 	1.05 -	19.06.2021 - HSB-12182: add trigger to add/remove connecting beams
/// </history>

double vectorTolerance = U(0.01, "mm");
double drillCorrection = U(1);

int arNZoneIndex[] = {0,1,2,3,4,5,6,7,8,9,10};
String arSZoneCharacter[] = {
	"'E' for element tools",
	"'Z' for general items",
	"'T' for beam tools",
	"'I' for information",
	"'C' for construction",
	"'D' for dimension"
};
char arCZoneCharacter[] = {
	'E', 
	'Z', 
	'T', 
	'I', 
	'C',
	'D'
};

String sCategory_Tooling= T("|Tooling|");
PropDouble propOffsetVertical(0, U(80), T("|Vertical offset|"));
propOffsetVertical.setDescription(T("|Offset in the vertical direction.|"));
propOffsetVertical.setCategory(sCategory_Tooling);
PropDouble propOffsetHorizontal(1, U(80), T("|Horizontal offset|"));
propOffsetHorizontal.setDescription(T("|Offset in the horizontal direction.|"));
propOffsetHorizontal.setCategory(sCategory_Tooling);
PropDouble propDiameter(2, U(10), T("|Drill radius|"));
propDiameter.setDescription(T("|Specifies the drill radius.|"));
propDiameter.setCategory(sCategory_Tooling);

String sCategory_Style= T("|Style|");
PropString sZoneCharacter(0, arSZoneCharacter, T("|Layer|"), 1);
sZoneCharacter.setCategory(sCategory_Style);
PropInt nPrZoneIndex(0, arNZoneIndex, T("|Zone index|"), 0);
nPrZoneIndex.setCategory(sCategory_Style);

String sCategory_Display= T("|Display|");
PropInt nColor(1, 3, T("|Color|"));
nColor.setCategory(sCategory_Display);

// Set properties if inserted with an execute key
String sCatalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( sCatalogNames.find(_kExecuteKey) != -1 )
	setPropValuesFromCatalog(_kExecuteKey);

// Insert
if(_bOnInsert)
{
	if( _kExecuteKey == "" || sCatalogNames.find(_kExecuteKey) == -1 )
		showDialogOnce(T("_LastInserted"));
	
	_Beam.append(getBeam(T("|Select a vertical beam|")));
	_Pt0 = getPoint(T("|Select insertion point|"));
	return;
}
//return
int nZoneIndex = arNZoneIndex.find(nPrZoneIndex, 0);
if( nZoneIndex > 5 )
	nZoneIndex = 5 - nZoneIndex;

char cZoneCharacter = arCZoneCharacter[arSZoneCharacter.find(sZoneCharacter,1)];

// Get selected beam
if(_Beam.length()==0 || !_Beam[0].bIsValid())
{
	eraseInstance();
	return;
}

Beam bm = _Beam[0];
Element el = bm.element();
assignToElementGroup(el, true, 0, 'Z');
if(!el.bIsValid())
{
	eraseInstance();
	return;
}

// Create coordinate system
CoordSys elCs = el.coordSys();
Vector3d vxEl = elCs.vecX();
Vector3d vyEl = elCs.vecY();
Vector3d vzEl = elCs.vecZ();
Vector3d bmX = bm.vecX();

if(!abs(vyEl.dotProduct(bmX)) == 1)
{
	reportNotice(T("|Beam is not vertical!|"));
	eraseInstance();
	return;
}

Point3d bmCenter = bm.ptCenSolid();
double bmLength = bm.solidLength();

// Figure out what direction the offset should go
Vector3d outsideY = vyEl;
Vector3d insideY = -vyEl;

if(vyEl.dotProduct(bmCenter - _Pt0) > vectorTolerance)
{
	outsideY *= -1;
	insideY *= -1;
}
// Set a new insertion point
_Pt0 = bmCenter + outsideY * 0.5 * bmLength;

// Create drill on the beam
Point3d drStart = _Pt0 + insideY * propOffsetVertical - vxEl * 0.5 * bm.dD(vxEl) - vxEl * drillCorrection;
Point3d drEnd = _Pt0 + insideY * propOffsetVertical + vxEl * 0.5 * bm.dD(vxEl) + vxEl * drillCorrection;

Drill drill(drStart, drEnd, propDiameter);
bm.addTool(drill);

// Create arrays to store all type of beams.
Beam verticalBeams[0];
Beam notVerticalBeams[0];
Beam allBeams[0];
// Collect all beams and store them in an array
Entity ent[] = Group().collectEntities(true, Beam(), _kAllSpaces);
for(int e = 0; e < ent.length(); e++)
	allBeams.append((Beam)ent[e]);
	
// Store all non vertical beams
for(int b = 0; b < allBeams.length(); b++) 
{
	Beam bmTest = allBeams[b];
	if(bm.vecX() == bmTest.vecX())
	{
		verticalBeams.append(bmTest);
		continue;
	}

		
	notVerticalBeams.append(bmTest);
}

// TODO Search for adjacent beams on both sides, apply the drill if needed.
// Get the adjacent beams -> Check if they are close enough  -> Add the tools

// Point to check from
Point3d ptAdjacentSearch = _Pt0 - outsideY * propOffsetVertical;

// Retrieve the beams on the left and right side of the chosen beam.
Beam leftBeams[] = Beam().filterBeamsHalfLineIntersectSort(verticalBeams, ptAdjacentSearch, -vxEl);
Beam rightBeams[] = Beam().filterBeamsHalfLineIntersectSort(verticalBeams, ptAdjacentSearch, vxEl);

// Create the points for the drill
Point3d ptLeftDrillStart = drStart;
Point3d ptLeftDrillEnd = drEnd;

ptLeftDrillStart.vis();
ptLeftDrillEnd.vis();

// Point to check if the beam should be removed.
Point3d ptDrillLeft = _Pt0 - vxEl * (propOffsetHorizontal - propDiameter);
double offsetLeft = 0;

// Loop through all beams to the left.
for(int i = 1; i < leftBeams.length(); i++)
{
	// Get the beam
	Beam leftAdjacentBeam = leftBeams[i];
	Point3d ptRightBeam = leftAdjacentBeam.ptCen() + vxEl * 0.5 * leftAdjacentBeam.dD(vxEl);
	
	// Visualize the beam
	// leftAdjacentBeam.envelopeBody().vis(150);

	// Check if the beams right side is located after the top drill position.
	if(vxEl.dotProduct((ptRightBeam - ptDrillLeft)) < vectorTolerance)
		break;
		
	// Visualize the beam
	// leftAdjacentBeam.envelopeBody().vis(150);
	
	// Calculate the gap between the beams
	double gapBetween = abs(vxEl.dotProduct((leftBeams[i - 1].ptCen() - vxEl * 0.5 * leftBeams[i - 1].dD(vxEl)) - ptRightBeam));	
	
	// Recalculate the points for the drills
	ptLeftDrillStart -= vxEl * (leftBeams[i - 1].dD(vxEl) + gapBetween);
	ptLeftDrillEnd -= vxEl * (leftBeams[i - 1].dD(vxEl) + gapBetween);
	
	// Replace the drill and add it to the adjacent beam.
	drill = Drill(ptLeftDrillStart, ptLeftDrillEnd, propDiameter);
	leftAdjacentBeam.addTool(drill);

	// Recalculate the drill point for  the top beam.
	ptDrillLeft -= vxEl * (leftBeams[i - 1].dD(vxEl) + gapBetween);
	offsetLeft += (leftBeams[i - 1].dD(vxEl) + gapBetween);
}

// Create the points for the drill
Point3d ptRightDrillStart = drStart;
Point3d ptRightDrillEnd = drEnd;

ptRightDrillStart.vis();
ptRightDrillEnd.vis();

// Point to check if the beam should be removed.
Point3d ptDrillRight = _Pt0 + vxEl * (propOffsetHorizontal - propDiameter);
double offsetRight = 0;

// Loop through all beams to the right.
for(int i = 1; i < rightBeams.length(); i++)
{
	// Get the beam
	Beam rightAdjacentBeam = rightBeams[i];
	Point3d ptLeftBeam = rightAdjacentBeam.ptCen() - vxEl * 0.5 * rightAdjacentBeam.dD(vxEl);
	
	// Visualize the beam
	// leftAdjacentBeam.envelopeBody().vis(150);

	// Check if the beams right side is located after the top drill position.
	if(vxEl.dotProduct((ptDrillRight - ptLeftBeam)) < vectorTolerance)
		break;
		
	// Visualize the beam
	// leftAdjacentBeam.envelopeBody().vis(150);
	
	// Calculate the gap between the beams
	double gapBetween = abs(vxEl.dotProduct((rightBeams[i - 1].ptCen() + vxEl * 0.5 * rightBeams[i - 1].dD(vxEl)) - ptLeftBeam));	
	
	// Recalculate the points for the drills
	ptRightDrillStart += vxEl * (rightBeams[i - 1].dD(vxEl) + gapBetween);
	ptRightDrillEnd += vxEl * (rightBeams[i - 1].dD(vxEl) + gapBetween);
	
	// Replace the drill and add it to the adjacent beam.
	drill = Drill(ptRightDrillStart, ptRightDrillEnd, propDiameter);
	rightAdjacentBeam.addTool(drill);

	// Recalculate the drill point for  the top beam.
	ptDrillRight += vxEl * (rightBeams[i - 1].dD(vxEl) + gapBetween);
	offsetRight += (rightBeams[i - 1].dD(vxEl) + gapBetween);
}


// TODO Transform the drill location
Beam connectingBeamsAll[] = bm.filterBeamsHalfLineIntersectSort(notVerticalBeams, _Pt0, outsideY);
int iConnectingBeamsInserted = _Map.getInt("iConnectingBeamsInserted");
if(iConnectingBeamsInserted==0)
{ 
	_Map.setInt("iConnectingBeamsInserted",1);
	_Map.setEntityArray(connectingBeamsAll, true, "connectingBeams", "", "");
}


Beam connectingBeams[0];
Beam connectingBeamsMap[0];
Entity entsconnectingBeams[] = _Map.getEntityArray("connectingBeams", "", "");
if(entsconnectingBeams.length()>0)
{ 
	for (int i=0;i<entsconnectingBeams.length();i++) 
	{ 
		Beam bmI = (Beam)entsconnectingBeams[i];
		if (bmI.bIsValid() && connectingBeamsMap.find(bmI) < 0)connectingBeamsMap.append(bmI);
	}//next i
}

connectingBeams.append(connectingBeamsMap);


for(int b = 0; b < connectingBeams.length(); b++)
{
	Beam cBm = connectingBeams[b];
	Point3d ptCenter = cBm.ptCen();
	Vector3d cBmX = cBm.vecX();	
	Vector3d cBmY = cBm.vecD(vyEl);
	if(outsideY != vyEl)
		cBmY *= -1;

	double beamHeight = cBm.dD(outsideY);
	Point3d bmTop = ptCenter + cBmY * 0.5 * beamHeight;
	
	double heightDifference = cBmY.dotProduct(bmTop - _Pt0);
	
	Point3d insertionPoint = _Pt0 + cBmY * heightDifference;

	Point3d ptTopLeft = insertionPoint - cBmX * propOffsetHorizontal - vxEl * offsetLeft;
	Point3d ptBotLeft = insertionPoint - cBmX * propOffsetHorizontal - cBmY * beamHeight - vxEl * offsetLeft;
	Point3d ptTopRight = insertionPoint + cBmX * propOffsetHorizontal + vxEl * offsetRight;
	Point3d ptBotRight = insertionPoint + cBmX * propOffsetHorizontal - cBmY * beamHeight + vxEl * offsetRight;
	Drill dr(ptTopLeft, ptBotLeft, propDiameter);
	Drill drtwo(ptTopRight, ptBotRight, propDiameter);
	cBm.addTool(dr);
	cBm.addTool(drtwo);
}

// HSB-12182
//region Trigger addConnectingBeams
	String sTriggeraddConnectingBeams = T("|add Connecting Beams|");
	addRecalcTrigger(_kContextRoot, sTriggeraddConnectingBeams );
	if (_bOnRecalc && _kExecuteKey==sTriggeraddConnectingBeams)
	{
		Beam beamsExtraAdd[0];
		PrEntity ssE(T("|Select beams|"), Beam());
		if (ssE.go())
			beamsExtraAdd.append(ssE.beamSet());
			
		for (int i=beamsExtraAdd.length()-1; i>=0 ; i--) 
		{ 
			if(connectingBeamsAll.find(beamsExtraAdd[i])<0)
			{ 
				// doesnt belong to the all possible connecting beams
				beamsExtraAdd.removeAt(i);
			}
			if(connectingBeams.find(beamsExtraAdd[i])>-1)
			{ 
				// already contained
				beamsExtraAdd.removeAt(i);
			}
		}//next i
		if(beamsExtraAdd.length()>0)
		{ 
			connectingBeams.append(beamsExtraAdd);
			// save in map
			_Map.setEntityArray(connectingBeams, true, "connectingBeams", "", "");
		}
		
		setExecutionLoops(2);
		return;
	}//endregion	


//region Trigger removeConnectigBeams
	String sTriggerremoveConnectingBeams = T("|remove ConnectingBeams|");
	addRecalcTrigger(_kContextRoot, sTriggerremoveConnectingBeams );
	if (_bOnRecalc && _kExecuteKey==sTriggerremoveConnectingBeams)
	{
		Beam beamsExtraRemove[0];
		PrEntity ssE(T("|Select beams|"), Beam());
		if (ssE.go())
			beamsExtraRemove.append(ssE.beamSet());
			
		for (int i=beamsExtraRemove.length()-1; i>=0 ; i--) 
		{ 
			if(connectingBeams.find(beamsExtraRemove[i])<0)
			{ 
				beamsExtraRemove.removeAt(i);
			}
		}//next i
		for (int i=0;i<beamsExtraRemove.length();i++) 
		{ 
			int iFind = connectingBeams.find(beamsExtraRemove[i]);
			if (iFind > -1)connectingBeams.removeAt(iFind);
		}//next i
		
		_Map.setEntityArray(connectingBeams, true, "connectingBeams", "", "");
		setExecutionLoops(2);
		return;
	}//endregion	


double offsetCorrection = (0.5 * offsetRight - 0.5 * offsetLeft);
_Pt0 += vxEl * offsetCorrection;

// Display
Display dpLifting(nColor);
dpLifting.elemZone(el, nZoneIndex, cZoneCharacter);
PLine pl(vzEl); 
Point3d pt01 = _Pt0 + vyEl * propOffsetVertical - vxEl * propOffsetHorizontal - vxEl * offsetCorrection;
Point3d pt02 = _Pt0 - vyEl * (propOffsetVertical - propOffsetHorizontal) - vxEl * propOffsetHorizontal - vxEl * offsetCorrection;
Point3d pt03 = _Pt0 - vyEl * (propOffsetVertical - propOffsetHorizontal) + vxEl * propOffsetHorizontal + vxEl * offsetCorrection;
Point3d pt04 = _Pt0 + vyEl * propOffsetVertical + vxEl * propOffsetHorizontal + vxEl * offsetCorrection;
pl.addVertex(pt01);
pl.addVertex(pt02);
pl.addVertex(pt03, 1);
pl.addVertex(pt04);
pl.close(1);
dpLifting.draw(pl);

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
      <str nm="Comment" vl="Change property name, diameter to radius." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="11/3/2023 11:23:56 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End