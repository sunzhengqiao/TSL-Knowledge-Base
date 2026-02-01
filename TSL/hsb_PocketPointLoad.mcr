#Version 8
#BeginDescription
#Versions:
2.21 09.09.2022 HSB-16007: Investigate the bottom beam from the body intersection  Author: Marsel Nakuci
2.20 07.09.2022 HSB-16007: fix when investigating splitted bottom plate Author: Marsel Nakuci
2.19 11.11.2021 HSB-12683: property to cut top/bottom plate active also for point load, not only for pocket load Author: Marsel Nakuci
2.18 02.07.2021 HSB-12452: use GA-T and insert Cullen, LAB, 180 at the outside beams Author: Marsel Nakuci
HSB-5614: Add properties: Inset angle brackets, Name outside beams, Color outside beams
HSB-5152: Creates studs for pockets or point loads over multiple stories.

Modified by: Alberto Jena (alberto.jena@hsbcad.com)
Date: 05.02.2021 - version 2.16



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 21
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT 
*  IRELAND
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* #Versions:
// 2.21 09.09.2022 HSB-16007: Investigate the bottom beam from the body intersection  Author: Marsel Nakuci
// 2.20 07.09.2022 HSB-16007: fix when investigating splitted bottom plate Author: Marsel Nakuci
// Version 2.19 11.11.2021 HSB-12683: property to cut top/bottom plate active also for point load, not only for pocket load Author: Marsel Nakuci
// Version 2.17 02.07.2021 HSB-12452: use GA-T and insert Cullen, LAB, 180 at the outside beams Author: Marsel Nakuci
*
* Create by: Alberto Jena (aj@hsb-cad.com)
* date: 16.06.2011
* version 1.0: Release Version
*
* date: 22.07.2011
* version 2.0: Release Version
*
* date: 29.11.2011
* version 2.1: If only one beam is created then it wont add any module
*
* date: 02.12.2011
* version 2.2: Make the module codes unique in diferent elements
*
* date: 20.01.2012
* version 2.3: Add properties to specify the code of the beams that are created
*
* date: 26.01.2012
* version 2.4: Bugfix when the beam half intersect the bottom plate
*
* date: 30.01.2012
* version 2.5: Add Tolerance to Beams with Code H 3mm if it's one or 5mm if more
*
* date: 11.07.2012
* version 2.7: Add the area of the pocket as a no valid area for the insulation
*
* date: 03.02.2014
* version 2.9: Recalculate Nailing and Frame nailing after this TSL is recalculated. Valid only since version 18.2.26
*
* date: 03.02.2014
* version 2.13: Add Usage value inside of the MapX of the beams created, so other TSL can know that those beams are part of a pointload
*
* date: 23.07.2019
* version 2.14: HSB-5152: Generate studs between top beam of the wall and the header of an opening
*
* date: 18.09.2019
* version 2.15: HSB-5614: Add properties: Inset angle brackets, Name outside beams, Color outside beams
*
* date: 05.02.2021
* version 2.16: If the user uses the option to set a module then even if there is only one beam created it will have module information.
*/

Unit(1,"mm"); // script uses mm

String sArNY[] = {T("No"), T("Yes")};

double dTolerance=U(1);

String sPath= _kPathHsbCompany+"\\Abbund\\Materials.xml";

String sFind=findFile(sPath);

if (sFind=="")
{
	reportNotice("\n Materials not been set, please run hsbMaterial Utility or contact SupportDesk");
	eraseInstance();
	return;
}

Map mp;
mp.readFromXmlFile(sPath);

String sMaterials[0];

if (mp.hasMap("MATERIAL[]"))
{
	Map mpMaterials=mp.getMap("MATERIAL[]");
	for(int i=0; i<mpMaterials.length(); i++)
	{
		Map mpMaterial=mpMaterials.getMap(i);
		if (mpMaterial.getString("MATERIAL")!="DEFAULT")
			sMaterials.append(mpMaterial.getString("MATERIAL"));
	}
}

PropInt nBmQty(0,3,T("Number of beams")); //Valid for pointload, will be calculated for the pocket
PropDouble dBmWidth(0,U(0),T("Timber width, 0=auto"));

//Alignment
String arSAlign[] = {"Left", "Center", "Right"};
int arNAlign[] = {0, 1, 2};
PropString sAlign(0, arSAlign, T("Alignment"),1);

//Pocket Properties
PropDouble dPocketBaseHeight(4, U(1500), T("Pocket Base Height"));
dPocketBaseHeight.setCategory(T("Pocket Options"));
PropDouble dPocketWidth(5, U(0), T("Pocket Width, 0=none"));
dPocketWidth.setCategory(T("Pocket Options"));
PropDouble dPocketHeight(6, U(250), T("Pocket Height"));
dPocketHeight.setCategory(T("Pocket Options"));

PropDouble dSillWidth(1,U(0),T("Pocket Sill Width, 0=none"));
dSillWidth.setCategory(T("Pocket Options"));
PropDouble dTransomWidth(2,U(0),T("Pocket Transom Width, 0=none"));
dTransomWidth.setCategory(T("Pocket Options"));
PropDouble dTransomGap(3,U(0),T("Transom Top Gap"));
dTransomGap.setCategory(T("Pocket Options"));

PropString sTransferLoad(1, sArNY, T("Transfer Load with Cripples"),0);

PropString sSplitTopPlate(2, sArNY, T("Split Top Plate"),0);

PropString sSplitBottomPlate(3, sArNY, T("Split Bottom Plate"),0);

PropString sCreateModule(5, sArNY, T("Create Beams as Modules"),0);

String sCncCatalogues[]={"None"};
String cncScriptName = "hsbCNC";
String hsbCncCatalogues[] = TslInst().getListOfCatalogNames(cncScriptName);
sCncCatalogues.append(hsbCncCatalogues);
PropString sCncCatalogue(18, sCncCatalogues, T("|Apply cnc tool|"), 0);

PropString sDimStyle(4, _DimStyles, T("Select Dim Style"));


PropString sNameStud (6, "STUD", T("Name Studs"));
sNameStud.setCategory(T("Beam Properties Studs"));
PropString sMaterialStud (7, sMaterials, T("Material Studs"));
sMaterialStud.setCategory(T("Beam Properties Studs"));
PropString sGradeStud (8, "C16", T("Grade Studs"));
sGradeStud.setCategory(T("Beam Properties Studs"));
PropString sCodeStud (15, "", T("Beam Code Studs"),0);
sCodeStud.setCategory(T("Beam Properties Studs"));

PropString sNameSill (9, "SILL", T("Name Pocket Sill"));
sNameSill.setCategory(T("Beam Properties Pocket Sill"));
PropString sMaterialSill (10, sMaterials, T("Material Pocket Sill"));
sMaterialSill.setCategory(T("Beam Properties Pocket Sill")); 
PropString sGradeSill (11, "C16", T("Grade Pocket Sill"));
sGradeSill.setCategory(T("Beam Properties Pocket Sill"));
PropString sCodeSill (16, "", T("Beam Code Sill"),0);
sCodeSill.setCategory(T("Beam Properties Pocket Sill"));

PropString sNameTransom (12, "TRANSOM", T("Name Pocket Transom"));
sNameTransom.setCategory(T("Beam Properties Pocket Transom"));
PropString sMaterialTransom (13, sMaterials, T("Material Pocket Transom"));
sMaterialTransom.setCategory(T("Beam Properties Pocket Transom"));
PropString sGradeTransom (14, "C16", T("Grade Pocket Transom"));
sGradeTransom.setCategory(T("Beam Properties Pocket Transom"));
PropString sCodeTransom (17, "", T("Beam Code Transom"),0);
sCodeTransom.setCategory(T("Beam Properties Pocket Transom"));

PropInt nColor(1, 3, T("Beam Color"));

// angle bracket
String sAngleBracketsName=T("|Insert Angle Brackets|");	
String sAngleBracketsOptions[] ={ "No", "Bottom", "Top", "Both"};
PropString sAngleBrackets(19, sAngleBracketsOptions, sAngleBracketsName);	
sAngleBrackets.setDescription(T("|Defines the Angle Brackets|"));
sAngleBrackets.setCategory("Outside beams");

String sAngleBracketsLocation=T("|Angle Brackets Location|");	
String sAngleBracketsLocationOptions[] ={ "Left", "Right", "Both"};
PropString sAngleBracketsLocations(21, sAngleBracketsLocationOptions, sAngleBracketsLocation);	
sAngleBracketsLocations.setDescription(T("|Defines the Angle Bracket Location|"));
sAngleBracketsLocations.setCategory("Outside beams");

// name outside beams
String sNameOutsideBeamsName=T("|Name Outside Beams|");	
PropString sNameOutsideBeams(20, "", sNameOutsideBeamsName);	
sNameOutsideBeams.setDescription(T("|Defines the Name of Outside Beams|"));
sNameOutsideBeams.setCategory("Outside beams");

// color outside beams
String sColorOutsideBeamsName=T("|Color Outside Beams|");	
//int nColorOutsideBeamss[]={1,2,3};
PropInt nColorOutsideBeams(2,-3, sColorOutsideBeamsName);	
nColorOutsideBeams.setDescription(T("|Defines the Color of Outside Beams|"));
nColorOutsideBeams.setCategory("Outside beams");


/*
//Milling Properties if pocket
PropDouble dMillDepth(7,U(10),T("Milling depth"));
PropInt nToolingIndex(1,0,T("Tooling index"));
String arSSide[]= {T("Left"),T("Right")};
int arNSide[]={_kLeft, _kRight};
PropString strSide(4,arSSide,T("Side"),0);

String arSTurn[]= {T("Against course"),T("With course")};
int arNTurn[]={_kTurnAgainstCourse, _kTurnWithCourse};
PropString strTurn(5,arSTurn,T("Turning direction"),0);

String arSOShoot[]= {T("No"),T("Yes")};
int arNOShoot[]={_kNo, _kYes};
PropString strOShoot(6,arSOShoot,T("Overshoot"),0);

String arSVacuum[]= {T("No"),T("Yes")};
int arNVacuum[]={_kNo, _kYes};
PropString strVacuum(7,arSVacuum,T("Vacuum"),0);
*/



// Load the values from the catalog
if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

int nAlign = arNAlign[arSAlign.find(sAlign,1)];
//int nSide = arNSide[arSSide.find(strSide,0)];
//int nTurn = arNTurn[arSTurn.find(strTurn,0)];
//int nOShoot = arNOShoot[arSOShoot.find(strOShoot,0)];
//int nVacuum = arNVacuum[arSVacuum.find(strVacuum,0)];
int bTransferLoad = sArNY.find(sTransferLoad,0);
int bTopPlate = sArNY.find(sSplitTopPlate,0);
int bBottomPlate = sArNY.find(sSplitBottomPlate,0);
int bModule = sArNY.find(sCreateModule,0);

if (_bOnInsert) {
	//Getting walls	
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE(T("Please select Elements"),ElementWall());
 	if (ssE.go())
	{
 		Element ents[0];
 		ents = ssE.elementSet();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			ElementWall el = (ElementWall) ents[i];
 			_Element.append(el);
 		 }
 	}

	if(_Element.length()==0){
		eraseInstance();
		return;
	}
	
	PrEntity ssE2(T("Select a beam, enter to pick a point"), Beam());
 	if (ssE2.go())
	{
 		Beam ents[0];
 		ents = ssE2.beamSet();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			Beam bm = (Beam) ents[i];
 			_Beam.append(bm);
			_Pt0=bm.ptCen();
			//break;
 		 }
 	}
	
	//_Beam.append(getBeam("Select a beam, enter to pick a point"));
	if(_Beam.length()==0)
	{
		_Pt0=getPoint(T("Pick a reference point to create Pocket/Pointload"));
	}
	
	return;
}	

if (_Element.length() == 0)
{
	reportMessage(T("No selected walls. TSL will be deleted"));
	eraseInstance(); 
	return; 
}
//return
// Find among all the _Element entries the element which is closest to _Pt0.

// The _bOnElementListModified will be TRUE after wall-splitting-in-length, or integrate tsl as tooling to element.

if (_bOnElementListModified && (_Element.length()>1)) // at least 2 items in _Element array
{
	// now find closest among these elements, for that project the point into the XY plane of each element
	
	int nIndexWinner = -1;
	double dDistWinner;
	
	for (int e=0; e<_Element.length(); e++)
	{
		Element elE = _Element[e];
		CoordSys csElE = elE.coordSys(_Pt0);
	
		Point3d ptE = csElE.ptOrg(); // project point into XY plane of elE
		PlaneProfile ppEn = PlaneProfile(elE.plEnvelope());
	
		// but if point is not inside the envelope, find the closest point on the envelope
		if (ppEn.pointInProfile(ptE)!=_kPointInProfile) ptE = ppEn.closestPointTo(ptE);
	
		double dDistE = Vector3d(ptE-_Pt0).length();
	
		if (nIndexWinner==-1 || dDistE<=dDistWinner)
		{
			nIndexWinner = e;
			dDistWinner = dDistE;
		}
	}
	
	if (nIndexWinner>0) // the new winner is has not index 0 (or -1)
	{
		Element elNew = _Element[nIndexWinner];
		Element elOld = _Element[0];
		reportMessage("\n"+scriptName()+" moved from "+elOld.number()+ " to "+elNew.number());
		_Element[0] = elNew; // overwrite 0 entry will replace the existing reference to elem0
	}
}

//Sort the elements from top to bottom
//Sorting elements from highest to lowest. Highest wall will set if lateral timbers are needed
for(int i=0;i<_Element.length()-1;i++)
	for(int j=i+1;j<_Element.length();j++)
		if(_Element[i].ptOrg().Z()<_Element[j].ptOrg().Z())
		{
			Element elTmp=_Element[j];
			_Element[j]=_Element[i];
			_Element[i]=elTmp;
		}

//Type 0=pocket 1=pointload
int nType=0;

//Get the vector of one element to use it as reference for the calculation of the area of the poinload
Element elRef = _Element[0];
CoordSys csElRef = elRef.coordSys();
Vector3d vxRef=csElRef.vecX();
Vector3d vyRef=csElRef.vecY();
Vector3d vzRef=csElRef.vecZ();

int bBeamSelected=false;
Body bdBm;
Vector3d vxBody;
Vector3d vyBody;

//double dPLWidth;

Plane plnRef(_Pt0, elRef.vecZ());
Plane plnPL(_Pt0, _ZW);
PlaneProfile ppBeamOrg (plnPL);
PlaneProfile ppAllBeams[0];

if (dBmWidth==0)
{
	if (elRef.dBeamWidth()>elRef.dBeamHeight())
	{
		dBmWidth.set(elRef.dBeamHeight());
	}
	else
	{
		dBmWidth.set(elRef.dBeamWidth());
	}
}

Map mpForSubMapX;
mpForSubMapX.setString("Usage", "PointLoad");

if (_Beam.length() > 0) //Pocket with beam
{
	bBeamSelected=true;
	PlaneProfile ppBeams;
	Plane pln;
	double dLen;
	
	//Loop all the beams and get the shape to create a body that combine all the beams;
	for(int i=0; i<_Beam.length(); i++)
	{
		Beam bmThis = _Beam[i];
		bdBm=bmThis.envelopeBody(false, true);
		if (i==0)
		{
			pln = Plane (bmThis.ptCen(), bmThis.vecX());
			vxBody=bmThis.vecX();
			dLen=bmThis.solidLength();
			
			Vector3d vzBody=bmThis.vecD(_ZW);
			vyBody=vzBody.crossProduct(vxBody);

			ppBeams=bdBm.getSlice(pln);
		} 
		ppBeams.unionWith(bdBm.getSlice(pln));
		//PlaneProfile ppThisBm(pln);
	}
	
	ppBeams.shrink(-U(10));
	ppBeams.shrink(U(10));
	//ppBeams.vis(1);
	//Set the first ring to be the body for your pocket
	PLine plAllRings[]=ppBeams.allRings();
	//double dPLWidth;
	if (plAllRings.length()>0)
	{
		bdBm=Body(plAllRings[0], vxBody*dLen, 0);
		_Pt0 = bdBm.ptCen();
		//Set the no valid area for the insulation TSL
		PlaneProfile ppThisRing(pln);
		ppThisRing.joinRing(plAllRings[0], false);
		ppThisRing.shrink(-U(30));
		PLine plNoValidArea[]=ppThisRing.allRings();
		_Map.setPLine("noinsulation", plNoValidArea[0]);
		
		//LineSeg ls1=ppThisRing.extentInDir(vyBody);
		//dPLWidth=abs(vyBody.dotProduct(ls1.ptStart()-ls1.ptEnd()));

	}
	else
	{
		reportNotice("\n"+T("The beam shape couldn't be created"));
	}
	
	ppBeamOrg=bdBm.shadowProfile(plnPL);
	ppAllBeams.append(ppBeamOrg);
}
else //Pocket without beam ot pointload
{
	double dWidthBeams=dBmWidth*nBmQty;
	if (dPocketWidth>U(1))//Pocket
	{
		dWidthBeams=dPocketWidth;
	}
	else//Pointload
	{
		dWidthBeams=dBmWidth*nBmQty;
		nType=1;
	}
	//Create a plan in the first element and project the selected point to that plane
	Line ln (elRef.ptOrg(), elRef.vecX());
	_Pt0=ln.closestPointTo(_Pt0);
	
	//Create a plane profile with the shape size of the pointload	
	Point3d ptLeft=_Pt0-(vxRef*dWidthBeams)*0.5;;
	Point3d ptRight=_Pt0+(vxRef*dWidthBeams)*0.5;
	int nSide=0;
	if (nAlign==0)//Left
	{
		ptLeft.transformBy(-vxRef*(dWidthBeams*0.5));
		ptRight.transformBy(-vxRef*(dWidthBeams*0.5));
		nSide=-1;
	}
	if (nAlign==2)//Right
	{
		ptLeft.transformBy(vxRef*(dWidthBeams*0.5));
		ptRight.transformBy(vxRef*(dWidthBeams*0.5));
		nSide=1;
	}
	//ptLeft.transformBy(vyRef*dPocketBaseHeight);
	//ptRight.transformBy(vyRef*dPocketBaseHeight);
	
	//ptLeft.vis();
	//ptRight.vis();
	
	if (nType==1)//Pointload
	{
		bdBm=Body(ptLeft, vxRef, vyRef, vzRef, dBmWidth*nBmQty,U(20), U(500), 1, 1, 0);
	}
	else//Pocket
	{
		ptLeft.transformBy(vyRef*dPocketBaseHeight);
		ptRight.transformBy(vyRef*dPocketBaseHeight);
		bdBm=Body(ptLeft, vzRef, vyRef, -vxRef, U(500), dPocketHeight, dPocketWidth, 0, 1, -1);
		
		//Set the no valid area for the insulation TSL
		PlaneProfile ppThisRing(plnRef);
		ppThisRing=bdBm.getSlice(plnRef);
		ppThisRing.shrink(-U(30));
		PLine plNoValidArea[]=ppThisRing.allRings();
		if(plNoValidArea.length() > 0)
		{
			_Map.setPLine("noinsulation", plNoValidArea[0]);
		}
	}
	
	LineSeg ls (ptLeft+vzRef*U(300), ptRight-vzRef*U(300));
	PLine plPL(_ZW);
	plPL.createRectangle(ls, vxRef, -vzRef);
	ppBeamOrg.joinRing(plPL, false);
	ppAllBeams.append(ppBeamOrg);
}

//Check the elements that are valid with that point Area
//Element elToPL[0];

//Loop the elements to see what of them are valid on the current location

/*for(int e=0;e<_Element.length();e++)
{
	Element el=_Element[e];
	
	//PLine plEl=el.plOutlineWall();
	PlaneProfile ppEl(el.plOutlineWall());
	//ppEl.joinRing(plEl, false);
	ppEl.intersectWith(ppBeam);
	
	if ((ppEl.area()/(U(1)*U(1)))>U(5))
	{
		//This element have to be pointload
		elToPL.append(el);
	}
}*/


//Beam bm=_Beam[0];

//double dBmW[0];
//int nBm[0];
//Point3d ptLocPL[0];

//dBmW.append(dBmWidth);
//nBm.append(nBmQty);
//ptLocPL.append(_Pt0);

double dSideTolerance=U(2);

double dPLWidth;

Element elLeft[0];
elLeft.append(_Element);



//Remove
Beam bmCreated[0];


for (int i=0; i<_Map.length(); i++)
{
	if(_Map.hasEntity("bm"+i))
	{
		Entity ent = _Map.getEntity("bm"+i);
		ent.dbErase();
	}
}

//if(_Map.hasEntity("bmToSplit")){
// Entity ent1 = _Map.getEntity("bmToSplit");
//  Beam bm1 = (Beam)ent1;
//  Entity ent2 = _Map.getEntity("bmSplitted");
//  Beam bm2 = (Beam)ent2;
//  bm1.dbJoin(bm2);
//}

//return;
// do for each element
for(int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	CoordSys csEl = el.coordSys();
	Vector3d vx=csEl.vecX();
	Vector3d vy=csEl.vecY();
	Vector3d vz=csEl.vecZ();

	//Calculate the profile from top
	PlaneProfile ppEl(el.plOutlineWall());
	
	PlaneProfile ppDraw[0];
	
	double dBmW=el.dBeamWidth();
	double dBmH=el.dBeamHeight();

	if (dBmW>dBmH)
	{
		dBmW=el.dBeamHeight();
		dBmH=el.dBeamWidth();
	}
	
	//Get all the beam and calculate which ones can not be deleted
	Beam bmAll[]=el.beam();
	if (bmAll.length()==0)
		continue;
	
	Sheet shZone1[]=el.sheet(1);
	Sheet shZone6[]=el.sheet(-1);
	
	Point3d ptExtremeSheets[0];
	//Zone1
	for(int i=0; i<shZone1.length(); i++)
	{
		PlaneProfile ppSh=shZone1[i].profShape();
		ptExtremeSheets.append(ppSh.getGripVertexPoints());
	}
	//Zone -1
	for(int i=0; i<shZone6.length(); i++)
	{
		PlaneProfile ppSh=shZone6[i].profShape();
		ptExtremeSheets.append(ppSh.getGripVertexPoints());
	}

	Plane plnY(el.ptOrg(), vy);
	Plane plnZ(el.ptOrg(), vz);
	// vertical beams
	Beam bmVer[]= vx.filterBeamsPerpendicularSort(bmAll);
	Beam bmFix[0];
	Beam bmTopPlate[0];
	Beam bmBottomPlate[0];
	Beam bmCripples[0];
	Beam bmBlocking[0];
	Beam bmToCheckDeletion[0];
	
	PlaneProfile ppTopPlate(plnZ);
	PlaneProfile ppBottomPlate(plnZ);
	
	
	//Check if there is any beam required to notch, indicated by Beamcode H in Token Position 0
	Beam bmWithTool[0];
		
	for(int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		int nBmType=bm.type();
		if (nBmType==_kSFTopPlate || nBmType==_kSFAngledTPLeft || nBmType==_kSFAngledTPRight || nBmType==_kSFVeryTopPlate) 
		{
			Body bd=bm.envelopeBody(false, true);
			bmTopPlate.append(bm);
			PlaneProfile ppAux=bd.shadowProfile(plnZ);
			ppTopPlate.unionWith(ppAux);
		}
		else if (nBmType==_kSFBottomPlate)
		{
			Body bd=bm.realBody();
			bmBottomPlate.append(bm);
			PlaneProfile ppAux=bd.shadowProfile(plnZ);
			ppBottomPlate.unionWith(ppAux);
		}
		else if (nBmType== _kSFSupportingBeam)
		{
			Body bd=bm.realBody();
			bmCripples.append(bm);
		}
		else if (nBmType== _kSFBlocking)
		{
			bmBlocking.append(bm);
		}
		
		//Check if there is any beam required to notch, indicated by Beamcode H in Token Position 0
		if (bm.beamCode().token(0)=="H")
		{
			bmWithTool.append(bm);
		}
	}
	
	PlaneProfile ppFix(plnY);
	PlaneProfile ppFixFront(plnZ);
	
	for(int i=0; i<bmVer.length(); i++)
	{
		Beam bm=bmVer[i];
		Point3d ptBmCen=bm.ptCen();
		int nEdge=false;
		int nBmType=bm.type();
		String sModule=bm.module();
		for(int j=0; j<ptExtremeSheets.length(); j++)
		{
			if (abs(vx.dotProduct(ptBmCen-ptExtremeSheets[j])) < ((bm.dD(vx)*0.5)+U(2)))
			{
				nEdge=true;
				break;
			}
		}
		if (nEdge || sModule!="" || nBmType==_kSFStudRight || nBmType==_kSFStudLeft) 
		{
			bmFix.append(bm);
			Body bd=bm.realBody();
			PlaneProfile ppAux=bd.shadowProfile(plnY);
			PlaneProfile ppAux2=bd.shadowProfile(plnZ);
			ppFix.unionWith(ppAux);
			ppFixFront.unionWith(ppAux2);
		}
		else
		{
			bmToCheckDeletion.append(bm);
		}
	}
	
	ppFix.intersectWith(ppEl);
	ppFix.shrink(-U(1));
	//ppFix.vis(2);
	//Create a plane profile array with the size  of all the modules that are openings and the supporting beams around
	Opening opAll[]=el.opening();
	
	//int nCrippleLeft[0];
	//int nCrippleRight[0];
	//double dSizeCLeft[0];
	//double dSizeCRight[0];
	PlaneProfile ppAllOpenings[0];
	PlaneProfile ppCrippleLeft[0];
	PlaneProfile ppCrippleRight[0];
	OpeningSF opSorted[0];
	Point3d ptCenterOp[0];
	for (int o=0; o<opAll.length(); o++)
	{
		OpeningSF op= (OpeningSF) opAll[o];
		if (!op.bIsValid()) continue;
		
		PLine plOp=op.plShape();
		Point3d ptOpCen;
		ptOpCen.setToAverage(plOp.vertexPoints(true));
		ptCenterOp.append(ptOpCen);
		Point3d ptLengthOp[]=plOp.intersectPoints(ptOpCen, vx);
		Point3d ptOpLeft=ptLengthOp[0];
		Point3d ptOpRight=ptLengthOp[ptLengthOp.length()-1];
		ptOpLeft=ptOpLeft-vx*(op.dGapSide()+((op.numBeamsSupport())*dBmW));
		ptOpRight=ptOpRight+vx*(op.dGapSide()+((op.numBeamsSupportRight())*dBmW));
		PLine plOpPlan(vy);
		plOpPlan.createRectangle(LineSeg(ptOpLeft+vz*U(300)-vx*(op.numBeamsNoSupport()*dBmW), ptOpRight-vz*U(300)+vx*(op.numBeamsNoSupport()*dBmW)), vx, -vz);
		PlaneProfile ppOpPlan(plOpPlan);
		ppOpPlan.intersectWith(ppEl);
		ppAllOpenings.append(ppOpPlan);
		//Cripple Left
		PLine plOpCrippleL(vy);
		plOpCrippleL.createRectangle(LineSeg(ptOpLeft+vz*U(100), ptOpLeft-vz*U(100)+vx*(dBmW*op.numBeamsSupport())), vx, -vz);
		PlaneProfile ppOpCrippleL(plOpCrippleL);
		ppOpCrippleL.intersectWith(ppEl);
		ppOpCrippleL.shrink(U(0.5));
		ppCrippleLeft.append(ppOpCrippleL);
		//Cripple Right
		PLine plOpCrippleR(vy);
		plOpCrippleR.createRectangle(LineSeg(ptOpRight+vz*U(100), ptOpRight-vz*U(100)-vx*(dBmW*op.numBeamsSupportRight())), vx, -vz);
		PlaneProfile ppOpCrippleR(plOpCrippleR);
		ppOpCrippleR.intersectWith(ppEl);
		ppOpCrippleR.shrink(U(0.5));
		ppCrippleRight.append(ppOpCrippleR);
		
		opSorted.append(op);
		//nCrippleLeft.append(op.numBeamsSupport());
		//nCrippleRight.append(op.numBeamsSupportRight());
	}
	
	PlaneProfile ppNewAreas[0];
	int nRemoveAtIndex[0];
	
	for (int n=0; n<ppAllBeams.length(); n++)
	{
		Beam bmCreatedThisWall[0];
		
		PlaneProfile ppBeam=ppAllBeams[n];
		//ppBeam.vis(n);
		
		int nNewAlign=0;
		
		//Calculate the profile from top
		//PLine plEl=el.plOutlineWall();
		PlaneProfile ppEl(el.plOutlineWall());
		//ppEl.joinRing(plEl, false);
		ppEl.intersectWith(ppBeam);
		
		Point3d ptBmCen = bdBm.ptCen();
		Vector3d vBeamDir=el.ptOrg()-ptBmCen;
		vBeamDir.normalize();
		
		Point3d ptSideBeam=el.ptOrg();
		if (vBeamDir.dotProduct(vz)>0)
		{
			ptSideBeam=ptSideBeam-vz*dBmH;
		}
		
		PlaneProfile ppElFront=el.profNetto(0);
		ppElFront.subtractProfile(ppBottomPlate);
		
		
		PlaneProfile ppBmElevation=el.profNetto(0);
		Plane plnZ(ptSideBeam, vz);
		Plane plnFront(el.ptOrg(), vz);
		
		PlaneProfile ppBeamFront(plnZ);
	
		if (nType==0)//Pocket
		{
			ppBeamFront=bdBm.getSlice(plnZ);
		}
		
		//Define if it's a pocket or a pointload	
		//Type 0=pocket 1=pointload
		int nTypeThisWall=1;
		//ppElFront.intersectWith(ppBeamFront);
		//ppElFront.vis(2);
		ppBmElevation.intersectWith(ppBeamFront);
		//ppBmElevation.vis(2);
		
		if (nType==0 && (ppBmElevation.area()/U(1)*U(1))>U(5))
		{
			nTypeThisWall=0;
		}
		
		double dTolerance=0;
		if (nTypeThisWall==0)
			dTolerance=dSideTolerance;
		
		LineSeg lsPL=ppEl.extentInDir(vx);
		LineSeg lsNew(lsPL.ptStart()-vx*dTolerance, lsPL.ptEnd()+vx*dTolerance);
		//lsNew.vis(1);
		
		//Plane profile with the shape of the pocket
		PLine plAux(vy);
		plAux.createRectangle(lsNew, vx, vz);
		
		//Planeprofile with the size of the pocket or pointload
		PlaneProfile ppPLPlan(plAux);
		ppPLPlan.intersectWith(ppEl);
		ppPLPlan.vis(3);
		//Check if there is any interference with the openings
		int nDrawX=false;
		Opening opInter[0];
		for (int o=0; o<ppAllOpenings.length(); o++)
		{
			PlaneProfile ppOp = ppAllOpenings[o];
			double dOriginalArea = (ppPLPlan.area() / U(1) * U(1));
			ppOp.intersectWith(ppPLPlan);
			//ppOp.vis(3);
			double dNewArea = (ppOp.area() / U(1) * U(1));
			if ( dNewArea > U(5))
			{
				if (abs(dNewArea-dOriginalArea)<U(2))//If all over the opening so thansfer both cripples
				{
					ppNewAreas.append(ppCrippleLeft[o]);
					ppNewAreas.append(ppCrippleRight[o]);
					opInter.append(opSorted[o]);
					nRemoveAtIndex.append(n);
					ppAllBeams.removeAt(n);
					nDrawX = true;
				}
				else //it's only over one side of the opening and not fully so only transfer the area that is needed
				{
					ppPLPlan.subtractProfile(ppAllOpenings[o]);
					if (vx.dotProduct(lsNew.ptMid()-ptCenterOp[o])<0)
					{
						PlaneProfile ppNewArea = ppPLPlan;
						ppNewArea.unionWith(ppCrippleLeft[o]);
						ppNewArea.shrink(-U(5));
						ppNewArea.shrink(U(5));
						ppNewAreas.append(ppNewArea);
						nNewAlign = -1;
						//reportNotice("\nLeft");
					}
					else
					{
						PlaneProfile ppNewArea = ppPLPlan;
						ppNewArea.unionWith(ppCrippleRight[o]);
						ppNewArea.shrink(-U(5 + dBmW));
						ppNewArea.shrink(U(5 + dBmW));
						ppNewAreas.append(ppNewArea);
						nNewAlign = 1;
						//reportNotice("\nRight");
					}
				}
			}
		}
		
		int nRemoveBeams=false;
		
		//Check if the pointload have interference with the existing beams
		double dPLArea=ppPLPlan.area()/U(1)*U(1);
		PlaneProfile ppInterference=ppFix;
		ppInterference.intersectWith(ppPLPlan);
		ppInterference.vis(4);
		if ((ppInterference.area()/U(1)*U(1))>U(10))
		{
			//ppInterference.shrink(-U(1));
			PlaneProfile ppAux=ppPLPlan;
			ppAux.subtractProfile(ppInterference);
			//ppAux.vis(2);
			if (ppAux.numRings()>1)
			{
				nRemoveBeams=true;
			}
			else
			{
				ppPLPlan.subtractProfile(ppInterference);
				ppPLPlan.shrink(-U(1));
				LineSeg lsInter=ppInterference.extentInDir(vx);
				//lsInter.vis(2);
				LineSeg lsPLAux=ppPLPlan.extentInDir(vx);
				if (vx.dotProduct(lsPLAux.ptMid()-lsInter.ptMid())<0)
				{
					nNewAlign=-1;
					//reportNotice("\nTMLeft");
				}
				else
				{
					nNewAlign=1;
					//reportNotice("\nTMRight");
				}
			}
		}
		
		LineSeg lsValidArea=ppPLPlan.extentInDir(vx);
		//Width of the pointload
		dPLWidth=abs(vx.dotProduct(lsValidArea.ptStart()-lsValidArea.ptEnd()));
		
		int nNumberBm=ceil((dPLWidth-U(1))/dBmWidth);//AJ
	
		ppPLPlan.vis(3);
		
		if (nDrawX)
		{
			///clone the TSL to draw the X
		
			//Insert the TSL again for each Element
			TslInst tsl;
			String sScriptName = "hsb_DrawXonWindow"; // name of the script
			Vector3d vecUcsX = _XW;
			Vector3d vecUcsY = _YW;
			Entity lstEnts[0];
			Beam lstBeams[0];
			Point3d lstPoints[0];
			int lstPropInt[0];
			String lstPropString[0];
			double lstPropDouble[0];
			lstPropString.append(sDimStyle);
			
			for (int o=0; o<opInter.length(); o++)
			{
				lstEnts.setLength(0);
				lstEnts.append(opInter[o]);
				tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString);
			}
			// HSB-5152: nDrawX means that the opening falls below the point load
			// beams that transfer the load must be created
			{ 
				// create beams
				if(nTypeThisWall==0)
				{
					//Pocket
				}
				else
				{ 
					// point load
					ppPLPlan.vis(4);
					LineSeg ls = ppPLPlan.extentInDir(vx);
					ls.vis(3);
					Point3d ptToCreate;
					if (nNewAlign == -1)
					ptToCreate = ls.ptEnd();
					if (nNewAlign == 1)
						ptToCreate = ls.ptStart();
					if (nNewAlign == 0)
					{
						ptToCreate=ls.ptMid();
						double dDistToMove=(nNumberBm*0.5)*dBmWidth;//AJ
						ptToCreate = ptToCreate - vx * dDistToMove;
						nNewAlign = 1;
					}
					ptToCreate = plnFront.closestPointTo(ptToCreate);
					ptToCreate.vis();
					
					// get the top plate
					Beam bmAux1[0];
					bmTopPlate[0].envelopeBody().vis(3);
					// point to get the top plates
					Point3d ptTopCen = ptToCreate + vz * (bmTopPlate[0].ptCenSolid() - ptToCreate).dotProduct(vz);
					ptTopCen.vis(3);
					bmAux1 = Beam().filterBeamsHalfLineIntersectSort(bmTopPlate, ptTopCen, vy);
					if (bmAux1.length() < 1)
					{ 
						// no top plate found
						continue;
					}
					// point at the bottom of top plate
					Point3d ptBottom = ptTopCen+
					(bmAux1[0].ptCenSolid() - (bmAux1[0].dD(vy) + U(0.1)) * vy - ptTopCen).dotProduct(vy) * vy;
					ptBottom.vis(3);
					// get the header; we know that openning lies below the beams
					Beam bmHeader[0];
					bmHeader = Beam().filterBeamsHalfLineIntersectSort(bmAll, ptBottom, -vy);
					bmHeader[0].envelopeBody().vis(3);
					vy.vis(ptToCreate, 3);
					
					// check if top header exist and is not a bottom plate, 
					// so opening exist
					if (bmHeader.length() == 1)
					{ 
						// only bottom beam found
						continue;
					}
//					bmAux1[0].envelopeBody().vis(2);
					// ToDO check if there is a gap between top beam and header
					Point3d ptTopHeader = bmHeader[0].ptCenSolid() + bmHeader[0].dD(vy) * vy;
					Point3d ptBottomTop = bmAux1[0].ptCenSolid() - (bmAux1[0].dD(vy)) * vy;
					
					if ((ptTopHeader - ptBottomTop).length() < U(0.1))
					{ 
						// no gap between top beam and the header
						continue;
					}
					
					// draw the beams
					Point3d ptBeamCen = ptToCreate;
					// move it to up to place between the top beam and the header, for the creation of the new beam
					ptBeamCen += vy * (.5 * (ptTopHeader + ptBottomTop)-ptBeamCen).dotProduct(vy);
					ptBeamCen.vis(3);
					for ( int b = 0; b < nNumberBm; b++)
					{
						Beam bmNew;
						bmNew.dbCreate(ptBeamCen, vy, vx, -vz, U(50), dBmWidth, dBmH, 0, nNewAlign, 1);//AJ
						bmNew.setName(sNameStud);
						bmNew.setMaterial(sMaterialStud);
						bmNew.setGrade(sGradeStud);
						bmNew.setBeamCode(sCodeStud + ";");
						bmNew.setType(_kStud);
						bmNew.setHsbId("114");
						bmNew.setSubMapX("UsageMap", mpForSubMapX);
						bmCreated.append(bmNew);
						bmCreatedThisWall.append(bmNew);
						ptBeamCen = ptBeamCen + vx * (nNewAlign * dBmWidth);
	
						//Beam bmNew;
						//bmNew=bm.dbCopy();
						
						bmNew.setColor(nColor);
						bmNew.assignToElementGroup(el, true, 0, 'Z');
						
						//bmNew.transformBy(vx*vx.dotProduct(ptNewBmCenter-bmNew.ptCen()));
						
//						Beam bmAux1[0];
//						bmAux1=Beam().filterBeamsHalfLineIntersectSort(bmTopPlate, bmNew.ptCen(), vy);
//						if (bmAux1.length()>0)
//							bmNew.stretchStaticTo(bmAux1[0], true);

//						bmAux1[0].envelopeBody().vis(2);
						bmNew.stretchStaticTo(bmAux1[0], true);
//						Beam bmAux2[0];
//						bmAux2=Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, bmNew.ptCen(), -vy);
//						if (bmAux2.length()>0)
//							bmNew.stretchStaticTo(bmAux2[0], true);
						bmNew.stretchStaticTo(bmHeader[0], true);
						//bmNew.realBody().vis();
					}
				}
			}
		}
		else
		{
			ppDraw.append(ppPLPlan);
			//Beams Creation
			if (nTypeThisWall==0)//Pocket
			{
				LineSeg lsBmFront=ppBmElevation.extentInDir(vx);
				LineSeg lsVer=ppBmElevation.extentInDir(vy);
				lsVer.vis();
				lsBmFront.vis(2);
				Point3d ptBelowBm=lsVer.ptStart();
				Point3d ptTopBm=lsVer.ptEnd();
				
				if ( dSillWidth>0 )
					ptBelowBm=ptBelowBm-vy*dSillWidth;
					
				if ( dTransomWidth>0 )
					ptTopBm=ptTopBm+vy*(dTransomWidth+dTransomGap);

				LineSeg ls=ppPLPlan.extentInDir(vx);

				Point3d ptToCreate;
				//Point3d ptLeftPocket;
				//Point3d ptRightPocket;
				if (nNewAlign==-1)
				{
					ptToCreate=ls.ptEnd();
//					ptLeftPocket=ls.ptStart();
//					ptRightPocket=ptToCreate;
				}
				if (nNewAlign==1)
				{
					ptToCreate=ls.ptStart();
//					ptLeftPocket=ptToCreate;
//					ptRightPocket=ls.ptEnd();
				}
				if (nNewAlign==0)
				{
					ptToCreate=ls.ptMid();

					if(nNumberBm < nBmQty)
					{
						nNumberBm=nBmQty;
					}
					
					double dDistToMove=(nNumberBm*0.5)*dBmWidth;//AJ
					ptToCreate=ptToCreate-vx*dDistToMove;
					nNewAlign=1;
					//ptLeftPocket=ptToCreate;
					//ptRightPocket=ls.ptEnd();
				}
				ptToCreate = plnFront.closestPointTo(ptToCreate);
				ptToCreate.vis();
				
				Line lnMidPocket (ptToCreate, vy);
				ptBelowBm = lnMidPocket.closestPointTo(ptBelowBm);
				ptTopBm = lnMidPocket.closestPointTo(ptTopBm);
				
				Point3d ptLeftPocket = ptToCreate;
				Point3d ptRightPocket = ptToCreate;
				
				Line lnBelowPocket (ptBelowBm, vx);
				Line lnTopPocket (ptTopBm, vx);
				
				ptLeftPocket = lnBelowPocket.closestPointTo(ptLeftPocket);
				ptRightPocket = lnBelowPocket.closestPointTo(ptRightPocket);

				Point3d ptLeftPocketUp = lnTopPocket.closestPointTo(ptLeftPocket);
				Point3d ptRightPocketUp = lnTopPocket.closestPointTo(ptRightPocket);
				
				ptRightPocket = ptRightPocket + vx * (nNewAlign * dBmWidth * nNumberBm);//AJ
				ptRightPocketUp = ptRightPocketUp + vx * (nNewAlign * dBmWidth * nNumberBm);//AJ
				
				if (vx.dotProduct(ptLeftPocket-ptRightPocket)>0)
				{
					Point3d ptAux1=ptLeftPocket;
					ptLeftPocket=ptRightPocket;
					ptRightPocket=ptAux1;
					
					Point3d ptAux2=ptLeftPocketUp;
					ptLeftPocketUp=ptRightPocketUp;
					ptRightPocketUp=ptAux2;
				}
				
				ptLeftPocketUp.vis();
				ptRightPocketUp.vis();
				ptLeftPocket.vis();
				ptRightPocket.vis();

				if(sCncCatalogues.find(sCncCatalogue,0) > 0)
				{
					if(_Map.hasEntity("Cnc"))
					{
						Entity ent = _Map.getEntity("Cnc");
						if(ent.bIsValid())
						{
							ent.dbErase();
						}
					}
				
					PLine plPocket;
					plPocket.createRectangle(LineSeg(ptLeftPocketUp, ptRightPocket),vx,vy);
		
					Vector3d vecUcsX(1,0,0);
					Vector3d vecUcsY(0,1,0);
					Beam lstBeams[0];
					Entity lstEntities[0];
					lstEntities.append(_Element[0]);
					
					Point3d lstPoints[0];
					int lstPropInt[0];
					double lstPropDouble[0];
					String lstPropString[0];
					TslInst tsl;
					Map mapTsl;
					mapTsl.setPLine("plCNC", plPocket);
					tsl.dbCreate(cncScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
					tsl.setPropValuesFromCatalog(sCncCatalogue);

					
					_Map.setEntity("Cnc", tsl);
				}
			
				//Check if there is any existing beam that needs to be split with the pointload beam
				PlaneProfile ppAuxA=ppBmElevation;
				ppAuxA.intersectWith(ppFixFront);
				if (ppAuxA.area()/U(1)*U(1) > U(2)*U(2))
				{
					Beam bmToAppend[0];
					LineSeg lsFullPocket(ptBelowBm, ptTopBm);
					double dCutLength=abs(vy.dotProduct(ptBelowBm-ptTopBm));
					Point3d ptCut=lsFullPocket.ptMid();
					for (int b=0; b<bmFix.length(); b++)
					{
						Beam bm=bmFix[b];
						Body bd=bm.realBody();
						
						PlaneProfile ppBm=bd.shadowProfile(plnZ);
						ppBm.intersectWith(ppBmElevation);
						if (ppBm.area()/U(1)*U(1) > U(2)*U(2))
						{
							ppBm=bd.shadowProfile(plnZ);
							ppBm.shrink(U(3));
							ppBm.subtractProfile(ppBmElevation);
							if (ppBm.numRings()>1)
							{
								Beam bmNew=bm.dbSplit(ptCut, ptCut);
								BeamCut bc(ptCut, vx, vy, vz, U(500),dCutLength, U(500), 0, 0, 0);
								bm.addToolStatic(bc);
								bmNew.addToolStatic(bc);
								bmToAppend.append(bmNew);
							}
							else
							{
								BeamCut bc(ptCut, vx, vy, vz, U(500), dCutLength, U(500), 0, 0, 0);
								bm.addToolStatic(bc);
							}
						}
					}
					bmFix.append(bmToAppend);
				}
				
				
				Cut ctBelowPocket (ptBelowBm, vy);
				//Vertical supporting Beams
				if (ppElFront.pointInProfile(ptBelowBm) == _kPointInProfile)
				{
					for( int b=0; b<nNumberBm; b++)
					{
						//ptRightPocket=ptRightPocket+vx*(nNewAlign*dBmW);
						//ptRightPocketUp=ptRightPocketUp+vx*(nNewAlign*dBmW);
						
						Beam bmNew;
						bmNew.dbCreate(ptToCreate+vy*U(200), vy, vx, -vz, U(50), dBmWidth, dBmH, 0, nNewAlign, 1);
						Body bdNew(ptToCreate+vy*U(225),vy,vx,-vz,U(8000),dBmWidth,dBmH,-1,nNewAlign,1);
						bmCreated.append(bmNew);
						bmCreatedThisWall.append(bmNew);
						ptToCreate=ptToCreate+vx*(nNewAlign*dBmWidth);//AJ
	
						//Beam bmNew;
						//bmNew=bm.dbCopy();
						bmNew.setName(sNameStud);
						bmNew.setMaterial(sMaterialStud);
						bmNew.setGrade(sGradeStud);
						bmNew.setBeamCode(sCodeStud+";");
						bmNew.setType(_kStud);
						bmNew.setSubMapX("UsageMap", mpForSubMapX);
						bmNew.setHsbId("114");
						bmNew.setColor(nColor);
						bmNew.assignToElementGroup(el, true, 0, 'Z');
						
						//bmNew.transformBy(vx*vx.dotProduct(ptNewBmCenter-bmNew.ptCen()));
						
						Beam bmAux2[0];
						bmAux2=Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, bmNew.ptCen(), -vy);
						if (bmAux2.length()>0)
							bmNew.stretchStaticTo(bmAux2[0], true);
						else
						{ 
						// HSB-16007check if the bottom plate is split into 2 parts
//							Point3d ptLook=bmNew.ptCen()+.25*bmNew.dD(vz)*bmNew.vecD(vz);
//							bmAux2=Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, ptLook, -vy);
//							if (bmAux2.length()>0)
//								bmNew.stretchStaticTo(bmAux2[0], true);
//							else
//							{
//								ptLook=bmNew.ptCen()-.25*bmNew.dD(vz)*bmNew.vecD(vz);
//								bmAux2=Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, ptLook, -vy);
//								if (bmAux2.length()>0)
//									bmNew.stretchStaticTo(bmAux2[0], true);
//							}
							Beam beamsIntersect[]=bdNew.filterGenBeamsIntersect(bmBottomPlate);
							if(beamsIntersect.length()>0)
							{
								Beam bmStretchTo=beamsIntersect[0];
								Point3d ptTopMaxs[]=bmStretchTo.realBody().extremeVertices(vy);
								Point3d ptTopMax=ptTopMaxs[ptTopMaxs.length()-1];
								ptTopMax.vis(6);
								for (int ibm=0;ibm<beamsIntersect.length();ibm++) 
								{ 
									Point3d ptTopMaxsI[]=beamsIntersect[ibm].realBody().extremeVertices(vy);
									Point3d ptTopMaxI=ptTopMaxsI[ptTopMaxsI.length()-1];
									if(vy.dotProduct(ptTopMaxI-ptTopMax)>0)
									{ 
										ptTopMax=ptTopMaxI;
										bmStretchTo=beamsIntersect[ibm];
									}
								}//next ibm
								bmNew.stretchStaticTo(bmStretchTo,true);
							}
						}
						//bmNew.realBody().vis();
						bmNew.addToolStatic(ctBelowPocket, _kStretchOnInsert); 
					}
				}
				
				//Left KingBeam
				Point3d ptLeftKing=ptLeftPocket-vx*(dBmWidth*0.5);//AJ
				Point3d ptLeftKingUp=ptLeftPocketUp-vx*(dBmWidth*0.5);//AJ
				if ((ppElFront.pointInProfile(ptLeftKing) == _kPointInProfile || ppElFront.pointInProfile(ptLeftKingUp) == _kPointInProfile) && ppFixFront.pointInProfile(ptLeftKing) == _kPointOutsideProfile)
				{
					Beam bmNew;
					bmNew.dbCreate(ptLeftKing, vy, vx, -vz, U(50), dBmWidth, dBmH, 0, 0, 1);//AJ
					Body bdNew(ptLeftKing,vy,vx,-vz,U(8000),dBmWidth,dBmH,-1,0,1);//AJ
					bmCreated.append(bmNew);
					bmCreatedThisWall.append(bmNew);
				
					bmNew.setName(sNameStud);
					bmNew.setMaterial(sMaterialStud);
					bmNew.setGrade(sGradeStud);
					bmNew.setBeamCode(sCodeStud+";");
					bmNew.setType(_kStud);
					bmNew.setSubMapX("UsageMap", mpForSubMapX);
					bmNew.setHsbId("114");
					bmNew.setColor(nColor);
					bmNew.assignToElementGroup(el, true, 0, 'Z');
					
					Beam bmAux1[0];
					bmAux1=Beam().filterBeamsHalfLineIntersectSort(bmTopPlate, bmNew.ptCen(), vy);
					if (bmAux1.length()>0)
						bmNew.stretchStaticTo(bmAux1[0], true);
					
					Beam bmAux2[0];
					bmAux2=Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, bmNew.ptCen(), -vy);
					if (bmAux2.length()>0)
						bmNew.stretchStaticTo(bmAux2[0], true);
					else
					{ 
					// HSB-16007 check if the bottom plate is split into 2 parts
//						Point3d ptLook=bmNew.ptCen()+.25*bmNew.dD(vz)*bmNew.vecD(vz);
//						bmAux2=Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, ptLook, -vy);
//						if (bmAux2.length()>0)
//							bmNew.stretchStaticTo(bmAux2[0], true);
//						else
//						{
//							ptLook=bmNew.ptCen()-.25*bmNew.dD(vz)*bmNew.vecD(vz);
//							bmAux2=Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, ptLook, -vy);
//							if (bmAux2.length()>0)
//								bmNew.stretchStaticTo(bmAux2[0], true);
//						}
						Beam beamsIntersect[]=bdNew.filterGenBeamsIntersect(bmBottomPlate);
						if(beamsIntersect.length()>0)
						{
							Beam bmStretchTo=beamsIntersect[0];
							Point3d ptTopMaxs[]=bmStretchTo.realBody().extremeVertices(vy);
							Point3d ptTopMax=ptTopMaxs[ptTopMaxs.length()-1];
							ptTopMax.vis(6);
							for (int ibm=0;ibm<beamsIntersect.length();ibm++) 
							{ 
								Point3d ptTopMaxsI[]=beamsIntersect[ibm].realBody().extremeVertices(vy);
								Point3d ptTopMaxI=ptTopMaxsI[ptTopMaxsI.length()-1];
								if(vy.dotProduct(ptTopMaxI-ptTopMax)>0)
								{ 
									ptTopMax=ptTopMaxI;
									bmStretchTo=beamsIntersect[ibm];
								}
							}//next ibm
							bmNew.stretchStaticTo(bmStretchTo,true);
						}
					}
					//bmNew.realBody().vis();
				}
				
				//Right KingBeam
				Point3d ptRightKing=ptRightPocket+vx*(dBmWidth*0.5);//AJ
				Point3d ptRightKingUp=ptRightPocketUp+vx*(dBmWidth*0.5);//AJ
				if ((ppElFront.pointInProfile(ptRightKing) == _kPointInProfile ||  ppElFront.pointInProfile(ptRightKingUp) == _kPointInProfile) && ppFixFront.pointInProfile(ptRightKing) == _kPointOutsideProfile)
				{
					Beam bmNew;
					bmNew.dbCreate(ptRightKing, vy, vx, -vz, U(50), dBmWidth, dBmH, 0, 0, 1);//AJ
					Body bdNew(ptRightKing,vy,vx,-vz,U(8000),dBmWidth,dBmH,-1,0,1);//AJ
					bmCreated.append(bmNew);
					bmCreatedThisWall.append(bmNew);
				
					bmNew.setName(sNameStud);
					bmNew.setMaterial(sMaterialStud);
					bmNew.setGrade(sGradeStud);
					bmNew.setBeamCode(sCodeStud+";");
					bmNew.setType(_kStud);
					bmNew.setHsbId("114");
					bmNew.setSubMapX("UsageMap", mpForSubMapX);
					bmNew.setColor(nColor);
					bmNew.assignToElementGroup(el, true, 0, 'Z');
					
					Beam bmAux1[0];
					bmAux1=Beam().filterBeamsHalfLineIntersectSort(bmTopPlate, bmNew.ptCen(), vy);
					if (bmAux1.length()>0)
						bmNew.stretchStaticTo(bmAux1[0], true);
					
					Beam bmAux2[0];
					bmAux2=Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, bmNew.ptCen(), -vy);
					if (bmAux2.length()>0)
						bmNew.stretchStaticTo(bmAux2[0], true);
					else
					{ 
					// HSB-16007 check if the bottom plate is split into 2 parts
//						Point3d ptLook=bmNew.ptCen()+.25*bmNew.dD(vz)*bmNew.vecD(vz);
//						bmAux2=Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, ptLook, -vy);
//						if (bmAux2.length()>0)
//							bmNew.stretchStaticTo(bmAux2[0], true);
//						else
//						{
//							ptLook=bmNew.ptCen()-.25*bmNew.dD(vz)*bmNew.vecD(vz);
//							bmAux2=Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, ptLook, -vy);
//							if (bmAux2.length()>0)
//								bmNew.stretchStaticTo(bmAux2[0], true);
//						}
						Beam beamsIntersect[]=bdNew.filterGenBeamsIntersect(bmBottomPlate);
						if(beamsIntersect.length()>0)
						{
							Beam bmStretchTo=beamsIntersect[0];
							Point3d ptTopMaxs[]=bmStretchTo.realBody().extremeVertices(vy);
							Point3d ptTopMax=ptTopMaxs[ptTopMaxs.length()-1];
							ptTopMax.vis(6);
							for (int ibm=0;ibm<beamsIntersect.length();ibm++) 
							{ 
								Point3d ptTopMaxsI[]=beamsIntersect[ibm].realBody().extremeVertices(vy);
								Point3d ptTopMaxI=ptTopMaxsI[ptTopMaxsI.length()-1];
								if(vy.dotProduct(ptTopMaxI-ptTopMax)>0)
								{ 
									ptTopMax=ptTopMaxI;
									bmStretchTo=beamsIntersect[ibm];
								}
							}//next ibm
							bmNew.stretchStaticTo(bmStretchTo,true);
						}
					}
					//bmNew.realBody().vis();
				}				
				
				//Sill Beam
				Point3d ptLeftSill=ptLeftPocket;
				Point3d ptRightSill=ptRightPocket;
				double dAx1=vx.dotProduct(ptLeftSill-lsBmFront.ptStart());
				double dAx2=vx.dotProduct(ptRightSill-lsBmFront.ptEnd());
				if (vx.dotProduct(ptLeftSill-lsBmFront.ptStart())>U(3))
				{
					ptLeftSill=lsBmFront.ptStart();
					ptLeftSill=lnBelowPocket.closestPointTo(ptLeftSill);
				}
				if (vx.dotProduct(ptRightSill-lsBmFront.ptEnd())<U(3))
				{
					ptRightSill=lsBmFront.ptEnd();
					ptRightSill=lnBelowPocket.closestPointTo(ptRightSill);
				}
				double dPocketLength=abs(vx.dotProduct(ptLeftSill-ptRightSill));
				Point3d ptSill=LineSeg(ptLeftSill,ptRightSill).ptMid();
				if ( (dSillWidth>1 && dPocketLength>1) && ppElFront.pointInProfile(ptSill) == _kPointInProfile)
				{
					Beam bmSill;
					bmSill.dbCreate(ptSill, vx, vy, vz, dPocketLength, dSillWidth, dBmH, 0, 1, -1);
					bmSill.setName(sNameSill);
					bmSill.setMaterial(sMaterialSill);
					bmSill.setGrade(sGradeSill);
					bmSill.setBeamCode(sCodeSill+";");
					bmSill.setType(_kSill);
					bmSill.setSubMapX("UsageMap", mpForSubMapX);
					bmSill.setColor(nColor);
					bmSill.assignToElementGroup(el, true, 0, 'Z');
					
					bmCreated.append(bmSill);
					bmCreatedThisWall.append(bmSill);
				}
				
				//Transom
				Point3d ptLeftTransom=ptLeftPocketUp;
				Point3d ptRightTransom=ptRightPocketUp;
				if (vx.dotProduct(ptLeftTransom-lsBmFront.ptStart())>U(3))
				{
					ptLeftTransom=lsBmFront.ptStart();
					ptLeftTransom=lnTopPocket.closestPointTo(ptLeftTransom);
				}
				if (vx.dotProduct(ptRightTransom-lsBmFront.ptEnd())<U(3))
				{
					ptRightTransom=lsBmFront.ptEnd();
					ptRightTransom=lnTopPocket.closestPointTo(ptRightTransom);
				}
				double dPocketLengthUp=abs(vx.dotProduct(ptLeftTransom-ptRightTransom));
				Point3d ptTransom=LineSeg(ptLeftTransom, ptRightTransom).ptMid();
				if ( (dTransomWidth>1 && dPocketLengthUp>1) && ppElFront.pointInProfile(ptTransom) == _kPointInProfile)
				{
					Beam bmTransom;
					bmTransom.dbCreate(ptTransom, vx, vy, vz, dPocketLengthUp, dTransomWidth, dBmH, 0, -1, -1);
					bmTransom.setName(sNameTransom);
					bmTransom.setMaterial(sMaterialTransom);
					bmTransom.setGrade(sGradeTransom);
					bmTransom.setColor(nColor);
					bmTransom.setBeamCode(sCodeTransom+";");
					bmTransom.setType(_kSFTransom);
					bmTransom.assignToElementGroup(el, true, 0, 'Z');
					bmTransom.setSubMapX("UsageMap", mpForSubMapX);

					
					bmCreated.append(bmTransom);
					bmCreatedThisWall.append(bmTransom);
				}
				
				//Split Top Plate
				if (bTopPlate)
				{

					double dCutLength=abs(vx.dotProduct(ptLeftPocket-ptRightPocket));
					Point3d ptCut=LineSeg(ptLeftPocket,ptRightPocket).ptMid();
					LineSeg lsTool (ptLeftPocket, ptRightPocket+vy*U(1000));
					PLine plTool(vy);
					plTool.createRectangle(lsTool, vx, vy);
					PlaneProfile ppTool(plTool);ppTool.vis(3);
//					ppBmElevation.shrink(-U(5));
					ppBmElevation.vis(4);
//					ppBmElevation.shrink(U(5));
					
					PlaneProfile ppAux=ppBmElevation;
					ppAux.intersectWith(ppTopPlate);
					if (ppAux.area()/U(1)*U(1) > U(5))
					{
						for (int b=0; b<bmTopPlate.length(); b++)
						{
							Beam bm=bmTopPlate[b];
							Body bd=bm.realBody();
							
							ptCut=Line(ptCut, vy).closestPointTo(Line(bm.ptCen(), bm.vecX()));
							ptCut.vis();
							
							PlaneProfile ppTP=bd.shadowProfile(plnZ);
							ppTP.intersectWith(ppTool);
							if (ppTP.area()/U(1)*U(1) > U(2)*U(2))
							{
								ppTP=bd.shadowProfile(plnZ);
								ppTP.subtractProfile(ppTool);
								if (ppTP.numRings()>1)
								{
									Point3d ptSplitLeft=Line(ptLeftPocket, vy).closestPointTo(Line(bm.ptCen(), bm.vecX()));
									Point3d ptSplitRight=Line(ptRightPocket, vy).closestPointTo(Line(bm.ptCen(), bm.vecX()));
									//bm.dbSplit(ptSplitRight, ptSplitLeft );
									Beam bmNew=bm.dbSplit(ptCut, ptCut);
									BeamCut bc(ptCut, vx, vy, vz, dCutLength, U(500), U(500), 0, 0, 0);
									bm.addToolStatic(bc);
									bmNew.addToolStatic(bc);
									//Check If the Result Beams are too small and intersect the original beam
									PlaneProfile ppBm1=bm.realBody().shadowProfile(plnZ);
									PlaneProfile ppBm2=bmNew.realBody().shadowProfile(plnZ);
									double dA1 = ppBm1.area();
									ppBm1.intersectWith(ppBmElevation);
									double dA2 = ppBm2.area();
									ppBm2.intersectWith(ppBmElevation);
//									if (ppBm1.area()/U(1)*U(1) > U(2)*U(2))
									if (ppBm1.area()/dA1 > .1)
									{
										bm.dbErase();
									}
//									if (ppBm2.area()/U(1)*U(1) > U(2)*U(2))
									if (ppBm2.area()/dA2 > U(2)*U(2))
									{
										bmNew.dbErase();
									}
								}
								else
								{
									BeamCut bc(ptCut, vx, vy, vz, dCutLength, U(500), U(500), 0, 0, 0);
									bm.addToolStatic(bc);
								}
							}
							
						}
					}
				}
				
				//Split Bottom Plate
				if (bBottomPlate)
				{
					double dCutLength=abs(vx.dotProduct(ptLeftPocket-ptRightPocket));
					Point3d ptCut=LineSeg(ptLeftPocket,ptRightPocket).ptMid();
					LineSeg lsTool (ptLeftPocket-vy*U(500), ptRightPocket+vy*U(1000));
					PLine plTool(vy);
					plTool.createRectangle(lsTool, vx, vy);
					PlaneProfile ppTool(plTool);ppTool.vis(3);
					ppBmElevation.vis(1);
					PlaneProfile ppAux=ppBmElevation;
					ppAux.intersectWith(ppBottomPlate);
					if (ppAux.area()/U(1)*U(1) > U(5))
					{
						for (int b=0; b<bmBottomPlate.length(); b++)
						{
							Beam bm=bmBottomPlate[b];
							Body bd=bm.realBody();
							PlaneProfile ppTP=bd.shadowProfile(plnZ);
							ppTP.intersectWith(ppTool);
							if (ppTP.area()/U(1)*U(1) > U(5))
							{
								ppTP=bd.shadowProfile(plnZ);
								ppTP.subtractProfile(ppTool);
								if (ppTP.numRings()>1)
								{
									Point3d ptSplitLeft=Line(ptLeftPocket, vy).closestPointTo(Line(bm.ptCen(), bm.vecX()));
									Point3d ptSplitRight=Line(ptRightPocket, vy).closestPointTo(Line(bm.ptCen(), bm.vecX()));
									bm.dbSplit(ptSplitRight, ptSplitLeft );
								}
								else
								{
									BeamCut bc(ptCut, vx, vy, vz, dCutLength, U(500), U(500), 0, 1, 0);
									bm.addToolStatic(bc);
								}
							}
						}
					}
				}
			}
			else//Pointload
			{
				//ppPLPlan
				LineSeg ls = ppPLPlan.extentInDir(vx);
				Point3d ptToCreate;
				if (nNewAlign == -1)
					ptToCreate = ls.ptEnd();
				if (nNewAlign == 1)
					ptToCreate = ls.ptStart();
				if (nNewAlign == 0)
				{
					ptToCreate = ls.ptMid();
					double dDistToMove=(nNumberBm*0.5)*dBmWidth;//AJ
					ptToCreate = ptToCreate - vx * dDistToMove;
					nNewAlign = 1;
				}
				ptToCreate=plnFront.closestPointTo(ptToCreate);
				ptToCreate.vis();

				// entity to store bottom angle brackets
				Entity entsTslBottomNew[0];
				Entity entsTslTopNew[0];
				
				int iAngleBracket = sAngleBracketsOptions.find(sAngleBrackets);
				int iAngleBracketLocation = sAngleBracketsLocationOptions.find(sAngleBracketsLocations);
				//
				String sMapTslBottomName = "entsTslBottom" + e;
				String sMapTslTopName = "entsTslTop" + e;
				
				Point3d ptLeftPocket=ptToCreate, ptRightPocket=ptToCreate;
				ptLeftPocket.vis(1);
				// delete bottom and top anglebrackets if exist
				{ 
					// bottom
					Entity entsTslBottom[] = _Map.getEntityArray(sMapTslBottomName, "", "");
					if(entsTslBottom.length()>0)
					{ 
						for (int i=entsTslBottom.length()-1; i>=0 ; i--) 
						{ 
							TslInst tsli = (TslInst)entsTslBottom[i];
							if(tsli.bIsValid())
							{
								tsli.dbErase();
							}
						}//next i
					}
					// delete from map
					_Map.removeAt("entsTslBottom", true);
					
					// top
					Entity entsTslTop[] = _Map.getEntityArray(sMapTslTopName, "", "");
					if(entsTslTop.length()>0)
					{ 
						for (int i=entsTslTop.length()-1; i>=0 ; i--) 
						{ 
							TslInst tsli = (TslInst)entsTslTop[i];
							if(tsli.bIsValid())
							{
								tsli.dbErase();
							}
						}//next i
					}
					// delete from map
					_Map.removeAt("entsTslTop", true);
				}
				for( int b=0; b<nNumberBm; b++)
				{
					Beam bmNew;
					bmNew.dbCreate(ptToCreate+vy*U(300), vy, vx, -vz, U(50), dBmWidth, dBmH, 0, nNewAlign, 1);//AJ
					Body bdNew(ptToCreate+vy*U(325),vy,vx,-vz,U(8000),dBmWidth,dBmH,-1,nNewAlign,1);
					bmNew.setName(sNameStud);
					bmNew.setMaterial(sMaterialStud);
					bmNew.setGrade(sGradeStud);
					bmNew.setBeamCode(sCodeStud+";");
					bmNew.setType(_kStud);
					bmNew.setHsbId("114");
					bmNew.setSubMapX("UsageMap", mpForSubMapX);
					bmCreated.append(bmNew);
					bmCreatedThisWall.append(bmNew);
					ptToCreate=ptToCreate+vx*(nNewAlign*dBmWidth);//AJ

					//Beam bmNew;
					//bmNew=bm.dbCopy();
					
					bmNew.setColor(nColor);
					bmNew.assignToElementGroup(el, true, 0, 'Z');
					
					//bmNew.transformBy(vx*vx.dotProduct(ptNewBmCenter-bmNew.ptCen()));
					
					Beam bmAux1[0];
					bmAux1=Beam().filterBeamsHalfLineIntersectSort(bmTopPlate, bmNew.ptCen(), vy);
					if (bmAux1.length()>0)
					{
						bmNew.stretchStaticTo(bmAux1[0], true);
					}
					else
					{ 
						//HSB-12683 top plate can be splitted, try to investigate top plate from ptLeftPocket
						Point3d ptLook = bmNew.ptCen();
						ptLook += vx * vx.dotProduct(ptLeftPocket - vx * U(1) - ptLook);
						
						bmAux1=Beam().filterBeamsHalfLineIntersectSort(bmTopPlate, ptLook, vy);
						if(bmAux1.length()>0)
						{
							Point3d ptCutTop = bmAux1[0].ptCen() - bmAux1[0].vecD(vy) * .5 * bmAux1[0].dD(vy);
							ptCutTop.vis(4);
							Cut cutTop(ptCutTop, bmAux1[0].vecD(vy));
							bmNew.addToolStatic(cutTop, _kStretchOnInsert); 
							
						}
					}
					
					Beam bmAux2[0];
					bmAux2=Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, bmNew.ptCen(), -vy);
					if (bmAux2.length()>0)
					{
						bmNew.stretchStaticTo(bmAux2[0], true);
					}
					else
					{ 
						//HSB-12683 top plate can be splitted, try to investigate top plate from ptLeftPocket
						Point3d ptLook = bmNew.ptCen();
						ptLook += vx * vx.dotProduct(ptLeftPocket - vx * U(1) - ptLook);
						bmAux2=Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, ptLook, -vy);
						if(bmAux2.length()>0)
						{
							Point3d ptCutBottom = bmAux2[0].ptCen()+bmAux2[0].vecD(vy)*.5*bmAux2[0].dD(vy);
							ptCutBottom.vis(4);
							Cut cutBottom(ptCutBottom, -bmAux2[0].vecD(vy));
							bmNew.addToolStatic(cutBottom, _kStretchOnInsert); 
						}
						else
						{ 
							Beam beamsIntersect[]=bdNew.filterGenBeamsIntersect(bmBottomPlate);
							if(beamsIntersect.length()>0)
							{
								Beam bmStretchTo=beamsIntersect[0];
								Point3d ptTopMaxs[]=bmStretchTo.realBody().extremeVertices(vy);
								Point3d ptTopMax=ptTopMaxs[ptTopMaxs.length()-1];
								ptTopMax.vis(6);
								for (int ibm=0;ibm<beamsIntersect.length();ibm++) 
								{ 
									Point3d ptTopMaxsI[]=beamsIntersect[ibm].realBody().extremeVertices(vy);
									Point3d ptTopMaxI=ptTopMaxsI[ptTopMaxsI.length()-1];
									if(vy.dotProduct(ptTopMaxI-ptTopMax)>0)
									{ 
										ptTopMax=ptTopMaxI;
										bmStretchTo=beamsIntersect[ibm];
									}
								}//next ibm
								Point3d ptCutBottom=bmStretchTo.ptCen()+bmStretchTo.vecD(vy)*.5*bmStretchTo.dD(vy);
								ptCutBottom.vis(4);
								Cut cutBottom(ptCutBottom, -bmStretchTo.vecD(vy));
								bmNew.addToolStatic(cutBottom, _kStretchOnInsert); 
							}
						}
					}
					
					bmNew.realBody().vis();
					// top beam
//					bmAux1[0].realBody().vis();
					// bottom beam
//					bmAux2[0].realBody().vis();
					
					if((bmNew.ptCen()-vx*.5*bmNew.dD(vx)-ptLeftPocket).dotProduct(vx)<0)
						ptLeftPocket = bmNew.ptCen() - vx * .5 * bmNew.dD(vx);
					if((bmNew.ptCen()+vx*.5*bmNew.dD(vx)-ptRightPocket).dotProduct(vx)>0)
						ptRightPocket = bmNew.ptCen() + vx * .5 * bmNew.dD(vx);	
					// array of entities where the TSL of anglebracket is saved
					Entity entsTsl[0];
					// create angle brackets if required
					if (b == 0 || b == nNumberBm - 1 )
					{ 
						// name and color
						if (sNameOutsideBeams != "")
						{ 
							// not empty
							bmNew.setName(sNameOutsideBeams);
						}
						if (nColorOutsideBeams >- 3)
						{ 
							bmNew.setColor(nColorOutsideBeams);
						}
						
						//sAngleBracketsLocationOptions[] ={ "Left", "Right", "Both"};
						if (iAngleBracketLocation == 1 && b == 0) continue;
						if (iAngleBracketLocation == 0 && b == nNumberBm - 1) continue;

//						sAngleBracketsOptions[] ={ "No", "Bottom", "Top", "Both"};
						if (iAngleBracket == 1 || iAngleBracket == 3)
						{
							// bottom or both
							// see if TSL is contained inside the map
							// insertion point of the connection
							Point3d ptAngleLeft;
							Point3d ptAngleRight;
							
							// if bottom beam is splitted, get the left bottom beam and the right beam
							Beam bmBottom;
							Point3d ptBeamLeft;
							Point3d ptBeamRight;
							ptBeamLeft = bmNew.ptCen() - vx * .5 * bmNew.dD(vx);
							ptBeamRight = bmNew.ptCen() + vx * .5 * bmNew.dD(vx);
							
							if(bmAux2.length()>0 && bmAux2[0].bIsValid())
							{ 
								bmBottom = bmAux2[0];
							}
							else 
							{ 
								// bottom beam can be split, find it new
								if(b==0)
								{ 
									Beam bmBottomLefts[0];
									bmBottomLefts=Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, ptBeamLeft-U(1)*vx, -vy);
									if(bmBottomLefts.length()>0)
									{ 
										bmBottom=bmBottomLefts[0];
									}
								}
								else
								{ 
									Beam bmBottomRights[0];
									bmBottomRights=Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, ptBeamRight-U(1)*vx, -vy);
									if(bmBottomRights.length()>0)
									{ 
										bmBottom=bmBottomRights[0];
									}
								}
							}
							// line beteen the bmNew and bmAux2
							Vector3d vecAux = bmBottom.vecD(vy);
							Point3d ptAux = bmBottom.ptCen() + vy * .5 * bmBottom.dD(vy);
//							ptAux.vis(2);
//							vecAux.vis(ptAux, 2);
							Plane pnAux(ptAux, vecAux);
							
//							Point3d ptBeamLeft;
//							Point3d ptBeamRight;
//							ptBeamLeft = bmNew.ptCen() - vx * .5 * bmNew.dD(vx);
//							ptBeamRight = bmNew.ptCen() + vx * .5 * bmNew.dD(vx);
							
							Plane pnBeamLeft(ptBeamLeft, vx);
							Plane pnBeamRight(ptBeamRight, vx);
							
							Line lnLeft = pnAux.intersect(pnBeamLeft);
							Line lnRight = pnAux.intersect(pnBeamRight);

							
							ptAngleLeft = lnLeft.closestPointTo(bmNew.ptCen());
							ptAngleLeft.vis(2);
							ptAngleRight = lnRight.closestPointTo(bmNew.ptCen());
//							ptAngleRight.vis(2);
							
						// create TSL
							TslInst tslNew;			Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
							GenBeam gbsTsl[] = {};	Entity entsTsl[] = {};	Point3d ptsTsl[] = {_Pt0};
							int nProps[]={};	double dProps[]={};	String sProps[]={};
							Map mapTsl;	
							
//							gbsTsl.setLength(0);
//							gbsTsl.append(bmBottom);
//							gbsTsl.append(bmNew);
							// GA-T is now O type and accepts entities not only genbeams
							entsTsl.setLength(0);
							entsTsl.append(bmBottom);
							entsTsl.append(bmNew);
							
							//family, model, nail
							sProps.setLength(0);
							sProps.append("Cullen Metal Angle Bracket");
							sProps.append("LAB");
							sProps.append("LAB-180");
							// 
							sProps.append("nail+bolt");
							sProps.append(T("|left|"));
							sProps.append( T("|none|"));
							// painter
							sProps.append( T("<|Disabled|>"));
							sProps.append( T("<|Disabled|>"));
							// milling, tolerance
							dProps.setLength(0);
							dProps.append(0);
							dProps.append(0);
							
							if(b == 0)
							{ 
								ptsTsl[0] = ptAngleLeft;
//								sProps[4] =  T("|right|");
								sProps[4] = T("|left|");
							}
							else
							{
								ptsTsl[0] = ptAngleRight;
//								sProps[4] = T("|left|");
								sProps[4] =  T("|right|");
							}
							//HSB-12452
							tslNew.dbCreate("GA-T" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
//							tslNew.setPropString(T("|Milling Type|"), "none");
//							tslNew.setPropDouble(T("|Tolerance|"), 0);
//								tslNew.recalc();

							// save the bottom TSL in the map
							entsTslBottomNew.append(tslNew);
							
						}
						if (iAngleBracket == 2 || iAngleBracket == 3)
						{ 
							// top or both
							// see if TSL is contained inside the map
							
							// insertion point of the connection
							Point3d ptAngleLeft;
							Point3d ptAngleRight;
							
							// if top beam is splitted, get the left top beam and the right beam
							Beam bmTop;
							Point3d ptBeamLeft;
							Point3d ptBeamRight;
							ptBeamLeft = bmNew.ptCen() - vx * .5 * bmNew.dD(vx);
							ptBeamRight = bmNew.ptCen() + vx * .5 * bmNew.dD(vx);
							// line beteen the bmNew and bmAux1
//							Beam bmTop;
							if(bmAux1.length()>0 && bmAux1[0].bIsValid())
							{ 
								bmTop = bmAux1[0];
							}
							else
							{ 
								if(b==0)
								{ 
									Beam bmTopLefts[0];
									bmTopLefts=Beam().filterBeamsHalfLineIntersectSort(bmTopPlate, ptBeamLeft-U(1)*vx, +vy);
									if(bmTopLefts.length()>0)
									{ 
										bmTop=bmTopLefts[0];
									}
								}
								else
								{ 
									Beam bmTopRights[0];
									bmTopRights=Beam().filterBeamsHalfLineIntersectSort(bmTopPlate, ptBeamRight-U(1)*vx, +vy);
									if(bmTopRights.length()>0)
									{ 
										bmTop=bmTopRights[0];
										
									}
								}
							}
							Vector3d vecAux = bmTop.vecD(vy);
							Point3d ptAux = bmTop.ptCen() - vy * .5 * bmTop.dD(vy);
//							ptAux.vis(2);
//							vecAux.vis(ptAux, 2);
							Plane pnAux(ptAux, vecAux);
							
//							Point3d ptBeamLeft;
//							Point3d ptBeamRight;
//							ptBeamLeft = bmNew.ptCen() - vx * .5 * bmNew.dD(vx);
//							ptBeamRight = bmNew.ptCen() + vx * .5 * bmNew.dD(vx);
							
							Plane pnBeamLeft(ptBeamLeft, vx);
							Plane pnBeamRight(ptBeamRight, vx);
							
							Line lnLeft = pnAux.intersect(pnBeamLeft);
							Line lnRight = pnAux.intersect(pnBeamRight);
							
							ptAngleLeft = lnLeft.closestPointTo(bmNew.ptCen());
							ptAngleLeft.vis(2);
							ptAngleRight = lnRight.closestPointTo(bmNew.ptCen());
//							ptAngleRight.vis(2);
							
						// create TSL
							TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
							GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
							int nProps[]={};			double dProps[]={};				String sProps[]={};
							Map mapTsl;	
							
//							gbsTsl.setLength(0);
//							gbsTsl.append(bmNew);
////							gbsTsl.append(bmAux1[0]);
							// GA-T now is O type and accepts entities not only genbeams
							entsTsl.setLength(0);
							entsTsl.append(bmTop);
							entsTsl.append(bmNew);
							
							//family, model, nail
							sProps.setLength(0);
							sProps.append("Cullen Metal Angle Bracket");
							sProps.append("LAB");
							sProps.append("LAB-180");
							// 
							sProps.append("nail+bolt");
							sProps.append(T("|left|"));
							sProps.append( T("|none|"));
							// painter
							sProps.append( T("<|Disabled|>"));
							sProps.append( T("<|Disabled|>"));
							// milling, tolerance
							dProps.setLength(0);
							dProps.append(0);
							dProps.append(0);
							if(b == 0)
							{ 
								ptsTsl[0] = ptAngleLeft;
								sProps[4] = T("|left|");
							}
							else
							{
								ptsTsl[0] = ptAngleRight;
								sProps[4] =  T("|right|");
							}
							// HSB-12452
							tslNew.dbCreate("GA-T" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
//							tslNew.setPropString(T("|Milling Type|"), "none");
//							tslNew.setPropDouble(T("|Tolerance|"), 0);
//								tslNew.recalc();

							// save the bottom TSL in the map
							entsTslTopNew.append(tslNew);
						}
						
//						PropString sAngleBrackets
					}
					
				}// for( int b=0; b<nNumberBm; b++)
				// save in map
				if (entsTslBottomNew.length() > 0)
				{ 
					// some angle brackets are created, save in map
					_Map.setEntityArray(entsTslBottomNew, true, sMapTslBottomName, "", "");
				}
				if (entsTslTopNew.length() > 0)
				{ 
					// some angle brackets are created, save in map
					_Map.setEntityArray(entsTslTopNew, true, sMapTslTopName, "", "");
				}
				
				
				// HSB-12683 Split Top Plate
				if(bTopPlate)
				{ 
					ptLeftPocket.vis(1);
					ptRightPocket.vis(1);
					double dCutLength=abs(vx.dotProduct(ptLeftPocket-ptRightPocket));
					Point3d ptCut=LineSeg(ptLeftPocket,ptRightPocket).ptMid();
					LineSeg lsTool (ptLeftPocket, ptRightPocket+vy*U(2000));
					PLine plTool(vy);
					plTool.createRectangle(lsTool, vx, vy);
					PlaneProfile ppTool(plTool);ppTool.vis(3);
//					ppBmElevation.shrink(-U(5));
					ppBmElevation.vis(4);
//					ppBmElevation.shrink(U(5));
					double daa = ppBmElevation.area();
					PlaneProfile ppAux=ppBmElevation;
					ppAux.intersectWith(ppTopPlate);
//					if (ppAux.area() / U(1) * U(1) > U(5))
					{
						for (int b = 0; b < bmTopPlate.length(); b++)
						{
							Beam bm=bmTopPlate[b];
							Body bd=bm.realBody();
							
							ptCut=Line(ptCut, vy).closestPointTo(Line(bm.ptCen(), bm.vecX()));
							ptCut.vis();
							
							PlaneProfile ppTP=bd.shadowProfile(plnZ);
							ppTP.vis(3);
							ppTP.intersectWith(ppTool);
							if (ppTP.area()/U(1)*U(1) > U(2)*U(2))
							{
								ppTP=bd.shadowProfile(plnZ);
								ppTP.subtractProfile(ppTool);
								if (ppTP.numRings()>1)
								{
									Point3d ptSplitLeft=Line(ptLeftPocket, vy).closestPointTo(Line(bm.ptCen(), bm.vecX()));
									Point3d ptSplitRight=Line(ptRightPocket, vy).closestPointTo(Line(bm.ptCen(), bm.vecX()));
									//bm.dbSplit(ptSplitRight, ptSplitLeft );
									Beam bmNew=bm.dbSplit(ptCut, ptCut);
									BeamCut bc(ptCut, vx, vy, vz, dCutLength, U(500), U(500), 0, 0, 0);
									bm.addToolStatic(bc);
									bmNew.addToolStatic(bc);
									//Check If the Result Beams are too small and intersect the original beam
									PlaneProfile ppBm1=bm.realBody().shadowProfile(plnZ);
									PlaneProfile ppBm2=bmNew.realBody().shadowProfile(plnZ);
									double dA1 = ppBm1.area();
									ppBm1.intersectWith(ppBmElevation);
									double dA2 = ppBm2.area();
									ppBm2.intersectWith(ppBmElevation);
//									if (ppBm1.area()/U(1)*U(1) > U(2)*U(2))
									if (ppBm1.area()/dA1 > .1)
									{
										bm.dbErase();
									}
//									if (ppBm2.area()/U(1)*U(1) > U(2)*U(2))
									if (ppBm2.area()/dA2 > U(2)*U(2))
									{
										bmNew.dbErase();
									}
								}
								else
								{
									BeamCut bc(ptCut, vx, vy, vz, dCutLength, U(500), U(500), 0, 0, 0);
									bm.addToolStatic(bc);
								}
							}
						}
					}
				}
				
				//HSB-12683 Split Bottom Plate
				if (bBottomPlate)
				{
					double dCutLength=abs(vx.dotProduct(ptLeftPocket-ptRightPocket));
					Point3d ptCut=LineSeg(ptLeftPocket,ptRightPocket).ptMid();
					LineSeg lsTool (ptLeftPocket-vy*U(500), ptRightPocket+vy*U(2000));
					PLine plTool(vy);
					plTool.createRectangle(lsTool, vx, vy);
					PlaneProfile ppTool(plTool);ppTool.vis(3);
					
					PlaneProfile ppAux=ppBmElevation;
					ppAux.intersectWith(ppBottomPlate);
//					if (ppAux.area()/U(1)*U(1) > U(5))
					{
						for (int b=0; b<bmBottomPlate.length(); b++)
						{
							Beam bm=bmBottomPlate[b];
							Body bd=bm.realBody();
							PlaneProfile ppTP=bd.shadowProfile(plnZ);
							ppTP.intersectWith(ppTool);
							if (ppTP.area()/U(1)*U(1) > U(5))
							{
								ppTP=bd.shadowProfile(plnZ);
								ppTP.subtractProfile(ppTool);
								if (ppTP.numRings()>1)
								{
									Point3d ptSplitLeft=Line(ptLeftPocket, vy).closestPointTo(Line(bm.ptCen(), bm.vecX()));
									Point3d ptSplitRight=Line(ptRightPocket, vy).closestPointTo(Line(bm.ptCen(), bm.vecX()));
									bm.dbSplit(ptSplitRight, ptSplitLeft );
								}
								else
								{
									BeamCut bc(ptCut, vx, vy, vz, dCutLength, U(500), U(500), 0, 1, 0);
									bm.addToolStatic(bc);
								}
							}
						}
					}
				}
			}
		}
		
		PlaneProfile ppThisPLFront (plnZ);
		for (int i = 0; i < bmCreatedThisWall.length(); i++)
		{
			PlaneProfile ppThisBm=bmCreatedThisWall[i].realBody().shadowProfile(plnZ);
			ppThisBm.shrink(-U(5));
			ppThisPLFront.unionWith(ppThisBm);
				
		}
		ppThisPLFront.shrink(U(5));
		//ppThisPLFront.vis(1);
		
		LineSeg lsLR=ppThisPLFront.extentInDir(vx);
		
		Point3d ptL=lsLR.ptStart();ptL.vis(1);
		Point3d ptR=lsLR.ptEnd();ptR.vis(2);
		Point3d ptM=lsLR.ptMid();
		
		//Check if a module Information should be set to the beams
		PlaneProfile ppAuxModule=ppThisPLFront;
		ppAuxModule.shrink(-U(2));
		String sModule="";
		int nColorMod=-1;
		for (int b=0; b<bmVer.length(); b++)
		{
			Beam bm=bmVer[b];
			Body bd=bm.realBody();
			
			PlaneProfile ppBm=bd.shadowProfile(plnZ);
			ppBm.intersectWith(ppAuxModule);
			if (ppBm.area()/U(1)*U(1) > U(2)*U(2))
			{
				if(bm.module() != "" )
				{
					sModule=bm.module();
					nColorMod=bm.color();
					break;
				}
			}
		}
		if (bModule)
		{
			if (sModule=="")
			{
				sModule=_ThisInst.handle()+el.handle();
			}
			for (int i=0; i<bmCreatedThisWall.length(); i++)
			{
				//if (bmCreatedThisWall.length()>1) Even if there is only 1 beam it will be set as a module
				{
					bmCreatedThisWall[i].setModule(sModule);
					bmCreatedThisWall[i].setColor(nColorMod);
				}
			}
		}
		
		
		//Remove the fix beams in case they are completely over the pointload
		if (nRemoveBeams)
		{
			//Erase the vertical beams that have interference with the element
			for (int i=0; i<bmFix.length(); i++)
			{
				Beam bm=bmFix[i];
				PlaneProfile ppThisBm=bm.realBody().shadowProfile(plnZ);
				ppThisBm.intersectWith(ppThisPLFront);
				if (ppThisBm.area()/U(1)*U(1) > U(2)*U(2))
				{
					bm.dbErase();
				}
			}
		}
		//Check interference with beams that can be removed
		for (int i=0; i<bmToCheckDeletion.length(); i++)
		{
			Beam bm=bmToCheckDeletion[i];
			PlaneProfile ppThisBm=bm.realBody().shadowProfile(plnZ);
			ppThisBm.intersectWith(ppThisPLFront);
			if (ppThisBm.area()/U(1)*U(1) > U(2)*U(2))
			{
				bm.dbErase();
			}
		}
		
		//Plane profile with the shape of the pocket
		LineSeg lsAllPL=ppThisPLFront.extentInDir(vx);
		PLine plAllAux(vz);
		plAllAux.createRectangle(lsAllPL, vx, vy);
		
		//Planeprofile with the size of the pocket or pointload
		PlaneProfile ppAllPLFront(plAllAux);
		//ppAllPLFront.intersectWith(ppEl);
		ppAllPLFront.vis(1);
		//Check Interference with Blocking
		for (int i=0; i<bmBlocking.length(); i++)
		{
			Beam bm=bmBlocking[i];
			PlaneProfile ppBlocking=bm.realBody().shadowProfile(plnZ);
			double dBlockingArea=ppBlocking.area()/U(1)*U(1);
			PlaneProfile ppThisBlocking=ppBlocking;
			ppBlocking.intersectWith(ppAllPLFront);
			if (ppBlocking.area()/U(1)*U(1) > U(2)*U(2))
			{
				//reportNotice("\nBlocking");
				if (dBlockingArea-ppBlocking.area()/U(1)*U(1) < U(3)*U(3))//Its almost fully cover by the pointload
				{
					//reportNotice("\nErase");
					bm.dbErase();
				}
				ppThisBlocking.subtractProfile(ppAllPLFront);
				ppThisBlocking.vis(2);
				if (ppThisBlocking.numRings()==1)//It's partially cover
				{
					
					Point3d ptRef=LineSeg(ppThisBlocking.extentInDir(vx)).ptMid();ptRef.vis(3);
					Plane plnCut;
					if (vx.dotProduct(ptL-ptRef)<0)
					{
						plnCut=Plane(ptR, vx);
					}
					else
					{
						plnCut=Plane(ptL, -vx);
					}
					
					Cut ctBlock(plnCut, ptRef, -1);
					bm.addToolStatic(ctBlock, _kStretchOnInsert);
					//reportNotice("\nOne Ring");
				}
				else if(ppThisBlocking.numRings()==2)
				{
					if (bm.vecX().dotProduct(vx)>0)
						bm.dbSplit(ptR, ptL);
					else
						bm.dbSplit(ptL, ptR);
					//reportNotice("\nSplit");
				}
			}
		}
		
		//Check if there is any beam required to notch, indicated by Beamcode H in Token Position 0
		
		//Collect the number of headers that are in the panel
		double dExtraOffset=U(3);
		Point3d ptAllCenters[0];
		for (int i=0; i<bmWithTool.length(); i++)
		{
			ptAllCenters.append(bmWithTool[i].ptCen());
		}
		
		if(ptAllCenters.length()>0)
		{
			Line ln1(ptAllCenters[0], vz);
			ptAllCenters=ln1.projectPoints(ptAllCenters);
			ptAllCenters=ln1.orderPoints(ptAllCenters, U(2));
			if (ptAllCenters.length()==1)
			{
				dExtraOffset=U(3);
			}
			else
			{
				dExtraOffset=U(5);
			}
		}
		
		for (int i=0; i<bmWithTool.length(); i++)
		{
			Beam bm=bmWithTool[i];
			Body bdCut=bm.realBody();
		
			Point3d ptShiftedCentre=bm.ptCen()+(U(5)*bm.vecY())+(U(5)*bm.vecZ());
			BeamCut bmCut(ptShiftedCentre, bm.vecX(), bm.vecY(), bm.vecZ(), U(10000), (bm.dD(bm.vecY())+U(10)+(dExtraOffset*2)), (bm.dD(bm.vecZ())+U(10))); 
			for(int j=0; j<bmCreatedThisWall.length(); j++)
			{
				bmCreatedThisWall[j].addToolStatic(bmCut);
				bmCreatedThisWall[j].setLabel("N");
			}
		}
	}
	
	Display dp(3);
	dp.elemZone(el, 0, 'E');
	for (int i=0; i<ppDraw.length(); i++)
	{
		LineSeg ls=ppDraw[i].extentInDir(vz);
		
		PLine plDraw(_ZW);
		plDraw.createRectangle(ls, vx, vz);
		
		//Collect the extreme point to dimension top, bottom, left and right
		Point3d ptAllVertex[]=plDraw.vertexPoints(true);
		Point3d ptCenterPline;
		ptCenterPline.setToAverage(ptAllVertex);
		
		Point3d ptMostLeft=ptCenterPline;
		Point3d ptMostRight=ptCenterPline;
		Point3d ptMostUp=ptCenterPline;
		Point3d ptMostDown=ptCenterPline;
	
		for (int i=0; i<ptAllVertex.length(); i++)
		{
			 Point3d pt=ptAllVertex[i];
			 if (vx.dotProduct(ptMostLeft-pt)>0)
			  ptMostLeft=pt;
			 if (vx.dotProduct(ptMostRight-pt)<0)
			  ptMostRight=pt;
			 if (vz.dotProduct(ptMostUp-pt)<0)
			  ptMostUp=pt;
			 if (vz.dotProduct(ptMostDown-pt)>0)
			  ptMostDown=pt;
		}
		
		Line lnVX(csEl.ptOrg(),vx);
		Line lnVZ(csEl.ptOrg(),-vz);
		Point3d ptVZOrd[]=lnVZ.orderPoints(ptAllVertex);
		Point3d ptVXOrd[]=lnVX.orderPoints(ptVZOrd);
		
		double dPlWidth=abs((vx.dotProduct(ptMostLeft-ptMostRight)));
		double dPlHeight=abs((vz.dotProduct(ptMostUp-ptMostDown)));
		PLine plCross1;
		PLine plCross2;
		if(ptVXOrd.length()>0)
		{
			plCross1=PLine(ptVXOrd[0],ptVXOrd[0]+(vx*dPlWidth)-(vz*dPlHeight));
			plCross2=PLine(ptVXOrd[0]-(vz*dPlHeight),ptVXOrd[0]+(vx*dPlWidth));
		}
	
		dp.draw(plDraw);
		dp.draw(plCross1);
		dp.draw(plCross2);
		// pLine of the beams to be drawn as support
		Map mpPL;
		mpPL.setPLine("plPointLoad", plDraw);
		_Map.setMap("mpPL", mpPL);
	}
	
	//Append the new areas so they will be available to the next element
	if(bTransferLoad)
	{
		for (int i=0; i<ppNewAreas.length(); i++)
		{
			ppAllBeams.append(ppNewAreas[i]);
		}
	}
	
	assignToElementGroup(el, false, 0, 'E');
	
	TslInst tslAll[]=el.tslInstAttached();
	for (int t=0; t<tslAll.length(); t++)
	{
		TslInst tslNew=tslAll[t];
		if (!tslNew.bIsValid()) continue;
		if ( tslNew.scriptName() == "hsb_Apply Naillines to Elements")
		{
			tslNew.recalcNow("Reapply NailLines");
		}
		if ( tslNew.scriptName() == "hsb_FrameNailing")
		{
			tslNew.recalcNow("Reapply Frame Nails");
		}
	}
}

//Store all the beams that are been created to the map
for (int n=0; n<bmCreated.length(); n++)
{
	_Map.setEntity("bm"+n, bmCreated[n]);
}

//eraseInstance();
//return;
















#End
#BeginThumbnail
























#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="100" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="1841" />
        <int nm="BreakPoint" vl="1957" />
        <int nm="BreakPoint" vl="1958" />
        <int nm="BreakPoint" vl="1883" />
        <int nm="BreakPoint" vl="1764" />
        <int nm="BreakPoint" vl="1769" />
        <int nm="BreakPoint" vl="1888" />
        <int nm="BreakPoint" vl="1000" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16007: Investigate the bottom beam from the body intersection " />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="21" />
      <str nm="Date" vl="9/9/2022 9:08:04 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16007: fix when investigating splitted bottom plate" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="20" />
      <str nm="Date" vl="9/7/2022 10:28:43 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12683: property to cut top/bottom plate active also for point load, not only for pocket load" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="19" />
      <str nm="Date" vl="11/11/2021 5:50:07 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12452: use GA-T and insert Cullen, LAB, 180 at the outside beams" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="7/2/2021 11:22:51 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End