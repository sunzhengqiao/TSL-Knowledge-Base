#Version 8
#BeginDescription
version value="1.3" date="09mar2020" author="thorsten.huck@hsbcad.com"> 
HSB-6920 new context commands to toggle the overshoot
HSB-6033 new option 'Shape' supports selection of angular shaped or round. If angular shaped is used with a radius > width the tool width will be adjusted.

This tsl creates a single rebate along any panel edge
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords CLT;Rebate;Edge;Falz
#BeginContents
/// <History>//region
/// <version value="1.3" date="09mar2020" author="thorsten.huck@hsbcad.com"> HSB-6920 new context commands to toggle the overshoot </version>
/// <version value="1.2" date="25nov2019" author="thorsten.huck@hsbcad.com"> HSB-6033 new option 'Shape' supports selection of angular shaped or round. If angular shaped is used with a radius > width the tool width will be adjusted. </version>
/// <version value="1.1" date="24jul2017" author="thorsten.huck@hsbcad.com"> bugfix side, radial dimension added </version>
/// <version value="1.0" date="23jul2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select panel(s), select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a single rebate along any panel edge
/// </summary>//endregion

// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));
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
// get mode
	int nMode = _Map.getInt("mode");
	// 0 = opening mode
	// 1 = edge mode

// Face	
	String sFaceName=T("|Face|");	
	String sFaces[] = {T("|Reference Side|"), T("|Opposite Side|")};
	PropString sFace(nStringIndex++, sFaces, sFaceName);
	sFace.setCategory(category );

// GEOMETRY
	category = T("|Rebate|");
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(20), sDepthName);
	String sDepthDesc = T("|Defines the depth of the rebate.|");
	dDepth.setDescription(sDepthDesc);
	dDepth.setCategory(category );

	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(40), sWidthName);
	String sWidthDesc = T("|Defines the width of the rebate.|");
	dWidth.setDescription(sWidthDesc);
	dWidth.setCategory(category );

	String sRadiusName=T("|Radius|");	
	PropDouble dRadius(nDoubleIndex++, U(0), sRadiusName);	
	dRadius.setDescription(T("|Defines the radius of the tool.|") + T("|This option will enlarge the tool regarding to the specified value.|") + " "+T("|0 = irrelevant|"));
	dRadius.setCategory(category);	
	
	String sShapeName=T("|Shape|");	
	String sShapes[] ={ T("|Round|"),T("|Angular shaped|")};
	PropString sShape(nStringIndex++, sShapes, sShapeName);	
	sShape.setDescription(T("|Defines the Shape|"));
	sShape.setCategory(category);

//End Properties//endregion 


// bOnInsert//region
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(sKey,-1)>-1)			
				setPropValuesFromCatalog(sKey);
			else
				showDialog();					
		}		
		else	
			showDialog();

	// create TSL
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};			
		double dProps[]={dDepth,dWidth, dRadius};				
		String sProps[]={sFace,sShape};
		Map mapTsl;	

	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());
	  	if (ssE.go())
			ents.append(ssE.set());
		
		
	// prompt for point input
		PrPoint ssP(TN("|Select start point|")); 
		if (ssP.go()==_kOk) 
			_PtG.append(ssP.value()); // append the selected points to the list of grippoints _PtG
		if (_PtG.length()<1)
		{ 
			eraseInstance();
			return;
		}
		
		
	// prompt for point input
		PrPoint ssP2(TN("|Select end point|"),_PtG[0]); 
		if (ssP2.go()==_kOk) 
			_PtG.append(ssP2.value()); // append the selected points to the list of grippoints _PtG
		if (_PtG.length()<2)
		{ 
			eraseInstance();
			return;
		}			
		
	
//	// get sips
		for (int i = 0; i < ents.length(); i++)
		{
			Sip sip = (Sip)ents[i];
			if (sip.bIsValid())
			{
				_Sip.append(sip);
			}
		}
		
		_Pt0.setToAverage(_PtG);
		
		return;		
	}	
// end on insert__________________//endregion
	

// validate
	if (_Sip.length()<1 || _PtG.length()<2)
	{
		reportMessage("\n" + scriptName() + ": " +T("|invalid reference or grip points|"));
		
		eraseInstance();
		return;	
	}
	
// set standards
	Sip sip = _Sip[0];
	Vector3d vecX = sip.vecX();
	Vector3d vecY = sip.vecY();
	Vector3d vecZ = sip.vecZ();
	Point3d ptCen = sip.ptCenSolid();
	PLine plEnvelope = sip.plEnvelope();
	double dZ = sip.dH();
	Quader qdr(ptCen, vecX, vecY, vecZ, sip.solidLength(), sip.solidWidth(), sip.solidHeight(),0,0,0);
	SipEdge edges[] = sip.sipEdges();
	CoordSys cs(ptCen, vecX, vecY, vecZ);
	//_ThisInst.setAllowGripAtPt0(false);
	
// assigning and color
	assignToGroups(sip,'T');
	_Entity.append(sip);
	setDependencyOnEntity(sip);

// get face
	int nFace = sFaces.find(sFace)==1?1:-1;
	Point3d ptFace = sip.ptCenSolid()+nFace*vecZ*.5*dZ;
	Plane pnFace(ptFace, vecZ*nFace);
	PLine plDefining(vecZ);
	PLine plOpenings[]=sip.plOpenings();

// get/set shape
	int nShape = sShapes.find(sShape,0);
	if (dRadius<=0)
	{ 
		if (nShape==0)	sShape.set(sShapes[1]);
		sShape.setReadOnly(true);
	}

// the grips and the derived coordSys
	Vector3d vecXG = _PtG[1] - _PtG[0];
	if (vecXG.bIsZeroLength())
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|invalid grip positions.|"));
		eraseInstance();
		return;
	}
	
	Vector3d vecYG = vecXG.crossProduct(-vecZ);
	vecYG.normalize();
	vecXG = vecYG.crossProduct(vecZ);
	vecXG.normalize();
//	vecXG.vis(_Pt0, 1);
//	vecYG.vis(_Pt0, 3);
	
	
	PLine plRecG;
	plRecG.createRectangle(LineSeg(_PtG[0]+vecYG*dWidth, _PtG[1]-vecYG*dWidth), vecXG, vecYG);

// find edge with biggest overlap
	SipEdge edgeRef;
	double dMaxArea;
	Vector3d vecDir = vecXG;
	Vector3d vecPerp = vecYG;


//TRIGGER//region
// TriggerFlipSide
	String sFlipTrigger = T("|Flip Side|") + " (" + T("|Doubleclick|") + ")";
	addRecalcTrigger(_kContext, sFlipTrigger );//sTriggerFlipDirection
	if (_bOnRecalc && (_kExecuteKey==sFlipTrigger || _kExecuteKey==sDoubleClick)) 
	{
		if (nFace==1)
			sFace.set(sFaces[0]);
		else if (nFace==-1)
			sFace.set(sFaces[1]);
		
		setExecutionLoops(2);
		return;
	}	
	
// Trigger OverShootStart
	int bOverShootStart = _Map.getInt("OverShootStart");
	String sTriggerOverShootStart =bOverShootStart?T("../|No Overshoot Start|"):T("../|Overshoot Start|");
	addRecalcTrigger(_kContext, sTriggerOverShootStart);
	if (_bOnRecalc && _kExecuteKey==sTriggerOverShootStart)
	{
		bOverShootStart = bOverShootStart ? false : true;
		_Map.setInt("OverShootStart", bOverShootStart);		
		setExecutionLoops(2);
		return;
	}
// Trigger OverShootEnd
	int bOverShootEnd = _Map.getInt("OverShootEnd");
	String sTriggerOverShootEnd =bOverShootEnd?T("../|No Overshoot End|"):T("../|Overshoot End|");
	addRecalcTrigger(_kContext, sTriggerOverShootEnd);
	if (_bOnRecalc && _kExecuteKey==sTriggerOverShootEnd)
	{
		bOverShootEnd = bOverShootEnd ? false : true;
		_Map.setInt("OverShootEnd", bOverShootEnd);		
		setExecutionLoops(2);
		return;
	}	
// Trigger OverShoot
	int bOverShoot = bOverShootStart || bOverShootEnd;
	String sTriggerOverShoot =bOverShootEnd?T("../|No Overshoot|"):T("../|Overshoot|");
	addRecalcTrigger(_kContext, sTriggerOverShoot);
	if (_bOnRecalc && _kExecuteKey==sTriggerOverShoot)
	{
		bOverShoot = bOverShoot ? false : true;
		_Map.setInt("OverShootStart", bOverShoot);	
		_Map.setInt("OverShootEnd", bOverShoot);	
		setExecutionLoops(2);
		return;
	}	
//endregion



// this attempt to store the edge location does not work	
//	int nEdgeIndex = _Map.hasInt("myEdge")?_Map.getInt("myEdge"):-1;
//	int numEdge = _Map.hasInt("numEdge")?_Map.getInt("numEdge"):-1;
//	
//	int bFindEdge = nEdgeIndex == -1 || nEdgeIndex >= edges.length() || (numEdge >- 1 && numEdge != edges.length());
//	if (bFindEdge)

	for (int e=0;e<edges.length();e++) 
	{ 
		SipEdge& edge = edges[e];
		Point3d pt1 = edge.ptStart();
		Point3d pt2 = edge.ptEnd();
		Vector3d vecXE = pt2 - pt1; vecXE.normalize();
		Vector3d vecYE = edge.vecNormal();
		Vector3d vecZE = vecXE.crossProduct(vecYE);
		
		if (!_bOnDbCreated && !vecXE.isParallelTo(vecDir))continue;
		
		
		PLine plRecE;
		plRecE.createRectangle(LineSeg(pt1, pt2-vecYE*dWidth), vecXE, vecYE);
		plRecE.projectPointsToPlane(pnFace, vecZE);
		//plRecE.vis(e);
		
		PLine plRecG2 = plRecG;
		plRecG2.projectPointsToPlane(pnFace, vecZE);
		
		PlaneProfile ppE(cs);
		PlaneProfile ppG(cs);
		
		ppE.joinRing(plRecE, _kAdd);
		
		
		ppG.joinRing(plRecG2, _kAdd);
		ppE.intersectWith(ppG);
		
		double dArea = ppE.area();
		if (dArea>dMaxArea)
		{ 
			//ppE.vis(e);
			edgeRef = edge;
			dMaxArea = dArea;
//				nEdgeIndex = e;
//				_Map.setInt("myEdge", nEdgeIndex);
//				_Map.setInt("numEdge", edges.length());

		}
	}//next e		

// snap grips to projected axis line
	if (edgeRef.plEdge().length()>dEps)
	{ 
		Point3d pt1 = edgeRef.ptStart();
		Point3d pt2 = edgeRef.ptEnd();
		Vector3d vecXE = pt2 - pt1; vecXE.normalize();		
		Vector3d vecYE = edgeRef.vecNormal();
		Vector3d vecZE = vecDir.crossProduct(vecYE);

		vecDir = vecXE;

		PLine plAxis(edgeRef.ptMid() - vecDir * U(10e4), edgeRef.ptMid() + vecDir * U(10e4));
		plAxis.projectPointsToPlane(pnFace, vecZE);
		//plAxis.vis(2);
		
	// project grips on face
		for (int i=0;i<2;i++) 
			_PtG[i]=plAxis.closestPointTo(_PtG[i]); 
			
		vecPerp = edgeRef.vecNormal().crossProduct(vecZ).crossProduct(-vecZ);	
		_Map.setVector3d("vecDir", vecXE);
		_Map.setVector3d("vecPerp", vecYE);
		
	}
	else
	{ 
		vecDir = _Map.getVector3d("vecDir");
		vecPerp = _Map.getVector3d("vecPerp");	
		
	}
	
//// project grips on face
//	for (int i=0;i<_PtG.length();i++) 
//		_PtG[i]=_PtG[i].projectPoint(pnFace,0); 	
	
	Point3d ptMid = (_PtG[0] + _PtG[1]) / 2;
	_Pt0 = ptMid;

// snap grips
	String sGrips[] = { "_PtG0", "_PtG1" };
	int nLastChangedGrip = sGrips.find(_kNameLastChangedProp);
	if (nLastChangedGrip >-1)
	{ 
		int nOther = nLastChangedGrip == 0 ? 1 : 0;
		PLine plAxis(_PtG[nOther]- vecDir * U(10e4),_PtG[nOther]+ vecDir * U(10e4));
		_PtG[nLastChangedGrip] = plAxis.closestPointTo(_PtG[nLastChangedGrip]);
		setExecutionLoops(2);
	}
//

// project grips to edge
	vecPerp.normalize();
	vecDir.vis(ptMid, 131);
	vecPerp.vis(ptMid, 131);


// check if this edge is an opening edge
	int bIsOpening;
	for (int i=0;i<plOpenings.length();i++) 
	{ 
		Point3d pt = ptMid+vecPerp*dEps;
		if (PlaneProfile(plOpenings[i]).pointInProfile(pt)==_kPointInProfile)	
		{ 
			bIsOpening = true;
			break;
		}
		 
	}//next i
	


// display
	int nColor = (nFace==1?4:3);
	Display dp(nColor);


//// get tool dimensions considering overshoot
	Point3d pts[] = { _PtG[0], _PtG[1]};
	if (bOverShootStart)pts.first() -= vecXG * dRadius;
	if (bOverShootEnd)pts.last() += vecXG * dRadius;
	


	double dXT =abs(vecDir.dotProduct(pts[1] - pts[0]));
	double dYT = bIsOpening?dWidth:dWidth*2;
	double dZT = dDepth;

	if (dZT > dEps && dYT > dEps && dXT>dEps)
	{ 
		Point3d ptTool = (pts[0] + pts[1]) / 2;
		ptTool += vecZ * vecZ.dotProduct(ptFace - ptTool);
		
		Vector3d vecXT = vecDir;
		Vector3d vecZT = - nFace * vecZ;
		Vector3d vecYT = vecXT.crossProduct(-vecZT);
		
		double dYFlag = bIsOpening?-nFace:0;

		
		//if (!vecYT.isCodirectionalTo(vecPerp))dYFlag *= -1;
		
		if (dRadius > 0 && nShape == 0)// round shaped
		{			
			if (dRadius>.5*dWidth)
			{
				dYFlag = 0;
				dYT = 2*dRadius;
				ptTool -= vecPerp * (dWidth-dRadius);	
				
			}
			
			vecXT.vis(ptTool, 1);
			vecYT.vis(ptTool, 3);
			vecZT.vis(ptTool, 150);
			
			ptTool.vis(2);

			Mortise ms(ptTool, vecXT, vecYT, vecZT, dXT, dYT, dZT, 0 ,dYFlag, 1);
			ms.setRoundType(_kExplicitRadius);
			ms.setExplicitRadius(dRadius);
			ms.cuttingBody().vis(3);
			sip.addTool(ms);
		}	
		else if (dRadius > 0 && nShape == 1)// angular shaped
		{			
			if (dRadius>.5*dWidth)
			{
				dYFlag = 0;
				dYT = 2*dRadius;
				ptTool -= vecPerp * (dWidth-dRadius);	
				
			}
			
			vecXT.vis(ptTool, 1);
			vecYT.vis(ptTool, 3);
			vecZT.vis(ptTool, 150);
			
			ptTool.vis(2);

			Mortise ms(ptTool, vecXT, vecYT, vecZT, dXT, dYT, dZT, 0 ,dYFlag, 1);
			ms.setRoundType(_kExplicitRadius);
			ms.setExplicitRadius(0);
			ms.cuttingBody().vis(2);
			sip.addTool(ms);
		}			
		else
		{
			vecXT.vis(ptTool, 1);
			vecYT.vis(ptTool, 3);
			vecZT.vis(ptTool, 150);
			//if (vecYT.isCodirectionalTo(vecPerp))dYFlag *= -1;
			vecPerp.vis(ptTool, 23);
			
			BeamCut bc(ptTool,vecXT, vecYT, vecZT, dXT, dYT, dZT, 0 ,dYFlag,1);
			bc.cuttingBody().vis(6);
			sip.addTool(bc);
	
			
		}		
	}


//collect text lines
	String sLine;
	if (dRadius > 0 && nShape==0) sLine="R" + (String().formatUnit(dRadius, 2,0));
	int bShowText=true;
	if (sLine.length() < 1)	bShowText = false;
	if (!bShowText && _PtG.length()>2)_PtG.setLength(2);


// draw text//region
	// concept:
	// as multiple tools could have the same originator and the same properties we only want to show the
	// text on one entity. To achieve this similar tsls are collected. Only the entity with the lowest handle will display
	if (bShowText)		
	{ 
	// collect childs of the same type and parent and use the smallest handle as entity to display description
		Entity tents[] = sip.eToolsConnected();
		String sMyParent = _Map.getString("parentHandle");

		String sSortKeys[0]; // a counter how many requests are seen in the same direction
		for (int i=0;i<tents.length();i++) 
		{ 
			TslInst tsl= (TslInst)tents[i];
			if (tsl.bIsValid() && tsl.scriptName() == scriptName())
			{ 
				Map m =tsl.map(); 
			// no parent flag
				if (!m.hasString("parentHandle"))continue;
				
				double depth = tsl.propDouble(0);
				double width = tsl.propDouble(1);
				double radius = tsl.propDouble(2);
				
				if (tsl.map().getVector3d("vecDir").isCodirectionalTo(vecDir))
					sSortKeys.append((String)depth+(String)width+(String)radius+tsl.propString(0));	
					
			// properties don't match
				if (tsl.propString(0) != sFace)continue;
				if (depth != dDepth)continue;
				if (width != dWidth)continue;
				if (radius != dRadius)continue;
	
			// don't show text if the handle of this is smaller than another one
				if (sMyParent==m.getString("parentHandle") && _ThisInst.handle()<tsl.handle())
				{ 
					bShowText = false;
					break;
				}
			}		 
		}//next i
		
	// get reading coordSys 
		Vector3d vecXRead = vecX;
		Vector3d vecYRead = vecY;
		// in XY plane
		if(vecZ.isParallelTo(_ZW))
		{ 
			vecXRead = qdr.vecD(_XW);
			vecYRead = vecXRead.crossProduct(-vecZ);
		}
		// as 3D wall
		else if(vecZ.isPerpendicularTo(_ZW))
		{ 
			vecYRead = qdr.vecD(_ZW);
			vecXRead = vecYRead.crossProduct(-vecZ);
		}	
	
	// text location
		Point3d ptText;
		if (_PtG.length()<3)
		{
			ptText= _PtG[1] - vecPerp*dWidth;
			_PtG.append(ptText);
		}
		else
			ptText=_PtG[2];	
	
	// draw lines of text
		double dXFlag ;//= vecDir.isCodirectionalTo(vecXRead)?1:-1;
		double dYFlag ;//= vecPerp.isCodirectionalTo(vecYRead)?-1:1;
//		if(vecDir.isParallelTo(vecYRead))
//		{ 
//			dXFlag = vecDir.isCodirectionalTo(vecYRead)?-1:1;
//			dYFlag = vecPerp.isCodirectionalTo(vecXRead)?1:-1;
//		}
		ptText.vis(2);
		
	// draw text
		Map mapRequests, mapRequest;
		if (bShowText)
		{ 
			dp.draw(sLine, ptText, vecXRead, vecYRead , dXFlag,dYFlag, _kDevice);
	
	
			
		// get center of radial dim and default chord vector	
			Point3d ptCenter = _PtG[1] - vecDir * dRadius - vecPerp*(dWidth-dRadius);
			Vector3d vecChord = vecDir - vecPerp;
			vecChord.normalize();

		// order keys, the sortkeys identify the value of the rotation of this chord vector
			for (int i=0;i<sSortKeys.length();i++) 
				for (int j=0;j<sSortKeys.length()-1;j++) 
					if (sSortKeys[j]>sSortKeys[j+1])
						sSortKeys.swap(j, j + 1);
		
		// get my location
			String sSortKey = (String)dDepth + (String)dWidth + (String)dRadius + sFace;
			int nSortKey = sSortKeys.find(sSortKey);
			double dAngle;
			if (sSortKeys.length()>1)
			{ 
				double dIncrementAngle = 90 / (sSortKeys.length() + 1);
				dAngle = -dIncrementAngle / 2;
				for (int i=0;i<nSortKey;i++) 
					dAngle += dIncrementAngle;
			
				CoordSys cs;
				cs.setToRotation(dAngle, vecZ, ptCenter);
				vecChord.transformBy(cs);
				if (bDebug)reportMessage("\ntools in same dir" + sSortKeys.length() + " index " + nSortKey + " vector transformed by " + dAngle + " cs: " + cs);
			}
			
			Point3d ptChord = ptCenter + vecChord * dRadius;
			//vecChord.vis(ptChord, 2);
			
		// publish radial info in a request map
			mapRequest.setVector3d("AllowedView", vecZ);
			mapRequest.setInt("AlsoReverseDirection", true);			
			mapRequest.setPoint3d("ptCenter",ptCenter);
			mapRequest.setPoint3d("ptChord",ptChord);
			mapRequests.appendMap("DimRequestRadial",mapRequest);	
			
		// publish dim requests	
			_Map.setMap("DimRequest[]", mapRequests);			
		}	
	// reset
		else if(_Map.hasMap("DimRequest[]"))
			_Map.removeAt("DimRequest[]",true);
	}
// reset	
	else if(_Map.hasMap("DimRequest[]"))
		_Map.removeAt("DimRequest[]",true);

//End draw text//endregion



// Draw Display
	dp.draw(PLine(_PtG[0], _PtG[1]));
	PLine plSym(vecZ);
	if (dRadius<=0 || nShape==1)
	{
		plSym = PLine(ptMid - vecPerp * dWidth, ptMid + vecDir * dWidth, ptMid - vecDir * dWidth, ptMid - vecPerp * dWidth);
		
	}
	else
	{ 
		plSym.addVertex(ptMid+vecDir*dWidth);
		plSym.addVertex(ptMid+-vecDir*dWidth,tan(45));
		plSym.close();
	}
	dp.draw(plSym);	
// draw direction
	{
		Point3d pts[] = Line(_Pt0,vecXG).orderPoints(plSym.intersectPoints(Plane(ptMid - vecPerp*.3 * dWidth, vecPerp)));
		if (pts.length()>1)
		{ 
			Point3d pt1 = pts.first();
			Point3d pt2 = pts.last();
			double dX = vecXG.dotProduct(pt2 - pt1)*.2;
			dp.draw(PLine(pt1, pt2));	
			dp.draw(PLine(pt2-vecXG*dX-vecPerp*.1*dWidth, pt2,pt2-vecXG*dX+vecPerp*.1*dWidth));
			
		}
	}
	
	
	
#End
#BeginThumbnail
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
1:VLH(&(+1H%)'3@59HH`_]G'
`



#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End