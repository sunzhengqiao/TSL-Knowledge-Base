#Version 8
#BeginDescription
#Versions:
Version 2.35 27.11.2025 20251127: Consider the case when vertical batten need to be splitted , Author: Marsel Nakuci
Version 2.34 27.11.2025 20251127: Implement onDbErase , Author: Marsel Nakuci
Version 2.33 27.11.2025 20251127: At the zone before battens create beams with width of zone 0 , Author: Marsel Nakuci
Version 2.32 06/11/2025 HSB-24636: Add property to cut top or/and bottom service batten , Author Marsel Nakuci
Version 2.31 06/11/2025 HSB-22709: At the batten zone use 4 beams to create the vent for round and rectangular , Author Marsel Nakuci
Version 2.30 10.10.2025 HSB-22709: Add option "As beams solid for rounding vent" , Author: Marsel Nakuci
Version 2.29 01.07.2025 HSB-22709: Add option "As beams" at property Batten , Author: Marsel Nakuci
Version 2.28 27/06/2025 HSB-19318: Capture error when jacks not possible , Author Marsel Nakuci
Version 2.27 26.06.2025 HSB-19318: Add properties for bracing and jacks , Author: Marsel Nakuci
2.26 18/07/2024 Add locating plate as beamtype to avoid Author: Robert Pol
Version 2.25 14.02.2023 HSB-17870 Element validation added
2.24 25.01.2022 HSB-14016: Support insertion of multiple instances when multiple walls are selected
2.23 25.11.2021 HSB-11217: created battens should not exceed boundaries of existing battens
2.22 23.04.2021 HSB-11217: Dont consider beams in sheet zones
2.21 22.03.2021 HSB-10859: when vent on top of an existing stud that is not at joining of 2 sheets then delete the stud. Add property No/Yes to controll this behaviour
2.20 19.03.2021 HSB-11217: add none at the list of batten zones
2.19 22.02.2021 HSB-10280: consider options stretch left,right, both for the battens, set property Fixed vent when colliding with existing stud
2.18 22.02.2021 HSB-10280: add properties for creating battens around vent

add/remove format revised, text drawn in model and dxa display
version value="2.17" date=09oct2020"
add categories and a property to freeze the vent so the beams can be modified manually

















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 35
#KeyWords vent,batten
#BeginContents
/// <History>//region
// #Versions
// 2.35 27.11.2025 20251127: Consider the case when vertical batten need to be splitted , Author: Marsel Nakuci
// 2.34 27.11.2025 20251127: Implement onDbErase , Author: Marsel Nakuci
// 2.33 27.11.2025 20251127: At the zone before battens create beams with width of zone 0 , Author: Marsel Nakuci
// 2.32 06/11/2025 HSB-24636: Add property to cut top or/and bottom service batten , Author Marsel Nakuci
// 2.31 06/11/2025 HSB-22709: At the batten zone use 4 beams to create the vent for round and rectangular , Author Marsel Nakuci
// 2.30 10.10.2025 HSB-22709: Add option "As beams solid for rounding vent" , Author: Marsel Nakuci
// 2.29 01.07.2025 HSB-22709: Add option "As beams" at property Batten , Author: Marsel Nakuci
// 2.28 27/06/2025 HSB-19318: Capture error when jacks not possible , Author Marsel Nakuci
// 2.27 26.06.2025 HSB-19318: Add properties for bracing and jacks , Author: Marsel Nakuci
//2.26 18/07/2024 Add locating plate as beamtype to avoid Author: Robert Pol
// 2.25 14.02.2023 HSB-17870 Element validation added , Author Thorsten Huck
// Version 2.24 25.01.2022 HSB-14016: Support insertion of multiple instances when multiple walls are selected Author: Marsel Nakuci
// Version 2.23 25.11.2021 HSB-11217: created battens should not exceed boundaries of existing battens Author: Marsel Nakuci
// Version 2.22 23.04.2021 HSB-11217: Dont consider beams in sheet zones Author: Marsel Nakuci
// Version 2.21 22.03.2021 HSB-10859: when vent on top of an existing stud that is not at joining of 2 sheets then delete the stud. Add property No/Yes to controll this behaviour Author: Marsel Nakuci
// Version 2.20 19.03.2021 HSB-11217: add none at the list of batten zones Author: Marsel Nakuci
// V 2.19 22.02.2021 HSB-10280: consider options stretch left,right, both for the battens, set property Fixed vent when colliding with existing stud Author: Marsel Nakuci
// V 2.18 22.02.2021 HSB-10280: add properties for creating battens around vent Author: Marsel Nakuci
/// Revised: Anno Sportel 040624	First revision
/// Revised: Anno Sportel 040624	Change: Add dimension
/// Revised: Anno Sportel 040624	Change: Place vent next to closest stud 
/// Revised: Anno Sportel 040624	Change: Add option to create a fixed vent 
/// Revised: Anno Sportel 050417	Change: Split sheeting if FIXED vent is placed on a sheet joint.
/// Revised: Anno Sportel 050422	Change: Do not mill the sheeting if vent is placed on sheet joint.
/// Revised: Mick Kelly 060202		Change: Dim line has been removed and height of vent has been added as text above the vent.
/// Revised: Thorsten Huck 061109	Change: pline for no insulation area published 
/// Revised: Alberto Jena 080124	Version 1.1 Top and Front View and DispRep 
/// Modify by: Alberto Jena (aj@hsb-cad.com)	date: 01.04.2009	version 2.0: Release Version for UK Content 
/// Modify by: Alberto Jena (aj@hsb-cad.com)	date: 00.06.2009	version 2.1: 	Add Beam Properties (Name.. Label.. Material), 
///				Y/N to create beams as a module
///				Add the code to be able to run from the palette
/// Modify by: Alberto Jena (aj@hsb-cad.com)	date: 05.08.2010	version 2.2: 	Set the Beam Type to Vents and the name and information is defaulted to Vent. 
///The fixed Vent option gives the studs defaulted to Stud.
/// version 2.6: 	The beams that are created by the TSL now are set by default to allow nails.
/// version 2.7: 	Add the option for round vent.
/// version 2.10: HSB-5595: Add the property stretch vertical { Do not stretch, stretch left, stretch right, stretch both}
/// version 2.11: HSB-5595: Some cosmetic
/// Modify by: nils.gregor@hsb-cad.com	date: 02jun2020	version 2.15: Add formatObject to access all properties for display
/// <version value="2.16" date=05jun2020" author="thorsten.huck@hsbcad.com"> add/remove format revised, text drawn in model and dxa display </version>
/// <version value="2.17" date=09oct2020" author="alberto.jena@hsbcad.com"> add categories and a property to freeze the vent so the beams can be modified manually </version>
/// </History>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsb_Vent")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Add/Remove Format|") (_TM "|Select tool|"))) TSLCONTENT
//endregion
	
	
//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String categoryDisplay = T("|Display|");
	String categoryBeams = T("|Beam properties|");
	String categoryJacksBracing = T("|Jacks and bracing|");
	String categoryTooling = T("|Tooling|");
	String categoryLocationAndSize = T("|Location and size|");
	String categoryBattens = T("|Battens|");
	String categoryChecks = T("|Checking|");
//end Constants//endregion
	
	

_ThisInst.setSequenceNumber(-10);

Unit(1,"mm"); // script uses mm
String sArNY[] = {T("No"), T("Yes")};
int arNNY[]={FALSE, TRUE};


//region Functions #FU

Beam createBeamFromSheet(Sheet _sheet)
{ 
	Beam bmNew;
	
	PlaneProfile ppSheet=_sheet.profShape();
	
	Element _el=_sheet.element();
	//
	Vector3d _vx=_el.vecX();
	Vector3d _vy=_el.vecY();
	Vector3d _vz=_el.vecZ();
	//
	// get extents of profile
	LineSeg seg = ppSheet.extentInDir(_vx);
	double dX = abs(_vx.dotProduct(seg.ptStart()-seg.ptEnd()));
	double dY = abs(_vy.dotProduct(seg.ptStart()-seg.ptEnd()));
	
	int _nZone=_sheet.myZoneIndex();
	ElemZone _eZone=_el.zone(_nZone);
	
	Vector3d _vxBm=dX>dY?_vx:_vy;
	Vector3d _vyBm=_eZone.vecZ();
	Vector3d _vzBm=_vxBm.crossProduct(_vyBm);_vzBm.normalize();
	
	Body _bd=_sheet.realBody();
	bmNew.dbCreate(_bd,_vxBm,_vyBm,_vzBm,true,false);
	bmNew.setColor(_eZone.color());
	bmNew.setType(_kBatten);
	bmNew.setMaterial(_eZone.material());
	bmNew.assignToElementGroup(_el, TRUE, _nZone, 'Z');
	
	
	return bmNew;
}

//end Functions #FU//endregion



// ***
// Create properties.
// This part of the scriptcreates the properties which can be changed by the user.
// These properties are visible in the OPM.
// ***

String sFormatName=T("|Format Label|");	
PropString sFormat(17, T("|Vent|"), sFormatName);	
sFormat.setDescription(T("|Defines the format of the description.|"));
sFormat.setCategory(categoryDisplay);

PropString sDimStyle(12,_DimStyles,T("Dimension style")); sDimStyle.setCategory(categoryDisplay);

PropString sDispRep(13,"",T("Display Representation")); sDispRep.setCategory(categoryDisplay);

PropDouble dHeight(0,U(1250, 50), T("Height to underside of top timber")); dHeight.setCategory(categoryLocationAndSize);

String sType[]={T("Rectangular"), T("Round")};
PropString sVentType(18, sType, T("Vent Shape")); sVentType.setCategory(categoryLocationAndSize);

PropDouble dVentW(1,U(150,6),T("Width of vent")); dVentW.setCategory(categoryLocationAndSize);
PropDouble dVentH(2,U(150,6),T("Height of vent")); dVentH.setCategory(categoryLocationAndSize);
PropDouble dDiameter1(3, U(150,6),T("Diameter of Vent")); dDiameter1.setCategory(categoryLocationAndSize);

PropString sCreateVertical(14, sArNY, T("Create Vertical Blocks"), 1); sCreateVertical.setCategory(categoryLocationAndSize);
sCreateVertical.setDescription("This option allow you to create vertical beams around the vent");

// HSB-5595 Add property yes/no Stretch Left, Stretch Right, Stretch Both.
String sStretchOptionName = T("|Stretch vertical|");
String sStretchOptions[] ={ T("Do not stretch"), T("Stretch left"), T("Stretch right"), T("Stretch both")};
PropString sStretchOption(21, sStretchOptions, sStretchOptionName);  sStretchOption.setCategory(categoryLocationAndSize);
sStretchOption.setDescription(T("|Options for stretching the vertical beams around the vent|"));
// HSB-5595 //

PropString sCreateStuds(16, sArNY, T("Snap to existing studs"), 1); sCreateStuds.setCategory(categoryLocationAndSize);
sCreateStuds.setDescription("If the vent is not fixed this can allow the vent to be created next to existing studs.");
// if fixed then it cannot move left and right
PropString sFixed(8, sArNY, T("Fixed vent")); sFixed.setCategory(categoryLocationAndSize);

PropString sFreeze(23, sArNY, T("Freeze vent")); sFreeze.setCategory(categoryLocationAndSize);
sFreeze.setDescription("It will freeze the beams creation so they can be manualy modified");

String sStudExistingDeleteName=T("|Delete existing stud|");	
PropString sStudExistingDelete(26, sArNY, sStudExistingDeleteName);	
sStudExistingDelete.setDescription(T("|If option yes is selected, then the existing stud that collides with vent will be deleted unless it lands at a sheet joint|"));
sStudExistingDelete.setCategory(categoryLocationAndSize);
// ----Battens----
String sBattenName=T("|Batten|");
// zones
//String sBattenZoneName=T("|Zone|");	
int nZonesAll[] ={ -5 ,- 4 ,- 3 ,- 2 ,- 1, 0, 1, 2, 3, 4, 5};
//PropInt nBattenZone(1, nZonesAll, sBattenZoneName);	
//nBattenZone.setDescription(T("|Defines the Batten Zone. Zone 0 means option for batten is not active.|"));
//nBattenZone.setCategory(categoryBattens);
// HSB-11217
String sBattenZoneName=T("|Zone|");	
String sZonesAll[] ={ "-5" ,"-4" ,"-3" ,"-2" ,"-1", "None", "1", "2", "3", "4", "5"};
PropString sBattenZone(25, sZonesAll, sBattenZoneName, 5);	
sBattenZone.setDescription(T("|Defines the Batten Zone|"));
sBattenZone.setCategory(categoryBattens);
int nBattenZone = nZonesAll[sZonesAll.find(sBattenZone)];

// batten type
String sBattens[] ={ T("|No|"), T("|Studs|"), T("|Blocking|"),T("|As beam|"),T("|As beam solid for roundings vent|")};// HSB-22709
PropString sBatten(24, sBattens, sBattenName);
sBatten.setDescription(T("|Defines the Batten type|"));
sBatten.setCategory(categoryBattens);
// tolerance for blocking batten
String sBattenToleranceName=T("|Tolerance|");	
PropDouble dBattenTolerance(5, U(0), sBattenToleranceName);	
dBattenTolerance.setDescription(T("|Defines the BattenTolerance|"));
dBattenTolerance.setCategory(categoryBattens);


// HSB-24636: 2 properties for splitting battens
String kPainterCollection = "Socket\\";
String kSheet = "Sheet";
String kDisabled = T("<|Disabled|>");
String sBattenDescription = T("|The selection supports painter definitions of type 'Sheet'.|") + 
		T("|The painter definition may be stored in a collection named 'Socket' in which case it will only collect definitions within this collection.|") +
		T("|If no such collection is found all painters matching the supported types will be collected.|");

//region HSB-24636 Collect valid Painters
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();
	
	// auto create painters if none found in dwg
	if (sPainters.length()<1)
	{ 
		String names[] ={ "batten-B", "batten-C", "batten-E"};
		for (int i=0;i<names.length();i++) 
		{ 
			PainterDefinition pd(kPainterCollection+names[i]);
			pd.dbCreate();
			if (pd.bIsValid())
			{ 
				pd.setType(kSheet);
				pd.setFilter("((Equals(Name,'"+names[i]+"')))");
				sPainters.append(names[i]);
			}
			 
		}//next i
	}
	
	// if a collection was found consider only those of the collection, else take all
	int bHasPainterCollection; 
	for (int i=0;i<sPainters.length();i++) 	{if (sPainters[i].find(kPainterCollection,0,false)>-1){bHasPainterCollection=true;break;}}//next i
	if (bHasPainterCollection)
		for (int i=sPainters.length()-1; i>=0 ; i--) 
			if (sPainters[i].find(kPainterCollection,0,false)<0)
				sPainters.removeAt(i);	

	String sSplitPainters[0];
	for (int i=0;i<sPainters.length();i++) 
	{ 
		String painter = sPainters[i];
		if (painter == kDisabled)continue;
		
		PainterDefinition pd(painter);
		int bValidType = pd.type() == kSheet;

		int n = painter.find("\\", 0, false);
	// append collection painters without the collection name	
		if (painter.find(kPainterCollection,0,false)>-1) 
		{ 
			String s = painter.right(painter.length() - n - 1);
			if (sSplitPainters.findNoCase(s,-1)<0 && bValidType)
				sSplitPainters.append(s);				
		}
	// ignore other collections	
		else if (!bHasPainterCollection && n <0) 
		{
			if (bValidType)sSplitPainters.append(painter);  			
		}
	}//next i
	sSplitPainters = sSplitPainters.sorted();
	sSplitPainters.insertAt(0, kDisabled);			
//endregion 


// HSB-24636
String sSplitBattenBottomName=T("|Bottom|");	
PropString sSplitBattenBottom(29, sSplitPainters, sSplitBattenBottomName);
sSplitBattenBottom.setCategory(categoryBattens);
sSplitBattenBottom.setDescription(T("|Defines whether the bottom Batten will be splitted| ")+sBattenDescription);
int nSplitBottom = sSplitPainters.find(sSplitBattenBottom);
if (nSplitBottom<0)// legacy: convert No/Yes into new property values
{ 	
	int ny = sArNY.find(sSplitBattenBottom);
	if (sSplitPainters.length()>1 && ny!=0)			
		sSplitBattenBottom.set(sSplitPainters[1]);
	else
		sSplitBattenBottom.set(kDisabled);
}
	
String sSplitBattenTopName=T("|Top|");	
PropString sSplitBattenTop(30, sSplitPainters, sSplitBattenTopName);	
sSplitBattenTop.setCategory(categoryBattens);
sSplitBattenTop.setDescription(T("|Defines whether the top Batten will be splitted| ")+sBattenDescription);
//	int nSplitTop = sSplitPainters.find(sSplitBattenBottom);
int nSplitTop = sSplitPainters.find(sSplitBattenTop);
if (nSplitTop<0)// legacy: convert No/Yes into new property values
{ 	
	int ny = sArNY.find(sSplitBattenTop);
	if (sSplitPainters.length()>1 && ny!=0)			
		sSplitBattenTop.set(sSplitPainters[1]);
	else
		sSplitBattenTop.set(kDisabled);
}	

// ----         --------
PropString sName(0,"VENT", "Name"); sName.setCategory(categoryBeams);
sName.setDescription("");

PropString sMaterial(1,"","Material"); sMaterial.setCategory(categoryBeams);
sMaterial.setDescription("");

PropString sGrade(2,"","Grade"); sGrade.setCategory(categoryBeams);
sGrade.setDescription("");

PropString sInformation(3,"VENT","Information"); sInformation.setCategory(categoryBeams);
sInformation.setDescription("");

PropString sLabel(4,"","Label"); sLabel.setCategory(categoryBeams);
sLabel.setDescription("");

PropString sSublabel(5,"","Sublabel"); sSublabel.setCategory(categoryBeams);
sSublabel.setDescription("");

PropString sSublabel2(6,"","Sublabel 2"); sSublabel2.setCategory(categoryBeams);
sSublabel2.setDescription("");

PropString sModule(7, sArNY, T("Create Vent as a Module")); sModule.setCategory(categoryBeams);
sModule.setDescription("");

// HSB-19318
String sBracingName=T("|Bracing|");
String sBracings[]={T("|None|"),T("|Top|"),T("|Bottom|"),T("|Both|")};
PropString sBracing(27, sBracings, sBracingName);	
sBracing.setDescription(T("|Defines whether the bracing will be created or not|"));
sBracing.setCategory(categoryJacksBracing);

String sJacksName=T("|Jacks|");	
String sJackss[]={T("|None|"),T("|Top|"),T("|Bottom|"),T("|Both|")};
PropString sJacks(28, sJackss, sJacksName);	
sJacks.setDescription(T("|Defines whether the jacks will be created or not|"));
sJacks.setCategory(categoryJacksBracing);


PropString sCreateMilling(15, sArNY, T("Create Milling"), 1); sCreateMilling.setCategory(categoryTooling);
sCreateMilling.setDescription("This option allow you to create milling around the vent for all the zones");

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
PropString psZones(22, "1;2;10;", T("Zones to Mill")); psZones.setCategory(categoryTooling);
psZones.setDescription(T("Please type the number of the zones separate by ; (1-10)"));

PropInt nToolingIndex(0,0,T("Tooling index")); nToolingIndex.setCategory(categoryTooling);

String arSTurn[]= {T("Against course"),T("With course")};
int arNTurn[]={_kTurnAgainstCourse, _kTurnWithCourse};
PropString sTurn(9,arSTurn,T("Turning direction")); sTurn.setCategory(categoryTooling);

PropString sOShoot(10,sArNY,T("Overshoot")); sOShoot.setCategory(categoryTooling);

PropString sVacuum(11,sArNY,T("Vacuum")); sVacuum.setCategory(categoryTooling);

PropString strNailing (19, sArNY,T("Set Beams as NO Nail")); strNailing.setCategory(categoryTooling);

PropString sShowExclusionZone(20,sArNY,T("Show exclusion zone"),0); sShowExclusionZone.setCategory(categoryChecks);
PropDouble dDiameterExlusionZone(4, U(300),T("Distance exclusion zone")); dDiameterExlusionZone.setCategory(categoryChecks);

//  ***
//  End of properties. 
//  ***

// Load the values from the catalog
if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nModule = arNNY[sArNY.find(sModule,0)];
int nExclusionZone = arNNY[sArNY.find(sShowExclusionZone,0)];
int nFixed = arNNY[sArNY.find(sFixed,0)];
int nTurn = arNTurn[arSTurn.find(sTurn,0)];
int nOShoot = arNNY[sArNY.find(sOShoot,0)];
int nVacuum = arNNY[sArNY.find(sVacuum,0)];
int nFreeze = arNNY[sArNY.find(sFreeze,0)];

// ***
// Start insert
// This code is executed when the TSL is inserted.
// ***
if (_bOnInsert)
{
	if ( insertCycleCount() > 1 ) {
		eraseInstance();
		return;
	}
	if (_kExecuteKey == "")
		showDialogOnce();
	
// prompt for elements
	PrEntity ssE(T("|Select elements|"), Element());
  	if (ssE.go())
		_Element.append(ssE.elementSet());
	_Pt0 = getPoint(T("Select a position"));
	if(_Element.length()>1)	
	{ 
		// HSB-14016:
		// more then 1 element selected.
		// see if on top of each other and distribute
		// find a reference element that selected point is between minmax
		Element eRef;
		for (int iel=0;iel<_Element.length();iel++) 
		{ 
			LineSeg segMinMax = _Element[iel].segmentMinMax();
			// point ptInside inside 2 points pt1 and pt2
			int iInside=true;
			{ 
				Point3d pt1 = segMinMax.ptStart();
				Point3d pt2 = segMinMax.ptEnd();
				Point3d ptInside = _Pt0;
				Vector3d vecDir = _Element[iel].vecX();
				vecDir.normalize();
				double dLengthPtI=abs(vecDir.dotProduct(ptInside-pt1))
					 + abs(vecDir.dotProduct(ptInside - pt2));
				double dLengthSeg = abs(vecDir.dotProduct(pt1 - pt2));
				if (abs(dLengthPtI - dLengthSeg) > dEps)iInside=false;
			}
			if(iInside)
			{ 
				eRef = _Element[iel];
				break;
			}
		}//next iel
		if(!eRef.bIsValid())
		{ 
			// no reference element found
			reportMessage("\n"+scriptName()+" "+T("|Please select a point inside the wall boundaries|"));
			eraseInstance();
			return;
		}
		PlaneProfile ppRef(Plane(eRef.ptOrg(), eRef.vecY()));
		ppRef.joinRing(eRef.plOutlineWall(),_kAdd);
		for (int iel=_Element.length()-1; iel>=0 ; iel--) 
		{ 
			Element elI=_Element[iel];
			PlaneProfile ppI(ppRef.coordSys());
			ppI.joinRing(elI.plOutlineWall(),_kAdd);
			PlaneProfile ppIntersect = ppRef;
			if(!ppIntersect.intersectWith(ppI))
				_Element.removeAt(iel);
		}//next iel
		// create TSL
		TslInst tslNew;	Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {}; Entity entsTsl[] = {}; Point3d ptsTsl[] = {_Pt0};
		int nProps[1]; 
		nProps[0] = nToolingIndex;
		
		double dProps[6]; 
		dProps[0] = dHeight;
		dProps[1] = dVentW;
		dProps[2] = dVentH;
		dProps[3] = dDiameter1;
		dProps[5] = dBattenTolerance;
		dProps[4] = dDiameterExlusionZone;
		
		String sProps[31];
		sProps[17] = sFormat;
		sProps[12] = sDimStyle;
		sProps[13] = sDispRep;
		sProps[18] = sVentType;
		sProps[14] = sCreateVertical;
		sProps[21] = sStretchOption;
		sProps[16] = sCreateStuds;
		sProps[8] = sFixed;
		sProps[23] = sFreeze;
		sProps[26] = sStudExistingDelete;
		sProps[27] = sBracing;
		sProps[28] = sJacks;
		sProps[25] = sBattenZone;
		sProps[24] = sBatten;
		sProps[29] = sSplitBattenBottom;// HSB-24636
		sProps[30] = sSplitBattenTop;// HSB-24636
		sProps[0] = sName;
		sProps[1] = sMaterial;
		sProps[2] = sGrade;
		sProps[3] = sInformation;
		sProps[4] = sLabel;
		sProps[5] = sSublabel;
		sProps[6] = sSublabel2;
		sProps[7] = sModule;
		sProps[15] = sCreateMilling;
		sProps[22] = psZones;
		sProps[9] = sTurn;
		sProps[10] = sOShoot;
		sProps[11] = sVacuum;
		sProps[19] = strNailing;
		sProps[20] = sShowExclusionZone;
		Map mapTsl;	
		for (int iel=0;iel<_Element.length();iel++) 
		{ 
			entsTsl.setLength(0);
			entsTsl.append(_Element[iel]);
			tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
				ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);			 
		}//next iel
		
		eraseInstance();
		return;
		
	}
	else
	{
		// one element is selected
//	_Element.append(getElement(T("Select an element")));
//	_Pt0 = getPoint(T("Select a position"));
		
		return;
	}
}
// ***
// End insert.
// ***

// HSB-17870 
if (_Element.length()<1)
{ 
	reportNotice("\n"+ scriptName()+" " + TN("|No valid element reference found|"));
	eraseInstance();
	return;
}

// add dberase event
addRecalcTrigger(_kErase, TRUE);

if(_bOnDbErase)
{ 
	// cleanup beams
	String sEntityKeys[]={"bmBattenLeft","bmBattenLeftTop","bmBattenLeftBottom",
		"bmBattenRight","bmBattenRightTop","bmBattenRightBottom",
		"bmBattenAboveLeft","bmBattenAboveRight","bmBattenBelowRight",
		"bmBattenAbove","bmBattenBelow","bmBattenLeft","bmBattenRight",
		"shAbove","shBelow","shStLeft","shStRight",
		"shBlocking",
		"bmAbove","bmBelow",
		"bmStLeft","bmStRight",
		"bmBracingAbove","bmBracingBelow",
		"bmJackLeftAbove","bmJackRightAbove",
		"bmJackLeftBelow","bmJackRightBelow"};
	
	for (int s=0;s<sEntityKeys.length();s++) 
	{ 
		if(_Map.hasEntity(sEntityKeys[s]))
		{ 
			Entity ent=_Map.getEntity(sEntityKeys[s]);
			ent.dbErase();
		}
	}//next s
	
	String sEntityArrayKeys[]={"BeamsSheeting[]"};
	for (int s=0;s<sEntityArrayKeys.length();s++) 
	{ 
		Entity ents[]=_Map.getEntityArray(sEntityArrayKeys[s],sEntityArrayKeys[s],sEntityArrayKeys[s]);
		for (int e=ents.length()-1; e>=0 ; e--) 
		{ 
			ents[e].dbErase();
		}//next e
	}//next s
	
	// join splitted beams
	{ 
		Beam bmAlreadyJoined[0];
		if (_Map.hasEntity("bmToSplit"))
		{
			Entity ent1 = _Map.getEntity("bmToSplit");
			Beam bm1 = (Beam)ent1;
			Entity ent2 = _Map.getEntity("bmSplitted");
			Beam bm2 = (Beam)ent2;
			bm1.dbJoin(bm2);
			
			bmAlreadyJoined.append(bm1);
			bmAlreadyJoined.append(bm2);
		}
		
		Entity beamsPreviouslySplit[] = _Map.getEntityArray("bmToSplit[]", "", "bmToSplit");
		Entity beamsPreviouslyReturnedFromSplit[] = _Map.getEntityArray("bmSplitted[]", "", "bmSplitted");
		if (beamsPreviouslySplit.length() == beamsPreviouslyReturnedFromSplit.length())
		{
			for (int i = 0; i < beamsPreviouslySplit.length(); i++)
			{
				Beam bmSplit = (Beam)beamsPreviouslySplit[i];
				Beam bmPreviouslySplit = (Beam)beamsPreviouslyReturnedFromSplit[i];
				if ( ! bmSplit.bIsValid() || !bmPreviouslySplit.bIsValid()) continue;
				if (bmAlreadyJoined.find(bmSplit) != -1 || bmAlreadyJoined.find(bmPreviouslySplit) != -1) continue;
				bmSplit.dbJoin(bmPreviouslySplit);
			}
		}
	}
	// join splitted battens
	{ 
		if (_Map.hasEntity("bmToSplitBatten"))
		{ 
			Entity ent1 = _Map.getEntity("bmToSplitBatten");
			Beam bm1 = (Beam)ent1;
			Entity ent2 = _Map.getEntity("bmSplittedBatten");
			Beam bm2 = (Beam)ent2;
			
			if(bm1.bIsValid() && bm2.bIsValid())
			{ 
				bm1.dbJoin(bm2);
			}
			_Map.removeAt("bmToSplitBatten",true);
			_Map.removeAt("bmSplittedBatten",true);
		}
	}
	
	return;
}

int nVertical = arNNY[sArNY.find(sCreateVertical,0)];
int nStuds = arNNY[sArNY.find(sCreateStuds,0)];
int bMilling = arNNY[sArNY.find(sCreateMilling,0)];
int nType = sType.find(sVentType, 0); //0 = Rectangular - 1 = Round
int nNoNail = sArNY.find(strNailing);
// HSB-19318
int nBracing=sBracings.find(sBracing);
int nJacks=sJackss.find(sJacks);
int nBatten=sBattens.find(sBatten);
// HSB-5595 do not stretch, stretch left, stretch right, stretch both
int nStretchOption = sStretchOptions.find(sStretchOption);
// HSB-5595
//return;
//Fill the values for the zones to mill
int nZones[0];
String sZones=psZones;
sZones.trimLeft();
sZones.trimRight();
sZones=sZones+";";
for (int i=0; i<sZones.length(); i++)
{
	String str=sZones.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
	{
		int nIndex=nValidZones.find(str.atoi());
		if(nIndex!=-1)
		{
	  		nZones.append(nRealZones[nIndex]);
		}
	}
}
// HSB-10280
int nZonesValid[0];
for (int iZ=0;iZ<nZonesAll.length();iZ++) 
{ 
	if(_Element[0].zone(nZonesAll[iZ]).dH()>0)
	{ 
		if (nZonesAll[iZ] == 0)continue;
		// valid zone
		nZonesValid.append(nZonesAll[iZ]);
	}
}//next iZ
if (nZonesValid.find(nBattenZone) < 0 && nBattenZone!=0)
{
//	nBattenZone.set(nZonesAll[nZonesAll.find(nZonesValid[0])]);
	sBattenZone.set(nZonesAll[nZonesAll.find(nZonesValid[0])]);
}
nBattenZone = nZonesAll[sZonesAll.find(sBattenZone)];

if (_Element.length() == 0) { eraseInstance(); return; }

String sModuleName;
int nBeamColor = 32;
String sTempModuleName = "-1";

for (int i = 0; i < _Beam.length(); i++)
{ 
	if (_Beam[i].module() != "")
	{ 
		sTempModuleName = _Beam[i].module();
		nBeamColor = _Beam[i].color();
		break;
	}
}
if (sTempModuleName != "-1")
{ 
	sModuleName = sTempModuleName;
}
else
{
	sModuleName = "Vent" + _ThisInst.handle();
}

if ( ! nFreeze)
{
	_Beam.setLength(0);
	//Clear _Map.
	if (_Map.hasEntity("bmAbove")) {
		Entity ent = _Map.getEntity("bmAbove");
		ent.dbErase();
	}
	if (_Map.hasEntity("bmBelow")) {
		Entity ent = _Map.getEntity("bmBelow");
		ent.dbErase();
	}
	if (_Map.hasEntity("bmStLeft")) {
		Entity ent = _Map.getEntity("bmStLeft");
		ent.dbErase();
	}
	if (_Map.hasEntity("bmStRight")) {
		Entity ent = _Map.getEntity("bmStRight");
		ent.dbErase();
	}
	// HSB-19318
	if (_Map.hasEntity("bmBracingAbove")) {
		Entity ent = _Map.getEntity("bmBracingAbove");
		ent.dbErase();
	}
	if (_Map.hasEntity("bmBracingBelow")) {
		Entity ent = _Map.getEntity("bmBracingBelow");
		ent.dbErase();
	}
	if (_Map.hasEntity("bmJackLeftAbove")) {
		Entity ent = _Map.getEntity("bmJackLeftAbove");
		ent.dbErase();
	}
	if (_Map.hasEntity("bmJackRightAbove")) {
		Entity ent = _Map.getEntity("bmJackRightAbove");
		ent.dbErase();
	}
	if (_Map.hasEntity("bmJackLeftBelow")) {
		Entity ent = _Map.getEntity("bmJackLeftBelow");
		ent.dbErase();
	}
	if (_Map.hasEntity("bmJackRightBelow")) {
		Entity ent = _Map.getEntity("bmJackRightBelow");
		ent.dbErase();
	}

//	if(sBattens.find(sBatten)!=0)
	{ 
		// create battens
		if (_Map.hasEntity("shAbove")) 
		{
			Entity ent = _Map.getEntity("shAbove");
			ent.dbErase();
		}
		if (_Map.hasEntity("shBelow")) 
		{
			Entity ent = _Map.getEntity("shBelow");
			ent.dbErase();
		}
		if (_Map.hasEntity("shStLeft")) 
		{
			Entity ent = _Map.getEntity("shStLeft");
			ent.dbErase();
		}
		if (_Map.hasEntity("shStRight")) 
		{
			Entity ent = _Map.getEntity("shStRight");
			ent.dbErase();
		}
		if (_Map.hasEntity("shBlocking")) 
		{
			Entity ent = _Map.getEntity("shBlocking");
			ent.dbErase();
		}
		// join sheet if exist
		if(_Map.hasEntity("shCutted"))
		{ 
			Entity ent = _Map.getEntity("shCutted");
			PLine pline = _Map.getPLine("pline");
//			PLine plCopy = pline;
//			plCopy.transformBy(_Element[0].vecX() * U(150));
//			plCopy.vis(6);
			pline.vis(3);
			Sheet shCutted = (Sheet)ent;
			shCutted.setPlEnvelope(pline);
			shCutted.joinRing(pline, _kAdd);
//			if(sheetsCutted.length()>0)
//				shCutted = sheetsCutted[0];
			
			Entity ents[] = _Map.getEntityArray("sheetsNew", "", "");
			for (int iEnt=ents.length()-1; iEnt>=0 ; iEnt--) 
			{ 
				ents[iEnt].dbErase();
			}//next iEnt
		}
		if(sArNY.find(sStudExistingDelete)==1)
		{ 
			// HSB-10859: create stud if previously deleted
			if(_Map.hasMap("StudDeletedInfo"))
			{ 
				Map mapStudDeleted = _Map.getMap("StudDeletedInfo");
				Point3d ptStud = mapStudDeleted.getPoint3d("ptStud");
				Vector3d vecXstud = mapStudDeleted.getVector3d("vecXstud");
				Vector3d vecYstud = mapStudDeleted.getVector3d("vecYstud");
				Vector3d vecZstud = mapStudDeleted.getVector3d("vecZstud");
				double dL = mapStudDeleted.getDouble("DL");
				double dW = mapStudDeleted.getDouble("DW");
				double dH = mapStudDeleted.getDouble("DH");
				int iColorThis= mapStudDeleted.getInt("Color");
				String sLabelThis = mapStudDeleted.getString("Label");
				String sSubLabelThis = mapStudDeleted.getString("SubLabel");
				String sSubLabel2This = mapStudDeleted.getString("SubLabel2");
				String sGradeThis = mapStudDeleted.getString("Grade");
				String sInformationThis = mapStudDeleted.getString("Information");
				String sMaterialThis = mapStudDeleted.getString("Material");
				String sBeamCodeThis = mapStudDeleted.getString("BeamCode");
				String sNameThis = mapStudDeleted.getString("Name");
				
				ptStud.vis(1);
				vecXstud.vis(ptStud, 1);
				vecYstud.vis(ptStud, 3);
				vecZstud.vis(ptStud, 5);
				// create new beam
				Beam bmStud;
				bmStud.dbCreate(ptStud, vecXstud, vecYstud, vecZstud, dL, dW, dH, 0, 0, 0);
				bmStud.assignToElementGroup(_Element[0], true, 0, 'Z' );
				bmStud.setColor(iColorThis);
				bmStud.setLabel(sLabelThis);
				bmStud.setSubLabel(sSubLabelThis);
				bmStud.setSubLabel2(sSubLabel2This);
				bmStud.setGrade(sGradeThis);
				bmStud.setInformation(sInformationThis);
				bmStud.setMaterial(sMaterialThis);
				bmStud.setBeamCode(sBeamCodeThis);
				bmStud.setName(sNameThis);
				_Map.removeAt("StudDeletedInfo", true);
			}
			
			// if vent on top of a stud at joint of sheets, remove the stud, and save its info in map
			Element el = _Element[0];
			Beam beamsAll[] = el.beam();
			Beam beamsVerAll[] = el.vecX().filterBeamsPerpendicularSort(beamsAll);
			PlaneProfile ppVent(el.coordSys());
			PLine plVent;
			plVent.createRectangle(LineSeg(_Pt0 - .5 * el.vecX() * dVentW - .5 * el.vecY() * dVentH, 
					_Pt0 + .5 * el.vecX() * dVentW + .5 * el.vecY() * dVentH), el.vecX(), el.vecY());
			ppVent.joinRing(plVent, _kAdd);
			ppVent.vis(1);
			for (int iB=0;iB<beamsVerAll.length();iB++) 
			{ 
				Beam bmIb = beamsVerAll[iB];
				PlaneProfile ppBmI = bmIb.envelopeBody().shadowProfile(Plane(el.ptOrg(), el.vecZ()));
	//			ppBmI.vis(2);
				PlaneProfile ppIntersect = ppVent;
				if(!ppIntersect.intersectWith(ppBmI))continue;
				ppBmI.vis(2);
				// vent in stud, see if stud at joint of sheets
				int iStudAtSheetJoint = false;
				int iBreak=false;
				for (int iZ=0;iZ<nZonesAll.length();iZ++) 
				{ 
					Element el = _Element[0];
					Sheet sheetsIz[] = el.sheet(nZonesAll[iZ]);
					ElemZone ezIz = el.zone(nZonesAll[iZ]);
					PlaneProfile ppZiz(ezIz.coordSys());
					
					// get all couples
					// stud must be inside 2 sheets but not inside one sheet
					int iCouples[0];
					
					for (int iSh=0;iSh<sheetsIz.length();iSh++) 
					{ 
						for (int jSh=0;jSh<sheetsIz.length();jSh++) 
						{ 
							if (iSh == jSh)continue;
							iCouples.append(1000 * (iSh + 1) + (jSh + 1));
							if(iCouples.find(1000 * (jSh + 1) + (iSh + 1))>-1)
							{ 
								continue;
							}
							//
							PlaneProfile ppI(ezIz.coordSys());
							ppI.joinRing(sheetsIz[iSh].plEnvelope(), _kAdd);
							PlaneProfile ppJ(ezIz.coordSys());
							ppJ.joinRing(sheetsIz[jSh].plEnvelope(), _kAdd);
							//
							PlaneProfile ppIntersectTest = ppI;
							ppIntersectTest.shrink(-dEps);
							if(!ppIntersectTest.intersectWith(ppJ))
							{
								// sheets not close with each other
								continue;
							}
							
							PlaneProfile ppItest = ppI;
							PlaneProfile ppJtest = ppJ;
							
							PlaneProfile ppBmItest = ppBmI;
							ppBmItest.subtractProfile(ppI);
							if(ppBmItest.area()<pow(dEps,2))
							{ 
								// all inside sheet
								continue;
							}
							PlaneProfile ppBmJtest = ppBmI;
							ppBmJtest.subtractProfile(ppJ);
							if(ppBmJtest.area()<pow(dEps,2))
							{ 
								// all inside sheet
								continue;
							}
							
							PlaneProfile ppUnion = ppI;
							ppUnion.unionWith(ppJ);
							
							PlaneProfile ppBmUniontest = ppBmI;
							ppBmUniontest.subtractProfile(ppUnion);
							if(ppBmUniontest.area()>pow(dEps,2))
							{ 
								// not all inside both sheets
								continue;
							}
							
							PlaneProfile ppIextend = ppI;
							ppIextend.shrink(-dEps);
							PlaneProfile ppJextend = ppJ;
							ppJextend.shrink(-dEps);
							// intersection bus be along the height of the beam
							PlaneProfile ppIntersectExtend = ppIextend;
							ppIntersectExtend.intersectWith(ppJextend);
							// get extents of profile
							LineSeg segIntersectExtend = ppIntersectExtend.extentInDir(el.vecX());
							double dYIntersectExtend = abs(el.vecY().dotProduct(segIntersectExtend.ptStart()-segIntersectExtend.ptEnd()));
							LineSeg segBeamI=ppBmI.extentInDir(el.vecX());
							double dYbeamI = abs(el.vecY().dotProduct(segBeamI.ptStart()-segBeamI.ptEnd()));
							if(dYbeamI>dYIntersectExtend)
								continue;
							// located at the joint of 2 sheets
							iBreak = true;
							ppI.vis(3);
							ppJ.vis(3);
							break;// break jSh
						}//next jSh
						if (iBreak)break;// break iSh
					}//next iSh
					if (iBreak)break;// break zone looping
				}//next iZ
				if(!iBreak)
				{ 
					// stud not at joint, save its info and delete it
					Map mapStudDeleted;
					
					mapStudDeleted.setPoint3d("ptStud", bmIb.ptCen(), _kAbsolute);
					mapStudDeleted.setVector3d("vecXstud", bmIb.vecX());
					mapStudDeleted.setVector3d("vecYstud", bmIb.vecY());
					mapStudDeleted.setVector3d("vecZstud", bmIb.vecZ());
					
					mapStudDeleted.setDouble("DL", bmIb.dL());
					mapStudDeleted.setDouble("DW", bmIb.dD(bmIb.vecD(bmIb.vecY())));
					mapStudDeleted.setDouble("DH", bmIb.dD(bmIb.vecD(bmIb.vecZ())));
					mapStudDeleted.setInt("Color", bmIb.color());
					mapStudDeleted.setString("Label", bmIb.label());
					mapStudDeleted.setString("SubLabel", bmIb.subLabel());
					mapStudDeleted.setString("SubLabel2", bmIb.subLabel2());
					mapStudDeleted.setString("Grade", bmIb.grade());
					mapStudDeleted.setString("Information", bmIb.information());
					mapStudDeleted.setString("Material", bmIb.material());
					mapStudDeleted.setString("BeamCode", bmIb.beamCode());
					mapStudDeleted.setString("Name", bmIb.name());
					
					_Map.setMap("StudDeletedInfo", mapStudDeleted);
					
					bmIb.dbErase();
					// break loop of all studs
					break;
				}
				else
				{ 
					// stud that intersect with vent is found but at joint of sheets
					break;
				}
			}//next iB
		}
	}
	Beam bmAlreadyJoined[0];
	if (_Map.hasEntity("bmToSplit"))
	{
		Entity ent1 = _Map.getEntity("bmToSplit");
		Beam bm1 = (Beam)ent1;
		Entity ent2 = _Map.getEntity("bmSplitted");
		Beam bm2 = (Beam)ent2;
		bm1.dbJoin(bm2);
		
		bmAlreadyJoined.append(bm1);
		bmAlreadyJoined.append(bm2);
	}
	
	Entity beamsPreviouslySplit[] = _Map.getEntityArray("bmToSplit[]", "", "bmToSplit");
	Entity beamsPreviouslyReturnedFromSplit[] = _Map.getEntityArray("bmSplitted[]", "", "bmSplitted");
	if (beamsPreviouslySplit.length() == beamsPreviouslyReturnedFromSplit.length())
	{
		for (int i = 0; i < beamsPreviouslySplit.length(); i++)
		{
			Beam bmSplit = (Beam)beamsPreviouslySplit[i];
			Beam bmPreviouslySplit = (Beam)beamsPreviouslyReturnedFromSplit[i];
			if ( ! bmSplit.bIsValid() || !bmPreviouslySplit.bIsValid()) continue;
			if (bmAlreadyJoined.find(bmSplit) != -1 || bmAlreadyJoined.find(bmPreviouslySplit) != -1) continue;
			bmSplit.dbJoin(bmPreviouslySplit);
		}
	}
	// join splitted battens
	{ 
		if (_Map.hasEntity("bmToSplitBatten"))
		{ 
			Entity ent1 = _Map.getEntity("bmToSplitBatten");
			Beam bm1 = (Beam)ent1;
			Entity ent2 = _Map.getEntity("bmSplittedBatten");
			Beam bm2 = (Beam)ent2;
			
			if(bm1.bIsValid() && bm2.bIsValid())
			{ 
				bm1.dbJoin(bm2);
			}
			_Map.removeAt("bmToSplitBatten",true);
			_Map.removeAt("bmSplittedBatten",true);
		}
	}
}

CoordSys csEl = _Element[0].coordSys();
_ThisInst.assignToElementGroup(_Element[0],TRUE,0,'E');

//Calculate _Pt0.
Line ln(csEl.ptOrg(), csEl.vecX());
_Pt0 = ln.closestPointTo(_Pt0);
_Pt0 = _Pt0 + csEl.vecY() * (dHeight - 0.5 * dVentH);
//_Pt0.vis();

Element el = _Element[0];
Beam arBm[] = el.beam();
// HSB-11217 sometimes there can be beams at other zones rather then 0. Make sure to only include here zone 0
for (int i=arBm.length()-1; i>=0 ; i--) 
{ 
	if (arBm[i].myZoneIndex() != 0)
		arBm.removeAt(i);
}//next i

int nBeamTypesToAvoid[] ={ _kSFBlocking, _kBlocking, _kLocatingPlate};

// Select vertical beams of the element and put them in an array.
Beam arBmVer[0];
Beam arBmHor[0];
for (int i = 0; i < arBm.length(); i++) {
	if ( (arBm[i].vecX()).isPerpendicularTo(csEl .vecX()) ) {
		//put all beams perpendicular to the X-axis of the element in an array.
		arBmVer.append(arBm[i]);
	}
	else if ( (arBm[i].vecX()).isPerpendicularTo(csEl .vecY()) ) {
		//put all beams perpendicular to the Y-axis of the element in an array.
		if (nBeamTypesToAvoid.find(arBm[i].type() ,- 1) != -1) continue;
		arBmHor.append(arBm[i]);
	}
}

// ***
// Start find beams in and closest to the opening.
// Step through the vertical beams of the element.
// When the beam crosses the opening; add it to the array of beams that need to be split.
// When the does not cross the opening, check if it is the closest beam on the left or right side of the opening.
// ***
Beam bmClLeft;
Beam bmClRight;
Beam bmToSplitVer[0];
double dClLeft;
double dClRight;

for (int i = 0; i < arBmVer.length(); i++)
{
	// check the endpoints of the beam in cs.vecY direction that they are on the opposite side
	// of the center of the opening, otherwise it is not considered
	Point3d ptMinBm = arBmVer[i].ptRef() + arBmVer[i].dLMin() * arBmVer[i].vecX();
	Point3d ptMaxBm = arBmVer[i].ptRef() + arBmVer[i].dLMax() * arBmVer[i].vecX();
	double dBYMin = csEl .vecY().dotProduct(ptMinBm - _Pt0);
	double dBYMax = csEl .vecY().dotProduct(ptMaxBm - _Pt0);
	if ( dBYMin * dBYMax > 0 ) {
		continue;
	}
	
	double dBm = csEl .vecX().dotProduct(arBmVer[i].ptCen() - _Pt0);
	// Check if beam is in opening. If < 0 Then beam is in opening
	if ( (abs(dBm) - dVentW / 2 - arBmVer[i].dD(csEl .vecX()) / 2) < 0 ) {
		// the beam is in the X-range of the opening
		bmToSplitVer.append(arBmVer[i]);
	}
	else { //Beam is outside opening
		if (dBm < 0 ) { //Beam is on left side of opening
			if (dBm > dClLeft || !bmClLeft.bIsValid()) {
				dClLeft = dBm;
				bmClLeft = arBmVer[i];
			}
		}
		else if (dBm > 0) { //Beam is on right side of opening
			if (dBm < dClRight || !bmClRight.bIsValid()) {
				dClRight = dBm;
				bmClRight = arBmVer[i];
			}
		}
	}
}

Point3d ptInsert = _Pt0;
if ( ! nFixed && nStuds) //Recalculate insert point if vent is NOT fixed.
{
	if (abs(dClLeft) < abs(dClRight)) {
		ptInsert = _Pt0 - csEl.vecX() * ( abs(dClLeft) - 0.5 * (bmClLeft.dW() + dVentW) );
	}
	else {
		ptInsert = _Pt0 + csEl.vecX() * ( abs(dClRight) - 0.5 * (bmClRight.dW() + dVentW) );
	}
	dClLeft = csEl .vecX().dotProduct(bmClLeft.ptCen() - ptInsert);
	dClRight = csEl .vecX().dotProduct(bmClRight.ptCen() - ptInsert);
}

//_Pt0.vis(1);
//ptInsert.vis();
//Corner points of opening on the front side of zone 0.
Point3d ptUppL=ptInsert-dVentW/2*csEl.vecX()+dVentH/2*csEl.vecY(); //ptUppL.vis();
Point3d ptUppR=ptInsert+dVentW/2*csEl.vecX()+dVentH/2*csEl.vecY(); //ptUppR.vis();
Point3d ptLowL=ptInsert-dVentW/2*csEl.vecX()-dVentH/2*csEl.vecY(); //ptLowL.vis();
Point3d ptLowR=ptInsert+dVentW/2*csEl.vecX()-dVentH/2*csEl.vecY(); //ptLowR.vis();

LineSeg lsForMidPoint (ptLowL, ptUppR);

//Create poly line of opening
PLine pl(csEl.vecZ());
pl.addVertex(ptUppR);
pl.addVertex(ptUppL);
pl.addVertex(ptLowL);
pl.addVertex(ptLowR);
pl.close();
//pl.vis();

//uncomment next line while debugging.
//return;

//Mill the sheeting.
Beam beamsSheeting[0];
if (bMilling)
{
	//nType
	lsForMidPoint.vis(1);
	
	int bAsBeam, bAsBeamSolidRoundings;
	PLine plAsBeam(csEl.vecZ());
	double dWidthPl;
	ElemZone eZoneBatten = el.zone(nBattenZone);
	double dWidthZoneBatten=eZoneBatten.dVar("width");;// width for battens
	
	if(nBatten==3 || nBatten==4)
	{ 
		// HSB-22709: As beam: get the batten
		Sheet sheetsBatten[]=el.sheet(nBattenZone);
		
		double dWidthZone = eZoneBatten.dVar("width");
		double dWidthBeam=el.dBeamHeight();// use this instead of dWidthZone
		bAsBeam=true;
		dWidthPl=2*dWidthBeam+dVentW;
		plAsBeam.createRectangle(LineSeg(ptInsert-.5*dWidthPl*csEl.vecX()-.5*dWidthPl*csEl.vecY(),
			ptInsert+.5*dWidthPl*csEl.vecX()+.5*dWidthPl*csEl.vecY()),csEl.vecX(),csEl.vecY());
		plAsBeam.vis(3);// use this only for zone -2
		if(nType==0)
		{ 
			// rectangle
			plAsBeam.createRectangle(LineSeg(ptInsert-.5*dWidthPl*csEl.vecX()-.5*(dVentH+2*dWidthBeam)*csEl.vecY(),
			ptInsert+.5*dWidthPl*csEl.vecX()+.5*(dVentH+2*dWidthBeam)*csEl.vecY()),csEl.vecX(),csEl.vecY());
		}
		if(nBatten==4)
		{ 
			// HSB-22709 v2.30
			bAsBeamSolidRoundings=true;
		}
	}
	if(_bOnDbCreated || !nFreeze || _bOnDebug)
	{ 
		// HSB-22709: delete beams at other zones
		Entity entsBeamsSheeting[]=_Map.getEntityArray("BeamsSheeting[]", "BeamsSheeting[]", "BeamsSheeting[]");
		for (int i=entsBeamsSheeting.length()-1; i>=0 ; i--) 
		{ 
			entsBeamsSheeting[i].dbErase();
		}//next i
		_Map.removeAt("BeamsSheeting[]",false);
		// delete beams at battens
		// bmBattenLeft, bmBattenRight, bmBattenAbove, bmBattenBelow
		String sKeysBatten[]={"bmBattenLeft","bmBattenRight",
		"bmBattenLeftTop","bmBattenLeftBottom","bmBattenRightTop","bmBattenRightBottom",
		"bmBattenAbove","bmBattenBelow",
		"bmBattenAboveLeft","bmBattenAboveRight","bmBattenBelowLeft","bmBattenBelowRight"};
		for (int s=0;s<sKeysBatten.length();s++) 
		{ 
			if (_Map.hasEntity(sKeysBatten[s])) 
			{
				Entity ent = _Map.getEntity(sKeysBatten[s]);
				ent.dbErase();
			}
		}//next s
	}
	for (int i=0;i<nZones.length();i++)
	{
		int nThisZone = nZones[i];
		if (nThisZone == 0)continue;
		Sheet shInZone[] = el.sheet(nThisZone);
		
		if (shInZone.length() == 0 && nThisZone!=nBattenZone)continue;
		
		PLine plTool(csEl.vecZ());
		int bZoneBeforeBatten;
		if (nType == 0) //Rectangular
		{
			plTool = pl;
		}
		else //Round
		{
			if (dVentW > dVentH)
			{
				if (dDiameter1 > dVentH)
				{
					dDiameter1.set(dVentH);
				}
			}
			else
			{
				if (dDiameter1 > dVentW)
				{
					dDiameter1.set(dVentW);
				}
			}
			plTool.createCircle(lsForMidPoint.ptMid(), el.vecZ(), dDiameter1 * 0.5);
		}
		if(bAsBeam )
		{
			// HSB-22709
			if(nBattenZone<0 && nThisZone==(1+nBattenZone))
			{
				plTool=plAsBeam;
				bZoneBeforeBatten=true;
			}
			if(nBattenZone>0 && nThisZone==(nBattenZone-1))
			{
				plTool=plAsBeam;
				bZoneBeforeBatten=true;
			}
		}
		Body bdCut(plTool, U(1000)*csEl.vecZ(),0);
		int nNrOfSheetsInvolved = 0;
		Sheet arShCut[0];
		for (int j = 0; j < shInZone.length(); j++)
		{
			Body bdTmp = bdCut;
			if ( bdTmp.intersectWith(Body(shInZone[j].envelopeBody())) )
			{
				nNrOfSheetsInvolved++;
				arShCut.append(shInZone[j]);
			}
		}
		if(!_bOnDebug)
		if (nNrOfSheetsInvolved > 0)
		{
			ElemMill elMill(nThisZone, plTool, el.zone(nThisZone).dH(), nToolingIndex, _kLeft, nTurn, nOShoot);
			elMill.setVacuum(nVacuum);
			el.addTool(elMill);
			SolidSubtract ss(bdCut);
			int nSheets = ss.addMeToGenBeamsIntersect(arShCut);
			for (int k = 0; k < arShCut.length(); k++)
			{
				setDependencyOnEntity(arShCut[k]);
			}
		}
		if(bAsBeam && (_bOnDbCreated || !nFreeze || _bOnDebug) )
		{ 
			// HSB-22709
			if(bZoneBeforeBatten)
			{ 
				// the zone before the batten zone
				if (nType == 1 && false)
				{ 
					// round
					// for rounds dont create anymore the beam with drill
					// create the 4 beams just like at rectangle
					// create beam with opening at sheet
					ElemZone eZone=el.zone(nThisZone);
					Point3d ptBm=ptInsert;ptBm+=eZone.vecZ()*eZone.vecZ().dotProduct(eZone.ptOrg()-ptBm);
					
					Vector3d vxBm=el.vecX();
					Vector3d vyBm=eZone.vecZ();
					Vector3d vzBm=vxBm.crossProduct(vyBm);vzBm.normalize();
					Beam bmNew;
					bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, 
						dWidthPl, eZone.dH(),dWidthPl, 0, 1, 0);
					bmNew.setColor(eZoneBatten.color());
					bmNew.setType(_kBatten);
					bmNew.setMaterial(eZoneBatten.material());
					bmNew.assignToElementGroup(el, TRUE, nBattenZone, 'Z');
					// add drill
					Drill dr(ptInsert-eZone.vecZ()*U(10e3),ptInsert+eZone.vecZ()*U(10e3),
						.5*dDiameter1);
					bmNew.addToolStatic(dr);
					beamsSheeting.append(bmNew);
					if(bAsBeamSolidRoundings)
					{ 
						// HSB-22709 v2.30 create beam in batten zone
						Point3d ptBm2=ptBm;
						ptBm2+=el.vecZ()*el.vecZ().dotProduct(el.zone(nBattenZone).ptOrg()-ptBm);
						
						Beam bmNew2;
						bmNew2.dbCreate(ptBm2, vxBm, vyBm, vzBm, 
							dWidthPl, eZoneBatten.dH(),dWidthPl, 0, 1, 0);
						bmNew2.setColor(eZoneBatten.color());
						bmNew2.setType(_kBatten);
						bmNew2.setMaterial(eZoneBatten.material());
						bmNew2.assignToElementGroup(el, TRUE, nBattenZone, 'Z');
						// add drill
						Drill dr(ptInsert-eZone.vecZ()*U(10e3),ptInsert+eZone.vecZ()*U(10e3),
							.5*dDiameter1);
						bmNew2.addToolStatic(dr);
						beamsSheeting.append(bmNew2);
					}
				}
				else if(nType==0 || nType==1)
				{ 
					// rectangular shape
					// create 4 surrounding beams
//					double dWidthBeam=dWidthZoneBatten;
					// 20251127: create beams with width of zone 0
					double dWidthBeam=el.dBeamHeight();
					dWidthPl=2*dWidthBeam+dVentW;
					ElemZone eZone=el.zone(nThisZone);
					Point3d ptBm=ptInsert;ptBm+=eZone.vecZ()*eZone.vecZ().dotProduct(eZone.ptOrg()-ptBm);
					
					// left
					ptBm-=.5*dWidthPl*el.vecX();
//					
					
					Vector3d vzBm=el.vecX();// height
					Vector3d vyBm=eZone.vecZ();// width (thickness of zone)
					Vector3d vxBm=vyBm.crossProduct(vzBm);vxBm.normalize();
					double dLbeam=nType==1?dWidthPl:dVentH+2*dWidthBeam;
					
					Beam bmNew;
					bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, 
						dLbeam, eZone.dH(),dWidthBeam, 0, 1, 1);
					
					bmNew.setColor(eZoneBatten.color());
					bmNew.setType(_kBatten);
					bmNew.setMaterial(eZoneBatten.material());
					bmNew.assignToElementGroup(el, TRUE, nBattenZone, 'Z');
					beamsSheeting.append(bmNew);
					// right
					Beam bmNew2=bmNew.dbCopy();
					bmNew2.transformBy(el.vecX()*(dWidthPl-dWidthBeam));
					beamsSheeting.append(bmNew2);
					// top
					if(nType==1)
					{
						// round
						ptBm+=.5*dWidthPl*el.vecX()+.5*dWidthPl*el.vecY();
					}
					else if(nType==0)
					{ 
						ptBm+=.5*dWidthPl*el.vecX()+.5*(dVentH+2*dWidthBeam)*el.vecY();
					}
					
					vzBm=el.vecY();// height
					vyBm=eZone.vecZ();// width (thickness of zone)
					vxBm=vyBm.crossProduct(vzBm);vxBm.normalize();
					
					bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, 
						dWidthPl-2*dWidthBeam, eZone.dH(),dWidthBeam, 0, 1, -1);
					
					bmNew.setColor(eZoneBatten.color());
					bmNew.setType(_kBatten);
					bmNew.setMaterial(eZoneBatten.material());
					bmNew.assignToElementGroup(el, TRUE, nBattenZone, 'Z');
					beamsSheeting.append(bmNew);
					
					Beam bmNew3=bmNew.dbCopy();
					if(nType==1)
					{
						bmNew3.transformBy(-el.vecY()*(dWidthPl-dWidthBeam));
					}
					else if(nType==0)
					{ 
						bmNew3.transformBy(-el.vecY()*(dVentH+dWidthBeam));
					}
					beamsSheeting.append(bmNew3);
				}
			}
			else if(nThisZone==nBattenZone)
			{ 
				// batten zone
				// check if battens are sheets or beams
				Sheet sheetsBatten[]=el.sheet(nThisZone);
				if(sheetsBatten.length()>0)
				{ 
					// transform sheets to beams
					for (int s=0;s<sheetsBatten.length();s++) 
					{ 
						Sheet sheet=sheetsBatten[s];
						Beam bmNew =createBeamFromSheet(sheet);
					}//next s
					// cleanup sheets
					for (int i=sheetsBatten.length()-1; i>=0 ; i--) 
					{ 
						sheetsBatten[i].dbErase();;
					}//next i
				}
				
				GenBeam genBeamsBatten[]=el.genBeam(nThisZone);
				Beam beamsBatten[0];
				for (int g=0;g<genBeamsBatten.length();g++) 
				{ 
					Beam bm=(Beam) genBeamsBatten[g];
					if(bm.bIsValid())
					{ 
						beamsBatten.append(bm);
					}
				}//next g
				
				//Do not stretch; Stretch left; Stretch right;Stretch both
				// get left, right, top, bottom beams
				Beam bmBattenLeft, bmBattenRight, bmBattenAbove,bmBattenBelow;
				
				Point3d ptLook=ptInsert;
				Point3d ptZoneMiddle=.5*(eZoneBatten.ptOrg()+eZoneBatten.ptOrg()+eZoneBatten.vecZ()*eZoneBatten.dH());
				ptZoneMiddle.vis(1);
				ptLook+=eZoneBatten.vecZ()*eZoneBatten.vecZ().dotProduct(ptZoneMiddle-ptLook);
				ptLook.vis(3);
				// HSB-22709: v2.30
				Beam beamsBattenVert[]=csEl.vecX().filterBeamsPerpendicularSort(beamsBatten);
				Beam beamsBattenHor[]=csEl.vecY().filterBeamsPerpendicularSort(beamsBatten);
				
				Beam beamsLeft[]=Beam().filterBeamsHalfLineIntersectSort(beamsBattenVert,ptLook,-csEl.vecX());
				if(beamsLeft.length()>0)
				{ 
					bmBattenLeft=beamsLeft.first();
					if(csEl.vecX().dotProduct(_Pt0-bmBattenLeft.ptCen())<.5*dWidthPl)
					{ 
						if(beamsLeft.length()>1)
						{ 
							bmBattenLeft=beamsLeft[1];
						}
					}
				}
				Beam beamsRight[]=Beam().filterBeamsHalfLineIntersectSort(beamsBattenVert,ptLook,csEl.vecX());
				if(beamsRight.length()>0)
				{ 
					bmBattenRight=beamsRight.first();
					if(csEl.vecX().dotProduct(bmBattenRight.ptCen()-_Pt0)<.5*dWidthPl)
					{ 
						if(beamsRight.length()>1)
						{ 
							bmBattenRight=beamsRight[1];
						}
					}
				}
				Point3d ptLookAboveBelow=ptLook;
				if(nType==1 && bAsBeamSolidRoundings)
				{ 
					ptLookAboveBelow=ptLook+csEl.vecY()*(.5*dWidthPl+U(5));
				}
				Beam beamsAbove[]=Beam().filterBeamsHalfLineIntersectSort(beamsBattenHor,ptLookAboveBelow,csEl.vecY());
				if(beamsAbove.length()>0)
				{ 
					bmBattenAbove=beamsAbove.first();
				}
				if(nType==1 && bAsBeamSolidRoundings)
				{ 
					ptLookAboveBelow=ptLook-csEl.vecY()*(.5*dWidthPl+U(5));
				}
				Beam beamsBelow[]=Beam().filterBeamsHalfLineIntersectSort(beamsBattenHor,ptLookAboveBelow,-csEl.vecY());
				if(beamsBelow.length()>0)
				{ 
					bmBattenBelow=beamsBelow.first();
				}
				if(bmBattenLeft.bIsValid() && bmBattenRight.bIsValid()
				&& bmBattenAbove.bIsValid() && bmBattenBelow.bIsValid())
				{ 
					Beam bmLeft=bmBattenLeft;
					Beam bmRight=bmBattenRight;
					Beam bmAbove=bmBattenAbove;
					Beam bmBelow=bmBattenBelow;
					// all 4 battens found
					if(nStretchOption==1 || nStretchOption==3)
					{ 
						// left or both stretch vertical
						// create left
						if(!(nType==1 && bAsBeamSolidRoundings))
						{ 
							// not rounding and as beam solid
							Point3d ptBm=ptLook-el.vecX()*.5*dVentW;
							
							Vector3d vyBm=eZoneBatten.vecZ();// 
							Vector3d vzBm=el.vecX();
							Vector3d vxBm=vyBm.crossProduct(vzBm);vxBm.normalize();
							Beam bmNew;
							bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, 
								U(10), eZoneBatten.dH(),dWidthZoneBatten, 0, 0, -1);
							bmNew.stretchDynamicTo(bmAbove);
							bmNew.stretchDynamicTo(bmBelow);
							bmNew.setColor(eZoneBatten.color());
							bmNew.setType(_kBatten);
							bmNew.setMaterial(eZoneBatten.material());
							bmNew.assignToElementGroup(el, TRUE, nBattenZone, 'Z');
							bmLeft=bmNew;
							_Map.setEntity("bmBattenLeft",bmNew);
						}
						else if(nType==1 && bAsBeamSolidRoundings)
						{ 
							// HSB-22709 v2.30 round with solid
							Point3d ptBm=ptLook-el.vecX()*.5*dVentW;
							ptBm+=csEl.vecY()*(.5*dWidthPl+U(5));
							ptBm.vis(3);
							Vector3d vyBm=eZoneBatten.vecZ();// 
							Vector3d vzBm=el.vecX();
							Vector3d vxBm=vyBm.crossProduct(vzBm);vxBm.normalize();
							Beam bmNew;
							bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, 
								U(10), eZoneBatten.dH(),dWidthZoneBatten, 0, 0, -1);
							bmNew.stretchDynamicTo(bmAbove);
//							bmNew.stretchDynamicTo(bmBelow);
							bmNew.setColor(eZoneBatten.color());
							bmNew.setType(_kBatten);
							bmNew.setMaterial(eZoneBatten.material());
							bmNew.assignToElementGroup(el, TRUE, nBattenZone, 'Z');
							bmLeft=bmNew;
							_Map.setEntity("bmBattenLeftTop",bmNew);
							// 
							ptBm=ptLook-el.vecX()*.5*dVentW;
							ptBm-=csEl.vecY()*(.5*dWidthPl+U(5));
							ptBm.vis(3);
//							Vector3d vyBm=eZoneBatten.vecZ();// 
//							Vector3d vzBm=el.vecX();
//							Vector3d vxBm=vyBm.crossProduct(vzBm);vxBm.normalize();
//							Beam bmNew;
							bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, 
								U(10), eZoneBatten.dH(),dWidthZoneBatten, 0, 0, -1);
//							bmNew.stretchDynamicTo(bmAbove);
							bmNew.stretchDynamicTo(bmBelow);
							bmNew.setColor(eZoneBatten.color());
							bmNew.setType(_kBatten);
							bmNew.setMaterial(eZoneBatten.material());
							bmNew.assignToElementGroup(el, TRUE, nBattenZone, 'Z');
							bmLeft=bmNew;
							_Map.setEntity("bmBattenLeftBottom",bmNew);
						}
					}
					if(nStretchOption==2 || nStretchOption==3)
					{ 
						// right or both stretch vertical
						// create right
						if(!(nType==1 && bAsBeamSolidRoundings))
						{ 
							// not rounding and as beam solid
							Point3d ptBm=ptLook+el.vecX()*.5*dVentW;
							
							Vector3d vyBm=eZoneBatten.vecZ();// 
							Vector3d vzBm=el.vecX();
							Vector3d vxBm=vyBm.crossProduct(vzBm);vxBm.normalize();
							Beam bmNew;
							bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, 
								U(10), eZoneBatten.dH(),dWidthZoneBatten, 0, 0, 1);
							bmNew.stretchDynamicTo(bmAbove);
							bmNew.stretchDynamicTo(bmBelow);
							bmNew.setColor(eZoneBatten.color());
							bmNew.setType(_kBatten);
							bmNew.setMaterial(eZoneBatten.material());
							bmNew.assignToElementGroup(el, TRUE, nBattenZone, 'Z');
							bmRight=bmNew;
							_Map.setEntity("bmBattenRight",bmNew);
						}
						else if(nType==1 && bAsBeamSolidRoundings)
						{ 
							// HSB-22709 v2.30 round with solid
							Point3d ptBm=ptLook+el.vecX()*.5*dVentW;
							ptBm+=csEl.vecY()*(.5*dWidthPl+U(5));
							ptBm.vis(3);
							Vector3d vyBm=eZoneBatten.vecZ();// 
							Vector3d vzBm=el.vecX();
							Vector3d vxBm=vyBm.crossProduct(vzBm);vxBm.normalize();
							Beam bmNew;
							bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, 
								U(10), eZoneBatten.dH(),dWidthZoneBatten, 0, 0, 1);
							bmNew.stretchDynamicTo(bmAbove);
//							bmNew.stretchDynamicTo(bmBelow);
							bmNew.setColor(eZoneBatten.color());
							bmNew.setType(_kBatten);
							bmNew.setMaterial(eZoneBatten.material());
							bmNew.assignToElementGroup(el, TRUE, nBattenZone, 'Z');
							bmRight=bmNew;
							_Map.setEntity("bmBattenRightTop",bmNew);
							// 
							ptBm=ptLook+el.vecX()*.5*dVentW;
							ptBm-=csEl.vecY()*(.5*dWidthPl+U(5));
							ptBm.vis(3);
//							Vector3d vyBm=eZoneBatten.vecZ();// 
//							Vector3d vzBm=el.vecX();
//							Vector3d vxBm=vyBm.crossProduct(vzBm);vxBm.normalize();
//							Beam bmNew;
							bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, 
								U(10), eZoneBatten.dH(),dWidthZoneBatten, 0, 0, 1);
//							bmNew.stretchDynamicTo(bmAbove);
							bmNew.stretchDynamicTo(bmBelow);
							bmNew.setColor(eZoneBatten.color());
							bmNew.setType(_kBatten);
							bmNew.setMaterial(eZoneBatten.material());
							bmNew.assignToElementGroup(el, TRUE, nBattenZone, 'Z');
							bmRight=bmNew;
							_Map.setEntity("bmBattenRightBottom",bmNew);
						}
					}
					// top and bottom
					if(nType==1 && bAsBeamSolidRoundings)
					{ 
						// HSB-22709 v2.30 round with solid beam
						if(!(nStretchOption==1 || nStretchOption==3))
						{ 
							// no vertical batten on the left
							// stretch horizontals
							Point3d ptBm=ptLook+el.vecY()*(.5*dVentW+.5*dWidthZoneBatten)-csEl.vecX()*(.5*dWidthPl+U(5));
							Vector3d vyBm=eZoneBatten.vecZ();// 
							Vector3d vzBm=el.vecY();
							Vector3d vxBm=vyBm.crossProduct(vzBm);vxBm.normalize();
							Beam bmNew;
							bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, 
								U(10), eZoneBatten.dH(),dWidthZoneBatten, 0, 0, 0);
							bmNew.stretchDynamicTo(bmLeft);
							bmNew.setColor(eZoneBatten.color());
							bmNew.setType(_kBatten);
							bmNew.setMaterial(eZoneBatten.material());
							bmNew.assignToElementGroup(el, TRUE, nBattenZone, 'Z');
							_Map.setEntity("bmBattenAboveLeft",bmNew);
							Beam bmNew2=bmNew.dbCopy();
							bmNew2.transformBy(-csEl.vecY()*(dVentW+dWidthZoneBatten));
//							bmBelow=bmNew2;
							_Map.setEntity("bmBattenBelowLeft",bmNew2);
						}
						if(!(nStretchOption==2 || nStretchOption==3))
						{ 
							// no vertical batten on the right 
							// create horizontal left and right
							Point3d ptBm=ptLook+el.vecY()*(.5*dVentW+.5*dWidthZoneBatten)+csEl.vecX()*(.5*dWidthPl+U(5));
							Vector3d vyBm=eZoneBatten.vecZ();// 
							Vector3d vzBm=el.vecY();
							Vector3d vxBm=vyBm.crossProduct(vzBm);vxBm.normalize();
							Beam bmNew;
							bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, 
								U(10), eZoneBatten.dH(),dWidthZoneBatten, 0, 0, 0);
							bmNew.stretchDynamicTo(bmRight);
							bmNew.setColor(eZoneBatten.color());
							bmNew.setType(_kBatten);
							bmNew.setMaterial(eZoneBatten.material());
							bmNew.assignToElementGroup(el, TRUE, nBattenZone, 'Z');
							_Map.setEntity("bmBattenAboveRight",bmNew);
							Beam bmNew2=bmNew.dbCopy();
							bmNew2.transformBy(-csEl.vecY()*(dVentW+dWidthZoneBatten));
//							bmBelow=bmNew2;
							_Map.setEntity("bmBattenBelowRight",bmNew2);
						}
					}
					else if(!(nType==1 && bAsBeamSolidRoundings))
					{ 
						// not round with solid
						Point3d ptBm;
						if(nType==1)
						{
							// round
							ptBm=ptLook+el.vecY()*(.5*dVentW+.5*dWidthZoneBatten);
						}
						else if(nType==0)
						{
							// rectangle
							ptBm=ptLook+el.vecY()*(.5*dVentH+.5*dWidthZoneBatten);
						}
						ptBm.vis(2);
						Vector3d vyBm=eZoneBatten.vecZ();// 
						Vector3d vzBm=el.vecY();
						Vector3d vxBm=vyBm.crossProduct(vzBm);vxBm.normalize();
						Beam bmNew;
						bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, 
							U(10), eZoneBatten.dH(),dWidthZoneBatten, 0, 0, 0);
						bmLeft.envelopeBody().vis(6);
						bmNew.stretchDynamicTo(bmLeft);
						bmNew.stretchDynamicTo(bmRight);
						bmNew.setColor(eZoneBatten.color());
						bmNew.setType(_kBatten);
						bmNew.setMaterial(eZoneBatten.material());
						bmNew.assignToElementGroup(el, TRUE, nBattenZone, 'Z');
						_Map.setEntity("bmBattenAbove",bmNew);
						bmAbove=bmNew;
						Beam bmNew2=bmNew.dbCopy();
						if(nType==1)
						{
							// round
							bmNew2.transformBy(-csEl.vecY()*(dVentW+dWidthZoneBatten));
						}
						else if(nType==0)
						{ 
							// rectangular
							bmNew2.transformBy(-csEl.vecY()*(dVentH+dWidthZoneBatten));
						}
						bmBelow=bmNew2;
						_Map.setEntity("bmBattenBelow",bmNew2);
						
						
						// check vertical battens that fall inside the vent
						// and need to be split
						Beam bmBattenSplit;
						
						for (int b=0;b<beamsBattenVert.length();b++) 
						{ 
							Beam bmB=beamsBatten[b];
							if(csEl.vecX().dotProduct(_Pt0-bmB.ptCen())<.5*dWidthPl
							&& csEl.vecX().dotProduct(bmB.ptCen()-_Pt0)<.5*dWidthPl)
							{ 
								// split
								bmBattenSplit=bmB;
								break;
							}
						}//next b
						if(bmBattenSplit.bIsValid())
						{ 
							Point3d ptSplitT=bmAbove.ptCen()+bmAbove.vecD(csEl.vecY())*.5*bmAbove.dD(csEl.vecY());
							Point3d ptSplitB=bmBelow.ptCen()-bmBelow.vecD(csEl.vecY())*.5*bmBelow.dD(csEl.vecY());
							Beam bmBattenSplit2=bmBattenSplit.dbSplit(ptSplitT,ptSplitB);
							
							_Map.setEntity("bmToSplitBatten",bmBattenSplit);
							_Map.setEntity("bmSplittedBatten",bmBattenSplit2);
						}
						
						
						if(!(nStretchOption==1 || nStretchOption==3))
						{ 
							// left 
							Point3d ptBm=ptLook-el.vecX()*.5*dVentW;
							
							Vector3d vyBm=eZoneBatten.vecZ();// 
							Vector3d vzBm=el.vecX();
							Vector3d vxBm=vyBm.crossProduct(vzBm);vxBm.normalize();
							Beam bmNew;
							bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, 
								U(10), eZoneBatten.dH(),dWidthZoneBatten, 0, 0, -1);
							bmNew.stretchDynamicTo(bmAbove);
							bmNew.stretchDynamicTo(bmBelow);
							bmNew.setColor(eZoneBatten.color());
							bmNew.setType(_kBatten);
							bmNew.setMaterial(eZoneBatten.material());
							bmNew.assignToElementGroup(el, TRUE, nBattenZone, 'Z');
							bmLeft=bmNew;
							_Map.setEntity("bmBattenLeft",bmNew);
						}
						if(!(nStretchOption==2 || nStretchOption==3))
						{ 
							// right or both
							// create right
							Point3d ptBm=ptLook+el.vecX()*.5*dVentW;
							
							Vector3d vyBm=eZoneBatten.vecZ();// 
							Vector3d vzBm=el.vecX();
							Vector3d vxBm=vyBm.crossProduct(vzBm);vxBm.normalize();
							Beam bmNew;
							bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, 
								U(10), eZoneBatten.dH(),dWidthZoneBatten, 0, 0, 1);
							bmNew.stretchDynamicTo(bmAbove);
							bmNew.stretchDynamicTo(bmBelow);
							bmNew.setColor(eZoneBatten.color());
							bmNew.setType(_kBatten);
							bmNew.setMaterial(eZoneBatten.material());
							bmNew.assignToElementGroup(el, TRUE, nBattenZone, 'Z');
							bmRight=bmNew;
							_Map.setEntity("bmBattenRight",bmNew);
						}
					}
				}
			}
		}
	}
	if(beamsSheeting.length()>0)
	{ 
		_Map.setEntityArray(beamsSheeting,false,
			"BeamsSheeting[]","BeamsSheeting[]","BeamsSheeting[]");
	}
}
//return;
PLine plOut=el.plOutlineWall();
Point3d ptAround[]=plOut.vertexPoints(TRUE);
Line lnOrigin(el.ptOrg(), -el.vecZ());
ptAround=lnOrigin.projectPoints(ptAround);
ptAround=lnOrigin.orderPoints(ptAround);
double dWidth=(ptAround[0]-ptAround[ptAround.length()-1]).length();
Plane plFront (ptAround[0], el.vecZ());


//Place cross in opening
PLine plCross1(csEl.vecZ());
plCross1.addVertex(ptUppL.projectPoint(plFront, 0));
plCross1.addVertex(ptLowR.projectPoint(plFront, 0));
PLine plCross2(csEl.vecZ());
plCross2.addVertex(ptUppR.projectPoint(plFront, 0));
plCross2.addVertex(ptLowL.projectPoint(plFront, 0));

Display dp(-1);
dp.color(3);
if (sDispRep!="")
	dp.showInDispRep(sDispRep);
	
PLine plDisplay=pl;
plDisplay.projectPointsToPlane(plFront, el.vecZ());
dp.draw(plDisplay);
dp.draw(plCross1);
dp.draw(plCross2);

el.ptOrg().vis();
//ptLowR.vis();
//Display for top view
PLine plY(csEl.vecZ());
plY.addVertex(ptLowR.projectPoint(plFront, 0));
plY.addVertex(ptLowL.projectPoint(plFront, 0));
plY.addVertex(ptLowL-csEl.vecZ()*U(abs(el.dPosZOutlineBack())));
plY.addVertex(ptLowR-csEl.vecZ()*U(abs(el.dPosZOutlineBack())));
plY.close();

PLine plCrossY1(csEl.vecY());
plCrossY1.addVertex(ptLowR.projectPoint(plFront, 0));
plCrossY1.addVertex(ptLowL-csEl.vecZ()*U(abs(el.dPosZOutlineBack())));
PLine plCrossY2(csEl.vecY());
plCrossY2.addVertex(ptLowL.projectPoint(plFront, 0));
plCrossY2.addVertex(ptLowR-csEl.vecZ()*U(abs(el.dPosZOutlineBack())));

dp.draw(plCrossY1);
dp.draw(plCrossY2);
dp.draw(plY);

if(nExclusionZone)
{ 
	Display dp1(3);
	PLine plCircle(csEl.vecZ());
	plCircle.createCircle(ptInsert, csEl.vecZ(), dDiameterExlusionZone + (dDiameter1 * 0.5));
	dp1.addViewDirection(csEl.vecZ());
	dp1.addViewDirection(-csEl.vecZ());
	dp1.draw(plCircle);
}


//region Parse text and display if found
//region Collect list of available object variables and append properties which are unsupported by formatObject (yet)
	Entity ents[] ={ _ThisInst};
	String sObjectVariables[] = _ThisInst.formatObjectVariables();

//region Add custom variables for format resolving
	// adding custom variables or variables which are currently not supported by core
	String sCustomVariables[] ={};
	for (int i=0;i<sCustomVariables.length();i++)
	{ 
		String k = sCustomVariables[i];
		if (sObjectVariables.find(k) < 0)
			sObjectVariables.append(k);
	}	
	
// get translated list of variables
	String sTranslatedVariables[0];
	for (int i=0;i<sObjectVariables.length();i++) 
		sTranslatedVariables.append(T("|"+sObjectVariables[i]+"|")); 
	
// order both arrays alphabetically
	for (int i=0;i<sTranslatedVariables.length();i++) 
		for (int j=0;j<sTranslatedVariables.length()-1;j++) 
			if (sTranslatedVariables[j]>sTranslatedVariables[j+1])
			{
				sObjectVariables.swap(j, j + 1);
				sTranslatedVariables.swap(j, j + 1);
			}			
//End add custom variables//endregion 
//End get list of available object variables//endregion 

//region Trigger AddRemoveFormat
	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
	addRecalcTrigger(_kContext, "../"+sTriggerAddRemoveFormat );
	if (_bOnRecalc && (_kExecuteKey=="../"+sTriggerAddRemoveFormat || _kExecuteKey==sTriggerAddRemoveFormat))
	{
		String sPrompt;
//		if (bHasSDV && entsDefineSet.length()<1)
//			sPrompt += "\n" + T("|NOTE: During a block setup only limited properties are accesable, but you can enter \nany valid format expression or use custom catalog entries.|");
		sPrompt+="\n"+ scriptName() +" "+ T("|Select a property by index to add or to remove|") + T(" ,|-1 = Exit|");
		reportNotice(sPrompt);
		
		for (int s=0;s<sObjectVariables.length();s++) 
		{ 
			String key ="@(" +sObjectVariables[s]+ ")"; 
			String keyT = sTranslatedVariables[s];
			String sValue;
			for (int j=0;j<ents.length();j++) 
			{ 
				String _value = ents[j].formatObject(key);
				if (_value.length()>0)
				{ 
					sValue = _value;
					break;
				}
			}//next j

			//String sSelection= sFormat.find(key,0, false)<0?"" : T(", |is selected|");
			String sAddRemove = sFormat.find(key,0, false)<0?"   " : "√";
			int x = s + 1;
			String sIndex = ((x<10)?"    " + x:"  " + x)+ "  "+sAddRemove+"   ";//
			
			reportNotice("\n"+ scriptName()+" " +sIndex+keyT + "........: "+ sValue);
			
		}//next i
		int nRetVal = getInt(sPrompt)-1;
				
	// select property	
		while (nRetVal>-1)
		{ 
			if (nRetVal>-1 && nRetVal<=sObjectVariables.length())
			{ 
				String newAttrribute = sFormat;
	
			// get variable	and append if not already in list	
				String var ="@(" + sObjectVariables[nRetVal] + ")";
				int x = sFormat.find(var, 0);
				if (x>-1)
				{
					int y = sFormat.find(")", x);
					String left = sFormat.left(x);
					String right= sFormat.right(sFormat.length()-y-1);
					newAttrribute = left + right;
					reportMessage("\n" + sObjectVariables[nRetVal] + " new: " + newAttrribute);				
				}
				else
				{ 
					newAttrribute+="@(" +sObjectVariables[nRetVal]+")";
								
				}
				sFormat.set(newAttrribute);
				reportMessage("\n" + sFormatName + " " + T("|set to|")+" " +sFormat);	
			}
			nRetVal = getInt(sPrompt)-1;
		}
	
		setExecutionLoops(2);
		return;
	}	
	
	
//endregion 

//region Resolve format by entity
	String text;// = "R" + dDiameter * .5;
	if (sFormat.length()>0)
	{ 
		String sLines[0];// store the resolved variables by line (if \P was found)	
		String sValues[0];	
		String sValue=  _ThisInst.formatObject(sFormat);
	
	// parse for any \P (new line)
		int left= sValue.find("\\P",0);
		while(left>-1)
		{
			sValues.append(sValue.left(left));
			sValue = sValue.right(sValue.length() - 2-left);
			left= sValue.find("\\P",0);
		}
		sValues.append(sValue);	
	
	// resolve unknown variables
		for (int v= 0; v < sValues.length(); v++)
		{
			String& value = sValues[v];
			int left = value.find("@(", 0);
			
		// get formatVariables and prefixes
			if (left>-1)
			{ 
				// tokenize does not work for strings like '(@(KEY))'
				String sTokens[0];
				while (value.length() > 0)
				{
					left = value.find("@(", 0);
					int right = value.find(")", left);
					
				// key found at first location	
					if (left == 0 && right > 0)
					{
						String sVariable = value.left(right + 1);

						String s;
						// add resolving of custom variables
//						if (sVariable.find("@("+sCustomVariables[0]+")",0,false)>-1)
//						{
//							s.formatUnit(dDiameter*.5,_kLength);
//							sTokens.append(s);
//						}
//
						value = value.right(value.length() - right - 1);
					}
				// any text inbetween two variables	
					else if (left > 0 && right > 0)
					{
						sTokens.append(value.left(left));
						value = value.right(value.length() - left);
					}
				// any postfix text
					else
					{
						sTokens.append(value);
						value = "";
					}
				}
//	
				for (int j=0;j<sTokens.length();j++) 
					value+= sTokens[j]; 
			}
//			//sAppendix += value;
			sLines.append(value);
		}	
//		
	// text out
		for (int j=0;j<sLines.length();j++) 
		{ 
			text += sLines[j];
			if (j < sLines.length() - 1)text += "\\P";		 
		}//next j
	}
//		
//End Resolve format by entity//endregion 



//End Parse text and display if found//endregion 

dp.dimStyle(sDimStyle);
String str = sFormat;
Point3d pt = ptLowL-csEl.vecZ()*U(abs(el.dPosZOutlineBack()));
Vector3d vecRead = csEl.vecX();
Vector3d vecUp = csEl.vecZ();
dp.draw(text, pt, vecRead, - vecUp, 1, 2 );


// publish pl to map Thorsten Huck 061109
_Map.setPLine("noinsulation", pl);


// ***
// Start find beams in and closest to the opening.
// Step through the horzontal beams of the element.
// When the beam crosses the opening; add it to the array of beams that need to be split.
// When the does not cross the opening, check if it is the closest beam on the top or bottom side of the opening.
// ***
Beam bmTop;
Beam bmBottom;
Beam bmClAbove;
Beam bmClBelow;
Beam bmToSplitHor[0];
double dClAbove;
double dClBelow;
double dBmMinMax;
double dBmMin;
double dBmMax;

for (int i = 0; i < arBmHor.length(); i++) {
	dBmMinMax = csEl.vecY().dotProduct(arBmHor[i].ptCen() - csEl.ptOrg());
	
	if ( (dBmMinMax < dBmMin) || ( ! bmBottom.bIsValid()) ) {
		dBmMin = dBmMinMax;
		bmBottom = arBmHor[i];
	}
	else if ( (dBmMinMax > dBmMax) || ( ! bmTop.bIsValid()) ) {
		dBmMax = dBmMinMax;
		bmTop = arBmHor[i];
	}
	
	// check the endpoints of the beam in csEl.vecX direction that they are on the opposite side
	// of the center of the opening, otherwise it is not considered
	Point3d ptMinBm = arBmHor[i].ptRef() + arBmHor[i].dLMin() * arBmHor[i].vecX();
	Point3d ptMaxBm = arBmHor[i].ptRef() + arBmHor[i].dLMax() * arBmHor[i].vecX();
	double dBXMin = csEl .vecX().dotProduct(ptMinBm - ptInsert);
	double dBXMax = csEl .vecX().dotProduct(ptMaxBm - ptInsert);
	if ( dBXMin * dBXMax > 0 ) {
		continue;
	}
	
	double dBm = csEl .vecY().dotProduct(arBmHor[i].ptCen() - ptInsert);
	// Check if beam is in opening. If < 0 Then beam is in opening
	if ( (abs(dBm ) - dVentH * 0.5 - arBmHor[i].dD(csEl .vecY()) * 0.5) < 0 ) {
		// the beam is in the Y-range of the opening
		if (arBmHor[i] == bmTop || arBmHor[i] == bmBottom) {
			// beam should not be split
			reportNotice("\n"+ scriptName()+" " +T("Opening has too much overlap with beam. (Max 0.5 * beamheight.)"));
		}
		else {
			bmToSplitHor.append(arBmHor[i]);
		}
	}
	else { //Beam is outside opening
		if (dBm > 0) { //Beam is above the opening
			if ( (dBm < dClAbove || !bmClAbove.bIsValid()) ) {
				dClAbove = dBm;
				bmClAbove = arBmHor[i];
			}
		}
		else if (dBm < 0) { //Beam below the opening
			if ( (dBm < dClBelow || !bmClBelow.bIsValid()) ) {
				dClBelow = dBm;
				bmClBelow = arBmHor[i];
			}
		}
	}
}

// ***
// Start creating beams.
// This part of the script creates the beams around the opening.
// ***
Beam bmResSplitVer;
Beam bmAbove;
Beam bmBelow;
Beam bmStLeft;
Beam bmStRight;

Point3d ptAboveC = ptInsert+(dVentH/2+el.dBeamHeight()/2)*csEl.vecY()-el.dBeamWidth()/2*csEl.vecZ();//ptAboveC.vis();
Point3d ptBelowC = ptInsert-(dVentH/2+el.dBeamHeight()/2)*csEl.vecY()-el.dBeamWidth()/2*csEl.vecZ();//ptBelowC.vis();
Point3d ptLC = ptInsert-(dVentW/2+el.dBeamHeight()/2)*csEl.vecX()-el.dBeamWidth()/2*csEl.vecZ();//ptLC.vis();
Point3d ptRC = ptInsert+(dVentW/2+el.dBeamHeight()/2)*csEl.vecX()-el.dBeamWidth()/2*csEl.vecZ();//ptRC.vis();


// Check if the opening is on the right place and if the beamcodes are valid,
// before start creating beams. 

// Break out of TSL if opening is too close to the side of the element.
if ( ! (bmClLeft.bIsValid() && bmClRight.bIsValid()) ) {
	return;
}
//return;
ElemZone eZoneBatten = el.zone(nBattenZone);
double dWidthZone = eZoneBatten.dVar("width");

Sheet shAbove;
Sheet shBelow;
Sheet shStLeft;
Sheet shStRight;
Sheet shBlocking;
ptAboveC.vis(4);
ptBelowC.vis(4);
ptLC.vis(4);
ptRC.vis(4);
//return;//!!!!!!!!!!!!!!!!!
if (!nFreeze)
{
	// when zone 0 is selected batten option is not active
	if(nBattenZone!=0 && nBatten!=3)
	{ 

		// do not stretch, stretch left, stretch right, stretch both
		
		// split sheet if intersect with vent
		PlaneProfile ppVent(eZoneBatten.coordSys());
		PLine plVent;
		plVent.createRectangle(LineSeg(_Pt0 - csEl.vecX() * .5 * dVentW- csEl.vecY() *.5 * dVentH,
						_Pt0 + csEl.vecX() * .5 * dVentW + csEl.vecY() * .5 * dVentH), csEl.vecX(), csEl.vecY());
		ppVent.joinRing(plVent, _kAdd);
		ppVent.vis(1);
		PLine pline;
		Sheet sheetsZone[] = el.sheet(nBattenZone);
		if(sheetsZone.length()>0)
		{ 
			for (int i=0;i<sheetsZone.length();i++) 
			{ 
				PlaneProfile ppSh(eZoneBatten.coordSys());
				pline = sheetsZone[i].plEnvelope();
				ppSh.joinRing(pline, _kAdd);
//				ppSh.vis(2);
				if(ppSh.intersectWith(ppVent))
				{ 
				// get extents of profile
					LineSeg seg = ppVent.extentInDir(csEl.vecX());
					double dX = abs(csEl.vecX().dotProduct(seg.ptStart()-seg.ptEnd()));
					double dY = abs(csEl.vecY().dotProduct(seg.ptStart()-seg.ptEnd()));
					PLine plVentBig();
					plVentBig.createRectangle(LineSeg(seg.ptMid()-csEl.vecX()*U(10e3)-csEl.vecY()*(.5*dVentH+dWidthZone),
								seg.ptMid() + csEl.vecX() * U(10e3) + csEl.vecY() * (.5*dVentH+dWidthZone)), csEl.vecX(), csEl.vecY());
								pline.vis(6);
							plVentBig.vis(9)	;
					Sheet sheetsNew[] = sheetsZone[i].joinRing(plVentBig, _kSubtract);
					_Map.setEntity("shCutted", sheetsZone[i]);
					_Map.setPLine("pline", pline, _kAbsolute);
					_Map.setEntityArray( sheetsNew, false,"sheetsNew","","");
					sFixed.set(sArNY[1]);
					setExecutionLoops(2);
					break;
				}
			}//next i
		}
		// create battens
		if (nBatten != 0 && nBatten!=3)
		{
			// get all studs of type _kStud
			Beam beamsAll[] = el.beam();
			Beam beamStuds[] = csEl.vecX().filterBeamsPerpendicularSort(beamsAll);
			for (int ib=beamStuds.length()-1; ib>=0 ; ib--) 
			{ 
				if(beamStuds[ib].type()!=_kStud) 
					beamStuds.removeAt(ib);
			}//next ib
			
			// get a batten planeprofile as module, batten behind the stud
			double dHeightBattenModule;
			Point3d ptTopModule, ptBottomModule;
			Sheet sheetsAll[]=el.sheet();
			Sheet sheetsBatten[] = el.sheet(nBattenZone);
			Plane pnZone(el.zone(nBattenZone).coordSys().ptOrg(), el.zone(nBattenZone).coordSys().vecZ());
			PlaneProfile ppBattenModule(pnZone);
			PlaneProfile ppTopModule(pnZone), ppBottomModule(pnZone);
			for (int ib=0;ib<beamStuds.length();ib++) 
			{ 
				PlaneProfile ppI = beamStuds[ib].envelopeBody().shadowProfile(pnZone);
				for (int iSh=0;iSh<sheetsBatten.length();iSh++) 
				{ 
					PLine plI = sheetsBatten[iSh].plEnvelope();
					PlaneProfile ppBattenI(pnZone);
					ppBattenI.joinRing(plI, _kAdd);
					PlaneProfile ppBattenIshrink = ppBattenI;
					ppBattenIshrink.shrink(U(2));
					if(ppBattenIshrink.intersectWith(ppI))
					{ 
						// get extents of profile
						LineSeg seg = ppBattenI.extentInDir(csEl.vecX());
						double dY = abs(csEl.vecY().dotProduct(seg.ptStart()-seg.ptEnd()));
						if(dY>dHeightBattenModule)
						{ 
							dHeightBattenModule = dY;
							ppBattenModule = ppBattenI;
							ptTopModule = seg.ptEnd();
							ptBottomModule = seg.ptStart();
							if(csEl.vecY().dotProduct(ptTopModule-ptBottomModule)<0)
							{ 
								ptTopModule = seg.ptStart();
								ptBottomModule = seg.ptEnd();
							}
						}
					}
				}//next ib
			}//next ib
			PLine plTopModule;
			plTopModule.createRectangle(LineSeg(ptTopModule - csEl.vecX() * U(30000), 
				ptTopModule + csEl.vecX() * U(30000) + csEl.vecY() * U(10000)), csEl.vecX(), csEl.vecY());
			ppTopModule.joinRing(plTopModule, _kAdd);
			PLine plBottomModule;
			plBottomModule.createRectangle(LineSeg(ptBottomModule - csEl.vecX() * U(30000), 
				ptBottomModule + csEl.vecX() * U(30000) - csEl.vecY() * U(10000)), csEl.vecX(), csEl.vecY());
			ppBottomModule.joinRing(plBottomModule, _kAdd);
			ppBattenModule.vis(4);
			
			if(sheetsBatten.length()>0)
			{ 
				PlaneProfile ppSheetsAll(eZoneBatten.coordSys());
				for (int i = 0; i < sheetsBatten.length(); i++)
				{
					PLine plEnvelopeI = sheetsBatten[i].plEnvelope();
					ppSheetsAll.joinRing(plEnvelopeI, _kAdd);
					PLine plOpeningsI[] = sheetsBatten[i].plOpenings();
					for (int iOp = 0; iOp < plOpeningsI.length(); iOp++)
					{
						ppSheetsAll.joinRing(plOpeningsI[iOp], _kSubtract);
					}//next iOp
				}//next i
				
//				ppSheetsAll.vis(5);
				if (nStretchOption == 0 && !nFixed)
				{
					// do not stretch
					PlaneProfile ppSheetBig(eZoneBatten.coordSys());
					PLine plSheetBig(eZoneBatten.vecZ());
					
					// --- above --- 
					Point3d ptAboveCsh = ptAboveC;
					ptAboveCsh += csEl.vecY() * .5 * (dWidthZone - el.dBeamHeight());
					if (nBatten==2)
					{
						// block
						ptAboveCsh += csEl.vecY() * dBattenTolerance;
					}
					plSheetBig.createRectangle(LineSeg(ptAboveCsh - U(10e3) * csEl.vecX() - dWidthZone / 2 * csEl.vecY(),
					ptAboveCsh + U(10e3) * csEl.vecX() + dWidthZone / 2 * csEl.vecY()), csEl.vecX(), csEl.vecY());
					ppSheetBig.joinRing(plSheetBig, _kAdd);
					//	ppSheet.vis(3);
					PlaneProfile ppSheetRemain = ppSheetBig;
					ppSheetRemain.subtractProfile(ppSheetsAll);
					//	ppSheetRemain.vis(3);
					
					PLine pls[] = ppSheetRemain.allRings(true, false);
					PLine plSheet;
					PlaneProfile ppVentBig(eZoneBatten.coordSys());
					PLine plVentBig;
					plVentBig.createRectangle(LineSeg(ptAboveCsh - csEl.vecX() * .5 * dVentW - csEl.vecY() * U(10e3),
					ptAboveCsh + csEl.vecX() * .5 * dVentW + csEl.vecY() * U(10e3)), csEl.vecX(), csEl.vecY());
					ppVentBig.joinRing(plVentBig, _kAdd);
					for (int iPl = 0; iPl < pls.length(); iPl++)
					{
						PlaneProfile pp(eZoneBatten.coordSys());
						pp.joinRing(pls[iPl], _kAdd);
						if (pp.intersectWith(ppVentBig))
						{
							plSheet = pls[iPl];
							break;
						}
					}//next iPl
					
					PlaneProfile ppSheet(eZoneBatten.coordSys());
					ppSheet.joinRing(plSheet, _kAdd);
					
					ppSheet.vis(9);
					if (ppSheet.area() > pow(dEps, 2))
					{
						shAbove.dbCreate(ppSheet, eZoneBatten.dH(), 1);
						shAbove.setColor(eZoneBatten.color());
						shAbove.assignToElementGroup(el, true, nBattenZone, 'Z' );
						_Map.setEntity("shAbove", shAbove);
					}
					// -- below
					Point3d ptBelowCsh = ptBelowC;
					ptBelowCsh += -csEl.vecY() * .5 * (dWidthZone - el.dBeamHeight());
					if (nBatten==2)
					{
						ptBelowCsh += -csEl.vecY() * dBattenTolerance;
					}
					
					plSheetBig.createRectangle(LineSeg(ptBelowCsh - U(10e3) * csEl.vecX() - dWidthZone / 2 * csEl.vecY(),
					ptBelowCsh + U(10e3) * csEl.vecX() + dWidthZone / 2 * csEl.vecY()), csEl.vecX(), csEl.vecY());
					ppSheetBig = PlaneProfile((eZoneBatten.coordSys()));
					ppSheetBig.joinRing(plSheetBig, _kAdd);
					//	ppSheet.vis(3);
					ppSheetRemain = ppSheetBig;
					ppSheetRemain.subtractProfile(ppSheetsAll);
					pls.setLength(0);
					pls = ppSheetRemain.allRings(true, false);
					
					ppVentBig = PlaneProfile(eZoneBatten.coordSys());
					plVentBig.createRectangle(LineSeg(ptBelowCsh - csEl.vecX() * .5 * dVentW - csEl.vecY() * U(10e3),
					ptBelowCsh + csEl.vecX() * .5 * dVentW + csEl.vecY() * U(10e3)), csEl.vecX(), csEl.vecY());
					ppVentBig.joinRing(plVentBig, _kAdd);
					for (int iPl = 0; iPl < pls.length(); iPl++)
					{
						PlaneProfile pp(eZoneBatten.coordSys());
						pp.joinRing(pls[iPl], _kAdd);
						if (pp.intersectWith(ppVentBig))
						{
							plSheet = pls[iPl];
							break;
						}
					}//next iPl
					ppSheet = PlaneProfile(eZoneBatten.coordSys());
					ppSheet.joinRing(plSheet, _kAdd);
					ppSheet.vis(9);
					if (ppSheet.area() > pow(dEps, 2))
					{
						shBelow.dbCreate(ppSheet, eZoneBatten.dH(), 1);
						shBelow.setColor(eZoneBatten.color());
						shBelow.assignToElementGroup(el, true, nBattenZone, 'Z' );
						_Map.setEntity("shBelow", shBelow);
					}
					// 
					if (nBatten==1)
					{
						// studs is selected
						if(nVertical)
						{ 
							// -- Left
							Point3d ptLCsh = ptLC;
							ptLCsh += -csEl.vecX() * .5 * (dWidthZone - el.dBeamHeight());
							ppSheet = PlaneProfile(eZoneBatten.coordSys());
							plSheet = PLine();
							plSheet.createRectangle(LineSeg(ptLCsh - csEl.vecX() * .5 * dWidthZone - csEl.vecY() * dVentH / 2,
							ptLCsh + csEl.vecX() * .5 * dWidthZone + csEl.vecY() * dVentH / 2),
							csEl.vecX(), csEl.vecY());
							ppSheet.joinRing(plSheet, _kAdd);
							ppSheet.vis(6);
							PlaneProfile ppSheetTest = ppSheet;
							ppSheetTest.shrink(dEps);
							
							if (ppSheet.area() > pow(dEps, 2) && !ppSheetTest.intersectWith(ppSheetsAll))
							{
								shStLeft.dbCreate(ppSheet, eZoneBatten.dH(), 1);
								shStLeft.setColor(eZoneBatten.color());
								shStLeft.assignToElementGroup(el, true, nBattenZone, 'Z' );
								_Map.setEntity("shStLeft", shStLeft);
							}
							// -- Right
							Point3d ptRCsh = ptRC;
							ptRCsh += csEl.vecX() * .5 * (dWidthZone - el.dBeamHeight());
							ppSheet = PlaneProfile(eZoneBatten.coordSys());
							plSheet = PLine();
							plSheet.createRectangle(LineSeg(ptRCsh - csEl.vecX() * .5 * dWidthZone - csEl.vecY() * dVentH / 2,
							ptRCsh + csEl.vecX() * .5 * dWidthZone + csEl.vecY() * dVentH / 2),
							csEl.vecX(), csEl.vecY());
							ppSheet.joinRing(plSheet, _kAdd);
							ppSheet.vis(6);
							ppSheetTest = ppSheet;
							ppSheetTest.shrink(dEps);
							
							if (ppSheet.area() > pow(dEps, 2) && !ppSheetTest.intersectWith(ppSheetsAll))
							{
								shStRight.dbCreate(ppSheet, eZoneBatten.dH(), 1);
								shStRight.setColor(eZoneBatten.color());
								shStRight.assignToElementGroup(el, true, nBattenZone, 'Z' );
								_Map.setEntity("shStRight", shStRight);
							}
						}
					}
					if (nBatten==2)
					{
						// blocking is selected
						ppSheet = PlaneProfile(eZoneBatten.coordSys());
						plSheet = PLine();
						Point3d ptCenVent = .5 * (ptBelowCsh + ptAboveCsh);
						plSheet.createRectangle(LineSeg(ptCenVent - csEl.vecX() * (dVentW / 2 + dWidthZone) - csEl.vecY() * (dVentH / 2 + dBattenTolerance),
						ptCenVent + csEl.vecX() * (dVentW / 2 + dWidthZone) + csEl.vecY() * (dVentH / 2 + dBattenTolerance)),
						csEl.vecX(), csEl.vecY());
						ppSheet.joinRing(plSheet, _kAdd);
						ppSheet.vis(6);
						// drill
						Point3d ptDrBatten = ptCenVent;
						ptDrBatten += eZoneBatten.vecZ() * eZoneBatten.vecZ().dotProduct(eZoneBatten.ptOrg() - ptDrBatten);
						Drill drBatten(ptDrBatten, eZoneBatten.vecZ(), eZoneBatten.dH(), .5 * dDiameter1);
						drBatten.cuttingBody().vis(1);
						if (ppSheet.area() > pow(dEps, 2))
						{
							shBlocking.dbCreate(ppSheet, eZoneBatten.dH(), 1);
							shBlocking.setColor(eZoneBatten.color());
							shBlocking.addToolStatic(drBatten);
							shBlocking.assignToElementGroup(el, true, nBattenZone, 'Z' );
							_Map.setEntity("shBlocking", shBlocking);
						}
					}
				}
				else if(nStretchOption==1 && !nFixed)
				{ 
					if (nBatten==1)
					{ 
						// stretch left
						// 
						Point3d ptCenVent = .5 * (ptBelowC + ptAboveC);
						Point3d ptLCsh = ptLC;
						ptLCsh += -csEl.vecX() * .5 * (dWidthZone - el.dBeamHeight());
						PlaneProfile ppSheetBig(eZoneBatten.coordSys());
						PLine plSheetBig(eZoneBatten.vecZ());
						plSheetBig.createRectangle(LineSeg(ptLCsh - csEl.vecX() * .5 * dWidthZone - csEl.vecY() * U(10e3),
								ptLCsh + csEl.vecX() * .5 * dWidthZone + csEl.vecY() * U(10e3)),
									csEl.vecX(), csEl.vecY());
						ppSheetBig = PlaneProfile((eZoneBatten.coordSys()));
						ppSheetBig.joinRing(plSheetBig, _kAdd);
						PlaneProfile ppSheetRemain = ppSheetBig;
						ppSheetRemain.subtractProfile(ppSheetsAll);
						PLine pls[] = ppSheetRemain.allRings(true, false);
						PLine plSheet;
						PlaneProfile ppVentBig(eZoneBatten.coordSys());
						PLine plVentBig;
						if(nVertical)
						{
							plVentBig.createRectangle(LineSeg(ptCenVent - csEl.vecX() * U(10e3) - csEl.vecY() * .5 * dVentH / 2,
							ptCenVent + csEl.vecX() * U(10e3) + csEl.vecY() * .5 * dVentH / 2), csEl.vecX(), csEl.vecY());
							ppVentBig.joinRing(plVentBig, _kAdd);
							for (int iPl = 0; iPl < pls.length(); iPl++)
							{
								PlaneProfile pp(eZoneBatten.coordSys());
								pp.joinRing(pls[iPl], _kAdd);
								if (pp.intersectWith(ppVentBig))
								{
									plSheet = pls[iPl];
									break;
								}
							}//next iPl
							PlaneProfile ppSheet(eZoneBatten.coordSys());
							ppSheet.joinRing(plSheet, _kAdd);
							ppSheet.subtractProfile(ppTopModule);
							ppSheet.subtractProfile(ppBottomModule);
							ppSheet.vis(3);
							PLine plsSheet[] = ppSheet.allRings(true, false);
							if(plsSheet.length()>0)
							{ 
								plSheet = plsSheet[0];
							}
							int iIntersect;
							{ 
							// get extents of profile
								LineSeg seg = ppSheet.extentInDir(csEl.vecX());
								double dX = abs(csEl.vecX().dotProduct(seg.ptStart()-seg.ptEnd()));
								if (dX < (dWidthZone - dEps))iIntersect = true;
							}
							if (ppSheet.area() > pow(dEps, 2) && !iIntersect)
							{
								shStLeft.dbCreate(ppSheet, eZoneBatten.dH(), 1);
								shStLeft.setColor(eZoneBatten.color());
								shStLeft.assignToElementGroup(el, true, nBattenZone, 'Z' );
								_Map.setEntity("shStLeft", shStLeft);
								// add the stretched left stud
								ppSheetsAll.joinRing(plSheet, _kAdd);
							}
						}
						// --- above ----
						ppSheetBig = PlaneProfile((eZoneBatten.coordSys()));
						// --- above --- 
						Point3d ptAboveCsh = ptAboveC;
						ptAboveCsh+=csEl.vecY()*.5*(dWidthZone-el.dBeamHeight());
						if (nBatten==2)
						{
							ptAboveCsh+=csEl.vecY()*dBattenTolerance;
						}
						plSheetBig=PLine(eZoneBatten.vecZ());
						plSheetBig.createRectangle(LineSeg(ptAboveCsh - U(10e3) * csEl.vecX() - dWidthZone / 2 * csEl.vecY(),
						ptAboveCsh + U(10e3) * csEl.vecX() + dWidthZone / 2 * csEl.vecY()), csEl.vecX(), csEl.vecY());
						ppSheetBig.joinRing(plSheetBig, _kAdd);
						//	ppSheet.vis(3);
						ppSheetRemain = ppSheetBig;
						ppSheetRemain.subtractProfile(ppSheetsAll);
						//	ppSheetRemain.vis(3);
						
						pls.setLength(0);
						pls = ppSheetRemain.allRings(true, false);
						ppVentBig=PlaneProfile(eZoneBatten.coordSys());
						plVentBig.createRectangle(LineSeg(ptAboveCsh - csEl.vecX() * .5 * dVentW - csEl.vecY() * U(10e3),
						ptAboveCsh + csEl.vecX() * .5 * dVentW + csEl.vecY() * U(10e3)), csEl.vecX(), csEl.vecY());
						ppVentBig.joinRing(plVentBig, _kAdd);
						for (int iPl = 0; iPl < pls.length(); iPl++)
						{
							PlaneProfile pp(eZoneBatten.coordSys());
							pp.joinRing(pls[iPl], _kAdd);
							if (pp.intersectWith(ppVentBig))
							{
								plSheet = pls[iPl];
								break;
							}
						}//next iPl
						
						PlaneProfile ppSheet(eZoneBatten.coordSys());
						ppSheet.joinRing(plSheet, _kAdd);
						
						ppSheet.vis(9);
						if (ppSheet.area() > pow(dEps, 2))
						{
							shAbove.dbCreate(ppSheet, eZoneBatten.dH(), 1);
							shAbove.setColor(eZoneBatten.color());
							shAbove.assignToElementGroup(el, true, nBattenZone, 'Z' );
							_Map.setEntity("shAbove", shAbove);
						}
						
						// --- below ---
						Point3d ptBelowCsh = ptBelowC;
						ptBelowCsh += -csEl.vecY() * .5 * (dWidthZone - el.dBeamHeight());
						if (nBatten== 2)
						{
							ptBelowCsh += -csEl.vecY() * dBattenTolerance;
						}
						plSheetBig=PLine(eZoneBatten.vecZ());
						plSheetBig.createRectangle(LineSeg(ptBelowCsh - U(10e3) * csEl.vecX() - dWidthZone / 2 * csEl.vecY(),
						ptBelowCsh + U(10e3) * csEl.vecX() + dWidthZone / 2 * csEl.vecY()), csEl.vecX(), csEl.vecY());
						ppSheetBig = PlaneProfile((eZoneBatten.coordSys()));
						ppSheetBig.joinRing(plSheetBig, _kAdd);
						//	ppSheet.vis(3);
						ppSheetRemain = ppSheetBig;
						ppSheetRemain.subtractProfile(ppSheetsAll);
							ppSheetRemain.vis(3);
						pls.setLength(0);
						pls = ppSheetRemain.allRings(true, false);
						ppVentBig=PlaneProfile(eZoneBatten.coordSys());
						plVentBig.createRectangle(LineSeg(ptBelowCsh - csEl.vecX() * .5 * dVentW - csEl.vecY() * U(10e3),
						ptBelowCsh + csEl.vecX() * .5 * dVentW+ csEl.vecY() * U(10e3)), csEl.vecX(), csEl.vecY());
						ppVentBig.joinRing(plVentBig, _kAdd);
						for (int iPl = 0; iPl < pls.length(); iPl++)
						{
							PlaneProfile pp(eZoneBatten.coordSys());
							pp.joinRing(pls[iPl], _kAdd);
							if (pp.intersectWith(ppVentBig))
							{
								plSheet = pls[iPl];
								break;
							}
						}//next iPl
						
						ppSheet=PlaneProfile(eZoneBatten.coordSys());
						ppSheet.joinRing(plSheet, _kAdd);
						
						ppSheet.vis(9);
						if (ppSheet.area() > pow(dEps, 2))
						{
							shBelow.dbCreate(ppSheet, eZoneBatten.dH(), 1);
							shBelow.setColor(eZoneBatten.color());
							shBelow.assignToElementGroup(el, true, nBattenZone, 'Z' );
							_Map.setEntity("shBelow", shBelow);
						}
						if(nVertical)
						{ 
							// -- Right
							Point3d ptRCsh = ptRC;
							ptRCsh += csEl.vecX() * .5 * (dWidthZone - el.dBeamHeight());
							ppSheet = PlaneProfile(eZoneBatten.coordSys());
							plSheet = PLine();
							plSheet.createRectangle(LineSeg(ptRCsh - csEl.vecX() * .5 * dWidthZone - csEl.vecY() * dVentH / 2,
							ptRCsh + csEl.vecX() * .5 * dWidthZone + csEl.vecY() * dVentH / 2),
							csEl.vecX(), csEl.vecY());
							ppSheet.joinRing(plSheet, _kAdd);
							PlaneProfile ppSheetTest = ppSheet;
							ppSheetTest.shrink(dEps);
							if (ppSheet.area() > pow(dEps, 2) && !ppSheetTest.intersectWith(ppSheetsAll))
							{
								shStRight.dbCreate(ppSheet, eZoneBatten.dH(), 1);
								shStRight.setColor(eZoneBatten.color());
								shStRight.assignToElementGroup(el, true, nBattenZone, 'Z' );
								_Map.setEntity("shStRight", shStRight);
							}
						}
					}
				}
				else if(nStretchOption==2 && !nFixed)
				{ 
					if (nBatten== 1)
					{ 
						
						// stretch right
						// 
						Point3d ptCenVent = .5 * (ptBelowC + ptAboveC);
						Point3d ptRCsh = ptRC;
						ptRCsh += +csEl.vecX() * .5 * (dWidthZone - el.dBeamHeight());
						PlaneProfile ppSheetBig(eZoneBatten.coordSys());
						PLine plSheetBig(eZoneBatten.vecZ());
						plSheetBig.createRectangle(LineSeg(ptRCsh - csEl.vecX() * .5 * dWidthZone - csEl.vecY() * U(10e3),
								ptRCsh + csEl.vecX() * .5 * dWidthZone + csEl.vecY() * U(10e3)),
									csEl.vecX(), csEl.vecY());
						ppSheetBig = PlaneProfile((eZoneBatten.coordSys()));
						ppSheetBig.joinRing(plSheetBig, _kAdd);
						PlaneProfile ppSheetRemain = ppSheetBig;
						ppSheetRemain.subtractProfile(ppSheetsAll);
						PLine pls[] = ppSheetRemain.allRings(true, false);
						PLine plSheet;
						PlaneProfile ppVentBig(eZoneBatten.coordSys());
						PLine plVentBig;
						if(nVertical)
						{ 
							plVentBig.createRectangle(LineSeg(ptCenVent - csEl.vecX() * U(10e3) - csEl.vecY() * .5 * dVentH / 2,
							ptCenVent + csEl.vecX() * U(10e3) + csEl.vecY() * .5 * dVentH / 2), csEl.vecX(), csEl.vecY());
							ppVentBig.joinRing(plVentBig, _kAdd);
							for (int iPl = 0; iPl < pls.length(); iPl++)
							{
								PlaneProfile pp(eZoneBatten.coordSys());
								pp.joinRing(pls[iPl], _kAdd);
								if (pp.intersectWith(ppVentBig))
								{
									plSheet = pls[iPl];
									break;
								}
							}//next iPl
							PlaneProfile ppSheet(eZoneBatten.coordSys());
							ppSheet.joinRing(plSheet, _kAdd);
							ppSheet.joinRing(plSheet, _kAdd);
							ppSheet.subtractProfile(ppTopModule);
							ppSheet.subtractProfile(ppBottomModule);
							ppSheet.vis(3);
							PLine plsSheet[] = ppSheet.allRings(true, false);
							if(plsSheet.length()>0)
							{ 
								plSheet = plsSheet[0];
							}
							int iIntersect;
							{ 
							// get extents of profile
								LineSeg seg = ppSheet.extentInDir(csEl.vecX());
								double dX = abs(csEl.vecX().dotProduct(seg.ptStart()-seg.ptEnd()));
								if (dX < (dWidthZone - dEps))iIntersect = true;
							}
							if (ppSheet.area() > pow(dEps, 2) && !iIntersect)
							{
								shStRight.dbCreate(ppSheet, eZoneBatten.dH(), 1);
								shStRight.setColor(eZoneBatten.color());
								shStRight.assignToElementGroup(el, true, nBattenZone, 'Z' );
								_Map.setEntity("shStRight", shStRight);
								// add the stretched right stud
								ppSheetsAll.joinRing(plSheet, _kAdd);
							}
						}
						// --- above ----
						ppSheetBig = PlaneProfile((eZoneBatten.coordSys()));
						
						// --- above --- 
						Point3d ptAboveCsh = ptAboveC;
						ptAboveCsh += csEl.vecY() * .5 * (dWidthZone - el.dBeamHeight());
						if (nBatten== 2)
						{
							ptAboveCsh += csEl.vecY() * dBattenTolerance;
						}
						plSheetBig=PLine(eZoneBatten.vecZ());
						plSheetBig.createRectangle(LineSeg(ptAboveCsh - U(10e3) * csEl.vecX() - dWidthZone / 2 * csEl.vecY(),
						ptAboveCsh + U(10e3) * csEl.vecX() + dWidthZone / 2 * csEl.vecY()), csEl.vecX(), csEl.vecY());
						ppSheetBig.joinRing(plSheetBig, _kAdd);
						//	ppSheet.vis(3);
						ppSheetRemain = ppSheetBig;
						ppSheetRemain.subtractProfile(ppSheetsAll);
						//	ppSheetRemain.vis(3);
						
						pls.setLength(0);
						pls = ppSheetRemain.allRings(true, false);
						ppVentBig=PlaneProfile(eZoneBatten.coordSys());
						plVentBig.createRectangle(LineSeg(ptAboveCsh - csEl.vecX() * .5 * dVentW - csEl.vecY() * U(10e3),
						ptAboveCsh + csEl.vecX() * .5 * dVentW + csEl.vecY() * U(10e3)), csEl.vecX(), csEl.vecY());
						ppVentBig.joinRing(plVentBig, _kAdd);
						for (int iPl = 0; iPl < pls.length(); iPl++)
						{
							PlaneProfile pp(eZoneBatten.coordSys());
							pp.joinRing(pls[iPl], _kAdd);
							if (pp.intersectWith(ppVentBig))
							{
								plSheet = pls[iPl];
								break;
							}
						}//next iPl
						
						PlaneProfile ppSheet(eZoneBatten.coordSys());
						ppSheet.joinRing(plSheet, _kAdd);
						
						ppSheet.vis(9);
						if (ppSheet.area() > pow(dEps, 2))
						{
							shAbove.dbCreate(ppSheet, eZoneBatten.dH(), 1);
							shAbove.setColor(eZoneBatten.color());
							shAbove.assignToElementGroup(el, true, nBattenZone, 'Z' );
							_Map.setEntity("shAbove", shAbove);
						}
						
						// --- below ---
						Point3d ptBelowCsh = ptBelowC;
						ptBelowCsh += -csEl.vecY() * .5 * (dWidthZone - el.dBeamHeight());
						if (nBatten== 2)
						{
							ptBelowCsh += -csEl.vecY() * dBattenTolerance;
						}
						plSheetBig=PLine(eZoneBatten.vecZ());
						plSheetBig.createRectangle(LineSeg(ptBelowCsh - U(10e3) * csEl.vecX() - dWidthZone / 2 * csEl.vecY(),
						ptBelowCsh + U(10e3) * csEl.vecX() + dWidthZone / 2 * csEl.vecY()), csEl.vecX(), csEl.vecY());
						ppSheetBig = PlaneProfile((eZoneBatten.coordSys()));
						ppSheetBig.joinRing(plSheetBig, _kAdd);
						//	ppSheet.vis(3);
						ppSheetRemain = ppSheetBig;
						ppSheetRemain.subtractProfile(ppSheetsAll);
							ppSheetRemain.vis(3);
						pls.setLength(0);
						pls = ppSheetRemain.allRings(true, false);
						ppVentBig=PlaneProfile(eZoneBatten.coordSys());
						plVentBig.createRectangle(LineSeg(ptBelowCsh - csEl.vecX() * .5 * dVentW - csEl.vecY() * U(10e3),
						ptBelowCsh + csEl.vecX() * .5 * dVentW + csEl.vecY() * U(10e3)), csEl.vecX(), csEl.vecY());
						ppVentBig.joinRing(plVentBig, _kAdd);
						for (int iPl = 0; iPl < pls.length(); iPl++)
						{
							PlaneProfile pp(eZoneBatten.coordSys());
							pp.joinRing(pls[iPl], _kAdd);
							if (pp.intersectWith(ppVentBig))
							{
								plSheet = pls[iPl];
								break;
							}
						}//next iPl
						
						ppSheet=PlaneProfile(eZoneBatten.coordSys());
						ppSheet.joinRing(plSheet, _kAdd);
						
						ppSheet.vis(9);
						if (ppSheet.area() > pow(dEps, 2))
						{
							shBelow.dbCreate(ppSheet, eZoneBatten.dH(), 1);
							shBelow.setColor(eZoneBatten.color());
							shBelow.assignToElementGroup(el, true, nBattenZone, 'Z' );
							_Map.setEntity("shBelow", shBelow);
						}
						// -- Right
						if(nVertical)
						{ 
							Point3d ptLCsh = ptLC;
							ptLCsh += -csEl.vecX() * .5 * (dWidthZone - el.dBeamHeight());
							ppSheet = PlaneProfile(eZoneBatten.coordSys());
							plSheet = PLine();
							plSheet.createRectangle(LineSeg(ptLCsh - csEl.vecX() * .5 * dWidthZone - csEl.vecY() * dVentH / 2,
							ptLCsh + csEl.vecX() * .5 * dWidthZone + csEl.vecY() * dVentH / 2),
							csEl.vecX(), csEl.vecY());
							ppSheet.joinRing(plSheet, _kAdd);
							ppSheet.vis(6);
							PlaneProfile ppSheetTest = ppSheet;
							ppSheetTest.shrink(dEps);
							if (ppSheet.area() > pow(dEps, 2) && !ppSheetTest.intersectWith(ppSheetsAll))
							{
								shStLeft.dbCreate(ppSheet, eZoneBatten.dH(), 1);
								shStLeft.setColor(eZoneBatten.color());
								shStLeft.assignToElementGroup(el, true, nBattenZone, 'Z' );
								_Map.setEntity("shStLeft", shStLeft);
							}
						}
					}
				}
				else if(nStretchOption==3 || nFixed)
				{ 
					if (nBatten== 1)
					{ 
						// stretch both
						Point3d ptCenVent = .5 * (ptBelowC + ptAboveC);
						Point3d ptLCsh = ptLC;
						ptLCsh += -csEl.vecX() * .5 * (dWidthZone - el.dBeamHeight());
						PlaneProfile ppSheetBig(eZoneBatten.coordSys());
						PLine plSheetBig(eZoneBatten.vecZ());
						plSheetBig.createRectangle(LineSeg(ptLCsh - csEl.vecX() * .5 * dWidthZone - csEl.vecY() * U(10e3),
								ptLCsh + csEl.vecX() * .5 * dWidthZone + csEl.vecY() * U(10e3)),
									csEl.vecX(), csEl.vecY());
						ppSheetBig = PlaneProfile((eZoneBatten.coordSys()));
						ppSheetBig.joinRing(plSheetBig, _kAdd);
						PlaneProfile ppSheetRemain = ppSheetBig;
						ppSheetRemain.subtractProfile(ppSheetsAll);
						PLine pls[] = ppSheetRemain.allRings(true, false);
						PLine plsAll[] = ppSheetsAll.allRings(true, false);
						ppSheetRemain.vis(1);
						PLine plSheet;
						// horizontal strip
						PlaneProfile ppVentBig(eZoneBatten.coordSys());
						PLine plVentBig;
						if(nVertical)
						{
							plVentBig.createRectangle(LineSeg(ptCenVent - csEl.vecX() * U(10e3) - csEl.vecY() * .5 * dVentH / 2,
							ptCenVent + csEl.vecX() * U(10e3) + csEl.vecY() * .5 * dVentH / 2), csEl.vecX(), csEl.vecY());
							ppVentBig.joinRing(plVentBig, _kAdd);
							ppVentBig.vis(4);
							for (int iPl = 0; iPl < pls.length(); iPl++)
							{
								PlaneProfile pp(eZoneBatten.coordSys());
								pp.joinRing(pls[iPl], _kAdd);
								if (pp.intersectWith(ppVentBig))
								{
									plSheet = pls[iPl];
									break;
								}
							}//next iPl
							PlaneProfile ppSheet(eZoneBatten.coordSys());
							ppSheet.joinRing(plSheet, _kAdd);
							ppSheet.subtractProfile(ppTopModule);
							ppSheet.subtractProfile(ppBottomModule);
							ppSheet.vis(3);
							PLine plsSheet[] = ppSheet.allRings(true, false);
							if(plsSheet.length()>0)
							{ 
								plSheet = plsSheet[0];
							}
							int iIntersect;
							{ 
							// get extents of profile
								LineSeg seg = ppSheet.extentInDir(csEl.vecX());
								double dX = abs(csEl.vecX().dotProduct(seg.ptStart()-seg.ptEnd()));
								if (dX < (dWidthZone - dEps))iIntersect = true;
							}
							if (ppSheet.area() > pow(dEps, 2) && !iIntersect)
							{
								shStLeft.dbCreate(ppSheet, eZoneBatten.dH(), 1);
								shStLeft.setColor(eZoneBatten.color());
								shStLeft.assignToElementGroup(el, true, nBattenZone, 'Z' );
								_Map.setEntity("shStLeft", shStLeft);
								// add the stretched left stud
								ppSheetsAll.joinRing(plSheet, _kAdd);
							}
							
							Point3d ptRCsh = ptRC;
							ptRCsh += csEl.vecX() * .5 * (dWidthZone - el.dBeamHeight());
							ppSheetBig = PlaneProfile(eZoneBatten.coordSys());
							plSheetBig=PLine(eZoneBatten.vecZ());
							plSheetBig.createRectangle(LineSeg(ptRCsh - csEl.vecX() * .5 * dWidthZone - csEl.vecY() * U(10e3),
									ptRCsh + csEl.vecX() * .5 * dWidthZone + csEl.vecY() * U(10e3)),
										csEl.vecX(), csEl.vecY());
							ppSheetBig = PlaneProfile((eZoneBatten.coordSys()));
							ppSheetBig.joinRing(plSheetBig, _kAdd);
							ppSheetRemain = ppSheetBig;
							ppSheetRemain.subtractProfile(ppSheetsAll);
							pls.setLength(0);
							pls = ppSheetRemain.allRings(true, false);
							plSheet=PLine();
							ppVentBig=PlaneProfile(eZoneBatten.coordSys());
							plVentBig=PLine();
							plVentBig.createRectangle(LineSeg(ptCenVent - csEl.vecX() * U(10e3) - csEl.vecY() * .5 * dVentH / 2,
							ptCenVent + csEl.vecX() * U(10e3) + csEl.vecY() * .5 * dVentH / 2), csEl.vecX(), csEl.vecY());
							ppVentBig.joinRing(plVentBig, _kAdd);
							for (int iPl = 0; iPl < pls.length(); iPl++)
							{
								PlaneProfile pp(eZoneBatten.coordSys());
								pp.joinRing(pls[iPl], _kAdd);
								if (pp.intersectWith(ppVentBig))
								{
									plSheet = pls[iPl];
									break;
								}
							}//next iPl
							ppSheet = PlaneProfile(eZoneBatten.coordSys());
							ppSheet.joinRing(plSheet, _kAdd);
							ppSheet.subtractProfile(ppTopModule);
							ppSheet.subtractProfile(ppBottomModule);
							plsSheet.setLength(0);
							plsSheet = ppSheet.allRings(true, false);
							if(plsSheet.length()>0)
							{ 
								plSheet = plsSheet[0];
							}
							iIntersect=0;
							{ 
							// get extents of profile
								LineSeg seg = ppSheet.extentInDir(csEl.vecX());
								double dX = abs(csEl.vecX().dotProduct(seg.ptStart()-seg.ptEnd()));
								if (dX < (dWidthZone - dEps))iIntersect = true;
							}
							if (ppSheet.area() > pow(dEps, 2) && !iIntersect)
							{
								shStRight.dbCreate(ppSheet, eZoneBatten.dH(), 1);
								shStRight.setColor(eZoneBatten.color());
								shStRight.assignToElementGroup(el, true, nBattenZone, 'Z' );
								_Map.setEntity("shStRight", shStRight);
								// add the stretched right stud
								ppSheetsAll.joinRing(plSheet, _kAdd);
							}
						}
						// --- above ----
						ppSheetBig = PlaneProfile((eZoneBatten.coordSys()));
						
						// --- above --- 
						Point3d ptAboveCsh = ptAboveC;
						ptAboveCsh += csEl.vecY() * .5 * (dWidthZone - el.dBeamHeight());
						if (nBatten==2)
						{
							ptAboveCsh += csEl.vecY() * dBattenTolerance;
						}
						plSheetBig=PLine(eZoneBatten.vecZ());
						plSheetBig.createRectangle(LineSeg(ptAboveCsh - U(10e3) * csEl.vecX() - dWidthZone / 2 * csEl.vecY(),
						ptAboveCsh + U(10e3) * csEl.vecX() + dWidthZone / 2 * csEl.vecY()), csEl.vecX(), csEl.vecY());
						ppSheetBig.joinRing(plSheetBig, _kAdd);
						//	ppSheet.vis(3);
						ppSheetRemain = ppSheetBig;
						ppSheetRemain.subtractProfile(ppSheetsAll);
						//	ppSheetRemain.vis(3);
						
						pls.setLength(0);
						pls = ppSheetRemain.allRings(true, false);
						ppVentBig=PlaneProfile(eZoneBatten.coordSys());
						plVentBig.createRectangle(LineSeg(ptAboveCsh - csEl.vecX() * .5 * dVentW - csEl.vecY() * U(10e3),
						ptAboveCsh + csEl.vecX() * .5 * dVentW + csEl.vecY() * U(10e3)), csEl.vecX(), csEl.vecY());
						ppVentBig.joinRing(plVentBig, _kAdd);
						for (int iPl = 0; iPl < pls.length(); iPl++)
						{
							PlaneProfile pp(eZoneBatten.coordSys());
							pp.joinRing(pls[iPl], _kAdd);
							if (pp.intersectWith(ppVentBig))
							{
								plSheet = pls[iPl];
								break;
							}
						}//next iPl
						
						PlaneProfile ppSheet(eZoneBatten.coordSys());
						ppSheet.joinRing(plSheet, _kAdd);
						
						ppSheet.vis(9);
						if (ppSheet.area() > pow(dEps, 2))
						{
							shAbove.dbCreate(ppSheet, eZoneBatten.dH(), 1);
							shAbove.setColor(eZoneBatten.color());
							shAbove.assignToElementGroup(el, true, nBattenZone, 'Z' );
							_Map.setEntity("shAbove", shAbove);
						}
						
						// --- below ---
						Point3d ptBelowCsh = ptBelowC;
						ptBelowCsh += -csEl.vecY() * .5 * (dWidthZone - el.dBeamHeight());
						if (nBatten== 2)
						{
							ptBelowCsh += -csEl.vecY() * dBattenTolerance;
						}
						plSheetBig=PLine(eZoneBatten.vecZ());
						plSheetBig.createRectangle(LineSeg(ptBelowCsh - U(10e3) * csEl.vecX() - dWidthZone / 2 * csEl.vecY(),
						ptBelowCsh + U(10e3) * csEl.vecX() + dWidthZone / 2 * csEl.vecY()), csEl.vecX(), csEl.vecY());
						ppSheetBig = PlaneProfile((eZoneBatten.coordSys()));
						ppSheetBig.joinRing(plSheetBig, _kAdd);
						//	ppSheet.vis(3);
						ppSheetRemain = ppSheetBig;
						ppSheetRemain.subtractProfile(ppSheetsAll);
							ppSheetRemain.vis(3);
						pls.setLength(0);
						pls = ppSheetRemain.allRings(true, false);
						ppVentBig=PlaneProfile(eZoneBatten.coordSys());
						plVentBig.createRectangle(LineSeg(ptBelowCsh - csEl.vecX() * .5 * dVentW - csEl.vecY() * U(10e3),
						ptBelowCsh + csEl.vecX() * .5 * dVentW + csEl.vecY() * U(10e3)), csEl.vecX(), csEl.vecY());
						ppVentBig.joinRing(plVentBig, _kAdd);
						for (int iPl = 0; iPl < pls.length(); iPl++)
						{
							PlaneProfile pp(eZoneBatten.coordSys());
							pp.joinRing(pls[iPl], _kAdd);
							if (pp.intersectWith(ppVentBig))
							{
								plSheet = pls[iPl];
								break;
							}
						}//next iPl
						
						ppSheet=PlaneProfile(eZoneBatten.coordSys());
						ppSheet.joinRing(plSheet, _kAdd);
						
						ppSheet.vis(9);
						if (ppSheet.area() > pow(dEps, 2))
						{
							shBelow.dbCreate(ppSheet, eZoneBatten.dH(), 1);
							shBelow.setColor(eZoneBatten.color());
							shBelow.assignToElementGroup(el, true, nBattenZone, 'Z' );
							_Map.setEntity("shBelow", shBelow);
						}
					}
				}
			}
			else
			{ 
				reportMessage("\n" + scriptName() + ": " +T("|no sheeting for the batten selected zone|"));
			}
		}
		
	}
	if ( ! nFixed )
	{
		// opening is above element, not fixed vent
		// for this option is also supported the property stretch vertical
		// horizontal beams
		if (nStretchOption == 0)
		{
			// do not stretch vertical beams, keep current implementation
			// horizontal beam above
			if ( ! bmClAbove.bIsValid())
			{
				if (bmTop.bIsValid())
				{
					bmAbove = bmTop;
				}
				else {
					reportNotice("\n"+ scriptName()+" " +T("Beamcode is not valid 1."));
					return;
				}
			}
			// opening is in element and also far enough away from the closest beam above.
			// create a new beam in the element.
			else if ( (abs(dClAbove) - dVentH * 0.5 - el.dBeamHeight() - bmClAbove.dD(csEl.vecY()) * 0.5) > 0 )
			{
				bmAbove.dbCreate(ptAboveC, csEl.vecX(), csEl.vecY(), csEl.vecZ(),
				dVentW, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
				bmAbove.setColor(nBeamColor);
				bmAbove.setType(_kSFVent);
				bmAbove.setName(sName);
				bmAbove.setMaterial(sMaterial);
				bmAbove.setGrade(sGrade);
				bmAbove.setInformation(sInformation);
				bmAbove.setLabel(sLabel);
				bmAbove.setSubLabel(sSublabel);
				bmAbove.setSubLabel2(sSublabel2);
				if (nModule) bmAbove.setModule(sModuleName);
				
				bmAbove.assignToElementGroup(el, TRUE, 0, 'Z');
				bmAbove.stretchDynamicTo(bmClLeft);
				bmAbove.stretchDynamicTo(bmClRight);
				bmAbove.setHsbId(139);
				_Beam.append(bmAbove);
				if (nNoNail)
					bmAbove.setBeamCode("VENT;;0;;;;;;NO;;;;");
				else
					bmAbove.setBeamCode("VENT;;0;;;;;;YES;;;;");
				_Map.setEntity("bmAbove", bmAbove);
				// set bmTop invalid. So the upper part of the beam.dbSplit will not be erased.
				bmTop = Beam();
				// create shAbove
				{ 
					PlaneProfile ppSheet(eZoneBatten.coordSys());
					PLine pl(eZoneBatten.vecZ());
//					ppSheet
				}
			}
			else
			{
				// opening is in element, but too close to the beam above. No extra beam will be placed.
				// set bmAbove equal to bmClAbove. The generated studs will be streched to bmAbove.
				// the upper part of the beam.dbSplit will be erased from the database.
				bmAbove = bmClAbove;
			}
			// horizontal beam below
			// opening is below element.
			if ( ! bmClBelow.bIsValid()) {
				// check if beam bottom is valid
				if (bmBottom.bIsValid()) {
					bmBelow = bmBottom;
				}
				else {
					reportNotice("\n"+ scriptName()+" "+T("Beamcode is not valid 2."));
					return;
				}
			}
			// opening is in element and also far enough away from the closest beam below.
			// create a new beam in the element.
			else if (bmClBelow.bIsValid() && (abs(dClBelow) - dVentH * 0.5 - el.dBeamHeight() - bmClBelow.dD(csEl.vecY()) * 0.5) > 0 ) {
				bmBelow.dbCreate(ptBelowC, csEl.vecX(), csEl.vecY(), csEl.vecZ(),
				dVentW, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
				bmBelow.setColor(nBeamColor);
				bmBelow.setType(_kSFVent);
				bmBelow.setName(sName);
				bmBelow.setMaterial(sMaterial);
				bmBelow.setGrade(sGrade);
				bmBelow.setInformation(sInformation);
				bmBelow.setLabel(sLabel);
				bmBelow.setSubLabel(sSublabel);
				bmBelow.setSubLabel2(sSublabel2);
				if (nModule) bmBelow.setModule(sModuleName);
				
				bmBelow.assignToElementGroup(el, TRUE, 0, 'Z');
				bmBelow.stretchDynamicTo(bmClLeft);
				bmBelow.stretchDynamicTo(bmClRight);
				bmBelow.setHsbId(139);
				_Beam.append(bmBelow);
				if (nNoNail)
					bmBelow.setBeamCode("VENT;;0;;;;;;NO;;;;");
				else
					bmBelow.setBeamCode("VENT;;0;;;;;;YES;;;;");
				_Map.setEntity("bmBelow", bmBelow);
				// set bmBottom invalid. So the lower part of the beam.dbSplit will not be erased.
				bmBottom = Beam();
			}
			else {
				// opening is in element, but too close to the beam below. No extra beam will be placed.
				// set bmBelow equal to bmClBelow. The generated studs will be streched to bmBelow.
				// the lower part of the beam.dbSplit will be erased from the database.
				bmBelow = bmClBelow;
			}
			
			// vertical beams around vent hole
			if (nVertical)
			{
				// create vertical beams around vent hole
				if ( (abs(dClLeft) - dVentW * 0.5 - el.dBeamHeight() * 1.5) > 0 ) {
					bmStLeft.dbCreate(ptLC, csEl.vecY(), csEl.vecX(), csEl.vecZ(),
					dVentH / 2, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
					bmStLeft.setColor(nBeamColor);
					bmStLeft.setType(_kSFVent);
					
					bmStLeft.setName(sName);
					bmStLeft.setMaterial(sMaterial);
					bmStLeft.setGrade(sGrade);
					bmStLeft.setInformation(sInformation);
					bmStLeft.setLabel(sLabel);
					bmStLeft.setSubLabel(sSublabel);
					bmStLeft.setSubLabel2(sSublabel2);
					if (nModule) bmStLeft.setModule(sModuleName);
					bmStLeft.assignToElementGroup(el, TRUE, 0, 'Z');
					bmStLeft.stretchDynamicTo(bmAbove);
					bmStLeft.stretchDynamicTo(bmBelow);
					bmStLeft.setHsbId(139);
					_Beam.append(bmStLeft);
					if (nNoNail)
						bmStLeft.setBeamCode("VENT;;0;;;;;;NO;;;;");
					else
						bmStLeft.setBeamCode("VENT;;0;;;;;;YES;;;;");
					_Map.setEntity("bmStLeft", bmStLeft);
				}
				
				if ( (abs(dClRight) - dVentW * 0.5 - el.dBeamHeight() * 1.5) > 0 ) {
					bmStRight.dbCreate(ptRC, csEl.vecY(), csEl.vecX(), csEl.vecZ(),
					dVentH / 2, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
					bmStRight.setColor(nBeamColor);
					bmStRight.setType(_kSFVent);
					bmStRight.setName(sName);
					bmStRight.setMaterial(sMaterial);
					bmStRight.setGrade(sGrade);
					bmStRight.setInformation(sInformation);
					bmStRight.setLabel(sLabel);
					bmStRight.setSubLabel(sSublabel);
					bmStRight.setSubLabel2(sSublabel2);
					if (nModule) bmStRight.setModule(sModuleName);
					bmStRight.assignToElementGroup(el, TRUE, 0, 'Z');
					bmStRight.stretchDynamicTo(bmAbove);
					bmStRight.stretchDynamicTo(bmBelow);
					bmStRight.setHsbId(139);
					_Beam.append(bmStRight);
					if (nNoNail)
						bmStRight.setBeamCode("VENT;;0;;;;;;NO;;;;");
					else
						bmStRight.setBeamCode("VENT;;0;;;;;;YES;;;;");
					_Map.setEntity("bmStRight", bmStRight);
				}
			}
		}
		else if (nStretchOption == 1)
		{
			// stretch left beam
			if (nVertical)
			{
				// create vertical beams
				// stretch left beam similar to the fixed vent case
				if ( (abs(dClLeft) - dVentW * 0.5 - el.dBeamHeight() * 1.5) > 0 )
				{
					// left vertical beam
					bmStLeft.dbCreate(ptLC, csEl.vecY(), csEl.vecX(), csEl.vecZ(),
					dVentH / 2, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
					bmStLeft.setColor(nBeamColor);
					bmStLeft.setType(_kStud);
					bmStLeft.setName("STUD");
					bmStLeft.setMaterial(sMaterial);
					bmStLeft.setGrade(sGrade);
					bmStLeft.setInformation("STUD");
					bmStLeft.setLabel(sLabel);
					bmStLeft.setSubLabel(sSublabel);
					bmStLeft.setSubLabel2(sSublabel2);
					if (nModule) bmStLeft.setModule(sModuleName);
					bmStLeft.assignToElementGroup(el, TRUE, 0, 'Z');
					bmStLeft.stretchDynamicTo(bmClAbove);
					bmStLeft.stretchDynamicTo(bmClBelow);
					bmClLeft = bmStLeft;
					bmStLeft.setHsbId(114);
					_Beam.append(bmStLeft);
					_Map.setEntity("bmStLeft", bmStLeft);
				}
			}
			
			// create bmAbove and bmBelow
			// opening is above element
			// bmAbove
			if ( ! bmClAbove.bIsValid())
			{
				if (bmTop.bIsValid())
				{
					bmAbove = bmTop;
				}
				else
				{
					reportNotice("\n"+ scriptName()+" "+T("Beamcode is not valid 1."));
					return;
				}
			}
			// opening is in element and also far enough away from the closest beam above.
			// create a new beam in the element.
			else if ( (abs(dClAbove) - dVentH * 0.5 - el.dBeamHeight() - bmClAbove.dD(csEl.vecY()) * 0.5) > 0 )
			{
				bmAbove.dbCreate(ptAboveC, csEl.vecX(), csEl.vecY(), csEl.vecZ(),
				dVentW, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
				bmAbove.setColor(nBeamColor);
				bmAbove.setType(_kSFVent);
				bmAbove.setName(sName);
				bmAbove.setMaterial(sMaterial);
				bmAbove.setGrade(sGrade);
				bmAbove.setInformation(sInformation);
				bmAbove.setLabel(sLabel);
				bmAbove.setSubLabel(sSublabel);
				bmAbove.setSubLabel2(sSublabel2);
				if (nModule) bmAbove.setModule(sModuleName);
				bmAbove.assignToElementGroup(el, TRUE, 0, 'Z');
				// bmClLeft is the newly created left vertical beam
				bmAbove.stretchDynamicTo(bmClLeft);
				bmAbove.stretchDynamicTo(bmClRight);
				bmAbove.setHsbId(139);
				_Beam.append(bmAbove);
				if (nNoNail)
					bmAbove.setBeamCode("VENT;;0;;;;;;NO;;;;");
				else
					bmAbove.setBeamCode("VENT;;0;;;;;;YES;;;;");
				_Map.setEntity("bmAbove", bmAbove);
				// set bmTop invalid. So the upper part of the beam.dbSplit will not be erased.
				bmTop = Beam();
			}
			else
			{
				// opening is in element, but too close to the beam above. No extra beam will be placed.
				// set bmAbove equal to bmClAbove. The generated studs will be streched to bmAbove.
				// the upper part of the beam.dbSplit will be erased from the database.
				bmAbove = bmClAbove;
			}
			
			// horizontal beam below
			// opening is below element.
			if ( ! bmClBelow.bIsValid())
			{
				// check if beam bottom is valid
				if (bmBottom.bIsValid())
				{
					bmBelow = bmBottom;
				}
				else
				{
					reportNotice("\n"+ scriptName()+" "+T("Beamcode is not valid 2."));
					return;
				}
			}
			// opening is in element and also far enough away from the closest beam below.
			// create a new beam in the element.
			else if (bmClBelow.bIsValid() && (abs(dClBelow) - dVentH * 0.5 - el.dBeamHeight() - bmClBelow.dD(csEl.vecY()) * 0.5) > 0 )
			{
				// horizontal beam below
				bmBelow.dbCreate(ptBelowC, csEl.vecX(), csEl.vecY(), csEl.vecZ(),
				dVentW, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
				bmBelow.setColor(nBeamColor);
				bmBelow.setType(_kSFVent);
				bmBelow.setName(sName);
				bmBelow.setMaterial(sMaterial);
				bmBelow.setGrade(sGrade);
				bmBelow.setInformation(sInformation);
				bmBelow.setLabel(sLabel);
				bmBelow.setSubLabel(sSublabel);
				bmBelow.setSubLabel2(sSublabel2);
				if (nModule) bmBelow.setModule(sModuleName);
				
				bmBelow.assignToElementGroup(el, TRUE, 0, 'Z');
				// bmClLeft is the newly created left vertical beam
				bmBelow.stretchDynamicTo(bmClLeft);
				bmBelow.stretchDynamicTo(bmClRight);
				bmBelow.setHsbId(139);
				_Beam.append(bmBelow);
				if (nNoNail)
					bmBelow.setBeamCode("VENT;;0;;;;;;NO;;;;");
				else
					bmBelow.setBeamCode("VENT;;0;;;;;;YES;;;;");
				_Map.setEntity("bmBelow", bmBelow);
				// set bmBottom invalid. So the lower part of the beam.dbSplit will not be erased.
				bmBottom = Beam();
			}
			else
			{
				// opening is in element, but too close to the beam below. No extra beam will be placed.
				// set bmBelow equal to bmClBelow. The generated studs will be streched to bmBelow.
				// the lower part of the beam.dbSplit will be erased from the database.
				bmBelow = bmClBelow;
			}
			
			if (nVertical)
			{
				// right vertical beam
				// right vertical
				if ( (abs(dClRight) - dVentW * 0.5 - el.dBeamHeight() * 1.5) > 0 )
				{
					// right vertical beam
					bmStRight.dbCreate(ptRC, csEl.vecY(), csEl.vecX(), csEl.vecZ(),
					dVentH / 2, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
					bmStRight.setColor(nBeamColor);
					bmStRight.setType(_kSFVent);
					bmStRight.setName(sName);
					bmStRight.setMaterial(sMaterial);
					bmStRight.setGrade(sGrade);
					bmStRight.setInformation(sInformation);
					bmStRight.setLabel(sLabel);
					bmStRight.setSubLabel(sSublabel);
					bmStRight.setSubLabel2(sSublabel2);
					if (nModule) bmStRight.setModule(sModuleName);
					bmStRight.assignToElementGroup(el, TRUE, 0, 'Z');
					bmStRight.stretchDynamicTo(bmAbove);
					bmStRight.stretchDynamicTo(bmBelow);
					bmStRight.setHsbId(139);
					_Beam.append(bmStRight);
					if (nNoNail)
						bmStRight.setBeamCode("VENT;;0;;;;;;NO;;;;");
					else
						bmStRight.setBeamCode("VENT;;0;;;;;;YES;;;;");
					_Map.setEntity("bmStRight", bmStRight);
				}
			}
		}
		else if (nStretchOption == 2)
		{
			// stretch right beam
			if (nVertical)
			{
				// right vertical beam
				// right vertical
				if ( (abs(dClRight) - dVentW * 0.5 - el.dBeamHeight() * 1.5) > 0 ) {
					bmStRight.dbCreate(ptRC, csEl.vecY(), csEl.vecX(), csEl.vecZ(),
					dVentH / 2, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
					bmStRight.setColor(nBeamColor);
					bmStRight.setType(_kStud);
					bmStRight.setName("STUD");
					bmStRight.setMaterial(sMaterial);
					bmStRight.setGrade(sGrade);
					bmStRight.setInformation("STUD");
					bmStRight.setLabel(sLabel);
					bmStRight.setSubLabel(sSublabel);
					bmStRight.setSubLabel2(sSublabel2);
					if (nModule) bmStRight.setModule(sModuleName);
					bmStRight.assignToElementGroup(el, TRUE, 0, 'Z');
					bmStRight.stretchDynamicTo(bmClAbove);
					bmStRight.stretchDynamicTo(bmClBelow);
					bmClRight = bmStRight;
					bmStRight.setHsbId(114);
					_Beam.append(bmStRight);
					_Map.setEntity("bmStRight", bmStRight);
				}
			}
			
			// create bmAbove and bmBelow
			// opening is above element
			// bmAbove
			if ( ! bmClAbove.bIsValid())
			{
				if (bmTop.bIsValid())
				{
					bmAbove = bmTop;
				}
				else
				{
					reportNotice("\n"+ scriptName()+" "+T("Beamcode is not valid 1."));
					return;
				}
			}
			// opening is in element and also far enough away from the closest beam above.
			// create a new beam in the element.
			else if ( (abs(dClAbove) - dVentH * 0.5 - el.dBeamHeight() - bmClAbove.dD(csEl.vecY()) * 0.5) > 0 )
			{
				bmAbove.dbCreate(ptAboveC, csEl.vecX(), csEl.vecY(), csEl.vecZ(),
				dVentW, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
				bmAbove.setColor(nBeamColor);
				bmAbove.setType(_kSFVent);
				bmAbove.setName(sName);
				bmAbove.setMaterial(sMaterial);
				bmAbove.setGrade(sGrade);
				bmAbove.setInformation(sInformation);
				bmAbove.setLabel(sLabel);
				bmAbove.setSubLabel(sSublabel);
				bmAbove.setSubLabel2(sSublabel2);
				if (nModule) bmAbove.setModule(sModuleName);
				bmAbove.assignToElementGroup(el, TRUE, 0, 'Z');
				// bmClLeft is the newly created left vertical beam
				bmAbove.stretchDynamicTo(bmClLeft);
				bmAbove.stretchDynamicTo(bmClRight);
				bmAbove.setHsbId(139);
				_Beam.append(bmAbove);
				if (nNoNail)
					bmAbove.setBeamCode("VENT;;0;;;;;;NO;;;;");
				else
					bmAbove.setBeamCode("VENT;;0;;;;;;YES;;;;");
				_Map.setEntity("bmAbove", bmAbove);
				// set bmTop invalid. So the upper part of the beam.dbSplit will not be erased.
				bmTop = Beam();
			}
			else
			{
				// opening is in element, but too close to the beam above. No extra beam will be placed.
				// set bmAbove equal to bmClAbove. The generated studs will be streched to bmAbove.
				// the upper part of the beam.dbSplit will be erased from the database.
				bmAbove = bmClAbove;
			}
			
			// horizontal beam below
			// opening is below element.
			if ( ! bmClBelow.bIsValid())
			{
				// check if beam bottom is valid
				if (bmBottom.bIsValid())
				{
					bmBelow = bmBottom;
				}
				else
				{
					reportNotice("\n"+ scriptName()+" "+T("Beamcode is not valid 2."));
					return;
				}
			}
			// opening is in element and also far enough away from the closest beam below.
			// create a new beam in the element.
			else if (bmClBelow.bIsValid() && (abs(dClBelow) - dVentH * 0.5 - el.dBeamHeight() - bmClBelow.dD(csEl.vecY()) * 0.5) > 0 )
			{
				// horizontal beam below
				bmBelow.dbCreate(ptBelowC, csEl.vecX(), csEl.vecY(), csEl.vecZ(),
				dVentW, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
				bmBelow.setColor(nBeamColor);
				bmBelow.setType(_kSFVent);
				bmBelow.setName(sName);
				bmBelow.setMaterial(sMaterial);
				bmBelow.setGrade(sGrade);
				bmBelow.setInformation(sInformation);
				bmBelow.setLabel(sLabel);
				bmBelow.setSubLabel(sSublabel);
				bmBelow.setSubLabel2(sSublabel2);
				if (nModule) bmBelow.setModule(sModuleName);
				
				bmBelow.assignToElementGroup(el, TRUE, 0, 'Z');
				// bmClLeft is the newly created left vertical beam
				bmBelow.stretchDynamicTo(bmClLeft);
				bmBelow.stretchDynamicTo(bmClRight);
				bmBelow.setHsbId(139);
				_Beam.append(bmBelow);
				if (nNoNail)
					bmBelow.setBeamCode("VENT;;0;;;;;;NO;;;;");
				else
					bmBelow.setBeamCode("VENT;;0;;;;;;YES;;;;");
				_Map.setEntity("bmBelow", bmBelow);
				// set bmBottom invalid. So the lower part of the beam.dbSplit will not be erased.
				bmBottom = Beam();
			}
			else
			{
				// opening is in element, but too close to the beam below. No extra beam will be placed.
				// set bmBelow equal to bmClBelow. The generated studs will be streched to bmBelow.
				// the lower part of the beam.dbSplit will be erased from the database.
				bmBelow = bmClBelow;
			}
			
			if (nVertical)
			{
				// create vertical beams around vent hole
				if ( (abs(dClLeft) - dVentW * 0.5 - el.dBeamHeight() * 1.5) > 0 ) {
					bmStLeft.dbCreate(ptLC, csEl.vecY(), csEl.vecX(), csEl.vecZ(),
					dVentH / 2, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
					bmStLeft.setColor(nBeamColor);
					bmStLeft.setType(_kSFVent);
					
					bmStLeft.setName(sName);
					bmStLeft.setMaterial(sMaterial);
					bmStLeft.setGrade(sGrade);
					bmStLeft.setInformation(sInformation);
					bmStLeft.setLabel(sLabel);
					bmStLeft.setSubLabel(sSublabel);
					bmStLeft.setSubLabel2(sSublabel2);
					if (nModule) bmStLeft.setModule(sModuleName);
					bmStLeft.assignToElementGroup(el, TRUE, 0, 'Z');
					bmStLeft.stretchDynamicTo(bmAbove);
					bmStLeft.stretchDynamicTo(bmBelow);
					bmStLeft.setHsbId(139);
					_Beam.append(bmStLeft);
					if (nNoNail)
						bmStLeft.setBeamCode("VENT;;0;;;;;;NO;;;;");
					else
						bmStLeft.setBeamCode("VENT;;0;;;;;;YES;;;;");
					_Map.setEntity("bmStLeft", bmStLeft);
				}
			}
		}
		else
		{
			// stretch both beams, nStretchOption==3
			if (nVertical)
			{
				// create vertical beams
				// stretch left beam similar to the fixed vent case
				if ( (abs(dClLeft) - dVentW * 0.5 - el.dBeamHeight() * 1.5) > 0 )
				{
					// left vertical beam
					bmStLeft.dbCreate(ptLC, csEl.vecY(), csEl.vecX(), csEl.vecZ(),
					dVentH / 2, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
					bmStLeft.setColor(nBeamColor);
					bmStLeft.setType(_kStud);
					bmStLeft.setName("STUD");
					bmStLeft.setMaterial(sMaterial);
					bmStLeft.setGrade(sGrade);
					bmStLeft.setInformation("STUD");
					bmStLeft.setLabel(sLabel);
					bmStLeft.setSubLabel(sSublabel);
					bmStLeft.setSubLabel2(sSublabel2);
					if (nModule) bmStLeft.setModule(sModuleName);
					bmStLeft.assignToElementGroup(el, TRUE, 0, 'Z');
					bmClAbove.envelopeBody().vis(3);
					bmClBelow.envelopeBody().vis(3);
					bmStLeft.stretchDynamicTo(bmClAbove);
					bmStLeft.stretchDynamicTo(bmClBelow);
					bmClLeft = bmStLeft;
					bmStLeft.setHsbId(114);
					_Beam.append(bmStLeft);
					_Map.setEntity("bmStLeft", bmStLeft);
				}
				// stretch right beam
				// right vertical beam
				if ( (abs(dClRight) - dVentW * 0.5 - el.dBeamHeight() * 1.5) > 0 ) {
					bmStRight.dbCreate(ptRC, csEl.vecY(), csEl.vecX(), csEl.vecZ(),
					dVentH / 2, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
					bmStRight.setColor(nBeamColor);
					bmStRight.setType(_kStud);
					bmStRight.setName("STUD");
					bmStRight.setMaterial(sMaterial);
					bmStRight.setGrade(sGrade);
					bmStRight.setInformation("STUD");
					bmStRight.setLabel(sLabel);
					bmStRight.setSubLabel(sSublabel);
					bmStRight.setSubLabel2(sSublabel2);
					if (nModule) bmStRight.setModule(sModuleName);
					bmStRight.assignToElementGroup(el, TRUE, 0, 'Z');
					bmStRight.stretchDynamicTo(bmClAbove);
					bmStRight.stretchDynamicTo(bmClBelow);
					bmClRight = bmStRight;
					bmStRight.setHsbId(114);
					_Beam.append(bmStRight);
					_Map.setEntity("bmStRight", bmStRight);
				}
			}
			//
			// create bmAbove and bmBelow
			// opening is above element
			// bmAbove
			if ( ! bmClAbove.bIsValid())
			{
				if (bmTop.bIsValid())
				{
					bmAbove = bmTop;
				}
				else
				{
					reportNotice("\n"+ scriptName()+" "+T("Beamcode is not valid 1."));
					return;
				}
			}
			// opening is in element and also far enough away from the closest beam above.
			// create a new beam in the element.
			else if ( (abs(dClAbove) - dVentH * 0.5 - el.dBeamHeight() - bmClAbove.dD(csEl.vecY()) * 0.5) > 0 )
			{
				bmAbove.dbCreate(ptAboveC, csEl.vecX(), csEl.vecY(), csEl.vecZ(),
				dVentW, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
				bmAbove.setColor(nBeamColor);
				bmAbove.setType(_kSFVent);
				bmAbove.setName(sName);
				bmAbove.setMaterial(sMaterial);
				bmAbove.setGrade(sGrade);
				bmAbove.setInformation(sInformation);
				bmAbove.setLabel(sLabel);
				bmAbove.setSubLabel(sSublabel);
				bmAbove.setSubLabel2(sSublabel2);
				if (nModule) bmAbove.setModule(sModuleName);
				bmAbove.assignToElementGroup(el, TRUE, 0, 'Z');
				// bmClLeft is the newly created left vertical beam
				bmAbove.stretchDynamicTo(bmClLeft);
				bmAbove.stretchDynamicTo(bmClRight);
				bmAbove.setHsbId(139);
				_Beam.append(bmAbove);
				if (nNoNail)
					bmAbove.setBeamCode("VENT;;0;;;;;;NO;;;;");
				else
					bmAbove.setBeamCode("VENT;;0;;;;;;YES;;;;");
				_Map.setEntity("bmAbove", bmAbove);
				// set bmTop invalid. So the upper part of the beam.dbSplit will not be erased.
				bmTop = Beam();
			}
			else
			{
				// opening is in element, but too close to the beam above. No extra beam will be placed.
				// set bmAbove equal to bmClAbove. The generated studs will be streched to bmAbove.
				// the upper part of the beam.dbSplit will be erased from the database.
				bmAbove = bmClAbove;
			}
			
			// horizontal beam below
			// opening is below element.
			if ( ! bmClBelow.bIsValid())
			{
				// check if beam bottom is valid
				if (bmBottom.bIsValid())
				{
					bmBelow = bmBottom;
				}
				else
				{
					reportNotice("\n"+ scriptName()+" "+T("Beamcode is not valid 2."));
					return;
				}
			}
			// opening is in element and also far enough away from the closest beam below.
			// create a new beam in the element.
			else if (bmClBelow.bIsValid() && (abs(dClBelow) - dVentH * 0.5 - el.dBeamHeight() - bmClBelow.dD(csEl.vecY()) * 0.5) > 0 )
			{
				// horizontal beam below
				bmBelow.dbCreate(ptBelowC, csEl.vecX(), csEl.vecY(), csEl.vecZ(),
				dVentW, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
				bmBelow.setColor(nBeamColor);
				bmBelow.setType(_kSFVent);
				bmBelow.setName(sName);
				bmBelow.setMaterial(sMaterial);
				bmBelow.setGrade(sGrade);
				bmBelow.setInformation(sInformation);
				bmBelow.setLabel(sLabel);
				bmBelow.setSubLabel(sSublabel);
				bmBelow.setSubLabel2(sSublabel2);
				if (nModule) bmBelow.setModule(sModuleName);
				
				bmBelow.assignToElementGroup(el, TRUE, 0, 'Z');
				// bmClLeft is the newly created left vertical beam
				bmBelow.stretchDynamicTo(bmClLeft);
				bmBelow.stretchDynamicTo(bmClRight);
				bmBelow.setHsbId(139);
				_Beam.append(bmBelow);
				if (nNoNail)
					bmBelow.setBeamCode("VENT;;0;;;;;;NO;;;;");
				else
					bmBelow.setBeamCode("VENT;;0;;;;;;YES;;;;");
				_Map.setEntity("bmBelow", bmBelow);
				// set bmBottom invalid. So the lower part of the beam.dbSplit will not be erased.
				bmBottom = Beam();
			}
			else
			{
				// opening is in element, but too close to the beam below. No extra beam will be placed.
				// set bmBelow equal to bmClBelow. The generated studs will be streched to bmBelow.
				// the lower part of the beam.dbSplit will be erased from the database.
				bmBelow = bmClBelow;
			}
		}//stretch options
		
		Beam bmBlockingToSplit[0];
		Point3d ptListToSplit[0];
		double dSizeBeam[0];
		for (int i = 0; i < _Beam.length(); i++)
		{
			Beam bmThisBeam = _Beam[i];
			if (bmThisBeam.vecX().isCodirectionalTo(el.vecY()))
			{
				Point3d ptSplit = bmThisBeam.ptCen();
				for (int j = 0; j < arBm.length(); j++)
				{
					if (bmThisBeam.envelopeBody().hasIntersection(arBm[j].envelopeBody()))
					{
						ptSplit = Line(arBm[j].ptCen(), arBm[j].vecX()).closestPointTo(ptSplit);
						if (bmBlockingToSplit.find(arBm[j]) == -1)
						{
							bmBlockingToSplit.append(arBm[j]);
						}
						ptListToSplit.append(ptSplit);
						dSizeBeam.append(bmThisBeam.dD(el.vecX()));
					}
				}
			}
		}
		
		int nThisLoop = 0;
		while (nThisLoop < bmBlockingToSplit.length())
		{
			Beam bmToSplitBlocking = bmBlockingToSplit[nThisLoop];
			
			int loopBreak = 0;
			int nCount = 0;
			int nSplit = false;
			
			while (nCount < ptListToSplit.length())
			{
				nSplit = false;
				loopBreak++;
				
				Point3d ptSplit = ptListToSplit[nCount];
				double dBeamSize = dSizeBeam[nCount];
				
				Plane pln(ptSplit, el.vecZ());
				
				PlaneProfile ppBeamToSplit = bmToSplitBlocking.envelopeBody().shadowProfile(pln);
				
				if (ppBeamToSplit.pointInProfile(ptSplit) == _kPointInProfile)
				{
					Beam bmResSplitBlocking = bmToSplitBlocking.dbSplit(ptSplit + (dBeamSize + U(1)) * 0.5 * csEl.vecX(), ptSplit - (dBeamSize + U(1)) * 0.5 * csEl.vecX());
					nSplit = true;
					bmBlockingToSplit.append(bmResSplitBlocking);
				}
				nCount++;
			}
			nThisLoop++;
		}
		
		Entity bmSplit[0];
		Entity bmReturnedFromSplit[0];
		
		for (int i = 0; i < bmToSplitVer.length(); i++)
		{
			Beam bmToSplit = bmToSplitVer[i];
			bmResSplitVer = bmToSplit.dbSplit(ptInsert + dVentH * 0.5 * csEl.vecY(), ptInsert - dVentH * 0.5 * csEl.vecY());
			
			_Map.setEntity("bmToSplit", bmToSplitVer[i]);
			_Map.setEntity("bmSplitted", bmResSplitVer);
			
			
			
			if (bmBelow == bmClBelow || bmBelow == bmBottom) {
				bmToSplitVer[i].dbErase();
			}
			else {
				bmToSplitVer[i].stretchDynamicTo(bmBelow);
			}
			if (bmAbove == bmClAbove || bmAbove == bmTop) {
				bmResSplitVer.dbErase();
			}
			else {
				bmResSplitVer.stretchDynamicTo(bmAbove);
			}
			
			if (bmToSplit.bIsValid() && bmResSplitVer.bIsValid())
			{
				bmSplit.append(bmToSplit);
				bmReturnedFromSplit.append(bmResSplitVer);
			}
		}
		
		_Map.setEntityArray(bmSplit, TRUE, "bmToSplit[]", "", "bmToSplit");
		_Map.setEntityArray(bmReturnedFromSplit, TRUE, "bmSplitted[]", "", "bmSplitted");
	}
	else 
	{
		// nFixed
		if ( (abs(dClLeft) - dVentW * 0.5 - el.dBeamHeight() * 1.5) > 0 ) {
			bmStLeft.dbCreate(ptLC, csEl.vecY(), csEl.vecX(), csEl.vecZ(),
			dVentH / 2, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
			bmStLeft.setColor(nBeamColor);
			bmStLeft.setType(_kStud);
			bmStLeft.setName("STUD");
			bmStLeft.setMaterial(sMaterial);
			bmStLeft.setGrade(sGrade);
			bmStLeft.setInformation("STUD");
			bmStLeft.setLabel(sLabel);
			bmStLeft.setSubLabel(sSublabel);
			bmStLeft.setSubLabel2(sSublabel2);
			if (nModule) bmStLeft.setModule(sModuleName);
			bmStLeft.assignToElementGroup(el, TRUE, 0, 'Z');
			bmStLeft.stretchDynamicTo(bmClAbove);
			bmStLeft.stretchDynamicTo(bmClBelow);
			bmClLeft = bmStLeft;
			bmStLeft.setHsbId(114);
			_Beam.append(bmStLeft);
			_Map.setEntity("bmStLeft", bmStLeft);
		}
		
		if ( (abs(dClRight) - dVentW * 0.5 - el.dBeamHeight() * 1.5) > 0 ) {
			bmStRight.dbCreate(ptRC, csEl.vecY(), csEl.vecX(), csEl.vecZ(),
			dVentH / 2, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
			bmStRight.setColor(nBeamColor);
			bmStRight.setType(_kStud);
			bmStRight.setName("STUD");
			bmStRight.setMaterial(sMaterial);
			bmStRight.setGrade(sGrade);
			bmStRight.setInformation("STUD");
			bmStRight.setLabel(sLabel);
			bmStRight.setSubLabel(sSublabel);
			bmStRight.setSubLabel2(sSublabel2);
			if (nModule) bmStRight.setModule(sModuleName);
			bmStRight.assignToElementGroup(el, TRUE, 0, 'Z');
			bmStRight.stretchDynamicTo(bmClAbove);
			bmStRight.stretchDynamicTo(bmClBelow);
			bmClRight = bmStRight;
			bmStRight.setHsbId(114);
			_Beam.append(bmStRight);
			_Map.setEntity("bmStRight", bmStRight);
		}
		
		// opening is above element
		if ( ! bmClAbove.bIsValid()) {
			if (bmTop.bIsValid()) {
				bmAbove = bmTop;
			}
			else {
				reportNotice("\n"+ scriptName()+" "+T("Beamcode is not valid 1."));
				return;
			}
		}
		// opening is in element and also far enough away from the closest beam above.
		// create a new beam in the element.
		else if ( (abs(dClAbove) - dVentH * 0.5 - el.dBeamHeight() - bmClAbove.dD(csEl.vecY()) * 0.5) > 0 ) {
			bmAbove.dbCreate(ptAboveC, csEl.vecX(), csEl.vecY(), csEl.vecZ(),
			dVentW, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
			bmAbove.setColor(nBeamColor);
			bmAbove.setType(_kSFVent);
			bmAbove.setName(sName);
			bmAbove.setMaterial(sMaterial);
			bmAbove.setGrade(sGrade);
			bmAbove.setInformation(sInformation);
			bmAbove.setLabel(sLabel);
			bmAbove.setSubLabel(sSublabel);
			bmAbove.setSubLabel2(sSublabel2);
			if (nModule) bmAbove.setModule(sModuleName);
			bmAbove.assignToElementGroup(el, TRUE, 0, 'Z');
			bmAbove.stretchDynamicTo(bmClLeft);
			bmAbove.stretchDynamicTo(bmClRight);
			bmAbove.setHsbId(139);
			_Beam.append(bmAbove);
			if (nNoNail)
				bmAbove.setBeamCode("VENT;;0;;;;;;NO;;;;");
			else
				bmAbove.setBeamCode("VENT;;0;;;;;;YES;;;;");
			_Map.setEntity("bmAbove", bmAbove);
			// set bmTop invalid. So the upper part of the beam.dbSplit will not be erased.
			bmTop = Beam();
		}
		else {
			// opening is in element, but too close to the beam above. No extra beam will be placed.
			// set bmAbove equal to bmClAbove. The generated studs will be streched to bmAbove.
			// the upper part of the beam.dbSplit will be erased from the database.
			bmAbove = bmClAbove;
		}
		
		// opening is below element.
		if ( ! bmClBelow.bIsValid()) {
			// check if beam bottom is valid
			if (bmBottom.bIsValid()) {
				bmBelow = bmBottom;
			}
			else {
				reportNotice("\n"+ scriptName()+" "+T("Beamcode is not valid 2."));
				return;
			}
		}
		// opening is in element and also far enough away from the closest beam below.
		// create a new beam in the element.
		else if (bmClBelow.bIsValid() && (abs(dClBelow) - dVentH * 0.5 - el.dBeamHeight() - bmClBelow.dD(csEl.vecY()) * 0.5) > 0 ) {
			bmBelow.dbCreate(ptBelowC, csEl.vecX(), csEl.vecY(), csEl.vecZ(),
			dVentW, el.dBeamHeight(), el.dBeamWidth(), 0, 0, 0);
			bmBelow.setColor(nBeamColor);
			bmBelow.setType(_kSFVent);
			bmBelow.setName(sName);
			bmBelow.setMaterial(sMaterial);
			bmBelow.setGrade(sGrade);
			bmBelow.setInformation(sInformation);
			bmBelow.setLabel(sLabel);
			bmBelow.setSubLabel(sSublabel);
			bmBelow.setSubLabel2(sSublabel2);
			if (nModule) bmBelow.setModule(sModuleName);
			bmBelow.assignToElementGroup(el, TRUE, 0, 'Z');
			bmBelow.stretchDynamicTo(bmClLeft);
			bmBelow.stretchDynamicTo(bmClRight);
			bmBelow.setHsbId(139);
			_Beam.append(bmBelow);
			if (nNoNail)
				bmBelow.setBeamCode("VENT;;0;;;;;;NO;;;;");
			else
				bmBelow.setBeamCode("VENT;;0;;;;;;YES;;;;");
			_Map.setEntity("bmBelow", bmBelow);
			// set bmBottom invalid. So the lower part of the beam.dbSplit will not be erased.
			bmBottom = Beam();
		}
		else {
			// opening is in element, but too close to the beam below. No extra beam will be placed.
			// set bmBelow equal to bmClBelow. The generated studs will be streched to bmBelow.
			// the lower part of the beam.dbSplit will be erased from the database.
			bmBelow = bmClBelow;
		}
//		for (int i = 0; i < bmToSplitVer.length(); i++) {
//			bmToSplitVer[i].dbErase();
//		}
		
		Entity bmSplit[0];
		Entity bmReturnedFromSplit[0];
		
		for (int i = 0; i < bmToSplitVer.length(); i++)
		{
			Beam bmToSplit = bmToSplitVer[i];
			bmResSplitVer = bmToSplit.dbSplit(ptInsert + dVentH * 0.5 * csEl.vecY(), ptInsert - dVentH * 0.5 * csEl.vecY());
			
			_Map.setEntity("bmToSplit", bmToSplitVer[i]);
			_Map.setEntity("bmSplitted", bmResSplitVer);
			
			
			
			if (bmBelow == bmClBelow || bmBelow == bmBottom) {
				bmToSplitVer[i].dbErase();
			}
			else {
				bmToSplitVer[i].stretchDynamicTo(bmBelow);
			}
			if (bmAbove == bmClAbove || bmAbove == bmTop) {
				bmResSplitVer.dbErase();
			}
			else {
				bmResSplitVer.stretchDynamicTo(bmAbove);
			}
			
			if (bmToSplit.bIsValid() && bmResSplitVer.bIsValid())
			{
				bmSplit.append(bmToSplit);
				bmReturnedFromSplit.append(bmResSplitVer);
			}
		}
		
		_Map.setEntityArray(bmSplit, TRUE, "bmToSplit[]", "", "bmToSplit");
		_Map.setEntityArray(bmReturnedFromSplit, TRUE, "bmSplitted[]", "", "bmSplitted");
		
	}
	// HSB-19318 create jacks and bracings
	{ 
		// get left right stud
		Entity entBmAbove=_Map.getEntity("bmAbove");
		if(entBmAbove.bIsValid())
		{
			bmAbove=(Beam)entBmAbove;
		}
		Entity entBmBelow=_Map.getEntity("bmBelow");
		if(entBmBelow.bIsValid())
		{
			bmBelow=(Beam)entBmBelow;
		}
		// none,top,bottom,both
		Beam beamsAll[] = el.beam();
		// space below
		Beam bmBottBelow;
		Beam bmTopBelow=bmBelow;
		// space above
		Beam bmBottAbove=bmAbove;
		Beam bmTopAbove;
			
		// top or both
		// get the top beam for the top bracing
		Point3d ptAbove=bmAbove.ptCen()
			+bmAbove.vecD(csEl.vecY())*(.5*bmAbove.dD(csEl.vecY())+U(1));
		
		Plane pnMid(bmAbove.ptCen(),csEl.vecX());
		
		Beam beamsTop[]=Beam().filterBeamsHalfLineIntersectSort(beamsAll,ptAbove,csEl.vecY());
		if(beamsTop.length()==0)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|Bracing not possible|"));
			eraseInstance();
			return;
		}
		Beam bmT=beamsTop.first();
		bmTopAbove=bmT;
		if(nBracing==1 || nBracing==3)
		{
			Point3d ptBm=bmT.ptCen()-bmT.vecD(csEl.vecY())*.5*bmT.dD(csEl.vecY());
			int bIntersect=Line(ptBm,bmT.vecX()).hasIntersection(pnMid,ptBm);
			Vector3d vxBm=bmT.vecX();
			Vector3d vyBm=bmT.vecD(-csEl.vecY());
			Vector3d vzBm=vxBm.crossProduct(vyBm);vzBm.normalize();
			Beam bmNew;
			bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, U(10), bmT.dD(vyBm), bmT.dD(vzBm), 0, 1, 0);
			bmNew.setColor(nBeamColor);
			bmNew.setType(_kBrace);
			bmNew.setMaterial(sMaterial);
			bmNew.setGrade(sGrade);
			bmNew.setInformation(sInformation);
			bmNew.setLabel(sLabel);
			bmNew.setSubLabel(sSublabel);
			bmNew.setSubLabel2(sSublabel2);
			if (nModule) bmNew.setModule(sModuleName);
			bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
			
			bmNew.stretchDynamicTo(bmClLeft);
			bmNew.stretchDynamicTo(bmClRight);
			bmTopAbove=bmNew;
			_Beam.append(bmNew);
			_Map.setEntity("bmBracingAbove", bmNew);
		}	

	// bottom or both
	// bottom 
	 
		Point3d ptBelow=bmBelow.ptCen()
			-bmBelow.vecD(csEl.vecY())*(.5*bmBelow.dD(csEl.vecY())+U(1));
		
		pnMid=Plane (bmBelow.ptCen(),csEl.vecX());
		Beam beamsBelow[]=Beam().filterBeamsHalfLineIntersectSort(beamsAll,ptBelow,-csEl.vecY());
		Beam bmB=beamsBelow.first();
		bmBottBelow=bmB;
		if(nBracing==2 || nBracing==3)	
		{
			Point3d ptBm=bmB.ptCen()+bmB.vecD(csEl.vecY())*.5*bmB.dD(csEl.vecY());
			int bIntersect=Line(ptBm,bmB.vecX()).hasIntersection(pnMid,ptBm);
			Vector3d vxBm=bmB.vecX();
			Vector3d vyBm=bmB.vecD(csEl.vecY());
			Vector3d vzBm=vxBm.crossProduct(vyBm);vzBm.normalize();
			Beam bmNew;
			bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, U(10), bmB.dD(vyBm), bmB.dD(vzBm), 0, 1, 0);
			bmNew.setColor(nBeamColor);
			bmNew.setType(_kBrace);
			bmNew.setMaterial(sMaterial);
			bmNew.setGrade(sGrade);
			bmNew.setInformation(sInformation);
			bmNew.setLabel(sLabel);
			bmNew.setSubLabel(sSublabel);
			bmNew.setSubLabel2(sSublabel2);
			if (nModule) bmNew.setModule(sModuleName);
			bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
			bmNew.stretchDynamicTo(bmClLeft);
			bmNew.stretchDynamicTo(bmClRight);
			bmBottBelow=bmNew;
			_Beam.append(bmNew);
			_Map.setEntity("bmBracingBelow", bmNew);
		}
		if(nJacks==1 || nJacks==3) 
		{ 
			// top jacks
			Point3d ptM=.5*(bmBottAbove.ptCen()+bmTopAbove.ptCen());
			// left
			Point3d ptBm=bmClLeft.ptCen()+bmClLeft.vecD(csEl.vecX())*.5*bmClLeft.dD(csEl.vecX());
			ptBm+=csEl.vecY()*csEl.vecY().dotProduct(ptM-ptBm);
			
			// create left
			Vector3d vxBm=bmClLeft.vecX();
			Vector3d vyBm=bmClLeft.vecD(csEl.vecX());
			Vector3d vzBm=vxBm.crossProduct(vyBm);vzBm.normalize();
			Beam bmNew;
			bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, U(10), bmClLeft.dD(vyBm), bmClLeft.dD(vzBm), 0, 1, 0);
			bmNew.setColor(nBeamColor);
			bmNew.setType(_kSFJackOverOpening);
			bmNew.setMaterial(sMaterial);
			bmNew.setGrade(sGrade);
			bmNew.setInformation(sInformation);
			bmNew.setLabel(sLabel);
			bmNew.setSubLabel(sSublabel);
			bmNew.setSubLabel2(sSublabel2);
			if (nModule) bmNew.setModule(sModuleName);
			bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
			bmNew.stretchDynamicTo(bmBottAbove);
			bmNew.stretchDynamicTo(bmTopAbove);
			_Beam.append(bmNew);
			_Map.setEntity("bmJackLeftAbove", bmNew);
			
			ptBm=bmClRight.ptCen()-bmClRight.vecD(csEl.vecX())*.5*bmClRight.dD(csEl.vecX());
			ptBm+=csEl.vecY()*csEl.vecY().dotProduct(ptM-ptBm);
			
			// create right
			vxBm=bmClRight.vecX();
			vyBm=bmClRight.vecD(csEl.vecX());
			vzBm=vxBm.crossProduct(vyBm);vzBm.normalize();
			
			bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, U(10), bmClRight.dD(vyBm), bmClRight.dD(vzBm), 0, -1, 0);
			bmNew.setColor(nBeamColor);
			bmNew.setType(_kSFJackOverOpening);
			bmNew.setMaterial(sMaterial);
			bmNew.setGrade(sGrade);
			bmNew.setInformation(sInformation);
			bmNew.setLabel(sLabel);
			bmNew.setSubLabel(sSublabel);
			bmNew.setSubLabel2(sSublabel2);
			if (nModule) bmNew.setModule(sModuleName);
			bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
			bmNew.stretchDynamicTo(bmBottAbove);
			bmNew.stretchDynamicTo(bmTopAbove);
			_Beam.append(bmNew);
			_Map.setEntity("bmJackRightAbove", bmNew);
		}
		if(nJacks==2 || nJacks==3)
		{ 
			// bottom jacks
			Point3d ptM=.5*(bmBottBelow.ptCen()+bmTopBelow.ptCen());
			
			// left
			Point3d ptBm=bmClLeft.ptCen()+bmClLeft.vecD(csEl.vecX())*.5*bmClLeft.dD(csEl.vecX());
			ptBm+=csEl.vecY()*csEl.vecY().dotProduct(ptM-ptBm);
			
			// create left
			Vector3d vxBm=bmClLeft.vecX();
			Vector3d vyBm=bmClLeft.vecD(csEl.vecX());
			Vector3d vzBm=vxBm.crossProduct(vyBm);vzBm.normalize();
			Beam bmNew;
			bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, U(10), bmClLeft.dD(vyBm), bmClLeft.dD(vzBm), 0, 1, 0);
			bmNew.setColor(nBeamColor);
			bmNew.setType(_kSFJackUnderOpening);
			bmNew.setMaterial(sMaterial);
			bmNew.setGrade(sGrade);
			bmNew.setInformation(sInformation);
			bmNew.setLabel(sLabel);
			bmNew.setSubLabel(sSublabel);
			bmNew.setSubLabel2(sSublabel2);
			if (nModule) bmNew.setModule(sModuleName);
			bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
			bmNew.stretchDynamicTo(bmBottBelow);
			bmNew.stretchDynamicTo(bmTopBelow);
			_Beam.append(bmNew);
			_Map.setEntity("bmJackLeftBelow", bmNew);
			
			ptBm=bmClRight.ptCen()-bmClRight.vecD(csEl.vecX())*.5*bmClRight.dD(csEl.vecX());
			ptBm+=csEl.vecY()*csEl.vecY().dotProduct(ptM-ptBm);
			
			// create right
			vxBm=bmClRight.vecX();
			vyBm=bmClRight.vecD(csEl.vecX());
			vzBm=vxBm.crossProduct(vyBm);vzBm.normalize();
			
			bmNew.dbCreate(ptBm, vxBm, vyBm, vzBm, U(10), bmClRight.dD(vyBm), bmClRight.dD(vzBm), 0, -1, 0);
			bmNew.setColor(nBeamColor);
			bmNew.setType(_kSFJackUnderOpening);
			bmNew.setMaterial(sMaterial);
			bmNew.setGrade(sGrade);
			bmNew.setInformation(sInformation);
			bmNew.setLabel(sLabel);
			bmNew.setSubLabel(sSublabel);
			bmNew.setSubLabel2(sSublabel2);
			if (nModule) bmNew.setModule(sModuleName);
			bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
			bmNew.stretchDynamicTo(bmBottBelow);
			bmNew.stretchDynamicTo(bmTopBelow);
			_Beam.append(bmNew);
			_Map.setEntity("bmJackRightBelow", bmNew);
		}
	}
	
	TslInst tslAll[]=el.tslInstAttached();
	for (int t=0; t<tslAll.length(); t++)
	{
		TslInst tslNew=tslAll[t];
		if (!tslNew.bIsValid()) continue;
		if ( tslNew.scriptName() == "hsb_Apply Naillines to Elements")
		{
			tslNew.recalcNow();
		}
		if ( tslNew.scriptName() == "hsb_FrameNailing")
		{
			tslNew.recalcNow("Reapply Frame Nails");
		}
	}
}
// ***
// End creating beams.
// ***

//region HSB-24636: Batten Splits
	for (int bt=0;bt<2;bt++)
	{ 
		String key = "SplitBatten" + bt;
		String painter = bt == 0 ? sSplitBattenBottom : sSplitBattenTop;
		String painterName = bt == 0 ? sSplitBattenBottomName : sSplitBattenTopName;
		
		
		Map mapX = _ThisInst.subMapX(key);

	// join existing
		int bRun = (_bOnDbCreated || _kNameLastChangedProp == "_Pt0" || _kNameLastChangedProp == painterName || (_bOnElementConstructed && el.sheet().length()>0));// || bDebug
		//reportNotice("\nRun " +painterName +" "+ bRun);

		if (bRun)//&& ents.length()>0 && mapX.hasPlaneProfile("ppX"))
		{ 
			Entity ents[] = mapX.getEntityArray("Sheet[]", "", "Sheet");
			PlaneProfile ppX = mapX.getPlaneProfile("ppX");
			PLine rings[] = ppX.allRings(true, false);
			ppX.shrink(-dEps);
			Sheet sheets[0];
			
			//reportNotice("\n   " + ents.length() + " sheets to be joined" );
			for (int i=0;i<ents.length();i++) 
			{ 
				Sheet sheet = (Sheet)ents[i];
				if (!sheet.bIsValid()){ continue;}
				PlaneProfile ppSheet(sheet.plEnvelope());				
				for (int r=0;r<rings.length();r++) 
				{ 
					PlaneProfile pp(rings[r]);
					pp.shrink(-dEps);
					if (pp.intersectWith(ppSheet))
					{ 
						sheet.joinRing(rings[r],_kAdd);	
						ppSheet.joinRing(rings[r],_kAdd);
					}	 
				}//next r
				sheets.append(sheet);				 
			}//next i
			
			if (sheets.length() >1)
			{ 
				//reportNotice("\n   joining " + sheets.length() );
				Sheet sheet = sheets[0];
				for (int i=1;i<sheets.length();i++) 
				{ 
					sheet.dbJoin(sheets[i]);
					 
				}//next i	
				
				mapX.removeAt("Sheet[]", true);
				mapX.removeAt("ppX", true);
				
			}
		}
		else if (!_bOnElementDeleted)
		{ 
			continue;
		}
		
		if ((painter == kDisabled && _kNameLastChangedProp == painterName) || _bOnElementDeleted)
		{
			//reportNotice("\n   removing " + painterName);
			_ThisInst.removeSubMapX(key);
			continue;
		}

		PainterDefinition pd(kPainterCollection+painter);
		Sheet sheets[]=pd.filterAcceptedEntities(el.sheet());
		if (sheets.length() < 1){continue;}	
		
	// get zone
		Sheet sheet = sheets.first();
		int zoneIndex = sheet.myZoneIndex();
		ElemZone zone = el.zone(zoneIndex);
		Vector3d vecZZ = zone.vecZ();
		Vector3d vecY=el.vecY();
		Vector3d vecX=el.vecX();
		Point3d ptRef=_Pt0;
		Plane pnHor(el.ptOrg(), el.vecY());
		CoordSys cs(zone.ptOrg(), vecY.crossProduct(vecZZ), vecY, vecZZ);
		//cs.vis(2);
		Plane pnZone(zone.ptOrg(), vecZZ);
		PlaneProfile ppSub;
		ppSub.createRectangle(LineSeg(ptRef - vecX * U(50), ptRef + vecX * U(50) + vecY * (bt==0?-1:1)*U(10e4)), vecX,vecY);
		ppSub.vis(bt);

	// get intersecting sheets
		Sheet sheetsX[0];
		PlaneProfile ppX(cs);
		for (int i=0;i<sheets.length();i++) 
		{ 
			
//			PlaneProfile pp(cs);
			Body bd = sheets[i].envelopeBody();
			// HSB-15195
			PlaneProfile ppHorBd=bd.shadowProfile(pnHor);
			// get extents of profile
			LineSeg segHorBd = ppHorBd.extentInDir(vecZZ);
			Point3d ptOrgSheet = segHorBd.ptStart();
			CoordSys csSheet(ptOrgSheet, vecY.crossProduct(vecZZ), vecY, vecZZ);
			PlaneProfile pp(csSheet);
			
			pp.unionWith(bd.shadowProfile(pnZone)); // found some oddities in the sample dwg: the top battens were defined with an invalid coordSys
			
			if(!sheets[i].vecZ().isParallelTo(vecZZ))
			{ 
				Sheet bad = sheets[i];
				Sheet new;
				new.dbCreate(pp, bd.lengthInDirection(vecZZ), 1);
				new.setColor(bad.color());
				new.setName(bad.name());
				new.setLabel(bad.label());
				new.setMaterial(bad.material());
				new.assignToElementGroup(el, true, zoneIndex, 'Z');
				sheets[i] = new;
				bad.dbErase();
			}
			
			int bOk=pp.intersectWith(ppSub);	
			if (pp.area()>pow(dEps,2))
			{ 
				ppX.unionWith(pp);
				sheetsX.append(sheets[i]);
			}
		}//next i	
		
		//reportNotice("\n   found " + sheetsX.length() + " to be splitted by ppX " + ppX.area());
		ppX.vis(3);
		
		if (bDebug){ continue;}
	// split
		Sheet newSheets[0];
		PLine rings[] = ppX.allRings(true, false);
		for (int r=0;r<rings.length();r++) 
			for (int i=0;i<sheetsX.length();i++) 
			{
				newSheets.append(sheetsX[i].joinRing(rings[r], _kSubtract));
				newSheets.append(sheetsX[i]);
			}
		
		//reportNotice("\n   storing " + newSheets.length() + " in " + painterName);
		mapX.setEntityArray(newSheets, false,"Sheet[]", "", "Sheet");
		mapX.setPlaneProfile("ppX",ppX);
		_ThisInst.setSubMapX(key, mapX);			
	}//next bt
//endregion 


//Display information in Production Controler
Display dpToDXA(1);
dpToDXA.elemZone(el, 1, 'E');
dpToDXA.showInDxa(true);
dpToDXA.showInTslInst(_bOnDebug);
dpToDXA.draw(plDisplay);
dpToDXA.draw(plCross1);
dpToDXA.draw(plCross2);
dpToDXA.draw(text, lsForMidPoint.ptMid(), csEl.vecX(), csEl.vecY(), 0, 0);

//Export to the dbase and hsbBOM
String sCompareKey = (String) sFormat;
setCompareKey(sCompareKey);

String sQty="1";
exportToDxi(TRUE);
dxaout("Electrical", "");
dxaout("U_MODEL",sFormat);
dxaout("U_QUANTITY",sQty);

//_ThisInst.assignToElementGroup(el, true, 0, 'E');

//For debugging only
//Show beams and sheeting
/*
Beam arBms[] = el.beam();
Sheet arShs[] = el.sheet();
if(_bOnDebug){
  dp.color(32);
  for(int i=0;i<arBms.length();i++){
    dp.draw(Body(arBms[i].realBody()));
  }
  dp.color(3);
  for(int i=0;i<arShs.length();i++){
    dp.draw(Body(arShs[i].realBody()));
  }
}
*/


//Add dimlines
//Array of points to dimension
//Point3d arPnts[0];
//points to dimension
//Point3d ptDim1 = ptInsert - csEl.vecY() * csEl.vecY().dotProduct(ptInsert - csEl.ptOrg());
//Point3d ptDim2 = ptDim1 + csEl.vecY() * dHeight;
//add them to the array
//arPnts.append(ptDim1);
//arPnts.append(ptDim2);
//Define the dimline
//DimLine dLine(ptInsert + csEl.vecX() * (0.5 * dVentW + U(200, 8)), csEl.vecY(), -csEl.vecX());
//Dim dim(dLine, arPnts,"<>","<>",_kDimDelta);
//dp.dimStyle(sDimStyle);
//dp.elemZone(el, 0, 'D');
//dp.draw(dim);

/*
//Display dp(-1);
dp.dimStyle(sDimStyle);
String str = ("Vent");
String str1 = (dHeight);
String str2 = (dVentW);
String str3 = (dVentH);
//String str = scriptName();
Point3d pt = _Pt0;
Vector3d vecRead = csEl.vecX();
Vector3d vecUp = csEl.vecZ();
dp.draw(str, pt, vecRead, - vecUp, 0,-3 );
dp.draw(str1, pt, vecRead, - vecUp, 0,-6 );
dp.draw(str,_Pt0,csEl.vecX(), csEl.vecY(),0,9);
dp.draw("Ho "+str1,_Pt0,csEl.vecX(), csEl.vecY(),0,6);
*/

















#End
#BeginThumbnail
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
C!1110`4444`%%%%`!1110`4444`%*GWU^M)2I]]?K3`__]E1
`



































#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="4047" />
        <int nm="BreakPoint" vl="4067" />
        <int nm="BreakPoint" vl="4101" />
        <int nm="BreakPoint" vl="4125" />
        <int nm="BreakPoint" vl="3949" />
        <int nm="BreakPoint" vl="2392" />
        <int nm="BreakPoint" vl="1775" />
        <int nm="BreakPoint" vl="3706" />
        <int nm="BreakPoint" vl="1053" />
        <int nm="BreakPoint" vl="1090" />
        <int nm="BreakPoint" vl="3741" />
        <int nm="BreakPoint" vl="1380" />
        <int nm="BreakPoint" vl="1471" />
        <int nm="BreakPoint" vl="1708" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="20251127: Consider the case when vertical batten need to be splitted" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="35" />
      <str nm="Date" vl="11/27/2025 4:36:14 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="20251127: Implement onDbErase" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="34" />
      <str nm="Date" vl="11/27/2025 2:22:10 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="20251127: At the zone before battens create beams with width of zone 0" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="33" />
      <str nm="Date" vl="11/27/2025 9:28:07 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24636: Add property to cut top or/and bottom service batten" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="32" />
      <str nm="Date" vl="11/6/2025 12:55:07 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22709: At the batten zone use 4 beams to create the vent for round and rectangular" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="31" />
      <str nm="Date" vl="11/6/2025 10:31:22 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22709: Add option &quot;As beams solid for rounding vent&quot;" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="30" />
      <str nm="Date" vl="10/10/2025 4:55:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22709: Add option &quot;As beams&quot; at property Batten" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="29" />
      <str nm="Date" vl="7/1/2025 9:30:25 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19318: Capture error when jacks not possible" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="28" />
      <str nm="Date" vl="6/27/2025 10:14:00 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19318: Add properties for bracing and jacks" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="27" />
      <str nm="Date" vl="6/26/2025 8:12:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add locating plate as beamtype to avoid" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="26" />
      <str nm="Date" vl="7/18/2024 1:45:29 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17870 Element validation added" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="25" />
      <str nm="Date" vl="2/14/2023 8:37:28 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11217: created battens should not exceed boundaries of existing battens" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="23" />
      <str nm="Date" vl="11/25/2021 5:14:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11217: Dont consider beams in sheet zones" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="22" />
      <str nm="Date" vl="4/23/2021 2:20:54 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End