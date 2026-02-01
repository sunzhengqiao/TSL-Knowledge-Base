#Version 8
#BeginDescription
Last modified by: Ronald van Wijngaarden (support.nl@hsbcad.com)
17.01.2020 -  version 1.11

This tsl distributes sheets in a specified area

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 11
#KeyWords Distribution; sheet
#BeginContents
/// <summary Lang=en>
/// This tsl distributes sheets in a specified area.
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// The tsl has to be inserted in elevation view.
/// </remark>

/// <version  value="1.11" date="17.01.2020"></version>

/// <history>
/// AS - 1.00 - 12.03.2014 -	First revision
/// AS - 1.01 - 14.03.2014 -	_Pt0 is no start of distribution
/// AS - 1.02 - 14.03.2014 -	Start distribution outside area
/// AS - 1.03 - 19.03.2014 -	Project _Pt0 to start of pline.
/// AS - 1.04 - 19.03.2014 -	Add an extra row. Limit rows and columns to 500.
/// AS - 1.05 - 19.03.2014 -	Enable rotation.
/// AS - 1.06 - 19.03.2014 -	Split hatch and sheet rotation in the properties
/// AS - 1.07 - 19.03.2014 -	Report notice when invalid group is selected.
/// AS - 1.08 - 19.03.2014 -	Add option to specify the distribution direction.
///rvw - 1.09 - 13.11.2019 -	Add option to select a sheet also during bOnInsert. And delete the earlier created sheets in the _Map when the tsl is run again.
///rvw - 1.10 - 15.01.2020 -	Add option to assign the generated sheets to the element the original selected sheet belongs to.
///rvw - 1.11 - 17.01.2020 -	Assign the sheets to the chosen zone if they are assigned to the element.
/// </history>

double dEps = U(.1,"mm");

PropString sSeperator01(0, "", T("|Area|"));
sSeperator01.setReadOnly(true);

String arSYesNo[] = {
	T("|Yes|"),
	T("|No|")
};
int arNYesNo[] = {
	_kYes,
	_kNo
};
PropString sDrawArea(1, arSYesNo, "     "+T("|Draw area|"));

PropString sAreaName(2, "Area name", "     "+T("|Area name|"));
PropString sDimStyle(3, _DimStyles, "     "+T("|Dimension style|"));

PropString sHatchPattern(4, _HatchPatterns, "     "+T("|Hatch pattern|"));
PropDouble dHatchScale(0,U(10),"     "+T("|Pattern scale|"));
PropDouble dHatchAngleInDegrees(1, 30, "     "+T("|Angle of pattern| ")+T("[|degrees|]"));

PropInt nAreaColor(0, 1, "     "+T("|Area color|"));

PropString sSeperator02(5, "", T("|Sheets|"));
sSeperator02.setReadOnly(true);

String arSNameFloorGroup[0];
String noFloorgroup = T("|None|");

arSNameFloorGroup.append(noFloorgroup);

Group arFloorGroup[0];
Group arAllGroups[] = Group().allExistingGroups();
for( int i=0;i<arAllGroups.length();i++ ){
	Group grp = arAllGroups[i];
	if( grp.namePart(2) == "" && grp.namePart(1) != ""){
		arSNameFloorGroup.append(grp.name());
		arFloorGroup.append(grp);
	}
}
PropString sNameFloorGroup(6, arSNameFloorGroup, "     "+T("|Assign to floorgroup|"));

PropString sAssigndistributionToElement(10, arSYesNo, "     "+T("|Assign to element|"));

int arNZoneIndex[] = {
	1,2,3,4,5,6,7,8,9,10
};
PropInt nZoneIndex(1, arNZoneIndex, "     "+T("|Zone index|"), 2);

String arSDistributionDirection[] = {
	T("|Left to right|"),
	T("|Right to left|")
};
int arNDistributionDirection[] = {
	1,
	-1
};
PropString sDistributionDirection(9, arSDistributionDirection, "     "+T("|Distribution direction|"),0);

PropDouble dShLength(2, U(6000), "     "+T("|Size in element|-Y"));
PropDouble dShWidth(3, U(240), "     "+T("|Size in element|-X"));
PropDouble dShThickness(4, U(12), "     "+T("|Thickness|"));
PropDouble dShAngleInDegrees(7, 30, "     "+T("|Angle of sheets| ")+T("[|degrees|]"));

PropDouble dVerticalGap(5, U(0), "     "+T("|Vertical gap|"));
PropDouble dHorizontalGap(6, U(0), "     "+T("|Horizontal gap|"));

PropString sStartWithFullSheet(7, arSYesNo, "     "+T("|Start with full sheet|"));

PropInt nShColor(2, 1, "     "+T("|Color|"));
PropString sMaterial(8, "<sheet material>", "     "+T("|Material|"));



if ( _bOnInsert ) {
	Entity ent = getEntity(T("|Select a closed polyline or sheet that describes the area|"));
	
	if ( ! ent.bIsKindOf(Sheet()) && ( ! ent.bIsKindOf(EntPLine())))
	{
		reportMessage(T("|Invalid selection. Select a closed polyline or a sheet|"));
		eraseInstance();
		return;
	}
	
	_Pt0 = getPoint(T("|Select the start of the distribution|"));
	
	showDialogOnce();
	
	int assignDistributionToElementGroup = arNYesNo[arSYesNo.find(sAssigndistributionToElement, 0)];
	int nGrpIndex = arSNameFloorGroup.find(sNameFloorGroup);
	
	if (ent.bIsKindOf(Sheet()))
	{
		Sheet sh = (Sheet)ent;
		PLine plineEnvelope = sh.plEnvelope();
		EntPLine entPline;
		entPline.dbCreate(plineEnvelope);
		if ( ! assignDistributionToElementGroup && nGrpIndex > 0)
		{
			int nGrpIndex = arSNameFloorGroup.find(sNameFloorGroup);
			if ( nGrpIndex == -1 ) {
				reportWarning(T("|Invalid group selected|"));
				return;
			}
			Group grpFloor = arFloorGroup[nGrpIndex];
			Element thisEntityElement =sh.element();
			grpFloor.addEntity(entPline, true, sh.myZoneIndex(), 'I');
		}
		else
		{
			entPline.assignToElementGroup(sh.element(), true, sh.myZoneIndex(), 'I');
		}
		sh.dbErase();
		ent = entPline;
	}
	
	_Entity.append(ent);
	Map plinesMap;
	Map plineMap;
	plineMap.setEntity("EntPLine", ent);
	plineMap.setInt("Subtract", false);
	plinesMap.setMap("PLine", plineMap);
	_Map.setMap("PLine[]", plinesMap);
	
	
	return;
}
if( _Entity.length() == 0 ){
	eraseInstance();
	return;
}

if (_Map.hasMap("Entity[]"))
{
	//reportNotice("\n********* REMOVE ENTITIES *********");
	Map createdEntities = _Map.getMap("Entity[]");
	for (int e = 0; e < createdEntities.length(); e++)
	{
		Entity ent = createdEntities.getEntity(e);
		//reportNotice("\nEnt: " + ent.handle());
		ent.dbErase();
	}
	_Map.removeAt("Entity[]", true);
}

int nDistributionDirection = arNDistributionDirection[arSDistributionDirection.find(sDistributionDirection,0)];
int bDrawArea = arNYesNo[arSYesNo.find(sDrawArea, 0)];
int bStartWithFullSheet = arNYesNo[arSYesNo.find(sStartWithFullSheet,0)];
int assignDistributionToElementGroup = arNYesNo[arSYesNo.find(sAssigndistributionToElement, 0)];

reportMessage(assignDistributionToElementGroup);

int nGrpIndex = arSNameFloorGroup.find(sNameFloorGroup);
if( nGrpIndex == -1 ){
	reportWarning(T("|Invalid group selected|"));
	return;
}

int nZnIndex = nZoneIndex;
if( nZnIndex > 5 )
	nZnIndex = 5 - nZnIndex;
	
Group grpFloor = arFloorGroup[nGrpIndex];
Element thisEntityElement = _Entity[0].element();

if (!assignDistributionToElementGroup && nGrpIndex > 0)
{	
	grpFloor.addEntity(_ThisInst, true, nZnIndex, 'I');
}
else
{	
	_ThisInst.assignToElementGroup(thisEntityElement, true, nZnIndex, 'Z');
}



// This is now done through the Map

//// Erase the sheets from this group.
//Entity arEntSh[] = grpFloor.collectEntities(true, Sheet(), _kModelSpace);
//for( int i=0;i<arEntSh.length();i++ ){
//	Entity entSh = arEntSh[i];
//	if( entSh.myZoneIndex() == nZnIndex )
//		entSh.dbErase();
//}

EntPLine arEntPLine[0];
PLine arPLine[0];
int arBSubtract[0];//first PLine is the outer PLine
//return;

//add special context menu action to trigger the regeneration of the constuction
String sTriggerAddArea = T("Add area");
addRecalcTrigger(_kContext, sTriggerAddArea );
String sTriggerSubtractArea = T("Subtract area");
addRecalcTrigger(_kContext, sTriggerSubtractArea );

if( _kExecuteKey==sTriggerAddArea ){
	Entity ent = getEntity(T("|Select a closed polyline or sheet that describes the area to add|"));
	
	if (!ent.bIsKindOf(Sheet()) && (!ent.bIsKindOf(EntPLine())))
	{
		reportMessage(T("|Invalid selection. Select a closed polyline or a sheet|"));
		return;
	}
	
	EntPLine entPLine = (EntPLine)ent;
	_Entity.append(entPLine);
	Map plinesMap = _Map.getMap("PLine[]");
	Map plineMap;
	plineMap.setEntity("EntPLine", ent);
	plineMap.setInt("Subtract", false);
	plinesMap.appendMap("PLine", plineMap);
	_Map.setMap("PLine[]", plinesMap);
}
if( _kExecuteKey==sTriggerSubtractArea ){
	Entity ent = getEntity(T("|Select a closed polyline or sheet that describes the area to remove|"));
	
	if (!ent.bIsKindOf(Sheet()) && (!ent.bIsKindOf(EntPLine())))
	{
		reportMessage(T("|Invalid selection. Select a closed polyline or a sheet|"));
		return;
	}
	
	EntPLine entPLine = (EntPLine)ent;
	_Entity.append(entPLine);
	Map plinesMap = _Map.getMap("PLine[]");
	Map plineMap;
	plineMap.setEntity("EntPLine", ent);
	plineMap.setInt("Subtract", true);
	plinesMap.appendMap("PLine", plineMap);
	_Map.setMap("PLine[]", plinesMap);
}

Map plinesMap = _Map.getMap("PLine[]");
for (int index=0;index<plinesMap.length();index++) 
{ 
	Map plineMap = plinesMap.getMap(index); 
	Entity ent = plineMap.getEntity("EntPLine");
	EntPLine entPline = (EntPLine)ent;
	if (! entPline.bIsValid())
	{
		plinesMap.removeAt(index, true);
		index --;
		continue;
	}
	arPLine.append(entPline.getPLine());
	arBSubtract.append(plineMap.getInt("Subtract"));
}//next index

_Map.setMap("PLine[]", plinesMap);

if( arPLine.length() != arBSubtract.length() )
{
	reportError(T("Different length of internal lists!"));
}

//Sort PLines on bSubtract (add first)
int nSort;
PLine plSort;
//Sort OKR beams on height
for(int s1=1;s1<arBSubtract.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		if( arBSubtract[s2] > arBSubtract[s11] ){
			nSort = arBSubtract[s2];				arBSubtract[s2] = arBSubtract[s11];				arBSubtract[s11] = nSort;
			plSort = arPLine[s2];					arPLine[s2] = arPLine[s11];						arPLine[s11] = plSort;

			s11=s2;
		}
	}
}

Vector3d vxZn = nDistributionDirection * _XU.rotateBy(dShAngleInDegrees, _ZU);
Vector3d vyZn = _YU.rotateBy(dShAngleInDegrees, _ZU);
Vector3d vzZn = _ZU;

// Make sure _Pt0 is in the right plane. For now we use the origin of the main pline.
if( arPLine.length()>0 ){
	PLine pl = arPLine[0];
	_Pt0 = Plane(pl.ptStart(), vzZn).closestPointTo(_Pt0);
}

PlaneProfile ppArea(CoordSys(_Pt0, vxZn, vyZn, vzZn));
for( int i=0;i<arPLine.length();i++ ){
	PLine pl = arPLine[i];
	int bSubtract = arBSubtract[i];
	
	ppArea.joinRing(pl, bSubtract);
}
double dArea = ppArea.area();

Hatch hatchArea(sHatchPattern, dHatchScale);
hatchArea.setAngle(dHatchAngleInDegrees);

Display dp(nAreaColor);

if( bDrawArea )
	dp.draw(ppArea, hatchArea);

Display dpTxt(-1);
dpTxt.dimStyle(sDimStyle);
dpTxt.draw(sAreaName, _Pt0,_XW,_YW, 0, 0, _kDeviceX);

int bCreateNewSheeting = true;
CoordSys csZn(_Pt0, vxZn, vyZn, vzZn);

Line lnX(_Pt0, vxZn);
Line lnY(_Pt0, vyZn);

Map mapWithCreatedEntities;

if ( bCreateNewSheeting )
{
	//Body Area
	PLine arPlDistribute[] = ppArea.allRings();
	if ( arPlDistribute.length() == 0 )
		return;
	PLine plDistribute = arPlDistribute[0];
	Body bdDistribute(plDistribute, vzZn);
	dp.draw(plDistribute);
	
	//Area grip vertex points
	Point3d arPtGripDistribute[] = ppArea.getGripVertexPoints();
	
	//Order points
	Point3d arPtGripDistributeX[] = lnX.orderPoints(arPtGripDistribute);
	Point3d arPtGripDistributeY[] = lnY.orderPoints(arPtGripDistribute);
	_Pt0.vis(4);
	// Start point for distribution is lower-left hand corner of the box around the area.
	Point3d ptStartDistribution = arPtGripDistributeX[0] + vyZn * vyZn.dotProduct(arPtGripDistributeY[0] - arPtGripDistributeX[0]);
	// Distances of distribution point to _Pt0.
	double dxStart = vxZn.dotProduct(_Pt0 - ptStartDistribution);
	double dyStart = vyZn.dotProduct(_Pt0 - ptStartDistribution);
	// Adjust start point. The user has picked a point. The calculated startpoint has to be corrected in the -x and -y direction.
	double dxCorrection = dxStart / (dShWidth + dHorizontalGap);
	dxCorrection -= int(dxCorrection);
	ptStartDistribution -= vxZn * (1 - dxCorrection) * (dShWidth + dHorizontalGap);
	double dyCorrection = dyStart / (dShLength + dVerticalGap);
	dyCorrection -= int(dyCorrection);
	ptStartDistribution -= vyZn * (1 - dyCorrection) * (dShLength + dVerticalGap);
	ptStartDistribution.vis(3);
	
	// Create sheeting
	// Get the extreme points of the area. The distribution should stop once it crosses these points.
	Point3d ptDistributeMaxX = arPtGripDistributeX[arPtGripDistributeX.length() - 1];
	Point3d ptDistributeMaxY = arPtGripDistributeY[arPtGripDistributeY.length() - 1];
	// Rows.
	int nRowIndex = 0;
	int bStartNextRow = false;
	while ( ! bStartNextRow ) {
		if ( nRowIndex > 500 )
			break;
		nRowIndex++;
		
		int bStartWithFullSheetForThisRow = bStartWithFullSheet;
		Point3d ptThisShColumn = ptStartDistribution;
		
		// Columns.
		int nColumnIndex = 0;
		bStartNextRow = false;
		while ( true ) {
			if ( nColumnIndex > 500 )
				break;
			nColumnIndex++;
			
			//Points to create the envelope of the sheet as a planeProfile
			Point3d ptBL = ptThisShColumn - vxZn * bStartWithFullSheetForThisRow * 0.5 * (dShWidth + dHorizontalGap);
			// Is this position still valid?
			if ( vyZn.dotProduct(ptDistributeMaxY - ptBL) < 0 ) {
				ptBL.vis(1);
				break;
			}
			if ( vxZn.dotProduct(ptDistributeMaxX - ptBL) < 0 ) {
				ptBL.vis(3);
				bStartNextRow = true;
			}
			Point3d ptBR = ptBL + vxZn * dShWidth;
			Point3d ptTR = ptBR + vyZn * dShLength;
			Point3d ptTL = ptTR - vxZn * dShWidth;
			PLine plSh(ptBL, ptBR, ptTR, ptTL);
			
			//Create a plane profile with a normal and add a ring
			PlaneProfile ppSh(csZn);
			ppSh.joinRing(plSh, _kAdd);
			ppSh.vis();
			
			if ( ppSh.intersectWith(ppArea) ) {
				//dbCreate the sheet
				PLine arPlSh[] = ppSh.allRings();
				int arNRingIsOpening[] = ppSh.ringIsOpening();
				for ( int i = 0; i < arPlSh.length(); i++) {
					//Ignore openings
					if ( arNRingIsOpening[i] )
						continue;
						//Get this pline and create a planeprofile with it.
						PLine plThisSh = arPlSh[i];
						//Create a plane profile with a normal and add a ring
						PlaneProfile ppThisSh(csZn);
						ppThisSh.joinRing(plThisSh, _kAdd);ppThisSh.vis(5);
						//Create the sheet
						Sheet sh;
						sh.dbCreate(ppThisSh, dShThickness, 1);
						sh.setColor(nShColor);
						sh.setMaterial(sMaterial);
												
						if (!assignDistributionToElementGroup && nGrpIndex > 0)
						{	
							grpFloor.addEntity(sh, true, nZnIndex, 'Z');
						}
						else
						{
							sh.assignToElementGroup(thisEntityElement, true, nZnIndex, 'Z');
						}						
						mapWithCreatedEntities.appendEntity("Entity", sh);
						//					sh.assignToElementGroup(el, TRUE, nZoneIndex, 'Z');
				}
			}
			//Next row
			
			ptThisShColumn += vyZn * (dShLength + dVerticalGap);
			bStartWithFullSheetForThisRow = ! bStartWithFullSheetForThisRow;
		}
		
		//Next column
		ptStartDistribution += vxZn * (dShWidth + dHorizontalGap);
	}
	
	if (mapWithCreatedEntities.length() > 0)
	{
		_Map.setMap("Entity[]", mapWithCreatedEntities);
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
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO">
        <lst nm="TSLINFO">
          <lst nm="TSLINFO">
            <lst nm="TSLINFO">
              <lst nm="TSLINFO">
                <lst nm="TSLINFO" />
              </lst>
            </lst>
          </lst>
        </lst>
      </lst>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End