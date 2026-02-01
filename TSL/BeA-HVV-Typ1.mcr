#Version 8
#BeginDescription
#Versions
Version 2.5 21.12.2021 HSB-14106 display published for hsbMake and hsbShare

version value="2.4" date=04may17" author="thorsten.huck@hsbcad.com"
Hardware component added 

/// Diese TSL fügt einen BeA HVV Typ 1 ein
/// This tsl creates a connector of type BeA HVV Type 1














#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 5
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Diese TSL fügt einen BeA HVV Typ 1 ein
/// </summary>
/// <summary Lang=de>
/// This tsl creates a connector of type BeA HVV Type 1
/// </summary>

/// History
// #Versions
// 2.5 21.12.2021 HSB-14106 display published for hsbMake and hsbShare , Author Thorsten Huck
///<version value="2.4" date=04may17" author="thorsten.huck@hsbcad.com"> Hardware component added </version>
/// Version 2.3  14.02..2013   th@hsbCAD.de
/// new assignment method: the instance can be assigned to the male or the female dependency. this can be the beam or the element on which the beam is dependent
/// Version 2.2  14.12.2012   th@hsbCAD.de
/// the Info-layer is the default layer on which the entity is drawn
/// Version 2.1  27.05.2011   th@hsbCAD.de
/// bugfix color on insert
/// Version 2.0  09.12.2010   th@hsbCAD.de
/// version compatibility bugfix
/// Version 1.9  30.11.2010   th@hsbCAD.de
/// color bugfix
/// Version 1.8  30.11.2010   th@hsbCAD.de
/// item export reduced to scriptname
/// Version 1.7  30.11.2010   th@hsbCAD.de
/// multiple connection added. 
/// One can chosse between all possible variatrions to connect two beams by multiple angle brackets
/// Version 1.6  23.09.2010   th@hsbCAD.de
/// item added
/// Version 1.5  04.02.2010   th@hsbCAD.de
/// TSLBOM published
/// Version 1.4  18.11.2009   th@hsbCAD.de
/// Content Standardisierung
/// Version 1.3   31.01.2008   th@hsbCAD.de
/// Version 1.2   25.01.2008   th@hsbCAD.de
/// Version 1.1   10.01.2008   th@hsbCAD.de

// basics and props
	U(1,"mm");
	String sArNY[] = { T("No"), T("Yes")};
	//PropInt nXX(0, 0, T("Int"));
	//PropDouble dWidth(0, 0, T("Double"));
	
	double dArA[]= {U(40),U(40),U(40),U(50),U(60),U(60),U(60),U(60),U(40),U(40),U(40),U(60),U(60),U(60),U(60),U(60),U(60),U(60),U(80),U(80),U(80),U(80),U(80),U(80),U(80),U(80),U(80),U(80),U(80),U(80),U(100),U(100),U(100),U(100),U(100),U(100),U(100),U(100),U(100),U(100),U(100),U(120),U(120),U(120),U(120),U(120)};
	double dArB[]= {U(40),U(40),U(40),U(50),U(60),U(60),U(60),U(60),U(40),U(40),U(60),U(60),U(60),U(60),U(60),U(60),U(60),U(80),U(80),U(80),U(80),U(80),U(80),U(80),U(80),U(80),U(80),U(80),U(80),U(80),U(100),U(100),U(100),U(100),U(100),U(200),U(100),U(100),U(100),U(100),U(100),U(120),U(120),U(120),U(120),U(120)};
	double dArC[]= {U(2),U(2),U(2),U(2),U(2),U(2),U(2),U(2),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2),U(2),U(2),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(3),U(3),U(3),U(3),U(3),U(3),U(3),U(3),U(3),U(3)};
	double dArD[]= {U(20),U(40),U(60),U(40),U(40),U(60),U(80),U(100),U(40),U(60),U(60),U(40),U(50),U(60),U(80),U(100),U(120),U(60),U(40),U(60),U(80),U(40),U(60),U(80),U(100),U(120),U(140),U(160),U(180),U(200),U(40),U(60),U(80),U(100),U(120),U(100),U(40),U(60),U(80),U(100),U(120),U(40),U(60),U(80),U(100),U(120)};		

	String sArModel[0];
	for (int i = 0; i < dArA.length(); i++)
		sArModel.append(dArA[i] +" x " + dArB[i] + " x " + dArC[i] + " x " + dArD[i]);

	PropString sModel(1, sArModel, T("|Model|"));	
	int nArSide[] = {1,2,3,4};
	PropInt nSide(0,nArSide,T("|Side|"));

	String sArMulti[] = {T("|Single Side|"), T("|Two opposite Sides|"),T("|Two neighbouring Sides|"),T("|Three Sides|") ,T("|Four Sides|")};
	PropString sMulti(2,sArMulti, T("|multiple Insertion|"),0);	
	int nArQtyMulti[] = {1,2,2,3,4};
	PropDouble dSnap (0, U(20), T("|hsbIntelliSnap|"));
	PropString sDimStyle(0, _DimStyles, T("Dimstyle"));	
	PropInt nColor(1,254, T("|Color|"));

// on insert
	if (_bOnInsert)
	{
		showDialog();	
		
		Beam bm[0];		

		PrEntity ssE(T("|Select beams|"), Beam());
		ssE.addAllowedClass(TslInst());
		Entity ents[0];
		if (ssE.go())
			ents= ssE.set();

		// declare TSL Props
		TslInst tsl;
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		Beam lstBeams[2];			// T-connection will be always made with 2 beams
		Entity lstEnts[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		
		// detect mode
		int nMode; // 0 = beam, 1 = tsl detail
		for (int i = 0; i<ents.length();i++)
		{
			if(ents[i].bIsKindOf(TslInst()))
			{
				TslInst tsl;
				tsl = (TslInst)ents[i];
				String sScriptName = tsl.scriptName();	
				sScriptName.makeUpper();
				if (sScriptName.find("DETAILGENBEAM",0)>-1)
				{
					//_Pt0 = getPoint();
					lstEnts.append(tsl);
					nMode =1;
					break;
				}
			}
			else if(ents[i].bIsKindOf(Beam()))	
				bm.append((Beam)ents[i]);
		}

		//append beams
		
		// remove comments and add properties with correct enumeration
		//lstPoints.append(ptYourPoint);
		lstPropInt.append(nSide);
		lstPropInt.append(nColor);
			
		lstPropDouble.append(dSnap);
		lstPropString.append(sDimStyle);
		lstPropString.append(sModel);	
	
		Map mapTsl;
		mapTsl.setInt("Mode",nMode);
		
			
		
		if (nMode==0) // Beam T-Connection
		{
			if (bm.length() == 1)// jumps to special insert
			{
				_Beam.append(bm[0]);
				return;
			}
		
			for (int i = 0; i < bm.length(); i++)
			{
				Beam bmFemale[0];
				//T connection
				int bOverWriteExisting = TRUE;	//TRUE=>Overwrite,  FALSE=>Not Overwrite
				double dRange = dSnap;		//ExtendDistanceAllowed, use a property to allow user to control the intelliSelect behaviour
				
				// query all possible t-connections
				bmFemale = bm[i].filterBeamsTConnection(bm,dRange,bOverWriteExisting);
	
	
				//for each beam that makes contact, insert the local instance of this tsl
				lstBeams[0] = bm[i];
				for (int j = 0; j < bmFemale.length();j++)
				{
					// make sure it's not the same beam
					if (bmFemale[j] == bm[i])
						continue;
					lstBeams[1] = bmFemale[j];	
					// create new instance	
					tsl.dbCreate(scriptName(), vUcsX,vUcsY,lstBeams, lstEnts, lstPoints, 
						lstPropInt, lstPropDouble, lstPropString,_kModelSpace,mapTsl ); 		
				}// next j	
			}// next i
		}
		else
		{
			lstPoints.append(_Pt0);
			
			tsl.dbCreate(scriptName(), vUcsX,vUcsY,lstBeams, lstEnts, lstPoints, 
						lstPropInt, lstPropDouble, lstPropString ,_kModelSpace,mapTsl );
						
		}
		eraseInstance();
		return;
	}	
//end on insert________________________________________________________________________________
	
// detect mode
	int nMode = _Map.getInt("Mode");
	
// detect type of model
	int nModel = sArModel.find(sModel);
		
// standards
	Vector3d vx,vy,vz;
	CoordSys csTransform;
	int nMulti = sArMulti.find(sMulti);
	if (nMulti<0) nMulti =0;
	
	
	Beam bm0,bm1;
	double dDeltaYZ;
	Point3d ptRefMirr = _Pt0;
	
// Display
	Display dp(nColor);	
	dp.showInDxa(true);
	
// detail mode
	if (nMode == 1)
	{
		// get the linked detailbeam from entity
		if (_Entity.length()<1)
		{
			eraseInstance();
			return;	
		}
		Entity ent = _Entity[0];
		setDependencyOnEntity(_Entity[0]);
		TslInst tslDetailGenBeam = (TslInst)ent;
		if (!tslDetailGenBeam.bIsValid())
		{
			eraseInstance();
			return;	
		}
		assignToGroups(tslDetailGenBeam);
		vx = _ZW;
		vy = _XW;
		vz = _YW;	

	// add triggers
		String sTrigger[] = {T("Update")};
		for (int i = 0; i < sTrigger.length(); i++)
			addRecalcTrigger(_kContext, sTrigger[i]);


	// get properties of detail beam and place connector
		double dBmY, dBmZ, dAngle;
		dBmY = tslDetailGenBeam.propDouble(1);
		dBmZ = tslDetailGenBeam.propDouble(0);
		dAngle = tslDetailGenBeam.propDouble(2);
		int nZn = tslDetailGenBeam.propInt(1);
		dDeltaYZ = (dBmZ-dBmY)/2;
		
		_Pt0 = tslDetailGenBeam.ptOrg();	
		
		
		CoordSys cs;
		cs.setToRotation(dAngle ,vx,_Pt0);
		vz.transformBy(cs);
		vy.transformBy(cs);
				
		Point3d ptCen = _Pt0 - vz * 0.5 * dBmZ - vy * 0.5 * dBmY;		
		ptCen.vis(4);	
		ptRefMirr =ptCen;
		
		double dRot[]={0,90,180,270};
		double dTrans = 0.5 * dBmZ;	
		if (nSide == 2 || nSide == 4)dTrans = 0.5 * dBmY;	

	// rotate by selected side				
		CoordSys csSide;
		csSide.setToRotation(dRot[nSide-1],vx,ptCen);
		vy.transformBy(csSide);
		vz.transformBy(csSide);	
		_Pt0 = ptCen + vz * dTrans;
		_Pt0.vis(1);	
	
	// obtain main detail tsl
		Entity entDetail= tslDetailGenBeam.map().getEntity("tslDetail");
		TslInst tslDetail = (TslInst)entDetail;
		if (!tslDetail.bIsValid())
		{
			eraseInstance();
			return;
		}
	
	// build tsl data map
		Map mapTsl;
		mapTsl.setString("scriptName", scriptName());		
		mapTsl.setEntity("ent", _ThisInst);
		mapTsl.setString("myHandle",_ThisInst.handle());	
		mapTsl.setEntity("entParent", tslDetailGenBeam);	
		mapTsl.setString("parentHandle",tslDetailGenBeam.handle());		
		mapTsl.setString("dependencyType","beamSubmap");			

		mapTsl.setPoint3d("ptOrg", _Pt0);
		mapTsl.setString("propString0", sDimStyle);
		mapTsl.setString("propString1", sModel);
		mapTsl.setString("propString2", sMulti);
		mapTsl.setDouble("propDouble0", dSnap);
		mapTsl.setInt("propInt0", nSide);
		mapTsl.setInt("propInt1", nColor);	

	// collect submaps of main detail
		Map mapMain = tslDetail.map();
		Map mapDetail = mapMain.getMap(tslDetail.propString(1));
		Map mapZone = mapDetail.getMap("Zone"+nZn);		

	// get path and last chnaged prop
		String sPath = mapMain.getString("UsedPath");	
		String sArNameLastChangedProp[0];
		sArNameLastChangedProp.append("_Pt0");
		sArNameLastChangedProp.append(T("|Model|"));
		sArNameLastChangedProp.append(T("|Side|"));
		sArNameLastChangedProp.append(T("|hsbIntelliSnap|"));
		sArNameLastChangedProp.append(T("|Dimstyle|"));

	// update
	if (_bOnRecalc && _kExecuteKey==sTrigger[0]
		|| (_bOnDbCreated || sArNameLastChangedProp.find(_kNameLastChangedProp)>-1))
	{
		
	// set tsl map
		mapZone.setMap(_ThisInst.handle(),mapTsl);
		mapDetail.setMap("Zone"+nZn, mapZone);
		mapMain.setMap(tslDetail.propString(1), mapDetail);
		
		tslDetail.setMap(mapMain);		
		tslDetail.setPropString(0,tslDetail.propString(0));
		mapMain.writeToXmlFile(sPath); 	
		reportMessage("\n" + scriptName() + " " + T("|has updated|") + " " + sPath);
	}
	
	// place these lines at the end of the script
// trigger0: update completed
	if (_bOnRecalc && _kExecuteKey==sTrigger[0]) 
	{
	 	reportMessage("\n" + T("|Updating Completed.|"));
	}

	
	}//END DETAIL MODE_________________________________________________________________________________________________________________
	
	
	
	
// BEAM MODE___________________________________________________________________________________________________________________BEAM MODE	
// beam mode
	else if (nMode == 0)
	{	
	// special creation mode, driven by the submap of _Beam[0]
		if (_Beam.length() == 1 && _bOnDbCreated)
		{
			Map mapSub = _Beam[0].subMap("Creator");
			// create tsl instance from each beam entity listed in the submap
			for (int i=0;i<mapSub.length();i++)
			{
				if (mapSub.hasEntity(i))
				{
					Entity ent = 	mapSub.getEntity(i);
					Beam bmSub = (Beam)ent;
					// create a new instance if the beam is valid
					if (bmSub.bIsValid())
					{
						double dProps[0]; 	dProps.append(dSnap );
						String sProps[0]; 	sProps.append(sDimStyle); sProps.append(sModel); sProps.append(sMulti);
						int nProps[0]; 		nProps.append(nSide);	nProps.append(nColor);
						Point3d ptAr[0];
						Entity ents[0];
						Beam bmAr[0];			bmAr.append(_Beam[0]);		bmAr.append(bmSub);
						TslInst tsl;
						tsl.dbCreate(scriptName() , _XW,_YW,bmAr, ents, ptAr, 
								nProps, dProps, sProps); // create new instance
		//erase the submap
		//bmSub.subMap(Map());
					}
					
				}	
			}
			// erase this instance since all required instances have been created
			eraseInstance();
			return;	
		}	
		
		
	// declare standards
		if (_Beam.length() < 2)
		{
			reportMessage("\n" + scriptName() + " " + T("|2 beams required|") +". " + T("|Tool will be deletd|"));
			eraseInstance();
			return;	
		}

		bm0 = _Beam[0];
		bm1 = _Beam[1];
		Element el0=bm0.element();
		Element el1=bm1.element();
		
		
	// assignment	
		int nAssignTo=_Map.getInt("assignTo");// 0= male, 1 = female
		
		String sAssignToTxt;
		Element elThis;	
		Beam bmThis;
		if(nAssignTo==0)// the current assignment is female, the trigger shows the command to assign to male
		{
			if (el0.bIsValid())	elThis=el0;
			else bmThis=bm0;
			
			if (el1.bIsValid())sAssignToTxt=T("|Element|") + " " +el1.number();
			else	sAssignToTxt=T("|female Beam|") + " " +bm1.posnum();	
		} 	
		else if(nAssignTo==1)// the current assignment is male, the trigger shows the command to assign to female
		{
			if (el1.bIsValid())	elThis=el1;
			else bmThis=_Beam1;
			
			if (el0.bIsValid())sAssignToTxt=T("|Element|") + " " +el0.number();
			else	sAssignToTxt=T("|male Beam|") + " " +bm0.posnum();	
		} 
			
	// add assignment trigger	
		String sTriggerAssign =T("|Assign to|")+" " + sAssignToTxt;
		addRecalcTrigger(_kContext,sTriggerAssign);			
		if (_bOnRecalc && _kExecuteKey==sTriggerAssign) 
		{	
			if (nAssignTo==1)
				nAssignTo =0;
			else	
				nAssignTo =1;			
			_Map.setInt("assignTo",nAssignTo);
			setExecutionLoops(2);
		}
	
	// assigning
		if (elThis.bIsValid())	
		{
			assignToElementGroup(elThis,TRUE,0, 'E');
			dp.elemZone(elThis,0,'I');
		}
		else if (bmThis.bIsValid())
		{
			assignToGroups(bmThis);//	remember to update this in the futrure: assignToGroups(Entity ent, char cZoneCharacter); // (added since 18.1.45) 	
		}			

		
		dDeltaYZ=-(bm0.dD(vz)-bm0.dD(vy))/2;
		
		// check if one of the edges would contact
		Point3d ptEdge[0];
		ptEdge.append(bm0.ptCen() + bm0.vecY()*bm0.dD(bm0.vecY())*0.5 + bm0.vecZ()*bm0.dD(bm0.vecZ())*0.5);
		ptEdge.append(bm0.ptCen() - bm0.vecY()*bm0.dD(bm0.vecY())*0.5 + bm0.vecZ()*bm0.dD(bm0.vecZ())*0.5);
		ptEdge.append(bm0.ptCen() - bm0.vecY()*bm0.dD(bm0.vecY())*0.5 - bm0.vecZ()*bm0.dD(bm0.vecZ())*0.5);
		ptEdge.append(bm0.ptCen() + bm0.vecY()*bm0.dD(bm0.vecY())*0.5 - bm0.vecZ()*bm0.dD(bm0.vecZ())*0.5);		
		int bHasContact;
		for(int i = 0; i<ptEdge.length(); i++)
		{
			LineBeamIntersect lbi(ptEdge[i], bm0.vecX(), bm1);
			if (lbi.bHasContact())	
			{	
				bHasContact= true;
				break;
			}
		}	
		_Pt0.vis(bHasContact);	
		if (!bHasContact)
			return;
			
		// build vectors for T-Connection
		_Pt0 = Line(bm0.ptCen(), bm0.vecX()).intersect(Plane(bm1.ptCen(),bm1.vecD(bm0.vecX())),0);
		vx = _Pt0 - bm0.ptCen();
		vx = bm1.vecD(vx);	vx.normalize();	
		_Pt0 = Line(bm0.ptCen(), bm0.vecX()).intersect(Plane(bm1.ptCen(),bm1.vecD(vx)),-0.5 * bm1.dD(vx));

		// multiple insertion
		int nQty = nArQtyMulti[nMulti];
		
		if (nSide == 1)
			vz = bm1.vecD(bm0.vecZ());
		else if (nSide == 2)
			vz = bm0.vecY();
		else if (nSide == 3)
			vz = bm1.vecD(-bm0.vecZ());
		else
			vz = -bm0.vecY();		

		//vx.vis(_Pt0,1);	
		//vz.vis(_Pt0,150);	
		vy = vx.crossProduct(-vz);
		vy.normalize();
		//vy.vis(_Pt0,3);
		
		// cut
		Cut ct(_Pt0,vx);
		bm0.addTool(ct,1);	
		bm0.ptCen().vis(1);

	
	// transformation
		csTransform.setToTranslation(vz*0.5*bm0.dD(vz));		


	// dxaoutput for hsbExcel
		dxaout("Name",scriptName() + " " + sModel);// description
		dxaout("Width", dArD[nModel]/U(1,"mm"));// width
		dxaout("Height", dArA[nModel]/U(1,"mm"));// height
		dxaout("Length", dArB[nModel]/U(1,"mm"));// length
		dxaout("Group", bm0.groups());// group
		dxaout("Quantity", nQty);// quantity
			
		Map mapSub;
		mapSub.setString("Name", scriptName() + " " + sModel);
		mapSub.setInt("Qty", nQty);
		mapSub.setDouble("Width", dArD[nModel]/U(1,"mm"));
		mapSub.setDouble("Length", dArB[nModel]/U(1,"mm"));
		mapSub.setDouble("Height", dArA[nModel]/U(1,"mm"));				
		mapSub.setString("Mat", T("|Steel, zincated|"));
		mapSub.setString("Grade", "");
		mapSub.setString("Info", "");
		mapSub.setString("Volume", "");						
		mapSub.setString("Profile", "");	
		mapSub.setString("Label", "");					
		mapSub.setString("Sublabel", "");	
		mapSub.setString("Type", sModel );						
		_Map.setMap("TSLBOM", mapSub);		
		
		model(sModel);
		material(T("Steel, zincated"));	
		setCompareKey(sModel);
	
	//Datenexport Zeitvorgabe und Deckenreport
	// Hardware Components
		HardWrComp hwcs[0];
		String category=T("|Connectors|"), articleNumber=scriptName();
		HardWrComp hwc(articleNumber, 1);
		hwc.setDScaleX(1); // write quantity to scale X as countType fails in excel (22.0.19.1055)
//		hwc.setDScaleX(dArD[nModel]);
//		hwc.setDScaleY(dArA[nModel]);
//		hwc.setDScaleZ(dArB[nModel]);
		hwc.setCategory(category);	
		hwc.setMaterial(articleNumber);
		hwc.setCountType(_kCTAmount);
		
		if (elThis.bIsValid()) 
		{
			Map mapItem;
			mapItem.setInt("Quantity",nQty);
			mapItem.setString("Category",T("|Connectors|"));
			mapItem.setString("Article",scriptName());
			mapItem.setInt("Quantity",1);				
			ElemItem item(0,sModel,_Pt0,elThis.vecX(),mapItem );
			item.setShow(_kNo);
			elThis.addTool(item);
			exportWithElementDxa(elThis);
			
			hwc.setDescription(elThis.number());
		}
		hwcs.append(hwc);	
		_ThisInst.setHardWrComps(hwcs);
		
	}			




// START draw_______________________________________________________________________________________________________________________

	vx.vis(_Pt0, 1);
	vy.vis(_Pt0, 3);
	vz.vis(_Pt0, 150);
// PLine
	PLine pl(vy);
	pl.addVertex(_Pt0);
	pl.addVertex(_Pt0+vz*dArB[nModel]);
	pl.addVertex(_Pt0+vz*dArB[nModel] - vx*dArC[nModel]);	
	pl.addVertex(_Pt0+vz*dArC[nModel] - vx*dArC[nModel]);		
	pl.addVertex(_Pt0+vz*dArC[nModel] - vx*dArA[nModel]);	
	pl.addVertex(_Pt0-vx*dArA[nModel]);
	pl.close();
		
// Body
	Body bd(pl,vy*dArD[nModel],0);	
	bd.transformBy(csTransform);
	bd.vis(2);
	dp.draw(bd);	


	

	// two opposite
	Body bd2=bd;
	if (nMulti==1 || nMulti ==3 || nMulti ==4)
	{
		CoordSys csMirr;
		csMirr.setToMirroring(Line(ptRefMirr,vx));
		bd2.transformBy(csMirr);
		dp.draw(bd2);	
	}
	if (nMulti==2 || nMulti ==3 || nMulti ==4)
	{
		bd2=bd;
		CoordSys cs;
		cs.setToRotation(90,vx,ptRefMirr);
		bd2.transformBy(cs);
		double d= bm0.dD(vz);//-bm0.dD(vy)/2;
		bd2.transformBy(vy*dDeltaYZ);
		dp.draw(bd2);
		

	}		
	if (nMulti ==4)
	{
		CoordSys csMirr;
		csMirr.setToMirroring(Line(ptRefMirr,vx));
		bd2.transformBy(csMirr);
		dp.draw(bd2);	
	}	
















#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`:P!K``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`-M!+H#`2(``A$!`Q$!_\0`
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
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHJ.6:.",O*X1`,DD]*`)**YG4
M/&VDV+^6LC3MZQ8(_/I6;+X^!B+06,\G4#Y0.?S-3S(?*SMF8*,L0![TB.CC
M*,&QZ&O+;K4-;U2Y:6>[>V3^%(V(Q^5/L-1U;2G+).;J/&=KGG/^>U1[6-[%
M<C/4J*X^'QQ:HF+Q6A.<#<IY_*NBM-5L;X8MKJ*1L9VJX)_*M$T]B;,O4444
MQ!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%4K_4[/38U>\G6(-TSDD_@*-MP+M%8D_BC1[=<F^B<X.%0[B?;CI^-
M<?J/B>2YE9VN'2)QM$:,0H'H?7ZUG.HHE1BV>EU1O=4MK`9F<#_&O*)+ZXF(
M2VB+!OXAVJ6WT\`%KG$CGMVJ/;6W17LSM+_Q@D,;"WA+R$?(!SD_7TKE+NZU
M76'+7UP8HC_RRCZ?YR,]_P`*D5510JJ%`Z`#&*6LI57(M02(8K2&)0`@)'<C
MFIJ**R+"BBB@!'1)%VNH8>A%4WL&BE\^RF:"4=-K$`?X5=HIIM;":N;6E>-5
MBVVNJQLLJX!F7D'_`&C_`)_PK8A\7:9*ZJWG1@_Q,HP/R)-<3+;Q3#$BY]^X
MJG_9910(KEUQZ\ULJS(Y$>OHZ2('1@RD9!!R"*?7E6GW&IZ4Q^S7"LC_`'E;
M/Y@UI1>-;_3SBZM#,O\`>#\?RK958LAP:/0Z*R=)\06.KQ;H)`"#@J>H-:U:
M$!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`445A:CXITW3)3%)(S
MNI(81C.WZY_SQ2;2W!*YNTR21(EW.P`KE6\<V#C$.XM@$#:3GCI6'>ZY>:K(
M'"O!$"?E;N/H#4N<5NQJ+9I>(?&1MK@6VFON=?O,H#$GT&>/\^U<O*+S6&-Q
MJ,S%G`QC@C\.U3PVL4)RJY<]6;DG\:FKFE4;V-HQ2*HTVU'_`"RS]33A86JG
M/DJ?KS5BBL[LJPBJJ*%4``=`*6BBD,****`"BBB@`HHHH`****`"BBB@`HHH
MH`9"IM)Q-;8C;&U@!U'^-='8^,8HBL-Z2KL>,J>.G4]*Y^D9%==K*"/0UI"J
MXZ$2@F>@OKFG1Q[Y+E(QC(!ZG\*8GB#2W95%T,DX&48#\R.*\VFTV*0[D9HV
MZ_*:A\O4(!A=LB@]NN*U]LWL3[-=3V2BO-/#_BB2PNDANUE^SR87:3PA)X(_
M7I7H,.HVLR@I*O-;0ES*YFU8M44@((!!R*6J$%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`'+>-[F]L]$>XLYVB=,?=/J0/ZUP"Z;=JD=V\)O+?')CR=F.<$>H_+FNN^(
MTCK;6,:GY&9B1CN-H'\S6%H^LW>FP((&5HG`9HG7*DX_3\/05S5)I2LS6$=+
MH@@O[5@`/W9Z8(Q5P$$<'-6_[<MKJ0G4-+MY`3UC&"/7@YSVXR.E,70(IXVN
MM!N"RJ`&MW)`4GU]_?IQ6:A&7PLIR:W17HJM]K,4Q@NXGMIA_"XX/T-6-RYQ
MN&?K4--;E)W%HHHI#"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`$=%D4JZAAZ&IVN"(E6*)(V7'S98[L>HW5#15*36PFD]S0T[Q5?:?)Y=
M^JF`YQ(N2!]<]*ZZQUNSO8U*R!6/&,]ZX$C(P:N::NG@>1=;X(\[EDC)X/H1
MZ?A_];>G6Z2,Y0['HBL&`*G(]13JXL^(8]%E1)[E)H7&Y73)R.P/H?;W]JZF
MUU*UO(U>&92#TYK=-/8RL6Z***8!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`<=\1(@V@Q2`+O6<`,1
MT&TD_P`A^5</:.'M(B.FT#'I7<^/)1_9UM;%<B1R^[/3:,8Q_P`"_2N`TXGR
M7!.0&KBKZLWI[%VIK:[N+*836TS1..ZGK['U''2H:*Q-3HKW6-*UJS$>IV<R
MS+T>#!^I&3QGTY[<UCP^'K2\95L-1B24C*I,IB8'.,#J#VQS56BM/:M[D>S7
M0OM:WUC+Y%VJN?[Z=OKFA6#*&4@@C((JI'<2Q*45SY9^]&>5/X?AU'-/N;JW
M#I)`DL)QADP"@YZ^OKV_E3]V6V@M5N6:*=:M;7I5+6Z1I2=OER$1MGOC)P1S
MZ_A5RXT>_M$WRVKA<$DKA@`/7'2DXM#NBC1114C"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`$95=2K`%3U!J!;:6&0/;7<T)7[@!RJ^N!
M5BBFFUL*US3TK4M4`*-=6Y\O!"NVS?[Y/\O_`-5;`U;51;K*ME),A)^:(JWK
MTQFN4I\<LD,@DB=D<=&4X(K:-=]2'370[&P\1PSR>1<*8IAP0PP<UN*RNN5(
M(]17&6=]9ZC`+7525D7B.X!(/XGU]SZ<]*?+JJ>'SG[6ES;[NJL&(SZ@=.G\
MJWC.,E<S<6CLJ*Q[3Q)I=W&K?;($)&<-(!6NK!AE3D52=R1:***8!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`</X\F5[BU
MMAG>D;.?3#$`?^@FN(L#AIDY/S9R:[;QM;2B]M[O&8FC\O([$$GG\_T-<1#\
ME^R#`!!-<-7XF=$-D7J***Q-`HHHH`*2EHH`@DMD<A@-K#D$=JW+#QOJ.FHL
M-W;?:U&?GW;6_$X-95(0",$9K2%24=B903W+QUK2KVYD?;)9@XQ$@#\GKU*X
M^G-6)EMU<BVNH[A!C#8*'G/\)Y[=L]JP9+.)Q]W!JNKW%FX4Y>/K[BB]Q6L=
M#14<6K6-^D:@?9[WG<N,))CN/1O;IZ8/%/5@R@J00>XH:L"8M%%%(84444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`4YM-@D'R`QMZK
MT_*M#2-6O]#5XW=IK8ME=HR5]>/?^E1T5<9N+NB7%,ZZW\76CB/S?D#?Q$X%
M;5K?V]X@:*0'/05Y_#>SV\+PQN/+<Y964,/U%0+/=6V7M)%5\=&'!K=5X]3-
MTWT/4:*\U_X2G7K1=Y6&7UX)P/IFMVR\=6$\T4-Q')`[<$MC:I^OI[UHJD62
MXM'6T5#!=0W"@Q2*P]C4U62%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`87BM%;P]<$J"5*%21T.X#(_`FO*U8+J2\'D$5Z?XQ25M"S'G8
MLJF3!Q\O(Y]>2*\OG!2_C<#)W!?H*Y*VL_D;4_A-"BBBN8V"BBB@`HHHH`**
M**`"D(!&",BEHH`ADMHI/O+4MCJ>K:))NL+EC%WB?YD/X'I^&*6DJHR<=A.*
M9MW'C2SU2R^SZA926]TH!CD3YAN[]<$`_C^E4+:ZANHP\3@CN.X^M9[P1OR5
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
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!7`?$33YG2*^C!90OEM@?=P21^>?T]Z[^
MLGQ!$DVD21NN48X8>W>IE'F5AQ=G<\MM23:Q$\?**FJ*W3R[>-#C*C'%2UYS
MW9UH****0!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10!#/;17"[9$!]^XK/.EM;2&2UFDC/\`LMBM:BFG8&C-74;V)D4RG`_O+D''
MN!FM#^V%1CYD/R=-R-NY_2FO$D@PR@U4FTX,I\LD9Z^]/3IH(U8M2M)<`3!3
MC.&XQ3_MMKN(^T1Y'/WA7.R6CQ,#AF3N/\*@X^;!''KQ2]]=!JQV%%8FFZD8
MB+>X.$Z*Q_A]C[5M@AE#*00>01WIQE=":L%%%%,04444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`5+BR#_/"0D@]N#3])U^?1[Q'FB8
M#.QPP^\O?^56*1D5U*LH(]#5*5A-7.]M_$.G7*!XI@4(SN/`J_%>6\RAHY58
M'H<]:\WMF2U("PHR`YVL.._ISWI?M$T3A[8B)@,8)9@?S.:Z56C;4R=-]#TZ
MBO-(O%VL:>X6=+=H\X#$$C^==)IOB^VO"B7"")FP-P;*Y[Y]!^=4JD63R,Z>
MBF(ZR('1@RL,@@Y!%/K0D****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`JEJD8DT^1>G'!]*NU4U&,RZ?-&,992.:`/*&B$,LD8<.
M%<\CH/;\.E%6+VU^SSLRCY)&+#`.`>XR>_.>/457KSIJTF=4-D%%%%04%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M(1D8-0RVL<H.1@U/133L!D7%G,@&T[@HX^E0!C"0R.Z..O&TC_/-;M02VB29
M(&#0TI;@KHI)JMXFT>;D#L0.:O6^MY;;<1@#^\G;\*I>1);`J8DE3Z<_G4#K
M$6PH>,YYW<@5/+-;.X7BSJ8Y$EC5XV#*>013JY>TU"2Q;`(*,>5/?Z5T-I=Q
MWD.]."/O+W!JHROHQ-$]%%%4(****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`$=%D7:Z@CT-9SZ=)&^ZVE(!/W6/2M*BFG85AMEXDUC
M2"D8C:6W#9\O`(]^>H_QKL-+\7V&H.D,CB"9N-DIVG.<8%<C5>ZLX[I""-K]
MF`YK6%5K0B4+GK((8`@Y%+7D5OJVJ:4$0S2B*/YOD<[1SZ=*Z+3?&<Q4^:%N
M`>1_`1^0QCKVK955U(Y&=W15&RU*UOTS;R@MC)0\,/P_'KTJ]6B:>Q`4444P
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*9(N^-EZ9&*?2'[IH`\WU
M%?+L)XMJ%4N@4;^(`A@?SVBL:MSQ!+%!++9'`F:42<#@@!O\:PZX:_QG33^$
M****Q+"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`2F-#&_50:DHI@5)+"%P/EY'0XZ57:PN(FWVT[1R
M=B#_`#K3HI\S%9&=#KUQ;N([V'.."RC!_*MV"YAN8]\,BNOL>E4617&&&16<
MUH]I/YUL63UV'&?:A.XCHZ*CT^[MK^#_`%WD7"*2RR?=;'/!['M@^G7G%255
M@"BBBD`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M&,\&J,VG+NWP-Y;`<+VJ]133L*QG1WMW9R_O(V!3YA(O;Z'UKI+3XA_N@EQ;
MJ\AX!5MI/U&#S_G%9E1O;PN<M$I.,<BKC.VPG&YW&F^*+#4G6)2T4QP`K="?
M0$?UQVK>KQR;3VB8269P1U5B<&MW2O&=W9P-'J$,TJJ>'QE@>XY/(K>%6^YE
M*%MCT:BN2MO'FFSN%99(<G@RX`/![_A6]::Q9WH!BE&#T)[UJFGL2U8OT444
MQ!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110!Y;XKB:/Q4)&X1XR%.>I!YK/KK
M_%EG"TC2RD*57=&1V(]?KT_&N0KBKJTCHI.Z"BBBL#0****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`***B:>%,[I5&.HSS0!+2'`4EL`=\U2EU&,(1;_O'],8`J.&PN;G<TD9+-
MU9B5P?;UIJ+>PKH@N9;99@\4S*W^R#GZ5-#=:G*,VY9U7H&48-:-II*1$/,%
M9A_"HX_'UK15510J@`#L*T3MYDM&!'KMU$"MS:L"N<MCBM&VU.*;@X!]CFKD
MD,<@PRBLJXT)&8R0NT<G7*G%.\6+5&P"",CI17/1ZA=:9,(KI-T)X#^E;-O?
MVUSQ%*I;^[GG\J3BT-,L4445(PHHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`$9$8$,H(/!R*JRV"%E>`^1(ARI7U]:MT4T[`
M6].\6ZCI:+%J$)GC48\U.2`!UQW[#M7467BO3;Q1LD^8]NXY[^E<93/(BW[P
M@#?WAP:VC6:W,W370]*BU*TF8*DZDXSUJRK*P!4Y'K7F-OY<6!()G53D`2$$
M'\<Y_&M>SO[KSO)M;KS`Q&U9AL9SZ9R1^H_&MHU8R,W!H[FBN=-_K-KM>XLL
MJS;<1_-CW.*MVWB"UE<I(P0CN36A)KT4Q)4D^XP-/H`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
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
MDA1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!6?
M>Z18:@FRZM8I."`2O(SUP>U:%%`'`ZC\/@K&72KAHCDG8_(]A]/SKE;RRU;3
M+AH+K:)%Y``R&'J/45[15#4M,@U6U^SS[@NX,"AP01_^LUC.DFM-RXS:W/'5
MOI(SBXBQVRM7(Y4E7*,"/:NIN?`MT6VPW,$B8Y,@*'/T&:Y74=!U#2&$KPO"
MI[\%3UXR.,\'BN:5-K=6-E)/8DHJO;W`ERC<2+U'K]*L5FU8L****0!1110`
M4444`%%%%`$-SQ;OQVKJOAQ$C1W<Q7]XH50<]`2<_P`A7)WAQ;FNH^'KM'</
M"IPCV^]ACJ01@_\`CQK:CHT9U-CT*BBBNXYPHHHH`**0D`9)P*P;O6C<.;;3
M5,CME3+CA?IZ_P#ZJ`%U'6)&NQ8Z?AI0V)'QD+[?7.*DL=`CAF,\[M+(>[-D
M_G3]'TO[#$6D&97.22<G/K6O0`@4*``,`4M%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4R3'EL&^[CFGU%.";>0`9.T\4`<_X<)_M+5%W';Y@.TG
MOZUTM8'AZ6)KC4HPN)5GRW'48XY_.M^@`HHHH`****`"BBB@`HHHH`****`"
MN)\4H(;^39@>;&A;N2=__P!:NVKA_&4$LNI0F+D)$"R@9(&6YJ9_"QQW,6B@
M=**X#I"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**9)*(QC!9C
MT51DFI(=-U?4(XWM(DC5QGY\D@=NU5&#EL)R2)K,0O>Q)-DI]YE'5@.WX]/Q
MKH/)U'5BL<JI!9H?EC3[I4=,_I[=#4VB>&8K")7G)>X/S.V<Y/\`AZ5T:J$&
M%&!773ARHPE*[*UII]O9Q*D:#CN:MT45H2%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
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
M]EW:QS#!`++R,]<'J/PK*I24BXS://?!^H+:7=W+"%FDEPH3?Z<Y_4UU)M=9
MU!MTMRT"9!"I@#_/>GZ;X/TW3-4-];(5.,!<D_SKHZN*LK$R=V9&GZ)%:,TD
MI\V1CDEN>?K6O115""BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`*S]3TR.]B)P!(!P<5H44`<]I&IS0
M.-/U)LR)Q',?XATY]ZZ&L[4])BU"/D`2#H:RA?ZGI<ZPS1&Y@'5^CXP.?3\Z
M`.FHJA8:K:Z@BF-]KG/[MC\P_"K]`!1110`50UD.=%O/+7<_EG`]35^FLH92
MIZ$8H`X&]1GTNTG1PT(++C`&">_KR!^E9M:%\LMI%)9;AY4=P1AL[NAQ^&,_
MI6?7'6^(WA\(4445D6%%%%`!1110`44^6&:%$9X74.,J2I`8>H]:N:=H%UJ%
MPC3J4@&&VCOUX/KV/Y]:TC3E(ER2**I))CRT+9/:NCTG0F=A+<*HCX(`/7`Q
MSG_/\JV[/1K2S;>J`N>I(_SZUI].*Z84U$QE)L:B+&@51@"G445H2%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4UD5QAE!'O3J*`,'5=#A
MF@,EO^ZE0[PR\$=ZLZ+J37L#13'_`$F'`DXQGWK5KG]0T^XM[L7UB<..HQP1
MZ'V_S]0#H**R]-U>'4`496AN$X>)^OIQZC-:E`!1110!Q^H0^;JFJ(Y(3RRX
MQUR%!'\JYVNK:"2ZUC4%0KAT:-2<]2N.?Q!KEF5HW*.I5E."",$&N6NM4;4]
MAM%%%8&@45;MM.O+O:8+>1U;.&VX7CW/%:%K';:9<[N+Z[3[J1_ZM#GKGN?P
MXP:N%.4B7)(O:-HL=O`;K4HTR>523H@]QTR<]#TJ=M=,I\C3+8LJ'8'9=JC@
M8P/T[5%'9ZEJSAM0^2'C"*1@$=_?.:W[>SAM4"QIC'?O79&*BK(P;;W,BRTF
M=YS/?RB5B<CC'T_S]:W5147:H`'H*=15""BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`,74]"CNR9H#Y5P,$,.V
M*II+KEBD<12.=$/+.<''IGU]ZZ:B@#GXO$JI($O;9X<C(906'?MC-;<,T=Q$
M)(G5T/0J<TV>TAN$*R(#6"VCWUC*7T^Z94/\'&T#OQZ\4`$[26/B@2OS#,F0
M2,!?7Z]O\]<GQ'9"UU-I$!\N<>8.#C/<9_7\:EO=0:Z>S-\JQW-O(2X5<@KU
MW#Z8_6H;>=-:U))[^1(X$4`Y;''9<^IY/YUC5LTH]2X::C;#0KR^VML\F(_Q
MOQD<=!WX/T]ZZ:V\/:=:_,8C,P).Z4YQQZ=/TIEUKEM;!8+2)IV"C:(QA`.W
M/^'I522UU75T"S2""/.<)P"/0^O'%5&E&(G-LDN]0FU&X-GI\A2,?>E4<GZ>
MW^'I6CIVD6]A&-J@N>IJ33]/BL(%1!\V.35VM"0HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`YOQ'HLM_Y;6@C5B&5WQEAD<8IFG>$K6WM5CG`D./F+#)/'K73T4K
M=0OT*5IIMK9(%AC``X&><5=HHI@%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
*%%%`!1110!__V5%`
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
      <str nm="Comment" vl="HSB-14106 display published for hsbMake and hsbShare" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="12/21/2021 8:35:11 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End