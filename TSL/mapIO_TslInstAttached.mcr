#Version 8
#BeginDescription


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Dieses TSL wird ausschließlich als Funktion von anderen TSL's verwendet und kann vom Anwender nicht aufgerufen werden.
/// Um die Funktion für andere TSL's zu gewährleisten muss dieses TSL im Verzeichnis <hsbCompany>\TSL gespeichert sein.
/// </summary>

/// <summary Lang=en>
/// This TSL is exclusively used as a function of  other tsl's. It can not be inserted and used by the user.
/// To ensure the functionality one must save this tsl in the path <hsbCompany>\TSL.
/// </summary>

/// <insert Lang=en>
/// Not supported
/// </insert>

/// <remark Lang=en>

/// </remark>
/// Requires hsbCAD 14.0.79 or higher
/// <remark Lang=en>

/// This tsl can be called by another TSL using the function static int callMapIO(String strScriptName, Map& mapIO);
/// The following map entries are available for the call of this mapIO TSL
/// <Entity> thisEntity					The entity which will be scanned for its attached tsl's
/// <String> scriptName	(optional)		If you search for a specific tsl to be attached
/// <int> reportDebug (optional)		If set to true debug messages will be shown
///
/// Sample
/// 		// query the tsl's which are attached to a pline (_Entity[0])
/// 		Map mapIO;
/// 		mapIO.setEntity("thisEntity",_Entity[0]);
/// 		mapIO.setString("scriptName",scriptName());
/// 		mapIO.setInt("reportDebug", false);
/// 		TslInst().callMapIO("mapIO_tslInstAttached", mapIO);
/// 		TslInst tslAttached[0];
/// 		for(int i=0;i<mapIO.length();i++)
/// 		{
/// 			if (mapIO.hasEntity(i) && mapIO.keyAt(i) == "tslAttached")
/// 			{
/// 				Entity e = mapIO.getEntity(i);
/// 				tslAttached.append((TslInst)e);
/// 			}
/// 		}	
/// </remark>


// on mapIO
	if (_bOnMapIO) {
		int bReportDebug = _Map.getInt("reportDebug");
		Entity entThis = _Map.getEntity("thisEntity");
		Group grThis[] = entThis.groups();
		if (grThis.length()<1)
			reportNotice(TN("|Warning for|") +" " + entThis.typeDxfName() +" "  + TN("|The entity needs to be assigned to at least one group|"));
		String filterScriptName = _Map.getString("scriptName");
		
		Group allGroups[] = Group().subGroups(TRUE); 
		Entity allEnts[0];
		for (int g=0; g <allGroups .length();g++)
			allEnts.append(allGroups[g].collectEntities(true,TslInst(),_kMySpace));
		for (int e=0; e< allEnts.length();e++)
		{
			TslInst tsl = (TslInst)allEnts[e];
			int bFilterOK =true;
			if (filterScriptName!="" && filterScriptName.makeUpper() != tsl.scriptName().makeUpper())
				bFilterOK =false;
			
			Entity entities[] = tsl.entity();	
			if (entities.find(entThis)>-1 &&bFilterOK)
			{
				_Map.appendEntity("tslAttached", tsl);
			}
			if (bReportDebug)
				reportNotice("\nentities " + entities.length());
		}	
	}
// no other use than on mapIO	
	else
	{
		eraseInstance();
		return;	
	}	

#End
#BeginThumbnail
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
!V3,/
`

#End
