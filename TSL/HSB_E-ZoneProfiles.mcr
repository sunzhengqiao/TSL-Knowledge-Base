#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
28.11.2012  -  version 1.0























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl shows the zone profiles of the selected element. It also gives the user to modify it.
/// </summary>

/// <insert>
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="28.11.2012"></version>

/// <history>
/// AS - 1.00 - 28.11.2012 -	Pilot version
/// </history>

double dEps = Unit(0.001, "mm");

int arNZoneIndex[] = {1,2,3,4,5,6,7,8,9,10};

PropString sSeperator01(0, "", "Zone");
sSeperator01.setReadOnly(true);
PropInt nHsbZoneIndex(0, arNZoneIndex, "     "+T("|Zone index|"));

String arSGripType[] = {T("|Edge|"), T("|Corner|")};
PropString sGripType(1, arSGripType, "     "+T("|Active grippoints|"));

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-ZoneProfiles");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	int nNrOfTslsInserted = 0;
	//Select beam(s) and insertion point
	PrEntity ssE(T("|Select one or more elements|"), Element());
	if (ssE.go()) {
		Element arSelectedElements[] = ssE.elementSet();
		
		//insertion point
		String strScriptName = "HSB_E-ZoneProfiles"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", TRUE);
		setCatalogFromPropValues("MasterToSatellite");
		mapTsl.setInt("ExecuteMode", 1);
		mapTsl.setInt("ManualInsert", true);
		for( int i=0;i<arSelectedElements.length();i++ ){
			Element el = arSelectedElements[i];
			lstEntities[0] = el;
			
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

if( _Element.length() == 0 ){
	reportMessage(TN("|Invalid selection|!"));
	eraseInstance();
}
int nZoneIndex = nHsbZoneIndex;
if( nZoneIndex > 5 )
	nZoneIndex = 5 - nZoneIndex ;

int nGripType = arSGripType.find(sGripType,0);

Display dpZone(-1);
dpZone.textHeight(U(50));
Element el = _Element[0];

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

CoordSys csZone = el.zone(nZoneIndex).coordSys();
Point3d ptZone = csZone.ptOrg();
Vector3d vzZone = csZone.vecZ();

Plane pnZoneZ(ptZone, vzZone);

String sIdentifier = "Zone " + nZoneIndex;
dpZone.draw(sIdentifier, ptEl, vxEl, vyEl, -1.5, -1.5, _kDevice);

PlaneProfile ppZone = el.profNetto(nZoneIndex);
dpZone.draw(ppZone);

// Get the points based on the 'grip-type'. Corner or edge points.
Point3d arPtGrip[0];
if( nGripType == 0 )
	arPtGrip.append(ppZone.getGripEdgeMidPoints());
else if( nGripType == 1 )
	arPtGrip.append(ppZone.getGripVertexPoints());

// Reset the list of grippoints if one of the related properties is changed.
if( _kNameLastChangedProp == "     "+T("|Zone index|") || _kNameLastChangedProp == "     "+T("|Active grippoints|") )
	_PtG.setLength(0);

// Set the grippoints.
if( _PtG.length() == 0 )
	_PtG.append(arPtGrip);

// Update the planeprofile if one of the grippoints is moved.
if( _kNameLastChangedProp.left(4) == "_PtG" ){
	int nIndexMovedPt = _kNameLastChangedProp.right(_kNameLastChangedProp.length() - 4).atoi();
	int bMovedSuccessfully = false;
	_PtG[nIndexMovedPt] = pnZoneZ.closestPointTo(_PtG[nIndexMovedPt]);
	if( nGripType == 0 )
		bMovedSuccessfully  = ppZone.moveGripEdgeMidPointAt(nIndexMovedPt, _PtG[nIndexMovedPt] - arPtGrip[nIndexMovedPt]);		
	else if( nGripType == 1 )
		bMovedSuccessfully  = ppZone.moveGripVertexPointAt(nIndexMovedPt, _PtG[nIndexMovedPt] - arPtGrip[nIndexMovedPt]);

	if( bMovedSuccessfully )
		el.setProfNetto(nZoneIndex, ppZone);
}

dpZone.color(1);
dpZone.draw(ppZone);


#End
#BeginThumbnail



#End
