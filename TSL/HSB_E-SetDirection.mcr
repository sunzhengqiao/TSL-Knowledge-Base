#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
13.12.2013  -  version 1.01



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl sets the main direction to direction of the rafters
/// </summary>

/// <insert>
/// Auto: Attach the tsl to element definition
/// Manual: Select elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="13.12.2013"></version>

/// <history>
/// AS - 1.00 - 13.05.2013 -	Pilot version
/// AS - 1.01 - 13.12.2013 -	Select points for direction
/// </history>



if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	int nNrOfTslsInserted = 0;
	//Select beam(s) and insertion point
	PrEntity ssE(T("|Select one or more elements|"), Element());
	if (ssE.go()) {
		Element arSelectedElements[] = ssE.elementSet();
		
		Point3d arPtDirection[0];
		Point3d ptStartDirection = getPoint(T("|Select start point direction|"));
		arPtDirection.append(ptStartDirection);
		while (true) {
			PrPoint ssP2(T("|Select end point direction|"),ptStartDirection); 
			if (ssP2.go()==_kOk) { // do the actual query
				Point3d pt = ssP2.value();
				arPtDirection.append(pt); // append the selected points to the list of grippoints _PtG
				break;
			}
		}
		
		//insertion point
		String strScriptName = "HSB_E-SetDirection"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[0];
		lstPoints.append(arPtDirection);
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
	return;
}

Element el = _Element[0];
ElementRoof elRf = (ElementRoof)el;

if( _PtG.length() > 0 ){
	Vector3d vDirection = _PtG[0] - _Pt0;
	vDirection.normalize();
	elRf.setVecY(vDirection);

	eraseInstance();
	return;
}

Beam arBm[] = el.beam();
for( int i=0;i<arBm.length();i++ ){
	Beam bm = arBm[i];
	if( bm.hsbId() == "4101" ){
		elRf.setVecY(bm.vecX());
		break;
	}
}

eraseInstance();
return;
#End
#BeginThumbnail


#End
