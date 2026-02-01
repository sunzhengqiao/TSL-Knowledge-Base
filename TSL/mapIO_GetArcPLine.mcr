#Version 8
#BeginDescription
/// Version 1.4   th@hsbCAD.de   08.11.2010
/// return map for an converted circle fixed

/// This tsl converts a given segmented polyline into an polyline with arcs if at least three short segments
/// could form an arc. if the polyline consists bulges the tsl will fail. It can be called via mapIO or be inserted
/// on a pline with straight segments


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl converts a given segmented polyline into an polyline with arcs if at least three short segments
/// could form an arc. if the polyline consists bulges the tsl will fail. It can be called via mapIO or be inserted
/// on a pline with straight segments
/// This TSL is exclusively used as a function of  other tsl's. It can not be inserted and used by the user.
/// To ensure the functionality one must save this tsl in the path <hsbCompany>\TSL.
/// </summary>

/// <insert Lang=en>
/// if inserted not through mapIO one can select a polyline (only straigh segments, no bulges)
/// </insert>


/// This tsl can be called by another TSL using the function static int callMapIO(String strScriptName, Map& mapIO);
/// The following map entries are available for the call of this mapIO TSL
/// <PLine> pline								The pline which will be converted into a pline with arced and tsraight segments
/// <double> MaxSegLength	(optional)	the maximal length of a segment which can be considered of being part of an arc
/// <int> reportDebug (optional)			If set to true debug messages will be shown
/// The return values are the converted polyline, a map of arcs which contains the centerpoints and the chord points as well as the arc:
/// mapIO.getPLine("pline")
/// mapIO.getMap("Arc[]");
/// 	mapArc.getPoint3d("ptCenter")  
/// 	mapArc.getPoint3d("ptChord")
/// 	mapArc.getPLine("arc")


/// sample
/// 	Map mapIO;
///	mapIO.setPLine("pline",plEnvelope);
///	mapIO.setDouble("MaxSegLength",U(3));
///	mapIO.setInt("reportDebug", false);
///   TslInst().callMapIO("mapIO_GetArcPLine", mapIO);
///   PLine plReturn = mapIO.getPLine("pline");
///	Map mapArcs = mapIO.getMap("Arc[]");
///	for (int a=0;a<mapArcs.length();a++)///
///	{			
///		Map mapArc = mapArcs.getMap(a);
///		Point3d ptCen = mapArc.getPoint3d("ptCenter");
///		Point3d ptChord= mapArc.getPoint3d("ptChord");
///	
///		DimRequestRadial drRad(strParentKey,ptCen,ptChord);
///		drRad.addAllowedView(vzView, TRUE); //vecView
///		addDimRequest(drRad);
///		drRad.vis(6);		
///	}

/// History
/// Version 1.4   th@hsbCAD.de   08.11.2010
/// return map for an converted circle fixed
/// Version 1.3   th@hsbCAD.de   05.11.2010
/// Version 1.0   th@hsbCAD.de   28.10.2010



// standards
	U(1,"mm");
	double dEps = U(.1);
	PropDouble dMaxSegLength(0, U(5), T("|max Segment Length|"));
	int bReportDebug =0;
	PLine plEnvelope;
		
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();
	    _Entity.append(getEntPLine());	
		_Pt0 = getPoint();
		return;	
	}
// end on insert	
// on mapIO
	else if (_bOnMapIO)
	{
		bReportDebug  = _Map.getInt("reportDebug");
		plEnvelope = _Map.getPLine("pline");
		if (_Map.hasDouble("MaxSegLength"))
			dMaxSegLength.set(_Map.getDouble("MaxSegLength"));
		else
			dMaxSegLength.set(U(3));
		if(bReportDebug)
		{
			reportMessage("\nConversion started...");	
			reportMessage("\n   max segment length	" + dMaxSegLength);	
			reportMessage("\n   vertices	" + plEnvelope.vertexPoints(true).length());
		}	
	}
	else
	{
	// get the pline from entity
		for (int i=0;i<_Entity.length();i++)
		{
			Entity ent =_Entity[i];
			if (ent.bIsKindOf(EntPLine()))
			{
				setDependencyOnEntity(ent);
				EntPLine epl =(EntPLine) ent;
				plEnvelope=epl.getPLine();
				break;// only the first	
			}
		}	
	}	


	if(bReportDebug)
	{
		reportMessage("\ncontinue...");
		reportMessage("\n   vertices	" + plEnvelope.vertexPoints(true).length());
	}
	
// profile and vec	
	Vector3d vz = plEnvelope.coordSys().vecZ();
	PlaneProfile pp(plEnvelope);
	PLine plRecompose = plEnvelope;
	
// the vertices
	Point3d ptEnv[] = plEnvelope.vertexPoints(true);	
	int nMax = ptEnv.length();
	
// the display	
	Display dp(0);

// potential recomposing the pline to retrieve arcs and straight segments
	int nAddMode[ptEnv.length()]; // 0 = not set, 1= straight, 2=start point , 3= on arc, 4=end point, 5 start and end point on alternating arcs
	int bArConcave[ptEnv.length()];
	int bAddArc;


// conversion is only done for plines with at least 5 vertices
	int n;
	if (ptEnv.length()>4)
	{
	// flag if it has arcs
		int bHasArc;	
		
	// flag if circle
		int bIsCircle=true;		
		
	// flag if previous segment was an arc
		int bPreviousIsArc;
		
		
		for (int i=0;i<nMax;i++)			
		{
			
		// looking back three segments
			Point3d ptX[0], ptMid[0];
			Vector3d vxSeg[0];
			double dLSeg[0];
			
			Point3d pt0,pt1,pt2,pt3;
															ptX.append(ptEnv[i]);
			n = i-1;		if (n<0)	n = nMax+n;		ptX.append(ptEnv[n]);
			n = i-2;		if (n<0)	n = nMax+n;		ptX.append(ptEnv[n]);
			n = i-3;		if (n<0)	n = nMax+n;		ptX.append(ptEnv[n]);			

		// get segments vecs and length
			int bValidLength=true;
			for (int p=1;p<4;p++)
			{
				ptMid.append((ptX[p-1]+ptX[p])/2);
				//ptMid[p-1].vis(p);
				Vector3d vxTemp = ptX[p-1]-ptX[p];
				if (vxTemp.length()>dMaxSegLength) bValidLength=false ;
				vxTemp.normalize();
				vxSeg.append(vxTemp);	
			}

		// create a temp arc
			PLine plArcTest(vz);
			plArcTest.addVertex(ptX[0]);
			plArcTest.addVertex(ptX[3],ptX[2]);
			if (i==37)plArcTest.vis(4);			
			
			
		// test if all on arc
			double dClosest = (plArcTest.closestPointTo(ptX[1])-ptX[1]).length();

		// test middle segment: if distance of midpoints is a lot bigger than other mid distance it is convex hull of an eight
			int bDebugMid=1;
			double dMid1 = (plArcTest.closestPointTo(ptMid[0])-ptMid[0]).length();
			double dMid2 = (plArcTest.closestPointTo(ptMid[1])-ptMid[1]).length();
			double dMid3 = (plArcTest.closestPointTo(ptMid[2])-ptMid[2]).length();			
			double dMidAverage = (dMid1+dMid2+dMid3)/3 + dEps;

			//if (bDebugMid) reportNotice("\ni="+i+ " dMid1=" + dMid1+ " dMid2 " + dMid2+ " dMid3=" + dMid3 + " average="+dMidAverage);
			
				
		// test and store previous segment direction, convex/concave
			Vector3d vxMitre = vxSeg[1]-vxSeg[0];	vxMitre.normalize();
			vxMitre.vis(ptX[1],1);
				
			n = i-1;		if (n<0)	n = nMax+n;	
			bArConcave[n] = pp.pointInProfile(ptX[1]+vxMitre*dEps)==_kPointInProfile;

		// collect node types
			int bDebugTypes = 0;
		// arced	
			if(abs(dClosest)<dEps && bValidLength && dMid2<dMidAverage)
			{
				if (i==37)	PLine(ptEnv[i],ptEnv[i]+(_XW+_YW)*U(200)).vis(5);
				bHasArc=true;
			// start point
				if (!bPreviousIsArc)
				{
					n = i-3;
					if (n<0)	n = nMax+n;
					if (nAddMode[n]==4)
						nAddMode[n] = 5;
					else
						nAddMode[n] = 2;
					if (bDebugTypes) ptEnv[n].vis(nAddMode[n]);						
				}				
				
			// on arc
				n = i-2;
				if (n<0)	n = nMax+n;
				nAddMode[n] = 3;
				if (bDebugTypes) ptEnv[n].vis(nAddMode[n]);	
			
			// on arc
				n = i-1;
				if (n<0)	n = nMax+n;
				nAddMode[n] = 3;
				if (bDebugTypes) ptEnv[n].vis(nAddMode[n]);	
			
			// end point
				n = i;
				if (nAddMode[n]==2)
					nAddMode[n] = 5;
				else if (i==nMax-1 && nAddMode[0]==3)
					nAddMode[n] = 3;				
				else
					nAddMode[n] = 4;
													
				if (bDebugTypes) ptEnv[n].vis(nAddMode[n]);	

			
			
			// flag arc mode
				if(!bPreviousIsArc)
					bPreviousIsArc= true;
	
			}
			else if (bPreviousIsArc)
			{				
				bPreviousIsArc=false;				
			}
		//straight
			else
			{
				n = i-3;
				if (n<0)	n = nMax+n;
				if (nAddMode[n]==0)
					nAddMode[n] = 1;
				if (bDebugTypes) ptEnv[n].vis(nAddMode[n]);
			}	
			
			//if (bPreviousIsArc)			
			//	plArcTest.vis(bArConcave[n]);	
		}
	
	// override if last and first mode are of type 4
		if (nAddMode[nMax-1]==4 && nAddMode[0]==4)
			nAddMode[nMax-1]=3;

	
	// declare a map which stores potential center points and chord
		Map mapArcs;
	
	// if it has an arc start converting
		if (bHasArc)
		{
			if(bReportDebug)
			{
				reportMessage("\arc detected...");
			}			
			
			
			Map mapArc;
		// the pline could have multiple arcs and straight segments. need to find a start point of conversion to
		// make sure that one arc is not converted to two arcs ... or it is an circle
			int nStartIndex; 		
			for (int i=0;i<nMax;i++)			
			{	
			// not a circle
				if (nAddMode[i]==1 || nAddMode[i]==2)
					bIsCircle=false;	
				if (nAddMode[i]==2)
					nStartIndex=i;	
				//ptEnv[i].vis(nAddMode[i]);
			
			}// next i
	
			
		// circle
			if (bIsCircle)
			{
				dp.color(1);
				Point3d ptCen;
				ptCen.setToAverage(ptEnv);
				double dRadius = Vector3d (ptEnv[0]-ptCen).length();
				plRecompose.createCircle(ptCen, vz, dRadius);

				mapArc.setPoint3d("ptChord", ptEnv[0]);
				mapArc.setPoint3d("ptCenter", ptCen);
				mapArc.setPLine("arc",plRecompose);
				mapArcs.appendMap("arc", mapArc);
			}
		// not a circle
			else
			{
				dp.color(3);
				plRecompose = PLine(vz);
				Point3d ptStartArc;
				for (int i=nStartIndex;i<(nMax+nStartIndex);i++)
				{
					n = i;
					if (n<0)	
						n = nMax+n;
					else if (n>nMax-1)
						n = n-nMax;

					int m = i-1;
					if (m<0)	
						m = nMax+m;
					else if (m>nMax-1)
						m = m-nMax;
					
				// add first
					if (n==nStartIndex)
					{
						ptStartArc=ptEnv[n];
						plRecompose.addVertex(ptStartArc);
					}
				// add end point
					else if(nAddMode[n]==4 || nAddMode[n]==5)
					{
						Point3d ptEndArc=ptEnv[n];
						plRecompose.addVertex(ptEndArc,ptEnv[m]);	
						
					// get center of arc				
						PLine plArc(vz);
						plArc.addVertex(ptStartArc);
						plArc.addVertex(ptEndArc,ptEnv[m]);		
						//plArc.vis(i);
						
						double dLArc = plArc.length();
						Point3d pt1 = plArc.getPointAtDist(dEps);
						Point3d pt2 = plArc.getPointAtDist(dLArc-dEps);
						Vector3d vxC = pt1-ptStartArc;	vxC.normalize();
						Line ln((pt1+ptStartArc)/2, vxC.crossProduct(vz));
						vxC = pt2-ptEndArc;					vxC.normalize();
						Plane pn((pt2+ptEndArc)/2, vxC);
						if (ln.hasIntersection(pn))
						{
							Point3d ptCen = ln.intersect(pn,0);
							vxC = plArc.ptMid()-ptCen;			vxC.normalize();
							Point3d pt[] = plArc.intersectPoints(Plane(ptCen,vxC.crossProduct(vz)));
							Point3d ptOnArc = plArc.closestPointTo(plArc.ptMid());
							if (pt.length()>0)
								ptOnArc = pt[0];
							ptCen.vis(i); 
							ptOnArc.vis(222);	
			
						// append chord and center points to global arrays
							mapArc.setPoint3d("ptChord", ptOnArc);
							mapArc.setPoint3d("ptCenter", ptCen);
							mapArc.setPLine("arc",plArc);
							mapArcs.appendMap("arc", mapArc);

						}						
						
						// if start and end fall in one
						if(nAddMode[n]==5)
							ptStartArc=ptEndArc;
						
					}			
				// add straight point
					else if((nAddMode[n]==2 ) || nAddMode[n]==1)//&& nAddMode[m]==4
					{
						if(nAddMode[n]==2)ptStartArc=ptEnv[n];
						plRecompose.addVertex(ptEnv[n]);	
					}
					
					
				//plRecompose.vis(i);	
				}
			}// not a circle but with arcs	
			_Map.setMap("Arc[]",mapArcs);
		}// end converting
		
	}// endif has min 4 vertices	
	plRecompose.close();
	dp.draw(plRecompose);
	_Map.setPLine("pline",plRecompose);	
	return;		



	




#End
#BeginThumbnail
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
M)#&^0$BRTCCW([>P_'-95\73HZ/5]CSIU(Q.LUSQ=8:2C1Q,MU=]!&C<*?\`
M:/3\.OTZUQ>W7?&=YG&8E.<G*PQ?Y_$UN:+X!10)M7?<V.+>-L`?[S#KWX'Y
MFNTA@BMH5A@C2.-1A408`KE5&MB=:SY8]C/DG4^+1&'HGA'3](\N9@;B\7GS
M7Z*?]D=OKR:Z"BBO0ITX4URP5C>,5%6044458PHHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"N-\1>-OL-S-8Z=&&FC)22:0<*W<*.Y![GN#
MP:[*LY-`TI-0:^%C%]H8EBS989]<'@'W`K#$0JSBE3=NY$U)JT6<'I7A74]?
MF-YJ$LL4+$9EER9)/H#V]SQZ9KO],T>QT>`Q6<(3/WG;EV^I_P`BKU%10PE.
MCJM7W%"G&/J%%%%=1H%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
3`4444`%%%%`!1110`4444`?_V110
`



#End
