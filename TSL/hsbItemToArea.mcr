#Version 8
#BeginDescription
<version 1.0> 
Initial Version  date="31mar2020" author="david.delombaerde@hsbcad.com" 
</version>

This tsl creates articles on entities area.

In the first dialog select a Major-Minor group and press "OK". The second time the dialog appaers you can select which article you need.
After that you can select all the enities and openings you wish to add an article to. 

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
//region History
/// <History>	
/// 	version 1.0 - 31 march 2020:  Initial version			
/// </History>

/// <insert Lang=en>
///  In first dialog select a Major-Minor group and press "OK". The second time the dialog appaers you can select which article you need.
///  After that you can select all the enities and openings you wish to add an article to. 
/// </insert>

/// <summary Lang=en>
/// This tsl creates articles on entities.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbItemToArea")) TSLCONTENT
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
	String category = T("|Groups|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
//end constants//endregion

//region Settings

// Settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="hsbItemToArea";
	
	Map mapSetting;
	Map mapArticles = _Map.getMap("Articles[]");
	Map mapOut;
	
// Find settings file
	String sFolders[]=getFoldersInFolder(sPath); 
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";
	String sFile=findFile(sFullPath);	
	
	if(sFile.length() < 1)
		sFile = findFile(_kPathHsbInstall + "\\Content\\General\\Tsl\\" + sFolder + "\\" + sFileName + ".xml");

// Read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// Create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() && sFile.length()>0)
	{
		mapSetting.readFromXmlFile(sFile);
		mo.dbCreate(mapSetting);
	}	
	
	// Validate
	if(mapSetting.length()<1)
	{ 
		reportMessage(TN("|Wrong definition of the xml file 1001|."));
		eraseInstance();
		return;	
	}
		
//End Settings//endregion

//region Get Major Settings from the mapSetting
	
	String sMajorNames[0];
	String sArticles[0];
	String sIDs[0];
	String k;
	
	Map m, mapMajors = mapSetting.getMap("Majors[]");
	for(int i = 0 ; i < mapMajors.length(); i++)
	{ 
		Map m = mapMajors.getMap(i);		
		String name;
		int index, bOk = true;
		k = "Name"; 	if (m.hasString(k))	name = m.getString(k);		else bOk = false;
		
		if(bOk && sMajorNames.find(name) < 0)		
			sMajorNames.append(name);		
	}
	
	if(!mapArticles.length() < 1)
	{ 
		for (int i = 0 ; i < mapArticles.length() ; i ++)
		{ 
			Map m= mapArticles.getMap(i);
			String s = m.getString("Description");
			if (sArticles.find(s)<0)
			{
				sArticles.append(s);
				sIDs.append(i);
			}	 
		}
	}
	
//End Get Major Settings from the mapSetting//endregion 

//region Retrieve Area, NetArea, Perimeter from map
	
	double dArea = 		_Map.getDouble("Area");
	double dNetArea =		_Map.getDouble("NetArea");
	double dPerimeter = 	_Map.getDouble("Perimeter");
	
	double dFactor = 1000000;
	String sUnit = "m2";
	
//End Retrieve Area, NetArea, Perimeter from map//endregion 

//region Properties
			
	String sMajorName=T("|Major - Minor group|");	
	PropString sMajor(0, sMajorNames, sMajorName);	
	sMajor.setDescription(T("|Defines a Major - Minor group|"));
	sMajor.setCategory(category);
	
	String sArticleName=T("|Article|");
	PropString sArticle(1, sArticles, sArticleName);	
		
	sArticle.setDescription(T("|Define Article|" + "\n"
							+ T("|Properties|:") + "\n"
							+ T("|Area|	=	")	+dArea / dFactor + sUnit + "\n"
							+ T("|NetArea|	=	")+dNetArea / dFactor +sUnit + "\n"
							+ T("|Perimeter| =	")+dPerimeter ));
							
	sArticle.setCategory(category);
	sArticle.setReadOnly(true);
	
//End Properties//endregion 

//region bOnInsert
		
	if(_bOnInsert)
	{	
		//region Setup bOnInsert
				
			if (insertCycleCount()>1) { eraseInstance(); return; }
								
			String sKey = _kExecuteKey;
			sKey.makeUpper();
			int bCatalogFound = false;
			
			if (sKey.length()>0)
			{
				String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
				for(int i=0;i<sEntries.length();i++)
					sEntries[i] = sEntries[i].makeUpper();	
				if (sEntries.find(sKey)>-1)
				{ 
					setPropValuesFromCatalog(sKey);
					
					if(sArticle == "")	
						bCatalogFound = false;
					else
						bCatalogFound = true;		
				}
				else
					setPropValuesFromCatalog(sLastInserted);					
			}	
			else		
			{ 	
				sArticle.set("");
				showDialog("---");	
			}
				
			// Set properties readonly state
			sMajor.setReadOnly(true);
			sArticle.setReadOnly(false);
		
		//End Setup bOnInsert//endregion 		
				
		//region Set up .net function
		
			// Set 'dll' path 
			sPath = _kPathHsbInstall + "\\Utilities\\hsbLooseMaterials\\hsbLooseMaterialsUI.dll";
			String sFind = findFile(sPath);
			
			// Validate if 'dll' is found at location.
			if(sFind == "")
			{ 
				reportNotice("\n" + TN("|The 'hsbLooseMaterialsUI.dll' was not found, please contact your local support team|."));
				eraseInstance();
				return;
			}
			
			String strType = "hsbCad.LooseMaterials.UI.MapTransaction";
			String strFunction = "GetItems";
			
			String strSplit[] = sMajor.tokenize("-");
			String major;
			String minor;
	
			for(int i = 0; i < strSplit.length() ; i ++)
			{ 
				if(i == 0)
					major = strSplit[i];
				else
					minor = strSplit[i];
			}
			
			Map mapIn;
			mapIn.setString("MajorGroupName", major);
			mapIn.setString("MinorGroupName", minor);
			
			mapOut = callDotNetFunction2(sPath, strType, strFunction, mapIn);		
		
		//End Set up .net function//endregion 
		
		//region Read-Out Inventory
		
			// Articles found in .net function
			mapArticles = mapOut.getMap("Item[]");
			
			// Iterate through articles found and get there description.
			for (int i=0;i<mapArticles.length();i++) 
			{ 
				Map m= mapArticles.getMap(i);
				String s = m.getString("Description");
				if (sArticles.find(s)<0)
				{
					sArticles.append(s);
					sIDs.append(i);
				}	 
			}			
						
			if (!bCatalogFound)
			{ 
				// Set found articles to property value.
				if(sArticles.length() > 0)
				{ 
					sArticle = PropString(1, sArticles, sArticleName);
				}
				else
				{
					reportMessage(TN("|No articles defined in the inventory|."));
					eraseInstance();
					return;
				}
				
				showDialog("---");
			}
					
		//End Read-Out Inventory//endregion 
			
		//region Get Allowed Classes from selected Major-Minor
				
			Map m, mapMajors = mapSetting.getMap("Majors[]");				
			String mAllowedClasses[0];
			String k;
					
			for(int i = 0 ; i < mapMajors.length(); i ++)
			{		
				Map m = mapMajors.getMap(i);
				String name;
				int index, bOk = true;
				
				k = "Name";		 if (m.hasString(k))	name = m.getString(k);		else bOk = false;
				
				if (name == sMajor)
				{ 
					Map a, mapAllowedClasses = m.getMap("AllowedClass[]");								
					for(int j = 0 ; j < mapAllowedClasses.length(); j ++)
					{ 
						a = mapAllowedClasses.getMap(j);
						k = "Name"; if(a.hasString(k))	name = a.getString(k); else bOk = false;
						
						if (bOk && mAllowedClasses.find(name) < 0)
							mAllowedClasses.append(name);
					}
				}
			}
			
		//End Get Allowed Classes from selected Major-Minor//endregion 
		
		//region Setup PrEntity
			
			//int bPlEntity = false;
			
			// Concatenate Prompt message with allowed classes
			String prM = T("|Select a set of| ");
			for (int i = 0 ; i < mAllowedClasses.length() ; i ++)
			{ 
				if (i == 0)
					prM += mAllowedClasses[i];
				else
					prM += " or " + mAllowedClasses[i];
			}
	
			// prompt for entities
			Entity ents[0];
			PrEntity ssE(T(prM), Entity());			
			int bNewDefinition = false;
			
			//region Set Allowed Classes
					
				 if(mAllowedClasses.findNoCase("Entity",-1)< 0)
		    			bNewDefinition = true;   		
		    		    			
		    		if(mAllowedClasses.findNoCase("EntPline", -1) >-1)
		    		{ 	
		    			//bPlEntity = true;
		    			if (bNewDefinition == true)
		    			{ 		
		    			  	ssE = PrEntity(T(prM), EntPLine());
		    				bNewDefinition = false;
		    			}			
		    			else
		    			{ 
		    				ssE.addAllowedClass(EntPLine());		
		    			}
		    		}
		    		
		    		if(mAllowedClasses.findNoCase("Circle",-1)>-1)
		    		{ 
		    			if (bNewDefinition == true)
		    			{ 		
		    			  	ssE = PrEntity(T(prM), Entity());
		    				bNewDefinition = false;
		    			}			
		    			else
		    			{ 
		    				ssE.addAllowedClass(Entity());		
		    			}
		    		}
		    		
		    		if(mAllowedClasses.findNoCase("ERoofPlane", -1) >-1)
		    		{ 
		    			if (bNewDefinition == true)
		    			{ 
		    				 ssE = PrEntity(T(prM), ERoofPlane());
		    				bNewDefinition = false;			
		    			}			
		    			else
		    			{ 
		    				reportMessage(TN("|hierdoor|"));
		    				
		    				ssE.addAllowedClass(ERoofPlane());		
		    			}
		    		}
		    		
		    		if(mAllowedClasses.findNoCase("Sip", -1) >-1)
		    		{ 
		    			if (bNewDefinition == true)
		    			{ 
		    				 ssE = PrEntity(T(prM), Sip());
		    				bNewDefinition = false;			
		    			}			
		    			else
		    			{ 
		    				ssE.addAllowedClass(Sip());		
		    			}
		    		}
		    		
		    		if(mAllowedClasses.findNoCase("Element", -1) >-1)
		    		{ 
		    			if (bNewDefinition == true)
		    			{ 
		    				ssE = PrEntity(T(prM), Element());
		    				bNewDefinition = false;			
		    			}			
		    			else
		    			{ 
		    				ssE.addAllowedClass(Element());		
		    			}
		    		}
		    		
				if(mAllowedClasses.findNoCase("Sheet", -1) >-1)
		    		{ 
		    			if (bNewDefinition == true)
		    			{ 
		    				ssE = PrEntity(T(prM), Sheet());
		    				bNewDefinition = false;			
		    			}			
		    			else
		    			{ 
		    				ssE.addAllowedClass(Sheet());		
		    			}
		    		}
		    		
		    		if(mAllowedClasses.findNoCase("Opening", -1) >-1)
		    		{ 
		    			if (bNewDefinition == true)
		    			{ 
		    				 ssE= PrEntity(T(prM), Opening());
		    				bNewDefinition = false;			
		    			}			
		    			else
		    			{ 
		    				ssE.addAllowedClass(Opening());		
		    			}
		    		}
			
			//End Set Allowed Classes//endregion 
						
			if (ssE.go())
				_Entity.append(ssE.set());
			
			
			
		//End Setup PrEntity//endregion 
		
		// create TSL
		TslInst tslNew;						Vector3d vecXTsl= _XW;					Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = { };				Entity entsTsl[0];	 entsTsl = _Entity;		Point3d ptsTsl[] = { _Pt0};
		int nProps[] = {};						double dProps[] ={};		 				String sProps[] = {sMajor, sArticle};
		Map mapTsl;	
		
		//mapTsl.setInt("Mode", 1);
		mapTsl.setMap("Articles[]", mapArticles);
				
		//if(bPlEntity == true)
		mapTsl.setInt("Mode", 0);
		
		tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);		
		
		eraseInstance();
		return;
			
	}	
	
//End bOnInsert//endregion

// Validate entity collection
if (_Entity.length() < 1)
{ 
	reportMessage(TN("|No allowed entities where found in the selection|."));
	eraseInstance();
	return;
}

//Mode:
// 	0 = Distribution mode
// 	2 = Instance mode
int nMode = _Map.getInt("Mode");
mapArticles = _Map.getMap("Articles[]");

if (nMode == 0)		 	// Distribution Mode
{			
	//region Validate
			
		// Only get EntPline or Circle entities
		Entity validEntities[0];
		int removeIndex[0];
		for (int i=0 ; i <_Entity.length() ;i++)
		{ 
		 	EntPLine ePl = (EntPLine)_Entity[i];	
			if (ePl.bIsValid())
			{ 
				validEntities.append(_Entity[i]);
			}		
			if(_Entity[i].typeDxfName().makeLower() == "circle")
			{ 
				validEntities.append(_Entity[i]);
			}		
		 }
		 	
	//End Validate//endregion 
	
	//region This part is only for the EntPLines and  Cicles
			
	// Order Entities on Area
	for (int i=0 ; i < validEntities.length() ;i++)
	{ 
		for(int j = i + 1 ; j < validEntities.length(); j ++)
		{ 
			// Compare area's of plines
			PLine plI = validEntities[i].getPLine();
			PLine plJ = validEntities[j].getPLine();
			
			if(plI.area() < plJ.area())
			{ 
				validEntities.swap(i, j);
			}
		}
	}					
	
	// Array that holds used PLines
	int usedEntities[0];
	
	// Group PLines that can be combines in Array
	for (int i = 0 ; i < validEntities.length() ; i ++)
	{ 
		int bSkipIndex = false;	
		for (int k = 0; k < usedEntities.length(); k ++)
		{
			if (i == usedEntities[k])
				bSkipIndex = true;
		}
		
		if (bSkipIndex == true) 
		{ 					
			continue;
		}
				
		usedEntities.append(i);
		
		// Create new array of entities
		Entity entities[0];		
		entities.append(validEntities[i]);
						
		// Set Entity Polyline
		PLine plI = validEntities[i].getPLine();		
		PLine tmpPl = plI;
		
		// Loop through the other entities and check if these
		// are incapsulated in the plI
		for (int j = i + 1 ; j < validEntities.length(); j ++ )
		{	
			// Set Entity Polyline
			PLine plJ = validEntities[j].getPLine();
						
			// Check if both plines are in the same plane
			if (plI.ptStart().Z() == plJ.ptStart().Z())			
			{ 
				// Create PlaneProfile of temporary Pline
				PlaneProfile ppFullArea(tmpPl);
				
				// Join plJ 
				ppFullArea.joinRing(plJ, true);	
				
				// If area of ppFullArea is smaller then area of
				// plI then these two polylines can be substracted
				if (round(ppFullArea.area()) < round(plI.area()))
				{ 
					entities.append(validEntities[j]);					
					usedEntities.append(j);					
				}
			}						
		}		
					
		// Check if there is already a TSL 'HsbItemToArea' attached to the Main Entity
		Entity ent = entities[0]; 
		TslInst instances[] = ent.tslInstAttached();	
		int bAlreadyCreated = false;
				
		if(instances.length() > 0)
		{ 
			for (int j=0;j<instances.length();j++) 
			{ 
				TslInst inst = instances[j]; 
				if (inst.scriptName() == scriptName() && inst != _ThisInst)
				{ 
					bAlreadyCreated = true;
				} 
			}//next j	
		}
		
		// After grouping the PLines create new tsl for this group
		// create TSL if tsl is not already created
		if (bAlreadyCreated == false)
		{ 
			TslInst tslNew;				Vector3d vecXTsl= _XW;					Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = { };		Entity entsTsl[0];	 entsTsl = entities;		Point3d ptsTsl[] = { };
			int nProps[]={}; 				double dProps[] ={ };					String sProps[] = {sMajor, sArticle};
			Map mapTsl;			
				
			mapTsl.setInt("Mode", 2);
			mapTsl.setMap("Articles[]", mapArticles);
			mapTsl.setDouble("Area", dArea);
			mapTsl.setDouble("NetArea", dNetArea);
			mapTsl.setDouble("Perimeter", dPerimeter);
			//mapTsl.setInt("Set", bSet);
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);		
		}
	}
	
	//End This part is only for the EntPLines and  Cicles//endregion 
	
	//region This is for the other Entities
		
	for (int i = 0 ; i < _Entity.length() ; i ++)
	{ 	
		Entity entities[0];
		int bSkipIndex = false;
		EntPLine ePl = (EntPLine)_Entity[i];	
		if (ePl.bIsValid())
		{ 
			bSkipIndex = true;
		}
		
		// Casting Circles
		if(_Entity[i].typeDxfName().makeLower() == "circle")
		{ 
			bSkipIndex = true;
		}		
		
		if(!bSkipIndex)
			entities.append(_Entity[i]);
		
		if(entities.length() < 1)
			continue;
		
		// Check if there is already a TSL 'HsbItemToArea' attached to the Main Entity
		Entity ent = entities[0]; 
		TslInst instances[] = ent.tslInstAttached();	
		int tslAlreadyCreated = false;
		
		if(instances.length() > 0)
		{ 
			for (int j=0;j<instances.length();j++) 
			{ 
				TslInst inst = instances[j]; 
				
				if (inst.scriptName() == _ThisInst.scriptName() && inst != _ThisInst)
				{ 
					tslAlreadyCreated = true;
				} 
			}//next j	
		}
		
		// After grouping the PLines create new tsl for this group
		if (tslAlreadyCreated == false)
		{ 
			TslInst tslNew;				Vector3d vecXTsl= _XW;					Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};		Entity entsTsl[0];	 entsTsl =entities;		Point3d ptsTsl[] = {};
			int nProps[]={} ; 				double dProps[] ={ };					String sProps[] = {sMajor, sArticle};
			Map mapTsl;			
				
			mapTsl.setInt("Mode", 2);
			mapTsl.setMap("Articles[]", mapArticles);
			mapTsl.setDouble("Area", dArea);
			mapTsl.setDouble("NetArea", dNetArea);
			mapTsl.setDouble("Perimeter", dPerimeter);
			// mapTsl.setInt("Set", bSet);
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
		}	
	}
	
	
	//End This is for the other Entities//endregion 
		
	eraseInstance();
	return;
}
else if (nMode == 2) 	// Instance Mode
{				
	//region Basic Settings
		
		// Set dependency on firs entity in array
		// other enities are openings.
		setDependencyOnEntity(_Entity[0]);
		
		// Set major-minor property read only true
		sMajor.setReadOnly(true);
		// Set article property read only false
		sArticle.setReadOnly(false);
		
		//region Setup Text
			
		int nc = 40;
		double dMarkSize = 5;
		Display dpText(nc);
		String sDimStyle = _DimStyles.first();
			
		double textHeight = dpText.textHeightForStyle("O", sDimStyle);
		{
			String k;
			Map mapDisplay = mapSetting.getMap("Display");
			Map m = mapDisplay;
			k = "Color";				if(m.hasInt(k)) nc = m.getInt(k);
			k = "DimStyle";			if (m.hasString(k) && _DimStyles.findNoCase(m.getString(k) ,- 1) >- 1)	sDimStyle = m.getString(k);
			k = "TextHeight";		if (m.hasDouble(k)) 	textHeight = m.getDouble(k);
			k = "MarkSize";			if(m.hasDouble(k)) dMarkSize = m.getDouble(k);
		}
			
		dpText.dimStyle(sDimStyle);
		dpText.textHeight(textHeight);
		dpText.color(nc);
		
		//End Setup Text//endregion 
	
	//End Basic Settings//endregion 
	
	//region Casting Entity[0]
		
		PLine pl;
		
		//region PlaneProfile all entities
			
			PlaneProfile ppFullArea(pl);
			for (int i = 1; i < _Entity.length(); i ++)
			{
				PLine pl = _Entity[i].getPLine();
				setDependencyOnEntity(_Entity[i]);
				ppFullArea.joinRing(pl, true);
			}
		
		//End PlaneProfile all entities//endregion 
		
		//region Casting
		
			EntPLine ePl = (EntPLine)_Entity[0];
			ERoofPlane roof = (ERoofPlane)_Entity[0];
			Sip sp = (Sip)_Entity[0];
			Element el = (Element)_Entity[0];
			Sheet sh = (Sheet)_Entity[0];
			Opening op = (Opening)_Entity[0];	
		
		//End Casting//endregion 
								
		//region Set PLine
		
			CoordSys csEnt(pl.coordSys());
			if (ePl.bIsValid()) 											//	Check if EntPline is valid cast
			{
				pl = ePl.getPLine();				
			}
			else if (_Entity[0].typeDxfName().makeLower() == "circle") 	//	Check if Circle is valid cast
			{
				pl = _Entity[0].getPLine();	
				pl.convertToLineApprox(U(10));
			}
			if (roof.bIsValid())											//	Check if ERoofplane is valid cast
			{
				pl = roof.plEnvelope();		
				csEnt = roof.coordSys();
			}
			else if (sp.bIsValid())											//	Check if Sip is valid cast
			{
				pl = sp.plEnvelope();	 	
			}
			else if (el.bIsValid())											//	Check if Element is valid cast
			{
				pl = el.plEnvelope();			
			}
			else if (sh.bIsValid())											//	Check if Element is valid cast
			{
				pl = sh.plEnvelope();		
			}
			else if (op.bIsValid())										//	Check if Opening is valid cast
			{
				pl = op.plShape();			
			}
		
		//End Set PLine//endregion 
				
		if (_bOnDbCreated)
		{ 
			Point3d pts[] = pl.vertexPoints(true);
			Point3d pt; pt.setToAverage(pts);
			pt.vis(2);
			pts = Line(_Pt0, _XW).orderPoints(pts);
			if (pts.length()>0)
			{ 
				pts.last().vis(6);
				pt += _XW * (_XW.dotProduct(pts.last() - pt) + U(50));
				pt += _ZW * _ZW.dotProduct(pts.last() - pt);
				pt.vis(1);
			}
			_Pt0 = pt;
		}	
				
	//End Casting Entity[0]//endregion 
	
	//region Guide Line
	
		PlaneProfile ppOffset(csEnt);
		ppOffset.joinRing(pl,_kAdd);
		ppOffset.shrink(U(100));
		
		if (ppOffset.area()<pow(dEps,2))
			ppOffset.joinRing(pl,_kAdd);	
			
		ppOffset.vis(3);	
	
		Point3d ptAvg; ptAvg.setToAverage(pl.vertexPoints(true));
		Vector3d vecDirGuide = _Pt0 - ptAvg;
		
		double dXFlag = 1;
		if (_XW.dotProduct(_Pt0 - ptAvg) < 0)dXFlag *= -1;
		
		vecDirGuide.normalize();
		vecDirGuide.vis(_Pt0, 1);
		Vector3d vecGuideN = vecDirGuide.crossProduct(_ZW).crossProduct(-_ZW);
		Point3d ptsGuide[0];
		ptsGuide.append(ppOffset.closestPointTo(_Pt0)-vecGuideN*U(50));
		ptsGuide.append(_Pt0 - dXFlag * _XW * (2*textHeight));
		ptsGuide.append(_Pt0);
		{ 
			PLine plGuide;
			for (int i=0;i<ptsGuide.length()-1;i++) 
			{ 
				LineSeg seg(ptsGuide[i],ptsGuide[i+1]); 
				dpText.draw(seg);
				 
			}//next i
		}
		
		PLine pl2(_XW);
		pl2.createCircle(ptsGuide.first(), _ZW, dMarkSize);
		PlaneProfile ppCircle(pl2);
	
		Hatch hatchSolid("SOLID", U(1));
		
		
	//End Guide Line//endregion 
	
	//region Get Articles and Select user choice
	
		sPath = _kPathHsbInstall + "\\Utilities\\hsbLooseMaterials\\hsbLooseMaterialsUI.dll";
		String strType = "hsbCad.LooseMaterials.UI.MapTransaction";
		String strFunction = "GetItems";
			
		String strSplit[] = sMajor.tokenize("-");
		String major;
		String minor;
			
		for (int i = 0; i < strSplit.length(); i ++)
		{
			if (i == 0)
				major = strSplit[i];
			else
				minor = strSplit[i];
		}
			
		Map mapIn;
		mapIn.setString("MajorGroupName", major);
		mapIn.setString("MinorGroupName", minor);
			
		mapOut = callDotNetFunction2(sPath, strType, strFunction, mapIn);
			
		// Articles found in .net function
		mapArticles = mapOut.getMap("Item[]");	
		String strSelectdArticle;
		Map mpSelectedArticle;		
		
		if (mapArticles.length() < 1)
		{ 
			Map m = _Map.getMap("Article");
			mpSelectedArticle = m;		
			strSelectdArticle = m.getString("Description");
			mapArticles = _Map.getMap("Articles[]");	
			sArticle.setReadOnly(true);
		}
		else
		{		
			// Iterate through articles found and get there description.
			for (int i = 0; i < mapArticles.length(); i++)
			{
				Map m = mapArticles.getMap(i);
				strSelectdArticle = m.getString("Description");
				if (strSelectdArticle == sArticle)
				{
					mpSelectedArticle = m;
					break;
				}
			}
		}
		
		dpText.draw(strSelectdArticle,_Pt0, _XW, _YW, dXFlag, 0, _kDevice);	
		dpText.draw(ppCircle, hatchSolid);
		
	//End Get Articles and Select user choice//endregion 
			
	//region Set description article with updated Area, NetArea, Perimeter
			
		dArea =pl.area();
		dPerimeter = pl.length();
		dNetArea = ppFullArea.area();
			
		_Map.setMap("Article", mpSelectedArticle);
		_Map.setInt("Mode", 2);
		_Map.setMap("Articles[]", mapArticles);
		_Map.setDouble("Area", dArea);
		_Map.setDouble("NetArea", dNetArea);
		_Map.setDouble("Perimeter", dPerimeter);
		_Map.setPoint3d("Pt0", _Pt0);
				
		// Set description Article with updated Area, NetArea, Perimeter
		sArticle.setDescription(T("|Define Article|" + "\n"
								+ T("|Properties|:") + "\n"
								+ T("|Area|	=	")	+dArea / dFactor + sUnit + "\n"
								+ T("|NetArea|	=	")+dNetArea / dFactor +sUnit + "\n"
								+ T("|Perimeter| =	")+dPerimeter ));
	
	//End Set description article with updated Area, NetArea, Perimeter//endregion 
	
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="616" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End