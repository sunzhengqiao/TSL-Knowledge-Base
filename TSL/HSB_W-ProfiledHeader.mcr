#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
02.04.2014  -  version 1.02

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
/// <summary Lang=en>
/// 
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.02" date="02.04.2014"></version>

/// <history>
/// AS - 1.00 - 04.01.2013 -	Pilot version
/// AS - 1.01 - 19.03.2014 -	Add option to change material name
/// AS - 1.02 - 02.04.2014 -	Add option to copy profile name to one of the header properties. 
/// </history>

String arSExtrusionProfileNamesSorted[0];
arSExtrusionProfileNamesSorted.append(ExtrProfile().getAllEntryNames());
for(int s1=1;s1<arSExtrusionProfileNamesSorted.length();s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		String sA = arSExtrusionProfileNamesSorted[s11];
		sA.makeUpper();
		String sB = arSExtrusionProfileNamesSorted[s2];
		sB.makeUpper();
		if( sA < sB ){
			arSExtrusionProfileNamesSorted.swap(s2, s11);
			s11=s2;
		}
	}
}
int nIndexRectangularProfile = arSExtrusionProfileNamesSorted.find(_kExtrProfRectangular);
if( nIndexRectangularProfile > 0 ){
	arSExtrusionProfileNamesSorted.removeAt(nIndexRectangularProfile);
	arSExtrusionProfileNamesSorted.insertAt(0, _kExtrProfRectangular);
}

PropString sSeperator01(0, "", T("|Extrusion profile|"));
sSeperator01.setReadOnly(true);

PropString sExtrusionProfileName(1, arSExtrusionProfileNamesSorted, "     "+T("|Extrusion profile name|"),0);
PropString sMaterialName(2, "", "     "+T("|Material|"));
String arSField[] = {
	T("|Do not copy profile name|"),
	T("|Information|")
};
PropString sCopyProfileNameToField(3, arSField, "     "+T("|Copy profile name to|"));


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_W-ProfiledHeader");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

//Insert
if( _bOnInsert ){
	//Erase after 1 cycle
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	int nNrOfTslsInserted = 0;
	PrEntity ssE(T("|Select one or more openings|"), OpeningSF());
	if (ssE.go()) {
		Entity arSelectedOpenings[] = ssE.set();

		//insertion point
		String strScriptName = "HSB_W-ProfiledHeader"; // name of the script
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
		for( int i=0;i<arSelectedOpenings.length();i++ ){
			OpeningSF opSF = (OpeningSF)arSelectedOpenings[i];
			if( !opSF.bIsValid() ){
				continue;
			}
			lstEntities[0] = opSF;
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			nNrOfTslsInserted++;
		}
	}
	
	reportMessage("\n"+nNrOfTslsInserted + T(" |tsl(s) inserted|"));	
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

int bManualInsert = false;
if( _Map.hasInt("ManualInsert") ){
	bManualInsert = _Map.getInt("ManualInsert");
	_Map.removeAt("ManualInsert", true);
}

//Check if there is a valid opening present
if( _Entity.length() == 0 ){
	eraseInstance();
	return;
}

int nCopyProfileNameToField = arSField.find(sCopyProfileNameToField,0);

//Get selected opening
OpeningSF op = (OpeningSF)_Entity[0];
if( !op.bIsValid() ){
	eraseInstance();
	return;
}

Element el = op.element();
if( !el.bIsValid() ){
	eraseInstance();
	return;
}

CoordSys csEl = el.coordSys();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Point3d ptOp = Body(op.plShape(),vzEl).ptCen();
_Pt0 = ptOp;

//All beams
Beam arBm[] = el.beam();
Beam arBmHeader[0];
for( int i=0;i<arBm.length();i++ ){
	Beam bm = arBm[i];
	if( bm.type() == _kHeader ){
		if( (vxEl.dotProduct(ptOp - (bm.ptRef() + bm.vecX() * bm.dLMin())) * vxEl.dotProduct(ptOp - (bm.ptRef() + bm.vecX() * bm.dLMax()))) > 0 )
			continue;
		
		arBmHeader.append(bm);
	}
}

int nNrOfEntitiesChanged = 0;
for( int i=0;i<arBmHeader.length();i++ ){
	Beam bmHeader = arBmHeader[i];
	bmHeader.setExtrProfile(sExtrusionProfileName);
	if( sMaterialName != "" )
		bmHeader.setMaterial(sMaterialName);
	if( nCopyProfileNameToField == 1 )
		bmHeader.setInformation(sExtrusionProfileName);
	nNrOfEntitiesChanged++;
}

if( _bOnElementConstructed || bManualInsert ){
	reportMessage(TN("|Headers are changed|! ") + nNrOfEntitiesChanged + T(" |entities changed|."));
	eraseInstance();
}



#End
#BeginThumbnail


#End
