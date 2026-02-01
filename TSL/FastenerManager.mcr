#Version 8
#BeginDescription
#Versions
Version 1.0 12.07.2021 CMP-25 initial version , Author Thorsten Huck
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords Fastener;Assembly;Garnitur;Screw;Bolt;Fixing;Metal;Steel
#BeginContents
//region <History>
// #Versions
// 1.0 12.07.2021 CMP-25 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select metalpart collections which contain fastener guidelines or tools with fastener guidelines
/// </insert>

// <summary Lang=en>
// This tsl extents fastener guidelines by the linked geometry of the metalpart collection entity. 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "FastenerManager")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Fastener|") (_TM "|Select Tool|"))) TSLCONTENT
//endregion



//region Constants 
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
//end Constants//endregion

//region Properties
	String sExtraRadiusName=T("|Extra Radius|");	
	PropDouble dExtraRadius(nDoubleIndex++, U(0), sExtraRadiusName);	
	dExtraRadius.setDescription(T("|Defines additional radius which will be added to the radius ofthe selected fastener.|"));
	dExtraRadius.setCategory(category);
	
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
		else	
			showDialog();
		
	
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select metalparts|"), MetalPartCollectionEnt());
		if (ssE.go())
			ents.append(ssE.set());
			
	
		for (int i=0;i<ents.length();i++) 
		{ 
		// create TSL
			TslInst tslNew;				Map mapTsl;
			int bForceModelSpace = true;	
			String sExecuteKey,sCatalogName = sLastInserted;
			String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {ents[i]};			Point3d ptsTsl[] = {};
		
			tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 	
			 
		}//next i
			
		
		
		
		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion
	

//region Get Reference
	MetalPartCollectionEnt ce;
	for (int i=0;i<_Entity.length();i++) 
	{ 
		ce = (MetalPartCollectionEnt)_Entity[i]; 
		if (ce.bIsValid())
		{
			setDependencyOnEntity(ce);
			break;		 
		}
	}//next i
	if (!ce.bIsValid())
	{
		eraseInstance();
		return;
	}
	CoordSys cs =ce.coordSys();
	_ThisInst.resetFastenerGuidelines();
	assignToGroups(ce, 'T');
	
	Display dp(40);
//End Get Reference//endregion 

//region Collect connected genbeams
	GenBeam genbeams[] = ce.genBeam();
	Body bodies[0];
	for (int i=0;i<genbeams.length();i++) 
	{ 
		Body bd = genbeams[i].envelopeBody(false, true);
		bodies.append(bd);	 
	}//next i
	
//endregion 


//region Scan definition
	MetalPartCollectionDef cd(ce.definition());	
	TslInst tsls[] = cd.tslInst();
	Beam dummies[0],beams[] = cd.beam();
	Body bdDummies[0]; // transformed to ce
	// collect dummies
	for (int i=beams.length()-1; i>=0 ; i--) 
	{ 
		if (beams[i].bIsDummy()==2)
		{
			Beam& b = beams[i];
			Body bd = b.envelopeBody(false, true);
			bd.transformBy(cs);
			bdDummies.append(bd); bd.vis(4);
			dummies.append(b);
			beams.removeAt(i);
		} 
	}//next i
	
	// collect all fastenerAssemblies attached
	FastenerAssemblyEnt faes[]=_ThisInst.getAttachedFasteners();
	int bAddFastener = _bOnDbCreated || _Map.getInt("addFastener");

	// collect potential fastener guidelines
	String sFasteners[] = FastenerAssemblyDef().getAllEntryNames();
	int numGuideline;
	for (int i=0;i<tsls.length();i++) 
	{ 
		// component data
		String sPreSelectFastener = tsls[i].propString(T("|Assembly|"));
		int nFastener = sFasteners.findNoCase(sPreSelectFastener,-1);		
		double mainDiameter;
		
		FastenerAssemblyDef fad;
		if (nFastener>-1)
		{ 
			fad=FastenerAssemblyDef (sFasteners[nFastener]);
			FastenerListComponent flc = fad.listComponent();
			mainDiameter = flc.componentData().mainDiameter();
		}

		FastenerGuideline fgs[]= tsls[i].fastenerGuidelines();
		for (int j=0;j<fgs.length();j++) 
		{ 
			Point3d pt1 = fgs[j].ptStart();
			Point3d pt2 = fgs[j].ptEnd();

			pt1.transformBy(cs);
			pt2.transformBy(cs);
			pt1.vis(3);
			pt2.vis(4);			
			
		// test solid intersection
			Body bdx(pt1, pt2, U(5));
			Vector3d vecDir = pt2 - pt1; vecDir.normalize();
			Line ln(pt1, vecDir);
			
		// extent test by potential dummy beam
			{ 
				Point3d pts[] = { pt1, pt2};
				for (int x=0;x<bdDummies.length();x++) 
				{ 
					Body& b = bdDummies[x];
					if ( !bdx.hasIntersection(b))continue; // test solid intersection	
					//b.vis(x);
					Point3d _pts[] = b.intersectPoints(ln);
					if (_pts.length()>0)
						pts.append(_pts);		
				}//next x			
				pts = ln.orderPoints(pts, dEps);
				if (pts.length()>1)
					bdx=Body(pts.first(), pts.last(), U(5));	
			}
			
		// extent by intersecting solids	
			Point3d pts[] = { pt1, pt2};
			for (int x=0;x<bodies.length();x++) 
			{ 
				Body& b = bodies[x];
				if ( !bdx.hasIntersection(b))continue; // test solid intersection	
				//b.vis(x);
				Point3d _pts[] = b.intersectPoints(ln);
				if (_pts.length()>0)
					pts.append(_pts);		
			}//next x			
			pts = ln.orderPoints(pts, dEps);
			
			if (pts.length()>1)
			{ 
				pt1 = pts.first();
				pt2 = pts.last();
			}
			//pt1.vis(1);pt2.vis(2);
			PLine pl(pt1, pt2);
			dp.draw(pl);
			CoordSys csPline = pl.coordSys();
			
		//Fastener Guideline
			FastenerGuideline fg(pt1, pt2, mainDiameter*.5);	//fg.vis(1);			
			_ThisInst.addFastenerGuideline(fg);				
			numGuideline++;

		// add fastener on dbCreate or on users request
			if (bAddFastener && fad.bIsValid())
			{ 
				FastenerAssemblyEnt fae;
				fae.dbCreate(sPreSelectFastener, csPline);
				fae.anchorTo(_ThisInst, pt1, U(1));
				
				if (faes.find(fae) < 0)faes.append(fae);
			}
		
		// get fastener attached to this guideline
			for (int f=0;f<faes.length();f++) 
			{ 
				CoordSys cs= faes[f].coordSys(); 
				Point3d ptOrg = cs.ptOrg();
				double dX = abs(cs.vecX().dotProduct(ptOrg - pt1));
				double dY = abs(cs.vecY().dotProduct(ptOrg - pt1));
				if (dX<dEps && dY<dEps && cs.vecZ().isParallelTo(vecDir))
				{ 
					_Entity.append(faes[f]);
					setDependencyOnEntity(faes[f]);
					FastenerAssemblyDef fadX(faes[f].definition());
					FastenerListComponent flcX = fadX.listComponent();
					double radius = flcX.componentData().mainDiameter()*.5;
					
					if (radius > 0 && radius+dExtraRadius>0)
					{ 
						Drill dr(pt1, pt2, radius + dExtraRadius);
						dr.addMeToGenBeamsIntersect(genbeams);
						break;						
					}

				}
			}//next f
			
		

		}//next j 
	}//next i
	
	
	
	
//End Scan definition//endregion 

//region Trigger AddFastener
	if (_Map.getInt("addFastener"))_Map.removeAt("addFastener", true);
	String sTriggerAddFastener = T("|Add Fastener|");
	addRecalcTrigger(_kContextRoot, sTriggerAddFastener );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddFastener)
	{
		for (int i=faes.length()-1; i>=0 ; i--) 
			faes[i].dbErase(); 
		_Map.setInt("addFastener", true);	
		setExecutionLoops(2);
		return;
	}//endregion	



if (numGuideline<1)
{ 
	eraseInstance();
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
        <int nm="BreakPoint" vl="173" />
        <int nm="BreakPoint" vl="133" />
        <int nm="BreakPoint" vl="173" />
        <int nm="BreakPoint" vl="133" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="CMP-25 initial version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="7/12/2021 11:39:32 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End