#Version 8
#BeginDescription
version  value="2.2" date="31jan14" author="th@hsbCAD.de"
writes dimensions of nested entities, if an ECS Marker could be found or child entity is based on a genbeam
posnums are now also assigned for entities of type beam, sheet or panel if they appear to be the parent entity
emulates the command HSB_ASSIGNPOSNUMS
metal part property set also assigned to genbeams
for genbeams the name property is copied if set for the genBeam


requires 17.2.6.0 or higher

DE
/// Diese TSL prüft ob die Eigenschaftssatz-Definitionen der gewählten Massengruppe auf das Feld ‚PosNum' 
/// und schreibt den Wert aus der hsbNummerierung in dieses Eigenschaftsfeld.
/// Ist der Eigenschaftssatz nicht dem Objekt zugewiesen, so wird dieser ergänzt, wenn er das entsprechende Feld enthält.

EN
/// This TSL checks the property sets of the selected massgroup after the field ‚PosNum' 
/// and writes this value as well as other weight informations to the property set

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Diese TSL prüft ob die Eigenschaftssatz-Definitionen der gewählten Massengruppe auf das Feld ‚PosNum' 
/// und schreibt den Wert aus der hsbNummerierung in dieses Eigenschaftsfeld.
/// Ist der Eigenschaftssatz nicht dem Objekt zugewiesen, so wird dieser ergänzt, wenn er das entsprechende Feld enthält.
/// </summary>

/// <summary Lang=en>
/// This TSL checks the property sets of the selected massgroup after the field ‚PosNum' 
/// and writes this value as well as other weight informations to the property set
/// </summary>

/// <insert=de>
/// Wählen Sie alle Bauteile aus. Sollte die Eigenschaftssatzdefinition ungültig sein, bzw die gewählte Eigenschaft
/// nicht in diesem vorhanden sein wird ein Dialog angezeigt und nach erfolgreicher Änderung kann der Befehl erneut ausgeführt werden.
/// </insert>

/// <remark Lang=de>
/// Dieses TSL ist abhängig von Eigenschaftssaätzen, welche diese Datenstruktur unterstützt (hsbMetalPart)
/// </remark>

/// History
///<version  value="2.2" date="31jan14" author="th@hsbCAD.de"> writes dimensions of nested entities, if an ECS Marker could be found or child entity is based on a genbeam </version>
///<version  value="2.1" date="10jan14" author="th@hsbCAD.de"> posnums are now also assigned for entities of type beam, sheet or panel if they appear to be the parent entity, emulates the command HSB_ASSIGNPOSNUMS, metal part property set also assigned to genbeams, for genbeams the name property is copied if set for the genBeam</version>
///<version  value="2.0" date="22mar12" author="th@hsbCAD.de">posnums are now also assigned for entities of type beam, sheet or panel</version>
///<version  value="1.9" date="08feb12" author="th@hsbCAD.de">new option to calculate the total surface area of the metalpart. data will be written to property set field named 'surface'</version>
///<version  value="1.8" date="31jan12" author="th@hsbCAD.de">new options to keep existing posnum and part name, new numbering method, requires 17.2.6.0 or higher</version>
///<version  value="1.7" date="23jan12" author="th@hsbCAD.de">optional removal of posnums if execute key contains 'releasePosNum'</version>
///<version  value="1.6" date="13jan12" author="th@hsbCAD.de">cosmetics</version>
///<version  value="1.5" date="25oct11" author="th@hsbCAD.de">upgrade to new methods, requires 17.1.29.0 or higher</version>
///<version  value="1.4" date="24oct11" author="th@hsbCAD.de"></version>



// basics and props
	U(1,"mm");
	String sArNY[]={T("|No|"), T("|Yes|")};
	String propS[0],propN[0];
	propN.append(T("|Start Number Parent|"));
	PropInt nParentStart(0, 1, propN[propN.length()-1]);
	propN.append(T("|Start Number Child|"));	
	PropInt nChildStart(1, 100, propN[propN.length()-1]);	

	propN.append(T("|Keep existing PosNum|"));	
	PropString sKeepExisting(2, sArNY, propN[propN.length()-1]);	

	propN.append(T("|Automatic Naming|"));	
	PropString sAutoNames(3, sArNY, propN[propN.length()-1]);

			
	double dEps = U(0.1);
	String sArPropertyNames[]={"POSNUM","GROSVOLUME","NAME", "GROSWEIGHT", "SURFACE","LENGTH","WIDTH","HEIGHT"};
	int bDebug;
	if (projectSpecial().find(scriptName(),0)>-1)bDebug=true;
	String sPrompt = T("|Select a set of metalparts (Massgroups, Beams, Sheets)|");
			
// on insert
	if (_bOnInsert) {
		if (insertCycleCount()>1) { eraseInstance(); return;}
	
	// declare prompt
 		PrEntity ssE(sPrompt , MassGroup());
		ssE.addAllowedClass(GenBeam());	
		
	// get execute key
		String sKey = _kExecuteKey.makeUpper();
		if (sKey=="ALL")
		{
			_Entity.append(Group().collectEntities(true,MassGroup(),_kModelSpace));
		}
		else if (sKey=="RELEASEPOSNUM")
		{	
			if (ssE.go()) 
				_Entity.append(ssE.set());
			_Map.setInt("releasePosNum", true);
		}
		else
		{	
			showDialog();		
			if (ssE.go()) 
				_Entity.append(ssE.set());
		}
		_Map.setInt("erase",true);
		//_Pt0 = getPoint();
		return;
	}
//end on insert________________________________________________________________________________



// detect mode
	int nMode;
	// 0 = add
	// 1 = remove
	if (_Map.getInt("releasePosNum")) nMode = 1;

	int bKeepExisting = sArNY.find(sKeepExisting,0);
	int bAutoNames = sArNY.find(sAutoNames,0);

// assign posnums to parent entities
	Entity entArParent[0];
	GenBeam genBeams[0];
	TslInst tsls[0];
	for (int i=0;i<_Entity.length();i++)
	{	
		Entity ent = _Entity[i];
		if (ent.bIsKindOf(MassGroup()))
			entArParent.append(ent);
		else if (ent.bIsKindOf(GenBeam()))
			genBeams.append((GenBeam)ent);
		if (bDebug)
			reportMessage("\nSelected Entities:\n	genbeams: " + genBeams.length() + "\n	MassGroup: " + entArParent.length());				
	}

// assign posnum to parent massgroups
	if (nMode ==0)
		MassGroup().assignPosnums(nParentStart, entArParent, bKeepExisting, true, false); 
	else
		MassGroup().releasePosnums(entArParent,true, true); 
		
// assign or release posnums from genBeams				
	for (int i=0;i<genBeams.length();i++)
	{
	// assign/release the posnum
		GenBeam gb = genBeams[i];
		if (nMode==0)	gb.assignPosnum(nParentStart); 	
		else	gb.releasePosnum(true); 	 

	// get property sets of this entity type
		String sArAvailablePropSetNames[0];
		if (gb.bIsKindOf(Beam()))sArAvailablePropSetNames= Beam().availablePropSetNames();
		else if (gb.bIsKindOf(Sheet()))sArAvailablePropSetNames= Sheet().availablePropSetNames();
		else if (gb.bIsKindOf(Sip()))sArAvailablePropSetNames= Sip().availablePropSetNames();

	// attach propset and data to the genbeam
		int nPos =gb.posnum();	
		if (bDebug)	reportMessage("\nNew Genbeam posnum: " + nPos);		
						
	// assign or release(if posnum == -1) posnum from property set
	// loop available property sets	
		if (bDebug)	reportMessage("\nGenbeam propSets: " + sArAvailablePropSetNames);	
		for (int f=0; f<sArAvailablePropSetNames.length();f++)	
		{
			if (bDebug)reportMessage("\n	" +sArAvailablePropSetNames[f]);	
			
		// try to attach the property set and find a property 'posnum'	
			int bAttachMe;
			if (nPos>-1)
				bAttachMe = gb.attachPropSet(sArAvailablePropSetNames[f]);
			Map map = gb.getAttachedPropSetMap(sArAvailablePropSetNames[f], sArPropertyNames);	
		
		// validate if a property 'posnum' can be found	
			int bOk=false;
			for (int m=0;m<map.length();m++)
			{
				if (bDebug)reportMessage("\n		property " + m + " = " + map.keyAt(m));
				if (map.keyAt(m).makeUpper()==sArPropertyNames[0].makeUpper())
				{
					bOk=true;
					break;
				}	
			}
		
		// if it does not contain a 'posnum' and it was attached bythis tool remove it	
			if ((!bOk && nMode==0 && bAttachMe) || (bOk && nMode==1 && nPos<0))
			{
				gb.removePropSet(sArAvailablePropSetNames[f]);
				if (bDebug)reportMessage("\n" +sArAvailablePropSetNames[f]+ "		removed, posnum = " +nPos);	
				continue;
			}	
		
		// write posnum to the propertyset map	
			map.setInt(sArPropertyNames[0],nPos); // sArPropertyNames[0]== POSNUM		
			map.setDouble(sArPropertyNames[4],gb.realBody().area()/1000/1000,_kNoUnit); // sArPropertyNames[0]== POSNUM	

		// write name if not already set in property set
			String sThisName;// = map.getString(sArPropertyNames[2]);
			if (bDebug)reportMessage("\n	existing Name: " +sThisName);
			// no name set
			
			if(bAutoNames)
			{
			// reuse genbeam name
				if (gb.bIsValid() && gb.name()!="")
				{
					sThisName =gb.name();	
					if (bDebug)reportMessage("\n		Name copied from genBeam");
				}
				else
				{		
				// it is always the main part		
					sThisName = T("|Part|") + " " + nPos;
				// assign genbeam name
					if (gb.bIsValid()) 
					{
						gb.setName(sThisName);
						if (bDebug)reportMessage("\n		genBeam Name set");
					}
				}						
			}
		// set the name entry
			if (sThisName !="")
			{
				map.setString(sArPropertyNames[2],sThisName );	
				if (bDebug)reportMessage("\n	Name set: " +sThisName);
			}						

					
		// the brut weight should be calculated by the volume without any subtractional entities, such as drills etc
		// currently this is not the case		
		// set grosVolume	
			double dVolM3 = gb.volume()/(U(1,"mm")*U(1,"mm")*U(1,"mm"))/pow(1000,3);	
			if (bDebug)reportMessage("\n" + sArPropertyNames[1] + " in m3 "+ dVolM3 );	
			map.setDouble(sArPropertyNames[1],dVolM3 ,_kNoUnit);	
		
		// set properties map
			gb.setAttachedPropSetFromMap(sArAvailablePropSetNames[f], map, sArPropertyNames);				
			if (bOk)break;			
		}// next f: loop available property sets	
	}// next i genbeam	

// loop parent entities, assign or release posnums of childs
	for (int i=0;i<entArParent.length();i++)
	{
	// this massgroup	
		MassGroup mgParent=(MassGroup)entArParent[i];
		
	// collect the child entities of this massGroup
		Entity entArChild[] = mgParent.entity();	
			
	// assign posnum of childs
		if (nMode ==0)
		{
			MassGroup().assignPosnums(nChildStart, entArChild, bKeepExisting, true, true); 
		// also number potential genbeams
			for (int e=0; e<entArChild.length();e++)
				if (entArChild[e].bIsKindOf(GenBeam()))
				{
					GenBeam gb = (GenBeam)entArChild[e];
					if (bKeepExisting && gb.posnum()!=-1) continue;
					gb.assignPosnum(nChildStart);	
				}			
		}
	// release posnum	
		else if (nMode ==1)
		{
			mgParent.removeSubMapX("hsbPosNum");
			for (int e=0; e<entArChild.length();e++)
				if (entArChild[e].bIsKindOf(GenBeam()))
				{
					GenBeam gb = (GenBeam)entArChild[e];
					gb.releasePosnum(true);	
				}
		}	
		int nThisPos = mgParent.posnum();
		
	// the family contains the parent and the childs	
		Entity entArFamily[0];
		int nKindOfs[0];// collects the kind of entity as int
			// 0 = mass group
			// 1 = beam
			// 2 = sheet
			// 3 = panel
			// 4 = tsl
		entArFamily.append(mgParent);
		nKindOfs.append(0);
		
		int bHasChild;
		for (int e=0; e<entArChild.length();e++)
		{
			int nKindOf=-1;
			if(entArChild[e].bIsKindOf(MassGroup()))nKindOf=0;
			else if(entArChild[e].bIsKindOf(Beam()))nKindOf=1;
			else if(entArChild[e].bIsKindOf(Sheet()))nKindOf=2;
			else if(entArChild[e].bIsKindOf(Sip()))nKindOf=3;
			else if(entArChild[e].bIsKindOf(TslInst()))nKindOf=4;
			
			if(nKindOf>-1)
			{
				bHasChild=true;
				entArFamily.append(entArChild[e]);
				nKindOfs.append(nKindOf);
			// release posnum	for massgroups
				if (nMode ==1 && nKindOf==0)	
					entArChild[e].removeSubMapX("hsbPosNum");
			}	
		}

		int nChildIndex=1;

	// attach propset and data to all members of the family
		for (int e=0; e<entArFamily.length();e++)
		{
		// collect matching property sets and assign entity by type
			MassGroup mg;
			GenBeam gb;
			Beam bm;
			Sheet sh;
			Sip sip;
			TslInst tsl;
			Entity ent = entArFamily[e];
			
			String sArAvailablePropSetNames[0];
			int nPos=-1;
			double dX, dY, dZ;
			if (nKindOfs[e]==0) 
			{
				sArAvailablePropSetNames= MassGroup().availablePropSetNames();
				mg = (MassGroup)ent;
				nPos =mg.posnum();
			// get entities of massgroup check childs for coordSys
				Entity entsMg[] = mg.entity();
				Vector3d vxMg=_XW, vyMg=_YW, vzMg=_ZW;
				// search for EcsMarker and buffer potential genbeam if no ECS found
				GenBeam gbMg;
				EcsMarker ecs;
				for (int em=0;em<entsMg.length();em++)
				{
					Entity entMg = entsMg[em];
					if (entMg.bIsKindOf(EcsMarker()))	
					{
						EcsMarker ecs =(EcsMarker)entMg;
						vxMg = ecs.coordSys().vecX();
						vyMg = ecs.coordSys().vecY();
						vzMg = ecs.coordSys().vecZ();
					}
					else if (entMg.bIsKindOf(GenBeam()))	
					{
						gbMg=(GenBeam)entMg;
					}
				}
			// no coord sys found, check for genbeam
				if (!ecs.bIsValid() && gbMg.bIsValid())
				{
					vxMg = gbMg.vecX();
					vyMg = gbMg.vecY();
					vzMg = gbMg.vecZ();					
				}		
				Body bd = ent.realBody();	
				dX = bd.lengthInDirection(vxMg);
				dY = bd.lengthInDirection(vyMg);
				dZ = bd.lengthInDirection(vzMg);			
			}
			else if (nKindOfs[e]==1) 
			{
				sArAvailablePropSetNames= Beam().availablePropSetNames();
				bm = (Beam)ent;
				gb = bm;
				nPos =bm.posnum();
				dX = bm.solidLength();
				dY = bm.solidWidth();
				dZ = bm.solidHeight();			
			}
			else if (nKindOfs[e]==2) 
			{
				sArAvailablePropSetNames= Sheet().availablePropSetNames();
				sh  = (Sheet)ent;
				gb = sh;
				nPos =sh.posnum();
				dX = sh.solidLength();
				dY = sh.solidWidth();
				dZ = sh.solidHeight();				
			}
			else if (nKindOfs[e]==3) 
			{
				sArAvailablePropSetNames= Sip().availablePropSetNames();
				sip = (Sip)ent;
				gb = sip;
				nPos =sip.posnum();
				dX =sip.solidLength();
				dY =sip.solidWidth();
				dZ =sip.solidHeight();				
			}
			else if (nKindOfs[e]==4) 
			{
				sArAvailablePropSetNames= TslInst().availablePropSetNames();
				tsl = (TslInst)ent;
				nPos =tsl.posnum();
			}
			
		// assign or release(if posnum == -1) posnum from property set
		// loop available property sets	
			for (int f=0; f<sArAvailablePropSetNames.length();f++)	
			{
				if (bDebug)reportMessage("\n	" +e+sArAvailablePropSetNames[f]);	
				
			// try to attach the property set and find a property 'posnum'	
				int bAttachMe;
				if (nPos>-1)
					bAttachMe = ent.attachPropSet(sArAvailablePropSetNames[f]);
				Map map = ent.getAttachedPropSetMap(sArAvailablePropSetNames[f], sArPropertyNames);	
			
			// validate if a property 'posnum' can be found	
				int bOk=false;
				for (int m=0;m<map.length();m++)
				{
					if (bDebug)reportMessage("\n		property " + m + " = " + map.keyAt(m));
					if (map.keyAt(m).makeUpper()==sArPropertyNames[0].makeUpper())
					{
						bOk=true;
						break;
					}	
				}
			
			// if it does not contain a 'posnum' and it was attached bythis tool remove it	
				if (!bOk && nMode==0){
					if (bAttachMe) 
					{
						ent.removePropSet(sArAvailablePropSetNames[f]);
						if (bDebug)reportMessage("\n" +sArAvailablePropSetNames[f]+ "		removed");	
					}
					continue;
				}	
			
			// write posnum to the propertyset map	
				map.setInt(sArPropertyNames[0],nPos); // sArPropertyNames[0]== POSNUM		
				map.setDouble(sArPropertyNames[4],ent.realBody().area()/1000/1000,_kNoUnit); // sArPropertyNames[0]== POSNUM	
				map.setDouble(sArPropertyNames[5],dX,_kLength);
				map.setDouble(sArPropertyNames[6],dY,_kLength);
				map.setDouble(sArPropertyNames[7],dZ,_kLength);

			// write name if not already set in property set
				String sThisName;// = map.getString(sArPropertyNames[2]);
				if (bDebug)reportMessage("\n	Existing Name: " +sThisName);
				// no name set
				
				if(bAutoNames)
				{
				// if it is a child build an indexed list or (if a genbeam) reuse genbeam names
					if (ent!=mgParent)
					{	
					// reuse genbeam name
						if (gb.bIsValid() && gb.name()!="")
						{
							sThisName =gb.name();	
							if (bDebug)reportMessage("\n		Name copied from genBeam");
						}
						else
						{		
							sThisName = T("|Part|") + " " + nThisPos + "." + nChildIndex;
						// assign genbeam name
							if (gb.bIsValid()) 
							{
								gb.setName(sThisName);
								if (bDebug)reportMessage("\n		genBeam Name set");
							}
							nChildIndex++;
						}
					}													
				// if it is the main part		
					else if (ent==mgParent)
					{			
						sThisName = T("|Part|") + " " + nThisPos;
					}
				
				}
			// set the name entry
				if (sThisName !="")
				{
					map.setString(sArPropertyNames[2],sThisName );	
					if (bDebug)reportMessage("\n	Name set: " +sThisName);
				}						
				
			
			// the brut weight is calculated by the volume without any subtractional entities, such as drills etc
				if (!bHasChild)
				{
				// collect additive parts
					Body bdBrut;	
					for (int c=0; c<entArChild.length();c++)
					{
						Entity entChild = entArChild[c];
						int nOperation = mgParent.operation(entChild);
						if (nOperation==_kAOPAdditive)
						{
							if (bdBrut.volume()<pow(dEps,3))
								bdBrut= entChild .realBody();
							else
								bdBrut.addPart(entChild.realBody());
						}
					}
					bdBrut.vis(1);
				
				// set grosVolume	
					double dVolM3 = bdBrut.volume()/(U(1,"mm")*U(1,"mm")*U(1,"mm"))/pow(1000,3);	
					if (bDebug)reportMessage("\n" + sArPropertyNames[1] + " in m3 "+ dVolM3 );	
					map.setDouble(sArPropertyNames[1],dVolM3 ,_kNoUnit);	
				}
			
			// set properties map
				ent.setAttachedPropSetFromMap(sArAvailablePropSetNames[f], map, sArPropertyNames);				
				if (bOk)break;			
			}// next f: loop available property sets	

			if (bDebug)reportNotice("\n");
		}// next e massGroup

		if (bDebug)
			for (int e=0; e<entArChild.length();e++)
				if (entArChild[e].bIsKindOf(MassGroup()))
					reportNotice("\nParent i: " + i + " Pos: " +entArParent[i].subMapX("hsbPosNum").getInt("POSNUM") + " child e: " + e + " Pos: " + entArChild[e].subMapX("hsbPosNum").getInt("POSNUM") );			
	}

// erase if attached to dwg
	if (_Map.getInt("erase")==true && !bDebug)
	{
		eraseInstance();
		return;	
	}	






#End
#BeginThumbnail
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
B+6"W@2"WB2&(#A(U"C]*FM6J1LF_N_K_`"+ITX/;\3__V7B<
`






#End
