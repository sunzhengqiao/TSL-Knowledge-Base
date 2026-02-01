#Version 8
#BeginDescription
Use to Mill around Window and Door Openings
Select an Element and Enter Properties for Milling
This will also place milling lines on the left and right of an element.











#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------
*  Copyright (C) 2004 by
*  hsbSOFT N.V.
*  THE NETHERLANDS
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT N.V., or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
*
* REVISION HISTORY
* ----------------
*
* Revised: Anno Sportel 041216
* Change:  First revision
*
* Revised: Mick Kelly	
* Change:  Added Mill Lines on Left and Right of Frame
*
* Revised: Anno Sportel 051024	
* Change: Select a set of elements instead of one element.
*
* Revised: Anno Sportel 051024	
* Change: Create a master and slaves.
*
* Revised: Anno Sportel 060517	
* Change: Add options to turn milling lines on and off.
*
* Revised: Anno Sportel 060824	
* Change: Remove a milling tsl if it is already attached to the element.
*
* Revised: Alberto Jena 070926	
* Change: Add property to offset milling around panel.
*
*/

//Script uses inches.

Unit(1,"mm");

String categories[] = { T("|Milling data|"), T("|Dimensions|"), T("|Locations|")};
String modes[] = { T("|Opening|"), T("|Opening where sheets intersect|")};
PropString sMode(12, modes, T("|Milling mode|"), 0);
sMode.setCategory(categories[0]);

//int nLunit = 4; // architectural (only used for beam length, others depend on hsb_settings)
//int nPrec = 3; // precision (only used for beam length, others depend on hsb_settings)
int arNZone[] = { -5, -4, -3, -2, -1, 1, 2, 3, 4, 5};
PropInt nZone(0,arNZone,T("Zone"),5);
nZone.setCategory(categories[0]);

PropInt nToolingIndex(1,1,T("Tooling index"));
nToolingIndex.setCategory(categories[0]);

String arSSide[]= {T("Right"),T("Left")};
PropString strSide(0,arSSide,T("Side"),0);
strSide.setCategory(categories[0]);

String arSTurn[]= {T("Against course"),T("With course")};
PropString strTurn(1,arSTurn,T("Turning direction"),1);
strTurn.setCategory(categories[0]);

String arSOShoot[]= {T("No"),T("Yes")};
PropString strOShoot(2,arSOShoot,T("Overshoot"));
strOShoot.setCategory(categories[0]);

String arSVacuum[]= {T("No"),T("Yes")};
int arNVacuum[]={_kNo, _kYes};
PropString strVacuum(3,arSVacuum,T("Vacuum"),1);
strVacuum.setCategory(categories[0]);

int nVacuum = arNVacuum[arSVacuum.find(strVacuum,0)];
PropDouble millDepth (0,U(9/16),T("Milling Depth"));
millDepth.setCategory(categories[1]);

PropDouble dOffsetOpening(1, U(0), T("Offset milling around opening"));
dOffsetOpening.setCategory(categories[1]);

PropDouble dOffsetTop(2, U(0), T("Offset milling panel top"));
dOffsetTop.setCategory(categories[1]);

PropDouble dOffsetSide(3, U(0), T("Offset milling panel sides"));
dOffsetSide.setCategory(categories[1]);

String arSYesNo[] = {T("Yes"), T("No")};

PropString sMillingOnTop(4, arSYesNo, T("Milling on top"));
sMillingOnTop.setCategory(categories[2]);

PropString sMillingOnTopLeft(5, arSYesNo, T("Milling on top-left"));
sMillingOnTopLeft.setCategory(categories[2]);

PropString sMillingOnLeft(6, arSYesNo, T("Milling on left"));
sMillingOnLeft.setCategory(categories[2]);

PropString sMillingOnBottomLeft(7, arSYesNo, T("Milling on bottom-left"));
sMillingOnBottomLeft.setCategory(categories[2]);

PropString sMillingOnBottom(8, arSYesNo, T("Milling on bottom"));
sMillingOnBottom.setCategory(categories[2]);

PropString sMillingOnBottomRight(9, arSYesNo, T("Milling on bottom-right"));
sMillingOnBottomRight.setCategory(categories[2]);

PropString sMillingOnRight(10, arSYesNo, T("Milling on right"));
sMillingOnRight.setCategory(categories[2]);

PropString sMillingOnTopRight(11, arSYesNo, T("Milling on top-right"));
sMillingOnTopRight.setCategory(categories[2]);

PropDouble dEdgeOffsetFromHole(4, U(0), T("Offset from hole edge"));
dEdgeOffsetFromHole.setCategory(categories[1]);

//Insert done in script
if(_bOnInsert){
	//Select a set of elements
	PrEntity ssE("\nSelect a set of elements",Element());
	if (ssE.go()) { // let the prompt class do its job, only one run
		Entity ents[0]; // the PrEntity will return a list of entities, and not elements
		// copy the list of selected entities to a local array: for performance and readability
		ents = ssE.set(); 

		// turn the selected set into an array of elements
		for (int i=0; i<ents.length(); i++) {
			Element el = (Element)ents[i]; // cast the entity to a element    
			_Element.append(el);
		}
	}

	//Showdialog
	showDialogOnce();
  
	//Return to drawing
	return;
}

//Check if there are elements selected.
if(_Element.length() == 0){eraseInstance(); return;}

String strScriptName = "Assign Milling to Openings (Slave)"; // name of the script
Vector3d vecUcsX(1,0,0);
Vector3d vecUcsY(0,1,0);

Beam lstBeams[0];
Element lstElements[0];
Point3d lstPoints[0];

int lstPropInt[0];
lstPropInt.append(nZone);
lstPropInt.append(nToolingIndex);
double lstPropDouble[0];
lstPropDouble.append(millDepth);
lstPropDouble.append(dOffsetOpening);
lstPropDouble.append(dOffsetTop);
lstPropDouble.append(dOffsetSide);
lstPropDouble.append(dEdgeOffsetFromHole);

String lstPropString[0];
lstPropString.append(strSide);
lstPropString.append(strTurn);
lstPropString.append(strOShoot);
lstPropString.append(strVacuum);
lstPropString.append(sMillingOnTop);
lstPropString.append(sMillingOnTopLeft);
lstPropString.append(sMillingOnLeft);
lstPropString.append(sMillingOnBottomLeft);
lstPropString.append(sMillingOnBottom);
lstPropString.append(sMillingOnBottomRight);
lstPropString.append(sMillingOnRight);
lstPropString.append(sMillingOnTopRight);
lstPropString.append(sMode);

for( int e=0;e<_Element.length();e++ ){
	Element el = _Element[e];
	lstElements.setLength(0);	
	lstElements.append(el);
	
	TslInst arTslAttached[] = el.tslInst();
	for( int i=0;i<arTslAttached.length();i++ ){
		TslInst tslAttached = arTslAttached[i];
		if( tslAttached.scriptName() == strScriptName ){
			tslAttached.dbErase();
		}
	}
		
	TslInst tsl;
	tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints,lstPropInt, lstPropDouble, lstPropString ); // create new instance
}

eraseInstance();
















#End
#BeginThumbnail









#End
#BeginMapX

#End