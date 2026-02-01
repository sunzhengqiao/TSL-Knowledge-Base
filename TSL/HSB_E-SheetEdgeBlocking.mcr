#Version 8
#BeginDescription
Last modified by: Ronald van Wijngaarden (support.nl@hsbcad.com)

21.01.2019  -  version 1.02

This tsl will create blockings based on sheets created by dsp.
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
// constants //region
/// <summary Lang=en>
/// Description
/// </summary>

/// <insert>
/// Specify insert
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="19-12-2018"></version>

/// <history>
/// RP - 1.00 - 19-12-2018 -  Pilot version.
/// RVW - 1.01 - 07-01-2019	- Add offset to beamcut or beamblocking
/// RVW	- 1.02  - 21-01-2019 - Recalculate offset when choosing beamblocking

/// </history>
//endregion



U(1,"mm");	
double pointTolerance =U(.1);
double vectorTolerance =U(.01);
int nDoubleIndex, nStringIndex, nIntIndex;
int arZone[] ={10, 9, 8, 7, 6, 0, 1, 2, 3, 4, 5};
int bDebug=_bOnDebug;
bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
String sDoubleClick= "TslDoubleClick";
String sDefault =T("|_Default|");
String sLastInserted =T("|_LastInserted|");	
String categories[] = { T ("|General|"), T("|Override properties|")};
String executeKey = "ManualInsert";
String options[] = { T("|Beamcut on rafters|"), T("|Blocking between rafters|")};
String arYesNo[] = { T("|No|"), T("|Yes|")};


PropString sheetBlocking(0, options, T("|Beamcut options|"), 0);
sheetBlocking.setDescription(T ("|Choose if the rafters need to be cut out, or the blocking has to be between the rafters.|"));
PropDouble offsetDistance(1, 0, T ("|Blocking or cut offset distance|"));
offsetDistance.setDescription(T ("|Give the beamcut in the rafter or the blocking between the rafters an additional offset distance.|"));
PropInt sheetZone(2, arZone, T ("|Use sheet from zone|"), 3);
sheetZone.setDescription(T ("|Choose which zone has to be used for the 'Beamcut on rafters' or 'Blocking between rafters'.|"));
PropString createBeam(3, arYesNo, T("|Convert sheet to beam.|"), 1);
createBeam.setDescription(T ("|Choose if the sheet from the chosen zone has to be converted to a beam.|"));


PropInt nColor(5, - 1, T("|Color|"));
nColor.setCategory(categories[1]);
PropString sName(6, " ", T("|Name|"));
sName.setCategory(categories[1]);
PropString sMaterial (7, "", T("|hsbCAD Material|"));
sMaterial.setCategory(categories[1]);
PropString sGrade (8, "", T("|Grade|"));
sGrade.setCategory(categories[1]);
PropString sInformation (9, "", T("|Information|"));
sInformation.setCategory(categories[1]);
PropString sLabel (10, "", T("|Label|"));
sLabel.setCategory(categories[1]);
PropString sSubLabel (11, "", T("|Sublabel|"));
sSubLabel.setCategory(categories[1]);
PropString sSubLabel2 (12, "", T("|Sublabel 2|"));
sSubLabel2.setCategory(categories[1]);
PropString sBeamCode (13, "", T ("|Beam code|"));
sBeamCode.setCategory(categories[1]);


// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( _bOnDbCreated && catalogNames.find(_kExecuteKey) != -1 ) 
{
	setPropValuesFromCatalog(_kExecuteKey);	
}

// bOnInsert
if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
				
// silent/dialog
	String sKey = _kExecuteKey;
	sKey.makeUpper();

	if (sKey.length()>0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for(int i=0;i<sEntries.length();i++)
		{
			sEntries[i] = sEntries[i].makeUpper();	
		}
		
		if (sEntries.find(sKey)>-1)
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
		else
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
	}	
	else	
	{
		showDialog();
		setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
	}
	
	// prompt for elements
	PrEntity ssE(T("|Select element(s)|"), Element());
  	if (ssE.go())
  	{
		_Element.append(ssE.elementSet());
  	}

	
	for (int e=0;e<_Element.length();e++) 
	{
		// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;
		Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[] = {};
		Entity entsTsl[0];
		entsTsl.append(_Element[e]);
		Point3d ptsTsl[] = {};
		int nProps[]={};
		double dProps[]={};
		String sProps[]={};
		Map mapTsl;	
		String sScriptname = scriptName();
		
		ptsTsl.append(_Element[e].coordSys().ptOrg());
		
		tslNew.dbCreate(scriptName(),vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, sLastInserted, true, mapTsl, executeKey, "");
	}
				
	eraseInstance();		
	return;
}	
// end on insert	__________________

// Read type of intersection from user : |Beamcut on rafters| or |Blocking between rafters| from OPM sheetblocking[] array, and assign it to int nBeamMode
int nBeamMode = options.find(sheetBlocking,0);
// Read if user wants to convert sheet to beam
int nSheetToBeam = arYesNo.find(createBeam,0);

// Read zone choice from user and extract it to -1, -2, -3, -4, -5 if the value is > 5 (zone 6 becomes -1, zone 7 becomes -2 etc.), and assign it to nZoneOld/ nZoneNew
	int nZoneOld = sheetZone;
	if( nZoneOld > 5 )
	nZoneOld = 5 - nZoneOld;


// validate and declare element variables
if (_Element.length()!=1)
{
	reportMessage(TN("|Element reference not found.|"));
	eraseInstance();
	return;	
}

Element element = _Element[0];
CoordSys cs = element.coordSys();
Vector3d vecX = cs.vecX();
Vector3d vecY = cs.vecY();
Vector3d vecZ = cs.vecZ();
Point3d ptOrg = cs.ptOrg();
assignToElementGroup(element,false, 0,'E');// assign to element tool sublayer

//Do you thing ;)
// create an array "sheets" with the sheets in zone (defined by user at "sheetZone"). And create an array "beams" with al the beams in the element.
Sheet sheets[] = element.sheet(nZoneOld);
Beam beams[] = element.beam();

// An array named "arNBmTypeFrame[] " with different kinds of beam/rafter types we need for the type of rafter in this element.
int arNBmTypeFrame[] = {
	_kDakCenterJoist,
	_kStud,
	_kSFStudLeft,
	_kSFStudRight,
	_kSFSupportingBeam,
	_kKingPost,
	_kKingStud,
	_kSFJackOverOpening,
	_kSFJackUnderOpening
};

Sheet sheetToBeamSheets[0];

// Create an int i and make it 0. Than check if int i has a less value than the array of sheets. If it has a less value add 1 to i. 
for (int i=0;i<sheets.length(); i++)
{
	// Create a sheet from .. and make it number [i]
	Sheet sheet = sheets[i];
	// Create a new Point3d on this sheet in this array with the name "bottomPointSheet" and place it : from sheet.ptCen() - sheet.vecD(vecZ) * 0.5 * sheet.dD(vecZ);
	Point3d bottomPointSheet = sheet.ptCen() - sheet.vecD(vecZ) * 0.5 * sheet.dD(vecZ);		
	// Transform/ move the sheet in the vecZ direction dotProduct. Looking at the element.zone (zone -1) looking at the coordSys, at the ptOrg() of the zone -1. substract point3d bottomPointSheet from this and the new vector is created.
	sheet.transformBy(vecZ * (vecZ.dotProduct(element.zone(-1).coordSys().ptOrg() - bottomPointSheet)));
		
	if (sBeamCode != "")
		sheet.setBeamCode(sBeamCode);
	if (sName != "")
		sheet.setName(sName);
	if (nColor != -1)
		sheet.setColor(nColor);
	if (sMaterial != "")
		sheet.setMaterial(sMaterial);
	if (sGrade != "")
		sheet.setGrade(sGrade);
	if (sInformation != "")
		sheet.setInformation(sInformation);
	if (sLabel != "")
		sheet.setLabel(sLabel);
	if (sSubLabel != "")
		sheet.setSubLabel(sSubLabel);
	if (sSubLabel2 != "")
		sheet.setSubLabel2(sSubLabel2);
	
	// intersection array
	Beam intersectionArray[0];
	Body sheetBody = sheet.envelopeBody();
	
	for (int b = 0; b < beams.length(); b++)
	{
		Beam beam = beams[b];
		Body beamBody = beam.envelopeBody();
		
		if (beamBody.hasIntersection(sheetBody))
		{
			intersectionArray.append(beam);
		}
	}
	
	// If the BeamMode = 0 / |Beamcut on rafters|
	if(nBeamMode == 0)
	{
		// Create a beamcut named "BeamCut". From sheet point center, XYZ axis, get the sheet solidLength, solidWidth and solidHeight. From sheet.poCen are the sheet.solidLength,Width,Height equally devided over the XYZ axis from sheet.ptCen. Also give an offsetDistance to the cut.
		BeamCut beamCut (sheet.ptCenSolid(),sheet.vecX(),sheet.vecY(),sheet.vecZ(),sheet.solidLength()+offsetDistance,sheet.solidWidth()+U(100),sheet.solidHeight()+ offsetDistance, 0, 0, 0);
		
		// Create a for loop. create an int b with the value 0, than give it a check to check if b < the amount of beams in the array of beams. if so add 1 to b and check again after the for loop.
		for (int b=0;b<intersectionArray.length(); b++)
		{
			// Create for the beam a number in the array beams
			Beam beam = intersectionArray[b];
					
			// If there is an intersection between those two bodies, than add the beam.addToolStatic(beamCut) to the beam. Because the sheet is the leader in this choice of the user. 
			beam.addToolStatic(beamCut);
		}
		
		sheetToBeamSheets.append(sheet);
		
	}
	else // If the user did not choose 0 / |Beamcut on rafters| it has to be 1 / |Blocking on rafters|
	{ 
		Sheet splittedSheets[0];
		splittedSheets.append(sheet);
		Plane planes[0];
		double gaps[0];
		Point3d points[0];
		
		for (int r = 0; r < intersectionArray.length(); r++)
		{
			Beam rafter = intersectionArray[r];
			Vector3d rafterY = rafter.vecX().crossProduct(vecZ);
			double rafterWidth = rafter.dD(rafterY) +(U(offsetDistance)*2);
			gaps.append(rafterWidth);
			if (rafterY.dotProduct(vecX) > 0)
			{
				rafterY *= -1;
			}
			Point3d point = rafter.ptCen();
			point += rafter.vecX() * rafter.vecX().dotProduct(sheet.ptCen() - point);
			Plane plane(point, - rafterY);
			planes.append(plane);
			points.append(point);
		}
		
		for (int p = 0; p < planes.length(); p++)
		{
			Plane plane = planes[p];
			double gap = gaps[p];
			Point3d point = points[p];
				
			for (int s = 0; s < splittedSheets.length(); s++)
			{
				Sheet sh = splittedSheets[s];
				PlaneProfile pp = sh.envelopeBody(false, false).shadowProfile(Plane(ptOrg, - vecZ));
				pp.vis(s);
				point.vis(s);
				if (pp.pointInProfile(point) != _kPointInProfile) continue;
				Sheet newSheets[] = sh.dbSplit(plane, gap);	
				for (int ns = 0; ns < newSheets.length(); ns++)
				{
					Sheet newSheet = newSheets[ns];
					if (splittedSheets.find(newSheet) != -1) continue;
					splittedSheets.append(newSheet);
				}
			}
		}	
		
		sheetToBeamSheets = splittedSheets;
	}
	
}

if (nSheetToBeam == 1)
{
	String strScriptName = "HSB_G-SheetToBeam";
	Vector3d vecUcsX;
	Vector3d vecUcsY;
	Element lstElements[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	TslInst tsl;
	tsl.dbCreate(strScriptName, vecUcsX, vecUcsY, sheetToBeamSheets, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString);	
}

if (_kExecuteKey == executeKey || _bOnElementConstructed)
{
	eraseInstance();
	return;
}


#End
#BeginThumbnail
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
L*F!C8KLH'Y"O*[<;%FB!.V&>2%,GG:KLHS[X`KLPL*-5OW3R\1FE=+W3_]F0
`


#End