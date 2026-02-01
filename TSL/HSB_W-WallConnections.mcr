#Version 8
#BeginDescription
Last modified by: Anno Sportel (support.nl@hsbcad.com)
15.05.2018  -  version 1.03
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
/// 
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.03" date="15.05.2018"></version>

/// <history>
/// AS - 1.00 - 06.03.2014	- Pilot version
/// AS - 1.01 - 01.03.2015	- Do vector comparison with a tolerance.Check width of intersecting body (FogBugzId 868).
/// AS - 1.02 - 08.02.2017	- Base connection profile on frame thickness of male element.
/// AS - 1.03 - 15.05.2018	- Add fallback for frame thickness for sip elements.
/// </history>

double dEps = Unit(0.01,"mm");

String arSArticle[0];			String arSDescription[0];
arSArticle.append("Fix90");	arSDescription.append("Wall connector 90mm wall");
arSArticle.append("Fix80");	arSDescription.append("Wall connector 80mm wall");
arSArticle.append("Fix70");	arSDescription.append("Wall connector 70mm wall");

PropString sSeperator01(0, "", T("|Drill pattern|"));
sSeperator01.setReadOnly(true);
PropDouble dOffsetFromBottom(0, U(50), "     "+T("|Offset from bottom|"));
PropDouble dOffsetFromTop(1, U(50), "     "+T("|Offset from top|"));
PropDouble dMaximumSpacing(2, U(300), "     "+T("|Maximum spacing|"));

PropString sSeperator02(1, "", T("|Drills|"));
sSeperator02.setReadOnly(true);
PropDouble dDrillDiameter(3, U(10), "     "+T("|Diameter|"));

PropString sArticle(2, arSArticle, "     "+T("|Fixing|"));
String sDescription = arSDescription[arSArticle.find(sArticle, 0)];


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_W-WallConnections");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);


if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	// show the dialog if no catalog in use
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 ){
		if( _kExecuteKey != "" )
			reportMessage("\n"+scriptName() + TN("|Catalog key| ") + _kExecuteKey + T(" |not found|!"));
		showDialog();
	}
	else{
		setPropValuesFromCatalog(_kExecuteKey);
	}
	
	Element arSelectedElement[0];
	PrEntity ssEl(T("Select a set of elements"), ElementWall());
	if( ssEl.go() ){
		arSelectedElement.append(ssEl.elementSet());
	}
	
	String strScriptName = "HSB_W-WallConnections"; // name of the script
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Element lstElements[2];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("MasterToSatellite", true);
	setCatalogFromPropValues("MasterToSatellite");
	
	ElementWall arElWallThis[0];
	ElementWall arElWallConnected[0];
	Point3d arPtIntersect[0];
	
	for( int e=0;e<arSelectedElement.length();e++ ){
		Element el = arSelectedElement[e];
		ElementWall elWall = (ElementWall)el;
		if( !elWall.bIsValid() )
			continue;
			
		Element arElConnected[] = elWall.getConnectedElements();
		for( int i=0;i<arElConnected.length();i++ ){
			Element elConnected = arElConnected[i];
			ElementWall elWallConnected = (ElementWall)elConnected;
			if( !elWallConnected.bIsValid() )
				continue;
			
			// Connected element has to be in the selection set.
			if( arSelectedElement.find(elWallConnected) == -1 )
				continue;
	
			//Check if the connection already exists.
			int nIndexThis = arElWallThis.find(elWall);
			int nIndexConnected = arElWallConnected.find(elWall);
			if( nIndexThis > -1 ){
				if( arElWallConnected[nIndexThis] == elWallConnected ){
					continue;
				}
			}
			if( nIndexConnected > -1 ){
				if( arElWallThis[nIndexConnected] == elWallConnected ){
					continue;
				}
			}
			
			int bIsExistingConnection = false;
			TslInst arTsl[] = elWall.tslInst();
			arTsl.append(elWallConnected.tslInst());
			for( int j=0;j<arTsl.length();j++ ){
				TslInst tsl = arTsl[j];
				if( tsl.scriptName() == strScriptName ){
					Entity arEntEl[] = tsl.entity();
					if( arEntEl.find(elWall) != -1 && arEntEl.find(elWallConnected) != -1 ){
						bIsExistingConnection = true;
						break;
					}
				}
			}
			if( bIsExistingConnection )
				continue;
			
			// Store the connection. It cannot be inserted twice.
			arElWallThis.append(elWall);
			arElWallConnected.append(elWallConnected);
			
			// Insert the tsl for this connection.
			lstElements[0] = elWall;
			lstElements[1] = elWallConnected;
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}
	}
	
	eraseInstance();
	return;
}

if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", true);
	}
}

if( _Element.length() != 2 ){
	reportNotice("\n" + scriptName() + TN("|Invalid number of elements|!"));
	eraseInstance();
	return;
}

Element el = _Element[0];
ElementWall elWall = (ElementWall)el;
if( !elWall.bIsValid() ){
	reportNotice("\n" + scriptName() + TN("|Invalid element found|!"));
	eraseInstance();
	return;
}

if( _bOnDebug )
	reportNotice(TN("\n|Wall|: ")+elWall.number());

//CoordSys
CoordSys csWall = elWall.coordSys();
Vector3d vxWall = csWall.vecX();
Vector3d vyWall = csWall.vecY();
Vector3d vzWall = csWall.vecZ();
_Pt0 = csWall .ptOrg();

//Draw diagonal
Display dp(-1);  	
LineSeg lnSegWall = elWall.segmentMinMax(); // get diagonal of multi element  	
//dp.draw(lnSegWall);

//Points to drill (ideal situation)
Point3d ptStartWall = lnSegWall.ptStart();
Point3d ptMidWall = lnSegWall.ptMid();
Point3d ptEndWall = lnSegWall.ptEnd();

//Outline this wall
PLine plElWall = elWall.plOutlineWall();
Point3d arPtPl[] = plElWall.vertexPoints(TRUE);
PlaneProfile ppElWall(CoordSys(csWall.ptOrg(), vxWall, -vzWall, vyWall));
ppElWall.joinRing(plElWall, _kAdd);
ppElWall.shrink(-U(2));

Element elConnected = _Element[1];
ElementWall elWallConnected = (ElementWall)elConnected;
if( !elWallConnected.bIsValid() ){
	reportNotice("\n" + scriptName() + TN("|Invalid element found|!"));
	eraseInstance();
	return;
}

//CoordSys
CoordSys csWallConnected = elWallConnected.coordSys();
Vector3d vxConnected = csWallConnected.vecX();
Vector3d vyConnected = csWallConnected.vecY();
Vector3d vzConnected = csWallConnected.vecZ();

// Inline connections are ignored.
if( abs(abs(vzWall.dotProduct(vzConnected)) - 1) < dEps ){
	reportNotice("\n----------------------------------\n"+elWall.number() + "     -     "+elWallConnected.number());
	reportNotice("\n" + scriptName() + TN("|Elements are in line with each other|!") + TN("|This is not supported|."));
	eraseInstance();
	return;
}


if( _bOnDebug )
	reportNotice(TN("\t|Connecting wall|: ")+elWallConnected.number());

//Outline other wall
PLine plElWallConnected = elWallConnected.plOutlineWall();
Point3d arPtPlConnected[] = plElWallConnected.vertexPoints(TRUE);
PlaneProfile ppElWallConnected(CoordSys(csWallConnected.ptOrg(), vxConnected, -vzConnected, vyConnected));
ppElWallConnected.joinRing(plElWallConnected, _kAdd);
ppElWallConnected.shrink(-U(2));

int nNrOfPointsOnOutlineThisWall = 0;
for( int j=0;j<arPtPlConnected.length();j++ ){
	Point3d pt = arPtPlConnected[j];
	pt.vis();
	if( ppElWall.pointInProfile(pt) == _kPointInProfile ){
		nNrOfPointsOnOutlineThisWall++;
	}
}
int nNrOfPointsOnOutlineOtherWall = 0;
for( int j=0;j<arPtPl.length();j++ ){
	Point3d pt = arPtPl[j];
	pt.vis();
	if( ppElWallConnected.pointInProfile(pt) == _kPointInProfile ){
		nNrOfPointsOnOutlineOtherWall++;
	}
}

// Find type of connection.

String arSConnectionType[] = {
	"Corner connection",
	"T-Connection",
	"Partial corner connection",
	"Head connection",
	"Angled head connection",
	"Unknown connection"
};
int arNConnectionType[] = {
	0, // Corner connection
	1, // T-Connection
	2, // Partial corner connection
	3, // Head connection
	4, // Angled head connection
	5	// Unknown connection
};
int nConnectionType = 5;

// Will be set to false if the connecting wall seems to be the male wall.
int bIsMaleConnection = true;

if( abs(abs(vzConnected.dotProduct(vzWall)) - 1) < dEps ){ // Head connection
	nConnectionType = 3;
}
else if( nNrOfPointsOnOutlineThisWall == 2 ){
	if( nNrOfPointsOnOutlineOtherWall == 2 ){// Angled head connection
		nConnectionType = 4;
	}
	else{//T-Connection or Corner-Connection
		bIsMaleConnection = false;
		if( nNrOfPointsOnOutlineOtherWall == 1 ){// Corner connection
			nConnectionType = 0;
		}
		else if( nNrOfPointsOnOutlineOtherWall == 0 ){// T connection
			nConnectionType = 1;
		}
	}
}
else if( nNrOfPointsOnOutlineThisWall == 1 ){
	if( nNrOfPointsOnOutlineOtherWall == 2 ){ // Corner connection
		nConnectionType = 0;
		
	}
	else if( nNrOfPointsOnOutlineOtherWall == 1 ){// Partial corner connection
		nConnectionType = 2;
	}
}
else if( nNrOfPointsOnOutlineThisWall == 0 ){
	if( nNrOfPointsOnOutlineOtherWall == 2 ){ // T connection
		nConnectionType = 1;
	}
}

// Only take into account the T- and (partial) corner connections
if( nConnectionType > 2 ){
	reportNotice("\n----------------------------------\n"+elWall.number() + "     -     "+elWallConnected.number());
	reportNotice("\n" + scriptName() + TN("|Invalid connection type|! - ")+nConnectionType);
	eraseInstance();
	return;
}

ElementWall elWallMale = elWall;
ElementWall elWallFemale = elWallConnected;
// Swap elements if it was a female connection.
if( !bIsMaleConnection ){
	elWallMale = elWallConnected;
	elWallFemale = elWall;
}

// Male properties
CoordSys csMale = elWallMale.coordSys();
Point3d ptMale = csMale.ptOrg();
Vector3d vxMale = csMale.vecX();
Vector3d vyMale = csMale.vecY();
Vector3d vzMale = csMale.vecZ();
double dHMale;
Point3d arPtMale[] = elWallMale.plOutlineWall().vertexPoints(true);
arPtMale = Line(ptMale, vzMale).orderPoints(arPtMale);
if( arPtMale.length() > 1 )
	dHMale = abs(vzMale.dotProduct(arPtMale[arPtMale.length() - 1] - arPtMale[0]));

// Female properties
CoordSys csFemale = elWallFemale.coordSys();
Point3d ptFemale = csFemale.ptOrg();
Vector3d vzFemale = csFemale.vecZ();
double dHFemale;
Point3d arPtFemale[] = elWallFemale.plOutlineWall().vertexPoints(true);
arPtFemale = Line(ptFemale, vzFemale).orderPoints(arPtFemale);
if( arPtFemale.length() > 1 )
	dHFemale = abs(vzFemale.dotProduct(arPtFemale[arPtFemale.length() - 1] - arPtFemale[0]));

// Find the intersection
Point3d ptConnection = Line(ptMale - vzMale * 0.5 * dHMale, vxMale).intersect(Plane(ptFemale, vzFemale), U(0));
Point3d ptInsideMale = ptMale - vzMale * 0.5 * dHMale + vxMale * U(10);
// UCS for the connection
Vector3d vzConnection = -vzFemale;
if( vzFemale.dotProduct(ptConnection - ptInsideMale) > 0 ){
	ptConnection -= vzFemale * dHFemale;
	vzConnection *= -1;
}
Vector3d vxConnection = vyMale;
Vector3d vyConnection = vzConnection.crossProduct(vxConnection);

_Pt0 = ptConnection;
ptConnection.vis(6);
vxConnection.vis(ptConnection, 1);
vyConnection.vis(ptConnection, 3);
vzConnection.vis(ptConnection, 150);
if( _bOnDebug )
	dp.draw(arSConnectionType[nConnectionType], ptConnection, vxMale, -vzMale, 0, 0);

PlaneProfile connectionProfile(CoordSys(ptConnection, vxConnection, vyConnection, vzConnection));
connectionProfile.unionWith(elWallFemale.profBrutto(0));
connectionProfile.vis(3);

PlaneProfile maleProfile(CoordSys(ptMale, -vzConnection, vxConnection, -vyConnection));
maleProfile.unionWith(elWallMale.profBrutto(0));
maleProfile.vis(1);
PLine maleProfileRings[] = maleProfile.allRings();
int maleProfileRingsAreOpenings[] = maleProfile.ringIsOpening();
PLine maleOutline(vyConnection);
for (int r=0;r<maleProfileRings.length();r++)
{
	if (maleProfileRingsAreOpenings[r])
		continue;
	if (maleProfileRings[r].area() > maleOutline.area())
		maleOutline = maleProfileRings[r];
}
int side = 1;
if (vyConnection.dotProduct(ptConnection - ptMale) < 0)
	side *= -1;
double maleFrameThickness = elWallMale.zone(0).dH();
if (maleFrameThickness == 0)
{
	maleFrameThickness = elWallMale.dBeamHeight();
}
if (maleFrameThickness == 0 && elWallMale.sip().length() != 0)
{
	Sip sips[] = elWallMale.sip();
	maleFrameThickness = sips[0].dH();
}
Body maleFrameBody(maleOutline, vyConnection * side * maleFrameThickness, 1);

connectionProfile = maleFrameBody.extractContactFaceInPlane(Plane(ptConnection, vzConnection), U(10));
//connectionProfile.transformBy(vzConnection * 10);
connectionProfile.vis(1);

Point3d arPtMidEdge[] = connectionProfile.getGripEdgeMidPoints();
// The width of the connecting face should be big enough.
arPtMidEdge = Line(ptConnection, vyConnection).orderPoints(arPtMidEdge);

if (arPtMidEdge.length() == 0 ){
	reportNotice("\n----------------------------------\n"+elWall.number() + "     -     "+elWallConnected.number());
	reportNotice("\n" + scriptName() + TN("|Surfaces are not connecting|!"));
	eraseInstance();
	return;
}
double dConnectionWidth = abs(vyConnection.dotProduct(arPtMidEdge[arPtMidEdge.length() - 1] - arPtMidEdge[0]));
if (dConnectionWidth < (2 * dDrillDiameter)) {
	reportNotice("\n----------------------------------\n"+elWall.number() + "     -     "+elWallConnected.number());
	reportNotice("\n" + scriptName() + TN("|Connecting surface is too small|!"));
	eraseInstance();
	return;
}

double dAreaConnectingFace = connectionProfile.area();

// Get the lower point of the connecting face. Use that as the start of the distribution.
arPtMidEdge = Line(ptConnection, vxConnection).orderPoints(arPtMidEdge);
if( arPtMidEdge.length() < 2 ){
	reportNotice("\n----------------------------------\n"+elWall.number() + "     -     "+elWallConnected.number());
	reportNotice("\n" + scriptName() + TN("|Surfaces are not connecting|!"));
//	eraseInstance();
	return;
}

// Calculate the exact spacing.
Point3d ptStartDistribution = arPtMidEdge[0] + vxConnection * dOffsetFromBottom;
Point3d ptEndDistribution = arPtMidEdge[arPtMidEdge.length() - 1] - vxConnection * dOffsetFromTop;
double dDistributionLength = vxConnection.dotProduct(ptEndDistribution - ptStartDistribution);
double dNrOfSpacings = dDistributionLength / dMaximumSpacing;
int nNrOfSpacings = int(dNrOfSpacings);

double dRest = dNrOfSpacings - nNrOfSpacings;
if( dRest > dEps )
	nNrOfSpacings++;
	
if( nNrOfSpacings == 0 ){
	reportNotice("\n----------------------------------\n"+elWall.number() + "     -     "+elWallConnected.number());
	reportNotice("\n" + scriptName() + TN("|No possible drill positions found|!"));
	eraseInstance();
	return;
}

double dSpacing = dDistributionLength / nNrOfSpacings;

// Create the drill
Point3d ptDrillSt = ptStartDistribution + vzConnection * 1.1 * dHFemale;
Point3d ptDrillEnd = ptStartDistribution - vzConnection * 0.1 * dHFemale;
Drill drill(ptDrillSt, ptDrillEnd, 0.5 * dDrillDiameter);
// ...and the symbol.
PLine plDrillSt(vzConnection);
plDrillSt.createCircle(ptDrillSt, vzConnection, dDrillDiameter);
PLine plDrillEnd(vzConnection);
plDrillEnd.createCircle(ptDrillEnd, vzConnection, dDrillDiameter);
PLine plLine(ptDrillSt, ptDrillEnd);



// Apply the drills.
for( int i=0;i<=nNrOfSpacings;i++ ){
	if( i>0 ){
		drill.transformBy(vxConnection * dSpacing);
		
		plDrillSt.transformBy(vxConnection * dSpacing);
		plDrillEnd.transformBy(vxConnection * dSpacing);
		plLine.transformBy(vxConnection * dSpacing);
	}
	
	GenBeam arGBmFemale[] = el.genBeam();
	int nDrillApplied = drill.addMeToGenBeamsIntersect(arGBmFemale);
	
	dp.color(1);
	dp.draw(plDrillSt);
	dp.draw(plDrillEnd);
	dp.color(7);
	dp.draw(plLine);
}

_ThisInst.assignToElementGroup(elWallFemale, true, 0, 'T');

// Attach article data to the element.
Map mapItem= Map();
mapItem.setString("DESCRIPTION", sDescription);
mapItem.setString("AMOUNT",nNrOfSpacings + 1); 
mapItem.setString("ARTICLENUMBER",sArticle);
ElemItem elItem(1, "ARTICLE", _Pt0, vxConnection, mapItem);
elItem.setShow(_kNo);
el.addTool(elItem);
#End
#BeginThumbnail




#End
#BeginMapX

#End