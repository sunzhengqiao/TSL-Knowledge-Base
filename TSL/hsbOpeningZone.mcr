#Version 8
#BeginDescription
#Versions:
Version 1.13 18/03/2025 HSB-23617: Update "RUB-Anker-Aufsatzwand" if hsbOpeningZone is moved , Author Marsel Nakuci
1.12 07.06.2022 HSB-15527: make sure width,height not<0 Author: Marsel Nakuci
1.11 17.11.2021 HSB-13828: update RUB-GV if zone is modified Author: Marsel Nakuci
1.10" date="20okt21" author="marsel.nakuci@hsbcad.com" 

HSB-13559: tsl to work symmetrically, also for negative zones </version>
HSB-10872: update the tsls in _Entity
HSB-6995: delete when 3d construction deleted
trigger potential siblings of parent tsl 
entities that dont belong to an element (.myZoneIndex=0) are excluded




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 13
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This Tsl creates a rectangular milling or saw contour. The tsl can be dependent from the location
/// of other tsl's or from a beam
/// </summary>

/// <insert=en>
/// Select one wall element and pick an insertion point
/// </insert>

/// <command "Add Link" Lang=en>
/// You can link a beam, which is not parallel to the X-Axis of the element or a TSL to create a dependency.
/// If a beam is selected the location and the section will be adapted to the projected beam contour (plate cut outs)
/// </remark>

/// History
/// #Versions:
// 1.13 18/03/2025 HSB-23617: Update "RUB-Anker-Aufsatzwand" if hsbOpeningZone is moved , Author Marsel Nakuci
// 1.12 07.06.2022 HSB-15527: make sure width,height not<0 Author: Marsel Nakuci
// Version 1.11 17.11.2021 HSB-13828: update RUB-GV if zone is modified Author: Marsel Nakuci
///<version  value="1.10" date="20okt21" author="marsel.nakuci@hsbcad.com"> HSB-13559: tsl to work symmetrically, also for negative zones </version>
///<version  value="1.9" date="24feb21" author="marsel.nakuci@hsbcad.com"> HSB-10872: update the tsls in _Entity </version>
///<version  value="1.8" date="16mar20" author="marsel.nakuci@hsbcad.com"> HSB-6995: delete when 3d construction deleted </version>
///<version  value="1.7" date="25sep19" author="thorsten.huck@hsbcad.com"> trigger potential siblings of parent tsl </version>
///<version  value="1.6" date="24.09.19" author="marsel.nakuci@hsbcad.com"> entities that dont belong to an element (.myZoneIndex=0) are excluded </version>
///<version  value="1.5" date="23oct18" author="thorsten.huck@hsbcad.com"> automatische Bereiningung, wenn Elternobjekt dies definiert </version>
///<version  value="1.4" date="22jun15" author="florian.wuermseer@hsbcad.com"> Solid-Bearbeitung korrigiert</version>
///<version  value="1.3" date="22jun15" author="thorsten.huck@hsbcad.com"> die vertikale Verschiebung eines TSL basierten Elternobjektes wird unterstützt. </version>
///<version  value="1.3" date="27may15" author="thorsten.huck@hsbcad.com"> Bearbeitungsseite bleibt auch beim Wechsel der Elementseite erhalten, Bearbeitung wird gelöscht, wenn eine Objektreferenz gesetzt wurde und dieses Objekt gelöscht wird </version>
///<version  value="1.1" date="03apr13" author="th@hsbCAD.de"> Elementzuordnung wechselt, wenn eine TSL Abhängigkeit diese definiert</version>
/// Version 1.0   th@hsbCAD.de   14.01.2010



// basics and prop
	U(1,"mm");
	double dEps=U(.1);
	String sArNY[] = { T("No"), T("Yes")};
	int nArZn[] = {-5,-4,-3,-2,-1,1,2,3,4,5};
	PropInt nZone (0, nArZn, T("|Zone|"),5);
	
	PropDouble dWidth(0, U(100), T("|Width|"));
	PropDouble dHeight(1, U(200), T("|Height|"));
	
	String sCategoryTooling = T("|Tooling|");
	String sArCNCTool[] = {T("|Milling|"), T("|Saw|")};	
	PropString sCNCTool(0, sArCNCTool, T("|Tool|"));	
	sCNCTool.setCategory(sCategoryTooling);	
	PropInt nToolingIndex(1, 0, T("|Tooling Index|"));
	nToolingIndex.setCategory(sCategoryTooling);		
	PropString sOverShoot(1, sArNY, T("|Overshoot|"));	
	sOverShoot.setCategory(sCategoryTooling);	
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();
		_Element.append(getElement());
		_Pt0 = getPoint();
		return;	
	}// end on insert_______________________________________________________________________________________________
	
// declare standards
	if (_Element.length() < 1)
	{
		eraseInstance();
		return;
	}
	
//	return;
// HSB-15527
	if(_kNameLastChangedProp==T("|Width|"))
	{ 
		if (dWidth <dEps)dWidth.set(U(100));
	}
	if(_kNameLastChangedProp==T("|Height|"))
	{ 
		if (dHeight <dEps)dHeight.set(U(100));
	}
// HSB-15527
	if(dWidth<dEps || dHeight<dEps)
	{ 
		setExecutionLoops(2);
		return;
	}
	
// detect if an override of the element has been assigned after swapping the direction of the sleeve
	for (int i = 0; i < _Entity.length(); i++)
	{
		setDependencyOnEntity(_Entity[i]);	
		Entity ent = _Entity[i];
	// a TSL will use it's origin as ref point unless a published point ptMount is found	
		if (ent.bIsKindOf(TslInst()))
		{
			TslInst tsl = (TslInst)ent;
			// HSB-10872
			tsl.transformBy(Vector3d(0,0,0));
			Entity entOverride = tsl.map().getEntity("overrideElement");
			if (entOverride.bIsValid() && entOverride.bIsKindOf(ElementWall()))
			{
				_Element[0] = (ElementWall)entOverride;	
			}
			break;	
		}
	}	
	
	Vector3d vx,vy,vz;
	Element el = _Element[0];
	vx=el.vecX();
	vy=el.vecY();
	vz=el.vecZ();
	//setExecutionLoops(2);
	assignToElementGroup(el, true, 0,'E');
	
// ints
	int nArOverShoot[] = {_kNoOverShoot,_kOverShoot};
	int nOverShoot = nArOverShoot[sArNY.find(sOverShoot,0)];
	int nTool = sArCNCTool.find(sCNCTool,0);
	
// add triggers
	String sTrigger[] = {T("|Link to Entity|"),T("|Remove Link|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);	
	
// trigger 0 add link
	if ((_bOnRecalc && _kExecuteKey==sTrigger[0]))
	{
		PrEntity ssE(T("|Select Entity|") + " " + T("|(a beam which is not parallel to the X-Axis of the element or a TSL)|"), Beam());
		ssE.addAllowedClass(TslInst());
		Entity ents[0];
		if (ssE.go())
			ents = ssE.set(); 	
		
		// take the first one
		for (int i = 0; i < ents.length(); i++)
		{
			_Entity.append(ents[i]);
			break;	
		}
	}
	
// trigger 1 remove link
	else if ((_bOnRecalc && _kExecuteKey==sTrigger[1]))
	{
		Entity ent = getEntity(T("|Select Entity|") + " " + T("|(a beam which is not parallel to the X-Axis of the element or a TSL)|"));
		for (int i=0;i<_Entity.length();i++)
			if (ent == _Entity[i])
				_Entity.removeAt(i);
	}	
	
// this zone and default contour
	ElemZone ez = _Element[0].zone(nZone);
	PLine plContour(vz);//ez.vecZ());
	plContour.createRectangle(LineSeg(_Pt0-.5*(vx*dWidth+vy*dHeight),_Pt0+.5*(vx*dWidth+vy*dHeight)),vx,vy);		

// query if this instance is linked
	Entity entRef = _Map.getEntity("entRef");	
	
// version 1.4: die vertikale Verschiebung eines TSL basierten Elternobjektes wird unterstützt.
// on the event of moving _Pt0 transform a potential parent tsl as well
	if (_kNameLastChangedProp == "_Pt0" && entRef.bIsValid() && entRef.bIsKindOf(TslInst()))
	{
		TslInst tsl = (TslInst)entRef;
		if(tsl.scriptName()=="RUB-Anker-Aufsatzwand")
		{ 
			// HSB-23617
			Vector3d vecXTrans = vx*vx.dotProduct(_Pt0-tsl.ptOrg());
			tsl.transformBy(vecXTrans);
			
			setExecutionLoops(2);
			return;
		}
		
		Point3d ptEntRef = tsl.ptOrg();	
		Map m = tsl.map();
		if (m.hasPoint3d("ptMount"))
			ptEntRef  = m.getPoint3d("ptMount");
		
	// calculate transformation in vecY of the element
		Vector3d vecYTrans = vy*vy.dotProduct(_Pt0-ptEntRef);
		tsl.transformBy(vecYTrans);
		
	// force the transformed tsl to trigger siblings	
		m.setInt("moveSibling", true);
		tsl.setMap(m);
		setExecutionLoops(2);
		return;
	}
	if (_kNameLastChangedProp == T("|Zone|") && entRef.bIsValid() && entRef.bIsKindOf(TslInst()))
	{
		// HSB-13828
		TslInst tsl = (TslInst)entRef;
		if(tsl.scriptName()=="RUB-GV")
		{ 
			tsl.setPropInt(0, nZone);
		}
		setExecutionLoops(2);
		return;
	}

	
// loop entities	
	for (int i = 0; i < _Entity.length(); i++)
	{
		setDependencyOnEntity(_Entity[i]);	
		Entity ent = _Entity[i];
	// a TSL will use it's origin as ref point unless a published point ptMount is found	
		if (ent.bIsKindOf(TslInst()))
		{
			TslInst tsl = (TslInst)ent;
			Map m = tsl.map();
		
		// erase me if parent is in no sleeve mode
			if (m.hasInt("HasSleeve") && !m.getInt("HasSleeve"))
			{ 
				eraseInstance();
				return;
			}
			
			
			if (m.hasPoint3d("ptMount"))
				_Pt0 = m.getPoint3d("ptMount");
			else
				_Pt0 = tsl.ptOrg();	
			// transform half width	
			if (tsl.map().hasVector3d("vxMount"))	
				_Pt0.transformBy(tsl.map().getVector3d("vxMount")*.5*dWidth);	
			plContour.createRectangle(LineSeg(_Pt0-.5*(vx*dWidth+vy*dHeight),_Pt0+.5*(vx*dWidth+vy*dHeight)),vx,vy);	
			entRef = tsl;
			break;	
		}
	// a beam will change replace the height / width	
		else if (ent.bIsKindOf(Beam()))
		{
			Beam bm= (Beam)ent;
			if (!bm.vecX().isParallelTo(vx))
			{			
				PLine plBox(bm.vecX());
				Point3d ptCen = bm.ptCenSolid();
				plBox.createRectangle(LineSeg(ptCen-.5*(bm.vecY()*bm.dW()+bm.vecZ()*bm.dH()),
													ptCen+.5*(bm.vecY()*bm.dW()+bm.vecZ()*bm.dH())),bm.vecY(),bm.vecZ());
				Vector3d vxProj = bm.vecX();
				if (vxProj.dotProduct(ez.ptOrg()-ptCen)<0)
					vxProj*=-1;
				plBox.projectPointsToPlane(Plane(ez.ptOrg(),ez.vecZ()), vxProj);
				
				Point3d pt[] = plBox.vertexPoints(true);
				Point3d ptMid;
				ptMid.setToAverage(pt);
				// use this only if the beam intersects the envelope
				if (PlaneProfile(el.plEnvelope()).pointInProfile(ptMid)!=_kPointOutsideProfile)
				{
					_Pt0.setToAverage(pt);
					plContour=plBox;	
					
					dWidth.setReadOnly(true);
					dHeight.setReadOnly(true);
					entRef = bm;	
					break;
				}	
			}	
		}
	}
	if (entRef.bIsValid())
	{
		_Map.setEntity("entRef", entRef);
	}

// kill me on element deleted if ref is invalid
	if ( ! entRef.bIsValid() && _Map.hasEntity("entRef"))//_bOnElementDeleted || 
	{
		// reference entity  not valid but referenced in Map 
		eraseInstance();
		return;
	}	
	// HSB-6995: delete when 3d construction deleted
	if (_bOnElementDeleted)
	{ 
		reportMessage(TN("|element was deleted|"));
		eraseInstance();
		return;
	}

	
// relocate _Pt0	
	_Pt0 = _Pt0 - ez.vecZ()*ez.vecZ().dotProduct(_Pt0-ez.ptOrg());
	
// tool contour
	PLine plTool=plContour;
	if (nTool==0)
	{
		plTool = PLine(vz);//ez.vecZ());
		Point3d pt[] = plContour.vertexPoints(false);
		for(int i=0;i<pt.length();i++)
		{
			Point3d ptThis = pt[i];
			if (i==0)
			{
				Vector3d vxSeg = pt[i+1]-pt[i];
				vxSeg .normalize();	
				ptThis.transformBy(U(10)*vxSeg);
			}
			plTool.addVertex(ptThis);
		}
	}
	plTool.vis();	
	
// add the tool
	//milling
	if (nTool==0)		
	{
	ElemMill tool(nZone, plTool, ez.dH(),  nToolingIndex, _kLeft, _kCCWise, nOverShoot);
		el.addTool(tool);	
	}	
	// saw
	else if (nTool==1)		
	{
		ElemSaw tool(nZone, plTool, ez.dH(),  nToolingIndex, _kLeft, _kCCWise, nOverShoot);
		el.addTool(tool);	
	}	
	
// solid subtract to sheets
	SolidSubtract sosu(Body(plContour,ez.vecZ()*U(1000),0));
	sosu.transformBy(ez.vecZ()*(ez.dH()+dEps));
	sosu.cuttingBody().vis(6);

// collect sheets to be manipulated
	Sheet sh[] = el.sheet(), shTool[0];
	for(int i=0;i<sh.length();i++)
	{
		int x = sh[i].myZoneIndex();
		if (x == 0)
		{ 
			// if entity does not belong to any element
			// zone index returned is 0, dont consider
			continue;
		}
		if (x<=nZone && x/abs(x)*nZone == nZone)
			shTool.append(sh[i]);
		// HSB-13559
		if(x>=nZone && x/abs(x)*nZone == -nZone)
			shTool.append(sh[i]);
	}
	for(int i=0;i<shTool.length();i++)
		shTool[i].addTool(sosu,_kSubtract);



#End
#BeginThumbnail
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
>*HJ*<@$J`/RYKI+.%K>R@@8@M'&%)'3@58HH`__9
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
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23617: Update &quot;RUB-Anker-Aufsatzwand&quot; if hsbOpeningZone is moved" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="3/18/2025 9:25:37 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15527: make sure width,height not&lt;0" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="6/7/2022 10:52:32 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13828: update RUB-GV if zone is modified" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="11/17/2021 4:22:17 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End