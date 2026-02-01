#Version 8
#BeginDescription
Last modified by: Robert Pol (robert.pol@hsbcad.com)
22.01.2018  -  version 1.03







#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl places an angled iron at the t-connection of the two selected beams
/// </summary>

/// <insert>
/// Select two beams
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="1.03" date="22.01.2018"></version>

/// <history>
/// AS - 1.00 - 10.03.2009 	- Pilot version
/// AS - 1.01 - 27.10.2014 	- Add thumbnail, set categories and descriptions
/// AS - 1.02 - 22.12.2016 	- Export angle as hardware.
/// RP - 1.03 - 22.01.2018 	- Add visualisation
/// </history>

//Epsylon value; units used in tsl are mm
double dEps = Unit(.01,"mm");

//Sizes
//Lengths
PropDouble dMPLength1(0, U(100), T("|Length 1|"));
dMPLength1.setDescription(T("|Sets the length of the angle along the male beam.|"));
dMPLength1.setCategory(T("|Angle Iron|"));
PropDouble dMPLength2(1, U(100), T("|Length 2|"));
dMPLength2.setDescription(T("|Sets the length of the angle along the female beam.|"));
dMPLength2.setCategory(T("|Angle Iron|"));
//Width
PropDouble dMPWidth(2, U(50), T("|Width|"));
dMPWidth.setDescription(T("|Sets the width of the angle.|"));
dMPWidth.setCategory(T("|Angle Iron|"));
//Thickness
PropDouble dMPThickness(3, U(8), T("|Thickness|"));
dMPThickness.setDescription(T("|Sets the thickness of the angle.|"));
dMPThickness.setCategory(T("|Angle Iron|"));


//Position rod
PropDouble dXRod(4, U(50), T("|Position rod|"));
dXRod.setDescription(T("|Sets the position of the rod.|"));
dXRod.setCategory(T("|Rod|"));

//Diameter rod
PropDouble dDiamRod(5, U(10), T("|Diameter rod|"));
dDiamRod.setDescription(T("|Sets the diamter of the rod.|") + 
								TN("|Zero means no rod|"));
dDiamRod.setCategory(T("|Rod|"));

//Article number
PropString sArticleNumber(0, "", T("|Articlenumber|"));
sArticleNumber.setDescription(T("|Sets the article number of the angle.|"));
sArticleNumber.setCategory(T("|Export data|"));

//Description
PropString sDescription(2, "", T("|Description|"));
sDescription.setDescription(T("|Sets the description of the angle.|"));
sDescription.setCategory(T("|Export data|"));

//Material
PropString sMaterial(3, "", T("|Material|"));
sMaterial.setDescription(T("|Sets the material of the angle.|"));
sMaterial.setCategory(T("|Export data|"));

//Side
String arSYesNo[] = {T("|Yes|"),T("|No|")};
String arSNoYes[] = {T("|No|"),T("|Yes|")};
int arNSide[] = {-1, 1};
PropString sSwapSide(1, arSYesNo, T("|Flip side|"),1);
sSwapSide.setDescription(T("|Swaps the position.|"));
sSwapSide.setCategory(T("|Position|"));


String arSZoneLayer[] = 
{
	"Tooling",
	"Information",
	"Zone",
	"Element"
};
char arChZoneCharacter[] = {
	'T',
	'I',
	'Z',
	'E'
};
int zones[] = {
	-5,
	-4,
	-3,
	-2,
	-1,
	0,
	1,
	2,
	3,
	4,
	5
};
int zonesOld[] = {
	10,
	9,
	8,
	7,
	6,
	0,
	1,
	2,
	3,
	4,
	5
};
PropString addToElement(2, arSNoYes, T("|Add to element|"),1);
addToElement.setDescription(T("|Add tsl to elementgroup|"));
addToElement.setCategory(T("|Visualisation|"));

PropString characterLayer(3, arSZoneLayer, T("|Layer char|"),1);
characterLayer.setDescription(T("|Sets the layer of the tsl|"));
characterLayer.setCategory(T("|Visualisation|"));

PropInt zoneLayer(4, zonesOld, T("|Layer zone|"),1);
zoneLayer.setDescription(T("|Sets the zone layer of the tsl|"));
zoneLayer.setCategory(T("|Visualisation|"));


String arSAddHardwareEvent[] = 
{
	T("|Articlenumber|"),
	T("|Description|"),
	T("|Material|")
};

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-AngleIron");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount()>1 ){
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
	
	PrEntity ssE(T("|Select first beam(s)|"), Beam());
	if( ssE.go() ){
		Beam arBmMale[] = ssE.beamSet();
		Beam bmFemale = getBeam(T("|Select second beam|"));
		
		String strScriptName = "HSB_E-AngleIron"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[2];
		
		lstBeams[1] = bmFemale;
		Element lstElements[0];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", TRUE);
		setCatalogFromPropValues("MasterToSatellite");
		
		for( int i=0;i<arBmMale.length();i++ ){
			Beam bmMale = arBmMale[i];
			
			lstBeams[0] = bmMale;
			
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
		_Map.removeAt("MasterToSatellite", TRUE);
	}
}
int nSide = arNSide[arSYesNo.find(sSwapSide,1)];

//Display
Display dp(-1);

//Beams
Beam bm0 = _Beam0;
Beam bm1 = _Beam1;

//Element
Element el = bm0.element();
if (addToElement == T("|Yes|") && el.bIsValid())
{
	int zone = zones[zonesOld.find(zoneLayer)];
	char character = arChZoneCharacter[arSZoneLayer.find(characterLayer)];
	assignToElementGroup(el, true, zone, character);
}
//CoordSys element
CoordSys csEl = el.coordSys();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

//CoordSys
Vector3d vxMP = _Z1;
Vector3d vzMP = _Y1;
if( vzEl.dotProduct(vzMP) < 0 )
	vzMP = -vzMP;
Vector3d vyMP = vzMP.crossProduct(vxMP) * nSide;

//Insertion point of metalpart
Point3d ptMP = _Pt0 + vyMP * .5 * bm0.dD(vyMP);// + vzMP * U(100);
ptMP.vis();

//Metalpart
Body bd1(ptMP, vxMP, vyMP, vzMP, dMPLength1, dMPThickness, dMPWidth, -1, 1, 0);
Body bd2(ptMP, vyMP, -vxMP, vzMP, dMPLength1, dMPThickness, dMPWidth, 1, 1, 0);
Point3d ptRod1 = ptMP - vxMP * dXRod + vyMP * .5 * dMPThickness;
Point3d ptRod2 = ptMP + vyMP * dXRod - vxMP * .5 * dMPThickness;


//Draw metalpart
Body bdMP = bd1;
bdMP.addPart(bd2);
if( dDiamRod > 0 ){
	Body bdRod(ptRod1, ptRod2, .5 * dDiamRod);
	bdMP.addPart(bdRod);
}
dp.draw(bdMP);

// Set flag to create hardware.
int bAddHardware = _bOnDbCreated;
if (_ThisInst.hardWrComps().length() == 0)
	bAddHardware = true;
if (arSAddHardwareEvent.find(_kNameLastChangedProp) != -1)
	bAddHardware = true;

// add hardware if model has changed or on creation
if (bAddHardware) {
	// declare hardware comps for data export
	HardWrComp hwComps[0];
  	HardWrComp hw(sArticleNumber, 1);
	
	hw.setCategory(T("|Steel|"));
	hw.setManufacturer("");
	hw.setModel(sArticleNumber);
	hw.setMaterial(sMaterial);
	hw.setDescription(sDescription);
	hw.setNotes("");
	
	hw.setDScaleX(0);
	hw.setDScaleY(0);
	hw.setDScaleZ(0); 
	hwComps.append(hw);

	_ThisInst.setHardWrComps(hwComps);
}

#End
#BeginThumbnail
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
G`,`#``IU%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!__9
`




#End