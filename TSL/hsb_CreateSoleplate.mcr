#Version 8
#BeginDescription
#Versions:
1.31 11.04.2022 HSB-15012: fix when doing splitting at doors (make sure soleplates are provided for given wall) Author: Marsel Nakuci
1.30 05.04.2022 HSB-15012: fix when doing splitting at doors Author: Marsel Nakuci
1.29 05.04.2022 HSB-15012: dont assign soleplates at elements Author: Marsel Nakuci
1.28 16.12.2021 HSB-13641: add property offset Author: Marsel Nakuci
1.27 11.05.2021 HSB-11750: split beams at doors by using extra TSL to enable parallelisation; fix bug when applying Cuts at soleplates Author: Marsel Nakuci
1.26 10.05.2021 HSB-11750: add property split soleplate at door No/Yes Author: Marsel Nakuci
Modified by: Marsel Nakuci (marsel.nakuci@hsbcad.com)
20.01.2021  -  version 1.25

Modified by: Alberto Jena (aj@hsb-cad.com)
16.02.2016  -  version 1.23







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 31
#KeyWords Soleplate
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
// 1.31 11.04.2022 HSB-15012: fix when doing splitting at doors (make sure soleplates are provided for given wall) Author: Marsel Nakuci
// 1.30 05.04.2022 HSB-15012: fix when doing splitting at doors Author: Marsel Nakuci
// 1.29 05.04.2022 HSB-15012: dont assign soleplates at elements Author: Marsel Nakuci
// Version 1.28 16.12.2021 HSB-13641: add property offset Author: Marsel Nakuci
// Version 1.27 11.05.2021 HSB-11750: split beams at doors by using extra TSL to enable parallelisation; fix bug when applying Cuts at soleplates Author: Marsel Nakuci
// Version 1.26 10.05.2021 HSB-11750: add property split soleplate at door No/Yes Author: Marsel Nakuci
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 25.05.2008
* version 1.0: Release Version
*1067
* date: 10.06.2008
* version 1.1: Set the group as Deliverable Container
*
* date: 12.06.2008
* version 1.2: Create a diferent group for the Precuts, And a Pull Down Menu for the Anchors
*
* Modify by: Mick Kelly (mk@hsb-cad.com)
* date: 12.06.2008
* version 1.3: Release Version
*
* date: 12.06.2008
* version 1.3: Addition of Anchor types.
*
* Modify by: Alberto Jena (mk@hsb-cad.com)
* date: 25.06.2008
* version 1.4: Add Yes/No Option for metal Parts and Precuts, Direction of creation and Restraint.
*
* date: 27.06.2008
* version 1.5: Add hardware Material and create a Table with that, using the "hsb_SolePlate Material Table" TSL
*
* date: 10.11.2008
* version 1.6: JH/MK Addition of Restraint types and description
*
* date: 00.06.2009
* version 1.7: 	Set Property to Insert or Not BOM Table
*				Property to cut internal soplates flush with external Soleplates
*				Fix the BOM
*				Properties to insert the External and Party Walls in the OPM
*
* date: 30.06.2009
* version 1.8:	Get the width of the timber to set that in the soleplates
*
* date: 06.08.2009
* version 1.9:	Fix with the Soleplate Table Values
*
* date: 30.09.2009
* version 1.10:	Fix some connections, made it more robust and fix T junction property
*
* date: 10.05.2010
* version 1.11:	Change the Table and some small fixes on export
*
* date: 16.07.2010
* version 1.12:	Fix issue with qty of restrain.
*
* date: 03.09.2010
* version 1.13:	Add properties so the customer can define custom types for Nailplates, Anchors and Restraint
*
* date: 09.11.2010
* version 1.14:Add the option to apply an extrusion profile to the first level of the soleplates
*
* date: 22.11.2010
* version 1.15:Fix to allow the changes on the Material Table TSL
*
* date: 14.02.2011
* version 1.17:Allow the TSL to run in sip elements but they will need to be generated.
*
* date: 10.03.2011
* version 1.18:Remove the option for a extrusion profile and add a chamfered
*
* date: 29.03.2011
* version 1.19:Update the Fixings from the List
*
* date: 15.08.2012
* version 1.20:Add the option to set the color of the beams
*
* date: 06.01.2015
* version 1.22:Added wall types filter for locating plate
*
* date: 16.02.2015
* version 1.23: Added check after dbJoin so that a beam is only re-evaluated with other beams if the join succeeded
*
* date: 20.01.2021
* version 1.24: HSB-10182: Add dropdown property Locator position { inside face, outside face}
*
* date: 20.01.2021
* version 1.25: HSB-10182: guard against negative or 0 input at max. Length and Min. Length
*/

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                      Properties

Unit(1,"mm"); // script uses mm
double dEps = U(0.1);

//Next int nInt available=5;
//Next int nString available=36;
//Next int nDouble=13;

String sArNY[] = {T("No"), T("Yes")};

PropString psExtType(0, "A;B;",  T("Code External Walls"));
psExtType.setDescription(T("Please type the codes of the external walls separate by ; "));

PropString psIntType(1, "F;G;",  T("Code Party Walls"));
psIntType.setDescription(T("Please type the codes of the internal walls separate by ; "));

PropString sName(2,"SolePlate","Name");
sName.setDescription("");

PropString sMaterialSP(3,"","Material");
sMaterialSP.setDescription("");

PropString sGrade(4,"","Grade");
sGrade.setDescription("");

PropString sInformation(5,"","Information");
sInformation.setDescription("");

//PropString sLabel(4,"SP","Label");
PropString sSublabel(6,"","Sublabel");
sSublabel.setDescription("");

PropString sSublabel2(7,"","Sublabel 2");
sSublabel2.setDescription("");

//PropString sGrpNm0(7, "House Level", T("House Level group name"));
PropString sGrpNm1(8, "00_GF-Soleplates", T("House Level group name"));
sGrpNm1.setDescription("");
PropString sGrpNm2(9, "GF-Soleplates", T("Floor Level group name"));
sGrpNm2.setDescription("");

//PropDouble dWSolePlate(0, U(140), T("Specify width of soleplates"));
PropDouble dH1SolePlate(0, U(38), T("Height of soleplate 1"));
dH1SolePlate.setDescription("");
PropDouble dH2SolePlate(1, U(38), T("Height of soleplate 2"));
dH2SolePlate.setDescription("");
PropDouble dH3SolePlate(2, U(0), T("Height of soleplate 3"));
dH3SolePlate.setDescription("");
PropDouble dH4SolePlate(3, U(0), T("Height of soleplate 4"));
dH4SolePlate.setDescription("");

PropInt nColorBeams(5, 1, T("Color"));
//PropString sProfile (34, ExtrProfile().getAllEntryNames(), T("|Extrusion profile for soleplate 1|"));
//sProfile.setDescription(T("This option allow the user to select the extrusion profile that will be set in the fisrt level of the soleplate"));

PropString sChamfer (34, sArNY, T("|Chamfer soleplate 1|"));
sChamfer.setDescription(T("This option allow to cut the edges of the fisrt level of the soleplate"));

PropDouble dMinLength(4, U(600), T("Min Length"));
dMinLength.setDescription("");

PropDouble dMaxLength(5, U(4800), T("Max Length"));
dMaxLength.setDescription("");

PropString sLocatingPlate(10, sArNY, T("Create Locating Plate"));
sLocatingPlate.setDescription("This allow the user to create the Soleplate 1 as Locating Plate with a diferent width");
// HSB-10182
String sLocatorPositionName=T("|Locator Position|");	
String sLocatorPositions[] ={ T("|Inside face|"), T("|Outside face|")};
PropString sLocatorPosition(39, sLocatorPositions, sLocatorPositionName);	
sLocatorPosition.setDescription(T("|Defines the Position of the Locator|"));

// HSB-13641
String sOffsetSolePlateName=T("|Offset|");	
PropDouble dOffsetSolePlate(13, U(0), sOffsetSolePlateName);	
dOffsetSolePlate.setDescription(T("|Defines the Offset for the locator|"));
//dOffsetSolePlate.setCategory(category);

//sLocatorPosition.setCategory(category);
String sSplitAtDoorName=T("|Split soleplate at doors|");
PropString sSplitAtDoor(40, sArNY, sSplitAtDoorName);
sSplitAtDoor.setDescription(T("|Defines whether the soleplate is splitted at doors|"));
//sSplitAtDoor.setCategory(category);
// 
PropDouble dWLocatingPlate(6, U(90), T("Width Locating Plate"));
dWLocatingPlate.setDescription("");

PropString psLocatingPlateFilter(38, "" ,T("|Wall types filter for Locating Plate|"));
psLocatingPlateFilter.setDescription("Only creates locating plates for the walls in the filter.  If the filter is empty all wall types will get a locating plate. Please type the codes of the walls separate by ; ");

PropString sTOverlap(11, sArNY, T("T Junction Soleplate Overlap"));
sTOverlap.setDescription("This allow you to overlap the soleplate of internal walls with the external");

PropString sPrecut(12, sArNY, T("Create Precut Group"));
sPrecut.setDescription("");

String sArOri[] = {T("Below Wall"), T("Within Wall")};
PropString sOrientation(13, sArOri, T("Soleplate Location"));
sOrientation.setDescription("");

PropString sBottomDetail (14, sArNY, T("Overwrite Bottom Detail"));
sBottomDetail .setDescription("If the Soleplate plate location is set to be Within the Wall, then you must have your Wall details modified to permit this.");

//Metal Part

PropString sDispRep(15, "", T("Show the Metal Parts in Disp Rep"));
sDispRep.setDescription("");

//NailPlates
PropString sShowNailPlate(16, sArNY, T("Insert Nail Plates"));
sShowNailPlate.setDescription("");

String strNailPlateModels[]={"Other Model Type", "NP-80-100", "NP-80-200", "NP-80-300", "NP-100-100", "NP-100-200", "NP-100-300", "NP-150-100", "NP-150-200", "NP-150-300"};
PropString sNameNailPlate(17, strNailPlateModels, T("Nail Plate Model"), 1);

PropString strCustomNailPlateModel (31, "**Other Type**", T("Other Nail Plate Type"));
strCustomNailPlateModel.setDescription( T("Please fill this value if you choose 'Other Model Type' above"));

//Restraint
String sArRestraint[] = {T("No"), T("External"), T("All")};
PropString sShowRestraint(18, sArRestraint, T("Insert Holding Down Straps"));
sShowRestraint.setDescription("");

String strRestraintModels[]={"Other Model Type", "ST-PFS-50", "ST-PFS-75", "ST-PFS-100", "ST-PFS-50-M", "ST-PFS-75-M", "ST-PFS-100-M", "RE240", "RE90"};
PropString sNameRestraint(19, strRestraintModels, T("Holding Down Straps"), 1);
sNameRestraint.setDescription("");

PropString strCustomRestraintModel (32, "**Other Type**", T("Other Restraint Type"));
strCustomRestraintModel.setDescription( T("Please fill this value if you choose 'Other Model Type' above"));

PropDouble dRestraintCenters (7, U(1000), T("Distance Between Straps"));
dRestraintCenters.setDescription("");

//Anchors
PropString sShowAnchors(20, sArNY, T("Insert Soleplate Anchors"));
sShowAnchors.setDescription("");

String strAnchorModels[]={"Other Model Type", "SP90", "SP240", "SPU90", "SPU96", "SPU240", "SPA38", "SPA50"};
PropString sNameAnchor(21, strAnchorModels, T("Anchor Model"), 1);
sNameAnchor.setDescription("");

PropString strCustomAnchorModel (33, "**Other Type**", T("Other Anchor Type"));
strCustomAnchorModel.setDescription( T("Please fill this value if you choose 'Other Model Type' above"));

PropDouble dAnchorCenters (8, U(1000), T("Distance Between Anchors"));
dAnchorCenters.setDescription("");

//Material Table

PropString sAA(30,"------------------------", "Details of the BOM");
sAA.setReadOnly(TRUE);

PropString sShowBOM(22, sArNY, T("Show BOM"));

PropString sDimStyle(23,_DimStyles,T("Dimstyle"));

PropInt nLineColor(0, 171, T("|Color Header and Lines|"));

PropInt nColor (1,143,T("|Row Color|"));

PropString sPackers(24, sArNY, T("Insert Packers"));
sPackers.setDescription("");

PropInt nPackersQTY (2, 4, T("Number of Packers"));
nPackersQTY.setDescription("");
PropDouble dPackersCenters (9, U(900), T("Distance Between Packers"));
dPackersCenters.setDescription("");

/*----------------------------DPC----------------------------*/
PropString sDPC(25, sArNY, T("Insert DPC"));
sDPC.setDescription("");

//String strDPCTypes[0];
//strDPCTypes.append("Other Model Type");
//strDPCTypes.append("Other Model Type");

//PropString sDPSMaterial(27, strDPCTypes, T("DPC Material Description"));
//sDPCMaterial.setDescription("");

//PropString strCustomDPCMaterial (37, "**Other Type**", T("Other DPC Type"));
//strCustomDPCMaterial.setDescription( T("Please fill this value if you choose 'Other Model Type' above"));

/*----------------------------SCREWS----------------------------*/
PropString sScrews(26, sArNY, T("Insert Screws"));
sScrews.setDescription("");

String strScrewTypes[0];
strScrewTypes.append("Other Model Type");
strScrewTypes.append("Tapcon concrete screw 7.5 x 45mm hex head ITW016671");
strScrewTypes.append("Tapcon concrete screw 7.5 x 60mm hex head ITW016672");
strScrewTypes.append("Tapcon concrete screw 6 x 70mm csk ITW921516");
strScrewTypes.append("Tapcon concrete screw 6 x 82mm csk ITW921517");
strScrewTypes.append("Hit M nylon hammerscrew 8 x 92mm ITW050135");

PropString sScrewMaterial(27, strScrewTypes, T("Screw Material Description"));
sScrewMaterial.setDescription("");

PropString strCustomScrewMaterial (37, "**Other Type**", T("Other Screws Type"));
strCustomScrewMaterial.setDescription( T("Please fill this value if you choose 'Other Model Type' above"));

PropDouble dScrewsCenters (10, U(900), T("Distance Between Screws"));
dScrewsCenters.setDescription("");
PropInt nScrewsBox (3, 50, T("Screws per Box"));
nScrewsBox.setDescription("");

/*----------------------------NAILS----------------------------*/
PropString sNails(28, sArNY, T("Insert Nails"));
sNails.setDescription("");

String strNailTypes[0];
strNailTypes.append("Other Model Type");
strNailTypes.append("Paslode IM350 Nail Fuel Pack 3.1x90mm smooth shank GalvPlus ITW141234");
strNailTypes.append("Paslode IM90i Nail Fuel Pack 3.1x90mm smooth shank GalvPlus ITW142037");
strNailTypes.append("Paslode IM90i Nail Fuel Pack 3.1x90mm ring shank GalvPlus ITW142038");
PropString sNailMaterial(29, strNailTypes, T("Nails Type Description"));
sNailMaterial.setDescription("");

PropString strCustomNailMaterial (36, "**Other Type**", T("Other Nail Type"));
strCustomNailMaterial.setDescription( T("Please fill this value if you choose 'Other Model Type' above"));

PropDouble dNailsCenters (11, U(600), T("Distance Between Nails"));
dNailsCenters.setDescription("");
PropInt nNailsBox (4, 2200, T("Nails per Box"));
nNailsBox.setDescription("");

PropDouble dExtraPercent (12, 10, T("Extra Percent for Materials"));
dExtraPercent.setDescription("");

// Load the values from the catalog
if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

int bTOverlap= sArNY.find(sTOverlap,0);
int bPrecut = sArNY.find(sPrecut,0);
int bOrientation = sArOri.find(sOrientation,0);
int bBottomDetail= sArNY.find(sBottomDetail,0);
int bShowNailPlate = sArNY.find(sShowNailPlate,0);
int bShowRestraint = sArRestraint.find(sShowRestraint,0);
int bShowAnchors = sArNY.find(sShowAnchors,0);
int bPackers = sArNY.find(sPackers,0);
int bDPC = sArNY.find(sDPC,0);
int bScrews = sArNY.find(sScrews,0);
int bNails = sArNY.find(sNails,0);
int bLocatingPlate= sArNY.find(sLocatingPlate,0);
int bChamfer= sArNY.find(sChamfer,0);

//Fill the values for the externall Walls
String arSCodeExternalWalls[0];
String sExtType=psExtType;
sExtType.trimLeft();
sExtType.trimRight();
sExtType=sExtType+";";
for (int i=0; i<sExtType.length(); i++)
{
	String str=sExtType.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
		arSCodeExternalWalls.append(str);
}

String arSCodePartyWalls[0];
String sIntType=psIntType;
sIntType.trimLeft();
sIntType.trimRight();
sIntType=sIntType+";";
for (int i=0; i<sIntType.length(); i++)
{
	String str=sIntType.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
		arSCodePartyWalls.append(str);
}

String arSLocatingPlateFilter[0];
String sLocatingPlateFilter=psLocatingPlateFilter;
sLocatingPlateFilter.trimLeft();
sLocatingPlateFilter.trimRight();
sLocatingPlateFilter=sLocatingPlateFilter+";";
for (int i=0; i<sLocatingPlateFilter.length(); i++)
{
	String str=sLocatingPlateFilter.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
		arSLocatingPlateFilter.append(str);
}

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                           Insert

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
}

int bShowBOM = sArNY.find(sShowBOM, 0);
sShowBOM.setReadOnly(TRUE);

if(_bOnInsert)
{
	if (bShowBOM)
	{
		_Pt0=getPoint("Select the Location for the Material Table");
	}
	
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}


if( _Element.length()==0 ){
	eraseInstance();
	return;
}
//return
/*
double dExProfileW;
double dExProfileH;
if (sProfile != _kExtrProfRectangular)
{
	ExtrProfile ep(sProfile ); 

	PlaneProfile ppExtProf();
	ppExtProf=ep.planeProfile();
	LineSeg ls=ppExtProf.extentInDir(_XW);
	dExProfileW=abs(_XW.dotProduct(ls.ptStart()-ls.ptEnd()));
	dExProfileH=abs(_YW.dotProduct(ls.ptStart()-ls.ptEnd()));
}
*/

double arDHSolePlate[0];
//if (dH1SolePlate>0 && sProfile == _kExtrProfRectangular)
if (dH1SolePlate>0)
{
	arDHSolePlate.append(dH1SolePlate);
}
//else if (sProfile != _kExtrProfRectangular)
//{
//	arDHSolePlate.append(dExProfileH);
//}
if (dH2SolePlate>0)
	arDHSolePlate.append(dH2SolePlate);
if (dH3SolePlate>0)
	arDHSolePlate.append(dH3SolePlate);
if (dH4SolePlate>0)
	arDHSolePlate.append(dH4SolePlate);

//-----------------------------------------------------------------------------------------------------------------------------------
//                                      Loop over all elements.

ElementWall elWall[0];
String strWallNames[0];

for( int e=0; e<_Element.length(); e++ )
{
	ElementWall el = (ElementWall) _Element[e];
	if (el.bIsValid())
	{
		elWall.append(el);
		strWallNames.append(el.code()+el.number());
	}
}

//_Pt0=elWall[0].ptOrg();

Beam bmAll[0];
int nLevelAll[0];
int nPrecutLevel=0;

double dTh=U(2);
double dWi=U(40);
double dLe=U(80);

//Clonning TSL 
TslInst tsl;
String sScriptName = "hsb_NailPlate"; // name of the script of the Metal Part
Vector3d vecUcsX = _XW;
Vector3d vecUcsY = _YW;
Entity lstEnts[0];
Beam lstBeams[0];
Point3d lstPoints[0];
int lstPropInt[0];
double lstPropDouble[0];
String lstPropString[0];

lstPropDouble.append(dTh);
lstPropDouble.append(dWi);
lstPropDouble.append(dLe);
lstPropString.append(sDispRep);
lstPropString.append(sNameNailPlate);
lstPropString.append(strCustomNailPlateModel);

String strLevelName=sGrpNm2+"_1";
Group grpSolePlate(sGrpNm1 + "\\" + strLevelName );
grpSolePlate.setBIsDeliverableContainer(TRUE);

int nDoorQty=0;

int nNumberofLevels=0;
//return
int iSplitAtDoor = sArNY.find(sSplitAtDoor);
for( int e=0; e<elWall.length(); e++ )
{
	ElementWallSF el = (ElementWallSF) elWall[e];
	CoordSys cs=el.coordSys();
	Vector3d vx=cs.vecX();
	Vector3d vy=cs.vecY();
	Vector3d vz=cs.vecZ();
	Point3d ptOrgEl=cs.ptOrg();
	String sCode = el.code();
		
	double dWSolePlate;
	double dWallThickness=abs(el.dPosZOutlineBack());
	double dWallThickness1=abs(el.dPosZOutlineFront());
	
	if (el.dBeamWidth()>0)
	{
		dWSolePlate=el.dBeamWidth();
		
	}
	else
	{
		Sip spAll[]=el.sip();
		if (spAll.length()>0)
		{
			Sip sp=spAll[0];
			SipStyle spStyle=sp.style();
			double dThick=spStyle.dThickness();
			dWSolePlate=dThick;
		}
		if (dWSolePlate<1)
		{
			Wall wall=(Wall) el;
			if (wall.bIsValid())
			{
				dWSolePlate=wall.instanceWidth();
			}
			else
			{
				if (dWallThickness<=U(105))
				{
					dWSolePlate=U(89);
				}
				else
				{
					dWSolePlate=U(140);
				}
			}
		}
	}

	Opening op[]=el.opening();
	// HSB-11750
	PlaneProfile ppDoors[0];
	for (int o=0; o<op.length(); o++)
	{
		if (op[o].openingType()==_kDoor)
		{
			nDoorQty++;
			PlaneProfile ppO(el.coordSys());
			ppO.joinRing(op[o].plShape(), _kAdd);
			ppO.vis(3);
			ppDoors.append(ppO);
		}
	}
	

	if (bOrientation)
	{
		ptOrgEl=ptOrgEl+vy*(dH1SolePlate+dH2SolePlate+dH3SolePlate+dH4SolePlate);
	}

	Line lnX (ptOrgEl-vz*(dWSolePlate*0.5), el.vecX());
	Line lnXBack (ptOrgEl-vz*(dWSolePlate), el.vecX());
	
	PLine plOut=el.plOutlineWall();
	
	Point3d ptStartEl;
	Point3d ptEndEl;
	
	if (abs(vx.dotProduct(ptOrgEl-el.ptStartOutline()))>abs(vx.dotProduct(ptOrgEl-el.ptEndOutline())))
	{
		ptStartEl=el.ptEndOutline();
		ptEndEl=el.ptStartOutline();
	}
	else
	{
		ptStartEl=el.ptStartOutline();
		ptEndEl=el.ptEndOutline();
	}

	double dLen=abs(vx.dotProduct(ptStartEl-ptEndEl));

	Beam bmAllSolePlates[0];
	int nSolePlateLevel[0];
	double dTransform ;
	
	nNumberofLevels=0;
	
	for( int j=0;j<arDHSolePlate.length();j++ )
	{
		double dHSolePlate = arDHSolePlate[j];
		if( dHSolePlate <= 0 )break;
		dTransform  = dTransform + dHSolePlate;
		
		int nLevel=j+1;
		nNumberofLevels++;
		
		Vector3d vTransform;
											
		Beam bmSolePlate;
		
		//Point to add the chanfered tool
		Point3d ptChamferFront;
		Point3d ptChamferBack;
		
		if (bLocatingPlate && nLevel==1)
		{
			int bCreatePlate=false;
			if(arSLocatingPlateFilter.length()==0)
			{
				bCreatePlate = true;
			}
			else
			{
				if(arSLocatingPlateFilter.find(sCode, -1)!=-1)
				{
					bCreatePlate=true;
				}
			}
			
			if(bCreatePlate) 
			{
				// HSB-10182
				if(sLocatorPositions.find(sLocatorPosition)==0)
				{ 
					// inside face
					// HSB-13641 Offset
					bmSolePlate.dbCreate(ptOrgEl-vz*dOffsetSolePlate, vx, vy, vz, dLen, dHSolePlate, dWLocatingPlate, 1, 1, -1); 
				}
				else
				{
					// HSB-13641 offset value
					bmSolePlate.dbCreate(ptOrgEl-vz*(dWSolePlate-dOffsetSolePlate), vx, vy, vz, dLen, dHSolePlate, dWLocatingPlate, 1, 1, 1); 
				}
			}
		}
		else
		{
			bmSolePlate.dbCreate(ptOrgEl, vx, vy, vz, dLen, dHSolePlate, dWSolePlate, 1, 1, -1);
		}
		// HSB-15012
//		bmSolePlate.assignToElementGroup(el, false, 0, 'Z' );
		bmSolePlate.setColor(nColorBeams);
		bmSolePlate.setType(_kSFSolePlate); 
		
		bmSolePlate.setName(sName);
		bmSolePlate.setMaterial(sMaterialSP);
		bmSolePlate.setGrade(sGrade);
		bmSolePlate.setInformation(sInformation+";"+el.number());
		bmSolePlate.setSubLabel(sSublabel);
		bmSolePlate.setSubLabel2(sSublabel2);
		
		if (bChamfer && nLevel==1)
		{
			Vector3d vzToolFront=vy+vz;
			Vector3d vzToolBack=vy+(-vz);
			vzToolFront.normalize();
			vzToolBack.normalize();
			Point3d ptCutFront=bmSolePlate.ptCen()+vy*(dHSolePlate*0.5)+vz*(dWSolePlate*0.5);
			Point3d ptCutBack=bmSolePlate.ptCen()+vy*(dHSolePlate*0.5)-vz*(dWSolePlate*0.5);
			
			ptCutFront=ptCutFront-vzToolFront*U(7);
			ptCutBack=ptCutBack-vzToolBack*U(7);
			
			Cut ctFront (ptCutFront, vzToolFront);
			Cut ctBack (ptCutBack, vzToolBack);
			
			bmSolePlate.addToolStatic(ctFront);
			bmSolePlate.addToolStatic(ctBack);
		}
		
		if( arSCodeExternalWalls.find(sCode) != -1 )
			bmSolePlate.setLabel("Ext");
		else if (arSCodePartyWalls.find(sCode) != -1)
			bmSolePlate.setLabel("Int Party");
		else
			bmSolePlate.setLabel("Int");
		
		String strLevelName=sGrpNm2+"_Level "+nLevel;
		
		if (j==arDHSolePlate.length()-1)
		{
			nPrecutLevel=j+1;
			if (bPrecut)
			{
				bmSolePlate.setSubLabel("Precut");

				strLevelName=strLevelName+"_Precut";
			}
			else
			{
				bmSolePlate.setSubLabel(sSublabel);
			}
		}
		else
		{
			bmSolePlate.setSubLabel(sSublabel);
		}
		
		grpSolePlate.setNamePart(1, strLevelName);
		grpSolePlate.setBIsDeliverableContainer(TRUE);
		
		grpSolePlate.addEntity(bmSolePlate, false);
							
		vTransform = -el.vecY() * dTransform;
		bmSolePlate.transformBy(vTransform);
		
		bmAllSolePlates.append(bmSolePlate);
		nSolePlateLevel.append(j+1);
		nLevelAll.append(j+1);
		bmAll.append(bmSolePlate);
	}
	
	if (bBottomDetail)
	{
		String strBottomDetail=el.code();
		strBottomDetail=strBottomDetail+"O"+nNumberofLevels;
		el.setConstrDetailBottom(strBottomDetail);
	}
	
	Point3d ptExt[]=plOut.vertexPoints(TRUE);
	Point3d ptCenter;
	ptCenter.setToAverage(ptExt);
	ptCenter.vis(2);
	
	double dDistToCenter=abs(el.vecX().dotProduct(el.ptOrg()-ptCenter));
	
	String strName=el.code()+el.number();
	Element elCon[] = el.getConnectedElements();
	for (int i=0; i<elCon.length(); i++)
	{
		ElementWallSF elC = (ElementWallSF) elCon[i];
		if (!elC.bIsValid())
			continue;
		elC.plEnvelope().vis(4);
		CoordSys csC=elC.coordSys();
		Vector3d vxC=csC.vecX();
		Vector3d vyC=csC.vecY();
		Vector3d vzC=csC.vecZ();
		Point3d ptOrgC=csC.ptOrg();
		
		double dWallThicknessC=abs(elC.dPosZOutlineBack());
		if (elC.dBeamWidth()>0)
		{
			dWallThicknessC=elC.dBeamWidth();
		}
		else
		{
			if (dWallThicknessC<=U(105))
			{
				dWallThicknessC=U(89);
			}
			else
			{
				dWallThicknessC=U(140);
			}
		}
		
		PLine plOutC=elC.plOutlineWall();
		
		Point3d ptAllC[]=plOutC.vertexPoints(TRUE);
		Point3d ptAll[]=plOut.vertexPoints(TRUE);
		Point3d ptInContact[0];
		for (int i=0; i<ptAllC.length(); i++)
		{
			if (plOut.isOn(ptAllC[i]))
			{
				ptInContact.append(ptAllC[i]);
			}
		}
		for (int i=0; i<ptAll.length(); i++)
		{
			if (plOutC.isOn(ptAll[i]))
			{
				ptInContact.append(ptAll[i]);
			}
		}
		for (int i=0; i<ptInContact.length()-1; i++)
			for (int j=i+1; j<ptInContact.length(); j++)
				if ((ptInContact[i]-ptInContact[j]).length()<U(2))
				{
					ptInContact.removeAt(j);
					j--;
				}
		
		String strNameElC=elC.code()+elC.number();
		
		if (abs(vx.dotProduct(vxC))>0.98)
			continue;
		
		int nAux = strWallNames.find(strNameElC,-1);
		if (nAux==-1) continue;

		Line lnFrontCon(elC.ptOrg(), elC.vecX());
		Line lnBackCon(elC.ptOrg()-elC.vecZ()*dWallThicknessC, elC.vecX());
		Point3d ptIntersect[0];
		ptIntersect.append(lnX.closestPointTo(lnFrontCon));
		ptIntersect.append(lnX.closestPointTo(lnBackCon));
		if (ptIntersect.length()<2)
			continue;
			
		Point3d ptClose;
		Point3d ptFar;
		if (abs(vx.dotProduct(ptCenter-ptIntersect[0]))>abs(vx.dotProduct(ptCenter-ptIntersect[1])))
		{
			ptFar=ptIntersect[0];
			ptClose=ptIntersect[1];
		}
		else
		{
			ptFar=ptIntersect[1];
			ptClose=ptIntersect[0];
		}
		
//		ptFar.vis(3);
//		ptClose.vis(4);
		Point3d ptCenterCon;
		ptCenterCon.setToAverage(ptIntersect);
//		ptCenterCon.vis(1);
		
		Point3d ptExtConWall[]=elC.plOutlineWall().vertexPoints(TRUE);
		Point3d ptCenterConWall;
		ptCenterConWall.setToAverage(ptExtConWall);
//		ptCenterConWall.vis();
		double dDistToCenterConWall=abs(elC.vecX().dotProduct(elC.ptOrg()-ptCenterConWall));
		//double dA1=abs(el.vecX().dotProduct(ptCenterCon-ptCenter));
		if (abs(el.vecX().dotProduct(ptCenterCon-ptCenter))>dDistToCenter+U(5))//Si la coneccion es mas lejos que el borde del elemento osea Macho
		{
			//Male
			double dAngle=abs(vxC.dotProduct(vx));
			if (dAngle>0.01 && dAngle<0.98) //Angle Conection
			{
				if (ptInContact.length()==1)
				{
					Line lnZ (ptCenter, vz);
					Line lnZC(ptCenterConWall, vzC);
					Point3d ptIntersection=lnZ.closestPointTo(lnZC);
					Vector3d vecAngle=vz+vzC;
					vecAngle.normalize();
					Vector3d vecDirCon=(ptCenterCon-ptCenter);
					Vector3d vecCut=vecAngle.crossProduct(vy);
					
					if (vecCut.dotProduct(vecDirCon)<0)
					{
						vecCut=-vecCut;
					}
					Cut ctAngle(ptInContact[0], vecCut);
					for (int k=0; k<bmAllSolePlates.length(); k++)
					{
						Body bdAux(ptInContact[0], vx, vy, vz, U(30), U(400), U(30), 0, 0, 0);
						if (!(bdAux.hasIntersection(bmAllSolePlates[k].realBody())))
							continue;
						bmAllSolePlates[k].addToolStatic(ctAngle, 1);
						
						if (nPrecutLevel==nSolePlateLevel[k] && bShowNailPlate)
						{
							Plane plnCut(ptInContact[0], vecCut);
							Line lnBmAngle(bmAllSolePlates[k].ptCen(), bmAllSolePlates[k].vecX());
							Point3d ptMetalPart=lnBmAngle.intersect(plnCut, 0);
							
							lstPoints.setLength(0);
							lstBeams.setLength(0);
							lstBeams.append(bmAllSolePlates[k]);
							lstPoints.append(ptMetalPart+bmAllSolePlates[k].vecY()*bmAllSolePlates[k].dD(bmAllSolePlates[k].vecY())*0.5);
							Map mp;
							mp.setVector3d("vx", vecCut);
							mp.setVector3d("vy", vecCut.crossProduct(bmAllSolePlates[k].vecY()));
							mp.setVector3d("vz", bmAllSolePlates[k].vecY());
							mp.setString("Group", "Soleplate");
							tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
						}
					}
					continue;
				}
			}
			else
			{
				if (ptInContact.length()==1)
					continue;
			}
			
			if (bTOverlap || arSCodeExternalWalls.find(elC.code(),-1) == -1 || arSCodeExternalWalls.find(el.code(),-1)!=-1)
			{
				Vector3d vecCutDir (ptFar-ptCenterCon);
				Vector3d vecCut=vzC;
				if (vecCutDir.dotProduct(vecCut)<0)
					vecCut=-vecCut;
				
				Cut ctFar(ptFar, vecCut);
				Cut ctClose(ptClose, vecCut);
				for (int k=0; k<bmAllSolePlates.length(); k++)
				{
					Body bdAux(ptClose, vx, vy, vz, U(30), U(400), U(30), 0, 0, 0);
					if (!(bdAux.hasIntersection(bmAllSolePlates[k].envelopeBody(FALSE,TRUE))))
						continue;
					if (nSolePlateLevel[k]==1 || nSolePlateLevel[k]==3)
					{
						bmAllSolePlates[k].addToolStatic(ctFar, 1);
					}
					else
					{
						bmAllSolePlates[k].addToolStatic(ctClose, 1);
						if (nPrecutLevel==nSolePlateLevel[k] && bShowNailPlate)
						{
							Plane pln(ptClose, vecCut);
							Line lnBm (bmAllSolePlates[k].ptCen(), bmAllSolePlates[k].vecX());
							Point3d ptMP=lnBm.intersect(pln, 0);
							ptMP.transformBy(vy*(bmAllSolePlates[k].dD(vy)*0.5));
							
							lstPoints.setLength(0);
							lstBeams.setLength(0);
							lstBeams.append(bmAllSolePlates[k]);
							lstPoints.append(ptMP);
							Map mp;
							mp.setVector3d("vx", vx);
							mp.setVector3d("vy", vz);
							mp.setVector3d("vz", vy);
							mp.setString("Group", "Soleplate");
							tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
						}
					}
				}
			}
		}		
		else
		{
			//Female
			double dA3=abs(el.vecX().dotProduct(ptCenter-ptCenterCon));
			if (abs(el.vecX().dotProduct(ptCenter-ptCenterCon))<dDistToCenter-U(dWSolePlate)) //Disminuir el margen con el borde si es necesario
			{
				//Si es una hembra que tiene un macho que no está cerca de los bordes
				//int asd=arSCodeExternalWalls.find(elC.code(),-1);
				if (bTOverlap || (arSCodeExternalWalls.find(elC.code(),-1) == -1 && arSCodeExternalWalls.find(el.code(),-1) == -1))
				{
					Beam bmNew[0];
					int nLevelNew[0];
					for (int k=0; k<bmAllSolePlates.length(); k++)
					{
						if (nSolePlateLevel[k]==1 || nSolePlateLevel[k]==3)
						{
							Body bdAux(ptCenterCon, vx, vy, vz, U(2), U(400), U(2), 0, 0, 0);
							if (bdAux.hasIntersection(bmAllSolePlates[k].realBody()))
							{
								
								Beam bmRes=bmAllSolePlates[k].dbSplit(ptCenterCon, ptCenterCon);
								bdAux=Body (ptIntersect[0], vx, vy, vz, U(2), U(400), U(2), 0, 0, 0);
	bdAux.vis(4);
								Vector3d vecCutDir (ptCenterCon-ptIntersect[0]);
								Vector3d vecCut=vzC;
								if (vecCutDir.dotProduct(vecCut)<0)
									vecCut=-vecCut;
									
//								ptIntersect[0].vis(3);
//								vecCut.vis(ptIntersect[0]);
//								ptIntersect[1].vis(3);
								vecCut.vis(ptIntersect[1]);
								
								Cut ct1(ptIntersect[0], vecCut);
								Cut ct2(ptIntersect[1], -vecCut);
								bmRes.envelopeBody().vis(5);
								bmAllSolePlates[k].envelopeBody().vis(7);
								if (bdAux.hasIntersection(bmRes.realBody()))
								{
									{ 
										Point3d ptStart0 = bmRes.realBody().shadowProfile(Plane(bmRes.ptCen(), bmRes.vecY())).
												extentInDir(bmRes.vecX()).ptStart();
										Point3d ptEnd0 = bmRes.realBody().shadowProfile(Plane(bmRes.ptCen(), bmRes.vecY())).
												extentInDir(bmRes.vecX()).ptEnd();
										// HSB-11750 check if cut is correct and that beam doesnot explode
										if((ptStart0-ptIntersect[0]).dotProduct(bmRes.vecX())*
										(ptEnd0-ptIntersect[0]).dotProduct(bmRes.vecX())>-dEps)
										{ 
											// point of cut outside beam
											if(vecCut.dotProduct(ptStart0-ptIntersect[0])>0)
											{ 
												// cut not possible, delete beam
												bmRes.dbErase();
											}
											else
											{ 
												bmRes.addToolStatic(ct1, 1);
											}
										}
										else
										{
											bmRes.addToolStatic(ct1, 1);
										}
									}
									{ 
										Point3d ptStart0 = bmAllSolePlates[k].realBody().shadowProfile(Plane(bmAllSolePlates[k].ptCen(), bmAllSolePlates[k].vecY())).
												extentInDir(bmAllSolePlates[k].vecX()).ptStart();
										Point3d ptEnd0 = bmAllSolePlates[k].realBody().shadowProfile(Plane(bmAllSolePlates[k].ptCen(), bmAllSolePlates[k].vecY())).
												extentInDir(bmAllSolePlates[k].vecX()).ptEnd();
										
//										ptStart0.vis(1);
//										ptEnd0.vis(2);
//										ptIntersect[1].vis(4);
										// HSB-11750 check if cut is correct and that beam doesnot explode
										if((ptStart0-ptIntersect[1]).dotProduct(bmAllSolePlates[k].vecX())*
										(ptEnd0-ptIntersect[1]).dotProduct(bmAllSolePlates[k].vecX())>-dEps)
										{ 
											// point of cut outside beam
											if((-vecCut).dotProduct(ptStart0-ptIntersect[1])>0)
											{ 
												// cut not possible, delete beam
												bmAllSolePlates[k].dbErase();
											}
											else
											{ 
												bmAllSolePlates[k].addToolStatic(ct2, 1);
											}
										}
										else
										{
											bmAllSolePlates[k].addToolStatic(ct2, 1);
										}
									}
								}
								else
								{
									{ 
										Point3d ptStart0 = bmRes.realBody().shadowProfile(Plane(bmRes.ptCen(), bmRes.vecY())).
												extentInDir(bmRes.vecX()).ptStart();
										Point3d ptEnd0 = bmRes.realBody().shadowProfile(Plane(bmRes.ptCen(), bmRes.vecY())).
												extentInDir(bmRes.vecX()).ptEnd();
										// HSB-11750 check if cut is correct and that beam doesnot explode
										if((ptStart0-ptIntersect[1]).dotProduct(bmRes.vecX())*
										(ptEnd0-ptIntersect[1]).dotProduct(bmRes.vecX())>-dEps)
										{ 
											// point of cut outside beam
											if((-vecCut).dotProduct(ptStart0-ptIntersect[1])>0)
											{ 
												// cut not possible, delete beam
												bmRes.dbErase();
											}
											else
											{ 
												bmRes.addToolStatic(ct2, 1);
											}
										}
										else
										{
											bmRes.addToolStatic(ct2, 1);
										}
									}
									{ 
										Point3d ptStart0 = bmAllSolePlates[k].realBody().shadowProfile(Plane(bmAllSolePlates[k].ptCen(), bmAllSolePlates[k].vecY())).
												extentInDir(bmAllSolePlates[k].vecX()).ptStart();
										Point3d ptEnd0 = bmAllSolePlates[k].realBody().shadowProfile(Plane(bmAllSolePlates[k].ptCen(), bmAllSolePlates[k].vecY())).
												extentInDir(bmAllSolePlates[k].vecX()).ptEnd();
										// HSB-11750 check if cut is correct and that beam doesnot explode
										if((ptStart0-ptIntersect[0]).dotProduct(bmAllSolePlates[k].vecX())*
										(ptEnd0-ptIntersect[0]).dotProduct(bmAllSolePlates[k].vecX())>-dEps)
										{ 
											// point of cut outside beam
											if((vecCut).dotProduct(ptStart0-ptIntersect[0])>0)
											{ 
												// cut not possible, delete beam
												bmAllSolePlates[k].dbErase();
											}
											else
											{ 
												bmAllSolePlates[k].addToolStatic(ct1, 1);
											}
										}
										else
										{
											bmAllSolePlates[k].addToolStatic(ct1, 1);
										}
									}
//									bmRes.addToolStatic(ct2, 1);
//									bmAllSolePlates[k].addToolStatic(ct1, 1);
								}
								bmNew.append(bmRes);
								nLevelNew.append(nSolePlateLevel[k]);
								if (nPrecutLevel==nSolePlateLevel[k] && bShowNailPlate)
								{
									Plane pln(ptIntersect[0], vecCut);
									Line lnBm (bmAllSolePlates[k].ptCen(), bmAllSolePlates[k].vecX());
									Point3d ptMP1=lnBm.intersect(pln, 0);
									ptMP1.transformBy(vy*(bmAllSolePlates[k].dD(vy)*0.5));
								
									lstPoints.setLength(0);
									lstBeams.setLength(0);
									lstBeams.append(bmAllSolePlates[k]);
									lstPoints.append(ptMP1);
									Map mp;
									mp.setVector3d("vx", vx);
									mp.setVector3d("vy", vz);
									mp.setVector3d("vz", vy);
									mp.setString("Group", "Soleplate");
									tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
		
									Plane pln2(ptIntersect[1], vecCut);
									Line lnBm2 (bmRes.ptCen(), bmRes.vecX());
									Point3d ptMP2=lnBm2.intersect(pln2, 0);
									ptMP2.transformBy(vy*(bmRes.dD(vy)*0.5));
		
									lstPoints.setLength(0);
									lstBeams.setLength(0);
									lstBeams.append(bmRes);
									lstPoints.append(ptMP2);
									tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
								}
								
							}
						}
					}
					for (int n=0; n<bmNew.length(); n++)
					{
						bmAllSolePlates.append(bmNew[n]);
						nSolePlateLevel.append(nLevelNew[n]);
						int nLevel=nLevelNew[n];
						String strLevelName=sGrpNm2+"_Level "+nLevel;
						if (nPrecutLevel==nLevel && bPrecut)
						{
							strLevelName=strLevelName+"_Precut";
						}
						grpSolePlate.setNamePart(1, strLevelName);
						
						grpSolePlate.addEntity(bmNew[n], false);
						
						bmAll.append(bmNew[n]);
						nLevelAll.append(nLevelNew[n]);
					}
				}
			}
			else
			{
				if (bTOverlap || arSCodeExternalWalls.find(elC.code(),-1) != -1 || arSCodeExternalWalls.find(el.code(),-1) == -1)
				{

					//Female
					Vector3d vecCutDir (ptFar-ptCenterCon);
					Vector3d vecCut=vzC;
					if (vecCutDir.dotProduct(vecCut)<0)
						vecCut=-vecCut;
					
					Cut ctFar(ptFar, vecCut);
					Cut ctClose(ptClose, vecCut);
					for (int k=0; k<bmAllSolePlates.length(); k++)
					{
						Body bdAux(ptCenterCon, vx, vy, vz, U(20), U(400), U(20), 0, 0, 0);
						if (!(bdAux.hasIntersection(bmAllSolePlates[k].realBody())))
							continue;
						if (nSolePlateLevel[k]==2 || nSolePlateLevel[k]==4)
						{
							bmAllSolePlates[k].addToolStatic(ctFar, 1);
							
						}
						else
						{
							bmAllSolePlates[k].addToolStatic(ctClose, 1);
							
							Plane pln(ptClose, vecCut);
							Line lnBm (bmAllSolePlates[k].ptCen(), bmAllSolePlates[k].vecX());
							Point3d ptMP=lnBm.intersect(pln, 0);
							ptMP.transformBy(vy*(bmAllSolePlates[k].dD(vy)*0.5));
							if (nPrecutLevel==nSolePlateLevel[k] && bShowNailPlate)
							{
								lstPoints.setLength(0);
								lstBeams.setLength(0);
								lstBeams.append(bmAllSolePlates[k]);
								lstPoints.append(ptMP);
								Map mp;
								mp.setVector3d("vx", vx);
								mp.setVector3d("vy", vz);
								mp.setVector3d("vz", vy);
								mp.setString("Group", "Soleplate");
								tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
							}

						}
					}
				}
			}
		}
	}
}


for (int i=0; i<bmAll.length(); i++)
{
	if (!bmAll[i].bIsValid() ||bmAll[i].dL()<U(3))
	{
		bmAll.removeAt(i);
		nLevelAll.removeAt(i);
		i--;
		continue;
	}
	Body bdBmi (bmAll[i].quader());
	Body bd1=bdBmi;
	Body bd2=bdBmi;
	bd1.transformBy(bmAll[i].vecX()*U(10));
	bd2.transformBy(-bmAll[i].vecX()*U(10));
	bdBmi.addPart(bd1);
	bdBmi.addPart(bd2);
	bdBmi.vis(1);
	for (int j=i+1; j<bmAll.length(); j++)
	{
		if (!bmAll[j].bIsValid())
		{
			bmAll.removeAt(j);
			nLevelAll.removeAt(j);
			j--;
			continue;
		}
		
		
		Body bdBmj (bmAll[j].quader());
		Body bd1=bdBmj;
		Body bd2=bdBmj;
		bd1.transformBy(bmAll[j].vecX()*U(10));
		bd2.transformBy(-bmAll[j].vecX()*U(10));
		bdBmj.addPart(bd1);
		bdBmj.addPart(bd2);
		
		bdBmj.vis(j+1);
		if (abs(bmAll[i].vecX().dotProduct(bmAll[j].vecX()))>0.99)
		{
			if (abs(_ZW.dotProduct(bmAll[i].ptCen()-bmAll[j].ptCen()))<U(2))
			{
				if (bdBmi.hasIntersection(bdBmj))
				{
					if (bmAll[i].dH()==bmAll[j].dH())
					{
						double dLengthBeforeJoin = bmAll[i].dL();
						bmAll[i].dbJoin(bmAll[j]);
						double dLengthAfterJoin = bmAll[i].dL();
				
						if(dLengthAfterJoin > dLengthBeforeJoin)
						{
							i--;
							break;
						}
					}
					else
					{
						if (nPrecutLevel==nLevelAll[i] && bShowNailPlate)
						{
							bdBmi.intersectWith(bdBmj);
							Point3d ptMetalPart=bdBmi.ptCen();
							lstPoints.setLength(0);
							lstBeams.setLength(0);
							lstBeams.append(bmAll[i]);
							lstPoints.append(ptMetalPart+bmAll[i].vecY()*bmAll[i].dD(bmAll[i].vecY())*0.5);
							Map mp;
							mp.setVector3d("vx", bmAll[i].vecX());
							mp.setVector3d("vy", bmAll[i].vecZ());
							mp.setVector3d("vz", bmAll[i].vecY());
							mp.setString("Group", "Soleplate");
							tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
						}
					}
				}
			}
		}
	}
	
	int yy=bmAll.length();
}

// HSB-10182 guard agains 0 
if (dMinLength < 0)dMinLength.set(U(0));
if (dMaxLength < dMinLength)dMaxLength.set(dMinLength);
if (dMaxLength <= 0)dMaxLength.set(U(0.1));
Beam bmAllSplits[0];
int nLevelAllSplits[0];
for (int i=0; i<bmAll.length(); i++)
{
	Beam bmToSplit=bmAll[i];
	Beam bmResult=bmToSplit;
	if (!bmAll[i].bIsValid())
	{
		bmAll.removeAt(i);
		nLevelAll.removeAt(i);
		i--;
		continue;
	}
	double dBLen=bmToSplit.solidLength();
	if (dBLen<=dMaxLength)
	{
		continue;
	}
	Body bdBm=bmToSplit.realBody();
	Point3d ptExt[]=bdBm.extremeVertices(bmToSplit.vecX());
	double nBeamHLen=dBLen;
	int numberOfSplits=nBeamHLen / dMaxLength;
	Line ln (bmToSplit.ptCen(), bmToSplit.vecX());
		
	if (dBLen>dMaxLength)
	{
		Point3d ptExt[]=bdBm.extremeVertices(bmToSplit.vecX());
		bmToSplit.ptCen().vis(2);
		bmToSplit.vecX().vis(bmToSplit.ptCen(),2);
		double nBeamHLen=dBLen;
		int numberOfSplits=nBeamHLen / dMaxLength;
		Line ln (bmToSplit.ptCen(), bmToSplit.vecX());
		Beam BRes=bmToSplit;
		Beam BRes1;
		for (int j=1; j<=numberOfSplits; j++)
		{
			double dBresLength = BRes.solidLength();
			if (dBresLength-dMaxLength>U(1,"mm"))
			{
				if (dBresLength-dMaxLength>dMinLength)
				{
					Point3d ptCut = ptExt[0]+bmToSplit.vecX()*(dMaxLength*j);
					ptCut = ln.closestPointTo(ptCut);
					BRes1=BRes.dbSplit(ptCut,ptCut);
					BRes=BRes1;
					bmAllSplits.append(BRes);
					nLevelAllSplits.append(nLevelAll[i]);
					if (nPrecutLevel==nLevelAll[i] && bShowNailPlate)
					{
						lstPoints.setLength(0);
						lstBeams.setLength(0);
						lstBeams.append(BRes1);
						lstPoints.append(ptCut+bmAll[i].vecY()*bmAll[i].dD(bmAll[i].vecY())*0.5);
						Map mp;
						mp.setVector3d("vx", bmAll[i].vecX());
						mp.setVector3d("vy", bmAll[i].vecZ());
						mp.setVector3d("vz", bmAll[i].vecY());
						mp.setString("Group", "Soleplate");
						tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
					}				
					if (bmResult.bIsValid())
					{
						int nLevel=nLevelAll[i];
						String strLevelName=sGrpNm2+"_Level "+nLevel;
						if (nPrecutLevel==nLevel && bPrecut)
						{
							strLevelName=strLevelName+"_Precut";
						}

						
						grpSolePlate.setNamePart(1, strLevelName);
				
						grpSolePlate.addEntity(bmResult, false);
					}
				}
				else
				{
					Point3d ptCut = ptExt[0]+bmToSplit.vecX()*(dMaxLength*(j-1)+(dBresLength-dMinLength));
					ptCut = ln.closestPointTo(ptCut);
					BRes1=BRes.dbSplit(ptCut,ptCut);
					BRes=BRes1;
					bmAllSplits.append(BRes);
					nLevelAllSplits.append(nLevelAll[i]);
					
					if (nPrecutLevel==nLevelAll[i] && bShowNailPlate)
					{
						lstPoints.setLength(0);
						lstBeams.setLength(0);
						lstBeams.append(BRes1);
						lstPoints.append(ptCut+bmAll[i].vecY()*bmAll[i].dD(bmAll[i].vecY())*0.5);
						Map mp;
						mp.setVector3d("vx", bmAll[i].vecX());
						mp.setVector3d("vy", bmAll[i].vecZ());
						mp.setVector3d("vz", bmAll[i].vecY());
						mp.setString("Group", "Soleplate");
						tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
					}				
					if (bmResult.bIsValid())
					{
						int nLevel=nLevelAll[i];
						String strLevelName=sGrpNm2+"_Level "+nLevel;
						if (nPrecutLevel==nLevel  && bPrecut)
						{
							strLevelName=strLevelName+"_Precut";
						}

						grpSolePlate.setNamePart(1, strLevelName);
				
						grpSolePlate.addEntity(bmResult, false);
					}
				}
			}
		}
	}
}

//Calculate the Qty of Anchors


bmAll.append(bmAllSplits);
nLevelAll.append(nLevelAllSplits);

double dBaseLengthExt89=0;
double dBaseLengthExt140=0;
double dBaseLengthParty=0;
double dBaseLengthInternal=0;


double dLenghtExternal89=0;
double dLenghtExternal140=0;
double dLengthInternal=0;
double dLengthParty=0;

double dArrHeight[0];
double dArrWidth[0];
double dArrLength[0];

Beam bmBottom;
for (int i=0; i<bmAll.length(); i++)
{
	double dLe=bmAll[i].solidLength();
	//dTotalLength=dTotalLength+dLe;
	Vector3d vAux=bmAll[i].vecX().crossProduct(_ZW);
	if (nLevelAll[i]==nPrecutLevel)
		bmBottom=bmAll[i];
	if (bmAll[i].label()=="Ext")
	{
		if (bmAll[i].dD(vAux)>U(100))
		{
			dLenghtExternal140=dLenghtExternal140+dLe;
			if (nLevelAll[i]==nPrecutLevel)
				dBaseLengthExt140+=dLe;
		}
		else
		{
			dLenghtExternal89=dLenghtExternal89+dLe;
			if (nLevelAll[i]==nPrecutLevel)
				dBaseLengthExt89+=dLe;
		}
	}else if (bmAll[i].label()=="Int Party")
	{
		dLengthParty=dLengthParty+dLe;
		if (nLevelAll[i]==nPrecutLevel)
			dBaseLengthParty+=dLe;
	} else if (bmAll[i].label()=="Int")
	{
		dLengthInternal=dLengthInternal+dLe;
		if (nLevelAll[i]==nPrecutLevel)
			dBaseLengthInternal+=dLe;
	}

	double dBmH=bmAll[i].dD(vAux);
	double dBmW=bmAll[i].dD(_ZW);
	
	int nIsNew=TRUE;
	for (int k=0; k<dArrHeight.length(); k++)
	{
		if (abs(dArrHeight[k]-dBmH)<0.1 && abs(dArrWidth[k]-dBmW)<0.1)
		{
			
			dArrLength[k]+=dLe;
			nIsNew=FALSE;
			//reportNotice("\n"+"Increase Length for: "+dArrHeight[k]+" "+dArrWidth[k]+"IN: "+dLe+ " - New Length: "+dArrLength[k]);
			break;
		}
	}
	if (nIsNew)
	{
		dArrHeight.append(dBmH);
		dArrWidth.append(dBmW);
		dArrLength.append(dLe);
		//reportNotice("\n"+"dArrHeight: "+dBmH);
		//reportNotice("\n"+"dArrWidth: "+dBmW);
		//reportNotice("\n"+"dArrLength To Start: "+dLe);
	}
}

//reportNotice("\n"+"Length 140: "+dLenghtExternal140);
//reportNotice("\n"+"Length 89: "+dLenghtExternal89);
//reportNotice("\n"+"Length Party: "+dLengthParty);
//reportNotice("\n"+"Length Internal: "+dLengthInternal);

double dTotalLength=0;
double dLenghtExternal=0;
dLenghtExternal=dBaseLengthExt140+dBaseLengthExt89;
dTotalLength=dBaseLengthExt140+dBaseLengthExt89+dBaseLengthParty+dBaseLengthInternal;

//Prepare the Array for the Material Table
String sDescription[0];
String sWidth[0];
String sHeight[0];
int nQty[0];
String sUnit[0];

for (int k=0; k<dArrHeight.length(); k++)
{
	sDescription.append("CLS SOLEPLATE TREATED");
	//String sDimensiondescription=dArrWidth[k] + " x " + dArrHeight[k] + " x MTR";
	sWidth.append(dArrWidth[k]);
	sHeight.append(dArrHeight[k]);
	int nQuantity=(dArrLength[k]/1000)+1;
	nQty.append(nQuantity);
	sUnit.append("LM");
}
/*
if (dLenghtExternal140>0)
{
	sDescription.append("CLS SOLEPLATE TREATED");
	sWidth.append("38 x 140 x MTR");
	int nQuantity=(dLenghtExternal140/1000)+1;
	nQty.append(nQuantity);
}
if (dTotalLength-dLenghtExternal140>0)
{
	sDescription.append("CLS SOLEPLATE TREATED");
	sWidth.append("38 x 89 x MTR");
	int nQuantity=((dTotalLength-dLenghtExternal140)/1000)+1;
	nQty.append(nQuantity);
}
*/

if (bDPC)
{
	if (dBaseLengthExt140>0)
	{
		sDescription.append("DPC 225mm Roll");
		sWidth.append(" ");
		sHeight.append(" ");
		int nQuantity=dBaseLengthExt140;
		nQuantity=nQuantity+(nQuantity*dExtraPercent)/100;
		nQuantity=nQuantity/1000;
		nQty.append(nQuantity);
		sUnit.append("LM");
	}
	if (dBaseLengthExt89>0)
	{
		sDescription.append("DPC 150mm Roll");
		sWidth.append(" ");
		sHeight.append(" ");
		int nQuantity=dBaseLengthExt89;
		nQuantity=nQuantity+(nQuantity*dExtraPercent)/100;
		nQuantity=nQuantity/1000;
		nQty.append(nQuantity);
		sUnit.append("LM");
	}
	if ((dBaseLengthInternal+dBaseLengthParty)>0)
	{
		sDescription.append("DPC 100mm Roll");
		sWidth.append(" ");
		sHeight.append(" ");
		int nQuantity=(dBaseLengthInternal+dBaseLengthParty);
		nQuantity=nQuantity+(nQuantity*dExtraPercent)/100;
		nQuantity=nQuantity/1000;
		nQty.append(nQuantity);
		sUnit.append("LM");
	}
}

if (bPackers)
{
	if (dBaseLengthExt140>0)
	{
		sDescription.append("Plastic Soleplate Packers 140mm");
		sWidth.append(" ");
		sHeight.append(" ");
		int nQuantity=(dBaseLengthExt140/dPackersCenters)*nPackersQTY;
		nQuantity=nQuantity+(nQuantity*dExtraPercent)/100;
		nQty.append(nQuantity);
		sUnit.append("No");
	}
	if (dBaseLengthExt89+dBaseLengthParty+dBaseLengthInternal>0)
	{
		sDescription.append("Plastic Soleplate Packers 90mm");
		sWidth.append(" ");
		sHeight.append(" ");
		int nQuantity=((dBaseLengthExt89+dBaseLengthParty+dBaseLengthInternal)/dPackersCenters)*nPackersQTY;
		nQuantity=nQuantity+(nQuantity*dExtraPercent)/100;
		nQty.append(nQuantity);
		sUnit.append("No");
	}
}


if (bScrews)
{
	if (dTotalLength>0)
	{
		sDescription.append(sScrewMaterial);
		//sWidth.append("HPS 8/60");
		sWidth.append(" ");
		sHeight.append(" ");
		int nQuantity=(dTotalLength)/dScrewsCenters;
		nQuantity=nQuantity+(nQuantity*dExtraPercent)/100;
		double dAux=nQuantity/nScrewsBox;
		nQuantity=nQuantity/nScrewsBox;
		if (nQuantity<dAux)
			nQuantity++;
		nQty.append(nQuantity);
		sUnit.append("Box");
	}
}

if (bNails)
{
	if (dTotalLength>0)
	{
		if (strNailTypes.find(sNailMaterial, 0)==0)
		{
			sDescription.append(strCustomNailMaterial);
		}
		else
		{
			sDescription.append(sNailMaterial);
		}
		
		//sWidth.append("90mm (each)");
		sWidth.append(" ");
		sHeight.append(" ");
		int nQuantity=(dTotalLength*(nNumberofLevels-1))/dNailsCenters;
		nQuantity=nQuantity+(nQuantity*dExtraPercent)/100;
		double dAux=nQuantity/nNailsBox;
		nQuantity=nQuantity/nNailsBox;
		if (nQuantity<dAux)
			nQuantity++;
		nQty.append(nQuantity);
		sUnit.append("Box");
	}
}

int dQtyOnLength=0;
if (dAnchorCenters>0)
	dQtyOnLength=dTotalLength/dAnchorCenters;

int nTotalQty=nDoorQty+dQtyOnLength;

if (bShowAnchors)
{
	//Clonning TSL 
	TslInst tsl;
	String sScriptName = "hsb_Anchor"; // name of the script of the Metal Part
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Entity lstEnts[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	lstPropDouble.setLength(0);
	lstPropInt.setLength(0);
	lstPropString.setLength(0);
	
	lstPropDouble.append(dTh);
	lstPropDouble.append(dWi);
	lstPropDouble.append(dLe);
	lstPropInt.append(nTotalQty);
	lstPropString.append(sDispRep);
	lstPropString.append(sNameAnchor);
	lstPropString.append(strCustomAnchorModel);
	
	lstPoints.setLength(0);
	lstBeams.setLength(0);
	lstBeams.append(bmBottom);
	lstPoints.append(bmBottom.ptCen()-bmBottom.vecY()*bmBottom.dD(bmBottom.vecY())*0.5-bmBottom.vecZ()*bmBottom.dD(bmBottom.vecZ())*0.5);
	Map mp;
	mp.setVector3d("vx", bmBottom.vecX());
	mp.setVector3d("vy", bmBottom.vecZ());
	mp.setVector3d("vz", bmBottom.vecY());
	mp.setString("Group", "Soleplate");
	tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
}

int nQtyRestraint=0;
if (dRestraintCenters>0 && bShowRestraint>0)
{
	if (bShowRestraint==1) //External
	{
		nQtyRestraint=dLenghtExternal/dRestraintCenters;
	}
	else if (bShowRestraint==2) //All
	{
		nQtyRestraint=dTotalLength/dRestraintCenters;
	}
	nQtyRestraint=nQtyRestraint+nDoorQty;
}



if (bShowRestraint>0 && nQtyRestraint>0)
{
	//Clonning TSL 
	TslInst tsl;
	String sScriptName = "hsb_Restraint"; // name of the script of the Metal Part
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Entity lstEnts[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	lstPropDouble.setLength(0);
	lstPropInt.setLength(0);
	lstPropString.setLength(0);
	lstPropDouble.append(dTh);
	lstPropDouble.append(dWi);
	lstPropDouble.append(dLe);
	lstPropInt.append(nQtyRestraint);
	lstPropString.append(sDispRep);
	lstPropString.append(sNameRestraint);
	lstPropString.append(strCustomRestraintModel);
	
	lstPoints.setLength(0);
	lstBeams.setLength(0);
	lstBeams.append(bmBottom);
	lstPoints.append(bmBottom.ptCen()+bmBottom.vecY()*bmBottom.dD(bmBottom.vecY())*0.5+bmBottom.vecZ()*bmBottom.dD(bmBottom.vecZ())*0.5);
	Map mp;
	mp.setVector3d("vx", bmBottom.vecX());
	mp.setVector3d("vy", bmBottom.vecZ());
	mp.setVector3d("vz", bmBottom.vecY());
	mp.setString("Group", "Soleplate");
	tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
}


//Set the values for the material Table
if (bShowBOM)
{
	TslInst tsl;
	String sScriptName = "hsb_SolePlate Material Table"; // name of the script of the Metal Part
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Entity lstEnts[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	lstPropDouble.setLength(0);
	lstPropInt.setLength(0);
	lstPropString.setLength(0);
	
	lstPropInt.append(nLineColor);
	lstPropInt.append(nColor);
	
	lstPropString.append(sDimStyle);
	lstPropString.append(sGrpNm1);
	lstPropString.append(sGrpNm2);
	lstPropString.append(sDispRep);
	lstPropString.append("SOLEPLATE BOM");
	
	lstPoints.setLength(0);
	lstBeams.setLength(0);
	lstPoints.append(_Pt0);
	
	Map mpTable;
	
	for (int i=0; i<sDescription.length(); i++)
	{
		Map mpRow;
		mpRow.setString("sDescription", sDescription[i]);
		mpRow.setString("sWidth", sWidth[i]);
		mpRow.setString("sHeight", sHeight[i]);
		mpRow.setInt("nQty", nQty[i]);
		mpRow.setString("sUnit", sUnit[i]);
		mpTable.appendMap("mpRow", mpRow);
	}
	
	Map mpToExport;
	mpToExport.setMap("mpTable", mpTable);
	mpToExport.setString("Group", "Soleplate");
	tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToExport);
}
// HSB-11750: call tsl that splits beams at doors
if(iSplitAtDoor)
{ 
	Beam bmSolesAll[0];
	bmSolesAll.append(bmAll);
// create TSL
	TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
	GenBeam gbsTsl[] = {}; Entity entsTsl[1]; Point3d ptsTsl[] = {_Pt0};
	int nProps[]={}; double dProps[]={}; String sProps[]={};
	Map mapTsl;	
	
	for( int e=0; e<_Element.length(); e++ )
	{
		ElementWall el = (ElementWall) _Element[e];
		Beam bmSoles[0];
		for (int iB=bmSolesAll.length()-1; iB>=0 ; iB--) 
		{ 
			String sInfoI = bmSolesAll[iB].information();
			String sToks[] = sInfoI.tokenize(";");
//			if(bmSolesAll[iB].element()==el)
			if(sToks[sToks.length()-1]==el.number())
			{ 
				bmSoles.append(bmSolesAll[iB]);
				bmSolesAll.removeAt(iB);
			}
		}//next iB
		
		if (el.bIsValid())
		{
			entsTsl[0] = el;
			gbsTsl.setLength(0);
			for (int iB=0;iB<bmSoles.length();iB++) 
			{ 
				// HSB-15012: 
				bmSoles[iB].setInformation(sInformation);
				gbsTsl.append(bmSoles[iB]);
			}//next iB
			if(gbsTsl.length()>0)
			{
				// HSB-15012
				tslNew.dbCreate("hsb_SolePlateSplitAtDoors" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
		}
	}
}

eraseInstance();






#End
#BeginThumbnail
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
;`"BBB@`HHHH`****`"BBB@`HHHH`****`/_9
`

































#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="915" />
        <int nm="BREAKPOINT" vl="917" />
        <int nm="BREAKPOINT" vl="915" />
        <int nm="BREAKPOINT" vl="917" />
        <int nm="BREAKPOINT" vl="760" />
        <int nm="BREAKPOINT" vl="766" />
        <int nm="BREAKPOINT" vl="845" />
        <int nm="BREAKPOINT" vl="984" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15012: fix when doing splitting at doors (make sure soleplates are provided for given wall)" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="31" />
      <str nm="DATE" vl="4/11/2022 1:49:39 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15012: fix when doing splitting at doors" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="30" />
      <str nm="DATE" vl="4/5/2022 1:58:37 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15012: dont assign soleplates at elements" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="29" />
      <str nm="DATE" vl="4/5/2022 11:47:02 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13641: add property offset" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="28" />
      <str nm="DATE" vl="12/16/2021 10:56:26 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11750: split beams at doors by using extra TSL to enable parallelisation; fix bug when applying Cuts at soleplates" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="27" />
      <str nm="DATE" vl="5/11/2021 5:31:09 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11750: add property split soleplate at door No/Yes" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="26" />
      <str nm="DATE" vl="5/10/2021 1:22:15 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-10182: guard against negative or 0 input at max. Length and Min. Length" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="25" />
      <str nm="DATE" vl="1/20/2021 1:29:10 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-10182: Add dropdown property Locator position { inside face, outside face}" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="24" />
      <str nm="DATE" vl="1/20/2021 11:49:21 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End