#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
29.01.2013  -  version 1.5


























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This moves beams to loose delivery groups
/// </summary>

/// <insert>
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.05" date="29.01.2013"></version>

/// <history>
/// AS - 1.00 - 22.05.2012 -	Pilot version
/// AS - 1.01 - 20.06.2012 -	Add support for 4 different loose provide groups
/// AS - 1.02 - 12.07.2012 -	Erase intersecting beams in the specified floorgroups
/// AS - 1.03 - 19.11.2012 -	Add floorgroup as default group
/// AS - 1.04 - 27.12.2012 -	Correct bug on intersection check.
/// AS - 1.05 - 29.01.2013 -	Add option to add loose delivery beams to schwelle group
/// </history>

if( _bOnElementDeleted ){
	eraseInstance();
	return;
}


String arSNameGroup[0];
Group arGroup[0];
arSNameGroup.append(T("|Parent floorgroup|"));
arGroup.append(Group());
arSNameGroup.append(T("|Schwelle of parent floorgroup|"));
arGroup.append(Group());
Group arAllGroups[] = Group().allExistingGroups();
for( int i=0;i<arAllGroups.length();i++ ){
	Group grp = arAllGroups[i];
	if( grp.namePart(1) != ""){
		if( grp.namePart(1).find("Los", 0) != -1 || grp.namePart(1).find("Loose", 0) != -1 ){
			arSNameGroup.append(grp.name());
			arGroup.append(grp);
		}
	}
}

PropString sSeperator01(0, "", T("|Loose delivery 1|"));
sSeperator01.setReadOnly(true);
PropString sNameGroup01(1, arSNameGroup, "     "+T("|Group| 1"));
PropString sBeamCodes01(2, "", "     "+T("|Beamcodes| 1"));

PropString sSeperator02(3, "", T("|Loose delivery 2|"));
sSeperator02.setReadOnly(true);
PropString sNameGroup02(4, arSNameGroup, "     "+T("|Group| 2"));
PropString sBeamCodes02(5, "", "     "+T("|Beamcodes| 2"));

PropString sSeperator03(6, "", T("|Loose delivery 3|"));
sSeperator03.setReadOnly(true);
PropString sNameGroup03(7, arSNameGroup, "     "+T("|Group| 3"));
PropString sBeamCodes03(8, "", "     "+T("|Beamcodes| 3"));

PropString sSeperator04(9, "", T("|Loose delivery 4|"));
sSeperator04.setReadOnly(true);
PropString sNameGroup04(10, arSNameGroup, "     "+T("|Group| 4"));
PropString sBeamCodes04(11, "", "     "+T("|Beamcodes| 4"));


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_G-LooseDelivery");
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
		String strScriptName = "HSB_G-LooseDelivery"; // name of the script
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
	return;
}

Element el = _Element[0];
Group grpElement = el.elementGroup();
Group grpFloor = Group(grpElement.namePart(0), grpElement.namePart(1), "");
Group grpFloorSchwelle = Group(grpElement.namePart(0), grpElement.namePart(1), "Schwelle");

int nGrpIndex = arSNameGroup.find(sNameGroup01);
if( nGrpIndex == -1 ){
	reportMessage(TN("|Group not found|! ")+scriptName()+T(" |is not executed for element| ")+el.code());
	eraseInstance();
	return;
}
Group grp01;
if( nGrpIndex == 0 )
	grp01 = grpFloor;
else if( nGrpIndex == 1 )
	grp01 = grpFloorSchwelle;
else
	grp01 = arGroup[nGrpIndex];
String sBC = sBeamCodes01 + ";";
sBC.makeUpper();
String arSBmCode01[0];
int nIndexBC = 0; 
int sIndexBC = 0;
while(sIndexBC < sBC.length()-1){
	String sTokenBC = sBC.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0){
		sIndexBC++;
		continue;
	}
	sIndexBC = sBC.find(sTokenBC,0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSBmCode01.append(sTokenBC);
}

nGrpIndex = arSNameGroup.find(sNameGroup02);
if( nGrpIndex == -1 ){
	reportMessage(TN("|Group not found|! ")+scriptName()+T(" |is not executed for element| ")+el.code());
	eraseInstance();
	return;
}
Group grp02;
if( nGrpIndex == 0 )
	grp02 = grpFloor;
else if( nGrpIndex == 1 )
	grp02 = grpFloorSchwelle;
else
	grp02 = arGroup[nGrpIndex];
sBC = sBeamCodes02 + ";";
sBC.makeUpper();
String arSBmCode02[0];
nIndexBC = 0; 
sIndexBC = 0;
while(sIndexBC < sBC.length()-1){
	String sTokenBC = sBC.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0){
		sIndexBC++;
		continue;
	}
	sIndexBC = sBC.find(sTokenBC,0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSBmCode02.append(sTokenBC);
}

nGrpIndex = arSNameGroup.find(sNameGroup03);
if( nGrpIndex == -1 ){
	reportMessage(TN("|Group not found|! ")+scriptName()+T(" |is not executed for element| ")+el.code());
	eraseInstance();
	return;
}
Group grp03;
if( nGrpIndex == 0 )
	grp03 = grpFloor;
else if( nGrpIndex == 1 )
	grp03 = grpFloorSchwelle;
else
	grp03 = arGroup[nGrpIndex];
sBC = sBeamCodes03 + ";";
sBC.makeUpper();
String arSBmCode03[0];
nIndexBC = 0; 
sIndexBC = 0;
while(sIndexBC < sBC.length()-1){
	String sTokenBC = sBC.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0){
		sIndexBC++;
		continue;
	}
	sIndexBC = sBC.find(sTokenBC,0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSBmCode03.append(sTokenBC);
}

nGrpIndex = arSNameGroup.find(sNameGroup04);
if( nGrpIndex == -1 ){
	reportMessage(TN("|Group not found|! ")+scriptName()+T(" |is not executed for element| ")+el.code());
	eraseInstance();
	return;
}
Group grp04;
if( nGrpIndex == 0 )
	grp04 = grpFloor;
else if( nGrpIndex == 1 )
	grp04 = grpFloorSchwelle;
else
	grp04 = arGroup[nGrpIndex];
sBC = sBeamCodes04 + ";";
sBC.makeUpper();
String arSBmCode04[0];
nIndexBC = 0; 
sIndexBC = 0;
while(sIndexBC < sBC.length()-1){
	String sTokenBC = sBC.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0){
		sIndexBC++;
		continue;
	}
	sIndexBC = sBC.find(sTokenBC,0);
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSBmCode04.append(sTokenBC);
}

Entity arEntGrp01[] = grp01.collectEntities(true, Beam(),  _kModelSpace);
Entity arEntGrp02[] = grp02.collectEntities(true, Beam(),  _kModelSpace);
Entity arEntGrp03[] = grp03.collectEntities(true, Beam(),  _kModelSpace);
Entity arEntGrp04[] = grp04.collectEntities(true, Beam(),  _kModelSpace);

Beam arBm[] = el.beam();

Beam arNewBmGrp01[0];
Beam arNewBmGrp02[0];
Beam arNewBmGrp03[0];
Beam arNewBmGrp04[0];
for( int i=0;i<arBm.length();i++ ){
	Beam bm = arBm[i];
	String sBmCode = bm.beamCode().token(0);
	sBmCode.trimLeft();
	sBmCode.trimRight();
	sBmCode.makeUpper();
	
	if( arSBmCode01.find(sBmCode) != -1 ){
		grp01.addEntity(bm, true);
		arNewBmGrp01.append(bm);
	}
	else if( arSBmCode02.find(sBmCode) != -1 ){
		grp02.addEntity(bm, true);
		arNewBmGrp02.append(bm);
	}
	else if( arSBmCode03.find(sBmCode) != -1 ){
		grp03.addEntity(bm, true);
		arNewBmGrp03.append(bm);
	}
	else if( arSBmCode04.find(sBmCode) != -1 ){
		grp04.addEntity(bm, true);
		arNewBmGrp04.append(bm);
	}
}

for( int i=0;i<arNewBmGrp01.length();i++ ){
	Beam bm = arNewBmGrp01[i];
	
	for( int j=0;j<arEntGrp01.length();j++ ){
		Entity ent = arEntGrp01[j];
		Beam bmEnt = (Beam)ent;
		if( !bmEnt.bIsValid() )
			continue;
		
		Body bdEnt = bmEnt.envelopeBody(true, true);
		double dVolumeBdEnt = bdEnt.volume();
		Body bdBm = bm.envelopeBody(true, true);
		if( bdEnt.hasIntersection(bdBm) ){
			int intersected = bdEnt.intersectWith(bdBm);
			double dVolumeIntersect = bdEnt.volume();
			
			if( dVolumeIntersect >= 0.85 * dVolumeBdEnt )
				ent.dbErase();
		}
	}
}

for( int i=0;i<arNewBmGrp02.length();i++ ){
	Beam bm = arNewBmGrp02[i];
	
	for( int j=0;j<arEntGrp02.length();j++ ){
		Entity ent = arEntGrp02[j];
		Beam bmEnt = (Beam)ent;
		if( !bmEnt.bIsValid() )
			continue;
		
		Body bdEnt = bmEnt.envelopeBody(true, true);
		double dVolumeBdEnt = bdEnt.volume();
		Body bdBm = bm.envelopeBody(true, true);
		if( bdEnt.hasIntersection(bdBm) ){
			int intersected = bdEnt.intersectWith(bdBm);
			double dVolumeIntersect = bdEnt.volume();

			if( dVolumeIntersect >= 0.85 * dVolumeBdEnt )
				ent.dbErase();
		}
	}
}

for( int i=0;i<arNewBmGrp03.length();i++ ){
	Beam bm = arNewBmGrp03[i];
	
	for( int j=0;j<arEntGrp03.length();j++ ){
		Entity ent = arEntGrp03[j];
		Beam bmEnt = (Beam)ent;
		if( !bmEnt.bIsValid() )
			continue;
		
		Body bdEnt = bmEnt.envelopeBody(true, true);
		double dVolumeBdEnt = bdEnt.volume();
		Body bdBm = bm.envelopeBody(true, true);
		if( bdEnt.hasIntersection(bdBm) ){
			int intersected = bdEnt.intersectWith(bdBm);
			double dVolumeIntersect = bdEnt.volume();

			if( dVolumeIntersect >= 0.85 * dVolumeBdEnt )
				ent.dbErase();
		}
	}
}

for( int i=0;i<arNewBmGrp04.length();i++ ){
	Beam bm = arNewBmGrp04[i];
	
	for( int j=0;j<arEntGrp04.length();j++ ){
		Entity ent = arEntGrp04[j];
		Beam bmEnt = (Beam)ent;
		if( !bmEnt.bIsValid() )
			continue;
		
		Body bdEnt = bmEnt.envelopeBody(true, true);
		double dVolumeBdEnt = bdEnt.volume();
		Body bdBm = bm.envelopeBody(true, true);
		if( bdEnt.hasIntersection(bdBm) ){
			int intersected = bdEnt.intersectWith(bdBm);
			double dVolumeIntersect = bdEnt.volume();

			if( dVolumeIntersect >= 0.85 * dVolumeBdEnt )
				ent.dbErase();
		}
	}
}

if( _bOnElementConstructed || bManualInsert )
	eraseInstance();







#End
#BeginThumbnail
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
AUKZ+^SP_\\D_[Y%*L,:-N6-0?4"IEB>9-6*C0Y7>Y__9
`



#End
