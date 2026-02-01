#Version 8
#BeginDescription
#Versions
Version 5.3 20.10.2022 HSB-16861 bugfix beam sheet converting when material is not defined
Version 5.2 15.01.2021 HSB-10362 debug message removed
Version 5.1 15.01.2021 HSB-10362 Default catalog entries (default and last inserted) are ignored for instance creation

HSB-9138 X-Grid tolerance increased
HSB-7407 X-Grid distribution enhanced V

DACH
Dieses TSL erzeugt Nagelreihen an ein oder mehrern Elementen.

EN
This tsl inserts naillines. It creates nailing instances based on entries which match the model criteria






















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 5
#MinorVersion 3
#KeyWords Element;Nailing,CNC;Nail
#BeginContents
//region Part 1
		

//region header
/// <summary Lang=en>
/// This tsl inserts naillines. It creates nailing instances based on entries which match the model criteria
/// </summary>


/// <insert Lang=en>
/// This tsl is based on its catalog entries and therefor one needs to configure it prior the first use
/// To create a configuration simply press enter when prompted and follow further instructions
/// </insert>

/// <insert remark=en>
/// This tsl creates opmn named sub instances named
/// hsbNailing-Lath: creates a nailing on laths
/// hsbNailing-Sheet: creates nailings on sheets
/// hsbNailing-Stud: creates nailings on studs
/// </remark>


/// History
// #Versions
// 5.3 20.10.2022 HSB-16861 bugfix beam sheet converting when material is not defined , Author Thorsten Huck
// 5.2 15.01.2021 HSB-10362 debug message removed
// 5.1 15.01.2021 HSB-10362 Default catalog entries (default and last inserted) are ignored for instance creation
///<version  value="5.0" date="08oct20" author="thorsten.huck@hsbcad.com"> HSB-9138 X-Grid tolerance increased </version>
///<version  value="4.9" date="27apr20" author="thorsten.huck@hsbcad.com"> HSB-7407 X-Grid distribution enhanced V </version>
///<version  value="4.8" date="19mar20" author="thorsten.huck@hsbcad.com"> HSB-6501 X-Grid distribution enhanced IV </version>
///<version  value="4.7" date="19mar20" author="thorsten.huck@hsbcad.com"> HSB-6501 X-Grid distribution enhanced III </version>
///<version  value="4.6" date="19mar20" author="thorsten.huck@hsbcad.com"> HSB-6501 X-Grid distribution enhanced II </version>
///<version  value="4.5" date="13feb20" author="thorsten.huck@hsbcad.com"> HSB-6501 X-Grid distribution enhanced </version>
///<version  value="4.4" date="30jan20" author="thorsten.huck@hsbcad.com"> HSB-6501 relative X-location tested for multiple parallel linesegments HSB-5616 enhanced </version>
///<version  value="4.3" date="16sep19" author="thorsten.huck@hsbcad.com"> HSB-5616 tolerance issue resolved when multiple parallel linesegments are tested against X-Grid </version>
///<version  value="4.2" date="16sep19" author="thorsten.huck@hsbcad.com"> HSB-5615 nailline pairs enhanced for large beams </version>
///<version  value="4.1" date="05jul19" author="thorsten.huck@hsbcad.com"> 'Nail on grid studs' enhanced </version>
///<version  value="4.0" date="05jul19" author="thorsten.huck@hsbcad.com"> HSB-5274 'Nail on grid studs' considers nonail and saw protection are prior nail segment creation </version>
///<version  value="3.9" date="03jul19" author="thorsten.huck@hsbcad.com"> mode 3 onSheet uses envelopeBody instead of realBody, openings fixed   </version>
///<version  value="3.8" date="02jul19" author="thorsten.huck@hsbcad.com"> new parameter 'ConvertSheet' added to settings Mode[]\\Lath to disable (value = 0) or enable (value = 1) the conversion of sheets into beams  </version>
///<version  value="3.7" date="28jun19" author="thorsten.huck@hsbcad.com"> HSB-5107 openings rings of contact face are grown and added to nailable area with XEndOffset instead EdgeOffset </version>
///<version  value="3.6" date="24may19" author="thorsten.huck@hsbcad.com"> HSB-5107 openings rings of contact face are grown and added to nailable area  </version>
///<version  value="3.5" date="11apr19" author="thorsten.huck@hsbcad.com"> HSBCAD-4862 supports genbeam name filter through external settings file </version>
///<version  value="3.4" date="15mar19" author="thorsten.huck@hsbcad.com"> minor bugfix on element cinstructed </version>
///<version  value="3.3" date="11feb19" author="thorsten.huck@hsbcad.com"> HSBCAD-486: modelmap call restricted to element construction, insertion or hsb_recalc. Sawline parameters are only stored during one of these events </version>
///<version  value="3.2" date="08feb19" author="thorsten.huck@hsbcad.com"> collection of referenceplane for type 5 limited to vertical beams to avoid beams which sticking out of the zone </version>
///<version  value="3.1" date="20dec18" author="thorsten.huck@hsbcad.com"> detection of contact plane of frame enhanced if entire plane needs to be offseted</version>
///<version  value="3.0" date="29mar18" author="thorsten.huck@hsbcad.com"> considers potential no nail definitions via subMapX of first citizen tsls </version>
///<version  value="2.9" date="28jul17" author="thorsten.huck@hsbcad.com"> 'Nail on grid studs' bugfix assignment vertical segments under openings </version>
///<version  value="2.8" date="28jul17" author="thorsten.huck@hsbcad.com"> 'Nail on grid studs' bugfix assignment vertical segments to sheets</version>
///<version  value="2.7" date="27jul17" author="thorsten.huck@hsbcad.com"> 'Nail on grid studs' bugfix colinear vertical segments </version>
///<version  value="2.6" date="10jul17" author="thorsten.huck@hsbcad.com"> 'Nail on grid studs' vertical segments accepting slightly offseted segments in grid </version>
///<version  value="2.5" date="07jul17" author="thorsten.huck@hsbcad.com"> 'Nail on grid studs' vertical segments revised II </version>
///<version  value="2.4" date="07jul17" author="thorsten.huck@hsbcad.com"> 'Nail on grid studs' vertical segments revised  </version>
///<version  value="2.3" date="22may17" author="thorsten.huck@hsbcad.com"> 'Nail on grid studs' vertical colinear segments of same sheet collected  </version>
///<version  value="2.2" date="20apr17" author="thorsten.huck@hsbcad.com"> 'Nail on grid studs' more tolerant </version>
///<version  value="2.1" date="20jan17" author="thorsten.huck@hsbcad.com"> previously attached naillines and instances of this tsl will be erased from any selected element </version>
///<version  value="2.0" date="25nov16" author="thorsten.huck@hsbcad.com"> bugfix sheet on sheet mode: offsets more tolerant on smaller contours. top and bottom offset only applied if segment is above/below average mid  </version>
///<version  value="1.9" date="18nov16" author="thorsten.huck@hsbcad.com"> 2 naillines on stud grid if beam width >=160mm </version>
///<version  value="1.8" date="30jun16" author="thorsten.huck@hsbcad.com"> combination of nail segments revised. segments are now combined if colinear and within combination range </version>
///<version  value="1.7" date="29jun16" author="thorsten.huck@hsbcad.com"> nailing type 'on sheet' has new properties 'merge gaps' and 'Distance from sheeting edge' for contact zone </version>
///<version  value="1.6" date="29jun16" author="thorsten.huck@hsbcad.com"> introducing additional cascading tests against wall code, element type, exposure and load bearing property. Please review existing catalog entries! </version>
///<version  value="1.5" date="21jun16" author="thorsten.huck@hsbcad.com"> bugfix for zone indices = 0 </version>
///<version  value="1.4" date="06jun16" author="thorsten.huck@hsbcad.com"> bugfix debug index </version>
///<version  value="1.3" date="03jun16" author="thorsten.huck@hsbcad.com"> bugfix sheet on sheet mode </version>
///<version  value="1.2" date="03jun16" author="thorsten.huck@hsbcad.com"> new type 'Nail on grid studs' released </version>
///<version  value="1.1" date="28apr16" author="thorsten.huck@hsbcad.com"> introducing the new type 'Nail on grid studs' </version>
///<version  value="1.0" date="07apr16" author="thorsten.huck@hsbcad.com"> initial </version>


//region constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end constants//endregion
//End Part 1//endregion 

//region modes
// this script supports various modes
	// 0 = setup mode: the user can define catalog entries and/or executes the insertion on a set of elements
	// 1 = insert mode: the user can execute the insertion on a set of elements
	// 2 = nail on laths
	// 3 = nail on sheetings
	// 4 = nail on studs
	// 5 = nail on stud grid
	String sOpmModes[]={"","","Lath","Sheet","Stud", "StudGrid"};
	String sOpmModesDistribution[]={"","",T("|Vert. latwerk op stijlen|"),"",""};	// the distribution of a zone is returned as translated string
	String sOrienations[] = {T("|Horizontal even|"),T("|Vertical even|"),T("|Horizontal fixed|"),T("|Vertical fixed|")};
	String sScriptOpmName;	
	String sPropDesc = T("|Separate multiple entries by|")+ " ' ;'";
	String sPropNameBelow = T("|Lath Material|") + " " +  T("|(Empty = all)|");
	String sDescNoFilter = T("|0 = no color filter|");


	
/// get mode	
	int nMode=_Map.getInt("mode");		
//END Header//endregion 
	
//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="hsbNailing";
	Map mapSetting;

// find settings file
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound;
	if (_bOnInsert)
		bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";
	String sFile=findFile(sFullPath); 

// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() && sFile.length()>0)
	{
		mapSetting.readFromXmlFile(sFile);
		mo.dbCreate(mapSetting);
	}		
//End Settings//endregion

//region Read Settings
	Map mapMaterials;
	int bConvertSheet = true;
{
	/*
	HSBCAD-4862
	Copy following lines and save as <comapny>\tsl\settings\hsbNailing.xml
	<?xml version="1.0" encoding="UTF-8"?>
	<Hsb_Map>
		<lst nm="Mode[]">
			<lst nm="StudGrid">
				<lst nm="Material[]">
					<lst nm="XPS">
						<lst nm="ExclusiveName[]">
							<str nm="ExclusiveName" vl="Schwelle-Hauseingang"/>
							<!-- Sample Entry
							<str nm="ExclusiveName" vl="Value of name property"/>
							 -->
						</lst>
					</lst>
				</lst>
			</lst>
		</lst>
		<unit ut="L" uv="millimeter"/>
		<unit ut="A" uv="radian"/>
	</Hsb_Map>		
	*/
	String k;
	if (nMode>1 && nMode<sOpmModes.length())
	{
		Map m,m2;
		k = "Mode[]\\" + sOpmModes[nMode];		m = mapSetting.getMap(k);
		
		k = "Material[]";	
		mapMaterials= m.getMap(k);
		
		k= "ConvertSheet";	if (m.hasInt(k))bConvertSheet = m.getInt(k);
		//if (mapSetting.hasMap(k))mapMaterials= mapSetting.getMap(k);
	}
		
	//ConvertSheet	
		
}
//End Read Settings//endregion 

//region string definitions
		

	if (_bOnDebug)
	{
	// ChangeModeTrigger
		String sTriggerChangeMode = "Change Mode";
		addRecalcTrigger(_kContext, sTriggerChangeMode );
		if (_bOnRecalc && _kExecuteKey==sTriggerChangeMode )
		{
			int n = getInt("\nLath = 2, Sheet = 3, Stud = 4, Grid = 5");
			if (n>1 && n<6)
				_Map.setInt("mode", n);
			setExecutionLoops(2);
			return;
		}
	}
	
	
	

// property names
	String sPropNamesN[0],sPropNamesS[0], sPropNamesD[0];

	String sZoneName = T("|Zone|");
	String sToolIndexName= T("|Nailing tool index|");
	String sExcludeColorName = T("|Exclude Color|");
	String sMaterialName = T("|Material|");
	String sSpacingName= T("|Maximum nailing spacing|");
	String sEdgeOffsetSideName = T("|Distance from sheeting edge|");
	String sEdgeOffsetBeamName = T("|Distance from beam edge|");
	String sEdgeOffsetContactSheetName = sEdgeOffsetSideName + " ";
	String sEdgeOffsetXName = T("|Distance end beams|");	
	String sMergeName = T("|Combine Nail Lines|");
	String sXGridName = T("|X-Grid|");

	String sElementFilterName=T("|Element Filter|");	
	String sExposedFilterName=T("|Exposed|");	
	String sLoadBearingFilterName=T("|Load Bearing Walls|");

	
	String sCategoryNailing= T("|Nailing|");
	String sCategoryContactZone = T("|Contact Zone|");
	String sCategoryDistribution= T("|Distribution|");
	String sCategoryFilter= T("|Filter|");	
	
	String sSpacingDescription=T("|Defines the spacing of a nailline|");
	String sMergeDescription=T("|If greater than potential gaps colinear naillines  will be combined over multiple sheets|");
	String sEdgeOffsetSideDescription=T("|Defines the edge offset from the sheeting zone|");
	String sEdgeOffsetXDescription =T("|Defines the offset from the end of a beam or lath|");
	String EdgeOffsetBeamDescription =T("|Defines the minimal side offset to the beam|");
	String sXGridDescription = T("|Defines a grid in X-Direction.|" + " " + T("|Redundant naillines between the grid are supptressed.|"));
	
	String sExposedFilters[] = {T("|Disabled|"), T("|Interior|"), T("|Exterior|")};
	String sLoadBearingFilters[] = {T("|Disabled|"), T("|Not Load Bearing|"), T("|Load Bearing|")};	
	String sElementTypes[] = {T("|Wall|"),T("|Floor|"),T("|Roof|"),T("|Multielement|")};
	String sElementTypes2[0];sElementTypes2=sElementTypes;
	for(int i=0;i<sElementTypes2.length();i++)sElementTypes2[i].makeUpper();

	double dCombineLength;
	String sNums[] = {"0","1","2","3", "4", "5", "6", "7", "8", "9"};
		
// declare arrays for tsl cloning
	TslInst tslNew;
	Vector3d vecXTsl = _X0;
	Vector3d vecYTsl = _Y0;
	GenBeam gbsTsl[0];
	Entity entsTsl[0];
	Point3d ptsTsl[0];
	int nProps[0];
	double dProps[0];
	String sProps[0];
	Map mapTsl;
	String sScriptname = scriptName();
//End string definitions//endregion 

//region SETUP or Insert mode_
// _________________________________________________________________________________________________________________SETUP
	if (_bOnInsert && nMode<2)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }


	// selection of element		
		PrEntity ssEl(T("|Select Element(s)|")+" " + T("|<Enter> for setup|"), Element());
		Element elements[0];
  		if (ssEl.go())
    		elements = ssEl.elementSet();	


	// setup mode
		if (elements.length()<1)	
		{
		// nailing type
			String sTypes[] = {T("|Nail on laths|"),T("|Nail on sheeting|"),T("|Nail on studs|"),T("|Nail on grid studs|")};
			PropString sType(3,sTypes,T("|Type|"));	
			sType.setDescription(T("|Sets the type of the nailing kind|"));

			showDialog();
			
			int nThisMode= sTypes.find(sType)+2;		
			mapTsl.setInt("mode",nThisMode);
			sScriptOpmName = scriptName()+ "-" + sOpmModes[nThisMode];

		// create an dummy tsl to allow the user to define an catalog entry
			mapTsl.setInt("isDummy",true);
			tslNew.dbCreate(sScriptname, vecXTsl,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
				nProps, dProps, sProps,_kModelSpace, mapTsl); // create new instance		
			if (tslNew.bIsValid())
			{
			// declare the auto entry value
				String sAutoEntry;	
					
			// selection of a genBeam to derive zone and material		
				PrEntity ssGb(T("|Select GenBeam to get Tooling Zone and Material (optional)|"), GenBeam());
				Entity entsGb[0]; 
				if (ssGb.go())
    				entsGb= ssGb.set();
				if (entsGb.length()>0)
				{
					GenBeam gb = (GenBeam)entsGb[0];
					int n = gb.myZoneIndex();
					sAutoEntry+="Z"+n+" ";
					if(n!=0)
					{
						String m = gb.material();
						sAutoEntry+=m+" ";
						tslNew.setPropInt(0,n);
						tslNew.setPropString(0,m);
					}	
				}

			// selection of a genBeam to derive contact material		
				ssGb=PrEntity (T("|Select GenBeam to get Contact Zone and Material (optional)|"), GenBeam());
				if (ssGb.go())
    				entsGb= ssGb.set();
				if (entsGb.length()>0)
				{
					GenBeam gb = (GenBeam)entsGb[0];
					String m = gb.material();
					sAutoEntry+=m+" ";
					tslNew.setPropString(1,m);
				}
		
			// trim and validate auto entry name, save entry
				sAutoEntry.trimLeft().trimRight();	
				if (sAutoEntry.length()<1)
					sAutoEntry = "Auto" + tslNew.getListOfCatalogNames().length();
				//tslNew.setCatalogFromPropValues(sAutoEntry);
				

				
				
			// show the dialog of this sub type
				int bOk = tslNew.showDialog();
					
			// append filter keys to auto entry name 
				String sElementFilter  = tslNew.propString(4);
				if (sElementFilter.length()>0)
				{
					// maybe the semicolon should be replaced...
					sAutoEntry+= "_" + sElementFilter;
				}
				String sExposedFilter = tslNew.propString(5);
				int nExposedFilter = sExposedFilters.find(sExposedFilter);
				if (nExposedFilter>0) sAutoEntry+="_" + sExposedFilter;				
				String sLoadBearingFilter = tslNew.propString(6);
				int nLoadBearingFilter = sLoadBearingFilters.find(sLoadBearingFilter );
				if (nLoadBearingFilter >0) sAutoEntry+="_" + sLoadBearingFilter ;						
			
				if(bDebug)reportMessage("\n"+ scriptName() + " AutoEntry " + sAutoEntry);
				
				if(bDebug)reportMessage("\n"+ scriptName() + " DialogOk  " + bOk);
				if (bOk)
				{
					tslNew.setCatalogFromPropValues(sAutoEntry);
					if(bDebug)reportMessage("\n"+ scriptName() + " properties stored  " + bOk);			
				}
				tslNew.dbErase();
				eraseInstance();
				return;	
			}// end if dummy (tslNew.bIsValid())
		}		
		else
			nMode=1;// insert mode		
	// end if setup mode

	
	// erase existing nailing entities
		for(int e=0;e<elements.length();e++)
		{ 
			Element el = elements[e];
			int x,y;
		// erase tsl instances	
			TslInst tsls[]=el.tslInstAttached();
			for (int t=tsls.length()-1;t>=0;t--) 
			{ 
				if (tsls[t].scriptName()==scriptName())
				{
					tsls[t].dbErase();
					x++;
				}	 
			}
			
		// erase all nailing linesx
			NailLine nlines[] = el.nailLine();
			for (int t=nlines.length()-1;t>=0;t--) 
			{
				nlines[t].dbErase();
				y++;
			}

		// report erasing if any
			String sMsg="\n"+scriptName() + ": ";
			if (x>0)
				sMsg += x + " " + T("|existing tsl instances|") + (y>0?(" " + T("|and|") + " "):"");
			if (y>0)
				sMsg += y + " " + T("|naillines|") + " ";
			sMsg +=T("|of element|") + " " + el.number() + " " + T("|deleted|");
			if (x+y>0)
				reportMessage(sMsg); 	 
		}
		
	
	

	// report
		if (bDebug)
		{
			reportMessage("\n\n"+scriptName() + " *******");
			reportMessage("\n" + elements.length() + " " + T("|Element(s) selected|"));
		}

	// get catalog entries of all types
		mapTsl.setInt("isDummy",true);
		String sCatalogNames[0];
	
	// declare the three different map with properties
		int nThisMode=2;
		Map mapEntries[0];
		int nApplies2Type[0];	 	 	 		
				
	// loop the four types: Lath, Sheet, Stud or studGrid, collect catalog entries
		// it is assumed that a zone will not have alternating types
		for(int j=0;j<(sOpmModes.length()-2);j++)
		{
			mapTsl.setInt("mode",nThisMode);
			sScriptOpmName = scriptName()+ "-" + sOpmModes[nThisMode];
			
			String sLocalCatalogNames[]=TslInst().getListOfCatalogNames(sScriptOpmName); 
			sCatalogNames.append(sLocalCatalogNames);
			for(int i=0;i<sLocalCatalogNames.length();i++)
				nApplies2Type.append(nThisMode);
			if (sLocalCatalogNames.length()>0)
			{
				//if(bDebug)reportNotice("\n	" + sScriptOpmName +" :" + sLocalCatalogNames.length() + " " + T("|Entries|"));					
				
			// create an dummy tsl to collect the property values of each entry	
				tslNew.dbCreate(sScriptname, vecXTsl,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl); // create new instance	
				if (tslNew.bIsValid())
				{
					for(int i=0;i<sLocalCatalogNames.length();i++)
					{
						//if (bDebug)reportNotice("\n		" +"Entry" + " " + sLocalCatalogNames[i]);	
						tslNew.setPropValuesFromCatalog(sLocalCatalogNames[i]);
						mapEntries.append(tslNew.mapWithPropValues());					
					}// next i
					
					// erase the dummy tsl
						tslNew.dbErase();					
				}// END If valid tsl	
			}
		// next mode
			nThisMode++;			
		}// next j type

	// write debug file
		if (bDebug)
		{
			Map mapAll;
			for(int e=0;e<mapEntries.length();e++)
				mapAll.appendMap(e, mapEntries[e]);
			mapAll.writeToXmlFile("c:\\temp\\Nail_Entries.xml");
		}



	// clear mapTsl
		mapTsl = Map();

	// query elements to see if one has matching zones
		for(int e=0;e<elements.length();e++)
		{
		// validate type
			ElementWallSF wall =(ElementWallSF )elements[e];
			ElementRoof roof =(ElementRoof)elements[e];
			ElementMulti multi = (ElementMulti)elements[e];
				
		// get type, load bearing and code
			int nElementType;	// 0 = wall, 1 = floor,2=roof, 3 = multi element
			int nLoadBearing=-1; // not defined	
			String sCode;			
			if (wall.bIsValid())
			{
				nElementType=0;
				nLoadBearing = wall.loadBearing();	
				sCode = wall.code();
			}
			else if (roof.bIsValid() && roof.bIsAFloor())
				nElementType=1;
			else if (roof.bIsValid() && !roof.bIsAFloor())
				nElementType=2;
			else if (multi.bIsValid())
				nElementType=3;
			else
				{continue;}
		
		// debug print zones
			if (bDebug)
			{
				reportMessage("\n\n" + T("|Element|") + ": " + elements[e].number() + " Code " + elements[e].code());
				for(int z=0;z<11;z++)
				{
					int nZn = z-5;
					ElemZone elzo = elements[e].zone(nZn);
					if (elzo.dH()<dEps)continue;
					reportMessage("\n		" + T("|Zone|") + ": " + nZn + " " + elzo.distribution());		
				}
			}

		// declare array which catalog entry matches	
			int bCatalogApplies[mapEntries.length()];// default = false


		// get all genBeams of this element
			GenBeam gbAll[] = elements[e].genBeam();

		// loop entries
			//if (bDebug) reportNotice("\nAnalysing "+ mapEntries.length()+ " entries" );
			for(int i=0;i<mapEntries.length();i++)
			{
				nThisMode = nApplies2Type[i];
				Map mapEntry = mapEntries[i];
				//if (bDebug)	reportNotice("\n	Entry " + i +  " " + sOpmModes[nThisMode]);
				
			// integer properties	
				int z2, c2;			
				Map mapProps = mapEntry.getMap("PropInt[]");
				if (bDebug)reportMessage("\n		Integer properties of entry");
				for (int j= 0;j<mapProps.length();j++)
				{
					String sName = mapProps.getMap(j).getString("strName");
					int nValue = mapProps.getMap(j).getInt("lValue");
					if(bDebug)reportMessage("\n			"	+sName+ " = " + nValue);
				// zone
					if (sName==sZoneName) z2 = nValue;
				// exclude color
					if (sName==sExcludeColorName) c2 = nValue;
													
				}// next j

			// string properties	
				String m2,	sElementFilter2,	sExposedFilter2,	sLoadBearingFilter2;
				mapProps = mapEntry.getMap("PropString[]");
				if (bDebug)reportMessage("\n		String properties of entry");
				for (int j= 0;j<mapProps.length();j++)
				{
					String sName = mapProps.getMap(j).getString("strName");
					String sValue = mapProps.getMap(j).getString("strValue");
					if(bDebug)reportMessage("\n			"	+sName+ " = " + sValue);
				// material
					if (sName==sMaterialName) m2 = sValue.makeUpper() ;
				// ElementFilter
					else if (sName==sElementFilterName)sElementFilter2= sValue.makeUpper() ;
				// ExposedFilter
					else if (sName==sExposedFilterName)		sExposedFilter2= sValue.makeUpper()  ;
				// LoadBearingFilter
					else if (sName==sLoadBearingFilterName) sLoadBearingFilter2= sValue;																								
				}// next j
			
			// test element filter: either codes of walls or types of element
			// build array from semicolon seperated list of codes and element types
				String  sCodes[0],sElementFilters[0];
				String sList = sElementFilter2;
				while (sList.length()>0 || sList.find(";",0)>-1)
				{
					String sToken = sList.token(0);	
					sToken.trimLeft().trimRight();
					sToken.makeUpper();	
				// make sure no numbers can be used	
					int bOk=true;
					for(int i=0;i<sNums.length();i++)
						if (sToken.find(sNums[i],0)>-1)
						{
							bOk=false;
							break;
						}
				// test token against predfined element type key or ensure that a valid code with one or two characters is specified
					if (sElementTypes2.find(sToken)>-1 && sElementFilters.find(sToken)<0 && bOk)
						sElementFilters.append(sToken);
					else if (sToken.length()<3 && sCodes.find(sToken)<0 && bOk)
						sCodes.append(sToken);
			
					int x = sList.find(";",0);
					sList.delete(0,x+1);
					sList.trimLeft();	
					if (x==-1)	sList = "";	
				}
				if (bDebug)reportMessage("\n 	Element Filter found: " +sElementFilters);
				if (bDebug)reportMessage("\n 	Codes Filter found: " +sCodes + "\n");
				
			// code test
				int bCodeTest=true;
				if (sCodes.length()>0 && wall.bIsValid() && sCodes.find(wall.code())<0)	
					bCodeTest=false;
				if(bDebug)reportMessage("\n		Testing code "+ elements[e].code()+ " against " + sCodes + " = " + (bCodeTest==true?"OK":"FAILED"));

			// element type test
				int bElementTypeTest=true;
				if (sElementFilters.length()>0 && sElementFilters.find(sElementTypes[nElementType])<0)
						bElementTypeTest=false;
				if(bDebug)reportMessage("\n		Testing element type "+ elements[e].typeDxfName() + " against " + sElementFilters + " = "+(bElementTypeTest==true?"OK":"FAILED"));

			// exposed test
			// String sExposedFilters[] = {T("|Disabled|"), T("|Interior|"), T("|Exterior|")};
				int bExposedTest=true;
				if (wall.bIsValid() && sExposedFilter2!=sExposedFilters[0].makeUpper()   && (
					(!wall.exposed() && sExposedFilter2!=sExposedFilters[1].makeUpper() ) ||
					(wall.exposed() && sExposedFilter2!=sExposedFilters[2].makeUpper() )))
						bExposedTest=false;
				if(bDebug && wall.bIsValid())reportMessage("\n		Testing wall exposed type "+ (wall.exposed()?T("|exposed|"):T("|not exposed|")) + " against catalog " + sExposedFilter2+ " = "+(bExposedTest==true?"ok":"failed"));

			// load bearing test
			// String sLoadBearingFilters[] = {T("|Disabled|"), T("|Not Load Bearing|"), T("|Load Bearing|")};
				int bLoadBearingTest=true;
				if (wall.bIsValid() && sLoadBearingFilter2!=sLoadBearingFilters[0] && ( 
					(!wall.loadBearing() && sLoadBearingFilter2!=sLoadBearingFilters[1]) || 
					(wall.loadBearing() && sLoadBearingFilter2!=sLoadBearingFilters[2])))
						bLoadBearingTest=false;
				if(bDebug && wall.bIsValid())reportMessage("\n		Testing load bearing "+ wall.loadBearing() + " against " + sLoadBearingFilter2+ " = "+(bLoadBearingTest==true?"OK":"FAILED"));
			
			// skip material test if one of the previous tests has failed
				if (!bElementTypeTest || !bExposedTest || !bLoadBearingTest)
				{
					if(bDebug)reportMessage("\n		Skipping material test");
					continue;
				}
			
				
			// material test
				// loop genBeams and find a potential match
				int bMaterialTest;
				for (int g=0 ; g<gbAll.length();g++)
				{
					GenBeam gb = gbAll[g];
					int z = gb.myZoneIndex();
					String m = gb.material().makeUpper();
					int c = gb.color();	
					
				// entry matches
					if (z==z2 && c!=c2 && m==m2)
					{
						bMaterialTest= true;
						if (bDebug)reportMessage("\n		Testing material " +m +" in zone " + z + " against material " + m2 + "in zone " + z2 + " color " + c +" != " + c2);						
						break;
					}						
				}// next g	

				bCatalogApplies[i] = bMaterialTest;	
				//if(bDebug)reportNotice("\n		Result of all tests  = "+(bCatalogApplies[i]==true?"OK":"FAILED"));
			}// next i

		

			
		// loop for applicable entries and create instances
			for(int i=0;i<mapEntries.length();i++)	
			{
				if (!bCatalogApplies[i] || sCatalogNames[i].find(sLastInserted,0,false)>-1 || sCatalogNames[i].find(sDefault,0,false)>-1)continue;
				
				int nThisMode = nApplies2Type[i];
				//if (bDebug)reportNotice("\n\n" + T("|Catalog Entry|") + " " + sCatalogNames[i] + " " + T("|applies for type|") + " " + sOpmModes[nThisMode]);		

				mapTsl.setInt("mode",nThisMode);
				entsTsl.setLength(0);
				entsTsl.append(elements[e]);

				tslNew.dbCreate(scriptName(), vecXTsl,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl); // create new instance	
				if (tslNew.bIsValid())
					tslNew.setPropValuesFromCatalog(sCatalogNames[i]);	
			}
		
		}// next e element

		eraseInstance();
		return;
	}
// END Setup or Insert ____________________________________________________________________________________________________________END SETUP or insert	
		
//End SETUP or Insert mode_//endregion 

//region global variables
		

	int nZones[] = {-5,-4,-3,-2,-1,1,2,3,4,5};

// tooling zone
	String sCategoryToolZone = T("|Tooling Zone|");

	PropString sIncludeMaterial(0,"",sMaterialName);	
	sIncludeMaterial.setDescription(sPropDesc);
	sIncludeMaterial.setCategory(sCategoryToolZone);
	
	PropInt nExcludeColor(2,0,sExcludeColorName);	
	nExcludeColor.setDescription(sDescNoFilter );
	nExcludeColor.setCategory(sCategoryToolZone);
	
// contact zone
	PropString sIncludeMaterialContact(1,"",sMaterialName+" ");	
	sIncludeMaterialContact.setDescription(sPropDesc);
	sIncludeMaterialContact.setCategory(sCategoryContactZone);
	
	PropInt nExcludeColorContact(3,0,sExcludeColorName+" ");	
	nExcludeColorContact.setDescription(sDescNoFilter );
	nExcludeColorContact.setCategory(sCategoryContactZone);
	
	PropInt nZone(0,nZones,sZoneName);
	nZone.setCategory(sCategoryNailing);
	
	PropInt nToolIndex(1,1, sToolIndexName);
	nToolIndex.setCategory(sCategoryNailing);
		
	PropDouble dSpacing(0,U(50), sSpacingName);	
	dSpacing.setCategory(sCategoryNailing);
	
	PropDouble dMerge(3,0, sMergeName);
	dMerge.setDescription(sMergeDescription);
	dMerge.setCategory(sCategoryNailing);


// filter	
	PropString sElementFilter(4, "", sElementFilterName);	
	sElementFilter.setDescription(T("|Defines a set of filter criterias.|") + " " + T("|This option allows multiple entries. Separate entries by|") + " ';' " + 
		T("|You can specify wall codes or the element type|") + 
		" (" + sElementTypes[0]+", " + sElementTypes[1]+", " + sElementTypes[2]+" " +T("|or|")+" "+ sElementTypes[3] + ")");
	sElementFilter.setCategory(sCategoryFilter);
		
	PropString sExposedFilter(5, sExposedFilters, sExposedFilterName,0);	
	sExposedFilter.setDescription(T("|Defines wether wall elements are filtered by their exposing property|"));
	sExposedFilter.setCategory(sCategoryFilter);
	
	PropString sLoadBearingFilter(6, sLoadBearingFilters, sLoadBearingFilterName,0);	
	sLoadBearingFilter.setDescription(T("|Defines wether wall elements are filtered by their laod bearing property|"));
	sLoadBearingFilter.setCategory(sCategoryFilter);	


// build arrays from semicolon seperated lists
	String  sCodes[0],sElementFilters[0];
	String sList = sElementFilter;
	while (sList.length()>0 || sList.find(";",0)>-1)
	{
		String sToken = sList.token(0);	
		sToken.trimLeft().trimRight();
		sToken.makeUpper();	
	// make sure no numbers can be used	
		int bOk=true;
		for(int i=0;i<sNums.length();i++)
			if (sToken.find(sNums[i],0)>-1)
			{
				bOk=false;
				break;
			}
	// test token against predfined element type key or ensure that a valid code with one or two characters is specified
		if (sElementTypes2.find(sToken)>-1 && sElementFilters.find(sToken)<0 && bOk)
			sElementFilters.append(sToken);
		else if (sToken.length()<3 && sCodes.find(sToken)<0 && bOk)
			sCodes.append(sToken);

		int x = sList.find(";",0);
		sList.delete(0,x+1);
		sList.trimLeft();	
		if (x==-1)	sList = "";	
	}

// get enum of filter properties
	int nExposedFilter= sExposedFilters.find(sExposedFilter)-1;// -1 = disabled, 0 = interior, 1 = exterior
	int nLoadBearingFilter = sLoadBearingFilters.find(sLoadBearingFilter)-1;// -1 = disabled, 0 = non load beraing, 1 = load bearing

//End // global variables//endregion 

//region General all types
// declare display	
	Display dp(nToolIndex);
		
// dummy flag
	int bIsDummy = _Map.getInt("isDummy");	

// validate
	if (_Element.length() < 1 && !bIsDummy)
	{
		eraseInstance();
		return;
	}

// standards
	Element el;
	CoordSys cs;
	Point3d ptOrg;	
	Vector3d vecX,vecY,vecZ;	
	ElemZone ez;
	if (_Element.length() >0)
	{
		el = _Element[0];
		cs = el.coordSys();
		ptOrg = cs.ptOrg();
		_Pt0 = el.zone(nZone).ptOrg();
		vecX=cs.vecX();
		vecY=cs.vecY();
		vecZ=cs.vecZ();
		
		vecX.vis(ptOrg, 1);
		vecY.vis(ptOrg, 3);
		vecZ.vis(ptOrg, 150);	
		
		ez = el.zone(nZone);
		_ThisInst.setColor(nMode);	
		setDependencyOnEntity(el);
		assignToElementGroup(el,true,nZone,'E');
	}
	/*else
	{
		reportMessage("\n"+ scriptName() + " " +T("|No valid element found.|"));
		eraseInstance();
		return;	
	}*/

// declare variables used often with pp's
	
	PLine plRings[0];
	int bIsOp[0];		

// query the element
	GenBeam gbAll[0];
	GenBeam gbThis[0];
	GenBeam gbOther[0];	
	Body bdAlls[0], thisBodies[0], otherBodies[0];
	PlaneProfile ppThis[0], ppOther,ppSaw;
	
	Beam bmFrame[0];
	Body frameBodies[0];
	Point3d ptZFrames[0]; // a collection of points which will help us to detect  a proper contact zone
	int nSgn = abs(nZone)/nZone;
		
	if(el.bIsValid())
	{
	// test wall codes
		if (!bIsDummy && el.bIsKindOf(ElementWall()) && sCodes.length()>0 && sCodes.find(el.code())<0)
		{
			reportMessage("\n" + T("|Wall Code does not match.|"));
			eraseInstance();
			return;
		}
	// load bearing
		if (!bIsDummy && el.bIsKindOf(ElementWallSF()) && nLoadBearingFilter>-1 && ((ElementWallSF)el).loadBearing()!=nLoadBearingFilter)
		{		
			reportMessage("\n" + T("|Load bearing property does not match.|"));
			eraseInstance();
			return;
		}		
	// interior/exterior
		if (!bIsDummy && el.bIsKindOf(ElementWall()) && nExposedFilter>-1 && ((ElementWall)el).exposed()!=nExposedFilter)
		{		
			reportMessage("\n" + T("|Exposed property does not match.|"));
			eraseInstance();
			return;
		}	
		
		
		Vector3d vecZZone = el.zone(nZone).vecZ();		
		

	// zone offset
		double dZoneOffset;
		for (int i=1; i<abs(nZone); i++) 
		{
			int z = nSgn*i;
			dZoneOffset+=el.zone(z).dH();
		}

		
	// remove existing nail lines
		if (bDebug || _bOnDbCreated)
		{
			NailLine nlOld[] = el.nailLine(nZone);
			for (int n=0; n<nlOld.length(); n++) 
			{
				NailLine nl = nlOld[n];
				//int nCol = nl.color();
				//if (nl.color()==nToolIndex)
					nl.dbErase();
			}		
		}
		
		
		
	// get all genBeams
		gbAll = el.genBeam();
		
		
	// defined properties
		String m2 = sIncludeMaterial.makeUpper();	
		String m3 = sIncludeMaterialContact.makeUpper();
		
		String sExclusiveNames[0]; 
		if (mapMaterials.hasMap(m2))
		{ 
			Map mapExclusives = mapMaterials.getMap(m2).getMap("ExclusiveName[]");
			for (int i=0;i<mapExclusives.length();i++) 
				sExclusiveNames.append(mapExclusives.getString(i).makeUpper());	
		}
	
		
	// query all nailing zones
		for (int g=0 ; g<gbAll.length();g++)
		{
			GenBeam gb = gbAll[g];
		
			int z = gb.myZoneIndex();
			int c = gb.color();
			String m = gb.material().makeUpper();		
		
			Body bd;
			
			int bIsSheetToNailOn = z == nZone && nMode == 3;
			
			if (bIsSheetToNailOn)
			{
				bd=gb.envelopeBody(false, true);
				
						
			// add openings
				if (z==nZone && nMode==3)
				{ 
					PLine plOpenings[] = ((Sheet)gb).plOpenings();
					for (int j=0;j<plOpenings.length();j++) 
					{ 
						bd.subPart(Body(plOpenings[j], el.vecZ()*U(10e3),0)); 
						 
					}//next j
					bd.vis(4);
				}	
				
			}
			else
				bd= gb.realBody();
			bdAlls.append(bd);			

		// declare a potential conversion genBeam
			GenBeam gbConvert;	Body bdConvert;

		// skip//append to frame	
			if (z==0 && gb.bIsKindOf(Beam()) && !gb.bIsDummy())	
			{
			// detect potential lath assigned to zone 0, but placed in contact zone
				if (nMode==2 && m==m3 && bConvertSheet && abs(nZone)==1) //HSB-16861 && bConvertSheet && abs(nZone)==1
				{
					PlaneProfile ppX = bd.extractContactFaceInPlane(Plane(el.zone(nZone).ptOrg(),vecZZone),dZoneOffset);	
					ppX.vis(2);
					if (ppX.area()>pow(dEps,2))
					{
						gbConvert=gb;
						bdConvert=bd;
						gbConvert.assignToElementGroup(el,true,(nZone-nSgn),'Z');
					}
				}
				else
				{
					if (m3.length()>0 && m3!=m){continue;}
					if (c>0 && c==nExcludeColorContact) {continue;}				
					bmFrame.append((Beam)gb);
					frameBodies.append(bd);
					//bd.vis(2);
				// use only vertical beams to avoid risk to use additional horizontal or sloped beams which might be offseted to zone (Lux) Version 3.2
					if (bmFrame[bmFrame.length()-1].vecX().isParallelTo(vecY))
						ptZFrames.append(bd.extremeVertices(vecZ));
				}
			}
		// get this zone
			else if (z==nZone)
			{
				if (m2.length()>0 && m2!=m){continue;}
				if (c>0 && c==nExcludeColor) {continue;}
				
			// HSBCAD-4862 test exclusive names if present
			// exclusive names can be specified in an external settings file	
				if (sExclusiveNames.length() > 0 && sExclusiveNames.find(gb.name().makeUpper())<0)
				{
						continue;
				}				
				
				gbThis.append(gb);
				thisBodies.append(bd);
				
				//bd.vis(5);
				//gb.realBody().vis(6);
			}
		// collect others
			else if (abs(nZone)>1 && (z!=0 && abs(z)/z==nSgn)&& (nSgn*(nZone-z)>0 || (z!=0 && nMode==2)))//
			{
				//if(bDebug)reportMessage("\n others z: "+ z + " sgn " + nSgn + " zone: " +nZone);

				if (m3.length()>0 && m3!=m){continue;}
				if (c>0 && c==nExcludeColorContact) {continue;}		
				
			// in 'on lath' mode convert potential laths which are defined as beams into sheets
				if (nMode == 2 && gb.bIsKindOf(Beam()))
				{
					gbConvert=gb;
					bdConvert=bd;
				}	
			// append to contact zone genbeams					
				else
				{
					gbOther.append(gb);	
					otherBodies.append(bd);	
					//bd.vis(2);
				}						
			}
			
		// convert potential
		// in 'on lath' mode convert potential laths which are defined as beams into sheets
			if (nMode == 2 && gbConvert.bIsValid() && bConvertSheet)
			{
				gb = gbConvert;
				Sheet sh;
				PlaneProfile ppSh(CoordSys(gb.ptCen(),gb.vecX().crossProduct(-vecZZone),gb.vecX(), vecZZone));
				
				PlaneProfile pp0= gb.realBody().shadowProfile(Plane(gb.ptCen(),vecZZone));
				plRings=pp0.allRings();
				bIsOp=pp0.ringIsOpening();
				for (int r=0;r<plRings.length();r++)
					if (!bIsOp[r])
						ppSh.joinRing(plRings[r],_kAdd);
				for (int r=0;r<plRings.length();r++)
					if (bIsOp[r])
						ppSh.joinRing(plRings[r],_kSubtract);
				sh.dbCreate(ppSh,gb.dD(vecZZone),0);
				sh.assignToGroups(gb);
				sh.setMaterial(m);
				sh.setColor(c);
				gb.dbErase();
				gb=sh;
				
				gbOther.append(gb);
				otherBodies.append(bd);
			}			
		}
		
	// create pp's

	// loop both zones
		GenBeam gbX[0];
		gbX =gbOther ;
		Body xBodies[0];xBodies=otherBodies;
		Point3d ptZone = el.zone(nZone-nSgn).ptOrg();ptZone.vis(8);
		if (nZone==1)ptZone=ptOrg;
		
		Plane pn(ptZone , el.zone(nZone-nSgn).vecZ());
		pn.vis(2);
		double dMergeX= dEps*5;
		
		if (nMode!=5)
			for (int i=0 ; i<2;i++)
			{
				PlaneProfile ppX;			
			// loop genbeams	
				for (int g=0 ; g<gbX.length();g++)
				{
					Body bd = xBodies[g];
					PlaneProfile pp = bd.shadowProfile(pn);

					GenBeam gb = gbX[g];
					int z = gb.myZoneIndex();
	
					//if(0){PlaneProfile ppD=pp;ppD.transformBy(vecZZone* U(300)); ppD.vis(2);}
				// merge other zone, merge this only if selected
					if (i==0 || dMergeX>dEps*5)
					{
						pp.shrink(-dMergeX);
						if (ppX.area()<pow(dEps,2))
							ppX=pp;
						else
							ppX.unionWith(pp);
					}
				// append this if not merged
					else
					{
						ppThis.append(pp);	
						//pp.vis(7);
					}
				}
				
			// shrink to merge
				if (i==0 || dMergeX>dEps*5) 
				{
					if (i==1) ppThis.append(ppX);
					ppX.shrink(dMergeX);
				}
				if (i==0) 
				{
					ppOther =ppX;
				}
		
			// merge factor	
				if (dMerge>dEps)dMergeX=dMerge;
				
			// next zone	
				gbX = gbThis;
				xBodies=thisBodies;
				pn=Plane(el.zone(nZone).ptOrg(), el.zone(nZone).vecZ());	

			}	
		
		

		
		ppSaw=PlaneProfile(CoordSys(ez.ptOrg(), vecX, vecX.crossProduct(-ez.vecZ()), ez.vecZ()));	
		
	// no nail dimensions
		double dYSaw = U(14);
		double dXFactorSaw = 2;
		

	// collect sawline tools
		Map mapSawTools;
		Entity entsTool[0];
		if (_bOnDbCreated || _bOnElementConstructed || _bOnRecalc)//)|| _bOnDebug)
		{ 
		// collect any element saw of the selected zone
		// set export flags to collect cnc saw lines
			ModelMapComposeSettings mmFlags;
			mmFlags.addElemToolInfo(TRUE); // default FALSE
			
			// compose ModelMap
			ModelMap mm;
			Entity entsElem[]=el.elementGroup().collectEntities(true,Entity(),_kModelSpace);
			mm.setEntities(entsElem);
			mm.dbComposeMap(mmFlags);
			Map mapModel = mm.map().getMap("Model");			
			//mapModel.writeToDxxFile(_kPathDwg+"\\mapModel.dxx");
			
			for (int i=0;i<mapModel.length();i++)
			{
				String sKey =mapModel.keyAt(i).makeUpper(); 
				if (sKey=="SAWLINE")
				{
					Map mapSaw = mapModel.getMap(i);
					mapSawTools.appendMap("Saw",mapSaw );	
					entsTool.append(mapSaw.getEntity("TOOLENT"));
				}	
			}
			
			Map mapElemTools = mapModel.getMap("ELEMENTWALLSF\\ELEMENTWALL\\ELEMENT\\ELEMTOOLS");
			for (int i=0;i<mapElemTools.length();i++)
			{
				String sKey =mapElemTools.keyAt(i).makeUpper(); 
				if (sKey=="ELEMENTSAW")
				{
					Map mapSaw = mapElemTools.getMap(i);
					mapSawTools.appendMap("Saw",mapSaw );	
					entsTool.append(mapSaw.getEntity("TOOLENT"));
				}	
			}	
			reportMessage("\n" + mapSawTools.length() + T(" |sawlines collectded|"));
			_Map.setMap("SawTool[]", mapSawTools);
			
		}
		else
		{ 
			mapSawTools = _Map.getMap("SawTool[]");
		}

	
	// loop collected sawlines
		for (int i=0;i<mapSawTools.length();i++)
		{
			Map mapSaw = mapSawTools.getMap(i);
			int nZoneIndex = mapSaw.getInt("zoneIndex");
		// validate zone index	
			if (nZoneIndex ==nZone)
			{
				//int bOverShoot = mapSaw.getInt("overShoot");
				
				PLine plPath = mapSaw.getPLine("plPath");
				Point3d pts[] = plPath.vertexPoints(true);
				for (int p=0;p<pts.length()-1;p++)
				{
					Point3d pt1 = pts[p];
					Point3d pt2 = pts[p+1];	
					Vector3d vecXSeg = pt2-pt1;
					vecXSeg.normalize();
					Vector3d vecYSeg = vecXSeg.crossProduct(-ez.vecZ());
					pt1.transformBy(-vecXSeg*dXFactorSaw*ez.dH()+vecYSeg*dYSaw );
					pt2.transformBy(vecXSeg*dXFactorSaw*ez.dH()-vecYSeg*dYSaw );
					
					PLine plRec;
					plRec.createRectangle(LineSeg(pt1,pt2),vecXSeg,vecYSeg);	
					//plRec.vis(4);
					ppSaw.joinRing(plRec,_kAdd);				
				}				
			}
								
		}
		//ppSaw.vis(211);		
	// append collected toolents to _Entity and set dependecies
//		_Entity.append(entsTool);
//		for (int i=0;i<_Entity.length();i++)
//			setDependencyOnEntity(_Entity[i]);
			
	}// END IF valid element


// declare nailing segments
	LineSeg segNails[0];	
	
	
	
// query first citizien tsl's which might have a no nail definition
	TslInst tsls[] = el.tslInstAttached();
	PlaneProfile ppNoNail;
	for (int i=0;i<tsls.length();i++) 
	{ 
		TslInst& tsl= tsls[i]; 
		if ( ! tsl.bIsValid() || tsl == _ThisInst)continue;
		
		Map mapNoNails = tsl.subMapX("NoNailProfile[]");
		if (mapNoNails.hasPlaneProfile("Zone" + nZone))
		{
			PlaneProfile pp = mapNoNails.getPlaneProfile("Zone" + nZone);
			if (ppNoNail.area()<pow(dEps,2))
				ppNoNail = pp;
			else
				ppNoNail.unionWith(pp);
		}	 
	}
	if (ppNoNail.area()>pow(dEps,2))
	{
		ppNoNail.vis(4);
		if (ppSaw.area()<pow(dEps,2))
			ppSaw = ppNoNail;
		else
			ppSaw.unionWith(ppNoNail);		
	}	
	
	
	
	
	
	
	
	
	
//End General all types//endregion 


//End Part 1______________________________________________________________________//endregion 

//region 2 = nail on laths
	if (nMode==2)
	{	
	// zone
		nZone=PropInt (0,nZones,sZoneName);
		nZone.setCategory(sCategoryNailing);
		
	// toolindex	
		nToolIndex=PropInt (1,1, sToolIndexName);
		nToolIndex.setCategory(sCategoryNailing);
		
	// spacing
		dSpacing=PropDouble (0,U(50), sSpacingName);
		dSpacing.setDescription(sSpacingDescription)	;
		dSpacing.setCategory(sCategoryNailing);
		
	// merge
		dMerge=PropDouble (3,0, sMergeName);
		dMerge.setDescription(sMergeDescription);
		dMerge.setCategory(sCategoryNailing);
		
	// edgeoffset side
		PropDouble dEdgeOffsetSide(1,U(20), sEdgeOffsetSideName);
		dEdgeOffsetSide.setDescription(sEdgeOffsetSideDescription);
		dEdgeOffsetSide.setCategory(sCategoryNailing);	
		dCombineLength = dEdgeOffsetSide;	
		
	// edge offset x
		PropDouble dEdgeOffsetX(2,U(20), sEdgeOffsetXName);
		dEdgeOffsetX.setDescription(sEdgeOffsetXDescription);
		dEdgeOffsetX.setCategory(sCategoryNailing);
	
		PropDouble dEdgeOffsetBeam(4,U(5), sEdgeOffsetBeamName);
		dEdgeOffsetBeam.setDescription(EdgeOffsetBeamDescription);	
		dEdgeOffsetBeam.setCategory(sCategoryNailing);	

// loose sheets		
		String sCategoryLooseSheets=T("|Nailing on loose sheeting edges|");
		
		PropDouble dMaxEdgeOffsetVertical (5,U(50), T("|Max. Offset Vertical Nailline|"));
		dMaxEdgeOffsetVertical .setDescription(T("|Defines max offset which a vertical nailline may have to the corresponding sheeting edge.|") + " " + 
			T("|If the offset is greater than the given offset an additional vertical nailline will potentially created to nail on the underlaying zone.|"));	
		dMaxEdgeOffsetVertical.setCategory(sCategoryLooseSheets);
			
		PropDouble dLooseEdgeOffsetVertical (6,U(50), sEdgeOffsetSideName + " " + T("|loose Edge|"));
		dLooseEdgeOffsetVertical .setDescription(sEdgeOffsetSideDescription);				
		dLooseEdgeOffsetVertical .setCategory(sCategoryLooseSheets);			
				
		setOPMKey(sOpmModes[nMode]);
		if (bIsDummy)return;

	// zone vec
		Vector3d vecZZone = el.zone(nZone).vecZ();
		ppOther.vis(252);

	// visualize this zone pp
		for (int i=0 ; i<ppThis.length();i++)	
		{
			Point3d ptsThis[0];
			
			ppThis[i].shrink(-dEps);
			ppThis[i].shrink(dEps+dEdgeOffsetSide);			
			ppThis[i].vis(6);

		// collect zone points and edge segments
			LineSeg segEdges[0];
			plRings=ppThis[i].allRings();
			bIsOp=ppThis[i].ringIsOpening();
			for (int r=0; r<plRings.length(); r++)
			{
				if (bIsOp[r])continue;		
				Point3d pts[]=plRings[r].vertexPoints(false);
				ptsThis.append(pts);
				ptsThis.removeAt(ptsThis.length()-1);
				
				// collect edge segments for loose edge nailings
				if (dLooseEdgeOffsetVertical>dEps)
					for (int p=0; p<pts.length()-1; p++)
					{
						Vector3d vecXSeg = pts[p]-pts[p+1] ;
						if (!vecXSeg.isParallelTo(vecY))continue;						
						segEdges.append(LineSeg(pts[p],pts[p+1]));
					}
			}
			
			if (bDebug)
				for (int p=0; p<segEdges.length(); p++)
					segEdges[p].vis(p);

		// declare a framing pp
			PlaneProfile ppFrame;

		// extract the contact face in plane for every framing beam
			for (int b=0;b<gbOther.length();b++)
			{
				Vector3d vecXThis = gbOther[b].vecX();
				double dX = gbOther[b].solidLength()-(dEdgeOffsetX-dEdgeOffsetBeam)*2;
				double dY = gbOther[b].solidWidth();
				double dZ = gbOther[b].solidHeight();
				Body bd(gbOther[b].ptCen(),vecXThis ,gbOther[b].vecY(),gbOther[b].vecZ(),dX,dY,dZ,0,0,0);
				//bd.vis(2);bmFrame[b].realBody().vis(3);
				
				PlaneProfile pp = gbOther[b].realBody().shadowProfile(Plane(ptOrg,vecZ));
				pp.intersectWith(bd.shadowProfile(Plane(ptOrg,vecZ)));
				pp.vis(2);
				
			// collect frame pp
				PlaneProfile ppBm=pp;
				ppBm.shrink(-dEps);
				if (ppFrame.area()<pow(dEps,2))
					ppFrame = ppBm;
				else
					ppFrame.unionWith(ppBm);					
				
				
				pp.shrink(dEdgeOffsetBeam);				//pp.vis(20);
				
				pp.intersectWith(ppThis[i]);				//pp.vis(1);	
				
			// get all rings
				plRings=pp.allRings();
				bIsOp=pp.ringIsOpening();
				for (int r=0; r<plRings.length(); r++)
				{
					if (bIsOp[r])continue;
					pp= PlaneProfile(plRings[r]);	
					LineSeg ls =pp.extentInDir(gbOther[b].vecX());					
					Point3d ptInt[] = plRings[r].intersectPoints(Plane(ls.ptMid(),vecXThis.crossProduct(vecZ)));
					if (ptInt.length()>0)
					{
						segNails.append(LineSeg(ptInt[0],ptInt[ptInt.length()-1]));
						segNails[segNails.length()-1].vis(5); 
					}
				}// next r				
			}// next b

		// the frame pp
			ppFrame.shrink(dEps);
			//ppFrame.vis(20);
			
			// remove all edges which are inside the frame pp
			for (int s=segEdges.length()-1; s>=0; s--)
			{
	
			// create a small pp which will be united with the frame pp, if the amount of resultimg rings is >1 it is considered to be kept 	
				Vector3d vecXSeg= segEdges[s].ptEnd()- segEdges[s].ptStart();
				vecXSeg.normalize();
				Vector3d vecYSeg = vecXSeg.crossProduct(-vecZZone);
				PLine plTest;
				plTest.createRectangle(LineSeg(segEdges[s].ptStart()-vecYSeg*dEps,segEdges[s].ptEnd()+vecYSeg*dEps),vecXSeg,vecYSeg);
				PlaneProfile ppTest(plTest);
				ppTest.intersectWith(ppFrame);
				if (ppTest.allRings().length()<2 && 
					ppFrame.pointInProfile(segEdges[s].ptStart())==_kPointInProfile &&
					ppFrame.pointInProfile(segEdges[s].ptEnd())==_kPointInProfile)
				{
					segEdges.removeAt(s);
					continue;
				}

				segEdges[s].transformBy(vecYSeg*(dLooseEdgeOffsetVertical-dEdgeOffsetSide));
				
			// append this segment only if it is not parallel or closed to another
				int bOk=true;
				for (int x=0;x<segNails.length();x++)
				{
					segEdges[s].transformBy(vecZ*vecZ.dotProduct(segNails[x].ptMid()-segEdges[s].ptMid()));
					//segEdges[s].vis(s);
					//segNails[x].vis(x);
					Vector3d vecXNail = segNails[x].ptEnd()-segNails[x].ptStart();
					if (segEdges[s].distanceTo(segNails[x])<dEps && vecXNail.isParallelTo(vecXSeg))
					{
						bOk=false;
						break;
					}
				}
				if(bOk)
				{
					segNails.append(segEdges[s]);
					vecYSeg.vis(segEdges[s].ptMid(),3);
				}			
			}		
		}// next i
	}
//End 2 = nail on laths//endregion 

//region 3 = nail on sheetings
	else if (nMode==3)
	{
	// zone
		nZone=PropInt (0,nZones,sZoneName);
		nZone.setCategory(sCategoryNailing);
		
	// toolindex	
		nToolIndex=PropInt (1,1, sToolIndexName);
		nToolIndex.setCategory(sCategoryNailing);
		
	// spacing
		dSpacing=PropDouble (0,U(50), sSpacingName);
		dSpacing.setDescription(sSpacingDescription)	;
		dSpacing.setCategory(sCategoryNailing);
		
	// merge
		dMerge=PropDouble (3,0, sMergeName);
		dMerge.setDescription(sMergeDescription);
		dMerge.setCategory(sCategoryNailing);
		
	// edgeoffset side
		PropDouble dEdgeOffsetSide(1,U(20), T("|Offset Sheeting Edge|"));
		dEdgeOffsetSide.setDescription(T("|Defines the edge offset from the sheeting zone|"));
		dEdgeOffsetSide.setCategory(sCategoryNailing);	
		dCombineLength = dEdgeOffsetSide;	
			
	// edge offset x
		PropDouble dEdgeOffsetX(2,U(20), T("|Edge Offset Bottom|"));
		dEdgeOffsetX.setDescription(T("|Defines the offset of an edge pointing downwards|"));
		dEdgeOffsetX.setCategory(sCategoryNailing);

		PropDouble dEdgeOffset_X(5,U(20), T("|Edge Offset Top|"));//+ " " + T("|Default|"));
		dEdgeOffset_X.setDescription(T("|Defines the offset of an edge pointing upwards|"));
		dEdgeOffset_X.setCategory(sCategoryNailing);

	// merge
		PropDouble dMergeContact(4,0, sMergeName+" ");
		dMergeContact.setDescription(sMergeDescription);
		dMergeContact.setCategory(sCategoryContactZone);
	
		PropDouble dEdgeOffsetContactSheet(7,U(5),sEdgeOffsetContactSheetName);
		dEdgeOffsetContactSheet.setDescription(T("|Specifies the edge offset of the contacting zone|"));	
		dEdgeOffsetContactSheet.setCategory(sCategoryContactZone);			

		PropString sOrientation(2,sOrienations, T("|Distribution Type|"),1);	
		sOrientation.setDescription(T("|The orientation of intermediate naillines|"));
		sOrientation.setCategory(sCategoryNailing);	
		
		
		PropDouble dNailModule(6,U(410),T("|Module|"));	
		dNailModule.setDescription(T("|The maximal offset of intermediate naillines|"));	
		dNailModule.setCategory(sCategoryNailing);	
				
		setOPMKey(sOpmModes[nMode]);
		if (bIsDummy)return;		

	// add subtraction area trigger
		String sTriggerSubtract = T("|Subtract Polyline|");
		addRecalcTrigger(_kContext, sTriggerSubtract );
		if (_bOnRecalc && _kExecuteKey==sTriggerSubtract ) 
		{
			EntPLine epl = getEntPLine();
			epl.assignToElementGroup(el,nZone,0,'T');
			_Entity.append(epl);
		}
		
	// collect subtraction areas from entity array
		PLine plSubtracts[0];
		for (int i=0;i<_Entity.length();i++)
		{
			Entity ent = _Entity[i];
			setDependencyOnEntity(ent);
			if (ent.bIsKindOf(EntPLine()))
			{
				EntPLine epl = (EntPLine)ent;
				plSubtracts.append(epl.getPLine());
			}	
		}	

	// subtract from all profiles
		for (int j=0;j<plSubtracts.length();j++)
			for (int i=0 ; i<ppThis.length();i++)
				ppThis[i].joinRing(plSubtracts[j], _kSubtract);

	// flag if edge offset can be performed by shrink instead of segment wise offset
		int bDoShrink = (dEdgeOffsetSide==dEdgeOffsetX && dEdgeOffsetX==dEdgeOffset_X);

	// zone vec
		Vector3d vecZZone = el.zone(nZone).vecZ();

	// ints
		int nOrientation =sOrienations.find(sOrientation,0);
		Vector3d vecArOrientation[]= {el.vecY(),el.vecX(),el.vecY(),el.vecX()};
		Vector3d vecO=vecArOrientation[nOrientation];	

	// merge contacting zone if specified
		if (dMergeContact>dEps)
		{			
			ppOther.shrink(-dMergeContact);
			ppOther.shrink(dMergeContact);
		}
		ppOther.shrink(dEdgeOffsetContactSheet);
		//ppOther.vis(6);
		
	// loop all tool profiles
		for (int i=0 ; i<ppThis.length();i++)	
		{
			PlaneProfile pp = ppThis[i];	
			
		// clear nearby vertices 
			pp.shrink(-dEps);
			pp.shrink(2*dEps);				
			pp.shrink(-dEps);	
			//pp.vis(20);
			
		// calculate offsetted profile
			// all edge offset parameters are identical: using shrink allows the removal of redundant segments
			if (bDoShrink)
			{
				pp.shrink(dEdgeOffsetSide);
			}
			// parameters vary, may result in wrong offsets for complexe profiles. if this happens user should use profile modificators by context command
			else
			{	
			// offset bottom and top edges
				plRings = pp.allRings();
				bIsOp = pp.ringIsOpening();
				
				
			// rebuild the profile without openings as the bottom and top parameters should only affect the contour
				pp.removeAllRings();
				PLine plTempOpenings[0];
				for (int r=0; r<plRings.length(); r++)	
				{
					if(!bIsOp[r])
						pp.joinRing(plRings[r],_kAdd);
					else
					{
						PlaneProfile ppOpening(plRings[r]);
						ppOpening.shrink(-dEdgeOffsetSide);
						PLine plRings2[] = ppOpening.allRings();
						int bIsOp2[] = ppOpening.ringIsOpening();
						for (int r2=0;r2<plRings2.length();r2++)
							if (!bIsOp2[r2])
								plTempOpenings.append(plRings2[r2]);
					}
				}
				pp.vis(171);
			// collect midpoints
				Point3d ptsMid[] = pp.getGripEdgeMidPoints();				
				Point3d ptMid = pp.extentInDir(vecX).ptMid();
				//reportNotice("\n	pp has rings: " + plRings .length() + " and " + ptsMid.length() + " midpoints");
				for (int r=0; r<plRings.length(); r++)
				{
					if(bIsOp[r])continue;
					
				// vertices
					Point3d pts[] = plRings[r].vertexPoints(false);
					for (int p=0; p<pts.length()-1; p++)
					{
						Vector3d vecXSeg = pts[p+1]-pts[p];
						LineSeg ls(pts[p],pts[p+1]);
						vecXSeg.normalize();
						Vector3d vecYSeg = vecXSeg.crossProduct(vecZZone);
						if (pp.pointInProfile(ls.ptMid()+vecYSeg*dEps)!=_kPointOutsideProfile)
							vecYSeg*=-1;				
						//vecYSeg.vis(ls.ptMid(),3);
						
						int nInd = -1;
						double dDistMin = 0;
						for (int q=0; q<ptsMid.length(); q++) 
						{
							Point3d pt = ptsMid[q];//pt.vis();
							double dDist = Vector3d(ls.ptMid()-pt).length();
							if (q==0 || dDist<dDistMin) 
							{
								dDistMin = dDist;
								nInd = q;
							}
						}
						// move a grip point with a vector towards ls.ptMid()
						if (nInd>=0)
						{
							Point3d pt = ptsMid[nInd];
							double dMove = dEdgeOffsetSide;// init with side Offset
							int c=1;
							
							double dMidRelation = vecYSeg.dotProduct(pt-ptMid);
						// Edge Offset Bottom
							if (-vecYSeg.isCodirectionalTo(vecY) && dMidRelation <0)
							{
								dMove = dEdgeOffsetX;
								c=2;
							}
						// Edge Offset Top
							else if (vecYSeg.isCodirectionalTo(vecY)&& dMidRelation >0)
							{
								dMove = dEdgeOffset_X;
								c=3;
							}
//						// vertical edge offset
//							else if (vecYSeg.isParallelTo(vecX))
//							{
//								dMove = dEdgeOffsetSide;
//								c=3;
//							}
							//vecYSeg.vis(pt,c);

							int bOk=false;
							if(pp.pointInProfile(pt)!=_kPointOutsideProfile)
							{
								pt.vis(p);
								bOk=true;
								pp.moveGripEdgeMidPointAt(nInd, -vecYSeg*dMove);
							}
								
						
						// test if moving the segment was successful
							if(pp.pointInProfile(pt)!=_kPointOutsideProfile)
							{
								bOk=false;

								PLine pl;
								pl.createRectangle(LineSeg(pt-vecXSeg*U(10e4),pt+vecXSeg*U(10e4)-vecYSeg*dMove), vecXSeg, vecYSeg);
								//pl.vis(c);
								pp.joinRing(pl,_kSubtract);
							}
							pp.vis(5);
							//pt.vis(bOk);					
						}
				
					}// next p point of ring vertex
				}// next r
				//pp.vis(123);
				
			// subtract temp opening rings
				for (int r=0; r<plTempOpenings.length(); r++)	
					pp.joinRing(plTempOpenings[r], _kSubtract);
				
				
			}// END IF !doShrink: offset by segment offset
			//pp.transformBy(vecZ*U(2000));
			//pp.vis(2);			
			//pp.transformBy(vecZ*-U(2000));	
	


		// get intersection and all rings
			pp.intersectWith(ppOther);	
			pp.vis(2);		
			plRings=pp.allRings();
			bIsOp=pp.ringIsOpening();
			
		// convert to straight segments
			for (int r=0; r<plRings.length(); r++)
			{
				//if (bIsOp[r])
				plRings[r].vis(4);
				PLine pl = plRings[r];
				pl.convertToLineApprox(U(dSpacing/2));
				Point3d pts[0];
				pts = pl.vertexPoints(false);
				for (int p=0; p<pts .length()-1; p++)
				{
					LineSeg seg(pts[p],pts[p+1]); seg.vis(p);
					segNails.append(seg);
				}
			}
					
		// collect distributed nail segments by module
			LineSeg ls=pp.extentInDir(vecX);
			double dRange = abs(vecO.dotProduct(ls.ptStart()-ls.ptEnd()));	
			if (dRange>dNailModule)
			{
			// distribute
				int n=dRange/dNailModule;
				double d=dRange/(n+1);
				if (nOrientation>1)d=dNailModule;
				//ls.vis(2);	
				Point3d pt = ls.ptMid()-.5*vecO*dRange;
				for (int p=0; p<n; p++)
				{
					pt.transformBy(vecO*d);
					//pt.vis(p);	
				// get intersecting points
					Point3d ptInt[0];
					for (int r=0; r<plRings.length(); r++)
					{
						//plRings[r].vis(r);
						ptInt.append(plRings[r].intersectPoints(Plane(pt,vecO )));
					}
					ptInt = Line(pt,vecO.crossProduct(vecZ)).orderPoints(ptInt);	
					for (int q=0; q<ptInt.length()/2; q++)
					{
						int x = q*2;
						LineSeg seg(ptInt[x],ptInt[x+1]); seg.vis(6);
						segNails.append(seg);
					}
				}	
			}		
		}
	}// END IF 3 = nail on sheetings
		
//End 3 = nail on sheetings//endregion 

//region 4 = nail on studs
	else if (nMode==4)
	{
		int bDebugThis = false;

	// zone
		nZone=PropInt (0,nZones,sZoneName);
		nZone.setCategory(sCategoryNailing);
		
	// toolindex	
		nToolIndex=PropInt (1,1, sToolIndexName);
		nToolIndex.setCategory(sCategoryNailing);
		
	// spacing
		dSpacing=PropDouble (0,U(50), sSpacingName);
		dSpacing.setDescription(sSpacingDescription)	;
		dSpacing.setCategory(sCategoryNailing);
	
	// DISTRIBUTION	
	// merge
		dMerge=PropDouble (3,0, sMergeName);
		dMerge.setDescription(sMergeDescription);
		dMerge.setCategory(sCategoryDistribution);
		
	// edgeoffset side
		PropDouble dEdgeOffsetSide(1,U(20), sEdgeOffsetSideName);
		dEdgeOffsetSide.setDescription(sEdgeOffsetSideDescription);
		dEdgeOffsetSide.setCategory(sCategoryDistribution);	
		dCombineLength = dEdgeOffsetSide;	
					
	// edge offset x
		PropDouble dEdgeOffsetX(2,U(20), sEdgeOffsetXName);
		dEdgeOffsetX.setDescription(sEdgeOffsetXDescription);
		dEdgeOffsetX.setCategory(sCategoryDistribution);
	
		PropDouble dEdgeOffsetBeam(4,U(5), sEdgeOffsetBeamName);
		dEdgeOffsetBeam.setDescription(EdgeOffsetBeamDescription);	
		dEdgeOffsetBeam.setCategory(sCategoryDistribution);

	
// loose sheets		
		String sCategoryLooseSheets=T("|Nailing on loose sheeting edges|");

		PropDouble dMaxEdgeOffset(5,U(50), T("|Max. Offset Vertical Nailline|"));
		dMaxEdgeOffset .setDescription(T("|Defines max offset which a nailline may have to the corresponding sheeting edge.|") + " " + 
			T("|If the offset is greater than the given offset an additional nailline will potentially created to nail on the underlaying zone.|"));	
		dMaxEdgeOffset .setCategory(sCategoryLooseSheets);
		PropDouble dLooseEdgeOffset (6,U(50), sEdgeOffsetSideName + " " + T("|loose Edge|"));
		dLooseEdgeOffset.setDescription(sEdgeOffsetSideDescription);	
		dLooseEdgeOffset.setCategory(sCategoryLooseSheets);
		
		setOPMKey(sOpmModes[nMode]);
		if (bIsDummy)return;

	// zone vec
		ElemZone ez = el.zone(nZone);
		Vector3d vecZZone = ez.vecZ();

	// a point on the zones side on the surface of zone 0 
		Point3d ptFaceZone0 = el.ptOrg();
		if (nZone<0)ptFaceZone0.transformBy(-vecZ*el.dBeamWidth());
		ptFaceZone0.vis(4);
		Plane pn(ptFaceZone0,vecZZone );

	// loop sheeting pp's
		for (int i=0; i<ppThis.length();i++)	
		{
		// declare an array of nailing segments for this profile (sheet)	
			LineSeg segsThis[0];
			
			Point3d ptsThis[0];
		// clean up vertices and offset to max sheeting edge offset	
			PlaneProfile ppGros = ppThis[i];

			ppThis[i].shrink(-dEps);
			ppThis[i].shrink(dEps+dEdgeOffsetSide);

		// extract the contact face in plane for every framing beam
			for (int b=0;b<bmFrame.length();b++)
			{
			// a point on the surface of the beam seen in zone direction
				Point3d ptBeamFace = bmFrame[b].ptCen()+.5*bmFrame[b].vecD(vecZZone)*bmFrame[b].dD(vecZZone);
				if (abs(vecZ.dotProduct(ptBeamFace-ptFaceZone0))>dEps)continue;// ignore beams not making contact to the surface of zone 0 seen in zone direction
				//ptBeamFace.vis(6);
				
				if(bDebugThis)dp.draw(b,ptBeamFace,_XW,_YW,0,0,_kDevice);
				
				Vector3d vecXBm = bmFrame[b].vecX();
				Vector3d vecYBm = vecXBm.crossProduct(-vecZZone);
				Vector3d vecZBm = vecZZone;
				Line lnX(ptBeamFace ,vecXBm);
				
				double dX = bmFrame[b].solidLength()+dEdgeOffsetBeam*2;//-(dEdgeOffsetX-dEdgeOffsetBeam)*2;// subtract dEdgeOffsetBeam twice as the profile will be shrinked later on
				double dY = bmFrame[b].dD(vecYBm);
				double dZ = bmFrame[b].dD(vecZBm);
			
			// the offseted envelope body of the beam	
				Body bd(bmFrame[b].ptCen(),vecXBm,vecYBm,vecZBm,dX,dY,dZ,0,0,0);	//bd.vis(2); 		
				Body bdReal = bmFrame[b].realBody();//bdReal .vis(3);
			// the shadow of the real	
				PlaneProfile ppBm = bdReal.extractContactFaceInPlane(Plane(ptBeamFace,vecZZone),dEps);//shadowProfile(pn);
				//if(1){PlaneProfile ppD=ppBm ;ppD.transformBy(vecZZone* U(300)); ppD.vis(2);}
				ppBm.vis(b);
				
				if(ppBm.area()<pow(dEps,2))// fall back if extractInContactFace fails
				{
					ppBm = bdReal.shadowProfile(pn);
					ppBm.vis(2);
					bd.vis(b);
				}
		
		
			// the shadow of the envelope
				PlaneProfile ppEnv = bd.shadowProfile(pn);		
				ppEnv.shrink(dEdgeOffsetBeam);
				LineSeg seg = ppEnv.extentInDir(vecXBm);

			// get X-offseted seg
				Point3d pts[] = {seg.ptStart(), seg.ptEnd()};	
				Vector3d vecYSeg = vecYBm;
				pts=lnX.orderPoints(pts);
				if (pts.length()<2)continue;
				if (vecYSeg.dotProduct(seg.ptMid()-pts[0])<0)vecYSeg*=-1;
				pts[0].transformBy(vecXBm*(dEdgeOffsetX));
				pts[1].transformBy(-vecXBm*(dEdgeOffsetX));				

				PLine plRec;
				plRec.createRectangle(LineSeg(pts[0],pts[1]),vecXBm,vecYBm);//plRec.vis(2);
				ppEnv.intersectWith(PlaneProfile(plRec));
				ppEnv.vis(5);			

			// get intersecting pp
				ppEnv.intersectWith(ppBm);
				ppEnv.intersectWith(ppThis[i]);
				//ppGros.vis(252);
				//ppThis[i].vis(2);	
					
			// use the gros profile
				PlaneProfile ppGrosBm = ppGros;
				ppGrosBm.intersectWith(ppBm);// the gros intersection determines the axis of the nailline
				LineSeg segGros = ppGrosBm.extentInDir(vecXBm);
				Point3d ptMidGros =segGros.ptMid(); ppGrosBm.vis(40);
				//if(1){PlaneProfile ppD=ppGrosBm;ppD.transformBy(vecZZone* U(300)); ppD.vis(2);}
				//if(1){PlaneProfile ppD=ppEnv ;ppD.transformBy(vecZZone* U(300)); ppD.vis(b);}

							
			// the resulting pp of the merged declared with the beam coordSys
				PlaneProfile pp(CoordSys(ptBeamFace, vecXBm, vecYBm, vecZBm));	
				plRings = ppEnv.allRings();
				bIsOp = ppEnv.ringIsOpening();
				for (int r=0;r<plRings.length();r++)	
				{
					if(!bIsOp[r])	
					{
					// version  value="2.6" date="07feb14" author="th@hsbCAD.de"> mode Stud: Erkennung der Kontaktfläche verbessert für mehrfach unterbrochene Bereiche
						if (pp.area()<pow(dEps,2))
							pp = PlaneProfile(plRings[r]);
						else
							pp.joinRing(plRings[r],_kAdd);
					}
				}
				for (int r=0;r<plRings.length();r++)	
					if(bIsOp[r])	
						pp.joinRing(plRings[r],_kSubtract);
				if (pp.area()<pow(dEps,2))continue;
				//pp.vis(7);
				//if (b==6)dp.draw(pp,_kDrawFilled);
				
				
			// the contact face might result in rectangle shape (case 1) or it might well have some cut outs
			// and may appear in an L,C or any diverted shape (case 2). In these cases the program subtracts 
			// the bounding shape of the segemnts which could be attached to the center. The remaining rings
			// will be postprocessed to achieve nail lines being offseted to the center.
											
			// CASE 1: process all rings which create nailings (case 1)
				plRings=pp.allRings();
				bIsOp=pp.ringIsOpening();			
				for (int r=0; r<plRings.length(); r++)
				{
					if (bIsOp[r])continue;
					
					PlaneProfile ppR(plRings[r]);	
					LineSeg ls =ppR.extentInDir(vecXBm);
										
				// get intersecting points
					Point3d ptInt[]=plRings[r].intersectPoints(Plane(ls.ptMid(),vecYBm));
					ptInt= Line(ls.ptMid(),vecY).orderPoints(ptInt);	
					for (int q=0; q<ptInt.length()/2; q++)
					{
						int x = q*2;
						LineSeg lsThis(ptInt[x],ptInt[x+1]);
						lsThis.vis(q);
					// transform the segment to the center of the gros	
						if (ppEnv.pointInProfile(ptMidGros)==_kPointInProfile) // make sure ptMidGros is valid, case 150120
							lsThis.transformBy(vecYBm*vecYBm.dotProduct(ptMidGros-lsThis.ptMid()));
						if (0 && bDebugThis)
						{
							lsThis.transformBy(vecZ*U(500));
							//lsThis.vis(q);
							lsThis.transformBy(vecZ*-U(500));
						}
						segsThis.append(lsThis);
						
					// subtract this range from the contact face
						PLine plSeg; plSeg.createRectangle(LineSeg(ptInt[x]-.5*vecYBm*bmFrame[b].dD(vecYBm),ptInt[x+1]+.5*vecYBm*bmFrame[b].dD(vecYBm)),vecXBm,vecYBm);
						PlaneProfile ppSeg(plSeg);
						pp.subtractProfile(ppSeg);						
					}	
				}

			// CASE 2: nailed segments have been subtracted from the pp, postprocess all rings which remain			
				//pp.vis(60);
				plRings=pp.allRings();
				bIsOp=pp.ringIsOpening();			
				for (int r=0; r<plRings.length(); r++)
				{
					if (bIsOp[r])continue;
					
					pp= PlaneProfile(plRings[r]);	
					LineSeg ls =pp.extentInDir(vecXBm);
										
				// get intersecting points
					Point3d ptInt[]=plRings[r].intersectPoints(Plane(ls.ptMid(),vecYBm));
					ptInt= Line(ls.ptMid(),vecY).orderPoints(ptInt);	
					for (int q=0; q<ptInt.length()/2; q++)
					{
						LineSeg lsThis(ptInt[q*2],ptInt[q*2+1]);
						if (ppSaw.area()>pow(dEps,2))
							segsThis.append(ppSaw.splitSegments(lsThis,false));		
						else
							segsThis.append(lsThis);			
					}	
				}				
				
			}// next b // extract the contact face in plane for every framing beam


		// based on all nail segments create a protection area where other nail segments will be splitted
			PlaneProfile ppSplit(CoordSys(ez.ptOrg(), vecX, vecX.crossProduct(-ez.vecZ()), ez.vecZ()));
			for (int x=0;x<segsThis.length();x++)
			{
				LineSeg seg = segsThis[x];
				Point3d pt1 = seg.ptStart();
				Point3d pt2 = seg.ptEnd();	
				
				Vector3d vecXSeg = pt2-pt1;
				vecXSeg.normalize();
				Vector3d vecYSeg = vecXSeg.crossProduct(-ez.vecZ());
				pt1.transformBy(-vecXSeg*dEdgeOffsetX+vecYSeg*dMaxEdgeOffset );
				pt2.transformBy(vecXSeg*dEdgeOffsetX-vecYSeg*dMaxEdgeOffset );
				
				PLine plRec;
				plRec.createRectangle(LineSeg(pt1,pt2),vecXSeg,vecYSeg);	
				ppSplit.joinRing(plRec,_kAdd);					
			}
			//if (bDebug)
			//{
				//ppSplit.transformBy(vecZ*U(200));
				//ppSplit.vis(51);
				//ppSplit.transformBy(-vecZ*U(200));
			//}


		// edge segments
			if (dLooseEdgeOffset>dEps)
			{
				PlaneProfile ppEdge = ppGros;
				ppEdge.transformBy(vecZ*vecZ.dotProduct(ppSplit.coordSys().ptOrg()-ppEdge.coordSys().ptOrg()));//ppEdge .vis(3);
				ppEdge.shrink(dLooseEdgeOffset);//ppEdge .vis(2);
				
				LineSeg segEdges[0];
				plRings=ppEdge.allRings();
				bIsOp=ppEdge.ringIsOpening();
				
				for (int r=0; r<plRings.length(); r++)
				{
					PLine pl = plRings[r];
					Point3d pts[] = pl.vertexPoints(false);
					for (int p=0;p<pts.length()-1;p++)
					{
						Point3d pt1 = pts[p];
						Point3d pt2 = pts[p+1];
						Vector3d vecXSeg = pt2-pt1;
						vecXSeg.normalize();	
						LineSeg seg(pt1+vecXSeg*dEps,pt2-vecXSeg*dEps);			
						segEdges.append(seg);
					}
				}
				
				segEdges= ppSplit.splitSegments(segEdges,false);	
				segsThis.append(segEdges);	
				if (bDebugThis)
					for (int p=0;p<segEdges.length();p++)	
					{
						segEdges[p].transformBy(vecZ*U(200));
						segEdges[p].vis(2);
						segEdges[p].transformBy(-vecZ*U(200));					
					}
			}

			
		// append all segments of this profile(sheet)	
			segNails.append(segsThis);					
		}// next i ppThis
	}
// END 4 = nail on studs
//End 4 = nail on studs//endregion 

//region 5 = nail on stud grid
	else if (nMode==5)
	{
		int bDebugThis = false;

	// zone
		nZone=PropInt (0,nZones,sZoneName);
		nZone.setCategory(sCategoryNailing);
		
	// toolindex	
		nToolIndex=PropInt (1,1, sToolIndexName);
		nToolIndex.setCategory(sCategoryNailing);
		
	// spacing
		dSpacing=PropDouble (0,U(50), sSpacingName);
		dSpacing.setDescription(sSpacingDescription)	;
		dSpacing.setCategory(sCategoryNailing);
	
	// DISTRIBUTION	
	// merge
		dMerge=PropDouble (3,0, sMergeName);
		dMerge.setDescription(sMergeDescription);
		dMerge.setCategory(sCategoryDistribution);
		
	// edgeoffset side
		PropDouble dEdgeOffsetSide(1,U(20), sEdgeOffsetSideName);
		dEdgeOffsetSide.setDescription(sEdgeOffsetSideDescription);
		dEdgeOffsetSide.setCategory(sCategoryDistribution);	
		dCombineLength = dEdgeOffsetSide;	
		
	// edge offset x
		PropDouble dEdgeOffsetX(2,U(20), sEdgeOffsetXName);
		dEdgeOffsetX.setDescription(sEdgeOffsetXDescription);
		dEdgeOffsetX.setCategory(sCategoryDistribution);
	
		PropDouble dEdgeOffsetBeam(4,U(5), sEdgeOffsetBeamName);
		dEdgeOffsetBeam.setDescription(EdgeOffsetBeamDescription);	
		dEdgeOffsetBeam.setCategory(sCategoryDistribution);
	
		PropDouble dXGrid(7,0, sXGridName);
		dXGrid.setDescription(sXGridDescription);	
		dXGrid.setCategory(sCategoryDistribution);	

		
		setOPMKey(sOpmModes[nMode]);
		if (bIsDummy)return;

	// special custom behaviour
		int nSpecial;
		double dYBigBeam,dEdgeOffsetBigBeam;
		
		if (projectSpecial().makeUpper().find("LUX",0)>-1)
		{
			nSpecial=1;
			dYBigBeam= U(160);
			dEdgeOffsetBigBeam = U(40);
		}
		
	// define contact plane
		Vector3d vecFace = nZone < 0 ? vecZ :- vecZ;
		ptZFrames = Line(_Pt0, vecFace).orderPoints(ptZFrames);
		Plane pnRef(ptOrg, vecZ);
		if(nZone<0)	pnRef=Plane(ptOrg-vecZ*el.dBeamWidth(), -vecZ);//pnRef.vis(8);
		if (ptZFrames.length()>0)
		{
			pnRef = Plane(ptZFrames[0], vecFace);
			//PLine (_PtW, ptZFrames[0]).vis(6);
		}

	// collect profiles of nailing zone
		PlaneProfile ppSheets[0];
		PLine plEnvelopes[0];
		for(int i=0;i<gbThis.length();i++)
		{
			Sheet sh = (Sheet)gbThis[i];
			Beam bm;
			if (!sh.bIsValid()) bm = (Beam)gbThis[i];
			GenBeam gb= gbThis[i];
			Body bd = thisBodies[i];
			if (sh.bIsValid() && abs(sh.dH()-el.zone(sh.myZoneIndex()).dH())<dEps)
			{			
				Plane pnSheet(gb.ptCenSolid() + gb.vecD(vecZ)*.5*gb.dD(vecZ),gb.vecD(vecZ));
				PlaneProfile pp = bd.extractContactFaceInPlane(pnSheet,dEps );
				ppSheets.append(pp);//profShape would be cheaper, but it is not considering modifications to a sheet solid: sh.profShape());
				
				plEnvelopes.append(sh.plEnvelope());
				//sh.vecZ().vis(sh.ptCenSolid(),150);	
			}
			else if (bm.bIsValid())
			{
				PlaneProfile pp = bd.shadowProfile(Plane(ptOrg, vecZ));
				ppSheets.append(pp);	
				PLine pl;
				pl.createConvexHull(pnRef,pp.getGripVertexPoints());
				plEnvelopes.append(pl);
			}
		}

	// a collector for all nailing segments
		LineSeg segsAll[0];
		

	// loop frame beams
		Display dpDebug(122);
		dpDebug.textHeight(U(30));
		int bDebugSeg;//=true;
 
		for(int i=0;i<bmFrame.length();i++)
		{
			Beam bm = bmFrame[i];
			Vector3d vecXBm = bm.vecX();
			Vector3d vecYBm = bm.vecX().crossProduct(-vecZ);// rel to the element
			Point3d pt = bm.ptCenSolid();
			
		// define offset contour
			double dX = bm.solidLength()+2*(dEdgeOffsetBeam-dEdgeOffsetX);
			double dY = bm.dD(vecYBm);
			LineSeg segBm(pt-.5*(vecXBm*dX+vecYBm*dY),pt+.5*(vecXBm*dX+vecYBm*dY));
			PLine pl; pl.createRectangle(segBm, vecXBm, vecYBm);
			//pl.vis(1);

		// get contact face
			Body bd = frameBodies[i]; 
			bd.vis(32);
			PlaneProfile ppBm = bd.extractContactFaceInPlane(pnRef,dEps);
// { 
// 	PlaneProfile ppp = ppBm;
// 	ppp.transformBy(vecZ * U(100));
// 	ppp.vis(2);
// }
		// double nail lines for big beams 
			int bBig;
			double dThisEdgeOffsetBeam = dEdgeOffsetBeam;
			if (dY>=dYBigBeam && nSpecial==1)
			{
				//bd.vis(i);

				dThisEdgeOffsetBeam = dEdgeOffsetBigBeam;
				bBig=true;
			}
			

		
		// extract profile openings
			PlaneProfile ppOpening(CoordSys(ptOrg,vecX,vecY,vecZ)); 
			PLine plRings[] = ppBm.allRings();
			int bIsOp[] = ppBm.ringIsOpening();
			ppBm.removeAllRings();
			for (int r=0;r<plRings.length();r++)
			{
				if (!bIsOp[r])
					ppBm.joinRing(plRings[r],_kAdd);
				else
				{
					ppOpening.joinRing(plRings[r],_kAdd);
					//plRings[r].vis(6);
				}
			}
			
		// intersect with offset contour
			PlaneProfile pp(pl);	
			ppBm.intersectWith(pp);
			ppBm.shrink(dEdgeOffsetBeam);
			
		// readd openings // HSB-5107 openings rings of contact face are grown and added to nailable area
			ppOpening.shrink(-dEdgeOffsetX);
			//ppOpening.vis(6);	
			ppBm.subtractProfile(ppOpening);
				
			//if (dY>dYBigBeam && nSpecial==1)	ppBm.vis(52);
			//ppBm.vis(5);	
			
		// collect intersecting sheet profiles with a small offset
			int nIntersectingSheets[0];
			double dTest = U(1);
			PlaneProfile ppTest1, ppTest2, pps[0];
			for(int s=0;s<ppSheets.length();s++)
			{
				PlaneProfile ppSheet = ppSheets[s];//ppSheet .vis(s);
				PlaneProfile ppX = ppBm;
		
				ppX.intersectWith(ppSheets[s]);
//if (s==1)
//{ 
//	PlaneProfile pp = ppSheet;
//	pp.transformBy(vecZ * U(400));
//	pp.vis(s);
//}				
				if (ppX.area()>pow(dEps,2))
				{
					nIntersectingSheets.append(s);
					ppSheet.shrink(-dTest);
					
					
						
					
					pps.append(ppSheet);
					//if (dY>dYBigBeam )ppSheet .vis(s);
				}
			}
			
		// test intersection	
			int bMerge=dMerge>0;
			//if (bMerge)
			//{
				//// test f2f
				//for(int a=0;a<pps.length();a++)
				//{
					//for(int b=0;b<pps.length();b++)
					//{
						//if (a==b) continue;
						//PlaneProfile pp=pps[a];
						//pp.intersectWith(pps[b]);
						//if (pp.area()<pow(dEps,2))continue;
						
						//if (ppTest1.area()<pow(dEps,2))
							//ppTest1=pp;
						//else
							//ppTest1.unionWith(pp);			
					//}
				//}				
				//ppTest1.intersectWith(ppBm);	
				////ppTest1.vis(6);
				
				//if (ppTest1.area()>(dY*(2*dTest)*nIntersectingSheets.length()-1))
					//bMerge=false;
			//}
			//ppTest2.vis(3);

			PlaneProfile ppNails[0];
//			PlaneProfile ppCombine;
			for(int s=0;s<nIntersectingSheets.length();s++)
			{
				int n = nIntersectingSheets[s];
			//// combined sheets	
				//if (bMerge&& ppCombine.area()<pow(dEps,2))
					//ppCombine=ppSheets[n];
				//else if (bMerge)
					//ppCombine.unionWith(ppSheets[n]);
				//else
				ppNails.append(ppSheets[n]);
			}
//			if (ppCombine.area()>pow(dEps,2))
//			{
//				//ppCombine.shrink(-dMerge);
//				//ppCombine.shrink(dMerge);
//				
//				ppNails.append(ppCombine);
//			}
			
		// collect nail segments from intersecting ppNails
			for(int s=0;s<ppNails.length();s++)
			{
				PlaneProfile ppNail = ppNails[s];	//ppNail.vis(2);
				ppNail.shrink(dEdgeOffsetSide);		//ppNail.vis(252);
				ppNail.subtractProfile(ppNoNail);	//version  value="4.0" date="05jul19" author="thorsten.huck@hsbcad.com"> 'Nail on grid studs' considers nonail and saw protection are prior nail segment creation
				ppNail.subtractProfile(ppSaw);
				ppNail.intersectWith(ppBm);			//ppNail.vis(2);
				
			// loop individual rings
				PLine plRings[] = ppNail.allRings();
				int bIsOp[] = ppNail.ringIsOpening();
				for (int r=0;r<plRings.length();r++)
					if (!bIsOp[r])
					{
						PlaneProfile pp(plRings[r]);
												
					/// get split segments
						LineSeg segNail = pp.extentInDir(vecXBm);
						double dXSeg = abs(vecXBm.dotProduct(segNail.ptStart()-segNail.ptEnd()));	
						double dYSeg = abs(vecYBm.dotProduct(segNail.ptStart()-segNail.ptEnd()));	
						segNail = LineSeg(segNail.ptMid()-vecXBm*dXSeg,segNail.ptMid()+vecXBm*dXSeg);//segNail.vis(s);
		
						LineSeg segSplits[0];				
						double d = dY-2*dEdgeOffsetBigBeam;
						if (bBig && d<=dYSeg) // 4.2 make sure remaining width of profile allows two nail segments
						{
							
							pp.vis(4);	segNail.vis(6);
							segNail.transformBy(vecYBm*(.5*d-dEps));
							segSplits= pp.splitSegments(segNail,true);	
							segsAll.append(segSplits);
							//if (bDebug)for (int k=0;k<segSplits.length();k++) 	segSplits[k].vis(1); 						
							segNail.transformBy(-vecYBm*(d-dEps));
							segSplits= pp.splitSegments(segNail,true);	
							segsAll.append(segSplits);
							
							//if (bDebug)for (int k=0;k<segSplits.length();k++) 	segSplits[k].vis(1);  
						}
						else
						{
							segSplits= pp.splitSegments(segNail,true);								
							//if (bDebug)for (int k=0;k<segSplits.length();k++) 	segSplits[k].vis(6);  	 
							
							segsAll.append(segSplits);
							//ppNail.vis(2);
						}					
							
						
					}
				

			}
		}// next i bm of bmFrame


	// combine segments
		int bCollectedSegTags[segsAll.length()];
		LineSeg segsCombined[0];
		for(int i=segsAll.length()-1;i>=0;i--)
		{
			if (bCollectedSegTags[i]) continue;
			LineSeg segA = segsAll[i];

		// get segment coordSys
			Vector3d vecXSeg = segA.ptEnd()-segA.ptStart(); 
			vecXSeg.normalize();
			Vector3d vecYSeg = vecXSeg.crossProduct(-vecZ);	
			Point3d ptMidA = segA.ptMid();
			
		// find all segments being collinear
			int indices[0];
			LineSeg segs[0];
			for(int j=segsAll.length()-1;j>=0;j--)	
			{
				if (j==i) continue;
				LineSeg segB = segsAll[j];

			// get segment coordSys
				Vector3d vecXSegB = segB .ptEnd()-segB .ptStart(); 
				vecXSegB.normalize();
				Vector3d vecYSegB = vecXSegB.crossProduct(-vecZ);	
				Point3d ptMidB = segB .ptMid();	
				
				if (vecXSeg.isParallelTo(vecXSegB) && abs(vecYSeg.dotProduct(ptMidA-ptMidB))<dEps)
				{
					indices.append(j);
					segs.append(segB);
					//segB.vis(1);
				}				
			}
			
		// order identified segments along ref segment vecX
			for(int j=0;j<segs.length();j++)
				for(int k=0;k<segs.length()-1;k++)
				{
					double d1 = abs(vecXSeg.dotProduct(ptMidA-segs[k].ptMid()));
					double d2 = abs(vecXSeg.dotProduct(ptMidA-segs[k+1].ptMid()));
					if (d1>d2)
					{
						segs.swap(k,k+1);
						indices.swap(k,k+1);
					}
				}

		// try to combine and remove by index
			double dDelta = 2*dCombineLength+2*dMerge;
			double dLA = segA.length()+dDelta;
			Line lnX(ptMidA, vecXSeg);
			Point3d ptsA[] = {segA.ptMid()-vecXSeg*.5*segA.length(), segA.ptMid()+vecXSeg*.5*dLA};			
			//if (i==59)segA.vis(12);
			for(int j=0;j<segs.length();j++)
			{
				LineSeg segB = segs[j];
//				segB.vis(j+1);
//				segA.vis(232);
				ptsA[0].vis(2);
				ptsA[1].vis(2);
				if (bDebugSeg)
				{ 
					Point3d pt = (ptsA[0]+ptsA[1])/2;
					dpDebug.draw("i"+i+"j"+j, pt, vecX, vecY, 0,0);
				}

				double dLB = segB.length()+dDelta;
				double dLB2 = segB.length()+dDelta;
				if(j==segs.length()-1)
					dLB2=segB.length();
				Point3d ptsB[] = {segB.ptMid()-vecXSeg*.5*dLB, segB.ptMid()+vecXSeg*.5*dLB2};			
				
			// append if nearby to extremes
				double d1 = abs(vecXSeg.dotProduct(ptsB[ptsB.length()-1]-ptsA[0]));
				double d2 = abs(vecXSeg.dotProduct(ptsA[ptsA.length()-1]-ptsB[0]));

				if (d1>-dEps && d2<dEps )	
				{
					ptsA.append(ptsB);
					ptsA=lnX.orderPoints(ptsA);
					//segB.vis(j+1);
				}
				else	
					indices	[j] = -1;
									
			}
			
		// remove any tagged segment and rebuild reference segment
			for(int j=0;j<indices.length();j++)
				if(indices[j]>-1)
					bCollectedSegTags[indices[j]] = true;	
					
			if (ptsA.length()>2)
			{ 
				segA = LineSeg(ptsA[0], ptsA[ptsA.length()-1]); 
				
			}
				
			//segA.vis(3);
//			if (i==59 || i==58)segA.vis(3);
			bCollectedSegTags[i] = true;
			segsCombined.append(segA);
		}// next i
		segsAll = segsCombined;



	// separate into x and y oriented segments
		LineSeg segVerticals[0];
		for(int i=0;i<segsAll.length();i++)
		{
			//segsAll[i].vis(i);
			Vector3d vec = segsAll[i].ptEnd()-segsAll[i].ptStart();
		// collect verticals
			if (vec.isParallelTo(vecY))
				segVerticals.append(segsAll[i]);
		// append the rest right away	
			else
				segNails.append(segsAll[i]);		
		}
		
	// order verticals along X
		for(int i=0;i<segVerticals.length();i++)		
			for(int j=0;j<segVerticals.length()-1;j++)
			{
				double d1 = vecX.dotProduct(ptOrg-segVerticals[j].ptMid());
				double d2 = vecX.dotProduct(ptOrg-segVerticals[j+1].ptMid());
				if (d1<d2)
					segVerticals.swap(j,j+1);	
			}
			
	// associate vertical nail segments to sheets
		int nIndSheets[0];
		for(int i=0;i<segVerticals.length();i++)
			nIndSheets.append(-1);
		int nIndices[0]; // vesrion 2.8
		for(int i=0;i<segVerticals.length();i++)
		{
			LineSeg seg = segVerticals[i];

			for(int s=0;s<ppSheets.length();s++)
			{
//				ppSheets[s].vis(s);
				if (ppSheets[s].splitSegments(seg,true).length()>0)
				{
					//ppSheets[s].extentInDir(vecX).vis(s+1);
					//seg.vis((i==19?4:252));
					if (nIndices.find(s)<0)nIndices.append(s);
					nIndSheets[i]=s;//ppSheets[s].vis(i);
					break;
				}	
			}
			//segVerticals[i].vis(nIndSheets[i]);	
		}
		
	//region Loop segment group HSB-6501
		for (int i=0;i<nIndices.length();i++)
		{ 
		// collect sheets of this index with grid locations
			int nInd = nIndices[i];
			LineSeg segs[0];
			Point3d ptLocs[0];
			for(int j=0;j<segVerticals.length();j++)
				if (nIndSheets[j]==nInd)
				{
					//if (segVerticals[j].length() < U(30)) continue;
					segVerticals[j].vis(nInd);
					segs.append(segVerticals[j]);
					ptLocs.append(segVerticals[j].ptMid());
				}
			Line ln(ptOrg+vecY*U(500), vecX);	
			ptLocs = ln.orderPoints(ln.projectPoints(ptLocs),dEps);
			if(ptLocs.length()<1){continue;}
		
		//region Append first and last, collect grid locations inbetween
			Point3d ptGrids[0];
			ptGrids.append(ptLocs.first());		
			double dXFirst2Last = abs(vecX.dotProduct(ptLocs.last()-ptLocs.first()));
			if (abs(dXGrid-dXFirst2Last)>dEps && dXFirst2Last+dEps > dXGrid)
			{
				for (int j=1;j<ptLocs.length();j++)
				{ 
					int bLast = j == ptLocs.length() - 1;
					Point3d ptX = ptLocs[j];
					Point3d ptB = bLast?ptX:ptLocs[j+1];
					double dXThis = vecX.dotProduct(ptX - ptGrids.last());
					double dXNext = vecX.dotProduct(ptB - ptGrids.last());
					
					PLine plA(ptGrids.last(), ptX);
					plA.transformBy(vecY * j * U(50));
					if (dXNext < dXGrid + 10*dEps && !bLast) // HSB-9138 tolerance increased to catch segments out of default range
					{
//						plA.vis(1);
//						ptX.vis(1);
						continue;
					}
					else //HSB-7407 if (dXThis < dXGrid + dEps)
					{ 
						ptGrids.last().vis(40);
						ptX.vis(3);
						plA.vis(3);
						ptGrids.append(ptX);
					}	
				}					

			}
		// make sure the first or last location is also taken: version  value="4.6" date="19mar20" author="thorsten.huck@hsbcad.com"> HSB-6501 X-Grid distribution enhanced II 	
			else// if (i==nIndices.length()-1)
			{ 
				ptGrids.append(ptLocs.last());		
			}
			if(bDebug)	reportMessage("\nElement " + el.number() + " nailing group " + nInd + " has " + ptGrids.length() + " grid locations");
							
		//End Append first and last, collect grid locations inbetween//endregion 
	
		// Append nailing segments by grid location
			for (int j=0;j<ptGrids.length();j++) 
			{ 
				Point3d ptGrid = ptGrids[j];
		ptGrid.vis(1);		
				for (int k=segs.length()-1; k>=0 ; k--) 
				{ 
					double d = abs(vecX.dotProduct(ptGrid-segs[k].ptMid())); 
					if (d<dEps*10)
					{ 
						//segs[k].vis(nInd);
						segNails.append(segs[k]);
						segs.removeAt(k);
					}
//					else
//						segs[k].vis(1);
				}//next k 
			}//next j	
		}
		
					
	//End Loop segment group//endregion 	

//	// loop segment groups
//		if (0)
//		for (int i=0;i<nIndices.length();i++) 
//		{ 
//		// collect sheets of this index
//			int nInd = nIndices[i];
//			LineSeg segs[0];
//			for(int j=0;j<segVerticals.length();j++)
//				if (nIndSheets[j]==nInd)
//				{
//					//segVerticals[j].vis(nInd);
//					segs.append(segVerticals[j]);
//				}
//				
//			if(segs.length()==0){continue;}
//			if(bDebug)
//				reportMessage("\nElement " + el.number() + " nailing group " + nInd);
//			//ppSheets[nInd].extentInDir(vecX).vis(i);
//			
//			
//		// set initial grid ref and get last segment
//			Point3d ptGridRef =segs[0].ptMid();
//			Point3d ptLast =segs[segs.length()-1].ptMid();
//			double dXFirst2Last = abs(vecX.dotProduct(ptGridRef-ptLast));
//		
//		// only one vertical location found
//			if (dXFirst2Last<dEps)
//				segNails.append(segs);
//			else
//			{ 
//			// append any segment at first and last location
//				for (int j=segs.length()-1; j>=0 ; j--) 
//				{ 
//					double dX= vecX.dotProduct(segs[j].ptMid()-segs[0].ptMid()); 
//					if (dX<dEps || dXFirst2Last-dX<dEps)
//					{ 
//						segs[j].vis(252);
//						segNails.append(segs[j]);
//						segs.removeAt(j);
//					}
//				}
//				
//			// extreme nail segments are below the grid value: no further nailings inbetween
//				if (dXFirst2Last<=dXGrid)	
//				{ 
//					continue;	
//				}
//				
//				
//			// run grid test against all remaining segments
//				for (int a=0;a<segs.length();a++) 
//				{ 
//					Point3d ptA = segs[a].ptMid(); ptA.vis(a);
//					Vector3d vecXSeg = segs[a].ptEnd() - segs[a].ptStart(); vecXSeg.normalize();		
//					ptGridRef.vis(a);
////					if (i==1)
//					segs[a].vis(2);
//					ptGridRef.vis(2);
//				// test this segment location	
//					double dXA= vecX.dotProduct(ptA-ptGridRef);
//					int bBreakA;
//					if (dXA<=dXGrid+dEps && dXA>dEps)
//					{ 
//					// test if next segment would also be valid
//						if (a<segs.length()-1)
//						{
//							for (int b=a+1;b<segs.length();b++) 
//							{ 
////								if(i==1)
//									segs[b].vis(101);
//								Point3d ptB = segs[b].ptMid(); ptB.vis(1);
//								PLine(segs[b].ptMid() , segs[a].ptMid()).vis(1);
//								double dXB= vecX.dotProduct(ptB-ptGridRef);
//								double dDeltaX = abs(vecXSeg.dotProduct(segs[b].ptMid() - segs[a].ptMid()));
//							// the next segment is also valid, so exclude the previous one	
//								//version  value="4.3" HSB-5616 tolerance issue resolved when multiple parallel linesegments are tested against X-Grid: abs(dXB-dXA)<dEps instead of (dXB<=dXA)
//								if (((dXB<dXA && dXB<U(10)) || (abs(dXB-dXA)<dEps)) && //2.7 <= 4.0 <   // version  value="4.1" 'Nail on grid studs' enhanced
//									dDeltaX<.5*segs[b].length()) // HSB-6501 
//								{ 
//									continue;
//								}
//								if (dXB<=dXGrid+dEps && dXB>dEps && dXB-dEps>dXA)
//								{ 
//									break; // break b
//								}
//							// next is invalid, append any segement at A Location
//								else
//								{ 
//									for (int k=0;k<segs.length();k++)
//									{
//										//segs[k].vis(7);
//										Point3d ptK = segs[k].ptMid();
//										double dXK= vecX.dotProduct(ptK-ptGridRef);
//										double dDelta = dXA-dXK;
//									// allow segments which are nearby	
//										//https://hsbcadbvba-my.sharepoint.com/personal/thorsten_huck_hsbcad_com/_layouts/15/guestaccess.aspx?docid=1fda89968205b4780977b8509a7f52ef7&authkey=AaRKdIvvlE8SalgITeib_wY
//										if (dDelta> -dEps && dDelta<dEdgeOffsetSide*.5) 
//										{
//											if(bDebug && abs(dDelta)>dEps)
//												reportMessage("\n	Accepting an additional segment with offset = " + dDelta);
//											//segs[k].vis(6);
//											segNails.append(segs[k]);
//										}
//										else if (dXK-dXA>dEps)
//										{ 
//											break;
//										}
//									}
//								// move ref location	
//									ptGridRef = ptA;
//								
//								// test distance to last
//									double dXThis2Last = abs(vecX.dotProduct(ptGridRef-ptLast));	
//									if (dXThis2Last<dXGrid)
//									{
//										if(bDebug)reportMessage("\n	breaking a at " + a + " Distance to last segment = " + dXThis2Last +" at group " + nInd);
//										
//										bBreakA=true;
//									}	
//								}
//							}
//						}
//					// last segment to be appended if valid	
//						else
//						{ 
//							segNails.append(segs[a]);
//						}
//	
//					}
//					else
//					{ 
//						segNails.append(segs[a]);
//					}
//				// breaking a because distance to last is smaller than grid value
//					if (bBreakA)
//					{ 
//						break;
//					}
//				}
//			}
//		}
	}
// END 5 = nail on stud grid		
//End 5 = nail on stud grid//endregion 

//region Nail Creation for all types
		

// debug

	//if (bDebug)dp.draw(scriptName(),ptOrg,vecX,vecY,1,0,_kDevice);
//
//	if (bDebug)
//		dp.draw(segNails);
	//ppOther.vis(2);

// add release naillines trigger
	String sTriggerReleaseNailings = T("|Release Naillines|");
	addRecalcTrigger(_kContext, sTriggerReleaseNailings );	
	
// flag to create individual nail lines
	int bCreate;
	if (_bOnRecalc && (_kExecuteKey==sTriggerReleaseNailings || _kExecuteKey==sDoubleClick))
		bCreate=true;

	


// split segments if sawlines are found
	if (ppSaw.area()>pow(dEps,2))
	{
		ppSaw.vis(4);
		
		for (int i=0 ; i<segNails.length();i++)
			segNails[i].vis(40);		
		segNails = ppSaw.splitSegments(segNails, false);
		
		
		
	}

// purge duplicates
	for (int i=segNails.length()-1; i>=0 ; i--)
	{ 
		LineSeg a = segNails[i];
		Vector3d vecA = a.ptStart() - a.ptEnd();
		vecA.normalize();
		Point3d ptMidA = a.ptMid();
		
		int bRemove;
		for (int j=segNails.length()-2; j>i ; j--) 
		{ 
			LineSeg b = segNails[j];
			Vector3d vecB = b.ptStart() - b.ptEnd();
			vecB.normalize();
			if ( ! vecA.isParallelTo(vecB))continue;
			Point3d ptMidB = b.ptMid();
			if (Vector3d(ptMidA-ptMidB).length()<dEps)
			{ 
				//b.vis(3);
				bRemove = true;
				break;
			}
		}
		
		if (bRemove)
		{ 
			//a.vis(1);
			segNails.removeAt(i);		
		}
	}
//next i
	
	





// loop segments
	for (int i=0 ; i<segNails.length();i++)
	{
		if (Vector3d (segNails[i].ptStart()-segNails[i].ptEnd()).length()<U(50))continue;// ignore short naillines
		ElemNail elemNail(nZone, segNails[i].ptStart(), segNails[i].ptEnd(), dSpacing, nToolIndex);
		
		if(bCreate)
		{
			NailLine nl;		
			nl.dbCreate(el, elemNail);
		}
		else if (!_bOnDebug)
			el.addTool(elemNail);
	}

// erase when individual were created
	if (bCreate || segNails.length()<1 && !_bOnDbCreated)
	{
		if (bDebug && segNails.length()<1)
		{
			reportMessage("\n" + T("|No nail segments found.|"));
		}
		else
			eraseInstance();
		return;	
	}
		
//End Nail Creation for all types//endregion 
























#End
#BeginThumbnail
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
4TME"UM8P0.06CC"DCIP*GHH`_]F/
`





































#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="2782" />
        <int nm="BreakPoint" vl="2361" />
        <int nm="BreakPoint" vl="2550" />
        <int nm="BreakPoint" vl="956" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16861 bugfix beam sheet converting when material is not defined" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="10/20/2022 12:36:37 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-10362 debug message removed" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="1/15/2021 3:02:20 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Default catalog entries (default and last inserted) are ignored for instance creation" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="1/15/2021 12:53:52 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End