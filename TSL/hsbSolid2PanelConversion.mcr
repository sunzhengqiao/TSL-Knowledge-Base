#Version 8
#BeginDescription
#Versions
Version 7.8 23.11.2022 HSB-16642 bugfix converting seatcuts
Version 7.7    23.02.2022   HSB-14486 bugfix when converting combination of risingSeatCut and japanesHipCut liek a doublecut
Version 7.6    21.10.2021   HSB-11073 bugfix when converting a combination of  a risingSeatCut and a valleyBirdsmouth like a doublecut
Version 7.5    03.02.2021   HSB-6753 the solid to panel conversion supports now freeprofiles to be translated into arc segments

HSB-6763 freeprofile added to supported tools

EN
This TSL converts solids into hsbPanels under respect of typical CLT requirements

DACH
Dieses TSL kann auch von anderen TSL's mit Berücksichtigung benutzerdefinierter Parameter aufgerufen werden.













#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 7
#MinorVersion 8
#KeyWords 
#BeginContents
//region History

/// <summary Lang=de>
/// Dieses TSL konvertiert Voluemnkörper in hsbCAD Panele unter Berücksichtigung typischer CLT Anforderungen
/// </summary>
/// <summary Lang=en>
/// This TSL converts solids into hsbPanels under respect of typical CLT requirements
/// </summary>
/// <insert=de>
/// Wählen die zu konvertierenden Volumenkörper.
/// </insert>
/// <remark Lang=de>
/// Dieses TSL kann auch von anderen TSL's mit Berücksichtigung benutzerdefinierter Parameter aufgerufen werden.
/// </remark>

/// History
// #Versions
// 7.8 23.11.2022 HSB-16642 bugfix converting seatcuts , Author Thorsten Huck
// 7.7 23.02.2022 HSB-14486 bugfix when converting combination of risingSeatCut and japanesHipCut liek a doublecut , Author Thorsten Huck
// 7.6 21.10.2021 HSB-11073 bugfix when converting a combination of  a risingSeatCut and a valleyBirdsmouth like a doublecut , Author Thorsten Huck
// 7.5 03.02.2021 HSB-6753 the solid to panel conversion supports now freeprofiles to be translated into arc segments , Author Thorsten Huck
///<version value="7.4" date="05Jan2020" author="thorsten.huck@hsbcad.com"> HSB-6753 freeprofile added to supported tools </version>
///<version  value="7.3" date=15sep2020" author="david.delombaerde@hsbcad.com"> HSB-8058 bugfix Bodyimporter convertion - Drills are missing</version>
///<version  value="7.2" date=08sep2020" author="thorsten.huck@hsbcad.com"> HSB-8376 bugfix toggeling between basic and full solid mode </version>
///<version  value="7.1" date=08sep2020" author="thorsten.huck@hsbcad.com"> HSB-8376 bugfix JapaneseHipCut and OpenDiagonalSeatCut </version>
///<version  value="7.0" date=25jun2020" author="thorsten.huck@hsbcad.com"> HSB-8054 HSB-8047 bugfix during cloning instance </version>
///<version  value="6.9" date=24jun2020" author="thorsten.huck@hsbcad.com"> HSB-8054 chamfers not converted in basic mode </version>
///<version  value="6.8" date=24jun2020" author="thorsten.huck@hsbcad.com"> HSB-8054 edge stretching enhanced</version>
///<version  value="6.7" date=23jun2020" author="thorsten.huck@hsbcad.com"> HSB-8047 new property to convert the full solid or the bounding box of source entity. Not applicable if the source entity is of type beam </version>
///<version  value="6.6" date=19jun2020" author="thorsten.huck@hsbcad.com"> HSB-7614 performance further enhanced if based on beam, converting progress logged </version>
///<version  value="6.5" date=08jun2020" author="thorsten.huck@hsbcad.com"> HSB-7614 performance and quality enhanced using acis modeling </version>
///<version  value="6.4" date=13may2020" author="thorsten.huck@hsbcad.com"> HSB-6972 conversion of beveled and edge drills supported </version>
///<version  value="6.3" date=27mar2020" author="thorsten.huck@hsbcad.com"> HSB-5458 bugfix style order </version>
///<version  value="6.2" date=26mar2020" author="thorsten.huck@hsbcad.com"> HSB-5458 tolerance bugfix on lapjoint conversion </version>
///<version  value="6.1" date=15aug19" author="robert.pol@hsbcad.com"> IAI-22 When importing with vx and vz in the map it was not checking size in those directions </version>
///<version  value="6.0" date=03may19" author="thorsten.huck@hsbcad.com"> HSBCAD-632 bugfix seatcuts contribute to contour 	</version>
///<version  value="5.9" date=11feb19" author="thorsten.huck@hsbcad.com"> UKD-77 bugfix lapJoints added to chamfer tests </version>
///<version  value="5.8" date=11feb19" author="thorsten.huck@hsbcad.com"> UKD-77 bugfix take II </version>
///<version  value="5.7" date=10jan19" author="thorsten.huck@hsbcad.com"> UKD-77 bugfix japaneseHipCuts </version>
///<version  value="5.6" date=04jan19" author="robert.pol@hsbcad.com"> only strech to non free directions of beamcut </version>
///<version  value="5.5" date=19sep18" author="thorsten.huck@hsbcad.com"> edge drills improved </version>
///<version  value="5.4" date=14sep18" author="thorsten.huck@hsbcad.com"> automatic cleanup of referenced bodyImporter when conversion is accepted </version>
///<version  value="5.3" date=13apr18" author="thorsten.huck@hsbcad.com"> tilted beamcuts further enhanced </version>
///<version  value="5.2" date=13apr18" author="thorsten.huck@hsbcad.com"> tilted house adjusts vertices, double cuts with slightly 90° are converted into beamcuts </version>
///<version  value="5.1" date=07mar18" author="thorsten.huck@hsbcad.com"> rabbet detection enhanced </version>
///<version  value="5.0" date=07mar18" author="thorsten.huck@hsbcad.com"> pocket detection added, requires v21.3.1, v22.0.32 or higher </version>
///<version  value="4.9" date=07feb18" author="thorsten.huck@hsbcad.com"> calculation of panel contour completely revised, solid drill conversion imroved </version>
///<version  value="4.8" date=13oct17" author="thorsten.huck@hsbcad.com"> meta data based style only set on creation </version>
///<version  value="4.7" date=09oct17" author="thorsten.huck@hsbcad.com"> ambigious style detection enhanced </version>
///<version  value="4.6" date=09oct17" author="thorsten.huck@hsbcad.com"> new context command to discard conversion </version>
///<version  value="4.5" date=09oct17" author="thorsten.huck@hsbcad.com"> prefiltered panel styles enhanced </version>
///<version  value="4.4" date=14aug17" author="thorsten.huck@hsbcad.com"> added support for prefiltered panel styles </version>
///<version  value="4.3" date=06jul17" author="thorsten.huck@hsbcad.com"> bugfix stretch edge by beamcut </version>
///<version  value="4.2" date=09dec16" author="thorsten.huck@hsbcad.com"> bugfix opening ring detection </version>
///<version  value="4.1" date=03nov16" author="florian.wuermseer@hsbcad.com"> added support for "information" field in meta data </version>
///<version  value="4.0" date=11mar15" author="th@hsbCAD.de"> post-processing through meta data supported </version>
///<version  value="3.9" date=11mar15" author="th@hsbCAD.de"> bugfix threshold cuts </version>
///<version  value="3.8" date=19sep14" author="th@hsbCAD.de"> supports source object meta data </version>
///<version  value="3.7" date=15sep14" author="th@hsbCAD.de"> Beamcut/Edge Stretching (Rafter CutOuts) enhanced </version>
///<version  value="3.6" date=05aug14" author="th@hsbCAD.de"> pocket beamcut removal: small beamcuts with up to size 60x6x6 (XYZ) are removed as they are assumed to be grain definitions </version>
///<version  value="3.5" date=04aug14" author="th@hsbCAD.de"> openings are now added plumb or perpendicular to the panel. If an intersection with the reference envelope is found the opening is added as beamcut</version>
///<version  value="3.4" date=04aug14" author="th@hsbCAD.de"> drill / opening conversion further enhanced </version>
///<version  value="3.3" date=17jul14" author="th@hsbCAD.de"> drill / opening conversion enhanced, new context command to rotate X-Axis and grain direction </version>
///<version  value="3.2" date=04jul14" author="th@hsbCAD.de"> posnum by meta data enhanced </version>
///<version  value="3.1" date=02jul14" author="th@hsbCAD.de"> posnum by meta data corrected </version>
///<version  value="3.0" date=25jun14" author="th@hsbCAD.de"> cuts further improved </version>
///<version  value="2.9" date=25jun14" author="th@hsbCAD.de"> coordinate system of panel aligned with WCS if parallel, new property 'Color' </version>
///<version  value="2.8" date=24jun14" author="th@hsbCAD.de"> coplanar stretching planes supported(test case 18), cut conversion revised </version>
///<version  value="2.7" date=30may14" author="th@hsbCAD.de"> bugfix of throughout openings, new method to detect double cuts (test case 11), LapJoints will not lead to individual beamcuts (tet case 16) </version>
///<version  value="2.6" date=25apr14" author="th@hsbCAD.de"> bugfix threshold value drills, perpendicular drills will be attached as hsbPanelDrill if applicable </version>
///<version  value="2.5" date=15apr14" author="th@hsbCAD.de"> sink holes are converted, cut thresholds supported</version>
///<version  value="2.4" date=14apr14" author="th@hsbCAD.de"> extended conversion data accepted: new threshold value to option drills and openings</version>
///<version  value="2.3" date=10apr14" author="th@hsbCAD.de"> edge independent static cuts added </version>
///<version  value="2.2" date=09apr14" author="th@hsbCAD.de"> static cuts further improved </version>
///<version  value="2.1" date=09apr14" author="th@hsbCAD.de"> sinkhole drills detected </version>
///<version  value="2.0" date=09apr14" author="th@hsbCAD.de"> inner or concave sip edges do not contribute to stretching </version>
///<version  value="1.9" date=08apr14" author="th@hsbCAD.de"> drill detection more tolerant </version>
///<version  value="1.8" date=08apr14" author="th@hsbCAD.de"> preconversion tolerance enhanced </version>
///<version  value="1.7" date=08apr14" author="th@hsbCAD.de"> cuts completely revised </version>
///<version  value="1.6" date=08apr14" author="th@hsbCAD.de"> redundant cut normal removal added </version>
///<version  value="1.5" date=08apr14" author="th@hsbCAD.de"> preconversion uses rounding flag </version>
///<version  value="1.4" date=07apr14" author="th@hsbCAD.de"> redundant beamcut removal added </version>
///<version  value="1.3" date=06mar14" author="th@hsbCAD.de"> bugfix </version>
///<version  value="1.1" date=22jan14" author="th@hsbCAD.de"> initial </version>		


//End History//endregion 

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
	
// keys of potential map contents
	String sKeyStructure = "STRUCTURE";
	String sKeyHeight = "HEIGHT";
	String sKeyQuality = "QUALITY";
	String sKeyLabel = "LABEL";
	String sKeySublabel = "SUBLABEL";
	String sKeyMaterial = "MATERIAL";
	String sKeyGrade = "GRADE";
	String sKeyInformation = "INFORMATION";
	String sKeyName = "NAME";
	String sKeyWallNumber = "WALLNUMBER";
	String sKeyPosNum = "POSNUM";
	String sKeySQRef = "SQREF";
	String sKeySQOpp = "SQOPP";		
	String sKeyTruck = "TRUCK";
	String sKeyLevel = "LEVEL";	
	String sKeyStyle = "STYLE";		

// declare constants for beamcut sizes which will be ignored for conversion
	double dMaxX=U(100), dMaxY=U(10), dMaxZ=U(10);

	
//end constants//endregion

//region Properties

// collect panel styles	and its thickness
	String sStyles[0];		
	sStyles.append(SipStyle().getAllEntryNames());
	sStyles = sStyles.sorted();
	sStyles.insertAt(0,T("|Auto|"));
	
	double dThicknesses[0];
	dThicknesses.append(0);	// auto thickness	
	for(int i=1;i<sStyles.length();i++)
	{
		SipStyle style (sStyles[i]);
		dThicknesses.append(style.dThickness());
	}
	
// get all surface quality style entries
	String sSqStyles[] = SurfaceQualityStyle().getAllEntryNames();
	
// if the conversion beam exists reduce the styles to the matching thicknesses
	if (_Beam.length()>0)
	{
		double dH = _Beam[0].dW() < _Beam[0].dH() ? _Beam[0].dW() : _Beam[0].dH();
		int nThickness=dH*1000;
		double dThickness=(double)nThickness/1000;//version  value="1.8" date=08apr14" author="th@hsbCAD.de"> preconversion tolerance enhanced
		if (dThicknesses.find(dThickness)>-1)
		{
			for(int i=sStyles.length()-1;i>=1;i--)
			{
				if (abs(dThicknesses[i]-dThickness)>dEps)
				{
					sStyles.removeAt(i);
					dThicknesses.removeAt(i);
				}	
			}		
		}
		//if (bDebug)reportMessage("\n	validated Styles: " + sStyles + " with thickness " + dThicknesses);
	}				
	
// declare properties
	String sStyleName =T("|Panel Style|");		
	PropString sStyle(nStringIndex++, sStyles, sStyleName);	
	sStyle.setDescription(T("|Sets the style of the conversion.|") + " " + 
		T("|The style must match the thickness of the solid.|") + " " + 
		T("|If multiple styles match the thickness the automatic detection will not function and the TSL will prompt the user has that a style has to be selected.|"));

	String sModeName=T("|Mode|");
	String sModes[] ={ T("|Full Conversion|"), T("|Basic Conversion|")};
	PropString sMode(nStringIndex++, sModes, sModeName);	
	sMode.setDescription(T("|Defines the preconversion mode.|")+ T("|Full = attempting to convert all tools|") + T(", |Basic = attempting to convert the bounding box with basic beamcuts|"));
	sMode.setCategory(category);

	String sColorName = T("|Color|");
	PropInt nColor(0,152,sColorName);		
//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
	// standard dialog	
		else	showDialog();

	// get ints from properties
		int nMode = sModes.find(sMode, 0);
		int bBoundingBody = nMode == 1;
	
	// get selection set
		PrEntity ssE(T("|Select solids|"), Entity());
		Entity ents[0];
		if (ssE.go())
			ents = ssE.set();
		
	//region Collect and order bodies of selected entities
		Entity entDrills[0];
		Body bdDrills[0]; // to cache the solid of the drill ents
		if(bDebug)reportMessage("\n" + ents.length() + " " + T("|entities selected|"));
		Body bodies[ents.length()];
		for (int i=ents.length()-1;i>=0;i--)
		{
			Entity ent = ents[i];
			if (ent.bIsKindOf(GenBeam())){ continue;}// HSB-7614 increase performance
			
			Body bd = ents[i].realBody();
			if (bd.volume()<pow(U(1),3))
			{
				ents.removeAt(i);
				bodies.removeAt(i);
				continue;
			}
		// filter potential drill solids by the number of grips, remove very small solids
			if (ents[i].gripPoints().length()==2)
			{
				entDrills.append(ents[i]);
				bdDrills.append(bd);
				ents.removeAt(i);
				bodies.removeAt(i);
				continue;
			}	
			bodies[i] = bd;
		}	
		if(bDebug)reportMessage(", " + entDrills.length() + " " + T("|detected as drills|"));		

	// order main solids by volume
		for (int i=0;i<ents.length();i++)
			for (int j=0;j<ents.length()-1;j++)
			{
				double d1 = bodies[j].volume();
				double d2 = bodies[j+1].volume();			
				if (d1>d2)
				{
					ents.swap(j,j+1);
					bodies.swap(j,j+1);
				}
			}
	//End Collect and order bodies of selected entities//endregion 
		
	//region Create instance for each main solid	
		TslInst tslNew;
		GenBeam gbsTsl[1];			Entity entsTsl[] = {};			Point3d ptsTsl[1];
		int nProps[]={nColor};		double dProps[]={};				String sProps[]={sStyle, sMode};
		Map mapTsl;	

		for (int i=0;i<ents.length();i++)	
		{
			Entity ent = ents[i];
			int bIsBeam = ent.bIsKindOf(Beam());
			
			Body bdMain = bodies[i];
	
		// collect drill entities per main solid by intersection
			Entity entMyDrills[0];
			for (int d=0;d<bdDrills.length();d++)
			{
				Body bd = bdMain;
				bd.intersectWith(bdDrills[d]);
				if (bd.volume()<pow(U(1),3))continue;
				entMyDrills.append(entDrills[d]);
			}
			
		// create an individual instance per main body 
			mapTsl.setEntity("mainSolid", ent); //store ref in map	
			entsTsl.setLength(0);		
			entsTsl.append(entDrills);


		// convert main to beam	and validate	
			Beam bm;
			if (bIsBeam)	bm = (Beam)ent;
			else			bm.dbCreate(ents[i],true,bBoundingBody);//HSB-7614 performance and quality enhanced using acis modeling 
			if (!bm.bIsValid())
			{ 
				reportMessage("\n" + scriptName() + ": " +T("|could not convert solid| ") + ents[i].typeDxfName() + T(" |due to its complexity|"));
				eraseInstance();
				return;
			}

			Vector3d vx,vy,vz;
			vx = bm.vecX();
			vy = bm.vecY();
			vz = bm.vecZ();
			// make sure height is the smallest value, swap Y and Z
			if (!bIsBeam && bm.dW()<bm.dH())
			{
				
				bm.dbErase();
				bm.dbCreate(ents[i],vx, vz,-vy, true,bBoundingBody);	//HSB-7614 performance and quality enhanced using acis modeling 
				if (!bm.bIsValid())
				{ 
					reportMessage("\n" + scriptName() + ": " +T("|could not convert solid| ") + ents[i].typeDxfName() + T(" |due to its complexity|"));
					eraseInstance();
					return;
				}
			
			}
			
			if (bm.bIsValid())
			{ 
			// toggle visibility of beam if conversion entity is not of type beam	
				if (!bIsBeam)
				{
					bm.setBIsDummy(true);
					if (bDebug)	
						bm.setIsVisible(true);				
					else
						bm.setIsVisible(false);
				}
				gbsTsl[0]=bm;	
				ptsTsl[0] = bm.ptCen();
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				
			}
			else
				reportMessage("\n" + T("|Creation of conversion instance failed for| ") + ent.handle());
		
		}		
					
	//End Create instance for each main solid//endregion 		

	// erase the caller	
		eraseInstance();
		return;	
		
	}	

//End OnINsert//endregion 

//region onMapIO
/// on mapIO
	if (_bOnMapIO)
	{
		int bDebugIO=true;
		//if (bDebugIO)reportMessage("\n" + scriptName() + " mapIO call...");
		Map mapIn=_Map;	
		Map mapOut;
		_Map = mapOut; // clear _Map and initialize as invalidation map
				
		int nFunction = mapIn.getInt("function");
		if (nFunction<=0)return;
	// function 1: evalueate meta data
		if (nFunction==1)
		{	
			//if (bDebugIO)reportMessage("\n	starting IO function " + nFunction);	
		// get args
			Entity ent;
			ent = mapIn.getEntity("sip");
			Sip sip = (Sip)ent;		
			Map mapMeta = mapIn.getMap("metaData");
			
		// set potential meta data
			if (mapMeta.length()>0 && sip.bIsValid())
			{
			// posnum assignment
				if (0 && mapMeta.hasInt("PosNum"))
				{
					
					int nPosRequested =mapMeta.getInt("PosNum");
					int nPos=-1;
					reportMessage("\n	" + sip.handle() + " has pos before " + sip.posnum() + " requested is " + nPosRequested );
					if (nPosRequested >0)
					{
						sip.releasePosnum(true);
						//nPos = 
						sip.assignPosnum(nPosRequested);
						reportMessage("\n	" + sip.handle() + " has pos after " + sip.posnum());	
						/*
						if (nPos!=nPosRequested)
						{
							sip.releasePosnum(true);
							int nPosX = sip.assignPosnum(nPosRequested+1000);
							if (bDebugIO)reportMessage("\n	"+ sip.handle()+ " IO " + T("Could not assign requested posnum") + " " + nPosRequested + ". " + T("|PosNum is set to|") + " " + nPosX +". ");// + T("Requested Posnum is written in Sublabel2"));
							sip.setSubLabel2(nPosRequested);	
						}	
						else if (bDebugIO)
							reportMessage("\n	" + sip.handle() + "IO has received pos num " + sip.posnum());
						*/		
					}
					else if (bDebugIO)
						reportMessage("\n	" + sip.handle()+": The meta data send the req pos: " + nPosRequested);
					
					if (bDebugIO)
						reportMessage("\n	pos/posreq"+nPos+"/" + nPosRequested);
				}
			// name assignment
				if (mapMeta.hasString("Name"))sip.setName(mapMeta.getString("Name"));
			// material assignment
				if (mapMeta.hasString("Material"))sip.setMaterial(mapMeta.getString("Material"));
			// information assignment
				if (mapMeta.hasString("Information"))sip.setInformation(mapMeta.getString("Information"));
			// label assignment
				if (mapMeta.hasString("Label"))sip.setLabel(mapMeta.getString("Label"));
			// SubLabel assignment
				if (mapMeta.hasString("SubLabel"))sip.setSubLabel(mapMeta.getString("SubLabel"));
			// grade assignment
				if (mapMeta.hasString("Grade"))sip.setGrade(mapMeta.getString("Grade"));			
			// surfaceQualityBottom override assignment
				if (mapMeta.hasString("surfaceQualityBottom"))
				{
					String s = mapMeta.getString("surfaceQualityBottom");
					if (sSqStyles.find(s)>-1)
					{
						sip.setSurfaceQualityOverrideBottom(s);	
					}	
				}
			// surfaceQualityTop override assignment
				if (mapMeta.hasString("surfaceQualityTop"))
				{
					String s = mapMeta.getString("surfaceQualityTop");
					if (sSqStyles.find(s)>-1)
					{
						sip.setSurfaceQualityOverrideTop(s);	
					}	
				}	
				
			// add tsl's if defined	
				if (mapMeta.hasMap("scriptNames"))
				{
					//reportMessage("\nscriptName map detected");
					Map mapScripts =mapMeta.getMap("scriptNames");
					for (int m=0;m<mapScripts.length();m++)
					{
						if (mapScripts.hasString(m))
						{
							//reportMessage("\n	scriptName: "+mapScripts.getString(m));
							TslInst tsl;
							Vector3d vxUcs= sip.vecX();
							Vector3d vyUcs= sip.vecY();
							GenBeam gbAr[0];
							Entity entAr[0];
							Point3d ptAr[0];
							int nArProps[0];
							double dArProps[0];
							String sArProps[0];
							gbAr.append(sip);
							ptAr.append(sip.ptCentreOfGravity());
							Map mapTsl;
							String sScriptname = mapScripts.getString(m);
							tsl.dbCreate(sScriptname , vxUcs,vyUcs,gbAr, entAr, ptAr, 
								nArProps, dArProps, sArProps,_kModelSpace, mapTsl); 	
							if (tsl.bIsValid())
							{
								tsl.setPropValuesFromCatalog(T("|_LastInserted|"));
								//reportMessage("\n	scriptName: "+tsl.handle() + " properties set");
							}
						}	
					}	
					
				}		
			}// END IF set potential meta data	
			
			
		}				
	// END function 1: evalueate meta data
		_Map=mapOut;
		return;		
	}
// end mapIO	__________________________________________________ end mapIO ___________________________________________________________________________________ end mapIO
		
//End onMapIO//endregion 

// declare the source ref and its coordSys
	Entity entSolid;		
	Vector3d vx,vy, vz;
	Body bdSolid;
// declare meta data map
	Map mapMeta;	
	mapMeta = _Map.getMap("metaData");
	double dThresholdDrill = mapMeta.getDouble("ThresholdMaxDrill");// defines the threshold up to which diam a drill/round opening will be converted into a drill
	double dThresholdCutNormal = mapMeta.getDouble("ThresholdCutNormal");// defines the threshold up to which abs angle relative to the sips normal a potential cut normal will be added
	double dThresholdEdge = mapMeta.getDouble("ThresholdEdge");// defines the threshold up to which abs angle relative to the sips normal a potential stretch plane will be added	
	int bConvertDrills = true;
	if (mapMeta.hasInt("ConvertDrills"))
		bConvertDrills =mapMeta.getInt("ConvertDrills"); // defines an optional toggle to exclude drills from conversion, default = true (convert)


	int nMode = sModes.find(sMode, 0);
	int bBoundingBody = nMode == 1;


	if (_Map.hasVector3d("vx") && _Map.hasVector3d("vz"))
	{
		vx=_Map.getVector3d("vx");
		vz=_Map.getVector3d("vz");
		vy=vx.crossProduct(-vz);
	}
	
// interrogate _Map if a conversion map exists
	Map mapConvert;
	if (_Map.hasMap("RefData"))
	{
		mapConvert=_Map.getMap("RefData");
		entSolid = mapConvert.getEntity("mainSolid");	
		if (!entSolid.bIsValid())
		{
			reportMessage("\n	Reqeuested main solid is not valid " + entSolid.handle());
			eraseInstance();
			return;
		}
		
		vx = mapConvert.getVector3d("vx");
		vz = mapConvert.getVector3d("vz");
		vy = vx.crossProduct(-vz);
	// the bref
		Entity entBref=mapConvert.getEntity("BRef");
		if (!entBref.bIsValid())
		{
			reportMessage("\n	Reqeuested blockReference is not valid " + entBref.handle());
		}
		BlockRef bref= (BlockRef )entBref;
		String sDefinition = bref.definition();
		double dScaleX =bref.dScaleX();
		double dScaleY =bref.dScaleY();
		double dScaleZ =bref.dScaleZ();
		
	// the scaled coordSys of the bref entity
		CoordSys cs = bref.coordSys();
		cs.setToAlignCoordSys(_PtW,cs.vecX(),cs.vecY(),cs.vecZ(),cs.ptOrg(),cs.vecX()*dScaleX ,cs.vecY()*dScaleY ,cs.vecZ()*dScaleZ );
		
		bdSolid=	entSolid.realBody();	
		bdSolid.transformBy(cs); 
		//PLine(bdSolid.ptCen(),_PtW).vis(3);
		_Pt0=bdSolid.ptCen();
		mapMeta = mapConvert.getMap("metaData");
		
		if (bDebug)reportMessage("\n	BlockRef data attached (in mapMeta): " + mapMeta);
		//Display dpDebug(3);
		//dpDebug.textHeight(U(100));
		//if (_ThisInst.handle()=="6BEE") dpDebug.color(211);
		//dpDebug.draw(_ThisInst.handle() + " es: " +entSolid.handle() + " vs " + entBref.handle(),_Pt0,_XW,_YW,0,0);
	}
		
// validate source ref from sset
	else if (!entSolid.bIsValid() && _Map.hasEntity("mainSolid"))
	{
		entSolid = _Map.getEntity("mainSolid");
		bdSolid = entSolid.realBody();
		if (bDebug)reportMessage("\n	main Solid: " + entSolid.handle());		
	}
	else if (!entSolid.bIsValid() && !_Map.hasEntity("mainSolid"))
	{
		reportMessage("\n	" + T("|No solid found.|"));
		eraseInstance();
		return;			
	}
// get meta data mapX if set
	Map mapConversion = entSolid.subMapX("ConversionMetaData");	


// recreate beam if mode toggled
	if (_Beam.length()>0 && _kNameLastChangedProp==sModeName)
	{ 
		_Beam[0].dbErase();
		if (_Sip.length()>0)_Sip[0].dbErase();
		setExecutionLoops(2);
		return;
	}

// get basic ref from solid
	Beam bm;
	int bIsBeam = entSolid.bIsKindOf(Beam());
	
	//if (_bOnDebug)_Beam.setLength(0);
	if (_Beam.length()<1)
	{
		if (bIsBeam)
		{
			bm =(Beam)entSolid;
		}			
		else if (entSolid.realBody().volume() > pow(U(1),3))
		{
			if (bDebug)reportMessage("\n" + T("|No pre-conversion beam found, recreate beam|"));
			if (vx.bIsZeroLength() || vy.bIsZeroLength() || vz.bIsZeroLength())
			{
				bm.dbCreate(entSolid.realBody(),true,bBoundingBody);
				
				Vector3d vx,vy,vz;
				vx = bm.vecX();
				vy = bm.vecY();
				vz = bm.vecZ();
			
			// make sure height is the smallest value, swap Y and Z
				if (bm.dW()<bm.dH())
				{				
					bm.dbErase();
					bm.dbCreate(entSolid.realBody(),vx, vz,-vy, true,bBoundingBody);
					if (!bm.bIsValid())
					{ 
						reportMessage("\n" + scriptName() + ": " +T("|could not convert solid| ") + entSolid.typeDxfName() + T(" |due to its complexity|"));
						eraseInstance();
						return;
					}
				}	
			}
			else
				bm.dbCreate(entSolid.realBody(), vx,vy,vz, true, bBoundingBody);	
			if (bm.bIsValid())				
				_Beam.append(bm);
			else
			{
				reportMessage("\n***" + T("|Base conversion failed, solid cannot be converted.|")+"***");
				eraseInstance();
				return;					
			}
			setExecutionLoops(2);
		}
		else
		{	
			reportMessage("\n***" + T("|Conversion not possible.|")+"***");
			eraseInstance();
			return;			
		}		
	}
	else
	{
		bm = _Beam[0];
	// toggle visibility
		if (!bIsBeam)
		{ 
			if (bDebug)bm.setIsVisible(true);
			else bm.setIsVisible(false);
		}
		
	}

// the quader and beam body	
	Quader qdr = bm.quader();//qdr.vis(2);
	Body bdBm = bm.realBody();

// Display Grain 
	Display dp(96);
	dp.textHeight(U(20));
	//dp.draw(scriptName(), _Pt0, _XW,_YW,1,0,_kDeviceX);
	
// Standards
	if (vx.bIsZeroLength() || vy.bIsZeroLength() || vz.bIsZeroLength())
	{
		vx = bm.vecX();
		vy = bm.vecY();
		vz = bm.vecZ();
	}
// make sure height is the smallest value, swap Y and Z
	if (bIsBeam && bm.dW()<bm.dH())
	{ 
		vy = bm.vecZ();
		vz = vx.crossProduct(vy);
	}		
	double dX = bdBm.lengthInDirection(vx);
	double dY = bdBm.lengthInDirection(vy);
	double dZ = bdBm.lengthInDirection(vz);	







// redeclare style property if a collection of styles has been found in metadata
	if (mapConversion.hasMap("STYLE[]"))
	{ 
		Map m = mapConversion.getMap("STYLE[]");
		String _sStyles[0];
		if(m.length()>0)
			_sStyles.append(T("|Auto|"));

		
		for (int i=0;i<m.length();i++) 
		{ 
			_sStyles.append(m.getString(i)); 	 
		}
		if (_sStyles.length()>1)
		{ 
			sStyle = PropString(0, _sStyles, sStyleName);
			sStyles = _sStyles;

		// reread thicknesses
			dThicknesses.setLength(0);
			for(int i=1;i<sStyles.length();i++)
			{
				SipStyle style (sStyles[i]);
				dThicknesses.append(style.dThickness());
			}
		}
		
	//	mapConversion.hasString("STYLE")
	}


// set style if defined by meta data conversion	
	if (mapConversion.hasString("STYLE") && _bOnDbCreated)
	{
		String sStyleName = mapConversion.getString("STYLE");
		int n= sStyles.find(sStyleName);	
		if (n>-1)
			sStyle.set(sStyles[n]);	
//		mapConversion.removeAt("STYLE", true);	
//		entSolid.setSubMapX("ConversionMetaData",mapConversion);
	}

// ints
	int nStyle = sStyles.find(sStyle);







// build sip coordSys, default is beam coordSys
	Vector3d vxSip=vx, vySip=vy, vzSip=vz;
// validate if derived from a curved style
	int bFromCurvedStyle;
	CurvedStyle curvedStyle(bm.curvedStyle());
	if (curvedStyle.entryName()!=_kStraight)bFromCurvedStyle=true;
	if (bFromCurvedStyle)
	{
		vxSip = vx;
		vySip = vz;		
		vzSip = -vy;	
	}

// change grain direction upon request
	Vector3d vecWoodGrainDirection = vxSip;	
	if (_Map.hasVector3d("WoodGrainDirection"))
	{
		vecWoodGrainDirection=_Map.getVector3d("WoodGrainDirection");
		vxSip = 	vecWoodGrainDirection;
		vySip =	vxSip.crossProduct(-vzSip);
	}

// trigger rotate 90°
	String sTrigger90 = T("|Rotate 90°|");
	addRecalcTrigger(_kContext,sTrigger90 );			
	if (_bOnRecalc &&  _kExecuteKey==sTrigger90) 
	{	
		CoordSys csRot;
		csRot.setToRotation(90, vzSip,_Pt0);
		vecWoodGrainDirection.transformBy(csRot);
		vxSip.transformBy(csRot);
		vySip.transformBy(csRot);
		_Map.setVector3d("WoodGrainDirection",vecWoodGrainDirection);
		if (_Sip.length()>0)
		{
			_Sip[0].dbErase();
			_Sip.setLength(0);
		}
		setExecutionLoops(2);
	}


// make sure the X-Axis is always aligned with positive WCS	
	if ((vxSip.isParallelTo(_XW) && !vxSip.isCodirectionalTo(_XW)) ||
		(vxSip.isParallelTo(_YW) && !vxSip.isCodirectionalTo(_YW)) ||
		(vxSip.isParallelTo(_ZW) && !vxSip.isCodirectionalTo(_ZW)) ||
		(!vzSip.isParallelTo(_ZW) && !vzSip.isPerpendicularTo(_ZW) && vxSip.dotProduct(_ZW)<0))
	{
		vxSip*=-1;
		vySip*=-1;	
	}
	

	
		
// swap ref on double click
// declare flag to erase panel
	int bClear;
// trigger flip ref side
	int bFlipRef =_Map.getInt("flipRef");
	String sTriggerFlipRef = T("|Flip Reference Side|");
	addRecalcTrigger(_kContext,sTriggerFlipRef );			
	if (_bOnRecalc && (_kExecuteKey==sDoubleClick ||  _kExecuteKey==sTriggerFlipRef )) 
	{	
		if (bFlipRef ==1)
			bFlipRef =0;
		else	
			bFlipRef =1;			
		_Map.setInt("flipRef",bFlipRef );
		bClear=true;
		setExecutionLoops(2);
	}		
// flip Z			
	if (bFlipRef)vzSip*=-1;
	vySip = vxSip.crossProduct(-vzSip);
// style changed
	if (_kNameLastChangedProp==sStyleName)
	{
		bClear=true;
	}
// trigger change Y<->Z
	if(_bOnDbCreated && bIsBeam && dZ>dY)
		_Map.setInt("switchYZ", true);
	int bSwitchYZ =_Map.getInt("switchYZ");

	String sTriggerSwitchYZ = T("|Switch Y-Z Axis|");
	addRecalcTrigger(_kContext,sTriggerSwitchYZ );			
	if (_bOnRecalc &&   _kExecuteKey==sTriggerSwitchYZ ) 
	{	
		if (bSwitchYZ ==1)
			bSwitchYZ =0;
		else	
			bSwitchYZ =1;			
		_Map.setInt("switchYZ",bSwitchYZ );
		bClear=true;
		setExecutionLoops(2);
		nStyle=0;
		sStyle.set(sStyles[nStyle]); // set to Auto
	}	
	
// switch Y and Z Axis
	if (bSwitchYZ)
	{
		Vector3d vecZTemp = -vzSip;
		vzSip = vySip;
		vySip = vecZTemp;
		
		double d = dZ;
		dZ = dY;
		dY = d;	
	}	
// erase panel
	if (bClear && _Sip.length()>0)
	{
		_Sip[0].dbErase();
		_Map.setInt("ToolsAdded",0);
		_Map.setInt("StaticCutsAdded", false);
		_Sip.setLength(0);		
	}
	if (_Sip.length()<1)
	{
		_Map.setInt("ToolsAdded",0);
		_Map.setInt("StaticCutsAdded", false);
	}		
// debug display vecs
	//vxSip.vis(_Pt0,1);	vySip.vis(_Pt0,3);	vzSip.vis(_Pt0,150);			
	Line lnZ(_Pt0,vzSip);
// box dimensions
	double dXSip = qdr.dD(vxSip);
	double dYSip = qdr.dD(vySip);
	double dZSip = qdr.dD(vzSip);		
// stop attempt of very small chunks
	int bKillMe;
	if (dY<U(25) && dZ<U(25))
	{
		if (bDebug)reportMessage(T("|Small solid conversion attempt will be removed.|"));
		bKillMe=true;	
	}	
// validate thickness if it cannot be found, erase instance
	int bThicknessFound;
	for (int i=0;i<dThicknesses.length();i++)
	{
		if (abs(dThicknesses[i]-dZSip)<=dEps)
		{
			bThicknessFound=true;
			break;
		}
	}
	

	if (!bThicknessFound && !bKillMe)
	{
		reportMessage("\n*******************" + scriptName() + " *******************\n" + 
				T("|No matching style found|")+ " " + T("|Thickness|") + " = " +dZSip + "\n" +
				T("|Tool will be deleted.|"));
		bKillMe=true;
		//return;
	}
	
// erase this instance and all other dependent entities	
	if(bKillMe)		
	{	
		setExecutionLoops(0);
		if (1)
		{
			dp.draw("err",_Pt0,_XW,_YW,0,0);	
		}
		else
		{
			if (!bIsBeam)bm.dbErase();
			if (_Sip.length()>0)_Sip[0].dbErase();
			eraseInstance();
		}		
		return;
	}
// conversion log messages
	String sLogMsgs[0];	
	
// find matching style(s)
	int nQtyAmbiguos;
	String sStyleSelected;
	if (nStyle==0)
	{
		int nMyStyle=-1;
		for (int i=0;i<dThicknesses.length();i++)
		{
			if (abs(dThicknesses[i]-dZSip)<=dEps)
			{
				nMyStyle=i;
				nQtyAmbiguos++;
			}	
		}
		if (nQtyAmbiguos>1)
		{
			dp.color(10); // highlight if ambiguous
			sLogMsgs.append(nQtyAmbiguos + " " + T("|ambiguous styles detected|"));
			sLogMsgs.append(T("|Thickness|") + " = " +dZSip);// #1
			if (_bOnDbCreated)// _kExecutionLoopCount==0 && 
				setExecutionLoops(2);
			else
				sStyleSelected=sStyles[nQtyAmbiguos];	
		}
		else if (nMyStyle>-1 && nQtyAmbiguos>0)
		{
			sStyle.set(sStyles[nMyStyle]);		
			nStyle = nMyStyle;
			sStyleSelected=sStyle;
		}
	// no matching style found after switching y and Z	
		else if (nMyStyle<0 && nQtyAmbiguos==0 && bSwitchYZ)
		{
			bSwitchYZ=false;
			_Map.setInt("switchYZ",bSwitchYZ );
			setExecutionLoops(2);
		}
		
	// add err msg if no matching style has been found
		if (nMyStyle<0)
		{
			dp.color(10); // highlight if ambiguous
			sLogMsgs.append(T("|No matching style found|"));
			sLogMsgs.append(T("|Thickness|") + " = " +dZSip);		
		// add delete trigger
			String sTriggerDelete = T("|Delete conversion attempt|");
			addRecalcTrigger(_kContext,sTriggerDelete );			
			if (_bOnRecalc &&  _kExecuteKey==sTriggerDelete) 
			{	
				if (!bIsBeam)bm.dbErase();
				if (_Sip.length()>0)_Sip[0].dbErase();
				eraseInstance();
				return;
			}
		}		
	}
	else
		sStyleSelected=sStyle;	


	

// ref side
	Point3d ptCen = bm.ptCenSolid();
	Point3d ptRef = ptCen-vzSip*.5*dZSip;
	Plane pnZ(ptCen,vzSip);
	CoordSys cs(ptRef, vxSip, vySip, vzSip);
	
	//ptRef.vis(1);
	Plane pnFaceRef(ptRef,-vzSip);	pnFaceRef.vis(55);
	Plane pnFaceOpp(ptCen+vzSip*.5*dZSip,vzSip);	

// get tools from dummy beam
	AnalysedTool tools[] = bm.analysedTools();
	// beamcuts
	AnalysedBeamCut abcs[] = AnalysedBeamCut().filterToolsOfToolType(tools);
	// cuts
	AnalysedCut cuts[] = AnalysedCut().filterToolsOfToolType(tools);
	// if there is any cut not perp to the x and y Axis we need to add pseudo analysed cuts at the -y and y side of the genBeam

	AnalysedFreeProfile fps[] = AnalysedFreeProfile().filterToolsOfToolType(tools);


	int bAddPseudoCuts;
	
// rebuild a cutted envelope body as the bdEnvelope(false, true) gives sometimes odd results
	Body bdEnvelope;
	
// stretch the body slightly if it has a cut aligned with the main x-direction
// test in positive X
	{
		int bPosX, bNegX;

		for (int c=0; c<cuts.length();c++)	
		{
			AnalysedCut cut = cuts[c];
			Point3d ptOrg = cut.ptOrg();
			Vector3d vecZCut = cut.normal();
			if (vecZCut.isPerpendicularTo(vx) && vecZCut.isPerpendicularTo(vy))continue;
			
			double d = cuts[c].normal().dotProduct(bm.vecX());
			if (d>0)	bPosX = true;
			else		bNegX = true;
		}
	
		if (bPosX||bNegX)
		{ 
			Point3d pt = bm.ptCenSolid();
			double dL = bdBm.lengthInDirection(vx);double dLL = U(100);
			if (bPosX){pt+= vx * dLL;dL+=dLL;}
			if (bNegX){pt-= vx * dLL;dL+=dLL;}
			bdEnvelope = Body(pt, vx, vy, vz, dL, bdBm.lengthInDirection(vy), bdBm.lengthInDirection(vz), 0, 0, 0);		// 5.2 	bm.ptCenSolid() -> pt
		}
		else 
			bdEnvelope= bm.envelopeBody();
	}


	for (int c=0; c<cuts.length();c++)
	{
		AnalysedCut cut = cuts[c];
		Point3d ptOrg = cut.ptOrg();
		Vector3d vecZCut = cut.normal();
		//vecZCut.vis(ptOrg, c);
		bdEnvelope.addTool(Cut(ptOrg, vecZCut), 0);
		if (!vecZCut.isPerpendicularTo(vx) && !vecZCut.isPerpendicularTo(vy))
			bAddPseudoCuts=true;
	}
	if (bAddPseudoCuts)
	{
		int nDir = 1;
		for (int i=0;i<2;i++)
		{
			Map mapAnalysedCut, mapTool, mapCut;
			Vector3d vecNormal = nDir*vy;
			Point3d ptOrg = ptCen+vecNormal*.5*bdBm.lengthInDirection(vy);	
			mapTool.setInt("MAV",1);
			mapTool.setEntity("GENBEAM",bm);
			mapAnalysedCut.setInt("MAV",1);
			mapAnalysedCut.setMap("ANALYSEDTOOL", mapTool);
			mapAnalysedCut.setPoint3d("PTORG",ptOrg);
			mapAnalysedCut.setVector3d("NORMAL",vecNormal );
			mapAnalysedCut.setInt("MUSTCUT",0);
			mapAnalysedCut.setInt("TOUCHESBODY",1);

			mapAnalysedCut.setMapKey("ANALYSEDCUT");// teams remark KR 2.2.2021
			
			AnalysedCut cutNew(mapAnalysedCut);
			if (cutNew.bIsValid())
				cuts.append(cutNew);
			else if (bDebug)
			{
				//mapCut.writeToDxxFile("c:\\temp\\analysedCutTest" + i + ".dxx");
				reportMessage("\npseudo cut " + i + " not valid");
			}
			nDir*=-1;
		}
	}

// declare beamcuts which will be appended as tools to the sip
	BeamCut bcs[0];

// refine envelope by doublecuts
	AnalysedDoubleCut dcuts[]= AnalysedDoubleCut().filterToolsOfToolType(tools);
	for (int i=0;i<dcuts.length();i++) 
	{ 
		AnalysedDoubleCut& adc = dcuts[i]; 
		Vector3d vecDC1 = adc.vecN1();
		Vector3d vecDC2 = adc.vecN2();


	// test if this double cut is nearly 90°
	// doublecuts could appear which are in fact rabbets, but added as doublecut due to inaccuracy
	// case 001
	// file:\\hsbData\OneDrive - hsbcad\TslPics\Solid2Panel Cases.jpg	
		double dAngle = vecDC1.angleTo(vecDC2);
		if(abs(dAngle-90)<.01)
		{ 
		// create a replacing beamcut
			Vector3d vecXBC, vecYBC, vecZBC;
			vecXBC = vecDC1.crossProduct(vecDC2);
			
			if (vecDC1.isParallelTo(vzSip)||vecDC1.isPerpendicularTo(vzSip))
			{	
				vecYBC = vecDC1;
				vecZBC = vecXBC.crossProduct(vecYBC);
			}
			else
			{
				vecZBC = vecDC2;
				vecYBC = vecXBC.crossProduct(-vecZBC);
			}
			BeamCut bc(adc.ptOrg(), vecXBC, vecYBC, vecZBC, bdEnvelope.lengthInDirection(vecXBC) * 2, bdEnvelope.lengthInDirection(vecYBC) * 2, bdEnvelope.lengthInDirection(vecZBC) * 2, 0, 1, 1);
			//bc.cuttingBody().vis(2);	vecXBC.vis(adc.ptOrg(), 1); vecYBC.vis(adc.ptOrg(), 3);			vecZBC.vis(adc.ptOrg(), 150);	
			bcs.append(bc);
			continue;
		}

		if (adc.vecN1().isParallelTo(vzSip) || adc.vecN2().isParallelTo(vzSip))continue;
		vecDC1.vis(adc.ptOrg(), 1);
		vecDC2.vis(adc.ptOrg(), 2);
		vzSip.vis(adc.ptOrg(), 150);
		//bdSolid.vis(4);
		DoubleCut dc(adc.ptOrg(), adc.vecN1(), adc.ptOrg(), adc.vecN2());
		bdEnvelope.addTool(dc);
	}
	
	
// add freeprofiles	HSB-6753
	PLine plFreeProfiles[0];
	for (int i=0;i<fps.length();i++) 
	{ 
		AnalysedFreeProfile& afp = fps[i]; 
		
		PLine pl = afp.plDefining();
		
		double depth = afp.dDepth();
		double millDiameter = afp.millDiameter();
		int nCncMode = afp.nCncMode();
		int nMillSide = afp.nMillSide();
		int machinePathOnly = afp.machinePathOnly();
		int solidPathOnly = afp.solidPathOnly();
		Vector3d vecSide = afp.vecSide();
		Point3d pts[0];
		{ 
			Point3d pt = pl.ptEnd();
			Vector3d vecTang = pl.getTangentAtPoint(pt).crossProduct(-vecSide);
			vecTang.vis(pt, 3);
			pt += vecTang * (bm.solidWidth() + bm.solidLength());
			pts.append(pt);
		}			
		{ 
			Point3d pt = pl.ptStart();
			Vector3d vecTang = pl.getTangentAtPoint(pt).crossProduct(-vecSide);
			vecTang.vis(pt, 1);
			pt += vecTang * (bm.solidWidth() + bm.solidLength());
			pts.append(pt);		
		}

		Point3d pt = afp.ptOrg();
		vecSide.vis(pt, 2);
//			PLine[] plCuts() const; // array of PLine that express the actual cut paths that cut the beam
		FreeProfile fp(pl, pts);
		fp.setMachinePathOnly(false);
//			fp.setSolidPathOnly(solidPathOnly);
		if (depth > 0)fp.setDepth(depth);
		bdEnvelope.addTool(fp);
		pl.projectPointsToPlane(pnFaceRef, vecSide);
		pl.vis(2);
		
		plFreeProfiles.append(pl);
	}
	
	
	
	
	


// get solid shadow

	PlaneProfile ppShadow = bdSolid.shadowProfile(pnZ);
	//bdSolid.vis(4);//
	//ppShadow.vis(4);	

	
// test for 'open' tilted beamcuts which are not completly free
	// case 002
	// file:\\hsbData\OneDrive - hsbcad\TslPics\Solid2Panel Cases.jpg
	/// https://hsbcadbvba-my.sharepoint.com/:i:/g/personal/thorsten_huck_hsbcad_com/ERpk6enyH8BEoI4iU9lNzn0BxBY_XIcLylCRZbSLzoluyw?e=raZun2
	/// C:\hsbData\OneDrive - hsbcad\TslPics\Solid2Panel Case002.png
	for (int i=abcs.length()-1; i>=0 ; i--) 
	{ 
		String toolSubType = abcs[i].toolSubType();
		Quader q = abcs[i].quader();		
	// show type
		if (0 && bDebug)
		{
			q.vis(i);
			Display dp(i);
			dp.textHeight(U(30));
			dp.draw(abcs[i].toolSubType(), q.pointAt(0, 0, 0), vxSip, vySip, 0, 0, _kDeviceX);
		}				

	// version 5.7 kABCJapaneseHipCut added to tilted tests
	// version 5.8 _kABCLapJoint added to tilted tests
		if (abcs[i].toolSubType()!=_kABCHouseTilted && abcs[i].toolSubType()!=_kABCJapaneseHipCut)// && abcs[i].toolSubType()!=_kABCLapJoint) 
		{
			continue; 
		}
		
	// collect relevant planes 	
		Vector3d vecs[] = {q.vecD(vxSip),q.vecD(vySip),q.vecD(-vxSip), q.vecD(-vySip)};

//	// find out if one direction is free
//		int bHasFreeDir;
//		for (int j=0;j<vecs.length();j++) 
//			if (abcs[i].bIsFreeD(vecs[j]))bHasFreeDir = true;
//		if (bHasFreeDir) continue;
		

	// if no direction is free test if projected ptCen is outside of profile
		Point3d ptCen;
		if (!Line(q.pointAt(0, 0, 0), q.vecD(vzSip)).hasIntersection(pnZ, ptCen))
		{
			continue;
		}
		
	// if the point is outside the profile it means that the beamcut is not free, but somewhere on the edge	of the panel
		if (ppShadow.pointInProfile(ptCen)==_kPointOutsideProfile)
		{
			// HSB-8376
			Point3d pt = q.pointAt(0, 0, 0);
			Vector3d vecX = q.vecD(vxSip);
			Vector3d vecZ = q.vecD(vzSip);
			Vector3d vecY = vecZ.crossProduct(vecX);
			if (vecY.bIsZeroLength()) // if quader is 45° it could take the invalid direction // https://hsbcad.myjetbrains.com/youtrack/issue/HSB-14486
			{ 
				vecX = q.vecD(vySip);
				vecY = vecZ.crossProduct(vecX);
			}		
//			vecX.vis(pt, 1);
//			vecY.vis(pt, 3);
//			vecZ.vis(pt, 150);

			BeamCut bc(pt, vecX, vecY, vecZ, q.dD(vecX),q.dD(vecY),q.dD(vecZ), 0, 0, 0);
//			bc.cuttingBody().vis(2);
			bdEnvelope.addTool(bc);  // https://hsbcad.myjetbrains.com/youtrack/issue/HSB-14486
			bcs.append(bc);
			abcs.removeAt(i);
		}

	}


// refine envelope by beamcuts
	for (int i=0;i<abcs.length();i++) 
	{ 
		AnalysedBeamCut& abc = abcs[i]; 
		String toolSubType = abc.toolSubType();
		Quader q = abc.quader(U(10));//HSB-5458
		//q.vis(1);

		Vector3d vecZQ = q.vecD(vzSip);
		//vecZQ.vis(q.pointAt(0, 0, 0), 1);
		int bDo = !vecZQ.isParallelTo(vzSip);
		if (toolSubType == _kABCHousingThroughout)bDo = true;

	// HSBCAD-632 test if this beamcut would contribute to the contour envelope
		if (!bDo)
		{ 
		// find out if at least one direction is free
			Vector3d vecs[] = {q.vecD(vxSip),q.vecD(vySip),q.vecD(-vxSip), q.vecD(-vySip)};
			for (int j=0;j<vecs.length();j++) 
				if (abcs[i].bIsFreeD(vecs[j]))
				{
					bDo = true;
					break;
				}			
		}

		
		
		
		if (bDo && toolSubType!=_kABCLapJoint && !(abc.bIsFreeD(vecZQ) && abc.bIsFreeD(-vecZQ)))
			bDo = false;
//
		if (bDo)// && abc.bIsFreeD(vecZQ) && abc.bIsFreeD(-vecZQ)) 
		{
			//q.vis(i);			vzSip.vis(q.ptOrg(), 150);	
			CoordSys c = q.coordSys();
			double dX = q.dD(vxSip);
			double dY = q.dD(vySip);
			double dZ = q.dD(vzSip);
			Point3d pt = c.ptOrg();
		
//		// extent in pos and neg X if free
//			if (abc.bIsFreeD(q.vecD(vxSip)))
//			{ 
//				pt += q.vecD(vxSip) *.5* dX;
//				dX *= 2;
//			}
//			if (abc.bIsFreeD(q.vecD(-vxSip)))
//			{ 
//				pt -= q.vecD(vxSip) * .5*q.dD(c.vecX());
//				dX += q.dD(c.vecX());
//			}			
			BeamCut bc(pt, q.vecD(vxSip), q.vecD(vySip), q.vecD(vzSip),dX, dY,dZ, 0, 0, 0);
			//bc.cuttingBody().vis(4);
			bdEnvelope.addTool(bc);
		}
	}
	//bdEnvelope.vis(2);
	
//region Search abcs which could be expressed by a doublecut, contribute to stretch planes // HSB-11073	
	Plane pnHexStretchEdges[0];
	for (int i=abcs.length()-1; i>=0 ; i--) 
	{ 
		AnalysedBeamCut abc = abcs[i];
		String toolSubType = abc.toolSubType();
		Quader qdrA = abc.quader();		//qdrA.vis(2);
		
		CoordSys cs = abc.coordSys();
		Vector3d vecX=cs.vecX(), vecY=cs.vecY(), vecZ=cs.vecZ();
		Vector3d vecs[]={ vecX,vecY, vecZ, -vecX,  -vecY, -vecZ};
		int numFree;
		for (int v=0;v<vecs.length();v++)
			if (abc.bIsFreeD(vecs[v]))
				numFree++;
		
		int bFound;
		if ((toolSubType ==_kABCRisingSeatCut) && numFree>3)
		{
			double dXA = qdrA.dD(vecX)*(abc.bIsFreeD(vecX) && abc.bIsFreeD(-vecX)?2:1);
			double dYA = qdrA.dD(vecY)*(abc.bIsFreeD(vecY) && abc.bIsFreeD(-vecY)?2:1);
			double dZA = qdrA.dD(vecZ)*(abc.bIsFreeD(vecZ) && abc.bIsFreeD(-vecZ)?2:1);		
					
			Body bdA(qdrA.ptOrg(), vecX, vecY, vecZ, dXA, dYA, dZA,0,0,0);	//bdA.vis(1);	// enlarge solid cutting body to avoid modeler issues
			for (int ii=abcs.length()-1; ii>=0 ; ii--) 		
			{
//				if (i == ii){continue;}
//				
				AnalysedBeamCut abcB = abcs[ii];
				String toolSubTypeB = abcB.toolSubType();
				Quader qdrB = abcB.quader();
				
				CoordSys csB = abcB.coordSys();
				Vector3d vecXB=csB.vecX(), vecYB=csB.vecY(), vecZB=csB.vecZ();
				Vector3d vecsB[] ={ vecXB, vecYB, vecZB};
				if (i!=ii && toolSubTypeB ==_kABCValleyBirdsmouth || toolSubTypeB ==_kABCJapaneseHipCut)
				{	
					double dXB = qdrB.dD(vecXB)*(abcB.bIsFreeD(vecXB) && abcB.bIsFreeD(-vecXB)?2:1);
					double dYB = qdrB.dD(vecYB)*(abcB.bIsFreeD(vecYB) && abcB.bIsFreeD(-vecYB)?2:1);
					double dZB = qdrB.dD(vecZB)*(abcB.bIsFreeD(vecZB) && abcB.bIsFreeD(-vecZB)?2:1);
					Body bdB(qdrB.ptOrg(), vecXB, vecYB, vecZB, dXB, dYB, dZB, 0, 0, 0);	//bdB.vis(2);// enlarge solid cutting body to avoid modeler issues
					Body bdTest = bdB;
					if (!bdTest.hasIntersection(bdA))continue; // bodies must intersect
					
					Vector3d vecStretchA = qdrA.vecD(-vzSip);
					if (abc.bIsFreeD(qdrA.vecD(vzSip)))
						vecStretchA = qdrA.vecD(vzSip);
					
					Line lnA = Plane(qdrA.pointAt(0, 0, 0) - vecStretchA * .5 * qdrA.dD(vecStretchA), vecStretchA).intersect(Plane(ptRef, vzSip));
					Plane pnStretchA(lnA.closestPointTo(qdrA.pointAt(0, 0, 0)), vecStretchA);			
					lnA.vis(2);	vecStretchA.vis(qdrA.ptOrg(), 5);		
					pnHexStretchEdges.append(pnStretchA);
					
					
					Vector3d vecStretchB = qdrB.vecD(-vzSip);
					if (abcB.bIsFreeD(qdrB.vecD(vzSip)))
						vecStretchB = qdrB.vecD(vzSip);					
					
					Line lnB= Plane(qdrB.pointAt(0, 0, 0) - vecStretchB * .5 * qdrB.dD(vecStretchB), vecStretchB).intersect(Plane(ptRef, vzSip));
					Plane pnStretchB(lnB.closestPointTo(qdrB.pointAt(0, 0, 0)), vecStretchB);			
					lnB.vis(2);	vecStretchB.vis(qdrB.ptOrg(), 5);					
					pnHexStretchEdges.append(pnStretchB);

					bdEnvelope.addTool(SolidSubtract(bdA));	
					bdEnvelope.addTool(SolidSubtract(bdB));
					//	

					if (i>ii)
					{
						abcs.removeAt(i);
						abcs.removeAt(ii);
					}
					else
					{ 
						abcs.removeAt(ii);
						abcs.removeAt(i);
					}
					bFound = true;
					break; // ii
				}
			}// next ii

		}// END IF if ((toolSubType ==_kABCRisingSeatCut) && numFree>3)
		if (bFound)
		{
			break;//i
		}		
	}// next i
	//bdEnvelope.vis(3);
//endregion
	

// get shadow,contact faces and shadow body
	PlaneProfile ppFaceRef(cs);
	ppFaceRef.unionWith(bdEnvelope.extractContactFaceInPlane(pnFaceRef, dEps));// version 4.9 bdSolid replaced
	PlaneProfile ppFaceOpp=bdEnvelope.extractContactFaceInPlane(pnFaceOpp, dEps);//ppFaceOpp .vis(7);

	//bdEnvelope.vis(3);
	PLine plRings[0];
	int bIsOp[0];
		
// keep the contact face of the solid to test _kABCHouseRotated contacts to the envelope (case 15)	
	PlaneProfile ppFaceRefSolid(cs);
	{
		PLine rings[]= ppFaceRef.allRings(true, false);
		for (int r=0;r<rings.length();r++) 
			ppFaceRefSolid.joinRing(rings[r],_kAdd); 

	}
	//ppFaceRefSolid.vis(6);

	 
	ppShadow.unionWith(ppFaceRef);
	ppShadow.unionWith(ppFaceOpp);
	ppShadow.shrink(-dEps);
	ppShadow.shrink(2*dEps);
	ppShadow.shrink(-dEps);
	//
	
	//ppShadow .vis(40);

	plRings = ppShadow.allRings();
	bIsOp = ppShadow.ringIsOpening();
	
	// build shadow by adding rings
	Body bdShadow;
	for (int r=0;r<plRings.length();r++)
	{
		if (!bIsOp[r] && plRings[r].area()>pow(dEps,2))// 1.3
		{
			bdShadow.addPart(Body(plRings[r],vzSip*dZSip,0));
			//plRings[r].vis(3);
		}
		else
			;//plRings[r].vis(1);
	}
	//TODO verify new approach
	// Body bdEnvelope = bdShadow;
	Body bdCuts = bdShadow;
	
//region Drills
	AnalysedDrill drills[0];
	if (bConvertDrills)
		drills = AnalysedDrill().filterToolsOfToolType(tools);	
	
// add openings by subtracting rings
	PLine plOpenings[0], plOpeningsBeamcutRemoval[0];
	Drill drillsByOpening[0];
	for (int r=0;r<plRings.length();r++)
		if (bIsOp[r])
		{
			PLine pl = plRings[r];//pl.vis(3);
			
		// test if this ring looks like a circle  sample dwg Case#4
			// get diameter
			PlaneProfile pp(pl);
			LineSeg seg = pp.extentInDir(vx);
			double dDiameter = abs(vx.dotProduct(seg.ptStart()-seg.ptEnd()));
			PLine plCircle(vzSip);
			plCircle.createCircle(seg.ptMid(), vzSip,dDiameter/2);
			//plCircle.vis(20);
			double dAreaOpening = pl.area();
			double dEps2 = pow(dEps,2);
			if (dAreaOpening<pow(dEps,2))continue;
			double dAreaCircle = plCircle.area();
			double dPerc2 = (dAreaCircle/dAreaOpening);
			double dPerc = (dAreaCircle/dAreaOpening*100)-100;

		
		// if the relative difference is smaller 2% we assume it is a circle, small crcles allow 5%
			double dVal = 2;
			if (dDiameter>U(1000))dVal=.5;
			else if (dDiameter<U(20))dVal=5;
		// version  value="1.9" date=08apr14" author="th@hsbCAD.de"> drill detection more tolerant
			int bIsCircle;
			if (dPerc<dVal && dAreaCircle >dAreaOpening)
			{
				//reportMessage("\ndiameter " + dDiameter);
				pl=plCircle;
				bIsCircle=true;		
			}	
			
			//pl.projectPointsToPlane(pnFaceRef,vzSip);
			//pl.vis(2);	
			
		// test if this ring is throughout or like a simple housing
			Body bdSub(pl,vzSip*dZSip*2,0);
			//bdSub.vis(6);
			
		// report diameter and threshold value
			if (bDebug && bIsCircle)
				reportMessage("\nThresVal = " +dThresholdDrill + " vs diam " + dDiameter);
			
		// circular cut out detected but below threshold value -> convert as drill
			if (bIsCircle && dThresholdDrill>0 && dDiameter<=dThresholdDrill)
			{
				plOpeningsBeamcutRemoval.append(pl);			
				Point3d ptDrill = seg.ptMid();
			
			// do not add if there is an analysed drill which are at same location with same properties
				int bOk=true;
				for (int d=0;d<drills.length();d++)
				{
					AnalysedDrill drill = drills[d];
					Point3d ptStart = drill.ptStartExtreme();
					ptStart.transformBy(vzSip*vzSip.dotProduct(ptDrill-ptStart));
					//ptStart.vis(2);
					if (drill.bThrough() && abs(drill.dDiameter()-dDiameter)<dEps && drill.vecZ().isParallelTo(vzSip) && Vector3d(ptStart-ptDrill).length()<dEps)
					{
						bOk=false;
						break;
					}		
				}							
				if (bOk)
				{
					ptDrill.transformBy(vzSip*vzSip.dotProduct(ptRef-ptDrill));
					//ptDrill.vis(3);
					drillsByOpening.append(Drill(ptDrill, ptDrill+vzSip*dZSip, dDiameter/2));
				}
			}
		// any other perform as opening
			else	
			{		
				bdShadow.subPart(bdSub);	
				plOpenings.append(pl);
			}
		}
//End Drills//endregion 	
	


// trim shadow by any double cut // case 11
	//bdShadow.vis(4);
	for (int i=dcuts.length()-1;i>=0;i--)
	{
		DoubleCut dcut(dcuts[i].ptOrg(), dcuts[i].vecN1(),dcuts[i].ptOrg(), dcuts[i].vecN2());
		bdShadow.addTool(dcut);	
	}
	//bdShadow.vis(40);
	


	
// declare potential abcs which operate on the edge of the panel to modify verteces
	String sTiltedTypes[] = {_kABCHouseTilted,_kABCOpenDiagonalSeatCut,_kABCRisingBirdsmouth,_kABC5AxisBirdsmouth, _kABC5Axis,_kABCLapJoint};//,_kABC5AxisBirdsmouth}; // case 2,3,4,5
	
	
// remove any beamcut which is:
// - throughOut and inside an opening 
// - smaller than 60x6x6
// Sample dwg Case #4
	if (bDebug)reportMessage("\nTest HousingThroughout");
	PLine plThroughOutRemovals[0];
	plThroughOutRemovals.append(plOpenings);
	plThroughOutRemovals.append(plOpeningsBeamcutRemoval);
	for (int i=abcs.length()-1;i>=0;i--)//
	{
		AnalysedBeamCut abc = abcs[i];					
		String toolSubType = abc.toolSubType();
	// remove small beamcuts which might be part of the conversion solid for grain detection (pocket mode), since version 3.6
		if (toolSubType ==_kABCSimpleHousing || toolSubType ==_kABCHousing)
		{
			Quader qdr = abc.quader();
			//qdr.vis(2);
			LineSeg seg(qdr.pointAt(1,1,1),qdr.pointAt(-1,-1,-1));
			CoordSys cs = abc.coordSys();
			Vector3d vecX=cs.vecX(), vecY=cs.vecY(), vecZ=cs.vecZ();
			Vector3d vecXYZ[] = {vecX, vecY,vecZ};
			double dXYZ[0];
			dXYZ.append(abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd())));
			dXYZ.append(abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd())));
			dXYZ.append(abs(vecZ.dotProduct(seg.ptStart()-seg.ptEnd())));
			for (int x=0;x<dXYZ.length();x++)
				for (int y=0;y<dXYZ.length()-1;y++)
					if (dXYZ[y]<dXYZ[y+1])
					{
						dXYZ.swap(y, y+1);
						vecXYZ.swap(y, y+1);	
					}	
							
			if (dXYZ[0]<=dMaxX && dXYZ[1]<=dMaxY && dXYZ[2]<=dMaxZ)
			{
				abcs.removeAt(i);
				continue;
			}
		}

	// remove very small birdsmouth beamcuts (Case 19 and 20). This removal should be obsolete if acisToBeam is fixed (status of hsbCAD 20.0.20.0)
		if (toolSubType == _kABCBirdsmouth || toolSubType == _kABCOpenDiagonalSeatCut || toolSubType ==_kABCRisingBirdsmouth)
		{
			Body bdX =abc.cuttingBody();
			bdX.intersectWith(bdSolid);
			//bdX.transformBy(vz*U(400));bdX.vis(3);

			double dVol = bdX.volume();
			double dMinVol = dEps*dEps*dZSip;
			if (dMinVol<dVol)
			{
				abcs.removeAt(i);
				if (bDebug)reportMessage("\n	very small ABCBirdsmouth removed");	
				continue;
			}			
		}
		else if (toolSubType == _kABCHousingThroughout)
		{	
			Point3d pt = abc.ptOrg();
			//abc.coordSys().vecZ().vis(pt,150);
			for (int r=0;r<plThroughOutRemovals.length();r++)
			{
				PlaneProfile pp(plThroughOutRemovals[r]);
				if (pp.pointInProfile(pt)==_kPointInProfile)
				{
					abcs.removeAt(i);
					if (bDebug)reportMessage("\n	ABCHousingThroughout " + i + " removed from opening " + r);
					break;// break r	
				}
			}// next r opening
		}		
//		else if(_bOnDebug)
//		{
//			Quader qdr = abc.quader();
//			qdr.vis(i);
//		}
	}
	
// declare potential cuts to be added to the panel as well as stretchEdgeTo planes
	Cut cutNormals[0];
	Plane pnNormals[0]; // length must match with cutNormals.
	Plane pnStretchEdges[0];
	
// declare a flag which indicates if an opening needs to be applied as plumb
	int bAddPlumbs[plOpenings.length()];
	int nRef2Abc[plOpenings.length()];
	 	
	AnalysedBeamCut abcEdgeTools[0];
	
// declare a potential subtraction body: this is required if the shadow is bigger than the ref contact face
	if (bDebug)reportMessage("\nTest Shadow > FaceRef");
	if (ppShadow.area() > ppFaceRef.area())
	{
		//Body bdSub = bdShadow;
		//bdSub.subPart(bdSolid);
		//bdSub.vis(2);
	
	// loop analysed beamcuts and add any through beamcut to modify the shadow body
		String sAllowedTypes[] = {_kABCJapaneseHipCut,_kABCHousingThroughout, _kABCRisingSeatCut, _kABCDiagonalSeatCut};// ,_kABCLapJoint};// 
		if (bDebug)reportMessage("\nTest sAllowedTypes: " + sAllowedTypes);
		for (int i=abcs.length()-1;i>=0;i--)//
		{
			AnalysedBeamCut abc = abcs[i];	
			CoordSys cs = abc.coordSys();	
			Point3d pt = cs.ptOrg();
			String sToolSubType = abc.toolSubType();
			Quader qdr = abc.quader();
			
			if (sAllowedTypes.find(sToolSubType)<0)
			{
				//dp.color(1);
				if (bDebug)	dp.draw(sToolSubType,pt,vxSip,vySip,0,0,_kDevice);
				//qdr.vis(i);
				//dp.color(96);
				continue;	
			}
			//qdr.vis(i);
			
		// enlarge to free directions
			Vector3d vxBc = cs.vecX();
			Vector3d vyBc = cs.vecY();
			Vector3d vzBc = cs.vecZ();
			double dDs[] = {qdr.dD(vxBc),qdr.dD(vyBc),qdr.dD(vzBc)};			
			Vector3d vecs[] = {vxBc,vyBc,vzBc};
			for (int j=0;j<vecs.length();j++)
			{
				int nDir=1;
				for (int k=0;k<2;k++)
				{
					if (abc.bIsFreeD(nDir*vecs[j]))
					{	
						pt.transformBy(nDir*vecs[j]*dDs[j]/2);
						dDs[j]*=2;
					}	
					nDir*=-1;
				}				
			}
			
			Body bdSubtract(pt,vxBc,vyBc,vzBc,dDs[0], dDs[1], dDs[2],0,0,0);	
			//bdSubtract.vis(222);
			bdSubtract.subPart(bdSolid);	
			bdShadow.subPart(bdSubtract);
			
		// append to list of edge tools	
			abcEdgeTools.append(abc);
		
			if (bDebug)reportMessage("\n	ABC " +i + " removed from abcs and added to abcEdgeTools");
			abcs.removeAt(i);

			//bdSubtract.vis(i);
		}
		if (bDebug)reportMessage("\n	abcEdgeTools: " +abcEdgeTools);

	// test any opening againgst a HouseRotated (through)
		for (int i=abcs.length()-1;i>=0;i--)
		{
			AnalysedBeamCut abc = abcs[i];	
			CoordSys cs = abc.coordSys();	
			Point3d pt = cs.ptOrg();
			String sToolSubType = abc.toolSubType();		
			if (sToolSubType!=_kABCHouseRotated)continue;
			Quader qdrAbc = abc.quader();
			//qdrAbc.vis(i);			
		
		// test by number of free directions if this beamcut is through
			int nNumIsFree;
			Vector3d vecFree;
			
		// enlarge to free directions
			Vector3d vxBc = cs.vecX();
			Vector3d vyBc = cs.vecY();
			Vector3d vzBc = cs.vecZ();
			double dDs[] = {qdrAbc.dD(vxBc),qdrAbc.dD(vyBc),qdrAbc.dD(vzBc)};			
			Vector3d vecs[] = {vxBc,vyBc,vzBc};
			for (int j=0;j<vecs.length();j++)
			{
				int nDir=1;
				for (int k=0;k<2;k++)
				{
					if (abc.bIsFreeD(nDir*vecs[j]))
					{	
						pt.transformBy(nDir*vecs[j]*dDs[j]/2);
						dDs[j]*=2;
					}	
					if (qdr.vecD(vecs[j]).isParallelTo(vzSip))
					{
						nNumIsFree++;
						vecFree=vecs[j];
					}
					nDir*=-1;
				}				
			}
			
		// continue if not through
			if (nNumIsFree<2)continue;
							
				
		// extract contour in ref face
			Body bdSubtract(pt,vxBc,vyBc,vzBc,dDs[0], dDs[1], dDs[2],0,0,0);
			PlaneProfile ppHR=bdSubtract.getSlice(pnFaceRef);
			PLine plHR;
			plHR.createConvexHull(pnFaceRef,ppHR.getGripVertexPoints());
			//plHR.vis(4);
		
		// test the bounding pline of this beamcut would modify the envelope of the solid contact pp
			PlaneProfile ppTest=ppFaceRefSolid;
			double dAreaBefore =ppTest.area();
			ppTest.joinRing(plHR,_kAdd);
			double dAreaAfter =ppTest.area();
			int bForceBeamcut = !abs(dAreaAfter-dAreaBefore)<pow(dEps,2);
			if (!vecFree.isParallelTo(_ZW))bForceBeamcut=true; // if not parallel with _ZW force beamcut
			
			
		// find opening fully inside
			for (int j=plOpenings.length()-1;j>=0;j--)
			{
				PlaneProfile ppOp(plOpenings[j]);
				
				PlaneProfile pp=ppHR;
				double dAreaBefore =pp.area();
				pp.unionWith(PlaneProfile());
				double dAreaAfter =pp.area();
				if (abs(dAreaAfter-dAreaBefore)<pow(dEps,2))// && vecFree.isParallelTo(_ZW)
				{
					//ppOp.vis(6);
					//vecFree.vis(ppOp.extentInDir(vxSip).ptMid(),1);
					
				// the additive part
					ppOp.shrink(-dEps);
					PLine plAdd;
					plAdd.createConvexHull(pnFaceRef,ppOp.getGripVertexPoints() );
					Body bdAdd(plAdd, vzSip*3*dZSip,0);
					bdAdd.intersectWith(bdEnvelope);
				
				// close the hole of the shadow opening pline	
					bdShadow.addPart(bdAdd);	
					
				// remove opening if beamcut is forced
					if (bForceBeamcut)
					{
						plOpenings.removeAt(j);
						bAddPlumbs.removeAt(j);
						nRef2Abc.removeAt(j);						
					}		
				// reassign opening pline and plumb flag	
					else
					{				
						plOpenings[j] = plHR;
						bAddPlumbs[j]=true;
						nRef2Abc[j] = i;
						//
						bdSubtract.intersectWith(bdEnvelope);	
						//bdSubtract.vis(3);
						bdShadow.subPart(bdSubtract);
					}
					
					//
					break;
				}
			}// next j opening pline		
		}		
	


	
	// the shadow body after applying the abcs	
		if (0&&_bOnDebug)
		{
			Body bd = bdShadow;
			bd.transformBy(_ZW*2*dZSip);
			bd.vis(4);
		}
	
//#cuts
	// loop all cuts
		if (bDebug)reportMessage("\nTest cuts (" +cuts.length()+")");
		for (int i=cuts.length()-1;i>=0;i--)	
		{	
			AnalysedCut cut = cuts[i];
			Vector3d vecNormal = cut.normal();
			double dAngleTo = vecNormal.angleTo(vzSip);
			if (bDebug)reportMessage("\nTdAngleTo " +dAngleTo );
			Plane pnCut(cut.ptOrg(),vecNormal);
			
		// get mid point of segment and collect plane
			Point3d ptsInPlane[]= cut.bodyPointsInPlane();
			Point3d ptMid = cut.ptOrg();
			if (ptsInPlane.length()>0)
				ptMid.setToAverage(ptsInPlane);	
			if(!pnFaceRef.hasIntersection(pnCut)) {continue;}
			Line lnFace = pnFaceRef.intersect(pnCut);	
			ptMid = lnFace.closestPointTo(ptMid);			
			//vecNormal.vis(ptMid,i);
		// catch tolerances of cuts which are almost perpendicular to vecZ of the panel
		// Sample dwg Case 8
			double dPerpTolerance=abs(vecNormal.dotProduct(vzSip));// add a test against slightly beveled cuts	
			if (0 && dPerpTolerance>0 && dPerpTolerance<0.000001)
			{
				if (0 && bDebug)
				{
					Display dpCut(i);
					dpCut.textHeight(U(15));
					dpCut.draw(dPerpTolerance, ptMid, _XW,_YW,1,0,_kDeviceX);			
					reportMessage("\n	Slightly beveled cut (tol=" + dPerpTolerance + ") has been removed [" + i + "]");
					//vecNormal.vis(ptMid,230);
					dpCut.color(i);
					PLine plContact;
					plContact.createConvexHull(pnCut,ptsInPlane);	
					dpCut.draw(PlaneProfile(plContact),_kDrawFilled);			
				}
				cuts.removeAt(i);
				continue;
			}
		// check if this cut is aligned with the ref face
			int bCutOnRefFace = vecNormal.dotProduct(vzSip)<0;	
		
		// show a hull of the cut contact points
			if (bDebug)
			{
				Display dpCut(i);		
				PLine plContact;
				plContact.createConvexHull(pnCut,ptsInPlane);	
				//plContact.vis(i);
				dpCut.color(bCutOnRefFace);
				Hatch hatch("Ansi32",U(10));
				//dpCut.draw(PlaneProfile(plContact),hatch);
			}
			
		// add any cut to the shadow body
			Cut ct(cut.ptOrg(),vecNormal);
			bdShadow.addTool(ct,0);
			bdCuts.addTool(ct,0);
		}// next i cut
		if (bDebug)reportMessage("\n	passed cuts " + cutNormals);
	// the shadow body after applying relevant cuts	
		if (0 && _bOnDebug)
		{
			Body bd = bdCuts;
			bd.transformBy(-vzSip*4*dZSip);
			bd.vis(71);
		}	
		// TODO verify 4.9
		//ppFaceRef = bdShadow.extractContactFaceInPlane(pnFaceRef, dEps);
	
	// debug display of reference face	
		if (0 && bDebug)
		{
			Display dp(4);		
			Hatch hatch("Ansi32",U(10));
			dp.draw(ppFaceRef,hatch);		
		}	
	}
// END IF (ppShadow.area() > ppFaceRef.area())____________________________________________________















	
	if (bDebug)reportMessage("\nTest Shadow > FaceRef ended.");
	//ppShadow .vis(20);		bdShadow.vis(20);
	
	// TODO verify 4.9
//	double dCleanUpRadius = U(1);
//	ppFaceRef.shrink(-dCleanUpRadius );
//	ppFaceRef.shrink(2*dCleanUpRadius );
//	ppFaceRef.shrink(-dCleanUpRadius );
	
	//ppFaceRef .vis(3);
	//ppFaceOpp.vis(3);
// lets get the outline of the sip
	plRings = ppFaceRef.allRings();
	bIsOp= ppFaceRef.ringIsOpening();
	PLine plEnvelope(vzSip);
	for (int r=0;r<plRings.length();r++)
		if (!bIsOp[r] && plEnvelope.area()<plRings[r].area())
			plEnvelope=plRings[r];	
	plEnvelope.vis(6);
	
	
//region Rebuild with arcs
	if (plFreeProfiles.length()>0)
	{ 
		Point3d pts[] = plEnvelope.vertexPoints(false);
		
	//region Make sure arcs walk in same direction
		for (int j=0;j<plFreeProfiles.length();j++) 
		{ 
			PLine& arc= plFreeProfiles[j]; 
			
			if (arc.coordSys().vecZ().dotProduct(vzSip)<0)
				arc.flipNormal();
			
			for (int i=0;i<pts.length()-1;i++) 
			{ 
				Point3d pt1= pts[i]; 	//pt1.vis(i);				
				if (arc.isOn(pt1))
				{ 
				// get direction of arc and envelope	
					Point3d ptA1 = arc.ptMid();
					double dA1 = arc.getDistAtPoint(ptA1);
					Point3d ptA2 = arc.getPointAtDist(dA1+dEps);
					Vector3d vecA = ptA2 - ptA1; vecA.normalize(); //vecA.vis(ptA1, 1);
					
					Point3d ptB1 = plEnvelope.closestPointTo(ptA1);
					double dB1 = plEnvelope.getDistAtPoint(ptB1);
					double dB2 = dB1 > plEnvelope.length() - dEps ? dEps : dB1 + dEps;
					Point3d ptB2 = plEnvelope.getPointAtDist(dB2);
					Vector3d vecB = ptB2 - ptB1; vecB.normalize();
					
					if (vecA.dotProduct(vecB) < 0)
					{
						arc.reverse();
						vecB.vis(ptA1, 20);
					}
					else
						vecB.vis(ptA1, 3);
					//arc.coordSys().vecZ().vis(pt1, 150);
					break;
				}
				 
			}//next i	 
		}//next j			
	//End Make sure arcs walk in same direction//endregion 
		
	//region Rebuild envelope with arcs
		PLine plNew(vzSip);
		int n;
		for (int j=0;j<plFreeProfiles.length();j++) 
		{ 
			PLine& arc= plFreeProfiles[j]; 
			Point3d ptStart= arc.ptStart();
			Point3d ptEnd= arc.ptEnd();//ptStart.vis(1);
			
		// add arc
			plNew.addVertex(ptStart);
			plNew.addVertex(ptEnd, arc.ptMid());
			
		// jump to next arc if starts and end of this	
			if (j<plFreeProfiles.length()-1)
			{ 
				Point3d ptStartNext= plFreeProfiles[j+1].ptStart();
				if (Vector3d(ptEnd-ptStartNext).length()<dEps)
				{
					continue;
				}
			}
			
		/// add  straight segments until it closes
			int bAdd;
			
			ptEnd = plNew.ptEnd();
			
			for (int i=0;i<pts.length();i++) 
			{ 
				Point3d ptX= pts[i]; 	
			
				if (bAdd)
				{ 
					//ptX.vis(252);
				// jump to next arc if starts and end of this	
					if (j<plFreeProfiles.length()-1)
					{ 
						Point3d ptStartNext= plFreeProfiles[j+1].ptStart();	
						if (Vector3d(ptX-ptStartNext).length()<dEps)
						{
							continue;	
						}
					}
				// close and end
					else if (Vector3d(ptX-plNew.ptStart()).length()<dEps)
					{ 
						plNew.close();
						plEnvelope = plNew;
						plEnvelope.vis(3);
						break;
					}
					else
					{ 
						//ptX.vis(2);
						ptEnd = ptX;
						plNew.addVertex(ptX);
						
					}
				}
			
			
				else if (Vector3d(ptEnd-ptX).length()<dEps)
				{ 
					bAdd = true;
					//ptX.vis(i);
				}
			}//next i

		}//next j
		
					
	//End Rebuild envelope with arcs//endregion 

		
	}	
//End Rebuild with arcs//endregion 	
	
	
	
	
	
	
	
	
// panel creation or assignment
	int nStyleSelected = sStyles.find(sStyleSelected);
	Sip sip;
	
	
	if (_Sip.length()>0)
		sip = _Sip[0];
	else if (plEnvelope.area()>pow(dEps,2) && nStyleSelected>0)
	{
		plEnvelope.setNormal(vzSip);	
		sip.dbCreate(plEnvelope,sStyleSelected,1);	
		sip.setXAxisDirectionInXYPlane(vxSip);
		sip.setWoodGrainDirection(vecWoodGrainDirection);
		sip.setColor(nColor);
		
	// assign meta data if defined
		if (mapMeta.length()>0)
		{
			Map mapIO;
			mapIO.setInt("function",1);	
			mapIO.setEntity("sip",sip);
			mapIO.setMap("metaData", mapMeta);		
			TslInst().callMapIO(scriptName(), mapIO);
		}
		
	// assign meta data from source entity
		if (mapConversion.hasString(sKeyMaterial))
			sip.setMaterial(mapConversion.getString(sKeyMaterial));
		if (mapConversion.hasString(sKeyGrade))
			sip.setGrade(mapConversion.getString(sKeyGrade));			
		if (mapConversion.hasString(sKeyInformation))
			sip.setInformation(mapConversion.getString(sKeyInformation));
		if (mapConversion.hasString(sKeyName))
			sip.setName(mapConversion.getString(sKeyName));		
		if (mapConversion.hasString(sKeyLabel))
			sip.setLabel(mapConversion.getString(sKeyLabel));
		if (mapConversion.hasString(sKeySublabel))
			sip.setSubLabel(mapConversion.getString(sKeySublabel));					
		if (mapConversion.hasString(sKeySQRef))
			sip.setSurfaceQualityOverrideTop(mapConversion.getString(sKeySQRef));	
		if (mapConversion.hasString(sKeySQOpp))
			sip.setSurfaceQualityOverrideBottom(mapConversion.getString(sKeySQOpp));
		if (mapConversion.hasString(sKeyPosNum))
			sip.assignPosnum(mapConversion.getString(sKeyPosNum).atoi(), true);			
	// append to global array
		_Sip.append(sip);
	}
	else if(nStyleSelected ==0)
		;
	else
	{
		if (_kExecutionLoopCount==0)//_bOnDbCreated)//
		{
			setExecutionLoops(2);
			return;
		}
		else
		{
			reportMessage("\n" + _ThisInst.handle()+" " +T("|Unexpected error|") + "\n Area:" + plEnvelope.area() + " loop: " + _kExecutionLoopCount);
			dp.color(6);
			dp.draw(_ThisInst.handle() + "XXXX" + entSolid.handle(), _Pt0, _XW,_YW,1,3,_kDeviceX);
//			eraseInstance();
			return;
		}
	}
	
// change color on request
	if (sip.bIsValid() && _kNameLastChangedProp == sColorName)
		sip.setColor(nColor);

// conversion is accepted by default if all required properties and values are set
	int bAllowConversionAccepted = _Map.getInt("AllowConversionAccepted");
	int bConversionAccepted = (nQtyAmbiguos==1 || nStyle!=0) && bAllowConversionAccepted ;	// accept conversion if allowed by meta data and style is selected or not ambigious

// trigger accept conversion
	String sTriggerAccept = T("|Accept Conversion|");
	addRecalcTrigger(_kContext,sTriggerAccept);
	if (_bOnRecalc && _kExecuteKey==sTriggerAccept) 
	{	
		bConversionAccepted=true;
	}	

// trigger reject conversion
	String sTriggerDiscard = T("|Discard Conversion|");
	addRecalcTrigger(_kContext,sTriggerDiscard);
	if (_bOnRecalc && _kExecuteKey==sTriggerDiscard) 
	{	
		if (bm.bIsValid() && !bIsBeam)bm.dbErase();
		if (sip.bIsValid())sip.dbErase();
		eraseInstance();
		return;
	}	


// collect and apply tools and modify edges of sip
	PlaneProfile ppSip;
	if (sip.bIsValid())// && (!_Map.getInt("ToolsAdded") || bDebug))
	{	
		if (bDebug)reportMessage("\nStart collect and apply tools");	

	// get the vertices of the cutted envelope body to distinguish  cuts which would contribute planes to stretch to
		Point3d ptsBody[] = bdCuts.allVertices();

	// collect sip edges
		SipEdge edges[] = sip.sipEdges();
		
	//region Stretch hex edges HSB-11073
		for (int e=edges.length()-1; e>=0 ; e--) 
		{ 
			PLine pl =edges[e].plEdge();
			pl.projectPointsToPlane(Plane(ptRef, vzSip), vzSip);
			int bRemove;
			for (int i=0;i<pnHexStretchEdges.length();i++) 
			{ 
				Point3d pt = pnHexStretchEdges[i].ptOrg();
				pt.vis(3);	
				
				double d = Vector3d(pt - pl.closestPointTo(pt)).length();
				
				pl.vis(2);
				if (pl.isOn(pt) || d<dEps)
				{ 
					sip.stretchEdgeTo(pt, pnHexStretchEdges[i]);
					bRemove = true;
					break;
				}
			}//next i
			if (bRemove)
				edges.removeAt(e);
		}//next e			
	//endregion 	

	// filter contour edges by testing projected edge mid point being in min convex hull profile
		ppSip.joinRing(plEnvelope,_kAdd);
		double dConvexMerger=sip.solidLength()+sip.solidWidth();
		ppSip.shrink(-dConvexMerger);
		ppSip.shrink(dConvexMerger);	
		ppSip.vis(2);
		
	// filter contour edges by testing projected edge mid point being in convex hull profile		
		PLine plHull;
		plHull.createConvexHull(pnFaceRef,plEnvelope.vertexPoints(true));
		PlaneProfile ppHull(plHull); //ppHull.vis(40);

		SipEdge edgesContour[0], edgesContourDoubleCut[0];
		for (int e=edges.length()-1;e>=0;e--)
		{
			SipEdge edge = edges[e];
			Vector3d vecZ = edge.vecNormal();
			Vector3d vecX = edge.ptEnd()-edge.ptStart(); vecX.normalize();
			Vector3d vecY = vecX.crossProduct(-vecZ); 

			Point3d pt = edge.ptMid();//+vecZ*dEps;
			pt = Line(pt,vecY).intersect(pnFaceRef,0)+vecZ*dEps;
			//pt.vis(e);
			if (ppHull.pointInProfile(pt)==_kPointOutsideProfile)
			{	
				edgesContour.append(edges[e]);	
			}
			else if (ppSip.pointInProfile(pt)==_kPointOutsideProfile)
			{
				//pt.vis(1);
				edgesContourDoubleCut.append(edges[e]);
			}
			else 
			{
				// 3.7	edges.removeAt(e);
				continue;
			}
			vecZ.vis(pt,1);		
		}			
	
	// collect intersecting lines with ref face and each cut
		Line lines[cuts.length()];
		for (int c=cuts.length()-1;c>=0;c--)
		{
			AnalysedCut cut = cuts[c];
			Point3d ptOrg = cut.ptOrg();
			Vector3d vecZCut = cut.normal();
			if (vecZCut.isParallelTo(vzSip))
			{
				cuts.removeAt(c);
				lines.removeAt(c);
				continue;			
			}
			//vecZCut.vis(ptOrg ,c);	
			Plane pnCut(ptOrg,vecZCut);	
			Line line = pnFaceRef.intersect(pnCut);
			//line.vis(c);//vecX().vis(line.ptOrg(),c);		
			lines[c] = line;
		}	
		
		
	// loop sip contour edges and add stretching planes
		AnalysedCut cutsEdges[0];		
		for (int e=edgesContour.length()-1;e>=0;e--)
		{
			SipEdge edge = edgesContour[e];
			Point3d ptMid = edge.ptMid();
		// get vecX of edge but ignore very short edges and circles			
			Vector3d vecX = edge.ptEnd()-edge.ptStart();			
			if (vecX.length()<dEps)continue;
			vecX.normalize();		
			Vector3d vecZ = edge.vecNormal();
			Vector3d vecY = vecX.crossProduct(-vecZ);
			Vector3d vecNormal = vecZ.crossProduct(vzSip).crossProduct(-vzSip);vecNormal.normalize();
			
		// project mid point of edge to ref face
			Line lnEdgeY(ptMid,vecY);
			ptMid = lnEdgeY.intersect(pnFaceRef,0);	

		// collect cuts relative to this edge
			AnalysedCut cutsThis[0];
			for (int c=0;c<cuts.length();c++)
			{
				Vector3d vecX2 = lines[c].vecX();//vecX2 .vis(ptMid,c);
				AnalysedCut cut = cuts[c];
				Point3d ptOrg = cut.ptOrg();
				Vector3d vecZCut = cut.normal();
				double d1 = vecNormal.dotProduct(vecZCut);
				double d2 =vecX.dotProduct(vecX2);
				int bPar = vecX.isParallelTo(vecX2);
				if (abs(abs(d2)-1)<dEps/1000 && d1>0)
				{
					cutsThis.append(cut);
					//vecZCut.vis(ptMid ,c);
				}
			}

		// find cuts which define a stretch plane
			int bStretched;
			AnalysedCut cutsEdge[0];	
			for (int c=cutsThis.length()-1;c>=0;c--)
			{
				AnalysedCut cut = cutsThis[c];
				Point3d ptOrg = cut.ptOrg();
				Vector3d vecZCut = cut.normal();
				
				Plane pnCut(ptOrg,vecZCut);
				
			// accept only cuts which are in the edge XZ-plane
				if (vzSip.isPerpendicularTo(vecZCut))//abs(vecZCut.dotProduct(ptMid-ptOrg))>dEps || 
				{
					continue;	
				}
				else 
				{
//					vecZCut.vis(ptOrg ,c);	
//					vecNormal.vis(ptMid,4);

					if(!bStretched)
					{					
						//vecZCut.vis(ptMid,20);	//vecZCut.vis(ptOrg ,150);	//	vecY.vis(ptMid,3);
						
						int bStretchMe = !vzSip.isPerpendicularTo(vecZCut);

					// stretch the sip if the threshold is not defined or the angle is greater than the threshold									
						if (bStretchMe && abs(dThresholdEdge)!=90 && dThresholdEdge!=0)
						{
							Vector3d vecZCutN = vecZCut.crossProduct(-vzSip).crossProduct(vzSip);
							double dAngle = vecZCut.angleTo(vecZCutN);
							if (abs(dAngle)<abs(dThresholdEdge))
								bStretchMe =false;
						}
						
					// test if stretch would be valid	
						Vector3d vecXCut = vecZCut.crossProduct(vecZ);
						Vector3d vecYCut = vecXCut.crossProduct(vecZCut);vecYCut.normalize();
						//vecYCut.vis(ptOrg, 3);
						Point3d pt1, pt2;
						Line lnY(ptOrg, vecYCut);
						int bFacesFound = lnY.hasIntersection(pnFaceRef, pt1) && lnY.hasIntersection(pnFaceOpp, pt2);
						
					// Extent panel if stretch would lead into envelope extension
						if (bFacesFound && (ppShadow.pointInProfile(pt1)==_kPointOutsideProfile || ppShadow.pointInProfile(pt2)==_kPointOutsideProfile))
						{ 
							Point3d pts[] = Line(ptOrg, vecNormal).orderPoints(ptsBody);
							if (pts.length()>0)
							{
								Plane pn(pts.last(), vecNormal);
								//pn.vis(1);
								sip.stretchEdgeTo(ptMid, pn);
							}
							cutsThis.removeAt(c);
							bStretched=true;
						}
					// stretch edge	
						else if (bStretchMe)
						{
							sip.stretchEdgeTo(ptMid, Plane(ptOrg,vecZCut));
							cutsEdges.append(cut);// append this cut to the list of processed cuts
							cutsThis.removeAt(c);
							bStretched=true;
						}
						
					// test chamfer cuts
						double dAngle = vecZCut.angleTo(vecNormal, vzSip);
						int bIsChamfer;
						if (abs(abs(dAngle)-45)<dEps ||abs(abs(dAngle)-315)<dEps)
						{ 
							Point3d pts[] = cut.bodyPointsInPlane();
							pts = Line(ptOrg, vecYCut).orderPoints(pts);
							double hypotenuse = abs(vecYCut.dotProduct(pts.last()-pts.first()));
							bIsChamfer = hypotenuse <= U(4.1);
						}
		
					// suppress this cut to be processed if in basic mode and chamfer
						if (bIsChamfer && bBoundingBody)
						{
							cutsEdges.append(cut);
						}

					}
					if (bStretched)break;
				}
			}// next c

		// add normal cut if it is aligned with edge	
			for (int c=cutsThis.length()-1;c>=0;c--)
			{
				AnalysedCut cut = cutsThis[c];
				Point3d ptOrg = cut.ptOrg();
				Vector3d vecZStatic = cut.normal();
			// if this edge is not stretched do not add any perp cuts
				if (!bStretched && vecZStatic.isPerpendicularTo(vzSip))
				{
					cutsEdges.append(cut);// append this cut to the list of processed cuts
					continue;	
				}
				
				//vecZStatic.vis(ptOrg,150);
				Cut ct(ptOrg,vecZStatic);
				
				
			// cut the sip if the threshold is not defined or the angle is greater than the threshold	
				int bDo = true;
				if (abs(dThresholdCutNormal)!=90 && dThresholdCutNormal!=0)
				{
					Vector3d vecZCutN = vecZStatic.crossProduct(-vzSip).crossProduct(vzSip);
					double dAngle = vecZStatic.angleTo(vecZCutN);
					if (abs(dAngle)<abs(dThresholdCutNormal))
						bDo=false;
				}
				if (bDo)
				{
					if (bConversionAccepted || _bOnDebug)
						sip.addToolStatic(ct,0);
					else
						sip.addTool(ct,0);	
				}
				cutsEdges.append(cut);// append this cut to the list of processed cuts	
				
			}// next c
		}// next e edgesContour

	// any cut not in the list of edges cuts is assumed to be an arbitrary cut
		for (int c=cuts.length()-1;c>=0;c--)
		{
			AnalysedCut cut = cuts[c];
			Point3d ptOrg = cut.ptOrg();
			Vector3d vecZCut = cut.normal();
			int bDel;
			for (int d=cutsEdges.length()-1;d>=0;d--)
			{
				AnalysedCut cut2 = cutsEdges[d];
				Point3d ptOrg2 = cut2.ptOrg();
				Vector3d vecZCut2 = cut2.normal();
				if (vecZCut2.isCodirectionalTo(vecZCut) && abs(vecZCut.dotProduct(ptOrg-ptOrg2))<dEps)
				{
					bDel=true;
					break;	
				}					
			}
			if (bDel)
			{
				cuts.removeAt(c);
				continue;	
			}

		// do not add any perp cuts
			Vector3d vecZStatic=vecZCut;		
			if (vecZStatic.isPerpendicularTo(vzSip))
			{
				continue;	
			}

			//vecZStatic.vis(ptOrg,151);
			Cut ct(ptOrg,vecZStatic);
			if (bConversionAccepted || _bOnDebug)
				sip.addToolStatic(ct,0);
			else
				sip.addTool(ct,0);						
		}
	
	// stretch sip edges of sip against potential doublecuts
		for (int c=dcuts.length()-1;c>=0;c--)
		{
			Vector3d vecNs[] = {dcuts[c].vecN1(),dcuts[c].vecN2()};
			Point3d ptOrgDc = dcuts[c].ptOrg();
			Plane pn1(ptOrgDc,vecNs[0]), pn2(ptOrgDc,vecNs[1]);
			if(!pn1.hasIntersection(pn2)) {continue;}
			Line lnDc = pn1.intersect(pn2);
			if(!Line(ptOrgDc, lnDc.vecX()).hasIntersection(pnFaceRef)){continue;}
			ptOrgDc =Line(ptOrgDc, lnDc.vecX()).intersect(pnFaceRef,0);//ptOrgDc.vis(4);
			
		// loop all prefiltered edges which could match with this doublecut
			for (int e=edgesContourDoubleCut.length()-1;e>=0;e--)
			{
				SipEdge edge = edgesContourDoubleCut[e];
				
				Vector3d vecZ = edge.vecNormal();
				Vector3d vecX = edge.ptEnd()-edge.ptStart();vecX.normalize();
				Point3d ptMid = edge.ptMid();
				Plane pnEdge(ptMid, vecZ);
				ptMid = ptMid.projectPoint(pnFaceRef,0);
				
			// flag loop
				int bStretched;
				for (int x=0;x<vecNs.length();x++)
				{
					Plane pn (ptOrgDc ,vecNs[x]);
					if(!pnFaceRef.hasIntersection(pn)) {continue;}
					Line lnCut = pnFaceRef.intersect(pn);
					if (lnCut.vecX().isParallelTo(vecX) && Vector3d(ptOrgDc-pnEdge.closestPointTo(ptOrgDc)).length()<dEps)
					{
						lnCut.vecX().vis(ptMid,e);
						//vecNs[x].vis(ptMid,e);
						sip.stretchEdgeTo(ptMid, Plane(ptOrgDc,vecNs[x]));	
						bStretched=true;
						break;
					}
				}
			// remove if flagged
				if (bStretched)
				{
					edgesContourDoubleCut.removeAt(e);
				}
			}
		}
	// next c doubleCut of stretch sip edges of sip against potential doublecuts	
		
	// TILTED TYPES: _kABCHouseTilted,_kABCOpenDiagonalSeatCut,_kABCRisingBirdsmouth, _kABC5Axis, _kABC5AxisBirdsmoutrh, _kABCLapJoint stretch edges against//region
		for (int i=abcs.length()-1; i>=0 ; i--) 
		{ 
			String sSubType = abcs[i].toolSubType();
			if (sTiltedTypes.find(sSubType)<0) continue; 
			
		// collect relevant planes 	
			Quader q = abcs[i].quader(U(10));
			Plane pns[] = { q.plFaceD(vxSip),q.plFaceD(-vxSip),q.plFaceD(vySip),q.plFaceD(-vySip),q.plFaceD(vzSip),q.plFaceD(-vzSip)};		
			edges = sip.sipEdges();
			//q.vis(40);
			
		// loop planes
			int bFound;
			for (int x=0;x<pns.length();x++) 
			{ 
				//pns[x].vis(x);
				Vector3d vecXP = pns[x].vecZ();
				if (abcs[i].bIsFreeD(vecXP)) continue; // do not try to modify edges where the beamcut has a free direction
				if (vecXP.isPerpendicularTo(vzSip))continue; // do not try to modify perp edges
				if (vecXP.isParallelTo(vzSip))continue; // HSB-8376
				
				Vector3d vecYP = vecXP.crossProduct(-vzSip);
				Vector3d vecZP = vecXP.crossProduct(vecYP);
				Point3d pt;
			// project to reference face	
				if (!Line(pns[x].ptOrg(), vecZP).hasIntersection(pnFaceRef, pt))continue;
				pt.vis(x); //vecZP.vis(pt,150);  vecYP.vis(pt,3);
			// loop edges
				for (int e=edges.length()-1;e>=0;e--)
				{ 	
					SipEdge& edge = edges[e];
					Point3d ptEdge = edge.ptMid();
					Vector3d vecNormal = edge.vecNormal();
					Vector3d vecZE = vecNormal.crossProduct(vecNormal.crossProduct(-vzSip));
					if (!Line(ptEdge, vecZE).hasIntersection(pnFaceRef, ptEdge))
					{
						continue;
					}
//					vecNormal.vis(ptEdge, 1);
					
					//vecXP.vis(pt, 2);
					
				// test if on plane of quader
					//version  value="5.3" date=13apr18" author="thorsten.huck@hsbcad.com"> tilted beamcuts further enhanced
					if (abs(vecXP.dotProduct(pt - ptEdge))<dEps)
					{
						//PLine(pt,edge.ptMid() ).vis(4);
//						vecXP.vis(pt,1);
//						vecYP.vis(pt,3);
						//reportMessage("\ntry stretching " + sSubType + " on edge e " +e);
						sip.stretchEdgeTo(pt, Plane(pt,-vecXP));
						bFound = true;
						break;
					}	
				}// next e egde
			}// next plane
			
			if (bDebug)
			{
				q.vis(2);
				Display dp(bFound?3:12);
				dp.textHeight(U(40));
				dp.draw(abcs[i].toolSubType()+(bFound?"":"not found"), q.pointAt(0, 0, 0), vxSip, vySip, 0, 0, _kDeviceX);
			}				
			
			
			if (bFound)
				abcs.removeAt(i);
		}// next c of abcs//endregion

	
		//plEnvelope.vis(2);
	// loop edges for beamcut dependent stretchings//region
		if (bDebug)reportMessage("\n	" + edges.length() + " edges collected");
		edges = sip.sipEdges();

		for (int e=edges.length()-1;e>=0;e--)
		{
			SipEdge edge = edges[e];
			Vector3d vecNormal = edge.vecNormal();
			Point3d ptMid = edge.ptMid();
			vecNormal.vis(ptMid,3);
			
		// create a tiny cylinder on the segment
			double dR = U(1);
			Point3d pt1=edge.ptStart(), pt2=edge.ptEnd();
			Vector3d vxSeg = pt2-pt1;
			if (vxSeg.length()<5*dR)continue;
			vxSeg.normalize();
			pt1 = plEnvelope.closestPointTo(pt1+vxSeg*dR*2);
			pt2 = plEnvelope.closestPointTo(pt2-vxSeg*dR*2);;
			Point3d ptMidSeg = (pt1+pt2)/2;ptMidSeg .vis(6);
			Body bdEdge(pt1,pt2, dR);
		
		// find biggest intersection tool	
			Body bdIntersection;
			int x=-1;
			for (int i=0; i<abcEdgeTools.length();i++)
			{
				AnalysedBeamCut abc = abcEdgeTools[i];
				Quader qdr = abc.quader();	
				CoordSys cs = abc.coordSys();	
				Vector3d vxBc = cs.vecX();
				Vector3d vyBc = cs.vecY();
				Vector3d vzBc = cs.vecZ();
				Point3d pt = cs.ptOrg();
				
				Body bd(pt,vxBc,vyBc,vzBc,qdr.dD(vxBc),qdr.dD(vyBc),qdr.dD(vzBc),0,0,0);
				Body bdTest = bd;
				Body _bdEdge = bdEdge;
				
				bdTest.intersectWith(_bdEdge);
				if (bdTest.volume()>bdIntersection.volume())
				{
					bdTest.vis(2);	
					_bdEdge.vis(i+30);
					bdIntersection=bdTest;
					x=i;	
				}
				else
				{ 
					bdTest = bd;
					
					_bdEdge.transformBy(vzSip * vzSip.dotProduct(pt - pt1));
					bdTest.intersectWith(_bdEdge);		
					if (bdTest.volume()>bdIntersection.volume())
					{
						_bdEdge.vis(i+40);
						bdIntersection=bdTest;
						x=i;	
					}					
				}
	
			}// next abc of edge
		
			double dIntersectionVolume = bdIntersection.volume();
		
		
		// tool found	
			if (x>-1 && dIntersectionVolume>pow((dR*2),3))// && abcEdgeTools[x].toolSubType()!=_kABCRisingSeatCut)  // https://hsbcad.myjetbrains.com/youtrack/issue/HSB-14486
			{
				if (bDebug)reportMessage("\n		edge beamcut found at " + x + " will remove edge " + e + " " + abcEdgeTools[x].toolSubType());
				Quader qdr = abcEdgeTools[x].quader();
				AnalysedBeamCut abc = abcEdgeTools[x];
				Vector3d vecNormal = qdr.vecD(vecNormal);
				int bDoStretch = !vecNormal.isPerpendicularTo(vzSip);
				
				
			// HSB-16642
				if (abc.toolSubType() == _kABCRisingSeatCut)
				{ 
						
					CoordSys cs = abc.coordSys();	
					Vector3d vxBc = cs.vecX();
					Vector3d vyBc = cs.vecY();
					Vector3d vzBc = cs.vecZ();
					Point3d pt = cs.ptOrg();		
					Body bd(pt,vxBc,vyBc,vzBc,qdr.dD(vxBc),qdr.dD(vyBc),qdr.dD(vzBc),0,0,0);	
					
					double dLengthDir = bd.lengthInDirection(vxSeg);
					double dEdgeLengthDir = bdEdge.lengthInDirection(vxSeg);
					
					if (abs(dEdgeLengthDir-dLengthDir)>U(100))
						bDoStretch = false;
				}

				
				
				if (bDoStretch)// 3.7 rafter cut outs
				{
					qdr.vis();
					vecNormal.normalize();
					Vector3d vecZN = vzSip.crossProduct(vecNormal).crossProduct(-vecNormal);
					Point3d ptX = qdr.ptOrg()-vecNormal*.5*qdr.dD(vecNormal);
					ptX=Line(ptX, vecZN).intersect(pnFaceRef,0);
					
					Vector3d vecStretch = vecNormal;
				// validate if the stretch plane is a free direction // version 4.3
					if (!abcEdgeTools[x].bIsFreeD(vecZN) || !abcEdgeTools[x].bIsFreeD(-vecZN))
					{
						if (!abcEdgeTools[x].bIsFreeD(vecZN))
							vecStretch=vecZN;
						else if (!abcEdgeTools[x].bIsFreeD(-vecZN))
							vecStretch=-vecZN;
						else 
						{
							//vecNormal.vis(ptX ,1);
							//vecZN .vis(ptX ,4);
							continue;
						}	
					}
								
//					bdEdge.vis(2);			
//					edge.vecNormal().vis(ptX,6);
		
					if (edge.vecNormal().dotProduct(vecStretch)<0)
						vecStretch *= -1;
					
					vecStretch.vis(ptX ,3);vecZN .vis(ptX ,4);
					//bdEdge.vis(160);
					sip.stretchEdgeTo(ptX , Plane(ptX ,vecStretch));
					//edges.removeAt(e);
				}
				else
					abcs.append(abcEdgeTools[x]);
			}
			else
				;//bdEdge.vis(211);					
		}//endregion
	
	// add beamcuts originated from inaccurate doublecuts
		for (int i=0;i<bcs.length();i++) 
		{ 
			//bcs[i].cuttingBody().vis(120);
			if (bConversionAccepted || _bOnDebug)
				sip.addToolStatic(bcs[i]);
			else
				sip.addTool(bcs[i]);			 
		}
		
	}// END IF sip.bIsValid()_______________________________________________________________________________________________________CUTS


// collect pockets: a pocket is a combination of one beamcut and two drills with the same depth and diameter/width
	for (int i=abcs.length()-1; i>=0 ; i--) 
	{ 
		AnalysedBeamCut abc = abcs[i];	
		CoordSys cs = abc.coordSys();	
		Point3d pt = cs.ptOrg();
		Quader qdrAbc = abc.quader();
	
	// get vecs and dims
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();

	// face
		if ( ! abc.bIsFreeD(vecZ) && !abc.bIsFreeD(-vecZ))continue;
		Vector3d vecFace = vecZ;
		if (!abc.bIsFreeD(vecZ))
			vecFace*= -1;

	// align coordSys with face
		Vector3d vecsX[] ={ vecX, vecY, vecZ};
		Vector3d vecsY[] ={ vecY, vecZ, vecX};
		Vector3d vecsZ[] ={ vecZ, vecX, vecY};

		double dMax;
		for (int j=0;j<vecsZ.length();j++) 
		{ 
			double d = abs(vecFace.dotProduct(vecsZ[j])); 
			if (d>dMax)
			{ 
				vecX = vecsX[j];
				vecY = vecsY[j];
				vecZ = vecsZ[j];
				dMax = d;
			}
		}
		double dX =qdrAbc.dD(vecX), dY=qdrAbc .dD(vecY), dZ=qdrAbc .dD(vecZ);

		Body bd(qdrAbc.pointAt(0, 0, 0), vecX, vecY, vecZ, dX, dY, dZ, 0, 0, 0);
		
		
		Point3d ptA = qdrAbc.pointAt(0, 0, 0)+vecFace*.5*dZ, ptB = qdrAbc.pointAt(0, 0,0)+vecFace*.5*dZ;
		//vecFace.vis(ptA,2);		ptB.vis(3);bd.vis(2);
	
	// collect a pair of drills intersecting 
		int nIndices[0];
		Vector3d vecXPocket, vecYPocket;
		double dXPocket, dYPocket, dZPocket = qdrAbc.dD(vecFace);
		for (int j=0;j<drills.length();j++)
		{
			AnalysedDrill drillA = drills[j];
			Vector3d vecZFreeA = drillA.vecFree();
			double dDiameterA = drillA.dDiameter();		
			int bThroughA = drillA.bThrough();
			Point3d ptStartA = drillA.ptStart();
		// depth not matching
			if (abs(drillA.dDepth()-dZPocket) > dEps)continue;
			
		// diameter not matching
			if ( ! (abs(dDiameterA - dX) < dEps || abs(dDiameterA - dY) < dEps)) continue;		
		
		// free direction not matching
			if (!bThroughA && !vecZFreeA.isCodirectionalTo(vecFace)) continue;
			
			
			for (int k=0;k<drills.length();k++)
			{
				if (k == j)continue;
				AnalysedDrill drillB = drills[k];
				Vector3d vecZFreeB = drillB.vecFree();
				double dDiameterB = drillB.dDiameter();		
				int bThroughB = drillB.bThrough();
				Point3d ptStartB = drillB.ptStart();
			// depth not matching
				if (abs(drillB.dDepth()-dZPocket) > dEps)continue;

			// diameter A and B not matching
				if (abs(dDiameterB- dDiameterA) > dEps) continue;	

			// diameter not matching
				if ( ! (abs(dDiameterB- dX) < dEps || abs(dDiameterB - dY) < dEps)) continue;		
			
			// free direction not matching
				if (!bThroughB && !vecZFreeB.isCodirectionalTo(vecFace)) continue;
			
				
			// get vec between drills
				vecXPocket = ptStartB-ptStartA;
				vecXPocket.normalize();
				vecYPocket = vecXPocket.crossProduct(-vecFace);

				double dMidOffset = abs(vecYPocket.dotProduct(ptA - ptStartA));
			
			// the drills are not in line with the beamcut
				if (dMidOffset > dEps)continue;
			
			// test center in relation to org of beamcut
				double dXA = abs(vecXPocket.dotProduct(ptA - ptStartA));
				double dXB = abs(vecXPocket.dotProduct(ptA - ptStartB));
				double dXAbc = qdrAbc.dD(vecXPocket);
				if (!(abs(dXA-.5*dXAbc)<dEps && abs(dXB-.5*dXAbc)<dEps)) continue;

				nIndices.append(j);
				nIndices.append(k);
				
				dXPocket = dXAbc + dDiameterA;
				dYPocket = dDiameterA;

				break;// k
			}// next k drill
			if (nIndices.length() == 2)break;
		}// next j drill
		
	// create pocket and remove 2 drills and a beamcut
		if (nIndices.length() == 2)
		{ 
			vecXPocket.vis(ptA,221);
			vecYPocket.vis(ptB,211);
			double dAngle = sip.vecX().angleTo(vecXPocket);
			String sSide = vecFace.isCodirectionalTo(vzSip) ? T("|Opposite Side|") : T("|Reference Side|");

			
		// prepare tsl cloning
			TslInst tslNew;
			Vector3d vecXTsl= sip.vecX();
			Vector3d vecYTsl= sip.vecY();
			GenBeam gbsTsl[] = {sip};
			Entity entsTsl[] = {};
			Point3d ptsTsl[] = {ptA};
			int nProps[]={};
			double dProps[]={dXPocket,dYPocket,dZPocket, dYPocket*.5, dAngle};
			String sProps[]={sSide,T("|center-center|") };
			Map mapTsl;	
			String sScriptname = "hsbCLT-Pocket";
			
			ptsTsl.append(ptA);


		// create pocket
			if (bConversionAccepted)
			{ 
				tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);	
				
				drills.removeAt(nIndices[1]);
				drills.removeAt(nIndices[0]);
				
				abcs.removeAt(i);
			}

		}
		
		
	}// next i abc


//region add openings and remaining beamcuts
	if (sip.bIsValid() && (!_Map.getInt("ToolsAdded") || bDebug))		
	{	
	// add all openings
		for (int i=0;i<plOpenings.length();i++)
		{
			PLine pl =plOpenings[i];
			int bAddPlumb = bAddPlumbs[i];
			//pl.projectPointsToPlane(pnFaceRef, vzSip);
			pl.vis(2);
			sip.addOpening(pl,bAddPlumb);
		}
		
	// add doublecuts	
		for (int i=0;i<dcuts.length();i++) 
		{ 
			AnalysedDoubleCut& adc = dcuts[i]; 
			if (!(adc.vecN1().isParallelTo(vzSip) || adc.vecN2().isParallelTo(vzSip)))continue;
			//adc.vecN1().vis(adc.ptOrg(), 4);			adc.vecN2().vis(adc.ptOrg(), 4);
			DoubleCut dc(adc.ptOrg(), adc.vecN1(), adc.ptOrg(), adc.vecN2());
			sip.addToolStatic(dc);
		}	
		
		
	// add all remaining beamcuts				
		for (int i=abcs.length()-1;i>=0;i--)
		{
			AnalysedBeamCut abc = abcs[i];	
			CoordSys cs = abc.coordSys();	
			Point3d pt = cs.ptOrg();
			Quader qdrAbc = abc.quader();
		
		qdrAbc.vis(254);
		
		// enlarge to free directions
			Vector3d vxBc = cs.vecX();
			Vector3d vyBc = cs.vecY();
			Vector3d vzBc = cs.vecZ();
			double dDs[] = {qdrAbc.dD(vxBc),qdrAbc.dD(vyBc),qdrAbc .dD(vzBc)};			
			Vector3d vecs[] = {vxBc,vyBc,vzBc};
			for (int j=0;j<vecs.length();j++)
			{
				int nDir=1;
				for (int k=0;k<2;k++)
				{
					if (abc.bIsFreeD(nDir*vecs[j]))
					{	
						pt.transformBy(nDir*vecs[j]*dDs[j]/2);
						dDs[j]*=2;
					}	
					nDir*=-1;
				}				
			}
			
			if (dDs[0]>dEps && dDs[1]>dEps && dDs[2]>dEps)
			{
			// make sure this beamcut would modify the CLT, version  value="1.4" date=07apr14" author="th@hsbCAD.de"> redundant beamcut removal added
				Body bd(pt,vxBc,vyBc,vzBc,dDs[0], dDs[1], dDs[2],0,0,0);	
			bd.vis(4);	
				
				if (bdEnvelope.hasIntersection(bd))
				{
					BeamCut bc(pt,vxBc,vyBc,vzBc,dDs[0], dDs[1], dDs[2],0,0,0);	
					sip.addToolStatic(bc);
					abcs.removeAt(i);					
				}
				else
				{
					if(bDebug)
					{
						reportMessage("\nRedundant beamcut " + i +" rejected");
						//bd.vis(6);
					}	
				}
			}		
			
		} // next i
		_Map.setInt("ToolsAdded",1);
	}		
//End add openings and remaining beamcuts//endregion 

// reset profile
	if (sip.bIsValid())
		ppSip=PlaneProfile(sip.plEnvelope());


// declare collectors for the different approaches to of drill conversion
	// all need to be of same length and order
	Point3d ptsDrill[0];
	Vector3d vecDrills[0];
	double dDrillDiameters[0];
	double dDrillDepths[0];
	
	
	
// interprete Analysed drills
	int bHasMeta = mapMeta.length() > 0;
	int nNumDrill;
	if (sip.bIsValid())
	{ 
		nNumDrill = drills.length();
		if (bConversionAccepted && nNumDrill>0)reportNotice("\n"+scriptName() + T(": |creating drill tools| (") + nNumDrill + T(") |Please wait...|"));
		for (int i=0;i<nNumDrill;i++)
		{
			//reportNotice("\nDrill " + i + " at " + getTickCount());
			AnalysedDrill& drill = drills[i];
			Vector3d vecZDrill = -drill.vecFree();		//vecZDrill.vis(drill.ptStart(), i);
			double dDiameter = drill.dDiameter();
			int bThrough = drill.bThrough();
			
			// check if Meta data has property ThresholdMaxDrill
			int bAddAsDrill = !bHasMeta && dDiameter<U(200);	
			if (bHasMeta)
			{ 
				double dTreshCheck = mapMeta.getDouble("ThresholdMaxDrill");			
				if (dTreshCheck == 0 && dDiameter<U(200))
					bAddAsDrill = true;	
			}
			
			if((dThresholdDrill >dEps && (abs(dDiameter-dThresholdDrill)<dEps) || dDiameter<dThresholdDrill) || !bThrough)
				bAddAsDrill=true;
			String subType = drill.toolSubType();

			if (bDebug)
			{
				reportMessage("\nadd as drill conditions\n	dThresholdDrill="+dThresholdDrill +
					"\n	dDiameter="+dDiameter + "\n	vecZDrill.isPerpendicularTo(vzSip)="+vecZDrill.isPerpendicularTo(vzSip) +
					"\n	isThrough=" + drill.bThrough() + "\n ---> add as drill = " + bAddAsDrill );
			}	
			Point3d ptStart = drill.ptStart()-vecZDrill*dDiameter;
			Point3d ptEnd = drill.ptEndExtreme();
			
			if(bAddAsDrill)
			{
				if (drill.bThrough())	ptEnd.transformBy(vecZDrill*dDiameter);
				Drill dr(ptStart, ptEnd, dDiameter/2);
				int c = 5;
				
				if (bConversionAccepted || bDebug)
				{
					Point3d ptCen = sip.ptCentreOfGravity();
				// try to convert perpendicular drills to tsl entities
					double d = vecZDrill.dotProduct(vzSip);				
					if (subType!=_kADPerpendicular || vecZDrill.isPerpendicularTo(vzSip))
					{ 
					// distiguish if start point is on edge face
						double dDistToFace = vzSip.dotProduct(drill.ptStart() - ptCen);
						int nFace;
						if (dDistToFace>=.5 * sip.dH()-dEps)
							nFace=1;
						else if (abs(dDistToFace)<.5 * sip.dH()-dEps)
							nFace=2;
						c = 4+nFace;
						double depth = (bThrough ? 0 : abs(vecZDrill.dotProduct(drill.ptStartExtreme() - drill.ptEndExtreme())));
						drill.ptStart().vis(c);
						//drill.ptEndExtreme().vis(2);
	
					// create TSL
						TslInst tslNew;				Vector3d vecXTsl= vxSip;			Vector3d vecYTsl= vySip;
						GenBeam gbsTsl[] = {sip};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {drill.ptStart(), drill.ptEndExtreme()};
						int nProps[]={};			
						double dProps[]={dDiameter,depth,0,0,0,0,0,0,0, 0};	
						String sFaces[] = { T("|Reference Face|"), T("|Top Face|"), T("|Edge|")};
						// Face, SnapToAxis, Format
						String sProps[]={sFaces[nFace], sNoYes.first(),""};
						Map mapTsl;	
									
						if (!bDebug)
						{
							//if (i >30)break;
							if (i%10==0)reportNotice(TN("...|creating individual tools| ") + i+"/"+nNumDrill);
							tslNew.dbCreate("hsbCLT-Drill" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
							
						}
						else
						{ 
							Body bd(drill.ptStart(), drill.ptEndExtreme(), dDiameter * .5);
							bd.vis(i);
						}
	
						
						//sip.addToolStatic(dr);				
					}
	
					//if (vecZDrill.isParallelTo(vzSip) || (d!=0 && abs(d)-1<.1*dEps) ) // catch tolerance
					else if ((d!=0 && abs(d)-1<.1*dEps) ) // catch tolerance
					{
						c = 6;
						ptsDrill.append(drill.ptStart());
						vecDrills.append(d>0?vzSip:-vzSip);
						dDrillDiameters.append(dDiameter);
						dDrillDepths.append(drill.dDepth());
					}
	
				}
				else
					sip.addTool(dr);
				//dr.cuttingBody().vis(c);	
			}
		// the diameter is above the threshold value
			else
			{
				PLine pl;
				pl.createCircle(ptStart, vecZDrill, dDiameter/2);
				//pl.vis(1);
				sip.addOpening(pl,false);
			}
			
		}// next i drill		
	}
	
// order drills by depth ascending
	for (int i=0;i<dDrillDepths.length();i++) 
		for (int j=0;j<dDrillDepths.length()-1;j++) 
			if (dDrillDepths[j]>dDrillDepths[j+1])
			{ 
				dDrillDepths.swap(j,j+1);
				vecDrills.swap(j,j+1);
				dDrillDiameters.swap(j,j+1);
				ptsDrill.swap(j,j+1);	
			}


// try to find a corresponding sink hole			
	double dSink1Diams[ptsDrill.length()];
	double dSink1Depths[ptsDrill.length()];
	double dSink2Diams[ptsDrill.length()];
	double dSink2Depths[ptsDrill.length()];
	
	for (int i=ptsDrill.length()-1; i>0 ; i--) 
	{ 
		double& dDiameter1 = dDrillDiameters[i];
		double& dDepth1 = dDrillDepths[i];
		Vector3d& vecZDrill1= vecDrills[i];
		Point3d& pt1 = ptsDrill[i];
		int bThrough = dZSip <= dDepth1;
		if (dSink1Diams[i] <0) continue; // negative means the drill was appended as sink
		for (int j=i-1; j>=0 ; j--)
		{ 
			double& dDiameter2 = dDrillDiameters[j];
			if (abs(dDiameter1 - dDiameter2) < dEps)continue; // skip same diam
			
			Vector3d& vecZDrill2= vecDrills[j];
			int bIsCodirectional = vecZDrill1.isCodirectionalTo(vecZDrill2);
			if (!bThrough && !bIsCodirectional)continue; // if first drill is not through or same z dir
			
			Point3d& pt2 = ptsDrill[j];
			if (abs(vxSip.dotProduct(pt1 - pt2)) > dEps && abs(vySip.dotProduct(pt1 - pt2)) > dEps)continue; // not at same location
		
		// attach
			dSink1Diams[j] = -1; // mark as used
			if (bIsCodirectional) // same side
			{
				dSink1Diams[i] = dDiameter2;
				dSink1Depths[i] = dDrillDepths[j];
			}
			else // opposite side
			{
				dSink2Diams[i] = dDiameter2;
				dSink2Depths[i] = dDrillDepths[j];
			}			
		}	
	}
	
// purge combined sink drills	
	for (int i=ptsDrill.length()-1; i>=0 ; i--) 
		if (dSink1Diams[i]<0)
		{ 
			dSink1Diams.removeAt(i);
			dSink1Depths.removeAt(i);
			dSink2Diams.removeAt(i);
			dSink2Depths.removeAt(i);
			dDrillDepths.removeAt(i);
			dDrillDiameters.removeAt(i);
			vecDrills.removeAt(i);
			ptsDrill.removeAt(i);
		}

	
// interprete solid drills and add them
	// filter potential drill solids by the amount of grips, remove very small solids
	if (bDebug)reportMessage("\nTest Drills by EntRef...");
	Entity entDrills[0], ents[0];
	ents = _Entity;
	Body bdDrills[0]; // to cache the solid of the drill ents
	for (int i=ents.length()-1;i>=0;i--)
	{
		Body bd = ents[i].realBody();
		if (bd.volume()<pow(U(1),3))
		{
			ents.removeAt(i);		
			continue;
		}	
		if (ents[i].gripPoints().length()==2)
		{			
			if (bConvertDrills)
			{
				entDrills.append(ents[i]);
				bdDrills.append(bd);
			}
			ents.removeAt(i);
		}	
	}	
	if (bDebug)reportMessage(entDrills.length() + " collected");
	
// get coordSys of drill, snap to surface
	for(int i=0;i<entDrills.length();i++)
	{
		Entity ent = entDrills[i];
		Point3d pts[] = lnZ.orderPoints(ent.gripPoints());
		if (pts.length()<2)continue;
	// start and end point of drill
		Point3d ptStart=pts[0], ptEnd=pts[1];
		
	// coordSys of drill	
		Vector3d vecZDrill = ptEnd-ptStart;
		vecZDrill.normalize();
		
		Vector3d vecXDrill = vx;
		if (vecZDrill.isPerpendicularTo(vzSip))	vecXDrill= vzSip;
		Line ln(ptStart,vecZDrill);
		
	// get diameter
		PlaneProfile pp = bdDrills[i].shadowProfile(Plane(pts[0],vecZDrill));
		LineSeg seg = pp.extentInDir(vecXDrill);
		//pp.vis(3);
		
		double dDiameter = abs(vecXDrill.dotProduct(seg.ptStart()-seg.ptEnd()));
		dDiameter =round(dDiameter+dEps);
	// declare and get default depth
		double dDepth = vecZDrill.dotProduct(ptEnd-ptStart);
		int bAddAsDrill = true;
		
	// for sloped and perp drills the start point will be projected to its closest surface
		if (!vecZDrill.isPerpendicularTo(vzSip))
		{
		// project start point to the surface of the panel
			Point3d ptFaceRef = ln.intersect(pnFaceRef,0);	//ptFaceRef .vis(8);
			Point3d ptFaceOpp = ln.intersect(pnFaceOpp,0);	//ptFaceOpp .vis(8);		
			double dFaceRef = vecZDrill.dotProduct(ptStart-ptFaceRef);
			double dFaceOpp = vecZDrill.dotProduct(ptStart-ptFaceOpp);
			
			if (abs(dFaceOpp)<abs(dFaceRef) || dFaceRef>dEps)
			{
				vecZDrill*=-1;
				if (vecZDrill.dotProduct(ptStart-ptFaceOpp)>dEps)
					ptEnd = ptStart;			
				ptStart = ptFaceOpp;
				//vecZDrill.vis(ptStart,222); ptEnd.vis(6);
			}
			else
			{
				ptStart = ptFaceRef;
			// set end point to the surface of the panel if it is outside of cutting solid			
				if (vecZDrill.dotProduct(ptEnd-ptFaceOpp)>dEps)
					ptEnd=ptFaceOpp;				
				//vecZDrill.vis(ptStart,3);
			}
				
		// sloped drills: make sure the start point is far out
			if (!vecZDrill.isParallelTo(vzSip))	
				ptStart.transformBy(-vecZDrill*dDiameter);					

			//ptStart.vis(1);			ptEnd.vis(2);
			
		// set depth 
			dDepth = abs(vecZDrill.dotProduct(ptStart-ptEnd));
			
		// test against threshold	and flag it
			if (vecZDrill.isParallelTo(vzSip) && abs(dDepth-dZSip)<dEps && (dThresholdDrill>dEps && dDiameter>dThresholdDrill))
				bAddAsDrill= false;
			if (bDebug)reportMessage("\n	sloped or perp. drill detected");
		}
	// edge drills	
		else
		{
		// find ptStartExtreme by intersection with envelope body
			double dLMax = qdr.dD(vecZDrill);	
			Body bdInt(ptStart-vecZDrill*2*dLMax , ptEnd+vecZDrill*2*dLMax, dDiameter/2);
			bdInt.intersectWith(bdEnvelope);
			//bdInt.vis(30);
			
		// get extremes
			Point3d pts[] = bdInt.extremeVertices(vecZDrill);
			if (pts.length()>0)
			{ 
				Point3d ptMid = (ptStart + ptEnd) / 2;
				double d1 = vecZDrill.dotProduct(pts[0] - ptMid);
				double d2 = vecZDrill.dotProduct(pts[pts.length()-1] - ptMid);
				
			// swap drill direction if required	
				if (abs(d2)<abs(d1))
				{ 
					ptEnd.transformBy(vecZDrill*vecZDrill.dotProduct(pts[pts.length()-1]-ptEnd));
					Point3d pt = ptStart;
					ptStart = ptEnd;
					ptEnd = pt;
					vecZDrill *= -1;
					
				}
				else
					ptStart.transformBy(vecZDrill*vecZDrill.dotProduct(pts[0]-ptStart));				
							}

			if (bDebug)reportMessage("\n	edge drill detected");
		}
	// add tool as drill
		int bDebugAddToolAsDrill=false;
		if (bAddAsDrill && dDepth>dEps)
		{
		// ensure drill points are not outside
			if (ppSip.pointInProfile(ptStart) == _kPointOutsideProfile && ppSip.pointInProfile(ptEnd) == _kPointOutsideProfile)continue;
			//vecZDrill.vis(ptStart, 1);
			Drill dr(ptStart , ptEnd, dDiameter/2);
			//dr.cuttingBody().vis(3);
			if (sip.bIsValid() && (bConversionAccepted || bDebugAddToolAsDrill))
			{
				ptsDrill.append(ptStart);
				vecDrills.append(vecZDrill);
				dDrillDiameters.append(dDiameter);
				dDrillDepths.append(dDepth);
				dSink1Diams.append(0);
				dSink2Diams.append(0);
				dSink1Depths.append(0);
				dSink2Depths.append(0);	
			}
			else if (sip.bIsValid())
				sip.addTool(dr);		
		}		
	// the diameter is above the threshold value, add as opening
		else if (!bAddAsDrill)
		{
			PLine pl;
			pl.createCircle(ptStart, vecZDrill, dDiameter/2);
			sip.addOpening(pl,true);
		}
		
		//vecZDrill.vis(pts[0],150);
		//pts[1].vis(2);				
	}// end looping drills
// add perpendicular drills as tsl, static or dynamic
	if (ptsDrill.length()>0)
	{
	// declare properties for cloning
		TslInst tslNew;
		Vector3d vUcsX = vx;
		Vector3d vUcsY = vy;
		GenBeam genBeams[]={sip};
		Entity entities[0];
		Point3d points[1];
		int propInts[0];
		
		// 0 diameter
		// 1 depth, 0 = complete through
		// 2 diameter sink top
		// 3 depth sink top
		// 4 diameter sink bottom
		// 5 depth sink bottom
		String propStrings[1];
		// 0 side:  sSides[] = {T("|Bottom|"),T("|Top|")};
		Map mapTsl;
		String sScriptname = "hsbPanelDrill";
		String sSides[] = {T("|Bottom|"),T("|Top|")};	
					
	// loop drills
		for (int i=0;i<ptsDrill.length();i++)
		{	
				double propDoubles[6];

				Vector3d vecZDrill = vecDrills[i];
				Point3d ptStart = ptsDrill[i];
				if(bDebug) reportMessage("\ntry to convert planar drills to tsl entities");
			// set properties				
				points[0] = ptStart;
				double& dDiameter = dDrillDiameters[i];
				propDoubles[0] = dDiameter;
				double& dDepth = dDrillDepths[i];
				if (abs(dDepth-sip.dH())>dEps)
					propDoubles[1] = dDepth;
				
				propDoubles[2] = dSink1Diams[i];
				propDoubles[3] = dSink1Depths[i];
				propDoubles[4] = dSink2Diams[i];
				propDoubles[5] = dSink2Depths[i];
				
				// side
				if (vecZDrill.isCodirectionalTo(vzSip))
					propStrings[0] = sSides[0];
				else
					propStrings[0] = sSides[1];
					
				// create	
				tslNew.dbCreate(sScriptname, vUcsX,vUcsY,genBeams, entities, points, 
					propInts, propDoubles, propStrings,_kModelSpace, mapTsl); // create new instance		
				if (!tslNew.bIsValid())
				{
					Drill dr(ptStart, ptStart+vecZDrill*dDepth, dDiameter/2);
					sip.addToolStatic(dr);
				}
		}// next i drill
	}
	
	if (bConversionAccepted && nNumDrill>0)reportNotice("\n"+scriptName() + T(": |Drill creation completed|"));
	
	
	
// END IF add perpendicular drills as tsl, static or dynamic


// conversion accepted
	if (bConversionAccepted) 
	{	
		setExecutionLoops(0);// force not be executed again
		if (!bIsBeam)bm.dbErase();

	// set potential meta data posnum
		if (mapMeta.length()>0 && sip.bIsValid())
		{
		// posnum assignment
			if (mapMeta.hasInt("PosNum"))
			{
				int nPosRequested =mapMeta.getInt("PosNum");
				int nPos=-1;
				reportMessage("\n	" + sip.handle() + " has pos before " + sip.posnum() + " requested is " + nPosRequested );
				if (nPosRequested >0)
				{
					sip.releasePosnum(true);
					nPos = sip.assignPosnum(nPosRequested);
					reportMessage("\n	" + sip.handle() + " has pos after " + sip.posnum());	
					
					if (nPos!=nPosRequested)
					{
						sip.releasePosnum(true);
						int nPosX = sip.assignPosnum(nPosRequested+1000);
						sip.setSubLabel2(nPosRequested);	
					}	
					reportMessage("\n	" + sip.handle() + "IO has received pos num " + sip.posnum());	
				}
				reportMessage("\n	" + sip.handle()+": The meta data send the req pos: " + nPosRequested);
				reportMessage("\n	pos/posreq"+nPos+"/" + nPosRequested);
			}	
			
			if (mapMeta.hasString("PostProcessing"))
			{
			// purge special beamcuts
				Map mapIO;
				mapIO.setEntity("gb",sip);
				mapIO.setInt("replaceTools",true);
				TslInst().callMapIO(mapMeta.getString("PostProcessing"), mapIO);
			}	
		}	
	
	// erase potential bodyImporter
		Entity entBodyImporter = _Map.getEntity("bodyImporter");
		if (entBodyImporter.bIsValid())
			entBodyImporter.dbErase();
		eraseInstance();
		return;	
	}	
	dp.draw(sStyleSelected, _Pt0, _XW,_YW,1,3,_kDeviceX);
	dp.draw(ppFaceRef);
	
// display log 
	for (int i=0;i<sLogMsgs.length();i++)
	{
		dp.draw(sLogMsgs[i],_Pt0,vxSip,vySip,0,-3*i,_kDeviceX);	
		
	}
	if (_Sip.length()<1)
		return;	
	
// grain symbol
	dp.color(1);
	Vector3d vxGrain = vx;
	if (sip.bIsValid())vxGrain = sip.woodGrainDirection();
	Vector3d vyGrain = vxGrain.crossProduct(-vzSip);
	Point3d ptGrain = _Pt0;
	PLine plGrain(vzSip);	
	double dLL = U(200);
	plGrain.addVertex(ptGrain +  (vxGrain*.5*dLL - vyGrain*dLL/5));
	plGrain.addVertex(ptGrain +  (vxGrain*dLL));	
	plGrain.addVertex(ptGrain + (-vxGrain*dLL));	
	plGrain.addVertex(ptGrain + (-vxGrain*.5*dLL + vyGrain*dLL/5));
	//plGrain.vis(2);
	dp.draw(plGrain);
	
// show potential differences in debug
	if (bDebug && sip.bIsValid())
	{
	// add create group trigger
		String sTriggerCreateGroup = T("|Create Group from Text|");
		addRecalcTrigger(_kContext,sTriggerCreateGroup );			
		if (_bOnRecalc &&  _kExecuteKey==sTriggerCreateGroup) 
		{	
			PrEntity	ssE(T("|Select text|"), Entity());
			Entity ents[0];
			if (ssE.go())
				ents = ssE.set(); 	
			if (ents.length()>0)
			{		
				Entity ent = ents[0];	
				ent.attachPropSet("hsbText");
				Map map = ent.getAttachedPropSetMap("hsbText");	
				String sTxt = map.getString("Text");
				Group groups[] = sip.groups();
				for (int g=0;g<groups.length();g++)
				{
					if (groups[g].namePart(1)!="")
					{
						Group grNew(groups[g].namePart(0)+"\\"+groups[g].namePart(1)+"\\"+sTxt);
						if (!grNew.bExists())	
							grNew.dbCreate();
					// assign sip to group
						grNew.addEntity(sip,true,0,'Z' );
					// assign solid and solid tools to group
						grNew.addEntity(entSolid,true,0,'C' );
						for(int i=0;i<entDrills.length();i++)
							grNew.addEntity(entDrills[i],true,0,'C' );
					// assign TSL, Text and dummy beam
						grNew.addEntity(_ThisInst,true,0,'T' );
						grNew.addEntity(ent,true,0,'I' );
						if (bm.bIsValid())grNew.addEntity(bm,true,0,'D' );
					}	
				}
			}	
		}	
	// assign the sip to the same group as tsl	
		else
		{
			sip.assignToGroups(_ThisInst);
				
		}					
		
		
		Body bdSource = bdSolid;
		Body bdTarget = sip.realBody();
		Body bdST, bdTS;
		bdST= bdSource;
		bdST.subPart(bdTarget );
		bdTS= bdTarget ;
		bdTS.subPart(bdSource);
		
		Vector3d vecOffset =vz *sip.dH()*5;
		
		if (0 && bDebug)
		{
			bdSource.transformBy(.5*vecOffset);
			bdSource.vis(2);
			bdSource.transformBy(.5*vecOffset);
			bdSource.vis(2);
			bdTS.transformBy(vecOffset);
			bdTS.vis(12);
			bdTS.transformBy(.5*vecOffset);
			bdTS.vis(1);
	
			bdTarget .transformBy(2*vecOffset);
			bdTarget .vis(3);		
			bdST.transformBy(2*vecOffset);
		}
		//bdST.vis(40);	
		
	}
			






#End
#BeginThumbnail
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
/;V4$+;=T<:J<58HH`__9
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
        <int nm="BreakPoint" vl="2064" />
        <int nm="BreakPoint" vl="1944" />
        <int nm="BreakPoint" vl="1609" />
        <int nm="BreakPoint" vl="1232" />
        <int nm="BreakPoint" vl="2557" />
        <int nm="BreakPoint" vl="2354" />
        <int nm="BreakPoint" vl="1588" />
        <int nm="BreakPoint" vl="1560" />
        <int nm="BreakPoint" vl="2519" />
        <int nm="BreakPoint" vl="2705" />
        <int nm="BreakPoint" vl="2673" />
        <int nm="BreakPoint" vl="2918" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16642 bugfix converting seatcuts" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="11/23/2022 2:41:55 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14486 bugfix when converting combination of risingSeatCut and japanesHipCut liek a doublecut" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="2/23/2022 11:37:54 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11073 bugfix when converting a combination of  a risingSeatCut and a valleyBirdsmouth like a doublecut" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="10/21/2021 3:43:40 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-6753 the solid to panel conversion supports now freeprofiles to be translated into arc segments" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="2/3/2021 3:13:47 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End