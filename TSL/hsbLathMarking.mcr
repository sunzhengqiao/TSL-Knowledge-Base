#Version 8
#BeginDescription
#Versions
Version 1.1 05.07.2022 HSB-15867 bugfix new in line when drawing info text , Author Thorsten Huck
version value="1.0" date="30jun2020" author="thorsten.huck@hsbcad.com"
initial

This tsl creates markings of all genbeams of a defining zone on a marking zone. Once inserted one could release the set of markings into single instances which can be then edited individualy.

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords Roof;floor;Marking;Marker;panlat;counterbatten;lath
#BeginContents
/// <History>//region
// #Versions
// 1.1 05.07.2022 HSB-15867 bugfix new in line when drawing info text , Author Thorsten Huck
/// <version value="1.0" date="30jun2020" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry and press OK, then select roofelements
/// </insert>

/// <summary Lang=en>
/// This tsl creates markings of all genbeams of a defining zone on a marking zone. Once inserted one could release the set of markings into single instances which can be then edited individualy.
/// </summary>
	
/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbLathMarking")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Edit in place|") (_TM "|Select Marking|"))) TSLCONTENT
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


//region Element
//	ElementRoof el;
//	if (_Element.length()>1 && _Element[0].bIsKindOf(ElementRoof()))
//		el = (ElementRoof)_Element[0];
//End Element//endregion 	



//region Properties
	category = T("|Tool|");
	String sZoneDefName=T("|Defining Zone|");	
	int nZoneDefs[]={-5,-4,-3,-2,-1,0,1,2,3,4,5};
//	// remove zones not present
//	if (el.bIsValid())
//		for (int i=nZoneDefs.length()-1; i>=0 ; i--) 
//			if (el.zone(nZoneDefs[i]).dH()<dEps)
//				nZoneDefs.removeAt(i);
//	if (nZoneDefs.length()<1){ eraseInstance();return;}
	PropInt nZoneDef(nIntIndex++, nZoneDefs, sZoneDefName,10);	
	nZoneDef.setDescription(T("|Defines the Marker Zone|"));
	nZoneDef.setCategory(category);
	
	String sZoneName=T("|Marking Zone|");	
	int nZones[]={-5,-4,-3,-2,-1,0,1,2,3,4,5};
//	// remove zones not present
//	if (el.bIsValid())
//		for (int i=nZones.length()-1; i>=0 ; i--) 
//			if (el.zone(nZones[i]).dH()<dEps)
//				nZones.removeAt(i);	
//	if (nZones.length()<1){ eraseInstance();return;}			
	PropInt nZone(nIntIndex++, nZones, sZoneName);	
	nZone.setDescription(T("|Defines the Zone|"));
	nZone.setCategory(category);

	String sToolingIndexName=T("|Tooling Index|");	
	PropInt nToolingIndex(nIntIndex++, 1, sToolingIndexName);	
	nToolingIndex.setDescription(T("|Defines the Tooling Index|"));
	nToolingIndex.setCategory(category);

	category = T("|Element|");
	String sMaxWidthName=T("|Max. Width|");	
	PropDouble dMaxWidth(nDoubleIndex++, U(0), sMaxWidthName);	
	dMaxWidth.setDescription(T("|Defines the maximal width of the element.|") + T(", |0 = any width|"));
	dMaxWidth.setCategory(category);		
//End Properties//endregion 


// create TSL
	TslInst tslNew;
	int bForceModelSpace = true;	
	String sCatalogName = sLastInserted;
	String sExecuteKey;
	String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
	GenBeam gbsTsl[] = {};		Entity entsTsl[1];				Point3d ptsTsl[1];
	int nProps[]={};			double dProps[]={};				String sProps[]={};
	Map mapTsl;	

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
		else showDialog();
		
	// prompt for elements
		PrEntity ssE(T("|Select element(s)|"), ElementRoof());
	  	if (ssE.go())
			_Element.append(ssE.elementSet());


	
	// insert per element
		for(int i=0;i<_Element.length();i++)
		{
			entsTsl[0]= _Element[i];	
			ptsTsl[0]=_Element[i].ptOrg();
			
			tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, 
				sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent);
			
			if(bDebug && tslNew.bIsValid())reportMessage("\n"+ scriptName() + " created for " +_Element[i].number());
		}

		eraseInstance();
		return;
	}	
// end on insert	__________________


// validate selection set
	if (_Element.length()<1 || !_Element[0].bIsKindOf(ElementRoof()))	
	{
		reportMessage("\n" + scriptName() + " " + T("|could not find reference to element.|"));
		eraseInstance();
		return;				
	}	
	
// standards
	ElementRoof el = (ElementRoof)_Element[0];
	CoordSys cs =el.coordSys();
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	Point3d ptOrg = cs.ptOrg();
	assignToElementGroup(el, true,0,'E');
	
	ElemZone zone = el.zone(nZone);
	Vector3d vecZZone = zone.vecZ();
	Point3d ptRefZone = zone.ptOrg()+vecZZone*zone.dH();
	
	
	
// error trapping
	String err;
	Map mapProperties = _Map.getMap("properties");
	String events[] = { sZoneDefName, sZoneName};
	
// check element size	
	LineSeg segMinMax = el.segmentMinMax();
	if (dMaxWidth>0)
	{ 
		Beam beams[] = el.beam();
		Point3d pts[0];
		for (int i=0;i<beams.length();i++) 
			pts.append(beams[i].envelopeBody(false,true).extremeVertices(vecX)); 
		pts = Line(_Pt0, vecX).orderPoints(pts, dEps);

	// get width of zone 0
		double dX;
		if (pts.length()>0)
			dX = abs(vecX.dotProduct(pts.first()-pts.last()));
		if (dX>0 && dX>dMaxWidth)
		{ 
			err = T("|The width of element| ") + el.number() + T(" |exceeds the maximal width of| ") + dMaxWidth + " (" + dX + ")";
			reportMessage("\n" + scriptName() + ": " +err);
			eraseInstance();
			return;
		}
		
	// set max width to 0 once it is inserted	
		dMaxWidth.set(0);	
		setExecutionLoops(2);
	}
	else
		dMaxWidth.setReadOnly(true);
	
	
// validate properties
	if (nZoneDef==nZone)
		err = T("|the defining and the marking zone may not be identical.|");
	else if ((nZoneDef<=0 && nZone>nZoneDef) ||(nZoneDef>=0 && nZone>nZoneDef) )
		err = T("|the defining zone may not be above the marking zone.|");
	if (err.length()>0)
	{ 
		reportMessage("\n" + scriptName() + ": " +err);
	
		if (mapProperties.length()>0 && events.find(_kNameLastChangedProp)>-1)
		{
			reportMessage(T(" |Restoring previous values.|"));
			setPropValuesFromMap(_Map.getMap("properties"));
			setExecutionLoops(2);
			return;
		}
		else
		{ 
			eraseInstance();
			return;			
		}

	}
	
// collect defining entities
	int numDef, numMark;
	GenBeam gbDefs[0];
	gbDefs.append(_GenBeam.length()>0?_GenBeam.first():el.genBeam(nZoneDef));
	numDef = gbDefs.length();
	GenBeam gbMarks[0];
	gbMarks.append(_GenBeam.length()>1?_GenBeam.last(): el.genBeam(nZone));
	numMark = gbMarks.length();
	
	if (numMark<1 && numDef<1)
	{
		err = T("|No defining and marking entities found.|");
		Display dp(1);
		dp.textHeight(U(80));
		dp.draw("\P" + scriptName() + T("\P|waiting for construction|"), segMinMax.ptMid(), vecX, vecY, 0, 0);
	}
	else if (numDef<1)
		err = T("|No defining entities found.|");
	else if (numMark<1)
		err = T("|No marking entities found.|");
	if (err.length()>0)
	{ 
		reportMessage("\n" + scriptName() + ": " +err);
		
		if (mapProperties.length()>0 && events.find(_kNameLastChangedProp)>-1)
		{
			reportMessage(T(" |Restoring previous values.|"));
			setPropValuesFromMap(_Map.getMap("properties"));
			setExecutionLoops(2);
			return;
		}
		else
		{ 
			eraseInstance();
			return;			
		}

	}	
	
	
// TriggerEditInPlacePanel
	
	
// Trigger EditInPlace//region
	int bEditInPlace=_Map.getInt("directEdit");
	String sTriggerEditInPlace = T("../|Edit in Place|");
	if (_GenBeam.length()<1)
	{
		addRecalcTrigger(_kContext, sTriggerEditInPlace );
		if (_bOnRecalc && (_kExecuteKey==sTriggerEditInPlace || _kExecuteKey==sDoubleClick))
		{
			setCatalogFromPropValues(sLastInserted);
			_Map.setInt("directEdit",bEditInPlace?false:true);
			setExecutionLoops(2);
			return;
		}		
	}
//endregion	

	
// collect linesegments on the upper(left) side of the definings
	LineSeg marks[0];
	for (int i=0;i<gbDefs.length();i++) 
	{ 
		GenBeam& gb = gbDefs[i]; 
		Vector3d vecDir = gb.vecX();
		Vector3d vecPerp = vecDir.isParallelTo(vecY) ? gb.vecD(-vecX) : gb.vecD(vecY);
		
		Point3d pt = gb.ptCenSolid() + vecPerp*.5 * gb.dD(vecPerp);
		pt += vecZZone * vecZZone.dotProduct(ptRefZone - pt);
		
		double dL = gb.solidLength();
		
		LineSeg segDef(pt - vecDir * .5 * dL, pt + vecDir * .5 * dL);
		//segDef.vis(1);
		
	// loop marked zone
		for (int j=0;j<gbMarks.length();j++) 
		{ 
			GenBeam gbMark= gbMarks[j];
			Body bd = gbMark.envelopeBody(false, true); bd.vis(i % 4);
			Plane pn(gbMark.ptCen() + vecZZone * .5 * gb.dD(vecZZone), vecZZone);
			PlaneProfile pp = bd.shadowProfile(pn);
			
			LineSeg segs[] = pp.splitSegments(segDef, true);
			if (segs.length() < 1)continue;
			
			if (bEditInPlace && _GenBeam.length()<2)
			{ 
				entsTsl[0]=el;	
				ptsTsl[0]=ptOrg;
				gbsTsl.setLength(0);
				gbsTsl.append(gb);
				gbsTsl.append(gbMark);
				mapTsl.setInt("directEdit", true);
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, 
					sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent);
			}
			else
				marks.append(segs);
		}//next j
	}//next i
	
	if (bEditInPlace && _GenBeam.length()<2)
	{ 
		eraseInstance();
		return;
	}
	
// if in single mode show grip points and allow modification by grip
	if (_GenBeam.length()==2 && marks.length()==1)
	{ 
		LineSeg mark = marks.first();
		if (_PtG.length()<2 )
		{ 
			_PtG.append(mark.ptStart());
			_PtG.append(mark.ptEnd());
		}
		for (int i=0;i<_PtG.length();i++) 
			_PtG[i]=mark.closestPointTo(_PtG[i]); 

		mark = LineSeg(_PtG[0], _PtG[1]);
		if (mark.length()>dEps)
			marks.first() = mark;
	}
	
// add marker
	for (int i=0;i<marks.length();i++) 
	{ 
		marks[i].vis(i%4); 
		
		PLine plMark(marks[i].ptStart(),marks[i].ptEnd());
		ElemMarker mark(nZone, plMark, nToolingIndex);
 		el.addTool(mark);
	}//next i
	
// purge if no markings found
	if (events.find(_kNameLastChangedProp)<0 && marks.length()<1)
	{ 
		reportMessage("\n"+ scriptName() + T(" |purged as no markings could be found.|"));
		eraseInstance();
		return;
	}


	
// store last properties used to avoid crash on property change	HSB-8167
	mapProperties= _ThisInst.mapWithPropValues();
	_Map.setMap("properties", mapProperties);
	

#End
#BeginThumbnail
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
,`````$E%3D2N0F""


#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15867 bugfix new in line when drawing info text" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="7/5/2022 8:49:24 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End