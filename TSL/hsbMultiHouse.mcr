#Version 8
#BeginDescription
#Versions
Version 2.6    01.04.2021
HSB-11440 housing tool will not be applied to male beams if set to not round and gap in width = 0 , Author Thorsten Huck

version  value="2.5" date="29nov18" author="thorsten.huck@hsbcad.com"
bugfix endcut, supports angled connections 
revised
new properties to define individual offsets
base grip can be used to modify depth 





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 6
#KeyWords 
#BeginContents
//region Header


/// <summary Lang=en>
/// This tsl creates a housed joinery at a t-connection between a multiple set of beams
/// The female beams can be selected by the element (preference) or by selecting multiple logs.
/// The height of the connection is derived from the maximal height at the connection.
/// The male logs will be stretched.
/// </summary>

/// <summary Lang=de>
/// Dieses TSL erzeugt über eine Mehrfachauswahl an Bohlen eine Verbindung Ausblattung in 
/// den aufstoßenden Bauteilen mittels der Bearbeitungen 'Blatt längs geneigt' und 'Blatt gederht'
/// Die Auswahl der durchlaufenden Bohlen kann aus dem Wandelement (Vorrang) oder einzelnen 
/// Bohlen abgeleitet werden.
/// Die Höhe der Bearbeitung leitet sich aus der maximalen Höhe der aufstoßenden Bohlen im Bereich
/// der Verbindung ab.
/// Die Bohlen der aufstoßenden Wand werden entsprechend gestreckt.
/// </summary>

/// <insert Lang=en>
/// Select a male beam and then a set of female beams.
/// </insert>


/// History
// #Versions
// 2.6 01.04.2021 HSB-11440 housing tool will not be applied to male beams if set to not round and gap in width = 0 , Author Thorsten Huck
/// <version  value="2.5" date="29nov18" author="thorsten.huck@hsbcad.com"> bugfix endcut, supports angled connections </version>
/// <version  value="2.4" date="28nov18" author="thorsten.huck@hsbcad.com"> revised, new properties to define individual offsets, base grip can be used to modify depth </version>
/// <version  value="2.3" date="14nov18" author="thorsten.huck@hsbcad.com"> bugfix tool resolving </version>
/// <version  value="2.2" date="02dec15" author="th@hsbCAD.de"> bugfix gap depth </version>
/// <version  value="2.1" date="10feb15" author="th@hsbCAD.de"> detection of female beam intersection enhanced </version>
/// <version  value="2.0" date="16dec14" author="th@hsbCAD.de"> instance color set to green (3) </version>
/// <version  value="1.9" date="11dec14" author="th@hsbCAD.de"> completely revised, bugfix detection intersection range </version>
/// Version 1.8   13.08.2009   th@hsbCAD.de
/// further enhancements in beam detection
/// Version 1.7   07.08.2009   th@hsbCAD.de
/// further enhancements in beam detection
/// Version 1.6   14.07.2009   th@hsbCAD.de
/// bugfix halflog with toolings at center
/// Version 1.5   10.07.2009   th@hsbCAD.de
/// enhancement for connections with a slight tongue interference
/// Version 1.4   27.04.2008   th@hsbCAD.de
/// new option to determine an offset of the male beam
/// Version 1.3   05.09.2008   th@hsbCAD.de
/// DE   Zuordnung zum Werkzeuglayer der Balken ergänzt
/// EN   Assignment to tool layer of male beams added
/// Version 1.2   11.03.2008   th@hsbCAD.de
/// Umfälzung für aufstoßende Bauteile ergänzt
/// neue Option 'Fuge' definiert Rückschnitt
/// Version 1.1   11.02.2008   th@hsbCAD.de
/// Joinery for male beams added
/// new option 'gap' defines cut back of male beams
/// Version 1.0   08.02.2008   th@hsbCAD.de
// commands
// command to insert
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbMultiHouse")) TSLCONTENT


//End Header//endregion 

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
//end constants//endregion

	
// geometry
	category = T("|Geometry|");
	String sDepthName =T("|Depth|");
	PropDouble dDepth(nDoubleIndex++, U(50), sDepthName);
	dDepth.setCategory(category);

	
	String sReliefName= T("|Relief|");
	String sArRelief[] = {T("|not rounded|"),T("|round|"),T("|relief|"),T("|rounded with small diameter|"),T("|relief with small diameter|"),T("|rounded|")};
	int nArRelief[] ={_kNotRound, _kRound, _kRelief, _kRoundSmall,_kReliefSmall,_kRounded };
	PropString sRelief(nStringIndex++, sArRelief, sReliefName);	
	sRelief.setCategory(category);
	
// gaps
	category = T("|Gaps|");
	String sGapName = T("|Depth| ");
	PropDouble dGap(nDoubleIndex++, U(0), sGapName);
	dGap.setCategory(category);	
	
	String sGapWidthName = T("|Width|");
	PropDouble dGapWidth(nDoubleIndex++, U(0), sGapWidthName);
	dGapWidth.setCategory(category);
	
// offsets
	category = T("|Tool Offset|");
	String sOffsetLeftName= T("|Left|");	
	PropDouble dOffsetLeft(nDoubleIndex++, U(0), sOffsetLeftName);	
	dOffsetLeft.setCategory(category);

	String sOffsetTopName=T("|Top|");	
	PropDouble dOffsetTop(nDoubleIndex++, U(0), sOffsetTopName);	
	dOffsetTop.setCategory(category);
	
	String sOffsetRightName=T("|Right|");	
	PropDouble dOffsetRight(nDoubleIndex++, U(0), sOffsetRightName);	
	dOffsetRight.setCategory(category);
	
	String sOffsetBottomName=T("|Bottom|");;	
	PropDouble dOffsetBottom(nDoubleIndex++, U(0), sOffsetBottomName);	
	dOffsetBottom.setCategory(category);	
	
	
	
	
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// dialog or catalog based properties
		if (_kExecuteKey.length()==0)
			showDialog();
		else
			setPropValuesFromCatalog(_kExecuteKey);		

	// select male beams
		PrEntity  ssB(T("|Select male beam(s)|"),Beam());
		Beam beamsMale[0];
		if (ssB.go())
			beamsMale= ssB.beamSet();

	// at least one male required
		if (beamsMale.length()<1)
		{
			eraseInstance();
			return;	
		}
		// _Beam.append(beamsMale);
		
		
	// select female beams or intersecting walls
		Beam beamsFemale[0];
		PrEntity  ssE(T("|Select intersecting wall or female beam(s)|"),Element());
		ssE.addAllowedClass(Beam());
		if (ssE.go())
		{
			Entity ents[0];
			ents = ssE.set();
			for (int i = 0; i < ents.length(); i++)
			{
				if (ents[i].bIsKindOf(Element()))	
					_Element.append((Element)ents[i]);	
				if (ents[i].bIsKindOf(Beam()))	
				{
					Beam bm = (Beam)ents[i];	
					beamsFemale.append(bm);					
				}	
			}
		}




	// compose beam packs
		Beam beamsAllPacks[0]; // a collector of beams which are packed
		Map mapPacks;
		Body bdPack;
		beamsMale=beamsMale[0].vecD(_ZW).filterBeamsPerpendicularSort(beamsMale);
		for (int i=0;i<beamsMale.length();i++)
		{
			Beam bm0 = beamsMale[i];
			Vector3d vecX = bm0.vecX();	
						
		// init the pack body for the first beam	
			Body bd0(bm0.ptCenSolid(), bm0.vecX(), bm0.vecY(), bm0.vecZ(),bm0.solidLength(),bm0.solidWidth(),bm0.solidHeight()+U(1),0,0,0);
			if (i==0)bdPack=bd0;				

			if (beamsAllPacks.find(bm0)>-1)
			{
				if (i<beamsMale.length()-1)
				{
					Beam bmN = beamsMale[i+1];
					bdPack=Body (bmN .ptCenSolid(), bmN .vecX(), bmN .vecY(), bmN .vecZ(),bmN .solidLength(),bmN .solidWidth(),bmN .solidHeight()+U(1),0,0,0);
				}	
				continue;// do not pack twice		
			}	
			
			Map mapPack;
			mapPack.appendEntity("Beam", bm0);
			Beam beamsPack[] = {bm0};

		// copy the array of others
			Beam bmOthers[0];
			bmOthers=beamsMale;
			for (int j=0;j<bmOthers.length();j++)
			{
				Beam bm1 = bmOthers[j];
				if (bm0==bm1 || beamsAllPacks.find(bm1)>-1)continue;// do not pack twice	
				Body bd1(bm1.ptCenSolid(), bm1.vecX(), bm1.vecY(), bm1.vecZ(),bm0.solidLength(),bm0.solidWidth(),bm1.solidHeight()+U(1),0,0,0);

			// parallel and intersecting
				if (bm1.vecX().isParallelTo(vecX) && bdPack.hasIntersection(bd1))
				{
					bdPack.combine(bd1);
					beamsPack.append(bm1); 
					mapPack.appendEntity("Beam", bm1);		
				}	
			}
			bdPack.vis(i);
			beamsAllPacks.append(beamsPack);
		
		// get the next pack start body
			if (i<beamsMale.length()-1)
			{
				Beam bmN = beamsMale[i+1];
				bdPack=Body (bmN .ptCenSolid(), bmN .vecX(), bmN .vecY(), bmN .vecZ(),bmN .solidLength(),bmN .solidWidth(),bmN .solidHeight()+U(1),0,0,0);
			}
			
		// store packs in map
			mapPacks.appendMap("BeamPack", mapPack);
		}// next i beamsMale

	// prepare tsl cloning
		TslInst tslNew;
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		GenBeam gbAr[0];
		Entity entAr[0];
		Point3d ptAr[1];
		int nArProps[0];
		double dArProps[] = {dDepth, dGap, dGapWidth,dOffsetLeft, dOffsetTop,dOffsetRight,dOffsetBottom};
		String sArProps[] ={sRelief};
		Map mapTsl;
		String sScriptname = scriptName();	



	// loop beam packs
		for (int m=0;m<mapPacks.length();m++)
		{
		// collect beams of pack. the packed beams are considered to be _Beam
			Map mapPack = mapPacks.getMap(m);
			Beam beamsPack[0];
			for (int b=0;b<mapPack.length();b++)
			{
				Entity ent = mapPack.getEntity(b);
				Beam bm=(Beam)ent;
				if (bm.bIsValid())
					beamsPack.append(bm);	
			}// next b

			if(beamsPack.length()<1)continue;
			Vector3d vecX = beamsPack[0].vecX();

			mapTsl.setMap("Male[]", mapPack);

		// determine if insertion is element or beam driven
			if (_Element.length()>0)
			{		
			// loop elements
				for (int e=0;e<_Element.length();e++)
				{
					Element el = _Element[e];
					if (el.vecX().isParallelTo(vecX)) continue;
					entAr.setLength(0);
					entAr.append(el);
					ptAr[0] = Line(beamsPack[0].ptCenSolid(), vecX).intersect(Plane(el.ptOrg(), el.vecZ()),0);
				
				// create the instance
					tslNew.dbCreate(scriptName(), vUcsX,vUcsY,gbAr, entAr, ptAr, 
						nArProps, dArProps, sArProps,_kModelSpace, mapTsl);	
				}
			}
		// all other beams to be considered female
			else
			{
				Map mapFemales;
				for (int e=0;e<beamsFemale.length();e++)
				{
					if (beamsFemale[e].vecX().isParallelTo(vecX)) continue;
					mapFemales.appendEntity("Female", beamsFemale[e]);
				}
				mapTsl.setMap("Female[]", mapFemales);
			// create the instance
				if (mapFemales.length()>0)
				{
					tslNew.dbCreate(scriptName(), vUcsX,vUcsY,gbAr, entAr, ptAr, 
						nArProps, dArProps, sArProps,_kModelSpace, mapTsl);
				}
			}
		}// next m pack	

		eraseInstance();		
		return;
	}	
//end on insert________________________________________________________________________________


// validate references
	Beam beamsMale[0];
	Map mapMales=_Map.getMap("Male[]");	
	for(int i=0;i<mapMales.length();i++)
	{
		Entity ent =mapMales.getEntity(i);
		if(ent.bIsValid() && ent.bIsKindOf(Beam()))
			beamsMale.append((Beam)ent);	
	}	

	if (beamsMale.length()<1)
	{
		reportMessage("\n" + scriptName() + ": " +T("|no male beams detected|"));
		
		eraseInstance();
		return;	
	}
	Beam bmMale = beamsMale[0];
	
// group assignment
	assignToGroups(bmMale ,'T');
	if (_bOnDbCreated)
	{
		_ThisInst.setColor(3);
		setExecutionLoops(2);
	}
	
// optional element ref
	Element el;
	if (_Element.length()>0)
		el =_Element[0];

// vecX
	Vector3d vecX=bmMale.vecX(), vecY=bmMale.vecY(), vecZ=bmMale.vecZ();
	Point3d ptCen = bmMale.ptCenSolid();

// declare ref plane
	Plane pnRef;
	double dZ;
	Vector3d vecZ1;
	
// get female beams
	Beam beamsFemale[0];
	if (!el.bIsValid())
	{
		Map mapFemales=_Map.getMap("Female[]");	
		for(int i=0;i<mapFemales.length();i++)
		{
			Entity ent =mapFemales.getEntity(i);
			if(ent.bIsValid() && ent.bIsKindOf(Beam()))
				beamsFemale.append((Beam)ent);	
		}

	// no females found
		if (beamsFemale.length()<1)
		{
			reportMessage("\n"+T("|No female beams found.|"));
			eraseInstance();
			return;	
		}	
		dZ = beamsFemale[0].dD(vecX);
		vecZ1=beamsFemale[0].vecD(vecX);
		pnRef = Plane(beamsFemale[0].ptCenSolid(),vecZ1);
	}
	else
	{
		vecZ1 = el.vecZ();
		dZ = el.dBeamWidth();
		pnRef = Plane(el.ptOrg()-vecZ1*.5*dZ, el.vecZ());
		Beam beamsEl[] =el.beam();
		for(int i=0;i<beamsEl.length();i++)
			if (beamsMale.find(beamsEl[i])<0)
				beamsFemale.append(beamsEl[i]);	
	}		

// tool coord sys is dependent from first male beam
	Point3d ptRef = Line(ptCen, vecX).intersect(pnRef,0);
	if (vecX.dotProduct(ptRef-ptCen)<0)
	{
		vecX*=-1;
		vecY*=-1;	
	}
	if (vecZ1.dotProduct(vecX)<0)vecZ1*=-1;
	vecY = vecZ1.crossProduct(-vecZ);
	vecZ = vecZ1.crossProduct(vecY);
	pnRef =Plane(ptRef,vecZ1);	
	ptRef = Line(ptCen, vecX).intersect(pnRef,-.5*dZ);
	vecX.vis(ptRef,1);
	vecY.vis(ptRef,3);
	vecZ.vis(ptRef,150);
	pnRef =Plane(ptRef,vecZ1);

// ints
	int nRelief = nArRelief[sArRelief.find(sRelief,0)];	
	int bNoMaleHouse = nRelief == _kNotRound && dGapWidth<dEps && dOffsetLeft==0 && dOffsetRight==0;

// get combined male
	Body bdMale;
	for(int i=0;i<beamsMale.length();i++)
		bdMale.addPart(beamsMale[i].envelopeBody(false,true));
	bdMale.vis(2);

// get mid point of tool
	Point3d ptMid=ptRef;
	pnRef.vis(2);
	PlaneProfile pp = bdMale.getSlice(Plane(ptCen,vecZ1));
	pp.transformBy(vecX * vecX.dotProduct(ptRef - ptCen));
	
	pp.vis(4);	
	LineSeg seg = pp.extentInDir(vecZ);
	if (pp.area()>pow(dEps,2))
		ptMid = seg.ptMid();
	ptMid += vecY * .5 * (dOffsetRight - dOffsetLeft) + vecZ * .5 * (dOffsetBottom - dOffsetTop);		
	ptMid.vis(6);
	
// adjust depth
	if (_kNameLastChangedProp=="_Pt0")
	{
		double dNewDepth = vecZ1.dotProduct(_Pt0 - ptMid);
		if (dNewDepth>dEps)
			dDepth.set(dNewDepth);
		else
			setExecutionLoops(2);
	}
	else
		_Pt0=ptMid+vecZ1*dDepth;
	
// tool size
	double dXT, dYT, dZT;
	dXT = dDepth;
	dYT = bmMale.dD(vecY)-dOffsetLeft-dOffsetRight;
	dZT = abs(vecZ.dotProduct(seg.ptStart()-seg.ptEnd()))-dOffsetTop-dOffsetBottom;

// stretch relevant body
	Body bd, bdInt;
	{ 
		Point3d ptBd = ptMid;
		Vector3d vec = bmMale.vecX() * .5 * bmMale.solidLength();
		double dL = dDepth;
		Point3d pts[] ={ ptCen - vec, ptCen + vec};
		pts.append(ptMid + vecZ1 * dDepth);
		if (pts.length()>1)
		{ 
			pts = Line(ptMid, vecX).orderPoints(pts);
			dL = vecX.dotProduct(pts[pts.length() - 1] - pts[0]);
			Point3d pt = (pts[pts.length() - 1] + pts[0]) / 2;
			ptBd += vecX*vecX.dotProduct(pt - ptBd);	
		}
		bdInt = Body(ptBd,vecX, vecY, vecZ, dL, dYT, dZT,0,0,0); bdInt.vis(3);
	}
	
	Beam bmHouseTools[] = bdInt.filterGenBeamsIntersect(beamsMale);





// any male beam not housed needs to be stretched to avoid infinite length
	for (int i=0;i<beamsMale.length();i++) 
	{ 
		Beam& bm = beamsMale[i];
		if (bmHouseTools.find(bm) >- 1)continue;
		bm.addTool(Cut(ptMid,vecZ1),1); 
		 
	}//next i
	

// tools
	if ((dYT-2*dGapWidth)>0 && (dZT-2*dGapWidth)>0 && abs(dXT-dGap)>0)
	{
	//	the male tooling
		if (bNoMaleHouse)
		{ 
			Point3d pt = ptMid + vecZ1 * dDepth;
			vecZ1.vis(pt,150);
			for (int i=0;i<bmHouseTools.length();i++)
			{
				bmHouseTools[i].addTool(Cut(ptMid+vecZ1*dDepth,vecZ1),1);
			}
		}
		else
		{ 
			House hsMale(ptMid,vecY,vecZ,vecZ1,dYT-2*dGapWidth ,dZT-2*dGapWidth ,abs(dXT),0,0,1);//-dGap
			hsMale.setRoundType(nRelief);
			hsMale.setEndType(_kMaleEnd);
			for (int i=0;i<bmHouseTools.length();i++) //version  value="2.3" date="14nov18" author="thorsten.huck@hsbcad.com"> bugfix tool resolving
			{
				bmHouseTools[i].addTool(Cut(ptMid+vecZ1*dDepth,vecZ1),1);
				bmHouseTools[i].addTool(hsMale,1); 
				
			}			
		}

		
	//	the female tool
		House hsFemale(ptMid,vecY,vecZ,vecZ1,dYT ,dZT ,dXT+dGap,0,0,1);
		hsFemale.setRoundType(nRelief);
		hsFemale.setEndType(_kFemaleSide);
		Body bdTool=hsFemale.cuttingBody();
		
		for(int i=0;i<beamsFemale.length();i++)
			if (beamsFemale[i].envelopeBody(true,true).hasIntersection(bdTool))
				beamsFemale[i].addTool(hsFemale);
	}


// display
	Display dp(0);
	dp.draw(pp);
	dp.draw(pp.extentInDir(vecZ));	
	dp.draw(PLine(ptMid, ptMid+vecZ1*dDepth));	


#End
#BeginThumbnail
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
2FMK*"!B"T:!21TX%6:*`/__9
`



#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.001" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11440 housing tool will not be applied to male beams if set to not round and gap in width = 0" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="4/1/2021 8:59:46 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="meter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End