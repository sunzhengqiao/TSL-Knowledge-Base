#Version 8
#BeginDescription
#Versions:
2.7 03.12.2024 HSB-23098: Add property that sets distance from beam axis Author: Marsel Nakuci

version value="2.6" date="08jan19" author="thorsten.huck@hsbcad.com"
version bugfix
alignment fixed
ntersecting beams detected on element creation when set as element tsl


DACH
Dieses TSL erzeugt eine Bohrungsverteilung entlang einem oder mehreren Stäben (Platten, Panelen).

EN
This tsl creates a drill distribution along X-Direction of a genbeam. optional one can connect additional genbeams with it

2.7 03.12.2024 HSB-23098: Add property that sets distance from beam axis Author: Marsel Nakuci

2.8 03.12.2024 ee Author: Marsel Nakuci

2.7 03.12.2024 HSB-23098: Add property that sets distance from beam axis Author: Marsel Nakuci


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 7
#KeyWords 
#BeginContents
//region Part1
/// <summary Lang=en>
/// Dieses TSL erzeugt eine Bohrungsverteilung entlang einem oder mehreren Stäben (Platten, Panelen).
/// </summary>

/// <summary Lang=en>
/// This tsl creates a drill distribution along X-Direction of a genbeam. optional one can connect additional genbeams with it
/// </summary>

/// <insert Lang=en>
/// The insertion is relative to the current UCS. Use the UCS property to align the drill axis.
/// Select the main genbeam, optional additional genbeams.
/// Now select optionally start and end point of distribution, default is the start and end point of the genbeam
/// </insert>

/// History
/// #Versions:
// 2.7 03.12.2024 HSB-23098: Add property that sets distance from beam axis Author: Marsel Nakuci
///<version value="2.6" date="08jan19" author="thorsten.huck@hsbcad.com"> version bugfix </version>
///<version value="2.5" date="10oct18" author="thorsten.huck@hsbcad.com"> alignment fixed </version>
///<version value="2.4" date="09oct18" author="thorsten.huck@hsbcad.com"> intersecting beams detected on element creation when set as element tsl </version>
///<version value="2.3" date="19jul17" author="thorsten.huck@hsbcad.com"> drill tool enter direction validated </version>
///<version value="2.2" date="14mar15" author="thorsten.huck@hsbcad.com"> slotted drills suppress overlapping drills </version>
///<version value="2.1" date="25nov15" author="thorsten.huck@hsbcad.com"> distribution mode supports remote catalog settings via map </version>
///<version value="2.0" date="21apr15" author="th@hsbCAD.de"> new copy and erase method included </version>
///<version value="1.9" date="27jan15" author="th@hsbCAD.de"> automatic tool removal if no genbeams are available </version>
///<version value="1.8" date="26jan15" author="th@hsbCAD.de"> automatic tool removal changed to avoid multi element removal </version>
///<version value="1.7" date="01sep14" author="th@hsbCAD.de"> automatic tool assignment if referenced to genbeams of  elements </version>
///<version value="1.6" date="29jul14" author="th@hsbCAD.de"> parallelism tested against element x-axis to perform identical behaviour on mirrored elements </version>
///<version value="1.5" date="01jul14" author="th@hsbCAD.de"> bugfix distribution direction if not default </version>
///<version value="1.4" date="01jul14" author="th@hsbCAD.de"> supports catalog based insertion (no dialog) </version>
///<version value="1.3" date="01jul14" author="th@hsbCAD.de"> property 'Depth' also suuports dowel alike connections by shortening the drill in the main object. Only applicable if total depth >= depth of main object</version>
///<version value="1.2" date="01jul14" author="th@hsbCAD.de"> new property 'Assignment' of slotted holes allowes individual settings of slotted holes </version>
///<version value="1.1" date="01jul14" author="th@hsbCAD.de"> initial </version>


// constants //region
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
	//endregion

//region Properties
	String sOpmKeyName = "Distribution";
	String sSpecials[] = {"BAUFRITZ"}; // declare a list of supported specials. specials might change behaviour and available properties
	int nSpecial = sSpecials.find(projectSpecial().makeUpper());

	String sDepthName =T("|Depth|");
	// 0
	PropDouble dDepth(nDoubleIndex++, 0,sDepthName);
	dDepth.setDescription(T("|Sets the depth of the drill|")+ " " + T("|0=complete through|"));		
	dDepth.setCategory(category);

	String sDiameterName =T("|Diameter|");
	// 1
	PropDouble dDiameter(nDoubleIndex++, U(18),sDiameterName);
	dDiameter.setDescription(T("|Sets the diameter of the drill|"));		
	dDiameter.setCategory(category);

	String sAlignments[] = {"-Z","-Y","Z","Y"};
	Vector3d vecs[] = {-_ZU,-_YU,_ZU,_YU};
	String sAlignmentName =T("|UCS|");
	PropString sAlignment(nStringIndex++, sAlignments,sAlignmentName);
	sAlignment.setDescription(T("|Sets the alignment of the drills in relation to the most aligned beam direction of the current UCS|"));		
	sAlignment.setCategory(category);

	String sSnapAxisName =T("|Snap to center line|");
	PropString sSnapAxis(nStringIndex++, sNoYes,sSnapAxisName);
	sSnapAxis.setDescription(T("|Defines if the drills will placed along the axis of the first selected beam|"));		
	sSnapAxis.setCategory(category);
	String sCategoryGeneral=category;
	
	category = T("|Sinkhole|" + " " + T("|Reference Side|"));
	String sDepthSink1Name =T("|Depth|" + " " );
	// 2
	PropDouble dDepthSink1(nDoubleIndex++, 0,sDepthSink1Name);
	dDepthSink1.setDescription(T("|Sets the depth of the sink hole|")+ " " + T("|A negative value shortens the drill in the main object if applicable.|"));		
	dDepthSink1.setCategory(category);

	String sDiameterSink1Name =T("|Diameter|"+ " " );
	// 3
	PropDouble dDiameterSink1(nDoubleIndex++, U(18),sDiameterSink1Name);
	dDiameterSink1.setDescription(T("|Sets the diameter of the drill|"));		
	dDiameterSink1.setCategory(category);

	category = T("|Sinkhole|" + + " " + T("|opposite Side|"));
	String sDepthSink2Name =T("|Depth|" + "  " );
	// 4
	PropDouble dDepthSink2(nDoubleIndex++, 0,sDepthSink2Name);
	dDepthSink2.setDescription(T("|Sets the depth of the drill|")+ " " + T("|0=complete through|"));		
	dDepthSink2.setCategory(category);

	String sDiameterSink2Name =T("|Diameter|"+ "  " );
	// 5
	PropDouble dDiameterSink2(nDoubleIndex++, U(18),sDiameterSink2Name);
	dDiameterSink2.setDescription(T("|Sets the diameter of the drill|"));		
	dDiameterSink2.setCategory(category);

	category = T("|Slotted Hole|");
	String sLengthName =T("|Length|");
	// 6
	PropDouble dLength(nDoubleIndex++, U(18),sLengthName);
	dLength.setDescription(T("|Sets a slotted hole if the length exceeds the diameter.|"));		
	dLength.setCategory(category);
	
	String sSlottedTypes[] = {T("|none|"), T("|first object|"), T("|second object|"), T("|all|")};
	String sSlottedTypeName =T("|Assignment|");
	PropString sSlottedType(nStringIndex++, sSlottedTypes,sSlottedTypeName);
	sSlottedType.setDescription(T("|Defines which objects of the selection set receive a slotted hole|"));		
	sSlottedType.setCategory(category);
	
// Baufritz
	String sPropHWDescription;
	category = "Baufritz";
	String sHWDescriptionName =T("|Hardware|");
	String sHWDescriptions[] = { "", "Schlüsselschraube 16 x 220", "Schlüsselschraube 16 x 260", "Stehbolzen kurz", "Stehbolzen lang"};//Beschreibung 
	if (nSpecial==0)
	{
		PropString sHWDescription(nStringIndex++, sHWDescriptions,sHWDescriptionName);
		sHWDescription.setDescription("Definiert die verwendeten Verbindungsmittel");		
		sHWDescription.setCategory(category);
		sPropHWDescription = sPropHWDescription;				
	}
	
	// 7
	String sOffsetAxisName=T("|Axis offset|");
	PropDouble dOffsetAxis(nDoubleIndex++, U(0), sOffsetAxisName);
	dOffsetAxis.setDescription(T("|Defines the offset from the beam axis. Only active for nonzero entries and when Snap to center line is set to no.|"));
	dOffsetAxis.setCategory(sCategoryGeneral);
	
//endregion End Properties

//region declare the tsl props
	TslInst tslNew;
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	GenBeam gbs[0];		Entity ents[0];		Point3d pts[0];
	int nProps[0];		double dProps[0];	String sProps[0];
	Map mapTsl;			String sScriptname = scriptName();		
//endregion End declare the tsl props


// on insert 	
	if (_bOnInsert)  	
	{ 
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// distribution mode
		setOPMKey(sOpmKeyName);
		category = T("|Distribution|");
		String sDistributionModes[] = {T("|Even Distribution|"), T("|Fixed Distribution|")};
		String sDistributionModeName =T("|Mode|");
		PropString sDistributionMode(nStringIndex++, sDistributionModes,sDistributionModeName);
		sDistributionMode.setDescription(T("|Sets the distribution of the distribution|"));		
		sDistributionMode.setCategory(category);
	
		String sOffsetName =T("|Inter distance|");
		PropDouble dOffset(nDoubleIndex++, U(70),sOffsetName);
		dOffset.setDescription(T("|Sets the offset of the distribution|"));		
		dOffset.setCategory(category);
	
		String sOffsetStartName =T("|Distance from startpoint|");
		PropDouble dOffsetStart(nDoubleIndex++, 0,sOffsetStartName);
		dOffsetStart.setDescription(T("|Sets the distance of start point of the distribution to the given point|"));		
		dOffsetStart.setCategory(category);
		
		String sOffsetEndName =T("|Distance from endpoint|");
		PropDouble dOffsetEnd(nDoubleIndex++, 0,sOffsetEndName);
		dOffsetEnd.setDescription(T("|Sets the distance of end point of the distribution to the given point|"));		
		dOffsetEnd.setCategory(category);

	// dialog
		if (_kExecuteKey.length()<1)
			showDialog();
		else
			setPropValuesFromCatalog(_kExecuteKey);
						
	// Baufritz
		if (nSpecial==0)
		{
			category = "Baufritz";
			PropString sHWDescription(3, sHWDescriptions,sHWDescriptionName);
			sHWDescription.setDescription("Definiert die verwendeten Verbindungsmittel");		
			sHWDescription.setCategory(category);
			sPropHWDescription= sHWDescription;				
		}	
		
	// snap to axis flag and alignment
		int bSnapAxis = sNoYes.find(sSnapAxis,1);
		int nAlignment=sAlignments.find(sAlignment,0);
		
	// prompt	
		GenBeam gb = getGenBeam();
		Point3d ptCen = gb.ptCenSolid();	
		_GenBeam.append(gb);

		Entity entities[0];
		PrEntity ssE(T("|Select additional objects ( <ENTER> for none)|"), GenBeam());
  		if (ssE.go())
	    	entities= ssE.set();	
		for (int e=0;e<entities.length();e++)
			_GenBeam.append((GenBeam)entities[e]);
	
	// CoordSys
		Vector3d vecX = gb.vecX();
		Vector3d vecZ = gb.vecZ();
		
	// allign with element if applicable
		if (gb.element().bIsValid())
		{
			Element el = gb.element();
			if (el.vecX().isParallelTo(vecX))
				vecX=el.vecX();
		}
		
	// align with selected UCS
		if (!_ZU.isParallelTo(vecX)) vecZ = -gb.vecD(vecs[nAlignment]);
		Vector3d vecY = vecX.crossProduct(-vecZ);
		
	// start point
		PrPoint ssP(TN("|Select start point|") + " " + T("|<Enter> to use start point of beam|")); 
	   if (ssP.go()==_kOk)// do the actual query
			_Pt0 =ssP.value(); // retrieve the selected point
		else
			_Pt0 = ptCen- vecX * .5* gb.solidLength();
		_Pt0.transformBy(vecZ*vecZ.dotProduct(ptCen-_Pt0));			
		if (bSnapAxis)
			_Pt0.transformBy(vecY*vecY.dotProduct(ptCen-_Pt0));
		Line lnRef(_Pt0,vecX);
						
	// end point
		PrPoint ssP1(TN("|Select end point|") + " " + T("|<Enter> to use end point of beam|"), _Pt0); 
		Point3d ptEnd=ptCen+ vecX * .5* gb.solidLength();
	   if (ssP1.go()==_kOk)// do the actual query
			ptEnd=ssP1.value(); // retrieve the selected point
		ptEnd = lnRef.closestPointTo(ptEnd);	
		_PtG.append(ptEnd);

	// distribution direction
		Vector3d vecXDistr=vecX;
		if(vecXDistr.dotProduct(ptEnd-_Pt0)<0)vecXDistr*=-1;


	// SPECIAL 0: insert reference drill at horizontal beam
		if (nSpecial==0 && vecX.isPerpendicularTo(_ZW) && gb.bIsKindOf(Beam()))
		{
			PrPoint ssP2("\n" + T("|Select reference point|") + " " + T("|(optional)|")); 
		    if (ssP2.go()==_kOk)// do the actual query
			{
				
				Point3d pt = lnRef.closestPointTo(ssP2.value());// retrieve the selected point
				vecUcsX = vecX;
				vecUcsY = vecX.crossProduct(gb.vecD(_ZW));
				
			// assign tsl properties
				dProps.setLength(0);
				dProps.append(U(4));// 0
				dProps.append(U(40));// 1
				dProps.append(0);// 2 sink
				dProps.append(0);// 3
				dProps.append(0);// 4
				dProps.append(0);// 5
				dProps.append(0);// 6 length
				dProps.append(dOffsetAxis);// 7 offset from beam axis
																				
				sProps.setLength(0);
				sProps.append(sAlignments[0]);
				sProps.append(sNoYes[1]);
				sProps.append(sSlottedTypes[0]);
				sProps.append(" ");
				
				for (int i=0;i<_GenBeam.length();i++)
				{	
					GenBeam gbThis = _GenBeam[i];
					pts.setLength(0);	
					pts.append(Line(gbThis.ptCenSolid(),gbThis.vecX()).closestPointTo(pt)); 
					gbs.setLength(0);
					gbs.append(gbThis);
					mapTsl.setInt("mode",1);
					tslNew.dbCreate(sScriptname, vecUcsX,vecUcsY,gbs, ents, pts, nProps, dProps, sProps,_kModelSpace, mapTsl); // create new instance
				}// next genbeam
			}
		}// END IF SPECIAL 0:
		_Map.setVector3d("vecXDistr",vecXDistr); 
		_Map.setInt("CustomInsert", true);
		return;
	}		
//endregion End Part1


// get mode
	int nMode = _Map.getInt("mode"); // 0 = distribution, 1 = connection
	int nAlignment=sAlignments.find(sAlignment,0);
	
	if(bDebug)reportMessage("\n"+ scriptName() + " running in mode " + nMode + " genbeams" + _GenBeam);
	
// get main genbeam
	if (_GenBeam.length()<1)
	{
		eraseInstance();
		return;	
	}
	GenBeam gb = _GenBeam[0];
	Vector3d vecX = gb.vecX();
	Vector3d vecY = gb.vecY();
	Vector3d vecZ = gb.vecZ();

	_XU.vis(_Pt0,1);
	_YU.vis(_Pt0,3);
	_ZU.vis(_Pt0,150);
	
// allign with element if applicable
	Element el = gb.element();
	if (el.bIsValid() && el.vecX().isParallelTo(vecX))	vecX=el.vecX();

//region Distribution Mode
	if	(nMode==0)
	{
		setOPMKey(sOpmKeyName);
		category = T("|Distribution|");
		String sDistributionModes[] = {T("|Even Distribution|"), T("|Fixed Distribution|")};
		String sDistributionModeName =T("|Mode|");
		PropString sDistributionMode(nStringIndex++, sDistributionModes,sDistributionModeName);
		sDistributionMode.setDescription(T("|Sets the distribution of the distribution|"));		
		sDistributionMode.setCategory(category);
	
		String sOffsetName =T("|Inter distance|");
		PropDouble dOffset(nDoubleIndex++, U(70),sOffsetName);
		dOffset.setDescription(T("|Sets the offset of the distribution|"));		
		dOffset.setCategory(category);
	
		String sOffsetStartName =T("|Distance from startpoint|");
		PropDouble dOffsetStart(nDoubleIndex++, U(70),sOffsetStartName);
		dOffsetStart.setDescription(T("|Sets the distance of start point of the distribution to the given point|"));		
		dOffsetStart.setCategory(category);
		
		String sOffsetEndName =T("|Distance from endpoint|");
		PropDouble dOffsetEnd(nDoubleIndex++, U(70),sOffsetEndName);
		dOffsetEnd.setDescription(T("|Sets the distance of end point of the distribution to the given point|"));		
		dOffsetEnd.setCategory(category);

	// Baufritz
		if (nSpecial==0)
		{
			category = "Baufritz";
			PropString sHWDescription(3, sHWDescriptions,sHWDescriptionName);
			sHWDescription.setDescription("Definiert die verwendeten Verbindungsmittel");		
			sHWDescription.setCategory(category);
			sPropHWDescription= sHWDescription;				
		}	
		
	// ints
		int nDistributionMode=sDistributionModes.find(sDistributionMode,0);

	// distribution vector
		Vector3d vecXDistr= vecX;
		if (_Map.hasVector3d("vecXDistr"))
			vecXDistr=_Map.getVector3d("vecXDistr");
		String sEntries[] = TslInst().getListOfCatalogNames();

	// set properties by catalog entry if defined in map
	// version 2.1: distribution mode supports remote catalog settings via map
		if (_Map.hasString("CatalogEntry"))
		{
			String sEntry = _Map.getString("CatalogEntry");
			String sEntries[] = TslInst().getListOfCatalogNames(_ThisInst.opmName());
			if (sEntries.find(sEntry)>-1)
				setPropValuesFromCatalog(sEntry);			
		}	
		
	// start and end point
		Point3d ptStart = _Pt0 + vecXDistr*dOffsetStart;	ptStart.vis(1);
		Point3d ptEnd = _PtG[0] - vecXDistr*dOffsetEnd;	ptEnd.vis(255);
		
	// distribution dist and module
		double dDist = abs(vecX.dotProduct(ptStart-ptEnd));
		int nNumDrills;
		double dModule;
		if (dOffset>0)
		{
			if (nDistributionMode==0)// Even Distribution
			{
				nNumDrills = dDist/dOffset+.99;		
				if (nNumDrills>0)
					dModule = dDist/nNumDrills;
					
				nNumDrills++;// include end point
			}
			else // Fixed Distribution
			{
				nNumDrills = dDist/dOffset+.99;
				dModule = dOffset;	
			}
		}

	// collect drill points
		Point3d ptsDrill[0];
		for (int i=0;i<nNumDrills;i++)
		{
			ptsDrill.append(ptStart);
			ptStart.transformBy(vecXDistr*dModule);		
		}		
		if (nDistributionMode==1)// Fixed Distribution
			ptsDrill.append(ptEnd);

	// assign tsl properties
		dProps.setLength(0);
		dProps.append(dDepth);
		dProps.append(dDiameter);
		dProps.append(dDepthSink1);// sink
		dProps.append(dDiameterSink1);
		dProps.append(dDepthSink2);
		dProps.append(dDiameterSink2);			
		dProps.append(dLength);
		dProps.append(dOffsetAxis);
								
		sProps.setLength(0);
		sProps.append(sAlignment);
		sProps.append(sSnapAxis);
		sProps.append(sSlottedType);
		if (nSpecial==0) sProps.append(sPropHWDescription);
		
	// find potential connecting beams if created from lib	
		int bCustomInsert = _Map.getInt("CustomInsert");
		if(!bCustomInsert && el.bIsValid())
		{ 
			Vector3d vecZ = vecs[nAlignment];
			GenBeam gbs[] = el.genBeam();
			for (int i=0;i<ptsDrill.length();i++) 
			{ 
				Point3d pt = ptsDrill[i]-gb.vecD(vecZ)*.5*gb.dD(vecZ); 
				Body bd(pt, pt + vecZ * dDepth, dDiameter / 2);
				PLine pl(pt, pt + vecZ * dDepth);
				bd.vis(2);
				
				GenBeam _gbs[] = bd.filterGenBeamsIntersect(gbs);
				for (int b=0;b<_gbs.length();b++) 
				{ 
					if (_GenBeam.find(_gbs[b])<0)
					{
						if(bDebug)_gbs[b].realBody().vis(3); 
						_GenBeam.append(_gbs[b]);
					}
					 
				}//next b	 
			}//next i
		}
		
		gbs=_GenBeam;
		mapTsl.setInt("mode",1);
//
//		vecUcsX = vecX;	
//		Vector3d vecUcsZ =-gb.vecD(vecs[nAlignment]);
//		vecUcsY  = vecX.crossProduct(-vecUcsZ);
//		vecUcsX.vis(_Pt0,193); vecUcsY.vis(_Pt0,193);	
	// distribute			
		for (int i=0;i<ptsDrill.length();i++)
		{
			Point3d pt = ptsDrill[i];
			if (bDebug)
				pt.vis(i);	
			else
			{
				pts.setLength(0);
				pts.append(pt);
				tslNew.dbCreate(sScriptname, _XU,_YU,gbs, ents, pts, nProps, dProps, sProps,_kModelSpace, mapTsl); // create new instance
			}		
		}	
		
		if (!bDebug)
			eraseInstance();
		return;
	}// END IF distribution	
//endregion End Distribution Mode

// single drill mode_____________________________________________________________________________________________________________________________________________________
// ______________________________________________________________________________________________________________________________________________________________________
	else if	(nMode==1)
	{
		
		if (_bOnDbCreated)
			setExecutionLoops(2);	
		setEraseAndCopyWithBeams(_kNoBeams); // Version 1.8: automatic tool removal changed to avoid multi element removal 
		setKeepReferenceToGenBeamDuringCopy(_kAllBeams);
		
	// snap to axis flag
		int bSnapAxis = sNoYes.find(sSnapAxis,1);
		int nSlottedType = sSlottedTypes.find(sSlottedType,0);
			
	// snap back _Pt0
		if (_kNameLastChangedProp==sAlignmentName || (bSnapAxis  && _kNameLastChangedProp=="_Pt0"))
			_Pt0 = Line(gb.ptCenSolid(), vecX).closestPointTo(_Pt0);



	// control slotted hole assignment based on length property
		if (dLength<=dDiameter && nSlottedType!=0)
		{
			sSlottedType.set(sSlottedTypes[0]);
			reportMessage("\n"+scriptName()+" "+sSlottedTypeName.trimLeft() + " " + T("|changed to|") + " '" + sSlottedType +"'.");
			reportMessage("\n"+scriptName()+" "+T("|Please adjust|") + " " + sLengthName.trimLeft() + " " + T("|to obtain slotted holes|"));
		}

	// coordSys of drill
		Vector3d vecZDrill = gb.vecD(vecs[nAlignment]);		vecZDrill .vis(_Pt0,150);
		Vector3d vecYDrill = vecX.crossProduct(-vecZDrill);	vecYDrill .vis(_Pt0,3);

	// add entity trigger	
		String sAddTrigger = T("|Add entities|");
		addRecalcTrigger(_kContext, sAddTrigger );
		if (_bOnRecalc && _kExecuteKey==sAddTrigger )
		{
			Entity ents[0] ;
		// declare a prompt	
			PrEntity ssE(T("|Select entities|"), GenBeam());		
			if (ssE.go())
				ents= ssE.set();
			for (int e=0; e<ents.length();e++)
			{
				int n = _GenBeam.find(ents[e]);
				if (n<0) _GenBeam.append((GenBeam)ents[e]);	
			}
		}
	
	// remove entity trigger	
		String sRemoveTrigger = T("|Remove entities|");
		addRecalcTrigger(_kContext, sRemoveTrigger );
		if (_bOnRecalc && _kExecuteKey==sRemoveTrigger )
		{
			Entity ents[0] ;		
		// declare a prompt	
			PrEntity ssE(T("|Select entities|"), GenBeam());
			
			if (ssE.go())
				ents= ssE.set();
			for (int e=0; e<ents.length();e++)
			{
				int n = _GenBeam.find(ents[e]);
				if (n>-1)
					_GenBeam.removeAt(n);	
			}
		}

	// remove any genBeam not coplanar with main genbeam
		for (int i=_GenBeam.length()-1;i>=1;i--)
			if (!_GenBeam[i].vecD(vecZDrill).isParallelTo(vecZDrill))
			{
				if(bDebug) reportMessage("\ni " + i + " not coplanar and will be removed");
				_GenBeam.removeAt(i);
			}
	
	// collection of genbeams to obtain slotted holes or regular drills
		// nSlottedType
		// 0 = none
		// 1 = first object
		// 2 = second object
		// 3 = all
		GenBeam gbsSlotted[0], gbsDrill[0];
		if (nSlottedType==1 && dLength>dDiameter)
		{
			gbsSlotted.append(gb);
			for (int i=0;i<_GenBeam.length();i++)
				if (_GenBeam[i]!=gb)
					gbsDrill.append(_GenBeam[i]);	
		}
		else if (nSlottedType==2 && dLength>dDiameter)
		{
			gbsDrill.append(gb);
			for (int i=0;i<_GenBeam.length();i++)
				if (_GenBeam[i]!=gb)
					gbsSlotted.append(_GenBeam[i]);
		}
		else if (nSlottedType==3 && dLength>dDiameter)
			gbsSlotted.append(_GenBeam);
		else
			gbsDrill.append(_GenBeam);

	// declare a collection of elements
		Element elements[0];

	// collect intersection points of all genbeams and the points for the ref face
		Point3d ptsFace[0];
		Point3d ptsExtremes[0];
		Map mapExtremes;
		for (int i=0;i<_GenBeam.length();i++)
		{
			Body bd  =_GenBeam[i].envelopeBody();
			Point3d ptsIntersect[] = bd.intersectPoints(Line(_Pt0,vecZDrill));
			if (ptsIntersect.length()>1)
			{
				mapExtremes.appendPoint3dArray( _GenBeam[i].handle(), ptsIntersect);
				ptsFace.append(ptsIntersect[0]);
				ptsExtremes.append(ptsIntersect);
				PLine(ptsIntersect[0],ptsIntersect[1]).vis(i);
				
				Element _el= _GenBeam[i].element();
				if (_el.bIsValid() && elements.find(el)<0)
					elements.append(_el);
			}		
		}
	
	// assign to elements
		int bExclusive = 	elements.length()==1;
		for (int i=0;i<elements.length();i++)
			assignToElementGroup(elements[i],bExclusive,0, 'T');
		

		
	// validate location
		if (ptsExtremes.length()<2)
		{
			reportMessage("\n"+scriptName()+" "+T("|The tool does not intersect any of the selected genbeams.|") + " " + T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}
	
		
	// find reference face by ordering associated genbeams
		for (int i=0;i<ptsFace.length();i++)		
			for (int j=0;j<ptsFace.length()-1;j++)	
			{
				double d1 = vecZDrill.dotProduct(_Pt0-ptsFace[j]);
				double d2 = vecZDrill.dotProduct(_Pt0-ptsFace[j+1]);
				if (d1<d2)
					ptsFace.swap(j,j+1); 
			}
		if (ptsFace.length()<1)
		{
			reportMessage("\n"+scriptName()+" "+T("|The tool does not intersect any of the selected genbeams.|"));
			eraseInstance();
			return;
		}

	// refPoint, snap to axis if selected	
		if (bSnapAxis)
		{
			_Pt0.transformBy(vecYDrill*vecYDrill.dotProduct(_GenBeam[0].ptCenSolid()-_Pt0));
		}
		
		if(dOffsetAxis!=0 && !bSnapAxis)
		{ 
			_Pt0.transformBy(vecYDrill*vecYDrill.dotProduct((_GenBeam[0].ptCenSolid()-vecYDrill*dOffsetAxis)-_Pt0));
		}
		
		Point3d ptRef = Line(_Pt0,vecX).closestPointTo(_Pt0); 
		ptRef.transformBy(-vecZDrill*vecZDrill.dotProduct(_Pt0-ptsFace[0]));	
		ptRef.vis(6);			
		_Pt0 = ptRef;
		
	// if depth == 0 drill complete through
		double dThisDepth=dDepth;
		int bIsThrough;
		if(dThisDepth<=0)
		{
			ptsExtremes = Line(ptRef, vecZDrill).orderPoints(ptsExtremes);
			if (ptsExtremes.length()>0)
			{
				dThisDepth = abs(vecZDrill.dotProduct(ptsExtremes[ptsExtremes.length()-1]-ptsExtremes[0]));
				bIsThrough=true;
			}
		}
		if (dThisDepth<=dEps)
		{
			reportMessage("\n"+scriptName()+" "+T("|The resulting depth is too small.|"));
			eraseInstance();
			return;
		}
	
	// control sink hole properties
		int bHasSink1 = dDepthSink1>dEps && dDiameterSink1>dDiameter;
		int bHasSink2 = dDepthSink2>dEps && dDiameterSink2>dDiameter && bIsThrough;		
		//if (!bIsThrough || dDepthSink2<dEps)dDiameterSink2.setReadOnly(true);
		//if (!bIsThrough || dDiameterSink2<dEps)dDepthSink2.setReadOnly(true);

	// calculate if shortening the main drill/mortise is applicable
		double dRefOffset;
		if (dDepthSink1<0 && gb.dD(vecZDrill)<=dThisDepth && dThisDepth>abs(dDepthSink1))
			dRefOffset=	-dDepthSink1;
	
	// drawables
		PLine plines[0], pline;
		plines.append(PLine(ptRef,ptRef+vecZDrill*dThisDepth));	
	
	// define and add drill
		if (gbsDrill.length()>0)
		{
		// main drill
			Point3d ptDrill = ptRef;
			double dRadius = dDiameter/2;
			double dDrillDepth = dThisDepth;
			Point3d ptStart = ptDrill+vecZDrill*dRefOffset;
			Point3d ptEnd = ptDrill +vecZDrill*dDrillDepth ;
			Drill drill(ptStart,ptEnd, dRadius);

//		// debug
//			if (_bOnDebug)
//			{
//				
//				Body bd = drill.cuttingBody();
//				bd.vis(2);
//				for (int i=0;i<gbsDrill.length();i++)
//				{
//					Body bdDebug = bd;
//					bdDebug.intersectWith(gbsDrill[i].envelopeBody());
//					bdDebug.transformBy(vecYDrill*(i+1)* U(100));
//					bdDebug.vis(gbsDrill[i].color());	
//				}
//			}
		// 2.3: loop thru all relevant drill beams to validate tool enter dir instead of addMeToGenBeamsIntersect	
			for (int i=0;i<gbsDrill.length();i++) 
			{ 
				if (mapExtremes.hasPoint3dArray(gbsDrill[i].handle()))
				{ 
					Point3d pts[] = mapExtremes.getPoint3dArray(gbsDrill[i].handle());
					if (pts.length()<2)continue;
					
					double d1 = vecZDrill.dotProduct(pts[0]-ptStart);
					double d2 = vecZDrill.dotProduct(pts[1]-ptEnd);
					
					Drill _drill=drill;
					if (d1<0 && d2>0)
					{ 
						Point3d _ptStart = ptStart;
						_ptStart.transformBy(vecZDrill*d1);
						_drill=Drill(_ptStart,ptEnd, dRadius);	
						_drill.cuttingBody().vis(222);
					}
					gbsDrill[i].addTool(_drill);
					
				} 
			}
		// 2.2   _GenBeam -> gbsDrill	
			//drill.addMeToGenBeamsIntersect(gbsDrill);  
			
			pline.createCircle(ptRef,vecZDrill, dRadius);	
			if (!bHasSink1)
			{
				pline.transformBy(vecZDrill*dRefOffset);
				plines.append(pline);
			}
			if (!bHasSink2)
			{
				pline.transformBy(vecZDrill*(dThisDepth-dRefOffset));			
				plines.append(pline);
			}
			
		// sink reference side drill
			if (bHasSink1 && (nSlottedType==0 || nSlottedType==2))
			{
				dRadius = dDiameterSink1/2;
				dDrillDepth =dDepthSink1;
				Drill drillSink1(ptDrill ,ptDrill +vecZDrill*dDrillDepth , dRadius);
				drillSink1.addMeToGenBeamsIntersect(gbsDrill);
				pline.createCircle(ptDrill,vecZDrill, dRadius);		plines.append(pline);
				pline.transformBy(vecZDrill*dDrillDepth );			plines.append(pline);
			}
		// sink opposite side drill
			if (bHasSink2  && (nSlottedType==0 || nSlottedType==1))
			{
				ptDrill = ptRef+vecZDrill*dThisDepth;
				dRadius = dDiameterSink2/2;
				dDrillDepth =dDepthSink2;
				Drill drillSink2(ptDrill,ptDrill-vecZDrill*dDepthSink2, dRadius);
				drillSink2.addMeToGenBeamsIntersect(gbsDrill);
				pline.createCircle(ptDrill,vecZDrill, dRadius);		plines.append(pline);
				pline.transformBy(-vecZDrill*dDrillDepth);			plines.append(pline);
			}

		}
		
	// add mortise for slotted hole
		if (gbsSlotted.length()>0)
		{
		// location
			Point3d ptMortise = ptRef;
			Vector3d vecZMortise = vecZDrill;
			Vector3d vecYMortise = vecYDrill ;
			double dZMortise=dThisDepth*2;
			
		// swap tooling side if shortening at refside is enabled	
			if (dRefOffset>0)
			{
				vecZMortise*=-1;
				vecYMortise*=-1;
				ptMortise.transformBy(vecZDrill*dThisDepth);
				dZMortise-=2*dRefOffset;
			}
			ptMortise.vis(3);
		
		// the tool
			Mortise ms(ptMortise , vecX, vecYDrill ,vecZMortise, dLength, dDiameter, dZMortise , 0,0,0);
			ms.cuttingBody().vis(5);
			ms.setEndType(_kFemaleSide);
			ms.setRoundType(_kRound);
			//ms.addMeToGenBeamsIntersect(gbsSlotted);
			for (int i=0;i<gbsSlotted.length();i++)
				gbsSlotted[i].addTool(ms);
		// the pline
			PLine pline(vecZDrill),pline2, pline3;
			pline.addVertex(ptRef +vecYDrill*.5*dDiameter-vecX*.5*(dLength-dDiameter));
			pline.addVertex(ptRef-vecYDrill*.5*dDiameter-vecX*.5*(dLength-dDiameter),1);
			pline.addVertex(ptRef-vecYDrill*.5*dDiameter+vecX*.5*(dLength-dDiameter));
			pline.addVertex(ptRef+vecYDrill*.5*dDiameter+vecX*.5*(dLength-dDiameter),1);
			pline.close();
			pline2= pline;
			pline3= pline2;
			pline.transformBy(vecZDrill*dRefOffset);
			if (!bHasSink1 && (nSlottedType==1 || nSlottedType==3))
				plines.append(pline);
			
			pline.transformBy(vecZDrill*dThisDepth);
			if (!bHasSink2 && (nSlottedType==2 || nSlottedType==3))
				plines.append(pline);	
			
		// sink reference side mortise
			if (bHasSink1  && (nSlottedType==1 || nSlottedType==3))
			{
				ptMortise = ptRef;
				vecZMortise = vecZDrill;
				CoordSys cs;
				double dFactor = dDiameterSink1/dDiameter;
				cs.setToAlignCoordSys(ptMortise ,vecX,vecY,vecZ,ptMortise ,vecX*dFactor,vecY*dFactor,vecZ*dFactor);
				pline2.transformBy(cs);
				plines.append(pline2);

			// the tool
				Mortise ms1(ptMortise , vecX, vecYDrill ,vecZMortise, dLength*dFactor, dDiameterSink1, dDepthSink1*2 , 0,0,0);
				ms1.setEndType(_kFemaleSide);
				ms1.setRoundType(_kRound);
				//ms.addMeToGenBeamsIntersect(gbsSlotted);
				for (int i=0;i<gbsSlotted.length();i++)
					gbsSlotted[i].addTool(ms1);				
			}
		// sink opposite side mortise
			if (bHasSink2 && (nSlottedType==2 || nSlottedType==3))
			{
				ptMortise = ptRef+vecZDrill*dThisDepth;
				CoordSys cs;
				double dFactor = dDiameterSink2/dDiameter;
				cs.setToAlignCoordSys(ptRef,vecX,vecY,vecZ,ptMortise ,vecX*dFactor,vecY*dFactor,vecZ*dFactor);
				pline3.transformBy(cs);
				plines.append(pline3);

			// the tool
				Mortise ms2(ptMortise , vecX, vecYDrill ,-vecZDrill , dLength*dFactor, dDiameterSink2, dDepthSink2*2 , 0,0,0);
				ms2.setEndType(_kFemaleSide);
				ms2.setRoundType(_kRound);
				//ms.addMeToGenBeamsIntersect(gbsSlotted);
				for (int i=0;i<gbsSlotted.length();i++)
					gbsSlotted[i].addTool(ms2);				
			}		
			
			
			
						
		}	
	
	// display
		Display dp(-1);
		for (int i=0;i<plines.length();i++)
			dp.draw(plines[i]);



	// Baufritz
		if (nSpecial==0)
		{
			category = "Baufritz";
			PropString sHWDescription(3, sHWDescriptions,sHWDescriptionName);
			sHWDescription.setDescription("Definiert die verwendeten Verbindungsmittel");		
			sHWDescription.setCategory(category);

			
			String sHWType[] = { "", T("Screw"), T("Screw"), T("Bolt"), T("Bolt")};//Typ
			String sHWModel[] = { "", T("16 x 220"),T("16 x 260"), T("kurz"), T("lang")};//Model
			String sHWMaterial[] = {"", T("Steel"), T("Steel"), T("Steel"), T("Steel")};//Material
			String sHWNotes[] = {"", T("Montage"), T("Montage"), T("Montage"), T("Montage")};//Notizen
			double dHWLength[] = {0, U(220), U(260), U(220), U(220)};//Länge
			double dHWDiam[] = {0,U(16), U(16), U(16), U(16)};//Durchmesser			

			int f = sHWDescriptions.find(sHWDescription);

		// Hardware
			if (f > 0)
			{
				setCompareKey( sHWType[f] + sHWDescriptions[f]);
				Hardware( sHWType[f] , sHWDescriptions[f], sHWModel[f], dHWLength[f], dHWDiam[f], 1, sHWMaterial[f], sHWNotes[f]);
			}
						
		}	



		
	}// END IF single drill	
	
	
	//_ThisInst.coordSys().vecZ().vis(_Pt0,40);
	//_Z0.vis(_Pt0,2);	
	//_ZE.vis(_Pt0+_X0,150);
	




#End
#BeginThumbnail
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
1E36JU()7>_8JE3A)Z?B?_]FX
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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23098: Add property that sets distance from beam axis" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="12/3/2024 9:43:58 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End