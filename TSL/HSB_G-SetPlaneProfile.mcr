#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
03.05.2017  -  version 1.01


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
/// 
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="03.05.2017"></version>

/// <history>
/// AS - 1.00 - 12.07.2012 -	Pilot version
/// AS - 1.01 - 03.05.2017 -	Add all zones
/// </history>

PropString sSeperator01(0, "", T("|Zone to process|"));
sSeperator01.setReadOnly(true);
int arNZoneIndex[] = {0,1,2,3,4,5,6,7,8,9,10};
PropInt nZnIndex(1, arNZoneIndex, "     "+T("|Zone|"));

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_G-SetPlaneProfile");
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
	PrEntity ssE(T("|Select one or more elements|"), Element());
	if (ssE.go()) {
		Element arSelectedElements[] = ssE.elementSet();
		
		//insertion point
		String strScriptName = "HSB_G-SetPlaneProfile"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", true);
		mapTsl.setInt("ManualInsert", true);
		setCatalogFromPropValues("MasterToSatellite");
		for( int i=0;i<arSelectedElements.length();i++ ){
			Element el = arSelectedElements[i];
			if( !el.bIsValid() ){
				continue;
			}
			lstEntities[0] = el;
			
			TslInst arTsl[] = el.tslInst();
			for( int j=0;j<arTsl.length();j++ ){
				TslInst tsl = arTsl[j];
				if( !tsl.bIsValid() ){
					tsl.dbErase();
					continue;
				}
				
				if( tsl.scriptName() == strScriptName )
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

Element el = _Element[0];
if( !el.bIsValid() ){
	eraseInstance();
	return;
}

int nZoneIndex = nZnIndex;
if( nZoneIndex > 5 )
	nZoneIndex = 5 - nZoneIndex;

CoordSys csZn = el.zone(nZoneIndex).coordSys();

GenBeam arGBm[] = el.genBeam();
PlaneProfile ppZn(csZn);
Plane pnZn(csZn.ptOrg(), csZn.vecZ());
for( int i=0;i<arGBm.length();i++ ){
	GenBeam gBm = arGBm[i];
	if( !gBm.bIsValid() )
		continue;
	
	if( gBm.myZoneIndex() != nZoneIndex )
		continue;
	
	Body bdGBm = gBm.envelopeBody(true, true);
	ppZn.unionWith(bdGBm.extractContactFaceInPlane(pnZn, U(100)));
}

ppZn.shrink(-U(10));
ppZn.shrink(U(10));

PLine arPlZn[] = ppZn.allRings();
int arBRingIsOpening[] = ppZn.ringIsOpening();
PlaneProfile ppZnNew(csZn);
for( int i=0;i<arPlZn.length();i++ ){
	PLine plZn = arPlZn[i];
	int bIsRing = arBRingIsOpening[i];
	
	if( bIsRing )
		continue;
	
	ppZnNew.joinRing(plZn, _kAdd);
}

Opening arOp[] = el.opening();
for( int i=0;i<arOp.length();i++ ){
	Opening op = arOp[i];
	ppZnNew.joinRing(op.plShape(), _kSubtract);
}

el.setProfNetto(nZoneIndex, ppZnNew);

if( _bOnElementConstructed || bManualInsert ){
	reportMessage(TN("|PlaneProfile set for zone| ") + nZnIndex);
	eraseInstance();
}

#End
#BeginThumbnail




#End