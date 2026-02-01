#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
18.09.2015  -  version 1.04


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
/// 
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.04" date="18.19.2015"></version>

/// <history>
/// AS - 1.00 - 20.03.2012 -	Pilot version
/// AS - 1.01 - 22.05.2012 -	Add option to set grade io material
/// AS - 1.02 - 10.07.2012 -	Add material
/// AS - 1.03 - 28.03.2014 -	Give beamcode preference
/// AS - 1.04 - 19.09.2015 -	Extend to 15 sets of materials
/// </history>

String arSMaterial[] = {
	"Fermacell",
	"OSB",
	"Spano",
	"Multiplex",
	"V313",
	"CDX",
	"Underlayment",
	"MUF",
	"PIR",
	"Lauan",
	"Rockpanel",
	"Fins vuren"
};

String arSSetMaterialTo[] = {
	T("|Material|"),
	T("|Grade|")
};
PropString sSetMaterialTo(30, arSSetMaterialTo, T("|Set material to|"), 0);

PropString sSeperator01(0, "", T("|Material| 1"));
sSeperator01.setReadOnly(true);
PropString sMat1(1, arSMaterial, "     "+T("|Material| 1"));
PropString sBmCode1(2, "", "     "+T("|Beamcode| 1"));
sBmCode1.setDescription(T("|The material field of beams with a beamcode from this list is also set|."));

PropString sSeperator02(3, "", T("|Material| 2"));
sSeperator02.setReadOnly(true);
PropString sMat2(4, arSMaterial, "     "+T("|Material| 2"));
PropString sBmCode2(5, "", "     "+T("|Beamcode| 2"));
sBmCode2.setDescription(T("|The material field of beams with a beamcode from this list is also set|."));

PropString sSeperator03(6, "", T("|Material| 3"));
sSeperator03.setReadOnly(true);
PropString sMat3(7, arSMaterial, "     "+T("|Material| 3"));
PropString sBmCode3(8, "", "     "+T("|Beamcode| 3"));
sBmCode3.setDescription(T("|The material field of beams with a beamcode from this list is also set|."));

PropString sSeperator04(9, "", T("|Material| 4"));
sSeperator04.setReadOnly(true);
PropString sMat4(10, arSMaterial, "     "+T("|Material| 4"));
PropString sBmCode4(11, "", "     "+T("|Beamcode| 4"));
sBmCode4.setDescription(T("|The material field of beams with a beamcode from this list is also set|."));

PropString sSeperator05(12, "", T("|Material| 5"));
sSeperator05.setReadOnly(true);
PropString sMat5(13, arSMaterial, "     "+T("|Material| 5"));
PropString sBmCode5(14, "", "     "+T("|Beamcode| 5"));
sBmCode5.setDescription(T("|The material field of beams with a beamcode from this list is also set|."));

PropString sSeperator06(15, "", T("|Material| 6"));
sSeperator06.setReadOnly(true);
PropString sMat6(16, arSMaterial, "     "+T("|Material| 6"));
PropString sBmCode6(17, "", "     "+T("|Beamcode| 6"));
sBmCode6.setDescription(T("|The material field of beams with a beamcode from this list is also set|."));

PropString sSeperator07(18, "", T("|Material| 7"));
sSeperator07.setReadOnly(true);
PropString sMat7(19, arSMaterial, "     "+T("|Material| 7"));
PropString sBmCode7(20, "", "     "+T("|Beamcode| 7"));
sBmCode7.setDescription(T("|The material field of beams with a beamcode from this list is also set|."));

PropString sSeperator08(21, "", T("|Material| 8"));
sSeperator08.setReadOnly(true);
PropString sMat8(22, arSMaterial, "     "+T("|Material| 8"));
PropString sBmCode8(23, "", "     "+T("|Beamcode| 8"));
sBmCode8.setDescription(T("|The material field of beams with a beamcode from this list is also set|."));

PropString sSeperator09(24, "", T("|Material| 9"));
sSeperator09.setReadOnly(true);
PropString sMat9(25, arSMaterial, "     "+T("|Material| 9"));
PropString sBmCode9(26, "", "     "+T("|Beamcode| 9"));
sBmCode9.setDescription(T("|The material field of beams with a beamcode from this list is also set|."));

PropString sSeperator010(27, "", T("|Material| 10"));
sSeperator010.setReadOnly(true);
PropString sMat10(28, arSMaterial, "     "+T("|Material| 10"));
PropString sBmCode10(29, "", "     "+T("|Beamcode| 10"));
sBmCode10.setDescription(T("|The material field of beams with a beamcode from this list is also set|."));

PropString sSeperator011(31, "", T("|Material| 11"));
sSeperator011.setReadOnly(true);
PropString sMat11(32, arSMaterial, "     "+T("|Material| 11"));
PropString sBmCode11(33, "", "     "+T("|Beamcode| 11"));
sBmCode11.setDescription(T("|The material field of beams with a beamcode from this list is also set|."));

PropString sSeperator012(34, "", T("|Material| 12"));
sSeperator012.setReadOnly(true);
PropString sMat12(35, arSMaterial, "     "+T("|Material| 12"));
PropString sBmCode12(36, "", "     "+T("|Beamcode| 12"));
sBmCode12.setDescription(T("|The material field of beams with a beamcode from this list is also set|."));

PropString sSeperator013(37, "", T("|Material| 13"));
sSeperator013.setReadOnly(true);
PropString sMat13(38, arSMaterial, "     "+T("|Material| 13"));
PropString sBmCode13(39, "", "     "+T("|Beamcode| 13"));
sBmCode13.setDescription(T("|The material field of beams with a beamcode from this list is also set|."));

PropString sSeperator014(40, "", T("|Material| 14"));
sSeperator014.setReadOnly(true);
PropString sMat14(41, arSMaterial, "     "+T("|Material| 14"));
PropString sBmCode14(42, "", "     "+T("|Beamcode| 14"));
sBmCode14.setDescription(T("|The material field of beams with a beamcode from this list is also set|."));

PropString sSeperator015(43, "", T("|Material| 15"));
sSeperator015.setReadOnly(true);
PropString sMat15(44, arSMaterial, "     "+T("|Material| 15"));
PropString sBmCode15(45, "", "     "+T("|Beamcode| 15"));
sBmCode15.setDescription(T("|The material field of beams with a beamcode from this list is also set|."));

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_G-SetMaterial");
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
		String strScriptName = "HSB_G-SetMaterial"; // name of the script
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

String arSMatKey[0];				String arSMatValue[0];				String arSMatCodeList[0];
arSMatKey.append("MAT1");		arSMatValue.append(sMat1);			arSMatCodeList.append(sBmCode1);
arSMatKey.append("MAT2");		arSMatValue.append(sMat2);			arSMatCodeList.append(sBmCode2);
arSMatKey.append("MAT3");		arSMatValue.append(sMat3);			arSMatCodeList.append(sBmCode3);
arSMatKey.append("MAT4");		arSMatValue.append(sMat4);			arSMatCodeList.append(sBmCode4);
arSMatKey.append("MAT5");		arSMatValue.append(sMat5);			arSMatCodeList.append(sBmCode5);
arSMatKey.append("MAT6");		arSMatValue.append(sMat6);			arSMatCodeList.append(sBmCode6);
arSMatKey.append("MAT7");		arSMatValue.append(sMat7);			arSMatCodeList.append(sBmCode7);
arSMatKey.append("MAT8");		arSMatValue.append(sMat8);			arSMatCodeList.append(sBmCode8);
arSMatKey.append("MAT9");		arSMatValue.append(sMat9);			arSMatCodeList.append(sBmCode9);
arSMatKey.append("MAT10");	arSMatValue.append(sMat10);		arSMatCodeList.append(sBmCode10);
arSMatKey.append("MAT11");	arSMatValue.append(sMat11);		arSMatCodeList.append(sBmCode11);
arSMatKey.append("MAT12");	arSMatValue.append(sMat12);		arSMatCodeList.append(sBmCode12);
arSMatKey.append("MAT13");	arSMatValue.append(sMat13);		arSMatCodeList.append(sBmCode13);
arSMatKey.append("MAT14");	arSMatValue.append(sMat14);		arSMatCodeList.append(sBmCode14);
arSMatKey.append("MAT15");	arSMatValue.append(sMat15);		arSMatCodeList.append(sBmCode15);

if( _Element.length() == 0 ){
	eraseInstance();
	return;
}
Element el = _Element[0];

int nSetMaterialTo = arSSetMaterialTo.find(sSetMaterialTo, 0);

int nNrOfEntitiesChanged = 0;
GenBeam arGBm[] = el.genBeam();
for( int i=0;i<arGBm.length();i++ ){
	GenBeam gBm = arGBm[i];
	if( !gBm.bIsValid() )
		continue;
	
	String sMaterial = gBm.material().makeUpper();
	String sBmCode = gBm.beamCode().token(0).makeUpper();
	
	Beam bm  = (Beam)gBm;
	Sheet sh  = (Sheet)gBm;
	
	if( sh.bIsValid() ){
		int nMatIndex = arSMatKey.find(sMaterial);
		if( nMatIndex == -1 )
			continue;
		
		if( nSetMaterialTo == 0 )
			sh.setMaterial(arSMatValue[nMatIndex]);
		else if( nSetMaterialTo == 0 )
			sh.setGrade(arSMatValue[nMatIndex]);
			
		nNrOfEntitiesChanged++;
	}
	
	if( bm.bIsValid() ){
		
		int bMatSet = false;
		for( int j=0;j<arSMatCodeList.length();j++ ){
			String sMatCode = arSMatCodeList[j];
			
			String sMCode = sMatCode + ";";
			sMCode.makeUpper();
			String arSMatCode[0];
			int nIndexBC = 0; 
			int sIndexBC = 0;
			while(sIndexBC < sMCode.length()-1){
				String sTokenBC = sMCode.token(nIndexBC);
				nIndexBC++;
				if(sTokenBC.length()==0){
					sIndexBC++;
					continue;
				}
				sIndexBC = sMCode.find(sTokenBC,0);
				sTokenBC.trimLeft();
				sTokenBC.trimRight();
				arSMatCode.append(sTokenBC);
			}
			
			if( arSMatCode.find(sBmCode) != -1 ){
				if( nSetMaterialTo == 0 )
					bm.setMaterial(arSMatValue[j]);
				else if( nSetMaterialTo == 1 )
					bm.setGrade(arSMatValue[j]);

				nNrOfEntitiesChanged++;
				
				bMatSet = true;

				break;
			}
		}
		if (bMatSet)
			continue;
		
		int nMatIndex = arSMatKey.find(sMaterial);
		if( nMatIndex > -1 ){
			if( nSetMaterialTo == 0 )
				bm.setMaterial(arSMatValue[nMatIndex]);
			else if( nSetMaterialTo == 1 )
				bm.setGrade(arSMatValue[nMatIndex]);
				
			nNrOfEntitiesChanged++;

			continue;
		}

	}
}


if( _bOnElementConstructed || bManualInsert ){
	reportMessage(TN("|Material set|! ") + nNrOfEntitiesChanged + T(" |entities changed|."));
	eraseInstance();
}



#End
#BeginThumbnail




#End