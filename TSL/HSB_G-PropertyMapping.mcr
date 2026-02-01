#Version 8
#BeginDescription
#Versions
Version 2.9 17-11-2022 Add option to insert the tsl via DspToTsl. Ronald van Wijngaarden
2.8 08.10.2021 HSB-13305: expose sequence number as a property Author: Marsel Nakuci
2.7 22/07/2021 Add support to use with a list of genbeams Author: Robert Pol
































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 9
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Tsl to map properties
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="2.06" date="08.04.2020"></version>

/// <history>
/// AS - 1.00 - 17.07.2014 - 	Pilot version
/// AS - 1.01 - 08.07.2014 - 	Set sequence number to 2000.
/// AS - 1.02 - 21.11.2014 -	 	Trim white spaces.
/// AS - 2.00 - 20.04.2017 - 	Extend number of properties to map to.
/// YB - 2.01 - 19.05.2017 - 	Added extrusion profile to the filter options.
/// YB - 2.02 - 19.05.2017 - 	Made the extrusion profile property easier to understand.
/// FA - 2.03 - 13.06.2018 -		Added filter and adding of isotropic, also added another input for the type, you can now enter number or type by name.
/// FA - 2.04 - 14.06.2018 -	 	Added filter and setting of zones. 
/// FA - 2.05 - 08.04.2020 -	Added the option for the user to set the Zone layer by using Characters in front of the Zone number.
/// FA - 2.06 - 08.04.2020 -	Make the default of the zone layer the current layer.

// #Versions
//2.9 17-11-2022 Add option to insert the tsl via DspToTsl. Ronald van Wijngaarden
//2.8 08.10.2021 HSB-13305: expose sequence number as a property Author: Marsel Nakuci
//2.7 22/07/2021 Add support to use with a list of genbeams Author: Robert Pol
/// </history>

//_ThisInst.setSequenceNumber(2000);

int nIntIndex;
String category = T("|General|");
int stringIndex = 0;
int bOnDebug = false;

String arSGenBeamProperties[] = {
	" --- ",					// 0
	T("|Name|"),			
	T("|Material|"),		
	T("|Grade|"),			
	T("|Information|"),	
	T("|Label|"),			// 5
	T("|Sublabel|"),		
	T("|Sublabel| 2"),	
	T("|Beamcode|"),		
	T("|Type|"),			
	T("|HsbId|"),			//10
	T("|Isotropic|"),
	T("|Zone|"),
	T("|Extrusion profile| ")
};

String arSGenBeamPropertiesSet[] = {
	" --- ",					// 0
	T("|Name|"),			
	T("|Material|"),		
	T("|Grade|"),			
	T("|Information|"),	
	T("|Label|"),			// 5
	T("|Sublabel|"),		
	T("|Sublabel| 2"),	
	T("|Beamcode|"),		
	T("|Type|"),			
	T("|HsbId|"),			//10
	T("|Isotropic|"),
	T("|Zone|")
};

String arIsotropic[] = 
{
	"ISOTROPIC",
	"NONISOTROPIC",
	"MULTIPLEXISOTROPIC"
};

//Gathering beam types and changing the string to a string w/o spaces or underscores.
String arBeamTypes[0];
for (int i = 0; i < _BeamTypes.length(); i++)
{
	String bType = _BeamTypes[i];
	String newBType = "";
	for (int j = 0; j < bType.length(); j++)
	{
		char c = bType.getAt(j);
		if (c == ' ' || c == '_')
		{
			continue;
		}
		else
		{ 
			newBType += c;
		}
		
	}
	newBType.makeUpper();
	arBeamTypes.append(newBType);
}

category = T("|Sequence Number|");
String sSequenceNumberName=T("|Sequence Number|");	
int nSequenceNumbers[]={1,2,3};
PropInt nSequenceNumber(nIntIndex++, 2000, sSequenceNumberName);	
nSequenceNumber.setDescription(T("|Defines the Sequence Number of the TSL. The sequence number is used to sort the list of Tsl's during execution of eg OnElementConstructed. It can be set to positive or negative value.|"));
nSequenceNumber.setCategory(category);

_ThisInst.setSequenceNumber(nSequenceNumber);
category = T("|Condition|");

PropString sCondition01(stringIndex++, arSGenBeamProperties, T("|Condition| 1"));
sCondition01.setCategory(category);
PropString sValueCondition01(stringIndex++, "", T("|Value condition| 1"));
sValueCondition01.setCategory(category);
sValueCondition01.setDescription(T("|Extrusion profile:|") + TN("0 = |No extrusion profile|") + TN("1 = |Extrusion profile|") + TN("") +
								TN("|You can use the name of the beamtype or you can use the index for the beamtype list. This list can be retrieved by using the following TSL 'HSB_I-ListBeamTypes'.|") + TN("") +
								TN("|Isotropic:|") +
								TN("|You can use the Isotropic name or use the following numbers.|") +
								TN("	|0 = 'Isotropic'|") +
								TN("	|1 = 'NonIsotropic'|")+
								TN("	|2 = 'MultiPlexIsotropic'| "));

PropString sCondition02(stringIndex++, arSGenBeamProperties, T("|Condition| 2"));
sCondition02.setCategory(category);
PropString sValueCondition02(stringIndex++, "", T("|Value condition| 2"));
sValueCondition02.setCategory(category);
sValueCondition02.setDescription(T("|Extrusion profile:|") + TN("0 = |No extrusion profile|") + TN("1 = |Extrusion profile|") + TN("") +
								TN("|You can use the name of the beamtype or you can use the index for the beamtype list. This list can be retrieved by using the following TSL 'HSB_I-ListBeamTypes'.|") + TN("") +
								TN("|Isotropic:|") +
								TN("|You can use the Isotropic name or use the following numbers.|") +
								TN("	|0 = 'Isotropic'|") +
								TN("	|1 = 'NonIsotropic'|")+
								TN("	|2 = 'MultiPlexIsotropic'| "));

PropString sCondition03(stringIndex++, arSGenBeamProperties, T("|Condition| 3"));
sCondition03.setCategory(category);
PropString sValueCondition03(stringIndex++, "", T("|Value condition| 3"));
sValueCondition03.setCategory(category);
sValueCondition03.setDescription(T("|Extrusion profile:|") + TN("0 = |No extrusion profile|") + TN("1 = |Extrusion profile|") + TN("") +
								TN("|You can use the name of the beamtype or you can use the index for the beamtype list. This list can be retrieved by using the following TSL 'HSB_I-ListBeamTypes'.|") + TN("") +
								TN("|Isotropic:|") +
								TN("|You can use the Isotropic name or use the following numbers.|") +
								TN("	|0 = 'Isotropic'|") +
								TN("	|1 = 'NonIsotropic'|")+
								TN("	|2 = 'MultiPlexIsotropic'| "));

PropString sCondition04(stringIndex++, arSGenBeamProperties, T("|Condition| 4"));
sCondition04.setCategory(category);
PropString sValueCondition04(stringIndex++, "", T("|Value condition| 4"));
sValueCondition04.setCategory(category);
sValueCondition04.setDescription(T("|Extrusion profile:|") + TN("0 = |No extrusion profile|") + TN("1 = |Extrusion profile|") + TN("") +
								TN("|You can use the name of the beamtype or you can use the index for the beamtype list. This list can be retrieved by using the following TSL 'HSB_I-ListBeamTypes'.|") + TN("") +
								TN("|Isotropic:|") +
								TN("|You can use the Isotropic name or use the following numbers.|") +
								TN("	|0 = 'Isotropic'|") +
								TN("	|1 = 'NonIsotropic'|")+
								TN("	|2 = 'MultiPlexIsotropic'| "));

PropString sCondition05(stringIndex++, arSGenBeamProperties, T("|Condition| 5"));
sCondition05.setCategory(category);
PropString sValueCondition05(stringIndex++, "", T("|Value condition| 5"));
sValueCondition05.setCategory(category);
sValueCondition05.setDescription(T("|Extrusion profile:|") + TN("0 = |No extrusion profile|") + TN("1 = |Extrusion profile|") + TN("") +
								TN("|You can use the name of the beamtype or you can use the index for the beamtype list. This list can be retrieved by using the following TSL 'HSB_I-ListBeamTypes'.|") + TN("") +
								TN("|Isotropic:|") +
								TN("|You can use the Isotropic name or use the following numbers.|") +
								TN("	|0 = 'Isotropic'|") +
								TN("	|1 = 'NonIsotropic'|")+
								TN("	|2 = 'MultiPlexIsotropic'| "));

PropString sCondition06(stringIndex++, arSGenBeamProperties, T("|Condition| 6"));
sCondition06.setCategory(category);
PropString sValueCondition06(stringIndex++, "", T("|Value condition| 6"));
sValueCondition06.setCategory(category);
sValueCondition06.setDescription(T("|Extrusion profile:|") + TN("0 = |No extrusion profile|") + TN("1 = |Extrusion profile|") + TN("") +
								TN("|You can use the name of the beamtype or you can use the index for the beamtype list. This list can be retrieved by using the following TSL 'HSB_I-ListBeamTypes'.|") + TN("") +
								TN("|Isotropic:|") +
								TN("|You can use the Isotropic name or use the following numbers.|") +
								TN("	|0 = 'Isotropic'|") +
								TN("	|1 = 'NonIsotropic'|")+
								TN("	|2 = 'MultiPlexIsotropic'| "));

arSGenBeamPropertiesSet.append(T("|Color|"));


category = T("|Set Properties|");

PropString sSetter01(stringIndex++, arSGenBeamPropertiesSet, T("|Set property| 1"));
sSetter01.setCategory(category);
PropString sValueSetter01(stringIndex++, "", T("|Value property| 1"));
sValueSetter01.setCategory(category);
sValueSetter01.setDescription(T("|Type:|")  +
								TN("|You can use the name of the beamtype or you can use the index for the beamtype list. This list can be retrieved by using the following TSL 'HSB_I-ListBeamTypes'.|") + TN("") +
								TN("|Isotropic:|") +
								TN("|You can use the Isotropic name or use the following numbers.|") +
								TN("	|0 = 'Isotropic'|") +
								TN("	|1 = 'NonIsotropic'|")+
								TN("	|2 = 'MultiPlexIsotropic'| "));

PropString sSetter02(stringIndex++, arSGenBeamPropertiesSet, T("|Set property| 2"));
sSetter02.setCategory(category);
PropString sValueSetter02(stringIndex++, "", T("|Value property| 2"));
sValueSetter02.setCategory(category);
sValueSetter02.setDescription(T("|Type:|")  +
								TN("|You can use the name of the beamtype or you can use the index for the beamtype list. This list can be retrieved by using the following TSL 'HSB_I-ListBeamTypes'.|") + TN("") +
								TN("|Isotropic:|") +
								TN("|You can use the Isotropic name or use the following numbers.|") +
								TN("	|0 = 'Isotropic'|") +
								TN("	|1 = 'NonIsotropic'|")+
								TN("	|2 = 'MultiPlexIsotropic'| "));

PropString sSetter03(stringIndex++, arSGenBeamPropertiesSet, T("|Set property| 3"));
sSetter03.setCategory(category);
PropString sValueSetter03(stringIndex++, "", T("|Value property| 3"));
sValueSetter03.setCategory(category);
sValueSetter03.setDescription(T("|Type:|")  +
								TN("|You can use the name of the beamtype or you can use the index for the beamtype list. This list can be retrieved by using the following TSL 'HSB_I-ListBeamTypes'.|") + TN("") +
								TN("|Isotropic:|") +
								TN("|You can use the Isotropic name or use the following numbers.|") +
								TN("	|0 = 'Isotropic'|") +
								TN("	|1 = 'NonIsotropic'|")+
								TN("	|2 = 'MultiPlexIsotropic'| "));

PropString sSetter04(stringIndex++, arSGenBeamPropertiesSet, T("|Set property| 4"));
sSetter04.setCategory(category);
PropString sValueSetter04(stringIndex++, "", T("|Value property| 4"));
sValueSetter04.setCategory(category);
sValueSetter04.setDescription(T("|Type:|")  +
								TN("|You can use the name of the beamtype or you can use the index for the beamtype list. This list can be retrieved by using the following TSL 'HSB_I-ListBeamTypes'.|") + TN("") +
								TN("|Isotropic:|") +
								TN("|You can use the Isotropic name or use the following numbers.|") +
								TN("	|0 = 'Isotropic'|") +
								TN("	|1 = 'NonIsotropic'|")+
								TN("	|2 = 'MultiPlexIsotropic'| "));

PropString sSetter05(stringIndex++, arSGenBeamPropertiesSet, T("|Set property| 5"));
sSetter05.setCategory(category);
PropString sValueSetter05(stringIndex++, "", T("|Value property| 5"));
sValueSetter05.setCategory(category);
sValueSetter05.setDescription(T("|Type:|")  +
								TN("|You can use the name of the beamtype or you can use the index for the beamtype list. This list can be retrieved by using the following TSL 'HSB_I-ListBeamTypes'.|") + TN("") +
								TN("|Isotropic:|") +
								TN("|You can use the Isotropic name or use the following numbers.|") +
								TN("	|0 = 'Isotropic'|") +
								TN("	|1 = 'NonIsotropic'|")+
								TN("	|2 = 'MultiPlexIsotropic'| "));

PropString sSetter06(stringIndex++, arSGenBeamPropertiesSet, T("|Set property| 6"));
sSetter06.setCategory(category);
PropString sValueSetter06(stringIndex++, "", T("|Value property| 6"));
sValueSetter06.setCategory(category);
sValueSetter06.setDescription(T("|Type:|")  +
								TN("|You can use the name of the beamtype or you can use the index for the beamtype list. This list can be retrieved by using the following TSL 'HSB_I-ListBeamTypes'.|") + TN("") +
								TN("|Isotropic:|") +
								TN("|You can use the Isotropic name or use the following numbers.|") +
								TN("	|0 = 'Isotropic'|") +
								TN("	|1 = 'NonIsotropic'|")+
								TN("	|2 = 'MultiPlexIsotropic'| "));

PropString sSetter07(stringIndex++, arSGenBeamPropertiesSet, T("|Set property| 7"));
sSetter07.setCategory(category);`
PropString sValueSetter07(stringIndex++, "", T("|Value property| 7"));
sValueSetter07.setCategory(category);
sValueSetter07.setDescription(T("|Type:|")  +
								TN("|You can use the name of the beamtype or you can use the index for the beamtype list. This list can be retrieved by using the following TSL 'HSB_I-ListBeamTypes'.|") + TN("") +
								TN("|Isotropic:|") +
								TN("|You can use the Isotropic name or use the following numbers.|") +
								TN("	|0 = 'Isotropic'|") +
								TN("	|1 = 'NonIsotropic'|")+
								TN("	|2 = 'MultiPlexIsotropic'| "));

PropString sSetter08(stringIndex++, arSGenBeamPropertiesSet, T("|Set property| 8"));
sSetter08.setCategory(category);
PropString sValueSetter08(stringIndex++, "", T("|Value property| 8"));
sValueSetter08.setCategory(category);
sValueSetter08.setDescription(T("|Type:|")  +
								TN("|You can use the name of the beamtype or you can use the index for the beamtype list. This list can be retrieved by using the following TSL 'HSB_I-ListBeamTypes'.|") + TN("") +
								TN("|Isotropic:|") +
								TN("|You can use the Isotropic name or use the following numbers.|") +
								TN("	|0 = 'Isotropic'|") +
								TN("	|1 = 'NonIsotropic'|")+
								TN("	|2 = 'MultiPlexIsotropic'| "));

PropString sSetter09(stringIndex++, arSGenBeamPropertiesSet, T("|Set property| 9"));
sSetter09.setCategory(category);
PropString sValueSetter09(stringIndex++, "", T("|Value property| 9"));
sValueSetter09.setCategory(category);
sValueSetter09.setDescription(T("|Type:|")  +
								TN("|You can use the name of the beamtype or you can use the index for the beamtype list. This list can be retrieved by using the following TSL 'HSB_I-ListBeamTypes'.|") + TN("") +
								TN("|Isotropic:|") +
								TN("|You can use the Isotropic name or use the following numbers.|") +
								TN("	|0 = 'Isotropic'|") +
								TN("	|1 = 'NonIsotropic'|")+
								TN("	|2 = 'MultiPlexIsotropic'| "));

PropString sSetter10(stringIndex++, arSGenBeamPropertiesSet, T("|Set property| 10"));
sSetter10.setCategory(category);
PropString sValueSetter10(stringIndex++, "", T("|Value property| 10"));
sValueSetter10.setCategory(category);
sValueSetter10.setDescription(T("|Type:|")  +
								TN("|You can use the name of the beamtype or you can use the index for the beamtype list. This list can be retrieved by using the following TSL 'HSB_I-ListBeamTypes'.|") + TN("") +
								TN("|Isotropic:|") +
								TN("|You can use the Isotropic name or use the following numbers.|") +
								TN("	|0 = 'Isotropic'|") +
								TN("	|1 = 'NonIsotropic'|")+
								TN("	|2 = 'MultiPlexIsotropic'| "));

PropString sSetter11(stringIndex++, arSGenBeamPropertiesSet, T("|Set property| 11"));
sSetter11.setCategory(category);
PropString sValueSetter11(stringIndex++, "", T("|Value property| 11"));
sValueSetter11.setCategory(category);
sValueSetter11.setDescription(T("|Type:|")  +
								TN("|You can use the name of the beamtype or you can use the index for the beamtype list. This list can be retrieved by using the following TSL 'HSB_I-ListBeamTypes'.|") + TN("") +
								TN("|Isotropic:|") +
								TN("|You can use the Isotropic name or use the following numbers.|") +
								TN("	|0 = 'Isotropic'|") +
								TN("	|1 = 'NonIsotropic'|")+
								TN("	|2 = 'MultiPlexIsotropic'| "));

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_G-PropertyMapping");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);


// Set properties from dsp
if( _Map.hasString("DspToTsl") ){
	String sCatalogName = _Map.getString("DspToTsl");
	setPropValuesFromCatalog(sCatalogName);
	
	_Map.removeAt("DspToTsl", true);
}



if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	int nNrOfTslsInserted = 0;
	PrEntity ssE(T("Select a set of elements"), Element());

	if( ssE.go() ){
		Element arSelectedElement[] = ssE.elementSet();
		
		String strScriptName = "HSB_G-PropertyMapping"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Element lstElements[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", true);
		mapTsl.setInt("ManualInsert", true);
		setCatalogFromPropValues("MasterToSatellite");
				
		for( int e=0;e<arSelectedElement.length();e++ ){
			Element el = arSelectedElement[e];
			lstElements[0] = el;
						
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			nNrOfTslsInserted++;
		}
	}
	
	reportMessage(nNrOfTslsInserted + T(" |tsl(s) inserted|"));
	
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

int nCondition01 = arSGenBeamProperties.find(sCondition01,0);
String arSValueCondition01[0];
String sList = sValueCondition01;
sList.trimLeft();
sList.trimRight();
sList += ";";
int nTokenIndex = 0; 
int nCharacterIndex = 0;
while(nCharacterIndex < sList.length()-1){
	String sListItem = sList.token(nTokenIndex,";");
	nTokenIndex++;
	if(sListItem.length()==0){
		nCharacterIndex++;
		continue;
	}
	nCharacterIndex = sList.find(sListItem,0);
	sListItem.trimLeft();
	sListItem.trimRight();
	if (nCondition01 == 11)
	{
		if (sListItem.length() < 3)
		{
			int iListItem = sListItem.atoi();
			arSValueCondition01.append(iListItem);
			continue;
		}
		else
		{
			int iListItem = arIsotropic.find(sListItem.makeUpper(), 0);
			arSValueCondition01.append(iListItem);
			continue;
		}
	}
	if (nCondition01 == 9)
	{
		if (sListItem.length() < 3)
		{
			int iListItem = sListItem.atoi();
			arSValueCondition01.append(iListItem);
			continue;
		}
		else
		{
			int iListItem = arBeamTypes.find(sListItem.makeUpper(), 0);
			arSValueCondition01.append(iListItem);
			continue;
		}
	}
	if (nCondition01 == 12)
	{
		int iListItem = sListItem.atoi();
		if ( iListItem > 5)
		{
			iListItem = 5 - iListItem;
		}
		arSValueCondition01.append(iListItem);
	}
	arSValueCondition01.append(sListItem);
}

int nCondition02 = arSGenBeamProperties.find(sCondition02,0);
String arSValueCondition02[0];
sList = sValueCondition02;
sList.trimLeft();
sList.trimRight();
sList += ";";
nTokenIndex = 0; 
nCharacterIndex = 0;
while(nCharacterIndex < sList.length()-1){
	String sListItem = sList.token(nTokenIndex,";");
	nTokenIndex++;
	if(sListItem.length()==0){
		nCharacterIndex++;
		continue;
	}
	nCharacterIndex = sList.find(sListItem,0);
	sListItem.trimLeft();
	sListItem.trimRight();
	if (nCondition02 == 11)
	{
		if (sListItem.length() < 3)
		{
			int iListItem = sListItem.atoi();
			arSValueCondition01.append(iListItem);
			continue;
		}
		else
		{
			int iListItem = arIsotropic.find(sListItem.makeUpper(), 0);
			arSValueCondition02.append(iListItem);
			continue;
		}
	}
	if (nCondition02 == 9)
	{
		if (sListItem.length() < 3)
		{
			int iListItem = sListItem.atoi();
			arSValueCondition02.append(iListItem);
			continue;
		}
		else
		{
			int iListItem = arBeamTypes.find(sListItem.makeUpper(), 0);
			arSValueCondition02.append(iListItem);
			continue;
		}
	}
	if (nCondition02 == 12)
	{
		int iListItem = sListItem.atoi();
		if ( iListItem > 5)
		{
			iListItem = 5 - iListItem;
		}
		arSValueCondition02.append(iListItem);
	}
	arSValueCondition02.append(sListItem);
}

int nCondition03 = arSGenBeamProperties.find(sCondition03,0);
String arSValueCondition03[0];
sList = sValueCondition03;
sList.trimLeft();
sList.trimRight();
sList += ";";
nTokenIndex = 0; 
nCharacterIndex = 0;
while(nCharacterIndex < sList.length()-1){
	String sListItem = sList.token(nTokenIndex,";");
	nTokenIndex++;
	if(sListItem.length()==0){
		nCharacterIndex++;
		continue;
	}
	nCharacterIndex = sList.find(sListItem,0);
	sListItem.trimLeft();
	sListItem.trimRight();
	if (nCondition03 == 11)
	{
		if (sListItem.length() < 3)
		{
			int iListItem = sListItem.atoi();
			arSValueCondition01.append(iListItem);
			continue;
		}
		else
		{
			int iListItem = arIsotropic.find(sListItem.makeUpper(), 0);
			arSValueCondition03.append(iListItem);
			continue;
		}
	}
	if (nCondition03 == 9)
	{
		if (sListItem.length() < 3)
		{
			int iListItem = sListItem.atoi();
			arSValueCondition03.append(iListItem);
			continue;
		}
		else
		{
			int iListItem = arBeamTypes.find(sListItem.makeUpper(), 0);
			arSValueCondition03.append(iListItem);
			continue;
		}
	}
	if (nCondition03 == 12)
	{
		int iListItem = sListItem.atoi();
		if ( iListItem > 5)
		{
			iListItem = 5 - iListItem;
		}
		arSValueCondition03.append(iListItem);
	}
	arSValueCondition03.append(sListItem);
}

int nCondition04 = arSGenBeamProperties.find(sCondition04,0);
String arSValueCondition04[0];
sList = sValueCondition04;
sList.trimLeft();
sList.trimRight();
sList += ";";
nTokenIndex = 0; 
nCharacterIndex = 0;
while(nCharacterIndex < sList.length()-1){
	String sListItem = sList.token(nTokenIndex,";");
	nTokenIndex++;
	if(sListItem.length()==0){
		nCharacterIndex++;
		continue;
	}
	nCharacterIndex = sList.find(sListItem,0);
	sListItem.trimLeft();
	sListItem.trimRight();
	if (nCondition04 == 11)
	{
		if (sListItem.length() < 3)
		{
			int iListItem = sListItem.atoi();
			arSValueCondition01.append(iListItem);
			continue;
		}
		else
		{
			int iListItem = arIsotropic.find(sListItem.makeUpper(), 0);
			arSValueCondition04.append(iListItem);
			continue;
		}
	}
	if (nCondition04 == 9)
	{
		if (sListItem.length() < 3)
		{
			int iListItem = sListItem.atoi();
			arSValueCondition04.append(iListItem);
			continue;
		}
		else
		{
			int iListItem = arBeamTypes.find(sListItem.makeUpper(), 0);
			arSValueCondition04.append(iListItem);
			continue;
		}
	}
	if (nCondition04 == 12)
	{
		int iListItem = sListItem.atoi();
		if ( iListItem > 5)
		{
			iListItem = 5 - iListItem;
		}
		arSValueCondition04.append(iListItem);
	}
	arSValueCondition04.append(sListItem);
}

int nCondition05 = arSGenBeamProperties.find(sCondition05,0);
String arSValueCondition05[0];
sList = sValueCondition05;
sList.trimLeft();
sList.trimRight();
sList += ";";
nTokenIndex = 0; 
nCharacterIndex = 0;
while(nCharacterIndex < sList.length()-1){
	String sListItem = sList.token(nTokenIndex,";");
	nTokenIndex++;
	if(sListItem.length()==0){
		nCharacterIndex++;
		continue;
	}
	nCharacterIndex = sList.find(sListItem,0);
	sListItem.trimLeft();
	sListItem.trimRight();
	if (nCondition05 == 11)
	{
		if (sListItem.length() < 3)
		{
			int iListItem = sListItem.atoi();
			arSValueCondition01.append(iListItem);
			continue;
		}
		else
		{
			int iListItem = arIsotropic.find(sListItem.makeUpper(), 0);
			arSValueCondition05.append(iListItem);
			continue;
		}
	}
	if (nCondition05 == 9)
	{
		if (sListItem.length() < 3)
		{
			int iListItem = sListItem.atoi();
			arSValueCondition05.append(iListItem);
			continue;
		}
		else
		{
			int iListItem = arBeamTypes.find(sListItem.makeUpper(), 0);
			arSValueCondition05.append(iListItem);
			continue;
		}
	}
	if (nCondition05 == 12)
	{
		int iListItem = sListItem.atoi();
		if ( iListItem > 5)
		{
			iListItem = 5 - iListItem;
		}
		arSValueCondition05.append(iListItem);
	}
	arSValueCondition05.append(sListItem);
}

int nCondition06 = arSGenBeamProperties.find(sCondition06,0);
String arSValueCondition06[0];
sList = sValueCondition06;
sList.trimLeft();
sList.trimRight();
sList += ";";
nTokenIndex = 0; 
nCharacterIndex = 0;
while(nCharacterIndex < sList.length()-1){
	String sListItem = sList.token(nTokenIndex,";");
	nTokenIndex++;
	if(sListItem.length()==0){
		nCharacterIndex++;
		continue;
	}
	nCharacterIndex = sList.find(sListItem,0);
	sListItem.trimLeft();
	sListItem.trimRight();
	if (nCondition06 == 11)
	{
		if (sListItem.length() < 3)
		{
			int iListItem = sListItem.atoi();
			arSValueCondition01.append(iListItem);
			continue;
		}
		else
		{
			int iListItem = arIsotropic.find(sListItem.makeUpper(), 0);
			arSValueCondition06.append(iListItem);
			continue;
		}
	}
	if (nCondition06 == 9)
	{
		if (sListItem.length() < 3)
		{
			int iListItem = sListItem.atoi();
			arSValueCondition06.append(iListItem);
			continue;
		}
		else
		{
			int iListItem = arBeamTypes.find(sListItem.makeUpper(), 0);
			arSValueCondition06.append(iListItem);
			continue;
		}
	}
	if (nCondition06 == 12)
	{
		int iListItem = sListItem.atoi();
		if ( iListItem > 5)
		{
			iListItem = 5 - iListItem;
		}
		arSValueCondition06.append(iListItem);
	}
	arSValueCondition06.append(sListItem);
}

if (_GenBeam.length() < 1 && _Element.length() < 1)
{
	reportMessage(TN("|No genbeams or element found|"));
	eraseInstance();
	return;	
}

// Create an array to store the beams
if(_Element.length() > 0)
{
	GenBeam elementGenBeams[] = _Element[0].genBeam();
	for (int index=0;index<elementGenBeams.length();index++) 
	{ 
		GenBeam genBeam = elementGenBeams[index]; 
		_GenBeam.append(genBeam);
	}
}

for( int i=0;i<_GenBeam.length();i++ )
{
	GenBeam gBm = _GenBeam[i]; 
	if (! gBm.bIsValid()) continue;
	
	Beam bm;
	if(gBm.bIsA(Beam()))
		bm = (Beam) gBm;
	// Check the conditions
	
	if(bOnDebug)
	{
		reportNotice(gBm.name());
		reportNotice(gBm.material());
		reportNotice(gBm.grade());
		reportNotice(gBm.information());
		reportNotice(gBm.label());
		reportNotice(gBm.subLabel());
		reportNotice(gBm.subLabel2());
		reportNotice(gBm.beamCode().token(0));
		reportNotice(gBm.type());
		reportNotice(gBm.hsbId());
		reportNotice(gBm.isotropic());
		reportNotice(gBm.myZoneIndex());
		
	}
	String sCond01;
	if( nCondition01 == 1 )
		sCond01 = gBm.name();
	if( nCondition01 == 2 )
		sCond01 = gBm.material();
	if( nCondition01 == 3 )
		sCond01 = gBm.grade();
	if( nCondition01 == 4 )
		sCond01 = gBm.information();
	if( nCondition01 == 5 )
		sCond01 = gBm.label();
	if( nCondition01 == 6 )
		sCond01 = gBm.subLabel();
	if( nCondition01 == 7 )
		sCond01 = gBm.subLabel2();
	if( nCondition01 == 8 )
		sCond01 = gBm.beamCode().token(0);
	if( nCondition01 == 9 )
		sCond01 = gBm.type();
	if( nCondition01 == 10 )
		sCond01 = gBm.hsbId();
	if (nCondition01 == 11)
		sCond01 = gBm.isotropic();
	if (nCondition01 == 12)
	{
		sCond01 = gBm.myZoneIndex();
	}
	int nCond01 = arSValueCondition01.find(sCond01);
	if(bm.bIsValid() && (bm.extrProfile() == "Rectangular" || bm.extrProfile() == "Round") && arSValueCondition01.find("0") == 0 && nCondition01 == 13)
		nCond01 = 1;
	else if(bm.bIsValid() && (bm.extrProfile() != "Rectangular" || bm.extrProfile() != "Round") && arSValueCondition01.find("1") == 0 && nCondition01 == 13)
		nCond01 = 1;
		
	int nCond02 = -1;
	if( nCond01 == -1 ){
		String sCond02;
		if( nCondition02 == 1 )
			sCond02 = gBm.name();
		if( nCondition02 == 2 )
			sCond02 = gBm.material();
		if( nCondition02 == 3 )
			sCond02 = gBm.grade();
		if( nCondition02 == 4 )
			sCond02 = gBm.information();
		if( nCondition02 == 5 )
			sCond02 = gBm.label();
		if( nCondition02 == 6 )
			sCond02 = gBm.subLabel();
		if( nCondition02 == 7 )
			sCond02 = gBm.subLabel2();
		if( nCondition02 == 8 )
			sCond02 = gBm.beamCode().token(0);
		if( nCondition02 == 9 )
			sCond02 = gBm.type();
		if( nCondition02 == 10 )
			sCond02 = gBm.hsbId();
		if (nCondition02 == 11)
			sCond02 = gBm.isotropic();
		if (nCondition02 == 12)
			sCond02 = gBm.myZoneIndex();		
			
		nCond02 = arSValueCondition02.find(sCond02);
		if(bm.bIsValid() && (bm.extrProfile() == "Rectangular" || bm.extrProfile() == "Round")  && arSValueCondition02.find("0") == 0 && nCondition02 == 13)
			nCond02 = 1;
		else if(bm.bIsValid() && (bm.extrProfile() != "Rectangular" || bm.extrProfile() != "Round") && arSValueCondition02.find("1") == 0 && nCondition02 == 13)
			nCond02 = 1;
	}
	
	int nCond03 = -1;
	if( nCond01 == -1 && nCond02 == -1){
		String sCond03;
		if( nCondition03 == 1 )
			sCond03 = gBm.name();
		if( nCondition03 == 2 )
			sCond03 = gBm.material();
		if( nCondition03 == 3 )
			sCond03 = gBm.grade();
		if( nCondition03 == 4 )
			sCond03 = gBm.information();
		if( nCondition03 == 5 )
			sCond03 = gBm.label();
		if( nCondition03 == 6 )
			sCond03 = gBm.subLabel();
		if( nCondition03 == 7 )
			sCond03 = gBm.subLabel2();
		if( nCondition03 == 8 )
			sCond03 = gBm.beamCode().token(0);
		if( nCondition03 == 9 )
			sCond03 = gBm.type();
		if( nCondition03 == 10 )
			sCond03 = gBm.hsbId();
		if (nCondition03 == 11)
			sCond03 = gBm.isotropic();
		if (nCondition03 == 12)
			sCond03 = gBm.myZoneIndex();				
			
		nCond03 = arSValueCondition03.find(sCond03);
		if(bm.bIsValid() && (bm.extrProfile() == "Rectangular" || bm.extrProfile() == "Round")  && arSValueCondition03.find("0") == 0 && nCondition03 == 13)
			nCond03 = 1;
		else if(bm.bIsValid() && (bm.extrProfile() != "Rectangular" || bm.extrProfile() != "Round") && arSValueCondition03.find("1") == 0 && nCondition03 == 13)
			nCond03 = 1;
	}
	
	int nCond04 = -1;
	if( nCond01 == -1 && nCond02 == -1 && nCond03 == -1){
		String sCond04;
		if( nCondition04 == 1 )
			sCond04 = gBm.name();
		if( nCondition04 == 2 )
			sCond04 = gBm.material();
		if( nCondition04 == 3 )
			sCond04 = gBm.grade();
		if( nCondition04 == 4 )
			sCond04 = gBm.information();
		if( nCondition04 == 5 )
			sCond04 = gBm.label();
		if( nCondition04 == 6 )
			sCond04 = gBm.subLabel();
		if( nCondition04 == 7 )
			sCond04 = gBm.subLabel2();
		if( nCondition04 == 8 )
			sCond04 = gBm.beamCode().token(0);
		if( nCondition04 == 9 )
			sCond04 = gBm.type();
		if( nCondition04 == 10 )
			sCond04 = gBm.hsbId();
		if (nCondition04 == 11)
			sCond04 = gBm.isotropic();
		if (nCondition04 == 12)
			sCond04 = gBm.myZoneIndex();				
			
		nCond04 = arSValueCondition04.find(sCond04);
		if(bm.bIsValid() && (bm.extrProfile() == "Rectangular" || bm.extrProfile() == "Round")  && arSValueCondition04.find("0") == 0 && nCondition04 == 13)
			nCond04 = 1;
		else if(bm.bIsValid() && (bm.extrProfile() != "Rectangular" || bm.extrProfile() != "Round") && arSValueCondition04.find("1") == 0 && nCondition04 == 13)
			nCond04 = 1;
	}
	
	int nCond05 = -1;
	if( nCond01 == -1 && nCond02 == -1 && nCond03 == -1 && nCond04 == -1){
		String sCond05;
		if( nCondition05 == 1 )
			sCond05 = gBm.name();
		if( nCondition05 == 2 )
			sCond05 = gBm.material();
		if( nCondition05 == 3 )
			sCond05 = gBm.grade();
		if( nCondition05 == 4 )
			sCond05 = gBm.information();
		if( nCondition05 == 5 )
			sCond05 = gBm.label();
		if( nCondition05 == 6 )
			sCond05 = gBm.subLabel();
		if( nCondition05 == 7 )
			sCond05 = gBm.subLabel2();
		if( nCondition05 == 8 )
			sCond05 = gBm.beamCode().token(0);
		if( nCondition05 == 9 )
			sCond05 = gBm.type();
		if( nCondition05 == 10 )
			sCond05 = gBm.hsbId();
		if (nCondition05 == 11)
			sCond05 = gBm.isotropic();	
		if (nCondition05 == 12)
			sCond05 = gBm.myZoneIndex();				
			
		nCond05 = arSValueCondition05.find(sCond05);
		if(bm.bIsValid() && (bm.extrProfile() == "Rectangular" || bm.extrProfile() == "Round")  && arSValueCondition05.find("0") == 0 && nCondition05 == 13)
			nCond05 = 1;
		else if(bm.bIsValid() && (bm.extrProfile() != "Rectangular" || bm.extrProfile() != "Round") && arSValueCondition05.find("1") == 0 && nCondition05 == 13)
			nCond05 = 1;
	}
	int nCond06 = -1;
	if( nCond01 == -1 && nCond02 == -1 && nCond03 == -1 && nCond04 == -1 && nCond05 == -1){
		String sCond06;
		if( nCondition06 == 1 )
			sCond06 = gBm.name();
		if( nCondition06 == 2 )
			sCond06 = gBm.material();
		if( nCondition06 == 3 )
			sCond06 = gBm.grade();
		if( nCondition06 == 4 )
			sCond06 = gBm.information();
		if( nCondition06 == 5 )
			sCond06 = gBm.label();
		if( nCondition06 == 6 )
			sCond06 = gBm.subLabel();
		if( nCondition06 == 7 )
			sCond06 = gBm.subLabel2();
		if( nCondition06 == 8 )
			sCond06 = gBm.beamCode().token(0);
		if( nCondition06 == 9 )
			sCond06 = gBm.type();
		if( nCondition06 == 10 )
			sCond06 = gBm.hsbId();
		if (nCondition06 == 11)
			sCond06 = gBm.isotropic();	
		if (nCondition06 == 12)
			sCond06 = gBm.myZoneIndex();				
			
		nCond06 = arSValueCondition06.find(sCond06);
		if(bm.bIsValid() && (bm.extrProfile() == "Rectangular" || bm.extrProfile() == "Round")  && arSValueCondition06.find("0") == 0 && nCondition06 == 13)
			nCond06 = 1;
		else if(bm.bIsValid() && (bm.extrProfile() != "Rectangular" || bm.extrProfile() != "Round") && arSValueCondition06.find("1") == 0 && nCondition06 == 13)
			nCond06 = 1;
	}
	
	if( nCond01 == -1 && nCond02 == -1 && nCond03 == -1 && nCond04 == -1  && nCond05 == -1 && nCond06 == -1)
		continue;

// Set the properties

	int nSetter01 = arSGenBeamPropertiesSet.find(sSetter01,0);
	if( nSetter01 == 1 )
		gBm.setName(sValueSetter01);
	if( nSetter01 == 2 )
		gBm.setMaterial(sValueSetter01);
	if( nSetter01 == 3 )
		gBm.setGrade(sValueSetter01);
	if( nSetter01 == 4 )
		gBm.setInformation(sValueSetter01);
	if( nSetter01 == 5 )
		gBm.setLabel(sValueSetter01);
	if( nSetter01 == 6 )
		gBm.setSubLabel(sValueSetter01);
	if( nSetter01 == 7 )
		gBm.setSubLabel2(sValueSetter01);
	if( nSetter01 == 8 )
		gBm.setBeamCode(sValueSetter01);
	if( nSetter01 == 9 )
	{
		int iValueSetter01;
		if (sValueSetter01.length() < 3)
		{
			iValueSetter01 = sValueSetter01.atoi();
		}
		else
		{
			iValueSetter01 = arBeamTypes.find(sValueSetter01.makeUpper());
		}
		gBm.setType(iValueSetter01);
	}
	if( nSetter01 == 10 )
		gBm.setHsbId(sValueSetter01);
	if( nSetter01 == 11 )
	{ 
		int iValueSetter01;
		if (sValueSetter01.length() < 3)
		{
			iValueSetter01 = sValueSetter01.atoi();
		}
		else
		{ 
			iValueSetter01 = arIsotropic.find(sValueSetter01.makeUpper());
		}
		gBm.setIsotropic(iValueSetter01);
	}
	if (nSetter01 == 12)
	{
		char cFirstChar = sValueSetter01.getAt(0);
		String firstCharToString = cFirstChar;
		int iValueSetter01;
		if(firstCharToString.atoi() != 0)
		{
			String entLayer = gBm.layerName();
			String tokenizedLayer = entLayer.token(1, "~");
			cFirstChar = tokenizedLayer.getAt(tokenizedLayer.length() - 2);
			iValueSetter01 = sValueSetter01.atoi();
		}else
		{
			String sTrimmedValue = sValueSetter01.delete(0, 1);
			iValueSetter01 = sTrimmedValue.atoi();
		}
		if ( iValueSetter01 > 5)
		{
			iValueSetter01 = 5 - iValueSetter01;
		}
		gBm.assignToElementGroup(gBm.element(), true, iValueSetter01, cFirstChar);
	}
	if( nSetter01 == 13 )
		gBm.setColor(sValueSetter01.atoi());
	
	int nSetter02 = arSGenBeamPropertiesSet.find(sSetter02,0);
	if( nSetter02 == 1 )
		gBm.setName(sValueSetter02);
	if( nSetter02 == 2 )
		gBm.setMaterial(sValueSetter02);
	if( nSetter02 == 3 )
		gBm.setGrade(sValueSetter02);
	if( nSetter02 == 4 )
		gBm.setInformation(sValueSetter02);
	if( nSetter02 == 5 )
		gBm.setLabel(sValueSetter02);
	if( nSetter02 == 6 )
		gBm.setSubLabel(sValueSetter02);
	if( nSetter02 == 7 )
		gBm.setSubLabel2(sValueSetter02);
	if( nSetter02 == 8 )
		gBm.setBeamCode(sValueSetter02);
	if( nSetter02 == 9 )
	{
		int iValueSetter02;
		if (sValueSetter02.length() < 3)
		{
			iValueSetter02 = sValueSetter02.atoi();
		}
		else
		{
			iValueSetter02 = arBeamTypes.find(sValueSetter02.makeUpper());
		}
		gBm.setType(iValueSetter02);
	}
	if( nSetter02 == 10 )
		gBm.setHsbId(sValueSetter02);
	if( nSetter02 == 11 )
	{ 
		int iValueSetter02;
		if (sValueSetter02.length() < 3)
		{
			iValueSetter02 = sValueSetter02.atoi();
		}
		else
		{ 
			iValueSetter02 = arIsotropic.find(sValueSetter02.makeUpper());
		}
		gBm.setIsotropic(iValueSetter02);
	}		
	if (nSetter02 == 12)
	{
		char cFirstChar = sValueSetter02.getAt(0);
		String firstCharToString = cFirstChar;
		int iValueSetter02;
		if(firstCharToString.atoi() != 0)
		{
			String entLayer = gBm.layerName();
			String tokenizedLayer = entLayer.token(1, "~");
			cFirstChar = tokenizedLayer.getAt(tokenizedLayer.length() - 2);
			iValueSetter02 = sValueSetter02.atoi();
		}else
		{
			String sTrimmedValue = sValueSetter02.delete(0, 1);
			iValueSetter02 = sTrimmedValue.atoi();
		}
		if ( iValueSetter02 > 5)
		{
			iValueSetter02 = 5 - iValueSetter02;
		}
		gBm.assignToElementGroup(gBm.element(), true, iValueSetter02, cFirstChar);
	}
	if( nSetter02 == 13 )
		gBm.setColor(sValueSetter02.atoi());

		
	int nSetter03 = arSGenBeamPropertiesSet.find(sSetter03,0);
	if( nSetter03 == 1 )
		gBm.setName(sValueSetter03);
	if( nSetter03 == 2 )
		gBm.setMaterial(sValueSetter03);
	if( nSetter03 == 3 )
		gBm.setGrade(sValueSetter03);
	if( nSetter03 == 4 )
		gBm.setInformation(sValueSetter03);
	if( nSetter03 == 5 )
		gBm.setLabel(sValueSetter03);
	if( nSetter03 == 6 )
		gBm.setSubLabel(sValueSetter03);
	if( nSetter03 == 7 )
		gBm.setSubLabel2(sValueSetter03);
	if( nSetter03 == 8 )
		gBm.setBeamCode(sValueSetter03);
	if( nSetter03 == 9 )
	{
		int iValueSetter03;
		if (sValueSetter03.length() < 3)
		{
			iValueSetter03 = sValueSetter03.atoi();
		}
		else
		{
			iValueSetter03 = arBeamTypes.find(sValueSetter03.makeUpper());
		}
		gBm.setType(iValueSetter03);
	}
	if( nSetter03 == 10 )
		gBm.setHsbId(sValueSetter03);
	if( nSetter03 == 11 )
	{ 
		int iValueSetter03;
		if (sValueSetter03.length() < 3)
		{
			iValueSetter03 = sValueSetter03.atoi();
		}
		else
		{ 
			iValueSetter03 = arIsotropic.find(sValueSetter03.makeUpper());
		}
		gBm.setIsotropic(iValueSetter03);
	}		
	if (nSetter03 == 12)
	{
		char cFirstChar = sValueSetter03.getAt(0);
		String firstCharToString = cFirstChar;
		int iValueSetter03;
		if(firstCharToString.atoi() != 0)
		{
			String entLayer = gBm.layerName();
			String tokenizedLayer = entLayer.token(1, "~");
			cFirstChar = tokenizedLayer.getAt(tokenizedLayer.length() - 2);
			iValueSetter03 = sValueSetter03.atoi();
		}else
		{
			String sTrimmedValue = sValueSetter03.delete(0, 1);
			iValueSetter03 = sTrimmedValue.atoi();
		}
		if ( iValueSetter03 > 5)
		{
			iValueSetter03 = 5 - iValueSetter03;
		}
		gBm.assignToElementGroup(gBm.element(), true, iValueSetter03, cFirstChar);
	}
	if( nSetter03 == 13 )
		gBm.setColor(sValueSetter03.atoi());
	
	
	int nSetter04 = arSGenBeamPropertiesSet.find(sSetter04,0);
	if( nSetter04 == 1 )
		gBm.setName(sValueSetter04);
	if( nSetter04 == 2 )
		gBm.setMaterial(sValueSetter04);
	if( nSetter04 == 3 )
		gBm.setGrade(sValueSetter04);
	if( nSetter04 == 4 )
		gBm.setInformation(sValueSetter04);
	if( nSetter04 == 5 )
		gBm.setLabel(sValueSetter04);
	if( nSetter04 == 6 )
		gBm.setSubLabel(sValueSetter04);
	if( nSetter04 == 7 )
		gBm.setSubLabel2(sValueSetter04);
	if( nSetter04 == 8 )
		gBm.setBeamCode(sValueSetter04);
	if( nSetter04 == 9 )
	{
		int iValueSetter04;
		if (sValueSetter04.length() < 3)
		{
			iValueSetter04 = sValueSetter04.atoi();
		}
		else
		{
			iValueSetter04 = arBeamTypes.find(sValueSetter04.makeUpper());
		}
		gBm.setType(iValueSetter04);
	}
	if( nSetter04 == 10 )
		gBm.setHsbId(sValueSetter04);
	if( nSetter04 == 11 )
	{ 
		int iValueSetter04;
		if (sValueSetter04.length() < 3)
		{
			iValueSetter04 = sValueSetter04.atoi();
		}
		else
		{ 
			iValueSetter04 = arIsotropic.find(sValueSetter04.makeUpper());
		}
		gBm.setIsotropic(iValueSetter04);
	}	
	if (nSetter04 == 12)
	{
		char cFirstChar = sValueSetter04.getAt(0);
		String firstCharToString = cFirstChar;
		int iValueSetter04;
		if(firstCharToString.atoi() != 0)
		{
			String entLayer = gBm.layerName();
			String tokenizedLayer = entLayer.token(1, "~");
			cFirstChar = tokenizedLayer.getAt(tokenizedLayer.length() - 2);
			iValueSetter04 = sValueSetter04.atoi();
		}else
		{
			String sTrimmedValue = sValueSetter04.delete(0, 1);
			iValueSetter04 = sTrimmedValue.atoi();
		}
		if ( iValueSetter04 > 5)
		{
			iValueSetter04 = 5 - iValueSetter04;
		}
		gBm.assignToElementGroup(gBm.element(), true, iValueSetter04, cFirstChar);
	}
	if( nSetter04 == 13 )
		gBm.setColor(sValueSetter04.atoi());
	
	int nSetter05 = arSGenBeamPropertiesSet.find(sSetter05,0);
	if( nSetter05 == 1 )
		gBm.setName(sValueSetter05);
	if( nSetter05 == 2 )
		gBm.setMaterial(sValueSetter05);
	if( nSetter05 == 3 )
		gBm.setGrade(sValueSetter05);
	if( nSetter05 == 4 )
		gBm.setInformation(sValueSetter05);
	if( nSetter05 == 5 )
		gBm.setLabel(sValueSetter05);
	if( nSetter05 == 6 )
		gBm.setSubLabel(sValueSetter05);
	if( nSetter05 == 7 )
		gBm.setSubLabel2(sValueSetter05);
	if( nSetter05 == 8 )
		gBm.setBeamCode(sValueSetter05);
	if( nSetter05 == 9 )
	{
		int iValueSetter05;
		if (sValueSetter05.length() < 3)
		{
			iValueSetter05 = sValueSetter05.atoi();
		}
		else
		{
			iValueSetter05 = arBeamTypes.find(sValueSetter05.makeUpper());
		}
		gBm.setType(iValueSetter05);
	}
	if( nSetter05 == 10 )
		gBm.setHsbId(sValueSetter05);
	if( nSetter05 == 11 )
	{ 
		int iValueSetter05;
		if (sValueSetter05.length() < 3)
		{
			iValueSetter05 = sValueSetter05.atoi();
		}
		else
		{ 
			iValueSetter05 = arIsotropic.find(sValueSetter05.makeUpper());
		}
		gBm.setIsotropic(iValueSetter05);
	}	
	if (nSetter05 == 12)
	{
		char cFirstChar = sValueSetter05.getAt(0);
		String firstCharToString = cFirstChar;
		int iValueSetter05;
		if(firstCharToString.atoi() != 0)
		{
			String entLayer = gBm.layerName();
			String tokenizedLayer = entLayer.token(1, "~");
			cFirstChar = tokenizedLayer.getAt(tokenizedLayer.length() - 2);
			iValueSetter05 = sValueSetter05.atoi();
		}else
		{
			String sTrimmedValue = sValueSetter05.delete(0, 1);
			iValueSetter05 = sTrimmedValue.atoi();
		}
		if ( iValueSetter05 > 5)
		{
			iValueSetter05 = 5 - iValueSetter05;
		}
		gBm.assignToElementGroup(gBm.element(), true, iValueSetter05, cFirstChar);
	}
	if( nSetter05 == 13 )
		gBm.setColor(sValueSetter05.atoi());
		
	int nSetter06 = arSGenBeamPropertiesSet.find(sSetter06,0);
	if( nSetter06 == 1 )
		gBm.setName(sValueSetter06);
	if( nSetter06 == 2 )
		gBm.setMaterial(sValueSetter06);
	if( nSetter06 == 3 )
		gBm.setGrade(sValueSetter06);
	if( nSetter06 == 4 )
		gBm.setInformation(sValueSetter06);
	if( nSetter06 == 5 )
		gBm.setLabel(sValueSetter06);
	if( nSetter06 == 6 )
		gBm.setSubLabel(sValueSetter06);
	if( nSetter06 == 7 )
		gBm.setSubLabel2(sValueSetter06);
	if( nSetter06 == 8 )
		gBm.setBeamCode(sValueSetter06);
	if( nSetter06 == 9 )
	{
		int iValueSetter06;
		if (sValueSetter06.length() < 3)
		{
			iValueSetter06 = sValueSetter06.atoi();
		}
		else
		{
			iValueSetter06 = arBeamTypes.find(sValueSetter06.makeUpper());
		}
		gBm.setType(iValueSetter06);
	}
	if( nSetter06 == 10 )
		gBm.setHsbId(sValueSetter06);
	if( nSetter06 == 11 )
	{ 
		int iValueSetter06;
		if (sValueSetter06.length() < 3)
		{
			iValueSetter06 = sValueSetter06.atoi();
		}
		else
		{ 
			iValueSetter06 = arIsotropic.find(sValueSetter06.makeUpper());
		}
		gBm.setIsotropic(iValueSetter06);
	}	
	if (nSetter06 == 12)
	{
		char cFirstChar = sValueSetter06.getAt(0);
		String firstCharToString = cFirstChar;
		int iValueSetter06;
		if(firstCharToString.atoi() != 0)
		{
			String entLayer = gBm.layerName();
			String tokenizedLayer = entLayer.token(1, "~");
			cFirstChar = tokenizedLayer.getAt(tokenizedLayer.length() - 2);
			iValueSetter06 = sValueSetter06.atoi();
		}else
		{
			String sTrimmedValue = sValueSetter06.delete(0, 1);
			iValueSetter06 = sTrimmedValue.atoi();
		}
		if ( iValueSetter06 > 5)
		{
			iValueSetter06 = 5 - iValueSetter06;
		}
		gBm.assignToElementGroup(gBm.element(), true, iValueSetter06, cFirstChar);
	}
	if( nSetter06 == 13 )
		gBm.setColor(sValueSetter06.atoi());

	int nSetter07 = arSGenBeamPropertiesSet.find(sSetter07,0);
	if( nSetter07 == 1 )
		gBm.setName(sValueSetter07);
	if( nSetter07 == 2 )
		gBm.setMaterial(sValueSetter07);
	if( nSetter07 == 3 )
		gBm.setGrade(sValueSetter07);
	if( nSetter07 == 4 )
		gBm.setInformation(sValueSetter07);
	if( nSetter07 == 5 )
		gBm.setLabel(sValueSetter07);
	if( nSetter07 == 6 )
		gBm.setSubLabel(sValueSetter07);
	if( nSetter07 == 7 )
		gBm.setSubLabel2(sValueSetter07);
	if( nSetter07 == 8 )
		gBm.setBeamCode(sValueSetter07);
	if( nSetter07 == 9 )
	{
		int iValueSetter07;
		if (sValueSetter07.length() < 3)
		{
			iValueSetter07 = sValueSetter07.atoi();
		}
		else
		{
			iValueSetter07 = arBeamTypes.find(sValueSetter07.makeUpper());
		}
		gBm.setType(iValueSetter07);
	}
	if( nSetter07 == 10 )
		gBm.setHsbId(sValueSetter07);
	if( nSetter07 == 11 )
	{ 
		int iValueSetter07;
		if (sValueSetter07.length() < 3)
		{
			iValueSetter07 = sValueSetter07.atoi();
		}
		else
		{ 
			iValueSetter07 = arIsotropic.find(sValueSetter07.makeUpper());
		}
		gBm.setIsotropic(iValueSetter07);
	}		
	if (nSetter07 == 12)
	{
		char cFirstChar = sValueSetter07.getAt(0);
		String firstCharToString = cFirstChar;
		int iValueSetter07;
		if(firstCharToString.atoi() != 0)
		{
			String entLayer = gBm.layerName();
			String tokenizedLayer = entLayer.token(1, "~");
			cFirstChar = tokenizedLayer.getAt(tokenizedLayer.length() - 2);
			iValueSetter07 = sValueSetter07.atoi();
		}else
		{
			String sTrimmedValue = sValueSetter01.delete(0, 1);
			iValueSetter07 = sTrimmedValue.atoi();
		}
		if ( iValueSetter07 > 5)
		{
			iValueSetter07 = 5 - iValueSetter07;
		}
		gBm.assignToElementGroup(gBm.element(), true, iValueSetter07, cFirstChar);
	}
	if( nSetter07 == 13 )
		gBm.setColor(sValueSetter07.atoi());

	int nSetter08 = arSGenBeamPropertiesSet.find(sSetter08,0);
	if( nSetter08 == 1 )
		gBm.setName(sValueSetter08);
	if( nSetter08 == 2 )
		gBm.setMaterial(sValueSetter08);
	if( nSetter08 == 3 )
		gBm.setGrade(sValueSetter08);
	if( nSetter08 == 4 )
		gBm.setInformation(sValueSetter08);
	if( nSetter08 == 5 )
		gBm.setLabel(sValueSetter08);
	if( nSetter08 == 6 )
		gBm.setSubLabel(sValueSetter08);
	if( nSetter08 == 7 )
		gBm.setSubLabel2(sValueSetter08);
	if( nSetter08 == 8 )
		gBm.setBeamCode(sValueSetter08);
	if( nSetter08 == 9 )
	{
		int iValueSetter08;
		if (sValueSetter08.length() < 3)
		{
			iValueSetter08 = sValueSetter08.atoi();
		}
		else
		{
			iValueSetter08 = arBeamTypes.find(sValueSetter08.makeUpper());
		}
		gBm.setType(iValueSetter08);
	}
	if( nSetter08 == 10 )
		gBm.setHsbId(sValueSetter08);
	if( nSetter08 == 11 )
	{ 
		int iValueSetter08;
		if (sValueSetter08.length() < 3)
		{
			iValueSetter08 = sValueSetter08.atoi();
		}
		else
		{ 
			iValueSetter08 = arIsotropic.find(sValueSetter08.makeUpper());
		}
		gBm.setIsotropic(iValueSetter08);
	}		
	if (nSetter08 == 12)
	{
		char cFirstChar = sValueSetter08.getAt(0);
		String firstCharToString = cFirstChar;
		int iValueSetter08;
		if(firstCharToString.atoi() != 0)
		{
			String entLayer = gBm.layerName();
			String tokenizedLayer = entLayer.token(1, "~");
			cFirstChar = tokenizedLayer.getAt(tokenizedLayer.length() - 2);
			iValueSetter08 = sValueSetter08.atoi();
		}else
		{
			String sTrimmedValue = sValueSetter08.delete(0, 1);
			iValueSetter08 = sTrimmedValue.atoi();
		}
		if ( iValueSetter08 > 5)
		{
			iValueSetter08 = 5 - iValueSetter08;
		}
		gBm.assignToElementGroup(gBm.element(), true, iValueSetter08, cFirstChar);
	}
	if( nSetter08 == 13 )
		gBm.setColor(sValueSetter08.atoi());

	int nSetter09 = arSGenBeamPropertiesSet.find(sSetter09,0);
	if( nSetter09 == 1 )
		gBm.setName(sValueSetter09);
	if( nSetter09 == 2 )
		gBm.setMaterial(sValueSetter09);
	if( nSetter09 == 3 )
		gBm.setGrade(sValueSetter09);
	if( nSetter09 == 4 )
		gBm.setInformation(sValueSetter09);
	if( nSetter09 == 5 )
		gBm.setLabel(sValueSetter09);
	if( nSetter09 == 6 )
		gBm.setSubLabel(sValueSetter09);
	if( nSetter09 == 7 )
		gBm.setSubLabel2(sValueSetter09);
	if( nSetter09 == 8 )
		gBm.setBeamCode(sValueSetter09);
	if( nSetter09 == 9 )
	{
		int iValueSetter09;
		if (sValueSetter09.length() < 3)
		{
			iValueSetter09 = sValueSetter09.atoi();
		}
		else
		{
			iValueSetter09 = arBeamTypes.find(sValueSetter09.makeUpper());
		}
		gBm.setType(iValueSetter09);
	}
	if( nSetter09 == 10 )
		gBm.setHsbId(sValueSetter09);
	if( nSetter09 == 11 )
	{ 
		int iValueSetter09;
		if (sValueSetter09.length() < 3)
		{
			iValueSetter09 = sValueSetter09.atoi();
		}
		else
		{ 
			iValueSetter09 = arIsotropic.find(sValueSetter09.makeUpper());
		}
		gBm.setIsotropic(iValueSetter09);
	}		
	if (nSetter09 == 12)
	{
		char cFirstChar = sValueSetter09.getAt(0);
		String firstCharToString = cFirstChar;
		int iValueSetter09;
		if(firstCharToString.atoi() != 0)
		{
			String entLayer = gBm.layerName();
			String tokenizedLayer = entLayer.token(1, "~");
			cFirstChar = tokenizedLayer.getAt(tokenizedLayer.length() - 2);
			iValueSetter09 = sValueSetter09.atoi();
		}else
		{
			String sTrimmedValue = sValueSetter09.delete(0, 1);
			iValueSetter09 = sTrimmedValue.atoi();
		}
		if ( iValueSetter09 > 5)
		{
			iValueSetter09 = 5 - iValueSetter09;
		}
		gBm.assignToElementGroup(gBm.element(), true, iValueSetter09, cFirstChar);
	}
	if( nSetter09 == 13 )
		gBm.setColor(sValueSetter09.atoi());
	
	int nSetter10 = arSGenBeamPropertiesSet.find(sSetter10,0);
	if( nSetter10 == 1 )
		gBm.setName(sValueSetter10);
	if( nSetter10 == 2 )
		gBm.setMaterial(sValueSetter10);
	if( nSetter10 == 3 )
		gBm.setGrade(sValueSetter10);
	if( nSetter10 == 4 )
		gBm.setInformation(sValueSetter10);
	if( nSetter10 == 5 )
		gBm.setLabel(sValueSetter10);
	if( nSetter10 == 6 )
		gBm.setSubLabel(sValueSetter10);
	if( nSetter10 == 7 )
		gBm.setSubLabel2(sValueSetter10);
	if( nSetter10 == 8 )
		gBm.setBeamCode(sValueSetter10);
	if( nSetter10 == 9 )
	{
		int iValueSetter10;
		if (sValueSetter10.length() < 3)
		{
			iValueSetter10 = sValueSetter10.atoi();
		}
		else
		{
			iValueSetter10 = arBeamTypes.find(sValueSetter10.makeUpper());
		}
		gBm.setType(iValueSetter10);
	}
	if( nSetter10 == 10 )
		gBm.setHsbId(sValueSetter10);
	if( nSetter10 == 11 )
	{ 
		int iValueSetter10;
		if (sValueSetter10.length() < 3)
		{
			iValueSetter10 = sValueSetter10.atoi();
		}
		else
		{ 
			iValueSetter10 = arIsotropic.find(sValueSetter10.makeUpper());
		}
		gBm.setIsotropic(iValueSetter10);
	}	
	if (nSetter10 == 12)
	{
		char cFirstChar = sValueSetter10.getAt(0);
		String firstCharToString = cFirstChar;
		int iValueSetter10;
		if(firstCharToString.atoi() != 0)
		{
			String entLayer = gBm.layerName();
			String tokenizedLayer = entLayer.token(1, "~");
			cFirstChar = tokenizedLayer.getAt(tokenizedLayer.length() - 2);
			iValueSetter10 = sValueSetter10.atoi();
		}else
		{
			String sTrimmedValue = sValueSetter10.delete(0, 1);
			iValueSetter10 = sTrimmedValue.atoi();
		}
		if ( iValueSetter10 > 5)
		{
			iValueSetter10 = 5 - iValueSetter10;
		}
		gBm.assignToElementGroup(gBm.element(), true, iValueSetter10, cFirstChar);
	}
	if( nSetter10 == 13 )
		gBm.setColor(sValueSetter10.atoi());

	int nSetter11 = arSGenBeamPropertiesSet.find(sSetter11,0);
	if( nSetter11 == 1 )
		gBm.setName(sValueSetter11);
	if( nSetter11 == 2 )
		gBm.setMaterial(sValueSetter11);
	if( nSetter11 == 3 )
		gBm.setGrade(sValueSetter11);
	if( nSetter11 == 4 )
		gBm.setInformation(sValueSetter11);
	if( nSetter11 == 5 )
		gBm.setLabel(sValueSetter11);
	if( nSetter11 == 6 )
		gBm.setSubLabel(sValueSetter11);
	if( nSetter11 == 7 )
		gBm.setSubLabel2(sValueSetter11);
	if( nSetter11 == 8 )
		gBm.setBeamCode(sValueSetter11);
	if( nSetter11 == 9 )
	{
		int iValueSetter11;
		if (sValueSetter11.length() < 3)
		{
			iValueSetter11 = sValueSetter11.atoi();
		}
		else
		{
			iValueSetter11 = arBeamTypes.find(sValueSetter11.makeUpper());
		}
		gBm.setType(iValueSetter11);
	}
	if( nSetter11 == 10 )
		gBm.setHsbId(sValueSetter11);
	if( nSetter11 == 11 )
	{ 
		int iValueSetter11;
		if (sValueSetter11.length() < 3)
		{
			iValueSetter11 = sValueSetter11.atoi();
		}
		else
		{ 
			iValueSetter11 = arIsotropic.find(sValueSetter11.makeUpper());
		}
		gBm.setIsotropic(iValueSetter11);
	}
	if (nSetter11 == 12)
	{
		char cFirstChar = sValueSetter11.getAt(0);
		String firstCharToString = cFirstChar;
		int iValueSetter11;
		if(firstCharToString.atoi() != 0)
		{
			String entLayer = gBm.layerName();
			String tokenizedLayer = entLayer.token(1, "~");
			cFirstChar = tokenizedLayer.getAt(tokenizedLayer.length() - 2);
			iValueSetter11 = sValueSetter11.atoi();
		}else
		{
			String sTrimmedValue = sValueSetter11.delete(0, 1);
			iValueSetter11 = sTrimmedValue.atoi();
		}
		if ( iValueSetter11 > 5)
		{
			iValueSetter11 = 5 - iValueSetter11;
		}
		gBm.assignToElementGroup(gBm.element(), true, iValueSetter11, cFirstChar);
	}
	if( nSetter11 == 13 )
		gBm.setColor(sValueSetter11.atoi());
}

if( bManualInsert || _bOnElementConstructed ){
	eraseInstance();
	return;
}



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
      <str nm="Comment" vl="Add option to insert the tsl via DspToTsl." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="11/17/2022 2:36:41 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13305: expose sequence number as a property" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="10/8/2021 10:54:44 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add support to use with a list of genbeams" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="7/22/2021 1:31:40 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End