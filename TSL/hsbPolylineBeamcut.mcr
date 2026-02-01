#Version 8
#BeginDescription
#Versions
Version 2.0 15.03.2022 HSB-14804 description of conversion property enhanced
Version 1.9 25.02.2022 HSB-14804 bugfix bulge alignment
version value="1.8" date="30may16" author="thorsten.huck@hsbcad.com"
TSL double click event assigned to flip reference side 

supports multiple selection of beams, sheets and panels.
new context commands to add/remove entities
supports dependency to polyline or grip points

This TSL creates segemented beamcuts along a polyline


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 0
#KeyWords CLT; Polyline; Beamcut;Free Profile
#BeginContents
/// <summary Lang=en>
/// This TSL creates segemented beamcuts along a polyline
/// </summary>

/// <insert Lang=en>
/// Draw a polyline intersecting the panel, select panel and polyline.
/// </insert>

/// History
// #Versions
// 2.0 15.03.2022 HSB-14804 description of conversion property enhanced , Author Thorsten Huck
// 1.9 25.02.2022 HSB-14804 bugfix bulge alignment , Author Thorsten Huck
///<version value="1.8" date="30may16" author="thorsten.huck@hsbcad.com"> TSL double click event assigned to flip reference side </version>
///<version value="1.7" date="24nov15" author="thorsten.huck@hsbcad.com"> bugfix insertion in view ports </version>
///<version value="1.6" date="05oct15" author="thorsten.huck@hsbcad.com"> bugfix: property 'keep reference' only during insert, uses tool free profile if dependent from polyline and not centered </version>
///<version value="1.5" date="14oct14" author="th@hsbCAD.de"> new property 'keep reference' during insert. this property controls if a defining polyine is converted into grippoints or if it is kept as reference </version>
///<version value="1.4" date="25aug14" author="th@hsbCAD.de"> supports multiple selection of beams, sheets and panels, new context commands to add/remove entities </version>
///<version value="1.3" date="10jul14" author="th@hsbCAD.de"> supports beams, sheets and panels. </version>
///<version value="1.2" date="04jul14" author="th@hsbCAD.de"> supports dependency to polyline or grip points </version>
///<version value="1.1" date="10apr14" author="th@hsbCAD.de"> released </version>
///<version value="1.0" date="01apr14" author="th@hsbCAD.de"> initial</version>

// constants
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=projectSpecial().find("debugTsl",0)>-1 || _bOnDebug;

// categories
	String sCategoryGeo = T("|Geometry|");
	String sCategoryDisplay= T("|Display|");

// geometry	
	String sAlignmentName=T("|Alignment|");	
	String sAlignments[] = {T("|Reference Side|"), T("|Opposite Side|")};
	PropString sAlignment(0, sAlignments, sAlignmentName);
	sAlignment.setCategory(sCategoryGeo);

	String sSideName=T("|Side|");	
	String sSides[] = {T("|Left|"),T("|Center|"),T("|Right|")};
	PropString sSide(1, sSides, sSideName, 1);
	sSide.setCategory(sCategoryGeo);
		
	PropDouble dDepth(0, U(20), T("|Depth|"));
	dDepth.setCategory(sCategoryGeo);
	PropDouble dWidth(1, U(30), T("|Width|"));
	dWidth.setCategory(sCategoryGeo);
	
// annotation
	String sAnnotationName=T("|Content|");	
	String sAnnotations[] = {T("|no Content|"), T("|Width & Depth|")};
	PropString sAnnotation(2, sAnnotations, sAnnotationName);
	sAnnotation.setDescription(T("|Controls wether an annotation should be displayed.|"));
	sAnnotation.setCategory(sCategoryDisplay);

// order dimstyles
	String sDimStyles[0];sDimStyles = _DimStyles;
	String sTemps[0];sTemps = sDimStyles;
	for(int i=0;i<sTemps.length();i++)
		for(int j=0;j<sTemps.length()-1;j++)
			if (sTemps[j].makeUpper()>sTemps[j+1].makeUpper())
			{
				sTemps.swap(j,j+1);
				sDimStyles.swap(j,j+1);
			}	
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(3, sDimStyles, sDimStyleName);
	sDimStyle.setCategory(sCategoryDisplay);	
	
	PropDouble dTxtH(2,U(40),T("|Text Height|"));
	dTxtH.setCategory(sCategoryDisplay);
	
	int nColor = 6;

	
// bOnInsert
if (_bOnInsert)
{
	if (insertCycleCount() > 1) { eraseInstance(); return; }
	
	setOPMKey("Insert");
	String sReferenceName = T("|Reference|");
	String sReferences[] = { T("|Convert into Grippoints|"), T("|Keep Polyline|")};
	PropString sReference(4, sReferences, sReferenceName);
	sReference.setDescription(T("|The dependency to a polyline can be kept or its vertices to be used as reference.|") +T(" |Beware that polylines with arced segments will be converted into straight segments|"));

	// silent/dialog
		String sKey = _kExecuteKey;
		if (sKey.length()>0)
			setPropValuesFromCatalog(sKey);	
		else
			showDialog();
		
		int nAlignment = sAlignments.find(sAlignment);	
		if (nAlignment==1)nColor=3;
		int bKeepReference= sReferences.find(sReference);
		
		
	// selection
		Entity entities[0];	
		PrEntity ssGb(T("|Select genbeam(s)|"), GenBeam());
  		if (ssGb.go())
	    	entities= ssGb.set();		
		for (int i=0;i<entities.length();i++)
		{
			GenBeam gb = (GenBeam)entities[i];
			if (gb.bIsValid())
				_GenBeam.append(gb);
		}

		if (_GenBeam.length()<1)
		{
			eraseInstance();
			return;
		}
		Vector3d vz = _GenBeam[0].vecZ();
		if (_GenBeam[0].bIsKindOf(Beam()))
			vz = _GenBeam[0].vecD(_ZU);
		
	// optional polyline selection
		PrEntity ssE(T("|Select polyline(s) (<Enter> to pick points)|"), EntPLine());
  		if (ssE.go())
	    	entities= ssE.set();	
	
	
	// declare the tsl props
		TslInst tslNew;
		Vector3d vUcsX = _GenBeam[0].vecX();
		Vector3d vUcsY = _GenBeam[0].vecY();
		GenBeam gbAr[0];
		Entity entAr[0];
		Point3d ptAr[0];
		int nArProps[0];
		double dArProps[] = {dDepth,dWidth  ,dTxtH };
		String sArProps[]={sAlignment,sSide, sAnnotation,sDimStyle};
		Map mapTsl;
		String sScriptname = scriptName();		
		gbAr = _GenBeam;	

	// pline mode	
		if (entities.length()>0)
		{
		// insert per selected tool
		// create one instance per pline
			for (int i=entities.length()-1;i>=0;i--)
			{
				ptAr.setLength(0);
				entAr.setLength(0);
				Entity ent=entities[i];
				if (!ent.bIsKindOf(EntPLine()))continue;
				
				EntPLine epl =(EntPLine)ent;
				PLine plDefining = epl.getPLine();	
				Point3d pts[] = plDefining.vertexPoints(true);
				if (pts.length()<2)continue;
							
				if (!bKeepReference)	
				{
					ptAr=	pts;
					ent.dbErase();
				}
				else
				{
					ptAr.append(pts[0]);
					entAr.append(ent);
				}	
				tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
						nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance					
			}
			
		}
	// point mode
		else
		{
			EntPLine eplJig;
			_Pt0 = getPoint(T("Pick start point"));
			Point3d ptLast = _Pt0;	
			while (1) 
			{
				PrPoint ssP("\n" + T("|Select next point|"),ptLast); 
				if (ssP.go()==_kOk) 
				{
				// delete a potential jig	
					if (eplJig.bIsValid())eplJig.dbErase(); 
				// do the actual query
					ptLast = ssP.value(); // retrieve the selected point
					_PtG.append(ptLast); // append the selected points to the list of grippoints _PtG
					
					PLine pl(vz);
					pl.addVertex(_Pt0);
					for (int i=0;i<_PtG.length();i++)
						pl.addVertex(_PtG[i]);
					eplJig.dbCreate(pl);
					eplJig.setColor(nColor);
				}
				// no proper selection
				else 
				{ 
				// delete a potential jig	
					if (eplJig.bIsValid())eplJig.dbErase();			
					break; // out of infinite while
				}
			}
			ptAr.append(_Pt0);
			ptAr.append(_PtG);
			tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
					nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance		
		}
		eraseInstance();
		return;
	}
// end on insert


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

	
// validate
	if (_GenBeam.length()<1)
	{
		eraseInstance();
		return;	
	}

// standards	
	GenBeam gb = _GenBeam[0];
	Vector3d vx = gb.vecX();
	Vector3d vy = gb.vecY();
	Vector3d vz = gb.vecZ();
	assignToGroups(gb);
	int nFlipFace=1;
	
// adjust coordSys if type of beam, consider the vecD upper face as reference face
	int bIsBeam =gb.bIsKindOf(Beam());
	if (bIsBeam)
	{
		vz = gb.vecD(_ZU);
		vy = vx.crossProduct(-vz);
		nFlipFace*=-1;
	}
	vz.vis(_Pt0,150);
	_ZU.vis(_Pt0,150);
		
// for sheets consider the upper face as reference face
	int bIsSheet =gb.bIsKindOf(Sheet());
	if (bIsSheet)
	{
		nFlipFace*=-1;
	}


// ints
	int nAlignment = sAlignments.find(sAlignment);
	int nSide = sSides.find(sSide)-1;
	int nAnnotation= sAnnotations.find(sAnnotation);	
	
// TriggerFlipSide
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContext, sTriggerFlipSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
	{
		if (nAlignment==0)nAlignment=1;
		else nAlignment=0;
		sAlignment.set(sAlignments[nAlignment]);
		
	// consider same alignment when face is flipped
		if (abs(nSide)==1)
		{
			nSide*=-1;
			sSide.set(sSides[nSide+1]);	
		}
		setExecutionLoops(2);
		return;
	}


// get defining pline
	EntPLine epl;
	PLine plDefining, plTool;
	int bFreeProfile;
	for (int i=0;i<_Entity.length();i++)
	{
		Entity ent = _Entity[i];
		if (ent.bIsKindOf(EntPLine()))
		{
			epl =(EntPLine)ent;
			plDefining = epl.getPLine();
			plTool=plDefining;
			if (nSide!=0)
				bFreeProfile=true;
			setDependencyOnEntity(ent);
			break;
		}	
	}

// grip mode
	if (!epl.bIsValid() || plDefining.vertexPoints(true).length()<2)
	{
		if (_PtG.length()<1)
		{
			eraseInstance();
			return;
		}

		plDefining=PLine(vz);
		plDefining.addVertex(_Pt0);
		for (int i=0;i<_PtG.length();i++)
			plDefining.addVertex(_PtG[i]);				
	}		



	Vector3d vecFace = -gb.vecD(vz)*nFlipFace;
	if (nAlignment==1)
	{
		vecFace*=-1;
		nColor=3;
	}

	//epl.assignToGroups(gb, 'T');

/// declare ref point on face
	Point3d ptRef = gb.ptCenSolid()+vecFace*.5*gb.dD(vz);	
	ptRef.vis(1);
	Plane pnRef(ptRef,vecFace);	

	

	
// project defining polyline to reference side
	plDefining.projectPointsToPlane(pnRef,vz);
	if (!plDefining.coordSys().vecZ().isCodirectionalTo(vecFace))plDefining.flipNormal();	//HSB-14804 
	plDefining.convertToLineApprox(dEps);
	Point3d pts[] = plDefining.vertexPoints(false);
	if (pts.length()<2)
	{
		reportMessage("\n" + scriptName() + " " + T("|invalid polyline shape.|") + T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
	plDefining.vis(nColor);

	_Pt0 = plDefining.closestPointTo(_Pt0);
	for (int i=0;i<_PtG.length();i++)
		_PtG[i].transformBy(vz*vz.dotProduct(_Pt0-_PtG[i]));
	
	
	Vector3d vecX1, vecSide;
	double dOffset = dWidth/2;
	double dOffset2 = dWidth/2*nSide;
// collect offseted points along contour	
	Point3d ptsA[0], ptsB[0];
	Vector3d vecsX[0],vecsY[0];
	for (int p=0;p<pts.length()-1;p++)
	{
		Vector3d vxSeg = pts[p+1]-pts[p];	
		vxSeg.normalize();
		Vector3d vySeg = vxSeg.crossProduct(-vecFace);
		vecsX.append(vxSeg);
		vecsY.append(vySeg);
		
		if (p==0)
		{
			vecSide = vySeg;
			if (nSide!=0) vecSide*=nSide;
			vecSide.vis(_Pt0,3);
			ptsA.append(pts[p]+vySeg*(dOffset+dOffset2));
			ptsB.append(pts[p]-vySeg*(dOffset-dOffset2));	
		}
		else
		{
			Vector3d vecMitre = vecX1-vxSeg;
			vecMitre.normalize();
			Vector3d vecMitreZ = vecMitre.crossProduct(vz);
			Plane pn(pts[p],vecMitreZ);
			//pn.vis(2);
			ptsA.append(Line(ptsA[ptsA.length()-1], vecX1).intersect(pn,0));
			ptsB.append(Line(ptsB[ptsB.length()-1], vecX1).intersect(pn,0));			
		}
		
		if (p==pts.length()-2)
		{
			ptsA.append(pts[p+1]+vySeg*(dOffset+dOffset2));
			ptsB.append(pts[p+1]-vySeg*(dOffset-dOffset2) );	
		}
		
		vecX1 = vxSeg;
	}

// set varias
	double dY = dWidth;
	double dZ = dDepth*2;

	
// a set of four points defines the outline of one segment
	PlaneProfile ppSegs[0], ppBoxes[0];
	for (int p=0;p<ptsA.length()-1;p++)
	{
		if (ptsB.length()-1<p)continue;
		
		//ptsA[p].vis(1);
		Point3d ptsC[0];
		ptsC.append(ptsA[p]);
		ptsC.append(ptsA[p+1]);
		ptsC.append(ptsB[p]);
		ptsC.append(ptsB[p+1]);
		PLine plC;
		plC.createConvexHull(pnRef, ptsC);
		//plC.vis(p);

		PlaneProfile pp(plC);
		ppSegs.append(pp);
		
		LineSeg seg=pp.extentInDir(vecsX[p]);
		PLine plRec;
		plRec.createRectangle(seg, vecsX[p],vecsY[p]);
		ppBoxes.append(PlaneProfile(plRec));
	}	

// loop all profiles and intersect with previous and next to obtain beamcut shortening
	for (int p=0;p<ppBoxes.length();p++)
	{
		Vector3d vxSeg, vySeg;
		vxSeg = vecsX[p];
		vySeg = vecsY[p];



		PlaneProfile ppThis=ppBoxes[p];
		LineSeg seg = ppThis.extentInDir(vxSeg);
		Point3d ptMid=seg.ptMid();		
		double dX = abs(vxSeg.dotProduct(seg.ptStart()-seg.ptEnd()));


	// get profiles and angle to previous/next segment
		double dAngleStart,dAngleEnd ;
		PlaneProfile ppPrev, ppNext;
		if (p>0)	
		{
			ppPrev=ppSegs[p-1];
			dAngleStart =vecsX[p-1].angleTo(vecsX[p]);
		}
		if (p<ppSegs.length()-1)
		{
			ppNext=ppSegs[p+1];
			dAngleEnd = vecsX[p].angleTo(vecsX[p+1]);
		}
		//dp.draw(dAngleStart+"/"+dAngleEnd,seg.ptMid(), vx,vy,0,0,_kDevice);
		//ppSegs[p].vis(p);

		ppThis.subtractProfile(ppSegs[p]);
		//if (p>35)ppThis.vis(p);
		ppThis.subtractProfile(ppPrev);
		ppThis.subtractProfile(ppNext);
		if (0 && p==36)
		{
			ppPrev.vis(1);
			ppThis.vis(p+1);
		}
		
		
	// the result of the intersection should have max 2 rings, shorten and offset the beamcut length
		PLine plRings[] =ppThis.allRings();
		int bIsOp[] =ppThis.ringIsOpening();
		int n;
		for (int r=0; r<plRings.length();r++)
		{
			if (bIsOp[r] || n>1)continue;
			LineSeg segX = PlaneProfile(plRings[r]).extentInDir(vxSeg);
			double dSub = abs(vxSeg.dotProduct(segX.ptStart()-segX.ptEnd()));
			
			if (dSub>dEps)
			{
				int nDir=1;
				if (vxSeg.dotProduct(segX.ptMid()-ptMid)<0)
				{
					nDir*=-1;	
				}
				
			// perform shortening/offset only for angles >90°
				// this test is required for arced segments with the side not being centered. else it could lead into open triangles
				int bOk=true;
				if (nDir==-1 && dAngleStart<=90) bOk=false;
				else if (nDir==1 && dAngleEnd<=90) bOk=false;
					
				if (bOk)
				{			
					dX-=dSub;
					ptMid.transformBy(-vxSeg*nDir*.5*dSub);	
				}	
			}		
			n++;	
		}	

	// add beamcut
		if (dX>dEps && dY>dEps && dZ>dEps)
		{
			if (bFreeProfile)
			{
				SolidSubtract sosu(Body(ptMid, vxSeg,vySeg,vxSeg.crossProduct(vySeg), dX, dY, dZ,0,0,0), _kSubtract);
				sosu.addMeToGenBeamsIntersect(_GenBeam);
			}
			else
			{
				BeamCut bc(ptMid, vxSeg,vySeg,vxSeg.crossProduct(vySeg), dX, dY, dZ,0,0,0 );
				//bc.cuttingBody().vis(p);
				//gb.addTool(bc);
				bc.addMeToGenBeamsIntersect(_GenBeam);
			}
		}
	}


// free profile is chosen project tooling pline and add free profile
	if (bFreeProfile)
	{
		plTool.projectPointsToPlane(pnRef,vz);
		if (!plTool.coordSys().vecZ().isCodirectionalTo(vecFace))
			plTool.flipNormal();	
		//plTool.vis(20);
		Point3d ptsClose[]={plTool.ptEnd()+vecSide*plTool.length(),plTool.ptStart()+vecSide*plTool.length()};
		FreeProfile fp(plTool,ptsClose);
		fp.setDepth(dDepth);
		fp.setDoSolid(false);
		fp.addMeToGenBeamsIntersect(_GenBeam);
		//Body bd = fp.cuttingBody();
		//bd.transformBy(vecFace*U(200));
		//bd.vis(2);
	}
	

	Display dp(nColor);
	dp.draw(plDefining);

// add annotation
	if(nAnnotation>0)
	{

// reading directions
	Vector3d vxRead = vx;
	Vector3d vyRead = vy;
	
	// align description with pline
	Point3d ptNear = plDefining.closestPointTo(plDefining.getPointAtDist(plDefining.getDistAtPoint(_Pt0)+dEps));
	Vector3d vxSegTxt = ptNear-_Pt0;
	vxSegTxt.normalize();
	vxRead = vxSegTxt;
	vyRead = vxRead.crossProduct(-vz);
	
	
	if (vz.isParallelTo(_ZW)&& _YW.dotProduct(vyRead)<0)
	{
		vxRead*=-1;
		vyRead*=-1;	
	}

// dYFlag
	Point3d ptTxt=_Pt0;
	double dYFlag = 1.5;
	if (abs(nSide)== 1)
		dYFlag*=nSide;
	else 
		ptTxt.transformBy(vyRead*.5*dWidth);
	
// display text
	String sTxt, sTmp;
	sTmp.formatUnit(dWidth, 2,0);
	sTxt += sTmp;	
	sTmp.formatUnit(dDepth, 2,0);
	sTxt += "/"+sTmp;
	dp.draw(sTxt,ptTxt ,vxRead ,vyRead ,0,dYFlag);

// declare dim request map
	Map mapRequests, mapRequest;
	
// publish text info in a request map
	mapRequest.setInt("Color", _ThisInst.color());
	mapRequest.setVector3d("AllowedView", vz);				
	mapRequest.setPoint3d("ptLocation",ptTxt );		
	mapRequest.setVector3d("vecX", vxRead );
	mapRequest.setVector3d("vecY", vyRead );
	mapRequest.setInt("deviceMode", _kDevice);
	mapRequest.setDouble("dXFlag", 0);
	mapRequest.setDouble("dYFlag", dYFlag);			
	mapRequest.setString("text", sTxt);	
	mapRequests.appendMap("DimRequest",mapRequest);


// publish dim requests	
	_Map.setMap("DimRequest[]", mapRequests);

// add annotation
	}// End if(nAnnotation>0)
	else
		_Map.removeAt("DimRequest[]", true);




#End
#BeginThumbnail
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
JT4A2+'T'/YFO3K&T@MX$@MXEAB4<+$H4?I4UJM2"5WOV*I4X2>GXG__9
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
      <str nm="Comment" vl="HSB-14804 description of conversion property enhanced" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="3/15/2022 9:24:21 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14804 bugfix bulge alignment" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="2/25/2022 8:36:51 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End