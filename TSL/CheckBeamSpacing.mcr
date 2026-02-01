#Version 8
#BeginDescription
Last modified by: Ronald van Wijngaarden (support.nl@hsbcad.com)
24.07.2019-  version 1.01

This tsl checks the spacing between beams and can add beams/ color beams that exceed the allowed spacing
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
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

/// <version  value="1.01" date="24.07.2019"></version>

/// <history>
/// RVW - 1.00 - 23.07.2019	- Pilot version
/// RVW - 1.01 - 24.07.2019	- Calculate max distance if using 0 (element distance between beams) to the distance between the beams minus the half thickness of the beams. And add properties to set to the new created beams.
/// </history>

double dEps = Unit(0.01,"mm");

String categories[] = {
	T("|General|"),
	T("|Dimensions|"),
	T("|Color|"),
	T("|New beam properties|")
};

String arSYesNo[] = {
	T("|Yes|"),
	T("|No|")
};

String arAddStuds[] = 
{
	T("|No|"),
	T("|From left|"),
	T("|In center|"),
	T("|From right|")
};

String beamTypeNames[] = 
{
	T("|Stud|"),
	T("|Beam|")
};

int beamTypes[] =
{
	_kStud,
	_kBeam
};

//TODO add some more standard beamtypes



PropInt sequenceNumber(0, 0, T("|Sequence number|"));
sequenceNumber.setCategory(categories[0]);
sequenceNumber.setDescription(T("|The sequence number is used to sort the list of tsl's during generate construction|"));

PropString sFilterBC(6,"",T("|Filter beams with beamcode|"));
sFilterBC.setCategory(categories[0]);
sFilterBC.setDescription(T("|Specify beamcode's that can be excluded from the calculation|"));

PropDouble dMaxAllowedSpacing(1, U(0), T("|Maximum allowed spacing|"));
dMaxAllowedSpacing.setCategory(categories[1]);
dMaxAllowedSpacing.setDescription(T("|This is the maximum spacing allowed between vertical beams. If zero, spacing set in element is checked|"));

PropString SAddBeams(2,  arAddStuds, ""+T("|Automatic add beams|"),0);
SAddBeams.setCategory(categories[1]);
SAddBeams.setDescription(T("|Automaticaly add vertical beams from left, in center or from right|"));

PropString sAddCircle(7, arSYesNo, "" + T("|Show circle|"), 1);
sAddCircle.setCategory(categories[1]);
sAddCircle.setDescription(T("|Add a circle when exceeding the maximum spacing between the studs|"));

PropInt nWrongBeamColor(4, 1, T("|Color of the wrong beam|"));
nWrongBeamColor.setCategory(categories[2]);
nWrongBeamColor.setDescription(T("|Sets the color of all the beams that are at an incorrect spacing distance|"));

PropInt nAddedBeamColor(5, 3, T("|Color of the added beam|"));
nAddedBeamColor.setCategory(categories[2]);
nAddedBeamColor.setDescription(T("|Sets the color of all the beams that are added|"));

PropInt nColorOfCircle(8, 1, T("|Color of the circle|"));
nColorOfCircle.setCategory(categories[2]);
nColorOfCircle.setDescription(T("|Sets the color of the circle|"));

PropInt newBeamColor (9, 1, T("|Color|"));
newBeamColor.setCategory(categories[3]);
newBeamColor.setDescription(T("|Set the color of the new beam|"));

PropString newBeamName (10, "", T("|Beam name|"));
newBeamName.setCategory(categories[3]);
newBeamName.setDescription(T("|Set the name of the new beam|"));

PropString newBeamType (11, beamTypeNames, T("|Beam type|"));
newBeamType.setCategory(categories[3]);
newBeamType.setDescription(T("|Set the type of the new beam|"));

PropString newBeamMaterial (12, "", T("|Beam material|"));
newBeamMaterial.setCategory(categories[3]);
newBeamMaterial.setDescription(T("|Set the material of the new beam|"));


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("CheckBeamSpacing");
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
	
	String strScriptName = "CheckBeamSpacing"; // name of the script
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
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

_Pt0 = ptEl;

// Resolve properties
int beamType = beamTypes[beamTypeNames.find(newBeamType, 0)];
int addNewBeams = arAddStuds.find(SAddBeams, 0);

int elIsWall;

double dElSpacing;
if (el.bIsKindOf(ElementWallSF()))
{
	ElementWallSF elSf = (ElementWallSF)el;
	dElSpacing = elSf.spacingBeam();
	elIsWall = true;
}
else if (el.bIsKindOf(ElementRoof()))
{
	ElementRoof elRoof = (ElementRoof)el;
	dElSpacing = elRoof.dBeamSpacing();
	elIsWall = false;
}

int useBeamSpacing = dMaxAllowedSpacing <= U(0);

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
	if (abs(abs(bm.vecX().dotProduct(el.vecX())) - 1) < vectorTolerance)
	{
	isHorizontalBeam = true;
	}
	// Its a vertical beam if it is alligned with the element y vector.
	if (abs(abs(bm.vecX().dotProduct(el.vecY())) - 1) < vectorTolerance)
	{
	isVerticalBeam = true;
	}

	// Store it if the beam is not vertical.
	if (!isVerticalBeam)
	{
	nonVerticalBeams.append(bm);
	}
	
	else
	{
	VerticalBeams.append(bm);
	}
}

// Store if the beam is vertical.
Beam arBmVerticalSort[] = vxEl.filterBeamsPerpendicularSort(VerticalBeams);
	
Display dpError(1);
int bMaxExceeded = false;

for (int i=0;i<(arBmVerticalSort.length() - 1);i++) 
{
	Beam bmThis = arBmVerticalSort[i];
	Beam bmNext = arBmVerticalSort[i+1];
	
	double sumOfHalfBeamSizes = 0.5 * (bmThis.dD(vxEl) + bmNext.dD(vxEl));
	double dSpacing = vxEl.dotProduct(bmNext.ptCen() - bmThis.ptCen()) - sumOfHalfBeamSizes;
	
	Point3d ptThis = bmThis.ptCen() + bmThis.vecD(vxEl) * 0.5 * bmThis.dD(vxEl);
	Point3d ptNext = bmNext.ptCen() - bmNext.vecD(vxEl) * 0.5 * bmNext.dD(vxEl);
	
	LineSeg ls(ptThis, ptNext);
	Point3d ptAux = ls.ptMid();
	
	Display dpCircle(nColorOfCircle);
	Display dpDimLine(1);
	dpDimLine.dimStyle("Entekra Design");
	
	int centerBeam = false;
	
	Display thisBeamdp(nWrongBeamColor);
	Display nextBeamdp(nWrongBeamColor);
	
	Body thisbeambody = bmThis.realBody();
	Body nextbeambody = bmNext.realBody();
	
	double allowedSpacing = useBeamSpacing ? dElSpacing - sumOfHalfBeamSizes : dMaxAllowedSpacing;
	
	if ((dSpacing - allowedSpacing) > dEps) 
	{
		reportNotice(TN("|Maximum spacing exceeded for element|: ") + el.number());
		bMaxExceeded = true;
		
		reportNotice("\n\t" + T("|Spacing between stud| ") + bmThis.posnum() + T(" |and| ") + bmNext.posnum() + T(" |is|: ") + dSpacing);
		if (nWrongBeamColor > 0) 
		{
			thisBeamdp.draw(thisbeambody);
			nextBeamdp.draw(nextbeambody);
		}
		if (addNewBeams != 0) 
		{
			for (int l = 1; dSpacing > allowedSpacing; l++) 
			{
				Beam bExceededBeam;
				bExceededBeam = addNewBeams == 3 ? bmNext.dbCopy() : bmThis.dbCopy();
				bExceededBeam.setD(bExceededBeam.vecD(vxEl), el.dBeamHeight());
				bExceededBeam.setColor(newBeamColor);
				bExceededBeam.setName(newBeamName);
				bExceededBeam.setType(beamType);
				bExceededBeam.setMaterial(newBeamMaterial);
				
				if (addNewBeams == 1) //Place beams from left
				{
					bExceededBeam.transformBy(vxEl * (0.5 * bmThis.dD(vxEl) +  (l - 0.5) * bExceededBeam.dD(vxEl)));
				}
				else if (addNewBeams == 2) //Place beam in center
				{
					bExceededBeam.transformBy(vxEl * ((bExceededBeam.dD(vxEl) / 2) + dSpacing / 2));
					centerBeam = true;
				}
				else //Place beams from right
				{
					bExceededBeam.transformBy(-vxEl * (0.5 * bmNext.dD(vxEl) + (l - 0.5) * bExceededBeam.dD(vxEl)));					
				}

				// Array with 1 and -1, this is used to swap the x-vector of the new stud. We need both ends of the stud to check where we have to strech to.
				int sides[] = { 1, - 1};
				for (int i = 0; i < sides.length(); i++) 
				{
					// The direction to find a beam to stretch to.
					Vector3d direction = bExceededBeam.vecX() * sides[i];
					// A point close to the end of the beam.
					Point3d beamEnd = bExceededBeam.ptCenSolid() + direction * 0.4 * bExceededBeam.solidLength();
					
					// Find a possible beam to stretch to.
					Beam beamsToStretchTo[] = Beam().filterBeamsHalfLineIntersectSort(nonVerticalBeams, beamEnd, direction);
					
					if (beamsToStretchTo.length() == 0) 
					{
						//Beam to stretch to is not found... something is wrong here? What to do... :-/						
					}
					
					// Stretch the new stud.
					bExceededBeam.stretchStaticTo(beamsToStretchTo[0], _kStretchOnInsert);
					
					Display addedBeamdp(nAddedBeamColor);
					Body addedbeambody = bExceededBeam.realBody();
					addedBeamdp.draw(addedbeambody);					
				}
				if (centerBeam)
				{
					break;
				}
				dSpacing -= bmThis.dD(vxEl);
				reportNotice("\n\t" + T("|Beam(s) Added| ") + "-->" + l);				
			}
		}
		if (sAddCircle == "Yes")
		{
			Point3d ptErrCen = ptAux;
			PLine pLine(vyEl);
			pLine.createCircle(ptErrCen, elIsWall ? vyEl : vzEl, U(100, 10));
			dpCircle.draw(pLine);
		}
		
		Point3d ptDimLine = ptThis + vzEl * U(350);
		ptDimLine.vis();
		DimLine dl1(ptDimLine, _XU, _YU);		
		Dim dim1(dl1,ptThis,ptNext, "<>");
		dpDimLine.draw(dim1);		
	}
}

if ( ! bMaxExceeded)
{
	reportNotice(TN("|Maximum spacing not exceeded for element|: ") + el.number());
}

if (_bOnElementConstructed || bOnManualInsert) 
{
	if (!bMaxExceeded)
	eraseInstance();
	
	return;
}
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