#Version 8
#BeginDescription
--For use on a static HSB Viewport in PS. Labels panel connections & Headers. Not intended
for use with built-up headers.

V0.40_5June2014__Added ability to select multiple labels to hide or rename
V0.35__17May2014__Revised edge detection logic & labeling
V0.30__15May2014__Added Property to suppress Edge labeling
V0.25_8May2014__Revisions to edge sorting to enable ElementRoof Functionality
V0.20_31March2014__Bugfix on labelling Trimmers & Kings
V0.19__Jan 13 2014__Added scriptname to the nothing display
V0.18_Dec 31 2013__Removed duplicated and blanks. Adds Wall number and sip style botom left
V0.17_Dec 19 2013__Will not show 0 quantities for trimmers and kings
V0.16_Nov 6 2013__Added grip points
V0.15_24February2012__Added labeling for King/Trimmer @ Openings
V0.10_ 23February2012__`Initial inception










V0.42 1/3/2024 Added customization options for title cc

V0.44 1/5/2024 Added Properties for control of text height, title color and spacing cc

V0.45 3/13/2024  setDependencyOnEntity(sp); cc

V0.47 3/14/2024 Made even more dependent, less performant  cc

0.49 5/2/2025 Bugfix on enabling grips cc
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 49
#KeyWords 
#BeginContents
/*
<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>

------For use on a static HSB Viewport in PS. Labels panel connections & Headers. Not intended
for use with built-up headers.

V0.10_ 23February2012__Initial inception

                                                       cc@hsb-cad.com
<>--<>--<>--<>--<>--<>--<>--<>_____  craigcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>


//######################################################################################
//############################ Documentation #########################################
<insert>
Primarily intended to be inserted by the user on PS Viewports
</insert>

<property name="xx">
- What are the important properties.
</ property >

<command name="xx">
- What are the custom commands.
</command>

<remark>
- What could make the tsl fail. 
- Is this an Element tsl that can be added to the list of auto attach tsls.
- What is the (internal) result of the tls: adds element/beam tools, changes properties of other entities,?
- Requirements and scope of applying this tsl (display configuration, styles, hatch, )
- Dependency on other entities (maps, properties, property sets, auto properties,?)
- Dependency on other software components (dlls, xml, catalogs, ?)
</remark>
//########################## End Documentation #########################################
//######################################################################################
*/

//######################################################################################
//############################ basics and props #########################################

// set the diameter of the 3 circles, shown during dragging
	Unit(1,"inch");
	setMarbleDiameter(U(0));
	
	PropString psDimStyle(0,_DimStyles,"Dimension Style");
	PropDouble pdLabelTextH(3, 0, "Label Text Height");
	PropDouble pdOffset(0, U(.2), "Connection Label Offset" ) ;
	PropDouble pdKingTrimOffset(1, 0, "King-Trimmer Offset" ) ;
	String stLabelChoices[] = { "Yes", "No"};
	PropString psLabelChoices(1, stLabelChoices, "Label All Edges");
	int iDoMinLabels = psLabelChoices == stLabelChoices[1];	
	PropDouble pdMaxReportD (2, U(6), "Max ReportDepth");
	
	String stContextOptions[] = { "Element", "Sip"};
	PropString psLine1Context(2, stContextOptions, "Title 1 Context");
	PropString psLine1Prefix(3, "Wall", "Title 1 Prefix");
	PropString psLine1Format(4, "@(ElementNumber)", "Title 1 Format");
	PropString psLine2Prefix(5, "Sip", "Title 2 Prefix");
	PropString psLine2Context(6, stContextOptions, "Title 1 Context", 1);
	PropString psLine2Format(7, "@(Style)", "Title 1 Format");
	PropInt piTitleColor(0, -1, "Title Color");
	PropDouble pdTitleTextH(4, 0, "Title Text Height");
	PropDouble pdTitleSpacing(5, 1, "Title Spacing Ratio");
	
	
		
	Display dp( -1 ) ;
	dp.dimStyle( psDimStyle) ;
	double dTextH = dp.textHeightForStyle("2x()", psDimStyle);
	if(pdLabelTextH>0)
	{ 
		dTextH = pdLabelTextH;
		dp.textHeight(pdLabelTextH);
	}
	
	Display dpTitle(piTitleColor);
	dpTitle.dimStyle(psDimStyle);
	double dTitleH = dpTitle.textHeightForStyle("Rq", psDimStyle);
	if(pdTitleTextH > 0)
	{ 
		dTitleH = pdTitleTextH;
		dpTitle.textHeight(dTitleH);
	}
	
	PLine plHandle ;
	plHandle.createCircle( _Pt0, _ZW, U(0) ) ;
	dp.draw(plHandle) ;
	
	if (_bOnInsert) 
	{
  		//_Pt0 = getPoint(T("Pick a point ")); // select point
		Viewport vp = getViewport(T("Select a viewport")); // select viewport
		_Viewport.append(vp);
		showDialogOnce() ;
		return;
	}

	if (_Viewport.length()==0)  // _Viewport array has some elements
	{
		eraseInstance() ;
		return;
	}
	Viewport vp = _Viewport[0] ;


	CoordSys ms2ps = vp.coordSys();
	CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
	

	
	Element el = vp.element();
	
	Wall w = (Wall)el;
	Sip sips[] = el.sip() ;
	Body bdSips[0] ;
	Beam bms[] = el.beam() ;

	int iDB2 = el.bIsValid() ;
//__Declare variables to be set via Wall or Roof routine later

	Vector3d vX ;
	Vector3d vY ;
	Vector3d vZ ;	
	CoordSys csEl ;
	Point3d ptElOrg ;
	double dScale = vp.dScale() ;
	double dTextHMS = dTextH/dScale;
	Vector3d vRightMS = _XW; vRightMS.transformBy(ps2ms);
	double dElW, dElH, dElL ;
	PLine plElEnv ;
	PlaneProfile ppElEnv ;
	Point3d ptFront, ptBack, ptElCen ;
	Point3d ptVPCen = vp.ptCenPS() ;
	Group gpEl = el.elementGroup() ;
	
	if( sips.length() == 0 )
	{
		Display dpHandle(-1) ;
		dpHandle.textHeight(U(.2) ) ;
		dpHandle.draw( "Nothing to Tag (" + scriptName() + ")", ptVPCen, _XW, _YW, 0, -4 ) ;
		return;
	}
	
	csEl = el.coordSys() ;
	vX = csEl.vecX() ;
	vY = csEl.vecY() ;
	vZ = csEl.vecZ() ;			
	ptElOrg = csEl.ptOrg() ;		
	dElW = sips[0].envelopeBody().lengthInDirection( vZ ) ;
	
	
	ptFront = ptElOrg ;
	ptBack = ptFront - vZ * dElW  ;	
	ptElCen = ptElOrg - vZ * dElW / 2;
	plElEnv = el.plEnvelope() ;	
	
	ptFront = ptElOrg ;
	ptBack = ptFront - vZ * dElW  ;	
	ptElCen = ptElOrg - vZ * dElW / 2;
	plElEnv = el.plEnvelope() ;	
	Plane pnFront ( ptFront, vZ ) ;

	
	ppElEnv = PlaneProfile( plElEnv ) ;
	LineSeg lsElEnv = ppElEnv.extentInDir( vY ) ;
	//__get height
	dElH = abs( vY.dotProduct( lsElEnv.ptStart() - lsElEnv.ptEnd() ) ) ;
	//__get length
	lsElEnv = ppElEnv.extentInDir( vX ) ;
	Point3d ptElStart = pnFront.closestPointTo(lsElEnv.ptStart());
	Point3d ptElEnd = pnFront.closestPointTo(lsElEnv.ptEnd());
	dElL = abs( vX.dotProduct(  ptElStart - ptElEnd ) ) ;	
	
	
	

	
//########################## End basics and props ############################################
//######################################################################################

//#####################################################################################
//######################### Gather & sort SipEdges ############################################### 
	
	//Collect display items
	String stMapKey = "mpDisplay"+el.number();
	Map mpDraw = _Map.getMap(stMapKey);
	
	String stResetDims = "Reset display data";
	String stHideDim = "Hide data";
	String stRenameDim = "Rename data";
	addRecalcTrigger(_kContextRoot,stResetDims);
	addRecalcTrigger(_kContextRoot,stHideDim);
	addRecalcTrigger(_kContextRoot,stRenameDim );
	
	if(_kNameLastChangedProp.left(4) == "_PtG" && _PtG.length() == mpDraw.length())
	{
		
		for(int i=0;i<mpDraw.length();i++)
		{
			Map mp=mpDraw.getMap(i);
			mp.setPoint3d("ptGrip",_PtG[i]);
			
			mpDraw.setMap(i,mp);
		}
		_Map.setMap(stMapKey,mpDraw);
	}
	
	if(_kExecuteKey == stHideDim)
	{
		Point3d pts[0];
		
		while (true)
		{
			PrPoint prp("Select points near the text to hide");
			if (prp.go() == _kOk)
			{
				pts.append(prp.value());
			}
			else
			{
				break;
			}
		}
		
		for (int m=0; m<pts.length(); m++)
		{
			Point3d pt = pts[m];
			int iClossest = -1;
			
			double dDist=U(0);
			for(int i=0;i<_PtG.length();i++)
			{
				double dd=(pt-_PtG[i]).length();
				
				if(i==0 || dd<dDist)
				{
					iClossest = i;
					dDist=dd;
				}
			}
			
			if(iClossest > -1)
			{
				Map mpReset = _Map.getMap(stMapKey);
				mpReset.setInt(iClossest + "\\bHideThis",1);
				
				_Map.setMap(stMapKey,mpReset);
				mpDraw = mpReset;
			}
		}
	}
	
	if(_kExecuteKey == stRenameDim)
	{
		Point3d pts[0];
		String stText = getString("New Text to be displayed");
		while (true)
		{
			PrPoint prp("Select points near the text to rename");
			if (prp.go() == _kOk)
			{
				pts.append(prp.value());
			}
			else
			{
				break;
			}
		}
		
		for (int m=0; m<pts.length(); m++)
		{
			Point3d pt = pts[m];
			int iClossest = -1;
			
			double dDist=U(0);
			for(int i=0;i<_PtG.length();i++)
			{
				double dd=(pt-_PtG[i]).length();
				
				if(i==0 || dd<dDist)
				{
					iClossest = i;
					dDist=dd;
				}
			}
			
			if(iClossest > -1)
			{				
				Map mpReset = _Map.getMap(stMapKey);
				mpReset.setString(iClossest + "\\stText",stText);
				
				_Map.setMap(stMapKey,mpReset);
				mpDraw = mpReset;
			}
		}
	}
	

		_Map.removeAt(stMapKey,1);
		mpDraw = Map();
		
		//__Store this data to not have duplicates
		double dVal = U(0.125);
		Point3d arPtExisting[0];
		String arStText[0];
		
		//String used at the end
//		String stLine1Text = "Wall (" + el.number() + ")";
//		String stLine2Text = sips[0].style();
//		
//		if(!w.bIsValid())stLine1Text = "Roof (" + el.number() + ")";
		Sip spSample = sips[0];

		String stLine1Text = psLine1Prefix;
		if(psLine1Context == stContextOptions[0])
		{ 
			stLine1Text += el.formatObject(psLine1Format);
		}
		else
		{ 
			stLine1Text += spSample.formatObject(psLine1Format);
		}
		
		String stLine2Text = psLine2Prefix;
		if(psLine2Context == stContextOptions[0])
		{ 
			stLine2Text += el.formatObject(psLine2Format);
		}
		else
		{ 
			stLine2Text += spSample.formatObject(psLine2Format);
		}
		
		
		//__Get sides of Openings, store points & lumber.
		Line lnX( ptElOrg, vX ) ;
		Line lnY( ptElOrg, vY ) ;
		Opening opAll[] = el.opening() ;
		Point3d ptsOpX[0], ptsOpY[0] ;
		Point3d ptsSipX[0], ptsSipY[0] ;
		Vector3d vLR[] = { vX, -vX } ;
		PlaneProfile ppOpAll[0];
		
		for( int i=0; i<opAll.length(); i++)
		{
			Opening op = opAll[i] ;
			PLine pl = op.plShape() ;
			PlaneProfile ppOp(pl);
			ppOp.shrink(- U(.25));
			ppOpAll.append(ppOp);
			
			Point3d ptsOp[] = pl.vertexPoints( true ) ;
			ptsOp = lnX.orderPoints( ptsOp ) ;
			ptsOpX.append( ptsOp[0] ) ;
			ptsOpX.append( ptsOp[ ptsOp.length() -1 ] ) ;
			ptsOp = lnY.orderPoints( ptsOp ) ;
			ptsOpY.append( ptsOp[0] ) ;
			ptsOpY.append( ptsOp[ ptsOp.length() -1 ] ) ;
			
			//__label trimmers & kings while in this loop
			Point3d ptSearch = op.coordSys().ptOrg() + (op.coordSys().vecZ())*U(2.5)+ vY*op.height()/2 + op.coordSys().vecX() ;
			Point3d ptLabel ;
			for( int k=0; k<vLR.length(); k++)
			{
				Vector3d vSearch = vLR[k] ;			
				Beam bmsThisSide[] = Beam().filterBeamsHalfLineIntersectSort(bms, ptSearch, vSearch) ;
				int iNumTrims, iNumKings ;
				double dStackW ;
				int iSafe = 0 ;
				while (iSafe < 10)
				{
					if( bmsThisSide.length()-1 < iSafe ) break;
					Beam bm = bmsThisSide[iSafe] ;
					if( iSafe == 0 )//__First beam, nothing to check
					{
						dStackW += bm.dD(vX) ;
						int iType = bm.type() ;
						if( iType == 21 || iType == 36 ) iNumTrims++;
						if( iType == 38 ) iNumKings++;
						iSafe++ ;
						ptLabel = bm.ptCen()  ;
						continue;
					}
					Beam bmLast = bmsThisSide[iSafe-1] ;
					double dWThis = bm.dD( vSearch ) ;
					double dWLast = bmLast.dD(vSearch) ;				
					double dCheck = (bm.ptCen() - bmLast.ptCen()).dotProduct( vSearch ) ;
					
					if( dCheck > (dWThis + dWLast)/2 + U(.01) ) break;				
				//__This beam must be in stack, update width & count				
					dStackW += dWThis ;
					int iType = bm.type() ;
					if( iType == 21 || iType == 36 ) iNumTrims++;
					if( iType == 38 ) iNumKings++;
					
					iSafe++ ;
					if ( iSafe > 100 ) reportError( "More than 100 loops" ) ;				
				}
				
				String  stLabel;//= "(" + iNumTrims + ") Trimmer (" + iNumKings + ") King" ;
				
				if(iNumTrims+iNumKings == 0)continue;
				
				if(iNumTrims > 0)
				{
					stLabel += String("(" + iNumTrims + ") Trimmer");
					if(iNumTrims > 1)stLabel+="s";
				}
				if(iNumKings > 0)
				{
					stLabel += String(" (" + iNumKings + ") King") ;
					if(iNumKings > 1)stLabel+="s";
				}
				
				
				ptLabel += vSearch * dStackW  ;
				ptLabel.transformBy( ms2ps ) ;
				vSearch.transformBy( ms2ps ) ; vSearch.normalize() ;
				ptLabel += vSearch * pdKingTrimOffset ;
				
				
				//Make sure there are no duplicates and the string contains something
				if(stLabel.length() == 0)continue;
				int bSkip=0;
				for(int d=0;d<arPtExisting.length();d++)
				{
					double dDist=(arPtExisting[d]-ptLabel).length();
					
					if(dDist<dVal && arStText[d] == stLabel)
					{
						bSkip = 1;
						break;
					}
				}
				if(bSkip)continue;	
				
				
				Map mp;
				mp.setString("stText",stLabel);
				mp.setPoint3d("ptGrip",ptLabel);
				mp.setVector3d("vx",_YW);
				mp.setVector3d("vy",-_XW);
				mp.setInt("iFlagX",0);
				mp.setInt("iFlagY",0);
				mpDraw.appendMap(mpDraw.length(),mp);
				arPtExisting.append(ptLabel);
				arStText.append(stLabel);
				//dp.draw(stLabel, ptLabel, _YW, - _XW, 0, 0 ) ;
			}
		}//__End loop through Openings
		
		//__Find unique panel intersections. Do not gather intersections @ opening sides.
		SipEdge seAll[0];
		String stPointsFound[0];
		Line lnEdgesFound[0];
		
		//__clear out any old entries, not sure if this is necessary or no
		_Sip.setLength(0);
		for( int i=0; i<sips.length(); i++) 
		{
			Sip sp = sips[i] ;
			_Sip.append(sp);
			setDependencyOnEntity(sp);
			
			//__get some end points to filter top & bottom edge of wall
			Body bdSipEnv = sp.envelopeBody(false, true);
			Point3d ptEnds[] = bdSipEnv.extremeVertices(vY);
			SipEdge ses[0];
			ses.append( sp.sipEdges() ) ;
			
			for (int k=0; k<ses.length(); k++)
			{
				SipEdge se = ses[k];
				Point3d ptSE = se.ptMid();
				if (se.dRecessDepth() > pdMaxReportD) continue;
				Vector3d vSE = se.vecNormal();
				
				Point3d ptSort = ptSE;
				Vector3d vSort = -vSE;
				Beam bmPerps[] = Beam().filterBeamsHalfLineIntersectSort(bms, ptSort, vSort);
				if (bmPerps.length() == 0) continue;
				
				int iAtOpening = false;
				for (int m=0; m<ppOpAll.length(); m++)
				{
					int iInside = ppOpAll[m].pointInProfile(ptSE);
					if (iInside == 0) 
					{
						iAtOpening = true;
						break;
					}
				}
				
				//__Also remove edges at sides of openings that might be above or below
				if (iDoMinLabels)
				{
					for (int m=0; m<ptsOpX.length(); m++)
					{
						Point3d pt = ptsOpX[m];
						double dCheckX = abs((pt - ptSE).dotProduct(vX));
						if (dCheckX < U(.1))
						{
							iAtOpening = true;
							break;
						}
					}
				}
				if (iAtOpening) continue;
				
					
				String stKey = 2* round(ptSE.X()/2);
				stKey +=  2* round(ptSE.Y()/2);
				stKey +=  2* round(ptSE.Z()/2);				
				
				if (stPointsFound.find(stKey) >= 0) 
				{//__This edge already recorded
					continue;
				}
				else
				{
					int iRecordEdge = true;						
					if (iDoMinLabels)
					{//__Check to see if edge is on end of panels, only record one of these						
						if (! vSE.isParallelTo(vX)) 
						{
							Vector3d vEdge = vZ.crossProduct(vSE);
							Line lnSE (ptSE, vEdge);
							
							//__is this edge on one of the ends?
							for (int n=0; n<ptEnds.length(); n++)
							{
								Point3d ptCheck = lnSE.closestPointTo(ptEnds[n]);
								Vector3d vCheck = ptCheck - ptSE;
								double dCheck = abs(vCheck.dotProduct(vSE));
								if (dCheck < U(.1))//__Yes, is end edge
								{
									//__Check to see if this edge already recorded
									for (int m=0; m<lnEdgesFound.length(); m++)
									{
										Line ln = lnEdgesFound[m];
										ptCheck = ln.closestPointTo(ptSE);
										double dCheck = abs((ptCheck - ptSE).dotProduct(vSE));
										if (dCheck < U(.1))
										{
											iRecordEdge = false;
											break;
										}
									}
									//__if iRecordEdge is still true, this is first edge for this end
									if ( iRecordEdge)
									{
										lnEdgesFound.append(lnSE);
										seAll.append(se);
										stPointsFound.append(stKey);
										iRecordEdge = false;
									}
								}
							}
						}
					}	
					if (iRecordEdge)
					{
						seAll.append(se);
						stPointsFound.append(stKey);
					}
				}				
			}//__End loop through edges		
			

		
	
//####################### End  Gather & sort SipEdges	################################## 
//#####################################################################################

//#####################################################################################
//############################## Label SipEdges ########################################## 
		Vector3d vRead = - _XW + _YW; vRead.normalize();
		
		for( int i=0; i<seAll.length(); i++)
		{
			SipEdge se = seAll[i] ;
			Point3d ptSE = se.ptMid() ;
			Vector3d vSE = se.vecNormal() ;
			double dSE = se.dRecessDepth() ;
			String stSE = se.detailCode() ;
			//reportMessage("\n" + stSE);
			String stLabel = "??" ;
			//__Use detail code & Recess Depth to set proper label
			//__Example if( stSE == "Block Spline" && dSE == 1.5 ) stLabel = "3\" Spline" ;
			if( stSE == "R 1-1/2\"" ) continue;
			
			Vector3d vSEMS = vSE;
			Vector3d ptSEMS = ptSE;
			ptSE.transformBy( ms2ps ) ;
			ptSE.setZ(0) ;	
			
			vSE.transformBy( ms2ps ) ; vSE.normalize() ;
			Vector3d vTextPerp = vSE;
			if (vTextPerp.dotProduct(vRead) < 0) 
			{
				vTextPerp *= -1;
				dSE *= 2;
			}
			
			Point3d ptText = ptSEMS - vSEMS * (dSE + pdOffset + dTextHMS/2) ;
			ptText.transformBy(ms2ps);
				
			Vector3d vText = vTextPerp.crossProduct( _ZW ) ;
			
			//__Check for end conditions and reset label ########################
			int iFlagX = 0;
			if (iDoMinLabels || stSE == "")//__Only when not labeling all edges
			{
				int iIsEnd = false;
				if ( abs((ptElStart - ptSEMS).dotProduct(vX)) < U(.1)) iIsEnd = true;//__Edge is at start of wall
				if ( abs((ptElEnd - ptSEMS).dotProduct(vX)) < U(.1)) iIsEnd = true;//__Edge is at end of wall
				
				//__Also check for no label
				if (iIsEnd || stSE == "")
				{
					Point3d ptSort = ptSEMS;// + vSEMS * U(6);
					Vector3d vSort = -vSEMS;
					Beam bmPerps[] = Beam().filterBeamsHalfLineIntersectSort(bms, ptSort, vSort);
					int iNumBeams;
					double dBmWLabel;
					for (int k=0; k<bmPerps.length()-1; k++)//__find stacked/sistered beams
					{
						Beam bm = bmPerps[k];
						if (bm.type() == 35) continue; //__ignore cap strips
						if (! bm.vecX().isPerpendicularTo(vSEMS)) continue;//__ignore beams not parallel to edge
						double dBmW = bm.dW();
						double dBmH = bm.dH();
						if ( dBmH < dBmW)
						{
							double dTemp = dBmH;
							dBmH = dBmW;
							dBmW = dTemp;
						}
						
						//__Verify there is an initial beam
						if (dBmWLabel == 0)
						{
							Vector3d vCheck1 = bm.ptCen() - ptSEMS;
							double dCheck1 = abs(vCheck1.dotProduct(vSEMS));
							if ( dCheck1 > dBmW/2 + U(.1)) break;
							iNumBeams = 1;
							dBmWLabel = round(dBmW * 1000)/1000;
						}
						
						Beam bmNext = bmPerps[k+1];					
						double dBmWNext = bmNext.dW();
						double dBmHNext = bmNext.dH();
						if (dBmHNext < dBmWNext)
						{
							double dTemp = dBmHNext;
							dBmHNext = dBmWNext;
							dBmWNext = dTemp;
						}
						double dStackDist = (dBmW + dBmWNext)/2;
						
						Vector3d vCheck = bm.ptCen() - bmNext.ptCen();
						double dCheck = abs(vCheck.dotProduct(vSEMS));
						
						if ( abs((dCheck - dStackDist)) < U(.1))//__Beams are stacked
						{
							iNumBeams++;
						}
						else
						{
							break;
						}
					}//__End look for stacked beams
					
					stSE = "(" + iNumBeams + ") " + dBmWLabel;
					if ( abs( dBmWLabel - U(1.5)) < U(.01)) stSE = "(" + iNumBeams + ") 2x" ;
					if ( iNumBeams == 0) stSE = "";
					//reportMessage ("\nvSEMS = " + vSEMS + " : dSE = " + dSE + " : stSE = " + stSE);
					
					//__Also reset label location to miss lumber for ends
					if (iIsEnd)
					{
						ptText = ptSEMS - vSEMS *( dBmWLabel*iNumBeams + dTextHMS/2);
						ptText.transformBy(ms2ps);	
					}					
				}
			}
			
			

			Map mp;
			mp.setString("stText",stSE);
			mp.setPoint3d("ptGrip",ptText);
			mp.setVector3d("vx",vText);
			mp.setVector3d("vy",vTextPerp);
			mp.setInt("iFlagX",0);
			mp.setInt("iFlagY",0);
			mpDraw.appendMap(mpDraw.length(),mp);
			arPtExisting.append(ptSE);
			arStText.append(stSE);
			//dp.draw( stSE, ptSE, vText, vSE, 0, 1 ) ;
		}
		
//################################# End Label SipEdges	################################## 
//#####################################################################################


//#####################################################################################
//######################### Gather & Label Headers ######################################## 
		for( int i=0; i<bms.length(); i++)
		{
			Beam bm = bms[i] ;
			if( bm.type() != 18 ) continue;
			//if( bm.vecX().isParallelTo(vX) ) continue;//__Do I need this?
			String stLabel = bm.name() ;
			Point3d ptLabel = bm.ptCen() ;
			ptLabel.transformBy( ms2ps ) ;
			ptLabel.setZ(0) ;
			
			//Make sure there are no duplicates
			if(stLabel.length() == 0)continue;
			int bSkip=0;
			for(int d=0;d<arPtExisting.length();d++)
			{
				double dDist=(arPtExisting[d]-ptLabel).length();
				
				if(dDist<dVal && arStText[d] == stLabel)
				{
					bSkip = 1;
					break;
				}
			}
			if(bSkip)continue;	
				
			Map mp;
			mp.setString("stText",stLabel);
			mp.setPoint3d("ptGrip",ptLabel);
			mp.setVector3d("vx",_XW);
			mp.setVector3d("vy",_YW);
			mp.setInt("iFlagX",0);
			mp.setInt("iFlagY",0);
			mpDraw.appendMap(mpDraw.length(),mp);
			arPtExisting.append(ptLabel);
			arStText.append(stLabel);
			//dp.draw( stLabel, ptLabel, _XW, _YW, 0, 0 ) ;
		}
//####################### End  Gather & Label Headers	################################## 
//#####################################################################################

//#####################################################################################
//####################### Finaly add wall style	################################## 
		
		
		Point3d ptLabel = vp.ptCenPS()-_XW*vp.widthPS()/2-_YW*vp.heightPS()/2;

		Map mp;
		mp.setInt("bIsTitle", 1);
		mp.setString("stText",stLine1Text);
		if(stLine2Text.length() > 0) mp.setString("stText2",stLine2Text);
		mp.setPoint3d("ptGrip",ptLabel);
		mp.setVector3d("vx",_XW);
		mp.setVector3d("vy",_YW);
		mp.setInt("iFlagX",0);
		mp.setInt("iFlagY",0);
		mpDraw.appendMap(mpDraw.length(),mp);		
	}
	
	_Map.setMap(stMapKey,mpDraw);
	
	
	if(mpDraw.length() > 0)
	{
		//_PtG.setLength(mpDraw.length());
		
		for(int i=0;i<mpDraw.length();i++)
		{
			Map mp=mpDraw.getMap(i);
			if(mp.getInt("bHideThis") == 1)continue;
			int bIsTitle = mp.getInt("bIsTitle");
			Display& dpDraw = bIsTitle ? dpTitle : dp;
			double dTH = bIsTitle ? dTitleH : dTextH;
			
			if(_PtG.length() -1 < i)
			{ 
				_PtG.append(mp.getPoint3d("ptGrip"));
			}
			
			
			if(mp.hasString("sttext2"))
			{
				Vector3d vy=mp.getVector3d("vy");
				
				dpDraw.draw(mp.getString("stText"),_PtG[i]+vy*dTH*pdTitleSpacing, mp.getVector3d("vx"), mp.getVector3d("vy"), mp.getInt("iFlagX"), mp.getInt("iFlagY")) ;
				dpDraw.draw(mp.getString("stText2"),_PtG[i]-vy*dTH*pdTitleSpacing, mp.getVector3d("vx"), mp.getVector3d("vy"), mp.getInt("iFlagX"), mp.getInt("iFlagY")) ;
			}
			else
			{
				dpDraw.draw(mp.getString("stText"),_PtG[i],mp.getVector3d("vx"),mp.getVector3d("vy"),mp.getInt("iFlagX"),mp.getInt("iFlagY")) ;
			}
		}
	}
	


_Element.setLength(0);
_Element.append(el);
setDependencyOnEntity(el);










#End
#BeginThumbnail















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Bugfix on enabling grips" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="49" />
      <str nm="Date" vl="5/2/2025 11:25:23 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Made even more dependent, less performant " />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="47" />
      <str nm="Date" vl="3/14/2024 5:47:33 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl=" setDependencyOnEntity(sp);" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="45" />
      <str nm="Date" vl="3/13/2024 2:24:18 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Added Properties for control of text height, title color and spacing" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="44" />
      <str nm="Date" vl="1/5/2024 9:20:08 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Added customization options for title" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="42" />
      <str nm="Date" vl="1/3/2024 1:39:32 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End