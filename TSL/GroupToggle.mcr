#Version 8
#BeginDescription
#Versions
Version 1.1 30.05.2023 HSB-19045 _RegenAll added when toggling groups on
Version 1.0 26.05.2023 HSB-19045 initial version of GroupToggle

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
// 1.1 30.05.2023 HSB-19045 _RegenAll added when toggling groups on , Author Thorsten Huck
// 1.0 26.05.2023 HSB-19045 initial version of GroupToggle , Author Thorsten Huck

/// <insert Lang=en>
/// Fire the command with the desired painter definition
/// </insert>

// <summary Lang=en>
// This tsl toggles groups based on its containing entities and a selectable painter definition
// Some painter definitions are predefined, custom definitions need to be added to the painter folder TSL\GroupToggle
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GroupToggle")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GroupToggle" (_TM "|Exterior Walls|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GroupToggle" (_TM "|Interior Walls|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GroupToggle" (_TM "|Roof Elements|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GroupToggle" (_TM "|Non Element|"))) TSLCONTENT
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
//end Constants//endregion

//region Painters
// Get or create default painter definition
	String sPainterCollection = "TSL\\GroupToggle\\";
	PainterDefinition pds[0];

	String sPainters[0],sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();
	for (int i=0;i<sAllPainters.length();i++) 
	{ 
		if (sAllPainters[i].find(sPainterCollection,0,false)==0)
		{
			PainterDefinition pd(sAllPainters[i]);
			if (!pd.bIsValid())
			{ 
				continue;
			}
			
		// add painter name	
			String name = sAllPainters[i];
			name = name.right(name.length() - sPainterCollection.length());
			if (sPainters.findNoCase(name,-1)<0)
			{ 
				sPainters.append(name);
				pds.append(pd);
			}
				
		}		 
	}//next i

	int nCustomPDCreation =-1;	
	if (_bOnInsert || _bOnDbCreated || bDebug)
	{ 
		String sCustomers[] = { "Lux"};
		for (int i=0;i<sCustomers.length();i++) 
		{ 
			if (projectSpecial().find(sCustomers[i],0,false)>-1)
			{
				nCustomPDCreation=i;
				break;
			} 
		}//next i		
	}


	
//region Custom Definitions
	if (nCustomPDCreation==0) // LUX
	{ 
		String name = "Vorwand";
		String painter = sPainterCollection + name;
		PainterDefinition pd(painter);	
		if (!pd.bIsValid())
		{ 
			pd.dbCreate();
			if (pd.bIsValid())
			{ 
				pd.setType("ElementWall");
				pd.setFilter("Contains(ElementNumber,'VW')");
				pd.setFormat("@(GroupLevel3)");
				pds.append(pd);
			}
		}	
			
		if (sPainters.findNoCase(name,-1)<0)
			sPainters.append(name);
			
	}		
//endregion 	

//region Default Definitions
	Entity entWalls[] = Group().collectEntities(true, ElementWall(), _kModelSpace);
	int bHasWalls = entWalls.length()>0;
	Entity entElementRoofs[] = Group().collectEntities(true, ElementRoof(), _kModelSpace);
	int bHasERoofs = entElementRoofs.length()>0;

// Wall Definitions
	if (bHasWalls)
	{ 
		if (sPainters.findNoCase(T("|Exterior Walls|"),-1)<0)
		{ 
			String name = T("|Exterior Walls|");
			String painter = sPainterCollection + name;
			PainterDefinition pd(painter);	
			if (!pd.bIsValid())
			{ 
				pd.dbCreate();
				if (pd.bIsValid())
				{ 
					pd.setType("ElementWall");
					pd.setFilter("Exposed = 'true'");
					pd.setFormat("@(GroupLevel3)");
					pds.append(pd);
				}
			}	
				
			if (sPainters.findNoCase(name,-1)<0)
				sPainters.append(name);		
		}
		if (sPainters.findNoCase(T("|Interior Walls|"),-1)<0)
		{ 
			String name = T("|Interior Walls|");
			String painter = sPainterCollection + name;
			PainterDefinition pd(painter);	
			if (!pd.bIsValid())
			{ 
				pd.dbCreate();
				if (pd.bIsValid())
				{ 
					pd.setType("ElementWall");
					pd.setFilter("Exposed = 'false'");
					pd.setFormat("@(GroupLevel3)");
					pds.append(pd);
				}
			}	
				
			if (sPainters.findNoCase(name,-1)<0)
				sPainters.append(name);		
		}			
	}
	
// Element Roof Definitions
	if (bHasERoofs)
	{ 
		if (sPainters.findNoCase(T("|Roof Elements|"),-1)<0)
		{ 
			String name = T("|Roof Elements|");
			String painter = sPainterCollection + name;
			PainterDefinition pd(painter);	
			if (!pd.bIsValid())
			{ 
				pd.dbCreate();
				if (pd.bIsValid())
				{ 
					pd.setType("ElementRoof");
					pd.setFilter("");
					pd.setFormat("@(GroupLevel3)");
					pds.append(pd);
				}
			}	
				
			if (sPainters.findNoCase(name,-1)<0)
				sPainters.append(name);		
		}			
	}

// No Element Groups
	{ 
		if (sPainters.findNoCase(T("|Non Element|"),-1)<0)
		{ 
			String name = T("|Non Element|");
			String painter = sPainterCollection + name;
			PainterDefinition pd(painter);	
			if (!pd.bIsValid())
			{ 
				pd.dbCreate();
				if (pd.bIsValid())
				{ 
					pd.setType("Entity");
					pd.setFilter("GroupLevel3 != '' and TypeName != 'Element' and TypeName != 'ElementRoof' and TypeName != 'ElementWall'");
					pd.setFormat("@(GroupLevel3)");
					pds.append(pd);
				}
			}	
				
			if (sPainters.findNoCase(name,-1)<0)
				sPainters.append(name);		
		}		
	}

//endregion 	
	
//endregion

//region Properties
	if (sPainters.length()<1)
	{ 
		reportNotice("\n**** " + scriptName() + " ****");
		reportNotice("\n" + T("|This tool is based on painter definitions of groups, but this drawing does not contain any valid definition.|"));
		reportNotice("\n" + T("|Please create painter definitions based on groups and try again.|"));
		reportNotice("\n" + T("|The definitions need to be created in folder named| ") + sPainterCollection);
		eraseInstance();
		return;		
	}


	String sPainterName=T("|Painter|");	
	PropString sPainter(nStringIndex++, sPainters.sorted(), sPainterName);	
	sPainter.setDescription(T("|Defines the painter definition which will be used to toggle matching groups|"));
	sPainter.setCategory(category);
	
	
//End Properties//endregion 

//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);	
		else if (_kExecuteKey.length()>0 && sPainters.findNoCase(_kExecuteKey,-1)>-1)
		{ 
			sPainter.set(_kExecuteKey);
		}			
	// standard dialog	
		else	
		{
			String entries[] = TslInst().getListOfCatalogNames(scriptName());
			showDialog();
			
			if (entries.length()<1)
			{ 
				reportNotice("\n***** " + scriptName() + " *****");
				reportNotice("\n" + T("|NOTE|: ") + T("|This information will only be shown once, please read carefully.|"));
				
				reportNotice("\n" + T("|By creating tool buttons with one of the following lines as command string\nyou can define a toggle to turn groups on or off as set.|"));
				reportNotice("\n" + T("|CTRL + 4 will open the catalog browser to insert a tool button to your palettes.|\n\n"));
				
				for (int i=0;i<sPainters.length();i++) 
				{ 
					String text = "^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert \"GroupToggle\" (_TM \"|"+ sPainters[i] +"|\"))) TSLCONTENT"; 
				
					reportNotice("\n" + text);
				}//next i
				
				
				reportNotice("\n\n***** " + scriptName() + " *****");
				
			}
			
			
			
			
			
		}
		
		//_Pt0 = getPoint();
		//return;
	}			
//endregion 

//region Get painter
	PainterDefinition pd(sPainterCollection+sPainter);
	String type = pd.type();
	String filter = pd.filter();
	String format = pd.format();	
	
	
	if (!pd.bIsValid())
	{ 
		reportNotice("\n**** " + scriptName() + " ****");
		reportNotice("\n" + T("|This tool is based on painter definitions of groups.|"));
		reportNotice("\n" + sPainterCollection+sPainter + " " + T("|is not a valid painter definition.|"));
		reportNotice("\n" + T("|The definitions need to be created in folder named| ") + sPainterCollection);
		eraseInstance();
		return;
	}

	int bIsElement = type.find("Element", 0, false) >- 1;
	int bIsWall = type.find("ElementWall", 0, false) >- 1;
	int bIsRoof = type.find("ElementRoof", 0, false) >- 1;
//endregion 

//region Collect relevant Groups

// get current parent
	Group grCurrent = _kCurrentGroup;
	String namePart0 = grCurrent.namePart(0);
	String namePart1 = grCurrent.namePart(1);
	String namePart2 = grCurrent.namePart(2);
	
	String sCurrentParent;
	if (namePart1.length() > 0) 
		sCurrentParent = namePart0 + "\\" + namePart1;
	else if (namePart0.length() > 0) 
		sCurrentParent = namePart0;

//region Collect groups
	Group groups[0];
	if (sCurrentParent.length() > 0)
	{ 
		Group grParent(sCurrentParent);
		groups = grParent.subGroups(true);
	}
	else if (bIsElement)
	{ 
		groups=Group().allElementGroups();
	}
	else
	{ 
		groups=Group().allExistingGroups();
	}
	// keep only level 3 groups
	for (int i=groups.length()-1; i>=0 ; i--)
		if (groups[i].namePart(2).length()<1)
			groups.removeAt(i);
			
//endregion 


//region Element: keep only element groups
	if (bIsElement)
	{ 
		Element elements[0];
		for (int i=groups.length()-1; i>=0 ; i--)
		{ 
			int ok;
			Element el = groups[i].elementLinked();
			if (el.bIsValid())
			{ 
				if (bIsWall && el.bIsKindOf(ElementWall()))
					ok = true;	
				else if (bIsRoof && el.bIsKindOf(ElementRoof()))
					ok = true;	
				else
					ok = true;
					
				if (ok)
					elements.append(el);
			}
			
			if (!ok)
				groups.removeAt(i);
		}
		
	// Collect element groups
		Group grElements[0];
		elements = pd.filterAcceptedEntities(elements);
		for (int i=0;i<elements.length();i++) 
			grElements.append(elements[i].elementGroup()); 	
		groups = grElements;	
	}
			
//endregion 	

//region Entity: Filter groups, consider only groups with entities
	else
	{ 
		for (int i = groups.length() - 1; i >= 0; i--)
		{
			Group& gr = groups[i];
			Entity ents[] = gr.collectEntities(false, Entity(), _kModelSpace, false);
			
			if (ents.length()<1)
			{ 
				groups.removeAt(i);
			}
			else
			{ 
				if (bDebug)reportNotice("\n" + groups[i].namePart(0) + "-" +groups[i].namePart(1) + "-" + groups[i].namePart(2) + " (" + ents.length() + ")");
				ents = pd.filterAcceptedEntities(ents);
				if (ents.length()<1)
				{ 
					groups.removeAt(i);
				}
			}	
		}		
	}		
//endregion 

//END Collect relevant Groups //endregion 
	
//region Show remaining groups to be toggled
	if (bDebug)
	{ 		
	// order alphabetically
		for (int i=0;i<groups.length();i++) 
			for (int j=0;j<groups.length()-1;j++) 
				if (groups[j].name()>groups[j+1].name())
					groups.swap(j, j + 1);		
		
		
		double textHeight = U(50);
		Display dp(2), dpf(-1);
		dp.textHeight(textHeight);
		Point3d pt = _Pt0-_XW*textHeight;
		
		CoordSys csl();
		CoordSys rot; rot.setToRotation(60, _YW, pt);
		csl.transformBy(rot);
		rot.setToRotation(60, _ZW, pt-_YW*.3*textHeight);
		
		PlaneProfile ppa(csl);
		PLine leaf; leaf.createCircle(pt, csl.vecZ(), textHeight * .25);
		leaf.convertToLineApprox(dEps);
		ppa.joinRing(leaf, _kAdd);
		ppa.project(Plane(pt, _ZW), _ZW, dEps);
		
		PlaneProfile ppb(CoordSys());
		
		for (int i=0;i<6;i++) 
		{ 
			ppb.unionWith(ppa);
			ppa.transformBy(rot);
			 
		}//next i
		dp.draw(ppb, _kDrawFilled);
		
		
		
		String text = "Group List: " + sPainter + "\n";
		for (int i=0;i<groups.length();i++) 
		{ 
			dpf.color((i + 1) % 5);
			text+= groups[i].name()+ "\n"; 
			pt-=_YW*textHeight; 
		}//next i
		
		dp.draw(text, _Pt0, _XW, _YW, 1, 0);
		
		//return;
	}
//endregion 	
		
//region Toggle Groups
	int bOn = _kIsOn;
	for (int i=0;i<groups.length();i++) 
	{ 
		int n = groups[i].groupVisibility(false); 
		if (n!=_kIsOff)
			bOn = _kIsOff;
	}//next i
	
	for (int i=0;i<groups.length();i++)
	{ 
		if (bOn)groups[i].turnGroupVisibilityOn(true); 
		else groups[i].turnGroupVisibilityOff(true); 
	}
	if (bOn == _kIsOn)
	{ 
		pushCommandOnCommandStack("_RegenAll");
	}
	
	if (!bDebug)
	{ 
		eraseInstance();
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
        <int nm="BreakPoint" vl="470" />
        <int nm="BreakPoint" vl="470" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19045 _RegenAll added when toggling groups on" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="5/30/2023 10:03:33 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19045 initial version of GroupToggle" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="5/26/2023 2:01:15 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End