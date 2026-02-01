#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
23.12.2015  -  version 1.02






















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
/// This splits beams to specific lengths
/// </summary>

/// <insert>
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.02" date="23.12.2015"></version>

/// <history>
/// AS - 1.00 - 22.05.2012 -	Pilot version
/// AS - 1.01 - 17.10.2012 -	Extend to a set of 6 lengths
/// AS - 1.02 - 23.12.2015 -	Add categories, set properties if tsl is attached to the element definition.
/// </history>

String categories[] = {
	T("|General|"),
	T("|Length 1|"),
	T("|Length 2|"),
	T("|Length 3|"),
	T("|Length 4|"),
	T("|Length 5|"),
	T("|Length 6|")
};

PropInt sequenceNumber(0, 0, T("|Sequence number|"));
sequenceNumber.setDescription(T("|The sequence number is used to sort the list of tsl's during generate construction|"));
sequenceNumber.setCategory(categories[0]);

PropDouble dLength01(0, U(2440), "     "+T("|Length| 1"));
dLength01.setCategory(categories[1]);
PropString sBeamCodes01(0, "", "     "+T("|Beamcodes| 1"));
sBeamCodes01.setCategory(categories[1]);

PropDouble dLength02(1, U(5400), "     "+T("|Length| 2"));
dLength02.setCategory(categories[2]);
PropString sBeamCodes02(1, "", "     "+T("|Beamcodes| 2"));
sBeamCodes02.setCategory(categories[2]);

PropDouble dLength03(2, U(5400), "     "+T("|Length| 3"));
dLength03.setCategory(categories[3]);
PropString sBeamCodes03(2, "", "     "+T("|Beamcodes| 3"));
sBeamCodes03.setCategory(categories[3]);

PropDouble dLength04(3, U(5400), "     "+T("|Length| 4"));
dLength04.setCategory(categories[4]);
PropString sBeamCodes04(3, "", "     "+T("|Beamcodes| 4"));
sBeamCodes04.setCategory(categories[4]);

PropDouble dLength05(4, U(5400), "     "+T("|Length| 5"));
dLength05.setCategory(categories[5]);
PropString sBeamCodes05(4, "", "     "+T("|Beamcodes| 5"));
sBeamCodes05.setCategory(categories[5]);

PropDouble dLength06(5, U(5400), "     "+T("|Length| 6"));
dLength06.setCategory(categories[6]);
PropString sBeamCodes06(5, "", "     "+T("|Beamcodes| 6"));
sBeamCodes06.setCategory(categories[6]);

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_G-OptimizeBeams");
if( _kExecuteKey != "" && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	setCatalogFromPropValues(T("|_LastInserted|"));

	int nNrOfTslsInserted = 0;
	//Select beam(s) and insertion point
	PrEntity ssE(T("|Select one or more elements|"), Element());
	if (ssE.go()) {
		Element arSelectedElements[] = ssE.elementSet();
		
		//insertion point
		String strScriptName = "HSB_G-OptimizeBeams"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("ManualInserted", true);
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

if (_Element.length() == 0) {
	reportWarning(T("|Invalid or no element selected.|"));
	eraseInstance();
	return;
}

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) {
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
	setPropValuesFromCatalog(T("|_LastInserted|"));

// Set the sequence number
_ThisInst.setSequenceNumber(sequenceNumber);
	
if( _bOnDebug || _bOnElementConstructed || manualInserted ){
	Element el = _Element[0];
	
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
	
	sBC = sBeamCodes05 + ";";
	sBC.makeUpper();
	String arSBmCode05[0];
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
		arSBmCode05.append(sTokenBC);
	}
	
	sBC = sBeamCodes06 + ";";
	sBC.makeUpper();
	String arSBmCode06[0];
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
		arSBmCode06.append(sTokenBC);
	}

	Beam arBm[] = el.beam();
	for( int i=0;i<arBm.length();i++ ){
		Beam bm = arBm[i];
		String sBmCode = bm.beamCode().token(0);
		sBmCode.trimLeft();
		sBmCode.trimRight();
		sBmCode.makeUpper();
		
		if( arSBmCode01.find(sBmCode) != -1 && bm.solidLength() > dLength01 ){
			Beam bmResult = bm;
			int nNrOfLoops = 0;
			while( bmResult.solidLength() > dLength01 ){
				Point3d ptSplit = bm.ptCenSolid() - bm.vecX() * (0.5 * bm.solidLength() - dLength01);
				bmResult = bm.dbSplit(ptSplit, ptSplit);
				bm = bmResult;
				if( nNrOfLoops > 5 )
					break;
				nNrOfLoops++;
			}
		}		
		else if( arSBmCode02.find(sBmCode) != -1 && bm.solidLength() > dLength02 ){
			Beam bmResult = bm;
			int nNrOfLoops = 0;
			while( bmResult.solidLength() > dLength02 ){
				Point3d ptSplit = bm.ptCenSolid() - bm.vecX() * (0.5 * bm.solidLength() - dLength02);
				bmResult = bm.dbSplit(ptSplit, ptSplit);
				bm = bmResult;
				if( nNrOfLoops > 5 )
					break;
				nNrOfLoops++;
			}
		}
		else if( arSBmCode03.find(sBmCode) != -1 && bm.solidLength() > dLength03 ){
			Beam bmResult = bm;
			int nNrOfLoops = 0;
			while( bmResult.solidLength() > dLength03 ){
				Point3d ptSplit = bm.ptCenSolid() - bm.vecX() * (0.5 * bm.solidLength() - dLength03);
				bmResult = bm.dbSplit(ptSplit, ptSplit);
				bm = bmResult;
				if( nNrOfLoops > 5 )
					break;
				nNrOfLoops++;
			}
		}
		else if( arSBmCode04.find(sBmCode) != -1 && bm.solidLength() > dLength04 ){
			Beam bmResult = bm;
			int nNrOfLoops = 0;
			while( bmResult.solidLength() > dLength04 ){
				Point3d ptSplit = bm.ptCenSolid() - bm.vecX() * (0.5 * bm.solidLength() - dLength04);
				bmResult = bm.dbSplit(ptSplit, ptSplit);
				bm = bmResult;
				if( nNrOfLoops > 5 )
					break;
				nNrOfLoops++;
			}
		}
		else if( arSBmCode05.find(sBmCode) != -1 && bm.solidLength() > dLength05 ){
			Beam bmResult = bm;
			int nNrOfLoops = 0;
			while( bmResult.solidLength() > dLength05 ){
				Point3d ptSplit = bm.ptCenSolid() - bm.vecX() * (0.5 * bm.solidLength() - dLength05);
				bmResult = bm.dbSplit(ptSplit, ptSplit);
				bm = bmResult;
				if( nNrOfLoops > 5 )
					break;
				nNrOfLoops++;
			}
		}
		else if( arSBmCode06.find(sBmCode) != -1 && bm.solidLength() > dLength06 ){
			Beam bmResult = bm;
			int nNrOfLoops = 0;
			while( bmResult.solidLength() > dLength06 ){
				Point3d ptSplit = bm.ptCenSolid() - bm.vecX() * (0.5 * bm.solidLength() - dLength06);
				bmResult = bm.dbSplit(ptSplit, ptSplit);
				bm = bmResult;
				if( nNrOfLoops > 5 )
					break;
				nNrOfLoops++;
			}
		}
	}
	
	eraseInstance();
	return;
}



#End
#BeginThumbnail



#End