#Version 8
#BeginDescription
Last modified by: Robert Pol (robert.pol@hsbcad.com)
29.09.2017 - version 2.04
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl sets the visualization type of the drills created by CNC_DrillElement, created through DSP.
/// </summary>

/// <insert>
/// Auto: Attach the tsl to element definition
/// Manual: Select elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="2.04" date="29.09.2017"></version>

/// <history>
/// AS - 1.00 - 09.10.2013 -	Pilot version
/// AS - 2.00 - 04.06.2015 -	Add beam filter options (FogBugzId 1356)
/// AS - 2.01 - 04.06.2015 -	Update thumbnail
/// AS - 2.02 - 23.12.2015 -	Add filters. Set CNC-DrillElement properties through catalog.
/// DR - 2.03 - 03.07.2017	- 	Added option (Yes/No) to erase TSLs that don't match filters
/// RP - 2.04 - 29.09.2017	- 	Set hardcoded sequence number
/// </history>

double dEps = Unit(0.1, "mm");
String sNoYes[] = {T("|No|"),T("|Yes|")};
String categories[] = {
	T("|General|"),
	T("|Selection|"),
	T("|Drill|")
};

int sequenceNumber = 1000;

String arSInExclude[] = {T("|Include|"), T("|Exclude|")};
PropString sInExcludeFilters(1, arSInExclude, T("|Include|")+T("/|exclude|"),1);
sInExcludeFilters.setCategory(categories[1]);
PropString sFilterBC(2,"",T("|Filter beams with beamcode|"));
sFilterBC.setCategory(categories[1]);
PropString sFilterLabel(3,"",T("|Filter objects with label|"));
sFilterLabel.setCategory(categories[1]);
PropString sFilterMaterial(4,"",T("|Filter objects with material|"));
sFilterMaterial.setCategory(categories[1]);
PropString sFilterHsbId(5,"",T("|Filter objects with hsb id|"));
sFilterHsbId.setCategory(categories[1]);

PropString sScriptNameDrill(6, "CNC_DrillElement", T("|Scriptname drill tsl|"));
sScriptNameDrill.setCategory(categories[2]);
sScriptNameDrill.setReadOnly(true);
PropString catalogDrillTsl(0, TslInst().getListOfCatalogNames("CNC_DrillElement"), T("|Visualization Type|"),2);
catalogDrillTsl.setCategory(categories[2]);

PropString sDeleteTSLsIfDontMatchFilter(7, sNoYes, T("|Delete TSLs that don't match filters'|"),1);

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-SetDrillVisualizationType");
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
		String strScriptName = scriptName(); // name of the script
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
	
	// resolve props
	int bExclude = arSInExclude.find(sInExcludeFilters,1);
	int bDeleteTSLsIfDontMatchFilter= sNoYes.find(sDeleteTSLsIfDontMatchFilter,1);
	
	// filter beams with beamcode
	String sFBC = (sFilterBC + ";").makeUpper();
	String arSFBC[0];
	int nIndexBC = 0; 
	int sIndexBC = 0;
	while(sIndexBC < sFBC.length()-1){
		String sTokenBC = sFBC.token(nIndexBC);
		nIndexBC++;
		if(sTokenBC.length()==0){
			sIndexBC++;
			continue;
		}
		sIndexBC = sFBC.find(sTokenBC,0);
	
		arSFBC.append(sTokenBC);
	}
	
	// filter GenBeams with label
	String sFLabel = (sFilterLabel + ";").makeUpper();
	String arSFLabel[0];
	int nIndexLabel = 0; 
	int sIndexLabel = 0;
	while(sIndexLabel < sFLabel.length()-1){
		String sTokenLabel = sFLabel.token(nIndexLabel);
		nIndexLabel++;
		if(sTokenLabel.length()==0){
			sIndexLabel++;
			continue;
		}
		sIndexLabel = sFilterLabel.find(sTokenLabel,0);
	
		arSFLabel.append(sTokenLabel);
	}
	
	String sFMaterial = (sFilterMaterial + ";").makeUpper();
	String arSFMaterial[0];
	int nIndexMaterial = 0; 
	int sIndexMaterial = 0;
	while(sIndexMaterial < sFMaterial.length()-1){
		String sTokenMaterial = sFMaterial.token(nIndexMaterial);
		nIndexMaterial++;
		if(sTokenMaterial.length()==0){
			sIndexMaterial++;
			continue;
		}
		sIndexMaterial = sFilterMaterial.find(sTokenMaterial,0);
	
		arSFMaterial.append(sTokenMaterial);
	}
	
	String sFHsbId = sFilterHsbId + ";";
	String arSFHsbId[0];
	int nIndexHsbId = 0; 
	int sIndexHsbId = 0;
	while(sIndexHsbId < sFHsbId.length()-1){
		String sTokenHsbId = sFHsbId.token(nIndexHsbId);
		nIndexHsbId++;
		if(sTokenHsbId.length()==0){
			sIndexHsbId++;
			continue;
		}
		sIndexHsbId = sFilterHsbId.find(sTokenHsbId,0);
	
		arSFHsbId.append(sTokenHsbId);
	}
	
	if( arSFBC.length() == 0 && arSFLabel.length() == 0 && arSFMaterial.length() == 0 && arSFHsbId.length() == 0)
		bExclude = true;
	
	TslInst arTsl[] = el.tslInst();
	for( int i=0;i<arTsl.length();i++ ){
		TslInst tsl = arTsl[i];
		if (!tsl.bIsValid())
			tsl.dbErase();
		if (tsl.scriptName().makeUpper() !=  sScriptNameDrill.makeUpper())
			continue;
		
		if (tsl.map().hasEntity("Beam")) {
			Entity ent = tsl.map().getEntity("Beam");
			Beam bm = (Beam)ent;
			
			// apply filters
			String sBmCode = bm.beamCode().token(0).makeUpper();
			sBmCode.trimLeft();
			sBmCode.trimRight();
		
			String sLabel = bm.label().makeUpper();
			sLabel.trimLeft();
			sLabel.trimRight();
			
			String sMaterial = bm.material().makeUpper();
			sMaterial.trimLeft();
			sMaterial.trimRight();
			
			String sHsbId = bm.hsbId().makeUpper();
			sHsbId.trimLeft();
			sHsbId.trimRight();
		
		
			int nZnIndex = bm.myZoneIndex();
			
			int bFilterBeam = false;
			if( arSFBC.find(sBmCode) != -1 ) {
				bFilterBeam = true;
			}
			else{
				for( int j=0;j<arSFBC.length();j++ ){
					String sFilter = arSFBC[j];
					String sFilterTrimmed = sFilter;
					sFilterTrimmed.trimLeft("*");
					sFilterTrimmed.trimRight("*");
					if( sFilterTrimmed == "" )
						continue;
					if( sFilter.left(1) == "*" && sFilter.right(1) == "*" && sBmCode.find(sFilterTrimmed, 0) != -1 )
						bFilterBeam = true;
					else if( sFilter.left(1) == "*" && sBmCode.right(sFilter.length() - 1) == sFilterTrimmed )
						bFilterBeam = true;
					else if( sFilter.right(1) == "*" && sBmCode.left(sFilter.length() - 1) == sFilterTrimmed )
						bFilterBeam = true;
				}
			}
			if( arSFLabel.find(sLabel) != -1 ){
				bFilterBeam = true;
			}
			else{
				for( int j=0;j<arSFLabel.length();j++ ){
					String sFilter = arSFLabel[j];
					String sFilterTrimmed = sFilter;
					sFilterTrimmed.trimLeft("*");
					sFilterTrimmed.trimRight("*");
					if( sFilterTrimmed == "" )
						continue;
					if( sFilter.left(1) == "*" && sFilter.right(1) == "*" && sLabel.find(sFilterTrimmed, 0) != -1 )
						bFilterBeam = true;
					else if( sFilter.left(1) == "*" && sLabel.right(sFilter.length() - 1) == sFilterTrimmed )
						bFilterBeam = true;
					else if( sFilter.right(1) == "*" && sLabel.left(sFilter.length() - 1) == sFilterTrimmed )
						bFilterBeam = true;
				}
			}
			if( arSFMaterial.find(sMaterial) != -1 ){
				bFilterBeam = true;
			}
			else{
				for( int j=0;j<arSFMaterial.length();j++ ){
					String sFilter = arSFMaterial[j];
					String sFilterTrimmed = sFilter;
					sFilterTrimmed.trimLeft("*");
					sFilterTrimmed.trimRight("*");
					if( sFilterTrimmed == "" )
						continue;
					if( sFilter.left(1) == "*" && sFilter.right(1) == "*" && sMaterial.find(sFilterTrimmed, 0) != -1 )
						bFilterBeam = true;
					else if( sFilter.left(1) == "*" && sMaterial.right(sFilter.length() - 1) == sFilterTrimmed )
						bFilterBeam = true;
					else if( sFilter.right(1) == "*" && sMaterial.left(sFilter.length() - 1) == sFilterTrimmed )
						bFilterBeam = true;
				}
			}
			if( arSFHsbId.find(sHsbId) != -1 ){
				bFilterBeam = true;
			}
			else{
				for( int j=0;j<arSFHsbId.length();j++ ){
					String sFilter = arSFHsbId[j];
					String sFilterTrimmed = sFilter;
					sFilterTrimmed.trimLeft("*");
					sFilterTrimmed.trimRight("*");
					if( sFilterTrimmed == "" )
						continue;
					if( sFilter.left(1) == "*" && sFilter.right(1) == "*" && sHsbId.find(sFilterTrimmed, 0) != -1 )
						bFilterBeam = true;
					else if( sFilter.left(1) == "*" && sHsbId.right(sFilter.length() - 1) == sFilterTrimmed )
						bFilterBeam = true;
					else if( sFilter.right(1) == "*" && sHsbId.left(sFilter.length() - 1) == sFilterTrimmed )
						bFilterBeam = true;
				}
			}
			if( (bFilterBeam && !bExclude) || (!bFilterBeam && bExclude) )
				int propsSet = tsl.setPropValuesFromCatalog(catalogDrillTsl);
			else if(bDeleteTSLsIfDontMatchFilter)
				tsl.dbErase();
		}
	}

	eraseInstance();
	return;
}










#End
#BeginThumbnail
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
"_]DH
`



#End