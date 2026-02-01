#Version 8
#BeginDescription
version  value="1.9" date="07apr14" author="th@hsbCAD.de"> 
new option to force cluster points on axis
insert mechanism completly revised, insert now only based on materials
nail distance = 0 creates one nailing point, contact plane now real contact plane and not shadow anymore

configuration error message enhanced
cluster point will always be transformed to support edge offset. if outside of definition area a warning is shown in the command line

/// Dieses TSL erzeugt Nagelpunkte an Kontaktstellen zwischen Sparren, Konterlatte und Latte

virtual extension of rafter contact face if a valid intersection
to a contact item (counterbatten) could be found.</version>
completely revised. please read documentation</version>



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 9
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Dieses TSL erzeugt Nagelpunkte an Kontaktstellen zwischen Sparren, Konterlatte und Latte
/// </summary>

/// <insert Lang=de>
/// Wählen Sie ein oder mehrere Elemente um alle Kreuzungspunkte der angegebenen Materialien zu klammern. Alternativ
/// kann bei einer Leerauswahl der Elemente anschließend eine Individualauswahl einzelner Bauteile erfolgen.
/// </insert>

/// <command name="individuelle nagelpunkte erzeugen" Lang=de>
/// Dieser benuzterdefinierte Befehl, welcher nur in Zonen basierten Instanzen vorhanden ist, 
/// ermöglicht es die Nagelpunkte einer Instanz in einzelne Instanzen aufzulösen.
/// </property>

/// <property name="Min. Klammerabstand" Lang=de>
/// Beschreibt den Mindestabstand zwischen zwei Klammern.
/// </property>

/// History
///<version  value="1.9" date="07apr14" author="th@hsbCAD.de"> new option to force cluster points on axis. insert mechanism completly revised, insert now only based on materials </version>
///<version  value="1.8" date="26mar14" author="th@hsbCAD.de"> nail distance = 0 creates one nailing point, contact plane now real contact plane and not shadow anymore</version>
///<version  value="1.7" date="3dec13" author="th@hsbCAD.de"> configuration error message enhanced </version>
///<version  value="1.6" date="3jul12" author="th@hsbCAD.de"> cluster point will always be transformed to support edge offset. if outside of definition area a warning is shown in the command line</version>
///<version  value="1.5" date="3jul12" author="th@hsbCAD.de"> virtual extension of rafter contact face if a valid intersection to a contact item (counterbatten) could be found.</version>
///<version  value="1.4" date="28jun12" author="th@hsbCAD.de"> completely revised. please read documentation</version>
///<version  value="1.3" date="20jun12" author="th@hsbCAD.de"> new property to relocate reference nail point in relation to support edge</version>
///<version  value="1.2" date="12jun12" author="th@hsbCAD.de">supports also Zone 1 and -1</version>
/// Version 1.1   th@hsbCAD.de   17.11.2010
/// derived from lath/counterlath approach
/// Version 1.0   th@hsbCAD.de   14.05.2010
/// initial



// basics and props
	U(1,"mm");
	double dEps = U(.1);
	int bDebug = false;

	PropString sNailingDummy(22,"",T("|Nailing Zone|"));
	sNailingDummy.setReadOnly(true);
	PropString sMatNail (0,"","   " + T("|Material|"));	
	PropDouble dNailEdge(0, U(5), "   " + T("|Edge Offset|"));
	PropDouble dSupportEdge(1, U(15), "   " + T("|Edge Offset Support|") + " " + T("|(0 to ignore)|"));
	//PropDouble dStapleWidth(2, U(12), "   " + T("|Staple Width|"));
	PropDouble dDistBetweenNail(2, U(20), "   " + T("|Nail Distance|"));
	dDistBetweenNail.setDescription(T("|Defines the max Nail Distance|") + " " + T("|0 = 1 Nail|"));

	String sArNY [] ={T("|No|"),T("|Yes|")};
	PropString sSnap2Axis(2,sArNY,"   " + T("|Snap Nails to Axis|"));	
	sSnap2Axis.setDescription(T("|Projects nailing points on an axis parallel to the rafter axis|"));
	
	PropString sContactDummy(23,"",T("|Contact Zone|"));
	sContactDummy.setReadOnly(true);
	PropString sMatContact (1,"","   " + T("|Material|")+" ");	
	PropDouble dContactEdge(4, 0, "   " + T("|Edge Offset|")+ " " + T("|(0 to ignore)|"));
	
	PropString sRafterDummy(24,"",T("|Zone 0|"));
	sRafterDummy.setReadOnly(true);	
	PropDouble dRafterEdge(3, U(5), "   " + T("|Edge Offset Zone 0|"));

	PropInt nToolingIndex(0,1,T("|Tooling index|"));
	
// 2 modes
	int nMode=_Map.getInt("mode");
	// 0 = element
	// 1 = individual cluster set

// declare the tsl props
	TslInst tslNew;
	Vector3d vUcsX = _XW;
	Vector3d vUcsY = _YW;
	GenBeam gbAr[0];
	Entity entAr[0];
	Point3d ptAr[0];
	int nArProps[0];
	double dArProps[0];
	String sArProps[0];
	Map mapTsl;
	String sScriptname = scriptName();

	//if (_kExecuteKey.find("insert",0)>-1)	
	//	nMode=1;
	//if (_kExecuteKey.find("debug",0)>-1 || _bOnDebug)	
	//	bDebug=true;



// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }


	// silent/dialog
		String sKey = _kExecuteKey;
		if (sKey.length()>0)
			setPropValuesFromCatalog(sKey);	
		else
			showDialog();

	// selection of elements
		PrEntity ssEl(T("|Select Element(s)|")  + ", " + T("|<Enter> to select individual entities of one nailing cluster|"), ElementRoof());
  		if (ssEl.go())
	    	_Element = ssEl.elementSet();

	// set properties
		nArProps.setLength(0);
		dArProps.setLength(0);
		sArProps.setLength(0);
		
		nArProps.append(nToolingIndex);
		
		dArProps.append(dNailEdge);// 0
		dArProps.append(dSupportEdge);// 1
		dArProps.append(dDistBetweenNail);// 2
		dArProps.append(dRafterEdge);// 3
		dArProps.append(dContactEdge);// 4		
					
		sArProps.append(sMatNail);// 0
		sArProps.append(sMatContact );// 1
		sArProps.append(sSnap2Axis);// 2
			
	// insert element based	
		if (_Element.length()>0)
		{	
			mapTsl.setInt("mode",0);
			for(int e=0;e<_Element.length();e++)
			{
				Element el = _Element[e];
				
			// get attached tsl's of this element and validate if an instance with the same stting is already attached
				TslInst tsls[] = el.tslInst();
				int bFound;
				for (int t=0 ;t<tsls.length();t++)
				{
					TslInst tsl = tsls[t];
					if (tsl.scriptName() == scriptName() || (scriptName()=="__HSB__PREVIEW" && _bOnDebug && tsl.scriptName()=="hsbNailCluster"))	
					{
						String sMatNailThis = tsl.propString(0);
						String sMatContactThis= tsl.propString(1);
						if (sMatNailThis==sMatNail && sMatContactThis==sMatContact)
						{
							bFound=true;
							reportMessage("\n" + scriptName() + " " + T("|already attached to element|") + " " + el.number());	
							continue;
						}
						
					}
				}			
				
				if (bFound) continue;
				entAr.setLength(0);
				entAr.append(el);
				//reportMessage("\n" + scriptName() + " element e " + e);
				tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
					nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
			}
			eraseInstance();
		}

	// setup or individual insert
		else
		{
		// selection of entities			
			_GenBeam.append(getBeam(T("|Select rafter or beam")));
		// selection of nailing	
			_GenBeam.append(getSheet(T("|Select lath")));
		// selection of potential contact zone		
			Sheet shContact;
			Entity ents[0];
			PrEntity ssContact(T("|Select entities of contact zone"), Sheet());
	  		if (ssContact.go())
		    	ents= ssContact.set();
			if (ents.length()> 0 && ents[0].bIsKindOf(Sheet()))
					_GenBeam.append((Sheet)ents[0]);

		// preset dialog, tweak witha blank as showDialog seems to translate strings
			sMatNail.set(_GenBeam[1].material()+" ");
			if (_GenBeam.length()>2)	sMatContact .set(_GenBeam[2].material()+" ");				

			showDialog("---");	
			sMatNail.set(sMatNail.trimRight());
			sMatContact.set(sMatContact.trimRight());
			_Map.setInt("mode",1);
		}		
		

		return;
	}
// END Setup or Insert ____________________________________________________________________________________________________________END SETUP or insert	


// on MapIO
	if (_bOnMapIO)
	{
		int bDebugIO=false;
		if (bDebugIO)reportMessage("\n" + scriptName() + " mapIO call...");
		Map mapIn=_Map;	
		Map mapOut;
		_Map = mapOut; // clear _Map and initialize as invalidation map
		
	// get the entities
		Entity ent;
		ent=mapIn.getEntity("bm");
		Beam bm = (Beam)ent;
		ent=mapIn.getEntity("lath");
		Sheet shLath = (Sheet)ent;
		ent=mapIn.getEntity("element");
		Element el= (Element)ent;			

	// get properties
		double dDistBetweenNail=mapIn.getDouble("DistBetweenNail");
		int bSnap2Axis=mapIn.getInt("Snap2Axis");
		
		if (mapIn.hasMap("properties"))
			setPropValuesFromMap(mapIn.getMap("properties"));


	// validate
		if (!el.bIsValid() || !bm.bIsValid()  || !shLath.bIsValid())
		{
			if (bDebugIO)reportMessage("\nreturning mapIO because of missing ents");
			return;		
		}
		
		Vector3d vx,vy,vz;
		vx = el.vecX();
		vy = el.vecY();
		vz = el.vecZ();
		Point3d ptOrg = el.ptOrg();		
			
	// get zone from lath
		int nZone = shLath.myZoneIndex();
		ElemZone elzo = el.zone(nZone);

	// the ref plane
		Plane pn(shLath.ptCenSolid()+elzo.vecZ()*.5*shLath.dD(elzo.vecZ()),elzo.vecZ());
		
	// tool planeProfile
		PlaneProfile ppCluster;


	// collect contact pp
		PlaneProfile ppContacts[0],ppContact;
		if (bDebugIO)reportMessage("\n	edge offset contact: " + dContactEdge);
		if (mapIn.hasMap("contact[]") && dContactEdge>0)
		{
			if (bDebugIO)reportMessage("\nmapIO reports contacts");
			Map mapContacts = mapIn.getMap("contact[]");
			for(int m=0;m<mapContacts.length();m++)
			{
				if (bDebugIO)reportMessage("\n	m: " + m);
				Entity ent = mapContacts.getEntity(m);
				Sheet sh = (Sheet)ent;
				if (sh.bIsValid())
				{
					PlaneProfile pp = sh.profShape();
					if (ppContact.area()<pow(dEps,2))
						ppContact= pp;	
					else
						ppContact.unionWith(pp);
					
					ppContacts.append(pp);
				}
			}
		}



		
	// rafters pp	
		//PlaneProfile ppBm = bm.realBody().shadowProfile(pn);	
		PlaneProfile ppBm = bm.realBody().extractContactFaceInPlane(Plane(bm.ptCen()+vz*.5*bm.dD(vz),vz),dEps);	// hidden rafter is considered by this approach

	// test for enlargement towards ridge
		for (int c=0 ; c<ppContacts.length();c++)
		{
			PlaneProfile pp=ppBm;
			pp.intersectWith(ppContacts[c]);
			if (pp.area()>pow(dEps,2))
			{
				LineSeg lsContact = ppContacts[c].extentInDir(vy);
				Point3d ptTo=lsContact.ptMid()+.5*vy*abs(vy.dotProduct(lsContact.ptStart()-lsContact.ptEnd()));
				
				Point3d ptGrips[] = ppBm.getGripEdgeMidPoints();
				// get upmost
				int nInd=-1;
				double dMax;
				for(int i=0;i<ptGrips.length();i++)
				{
					double d=vy.dotProduct(ptGrips[i]-ptOrg);
					if (d>dMax)
					{
						dMax=d;
						nInd=i;	
					}
				}
				if (nInd>-1)
					ppBm.moveGripEdgeMidPointAt(nInd,vy*vy.dotProduct(ptTo-ptGrips[nInd]));
				break;
			}	
			
		}


		ppBm.shrink(dRafterEdge);
		ppCluster=ppBm;

	// lath pp
		PlaneProfile ppLath = shLath.profShape();	
		ppLath.shrink(dNailEdge);
		Point3d ptGrips[] = ppLath.getGripEdgeMidPoints();
		// get upmost
		int nInd=-1;
		double dMax;
		for(int i=0;i<ptGrips.length();i++)
		{
			double d=vy.dotProduct(ptGrips[i]-ptOrg);
			if (d>dMax)
			{
				dMax=d;
				nInd=i;	
			}
		}
		if (nInd>-1)
			ppLath.moveGripEdgeMidPointAt(nInd,-vy*(dSupportEdge-dNailEdge));
		ppCluster.intersectWith(ppLath);

	// contact pp
		if(ppContact.area()>pow(dEps,2))
		{
			ppContact.shrink(dContactEdge);	
			ppCluster.intersectWith(ppContact);
		}
		
	// the cluster area	
		ppCluster.vis(4);
		LineSeg seg = ppCluster.extentInDir(vx);

	// erase
		if (ppCluster.area()<pow(dEps,2))
		{
			if(bDebugIO)reportMessage("\n" + T("|No valid intersection|"));
			return;	
		}
		
	// size of cluster area
		double dX= abs(vx.dotProduct(seg.ptEnd()-seg.ptStart()));	
		double dY= abs(vy.dotProduct(seg.ptEnd()-seg.ptStart()));
		
	// validate qty and alignment
		int bHas2;
		if (dY >dDistBetweenNail)	bHas2=true;
	// align cluster points vertical if nail distance is too big or if flagged by user
		int bVertical;
		if (dX<dDistBetweenNail || bSnap2Axis) bVertical=true;

	// collect cluster points
		Point3d ptCluster[0];
		if (dDistBetweenNail<dEps)
			ptCluster.append(seg.ptMid());
		else
		{
			ptCluster.append(seg.ptMid()+vy*.5*dY);
			if (bHas2)
			{
				ptCluster.append(ptCluster[0]-vy*dDistBetweenNail);
				if(!bVertical)
				{
					ptCluster[0].transformBy(vx*.5*dDistBetweenNail);
					if (bHas2)ptCluster[1].transformBy(-vx*.5*dDistBetweenNail);
				}			
			}
		}
		mapOut.setPoint3dArray("ptCluster",ptCluster);
		PLine plRings[] = ppCluster.allRings();
		for (int r=0;r<plRings.length();r++)
			mapOut.appendPLine("pl",plRings[r]);
		_Map=mapOut;
		return;
	}
// END mapIO__________________________________________________________________________________________________________________________________


// ints
	int bSnap2Axis=sArNY.find(sSnap2Axis,0);
	

// mode 1: cluster
	if (nMode==1)
	{
	// validate
		if (_GenBeam.length()<2)
		{
			eraseInstance();
			return;			
		}
		GenBeam gb[0];
		gb = _GenBeam;
		Sheet shLath = (Sheet)gb[1];	
						
		Element el=gb[0].element();
		if (!el.bIsValid() || !shLath.bIsValid())// || !el.vecX().isParallelTo(shLath.vecX()))
		{
			eraseInstance();
			return;			
		}
		Vector3d vy = el.vecY();
		
		
	// get zone from lath	
		int nZone=shLath.myZoneIndex();
		ElemZone elzo = el.zone(nZone);
		int nSgn = nZone/abs(nZone);
		assignToElementGroup(el, true,nZone,'E');
		
		Map mapContacts;
		for (int g=2 ; g<_GenBeam.length();g++)
		{
			int nContactZone=_GenBeam[g].myZoneIndex();
		// the contact zone must be below the nailing zone
			if(nContactZone*nSgn>=nZone)continue;
				
		// collect contact items to the submap for the mapIO call	
			mapContacts.appendEntity("contact", _GenBeam[g]);							
		}	

		Map mapIO;
		mapIO.setEntity("element",el);
		mapIO.setEntity("bm",gb[0]);
		mapIO.setEntity("lath",shLath);
		mapIO.setDouble("DistBetweenNail",dDistBetweenNail);
		mapIO.setInt("Snap2Axis",bSnap2Axis);
		if (mapContacts.length()>0)
			mapIO.setMap("contact[]",mapContacts);	
		mapIO.setMap("properties", _ThisInst.mapWithPropValues());
		TslInst().callMapIO(scriptName(), mapIO);
		
	// get the cluster points from mapIO	
		Point3d ptCluster[]= mapIO.getPoint3dArray("ptCluster");		

	// append cluster points
		if (ptCluster.length()<1)
		{
			eraseInstance();
			return;
		}		
		
		Display dp(nToolingIndex);

		LineSeg lsLath = shLath.profShape().extentInDir(vy);
		double dLathWidth = abs(vy.dotProduct(lsLath.ptStart()-lsLath.ptEnd()));
		Point3d ptEdge = shLath.ptCen()+vy*(.5*dLathWidth);
		double dMoveToSupport = vy.dotProduct(ptEdge-ptCluster[0])-dSupportEdge;	
		if (abs(dMoveToSupport)>dEps && dDistBetweenNail>dEps)
		{
			ptCluster[0].vis(2);
			ptCluster[0].transformBy(vy*dMoveToSupport);
			reportMessage("\n" + shLath.posnum() + " " + T("|Nailing point not inside rule offsets.|"));
			dp.draw(PlaneProfile(mapIO.getPLine("pl")),_kDrawFilled);
		}
		else
			dp.draw(mapIO.getPLine("pl"));	
			
		ElemNailCluster cluster(nZone,ptCluster,nToolingIndex);
		el.addTool(cluster);	

		if (ptCluster.length()>1)
			dp.draw(LineSeg(ptCluster[0],ptCluster[1]));	
		else
		{
			PLine plCirc(elzo.vecZ());
			plCirc.createCircle(ptCluster[0],elzo.vecZ(),U(1.5));	
			dp.draw(plCirc);
		}
		_Pt0.setToAverage(ptCluster);
		return;
	}




// element  mode
	Element el;
	Vector3d vx,vy,vz;
	Point3d ptOrg;

	Plane pn;
	Sheet shAll[0];
	Beam bmAll[0];
	PlaneProfile ppSheets[0], ppBeams[0];
		
	if (nMode==0)
	{	
	// validate element	
		if (_Element.length()<1)
		{
			eraseInstance();
			return;	
		}
		el = _Element[0];
		vx = el.vecX();
		vy = el.vecY();
		vz = el.vecZ();
		ptOrg= el.ptOrg();
		_Pt0 = ptOrg;
		
		vx.vis(ptOrg,1);







		
	// get all genBeams
		GenBeam gbAll[] = el.genBeam();

	// the ref plane
		pn=Plane (ptOrg,vz);pn.vis(2);
		
	// reduce sset to sheets
		for (int g=0 ; g<gbAll.length();g++)
		{	
		// get any sheet	
			if (gbAll[g].bIsKindOf(Sheet()))
			{
				Sheet sh = (Sheet)gbAll[g];
				shAll.append(sh);
				ppSheets.append(sh.profShape());	
			}
		// get any beam not par to vecX
			else if (gbAll[g].bIsKindOf(Beam()) && !gbAll[g].vecX().isParallelTo(vx))
			{
				Beam bm = (Beam)gbAll[g];
				bmAll.append(bm);
				Body bd = bm.realBody();
				bd.vis(g);
				ppBeams.append(bd.extractContactFaceInPlane(Plane(bm.ptCen()+vz*.5*bm.dD(vz),vz),dEps));
				//ppBeams.append(bm.realBody().shadowProfile(pn));
			}
		}

	// nothing to do
		if (bmAll.length()<1 || shAll.length()<1)
		{
			reportMessage("\n" + scriptName() + " " + T("|no beams or sheets found|"));
			eraseInstance();
			return;	
		}		
		
	// add  triggers	
		String sTriggers[] = {T("|Create individual cluster nailings|")};
		for (int i = 0; i < sTriggers.length(); i++)
			addRecalcTrigger(_kContext, sTriggers[i]);
		int bCreateSingle;		
		if (_bOnRecalc && _kExecuteKey==sTriggers[0])
		{
			bCreateSingle=true;	
			reportMessage("\n" + scriptName() + " " + T("|is now creating individual cluster nailings for element|")+ " " + el.number());			
		}

			
		Display dp(nToolingIndex);
		String sN = sMatNail.makeUpper().trimRight();
		String sC = sMatContact.makeUpper().trimRight();
		
	// collect nailing and contact items	
		Sheet shNails[0], shContacts[0];
		PlaneProfile ppNails[0], ppContacts[0];
		for (int s=0 ; s<shAll.length();s++)
		{	
			if (shAll[s].material().makeUpper()==sN)
			{
				shNails.append(shAll[s]);
				ppNails.append(ppSheets[s]);				
			}
			else if (shAll[s].material().makeUpper()==sC)
			{
				shContacts.append(shAll[s]);	
				ppContacts.append(ppSheets[s]);	
						
			}									
		}

	// cluster counter (used to erase redundant instances)
		int nNumCluster;

	// loop through all beams
		for (int b=0 ; b<bmAll.length();b++)
		{
			Beam bm= bmAll[b];
			PlaneProfile ppBm=ppBeams[b];			
			ppBm.shrink(dRafterEdge);
			ppBm.vis(32);
		// find intersections with nailing zone	
			for (int s=0 ; s<shNails.length();s++)	
			{
				int nZone = shNails[s].myZoneIndex();			
			// assign once
				if (s==0)assignToElementGroup(el,true,nZone,'E');
				
				ElemZone elzo =el.zone(nZone);

			// declare the map for mapIO
				Map mapIO;

			// prepare creation of single instances
				if (bCreateSingle)
				{
					reportMessage("\n	"  + " " + T("|Beam|")+ " " + bm.posnum() + " + " + shNails[s].posnum() + " " +  shNails[s].material());
					mapTsl.setInt("mode",1);
					entAr.setLength(0);
					entAr.append(el);
					gbAr.setLength(0);
					gbAr.append(bm);
					gbAr.append(shNails[s]);
				}

			// find potential contact zone	
				if (abs(nZone)>1 && shContacts.length()>0)
				{
					int nSgn = nZone/abs(nZone);
					Map mapContacts;
					for (int c=0 ; c<shContacts.length();c++)
					{
						int nContactZone=shContacts[c].myZoneIndex();
					// the contact zone must be below the nailing zone
						if(nContactZone*nSgn>=nZone)continue;
					// collect contacts for single creation
						if (bCreateSingle)gbAr.append(shContacts[c]);
											
					// collect contact items to the submap for the mapIO call	
						mapContacts.appendEntity("contact", shContacts[c]);							
					}	
					mapIO.setMap("contact[]",mapContacts);
				}// END find potential contact zone	

			// call mapIO	
				if(!bCreateSingle)
				{
					Sheet shLath = shNails[s];
					LineSeg lsLath = shLath.profShape().extentInDir(vy);
					double dLathWidth = abs(vy.dotProduct(lsLath.ptStart()-lsLath.ptEnd()));
					mapIO.setEntity("element",el);
					mapIO.setEntity("bm",bm);
					mapIO.setEntity("lath",shNails[s]);
					mapIO.setDouble("DistBetweenNail",dDistBetweenNail);
					mapIO.setInt("Snap2Axis",bSnap2Axis);
					mapIO.setMap("properties", _ThisInst.mapWithPropValues());
					TslInst().callMapIO(scriptName(), mapIO);
					Point3d ptCluster[]= mapIO.getPoint3dArray("ptCluster");					
	
					shLath.envelopeBody().vis(6);
					bm.envelopeBody().vis(16);
					
	
				// append cluster points
					if (ptCluster.length()>0)
					{
						dp.color(nToolingIndex);
					// validate first cluster point to be at support edge offset
						Point3d ptEdge = shLath.ptCen()+vy*(.5*dLathWidth);
					
						double dMoveToSupport = vy.dotProduct(ptEdge-ptCluster[0])-dSupportEdge;	
						if (abs(dMoveToSupport)>dEps && dDistBetweenNail>dEps)
						{
							ptCluster[0].vis(2);
							ptCluster[0].transformBy(vy*dMoveToSupport);
							reportMessage("\n" + shLath.posnum() + " " + T("|Nailing point not inside rule offsets.|"));
							dp.draw(PlaneProfile(mapIO.getPLine("pl")),_kDrawFilled);
						}
						else
							dp.draw(mapIO.getPLine("pl"));
							
						ElemNailCluster cluster(nZone,ptCluster,nToolingIndex);
						el.addTool(cluster);	
						
						
						if (ptCluster.length()>1)
							dp.draw(LineSeg(ptCluster[0],ptCluster[1]));	
						else
						{
							PLine plCirc(elzo.vecZ());
							plCirc.createCircle(ptCluster[0],elzo.vecZ(),U(1.5));	
							dp.draw(plCirc);
						}
						//dp.draw("bs "+ +b + "/" +s, ptCluster[0], _XW,_YW,0,0,_kDeviceX);
						nNumCluster++;						
					}
				}// END call mapIO	
			// create individuals	
				else if (!_bOnDebug)
				{	
					tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
						nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance					
					if (tslNew.bIsValid())
						tslNew.setPropValuesFromMap(_ThisInst.mapWithPropValues());
				}	
			}// next nail sheet			
		}// next b beam		
		
		
		if (nNumCluster<1)
		{
			if (!bCreateSingle) reportMessage("\n" + scriptName() + " " + T("|could not collect any clusters of element|")+ " " + el.number() + " " + T("|with material|") +" "+ sMatNail);
			eraseInstance();
			return;
		}
	}




#End
#BeginThumbnail
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
-!*[W[%4J<)/3\3__V7&U
`

#End
