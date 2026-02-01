#Version 8
#BeginDescription
Used to create zoomed in detail view both in section/elevation and plan. Requires sd_ViewPlaceholderUtility or sd_ViewDataExporter to be in Layout block

V0.66__23November2017__Renamed and revised for public release. Increased minimum allowed Grip separation
version value="0.65" date=23nov17" author="thorsten.huck@hsbcad.com"> Bugfix in view detection, language independency added, properties categorized
V0.64__21November2017__Bugfix in transforms when working from SD_ViewDataGenerator
V0.63__21November2017__Additions to support gathering information from SD_ViewDataExporter  cc
V0.62__15August2017__Bugfix in scale calculation
V0.60__9August2017__Updates to coordinate with other scripts
V0.55__31May2017__Enabled working from ViewGeneratorStandard
V0.52__21April2017__bugfix on body generation
V0.50_6April2017__Added Circle Plan option, autoset of Section view height
V0.40_3April2017_Added High Detail option to Section Cut;
V0.38__28March2017__Added safety when adding body parts together
V0.37__28March2017__Added Safety line 424 ish when finding points bottom top
V0.36_27March2017__Retreval and re-release of current source code
V0.32_13March2017__Bugfix in scale calculation
V0.30_3February2017_Improvements in display & control of section
V0.25__29December2016_Inception
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 66
#KeyWords 
#BeginContents

/*
<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>

-------DESCRIPTION!!!!!!!

V0.1 _ !!DATE!!__!!VERSION DESCRIPTION!!!!!

                                                       cc@hsb-cad.com
<>--<>--<>--<>--<>--<>--<>--<>_____  craigcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>


//######################################################################################
//############################ Documentation #########################################
<insert>
Primarily intended to be inserted 
</insert>

<property name="xx">
- What are the important properties.
</ property >

<command name="xx">
- What are the custom commands.
</command>

<version  value=?0.85? date=?2july08?>
</version>

<remark>
- What could make the tsl fail. 
- Is this an Element tsl that can be added to the list of auto attach tsls.
- What is the (internal) result of the tls: adds element/beam tools, changes properties of other entities,?
- Requirements and scope of applying this tsl (display configuration, styles, hatch, )
- Dependency on other entities (maps, properties, property sets, auto properties,?)
- Dependency on other software components (dlls, xml, catalogs, ?)
</remark>

Grip Definitions=
_PtG[0] -> Primary defining location of source
_PtG[1] -> Defines length of section cut, or height of plan view
_PtG[2] -> Defines depth of section cut, or width of plan View
_PtG[3] -> Location of resulting linework
_PtG[4] -> Source Tag. Title text will be tied to detail view location
_PtG[5] -> Height of section cut, not used in Plan view
//########################## End Documentation #########################################
//######################################################################################
*/



//######################################################################################		
//########################## Props & basic setup #############################################	

U(1, "mm");
int bInDebug = false;
if(_bOnDebug) bInDebug = true;
//bInDebug = true;
String category = T("|General|");
String sNoYes[] = { T("|No|"), T("|Yes|")};





// mode
category = T("|Mode|");

String stOperationModes[] = { T("|Rectangle Plan|"), T("|Sect/Elev Cut|"), T("|Circle Plan|")};
//String stOperationModes[] = { "Rectangle Plan", "Sect/Elev Cut"};
PropString psOperationMode (1, stOperationModes, T("|Type|"));
psOperationMode.setCategory(category);
int bIsSectionCut = psOperationMode == stOperationModes[1];
int bIsCirclePlan = psOperationMode == stOperationModes[2];
int bIsRectanglePlan = psOperationMode == stOperationModes[0];

PropString psDoFlippedReverseView(5, sNoYes, T("|Flipped Reverse View|"));
psDoFlippedReverseView.setCategory(category);
int bUseFlippedReverseView = psDoFlippedReverseView == sNoYes[1];

String stHighDetailOptions[] = { T("|High|"), T("|Low (Outline)|")};
PropString psDoHighDetail(6, stHighDetailOptions, T("|Detail Level|"));
psDoHighDetail.setDescription(T("|This option only relevant to Collection Entities|"));
psDoHighDetail.setCategory(category);
int bDoHighDetail = stHighDetailOptions[0] == psDoHighDetail;

PropDouble pdScale(0, 1, "Scale");
pdScale.setCategory(category);

PropInt piVisibleColor(1, 4, T("|Color|"));
piVisibleColor.setCategory(category);

// Hidden Linework
category = T("|Hidden Linework|");
PropInt piHiddenColor(0, 7, T("|Color|")+" ");
piHiddenColor.setCategory(category);

PropString psHiddenLinetype(0, _LineTypes, T("|Linetype|"));
psHiddenLinetype.setCategory(category);

PropDouble pdHiddenLinetypeScale(7, -1, T("|Linetype Scale|"));
pdHiddenLinetypeScale.setCategory(category);


// Tag and Text
category = T("|Title|");
PropString psTitle(4, "Enter Title", T("|Title|"));
psTitle.setCategory(category);

PropInt piTextColor(4, 6, T("|Color|")+"  ");
piTextColor.setCategory(category);

PropDouble pdTitleHeight(3, U(15), T("|Text Height|"));
pdTitleHeight.setCategory(category);


category = T("|Tag|");
PropString psDetailTag(3, "A", T("|Tag|"));
psDetailTag.setCategory(category);

PropInt piTagColor(5, 6, T("|Color|")+"   ");
piTagColor.setCategory(category);

PropDouble pdTagHeight(4, U(20), T("|Text Height|")+" ");
pdTagHeight.setCategory(category);



// General Linework
category = T("|General Linework|");
PropInt piCutlineColor(2, 1, T("|Cut-Line Color|"));
piCutlineColor.setCategory(category);

PropDouble pdVerticalOffset(6, 0, T("|Section Vertical Offset|"));
pdVerticalOffset.setReadOnly(bIsRectanglePlan);
pdVerticalOffset.setCategory(category);

PropString psDrawConnector(7, sNoYes, T("|Draw Connector|"));
psDrawConnector.setCategory(category);
int bDrawConnector =	sNoYes.find(psDrawConnector);

PropString psDrawBorder(2, sNoYes, T("|Draw Border|"));
psDrawBorder.setCategory(category);
int bDrawBorder = sNoYes.find(psDrawBorder);

PropInt piBorderColor(3, 0, T("|Border Color|") );
piBorderColor.setCategory(category);

PropDouble pdBorderPadding(5, 0, T("|Border Padding|") );
pdBorderPadding.setCategory(category);

PropDouble pdArrowL(1, U(60), T("|Arrow Length|"));
pdArrowL.setCategory(category);
PropDouble pdArrowH(2, U(30), T("|Arrowhead Scale|"));
pdArrowH.setCategory(category);





Display dpBorder(piBorderColor);
Display dpCutline(piCutlineColor);
Display dpVisible(piVisibleColor);
Display dpHidden(piHiddenColor);
dpHidden.lineType(psHiddenLinetype, pdHiddenLinetypeScale);
Display dpTitleText(piTextColor);
dpTitleText.textHeight(pdTitleHeight);
Display dpTag(piTagColor);
dpTag.textHeight(pdTagHeight);

Vector3d vX = _XW;
Vector3d vY = _YW;
Vector3d vZ = _ZW;
Plane pnWorld(_PtW, vZ);


if (_bOnInsert)
{
	if(insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	showDialogOnce();
	
	PrEntity pre(T("|Select Multipage Shopdrawing or ViewGenerator TSL|"));
	Entity entCollector[0];
	if(pre.go())  entCollector = pre.set();

	_Entity.append(entCollector);
	
	_PtG.append(getPoint(T("|Select first defining point|")));
	PrPoint prp(T("|Select 2nd defining point|"), _PtG[0]);
	if(prp.go()) _PtG.append(prp.value());
	
	PrPoint prp2(T("|Select 3rd point or return|"), _PtG[0]);
	if(prp2.go() == _kOk)  _PtG.append(prp2.value()); 
	
	_Map.setPoint3d("ptViewTarget", getPoint(T("|Select location for generated linework|")));
	return;
}


//########################## End Props_and_Insert ###############################################
//######################################################################################	
			
			
//######################################################################################		
//########################## Grip Management #############################################	

//__Insertion will have set either 2 or 3 grip points
if(_PtG.length() < 5)//__after insertion this will be true
{
	//_add grip and enforce location
	Vector3d vDefine = _PtG[1] - _PtG[0];
	Vector3d vViewDir = vDefine.crossProduct(_ZW);
	
	if(_PtG.length() < 3)_PtG.append(_PtG[0] + vViewDir);
	_PtG.append(_Map.getPoint3d("ptViewTarget"));
	_Map.removeAt("ptViewTarget", 0);
	
	_PtG.append(_PtG[0] - vY * pdTagHeight*2);
}

//__enforce all grips are in world xy plane 
for(int i=0;i<_PtG.length();i++)
{
	_PtG[i].setZ(0);
}

//__grips 1 and 2 should maintain relation to 0
//___cannot use _Pt0 since that would also move the generated linework
if(_kNameLastChangedProp == "_PtG0")
{
	Vector3d vGrip1Locate = _Map.getVector3d("vGrip1Locate");
	_PtG[1] = _PtG[0] + vGrip1Locate;
	
	Vector3d vGrip2Locate = _Map.getVector3d("vGrip2Locate");
	_PtG[2] = _PtG[0] + vGrip2Locate;
	
	Vector3d vGrip4Locate = _Map.getVector3d("vGrip4Locate");
	_PtG[4] = _PtG[0] + vGrip4Locate;
}

//__additional grip needed for Section
//__declare a flag to set this point when newly created
int bNeedToCheckViewHeight;
if(bIsSectionCut)
{
	if(_PtG.length() < 6) 
	{
		_PtG.append(_PtG[3] + vY * (_PtG[0] - _PtG[1]).length());
		bNeedToCheckViewHeight = true;
		if(bInDebug) reportMessage("\nSet bNeedToCheckViewHeight = true");
	}
	
	Line lnViewLeft (_PtG[3], vY);
	_PtG[5] = lnViewLeft.closestPointTo(_PtG[5]);
	
	Vector3d vHeightGripCheck = _PtG[5] - _PtG[3];
	if(vHeightGripCheck.dotProduct(vY) < 0)
	{
		_PtG[5] = _PtG[3] - vHeightGripCheck;
	}
	
	//__Keep View direction and depth/extents grip orthogonal and on correct side
	Vector3d vSectionCutLine = _PtG[1] - _PtG[0];
	vSectionCutLine.normalize();
	Line lnOrtho(_PtG[0], vSectionCutLine);
	_PtG[1] = lnOrtho.closestPointTo(_PtG[1]);
	
	Vector3d vSectionViewDirection = vZ.crossProduct(vSectionCutLine);
	vSectionViewDirection.normalize();
	Line lnSectionViewDirection(_PtG[0], vSectionViewDirection);
	 _PtG[2] = lnSectionViewDirection.closestPointTo(_PtG[2]);
	Vector3d vGrip2 = _PtG[2] - _PtG[0]; 
	 double dSectionDepth = vGrip2.length();
	 if(vSectionViewDirection.dotProduct(vGrip2) < 0) _PtG[2] = _PtG[0] + vSectionViewDirection * dSectionDepth;
	
	if(_kNameLastChangedProp == "_PtG3")
	{
		Vector3d vGrip5Locate = _Map.getVector3d("vGrip5Locate");
		_PtG[5] = _PtG[3] + vGrip5Locate;
	}
}
else
{
	_PtG.setLength(5);
}


//__enforce grip locations
if(bIsRectanglePlan || bIsCirclePlan)
{
	Line lnX (_PtG[0], vX);
	Vector3d vXCheck = _PtG[1] - _PtG[0];
	if(vXCheck.dotProduct(vX) < 0) _PtG[1] = _PtG[0] - vXCheck;
	_PtG[1] = lnX.closestPointTo(_PtG[1]);
	
	Line lnY(_PtG[0], vY);
	Vector3d vYCheck = _PtG[2] - _PtG[0];
	if(vYCheck.dotProduct(vY) < 0) _PtG[2] = _PtG[0] - vYCheck;
	_PtG[2] = lnY.closestPointTo(_PtG[2]);
	
	//__keep grips from colliding
	double dMinDist = U(25);
	if((_PtG[1] - _PtG[0]).length() < dMinDist) _PtG[1] = _PtG[0] + vX * dMinDist;
	if((_PtG[2] - _PtG[0]).length() < dMinDist) _PtG[2] = _PtG[0] + vY * dMinDist;
	
	if(bIsCirclePlan)//__in this case enforce identical grip distances
	{
		int bLastGripSetWasX = _kNameLastChangedProp == "_PtG1";
		int iIndexToMaintain = bLastGripSetWasX ? 1 : 2;
		int iIndexToSet = bLastGripSetWasX ? 2 : 1;
		Vector3d vSetDirection = bLastGripSetWasX ? vY : vX;
		
		double dGripDist = (_PtG[iIndexToMaintain] - _PtG[0]).length();
		_PtG[iIndexToSet] = _PtG[0] + vSetDirection * dGripDist;
		
	}
}

if(bInDebug)
{

	for(int i=0;i<_PtG.length();i++)
	{
		dpTitleText.draw(i, _PtG[i], _XW, _YW, 0, 1);
	}
}

//########################## End Grip Management ###############################################
//######################################################################################	

//######################################################################################		
//########################## View Data and base geometry #############################################	

Map mpViewData;
ViewData vdAll[0];
Entity ent = _Entity[0];
int bWorkingFromViewGenerator;
CoordSys ms2ps, ps2ms;
double dViewportScale;
Entity entsShowSet[0];

//__if entity not present or deleted, 
if(! ent.bIsValid())
{
	eraseInstance();
	return;
}
else
{
	assignToGroups(ent);
}


setDependencyOnEntity(ent);
mpViewData = ent.subMap("mpViewData");//__ TODO revise to also get ViewData from Viewport 

if(mpViewData.length() ==0)//__either no submap on Multipage, or ent is not Multipage
{
	//__attempt to get info from ViewGenerator TSL
	TslInst tsl = (TslInst)ent;
	mpViewData = tsl.map().getMap("mpTslViewData");
	bWorkingFromViewGenerator = true;
}

//__also support information from SD_ViewDataExporter
int bWorkingFromViewDataExporter;
if(mpViewData.length() == 0)
{ 
	mpViewData = ent.subMapX("mpShopdrawData");
	bWorkingFromViewGenerator = false;
	bWorkingFromViewDataExporter = true;
}

if(mpViewData.length() == 0)
{
	reportMessage("\n**" + T("|No View Data found|") +"**");
	reportMessage("\n**" + T("|Check that sd_ViewPlaceholderUtilty or sd_ViewData Exporter is present in Layout block|")+"**");	
	
	if( bInDebug) 
	{
		_Pt0 = ent.coordSys().ptOrg();
		Display dpDB(2);
		PLine plHandle ;
		plHandle.createCircle( _Pt0, _ZW, U(33, "mm") ) ;
		dpDB.draw( plHandle ) ;
		dpDB.color( 3 ) ;
		plHandle.createCircle( _Pt0, _ZW, U(44, "mm") ) ;
		dpDB.draw( plHandle ) ;		
	}
	else
	{
		reportMessage("\n"+ scriptName() + ": "+T("|Tool will be deleted.|"));
		eraseInstance();
	}
	return;
}



CoordSys csMultiPage = ent.coordSys();

Point3d ptViewDefine = _PtG[0];ptViewDefine.vis(1);
Point3d ptViewLimit = _PtG[1];ptViewLimit.vis(1);
Point3d ptViewDepthLimit = _PtG[2];
Point3d ptDrawLocation = _PtG[3];

Vector3d vDefine = ptViewLimit - ptViewDefine;
vDefine.normalize();
Vector3d vSectionViewDirection = vZ.crossProduct(vDefine);
vDefine.vis(_PtG[0], 3);
vSectionViewDirection.vis(_PtG[0], 4);

double dViewWidth = (_PtG[1] - _PtG[0]).length();
double dViewDepth = (_PtG[2] - _PtG[0]).length();
double dTargetWidth = dViewWidth * pdScale;
double dTargetHeight = dViewDepth * pdScale;
double dSourceHeight = U(10000);

//########################## End View Data and base geometry ###############################################
//######################################################################################	



//######################################################################################		
//########################## Find View and create transforms #############################################	
	
//__Need to set ms2ps, ps2ms, dViewportScale, and entsShowSet 
if(bWorkingFromViewGenerator)	
{
	dViewportScale = mpViewData.getDouble("dScale");
	
	Point3d ptSource = mpViewData.getPoint3d("ptSource");
	Vector3d vSourceX = mpViewData.getVector3d("vSourceX");
	Vector3d vSourceY = mpViewData.getVector3d("vSourceY");
	Vector3d vSourceZ = mpViewData.getVector3d("vSourceZ");

	Point3d ptTarget = mpViewData.getPoint3d("ptTarget");
	Vector3d vTargetX = mpViewData.getVector3d("vTargetX");
	Vector3d vTargetY = mpViewData.getVector3d("vTargetY");
	Vector3d vTargetZ = mpViewData.getVector3d("vTargetZ");

	
	ms2ps.setToAlignCoordSys(ptSource, vSourceX, vSourceY, vSourceZ, ptTarget, vTargetX*dViewportScale, vTargetY*dViewportScale, vTargetZ*dViewportScale);
	ps2ms = ms2ps;//.setToAlignCoordSys(ptTarget, vTargetX/dViewportScale, vTargetY/dViewportScale, vTargetZ/dViewportScale, ptSource, vSourceX, vSourceY, vSourceZ);
	ps2ms.invert();
	
	entsShowSet = mpViewData.getEntityArray("entsShowSet", "", "entsShowSet");
}
else
{ 
	//__currently 2 types of stored ViewData format have been released in the wild
	vdAll = ViewData().convertFromSubMap( mpViewData, "\\" + _kViewDataSets,2);
	if(vdAll.length() == 0 ) vdAll = ViewData().convertFromSubMap( mpViewData, _kViewDataSets,2);
	if(vdAll.length() == 0)
	{
		Map mpContainer;
		mpContainer.setMap("mpViewData", mpViewData);
		vdAll = ViewData().convertFromSubMap(mpContainer, "mpViewData", 2);
	}
	
	//__if this is still not resolved there's nothing more to do
	if(vdAll.length() == 0 && ! bWorkingFromViewGenerator)
	{
		dpBorder.textHeight(U(50, "mm"));
		dpBorder.draw("No ViewData Found!!", _Pt0, vX, vY, 0, 0);
		return;
	}
	
	//__find correct View to work with
	for(int i=0;i<vdAll.length();i++)
	{
		ViewData vd = vdAll[i];//__ appended to ppViewBorders in same order as vdAll
		
		CoordSys csViewPS = vd.coordSysPS();
		double dViewH =	vd.heightPS();
		double dViewW = vd.widthPS();
		
		//__View might be rotated, if so switch values
		//___Can only support 90 increments for rotation
		if(csViewPS.vecY().isPerpendicularTo(vY))
		{
			double dTemp = dViewH;
			dViewH = dViewW;
			dViewW = dTemp;
		}
		
		Point3d ptViewCen = vd.ptCenPS();
		Point3d ptLL = ptViewCen - vY * dViewH/2 - vX * dViewW/2;
		Point3d ptTR = ptViewCen + vY * dViewH/2 + vX * dViewW/2;
		PLine plView;
		
		//__need to transform this to final MS location 
		plView.createRectangle(LineSeg(ptLL, ptTR), vX, vY);
		if(! bWorkingFromViewDataExporter) plView.transformBy(csMultiPage);
		plView.projectPointsToPlane(pnWorld, vZ);
		plView.vis(4);
		
		PlaneProfile ppView(plView);
		
	// test if this view is relevant for the section line	
		LineSeg segs[] = ppView.splitSegments(LineSeg(ptViewDefine, ptViewLimit), true);
		if(segs.length()>0)
		{
			ms2ps = vd.coordSys();
			//__also need transform to MP location
			ms2ps.transformBy(csMultiPage);
			ps2ms = ms2ps;
			ps2ms.invert();
			dViewportScale = vd.dScale();		
			
			//__will need realBody of showing entities for all detail views
			entsShowSet = vd.showSetEntities();
			break;
		}
	}
}

Body bdCombinedEntities, bdIndividualEntities[0];
for(int k=0;k<entsShowSet.length();k++)
{
	Entity ent = entsShowSet[k];
	Body bd = ent.realBody();
	bd.transformBy(ms2ps);//__move body now to cut down on Linwork transformations	
	bd.vis(k);
	Body bdTest = bdCombinedEntities;
	if(bdTest.addPart(bd))
	{				
		bdCombinedEntities.addPart(bd);			
		bdIndividualEntities.append(bd);
	}
}	

if(bUseFlippedReverseView)//__need to adjust body
{
	CoordSys csAdjust;
	Point3d ptBmCen = bdCombinedEntities.ptCen();
	csAdjust.setToRotation(90, _XW, ptBmCen);
	bdCombinedEntities.transformBy(csAdjust);
	
	for(int n=0;n<bdIndividualEntities.length();n++)
	{
		Body bd = bdIndividualEntities[n];
		ptBmCen = bd.ptCen();
		csAdjust.setToRotation(90, _XW, ptBmCen);
		bdIndividualEntities[n].transformBy(csAdjust);
	}
}

double dFinalScale = 1;
if (dViewportScale > 0)dFinalScale = dViewportScale * pdScale;

//########################## Find View and create transforms ###############################################
//######################################################################################	
			
//######################################################################################		
//########################## Generate and draw graphics #############################################	

//__define each of these later in condition specific sections
PLine plViewBorder(vZ), plViewDefine(vZ);
CoordSys csView, csMoveToView;
Plane pnViewSource;

//__buckets to be populated in condition specific sections
PlaneProfile ppCut;
PLine plCut[0];
LineSeg lsVisible[0], lsHidden[0];
//bdCombinedEntities.vis(1);

//__default constrcuction is Section
Body bdViewVolume(ptViewDefine, vDefine, vSectionViewDirection, vZ, dViewWidth, dViewDepth, U(10000), 1, 1, 1 );
if(bIsRectanglePlan) bdViewVolume = Body(ptViewDefine, vDefine, vSectionViewDirection, vZ, dViewWidth, dViewDepth, U(10000), 1, 1, 1);
if(bIsCirclePlan) bdViewVolume = Body(ptViewDefine-vZ*U(1000), ptViewDefine + vZ * U(10000), dViewWidth);
//bdViewVolume.vis(3);

//__first remove non-intersecting bodies from set
Body bdsRelevant[0];
for(int i=0;i<bdIndividualEntities.length();i++)
{
	Body bd = bdIndividualEntities[i];
	if(bd.hasIntersection(bdViewVolume))//__this body is relevant to detail, trim and record 
	{
		if(! bIsSectionCut)//__section cut needs different body cuts
		{
			bd.intersectWith(bdViewVolume);
		}
		bdsRelevant.append(bd);
	}
}
bdIndividualEntities = bdsRelevant;



if(bIsSectionCut) 
{
	if(bNeedToCheckViewHeight)//__section is newly activated, set _PtG[5] to extents of linework
	{
		Body bdTest = bdCombinedEntities;
		//bdTest.intersectWith(bdViewVolume);
		double dMinHeight = bdTest.lengthInDirection(vZ) * pdScale + 2 * pdBorderPadding;
		if(bInDebug) reportMessage("\nFound dMinHeight = " + dMinHeight);
		_PtG[5] = _PtG[3] + vY * dMinHeight;
	}
	//__resest section height according to view TopLeft grip
	dTargetHeight = (_PtG[5] - _PtG[3]).length();
	dTargetWidth = (_PtG[1] - _PtG[0]).length()*pdScale;
	
	double dScaledBorder = pdBorderPadding/pdScale;
	//__construct transform to View	
	csMoveToView.setToAlignCoordSys(ptViewDefine, vDefine, vZ, -vSectionViewDirection, 
		ptDrawLocation, vX*pdScale, vY*pdScale, vZ*pdScale);
		
	//__plane to project all linewok to
	pnViewSource = Plane(ptViewDefine, vSectionViewDirection);

	//__will do all section/elevation linework here
	//__move trimmed body up to Z=0;
	Line lnBaseFinder(bdCombinedEntities.ptCen(), vZ);
	Point3d ptsBottomTop[] = bdCombinedEntities.intersectPoints(lnBaseFinder);
	
	if(ptsBottomTop.length() > 0)
	{ 
		Vector3d vMoveUp = vZ * (abs(ptsBottomTop[0].Z()) + dScaledBorder - pdVerticalOffset);
		bdCombinedEntities.transformBy(vMoveUp);
		for(int i=0;i<bdIndividualEntities.length();i++)
		{
			bdIndividualEntities[i].transformBy(vMoveUp);
		}
		dSourceHeight = (ptsBottomTop[0] - ptsBottomTop[ptsBottomTop.length()-1]).length();
	}
	
	//__first trim body to view area
	Cut ctAllCuts[0];
	Cut ctBase(ptViewDefine + vZ * dScaledBorder, -vZ);
	ctAllCuts.append(ctAllCuts);
	bdCombinedEntities.addTool(ctBase);
	
	Cut ct1(ptViewDefine, - vDefine);
	ctAllCuts.append(ct1);
	bdCombinedEntities.addTool(ct1);
	
	Cut ct2(ptViewLimit, vDefine);
	ctAllCuts.append(ct2);
	bdCombinedEntities.addTool(ct2);
	
	Cut ct3(ptViewDepthLimit, vSectionViewDirection);
	ctAllCuts.append(ct3);
	bdCombinedEntities.addTool(ct3);
	
	//__find appropriate height from height of view area
	double dViewHeight = (dTargetHeight - pdBorderPadding)/pdScale;
	Cut ctTop (ptViewDefine + vZ * dViewHeight, vZ);
	ctAllCuts.append(ctTop);
	bdCombinedEntities.addTool(ctTop);

	Plane pnSlice (ptViewLimit, vSectionViewDirection);
	
	ppCut = bdCombinedEntities.getSlice(pnSlice);
	ppCut.transformBy(csMoveToView);
	plCut.append(ppCut.allRings());
	
	//__next cut in preparation of visible and hidden linework
	Cut ctSectionCut(ptViewDefine, - vSectionViewDirection);
	bdCombinedEntities.addTool(ctSectionCut);
	
	if(bDoHighDetail)
	{
		plCut.setLength(0);
		
		for(int i=0;i<bdIndividualEntities.length();i++)
		{
			Body bd = bdIndividualEntities[i];
			for(int k=0;k<ctAllCuts.length();k++)
			{
				bd.addTool(ctAllCuts[k]);
			}
			PlaneProfile pp = bd.getSlice(pnSlice);
			ppCut.transformBy(csMoveToView);
			plCut.append(pp.allRings());
			
			//__next cut at cut line in preparation for gathering visible and hidden linework
			bd.addTool(ctSectionCut);
			//__re-set body in the array
			bdIndividualEntities[i] = bd;
		}
	}
	
	//__reset defining CoordSyses to proper settinsg for  Visible and Hidden collections
	csView = CoordSys(ptViewDefine - vSectionViewDirection * U(10), vDefine, vZ, -vSectionViewDirection);
	csMoveToView.setToAlignCoordSys(ptViewDefine, vDefine, vZ, vSectionViewDirection,
		ptDrawLocation, vX*pdScale, vY*pdScale, vZ*pdScale);
	
	Point3d ptArrowTipLimit = ptViewLimit + vSectionViewDirection*dViewDepth;
	Point3d ptArrowTipDefine = ptViewDefine + vSectionViewDirection * dViewDepth;
	plViewDefine.addVertex(ptArrowTipLimit);
	plViewDefine.addVertex(ptArrowTipLimit - vDefine*pdArrowH - vSectionViewDirection * pdArrowL );
	plViewDefine.addVertex(ptArrowTipLimit);
	plViewDefine.addVertex(ptArrowTipLimit + vDefine*pdArrowH - vSectionViewDirection * pdArrowL );
	plViewDefine.addVertex(ptArrowTipLimit);
	plViewDefine.addVertex(ptViewLimit);
	plViewDefine.addVertex(ptViewDefine);
	plViewDefine.addVertex(ptArrowTipDefine);
	plViewDefine.addVertex(ptArrowTipDefine - vDefine * pdArrowH - vSectionViewDirection * pdArrowL);
	plViewDefine.addVertex(ptArrowTipDefine);
	plViewDefine.addVertex(ptArrowTipDefine + vDefine * pdArrowH - vSectionViewDirection * pdArrowL);
	
	LineSeg lsViewDiagonal (ptDrawLocation, ptDrawLocation + vX * dTargetWidth + vY * dTargetHeight);
	plViewBorder.createRectangle(lsViewDiagonal, vX, vY);
	
}
else//__when not doing section, trim bdCombinedEntities to view area, bdIndividualEntities already handled
{
bdCombinedEntities.vis(1);
	bdCombinedEntities.intersectWith(bdViewVolume);

	Point3d ptHideDisplayView = ptViewDefine;
	double dBodyHeight = bdCombinedEntities.lengthInDirection(vZ);
	ptHideDisplayView.transformBy(vZ * dBodyHeight * 1.2);
	csView = CoordSys(ptViewDefine, vX, vY, vZ);		
	csMoveToView.setToAlignCoordSys(ptViewDefine, vX, vY, vZ , ptDrawLocation, vX*pdScale, vY*pdScale, vZ*pdScale);
	
	pnViewSource = pnWorld;
	if(bIsRectanglePlan)
	{	
		LineSeg lsSourceDiagonal(ptViewLimit, ptViewDepthLimit);
		LineSeg lsViewDiagonal(ptDrawLocation, ptDrawLocation + vX * dTargetWidth + vY * dTargetHeight);
		plViewDefine.createRectangle(lsSourceDiagonal, vX, vY);		
		plViewBorder.createRectangle(lsViewDiagonal, vX, vY);
	}
	
	if(bIsCirclePlan)
	{
		plViewDefine.createCircle(ptViewDefine, vZ, dViewWidth);
		plViewBorder.createCircle(ptDrawLocation, vZ, dTargetWidth);
	}
}
PlaneProfile ppBorder (plViewBorder);
//ppBorder.shrink(- pdBorderPadding);
dpBorder.draw(ppBorder);

dpCutline.draw(plViewDefine);
bdCombinedEntities.vis(4);

if(bDrawConnector)
{
	Point3d ptSourceConnector, ptTargetConnector, ptSourceCenter, ptTargetCenter;
	Point3d ptsViewDefine[] = plViewDefine.vertexPoints(true);
	ptSourceCenter.setToAverage(ptsViewDefine);
	Point3d ptsViewBorder[] = plViewBorder.vertexPoints(true);
	ptTargetCenter.setToAverage(ptsViewBorder);
	ptSourceConnector = plViewDefine.closestPointTo(ptTargetCenter);
	ptTargetConnector = plViewBorder.closestPointTo(ptSourceCenter);

	PLine plConnector(ptTargetConnector, ptSourceConnector);
	dpBorder.draw(plConnector);
}


if(bDoHighDetail) 
{
	for(int i=0;i<bdIndividualEntities.length();i++)
	{
		LineSeg ls[] = bdIndividualEntities[i].hideDisplay(csView, false, false, false);
		lsVisible.append(ls);
	}
}
else
{
	lsVisible = bdCombinedEntities.hideDisplay(csView, false, false, false);
}
lsVisible = pnViewSource.projectLineSegs(lsVisible);

lsHidden = bdCombinedEntities.hideDisplay(csView, true, true, true);
lsHidden = pnViewSource.projectLineSegs(lsHidden);

for(int i=0;i<lsHidden.length();i++)
{
	LineSeg ls = lsHidden[i];
	ls.transformBy(csMoveToView);
	dpHidden.draw(ls);
}

for(int i=0;i<lsVisible.length();i++)
{
	LineSeg ls = lsVisible[i];
	ls.transformBy(csMoveToView);
	//__first check that these don't overlap Cut Line (if present)	
	int iIsOverlapping = false;
	for(int k=0;k<plCut.length();k++)
	{
		int iCheckStart = plCut[k].isOn(ls.ptStart());
		int iCheckEnd = plCut[k].isOn(ls.ptEnd());
		if(iCheckStart == true && iCheckEnd == true) 
		{
			iIsOverlapping = true;
			break;
		}
	}
	
	if(iIsOverlapping) continue;	
	dpVisible.draw(ls);
}

// th 0.65: in section mode this was drawing the section in the section plane but not in its projection
//for(int i=0;i<plCut.length();i++)//__these were already transformed when generated
//{
//	PLine pl = plCut[i];
//	dpCutline.draw(pl);
//}

//__draw tag @ detail
dpTag.draw(psDetailTag, _PtG[4], vX, vY, 1, 1);

//build title text
String stTitle = psDetailTag + "-" + psTitle;
Point3d ptTitle = _PtG[3] - vY * (pdTitleHeight * 1.5 + pdBorderPadding);
if(bIsCirclePlan) 
{
	ptTitle.transformBy(-vY * dTargetHeight);
	ptTitle.transformBy(-vX * dTargetWidth/2);
}
dpTitleText.draw(stTitle, ptTitle, vX, vY, 1, 1);
Point3d ptTitleLine = ptTitle - vY * .25 * pdTitleHeight;
Point3d ptTitleLineEnd = ptTitleLine + vX * dTargetWidth;
dpTitleText.draw(LineSeg(ptTitleLine, ptTitleLineEnd));
Point3d ptScaleText = ptTitleLine - vY * 1.25 * pdTitleHeight;
String stScaleText = "Scale = 1:" + dFinalScale;
dpTitleText.draw(stScaleText, ptScaleText, vX, vY, 1, 1);


//########################## End generate and  draw graphics ###############################################
//######################################################################################	
			


//######################################################################################		
//########################## Persist grip loactions for 1 & 2 #############################################	

Vector3d vGrip1Locate = _PtG[1] - _PtG[0];
Vector3d vGrip2Locate = _PtG[2] - _PtG[0];
Vector3d vGrip4Locate = _PtG[4] - _PtG[0];

_Map.setVector3d("vGrip1Locate", vGrip1Locate);
_Map.setVector3d("vGrip2Locate", vGrip2Locate);
_Map.setVector3d("vGrip4Locate", vGrip4Locate);
if(bIsSectionCut)
{
	Vector3d vGrip5Locate = _PtG[5] - _PtG[3];
	_Map.setVector3d("vGrip5Locate", vGrip5Locate);
}

#End
#BeginThumbnail












#End