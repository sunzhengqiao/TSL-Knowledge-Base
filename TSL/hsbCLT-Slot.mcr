#Version 8
#BeginDescription
version value="1.1" date="02dec2020" author="thorsten.huck@hsbcad.com"
HSB-9950 compatible with version 22

This tsl creates a slot on one of the main faces of a panel

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <History>//region
/// < </version>
/// <version value="1.0" date="30nov2020" author="thorstversion value="1.1" date="02dec2020" author="thorsten.huck@hsbcad.com"> HSB-9950 compatible with version 22en.huck@hsbcad.com"> HSB-9950 initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a slot on one of the main faces of a panel
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-Slot")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Panels|") (_TM "|Select slot tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Panels|") (_TM "|Select slot tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Side|") (_TM "|Select slot tool|"))) TSLCONTENT

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
//end Constants//endregion

//region bOnJig
	String sJigAction = "JigAction";
	if (_bOnJig && _kExecuteKey==sJigAction) 
	{
	//_ThisInst.setDebug(TRUE);
	    Point3d ptBase = _Map.getPoint3d("_PtBase"); // set by second argument in PrPoint
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point

		double dX = _Map.getDouble("dX");
		double dY = _Map.getDouble("dY");
		double dZ = _Map.getDouble("dZ");
		double dH = _Map.getDouble("dH");		
		double dAngle =_Map.getDouble("angle");	
		
		int nAlignmentX = _Map.getInt("alignmentX");
		int nAlignmentY = _Map.getInt("alignmentY");		
		int nAlignmentZ = _Map.getInt("alignmentZ");
		
		Vector3d vecZ = _Map.getVector3d("vecZ");		
		Vector3d vecXT = ptJig - ptBase;	
		if (dX <= 0)dX = vecXT.length();
		vecXT.normalize();
		Vector3d vecZT = vecZ * nAlignmentZ;
		Vector3d vecYT = vecXT.crossProduct(-vecZT);

		// angle
		CoordSys csT(_Pt0, vecYT, vecXT, vecZT);
		if (abs(dAngle)>0)
		{ 
			CoordSys csRot;
			csRot.setToRotation(dAngle, csT.vecY(), _Pt0);
			csT.transformBy(csRot);
			vecYT = csT.vecX();
			vecXT = csT.vecY();
			vecZT = csT.vecZ();	
		}	


		Point3d ptRef = _PtW + _Map.getVector3d("ptRef")+vecZT*.5*dH;
		Point3d ptSlot = ptBase + vecZT * vecZT.dotProduct(ptRef - ptBase);
		ptJig += vecZT * vecZT.dotProduct(ptRef - ptJig);

		//Vector3d vecZView = getViewDirection(2);

		Display dp(40);
		if (nAlignmentZ<0)
			dp.color(5);//dp.trueColor(rgb(122,151,255));// blueish
		else
			dp.color(40);//dp.trueColor(rgb(255,221,117));// brownish	
		//dp.draw(nAlignmentX + " / " + nAlignmentY + " / " + nAlignmentZ, ptSlot, _XW,_YW,1,0);	
		
		if (dX>dEps && dY>dEps && dZ>dEps)
		{ 
			Body bd (ptSlot, vecXT, vecYT, vecZT, dX, dY, dZ, -nAlignmentX, -nAlignmentZ*nAlignmentY, -1);
			dp.draw(bd);			
		}
	
		
		dp.color(1);
		dp.draw(PLine(ptSlot, ptJig));
		dp.color(3);
		Point3d pt = ptSlot + vecYT*nAlignmentY * .5 * dY;
		dp.draw(PLine(pt-vecYT*2*dY,pt+vecYT*2*dY));
	    return;
	}		
//End bOnJig//endregion 

//region Properties
	category = T("|Geometry|");
	
	String sLengthName=T("|Length|");	
	PropDouble dLength(nDoubleIndex++, U(0), sLengthName);	
	dLength.setDescription(T("|Defines the length of the slot.|"));
	dLength.setCategory(category);		
	
	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(8), sWidthName);	
	dWidth.setDescription(T("|Defines the Width|"));
	dWidth.setCategory(category);
	
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(100), sDepthName);	
	dDepth.setDescription(T("|Defines the Depth|"));
	dDepth.setCategory(category);
		
	category = T("|Alignment|");
	String sAlignments[] ={ T("|Left|"), T("|Center|"), T("|Right|")};
	String sAlignmentName=T("|Alignment|");	
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the Alignment|"));
	sAlignment.setCategory(category);
	int nAlignment = sAlignments.find(sAlignment, 1)-1;
	if (nAlignment<-1){ sAlignment.set(sAlignments[1]); setExecutionLoops(2); return;}
	
	String sFaceName=T("|Face|");
	String sFaces[] = { T("|Reference Side|"), T("|Opposite Side|")};
	PropString sFace(nStringIndex++, sFaces, sFaceName);	
	sFace.setDescription(T("|Defines the Face|"));
	sFace.setCategory(category);
	int nFace = sFaces.find(sFace)==1?1:-1;

	String sAngleName=T("|Angle|");	
	PropDouble dAngle(nDoubleIndex++, U(0), sAngleName, _kAngle);	
	dAngle.setDescription(T("|Defines the angle of the slot to the normal of the face|") + T(", |must be in range of -90 > Value < 90|"));
	dAngle.setCategory(category);
//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		dLength.setDescription(T("|Defines the length of the slot.|") + T(" |0 = pick length|"));			
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
		
		int nFace = sFaces.find(sFace)==1?1:-1;
		int nAlignment = sAlignments.find(sAlignment, 1)-1;
		
		
		_Sip.append(getSip());
		
		_PtG.append(getPoint(T("|Start Point|")));
 
	//region Show Jig
		_Pt0 = _PtG[0];
		PrPoint ssP(T("|Select end point [Start/Mid/End/Left/Center/Right/FlipSide]|"), _PtG[0]); // second argument will set _PtBase in map
	    Map mapArgs;

		mapArgs.setVector3d("vecZ", _Sip[0].vecZ());
		mapArgs.setDouble("dX", dLength);
		mapArgs.setDouble("dY", dWidth);
		mapArgs.setDouble("dZ", dDepth);
		mapArgs.setDouble("dH", _Sip[0].dH());
		mapArgs.setDouble("angle", dAngle);
		
		int nAlignmentX = dLength<=0?-1:0;
		int nAlignmentY = nAlignment;
		int nAlignmentZ = nFace;
		
		mapArgs.setInt("alignmentX", nAlignmentX);
		mapArgs.setInt("alignmentY", nAlignmentY);
		mapArgs.setInt("alignmentZ", nAlignmentZ);
		mapArgs.setVector3d("ptRef", _Sip[0].ptCen()-_PtW);
		
	    mapArgs.setPoint3d("ptBase", _PtG[0]); // add all the info you need for Jigging
	    
	    int nGoJig = -1;
	    int bSetLength;
	    while (nGoJig != _kOk && nGoJig != _kNone)
	    {
	        nGoJig = ssP.goJig("JigAction", mapArgs); 
	        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
	        
	        if (nGoJig == _kOk)
	        {
	            _PtG.append(ssP.value()); //retrieve the selected point
	        }
	        else if (nGoJig == _kKeyWord)
	        { 
	        // flip side	
	        	if (ssP.keywordIndex() ==6)
	        	{
	        		//nAlignmentY *= -1;
	        		nAlignmentZ *= -1;
	        	}	        	
				else if (ssP.keywordIndex() <3)
	        	{
	        		nAlignmentX  = ssP.keywordIndex()-1;
	        	}
	        	else if (ssP.keywordIndex() >2)
	        	{
	        		nAlignmentY =ssP.keywordIndex()-4;
	        	}
	        	mapArgs.setInt("alignmentX", nAlignmentX);
	        	mapArgs.setInt("alignmentY", nAlignmentY);
	        	mapArgs.setInt("alignmentZ", nAlignmentZ);
	        }
	        else if (nGoJig == _kCancel || nGoJig == _kNone)
	        { 
	            eraseInstance(); // do not insert this instance
	            return; 
	        }
	    }
	    
	    sFace.set(sFaces[(nAlignmentZ == 1 ? 1 : 0)]);
	    sAlignment.set(sAlignments[nAlignmentY+1]);
	    Vector3d vecXT = _PtG[1] - _PtG[0]; 
	    if (dLength <= 0)dLength.set(vecXT.length());
	    vecXT.normalize();
	    
	    if (nAlignmentX==0)
	    { 
	    	_PtG[0] = _Pt0 - vecXT*.5*dLength;
	    	_PtG[1] = _Pt0 + vecXT*.5*dLength;
	    }
		else if (nAlignmentX==-1)
	    { 
	    	_PtG[1] = _Pt0 + vecXT*dLength;
	    	_Pt0.setToAverage(_PtG);
	    }
	 	else if (nAlignmentX==1)
	    { 
	    	_PtG[0] = _Pt0 - vecXT*dLength;
	    	_PtG[1] = _Pt0;
	    	_Pt0.setToAverage(_PtG);
	    }   
	//End Show Jig//endregion 	

		
		return;
	}	
// end on insert	__________________//endregion

//region Events
	int bOnJig;
	if (_bOnGripPointDrag && (_kExecuteKey.find("_PtG", 0, false) >- 1 || _kExecuteKey == "_Pt0"))
	{
		bOnJig = true;
	}
//	if (_kNameLastChangedProp==sFaceName && nAlignment!=0)
//	{ 
//		int n = nAlignment *- 1;
//		nAlignment = n;
//		n++;
//		sAlignment.set(sAlignments[n]);	
//	}
	if (_kNameLastChangedProp.find("_PtG",0)>-1 || (_bOnDbCreated && dLength<=0))
	{ 
		Vector3d vecXT = _PtG[1] - _PtG[0];
		double dX = vecXT.length();
		dLength.set(dX);
	}
	if (_kNameLastChangedProp==sLengthName || (_bOnDbCreated && dLength>0))
	{ 
		Vector3d vecXT = _PtG[1] - _PtG[0];
		vecXT.normalize();
		_PtG[0] = _Pt0 - vecXT * .5 * dLength;
		_PtG[1] = _Pt0 + vecXT * .5 * dLength;
	}
//	if (_kNameLastChangedProp == sFaceName)
//	{
//		sFace.set((sFace == sFaces[0] ? sFaces[1] : sFaces[0]));
//	}
	
// Trigger FlipSide//region
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick)) 
	{
		sFace.set((sFace == sFaces[0] ? sFaces[1] : sFaces[0]));
		setExecutionLoops(2);
		return;
	}//endregion	
	



	
	
//End Events//endregion 

//region Panel standards
	if (_Sip.length()<1)
	{
		reportMessage("\n" + scriptName() + ": " +T("|Invalid reference.|") + " " + T("|Tool will be deleted|"));
		eraseInstance();
		return;
	}

	Sip sip = _Sip[0];
	Vector3d vecX = sip.vecX();
	Vector3d vecY = sip.vecY();
	Vector3d vecZ = sip.vecZ();
	Point3d ptCen = sip.ptCenSolid();
	double dZ = sip.dH();
	vecX.vis(ptCen,1);vecY.vis(ptCen,3);vecZ.vis(ptCen,150);
	Vector3d vecFace = nFace * vecZ;	vecFace.vis(ptCen,2);
	if (!bOnJig)
	{ 
		_ThisInst.setDrawOrderToFront(true);
	// declare a potential element ref
		Element el=sip.element();
		if (el.bIsValid())
		{
			assignToElementGroup(el,true,0,'T');
			_Element.append(el);	
		}
		else
			assignToGroups(sip, 'T');
		
	//	PLine plOpenings[] = sip.plOpenings();
	//	PLine plEnvelope = sip.plEnvelope();
	//	Body bdEnv = sip.envelopeBody(false, true);
	//	Plane pnZ(ptCen, vecZ);
	//	PlaneProfile ppZ(sip.coordSys());
	//	ppZ.unionWith(bdEnv.shadowProfile(pnZ));		//ppZ.vis(1);
	//	SipEdge edges[] = sip.sipEdges();
	//	SipStyle style(sip.style());
	//	
		
		
		setEraseAndCopyWithBeams(_kBeam0);		
	}


//End Panel standards//endregion 


//region Tool CoordSys 
	Point3d ptRef = ptCen+vecFace*.5*dZ;
	for (int i=0;i<_PtG.length();i++) 
	{ 
		_PtG[i]+=vecZ*vecZ.dotProduct(ptRef-_PtG[i]); 
		addRecalcTrigger(_kGripPointDrag, "_PtG"+i); 
	}//next i
	_Pt0.setToAverage(_PtG);
	addRecalcTrigger(_kGripPointDrag, "_P0");
	
	Vector3d vecXT = _PtG[1] - _PtG[0];
	double dX = vecXT.length();
	vecXT.normalize();
	Vector3d vecZT = -vecFace;
	Vector3d vecYT = vecZT.crossProduct(vecXT);	
	
	// angle
	CoordSys csT(_Pt0, vecYT, vecXT, vecZT);
	if (abs(dAngle)>0)
	{ 
		CoordSys csRot;
		csRot.setToRotation(dAngle, csT.vecY(), _Pt0);
		csT.transformBy(csRot);
		vecYT = csT.vecX();
		vecXT = csT.vecY();
		vecZT = csT.vecZ();	
	}	

	//	vecXT.vis(_Pt0,1);vecYT.vis(_Pt0,3);vecZT.vis(_Pt0,150);
	Point3d ptSlot = _Pt0;
	
//End Tool CoordSys //endregion 	
	
//region Display
	Display dp(1);
	Point3d pt = ptSlot + vecZT * .5 * dDepth;
	pt+=vecYT*nFace*nAlignment * .5 * dWidth;
	PLine plines[] ={ PLine(ptSlot-vecXT*.5*dX, ptSlot+vecXT*.5*dX),PLine(pt-vecYT*.5*dWidth, pt+vecYT*.5*dWidth),PLine(ptSlot, ptSlot + vecZT * dDepth)};
	for (int i=0;i<plines.length();i++) 
	{ 
		dp.color(i == 0 ?12:(i == 1 ? 92 : 150));
		dp.draw(plines[i]);  
	}//next i
	
	PLine pl; pl.createRectangle(LineSeg(ptSlot - vecXT * .5 * dX - vecYT * .5 * dWidth, ptSlot + vecXT * .5 * dX + vecYT * .5 * dWidth), vecXT, vecYT);
	pl.transformBy(vecYT * nFace*nAlignment * .5 * dWidth);
	pl.projectPointsToPlane(Plane(ptRef, vecZ), vecZT);
	if(nFace == -1)
		dp.color(5);//dp.trueColor(rgb(122,151,255));// blueish
	else
		dp.color(40);//dp.trueColor(rgb(255,221,117));// brownish		
	dp.draw(pl);
	if (bOnJig)
	{ 	
		Body bd(ptSlot, vecXT, vecYT, vecZT, dX, dWidth, dDepth, 0, nFace*nAlignment, 1);
		for (int i=0;i<_Sip.length();i++) 
		{ 
			Body bdEnv = _Sip[i].envelopeBody(false,true);
			bdEnv.intersectWith(bd);
			dp.draw(bdEnv);
			 
		}//next i
		
		
		dp.draw(PlaneProfile(pl), _kDrawFilled, 90);
		return;
	}
//End Display//endregion 

//region Tool
	else
	{
		if (dX>dEps && dWidth>dEps && dDepth>dEps)
		{ 
			Slot slot(ptSlot, vecXT, vecYT, vecZT, dX, dWidth, dDepth, 0, nFace*nAlignment, 1);
			slot.addMeToGenBeamsIntersect(_Sip);
			
		//region Trigger Add or Remove Panels
			String sTriggerAddPanels = T("|Add Panels|");
			addRecalcTrigger(_kContextRoot, sTriggerAddPanels );
			if (_bOnRecalc && _kExecuteKey==sTriggerAddPanels)
			{
			
			// prompt for sips
				Entity ents[0];
				PrEntity ssE(T("|Select panels|"), Sip());
				if (ssE.go())
					ents.append(ssE.set());
				
				for (int i=0;i<ents.length();i++) 
				{ 
					Sip _sip= (Sip)ents[i];
					if (_Sip.find(_sip)<0 && slot.cuttingBody().hasIntersection(_sip.envelopeBody(false,true)))
						_Sip.append(_sip);
				}//next i
				setExecutionLoops(2);
				return;
			}
			if (_Sip.length()>1)
			{ 
				String sTriggerRemovePanels = T("|Remove Panels|");
				addRecalcTrigger(_kContextRoot, sTriggerRemovePanels );
				if (_bOnRecalc && _kExecuteKey==sTriggerRemovePanels)
				{
				// prompt for sips
					Entity ents[0];
					PrEntity ssE(T("|Select panels|"), Sip());
					if (ssE.go())
						ents.append(ssE.set());
					
					for (int i=0;i<ents.length();i++) 
					{ 
						int n = _Sip.find(ents[i]);
						if (_Sip.length()>1 && n>-1)
							_Sip.removeAt(n);
					}//next i
					setExecutionLoops(2);
					return;
				}				
			}
			
		//endregion		
			
		}
		else
		{ 
			eraseInstance();
			return;
		}
	}
	
//End Tool//endregion 



		
#End
#BeginThumbnail
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
;#!815<;_![_:$K#EXM1B`````$E%3D2N0F""

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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End