#Version 8
#BeginDescription
This tsl replaces an opening by surrounding tools

#Versions
Version 2.9 30/04/2025 HSB-23562: Fix when radius is applied , Author Marsel Nakuci
Version 2.8 11/04/2025 HSB-23562: Fix when closing door openings (make sure they get closed); Fix when freeprofiling the door openings (make sure nothing remains at the outter edge; Use the envelopBody with cuts when investigating outter contour for openings , Author Marsel Nakuci
Version 2.7 01/04/2025 HSB-23562: Fix when getting rings of openings , Author Marsel Nakuci
Version 2.6 27.02.2024 HSB-20579 new strategies 'House Tool' and 'Mortise Tool' have been added for rectangular opening shapes

Version 2.5 01.08.2023 HSB-19654 bugfix strategy 1 on doors
Version 2.4 09.09.2022 HSB-16458 batch insert support added
Version 2.3 08.09.2022 HSB-15403 new commands to show UI commands and to clone tool, new corner tool behaviour and options
Version 2.2 30.06.2022 HSB-15876 new command flip side toggles reference and opposite side, doubleclick action changed to 'Flip Side'
Version 2.1 28.06.2022 HSB-15876 corner tool fixed when support used for door alike openings
Version 2.0 16.11.2021 HSB-13263 Tool image updated
Version 1.10 06.10.2021 HSB-13386: recalcNow the tsl
Version 1.9 09.09.2021 HSB-13112 new custom command to add tool dimensions to shopdrawing (requires sd_Opening to be part of ruleset definition) 
Version 1.8 28.07.2021 HSB-12511 rafter cutouts also detected on gable alike shapes
Version 1.7 27.07.2021 HSB-12511 new strategy to convert openings into extrusion tools (pockets)
Version 1.6 02.02.2021 HSB-10539 new strategy to control openings
HSB-10531 negative radius supports cleanup shape
HSB-10531 new property radius
HSB-10527 bugfix when adding single openings
HSB-10391 renamed to hsbCLT-Opening, new detection of edge openings and doors, settings support, individual annotation and dimensioning supported 
HSB-10384 hsbCLT-OpeningPrecut supports its shape to be drawn in shopdrawings. The option to select polylines during insert has been improved.






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 9
#KeyWords 
#BeginContents
//region Part #1
//region History
/// <History>
// #Versions
// 2.9 30/04/2025 HSB-23562: Fix when radius is applied , Author Marsel Nakuci
// 2.8 11/04/2025 HSB-23562: Fix when closing door openings (make sure they get closed); Fix when freeprofiling the door openings (make sure nothing remains at the outter edge; Use the envelopBody with cuts when investigating outter contour for openings , Author Marsel Nakuci
// 2.7 01/04/2025 HSB-23562: Fix when getting rings of openings , Author Marsel Nakuci
// 2.6 27.02.2024 HSB-20579 new strategies 'House Tool' and 'Mortise Tool' have been added for rectangular opening shapes. , Author Thorsten Huck
// 2.5 01.08.2023 HSB-19654 bugfix strategy 1 on doors  , Author Thorsten Huck
// 2.4 09.09.2022 HSB-16458 batch insert support added , Author Thorsten Huck
// 2.3 08.09.2022 HSB-15403 new commands to show UI commands and to clone tool, new corner tool behaviour and options , Author Thorsten Huck
// 2.2 30.06.2022 HSB-15876 new command flip side toggles reference and opposite side, doubleclick action changed to 'Flip Side' , Author Thorsten Huck
// 2.1 28.06.2022 HSB-15876 corner tool fixed when support used for door alike openings , Author Thorsten Huck
// 2.0 16.11.2021 HSB-13263 Tool image updated , Author Thorsten Huck
// 1.10 06.10.2021 HSB-13386 recalcNow the tsl Author: Marsel Nakuci
// 1.9 09.09.2021 HSB-13112 new custom command to add tool dimensions to shopdrawing (requires sd_Opening to be part of ruleset definition) , Author Thorsten Huck
// 1.8 28.07.2021 HSB-12511 rafter cutouts also detected on gable alike shapes , Author Thorsten Huck
// 1.7 27.07.2021 HSB-12511 new strategy to convert openings into extrusion tools (pockets) , Author Thorsten Huck
// 1.6 02.02.2021 HSB-10539 new strategy to control openings , Author Thorsten Huck
// 1.5 01.02.2021 HSB-10531 negative radius supports cleanup shape , Author Thorsten Huck
// 1.4 01.02.2021 HSB-10531 new property radius , Author Thorsten Huck
// 1.3 01.02.2021 HSB-10527 bugfix when adding single openings , Author Thorsten Huck
// 1.2 20.01.2021 HSB-10391 renamed to hsbCLT-Opening, new detection of edge openings and doors, settings support, individual annotation and dimensioning supported 
// 1.1 18.01.2021 HSB-10384 hsbCLT-OpeningPrecut supports its shape to be drawn in shopdrawings. The option to select polylines during insert has been improved.
/// <version value="1.0" date="02dec2020" author="thorsten.huck@hsbcad.com"> HSB-9972 initial </version>
/// </History>

/// <insert Lang=en>
/// Select panels and pick points in openings or enter to select all
/// </insert>

/// <summary Lang=en>
/// This tsl replaces an opening by surrounding tools 
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-Opening")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Clone Tool|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Reset + Erase|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Edit Shape|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Configure Display|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Tool Dimpoints to Shopdrawing|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Tool Dimpoints from Shopdrawing|") (_TM "|Select tool|"))) TSLCONTENT

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
	
	String sStrategies[] ={ T("|Midpoint Tool|"), T("|Corner Tool|"), T("|Opening|"), T("|Extrusion|"), T("|Housing Tool|"), T("|Mortise Tool|")};
	String sStrategyKeys[] = { "Midpoint Tool","Corner Tool", "Opening", "Extrusion", "House", "Mortise"};

	int nc = 150, ncText=nc;
	int nt ;
	String sLineType = "DASHED";
	double dLineTypeScale = U(10);
	String sText;
	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	
	int yellow = rgb(255,255,0);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(255,63,0);//205,105,40 // rgb(242,103,34);
	int red = rgb(205,32,39);
	int magenta = rgb(255, 0, 255);
	int purple = rgb(147,39,143);
	int lightblue = rgb(204,204,255);
	int blue = rgb(39,118,187);
	int darkblue = rgb(26,50,137);	
	
	int lightgreen = rgb(127,255,0);
	int green = rgb(88,186,72);//19, 155, 72  
	int darkgreen = rgb(64,146,2);
	
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);

	double dViewHeight = getViewHeight();	
	
	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	
	String kFaceRef = T("|Reference Side|"), kFaceOpp = T("|Opposite Side|"),kCloning = "isCloning", kBatchIndex = "batchIndex";
	
	double dBlowUpShrink = U(250);
//end Constants//endregion

//region Functions #FU

//region extendPlOutsidePp
// HSB-23562: This stretches an existing pline
// at the edge that falls in the edge of the outter contour _pp
// _pl represents a door opening
	PLine extendPlOutsidePp(PLine _pl,PlaneProfile _pp)
	{ 
		// the pline
		// must have one edge at the edge of the planeprofile
		// this edge will be extended toward the outside of the pp
		
		PLine _plOut;
		// envelope
		_pp.joinRing(_pl,_kAdd);
		_pp.shrink(-U(5));
		_pp.shrink(U(5));
		_pp.shrink(U(5));
		_pp.shrink(-U(5));
		
		//
		PlaneProfile _ppPl(_pl);
		PlaneProfile _ppNew=_ppPl;
		_ppPl.shrink(-U(10));
		// to be added part
		PlaneProfile _ppAdd=_ppPl;
		_ppPl.intersectWith(_pp);
		_ppAdd.subtractProfile(_ppPl);
		_ppAdd.shrink(U(5));
		_ppAdd.shrink(-U(5));
		_ppAdd.shrink(-U(5));
		_ppAdd.shrink(U(5));
		
		// the new pline result
		_ppNew.unionWith(_ppAdd);
		_ppNew.shrink(-U(5));
		_ppNew.shrink(U(5));
//		_ppNew.shrink(-U(5));
//		_ppNew.shrink(U(5));
		
		PLine _plsNew[]=_ppNew.allRings(true,false);
		if(_plsNew.length()==1)
		{ 
			_plOut=_plsNew.first();
		}
		
//		_pp.vis(1);
//		Point3d _pts[]=_pl.vertexPoints(true);
//		
//		// get points that are at edge of _pp
//		Point3d _ptsEdge[0];
//		int nIndicesEdge[0];
//		for (int i=0;i<_pts.length();i++) 
//		{ 
//			Point3d _ptiEdge=_pp.closestPointTo(_pts[i]); 
////			_ptiEdge.vis(3);
//			if((_ptiEdge-_pts[i]).length()<dEps)
//			{ 
//				_pts[i].vis(2);
//				_ptsEdge.append(_pts[i]);
//				nIndicesEdge.append(i);
//			}
//		}//next i
//		//
////		if(_ptsEdge.length()!=2)
////		{ 
////			return _plOut;
////		}
//		//
//		// add 2 points 
//		Point3d _ptsNew[]=_pts;
////		_pts.append(_pts.first());
//		double dExtend=U(200);
//		for (int i=0;i<nIndicesEdge.length();i++) 
//		{ 
//			Point3d pti=_pts[nIndicesEdge[i]];
//			if(nIndicesEdge.find(nIndicesEdge[i]+1)<0 && _pts.length()>(nIndicesEdge[i]+1))
//			{ 
//				// next point is valid point
//				Vector3d _vDiri=pti-_pts[nIndicesEdge[i]+1];_vDiri.normalize();
//				Point3d _ptNew=pti+_vDiri*dExtend;
////				_vDiri.vis(pti);
//				_ptsNew.append(_ptNew);
//			}
//			else if(nIndicesEdge[i]-1>-1 && nIndicesEdge.find(nIndicesEdge[i]-1)<0)
//			{ 
//				// take the previous point, it is valid point
//				Vector3d _vDiri=pti-_pts[nIndicesEdge[i]-1];_vDiri.normalize();
//				Point3d _ptNew=pti+_vDiri*dExtend;
////				_vDiri.vis(pti);
//				_ptsNew.append(_ptNew);
//			}
//			else
//			{ 
//				// take the first point or the last one
//				Point3d ptNext=_pts.first();
//				if(nIndicesEdge[i]==0)ptNext=_pts.last();
//				Vector3d _vDiri=pti-ptNext;_vDiri.normalize();
//				Point3d _ptNew=pti+_vDiri*dExtend;
////				_vDiri.vis(pti);
//				_ptsNew.append(_ptNew);
//			}
//		}//next i
//		//
//		_plOut.createConvexHull(Plane(_pl.coordSys().ptOrg(),_pl.coordSys().vecZ()),
//			_ptsNew);
//		_plOut.vis(4);
		return _plOut;
	}
//end extendPlOutsidePp//endregion

//end Functions #FU //endregion


//region bOnJig
	String sJigAction = "JigAction";
	if (_bOnJig && _kExecuteKey==sJigAction) 
	{
	//_ThisInst.setDebug(TRUE);
	    Point3d ptBase = _Map.getPoint3d("_PtBase"); // set by second argument in PrPoint
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
		String sAreaFilter = _Map.getString("AreaFilter");
		
		Display dp(-1), dp2(-1);
		
	// draw area filter setting at cursor	
		dp.trueColor(red,0);
		dp.textHeight(dViewHeight/40);
		if (sAreaFilter!="0")
			dp.draw(sAreaFilter, ptJig, vecXView, vecYView, 1.2, 1.2 );
		
	// find shape at jig location
		for (int i=0;i<_Map.length();i++) 
		{ 
			Map m= _Map.getMap(i);
	
			PlaneProfile ppShape = m.getPlaneProfile("shape");
			PLine plContour= m.getPLine("contour");
			PlaneProfile ppContour(plContour);
			
			PLine plShape;
			PLine rings[] = ppShape.allRings(true, false);
			if (rings.length() > 0)plShape = rings.first();
			double dZ = m.getDouble("dZ");
			
			int strategy = m.getInt("Strategy");
			int bIsDoor = m.getInt("isDoor");
			
			if (strategy==0) //Midpoint Tool
				dp.trueColor(darkgreen,50);
			else if (strategy==1) // Corner Tool
				dp.trueColor(orange,50);	
			else if (strategy==2) // opening
				dp.trueColor(darkyellow,50);		
			else if (strategy==3) // extrusion
				dp.trueColor(purple,50);
			else if (strategy==4) // house
				dp.trueColor(green,50);	
			else if (strategy==5) // mortise
				dp.trueColor(yellow,50);	
			
			CoordSys cs = ppContour.coordSys();
			Vector3d vecZ = cs.vecZ();//m.getVector3d("vecZ");
			Point3d pt=ptJig;
			Line(ptJig,vecZView).hasIntersection(Plane(cs.ptOrg(), vecZ),pt);
			
			if (ppContour.pointInProfile(pt)!=_kPointOutsideProfile)
			{	
				dp.draw(ppShape, _kDrawFilled);
				dp.trueColor(darkyellow,0);
				dp.draw(ppShape);
			}
			else
			{ 
				dp.trueColor(lightgreen,50);
				dp.draw(ppShape, _kDrawFilled);
			}
			
			if (plShape.area()>pow(dEps,2) && dZ > 0)
			{ 
				Body bd(plShape, ppShape.coordSys().vecZ() * dZ, 1);
				dp.draw(bd);
			}
		}//next i
	    return;
	}
//End bOnJig//endregion 
	
//region bOnMapIO
	if (_bOnMapIO)
	{ 
		String k = "plContour";
		Map mapIn = _Map;
		String err;
		PLine plContour = mapIn.getPLine("plContour");
		double dRadius = mapIn.getDouble("radius");
		if (!mapIn.hasPLine("plContour"))
		{ 
			err = T("|No valid input to calculate the offseted contour.|");
			reportMessage("\n"+err);
			_Map.setString("err", err);
			return;
		}
		else if (abs(dRadius)<dEps)
		{ 
			return;
		}
		
		CoordSys cs = plContour.coordSys();
		Vector3d vecX = mapIn.hasVector3d("vecX") ? mapIn.getVector3d("vecX") : cs.vecX();
		Vector3d vecY = mapIn.hasVector3d("vecY") ? mapIn.getVector3d("vecY") : cs.vecY();
		Vector3d vecZ = mapIn.hasVector3d("vecZ") ? mapIn.getVector3d("vecZ") : cs.vecZ();

		PLine plContourOut(vecZ);
		PlaneProfile ppContour(CoordSys(plContour.ptStart(), vecX, vecY, vecZ));
		ppContour.joinRing(plContour, _kAdd);
		
		Point3d pts[] = plContour.vertexPoints(true);
		
	// overshoot if radius < 0
		if (dRadius<0)
		{ 
			// loop vertices
			for (int i=0;i<pts.length();i++) 
			{ 
			//region Look at previous and next segment
				int n = i == 0 ? pts.length() - 1 : i - 1;
				int m = i == pts.length() - 1 ? 0: i + 1;
				
			// test if one of the segments is an arc and if the arc is concave or convex
				Point3d ptN = (pts[i] + pts[n]) * .5;	//ptN.vis(i);
				int bIsArcN = ! plContour.isOn(ptN);
				int bIsConcaveN = ppContour.pointInProfile(ptN)==_kPointOutsideProfile;
				Point3d ptM = (pts[i] + pts[m]) * .5;	//ptM.vis(i);
				int bIsArcM = ! plContour.isOn(ptM);
				int bIsConcaveM = ppContour.pointInProfile(ptM)==_kPointOutsideProfile;				
			//End Look at previous and next segment//endregion 	
	
				
			// arc and first vertex	
				if ((bIsArcN || bIsArcM) && plContourOut.vertexPoints(true).length()==0)
					plContourOut.addVertex(pts[i]);
			// previous is a convex arc		
				else if (bIsArcN && !bIsConcaveN)
				{
					double d = plContour.getDistAtPoint(pts[i])-dEps;
					if (d <= dEps)d = plContour.length() - dEps;
					plContourOut.addVertex(pts[i],plContour.getPointAtDist(d));
					//plContourOut.vis(6);
				}
			// next segment is convex arc	
				else if (bIsArcM && !bIsConcaveM)
				{
					//pts[i].vis(6);
					plContourOut.addVertex(pts[i]);
				}
			// two straight segments or connecting to a concave arc	
				else if ((!bIsArcN && !bIsArcM) || (bIsConcaveN ||bIsConcaveM))
				{ 
				// 'a' is the segemnt before, 'b' is the segment after the vertex	
					double d = plContour.getDistAtPoint(pts[i])-dEps;
					if (d <= dEps)d = plContour.length() - dEps;
					Point3d ptA = plContour.getPointAtDist(d);
					Vector3d vecA = pts[i] - ptA;	vecA.normalize();
					d = plContour.getDistAtPoint(pts[i])+dEps;
					if (d >plContour.length())d = dEps;
					Point3d ptB = plContour.getPointAtDist(d);
					Vector3d vecB = pts[i] - ptB;	vecB.normalize();
					Vector3d vecM = vecA + vecB; 	vecM.normalize();	vecM.vis(pts[i], 4);
					
					Vector3d vecAY = vecM.crossProduct(vecA).crossProduct(-vecA);	vecAY.normalize();	//vecA.vis(pts[i], 1); vecAY.vis(pts[i], 3);			
					Vector3d vecBY = vecM.crossProduct(vecB).crossProduct(-vecB);	vecBY.normalize();	//vecBY.vis(pts[i], 3);
									
				//region find center of cleanup circle
					Point3d ptX;
					int bOk=Line(pts[i] + vecAY * dRadius, vecA).hasIntersection(Plane(pts[i] + vecBY * dRadius, vecBY), ptX);
					double delta = vecM.dotProduct(pts[i] - ptX);
					//ptX.vis(2);
					ptX += vecM * (delta+dRadius);	ptX.vis(20);
					PLine plCirc;
					plCirc.createCircle(ptX, vecZ, dRadius);
					if (bDebug)plCirc.vis(252);					
				//End find center of cleanup circle//endregion 					
	
	
					Vector3d vecMY = vecM.crossProduct(-vecZ);
					Point3d ptsA[] = Line(pts[i], vecA).orderPoints(plCirc.intersectPoints(Plane(pts[i], vecAY)));
					Point3d ptsB[] = Line(pts[i], vecB).orderPoints(plCirc.intersectPoints(Plane(pts[i], vecBY)));
					if (ptsA.length()>0 && ptsB.length()>0)
					{ 
					// test for sharp angles
						int bIsSharp = vecM.dotProduct(ptX-((ptsA.first() + ptsB.first()) * .5))>dEps;
					//region corners < 90°
						if (bIsSharp)
						{ 
							
							if (bDebug)vecMY.vis(ptsA.first(), 4);
							Point3d ptsM[] = Line(ptX, -vecMY).orderPoints(plCirc.intersectPoints(Plane(ptX, vecM)));
							if (ptsM.length()>0)
							{ 
								Point3d pt = ptsM.first();							//pt.vis(0);
								Line(pt, vecM).hasIntersection(Plane(pts[i], vecAY), pt);
								pt -= vecA * dEps;
								pt = plContour.closestPointTo(pt);						//pt.vis(4);
								
								if (bIsConcaveN)
								{	
									double d = plContour.getDistAtPoint(pt)-dEps;
									if (d <= dEps)d = plContour.length() - dEps;
									plContourOut.addVertex(pt, plContour.getPointAtDist(d));	
								}
								else												//pt.vis(40);
	
								plContourOut.addVertex(pt);
								pt = ptsM.first();									//pt.vis(3);
								plContourOut.addVertex(pt);
								pt = ptsM.last();									//pt.vis(2);
								plContourOut.addVertex(pt, pts[i]);
								Line(pt, vecM).hasIntersection(Plane(pts[i], vecBY), pt);
								pt -= vecB * dEps;
								pt = plContour.closestPointTo(pt);
								plContourOut.addVertex(pt);
							}							
						}		
					//End corners < 90°//endregion 	
					// corners >=90°	
						else
						{ 
							if (bDebug)ptsA.first().vis(1);									//ptsB.first().vis(1);
							plContourOut.addVertex(ptsA.first());
							plContourOut.addVertex(ptsB.first(), pts[i]);						
						}
	
					}
					else
						plContourOut.addVertex(pts[i]);	
				}
			}//next i
			plContourOut.close();			
		}
		
	// round fillet corners	
		else if (dRadius >dEps)
		{ 
			ppContour.shrink(abs(dRadius));
			PLine rings[] = ppContour.allRings(true, false);
			if (rings.length()>0)
			{ 
				plContourOut = rings[0];
				plContourOut.offset(-dRadius);
			}			
		}
		if (plContourOut.area()>pow(dEps,2))
			_Map.setPLine("plContour", plContourOut);	

		return;
	}
//End bOnMapIO//endregion 

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		setOPMKey("Configuration");
	// Add Configuration	
		if (nDialogMode==1)
		{ 
			String rules[0];
			for (int i=0;i<sStrategyKeys.length();i++) 
			{ 
				if (i<2)
				{ 
					rules.append(sStrategies[i]+"_"+T("|Opening|"));
					rules.append(sStrategies[i]+"_"+T("|Door|")); 
				}
				else if (i==2)
				{ 
					rules.append(T("|Opening|"));
					rules.append(T("|Door|"));
					rules.append(T("|Extrusion|"));
					rules.append(T("|Housing Tool|"));
					rules.append(T("|Mortise Tool|"));
				}
			}//next i
			rules = rules.sorted();
			rules.insertAt(0, T("|Default|"));
			String sRuleName=T("|Rule|");	
			PropString sRule(nStringIndex++, rules, sRuleName);	
			sRule.setDescription(T("|Defines to which strategy these settings apply to|"));
			sRule.setCategory(category);
			
		category = T("|Annotation|");
			String sDimStyleName=T("|DimStyle|");	
			PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
			sDimStyle.setDescription(T("|Defines the DimStyle|"));
			sDimStyle.setCategory(category);
			
			String sTextHeightName=T("|Text Height|");	
			PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
			dTextHeight.setDescription(T("|Defines the text height|, ") + T("|0 = byDimstyle|") + T(", |<0 = do not show in model|"));
			dTextHeight.setCategory(category);

			String sColorTextName=T("|Color|");	
			PropInt nColorText(nIntIndex++, nc, sColorTextName);	
			nColorText.setDescription(T("|Defines the Color|"));
			nColorText.setCategory(category);

		category = T("|Linework|");
			String sColorName=T("|Color|");	
			PropInt nColor(nIntIndex++, nc, sColorName);	
			nColor.setDescription(T("|Defines the Color|"));
			nColor.setCategory(category);
			
			String sTransparencyName=T("|Transparency|");	
			PropInt nTransparency(nIntIndex++, 0, sTransparencyName);	
			nTransparency.setDescription(T("|Defines the transparency|"));
			nTransparency.setCategory(category);
			
			String sLineTypeName=T("|Linetype|");	
			PropString sLineType(nStringIndex++, _LineTypes, sLineTypeName);	
			sLineType.setDescription(T("|Defines the LineType|"));
			sLineType.setCategory(category);
			
			String sLineTypeScaleName=T("|Linetype Scale|");	
			PropDouble dLineTypeScale(nDoubleIndex++, U(10), sLineTypeScaleName);	
			dLineTypeScale.setDescription(T("|Defines the scale of the linetype|"));
			dLineTypeScale.setCategory(category);	
			
		category = T("|Dimension|");
			String sStereotypes[0];
			String styles[] = MultiPageStyle().getAllEntryNames();
			for (int i=0;i<styles.length();i++) 
			{ 
				MultiPageStyle mps(styles[i]);
				String stereotypes[] = mps.getListOfStereotypeOverrides();
				for (int j=0;j<stereotypes.length();j++) 
				{ 
					if (sStereotypes.findNoCase(stereotypes[j],-1)<0)
						sStereotypes.append(stereotypes[j]); 			 
				}//next j	 
			}//next i
			sStereotypes = sStereotypes.sorted();
			sStereotypes.insertAt(0, "*");
		
		
			String sStereotypeName=T("|Stereotype|");	
			PropString sStereotype(nStringIndex++, sStereotypes, sStereotypeName);	
			sStereotype.setDescription(T("|Defines the Stereotype|"));
			sStereotype.setCategory(category);
			
			String sIsActiveName=T("|Add Dimension|");	
			PropString sIsActive(nStringIndex++, sNoYes, sIsActiveName);	
			sIsActive.setDescription(T("|Defines if dimensions will be added to the shopdrawing|"));
			sIsActive.setCategory(category);

		}
		return;
	}
//End DialogMode//endregion 
	
//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="hsbCLT-Opening";
	Map mapSetting;

// compose settings file location
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound = _bOnInsert ? sFolders.find(sFolder) >- 1 ? true : makeFolder(sPath + "\\" + sFolder) : false;
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";
	
// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() )
	{
		String sFile=findFile(sFullPath); 
	// if no settings file could be found in company try to find it in the installation path
		if (sFile.length()<1) sFile=findFile(sPathGeneral+sFileName+".xml");	
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);			
		}
	}
	// validate version when creating a new instance
	if(_bOnDbCreated)
	{ 
		int nVersion = mapSetting.getInt("GeneralMapObject\\Version");
		String sFile = findFile(sPathGeneral + sFileName + ".xml");		// set default xml path
		if (sFile.length()<1) sFile=findFile(sFullPath);				// set custom xml path if no default found
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);	// read the xml from installation directory
		int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");		
		if(sFile.length()>0 && nVersion!=nVersionInstall)
			reportNotice(TN("|A different Version of the settings has been found for|") + scriptName()+
			TN("|Current Version| ")+nVersion + "	" + _kPathDwg + TN("|Other Version| ") +nVersionInstall + "	" + sFile);
	}
//End Settings//endregion	
	
//region Settings Freeprofile for CNC tools	
	String sFileName2 ="hsbCLT-Freeprofile";
	Map mapSetting2;

// compose settings file location
	String sFullPath2 = sPath+"\\"+sFolder+"\\"+sFileName2+".xml";

// read a potential mapObject
	MapObject mo2(sDictionary ,sFileName2);
	if (mo2.bIsValid())
	{
		mapSetting2=mo2.map();
		setDependencyOnDictObject(mo2);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo2.bIsValid() )
	{
		String sFile2=findFile(sFullPath2); 
	// if no settings file could be found in company try to find it in the installation path
		if (sFile2.length()<1) sFile2=findFile(sPathGeneral+sFileName2+".xml");	
		if (sFile2.length()>0)
		{ 
			mapSetting2.readFromXmlFile(sFile2);
			mo2.dbCreate(mapSetting2);			
		}
	}
	Map mapTools = mapSetting2.getMap("Tool[]");
//endregion	

//region Properties
category = T("|General|");
	String sStrategyName=T("|Strategy|");	
	PropString sStrategy(nStringIndex++, sStrategies, sStrategyName);	
	sStrategy.setDescription(T("|Defines the strategy of the tool|"));
	sStrategy.setCategory(category);
	sStrategy.setControlsOtherProperties(true);
	int nStrategy = sStrategies.find(sStrategy, 1);
	if (nStrategy<-1){ sStrategy.set(sStrategies[1]); setExecutionLoops(2); return;}
	
category = T("|Tooling|");
	String sRadiusName=T("|Radius|");	
	PropDouble dRadius(nDoubleIndex++, U(0), sRadiusName);	
	dRadius.setDescription(T("|Defines the radius of a potential opening.|") + T("|Negative = cleanup radius|"));
	dRadius.setCategory(category);

	String sXOffsetName=T("|Offset X|");
	PropDouble dXOffset(nDoubleIndex++, U(200), sXOffsetName);	
	dXOffset.setDescription(T("|Defines the X Offset of the tool.| ") + T("|Midpoint = offset from corner|, ") + T("|Corner = length from corner|, "));
	dXOffset.setCategory(category);	
	
	String sYOffsetName=T("|Offset Y|");		
	PropDouble dYOffset(nDoubleIndex++, U(0), sYOffsetName);	
	dYOffset.setDescription(T("|Defines the Y Offset of the tool.| ") + T("|Midpoint = offset from corner|, ") + T("|Corner = length from corner|, "));
	dYOffset.setCategory(category);	
	
//	// invalidate radius 
//	if (nStrategy==1 && (dXOffset<=0 || dYOffset<=0) && abs(dRadius)>0)
//	{ 
//		reportNotice(TN("|A radius can only be specified if the X- and the Y-Offset are > 0|"));
//		dRadius.set(0);
//	}
	
	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(8), sWidthName);	
	dWidth.setDescription(T("|Defines the width of the tool|") + T("|Slot if width <= 20mm, else beamcut|"));
	dWidth.setCategory(category);
	
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(0), sDepthName);	
	dDepth.setDescription(T("|Defines the Depth|") + T(", |0 = complete through|"));
	dDepth.setCategory(category);
	
	String sFaceName=T("|Face|");
	String sFaces[] = { kFaceRef, kFaceOpp};
	PropString sFace(nStringIndex++, sFaces, sFaceName);	
	sFace.setDescription(T("|Defines the Face|"));
	sFace.setCategory(category);
	int nFace = sFaces.find(sFace)==1?1:-1;
	
category = T("|Edge Opening|");
	String sEdgeOnly = T("|Only applicable for tools on the bounding edge of a panel|");
	String sLengthEdgeCutName=T("|Length Edge Cut|");	
	PropDouble dLengthEdgeCut(nDoubleIndex++, U(0), sLengthEdgeCutName);	
	dLengthEdgeCut.setDescription(T("|Defines the length of the cut on the edge.| ")+sEdgeOnly);
	dLengthEdgeCut.setCategory(category);
	
	String sSupportWidthName=T("|Reinforcement Width|");	
	PropDouble dSupportWidth(nDoubleIndex++, U(200), sSupportWidthName);	
	dSupportWidth.setDescription(T("|Defines the width of the supporting part.| ")+sEdgeOnly);
	dSupportWidth.setCategory(category);
	
category = T("|General|");
	String sAreaFilterName=T("|Filter by Area|");	
	PropString sAreaFilter(nStringIndex++, "", sAreaFilterName);	
	sAreaFilter.setDescription(T("|Shapes matching the filter condition are accepted.|") + 
		T("|Specify area in m² (metric) or drawing units (imperial) with leading logical condition, i.e. <=0.7|") );
	sAreaFilter.setCategory(category);
	
category = T("|Display|");
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "", sFormatName);	
	sFormat.setDescription(T("|Defines the format variable and/or any static text.|") + 
		T("|i.e. this argument would display the area in [m²], rounded to 3 decimal digits|: ")+"@(Area:CU;m:RL3)m²");
	sFormat.setCategory(category);
	//
//End Properties//endregion 
		
//End Part #1//endregion 

//region Part #2

//region bOnInsert
	if(_bOnInsert)
	{
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
		
		int strategy = sStrategies.find(sStrategy, 0);
		int bHasSupport = dSupportWidth > 0 && strategy!=2 && strategy!=3 && strategy!=4 && strategy!=5;
		if (!bHasSupport)
		{ 
			dSupportWidth.set(0);
			dLengthEdgeCut.set(0);
			setCatalogFromPropValues(sLastInserted);
		}

	//region Get Area and logical expression of filter area
		int nLogical; // 0 = undefined < <= > >= =
		double dArea;
		int bIsMetric = U(1000) == 1000 || U(1000) == 100 || U(1000) == 10 || U(1000) == 1;
		if (sAreaFilter.length()>1)
		{ 
			String s = sAreaFilter; s.trimLeft().trimRight();
			String s1 = s.left(1);
			String s2 = s.left(2).right(1);
			if (s1 == "<")nLogical = s2 == "=" ? 2 : 1;// smaller equal , smaller
			else if (s1 == ">")nLogical = s2 == "=" ? 4 : 3; // greater equal, greater 
			else if (s1 == "=")nLogical = 5; // equal
			
			int n;
			if (nLogical == 1 || nLogical == 3 || nLogical == 5)n = 1;
			else if (nLogical == 2 || nLogical == 4)n = 2;
			
			String s3 = s.right(s.length() - n).trimLeft().trimRight();
			dArea = s3.atof();
		}			
	//endregion 

	// prompt for sips
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());
		if (ssE.go())
			ents.append(ssE.set());
		//reportNotice("\n" + ents.length() + " panels selected");
		
		
	// loop selection set and collect shapes to be replaced
	// a set of 4 arrays with a one to one relation will be collected 
		Sip sips[0];				// the panel
		PlaneProfile ppShapes[0];	// the shape to be added to the panel
		PLine plContours[0];		// the contour to be of the modified
		int bIsDoors[0];			//	a flag to identify a opening or door/edge 	
		int bAddExtrusion= strategy==3;
		int bAddHouse= strategy==4;
		int bAddMortise= strategy==5;
		
		for (int i = 0; i < ents.length(); i++)
		{
			Sip sip = (Sip)ents[i];
			Vector3d vecX = sip.vecX();
			Vector3d vecY = sip.vecY();
			Vector3d vecZ = sip.vecZ();
			Point3d ptCen = sip.ptCenSolid();
			double dZ = sip.dH();
			PLine plEnvelope = sip.plEnvelope();
			CoordSys cs = CoordSys(ptCen-vecZ*.5*dZ, vecX, vecY, vecZ);
			Plane pnZ(ptCen-vecZ*.5*dZ, vecZ);

		// the shape of the original panel
			PlaneProfile ppEnvelope(cs);
			ppEnvelope.joinRing(plEnvelope,_kAdd);
			// HSB-23562: work with envelopebody with cuts
//			ppEnvelope=sip.envelopeBody(true,true).shadowProfile(Plane(cs.ptOrg(),cs.vecZ()));
//			PLine plsEnvelope[]=ppEnvelope.allRings(true,false);
//			if(plsEnvelope.length()>0)plEnvelope=plsEnvelope.first();
			
			PlaneProfile ppBlowUp=ppEnvelope;
			
			ppBlowUp.shrink(-dBlowUpShrink);			
			ppBlowUp.shrink(dBlowUpShrink);
			ppBlowUp.subtractProfile(ppEnvelope);

			PlaneProfile ppHull(cs);
			{
				PLine pl;pl.createConvexHull(pnZ, plEnvelope.vertexPoints(true));
				ppHull.joinRing(pl,_kAdd);
			}
			
		// the boxed shape of the panel	
			PlaneProfile ppSipBox(cs);
			ppSipBox.createRectangle(ppEnvelope.extentInDir(vecX), vecX, vecY);
			//ppSipBox.shrink(-dEps);

		// Get a profile to calculate the net profile of a support if set
			PlaneProfile ppSupportSubtract; 
			if (dSupportWidth>0)
			{ 
				ppSupportSubtract = ppSipBox; 
				ppSupportSubtract.shrink(dSupportWidth);		
			}

		// collect windows / openings	
			PLine plOpenings[] = sip.plOpenings();
			//reportNotice("\n" + sip.handle() + " num of openings " + plOpenings.length());
			for (int j=0;j<plOpenings.length();j++) 
			{ 
				PlaneProfile ppShape(cs);
				ppShape.joinRing(plOpenings[j],_kAdd);
				ppShapes.append(ppShape);			
				plContours.append(plOpenings[j]);
				sips.append(sip);
				bIsDoors.append(false);
			}//next j			
			
		// Collect rings of the blowupAndShrink
			PLine rings[]= ppBlowUp.allRings(true, false);		
			
		// collect doors or cutouts at the edge of the panel if not intersecting with the blowUp
			{ 
				PlaneProfile ppEdge;
				ppEdge = ppSipBox;
//				ppSipBox.shrink(-dEps);
				ppEdge.joinRing(plEnvelope,_kSubtract);
				ppEdge.shrink(dEps);// TODO used to be multiplied by 2
				ppEdge.shrink(-dEps);	//ppEdge.vis(72);			
								
				PLine _rings[] = ppEdge.allRings(true, false);
				for (int j=0;j<_rings.length();j++)
				{
					PlaneProfile pp(_rings[j]);
					if (!pp.intersectWith(ppBlowUp))//ppBlowUp.area()>pow(dEps,2) && 
					{
					 	rings.append(_rings[j]);
					 	//_rings[j].vis(j+1);
					}	
				}
			}
			
			for (int j=0;j<rings.length();j++) 
			{ 
				PLine ring = rings[j];
				
			//region Accept only rectangular shapes if in extrusion mode
				if (0)
				{ 
					Vector3d vecXS=vecX;
					double dMin = U(10e6);
					Point3d pts[] = ring.vertexPoints(false);
					for (int p=0;p<pts.length()-1;p++) 
					{ 
						Vector3d vec= pts[p+1]-pts[p];
						if (vec.length()<dMin)
						{
							dMin = vec.length();
							vecXS = vec;
							vecXS.normalize();
						}			 
					}//next p
					Vector3d vecYS = vecXS.crossProduct(-vecZ);	
					
					PLine rect; rect.createRectangle(PlaneProfile(ring).extentInDir(vecXS), vecXS, vecYS);
					if (abs(rect.area()-ring.area())>pow(dEps,2))
					{ 
						if (bDebug)reportMessage("\n" + j +" ring is not a rectangle");
						continue;
					}
				}					
			//endregion 
				
				PlaneProfile ppShape(cs);
				ppShape.joinRing(ring,_kAdd);

				PlaneProfile ppOpening = (strategy==2 ||strategy==3 || strategy==4 || strategy==5) ?ppShape:ppSipBox;
				if (bHasSupport)
					ppOpening.shrink(dSupportWidth); 
				else if ((strategy==2 || strategy==3 || strategy==4 || strategy==5)&& abs(dRadius)>dEps) // opening mode
				{ 
				// stretch by radius to any free edge
					Point3d ptMid = ppOpening.ptMid();
					Point3d pts[] = ppOpening.getGripEdgeMidPoints();

					for (int p=0;p<pts.length();p++) 
					{ 
						if (ppSipBox.pointInProfile(pts[p])==_kPointOnRing)
						{
							Vector3d vecDir = pts[p]-ptMid; vecDir.normalize();
							ppOpening.moveGripEdgeMidPointAt(p, vecDir * abs(dRadius));
						}						 
					}//next i
					if (bDebug)ppOpening.vis(172);
				}

			// modify contour by mapIO	
				if (abs(dRadius)>0 &&  ppOpening.allRings(true, false).length()>0)
				{ 	
					PLine rings[] = ppOpening.allRings(true, false);
					PLine plTool= rings.first();
					
					Map mapIO;	
					mapIO.setPLine("plContour",plTool);
					mapIO.setDouble("radius",dRadius); // a negative radius will create cleanup corner shape, positive will round
					mapIO.setVector3d("vecX",vecX);
					mapIO.setVector3d("vecY",vecY);
					mapIO.setVector3d("vecZ",vecZ);
					
					TslInst().callMapIO(scriptName(), mapIO);
					PLine plCleanUp = mapIO.getPLine("plContour");		
					
					if (plCleanUp.area()>pow(dEps,2))
					{ 	
						ppOpening.removeAllRings();
						ppOpening.joinRing(plCleanUp, _kAdd);
						if (bDebug)ppOpening.vis(3);
					}
				}
				//ppShape.joinRing(plEnvelope,_kSubtract);
				
			// get jig shape with reinforcment support	
				if (bHasSupport)
					ppShape.subtractProfile(ppOpening); 
			// get rounded shape and contour for jigging		
				else if ((strategy == 2 || strategy == 3 || strategy==4 || strategy==5) && abs(dRadius)>dEps)  
				{
					ppOpening.intersectWith(ppSipBox);
					PLine rings2[] = ppOpening.allRings(true, false);
					if (rings2.length()>0)ring = rings2.first();
				}
				
				ppShapes.append(ppShape);
				plContours.append(ring);
				sips.append(sip);
				bIsDoors.append(true);
			}//next j
			
			//ppBlowUp.vis(211);
			//ppHull.vis(2);	
			//ppEnvelope.vis(6);
			//ppSipBox.vis(4);
			//ppSupportSubtract.vis(3);	
		}
		
	// Set Jig Map
		Map mapArgs;
		mapArgs.setString("AreaFilter", sAreaFilter);
		for (int i=0;i<sips.length();i++) 
		{ 	
		// check if this is to be filtered
			if (dArea>0)
			{ 
				double area = plContours[i].area();
				if (bIsMetric)area/=U(10e5,"mm");

				int bSkip;
				if (nLogical <= 2 && dArea < area){continue;}
				else if (nLogical == 2 && dArea <= area){continue;}
				else if (nLogical == 3 && dArea > area){continue;}
				else if (nLogical == 4 && dArea >= area){continue;}
				else if (nLogical == 5 && abs(dArea-area)<pow(dEps,2)){continue;}				
			}
			
			Map mapArg;
			mapArg.setPlaneProfile("shape", ppShapes[i]);
			mapArg.setPLine("contour", plContours[i]);
			mapArg.setInt("isDoor", bIsDoors[i]);
			mapArg.setInt("Strategy", strategy);
			mapArg.setDouble("dZ", sips[i].dH());
			mapArgs.appendMap("Tool", mapArg);
		}//next i
		
	// Prompt to pick individual openings
		String prompt;
		PrPoint ssP(T("|Select Opening or all [Polylines/Openings/Cutouts/Shapes/setArea]|"));
		int bInsertAll;
		
	// Jig
		int nGoJig = -1;
		while (nGoJig != _kNone)
		{ 
			nGoJig = ssP.goJig("JigAction", mapArgs); 
			
		//region Jig: point picked
			if (nGoJig == _kOk)
			{
				Point3d ptPick = ssP.value();
				
			// loop arrays to identify shape and contour
				for (int i=sips.length()-1; i>=0 ; i--) 
				{ 
				// check if this is to be filtered
					if (dArea>0)
					{ 
						double area = plContours[i].area();
						if (bIsMetric)area/=U(10e5,"mm");
		
						int bSkip;
						if (nLogical <= 2 && dArea < area){continue;}
						else if (nLogical == 2 && dArea <= area){continue;}
						else if (nLogical == 3 && dArea > area){continue;}
						else if (nLogical == 4 && dArea >= area){continue;}
						else if (nLogical == 5 && abs(dArea-area)<pow(dEps,2)){continue;}				
					}	

					PLine plContour = plContours[i];
					PlaneProfile ppContour(plContour);
					
				// project picked point to plane	
					CoordSys cs = ppContour.coordSys();
					Point3d pt=ptPick;
					Line(ptPick,vecZView).hasIntersection(Plane(cs.ptOrg(), cs.vecZ()),pt);
					if (ppContour.pointInProfile(pt)==_kPointOutsideProfile){ continue;}
					
					PlaneProfile ppShape = ppShapes[i];					
					int bIsDoor = bIsDoors[i];
					Sip sip = sips[i];
					Vector3d vecX = sip.vecX();
					Vector3d vecY = sip.vecY();

				// create TSL
					TslInst tslNew;				Map mapTsl;
					int bForceModelSpace = true;	
					String sExecuteKey,sCatalogName = sLastInserted;
					String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
					GenBeam gbsTsl[] = {sip};		Entity entsTsl[] = {};			
					Point3d ptsTsl[] = {ppShape.extentInDir(sip.vecX()).ptMid()};
				
					mapTsl.setPlaneProfile("shape",ppShape);//PlaneProfile(plContour));//
					mapTsl.setInt("isDoor", bIsDoor);

					tslNew.dbCreate(scriptName() ,vecX ,vecY,gbsTsl, entsTsl, ptsTsl, sCatalogName, 
						bForceModelSpace, mapTsl, sExecuteKey, sEvent); 	
					
				// remove inserted	
					ppShapes.removeAt(i);
					plContours.removeAt(i);
					bIsDoors.removeAt(i);
					sips.removeAt(i);

				// recompose mapArgs
					mapArgs=Map();
					for (int ii=0;ii<sips.length();ii++) 
					{ 
					// check if this is to be filtered
						if (dArea>0)
						{ 
							double area = plContours[ii].area();
							if (bIsMetric)area/=U(10e5,"mm");
			
							int bSkip;
							if (nLogical <= 2 && dArea < area){continue;}
							else if (nLogical == 2 && dArea <= area){continue;}
							else if (nLogical == 3 && dArea > area){continue;}
							else if (nLogical == 4 && dArea >= area){continue;}
							else if (nLogical == 5 && abs(dArea-area)<pow(dEps,2)){continue;}				
						}	

						Map mapArg;
						mapArg.setPlaneProfile("shape", ppShapes[ii]);
						mapArg.setPLine("contour", plContours[ii]);
						mapArg.setInt("isDoor", bIsDoors[ii]);
						mapArg.setInt("Strategy", strategy);
						mapArg.setDouble("dZ", sips[ii].dH());
						mapArgs.appendMap("Tool", mapArg);
					}//next i
				}//next i				
			}				
		//End Jig: point picked//endregion 	

		//region Jig: keyword
			else if (nGoJig == _kKeyWord)
			{ 
				int keywordIndex = ssP.keywordIndex();
				if (keywordIndex ==0)	// Polyline
				{ 
				// collect closed polylines
					PrEntity ssEpl(T("|Select polylines|"), Entity());
					Entity ents[0];
				  	if (ssEpl.go())
						ents.append(ssEpl.set());

					Map mapPLines;
					for (int i=0;i<ents.length();i++) 
					{ 
						//EntPLine epl = (EntPLine)ents[i];
						PLine pl = ents[i].getPLine();
						if (pl.area()>pow(dEps,2))
							mapPLines.appendPLine(ents[i].handle(), pl);
						 
					}//next i
					
					if (mapPLines.length()>0)
					{
						bInsertAll = true;
						mapArgs.appendMap("PLine[]", mapPLines);
						nGoJig = _kNone;
					}	
				}
				else if (keywordIndex ==1 || keywordIndex ==2 || keywordIndex==3)	// all Openings, Doors or any shapes
				{ 					
				// remove all doors
					for (int i=sips.length()-1; i>=0 ; i--) 
					{ 
						int bIsDoor = bIsDoors[i];
						if ((bIsDoor && keywordIndex==1) || (!bIsDoor && keywordIndex==2))
						{ 
							sips.removeAt(i);
							ppShapes.removeAt(i);
							plContours.removeAt(i);
							bIsDoors.removeAt(i);
							
						}	
					}//next i
					bInsertAll = true;
					nGoJig = _kNone;
					break;
				}
				else if (keywordIndex ==4)
				{ 
					String sNewAreaFilter = getString(TN("|Specify area in m² (metric) or drawing units (imperial) with leading logical condition, i.e. <=0.7|"));
					
					if (sNewAreaFilter.length()>1)
					{ 
						String s = sNewAreaFilter; s.trimLeft().trimRight();
						String s1 = s.left(1);
						String s2 = s.left(2).right(1);
						if (s1 == "<")nLogical = s2 == "=" ? 2 : 1;// smaller equal , smaller
						else if (s1 == ">")nLogical = s2 == "=" ? 4 : 3; // greater equal, greater 
						else if (s1 == "=")nLogical = 5; // equal
						
						int n;
						if (nLogical == 1 || nLogical == 3 || nLogical == 5)n = 1;
						else if (nLogical == 2 || nLogical == 4)n = 2;
						
						String s3 = s.right(s.length() - n).trimLeft().trimRight();
						dArea = s3.atof();
						
						sAreaFilter.set(sNewAreaFilter);
						mapArgs=Map();
						mapArgs.setString("AreaFilter", sAreaFilter);
						for (int i=0;i<sips.length();i++) 
						{ 	
						// check if this is to be filtered
							if (dArea>0)
							{ 
								double area = plContours[i].area();
								if (bIsMetric)area/=U(10e5,"mm");
				
								int bSkip;
								if (nLogical <= 2 && dArea < area){continue;}
								else if (nLogical == 2 && dArea <= area){continue;}
								else if (nLogical == 3 && dArea > area){continue;}
								else if (nLogical == 4 && dArea >= area){continue;}
								else if (nLogical == 5 && abs(dArea-area)<pow(dEps,2)){continue;}				
							}
				
							Map mapArg;
							mapArg.setPlaneProfile("shape", ppShapes[i]);
							mapArg.setPLine("contour", plContours[i]);
							mapArg.setInt("isDoor", bIsDoors[i]);
							mapArg.setInt("Strategy", strategy);
							mapArg.setDouble("dZ", sips[i].dH());
							mapArgs.appendMap("Tool", mapArg);
						}//next i							
					}
				}
			}
		//End Jig: keyword//endregion 

		// Jig: cancel
	        else if (nGoJig == _kCancel)
	        {
	        	break;	
	        }
		}


	//region Collect sips and plines
		Map mapPLines = mapArgs.getMap("PLine[]");
		if (mapPLines.length()>0)
		{ 
			//reportNotice("\npline detection active");
			sips.setLength(0);
			ppShapes.setLength(0);
			plContours.setLength(0);
			bIsDoors.setLength(0);
			
		// get profiles
			PlaneProfile pps[0];
			for (int i=0;i<mapPLines.length();i++) 
				if (mapPLines.hasPLine(i))
					pps.append(PlaneProfile(mapPLines.getPLine(i))); 
	
		// collect intersections with sips from sset
			for (int s=0;s<ents.length();s++) 
			{ 
				Sip sip =(Sip)ents[s];
				for (int i=0;i<pps.length();i++) 
				{ 
					PlaneProfile ppSip(sip.coordSys());
					ppSip.joinRing(sip.plEnvelope(),_kAdd);
					PlaneProfile pp1(sip.coordSys());
					pp1.unionWith(pps[i]);
					
					PlaneProfile pp2 = pp1;
					pp2.intersectWith(ppSip);
					
					PLine rings[] = pp1.allRings(true, false);
					if (pp2.area()>pow(dEps,2) && rings.length()>0)
					{ 
						sips.append(sip);
						ppShapes.append(pp1);
						plContours.append(rings.first());
						bIsDoors.append(false);
					}
				}//next i 
			}//next s
		}
	//End Collect sips and plines//endregion 

	//region Insert all
		if (bInsertAll)
		{ 
			//reportNotice("\ninsert all active");
      		for (int i=0;i<sips.length();i++) 
			{ 
			// check if this is to be filtered
				if (dArea>0)
				{ 
					double area = plContours[i].area();
					if (bIsMetric)area/=U(10e5,"mm");
	
					int bSkip;
					if (nLogical <= 2 && dArea < area){continue;}
					else if (nLogical == 2 && dArea <= area){continue;}
					else if (nLogical == 3 && dArea > area){continue;}
					else if (nLogical == 4 && dArea >= area){continue;}
					else if (nLogical == 5 && abs(dArea-area)<pow(dEps,2)){continue;}				
				}	
				
				Sip sip = sips[i];
				Vector3d vecX = sip.vecX();
				Vector3d vecY = sip.vecX();
				
				PlaneProfile ppShape =ppShapes[i];
				PLine plContour = plContours[i];
				int bIsDoor = bIsDoors[i];
				
			// create TSL
				TslInst tslNew;				Map mapTsl;
				int bForceModelSpace = true;	
				String sExecuteKey,sCatalogName = sLastInserted;
				String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
				GenBeam gbsTsl[] = {sip};		Entity entsTsl[] = {};			
				Point3d ptsTsl[] = {ppShape.extentInDir(vecX).ptMid()};
				//
				mapTsl.setPlaneProfile("shape", PlaneProfile(plContour));//ppShape);
				//mapTsl.setPLine("contour", plContour);
				mapTsl.setInt("isDoor", bIsDoor);		
				
				tslNew.dbCreate(scriptName() , vecX, vecY,gbsTsl, entsTsl, ptsTsl, sCatalogName,
					bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
				// HSB-13386
				tslNew.recalcNow();
				
			}//next i			
		}
	//End Insert all//endregion  
	    
	    eraseInstance();
		return;
	}	
// end on insert	__________________//endregion
	
//region Panel standards
	if (_Sip.length()<1)
	{
		reportMessage("\n" + scriptName() + ": " +T("|Invalid reference.|") + " " + T("|Tool will be deleted|"));
		eraseInstance();
		return;
	}
	//reportNotice("\n\nExecuting " + _ThisInst.handle() + " in loop " + _kExecutionLoopCount);
	
	Sip sip = _Sip[0];
	Vector3d vecX = sip.vecX();
	Vector3d vecY = sip.vecY();
	Vector3d vecZ = sip.vecZ();
	Point3d ptCen = sip.ptCenSolid();
	double dZ = sip.dH();
	vecX.vis(ptCen,1);vecY.vis(ptCen,3);vecZ.vis(ptCen,150);
	Vector3d vecFace = nFace * vecZ;	vecFace.vis(ptCen,2);
	Point3d ptFace = ptCen + vecFace * .5 * dZ;
	Plane pnFace(ptFace, vecZ);
	_Pt0 += vecFace * vecFace.dotProduct(ptFace - _Pt0);
	_ThisInst.setDrawOrderToFront(true);
	_ThisInst.setAllowGripAtPt0(false);

// declare a potential element ref
	Element el=sip.element();
	if (el.bIsValid())
	{
		assignToElementGroup(el,true,0,'T');
		_Element.append(el);	
	}
	else
		assignToGroups(sip, 'T');
	
	PLine plOpenings[] = sip.plOpenings();
	PLine plEnvelope = sip.plEnvelope();
	// HSB-23562: 
//	PlaneProfile ppEnvelope=sip.envelopeBody(true,true).shadowProfile(
//			Plane(plEnvelope.coordSys().ptOrg(),plEnvelope.coordSys().vecZ()));
//	PLine plsEnvelope[]=ppEnvelope.allRings(true,false);
//	if(plsEnvelope.length()>0)plEnvelope=plsEnvelope.first();
	
	Body bdEnv = sip.envelopeBody(false, true);
	Plane pnZ(ptCen, vecZ);
	CoordSys cs = CoordSys(ptFace, vecX, vecY, vecZ); cs.vis(2);
	PlaneProfile ppZ(cs);
	ppZ.unionWith(bdEnv.shadowProfile(pnZ));		//ppZ.vis(1);
	SipEdge edges[] = sip.sipEdges();
	SipStyle style(sip.style());
	
	PlaneProfile ppSipBox(cs); 
	ppSipBox.joinRing(plEnvelope, _kAdd);
	LineSeg segBox = ppSipBox.extentInDir(vecX);
	ppSipBox.createRectangle(segBox, vecX, vecY); // box it
	PLine plSipBox; plSipBox.createRectangle(segBox, vecX, vecY); 		
	if(dRadius>dEps && _bOnDbCreated)
	{ 
		setExecutionLoops(2);
	}
//End Panel standards//endregion 
	
//region Debug Contour detection
	if (0)
	{ 
		int strategy = nStrategy;
		int bHasSupport;
	// a set of 4 arrays with a one to one relation will be collected 
		Sip sips[0];				// the panel
		PlaneProfile ppShapes[0];	// the shape to be added to the panel
		PLine plContours[0];		// the contour to be of the modified
		int bIsDoors[0];			//	a flag to identify a opening or door/edge 	
		int bAddExtrusion= nStrategy==3;


		// the shape of the original panel
			PlaneProfile ppEnvelope(cs);
			ppEnvelope.joinRing(plEnvelope,_kAdd);
	
			PlaneProfile ppBlowUp=ppEnvelope;
			ppBlowUp.shrink(-dBlowUpShrink);
			ppBlowUp.shrink(dBlowUpShrink);
			ppBlowUp.subtractProfile(ppEnvelope);

			PlaneProfile ppHull(cs);
			{
				PLine pl;pl.createConvexHull(pnZ, plEnvelope.vertexPoints(true));
				ppHull.joinRing(pl,_kAdd);
			}
			
		// the boxed shape of the panel	
			PlaneProfile ppSipBox(cs);
			ppSipBox.createRectangle(ppEnvelope.extentInDir(vecX), vecX, vecY);
			//ppSipBox.shrink(-dEps);

		// Get a profile to calculate the net profile of a support if set
			PlaneProfile ppSupportSubtract; 
			if (dSupportWidth>0)
			{ 
				ppSupportSubtract = ppSipBox; 
				ppSupportSubtract.shrink(dSupportWidth);		
			}

		// collect windows / openings	
			PLine plOpenings[] = sip.plOpenings();
			//reportNotice("\n" + sip.handle() + " num of openings " + plOpenings.length());
			for (int j=0;j<plOpenings.length();j++) 
			{ 
				PlaneProfile ppShape(cs);
				ppShape.joinRing(plOpenings[j],_kAdd);
				ppShapes.append(ppShape);			
				plContours.append(plOpenings[j]);
				sips.append(sip);
				bIsDoors.append(false);
			}//next j			
	
		// Collect rings of the blowupAndShrink
			PLine rings[]=ppBlowUp.allRings(true, false);	

	
		// collect doors or cutouts at the edge of the panel if not intersecting with the blowUp
			{ 
				PlaneProfile ppEdge;
				ppEdge = ppSipBox;
				ppSipBox.shrink(-dEps);
				ppEdge.joinRing(plEnvelope,_kSubtract);	if (bDebug)ppEdge.vis(1);	
				ppEdge.shrink(2*dEps);					if (bDebug)ppEdge.vis(2);	
				ppEdge.shrink(-dEps);					if (bDebug)ppEdge.vis(72);		
								
				PLine _rings[] = ppEdge.allRings(true, false);
				for (int j=0;j<_rings.length();j++)
				{
					PlaneProfile pp(_rings[j]);
					if (!pp.intersectWith(ppBlowUp))//ppBlowUp.area()>pow(dEps,2) && 
					{
					 	rings.append(_rings[j]);
					 	_rings[j].vis(j+1);
					}	
				}
			}

			for (int j=0;j<rings.length();j++) 
			{ 
				PLine ring = rings[j];
				

			//region Accept only rectangular shapes if in extrusion mode
				if (0)
				{ 
					Vector3d vecXS=vecX;
					double dMin = U(10e6);
					Point3d pts[] = ring.vertexPoints(false);
					for (int p=0;p<pts.length()-1;p++) 
					{ 
						Vector3d vec= pts[p+1]-pts[p];
						if (vec.length()<dMin)
						{
							dMin = vec.length();
							vecXS = vec;
							vecXS.normalize();
						}			 
					}//next p
					Vector3d vecYS = vecXS.crossProduct(-vecZ);	
					
					PLine rect; rect.createRectangle(PlaneProfile(ring).extentInDir(vecXS), vecXS, vecYS);
					if (abs(rect.area()-ring.area())>pow(dEps,2))
					{ 
						if (bDebug)reportMessage("\n" + j +" ring is not a rectangle");
						continue;
					}
				}					
			//endregion 


				PlaneProfile ppShape(cs);
				ppShape.joinRing(ring,_kAdd);

				PlaneProfile ppOpening = (strategy==2 ||strategy==3) ?ppShape:ppSipBox;
				if (bHasSupport)
					ppOpening.shrink(dSupportWidth); 
				else if ((strategy==2 || strategy==3)&& abs(dRadius)>dEps) // opening mode
				{ 
				// stretch by radius to any free edge
					Point3d ptMid = ppOpening.ptMid();
					Point3d pts[] = ppOpening.getGripEdgeMidPoints();

					for (int p=0;p<pts.length();p++) 
					{ 
						if (ppSipBox.pointInProfile(pts[p])==_kPointOnRing)
						{
							Vector3d vecDir = pts[p]-ptMid; vecDir.normalize();
							ppOpening.moveGripEdgeMidPointAt(p, vecDir * abs(dRadius));
						}						 
					}//next i
					if (bDebug)ppOpening.vis(172);

				}

			// modify contour by mapIO	
				if (abs(dRadius)>0 &&  ppOpening.allRings(true, false).length()>0)
				{ 	
					PLine rings[] = ppOpening.allRings(true, false);
					PLine plTool= rings.first();

					Map mapIO;	
					mapIO.setPLine("plContour",plTool);
					mapIO.setDouble("radius",dRadius); // a negative radius will create cleanup corner shape, positive will round
					mapIO.setVector3d("vecX",vecX);
					mapIO.setVector3d("vecY",vecY);
					mapIO.setVector3d("vecZ",vecZ);
					
					TslInst().callMapIO(scriptName(), mapIO);
					PLine plCleanUp = mapIO.getPLine("plContour");		
					
					if (plCleanUp.area()>pow(dEps,2))
					{ 	
						ppOpening.removeAllRings();
						ppOpening.joinRing(plCleanUp, _kAdd);
						if (bDebug)ppOpening.vis(3);
					}
				}
				//ppShape.joinRing(plEnvelope,_kSubtract);
			// get jig shape with reinforcment support	
				if (bHasSupport)
					ppShape.subtractProfile(ppOpening); 
			// get rounded shape and contour for jigging		
				else if ((strategy == 2 || strategy == 3) && abs(dRadius)>dEps)  
				{
					ppOpening.intersectWith(ppSipBox);
					PLine rings2[] = ppOpening.allRings(true, false);
					if (rings2.length()>0)ring = rings2.first();
				}
				
				ppShapes.append(ppShape);
				plContours.append(ring);
				sips.append(sip);
				bIsDoors.append(true);
			}//next j

			//ppBlowUp.vis(211);
			//ppHull.vis(2);	
			//ppEnvelope.vis(6);
			//ppSipBox.vis(4);
			//ppSupportSubtract.vis(3);	
		return;
	}
//endregion 
	
//region Tool Standards
	setEraseAndCopyWithBeams(_kBeam0);
	double dZT = dDepth; // given depth
	if (abs(dDepth)<dEps)// complete throuh
		dZT = dZ;
	else if (dDepth<0)	// negative value means remaining depth
		dZT= dZ + dDepth;	
		
	int bIsDoor = _Map.getInt("isDoor");
	int bHasSupport = bIsDoor && dSupportWidth > 0;
	int bIsOpening = nStrategy == 2;
	int bIsExtrusion = nStrategy == 3;
	int bIsHouse = nStrategy == 4;
	int bIsMortise = nStrategy == 5;
	Point3d ptToolDims[0]; // a collection of dimpoints derived from the tool, published as instance based override to dimrequests
	int bAddToolDim = _Map.getInt("AddToolDim");
	
	sAreaFilter.setReadOnly(_kHidden);
	if (_Map.getInt(kCloning)==false)
	{ 
		if (bIsExtrusion || bIsHouse || bIsMortise)
		{ 
			dXOffset.setReadOnly(_kHidden);
			dYOffset.setReadOnly(_kHidden);
			dWidth.setReadOnly(_kHidden);	
			dLengthEdgeCut.setReadOnly(_kHidden);
			dSupportWidth.setReadOnly(_kHidden);
			
			if (bIsHouse)
				dRadius.setReadOnly(_kHidden);	
			
		}
		else if (bIsOpening)
		{ 
			dXOffset.setReadOnly(_kHidden);
			dYOffset.setReadOnly(_kHidden);
			dWidth.setReadOnly(_kHidden);
			dDepth.setReadOnly(_kHidden);
		}	
		else if (nStrategy<1)
		{ 
			dRadius.setReadOnly(_kHidden);		
		}
	}
	
	PlaneProfile ppShape(cs);
	PlaneProfile ppShapeTool(cs);
	ppShape.unionWith(_Map.getPlaneProfile("shape"));	ppShape.vis(40);

// check if instance has been copied
	if (_Map.hasEntity("Me") && _Map.getEntity("Me") != _ThisInst)
	{
		if (bDebug)reportNotice("\nMe " + _Map.getEntity("Me") + " vs " + _ThisInst);
		_Map.removeAt("vecRef", true);
	}

// check if location has changed	
	Point3d ptRef = ppShape.extentInDir(vecX).ptMid();
	Point3d ptPrevRef = ptRef;
	if (_Map.hasVector3d("vecRef"))
	{
		ptPrevRef = sip.ptRef() + _Map.getVector3d("vecRef");
		ptPrevRef.vis(1); ptRef.vis(3);
	}
	Vector3d vecRefMove = Vector3d(ptRef-ptPrevRef);

	int bHasPLine;
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity ent = _Entity[i];
		EntPLine epl = (EntPLine)ent;
		if (epl.bIsValid() && !bHasPLine)
		{ 
			PlaneProfile pp(cs);
			pp.joinRing(epl.getPLine(), _kAdd);
			if (pp.area()>pow(dEps,2))
			{
				ppShape = pp;
				bHasPLine = true;
				setDependencyOnEntity(ent);
			}
		}
	}//next i

//End Tool Standards//endregion 

//region Read Settings
	String sStereotype = "*";
	int bIsActive=true;
	String sDimStyle = _DimStyles.first();
	double dTextHeight = U(80);
{
	String k;
	
	k = sStrategyKeys[nStrategy];
	if (!bIsExtrusion && !bIsHouse && !bIsMortise) k+=(bIsDoor?"Door":"Opening");

	Map m,m2;
	if (mapSetting.hasMap(k))m2 = mapSetting.getMap(k);
	else m2=mapSetting.getMap("Default");
	
	// LineWork
	k="LineWork";			if (m2.hasMap(k))	m = m2.getMap(k);
	k="LineTypeScale";		if (m.hasDouble(k))	dLineTypeScale = m.getDouble(k);
	k="LineType";			if (m.hasString(k))	sLineType = m.getString(k);
	k="Color";				if (m.hasInt(k))	nc = m.getInt(k);
	k="Transparency";		if (m.hasInt(k))	nt = m.getInt(k);

	// Display
	k="Display";			if (m2.hasMap(k))	m = m2.getMap(k);
	k="TextHeight";			if (m.hasDouble(k))	dTextHeight = m.getDouble(k);
	k="DimStyle";			if (m.hasString(k))	sDimStyle = m.getString(k);
	k="Color";				if (m.hasInt(k))	ncText = m.getInt(k);

	// Dimension
	k="Dimension";			if (m2.hasMap(k))	m = m2.getMap(k);
	k="Stereotype";			if (m.hasString(k))	sStereotype = m.getString(k);
	k="IsActive";			if (m.hasInt(k))	bIsActive = m.getInt(k);
}
//End Read Settings//endregion 

//region Remove opening on creation	
	ppShape.intersectWith(ppSipBox);
	if (ppShape.area()<pow(dEps,2))
	{ 
		reportMessage(TN("|Invalid tool shape.|"));
		eraseInstance();
		return;
	}
	PLine plShape;
	PLine rings[] = ppShape.allRings();
	if (rings.length()>0)		
		plShape = rings.first();
	else					
	{
		eraseInstance();return;
	}
	//plShape.vis(1);

	int bAddRing = _bOnDbCreated || !vecRefMove.bIsZeroLength();	
	if (bIsDoor && _Map.hasDouble("SupportWidth") && 
		(_Map.getDouble("SupportWidth")!=dSupportWidth || _kNameLastChangedProp==sRadiusName))
	{
		//reportNotice("\n"+_ThisInst.handle()+ " ln980 sets addRing flag in loop " + _kExecutionLoopCount);
		bAddRing = true;
	}
// opening strategy: not a door but radius has changed
	else if (nStrategy==2 && !bIsDoor && _kNameLastChangedProp==sRadiusName)
	{
		//reportNotice("\n"+_ThisInst.handle()+ " ln987 sets addRing flag as opening in loop " + _kExecutionLoopCount);
		bAddRing = true;
	}
// strategy changed
	else if (_kNameLastChangedProp == sStrategyName && nStrategy!=3 && nStrategy!=4 && nStrategy!=5)
		bAddRing = true;

// batch insert: do not add ring if it is not the first instance of the batch insert // HSB-16458
	if (_Map.hasInt(kBatchIndex))
	{ 
		if (_Map.getInt(kBatchIndex)>0)
			bAddRing=false;
		_Map.removeAt(kBatchIndex, true);
	}
	
// Add ring
	if (bAddRing)
	{ 
		
		PLine ring = plShape;
		if (bIsDoor)
		{ 
		// get an outer profile around the boxed envelope 
		
			PlaneProfile ppOut = ppSipBox;
			PlaneProfile box = ppOut;
			ppOut.shrink(-U(2)); // blow up
			ppOut.subtractProfile(box);
			PlaneProfile ppMergeShape = ppShape;
			ppMergeShape.shrink(-U(1));
			ppMergeShape.subtractProfile(ppOut);
			
			// HSB-23562
//			ppMergeShape.shrink(U(1));
			{ 
				// make sure it does not go out of the edge
				PlaneProfile ppEnvelope(cs);
				ppEnvelope.joinRing(plEnvelope,_kAdd);
				ppEnvelope.unionWith(ppShape);
				ppEnvelope.shrink(-U(10));
				ppEnvelope.shrink(U(10));
				ppEnvelope.shrink(U(10));
				ppEnvelope.shrink(-U(10));
				// keep whats inside
				ppMergeShape.intersectWith(ppEnvelope);
			}
			rings = ppMergeShape.allRings();
			if (rings.length()>0)
				ring = rings.first();
		}
		
		if (_Map.hasDouble("Radius")) // if the opening has been offseted by a cleanup radius the ring to be aded needs to be bigger
		{ 
			double dPrevRadius = _Map.getDouble("Radius");
			if (dPrevRadius<0)
			{ 
				PlaneProfile pp = ppShape;
				pp.shrink(dPrevRadius);
				pp.intersectWith(ppSipBox);
				rings = pp.allRings();
				if (rings.length()>0)
					ring = rings.first();				
			}
		}
	// the instance has been moved, the ring to be added needs to be transformed to te previous location
		if (!vecRefMove.bIsZeroLength())
		{
			ring.transformBy(-vecRefMove);
			if (bDebug)
			{ 
				//reportNotice("\n"+_ThisInst.handle()+ " ln1036 has been moved by " + vecRefMove.length()+"  in loop " + _kExecutionLoopCount);
				EntPLine epl;epl.dbCreate(ring);epl.setColor(2);
			}
		}
	
	// add the ring to remove the existing opening
		if (bDebug)
		{ 
			//reportNotice("\n"+_ThisInst.handle()+ " ln1051 adds a ring to remove opening at " +ring.ptStart()+"  in loop " + _kExecutionLoopCount);
			EntPLine epl;epl.dbCreate(ring);epl.setColor(4);
		}
		// HSB-23562
		// when closing the ring for doors make sure 
		// it is extended but not at edges. Make sure Operning is closed
		PLine plRing=ring;
		if (bIsDoor)
		{ 
			PlaneProfile ppRing(ring);
			ppRing.shrink(-U(1));
			PlaneProfile ppEnvelope(cs);
			ppEnvelope.joinRing(plEnvelope,_kAdd);
//			ppEnvelope=sip.envelopeBody(true,true).shadowProfile(Plane(cs.ptOrg(),cs.vecZ()));
			ppEnvelope.joinRing(ring,_kAdd);
			ppEnvelope.shrink(-U(5));
			ppEnvelope.shrink(U(5));
			ppEnvelope.shrink(U(5));
			ppEnvelope.shrink(-U(5));
			ppRing.intersectWith(ppEnvelope);
			PLine plsRing[]=ppRing.allRings(true,false);
			if(plsRing.length()==1)
			{ 
				plRing=plsRing[0];
			}
		}
		Sip sips[]= sip.addRing(plRing);
//		Sip sips[]= sip.addRing(ring);
	}
//End remove opening on creation//endregion 
		
//End Part #2//endregion 

//region As Opening or pocket #3
	PlaneProfile ppShapeOpening = ppShape;
	if(bIsOpening || bIsExtrusion || bIsHouse || bIsMortise)	
	{ 
		PlaneProfile ppOpening = ppShape;
		PLine plOpening = plShape;
	// stretch by radius to any free edge
		if (bIsDoor && abs(dRadius)>dEps)
		{ 
			double dStretch = abs(dRadius)*(dRadius<2?2:1);
			Point3d ptMid = ppShapeOpening.ptMid();
			Point3d pts[] = ppShapeOpening.getGripEdgeMidPoints();
			for (int i=0;i<pts.length();i++) 
			{ 
				if (ppSipBox.pointInProfile(pts[i])==_kPointOnRing)
				{
					Vector3d vecDir = pts[i]-ptMid; vecDir.normalize();
					vecDir.vis(pts[i], 4);
					ppShapeOpening.moveGripEdgeMidPointAt(i, vecDir * dStretch);
				}
			}//next i
		}
		
		
	//Add rounding by radius
		if (abs(dRadius)>0 && ppShapeOpening.allRings(true, false).length()>0)
		{ 
			PLine rings[] = ppShapeOpening.allRings(true, false);
			PLine plTool= rings.first();
	
			Map mapIO;	
			mapIO.setPLine("plContour",plTool);
			mapIO.setDouble("radius",dRadius); // a negative radius will create cleanup corner shape, positive will round
			mapIO.setVector3d("vecX",vecX);
			mapIO.setVector3d("vecY",vecY);
			mapIO.setVector3d("vecZ",vecZ);
			
			TslInst().callMapIO(scriptName(), mapIO);
			PLine plCleanUp = mapIO.getPLine("plContour");		
			
			if (plCleanUp.area()>pow(dEps,2))
			{ 
				//plCleanUp.vis(bIsDoor?4:2);
				ppShapeOpening.removeAllRings();
				ppShapeOpening.joinRing(plCleanUp, _kAdd);
				plOpening = plCleanUp;
			}
		}
		if (dRadius>0)ppShapeOpening.intersectWith(ppShape);
		if (abs(dRadius)>dEps)
		{
			ppShapeOpening.intersectWith(ppSipBox);
			PLine rings[] = ppShapeOpening.allRings(true, false);
			if (rings.length() > 0)plOpening = rings.first();
		}
		if (bDebug)ppShapeOpening.vis(6);	
		
	// opening	
		if (bAddRing && bIsOpening)
		{
			sip.addOpening(plOpening, false);
			//reportNotice("\n"+ _ThisInst.handle() + " ln1137 adds an opening ring at " +plOpening.ptStart()+ " in loop " + _kExecutionLoopCount);
		}	
	// extrusion
		else if (bIsExtrusion)
		{ 
		// collect tools
			double diameters[0];
			double lengths[0];
			int indices[0];
			String names[0];
			
			String k;
			for (int i=0;i<mapTools.length();i++) 
			{ 
				Map m= mapTools.getMap(i);
				double diameter, dL;
				int index;
				String name;
				k = "Diameter"; if (m.hasDouble(k))diameter=m.getDouble(k);else { continue;}
				k = "Length"; if (m.hasDouble(k))dL=m.getDouble(k);else { continue;}
				k = "ToolIndex"; if (m.hasInt(k))index=m.getInt(k);else { continue;}
				k = "Name"; if (m.hasString(k))name=m.getString(k);else { continue;}
				
			// ignore tools not matching given radius
				if (dRadius!=0 && abs(dRadius)<diameter*.5){ continue;}
			// ignore tools if length is not matching given panel thickness
				if (dZ>dL){ continue;}

				diameters.append(diameter);
				lengths.append(dL);
				indices.append(index);
				names.append(name);		
			}//next i
			
			plOpening.vis(2);
			PLine plTool= plOpening;
			plTool.projectPointsToPlane(pnFace, plTool.coordSys().vecZ());
			plTool.convertToLineApprox(dEps);
			if (bDebug)plTool.vis(4);
			
			// extend the ring on the outside of the edge 
			// to make sure nothing remains
			PlaneProfile ppEnvelope(cs);
			ppEnvelope.joinRing(plEnvelope,_kAdd);
//			ppEnvelope=sip.envelopeBody(true,true).shadowProfile(Plane(cs.ptOrg(),cs.vecZ()));
//			HSB-23562
			PLine ringExtend=extendPlOutsidePp(plTool,ppEnvelope);
//			FreeProfile fp(plTool, _kLeft);
			FreeProfile fp(ringExtend, ringExtend.vertexPoints(true));
			//
			fp.setDepth(dZT);
			fp.setMachinePathOnly(false);
			
			int nTool = 0;
			if (diameters.length()>0) // automatically picks first in list
			{ 
				fp.setSolidMillDiameter(diameters[nTool]);
				fp.setCncMode(indices[nTool]);
			}
			
			if (bDebug)
			{
				fp.cuttingBody().vis(4);
			}
			fp.addMeToGenBeamsIntersect(_Sip);
			
			if (bDebug)
			{ 
				Display dp(1);
				dp.textHeight(U(100));
				dp.draw(plTool.area() / U(1000) / U(1000), _Pt0, _XW, _YW, 1, 0);
				dp.draw(PlaneProfile(plTool), _kDrawFilled, 60);				
			}
		}
	//region Housing Tool
		else if (bIsHouse)
		{ 	
			Vector3d vecXT = vecX;
			Vector3d vecZT = -vecFace;
			Vector3d vecYT = vecXT.crossProduct(-vecZT);
			
			Point3d pt = ptRef;
			pt += vecZ * vecZ.dotProduct(ptFace - pt);
			
			double dx = ppShape.dX(), dy = ppShape.dY(), dz = dZT;
			if (dx>dEps && dy>dEps && dz>dEps)
			{ 
				House hs(pt, vecXT, vecYT, vecZT, dx, dy, dz, 0, 0, 1);
				hs.setEndType(_kFemaleSide);
				hs.setRoundType(_kNotRound);
				if (bDebug)hs.cuttingBody().vis(42);
				hs.addMeToGenBeamsIntersect(_Sip);
			
				if (nt>0)
					ppShapeTool.unionWith(hs.cuttingBody().shadowProfile(pnFace));			
			}

			
		}//endregion 
	//region Housing Tool
		else if (bIsMortise)
		{ 	
			Vector3d vecXT = vecX;
			Vector3d vecZT = -vecFace;
			Vector3d vecYT = vecXT.crossProduct(-vecZT);
			
			Point3d pt = ptRef;
			pt += vecZ * vecZ.dotProduct(ptFace - pt);

			double dx = ppShape.dX(), dy = ppShape.dY(), dz = dZT;
			if (dx > dEps && dy > dEps && dz > dEps)
			{
				
				Mortise ms(pt, vecXT, vecYT, vecZT, dx, dy, dz, 0, 0, 1);
				ms.setEndType(_kFemaleSide);
				if (abs(dRadius) > dEps)
				{
					ms.setExplicitRadius(dRadius);
					ms.setRoundType(_kExplicitRadius);
				}
				else
					ms.setRoundType(_kNotRound);
				if (bDebug)ms.cuttingBody().vis(42);
				ms.addMeToGenBeamsIntersect(_Sip);
				
				if (nt > 0)
					ppShapeTool.unionWith(ms.cuttingBody().shadowProfile(pnFace));
				
			}
		}//endregion 		
		
	}
//endregion 

//region Mid or Edge Tooling
	else
	{ 
		Point3d ptsShape[]=plShape.vertexPoints(false);
		PlaneProfile ppOpening = ppSipBox;
		if (bHasSupport)ppOpening.shrink(dSupportWidth);
		
	//region Add rounding by radius
		if (abs(dRadius)>0 &&  ppOpening.allRings(true, false).length()>0)
		{ 
			PLine rings[] = ppOpening.allRings(true, false);
			PLine plTool= rings.first();
	
			Map mapIO;	
			mapIO.setPLine("plContour",plTool);
			mapIO.setDouble("radius",dRadius); // a negative radius will create cleanup corner shape, positive will round
			mapIO.setVector3d("vecX",vecX);
			mapIO.setVector3d("vecY",vecY);
			mapIO.setVector3d("vecZ",vecZ);
			
			TslInst().callMapIO(scriptName(), mapIO);
			PLine plCleanUp = mapIO.getPLine("plContour");		
			
			if (plCleanUp.area()>pow(dEps,2))
			{ 
				plCleanUp.vis(2);
				ppOpening.removeAllRings();
				ppOpening.joinRing(plCleanUp, _kAdd);
			}
		}
		ppOpening.intersectWith(ppShape);		//ppOpening.vis(161);
	//End Add rounding by radius//endregion 	
	
		
	// Support: add ring as opening on creation or modifying width property
		if (bHasSupport && !bIsOpening)
		{
			
			// add ring as opening on creation or modifying width property	
			if (bAddRing)
			{
				PLine rings[] = ppOpening.allRings(true, false);
				for (int r = 0; r < rings.length(); r++)
				{	
					//reportNotice("\n"+ _ThisInst.handle() + " adds ring at " +rings[r].ptStart()+" in loop " + _kExecutionLoopCount);
					sip.addOpening(rings[r], false);
				}//next r
			}
		}
		
		//region Door with edge slot/beamcut)	
		Point3d ptsOn[0];
		Vector3d vecOns[0]; // the vecXS of this tool
		if (bIsDoor && dLengthEdgeCut>dEps && dWidth>0)
		{ 
		//region Find vertices on bounding box of panel
			ppSipBox.vis(3)	;	
			for (int i=0;i<ptsShape.length()-1;i++)
			{
				int bIsOn = ppSipBox.pointInProfile(ptsShape[i]) == _kPointOnRing;
				if (!bIsOn)
				{ 
					Point3d pt = ptsShape[i];
					pt += vecZ * vecZ.dotProduct(ptFace - pt);
					Point3d pt2 = ppSipBox.closestPointTo(pt);
					double d = (pt2 - pt).length();
					if (d < 2*dEps)bIsOn = true;
					
					pt.vis(bIsOn);
				}
				if (bIsOn)
				{
					//ptsShape[i].vis(3);
					ptsOn.append(ptsShape[i]);
				}
			}
			
			// two vertices are expected, remove any additional
			if (ptsOn.length()>2)
			{ 
				Point3d ptsE[] = plSipBox.vertexPoints(true);
				for (int i=ptsOn.length()-1; i>=0 ; i--) 
				{ 
					Point3d pt = ptsOn[i];
					for (int j=0;j<ptsE.length();j++) 
					{ 
						if (Vector3d(ptsE[j]-pt).length()<dEps)
						{
							ptsOn.removeAt(i);
							break; 
						}	 
					}//next i
					if (ptsOn.length() == 2)break;
				}//next i
			}				
		//End Find vertices on bounding box of panel
		//endregion 
			
			for (int i = 0; i < ptsOn.length(); i++)
			{
				Point3d pt = ptsOn[i];
				Vector3d vecTan = plSipBox.getTangentAtPoint(pt);//vecTan.vis(pt, 2);
				Vector3d vecNormal = vecTan.crossProduct(-vecZ);vecNormal.normalize();
				if (ppSipBox.pointInProfile(pt + vecNormal * dEps) != _kPointOutsideProfile)
					vecNormal *= -1;
				vecNormal.vis(pt, 6);
				
				// align tool direction with opening (considering trapezoid shapes)
				double distAt = plShape.getDistAtPoint(pt);
				Point3d ptA = plShape.getPointAtDist(distAt < dEps ? plShape.length() - dEps : distAt - dEps);
				Point3d ptB = plShape.getPointAtDist(distAt < plShape.length() ? distAt + dEps : dEps);			
				Point3d pt2 =ppSipBox.pointInProfile(ptA) == _kPointOnRing ? ptB : ptA;//pt2.vis(2); //ptA.vis(1);			ptB.vis(2);
				
				Vector3d vecXS = pt - pt2; vecXS.normalize();	vecXS.vis(pt, 1);	
				vecOns.append(vecXS);
				Vector3d vecYS = vecXS.crossProduct(vecFace);	//vecYS.vis(pt, 3);				
				int nSide = vecYS.dotProduct(_Pt0 - pt) < 0 ?- 1 : 1;
				pt += vecZ * vecZ.dotProduct(ptFace - pt);
			// Slot	
				if (dWidth < U(20))
				{
					Slot tool(pt, vecXS, vecYS, - vecFace, 2*dLengthEdgeCut, dWidth, dZT, 0 ,nSide, 1);
					tool.cuttingBody().vis(3);
					sip.addTool(tool);	
				}
			// Beamcut	
				else
				{
					BeamCut tool(pt, vecXS, vecYS, - vecFace, 2*dLengthEdgeCut, dWidth, dZT, 0 ,nSide, 1);
					tool.cuttingBody().vis(4);
					sip.addTool(tool);	
				}	
			}//next i
		//End Support with edge slot/beamcut)//endregion 	
		}
	
	// default slot or beamcut tools
		if (!bHasSupport && dWidth>0)
		{ 
			double radius = abs(dRadius);
		
		// collect tools if strategy corner tool with radius
			double diameters[0];
			double lengths[0];
			int indices[0];
			String names[0];
			
			if (nStrategy == 1 && radius>dEps)
			{ 
				String k;
				for (int i=0;i<mapTools.length();i++) 
				{ 
					Map m= mapTools.getMap(i);
					double diameter, dL;
					int index;
					String name;
					k = "Diameter"; if (m.hasDouble(k))diameter=m.getDouble(k);else { continue;}
					k = "Length"; if (m.hasDouble(k))dL=m.getDouble(k);else { continue;}
					k = "ToolIndex"; if (m.hasInt(k))index=m.getInt(k);else { continue;}
					k = "Name"; if (m.hasString(k))name=m.getString(k);else { continue;}
					
				// ignore tools not matching given radius
					if (dRadius!=0 && abs(dRadius)<diameter*.5){ continue;}
				// ignore tools if length is not matching given panel thickness
					if (dZ>dL){ continue;}
	
					diameters.append(diameter);
					lengths.append(dL);
					indices.append(index);
					names.append(name);		
				}//next i				
			}
			
		// get free direction of door alike
			Vector3d vecFree;
			if (bIsDoor)
			{ 
				Vector3d vecXD = vecX *(dEps+ .5 * ppShape.dX());
				Vector3d vecYD = vecY *(dEps+ .5 * ppShape.dY());
				Vector3d vecs[] = { vecXD, vecYD, - vecXD, - vecYD};
				for (int i=0;i<vecs.length();i++) 
				{ 
					Point3d pt = ppShape.ptMid() + vecs[i]; pt.vis(6);
					if (ppZ.pointInProfile(pt)==_kPointOutsideProfile)
					{ 
						vecFree = vecs[i];
						vecFree.normalize();
						vecFree.vis(pt, i);
						break;
					}					 
				}//next i	
			}

			
			for (int i=0;i<ptsShape.length()-1;i++) 
			{ 
				Point3d pt1 = ptsShape[i]; 
				Point3d pt2 = ptsShape[i+1];
				Vector3d vecXS = pt2 - pt1;
				double dX = vecXS.length();
				vecXS.normalize();
				Vector3d vecYS = vecXS.crossProduct(-vecFace);
				Point3d ptMid = (pt1 + pt2) * .5;
				if (ppShape.pointInProfile(ptMid+vecYS*dEps)!=_kPointOutsideProfile)
					vecYS *= -1;
				//vecYS.vis(ptMid,3);	

				int bFreeDir = !vecFree.bIsZeroLength() && vecYS.isCodirectionalTo(vecFree);// HSB-19654 vecFree.dotProduct(pt1-ppShape.ptMid())>0;
				//vecYS.vis(pt1, bFreeDir);


			// do not add any tool on the edge if in door mode
				if (bFreeDir && nStrategy == 1)
				{ 
					vecYS.vis(ptMid, bFreeDir);
					continue;
				}
				if (nStrategy==0 && bIsDoor && ppSipBox.pointInProfile(ptMid)==_kPointOnRing)
				{ 
					continue;
				}
				
				double dOffset = vecXS.isParallelTo(vecX) ? dXOffset : dYOffset;
				
			// check for potential edge cut
				if (bIsDoor && nStrategy==0 && dOffset<=0)
				{ 
					for (int j=0;j<ptsOn.length();j++) 
					{ 
						Point3d pt = ptsOn[j]; 
						Vector3d vecOn = vecOns[j];
						if (vecXS.isParallelTo(vecOn) && abs(vecYS.dotProduct(pt-ptMid))<dEps)
						{ 
							double dOffset2 = vecXS.isParallelTo(vecX) ? dYOffset : dXOffset;
							dX-=dOffset2;
							ptMid -= vecOn * .5*dOffset2;
							break;
						}
					}//next j				
				}
	
				Body bd;
				if (nStrategy == 0 && dX > 2 * dOffset && dOffset>0)//mid offset
				{	
					if (dWidth < U(20))
					{
						Slot tool(ptMid, vecXS, vecYS, - vecFace, dX - 2 * dOffset, dWidth, dZT, 0 ,- 1, 1);
						bd = tool.cuttingBody();
						sip.addTool(tool);	
					}
					else
					{
						BeamCut tool(ptMid, vecXS, vecYS, - vecFace, dX - 2 * dOffset, dWidth, dZT, 0 ,- 1, 1);
						bd = tool.cuttingBody();
						sip.addTool(tool);	
					}
					ppShapeTool.unionWith(bd.shadowProfile(pnFace));
					
				// publish tool dims
					{ 
						ptToolDims.append(ptMid-vecXS*.5*(dX - 2 * dOffset));
						ptToolDims.append(ptMid+vecXS*.5*(dX - 2 * dOffset)-vecYS*dWidth);						
					}					
					
				}
				else if (nStrategy == 1 && dX -2 * dOffset>dWidth && dOffset>0)//corner offset
				{
					if (dWidth < U(20))
					{
						Slot tool(pt1, vecXS, vecYS, - vecFace, dOffset, dWidth, dZT, 1 ,- 1, 1);
						bd = tool.cuttingBody();
						//bd.vis(6);
						ppShapeTool.unionWith(bd.shadowProfile(pnFace));
						sip.addTool(tool);
					
						Slot tool2(pt2, vecXS, vecYS, - vecFace, dOffset, dWidth, dZT, -1 ,- 1, 1);
						bd = tool2.cuttingBody();
						//bd.vis(4);
						ppShapeTool.unionWith(bd.shadowProfile(pnFace));												
						sip.addTool(tool2);
						
					}
					else if (radius>dEps && radius<dXOffset && radius<dYOffset)
					{ 

						double d1 = plShape.getDistAtPoint(pt1);
						double da = d1 <= dEps ? plShape.length() - dEps : d1 - dEps;
						Point3d pta = plShape.getPointAtDist(da);
						Vector3d vecA = pta - pt1; vecA.normalize();
						pta = pt1 + vecA * (vecA.isParallelTo(vecX)?dXOffset:dYOffset);
						pta.vis(3);
						
						double db = abs(d1-plShape.length())<dEps ? dEps:d1+dEps;
						Point3d ptb = plShape.getPointAtDist(db);
						Vector3d vecB = ptb - pt1; vecB.normalize();
						ptb = pt1 + vecB * (vecB.isParallelTo(vecX)?dXOffset:dYOffset);
						
						Vector3d vecM = vecA + vecB; vecM.normalize();
						
						PLine plTool(vecFace);
						plTool.addVertex(pta);
						plTool.addVertex(pt1);
						plTool.addVertex(ptb);


						PLine plShapeTool = plTool;
						
						if (dRadius>0)
						{ 
							plTool.offset(-dRadius, false);plTool.vis(12);
							plTool.offset(dRadius, true);	plTool.vis(1);						
						}
						else
						{ 
							PLine c;
							c.createCircle(pt1 + vecM * radius, vecFace, radius); //c.vis(1);
							Point3d pts[] = c.intersectPLine(plTool);
							
							if (pts.length()>1)
							{ 
								Vector3d vec = ptb - pta;
								pts = Line(_Pt0, vec).orderPoints(pts, dEps);
								if (pts.length()>1)
								{ 
									plTool = PLine(vecFace);
									plTool.addVertex(pta);
									plTool.addVertex(pts.first());
									plTool.addVertex(pts.last(), pt1);
									plTool.addVertex(ptb);
									
									//plTool.close();
								}
							}
							//plTool.projectPointsToPlane(pnFace, vecFace);
							//plTool.offset(U(3), false);

						}
						//plTool.projectPointsToPlane(pnFace, vecFace);
						//plTool.transformBy(-vecFace * dZT);
						
						plTool.vis(1);
						plTool.convertToLineApprox(dEps);
											
						plShapeTool.offset(nFace*dWidth, false);
						plShapeTool.reverse();			
						plShapeTool.append(plTool);
						plShapeTool.reverse();	
						plShapeTool.close();			plShapeTool.vis(2);			
						
						
						FreeProfile fp(plTool, nFace==-1?_kRight:_kLeft);
						

						int nTool = 0;
						if (diameters.length()>0) // automatically picks first in list
						{ 
						// the width is greater than the tool
							if (dWidth>diameters[nTool])
							{
								fp=FreeProfile(plTool, nFace==-1?_kRight:_kLeft);
								fp.setMachinePathOnly(false);
								fp.setSolidMillDiameter(dWidth);
							}
							else
								fp.setSolidMillDiameter(diameters[nTool]);
							fp.setCncMode(indices[nTool]);
							
						}		
						else
							fp.setSolidMillDiameter(radius);
						fp.setDepth(dZT);	
						if (!bDebug)
							fp.addMeToGenBeamsIntersect(_Sip);
						else
							fp.cuttingBody().vis(4);
							
							

						ppShapeTool.joinRing(plShapeTool, _kAdd);
						
						
						
					}					
					else
					{
						BeamCut tool(pt1, vecXS, vecYS, - vecFace, dOffset, dWidth, dZT, 1 ,- 1, 1);
						sip.addTool(tool);
						bd = tool.cuttingBody();	//bd.vis(1);
						ppShapeTool.unionWith(bd.shadowProfile(pnFace));
						
						BeamCut tool2(pt2, vecXS, vecYS, - vecFace, dOffset, dWidth, dZT, -1 ,- 1, 1);
						sip.addTool(tool2);	
						bd = tool2.cuttingBody();	//bd.vis(2);
						ppShapeTool.unionWith(bd.shadowProfile(pnFace));
					}
					
				// publish tool dims
					{ 
						ptToolDims.append(pt1);
						ptToolDims.append(pt1+vecXS*dOffset-vecYS*dWidth);
						ptToolDims.append(pt2);
						ptToolDims.append(pt2-vecXS*dOffset-vecYS*dWidth);						
					}
					
				}		
				
			// Append cleanup drills for a negative radius	
				if (nStrategy == 1 && dRadius<0 && (dXOffset<=dEps || dXOffset<=dEps || dWidth < U(20)))
				{ 
					double d1 = plShape.getDistAtPoint(pt1);
					double da = d1 <= dEps ? plShape.length() - dEps : d1 - dEps;
					Point3d pta = plShape.getPointAtDist(da);
					Vector3d vecA = pta - pt1; vecA.normalize();
					pta = pt1 + vecA * (vecA.isParallelTo(vecX)?dXOffset:dYOffset);
					pta.vis(3);
					
					double db = abs(d1-plShape.length())<dEps ? dEps:d1+dEps;
					Point3d ptb = plShape.getPointAtDist(db);
					Vector3d vecB = ptb - pt1; vecB.normalize();
					ptb = pt1 + vecB * (vecB.isParallelTo(vecX)?dXOffset:dYOffset);
					
					Vector3d vecM = vecA + vecB; vecM.normalize();
					
					Drill dr(pt1 + vecM * radius, -vecFace, dZT, radius);
					dr.addMeToGenBeamsIntersect(_Sip);
					
					PLine c;
					c.createCircle(pt1 + vecM * radius, vecFace, radius);
					c.convertToLineApprox(dEps);
					ppShapeTool.joinRing(c, _kAdd);
					
				}
			}//next i
			
					
		}
		
	}	
	//ppShapeTool.vis(3);
//	for (int i=0;i<ptToolDims.length();i++) 
//	{ 
//		ptToolDims[i].vis(2); 		 
//	}//next i
	
//End Tooling//endregion 

//region Formatting
	String sVariables[]=_ThisInst.formatObjectVariables();
	Map mapAdditionals;	
	{ 
		String k;
		k = "Area";
		if (sVariables.findNoCase(k,-1)<0)
		{
			mapAdditionals.setDouble(k, ppShapeOpening.area(), _kArea);
			sVariables.append(k);
		}
	}
	sFormat.setDefinesFormatting(_ThisInst, mapAdditionals); // HSB-15403
//endregion

//region Display and mapRequests
	Display dp(nc);
	if (_LineTypes.findNoCase(sLineType,-1)>-1)		
		dp.lineType(sLineType, dLineTypeScale);
	if (nt>0)
		dp.draw(ppShapeTool,_kDrawFilled, nt);//ppShapeOpening	
	dp.draw(ppShapeOpening);
	if (_DimStyles.findNoCase(sDimStyle, - 1) >- 1)dp.dimStyle(sDimStyle);
	if (dTextHeight>0)dp.textHeight(dTextHeight);

	Map mapRequests;
	double dYAnno = dTextHeight;  // carries the height of the text which will be displayed (reused for cloning)
	if (sFormat.length()>0)
	{ 
		
		String text = _ThisInst.formatObject(sFormat, mapAdditionals);
		
		if (_PtG.length() < 1)_PtG.append(_Pt0);
		Point3d pt = _PtG[0];
		
		if (text.length()>0)
		{ 
			if (dTextHeight>=0)
			{
				dp.color(ncText);
				dp.draw(text, pt, vecX, vecY, 0, 0,_kDevice); // hide if textheight < 0
				
				dYAnno = +dp.textHeightForStyle(text, sDimStyle, dTextHeight);
			}

			Map mapRequest;
			mapRequest.setInt("Color", ncText);
			mapRequest.setVector3d("AllowedView", vecZ);
			mapRequest.setInt("AlsoReverseDirection", true);									
			mapRequest.setString("text", text);
			mapRequest.setString("stereotype", sStereotype);
			mapRequest.setPoint3d("ptLocation", _PtG[0]);	
			mapRequest.setDouble("dXFlag",  0);
			mapRequest.setDouble("dYFlag",  0);
			mapRequests.appendMap("DimRequest",mapRequest);			
		}		
		else
			_PtG.setLength(0);
		
		
	}

	{ 
		Map mapRequest;
		mapRequest.setInt("Color", nc);
		mapRequest.setVector3d("AllowedView", vecZ);
		mapRequest.setInt("AlsoReverseDirection", true);									
		mapRequest.setPlaneProfile("PlaneProfile", ppShape);	
		mapRequest.setString("lineType", "Dashed");	
		mapRequest.setDouble("LineTypeScale",  U(10));	
		mapRequests.appendMap("DimRequest",mapRequest);			
	}

// add dimension requests	
	if (bIsActive)
	{ 
		Point3d ptsDim[] = ppShape.getGripVertexPoints();
		if (bAddToolDim)ptsDim.append(ptToolDims);//HSB-13112
		
		
		
		Point3d ptsRef[] ={ segBox.ptStart(), segBox.ptEnd()};
		for (int xy=0;xy<2;xy++) 
		{ 
			Point3d _ptsDim[0];
			Point3d _ptsRef[0];
			
			Vector3d vecDir = (xy==0?vecX:vecY);
			Vector3d vecPerp = (xy==0?vecY:vecX);
			Line ln(_Pt0,vecDir) ;//ln.vis(2);
			_ptsDim = ln.orderPoints(ln.projectPoints(ptsDim), dEps);
			_ptsRef = ln.orderPoints(ln.projectPoints(ptsRef), dEps);
			
			Map mapRequest;
			//mapRequest.setString("ParentUID",  _ThisInst.handle());
			mapRequest.setInt("Color", nc);
			mapRequest.setVector3d("vecDimLineDir", vecDir);
			mapRequest.setVector3d("vecPerpDimLineDir", vecPerp);
			mapRequest.setVector3d("AllowedView", vecZ);
			mapRequest.setInt("AlsoReverseDirection", true);									
			mapRequest.setPoint3dArray("Node[]", _ptsDim);
			mapRequest.setPoint3dArray("Ref[]", _ptsRef);
			mapRequest.setString("stereotype",  sStereotype);	
			mapRequest.setString("DimRequestPoint", "DimRequestPoint");
			mapRequests.appendMap("DimRequest",mapRequest);	
			 
		}//next xy
		
	}


// publish dim requests
	_Map.setMap("DimRequest[]", mapRequests);	
	_Map.setDouble("SupportWidth", dSupportWidth); // store current support width to allow changes of it
	_Map.setDouble("Radius", dRadius); // store current support width to allow changes of it
	_Map.setVector3d("vecRef", ptRef - sip.ptRef());
	_Map.setEntity("Me", _ThisInst);
	
//End Display//endregion 

//region Trigger
{
	// create TSL
	TslInst tslDialog;			Map mapTsl;
	GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };	
	
	//region Trigger CloneTool
		String sTriggerCloneTool = T("|Clone Tool|");
		addRecalcTrigger(_kContextRoot, sTriggerCloneTool);
		if (_bOnRecalc && _kExecuteKey==sTriggerCloneTool)
		{
			String k;
			k = "shape"; if (_Map.hasPlaneProfile(k))mapTsl.setPlaneProfile(k, _Map.getPlaneProfile(k));
			k = "isDoor"; if (_Map.hasInt(k))mapTsl.setInt(k, _Map.getInt(k));
			k = "vecRef"; if (_Map.hasVector3d(k))mapTsl.setVector3d(k, _Map.getVector3d(k));
			mapTsl.setInt(kCloning, true); // set is Cloning map to show all hidden properties
			dProps.append(dRadius);
			dProps.append(dXOffset);
			dProps.append(dYOffset);
			dProps.append(dWidth);
			dProps.append(dDepth);
			dProps.append(dLengthEdgeCut);
			dProps.append(dSupportWidth);

			sProps.append(sStrategy);
			sProps.append(sFace);
			sProps.append(sAreaFilter);
			sProps.append(sFormat);
			

			gbsTsl.append(sip);
			ptsTsl[0] += vecY * dYAnno;

			tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			
			if (tslDialog.bIsValid())
			{ 
				int bOk = tslDialog.showDialog();
				if (bOk)
				{ 
					Map m = tslDialog.map();
					m.removeAt(kCloning, true); // remove the unhiding of the properties
					tslDialog.setMap(m);
					
				// validate instance not be a 1:1 clone	
					int bPurge=true;
					for (int i=0;i<dProps.length();i++) 
					{ 
						if (dProps[i]!=tslDialog.propDouble(i))
						{
							bPurge=false;
							break;
						}			 
					}//next i
					for (int i=0;i<sProps.length();i++) 
					{ 
						if (sProps[i]!=tslDialog.propString(i))
						{
							bPurge=false;
							break;
						}			 
					}//next i			
		
					if (bPurge)
					{ 
						reportMessage(TN("|Tool not created, modify at least one property to create a valid tool|"));
						tslDialog.dbErase();
					}					
				}
				else
					tslDialog.dbErase();
				
				
			}

			setExecutionLoops(2);
			return;
		}//endregion	
	
	
	//region Trigger FlipSide
		String sTriggerFlipSide = T("|Flip Side|"); //HSB-15876
		addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
		if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
		{
			sFace.set(sFace == kFaceRef ? kFaceOpp:kFaceRef);
			setExecutionLoops(2);
			return;
		}//endregion	
	
	//region Trigger EditShape
		if (!bHasPLine)
		{ 
			String sTriggerEditShape = T("|Edit Shape|");
			addRecalcTrigger(_kContextRoot, sTriggerEditShape );
			if (_bOnRecalc && _kExecuteKey==sTriggerEditShape)
			{
				plShape.projectPointsToPlane(pnFace, vecZ);
				EntPLine epl;
				epl.dbCreate(plShape);
				epl.setColor(nc);
				if (epl.bIsValid())
				{ 
					_Entity.append(epl);
				}
				setExecutionLoops(2);
				return;
			}	
		}
	//endregion	

	//region Trigger ResetErase
	String sTriggerResetErase = T("|Reset + Erase|");
	addRecalcTrigger(_kContextRoot, sTriggerResetErase );
	int bReset = _bOnRecalc && _kExecuteKey == sTriggerResetErase;
	if ( !_bOnDbCreated && ppSipBox.pointInProfile(_Pt0) == _kPointOutsideProfile)
	{
		bReset = true;
	}
	if (bReset)
	{
		// remove the opening if door with supporting frame
		if (bIsDoor && dSupportWidth > 0)
		{
			PlaneProfile ppOut = ppSipBox;
			PlaneProfile box = ppOut;
			ppOut.shrink(-U(2)); //blow up
			ppOut.subtractProfile(box);
			
			ppShape.shrink(-U(1));
			ppShape.subtractProfile(ppOut);
			rings = ppShape.allRings();
			if (rings.length() > 0)
				_Sip = sip.addRing(rings.first());
		}
		
		// add the shape as opening
		sip.addOpening(plShape, true);
		eraseInstance();
		return;
	}//endregion

	//region AddToolDim
	String sTriggerAddToolDim =bAddToolDim?T("|Remove Tool Dimpoints from Shopdrawing|"):T("|Add Tool Dimpoints to Shopdrawing|");
	addRecalcTrigger(_kContextRoot, sTriggerAddToolDim);
	if (_bOnRecalc && _kExecuteKey==sTriggerAddToolDim)
	{
		bAddToolDim = bAddToolDim ? false : true;
		_Map.setInt("AddToolDim", bAddToolDim);		
		setExecutionLoops(2);
		return;
	}			
	//endregion 

	//region Trigger ConfigureDisplay
	String sTriggerConfigureDisplay = T("|Configure Display|");
	addRecalcTrigger(_kContextRoot, sTriggerConfigureDisplay );
	if (_bOnRecalc && _kExecuteKey == sTriggerConfigureDisplay)
	{
		// prepare dialog instance
		mapTsl.setInt("DialogMode", 1);
		if (nStrategy==3)
			sProps.append(T("|Extrusion|"));
		else if (nStrategy==4)
			sProps.append(T("|Housing Tool|"));	
		else if (nStrategy==5)
			sProps.append(T("|Mortise Tool|"));				
		else if (nStrategy==2)
			sProps.append((bIsDoor?T("|Door|"):T("|Opening|")));		
		else
			sProps.append(sStrategy+"_"+ (bIsDoor?T("|Door|"):T("|Opening|")));		
		
		sProps.append(sDimStyle); // Dimstyle
		dProps.append(dTextHeight);
		
		nProps.append(ncText); // color text
		nProps.append(nc); // color
		nProps.append(nt); // transparency
		
		
		sProps.append(_LineTypes.find(sLineType)>-1?sLineType:_LineTypes.first());
		dProps.append(dLineTypeScale);
		
		sProps.append(sStereotype.length()>0?sStereotype:"*");//Stereotype
		sProps.append(sNoYes.last());
		
		
		tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{
				String rule = tslDialog.propString(0);
			// get current config			
				String key = "Default";
				
				if (rule == T("|Opening|"))key = "Opening";
				else if (rule == T("|Door|"))key = "Door";
				else if (rule == T("|Extrusion|"))key = "Extrusion";
				else
				{ 
					for (int i=0;i<sStrategies.length();i++) 
					{ 	
						if (rule.find(sStrategies[i],0,false)>-1)
						{
							key = sStrategyKeys[i];
							//key = key +"_"+ (rule.find("_" + T("|Door|"),0, false)>-1 ? "Door" : "Opening");
							if (rule.find("_" + T("|Door|"), 0, false) >- 1)key = key + "_Door";
							else if (rule.find("_" + T("|Opening|"), 0, false) >- 1)key = key + "Opening";
							else if (rule.find("_" + T("|Extrusion|"), 0, false) >- 1)key = key + "Extrusion";
							else if (rule.find("_" + T("|Housing Tool|"), 0, false) >- 1)key = key + "House";
							else if (rule.find("_" + T("|Mortise Tool|"), 0, false) >- 1)key = key + "Mortise";
							break; 
						}	 
					}//next i					
				}

				Map map = mapSetting.getMap(key);				
								
			// annotation	
				sDimStyle = tslDialog.propString(1);
				dTextHeight = tslDialog.propDouble(0);
				ncText= tslDialog.propInt(0);
				
			// LineWork	
				int color= tslDialog.propInt(1);
				int transparency= tslDialog.propInt(2);
				
				String lineType = tslDialog.propString(2);
				double lineTypeScale = tslDialog.propDouble(1);
			
			// dimension
				String stereotype = tslDialog.propString(3);
				int bAddDim = sNoYes.find(tslDialog.propString(4),1);
				
			// annotation
				{ 
					Map m;
					m.setString("dimStyle", sDimStyle);
					m.setDouble("textHeight", dTextHeight);
					m.setInt("Color", ncText );
					map.setMap("Display", m);
				}
			// Linework
				{ 
					Map m;
					m.setDouble("LineTypeScale", lineTypeScale );
					m.setString("LineType", lineType );
					m.setInt("Color", color );
					m.setInt("Transparency", transparency );
					map.setMap("Linework", m);
				}	
			// dimension	
				{ 
					Map m;
					m.setInt("isActive", bAddDim);
					m.setString("stereotype", stereotype);
					map.setMap("Dimension", m);
				}
				mapSetting.setMap(key, map);

				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;
	}//endregion
}//endregion
		
//region Trigger PrintAllCommands
	String sTriggerPrintCommand2 = T("|Show all Commands for UI Creation|");
	addRecalcTrigger(_kContext, sTriggerPrintCommand2 );
	if (_bOnRecalc && _kExecuteKey==sTriggerPrintCommand2)
	{
		String text = TN("|You can create a toolbutton, a palette or a ribbon command using one of the following commands.|")+
			TN("|Copy the corresponding line starting with ^C^C below into the command property of the button definition|");	
		
		String command;
		
		command += TN("|Command to insert a new instance of the tool|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert \"hsbCLT-Opening\")) TSLCONTENT";
		
		command += TN("\n|Command to insert a new instance of the tool with no dialog using an existing catalog entry, i.e. 'ABC123'|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert \"hsbCLT-Opening\" \"ABC123\")) TSLCONTENT";

		command += TN("\n|Command to flip the face of the tool|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Flip Side|\") (_TM \"|Select tool|\"))) TSLCONTENT";
		
		command += TN("\n|Command to clone the tool and assign different parameters|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Clone Tool|\") (_TM \"|Select tool|\"))) TSLCONTENT";		

		command += TN("\n|Command to reset the opening shape and erase the tool|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Reset + Erase|\") (_TM \"|Select tool|\"))) TSLCONTENT";
		
		command += TN("\n|Command to edit the shape|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Edit Shape|\") (_TM \"|Select tool|\"))) TSLCONTENT";

		command += TN("\n|Command to edit the display settings, each strategy may have its own settings)|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Configure Display|\") (_TM \"|Select tool|\"))) TSLCONTENT";
		
		command += TN("\n|Command to additional points to be shown in shopdrawing|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Add Tool Dimpoints to Shopdrawing|\") (_TM \"|Select tool|\"))) TSLCONTENT";
		
		command += TN("\n|Command to remove potential additional points not to be shown in shopdrawing|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Remove Tool Dimpoints from Shopdrawing|\") (_TM \"|Select tool|\"))) TSLCONTENT";

		reportNotice(text +"\n\n"+ command);		
		setExecutionLoops(2);
		return;
	}//endregion	
	//reportNotice("\nEnd of exec " + _ThisInst.handle() + " in loop " + _kExecutionLoopCount);































#End
#BeginThumbnail
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
8_PLP``Z)B=,==@XY`````$E%3D2N0F""









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
        <int nm="BreakPoint" vl="1469" />
        <int nm="BreakPoint" vl="2386" />
        <int nm="BreakPoint" vl="2348" />
        <int nm="BreakPoint" vl="2273" />
        <int nm="BreakPoint" vl="1982" />
        <int nm="BreakPoint" vl="1969" />
        <int nm="BreakPoint" vl="115" />
        <int nm="BreakPoint" vl="167" />
        <int nm="BreakPoint" vl="209" />
        <int nm="BreakPoint" vl="1926" />
        <int nm="BreakPoint" vl="1741" />
        <int nm="BreakPoint" vl="168" />
        <int nm="BreakPoint" vl="174" />
        <int nm="BreakPoint" vl="208" />
        <int nm="BreakPoint" vl="210" />
        <int nm="BreakPoint" vl="1918" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23562: Fix when radius is applied" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="4/30/2025 2:43:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23562: Fix when closing door openings (make sure they get closed); Fix when freeprofiling the door openings (make sure nothing remains at the outter edge; Use the envelopBody with cuts when investigating outter contour for openings" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="4/11/2025 11:07:07 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23562: Fix when getting rings of openings" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="4/1/2025 4:34:50 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20579 new strategies 'House Tool' and 'Mortise Tool' have been added for rectangular opening shapes." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="2/27/2024 5:04:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19654 bugfix strategy 1 on doors " />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="8/1/2023 2:30:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16458 batch insert support added" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="9/9/2022 10:34:55 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15403 new commands to show UI commands and to clone tool, new corner tool behaviour and options" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="9/8/2022 11:12:36 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15876 new command flip side toggles reference and opposite side, doubleclick action changed to 'Flip Side'" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="6/30/2022 9:53:36 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15876 corner tool fixed when support used for door alike openings" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="6/28/2022 3:26:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13263 Tool image updated" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="11/16/2021 4:50:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13386: recalcNow the tsl" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="10/6/2021 2:24:41 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13112 new custom command to add tool dimensions to shopdrawing (requires sd_Opening to be part of ruleset definition)" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="9/9/2021 10:02:57 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12511 rafter cutouts also detected on gable alike shapes" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="7/28/2021 3:18:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12511 new strategy to convert openings into extrusion tools (pockets)" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="7/27/2021 3:30:54 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10539 new strategy to control openings" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="2/2/2021 6:13:18 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10531 negative radius supports cleanup shape" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="2/1/2021 9:03:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10531 new property radius" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="2/1/2021 5:37:28 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End