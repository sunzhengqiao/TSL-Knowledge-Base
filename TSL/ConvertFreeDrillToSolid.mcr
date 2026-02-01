#Version 8
#BeginDescription
#Versions
Version 1.0 05.02.2025 HSB-23368 initial version

Select hsbcad free drills to convert into solids. Requires a valid genbeam associated to the tool.
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
//region <History>
// #Versions
// 1.0 05.02.2025 HSB-23368 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select hsbcad free drills
/// </insert>

// <summary Lang=en>
// This tsl creates solids from hsbcad free drills
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ConvertFreeDrillToSolid")) TSLCONTENT

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


//region Function setReadOnlyFlagOfProperties
	// sets the readOnlyFlag
	void setReadOnlyFlagOfProperties()
	{ 		
//		Property.setReadOnly(HideCondition?_kHidden:false);
//		Property.setReadOnly(HideCondition?_kHidden:false);
		return;
	}//endregion	

//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
//	// standard dialog	27..
//		else	
//		{
//			setPropValuesFromCatalog(tLastInserted);
//			setReadOnlyFlagOfProperties();
//		}
//		while (showDialog("---") == _kUpdate) // _kUpdate means a controlling property changed.	
//		{ 
//			setReadOnlyFlagOfProperties(); // need to set hidden state
//		}	
//		setReadOnlyFlagOfProperties();
	// standard dialog	
		else	
			showDialog();


	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select free drills|"), Entity());
		if (ssE.go())
			ents.append(ssE.set());
		
		for (int i=0;i<ents.length();i++) 
			if (ents[i].typeDxfName()=="HSB_EFREE_DRILL")
				_Entity.append(ents[i]);

		
		if (_Entity.length()<1)
		{ 
			reportNotice("\n"+scriptName() + T(" |could not find any entities of type 'hsbcad Free Drill' in the selection set.|")); 
			eraseInstance();
		}
		//_Pt0 = getPoint();
		return;
	}			
//endregion




//region Function FindDrillsByToolEnt
	// returns all AnalysedDrills of he given genbeam which depend from the toolEnt
	AnalysedDrill[] FindDrillsByToolEnt(GenBeam g, ToolEnt tent)
	{ 
		AnalysedDrill drills[0],drillsG[] = AnalysedDrill().filterToolsOfToolType(g.analysedTools(1));
		for (int i=0;i<drillsG.length();i++) 
		{
			if (drillsG[i].toolEnt()==tent)
				drills.append(drillsG[i]);	
		}
					
		return drills;
	}//endregion

//region Function FindCenterDrill
	// returns the radius of the drill which starts and ends at the extreme points
	double FindCenterDrill(Point3d pt1, Point3d pt2, AnalysedDrill drills[], Vector3d vecZ)
	{ 
		int index = -1;
		
		Point3d ptStarts[0], ptEnds[0]; 
		double radius,radii[0];// collect all radii. with multipe beams it could happen that the main drill is not complete through: take smallest radius 
		
		for (int i=0;i<drills.length();i++) 
		{ 
			AnalysedDrill drill = drills[i];

			Point3d ptStart = drill.ptStartExtreme();
			Point3d ptEnd = drill.ptEndExtreme();		
			if(vecZ.dotProduct(ptEnd-ptStart)<0)
			{ 
				ptStart = ptEnd;
				ptEnd = drill.ptStart();
			}

//			ptStart.vis(i);
//			ptEnd.vis(2);

			double d1 = abs(vecZ.dotProduct(pt1 - ptStart));
			double d2 = abs(vecZ.dotProduct(pt2 - ptEnd));
			
			if (d1<dEps && d2<dEps)
			{ 
				index = i;
				break;
			}

			radii.append(drill.dRadius());

		}//next i
		
		
		if (index<0)
		{ 
			radii = radii.sorted();
			if (radii.length()>0)
				radius = radii.first();
			
		}
		
		
		return radius;
	}//endregion

//region Function FindSinkRadiusAtPoint
	// returns the depth and radius of a potential sink
	// radius: main radius passed in
	double FindSinkRadiusAtPoint(Point3d pt, AnalysedDrill drills[], Vector3d vecZ, double& radius)
	{ 
		double depth, mainRadius= radius;
		radius = 0;

		Point3d ptStarts[0], ptEnds[0];
		double radii[0];// collect all radii. with multipe beams it could happen that the main drill is not complete through: take smallest radius 
		
		for (int i=0;i<drills.length();i++) 
		{ 
			AnalysedDrill drill = drills[i];
			double r = drill.dRadius();
			
			if (r<=mainRadius || abs(r-mainRadius)<dEps)
			{ 
				continue;
			}

			Point3d ptStart = drill.ptStartExtreme();
			Point3d ptEnd = drill.ptEndExtreme();		
			if(vecZ.dotProduct(ptEnd-ptStart)<0)
			{ 
				ptStart = ptEnd;
				ptEnd = drill.ptStart();
			}

//			ptStart.vis(i);
//			ptEnd.vis(2);

			double d1 = abs(vecZ.dotProduct(pt - ptStart));
			double d2 = abs(vecZ.dotProduct(pt - ptEnd));
			
			//reportNotice("...testing " +d1 + " " + d2);
			if (d1<dEps || d2<dEps)
			{ 
				//reportNotice("...accepting " +d1 + " " + d2);
				ptStarts.append(ptStart);
				ptEnds.append(ptEnd);
				radius = r;
			}
		}//next i

		ptStarts = Line(_Pt0, vecZ).orderPoints(ptStarts, dEps);
		ptEnds= Line(_Pt0, vecZ).orderPoints(ptEnds, dEps);
		
		if (ptStarts.length()>0 && ptEnds.length()>0)
		{ 
			depth = vecZ.dotProduct(ptEnds.last() - ptStarts.first());
		}
		return depth;
	}//endregion


//region Function CreateAndConvertMassElement
	// returns
	void CreateAndConvertMassElement(Body bd, CoordSys cs)
	{ 
		
		Entity ent = bd.dbCreateAsMassElement(cs, 2);
		pushCommandOnCommandStack("ConvertTo3DSolids");
		pushCommandOnCommandStack("(handent \""+ent.handle()+"\")");
		pushCommandOnCommandStack("(Command \"\")");
		pushCommandOnCommandStack("Yes"); // yes
		pushCommandOnCommandStack("Ja"); // Ja
		pushCommandOnCommandStack("Oui"); // Oui
		//pushCommandOnCommandStack("Si"); // Si
		pushCommandOnCommandStack("(Command \"\")");
		pushCommandOnCommandStack("(Command)");		

		return;
	}//endregion



//region Collect Bodies
	int num;
	for (int i=0;i<_Entity.length();i++) 
	{ 
		ToolEnt tent = (ToolEnt)_Entity[i]; 
		
		//reportNotice("\n\ntent " +tent.handle());
		if (tent.bIsValid())
		{ 
			
			GenBeam gbs[] = tent.genBeam();
			if (gbs.length()<1)
			{ 
				reportNotice("\n" +tent.handle() +  T( ": |cannot detect diameter from a tool which is not linked with a genbeam.|"));
				continue;
			}
			
			AnalysedDrill drills[0];
			for (int j=0;j<gbs.length();j++) 
			{ 
				gbs[j].realBody().vis(j);
				drills.append(FindDrillsByToolEnt(gbs[j], tent));
				 
			}//next j
			
			if (drills.length()<1)
			{ 
				reportNotice("\n" +tent.handle() +  T(": |cannot detect drill.|"));
				continue;								
			}
			
		// Get vecZ from first
			Vector3d vecZ= drills.first().vecZ();
			Point3d pts[] = Line(_Pt0, vecZ).orderPoints(tent.gripPoints(), dEps);
			if (pts.length()<2)
			{ 
				continue;
			}			
			
			
			Vector3d vecX = _XW.isParallelTo(vecZ) ? _YW : _XW;
			Vector3d vecY = vecX.crossProduct(-vecZ);	vecY.normalize();
			vecX = vecY.crossProduct(vecZ);
			
			
			
			
		// Get bodies from collect atools			
			Point3d pt1 = pts.first();
			Point3d pt2 = pts.last();
			
			vecX.vis(pt1, 1);
			vecY.vis(pt1, 3);
			vecZ.vis(pt1, 150);
			
			pt1.vis(3);
			pt2.vis(4);
			
			
		// Main	
			double radius = FindCenterDrill(pt1, pt2, drills, vecZ);			
			if (radius>dEps)
			{ 

				Body bd(pt1, pt2, radius);
				bd.vis(6);
				if (!bd.isNull())
					CreateAndConvertMassElement(bd, CoordSys(pt1, vecX, vecY, vecZ));
	
			}
			
		// Sinkholes
			double depth1, radius1=radius;
			depth1 = FindSinkRadiusAtPoint(pt1, drills, vecZ, radius1);
			if (radius1>radius && depth1>dEps)
			{ 

				Body bd1(pt1, pt1+vecZ*depth1, radius1);
				bd1.vis(4);
				if (!bd1.isNull())
					CreateAndConvertMassElement(bd1, CoordSys(pt1, vecX, vecY, vecZ));
			}			
			
			double depth2, radius2=radius;
			depth2 = FindSinkRadiusAtPoint(pt2, drills, vecZ, radius2);
			if (radius2>radius && depth2>dEps)
			{ 

				Body bd2(pt2, pt2-vecZ*depth2, radius2);
				bd2.vis(4);
				if (!bd2.isNull())
					CreateAndConvertMassElement(bd2, CoordSys(pt2, vecX, vecY, vecZ));			
			}				

			
		}
		 
	}//next i		
//endregion 


	if (!bDebug)
	{ 
		eraseInstance();
		return;
	}


//
////region Convert to solids
//	for (int i=0;i<bodies.length();i++) 
//	{ 
//		Body bd = bodies[i]; 
//		//Entity ent = bd.dbCreateAsMassElement(2);
//	}//next i
//		
////endregion 





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
        <int nm="BreakPoint" vl="215" />
        <int nm="BreakPoint" vl="373" />
        <int nm="BreakPoint" vl="343" />
        <int nm="BreakPoint" vl="354" />
        <int nm="BreakPoint" vl="330" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23368 initial version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="2/5/2025 11:59:14 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End