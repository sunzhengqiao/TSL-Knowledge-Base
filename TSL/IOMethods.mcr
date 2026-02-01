#Version 8
#BeginDescription

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 0
#FileState 0
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
if (_bOnMapIO)
{
	if ( _kExecuteKey == "GETBEAMPROPERTIES" )
	{
		int nBeamType=-1;
		Entity ent;
		if (_Map.hasInt("nType"))
		{
			nBeamType=_Map.getInt("nType");
		}
		else
		{
			reportNotice("\n_Map does not contain type key");
			_Map=Map();
			_Map.setString("ERROR", "Map does not contain type key");
			return;
		}
		
		if (_Map.hasEntity("Element"))
		{
			ent=_Map.getEntity("Entity");
		}
		else
		{
			reportNotice("\n_Map does not contain entity");
			_Map=Map();
			_Map.setString("ERROR", "Map does not contain entity");
			return;
		}
		
		if (!ent.bIsValid())
		{
			reportNotice("\nEntity is not valid");
			_Map=Map();
			_Map.setString("ERROR", "Entity is not valid");
			return;
		}
		
		//Reset the map and prepare it for output
		_Map=Map();
		
		String sAllMaps=ent.subMapXKeys();
		
		if (sAllMaps.find("BEAMPROPERTIES", -1) == -1)
		{
			reportNotice("\nEntity does not contain mapX");
			_Map.setString("ERROR", "Entity does not contain mapX");

			return;
		}
		
		Map mpTypes=ent.subMapX("BEAMPROPERTIES");
		
		int nTypes[0];
		String sNames[0];
		String sMaterial;
		String sGrade;
		for (int i=0; i<mpTypes.length(); i++)
		{
			if (mpTypes.keyAt(i)=="BEAMTYPE")
			{
				Map mpType=mpTypes.getMap(i);
				nTypes.append(mpType.getInt("Type"));
				sNames.append(mpType.getString("Name"));
			}
			if (mpTypes.keyAt(i)=="BEAMMATERIAL")
			{
				sMaterial=mpTypes.getString("BEAMMATERIAL");
			}
			if (mpTypes.keyAt(i)=="BEAMGRADE")
			{
				sGrade=mpTypes.getString("BEAMGRADE");
			}
		}
		

		int nLocation=nTypes.find(nBeamType, -1);
		String sOutputName;
		if (nLocation != -1)
		{
			sOutputName=sNames[nLocation];
		}
		else
		{
			reportNotice("\nBeam type not found.");
			_Map.setString("ERROR", "Beam type not found");
			return;
		}
		
		_Map.setString("NAME", sOutputName);
		_Map.setString("MATERIAL", sMaterial);
		_Map.setString("GRADE", sGrade);
		
		return;
	}
}


#End
#BeginThumbnail

#End
