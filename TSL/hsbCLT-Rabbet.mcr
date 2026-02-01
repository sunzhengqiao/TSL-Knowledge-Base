#Version 8
#BeginDescription
/// This tsl defines a rabbet / tenon joint between T-connected panels
/// The tool stretches the closest edge(s) to the designated plane

#Versions
Version 1.14 29.01.2025 HSB-23351: Add tool maprequest , Author: Marsel Nakuci
1.13 07/08/2024 HSB-22501: check male panel if male panel at a wall gets splitted Marsel Nakuci
1.12 26/03/2024 HSB-21750: Consider case when no body intersection found; Fix tooling for female gable walls Marsel Nakuci
1.11 26/03/2024 HSB-21750: Fix tooling for female gable walls Marsel Nakuci
1.10 08.03.2024 HSB-21589: Swap female sips when tooling fails 
1.9 07/03/2024 HSB-21624: Improve report messages 
Version 1.8 03.06.2022 HSB-15327 new property to define assymetric side offset , Author Thorsten Huck
Version 1.7 24.02.2021 
HSB-10875 toolshape only set to read only if size > 1500mm , Author Thorsten Huck
Version 1.6 23.02.2021
HSB-10875 a beamcut will exported if toolshape is set to not round , Author Thorsten Huck
adding male mortise topol improved









#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 14
#KeyWords SIP,Panel,Rabbet
#BeginContents
/// <summary Lang=en>
/// This tsl defines a rabbet / tenon joint between T-connected panels
/// The tool stretches the closest edge(s) to the designated plane
/// </summary>

/// <insert Lang=en>
/// Select a set of male panels and then a set of female panels.
/// </insert>

/// History
// #Versions
// 1.14 29.01.2025 HSB-23351: Add tool maprequest , Author: Marsel Nakuci
// 1.13 07/08/2024 HSB-22501: check male panel if male panel at a wall gets splitted Marsel Nakuci
// 1.12 26/03/2024 HSB-21750: Consider case when no body intersection found; Fix tooling for female gable walls Marsel Nakuci
// 1.11 26/03/2024 HSB-21750: Fix tooling for female gable walls Marsel Nakuci
// 1.10 08.03.2024 HSB-21589: Swap female sips when tooling fails Author: Marsel Nakuci
// 1.9 07/03/2024 HSB-21624: Improve report messages Marsel Nakuci
// 1.8 03.06.2022 HSB-15327 new property to define assymetric side offset , Author Thorsten Huck
// Version 1.7 24.02.2021 HSB-10875 toolshape only set to read only if size > 1500mm , Author Thorsten Huck
// Version 1.6 23.02.2021 HSB-10875 a beamcut will exported if toolshape is set to not round , Author Thorsten Huck
///<version value="1.5" date=06feb18" author="thorsten.huck@hsbcad.com"> adding male mortise topol improved </version>
///<version  value="1.4" date="27jul15" author="thorsten.huck@hsbcad.com"> double click event toggles alignment, catalog entries accesible through context menu </version>
///<version  value="1.3" date="22jul15" author="thorsten.huck@hsbcad.com"> tool shape correction supports hsbcad 19.1.112 </version>
///<version  value="1.2" date="22jul15" author="thorsten.huck@hsbcad.com"> tool shapes introduced </version>
///<version  value="1.0" date="20jul15" author="thorsten.huck@hsbcad.com"> initial </version>


// constants
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=false;

//region Functions
//region visPp
	void visPp(PlaneProfile _pp, Vector3d _vec)	
	{ 
		_pp.transformBy(_vec);
		_pp.vis(6);
		_pp.transformBy(-_vec);
		return;
	}
//endregion
//endregion 

// geometry
	String sCategoryGeo = T("|Geometry|");

	String sWidthName="(A)   " + T("|Width|");
	PropDouble dWidth(0, U(50),sWidthName);
	dWidth.setDescription(T("|Defines the width of the joint|")+ " " + T("|0 = 50% of thickness|"));
	dWidth.setCategory(sCategoryGeo );

	String sDepthName="(B)   " + T("|Depth|");	
	PropDouble dDepth(1, U(20), sDepthName);
	dDepth.setDescription(T("|Defines the depth|") );
	dDepth.setCategory(sCategoryGeo );

	String sGapSideName="(C1)   " + T("|Gap|") + " " + T("|reference side|");
	PropDouble dGapSide(2, 0,sGapSideName);
	dGapSide.setDescription(T("|Defines the side gap of the joint|"));
	dGapSide.setCategory(sCategoryGeo);

	String sGapSide2Name="(C2)   " + T("|Gap|") + " " + T("|opposite side|");
	PropDouble dGapSide2(5, 0,sGapSide2Name);
	dGapSide2.setDescription(T("|Defines the side gap of the joint|"));
	dGapSide2.setCategory(sCategoryGeo);

	String sGapDepthName="(D)   " + T("|Gap|") + " " + T("|Depth|");
	PropDouble dGapDepth(3, 0,sGapDepthName);
	dGapDepth.setDescription(T("|Defines the gap in depth of the joint|"));
	dGapDepth.setCategory(sCategoryGeo);
	
// tooling
	String sCategoryTooling = T("|Tooling|");

	String sAlignmentName = "(E)   " + T("|Alignment|");
	String sAlignments[] = {T("|Reference Side|"), T("|Center|"), T("|opposite side|")};
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);
	sAlignment.setDescription(T("|Defines the location of the mortise.|"));
	sAlignment.setCategory(sCategoryTooling );
		
	String sOffsetName="(F)   " +T("|Offset|");
	PropDouble dOffset(4, U(50),sOffsetName);
	dOffset.setDescription(T("|Defines the offset from the reference side|"));
	dOffset.setCategory(sCategoryTooling );

	String sToolName = T("|Tool|");
	String sTools[] = {T("|Contact|"), T("|towards bottom|"), T("|towards top|"), T("|both Sides|")};
	PropString sTool(nStringIndex++, sTools, sToolName );
	sTool.setDescription(T("|Defines the extension of the tool if panels have different extents.|"));
	sTool.setCategory(sCategoryTooling );

	String sToolShapeName = T("|Tool Shape|");
	String sToolShapes[] = {T("|not rounded|"), T("|round|"), T("|rounded|")};
	int nRoundTypes[] = {_kNotRound,_kRound,_kRounded};
	PropString sToolShape(nStringIndex++, sToolShapes, sToolShapeName);
	sToolShape.setDescription(T("|Defines the rounding type of the tool.|"));
	sToolShape.setCategory(sCategoryTooling);

		
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }	

	// a potential catalog entry name and all available entries
		String sEntry = _kExecuteKey;
		String sEntryUpper = sEntry; sEntryUpper.makeUpper();
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for (int i=0;i<sEntries.length();i++)
			sEntries[i].makeUpper();
		int nEntry = sEntries.find(sEntryUpper);
		
							
	// silent/dialog
		if (nEntry>-1)
			setPropValuesFromCatalog(sEntry);	
		else
			showDialog();

	// get male panel
		_Sip.append(getSip(T("|Select male panel|")));		
		
	// get selection set
		PrEntity ssE(T("|Select female panel(s)|"), Sip());
		Entity ents[0];
		if (ssE.go())
			ents = ssE.set();

	// cast to sips
		Sip sipFemales[0];
		for (int i=0;i<ents.length();i++)
		{
			Sip sip = (Sip)ents[i];
			if (_Sip[0]==sip || !sip.bIsValid())continue;
			sipFemales.append(sip);
		}	

	// validate female sips
		if (sipFemales.length()<1)
		{
			eraseInstance();
			return;	
		}			
		
	// male and first female may not be parallel
		if (_Sip[0].vecZ().isParallelTo(sipFemales[0].vecZ()))	
		{
			// HSB-21624: Add scriptname
			reportMessage("\n"+scriptName()+" "+ T("|Panels may not be parallel.|"));
			eraseInstance();
			return;	
		}	

	// store all female panels in _Sip
		_Sip.append(sipFemales);		
		
		//_Pt0 = getPoint();					
		return;
	}	
//end on insert________________________________________________________________________________						

// validate references	
	if (_Sip.length()<2)
	{
		reportMessage("\n"+scriptName()+" "+T("|This tool requires at least two panels.|"));
		eraseInstance();
		return;	
	}	
	Sip sip0 = _Sip[0];
	Sip sipMales[] = {sip0};

// collect sips and assign to male and female subsets
	Sip sipFemales[0];
	for (int i=1;i<_Sip.length();i++)
	{
		sipFemales.append(_Sip[i]);
	}
	
	if (_bOnDbCreated)
		setExecutionLoops(2);
	
// first male and female may not be parallel
	if (sip0.vecZ().isParallelTo(sipFemales[0].vecZ()))	
	{
		reportMessage("\n"+scriptName()+" "+ T("|Panels may not be parallel.|"));
		eraseInstance();
		return;	
	}			
	
// collect coordSys
	Vector3d vecX,vecY,vecZ;
	vecX = sip0.vecX();
	vecY = sip0.vecY();
	vecZ = sip0.vecZ();
	Point3d ptCen = sip0.ptCenSolid();
	double dZ = sip0.dH();		

	Vector3d vecXM,vecYM,vecZM;// corresponds to _X0,_Y0,_Z0

	Vector3d vecXF,vecYF,vecZF;
	Sip sip1 = sipFemales[0];
	vecXF = sip1.vecX();
	vecYF = sip1.vecY();
	vecZF = sip1.vecZ();
	Point3d ptCenF = sip1.ptCenSolid();
	double dZF = sip1.dH();
	Element el1 = sip1.element();
	// plenvelope for first female panel
	PlaneProfile ppShadow1( sip1.plEnvelope()); 
	// plenvelope for 2nd female panel if exists
	PlaneProfile ppShadow2;
	if(sipFemales.length()>1)
	{ 
		ppShadow2=PlaneProfile(sipFemales[1].plEnvelope());
	}

// assignTo female
	assignToGroups(sip1, 'T');

// set female envelope body
	Body bdFemale;
	for (int i=0; i<sipFemales.length();i++)
		bdFemale.addPart(sipFemales[i].envelopeBody());
	bdFemale.vis(250);

	Body bdMale;
	for (int i=0; i<sipMales.length();i++)
		bdMale.addPart(sipMales[i].envelopeBody());
	bdMale.vis(5);
// properties by index
	int nTool=sTools.find(sTool);
	int nAlignment=sAlignments.find(sAlignment);	
	int nToolShape = sToolShapes.find(sToolShape);
	int nRoundType;
	if (nToolShape<nRoundTypes.length()) 
		nRoundType= nRoundTypes[nToolShape];

	// HSB-22501: check male panel if male panel at a wall gets splitted
	if(_bOnDbCreated || _bOnDebug)
	{ 
		if(_Map.hasInt("checkMalesForHolzius"))
		{ 
			Element elSip=sip0.element();
			if(elSip.bIsValid())
			{ 
				// element found
				Sip sipsEl[]=elSip.sip();
				// get the one that is closer to the female
				PlaneProfile ppFemale=bdFemale.shadowProfile(Plane(ptCen,_ZW));
				Sip sipMaleClosest=sip0;
				double dClosest=abs(vecZF.dotProduct(sipMaleClosest.ptCen()-ppFemale.ptMid()));
				for (int s=0;s<sipsEl.length();s++) 
				{ 
					double dClosestS=abs(vecZF.dotProduct(sipsEl[s].ptCen()-ppFemale.ptMid())); 
					if(dClosestS<dClosest)
					{ 
						dClosest=dClosestS;
						sipMaleClosest=sipsEl[s];
					}
				}//next s
				if(sipMaleClosest!=sip0)
				{ 
					_Sip[0]=sipMaleClosest;
					setExecutionLoops(2);
					return;
				}
			}
		}
	}

// add double click trigger to swap sides
	if (_bOnRecalc && _kExecuteKey==sDoubleClick)
	{
		if (nAlignment<2)  // current is ref or center
			sAlignment.set(sAlignments[2]);
		else // current is opposite
			sAlignment.set(sAlignments[0]);
		setExecutionLoops(2);
		return; 
	}

// collect all catalog entries and append to custom context to enable hsbRecalcWithKey
	addRecalcTrigger(_kContext, T("|Catalog Entries|"));
	String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
	for (int i=0;i<sEntries.length();i++)
		for (int j=0;j<sEntries.length()-1;j++)
			if(sEntries[j]>sEntries[j+1])sEntries.swap(j,j+1);
			
// arrange entries alphabetically
	for (int i=0;i<sEntries.length();i++)
	{
		String sEntry = sEntries[i];
		if (sEntry==T("|_LastInserted|") || sEntry==T("|_Default|"))continue;
		addRecalcTrigger(_kContext, "   " + sEntry);	
	}

// context trigger fired
	if (_bOnRecalc && sEntries.find(_kExecuteKey.trimLeft())>-1)
	{
		setPropValuesFromCatalog(_kExecuteKey);		
		setExecutionLoops(2);
		return;
	}
	
// find coordinate system of tool	
	Vector3d vecXC,vecYC,vecZC;
	Plane pn1(ptCenF, vecZF);
	int bHasX = Line(ptCen, vecX).hasIntersection(pn1);
	int bHasY = Line(ptCen, vecY).hasIntersection(pn1);
	if (bHasX && bHasY)
	{
		double d1 = abs(vecX.dotProduct(vecZF));
		double d2 = abs(vecY.dotProduct(vecZF));
		if (d1<d2)	bHasX=false;
	}
	if (bHasX)
		vecXM= vecX;	
	else
		vecXM= vecY;	

	Point3d ptX = Line(ptCen, vecXM).intersect(pn1,0);
	if (vecXM.dotProduct(ptX-ptCen)<0)
		vecXM*=-1;
	vecXM.vis(_Pt0,1);	
	
	
	if (el1.bIsValid())
		vecYC = el1.vecY();
	else
		vecYC = vecXM.crossProduct(vecZ);
	vecYC.normalize();	
	vecXC = vecYC.crossProduct(-vecZF);
	vecZC = vecXC.crossProduct(vecYC);
	if (vecXM.dotProduct(vecZC)<0)
		vecZC*=-1;
	vecXC = vecYC.crossProduct(vecZC);	
	vecXC.vis(_Pt0,1);
	
	pn1 = Plane(ptCenF, vecZC);
	
// get a flag which indicates the relation of vecXC to the refside
	int nSide = 1;
	if (vecXC.dotProduct(vecZ)<0) nSide*=-1;
	
	Line lnRef(ptCen+nSide*(nAlignment-1)*vecZ*.5*dZ, vecXM);
	lnRef.vis(2);
	Point3d ptBase = lnRef.intersect(pn1,-.5*dZF);
	if (_bOnDbCreated)
		_Pt0 = ptBase;
	else
		_Pt0 = Line(ptBase,vecYC).closestPointTo(_Pt0);
	ptBase .vis(3);	
	vecYC.vis(_Pt0,3);
	
// get min/max female dimensions at connection
	Body bdTest(_Pt0, vecXC,vecYC, vecZC, dWidth, U(10e3), dDepth*2,0,0,0);//bdTest.vis(1);
	bdTest.intersectWith(bdFemale);
	Point3d ptsExtrFemales[] = bdTest.extremeVertices(vecYC);	
	
// find an edge which is aligned towards the connection
	SipEdge edgeMales[] = sip0.sipEdges();
	for (int e=edgeMales.length()-1;e>=0;e--)
	{
		SipEdge edge = edgeMales[e];
		Vector3d vecNormal = edge.vecNormal().crossProduct(vecXC).crossProduct(-vecXC);	
		vecNormal.normalize();
		if (!vecNormal.isCodirectionalTo(vecZC))
		{
			edgeMales.removeAt(e);
			continue;	
		}
		//vecNormal.vis(edge.ptMid(),3);
	}	

// order
	double dMin=U(10e5);
	if (edgeMales.length()==1)
		dMin=vecZC.dotProduct(ptBase-edgeMales[0].ptMid());
	for (int e=0; e<edgeMales.length();e++)
	{
		for (int f=0; f<edgeMales.length()-1;f++)
		{
			double d1 = vecZC.dotProduct(ptBase-edgeMales[f].ptMid());
			double d2 = vecZC.dotProduct(ptBase-edgeMales[f+1].ptMid());
			if (d1>d2)
			{
				edgeMales.swap(f, f+1);
				if(dMin>d2)
					dMin = d2;
				else if (dMin>d1)
					dMin = d1;
			}
			else if (dMin>d1)
				dMin = d1;
			
		}	
	}

// it should find at least one segment
	if (edgeMales.length()<1)
	{
		reportMessage("\n"+scriptName()+" "+ T("|No male segment found.|"));
		eraseInstance();
		return;			
	}
	
// filter all edges not aligned with the closest
	for (int e=edgeMales.length()-1;e>=0;e--)	
	{
		SipEdge edge = edgeMales[e];
		double d1 = vecZC.dotProduct(ptBase-edge.ptMid());
		if (abs(d1-dMin)>dEps)
		{
			edgeMales.removeAt(e);
		}
	}
	
// set ptRef and stretch edges
	Point3d ptRef = ptBase+vecZC*dDepth+vecXC*dOffset;
	ptRef.vis(6);	
	PlaneProfile ppContact;	
	for (int e=0; e<edgeMales.length();e++)
	{
		SipEdge edge = edgeMales[e];
		edge.ptMid().vis(e);	
	// test rectangle
		PLine plRec;
		plRec.createRectangle(LineSeg(edge.ptStart()+vecXC*20*dEps, edge.ptEnd()-vecXC*20*dEps), vecXC,vecYC);
		PlaneProfile pp(plRec);
		PlaneProfile ppInter1=pp;
		pp.vis(5);
		if(ppInter1.intersectWith(ppShadow1))
		{
			sip0.stretchEdgeTo(edgeMales[e].ptMid(),Plane(ptRef, vecZC));
			ppInter1.vis(3);
			if (ppContact.area()<pow(dEps,2))
				ppContact=ppInter1;
			else
				ppContact.unionWith(ppInter1);			
		}
		else if(sipFemales.length()>1)
		{ 
			// check contact with the second female wall
			pp=PlaneProfile (plRec);
			PlaneProfile ppInter2=pp;
			if(ppInter2.intersectWith(ppShadow2))
			{
				sip0.stretchEdgeTo(edgeMales[e].ptMid(),Plane(ptRef, vecZC));
				ppInter2.vis(3);
				if (ppContact.area()<pow(dEps,2))
					ppContact=ppInter2;
				else
					ppContact.unionWith(ppInter2);			
			}
		}
		else
			pp.vis(1);
	}
	ppContact.vis(4);
	
// the display
	int nColor = _ThisInst.color();
	Display dpModel(nColor);	
	
// declare a perp plane through ptRef
	Plane pnYZ(ptRef, vecXC);

// symbols
	PLine plSymbols[0];
	PLine plFilleds[0];
	
// symbol pline
	Point3d ptSym = ptRef + vecYC*vecYC.dotProduct(_Pt0-ptRef);
	ptSym.transformBy(-vecXC*nAlignment*.5*dWidth);		
	ptSym.vis(2);
	PLine plSym(vecYC);
	plSym.addVertex(ptSym-vecZC*dDepth);
	plSym.addVertex(ptSym);
	plSym.addVertex(ptSym+vecXC * dWidth);
	plSym.addVertex(ptSym+vecXC * dWidth-vecZC*dDepth);
	plSymbols.append(plSym);
	plSymbols.append(PLine(ptSym, ptSym+vecXC*dWidth-vecZC*dDepth));
	plSymbols.append(PLine(ptSym+vecXC*dWidth, ptSym-vecZC*dDepth));
	plSym.vis(2);

// tool dimensions
	double dXBc =dWidth;
	double dYBc;
	double dZBc = dDepth;
	
// decalre tool segments
	LineSeg segs[0];
	
// contact	
	if (nTool==0)
	{
	// collect split segments of pContact	
		Point3d pt = ppContact.extentInDir(vecXC).ptMid();
		segs = ppContact.splitSegments(LineSeg(pt-vecYC*U(10e4),pt+vecYC*U(10e4)), true);	
	}
	else
	{
	// sorting line 
		Line lnY(ptRef, vecYC);	

	// collect extreme points of male panels
		Point3d pts[0];
		for (int e=0; e<edgeMales.length();e++)
		{
			SipEdge edge = edgeMales[e];
			PLine pl = edge.plEdge();
			pl.projectPointsToPlane(pnYZ, vecXC);
			pts.append(pl.vertexPoints(true));
		}	
		pts = lnY.orderPoints(pts);
		
	// set the line segment
		if (pts.length()>1)
		{
			Point3d ptMin = pts[0];
			Point3d ptMax = pts[pts.length()-1];	
			ptMin.vis(222);
			ptMax.vis(120);	

		// get min max of female
			Point3d ptMinF = ptMin-vecYC*U(10e3);
			Point3d ptMaxF = ptMax+vecYC*U(10e3);
			if (ptsExtrFemales.length()>0)
			{
				ptMinF.transformBy(vecYC*vecYC.dotProduct(ptsExtrFemales[0]-ptMinF));
				ptMaxF.transformBy(vecYC*vecYC.dotProduct(ptsExtrFemales[ptsExtrFemales.length()-1]-ptMaxF));	
			}
			
		// common
			Point3d ptsCommons[] = {ptMin,ptMax,ptMinF,ptMaxF};
			ptsCommons= lnY.orderPoints(ptsCommons);		
			
			if (nTool == 1) // bottom
			{
				LineSeg seg(ptsCommons[0], ptMax);
				segs.append(seg);		
			}	
			else if (nTool == 2)// top
			{
				LineSeg seg(ptMin, ptsCommons[ptsCommons.length()-1]);
				segs.append(seg);	
			}
			else if (nTool == 3)// both
			{
				LineSeg seg(ptsCommons[0], ptsCommons[ptsCommons.length()-1]);
				segs.append(seg);		
			}			
		}		
	}
	
	// HSB-21589
	if(segs.length()==0)
	{ 
		if(_Sip.length()>2)
		{
			_Sip.swap(1, 2);
			setExecutionLoops(2);
			return;
		}
	}
	
//  HSB-21750: sort segments in vecYC
	for (int i=0;i<segs.length();i++) 
		for (int j=0;j<segs.length()-1;j++) 
			if (vecYC.dotProduct(segs[j].ptMid()-segs[j+1].ptMid())>0)
				segs.swap(j, j + 1);
		
	// maprequests
	Map mapRequests;
/// apply tool per segment	
	int bHasMortise;
	PlaneProfile ppFemale;
	if(sipFemales.length()>0)
	{
		ppFemale=bdFemale.shadowProfile(Plane(sipFemales[0].ptCen(),sipFemales[0].vecZ()));
	}
	for (int i=0; i<segs.length();i++)
	{
		LineSeg seg = segs[i];
		seg.transformBy(vecXC*vecXC.dotProduct(ptRef-seg.ptMid()));
//		seg.transformBy(vecZC*vecZC.dotProduct(ptRef-seg.ptMid()));
		dYBc = abs(vecYC.dotProduct(seg.ptStart()-seg.ptEnd()));
		Point3d ptBc=seg.ptMid();
		if (dXBc>dEps && dYBc>dEps && dZBc>dEps)
		{
		// version 19.1.112 and  20.0.92 contains a limitation of 1500mm in height for mortise and house
		// remove if statement when this is fixed
			if (dYBc>=U(1500) || nToolShape==0) // HSB-10875 tool shape
			{
				Point3d pt= ptBc+vecZC*dGapDepth;
				if (nAlignment==0)
					pt -=vecXC * dGapSide;					
				else if (nAlignment==1)
					pt += vecXC * .5*(dGapSide2-dGapSide);		
				else
					pt +=vecXC * dGapSide2;// (nAlignment-1)*
				
				LineSeg segMale1=segs[i];
				LineSeg segMale2=segs[i];
				pt.vis(3);
			//  HSB-21750
				if(i==0 && (nTool==1 || nTool==3))
				{
				// toward bottom, or both (female tool)
					Body _bdTest(pt, vecXC, vecYC, vecZC, 
						dXBc+dGapSide+dGapSide2, 10*dYBc, dZBc+dGapDepth,-(nAlignment-1),0, -1);
					if(_bdTest.intersectWith(bdFemale))
					{ 
						_bdTest.vis(6);
						Point3d ptsBd[]=_bdTest.extremeVertices(vecYC);
						if(ptsBd.length()>1)
						{ 
							Point3d pt1=seg.ptStart();
							Point3d pt2=seg.ptEnd();
							if(vecYC.dotProduct(pt1-pt2)>0)
							{ 
								pt1=seg.ptEnd();
								pt2=seg.ptStart();
							}
							pt1-=vecYC*vecYC.dotProduct(ptsBd.first()-pt1);
							LineSeg segNew(pt1,pt2);
							dYBc=abs(vecYC.dotProduct(segNew.ptStart()-segNew.ptEnd()));
							pt+=vecYC*vecYC.dotProduct(segNew.ptMid()-pt);
							ptBc+=vecYC*vecYC.dotProduct(segNew.ptMid()-ptBc);
							segs[0]=segNew;
						}
					}
				}
			//  HSB-21750
				if(i==segs.length()-1 && (nTool==2 || nTool==3))
				{ 
				// toward top or both (female tool)
					seg=segs[segs.length()-1];
					Body _bdTest(pt, vecXC, vecYC, vecZC, 
						dXBc+dGapSide+dGapSide2, 10*dYBc, dZBc+dGapDepth,-(nAlignment-1),0, -1);
					if(_bdTest.intersectWith(bdFemale))
					{ 
						_bdTest.vis(6);
						Point3d ptsBd[]=_bdTest.extremeVertices(vecYC);
						if(ptsBd.length()>1)
						{ 
							Point3d pt1=seg.ptStart();
							Point3d pt2=seg.ptEnd();
							if(vecYC.dotProduct(pt1-pt2)>0)
							{ 
								pt1=seg.ptEnd();
								pt2=seg.ptStart();
							}
							pt2+=vecYC*vecYC.dotProduct(ptsBd.last()-pt2);
							LineSeg segNew(pt1,pt2);
							dYBc=abs(vecYC.dotProduct(segNew.ptStart()-segNew.ptEnd()));
							pt+=vecYC*vecYC.dotProduct(segNew.ptMid()-pt);
							ptBc+=vecYC*vecYC.dotProduct(segNew.ptMid()-ptBc);
							segs[0]=segNew;
						}
					}
				}
				
				BeamCut bc(pt, vecXC, vecYC, vecZC, 
					dXBc+dGapSide+dGapSide2, dYBc, dZBc+dGapDepth,-(nAlignment-1),0, -1);
				bc.cuttingBody().vis(1);
				bc.addMeToGenBeamsIntersect(sipFemales);
				
				Sip sipFemale;
				if(sipFemales.length()>0)
				{ 
					sipFemale=sipFemales[0];
				}
				// HSB-23351
				if(dXBc+dGapSide+dGapSide2<=(U(60)+dEps))
				{ 
					int nColor=5;
					if(vecXM.dotProduct(sipFemale.vecZ())<0)nColor=1;
					PlaneProfile ppBc=bc.cuttingBody().shadowProfile(Plane(sipFemale.ptCen(),sipFemale.vecZ()));
					ppBc.intersectWith(ppFemale);
//					visPp(ppBc,vecXM*U(-1000));
					Map mapRequestPlaneProfile;
					String sStereotypePp="CLTRabbetPp";
					mapRequestPlaneProfile.setString("Stereotype",sStereotypePp);
					mapRequestPlaneProfile.setVector3d("AllowedView", sipFemale.vecZ());
					mapRequestPlaneProfile.setInt("AlsoReverseDirection", true);
					mapRequestPlaneProfile.setInt("Color", nColor);
					mapRequestPlaneProfile.setInt("Transparency", 10);
					mapRequestPlaneProfile.setString("HatchPattern", "ANSI31");
		    		mapRequestPlaneProfile.setDouble("HatchScale", 10);
					mapRequestPlaneProfile.setInt("ShowForDirOfView", true);
				    mapRequestPlaneProfile.setInt("ShowForOppositeDirOfView", false);
				    mapRequestPlaneProfile.setPlaneProfile("PlaneProfile",ppBc);
				    mapRequests.appendMap("DimRequest",mapRequestPlaneProfile);
				}
				double dYBc1=dYBc;
				Point3d ptBc1=ptBc;
				double dYBc2=dYBc;
				Point3d ptBc2=ptBc;
				
				if(i==0 && (nTool==1 || nTool==3))
				{ 
					// toward bottom or both
					seg=segMale1;
					Body _bdTest(ptBc-vecXC*.5*dWidth, vecXC, vecYC, vecZC, 
						U(1000), 10*dYBc, dZBc,-1,0, -1);
					_bdTest.vis(2);
					if(_bdTest.intersectWith(bdMale))
					{ 
						_bdTest.vis(6);
						Point3d ptsBd[]=_bdTest.extremeVertices(vecYC);
						if(ptsBd.length()>1)
						{ 
							Point3d pt1=seg.ptStart();
							Point3d pt2=seg.ptEnd();
							if(vecYC.dotProduct(pt1-pt2)>0)
							{ 
								pt1=seg.ptEnd();
								pt2=seg.ptStart();
							}
							pt1-=vecYC*vecYC.dotProduct(ptsBd.first()-pt1);
							LineSeg segNew(pt1,pt2);
							dYBc1=abs(vecYC.dotProduct(segNew.ptStart()-segNew.ptEnd()));
							ptBc1+=vecYC*vecYC.dotProduct(segNew.ptMid()-ptBc1);
//							ptBc+=vecYC*vecYC.dotProduct(segNew.ptMid()-ptBc);
//							segs[0]=segNew;
							segMale1=segNew;
						}
					}
					seg=segMale2;
					_bdTest=Body (ptBc+vecXC*.5*dWidth, vecXC, vecYC, vecZC, 
						U(1000), 10*dYBc, dZBc,1,0, -1);
					if(_bdTest.intersectWith(bdMale))
					{ 
						_bdTest.vis(6);
						Point3d ptsBd[]=_bdTest.extremeVertices(vecYC);
						if(ptsBd.length()>1)
						{ 
							Point3d pt1=seg.ptStart();
							Point3d pt2=seg.ptEnd();
							if(vecYC.dotProduct(pt1-pt2)>0)
							{ 
								pt1=seg.ptEnd();
								pt2=seg.ptStart();
							}
							pt1-=vecYC*vecYC.dotProduct(ptsBd.first()-pt1);
							LineSeg segNew(pt1,pt2);
							dYBc2=abs(vecYC.dotProduct(segNew.ptStart()-segNew.ptEnd()));
							ptBc2+=vecYC*vecYC.dotProduct(segNew.ptMid()-ptBc2);
//							ptBc+=vecYC*vecYC.dotProduct(segNew.ptMid()-ptBc);
//							segs[0]=segNew;
							segMale2=segNew;
						}
					}
				}
				if(i==segs.length()-1 && (nTool==2 || nTool==3))
				{ 
					// toward top or both
					seg=segMale1;
					Body _bdTest(ptBc-vecXC*.5*dWidth, vecXC, vecYC, vecZC, 
						U(1000), 10*dYBc, dZBc,-1,0, -1);
					if(_bdTest.intersectWith(bdMale))
					{ 
						_bdTest.vis(6);
						Point3d ptsBd[]=_bdTest.extremeVertices(vecYC);
						if(ptsBd.length()>1)
						{ 
							Point3d pt1=seg.ptStart();
							Point3d pt2=seg.ptEnd();
							if(vecYC.dotProduct(pt1-pt2)>0)
							{ 
								pt1=seg.ptEnd();
								pt2=seg.ptStart();
							}
							pt2+=vecYC*vecYC.dotProduct(ptsBd.last()-pt2);
							LineSeg segNew(pt1,pt2);
							dYBc1=abs(vecYC.dotProduct(segNew.ptStart()-segNew.ptEnd()));
							ptBc1+=vecYC*vecYC.dotProduct(segNew.ptMid()-ptBc1);
//							ptBc+=vecYC*vecYC.dotProduct(segNew.ptMid()-ptBc);
//							segs[0]=segNew;
							segMale1=segNew;
						}
					}
					seg=segMale2;
					_bdTest=Body (ptBc+vecXC*.5*dWidth, vecXC, vecYC, vecZC, 
						U(1000), 10*dYBc, dZBc,1,0, -1);
					if(_bdTest.intersectWith(bdMale))
					{ 
						_bdTest.vis(6);
						Point3d ptsBd[]=_bdTest.extremeVertices(vecYC);
						if(ptsBd.length()>1)
						{ 
							Point3d pt1=seg.ptStart();
							Point3d pt2=seg.ptEnd();
							if(vecYC.dotProduct(pt1-pt2)>0)
							{ 
								pt1=seg.ptEnd();
								pt2=seg.ptStart();
							}
							pt2+=vecYC*vecYC.dotProduct(ptsBd.last()-pt2);
							LineSeg segNew(pt1,pt2);
							dYBc2=abs(vecYC.dotProduct(segNew.ptStart()-segNew.ptEnd()));
							ptBc2+=vecYC*vecYC.dotProduct(segNew.ptMid()-ptBc2);
//							ptBc+=vecYC*vecYC.dotProduct(segNew.ptMid()-ptBc);
//							segs[0]=segNew;
							segMale2=segNew;
						}
					}
				}
				ptBc.transformBy(vecXC*-(nAlignment-1)*.5*dWidth);
				ptBc1.transformBy(vecXC*-(nAlignment-1)*.5*dWidth);
				ptBc2.transformBy(vecXC*-(nAlignment-1)*.5*dWidth);
//				BeamCut bc1(ptBc-vecXC*.5*dWidth, vecXC, vecYC, vecZC, U(1000), dYBc, dZBc,-1,0, -1);
				BeamCut bc1(ptBc1-vecXC*.5*dWidth, vecXC, vecYC, vecZC, U(1000), dYBc1, dZBc,-1,0, -1);
				bc1.cuttingBody().vis(6);
				bc1.addMeToGenBeamsIntersect(sipMales);				
//				BeamCut bc2(ptBc+vecXC*.5*dWidth, vecXC, vecYC, vecZC, U(1000), dYBc, dZBc,1,0, -1);
				BeamCut bc2(ptBc2+vecXC*.5*dWidth, vecXC, vecYC, vecZC, U(1000), dYBc2, dZBc,1,0, -1);
				bc2.cuttingBody().vis(2);
				bc2.addMeToGenBeamsIntersect(sipMales);					
				
				if (dYBc>=U(1500))
				{ 
					sToolShape.set(sToolShapes[0]);
					sToolShape.setReadOnly(true);					
				}
			}
			else
			{	
			// symetrical gap for mortises required
				if (dGapSide!=dGapSide2)
				{ 
					dGapSide2.set(dGapSide);
				}

				Point3d pt =ptBc- vecXC * (nAlignment-1)*(.5 * dXBc);
				pt-= vecXC*(nAlignment-1)*dGapSide;
				Mortise msF(pt+vecZC*dGapDepth, vecXC, vecYC, vecZC, dXBc+dGapSide*2, dYBc+dGapSide*2, dZBc+dGapDepth,0,0, -1);//-(nAlignment-1)
				msF.setEndType(_kFemaleSide);
				msF.setRoundType(nRoundType);
				msF.cuttingBody().vis(3);	
				msF.addMeToGenBeamsIntersect(sipFemales);
	
				Mortise ms(pt, vecXC, vecYC, vecZC, dXBc, dYBc, dZBc,0,0, -1);// x:: -(nAlignment-1)
				ms.setEndType(_kMaleEnd);
				for (int i=0;i<sipMales.length();i++) 
					sipMales[i].addTool(ms); 
					
				bHasMortise=true;	
			}
		}
	}
	// HSB-23351
	if(mapRequests.length()>0)
	{
		_Map.setMap("DimRequest[]", mapRequests);
	}


	if (dGapSide>dEps)
	{
		double gapSide = dGapSide;
		plSym.createRectangle(LineSeg(ptSym, ptSym-vecXC*gapSide-vecZC*(dDepth+dGapDepth)),vecXC, vecZC);
		plSym.transformBy(vecZC*dGapDepth);
		if (bHasMortise)plSym.transformBy(-vecXC*(nAlignment-1)*dGapSide);
		plFilleds.append(plSym);
	}
	if (dGapSide2>dEps)//HSB-15327
	{
		double gapSide = dGapSide2;
		plSym.createRectangle(LineSeg(ptSym, ptSym-vecXC*gapSide-vecZC*(dDepth+dGapDepth)),vecXC, vecZC);
		plSym.transformBy(vecZC*dGapDepth+vecXC*(dWidth+dGapSide2));
		if (bHasMortise)plSym.transformBy(-vecXC*(nAlignment-1)*dGapSide2);
		plFilleds.append(plSym);		
	}	
	if (dGapDepth>dEps)
	{
		plSym.createRectangle(LineSeg(ptSym, ptSym+vecXC*dWidth+vecZC*dGapDepth),vecXC, vecZC);
		if (bHasMortise)plSym.transformBy(-vecXC*(nAlignment-1)*dGapSide2);
		plFilleds.append(plSym);	
	}
	//plSym.vis(2);



// draw symbols
	if (plFilleds.length()>0)	
		for (int i=0;i<plFilleds.length();i++)
			dpModel.draw(PlaneProfile(plFilleds[i]), _kDrawFilled,50);

	for (int i=0;i<plSymbols.length();i++)
	{
		if (plFilleds.length()>0 && i==0)continue;	
		dpModel.draw(plSymbols[i]);		
	}

	for (int i=0;i<segs.length();i++)
		dpModel.draw(segs[i]);	


	










#End
#BeginThumbnail
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
0=..F3G%=4!@`>E+10!__V<N<
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="707" />
        <int nm="BreakPoint" vl="815" />
        <int nm="BreakPoint" vl="572" />
        <int nm="BreakPoint" vl="665" />
        <int nm="BreakPoint" vl="843" />
        <int nm="BreakPoint" vl="668" />
        <int nm="BreakPoint" vl="337" />
        <int nm="BreakPoint" vl="685" />
        <int nm="BreakPoint" vl="681" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23351: Add tool maprequest" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="1/29/2025 6:11:28 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22501: check male panel if male panel at a wall gets splitted" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="8/7/2024 4:40:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21750: Consider case when no body intersection found; Fix tooling for female gable walls" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="3/26/2024 1:41:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21750: Fix tooling for female gable walls" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="3/26/2024 11:31:04 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21589: Swap female sips when tooling fails" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="3/8/2024 1:54:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21624: Improve report messages" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="3/7/2024 7:52:57 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15327 new property to define assymetric side offset" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="6/3/2022 9:58:20 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10875 toolshape only set to read only if size &gt; 1500mm" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="2/24/2021 8:09:48 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10875 a beamcut will exported if toolshape is set to not round" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="2/23/2021 9:16:20 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End