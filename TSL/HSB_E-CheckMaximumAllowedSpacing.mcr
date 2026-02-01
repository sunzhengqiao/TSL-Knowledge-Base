#Version 8
#BeginDescription
Last modified by: Robert Pol (robert.pol@hsbcad.com)
05.08.2016  -  version 1.04

This tsl checks the spacing between vertical beams and can add beams/ color beams that exceed the allowed spacing
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl checks the maximum spacing
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.04" date="05.08.2016"></version>

/// <history>
/// AS - 1.00 - 22.04.2015	- Pilot version
/// RP - 1.01 - 24.02.2016   - Add message when spacing is not exceeded, add studs when maxspacing is exceeded
/// RP - 1.02 - 25.02.2016   - Add colors
/// RP - 1.03 - 26.02.2016   - Add options to skip some properties
/// RP - 1.04 - 05.08.2016   - Add display instead of colour and a filter
/// </history>

double dEps = Unit(0.01,"mm");

String categories[] = {
	T("|General|"),
	T("|Dimensions|"),
	T("|Color|")
};

String arSAddBeams[] = {
	T("|Yes|"),
	T("|No|")
};

PropInt sequenceNumber(0, 0, T("|Sequence number|"));
sequenceNumber.setCategory(categories[0]);
sequenceNumber.setDescription(T("|The sequence number is used to sort the list of tsl's during generate construction|"));
PropString sFilterBC(6,"",T("|Filter beams with beamcode|"));
sFilterBC.setCategory(categories[0]);
sFilterBC.setDescription(T("|Specify beamcode's that can be excluded from the calculation|"));
PropDouble dMaximumAllowedSpacing(1, U(600), T("|Maximum allowed spacing|"));
dMaximumAllowedSpacing.setCategory(categories[1]);
dMaximumAllowedSpacing.setDescription(T("|This is the maximum spacing allowed between vertical beams|"));
PropString SAddBeams(2,  arSAddBeams, ""+T("|Automatic add Studs|"),1);
SAddBeams.setCategory(categories[1]);
SAddBeams.setDescription(T("|Automaticaaly add vertical beams until the maimum spacing is not exceeded|"));
PropInt nWrongBeamColor(4, 1, T("|Color of the wrong beam|"));
nWrongBeamColor.setCategory(categories[2]);
nWrongBeamColor.setDescription(T("|Sets the color of all the beams that are at an incorrect spacing distance|"));
PropInt nAddedBeamColor(5, 3, T("|Color of the added beam|"));
nAddedBeamColor.setCategory(categories[2]);
nAddedBeamColor.setDescription(T("|Sets the color of all the beams that are added|"));


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-CheckMaximumAllowedSpacing");
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
	PrEntity ssEl(T("Select a set of elements"), Element());
	if( ssEl.go() ){
		arSelectedElement.append(ssEl.elementSet());
	}
	
	String strScriptName = "HSB_E-CheckMaximumAllowedSpacing"; // name of the script
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Element lstElements[1];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("MasterToSatellite", true);
	setCatalogFromPropValues("MasterToSatellite");
	
	for( int e=0;e<arSelectedElement.length();e++ ){
		Element el = arSelectedElement[e];
		lstElements[0] = el;

		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	}
	
	eraseInstance();
	return;
}

int bOnManualInsert = false;
if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", true);
	}
	
	bOnManualInsert = true;
}

if( _Element.length() == 0 ){
	reportNotice("\n" + scriptName() + TN("|No element selected|!"));
	eraseInstance();
	return;
}

Element el = _Element[0];
if( !el.bIsValid() ){
	reportNotice("\n" + scriptName() + TN("|Invalid element found|!"));
	eraseInstance();
	return;
}

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();

_Pt0 = ptEl;

	// Vector tolerance.
	double vectorTolerance = U(0.01);

	// All beams from the element.
	Beam beams[] = el.beam();
	// An empty array which we will use to store the non vertical beams.
	Beam nonVerticalBeams[0];
	Beam VerticalBeams[0];
	for (int b=0;b<beams.length();b++) {
		Beam bm = beams[b];
		
		String sFBC = sFilterBC + ";";
		String arSExcludeBC[0];
		int nIndexBC = 0; 
		int sIndexBC = 0;
		while(sIndexBC < sFBC.length()-1){
			String sTokenBC = sFBC.token(nIndexBC);
			nIndexBC++;
			if(sTokenBC.length()==0){
				sIndexBC++;
				continue;
			}
			sIndexBC = sFBC.find(sTokenBC,0);
			sTokenBC.trimLeft();
			sTokenBC.trimRight();
			arSExcludeBC.append(sTokenBC);
		}
			String sBmCode = bm.beamCode().token(0);
			sBmCode.trimLeft();
			sBmCode.trimRight();
		
			int bExcludeGenBeam = false;
		
			if( arSExcludeBC.find(sBmCode)!= -1 ){
				bExcludeGenBeam = true;
			}
			else{
				for( int j=0;j<arSExcludeBC.length();j++ ){
					String sExclBC = arSExcludeBC[j];
					String sExclBCTrimmed = sExclBC;
					sExclBCTrimmed.trimLeft("*");
					sExclBCTrimmed.trimRight("*");
					if( sExclBCTrimmed == "" ){
						if( sExclBC == "*" && sBmCode != "" )
							bExcludeGenBeam = true;
						else
							continue;
					}
					else{
						if( sExclBC.left(1) == "*" && sExclBC.right(1) == "*" && sBmCode.find(sExclBCTrimmed, 0) != -1 )
							bExcludeGenBeam = true;
						else if( sExclBC.left(1) == "*" && sBmCode.right(sExclBC.length() - 1) == sExclBCTrimmed )
							bExcludeGenBeam = true;
						else if( sExclBC.right(1) == "*" && sBmCode.left(sExclBC.length() - 1) == sExclBCTrimmed )
							bExcludeGenBeam = true;
					}
				}
			}
			if( bExcludeGenBeam)
				continue;

	int isHorizontalBeam = false;
	int isVerticalBeam = false;
	// Its an horizontal beam if it is alligned with the element x vector.
	if (abs(abs(bm.vecX().dotProduct(el.vecX())) - 1) < vectorTolerance){
	isHorizontalBeam = true;
	}
	// Its a vertical beam if it is alligned with the element y vector.
	if (abs(abs(bm.vecX().dotProduct(el.vecY())) - 1) < vectorTolerance){
	isVerticalBeam = true;
	}

	// Store it if the beam is not vertical.
	if (!isVerticalBeam){
	nonVerticalBeams.append(bm);
	}
	
	else{
	VerticalBeams.append(bm);
	}
}
	// Store if the beam is vertical.
	Beam arBmVerticalSort[] = vxEl.filterBeamsPerpendicularSort(VerticalBeams);
	
Display dpError(1);
int bMaxExceeded = false;

for (int i=0;i<(arBmVerticalSort.length() - 1);i++) {
	Beam bmThis = arBmVerticalSort[i];
	Beam bmNext = arBmVerticalSort[i+1];

	Point3d ptThis = bmThis.ptCen() + bmThis.vecD(vxEl) * 0.5 * bmThis.dD(vxEl);
	Point3d ptNext = bmNext.ptCen() - bmNext.vecD(vxEl) * 0.5 * bmNext.dD(vxEl);
	double dSpacing = vxEl.dotProduct(ptNext - ptThis);
	
	Display thisBeamdp(nWrongBeamColor);
	Display nextBeamdp(nWrongBeamColor);
	
	Body thisbeambody = bmThis.realBody();
	Body nextbeambody = bmNext.realBody();
	
	if (dSpacing  > dMaximumAllowedSpacing) {
			reportNotice(TN("|Maximum spacing exceeded for element|: ") + el.number());
			bMaxExceeded = true;

		reportNotice("\n\t" + T("|Spacing between stud| ") + bmThis.posnum() +T(" |and| ") + bmNext.posnum() + T(" |is|: ") + dSpacing);
		if (nWrongBeamColor > 0){
		thisBeamdp.draw(thisbeambody);
		nextBeamdp.draw(nextbeambody);
	}
		if (SAddBeams == "Yes"){
		for (int l=1;dSpacing > dMaximumAllowedSpacing; l++){
		Beam ExceededBeam = bmThis.dbCopy();
		
		ExceededBeam.transformBy(vxEl *(l * bmThis.solidWidth()));
		// Array with 1 and -1, this is used to swap the x-vector of the new stud. We need both ends of the stud to check where we have to strech to.
		int sides[] = {1, -1};
		for (int i=0;i<sides.length();i++) {
		// The direction to find a beam to stretch to.
		Vector3d direction = ExceededBeam.vecX() * sides[i];
		// A point close to the end of the beam.
		Point3d beamEnd = ExceededBeam.ptCenSolid() + direction * 0.4 * ExceededBeam.solidLength();

		// Find a possible beam to stretch to.
		Beam beamsToStretchTo[] = Beam().filterBeamsHalfLineIntersectSort(nonVerticalBeams, beamEnd, direction);

		if (beamsToStretchTo.length() == 0) {
		//Beam to stretch to is not found... something is wrong here? What to do... :-/

		}

		// Stretch the new stud.
		ExceededBeam.stretchStaticTo(beamsToStretchTo[0], _kStretchOnInsert);
		
		Display addedBeamdp(nAddedBeamColor);
		Body addedbeambody = ExceededBeam.realBody();
		addedBeamdp.draw(addedbeambody);

	}
		dSpacing -= bmThis.solidWidth();
		reportNotice("\n\t" + T("|Beam(s) Added| ") + "-->" + l);

	}
}
	}

}
		if( !bMaxExceeded){
			reportNotice(TN("|Maximum spacing not exceeded for element|: ")+ el.number());
	}

if (_bOnElementConstructed || bOnManualInsert) {
	if (!bMaxExceeded)
	eraseInstance();
	
	return;
}
#End
#BeginThumbnail








#End