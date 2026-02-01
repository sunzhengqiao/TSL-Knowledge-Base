#Version 8
#BeginDescription
version  value="1.5" date="04sep15"author="thorsten.huck.com"
 UI updated 


DE
Dieses TSL erzeugt ein Schlitzblech in Abhängigkeit von mehreren Stäben und Bohrmustern
Anwendung:  Wählen Sie den Haupttäger/Binder und danach alle anschließendenden Stäbe. Der zuerst gewählte anschließende Stab 
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
#MinorVersion 5
#KeyWords 
#BeginContents
/// concept
/// this tool generates a connecting metalpart between multiple beams. as it is a t-tool at least the main beams have to connect like a T.
/// the metalpart is derived from its drill patterns. these drill patterns are individual instances in dependency of one beam.
/// the shape is a result of the merge of all patterns. the location is dependent from the location of the first male beam
/// in the selection set.

/// <summary Lang=de>
/// Dieses TSL erzeugt ein Schlitzblech in Abhängigkeit von mehreren Stäben und Bohrmustern
/// </summary>

/// <summary Lang=en>
/// This tsl creates a metalpart in dependency of drill patterns and its beams
/// </summary>

/// <insert Lang=de>
/// Wählen Sie den Haupttäger/Binder und danach alle anschließendenden Stäbe. Der zuerst gewählte anschließende Stab 
/// definiert die Lage des Stahlteils.
/// </insert>

/// <insert Lang=en>
/// Select the main joist and afterwards the connecting beams. the first connecting beam defines the loaction of the metalpart.
/// </insert>

/// History
///<version  value="1.5" date="04sep15" author="thorsten.huck.com"> UI updated </version>
///<version  value="1.4" date="25aug15" author="thorsten.huck.com"> additional contour can now also be inserted by picking points </version>
///<version  value="1.3" date="29feb2012" author="th@hsbCAD.de"> bugfix positioning on curved beams and on beams with applied cuts on the relevant surface</version>
///<version  value="1.2" date="27feb2012" author="th@hsbCAD.de"> properties on insert bugfix</version>
///<version  value="1.1" date="14feb2012" author="th@hsbCAD.de"> publishes Dimrequests </version>
///<version  value="1.0" date="10feb2012" author="th@hsbCAD.de"> initial </version>

// basics and props
	U(1,"mm");
	double dEps = U(0.1);
	String sChildName = "hsbDrillPattern";
	PropDouble dThickness(0, U(6), T("|Thickness Steelplate|") + " (t)");
	dThickness.setDescription(T("|Specifies the thickness of the steelplate.|"));
	PropDouble dYSlot (2, U(8), T("|Slot Width|") + " (T)");
	dYSlot.setDescription(T("|Specifies the width of the slot.|"));
	PropDouble dExtraDiam(1, U(2), T("|Additional Diameter Drills|") + " (E)");
	dExtraDiam.setDescription(T("|The increment of the drill diameter in the metalpart in relation to the fastener diameter.|"));	
	PropDouble dZOffset(3, U(0), T("|Z-Offset from Axis|") + " (dZ)" );
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
	
// add triggers
	String sTrigger[] = {T("|Add Drill Pattern|"),T("|Add Contour|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);	

// trigger0:Add Drill Pattern					
	if (_bOnRecalc && _kExecuteKey==sTrigger[0]) 
	{	
		Entity ents[0];
		PrEntity ssE(T("|Select Pattern(s)|"), TslInst());
  		if (ssE.go())
	    	ents= ssE.set();
		for (int i=0;i<ents.length();i++)
		{
			TslInst tsl = (TslInst)ents[i];
			if (tsl.bIsValid() && tsl.scriptName().makeUpper()==sChildName.makeUpper() && _Entity.find(ents[i])<0)
				_Entity.append(ents[i]);		
		}
	}


// trigger1:Add PLine Contour				
	if (_bOnRecalc && _kExecuteKey==sTrigger[1]) 
	{	
		Entity ents[0];
		PrEntity ssE(T("|Select Polyline(s)|") + " " + T("|<Enter> to pick points|"), EntPLine());
  		if (ssE.go())
	    	ents= ssE.set();
		for (int i=0;i<ents.length();i++)
		{
			EntPLine epl= (EntPLine)ents[i];
			if (epl.bIsValid() && _Entity.find(ents[i])<0)
				_Entity.append(ents[i]);	
		}
		
	// request points
		if (ents.length()<1)
		{
		// declare jig entpline
			EntPLine eplJig;	
		
		// get base offset
			Point3d pts[0];
			pts.append(getPoint(T("|Pick first point|")));
			while (1) 
			{
				PrPoint ssP("\n" + T("|pick next vertex, <Enter> to close contour|"),pts[pts.length()-1]); 
				if (ssP.go()==_kOk) 
				{
					if (eplJig.bIsValid())eplJig.dbErase();
					pts.append(ssP.value()); // append the selected points to the list of grippoints _PtG
	
				// create entPline
					PLine pl(vz);
					for (int i=0;i<pts.length();i++)
					{
						pl.addVertex(pts[i]);	
					}				
					eplJig.dbCreate(pl);
					eplJig.setColor(3);
					eplJig.assignToGroups(_Beam[0], 'T'); // just in case if the user breaks the command 
				}
				else
					break; // out of infinite while
			}
			if (eplJig.bIsValid())eplJig.dbErase();
			
		// create entPline
			PLine pl(vz);
			for (int i=0;i<pts.length();i++)
			{
				pl.addVertex(pts[i]);	
			}	
			pl.close();
			if (pl.area()>pow(dEps,2))
			{
				EntPLine epl;
				epl.dbCreate(pl);
				epl.assignToGroups(_Beam[0], 'T');
				_Entity.append(epl);	
			}
		}	
	}


// collect patterns and plines from _Entity
	TslInst tslPattern[0];
	PLine plAdd[0];
	for (int i=0;i<_Entity.length();i++)
	{
		setDependencyOnEntity(_Entity[i]);
		TslInst tsl = (TslInst)_Entity[i];
		if (tsl.bIsValid() && tsl.scriptName().makeUpper()==sChildName.makeUpper())
		{
			Map map = tsl.map();
			map.setInt("index",i);
			tsl.setMap(map);
			tslPattern.append(tsl);	
			//PLine(tsl.ptOrg()-tsl.coordSys().vecX()*U(500),tsl.ptOrg(),_Pt0).vis(i);	
		}
		else
		{
			EntPLine epl = (EntPLine )_Entity[i];
			plAdd.append(epl.getPLine());	
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
			lsSlot.vis(3);
			double dXSlot = abs(vxP.dotProduct(lsSlot.ptStart()-lsSlot.ptEnd())) + 2*tslPattern[i].propDouble(6);
			double dZSlot = abs(vyP.dotProduct(lsSlot.ptStart()-lsSlot.ptEnd())) + 2*tslPattern[i].propDouble(7);
			Point3d ptSlot=lsSlot.ptMid();
			ptSlot.transformBy(vz*vz.dotProduct(ptRefPlate-ptSlot));
			Slot slot(ptSlot, vxP, -vzP,vyP,dXSlot, dYSlot, dZSlot,0,0,0);
			//slot.cuttingBody().vis(3);
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

// add contour plines 
	for (int i=0;i<plAdd.length();i++)
		if (plAdd[i].area()>pow(dEps,2))
			ppShape.joinRing(plAdd[i],_kAdd);


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
1($10JCH`,`4ZB@`HHHH`_]GC
`

#End