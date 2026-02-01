#Version 8
#BeginDescription
/// Dieses TSL erzeugt Hebemittel für CLT Panele
/// Es werden die Ausführungen Hebeschlaufe, Rampamuffe, Würth-System und Stahlanker unterstützt

version  value="2.4" date="22nov17" author="florian.wuermseer@hsbcad.com" lang="de"> 
Wenn der Verteilungsabstand = 0 ist, wird nur eine Bohrung ausgeführt
neuer Typ W4 200x umbenannt in W4.1
neuer Typ W4 200x, System Würth verfügbar (ausschließlich für Wände) Bearbeitung wird als Ausblatttung ausgeführt 
neuer Typ W4, System Würth verfügbar (ausschließlich Wände) 
zusätzlicher 3. Verteilungspunkt nur bei Typ Rampa
Symbol und Beschriftung für Einzelzeichnung veröffentlicht 

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Dieses TSL erzeugt Hebemittel für CLT Panele
/// Es werden die Ausführungen Hebeschlaufe, Rampamuffe, Würth-System und Stahlanker unterstützt
/// </summary>
/// <insert Lang=de>
/// Wählen Sie ein oder mehrere CLT Panels aus.
/// </insert>

/// <remark Lang=de>
/// Dieses TSL unterstützt verschiedene Modellausführungen:
/// ·	Hebeschlaufe
/// ·	Rampamuffe
/// ·	Würth-System
/// ·	Stahlanker
/// Diese Ausführungen werden in den Eigenschaften als eigener Typ gelistet, obwohl das zu Grunde liegende TSL für alle Variationen identisch ist.
/// Der Aufruf sollte aus diesem Grunde mittels Multifunktionsleiste, Paletten o.ä. ausgeführt werden, da die Modellausführungen mit Standardwerten vorbelegt werden können.
/// Der zugehörige Befehlsaufruf lautet: 
/// ^C^C(hsb_scriptinsert "hsbCLT-Lift.mcr" "< Katalogname >")
/// Die Zeichenkette <Katalogeintrag> wird mit dem Namen eines Katalogeintrages ersetzt. Der Name des Eintrages sollte folgenden Konventionen genügen:
/// <Katalogname> = <Beschreibung>[optional]Vorgabe?<Ausführung>
/// Beschreibung: ein Untername, welcher keinen der Schlüsselbegriffe enthält
/// Vorgabe: ergänzen Sie das Wort Vorgabe, wenn Sie keinen Dialog angezeigt bekommen möchten
/// Ausführung: einer der definierten Ausführungen
/// Vorgabe	Unterdrückt die Anzeige des Dialogs	
/// Ausführungen		
///    Hebeschlaufe	Definiert die Ausführung Hebeschlaufe (Standard)	
///    Rampa	Definiert die Ausführung Rampamuffe (nur Dach/Decke)	
///    Würth	Definiert die Ausführung Würth-System	
///    Stahl	Definiert die Ausführung Stahlanker	
/// 
/// Der Aufruf für ein Hebemittel mit dem Würth-System würde z.B. lauten:
/// ^C^C(hsb_scriptinsert "hsbCLT-Lift.mcr" "Standard?Würth")
/// Soll der Dialog nicht angezeigt werden, so lautet der Eintrag:
/// ^C^C(hsb_scriptinsert "hsbCLT-Lift.mcr" "Standard Vorgabe?Würth")
/// Die Ausführungen können auch über den entsprechenden Kontextbefehl nachträglich geändert werden.
/// </remark>
///



/// History
///<version  value="2.4" date="22nov17" author="florian.wuermseer@hsbcad.com" lang="de"> Wenn der Verteilungsabstand = 0 ist, wird nur eine Bohrung ausgeführt </version>
///<version  value="2.3" date="01feb16" author="thorsten.huck@hsbcad.com" lang="de"> neuer Typ W4 200x umbenannt in W4.1 </version>
///<version  value="2.2" date="01feb16" author="thorsten.huck@hsbcad.com" lang="de"> neuer Typ W4 200x, System Würth verfügbar (ausschließlich für Wände) Bearbeitung wird als Ausblatttung ausgeführt </version>
///<version  value="2.1" date="29jan16" author="thorsten.huck@hsbcad.com" lang="de"> neuer Typ W4, System Würth verfügbar (ausschließlich Wände) </version>
///<version  value="2.0" date="28jan16" author="thorsten.huck@hsbcad.com" lang="de"> zusätzlicher 3. Verteilungspunkt nur bei Typ Rampa </version>
///<version  value="1.9" date="14jan16" author="thorsten.huck@hsbcad.com" lang="de"> Symbol und Beschriftung für Einzelzeichnung veröffentlicht </version>
///<version  value="1.8" date="16nov15" author="thorsten.huck@hsbcad.com" lang="de"> Ausrichtung Stahlanker an polygonalen Panelen verbessert </version>
///<version  value="1.7" date="10sep15" author="thorsten.huck@hsbcad.com" lang="de"> Ausrichtung bei Dach/Deckenassoziationen korrigiert </version>
///<version  value="1.6" date="29jun15" author="th@hsbCAD.de" lang="de"> Lage bei Dach/Deckenassoziationen korrigiert, Beschreibungen der Eigenschaften erweitert </version>
///<version  value="1.5" date="28apr15" author="th@hsbCAD.de" lang="de"> Tiefe Hebeschlaufe in Wandassoziationen korrigiert </version>
///<version  value="1.4" date="27jan15" author="th@hsbCAD.de" lang="de"> Tiefe Stahlanker in Wandassoziationen korrigiert </version>
///<version  value="1.3" date="27jan15" author="th@hsbCAD.de" lang="de"> bauBit Export ergänzt </version>
///<version  value="1.2" date="19jan15" author="th@hsbCAD.de" lang="de"> stirnseitige Bohrungen für Ausführung Stahlanker bei allen Assoziationen</version>
///<version  value="1.1" date="14jan15" author="th@hsbCAD.de"> initial</version>



// constants
	U(1,"mm");
	double dEps=U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;	
	String sLastEntry = T("|_LastInserted|");
	String sDoubleClick= "TslDoubleClick";	
	int bDebug;//_bOnDebug;

	String sDefaultPropSetName = "hsbCLT";
	String sCategoryGeo = T("|Geometry|");
	String sCategoryMainTool = T("|Tooling|");

// lifting sub systems and its parameters
	String sAuto = T("|Automatic|");
	String sHChilds[] = {sAuto, "H1","H1.1", "H2","H2.1"};	double dMaxHLoads[] = {0,800,2000, 1600,4000};
	String sRChilds[] = {sAuto, "R1", "R2", "R3"};				double dMaxRLoads[] = {0,600,800,900}; 
	String sWChilds[] = {sAuto, "W1", "W2", "W3"};				double dMaxWLoads[] = {0,300,500,800};		
	String sWWallChilds[] = {sAuto,"W4", "W4.1"};				double dMaxWWallLoads[] = {0,600, 600};	
	String sSChilds[] = {sAuto, "S1","S1.1", "S2","S2.1"};	double dMaxSLoads[] = {0,800,1200,1600,4000};
	
	String sChildName=T("|Type|");
	String sChildDescription =T("|Defines the subtype of the lifting family.|");
	String sDistributionOffsetName=T("|Distribution Offset|");
	String sDistributionOffsetDescription =T("|Defines offset if more than 1 device is required.|") + " " + T("|Enter a relation to the CLT dimension i.e. '1/3' or the offset itself|");

	String sFamilies[] = {T("|Hebeschlaufe|"), T("|Rampa|"), T("|Würth|"), T("|Steel Anchor|")};
	int nFamilyColors[] = {2,3,12,252};
	String sOpmFamilies[] = {"Hebeschlaufe", "Rampa", "Würth", "Stahlanker"};
	double dFamilyDiameters[] = {U(30), U(15), U(99), U(99)};


// properties
	String sAssociationName=T("|Association|");
	String sAssociationShorts[] = {"Auto","Wall", "Roof/Floor"};
	String sAssociations[] = {sAuto, T("|Wall|"), T("|Roof/Floor|")};
	PropString sAssociation(nStringIndex++, sAssociations, sAssociationName,0);	
	sAssociation.setDescription(T("|Defines the associated type.|"));

	String sDiameterName=T("|Diameter|");
	PropDouble dDiameterOverride(nDoubleIndex++, 0, sDiameterName);	
	dDiameterOverride.setCategory(sCategoryMainTool);

	String sDepthName=T("|Depth|");
	PropDouble dDepth (nDoubleIndex++, 0, sDepthName);	
	dDepth.setCategory(sCategoryMainTool);

	String sDrillDistName=T("|Interdistance|");
	PropDouble dDrillDist(nDoubleIndex++, U(0), sDrillDistName);	
	dDrillDist.setDescription(T("|Defines the interdistance of a double drill.|") + " " + T("|Only applicable for floor/roof associations and type Hebeschlaufe.|"));
	dDrillDist.setCategory(sCategoryMainTool);
	
	String sOffsetEdgeName=T("|Edge Offset|");
	PropDouble dOffsetEdge(nDoubleIndex++, U(200), sOffsetEdgeName);	


// prepare tsl cloning
	TslInst tslNew;
	Vector3d vecXUcs = _XW;
	Vector3d vecYUcs = _YW;
	GenBeam gbs[1];
	Entity ents[0];
	Point3d ptsIn[1];
	int nProps[0];
	double dProps[0];
	String sProps[0];
	Map mapTsl;
	String sScriptname = scriptName();	
	
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

		Sip sips[0];
	
	// single or distribution insertion
		int bIsSingle;
		int nFamily; // 0=H, 1=R, 2=W, 3=S
		int nAssociation; // 0 = automatic, 1=Wall, 2 = Floor/roof

	// the catalog entry name
		String sEntry;			
		String sEntryUpper= _kExecuteKey;
		sEntryUpper.makeUpper();		
		int bIsValidEntry; // a flag which indicates that the given catalog entry exists
			
	// search for token of catalog entry and get tokenized value
		int nToken = _kExecuteKey.find("?",0);
		if (nToken>-1)
			sEntry =  _kExecuteKey.left(nToken).trimLeft().trimRight();
		else 
			sEntry =  _kExecuteKey;
			
			
	// search key for tokens
		// single insertion
		if (sEntryUpper.find("SINGLE",0)>-1)
			bIsSingle=true;
	
		// family
		String sChilds[0];sChilds=sHChilds; // Hebeschlaufe is default
		if (sEntryUpper.find("RAMPA",0)>-1)
		{
			nFamily=1;
			sChilds=sRChilds;
		}
		else if (sEntryUpper.find("WÜRTH",0)>-1)
		{
			nFamily=2;
			sChilds=sWChilds;
		}
		else if (sEntryUpper.find("STAHL",0)>-1)
		{
			nFamily=3;
			sChilds=sSChilds;
		}
		mapTsl.setInt("Family", nFamily);
		
	// set opmName and collect potential entries	
		setOPMKey(sOpmFamilies[nFamily]);
		String sOpmName = scriptName() + "-" + sOpmFamilies[nFamily];

		if (sEntry.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(sOpmName);	
		// loop entries to ignore case sensitive writing instead of using if (sEntries.find(sEntry)>-1)
			for (int i=0;i<sEntries.length();i++)
			{
				String s1 = sEntries[i];//reportMessage("\n"+sOpmName + " has Entry " + s1);
				String s2 = sEntry;
				if (s1.makeUpper()==s2.makeUpper())
				{
					bIsValidEntry=true;			
					//reportMessage("\nproperties set of : " +sEntry + " map " + mapWithPropValues() + " diameter: " + dDiameterOverride);	
					break;					
				}
			}
		}
					
	// declare childs property
		PropString sChild(nStringIndex++, sChilds, sChildName);	
		sChild.setDescription(sChildDescription);
		sChild.setCategory(sCategoryMainTool);
		

	// distribution  selection___________________distribution  selection________________________________distribution  selection
		if (!bIsSingle)
		{	
		// declare additional offset property
			PropString sDistributionOffset(nStringIndex++, "1/3", sDistributionOffsetName);	
			sDistributionOffset.setDescription(sDistributionOffsetDescription);

		// show the dialog if no catalog in use
			if (bIsValidEntry)
			{
				int b=setPropValuesFromCatalog(sEntry);
				//reportMessage("\nb:" + b);
				if(sEntry.find(T("|_Default|"),0)<0)
					showDialog(sEntry);	
			} 
			else
				showDialog();	
			
		// selection set
			Entity ents[0];
			PrEntity ssE(T("|Select CLT panels or elements|"), Sip());	
			ssE.addAllowedClass(Element());
			if (ssE.go())
				ents= ssE.set();	
	
		// collect sips	
			for(int i = 0;i <ents.length();i++)
			{
				if(ents[i].bIsKindOf(Sip()))
				{
					Sip sip = (Sip)ents[i];
					if (sips.find(sip)<0)sips.append(sip);
				}
				else if(ents[i].bIsKindOf(Element()))
				{
					Element el = (Element)ents[i];
					Sip childs[]=el.sip();
					for(int c= 0;c<childs.length();c++)
					{
						Sip sip = childs[c];					
						if (sips.find(sip)<0) sips.append(sip);
					}					
				}
			}
	
		// remove those sips which do have already an instance attached
			for(int i = sips.length()-1;i>=0;i--)
			{
				Entity ents[] = sips[i].eToolsConnected();
				for(int c= 0;c<ents.length();c++)	
				{
					TslInst tsl = (TslInst)ents[c];
					if (tsl.bIsValid() && scriptName() == tsl.scriptName())
					{
						reportMessage("\n" + T("|Panel|") + " " +sips[i].posnum() + ": " + T("|Tool already attached.|") + " " + T("|Panel will be removed from selection set|"));
						sips.removeAt(i);
						break;	
					}	
				}
				
			}
		}// END IF distribution selection
		
	// individual  selection___________________individual selection________________________________individual selection
		else if(bIsSingle)
		{
		// show the dialog if no catalog in use
			if (bIsValidEntry)
			{
				int b=setPropValuesFromCatalog(sEntry);
				if(sEntry.find(T("_Default"),0)<0)
					showDialog(sEntry);	
			} 
			else
				showDialog();	
				
			sips.append(getSip());
			ptsIn[0]= getPoint();
			mapTsl.setInt("mode",1);				
		}

	// create tsl
		for(int i = 0;i <sips.length();i++)
		{
			gbs[0] = sips[i];
			vecXUcs = sips[i].vecY();
			vecYUcs = sips[i].vecY();
			if (!bIsSingle)ptsIn[0] = sips[i].ptCen(); // distributions will have _Pt0 at ptCen
			tslNew.dbCreate(sScriptname, vecXUcs ,vecYUcs ,gbs, ents, ptsIn, 
				nProps, dProps, sProps,_kModelSpace, mapTsl);	
			if (tslNew.bIsValid())
			{
				//reportMessage("\n" + tslNew.handle() + " created");
				tslNew.setPropValuesFromCatalog(sEntry);
			}	
		}
		
		eraseInstance();
		return;
	}
// end on insert	___________________________________________________________________________________________________________________________________________________	


// validate element and/or panel link
	Element elThis;
	if (_Sip.length()<1)
	{
		eraseInstance();
		return;	
	}

// sip standards	
	Sip sip = _Sip[0];
	elThis= sip.element();
	Vector3d vecX = sip.vecX();
	Vector3d vecY = sip.vecY();
	Vector3d vecZ = sip.vecZ();	

	double dH = sip.dH();	
	PLine plShadow = sip.plShadow();
	Body bd = sip.realBody();	
	assignToGroups(sip);
	setDependencyOnEntity(sip);
	
// ref point
	Point3d ptCen = bd.ptCen();	
	
// get distribution mode and family from map
	int nMode = _Map.getInt("mode"); //0=distribution, 1=single device
	int nAssociationOverride = sAssociations.find(sAssociation);// 0 = automatic, 1= wall, 2 = floor/roof
	int nAssociation = nAssociationOverride;
	if (nAssociation==0)nAssociation=1;// default wall
	int nFamily = _Map.getInt("Family"); // 0 = Hebe, 1=Rampa, 2=Würth, 3=Stahl


// collect the weight from property set, if this fails use 471kg/m³
	String sAttachedProSetNames[] = sip.attachedPropSetNames();
	if (sAttachedProSetNames.find(sDefaultPropSetName)<0)
	{
		String sAvailableProSetNames[] = sip.availablePropSetNames();
		if (sAvailableProSetNames.find(sDefaultPropSetName)>-1)
			sip.attachPropSet(sDefaultPropSetName);	
	}
	Map mapPropSet = sip.getAttachedPropSetMap(sDefaultPropSetName);
	double dNetWeight =mapPropSet.getDouble("Weight");
	if (dNetWeight<dEps) 
		dNetWeight = sip.realBody().volume()*471/(U(1000)*U(1000)*U(1000));	

// set association from the association set with the CLT
	if (nAssociationOverride==0)
	{
		String sCltAssociation=mapPropSet.getString("Association");
		int n=sAssociationShorts.find(sCltAssociation);
		if (n>0)
			nAssociation=n;	
		//if (_bOnDebug)nAssociation=2;
		//reportMessage("\nnAssociation:" + nAssociation);	
	}


// Rampa lifting system not valid for walls
	if (nAssociation==1 && nFamily==1)
	{
		nFamily=0;
		_Map.setInt("Family",nFamily);
		reportMessage("\n" + scriptName() + " " + T("|lifting system set to|") + " " + sFamilies[nFamily] + " " + T("|panel|") + " " + sip.posnum());
	}
	setOPMKey(sOpmFamilies[nFamily]);
	
	int nFamilyColor=nFamilyColors[nFamily];
	String sFamily = sFamilies[nFamily];
	
// declare childs property
	String sChilds[0];sChilds=sHChilds; // Hebeschlaufe is default
	if (nFamily==1)		sChilds=sRChilds;
	else if (nFamily==2)	
	{
		//nFamily:  0=H, 1=R, 2=W, 3=S
		//nAssociation; 0 = automatic, 1=Wall, 2 = Floor/roof
		if (nAssociation==1)
			sChilds = sWWallChilds;
		else
			sChilds=sWChilds;
			
	}
	else if (nFamily==3)	sChilds=sSChilds;

	PropString sChild(nStringIndex++, sChilds, sChildName);	
	sChild.setCategory(sCategoryMainTool);
	// description set later on when max load is detected
	int nChild = sChilds.find(sChild);
	
	
	
// automatic drill depth
	double dDrillDepth = dDepth;
	double dDiameter = dDiameterOverride;
	if (dDrillDepth<=0)
	{
	///0=H
		if (nFamily==0)
			dDrillDepth =dH;
	// 1=R		
		else if (nFamily==1)// rampa
		{
			if (nChild==2)dDrillDepth =U(70);
			if (nChild==3)dDrillDepth =U(80);
			else dDrillDepth =U(60);		
		}
	//2=W
		else if (nFamily==2)
			dDrillDepth =U(30);
	//3=S
		else if (nFamily==3)
			dDrillDepth =dH-U(20);
	}

	if (dDiameter<=0 && nFamily>-1)
	{
		if (nAssociation==1 && nChild == 2)
			dDiameter = U(50); // width of beamcut
		else
			dDiameter = dFamilyDiameters[nFamily];
	}

// distinguish distribution rule
	double dArea = plShadow.area();
	int nRule; // 0 = wall, 1= roof/floor , 2=roof/floor < 8m²
	if (nFamily==0 && nAssociation==2 && dArea<(U(8000)*U(1000)))
		nRule=2;	// diagonal placemnet
	else if (nAssociation==2)
		nRule=1;	
	else if (nFamily==2 && nAssociation==1) // wall würth
		nRule=3;	

// collect sip edges for wall würth
	SipEdge edges[0];
	if (nRule==3)
		edges = sip.sipEdges();


// collect all surface quality style entries
	String sSQNames[] = SurfaceQualityStyle().getAllEntryNames();
	int nQualities[0];	
	for (int i=0;i<sSQNames.length();i++)
	{
		SurfaceQualityStyle sq(sSQNames[i]);
		nQualities.append(sq.quality());
	}	
// order by quality
	for (int i=0;i<sSQNames.length();i++)
		for (int j=0;j<sSQNames.length()-1;j++)
			if (nQualities[j]>nQualities[j+1])
			{
				nQualities.swap(j,j+1);
				sSQNames.swap(j,j+1);	
			}

// surface quality overrides
	String sSQRTop=sip.surfaceQualityOverrideTop();
	String sSQRBot=sip.surfaceQualityOverrideBottom();
	int nSQRTop = sSQNames.find(sSQRTop);
	int nSQRBot = sSQNames.find(sSQRBot);

// set the reference side for the lifting device
	Vector3d vecFace = -vecZ;
	if (nAssociation ==2) // 1.6
		vecFace *=-1;
	if (nSQRTop<nSQRBot)
		vecFace *=-1;

	
// add flip trigger if qualities are equal
	if (nSQRTop==nSQRBot)
	{
		String sTriggerFlipSide = T("|Flip Side|");
		int bFlip = _Map.getInt("flip");
		addRecalcTrigger(_kContext, sTriggerFlipSide);
		if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick)) 
		{
			if (bFlip)	bFlip =false;
			else bFlip=true;
			_Map.setInt("flip",bFlip);		
		}
		if (bFlip)
			vecFace*=-1;
	}
	Plane pnZ(sip.ptCen(), vecFace);	
	vecFace.vis(ptCen,2);


/// declare ref point on face
	Point3d ptRef = sip.ptCenSolid();
	ptRef.transformBy(vecFace*.5*sip.dH());	
	vecFace.vis(ptRef,1);
	Plane pnRef(ptRef,vecFace);

// add triggers to change family
	String sChangeFamilies[0];sChangeFamilies= sFamilies;
	sChangeFamilies.removeAt(nFamily);// remove the current family
	// search rampa and remove if associated as wall
	if (nAssociation==1)
	{
		int n=sChangeFamilies.find(sFamilies[1]);
		sChangeFamilies.removeAt(n);
	}
	String sTriggerChangeFamily  = T("|Change Family|");
	addRecalcTrigger(_kContext, sTriggerChangeFamily);
	for (int i=0;i<sChangeFamilies.length();i++)
	{
		String sTrigger = "   "+sChangeFamilies[i];
		addRecalcTrigger(_kContext, sTrigger);
		if (_bOnRecalc && _kExecuteKey==sTrigger) 
		{
			sTrigger.trimLeft();
			int nNewFamily = sFamilies.find(sTrigger);
			_Map.setInt("Family",nNewFamily);
			_Map.setInt("FamilyChanged",true);
		// reset childs property also			
			if (nFamily==0)		sChilds=sHChilds;
			else if (nFamily==1)	sChilds=sRChilds;
			else if (nFamily==2)	sChilds=sWChilds;
			else if (nFamily==3)	sChilds=sSChilds;
			sChild.set(sChilds[0]);	
			
			setExecutionLoops(2);
			return;		
		}
	}

// define a pline cross for visualization
	PLine plCross(vecFace);
	plCross.addVertex(_Pt0);
	plCross.addVertex(_Pt0-vecX*dDiameter*.7);
	plCross.addVertex(_Pt0+vecX*dDiameter*.7);
	plCross.addVertex(_Pt0);
	plCross.addVertex(_Pt0-vecY*dDiameter*.7);
	plCross.addVertex(_Pt0+vecY*dDiameter*.7);	
	
// rotate by 45°
	CoordSys csRot;
	csRot.setToRotation(45,vecZ,_Pt0);
	plCross.transformBy(csRot);	
	plCross.vis(40);
	
// declare display
	Display dpModel(nFamilyColor);
	if (_bOnDebug)dpModel.draw(sFamilies[nFamily], ptCen,_XW,_YW,0,0,_kDeviceX);


// get sub system
	String sLiftingChilds[0];
	double dMaxLoads[0];
	if (nFamily==0) // lifting straps
	{
		sLiftingChilds=sHChilds;
		dMaxLoads = dMaxHLoads;
	}
	else if (nFamily==1)// rampa
	{
		sLiftingChilds=sRChilds;
		dMaxLoads = dMaxRLoads;
	}
	else if (nFamily==2)// würth
	{
		if (nAssociation == 1)// wall
		{
			sLiftingChilds=sWWallChilds;
			dMaxLoads = dMaxWWallLoads;
		}
		else
		{
			sLiftingChilds=sWChilds;
			dMaxLoads = dMaxWLoads;
		}
	}
	else if (nFamily==3)// steel
	{
		sLiftingChilds=sSChilds;
		dMaxLoads = dMaxSLoads;
	}
	
// set descriptions based on types and selections
	String sMaxLoadsDescription;
	for (int i=1;i<	dMaxLoads.length();i++)
	{
		sMaxLoadsDescription+=sLiftingChilds[i] +"="+ dMaxLoads[i] + "kg ";
		if (i<dMaxLoads.length()-1)sMaxLoadsDescription+=", ";
	}
	sChild.setDescription(sChildDescription + " " +sMaxLoadsDescription);

	String sDiameterOverrideDescription;
	for (int i=0;i<sFamilies.length();i++)
	{
		sDiameterOverrideDescription+=sFamilies[i] +"="+ dFamilyDiameters[i]/U(1,"mm");
		if (i<sFamilies.length()-1)sDiameterOverrideDescription+=", ";
	}
	dDiameterOverride.setDescription(T("|0 = automatic by Family|") + " "  + sDiameterOverrideDescription);

	String sDepthDescription;
	sDepthDescription.formatUnit(dDrillDepth, 2,3);
	sDepthDescription = T("|current depth|")+ " = "+ sDepthDescription;
	dDepth.setDescription(T("|0 = automatic|") + " " + sDepthDescription);
	
	
	
	
// get lifting direction vector
	Vector3d vecXLift, vecYLift, vecZLift;
	if (nAssociation==2) // floor / roof association
	{
		vecZLift= vecFace;
		// override lifting direction by custom value
		if (_Map.hasVector3d("vecLift")) vecZLift = _Map.getVector3d("vecLift");
		
	// make sure the vecX direction of the lifting points to the bigger dimension	
	// version  value="1.7
		LineSeg seg = PlaneProfile(plShadow).extentInDir(vecX);
		double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
		double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));	
		if (dX<dY)
			vecXLift = vecY;
		else
			vecXLift = vecX;
	}
	else if (elThis.bIsValid()) // wall and valid element ref
	{
		vecZLift= elThis.vecY();
		// override lifting direction by custom value
		if (_Map.hasVector3d("vecLift")) vecZLift = _Map.getVector3d("vecLift");
		vecXLift = vecZLift.crossProduct(vecFace);	
	}
	else // wall, no element ref
	{
	// if the panel is perp to world Z a flat wall view convention is assumed
		if (vecZ.isParallelTo(_ZW))
			vecZLift=_YW;
	// if the panel Z is perp to world Z a 3D  wall view convention is assumed			
		else if (vecZ.isPerpendicularTo(_ZW))
			vecZLift=_ZW;
	// panel coordSys
		else
			vecZLift=vecY;
	// override lifting direction by custom value
		if (_Map.hasVector3d("vecLift")) vecZLift = _Map.getVector3d("vecLift");
		
		vecXLift = vecZLift.crossProduct(vecFace);	
	}
	vecYLift = vecXLift.crossProduct(-vecZLift);	
	vecXLift.vis(_Pt0,1);
	vecYLift.vis(_Pt0,3);
	vecZLift.vis(_Pt0,150);	




// collect other lifting devices attached to this panel with the same lifting direction
	Entity entConnectedTools[] = sip.eToolsConnected();
	int nQtyDevices;
	for(int c= 0;c<entConnectedTools.length();c++)	
	{
		TslInst tsl = (TslInst)entConnectedTools[c];
		if (tsl.bIsValid() && scriptName() == tsl.scriptName() && tsl!=_ThisInst)
		{
			Map map = tsl.map().getMap("Lifting");
			int nQty = map.getInt("qty");
			Vector3d vecLift = map.getVector3d("vecLift");
			if (vecZLift.isCodirectionalTo(vecLift))
				nQtyDevices+=nQty ;
		}	
	}

	
// get shadow, contour and validation
	//PlaneProfile ppShadowGros(CoordSys(ptRef, vecXLift, vecYLift, vecZLift));
	//ppShadowGros.joinRing(plShadow,_kAdd);
	PlaneProfile ppShadowGros(plShadow);
	PlaneProfile ppShadow = bd.shadowProfile(pnRef);//(plShadow);//
	Vector3d vecYN = vecXLift.crossProduct(-vecFace);
	LineSeg segShadow = ppShadowGros.extentInDir(vecXLift);//segShadow .vis(3);
	double dXShadow = abs(vecXLift.dotProduct(segShadow.ptStart()-segShadow.ptEnd()));
	double dYShadow = abs(vecYN.dotProduct(segShadow.ptStart()-segShadow.ptEnd()));	
	if (_bOnDebug){PlaneProfile pp=ppShadow;pp.transformBy(vecYN*2*dYShadow);pp.vis(1);}

	// ppShadow.shrink(dOffsetEdge);	seems to fail in 20.0.50.0
	PlaneProfile ppRange =ppShadowGros;
	ppRange.shrink(dOffsetEdge);
	PlaneProfile ppRangeGros=ppRange;
	//if (_bOnDebug){PlaneProfile pp=ppRange;pp.transformBy(vecYN*2*dYShadow);pp.vis(2);}

// subtract shrinked opening rings from range
	PLine plRings[]=ppShadow.allRings();
	int bIsOp[] = ppShadow.ringIsOpening();
	PlaneProfile ppOpenings[0];
	for (int r =0;r<plRings.length();r++)
	{
		PLine pl =plRings[r]; 
		if (bIsOp[r] && pl.area()>pow(dDiameter,2))	
		{
			PlaneProfile pp(pl);
			pp.shrink(-dOffsetEdge);
			ppOpenings.append(pp);
			ppRange.subtractProfile(pp);	
		}
	}	
	//if (_bOnDebug){PlaneProfile pp=ppRange;pp.transformBy(vecYN*2*dYShadow);pp.vis(2);}

// for roof/floor associations intersecting the gros range and not fully inside the range try to append a range with half of the edgeoffset		
	PlaneProfile ppAdd;
	if (nAssociation==2)
	{
		int bAdd;
		for (int o=0;o<ppOpenings.length();o++)
		{
			//if (_bOnDebug){PlaneProfile pp=ppOpenings[o];pp.transformBy(vecYN*2*dYShadow);pp.vis(4);}
			PlaneProfile ppTest=ppOpenings[o];
			ppTest.subtractProfile(ppRangeGros);
			if (ppTest.area()>pow(dEps,2))
			{
				bAdd=true;
				break;
			}	
		}
	
	// add half edge offset profile
		if (bAdd)
		{
			double dOffsetEdge05=dOffsetEdge*.5;
			ppAdd=ppShadowGros;
			ppAdd.shrink(dOffsetEdge05);	
			//if (_bOnDebug){PlaneProfile pp=ppAdd;pp.transformBy(vecYN*2*dYShadow);pp.vis(5);}
		
		// subtract half shrinked opening rings from range	
			for (int r =0;r<plRings.length();r++)
			{
				PLine pl =plRings[r]; 
				if (bIsOp[r] && pl.area()>pow(dDiameter,2))	
				{
					PlaneProfile pp(pl);
					pp.shrink(-dOffsetEdge05);
					ppAdd.subtractProfile(pp);	
				}
			}	
			//if (_bOnDebug){PlaneProfile pp=ppAdd;pp.transformBy(vecYN*2*dYShadow);pp.vis(5);}
			
		// find intersections with openings
			PlaneProfile ppAdd2;
			for (int o=0;o<ppOpenings.length();o++)
			{
				PlaneProfile ppTest=ppOpenings[o];
				ppTest.intersectWith(ppAdd);
				if (ppTest.area()>pow(dEps,2))
				{
					if (ppAdd2.area()<pow(dEps,2))
						ppAdd2=ppTest;
					else
						ppAdd2.unionWith(ppTest);	
				}
			}
			ppAdd=ppAdd2;
			//if (_bOnDebug){PlaneProfile pp=ppAdd;pp.transformBy(vecYN*2*dYShadow);pp.vis(70);}
			ppRange.unionWith(ppAdd);
		}	
	}
	//if (_bOnDebug){PlaneProfile pp=ppRange;pp.transformBy(vecYN*2*dYShadow);pp.vis(40);}

	ppAdd.vis(6);
	ppRange.vis(1);

 //validate offsetd contour, for small panels remove tool
	if (ppRange.area()<pow(dEps,2))
	{
		Display dpInfo(1);
		dpInfo.draw("***** " + _ThisInst.opmName()+" *****",_Pt0, vecXLift, vecYN, 0,3, _kDevice);
		dpInfo.draw(T("|Dimensions do not match lifting distribution|")+ " " + sip.posnum(),_Pt0, vecXLift, vecYN, 0,0, _kDevice);
		
		//reportMessage("\n"+ T("|Dimensions do not match lifting distribution|") + "\n" + T("|Tool will be deleted.|"));
		//eraseInstance();
		return;
	}
	
// declare variables for toolings and distribution direction
	Point3d ptsLoc[0];	
	Vector3d vecDir = vecZLift;	
	double dMaxIncrement=dXShadow*.5;
	if (nAssociation==2 && dXShadow>dYShadow)
		vecDir=vecYLift;
	else if (nAssociation==2 && dYShadow>dXShadow)
	{
		vecDir=vecXLift;
		dMaxIncrement=dYShadow*.5;
	}
	
	
		
	
// individual device________________________________________________________________________________________________________
	if (nMode==1)
	{
		setEraseAndCopyWithBeams(_kBeam0);
		if (_kNameLastChangedProp=="_Pt0" && dOffsetEdge>0)
		{
			_Pt0=ppRange.closestPointTo(_Pt0);
			setExecutionLoops(2);	
		}
		
		ptsLoc.append(_Pt0);
	}	
// device collection mode________________________________________________________________________________________________________	
	else
	{	
		_Pt0 =ptCen;		
		
	// declare additional offset property
		PropString sDistributionOffset(nStringIndex++, "1/3", sDistributionOffsetName);	
		sDistributionOffset.setDescription(sDistributionOffsetDescription);
					
	// set distribution quantity
		//nFamily; 0=H, 1=R, 2=W, 3=S
		//nAssociation: 0 = automatic, 1=Wall, 2 = Floor/roof
		int nQtyDistr=1;
		if (nAssociation==1 && (dXShadow>=U(2000)) )// wall with two devices  // || dNetWeight>200)
			nQtyDistr=2;
		else if (nAssociation==2 && dXShadow>=U(8000) && dH<=U(80) && nFamily==1)// rampa in a floor/roof receives an additional third device: version  value="2.0" date="28jan16"
			nQtyDistr=3;			
		else if (nAssociation==2)// default floor roof
			nQtyDistr=2;
			
	// get distribution distance
		double dDistributionOffset;
		if(nQtyDistr>1)
		{
			int n = sDistributionOffset.find("/",0);
			if (n>-1)
			{
				int nChars = sDistributionOffset.length();
				String sLeft = sDistributionOffset.left(n).trimLeft().trimRight();
				String sRight = sDistributionOffset.right(nChars-n-1).trimLeft().trimRight();
				double dA = sLeft.atof();
				double dB = sRight.atof();
				if (dA>0 && dB>0)
					dDistributionOffset=dXShadow*(dA/dB);
			}
			else
				dDistributionOffset=sDistributionOffset.atof();	
		}
			
	// collect distribution ref points
		if (dDistributionOffset == 0)
			nQtyDistr = 1;
		Point3d ptsDistrRef[0];
		Point3d pt = ptCen-vecXLift*(nQtyDistr-1)*.5*dDistributionOffset;
		pt.transformBy(vecFace*vecFace.dotProduct(ptRef-pt));// 1.6
		for (int i=0;i<nQtyDistr;i++)
		{
			ptsDistrRef.append(pt);
			pt.vis(7);
			pt.transformBy(vecXLift*dDistributionOffset);
		}	

	// flag to collect segment mid points
		int bCollectMidPoint=nAssociation==2 && ppAdd.area()>pow(dEps,2) && nFamily == 0 ;

	// loop ref locations until valid locations are found or interdistnace exceeds max value
		double dIncrement; // the increment to offset in  x
		int nDir = -1;		
		int nCntMax = dMaxIncrement/dDiameter+1;
		int nCnt;
		while (nCnt<nCntMax)
		{		
			Point3d pts[0];
			for (int i=0;i<ptsDistrRef.length();i++)
			{
				Point3d pt = ptsDistrRef[i];
				Vector3d vecOffset = vecXLift;
				if (vecOffset.dotProduct(pt-ptCen)<0)vecOffset*=-1;
				LineSeg segSplit(pt-vecDir*(dXShadow+dYShadow),pt+vecDir*(dXShadow+dYShadow)); //segSplit.vis(5);
				segSplit.transformBy(vecOffset*dIncrement);
				
				LineSeg segSplits[0];
			// wall würth rule
				if (nRule==3)
					segSplits = ppShadowGros.splitSegments(segSplit, true);
			// all other rules	
				else
					segSplits = ppRange.splitSegments(segSplit, true);
					
				Point3d ptsInt[0];
				for (int k=0;k<segSplits.length();k++)
				{
					LineSeg seg = segSplits[k]; seg.vis(4);
				// collect start and end point as default
					if (bCollectMidPoint && ppAdd.pointInProfile(seg.ptMid())==_kPointInProfile)
						ptsInt.append(seg.ptMid());
					else
					{	
						ptsInt.append(seg.ptStart());
						ptsInt.append(seg.ptEnd());
					}
				}// next k
				ptsInt= Line(pt,vecDir).orderPoints(ptsInt);
				if (ptsInt.length()<1)continue;
				if (nRule==0 || nRule==3) // wall rule, collect any point above point of gravity
				{
					Point3d ptInt = ptsInt[ptsInt.length()-1];
					if (vecDir.dotProduct(ptInt-ptCen)>0)
						pts.append(ptInt);	
				}
				else if (nRule==1)// floor roof
				{
					pts.append(ptsInt[0]);
					pts.append(ptsInt[ptsInt.length()-1]);
				}
				else if (nRule==2) // diagonal
				{
					Point3d ptInt = ptsInt[0];
					if (i==0 && vecDir.dotProduct(ptInt-ptCen)<0)
						pts.append(ptInt);
					ptInt = ptsInt[ptsInt.length()-1];
					if(i==1 && vecDir.dotProduct(ptInt-ptCen)>0)
						pts.append(ptsInt[ptsInt.length()-1]);
				}
			
			}// next i
		
		// validate collected intersection points
			int nQty = nQtyDistr;
			if (nRule==1)nQty*=2;
			if (pts.length() == nQty)
			{
				ptsLoc=pts;
				break;	
			}	
			else
			{
				nCnt++;
				dIncrement+=dDiameter;	
			}
		}// end do while			
	}
// END IF device collection mode
	
	
// get load per device, the total amount of devices with the same lifting direction is defining the max load per device
	nQtyDevices+=ptsLoc.length();
	
	if (nQtyDevices<1)// erase if no locations are found
	{
		Display dpInfo(1);
		dpInfo.draw("***** " + _ThisInst.opmName()+" *****",_Pt0, vecXLift, vecYN, 0,3, _kDevice);
		dpInfo.draw(T("|Could not resolve locations on panel|")+ " " + sip.posnum(),_Pt0, vecXLift, vecYN, 0,0, _kDevice);
		dpInfo.draw(T("|Please insert individual instances|"),_Pt0, vecXLift, vecYN, 0,-3, _kDevice);
		dpInfo.draw(T("|or reduce edge offset|"),_Pt0, vecXLift, vecYN, 0,-6, _kDevice);
		//eraseInstance();
		return;	
	}
	double dLoadDevice = dNetWeight/nQtyDevices;
	int nSelected=sChilds.length()-1;

	int bIsW4Beamcut = nFamily == 2 && nAssociation==1 && nChild == 2;

// automatic child detection
	int bIsAllowed;// flag if the selected device can carry the load
	if (nChild==0)
	{
		double dMaxLoad;
		for (int i=1;i<sChilds.length();i++)
			if (dLoadDevice<=dMaxLoads[i])
			{
				nSelected=i;
				bIsAllowed=true;
				break;
			}	
	}
	else
	{
		if (dLoadDevice<=dMaxLoads[nChild])
			bIsAllowed=true;
		nSelected=nChild;
	}

// set string of selected child
	String sSelectedChild = sChilds[nSelected];
	if (dDiameterOverride>0) 
	{
		String s;
		s.formatUnit(dDiameterOverride,2,3);		
		if (bIsW4Beamcut) // beamcut special type wall würth
			sSelectedChild +=" "+s;
		else
			sSelectedChild +="Ø"+s;
	}
// alert user that selected device is invalid
	if (!bIsAllowed)
		dpModel.color(1);	


// add edit in place trigger
	int bCreateSingles;
	if(nMode==0)
	{
		String sTriggerEditInPlace= T("|Edit in Place|");
		addRecalcTrigger(_kContext, sTriggerEditInPlace);
		if (_bOnRecalc && _kExecuteKey==sTriggerEditInPlace) 
		{
			setCatalogFromPropValues(sLastEntry);	
			vecXUcs =vecX;
			vecYUcs =vecY;

			gbs[0] = sip;
			mapTsl.setInt("mode",1);
			mapTsl.setInt("Family",nFamily);
			bCreateSingles=true;
		}
	}// end if add edit in place trigger

	else if(nMode==1 && nAssociation==1)
	{
	// set lifting direction
		String sTriggerSetDirection= T("|Set lifting direction|");
		addRecalcTrigger(_kContext, sTriggerSetDirection);
		if (_bOnRecalc && _kExecuteKey==sTriggerSetDirection) 
		{
			PrPoint ssP("\n" + T("|Select point in lifting direction|"),_Pt0); 
			if (ssP.go()==_kOk) 
			{ // do the actual query
				Point3d ptLast = ssP.value(); // retrieve the selected point
				Vector3d vec = ptLast-_Pt0;
				if (vec.bIsZeroLength())
					_Map.removeAt("vecLift",true);
				else
				{
					Quader qdr(sip.ptCen(), vecX, vecY, vecZ, sip.solidLength(), sip.solidWidth(), sip.solidHeight(),0,0,0);
					vec=qdr.vecD(vec);
					if (!vec.isParallelTo(vecZ))	
						_Map.setVector3d("vecLift", vec);
				}
				
			}
			else
				_Map.removeAt("vecLift",true);
			setExecutionLoops(2);		
		}
	}

// shopdraw dimrequests
	

// collector for single tsls, used to retrigger freshly created individual instances
	TslInst tslSingles[0];

// declare dim request map
	Map mapRequest,mapRequests;
	mapRequest.setInt("Color", nFamilyColor);
	mapRequest.setVector3d("AllowedView", vecZ);

		
// general, works for both modes	
	for (int i=0;i<ptsLoc.length();i++)
	{
		Point3d ptLoc = ptsLoc[i];
		//nRule: 0 = wall, 1= roof/floor , 2=roof/floor < 8m²
		//nFamily: 0=H, 1=R, 2=W, 3=S
		if (nRule==3)
		{
			ptLoc = Line(ptsLoc[i], vecZ).intersect(pnZ,0);
			
		// snap to envelope if in single wall würth mode 
			if (nFamily==2 && nAssociation==1 && nMode==1)
			{
				Point3d pts[] = Line(ptLoc,-vecZLift).orderPoints(sip.plEnvelope().intersectPoints(Plane(ptLoc, vecXLift)));
				if (pts.length()>0)
				{
					double d=vecZLift.dotProduct(pts[0]-ptLoc);
					if (d>dEps)
					{
						ptLoc.transformBy(vecZLift*d);	
						_Pt0 = ptLoc;
						setExecutionLoops(2);
					}
				}
			}
		}
		else if (nAssociation!=1 && nFamily!=2)
			ptLoc = Line(ptsLoc[i], vecZ).intersect(pnZ,0.5*dH);
		else if (nAssociation==1 && (nFamily==3 || nFamily==0))//...nFamily==0 version  value="1.5" Tiefe Hebeschlaufe in Wandassoziationen korrigiert 
			ptLoc = Line(ptsLoc[i], vecZ).intersect(pnZ,0.5*dH);

	// for floor/roof assocs test if a potential location needs to be rotated
		int bRotate = nAssociation==2 && nFamily == 0 && dDrillDist>0 && ppAdd.area()>pow(dEps,2) && ppAdd.pointInProfile(ptLoc)!=_kPointOutsideProfile;			
		if (bRotate) 
		{
			ptLoc.transformBy(vecXLift*.5*dDrillDist);
			mapTsl.setDouble("Rotation", 90);	
		}
		else
			mapTsl.removeAt("Rotation",true);
		
		if (bCreateSingles)
		{
			ptsIn[0] = ptLoc;
			tslNew.dbCreate(sScriptname, vecXUcs ,vecYUcs ,gbs, ents, ptsIn, 
				nProps, dProps, sProps,_kModelSpace, mapTsl);	
			if (tslNew.bIsValid())
			{
				//reportMessage("\n" + tslNew.handle() + " created");
				tslNew.setPropValuesFromCatalog(sLastEntry);
				tslSingles.append(tslNew);
			}
			continue;			
		}		
		
		//vecFace.vis(ptLoc,7);
		PLine pl=plCross;
		pl.transformBy(ptLoc-_Pt0);
		
	// declae the drill vec
		Vector3d vecDrill = -vecFace;	
		Vector3d vecTxtOffset = vecXLift*dDiameter;
	// würth wall
		if (nRule==3)
		{
			vecDrill=-vecZLift;
		
		// test alignment of the closest edge
			double dDist = dXShadow+dYShadow;
			SipEdge edgeX;
			for (int e=0;e<edges.length();e++)
			{
				SipEdge edge = edges[e];
				PLine pl = edge.plEdge();
				double d=(pl.closestPointTo(ptLoc)-ptLoc).length();
				Vector3d vec = edge.vecNormal().crossProduct(vecFace).crossProduct(-vecFace);
				if (d<dDist && vecDrill.dotProduct(vec)<0 && !vecDrill.isPerpendicularTo(vec))
				{
					dDist=d;
					edgeX=edge;	
				}
			}
			
		// align with edge if not parallel
			if (edgeX.plEdge().length()>0)
				vecDrill = -edgeX.vecNormal();
			
		//transform to the edge of the panel
			CoordSys cs;
			cs.setToAlignCoordSys(ptLoc, vecX, vecY, vecZ, ptLoc, vecFace.crossProduct(vecDrill), vecFace, -vecDrill);
			pl.transformBy(cs);
			vecTxtOffset +=vecZLift*dDiameter;
		}	
		
	// draw symbol at location	
		dpModel.draw(pl);	
		
	// add request
		mapRequest.setInt("DrawFilled", 0);
		mapRequest.setPLine("pline", pl);
		mapRequests.appendMap("DimRequest",mapRequest);			

	// add tooling
		Body bdTool;
		if (bIsW4Beamcut && dDrillDepth>dEps && dDiameter>dEps) // wall würth beamcut
		{
			Vector3d vecXBc = vecZ.crossProduct(vecDrill);
			Vector3d vecYBc = vecZ;
			Vector3d vecZBc = vecDrill;
			vecXBc.vis(ptLoc, 1);	vecYBc.vis(ptLoc, 3);	vecZBc.vis(ptLoc, 150);

			BeamCut bc(ptLoc, vecXBc,vecYBc ,vecZBc, U(200), dDiameter, dDrillDepth,0,0,1);
			sip.addTool(bc);	
		}
		else if(dDrillDepth>dEps && dDiameter>dEps)
		{
			Drill drill(ptLoc, ptLoc+vecDrill*dDrillDepth, dDiameter*.5);
			bdTool = drill.cuttingBody();
			bdTool .vis(2);
			sip.addTool(drill);	
		}
	
	// draw warning if load exceeds max weight
		if (!bIsAllowed)
		{
			pl.createCircle(ptLoc,vecFace, dDiameter*.5);
			dpModel.draw(PlaneProfile(pl),_kDrawFilled);	
			
			mapRequest.setInt("DrawFilled", 1);
			mapRequest.setPLine("pline", pl);
			mapRequests.appendMap("DimRequest",mapRequest);		
		}
			
	// draw warning if drill is not fully inside envelope body on wall würth
		if (nRule==3)
		{
			Body bdEnv=sip.envelopeBody(false, true);
			//bdEnv.vis(2);
			bdTool.subPart(bdEnv);
			if (bdTool.volume()>pow(U(1),3))
			{
				bdTool.vis(1);
				dpModel.color(1);
				dpModel.draw(bdTool.shadowProfile(pnZ),_kDrawFilled);
			}
		}

	// draw selected child string
		dpModel.draw(sSelectedChild, ptLoc+vecTxtOffset, vecXLift, vecYN,1,0, _kDevice);	

		Map mapRequestTxt;
		//mapRequestTxt.setPoint3d("ptScale", ptLoc+vecX*);		
		mapRequestTxt.setInt("deviceMode", _kDevice);		
		mapRequestTxt.setInt("Color", nFamilyColor);
		mapRequestTxt.setVector3d("AllowedView", vecZ);				
		mapRequestTxt.setPoint3d("ptLocation",ptLoc+vecTxtOffset);	
		Point3d (ptLoc+vecTxtOffset).vis(6);	
		mapRequestTxt.setVector3d("vecX", vecXLift);
		mapRequestTxt.setVector3d("vecY", vecYN);
		mapRequestTxt.setDouble("dXFlag", 2);
		mapRequestTxt.setDouble("dYFlag", 0);			
		mapRequestTxt.setString("text", sSelectedChild);	
		mapRequests.appendMap("DimRequest",mapRequestTxt);




	// add extra drill for hebeschlaufe with floor/roof
		if (nAssociation==2 && nFamily==0 && dDrillDist>2*dDiameter )
		{
			Point3d pt = ptLoc;
			if (bRotate) pt.transformBy(-vecXLift*.5*dDrillDist);	
			else
			{
				Point3d ptNext = sip.plShadow().closestPointTo(ptLoc);
				ptNext = Line(ptNext , vecZ).intersect(pnZ,0.5*dH);
				Vector3d vecEdge = vecDir;
				if (vecEdge.dotProduct(ptNext-ptLoc)<0)vecEdge*=-1;
				//vecEdge.vis(ptNext,2);
				pt.transformBy(-vecEdge*dDrillDist);
			}
			Drill drill2(pt, pt+vecDrill*dDrillDepth , dDiameter *.5);
			sip.addTool(drill2);				
		}	
	// add extra drill for steel anchor
		if (nFamily==3)
		{
			double dDrillDepth2 = U(400);
			double dDiameter2 = U(17);
			Point3d ptNext = sip.plShadow().closestPointTo(ptLoc);
			ptNext = Line(ptNext , vecZ).intersect(pnZ,0.5*dH)-vecFace*(dDrillDepth-U(20));	
			Point3d pt1 = ptLoc+vecZ*vecZ.dotProduct(ptNext-ptLoc);
			Vector3d vecEdge = ptNext-pt1;//vecDir;
			vecEdge.normalize();
			if (vecEdge.dotProduct(ptNext-ptLoc)<0)vecEdge*=-1;
			vecEdge.vis(ptNext,2);		
			Drill drill2(ptNext, ptNext-vecEdge*dDrillDepth2 , dDiameter2 *.5);
			
			sip.addTool(drill2);				
		}

	}// next i of ptsLoc


// retrigger single instances after creation and erase caller	
	if (bCreateSingles)
	{
	// make sure all single instances will be recalculated when all instances are present to ensure the correct subtype is selected
		for (int i=0;i<tslSingles.length();i++)
			tslSingles[i].recalcNow();
		eraseInstance();
		return;
	}

	
// publish qty of lifting devices and lifting direction
	Map mapLifting;
	int nQty = ptsLoc.length();
	mapLifting.setInt("qty", nQty);
	mapLifting.setVector3d("vecLift", vecZLift);
	_Map.setMap("Lifting", mapLifting);
	_Map.setMap("DimRequest[]", mapRequests);		
			
// set compareKey
	setCompareKey(nFamily + "_" + nChild + "_" + nQty);	

	Map mapLiftingDevice;
	mapLiftingDevice.setString("Type",sFamily + " " + sChild);
	_ThisInst.setSubMapX("LiftingDevice",mapLiftingDevice);


// declare hardware comps for data export
	HardWrComp hwComps[0];
		
// set hardware
	{
	// add hardware on creation and recalc	
		int bAddHardWare = _bOnDbCreated || _bOnRecalc;
	// add hardware if family has changed
		if (_Map.getInt("FamilyChanged"))
		{
			bAddHardWare =true;
			_Map.removeAt("FamilyChanged", true);
		}
		
	// override dZ for rampa	
		double dZ = dDepth;	
		if (nFamily == 1)// rampa
		{
			double dZs[] = {U(60), U(70), U(80)};
			dZ = dZs[nChild];
		}

		HardWrComp hw(sSelectedChild , nQty);	
		hw.setCategory("LiftingDevice");
		hw.setDescription(sFamily);
		hw.setDScaleX(dDiameter);
		hw.setDScaleY(dDiameter);
		hw.setDScaleZ(dZ);	
		hwComps.append(hw);
		if (bAddHardWare)
			_ThisInst.setHardWrComps(hwComps);
	}
	 
				
			
					
#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
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
M"BBB@`HHHH`****`"BBB@`HHHH`**BN+F"S@:>YF2&)1R[L`!7%WWQ4T&&X-
MIIR7.J7><+%:QYW'V-`'<T5R-CXF\37Z;U\$W-NO_3U?1QG\ADUT.DWYU32K
M>],7E&5<F/=NVG.,9[]*`+M%<YJ/C32=*U22PNA<*T>W=(L1*+D9Y-;%AJEC
MJD/FV-U%.GJC9H`MT4@((R*6@`HHHH`****`"BBB@`HHHH`****`"BBB@`HJ
MO=WMII]N;B]NH+:$$`R32!%!/3D\5G_\);X;_P"AATG_`,#8_P#&DY);LTC2
MJ35XQ;^1L456LM0LM2A,UA>6]U$&VEX)5=0?3(/7D50/BOPXK%6U_2@0<$&\
MCX_6CF7<%2J-M*+NO(V**S;3Q!HM_<+;V6KV%S.P)$<-RCL<=>`<U;O+R"PM
M)+JY<)#&,L:$T]B90E!VDK$]%<%>>.KN1V%A:1Q1CH\WS,?P'`_6L>;Q%KEP
M>=1E3/01J%'X8%,D]5HKR)=7ULJ&35+H@\Y#[JOVWBS6[9L-<+.H_AGB`/Z8
M-`'IU%<KHOC2#4+B.TO(?LT[G:A#91CZ>QKJJ`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`*R_$.MP>'=#N=3N!E(5X7^\QX`K4KG?''A]_$WA
M2ZTV)U69MKQ[C@%E(('X]*`/G#QUX_UC790DT[1PR<E`,!1V`_QJ3P4FL1R1
MW,-BXAW9$TLBQ)^;'/Y?E3M0\.-./L]S$]M?6QZ.G*'N"._UJE:^$M9N9P-1
MDO$L\?\`'Q;H91^0Z?E0!]`Z?XP,<<45_J>A0XP"?M>6_7&:V?!LOF^%K-PR
M.AW;'3HPW'D5\]6-CX&LRT5S/K=[+&=K>3"`,CVVYKLO#OC6_P!*\/6]I975
MM#90KB$7,69%7D@-\PYH`ZK7M:EM-=URS2TDN=XA)";3CY/[N<_E7D\7C<:%
MK@>SDV+YFQU7(9&)ZD?T-5O%6I7WBK5[K48[KS+E$18?LT+*)<>C`X!_&LS2
MO"5]?ZE'<:G-NER"$=OFS_M'V]*`/I/PQXRL-<Q927$2:DB!GAW8+C^\H]*Z
MBOE?QA/)X=U_2GL+EENH(-[7'&6<G)SCMVQ7O_@#Q9'XO\+PWV5%U'^ZN4'9
MQ_C0!U-%%%`!1110`4444`%%%%`!1110`4444`<+\7?^1`N?^NT7_H5?.]?4
M7C/P[)XH\.2Z7%<)`SR(WF.I(&#GI7FO_"C;[_H-V_\`WY;_`!K@Q-&<YWBC
MZ[(\QPN&PSA5G9W??R,/P5\2#X/T:73_`.R_M7F3F;?Y^S&548QM/]VN'FD\
MV>27&-[%L9Z9->J?\*-OO^@W;_\`?EO\:/\`A1M]_P!!NW_[\M_C6,J->22:
MV/1I9CE=*I*I"=G+?<Y[X2_\E"L_^N4O_H!KV3QP3_8L*_PM.N??@_Y_"N:\
M'?"ZZ\,>)(-5EU.&=8T=3&L1!.Y2.N?>NG\;KNT2+VN%_DU=N%A*$+2/F<]Q
M-+$XE3HNZM_F>>L&$;-'%+-)TCBB7<SMZ#^M2P>%?&-[^\2S@LXVY43298?4
M9_I71^`P#K%Z2!E(5"^V3S7?UTL\9'E:^!O%B`,;C3)`/X"7&:BDT?5;`?\`
M$UTUH4(XN;9O-C4_[0SD#WKUFD90RE2`01@@T@/%9XV4Y'RLK`J1_"0>OZ5[
M-;LS6T3-]XH"?KBO'YE#-MC'R[@JCV[5[(H"J%'0#%`A:***!A1110`4444`
M%%%%`!1110`4444`%%%%`!1110`5%<W,%G;27%S*D4,8+.[G``%2UX)\>]4U
M&35K#1D>1+`PF9U7@2-DCGU`ST]Z`-3Q7K=AK-K-JVE7`EAWE8IU&-VT<X/<
M9IW@35[C4K9(;M8IES@97!].U>9:+JLUMX=ETB:/<@8O$Z\8SU!'\J[GX9R*
MI'F/MPW?CN*`,?5_$&DZ-XFU:"[AU`RQ7<B[8)4B11T_ND_K6UX0FT[4=-O+
MW[%'-YEY)L-Q\S*O8<8K$\4Z[>:%XWUN&)83$]T90Q@1]V['<Y/>KWA+6%N[
M:]EN94C9YR^S@#D=A0!S_C/Q%J44GV.T>.VAZ8@C"D_CUI?`HEDF,DSLQ'+,
MYY/N:9K.B:CKFH$V%I/.,\;(SSSZUU.F>`+RVTYDU%S!$Z_-;PL=Q]F;/Z4`
M<+XLNEUSQ++=P'=;1`1QN>C;>I^GO7I_[/<$L>E:U(0?*>=-I/K@YQ^E<G=^
M'#<WRVT&V.,?(Y/`C'0`^G6O=_"7AVW\,^'X+"`JQ`W.X_B)[T`;M%%%`!11
M10`4444`%%%%`!1110`4444`<QX_N]2T_P`&7U[I4[0W4&Q]Z@$A=PW=?:O#
MO^%D>+_^@W-_WPG_`,37TG<6\5U;2V\\8>&5"CHPX92,$5\W^-O`U]X4U!V2
M-YM,=LPW"J2%']UO0_SKBQ:FK2B]#ZCA^IA9IT*T4Y7NKI:^0S_A9'B__H-S
M?]\)_P#$T?\`"R/%_P#T&YO^^$_^)J_X.^&\WB_1Y-0CU..V$<YA*-"6S@*<
MYR/[WZ5R5OIEW>ZG_9]E!)<W!<HJ1KR<'K[5R-U4DVWJ?0PAE\YSA&$;QWT6
MGX'J/PQ\4^)/$'BLP7^I2SVD5N\DB%%`SP!T'J?TKT3QDH;1%SVF4_H:H?#[
MP8OA'1V$Y5]0N<-<,O(7'1`?09_.M'Q>,Z)TZ2`_H:]*A&48+FW/A\UK4:N)
MDZ"2BM-%:_F<]X%.W7KQ/6W!_)A7H%>=^",CQ+<`][3C_OH5Z)6[/-04R1O+
MB9_[JDT^JFIR>5I5Y)_<@=OR4TAGD\"E[BW3'/F(/U`KV.O)-/7=J]DI[W"#
M_P`>%>MT"04444#"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`KF?&7@R
MR\7V"Q3GR[F'F&8#[OL?:NFK%\3>*=+\):2^H:I.(XP=J(.7D;T4=Z`/"KCP
M=J=C=3V:0B9XR<B(_,.>N#7>^!-%DBAV7-K(K`9*O'_]:N2UOQ$GBO29M<AM
MVM2TI2/:YWA0,`[A5[P+J.KR6_E+JUYC/&Y@Y_6@#T77/#VDR-N?3[4G'S.T
M:Y/XURYMO#^E7:NXM(SUQM6MFZU#7K6/#7JR*.@>!2:XJ]UG5[RZ?S)XUQWC
MMT4C]*`.FN?&6G6L&+2":<+W2/RD_,X%48?$8UN0Q)/%$@&/*M3O<_5^@_`5
MX5XKO+F?462:YFEYY#-Q^72O0/AR^+9,L$7CGH%Y'-`#/B;,U@EGIUM((H9(
MB[(C<D@]2W4UZ/\`!GQ9-XC\*O:7;[[K3W$3/G[R_P`)->4^.YSK6N33[#]F
MMT\B$L.6"]6_$XKN/@#IDMM9ZS=LNV.21$7CK@'-`'L]%%%`!1110`4444`%
M%%%`!1110`4444`%,DC26-HY$5T8896&01[BGT4`4=,TC3]&ADATZTCMHI)#
M*R1\`L0!G';H.E,TO0]+T6)H].LHK<,<LRC+-WY8\G\36C12Y46ZLW>[>N_F
M%8?BS_D`R''1U_P_K6Y7.^,G8:+'$NX>=<)&2/Q(^G(`_&F0<QX3E%OXLC20
M[?.MV13ZD$'%>DUXI<Q36LD=U:-,UQ"=Q#C[C@\#/T_D:]!T3QM97MHG]H?Z
M'<@8?>#L)]CV_&F+8ZJLGQ+<);^'+XNV/,B,2^Y;@?SHG\2:1!'N-]$_HL1W
ML?P%<-XBUBXURYA5@UK8QO\`NP6&6.!RW/!P>/QHL%T0Z.F[7[`8_P"7A3^7
M->JUY9H<%S::]ITKEI(99MJ;UP>.">>W->IT@"BBB@84444`%%%%`!1110`4
M444`%%%%`!1110`4444`%>#?'RQO)-8TFY;=]C\ID0\X63(X^N,U[S6=K.C6
M>NZ=)97L2R1MT)&=I]10!\N:5]JL[.6T0[K64[BA_@;VKT#P0+NP(=K*6XC/
M1K==Q`]Q27OA"#3+R6SDU"&UE0#:+@%4?/3#<UW7@O2+BR`+>4P49!C<%3TY
MR*`$U/6]-^S@NMQ&Q'.^V8'/ITKSRXU6T%Q,52X;KC;;MD_I7NUW"98N!G`Z
M"N.U2U9)>8Y!CMLH`\!F\):WXDU0M9:;-'"S?ZRX&P5ZSX8\!2:+8)'-+YTN
M.0/N@U<EUS3M"B\VY"HYY!FD51_C4=CXNG\1OY<4X%OV$$>U3_P+J:`.:\46
M-G:/YEY<I#&'PSYR<<YXKV+PI;:;:^&;%-)97LVC#HZ_Q9YR?>O#OBFJM<6%
MO$-N(3,0#G.>,G/XUUGP%U:YN-&U'2IWW1V<BM"/[JMGCZ4`>OT444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!6%XP19/"M[N'W0K`^A##!K=K$\7
M#_BD]1]HL_D10".)GN$FFM?.#F1%*RS+MRP7H3G'/;/-8HL[N\_>F^:))6;:
MD0Q@<XYZG@5:>]DL[R/[+I[WTTTAV0QY8=,]/3O^'O74Z+X/FN=.AEU4"UD8
M%C;Q`,R9)."QR._3'XU0)G'PZ-<QL"NIS%LXRP!`_"KZ&Y:WC62.WF-M($R@
M*!TP.'Y/(]0#7<_\(AIBK^[$BM_>)!_I7'7UCJ6@W$\,]BTEK+/NBNU8%.>@
M(ZBA#Z%_P[B[\5QSRC<?+=D!QA?3&`/6O0JX+PJA/B>0]EA<@_\``@*[VI)0
M4444#"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`K@?B9\0O^$+LH8+2(
M3:C=9\L$9$:C^(_IQ7?5XK\;?#-S<W]AKD$3R0!/(G(YV<Y!QZ=<_A0!SFG:
MU<>(-"NY+^Z:XO&G9G#_`-WMQZ5T'@>U#-LC9E4GD(Y&*XO3K`)PF1V^6N^\
M)6.IP3*UIY$H+?<E.T_G0!V=_#<6]OF.\N5&.TE<5+/=R7D@EN[AP./FD-=C
MJL^K^44.@W!(')29&!_E7(1VNJ274CRZ8\"GG]Y(/Z4`>7^,(EDO@6Y.>,Y-
M=KX$3R[:(*/F";@H.35H?#^36M0#WMQL4M\L</WC^->C:9X<TSPW8I`@5,KP
M@^:1OZF@#RSQ'IMQ=WEQ?WIW2285%'W409PHKMO@_P"'I-)TF\O9$VFZ<!`>
MZKWK&\7:K9Z;?VPN.(I&`$07YBN1G/I7KEC'!%80);+M@$8\L>V*`+%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`5D>)XS)X8U)1U^SL?R&:UZ9
M+$D\$D3C*.I5A[&@#RW0KE;?QAIF[CSI'`_&(D5)I_Q:34/B):>'Q:O#;W#&
M-2Z<GY"RMG/<C&,?C67XAT^]L_+DMB8[_2Y%Y`SD+S&^/0C`/OFN!U2QU&#Q
MCX?\0PP_,CQRLHZ$*^6`_`XQZ4[BMV/9/B[K6I>'O"$6IZ;,8S%=QK*0Q&%;
M(SQ[XX/'-8J^)+N_T6UL]1N1-.VHQA6P`3'M8G..N"O7W%.\?^)]+\5>$+[1
M8;6[Q/M(G=`H0JX;/7)Z>G>N8LO#=\MYIKWY>!88/,D=N!&`!DGWXI)@T>B^
M#8R=;NI<<"W`)_WFW?RKN:Y[PE:E=/DOWC*->L'53U6-1A`?PY_&NAH!!111
M0,****`"BBB@`HHHH`****`"BBB@`HHHH`****`"F2QQS1F*5%=&X*L`0?P-
M/HH`\Y\3:)I.GW7F3:=($<;A-:MM(/\`M)T/X4_PQ=Z&CYAU/IP1+$T9'Z8K
MJ/$VC-J^G;8MOG1Y*Y'7CI7$^';"6.<P2HR.IY1P01_C0!WEQJ>DRQDG4+-#
MZO*!_45RVI:SID#,4UBP<]-JL7/Z"K.K:3%Y+;HEW]<%1T_G7`S:>B32%8XU
MXZA<4`:=U\3-*T>/:KW=Q+GA;>#9_P"/'G%0:=XLOM=RN%L[?L(OFE8>[GG\
M!BO,?$0']H!5^]G`SU/T'6M:P.N0VZ0V\#V>[&Z61,R'_<3KGWH`TO&K)?:[
M;V%C\QM<0R;.<R,1E<GJ1D9KZ"TRV-GI5I;,26BA5#GU`YKSGX>_#^2R:#5-
M5B9#'EH+>1MS`Y^\_OUKU&@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@#"\1>'%UR))(+E[._A&(KE!GCNC#^)3Z?E7,ZB(+/P^-)UR"V
M6[0%\P#Y3\QVNO<9Z>W->AUY+\:=1.E1V,D8_>W"/&A^A!/Y;OUH#8YZRO=,
M74EW;F:-@51VW`GGT].*[IVMM:U/1S=1*\*3X9"<AB1QD=QD"O`)#);*'N[K
M;-(H984#%U!YR1T&1[YZ<<YKK?"'B"ZM;ZUMO.^V6\ES$JL&P\3%QV//IVQZ
M4(&?20``P!@#I2T44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%5KFPM;Q<3PJQ[-C!'X]:LT4`85WX:$T12WU*[M_J5D'Y,/ZUR<_PU
MU::1C_PDA"GM]F4']*])HH`\]TCX6V^GJS2ZB\DK'+.L*[C_`,".2/PKJM+\
M,Z5I+"2"WWS]YY27?\ST_"MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`*X3XL^&_[?\`!<\T*YO-.S<Q?[2@?.OXKS]5%=W2
M,H92K`%2,$$<&@#XG>6621G<LS,Q)/<G/-;W@IC)XTT*,CKJ-OQ]'%=3JWPK
MO[+Q+=VL-S!'9>86@+AB?+)^4>^!Q]16QX6^'T%AXKTJZ-W)+)#<)(JJH`X.
M>>]-(39[U1112&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110!GZGI-OJD:B4LDB?=D3J/_K5!IGAZUTV<W&YI9SG#L,;
M<]<"M>BG=VL`4444@"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M***SY]=T>UD:.XU6QAD4X99+A%(/T)H`T**YJ?Q_X6MY&1]6C8J<$QQNX_`J
MI!_"LN;XK>'XY&6.&_G4'`>.)0#[_,P/Z468'<T5YQ/\7;%7(M]*N'3L9)%0
M_D,_SJLWQA4=-$!^MYC_`-DH`]0HKR"3XYK')M;P]D>JWN?_`&2K=K\=-&;<
M+O2;^(\8\DI(/QR5_K0!ZI17"V7Q>\'74>Z6_FM&W8V3V[Y^N5##'XUO6OC+
MPQ>1J\&OZ:V[HK7**WXJ2"/Q%`&Y134=9$5T8,C#*LIR"/44Z@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBHKFXBM+66YG<)#"ADD8C[J@9)_*@#.U_Q'IG
MAJP-WJ=P(U.?+C49>0@9PH_R!GDBO)]:^-&I7+R1:+916D.<++/^\D//7'W5
MX[?-]:X+Q/KL_B'Q!=ZE/D><_P"[0G.Q!PJ_@,=N>O>LD'UIH#>O]>U36)2^
MIZK<SY8L$9SL7/HO0?@*CB:(=$9JSX.H"IN-:40EX)*I6R6A#)0YQQ"%'O32
M3Z"G%0>LQ/TII5>QZ>U2RD,)'I4;$?W*EZ]*:P8=&`J&-&)=X\P_(15,D=JT
M+P$2'+@U18'I_2I&1DTW)%*WTIG2D,M6.JZAI<A?3[^[LW(P6MIVC)&<X.TC
M(]J]`T+XU^(M.9$U.*#4[<+@[_W4G3^\HQ]<J<^U>9&E4X/%`K'U7X2\?Z)X
MOBVVLOV>]4?/9SD!^F25_O#KR/Q`S755\8Q2-&ZNA*LIRK*<$'U%?5W@C6+C
M7_!NFZG=[3<31D2%1@,58KG';.W/XT)@=!1113$%%%%`!1110`444E`"T4T,
M#T(_#M59M2LTNA:M<1BX)QY>[G-`%NBJLNHV4)Q+=P(?1I`#47]LZ?VN5;TV
M@G^5`%^BLB3Q'IT8.'=\>B$?SQ4`\40R?ZJTG8>O&/T)I7`WJ*P_[;N7!\K3
MI&^I8?\`LM0-?:],V(K,1#U*K_\`%?TH`Z/-)7/"#7I/OS[?^!JH_1:C;2=;
MF^]J8C'HI=OZB@#I2P'4X^M0M>6R#Y[B)?JX%<VWAN+.Z\U0OCDY51_/)H,?
MART#))?Q`CJ!/C]`:`-V36-/B&6ND./[F6_E4+:_8@9#2$>NPK_/%<#XNU+2
MI=#N+/PS/`VLS$1PMOP0?4,W`YQ7SUK$7BOPMK?F:I)=VM^W[Q96DW^9SU#`
MD-3`^O3XHTU<;V=`3@$@'^1-:\4J31+)&=R,,@^HKQ6X\57MYHUOI,L+W.I!
MDE#@?<X^ZQ]1S^E>F>#+FYN/#Z&[A,,R.4*GTP#_`%I7$=#1113&%%%%`!11
M10`4444`%5M0LUU#3+JR=MJW$+Q$XS@,"/ZU9HH`^/YT*7+H3R#0OYU9\36C
M66OZA:L5)@N)(VQTRK$9'Y57T3Q!/H&HI>16EE=L@($=Y#YB<]\9'/XT186-
MW1_#>M:P$-AIUU-&S;1(D9"9_P!\_*.OK7=Z3\(]5F6-[^X@M%;.Y,^8Z]<<
M#Y3_`-]=_P`*@L?V@<1QIJ'A_+_QR6]Q@'Z*5X_[Z-=%#\<_"DOWH-3B_P!^
M!#_Z"YJ^=BL/@^$5LC+YVJNR9Y$<`4D?4L?Y5>_X5/H.>;K43_VT3_XBGI\7
MO!#JA.KR*6&=ILI^/8D)C]:OP?$?PA<`>7KD'3.&1U/Y$5-V,JVWPP\-0,3)
M#<W`(QB2=@![_+BK:_#SPHO325/^]-(W\VJ_#XM\.31+(FNZ<%/0/<JI_(D&
MG_\`"4>'O^@[I?\`X&1_XT@,N7X;^$)AA]$A^JNZG]&K*N_@YX0N6!BM[JUX
MQB&Y8Y]_GW5TTOBSP[!&7?7-/P.R7"L?R!)K/;XB^%%?;_:NX^J6\K#\PN*+
M`<=??`?2I"/L&LWEN,<B>-9>?PVUR6L_!'Q)8H9--EM=37=@(C"&0CUPYV_^
M/5ZI_P`+*TB2SO+BVMKN4VJJS*51<ACM!^]T#%0>_P`PX/..9O/B[>O*(;'2
M[>)R<`S2F3<3TX&W'YFFH-AS6/$M3T'5]&*_VEIEY9AB0K3PL@;'7!(P?PJK
M#:RRGA"!ZG@5Z!J_B[Q#XAL;F.]U&5H(2-T,0"*^3CG;]X?7(XK'U&U@@L]/
M>%R99;?=<`]%?<2`/^`&,_C^`:I]Q<QA+:*OWB37T]\/(Q#X"TE!_P`\V/YN
MQKYI`^<`'O7U-X6C6+PEHZHH4?8H3@#')0$_K2:L,UZ***0!1110`4444`%5
MM0D,6GW#@X*QD@_A5FJUZ%:SF0G[R$?I0P.)B35-'&GM8W'F+>*?,\Q1@':"
MI_G1I4#7>GZA<:I(AU!7<G#8QA>#C\#7*2#Q&;XD/(MG#<%(9"_``8A>/IBJ
MLV@:_=:KJ"K?;&,8+DN<'.2./Q-);$]3TE='TB-!-)>_*5!SYVT8Z]L5'YGA
M"#)DOK5\==\Y?'ZUPH^',]]!$9=:F2$J"JJIX'IG(JW;_#'3(VS/J5[*1UY`
M'ZYH*N=6?$O@ZT_U<EN>>2D>?Z50G^*/AFV9A$?,VC[R`8JO;^`/#D)RUCYO
M'61B?TZ5JPZ-HEH`(M,LDQTQ$N?Y46%<P9?B_;LVRTTUI.<#);^0%5?^%D^*
M+S<MIX:F7CY3Y3\_B0!75M?65J",Q1\=0-M9ESXNT*R),U]`I';=G]*`N8S:
M]\1[LYATY(4Q_%M7^M-2Q\>Z@/\`2==AM0<\!\G/T`%69?B7H2G$;S2XZ;(6
M_P`*JO\`$ZSZPZ9.[=LJH_F:5QCI/`.IW8S=>*+IGZ%43W]S3K3X9:<K[KO4
M=2FXY#.%S^0_K5)_B'JTQQ::*#SQODP?T%*/$/C2\'[G3K>//J&/]11<1T$?
M@7PS;D'[`9)`<AI)'8Y['K5N[T32;V>TFU"RBN6LF+6[3_-Y9XZ9^@Z^E<C)
MIWCW4,`W*P*?[F!C^=(OP\\2W;;KO6)SG_ILV/R%%P.WD^Q1B,+Y$69,DA0#
MWKJ=+B:*T.X$;FW`'Z"O-])^%[P3^9<7TDG'<D_S->H6\?E6\<>2=BA<GVIH
M9+1113`****`"BBB@`HHHH`*Q/$WB'_A'+"*Z-HUPLDGE\.%"\$^Y[>G_P!?
M;KE?B%:BX\)2R%L?9Y4D`QUR=OX?>_2M*24JB4MB9MJ+:/"_$%DFM:Y?7ZSI
M`;B9YC$?F*[CG&<CUK*_X17=TODQ_P!<O_LJU)TD\]HDD.V1,;=GRYP1G=VZ
M#C)/M5B"T:)5#."=Q+?BO./QKU%A*3=N4XW6G:]S!_X0]NOVX?7R?_KT'PG%
M$NZ2_8#VAS_6ND$.>>!ZT+"R[1NPHSD*U:?4Z78CZQ/N<W'H-B.#?3-CLL>/
MYU9_LVRM'A>%YLL&!:1N3T[5NJCHVW)93W+=/R']:H:@L8O(W8'E",DY[YK*
MMAX0IMI%TZKE-)E410NZ@`L68`+GK[5M1#1T_MU5AMY!OD&FR!67`20$A03R
M/+)/S9/R]<]<R!HFGB`0\..U3H/-U"W@"J9)I'4DD*-TC,F23P.,>U>8=I9M
M(;>?0+ZX2V3[1"\<BN`.(P=KY!/K)%V[?G&NS^Q3.ORSB<#B)1^[P1SC'?`Z
M9YZCNRSN9([?R(U"QW5M('7'7G<OTYCC_+WJ\F^P@NK.5/GGT]?XON[G2<?^
M.@?G^%-"*]S+*-.M1',T6]&CF",P\T%]R[N<'ITZ<>O-2./[0UE7D?YH+261
M2$Q\MNCE%[8XC49_'DU)=>7)=3QRK.LD$\,)#ORNQ=C#&/5<@?PC(YZUFNWF
MZ6SA.2S)P.V4;'Y[OSJR1Z12W+:M!$O,OFR@GCB,&0G_`+Y!JIK$$L=O&9%R
MD4\MOO7YD+($R`PX/7MVQ6M'9S+J6CQ@AFU.-CM:,$$R_NL?FF<G!!/8`$YS
MK%/H<VPYN%OS^Y)R[AUX*KC)P4()_P!I?QEC1B1#,@`%?56A+L\/::G]VTB'
M_C@KR;PA\*+VXN8+_7E6WM1A_LH/[V3N`W]T>O?@CCK7M-9/<L****0!1110
M`4444`%9&NEA:L%/.VM>J=];FX3`!Y&.*3`\NUCQ):)X;G2*XB^W+(I6(L-V
M=P!XZ^M8FD^,C#>7TFLR!3+$JH8H2<]>.*[>/X<63:RVH3*S$G.T],UI2^!-
M-N'4R0#`]#BEK85M3SQ_'NL2,4TVP3R0Q$;NIR5SQQ3#KOC2['R(JY_N05Z[
M;>'K*U0+'$H`JZNGPI]U118+'BHT_P`;WOWKJX7Z;5_I3T\!>([ILW%]<8/7
M-PW\J]L6VC4<+3Q&J\`4[#/';?X4/(<W,Y;ZG/\`.M:V^$^G1D%][?0XKT['
M%`HL!Q-M\.-'AQFVW?[S9K6M_".E0?<LX1_P$5T-%%@,^+1[.+&R!%QZ+5E;
M2%>B"IZ*=@(Q#&.B#\J=M4=`/RI:*`"EI*6@`HHHH`****`"BBB@`HHHH`*R
M?$T4<WA?5%E7<JVSOC/=1N!_,"M:BFG9W$U=6/F:YB<7$+I&TGSX;#8P,Y_K
M4$$,\=TN4D=0!D[,#.[';VKZ@HKN^NZWY?Q.=8>RM<^:GMKP[]CXR^5Y[8/'
M3Z4\6UYYJ_-\OF%NK9*Y&!7TE13^OO\`E_$/J_F?,@@DM6CCDNU4JQ9E9\$@
MX_P/YU7>,1B!3<K<.K'/(R<C_P"M7T]/!#<PM#<11RQ-]Y)%#*?J#7-:S\/?
M#NK1Q[+"WL9HW#">T@1'([@\<Y'Y?GF)8SFC;E'&A9WN>&60EGU"UBC@9F>9
M%554Y))&`*)GEL]::W=2S6KB-F*E<LF`3@@$9()Y`/->R+\*=!V;7N=1?W,J
M`_HHH/PI\.EMQDO\DY)\\?X5R7-['F4R6UGXHMK:6W;[)9O%;W*9Y8KA9L<]
MVWXP>_:F6C"7Q`JSLC1R/]F#3$A47'EKD@\!>/88_"O6H/AIX9B0B6VN+AB<
M[Y;J0'Z?*0*O6O@;PS:,631[>3(QB?,P_)R1^--206/$;._LK3[9]L4[;FW=
M49=N1+U4\@]^"1@\GGL;>F:#K6LZ<]I8Z-<2!YEG2[<&.,*`RL`S8#9)4\<C
M::]XL])TW3F+6.GVEJQ&"8(50D?@*N4_:=A<IY9%\+=2U,6:Z]JT2+90K;P_
M8@S.45F89=^A&[`PI&`/2N^T;PYI.@0A-.LHXFV[6EQF1^G5NO;..E:M%0VV
M4%%%%(`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HJI-J5E;W]K83
M7,:7=UN\F$M\S[022!Z`#K5N@`HHHH`****`"BBJECJ5EJ:3/8W,=PD,IAD:
M,Y`<`$C/MD4`6Z***`"BBB@`HHHH`****`"BBB@`HIK,J(6=@J@9))P!21R)
M+&LD9W(PRI]10`^BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBN,\<>*O[*MCI]G)_ILJ_.P/^J4_U/;\_2LJU:-&
M#G(WP^'GB*BIPW9#KWQ"CTS49+.QMDN?*X>0OA=W<#UQ7/7OQ3U2&%G%M9QJ
M.GRL3_.N5M+6>]NH[:VC:2:1L*HZFN:UG[3'J<]I<(8WMY&C*'L0<&O"CBL3
M6DW>R_K0^NIY9@Z:4'%.7G^9]#>"/$#^)?#$%_/L^T;WCF"#`#`\?^.E3^-:
MFMW,MEH&HW<!"S06LLB$C(#*I(_E7E'P7U?RM0O]'=OEF03Q#_:7AA^((_[Y
MKU'Q-_R*FL?]>,W_`*`:]W#RYX)GRV8T/88B45MNOF?/GPOU&\U7XN:?>7]S
M)<7,@F+R2-DG]T_Z>U?3%?(W@/Q!:^%O&%GJ]Y%-+!;K(&6$`L=R,HQD@=2.
M]>FW/[02+,1:^'6:+LTMWM8_@%./SKMJP<I:(\BC4C&/O,]LHKA_!'Q.TKQI
M,UFL,EEJ"KO^SR,&#@==K<9QZ8!K5\7>-=)\&6"7&HNS2RY$-O$,O)CK]`.Y
M-8\KO8Z>>-N:^AT=%>%S_M`W)E/V?P]$L>>/,N23^BBK^D_'N&YNXH-0T*2(
M2,%$EO.'Y)Q]T@?SJO93[$*O#N6/CMKFI:9IFE6-E=R007QF%P(^"X79@9ZX
M^8Y'>M'X%_\`(@2_]?TG_H*5SW[0GW?#OUN?_:58?@;XHV/@KP:VG_8)KR^>
MZ>78'"(JD*!EN3G@]!5J-Z:2,G-1K-L^B:*\7T_]H"VDN`FHZ#)#">LD%P)"
M/^`E1_.O6]*U6RUK38=0TZX6>UF7*.O\CZ$=Q64H2CN;QJ1ELR[16=J.L6NF
MX60EY2,B-.OX^E90\3W$F3#IY9?]XG^E26=-161I6M/J%R\$EL865-V=V>X'
M3'O46H:]):7KVD%F973&3N]1GH!0!N45S+>([^(;I=.*IZD,/UK4TS6;?4LH
MJF.51DHQ_EZT`:5%5KV^M["#S9WP#T`ZM]*PV\69<B*Q9E'<O@_R-`$OBMB-
M/A`)P9.1GKQ6KI?_`"";3_KBO\JY;5]:CU.UCC$+1NC[B"<CIZUU.E_\@JT_
MZXK_`"H`MT444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110!A>+/$</AC0WOI.7=Q%""#@N02,X[8!/X5X/>>(8[BYDN)7D
MFFD8LS8ZFO8?BG8_;/`=TRKN>WDCF4`?[04_HQKPFWL,8:;\%KQ\Q2<USO0^
MKR*$%1<TM;V9[WX#\/Q:=H\.HRQ_Z;=Q!SNZQH>0H_#!/_UJX'XN^'S!KUOJ
MEL@VWD>V0`_QI@9_$%?R-9`\<^(]+A7R-4E8#"JLN''T^8&EUGQI=^+;6S6\
MMHHI;0OEXB</NV]CTQM]>]#KTEAN6"M8='!8J&-]M.2:=[^G3]#)\)3WFD^+
M--NXH78K.JLJ#)96^5@!W.":^A/$W'A36/\`KQF_]`-<E\//"'V*)-9OX\7,
MB_Z/&P_U:G^(^Y'Y#ZUUOB;CPGK'_7C-_P"@&NW`QFH7GU/)SK$4ZM:T/LJU
M_P"NQ\N>`O#]MXF\9V&DWCR);S%VD,9PQ"H6QGMG&*^B'^%_@UM-:R&B0*I7
M:)03YH]]Y.<UX;\'?^2G:7_NS?\`HIZ^HJ]*M)J6A\_AXQ<6VCY(\(22Z5\1
MM($+G='J,<)/JI?8WY@FNK^._G?\)S;;\^6+!/*]/OOG]:Y+1/\`DI&G?]A>
M/_T<*^D?&'@S1/&4,%KJ3&*ZC#-;RQ.!(HXSP>J],C'Y5<Y*,DV9TXN4&D>?
M^$]:^%%GX9L([V"P%Z(5%S]LL3*_F8^;YBIXSG&#TK>M-*^%GBVZ2+3(].^U
MHV]%MLV[Y'.0O&[\C6$?V?K3/R^(9@.V;4'_`-FKRGQ-HL_@OQ=<:=#>^9-9
MNCQW$7R'D!E/7@C([U*49/W66Y2@O>BK'J'[0GW?#OUN?_:5-^$/@7P[KGAJ
M35=4T\75R+IXE\QVVA0%/W0<=SUJG\:[Q[_0/!M[(-KW-O+,PQT++"?ZUU_P
M,_Y$"3_K^D_]!2B[5)`DG6=S!^+?P]T33/#)UO1[);.6WE19EB)V.C';T[$$
MKR/>F_`'4Y?)UK39')AC\NXC7^Z3D-^>%_*M_P"-VM6]EX).EF5?M5],@6+/
MS;%;<6QZ94#\:YGX`V+O)KMXP(CV10*?4G<3^7'YTE=TM1M)5ERGH&CVXU;6
M)9[D;U&9"IZ$YX'T_P`*[(`*H```'0"N1\,R"UU2:VE^5F4J`?[P/3^==?6!
MU"55N=0L[(_OYD1CSCJ?R'-6B<*3Z"N+TBV76-4F>[9FXWD`XSS_`"H`Z#_A
M(=+/!G./^N;?X5@V+0_\)2IM3^Y+MMP,#!!KH?[!TS;C[(O_`'TW^-<_:P1V
MWBQ881MC20A1G..*8$NH`ZEXH2U8GRT(7`]`-Q_K74Q0QP1".)%1%Z*HP*Y:
M9A9^,1)(0$+C!/3#+BNMI`<YXKC06L$@10_F8W8YQCUK8TO_`)!5I_UQ7^59
M7BS_`(\8/^NG]#6KI?\`R"K3_KBO\J`+=%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`(0&4@@$$8(-<;KWPYTK5`TUB
M!87/7]VO[MC[KV_"NSHK.I2A45IJYM1Q%6A+FIRLSP'5?AMXK%QY4&G+/&G2
M2.=`K?3<0?TKH?`7PWOK:^-UX@M1#%"P:.`NK^8W8G!(P/3O7KM%81P5*-CT
M*F<XFI!PT5^JW_,*SM=MY;OP]J5M;IOFFM)8XUR!N8H0!S[UHT5UGDL\#^&O
MP^\4Z%X\T_4=3TEH+2(2AY#-&V,QL!P&)ZD5[Y1153FY.[(A!05D?.6D_#3Q
M?;>-K'4)='9;6/4HYGD\^+A!("3C=GI7H?Q7\$ZWXL_LJXT5H?,L?-W*\NQC
MNV8VG&/X3U(KTJBJ=1MIDJC%1<>Y\W+X9^+=FOD1OK2H.`(]2RH^F'Q5KP_\
M%_$6J:DMQXA9;.V9]\VZ8232=SC!(R?4G\#7T/13]M+H3]7CU/-/BGX!U/Q;
M:Z/'HWV5%L!*ICE<KPP0*%X(_A/7':O+T^%WQ$TQS]BLY5SU:VOHUS_X^#7T
MW12C5<58<J,9.Y\WV/P;\9ZQ>"356CM`3\\US<"5\>P4G)]B17N_ACPW8^%-
M"ATJP!\M/F>1OO2.>K'W_H!6S12E-RT94*48:HPM6T$W4_VJT<1S=2#P"1WS
MV-55?Q+"-FSS`.A.TUT]%0:&1I7]L-<NVH8$.SY5^7KD>GXUG3Z%?65XUQI;
MC!)PN0"/;G@BNHHH`YD0>)+GY))1"OKN4?\`H/-)::#<V.L6TJGS81R[Y`P<
M'M73T4`9.LZ,NI(KQL$N$&%)Z$>AK.B/B.T01"(2JO"EMIX^N?YUT]%`')W%
CCKNJ;5N5144Y`+*`/RYKI+*%K:Q@@8@M'&%)'3@58HH`_]D^
`




#End