#Version 8
#BeginDescription
Electrical Fixtures.
Version 1.8








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
// ##################################################################
// Script		: Corus - Electrical Fixture
// Description	: Adds elecrical fixtures to a circuit within an element.
// Author		: DRT
// Date			: September 2005
// Version		: 1.6
// ------------------------------------------------------------------------------------------------------------------------------------
// Key Assumptions:
// ----------------------------
//
// Inputs:
// -----------
//
// Outputs:
// -------------
// 1. 	TBC
// 
// Changes:
// ---------------
// Date		Version	Change By		Description
// ------------------------------------------------------------------------------------------------------------------------------------
// 9/11/05	1.2			DRT			TSL now added to Zone 7.
// 10/11/05	1.2			DRT			Centre point added to DXA output.
// 10/11/05	1.3			DRT			Radiator fixture added.
// 10/11/05 1.4			DRT			Milling problem fixed.
// 09/10/09 1.5			AJ				Add depth Property
// ##################################################################

// ---------------------------------------------------------------------------------------------------------------------------------------
// Unit Definitions
// ---------------------------------------------------------------------------------------------------------------------------------------
Unit(1,"mm"); // script uses mm

// ---------------------------------------------------------------------------------------------------------------------------------------
// Properties
// ---------------------------------------------------------------------------------------------------------------------------------------
String arSFixtures[0];
String arSCodes[0];
String arSTypes[0];

//String arSSide[]= {T("Left"),T("Right")};
//int arNSide[]={_kLeft, _kRight};
//PropString strSide(0,arSSide,T("Side"));
//int nSideRight= arNSide[arSSide.find(strSide,0)];

// Load library details.
Map mapLibrary;
if (_Map.hasMap("LIBRARY"))
	mapLibrary = _Map.getMap("LIBRARY");
else
{
	mapLibrary.readFromXmlFile(_kPathHsbInstall+"\\Content\\UK\\TSL\\Standard\\Electrical\\electricallibrary.xml");
//	mapLibrary.readFromXmlFile("J:\Company2\HSBSoft\Software Install\hsbCompany FrameUK\Tsl\Catalog\electricallibrary.xml");
}
int i=0;	
while (mapLibrary.hasString("CODE"+i)){
	arSFixtures.append(mapLibrary.getString("DESCRIPTION"+i));
	arSCodes.append(mapLibrary.getString("CODE"+i));
	arSTypes.append(mapLibrary.getString("TYPE"+i));
	i++;
}
PropString sFixture=PropString(1,arSFixtures,"Fixture");
PropString sCircuit=PropString(0,"None","Circuit");
sCircuit.setReadOnly(1);

PropDouble dDepthMill(0, 0,"Milling Depth '0=Automatic'");

String arSTurn[]= {T("Against course"),T("With course")};
int arNTurn[]={_kTurnAgainstCourse, _kTurnWithCourse};
PropString strTurn(2,arSTurn,T("Turning direction"));
int nTurningDirectionWith= arNTurn[arSTurn.find(strTurn,0)];

String arSOShoot[]= {T("No"),T("Yes")};
int arNOShoot[]={_kNo, _kYes};
PropString strOShoot(3,arSOShoot,T("Overshoot"));
int nOverShoot= arNOShoot[arSOShoot.find(strOShoot,0)];

// ---------------------------------------------------------------------------------------------------------------------------------------
// On Insert....
// ---------------------------------------------------------------------------------------------------------------------------------------
if (_bOnInsert) {
	// Prompt user for the position of the fixture.
	double y = getDouble("Height");
	double x = getDouble("Lateral Position");   //getPoint();
	// Prompt user for the electrical circuit the fixture belongs to.
	TslInst circuit = getTslInst(T("Select electrical circuit")); 
	Entity en = circuit;
	_Entity.append(en);
	circuit.entity().append(_ThisInst);
	Element el = circuit.element();
	setDependencyOnEntity(en);
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0 = el.ptOrg()+vx*x+vy*y;
	// No library items? Lets get out of here!!
	if (arSFixtures.length()==0){
		reportMessage("No Electrical Library items found.");
		eraseInstance();
		return;
	}
	showDialog();
	// Save the Library in the TSL.
	_Map=Map();
	_Map.setMap("LIBRARY",mapLibrary);
	return;
}

if (_Entity.length()<1)
{
	eraseInstance();
	return;
}
// Assign this TSL to the element group.
TslInst circuit = (TslInst)_Entity[0];
sCircuit.set(circuit.propString("Circuit Name"));
Entity en[] = circuit.entity();
Element el = (Element)en[0];
_Element.append(el);	
assignToElementGroup(el,TRUE,8,'Z');
//setDependencyOnEntity(circuit);
// Define coordinate system.
CoordSys csEl = el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

Display disp(-1);

double dFixtureHeight = 0;

// Type of routing requird for fixture.
// 0 = None.
// 1 = double back box (135.3 x 75.0)
// 2 = single back box (75.0 x 75.0)
int nRoutingType = 0;

int nFixtureType = 0;

// Constant to add to all milling dimensions.
double dMillingTolerence=1.5;

_Pt0 =_Pt0.projectPoint(Plane(circuit.ptOrg(),vz),0);

// ---------------------------------------------------------------------------------------------------------------------------------------
// Build fixtures
// ---------------------------------------------------------------------------------------------------------------------------------------
String sType = arSTypes[arSFixtures.find(sFixture,0)];
String sCode = arSCodes[arSFixtures.find(sFixture,0)];

// Find outside edge sheeting
int nOutSideZone;
double dZone;
for(int i=1;i<10;i++){
	dZone+=el.zone(i).dH();
	if (el.zone(i).dH()==0){
		nOutSideZone = i-1;
		break;
	}
}
Point3d ptStartPoint = _Pt0.projectPoint(Plane(el.ptOrg()+vz*dZone,vz),0)-vy*U(43);
// ---------------------------------------------------------------------------------------------------------------------------------------
// Double Socket
// ---------------------------------------------------------------------------------------------------------------------------------------
if (sType=="Double Socket"){
	nFixtureType=1;
	// Now Draw Bottom Pin Holes
	PLine plBPin(vz);
	Point3d ptPinStart = ptStartPoint-vx*U(44.5)+vy*U(28)+vz*U(13);  
	plBPin.addVertex(ptPinStart);
	plBPin.addVertex(ptPinStart-vx*U(6.5));
	plBPin.addVertex(ptPinStart-vx*U(6.5)+vy*U(4.5));
	plBPin.addVertex(ptPinStart+vy*U(4.5));
	plBPin.close();
	disp.draw(plBPin);
	CoordSys csMove;
	csMove.setToTranslation(vx*U(22.5));
	plBPin.transformBy(csMove);
	disp.draw(plBPin);
	csMove.setToTranslation(vx*U(50.5));
	plBPin.transformBy(csMove);
	disp.draw(plBPin);
	csMove.setToTranslation(vx*U(22.5));
	plBPin.transformBy(csMove);
	disp.draw(plBPin);
	// Top Pin Holes
	ptPinStart = ptStartPoint-vx*U(36.5)+vy*U(49.5)+vz*U(13); 
	PLine plTPin(vz);
	plTPin.addVertex(ptPinStart);
	plTPin.addVertex(ptPinStart-vx*U(2.25));
	plTPin.addVertex(ptPinStart-vx*U(2.25)+vy*U(8));
	plTPin.addVertex(ptPinStart+vx*U(2.25)+vy*U(8));
	plTPin.addVertex(ptPinStart+vx*U(2.25));
	plTPin.close();
	disp.draw(plTPin);
	csMove.setToTranslation(vx*U(73));
	plTPin.transformBy(csMove);
	disp.draw(plTPin);
	dFixtureHeight = 86;
	// Set Routing Type for Back Box Milling
	nRoutingType = 1;
}
// ---------------------------------------------------------------------------------------------------------------------------------------
// Data and Telephone Socket
// ---------------------------------------------------------------------------------------------------------------------------------------
if (sType=="Telephone/Data Point"){
	nFixtureType=2;
	Point3d ptSwitchStart =_Pt0.projectPoint(Plane(el.ptOrg()+vz*dZone,vz),0)-vy*U(5)-vx*U(17.5)+vz*U(13);
	PLine plSwitch(vz);
	plSwitch.addVertex(ptSwitchStart);
	plSwitch.addVertex(ptSwitchStart-vx*U(12.5));
	plSwitch.addVertex(ptSwitchStart-vx*U(12.5)+vy*U(10));
	plSwitch.addVertex(ptSwitchStart+vx*U(12.5)+vy*U(10));
	plSwitch.addVertex(ptSwitchStart+vx*U(12.5));
	plSwitch.close();
	disp.draw(plSwitch);
	CoordSys csMove;
	csMove.setToTranslation(vx*U(35));
	plSwitch.transformBy(csMove);
	disp.draw(plSwitch);
	dFixtureHeight = 86;
}
// ---------------------------------------------------------------------------------------------------------------------------------------
// Data and Telephone Socket
// ---------------------------------------------------------------------------------------------------------------------------------------
if (sType=="TV Aerial Point"){
	nFixtureType=2;
	PLine plCircle(vz);
	Point3d ptAerialStart = _Pt0.projectPoint(Plane(el.ptOrg()+vz*dZone,vz),0);
	plCircle.createCircle(ptAerialStart+vz*U(13),vz,U(6));
	disp.draw(plCircle);
	dFixtureHeight = 86;
}
// ---------------------------------------------------------------------------------------------------------------------------------------
// Data and Telephone Socket
// ---------------------------------------------------------------------------------------------------------------------------------------
if (sType=="Radiator"){
	PLine plRadiator(vz);
	ptStartPoint = _Pt0.projectPoint(Plane(el.ptOrg()+vz*dZone,vz),0)-vy*U(200);
	plRadiator.addVertex(ptStartPoint);
	plRadiator.addVertex(ptStartPoint-vx*U(300));
	plRadiator.addVertex(ptStartPoint-vx*U(300)+vy*U(400));
	plRadiator.addVertex(ptStartPoint+vx*U(300)+vy*U(400));
	plRadiator.addVertex(ptStartPoint+vx*U(300));
	plRadiator.addVertex(ptStartPoint);
	// Draw Socket
	Body bdRadiator(plRadiator,vz*U(40),U(1));
	disp.draw(bdRadiator);
	dFixtureHeight = 400;
	// Set Routing Type for Back Box Milling
	nRoutingType = 2;
}
// ---------------------------------------------------------------------------------------------------------------------------------------
// Wall Light
// ---------------------------------------------------------------------------------------------------------------------------------------
if (sType=="Light"){
	ptStartPoint = _Pt0.projectPoint(Plane(el.ptOrg()+vz*dZone,vz),0)-vy*U(150);
	nFixtureType=0; // No fixture.
	PLine plLight(vz);
	Point3d ptLightStart = _Pt0.projectPoint(Plane(el.ptOrg()+vz*dZone,vz),0);
	plLight.createCircle(ptLightStart,vz,U(125));
	Body bdLight(plLight,vz*U(25),1);
	disp.draw(bdLight);
	PLine plLight2(vz);	
	plLight2.createCircle(ptLightStart+vz*25,vz,U(150));
	Body bdLight2(plLight2,vz*U(50),1);
	disp.draw(bdLight2);
	dFixtureHeight = U(300);
}
// ---------------------------------------------------------------------------------------------------------------------------------------
// Single Socket
// ---------------------------------------------------------------------------------------------------------------------------------------
if (sType=="Single Socket"){
	nFixtureType=2;
	// Now Draw Bottom Pin Holes
	PLine plBPin(vz);
	Point3d ptPinStart = ptStartPoint-vx*U(8)+vy*U(28)+vz*U(13);  
	plBPin.addVertex(ptPinStart);
	plBPin.addVertex(ptPinStart-vx*U(6.5));
	plBPin.addVertex(ptPinStart-vx*U(6.5)+vy*U(4.5));
	plBPin.addVertex(ptPinStart+vy*U(4.5));
	plBPin.close();
	disp.draw(plBPin);
	CoordSys csMove;
	csMove.setToTranslation(vx*U(22.5));
	plBPin.transformBy(csMove);
	disp.draw(plBPin);
	// Top Pin Holes
	ptPinStart = ptStartPoint+vy*U(49.5)+vz*U(13); 
	PLine plTPin(vz);
	plTPin.addVertex(ptPinStart);
	plTPin.addVertex(ptPinStart-vx*U(2.25));
	plTPin.addVertex(ptPinStart-vx*U(2.25)+vy*U(8));
	plTPin.addVertex(ptPinStart+vx*U(2.25)+vy*U(8));
	plTPin.addVertex(ptPinStart+vx*U(2.25));
	plTPin.close();
	disp.draw(plTPin);
	dFixtureHeight = 86;
}
// ---------------------------------------------------------------------------------------------------------------------------------------
// Single Light Switch
// ---------------------------------------------------------------------------------------------------------------------------------------
if (sType=="Single Light Switch"){
	nFixtureType=2;
	Point3d ptSwitchStart =_Pt0.projectPoint(Plane(el.ptOrg()+vz*dZone,vz),0)-vy*U(12.5)+vz*U(13);
	PLine plSwitch(vz);
	plSwitch.addVertex(ptSwitchStart);
	plSwitch.addVertex(ptSwitchStart-vx*U(5));
	plSwitch.addVertex(ptSwitchStart-vx*U(5)+vy*U(25));
	plSwitch.addVertex(ptSwitchStart+vx*U(5)+vy*U(25));
	plSwitch.addVertex(ptSwitchStart+vx*U(5));
	plSwitch.close();
	disp.draw(plSwitch);
	dFixtureHeight = 86;
}
// ---------------------------------------------------------------------------------------------------------------------------------------
// DoubleLight Switch
// ---------------------------------------------------------------------------------------------------------------------------------------
if (sType=="Double Light Switch"){
	nFixtureType=2;
	Point3d ptSwitchStart =_Pt0.projectPoint(Plane(el.ptOrg()+vz*dZone,vz),0)-vy*U(12.5)-vx*U(10)+vz*U(13);
	PLine plSwitch(vz);
	plSwitch.addVertex(ptSwitchStart);
	plSwitch.addVertex(ptSwitchStart-vx*U(5));
	plSwitch.addVertex(ptSwitchStart-vx*U(5)+vy*U(25));
	plSwitch.addVertex(ptSwitchStart+vx*U(5)+vy*U(25));
	plSwitch.addVertex(ptSwitchStart+vx*U(5));
	plSwitch.close();
	disp.draw(plSwitch);
	CoordSys csMove;
	csMove.setToTranslation(vx*U(20));
	plSwitch.transformBy(csMove);
	disp.draw(plSwitch);
	dFixtureHeight = 86;
}

// ---------------------------------------------------------------------------------------------------------------------------------------
// Connect Fixture to Circuit.
// ---------------------------------------------------------------------------------------------------------------------------------------
PLine plLine;
double dFixtureDistance = vy.dotProduct(_Pt0-_Pt0.projectPoint(Plane(circuit.ptOrg(),vy),0));
//reportMessage(dFixtureDistance);
Point3d ptLineStart = ptStartPoint.projectPoint(Plane(circuit.ptOrg(),vz),0);
if (dFixtureDistance>0)
	plLine = PLine(ptLineStart,ptLineStart.projectPoint(Plane(circuit.ptOrg(),vy),0));
if (dFixtureDistance<0)
	plLine = PLine(ptLineStart+vy*dFixtureHeight,ptLineStart.projectPoint(Plane(circuit.ptOrg(),vy),0));
//(_Pt0,_Pt0.projectPoint(Plane(circuit.ptOrg(),vy),0));
if (abs(dFixtureDistance)>17.5){
	disp.color(3);
	disp.draw(plLine);
	PLine plCircle(vz);
	plCircle.createCircle(ptLineStart.projectPoint(Plane(circuit.ptOrg(),vy),0),vz,U(17.5));
	disp.draw(plCircle);
}

// ---------------------------------------------------------------------------------------------------------------------------------------
// Draw generic fixture types.
// ---------------------------------------------------------------------------------------------------------------------------------------
disp.color(7);
if (nFixtureType==1){
	PLine plDoubleSocket(vz);
	plDoubleSocket.addVertex(ptStartPoint);
	plDoubleSocket.addVertex(ptStartPoint-vx*U(66));
	plDoubleSocket.addVertex(ptStartPoint-vx*U(66)+vy*U(72));
	plDoubleSocket.addVertex(ptStartPoint+vx*U(66)+vy*U(72));
	plDoubleSocket.addVertex(ptStartPoint+vx*U(66));
	plDoubleSocket.addVertex(ptStartPoint);
	// Draw Socket
	Body bdDoubleSocket(plDoubleSocket,vz*U(13),U(1));
	//disp.draw(plDoubleSocket);
	disp.draw(bdDoubleSocket);
	// Set Routing Type for Back Box Milling
	nRoutingType = 1;
}
if (nFixtureType==2){
	PLine plSingleSocket(vz);
	plSingleSocket.addVertex(ptStartPoint);
	plSingleSocket.addVertex(ptStartPoint-vx*U(36));
	plSingleSocket.addVertex(ptStartPoint-vx*U(36)+vy*U(72));
	plSingleSocket.addVertex(ptStartPoint+vx*U(36)+vy*U(72));
	plSingleSocket.addVertex(ptStartPoint+vx*U(36));
	plSingleSocket.addVertex(ptStartPoint);
	// Draw Socket
	Body bdSingleSocket(plSingleSocket,vz*U(13),U(1));
	disp.draw(bdSingleSocket);
	// Set Routing Type for Back Box Milling
	nRoutingType = 2;
}

// ---------------------------------------------------------------------------------------------------------------------------------------
// Mill Out Back Generic Box.
// ---------------------------------------------------------------------------------------------------------------------------------------
if (nRoutingType!=0){
	double x=0;
	double y=0;
	// Double Back Box
	if (nRoutingType==1){
		x = U(67.65+dMillingTolerence);
		y = U(37.5+dMillingTolerence);
	}	
	// Double Back Box
	if (nRoutingType==2){
		x = U(37.5+dMillingTolerence);
		y = U(37.5+dMillingTolerence);
	}	

	// Route through sheeting layers.
	Point3d aPtMill[0];
	PLine plMill(vz);
	plMill.addVertex(_Pt0-vx*x+vy*y);
	plMill.addVertex(_Pt0+vx*x+vy*y);
	plMill.addVertex(_Pt0+vx*x-vy*y);
	plMill.addVertex(_Pt0-vx*x-vy*y);
	plMill.addVertex(_Pt0-vx*x+vy*y);
	// Get milling depth.
	double dMillDepth = 0;
	if (abs(dDepthMill)<0.01)
	{
		for(int i=1;i<=nOutSideZone;i++)
			dMillDepth+=el.zone(i).dH();
	}
	else
	{
		dMillDepth =dDepthMill;
	}
	// Add milling to outside layer but milling through all lower layers.
		
		//ElemMill tool(nOutSideZone, plMill,  dMillDepth,    0,   _kRight,  nTurningDirectionWith,   nOverShoot);
		//el.addTool(tool);
}

// ---------------------------------------------------------------------------------------------------------------------------------------
// Store details of the Bracing Plates and Straps to the DXA structure
// ---------------------------------------------------------------------------------------------------------------------------------------
Map fixtureMap = Map();
fixtureMap.setString("DESCRIPTION", sType);
fixtureMap.setString("CIRCUIT",  circuit.propString("Circuit Name"));
fixtureMap.setString("CODE",  sCode);
Point3d ptCentre = _Pt0.projectPoint(Plane(el.ptOrg()+vz*dZone,vz),0);
fixtureMap.setString("CX",  vx.dotProduct(ptCentre-el.ptOrg()));
fixtureMap.setString("CY",  vy.dotProduct(ptCentre-el.ptOrg()));
fixtureMap.setString("CZ",  vz.dotProduct(ptCentre-el.ptOrg()));
ElemItem fixtureItem(nOutSideZone, T("ELECTRICALFIXTURE"), _Pt0, vz, fixtureMap);
fixtureItem.setShow(_kNo);
el.addTool(fixtureItem);

// Draw Element in debug.
if (_bOnDebug){
	GenBeam arGBm[] = el.genBeam();
	Display dpDebug(-1);
	for(int i=0;i<arGBm.length();i++){
		GenBeam gBm = arGBm[i];
		dpDebug.color(gBm.color());
		dpDebug.draw(gBm.realBody());
	}
}










#End
#BeginThumbnail









#End
