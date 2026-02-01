#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
18.12.2018 - version 1.04

Places/deletes/sets color cover strips at roof element connections, walls and specific beams (defined by filters)
Notice: when creating strips, user don't have to concern about deleting previous existing, they'll be erased as well (if selected).
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
//region History and versioning
/// <summary Lang=en>
///
/// </summary>

/// <insert>
/// Select elementRoofs(s)
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <history>
/// DR - 1.00 - 14.05.2018	- Release
/// DR - 1.01 - 18.05.2018	- Added support for beams (filtered by beamCode) and kneeWalls (filtered by wall code )
///						- Props added: color, BeamCode (overrides value taken from original sheeting if set), Group to assing instead of roofElement
///						- Strips signed in submapX to be located by HSB_R-CoverStripsManager.mcr
///						- Strips found in selection deleted when creating new strips
///						- Removal of duplicateds
///						- Added a working secondary filter which makes it filter on beamcodes over filter definitions.
/// DR - 1.02 - 03.06.2018	- Added strips between sheeting inside same roof element
/// DR - 1.03 - 11.12.2018	- Added strips around openings
/// DR - 1.04 - 18.12.2018	- Not framing over beams that were found by code but not located at edge of sheet
///						- Fixed all issues around dormers
///						- Fixed issue with pieces not aligned when sheet is too small
///						- To frame over beams by code now sheets will be collected from ElemRoofs and sheets by manual selection
/// </history>
//endregion

//region basic settings
Unit (1,"mm");
double dTolerance=U(0.01);
String sNoYes[] = { T("|No|"), T("|Yes|")};
int nZoneForRoofs = - 1, nZoneForWalls = 1;//NOTICE: if change any of these you must implement code for new possible zones, at the time of creation we relayed that these were fixed
String sMapEntryName_Type = "Type", sMapEntryValue_Type = "coverstrip", sSubMapXKeyName = "CoverStripsInfo";
int nPropIndexInt, nPropIndexDouble, nPropIndexString;
String filterDefinitionTslName = "HSB_G-FilterGenBeams";

//debug
int bDebug=_bOnDebug;
// read a potential mapObject defined by hsbDebugController
{ 
	MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
	if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
	if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
}
int bOnDebugUsingColors = false, nOffDebug = 58, nColorSheetingDebug = 2;
int nColorsDebug[0];
int nColorOnRoofSheetsAtLeft, nColorOnRoofSheetsAtRight, nColorAroundOpening, nColorRoofConnections, nColorOnBeams, nColorOnWalls;
nColorOnRoofSheetsAtLeft = nColorOnRoofSheetsAtRight = nColorAroundOpening = nColorRoofConnections = nColorOnBeams = nColorOnWalls = 2;
nColorOnBeams = 3;
//endregion

//region props. arrays
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");

String arSNameGroup[0];
Group arAllGroups[] = Group().allExistingGroups();
for( int i=0;i<arAllGroups.length();i++ ){
	Group grp = arAllGroups[i];
	arSNameGroup.append(grp.name());
}
//order element left to right
for(int s1=1;s1<arSNameGroup.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		if( arSNameGroup[s11] < arSNameGroup[s2] ){
			arSNameGroup.swap(s2, s11);					
			s11=s2;
		}
	}
}

arSNameGroup.insertAt(0, T("|Don't assign|"));

String sTab="     ";
String sZoneOptions[]= {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"};
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
//endregion

//region properties
String sCategory_Manager= T("|Manager|");
String sActions[] = {T("|Create/replace|"), T("|Remove|"), T("|Change color|")};	
PropString sAction(nPropIndexString, sActions, T("|Action|"), 0);nPropIndexString++;
sAction.setCategory(sCategory_Manager);
PropDouble dMaxGap(nPropIndexDouble, U(18), T("|Max gap|"));nPropIndexDouble++;
dMaxGap.setCategory(sCategory_Manager);
dMaxGap.setDescription(T("|Max separation between roof elements|"));

String sCategory_Strip= T("|Strip|");
PropDouble dStripWidth (nPropIndexDouble, U(45), T("|Width|"));nPropIndexDouble++;
dStripWidth.setCategory(sCategory_Strip);
PropDouble dStripThickness (nPropIndexDouble, U(11), T("|Thickness|"));nPropIndexDouble++;
dStripThickness.setCategory(sCategory_Strip);
PropInt nColorStrip(nPropIndexInt, U(-1), T("|Color|"));	nPropIndexInt++;
nColorStrip.setDescription(T("|Taken from sheeting if -1|"));
nColorStrip.setCategory(sCategory_Strip);
PropString sBeamCode(nPropIndexString, "", T("|Beam code|"));nPropIndexString++;
sBeamCode.setCategory(sCategory_Strip);

String sCategory_FilterBeams= T("|Filter Beams|");
PropString beamFilterDefinition(nPropIndexString, filterDefinitions, T("|Filter definition for beams|"));nPropIndexString++;
beamFilterDefinition.setDescription(T("|Filter definition for beams.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|.") + TN("|NOTE|: ") + T("|This value gets overwriten by <Beam codes to filter> (if any set)|"));
beamFilterDefinition.setCategory(sCategory_FilterBeams);

PropString beamCodesToFilter(nPropIndexString, "OSP-01;OSP-02", T("|Beam codes to filter|"));nPropIndexString++;
beamCodesToFilter.setDescription(T("|Filter beams with these beam codes.|") + TN("|NOTE|: ") + T("|This value overrides the filter definition|"));
beamCodesToFilter.setCategory(sCategory_FilterBeams);

String sCategory_FilterWalls= T("|Filter Walls|");
PropString sWallCodesToFilter(nPropIndexString, "KN", T("|Wall codes|"));nPropIndexString++;
sWallCodesToFilter.setCategory(sCategory_FilterWalls);

String sCategory_Group= T("|Group|");
PropString sGroupNameProp(nPropIndexString, arSNameGroup, T("|Group|"));nPropIndexString++;
sGroupNameProp.setCategory(sCategory_Group);
PropString sSelectedZone( nPropIndexString, sZoneOptions, sTab+T("|Zone|"), 6);nPropIndexString++;
sSelectedZone.setCategory(sCategory_Group);
PropString sZoneCharacter(nPropIndexString,arSZoneCharacter, sTab+T("Zone character"), 1);nPropIndexString++;
sZoneCharacter.setCategory(sCategory_Group);
PropString sExclusive(nPropIndexString, sNoYes, sTab+T("Add exclusive"), 1);nPropIndexString++;
sExclusive.setCategory(sCategory_Group);
//endregion

//region custom commands (debug)
int bDeleteMyself = false;
String sCustomCommandDeleteAndRemoveStrips = T("|Delete And Remove Strips|");
addRecalcTrigger(_kContext, sCustomCommandDeleteAndRemoveStrips );
if (_bOnRecalc && _kExecuteKey==sCustomCommandDeleteAndRemoveStrips)
{
	bDeleteMyself = true;
}
//endregion

//region bOnInsert
// Set properties if inserted with an execute key
String sCatalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( sCatalogNames.find(_kExecuteKey) != -1 )
	setPropValuesFromCatalog(_kExecuteKey);	

if (_bOnInsert)
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	if ( _kExecuteKey == "" || sCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	setCatalogFromPropValues(T("_LastInserted"));
	
	int nAction = sActions.find(sAction, 0);
	if (nAction > 0)
	{
		PrEntity ssSh(T("|Select cover strips to remove/color (as sheeting)|"), Sheet());
		if (ssSh.go())
			_Sheet.append(ssSh.sheetSet());
		
		int bRemove = sActions.find(sAction, 1);
		int nAffected;
		for (int s = 0; s < _Sheet.length(); s++)
		{
			Sheet sh = _Sheet[s];
			if ( ! sh.bIsValid())
			{
				sh.dbErase();
				continue;
			}
			
			// Turn off colors - Model space: 58
			Map subMapX = sh.subMapX(sSubMapXKeyName);
			if (subMapX.length() == 0)
				continue;
			
			if (subMapX.hasString(sMapEntryName_Type))
			{
				if (subMapX.getString(sMapEntryName_Type) == sMapEntryValue_Type)
				{
					if (nAction == 1)
						sh.dbErase();
					else if (nAction == 2)
						sh.setColor(nColorStrip);
					
					nAffected++;
				}
			}
		}
		
		String sMessage;
		if (nAction == 1)
			sMessage = T("|Deleted|");
		else if (nAction == 2)
			sMessage = T("|Colored|");
		
		reportMessage(sMessage + T(" |cover strips|: ") + nAffected );
		eraseInstance();
		return;
	}
	
	PrEntity ssE(T("|Select entities|"), Entity());
	if (ssE.go())
		_Entity.append(ssE.set());
	
	if (bDebug)
		_Pt0 = getPoint();
	
	_Map.setInt("ManualInserted", true);
	return;
}
//endregion

//region set properties from master, set manualInserted=true if case
int manualInserted = false;
if (_Map.hasInt("ManualInserted")) 
{
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
	setPropValuesFromCatalog(T("|_LastInserted|"));
//endregion

//region Resolve properties
String sGroupName = sGroupNameProp;
Group groupSelected = Group (sGroupName);

int nSelectedZone= sZoneOptions.find(sSelectedZone);
int nZoneIndex = nSelectedZone;
if( nZoneIndex > 5 )
	nZoneIndex = 5 - nZoneIndex;

char cZoneCharacter = arCZoneCharacter[arSZoneCharacter.find(sZoneCharacter,1)];
int bExclusive = sNoYes.find(sExclusive, 1);
Display dp (nColorStrip);

//trimm tokens
String beamCodesToFilterTrimmed;
String beamCodesToFilterRaw[] = beamCodesToFilter.tokenize(";");
for (int s=0;s<beamCodesToFilterRaw.length();s++) 
{ 
	String token= beamCodesToFilterRaw[s]; 
	token = token.trimLeft().trimRight();
	beamCodesToFilterTrimmed += token + ";";
}
beamCodesToFilter.set(beamCodesToFilterTrimmed);
//endregion

//region Element collection, validation and basic info
if( _Entity.length() == 0 )
{
 	eraseInstance();
 	return;
}
ElementRoof roofs[0];
ElementWallSF walls[0];
Entity beamEntities[0];
for (int e = 0; e < _Entity.length(); e++)
{
	Entity ent = _Entity[e];
	ElementRoof roof = (ElementRoof) ent;
	ElementWallSF wall = (ElementWallSF) ent;
	Beam beam = (Beam) ent;
	Sheet sheet = (Sheet) ent;
	
	if (roof.bIsValid())
	{
		roofs.append(roof);
	}
	else if (wall.bIsValid())
	{
		String sWallCodes = sWallCodesToFilter.tokenize(";"); 
		if(sWallCodes.find(wall.code(), -1) >=0 )
			walls.append(wall);
	}
	else if (beam.bIsValid())
	{
		beamEntities.append(ent);
	}
	else if (sheet.bIsValid())
	{
		_Sheet.append(sheet);
	}
}
if(groupSelected.name() != arSNameGroup[0])
	groupSelected.addEntity(_ThisInst, bExclusive, nZoneIndex, cZoneCharacter);
//endregion

//region remove all previous cover strips created by this instance, cash non removed to selection
Sheet sheetsFromSelection[0];
int nDeletedCoverStrips;
for (int s = 0; s < _Sheet.length(); s++)
{
	Sheet sh = _Sheet[s];
	if ( ! sh.bIsValid())
	{
		sh.dbErase();
		continue;
	}
	
	// Turn off colors - Model space: 58
	Map subMapX = sh.subMapX(sSubMapXKeyName);
	if (subMapX.length() == 0)
	{
		sheetsFromSelection.append(sh);
		continue;
	}
	
	if (subMapX.hasString(sMapEntryName_Type))
	{
		if (subMapX.getString(sMapEntryName_Type) == sMapEntryValue_Type)
		{
			sh.dbErase();
			nDeletedCoverStrips++;
		}
	}
}

if(bDeleteMyself)
{ 
	eraseInstance();
	return;
}
//endregion

//region strip covers basics definition
Point3d ptStripCenters[0];
Vector3d vxStrips[0], vyStrips[0], vzStrips[0];
double dStripLengths[0];
Sheet shReferenceSheets[0];
//endregion

//region create srip on sheet of every element roof
Sheet sheetsFromElementRoofs[0];
int nCoverStripsCreatedOnRoofs, nDuplicatedOnRoofs;
for (int e = 0; e < roofs.length(); e++)
{
	ElementRoof elCurrent = roofs[e];	
	if ( ! elCurrent.bIsValid()) continue;
	
	CoordSys csEl = elCurrent.coordSys();
	Point3d ptElOrg = csEl.ptOrg();
	Vector3d vxEl = csEl.vecX();
	Vector3d vyEl = csEl.vecY();
	Vector3d vzEl = csEl.vecZ();
	Line lnX(ptElOrg, vxEl);		
	ElemZone elZone = elCurrent.zone(nZoneForRoofs);
	double dZoneThickness = elZone.dH();
	Point3d ptZoneOrg = elZone.coordSys().ptOrg();
	Sheet shAll[] = elCurrent.sheet(nZoneForRoofs);
	sheetsFromElementRoofs.append(sheetsFromElementRoofs);

	//search strips on sheeting connections
	//get right vertex on roof
	Point3d ptAllVertexOnRoof[] = elCurrent.plEnvelope().vertexPoints(true);
	Point3d ptOrderedPointsOnRoof[] = lnX.orderPoints(ptAllVertexOnRoof);
	Point3d ptLeftOnRoof = ptOrderedPointsOnRoof[0];
	Point3d ptRightOnRoof = ptOrderedPointsOnRoof[ptOrderedPointsOnRoof.length() - 1];

	for (int s = 0; s < shAll.length(); s++)
	{
		Sheet sheet = shAll[s];
		Point3d ptExtremesXOnSheet[] = sheet.realBody().extremeVertices(vxEl);
		
		//create strips at left side
		//get most left point of sheet
		Point3d ptLeftOnSheet = ptExtremesXOnSheet[0];
		
		//collect all vertex aligned to most left point on sheet
		Point3d ptLeftsOnSheet[0];
		Point3d ptAllVertexsOnSheet[] = sheet.plEnvelope().vertexPoints(true);
		for (int p = 0; p < ptAllVertexsOnSheet.length(); p++)
		{
			Point3d pt = ptAllVertexsOnSheet[p];
			if (abs(vxEl.dotProduct(pt - ptLeftOnSheet)) > dTolerance//is not aligned to sheet's ptLeft
				 || abs(vxEl.dotProduct(pt - ptLeftOnRoof)) < dStripWidth)//is aligned to roof's ptLeft
				{
					continue;
				}
			
			ptLeftsOnSheet.append(pt);
		}
		
		//create strip on every pair or points at left
		for (int p = 0; p < ptLeftsOnSheet.length(); p++)
		{
			if (p + 1 > ptLeftsOnSheet.length() - 1)
				break;
			
			Point3d ptStart = ptLeftsOnSheet[p];
			Point3d ptEnd = ptLeftsOnSheet[p + 1];
			
			//relocate this points to over current sheeting zone and half new piece thickness
			ptStart += vzEl * (vzEl.dotProduct(ptZoneOrg - ptStart) - dZoneThickness - dStripThickness * .5);
			ptEnd += vzEl * (vzEl.dotProduct(ptZoneOrg - ptEnd) - dZoneThickness - dStripThickness * .5);
			
			Point3d ptStripCenter = (ptStart + ptEnd) / 2;
			
			//avoid duplicated
			int bIsDuplicated = false;
			for (int p = 0; p < ptStripCenters.length(); p++)
			{
				Point3d ptStored = ptStripCenters[p];
				if ((ptStored - ptStripCenter).length() < dStripWidth)
				{
					bIsDuplicated = true;
					nDuplicatedOnRoofs++;
					break;
				}
			}
			
			if (bIsDuplicated)
				continue;
			
			//store info for new cover strip
			Vector3d vxStrip = vyEl;
			Vector3d vzStrip = vzEl;
			Vector3d vyStrip = vzStrip.crossProduct(vxStrip);
			double dStripLength = (ptStart - ptEnd).length();
			
			ptStripCenters.append(ptStripCenter);
			vxStrips.append(vxStrip);
			vyStrips.append(vyStrip);
			vzStrips.append(vzStrip);
			dStripLengths.append(dStripLength);
			shReferenceSheets.append(sheet);
			nColorsDebug.append(nColorOnRoofSheetsAtLeft);
			
			nCoverStripsCreatedOnRoofs++;
			p++;
		}
		
		//create strips at right side (duplicateds will exist and will be removed)
		//get most right point of sheet
		Point3d ptRightOnSheet = ptExtremesXOnSheet[ptExtremesXOnSheet.length() - 1];
		
		//collect all vertex aligned to most right point on sheet
		Point3d ptRightsOnSheet[0];
		for (int p = 0; p < ptAllVertexsOnSheet.length(); p++)
		{
			Point3d pt = ptAllVertexsOnSheet[p];
			if (abs(vxEl.dotProduct(pt - ptRightOnSheet)) > dTolerance//is not aligned to sheet's ptRight
				 || abs(vxEl.dotProduct(pt - ptRightOnRoof)) < dStripWidth)//is aligned to roof's ptRight
				{
					continue;
				}
			
			ptRightsOnSheet.append(pt);
		}
		
		//create strip on every pair or points at right
		for (int p = 0; p < ptRightsOnSheet.length(); p++)
		{
			if (p + 1 > ptRightsOnSheet.length() - 1)
				break;
			
			Point3d ptStart = ptRightsOnSheet[p];
			Point3d ptEnd = ptRightsOnSheet[p + 1];
			
			//relocate this points to over current sheeting zone and half new piece thickness
			ptStart += vzEl * (vzEl.dotProduct(ptZoneOrg - ptStart) - dZoneThickness - dStripThickness * .5);
			ptEnd += vzEl * (vzEl.dotProduct(ptZoneOrg - ptEnd) - dZoneThickness - dStripThickness * .5);
			
			Point3d ptStripCenter = (ptStart + ptEnd) / 2;
			
			//avoid duplicated
			int bIsDuplicated = false;
			for (int p = 0; p < ptStripCenters.length(); p++)
			{
				Point3d ptStored = ptStripCenters[p];
				if ((ptStored - ptStripCenter).length() < dStripWidth)
				{
					bIsDuplicated = true;
					nDuplicatedOnRoofs++;
					break;
				}
			}
			
			if (bIsDuplicated)
				continue;
			
			//store info for new cover strip
			Vector3d vxStrip = vyEl;
			Vector3d vzStrip = vzEl;
			Vector3d vyStrip = vzStrip.crossProduct(vxStrip);
			double dStripLength = (ptStart - ptEnd).length();
			
			ptStripCenters.append(ptStripCenter);
			vxStrips.append(vxStrip);
			vyStrips.append(vyStrip);
			vzStrips.append(vzStrip);
			dStripLengths.append(dStripLength);
			shReferenceSheets.append(sheet);
			nColorsDebug.append(nColorOnRoofSheetsAtRight);
			
			nCoverStripsCreatedOnRoofs++;
			p++;
		}
		
		// frame around openings
		PLine plOpenings[] = sheet.plOpenings();
		for (int p = 0; p < plOpenings.length(); p++)
		{
			PLine plOpening = plOpenings[p];
			PlaneProfile ppOpening(plOpening);
			LineSeg lnSeg = ppOpening.extentInDir(vxEl);
			Point3d ptBottomLeft = lnSeg.ptStart();
			Point3d ptTopRight = lnSeg.ptEnd();
			lnSeg = ppOpening.extentInDir(vyEl);
			Point3d ptTopLeft = lnSeg.ptEnd();
			Point3d ptBottomRight = lnSeg.ptStart();
			
			//store info for new cover strips
			Point3d pts[0];
			Vector3d vecXs[0];
			double dLengths[0];
			
			//top
			pts.append( ((ptTopLeft + ptTopRight) / 2) + vyEl * dStripWidth * .5 );
			vecXs.append(vxEl);
			dLengths.append(abs(vxEl.dotProduct(ptTopLeft - ptTopRight)) + dStripWidth * 2);
			//bottom 
			pts.append( ((ptBottomLeft + ptBottomRight) / 2) - vyEl * dStripWidth * .5 );
			vecXs.append(vxEl);
			dLengths.append(abs(vxEl.dotProduct(ptBottomLeft - ptBottomRight)) + dStripWidth * 2);
			//left
			pts.append(((ptTopLeft + ptBottomLeft) / 2) - vxEl * dStripWidth * .5);
			vecXs.append(vyEl);
			dLengths.append(abs(vyEl.dotProduct(ptTopLeft - ptBottomLeft)));
			//right
			pts.append(((ptTopRight + ptBottomRight) / 2) + vxEl * dStripWidth * .5);
			vecXs.append(vyEl);
			dLengths.append(abs(vyEl.dotProduct(ptTopRight - ptBottomRight)));
			for (int p = 0; p < pts.length(); p++)
			{
				Point3d ptStripCenter = pts[p];
				
				Vector3d vxStrip = vecXs[p];
				Vector3d vzStrip = vzEl;
				Vector3d vyStrip = vzStrip.crossProduct(vxStrip);
				double dStripLength = dLengths[p];
				
				ptStripCenters.append(ptStripCenter);
				vxStrips.append(vxStrip);
				vyStrips.append(vyStrip);
				vzStrips.append(vzStrip);
				dStripLengths.append(dStripLength);
				shReferenceSheets.append(sheet);
				nColorsDebug.append(nColorAroundOpening);
				nCoverStripsCreatedOnRoofs++;
				
			}//next index
		}//next index
	}
	
	//search strips on roof connections
	ElemRoofEdge edgesCurrent[] = elCurrent.elemRoofEdges();	
	//search all other elements that have coincident edges
	for (int f = e + 1; f < roofs.length(); f++)
	{		
		ElementRoof elOther = roofs[f];
		if ( ! elOther.bIsValid()) continue;

		Vector3d vzElOther = elOther.vecZ();		
		if( abs(1-vzEl.dotProduct(vzElOther)) > dTolerance)//roof planes are not paralell
		{
			continue;
		}
		
		ElemRoofEdge edgesOther[] = elOther.elemRoofEdges();
		
		for (int x = 0; x < edgesCurrent.length(); x++)
		{
			ElemRoofEdge edgeCurrent = edgesCurrent[x];
			Point3d ptCurrentStart = edgeCurrent.ptNode();
			Point3d ptCurrentEnd = edgeCurrent.ptNodeOther();
			LineSeg lsCurrent (ptCurrentStart, ptCurrentEnd);
			Point3d ptCurrentMid = lsCurrent.ptMid();
			Vector3d vCurrentDir = edgeCurrent.vecDir();
			
			for (int y = 0; y < edgesOther.length(); y++)
			{
				ElemRoofEdge edgeOther = edgesOther[y];
				LineSeg lsEdgeOther (edgeOther.ptNode(), edgeOther.ptNodeOther());
				Point3d ptOtherMid = lsEdgeOther.ptMid();
				Vector3d vOtherDir = edgeOther.vecDir();
				Line lnEdgeOther (ptOtherMid, vOtherDir);
				
				if (vCurrentDir.isParallelTo(vOtherDir))//edges are paralell
				{
					if (vCurrentDir.dotProduct(ptOtherMid - ptCurrentStart) * vCurrentDir.dotProduct(ptOtherMid - ptCurrentEnd) < 0 ) //edges are in contact
					{
						Point3d ptOtherAligned = lnEdgeOther.closestPointTo(ptCurrentMid);
						double dCurrentDistance = round((ptOtherAligned - ptCurrentMid).length());
						if ( dCurrentDistance <= dMaxGap)//edges are close enough
						{
							Vector3d vRealign (ptOtherMid - ptCurrentMid);//move to center between edges
							vRealign.normalize();
							
							LineSeg lsJoint = lsCurrent;
							lsJoint.transformBy(vRealign * (ptOtherMid - ptCurrentMid).length() * .5);//current valid connection
							
							//search sheething in contact with roof joint
							Body bdJoint(lsJoint.ptStart(), lsJoint.ptEnd(), U(25));
							for (int s = 0; s < shAll.length(); s++)
							{
								Sheet sh = shAll[s];
								if ( ! sh.bIsValid())
									continue;
								
								Body bdSh = sh.realBody();
								if ( ! bdSh.hasIntersection(bdJoint))
									continue;
								
								Body bdExtendedJoint(lsJoint.ptMid() - vCurrentDir * U(10000), lsJoint.ptMid() + vCurrentDir * U(10000), U(25));//make a large one to cover all sheeting edge, this will give us the extreme points for new sheeting
								bdSh.intersectWith(bdExtendedJoint);
								if (bdSh.area() < U(10))
									continue;
								
								Point3d ptExtremes[] = bdSh.extremeVertices(vCurrentDir);
								if (ptExtremes.length() < 2)
									continue;
								Line lnJoint(lsJoint.ptMid(), vCurrentDir);
								
								Point3d ptStart = lnJoint.closestPointTo(ptExtremes[0]);
								Point3d ptEnd = lnJoint.closestPointTo(ptExtremes[ptExtremes.length() - 1]);
								
								//relocate this points to over current sheeting zone and half new piece thickness
								ptStart += vzEl * (vzEl.dotProduct(ptZoneOrg - ptStart) - dZoneThickness - dStripThickness * .5);
								ptEnd += vzEl * (vzEl.dotProduct(ptZoneOrg - ptEnd) - dZoneThickness - dStripThickness * .5);
								
								Point3d ptStripCenter = (ptStart + ptEnd) / 2;
								
								//avoid duplicated
								int bIsDuplicated = false;
								for (int p = 0; p < ptStripCenters.length(); p++)
								{
									Point3d ptStored = ptStripCenters[p];
									if ((ptStored - ptStripCenter).length() < dStripWidth)
									{
										bIsDuplicated = true;
										nDuplicatedOnRoofs++;
										break;
									}
								}
								
								if(bIsDuplicated)
									continue;
								
								//store info for new cover strip
								Vector3d vxStrip = vCurrentDir;
								Vector3d vzStrip = vzEl;
								Vector3d vyStrip = vzStrip.crossProduct(vxStrip);
								double dStripLength = (ptStart - ptEnd).length();
								
								ptStripCenters.append(ptStripCenter);
								vxStrips.append(vxStrip);
								vyStrips.append(vyStrip);
								vzStrips.append(vzStrip);
								dStripLengths.append(dStripLength);
								shReferenceSheets.append(sh);
								nColorsDebug.append(nColorRoofConnections);
								nCoverStripsCreatedOnRoofs++;
							}
							
							dp.draw(lsJoint);
						}
					}
				}
			}
		}
	}
}
//endregion

//region on beams
//filter beams
Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(beamEntities, false, "GenBeams", "GenBeams", "GenBeam");

//Use secondary filter only when there is no catalog selected with filterGenBeams
String beamFilterDefinitionMapIO = beamFilterDefinition;
if (beamCodesToFilter != "")
{
	filterGenBeamsMap.setString("BeamCode[]", beamCodesToFilter);
	filterGenBeamsMap.setInt("Exclude", false);
	beamFilterDefinitionMapIO = "";
}

int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, beamFilterDefinitionMapIO, filterGenBeamsMap);
if (!successfullyFiltered) {
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}

Entity filteredBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
Beam filteredBeams[0];
for (int e=0;e<filteredBeamEntities.length();e++) 
{
	Beam bm = (Beam)filteredBeamEntities[e];
	if (!bm.bIsValid()) continue;
	
	filteredBeams.append(bm);
}

//collecting sheeting
Sheet sheetsValid[0];
for (int s=0;s<sheetsFromSelection.length();s++) 
{ 
	Sheet sh= sheetsFromSelection[s];
	if(sheetsValid.find(sh,-1)<0)
	{ 
		sheetsValid.append(sh);
	}
}
for (int s=0;s<sheetsFromElementRoofs.length();s++) 
{ 
	Sheet sh= sheetsFromElementRoofs[s];
	if(sheetsValid.find(sh,-1)<0)
	{ 
		sheetsValid.append(sh);
	}
}

//search contacting sheeting and proper conditions
Point3d ptStripCentersFromBeams[0];
int nCoverStripsCreatedOnBeams, nDuplicatedOnBeams;
for (int b = 0; b < filteredBeams.length(); b++)
{
	Beam bm = filteredBeams[b];
	if ( ! bm.bIsValid())
	{
		bm.dbErase();
		continue;
	}

		
	//search sheeting in contact with beam
	Vector3d vxBm = bm.vecX();
	Vector3d vyBm = bm.vecD(_ZW).crossProduct(vxBm);
	Vector3d vSearch = bm.vecD(-_ZW);
	Point3d ptOnFace = bm.ptCen() + vSearch * bm.dD(vSearch) * .5;
	Body bdSheetingSearch = bm.envelopeBody();
	bdSheetingSearch.transformBy(vSearch * U(2));
	if(bDebug)
		bdSheetingSearch.vis();
	
	for (int s = 0; s < sheetsValid.length(); s++)
	{
		Sheet sh = sheetsValid[s];
		Body bdSheet = sh.realBody();
		if ( ! bdSheet.hasIntersection(bdSheetingSearch))
		{
			continue;
		}
		
		if(bDebug)
			sh.ptCenSolid().vis(2);
				
		double dSheetingThickness = sh.dD(vSearch);
		Vector3d vxSheet = sh.vecX();
		Vector3d vySheet = sh.vecY();
		if ( ! vxBm.isParallelTo(vxSheet) && !vxBm.isParallelTo(vySheet)) // check if beam is properly aligned 
			continue;
		
		//check that beam is coincident with any of the sheet edges and close enough
		int bBeamIsAtEdge = false;
		Point3d pts[] = sh.plEnvelope().vertexPoints(false), ptEdge;
		for (int p = 0; p < pts.length()-1; p++)
		{
			Point3d pt0 = pts[p];
			Point3d pt1 = pts[p+1];
			if(!(pt0-pt1).isParallelTo(vxBm)) // beam is not aligned to edge
				continue;
			
			Vector3d vxSearch = (pt1 - pt0); vxSearch.normalize();
			Body bdSearch((pt0+pt1)/2, vxSearch, sh.vecZ().crossProduct(vxSearch), sh.vecZ(), (pt0-pt1).length(), U(2), U(100));
			if(bDebug)
				bdSearch.vis(2);
			if(!bdSearch.hasIntersection(bm.realBody()))
				continue;
				
			bBeamIsAtEdge = true;
			ptEdge = pt0;
		}//next index
		
		if(!bBeamIsAtEdge)
			continue;

		bdSheet.intersectWith(bdSheetingSearch);
		Point3d ptExtremeBmX[] = bdSheet.extremeVertices(vxBm);
		if (ptExtremeBmX.length() < 2)
			continue;
		
		Point3d ptStart = ptExtremeBmX[0];
		Point3d ptEnd = ptExtremeBmX[ptExtremeBmX.length() - 1];
		Point3d ptStripCenter = (ptStart + ptEnd) / 2;
		ptStripCenter += vSearch * (vSearch.dotProduct(ptOnFace - ptStripCenter) + dSheetingThickness + dStripThickness * .5) + vyBm * vyBm.dotProduct(ptEdge - ptStripCenter);
		
		//avoid duplicated or avoid strip if there is already one created by roof edges
		int bIsDuplicated = false, bNotNeeded = false;
		for (int p = 0; p < ptStripCenters.length(); p++)
		{
			PLine plExisting; plExisting.createRectangle(LineSeg(ptStripCenters[p] - vxStrips[p] * dStripLengths[p] * .5 - vyStrips[p] * dStripWidth * .5, ptStripCenters[p] + vxStrips[p] * dStripLengths[p] * .5 + vyStrips[p] * dStripWidth * .5), vxStrips[p], vyStrips[p]);
			PlaneProfile ppExisting(plExisting);
			if (ppExisting.pointInProfile(ptStripCenter) == _kPointInProfile)
				bNotNeeded = true;
		}
		
		if(bIsDuplicated || bNotNeeded)
			continue;
		
		Vector3d vxStrip = vxBm;
		Vector3d vzStrip = vSearch;
		Vector3d vyStrip = vzStrip.crossProduct(vxStrip);
		double dStripLength = abs(vxBm.dotProduct(ptStart - ptEnd));
		
		ptStripCenters.append(ptStripCenter);
		vxStrips.append(vxStrip);
		vyStrips.append(vyStrip);
		vzStrips.append(vzStrip);
		dStripLengths.append(dStripLength);
		shReferenceSheets.append(sh);
		nColorsDebug.append(nColorOnBeams);
		
		if(bDebug)
		{ 
			PLine pl(bm.ptCen(), ptStripCenter);
			pl.vis(1);
			Point3d ptCenBm = bm.ptCenSolid();
			ptCenBm.vis(b);
			Point3d ptCenCover = ptStripCenter;
			ptCenCover.vis(b);
			//aa
		}
		
		nCoverStripsCreatedOnBeams++;
	}
}
//endregion

//region on walls
Point3d ptStripCentersFromWalls[0];
int nCoverStripsCreatedOnWalls, nDuplicatedOnWalls;
for (int w = 0; w < walls.length(); w++)
{
	ElementWallSF el = walls[w];
	if ( ! el.bIsValid())
	{
		continue;
	}
	
	//basics from wall
	Point3d ptElOrg = el.ptOrg();
	Vector3d vxEl = el.vecX();
	Vector3d vyEl = el.vecY();
	Vector3d vzEl = el.vecZ();
	LineSeg ls = el.segmentMinMax();
	double dElLength = abs(vxEl.dotProduct(ls.ptStart() - ls.ptEnd()));
	Point3d ptElLeft = ptElOrg;
	Point3d ptElRight = ptElOrg + vxEl * dElLength;
	ElemZone zone = el.zone(nZoneForWalls);
	double dZoneThickness = zone.dH();
	
	//find sheeting splits (point between 2 sheets)
	Point3d ptAllExtremesX[0], ptAllExtremesY[0];
	Sheet shAll[] = el.sheet(nZoneForWalls);
	if(shAll.length() == 0)
		continue;
		
	for (int s = 0; s < shAll.length(); s++)
	{
		Sheet sh = shAll[s];
		Body bdSh = sh.envelopeBody();
		bdSh.vis();
		ptAllExtremesX.append(bdSh.extremeVertices(vxEl));
		ptAllExtremesY.append(bdSh.extremeVertices(vyEl));
	}
	
	Line lnX (ptElOrg + vzEl * (dZoneThickness + dStripThickness * .5), vxEl);
	ptAllExtremesX = lnX.projectPoints(ptAllExtremesX);
	Point3d ptSheetingSplits[0];
	
	for (int p = 0; p < ptAllExtremesX.length(); p++)
	{
		Point3d ptCurrent = ptAllExtremesX[p];
		int bPointFound = false;
		int nSafe;
		for (int q = p + 1; q < ptAllExtremesX.length(); q++)
		{
			Point3d ptNext = ptAllExtremesX[q];
			if (abs(vxEl.dotProduct(ptCurrent - ptNext)) < dStripWidth)
			{
				if ( ! bPointFound)
				{
					ptSheetingSplits.append((ptCurrent + ptNext) / 2);
					bPointFound = true;
				}
				
				ptAllExtremesX.removeAt(q);
				q--;
			}
			
			nSafe++;
			if (nSafe > 100)
			{
				reportMessage("\n" + scriptName() + ": " + T("|Safelock broken searching strip locations on knee walls|"));
			}
		}
	}
	
	Line lnY (ptElOrg, - vyEl);
	ptAllExtremesY = lnY.orderPoints(ptAllExtremesY);
	Point3d ptTop = ptAllExtremesY[0];
	
	Sheet shAny;
	if (shAll.length() > 0)
		shAny = shAll[0];
	
	for (int p = 0; p < ptSheetingSplits.length(); p++)
	{
		Point3d pt = ptSheetingSplits[p];
		Point3d ptStart = pt;
		Point3d ptEnd = pt + vyEl * vyEl.dotProduct(ptTop - pt);
		Point3d ptStripCenter = LineSeg(ptStart, ptEnd).ptMid();
		
		//avoid duplicateds
		int bIsDuplicated = false;
		for (int p = 0; p < ptStripCenters.length(); p++)
		{
			Point3d ptStored = ptStripCenters[p];
			if ((ptStored - ptStripCenter).length() < dStripWidth)
			{
				bIsDuplicated = true;
				nDuplicatedOnWalls++;
				break;
			}
		}
		
		if(bIsDuplicated)
			continue;
			
		Vector3d vxStrip = vyEl;
		Vector3d vyStrip = vxEl;
		Vector3d vzStrip = vxStrip.crossProduct(vyStrip);
		double dStripLength = (ptStart - ptEnd).length();
		
		ptStripCenters.append(ptStripCenter);
		vxStrips.append(vxStrip);
		vyStrips.append(vyStrip);
		vzStrips.append(vzStrip);
		dStripLengths.append(dStripLength);
		shReferenceSheets.append(shAny);
		nColorsDebug.append(nColorOnWalls);
				
		nCoverStripsCreatedOnWalls++;
		
	}
}

//endregion

//region create strips and assign to goup
if (groupSelected.name() != arSNameGroup[0])
	groupSelected.addEntity(_ThisInst, bExclusive, nZoneIndex, cZoneCharacter);

for (int s = 0; s < ptStripCenters.length(); s++)
{
	Point3d ptStripCenter = ptStripCenters[s];
	Vector3d vxStrip = vxStrips[s];
	Vector3d vyStrip = vyStrips[s];
	Vector3d vzStrip = vzStrips[s];
	double dStripLength = dStripLengths[s];
	Sheet sh = shReferenceSheets[s];
	
	Body bdStrip (ptStripCenter, vxStrip, vyStrip, vzStrip, dStripLength, dStripWidth, dStripThickness);
	bdStrip.vis(nColorSheetingDebug);
	
	Sheet shStrip;
	if ( ! bDebug)
		shStrip.dbCreate(bdStrip);
	
	shStrip.setType(sh.type());
	shStrip.setLabel(sh.label());
	shStrip.setSubLabel(sh.subLabel());
	shStrip.setSubLabel2(sh.subLabel2());
	shStrip.setGrade(sh.grade());
	shStrip.setInformation(sh.information());
	shStrip.setMaterial(sh.material());
	shStrip.setName(sh.name());
	shStrip.setModule(sh.module());
	shStrip.setHsbId(sh.hsbId());
	
	String sNewBeamCode = sh.beamCode();
	if (sBeamCode != "")
		sNewBeamCode = sBeamCode.trimLeft().trimRight();
	shStrip.setBeamCode(sNewBeamCode);
	
	if(bOnDebugUsingColors)
	{ 
		shStrip.setColor(nColorsDebug[s]);
	}
	else
	{
		int nNewColor = sh.color();
		if (nColorStrip >= 0)
			nNewColor = nColorStrip;
		shStrip.setColor(nNewColor);
	}
	
	//sign sheeting
	Map map;
	map.setString(sMapEntryName_Type, sMapEntryValue_Type);
	shStrip.setSubMapX(sSubMapXKeyName, map);
	
	_Sheet.append(shStrip);
	
	if (groupSelected.name() != arSNameGroup[0])
		groupSelected.addEntity(shStrip, bExclusive, nZoneIndex, cZoneCharacter);
	
	
	if (bDebug)
		shStrip.setColor(nColorSheetingDebug);
	
	//Point3d ptCen = ptStripCenter; ptCen.vis(nColorSheetingDebug);
}

reportMessage(TN("|Cover strips found and deleted|: ")+nDeletedCoverStrips);
int nCoverStripsTotal = nCoverStripsCreatedOnRoofs + nCoverStripsCreatedOnBeams + nCoverStripsCreatedOnWalls;
reportMessage(TN("|Created and assiged to group|: ") + groupSelected+": "+nCoverStripsTotal + " (" +
T(("|Roofs|: ")+nCoverStripsCreatedOnRoofs)+T("; |Beams|: ")+nCoverStripsCreatedOnBeams+T("; |Knee walls|: ")+nCoverStripsCreatedOnWalls+")");
//endregion

//region Temporary display (debug)
_Pt0 += _ZW * _ZW.dotProduct(_Entity[0].coordSys().ptOrg() - _Pt0);

double dc=U(1500);
Vector3d vxd=_XW;
Vector3d vyd=_YW;
Vector3d vzd=_ZW;
PLine pl;
Point3d ptStart=_Pt0;
Point3d ptCurrentMid=ptStart;
pl.addVertex(ptCurrentMid);
ptCurrentMid=ptStart+vxd*dc*.5;
pl.addVertex(ptCurrentMid);
ptCurrentMid=ptStart-vxd*dc*.5;
pl.addVertex(ptCurrentMid);
ptCurrentMid=ptStart;
pl.addVertex(ptCurrentMid);
ptCurrentMid=ptStart+vyd*dc*.5;
pl.addVertex(ptCurrentMid);
ptCurrentMid=ptStart-vyd*dc*.5;
pl.addVertex(ptCurrentMid);
dp.draw(pl);
pl=PLine();
ptCurrentMid=ptStart-vzd*dc*.5;
pl.addVertex(ptCurrentMid);
ptCurrentMid=ptStart+vzd*dc*.5;
pl.addVertex(ptCurrentMid);
dp.draw(pl);
//endregion

//region remove this instance
if(!bDebug)
{ 
	eraseInstance();
	return;
}
return;
//endregion
#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``,"`@,"`@,#`P,$`P,$!0@%!00$
M!0H'!P8(#`H,#`L*"PL-#A(0#0X1#@L+$!80$1,4%145#`\7&!84&!(4%13_
MVP!#`0,$!`4$!0D%!0D4#0L-%!04%!04%!04%!04%!04%!04%!04%!04%!04
M%!04%!04%!04%!04%!04%!04%!04%!3_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#]4Z***`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`**R]6\4:1H=]IECJ&I6UG>:G,;>
MRMYI0LES(%+%47JQ"@DXZ`5J4"N%%%%`PHHHH`***R]%\3Z1XBFU&+2M2M=1
M?3[@VEV+642>1,%#&-B.C`,N1U&:!7-2BBB@84444`%%%%`!1110`4444`%%
M,FF2WB>25UCC0;F=S@`#J2:CLKV#4K2&ZM95GMYE#QRH<JRGH0?2@">BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBO'OVA_C9%\,M!.GZ?*K>([Y#Y*CG[.AX,I]^NT>H)[5R8K%4L'1E7K.R7]6
M/0P&!KYEB887#J\I?U=^2ZE/XK?M0Z3\.?$$FBVFGG6KR%?W[+/Y:1/_`'/N
MG)'?TZ=<X\KUK]N74[&SFN5T'3[.*,$L\\KR`>G3;DU\_0PWFO:HL4227E]=
M2X"C+/([']22:\@^+6H:G;^)[[0+ZVDT\Z7.T$MM)PQD4X)/]/;GO7YC#.,S
MS"LW3GR0OT2T\KVW/Z#PO"&2X6G&E5IJ=2VK;>O=VO:US]0_V8/C@_QZ^'+Z
M[=0V]KJ5O>2VMS;V^0JXPR'!)/*,O?J#7H?CC6)_#O@O7]5M0ANK'3[BZB$@
MRN](V9<CTR!7P%_P3=^(7]C?$36_"<\I$&LVHG@4GCSH<G`'NC/_`-\"ON_X
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
@Z"\%Z3/H/A'1M-NMOVFTM(X9/+.5W*H!P?2MJB@#_]D`

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="TslInfo">
    <lst nm="TSLINFO" />
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End