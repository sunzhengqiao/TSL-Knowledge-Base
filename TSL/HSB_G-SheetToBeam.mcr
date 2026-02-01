#Version 8
#BeginDescription
Last modified by: Robert Pol(support.nl@hsbcad.com)
29.01.2020-  version 3.07














#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 7
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Change the width and the length of a sheet base on the envelope sheet that fit the most. Convert it to a beam after that.
/// </summary>

/// <insert>
/// Select an element
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="3.07" date="29.01.2020"></version>

/// <history>
/// AS - 1.00 - 14.06.2010 - Pilot version
/// AS - 2.00 - 06.03.2013 - Updated for localizer
/// AS - 2.01 - 07.03.2013 - Add options to override properties
/// AS - 2.02 - 02.10.2014 - Add option to set color
/// AS - 2.03 - 16.03.2015 - Preserve beamcode when converting from sheet to beam.
/// AS - 2.04 - 29.03.2016 - Do not create temporary sheet anymore, it can flip the beam if it is generated based on that temporary sheet.
/// EtH - 2.05 - 13-06-2016 - Name set Propperly instead of materialName
/// AS - 3.00 - 18-04-2017 - Add categories, improve insert.
/// RP - 3.01 - 23-11-2017 - Add option to select individual sheets
/// RP - 3.02 - 13-12-2017 - All beams in the same direction aligned to vecX element and fix insertion based on element
/// RP - 3.03 - 17-01-2018 - On element constructed get the sheets of the element and add them to _sheet
/// RP - 3.04 - 08-01-2019 - Add a tolerance for check on area
//Rvw - 3.05 - 18.07.2019 - Add a GenbeamFilter to filter sheets not only on zone. Filter on zone and GenbeamFilter can not be used simultaneously.
/// RP - 3.06 - 26-08-2019 - Use filtergenbeams to do all filtering
/// RP - 3.07 - 29-01-2019 - Add sequence number
/// </history>

_ThisInst.setSequenceNumber(-300);
//Script uses mm
double dEps = U(.001,"mm");
double areaTolerance = U(0.001);
double pointTolerance = U(0.1);
double vectorTolerance = U(0.01);
String categories[] = {
	T("|Selection|"),
	T("|Override properties|")
};

String arSZone[] = {"--", "10", "9","8","7","6","0","1","2","3","4","5"};
String arSActualZone[] = {"--", "-5", "-4","-3","-2","-1","0","1","2","3","4","5"};

PropString sZn(0, arSZone, T("|Zone to convert|"));
sZn.setCategory(categories[0]);
sZn.setDescription(T("|Filterdefenition will always override this propertie!|"));

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0, "");

PropString genBeamFilterDefinition(10, filterDefinitions, T("|Filter definition for GenBeams|"));
genBeamFilterDefinition.setDescription(T("|Filter definition for GenBeams.|") + T(" (|Will be combined with custom filters|)") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
genBeamFilterDefinition.setCategory(categories[0]);

PropString sName(2, "", T("|Name|"));
sName.setCategory(categories[1]);
PropString sMaterial(3, "", T("|hsbCAD Material|"));
sMaterial.setCategory(categories[1]);
PropString sGrade(4, "", T("|Grade|"));
sGrade.setCategory(categories[1]);
PropString sInformation(5, "", T("|Information|"));
sInformation.setCategory(categories[1]);
PropString sLabel(6, "", T("|Label|"));
sLabel.setCategory(categories[1]);
PropString sSublabel(7, "", T("|Sublabel|"));
sSublabel.setCategory(categories[1]);
PropString sSublabel2(8, "", T("|Sublabel 2|"));
sSublabel2.setCategory(categories[1]);
PropString sBeamCode(9, "", T("|Beam code|"));
sBeamCode.setCategory(categories[1]);
PropInt nColor(1, -1, T("|Color|"));
nColor.setCategory(categories[1]);

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-BeamToSheet");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	int nNrOfTslsInserted = 0;
	//Select beam(s) and insertion point
	PrEntity ssE(T("|Select one or more elements|") + T(" <|Right click to select sheets|>"), Element());
	if (ssE.go()) {
		Element arSelectedElements[] = ssE.elementSet();
		if (arSelectedElements.length() == 0) {
			if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
				showDialog();

			PrEntity ssESh(T("|Select sheets|"), Sheet());
			if (ssESh.go()) {
				_Sheet.append(ssESh.sheetSet());
				return;
			}
		}
		else
		{
			if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
				showDialog();
		}

		
		//insertion point
		String strScriptName = scriptName(); // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", true);
		setCatalogFromPropValues("MasterToSatellite");
		mapTsl.setInt("ManualInsert", true);
		for( int i=0;i<arSelectedElements.length();i++ )
		{
			Entity lstEntities[0];
			Sheet lstBeams[0];
			
			Element el = arSelectedElements[i];
			lstEntities.append(el);
			Sheet sheets[] = el.sheet(); 
			for (int index=0;index<sheets.length();index++) 
			{ 
				Sheet sheet = sheets[index]; 
				 lstBeams.append(sheet);
			}
			
			TslInst arTsl[] = el.tslInst();
			for( int j=0;j<arTsl.length();j++ ){
				TslInst tsl = arTsl[j];
				if( !tsl.bIsValid() || tsl.scriptName() == strScriptName )
					tsl.dbErase();
			}
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			nNrOfTslsInserted++;
		}
	}
	
	reportMessage(nNrOfTslsInserted + T(" |tsl(s) inserted|"));
	
	eraseInstance();
	return;
}

// set properties from master
if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", true);
	}
}

int bManualInsert = false;
if( _Map.hasInt("ManualInsert") ){
	bManualInsert = _Map.getInt("ManualInsert");
	_Map.removeAt("ManualInsert", true);
}

 if( _bOnElementConstructed)
{
	_Sheet.append(_Element[0].sheet());
}

if (_Element.length() == 0 && _Sheet.length() == 0) {
	reportMessage(TN("|Invalid selection|!"));
	eraseInstance();
	return;
}

String sActualZone = arSActualZone[arSZone.find(sZn)];	
int nNrOfEntitiesChanged = 0;
Vector3d allVx[0];

Entity entities[0];
Entity filteredSheets[0];

for (int s=0;s<_Sheet.length();s++) 
{ 
	Entity ent = (Entity)_Sheet[s]; 
	entities.append(ent);
}//next s

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(entities, false, "GenBeams", "GenBeams", "GenBeam");
filterGenBeamsMap.setString("Zone[]", sActualZone);
if (genBeamFilterDefinition == "" && sActualZone != "--")
{
	filterGenBeamsMap.setInt("Exclude", false);
}
int succesfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, genBeamFilterDefinition, filterGenBeamsMap);
if (! succesfullyFiltered)
{
	reportWarning(T("|GenBeams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
}
filteredSheets.append(filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam"));	

for (int k=0; k<filteredSheets.length(); k++){
	Sheet sh= (Sheet)filteredSheets[k];
		
//	if (sh.myZoneIndex() != nZone && nZone != -1)
//		continue;
	Vector3d vx=sh.vecX();
	Vector3d vy=sh.vecY(); 
	Vector3d vz=sh.vecZ();
	
	String sShMaterial = sh.material();
	
	Point3d ptCenter=sh.ptCen();
	
	PLine plShEnvelope=sh.plEnvelope();
	PLine plShOpenings[]=sh.plOpenings();
	Point3d ptVertex[]=plShEnvelope.vertexPoints(FALSE);
	double dArea=plShEnvelope.area();
	dArea=dArea/U(1)*U(1);
	
	Point3d ptVertexToSort[0];
	ptVertexToSort.append(ptVertex);
	
	//Store all the posible areas and vectors to define the new orientation of the sheet
	double dValidAreas[0];
	double dSegmentLength[0];
	Vector3d vxNew[0];
	
	//Loop of the vertex Points to analize each segment
	for (int i=0; i<ptVertex.length()-1; i++)
	{
		//Declare of the new X and Y Direction using a pair of Vertex Points
		Vector3d vxSeg=ptVertex[i+1]-ptVertex[i];
		vxSeg.normalize();
		Vector3d vySeg=vxSeg.crossProduct(vz);

		//Lines to Sort the Point in the New X and Y Direction
		Line lnX (ptCenter, vxSeg);
		Line lnY (ptCenter, vySeg);
		
		//Sort the vertext Point in the new X direction and fine the bigest distance
		ptVertexToSort=lnX.orderPoints(ptVertexToSort);
		double dDistA=abs(vxSeg.dotProduct(ptVertexToSort[0]-ptVertexToSort[ptVertexToSort.length()-1]));
		
		//Sort the vertext Point in the new Y direction and fine the bigest distance
		ptVertexToSort=lnY.orderPoints(ptVertexToSort);
		double dDistB=abs(vySeg.dotProduct(ptVertexToSort[0]-ptVertexToSort[ptVertexToSort.length()-1]));
		
		double dNewArea=dDistA*dDistB;
		
		dValidAreas.append(dNewArea-dArea);
		dSegmentLength.append(abs(vxSeg.dotProduct(ptVertex[i+1]-ptVertex[i])));
		vxNew.append(vxSeg);
	}

	//Sort the arrays by Segment Length
	for (int i=0; i<dSegmentLength.length()-1; i++)
	{
		for (int j=i+1; j<dSegmentLength.length(); j++)
		{
			if( dSegmentLength[i] < dSegmentLength[j])
			{
				dValidAreas.swap(i, j);
				dSegmentLength.swap(i, j);
				vxNew.swap(i, j);
			}			
		}
	}

	//Sort the arrays by Smallest Area
	for (int i=0; i<dValidAreas.length()-1; i++)
	{
		for (int j=i+1; j<dValidAreas.length(); j++)
		{
			if( dValidAreas[i] > dValidAreas[j] + areaTolerance)
			{
				dValidAreas.swap(i, j);
				dSegmentLength.swap(i, j);
				vxNew.swap(i, j);
			}			
		}
	}


	//Create the New Sheet with the coordinate system of the vector found before
	//Declare the CoordSys for the new sheet
	Vector3d vyNew=vxNew[0].crossProduct(vz);
	CoordSys csNew (ptCenter, vxNew[0], vyNew, vz);
	
	//PlaneProfile ppSheet(csNew);
	//ppSheet.joinRing (plShEnvelope, FALSE);
	//for (int i=0; i<plShOpenings.length(); i++)
		//ppSheet.joinRing (plShOpenings[i], TRUE);
	
	////Element el=sh.element();
	
	////Create temporary sheet
	//Sheet shNew;
	//shNew.dbCreate(ppSheet, sh.dH());
	Body bdShNew = sh.realBody();//shNew.realBody();
	
	if( bdShNew.lengthInDirection(vyNew) > bdShNew.lengthInDirection(vz) ){
		Vector3d vTmp = vyNew;
		vyNew = vz;
		vz = vTmp;
	}
	Element el = sh.element();	
	Vector3d xVectorToUse = 	vxNew[0];
	if (el.bIsValid() && el.coordSys().vecX().dotProduct(xVectorToUse) < dEps -1)
		xVectorToUse *= -1;
	for (int index=0;index<allVx.length();index++) 
	{ 
		Vector3d vec = allVx[index]; 
		if  (abs(vec.dotProduct(vxNew[0])) > 1 - dEps)
			xVectorToUse = vec;
	}
	
	allVx.append(xVectorToUse);	

	//Create beam
	Beam bmNew;
	bmNew.dbCreate(bdShNew, xVectorToUse, vyNew, xVectorToUse.crossProduct(vyNew));
	bmNew.setName(sName);
	if( sName != "" )
		bmNew.setName(sName);
	bmNew.setMaterial(sShMaterial);
	if( sMaterial != "" )
		bmNew.setMaterial(sMaterial);
	bmNew.setGrade(sh.grade());
	if( sGrade != "" )
		bmNew.setGrade(sGrade);
	bmNew.setInformation(sh.information());
	if( sInformation != "" )
		bmNew.setInformation(sInformation);
	bmNew.setLabel(sh.label());
	if( sLabel != "" )
		bmNew.setLabel(sLabel);
	bmNew.setSubLabel(sh.subLabel());
	if( sSublabel != "" )
		bmNew.setSubLabel(sSublabel);
	bmNew.setSubLabel2(sh.subLabel2());
	if( sSublabel2 != "" )
		bmNew.setSubLabel2(sSublabel2);	
	bmNew.setBeamCode(sh.beamCode());//sShMaterial+";"+sShMaterial+";;");
	if( sBeamCode != "" )
		bmNew.setBeamCode(sBeamCode);
	bmNew.setType(sh.type());
	bmNew.setModule(sh.module());
	bmNew.setHsbId(sh.hsbId());
	bmNew.setColor(sh.color());
	if (nColor > -1)
		bmNew.setColor(nColor);

	bmNew.assignToLayer(sh.layerName());
	//shNew.assignToElementGroup(el, nZnIndex, TRUE, 'Z');
	
	//Remove sheets
	sh.dbErase();
	nNrOfEntitiesChanged++;
}

if( _bOnElementConstructed || bManualInsert){
	reportMessage(TN("|Sheets are converted to beams|! ") + nNrOfEntitiesChanged + T(" |entities changed|."));
	eraseInstance();
}








#End
#BeginThumbnail






















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End