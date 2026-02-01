#Version 8
#BeginDescription
/// Version 1.3   th@hsbCAD.de   20.02.2013
/// bugfix distribution

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl creates a distribution of Exposed Rafter Eaves in dependency of one or multiple roofplanes and a given location.
/// One can use extrusionprofiles (reference point must be centered to the bounding box) or use rectangular shapes.
/// The tool will stay dynamic in generation of the beams if you change properties. One can also force the generation
/// by the context commands
/// </summary>

/// <insert>
/// Select one or multiple roofplanes. If you have selected multiple roofplanes you must select a closed polyline which
/// represents the location of the distribution end. On a single roofplane selection you may well pick a point for this location
/// </insert>

/// <property name="visible Width">
/// Determines the visible width of an extrusion profile or the width of rectangular shapes. Changing this property will regenerate
/// all Exposed Rafter Eaves.
/// </property name>

/// <command name="Generate Beams">
/// This command will delete all existing Exposed Rafter Eaves and create a new distribution.
/// </command>

/// <command name="Delete Beams">
/// This command will delete all existing Exposed Rafter Eaves.
/// </command>

/// <remark>
/// This tsl requires the tsl mapIO_LayerAssignment in the default tsl path (<hsbCompany>\tsl\) or to be present in the drawing
/// </remark>

/// <property Gruppe, Layername oder Zonenbuchstabe Lang=de>
/// Diese Eigenschaft gestattet dem Benutzer eine variable Steuerung der Layer,-
/// bzw Gruppenzuordnung des TSL's
/// Gültige Eingaben sind existierende Gruppennamen (z.B. Haus\Dach\Zange), freie 
/// Layernamen oder Zonenbuchstaben (C,I,J,T,Z)
/// Die Eingabe eines gültigen Gruppennamens ordnet das TSL der betreffenden Gruppe zu.
/// Wird ein gültiger Zonenbuchstabe eingegeben und ist das abhängige Bauteil einer Gruppe
/// zugeordnet, so wird das TSL dem entsprechenden Gruppenlayer zugewiesen und ist
/// dadurch über den Reiter Einstellungen in der Konsole steuerbar (I = Information, 
/// T = Werkzeug etc).
/// Entspricht die Eingabe weder einem gültigen Gruppennamen, noch einem Zonenbuchstaben,
/// so wird ein Layer mit dem angegebenen Namen erzeugt. Ungültige Buchstaben des
/// Layernamens werden automatisch ersetzt.
/// </property>

/// <property Group, Layername or Zone Character Lang=en>
/// This property enables a flexible group or layer control of the tsl
/// Valid entries are existing group names (i.e. House\Roof\Rafter), Layernames
/// or zone characters.
/// If you enter a valid group name the instance will be assigned to this group.
/// Entering a valid zone character (C,I,J,T,Z) will assign the instance to the 
/// designated layer of the group if the linked instance is also assigned to a group.
/// If the entered string is not a valid group name and not a valid zone character it
/// will assign the instance to a new layer with the given name. Invalid characters will
/// be automatically replaced.
/// </property>

/// History
/// Version 1.3   th@hsbCAD.de   20.02.2013
/// bugfix distribution
/// Version 1.2   th@hsbCAD.de   14.01.2010
/// Version 1.1   th@hsbCAD.de   09.08.2009
/// english terminology corrected
/// supports now offset location if rafters have a plump cut
/// any overlapping of the beams regarding the roofplane outline will be trimmed to fit
/// Version 1.0   th@hsbCAD.de   07.08.2009
/// initial



// basics and props
	U(1,"mm");
	double dEps =U(.1);
	String sArNY[] = { T("|No|"), T("|Yes|")};


	String propNameExtr = T("|Extrusion profile|");
	PropString sExtrusionProfile(0, ExtrProfile().getAllEntryNames(), propNameExtr);
	String propNameWidth = T("|visible|") + " " + T("|Width|");
	PropDouble dVisWidth(0, U(121), propNameWidth);
	String propNameHeight= T("|Height|");
	PropDouble dHeight(1, U(21), propNameHeight);

	PropDouble dAdditionalWidth(2, U(0), T("|Additional Width|"));
	
	PropString sMat(1, "", T("|Material|"));
	PropString sGrade(2, "", T("|Grade|"));		
	PropString sName(7, T("|Exposed Rafter Eaves|"), T("|Name|"));
	PropString sLabel(3, "", T("|Label|"));
	PropString sSublabel(4, "", T("|Sublabel|"));	
	PropInt nColor(0, 65, T("|Color|"));	
	PropString sDimStyle(5, _DimStyles, T("|Dimstyle|"));			

	PropString sLayerGroup(6, T("|Exposed Rafter Eaves|"), T("|Group, Layername or Zone Character|"));	
	sLayerGroup.setDescription(T("|Valid entries are existing group names (i.e. House\Roof\Rafter), Layernames or zone characters.|"));
		
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
		// this property should not appear with the inserted (cloned) instance and it's value is stored in the map
		PropDouble dWallOverlap(3, U(30), T("|Gable Wall Overlapping|"));
		showDialog();	
		
		Entity ents[0];
		ERoofPlane erp[0];
	// get the roofplane	
		PrEntity  ssE(T("|Select Roofplane|"),ERoofPlane());
		if (ssE.go())
			ents.append(ssE.set());		
		for (int i=0;i<ents.length();i++)
			erp.append((ERoofPlane)ents[i]);	
		
	// at least the roofplane needed
		if 	(erp.length()<1)
		{
			eraseInstance();
			return;	
		}	
		
		// since the entPline is optional we must use the PREntity instead of the getEntPLine()
		PrEntity  ssPl(T("|Select pline(s)|"),EntPLine());
		Entity entPLines[0];
		if (ssPl.go())
			entPLines.append(ssPl.set());	
				
		// pline selected	
		if (entPLines.length()>0)
		{
			PLine plContour;
			EntPLine epl= (EntPLine)entPLines[0];
			plContour = epl.getPLine();
			
			// if it is a valid pline multiple roofplanes can be processed
			if (plContour.vertexPoints(true).length()>2)
			{
				// declare tsl props
				TslInst tsl;
				String sScriptName = scriptName(); // name of the script
				Vector3d vecUcsX = _XW;
				Vector3d vecUcsY = _YW;
				Beam bmAr[0];
				Entity entAr[2];
				Point3d ptAr[1];
				int nArProps[0];
				double dArProps[0];
				String sArProps[0];	
				Map mapTsl;
				
				sArProps.append(sExtrusionProfile);
				sArProps.append(sMat);				
				sArProps.append(sGrade);				
				sArProps.append(sLabel);
				sArProps.append(sSublabel);								
				sArProps.append(sDimStyle);
				sArProps.append(sLayerGroup);
				sArProps.append(sName);	
				
				nArProps.append(nColor);

				dArProps.append(dVisWidth);
				dArProps.append(dHeight);				
				dArProps.append(dAdditionalWidth);	
				
				entAr[0]=entPLines[0];
					
				mapTsl.setDouble("wallOverlap", dWallOverlap);
																									
				for (int e=0;e<erp.length();e++)
				{
					entAr[1]=erp[e];
					PlaneProfile ppDiff(CoordSys(_PtW,_XW,_YW,_ZW));
					PLine plErp = erp[e].plEnvelope();
					plErp.projectPointsToPlane(Plane(_PtW,_ZW),_ZW);
					ppDiff.joinRing(plErp,_kAdd);
					//ppDiff.subtractProfile(PlaneProfile (plContour));
					ppDiff.vis(3);
					
					// assume the first ring to be valid
					PLine plRings[] = ppDiff.allRings();
					for (int r=0;r<plRings.length();r++)
					{
						Point3d pt[]=plRings[r].vertexPoints(true);
						pt = Line(erp[e].coordSys().ptOrg(),-erp[e].coordSys().vecY()).orderPoints(pt);
						if (pt.length()<1)continue;
						ptAr[0] =pt[0];//_Pt0
						
						tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,bmAr, entAr,ptAr,
							nArProps, dArProps,sArProps, _kModelSpace, mapTsl);

						break;	
					}
				}// next e erp	
			}// end if contour valid			
		}	
		// no pline selected
		else
		{
			_Entity.append(ents[0]);
			_Pt0 = getPoint(T("|Point near end of distribution|"));	
		}					
		return;	
	}// end on insert

// get plate, genbeams and roofplane
	//GenBeam gb[0];
	ERoofPlane erp;
	PLine plOutline;
	Beam bmPlate;
	
	for (int i=0; i<_Entity.length(); i++)
	{
		Entity e = _Entity[i];
		setDependencyOnEntity(_Entity[i]);
		if (e.bIsKindOf(ERoofPlane()))
		{
			erp= (ERoofPlane)e;
		}

		else if (e.bIsKindOf(EntPLine()))
		{
			EntPLine epl = (EntPLine)e;
			plOutline = epl.getPLine();
		}
	}

// at least the roofplane and the plate is needed
	if 	(!erp.bIsValid())
	{
		eraseInstance();
		return;	
	}
	
// declare Standards
	Point3d ptOrg = erp.coordSys().ptOrg();
	Vector3d vx, vy, vz, vyN;
	vx = erp.coordSys().vecX();
	vy = erp.coordSys().vecY();
	vz = erp.coordSys().vecZ();	
	vyN = vy.crossProduct(_ZW).crossProduct(-_ZW);
	vyN.normalize();
	vyN.vis(_Pt0,93);
	vz.vis(_Pt0,150);	


// regenrate the beams on certain events
	int bRegenBeams;

	String sArPropNames[] = {"_Pt0", propNameExtr,propNameHeight,propNameWidth };
	for (int i = 0; i < _PtG.length(); i++)
		sArPropNames.append("_PtG"+i);
	if(sArPropNames.find(_kNameLastChangedProp)>-1)
		bRegenBeams=true;
	if (_bOnDbCreated) 
		bRegenBeams=true;	
	
// add triggers
	String sTrigger[] = {T("|Generate Beams|"),T("|Delete Beams|"), T("|Toggle Direct Editing|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);

// trigger: 
	if ((_bOnRecalc && (_kExecuteKey==sTrigger[0] || _kExecuteKey==sTrigger[1])) || 
		bRegenBeams) 
	{
		// store some values in a temp map
		Map mapTmp;
		mapTmp.setDouble("wallOverlap", _Map.getDouble("wallOverlap"));
		mapTmp.setInt("enableGrips", _Map.getInt("enableGrips"));
		if ( _Map.hasPLine("offsetContour"))mapTmp.setPLine("offsetContour",_Map.getPLine("offsetContour"));
		
		
		for (int i=0;i<_Map.length();i++)
		{
			Map mapBeam=_Map.getMap(i);
			Entity ent = mapBeam.getEntity("bm");
			Beam bm = (Beam)ent;
			if (bm.bIsValid())
				bm.dbErase();		
		}	
		
		// rest main map but restore persistant values
		_Map = mapTmp;
		
		if (_kExecuteKey==sTrigger[0])
			bRegenBeams=true;
	}

// trigger: 
	if ((_bOnRecalc && _kExecuteKey==sTrigger[2]))
	{
		if (_Map.getInt("enableGrips")==false)
			_Map.setInt("enableGrips",true);
		else
			_Map.setInt("enableGrips",false);			
	}
		
// disable grips
	if (!_Map.getInt("enableGrips"))
		_PtG.setLength(0);
	
// roof pp
	PlaneProfile ppErp(erp.plEnvelope());
	LineSeg lsErp = ppErp.extentInDir(vx);	
	ppErp.vis(5);


// calculate the total distribution widt and the even distribution at the eave
	Point3d ptLs[] = {lsErp.ptStart(),lsErp.ptEnd()};	
	ptLs = Line(_Pt0,vyN).orderPoints(ptLs);
	Point3d ptClosestToWall = plOutline.closestPointTo(ptOrg);		
	// the overhang at the eave
	{
		PlaneProfile pp(plOutline);
		pp.intersectWith(ppErp);
		pp.vis(3);
		// assume the biggest ring is the one
		PLine plRings[]=pp.allRings();
		int bIsOp[]=pp.ringIsOpening();
		PLine pl;
		for(int r = 0; r<plRings.length();r++)
			if (plRings[r].area()>pl.area() && !bIsOp[r])
				pl = plRings[r];				
		ptClosestToWall = pl.closestPointTo(ptOrg);//	ptLs[0]
	}
	ptClosestToWall = ptClosestToWall -vx*vx.dotProduct(ptClosestToWall -lsErp.ptMid());	ptClosestToWall .vis(12);
	double dOverhang = vyN.dotProduct(ptClosestToWall -ptLs[0]);	
	
	// the distribution width to the _Pt0
	Point3d ptRef = _Pt0-vx*vx.dotProduct(_Pt0-lsErp.ptMid());	ptRef .vis(12);
	double dTotalOverhang = vyN.dotProduct(ptRef-ptLs[0]);		

// get the default ts-shapes
	PLine plRec(_ZW);
	double dTestLength = abs(vx.dotProduct(lsErp.ptStart()-lsErp.ptEnd()));
	
	// case 1: overhang
	plRec.createRectangle(LineSeg(ptClosestToWall -vx*dTestLength-vyN*dOverhang,ptClosestToWall +vx*dTestLength),vx,vyN);
	plRec.projectPointsToPlane(Plane(ptOrg,vz), _ZW);
	PlaneProfile ppShape(plRec);
	ppShape.intersectWith(ppErp);
	//ppShape.vis(3);	
	LineSeg lsShape = ppShape.extentInDir(vx);	
	Point3d ptShape[] = {lsShape.ptStart(),lsShape.ptEnd()};	
	ptShape= Line(ptClosestToWall,vx).orderPoints(ptShape);
	double dLength = abs(vx.dotProduct(lsShape.ptStart()-lsShape.ptEnd()));	

	// case 2: total overhang
	plRec.createRectangle(LineSeg(ptRef -vx*dTestLength-vyN*dTotalOverhang ,ptRef +vx*dTestLength),vx,vyN);
	plRec.projectPointsToPlane(Plane(ptOrg,vz), _ZW);
	PlaneProfile ppShapeTotal(plRec);
	ppShapeTotal.intersectWith(ppErp);
	ppShapeTotal.vis(2);	
	LineSeg lsShapeTotal = ppShapeTotal.extentInDir(vx);	
	Point3d ptShapeTotal[] = {lsShapeTotal.ptStart(),lsShapeTotal.ptEnd()};	
	ptShapeTotal= Line(ptRef,vx).orderPoints(ptShapeTotal);
	double dLengthTotal = abs(vx.dotProduct(lsShapeTotal.ptStart()-lsShapeTotal.ptEnd()));	
			
// the Extrusionprofile	
	ExtrProfile ep(sExtrusionProfile);
	PlaneProfile ppEp= ep.planeProfile();
	ppEp.transformBy(CoordSys(ptShape[0],-vy,vz,-vx));	
	LineSeg lsEp = ppEp.extentInDir(vy);
	double dEpBounds[] = {dVisWidth,dHeight};
	lsEp.vis(62);
	
// control property height
	if (sExtrusionProfile!=_kExtrProfRectangular)
	{
		dEpBounds[0] = abs(vy.dotProduct(lsEp.ptStart()-lsEp.ptEnd()));
		dEpBounds[1] = abs(vz.dotProduct(lsEp.ptStart()-lsEp.ptEnd()));
		dHeight.set(dEpBounds[1]);
		dHeight.setReadOnly(true);	
	}	
	else
		dHeight.setReadOnly(false);	
		
// calculate the distribution at the eave
	double dWidthEave=abs(vy.dotProduct(lsShape.ptStart()-lsShape.ptEnd()));
	int nEave = (dWidthEave +dEps)/ dVisWidth;
	dWidthEave = (nEave -1)*dVisWidth+dEpBounds[0];
		
// calculate the distribution
	double dWidth =  abs(vy.dotProduct(lsShapeTotal.ptStart()-lsShapeTotal.ptEnd()));
	int n = (dWidth+dEps)/ dVisWidth+1;
	dWidth = (n-1)*dVisWidth+dEpBounds[0];

// the origin is always the left lower corner of a roofplane	
	ptOrg = ptOrg-vx*vx.dotProduct(ptOrg-ptShape[0]);
	ptShape= Line(_Pt0,vy).orderPoints(ptShape);
	ptOrg = ptOrg -vy*vy.dotProduct(ptOrg -ptShape[0]);	

// define a shape which is used for offseting edges
	PLine plEave;
	if (plOutline.vertexPoints(true).length()>2)
	{
		// reduce outline to projected roofplane intersection
		PlaneProfile ppOL(plOutline);
		ppOL.intersectWith(ppErp);

		// reduce outline to even number of eave boards
		Point3d ptEave = ptClosestToWall +vy*(dWidthEave-dOverhang)-vz*dHeight;
		plEave.createRectangle(LineSeg(ptEave -vx*dTestLength-vy*dOverhang,ptEave +vx*dTestLength),vx,vy);
		plEave.projectPointsToPlane(Plane(plOutline.ptStart(),plOutline.coordSys().vecZ()),_ZW);//Plane(ptOrg-dHeight*vz,vz),_ZW);
		plEave.vis(5);
		ppOL.subtractProfile(PlaneProfile(plEave));
	
		// analyse the erp contour to detect gable ends
		// assuming that an gable end is perp to vx
		Point3d pts[]=erp.plEnvelope().vertexPoints(false);
		LineSeg lsGable[0];
		for (int p=0;p<pts.length()-1;p++) 
			if ((pts[p]-pts[p+1]).isPerpendicularTo(vx))
				lsGable.append(LineSeg(pts[p],pts[p+1]))	;

		Plane pn(plOutline.ptStart(),plOutline.coordSys().vecZ());
		lsGable = pn.projectLineSegs(lsGable);
		
		// get all mid grips
		Point3d ptMidGrip[] = ppOL.getGripEdgeMidPoints();
		
		// move outline segments on every detected gable edge by given default value (on creation)
		for (int l=0;l<lsGable.length();l++)
		{ 
			//Point3d ptNext = lsGable[l].ptMid();
			lsGable[l].vis(l);
			Vector3d vxSeg = lsGable[l].ptEnd()-lsGable[l].ptStart();
			vxSeg.normalize();

			// determine which point is closest to ptNext
			int nInd = -1;
			double dDistMin = 0;
			for (int i=0; i<ptMidGrip.length(); i++) 
			{
				Point3d pt = ptMidGrip[i];
				double dDist = Vector3d(lsGable[l].ptMid()-pt).length();
				if (i==0 || dDist<dDistMin)
				{
					dDistMin = dDist;
					nInd = i;
				}
			}		
			
			Point3d ptNext = ptMidGrip[nInd];
			Point3d ptNext2 = ppOL.closestPointTo(ptMidGrip[nInd]+vxSeg*dEps);
			Vector3d vyMove = ptNext2-ptNext;
			vyMove.normalize();
			
			Vector3d vxTmp = ptNext-lsGable[l].ptMid();
			vxTmp.normalize();
				
			Vector3d vxMove = vxTmp.crossProduct(vyMove).crossProduct(-vyMove);
			vxMove.normalize();
			//vxMove.vis(ptNext,1);//nInd);

			ppOL.moveGripEdgeMidPointAt(nInd, vxMove*_Map.getDouble("wallOverlap"));	
			
			// get the outer ring of the offseted
			PLine plRings[]=ppOL.allRings();
			int bIsOp[]=ppOL.ringIsOpening();
			PLine pl;
			for(int r = 0; r<plRings.length();r++)
				if (plRings[r].area()>pl.area() && !bIsOp[r])
					pl = plRings[r];			
			
			if(!_Map.getInt("enableGrips"))			
				_Map.setPLine("offsetContour",pl);
			//pl.vis(55);
						
		}



		// enabled grip editing and show graphics
		if(_Map.hasPLine("offsetContour") && _Map.getInt("enableGrips"))
		{
			PLine pl =_Map.getPLine("offsetContour");
			PlaneProfile ppC = PlaneProfile(pl);
			// get all mid grips
			Point3d ptMidGrip[] = ppC.getGripEdgeMidPoints();	
			if (_PtG.length()<1)
				for(int p= 0; p<ptMidGrip.length();p++)
					_PtG.append(ptMidGrip[p]);
			//pl.vis(1);	


			// the event of dragging a grip should change the offset contour
			if (_kNameLastChangedProp.find("_PtG",0)>-1)
			{
				// get the index of the changed grip
				String s = _kNameLastChangedProp;
				s = s.right(s.length()-4);
				int n = s.atoi();

				// determine which point is closest to ptNext
				int nInd = -1;
				double dDistMin = 0;
				for (int i=0; i<ptMidGrip.length(); i++) 
				{
					Point3d pt = ptMidGrip[i];
					double dDist = Vector3d(_PtG[n]-pt).length();
					if (i==0 || dDist<dDistMin)
					{
						dDistMin = dDist;
						nInd = i;
					}
				}// next i
				
				// move MidGrip and reassign to _PtG
				CoordSys csPl = plOutline.coordSys();
				_PtG[n] = _PtG[n]-csPl.vecZ()*csPl.vecZ().dotProduct(_PtG[n]-ptMidGrip[nInd]);
				Vector3d vMove = _PtG[n]-ptMidGrip[nInd];
				ppC.moveGripEdgeMidPointAt(nInd, vMove);

				// get the outer ring of the offseted
				PLine plRings[]=ppC.allRings();
				int bIsOp[]=ppC.ringIsOpening();
				PLine pl;
				for(int r = 0; r<plRings.length();r++)
					if (plRings[r].area()>pl.area() && !bIsOp[r])
						pl = plRings[r];	
									
				// store the biggest ring
				_Map.setPLine("offsetContour",pl);
				_PtG[n] = ppC.closestPointTo(_PtG[n]);
				pl.vis(3);
			}// end event grip moved
			
			// show graphics for direct editing
			PlaneProfile ppInnerC = ppC;
			ppInnerC.shrink(U(50));
			ppC.subtractProfile(ppInnerC);
			Display dpDirectEdit(12);
			dpDirectEdit.draw(ppC,_kDrawFilled);
		}	
	}//END valid outline selected

// Display
	Display dp(nColor);
	
// collect intersecting beams from erp
	Beam bmRafter[0], bmValleyRafter[0], bmHipRafter[0];
	plRec.createRectangle(LineSeg(ptOrg,ptOrg+vx*2*dLength+vy*(dWidth)),vx,vy);
	plRec.vis(1);
	PlaneProfile ppBc(plRec);
	ppBc.intersectWith(PlaneProfile(erp.plEnvelope()));

	if (_Map.hasPLine("offsetContour"))
	{
		PLine pl = _Map.getPLine("offsetContour");
		pl.projectPointsToPlane(Plane(ptOrg,vz),_ZW);
		ppBc.joinRing(pl,_kSubtract);	
	}

ppBc.transformBy(vz*U(100));
ppBc.vis(12);
ppBc.transformBy(-vz*U(100));

	// the beamcut body is used for the filtering of relevant beams
	Body bdBeamcut;
	
	// create bodies from rings
	PLine plRings[] = ppBc.allRings();
	for (int r=0;r<plRings.length();r++)
	{
		Body bd(plRings[r], -vz*dHeight,1);bd.vis(r);
		bdBeamcut.addPart(bd);
		Beam bmTmp, bmColl[0];
		bmTmp.dbCreate(bd,vx,vy,vz);
		// the capsule intersect does not work on funny shapes
		//bmColl = bmTmp.filterBeamsCapsuleIntersect(erp.beam());
		Beam bmErp[] = erp.beam();
		for (int b=0;b<bmErp.length();b++)
			if (bmTmp.realBody().hasIntersection(bmErp[b].envelopeBody()))
			bmColl.append(bmErp[b]);
		
		
		bmTmp.dbErase();
		for (int b=0;b<bmColl.length();b++)
		{
			
			int excludeTypes[] = {_kValleyRafter,_kTopPlate,_kMidPlate,_kRidge};
			// collect all rafter types without valley rafter
			if (bmRafter.find(bmColl[b])<0 && excludeTypes.find(bmColl[b].type())<0)
			{
				bmRafter.append(bmColl[b]);
				//bmColl[b].envelopeBody().vis(1);
			}
			// collect valley rafters
			else if(bmColl[b].type()==_kValleyRafter && bmValleyRafter.find(bmColl[b])<0)
				bmValleyRafter.append(bmColl[b]);
			// collect hip rafters
			if(bmColl[b].type()==_kHipRafter && bmHipRafter.find(bmColl[b])<0)
				bmHipRafter.append(bmColl[b]);
		}		
	}

// test if any of the rafters has a plump cut
	int bHasPlump;
	Point3d ptBottomFace[0];
	for (int b=0;b<bmRafter.length();b++)
	{
		Beam bm = bmRafter[b];
		Plane pnY(bm.ptCen(),bm.vecD(vx));
		Point3d ptInt[] = erp.plEnvelope().intersectPoints(pnY);
		ptInt = Line(bm.ptCen(),vy).orderPoints(ptInt);
		if (ptInt.length()>0)
		{
			Plane pnX(ptInt[0],vyN);
			if (!vyN.isPerpendicularTo(bm.vecX()))
				ptBottomFace.append(Line(ptInt[0]-vz*dHeight,bm.vecX()).intersect(pnX,0));
		}
		Body bd = bm.envelopeBody();
		bd.intersectWith(Body(ptOrg,vx,vy,vz,U(30000), U(2), U(10000),0,-1,0));
		if (bd.volume() > pow(U(1),3) && bm.type()!=_kHipRafter)
		{
			bHasPlump=true;	
		}
	}	
	ptBottomFace= Line(ptOrg,vy).orderPoints(ptBottomFace);

// calculate the offset in vy direction for plump cuts
	if (ptBottomFace.length()>0 && bHasPlump)
	{
		double d= vy.dotProduct(ptOrg-ptBottomFace[0]);	
		dWidth +=d;
		ptOrg.transformBy(-vy*d);
		// update qty of distribution
		n = (dWidth+dEps)/ dVisWidth+1;
	}

	
// beamcut
	//bdBeamcut.vis(4);
	BeamCut bc(ptOrg,vx,vy,vz, dLength, (n-1)*dVisWidth+dEpBounds[0], dHeight, 1,1,-1);
	//bc.cuttingBody().vis(86);	
	//bc.addMeToGenBeamsIntersect(bmRafter);	

// find potential par houses in any of the involved valleyrafters
	for (int b=0;b<bmValleyRafter.length();b++)
	{
		Beam bm = bmValleyRafter[b];
		Vector3d  vxUp = bm.vecX();
		if (vxUp.dotProduct(_ZW)<0) vxUp*=-1;
		
		// half body of the valley
		Body bdValley = bm.realBody();
		// collect the valley cut
		AnalysedTool tools[] = bm.analysedTools(_bOnDebug);
		AnalysedDoubleCut adcCuts[] = AnalysedDoubleCut().filterToolsOfToolType(tools,_kADCValley);					
		if (adcCuts.length()>0)
		{
			Point3d pt1[] = adcCuts[0].bodyPointsAlongLine();
			if (pt1.length()>0)
			{
				Plane pn(pt1[0],bm.vecD(vx));
				Line ln0(ptOrg,vx);
				Vector3d vDir = vx;
				if (vx.dotProduct(vxUp)<0) vDir*=-1;
				//)Line(ptOrg,vx).intersect(pn,0)-ln0.closestPointTo(_Pt0);
				vDir.normalize();
				vDir.vis(bm.ptCen(),2);
				bdValley.addTool(Cut(pt1[0],bm.vecD(vDir)),0);
				//bdValley .vis(12);	
				
				// get the contour
				PlaneProfile ppValley = bdValley.shadowProfile(Plane(ptOrg,bm.vecD(vz)));
				PlaneProfile ppCut=bc.cuttingBody().shadowProfile(Plane(ptOrg,vz));
				// slightly scale it in x
				CoordSys csScale;
				csScale.setToAlignCoordSys(ptOrg,vDir,vy,vz,ptOrg,vDir*1.1,vy,vz);
				ppCut.transformBy(csScale);
				ppValley.intersectWith(ppCut);
				PLine plRings[] = ppValley.allRings();
				ppValley = PlaneProfile(CoordSys(ptOrg-vz*dHeight,vx,vy,vz));
				for (int r=0;r<plRings.length();r++)
				{
					plRings[r].projectPointsToPlane(Plane(ptOrg,vz),bm.vecD(vz));	
					ppValley.joinRing(plRings[r],_kAdd);
				}	
				ppValley.vis(211);
				
				// the par house
				LineSeg lsPar = ppValley.extentInDir(bm.vecX());
				Point3d ptPar = Line(lsPar.ptMid(),vx).intersect(pn,0);
				double dParLength = abs(bm.vecX().dotProduct(lsPar.ptStart()-lsPar.ptEnd()));
				Point3d ptEdge = Line(pt1[0],vx).intersect(Plane(bm.ptCen(), bm.vecD(-vDir)), .5*bm.dD(vDir));
				ptEdge.vis(56);
				double dParWidth = abs(vx.dotProduct(pt1[0]-ptEdge));
				ParHouse par(ptPar,bm.vecX(),vDir,-vz,dParLength , dParWidth*2  ,dHeight+U(500),0,-1,-1);
				par.setRoundType(_kRound);
				//par.cuttingBody().vis(6);
				bm.addTool(par);
				
			}
		}		
	}

// generate or valididate generated
	PlaneProfile ppBeams[0];
	Beam bmNew, bmArNew[0];
	plRec.createRectangle(LineSeg(ptOrg,ptOrg+vx*2*dLength+vy*dEpBounds[0]),vx,vy);//dVisWidth
	//plRec.vis(6);
	// transform it by half the difference
	if (abs(dVisWidth-dEpBounds[0])>dEps)
		;//plRec.transformBy(.5*(dEpBounds[0]-dVisWidth)*vy);
		
// loop quantity of rows
	for (int i=0;i<n;i++)
	{
		PlaneProfile ppBoard(plRec);//CoordSys(ptOrg-vz*dHeight,vx,vy,vz));
		PLine plErp = erp.plEnvelope();
		if (ptBottomFace.length()>0 && bHasPlump)
			plErp.projectPointsToPlane(Plane(ptOrg-vz*dHeight,vz),_ZW);
		ppBoard.intersectWith(PlaneProfile(plErp));
		//ppBoard.vis(5);
		
		// subtract the offseted contour
		if (_Map.hasPLine("offsetContour"))
		{
			PLine pl = _Map.getPLine("offsetContour");
			pl.projectPointsToPlane(Plane(ptOrg,vz),_ZW);
				
			// move the edge of the first board which does not belong to the eave set
			// for this board we need to offset the cutting contour such that no parts remain due to overlapping of the real/visible width
			if (i==nEave+1)
			{		
				PlaneProfile ppTmp = ppBoard;
				ppTmp.joinRing(pl,_kSubtract);
	
				// move each potential ring
				PLine plRings[] = ppTmp .allRings();
				for (int r=0;r<plRings.length();r++)
				{
					LineSeg lsBd = PlaneProfile(plRings[r]).extentInDir(vx);
					PlaneProfile ppContour(pl);
					Point3d ptMidGrip[] = ppContour.getGripEdgeMidPoints();	
					// determine which point is closest to ptNext
					int nInd = -1;
					double dDistMin = 0;
					for (int i=0; i<ptMidGrip.length(); i++) 
					{
						ptMidGrip[i].vis(2);
						Point3d pt = ptMidGrip[i];
						Point3d ptNext = lsBd.ptMid()+vy*abs(vy.dotProduct(lsBd.ptStart()-lsBd.ptEnd()));
						double dDist = Vector3d(ptNext-pt).length();
						if (i==0 || dDist<dDistMin)
						{
							dDistMin = dDist;
							nInd = i;
						}
					}// next i			
					ptMidGrip[nInd].vis(1);
					ppContour.moveGripEdgeMidPointAt(nInd, -vy*dVisWidth);
					ppBoard.subtractProfile(ppContour);
					
				}// next r
			}// end no eave	
			else
				ppBoard.joinRing(pl,_kSubtract);					
		} // end has map pline

		ppBeams.append(ppBoard);
		
		// create bodies from rings
		PLine plRings[] = ppBoard.allRings();
		for (int r=0;r<plRings.length();r++)
		{
			// get the center point of it
			LineSeg lsBd = PlaneProfile(plRings[r]).extentInDir(vx);
			lsBd.ptMid().vis(3);			

			// the body representing a single board
			Body bd(plRings[r], -vz*dHeight,1);
			if (i==nEave+1)
				bd.vis(2);				
			else
				;//bd.vis(6);		


			// if the body of the board intersects the beamcut body add the tool
			if (bd.hasIntersection(bdBeamcut))
			{
				BeamCut bc;
				if (i==0)
					bc=BeamCut(lsBd.ptMid()-vy*.5*bd.lengthInDirection(vy),vx,vy,vz,bd.lengthInDirection(vx),2*bd.lengthInDirection(vy),bd.lengthInDirection(vz)*2,0,0,0);
				else
					bc=BeamCut(lsBd.ptMid(),vx,vy,vz,bd.lengthInDirection(vx),bd.lengthInDirection(vy),bd.lengthInDirection(vz)*2,0,0,0);
				bc.cuttingBody().vis(1);
				bc.addMeToGenBeamsIntersect(bmRafter);			
			}
			
			if (bRegenBeams && bd.hasIntersection(bdBeamcut))
			{
				bmNew.dbCreate(bd,vx,vy,vz);
				bmNew.setExtrProfile(sExtrusionProfile);	
				bmNew.setMaterial(sMat);
				bmNew.setName(sName);
				bmNew.setGrade(sGrade);
				bmNew.setLabel(sLabel);
				bmNew.setSubLabel(sSublabel);
				bmNew.setColor(nColor);
				
				// args for group assignment
				Map mapIO;
				mapIO.setString("layerGroup", sLayerGroup);
				mapIO.setString("subLayerChar", "Z");
				//mapIO.setEntity("parentEntity");
				mapIO.setEntity("thisEntity", bmNew);
				mapIO.setInt("reportDebug", _bOnDebug);
				
				// group assignment
				int bOk = TslInst().callMapIO("mapIO_LayerAssignment", mapIO);
				if (!bOk)	reportMessage("\ncallMapIO returned false.");
			
				// store in map
				Map mapBeam;
				mapBeam.setInt("row", i);
				mapBeam.setInt("column", r);
				mapBeam.setVector3d("vecRef", bmNew.ptCen()-ptOrg);
				mapBeam.setEntity("bm", bmNew);
				_Map.setMap("row"+i+"col"+r,mapBeam);
				
				// stretch dynamic to valley rafters
				Beam bmStretch[0];
				//bmStretch = bmNew.filterBeamsCapsuleIntersect(bmValleyRafter);
				//for (int s=0;s<bmStretch.length();s++)
				//	bmNew.stretchDynamicTo(bmStretch[s]);
				
				// stretch to valley line	
				bmStretch = bmNew.filterBeamsCapsuleIntersect(bmValleyRafter);
				for (int s=0;s<bmStretch.length();s++)
				{
					Beam bm = bmStretch[s];
					// collect the valley cut
					AnalysedTool tools[] = bm.analysedTools(_bOnDebug);
					AnalysedDoubleCut adcCuts[] = AnalysedDoubleCut ().filterToolsOfToolType(tools,_kADCValley);					
					if (adcCuts.length()>0)
					{
						Point3d pt1[] = adcCuts[0].bodyPointsAlongLine();
						if (pt1.length()>0)
						{ 
							//and stretch to it
							Plane pn(pt1[0],bm.vecD(vx));
							Vector3d vDir = Line(bmNew.ptCen(),vx).intersect(pn,0)-bmNew.ptCen();
							bmNew.addToolStatic(Cut(pt1[0],bm.vecD(vDir)),1);					
						}	
					}
				}// END stretch to valley line	

				// cut at hip line 
				Beam bmHip[0];
				bmHip = bmNew.filterBeamsCapsuleIntersect(bmHipRafter);
				for (int s=0;s<bmHip.length();s++)
				{
					// collect the hip cut
					AnalysedTool tools[] = bmHip[s].analysedTools(_bOnDebug);
					AnalysedCut acCuts[] = AnalysedCut ().filterToolsOfToolType(tools,_kACHip);
					if (acCuts.length() >1)
					{
						Point3d pt1[0], pt2[0];
						pt1 = acCuts[0].bodyPointsInPlane();
						pt2 = acCuts[1].bodyPointsInPlane();	
						for (int p=0; p<pt1.length(); p++)
							for (int q=0; q<pt2.length(); q++)
								if (Vector3d(pt1[p]-pt2[q]).length() <= dEps)
								{
									Plane pn(pt1[p],bmHip[s].vecD(vx));
									Vector3d vDir = Line(bmNew.ptCen(),vx).intersect(pn,0)-bmNew.ptCen();
									bmNew.addToolStatic(Cut(pt1[p],bmHip[s].vecD(vDir)),1);
									p = pt1.length();
									break;
								}		
					}				
				}	
				bmArNew.append(bmNew);		
			}
		}
		plRec.transformBy(vy*dVisWidth);
		//plRec.vis(7);
	}	
	
// if board intersects outline cut at segment
	PLine plContour = erp.plEnvelope();
	Point3d ptContour[] = plContour.vertexPoints(false);
	for (int p=0; p<ptContour.length()-1; p++)
	{
		Vector3d vxSeg, vySeg;
		vxSeg = ptContour[p+1]-ptContour[p];
		double dL = vxSeg.length();
		vxSeg.normalize();
		vySeg = vxSeg.crossProduct(vz);
		vxSeg.vis(ptContour[p],1);
		Vector3d  vySegN = vySeg.crossProduct(_ZW).crossProduct(-_ZW); 
		vySegN .vis(ptContour[p],3);
		// test side
		Point3d pt = (ptContour[p+1]+ptContour[p])/2+vySeg*dEps;
		if (PlaneProfile(plContour).pointInProfile(pt)== _kPointInProfile)
			vySeg*=-1;
		
		Body bdSeg(ptContour[p], vxSeg, vySeg,vxSeg.crossProduct(vySeg),dL, U(1000), U(1000),1,1,0 );
		for (int b=0; b<bmArNew.length(); b++)
		{
			Body bd = bdSeg;
			bd.intersectWith(bmArNew[b].realBody());
			// add a static cut
			if (bd.volume() > pow(dEps,3))
			{
				
				bmArNew[b].addToolStatic(Cut(ptContour[p],vySegN),0);	
			}	
		}			
	}
	

// collect visible and non visible areas
	


// draw
	// draw the outline and a diagonal
	{
		plRec.createRectangle(LineSeg(ptOrg,ptOrg+vx*2*dLength+vy*dWidth),vx,vy);		
		PlaneProfile pp(plRec);
		pp.intersectWith(PlaneProfile(erp.plEnvelope()));
		PLine plRings[] = pp.allRings();
		for (int r=0; r<plRings.length(); r++)
		{
			PlaneProfile ppRing(plRings[r]);
			LineSeg ls = ppRing.extentInDir(vx);
			Point3d pt[] = {ls.ptStart(),ls.ptEnd()};
			PLine pl;
			dp.draw(ppRing);
			for (int i=0; i<pt.length(); i++)
			{
				pt[i] = ppRing.closestPointTo(pt[i]);
				pl.addVertex(pt[i]);
			}
			dp.draw(pl);
		}
	}
	

#End
#BeginThumbnail
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
EB<P6?'3Y&_\`BJN67B[4+W4+2VDAM@DD\:DJK9^\/]JDRC__V0!"
`


#End
