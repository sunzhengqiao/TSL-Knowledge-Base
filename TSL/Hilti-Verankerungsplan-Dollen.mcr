#Version 8
#BeginDescription
#Versions:
Version 1.11 28.10.2025 HSB-24831: Changes for Baufritz (Markus Sailer) , Author: Marsel Nakuci
Version 1.10 08.10.2024 HSB-22780: Export circle objects for HCWL+K , Author Marsel Nakuci
1.9 23/08/2024 HSB-19771: Support "hsbCLT-Hilti" 
1.8 06/05/2024 HSB-21970: Fix groups for Baufritz 
1.7 12.02.2024 HSB-21338: Add property "Nr connectors" to show nr of connectors 
1.6 19.09.2023 20230919: Fix when gathering groups 
1.5 15.03.2023 HSB-18322: add folder name at the exported dwg of verankerungsplan 
1.4 15.03.2023 HSB-18322: add nr of Verankerungen at the dwg name when it is exported
1.3 13.01.2023 HSB-17527: scale back plines after transforming during dwg export 
1.2 12.01.2023 HSB-17527: Make sure selected polylines are valid closed polylines
1.1 12.01.2023 HSB-17527: generate dwg to 0,0,0
1.0 10.01.2023 HSB-17499: Initial











#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 11
#KeyWords Stexon,Dollen,Plan,Verankerung,Hilti,Baufritz
#BeginContents
/// <summary Lang=de>
/// Dieses TSL erzeugt einen Verankerungsplan mit Dollen und Polylinien. 
/// Über das Kontextmenü kann dieser Verankerungsplan als DXF Datei exportiert werden.
/// Beim Einfügen wird eine Etagengruppe mit Dollen gewählt, Polylinien können optional hinzugefügt werden (Kontext)
/// Es wird eine Untergruppe 'DXF Dollen' in der jeweiligen Etagengruppe erzeugt.
/// </summary>

/// <insert Lang=de>
/// Beim Einfügen ist eine Gruppe zu wählen.
/// </insert>

/// History
/// #Versions:
// 1.11 28.10.2025 HSB-24831: Changes for Baufritz (Markus Sailer) , Author: Marsel Nakuci
// 1.10 08.10.2024 HSB-22780: Export circle objects for HCWL+K , Author Marsel Nakuci
// 1.9 23/08/2024 HSB-19771: Support "hsbCLT-Hilti" Marsel Nakuci
// 1.8 06/05/2024 HSB-21970: Fix groups for Baufritz Marsel Nakuci
// 1.7 12.02.2024 HSB-21338: Add property "Nr connectors" to show nr of connectors Author: Marsel Nakuci
// 1.6 19.09.2023 20230919: Fix when gathering groups Author: Marsel Nakuci
// 1.5 15.03.2023 HSB-18322: add folder name at the exported dwg of verankerungsplan Author: Marsel Nakuci
// 1.4 15.03.2023 HSB-18322: add nr of Verankerungen at the dwg name when it is exported Author: Marsel Nakuci
// 1.3 13.01.2023 HSB-17527: scale back plines after transforming during dwg export Author: Marsel Nakuci
// 1.2 12.01.2023 HSB-17527: Make sure selected polylines are valid closed polylines Author: Marsel Nakuci
// 1.1 12.01.2023 HSB-17527: generate dwg to 0,0,0 Author: Marsel Nakuci
// 1.0 10.01.2023 HSB-17499: Initial Author: Marsel Nakuci
// 2.1 28.09.2022 HSB-16670: Allow Hilti-Verankerung Author: Marsel Nakuci
///<version value="2.0" date=24apr19" author="thorsten.huck@hsbcad.com"> alle Kombinationen möglich, Kontextbefehle im Hauptlevel </version>//
///<version value="1.9" date=13mar19" author="thorsten.huck@hsbcad.com"> Standardgruppen + EG und Garage Kombination </version>//
///<version value="1.8" date=13mar19" author="thorsten.huck@hsbcad.com"> EG und Garage wird kombiniert </version>
///<version value="1.7" date=26oct18" author="thorsten.huck@hsbcad.com"> BF-Stexon-Verankerung ergänzt   </version>
///<version value="1.6" date="16mar16" author="th@hsbCAD.de"> Ausgabe in [m] skaliert </version>
///<version value="1.5" date="17mar16" author="th@hsbCAD.de"> Dollenpunkte werden als Punkte in DXF-Datei exportiert (erfordert 20.1.65.0 oder höher)</version>
///<version value="1.4" date="16mar16" author="th@hsbCAD.de"> neue Kontextbefehle zur Definition von Referenzpunkten, Ausgabe skaliert 1:25 und um 90° gedreht </version>
///<version value="1.3" date="05may15" author="th@hsbCAD.de"> Stexon ergänzt </version>
///<version value="1.2" date="09mar15" author="th@hsbCAD.de"> Bezugspunkt wird in die Ebene Z-Welt projiziert </version>
///<version value="1.1" date="06oct14" author="th@hsbCAD.de"> Punkte der Dollen werden in die Ebene Z-Welt projiziert </version>
///<version value="1.0" date="12feb13" author="th@hsbCAD.de"> initial</version>

//region constants 
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
	String sProjectSpecial=projectSpecial();
	sProjectSpecial.makeUpper();
	int bIsBaufritz=sProjectSpecial=="BAUFRITZ";
//end constants//endregion

//region Functions
//region checkHiltiClt
	// gets only thos that are inserted to one panel and point upward in _ZW
	//HSB-19771
	int checkHiltiClt(TslInst _tsl)
	{ 
		int _ok=true;
		// check name
		if(_tsl.scriptName()!="hsbCLT-Hilti")
		{ 
			_ok=false;
			return _ok;
		}
		// check it is at single panel
		Sip _sipsTsl[]=_tsl.sip();
		if(_sipsTsl.length()!=1)
		{ 
			_ok=false;
			return _ok;
		}
		Vector3d _vecUp=_tsl.map().getVector3d("vecUp");
		if(abs(_vecUp.dotProduct(_ZW)-1.0)>dEps)
		{ 
			_ok=false;
			return _ok;
		}
		return _ok;
	}
//End checkHiltiClt//endregion
//End Functions//endregion 

//	String sScriptNames[] = {"BF-Dollen".makeUpper(),"BF-Stexon".makeUpper(), "BF-Stexon-Verankerung".makeUpper(),"Hilti-Verankerung".makeUpper()};
	String sScriptNames[] = {"Hilti-Verankerung".makeUpper(),"hsbCLT-Hilti".makeUpper()};
	double dSize = U(300);
	int nColor = 10;
	int nColorRef = 2;
	
// collect all dollen instances and relevant groups
	Entity ents[0];
	TslInst tsls[0];
	ents = Group().collectEntities(true,TslInst(),_kModelSpace);
	String sFloors[0];// just the level
	String sFloorsFull[0];
	for(int i=0;i<ents.length();i++)
	{
		TslInst tsl = (TslInst)ents[i];
		String s = tsl.scriptName();
		if (sScriptNames.find(s.makeUpper())>-1)
		{
			//HSB-19771
			if(tsl.scriptName()!="hsbCLT-Hilti")
			{ 
				// collect all verankerung tsls
				tsls.append(tsl);
			}
			else if(tsl.scriptName()=="hsbCLT-Hilti")
			{ 
				if(checkHiltiClt(tsl))
					tsls.append(tsl); // collect all dollen tsls
			}
			String sFloorGroupName,sFloorGroupNameFull ;
			Element elTsl = tsl.element();
			Group group;
			if (elTsl.bIsValid())
			{
				group = elTsl.elementGroup();
				sFloorGroupName = group.namePart(1);
				sFloorGroupNameFull = group.namePart(0)+"\\" + sFloorGroupName;
			}
			else
			{
				Group gr[] = tsl.groups();
				if (gr.length()>0)
				{
					group = gr[0];
					sFloorGroupName = gr[0].namePart(1);
					sFloorGroupNameFull = gr[0].namePart(0)+"\\" + sFloorGroupName;						
				}	
			}
			if (sFloorGroupName!="" && sFloors.find(sFloorGroupName)<0)
			{
				sFloors.append(sFloorGroupName);	
				sFloorsFull.append(sFloorGroupNameFull);	
			}			
		}	
	}	
	
// check if EG and Garage can be combined
	int nIndEG=-1, nIndGarage=-1;
	for (int i=0;i<sFloors.length();i++) 
	{ 
		String s = sFloors[i];
		s.makeUpper();
		if (s == "EG")nIndEG = i;
		else if (s == "GARAGE")nIndGarage = i;
		// HSB-24831
		if(bIsBaufritz)
		{ 
			if (s == "EG" || s.right(2) == "EG")nIndEG = i;
			else if (s == "GARAGE" || s.right(6) == "GARAGE")nIndGarage = i;
		}
		
		if (nIndEG>0 && nIndGarage>0)break; 
	}//next i
	if(nIndEG>-1 && nIndGarage>-1)
		sFloors.append(sFloors[nIndEG] + "_" + sFloors[nIndGarage]);

// order alphabetically
	for (int i=0;i<sFloors.length();i++) 
		for (int j=0;j<sFloors.length()-1;j++) 
			if (sFloors[j]>sFloors[j+1])
				sFloors.swap(j,j+1);


	String sFloorName=T("|Floor name|");	
	PropString sFloor(nStringIndex++,sFloors,sFloorName);	
	sFloor.setDescription(T("|Defines the floor group|"));
	sFloor.setCategory(category);
// HSB-21338
	String sNrConnectorsName=T("|Nr Connectors|");
	int nNrConnectorss[]={1,2,3};
	PropInt nNrConnectors(nIntIndex++, 0, sNrConnectorsName);	
	nNrConnectors.setDescription(T("|Defines/shows the Nr. of Connectors|"));
	nNrConnectors.setCategory(category);
	nNrConnectors.setReadOnly(_kReadOnly);
	
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) {eraseInstance();return;}

		showDialog();	
		
	// declare the tsl props
		TslInst tslNew;
		Vector3d vUcsX=_XW;
		Vector3d vUcsY=_YW;
		GenBeam gbAr[0];
		Entity entAr[0];
		Point3d ptAr[0];
		int nArProps[]={nNrConnectors};
		double dArProps[0];
		String sArProps[]={sFloor};
		Map mapTsl;
		String sScriptname=scriptName();			

		ptAr.append(_PtW);
		
		tslNew.dbCreate(sScriptname,vUcsX,vUcsY,gbAr,entAr,ptAr, 
					nArProps,dArProps,sArProps,_kModelSpace,mapTsl);
		
		eraseInstance();
		return;
	}	
// END ON bOnInsert____________________________________________________________________________________________________________________________________________
	
// report prefix
	String sReportPrefix=scriptName()+ ": "; 
	Plane pnW(_PtW,_ZW);
	pnW.vis(3);

	
// get relevant groups
	Group groups[0];
	String sGroupTokens[]=sFloor.tokenize("_");
	for (int i=0;i<sGroupTokens.length();i++) 
	{ 
		String sGroupToken=sGroupTokens[i]; 
		
		for (int j=0;j<sFloorsFull.length();j++) 
		{ 
			String sTokens[]=sFloorsFull[j].tokenize("\\");
			//  HSB-21970
			if(!bIsBaufritz)
			{ 
				// 20230919: Fix when gathering groups
	//			if (sTokens.length()>1 && sGroupToken==sTokens[1])
				{
					groups.append(Group(sFloorsFull[j]));				
				}
			}
			else if(bIsBaufritz)
			{ 
				if (sTokens.length()>1 && sGroupToken==sTokens[1])
				{
					groups.append(Group(sFloorsFull[j]));				
				}
			}
		}//next j
	}//next i

// validate
	if (groups.length()<1)
	{
		reportMessage("\n" + sReportPrefix + " definierte Gruppe ungültig." + " " + T("|Tool will be deleted.|"));	
		//eraseInstance();
		return;
	}
	Group grFloor=groups[0];

// declare/assign to dxf group
	Group grDxf(grFloor.namePart(0)+"\\"+ grFloor.namePart(1) + "\\" + "DXF Dollen");
	if (!grDxf.bExists())grDxf.dbCreate();
	grDxf.addEntity(_ThisInst, true,0,'I');

// remove dollen on property change
	if (_kNameLastChangedProp==sFloorName)
	{ 
		_Map.removeAt("Location[]", true);
		for (int i=_Entity.length()-1;i>=0;i--)
		{ 
			TslInst t=(TslInst)_Entity[i]; 
			if (t.bIsValid() && sScriptNames.find(t.scriptName().makeUpper())>-1)
				_Entity.removeAt(i);
		}//next i
	}

// collect all dollen instances
	for (int j=0;j<groups.length();j++) 
	{ 
		//Entity _ents[] = groups[j].collectEntities(true,TslInst(),_kModelSpace);	
		for(int i=0;i<tsls.length();i++)
		{
			Group _groups[]=tsls[i].groups();
			for (int g=0;g<_groups.length();g++) 
			{ 
				String s1=_groups[g].namePart(0)+"\\"+_groups[g].namePart(1);
				String s2=groups[j].name();
				
				if (_Entity.find(tsls[i])<0 && s1==s2)
					_Entity.append(tsls[i]);
			}//next g	
		}
	}//next j
	
	// HSB-19771: cleanup _Entity
	for (int e=_Entity.length()-1; e>=0 ; e--) 
	{ 
		TslInst tslE=(TslInst)_Entity[e];
		if(tslE.bIsValid())
		{ 
			if(tsls.find(tslE)<0)
			{ 
				// remove from _Entity tsls not part of tsls
				_Entity.removeAt(e);
			}
		}
	}//next e
	

// add pline collection trigger
	String sTriggerAddPLine=T("|Add Polyline(s)|");
	addRecalcTrigger(_kContext, "../"+sTriggerAddPLine);	
	if (_bOnRecalc && (_kExecuteKey==sTriggerAddPLine || _kExecuteKey=="../"+sTriggerAddPLine)) 
	{
	// selection set
		Entity entPLines[0];
		PrEntity ssE(T("|Select Polyline(s)|"), EntPLine());	
		if (ssE.go())
			entPLines=ssE.set();
		for (int i=0;i<entPLines.length();i++)
		{	
			EntPLine epl=(EntPLine)entPLines[i];
			if (epl.bIsValid() && _Entity.find(epl)<0)
			{
				epl.setColor(nColor);
				grDxf.addEntity(epl,true,0,'I');
				_Entity.append(epl);
			}
		}
	}

// remove pline collection trigger
	String sTriggerRemovePLine = T("|Remove Polyline(s)|");
	addRecalcTrigger(_kContext, "../"+sTriggerRemovePLine);	
	if (_bOnRecalc && (_kExecuteKey==sTriggerRemovePLine || _kExecuteKey=="../"+sTriggerRemovePLine)) 
	{
	// selection set
		Entity entPLines[0];
		PrEntity ssE(T("|Select Polyline(s)|"), EntPLine());	
		if (ssE.go())
			entPLines=ssE.set();
		for (int i=0;i<entPLines.length();i++)
		{	
			int n=_Entity.find(entPLines[i]);
			if (n>-1)
			{
				entPLines[i].setColor(0);
				_Entity.removeAt(n);
			}	
		}				
	}

// set ref points for diagonal dimensions
	Point3d ptsRef[0];
	ptsRef=_Map.getPoint3dArray("RefLocation[]");
	String sTriggerSetRef = T("|Set reference point(s)|");
	addRecalcTrigger(_kContext, "../"+sTriggerSetRef);	
	if (_bOnRecalc && (_kExecuteKey==sTriggerSetRef || _kExecuteKey=="../"+sTriggerSetRef)) 
	{
		Point3d pts[0];
		while(1)
		{
			PrPoint ssP("\n" + T("|Specify location|"));
			if (ssP.go()==_kOk)
				pts.append(ssP.value());
			else
				break;
		}
		pts=pnW.projectPoints(pts);
	
	// append ref locations
		for (int i=0;i<pts.length();i++)
			ptsRef.append(pts[i]);	
		_Map.setPoint3dArray("RefLocation[]", ptsRef);	
	}

// remove ref points for diagonal dimensions
	String sTriggerRemoveRef = T("|Remove reference point(s)|");
	if (ptsRef.length()>0)
		addRecalcTrigger(_kContext, "../"+sTriggerRemoveRef);	
	if (_bOnRecalc && (_kExecuteKey==sTriggerRemoveRef || _kExecuteKey=="../"+sTriggerRemoveRef))
	{
		Point3d pts[0];
		PrPoint ssP("\n" + T("|Specify location|") + ", " + T("|<Enter> to remove all|"));
		while(1)
		{
			if (ssP.go()==_kOk)
				pts.append(ssP.value());
			else
			{
			// remove all	
				if (pts.length()==0)
				{
					_Map.removeAt("RefLocation[]", true);
					setExecutionLoops(2);
					return;	
				}
			// break prompting for points
				break;
			}
			ssP=PrPoint ("\n" + T("|Specify location|"));	
		}
		pts=pnW.projectPoints(pts);
	
	// remove ref locations if near to selected point
		for (int i=pts.length()-1;i>=0;i--)
			for (int j=ptsRef.length()-1;j>=0;j--)
			{
				if (Vector3d(pts[i]-ptsRef[j]).length()<=.5*dSize)
				{
					ptsRef.removeAt(j);	
					break; // breaking j
				}
			}
		_Map.setPoint3dArray("RefLocation[]", ptsRef);	
	}


// err
	if (_Entity.length()<1)
	{
		reportMessage("\n" + sReportPrefix + " Es konnten keine Dollen gefunden werden." + " " + T("|Tool will be deleted.|"));				
		eraseInstance();
		return;
	}

// loop entities to set dependency and collect dollen locations
	Point3d pts[0];
	//TslInst tsls[0];
	PLine plines[0];
	
	
// HSB-17527: cleanup open polylines
	for (int i=_Entity.length()-1; i>=0;i--) 
	{ 
		EntPLine epl=(EntPLine)_Entity[i];
		if(epl.bIsValid())
		{ 
			PLine pl=epl.getPLine();
			if(!pl.isClosed())
			{ 
				_Entity.removeAt(i);
			}
		}
	}//next i
	
	int nVersion[0];
	for (int i=0;i<_Entity.length();i++)
	{
		Entity ent=_Entity[i];
		setDependencyOnEntity(ent);
		if (ent.bIsKindOf(TslInst()))
		{
			TslInst tsl=(TslInst)ent;
			if(bIsBaufritz)
			{ 
				// HSB-22780
				String sVersion = tsl.propString(0);
				// HSB-24831
				if(sVersion=="HCWL+K")
					nColor =4;
				else
					nColor =1;
			}
			
			if(tsl.scriptName()!="hsbCLT-Hilti")
			{ 
				//tsls.append(tsl);
				pts.append(tsl.ptOrg());
				nVersion.append(nColor);
			}
			else if(tsl.scriptName()=="hsbCLT-Hilti")
			{ 
				// HSB-19771 hilti tsl
				// get the points when distribution
//				pts.append(tsl.ptOrg());
				Map mapTsl=tsl.map();
				if(mapTsl.hasPoint3dArray("ptsDis"))
				{ 
					pts.append(mapTsl.getPoint3dArray("ptsDis"));
				}
			}
		}
		else if(ent.bIsKindOf(EntPLine()))
		{
			EntPLine epl=(EntPLine)ent;
			PLine pl=epl.getPLine();
			pl.projectPointsToPlane(pnW,_ZW);
			plines.append(pl);
		}
	}// next i _Entity
		

// store all points in map, identify ref locations
	pts=pnW.projectPoints(pts);
	for (int j=0;j<ptsRef.length();j++)
	{
		Point3d ptRef=ptsRef[j];
		ptRef.vis(2);
		for (int i=0;i<pts.length();i++)
			if (Vector3d(ptRef-pts[i]).length()<=.5*dSize)
			{
				pts[i].setZ(U(1));
				break;
			}
	}	
	_Map.setPoint3dArray("Location[]", pts);

// declare shopdrawing dimRequests
	Map mapRequests,mapRequest;
	mapRequest.setInt("Color",nColor);
	mapRequest.setVector3d("AllowedView",_ZW);
		
	PlaneProfile ppBounds(CoordSys(_PtW,_XW,_YW,_ZW));
	PLine plBounds;
	plBounds.createConvexHull(pnW,pts);
	ppBounds.joinRing(plBounds,_kAdd);
	
// plan display
	Display dp(nColor),dpDxf(nColor);
	
// plines collection
	PLine plOuts[0];
	LineSeg segOuts[0];
		
// draw points
	Vector3d vxCross=_XW+_YW; vxCross.normalize();
	Vector3d vyCross=-_XW+_YW; vyCross.normalize();
	for (int i=0;i<pts.length();i++)
	{
		if(bIsBaufritz)
			nColor = nVersion[i];// HSB-24831
		
		int c=nColor;
		
		Point3d pt=pts[i];
		if (pt.Z()>0)
			c=nColorRef;	
		dp.color(c);
		pt=pt.projectPoint(pnW,0);

		PLine plPlan1(pt+.5*vxCross*dSize,pt-.5*vxCross*dSize);
		PLine plPlan2(pt+.5*vyCross*dSize,pt-.5*vyCross*dSize);
		dp.draw(plPlan1);
		dp.draw(plPlan2);
		
		// draw point as zero length segment
		//plOuts.append(plPlan1);
		//plOuts.append(plPlan2);
		segOuts.append(LineSeg(pt,pt));
				
		mapRequest.setInt("Color", c);
		mapRequest.setInt("DrawFilled", 0);
		mapRequest.setPLine("pline", plPlan1);
		mapRequests.appendMap("DimRequest",mapRequest);	
		mapRequest.setPLine("pline", plPlan2);
		mapRequests.appendMap("DimRequest",mapRequest);			
		
	}
// HSB-21338
	nNrConnectors.set(pts.length());
	
// draw plines
	mapRequest.setInt("Color", nColor);
	for (int i=0;i<plines.length();i++)
	{
		plines[i].projectPointsToPlane(pnW,_ZW);
		plOuts.append(plines[i]);
		dp.draw(plines[i]);
		
		mapRequest.setInt("DrawFilled",0);
		mapRequest.setPLine("pline",plines[i]);
		mapRequests.appendMap("DimRequest",mapRequest);	
		ppBounds.joinRing(plines[i],_kAdd);
		dp.draw(Body(plines[i],_ZW*dEps,-1));
	}	
	_Map.setMap("DimRequest[]", mapRequests);


// get a point outside to draw a little box
	LineSeg seg=ppBounds.extentInDir(_XW);	
	double dX=abs(_XW.dotProduct(seg.ptStart()-seg.ptEnd()));
	double dY=abs(_YW.dotProduct(seg.ptStart()-seg.ptEnd()));
	_Pt0=seg.ptMid()-.5*(_XW*dX-_YW*dY);
	dp.draw(Body(seg.ptMid(),_XW,_YW,_ZW,dEps,dEps,dEps,0,0,0));
	
// set transformation to scale 1/25 and rotation
	if (_bOnDebug)
	{
		CoordSys csDxf;
		csDxf.setToAlignCoordSys(_Pt0, _XW,_YW,_ZW, _PtW, _YW*.25,-_XW*.25, _ZW*.25 );
		for (int i=0;i<plOuts.length();i++)
		{
			PLine pl = plOuts[i];
			pl.transformBy(csDxf);
			pl.vis(161);	
		}
	}

//// create dxf file
//	String sTriggerCreateDxf= T("|Create Dxf File|");
//	addRecalcTrigger(_kContext, "../"+sTriggerCreateDxf);	
//	if (_bOnRecalc && (_kExecuteKey==sTriggerCreateDxf || _kExecuteKey=="../"+sTriggerCreateDxf))	
//	{
//		CoordSys csDxf;
//		csDxf.setToAlignCoordSys(_Pt0, _XW,_YW,_ZW, _PtW, _YW*0.001,-_XW*0.001, _ZW*0.001 );
//		for (int i=0;i<plOuts.length();i++)
//		{
//			plOuts[i].transformBy(csDxf);
//			dpDxf.draw(plOuts[i]);
//		}
//		for (int i=0;i<segOuts.length();i++)
//		{
//			segOuts[i].transformBy(csDxf);
//			dpDxf.draw(segOuts[i]);
//		}		
//
//
//		String sFullPath = _kPathDwg + "\\";
//		if (grFloor.namePart(1).length()>0)
//			sFullPath+=grFloor.namePart(1)+"-";
//		sFullPath+="Verankerungsplan.dxf";
//		dpDxf.writeToDxfFile(sFullPath , false, _kVersion2000);
//	}
	String sDwgPath=_kPathDwg;
		String sTokens[]=sDwgPath.tokenize("\\");
	
//region Trigger CreateDwgFile
	String sTriggerCreateDwgFile = T("|Create Dwg File|");
	addRecalcTrigger(_kContextRoot, sTriggerCreateDwgFile );
	if (_bOnRecalc && _kExecuteKey==sTriggerCreateDwgFile)
	{
	// export the circles in a dwg
		// HSB-17527
		CoordSys csDxf;
		csDxf.setToAlignCoordSys(_Pt0,_XW,_YW,_ZW,
			_PtW,_YW*0.001,-_XW*0.001,_ZW*0.001);
		CoordSys csDxfInv=csDxf;
		csDxfInv.invert();
//	BlockRef bref;
		String sBlockName="Hilti-Verankerungsplan-Dollen";
		Block blockTest(sBlockName);
		if(_BlockNames.find(sBlockName)<0)
		{ 
			blockTest.dbCreate();
		}
		EntCircle entCircles[0];
		// HSB-22780
		int nVersion;
		for (int i=0;i<_Entity.length();i++)
		{
			Entity ent = _Entity[i];
			if (ent.bIsKindOf(TslInst()))
			{
			// TSL Hilti-Verankerung
				TslInst tsl = (TslInst)ent;
				if(tsl.scriptName()!="hsbCLT-Hilti")
				{ 
				// draw the entCircle
					EntCircle entCircle;
					entCircle.dbCreate(tsl.ptOrg(),_ZW,tsl.propDouble(0));
					entCircle.transformBy(csDxf);
					if(bIsBaufritz)
					{ 
						String sVersion=tsl.propString(0);
						if(sVersion=="HCWL+K")
						{ 
							entCircle.setColor(4);
							EntCircle entCircle1;
							entCircle1.dbCreate(tsl.ptOrg(),_ZW,U(20));
							entCircle1.setColor(1);
							entCircle1.transformBy(csDxf);
							entCircles.append(entCircle1);
							blockTest.addEntity(entCircle1);
							nVersion=nVersion+1;
						}
					}
					
					entCircles.append(entCircle);
					blockTest.addEntity(entCircle);
				}
				else if(tsl.scriptName()=="hsbCLT-Hilti")
				{ 
					// HSB-19771
					Point3d ptsTsl[]=tsl.map().getPoint3dArray("ptsDis");
					for (int p=0;p<ptsTsl.length();p++) 
					{ 
						EntCircle entCircle;
						// HCWL for panels
						entCircle.dbCreate(ptsTsl[p],_ZW,U(42));
						entCircle.transformBy(csDxf);
						entCircles.append(entCircle);
						blockTest.addEntity(entCircle); 
					}//next p
				}
			}
			else if(ent.bIsKindOf(EntPLine()))
			{
				EntPLine epl = (EntPLine)ent;
				epl.transformBy(csDxf);
				blockTest.addEntity(epl);
			}
		}// next i _Entity
		
	//  Export to the working directory
		String sFullPath = _kPathDwg + "\\";
	// 
		String sDwgPath=_kPathDwg;
		String sTokens[]=sDwgPath.tokenize("\\");
		if(sTokens.length()>1)
		{ 
			sFullPath+=sTokens[sTokens.length()-2]+"_";
		}
	// 
		if (grFloor.namePart(1).length()>0)
			sFullPath+=grFloor.namePart(1)+"-";
	// HSB-18322: add nr of parts exprted
		if(!bIsBaufritz)
		{
			sFullPath+="Verankerungsplan"+"_"+entCircles.length()+" Stück"+".dwg";
		}
		else if(bIsBaufritz)
		{ 
			String sText=entCircles.length() + " Stück" + ".dwg";
			sText = (entCircles.length()- nVersion- nVersion) + "+" + nVersion + " Stück" + ".dwg";
			sFullPath+="Verankerungsplan"+"_"+sText;
		}
		blockTest.writeToDwg(sFullPath);
		
		// transform plines back to where they were
		for (int i=0;i<_Entity.length();i++)
		{
			Entity ent = _Entity[i];
			if(ent.bIsKindOf(EntPLine()))
			{
				EntPLine epl = (EntPLine)ent;
				epl.transformBy(csDxfInv);
			}
		}// next i _Entity
		
	// dberase the created circles
		for (int i=entCircles.length()-1; i>=0 ; i--) 
		{ 
			entCircles[i].dbErase();
		}//next i
	// dbErase
		blockTest.dbErase();
		setExecutionLoops(2);
		return;
	}//endregion	









#End
#BeginThumbnail













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
        <int nm="BreakPoint" vl="160" />
        <int nm="BreakPoint" vl="134" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24831: Changes for Baufritz (Markus Sailer)" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="10/28/2025 9:44:51 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22780: Export circle objects for HCWL+K" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="10/8/2024 8:52:58 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19771: Support &quot;hsbCLT-Hilti&quot;" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="8/23/2024 10:11:30 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21970: Fix groups for Baufritz" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="5/6/2024 2:35:32 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21338: Add property &quot;Nr connectors&quot; to show nr of connectors" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="2/12/2024 8:41:27 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="20230919: Fix when gathering groups" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="9/19/2023 3:27:56 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18322: add folder name at the exported dwg of verankerungsplan" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="3/15/2023 11:33:16 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18322: add nr of Verankerungen at the dwg name when it is exported" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="3/15/2023 9:42:23 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17527: scale back plines after transforming during dwg export" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="1/13/2023 8:00:02 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17527: Make sure selected polylines are valid closed polylines" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="1/12/2023 11:37:53 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17527: generate dwg to 0,0,0" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="1/12/2023 9:17:50 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17499: Initial" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="1/10/2023 10:51:39 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End