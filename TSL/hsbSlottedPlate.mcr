#Version 8
#BeginDescription
version  value="1.4" date="12mai2014" author="th@hsbCAD.de"
new context command to subtract regions from the plate

bugfix positioning on curved beams and on beams with applied cuts on the relevant surface</version>


DE
Dieses TSL erzeugt ein Schlitzblech in Abh‰ngigkeit von mehreren St‰ben und Bohrmustern
Anwendung:  W‰hlen Sie den Hauptt‰ger/Binder und danach alle anschlieﬂendenden St‰be. Der zuerst gew‰hlte anschlieﬂende Stab 
definiert die Lage des Stahlteils.

EN
This tsl creates a metalpart in dependency of drill patterns and its beams
insert: Select the main joist and afterwards the connecting beams. the first connecting beam defines the loaction of the metalpart.






#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/// concept
/// this tool generates a connecting metalpart between multiple beams. as it is a t-tool at least the main beams have to connect like a T.
/// the metalpart is derived from its drill patterns. these drill patterns are individual instances in dependency of one beam.
/// the shape is a result of the merge of all patterns. the location is dependent from the location of the first male beam
/// in the selection set.

/// <summary Lang=de>
/// Dieses TSL erzeugt ein Schlitzblech in Abh‰ngigkeit von mehreren St‰ben und Bohrmustern
/// </summary>

/// <summary Lang=en>
/// This tsl creates a metalpart in dependency of drill patterns and its beams
/// </summary>

/// <insert Lang=de>
/// W‰hlen Sie den Hauptt‰ger/Binder und danach alle anschlieﬂendenden St‰be. Der zuerst gew‰hlte anschlieﬂende Stab 
/// definiert die Lage des Stahlteils.
/// </insert>

/// <insert Lang=en>
/// Select the main joist and afterwards the connecting beams. the first connecting beam defines the loaction of the metalpart.
/// </insert>

/// History
///<version  value="1.4" date="12mai2014" author="th@hsbCAD.de"> new context command to subtract regions from the plate</version>
///<version  value="1.3" date="29feb2012" author="th@hsbCAD.de"> bugfix positioning on curved beams and on beams with applied cuts on the relevant surface</version>
///<version  value="1.2" date="27feb2012" author="th@hsbCAD.de"> properties on insert bugfix</version>
///<version  value="1.1" date="14feb2012" author="th@hsbCAD.de"> publishes Dimrequests </version>
///<version  value="1.0" date="10feb2012" author="th@hsbCAD.de"> initial </version>

// basics and props
	U(1,"mm");
	double dEps = U(0.1);
	String sChildName = "hsbDrillPattern".makeUpper();
	PropDouble dThickness(0, U(6), T("|Thickness Steelplate|"));
	dThickness.setDescription(T("|Specifies the thickness of the steelplate.|"));
	PropDouble dYSlot (2, U(8), T("|Slot Width|"));
	dYSlot.setDescription(T("|Specifies the width of the slot.|"));
	PropDouble dExtraDiam(1, U(2), T("|Additional Diameter Drills|"));
	dExtraDiam.setDescription(T("|The increment of the drill diameter in the metalpart in relation to the fastener diameter.|"));	
	PropDouble dZOffset(3, U(0), T("|Z-Offset from Axis|"));
	dZOffset.setDescription(T("|The translation in Z-Direction from the axis of the beam.|"));
	
// declare arrays for tsl cloning
	TslInst tslNew;
	Vector3d vUcsX = _X0;
	Vector3d vUcsY = _Y0;
	GenBeam gbAr[1];
	Entity entAr[0];
	Point3d ptAr[1];
	int nArProps[0];
	double dArProps[0];
	String sArProps[0];
	Map mapTsl;
	String sScriptname = sChildName ;

// on insert
	if (_bOnInsert) 
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();
		
		_Beam.append(getBeam(T("|Select main joist|")));
	// selection of beams to be processed
		Entity entsGb[0];	
		PrEntity ssBm(T("|Select secondary Beam(s)|"), Beam());
  		if (ssBm.go())
	    	_Beam.append(ssBm.beamSet());
	
	// validate
		if (_Beam.length()<2)
		{
			eraseInstance();
			return;			
		}
		_Beam.swap(0,1);

	// create an instance to show the pattern dialog
		gbAr[0] = _Beam[0];
		tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
			nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
		if (tslNew.bIsValid())
		{
			tslNew.showDialog();	
			if (tslNew.bIsValid())
			{
				tslNew.setCatalogFromPropValues(T("|_LastInserted|"));
				tslNew.dbErase();
			}
				
		}
		else
		{
			reportNotice("\n\n\n**** " +scriptName() + "********************************\n"+ T("|The creation of a drill pattern instance has failed.|") + 
				"\n" + T("|Please ensure that the drill pattern tsl is \npresent in your current drawing.|") + "\n\n" + 
				T("|TSL Name|") + ": " + sChildName + "\n\n"  + T("|Tool will be deleted.|") + "\n********************************************************");	
			eraseInstance();
		}
		return;
	}


// create drill patterns on insert
	if (_bOnDbCreated)
	{
		ptAr[0] = _Pt0;
		mapTsl.setEntity("parent",_ThisInst);
		
	// dbCreate the drill patterns
		for (int i = 0; i <_Beam.length(); i++)
		{
			mapTsl.setInt("index",i);
			gbAr[0] = _Beam[i];
			
			tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
				nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
			if (tslNew.bIsValid())
			{
				tslNew.setPropValuesFromCatalog(T("|_LastInserted|"));
				_Entity.append(tslNew);	
			}
		}			
	}
	
// beams
	Beam bmAr[0];
	bmAr = _Beam;

// base coord sys
	Vector3d vx,vy,vz;
	vx = _X0;
	vy = _Y0;
	vz = _Z0;
	
	vx.vis(_Pt0,1);
	vy.vis(_Pt0,3);
	vz.vis(_Pt0,150);
	
	Point3d ptRefPlate=_Pt0+vz*dZOffset;

// collect add and subtract plines from map
	EntPLine eplAdditives[0], eplSubtractives[0];
	Map mapAdd = _Map.getMap("Additive[]");
	Map mapSub = _Map.getMap("Subtractive[]");	
	for (int i=0;i<mapAdd.length();i++)
	{
		Entity ent = mapAdd.getEntity(i);
		EntPLine epl = (EntPLine)ent;
		if (epl.bIsValid() && eplAdditives.find(epl)<0)
			eplAdditives.append(epl);		
	}
	for (int i=0;i<mapSub .length();i++)
	{
		Entity ent = mapSub.getEntity(i);
		EntPLine epl = (EntPLine)ent;
		if (epl.bIsValid() && eplSubtractives.find(epl)<0)
			eplSubtractives.append(epl);		
	}
	

// trigger:Add Drill Pattern		
	String sTriggerAddPattern = T("|Add Drill Pattern|");
	addRecalcTrigger(_kContext, sTriggerAddPattern );			
	if (_bOnRecalc && _kExecuteKey==sTriggerAddPattern ) 
	{	
		Entity ents[0];
		PrEntity ssE(T("|Select Pattern(s)|"), TslInst());
  		if (ssE.go())
	    	ents= ssE.set();
		for (int i=0;i<ents.length();i++)
		{
			TslInst tsl = (TslInst)ents[i];
			if (tsl.bIsValid() && tsl.scriptName().makeUpper()==sChildName && _Entity.find(ents[i])<0)
				_Entity.append(ents[i]);		
		}
	}


// trigger:Add PLine Contour		
	String sTriggerAddContour= T("|Add Contour|");
	addRecalcTrigger(_kContext, sTriggerAddContour);		
	if (_bOnRecalc && _kExecuteKey==sTriggerAddContour) 
	{	
		Entity ents[0];
		PrEntity ssE(T("|Select Polyline(s)|"), EntPLine());
  		if (ssE.go())
	    	ents= ssE.set();
		for (int i=0;i<ents.length();i++)
		{
			EntPLine epl= (EntPLine)ents[i];
			if (epl.bIsValid() && eplAdditives.find(ents[i])<0)
			{
				_Entity.append(epl);
				eplAdditives.append(epl);	
				mapAdd.appendEntity("epl", epl);

			// if it was an subtractive pline before remove from list
				int n = eplSubtractives.find(epl);
				if (n>-1)
				{
					eplSubtractives.removeAt(n);
					mapSub.removeAt(n,true);
					_Map.setMap("Subtractive[]",mapSub);
				}	
								
			}
		}
		_Map.setMap("Additive[]",mapAdd);
	}
// trigger:Subtract PLine Contour		
	String sTriggerSubtractContour= T("|Subtract Contour|");
	addRecalcTrigger(_kContext, sTriggerSubtractContour);		
	if (_bOnRecalc && _kExecuteKey==sTriggerSubtractContour) 
	{	
		Entity ents[0];
		PrEntity ssE(T("|Select Polyline(s)|"), EntPLine());
  		if (ssE.go())
	    	ents= ssE.set();
		for (int i=0;i<ents.length();i++)
		{
			EntPLine epl= (EntPLine)ents[i];
			if (epl.bIsValid() && eplSubtractives.find(ents[i])<0)
			{
				_Entity.append(epl);			
				eplSubtractives.append(epl);	
				mapSub.appendEntity("epl", epl);
				
			// if it was an additive pline before remove from list
				int n = eplAdditives.find(epl);
				if (n>-1)
				{
					eplAdditives.removeAt(n);
					mapAdd.removeAt(n,true);
					_Map.setMap("Additive[]",mapAdd);
				}		
			}				
		}
		_Map.setMap("Subtractive[]",mapSub);		
	}
	

		
// collect patterns and plines from _Entity
	TslInst tslPattern[0];
	for (int i=0;i<_Entity.length();i++)		
	{
		setDependencyOnEntity(_Entity[i]);
		TslInst tsl = (TslInst)_Entity[i];
		if (tsl.bIsValid() && tsl.scriptName().makeUpper()==sChildName)
		{
			Map map = tsl.map();
			map.setInt("index",i);
			tsl.setMap(map);
			tslPattern.append(tsl);	
			//PLine(tsl.ptOrg()-tsl.coordSys().vecX()*U(500),tsl.ptOrg(),_Pt0).vis(i);	
		}	
	}
	
// Display
	Display	dp(5);
	
	
// no patterns found
	if (tslPattern.length()<1)
	{
		reportMessage("\n"+ T("|No drill Pattern found.|") + " " + T("|Tool will be deleted.|"));
		eraseInstance();
		return;
		//dp.draw(scriptName(),_Pt0,vx,vy,0,0,_kDevice);	
	}
	
// loop patterns to detect shape, don't stretch metalpart for female beam
	PlaneProfile ppShape(CoordSys(_Pt0,vx,vy,vz));
	for (int i=0;i<tslPattern.length();i++)
	{
		Map map = tslPattern[i].map();
		double dX =map.getDouble("dX");
		double dY =map.getDouble("dY");
		double dThisDiam =map.getDouble("Diameter");
		Point3d ptRef = map.getPoint3d("ptRef");		
		ptRef.transformBy(vz*vz.dotProduct(ptRefPlate-ptRef));
		
		Vector3d vxP, vyP, vzP;
		vzP=vz;		
		vyP=tslPattern[i].coordSys().vecX().crossProduct(-vz);
		vyP.normalize();
		vxP=tslPattern[i].coordSys().vecY().crossProduct(vz);	//vxP.vis(ptRef,i);
		vxP.normalize();

		
	// the _Beam of this pattern
		Beam bmTsl[0];
		bmTsl = tslPattern[i].beam();
	
	// plate pline	
		PLine plPlate(vz);	
		
	// rectangle for main plate		
		if (bmTsl.length()>0 && bmTsl[0]==_Beam[1])
		{
			LineSeg lsPlate(ptRef-.5*(vxP*(dX+3*dThisDiam)+vyP*dY),ptRef+.5*(vxP*dX+vyP*dY));
			plPlate.createRectangle(lsPlate,vxP,vyP);	
		}
	// polygon for secondary
		else
		{
			Point3d pt = ptRef-.5*(vxP*(dX+3*dThisDiam)+vyP*dY);
			plPlate.addVertex(pt);
			pt = ptRef -.5*(vxP*(dX+3*dThisDiam)-vyP*dY);
			plPlate.addVertex(pt);
			pt = Line(pt,vxP).intersect(_Plf,.5*_Beam[1].dD(_X0));
			plPlate.addVertex(pt);
			pt = ptRef -.5*(vxP*dX+vyP*dY);
			pt = Line(pt,vxP).intersect(_Plf,.5*_Beam[1].dD(_X0));
			plPlate.addVertex(pt);
			plPlate.close();
		}

	// add slot
		if (bmTsl.length()>0)
		{
			PlaneProfile ppPlate(plPlate);
			LineSeg lsSlot=ppPlate.extentInDir(vxP);
			lsSlot.transformBy(vz*dZOffset);
			//lsSlot.vis(3);
			double dXSlot = abs(vxP.dotProduct(lsSlot.ptStart()-lsSlot.ptEnd())) + 2*tslPattern[i].propDouble(6);
			double dZSlot = abs(vyP.dotProduct(lsSlot.ptStart()-lsSlot.ptEnd())) + 2*tslPattern[i].propDouble(7);
			Point3d ptSlot=lsSlot.ptMid();
			ptSlot.transformBy(vz*vz.dotProduct(ptRefPlate-ptSlot));
			Slot slot(ptSlot, vxP, -vzP,vyP,dXSlot, dYSlot, dZSlot,0,0,0);
			bmTsl[0].addTool(slot);
		}
		
	// build shape
		if (ppShape.area()<pow(dEps,2) && plPlate.area()>pow(dEps,2))
			ppShape	= PlaneProfile(plPlate);
		else
			ppShape.joinRing(plPlate,_kAdd);

		//plPlate.vis(i);
		
	}// next i pattern
	//ppShape.vis(252);

// collect optional additive and subtractive plines	
	PLine plAdditives[0],plSubtractives[0];	
	for (int i=0;i<eplAdditives.length();i++)			plAdditives.append(eplAdditives[i].getPLine());
	for (int i=0;i<eplSubtractives.length();i++)		plSubtractives.append(eplSubtractives[i].getPLine());	

// add contour plines 
	for (int i=0;i<plAdditives.length();i++)
		if (plAdditives[i].area()>pow(dEps,2))
			ppShape.joinRing(plAdditives[i],_kAdd);
// subtract contour plines 
	for (int i=0;i<plSubtractives.length();i++)
		if (plSubtractives[i].area()>pow(dEps,2))
			ppShape.joinRing(plSubtractives[i],_kSubtract);

// cleanup the shape
	double dCleanupValue = U(4);
	ppShape.shrink(dCleanupValue);
	ppShape.shrink(-dCleanupValue);
	
	
// create the body from the rings of the shape
	ppShape.vis(3);
	Body bd;
	PLine plRings[0];
	int bIsOp[0];
	plRings=ppShape.allRings();
	bIsOp=ppShape.ringIsOpening();	
	for (int r=0;r<plRings.length();r++)	
		if (!bIsOp[r])
			bd.addPart(Body(plRings[r],vz*dThickness,0));

	for (int r=0;r<plRings.length();r++)	
		if (bIsOp[r])
			bd.subPart(Body(plRings[r],vz*dThickness,0));

// declare a map for dimrequests
	Map mapRequests;	

			
// drill the plate
	for (int i=0;i<tslPattern.length();i++)
	{
		Map map = tslPattern[i].map();
		double dThisDiam =map.getDouble("Diameter")+dExtraDiam;
		Point3d ptRef = map.getPoint3d("ptRef");		
		Point3d ptDr[0];
		ptDr = map.getPoint3dArray("ptDr");

		Vector3d vxP, vyP, vzP;
		vzP=vz;		
		vyP=tslPattern[i].coordSys().vecX().crossProduct(-vz);
		vyP.normalize();
		vxP=tslPattern[i].coordSys().vecY().crossProduct(vz);	//vxP.vis(ptRef,i);
		vxP.normalize();
		
		Map mapRequest;
		mapRequest.setPoint3dArray("points", ptDr);
		mapRequest.setVector3d("vecX", vxP);
		mapRequest.setVector3d("vecY", vyP);
		mapRequest.setVector3d("vecZ", vzP);
		mapRequest.setDouble("radius", dThisDiam /2);
		mapRequest.setString("Stereotype", "Drill");
		mapRequest.setVector3d("AllowedView", vzP);
		mapRequests.appendMap("DimRequest",mapRequest);
			
		for (int x=0;x<ptDr.length();x++)			
		{
		//( drill with an additional increment	
			Drill dr(ptDr[x] -vzP*U(1000),ptDr[x] +vzP*U(1000),dThisDiam/2);
			bd.addTool(dr);	
			
		}			
	}

// draw the metalpart and store all dimrequests
	dp.draw(bd);
	_Map.setMap("DimRequest[]",mapRequests);	
	
	
			
	
			






#End
#BeginThumbnail
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
*1112&%%%%`'_V9QV
`






#End