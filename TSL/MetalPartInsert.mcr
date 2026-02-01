#Version 8
#BeginDescription
#Versions
Version 1.1 20.11.2024 HSB-22974 bugfix if no external style dwg found
Version 1.0 13.11.2024 HSB-22974 initial version of MetalPartInsert

This tsl creates MetalPartCollection entities and imports the selected style if not found in the current dwg
Requires at least one MetalPartCollection style in the current dwg or a style dwg in <company>\subassembly or <company>\assemblies


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.1 20.11.2024 HSB-22974 bugfix if no external style dwg found , Author Thorsten Huck
// 1.0 13.11.2024 HSB-22974 initial version of MetalPartInsert , Author Thorsten Huck

/// <insert Lang=en>
/// Select style and pich insertion points, Requires at least one style in the current dwg or a style dwg in <company>\subassembly or <company>\assemblies
/// </insert>

// <summary Lang=en>
// This tsl creates MetalPartCollection entities and imports the selected style if not found in the current dwg
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "MetalPartInsert")) TSLCONTENT
// optional commands of this tool
// this tsl does not provide any context commands
//endregion



//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String tDefault =T("|_Default|");
	String tLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};

	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";

//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	
	

//end Constants//endregion

//region Functions

//region ArrayToMapFunctions

	//region Function GetBodyArray
	// returns an array of bodies stored in map
	Body[] GetBodyArray(Map mapIn)
	{ 
		Body bodies[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasBody(i))
				bodies.append(mapIn.getBody(i));		
		return bodies;
	}//endregion

	//region Function SetBodyArray
	// sets an array of bodies in map
	Map SetBodyArray(Body bodies[], String key)
	{ 
		key = key.length() < 1 ? "body" : key;
		Map mapOut;
		for (int i=0;i<bodies.length();i++) 
			mapOut.appendBody(key, bodies[i]);	
		return mapOut;
	}//endregion

	//region Function GetIntArray
	// returns an array of doubles stored in map
	int[] GetIntArray(Map mapIn, int bSorted)
	{ 
		int values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasInt(i))
				values.append(mapIn.getInt(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetIntArray
	// sets an array of ints in map
	Map SetIntArray(int values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendInt(key, values[i]);	
		return mapOut;
	}//endregion
		
//End ArrayToMapFunctions //endregion 	 	





//region Function GetStyleDwgs
	// appends file paths of dwgs with MetalPartCollectionDef styles
	void GetStyleDwgs(String& filePaths[], String rootPath)
	{ 
	// Read files
		String files[] = getFilesInFolder(rootPath, "*.dwg");
		for (int i=0;i<files.length();i++) 
		{ 
			String fullPath = rootPath+"\\"+files[i]; 
			reportMessage(TN("|Reading| ")+fullPath);

			String styles[] = MetalPartCollectionDef().getAllEntryNamesFromDwg(fullPath);
			
			if (styles.length()>0)
			{
				filePaths.append(fullPath);
				reportMessage(T(", |styles found| (") + styles.length()+")");
			}
			else
			{
				reportMessage(T(", |no styles found|"));
			}
		}//next i
			
	// Read folders	
		String folders[] = getFoldersInFolder(rootPath);
		for (int i=0;i<folders.length();i++) 
		{ 
			String path = rootPath+"\\"+folders[i]; 
			GetStyleDwgs(filePaths, path);			
		}//next i

		return;
	}//endregion	
	
//region Function ShowDwgSelectionDialog
	// returns the fullPath of the selected style dwg
	String ShowDwgSelectionDialog(String sDwgPaths[])
	{ 

		Map mapItems;
		for (int i=0;i<sDwgPaths.length();i++) 
		{ 
			String fullPath = sDwgPaths[i];
			String tokens[] = fullPath.tokenize("\\");
			String fileName = tokens.length() > 0 ? tokens.last() : fullPath;
			Map mapItem;
			mapItem.setString("Text", fileName);
			mapItem.setString("ToolTip", fullPath);//__only Map entries can declare ToolTips
			//mapItem.setInt("IsSelected", 0);
			mapItems.appendMap("mp", mapItem);
		}//next i
	
		Map mapIn; 
		mapIn.setMap("Items[]", mapItems);
		mapIn.setString("Title", T("|Default Style Drawing|"));
		mapIn.setString("Prompt", T("|Select the file containing the default styles of metalparts|"));
		//__if this line is uncommented, it will override other entries and ensure the 3rd item is selected
		mapIn.setInt("SelectedIndex", 0);
		Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, listSelectorMethod, mapIn);

		int bCancel = mapOut.getInt("WasCancelled");
		int nSelected = mapOut.getInt("SelectedIndex");	
		
		String out = ! bCancel && nSelected >- 1 ?sDwgPaths[nSelected]: "";
		
		return out;
	}//endregion

//region Function ShowStyleSelectionDialog
	// returns the dialog results
	// nIndexSelectDwg: an integer indicating if the dwg selection dialog can be shown again: -1 = do not show option, else index of option to select dwg
	Map ShowStyleSelectionDialog(String styles[], int& nIndexSelectDwg, String info)
	{ 
		Map mapItems;
		for (int i=0;i<styles.length();i++) 
		{ 
			Map mapItem;
			mapItem.setString("Text", styles[i]);
			//mapItem.setString("ToolTip", "");//__only Map entries can declare ToolTips
			//mapItem.setInt("IsSelected", 0);
			mapItems.appendMap("mp", mapItem);
		}//next i
		
	// Append entry to select another style dwg				
		if (nIndexSelectDwg>-1)
		{ 
			Map mapItem;
			mapItem.setString("Text", T("<|Select Style Dwg|>"));
			mapItem.setString("ToolTip", T("|Shows the dialog to select another style dwg.|"));//__only Map entries can declare ToolTips
			//mapItem.setInt("IsSelected", 0);
			mapItems.appendMap("mp", mapItem);
			nIndexSelectDwg = styles.length();
		}

		Map mapIn; 
		mapIn.setMap("Items[]", mapItems);
		mapIn.setString("Title", T("|Style Selection|"));
		mapIn.setString("Prompt", T("|Select a metalpart style|")+info);
		Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, listSelectorMethod, mapIn);		
		return mapOut;
	}//endregion



//region Function ImportFromDwg
	// returns
	int ImportFromDwg(String fullPath, String style)
	{ 
		String err = MetalPartCollectionDef().importFromDwg(fullPath, style, true);
		if (err.length()>0)
		{
			reportMessage("\n" + style + T(": |import failed|, ") + err);
			return false;
		}	
		else
		{
			reportMessage("\n" + style + T(": |successfully imported from| ") + fullPath);
			return true;
		}
	}//endregion

//region Function GetSimpleBody
	// returns a simplified body of an entity
	Body GetSimpleBody(Entity ent)
	{ 
		Body bd;
		
		GenBeam gb = (GenBeam)ent;
		
		if (gb.bIsValid())
			bd = gb.envelopeBody(true, true);
		else
		{ 
			Quader q = ent.bodyExtents();
			if (q.dX()<=dEps || q.dY()<=dEps || q.dZ()<=dEps)
				bd = ent.realBody();
			else
				bd = Body(q.pointAt(0, 0, 0), q.vecX(), q.vecY(), q.vecZ(), q.dX(), q.dY(), q.dZ(), 0, 0, 0);
		}
		
		return bd;
	}//endregion

//region Function GetTextFlags
	// returns
	// t: the tslInstance to 
	void GetTextFlags(Vector3d vecDir, Vector3d vecRef, double& xFlag, double& yFlag)
	{ 
	    if(vecDir.isPerpendicularTo(vecRef))
	    	xFlag = 0;
	    else
	    	xFlag = vecDir.dotProduct(vecXView)<0?-1:1;

	    if(vecDir.isParallelTo(vecRef))
	    	yFlag = 0;
	    else
	    	yFlag = vecDir.dotProduct(vecYView)<0?-1:1;
	   
		return;
	}//endregion

//region Function GetAngle
	// returns the rotation angle snapping to differnt grids based on the offset
	// vecDir: not normalized, the direction vector to derive the angle to vecRef
	// vecRef: the refrence vector
	// vecZ: used to distinguish neg/pos in the range of +-180°
	// diameter: the preview circle size
	// gridAngle: the angle increment derived from the selected offset, 0=full precision
	double GetAngle(Vector3d vecDir, Vector3d vecRef, Vector3d vecZ, double diameter, double& gridAngle)
	{ 

		double offset = vecDir.length();
		vecDir.normalize();
		double angle = vecRef.angleTo(vecDir) *(vecZ.dotProduct(vecRef.crossProduct(vecDir))<0?-1:1);
			
		if (offset>2*diameter)			gridAngle = 1;
		else if (offset>1.5*diameter)	gridAngle = 5;
		else if (offset>1.0*diameter)	gridAngle = 10;		
		else if (offset>0.5*diameter)	gridAngle = 22.5;
		else							gridAngle = 45;

		if (offset<2.5*diameter)
			angle = round(angle / gridAngle) * gridAngle;
		else
			gridAngle = 0;
		return angle;
	}//endregion


//region Function AppendStrings
	// appends an array of strings to an array of of strings ignoring duplicates
	void AppendStrings(String& values[],String valuesNew[])
	{ 
		for (int i=0;i<valuesNew.length();i++) 
		{ 
			String value= valuesNew[i]; 
			if (values.findNoCase(value,-1)<0)
				values.append(value);			 
		}//next i
		values = values.sorted();
		return values;
	}//endregion
//endregion 

// Jig Insert
	String kJigInsert = "JigInsert";
	if (_bOnJig && _kExecuteKey==kJigInsert) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point	
	    Point3d ptOrg = _Map.getPoint3d("ptOrg");
		int bIsRotation = _Map.getInt("isRotation");
		Map mapBodies = _Map.getMap("Body[]");
		Map mapColors = _Map.getMap("Color[]");
		
		Body bodies[] = GetBodyArray(mapBodies);
		int colors[] = GetIntArray(mapColors,false);

		PlaneProfile pp = _Map.getPlaneProfile("pp");
		CoordSys cs = pp.coordSys();
		Point3d pt = cs.ptOrg();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		Plane pn(pt, vecZView);
		Line(ptJig, vecZView).hasIntersection(pn, ptJig);

		Vector3d vec = ptJig - ptOrg;

	// Rotate
		CoordSys csRot;
		if (bIsRotation)
		{ 
	        double diameter = dViewHeight * .15; // HSB-22689 incremental rotation fixed
	        Vector3d vecRotate = ptJig-pt;
	        
	        double dGridAngle;
	        double dAngle = GetAngle(vecRotate, cs.vecX(), cs.vecZ(), diameter, dGridAngle);	
	       
	       	
	        csRot.setToRotation(dAngle, cs.vecZ(), cs.ptOrg());
		
		}
		



	    Display dp(-1);
		dp.trueColor(lightblue, 50);

		for (int i=0;i<bodies.length();i++) 
		{ 
			Body bd= bodies[i]; 
			bd.transformBy(vec);
			bodies[i].transformBy(csRot);
			if (colors.length()>i)
				dp.color(colors[i]);
			else
				dp.trueColor(lightblue, 50);	
			
			dp.draw(bd);
		}//next i
		
		
	    
	    
	    return;
	}


//region Jig Rotation
	String kJigRotation = "JigRotation";
	if (_bOnJig && _kExecuteKey==kJigRotation) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
		int indexAxis = _Map.getInt("indexAxis");
		PlaneProfile pp = _Map.getPlaneProfile("pp");
		CoordSys cs = pp.coordSys();
		Point3d pt = cs.ptOrg();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		Plane pn(pt, vecZ);
		Line(ptJig, vecZView).hasIntersection(pn, ptJig);

	    int colors[] = { 1, 3, 150};
	    
	    double diameter = dViewHeight * .15;
	    PLine circles[0], circle;
	    circle.createCircle(pt, vecZ, diameter);
	    circles.append(circle);

		Vector3d vecJig = ptJig - pt;
		
		double dGridAngle;
		double angle = GetAngle(vecJig, vecX, vecZ, diameter, dGridAngle);
		double dJigLength = vecJig.length();

		
		CoordSys rot;
		rot.setToRotation(angle, vecZ, pt);
		Vector3d vecDir = vecX;
		vecDir.transformBy(rot);
		Vector3d vecMid = vecX + vecDir; vecMid.normalize();
		Point3d ptOnArc = circle.closestPointTo(pt +vecMid * diameter);

		PLine plSector(vecZ);
		plSector.addVertex(pt);
		plSector.addVertex(pt + vecX * diameter);
		plSector.addVertex(pt + vecDir * diameter, ptOnArc);	
		plSector.close();

	    Display dp(-1);
	    double textHeight = dViewHeight * .05;
	    dp.textHeight(textHeight);
	        
	    if (indexAxis>0 && indexAxis<3)
	    	dp.color(colors[indexAxis]);	    
	    dp.draw(plSector);
	    
	    
		dp.trueColor(lightblue,80);
		double diamGrid;
	    if (dJigLength>diameter) // 10°
	    { 
	    	diamGrid = diameter * 1.5;
	    	circle.createCircle(pt, vecZ, diamGrid);
	    	dp.draw(circle);
	    }	    
	    if (dJigLength>diameter*1.5)
	    { 
	    	diamGrid = diameter * 2;
	    	circle.createCircle(pt, vecZ, diamGrid);
	    	dp.draw(circle);
	    }		    
	    if (dJigLength>diameter*2)
	    { 
	    	diamGrid = diameter * 2.5;
	    	circle.createCircle(pt, vecZ, diamGrid);
	    	dp.draw(circle);
	    }		    
	    
	    Body bd = _Map.getBody("bd");
	    bd.transformBy(rot);
	    dp.draw(bd);
	    
	    Point3d ptTxt = pt + vecDir * (diameter + .5 * textHeight);
	    if(diamGrid>0)
	    { 
		    if (indexAxis>0 && indexAxis<3)
		    	dp.color(colors[indexAxis]);
		    Point3d pt2 = pt + vecDir * (diamGrid);
		    Point3d pt1 = pt2 -vecDir* .5 * diameter;
		    dp.transparency(0);
		    dp.draw(PLine(pt1, pt2));
		    ptTxt = pt2 + vecDir * .5 * textHeight;
	    }	    
	    
	    
	    
	    dp.trueColor(darkyellow);
	    dp.transparency(0);
	    if (abs(angle)>0)
	    { 
		    plSector.convertToLineApprox(dEps);
		    dp.draw(PlaneProfile(plSector), _kDrawFilled, 40);
		}   
		{ 
		    double xFlag, yFlag;
		    GetTextFlags(vecDir, vecX,xFlag, yFlag);
		    dp.draw(angle+"°", ptTxt, vecXView, vecYView, xFlag, yFlag);	   			
		}


	// draw grid angle
		dp.trueColor(lightblue);
		if (dGridAngle>0)
		{ 
			dp.textHeight(.75 * textHeight);			
			double xFlag, yFlag;
		    GetTextFlags(-vecMid,vecX, xFlag, yFlag);		
			dp.draw(dGridAngle+"°", pt-vecMid*.375*textHeight, vecXView, vecYView, xFlag, yFlag);
		}

	    return;
	}//endregion 


//endregion 




//region OnInsert
	if(_bOnInsert || bDebug)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

	
		CoordSys cs(_PtW, _XU, _YU, _ZU);


	// The requested style could be defined as execute key, check if already in dwg
		String style, sStyles[] = MetalPartCollectionDef().getAllEntryNames();
		String sAllStyles[0];
		sAllStyles = sStyles;
		
		int bImport=true, bShowStyleDialog, bCanOverride;
		if (_kExecuteKey.length()>0)
		{
			int n = sStyles.findNoCase(_kExecuteKey ,- 1);
			if (n>-1)
			{ 
				style =sStyles[n];
				bImport = false;
			}
			else
				style =_kExecuteKey;
		}

		//if (bDebug)style = "ST40";


	//region Search dwgs with styles and select style
		String fullPath, sDwgPaths[0];
		
		if (bImport)
		{ 
			String sDefaultPaths[] = { _kPathHsbCompany + "\\Assemblies", _kPathHsbCompany + "\\SubAssembly"};
			
			for (int i=0;i<sDefaultPaths.length();i++) 
				GetStyleDwgs(sDwgPaths, sDefaultPaths[i]); 	
			sDwgPaths = sDwgPaths.sorted();
			
		//region Select if multiple found
			if (sDwgPaths.length()<1)
			{ 
				bShowStyleDialog = true;
				if (sStyles.length()<1)
				{ 
					reportNotice(TN("|Could not find any styles in the search paths.|"));
					eraseInstance();
					return;					
				}
			}
			else if (sDwgPaths.length()==1)
			{ 
				fullPath = sDwgPaths.first();
			}
			else if (sDwgPaths.length()>0)
			{ 
				fullPath = ShowDwgSelectionDialog(sDwgPaths);
			}//endregion 				

		//region Select Style from dwg			
			while (sDwgPaths.findNoCase(fullPath,-1)>-1)
			{ 	
				String styles[] = MetalPartCollectionDef().getAllEntryNamesFromDwg(fullPath).sorted();
				AppendStrings(sAllStyles, styles); // append existing styles from current dwg
				
				int bCancel, nSelected = -1,nIndexSelectDwg;
				
			// No styles found	
				if (sAllStyles.length()<1)
				{ 
					reportNotice(TN("|Could not find any styles within the search path or in the current drawing.|\n")+ fullPath);
					eraseInstance();
					return;
				}
//			// Requested Style found in current and style dwg
//				else if (styles.findNoCase(style,-1)>-1 && sStyles.findNoCase(style,-1)>-1)
//				{ 
//					bCanOverride=true;
//				}
			// Requested Style found in style dwg but not in current: import style
				else if (styles.findNoCase(style,-1)>-1 && sStyles.findNoCase(style,-1)<0)
				{ 
					if (!ImportFromDwg(fullPath, style))
					{
						eraseInstance();
						return;
					}
					else
					{ 
						bCanOverride = false;
						bImport = false;						
					}
					break;
				}
			// select style from dialog	
				else
				{ 

					Map mapDialog = ShowStyleSelectionDialog(sAllStyles, nIndexSelectDwg, "");
					bCancel = mapDialog .getInt("WasCancelled");
					nSelected = mapDialog .getInt("SelectedIndex");			
				}			
				
			// Cancel
				if (nSelected<0)
				{ 
					if (bDebug)reportNotice("\nStyle cancelled");
					break;
					
				}
			// Show file dialog again	
				else if (nSelected==nIndexSelectDwg)
				{ 
					fullPath = ShowDwgSelectionDialog(sDwgPaths);
				}
			// Style selected and Import	
				else
				{ 
					style = sAllStyles[nSelected];					
				// Exists in current	
					if (sStyles.findNoCase(style,-1)>-1)
						bCanOverride = true;
				// Import		
					else if (!ImportFromDwg(fullPath, style))
					{ 
					// Import failed	
						eraseInstance();
						return;
					}
						
					break;
				}
			}	
		//endregion 
		}
	//End Search //endregion 

	//region No Style dwg found, use styles of current dwg only
		if (style=="" && sStyles.length()>0)
		{
			bShowStyleDialog = true;
		}
		
		if (bShowStyleDialog)
		{ 
			int nAllowFileSelection = -1; // do not show file option
			Map mapDialog =ShowStyleSelectionDialog(sAllStyles, nAllowFileSelection, TN("|(No external style drawing found.)|"));
			int bCancel = mapDialog.getInt("WasCancelled");
			int nSelected = mapDialog.getInt("SelectedIndex");	
			
			if (bCancel ||nSelected<0)
			{ 
				eraseInstance();
				return;
			}			
			else
				style = sAllStyles[nSelected];
		}
	//endregion 



		if (style.length()<1)
		{ 
			if (bDebug)reportNotice("\nno style found");
			eraseInstance();
			return;
		}
		else
		{ 
			//if (bDebug)return;
			Point3d ptLocs[0];
			String prompt0 = T("|Pick insertion point|");
			String prompt1 = T("|Pick insertion point [Import]|");
			String prompt2 = T("|Pick insertion point [Rotate]|");
			String prompt3 = T("|Pick insertion point [Rotate/Import]|");
			String prompts[] ={ prompt0, prompt1, prompt2, prompt3};
			int nPrompt = bCanOverride ? 3 : 2;	
			String prompt=prompts[nPrompt];

		
		 //region Get Jig bodies from style	
		 	
		 	Map mapArgs;
		 	
		 	PlaneProfile pp(cs);
		 	Point3d ptOrg = cs.ptOrg(), ptLoc;
	   		Plane pn(_PtW, cs.vecZ());
	   		mapArgs.setPlaneProfile("pp", pp); // carries coordSys
		 	mapArgs.setInt("indexAxis", 0); 
		 	int bIsRotation;
		 	double dAngle;
		 	
			Body bodies[0];
			int colors[0];
			MetalPartCollectionDef cd(style);

			if (cd.bIsValid())
			{ 
				{
					Sheet items[] = cd.sheet();
					for (int i=0;i<items.length();i++) 
					{ 
						Body bd = items[i].envelopeBody(true, true); 
						if (!bd.isNull()){ bodies.append(bd);	colors.append(items[i].color());}
					}//next i
				}
				{
					Beam items[] = cd.beam();
					
					for (int i=0;i<items.length();i++) 
					{ 
						Body bd = items[i].envelopeBody(true, true); 
						if (!bd.isNull()){ bodies.append(bd);	colors.append(items[i].color());}

					}//next i
				}
				{
					Sip items[] = cd.sip();
					for (int i = 0; i < items.length(); i++)
					{
						Body bd = items[i].envelopeBody(true, true);
						if (!bd.isNull()){ bodies.append(bd);	colors.append(items[i].color());}
					}
				}
				{
					Entity items[] = cd.entity();
					for (int i=0;i<items.length();i++) 
					{ 
						Body bd = items[i].realBodyTry(); 
						if (!bd.isNull()){ bodies.append(bd);	colors.append(items[i].color());}
					}//next i
				}				
			}

			Map mapBodies = SetBodyArray(bodies, "body");
			Map mapColors = SetIntArray(colors, "color");
			mapArgs.setMap("Body[]", mapBodies);			
			mapArgs.setMap("Color[]", mapColors);			
			mapArgs.setPoint3d("ptOrg", ptOrg);
		 		
		 //endregion 


		//region PrPoint with Jig
			PrPoint ssP(prompt); // second argument will set _PtBase in map

		    int nGoJig = -1;
		    while (nGoJig != _kNone)//nGoJig != _kOk && 
		    {
		        nGoJig = ssP.goJig(kJigInsert, mapArgs); 
		        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
		        
		        if (nGoJig == _kOk)
		        {
		            Point3d ptPick = ssP.value(); //retrieve the selected point
	
					if (bIsRotation)
					{ 
						pn=Plane (ptPick, cs.vecZ());
						Line(ptPick, vecZView).hasIntersection(pn, ptPick);
			            double diameter = dViewHeight * .15; // HSB-22689 incremental rotation fixed
			            Vector3d vecPick = ptPick-ptLoc;
			            
			            double dGridAngle;
			            dAngle = GetAngle(vecPick, cs.vecX(), cs.vecZ(), diameter, dGridAngle);	
			           
			           	CoordSys csRot;
			            csRot.setToRotation(dAngle, cs.vecZ(), cs.ptOrg());
			            
			            for (int i=0;i<bodies.length();i++) 
			            	bodies[i].transformBy(csRot); 
			            Map mapBodies = SetBodyArray(bodies, "body");
			            mapArgs.setMap("Body[]", mapBodies);
			            
			            cs.transformBy(csRot);
			            
			            bIsRotation = false;
			            mapArgs.setInt("isRotation", bIsRotation);
			            
			            ssP=PrPoint (prompt);
					}
					else
					{ 
						ptLoc = ptPick;
						ptLocs.append(ptPick);
						bIsRotation = false;
		        		mapArgs.setInt("isRotation", bIsRotation);
					}
					
					cs = CoordSys(ptLoc, cs.vecX(), cs.vecY(), cs.vecZ());
					MetalPartCollectionEnt ce;
					ce.dbCreate(cs, style);

		        }
		        else if (nGoJig == _kKeyWord)
		        { 
		        	if (ssP.keywordIndex() == 0)//Rotate
		        	{ 
		        		ptLoc = getPoint();
		        		pn=Plane (ptLoc, cs.vecZ());
		            	cs= CoordSys(ptLoc, cs.vecX(), cs.vecY(), cs.vecZ());
		            	pp = PlaneProfile(cs);
		            	mapArgs.setPlaneProfile("pp", pp);	
		            	ssP=PrPoint (T("|Pick point to rotate [Angle/Basepoint/ReferenceLine]|"), ptLoc);		        		
		        		
		        		bIsRotation = true;
		        		mapArgs.setInt("isRotation", bIsRotation);
		        		
		        	}
		            else if (ssP.keywordIndex() == 1)//Import
		            {
						if (!ImportFromDwg(fullPath, style))
						{
							eraseInstance();
							return;
						}
						else
						{
							bCanOverride = false;
							ssP= PrPoint(prompt0);
						}
		            }
		        }
		        else if (nGoJig == _kCancel)
		        { 
		            eraseInstance(); // do not insert this instance
		            return; 
		        }
		        
		    // Create
		        
		        
		    }			
		//endregion 
	
		}


		if (!bDebug)eraseInstance();
		return;
	}			
//endregion 

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
        <int nm="BreakPoint" vl="154" />
        <int nm="BreakPoint" vl="683" />
        <int nm="BreakPoint" vl="561" />
        <int nm="BreakPoint" vl="581" />
        <int nm="BreakPoint" vl="530" />
        <int nm="BreakPoint" vl="552" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22974 bugfix if no external style dwg found" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="11/20/2024 11:09:03 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22974 initial version of MetalPartInsert" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="11/13/2024 4:54:39 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End