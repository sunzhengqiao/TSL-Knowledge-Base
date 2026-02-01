#Version 8
#BeginDescription
version value="1.1" date="23jan2018" author="thorsten.huck@hsbcad.com"
display text changed to 'Edge Relief'

This tsl creates relief cuts between two or more panels.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <History>//region
/// <version value="1.1" date="23jan2018" author="thorsten.huck@hsbcad.com"> display text changed to 'Edge Relief' </version>
/// <version value="1.0" date="23jan2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select panels, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates relief cuts between two or more panels.
/// </summary>//endregion



// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	//endregion

	String sGapReliefName=T("(A)   |Gap Relief|");	
	PropDouble dGapRelief(nDoubleIndex++, U(0), sGapReliefName);	
	dGapRelief.setDescription(T("|Defines the gap of the relief cut|"));
	dGapRelief.setCategory(category);
	
	String sSideName=T("(B)   |Side|");
	String sSides[] = { T("|Reference Side|"), T("|Opposite Side|") };
	PropString sSide(nStringIndex++, sSides, sSideName);	
	sSide.setDescription(T("|Defines the Side|"));
	sSide.setCategory(category);

// Display
	

// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();

		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
		else	
			showDialog();
		
	// prompt for male or all panels
		PrEntity ssM(T("|Select panel(s)|"), Sip());
	  	Entity males[0];
	  	if (ssM.go())
			males.append(ssM.set());
			
	// prompt for female and not all panels
		String sMsgOption = males.length() > 1 ?T(" |<Enter> to cut all edges|"):"";
		PrEntity ssF(T("|Select female panel(s|") + sMsgOption , Sip());
	  	Entity females[0];
	  	if (ssF.go())
			females.append(ssF.set());
		
	// differentiate ssets
		if (females.length()>0)
		{ 
			for (int j=0;j<females.length(); j++)
			{ 
				int n = males.find(females[j]);
				if (n>-1) 
				{ 
					males.removeAt(n);
				}				
			}
		}
		
	// dump panles in _Sip
		if (males.length()<1)
			eraseInstance();
		for (int i=0;i<males.length();i++) 
			_Sip.append((Sip)males[i]); 
			
	// store females additionaly in EntityArray
		for (int i=0;i<females.length();i++) 
		{
			_Sip.append((Sip)females[i]);
			_Map.setEntityArray(females, false, "female[]", "", "female[]");
		}

		
		return;
	}	
// end on insert	__________________
	

	//reportMessage("\nstarting " + _ThisInst.handle());

// default coordSys
	Vector3d vecX, vecY, vecZ;
	Point3d ptOrg;
	Sip sip;
	double dH;


// get edit in place flag
	int bEditInPlace=_Map.getInt("directEdit");
	int nMode = _Map.getInt("mode");
	
// requires at least two panels
	if (_Sip.length()<2)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|requires at least two panels.|"));
		eraseInstance();
		return;
	}
// the first male specifies the base reference
	else
	{ 
		sip = _Sip[0];
		assignToGroups(sip, 'T');
		vecX = sip.vecX();
		vecY = sip.vecY();
		vecZ = sip.vecZ();	
		ptOrg = sip.ptCenSolid();
		if (_bOnDbCreated && nMode==0)_Pt0 = ptOrg;
		dH = sip.dH();
	}

// ints
	int nSide = sSides.find(sSide, 0);
	Vector3d vecFace = (nSide ? 1 :-1) * vecZ;
	Point3d ptFace = ptOrg + vecFace * .5 *dH;
	CoordSys csFace(ptFace, vecX, vecX.crossProduct(-vecFace), vecFace);

// TriggerFlipSide
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContext, sTriggerFlipSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
	{
		if (nSide==0)nSide=1;
		else nSide = 0;
		sSide.set(sSides[nSide]);
		setExecutionLoops(2);
		return;
	}
	
	
// Trigger Reset
	String sTriggerReset = T("|Reset relief cut|");
	addRecalcTrigger(_kContext, sTriggerReset );
	if (_bOnRecalc && _kExecuteKey==sTriggerReset)
	{
		dGapRelief.set(0);
		setExecutionLoops(2);
		return;
	}	


// purge any panel not being coplanar to the face or set dependency
	double dRefH = dH;
	for (int i=_Sip.length()-1; i>0 ; i--) 
	{ 
		double _dH = _Sip[i].dH();
		Vector3d vec = _Sip[i].vecZ();	
		Point3d pt= _Sip[i].ptCenSolid()+vecFace*.5*_dH;
		if (abs(vecFace.dotProduct(pt-ptFace))>dEps)
			_Sip.removeAt(i);
		else
		{
		// set ref height to thinnest panel
			if (_dH < dRefH)dRefH = _dH;
			_Entity.append(_Sip[i]);
			setDependencyOnEntity(_Sip[i]);
		}
	}

// get references
	Sip males[0], females[0];
	Body bodies[0];
	PlaneProfile ppShadows[0];
	double dMerge = U(1);
	Entity entFemales[0];
	entFemales = _Map.getEntityArray("female[]", "", "female[]");
	for (int i=0;i<_Sip.length();i++) 
	{ 
		int n = entFemales.find(_Sip[i]);
		if (n>-1)
			females.append(_Sip[i]);
		else
			males.append(_Sip[i]);
			
	// collect body
		bodies.append(_Sip[i].realBody());
		
		PlaneProfile pp(csFace);
		pp.joinRing(_Sip[i].plShadow(),_kAdd);
			
	// snap mode1 to edge
		if (nMode==1)
			_Pt0 = pp.closestPointTo(_Pt0);
		
		pp.shrink(-dMerge);
		ppShadows.append(pp);
	}
	
// invalid set
	if (males.length()<1)
	{ 
		reportMessage("\n"+ scriptName() + ": "+T("|Tool will be deleted.|"));
		eraseInstance();
		return;		
	}

// no females found, use same sset for females
	int bConnectAll;
	if (females.length()<1)
	{ 
		bConnectAll = true;
		females = males;
	}
		
// show males and females
	if (bDebug)
	{
		for (int i=0;i<males.length();i++) 
			vecFace.vis(males[i].ptCen(),1);  
		for (int i=0;i<females.length();i++) 
			-(females[i].vecZ()).vis(females[i].ptCen(),2); 	
	}
	
// collect edges and its sip ref index
	SipEdge edges[0];
	int nSipRefs[0];
	for (int i=0;i<_Sip.length();i++) 
	{ 
		SipEdge _edges[]= _Sip[i].sipEdges();
		for (int e=0;e<_edges.length();e++) 
		{ 
			nSipRefs.append(i); 
			edges.append(_edges[e]);
		}
	}

// declare display
	Display dp(nSide==0?3:4);

// flag if one relief cut has been found
	int bHasRelief;
	
// collect collinear segments
	int nNumRelief;
	for (int i=0;i<edges.length();i++)
	{ 
		int a = nSipRefs[i];
		SipEdge e1 = edges[i];
		Vector3d vecNormal1 = e1.vecNormal();
		Vector3d vecN1 = vecNormal1;
		if (!vecN1.isPerpendicularTo(vecZ))
			vecN1 = vecN1.crossProduct(vecZ).crossProduct(-vecZ);
	
	// edge data
		Point3d ptM1 = e1.ptMid();
		Vector3d vecX1 = vecN1.crossProduct(vecFace);
		double dX1 = Vector3d(e1.ptEnd() - e1.ptStart()).length();
		vecX1.normalize();
		Plane pn1(ptM1, vecNormal1);
		
	// first panel
		Sip sip1 = _Sip[nSipRefs[i]];
		Point3d ptCen1 = sip1.ptCenSolid();
		double dH1 = sip1.dH();
		int bIsFemale1 = females.find(sip1) >- 1;

		for (int j=i+1;j<edges.length();j++)
		{ 
			int b = nSipRefs[j];
		// skip same edge or same ref
			if (i == j || a==b){continue;}
			 
			SipEdge e2 = edges[j]; 
			Vector3d vecNormal2 = e2.vecNormal();
			Vector3d vecN2 = vecNormal2;
			if (!vecN2.isPerpendicularTo(vecZ))
				vecN2=vecN2.crossProduct(vecZ).crossProduct(-vecZ);			
			
		// second edge data	
			Point3d ptM2 = e2.ptMid();
			Vector3d vecX2 = vecN2.crossProduct(vecFace);
			double dX2 =  Vector3d(e2.ptEnd() - e2.ptStart()).length();
			vecX1.normalize();
			
		// second panel
			Sip sip2 = _Sip[nSipRefs[j]];
			Point3d ptCen2 = sip2.ptCenSolid();
			double dH2 = sip2.dH();
			int bIsFemale2 = females.find(sip2) >- 1;
	
		// skip if not parallel or codirectional
			if (!vecN1.isParallelTo(vecN2) || vecN1.isCodirectionalTo(vecN2))
			{ 
				continue;
			}
		// skip if not collinear
			else if (dGapRelief>0 && abs(vecN1.dotProduct(ptM1-ptM2))>dGapRelief)
			{ 
				continue;
			}
		// skip if of same type
			else if (!bConnectAll && bIsFemale1==bIsFemale2)
			{ 
				continue;
			}
//			vecN1.vis(ptM1, 1);
//			vecN2.vis(ptM2, 2);	

		// get common length
			PlaneProfile ppEdge(csFace);
			PLine pl;
			pl.createRectangle(LineSeg(ptM1+vecX1*.5*(dX1-4*dMerge-dEps)+ vecN1*U(50),ptM1-vecX1*.5*(dX1-4*dMerge-dEps)- vecN1*U(50)), vecX1, vecN1);
			ppEdge.joinRing(pl,_kAdd);
			PlaneProfile ppX = ppShadows[a];
			ppX.intersectWith(ppShadows[b]);
			ppX.intersectWith(ppEdge);
			ppX.vis(6);
			if (ppX.area() < pow(dEps, 2))continue;
			
			LineSeg segX = ppX.extentInDir(vecX1);
			Point3d ptX = segX.ptMid(); //ptX.vis(1);
			double dXCommon = abs(vecX1.dotProduct(segX.ptStart()-segX.ptEnd()));


			Plane pnX(ptM1, vecX1);
			Body bdEdge1(ptX, vecX1, vecN1, vecFace, dX1, dH, dRefH, 0 ,0, -1);
			bdEdge1.intersectWith(bodies[a]);
			//bdEdge1.vis(2);
			PlaneProfile pp1 = bdEdge1.shadowProfile(pnX);
			
			Body bdEdge2(ptX, vecX2, vecN2, vecFace, dX2, dH, dRefH, 0 ,0, -1);
			bdEdge2.intersectWith(bodies[b]);
			//bdEdge2.vis(3+j);
			PlaneProfile pp2 = bdEdge2.shadowProfile(pnX);
			
			Point3d pts1[] = Line(ptM1,-vecN1).orderPoints(pp1.getGripVertexPoints());
			if(pts1.length()>0)
				pts1 = Line(ptM1,-vecFace).orderPoints(Plane(pts1[0], vecN1).filterClosePoints(pts1, dEps));
			Point3d pts2[] = Line(ptM2,-vecN2).orderPoints(pp2.getGripVertexPoints());
			if(pts2.length()>0)
				pts2 = Line(ptM2,-vecFace).orderPoints(Plane(pts2[0], vecN1).filterClosePoints(pts2, dEps));			
			
		// the reference point is the lowest point on the touching plane	
			Point3d ptRef = ptX;
			if (pts1.length()>0 && pts2.length()>0)
			{ 
				ptRef.transformBy(vecFace * vecFace.dotProduct(pts1[0] - ptRef));
				
				double d2 = vecFace.dotProduct(pts2[0] - ptRef);
				if (d2 > dEps) ptRef.transformBy(vecFace * d2);
				
			}
		// fall back to face if below ptCen
			if (vecFace.dotProduct(ptRef-ptOrg)<0)
				ptRef = ptX;
			ptRef.vis(2);
	 		
	 		Point3d ptRefB = ptRef - vecFace *  dRefH;//(vecFace.dotProduct(ptRef-ptCen1) + .5
	 		//ptRefB.vis(3);
	 		
	 		Point3d pt1 = ptRefB - vecN1 * .5 * dGapRelief;//pt1.vis(3);
	 		Point3d pt2 = ptRefB - vecN2 * .5 * dGapRelief;
	 		
	 		Vector3d vecZ1 = pt1 - ptRef; vecZ1.normalize();
	 		Vector3d vecZ2 = pt2 - ptRef; vecZ2.normalize();
	 		
	 		Vector3d vecY1 = vecX1.crossProduct(-vecZ1);
	 		Vector3d vecY2 = vecX2.crossProduct(-vecZ2);
	 		//e2.plEdge().vis(j);
	 		
//	 		vecX1.vis(pt1, 1);
	 		vecY1.vis(pt1, 3);
//	 		vecZ1.vis(pt1, 150);
//	 		vecX2.vis(pt2, 2);
	 		vecY2.vis(pt2, 4);
//	 		vecZ2.vis(pt2, 160);	


			if (bEditInPlace)
			{ 
			// prepare tsl cloning
				TslInst tslNew;
				Vector3d vecXTsl= vecX1;
				Vector3d vecYTsl= vecN1;
				GenBeam gbsTsl[] = {sip1, sip2};
				Entity entsTsl[] = {};
				Point3d ptsTsl[] = {ptRef};
				int nProps[]={};
				double dProps[]={dGapRelief};
				String sProps[]={sSide};
				Map mapTsl;	
				mapTsl.setInt("mode", 1);
				Entity ents[] ={ sip2};
				mapTsl.setEntityArray(ents, false, "female[]", "", "female[]");
				String sScriptname = scriptName();
				
				tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
						nProps, dProps, sProps,_kModelSpace, mapTsl);	
				continue;
			}


			if (nMode==1 && ppX.pointInProfile(_Pt0)!=_kPointInProfile)
			{
				continue;
			}

//			if (dXCommon<dX1-5*dMerge)
//			{ 
//				BeamCut bc(ptRef, vecX1, vecY1, vecZ1, dXCommon, dH, dH * 3, 0, -1, 0);
//				//bc.cuttingBody().vis(1);
//				sip1.addTool(bc);
//			}
//			else 
			if (!bDebug)
			{
				sip1.stretchEdgeTo(ptM1, Plane(pt1, vecY1)); 
			}

//			if (dXCommon<dX2-5*dMerge)
//			{ 
//				BeamCut bc(ptRef, vecX2, vecY2, vecZ2, dXCommon, dH, dH * 3, 0, -1, 0);
//				//bc.cuttingBody().vis(2);
//				sip2.addTool(bc);
//			}
//			else 
			if (!bDebug)
			{
				sip2.stretchEdgeTo(ptM2, Plane(pt2, vecY2)); 
			}

	 		PLine plSym(vecX1);
	 		plSym.addVertex(ptRef);
	 		plSym.addVertex(pt1);
	 		plSym.addVertex(pt2);
	 		plSym.close();
	 		
	 		dp.draw(plSym);
	 		dp.draw(PLine(ptRef-vecX1*.5*dXCommon, ptRef+vecX1*.5*dXCommon));
	 		
	 		Body bdSym(plSym, vecX1 * dXCommon, 0);
	 		PlaneProfile ppSym = bdSym.extractContactFaceInPlane(Plane(ptRef - vecFace * dRefH, vecFace), dEps);
	 		if (ppSym.area()>pow(dEps,2))
	 			dp.draw(ppSym,_kDrawFilled,80);

		// text
			dp.draw(T("|Edge Relief| ") + dGapRelief, ptRefB, vecX1, vecY1, 0, 1.5, _kDevice);

			nNumRelief++;
	 		if (!bHasRelief && nMode==0)
	 		{
	 			_Pt0 = ptRef;
	 			bHasRelief = true;
	 		}
		}		
	}
	
	
	if (dGapRelief<=0 || bEditInPlace)
		eraseInstance();

	
// TriggerEditInPlacePanel
	if (nMode==0 && nNumRelief>1)
	{
		String sTriggerEditInPlace = T("|Edit in Place|");
		addRecalcTrigger(_kContext, sTriggerEditInPlace );
		if (_bOnRecalc && _kExecuteKey==sTriggerEditInPlace )
			{
			if (bEditInPlace)
			{
				bEditInPlace=false;
				_PtG.setLength(0);
			}
			else
				bEditInPlace= true;
			_Map.setInt("directEdit",bEditInPlace);
			_Map.setInt("mode",1);
			setExecutionLoops(2);
			return;
		}		
	}


	
	
	
	
	
	
#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`'5`G$#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*Y+QQXYB\&P6N
MVR-]<W!8B!9=A"*,LY.T\#CMZ^E=;7FVA0Q>,OB!KVKW"K-IUE$=-ME(RK9R
M'(_7\&IQ5W_7];DR=EZG?:9J$&K:7:ZA;-NAN(UD0^Q'3ZCI5NO//AC<R:=-
MK/A&Y<F72KEC!NZM"QX/YX/_``*O0Z<TD]-F*#;6NZ"BBBI+"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`0D*I9B``,DGM7D^F?$'6)O&4%Y<OCPM?WDEE:Y11M
M90`K[L9Y)]>[>E=1\3M<.A^";HQMMN+PBUB.[&"V<G\%!KE]>B\,CX4)HMIK
MNE/>6,*SQ;+R,L9E^9MO.<G+#\:N%E[SVV_S^XRJ-OW4[/?_`"_$]9HK"\&Z
MX/$7A+3]2)S*\>V7G^-?E;]1G\:W:F47%M,N,E**:"BBBD4%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!15>^O;?3;">]NY/+MX$
M,DC[2=JCDG`Y/X5RG_"U_!/_`$&O_)6;_P"(II-["<DMSLZ*K6&HV6J6JW5A
M=0W4#<"2%PPSZ<=_:K-)JVX)IZH****!A1110`4444`%%%%`!69X=NIK[P[I
M]U<OOFEA5G;`&3^%:=8WA+_D4M*_Z]U_E3Z"ZD/C77/^$>\(ZAJ"N%F6,I#_
M`-=&X7\B<_A7(^$_AJ8O#=G))XA\06,]Q&)YH;.\\J,,PS]W:><8!/M7IM%.
M,K)VZBE'F:;Z'D6HZ5_PK[X@:)JXU*_N[742;6[GOYA(XS@#+8'`^4_\!KUV
MBBARNDGT%&"BVUU,RVNIG\2ZA:,^8(K6WD1<#AF:4,?QVK^5:=8UI_R..K?]
M>5I_Z%/6S292"BBBD,****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`**Q->\7:'X8>!-8OOLS3@F,>4[[@,9^ZIQU%4;#XC^$=3NUMK;6X?-
M;[HF1X@?;+J!GVSFFHMZI$N44[-G4T444B@HHHH`****`"BBB@`HHHH`S-:N
MIK2.R,#[#)>PQ/P#E6;!%:=8WB/_`%6F_P#81M__`$*MFGT%U.&\1^&[[Q+X
M]T<WEBK^'["-I':1T*RR'^'9G)'"]1CK70?\(AX9_P"A=TC_`,`H_P#XFMFB
MCF=K"Y5=MG#^`M`U3PQJ6N:=-:E=(DN#/8S"12,'@KM!R.-O4=C72^(;J:QT
M"\N;=]DT:95L`XY'K6G6-XL_Y%;4/^N?]13O=JXN7E3L;-%%%26%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`&!XX_P"1%US_`*\I
M?_036!X&\2^'K7P%I=M>ZUID4B6^V2&6Y0,.3P5)S^%;_CC_`)$77/\`KRE_
M]!-87@/PSH%YX&TBXNM$TV>>2#+R2VD;,QR>22,FKC;E=_+]3.5^>-O/]"C\
M,X4E\0^)-2TJ!X/#]S*HM!L*([#.XHIZ#^60.V!Z57EOA7[)9_%?4K'PS*'T
M1K7S;F.%]T,<W'W>V?I[CM@6_$VDZGH=O_:L/B[5Y]9EN56TM&D403L6P(Q"
M!C[O4]."W%4U=Q]%_D3%N*EZO_,]'HI%SM&X8..:6LC9!1110`4444`%%%%`
M&7XCL+O5/#M_8V%S]FNIXBD<N2-I^HY&>F1ZUQGPY\-ZY9>$XC+K\T,<[>;%
M#$B2!%('=U)!/7`X_6O1ZQO"7_(I:5_U[K_*J3?+8AQ3DF']DZK_`-#)=_\`
M@-!_\11_9.J_]#)=_P#@-!_\16S12N5RHQO[)U7_`*&2[_\``:#_`.(H_LG5
M?^ADN_\`P&@_^(K9HHN'*CS#PWX6UZQ^*VHWUWK!N+=(_-D)8[IDDWB-2N,#
M:5)XX&!CKQZ?6-:?\CCJW_7E:?\`H4];-.3NR8126@4445)84444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110!YI\0+B"T^(?@RXN9HX88Y)"\
MDC!5497DD\"IOB)K_A;4_"5Q:+>6.I7TOR645JZS2"4]"NW)7],].^*A^(%O
M!=_$/P9;W,,<T,DD@>.10RL,KP0>#6QXJ\,>"[;PY>/?Z;IEA%Y9VSQ0I$X?
M!(VE0"3QT[],&KT]FK]W^9E9NK*WE^1N>%;>\M/"FE6^H;OM<=LBRACD@XZ$
M^HZ5KUY_X+@UK7_AC917.JWEC/(Y`ND`,K0!L8!/()&0&ZC@\]*L>&XKO3/&
ME[I-OK5_JVFQ6H>X:^E$KV\Y;Y5W\=5R=O;\:J<;S8J<K0CH=Q11161L%%%%
M`!1110`4444`><?%/P[K&MMH\FFWXAC2X$1C9V0"1R-K\>GZ=JZJ#1M8CMXT
M?Q-=LZJ`S?9X>3CKRE2>(_\`5:;_`-A&W_\`0JV:KF=DB%%<S9C?V3JO_0R7
M?_@-!_\`$4?V3JO_`$,EW_X#0?\`Q%;-%*Y7*C&_LG5?^ADN_P#P&@_^(KD?
MB-X:UR]\+.8M?FF2%Q)+#*B1AUZ=449P2#@\?D*]'K&\6?\`(K:A_P!<_P"H
MIQDTR913BR;P[87>E^';"QO[K[3=01!))<D[C]3R<=,GTK3HHJ2TK*P4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44$X&36/;:A?RP+(8
M8,.2RY<@[2>.WIB@#0OK*WU*PGLKN/S+>=#'(FXC<IX(R.1^%<I_PJCP3_T!
M?_)J;_XNN@^VWO\`SPM_^_C?X4?;;W_GA;_]_&_PIIM;"<4]T3:7H^FZ+:BV
MTRQ@M8N,B)`-V!C+'JQ]SDUP<)\76_B.[U>X\&/J%R6:.UD?5842"'/`1.=I
M(QDYR?;I7;?;;W_GA;_]_&_PH^VWO_/"W_[^-_A34G>XG%-66AH0M(\$;RQ^
M5(R@O'NW;3CD9[XI]9GVV]_YX6__`'\;_"C[;>_\\+?_`+^-_A4E(TZ*S?MU
M[_SZ6Y_[>#_\11]OO?\`GTM__`@__$4`:5%9OV^]_P"?2W_\"#_\11]OO?\`
MGTM__`@__$4`:5%9OV^]_P"?2W_\"#_\11]OO?\`GTM__`@__$4`:54=&L&T
MO1K2Q:02-!$$+`8!Q4?V^]Q_QZ6__@0?_B*9X<U<ZYH<%^\0B=RP>,'.TAB/
MZ5/,D^7O_7ZE*FW%SZ+3[_\`AC5HHHJB0HHHH`HPV#1:W>7YD!6X@AB"8Y&P
MR'/X[Q^57JYBY\2WPU^^TZTL8)4M!'N=Y2I)9<^A_P`BG?VYK'_0-M/_``)/
M_P`36:K0?7^D:NA4CNO/[]3I:*YK^W-8_P"@;:?^!)_^)H_MS6/^@;:?^!)_
M^)H]K#N+V4^QTM%<U_;FL?\`0-M/_`D__$T?VYK'_0-M/_`D_P#Q-'M8=P]E
M/L=+17-?VYK'_0-M/_`D_P#Q--;7-<)^33[(#WG8_P#LM'M8=P]E/L=/17+?
MVWKW_/C8?]_F_P`*/[;U[_GQL/\`O\W^%'M8=P]E/L=317+?VWKW_/C8?]_F
M_P`*/[;U[_GQL/\`O\W^%'M8=P]E/L=317+?VWKW_/C8?]_F_P`*/[;U[_GQ
ML/\`O\W^%'M8=P]E/L=317/:#J]_=ZI>VFHQQ(ZHDL(C.1M/!Y[\_P`ZZ&K3
M35T0TT[,****8@HHHH`**IZE<RVULI@56F>140-T]3^@-0?;;W_GA;_]_&_P
MH`KZ]X1T/Q.\#ZQ8_:6@!$9\UTV@XS]UAGH*SK3X9^#K*Y6>+0X6=<X$TCRK
MSZJ[$'\16S]MO?\`GA;_`/?QO\*/MM[_`,\+?_OXW^%-2:5DR7&+=VBMXI_M
M>/PY-%X?M3+>MMC18Y$C*)GYBI;@$#IZ''!K)\'G6;`1:9-X0.EV0#.]TVI1
MSN\G=F`&69CU-;_VV]_YX6__`'\;_"C[;>_\\+?_`+^-_A33LF#C=I]C3HK,
M^VWO_/"W_P"_C?X4OVV]_P"?>W/MYK#_`-EJ2C2HK-^WWO\`SZ6__@0?_B*/
MM][_`,^EO_X$'_XB@#2HK-^WWO\`SZ6__@0?_B*/M][_`,^EO_X$'_XB@#2H
MK-^WWO\`SZ6__@0?_B*/M][_`,^EO_X$'_XB@"34[!K]+55D">3<QSG(SD*<
MXJ]7/:KXANM,BMI7LH3'+<)"Q$Y.T,>OW170U*FFW'L4Z;45-[/]`HHHJB0J
MCK%@VIZ1<V2R"-IEVAB,@<U>K*\2:NVAZ#<:@D:RO%M"HQP"2P']:4IJ"<GT
M*A!U)*$=WH:M%<U_;NL_]`VT_P#`D_\`Q-']N:Q_T#;3_P`"3_\`$U'M8=RO
M93['2T5S7]N:Q_T#;3_P)/\`\31_;FL?]`VT_P#`D_\`Q-'M8=P]E/L=+17-
M?VYK'_0-M/\`P)/_`,31_;FL?]`VT_\``D__`!-'M8=P]E/L=+17-'7-9P<:
M=9Y[9N6_^)J/^V]>_P"?&P_[_-_A1[6'</93['4T5RW]MZ]_SXV'_?YO\*/[
M;U[_`)\;#_O\W^%'M8=P]E/L=317+?VWKW_/C8?]_F_PH_MO7O\`GQL/^_S?
MX4>UAW#V4^QU-%<M_;>O?\^-A_W^;_"JU_X@U^WM&F^R6B+&0SE'+':#SP1Z
M4_:0?47LY]CLJ*:CK)&KH<JP!!]13JL@****`"BBB@"KJ+F/3K@@X8H57ZG@
M?J:JJH1`HZ`8%3:H<P0Q_P!^91^7S?\`LM14`%%%%`!1110`4444`%%%%`!1
M110`4444`%9/@@^5;:M9G_EWU&4*/]DX(_K6M6-X>/D>,-?MOX95AG0?\!(/
MZUA4TJ0?JOP_X!TT=:52/DG]S2_4ZRBBBMSF"BBFR.L4;2.<*@+$^PH`X+1R
M9]7UZ\)SYE\T0/LG`_G6S6%X14_\(_'.WW[B1Y6^I8C^E;M>13=XW[_J>U75
MJC7;3[M`HHHJS$****`"BBB@`HHHH`****`"BBB@""!_(\4:=(.!.DD#'\-P
M_5:ZVN,U!O)>QN>@AO(F8^Q.T_\`H5=G7=0=X'#75IA1116QB%%%%`&=?G=?
M6T?95>0_7@#^9IM-F._5)C_<C1/QY)_F*=0`4444`%%%%`!1110`4444`%%%
M%`!1110!S_C52?"US(OWHFCD7ZAQ78QN)(U=?NL`17->)(O.\-:DG_3N[?D,
M_P!*U]!F^T>'M-FSDO:QD_7:,U@M*S\TOP;_`,SIEKAH^4G^*7^1H4445N<P
M5R?Q`R^B6=L/^7B^BB/XY/\`2NLKC_&K&34_#UJ/XKII?^^`#_6N?%/]R_ZW
M.O`K_:(OMK]RN6J***XSI"BBB@`HHHH`****`"BBB@`HHHH`*9-$)X)(F^ZZ
ME3^(Q3Z*`-'PU.;CPW8.WWEB$;?5?E/\JU:P/"C8L[VW_P">-Y(`/0-AA_Z%
M6_7IIW5SS&K.P4444Q!1110!G:@<WEHGH'D_(`?^S4VB[.=5`_N0?S;_`.QH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`*PXC]G^(T#=%NM/:/ZLK;OY5N5
M@ZR?L_B;PY>=`+AX#_VT7`K"OI%/LU^9TX76;CW3_*_YG8T445N<P5E>);@6
MOAC4Y2<$6S@'W(P/U-:M<O\`$&79X2GA'WKB6.)?KN!_H:RKRY:4GY,WPL>>
MO"/FBEH<(@T*QC`QB!2?J1D_J:OTB*$144851@"EKSTK*QWRES2;[A1113)"
MBBB@`HHHH`****`"BBB@`HHHH`H:TI?1KK;U5-X_X#S_`$KLH9!-!'*O1U##
M\17+W2>;:31_WD9?S%;/A^7SO#NG.3DFW0$^X`%=>&>C1R8E:IFE11172<P4
M444`9"'=<W<G]Z8C\@%_I4E06AW0;_[[N_YL34]`!1110`4444`%%%%`!111
M0`4444`%%%%`$-W%Y]E/#C/F1LN/J,5!X'F\_P`&Z:WHC)_WRQ']*NUE>`SL
MT*XMO^?:]FBQZ8.?ZUA+2M%^3_0Z8:X>:[-?J=11116YS!7%^)',OCC1X>T%
MO+*?^!?+_2NTKA[]_/\`B+/Z6^GK'^);=_6N7%OW$N[7^9VX%?O&^R?^7ZFE
M1117*;A1110`4444`%%%%`!1110`4444`%%%%`"^'FV:WJL/]]8I1^14_P`A
M72URVEG9XM(SQ)8G\2KC_P"*-=37H4G>"//JJTV%%%%:&84444`94IW:I<'T
M1%_]"/\`6G4P_P#(1O/]Y1_XZ*?0`4444`%%%%`!1110`4444`%%%%`!1110
M`5SWC$^3I-O>_P#/G>0SY],-C^M=#61XI@^T>%]13&<0E_\`OGYOZ5CB%>E)
M+L=&$DHUX-]T=515+2+C[7HMC<YSYMO&Y_%0:NUK%W5S&47&3B^@5R'CA_,N
M-!LL9\R^$I'L@Y_]"KKZXOQ$QG\=:3!VMK62<_\``OE_H*Y\6_W5N]OS.K`K
M]]?LF_P9>HHHKD.@****`"BBB@`HHHH`****`"BBB@`HHHH`*N>$CGPQ9K_<
MWI^3L/Z53JUX2)_L(`]IYA_Y$:NG#;LYL3LC<HHHKK.0*1B%4L>@&:6H[CBV
ME/\`L'^5`&18@BPM\]?+4GZXJQ45M_QZP_[B_P`JEH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`*R/"!\O4?$-K_`';[S<?[XS_2M>L;0CY/CC7(NT\,$H_`
M;?ZUA5TG!^?Z,Z:&M.HO*_XHZRBBBMSF"N$MV$_C3Q#,/X6AB'X)@_J*[NO/
M]!(EN];N1SYFI2@'U`/'\ZX\6_A7G^AWX)6C4?DE^*_R-JBBBN<U"BBB@`HH
MHH`****`"BBB@`HHHH`****`(;<[/%.FG^_',A_('^E=97(C'_"2:,3_`,])
M1_Y#:NNKOH?`C@K_`!L****U,@HHHH`R3_R$+W_?7_T!:?39.-3N1ZA#^A']
M*=0`4444`%%%%`!1110`4444`%%%%`!1110`5%=0BXM)H#TDC9#^(Q4M%)JZ
ML--IW11\#3F?P=IY;[R*T9'IM8C^0%=#7*^!SY5MJME_S[:C*JC_`&3@C^M=
M566'?[J/I^1T8Q)5YVZN_P!^H5PTS&X^(&J2=1;6T4`_X%\_^-=S7`:.?/U?
M7KPG.^^:('V3@?SK'%O2*\_T-L$M)R\K?>T;-%%%<YJ%%%%`!1110`4444`%
M%%%`!1110`4444`%6?"6?[%;T^TS8_[[-5JM^$A_Q3=LW=WE;\Y&KIPV[.;$
M[(VZ***ZSD"HKK_CTF_ZYM_*I::Z[XV7U!%`&5;_`/'M%_N#^525!9'=86[>
ML2G]*GH`****`"BBB@`HHHH`****`"BBB@`HHHH`*PX#Y/Q'C/:XTTK^(?/\
MJW*P;\^3XV\/3=I!/$W_`'QQ^M85]D^S7YV.G"ZRE'O&7Y7_`$.QHHHK<YA"
M0JEB<`#)->>^$`3X?CF/WIY))#]=Q']*[76I3;Z#J,P.#';2,/P4UR?AR+R?
M#M@OK$&_[ZY_K7#BG^\BO)_H>CA5:A)]VOR9J4445B6%%%%`!1110`4444`%
M%%%`!1110`4444`5O^9AT?U\V3_T6U=?7)1#=XHTH?W5F;_QT#^M=;7=0^!'
M#7^-A1116QB%%%%`&7<C;JK'^_"OZ$_XBEIVH#;>6LG8AX_Q.&_]E--H`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`,;PZ?(\8^(+;^&40SJ/^`D']:Z
MRN0B/V;XC0-T6ZT]H_JRMN_E77UA0T4H]F_\_P!3JQ6KC+O%?@K?H-D=8HVD
M<X506)]A7GWA%3_8$<[??N)'E;ZEB/Z5UWB6X%KX8U.4G&+9P#[D8'ZFN?T.
M$0:%8Q@8Q`A/U(R?U-<^*=ZB79,Z,*K4)/NU^"?^9?HHHK(H****`"BBB@`H
MHHH`****`"BBB@`HHHH`CGD\JWDD_N*6_(5K>&X?(\-Z<G<P*Q_$9_K7/:RY
M31[K;]YTV#ZM\H_G786\(M[:*$=(T"#\!BNO#+1LY,2]4B6BBBNDY@HHHH`Q
M;,;;94_YYED_[Y)']*GJ*,;+BZC_`+LQ/_?0#?UJ6@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`KG_$A\J^T&Y_N:E&A/H&R#_*N@KGO&GR>'_M/>WGBE'X,
M!_6L,3_"D^VOW'3@_P"/%=]/OT.THHZC(HK<YC!\:SFW\':FX[Q!/^^F"_UK
M/L(C!IUK">L<2+^0`J3XA.?^$8^SCK<W,47ZY_\`9:DKSJ[O6?HOU/3H*V'7
MFW^2"BBBH&%%%%`!1110`4444`%%%%`!1110`4444`1Z:OF>+4STALV8?5G`
M_H:ZJN:\/+YFMZK/V18H5/X%C_,5TM>A25H(\^J[S84445H9A1110!1U4?Z(
MLO\`SRD5OPS@_H3457KB(7%M+">DB%?S%9EO(9;:-S]YE!(]#WH`EHHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`P-9/V?Q/X<N^F+AX"?]]<"NRKB_&)\
MG2;>]_Y\[R*?/IAL?UKM*PIZ59KT?X6_0ZJNM&G+U7XW_4Y?X@2[/"4\(^]<
M2QQ+]=P/\@:5%"(J*,*HP!5?QP_F3Z%98SYE\)2/9!S_`.A59KDK.]9^5E^O
MZG525L/%=VW^GZ!1114@%%%%`!1110`4444`%%%%`!1110`4444`4[M/M%]I
MEH.?-NE9AZJF6/\`(5V5<MI:?:?%+/U6SMOR=S_@IKJ:[Z"M!'!7=YL****U
M,@HHHH`R[@;-4;TEB!'U4D'^:TM/U-=KVTW]V38Q]F'^(6F4`%%%%`!1110`
M4444`%%%%`!1110`4444`%8_BN+SO"VHKCI%N_[Y(/\`2MBJFIQ>?I-Y#_ST
M@=?S4BHJQYH->1K0ERU8R[-&GI<WVG2+*?KYD"/^:@U;K$\'S>?X1TM_2`)_
MWS\O]*VZ*<N:"?D%:/+5E'LV<CXY??)H5K_?U!9/P4<_SJQ5/Q4PE\7>'X.O
MEK/*1]5`'ZBKE>?4=ZLOZZ'HQ5J%->3?XO\`R"BBBD2%%%%`!1110`4444`%
M%%%`!1110`4454U.<VVEW,H^\L9"X]3P/U-"5W8&[*YI^$DSI,MU_P`_5S)*
M/IG:/T6MZJFF6@L=*M;7&/*B5#]0.?UJW7II65CS&[NX4444Q!1110`5D(OE
M7-S#V60NOT;G^9/Y5KUFWJ^7J$,G:5"A^HY'Z%J`$HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`R/%,'VCPOJ*8SB$O\`]\_-_2MW2+C[7HUC<YSYMO&Y
M_%0:J74(N+2:`])(V0_B,56\#3F?P=IY;[R*T9'IM8C^0%8;5O5?D_\`@G3O
MAO27YK_@&9XB<S^.=)@[6UK).?\`@7R_T%7JS)F:X^(.J2=5MK:*`?\``L/_
M`(UIUPMWG)^?Y:?H=TE:$(]DOQU_4****9`4444`%%%%`!1110`4444`%%%%
M`!11534K@VNFW$R_>5#M_P!X\#]<4)7=@;LKFCX3CWVEW?GDW5PQ4_["_*O\
MC^==!532[,:?I5K:#_EC$JGW..3^=6Z]-*RL>8W=W"BBBF(****`*]]"9[&:
M-?OE<I_O#D?J!5**02Q)(OW74,/QK5K&@7RS-!_SRD*CZ'D?H10!-1110`44
M44`%%%%`!1110`4444`%%%%`!00",'H:**`,OP"Q'A6.W/6WFEB/_?9/]:Z>
MN5\%GRVURU_YYZE(P'H&`Q_*NJK##?PHKMI]QTXS^/)]]?OU.)U8B;XB1CKY
M&FY^A+G^AK0K*_UOCW7)<Y\J.&(?BN3^HK5KAO>4GYO_`".^:M&"\E^*O^H4
M444S,****`"BBB@`HHHH`****`"BBB@`JI<Q_:]1TVQ[2SB1QZHGS']<5;I-
M$C^T>)+N<_=M8%A7_><[C^@'YUK1C>:,JTK09T]%%%=YP!1110`4444`%4=4
M7_15E[Q2*WX9P?T)J]5:_3S-.N4'4Q-CZXH`JT4V-M\:O_>`-.H`****`"BB
MB@`HHHH`****`"BBB@`HHHH`*R?`Y\JUU6S/_+MJ,JJ/]DX(_K6M6)H,BV?B
MSQ%$YQ&R0W`^FT[C^=85=)P?JOP_X!U4?>I5(^2?W-+]3.T<^?J^OWA.=]\T
M0/LG`_G6S6%X14_V!',WWYY'E;ZEB/Z5NUY]-WC?OK]YZ%=6J./;3[M`HHHJ
MS$****`"BBB@`HHHH`****`"BBB@`JG>)]IO=-L^TUTI8>JIES_(5<J*S7S?
M%=HO_/&VEE_,JO\`4UI15YHSK.T&=71117H'GA1110`4444`%9=P/+U1_26(
M-^(.#^A6M2L[41BZM']2Z?F,_P#LM`#:***`"BBB@`HHHH`****`"BBB@`HH
MHH`****`,;PV?*\7>(H.S&"5?Q4Y_6NLKD;`^3\1KA.@N--#_4J^/Y5UU84/
MA:[-_G<Z<5K*,N\8_E;]#@-(S+K7B"Y/.Z_:+/\`N<?UK9K"\*,9=+GNFZW-
MU++^9Q_2MVO/@[QOW/1KJU1KMI]V@44459B%%%%`!1110`4444`%%%%`!111
M0`58\)IG3)KL];JYDD!_V0=H_1:I7,GDVLTO]Q&;\A6QX>A\CPYIT?\`T[HQ
M^I&3_.NG#+=G-B7LC3HHHKK.0****`"BBB@`I&&Y2OJ,4M(3@$GH*`,6Q.[3
M[8^L2G]!5BJ]@,:=;`]HE_D*L4`%%%%`!1110`4444`%%%%`!1110`4444`%
M<?X@N1INOWLY.T76C2Q#_?!X_I785PWQ'MGDBTV5/O>8\7'?<!_A7+C;JBY+
MH=^6I/$*$MG=&OH<(@T*QC`QB!2?J1D_J:OTB*$144851@"EKD2LK&\Y<TG+
MN%%%%,D****`"BBB@`HHHH`****`"BBB@`I-(&?%<QQ]VQ7GZN?\*6DT@X\5
M3CULE_1S_C6V'^,QK_`=/1117<<(4444`%%%%`!5#5/^70^D_P#[*PJ_5#5.
MEJ/6<?\`H+4`1T444`%%%%`!1110`4444`%%%%`!1110`4444`85P?)\?:+)
MT\^":+/T&ZNGU"?[+IEU<?\`/*%W_($URVNGR==\.W/]V]\K/^^,?TK9\63_
M`&?PGJC^MNR?]]#;_6N92Y?:>6OX([91Y_8KOI_Y,SFO"T9B\,V*GNA;\V)_
MK6Q5/28_*T>RC[K`@/\`WR*N5PP5HI'75ES5)/NV%%%%69A1110`4444`%%%
M%`!1110`4444`4M7.W1KT_\`3%Q^E=99KLL;=/[L:C]*Y/6!G1KT?],6/Z5U
MMHV^R@;UC4_I77AMF<F)W1-11172<P4444`%%%%`!4%[)Y5A<2?W8F/Z5/5+
M53_H#(.LC*@'KDC/Z9H`K1)Y<*)_=4"GT44`%%%%`!1110`4444`%%%%`!11
M10`444C,%4LQ`4#))[4`#,J*68@*.234-QHD&LVV-01@F=T*@D-&>S_7VJW:
MVQE99YE(4',<9'_CQ]_0=OKTOTFDU9C3:=T<<C7%E=_V??D>=C,4P&%G7U'H
MP[BK=;6I:;!JEH;><$<[D=>&C8=&!]:YN*2>UNSI]_@7*C,<@&%G7^\/?U':
MN2M1M[T=CKHUK^[(M4445SG0%%%%`!1110`4444`%%%%`!1110`5'8-Y7BR`
MGI-:2(/J&4_XU)525_(UK2+@_=$YB)_WU('ZXK2B[31G65X,[&BBBO0//"BB
MB@`HHHH`*S]2.;BS3T=G_)2/_9JT*S+L[]44?\\X3_X\?_L:`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@#GO&!\O3;.Z_Y]KZ&7/I@X_K5WX@2;?!UU
M&/O3/'&OUW@_TJMXRB\WPG?J.JJK_DP/]*9XRG6\TC0ES_Q]7T#$>J[23_,5
MPUW;VB[I?JCT\*N;V+[2?X69<50BA1T`P*6BBL"@HHHIB"BBB@`HHHH`****
M`"BBB@`HHHH`@O(_.L;B+^_$R_F*W="F\_0-/E_O6Z9^NT9K)JSX1?/A^.$_
M>MY9(6'IAC@?D175AGNCEQ*V9NT445U'*%%%%`!1110`5G:@V^[M8NR[I3^`
MP/\`T(_E6C65(WF:E</V0+$/P&X_^A?I0`ZBBB@`HHHH`****`"BBB@`HHHH
M`***"0!DG`'4T`(2%4EB`!R2:DMK<SLLTJD1@YC0CK_M'^@_'Z);6YN6$L@Q
M".44_P`?N?;T%:-`!1110`52U33(-5M?)ERKJ=T4J_>C;L15VB@#CX9IX;EK
M"_`6[09#`869?[R_U':K5:^JZ5#JML(W8QRQG=#,OWHV]1_4=ZYZWGF2X>QO
M4$=Y$,D#[LB_WU]OY5Q5J7+[RV.VC5YM'N6J***P-PHHHH`****`"BBB@`HH
MHH`*HZPC/I4[1_ZR("5/JIW?TJ]2,`RE2,@C!%-.SN)JZL=%;3K<VL,Z?<E0
M.OT(S4M8GA24MH$4#'+VKO;M_P`!8@?IBMNO3/,"BBB@`HHHH`*R$;S+FYF_
MO2E1]%^7^8-:DTHA@DE;[J*6/X"LFU0QVL:M][:"WU[_`*T`34444`%%%%`!
M1110`4444`%%%%`!1110`4444`4-<B\_0=0BQDM;2`?7:<5S5Q-]L@\$QYS^
MY9V^J(O]0:[*1!+$\;=&4J?QKSKP_(US?Z)"W6TL9B?8F5U_EBO/QCM)+O\`
MHT>KEZO3D_Y?UC)':4445F(****`"BBB@`HHHH`****`"BBB@`HHHH`*7PZ_
MD:QJ=F>!)LN4'U&UOU44E5XG^R^)=.GZ+,'MG/U&Y?U6MJ#M,QKJ\#KJ***[
MCA"BBB@`HHHH`IZM<75IHU[<V-O]INXH'>&'_GHX4E5_$X%?/W_">_$T/(RZ
M/.-[ER!IC]2?I7T;17I8#'4<,FJE&-2_?H1*+EL['SG_`,)_\3O^@3/_`."Q
M_P#"C_A/_B=_T"9__!8_^%?1E%>A_;6%_P"@2']?(GV<OYCYS_X3_P")W_0)
MG_\`!8_^%'_"?_$[_H$S_P#@L?\`PKZ,HH_MK"_]`D/Z^0>SE_,?.?\`PG_Q
M._Z!,_\`X+'_`,*/^$_^)W_0)G_\%C_X5]&44?VUA?\`H$A_7R#V<OYCYS_X
M3_XG?]`F?_P6/_A1_P`)_P#$[_H$S_\`@L?_``KZ,HH_MK"_]`D/Z^0>SE_,
M?.?_``G_`,3O^@3/_P""Q_\`"C_A/_B=_P!`F?\`\%C_`.%?1E%']M87_H$A
M_7R#V<OYCYS_`.$_^)W_`$"9_P#P6/\`X5W'PUU[Q;XCU2Z@\2Z6\-G#%YB2
MM;-#N?(`0Y^\,9/'ISUKU2BN?$YIAZU)TX8:,6^JW0XP:=[A1117BF@4444`
M%%%%`!61XCTXWNDS2P1EK^WC:2U*'#>8!PN?0G@BM>BFK)ZZ@?-[^-OB5O;_
M`(DUPG/W1IK\?F*;_P`)K\2O^@1<?^"U_P#"OI*BO=_M7!?]`</Z^1/[S^=G
MS;_PFOQ*_P"@1<?^"U_\*/\`A-?B5_T"+C_P6O\`X5])44?VM@O^@.']?(/W
MG\[/FW_A-?B5_P!`BX_\%K_X4?\`":_$K_H$7'_@M?\`PKZ2HH_M;!?]`</Z
M^0?O/YV?-O\`PFOQ*_Z!%Q_X+7_PH_X37XE?]`BX_P#!:_\`A7TE11_:V"_Z
M`X?U\@_>?SL^;?\`A-?B5_T"+C_P6O\`X4?\)K\2O^@1<?\`@M?_``KZ2HH_
MM;!?]`</Z^0?O/YV?-O_``FOQ*_Z!%Q_X+7_`,*/^$U^)7_0(N/_``6O_A7T
ME11_:V"_Z`X?U\@_>?SL\A^%6O\`B^]U^\M-8TB6*QE0SO,]LT6R3@#&>#GT
MZ\9KUZBBO+QF(IUZO/3IJ"[+8<4TM7<****Y1A1110!P/Q3USQ+HVDVB^'M-
M:Z%R[+<2+"TIC``P-H]>>3Z>]>8_\)_\3O\`H$S_`/@L?_"OHRBO8P>9T*%)
M4YX>,WW>YG*#;NF?.?\`PG_Q._Z!,_\`X+'_`,*/^$_^)W_0)G_\%C_X5]&4
M5U?VUA?^@2']?(7LY?S'SG_PG_Q._P"@3/\`^"Q_\*/^$_\`B=_T"9__``6/
M_A7T911_;6%_Z!(?U\@]G+^8^<_^$_\`B=_T"9__``6/_A1_PG_Q._Z!,_\`
MX+'_`,*^C**/[:PO_0)#^OD'LY?S'SG_`,)_\3O^@3/_`."Q_P#"C_A/_B=_
MT"9__!8_^%?1E%']M87_`*!(?U\@]G+^8^=8_'7Q2E;;'HUT[=<+I;D_RJ7_
M`(3+XL_]"_??^"B3_"OH6BI>=8;IA(![.7\Q\]?\)E\6?^A?OO\`P42?X4'Q
MC\6<?\@"^'O_`&1)_A7T+11_;6'_`.@6`>S?\S/G3_A*_B[_`-`G4_\`P3G_
M`.(H_P"$K^+O_0)U/_P3G_XBOHNBJ_MS#_\`0)#[O^`+V3_F9\Z?\)7\7?\`
MH$ZG_P""<_\`Q%95I<_$NQNFN;?0]565E*D_V4YX+;CQM]:^H**B6<865G+!
MTW;R_P"`:0]I!-1FU<^;O^$B^+'_`$"-4_\`!0W_`,11_P`)%\6/^@1JG_@H
M;_XBOI&BC^V,+_T!T_N_X`K5/YV?.">)/BNK9.BZDX]#I#8_1:D_X2CXJ_\`
M0OW_`/X*9/\`"OHNBI>;81_\P=/[A_O/YV?.G_"4?%7_`*%^_P#_``4R?X4?
M\)1\5?\`H7[_`/\`!3)_A7T711_:N$_Z`Z?W!^\_G9\V_P#":_$K_H$7'_@M
M?_"C_A-?B5_T"+C_`,%K_P"%?25%/^UL%_T!P_KY!^\_G9\V_P#":_$K_H$7
M'_@M?_"C_A-?B5_T"+C_`,%K_P"%?25%']K8+_H#A_7R#]Y_.SYM_P"$U^)7
M_0(N/_!:_P#A1_PFOQ*_Z!%Q_P""U_\`"OI*BC^UL%_T!P_KY!^\_G9\V_\`
M":_$K_H$7'_@M?\`PH_X37XE?]`BX_\`!:_^%?25%']K8+_H#A_7R#]Y_.SY
MM_X37XE?]`BX_P#!:_\`A3'\7_$>5X6?1[DF&594_P"):_WE.1VKZ5HIK-L&
MML'#^OD)JH]'-E+1[F[O-%L;F_MOLUY+`CSP?\\W(!(_`U=HHKPI-.3:5BPH
MHHJ0"BBB@`HHHH`*YC4_B'X5T;49M/O]4\FZA($D?V>5L$@'J%(Z$5T]>7:-
MJFGZ7\8/%<FH7]K9H\<05KB98PQVKP-Q&:J"O*S[,BI)QC==TCM=$\8^'O$4
MC1:5JD,\H_Y9$%'/?(5@"1[@8K<KRGQC=Z7XA\7^'8_#4D-YK$5RLLUU9D,(
MX`1G>Z\8]LG'/][GU:B25DPC)MM,****DL****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@"O?7MOIMA/>W<GEV\"&21]I.U1R3@<G\*Y3_`(6OX)_Z#7_DK-_\16IX
MX_Y$77/^O*7_`-!-8'@;Q+X>M?`6EVU[K6F12);[9(9;E`PY/!4G/X544K-_
MUU(E)J22\_T.UL-1LM4M5NK"ZANH&X$D+AAGTX[^U6:\U^&<*2^(?$FI:5`\
M'A^YE46@V%$=AG<44]!_+(';`]*HDK,(2YD%%%%26%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`5Y=HVEZ?JGQ@\5QZA86MXB1Q%5N(5D"G:O(W`XKU&N8U/X>>
M%=9U&;4+_2_.NIB#))]HE7)``Z!@.@%5!VE=]F14BY1LNZ9R'Q.TS0-#T^SN
M='AMM.\0I.ALTL5$<C@G!RJ]1[D=>.Y!Z_Q-%XBN/#R'3M1ATYUMWDO)?*WR
M9"9VIV&3D$]1P1TJ;1_`WAG0;C[1IVD01S9!65RTK(1G[I<DKU[8K6U2&2XT
MF\@B7=))`Z(N<9)4@42E[EEJ$(^_=Z&?X.GFNO!NCSW$KRS26D;/)(Q9F)')
M)/4UMUD>%;*XTWPII5E=Q^7<06R1R)N!VL!R,C@UKTZEN=V"G?D5^P4445!8
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`8'CC_D1=<_Z\I?_`$$UA>`_#.@7G@;2+BZT
M339YY(,O)+:1LS')Y)(R:[2^LK?4K">RNX_,MYT,<B;B-RG@C(Y'X5RG_"J/
M!/\`T!?_`":F_P#BZJ+237I^I$HMM->?Z&!X4^R6?Q7U*Q\,RA]$:U\VYCA?
M=#'-Q]WMGZ>X[8&KJA\16OC_`$-[O6%_L^YNY8XK&V0HNP1D@R'.6;V/`QD=
M:[#2]'TW1;46VF6,%K%QD1(!NP,98]6/N<FLK7],O+WQ%X;N[>'?!9W,CSMN
M`V*8R`<$Y//I5<RNO(GD:BSHJ***S-0HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**X#Q+X_DL=0:TTQ8Y!'
MP\C<C=Z"N<E\?Z_+TN(T'^S&!7GU,RH0DXZNQZU')L35BIZ)/N>Q45X,/B)J
M\.MV?FZA*\"3*9USP5SR/RKW='#HKJ<AAD5T8?$*M&Z5CFQN!J81I3=[]AU<
MYXK\:Z/X0LS+?SAIR/W=NAR[_P"`]ZZ.OCSQ7<SW7BK5)+B5Y6%S(`7.<`,<
M"NRG#F>IYE:HX+0^KO#6KG7_``[8ZJT0B-U&)-@.=N:U:Y;X<?\`)/-$_P"O
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
=110`4444`%%%%`!1110`4444`%%%%`!1110!_]E%
`

#End