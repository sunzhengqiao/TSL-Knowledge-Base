#Version 8
#BeginDescription

0.12 11/15/2024 Bugfix in projection of dimpoints cc
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 12
#KeyWords 
#BeginContents
/*
<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>

------For use on a static HSB Viewport in PS. Dimensions Wall vertices on 4 sides.

V0.1 _ January2009__`Initial inception
V0.5 _ 11MARCH2009__Bugfixes, added tolerance property, option to limit extension lines
V0.55_15June2009__Bugfix on sorting unique points (avoid redundant dimensions)
V0.60__16Oct2009__Added dimensioning for Far face of element
V0.65__22Oct2009__Bugfix on farside dimcolor
V0.75__20March2010_Revised to dimension per panel, and added Roof functionality
V0.80_7April2010_bugfix on point collection & sorting
                                                   cc@hsb-cad.com
<>--<>--<>--<>--<>--<>--<>--<>_____  craigcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>


//######################################################################################
//############################ Documentation #########################################

Primarily intended to be inserted by the user on PS Viewports

//########################## End Documentation #########################################
//######################################################################################
*/

//######################################################################################
//############################ basics and props #########################################

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(0));

String stBeamDimstyles[] = { T("|Do Not Dimension|"), T("|Combine with Near|")};

stBeamDimstyles.append(_DimStyles);

PropString psDimStyle(0,_DimStyles,"Dimension Style Near");
PropString psDimStyleFar(2,_DimStyles,"Dimension Style Far"); 
PropString psBeamDimstyle(17, stBeamDimstyles, "Beam Dimstyle", 1);
PropDouble pdChainSpace( 0, U(1) , "Dimension Chain Spacing" ) ;
PropDouble pdDimPointTol( 1, U(.125 ) , "Dimension point tolerance" ) ;
//PropDouble pdDimOffset( 2, U(12), "Dimension line offset" ) ;
pdDimPointTol.setFormat( _kLength ) ;
pdChainSpace.setFormat( _kLength ) ;
String stYN[] = { "Yes", "No" } ;
PropString psDimLimit( 1, stYN, "Limit Extension Lines" ) ;
String stDimWhat[] = { "Extremes", "All Points" };
PropString psDimWhat( 3, stDimWhat, "Detail Level" ) ;
String stMinMax[] = { "Overall", "Per Side" } ;
//PropString psMinMax( 4, stMinMax, "Min & Max points" ) ;
PropString psDrawTopDim( 4, stYN, "Display Top Dim" ) ;
PropString psDrawBotDim( 5, stYN, "Display Bottom Dim" ) ;
PropString psDrawLeftDim( 6, stYN, "Display Left Dim" ) ;
PropString psDrawRightDim( 7, stYN, "Display Right Dim" ) ;	
PropString psDimConnectedElements( 8, stYN, "Dim Connected Female Elements" ) ;	

int bDoLeftDim = psDrawLeftDim == stYN[0];
int bDoTopDim = psDrawTopDim == stYN[0];
int bDoRightDim = psDrawRightDim == stYN[0];
int bdoBottomDim = psDrawBotDim == stYN[0];
int bDoDimSides[] = { bDoTopDim, bDoRightDim, bdoBottomDim, bDoLeftDim};
int bLimitExtensionLines = psDimLimit == stYN[0];

PropString psUseGrips( 9, stYN, "Use Grips" ) ;	

PropDouble pdDimOffTop( 2, U(12 ) , "Top Dim Offset" ) ;
PropDouble pdDimOffBot( 3, U(12 ) , "Bottom Dim Offset" ) ;
PropDouble pdDimOffLeft( 4, U(12 ) , "Left Dim Offset" ) ;
PropDouble pdDimOffRight( 5, U(12 ) , "Right Dim Offset" ) ;

PropString psAddSipPtsLeft( 10, stYN, "Add Sip Points Left" ) ;
PropString psAddSipPtsRight( 11, stYN, "Add Sip Points Right" ) ;

int iDimTypes[] = { _kDimNone, _kDimDelta, _kDimCumm, _kDimBoth};
String stDimTypes[]={ "Delta", "Cummulative", "Both"};

PropString psDimTypeTop(12, stDimTypes, "Top Dim Type");
PropString psDimTypeBot(13, stDimTypes, "Bottom Dim Type");
PropString psDimTypeLeft(14, stDimTypes, "Left Dim Type");
PropString psDimTypeRight(15, stDimTypes, "Right Dim Type");

int iTopDimType = iDimTypes[stDimTypes.find(psDimTypeTop) +1];
int iBotDimType = iDimTypes[stDimTypes.find(psDimTypeBot) +1];
int iLeftDimType = iDimTypes[stDimTypes.find(psDimTypeLeft) +1];
int iRightDimType = iDimTypes[stDimTypes.find(psDimTypeRight) +1];
int iDimTypeSides[] = { iTopDimType, iRightDimType, iBotDimType, iLeftDimType};


PropDouble pdOffLowerPtLeft( 6, U(0 ) , "Offset Vertical Dim Left Start Point" ) ;
PropDouble pdOffLowerPtRight( 7, U(0 ) , "Offset Vertical Dim Right Start Point" ) ;
PropDouble pdAddBaseDim (8, U(0), "Additional Vertical Base Dimension");
pdAddBaseDim.setDescription("0 will result in no additional base dimension being added");
//PropDouble pdAddTopDim (10, U(0), "Additional Vertical Top Dimension");
//pdAddTopDim.setDescription("0 will result in no additional Top dimension being added");
PropDouble pdAddElevation (9, U(0), "Additional Elevation Value");

int bHaveAdditionalBaseDim = pdAddBaseDim > 0;
int bHaveElevationValue = pdAddElevation > 0;

Display dp( -1 ) ;
Display dpFar( -1 ) ;

PLine plHandle ;
plHandle.createCircle( _Pt0, _ZW, U(0) ) ;
dp.draw(plHandle) ;

if (_bOnInsert) 
{
		//_Pt0 = getPoint(T("Pick a point ")); // select point
	Viewport vp = getViewport(T("Select a viewport")); // select viewport
	_Viewport.append(vp);
	showDialogOnce() ;
	return;
}

if (_Viewport.length()==0)  // _Viewport array has some elements
{
	eraseInstance() ;
	return;
}
Viewport vp = _Viewport[0] ;


CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps

ViewData vd = vp.viewData() ;


Element el = vp.element();
ElementWall elW=(ElementWall)el;
Sip sips[] = el.sip() ;
Body bdSips[0] ;

int iDB2 = el.bIsValid() ;

//__Declare variables to be set via Wall or Roof routine later

Vector3d vX ;
Vector3d vY ;
Vector3d vZ ;	
CoordSys csEl ;
Point3d ptElOrg ;
double dScale = vp.dScale() ;
double dElW, dElH, dElL ;
PLine plElEnv ;
PlaneProfile ppElEnv ;
Point3d ptFront, ptBack, ptElCen ;
Point3d ptVPCen = vp.ptCenPS() ;

if( sips.length() == 0 )
{
	Display dpHandle(-1) ;
	dpHandle.textHeight(U(.2) ) ;
	dpHandle.draw( "Nothing to dimension (" + scriptName() + ")", ptVPCen, _XW, _YW, 0, 2 ) ;
	return;
}

csEl = el.coordSys() ;
vX = csEl.vecX() ;
vY = csEl.vecY() ;
vZ = csEl.vecZ() ;			
ptElOrg = csEl.ptOrg() ;		
dElW = sips[0].envelopeBody().lengthInDirection( vZ ) ;



ptElCen = ptElOrg - vZ * dElW / 2;
plElEnv = el.plEnvelope() ;	

PlaneProfile ppElBase (el.plOutlineWall() );	
LineSeg lsElBase = ppElBase.extentInDir( vZ ) ;
ptBack = lsElBase.ptStart();
ptFront = lsElBase.ptEnd();

ppElEnv = PlaneProfile( plElEnv ) ;
LineSeg lsElEnv = ppElEnv.extentInDir( vY ) ;
//__get height
dElH = abs( vY.dotProduct( lsElEnv.ptStart() - lsElEnv.ptEnd() ) ) ;
//__get length
lsElEnv = ppElEnv.extentInDir( vX ) ;
dElL = abs( vX.dotProduct(  lsElEnv.ptStart() - lsElEnv.ptEnd() ) ) ;

//__Get paperspace vectors for Dimline orientation
Vector3d vRtPS = _XW ;
Vector3d vUpPS = _YW ;
Vector3d vRtMS = vRtPS ;
vRtMS.transformBy( ps2ms ) ;
vRtMS.normalize() ;
Vector3d vUpMS = vUpPS ;
vUpMS.transformBy( ps2ms ) ;
vUpMS.normalize() ;		

Vector3d vToView = _ZW;
vToView.transformBy(ps2ms);
vToView.normalize();

dp.dimStyle(psDimStyle, 1/dScale);
dpFar.dimStyle(psDimStyleFar, 1/dScale);

//########################## End basics and props ############################################
//######################################################################################

//region Point  Commands
//######################################################################################		
//######################################################################################

Point3d ptsAddedNear[] = _Map.getPoint3dArray("ptsAddedNear");
Point3d ptsAddedFar[] = _Map.getPoint3dArray("ptsAddedFar");
Point3d ptsRemovedNear[] = _Map.getPoint3dArray("ptsRemovedNear");
Point3d ptsRemovedFar[] = _Map.getPoint3dArray("ptsRemovedFar");

String stResetAddedPointsCommand = T("|Reset Added Points|");
addRecalcTrigger(_kContextRoot, stResetAddedPointsCommand);
if(_kExecuteKey == stResetAddedPointsCommand)
{ 
	ptsAddedNear.setLength(0);
	ptsAddedFar.setLength(0);
}

String stResetRemovedPointsCommand = T("|ResetRemovedPoints|");
addRecalcTrigger(_kContextRoot, stResetRemovedPointsCommand);
if(_kExecuteKey == stResetRemovedPointsCommand)
{ 
	ptsRemovedNear.setLength(0);
	ptsRemovedFar.setLength(0);
}

Point3d[] SelectPoints(String message)
{ 
	Point3d ptsSelected[0];
	PrPoint prp(message);
	while(prp.go() == _kOk)
	{ 
		Point3d ptSelected = prp.value();
		ptSelected.transformBy(ps2ms);
		ptsSelected.append(ptSelected);		
	}
	
	return ptsSelected;
}


String stAddNearPointsCommand = T("|Add Near Points|");
addRecalcTrigger(_kContextRoot, stAddNearPointsCommand);
if(_kExecuteKey == stAddNearPointsCommand)
{ 
	ptsAddedNear.append(SelectPoints("Select points to add (Near Side)"));
}


String stRemoveNearPointsCommand = T("|Remove Near Points|");
addRecalcTrigger(_kContextRoot, stRemoveNearPointsCommand);
if(_kExecuteKey == stRemoveNearPointsCommand)
{ 
	ptsRemovedNear.append(SelectPoints("Select points to remove (Near Side)"));	
}


String stAddFarPointsCommand = T("|Add Far Points|");
addRecalcTrigger(_kContextRoot, stAddFarPointsCommand);
if(_kExecuteKey == stAddFarPointsCommand)
{ 
	ptsAddedFar.append(SelectPoints("Select points to add (Far side)"));
}


String stRemoveFarPointsCommand = T("|Remove Far Points|");
addRecalcTrigger(_kContextRoot, stRemoveFarPointsCommand);
if(_kExecuteKey == stRemoveFarPointsCommand)
{ 
	ptsRemovedFar.append(SelectPoints("Select points to remove (Far side)"));
}


_Map.setPoint3dArray("ptsAddedNear", ptsAddedNear);
_Map.setPoint3dArray("ptsAddedFar", ptsAddedFar);
_Map.setPoint3dArray("ptsRemovedNear", ptsRemovedNear);
_Map.setPoint3dArray("ptsRemovedFar", ptsRemovedFar);



//######################################################################################
//######################################################################################	
//endregion End Commands 			




//region  Gather raw point data
//######################################################################################		
//######################################################################################	

Point3d ptsWallRefs[] = { ptBack, ptFront};
Line lnSortWallRefs (ptBack, vToView);
ptsWallRefs = lnSortWallRefs.orderPoints(ptsWallRefs);

Plane pnFront (ptsWallRefs[1], vToView);
Plane pnBack (ptsWallRefs[0], vToView) ;		
Plane pnElCen (ptElCen, vToView) ;		

	
//__Gather vertices from Sips
Point3d ptsAllNear[0], ptsAllFar[0] ;
Point3d ptsAllNearEx[0], ptsAllFarEx[0] ;
Point3d ptsAll[0] ;

//__append added points
ptsAllNear.append(ptsAddedNear);
ptsAllFar.append(ptsAddedFar);

//__not immediately clear if added points should go into extreme arrays
//ptsAllNearEx.append(ptsAddedNear);
//ptsAllFarEx.append(ptsAllFarEx);


for( int i=0; i<sips.length(); i++)
{
	Sip sp = sips[i];
	Body bd = sp.realBody( _XW, "hsbCAD Panel - Basic solid" ) ;
	PlaneProfile ppSipBack = bd.extractContactFaceInPlane( pnBack, U(.01) ) ;
	PlaneProfile ppSipFront = bd.extractContactFaceInPlane( pnFront, U(.01) ) ;
	
	setDependencyOnEntity(sp);//__experimental, may cause performance issues
	if (_Entity.find(sp) < 0) _Entity.append(sp);

	//__Collect Detail vertices
	PLine plBackAll[] = ppSipBack.allRings() ;
	PLine plFrontAll[] = ppSipFront.allRings() ;
	
	if(plBackAll.length() * plFrontAll.length() == 0)
	{
		Display dpHandle(-1) ;
		dpHandle.textHeight(U(.2) ) ;
		dpHandle.draw( "Problem with plContour (" + scriptName() + ")", ptVPCen, _XW, _YW, 0, 2 ) ;
		return;
	};
	
	PLine plBack = plBackAll[0] ;
	PLine plFront = plFrontAll[0] ;
	ptsAllFar.append( plBack.vertexPoints(true) ) ;
	ptsAllNear.append( plFront.vertexPoints( true) ) ;

	
	//__Collect Extreme points
	LineSeg lsLRBack = ppSipBack.extentInDir( vX ) ;
	LineSeg lsLRFront = ppSipFront.extentInDir( vX ) ;
	LineSeg lsUDBack = ppSipBack.extentInDir( vY ) ;
	LineSeg lsUDFront = ppSipFront.extentInDir( vY ) ;
	
	Line lnLeftBack( lsLRBack.ptStart(), vY ) ;
	Line lnRightBack( lsLRBack.ptEnd(), vY ) ;
	Line lnBottomBack( lsUDBack.ptStart(), vX ) ;
	Line lnTopBack( lsUDBack.ptEnd(), vX ) ;
	
	Line lnLeftFront( lsLRFront.ptStart(), vY ) ;
	Line lnRightFront( lsLRFront.ptEnd(), vY ) ;
	Line lnBottomFront( lsUDFront.ptStart(), vX ) ;
	Line lnTopFront( lsUDFront.ptEnd(), vX ) ;
	
	ptsAllNearEx.append(lsLRFront.ptEnd() ) ;
	ptsAllNearEx.append(lsLRFront.ptStart() ) ;
	ptsAllFarEx.append(lsLRBack.ptEnd() ) ;
	ptsAllFarEx.append(lsLRBack.ptStart() ) ;
	ptsAllNearEx.append(lsUDFront.ptEnd() ) ;
	ptsAllNearEx.append(lsUDFront.ptStart() ) ;
	ptsAllFarEx.append(lsUDBack.ptEnd() ) ;
	ptsAllFarEx.append(lsUDBack.ptStart() ) ;		
}

//__ensure all points are coplanar
ptsAllNear = pnElCen.projectPoints(  ptsAllNear) ;
ptsAllFar = pnElCen.projectPoints(ptsAllFar ) ;
ptsAllNearEx = pnElCen.projectPoints( ptsAllNearEx ) ;
ptsAllFarEx = pnElCen.projectPoints( ptsAllFarEx ) ;	
ptsRemovedFar = pnElCen.projectPoints(ptsRemovedFar);
ptsRemovedNear = pnElCen.projectPoints(ptsRemovedNear);
ptsAddedFar = pnElCen.projectPoints(ptsAddedFar);
ptsAddedNear = pnElCen.projectPoints(ptsAddedNear);

//Create a convexhull with all front or back points
PLine plFront;
plFront.createConvexHull(pnFront,ptsAllNear);	

Point3d arPtFrontCH [] = Line(csEl.ptOrg(),vY).orderPoints( plFront.vertexPoints(true));
Point3d arPtExtraLeft[0],arPtExtraRight[0];

for(int i=0;i<arPtFrontCH.length()-1;i++)
{
	Point3d ptLast = arPtFrontCH[arPtFrontCH.length()-1];
	Point3d pt = arPtFrontCH[i];
	
	if((pt-ptLast).dotProduct(vX) < U(0))arPtExtraLeft.append(pt);
	else arPtExtraRight.append(pt);
}


//######################################################################################
//######################################################################################	
//endregion End Gather raw point data 			





//region  Filter out opening points, duplicate points front/back
//######################################################################################		
//######################################################################################			



//__Gather openings
Opening opAll[] = el.opening() ;
PlaneProfile ppOps[0];
for ( int i=0; i<opAll.length(); i++)
{
	PLine pl = opAll[i].plShape() ;
	pl.projectPointsToPlane(pnElCen, vZ);
	PlaneProfile pp(pl);
	pp.shrink(-U(.125, "inch"));
	ppOps.append(pp);
}


Point3d ptsNoOpes[0];
for(int i=0; i<ptsAllNear.length(); i++)
{
	Point3d pt = ptsAllNear[i];
	int bNotInOpe = true;
	for(int k=0; k<ppOps.length(); k++)
	{
		PlaneProfile ppOp = ppOps[k];
		if(ppOp.pointInProfile(pt) == _kPointInProfile)
		{ 
			bNotInOpe = false;
			break;
		}
	}
	if (bNotInOpe) ptsNoOpes.append(pt);
}
ptsAllNear = ptsNoOpes;
ptsAllNear.append(ptsAddedNear);

ptsNoOpes.setLength(0);
for(int i=0; i<ptsAllFar.length(); i++)
{
	Point3d pt = ptsAllFar[i];
	int bNotInOpe = true;
	for(int k=0; k<ppOps.length(); k++)
	{
		PlaneProfile ppOp = ppOps[k];
		if(ppOp.pointInProfile(pt) == _kPointInProfile)
		{ 
			bNotInOpe = false;
			break;
		}
	}
	if (bNotInOpe) ptsNoOpes.append(pt);
}
ptsAllFar = ptsNoOpes;
ptsAllFar.append(ptsAddedFar);


//__'Extremes' option maintained for legacy compatibility, not sure it's used
Point3d ptsDim[0], ptsDimFar[0] ;
if ( psDimWhat == "Extremes" ) 
{
	ptsDim = ptsAllNearEx ;
	ptsDimFar = ptsAllFarEx ;
}
else
{
	ptsDim = ptsAllNear ;
	ptsDimFar = ptsAllFar ;
}

ptsAll.append(ptsDim);
ptsAll.append(ptsDimFar);

//######################################################################################
//######################################################################################	
//endregion End Filter out opening points, duplicate points front/back 	



//region  handle connected elementa
//######################################################################################		
//######################################################################################	

//__Gather connected for walls only
Point3d arPtWallConnections[0];

if(elW.bIsValid() && psDimConnectedElements == stYN[0])
{
	Element arEl[]=elW.getConnectedElements();
	
	Element elM[0],elF[0],elA[0];
	Point3d arPTF[0],arPTM[0];
	
	Point3d ptS=elW.ptStartOutline();
	Point3d ptE=elW.ptEndOutline();
	
	
	for(int i=0;i<arEl.length();i++)
	{
		ElementWall elWi=(ElementWall)arEl[i];
		if(!elWi.bIsValid())  continue;
		
		double dTest=el.vecX().dotProduct(ptS-elWi.ptStartOutline()) * el.vecX().dotProduct(ptE-elWi.ptStartOutline());
		
		if(elW.vecX().isParallelTo(elWi.vecX()));//do nothing for now
		else if(!arEl[i].vecX().isPerpendicularTo(el.vecX())) elA.append(arEl[i]);
		else if(dTest<0)
		{
			elM.append(arEl[i]);
			arPTM.append(elWi.ptStartOutline());
		}
		else
		{
			elF.append(arEl[i]);
			arPTF.append(elWi.ptStartOutline());
		}
	}
	
	//__For now, only collect points of the female connecitons
	for(int i=0;i<elF.length();i++)
	{
		arPtWallConnections.append(elF[i].plOutlineWall().vertexPoints(TRUE) );
	}
	
	//project
	arPtWallConnections = Line( ptElOrg, vRtMS ).projectPoints( arPtWallConnections );
}

//######################################################################################
//######################################################################################	
//endregion End handle connected elements





//region  Determine geometric min/max
//######################################################################################		
//######################################################################################	

//___X & Y generally refer to PS _XW & _YW directions
Point3d ptMinY, ptMaxY, ptMinX, ptMaxX ;
Point3d ptMinYNear, ptMaxYNear, ptMinXNear, ptMaxXNear ;
Point3d ptMinYFar, ptMaxYFar, ptMinXFar, ptMaxXFar ;
ptElOrg = pnElCen.closestPointTo( ptElOrg ) ;
Line lnY ( ptElOrg,vUpMS ) ;
Line lnX ( ptElOrg, vRtMS ) ;
Point3d ptsToOrderNear[0], ptsToOrderFar[0], ptsToOrderAll[0] ;
ptsToOrderNear = ptsDim ;
ptsToOrderFar = ptsDimFar ;
ptsToOrderAll = ptsDim ;
ptsToOrderAll.append( ptsDimFar ) ;

Point3d ptsOrderedYNear[] = lnY.orderPoints( ptsToOrderNear ) ;
ptMinYNear = ptsOrderedYNear[0] ;
ptMaxYNear = ptsOrderedYNear[ ptsOrderedYNear.length() - 1 ] ;
Point3d ptsOrderedXNear[] = lnX.orderPoints( ptsToOrderNear ) ;
ptMinXNear = ptsOrderedXNear[0] ;
ptMaxXNear= ptsOrderedXNear[ ptsOrderedXNear.length() - 1 ] ; 

//__only add to Far set if it is non-empty
int bHaveFarPoints = ptsDimFar.length() > 0;
if(bHaveFarPoints)
{
	Point3d ptsOrderedYFar[] = lnY.orderPoints( ptsToOrderFar ) ;
	ptMinYFar = ptsOrderedYFar[0] ;
	ptMaxYFar = ptsOrderedYFar[ ptsOrderedYFar.length() - 1 ] ;
	Point3d ptsOrderedXFar[] = lnX.orderPoints( ptsToOrderFar ) ;
	ptMinXFar = ptsOrderedXFar[0] ;
	ptMaxXFar = ptsOrderedXFar[ ptsOrderedXFar.length() - 1 ] ;
}


//__determine absolute limts from Near and far sides
Point3d ptsOrderedYAll[] = lnY.orderPoints( ptsToOrderAll ) ;
ptMinY = ptsOrderedYAll[0] ;
ptMaxY = ptsOrderedYAll[ ptsOrderedYAll.length() - 1 ] ;
Point3d ptsOrderedXAll[] = lnX.orderPoints( ptsToOrderAll ) ;
ptMinX = ptsOrderedXAll[0] ;
ptMaxX= ptsOrderedXAll[ ptsOrderedXAll.length() - 1 ] ; 

Point3d ptMinYPS = ptMinY ;
Point3d ptMaxYPS = ptMaxY ;
Point3d ptMinXPS = ptMinX ;
Point3d ptMaxXPS = ptMaxX ;
ptMinYPS.transformBy( ms2ps ) ;
ptMaxYPS.transformBy( ms2ps ) ;
ptMinXPS.transformBy( ms2ps ) ;
ptMaxXPS.transformBy( ms2ps ) ;	

ptMinYPS.vis( 3 )  ;
ptMaxYPS.vis( 3 ) ;
ptMinXPS.vis( 3 ) ;
ptMaxXPS.vis( 3 ) ;


Line lnLeftSide( ptMinXNear, vUpMS ) ;
Line lnRightSide( ptMaxXNear, vUpMS ) ;
Line lnTop ( ptMaxYNear, vRtMS ) ;
Line lnBase ( ptMinYNear, vRtMS )  ;
Line lnSides[] = { lnTop, lnRightSide, lnBase, lnLeftSide};

Line lnLeftSideFar( ptMinXFar, vUpMS ) ;
Line lnRightSideFar( ptMaxXFar, vUpMS ) ;
Line lnTopFar ( ptMaxYFar, vRtMS ) ;
Line lnBaseFar ( ptMinYFar, vRtMS )  ;

//__Determine bounding corner points for each side, and overall
Point3d ptTopLftFar = lnLeftSideFar.closestPointTo( ptMaxYFar ) ;
Point3d ptTopRtFar = lnRightSideFar.closestPointTo( ptMaxYFar ) ;
Point3d ptBottomLftFar = lnLeftSideFar.closestPointTo( ptMinYFar ) ;
Point3d ptBottomRtFar = lnRightSideFar.closestPointTo( ptMinYFar ) ;

Point3d ptTopLftNear = lnLeftSide.closestPointTo( ptMaxYNear ) ;
Point3d ptTopRtNear = lnRightSide.closestPointTo( ptMaxYNear ) ;
Point3d ptBottomLftNear = lnLeftSide.closestPointTo( ptMinYNear ) ;
Point3d ptBottomRtNear = lnRightSide.closestPointTo( ptMinYNear ) ;

Point3d ptTopLft = lnLeftSide.closestPointTo( ptMaxY ) ;
Point3d ptTopRt = lnRightSide.closestPointTo( ptMaxY ) ;
Point3d ptBottomLft = lnLeftSide.closestPointTo( ptMinY ) ;
Point3d ptBottomRt = lnRightSide.closestPointTo( ptMinY ) ;

LineSeg lsDiag ( ptTopRt, ptBottomLft ) ;	
Point3d ptCen = lsDiag.ptMid() ;
Point3d ptCenPS = ptCen ;
ptCenPS.transformBy( ms2ps ) ;


Point3d ptsDimStart[] = { ptTopLft, ptBottomRt, ptBottomLft, ptBottomLft};
Point3d ptsDimEnd[] = { ptTopRt, ptTopRt, ptBottomRt, ptTopLft};
//######################################################################################
//######################################################################################	
//endregion End Determine geometric min/max 			


//region  Sort  points to sides
//######################################################################################		
//######################################################################################	
		
Point3d ptsRight[0] ;
Point3d ptsUp[0] ;
Point3d ptsLeft[0] ;
Point3d ptsDown[0] ;	
//__Loop through points and sort
for ( int i=0; i<ptsDim.length(); i++)
{
	Point3d pt = ptsDim[i] ;
	Vector3d vTestLR = pt - ptCen ;
	Vector3d vTestUD = pt - ptCen ;
	double dTestLR = vTestLR.dotProduct( vRtMS ) ;
	double dTestUD = vTestUD.dotProduct( vUpMS ) ;
	
	if ( dTestLR > 0 ) ptsRight.append( pt ) ; else ptsLeft.append( pt ) ;
	if ( dTestUD > 0 ) ptsUp.append( pt ) ; else ptsDown.append( pt ) ;
			
}

if(psAddSipPtsLeft == stYN[0])ptsLeft.append(arPtExtraLeft);//__WTF is this doing?!
if(psAddSipPtsRight == stYN[0])ptsRight.append(arPtExtraRight);


//__Make sure near sets have min & max
ptsUp.append( ptTopLftNear) ;
ptsUp.append( ptTopRtNear ) ;
ptsLeft.append( ptBottomLftNear ) ;
ptsLeft.append( ptTopLftNear) ;	
ptsRight.append( ptTopRtNear ) ;
ptsRight.append( ptBottomRtNear ) ;
ptsDown.append( ptBottomLftNear ) ;
ptsDown.append( ptBottomRtNear ) ;	

//__Project and order points so to have only unique dims
ptsRight =lnRightSide.projectPoints( ptsRight ) ;
ptsUp = lnTop.projectPoints( ptsUp ) ;
ptsLeft = lnLeftSide.projectPoints( ptsLeft ) ;
ptsDown = lnBase.projectPoints( ptsDown ) ;

//__OrderPoints will remove duplicates
ptsRight = lnRightSide.orderPoints( ptsRight, pdDimPointTol ) ;
ptsUp = lnTop.orderPoints( ptsUp, pdDimPointTol ) ;
ptsLeft = lnLeftSide.orderPoints( ptsLeft, pdDimPointTol ) ;
ptsDown = lnBase.orderPoints( ptsDown, pdDimPointTol ) ;

//__Do sorting into sides for Far points
Point3d ptsRightFar[0] ;
Point3d ptsUpFar[0] ;
Point3d ptsLeftFar[0] ;
Point3d ptsDownFar[0] ;	
//__Loop through points and sort
for ( int i=0; i<ptsDimFar.length(); i++)
{
	Point3d pt = ptsDimFar[i] ;
	Vector3d vTestLR = pt - ptCen ;
	Vector3d vTestUD = pt - ptCen ;
	double dTestLR = vTestLR.dotProduct( vRtMS ) ;
	double dTestUD = vTestUD.dotProduct( vUpMS ) ;
	
	if ( dTestLR > 0 ) ptsRightFar.append( pt ) ; else ptsLeftFar.append( pt ) ;
	if ( dTestUD > 0 ) ptsUpFar.append( pt ) ; else ptsDownFar.append( pt ) ;				
}	

//__also project and filter out remove requests
String stSideKeys[] = { "Top", "Right", "Base", "Left", "FarTop", "FarRight", "FarBase", "FarLeft"};
Vector3d vSideDirs[] = { vRtMS, vUpMS, vRtMS, vUpMS, vRtMS, vUpMS, vRtMS, vUpMS};
Point3d ptsTopRemoveNear[0], ptsRightRemoveNear[0], ptsBaseRemoveNear[0], ptsLeftRemoveNear[0];
Point3d ptsTopRemoveFar[0], ptsRightRemoveFar[0], ptsBaseRemoveFar[0], ptsLeftRemoveFar[0];


for(int i=0; i<ptsRemovedNear.length(); i++)
{
	Point3d pt = ptsRemovedNear[i];
	Vector3d vTestLR = pt - ptCen ;
	Vector3d vTestUD = pt - ptCen ;
	double dTestLR = vTestLR.dotProduct( vRtMS ) ;
	double dTestUD = vTestUD.dotProduct( vUpMS ) ;
	
	if ( dTestLR > 0 ) ptsRightRemoveNear.append( pt ) ; else ptsLeftRemoveNear.append( pt ) ;
	if ( dTestUD > 0 ) ptsTopRemoveNear.append( pt ) ; else ptsBaseRemoveNear.append( pt ) ;
}

for(int i=0; i<ptsRemovedFar.length(); i++)
{
	Point3d pt = ptsRemovedFar[i];
	Vector3d vTestLR = pt - ptCen ;
	Vector3d vTestUD = pt - ptCen ;
	double dTestLR = vTestLR.dotProduct( vRtMS ) ;
	double dTestUD = vTestUD.dotProduct( vUpMS ) ;
	
	if ( dTestLR > 0 ) ptsRightRemoveFar.append( pt ) ; else ptsLeftRemoveFar.append( pt ) ;
	if ( dTestUD > 0 ) ptsTopRemoveFar.append( pt ) ; else ptsBaseRemoveFar.append( pt ) ;
}

if(ptsLeft.length() > 0)ptsLeft[0].transformBy(el.vecY()*pdOffLowerPtLeft);
if(ptsRight.length() > 0)ptsRight[0].transformBy(el.vecY()*pdOffLowerPtRight);


//__Need to project points to line, remove duplicates
ptsRightFar = lnRightSide.projectPoints( ptsRightFar ) ;
ptsUpFar = lnTop.projectPoints( ptsUpFar ) ;
ptsLeftFar = lnLeftSide.projectPoints( ptsLeftFar ) ;
ptsDownFar = lnBase.projectPoints( ptsDownFar ) ;

ptsRightFar = lnRightSide.orderPoints( ptsRightFar, pdDimPointTol ) ;
ptsUpFar = lnTop.orderPoints( ptsUpFar, pdDimPointTol ) ;
ptsLeftFar = lnLeftSide.orderPoints( ptsLeftFar, pdDimPointTol ) ;
ptsDownFar = lnBase.orderPoints( ptsDownFar, pdDimPointTol ) ;	

ptsTopRemoveNear = lnTop.projectPoints(ptsTopRemoveNear);
ptsTopRemoveNear = lnTop.orderPoints(ptsTopRemoveNear);
ptsRightRemoveNear = lnRightSide.projectPoints(ptsRightRemoveNear);
ptsRightRemoveNear = lnRightSide.orderPoints(ptsRightRemoveNear);
ptsBaseRemoveNear = lnBase.projectPoints(ptsBaseRemoveNear);
ptsBaseRemoveNear = lnBase.orderPoints(ptsBaseRemoveNear);
ptsLeftRemoveNear = lnLeftSide.projectPoints(ptsLeftRemoveNear);
ptsLeftRemoveNear = lnLeftSide.orderPoints(ptsLeftRemoveNear);

ptsTopRemoveFar = lnTop.projectPoints(ptsTopRemoveFar);
ptsTopRemoveFar = lnTop.orderPoints(ptsTopRemoveFar);
ptsRightRemoveFar = lnRightSide.projectPoints(ptsRightRemoveFar);
ptsRightRemoveFar = lnRightSide.orderPoints(ptsRightRemoveFar);
ptsBaseRemoveFar = lnBase.projectPoints(ptsBaseRemoveFar);
ptsBaseRemoveFar = lnBase.orderPoints(ptsBaseRemoveFar);
ptsLeftRemoveFar = lnLeftSide.projectPoints(ptsLeftRemoveFar);
ptsLeftRemoveFar = lnLeftSide.orderPoints(ptsLeftRemoveFar);

Map mpDimPoints, mpRemoveDimPoints;
mpDimPoints.setPoint3dArray(stSideKeys[0], ptsUp);
mpDimPoints.setPoint3dArray(stSideKeys[1], ptsRight);
mpDimPoints.setPoint3dArray(stSideKeys[2], ptsDown);
mpDimPoints.setPoint3dArray(stSideKeys[3], ptsLeft);
mpDimPoints.setPoint3dArray(stSideKeys[4], ptsUpFar);
mpDimPoints.setPoint3dArray(stSideKeys[5], ptsRightFar);
mpDimPoints.setPoint3dArray(stSideKeys[6], ptsDownFar);
mpDimPoints.setPoint3dArray(stSideKeys[7], ptsLeftFar);

mpRemoveDimPoints.setPoint3dArray(stSideKeys[0], ptsTopRemoveNear);
mpRemoveDimPoints.setPoint3dArray(stSideKeys[1], ptsRightRemoveNear);
mpRemoveDimPoints.setPoint3dArray(stSideKeys[2], ptsBaseRemoveNear);
mpRemoveDimPoints.setPoint3dArray(stSideKeys[3], ptsLeftRemoveNear);
mpRemoveDimPoints.setPoint3dArray(stSideKeys[4], ptsTopRemoveFar);
mpRemoveDimPoints.setPoint3dArray(stSideKeys[5], ptsRightRemoveFar);
mpRemoveDimPoints.setPoint3dArray(stSideKeys[6], ptsBaseRemoveFar);
mpRemoveDimPoints.setPoint3dArray(stSideKeys[7], ptsLeftRemoveFar);

String stNearPointKeys[] = { stSideKeys[0], stSideKeys[1], stSideKeys[2], stSideKeys[3]};
String stFarPointKeys[] = { stSideKeys[4], stSideKeys[5], stSideKeys[6], stSideKeys[7]};


//__Make sure dim set has Min & Max
if ( ptsRightFar.length() > 0 )
{
	ptsRightFar.append( ptTopRtFar ) ;
	ptsRightFar.append( ptBottomRtFar ) ;
}


//__Make sure dim set has Min & Max
if ( ptsLeftFar.length() > 0 )
{
	ptsLeftFar.append( ptTopLftFar ) ;
	ptsLeftFar.append( ptBottomLftFar ) ;
}


//__Make sure dim set has Min & Max
if ( ptsUpFar.length() > 0 )
{
	ptsUpFar.append( ptTopRtFar ) ;
	ptsUpFar.append( ptTopLftFar ) ;
}

//__Make sure dim set has Min & Max
if ( ptsDownFar.length() > 0 )
{
	ptsDownFar.append( ptBottomLftFar ) ;
	ptsDownFar.append( ptBottomRtFar ) ;
}



//__Order Points one more time in case adding Requested, Min, or Max introduced redundancy
ptsRightFar = lnRightSide.projectPoints( ptsRightFar ) ;
ptsUpFar = lnTop.projectPoints( ptsUpFar ) ;
ptsLeftFar = lnLeftSide.projectPoints( ptsLeftFar ) ;
ptsDownFar = lnBase.projectPoints( ptsDownFar ) ;

ptsRightFar = lnRightSide.orderPoints( ptsRightFar, pdDimPointTol ) ;
ptsUpFar = lnTop.orderPoints( ptsUpFar, pdDimPointTol ) ;
ptsLeftFar = lnLeftSide.orderPoints( ptsLeftFar, pdDimPointTol ) ;
ptsDownFar = lnBase.orderPoints( ptsDownFar, pdDimPointTol ) ;	

//__not sure what this is doing...29July2024 cc
if(ptsLeftFar.length() > 0)ptsLeftFar[0].transformBy(el.vecY()*pdOffLowerPtLeft);
if(ptsRightFar.length() > 0)ptsRightFar[0].transformBy(el.vecY()*pdOffLowerPtRight);


//####################### End  Filter through, sort and organize	################################## 
//#####################################################################################




//####################################################################################
//###############################Manage Grip Points  #####################################
//__Create grips if not yet present

Point3d arPt[4];
arPt[0] = ptMaxXPS + vRtPS * pdDimOffRight*dScale;
arPt[1] = ptMaxYPS + vUpPS * pdDimOffTop*dScale;
arPt[2] = ptMinXPS - vRtPS * pdDimOffLeft*dScale;
arPt[3] = ptMinYPS - vUpPS * pdDimOffBot*dScale;


if ( _PtG.length() < 4 )
{
	while ( _PtG.length() < 4 ) _PtG.append( _Pt0 ) ;
	
	double dOffset = pdChainSpace * 2 ;
	_PtG[0] = ptMaxXPS + vRtPS * dOffset ;
	_PtG[1] = ptMaxYPS + vUpPS * dOffset ;
	_PtG[2] = ptMinXPS - vRtPS * dOffset ;
	_PtG[3] = ptMinYPS - vUpPS * dOffset ;
	
}


//__Project grips to midlines, restrict to proper sides
ptCenPS.vis( 2 ) ;
Line lnXMid ( ptCenPS, vRtPS ) ;
Line lnYMid ( ptCenPS, vUpPS ) ;

_PtG[0] = lnXMid.closestPointTo( _PtG[0] ) ;
_PtG[1] = lnYMid.closestPointTo( _PtG[1] ) ;
_PtG[2] = lnXMid.closestPointTo( _PtG[2] ) ;
_PtG[3] = lnYMid.closestPointTo( _PtG[3] ) ;

if(psUseGrips == stYN[0])arPt=_PtG;

	
//__Get Model Space projection of PS grip points.
Point3d ptMSRt, ptMSLt, ptMSUp, ptMSDown ;

ptMSRt = arPt[0] ;
ptMSUp = arPt[1] ;
ptMSLt = arPt[2] ;
ptMSDown = arPt[3] ;
ptMSDown.transformBy( ps2ms ) ;
ptMSRt.transformBy( ps2ms ) ;
ptMSUp.transformBy( ps2ms ) ;
ptMSLt.transformBy( ps2ms ) ;

double dChainMS = pdChainSpace / dScale ;
DimLine dlRight( ptMSRt, vUpMS, -vRtMS ) ;
DimLine dlUp( ptMSUp, vRtMS, vUpMS ) ;
DimLine dlLeft( ptMSLt, vUpMS, -vRtMS ) ;
DimLine dlDown( ptMSDown, vRtMS, vUpMS ) ;
DimLine dlOARt( ptMSRt + 2*vRtMS*dChainMS, vUpMS, -vRtMS ) ;
DimLine dlOADn( ptMSDown - vUpMS * dChainMS, vRtMS, vUpMS ) ;

//__Dimlines for Far points
DimLine dlRightFar( ptMSRt - vRtMS * dChainMS, vUpMS, -vRtMS ) ;
DimLine dlUpFar( ptMSUp - vUpMS * dChainMS, vRtMS, vUpMS ) ;
DimLine dlLeftFar( ptMSLt + vRtMS * dChainMS, vUpMS, -vRtMS ) ;
DimLine dlDownFar( ptMSDown + vUpMS * dChainMS, vRtMS, vUpMS ) ;

//########################## End Manager Grips #########################################
//######################################################################################

//##########################################################################################
//###############################Create dimlines for each side #################################
 
DimLine dlsNear[] = { dlUp, dlRight, dlDown, dlLeft};
DimLine dlsFar[] = {dlUpFar, dlRightFar, dlDownFar, dlLeftFar};
Vector3d vecsDimPerp[] = { vUpMS, vRtMS, - vUpMS, - vRtMS };
Vector3d vReadDirs[] = { vUpMS, - vRtMS, vUpMS, - vRtMS};

//__removes points from ptsToFilter which are present in ptsRef
Point3d[] FilterPoints(Point3d ptsRef[], Point3d ptsToFilter[])
{ 
	Point3d ptsUnique[0];
	
	if (ptsRef.length() == 0 || ptsToFilter.length() == 0) return ptsToFilter;
	
	//__construct a reference line, exact location not relevant. Assuming all point arrays are ordered
	Point3d pntRef = ptsRef[0];
	int iRefCount = ptsRef.length();
	Vector3d vSortDir = ptsRef.last() - ptsRef.first();
	vSortDir.normalize();
	Line lnRef(pntRef, vSortDir);
	int iLastChecked = 0;
	
	for(int i=0; i<ptsToFilter.length(); i++)
	{
		Point3d ptCheck = ptsToFilter[i];
		int bFoundDuplicate = false;
		
		for(int k=iLastChecked; k<iRefCount; k++)
		{
			Point3d pt = ptsRef[k];
			double dDist = (pt - ptCheck).dotProduct(vSortDir);
			if(abs(dDist) < pdDimPointTol)
			{ 
				bFoundDuplicate = true;
				iLastChecked = i == 0 ? 0 : i - 1;
				break;
			}
			
			if(dDist > 0) //__since points are order we are done checking
			{ 
				iLastChecked = i == 0 ? 0 : i - 1;//__this is the last index that might be relevant to the next point				
				break;
			}	
		}
		
		if (bFoundDuplicate) continue;//__this point is duplicate, skip it
		
		ptsUnique.append(ptCheck);
	}
	
	return ptsUnique;
}

Point3d GetProjectedPoint(Point3d ptSource, Vector3d vProjection)
{ 
	Line lnProject(ptSource, vProjection);
	Point3d ptsClose[] = lnProject.filterClosePoints(ptsAll);
	ptsClose = lnProject.orderPoints(ptsClose);
	if (ptsClose.length() == 0) return ptSource;
	
	Point3d ptClose = ptsClose[0];
	return ptClose;
}

Point3d[] GetProjectedPoints(Point3d ptsSource[], Vector3d vProjection)
{ 
	Point3d ptsProjected[0];
	
	for(int i=0; i<ptsSource.length(); i++)
	{
		Point3d pt = ptsSource[i];
		pt = GetProjectedPoint(pt, vProjection);
		ptsProjected.append(pt);
	}
	
	return ptsProjected;
}

for (int i = 0; i < dlsNear.length(); i++)
{
	if ( ! bDoDimSides[i]) continue;
	
	DimLine dl = dlsNear[i];
	DimLine dlFar = dlsFar[i];
	Vector3d vDimPerp = vecsDimPerp[i];
	Vector3d vRead = vReadDirs[i];
	Line lnSide = lnSides[i];
	
	Point3d ptsNear[] = mpDimPoints.getPoint3dArray(stNearPointKeys[i]);
	Point3d ptsRemove[] = mpRemoveDimPoints.getPoint3dArray(stNearPointKeys[i]);
	
	Point3d ptsFar[] = mpDimPoints.getPoint3dArray(stFarPointKeys[i]);
	Point3d ptsFarRemove[] = mpRemoveDimPoints.getPoint3dArray(stFarPointKeys[i]);
	
	int bIsVerticalDim = i == 1 || i == 3;
	
	//Line lnNear(dl.ptOrg(), dl.vecX());
	//Line lnFar(dlFar.ptOrg(), dlFar.vecX());
	
	//__remove requested dimpoints
	ptsNear = FilterPoints(ptsRemove, ptsNear);
	
	if(bIsVerticalDim && bHaveAdditionalBaseDim)
	{ 
		ptsNear.insertAt(0, ptsNear[0] - vUpMS * pdAddBaseDim);
	}
	
	
	Point3d ptsNearDim[0];
	//__project to requested location
	if(bLimitExtensionLines)
	{ 
		ptsNearDim = lnSide.projectPoints(ptsNear);
	}
	else
	{ 
		Vector3d vProjected = - vDimPerp;
		ptsNearDim = GetProjectedPoints(ptsNear, - vDimPerp);
	}
	
	Dim dmNear(dl, ptsNearDim, "<>", "<>", iDimTypeSides[i]);//__this is default case
	
	//__if this is a vertical dimension, and an elevation value is present need to adjust dim values
	if(bIsVerticalDim && bHaveElevationValue)
	{ 
		Point3d ptsNone[0];
		Dim dmBlank (dl, ptsNone, "<>", "<>", iDimTypeSides[i]);
		Point3d ptDimRef = ptsNear[0];
		
		for(int k=0; k<ptsNearDim.length(); k++)
		{
			Point3d ptDim = ptsNearDim[k];
			double dDim = (ptDim - ptDimRef).dotProduct(vUpMS) + pdAddElevation;
			String stDim = String().formatUnit(dDim, psDimStyle);
			dmBlank.append(ptDim, "<>", stDim);
		}
		
		dmNear = dmBlank;		
	}
	
	dmNear.setReadDirection(vRead);
	dmNear.correctTextNormalForViewDirection(vToView);
	dmNear.transformBy(ms2ps);
	dp.draw(dmNear);
	
	//__far points should already be ordered. Filter them to get only unique
	ptsFar = FilterPoints(ptsNear, ptsFar);
	ptsFar = FilterPoints(ptsRemovedFar, ptsFar);
	
	if (ptsFar.length() == 0) continue;//__nothing to draw on far dims for this side
	
	//__since we have far dims, add back extremes as they have likely been filtered out
	ptsFar.insertAt(0, ptsDimStart[i]);
	ptsFar.append(ptsDimEnd[i]);
	
	Point3d ptsFarDim[0];//__this array will be projected according to extension line settings
	
	if(bLimitExtensionLines)
	{ 
		ptsFarDim = lnSide.projectPoints(ptsFar);
	}
	else
	{
		Vector3d vProjected = - vDimPerp;		
		ptsFarDim = GetProjectedPoints(ptsFar, - vDimPerp);
	}
	
	
	
	Dim dmFar(dlFar, ptsFarDim, "<>", "<>", iDimTypeSides[i]);
	dmFar.setReadDirection(vRead);
	dmFar.correctTextNormalForViewDirection(vToView);
	dmFar.transformBy(ms2ps);
	dpFar.draw(dmFar);
}




_Pt0 = _PtW ;

Display dpDB(2);
plHandle.createCircle( _Pt0, _ZW, U(33, "mm") ) ;
dpDB.draw( plHandle ) ;
dpDB.color( 3 ) ;
plHandle.createCircle( _Pt0, _ZW, U(44, "mm") ) ;
dpDB.draw( plHandle ) ;
//########################## End Create dimlines for each side #############################
//######################################################################################



















#End
#BeginThumbnail

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Bugfix in projection of dimpoints" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="11/15/2024 8:54:48 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End