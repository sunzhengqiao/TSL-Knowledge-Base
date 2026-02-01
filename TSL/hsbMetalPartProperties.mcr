#Version 8
#BeginDescription

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Diese TSL prüft ob die Eigenschaftssatz-Definitionen der gewählten Massengruppe auf das Feld ‚PosNum' 
/// und schreibt den Wert aus der hsbNummerierung in dieses Eigenschaftsfeld.
/// Ist der Eigenschaftssatz nicht dem Objekt zugewiesen, so wird dieser ergänzt, wenn er das entsprechende Feld enthält.
/// </summary>

/// <insert=de>
/// Wählen Sie alle Bauteile aus. Sollte die Eigenschaftssatzdefinition ungültig sein, bzw die gewählte Eigenschaft
/// nicht in diesem vorhanden sein wird ein Dialog angezeigt und nach erfolgreicher Änderung kann der Befehl erneut ausgeführt werden.
/// </insert>

/// <remark>
/// Benötigt die Materialtabelle <hsbCompany>\\Abbund\\hsbGenBeamDensityConfig.xml" und eine Eigenschaftssatzdefinition mit einer
/// Eigenschaft für die Dichte. Diese Eigenschaft muss der Eingabe einer reelen Zahl entsprechen.
/// </remark>

/// History
/// Version 1.2



// basics and props
	U(1,"mm");
	double dEps = U(0.1);
	String sArPropertyNames[]={"POSNUM"};
			
// on insert
	if (_bOnInsert) {
		
		_Entity.append(getEntity());
		_Map.setInt("erase",true);
		return;
	}
//end on insert________________________________________________________________________________

		
// validate the entity
	MassGroup mg;
	TslInst tsl;
	Entity entThis;
	if (_Entity.length()>0 && _Entity[0].bIsKindOf(MassGroup()))
	{ 
			mg = (MassGroup)_Entity[0]; // would be valid if added to a massGroup in the drawing
	}

	if (!mg.bIsValid() ) {
		reportMessage("\n"+scriptName() +": " + T("|No Entity found!|") + " (" +_Entity[0].typeDxfName()+") "+ T("|Instance erased.|"));
		eraseInstance();
		return;
	}	
	else
	{	
	// write the posnum if found in mapX to all matching property sets
		String sArAvailablePropSetNames[] = MassGroup().availablePropSetNames();

		int nPos = mg.subMapX("hsbPosNum").getInt(sArPropertyNames[0]);
		if (nPos>-1)
		{
			for (int e=0; e<sArAvailablePropSetNames.length();e++)	
			{
				//reportNotice("\nattaching " +sArAvailablePropSetNames[e]);	
				int bAttachMe = mg.attachPropSet(sArAvailablePropSetNames[e]);
				Map map = mg.getAttachedPropSetMap(sArAvailablePropSetNames[e], sArPropertyNames);	
			
			// validate if a property 'posnum' can be found	
				int bOk=false;
				for (int m=0;m<map.length();m++)
				{
					//reportNotice("\nproperty " + m + " = " + map.keyAt(m));
					if (map.keyAt(m).makeUpper()==sArPropertyNames[0].makeUpper())
					{
						bOk=true;
						break;
					}	
				}
			
			// if it does not contain a 'posnum' and it was attached bythis tool remove it	
				if (!bOk){
					if (bAttachMe) 
					{
						mg.removePropSet(sArAvailablePropSetNames[e]);
						//reportNotice("\n" +sArAvailablePropSetNames[e]+ " removed");	
					}
					continue;
				}	
			
			// set the posnum from mapX			
				map.setInt(sArPropertyNames[0],nPos);
				mg.setAttachedPropSetFromMap(sArAvailablePropSetNames[e], map, sArPropertyNames);			
			}
		}// end if has posnum
		else
		{
			reportNotice("\n" + mg.handle()	+ " " + T("|has no PosNum assigned.|"));
			
		}
	}
	
// erase if attached to dwg
	if (_Map.getInt("erase")==true)
	{
		eraseInstance();
		return;	
	}	
#End
#BeginThumbnail

#End
