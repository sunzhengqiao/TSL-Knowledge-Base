#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
02.10.2017  -  version 1.02
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

/// <version  value="1.02" date="02.10.2017"></version>

/// <history>
/// AS - 1.00 - 01.11.2016 -	Pilot version
/// AS - 1.01 - 01.11.2016 -	Correct material index
/// AS - 1.02 - 02.10.2017 -	Use different name for posnum mapx because it will not be resolved in the exporter
/// </history>

String recalcTriggers[] = {
	T("|Assign posnum prefixes|"),
	T("|Clear data|")
};
for (int r=0;r<recalcTriggers.length();r++)
	addRecalcTrigger(_kContext, recalcTriggers[r]);


if (_bOnInsert) 
{
	if (insertCycleCount()> 1) 
	{
		eraseInstance();
		return;
	}
	
	_Pt0 = getPoint(T("|Select a position|"));
	
	_Map.setInt("Insert", true);
	return;
}

int clear = false;

int execute = false;
if (_Map.hasInt("Insert")) {
	if (_Map.getInt("Insert"))
		execute = true;
	
	_Map.removeAt("Insert", false);
}
if (_kExecuteKey == recalcTriggers[0])
	execute = true;

String doubleClick= "TslDoubleClick";
if (_bOnRecalc && _kExecuteKey==doubleClick)
	execute = true;

if (_bOnDebug)
	execute = true;

if (_kExecuteKey == recalcTriggers[1])
{
	execute = true;
	clear = true;
}

if (execute) 
{
	String fileName = _kPathHsbCompany + "\\Custom\\Posnum.xml";
	Map mapPosnum;
	String materials[0];
	String materialPrefixes[0];
	String beamCodes[0];
	String beamCodePrefixes[0];
	
	if (!clear) 
	{
		mapPosnum.readFromXmlFile(fileName);
		for( int i=0;i<mapPosnum.length();i++ )
		{
			if( !mapPosnum.hasMap(i) )
				continue;
			Map mapPrefix = mapPosnum.getMap(i);
			String posnumPrefix = mapPrefix.getMapKey();
			for( int j=0;j<mapPrefix.length();j++ )
			{
				if( mapPrefix.keyAt(j) == "BeamCode" )
				{
					beamCodes.append(mapPrefix.getString(j));
					beamCodePrefixes.append(posnumPrefix);
				}
				if( mapPrefix.keyAt(j) == "Material" )
				{
					materials.append(mapPrefix.getString(j));
					materialPrefixes.append(posnumPrefix);
				}
			}
		}
	}
	
	Entity genBeamEntities[] = Group().collectEntities(true, GenBeam(), _kModelSpace);
	int numberOfPrefixedGenBeams = 0;
	for (int g=0;g<genBeamEntities.length();g++) 
	{
		GenBeam genBeam = (GenBeam)genBeamEntities[g];
		if (!genBeam.bIsValid())
			continue;
		
		if (clear) 
		{
			genBeam.removeSubMapX("PositionNumber");
			continue;
		}
		
		String prefix;
		
		String beamCode = genBeam.beamCode().token(0);
		String beamCodePrefix;
		int beamCodePrefixIndex = beamCodes.find(beamCode);
		if (beamCodePrefixIndex > -1) 
		{
			beamCodePrefix = beamCodePrefixes[beamCodePrefixIndex];
			prefix = beamCodePrefix;
		}
		
		String material = genBeam.material();
		String materialPrefix;
		int materialPrefixIndex = materials.find(material);
		if (materialPrefixIndex > -1)
		{
			materialPrefix = materialPrefixes[materialPrefixIndex];
			prefix = materialPrefix;
		}
		
		if (beamCodePrefixIndex == -1 && materialPrefixIndex == -1)
			continue;
		
//		reportNotice("\n" + TN("|Beam code|: ") + beamCode + T(" - |Prefix|: ")+ beamCodePrefix);
//		reportNotice(TN("|Material|: ") + material + T(" - |Prefix|: ")+ materialPrefix);
//		reportNotice(TN("|Prefix|: ") + prefix);
//		
//		if (beamCodePrefixIndex > -1 && materialPrefixIndex > -1 && beamCodePrefix != materialPrefix) 
//			reportNotice(scriptName() + TN("|Material and beamcode prefix are not the same for| ") + material + T(" |and| ") + beamCode + TN("|Material prefix is used|!"));			
		
		Map posnumPrefix;
		posnumPrefix.setString("Prefix", prefix);
		genBeam.setSubMapX("PositionNumber", posnumPrefix);
		
		numberOfPrefixedGenBeams++;
	}
	
	_Map.setInt("NumberOfEntities", numberOfPrefixedGenBeams);
	_Map.setString("Executed", String().formatTime("%d-%m-%Y, %H:%M"));
}

String dateTimeLastExecute = _Map.getString("Executed");
Display dp(-1);
dp.textHeight(U(100));

dp.draw(_Map.getInt("NumberOfEntities") + T(" |entities are last posnum-prefixed at|: ") + dateTimeLastExecute, _Pt0, _XW, _YW, 1, 1);
#End
#BeginThumbnail


#End