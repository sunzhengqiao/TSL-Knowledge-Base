#Version 8
#BeginDescription
#Versions
Version 1.0 30.04.2024 HSB-21987 initial version

This tsl creates marking lines on a genbeam based on a polyline
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
// 1.0 30.04.2024 HSB-21987 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select polylines, then select genbeams
/// </insert>

// <summary Lang=en>
// This tsl creates marking lines on a genbeam based on a polyline
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbPolylineMarker")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Side|") (_TM "|Select Tool|"))) TSLCONTENT
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


	//region Function GetMarkingPLine
	// returns
	// t: the tslInstance to 
	PLine GetMarkingPLine(GenBeam gb, PLine plDefining, Plane& pnFace, int bFlipFace)
	{ 
		PLine out;
	
		CoordSys cs = plDefining.coordSys();
		Vector3d vecZ = (bFlipFace?-1:1)*cs.vecZ();
		Vector3d vecD = gb.vecD(vecZ);
		
		
		Beam bm = (Beam)gb;
		// marking only supported on XY planes of sheet or panel
		if (!bm.bIsValid() && !vecD.isParallelTo(gb.vecZ()))
		{ 
			return out;
		}
		else
		{ 
			Point3d ptFace = gb.ptCen()+vecD*.5*gb.dD(vecD);
			pnFace= Plane(ptFace, vecD);
			
			PLine pl = plDefining;
			pl.projectPointsToPlane(pnFace, vecZ);

			if (pl.length()>0)
				out = pl;
		}
	
		return out;
	}//endregion



//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
//	// silent/dialog
//		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
//			setPropValuesFromCatalog(_kExecuteKey);						
//	// standard dialog	
//		else	
//			showDialog();
		
		
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select marking polylines|"), EntPLine());
		if (ssE.go())
			ents.append(ssE.set());
		if (ents.length()<1)
		{ 
			reportNotice("\n"+ T("|Invalid selection set.|"));
			eraseInstance();
			return;
		}
			
			
	// prompt for genbeams
		Entity ents2[0];
		PrEntity ssE2(T("|Select genbeams to be marked|"), GenBeam());
		if (ssE2.go())
			ents2.append(ssE2.set());		
		
		GenBeam gbs[0];
		for (int i=0;i<ents2.length();i++) 
		{ 
			GenBeam gb = (GenBeam)ents2[i]; 
			if (!gb.bIsValid()  || gb.bIsDummy())
			{
				continue;
			}
			gbs.append(gb);	
		}//next i		
		
	// Create individual instances

		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};			double dProps[]={};				String sProps[]={};
		Map mapTsl;	
		
		for (int i=0;i<gbs.length();i++) 
		{ 
		
			GenBeam gb = gbs[i];
			
			for (int j=0;j<ents.length();j++)
			{ 
				
				
				EntPLine epl = (EntPLine)ents[j];
				PLine pl = epl.getPLine();
				
				if (pl.length()<dEps){ continue;}
				Plane pnFace;
				PLine plMarking =GetMarkingPLine(gb, pl, pnFace,false);
				if (plMarking.length()>0)
				{ 
					Entity entsTsl[] = {epl};
					GenBeam gbsTsl[] = {gbs[i]};
					
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);					
				}
				
				

			}
			 
		}//next i
		
						
		
		
		
		eraseInstance();
		return;
	}			
//endregion 


//region ValidateSet
	GenBeam gbs[0];gbs = _GenBeam;
	EntPLine epl;
	
	for (int i=0;i<_Entity.length();i++) 
	{ 
		EntPLine _epl= (EntPLine)_Entity[i]; 
		if (_epl.bIsValid() && !epl.bIsValid())
		{ 
			epl = _epl;
		}
		setDependencyOnEntity(_Entity[i]);
	}//next i
	
	
	if (gbs.length()<1 || !epl.bIsValid())
	{ 
		reportNotice("\n" + T("|Invalid selection set|"));
		eraseInstance();
		return;
	}

	int nColor = 3;
	Display dp(nColor);
	_ThisInst.setDrawOrderToFront(100);
	_ThisInst.setAllowGripAtPt0(false);
	assignToGroups(gbs[0], 'T');
//endregion 


//region Get Marking PLine 
	int bFlipFace=_Map.getInt("flip");



	PLine plDefining = epl.getPLine();
	if (plDefining.length()<dEps)
	{ 
		reportNotice("\n" + T("|Invalid pline|"));
		eraseInstance();
		return;
	}
	CoordSys csp = plDefining.coordSys();
	_Pt0 = plDefining.ptStart();
	Vector3d vecZ = (bFlipFace?-1:1)*csp.vecZ();
	
	int bHasMarking;	
	for (int i=0;i<gbs.length();i++) 
	{ 
		GenBeam gb = gbs[i]; 
		Plane pnFace;
		PLine plMarking = GetMarkingPLine(gb, plDefining, pnFace,bFlipFace);
		if (bFlipFace)
			plMarking.flipNormal();
		plMarking.convertToLineApprox(U(50));
		Vector3d vecN = pnFace.vecZ();
		
		PlaneProfile pp = gb.realBody().shadowProfile(pnFace);		pp.vis(2);
		
		
		Point3d ptStart = plMarking.ptStart();
		Point3d ptEnd = plMarking.ptEnd();
		
		PLine rings[] = pp.allRings(true, false);
		PLine plEnvelope;
		if (rings.length()>0)
			plEnvelope = rings[0];
			
//		if (!plMarking.coordSys().vecZ().isCodirectionalTo(pnFace.vecZ()))
//			plMarking.flipNormal();

		
	// check if marking pline intersects
		double dists[] = plMarking.intersectPLineAsDistances(plEnvelope);
		int bHasIntersection = pp.pointInProfile(ptStart)!=_kPointOutsideProfile || pp.pointInProfile(ptEnd)!=_kPointOutsideProfile;


	// trim marking pline
		double dL = plMarking.length();
		if (dists.length()>0)
		{ 
			double d0 = dists[0];
			
			Point3d pt1 = plMarking.getPointAtDist(d0);		pt1.vis(6);
			int bAtEnd = false;
			double dTrim = d0;
			if (d0>0)
			{ 
				Point3d pt2 = plMarking.getPointAtDist(d0 - dEps);
				if (pp.pointInProfile(pt2)==_kPointInProfile)
				{ 
					bAtEnd = true;
					dTrim = dL - dists[0];
				}
			}
			plMarking.trim(dTrim, bAtEnd);			
			
		}
		
		ptStart = plMarking.ptStart();
		if ((plEnvelope.closestPointTo(ptStart)-ptStart).length()<dEps)
			plMarking.reverse();
		

		plMarking.vis(2);
		if (plMarking.length()> U(10))
		{ 
			dp.draw(plMarking);
			PLine circle;
			circle.createCircle(plMarking.ptStart(), vecN, U(10));
			if (bFlipFace)
				dp.draw(circle);
			else
				dp.draw(PlaneProfile(circle), _kDrawFilled);
			Point3d pts[] = plMarking.vertexPoints(plMarking.isClosed()?false:true);
			for (int p=0;p<pts.length()-1;p++) 
			{ 
				MarkerLine ml(pts[p], pts[p+1], vecN);
				gb.addTool(ml); 
			}//next p

			bHasMarking = true;
		}
		
	}//next i
	
	if (!bHasMarking)
	{ 
		reportNotice("\n" + T("|No common marking area found|"));
		eraseInstance();
		return;
	}
//endregion 


// TriggerFlipSide
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
	{
		 _Map.setInt("flip",!bFlipFace);
		setExecutionLoops(2);
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
        <int nm="BreakPoint" vl="293" />
        <int nm="BreakPoint" vl="285" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-21987 initial version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="4/30/2024 3:05:42 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End