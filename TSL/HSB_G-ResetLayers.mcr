#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
25.11.2013  -  version 1.00
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
/// This tsl sets the layer of the genbeams of the selected elements. Set layer '0' and assign to element group.
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="25.11.2013"></version>

/// <history>
/// AS - 1.00 - 25.11.2013 -	Pilot version
/// </history>


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_G-ResetLayers");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
//	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
//		showDialog();
	
	PrEntity ssE(T("|Select a set of elements|"),Element());
	if(ssE.go()){
		_Element.append(ssE.elementSet());
	}
	
	String strScriptName = "HSB_G-ResetLayers"; // name of the script
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Element lstElements[1];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("MasterToSatellite", TRUE);
	setCatalogFromPropValues("MasterToSatellite");
	mapTsl.setInt("ExecuteMode", 1);// 1 == recalc
	for( int e=0;e<_Element.length();e++ ){
		Element el = _Element[e];
		
		TslInst arTsl[] = el.tslInst();
		for( int i=0;i<arTsl.length();i++ ){
			TslInst tsl = arTsl[i];
			if( tsl.scriptName() == strScriptName )
				tsl.dbErase();
		}
	
		lstElements[0] = el;
	
		TslInst tsl;
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	}
	
	eraseInstance();
	return;
}

if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", true);
	}
}

if( _Element.length()==0 ){
	eraseInstance();
	return;
}

Element el = _Element[0];
Group grpElement = el.elementGroup();

Entity arEntGenBeam[] = grpElement.collectEntities(true, GenBeam(), _kModelSpace);
for( int i=0;i<arEntGenBeam.length();i++ ){
	GenBeam gBm = (GenBeam)arEntGenBeam[i];
	if( !gBm.bIsValid() )
		continue;

	int nZnIndex = gBm.myZoneIndex();
	gBm.assignToLayer("0");
	gBm.assignToElementGroup(el, true, nZnIndex, 'Z');
}

eraseInstance();
return;

#End
#BeginThumbnail

#End
