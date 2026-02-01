#Version 8
#BeginDescription
version value="1.6" date=22dec17" author="thorsten.huck@hsbcad.com"
debug removed
bugfix beamcut length enhanced

Dieses TSL schreibt erweiterte Daten für den bauBit Export in jedes Panel und startet den Export der Daten
Die Verwendung dieses Befehls setzt die Definition eines bauBITExports voraus, vergl. benutzerdefinierte Dokumentation


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Dieses TSL schreibt erweiterte Daten für den bauBit Export in jedes Panel und startet den Export der Daten
/// Die Verwendung dieses Befehls setzt die Definition eines bauBIT-Exports voraus, vergl. benutzerdefinierte Dokumentation
/// </summary>

/// <insert Lang=de>
/// Wählen Sie ein oder mehrere Objekte für den Export aus oder bestätigen Sie die Auswahl mit einer Leereingabe
/// um alle gültigen Objekte der Zeichnung zu exportieren
/// </insert>

/// History
///<version value="1.6" date=22dec17" author="thorsten.huck@hsbcad.com"> debug removed </version>
///<version value="1.5" date=08dec17" author="thorsten.huck@hsbcad.com"> bugfix beamcut length enhanced </version>
///<version value="1.4" date=22nov17" author="thorsten.huck@hsbcad.com"> bugfix beamcut length </version>
///<version  value="1.3" date="15apr15" author="th@hsbCAD.de"> bugfix spline beam output </version>
///<version  value="1.2" date="27jan15" author="th@hsbCAD.de"> element, beam and electrical output added </version>
///<version  value="1.1" date="17nov14" author="th@hsbCAD.de"> cut normals are exported  as cuts </version>
///<version  value="1.0" date="27jan14" author="th@hsbCAD.de"> initial </version>

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


	
	

	// collect and order exporter groups
	String sExporterGroups[] = ModelMap().exporterGroups();
	for (int i=0;i<sExporterGroups.length();i++)
		for (int j=0;j<sExporterGroups.length()-1;j++)
		{
			String s1 = sExporterGroups[j];
			String s2 = sExporterGroups[j+1];
			s1.makeUpper();
			s2.makeUpper();
			if(s1>s2)
				sExporterGroups.swap(j,j+1);
		}
			
	PropString sExporterGroup(0,sExporterGroups, T("|Exporter Group|"));
// on insert
	if (_bOnInsert) 
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		// show the dialog if no catalog in use
		if (_kExecuteKey == "" )
		{
			if (sExporterGroups.length()>1)
			{
				showDialog();	
			}	
			else if (sExporterGroups.length()<1)
			{
				reportNotice("\n" + scriptName() + "\n" + T("|Please define an Exporter Group first and try again.|"));
				eraseInstance();
				return;	
			}
		}
		// set properties from catalog		
		else	
			setPropValuesFromCatalog(_kExecuteKey);	
			
	// get selection set
		PrEntity ssE(T("|Select object(s)|") + " " + T("|<Enter> to select all|"), Entity());
		Entity ents[0];
		if (ssE.go())
			ents = ssE.set();
		
	// debug mode
		if (ents.length()>0 && ents[0].bIsKindOf(Sip()) && (_kExecuteKey.makeUpper()=="DEBUG") || bDebug)
		{
			reportNotice("\n" + scriptName() + "\n" + T("|Debug Mode|"));
			_Sip.append((Sip)ents[0]);
			bDebug=true;	
			return;
		}
				

	// auto select	
		if (ents.length()<1)
		{
			Entity entsAuto[0];
			entsAuto  = Group().collectEntities(true,GenBeam(),_kModelSpace);
			for (int i = 0;i<entsAuto.length();i++)ents.append(entsAuto[i]);
			entsAuto = Group().collectEntities(true,Element(),_kModelSpace);
			for (int i = 0;i<entsAuto.length();i++)ents.append(entsAuto[i]);
			entsAuto  = Group().collectEntities(true,TslInst(),_kModelSpace);
			for (int i = 0;i<entsAuto.length();i++)ents.append(entsAuto[i]);
			entsAuto = Group().collectEntities(true,ChildPanel(),_kModelSpace);
			for (int i = 0;i<entsAuto.length();i++)ents.append(entsAuto[i]);
			entsAuto  = Group().collectEntities(true,MasterPanel(),_kModelSpace);
			for (int i = 0;i<entsAuto.length();i++)ents.append(entsAuto[i]);
		}	
		
		
	// remove not supported beam types	
		int nAllowedTypes[] = {_kPanelSplineLumber};
		for (int i=ents.length()-1;i>=0;i--)
		{
			if (ents[i].bIsKindOf(Beam()))
			{
				Beam bm = (Beam) ents[i];
				if (bm.bIsDummy() || nAllowedTypes.find(bm.type())<0)
				{
					//reportMessage("\n" + bm.posnum() + " removed");
					ents.removeAt(i);
					continue;		
				}
			}	
		}

	// append entities of collected masters and childs	
		Entity entsSelected[0]; entsSelected=ents;	
		for (int i=0;i<entsSelected.length();i++)
		{
			Entity ent = entsSelected[i];
			ChildPanel childs[0];
			if (ent.bIsKindOf(MasterPanel()))
			{
				MasterPanel mp = (MasterPanel)ent;
				childs = mp.nestedChildPanels();
			}
			else if (ent.bIsKindOf(ChildPanel()))
			{
				childs.append((ChildPanel)ent);
			}			
			else if (ent.bIsKindOf(Element()))
			{
				Sip sipsElement[] =((Element)ent).sip();
			// collect and append from element	
				for (int c=0;c<sipsElement.length();c++)
				{
					if (ents.find(sipsElement[c])<0)
						ents.append(sipsElement[c]);
				}			
			}
			
		// collect and append from childs				
			for (int c=0;c<childs.length();c++)
			{
				Sip sipChild = childs[c].sipEntity();
				if (ents.find(sipChild)<0)
					ents.append(sipChild);
			}			
		}
		
	// attach tool data to every sip and collect potential parent elements
		Element elements[0];
		if (!bDebug)
		{
			//reportMessage("\n" + ents.length() + " collected");
			for (int i=0;i<ents.length();i++)
			{
				if(ents[i].bIsKindOf(Sip()))
				{
					Sip sip = (Sip)ents[i];
					Element el = sip.element();
					if (el.bIsValid() && elements.find(el)<0)
						elements.append(el);
						
					Map mapIO;
					mapIO.setEntity("sip", ents[i]);
					TslInst().callMapIO(scriptName(), mapIO);
				}		
			}	
		}
	
	// append potential elements
		for (int i=0;i<elements.length();i++)
			ents.append(elements[i]);			
		
			
	// set some export flags
		ModelMapComposeSettings mmFlags;
		mmFlags.addSolidInfo(TRUE); // default FALSE
		mmFlags.addAnalysedToolInfo(TRUE); // default FALSE
		mmFlags.addElemToolInfo(TRUE); // default FALSE
		mmFlags.addConstructionToolInfo(TRUE); // default FALSE
		mmFlags.addHardwareInfo(TRUE); // default FALSE
		mmFlags.addRoofplanesAboveWallsAndRoofSectionsForRoofs(TRUE); // default FALSE
		mmFlags.addCollectionDefinitions(TRUE); // default FALSE
		String strDestinationFolder = _kPathDwg;
	
	// Map that contains the keys that need to be overwritten in the ProjectInfo 
		Map mapProjectInfoOverwrite;
		//mapProjectInfoOverwrite.appendString("ProjectInfo\\ProjectRevision","10.11.12");
		//mapProjectInfoOverwrite.appendString("ProjectInfo\\PathDwg","aa");

	// call the exporter
		if (!bDebug)
		{
			if (1)
			{
				// compose ModelMap
				ModelMap mm;
				mm.setEntities(ents);
				mm.dbComposeMap(mmFlags);
				//mm.writeToDxxFile(_kPathDwg+"\\debugOut.dxx");			
			}
			
			int bOk = ModelMap().callExporter(mmFlags, mapProjectInfoOverwrite, ents, sExporterGroup, strDestinationFolder);
			if (!bOk)
				reportMessage("\nTsl::callExporter failed.");
			eraseInstance();
		}
		else
		{	
			_Pt0=getPoint();
		}
		return;
	}

	
// validate the sip
	Sip sip;

// on mapIO get a the sip ref
	if (_bOnMapIO)
	{
		Entity ent = _Map.getEntity("sip");
		Sip sipIO = (Sip)ent;
	
	// reportDebug
		if (bDebug)reportMessage("\nAnalysing " + sipIO.handle() + "...");
		
		if (!sipIO.bIsValid())
		{
			reportMessage("\n invalid sip ref");
			return;
		}
		else
			sip = sipIO;	
			
			
			
			
		
	}
	else if (_Sip.length()>0)
	{
		sip = _Sip[0];
		bDebug = true;
	}		
	else
	{
		eraseInstance();
		return;
	}		
	
// get sips coordSys		
	Point3d ptCen = sip.ptCen();
	Vector3d vx = sip.vecX();
	Vector3d vy = sip.vecY();
	Vector3d vz = sip.vecZ();	

// the sip body and its edges
	Body bdSip = sip.realBody();
	SipEdge edges[] = sip.sipEdges();	
	
// location is always at the selected entity
	_Pt0 = sip.ptCen();	
	_Pt0.vis(1);


// view vec, childpanels always seen in _ZW plane
	Vector3d vzView = vz;//_ZW
//	vzView.transformBy(child2sip);
	vzView.vis(sip.ptCen(),1);
		
	double dZ = sip.dH();
	Plane pnBot(_Pt0-vz*.5*dZ, vz);
	Plane pnTop(_Pt0+vz*.5*dZ, vz);

// the display
	Display dp(5);
	dp.textHeight(U(30));
		
// get envelope body	
	PLine plEnvelope;
	PLine plOpenings[0];
	Point3d ptRef;
	plEnvelope = sip.plEnvelope();
	ptRef = plEnvelope.ptStart();
	plOpenings= sip.plOpenings();

// build a pp from shadow by recomposing it from non openings	
	PlaneProfile ppMe = sip.realBody().shadowProfile(Plane(ptRef,vz));
	PLine plRings[] = ppMe.allRings();
	int bIsOp[] = ppMe.ringIsOpening();
	ppMe.removeAllRings();
	for (int r=0;r<plRings.length();r++)	
		if (!bIsOp[r])
		{
			ppMe.joinRing(plRings[r],_kAdd);
			if(plEnvelope.area()<plRings[r].area())
				plEnvelope = plRings[r];
		}	

// envelope net and brut body
	Body bdEnvelope(plEnvelope, vz*sip.dH(),1);
	bdEnvelope.vis(3);
	Body bdNet=bdEnvelope;
	for (int r=0;r<plRings.length();r++)	
		if (bIsOp[r])
		{
			Body bd(plRings[r], vz*dZ*3, 0);
			bdNet.subPart(bd);
		}
	bdNet.vis(6);
		
// add openings
	for(int o=0;o<plOpenings.length();o++)
	{
		ppMe.joinRing(plOpenings[o],_kSubtract);	
	}



// draw the outline
	plEnvelope.projectPointsToPlane(pnTop,_ZW);
	plEnvelope.vis(2);	
	
/*
// get contact face and compare with location of openings
	// any opening of the solid which matches an opening of the sip will be drawn
	dp.color(3);
	PlaneProfile ppFace = bdSip.extractContactFaceInPlane(Plane(ptCen+vzView*.5*dZ,vzView),dEps);
	//ppFace.vis(7);
	plRings = ppFace .allRings();
	bIsOp = ppFace .ringIsOpening();
	for (int r=0;r<plRings.length();r++)	
		if (bIsOp[r])
		{
			for(int o=0;o<plOpenings.length();o++)
			{
				Point3d ptO;
				ptO.setToAverage(plOpenings[o].vertexPoints(true));
				PlaneProfile pp(plRings[r]);
				if (pp.pointInProfile(ptO)==_kPointInProfile)
				{
					pp.transformBy(sip2child);
					dp.draw("Öffnung ", pp.extentInDir(_XW).ptMid(),_XW,_YW,0,0);	
					dp.draw(pp);
					break;
					//plRings[r].vis(9);	
				}	
			}	
		}
*/

// collect analysed tools
	AnalysedTool tools[] = sip.analysedTools(1); 	
	AnalysedDrill drills[]= AnalysedDrill().filterToolsOfToolType(tools);
	AnalysedCut cuts[]= AnalysedCut().filterToolsOfToolType(tools);
	AnalysedBeamCut abcs[]= AnalysedBeamCut ().filterToolsOfToolType(tools);
	
	
// DRILLS loop and collect data
	Point3d ptsDrillData[0];// X=diameter, Y=depth, Z=qty
	for(int i=0;i<drills.length();i++)
	{
		AnalysedDrill drill = drills[i];
		double dDiameter = drill.dDiameter();
		double dDepth = drill.dDepth();

	// the start point of the drill	
		Point3d ptStart =drill.ptStart(); 	
		double dRadius = drill.dRadius();

	// do not collect drill data if it isdefined by a liftingDevice	
		ToolEnt tent = drill.toolEnt();
		int bIsExporterData=true;
		if (tent.subMapXKeys().find("LiftingDevice")>-1 || tent.subMapXKeys().find("Electrical")>-1)
			bIsExporterData=false;
		
	// collect drill data
		if (bIsExporterData)
		{
			int bCollected;
			for(int p=0;p<ptsDrillData.length();p++)
			{
				if (abs(ptsDrillData[p].X()-dDiameter)<dEps && abs(ptsDrillData[p].Y()-dDepth)<dEps)
				{
					ptsDrillData[p].setZ(ptsDrillData[p].Z()+1);
					bCollected=true;
					drill.vecFree().vis(ptStart,p);
					break;		
				}	
			}
			if (!bCollected)
			{
				ptsDrillData.append(Point3d(dDiameter,dDepth,1));
				drill.vecFree().vis(ptStart,ptsDrillData.length()-1);
			}
		}
			
	// any drill which has a free vec codirectional to the transformed view vec or is complete through displays as top face
		Vector3d vecFree = drill.vecFree();
		int nDisplayType=-99;
		int nCircleColor=3, nCrossColor=12;
		if (drill.bThrough())	
			nDisplayType=0;
		else if (vecFree.isCodirectionalTo(vzView) && !drill.bThrough())	
			nDisplayType=1;	
		else if (vecFree.isParallelTo(vzView) && !drill.bThrough())	
		{
			nDisplayType=-1;
			nCircleColor=6;
			nCrossColor=4;	
		}
	// 
	
	// debug body
		if (0)
		{	
			Body bd(drill.ptStartExtreme(), drill.ptEndExtreme(), drill.dDiameter()/2);
			//if (child.bIsValid())bd.transformBy(child.sipToMeTransformation());
			bd.vis(i);	
		}
		

		
		/*
		ptStart.transformBy(sip2child);
		vecFree.transformBy(sip2child);
		*/
		
		//vecFree.vis(ptStartExtreme,bShowAsTop);
		//drill.vecFree().vis(drill.ptStartExtreme(),150);

	// text location
		Point3d ptTxt = ptStart+_XW*1.1*dRadius;
		//ptTxt.vis(2);
		
		if (bDebug)
		{
		// the circle display
			dp.color(nCircleColor);
			PLine plCirc;
			plCirc.createCircle(ptStart,_ZW, dRadius);
			if (nDisplayType==0)
			{
				plCirc.projectPointsToPlane(pnTop,_ZW);
				dp.draw("ø" + drill.dDiameter(), ptTxt,_XW,_YW,1,0);
			}
			dp.draw(plCirc);
	
	
		// the cross display
			if (nDisplayType!=0)
			{
				dp.color(nCrossColor);		
				PLine plCross;
				plCross.addVertex(ptStart+_YW*dRadius);
				plCross.addVertex(ptStart-_YW*dRadius);
				plCross.addVertex(ptStart);
				plCross.addVertex(ptStart+_XW*dRadius);
				plCross.addVertex(ptStart-_XW*dRadius);
				
				CoordSys cs;
				cs.setToRotation(45,_ZW,ptStart);
				plCross.transformBy(cs);
				
				if (nDisplayType==1)
					plCross.projectPointsToPlane(pnTop,_ZW);
				else if (nDisplayType==-1)
					plCross.projectPointsToPlane(pnBot,_ZW);
				dp.draw(plCross);
			
			// format string	
				String sDepth;
				sDepth.formatUnit(drill.dDepth(),2,0);
						
				dp.draw("ø" + drill.dDiameter()+"/"+sDepth, ptTxt,_XW,_YW,1,nDisplayType*3);
			}
		}
	}
// next i drill	


// CUTS loop and collect data from analysed tools
	Point3d ptsCutsData[0];// X=length, Y=angle, Z=not used
	Vector3d vecsCutNormal[0];
	Plane pnCuts[0];
	for(int i=0;i<cuts.length();i++)
	{
		AnalysedCut cut = cuts[i];
		//reportMessage("\ncut i:" + i +" has a bevel: " + cut.dBevel() +  " angle: " + cut.dAngle());
		Point3d ptOrg = cut.ptOrg();
		Vector3d vzCut = cut.normal();
		double dBevel = abs(vzCut.angleTo(vz));	
		if (dBevel>90) dBevel =180-dBevel;
		if (abs(dBevel-90)<dEps)continue;
		//reportMessage("\ncut i has a bevel of " + dBevel);
		pnCuts.append(Plane(ptOrg, vzCut));// collect cutting planes to skip doublettes
		Point3d pts[] = cut.bodyPointsInPlane();
		int nFlip=1;
		if (vzCut.dotProduct(vz)<0)nFlip*=-1;
		Vector3d vecFace = nFlip*vz;
		
	// cut color and line type
		int nCutColor=3;
		/*
		dp.lineType("CONTINUOUS");
		if (vzView.dotProduct(vzCut)<0)
		{
			nCutColor=6;
			dp.lineType("DASHED");	
		}
		dp.color(nCutColor);
		*/
		
		Vector3d vxCut = vzCut.crossProduct(vecFace);	vxCut.normalize();
		Vector3d vyCut = vxCut.crossProduct(-vzCut);
		
		Plane pnFace(ptCen+vecFace*.5*dZ, vecFace);
		
		ptOrg = Line(ptOrg,vyCut).intersect(pnFace,0);

		Line lnX(ptOrg,vxCut);
		pts = lnX.projectPoints(pts);
		pts = lnX.orderPoints(pts);		
		for (int p=0;p<pts .length();p++)pts[p].vis(i);

		double dX;
		PLine plCut;
		if (pts.length()>0)
		{
			dX=abs(vxCut.dotProduct(pts[0]-pts[pts.length()-1])); 
			
		// the cutting line		
			plCut.addVertex(pts[0]);
			plCut.addVertex(pts[pts.length()-1]);	
			
			if (bDebug)
			{
				//plCut.transformBy(sip2child);
				dp.draw(plCut);	
							
				Point3d ptTxt;
				ptTxt.setToAverage(plCut.vertexPoints(true));
	
				String sLength, sBevel;
				sLength.formatUnit(dX,2,0);
				sBevel.formatUnit(dBevel,2,0);	
				
			// the reading vectors	
				Vector3d vxRead = vxCut;
				//vxRead.transformBy(sip2child);
				if (vxRead.dotProduct(_YW)<0)	vxRead*=-1;	
				Vector3d vyRead = vxRead.crossProduct(-_ZW);
				if (vyRead.dotProduct(_YW)<0)	vyRead*=-1;	
				vxRead = vyRead.crossProduct(_ZW);
				dp.draw(sLength+"/"+sBevel+"°", ptTxt,vxRead,vyRead,1,nFlip*1.2);
			}
		}


	// collect cut data
		int bCollected;
		for(int p=0;p<ptsCutsData.length();p++)
		{
			//if (abs(ptsCutsData[p].Y()-dBevel)<dEps)
			if (vzCut.isCodirectionalTo(vecsCutNormal[p]))
			{
				//ptsCutsData[p].setX(ptsCutsData[p].X()+dX);
				bCollected=true;
				break;		
			}	
		}
		if (!bCollected)
		{
		// debug display
			if (bDebug)
			{
				PLine pl;
				Point3d pts[]= cut.bodyPointsInPlane();
				for(int p=0;p<pts.length();p++)
					pl.addVertex(pts[p]);
				PlaneProfile pp(pl);
				Display dpC(i);
				dpC.draw(pp,_kDrawFilled);
			}
			//double dThisAngle = dAngle;
			//if (dThisAngle<0) dThisAngle=90+dAngle;		
			ptsCutsData.append(Point3d(dX,abs(dBevel) ,0));
			vecsCutNormal.append(vzCut);
		}				
	}
// END CUTS from AT____________________________________________________________________________________________________________________________________________________

// CUTS loop and collect data from edges
	for(int i=0;i<edges.length();i++)
	{
	// edge
		SipEdge edge = edges[i];	
		Point3d ptOrg = edge.ptMid();
		Vector3d vzCut = edge.vecNormal();
		if (vzCut.isPerpendicularTo(vz))continue; // ignore perp edges
		Point3d pts[] = edge.plEdge().vertexPoints(true);
		if (pts.length()<2)continue;

	// ignore edge derived cut if already attached via analysed tools
		int bOk=true;
		for (int p=0;p<pnCuts.length();p++)
		{
			Vector3d vecNormal = pnCuts[p].vecZ();
			Point3d ptOrgP = pnCuts[p].ptOrg();
			if (vecNormal.isCodirectionalTo(vzCut) && abs(vecNormal.dotProduct(ptOrgP-ptOrg))<dEps)
			{
				bOk=false;
				break;	
			}	
		}
		if (!bOk)continue;

		int nFlip=1;
		if (vzCut.dotProduct(vz)<0)nFlip*=-1;	
		Vector3d vecFace = nFlip*vz;
		Vector3d vxCut =pts[pts.length()-1]-pts[0];
		double dX = vxCut.length();
		vxCut.normalize();
		Vector3d vyCut = vxCut.crossProduct(-vzCut);			

	// ignore edges to be processed as beamcut
		Body bdTest(ptOrg,vxCut,vyCut,vzCut, dX*2, 3*dZ, U(1),0,0,1);
		if (bdTest.hasIntersection(bdSip))continue;//bdTest.vis(6);

		Plane pnFace(ptCen+vecFace*.5*dZ, vecFace);
		ptOrg = Line(ptOrg,vyCut).intersect(pnFace,0);

		double dBevel = vecFace.angleTo(vzCut);	
		
	// extract face of cut on body
		PlaneProfile pp= bdSip.extractContactFaceInPlane(Plane(ptOrg,vzCut), dEps);
		LineSeg seg = pp.extentInDir(vxCut);
		dX = abs(vxCut.dotProduct(seg.ptStart()-seg.ptEnd()));

		pp.vis(4);
				
	// cut color and line type
		int nCutColor=3;
		if (bDebug)
		{
			dp.lineType("CONTINUOUS");
			if (vzView.dotProduct(vzCut)<0)
			{
				nCutColor=6;
				dp.lineType("DASHED");	
			}
			dp.color(nCutColor);			
	
			String sLength, sBevel;
			sLength.formatUnit(dX,2,0);
			sBevel.formatUnit(dBevel,2,0);	
			
	
		// the reading vectors
			Vector3d vxRead = vxCut;
			//vxRead.transformBy(sip2child);
			if (vxRead.dotProduct(_YW)<0)	vxRead*=-1;			
			Vector3d vyRead = vxRead.crossProduct(-_ZW);
			if (vxRead.dotProduct(_YW)<0 || vyRead.dotProduct(_YW)<0)	vyRead*=-1;	
			vxRead = vyRead.crossProduct(_ZW);
	
			Point3d ptTxt=ptOrg;
			//ptTxt.transformBy(sip2child);
			dp.draw(sLength+"/"+sBevel+"°", ptTxt,vxRead,vyRead,1,nFlip*1.2);
		}
		
	// collect cut data
		int bCollected;
		
		for(int p=0;p<ptsCutsData.length();p++)
		{
			//if (abs(ptsCutsData[p].Y()-dBevel)<dEps)
			if (vzCut.isCodirectionalTo(vecsCutNormal[p]))
			{
				//ptsCutsData[p].setX(ptsCutsData[p].X()+dX);
				bCollected=true;
				break;		
			}	
		}
		if (!bCollected)
		{
			ptsCutsData.append(Point3d(dX,dBevel,0));
			vecsCutNormal.append(vzCut);
		// debug display
			if (bDebug)
			{
				Display dpC(40);
				dpC.draw(pp,_kDrawFilled);
			}			
		}		
				
	}// next i


	// order cuts data by bevel
		for (int i=0;i<ptsCutsData.length();i++)
			for (int j=0;j<ptsCutsData.length()-1;j++)
				if(ptsCutsData[j].Y()>ptsCutsData[j+1].Y())
					ptsCutsData.swap(j,j+1);	
		
// END CUTS from edges_________________________________________________________________________________________________________________________________________________


// BEAMCUTS loop and collect data from analysed tools
	Point3d ptsBeamCutsData[0];// X=length, Y=width, Z=height

// run advanced analysis for the following types only
	String sArAllowedTypes[]={_kABCSimpleHousing,_kABCOpenDiagonalSeatCut};	

// precollect all cutting quaders from abc's
	Body bdQuaders[0];
	for(int a=0;a<abcs.length();a++)
	{
		AnalysedBeamCut abc = abcs[a];
		String sToolSubType =abc.toolSubType();
		CoordSys cs = abc.coordSys();
		Quader qdr = abc.quader();
		Point3d pt = cs.ptOrg();
		double dXBc=qdr.dD(cs.vecX());
		double dYBc=qdr.dD(cs.vecY());
		double dZBc=qdr.dD(cs.vecZ());	
		Body bdQdr(qdr.ptOrg(), cs.vecX(),cs.vecY(),cs.vecZ(),dXBc,dYBc,dZBc,0,0,0);	
		bdQuaders.append(bdQdr);
	}

// order abc#s and quaders by size
	for(int a=0;a<abcs.length();a++)
		for(int b=0;b<abcs.length()-1;b++)
		{
			double dVol1 = bdQuaders[b].volume();
			double dVol2 = bdQuaders[b+1].volume();
			if (dVol1<dVol2)
			{
				abcs.swap(b, b+1);
				bdQuaders.swap(b, b+1);	
			}	
		}
	
	for(int a=0;a<abcs.length();a++)
	{
		AnalysedBeamCut abc = abcs[a];
		String sToolSubType =abc.toolSubType();
		CoordSys cs = abc.coordSys();
		Quader qdr = abc.quader();
		Point3d pt = cs.ptOrg()+vz*a*U(100);
		double dXBc=qdr.dD(cs.vecX());
		double dYBc=qdr.dD(cs.vecY());
		double dZBc=qdr.dD(cs.vecZ());
			
		Vector3d vecFace = vz;
		int nFlip;
		if (abc.bIsFreeD(vecFace))nFlip=1;
		else if (abc.bIsFreeD(-vecFace))nFlip=-1;
		if (nFlip==0)continue;// only beamcuts on main faces supported	
		Plane pnFace(ptCen+vecFace*.5*dZ, vecFace);
	
	// the array of segs to be drawn
		LineSeg segs[0];
		String sTxts[0];
		String sLength, sWidth, sHeight;
		
	// color and line type
		int nCutColor=3;
		dp.lineType("CONTINUOUS");
		if (nFlip<0)
		{
			nCutColor=6;
			dp.lineType("DASHED");	
		}
		dp.color(nCutColor);	

	// some bodies related to the tool					
		Body bdQdr=bdQuaders[a];//(qdr.ptOrg(), cs.vecX(),cs.vecY(),cs.vecZ(),dXBc,dYBc,dZBc,0,0,0);
		//bdQdr.vis(a);
		//continue;
		Body bdQdrTest(qdr.ptOrg(), cs.vecX(),cs.vecY(),cs.vecZ(),dXBc+U(1),dYBc+U(1),dZBc+U(1),0,0,0);// a test body to find out if the tool intersects any edge
		//if (nDebug==4)dp.draw(sToolSubType, bdQdr.ptCen(),_XW,_YW,0,0,_kDeviceX);	
		
		Body bdToolEnvelope=bdQdr;	
	// subtract any quader body being bigger and previously checked // debug trial version 1.3: this would eliminate duplicate areas if intersecting in full tool width
		if(0)
		{
			for(int x=0;x<a;x++)
			{
				Body bd=	bdQuaders[x];
				if (bd.hasIntersection(bdToolEnvelope))
				{
					bd.vis(4);
					bdToolEnvelope.subPart(bd);
				}
			}
		}	

		bdToolEnvelope.intersectWith(bdEnvelope);		
		Body bdToolBox = bdToolEnvelope;
	// if the tool envelope consists of multiple lumps recompose into one solid
		if (bdToolBox.decomposeIntoLumps().length()>1)
		{
			Point3d ptCenSolid = bdToolBox .ptCen();
			Point3d ptsX[] = bdToolBox .extremeVertices(cs.vecX());
			Point3d ptsY[] = bdToolBox .extremeVertices(cs.vecY());
			Point3d ptsZ[] = bdToolBox .extremeVertices(cs.vecZ());
			if (ptsX.length()>0 && ptsY.length()>0 && ptsZ.length()>0)
			{
				Point3d ptM;
				ptM.setToAverage(ptsX);
				ptCenSolid.transformBy(cs.vecX()*cs.vecX().dotProduct(ptM-ptCenSolid));
				ptM.setToAverage(ptsY);
				ptCenSolid.transformBy(cs.vecY()*cs.vecY().dotProduct(ptM-ptCenSolid));
				ptM.setToAverage(ptsZ);
				ptCenSolid.transformBy(cs.vecZ()*cs.vecZ().dotProduct(ptM-ptCenSolid));
				
				dXBc = abs(cs.vecX().dotProduct(ptsX[0]-ptsX[ptsX.length()-1]));
				dYBc = abs(cs.vecY().dotProduct(ptsY[0]-ptsY[ptsY.length()-1]));
				dZBc = abs(cs.vecZ().dotProduct(ptsZ[0]-ptsZ[ptsZ.length()-1]));
				
				Vector3d vecXBc = cs.vecX();
				Vector3d vecYBc = cs.vecY();
				Vector3d vecZBc = cs.vecZ();


				
				if (dXBc>dEps && dYBc>dEps && dZBc>dEps )	bdToolBox = Body(ptCenSolid, vecXBc, vecYBc, vecZBc, dXBc, dYBc, dZBc,0,0,0);
			}				
		}	
		bdToolBox 	.vis(40);	
		bdToolEnvelope.vis(8);
	
	
	
	
		
	// check for advanced analysis
		int bAdvancedAnalysis;
		if (sArAllowedTypes.find(sToolSubType)>-1)	bAdvancedAnalysis=true;
		//bdQdr.vis(bAdvancedAnalysis);	
		
	// simple analysis
		if (!bAdvancedAnalysis)
		{
					
		// consider biggest dimension to be the length	
			if (dYBc>dXBc)
			{ 
				double d = dXBc;
				dXBc=dYBc;
				dYBc=d;
			}
			
			ptsBeamCutsData.append(Point3d(dXBc,dYBc,dZBc));
			LineSeg seg;
			String sTxt;
			sWidth.formatUnit(dYBc,2,0);
			sHeight.formatUnit(dZBc,2,0);

			if (sToolSubType==_kABCDado || sToolSubType==_kABCDiagonalSeatCut)
			{
				sTxt=T("|Dado|");
				Point3d ptStart = qdr.ptOrg()-.5*cs.vecX()*dXBc; ptStart=ptStart.projectPoint(pnFace,0);
				Point3d ptEnd = qdr.ptOrg()+.5*cs.vecX()*dXBc; ptEnd=ptEnd.projectPoint(pnFace,0);
				sLength.formatUnit(Vector3d(ptStart-ptEnd).length(),2,0);
				seg=LineSeg (ptStart, ptEnd);
			}
			else if (sToolSubType==_kABCRabbet)
			{
				sTxt=T("|Rabbet|");
				cs.vecY().vis(qdr.ptOrg(),3);
				Point3d ptStart = qdr.ptOrg()-.5*cs.vecX()*dXBc; ptStart=ptStart.projectPoint(pnFace,0);
				Point3d ptEnd = qdr.ptOrg()+.5*cs.vecX()*dXBc; ptEnd=ptEnd.projectPoint(pnFace,0);
				sLength.formatUnit(Vector3d(ptStart-ptEnd).length(),2,0);
				seg=LineSeg (ptStart, ptEnd);	
				seg.transformBy(-cs.vecY()*.5*dYBc);			
			}
			else if  (sToolSubType==_kABCHousingThroughout || sToolSubType==_kABCHouseRotated)
			{
				ptsBeamCutsData.append(Point3d(dXBc,dYBc,dZBc));	
				Body bd=bdQdr;
				bd.vis(4);				
				bd.intersectWith(bdEnvelope);
				PlaneProfile pp= bdQdr.getSlice(pnFace);
				//pp.transformBy(sip2child);
				dp.draw(pp);

				dp.draw("Öffnung ", pp.extentInDir(_XW).ptMid(),_XW,_YW,0,0);	
				double d=-3;
				if (abc.dAngle()>dEps && abc.dAngle()<90)
				{
					dp.draw("A:"+abc.dAngle()+"°", pp.extentInDir(_XW).ptMid(),_XW,_YW,0,d);	
					d-=3;
				}
				if (abc.dBevel()>dEps && abc.dBevel()<90)
				{
					dp.draw("B:"+abc.dBevel()+"°", pp.extentInDir(_XW).ptMid(),_XW,_YW,0,d);	
					d-=3;
				}
				if (abc.dTwist()>dEps  && abc.dTwist()<90)
				{
					dp.draw("C:"+abc.dTwist()+"°", pp.extentInDir(_XW).ptMid(),_XW,_YW,0,d);	
					d-=3;
				}								
			
			}			
			else
			{
				sTxt=T("|Beamcut|");
				dp.draw(sTxt, pt,_XW,_YW,0,0);	
			}
			
			//seg.transformBy(sip2child);
			segs.append(seg);	
			sTxts.append(sTxt+" " + sLength+ "x" + sWidth+"x"+sHeight);	
	
			
		}
	//advanced analysis
		else
		{
		// collect intersecting edges
			SipEdge edgesTool[0];
			double _dXBc = dXBc;
			for(int e=0;e<edges.length();e++)
			{
				SipEdge edge = edges[e];	
				Point3d ptOrg = edge.ptMid();
				Point3d pts[] = edge.plEdge().vertexPoints(true);if (pts.length()<2)continue;				
				Vector3d vzCut = edge.vecNormal();
				Vector3d vxCut =pts[pts.length()-1]-pts[0];
				dXBc = vxCut.length();
				vxCut.normalize();
				Vector3d vyCut = vxCut.crossProduct(-vzCut);	
				Body bdEdge(ptOrg,vxCut, vyCut, vzCut,dXBc, 3*dZ, U(1), 0, 0,-1);				
				if (bdEdge.hasIntersection(bdQdrTest))
				{
					bdEdge.vis(2);
					edgesTool.append(edge);
				}
			}
		// when no edges intersect export as simple
			if (edgesTool.length()<1)
			{
				dXBc = _dXBc;
			// consider biggest dimension to be the length	
				if (dYBc>dXBc)
				{ 
					double d = dXBc;
					dXBc=dYBc;
					dYBc=d;
				}				

				ptsBeamCutsData.append(Point3d(dXBc,dYBc,dZBc));	
				Body bd=bdQdr;
				bd.intersectWith(bdEnvelope);
				PlaneProfile pp= bd.extractContactFaceInPlane(pnFace, dEps);
				//pp.transformBy(sip2child);
				dp.draw(pp);	
				dp.draw("Vertiefung " + dZBc, pp.extentInDir(_XW).ptMid(),_XW,_YW,0,0);					
			}
		// tool intersects with at least one edge	
			else
			{
			// extract contour in face
				Point3d pts[] = abc.genBeamQuaderIntersectPoints();
				for(int p=pts.length()-1;p>=0;p--)
					if (abs(vzView.dotProduct(pts[p]-pnFace.ptOrg()))>dEps)
						pts.removeAt(p);
				PLine pl;
				pl.createConvexHull(pnFace,pts);
				PlaneProfile pp(pl);
				//pp.vis(1);
				
				
			// loop edges and collect potential bodies
				Body bdTools[0];
				CoordSys csTools[0];	
				double dArVol[0];

				
			// test against multiple edges
				for(int e=0;e<edgesTool.length();e++)
				{	
					Vector3d vzEdge=edgesTool[e].vecNormal();
					Point3d ptMid=edgesTool[e].ptMid();
					if (pp.pointInProfile(ptMid+vzEdge*U(1))==_kPointOutsideProfile)continue;
					Body bdTool = bdQdr;
					bdTool .addTool(Cut(ptMid,vzEdge),0);
					
					Vector3d vxEdge = vzEdge.crossProduct(vzView);
					vxEdge.vis(ptMid,1);
					//bdTool .vis(e);
					edgesTool[e].plEdge().vis(5);
					
					bdTools.append(bdTool);
					CoordSys csTool(ptMid, vxEdge, vzEdge, vzView);
					csTools.append(csTool);
					dArVol.append(bdTool.volume());					
				}	
			
			// in some cases the edge test does not return any decomposed solids. use the original tool instead then
				if (bdTools.length()<1)
				{
					bdTools.append(bdToolBox);
					csTools.append(cs);
					dArVol.append(bdToolBox.volume());	
				}	

			// order all tools by size of intersection with test body
				for (int i=0; i<dArVol.length(); i++)
					for (int j=0; j<dArVol.length()-1; j++)
						if (dArVol[j]<dArVol[j+1])
						{
							dArVol.swap(j,j+1);
							csTools.swap(j,j+1);
							bdTools.swap(j,j+1);
						}
				
			// append tools as long as there is something to process
			//bdToolEnvelope.vis(20);
				for (int i=0; i<bdTools.length(); i++)
				{	
					if (bdToolEnvelope.volume()<pow(dEps,3))	break;
					bdToolEnvelope.subPart(bdTools[i]);
					bdTools[i].vis(i);

					double dXBc = bdTools[i].lengthInDirection(csTools[i].vecX());
					double dYBc = bdTools[i].lengthInDirection(csTools[i].vecY());
					double dZBc = bdTools[i].lengthInDirection(csTools[i].vecZ());
					
				// consider biggest dimension to be the x-value // version  value="1.3" date="27jan14" author="th@hsbCAD.de"> bugfix Falzlängen
					if (dXBc<dYBc)
					{
						Vector3d vecY= csTools[i].vecX();
						Vector3d vecX= -csTools[i].vecY();
						double d = dXBc;
						dXBc=dYBc;
						dYBc=d;
						csTools[i]=CoordSys(csTools[i].ptOrg(), vecX, vecY,csTools[i].vecZ() );	
					}	
					
					ptsBeamCutsData.append(Point3d(dXBc,dYBc,dZBc));	
					
					Point3d ptStart = bdTools[i].ptCen()-.5*csTools[i].vecX()*dXBc; ptStart=ptStart.projectPoint(pnFace,0);
					Point3d ptEnd  = bdTools[i].ptCen()+.5*csTools[i].vecX()*dXBc; ptEnd  =ptEnd  .projectPoint(pnFace,0);
					sLength.formatUnit(dXBc,2,0);
					sWidth.formatUnit(dYBc,2,0);
					sHeight.formatUnit(dZBc,2,0);		
				
					LineSeg seg(ptStart, ptEnd);
					seg.vis(3);
					String sTxt = 	T("|Rabbet|");
					
				// detect milling type, if both y directions are not free it is a dado
					int bXFree=abc.bIsFreeD(qdr.vecD(csTools[i].vecX()));
					int bYFree =abc.bIsFreeD(qdr.vecD(csTools[i].vecY()));
					int b_XFree=abc.bIsFreeD(qdr.vecD(-csTools[i].vecX()));
					int b_YFree =abc.bIsFreeD(qdr.vecD(-csTools[i].vecY()));
					if (!bYFree && !b_YFree && (bXFree || b_XFree))	
						 sTxt = 	T("|Dado|");
					else
						seg.transformBy(-csTools[i].vecY()*.5*dYBc);
					//seg.transformBy(sip2child);
					segs.append(seg);	
					sTxts.append(sTxt+" " + sLength+ "x" + sWidth+"x"+sHeight);	

				}					
		
			}		
		}
	// END IF advanced analysis
			
	// draw all segements and texts
		for (int i=0;i<segs.length();i++)
		{
			LineSeg seg = segs[i];
			dp.draw(seg);	
			Vector3d vxRead=seg.ptStart()-seg.ptEnd();
			vxRead.normalize();
			if (vxRead.dotProduct(_YW)<0)	vxRead*=-1;			
			Vector3d vyRead = vxRead.crossProduct(-_ZW);
			if (vxRead.dotProduct(_YW)<0 || vyRead.dotProduct(_YW)<0)	vyRead*=-1;	
			vxRead = vyRead.crossProduct(_ZW);	
			dp.draw(sTxts[i], seg.ptMid(),vxRead,vyRead,0,nFlip);			
		}// next i

	// order beamcuts data by thickness
		for (int i=0;i<ptsBeamCutsData.length();i++)
			for (int j=0;j<ptsBeamCutsData.length()-1;j++)
				if(ptsBeamCutsData[j].Z()>ptsBeamCutsData[j+1].Z())
					ptsBeamCutsData.swap(j,j+1);	
		
	}// next a abc
// END BEAMCUTS from AT_________________________________________________________________________________________________________________________________________________







// tooling map
	Map mapTools;

// drill stats
	for (int i=0;i<ptsDrillData.length();i++)
	{
		int nQty=ptsDrillData[i].Z();
		double dDepth =round(ptsDrillData[i].Y()*10)/10;
	
		Map mapTool;
		mapTool.setString("Type", "Drill");
		mapTool.setDouble("Depth", dDepth);
		mapTool.setDouble("Diameter", ptsDrillData[i].X());
		
		mapTool.setInt("Quantity", nQty);
		mapTools.appendMap("Tool", mapTool);		
	}

// cut stats
	for (int i=0;i<ptsCutsData.length();i++)
	{
		Map mapTool;
		mapTool.setString("Type", "Cut");
		mapTool.setDouble("Bevel", ptsCutsData[i].Y(),_kAngle);
		mapTool.setDouble("Length", ptsCutsData[i].X(),_kLength);

		mapTools.appendMap("Tool", mapTool);		
	}

// beamcut stats
	for (int i=0;i<ptsBeamCutsData.length();i++)
	{	
		Map mapTool;
		mapTool.setString("Type", "Beamcut");
		mapTool.setDouble("Length", ptsBeamCutsData[i].X(),_kLength);
		mapTool.setDouble("Width", ptsBeamCutsData[i].Y(),_kLength);
		mapTool.setDouble("Height", ptsBeamCutsData[i].Z(),_kLength);

		mapTools.appendMap("Tool", mapTool);		
	}
	sip.setSubMap("Tool[]",mapTools);

	if (_bOnMapIO && bDebug)
		reportMessage("\n...Analysing done for sip " +sip.posnum()+ " with " +mapTools.length());




















		


#End
#BeginThumbnail
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
=D%O$D,0'"1J%'Z5%:M4C9-_=_7^15.G!ZK\3_]G6
`







#End