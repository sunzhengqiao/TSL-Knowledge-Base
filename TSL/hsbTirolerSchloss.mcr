#Version 8
#BeginDescription
version value="2.0" date=19jun17" author="thorsten.huck@hsbcad.com">
tapering enhanced on diagonal notches
negative seatcut values are forcing additional beamcuts
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Dieses Tsl erzeugt die Blockverkämmung Tiroler Schloss
/// </summary>

/// <insert>
/// Select 2 walls or press <Enter> to insert in beam mode. In beam mode select the beam and a reference point.
/// </insert>

/// <command name="Swap Direction X" Lang=en>
/// This command swaps the direction in X
///</ command >

/// <command name="Swap Direction Y" Lang=en>
/// This command swaps the direction in Y. This command is useful if you want to connect two 
/// tools with the same shape for an extended protrusion.
///</ command >

/// <command name="Swap Direction Y" Lang=de>
/// Dieser Befehl wechselt die Richtung in Y-Richtung. Anwendung bei zwei gleich orientierten Werkzeugen zur Erzeugung einer
/// verlängerten Durchdringung
///</ command >

///History
///<version value="2.0" date=19jun17" author="thorsten.huck@hsbcad.com"> tapering enhanced on diagonal notches, negative seatcut values are forcing additional beamcuts </version>
/// Version 1.9   16.11.2009   th@hsbCAD.de
/// DE   bei ungleichen Wandhöhen wird  nun die Start- und Endhöhe korrekt berücksichtigt
///      um auch halbe Verbindungen zu berücksichtigen, stellen Sie bitte sicher, dass die 
///      gewählte Endhöhe die Oberkante der betreffenden Bohle überragt
/// EN   bugfix for different wall heights and specified start and end height.
///      to ensure also half connections t be included specify end height such that the height at the upper
///      face of the last log is below the given endheight
/// Version 1.8   10.07.2008   th@hsbCAD.de
/// DE   neuer Kontextbefehl zum Wechsel der Y-Richtung
/// EN   new context command to swap Y-Alignment
/// Version 1.7   26.06.2008   th@hsbCAD.de
/// DE   Korrektur für komplexe Bauteile, Werkzeug wird nicht mehr gelöscht
/// EN   tool will not be deleted on complex beams 
/// Version 1.6   23.06.2008   th@hsbCAD.de


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


	// the tsl has various properties which depend on the mode
	// the tool shape propert depends on the tsl mode
	String sMasterMacros[] = {T("|Convex|"),T("|Concave|"),T("|Diagonal|")};
	String sMacros[] = {T("|Corner convex|"),T("|Corner concave|"),T("|Corner diagonal|"),
							T("|T-Connection convex (female)|"),T("|T-Connection concave (female)|"),T("|T-Connection diagonal (female)|"),
							T("|T-Connection convex (male)|"),T("|T-Connection concave (male)|"),T("|T-Connection diagonal (male)|")};
	int nMacros[]={_kCConvex, _kCConcave, _kCDiagonal, _kTIConvex, _kTIConcave, _kTIDiagonal, _kTEConvex, _kTEConcave, _kTEDiagonal};	
	PropString sMacro;
	if (!_Map.getInt("isMaster"))
		sMacro = PropString(nStringIndex++,sMacros, T("|Tool Shape|"));	
	else
		sMacro = PropString(nStringIndex++,sMasterMacros, T("|Tool Shape|"));	
	int bDiagonal = sMacro==sMasterMacros[2]||sMacro==sMacros[2];



	PropDouble dTSGap (nDoubleIndex++, 0, T("|Gap|"));
	dTSGap.setDescription(T("|Gap of the tool|"));

	category=T("|Seatcut / Tapering|");
	
	PropDouble dOffsetThis (nDoubleIndex++, 0, T("|Seat width|"));
	String sOffsetThisDesc = T("|The width of the seat cut or the diagonal milling|");
	if (!bDiagonal)sOffsetThisDesc+=", "+T("|Negative values forcing an additional beamcut.|");
	dOffsetThis.setDescription(sOffsetThisDesc);	
	dOffsetThis.setCategory(category);
	
	String sOffsetThisNames[]={T("|Seat depth|"), T("|Tapering|")};
	PropDouble dOffsetOther(nDoubleIndex++, 0, bDiagonal?sOffsetThisNames[1]:sOffsetThisNames[0]);
	String sOffsetOtherDesc = T("|The width of the seat cut or the diagonal milling|");
	if (!bDiagonal)sOffsetOtherDesc+=", "+T("|Negative values forcing an additional beamcut.|");
	dOffsetOther.setDescription(sOffsetOtherDesc);
	dOffsetOther.setCategory(category);
	
	PropDouble dDovetailAngle (nDoubleIndex++, 8, T("|Flankenwinkel|"));
	dDovetailAngle.setDescription(T("|The side angle|"));	
	
	PropDouble dExtraLength (nDoubleIndex++, 0, T("|Protrusion|"));
	dExtraLength .setDescription(T("|The protrusion of the connection|"));	
	
	PropDouble dOffsetVertical (nDoubleIndex++, 0, T("|Vertical Offset|"));
	dOffsetVertical .setDescription(T("|Moves the tool in vertical direction|"));
//	
//	category=T("|Tapering|");
//	String sWidthName=T("|Width|");	
//	PropString sWidth(nStringIndex++, "0", sWidthName);	
//	sWidth.setDescription(T("|Defines the tapered width as absolute value or relative to the log width (i.e.80%)|"));
//	sWidth.setCategory(category);

	category=T("|Display|");
	PropInt nColor(0, 37, T("|Color|"));
	nColor.setDescription(T("|Color of the log/log connection symbol|"));	
	nColor.setCategory(category);
	
	
// on insert
	if (_bOnInsert)
	{
		String sMsg = T("|Select 2 walls|") + ", " + T("|<Enter> to insert with beam mode|");
		PrEntity ssE(sMsg , Element());
		while (_Element.length()<2)
		{	
	  		if (ssE.go()){
				Entity ents[0];
	    		ents = ssE.set();
				for (int i = 0; i < ents.length(); i++){
				// append only elements if first entity is of type element
					if (ents[i].bIsKindOf(Element()))
					{
						Element el =(Element)ents[i];
						if (_Element.length() < 1)
						{
							_Element.append(el);
							sMsg = T("|Select other element|");
						}
						else if (_Element.find(el)<0)
						{
							if (!el.vecX().isParallelTo(_Element[0].vecX()))
								_Element.append(el);
							else
								sMsg = T("|Invalid selection.|") + " " + T("|Elements are parallel.|" + "\n");
							sMsg = sMsg +  T("|Select other element|");		
						}
						else
							sMsg = T("|Invalid selection.|") + " " + T("|Select other element|");
						 
					}
				}// next i
				if (_Element.length() < 1)
					break;
				ssE = PrEntity ("\n"+sMsg , Element());
			}// endif go()	
			else
				break;
		}// do loop
		
		
	// collect the tsl's attached to this element and verify that the same instance is not attached to the selected walls
		if (_Element.length()>0)
		{
			_Map.setInt("isMaster",true);
			
			// differ the opm key for the master
			setOPMKey(T("|Wall|"));
			
			// these properties are only needed on insert and for the master tsl
			category=T("|Display|");
			PropString sDimStyle(nStringIndex++, _DimStyles, T("|Dimstyle|"));
			sDimStyle.setCategory(category);
			
			category=T("|Tool Range|");
			PropDouble dStartHeight(nDoubleIndex++,U(0), T("|Start at Height|"));
			dStartHeight.setDescription(T("|Logs intersecting this start height will be taken for connection|"));	
			dStartHeight.setCategory(category);
			
			PropDouble dEndHeight(nDoubleIndex++,U(0), T("End at Height") + " " + T("(0 = full height)"));
			dEndHeight.setDescription(T("|Logs intersecting this end height will be taken for connection|"));		
			dEndHeight.setCategory(category);
			
			sMacro = PropString(0,sMasterMacros, T("|Tool|"));	
				
			TslInst tslAttached[0];
			tslAttached = _Element[0].tslInst();
			String sScriptName,sScriptNameAttached;
			sScriptName=scriptName(); sScriptName.makeUpper();
			int bFound;
			for (int t = 0; t < tslAttached.length();t++)
			{
			sScriptNameAttached = tslAttached[t].scriptName(); 
			sScriptNameAttached.makeUpper();
			Map map = tslAttached[t].map();
			//&& map.getInt("isMaster") 
			//reportNotice("\n"+ sScriptName + "//" + sScriptNameAttached); 
			if (sScriptName == sScriptNameAttached && tslAttached[t].map().getInt("isMaster"))//
			{
				// get the elements of this tsl
				Entity ents[] = tslAttached[t].entity();
				int nCnt;
				for (int e=0; e<ents.length();e++)
					if (_Element.find(ents[e])>-1)
					{
						nCnt++;
						//reportNotice("\nfound"+ nCnt);
					}
				if (nCnt >1)
				{
					reportNotice("\n*****************************************************************\n" + 
					scriptName() + ": " + T("|Incorrect user input.|") + "\n" + 
					T("|An instance of this tsl is already attached to this connection.|") + "\n" + 
					T("|Tsl will be deleted.|") + "\n" +
					"*****************************************************************");
					eraseInstance();
					return;	
				}

			}			
		}		
		}
		// go for beam selection
		else
		{
			Element elTest;
			_Beam.append(getBeam());
			elTest = _Beam[0].element();
			if (elTest.bIsValid())
				_Element.append(elTest);
				
			Beam bmOther[0];
			PrEntity ssB("|Select a other beams|", Beam());
			if (ssB.go())
				bmOther.append(ssB.beamSet());
			for (int i=0; i<bmOther.length(); i++)
			{
				elTest = bmOther[i].element();
				if (_Beam.find(bmOther[i])<0 && elTest.bIsValid())
				{
					_Beam.append(bmOther[i]);
					if (_Element.find(elTest)<0)
						_Element.append(elTest);
				}
			}
			
			if (_Beam.length()<2)
			{
					reportNotice("\n*****************************************************************\n" + 
					scriptName() + ": " + T("|Incorrect user input.|") + "\n" + 
					T("|You must select at least two beams which intersect and \nbelong to an element.|") + "\n" + 
					T("|Tsl will be deleted.|") + "\n" +
					"*****************************************************************");
					eraseInstance();
					return;						
			}
		}
		
		showDialogOnce();	
		return;	
	}
//end on insert________________________________________________________________________________
//_______________________________________________________________________________________________

// declare standards
	if (_Element.length() < 2)
	{
		eraseInstance();
		return;
	}
	
	Element el[0];
	el  = _Element;
	Point3d ptOrg[0];
	Vector3d vx[0],vy[0],vz[0];
	PLine plOutline[0];
	for (int i=0; i<el.length(); i++)
	{
		ptOrg.append(el[i].ptOrg());	
		vx.append(el[i].vecX());		vx[i].vis(ptOrg[i], 1);
		vy.append(el[i].vecY());		vy[i].vis(ptOrg[i], 3);
		vz.append(el[i].vecZ());		vz[i].vis(ptOrg[i], 150);	
		plOutline.append(el[i].plOutlineWall());
	}


// detect mode_______________________________________________________________________________________________________________________
	if (_Map.getInt("isMaster"))
	{
	// differ the opm key for the master
		setOPMKey(T("|Wall|"));
	// these properties are only needed on insert and for the master tsl
		category=T("|Display|");
		PropString sDimStyle(nStringIndex++, _DimStyles, T("|Dimstyle|"));
		sDimStyle.setCategory(category);
		
		category=T("|Tool Range|");
		PropDouble dStartHeight(nDoubleIndex++,U(0), T("|Start at Height|"));
		dStartHeight.setDescription(T("|Logs intersecting this start height will be taken for connection|"));	
		dStartHeight.setCategory(category);
		
		PropDouble dEndHeight(nDoubleIndex++,U(0), T("End at Height") + " " + T("(0 = full height)"));
		dEndHeight.setDescription(T("|Logs intersecting this end height will be taken for connection|"));		
		dEndHeight.setCategory(category);
		
	// detect T or C Connection
		int bTConnection;
		int nIsOn[el.length()];
		int n=0,m=1;
		Point3d ptOn[0];
		
		//reportNotice("\nexecuting on element " + el[0].number() +"/" + el[1].number());
		
		for (int e=0; e<el.length();e++)
		{
			assignToElementGroup(el[e], FALSE,0, 'T');
			Point3d ptOutline[] = plOutline[n].vertexPoints(TRUE);
			for (int i =0; i < ptOutline.length(); i++)
				if (plOutline[m].isOn(ptOutline[i]))
				{
					nIsOn[n]++;
					ptOn.append(ptOutline[i]);	
				}
			n=1;
			m=0;
		}
		if (nIsOn[0]==2 && nIsOn[1]!=2)
		{
			bTConnection = true;	
		}
		else if (nIsOn[1]==2 && nIsOn[0]!=2)
		{
			bTConnection  = true;	
			el.swap(0,1);		
		}	
	
	// set _Pt0
		if (ptOn.length()>1)
			_Pt0.setToAverage(ptOn);
		else
			_Pt0 = Line(ptOrg[0]-vz[0]*.5*el[0].dBeamWidth(), vx[0]).intersect(Plane(ptOrg[1],vz[1]),-.5*el[1].dBeamWidth());	
				
	// intersectional body
		double dThisEndHeight = dEndHeight;
		if (dThisEndHeight<=0) dThisEndHeight = U(10000);
		Body bdInt(_Pt0 + vy[0]*dStartHeight, vx[0], vy[0], vz[0], U(50), dThisEndHeight-dStartHeight, U(50), 0,1,0);
		double dIntLength = abs(dEndHeight-dStartHeight);	
		//bdInt.vis(6);
	// intersect with wall bodies
		for (int i = 0; i < el.length();i++)
		{
			LineSeg lsEl = el[i].segmentMinMax();
			Body bdEl(lsEl.ptMid(), vx[i], vy[i], vz[i], 
				abs(vx[i].dotProduct(lsEl.ptStart()-lsEl.ptEnd())) +el[i].dBeamWidth()*2,
				abs(vy[i].dotProduct(lsEl.ptStart()-lsEl.ptEnd())),
				abs(vz[i].dotProduct(lsEl.ptStart()-lsEl.ptEnd()))+ +el[i].dBeamWidth()*2,
				0,0,0);
			bdEl.vis(i);
			bdInt.intersectWith(bdEl);
		}
		bdInt.vis(2);	
		dIntLength = bdInt.lengthInDirection(vy[0]);	
	
	
	// collect all beams
		Beam bmAll0[0], bmAll1[0];
		bmAll0 = el[0].beam();
		bmAll1 = el[1].beam();	
		bmAll0 = vy[0].filterBeamsPerpendicularSort(bmAll0);
		bmAll1 = vy[1].filterBeamsPerpendicularSort(bmAll1);	
		
	// collect valid beams	
		Beam bm0[0], bm1[0];
		for (int i = 0; i < bmAll0.length(); i++){
			
			if (bdInt.hasIntersection(bmAll0[i].realBody())){
				bm0.append(bmAll0[i]);
				bmAll0[i].envelopeBody().vis(3);
			}		
		}
		for (int i = 0; i < bmAll1.length(); i++){
			if (bdInt.hasIntersection(bmAll1[i].realBody())){
				bm1.append(bmAll1[i]);			
				bmAll1[i].envelopeBody().vis(3);
			}		
		}		

		int nToolShape = sMasterMacros.find(sMacro,0);
	// diagonal
		if (nToolShape==2)
		{
			dOffsetThis.set(dOffsetOther);
			dOffsetThis.setReadOnly(true);
		}
		
	// on element constructed
		if ((bm0.length()>0&&bm1.length()>0) && (_bOnElementConstructed || _bOnDbCreated))
		{	
				
		// compose an ordered array of all connecting beams
			Beam bmC[0];
			bmC= bm0;
			bmC.append(bm1);
			bmC= vy[0].filterBeamsPerpendicularSort(bmC);	
	


	
		// declare tsl props
			TslInst tsl;			
			Vector3d vxTsl = vx[0];
			Vector3d vyTsl = vy[0];			
			int nProps[0];
			double dProps[0];
			String sProps[2];	
			Map mapTsl;	
			Beam arBm[0];
			Entity arEnts[2];
			Point3d arPt[1];	
			
			arEnts[0] = el[0];	
			arEnts[1] = el[1];
	
			nProps.append(nColor);	
				
			dProps.append(dTSGap);	
			dProps.append(dOffsetThis );	
			dProps.append(dOffsetOther );	
			dProps.append(dDovetailAngle );	
			dProps.append(dExtraLength );	
			dProps.append(dOffsetVertical );	
			//dProps.append(dStartHeight);						
			//dProps.append(dEndHeight);
			
			


			for (int i = 0; i < bmC.length(); i++)
			{
				arBm.setLength(0);
				arBm.append(bmC[i]);

				//reportNotice("\n"+bmC[i].posnum() + bmC[i].element().number());
		
				// set the tool
				if (bTConnection)
				{
					if (nToolShape == 0)// convex
					{
						if (arBm[0].element() == el[0])	sProps[0]	= sMacros[6];	
						else									sProps[0]	= sMacros[3];
					}				
					else if (nToolShape == 1)// concave
					{
						if (arBm[0].element() == el[0])	sProps[0]	= sMacros[7];	
						else									sProps[0]	= sMacros[4];					
					}				
					else if (nToolShape == 2)// diagonal
					{
						if (arBm[0].element() == el[0])	sProps[0]	= sMacros[8];	
						else									sProps[0]	= sMacros[5];					
					}	
				}
				else
				{
					if (nToolShape == 0)// convex
					{
						if (arBm[0].element() == el[0])	sProps[0]	= sMacros[0];
						else									sProps[0]	= sMacros[1];	
					}				
					else if (nToolShape == 1)// concave
					{
						if (arBm[0].element() == el[0])	sProps[0]	= sMacros[1];
						else									sProps[0]	= sMacros[0];	
					}	
					else	// diagonal
																sProps[0]	= sMacros[2];
				}	
				
						
				// append below additional				
				if (i>0)
				{
					arBm.append(bmC[i-1]);
				}
				// append above additional
				if (i<bmC.length()-1)	
				{
					arBm.append(bmC[i+1]);
					//reportNotice("\ni=" +i+ " " + bmC[i+1].color());
				}
				//reportNotice("\ni:" + i + "length: " + arBm.length());
				
			
			//	sProps[1]	= sWidth;
			// default mill above last log	
				sProps[1]	= sNoYes[1];
				
				if (arBm.length() > 1)
				{	
					if (arBm[0].vecX().isParallelTo(arBm[1].vecX()))
						continue;
					arPt[0] = Line(arBm[0].ptCen(), arBm[0].vecX()).intersect(Plane(arBm[1].ptCen(), arBm[1].vecD(arBm[0].vecX())),0);	
					//reportNotice("\ncreating for qty beams : " + arBm.length());
					tsl.dbCreate(scriptName(), vxTsl,vyTsl,arBm, arEnts,arPt,
						nProps, dProps,sProps, _kModelSpace, mapTsl );
				}		
			}// next i
		}
		
		Display dp(nColor);
		dp.dimStyle(sDimStyle);
		if(bm0.length()<1||bm1.length()<1)
			dp.color(1);
		dp.draw(scriptName(),_Pt0,  vx[0], vz[0], 0,0, _kDevice);
		
		
	}// end the master mode	____________________________________________________________________________________________________________	
	
	
	// tooling mode_________________________TS___________________________TS_______________________________TS___________________________
	else
	{
		PropString sMillAbove(nStringIndex++, sNoYes, T("|Mill above top log|"));
		int nMillAbove = sNoYes.find(sMillAbove);
		
		// add triggers
		String sTrigger[] = {T("|Swap direction|") + " X", T("|Swap direction|") + " Y"};
		for (int i = 0; i < sTrigger.length(); i++)
			addRecalcTrigger(_kContext, sTrigger[i]);	
			
		// trigger0:
		int nDir=1;
		if (_Map.hasInt("dir"))
			nDir = _Map.getInt("dir");
		if (_bOnRecalc && _kExecuteKey==sTrigger[0]) 
		{
			nDir *=-1;
			_Map.setInt("dir",nDir);
		}	

		// trigger1:
		int nDirOther = 1;
		if (_Map.hasInt("dirOther"))
			nDirOther = _Map.getInt("dirOther");
		if (_bOnRecalc && _kExecuteKey==sTrigger[1]) 
		{
			nDirOther *=-1;
			_Map.setInt("dirOther",nDirOther );
		}	
					
	// execution loops
		setExecutionLoops(2);

	// stop
		if (_Beam.length() < 2)
		{
			eraseInstance();
			return;				
		}
		
	// assign beam below / above
		Beam bmBelow, bmAbove,bmThis, bmOther[0];
		bmThis= _Beam[0];
		assignToGroups(bmThis);
		Body bdThis = bmThis.realBody();
		bdThis = Body (bdThis.ptCen(), bmThis.vecX(), bmThis.vecY(), bmThis.vecZ(), 
			bdThis.lengthInDirection(bmThis.vecX()) + U(10), bdThis.lengthInDirection(bmThis.vecY()), bdThis.lengthInDirection(bmThis.vecZ()),0,0,0);
		bdThis.transformBy(bmThis.ptCen()-bdThis.ptCen());	
		//bdThis.vis(6);
		for (int i = 1; i < _Beam.length(); i++)
		{
			Body bdOther = _Beam[i].realBody();
			bdOther = Body (bdOther.ptCen(), _Beam[i].vecX(), _Beam[i].vecY(), _Beam[i].vecZ(), 
				bdOther.lengthInDirection(_Beam[i].vecX()), bdOther .lengthInDirection(_Beam[i].vecY()), bdOther .lengthInDirection(_Beam[i].vecZ()),0,0,0);
			bdOther.transformBy(_Beam[i].ptCen()-bdOther.ptCen());	
			//bdOther.vis(i);
			if (bdOther.intersectWith(bdThis))
				bmOther.append(_Beam[i]);
		}
		bmOther = _ZW.filterBeamsPerpendicularSort(bmOther);
		
//	// get tapered width
//		double dWidth=sWidth.atof();
//		if (sWidth.find("%",0)>0)
//		{
//			dWidth = sWidth.left(sWidth.length()-sWidth.find("%",0)+1).trimRight().trimLeft().atof()/100*bmThis.dW();
//		}			
//


		
	// err
		if (bmOther.length()<1)
		{
			if (!_bOnElementDeleted && _bOnElementConstructed)
			{
				reportNotice("\n*****************************************************************\n" + 
				scriptName() + ": " + T("|Incorrect user input.|") + "\n" + 
				T("|At least two beams are required which intersect and \nbelong to an element.|") + "\n" + 
				T("|Tsl will be deleted.|") + "\n" +
				"*****************************************************************");			
			}
			if (!bDebug)eraseInstance();	
			return;
	 	}
		if (bmOther[0].vecX().isParallelTo(bmThis.vecX()))
		{
			if (!_bOnElementDeleted && _bOnElementConstructed)
			{
				reportNotice("\n*****************************************************************\n" + 
				scriptName() + ": " + T("|Incorrect user input.|") + "\n" + 
				T("|Secondary beams may not be parallel to main beam.|") + "\n" + 
				T("|Tsl will be deleted.|") + "\n" +
				"*****************************************************************");	
			}
			if (!bDebug)eraseInstance();	
			return;
	 	}
	
	// append to beams and flag below/above
		int bHasAbove, bHasBelow;	
		for (int i = 0; i < bmOther.length();i++)
		{
			double dDist = vy[0].dotProduct(_Pt0 - bmOther[i].ptCen());
			if (dDist>0)
			{
				bHasBelow=TRUE;
				bmBelow = bmOther[i];
			}
			else if (dDist<0)
			{
				bHasAbove=TRUE;			
				bmAbove= bmOther[i];
			}
		}	

	// tool location
		Point3d ptTool = Line(bmThis.ptCen(), bmThis.vecX()).intersect(Plane(bmOther[0].ptCen(), bmOther[0].vecD(bmThis.vecX())),0);
		_Pt0 = ptTool;
		int nMacro = nMacros[sMacros.find(sMacro,0)];
	
	// diagonal: force identical values for tapering
		if (nMacro==_kCDiagonal)
		{
			dOffsetThis.set(dOffsetOther);
			dOffsetThis.setReadOnly(true);
		}
		
		
		
	// tool vecs
		Vector3d vxThis, vxOther;
		vxThis = ptTool-bmThis.ptCen(); 	vxThis.normalize();
		Point3d ptOtherOnThis = bmOther[0].ptCen() - vy[0] * vy[0].dotProduct(bmOther[0].ptCen()-bmThis.ptCen());
		vxOther= ptTool-ptOtherOnThis ; 	vxOther.normalize();
		vxOther *= nDirOther;
		if(nMacro != _kTIConcave && nMacro != _kTIConvex && nMacro != _kTIDiagonal)
			vxOther *= nDir;
		else
			vxThis *= nDir;			
		ptTool.transformBy(vy[0]*dOffsetVertical);
		vxThis.vis(ptTool,3);	
		vxOther.vis(ptTool,4);

	// collect POI
		Point3d ptTopBelow, ptBottomAbove;
		LineSeg lsBelow = bmBelow.realBody().shadowProfile(Plane(bmBelow.ptCen(), bmBelow.vecX())).extentInDir(vxThis);
		LineSeg lsBelowEnv = bmBelow.envelopeBody().shadowProfile(Plane(bmBelow.ptCen(), bmBelow.vecX())).extentInDir(vxThis);
		lsBelow.vis(3);
		lsBelowEnv.vis(1); 
		
		ptTopBelow = lsBelow.ptMid() + vy[0] * .5*abs(vy[0].dotProduct(lsBelow.ptStart()-lsBelow.ptEnd()));
		ptTopBelow.vis(3);
		
	// dovetailheight
		Element elThis = bmThis.element();
		ElementLog elLogThis = (ElementLog) elThis;
		double dDovetailHeight = 1/3*bmThis.dH()-dTSGap ;	
		double dVisHeight = bmThis.dH();	
		//double dRealHeightThis = bdThis.lengthInDirection(vy[0]);
		if (elLogThis.bIsValid())
		{
			dVisHeight =elLogThis.dVisibleHeight();
			//dRealHeightThis -= elLogThis.dTongue();
			dDovetailHeight = dVisHeight /2 - dTSGap ;//+ elLogThis.dTongue()
		}
		
	// tool offsets
		double dOffsetTool[] = {dOffsetThis,dOffsetOther};
		if (nMacro == 0 || nMacro == 1)
		{
			if (elThis == el[0])
				dOffsetTool.swap(0,1);
		}

	// beamcut above
		if (nMillAbove && bHasBelow && !bHasAbove && (nMacro!=3 && nMacro!=4 &&  nMacro!=5))
		{
			Point3d ptBc = ptTool - vy[0]*vy[0].dotProduct(ptTool-ptTopBelow);
			BeamCut bcBelow(ptBc+vxThis*dExtraLength, vxOther, vy[0].crossProduct(vxOther), vy[0], 2*bmThis.dD(vxOther), bmOther[0].dD(vxThis)+2*dExtraLength, U(500), 0,0,1);
			bcBelow.cuttingBody().vis(3);
			bmThis.addTool(bcBelow);
		}	

	
	// stretch on insert for t-connections
		//if (_bOnDbCreated && (nMacro == 6 || nMacro == 7 || nMacro == 8))
		//	bmThis.addToolStatic(Cut(ptTool + vxThis*.5 * bmOther[0].dD(vxThis), bmOther[0].vecD(vxThis)),2);
	// stretch flag
		int nStretch;
		if(nMacro != _kTIConcave && nMacro != _kTIConvex && nMacro != _kTIDiagonal)
			nStretch  = _kStretchOnInsert;
			

//		// tapered connection
//		double dTaper;
//		if (dWidth>0)
//		{
//			dTaper = bmThis.dD(vxOther)-dWidth;
//			ptTool.transformBy((vxThis+bmThis.vecD(vxOther))*dTaper);
//			ptTool.vis(4);
//		}

	// the tool 
		double dWidthBeamThis = bmThis.dD(vxOther);
		double dWidthBeamOther = bmOther[0].dD(vxThis);
		double dOffsetThis = abs(dOffsetTool[0]);//-dTaper;
		double dOffsetOther = abs(dOffsetTool[1]);
		double dProtrusion = dExtraLength;//-dTaper;
		TirolerSchloss ts(ptTool ,vxThis,vxOther,dWidthBeamThis,dWidthBeamOther, dOffsetThis,dOffsetOther, dDovetailHeight, dDovetailAngle, dProtrusion,nMacro);//[0]);
		bmThis.addTool(ts,nStretch);	

	// additional seat beamcut if seatcut value < 0
		if (dOffsetTool[0]<0 && nMacro != _kCDiagonal)
		{
			Vector3d vecYA = bmThis.vecD(vxOther);
			double dTaperA = dOffsetThis-.5*bmThis.dD(vxOther);
			Vector3d vecYB = bmOther[0].vecD(vxThis);
			double dTaperB = dOffsetThis-.5*bmOther[0].dD(vxThis);
			if(nMacro == _kCConcave)
				dTaperB = -.5*bmOther[0].dD(vxThis);
			Point3d pt;
			int bOk = Line(bmThis.ptCenSolid()+vecYA*dTaperA, vxThis).hasIntersection(Plane(bmOther[0].ptCenSolid()+vecYB*dTaperB, bmOther[0].vecD(vxThis)), pt);
			
			if (bOk)
			{
				BeamCut bc1(pt, vxThis, -vxOther, vxThis.crossProduct(vxOther), bmOther[0].dD(vxThis)+dExtraLength, dOffsetThis*2, bmThis.dD(_ZW)*2,1,1,0);
				bc1.cuttingBody().vis(2);
				bmThis.addTool(bc1);
			}
		}

//	// tapered connection
//		if (dWidth>0)
//		{
//			double dTaperA = dWidth-.5*bmThis.dD(vxOther);
//			Vector3d vecYA = bmThis.vecD(vxOther);
//
//			double dTaperB = dWidth-.5*bmOther[0].dD(vxThis);
//			Vector3d vecYB = bmOther[0].vecD(vxThis);
//
//			Point3d pt;
//			int bOk = Line(bmThis.ptCenSolid()-vecYA*dTaperA, vxThis).hasIntersection(Plane(bmOther[0].ptCenSolid()-vecYB*dTaperB, bmOther[0].vecD(vxThis)), pt);
//		
//			BeamCut bc1(pt, vxThis, -vxOther, vxThis.crossProduct(vxOther), bmOther[0].dD(vxThis), dTaperA*2, bmThis.dD(_ZW)*2,1,1,0);
//			bc1.cuttingBody().vis(3);
//			bmThis.addTool(bc1);
//			
//			Vector3d vecXM = vxThis+vxOther;
//			vecXM.normalize();
//			Vector3d vecYM = vecXM.crossProduct(-_ZW);
//
//			pt.vis(2);		
//			vecXM.vis(pt,1);
//			vecYM.vis(pt,3);
//			
//			int dYFlag = vecYM.dotProduct(vxOther)<0?1:-1;
//			BeamCut bc2(pt, vecXM, vecYM, _ZW, dTaperA*2, dTaperA*2, bmThis.dD(_ZW)*2,-1,dYFlag,0);
//			bc2.cuttingBody().vis(3);
//			bmThis.addTool(bc2);
//		}
		
		
		
	// Display
		Display dp(nColor);//[0]);
		//dp.draw(scriptName(),ptTool, _XW,_YW, 0,0,_kDeviceX);
		
	// PlaneProfile	
		PlaneProfile pp;
		
		if (nMacro == 3 || nMacro == 4 || nMacro == 5)
			pp = bmThis.realBody().getSlice(Plane(ptTool, vxThis));			
		else
			pp = bmThis.realBody().extractContactFaceInPlane(Plane(ptTool+vxThis *(0.5*bmOther[0].dD(vxThis)+dProtrusion), vxThis),U(1000));
		dp.draw(pp);
		if (dExtraLength > 0)
		{
			LineSeg ls = pp.extentInDir(vxOther);
			PLine pl(ls.ptMid(),ls.ptMid()-vxThis*dExtraLength );
			dp.draw(pl);	
		}
	}
	
	











#End
#BeginThumbnail
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
.!B"T<84D=.!5BB@#_]GZ
`


#End