#Version 8
#BeginDescription
version  value="1.6" date="11aug16" author="thorsten.huck@hsbcad.com"
bugfix beamcut depth on complexe contours 

/// completely revised
/// supports any extruded solid shape if the extrusion profile consists exclusively of straight segments
/// Note: once this tools applies an opening to the panel it will not be able to close this after the tooling
/// entity 

This Tsl creates a beamcut connection between a panel and a beam.
The Beamcut is either grip based openings on through beamcuts or a regular beamcut on not through connections 

/// NOTE: any connection where the X-Axis of the beam is perpendicular to the Z-Axis of the panel is not supported.



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This Tsl creates a beamcut connection between a panel and a beam.
/// The Beamcut is either grip based openings on through beamcuts or a regular beamcut on not through connections
/// </summary>

/// <insert=en>
/// Select a panel and a beam
/// </insert>

/// <remark Lang=en>
/// The location of the connection can be moved at any time as long as the type of the connection will not change.
/// This means one can well move the beam or panel as long as a full opening remains as full opening or a edge beamcut
/// remains as edge beamcut or a non through remains as non through beamcut.
/// If these conditions apply one can also alter the angle of the connection by rotation
/// NOTE: any connection where the X-Axis of the beam is perpendicular to the Z-Axis of the panel is not supported.
/// </remark>

/// <property name="Gap" Lang=en>
/// The gap properties allow to specify a gap in the given direction.
/// </remark>

/// History
///<version  value="1.6" date="11aug16" author="thorsten.huck@hsbcad.com"> bugfix beamcut depth on complexe contours </version>
///<version  value="1.5" date="05nov12" author="th@hsbCAD.de"> bugfix multiple aligned openings</version>
/// Version 1.4   th@hsbCAD.de   17.03.2011
/// minor bugfixes
/// Version 1.3   th@hsbCAD.de   19.11.2010
/// completely revised
/// supports any extruded solid shape if the extrusion profile consists exclusively of straight segments
/// Note: once this tools applies an opening to the panel it will not be able to close this after the tooling
/// entity 
/// Version 1.2   th@hsbCAD.de   04.11.2010
/// supports now also beamcuts where the intersecting beam is perpendicular to the panel plane
/// Version 1.1   th@hsbCAD.de   28.05.2010



// basics and props
	U(1,"mm");	
	double dEps = U(.1);

	PropDouble dGapX(0, U(0), T("|Gap|") + " X");
	PropDouble dGapY(1, U(0), T("|Gap|") + " Y");
	PropDouble dGap_X(2, U(0), T("|Gap|") + " -X");
	PropDouble dGap_Y(3, U(0), T("|Gap|") + " -Y");
	PropDouble dGapZ(4, U(0), T("|Gap|") + " Z");
	PropDouble dGap_Z(5, U(0), T("|Gap|") + "-Z");	
	
	String sArToolMode[]= {T("|Beamcut|"), T("|Vertex Adjustment|"), T("|Auto|")};
	PropString sToolMode(0, sArToolMode, T("|Tool Mode|"),2);
	
// declare arrays for tsl cloning
	TslInst tslNew;
	Vector3d vUcsX = _XW;
	Vector3d vUcsY = _YW;
	GenBeam gbAr[0];
	Entity entAr[0];
	Point3d ptAr[1];
	int nArProps[0];
	double dArProps[0];
	String sArProps[0];
	Map mapTsl;
	String sScriptname = scriptName();
	
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		// show the dialog if no catalog in use
		if (_kExecuteKey == "")
			showDialog();			
		else
			// set properties from catalog
			setPropValuesFromCatalog(_kExecuteKey);
		
		setCatalogFromPropValues(T("|_LastInserted|"));
		
		// selection of panels		
		PrEntity ssSip(T("Select Panel(s)"), Sip());
		Entity ents[0];
  		if (ssSip.go())
	    	ents.append(ssSip.set());		

		// selection of tools		
		PrEntity ssTools(T("Select Tooling Solid(s)"), Entity());
		Entity entTools[0];
  		if (ssTools.go())
	    	entTools.append(ssTools.set());	
		
		// create one instance per panel
		for (int p=0;p<ents.length();p++)
		{
			Body bdPanel = ents[p].realBody();
			
			gbAr.setLength(0);
			gbAr.append((Sip)ents[p]);
			entAr.setLength(0);
			for (int i=0;i<entTools.length();i++)
			{
					
				Body bdTool = entTools[i].realBody();
				Body bdInt = bdTool;
				bdInt.intersectWith(bdPanel);
				if (bdTool.volume()<pow(dEps,3) || bdInt.volume()<pow(dEps,3))
				{
					reportMessage("\n" + entTools[i].typeDxfName() + " " + T("|does not intersect the panel or is an invalid tool|"));
					continue;		
				}
				ptAr[0] = bdInt.ptCen();
				entAr.append(entTools[i]);
				
				// create a new instance
				tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
					nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
				if(tslNew.bIsValid())
					tslNew.setPropValuesFromCatalog(T("|_LastInserted|"))	;
				entAr.setLength(0);				
			}// next i tool			
		}// next p panel
		
		eraseInstance();			
		return;
	}	

// validate
	if (_Sip.length()<1 || _Entity.length()<1)
	{
		reportMessage("\n" + scriptName() + " " + T("|No panel or no tool available|"));
		eraseInstance();
		return;
	}	
	Entity entTool = _Entity[0];
	setDependencyOnEntity(_Entity[0]);

	
// declare the sip
	Sip sip=_Sip[0];
	Vector3d vx,vy,vz;
	vx=sip .vecX();
	vy=sip .vecY();
	vz=sip .vecZ();	
	PlaneProfile ppEnvelope(sip.plEnvelope());
	assignToGroups(sip);
			
// the ref plane
	Plane pn(sip .ptCen() - vz*.5*sip.dD(vz),vz);	
	vx.vis(_Pt0, 1);
	vy.vis(_Pt0, 3);
	vz.vis(_Pt0, 150);	

// Display
	Display dp(3);

// the bodies
	Body bdPanel = Body(sip.plEnvelope(), vz *sip.dD(vz),1 );	//bdPanel.vis(1);
	Body bdTool = entTool .realBody();
	
// validate tooling mode
	// 0 = a beamcut tool
	// 1 = a panel contour modifier
	Body bdIntersect = bdTool;
	bdIntersect.intersectWith(bdPanel);
	int nMode;
	if (abs(bdIntersect.lengthInDirection(vz)-sip.dD(vz))<dEps)
		nMode=1;
	bdIntersect.vis(nMode);
	
// tool in beamcut mode
	if (nMode ==0)
	{
		GenBeam gb;
		if (entTool.bIsKindOf(GenBeam()))
			gb = (GenBeam)entTool;
		else
		{
			Beam bm;
			bm.dbCreate(bdTool);
			gb = bm;
		}
		
		BeamCut bc;		
		Point3d ptTool = gb.ptCenSolid();
		ptTool.transformBy(gb.vecX()*.5*(dGapX-dGap_X)+gb.vecY()*.5*(dGapY-dGap_Y));
		double dX = gb.solidLength()+dGapX+dGap_X, dY=gb.solidWidth()+dGapY+dGap_Y, dZ=gb.solidHeight()+dGapZ+dGap_Z;
		if (dX>0 && dY>0 && dZ>0)
			bc = BeamCut(ptTool,gb.vecX(),gb.vecY(),gb.vecZ(),dX,dY,dZ, 0,0,0);		
		//bc.cuttingBody().vis(6);
		if (bc.cuttingBody().volume()>pow(dEps,3))
			sip.addTool(bc);
			
	// erase an existing dummy	
		if (!entTool.bIsKindOf(GenBeam()) && gb.bIsValid())
			gb.dbErase();


	// draw the intersection of the tool with the boxed shape of the panel
		LineSeg ls = ppEnvelope.extentInDir(vx);
		PLine plBox;
		plBox.createRectangle(ls,vx,vy);

		
		Body bd = sip.envelopeBody(false, true);
		bd.intersectWith(bc.cuttingBody());
		if (bd.volume()>pow(dEps,3))
		{
			_Pt0 = bd.ptCen();
			pn = Plane(_Pt0,vz);		
		}
		else
		{
			bd = bc.cuttingBody();
		}
		PlaneProfile ppDraw = bd.shadowProfile(pn);
		ppDraw.intersectWith(PlaneProfile(plBox));
		
		if (ppDraw.area() < pow(dEps,2))
		{
			eraseInstance();
			return;	
		}
		else
		{
			//ppDraw.transformBy(vz*vz.dotProduct(_Pt0-ppDraw.coordSys().ptOrg()));
			dp.draw(ppDraw);
			dp.draw(bd);
		}	

				
	} // end beamcut tool mode	

// tool in modify verteces mode
	else
	{		
	// get the tool shape at the refplane
		PlaneProfile ppTool = bdIntersect.getSlice(pn);

	// get the shadow of the intersecting body
		PlaneProfile ppShadow= bdIntersect.shadowProfile(pn);
		ppShadow.vis(3);
		
	// derive the approximate tooling vectors from the views
		Vector3d vyTemp, vxTool, vxTemp;
		Plane pnY(_Pt0,vy);
		PlaneProfile ppY = bdIntersect.shadowProfile(pnY);
		PlaneProfile ppYSip = sip.realBody().shadowProfile(pnY);
		Point3d ptYCen = ppY.extentInDir(vz).ptMid(); ptYCen.vis(2);
		ppY.shrink(-U(1));
		ppY.transformBy(vz*U(1));
		ppY.subtractProfile(ppYSip);
		vyTemp= ppY.extentInDir(vz).ptMid()-ptYCen;
		vyTemp.normalize();

		Plane pnX(_Pt0,vx);
		PlaneProfile ppX = bdIntersect.shadowProfile(pnX);
		PlaneProfile ppXSip = sip.realBody().shadowProfile(pnX);
		Point3d ptXCen = ppX.extentInDir(vz).ptMid(); ptXCen.vis(2);
		ppX.shrink(-U(1));
		ppX.transformBy(vz*U(1));
		ppX.subtractProfile(ppXSip);
		vxTemp= ppX.extentInDir(vz).ptMid()-ptXCen;
		vxTemp.normalize();

	// get tooling vecs
		Beam bmTool;
		bmTool.dbCreate(bdTool);
		Quader qdr = bmTool.quader();
		bmTool.dbErase();

	// the tool vecX	
		vxTool = qdr.vecD(vxTemp+vyTemp);
		vxTool.vis(_Pt0,1);

	// once the tooling direction is known get an aligned quader
		Vector3d vyTool, vzTool;
		vyTool = vy.crossProduct(vxTool).crossProduct(vxTool);
		vyTool.normalize();
		vyTool .vis(_Pt0,4);
		vzTool = vxTool.crossProduct(vyTool);
		bmTool.dbCreate(bdTool, vxTool, vyTool,vzTool);
		qdr = bmTool.quader();
		bmTool.dbErase();		

	// collect gaps and it's aligned vecs
		double dArGaps[] = {dGapX,dGapY,dGap_X,dGap_Y};
		Vector3d vArGaps[] = {qdr.vecY(),qdr.vecZ(),-qdr.vecY(),-qdr.vecZ()};		
		

	// extract the biggest ring
		PLine plTool;
		PLine plRings[]=ppTool.allRings();
		int bIsOp[] = ppTool.ringIsOpening();
		for(int r=0;r<plRings.length();r++)
			if (!bIsOp[r] && plTool.area()<plRings[r].area())
				plTool=plRings[r];
		plTool.vis(222);
		
	// points	
		Point3d ptTool[] = plTool.vertexPoints(false);	
			
	// test if fully inside
		// int bInside=true;
		// for(int p=0;p<ptTool.length()-1;p++)
		// {
		// 	if (ppEnvelope.pointInProfile(ptTool[p])!= _kPointInProfile)		
		// 	{	
		// 		bInside=false;
		// 		break;
		// 	}
		// }
	
	// flag to create sip dummy sip opening
		int bAddOpening=_bOnDbCreated;
		
	// append a perp opening first
		if (plTool.area()>pow(dEps,2) && bAddOpening)
			sip.addOpening(plTool,false);	

	// define a transformation for 45° aligned edges as the vecD might fall only to one direction
		CoordSys csRot;
		csRot.setToRotation(0.1,vz,_Pt0);
		
		for(int q=0;q<ptTool.length()-1;q++)	
		{
			
			Vector3d vxSegTool,vySegTool, vzSegTool;
			LineSeg lsTool(ptTool[q],ptTool[q+1]);
			vxSegTool = ptTool[q+1]-ptTool[q];
			vxSegTool.normalize();	
			vySegTool = vxSegTool.crossProduct(vz);
			if (ppTool.pointInProfile(lsTool.ptMid()+vySegTool*U(1))==_kPointOutsideProfile)
				vySegTool*=-1;	
			vySegTool.vis(lsTool.ptMid(),q);	
			vzSegTool = vxSegTool.crossProduct(vySegTool);
			Point3d ptStretch = lsTool.ptMid();

			vzSegTool .vis(lsTool.ptMid(),150);				

			int nDir =1;
			if (vzSegTool.dotProduct(vxTool)<0)
				nDir*=-1;
			
			Vector3d vecStr = vxTool.crossProduct(nDir*vxSegTool);//qdr.vecD(vySegTool);
			vecStr.vis(lsTool.ptMid(),222);
			
			Point3d ptStretchTo = lsTool.ptMid();
		
		// acknowledge a potential gap by comparing the aligned stretch vector with the gap vectors
			Vector3d vzStretchAligned = qdr.vecD(vecStr);
			if (45-abs(vecStr.angleTo(sip.vecX()))<dEps)
			{
				Vector3d  vTest = vecStr;
				vTest .transformBy(csRot);
				vzStretchAligned = qdr.vecD(vTest);
			}		
			
			for (int v=0;v<vArGaps.length();v++)
			{			
				if(vzStretchAligned.isCodirectionalTo(vArGaps[v]))
				{
					(-vzStretchAligned).vis(lsTool.ptMid(),v);
					ptStretchTo.transformBy(vzStretchAligned * -dArGaps[v]);
					break;		
				}
			}
			if (ppShadow.pointInProfile(ptStretchTo)!=_kPointOutsideProfile)
			{
				sip.stretchEdgeTo(ptStretch,Plane(ptStretchTo,vecStr));
			}
		}

	// draw the intersection of the tool with the boxed shape of the panel
		LineSeg ls = ppEnvelope.extentInDir(vx);
		PLine plBox;
		plBox.createRectangle(ls,vx,vy);
		PlaneProfile ppDraw = ppTool;
		ppDraw.intersectWith(PlaneProfile(plBox));
		
		if (ppDraw.area() < pow(dEps,2))
		{
			eraseInstance();
			return;	
		}
		else
		{
			_Pt0 = ppDraw.extentInDir(vx).ptMid();
			dp.draw(ppDraw);
		
		}		
		
	}// end tool in vertex mode	
	

	
	

		
	

	
	
				

		
			
			
			
					
		



#End
#BeginThumbnail
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
A4VK<JBHIR`64`?ES7264+6UC!`Q!:.,*2.G`JQ10!__9
`

#End