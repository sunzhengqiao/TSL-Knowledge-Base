#Version 8
#BeginDescription
Corus Electrical Circuit

Version 1.2 - 3/11/2005





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
// ##################################################################
// Script		: Corus - Circuit
// Description	: Adds an electrical circuit to an element.
// Author		: DRT
// Date			: September 2005
// Version		: 1.1
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
// Date		Change By		Description
// ------------------------------------------------------------------------------------------------------------------------------------
//
//
// ##################################################################

// ---------------------------------------------------------------------------------------------------------------------------------------
// Unit Definitions
// ---------------------------------------------------------------------------------------------------------------------------------------
Unit(1,"mm"); // script uses mm

// ---------------------------------------------------------------------------------------------------------------------------------------
// Properties
// ---------------------------------------------------------------------------------------------------------------------------------------
PropDouble dHeight(0,U(1500),"Circuit Height");
PropString sName(0,"Circuit","Circuit Name");
String aSTrim[] = {"Left","Right","Both","None"};
PropString sTrim(1,aSTrim,"Trim",3);
String aSColour[] = {"Red","Yellow","Green","Cyan","Blue","Magenta"};
PropString sColour(2,aSColour,"Colour",2);

// ---------------------------------------------------------------------------------------------------------------------------------------
// On Insert....
// ---------------------------------------------------------------------------------------------------------------------------------------
if (_bOnInsert) {
	_Element.append(getElement("Element"));
	// Make sure we have an element.
	if (_Element.length()==0){
		reportMessage(T("Element must be selected."));
		eraseInstance();
		return;
	}
	// Allow the properties to be chanegd.
	showDialog();
	// Check to see if there are any horizontal beams in the way of the circuit.
	CoordSys csEl = _Element[0].coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	// Cache Beams
	_Beam =  _Element[0].beam();
	Beam arHBeams[] = vy.filterBeamsPerpendicularSort(_Beam);
	for(int j=0;j<arHBeams.length();j++){
		LineBeamIntersect lb1(_Element[0].ptOrg()+vy*dHeight,vx,arHBeams[j]);
		if (lb1.bHasContact()){
			reportMessage(T("Beam in the way of circuit path"));
			eraseInstance();
			return;
		}
	}
	return;
}

// Assign selected element to el.
Element el = _Element[0];
// Assign this TSL to the element group.
assignToElementGroup(el,TRUE,8,'Z');

// Define coordinate system.
CoordSys csEl = el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

Display disp(-1);

// ---------------------------------------------------------------------------------------------------------------------------------------
// 
// ---------------------------------------------------------------------------------------------------------------------------------------

// Get all beams
//Beam arBeams[] = _Beam; //el.beam();

//Find top and bottom plates. Assume top most beam is top and bottom most beam is bottom.
if (_Beam.length()==0)
{
	return;
}
Beam arHBeams[] = vy.filterBeamsPerpendicularSort(_Beam);
Beam bmTop = arHBeams[arHBeams.length()-1];
Beam bmBottom = arHBeams[0];
double dTopBeamHeight = bmTop.dW();
double dBottomBeamHeight = bmBottom.dW();

//disp.draw(scriptName(),_Pt0,vx,vy,1,1);
// Find min and max points on bottom plate.
Point3d ptBottomMinBm = bmBottom.ptRef() + bmBottom.dLMin()*bmBottom.vecX();
Point3d ptBottomMaxBm = bmBottom.ptRef() + bmBottom.dLMax()*bmBottom.vecX();
ptBottomMinBm = ptBottomMinBm.projectPoint(Plane(el.ptOrg(),-vy),0);
ptBottomMaxBm = ptBottomMaxBm.projectPoint(Plane(el.ptOrg(),-vy),0);

// Get all vertical beams.
Beam arAllVBeams[] = vx.filterBeamsPerpendicularSort(_Beam);
Beam arVBeams[0];
for(int i=0;i<arAllVBeams.length();i++){
	double check = vx.dotProduct(arAllVBeams[i].ptCen()-ptBottomMinBm)*vx.dotProduct(ptBottomMaxBm-arAllVBeams[i].ptCen());
      if (check>0)
		arVBeams.append(arAllVBeams[i]);
}

// Put the insertion pointto be the centre of the circuit.

// Add holes into all vertical studs.
Point3d ptCircuitStart = arAllVBeams[0].ptCen().projectPoint(Plane(el.ptOrg(),vy),0)+vy*dHeight-vx*arAllVBeams[0].dD(vx)/2;
ptCircuitStart = ptCircuitStart.projectPoint(Plane(arVBeams[0].ptCen(),vz),0);
Point3d ptCircuitEnd = arAllVBeams[arAllVBeams.length()-1].ptCen().projectPoint(Plane(el.ptOrg(),vy),0)+vy*dHeight+vx*arAllVBeams[arVBeams.length()-1].dD(vx)/2;
ptCircuitEnd = ptCircuitEnd.projectPoint(Plane(arVBeams[0].ptCen(),vz),0);
for(int i=0;i<arVBeams.length();i++){
//	Point3d ptCircuitStart = arVBeams[i].ptCen().projectPoint(Plane(el.ptOrg(),vy),0)+vy*dHeight;
	LineBeamIntersect lb1(ptCircuitStart,vx,arVBeams[i]);
	if (lb1.bHasContact()){
		// See if contact point is actually in the beam...you know, that old infinite beam thing!!
		Point3d ptMinBm = arVBeams[i].ptRef() + arVBeams[i].dLMin()*arVBeams[i].vecX();
		Point3d ptMaxBm = arVBeams[i].ptRef() + arVBeams[i].dLMax()*arVBeams[i].vecX();
		if (vy.dotProduct(ptMaxBm-lb1.pt1())*vy.dotProduct(lb1.pt1()-ptMinBm)>0){
			PLine plHole(vx);
			plHole.createCircle(lb1.pt1(),vx,12);
			disp.draw(plHole);
			lb1.pt1().vis(1);
		}
	}
}
// Read through fixtures and draw a line
//int i=0;
//int j=0;
//TslInst arTSL[] = el.tslInstAttached();
//for(int i=0;i<arTSL.length();i++){
//	TslInst fixture = arTSL[i];
//	if (fixture.scriptName()=="Corus - Electrical Fixture"){
		//disp.draw("X",fixture.ptOrg(),Vector3d(1,0,0),Vector3d(0,0,1),1,1);
		//if (!fixture.element().bIsValid())
		//	fixture.dbErase();
		//else{
		//	fixture.ptOrg().vis(1);
		//	disp.draw("X",fixture.ptOrg(),Vector3d(1,0,0),Vector3d(0,0,1),1,1);
		//	fixture.ptOrg().vis(1);
		//	j++;
		//}

	//}/
//	}
//}

//disp.draw(_ThisInst.handle(),_Pt0,Vector3d(1,0,0),Vector3d(0,0,1),1,1);

//Point3d ptCircuitStart = arAllVBeams[0].ptCen().projectPoint(Plane(el.ptOrg(),vy),0)+vy*dHeight-vx*arAllVBeams[0].dD(vx)/2;;
//ptCircuitStart = ptCircuitStart.projectPoint(Plane(arVBeams[0].ptCen(),vz),0);
//Point3d ptCircuitEnd = arAllVBeams[arAllVBeams.length()-1].ptCen().projectPoint(Plane(el.ptOrg(),vy),0)+vy*dHeight+vx*arAllVBeams[arVBeams.length()-1].dD(vx)/2;
//ptCircuitEnd = ptCircuitEnd.projectPoint(Plane(arVBeams[0].ptCen(),vz),0);
//Drill drill(ptCircuitStart,ptCircuitEnd,20);
//int nNrOfBeams = drill.addMeToGenBeamsIntersect(arVBeams);
//disp.draw("Beams: "+nNrOfBeams,_Pt0,vx,vy,1,1);
//ptCircuitStart.vis(1);
//ptCircuitEnd.vis(1);

// Perform any requested trimming of the curcuit.
// Trimming is ending the circuit at the last fixture.
// Find min and max fixture positions.
double dMin = 9999999;
double dMax = -9999999;
TslInst ti[] = el.tslInst();
for(int i=0;i<ti.length();i++){
	// See if we have a TSL.
	TslInst t = ti[i];
	if (t.scriptName()=="hsbCAD_Electrical Fixture" && t.propString("Circuit")==sName){
		double dDistance = vx.dotProduct(t.ptOrg()-ptCircuitStart);
		if (dDistance<dMin)
			dMin = dDistance;
		if (dDistance>dMax)
			dMax = dDistance;
	}
}
// Calculate start and end points for the circuit line depending on the Trim settings.
Point3d ptOriginalStart(ptCircuitStart);
if ((sTrim=="Left" || sTrim=="Both") && dMin!=9999999){
	ptCircuitStart = ptOriginalStart + vx*dMin;
}
if ((sTrim=="Right"  || sTrim=="Both") && dMax!=-9999999){
	ptCircuitEnd = ptOriginalStart + vx*dMax;
}

// Create Circuit Line
PLine plCircuit(ptCircuitStart,ptCircuitEnd);
int nCircuitColour = aSColour.find(sColour,2)+1;
disp.color(nCircuitColour); // Display circuit in green.
disp.draw(plCircuit);
_Pt0 = plCircuit.ptMid();

disp.draw(sName,_Pt0,vx,vy,1,1);

// ---------------------------------------------------------------------------------------------------------------------------------------
// Store details of the Bracing Plates and Straps to the DXA structure
// ---------------------------------------------------------------------------------------------------------------------------------------
Map circuitMap = Map();
circuitMap.setString("DESCRIPTION", sName);
circuitMap.setString("HEIGHT",  dHeight);
circuitMap.setString("TRIM",sTrim);
circuitMap.setString("STARTX",  vx.dotProduct(ptCircuitStart-el.ptOrg()));
circuitMap.setString("STARTY",  vy.dotProduct(ptCircuitStart-el.ptOrg()));
circuitMap.setString("STARTZ",  vz.dotProduct(ptCircuitStart-el.ptOrg()));
circuitMap.setString("ENDX",  vx.dotProduct(ptCircuitEnd-el.ptOrg()));
circuitMap.setString("ENDY",  vy.dotProduct(ptCircuitEnd-el.ptOrg()));
circuitMap.setString("ENDZ",  vz.dotProduct(ptCircuitEnd-el.ptOrg()));
ElemItem circuitItem(0, T("ELECTRICALCIRCUIT"), _Pt0, vz, circuitMap);
circuitItem.setShow(_kNo);
el.addTool(circuitItem);

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
