#Version 8
#BeginDescription
#Versions
Version 1.0 18.11.2021 HSB-13847 initial version of dovetail tool , Author Thorsten Huck

This tsl creates a dovetailk connection between two parallel beams. When selected on a single beam it splits the beam at the given location
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords Beam;Dove;Dovetail;Length Connection
#BeginContents
//region <History>
// #Versions
// 1.0 18.11.2021 HSB-13847 initial version of dovetail tool , Author Thorsten Huck

/// <insert Lang=en>
/// Select one or two beams
/// </insert>

// <summary Lang=en>
// This tsl creates a dovetail connection between two parallel beams. When selected on a single beam it splits the beam at the given location
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "DoveTail")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Direction|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Rotate 90°|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Rotate 180°|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Rotate 270°|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Join + Erase|") (_TM "|Select Tool|"))) TSLCONTENT


//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
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
	
//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	
	
//end Constants//endregion

//region Jigs
if (_bOnJig)
{ 
	if (_kExecuteKey=="PickLocation") 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
	    
		Point3d ptCen = _Map.getPoint3d("ptCen");
		Vector3d vecX0 = _Map.getVector3d("vecX0");
		Vector3d vecY0 = _Map.getVector3d("vecY0");
		Vector3d vecZ0 = _Map.getVector3d("vecZ0");
		double dX =  _Map.getDouble("dX");
		double dY =  _Map.getDouble("dY");
		double dZ =  _Map.getDouble("dZ");	    
	    
	    Quader qdr (ptCen, vecX0, vecY0, vecZ0, dX, dY, dZ, 0, 0, 0);
	    
		Vector3d vecX = _Map.getVector3d("vecX");
		Vector3d vecY = _Map.getVector3d("vecY");
		Vector3d vecZ = _Map.getVector3d("vecZ");		
		double dXWidth =  _Map.getDouble("XWidth");
		double dYHeight =  _Map.getDouble("YHeight");
		double dZDepth =  _Map.getDouble("ZDepth");
		double dAlfa =  _Map.getDouble("Alfa");

	// Displays
		Display dpJ(2), dp(-1), dpSolid(-1);	
		dp.trueColor(darkyellow,80);
		dp.addViewDirection(vecZView);
		dpSolid.trueColor(darkyellow);

	// collect faces and check if jig point is on profile
		int nIsOn=-1;
		Map mapFaces = _Map.getMap("Face[]");
		PlaneProfile pps[0];
		for (int i=0;i<mapFaces.length();i++) 
		{
			PlaneProfile pp = mapFaces.getPlaneProfile(i);
			if (pp.pointInProfile(ptJig)== _kPointOnRing)
				nIsOn = i;
			pps.append(pp); 
		}
		
	// project jig point and limit location to valid length	
		PLine pl(ptCen - vecX0 * .5 * (dX - 2*dZDepth), ptCen + vecX0 * .5 * (dX - 2*dZDepth));
		if (nIsOn<0)
			Line(ptJig, vecZView).hasIntersection(Plane(ptCen+vecY * .5 * qdr.dD(vecY),vecZView), ptJig);//,
		pl.transformBy(vecY * .5 * qdr.dD(vecY));
		ptJig = pl.closestPointTo(ptJig);
		Point3d ptOrg = ptJig;// + vecY * .5 * qdr.dD(vecY);
	
	// Body
		Point3d ptBody = ptCen+vecZ * vecZ.dotProduct(ptOrg-ptCen); 
		Body bd(ptBody, vecZ, vecY0, vecZ.crossProduct(vecY0), dZDepth, dY, dZ,1, 0, 0);			
		PlaneProfile ppZ = bd.shadowProfile(Plane(ptOrg, vecZ));		
		Dove dv(ptOrg, vecX, vecY, vecZ, dXWidth, dYHeight, dZDepth, dAlfa, _kMaleEnd);
		bd.addTool(dv);

	// draw view shadow
		PlaneProfile ppView = bd.shadowProfile(Plane(ptOrg, vecZView));
		dp.draw(ppView, _kDrawFilled);

	// draw solid	
		dpSolid.draw(bd);
		dpSolid.draw(ppZ);
		
	// debug
		if (0)
		{ 
			PLine plCirc;
			dpJ.color(6);
			plCirc.createCircle(ptJig, qdr.vecD(vecZView), U(50));
			dpJ.draw(plCirc);
			dpJ.draw(PLine (ptJig, ptOrg, _PtW));
			dpJ.color(1);
			dpJ.draw(pl);	
		}
		
	    return;
	}
	
	if (_kExecuteKey=="SelectFace") 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
		int bFront = ! _Map.hasInt("showFront") ? true : _Map.getInt("showFront");
		
	
		Point3d ptCen = _Map.getPoint3d("ptCen");
		Vector3d vecX0 = _Map.getVector3d("vecX0");
		Vector3d vecY0 = _Map.getVector3d("vecY0");
		Vector3d vecZ0 = _Map.getVector3d("vecZ0");
		double dX =  _Map.getDouble("dX");
		double dY =  _Map.getDouble("dY");
		double dZ =  _Map.getDouble("dZ");			

		
		Point3d ptOrg = _Map.getPoint3d("ptOrg");
		Vector3d vecX = _Map.getVector3d("vecX");
		Vector3d vecY = _Map.getVector3d("vecY");
		Vector3d vecZ = _Map.getVector3d("vecZ");		
		double dXWidth =  _Map.getDouble("XWidth");
		double dYHeight =  _Map.getDouble("YHeight");
		double dZDepth =  _Map.getDouble("ZDepth");
		double dAlfa =  _Map.getDouble("Alfa");

		
		Quader qdr (ptCen, vecX0, vecY0, vecZ0, dX, dY, dZ, 0, 0, 0);
		int bIsSideView = qdr.vecD(vecZView).isParallelTo(vecZView) && vecZView.isPerpendicularTo(_ZW);
		
		double dL = dZDepth+dX;// show full solid of first beam
		Point3d ptBody = ptCen + vecZ * .5 * dZDepth;
		if (bIsSideView)
		{
			ptBody += vecZ * (vecZ.dotProduct(ptOrg - ptCen) );//+ .5 * dZDepth
			dL =dZDepth; 
		}
		Body bd(ptBody, vecX0, vecY0, vecZ0, dL, dY, dZ,0, 0, 0);

	// Displays
		Display dpJ(2), dp(-1), dpSolid(-1);	
		dp.trueColor(darkyellow,80);
		dp.addViewDirection(vecZView);
		dpSolid.trueColor(darkyellow);

	// collect faces
		Map mapFaces = _Map.getMap("Face[]");
		PlaneProfile pps[0];
		double dDist = U(10e5);
		int index = - 1;	
		for (int i=0;i<mapFaces.length();i++) 
		{ 
			PlaneProfile pp = mapFaces.getPlaneProfile(i);
			CoordSys csPP = pp.coordSys();
			Vector3d vecFace= csPP.vecZ();
			Point3d ptFace = csPP.ptOrg();
			
			double dFront = vecFace.dotProduct(vecZView);
			if ((dFront > 0 && bFront) || (dFront < 0 && !bFront))
			{
				Point3d pt = ptJig;
				Line(pt, vecZView).hasIntersection(Plane(ptFace, vecFace), pt);
				double d = Vector3d(pt - pp.closestPointTo(pt)).length();
				if (d < dDist)
				{
					dDist = d;
					index = pps.length();
				}
				pps.append(pp);
			}

		}//next i

	// draw beam end at dove base
		dp.draw(bd.getSlice(Plane(ptOrg, vecZ)), _kDrawFilled);
		
	// draw front/back side faces
		if (!bIsSideView)
		for (int i = 0; i < pps.length(); i++)
		{
			PlaneProfile pp = pps[i];
			if (i == index)
			{	
			// rotate to selected side
				
				{ 
					dp.trueColor(darkyellow, 80);
					dp.draw(pp, _kDrawFilled);
					dp.draw(pp);				
					
					
					CoordSys csPP = pp.coordSys();
					Vector3d vecFace= csPP.vecZ();
					Point3d ptFace = csPP.ptOrg();
					
					double angle = vecY.angleTo(vecFace, vecZ);
					CoordSys csRot;
					csRot.setToRotation(angle, vecZ, ptCen);
					
					Point3d ptOrg2 = Line(ptCen, vecZ).closestPointTo(ptOrg);			
					vecX.transformBy(csRot);
					vecY.transformBy(csRot);
					Line(ptOrg2, vecFace).hasIntersection(Plane(ptFace, vecFace), ptOrg);					
				}

				
			}
			else
			{ 
				dp.trueColor(lightblue, 80);
				dp.draw(pp, _kDrawFilled);				
			}
		}//next i	


		ptCen += vecZ * dZDepth;
		Dove dv(ptOrg, vecX, vecY, vecZ, dXWidth, dYHeight, dZDepth, dAlfa, _kMaleEnd);
		bd.addTool(dv);


	// draw beam end at dove head
		dp.trueColor(darkyellow, 80);
		PlaneProfile pp = bd.extractContactFaceInPlane(Plane(ptOrg + vecZ * dZDepth, vecZ), dEps);
		dp.draw(pp, _kDrawFilled);		
//		dpFace.draw(pp, _kDrawFilled);
		
		
	// draw top face of dove when in side view and parallel to view	
		if (bIsSideView && vecY.isParallelTo(vecZView))
		{ 
			PlaneProfile pp = bd.extractContactFaceInPlane(Plane(ptOrg, vecZView), dEps);
			dp.trueColor(vecY.isCodirectionalTo(vecZView)?darkyellow:lightblue, 80);
			dp.draw(pp, _kDrawFilled);
		}
		
		
	// draw solid	
		dpSolid.draw(bd);    
	}	
	return;
}

//endregion 

//region Properties
	String sOffsetName=T("|Offset|");	
	PropDouble dOffset(nDoubleIndex++, U(0), sOffsetName);	
	dOffset.setDescription(T("|Defines the Offset|"));
	dOffset.setCategory(category);
	
	String sXWidthName=T("|Width|");	
	PropDouble dXWidth(nDoubleIndex++, U(40), sXWidthName,_kLength);	
	dXWidth.setDescription(T("|Defines the Width|"));
	dXWidth.setCategory(category);

	String sZDepthName=T("|Depth|");	
	PropDouble dZDepth(nDoubleIndex++, U(20), sZDepthName,_kLength);	
	dZDepth.setDescription(T("|Defines the ZDepth|"));
	dZDepth.setCategory(category);
	
	String sAlfaName=T("|Alfa|");	
	PropDouble dAlfa(nDoubleIndex++, 6, sAlfaName,_kAngle);	
	dAlfa.setDescription(T("|Defines the Alfa|"));
	dAlfa.setCategory(category);
	
category = T("|Alignment|");
	String sOffsetXName=T("|Horizontal Axis-Offset|");	
	PropDouble dOffsetX(nDoubleIndex++, U(0), sOffsetXName);	
	dOffsetX.setDescription(T("|Defines the horizontal axis offset|"));
	dOffsetX.setCategory(category);
	
	
	
	
//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
	//region Dialog and Selection
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
	// standard dialog	
		else	
			showDialog();
		
		
	// prompt for beams
		Beam beams[0];
		PrEntity ssE(T("|Select beams|"), Beam());
		if (ssE.go())
			beams.append(ssE.beamSet());
		if (beams.length()<1)
		{ 
			eraseInstance();
			return;
		}
		
	// Prepare TSL Cloning
		TslInst tslNew;				Map mapTsl;
		int bForceModelSpace = true;	
		String sExecuteKey,sCatalogName = sLastInserted;
		String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
		GenBeam gbsTsl[2];		Entity entsTsl[0];			Point3d ptsTsl[1];
	//endregion 


		Map mapArgs;
		mapArgs.setDouble("XWidth", dXWidth);	    
		mapArgs.setDouble("ZDepth", dZDepth);
		mapArgs.setDouble("Alfa", dAlfa);

	// single beam selection prompt for location
		if (beams.length()==1)
		{ 
			Beam bm0 = beams[0];
			Point3d ptCen0 = bm0.ptCenSolid();
			double dX = bm0.solidLength();
			Body bd0 = bm0.envelopeBody(false, true);
			Vector3d vecX0 = bm0.vecX();
			Vector3d vecY0 = bm0.vecY();
			Vector3d vecZ0 = bm0.vecZ();
			
		// Set Faces and profiles
			Vector3d vecFaces[] ={vecY0, vecZ0, -vecY0, -vecZ0};
			PlaneProfile ppFace,pps[0];
			Map mapFaces;
			for (int i=0;i<vecFaces.length();i++) 
			{ 
				Vector3d vecFace = vecFaces[i];
				PlaneProfile pp = bd0.extractContactFaceInPlane(Plane(ptCen0+vecFace*.5*bm0.dD(vecFace), vecFace), U(1)); 
				pps.append(pp);
				mapFaces.appendPlaneProfile("pp", pp);
			}//next i
			mapArgs.setMap("Face[]", mapFaces);		
		
		//region Show Jig
			String prompt = T("|Select location [flipDirection/90/180/270]|");
			PrPoint ssP(prompt);
		    
		    
		    int bFront = true; // default to pick a face on viewing side			    
		    mapArgs.setInt("showFront", bFront);
		    mapArgs.setPoint3d("ptCen", ptCen0); 
		    mapArgs.setVector3d("vecX0", vecX0);
		    mapArgs.setVector3d("vecY0", vecY0);
		    mapArgs.setVector3d("vecZ0", vecZ0);
		    mapArgs.setDouble("dX", dX);
		    mapArgs.setDouble("dY", bm0.dD(vecY0));
		    mapArgs.setDouble("dZ", bm0.dD(vecZ0));

			Vector3d vecZ = vecX0;
			Vector3d vecY = bm0.vecD(_ZW);
			Vector3d vecX = vecY.crossProduct(vecZ);
			CoordSys cs(ptCen0, vecX, vecY, vecZ);
			
			double dYHeight = bm0.dD(vecY);
			if (dOffset<dYHeight)dYHeight-=dOffset;
		    mapArgs.setDouble("YHeight", dYHeight);
			
			mapArgs.setVector3d("vecX", vecX);
			mapArgs.setVector3d("vecY", vecY);
			mapArgs.setVector3d("vecZ", vecZ);	
	    
		    int nGoJig = -1;
			while (nGoJig != _kOk)
			{
				nGoJig = ssP.goJig("PickLocation", mapArgs);
				if (nGoJig == _kOk)
				{
					Point3d ptPick = ssP.value();
			
				// Check if pick point is on any profile
					int nIsOn=-1;
					for (int i=0;i<pps.length();i++) 
						if (pps[i].pointInProfile(ptPick)== _kPointOnRing)
							nIsOn = i;
				
				// project pick  point and limit location to valid length	
					PLine pl(ptCen0 - vecX0 * .5 * (dX - 2*dZDepth), ptCen0 + vecX0 * .5 * (dX - 2*dZDepth));
					pl.transformBy(vecY * .5 * bm0.dD(vecY));
					if (nIsOn<0)
						Line(ptPick, vecZView).hasIntersection(Plane(ptCen0+bm0.vecD(vecY) * .5 * bm0.dD(vecY),vecZView), ptPick);
					_Pt0 = pl.closestPointTo(ptPick); //retrieve the selected point					
					
				// Split beam and append to list	
					Beam bm1;
					bm1 = bm0.dbSplit(_Pt0, _Pt0);
					beams.append(bm1);
	
				}
				else if (nGoJig == _kKeyWord)
				{
					int keyIndex = ssP.keywordIndex();
				
				// flip direction
					if (keyIndex == 0)
					{
						vecX *= -1;
						vecZ *= -1;
						mapArgs.setVector3d("vecX", vecX);
						mapArgs.setVector3d("vecZ", vecZ);
					}
				// rotateBy	
					else if (keyIndex > 0 && keyIndex <4)
		            { 
		            	double dAngle = keyIndex == 1 ? 90 : (keyIndex == 2 ? 180 : -90);
		            	CoordSys csRot;
		            	csRot.setToRotation(dAngle, vecZ, ptCen0);
		            	cs.transformBy(csRot);
		            	vecX = cs.vecX();
		            	vecY = cs.vecY();
		            	vecZ = cs.vecZ();
					
						dYHeight = bm0.dD(vecY);
						if (dOffset<dYHeight)dYHeight-=dOffset;
					
					
						mapArgs.setVector3d("vecX", vecX);
						mapArgs.setVector3d("vecY", vecY);
						mapArgs.setVector3d("vecZ", vecZ);
						mapArgs.setDouble("YHeight", dYHeight);
					}
					
				}
		        else if (nGoJig == _kCancel)
		        { 
		            eraseInstance(); // do not insert this instance
		            return; 
		        }
		    }
			//End Show Jig//endregion 
//			 if (!vecZ.isCodirectionalTo(vecX0))
//		       		beams.swap(0, 1);
	       	ptsTsl[0] = _Pt0;
			gbsTsl[0] = beams[0]; 
			gbsTsl[1] = beams[1]; 
			tslNew.dbCreate(scriptName() , vecZ ,vecX,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent);  
	        	
		}
		
	// first couple found is taken as selection set	
		else if (beams.length()>1)
		{ 
		//region Get codirectional couple	
			Beam parBeams[0];
			double dMin = U(10e6);
			for (int i=0;i<beams.length()-1;i++) 
			{ 
				Beam bm0 = beams[i];
				Point3d ptCen0 = bm0.ptCenSolid();
				double dL0 = bm0.solidLength() * .5;
				Vector3d vecX0 = bm0.vecX();
				Vector3d vecY0 = bm0.vecY();
				Vector3d vecZ0 = bm0.vecZ();
				PlaneProfile pp1 = bm0.envelopeBody().shadowProfile(Plane(ptCen0, vecX0));
				for (int j=i+1;j<beams.length();j++)
				{ 
					Beam bm1 = beams[j];
					Point3d ptCen1 = bm1.ptCenSolid();
					double dL1 = bm1.solidLength() * .5;
					Vector3d vecX1 = bm1.vecX();
					Vector3d vecY1 = bm1.vecY();
					Vector3d vecZ1 = bm1.vecZ();
					PlaneProfile pp2 = bm1.envelopeBody().shadowProfile(Plane(ptCen1, vecX1));
					if(!vecX0.isParallelTo(vecX1)){ continue;} // not parallel
					if(!(vecY0.isParallelTo(vecY1) || vecY0.isPerpendicularTo(vecZ1))){ continue;} // twisted
					pp2.intersectWith(pp1);
					if (pp2.area()<pow(dXWidth,2)){ continue;} // connection must have at least a square width overlapping

					double d = abs(vecX0.dotProduct(ptCen0 - ptCen1)) - dL0 - dL1;
					if (d<dMin)
					{ 
						dMin = d;
						parBeams.setLength(2);
						parBeams[0] = bm0;
						parBeams[1] = bm1;
					}
				}
			}//next i
		
		// codirectional length connection found
			if (parBeams.length() == 2)
			{ 		
				Beam bm0 = parBeams[0];
				Point3d ptCen0 = bm0.ptCenSolid();
				double dL0 = bm0.solidLength() * .5;
				Body bd0 = bm0.envelopeBody(false, true);
				Vector3d vecX0 = bm0.vecX();
				Vector3d vecY0 = bm0.vecY();
				Vector3d vecZ0 = bm0.vecZ();
				
			// Set Faces and profiles
				Vector3d vecFaces[] ={vecY0, vecZ0, -vecY0, -vecZ0};
				PlaneProfile ppFace,pps[0];
				Map mapFaces;
				for (int i=0;i<vecFaces.length();i++) 
				{ 
					Vector3d vecFace = vecFaces[i];
					PlaneProfile pp = bd0.extractContactFaceInPlane(Plane(ptCen0+vecFace*.5*bm0.dD(vecFace), vecFace), U(1)); 
					pps.append(pp);
					mapFaces.appendPlaneProfile("pp", pp);
				}//next i
				mapArgs.setMap("Face[]", mapFaces);		

				Beam bm1 = parBeams[1];
				Point3d ptCen1 = bm1.ptCenSolid();
				double dL1 = bm1.solidLength() * .5;
				Vector3d vecX1 = bm1.vecX();
				
				Vector3d vecZ = vecX0;
				if (vecZ.dotProduct(ptCen1 - ptCen0) < 0)vecZ *= -1;
				Vector3d vecY = bm0.vecD(_ZW);
				Vector3d vecX = vecY.crossProduct(vecZ);
				
				Point3d pt = (ptCen0 + vecZ * dL0 + ptCen1 - vecZ * dL1) * .5;
				CoordSys cs(pt, vecX, vecY, vecZ);
				
			// get common range
				Plane pn(pt, vecZ);
				PlaneProfile pp0 = bm0.envelopeBody().shadowProfile(pn);
				PlaneProfile pp1 = bm1.envelopeBody().shadowProfile(pn);
				PlaneProfile pp(cs);
				pp.unionWith(pp0);
				pp.intersectWith(pp1);
				pp.vis(2);
		
				double dYHeight = pp.dY();
				if (dOffset<dYHeight)dYHeight-=dOffset;


			//region Show Jig
				int bIsSideView = bm0.vecD(vecZView).isParallelTo(vecZView) && vecZView.isPerpendicularTo(_ZW);
				String prompt = T("|Select rotate [flipDirection/flipSide/90/180/270]|");
				PrPoint ssP(prompt); // second argument will set _PtBase in map
			    			    
			    int bFront = true; // default to pick a face on viewing side			    
			    mapArgs.setInt("showFront", bFront);
			    mapArgs.setPoint3d("ptCen", ptCen0); 
			    mapArgs.setVector3d("vecX0", vecX0);
			    mapArgs.setVector3d("vecY0", vecY0);
			    mapArgs.setVector3d("vecZ0", vecZ0);
			    mapArgs.setDouble("dX", bm0.solidLength());
			    mapArgs.setDouble("dY", bm0.dD(vecY0));
			    mapArgs.setDouble("dZ", bm0.dD(vecZ0));
			    
			    mapArgs.setPoint3d("ptOrg", pp.ptMid()+vecY*.5*pp.dY()); 
			    mapArgs.setDouble("YHeight", dYHeight);
				mapArgs.setVector3d("vecX", vecX);
				mapArgs.setVector3d("vecY", vecY);
				mapArgs.setVector3d("vecZ", vecZ);

	
			    int nGoJig = -1;
			    ssP.setSnapMode(TRUE, 0); // turn off all snaps
			    while (nGoJig != _kOk && nGoJig != _kNone)
			    {
			        nGoJig = ssP.goJig("SelectFace", mapArgs);         
			        if (nGoJig == _kOk && !bIsSideView)
			        {
			            Point3d ptPick = ssP.value();
		            
			            
			       		PlaneProfile ppsX[0];
						double dDist = U(10e5);
						int index = - 1;	
						for (int i=0;i<pps.length();i++) 
						{ 
							PlaneProfile pp = pps[i];
							CoordSys csPP = pp.coordSys();
							Vector3d vecFace= csPP.vecZ();
							Point3d ptFace = csPP.ptOrg();
							
							double dFront = vecFace.dotProduct(vecZView);
							if ((dFront > 0 && bFront) || (dFront < 0 && !bFront))
							{
								Point3d pt = ptPick;
								Line(pt, vecZView).hasIntersection(Plane(ptFace, vecFace), pt);
								double d = Vector3d(pt - pp.closestPointTo(pt)).length();
								if (d < dDist)
								{
									dDist = d;
									index = ppsX.length();
								}
								ppsX.append(pp);
							}
				
						}//next i     
			            
			        	if (index>-1)
						{
							PlaneProfile pp = ppsX[index];
							CoordSys csPP = pp.coordSys();
							Vector3d vecFace= csPP.vecZ();
							Point3d ptFace = csPP.ptOrg();
							
							double angle = vecY.angleTo(vecFace, vecZ);
							CoordSys csRot;
							csRot.setToRotation(angle, vecZ, ptCen0);

							vecX.transformBy(csRot);
							vecY.transformBy(csRot);	
						}   

			        }
			        else if (nGoJig == _kKeyWord)
			        { 
			        	int keyIndex = ssP.keywordIndex();
			        // flip direction	
			            if (keyIndex == 0)
			            {
			            	parBeams.swap(0, 1);
			            	bm0 = parBeams[0];
			            	bm1 = parBeams[1];
							ptCen0 = bm0.ptCenSolid();
							dL0 = bm0.solidLength() * .5;
							vecX0 = bm0.vecX();
							vecY0 = bm0.vecY();
							vecZ0 = bm0.vecZ();
			            	mapArgs.setPoint3d("ptCen", ptCen0); 
						    mapArgs.setVector3d("vecX0", vecX0);
						    mapArgs.setVector3d("vecY0", vecY0);
						    mapArgs.setVector3d("vecZ0", vecZ0);
						    mapArgs.setDouble("dX", bm0.solidLength());
						    mapArgs.setDouble("dY", bm0.dD(vecY0));
						    mapArgs.setDouble("dZ", bm0.dD(vecZ0));		
						    
			            	vecZ *= -1;
			            	vecX *= -1;
			            	mapArgs.setVector3d("vecX", vecX);
							mapArgs.setVector3d("vecZ", vecZ);
			            }
			        // flip front/back 
			            else if (keyIndex == 1) 
			            {
			            	bFront =! bFront;
			            	mapArgs.setInt("showFront", bFront);
			            }
			            else if (keyIndex > 1 && keyIndex <5)
			            { 
			            	double dAngle = keyIndex == 2 ? 90 : (keyIndex == 3 ? 180 : 270);
			            	CoordSys csRot;
			            	csRot.setToRotation(dAngle, vecZ, pp.ptMid());
			            	cs.transformBy(csRot);
			            	vecX = cs.vecX();
			            	vecY = cs.vecY();
			            	vecZ = cs.vecZ();
			            	
			            	pp=PlaneProfile(cs);
							pp.unionWith(pp0);
							pp.intersectWith(pp1);
			            	
			            	dYHeight = pp.dY();
							if (dOffset<dYHeight)dYHeight-=dOffset;
			            	
			            	mapArgs.setPoint3d("ptOrg", pp.ptMid()+vecY*.5*pp.dY());
			            	mapArgs.setDouble("YHeight", dYHeight);
							mapArgs.setVector3d("vecX", vecX);
							mapArgs.setVector3d("vecY", vecY);
							mapArgs.setVector3d("vecZ", vecZ);
			            }
			        }
			        else if (nGoJig == _kCancel)
			        { 
			            eraseInstance(); // do not insert this instance
			            return; 
			        }
			    }
			    ssP.setSnapMode(false, 0);
			//End Show Jig//endregion 

				ptsTsl[0] = pt;
				gbsTsl[0] = parBeams[0]; 
				gbsTsl[1] = parBeams[1]; 
				tslNew.dbCreate(scriptName() , vecZ ,vecX,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
			}
						
		//endregion 

		//region Get potential T-Connections
			else
			{ 
				Beam bm0 = beams.first();
				Beam _beams[0];_beams = beams;
				_beams.removeAt(0);
				
				Beam beamsT[] = bm0.filterBeamsTConnection(_beams, U(200), true);
				

			
				 
				gbsTsl[0] = bm0;
				Point3d ptCen = bm0.ptCen();
				Vector3d vecX = bm0.vecX();
				Vector3d vecY = bm0.vecY();
				
				for (int i=0;i<beamsT.length();i++) 
				{ 
					Line(ptCen, vecX).hasIntersection(Plane(beamsT[i].ptCen(), beamsT[i].vecD(vecX)),ptsTsl[0]);
					gbsTsl[1] = beamsT[i]; 
					tslNew.dbCreate(scriptName() , vecX ,vecY,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
				}//next i
			}				
		//endregion
			
		}
		

		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion

//region Validate and get Alignment
	if (_Beam.length()<2)
	{ 
		reportMessage("\n"+ scriptName() + T("|Requires two beams| ")+T("|Tool will be deleted.|"));
		eraseInstance();
		return;
	}
	
	Beam& bm0 = _Beam[0];
	Vector3d vecX0 = bm0.vecX();
	Vector3d vecY0 = bm0.vecY();
	Vector3d vecZ0 = bm0.vecZ();
	Point3d ptCen0 = bm0.ptCenSolid(); ptCen0.vis(1);

	Beam& bm1 = _Beam[1];
	Vector3d vecX1 = bm1.vecX();
	Vector3d vecY1 = bm1.vecY();
	Vector3d vecZ1 = bm1.vecZ();	
	Point3d ptCen1 = bm1.ptCenSolid();ptCen1.vis(2);

// assigning
	Element el0 = bm0.element(), el1 =bm1.element();
	if (el0.bIsValid() && el1.bIsValid())
	{ 
		assignToElementGroup(el0, false, 0, 'T');
		assignToElementGroup(el1, false, 0, 'T');
	}
	else	
		assignToGroups(bm0, 'T');

	int bIsParallel = vecX0.isParallelTo(vecX1);	
	if (!bIsParallel)
	{ 
		reportMessage("\n"+ scriptName() + T("|Only parallel connection supported| ")+T("|Tool will be deleted.|"));
		eraseInstance();
		return;		
	}
	
//endregion 

//region Display
	Display dp(255);
	
//endregion 

//region Parallel Connection
	if (bIsParallel)
	{ 
	// dragging
		addRecalcTrigger(_kGripPointDrag, "_Pt0");
		int bDrag = _bOnGripPointDrag && _kExecuteKey == "_Pt0";
		
	// get coordsys	
		Vector3d vecZ = bm0.vecX();
		if (vecZ.dotProduct(ptCen1 - ptCen0) < 0)
			vecZ *= -1;
		Vector3d vecY = bm0.vecD(_ZU);
		Vector3d vecX = vecY.crossProduct(vecZ);		
		vecX.vis(_Pt0, 1);
		vecY.vis(_Pt0, 3);
		vecZ.vis(_Pt0, 150);
		
		Point3d ptRef = _Pt0;
		
	// make sure location is within range	
		if ((bDrag || _kNameLastChangedProp == "_Pt0") && _Map.hasVector3d("vecPt0"))
		{ 
			Point3d ptMax0 = ptCen0 - vecZ * .5 * bm0.dL();
			double d0 = vecZ.dotProduct(_Pt0 - ptMax0);
			Point3d ptMax1 = ptCen1 + vecZ * .5 * bm1.dL();
			double d1 = vecZ.dotProduct(ptMax1 - _Pt0);
		
			if (d0 < 2*dZDepth || d1 < 2*dZDepth)
			{ 
				ptRef = _PtW + _Map.getVector3d("vecPt0");
			}
		}
		CoordSys cs (ptRef, vecX, vecY, vecZ);
		
	
	// get common range
		Plane pn(ptRef, vecZ);
		PlaneProfile pp0 = bm0.envelopeBody().shadowProfile(pn);
		PlaneProfile pp1 = bm1.envelopeBody().shadowProfile(pn);
		PlaneProfile pp(cs);
		pp.unionWith(pp0);
		pp.intersectWith(pp1);
		pp.vis(2);

		double dYHeight = pp.dY();
		if (dOffset<dYHeight)dYHeight-=dOffset;
		int bDove = dXWidth > dEps && dYHeight > dEps && dZDepth > dEps;

	// get reference point				
		ptRef = pp.ptMid() + vecY*.5*pp.dY()+vecX*dOffsetX;
		if (!bDrag)_Pt0 = ptRef;


	// Trigger FlipDirection//region
		String sTriggerFlipDirection = T("|Flip Direction|");
		addRecalcTrigger(_kContextRoot, sTriggerFlipDirection );
		if (_bOnRecalc && (_kExecuteKey==sTriggerFlipDirection || _kExecuteKey==sDoubleClick))
		{
			
			bm0.addToolStatic(Cut(ptRef, vecZ), _kStretchOnToolChange);
			bm1.addToolStatic(Cut(ptRef, -vecZ),_kStretchOnToolChange);	
			
			_Beam.swap(0, 1);
			setExecutionLoops(2);
			return;
		}//endregion



	//region Tools
		if (bDrag && bDove)
		{ 
			Dove dv(ptRef, vecX, vecY, vecZ, dXWidth, dYHeight, dZDepth, dAlfa, _kMaleEnd);
		
			Point3d pt = ptCen0;
			pt += vecZ * (vecZ.dotProduct(ptRef - pt)+dZDepth);
			Body bd(pt, vecX, vecY, vecZ, bm0.dD(vecX), bm0.dD(vecY), abs(vecZ.dotProduct(pt-(ptCen0-vecZ*.5*bm0.solidLength()))),0, 0, -1);			
			bd.addTool(dv);

			PlaneProfile ppZ = bd.shadowProfile(Plane(pt, vecZView));
			dp.trueColor(darkyellow,80);
			dp.addViewDirection(vecZView);
			dp.draw(ppZ, _kDrawFilled);

			Display dpSolid(-1);
			dpSolid.trueColor(darkyellow);
			dpSolid.draw(bd);			
		}
		// Dove
		else if (bDove)
		{ 
			Dove dv(ptRef, vecX, vecY, vecZ, dXWidth, dYHeight, dZDepth, dAlfa, _kFemaleEnd);
			
			if (vecY.dotProduct(ptCen1-ptCen0)>dEps)
				dv.setAddKeyhole(true);			
			bm1.addTool(dv,_kStretchOnToolChange);
			dv.setEndType(_kMaleEnd);
			dv.setAddKeyhole(false);	
			bm0.addTool(dv,_kStretchOnToolChange);
			
			Point3d pt = ptCen0;
			pt += vecZ * (vecZ.dotProduct(ptRef - pt)+dZDepth);
			Body bd(pt, vecX, vecY, vecZ, bm0.dD(vecX), bm0.dD(vecY), dZDepth,0, 0, -1);			
			bd.addTool(dv);
			dp.draw(bd);
		}
		// Stretch
		else
		{ 
			dp.draw(pp, _kDrawFilled, 90);
			if (!bDrag)
			{ 
				bm0.addTool(Cut(ptRef, vecZ), _kStretchOnToolChange);
				bm1.addTool(Cut(ptRef, -vecZ), _kStretchOnToolChange);				
			}

			
		}
	//endregion 

	// Trigger Join
		String sTriggerJoin = T("|Join + Erase|");
		addRecalcTrigger(_kContextRoot, sTriggerJoin );
		if (_bOnRecalc && (_kExecuteKey==sTriggerJoin || _kExecuteKey==sDoubleClick))
		{
			bm0.dbJoin(bm1);
			eraseInstance();
			return;
		}	
	
	//region Trigger Rotate90
		double dRotations[] = { 90, 180, 270};
		for (int i=0;i<dRotations.length();i++) 
		{ 
			double dRotation = dRotations[i];			
			String sTriggerRotate = T("|Rotate| ")+ String().formatUnit(dRotation,2,0) + "°";
			addRecalcTrigger(_kContextRoot, sTriggerRotate);
			if (_bOnRecalc && _kExecuteKey==sTriggerRotate)
			{
				CoordSys csRot;
				csRot.setToRotation(dRotation, vecZ, _Pt0);
				_ThisInst.transformBy(csRot);
				setExecutionLoops(2);
				return;
			}	
		}//next i
		
		//endregion
			_Map.setVector3d("vecPt0", _Pt0 - _PtW);	
		}
	//endregion 

	








#End
#BeginThumbnail
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
>"1N'V<HPJN3_`R^`^)5YV32G`````$E%3D2N0F""

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="956" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13847 initial version of dovetail tool" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="11/18/2021 2:06:58 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End