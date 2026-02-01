#Version 8
#BeginDescription
#Versions
Version 3.9 18.10.2024 HSB-22805 retriggering schedule upon creation to update relatiions , Author Thorsten Huck
3.8 11.10.2024 HSB-22805 dormer opening areas are subtracted from main roof and are not separately listed anymore
3.7 21.09.2023 HSB-20108: Special (RUB) In schedule mode collect only roof planes that have groups turned on
3.6 18.07.2023 HSB-19481: Fix pl when creatng pp from pl 
3.5 18.07.2023 HSB-19481: check if pp operation fails in eave area and inner area 
3.4 14.06.2023 HSB-19192: Fix catalog for the RoofDataEdge 
3.3 12.04.2023 HSB-18550: Prompt PLine for inner area 
3.2 11.04.2023 HSB-18550: Consider Rafters at Eave area "Sparrenkopf" 
3.1 05.07.2022 HSB-15819: dont assign table in group for projectSpecial =="Baufritz"
Version 3.0    28.04.2021
HSB-11712 tolerance issue catched when merging complex roof shapes , 


2.10 11.03.2021 HSB-11158: write Level of the group in hardware group 

<version value="2.9" date="26mar2020" author="nils.gregor@hsbcad.com"> 
HSB-5822 Bugfix check group length before adding instance 

hardware count type changed to area
automatic numbering of roofplanes without any number

DACH
Dieses TSL berechnet die Trauf-, Indach-, und Dachflächen und faßt diese in einer Tabelle zusammen.

EN
This tsl calculates eave, inner and roof areas and summarizes those in a schedule table





















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 9
#KeyWords 
#BeginContents
/// <summary Lang=de>//region
/// Dieses TSL berechnet die Trauf-, Indach-, und Dachflächen und faßt diese in einer Tabelle zusammen.
/// </summary>

/// <summary Lang=en>
/// This tsl calculates eave, inner and roof areas and summarizes those in a schedule table
/// </summary>

/// History
// #Versions: 
// 3.9 18.10.2024 HSB-22805 retriggering schedule upon creation to update relatiions , Author Thorsten Huck
// 3.8 11.10.2024 HSB-22805 dormer opening areas are subtracted from main roof and are not separately listed anymore , Author Thorsten Huck
// 3.7 21.09.2023 HSB-20108: Special (RUB) In schedule mode collect only roof planes that have groups turned on Author: Marsel Nakuci
// 3.6 18.07.2023 HSB-19481: Fix pl when creatng pp from pl Author: Marsel Nakuci
// 3.5 18.07.2023 HSB-19481: check if pp operation fails in eave area and inner area Author: Marsel Nakuci
// 3.4 14.06.2023 HSB-19192: Fix catalog for the RoofDataEdge Author: Marsel Nakuci
// 3.3 12.04.2023 HSB-18550: Prompt PLine for inner area Author: Marsel Nakuci
// 3.2 11.04.2023 HSB-18550: Consider Rafters at Eave area "Sparrenkopf" Author: Marsel Nakuci
// 3.1 05.07.2022 HSB-15819: dont assign table in group for projectSpecial =="Baufritz" Author: Marsel Nakuci
// 3.0 28.04.2021 HSB-11712 tolerance issue catched when merging complex roof shapes , Author Thorsten Huck
// 2.10 11.03.2021 HSB-11158: write Level of the group in hardware group Author: Marsel Nakuci
///<version value="2.9" date="26mar2020" author="nils.gregor@hsbcad.com"> HSB-5822 Bugfix check group length before adding instance  </version>
///<version value="2.8" date="25feb2020" author="nils.gregor@hsbcad.com"> HSB-5822 Changed custom behavior. RoofArea is only a result. _PtGs can only be moved inside the roof plane </version>
///<version value="2.7" date="20feb2020" author="thorsten.huck@hsbcad.com"> HSB-6652 reverted HSB-5822 as negative implications on insert </version>
///<version value="2.6" date="24oct19" author="thorsten.huck@hsbcad.com"> HSB-5822 subtraction plines enabled for roof area mode after insertion </version>
///<version value="2.5" date="18oct18" author="thorsten.huck@hsbcad.com"> hardware count type changed to area </version>
///<version value="2.4" date="09apr18" author="thorsten.huck@hsbcad.com"> automatic numbering of roofplanes without any number </version>
///<version value="2.3" date="05apr17" author="florian.wuermseer@hsbcad.com"> bugfix editinplace (roof areas were jumping when editinplace was initiated), group assignment is kept durin editinplace </version>
///<version value="2.2" date="25jan17" author="thorsten.huck@hsbcad.com"> bugfix mono ridge roofs, supports base angles and hip/valley angles of roof edges assigned to two roofplanes </version>
///<version value="2.1" date="15dec16" author="thorsten.huck@hsbcad.com"> bugfix </version>
///<version value="2.0" date="15dec16" author="thorsten.huck@hsbcad.com"> new catalog option to evaluate roof edge data, if enabled edge data will also be listed in schedule table </version>
///<version value="1.9" date="05dec16" author="thorsten.huck@hsbcad.com"> deep check if roofplane is valid for evaluation context, plan view interference tests on insert and recalc added </version>
///<version value="1.8" date="02dec16" author="thorsten.huck@hsbcad.com"> schedule table supports amount of decimals, supports silent insert when called with catalog entry name </version>
///<version value="1.7" date="30nov16" author="thorsten.huck@hsbcad.com"> unit bugfix </version>
///<version value="1.6" date="22july16" author="thorsten.huck@hsbcad.com"> image updated </version>
///<version value="1.5" date="22july16" author="thorsten.huck@hsbcad.com"> translation fixed </version>
///<version value="1.4" date="13may16" author="thorsten.huck@hsbcad.com"> individual preview for multiple roofs, edit in place will create individual instances if multiple rings apply </version>
///<version value="1.3" date="09may16" author="thorsten.huck@hsbcad.com"> bugfixes add/subtract polylines, adding and removing grips added </version>
///<version value="1.2" date="09may16" author="thorsten.huck@hsbcad.com"> initial </version>//endregion


//region constants
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=projectSpecial().find("debugTsl",0)>-1;

	String sUnits[] = {"mm", "cm", "m", "inch", "feet"};
	String sScriptNameEdge = "hsbRoofDataEdge";
// opmKeys
	String sOpmKeys[] = { "EaveArea", "InnerArea", "RoofArea", "Schedule"};
	String sPrefixes[] = { T("|Eave Area|"), T("|Inner Area|"), T("|Roof Area|"), T("|Schedule Table|")};

	String sDisabled = T("|Disabled|");
	String sEnabled = T("|Enabled|");
	String sDefaultEntryName = T("|_Default|");
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
// categories
	String sCategoryGeneral = T("|General|");
	String sCategoryDisplay = T("|Display|");
	String sCategoryHatch = T("|Hatch|");
	String sCategoryCatalogs = T("|Catalog Entries|");

// order dimstyles
	String sDimStyles[0];sDimStyles = _DimStyles;
	String sTemps[0];sTemps = sDimStyles;
	for(int i=0;i<sTemps.length();i++)
		for(int j=0;j<sTemps.length()-1;j++)
			if (sTemps[j].makeUpper()>sTemps[j+1].makeUpper())
			{
				sTemps.swap(j,j+1);
				sDimStyles.swap(j,j+1);
			}	

	String sDimStyleName=T("|Dimstyle|");
	String sProjectSpecial=projectSpecial();
	sProjectSpecial.makeUpper();
// HSB-7512:
	int isBaufritz=sProjectSpecial=="BAUFRITZ";
	int isRubner=sProjectSpecial=="RUB";
	
// Store ThisInst in _Map to enable debugging with subMapX until HSB-22564 is implemented
	TslInst this = _ThisInst;
	if (bDebug && _Map.hasEntity("thisInst"))
	{
		Entity ent = _Map.getEntity("thisInst");	
		this = (TslInst)ent;
	}
	else if (!bDebug && (_bOnDbCreated || !_Map.hasEntity("thisInst")))
		_Map.setEntity("thisInst", this);	
	
	
	
//endregion

//region Functions

//region Function CollectERoofPlanes
	// returns all eroofplanes
	ERoofPlane[] CollectERoofPlanes()
	{ 
		Entity ents[]=Group().collectEntities(true,ERoofPlane(),_kModelSpace);
		ERoofPlane out[0];
		for (int i = 0; i < ents.length(); i++)
		{
			ERoofPlane erp = (ERoofPlane)ents[i];
			if (erp.bIsValid())
				out.append(erp);
			
		}
		return out;
	}//endregion



//region Function CollectERoofPlaneTypes
	// returns potential appearances of eroofplanes of the specified type and modifies the input array if found
	// erpRef: an eroofplane which is used to check if coplanar, ignore if not valid
	ERoofPlane[] CollectERoofPlaneTypes(ERoofPlane& erps[], int nRPType, ERoofPlane erpRef)
	{ 
		ERoofPlane out[0];
		
		for (int i=erps.length()-1; i>=0 ; i--) 
		{ 
			int n =erps[i].planeType();
			if (n==nRPType)
			{ 
				if (erpRef.bIsValid())
				{ 
					CoordSys cs1 = erps[i].coordSys();
					CoordSys cs2 = erpRef.coordSys();
					
					Vector3d vecZ1 = cs1.vecZ();
					Vector3d vecZ2 = cs2.vecZ();
					
					Point3d pt1= cs1.ptOrg();
					Point3d pt2 = cs2.ptOrg();
					
					if (vecZ1.isParallelTo(vecZ2) && abs(vecZ1.dotProduct(pt1-pt2))<dEps)
					{ 
						out.append(erps[i]);
						erps.removeAt(i);						
					}
					
				}
				else
				{ 
					out.append(erps[i]);
					erps.removeAt(i);					
				}
			}			
		}//next i	

		return out;
	}//endregion


//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) {eraseInstance(); return;}
		
	// caller properties
		int nOpmKey=0;
		// eave area
		String sEaveEntries[]=TslInst().getListOfCatalogNames(scriptName()+ "-" + sOpmKeys[nOpmKey]); 
		if (sEaveEntries.length()<1) sEaveEntries.append(sDefaultEntryName);
		sEaveEntries.insertAt(0, sDisabled);
		String sEaveEntryName=sPrefixes[nOpmKey++];	
		PropString sEaveEntry(nStringIndex++, sEaveEntries, sEaveEntryName);	
		sEaveEntry.setDescription(T("|Defines the catalog entry of this type|"));
		sEaveEntry.setCategory(sCategoryCatalogs);
		
		// inner area
		String sInnerEntries[]=TslInst().getListOfCatalogNames(scriptName()+ "-" + sOpmKeys[nOpmKey]); 
		if (sInnerEntries.length()<1) sInnerEntries.append(sDefaultEntryName );
		sInnerEntries.insertAt(0, sDisabled);
		String sInnerEntryName=sPrefixes[nOpmKey++];	
		PropString sInnerEntry(nStringIndex++, sInnerEntries, sInnerEntryName);	
		sInnerEntry.setDescription(T("|Defines the catalog entry of this type|"));
		sInnerEntry.setCategory(sCategoryCatalogs);
		
		// roof area
		String sRoofEntries[]=TslInst().getListOfCatalogNames(scriptName()+ "-" + sOpmKeys[nOpmKey]); 
		if (sRoofEntries.length()<1) sRoofEntries.append(sDefaultEntryName );		
		sRoofEntries.insertAt(0, sDisabled);
		String sRoofEntryName=sPrefixes[nOpmKey++];	
		PropString sRoofEntry(nStringIndex++, sRoofEntries, sRoofEntryName);	
		sRoofEntry.setDescription(T("|Defines the catalog entry of this type|"));
		sRoofEntry.setCategory(sCategoryCatalogs);				
		
		// schedule area
		String sScheduleEntries[]=TslInst().getListOfCatalogNames(scriptName()+ "-" + sOpmKeys[nOpmKey]); 
		if (sScheduleEntries.length()<1) sScheduleEntries.append(sDefaultEntryName );		
		sScheduleEntries.insertAt(0, sDisabled);
		String sScheduleEntryName=sPrefixes[nOpmKey++];	
		PropString sScheduleEntry(nStringIndex++, sScheduleEntries, sScheduleEntryName);	
		sScheduleEntry.setDescription(T("|Defines the catalog entry of this type|"));
		sScheduleEntry.setCategory(sCategoryCatalogs);
		
		nStringIndex++;// keep compatibility with previous version 1.9
		String sEdgeEntries[]=TslInst().getListOfCatalogNames(sScriptNameEdge); 
		if (sEdgeEntries.length()<1) sEdgeEntries.append(sDefaultEntryName);
		sEdgeEntries.insertAt(0, sDisabled);
		String sEdgeEntryName=T("|Roof Edges|");
		PropString sEdgeEntry(nStringIndex++, sEdgeEntries, sEdgeEntryName,1);	//3
		sEdgeEntry.setDescription(T("|Defines wether roof edge calculation shall be executed.|"));
		sEdgeEntry.setCategory(sCategoryCatalogs);
		nStringIndex-=2;// keep compatibility with previous version 1.9
		
		String sGroupName=T("|Group|");	
		PropString sGroup(nStringIndex++, "", sGroupName);	//3
		sGroup.setDescription(T("|seperate Level by '\\'|"));
		sGroup.setCategory(sCategoryGeneral);
		
	// silent/dialog
		String sKey=_kExecuteKey;
		sKey.makeUpper();
		int bSilent;
		if (sKey.length()>0)
		{
			String sEntries[]=TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i]=sEntries[i].makeUpper();
			if (sEntries.find(sKey)>-1)
			{
				setPropValuesFromCatalog(sKey);
				bSilent=true;
			}
			
			else
				setPropValuesFromCatalog(T("|_LastInserted|"));
		}
		if(!bSilent)
			showDialog();
		
	// get enums of selected entries
		int nEaveEntry=sEaveEntries.find(sEaveEntry,0);
		int nInnerEntry=sInnerEntries.find(sInnerEntry,0);
		int nRoofEntry=sRoofEntries.find(sRoofEntry,0);
		int nScheduleEntry=sScheduleEntries.find(sScheduleEntry,0);
		int nEdgeEntry=sEdgeEntries.find(sEdgeEntry,0);
		// 
	// prompt for roofplanes
		Entity entsErps[0];
		PrEntity ssErp(T("|Select roofplane(s)|"), ERoofPlane());
  		if (ssErp.go())
			entsErps=ssErp.set();
		
	// prompt for walls or polylines
		Entity entsSet[0];
		// prompt if eave or inner area is selected
		if(nEaveEntry)
		{ 
			// HSB-19192
		// prompt for elements
			PrEntity ssE(T("|Eave Area|")+": "+T("|Select walls or <Enter> to select Polylines|"), ElementWall());
		  	if (ssE.go())
				entsSet.append(ssE.set());
						
			if(entsSet.length()==0)
			{ 
			// prompt for polylines
				PrEntity ssEpl(T("|Eave Area|")+": "+T("|Select polylines|"), EntPLine());
			  	if (ssEpl.go())
					entsSet.append(ssEpl.set());
			}
			
//			PrEntity ssE(T("|Select polyline(s) or walls for the eave area|"), EntPLine());
//			ssE.addAllowedClass(ElementWall());
//			
//		  	if (ssE.go())
//				entsSet.append(ssE.set());
		}
		EntPLine ePlInner;
		Map mapSubtrInner;
//		if(nInnerEntry)
		if((nInnerEntry && nEaveEntry) || (nInnerEntry && nRoofEntry))
		{ 
//			ePlInner=getEntPLine(T("|Select polyline for the inner area|"));
		// HSB-19192: prompt for polylines
			Entity entPls[0];
			String sPrompt=T("|Select polyline for the inner area|");
			if(nEaveEntry)
				sPrompt=T("|Select polyline for the inner area or <Enter> to accept the previous selection|");
			PrEntity ssEpl(sPrompt, EntPLine());
		  	if (ssEpl.go())
				entPls.append(ssEpl.set());
					
			EntPLine epls[0];
			for (int ient=0;ient<entPls.length();ient++) 
			{ 
				EntPLine ePlI=(EntPLine) entPls[ient]; 
				if (ePlI.bIsValid())epls.append(ePlI);
			}//next ient
			if(epls.length()>0)
				for (int iepl=0;iepl<epls.length();iepl++) 
				{ 
					mapSubtrInner.appendEntity("pline", epls[iepl]);
				}//next iepl
//			mapSubtrInner.appendEntity("pline", ePlInner);
		}
		
	// cast sset
		Wall elements[0];
		EntPLine eplSubs[0];	
		Map mapSubtr;
		// inner area
		for(int i=0;i<entsSet.length();i++)
		{
			Entity ent=entsSet[i];
			if (ent.bIsKindOf(Wall()))
				elements.append((Wall)ent);
			else if (ent.bIsKindOf(EntPLine()))
			{	
				eplSubs.append((EntPLine)ent);
				mapSubtr.appendEntity("pline", ent);
			}
		}
		// inner is prompted
//		if(nInnerEntry && !nEaveEntry && !nRoofEntry)
		if(nInnerEntry)
		{ 
			if(mapSubtrInner.length()==0 && mapSubtr.length()>0)
			{ 
				// // HSB-19192
				// no selection was done in inner prompt
				// and a pline was selected at eave area
				mapSubtrInner=mapSubtr;
			}
		}
		
//		if (mapSubtr.length()<1 && elements.length()<1)
//		{
//			reportMessage(TN("|Requires at least 1 polyline or wall.|"));
//			eraseInstance();
//			return;
//		}	
		
	// create group if property is used and group not existant
		Group group;
		if (sGroup!="")
		{
			group.setName(sGroup);
			if (!group.bExists())
				group.dbCreate();
		}
		
		Point3d ptSchedule;
		if(nScheduleEntry>0)
		{ 
			ptSchedule=getPoint(T("|Insertion point schedule|"));
		}
	// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl=_XE;
		Vector3d vecYTsl=_YE;
		GenBeam gbsTsl[]={};
		Entity entsTsl[]={};
		Point3d ptsTsl[]={};
		int nProps[]={};
		double dProps[]={};
		String sProps[]={};
		
		String sScriptname=scriptName();
		Entity entsTsls[0];
		
	// create roof edge 
		if (nEdgeEntry>0)
		{
			Map mapTsl;	
			entsTsl=entsErps;
			tslNew.dbCreate(sScriptNameEdge,vecXTsl,vecYTsl,gbsTsl,entsTsl,ptsTsl, 
				nProps,dProps,sProps,_kModelSpace,mapTsl);
			if (tslNew.bIsValid())
			{// HSB-19192: fix catalog assignment
				tslNew.setPropValuesFromCatalog(sEdgeEntry);
				//if (nEdgeEntry==sDefaultEntryName)tslNew.setPropInt(1, 142);	
				entsTsls.append(tslNew);
				if (sGroup!="")group.addEntity(tslNew, TRUE);
			}			
		}
		
	// collect existing roof numbers
		String sNumbers[0];
		ERoofPlane erps[] = CollectERoofPlanes();
		for(int i=0;i<erps.length();i++)
		{
			ERoofPlane erp=erps[i];
			if (!erp.bIsValid())continue;

			String sNumber=erp.roofNumber();
			int n=sNumbers.find(sNumber);
		// reset duplicates	
			if (n>-1)
				erp.setRoofNumber("");
		// collect roof number
			else if (sNumber.length()>0)
				sNumbers.append(sNumber);
		}	
		
	// roof index
		int nRoofNumber=1;
		
	// create individual instances of outer, inner and roof areas
	// create 3o1 tsl/erp and collect created instances
		ERoofPlane erpRoofs[] = CollectERoofPlaneTypes(erps, _kRPTRoof, ERoofPlane());
		for (int i=0;i<entsErps.length();i++)
		{
		// apply number
			ERoofPlane erp=erpRoofs[i];//(ERoofPlane)entsErps[i];
			if (!erp.bIsValid())continue;
			
			if (erp.roofNumber().length()<1)
			{
				int x=-1;
				while (x<sNumbers.length())
				{
					String sNumber=nRoofNumber;
					if (sNumbers.find(sNumber) < 0)
					{
						erp.setRoofNumber(sNumber);
						sNumbers.append(sNumber);
						break;
					}
					nRoofNumber++;
					x++;
				}
			}
			
			Map mapTsl;	
			entsTsl.setLength(0);
			entsTsl.append(entsErps[i]); // append a roofplane
			entsTsl.append(entsSet);	// append walls and plines
		// outer area
			if (nEaveEntry>0)
			{
				mapTsl.setMap("Subtraction[]",mapSubtr);
				mapTsl.setInt("mode",0); 
				tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,ptsTsl, 
					nProps,dProps,sProps,_kModelSpace, mapTsl);	
				if (tslNew.bIsValid())
				{
					tslNew.setPropValuesFromCatalog(sEaveEntry);
					if (sEaveEntry==sDefaultEntryName)
					{
						tslNew.setPropInt(1,142);
					// set the calculation of Kopfsparren
						tslNew.setPropString(4,sNoYes[0]);
					}
					entsTsls.append(tslNew);
					if (sGroup != "")group.addEntity(tslNew, TRUE);
				}
			}
		// inner area
			if (nInnerEntry>0)
			{	
				mapTsl.setMap("Subtraction[]",mapSubtrInner);
//				mapTsl.removeAt("Subtraction[]",true);
//				mapTsl.setMap("Addition[]",mapAdds);
				mapTsl.setInt("mode",1);
				tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,ptsTsl, 
					nProps,dProps,sProps,_kModelSpace,mapTsl);
				if (tslNew.bIsValid())
				{
					tslNew.setPropValuesFromCatalog(sInnerEntry);
					if (sInnerEntry==sDefaultEntryName)tslNew.setPropInt(1, 74);
					entsTsls.append(tslNew);
					if (sGroup!="")group.addEntity(tslNew, TRUE);
				}
			}
		// roof area
			if (nRoofEntry>0)
			{	
				mapTsl.setInt("mode",2);	
				mapTsl.setInt("NumSubPlines", mapSubtr.length());
				tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,ptsTsl, 
					nProps,dProps,sProps,_kModelSpace,mapTsl);
				if (tslNew.bIsValid())
				{
					tslNew.setPropValuesFromCatalog(sRoofEntry);
					if (sRoofEntry==sDefaultEntryName)tslNew.setPropInt(1, 12);
					entsTsls.append(tslNew);
					if (sGroup!="")group.addEntity(tslNew, TRUE);
				}
			}
		}
		
	/// schedule table
		if (nScheduleEntry>0)
		{
			tslNew=TslInst();
//			ptsTsl.append(getPoint(T("|Insertion point schedule|")));
			ptsTsl.append(ptSchedule);
			Map mapTsl;	
			mapTsl.setInt("mode",3);	// schedule table
			entsTsl=entsTsls;
			if (entsTsl.length()>0)	
				tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,ptsTsl, 
					nProps,dProps,sProps,_kModelSpace,mapTsl);
			if (tslNew.bIsValid())
			{
				tslNew.setPropValuesFromCatalog(sScheduleEntry);
				if (sScheduleEntry==sDefaultEntryName)tslNew.setPropInt(1, 7);
				
				if (sGroup!="")
				{
					// HSB-15819:
					if(!isBaufritz)
						group.addEntity(tslNew, TRUE);
				}
				tslNew.transformBy(Vector3d(0, 0, 0));
			}	
		}	
		
		eraseInstance();
		return;	
	}
// END ON INSERT		
//endregion 


// get mode: detect type
	int nMode=_Map.getInt("mode");
	setOPMKey(sOpmKeys[nMode]);
	// 0 = eave area
	// 1 = inner area
	// 2 = roof area
	// 3 = schedule mode
	if(bDebug)reportMessage("\n\n ****"+ scriptName() + " starting in mode " + sOpmKeys[nMode]);
	
	
// schedule mode//region
	if(nMode==3)
	{
		
	//region Properties
		String sHeaderName=T("|Schedule Header|");	
		PropString sHeader(nStringIndex++, T("|Schedule Table|"), sHeaderName);	
		sHeader.setDescription(T("|Defines the Header|"));
		sHeader.setCategory(sCategoryDisplay);
		
		PropString sDimStyle3(nStringIndex++,sDimStyles,sDimStyleName);//0
		sDimStyle3.setCategory(sCategoryDisplay);

		String sTxtH3Name=T("|Text Height|");	
		PropDouble dTxtH3(nDoubleIndex++, U(30), sTxtH3Name);
		dTxtH3.setDescription(T("|Sets the text height|"));
		dTxtH3.setCategory(sCategoryDisplay);
		
		String sColor3Name=T("|Color|");	
		PropInt nColor3(nIntIndex++, 1, sColor3Name);	
		nColor3.setDescription(T("|Defines the color|"));
		nColor3.setCategory(sCategoryDisplay);		
	
		String sDecimalName=T("|Decimals|");	
		int nDecimals[]={0,1,2,3,4};
		PropInt nDecimal(nIntIndex++, 0, sDecimalName);	//0
		nDecimal.setDescription(T("|Defines the qty of decimals|"));
		nDecimal.setCategory(sCategoryDisplay);			
	//endregion 
		
	//region Collect Entities and map data
	
	// add entities which have been appended through my map
		if (_Map.hasMap("AddArea[]"))
		{
			Map map=_Map.getMap("AddArea[]");
			for(int i=0;i<map.length();i++)
			{
				Entity ent=map.getEntity(i);
				if (ent.bIsKindOf(TslInst()))
				{
					//tsls.append((TslInst)ent);	
					_Entity.append(ent);	
				}			
			}
			_Map.removeAt("AddArea[]", true);	
		}	

	// collect attached tsls
		TslInst tsls[0], tslEdges[0];
		for(int i=0;i<_Entity.length();i++)
		{
			Entity ent=_Entity[i];
			TslInst tsl=(TslInst)ent;
			if (tsl.bIsValid() && tsl.scriptName().makeUpper().find("EDGE",0)<0)
				tsls.append(tsl);
			else
				tslEdges.append(tsl);
		}

	// remove invalid scripts
		for(int i=tsls.length()-1;i>=0;i--)
			if (tsls[i].scriptName()!=scriptName() && scriptName()!="__HSB__PREVIEW")
				tsls.removeAt(i);	

	// erase empty schedules
		if (tsls.length()<1)
		{
			reportMessage("\n" + scriptName() + ": " +T("|Could not find any data.|") + " " + T("|Tool will be deleted.|"));		
			eraseInstance();
			return;
		}
		
		
	// on insert or recalc run auto correct location of associated instances
		if (_bOnDbCreated || _bOnRecalc)
		{ 
			CoordSys csWorld(_PtW, _XW,_YW,_ZW);
			PlaneProfile ppProtect(csWorld);
			double dThisTxtH;
			for (int i=0;i<tsls.length();i++) 
			{ 
				TslInst tsl = tsls[i]; 
				if (dThisTxtH<=dEps) // get etxt height from first
					dThisTxtH = tsl.propDouble(1);
				Map map = tsl.map();
				PLine plBox = map.getPLine("plPlan");
				if (plBox.area()<pow(dEps,2))
					continue;
				Point3d ptLoc = tsl.ptOrg(); 
				plBox.projectPointsToPlane(Plane(_PtW,_ZW),_ZW);//plBox.vis(i);
				
			// initial protection area
				if (ppProtect.area()<pow(dEps,2))
					ppProtect.joinRing(plBox, _kAdd);
			// test interference	
				else
				{
					Vector3d vec = _XW;
					double dDelta = dThisTxtH*.5;//
					Point3d ptLocTest=ptLoc;
					PlaneProfile ppAdd(csWorld);
					ppAdd.joinRing(plBox, _kAdd);
					//ppAdd.vis(3);
					PlaneProfile ppTest =ppProtect;
					ppProtect.vis(4);
					ppTest.intersectWith(ppAdd);
					int nCnt;
					CoordSys csRot; csRot.setToRotation(22.5, _ZW, ptLoc);
					while(ppTest.area()>pow(dEps,2) && nCnt<100)
					{
						int bOk;
						for (int r=0; r<16;r++)
						{
							ppAdd.transformBy(vec*dDelta);
							ptLocTest.transformBy(vec*dDelta);
							ppTest=ppProtect;
							ppTest.intersectWith(ppAdd);	
							if (bDebug){ Display dpDebug(nCnt);dpDebug.draw(ppAdd);}					
							if (ppTest.area()<pow(dEps,2)) 
							{
								bOk=true;
								break;	
							}
							ppAdd.transformBy(-vec*dDelta);
							ptLocTest.transformBy(-vec*dDelta);							
							
							vec.transformBy(csRot);															
						}	
						if (bOk)break;
						dDelta += dThisTxtH*.5;					
						nCnt++;
					}
					
					ptLoc=ptLocTest;
					ppProtect.unionWith(ppAdd);
					if (bDebug){ Display dpDebug(nCnt);dpDebug.draw(ppAdd, _kDrawFilled);}	
					
					PLine (ptLoc,tsl.ptOrg()).vis(i);
					tsl.transformBy(ptLoc-tsl.ptOrg());
				}
			}
		}//END on insert or recalc run auto correct location of associated instances
		
		
	// write schedule parent data to each child area	
		// this is used to relink a splitted area instance to an existing schedule	
		Map mapX;
		mapX.setString("ParentUID", _ThisInst.handle());
		mapX.setPoint3d("ptOrg", _Pt0, _kRelative);
		for (int t=0;t<2;t++) 
		{ 
			TslInst tslChilds[0];
			if (t==0)tslChilds=tsls;
			else if (t==1)tslChilds=tslEdges;
			for(int i=tslChilds.length()-1;i>=0;i--)
			{
			// (over)write submapX
				tslChilds[i].setSubMapX("Hsb_RoofAreaScheduleParent",mapX);
				setDependencyOnEntity(tslChilds[i]);	
			}
		}
	// use unit from first tsl
	// unit data
		int nUnit = 0;
		double dUnitFactor = 1;
		if (tsls.length()>0)
		{
			nUnit=sUnits.find(tsls[0].propString(1));	
			//nDecimal = tsls[0].propInt(0);
		}
		if (nUnit ==1)	dUnitFactor =U(1)/U(1,"cm");
		else if (nUnit ==2)	dUnitFactor =U(1)/U(1,"m");
		else if (nUnit ==3)	dUnitFactor =U(1)/U(1,"inch");
		else if (nUnit ==3)	dUnitFactor =U(1)/U(1,"feet");		
		U(1,"mm");



	//endregion 		
	
	//region Trigger
	
	// TriggerAddArea
		String sTriggerAdd = T("|Add Dependency|");
		addRecalcTrigger(_kContext, sTriggerAdd);
		if (_bOnRecalc && _kExecuteKey==sTriggerAdd)
		{
		// prompt for areas
			Entity ents[0];
			PrEntity ssE(T("|Select roof calculation item(s)"), TslInst());
		  	if (ssE.go())
				ents.append(ssE.set());

		// validate scriptName
			for(int i=0;i<ents.length();i++)
			{
				TslInst tsl = (TslInst)ents[i];
				if (tsl.bIsValid() && (tsl.scriptName() == scriptName() || tsl.scriptName() == sScriptNameEdge) && _Entity.find(tsl)<0)
					_Entity.append(tsl);
			}

			setExecutionLoops(2);
			return;
		}

	// TriggerRemoveArea
		String sTriggerRemove = T("|Remove Dependency|");
		addRecalcTrigger(_kContext, sTriggerRemove );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemove )
		{
		// prompt for areas
			Entity ents[0];
			PrEntity ssE(T("|Select roof calculation item(s)|"), TslInst());
		  	if (ssE.go())
				ents.append(ssE.set());

		// validate scriptName
			for(int i=0;i<ents.length();i++)
			{
				TslInst tsl = (TslInst)ents[i];
				int n = _Entity.find(tsl);
				if (tsl.bIsValid() && (tsl.scriptName() == scriptName() || tsl.scriptName() == sScriptNameEdge) && n>-1)
					_Entity.removeAt(n);
			}
			setExecutionLoops(2);
			return;
		}	
					
	//endregion 

	//region Collect all roofplanes of dwg for preview
		Entity entsErps[0];
		ERoofPlane erps[0];
		int nColorErp=0;
		entsErps= Group().collectEntities(true,ERoofPlane(), _kModelSpace);
		for(int i=0;i<entsErps.length();i++)
		{
			ERoofPlane erp = (ERoofPlane)entsErps[i];
			if (erp.bIsValid())
			{
				if(isRubner)
				{ 
					// HSB-20108: In schedule mode collect only roof planes that have groups turned on 
					Group groupsI[]=erp.groups();
					for (int ig=0;ig<groupsI.length();ig++) 
					{ 
						if(groupsI[ig].groupVisibility(true)==_kIsOn)
						{ 
							erps.append(erp);
							nColorErp=erp.color();
							break;
						}
					}//next ig
				}
				else
				{ 
					erps.append(erp);
					nColorErp=erp.color();
				}
			}
		}			
	//endregion 
	
	//region Rubner
		if(isRubner)//HSB-20108: Include erps from selected tsls
		{ 
			ERoofPlane erpsSelected[0];		
			for (int i = 0; i < tsls.length(); i++)
			{
				Entity entsTsl[] = tsls[i].entity();
				for (int ii = 0; ii < entsTsl.length(); ii++)
				{
					ERoofPlane erpI = (ERoofPlane)entsTsl[ii];
					if (erpI.bIsValid() && erpsSelected.find(erpI) < 0)
						erpsSelected.append(erpI);
				}//next ii
			}

			for (int i=0;i<erpsSelected.length();i++) 
				if(erps.find(erpsSelected[i])<0)
					erps.append(erpsSelected[i]);
		}			
	//endregion 

	// get overall profile of erps
		Plane pnW(_PtW, _ZW);
		CoordSys csW(_PtW, _XW, _YW, _ZW);
		PlaneProfile ppRoof(csW);
		PLine plErps[0];
		for(int i=0;i<erps.length();i++)	
		{
			PLine pl = erps[i].plEnvelope();
			pl.projectPointsToPlane(pnW,_ZW);
			
			PlaneProfile pp(csW);
			pp.joinRing(pl, _kAdd); 
			pp.shrink(-dEps);// HSB-11712 blowup before merge to solve tolerance issues
			plErps.append(pl);
			ppRoof.unionWith(pp);
		}
		
	// merge little gaps
		double dMerge=U(100);
		ppRoof.shrink(-dMerge);
		ppRoof.shrink(dMerge+dEps);

	// order openings and contour rings of planeProfile
		PLine plRings[] = ppRoof.allRings();
		int bIsOp[] = ppRoof.ringIsOpening();
		
	// collect individual roofs
		PlaneProfile ppRoofs[0];
		for (int r=0;r<plRings.length();r++)
		{
			if (!bIsOp[r])
			{	
				PlaneProfile pp(CoordSys(_PtW, _XW,_YW,_ZW));

				plRings[r].offset(U(1));
				plRings[r].offset(-U(1));
				pp.joinRing(plRings[r],_kAdd);
				ppRoofs.append(pp);
			}
		}
		
	// collect order keys
		String sOrderKeys[0];
		for(int i=0;i<tsls.length();i++)
			sOrderKeys.append(tsls[i].opmName()+"_x_"+tsls[i].propString(0));
			
	// order by orderkey
		for(int i=0;i<tsls.length();i++)	
			for(int j=0;j<tsls.length()-1;j++)
			{
				String s1 = sOrderKeys[j];	
				String s2 = sOrderKeys[j+1];	
				if(s1>s2)
				{
					sOrderKeys.swap(j,j+1);	
					tsls.swap(j,j+1);	
				}
			}	

	// collect different orderKeys
		String sUniqueOrderKeys[0];
		for(int i=0;i<sOrderKeys.length();i++)	
			if (sUniqueOrderKeys.find(sOrderKeys[i])<0)
				sUniqueOrderKeys.append(sOrderKeys[i]);
		
	// set color
		if (nColor3!=_ThisInst.color())
			_ThisInst.setColor(nColor3);			
		
	// collect values
		String sCol0Values[]={T("|Material|")};
		String sCol1Values[]={T("|Area|") + "[" + sUnits[nUnit]+ "²]"};
		double dCol0Indent[]={0};
		TslInst tslsRows[]={TslInst()};
		
	// collect amount of different materials per type
		int nType;
		String sSumMaterials[sUniqueOrderKeys.length()];
		String sSumOrderKeys[sUniqueOrderKeys.length()];
		double dSumAreas[sUniqueOrderKeys.length()];
		// HSB-18550:
		double dSumAreasEaveRafter[sUniqueOrderKeys.length()];
		double dSumAreasAdded[sUniqueOrderKeys.length()];
		int bDump;
		
	// get subtotals
		for(int i=0;i<tsls.length();i++)	
		{
			int n=sUniqueOrderKeys.find(sOrderKeys[i]);
			if (n>-1)
			{
				sSumMaterials[n]=tsls[i].propString(0);
				sSumOrderKeys[n]=sOrderKeys[i];
				dSumAreas[n]+=tsls[i].map().getDouble("Area");
				// HSB-18550:
				dSumAreasEaveRafter[n]+=tsls[i].map().getDouble("AreaEaveRafter");
//				dSumAreasAdded[n]+=tsls[i].map().getDouble("AreaAdded");
			}
		}
		
	// append header
		if (sHeader.length()>0)
		{
		// add row
			sCol0Values.append(sHeader);
			sCol1Values.append("");	
			dCol0Indent.append(-1);	
			tslsRows.append(TslInst());
			
			sCol0Values.swap(0,1);
			sCol1Values.swap(0,1);
			dCol0Indent.swap(0,1);
			tslsRows.swap(0,1);				
		}
	// write row data
		for(int i=0;i<tsls.length();i++)	
		{
			double dArea=tsls[i].map().getDouble("Area");
			String sArea;
			sArea.formatUnit(dArea ,2,nDecimal);
			String sMaterial=tsls[i].propString(0);
			if (sMaterial.length()<1) sMaterial ="-";
			// HSB-18550:
			int nEaveRafter;
			int nAreaAdded;
			String sAreaEaveRafter;
			String sAreasAdded[0];
			String sStringsAdded[0];
			if(isBaufritz)
			{ 
				if(tsls[i].map().hasDouble("AreaEaveRafter"))
				{ 
					if(tsls[i].map().getDouble("AreaEaveRafter")>pow(dEps,2))
					{ 
						nEaveRafter=true;
						double dAreaEaveRafter=tsls[i].map().getDouble("AreaEaveRafter");
						sAreaEaveRafter.formatUnit(dAreaEaveRafter ,2,nDecimal);
					}
				}
//				if(tsls[i].map().hasDouble("AreaAdded"))
				if(tsls[i].map().hasMap("mapsAreaAdded"))
				{ 
					Map mapsAreaAdded=tsls[i].map().getMap("mapsAreaAdded");
					Map mapAdditionStrings=tsls[i].map().getMap("AdditionStrings[]");
					for (int im=0;im<mapsAreaAdded.length();im++) 
					{ 
						nAreaAdded=true;
						double dAreaAdded=mapsAreaAdded.getDouble(im); 
						String sAreaAdded;
						sAreaAdded.formatUnit(dAreaAdded ,2,nDecimal);
						sAreasAdded.append(sAreaAdded);
						String sStringI=mapAdditionStrings.getString(im);
						sStringsAdded.append(sStringI);
					}//next im
					
//					if(tsls[i].map().getDouble("AreaAdded")>pow(dEps,2))
//					{ 
//						nAreaAdded=true;
//						double dAreaAdded=tsls[i].map().getDouble("AreaAdded");
//						sAreaAdded.formatUnit(dAreaAdded ,2,nDecimal);
//					}
				}
			}
			
		// append decimal zeros
			if (sArea.find(".",0)<0 && nDecimal>0)
			{
				sArea+=".";
				for(int i=0;i<nDecimal;i++)sArea+="0";
			}
			
		// add type row
			if (i==0 || (i>0 && tsls[i].opmName()!=tsls[i-1].opmName()))
			{
				String s=tsls[i].opmName();
				int n=s.length()-scriptName().length()-1;
				s=s.right(n);
				
			// find corresponding prefix
				n=sOpmKeys.find(s);
				if (n>-1 && n<sPrefixes.length())
					s=sPrefixes[n];
								
				sCol0Values.append(s);
				sCol1Values.append("");		
				dCol0Indent.append(0);	
				tslsRows.append(TslInst());
			}
			
		// add row
			sCol0Values.append(sMaterial);
			sCol1Values.append(sArea);	
			dCol0Indent.append(dTxtH3);
			tslsRows.append(tsls[i]);
			
		// add subtotal
			if (i==tsls.length()-1 || (i<tsls.length()-1 && sOrderKeys[i]!=sOrderKeys[i+1]))	
			{
				int n=sSumOrderKeys.find(sOrderKeys[i]);
				sCol0Values.append("Σ " + sMaterial);
				
				sArea.formatUnit(dSumAreas[n],2,nDecimal);
			// append decimal zeros
				if (sArea.find(".",0)<0 && nDecimal>0)
				{
					sArea+=".";
					for(int i=0;i<nDecimal;i++)sArea+="0";
				}				
				sCol1Values.append(sArea);					
				dCol0Indent.append(dTxtH3);
				tslsRows.append(TslInst());
			}
			
			if(nEaveRafter)
			{ 
			// HSB-18550:
				sArea=sAreaEaveRafter;
				if (sArea.find(".",0)<0 && nDecimal>0)
				{
					sArea+=".";
					for(int i=0;i<nDecimal;i++)sArea+="0";
				}
	
			// add type row
				if (i==0 || (i>0 && tsls[i].opmName()!=tsls[i-1].opmName()))
				{
					String s = tsls[i].opmName();
					int n = s.length()-scriptName().length()-1;
					s = s.right(n);
					
				// find corresponding prefix
					n =sOpmKeys.find(s);
					if (n>-1 && n<sPrefixes.length())
						s = sPrefixes[n];
									
//					sCol0Values.append(s);
					sCol0Values.append("Sparrenkopf");
					sCol1Values.append("");		
					dCol0Indent.append(0);	
					tslsRows.append(TslInst());
				}
	
			// add row
				sCol0Values.append(sMaterial);
				sCol1Values.append(sArea);	
				dCol0Indent.append(dTxtH3);
				tslsRows.append(tsls[i]);
				
			// add subtotal
				if (i==tsls.length()-1 || (i<tsls.length()-1 && sOrderKeys[i]!=sOrderKeys[i+1]))	
				{
					int n = sSumOrderKeys.find(sOrderKeys[i]);
					sCol0Values.append("Σ " + sMaterial);
					
					sArea.formatUnit(dSumAreasEaveRafter[n],2,nDecimal);
				// append decimal zeros
					if (sArea.find(".",0)<0 && nDecimal>0)
					{
						sArea+=".";
						for(int i=0;i<nDecimal;i++)sArea+="0";
					}				
					sCol1Values.append(sArea);					
					dCol0Indent.append(dTxtH3);
					tslsRows.append(TslInst());
				}
			}
			if(nAreaAdded)
			{ 
			// HSB-18550:
				for (int iA=0;iA<sAreasAdded.length();iA++) 
				{ 
					sArea=sAreasAdded[iA];
					String sStringAddedI=sStringsAdded[iA];
					if (sArea.find(".",0)<0 && nDecimal>0)
					{
						sArea+=".";
						for(int i=0;i<nDecimal;i++)sArea+="0";
					}
		
				// add type row
					if (i==0 || (i>0 && tsls[i].opmName()!=tsls[i-1].opmName()))
					{
						String s = tsls[i].opmName();
						int n = s.length()-scriptName().length()-1;
						s = s.right(n);
						
					// find corresponding prefix
						n =sOpmKeys.find(s);
						if (n>-1 && n<sPrefixes.length())
							s = sPrefixes[n];
										
	//					sCol0Values.append(s);
						sCol0Values.append("Zusätzliche Fläche");
//						sCol0Values.append(sStringAddedI);
						sCol1Values.append("");		
						dCol0Indent.append(0);	
						tslsRows.append(TslInst());
					}
		
				// add row
//					sCol0Values.append(sMaterial);
					sCol0Values.append(sStringAddedI);
					sCol1Values.append(sArea);	
					dCol0Indent.append(dTxtH3);
					tslsRows.append(tsls[i]);
					
				// add subtotal
					if (i==tsls.length()-1 || (i<tsls.length()-1 && sOrderKeys[i]!=sOrderKeys[i+1]))	
					{
						int n = sSumOrderKeys.find(sOrderKeys[i]);
//						sCol0Values.append("Σ " + sMaterial);
						sCol0Values.append("Σ " + sStringAddedI);
						
//						sArea.formatUnit(dSumAreasAdded[n],2,nDecimal);
					// append decimal zeros
						if (sArea.find(".",0)<0 && nDecimal>0)
						{
							sArea+=".";
							for(int i=0;i<nDecimal;i++)sArea+="0";
						}				
						sCol1Values.append(sArea);					
						dCol0Indent.append(dTxtH3);
						tslsRows.append(TslInst());
					}
				}//next iA
			}
		}	
		
		
		
	// add new header if edges found
		// append columns 3 and 4 for angles
		int nNumRows=sCol0Values.length();
		String sCol2Values[nNumRows];
	
		if (tslEdges.length()>0)
		{
			sCol0Values.append(T("|Roof Edges|"));
			sCol1Values.append("");	
			sCol2Values.append("");	
			
			dCol0Indent.append(-1);	

			sCol0Values.append("Type");
			sCol1Values.append(T("|Length|") + "[" + sUnits[nUnit]+ "]");
			sCol2Values.append(T("|Angles|") + "[°]");
			
			dCol0Indent.append(0);	
			tslsRows.append(TslInst());	
			
		// get hardware data	
			HardWrComp hwcs[0];
			for (int i=0;i<tslEdges.length();i++) 
			{ 
				TslInst tslEdge = tslEdges[i]; 
				hwcs.append(tslEdge.hardWrComps()); 
			}
		
		// order components
			for (int i=0;i<hwcs.length();i++) 
				for (int j=0;j<hwcs.length()-1;j++)
					if (hwcs[j].articleNumber()>hwcs[j+1].articleNumber())
						hwcs.swap(j,j+1);
						
		// append components by type
			double dSumLength;
			for (int i=0;i<hwcs.length();i++) 
			{
				int bOut = i==hwcs.length()-1;
				HardWrComp hwc = hwcs[i];
				String sArticle = hwc.articleNumber();
				double dLength = hwc.dScaleX()*dUnitFactor;
				String sPitch, sBend;
				sPitch.formatUnit(hwc.dAngleA(),2,1);
				sBend.formatUnit(hwc.dAngleB(),2,1);
				
				String sCompareyKey1 = sArticle+sPitch+sBend;
				String sCompareyKey2;
				if (i<hwcs.length()-1)
				{
					HardWrComp hwc2 = hwcs[i+1];
					String sArticle2 = hwc2.articleNumber();
					String sPitch2, sBend2;
					sPitch2.formatUnit(hwc2.dAngleA(),2,1);
					sBend2.formatUnit(hwc2.dAngleB(),2,1);
					sCompareyKey2 = sArticle2+sPitch2+sBend2;
				}
				
				
				if (!bOut && sCompareyKey1!=sCompareyKey2)//sArticle!=hwcs[i+1].articleNumber())
					bOut=true;
				
				dSumLength+=dLength;
				if(bOut)
				{
				
					sCol0Values.append(sArticle);
					
					String sValue;
					sValue.formatUnit(dSumLength ,2,nDecimal);
				
				// append decimal zeros
					if (sValue.find(".",0)<0 && nDecimal>0)
					{
						sValue+=".";
						for(int i=0;i<nDecimal;i++)sValue+="0";
					}
					sCol1Values.append(sValue);
					dCol0Indent.append(0);
					
				// append pitch and/or bend angle
					sValue=sPitch=="0"?"":sPitch;
					if (sValue=="")
						sValue=sBend=="0"?"":"0/"+sBend;
					else
						sValue+=sBend=="0"?"":"/"+sBend;
					sCol2Values.append(sValue);
					
					tslsRows.append(TslInst());
					dSumLength=0;
				}
			}
		}
		
		
	// display
		Display dp(nColor3);
		dp.dimStyle(sDimStyle3);
		dp.textHeight(dTxtH3);

		double dYTxt = dp.textHeightForStyle("O",sDimStyle3);
		
	// get scale text dimensions to current
		double dFactor = 1;
		if (abs(dYTxt-dTxtH3)>dEps && dYTxt > 0)
			dFactor  = dTxtH3/dYTxt;	
		
		
	// get column 1+2 widths
		Unit(1,"mm");
		double dWidths[0], dWidthTotal;
		String sTempValues[0];
		sTempValues=sCol0Values;
		for(int k=0;k<2;k++)
		{
			double dMax;
			for(int i=0;i<sTempValues.length();i++)
			{
				double d = dp.textLengthForStyle(sTempValues[i],sDimStyle3)*dFactor+ dTxtH3;
				if (k==0) d+=dCol0Indent[i];
				if (d>dMax)
					dMax = d;
				
			}
			sTempValues=sCol1Values;
			dWidths.append(dMax);
			dWidthTotal+=dMax;
		
		// add graphics column
			if (k==1)
			{
				if (dMax>U(1000)) dMax = U(1000);
				dWidths.append(dMax);
				dWidthTotal+=dMax;	
			}		
		}
		double dRowHeight = 3*dTxtH3;

	// draw columns
		Point3d ptTxt=_Pt0;
		for(int i=0;i<sCol1Values.length();i++)
		{
			double dXFlag = 1;
			Point3d pt = ptTxt;
			pt.transformBy(_XW*dCol0Indent[i]);
			if (dCol0Indent[i]<0)
			{
				dXFlag =0;
				pt = ptTxt+_XW*.5* dWidthTotal;
			}
	
			
			dp.draw(sCol0Values[i], pt, _XW,_YW,dXFlag ,0);
			
			pt = ptTxt+_XW*(dWidths[0]+dWidths[1]);
			//if (i==0) pt.transformBy(_XW*dTxtH3);//pt.vis(4);
			dp.draw(sCol1Values[i], pt, _XW,_YW,-1,0);
			
			PLine plBox;
			plBox.createRectangle(LineSeg(ptTxt+_YW*.5*dRowHeight -_XW*dTxtH3, ptTxt+_XW*(dWidthTotal+dTxtH3)-_YW*.5*dRowHeight), _XW,_YW);
			dp.draw(plBox);//plBox.vis(2);
			
			// first vertical grid line
			double dColWidth = dWidths[0];
			PLine pl (ptTxt+_XW*dColWidth +_YW*.5*dRowHeight,ptTxt+_XW*dColWidth-_YW*.5*dRowHeight);
			if (dXFlag>0)dp.draw(pl);pl.vis(2);
			
			// second vertical grid line
			dColWidth +=dWidths[1]+dTxtH3;
			pl =PLine(ptTxt+_XW*dColWidth +_YW*.5*dRowHeight,ptTxt+_XW*dColWidth-_YW*.5*dRowHeight);
			if (dXFlag>0)dp.draw(pl);//pl.vis(2);			
			pt = ptTxt+_XW*(dWidths[0]+dWidths[1]+.5*dWidths[2]+dTxtH3);
			pt.vis(6);

		// draw pitches if any
			if (sCol2Values[i].length()>0)
				dp.draw(sCol2Values[i], pt, _XW,_YW,0,0);
		//HSB - 19480: make sure the position gets updated
			ptTxt.transformBy(-_YW*dRowHeight);
			
		// draw preview
			if (tslsRows.length()>i && tslsRows[i].bIsValid())
			{
				Display dp2(nColorErp);
			
			// collect plines of tsl
				PLine plines[0];
				PLine plOpenings[0];
				Map mapPLines = tslsRows[i].map().getMap("PLine[]");
				for(int j=0;j<mapPLines.length();j++)		
				{
					int bIsOpening = mapPLines.keyAt(j)=="opening";
					PLine pl = mapPLines.getPLine(j);
					pl.projectPointsToPlane(pnW,_ZW);
					if (bIsOpening)
						plOpenings.append(pl);					
					else
					{
						plines.append(pl);
					}
				}
			
			// find intersecting roof outline	
				PlaneProfile ppRoof;
				for(int k=0;k<ppRoofs.length();k++)	
				{
					int bFound;
					for(int j=0;j<plines.length();j++)
					{
						PlaneProfile pp = ppRoofs[k];
						pp.intersectWith(PlaneProfile(plines[j]));
						if (pp.area()>pow(dEps,2))
						{
							ppRoof=ppRoofs[k];
							bFound=true;
							break;	
						}
					}
					if (bFound)break;
				}				
			
			// get dimensions of detected outline	
				LineSeg segRoof = ppRoof.extentInDir(_XW);	
				segRoof .vis(2);
				double dXRoof = abs(_XW.dotProduct(segRoof.ptStart()-segRoof.ptEnd()));
				double dYRoof = abs(_YW.dotProduct(segRoof.ptStart()-segRoof.ptEnd()));			
				if (dXRoof<=dEps || dYRoof<=dEps)continue;

			// calc scaling to cell				
				double dScaleX= (dWidths[2]-.5*dTxtH3)/dXRoof;		
				double dScaleY=(dRowHeight-.5*dTxtH3)/dYRoof;
				double dScaleGraphics = dScaleX;
				if(dScaleGraphics>dScaleY)dScaleGraphics=dScaleY;
				ppRoof.vis(2);
					
				CoordSys cs;
				cs.setToAlignCoordSys(segRoof.ptMid(), _XW,_YW,_ZW, pt, _XW*dScaleGraphics ,_YW*dScaleGraphics ,_ZW*dScaleGraphics );
				PlaneProfile pp = ppRoof;
				pp.transformBy(cs);				
				
				
			// collect and draw intersecting individual roof envelopes of entire roof
			// outline
				dp2.draw(pp);
				for(int j=0;j<plErps.length();j++)
				{
					PLine pl = plErps[j];
					PlaneProfile ppTest = ppRoof;
					ppTest.intersectWith(PlaneProfile(plErps[j]));
					if(ppTest.area()>pow(dEps,2))
					{
						pl.transformBy(cs);	
						dp2.draw(pl);
					}
				}	
				
			// current
				dp2.color(tslsRows[i].propInt(1));
				PlaneProfile ppCurrent(CoordSys(_Pt0, _XW,_YW,_ZW));
				for(int j=0;j<plines.length();j++)		
				{
					PLine pl = plines[j];
					pl.projectPointsToPlane(pnW,_ZW);
					pl.transformBy(cs);	
					ppCurrent.joinRing(pl, _kAdd);					
				}		
				for(int j=0;j<plOpenings.length();j++)		
				{
					PLine pl = plOpenings[j];
					pl.projectPointsToPlane(pnW,_ZW);
					pl.transformBy(cs);	
					ppCurrent.joinRing(pl, _kSubtract);
										
				}				
				dp2.draw(ppCurrent, _kDrawFilled);
			}		
//			ptTxt.transformBy(-_YW*dRowHeight);
		}	
		return;	
	}
// END schedule mode//endregion
	
	
// General//region
	String sMaterialName=T("|Material|");	
	PropString sMaterial(nStringIndex++, "", sMaterialName);	//1
	sMaterial.setDescription(T("|Defines the name of the roof|"));
	sMaterial.setCategory(sCategoryGeneral);	
	
	String sUnitName=T("|Unit|");	
	PropString sUnit(nStringIndex++, sUnits, sUnitName,2);	//2
	sUnit.setDescription(T("|Defines the unit|"));
	sUnit.setCategory(sCategoryDisplay);

	String sDecimalName=T("|Decimals|");	
	int nDecimals[] = {0,1,2,3,4};
	PropInt nDecimal(nIntIndex++, 0, sDecimalName);	//0
	nDecimal.setDescription(T("|Defines the qty of decimals|"));
	nDecimal.setCategory(sCategoryDisplay);
		
	String sHatchName=T("|Pattern|");	
	String sHatchs[]={T("|None|")};
	sHatchs.append(_HatchPatterns);
	PropString sHatch(nStringIndex++, sHatchs, sHatchName);	//5
	sHatch.setDescription(T("|Defines the hatch pattern|"));
	sHatch.setCategory(sCategoryHatch );
	
	String sHatchScaleName=T("|Scale|");	
	PropDouble dHatchScale(nDoubleIndex++, U(30), sHatchScaleName);	//0
	dHatchScale.setDescription(T("|Defines the scale of the hatch pattern|"));
	dHatchScale.setCategory(sCategoryHatch );	

	
	PropString sDimStyle(nStringIndex++,sDimStyles,sDimStyleName);//0
	sDimStyle.setCategory(sCategoryDisplay);
	
	String sTxtHName=T("|Text Height|");	
	PropDouble dTxtH(nDoubleIndex++, U(30), sTxtHName);	
	dTxtH.setDescription(T("|Sets the text height|"));
	dTxtH.setCategory(sCategoryDisplay);

	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, 1, sColorName);	
	nColor.setDescription(T("|Defines the color|"));
	nColor.setCategory(sCategoryDisplay);

	
// set color
	if (nColor!=_ThisInst.color())
		_ThisInst.setColor(nColor);	
	//endregion
	int nEaveRafter;
	if(isBaufritz && nMode==0)
	{ 
		// extra option for the consideration of rafters at eave area
		category=sPrefixes[0];
		String sEaveRafterName=T("Sparrenkopf");
		PropString sEaveRafter(nStringIndex++, sNoYes, sEaveRafterName);
		sEaveRafter.setDescription(T("|Defines whether the area of rafters should be calculated.|"));
		sEaveRafter.setCategory(category);
		nEaveRafter=sNoYes.find(sEaveRafter);
	}
	
	
// get and validate roofplane//region
	ERoofPlane erp;
	for (int i = 0; i < _Entity.length(); i++)
	{
		Entity ent=_Entity[i];
		setDependencyOnEntity(ent);
		if (ent.bIsKindOf(ERoofPlane()))
			erp=(ERoofPlane)ent;	
	}
	if (!erp.bIsValid())
	{	
		reportMessage("\n"+scriptName()+" "+T("|Roofplane could not be found|"));
		eraseInstance();
		return;		
	}

// Collect potential opening roofplanes	
	ERoofPlane erps[] = CollectERoofPlanes();
	{ 
		int n = erps.find(erp);
		if (n>-1)
			erps.removeAt(n);
	}
	ERoofPlane erpSubtractions[] = CollectERoofPlaneTypes(erps, _kRPTOpening, erp);

// declare standards
	CoordSys cs;
	Vector3d vecX,vecY,vecZ;
	Point3d ptOrg;
	cs = erp.coordSys(); 
	ptOrg = cs.ptOrg();
	vecX = cs.vecX();
	vecY = cs.vecY();
	vecZ = cs.vecZ();
	Plane pnErp (ptOrg, vecZ);
	PLine plEnvelope = erp.plEnvelope();
	
// validate roofplane by its pline
	if (plEnvelope.area()<pow(dEps,2) || plEnvelope.vertexPoints(true).length()<3)
	{
		reportMessage("\n" + scriptName() + ": " +T("|polyline of roofplane is invalid.|") + " " + T("|Tool will be deleted.|"));
		eraseInstance();
		return;
	}
	
	_Pt0 = Line(_Pt0,_ZW).intersect(pnErp,0);
	_Pt0.vis(20);	
	//endregion
//return;
// get edit in place mode
	int bEditInPlace=_Map.getInt("EditInPlace");

// relocate grips on dragging _Pt0
	if (_kNameLastChangedProp=="_Pt0" && _PtG.length()>2)
	{
	// get grips
		Map mapGrips = _Map.getMap("GripVector[]");
		for(int i=0;i<_PtG.length();i++)
			if (mapGrips.hasVector3d(i))
				_PtG[i] = _PtW+mapGrips.getVector3d(i);
	}
	for(int i=0;i<_PtG.length();i++)
		_PtG[i] = Line(_PtG[i], _ZW).intersect(pnErp,0);
	
	//reportMessage("\n" + _kNameLastChangedProp + " " + _kNameLastChangedProp.find("_PtG", 0));
// Grip points should stay inside roof area
	if(_kNameLastChangedProp.find("_PtG",0) > -1)
	{
		String sPtG = _kNameLastChangedProp;		
		sPtG = sPtG.mid(4,3);
		int nPtG = sPtG.atoi();
		
		if(PlaneProfile(plEnvelope).pointInProfile(_PtG[nPtG])==_kPointOutsideProfile)
		{
			_PtG[nPtG] = plEnvelope.closestPointTo(_PtG[nPtG]);
		}
	}

// get polylines
	Entity eplSubtractions[0], eplAdds[0];
	PLine plSubtractions[0];
	PLine plAdds[0];
	
// not 'edit in place' mode	
	Map mapSubtr=_Map.getMap("Subtraction[]"), mapAdds=_Map.getMap("Addition[]");
	if (!bEditInPlace)
	{	
		for (int i = 0; i < mapSubtr.length(); i++)
		{
			Entity ent = mapSubtr.getEntity(i);
			EntPLine epl =(EntPLine)ent;
			if (epl.bIsValid())
			{
				eplSubtractions.append(epl);
				plSubtractions.append(epl.getPLine());
			}
		}
		
		for (int i = 0; i < mapAdds.length(); i++)
		{
			Entity ent = mapAdds.getEntity(i);
			EntPLine epl =(EntPLine)ent;
			if (epl.bIsValid())
			{
				eplAdds.append(epl);
				PLine pl = epl.getPLine();
				pl.projectPointsToPlane(pnErp, _ZW);
				plAdds.append(pl);
			}
		}
		
	// get walls
		PlaneProfile ppWall(CoordSys(_PtW, _XW,_YW,_ZW));
		for(int i=0;i<_Entity.length();i++)
		{
			Entity ent=_Entity[i];
			if (!ent.bIsKindOf(Wall()))continue;
		// first attempt: get outline from shrinkWrapBody
			Wall wall=(Wall)ent;
			Body bd=wall.shrinkWrapBody(true, true,false,true, false); 
			PlaneProfile pp=bd.shadowProfile(Plane(_PtW,_ZW));

		// second attempt: get shadow of real as shrinkwrap fails especially when corner cleanup has warnings
			if (pp.area()<pow(dEps,2))
			{
				bd=ent.realBody();
				pp=bd.shadowProfile(Plane(_PtW,_ZW));	
			}
		// third attempt and final: if this still fails use the outline
			if (pp.area()<pow(dEps,2))
			{
				Element el = (Element)ent;
				el.plOutlineWall().vis(1);			
				ppWall.joinRing(el.plOutlineWall(),_kAdd);	
			}			
			else if (ppWall.area()<pow(dEps,2))
				ppWall=pp;
			else
				ppWall.unionWith(pp);
		}	
		if (ppWall.area()>pow(dEps,2) && nMode!=2) // do not consider walls for roof areas
		{
			ppWall.shrink(-U(10));
			ppWall.shrink(U(10));
			
		// get rings and remove openings
			PLine plRings[]=ppWall.allRings();
			int bIsOp[]=ppWall.ringIsOpening();
			ppWall.removeAllRings();
			// HSB-19192: pline defintiion for inner area was found, 
			// ignore the walls
			if(!(nMode==1 && mapSubtr.length()>0))
			for (int r=0;r<plRings.length();r++)
				if (!bIsOp[r])
				{
					ppWall.joinRing(plRings[r],_kAdd);
					plSubtractions.append(plRings[r]);
				}
			//ppWall.vis(40);
//			if(nMode==1 && mapSubtr.length()==0)
//			{ 
//				// inner area
//				for (int r=0;r<plRings.length();r++)
//					if (bIsOp[r])
//					{
//						plRings[r].transformBy(_ZW * U(200));
//						plRings[r].vis(2);
//						plRings[r].transformBy(-_ZW * U(200));
//						
//						plSubtractions.append(plRings[r]);
//					}
//			}
		}
		if (0 && _bOnDebug)
		{ 
			Display dp(40);
			dp.draw(ppWall,_kDrawFilled);
		}		
	}
	
// if no polylines were found, try to rebuild from grips
	if (plSubtractions.length()<1)
	{
		PLine plSubtraction(erp.coordSys().vecZ());
		for (int i = 0; i < _PtG.length(); i++)
			plSubtraction.addVertex(_PtG[i]);	
		plSubtraction.close();
		if (plSubtraction.area()>pow(dEps,2))
		{
			if (nMode==0)
			{
				PlaneProfile pp(cs);
				pp.joinRing(plEnvelope , _kAdd);
				pp.joinRing(plSubtraction, _kSubtract);
				
			// get rings and remove openings
				PLine plRings[] = pp.allRings();
				int bIsOp[] = pp.ringIsOpening();
				pp.removeAllRings();
				for (int r=0;r<plRings.length();r++)
					if (!bIsOp[r])
						plSubtractions.append(plRings[r]);
				if(nMode==1)
				{ 
				// inner area
					reportMessage("\n"+scriptName()+" "+T("|Inner area|"));
					
				}
			}
			else if (nMode==1)
			{					
				plSubtractions.append(plSubtraction);
			}
		}
	}
	for (int i = 0; i < plSubtractions.length(); i++)
	{
		plSubtractions[i].projectPointsToPlane(pnErp, _ZW);
		plSubtractions[i].vis(2);
	}

//if(nMode < 2)
if(nMode <= 2)
{
// define add/subtraction trigger entries, swap when in inner area mode to reverse behaviour
	String sPlineTriggers[] = {T("|Add subtractive Polyline(s)|"),T("|Add additive Polyline(s)|")};
	if (nMode==1)sPlineTriggers.swap(0,1);
	
// add subtraction pline(s)
	String sAddSubtractionPlineTrigger = sPlineTriggers[0];
	if(nMode < 2)
	if (!bEditInPlace)
		addRecalcTrigger(_kContext, sAddSubtractionPlineTrigger );
	if (_bOnRecalc && _kExecuteKey==sAddSubtractionPlineTrigger )
	{
		PrEntity ssPline(T("|Select subtractive polyline(s)|"), EntPLine());
  		if (ssPline.go())
		{
			Entity ents[0];
    		ents=ssPline.set();
			for (int i = 0; i < ents.length(); i++)
			{
				EntPLine epl = (EntPLine)ents[i];
				if (!epl.bIsValid() || _Entity.find(epl)>-1) continue;
				_Entity.append(epl);
				mapSubtr.appendEntity("pline",epl);
			}
		}
		_Map.setMap("Subtraction[]",mapSubtr);
		setExecutionLoops(2);
		return;	
	} 

// add subtraction pline(s)
	String sAddAdditionPlineTrigger=sPlineTriggers[1];
	if (!bEditInPlace)	
		addRecalcTrigger(_kContext, sAddAdditionPlineTrigger );
	if (_bOnRecalc && _kExecuteKey==sAddAdditionPlineTrigger )
	{
		PrEntity ssPline(T("|Select additive polyline(s)|"), EntPLine());
		Map mapStringsAdd=_Map.getMap("AdditionStrings[]");
  		if (ssPline.go())
		{
			Entity ents[0];
    		ents=ssPline.set();
			for (int i=0;i<ents.length();i++)
			{
				EntPLine epl=(EntPLine)ents[i];
				if (!epl.bIsValid() || _Entity.find(epl)>-1) continue;
				_Entity.append(epl);
				String sString=getString("Flächenname eingeben");
				mapAdds.appendEntity("pline", epl);
				mapStringsAdd.appendString("String",sString);
			}
		}
		_Map.setMap("Addition[]", mapAdds);	
		_Map.setMap("AdditionStrings[]", mapStringsAdd);	
		setExecutionLoops(2);
		return;	
	} 
	
// remove pline(s)
	String sRemovePlineTrigger=T("|Remove Polyline(s)|");
	if (!bEditInPlace)
		addRecalcTrigger(_kContext, sRemovePlineTrigger );
	if (_bOnRecalc && _kExecuteKey==sRemovePlineTrigger )
	{
		PrEntity ssPline(T("|Select polyline(s) to be removed|"), EntPLine());
		Map mapStringsAdd=_Map.getMap("AdditionStrings[]");
		String sStrings[0];
		for (int im=0;im<mapStringsAdd.length();im++) 
		{ 
			sStrings.append(mapStringsAdd.getString(im));
		}//next im
		
  		if (ssPline.go())
		{
			Entity ents[0];
    		ents=ssPline.set();
			for (int i=0;i<ents.length(); i++)
			{
				EntPLine epl=(EntPLine)ents[i];
				int n=_Entity.find(epl);
				if (!epl.bIsValid() || n<0) continue;
		
			// find in subtraction map
				for (int j=eplSubtractions.length()-1; j>=0;j--)
					if (epl==eplSubtractions[j])
					{
						eplSubtractions.removeAt(j);
						_Entity.removeAt(n);	
					}
			// reset subtractions
				mapSubtr = Map();
				for (int j=0;j<eplSubtractions.length();j++)
					mapSubtr.appendEntity("pline",eplSubtractions[j]);
				_Map.setMap("Subtraction[]", mapSubtr );
			
			// find in addition map
				for (int j=eplAdds.length()-1;j>=0;j--)
					if (epl==eplAdds[j])
					{
						eplAdds.removeAt(j);
						_Entity.removeAt(n);
						sStrings.removeAt(j);
					}						
			// reset adds
				mapAdds= Map();
				for (int j=0;j<eplAdds.length();j++)
					mapAdds.appendEntity("pline",eplAdds[j]);
				mapStringsAdd= Map();
				for (int j=0;j<sStrings.length();j++)
					mapStringsAdd.appendString("pline",sStrings[j]);
				_Map.setMap("Addition[]", mapAdds);
				_Map.setMap("AdditionStrings[]", mapStringsAdd);
			}// next i
		}
		setExecutionLoops(2);
		return;	
	} 	

// add grip trigger
	String sAddGripTrigger = T("|Add Grip(s)|");
	if (bEditInPlace)
		addRecalcTrigger(_kContext, sAddGripTrigger );
	if (_bOnRecalc && _kExecuteKey==sAddGripTrigger )
	{
	// prompt for point input
		Point3d pts[0];
		while(1)
		{
			PrPoint ssP(TN("|Select point|")); 
			if (ssP.go()==_kOk) 
				pts.append(Line(ssP.value(), _ZW).intersect(pnErp,0)); // append the selected points to the list of grippoints _PtG
			else
				break;	
		}

	// find closest segment per point	
		Point3d ptsGrips[0];
		ptsGrips = _PtG;
	
		for(int p=0;p<pts.length();p++)
		{
			Point3d pt = pts[p];
			
		// collect segments	
			double dMin = U(10e6);
			int nInd=-1;
			for(int i=0;i<ptsGrips .length();i++)
			{
				int n = i+1;
				if (i==ptsGrips.length()-1)n=0;
				LineSeg seg(ptsGrips[i], ptsGrips[n]);
				
				Point3d ptNext = seg.closestPointTo(pt);
				double dA = Vector3d(ptNext-pt).length();
				double dB = Vector3d(ptsGrips[i]-pt).length();
				double dC = Vector3d(ptsGrips[n]-pt).length();
				if (dB>dEps && dC>dEps && dA<dMin)
				{
					dMin=dA;	
					nInd=i;
				}
			}
			
		// insert after index
			if (nInd>-1)
				ptsGrips.insertAt(nInd+1,pt);

		}// next p
		
		if (ptsGrips.length()!=_PtG.length())
			_PtG=ptsGrips;
		setExecutionLoops(2);
		return;	
	} 		

// remove grip trigger
	String sRemoveGripTrigger = T("|Remove Grip(s)|");
	if (bEditInPlace)
		addRecalcTrigger(_kContext, sRemoveGripTrigger );
	if (_bOnRecalc && _kExecuteKey==sRemoveGripTrigger )
	{
	// prompt for point input
		Point3d pts[0];
		while(1)
		{
			PrPoint ssP(TN("|Select point|")); 
			if (ssP.go()==_kOk) 
				pts.append(Line(ssP.value(), _ZW).intersect(pnErp,0)); // append the selected points to the list of grippoints _PtG
			else
				break;	
		}		
		
		if (pts.length()<_PtG.length()-3)
			for(int p=0;p<pts.length();p++)
			{
				Point3d pt = pts[p];
				double dMin = U(10e6);
				int nInd=-1;
				for(int i=0;i<_PtG .length();i++)
				{
					double dA = Vector3d(_PtG[i]-pt).length();
					if (dA<dMin)
					{
						dMin=dA;	
						nInd=i;						
					}	
				}
				
				if (nInd>-1)
					_PtG.removeAt(nInd);
			}// next p
		
		setExecutionLoops(2);
		return;			
	}	
}

// hatch index
	int nHatch = sHatchs.find(sHatch);
	int nUnit = sUnits.find(sUnit);

// declare area
	PlaneProfile ppArea(cs);
	// only for roof area
	PlaneProfile ppAreasAdded[0];
// extra area of the rafters
	double dAreaEaveRafter;
// mode 1 = EAVE AREA
	if (nMode==0)
	{
	// get eave area
		ppArea.joinRing(plEnvelope , _kAdd);
		for (int i = 0; i < plSubtractions.length(); i++)
		{
			// HSB-19481: check if pp operation successful
			PlaneProfile ppSubI(plSubtractions[i]);
			PlaneProfile ppTest(plSubtractions[i]);
			int bInter=ppTest.intersectWith(ppArea);
			if(bInter)
			{ 
//				ppArea.subtractProfile(ppSubI);
				ppArea.subtractProfile(ppTest);
				ppArea.shrink(-U(1));
				ppArea.shrink(U(1));
			}
			else
			{ 
				// try
				ppTest=ppSubI;
				ppTest.shrink(dEps);
				bInter=ppTest.intersectWith(ppArea);
				if(bInter)
				{ 
					ppArea.subtractProfile(ppTest);
					ppArea.shrink(-U(1));
					ppArea.shrink(U(1));
				}
			}
//			ppArea.joinRing(plSubtractions[i], _kSubtract);
		}
		
	// add rings
		for (int i = 0; i < plAdds.length(); i++)
		{
			PlaneProfile ppA(cs);
			ppA.joinRing(plEnvelope, _kAdd);
			PlaneProfile ppB(cs);
			ppB.joinRing(plAdds[i], _kAdd);
			ppA.intersectWith(ppB);
	
			PLine plRings[] = ppA.allRings();
			int bIsOp[] = ppA.ringIsOpening();
			for (int r=0;r<plRings.length();r++)
				if (!bIsOp[r])
					ppArea.joinRing(plRings[r],_kAdd);
		}
		if(isBaufritz && nEaveRafter)
		{ 
		// consider extra area from Sparrenkopf at eave area
			// total body of rafters
			Body bdRafters;
			// bounding area
			Body bdArea;
			{ 
				PLine pls[]=ppArea.allRings(true,false);
				PLine plsSubtract[]=ppArea.allRings(false,true);
				for (int ipl=0;ipl<pls.length();ipl++) 
				{ 
					Body bdI(pls[ipl],cs.vecZ()*U(10e3),0);
					bdArea.addPart(bdI);
				}//next ipl
				for (int ipl=0;ipl<plsSubtract.length();ipl++) 
				{ 
					Body bdI(plsSubtract[ipl],cs.vecZ()*U(10e3),0);
					bdArea.subPart(bdI);
				}//next ipl
			}
//			bdArea.vis(5);
			PLine plErp=erp.plEnvelope();
			PlaneProfile ppErp(plErp);
			ppErp.shrink(-U(100));
			ppErp.vis(1);
			ppErp.shrink(U(100));
		// collect all Roof elements
			Entity entEroofs[]=Group().collectEntities(true,ElementRoof(),_kModelSpace);
			ElementRoof eRoofs[0];
//			Body bdRafters[0];
			double dAreaTopRemove;
			for (int ient=0;ient<entEroofs.length();ient++) 
			{ 
				ElementRoof eRoofI=(ElementRoof)entEroofs[ient];
				if(!eRoofI.bIsValid())continue;
				Vector3d vecZi=eRoofI.coordSys().vecZ();
				vecZi.vis(cs.ptOrg());
				if(abs(abs(vecZi.dotProduct(cs.vecZ()))-1.0)>dEps)continue;
				
				if(abs(vecZi.dotProduct(eRoofI.coordSys().ptOrg()-cs.ptOrg()))>U(400))continue;
				PlaneProfile ppI(cs);
				ppI.joinRing(eRoofI.plEnvelope(),_kAdd);
				PlaneProfile ppIntersectI=ppI;
				if(!ppIntersectI.intersectWith(ppErp))continue;
				
				Beam beamsI[]=eRoofI.beam();
				if(beamsI.length()==0)continue;
				for (int ib=0;ib<beamsI.length();ib++) 
				{ 
					Beam bmI=beamsI[ib];
					Body bdI=bmI.realBody();
					PlaneProfile ppBmI=bdI.shadowProfile(Plane(cs.ptOrg(),cs.vecZ()));
					if(!ppBmI.intersectWith(ppArea))continue;
					
					bdI.intersectWith(bdArea);
					double dAreaTopRemoveI=bdI.shadowProfile(Plane(cs.ptOrg(),cs.vecZ())).area();
					dAreaTopRemove+=dAreaTopRemoveI;
//					bdI.vis(3);
					bdRafters.addPart(bdI);
				}//next ib
//				ppI.vis(4);
			}//next ient
			bdRafters.vis(3);
			dAreaEaveRafter=bdRafters.area();
			dAreaEaveRafter-=dAreaTopRemove;
		// remove projected area. On top side there is no painting
//			erp.plEnvelope().vis(3);
		}
		
		if (ppArea.area()<pow(dEps,2))
		{ 
			eraseInstance();
			return;
		}		
		
		
	}
// mode 2 = INNER AREA	
	else if (nMode==1)
	{
		
		ppArea.joinRing(plEnvelope , _kAdd);		
		
		PlaneProfile ppSub(cs);
		for (int i = 0; i < plSubtractions.length(); i++)
			ppSub.joinRing(plSubtractions[i], _kAdd);
			
		// HSB-19481: check if pp operation successful
//		ppArea.intersectWith(ppSub);
		PlaneProfile ppTest=ppSub;
		int bInter=ppTest.intersectWith(ppArea);
		if(bInter)
		{ 
			ppArea=ppTest;
			ppArea.shrink(-U(1));
			ppArea.shrink(U(1));
		}
		else
		{ 
			// try
			ppTest=ppSub;
			ppTest.shrink(dEps);
			bInter=ppTest.intersectWith(ppArea);
			
			ppArea=ppTest;
			ppArea.shrink(-U(1));
			ppArea.shrink(U(1));
		}
		
		for (int i=0;i<plAdds.length();i++)
			ppArea.joinRing(plAdds[i], _kSubtract);
		
	}
// mode 3 = ROOF AREA	
	else if (nMode==2)
	{
		ppArea.joinRing(plEnvelope , _kAdd);	

	// Subtract potential opening eroofplanes
		for (int i=0;i<erpSubtractions.length();i++) 
		{ 		
			erpSubtractions[i].plEnvelope().vis(40);	
			ppArea.joinRing(erpSubtractions[i].plEnvelope(),_kSubtract); 		 
		}//next i

		PLine plRoofs[] = ppArea.allRings(true, false);		
		PlaneProfile ppRoof(cs);
		
		for (int i=0;i<plRoofs.length();i++) 
			ppRoof.joinRing(plRoofs[i], _kAdd); 
		
		Entity ent = _Map.getEntity("tslEave");
		TslInst tslEave = (TslInst)ent;
		 ent = _Map.getEntity("tslinner");
		TslInst tslInner = (TslInst)ent;	
		int nNumSubs = _Map.getInt("NumSubPlines");
		
		if(! tslEave.bIsValid() || ! tslInner.bIsValid())
		{
			TslInst tsls[] = erp.tslInstAttached();
			
			for (int i=0;i<tsls.length();i++) 
			{ 
				TslInst tsl = tsls[i]; 
				if(tsl.opmName() == "hsbRoofData-EaveArea")			
	//			if(tsl.opmName() == _ThisInst.scriptName() + "-" + sOpmKeys[0])
				{
					tslEave = tsl;
					_Map.setEntity("tslEave", tslEave);
				}
				else if(tsl.opmName() == "hsbRoofData-InnerArea")				
	//			if(tsl.opmName() == _ThisInst.scriptName() + "-" + sOpmKeys[1])
				{
					tslInner = tsl;
					_Map.setEntity("tslInner", tslInner);
				}			 
			}//next i
		}
		
		Map mapSubE, mapSubI, mapAddE, mapAddI;
		
		if(tslEave.bIsValid())
		{
			if(_Entity.find(tslEave) < 0)
				_Entity.append(tslEave);
			setDependencyOnEntity(tslEave);
			Map mapTsl = tslEave.map();
			mapSubE = mapTsl.getMap("Subtraction[]");
			mapAddE = mapTsl.getMap("Addition[]");
		}		
		
		if(tslInner.bIsValid())
		{
			if(_Entity.find(tslInner) < 0)
				_Entity.append(tslInner);
			setDependencyOnEntity(tslInner);
			Map mapTsl = tslInner.map();
 			mapAddI = mapTsl.getMap("Subtraction[]");
		 	mapSubI = mapTsl.getMap("Addition[]");
		}	
		
		for (int j=nNumSubs;j<mapSubE.length();j++) 
		{ 
			PLine plSub = mapSubE.getEntity(j).getPLine();plSub.vis(3);
			plSub.projectPointsToPlane(pnErp, _ZW);
			ppArea.joinRing(plSub, _kSubtract);					 
		}//next j
		
		for (int j=0;j<mapSubI.length();j++) 
		{ 
			PLine plAdd = mapSubI.getEntity(j).getPLine();
			plAdd.projectPointsToPlane(pnErp, _ZW);
			ppArea.joinRing(plAdd, _kSubtract);
		}//next j
		
		for (int j=0;j<mapAddE.length();j++) 
		{ 
			PLine plAdd = mapAddE.getEntity(j).getPLine();
			plAdd.projectPointsToPlane(pnErp, _ZW);				
			ppArea.joinRing(plAdd, _kAdd);
			ppArea.intersectWith(ppRoof);
		}//next j
		
		for (int j=nNumSubs;j<mapAddI.length();j++) 
		{ 
			PLine plSub = mapAddI.getEntity(j).getPLine();
			plSub.projectPointsToPlane(pnErp, _ZW);
			ppArea.joinRing(plSub, _kAdd);	
			ppArea.intersectWith(ppRoof);
		}//next j
		// 
		for (int i = 0; i < plAdds.length(); i++)
		{
			PlaneProfile ppAreaAdded(cs);
			ppAreaAdded.joinRing(plAdds[i],_kAdd);
//			ppAreasAdded.joinRing(plAdds[i], _kAdd);
			ppAreasAdded.append(ppAreaAdded);
		}

//		Deprecated version 2.2, area of mono ridge roofs would fail
//		PlaneProfile ppSub(cs);
//		for (int i = 0; i < plSubtractions.length(); i++)
//			ppArea.joinRing(plSubtractions[i], _kSubtract);		

		ppArea.vis(211);
	}
	
// collect relevant polylines
	PLine plContours[0];
	PLine plRings[] = ppArea.allRings();
	int bIsOp[] = ppArea.ringIsOpening();
	for (int r=0;r<plRings.length();r++)
		if (!bIsOp[r])
			plContours.append(plRings[r]);
	
if(nMode < 2)
{
// TriggerEditInPlace
	String sTriggerEditInPlaces[] = {T("|Edit in Place|"),T("|Disable Edit in Place|")};
	String sTriggerEditInPlace = sTriggerEditInPlaces[bEditInPlace];
	addRecalcTrigger(_kContext, sTriggerEditInPlace );
	if (_bOnRecalc && _kExecuteKey==sTriggerEditInPlace )
	{
		if (bEditInPlace)
		{
			bEditInPlace=false;
			_PtG.setLength(0);
		}
	// create new instances per contour ring	
		else
		{	
			bEditInPlace= true;
							
		// get link to schedulate table via potential subMapX	
			Map mapX = _ThisInst.subMapX("Hsb_RoofAreaScheduleParent");			
			Entity entParent;
			entParent.setFromHandle(mapX.getString("ParentUID"));
		
		// collect groups of the TSL
			Group groups[] = _ThisInst.groups();
			
		// prepare tsl cloning
			TslInst tslNew;
			Vector3d vecXTsl=_XE;
			Vector3d vecYTsl=_YE;
			GenBeam gbsTsl[]={};
			Entity entsTsl[]={};
			Point3d ptsTsl[]={};
			int nProps[]={};
			double dProps[]={};
			String sProps[]={};
			Map mapTsl;	
			String sScriptname=scriptName();
			
			mapTsl=_Map;
			mapTsl.setInt("EditInPlace",bEditInPlace);
			entsTsl=_Entity;
			
		// loop each contour
			for(int r=0;r<plContours.length();r++)
			{
				Point3d pts[]=plContours[r].vertexPoints(true);
				
				Point3d ptMid;
				ptMid.setToAverage(pts);
				ptsTsl.setLength(0);
				ptsTsl.append(ptMid);
				ptsTsl.append(pts);
				
				tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,ptsTsl, 
						nProps,dProps,sProps,_kModelSpace,mapTsl);
				
				if(bDebug)reportMessage("\n"+ scriptName() + " will be cloned" + 
					"\n	vecX  	" + vecXTsl+
					"\n	vecY  	" + vecYTsl+
					"\n	GenBeams 	(" + gbsTsl.length()+")" +
					"\n	Entities 	(" + entsTsl.length()+")"+
					"\n	Points   	(" + ptsTsl.length()+")"+
					"\n	PropInt  	(" + nProps.length()+")"+ ((nProps.length()==nIntIndex) ? " OK" : (" Warning: should be " + nIntIndex))+
					"\n	PropDouble	(" + dProps.length()+")"+ ((dProps.length()==nDoubleIndex) ? " OK" : (" Warning: should be " + nDoubleIndex))+
					"\n	PropString	(" + sProps.length()+")"+ ((sProps.length()==nStringIndex) ? " OK" : (" Warning: should be " + nStringIndex))+
					"\n	Map      	(" + mapTsl.length()+") " + mapTsl+"\n");							
				
				
				if (tslNew.bIsValid() && entParent.bIsValid() && entParent.bIsKindOf(TslInst()))
				{
				// clone poperties
					tslNew.setPropValuesFromMap(_ThisInst.mapWithPropValues());
				
				// set to correct group
					if (tslNew.bIsValid())
						groups[0].addEntity(tslNew);
	
				// add new area to potential schedule parent
					TslInst tslParent=(TslInst) entParent;
					if (tslParent.bIsValid())
					{
						Map map=tslParent.map();
						Map mapAdd;
						mapAdd.setEntity("AddArea", tslNew);
						map.setMap("AddArea[]", mapAdd);
						tslParent.setMap(map);
						
						tslParent.recalc(); // in V 2.3 replaced - previous "tslParent.recalc();" caused jumping planes when editinplace was initiated
						if(bDebug)reportMessage("\n"+ scriptName() + " remotely updating parent schedule " + tslParent.handle());
					}
				}		
			}// next r of contour rings		
			eraseInstance();
			return;	
		}
		_Map.setInt("EditInPlace",bEditInPlace);
		setExecutionLoops(2);
		return;
	}		
}
	
// declare display
	Display dp(_ThisInst.color());
	dp.dimStyle(sDimStyle);
	dp.textHeight(dTxtH);
	//dp.addViewDirection(_ZW);
	
// collect data
	double dUnitFactor = 1;
	if (nUnit ==0)	dUnitFactor =U(1)/U(1,"mm")/U(1,"mm");
	else if (nUnit ==1)	dUnitFactor =U(1)/U(1,"mm")/U(1,"cm");
	else if (nUnit ==2)	dUnitFactor =U(1)/U(1,"mm")/U(1,"m");
	else if (nUnit ==3)	dUnitFactor =U(1)/U(1,"mm")/U(1,"inch");
	else if (nUnit ==3)	dUnitFactor =U(1)/U(1,"mm")/U(1,"feet");	
	U(1,"mm");
	
	double dAreaRoof = plEnvelope.area()*pow(dUnitFactor,2);
	double dAreaEave = ppArea.area()*pow(dUnitFactor,2);
	//added are for RoofArea
//	double dAreaAdded = ppAreaAdded.area()*pow(dUnitFactor,2);
	
	dAreaEaveRafter*=pow(dUnitFactor,2);
	String sAreaRoof, sAreaEave;
	String sAreaAdded;
	String sAreaEaveRafter;
	int nLUnit=2; if (nUnit>2)nLUnit=4;
	sAreaRoof.formatUnit(dAreaRoof, nLUnit, nDecimal);
	sAreaEave.formatUnit(dAreaEave , nLUnit, nDecimal);
	sAreaEaveRafter.formatUnit(dAreaEaveRafter , nLUnit, nDecimal);
//	sAreaAdded .formatUnit(dAreaAdded , nLUnit, nDecimal);
	sAreaRoof= sAreaRoof + sUnit+"²";
	sAreaEave = sAreaEave + sUnit+"²";
	sAreaEaveRafter = sAreaEaveRafter + sUnit+"²";
//	sAreaAdded = sAreaAdded + sUnit+"²";

// validate data
	if (nMode==1 && dAreaEave<=pow(dEps,2) || (nMode==0 && abs(dAreaEave-dAreaRoof)<pow(dEps,2)))
	{
		reportMessage("\n"+scriptName()+" "+T("|Calculated area=0. Instance will be deleted|")+" "+sOpmKeys[nMode]);
		eraseInstance();
		return;
	}

// get text scale factor
	String sRoofPrefix = T("|Roof Area|") + ": ";
	if (erp.roofNumber().length()>0)sRoofPrefix = erp.roofNumber()+ ": ";
	String sEavePrefix = sPrefixes[nMode] + ": ";
	if (sMaterial.length()>0) sEavePrefix = sMaterial + ": ";
	
// define a box around the text
	String sTxt;
	//sTxt = sRoofPrefix +" "+sAreaRoof;
	double dXTxt;
	//dXTxt= dp.textLengthForStyle(sTxt,sDimStyle);
	sTxt = sEavePrefix +" "+sAreaEave ;
	if (dXTxt<dp.textLengthForStyle(sTxt ,sDimStyle))
		dXTxt = dp.textLengthForStyle(sTxt ,sDimStyle);
	double dYTxt = dp.textHeightForStyle("O",sDimStyle);
	
	// scale text dimensions to current
	if (abs(dYTxt-dTxtH)>dEps && dYTxt > 0)
	{	
		double f = dTxtH/dYTxt;	
		dYTxt =dTxtH;
		dXTxt *=f;
	}	
	
// relocate _Pt0 on creation
	if (_bOnDbCreated || _bOnDebug)_Pt0 = ppArea.extentInDir(vecX).ptMid()-vecX*.5*dXTxt;	
	
// get reading vecs
	Vector3d vecXRead=vecX;
	if (vecX.isParallelTo(_YW))
		vecXRead=_YW;
	else if (vecX.dotProduct(_XW)<0)
		vecXRead*=-1;
	Vector3d vecYRead=vecXRead.crossProduct(-_ZW);
	
// draw prefixes and texts
	//dp.draw(sRoofPrefix , _Pt0, _XW,_YW, 1, 1.5);
	dp.draw(sEavePrefix,_Pt0,vecXRead,vecYRead,1,0);//-1.5);
	//dp.draw(sAreaRoof, _Pt0+_XW*dXTxt, _XW,_YW, -1, 1.5);
	dp.draw(sAreaEave,_Pt0+vecXRead*dXTxt,vecXRead,vecYRead,-1,0);//, -1.5);
	if(isBaufritz && nEaveRafter)
	{ 
		dp.draw("Sparrenkopf",_Pt0,vecXRead,vecYRead,1,-3);//-1.5);
	//dp.draw(sAreaRoof, _Pt0+_XW*dXTxt, _XW,_YW, -1, 1.5);
		dp.draw(sAreaEaveRafter,_Pt0+vecXRead*dXTxt,vecXRead,vecYRead,-1,-3);//, -1.5);
	}
	
// draw box around text
	PLine plBox;
	plBox.createRectangle(LineSeg(_Pt0-vecXRead*.5*dYTxt+vecYRead*2*dYTxt,
		_Pt0-vecYRead*2*dYTxt+vecXRead*(dXTxt+.5*dYTxt)),vecXRead,vecYRead);
	if(isBaufritz && nEaveRafter)
	{ 
		plBox.createRectangle(LineSeg(_Pt0-vecXRead*.5*dYTxt+vecYRead*2*dYTxt,
			_Pt0-vecYRead*4*dYTxt+vecXRead*(dXTxt+.5*dYTxt)),vecXRead,vecYRead);
	}
	//plBox.vis(5);
	dp.draw(plBox);	

// copy eave area as hatch area, subtract potential boxed label
	PlaneProfile ppHatch=ppArea;
	plBox.projectPointsToPlane(pnErp,_ZW);
	ppHatch.joinRing(plBox,_kSubtract);
// Hatch
	if (nHatch>0)
	{
		Hatch hatch(sHatchs[nHatch],dHatchScale);		
		dp.draw(ppHatch,hatch);
	}
	dp.draw(ppArea);
//	if(dAreaAdded>pow(dEps,2))
//	{ 
//		dp.draw(ppAreaAdded);
//	}
	for (int ip=0;ip<ppAreasAdded.length();ip++)
	{ 
		if(ppAreasAdded[ip].area()>pow(dEps,2))
		{ 
			dp.draw(ppAreasAdded[ip]);
		}
	}//next ip
	
	
// draw guideline
	Point3d ptEnd=ppHatch.closestPointTo(_Pt0+.5*vecXRead*dXTxt);
	Point3d ptStart=_Pt0;
	Point3d ptsInt[]=plBox.intersectPLine(PLine(ptEnd,ptStart));
	if (ptsInt.length()>0)
		ptStart=ptsInt[0];
	PLine plGuide(ptStart,ptEnd);
	plGuide.vis(5);
	if (plGuide.length()>dYTxt)	
		dp.draw(plGuide);		
	
// set exportdata (hardware)
	HardWrComp hwComps[0];
	String sArticle=_ThisInst.opmName();

	HardWrComp hw(sArticle, 1);	
	hw.setCategory(scriptName());
	hw.setModel(erp.roofNumber());
	hw.setMaterial(sMaterial);
	hw.setDScaleX(dAreaEave); // mis use X value as area
	hw.setCountType(_kCTArea);
	// HSB-11158: write group
	// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{ 
		Group groups[]=_ThisInst.groups();
		if (groups.length()>0)	
		{
//			sHWGroupName=groups[0].name();
			sHWGroupName=groups[0].namePart(1);
		}
	}
	hw.setGroup(sHWGroupName);
	hwComps.append(hw);
	_ThisInst.setHardWrComps(hwComps);		
	
// store area and outlines
	Map mapPLines;
	for(int i=0;i<plRings.length();i++)
	{
		if (bIsOp[i])
			mapPLines.appendPLine("opening",plRings[i]);			
		else
			mapPLines.appendPLine("contour",plRings[i]);
	}
	_Map.setMap("PLine[]", mapPLines);
	_Map.setPLine("plPlan", plBox);
	_Map.setDouble("Area", dAreaEave);
	
// add extra area for Sparrenkopf !!!!
	if(isBaufritz)
	{ 
		if(dAreaEaveRafter>pow(dEps,2))
		{ 
			_Map.setDouble("AreaEaveRafter",dAreaEaveRafter);
		}
		else
		{ 
			_Map.removeAt("AreaEaveRafter",false);
		}
	}
	Map mapsAreaAdded;
	for (int ip=0;ip<ppAreasAdded.length();ip++) 
	{ 
		double dAI=ppAreasAdded[ip].area()*pow(dUnitFactor,2);
		mapsAreaAdded.appendDouble("AreaAdded",dAI);
	}//next ip
	
//	_Map.setDouble("AreaAdded",dAreaAdded);
	_Map.setMap("mapsAreaAdded",mapsAreaAdded);
// store grips
	Map mapGrips;
	for(int i=0;i<_PtG.length();i++)
		mapGrips.appendVector3d("GripVector", _PtG[i]-_PtW);
	_Map.setMap("GripVector[]", mapGrips);
	
/*
// add triggers
	String sTrigger[] = {T("|Add Point|"), T("|Remove Point|"), T("|Select polyline|"),T("|Show edge description on/off|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);






#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HI
MDLJ0QEW.`/UJI;R3W$_FYVQ#C'8T`7J***`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`IDLJ0H7<X'\Z?6-=O*T_P"]7&.B
M]L4`3HDE_+O?*Q+T%:*J%4*HP!T%5[6YBE0(H",!]W_"K-`!1110`4444`%%
M%<MXR\1ZCHT=M;:)9PWFISB2412YVB*-=SDX(.3PH]S32N[`]#J:*IZ3J4&L
MZ1::E;$^3<Q+*N>HR.A]QTK"UC7]1LI-1E@?3DM[.1(5CN25:9V16P'W`+][
MT/0FCE=[$\RM<W+_`%>QTTHMU/MDD^Y$B-)(_P#NHH+'\!5,>)]/7FXCOK6/
M_GK<V4L<8^K%<+^)%8.A^+-%MYHHKMQ%?71Q<7<T\!#N%)P2DC87@A1T'`[\
M];?65MJVFS6=QN>VN8RC^6Y7*GT(YIM6W$FWL5;7Q'H][;3W%MJ,$L$%PMM)
M*K942,5`7/?)91D<9-53X1TN:9KB]:[OK@N7\RYNG.WG.%4$*H'HH'ODUQ5K
M\/M3\,27=GIDAOM+O+FSF`8A9(6BN8W.>@(V!^1Z#BN_UG2_[5$$5Q=-'I\9
M,ES"IV^?C&U6;^YU)'?@'C(*DDGH.+;6I+J>BZ?K*Q"_M_.$1)3YV7&>O0CT
M%&F:+I^C)(MA;^2)""_SLV<=.I-82NWBYPZL8/#$)R"#M.H8_E`/_'_]W[PK
MMXN<.K&#PQ"<@@[3J&/Y0#_Q_P#W?O(HNCP7X?$GF#3_`)@=V?.DZ_\`?57M
M6TC3-52+^TH5D6,G9F1DQGKT(]*=I&J6^KV1NK-'%IO*0R%<+*H_C3_9)R`>
M^,C@@GD_BI_R`;#_`*_5_P#0'JX1YI6,<36]C2E4M>QT^FZ=I&BI*MBL<"N0
M7S*6SCIU)]:I'PAX:+^8;--Q;.?/?K_WU7G^A_P5TFM?\@9?QKY;&<0O#5O9
M>SOKW_X!CD>+_M2?(X\OSO\`Y'6:CI.F:XD:WD2W"Q$E<2$8)Z_=(IVF:+I^
MC+*+"W\D2D%_G9LXZ=2?4UR7PN_Y!>I_]?G_`+(M:FM(NI^*[+2+FZN[>T^P
MS7(^RW<ELTCJZ+RT;*Q"AB<9QSDCI7T%"K[6G&=K7_X<];&X;ZM7E2O>WZV_
MS+)\%^'S)YAT_P"8G=GSI.O_`'U6AJ>BZ?K*1K?V_G",DI\[+C/7H17*_P!I
MW4WP]T>26^F/VRXM[66\5S&[1-*$WAQC:67'S#'WLC!Q6KX<!M-5US38KNYN
M;6TEB,?VF=YWB9HP63>Y+$=&P2<;O3%;-V3?;_@?YG*:NF:+I^C+*+"W\D2D
M%_G9LXZ=2?4U0T5[RSUC4-&N[F6[BACCN;6XE^_Y;EP8V('S%60\]2&7.2"3
MRY\6^*5L1<G^QB&TEM6`$$ORHF,Q??Y+9&'XV\C:W6NTM]76XUI].$)&VSBN
M_,+=0[.NW'MLZ^].W]?UZ!UM_7]:HTJ***0!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4R6))DVNN1_*GT4`9%Q9R6YW+ED'1AU
M%36VH=$F_!O\:T:HW-@&R\.`W=>QH`N@@C(.0>XI:QH;B6U<J0<`\H:TENX6
MB,F[`'4'K0!))(L2%W.`*RWN9KBX4QD@Y^4"FS327<P`!_V5%:-K:K;ID\N>
MIH`F3=L&_&['.*\VA_X2C6O%^J^(/#Z:,;:(G38&U$R$[4.79-G8L3SWVCTK
MTNBFG9W$U=6.$^'KW^E7&J>&-6-N+NUD^U0+;EO+\F3G";N=JMD>V<5,S1VG
MC;5+C4K2]>V&QK7RM/GG5F:-%=LHC#(V`#ORU=K15.5W<GDLK'*W]U9ZS;?V
M98Z?>*]TPBDDETV:!8XC]\[W10#MR!SG)%=2JJB*B*%51@`#``I:*ELI(RO$
M6H3Z7I*W-OM\PW=M#\PR-LD\<;?HQHUO25UA(8+JX*::I+W4`X^T`8PK'^YU
M)'?@'C(-G5+:SN=/<7X)MHF2X;DC!C82`\<\%0?PJ*]L;'Q#IL<<LAGL)MLA
M6-_DG3J`Q'5#QD=#T.1D4AF%_P`CC_TQ\+1?\!_M#'\H!_X__N_>/^1Q_P"F
M/A:+_@/]H8_E`/\`Q_\`W?O=!J6DVNK62V5T'-ID;X$;:LBC^%L=5]1T/0Y&
M11J6DVNK62V5T'-ID;X$;:LBC^%L=5]1T/0Y&10`FCZG;ZM9?:;)&%IO*02%
M<+*H_C3_`&2<@'OC(X()Y/XJ?\@&P_Z_5_\`0'KNE4(H50`H&``.`*HZKHVG
MZW;QP:C;^='&_F*N]EPV",_*1V)JZ<E&5V<^+I2K494X[L\MT/\`@KI-:_Y`
MR_C72P>%M%ML>39[<?\`35S_`%JS-HNGW$/DRV^Z/TWL/ZU\=C\@Q.(Q'M82
MC:_5O_(Y^'<)/+:G-6:>O3_@V.2^%W_(+U/_`*_/_9%K4\32V-SJ%IIVHZ%I
M^IVBO$TIO-K&(R/Y:&.,HVXYSGE<#IGI6SI>BZ?HL4L6GV_DI*^]QO9LMC&>
M2?2II].LKF\M[N>SMY;FVSY$TD2L\6>#M8C*Y[XKZ?#4G2I0A+IN>YC\1'$8
MB=6&SVO\CD[O5M'BUB_CNM"O9XGB%G+(\<#6_E(6&T*7R5W-C!7DL.P.-#PO
MJ>G2!M-T[0)M'AC5G6(PPQQDY&[`C8\_,I/`^]Z@@;CZ?92;M]G;MN.6W1`Y
MYSSQZ\U)':V\+[XH(D?!&Y4`/.,_R'Y"MUYG&_(A_LS3S'Y9L;;8(3;A?)7'
ME'JG3[O'3I44>EI%KLNIK)C?:QVPB"X"A&=L_P#C^,>U:%8-JLDOCG4IE5Q!
M%86\!8@A3)OE<@>I"LI/^\*`-ZBBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@"&>VCG7YAANS#K67):31R!-I;)
MP".];5%`%>UM5MTR>7/4U8HHH`****`"BBB@`HHHH`*P7\(Z8"?LLE_8QDDF
M*RO988\DY)"*P4?@!6]10!1M=+CM-/DLEN;V1)-V9)KEWD&1CAR<CVP>*I6W
MAFWM;F.==1UB1HV#!9=1F=3]5+8(]C6W10!F:EH<.ISK+)>:C`57;MM;V2%3
MSG)"D`GGK4MKI<=II\EDMS>R))NS)-<N\@R,<.3D>V#Q5ZB@#$MO#-O:W,<Z
MZCK$C1L&"RZC,ZGZJ6P1[&K&I:'#J<ZRR7FHP%5V[;6]DA4\YR0I`)YZUIT4
M`4;72X[33Y+);F]D23=F2:Y=Y!D8X<G(]L'BJ5MX9M[6YCG74=8D:-@P6749
MG4_52V"/8UMT4`9FI:'#J<ZRR7FHP%5V[;6]DA4\YR0I`)YZU+:Z7'::?)9+
M<WLB2;LR37+O(,C'#DY'M@\5>HH`Q+?PQ;6US'.NHZPYC8,%EU*9E./4%L$>
MQK;HHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`.5\?ZZVD>!M:O+"^C@OK>W8Q,&4LK9QT/>I?`^M'5/!6
MAW5[>QS7UQ:1O*Q90S.0,\#O7!_$KX6>$[;POXB\1164JZGLDNO,^T.1YC-D
MG;G'4GBIOAW\*_"4GAWPWXC:QE.IB*"\\S[0^/-&&!VYQU'2@#UNBBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHKA-;\3:MJNH2Z;X3DB3[(3]IO9%#)O'_+)<@@GU-1.:@M3HPV&GB)-)I)
M;MZ)>IW=%>5:5\0/%0U%]-OM,LIKR/\`Y8,Y@DD]U)RI_"NC7XA06_&K:+JE
MA@\R&'S(Q_P)?\*SCB(25]CLK9/BJ4N5)2]&G?T6_P"!V5%8MAXN\/:G@6FK
MVK,>B,^QC_P%L&MD$$`@Y!Z$5M&2EJF>?4HU*3Y:D6GYJPM%%%,S"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBJ.IZI%IL&YOFE;[B`]?\`ZU)R45=E1BY.
MT2ZRJZE74,IX((R#0JJBA44*HX``P!5/3]4M]1CS&=L@'S1MU'^(J[0I*2N@
ME%Q=I!1113)"BBB@`HHHH`****`"BBL+[;XEN)F-OH]C;VX<J#>7I$K`'KM1
M&4#N/F)YY`H`W:*H:F^KH(_[*@L922?,^U3/'CTQM5L]_2C3'U9ED_M6"RB8
M$>7]EF>0$=\[E7%`%^BL$2^+?,&;'1-F>?\`3)<X_P"_57]3?5T$?]E06,I)
M/F?:IGCQZ8VJV>_I0!?HJAICZLRR?VK!91,"/+^RS/(".^=RKBJ!E\6^8<6.
MB;,\?Z9+G'_?J@#>HJAJ;ZLJQ_V5!92L2?,^U3/&`.V-JMFC3'U=Q)_:L%C$
M01Y?V69Y,^N=RKCMZT`7Z*P3+XM\PXL=$V9X_P!,ESC_`+]5?U-]658_[*@L
MI6)/F?:IGC`';&U6S0!?HJAICZNXD_M6"QB((\O[+,\F?7.Y5QV]:CT?6HM6
M^TQ&"6UO;201W-K,1OC)&5/RD@J1R"#@_4$``TZ***`"BBN-\2^(+J\OF\.Z
M#)BZ(_TR['2U0]A_MG]/Y3.:BKF^'P\J\^5:):M]$N[_`*UV6I#XBURYUF_D
M\.Z'*4"\7]\G2%>Z*?[Y_3\\6;.TLM#TR.VMU6*WB&`">6/U/4DTFG:=9Z%I
MBV]NFV*,%F;JSGNQ]2:S+J\>[DW<K&/NKR./4CUK"4O9KGG\3.R35>U"AI37
MWM]WY]ET7S;H:U:Q:Z/](#(5.8F0X:/_`![_`)UDV^O:IH$ZVNK3NULQ"PWB
MC(X.<,.WI_CUK=IDL4<\313(LD;##*PR#7`ZDW+F3U/5H^RC#V-2'-#\5YI_
MTF+,MAJ,6^ZTVQO-RDB38%+9Z889XQ5>+1]/M23IE]JNDMDX^SSED]>5YR/:
ML1K2_P##;M+8![K3>KVS'+1^Z_Y_QK:T_4;74[83VL@=?XAW4^A%-5FW[R5S
M2IAZE&'-0J/D]=/1IW2?](TH+WQ5:8^RZ_IVHKD`1WT/EMST&5YS]:W=!\7Q
MW]V=+U6W_L_5UZ0L<I*/[T;=_I7+RC.SC.'!Z`XJ:YBM-5M1::JA=5YBN5.'
MB/)W;NW;I^-=-.KV?W[?\`\^K&$]*T5;O%)-?)637?9^9Z317`:=XGU#PT\5
MIXB?[5ISD+!JJ#.!V$H_K_/DUWD4L<T22Q.LD;@,KH<A@>A![UUPJ*7J>9B,
M+.C9[Q>S6S_X/=/5#Z***LY@HHHH`****`"BBB@`HHH.<<4`4-4U2+38-S8:
M5ON)Z^_TKB+FYENYVFF8L[?I5[6;.^ANFFNCY@<\2#I]/;Z5F5YM>I*4K/0]
MK"T80CS+5L='(\4@DC=D=>C*<$5U&E^(TEVPWI"2=!)T!^OI7*T5G3J2@[HU
MJT855:1Z6#D9%%<3IFN3V!6-\RV_]TGE?I_A77VMY!>PB6"0,O<=Q]:]&G6C
M4VW/'K8>=)Z[$]<]K?CGPYX<OQ9:KJ/V>X*"0)Y$C_*<@'*J1V-=#7GFI_\`
M"0_\+0O/^$>_LOSO[+A\W^T/,V[?,;[NSG.?6MHJ[L<TVU&Z.UTG6-.UVP2^
MTR[CN;=C@.F>#Z$'D'V-0WOB+2-.N'@N[^*&2,`ONSA,C/S'H..>:YKP#]HM
M=8\26&IQQ+K'VI;JY-L?W#+(OR%!@$="#G))Y)YXG=)-5\2ZUHD;A(6E2:[8
MIN^3R8@B<\?,0WKPA'>J<5<E2E;7<UTAO=<C6XFN;BPL7&8H(#LE=>Q=NJY_
MNK@CN>P@O_#TMOI\\NBW>HKJ"H3#Y^I32(6[`B0NN/P_+K67?>&ET"V_M*PO
MIH[J$[;>*.-5621QL1",8VEF'TX/:NTC#B)!(P:0*-S`8!/<XI-VV&E?<\ET
M#Q;XEBAU;3==>6#6([^SD02(!^YDN(XG51TVX/!'][.:]8<LKABR+"JDN6Z]
ML<]AUJCK,6E""*YU6&)DCFB6-W3<5=I$"8QS]_9[<`GI3-;TE=82&"ZN"FFJ
M2]U`./M`&,*Q_N=21WX!XR"I.[N.*:5F1:3K4FLS37=O"B:,@Q#=2$@W)[NH
M[1CLQ^]U'&"32=:DUF::[MX431D&(;J0D&Y/=U':,=F/WNHXP3E_\CC_`-,?
M"T7_``'^T,?R@'_C_P#N_>/^1Q_Z8^%HO^`_VAC^4`_\?_W?O(HZ#2=5@UFT
M:\M5<VI<K#*PP)E'\:_[).<'OC(X()R/&OB&[\.:9;7-G'`[RW`B83*2,;6/
M&".>*UM'U.WU:R^TV2,+3>4@D*X651_&G^R3D`]\9'!!/)_%3_D`V'_7ZO\`
MZ`]:4DG-)G+CIRAAYRB[-(;IOC;4KS;YD%H,_P!U&_\`BJU]0\17=I8">..`
ML<\,IQ_.N$T/^"NDUK_D#+^-?G^9YEBZ6*Y(5&E<Y.$ZU3%U6J[YE?J:_@SQ
M#=^(K.\FNXX$:&?RE$*D`C:#SDGGFKNK:O>VVHV^FZ58V]Y>RQ/.RW%T8$2-
M2!G<$<DDL`!CUY'?G/A=_P`@O4_^OS_V1:Z'5M&OKC5+?5-*U""SO8X7MV-Q
M;&>-XV(;[H="&!48.<=<@\8^RPDY3H0E)[H^ES2E"EBYPIJR5K?@1MXF#>%[
M75H;-C<7;1PQ6DLFS]\[;-C-@X`;.2`>`2`>E6-&U:ZOI;ZTU"RCL[VS=1(D
M4YFC967<K*Y52>XP5&"#]:RSX:O&TV/1XKD16]BL,UK>2('D>Y5R[.RA@"F<
M97Y3RV".#6IH^DW-C)>W5_>I=WUXZF1XH3%&JJNU55"S$#J3ECDD^P'4]G_7
M]=?D>=V*`^('ADH7^WS;=@D!^QS\Q]Y!\G*#HSCY5[D5L1V=JNN3WZ2G[5-;
M11/&&&-B,Y5L=>KOS6&W@S=8K;?;_NZ*^D[O)_O8_>8W>WW?UJW:6<T'C.>0
MQN8!I5O$)=I"LRR2Y&?7!!Q[T]/Z^?\`7S'U_KR_X/W&_117*^*?$L]I.FBZ
M,JS:Q<+G)^[;)_ST;^@__48G-15V;4*$Z\^2'_`2[OR1%XG\1W/VO^P-!96U
M21<S3]5M$_O'_:]!_P#6IFE:7::#IQAAS@9DFF?EI&[LQ]:;I&DVVAV3CS-\
MKDR7-S(?FE;J68_G5.^O6NI-J_+"IX'<D9&<@]".U8M\B]I/?^OZ9VR:J+ZM
MA_@6[_F?=^79=/6XV^NS=RXQ^Z0_*O!!(Z-TX-5J**X)S<W=G=3IQIQY8A11
M14%A6'J&A.+DZAI,HM;WJRC[DOL1_G^M;E%)JYM1K3I2O'_@/U,6PUM+V46=
MW#]EOXV&^%P>?=3_`)_'K6U6=JVEVVI1(LJ[90<)*I`9/H?Z5G0:I>:/.MGK
M7SPL=L-ZH^5O9O0_YYZT7:6IM[&%=N5#1_R_Y=_3?U.GAG,4;Q2()K=P0\+\
MAN.G/0>U1V9O_"^Z[T'??:,6)ETYR=\7/)B)Y_#O^M-5E=0RD,I&00>"*?%(
M\,PEC8JW`)`'(SG'TK>%792^_L>?RN%^573WB]G_`)/S6IW&BZ[I_B"Q%WI\
MXD3HZ'AXSZ,.QK1KS-[)IKW^U-'N!IVM``/_`,\KG_98=^G7J*Z;P_XOBU.X
M_LS4838:P@^:W<_+)_M1G^(>W7Z]:[H5>DOOZ/\`KL>?6P:<74H7:6Z?Q1_S
M7FOG8Z:BBBMCSPHHHH`****`"BBB@!LD:2QM'(H9&&"I&0:Y?5/#C1;IK$%T
MZF+J1]/6NJHK.I2C-69K2K3I.\3S3H<&BNVU31(-0!D3$5Q_>`X;ZUR<VG74
M%V+9X6\UCA0/XOI7GU*,H,]BCB855V9!%$\TJQQJ6=C@`=Z[71])7382S'=.
MX^=AT'L*31]'33HM[X:X8?,WI["M2NJA0Y?>EN>?BL5[3W([!7,:UX)M]9UH
MZJ-8UG3[EH5@;[!<B(,H)(S\I)Y/K73T5U)V=SA:35F8WA_PS8>&X)DM#/--
M</YEQ=7,IDEF;U9O\`/S)IUQX<LKB_GO1->P3W&WS3;W<D8?:,#(4XZ5KT4W
M)MW#E5K&3!X>M(;J&X:>^G:%MZ+<7<DBAL$9VL<9Y-:U%%*X))&3XCT^?4])
M6VMPOF"[M9?F.!MCGC=O_'5-.UG1_P"VQ!;7$[#3PQ:YMU&/M'3:C'^YU)'\
M7`/&0=">,S6\D2RO$SH5$D>-R9'49!&1[BL".Z\4V$*6\^EVVJ.@Q]K@NA#Y
MF.[(P^4GT!(^G2@8[4=*N]<OOL-W&+?080-\*L-UZ?[K8^[$.Z]6/!PO#&HZ
M5=ZY??8;N,6^@P@;X58;KT_W6Q]V(=UZL>#A>&T[2ZOYM/DFN=-^SW*[MMOY
MZOOP./F'`STJE;:GKLMU''<>'?(A9@'E^VHVP>N`.:`->$G#)Y)B5#M3IAA@
M<C'0=OPKG/&^@7GB'2[6WLC$'BN!*WF,0,;6'H?6M34K[5;6=$L-'^VQE<L_
MVE8\'/3!J6TNK^;3Y)KG3?L]RN[;;^>K[\#CYAP,]*J,G%W1G5I1JP=.6S.,
MT[P=JMD!O$#8_N2=?S%;&H:!>W>GB"/RP_/WFXJ];:GKLMU''<>'?(A9@'E^
MVHVP>N`.:L:E?:K:SHEAH_VV,KEG^TK'@YZ8->+B,CPE>I[2=[^IGEV&IY=+
MFH;^>IE^"O#]YX?LKR&],1::X\Q?+8GC:!SQ[4_6M`N-1\0Z??1Q6;I`4/GR
ML?.MMK[CY0VD'>/D;E>!_%TK6M+J_FT^2:YTW[/<KNVV_GJ^_`X^8<#/2J5M
MJ>NRW4<=QX=\B%F`>7[:C;!ZX`YKU*5.-*,8QZ;'=B*\\14E4GO(S;SPSJLN
MH7%[!JMRDCNS(GV^81K\W'R`[1\I(QCJ0>H!%S0M!N](O9));^YN(G1EVSWL
ML^.5*X#D@?Q\CU`Z``7M2OM5M9T2PT?[;&5RS_:5CP<],&I;2ZOYM/DFN=-^
MSW*[MMOYZOOP./F'`STK2.AB]2]6:FI2-XFGTORU\N.SCN`_<EG=<?3Y!5:V
MU/79;F..?P[Y$3,`\OVU&V#UP!S5^#38+?5+S40TC7%TL<;EFR%1,[54=AEG
M/U8^V`#%\4^)GTQH]+TM%N-:NA^ZCZK$O>1_0#]:S]$T5-(@D:25KB^N&WW-
MR_+2-_AZ"I_$'A:[.IR:_H$PCU-E`G@E.8[E1C`_V3@#G^76J^D:]!JC26TD
M;VNH0\3VDPPZ'^H]ZP7\3W]^G]=SU:B_V1+#:Q^WWOY_W5TZ7WUT2:I+.[M$
MH'E+MSL)+'(/WAC@5F5TB9-Q,&W%<+P2,=_Q_.L^]TO`\RU4``9,8'8#@*/P
MJ,11<_>1CA,3&FN27WF711W8=U."/0^E%<&QZJ:>J"BBBD`444C,J*68@*.I
M-`#9,_)C/WAT&:2>"*YA:&>-9(W&&5AD&FR;W*[8P0K9)8XZ>E2(X=<C\0>"
M/K5-:"C*TKHYPVU]X;9I;,-=:7G+VY.7B]2OJ/\`/O6Y8W]MJ5LMQ:R!T/4=
MU/H1V-6:P[_1)([EM1TB06]YU>/_`)9S>H(]?\^]9V:V._VE/$Z5=)?S='_B
M_P`_O-SN""01T(."*6[AL]7MTM]34AH^8;N,[7A(Q@[NN<_A61IFN17KM;7*
M&UOHSM>%SU/^R>_^?K6M6L*EO-''6P\Z4]?=DMFOZU1H:?XHO_#TT=AXG;SK
M5CM@U5%^4^@E'\)]_P#ZYKN4=)(U>-E=&&593D$>HKSR.9?)>VGB2>VD.'BD
MP5P3DGH<_2H;&74?"@^TZ/YFH:&QW2:>Q/FVX/4QYY_X"?\`Z]=E.K9=U^*_
MS1PUL/"N^D:GW1EZ?RORV?2QZ716?H^M6&O6"WFGSB6(\,.C(?1AV-:%=2::
MNCR9PE3DX35F@HHHIDA1110`4444`%)@$@D#(Z'TJK+JNG02M%-?VL<B_>1Y
ME!'X$T1:KIT\JQ0W]K)(WW42923^`-`%NBBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`*PO$/A:RU]4E+-:ZA#_J+R'B2,_U'
ML:W:*F45)69I2K3HS4Z;LSSNWU.[T3418>)!%'-+A(;V-,13X]3V;!''3K71
MU>NM/LM5:]LKV"*>%U3?&S$GO@X_A/H1S7'W-GJG@D;AYVI:`/XL;I[0>_\`
M>4>O;^>?-*G\6J[_`.9VJG3Q?\/W:G;H_P##V?E]W8U[NPCNL-G9(.`W)XSS
MQG'XUARPR02&.12K#G\.W\JZ"TO+:^M4NK69)8'&5=3Q3)3#=KY8C\X`@A@!
MA<@_,">#^&3S2JT8U%=;F%+$5*$N62^1S],:1%;:3ENNT<G'KCTJQ<:=<6R*
M\KY3C.SM@<DG`J%55%"J``.PK@G!P=I'K4ZJJ*\1G[QQQ^['YGK^72E6-5.[
M&6YY/)YI]%1<NP4QDR=RG:_8]CQW]:?10-JXQ9/FV,-K\X!/4#N*?R2%5=SM
MPJ@\L?04UUWJ5V,^?X5!)/TQ6Q8VIL2&N%W,V!YBDG!)/;''&.:VI4O:/R.;
M$8A45YE*^\)6>I6>VX9DO`=T=S'PT9&<#KR!G\?:L."ZET2\33O$@:-&8"#4
MHC^[D`Z!QC"GU/']3W,T\5O;O/-(J1(NYG8\`>M8.E:9+XVODU/4(F30(&S:
MVSC'VIA_RT<?W?0?_7STU:<4TH;_`-;BP->4J<OK'\-=>J?3E?=]MK:ON2KI
MIFA$EK=PSKCAL\$Y]1GM3/(OK)C+'$P(R25&X,!G&0.3USBM:Y^'7AV5S);0
M3V$Q_P"6EG.T9_+D?I51_"7B&R&=,\3-,HZ1:A`'S]7'/Z4O96=^7[G_`)D<
MU*HK1J_*<6OQCS?C8R7LG&HMJ.ASKINL*=LL+?ZJZP`2&7/OUZ_SKJ/#OBZ#
M6)387D)L-7C'[RTE/WO]I#_$/\^]8-Q)XNL9(6O=`ANT1R3)I\H;/RD<*WS#
MZ_AWK,U;6-`U14BU:*^TF\C.89IX&BDC;_989_6CF4-4[>3T3-XT*E>/LZL>
M=+:46I->J6K7D]5T?0]5HKSS0_'@L9H]/UV]M[F%CM@U6!P4;T$@'W6]_P#]
M=>A*RNH92&4C((/!%;TZD9K0\O%8.KAI6FM'L^C_`*[;KJ+1116ARA112;UW
MA-PW$9`SS0!XIXN_X4M_PEFH_P#"0^;_`&OYO^E;?M6-V!_<^7ICI3_!G_"F
M?^$NT_\`X1KS?[8WM]FW?:L9VG/W_EZ9ZUZ]+I6G3RM+-86LDC?>=X5)/XD4
M1:7IT$JRPV%K'(OW72%01^(%`%NBBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`*GG+#=7#2NRJ%4C<1C@$G`'-.\Z:;B
M&':F<%Y>,@KD$+U/.`0=O>DELT-R+J(*MQP&8C.Y1VZ\'GK4D$_G#:Z&.90#
M)&>=I(]>A^HH`XO5?!EUI\QU3PXT8N,[Y[!QM@G.,$J/X6].>_:I-&URUU9'
MB1'M[N'Y9K24;9(C]/3WKMJP/$/A2TUPI=1R-9ZG"/W%Y#PR^S?WE]C6+@X.
M\/N_R/0A7IUX\F)WZ2Z_]O=U^*\]AA`92K`$'@@]ZR;S2V!:6V!;)R8\\Y)[
M$G@=>*K6VMW6G7RZ5XCB2VNVXAN5_P!3<_[I['V/_P!:N@I^Y5C9F,Z=;"35
M^NSW37EW.5HK=O-/CN<R+\DW'S>N,X!_.L22*2&3RY4*L/8X/`Z'OUKAJT)0
MUZ'HT,3&JK;,;2$A1DT$@#)(`]36SIUAY86XG7$O55/5.W/.#4TJ3J.W0JO7
M5*-^HNGZ=Y!$TP!F_A'!"=1P?4@U?D=(XV>1E5%!+,QP`.Y-.)`&3P!7-1PS
M>.K]K6%GC\/6[XN)U.#=N/X%/]T=S7H-JFE&*UZ'G4:,L3-SJ.T5N^W_``7T
M7Z7(;*QD\8W#S^5*/#5JX*0+A?MC*.BCCY,@<9'Y]/1[=X6B"P%-D?R;4QA,
M?PX'3'I2P016T$<$$:QQ1J%1$&`H'0`4V6#<_F1N8Y0,!N2,9!.5S@],9ZBJ
MA#EU>[)Q.(]JU&"M!;+]7YOJ_P!":BH89_,8QR(8Y@-Q3KQD@'/0YQ4U6<I6
MNMOVBRW;,^<=NX$G/EOTQT.,]>,9[XJ:6*.:,QRQK(C=5<9!_"HK@D3VG)&9
M3TDVY^1NW\7T_'M5B@$VM4<W?^`O#&HY,ND01L?XH,Q'_P`=P*T="T2W\/Z:
M+"UFN)8%8LGGR;B@/\(X&![>]:=%0J<$^9+4Z9XS$5*?LIS;CV;N%%%07-RM
MNGJYZ"K.8+FY6W3U<]!7)ZEJCF1DB<[R?F<'I["C4]39W:.-\L?OO_05CUQU
MZ_V8GI87"_;F=)I7B0C$-\21T$N/Y_XUTR.KH'1@RD9!!R#7FM:&FZO<:<V%
M.^$GF-CQ^'H:BEB6M)EU\$I>]3W.[HJI8ZC;ZA%OA;D?>0]5JW7<FFKH\N47
M%V84444Q!1110`45EW6L[+E[2QLYKZY3_6+%A4B[_.[$`'V&3TXJI=:[J.EV
MLEYJ>D116<0W2R0WJN4'KA@H_(Y]`:=F*Z-^LJ]\3Z#IUW]DO-8L8+D'!A>=
M0X^JYR.H_.LC1_B#I&M:;>7]LL_DVUY%:8*C<WF.J(^,\*6;OS@'Z5T=K966
MF0R"UMX+:-F,C^6H4$DY+'WZG)H::T8)IJZ(=3UO3-&6-M2OH+42DA/-?;NQ
MUQ^8HTS6],UE9&TV^@NA$0'\I]VW/3/Y&K%M>VUW9K>6\\<MLZ[EF5LHR^H/
M0CWHMKVVN[-;RWGCEMG7<LRME&7U!Z$>](9D?\)MX8\SR_[=L=V=N/-'6K^I
MZWIFC+&VI7T%J)20GFOMW8ZX_,59M;NWOK6.YM9DF@D&Z.1#E7'J#W'O4.HZ
MK8Z3%'+?W"P1R/L5FS@M@G'Y`T"E)15Y.R&:9K>F:RLC:;?070B(#^4^[;GI
MG\C5#_A-O#'F>7_;MCNSMQYHZU83Q-H\O^KO5?\`W48_TJPVL6$</G/<!(_5
ME(_I[UC+$T8?%-+YH5&<:W\)\WIK^0FIZWIFC+&VI7T%J)20GFOMW8ZX_,4:
M9K>F:RLC:;?070B(#^4^[;GIG\C3M-U>PU>.22PN!.D;;'(!&#C..1[U=K5-
M-71I.$H2Y9*S,'_A-O#'F>7_`&[8[L[<>:.M7]3UO3-&6-M2OH+42DA/-?;N
MQUQ^8J_13)*&F:WIFLK(VFWT%T(B`_E/NVYZ9_(U>5@RAE(*D9!'>EK"T?2Y
M='UG4+:VB,>CRQQSP("-L4Q+B1$'92`C8Z99O6@#=HHHH`*BGMTG`)^610=D
M@`W(2,9&>_-2T4`5A.T+;+G"C)V2Y^4C@#<>`&)/3_\`55FD95=2K`$'J"*K
M!9;4@)NE@X&"<NI)))+,>1R..O'?I0`W4]*L=9L7L]0MTG@?JK#H?4'L?<5P
M]Q%JG@H_Z2TNI:#GY;CEIK4>CC^)1Z__`%A7H,<B31++&P9'&5([BG$`@@C(
M/4&LYT^9W6C.NABG3C[.:YH/I^J?1^?WW1S5M<P7ELEQ;2I+#(,JZ'(-)<VT
M5U&4D7L<,.J_0]JSM3\*7FC7+ZGX6"A6.ZXTMFQ'+ZE/[K?I_(R:1KEIK,;^
M3NBN(CMFMI1MDB;T(_K2C.[Y9Z/\RJV%M'VU!\T/Q7JOUV?X"66GJMW,[NK^
M5)M10>F0#\P]>:U*AASYMQG=CS!C.,?=7ICM]??VK#O)KKQ-J3Z%H\IC@CXU
M"]7I$O\`<7U8_I^=-N--62(HTIXJ?O.R6[>R7];+JQDOVGQEJ4FD:?(\6DP-
MMO[U/^6A_P">2'^9_P`GO[.SM]/LXK2TA6&WB7:B*.`*CTS3+31]/AL;&$16
M\0PJCO[GU)]:MT0@U[TMV5B<1&:5*DK0CMW;[OS?X+1!1116AQD<L,<RJ'4'
M:=RDCE3V(]ZA65[;Y+AMT8&%F)YP%R2_`"\@^WTJU4<\D,41:=D6,D*=YX.>
M`/QSB@!D^3-:D`D>:22$##&QNI[#W'T[U/68D4TE];M%'BT1W=O/W;U;!4;.
M>!R>",8/%:=`!1110`5DWEM*CM(274]3Z5K44`<7>:6&R]N`#W3L?I62RE6*
ML"".H-=Y<V`?+PX#=U[&L6[L4GRLBE9!P#W%<E7#)ZP.^AC7'W:FJ.<HJ:XM
M9;9\...S#H:AKA::=F>I&2DKHDAFDMY5EA<HZ]"#77:/K7VY=DZ;)%_C'W6_
MP-<M:6CW4F!P@^\U=)9V>[;%$-J+U/I79A8SWZ'GXZ=.W+;WOR-ZN)U>74O$
MOB^?P[9:G/IEA8VZ37LUJ=L\C.<HJ-CY1A221],&NT1!&BH,X`QR:Y#6M*US
M3/$[>)/#UO#?&X@6"]T^201-+M/RNCG@$9[]L]2>.Z-KZGERV9K:!X>ET&2X
MSKFJ:C#*%PFH3"4QL,Y*M@'!!''M6-K5Y?F]U)+35+Z*[298;.WMXD=?]4CL
MS*4)(&XDY([#(R*V-!U'7]0EG.L:"FDQ(H\L?;%G:0\Y^Z,`"J/V#5+#Q;J>
MJ0Z<+R.Y6-83]H5/+^50_!'4E%_[Y%5UU(TMH9^FZ_JFBVL,-YH$J:?`C&>X
MB5]R@*6,A##G)'/S$\DY-=KB&\M</&)(9DY21>&4CH0?Y&L.Z75M92.QN=,6
MTM))%-PYN5<M&#DH`!_%@*?8FNAI2*C<X5OAM:V-[/-H<_V2WNI;>2XM'R8\
MQ3I*"G<'"L,<CYNV*Z76])76$A@NK@IIJDO=0#C[0!C"L?[G4D=^`>,@P>++
MB:UT-)()7BD^W6:;D8@[6N8E8?0@D'V-3ZWI*ZPD,%U<%--4E[J`<?:`,85C
M_<ZDCOP#QD%-M[C22V,;_D<?^F/A:+_@/]H8_E`/_'_]W[Q_R./_`$Q\+1?\
M!_M#'\H!_P"/_P"[]X_Y''_ICX6B_P"`_P!H8_E`/_'_`/=^\?\`(X_],?"T
M7_`?[0Q_*`?^/_[OWD,W]'U.WU:R^TV2,+3>4@D*X651_&G^R3D`]\9'!!/)
M_%3_`)`-A_U^K_Z`]=9H^IV^K67VFR1A:;RD$A7"RJ/XT_V2<@'OC(X()Y/X
MJ?\`(!L/^OU?_0'K6A\:.+,?]UGZ',Z'_!72:U_R!E_&N;T/^"NDUK_D#+^-
M?F&<?[XO4X^"?XS]1?A=_P`@O4_^OS_V1:G\6-HG_"2Z>OBH6/\`8OV.8QG4
M`OD?:-R?WOEW[-V,\XW8[U!\+O\`D%ZG_P!?G_LBUL:UKUSI_B'3["*6S59R
MG[B5"9;G<^UO*.X`;%^=N&X_N]:^^P.M"FOZZGUN<_[[5?I^AS\US&GPZTNT
MO9#Y`:W:]BN3\ZV)EQNE4\A-@`8GMNSWK6\&C3!=:V=`$`T0S1FW^R8^S^9L
M'F>5M^7&=N=O&[/?-17'B2XL=;O9ET6W:+/EO<F];S&5&*CY/+P/F;H&[L>O
M!TM"U^_U.]DM[[38+3",RM%=F;)!7(.47'#KZ\Y]`3UKWD[=;_U_74\MJV_3
M3^OZV.0.K>)ETX7/_"13%GT)]6(^R0<2)C$8^3[AW?-G+<<,O2NWM-4GN/$L
MEBP40#3H;D`#D.[R`\^F%%;-44CL/[=FE5E_M$VR*XW'/E;GV\=/O%^:J_\`
M7W_U\@ZW_KI_P?O+U%%%(`HHHH`****`*TD#I(T]M@2'YG0G"RG;@`G!QVY'
MIWJ2*=925P5=2058$=.XSU'O4M136Z388Y20#"R+PRC()`/H<#([T`2USOB#
MPG;ZQ*M]:RM8ZM$/W5W$.3[./XEK96Y:)UCNMJLQPL@P$<DG"C)SG`'Y\59J
M914E9FM&O4HSYZ;L_P"M^Z\CS%3XIO;F3038BSOI7S<:C&O[I8MH&]3W8XX'
M;CICCO\`1M'L]"TR*PL8]L2<DGEG;NS'N34UL0;B\P5.)AG#EL?NTZC^'Z#Z
M]ZLU,:=G=N[-J^+=2'LX148[M+J^_P`NBV7S"BD9@JEF("@9))X%0?:@YQ;Q
MM+R`6'"C*Y!R>HZ?=SUK0Y"Q4+W4*2^5NW294%$!8KG."0.@X/)XXI@@FDVM
M/+CE6\N(X`('(SU(R?;H*FBBCAC6.)`B*,``=!0!"/M4P4G%NORDKPS=>0>W
M(QTI\5K#"V]5W2;=OF.=SXSG&3SC)Z5-10`4444`%%%%`!1110`5#/;1SK\P
MPW9AUJ:B@#"NK-D!250R'OV-8TFD9F&Q\1D\@]17:LH92K`$'J#6?+IOS@Q,
M`I/(/:HG3C/XD:TZTZ?PLHV=GNVQ1+M1>I]*W(HDAC"(./YT11)#&$0<#]:?
M5I6,VVW=A1110(****`"BBB@"&Z"_99&:W^T;!O6+`)9EY`&>,Y`Q[UFVVL:
M)K^F,&EMY(95*3VMT`&4]TDC;H1T((K8JC>Z+I6IR+)?Z99W;J,*T\"N0/8D
M4`2R1V5[820R);SV;(4=&"M&5[@CICVIDC:;>V[64AM)X)%\MH&*LK+Z;>A'
MM2P:7I]K9/96]C:PVL@(>".%51LC!RH&#D56@\-:#:SI/;Z)IL4T9W))':HK
M*?4$#B@"\\]M;!8WEBBP/E4L%X]A2.+2[AW.(9HE.<MAE%5[W1-)U.99K_2[
M*[E5=H>>W1V`ZXR1TY/YU)!I>GVMD]E;V-K#:R`AX(X55&R,'*@8.10!"D.C
M.ZJD=@SD\!50FIG73[?"2"VBS\P5@J_C5:#PUH-K.D]OHFFQ31G<DD=JBLI]
M00.*EO=$TG4YEFO]+LKN55VAY[='8#KC)'3D_G4N,7N@C[NVA8MA:1PLUJ(%
MBSDF+`'Z4+>6KL%2YA9CP`)`2:CM]*TZTLY+.VL+6&UESYD$<*JCY&#E0,'(
MXJK#X9T"WFCF@T/38I8V#(Z6D:LI'0@@<&J&W=W9H2W,$)`EFCC)Y`=@*<DT
M4D9D21&0=65@1^=4[W1-)U.99K_2[*[E5=H>>W1V`ZXR1TY/YU);Z5IUI9R6
M=M86L-K+GS((X55'R,'*@8.1Q0(D6]M78*ES"S$X`$@)-9UM97/_``ENH:C+
M&$MS:06T)W`F0JTCLV!T'SJ!GG(;MBI(/#6@VTZ3V^B:;%-&=R21VB*RGU!`
MX-:E`!1110`4444`%%%%`!1110`A`8$$<&JOS6"?Q/:HONS1J%_$OG'UY[U;
MHH`II<)"]T\KL%W[E#8.0$7.T#G'UYSGMBGM)<REEAB$8^9?,E/0XX8*.HSZ
ME3Q3X[6WAD>2*"-'=B[,J@$DXR?QP/RJ:@"N+12^^5FE8'(W=%R,'`]/SZFK
M'08%%%`!1110`4444`%%%%`!1110`4444`%%%%`&?KFL6OA_1+S5K[?]FM(S
M))Y:Y;`]!ZU;MKB.ZM8;F(DQRH)$)&,@C(KSOXN>+-!M?!NNZ%/J<*:I):X2
MU.=[9((QQ70>"_%>A:[I=I9:7J<-U<VUI&9HX\Y3"@<\>M`'4T444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!\_?
MM(^'\/I'B.).H-E.P'U=/_9_TKH/V>/#_P#9_@VZUF1,2ZG/A"1_RRCRH_\`
M'B_Y"NX^(OAIO%G@34]*B0-=-'YEMDX_>H=RC/;.,?C6OX?TB+0/#VGZ3!CR
M[.W2$$?Q$#D_B<G\:`-*BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHJ&YN[:SC$EU<101D[0TKA1GTR:`)J*P=2UN!D5M.U
MK2Q(`<K-=(%)ZCD`GJ-I]F)Z@5D2:[K@MV$.K>%&N&MU(:2[;8DVU0P"@9*$
M[CDMGIZ\`'8RW$,#1++*B-*_EQAF`WM@G`]3@$_A4E<AXAUK3'NO#I_M2Q8I
MJ:LY2=<#]S+SUX&36Y+KNDM$XCU>Q5RI"G[2G!_7^1H>@+4TZ*Y*PUFZ_M&Q
M:^UO2!:1V1CND2\1C+<?(0Z_(OR_?';K]VMY=<TEW5$U2R9F.`!<(23^=,"_
M1112`****`"BJ5_JUCIFP74X623_`%<2*7D?_=106;\!5/\`X2C3E.;A+VTC
M/_+6ZLI8HQ]69<+^)%.S%=&S5-M7TU9_(;4+03;MOEF9=V?3&<YJB?%&D36C
MSVURMW"MY%8N8"&`DD=$'/0C+C)'O2MIOAK18H6>STJQC1@L3-''&`PY&"<<
M\9HL]@<DE=FA<ZA963*MW>6\!8942RJN?IDTZWOK2[B:6VNH)HT.&>.0,!]2
M*HS3Z!J14SRZ9=%?NEVC?'TS4\1TJPMV6$V5M"QR0FU%)_#BL95J479R7WBA
M*-32#OZ")K>DR.J)JEDSL<*JW"$D^G6IKG4+*R95N[RW@+#*B655S],FJ5C9
M^'KIC+86VES-$PR\"1L4;J.1T-7;K3[*]*F[L[>X*_=,L0;'TR*T335T7*+B
M[-6'6]]:7<32VUU!-&APSQR!@/J15=-;TF1U1-4LF=CA56X0DGTZU8M[*UM(
MFBMK:&&-CEDCC"@GZ"JZ:)I,<BR1Z99(ZD,K+;H"".A'%,1-<ZA963*MW>6\
M!8942RJN?IDU.DB2H'C=71N0RG(-076GV5Z5-W9V]P5^Z98@V/ID54TZ/2=+
MOIM(T^WCM9"GVMH8H]J88[<@#@<KT'U[T`:E%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!4-Q:V]Y%Y5U;Q3Q
MYSLE0,,^N#4U5-1TO3]7MOLVIV%K>VX8.(KF%9%W#H<,",\F@#,U+2+:!%>Q
M\/Z?<G!W1^1&"2.1R2`,X*_5E/0&LB2*]CMV=/A_933&W65(A-;JJOM7=$6/
M<,3A@N,#Z9GU+P7X?@17L?!6@W)P=T?V"`$D<CDX`S@K]64]`:R9/#MK';LZ
M?"K1)IC;K*D02U55?:NZ(L1U#$X8+C`^F3H'4U?$.C:6MUX=QI=DA?4U#JL"
MX(\F4XZ<C/\`*MR;0M*$$ABTBP,@4[1]F0Y../3^8^M<KK_@SPO#<^'PGAC1
MHO-U)4E5+&(!E\F4[3\O(R!^0K9N/`WA1;:5H?">AM*$)0?V;"<MCC@@9Y]Q
M]12EL$2OI6G2SR6"ZCX9TZ$-:%KQEM8P$N/E.U?F/R\MTW<CJ,?-NIHFDQNK
MII=DKJ<JRVZ`@^O2N5TSPCI$\MDM]X%T.%6M2;HC3+<".?Y"`,,W!!;IN`*_
M>]=R/P3X3AE26+POHL<B,&1UL(@5(Z$';P:I_P!?U_6@D;M<//K7C&_\4:QI
MNA)H0M].:)2U\)M[;TW?P''KV%=Q7FL/B[0O#'C_`,5)K%]]F:>2V,8\IWW`
M1<_=4XZCK3@KM^GZH4W9+^NYT_AWQ)<ZE?WFD:M8"PU>S57DC63?',AZ21GT
MSV[9`)S46KZ_J-D^I30'3UM[*1(1'<DJTSLBL`'W`+]['(/0FJ?AQ[G7_&5[
MXF%G/:Z:+-+.T-Q'L>X&[>9`#R%Y&/7/U%(SQVGC;4Y]2M+U[5=CVOE:?/.C
MLT:*[91&&0$`'?YFJFE<A-VW&Z'XKT2">-+MQ%?W7$]Y/-`0[A2V,I(V%&"%
M'0<#J>>LO[*WU?3)K.<LUO<QE&,<A4E3Z$5@7]U9ZS;?V986%XDETPBDEETR
M:!8XC]\[G10#MR!SG)%=0B+&BHBA548`'0"I?<J/8\TTCX<7_A[4IK.RO!/H
M]Q<VUV&E^_$\$RR;2!UW*&&1WQD"M'XJ_P#(`L?^OP?^@/70>*KB:VTVS>"5
MXV;4[*-BC$$JUQ&&'T()!]C7/_%7_D`6/_7X/_0'K6BVZB;.3'Q4<)-+L<SH
M?1*Z;5_^0*/QKF=#Z)73:O\`\@4?C7Y=G'^^+U./@K^,_49\+/\`CRU;_KZ'
M_H(JUXL;1/\`A)=/7Q4+'^Q?L<QC.H!?(^T;D_O?+OV;L9YQNQWJK\+/^/+5
MO^OH?^@BMO6M>N=/\0Z?812V:K.4_<2H3+<[GVMY1W`#8OSMPW']WK7WV`UP
M]-?UU/K\Z_WVJ_3\D<_-<QI\.M+M+V0^0&MVO8KD_.MB9<;I5/(38`&)[;L]
MZUO!HTP76MG0!`-$,T9M_LF/L_F;!YGE;?EQG;G;QNSWS45QXDN+'6[V9=%M
MVBSY;W)O6\QE1BH^3R\#YFZ!N['KP=+0M?O]3O9+>^TV"TPC,K179FR05R#E
M%QPZ^O.?0$]:]Y.W6_\`7]=3RFK;]-/Z_K8Y`ZMXF73A<_\`"13%GT)]6(^R
M0<2)C$8^3[AW?-G+<<,O2NWMK*>3Q)_;!V""73HX0N?FW;V8_A@BMFL5;RX/
MC:6R\T_9AIR2B/MO,C#/Y`55_P"OO_KY!UO_`%T_X/WFU1112`****`"H+J\
MM[&`S74R11CJSG`J265(8FED8*B#+,>@%>-^+_$SZ]?F.)B+.(XC7^][FN7%
MXJ.'A=[]#OR_`RQ=3E6B6[/1YO&WA^'.;]&Q_<&:T]+U6SUFQ6\L9?,A8D!L
M=Q7SAK,TUIMMS&\;.N[+#&1[5Z-\&-7\RTO=*=N8R)HQ['@_T_*N?"8NI5E^
M\5KGH8_*:5"@ZE)MM'=>+?$UMX2T";5;F-Y50A51.K,>!6+\-?%E[XPTF]U&
M\1(\7)2.-.BKCI[UG_&W_DGDW_7>/_T*N0^$_C;0/"_A*ZCU6^6*5K@L(@-S
M$8'.*]=1O"Y\RYM5+/8]UHKB=+^*_A'5KQ;6'4&CD<X7SXR@)^IKK[J\M[*T
MDNKF9(H(UW-(YP`*S::W-E)/9D]%>>W?QH\'VT[1+<SS;>K1PDK^![UI:#\3
M?#'B*^CLK*\<74APD<L97<?04^22Z$JI%NUSGOB!\49-`UF/0=+@S>%D$L\@
MX0$]AW->GQDF-2>I`-?,WQ48)\5968X56B))["O7KCXO>#K&46[:@\K*`"T4
M19?SJY0T5D9PJ>\^9G>T5E:'XCTGQ):?:=*O([A!]X`_,OU':M">XAMHS)-(
MJ*.Y-9&R:>J):*QV\2Z<K8#N?<+5ZTU"WO8GE@8E4ZY&*!EJBL=_$M@K84R/
M]%J:UUVQNI!&LA5ST#C%`&E12,RHI9B`HY)-9DGB'3HW*F8MCNJDB@!NL:G+
M926\,2C,IY8]AFM:N3UF^M[Z\LFMY-P!Y]N1764`%5-1TVVU6V%O="4QA@V(
MIWB.1[H0>_2K=5-1L/[1MA#]KNK7#!M]M)L8^V<=*`.<U+PUI&GHLBV&J7"$
M$L(=0NF88YZ!CV#8]2`.K"LF2'18;=I6\-^*V/V=;A(HY;IG8%5)4_O-H<%L
M;<YX/H<:&NV=EX=LHKN^\0:\(9)T@RM\H(+'&<-C('4@9.`>#BH;,Z-J&H0V
M5GXI\0SR3)OCD220Q.,;N)=FSH,XW4+4-AFO^$](CN?#^R.]7S=256#:A.2!
MY,I_O\'@<BMBY\(:-!:S3+!?R-&A8(NHW)+$#.!AR?R!K(\0^&O*O-`']MZR
M_F:FJY>[SM_=2G(XX/'ZFMO_`(17_J/Z[_X&?_6H>NP+S.=TNPT_4=1TZUDT
M'6+9;FP^TSR27]Z!;2_+^Y;.!NPQ/)!XZ5TT7@_1H94E1+T.C!E)U&X/(]B]
M9.F6-MJM]J5G!KNO"33YA#+G48VR2,Y`4D@?[P4]>.*U8O#'E3))_;FM/L8-
MM>[RIQV(QTIL#>HHHI`%%%%`!1110!1UB^M=,TR2]O8C);0,CR80-L&X?.<]
ME^\3V"DU+<6EEJ4""YM[>ZBR'02(KKG'!&?8]:L$!E*L`01@@]ZPY/!?AF5]
MSZ%89P!Q"``!P``*!-)JS-%-)TV+_5Z?:)_NPJ/Z5*]C:2)L>U@9/[K1@BH)
M]&TVYTQ--GLH9+)`H6!ERH"]./:H-.\-Z+I%R;C3],MK:8J4+Q)@X]/T%92H
MTI.[BON%",:>L%;T+MK86=BKK9VD%N'.YA#&$W'U..M6*QKOPEX?O[J2ZN]'
MM)IY#EY'C!+'WJW-HVFW&EKIDME"]BH55@9?D`'3CVK1))61<I.3NW<O45E:
M=X:T32;G[3I^F6UM,5*[XDP<'M^E1WGA/P_J%W)=7>D6DUQ(<O(\8);C'-,1
MLUGV]UIUSK=Y'`$>^M8HTGD"?=#%BJ;O7N5[;@>XITNC:;/I:Z9+90O8H%"P
M%?E`'3CVJ6PTZRTNU6UL+2&U@4DB.%`JY/4X'<^M`%FBBB@`HHHH`\J^(WC6
M..[ET.%G018\]L?>/7`]JS/AYI$/B34);B56^RVN"0?XV/0?2H/BEX>N!XI;
M45@?[)-&I:0+QN&<C/TQ7+V>HW>CQ,;*ZE@&,G8^,UX5=Q6(YJJ;/LL+2YL"
MH8=V;6_GU/0OC!H$;V%GJMNBK)"?)8`=5/3\JXGX=W%UIWC.R=(G*R-Y;@`]
M#P?RILGC/6=;TW^S+^43QA@ZL5^?/85ZKX!\'KH]J-2O8P;Z9?E##_5+_B:Z
M$W5Q'[M:;LYYR^I8%TJ[NW=(H_&W_DGDW_7>/_T*N`^%'PYTGQ5IUQJ>JM+(
ML<OEK"AVCIU)KO\`XV_\D\F_Z[Q_^A50^`W_`")]Y_U]'^0KVTVJ>A\9**=:
MS.`^+G@O3/"5]I\NDAXXKE6W1LV=I7'(_.M[QUJ5_>_!+PY.7<K,RK.<]0`P
M&?Q`J;]H+[^B?23^E=3X>.A_\*7TI?$)C&G/"$=GZ`ER`?SJK^[%LGE7/**T
M//\`P+'\-!X>C;7V0ZD6/FB<G`YXVX[5W7AGPU\/+S7K;4O#EVOVNU;>(HYL
M@_4&L=?AI\.;H&:WUPB-N1BY7@?C7FUG''H7Q/@@T&\:XAAO%2&53]\'&1[]
MQ1\5[-BNX6YDC1^+$0F^*-Q$QP'\I21[UZI'\%/"?]G^5Y=R963_`%IEY!]>
ME>6_%5UC^*LSL<*K1$GT%>ZR>//#%KIOVIM9M&1$SA'R3[`43<N56*IJ+E+F
M/#/`4UUX2^+,>E+*Q1KEK24=F!/!(_6O<+M3JOB06DC'R8NP]N37AW@I9O%7
MQ@CU*%&\L7373G^Z@/&?TKW&9QIOBHS2\12]_J,5-7<O#_"SH8["TB0*MO%@
M>J@T]((8581QJBM]X`8!J165U#*P(/0@UGZW*Z:1.8S\V,''85B;D+W^C6I\
MO]SD=0J9K&URXTZ>..6S*B8-SM&.*T-!T^QETY97C224D[MW:JOB.&QA@C%N
ML:REN0O7%,"36KF62RL;8-@SJ"Q]:V+;2+.VA5!`C''+,,DUAZPC):Z9=`?+
M&H!_0UTL$\=S"LL3!E89X-(#FM=M(+;4+,PQ*F\_-M[\UU5<WXD(^WV(]_ZB
MNDH`****`"BBB@"G?:;#J$ME)*S@V=P+B/:1RP5EP?;#FKE%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`,EBCFC:.5%=
M&&"K#(-<1KGPNTC569[65[%F.6$:[E/X'I7=45G.E"I\2N;4<15H.].5C@?#
MGPLT_0=46^DO)+PH/D1T"@'UZ\UWU%%.%.,%:*"OB*E>7-4=V<_XQ\+1>,-!
M;2IKE[=&=7WHH8\'/>H?!'@Z'P5I,MA!=R7*R2^9O=0I''3BNFHK3F=K'/RJ
M_-U.,\=_#VW\<M9F>_EM?LH;&Q`V[./7Z58?P)8W'@.#PG<W$TEM$H`E7"L2
M&W`_G75T4^9VL')&[?<\:E_9^L2^8M<N`OHT(X_6NF\)?"71/"U^E_YLM[=I
M]QY0`$/J`.]=_13=235KDJE!.Z1P'BOX3:1XJU>74YKNY@N)%`;9@CCV-<ZO
M[/\`I8<%M;NRN>1Y2U[#10JDEU!TH-W:.?\`"W@S1_"%JT.F0D/)_K)G.7;\
M?2M:]L+>_BV3IG'1AU%6J*EMO<M))61@?\(T5XBOYE7TK0LM+2TMI87E:=9/
MO;ZOT4AF$WAB'>3#=31*?X13SX9LS`R%G,C?\M"<D5M44`5S9Q/9"UE&^,*%
EYK)_X1H1L?(O9HU/\(K>HH`PXO#4*S++-<RRLIR,UN444`?_V1/9
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
        <int nm="BreakPoint" vl="1381" />
        <int nm="BreakPoint" vl="1353" />
        <int nm="BreakPoint" vl="2114" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22805 retriggering schedule upon creation to update relatiions" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="10/18/2024 4:07:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22805 dormer opening areas are subtracted from main roof and are not separately listed anymore" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="10/11/2024 3:30:31 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20108: Special (RUB) In schedule mode collect only roof planes that have groups turned on" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="9/21/2023 1:04:17 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19481: Fix pl when creatng pp from pl" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="7/18/2023 2:41:49 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19481: check if pp operation fails in eave area and inner area" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="7/18/2023 11:51:31 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19192: Fix catalog for the RoofDataEdge" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="6/14/2023 9:57:40 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18550: Prompt PLine for inner area" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="4/12/2023 11:29:39 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18550: Consider Rafters at Eave area &quot;Sparrenkopf&quot;" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="4/11/2023 11:41:49 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15819: dont assign table in group for projectSpecial ==&quot;Baufritz&quot;" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="7/5/2022 10:10:34 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11712 tolerance issue catched when merging complex roof shapes" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="4/28/2021 9:59:00 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End