#Version 8
#BeginDescription
V0.8__BugFix
V0.7__Added support for NA layout DIm 
Version 0.6_Aug7 2013_BJ_Adjusted Vent Height
Version 0.5_June28 2013_BJ_Added Vent Holes for EC11
Version 0.4 Alterred the Marking text for the CDT file
V0.3_21MAY2008_ TSL will no longer need to be recalced after element constuction
V0.2_2MAY2008_  Altered to be persistent through element construction. TSL will need to be recalced.







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 0
#MinorVersion 8
#KeyWords 
#BeginContents
Unit(1,"inch"); // script uses inches

// ***
// Create properties.
// This part of the scriptcreates the properties which can be changed by the user.
// These properties are visible in the OPM.
// ***

MapObject mo("ElectricalItems", "ElectricalItems");
Map mpElectrical = mo.map();

String arTypes[0];
String arNamesToExport[0];
double dWidhts[0];
double dHeights[0];
double dElevations[0];
int nReferencePoints[0];
//WARNING: arTypes MUST HAVE SAME NUMBER OF ELEMENTS THAT dWidhts, dHeights, dElevations and nReferencePoints
//WARNING; If dElevations<0, then value is taken from top plate
//WARNING: nReferencePoint sets if elevation is from top (1), center (0), or bottom (-1) of box.

//Features
String sRange="Range Electric";												arTypes.append(sRange);						arNamesToExport.append(" - 4 sq"); 		dWidhts.append(4.6875);	dHeights.append(4.6875);			dElevations.append(4.5);		nReferencePoints.append(-1);
String sStandarRecep1="Std receptacle, bell and cable single";			arTypes.append(sStandarRecep1);			arNamesToExport.append(" - 2x3"); 		dWidhts.append(U(2));		dHeights.append(U(3));				dElevations.append(U(16));		nReferencePoints.append(-1);
String sSingleVent="Single Vent";			                                           arTypes.append(sSingleVent);			arNamesToExport.append(" - 9.5x9.5"); 		dWidhts.append(9.375);		dHeights.append(9.375);				dElevations.append(96.25);		nReferencePoints.append(-1);
String sDoubleVent="Double Vent";			                                           arTypes.append(sDoubleVent);			arNamesToExport.append(" - 17.25x9.5"); 		dWidhts.append(17.25);		dHeights.append(9.375);		            dElevations.append(96.25);		nReferencePoints.append(-1);
String sStandarRecep2="Std receptacle, bell and cable double";			arTypes.append(sStandarRecep2);			arNamesToExport.append(" - 4x3"); 		dWidhts.append(4);		dHeights.append(3);				dElevations.append(16);		nReferencePoints.append(-1);
String sWasher="Washer";													arTypes.append(sWasher);					arNamesToExport.append(" - 2x3"); 		dWidhts.append(2);		dHeights.append(3);				dElevations.append(30);		nReferencePoints.append(-1);
String sFridge="Fridge";														arTypes.append(sFridge);						arNamesToExport.append(" - 2x3"); 		dWidhts.append(2);		dHeights.append(3);				dElevations.append(30);		nReferencePoints.append(-1);
String sDryer="Dryer";														arTypes.append(sDryer);						arNamesToExport.append(" - 4 sq"); 		dWidhts.append(4.6875);	dHeights.append(4.6875);			dElevations.append(30);		nReferencePoints.append(-1);
String sKitchenC="Kitchen countertop";										arTypes.append(sKitchenC);					arNamesToExport.append(" - 2x3");	 	dWidhts.append(U(2));		dHeights.append(U(3));				dElevations.append(U(45));		nReferencePoints.append(-1);
String sKitchenCS="Kitchen/bathroom countertop beside sink";				arTypes.append(sKitchenCS);					arNamesToExport.append(" - 2x3 GFI"); 	dWidhts.append(2);		dHeights.append(3);				dElevations.append(45);		nReferencePoints.append(-1);
String sStandarLight1="Std light switch single";								arTypes.append(sStandarLight1);				arNamesToExport.append(" - 2x3");		dWidhts.append(2);		dHeights.append(3);				dElevations.append(48.5);		nReferencePoints.append(-1);
String sStandarLight2="Std light switch double";								arTypes.append(sStandarLight2);				arNamesToExport.append(" - 4x3"); 		dWidhts.append(4);		dHeights.append(3);				dElevations.append(48.5);		nReferencePoints.append(-1);
String sStandarLight3="Std light switch triple";								arTypes.append(sStandarLight3);				arNamesToExport.append(" - 6x3"); 		dWidhts.append(6);		dHeights.append(3);				dElevations.append(48.5);		nReferencePoints.append(-1);
String sStandarLight4="Std light switch quadruple";							arTypes.append(sStandarLight4);				arNamesToExport.append(" - 8x3");	 	dWidhts.append(8);		dHeights.append(3);				dElevations.append(48.5);		nReferencePoints.append(-1);
String sPrincipleFan="Principle fan switch/central vacuum";				arTypes.append(sPrincipleFan);				arNamesToExport.append(" - 2x3");	 	dWidhts.append(2);		dHeights.append(3);				dElevations.append(52);		nReferencePoints.append(-1);
String sMicrowave="Microwave, fireplace switch, wall mounted phone";	arTypes.append(sMicrowave);				arNamesToExport.append(" - 2x3"); 		dWidhts.append(2);		dHeights.append(3);				dElevations.append(60);		nReferencePoints.append(-1);
String sHoodFan="Hood fan";													arTypes.append(sHoodFan);					arNamesToExport.append(" - 2x3"); 		dWidhts.append(2);		dHeights.append(3);				dElevations.append(64);		nReferencePoints.append(-1);
String sMicromate="Microwave hood fan combo";							arTypes.append(sMicromate);				arNamesToExport.append(" - 2x3"); 		dWidhts.append(2);		dHeights.append(3);				dElevations.append(79);		nReferencePoints.append(0);
String sValence8="Valence light 8' wall";										arTypes.append(sValence8);					arNamesToExport.append(" - 3x2"); 		dWidhts.append(3);	            dHeights.append(2);				dElevations.append(53.375);		nReferencePoints.append(-1);
String sValence9="Valence light 9' wall";										arTypes.append(sValence9);					arNamesToExport.append(" - 3x2"); 		dWidhts.append(3);	            dHeights.append(2);				dElevations.append(52);		nReferencePoints.append(-1);

//Special case (No milling around box needed. Instead, a hole in the center of box is needed)
String sExteriorGFI="Exterior GFI";											arTypes.append(sExteriorGFI);				arNamesToExport.append(" - 2x3"); 		dWidhts.append(2);		dHeights.append(3);				dElevations.append(24);		nReferencePoints.append(-1);
String sBrick="Wall mounted exterior light fixture (Brick)";					arTypes.append(sBrick);						arNamesToExport.append(" - 2x3"); 		dWidhts.append(2);		dHeights.append(3);				dElevations.append(74);		nReferencePoints.append(-1);
//Every name of a reference to special case "no box milling but hole needed" must be added here
String sNoBoxMillButHoleMill[0];
sNoBoxMillButHoleMill.append(sExteriorGFI);
sNoBoxMillButHoleMill.append(sBrick);
double dSpecialHoleDiameter=U(1);// Diameter of hole in this special case

//Special case (reference to U.S. floor joist)
String sGarageLightInterior="Garage light & receptacle (interior)";			arTypes.append(sGarageLightInterior);		arNamesToExport.append(" - 2x3");               dWidhts.append(2);		dHeights.append(3);		                        dElevations.append(11.25);	            nReferencePoints.append(-1);
String sGarageLightExterior="Garage light & receptacle (exterior)";	      	arTypes.append(sGarageLightExterior);		arNamesToExport.append(" - 2x3");               dWidhts.append(2);		dHeights.append(3);		                        dElevations.append(22.5);	            nReferencePoints.append(-1);
String sGarageCentralVaccum="Garage central vaccum";					arTypes.append(sGarageCentralVaccum);	arNamesToExport.append("- 2x3"); 		dWidhts.append(2);		dHeights.append(3);				dElevations.append(39.25);		nReferencePoints.append(-1);
//Every name of a reference to U.S. floor joist outlet must be added here
String sUSFloorJoists[0];
sUSFloorJoists.append(sGarageLightInterior);
sUSFloorJoists.append(sGarageLightExterior);


//Special case (octagons) 
double dOctagonMaxSide=U(3.622); // For drawing the whole octagon, only height is referenced
String sStucco="Wall mounted exterior light fixture (Sidding/Stucco)";		arTypes.append(sStucco);					arNamesToExport.append(" - Octagon"); 	dWidhts.append(0);		dHeights.append(dOctagonMaxSide);	dElevations.append(74);		nReferencePoints.append(-1);
String sInteriorLightFix="Wall mounted interior light fixture"; 				arTypes.append(sInteriorLightFix);	      	arNamesToExport.append(" - Octagon"); 	dWidhts.append(0);		dHeights.append(dOctagonMaxSide);	dElevations.append(77.5);		nReferencePoints.append(-1);

String sRangeGas="Range Gas";												arTypes.append(sRangeGas);				arNamesToExport.append(" - 2x3"); 		dWidhts.append(2);		dHeights.append(3);				dElevations.append(4.5);		nReferencePoints.append(-1);

String sStandarLight11R="Std light switch single @ -1R (7 1/2 in)";			arTypes.append(sStandarLight11R);			arNamesToExport.append(" - 2x3");		dWidhts.append(2);		dHeights.append(3);				dElevations.append(41);		nReferencePoints.append(-1);
String sStandarLight12R="Std light switch single @ -2R (15 in)";			arTypes.append(sStandarLight12R);			arNamesToExport.append(" - 2x3");		dWidhts.append(2);		dHeights.append(3);				dElevations.append(33.5);		nReferencePoints.append(-1);

String sStandarLight21R="Std light switch double @ -1R (7 1/2 in)";		arTypes.append(sStandarLight21R);			arNamesToExport.append(" - 4x3"); 		dWidhts.append(4);		dHeights.append(3);				dElevations.append(41);		nReferencePoints.append(-1);
String sStandarLight22R="Std light switch double @ -2R (15 in)";			arTypes.append(sStandarLight22R);			arNamesToExport.append(" - 4x3"); 		dWidhts.append(4);		dHeights.append(3);				dElevations.append(33.5);		nReferencePoints.append(-1);

String sStandarLight31R="Std light switch triple @ -1R (7 1/2 in)";			arTypes.append(sStandarLight31R);			arNamesToExport.append(" - 6x3"); 		dWidhts.append(6);		dHeights.append(3);				dElevations.append(41);		nReferencePoints.append(-1);
String sStandarLight32R="Std light switch triple @ -2R (15 in)";				arTypes.append(sStandarLight32R);			arNamesToExport.append(" - 6x3"); 		dWidhts.append(6);		dHeights.append(3);				dElevations.append(33.5);		nReferencePoints.append(-1);

String sStandarLight41R="Std light switch quadruple @ -1R (7 1/2 in)";		arTypes.append(sStandarLight41R);			arNamesToExport.append(" - 8x3");	 	dWidhts.append(8);		dHeights.append(3);				dElevations.append(41);		nReferencePoints.append(-1);
String sStandarLight42R="Std light switch quadruple @ -2R (15 in)";		arTypes.append(sStandarLight42R);			arNamesToExport.append(" - 8x3");	 	dWidhts.append(8);		dHeights.append(3);				dElevations.append(33.5);		nReferencePoints.append(-1);

//Every name of a octagon outlet must be added here
String sOctagons[0];
sOctagons.append(sStucco);
sOctagons.append(sInteriorLightFix);

PropString strType(0,arTypes,"Type of outlet");
int nType=arTypes.find(strType,0);

PropDouble dDistanceFromBm(0,U(0),T("Distance between beam and outlet  / vent"));

PropDouble dVentRadius(1,U(3),T("Vent radius"));
PropDouble dDistanceFromVentToBox(3,U(7),T("Distance between vent and outlet"));
PropDouble dTolerance(2,U(.1),T("Tolerance"));

int arnSide[]={-1,1};// -1=Back/Left/Down, 1=Front/Right/Up

String arFrontBack[]={T("Back"),T("Front")};
PropString strFrontBack(1,arFrontBack,T("Face to place Outlet"));
int nSide=arnSide[arFrontBack.find(strFrontBack)];

String arLeftRight[]={T("Left"),T("Right")};
PropString strLeftRightBm(2,arLeftRight,T("Side to place Outlet from beam"));
int nDirFromBeam=arnSide[arLeftRight.find(strLeftRightBm,0)];

String arUpDown[]={T("Down"),T("Up")};
PropString strUpDownChase(3,arUpDown,T("Wire chase direction"));
int nChaseDir=arnSide[arUpDown.find(strUpDownChase,0)];

PropInt nToolingIndex(0,0,T("Tooling index"));

String arSTurn[]= {T("Against course"),T("With course")};
int arNTurn[]={_kTurnAgainstCourse, _kTurnWithCourse};
PropString sTurn(4,arSTurn,T("Turning direction"));
int nTurn = arNTurn[arSTurn.find(sTurn,0)];

String arSOShoot[]= {T("No"),T("Yes")};
int arNOShoot[]={FALSE, TRUE};
PropString sOShoot(5,arSOShoot,T("Overshoot"));
int nOShoot = arNOShoot[arSOShoot.find(sOShoot,0)];

String arSVacuum[]= {T("No"),T("Yes")};
int arNVacuum[]={FALSE, TRUE};
PropString sVacuum(6,arSVacuum,T("Vacuum"));
int nVacuum = arNVacuum[arSVacuum.find(sVacuum,0)];

//  End of properties. 
//  ***

// ***
// Start insert
// This code is executed when the TSL is inserted.
// ***
if (_bOnInsert) {
	showDialogOnce();
	Beam bmSelect = getBeam(T("Select a Stud")) ;
	
	if(!bmSelect.vecX().isParallelTo(_ZW)){
		reportNotice( "Selected beam not vertical" ) ;

		eraseInstance(); 
		return;
	}
	
	_Element.append(bmSelect.element());
	_Map.setEntity( "entBeam", bmSelect );
	_Map.setEntity( "entWall", bmSelect.element() ) ;
	_Map.setPoint3d( "ptBeam", bmSelect.ptCen() ) ;
 	return;
}


String stLinktoElement = T("|Link to wall|");
addRecalcTrigger(_kContext, stLinktoElement);
String stUnlikFromElement = T("|Unlink from wall|");
addRecalcTrigger(_kContext, stUnlikFromElement);

if(_kExecuteKey == stLinktoElement || _kExecuteKey == stUnlikFromElement || _bOnInsert || _bOnDbCreated)
{ 
	Entity entEl = _Map.getEntity("entWall");
	Element el = (Element)entEl;
	
	//clear out from registry
	if (el.bIsValid())
	{
		MapObject mo("ElectricalItems", "ElectricalItems");
		Map mpElectrical = mo.map();
		
		Map mpThisEl = mpElectrical.getMap("EL-" + el.handle());
		
		for (int i = mpThisEl.length()-1; i > -1 ;i--) 
		{ 
			Entity entTsl = mpThisEl.getEntity(i);
			if ( ! entTsl.bIsValid())continue;
			String stHand = _ThisInst.handle();
			if(entTsl == _ThisInst)
			{ 
				mpThisEl.removeAt(i, true);
				reportMessage("\nRemoved from registry for wall '" + el.number() + "'." );
			}
		}
		
		mpElectrical.setMap("EL-" + el.handle(), mpThisEl);
		
		mo.setMap(mpElectrical);
	}
}

if(_kExecuteKey == stLinktoElement)
{ 
	Element el = getElement("\nSelect an element.", true);
	
	if (el.bIsValid())
	{
		_Map.setEntity("entWall", el);
		
		_Element.setLength(1);
		_Element[0] = el;
	}
	else
	{
		_Map.removeAt("entWall", 1);
		reportMessage("\nInvalid selection. This box is now orphaned." );
	}
}
if(_kExecuteKey == stUnlikFromElement)
{ 

	_Map.removeAt("entWall", 1);
	reportMessage("\nThis box is now orphaned." );
}

//Reset _Element if linked to new wall
if(_Map.hasInt("bLinkedToNewWall"))
{ 
	_Element.setLength(0);
}


Map mp = _Map;
int boxIndex = arTypes.find(strType);

if (mp.getString("stName") != strType) _Map.setString("stName", strType);
_Map.setString("stUnitName", strType + arNamesToExport[boxIndex]);
_Map.setDouble("Width", dWidhts[boxIndex]);
_Map.setDouble("Height", dHeights[boxIndex]);
_Map.setDouble("Depth", U(2) );
_Map.setString("stKPNCover", strType);
_Map.setString("stKPNBox", strType);
_Map.setString("stKPNMud", strType);
_Map.setString("stKPNOutlet", strType);
_Map.setString("stKPNWeather", strType);
_Map.setString("Face", strFrontBack);

// ***
// End insert.
// ***
Entity entBeam = _Map.getEntity( "entBeam" ) ;
Beam bmSelected=(Beam)entBeam ;
Entity ent =  _Map.getEntity( "entWall" ) ;
Element el = (Element)ent ;


if(_Element.length()>0) setDependencyOnEntity(_Element[0]);
else if(el.bIsValid())
{
	_Element.setLength(1);
	_Element.append(el);
	setDependencyOnEntity(_Element[0]);
	
	
}
else{
	reportNotice( "Element0 is not valid" ) ;
	eraseInstance(); 
	return;
}

if(el.bIsValid())
{ 
	//FOR NOW WE STORE IN MAP OBJECT
	String stHand = "EL-" + el.handle();
	Map mpThisEl = mpElectrical.getMap(stHand);
	
	mpThisEl.setEntity("BOX-" + _ThisInst.handle(), _ThisInst);
	mpElectrical.setMap("EL-" + el.handle(), mpThisEl);
	if(mo.bIsValid())	mo.setMap(mpElectrical);
	else mo.dbCreate(mpElectrical);
}


if (! bmSelected.bIsValid() ) //  Happens during element construction
{
	Point3d ptBeam = _Map.getPoint3d( "ptBeam" ) ;
	Beam bmFinder ;
	bmFinder.dbCreate( ptBeam, _ZW, _YW, _XW) ;
	Beam bmAll[] = el.beam() ;
	bmAll = bmFinder.filterBeamsParallel( bmAll ) ;
	
	Beam bmCloseStuds[0] ;
	bmCloseStuds = bmFinder.filterBeamsCenterDistanceYZRange( bmAll, U(2.25), 0 ) ;
	bmFinder.dbErase() ;
	
	if ( bmCloseStuds.length() < 1 ) 
	{
		//reportNotice( "No close studs found" ) ;
		//eraseInstance();
		return;
	}
	
	bmSelected = bmCloseStuds[0] ;
	_Map.setEntity( "entBeam", bmSelected ) ;
	
}

CoordSys csEl=el.coordSys();
Point3d ptOrg=csEl.ptOrg();
Vector3d vx=csEl.vecX();
Vector3d vy=csEl.vecY();
Vector3d vz=csEl.vecZ();
assignToElementGroup(el,TRUE,0,'Z');

//Searching top&bottom plates
Sheet arShOnZone[]=el.sheet(nSide);
Beam arBmAll[]=el.beam();
Beam arBmHorizontal[]=vy.filterBeamsPerpendicularSort(arBmAll);
Beam arBmVer[]=vx.filterBeamsPerpendicularSort(arBmAll);
double dTop=0;
double dBtm=U(20000,800);
Beam bmTop, bmBottom;
int nTopIndex, nBtmIndex;
int bTopFound,bBottomFound;

//Randy Start
Point3d bmClLeft;
Point3d bmClRight;
double dClLeft= U(2000);
double dClRight=U(2000);
//Randy Finish

for(int b=0;b<arBmHorizontal.length();b++){
	Beam bm=arBmHorizontal[b];
	//Top plate search
	if(bm.type()==_kSFTopPlate&&!bTopFound){
		bmTop=bm;
		dTop=bm.ptCen().Z();
		bTopFound=true;
	}
	//Bottom plate search
	if(bm.type()==_kSFBottomPlate&&!bBottomFound){
		bmBottom=bm;
		dBtm=bm.ptCen().Z();
		bBottomFound=true;
	}
	
	
}

for(int v=0;v<arBmVer.length();v++){
	Beam bm=arBmVer[v];
	//Randy Start
	double dBm = el.vecX().dotProduct(bm.ptCen()-_Pt0);
	// Check if beam is in connection. If < 0 Then beam is in connection
	if (dBm < 0 ) { //Beam is on left side of connection
		if (abs(dBm) < abs(dClLeft)) {
			dClLeft = dBm;
			bmClLeft = bm.ptCen();
		}
	}
	else if (dBm > 0) { //Beam is on right side of connection
		if (dBm < dClRight) {
			dClRight = dBm;
			bmClRight = bm.ptCen();
		}
	}
}


double dBlockL=abs(el.vecX().dotProduct(bmClRight-bmClLeft))-U(1.5);
	//Randy Finish
	
Point3d ptInsertionOnTop=bmTop.ptCen()-vy*bmTop.dD(vy)*.5;
Point3d ptInsertionOnBottom=bmBottom.ptCen()-vy*bmBottom.dD(vy)*.5;

// ***
// Get the Boxes information
// ***
String sNameToExport=arNamesToExport[nType];
double dW,dH,dBodyDepth,dElevation,ChaseW;
dW=dWidhts[nType];
dH=dHeights[nType];
dBodyDepth=U(2);// Not defined by customer
dElevation=dElevations[nType];
int nReferencePoint=nReferencePoints[nType];

// ***
// End of Box information
// ***

// ***
//Wire chase
double dChaseRadius=U(0.5);
double dDrillingOnPlates=dChaseRadius+dTolerance*.5;
// End of wire chase information
// ***

//Placing boxes
Display dp(-1);

int iColorDxa = 7;

if (nSide == -1)iColorDxa = 1;
else iColorDxa = 3;

Display dpDXA(iColorDxa);
dpDXA.showInDxa(true);
dpDXA.textHeight(U(1.5));
//dpDxa.showInDispRep("Bogus");

PLine arPlDxa[0];


//Define if is octagon
int bIsOctagon=false;
for(int i=0;i<sOctagons.length();i++){
	if(strType.find(sOctagons[i],0)!=-1){
		bIsOctagon=true;
	}
}

if(!bIsOctagon){// Not octagonal shape

	//Define special case: US Floor Joist (vertical alignment reference diferent)
	int bIsUSFloorJoist=false;
	for(int i=0;i<sUSFloorJoists.length();i++){
		if(strType.find(sUSFloorJoists[i],0)!=-1){
			bIsUSFloorJoist=true;
		}
	}
	
	_Pt0=bmSelected.ptCen()+vx*(bmSelected.dD(vx)*.5+dDistanceFromBm)*nDirFromBeam;

	//Realign along vy
	if(!bIsUSFloorJoist){ // not referenced to floor joist
		if(dElevation>0){// Dependent on bottom plate
			_Pt0+=vy*(vy.dotProduct(ptInsertionOnBottom-_Pt0)+dElevation-nReferencePoint*dH*.5);
		}
		else if(dElevation<0){// Dependent on top plate
			_Pt0+=vy*(vy.dotProduct(ptInsertionOnTop-_Pt0)+dElevation-nReferencePoint*dH*.5);	
		}
	}

	else{
		Point3d ptBottomOnBeam=bmSelected.ptCen()-vy*(bmSelected.realBody().lengthInDirection(vy)*.5+U(1.5));
		ptInsertionOnBottom+=vy*vy.dotProduct(ptBottomOnBeam-ptInsertionOnBottom);
		_Pt0+=vy*(vy.dotProduct(ptInsertionOnBottom-_Pt0)+dElevation-nReferencePoint*dH*.5);
	}	

	//Realign along vz
	_Pt0+=vz*nSide*(bmSelected.dD(vz)*.5-dBodyDepth*.5);
	
	//Box
	Body bdOutlet(_Pt0,vx,vy,vz,dW,dH,dBodyDepth,nDirFromBeam,0,0);
	dp.draw(bdOutlet);
	
	//Define special case: No box milling needed, instead a hole in center of box
	int bNoBoxMillButHoleMill=false;
	for(int i=0;i<sNoBoxMillButHoleMill.length();i++){
		if(strType.find(sNoBoxMillButHoleMill[i],0)!=-1){
			bNoBoxMillButHoleMill=true;
		}
	}
	
	//Milling
		if (arShOnZone.length() > 0) {
		if ( ! bNoBoxMillButHoleMill) {// Not special case, normal milling needed
			PlaneProfile ppBox = bdOutlet.extractContactFaceInPlane(Plane(ptOrg, vz), U(5));
			ppBox.shrink(-dTolerance);
			PLine plAll[] = ppBox.allRings();
			if (plAll.length() > 0)
			{
				PLine plMill = plAll[0];
				ElemMill mill(nSide, plMill, el.zone(nSide).dH(), nToolingIndex, 0, nTurn, nOShoot);
				el.addTool(mill);
			}
		}
		else{// special case, no box milling needed, instead a hole in middle of box needed
			Point3d ptMillCen=_Pt0;
			ptMillCen+=vx*dW*.5*nDirFromBeam;
			PLine plMill(vz);
			plMill.createCircle(ptMillCen,vz,dSpecialHoleDiameter*.5);		
			ElemMill mill(nSide,plMill,el.zone(nSide).dH(),nToolingIndex,0,nTurn,nOShoot);
			el.addTool(mill);	
		}
	}
		
	//Chase
	if(nChaseDir<0){//Chase is going down
		Point3d ptChaseStart=_Pt0+vx*dChaseRadius*nDirFromBeam-vy*dH*.5;
		Point3d ptChaseEnd=ptChaseStart+vy*(vy.dotProduct(ptInsertionOnBottom-ptChaseStart)-bmBottom.dD(vy)*1.5);
		Body bdChase(ptChaseStart, ptChaseEnd, dChaseRadius);
		dp.draw(bdChase);
		
		arPlDxa.append(PLine(ptChaseStart, ptChaseEnd));
	}
	
	if(nChaseDir>0){//Chase is going up
		Point3d ptChaseStart=_Pt0+vx*dChaseRadius*nDirFromBeam+vy*dH*.5;
		Point3d ptChaseEnd=ptChaseStart+vy*(vy.dotProduct(ptInsertionOnTop-ptChaseStart)+bmTop.dD(vy)*1.5);
		Body bdChase(ptChaseStart, ptChaseEnd, dChaseRadius);
		dp.draw(bdChase);
		
		arPlDxa.append(PLine(ptChaseStart, ptChaseEnd));
	}
	
	PLine plRec;
	plRec.addVertex(_Pt0+ vy * dH/2);
	plRec.addVertex(_Pt0+ vy * dH/2 + vx * nDirFromBeam  * dW);
	plRec.addVertex(_Pt0- vy * dH/2 + vx * nDirFromBeam * dW);
	plRec.addVertex(_Pt0- vy * dH/2);
	plRec.close();

	arPlDxa.append(plRec);
	arPlDxa.append(PLine(_Pt0 + vy * dH / 2, _Pt0 - vy * dH / 2 + vx * nDirFromBeam * dW));
	arPlDxa.append(PLine(_Pt0 - vy * dH / 2, _Pt0 + vy * dH / 2 + vx * nDirFromBeam * dW));
	
}

else if(bIsOctagon){// Octagonal shape

	//Realign along vx
	_Pt0=bmSelected.ptCen()+vx*(bmSelected.dD(vx)*.5+dDistanceFromBm)*nDirFromBeam;

	//Realign along vy
	if(dElevation>0){// Dependent on bottom plate
		_Pt0+=vy*(vy.dotProduct(ptInsertionOnBottom-_Pt0)+dElevation-nReferencePoint*dH*.5);
	}
	else if(dElevation<0){// Dependent on top plate
		_Pt0+=vy*(vy.dotProduct(ptInsertionOnTop-_Pt0)+dElevation-nReferencePoint*dH*.5);	
	}

	//Realign along vz
	_Pt0+=vz*nSide*(bmSelected.dD(vz)*.5-dBodyDepth*.5);
		
	//Octogonal outlet 
	double dOcSide=dH*tan(22.5);//Get side of octagon
	Vector3d vSide=-vy;
	double dAngle=45*nDirFromBeam;
	Point3d ptV;//Every vertex of octagon
	
	PLine plOct(vz);
	plOct.addVertex(_Pt0);
	ptV=_Pt0+vSide*dOcSide*.5;
	plOct.addVertex(ptV);
	vSide=vSide.rotateBy(dAngle,vz);
	ptV=ptV+vSide*dOcSide;
	plOct.addVertex(ptV);
	vSide=vSide.rotateBy(dAngle,vz);
	ptV=ptV+vSide*dOcSide;
	plOct.addVertex(ptV);
	vSide=vSide.rotateBy(dAngle,vz);
	ptV=ptV+vSide*dOcSide;
	plOct.addVertex(ptV);
	vSide=vSide.rotateBy(dAngle,vz);
	ptV=ptV+vSide*dOcSide;
	plOct.addVertex(ptV);
	vSide=vSide.rotateBy(dAngle,vz);
	ptV=ptV+vSide*dOcSide;
	plOct.addVertex(ptV);
	vSide=vSide.rotateBy(dAngle,vz);
	ptV=ptV+vSide*dOcSide;
	plOct.addVertex(ptV);
	vSide=vSide.rotateBy(dAngle,vz);
	ptV=ptV+vSide*dOcSide;
	plOct.addVertex(ptV);
	plOct.close();
	
	Body bdOctagon(plOct,vz*dBodyDepth,0);
	dp.draw(bdOctagon);
	
	arPlDxa.append(plOct);
	
	if(arShOnZone.length()>0){	
		//Milling
		PlaneProfile ppBox=bdOctagon.extractContactFaceInPlane(Plane(ptOrg,vz),U(5));
		ppBox.shrink(-dTolerance);
		PLine plAll[]=ppBox.allRings();
		PLine plMill=plAll[0];
		ElemMill mill(nSide,plMill,el.zone(nSide).dH(),nToolingIndex,0,nTurn,nOShoot);
		el.addTool(mill);	
	}
		
	//Chase
	if(nChaseDir<0){//Chase is going down
		Point3d ptChaseStart=_Pt0+vx*dH*.5*nDirFromBeam-vy*dH*.5;
		Point3d ptChaseEnd=ptChaseStart+vy*(vy.dotProduct(ptInsertionOnBottom-ptChaseStart)-bmBottom.dD(vy)*1.5);
		Body bdChase(ptChaseStart, ptChaseEnd, dChaseRadius);
		dp.draw(bdChase);
		arPlDxa.append(PLine(ptChaseStart, ptChaseEnd));
		
	}
	
	if(nChaseDir>0){//Chase is going up
		Point3d ptChaseStart=_Pt0+vx*dH*.5*nDirFromBeam+vy*dH*.5;
		Point3d ptChaseEnd=ptChaseStart+vy*(vy.dotProduct(ptInsertionOnTop-ptChaseStart)+bmTop.dD(vy)*1.5);
		Body bdChase(ptChaseStart, ptChaseEnd, dChaseRadius);
		dp.draw(bdChase);
		arPlDxa.append(PLine(ptChaseStart, ptChaseEnd));
		
	}

}
_Map.removeAt("mpDisplay" , 1);

for (int p=0;p<arPlDxa.length();p++) 
{ 
	PLine pl = arPlDxa[p]; 
	dpDXA.draw(pl);
	
	_Map.appendPLine("mpDisplay\\pl", pl);
}



/*
//Randy start
Map map;
if(strType==sMicromate){
	map.setPoint3d("DimPoint",_Pt0);
	map.setString("DimText",sNameToExport);
	map.setVector3d("DimVec",-el.vecX()*nDirFromBeam);
}
else{
	map.setPoint3d("DimPoint",_Pt0-el.vecY()*dH/2);
	map.setString("DimText",sNameToExport);
	map.setVector3d("DimVec",-el.vecX()*nDirFromBeam);
}
_Map.setMap("mpRandy", map) ;
*/

addRecalcTrigger(_kContext, "Create Blocking");

if(strType==sDryer || strType==sRange || strType==sValence8 || strType==sValence9 ){
	if(_bOnInsert || _kExecuteKey=="Create Blocking"){
		Point3d ptInsert=_Pt0 - el.vecY()*dH/2*nChaseDir;
		ptInsert=ptInsert.projectPoint(Plane(el.ptOrg(),el.vecZ()),0);
		ptInsert.vis(1);
		double dw=el.dBeamWidth();
	//Create blocks
		Beam bm;
		bm.dbCreate(ptInsert, el.vecX(), el.vecY(), el.vecZ(),dBlockL, U(1.5), dw, nDirFromBeam, -1*nChaseDir, -1);
		bm.setType(_kBlocking);
		bm.setColor(32);
		bm.setHsbId("12");
		//bm.stretchDynamicTo(bmClLeft);
		//bm.stretchDynamicTo(bmClRight);
		bm.assignToElementGroup(el,TRUE,0,'Z');
		//_Beam.append(bm);
	}
}
//Randy end	



///Marking
Mark mk(_Pt0+dH/2*el.vecY(),vx*nDirFromBeam,arNamesToExport[arTypes.find(strType)]);
bmSelected.addTool(mk);


Plane pn(el.ptOrg() + el.vecY() * dElevation, el.vecY());
	
	_Pt0 = Line(_Pt0, el.vecY()).intersect(pn, 0);
	mp.setPoint3d("pt1", _Pt0);
	_Map.setPoint3d("pt1", _Pt0);


















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
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End