#Version 8
#BeginDescription

1.1 24/01/2024 Add operations Author: Robert Pol
1.3 25/01/2024 Add prop to use filter on props Author: Robert Pol

1.2 24/01/2024 Also use include exclude on beamtypes Author: Robert Pol

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl integrates the beams in the connecting beams.
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="18.11.2013"></version>
// #Versions
//1.3 25/01/2024 Add prop to use filter on props Author: Robert Pol
//1.2 24/01/2024 Also use include exclude on beamtypes Author: Robert Pol
//1.1 24/01/2024 Add operations Author: Robert Pol

/// <history>
/// AS - 1.00 - 02.05.2013 -	Pilot version
/// </history>

if( _bOnElementDeleted )
{
	eraseInstance();
	return;
}

int executeMode = 0; // 0 = default, 1 = insert/recalc

Unit (1,"mm");
double dEps = U(0.05);

// Filter options
String operations[] = {
	T("|Exclude|"),
	T("|Include|")
};

String yesNo[] = 
{
	T("|Yes|"),
	T("|No|")
};

/// - Filter -
///
PropString sSeparator01(0, "", T("|Filter|"));
sSeparator01.setReadOnly(true);
PropString sFilterBC(1,"","     "+T("|Filter beams with beamcode|"));
PropString sFilterLabel(2,"","     "+T("|Filter beams and sheets with label|"));
PropString sFilterMaterial(3,"","     "+T("|Filter beams and sheets with material|"));
PropString sFilterOperation(7, operations, "     "+T("|Filter operation|"));

String arSBeamProperties[] = {
	T("|Beam Type|")
};
PropString sSeparator02(4, "", T("|Extend beam|"));
sSeparator02.setReadOnly(true);
PropString sBeamProperty(5, arSBeamProperties, "     "+T("|Beam property|"));
PropString sBeamType(6, _BeamTypes, "     "+T("|Beam type|"));
PropString sUsePropsForFiltering(8, yesNo, "     "+T("|Use props for filtering|"));

PropDouble dExtendWith(0, U(2), "     "+T("|Extend with|"));


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-ExtendBeam");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	PrEntity ssE(T("|Select a set of elements|"),Element());
	if(ssE.go()){
		_Element.append(ssE.elementSet());
	}
	
	String strScriptName = "HSB_E-ExtendBeam"; // name of the script
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
int exclude = (operations.find(sFilterOperation) == 0);
int usePropsForFiltering = (yesNo.find(sUsePropsForFiltering) == 0);
int include;
// Resolve properties

String sFBC = sFilterBC + ";";
sFBC.makeUpper();
String arSExcludeBC[0];
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
	sTokenBC.trimLeft();
	sTokenBC.trimRight();
	arSExcludeBC.append(sTokenBC);
}
String sFLabel = sFilterLabel + ";";
sFLabel.makeUpper();
String arSExcludeLbl[0];
int nIndexLabel = 0; 
int sIndexLabel = 0;
while(sIndexLabel < sFLabel.length()-1){
	String sTokenLabel = sFLabel.token(nIndexLabel);
	nIndexLabel++;
	if(sTokenLabel.length()==0){
		sIndexLabel++;
		continue;
	}
	sIndexLabel = sFLabel.find(sTokenLabel,0);

	arSExcludeLbl.append(sTokenLabel);
}
String sFMaterial = sFilterMaterial + ";";
sFMaterial.makeUpper();
String arSExcludeMat[0];
int nIndexMaterial = 0; 
int sIndexMaterial = 0;
while(sIndexMaterial < sFMaterial.length()-1){
	String sTokenMaterial = sFMaterial.token(nIndexMaterial);
	nIndexMaterial++;
	if(sTokenMaterial.length()==0){
		sIndexMaterial++;
		continue;
	}
	sIndexMaterial = sFMaterial.find(sTokenMaterial,0);

	arSExcludeMat.append(sTokenMaterial);
}

int nBeamType = _BeamTypes.find(sBeamType);

Beam arBm[0];
Beam arBmToExtend[0];
Beam arBmAll[] = el.beam();
for(int i=0;i<arBmAll.length();i++){
	Beam bm = arBmAll[i];
	int bExcludeGenBeam = false;
	
	//Exclude dummies
	if( bm.bIsDummy() )
		continue;
	
	//Exclude labels
	String sLabel = bm.label().makeUpper();
	sLabel.trimLeft();
	sLabel.trimRight();
	if( arSExcludeLbl.find(sLabel)!= -1 ){
		bExcludeGenBeam = true;
	}
	else{
		for( int j=0;j<arSExcludeLbl.length();j++ ){
			String sExclLbl = arSExcludeLbl[j];
			String sExclLblTrimmed = sExclLbl;
			sExclLblTrimmed.trimLeft("*");
			sExclLblTrimmed.trimRight("*");
			if( sExclLblTrimmed == "" )
				continue;
			if( sExclLbl.left(1) == "*" && sExclLbl.right(1) == "*" && sLabel.find(sExclLblTrimmed, 0) != -1 )
				bExcludeGenBeam = true;
			else if( sExclLbl.left(1) == "*" && sLabel.right(sExclLbl.length() - 1) == sExclLblTrimmed )
				bExcludeGenBeam = true;
			else if( sExclLbl.right(1) == "*" && sLabel.left(sExclLbl.length() - 1) == sExclLblTrimmed )
				bExcludeGenBeam = true;
		}
	}
	if( bExcludeGenBeam && exclude)
	{
		continue;
	}
	else if (bExcludeGenBeam)
	{
		include = true;
	}
	
	//Exclude material
	String sMaterial = bm.material().makeUpper();
	sMaterial.trimLeft();
	sMaterial.trimRight();
	if( arSExcludeMat.find(sMaterial)!= -1 ){
		bExcludeGenBeam = true;
	}
	else{
		for( int j=0;j<arSExcludeMat.length();j++ ){
			String sExclMat = arSExcludeMat[j];
			String sExclMatTrimmed = sExclMat;
			sExclMatTrimmed.trimLeft("*");
			sExclMatTrimmed.trimRight("*");
			if( sExclMatTrimmed == "" )
				continue;
			if( sExclMat.left(1) == "*" && sExclMat.right(1) == "*" && sMaterial.find(sExclMatTrimmed, 0) != -1 )
				bExcludeGenBeam = true;
			else if( sExclMat.left(1) == "*" && sMaterial.right(sExclMat.length() - 1) == sExclMatTrimmed )
				bExcludeGenBeam = true;
			else if( sExclMat.right(1) == "*" && sMaterial.left(sExclMat.length() - 1) == sExclMatTrimmed )
				bExcludeGenBeam = true;
		}
	}
	if( bExcludeGenBeam && exclude)
	{
		continue;
	}
	else if (bExcludeGenBeam)
	{
		include = true;
	}

	
	//Exclude beamcodes
	String sBmCode = bm.beamCode().token(0).makeUpper();
	sBmCode.trimLeft();
	sBmCode.trimRight();
	
	if( arSExcludeBC.find(sBmCode)!= -1 ){
		bExcludeGenBeam = true;
	}
	else{
		for( int j=0;j<arSExcludeBC.length();j++ ){
			String sExclBC = arSExcludeBC[j];
			String sExclBCTrimmed = sExclBC;
			sExclBCTrimmed.trimLeft("*");
			sExclBCTrimmed.trimRight("*");
			if( sExclBCTrimmed == "" ){
				if( sExclBC == "*" && sBmCode != "" )
					bExcludeGenBeam = true;
				else
					continue;
			}
			else{
				if( sExclBC.left(1) == "*" && sExclBC.right(1) == "*" && sBmCode.find(sExclBCTrimmed, 0) != -1 )
					bExcludeGenBeam = true;
				else if( sExclBC.left(1) == "*" && sBmCode.right(sExclBC.length() - 1) == sExclBCTrimmed )
					bExcludeGenBeam = true;
				else if( sExclBC.right(1) == "*" && sBmCode.left(sExclBC.length() - 1) == sExclBCTrimmed )
					bExcludeGenBeam = true;
			}
		}
	}
	if( bExcludeGenBeam && exclude)
	{
		continue;
	}
	else if (bExcludeGenBeam)
	{
		include = true;
	}

	
	arBm.append(bm);
	
	if (exclude || include)
	{
		if (usePropsForFiltering)
		{
			int nBeamProperty = arSBeamProperties.find(sBeamProperty);
			if ( nBeamProperty == 0 ) {
				if ( bm.type() == nBeamType)
				{
					arBmToExtend.append(bm);
				}
			}
		}
		else
		{
			arBmToExtend.append(bm);
					}
	}
}


for( int i=0;i<arBmToExtend.length();i++ ){
	Beam bm = arBmToExtend[i];
	
	Point3d ptBmStart = bm.ptCenSolid() - bm.vecX() * 0.5 * (bm.solidLength() + dExtendWith);
	Point3d ptBmEnd = bm.ptCenSolid() + bm.vecX() * 0.5 * (bm.solidLength() + dExtendWith);
	
	Cut cutStart(ptBmStart, -bm.vecX());
	Cut cutEnd(ptBmEnd, bm.vecX());
	
	bm.addToolStatic(cutStart, _kStretchOnInsert);
	bm.addToolStatic(cutEnd, _kStretchOnInsert);
}

eraseInstance();
return;




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
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Add prop to use filter on props" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="1/25/2024 8:50:22 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Also use include exclude on beamtypes" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="1/24/2024 1:34:39 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add operations" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="1/24/2024 10:36:51 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End