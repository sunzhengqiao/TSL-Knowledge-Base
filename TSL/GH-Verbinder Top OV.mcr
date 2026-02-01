#Version 8
#BeginDescription
#Versions:
3.11 03/06/2024 HSB-22143: For site modus, change milling for Baufritz 
3.10 10.04.2023 20230410: Fix House vetors make sure right hand side 
3.9 05.07.2022 HSB-15918: Weinmann drill to be switsched ON/OFF depending on the state of production {Teilmontage,Werk,Baustelle} 

HSB-10687: nonail area include all parts, add milling at all parts, fix hardware
HSB-10103: dAxisOffset used for distance between parts
HSB-10103: make nr of parts variable, check boundary conditions
HSB-9035 bugfix toggle plant or construction site
HSB-9024 double connector quantity output
HSB-8422 additionalNotes considered for posnum generation

HSB-8183 optional badge added, toggle plant or construction site added
notes supports tokenized entries of <Mounting>;<PosNum>;<TSL Notes>

/// Dieses TSL erzeugt einen GH-OV Verbinder als T- oder G-Verbindung
/// Liegt eine gültige Verbindung zu einem Element vor, so wird eine positionierungsbohrung in Zone 1 hinzugefügt









#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 11
#KeyWords Baufritz,GH,Verbinder
#BeginContents
/// <summary Lang=de>
/// Dieses TSL erzeugt einen GH-OV Verbinder als T- oder G-Verbindung
/// Liegt eine gültige Verbindung zu einem Element vor, so wird eine positionierungsbohrung in Zone 1 hinzugefügt
/// </summary>

/// <command name="Seite wechseln" Lang=de>
/// Die Ausrichtung der Bearbeitung wird gewechselt
///</ command >

/// erzeugt einen GH-OV Verbinder
/// History
/// #Versions:
// 3.11 03/06/2024 HSB-22143: For site modus, change milling for Baufritz Marsel Nakuci
// 3.10 10.04.2023 20230410: Fix House vetors make sure right hand side Author: Marsel Nakuci
// 3.9 05.07.2022 HSB-15918: Weinmann drill to be switsched ON/OFF depending on the state of production {Teilmontage,Werk,Baustelle} Author: Marsel Nakuci
/// <version value="3.8" date="10feb2021" author="marsel.nakuci@hsbcad.com"> HSB-10687: nonail area include all parts, add milling at all parts, fix hardware </version>
/// <version value="3.7" date="14dec2020" author="marsel.nakuci@hsbcad.com"> HSB-10103: dAxisOffset used for distance between parts </version>
/// <version value="3.6" date="14dec2020" author="marsel.nakuci@hsbcad.com"> HSB-10103: make nr of parts variable, check boundary conditions </version>
/// <version value="3.5" date="29sep2020" author="thorsten.huck@hsbCAD.com"> HSB-9035 bugfix toggle plant or construction site </version>
/// <version value="3.4" date="29sep2020" author="thorsten.huck@hsbCAD.com"> HSB-9024 double connector quantity output </version>
/// <version value="3.3" date="28jul2020" author="thorsten.huck@hsbCAD.com"> HSB-8422 additionalNotes considered for posnum generation </version>
///<version  value="3.2" date="02Jul20" author="thorsten.huck@hsbcad.com"> HSB-8183 optional badge added, toggle plant or construction site added, notes supports tokenized entries of <Mounting>;<PosNum>;<TSL Notes> </version>
///<version  value="3.1" date="26apr17" author="thorsten.huck@hsbcad.com"> 'Seite wechseln' wieder für T-Verbindung verfügbar </version>
///<version  value="3.0" date="26jan17" author="thorsten.huck@hsbcad.com"> bugfix 'Seite wechseln' </version>
///<version  value="2.9" date="14dec16" author="thorsten.huck@hsbcad.com"> Bohrung durch fräsung ersetzt </version>
///<version  value="2.8" date="06oct15" author="thorsten.huck@hsbcad.com"> Elementzuordnung, wenn möglich </version>
///<version  value="2.7" date="06oct15" author="thorsten.huck@hsbcad.com"> neue Kontextbefehle zur Ausrichtung </version>
///<version  value="2.6" date="23mar15" author="th@hsbCAD.de"> bugfix Elementzuordnung </version>
///<version  value="2.5" date="25jun12" author="th@hsbCAD.de"> bugfix parallel connection </version>
///<version  value="2.4" date="25jun12" author="th@hsbCAD.de"> parallel connection supported</version>
/// Version 2.3   th@hsbCAD.de   21.09.2011
/// Ausgabe Verbindungsmittel verbessert
/// Version 2.2   th@hsbCAD.de   14.06.2011
/// neue Kontext-Option um Neben-/Hauptträgerzuordnung zu wechseln
/// Version 2.1   th@hsbCAD.de   01.03.2011
/// zweifach geneigte Anschlüße werden unterstützt
/// Version 2.0   th@hsbCAD.de   08.12.2009
/// - neuer Kontextbefehl Seite wechseln
/// Version 1.9  23.11.2009   th@hsbCAD.de
///    - unterstützt einfache oder doppelte Verbinder (Hinweis: statische Zulässigkeit muss vom Benutzer geprüft werden)
/// Version 1.8  19.03.2008   th@hsbCAD.de
///    - unterstützt Sperrflächenexport
/// Version 1.7  20.02.2008   th@hsbCAD.de
///    - Sperrflächen für alle schneidenen Elemente ergänzt
/// Version 1.6  05.12.2007   th@hsbCAD.de
/// 
///    - Sperrfläche um Verbinder im Bereich NT&HT bei gültiger Elementzuordnung
/// Version 1.5  30.11.2007   th@hsbCAD.de
/// 
///    - Sperrfläche um Verbinder im Bereich NT bei gültiger Elementzuordnung
/// 
/// Version 1.4   28.11.2007   th@hsbCAD.de
/// 
///    - Eigenschaften Schraublängen werden übernommen
/// Version 1.3   28.11.2007   th@hsbCAD.de
/// 
///    - optionale Element-Bohrung um 15mm in Richtung HT versetzt
/// Version 1.2   28.11.2007   th@hsbCAD.de
///    - Stücklistenausgabe optimiert
/// Version 1.1   22.11.2007   th@hsbCAD.de
///    - Verbinder kann nun als T-Stoss, Gehrung und Längsstoß eingesetzt werden
///    - Fuge kann wahlweise im Haupt,- Neben,- oder beiden Trägern eingestellt werden
///    - optionale Element-Bohrung, wenn Nebenträger einem Element zugeordnet ist
/// Version 1.0   19.10.2007   th@hsbCAD.de

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
	
// mounting	
	String sMountings[] ={ T("|Partial Assembly Plant|"), T("|Plant|"), T("|Construction Site|")};
	String sMountingProduction = sMountings[1];
	String sMountingOnSite = sMountings[2];
//end Constants//endregion
	
// geometry
	category = T("|Geometry|");
	
	String sArType[] = {T("|Type|") + " 40",T("|Type|") + " 60",T("|Type|") + " 80",T("|Type|") + " 100"};
	String sTypeName = T("|Type|");
	PropString sType(nStringIndex, sArType, sTypeName);
	sType.setCategory(category);
	
	String sArRelief[] = {T("|not rounded|"),T("|rounded|"),T("|relief|"),T("|rounded with small diameter|"),T("|relief with small diameter|"),T("|rounded|")};
	int nArRelief[] ={_kNotRound, _kRound, _kRelief, _kRoundSmall,_kReliefSmall,_kRounded };
	PropString sRelief(1, sArRelief, T("|Tooling|"));
	sRelief.setCategory(category);
	
	String sArConType[] = {T("|T-Connection|"), T("|Length connection|"), T("|Parallel connection|")};
	PropString sConType(2,sArConType,T("|Connection Type|"));
	sConType.setCategory(category);
	
	PropString sElemDrill(4,sNoYes,T("|Drill with element|"));
	sElemDrill.setCategory(category);
	
// Alignment	
	category = T("|Alignment|");
	PropDouble dOffset(0, 0, T("|Offset|"));
	dOffset.setCategory(category);
	
	PropDouble dCenterOffset(1, 0, T("|Offset from center|"));
	dCenterOffset.setCategory(category );
	
// multiple connectors
	category = T("|Multiple Connectors|");
	// 
	int nArQty[] = {1,2};
//	PropInt nQty(0, nArQty, T("Quantity"));
	PropInt nQty(0, 1, T("Quantity"));
	nQty.setCategory(category);	
	
	PropDouble dAxisOffset(6, 0, T("|Axis Offset between 2|"));	
	dAxisOffset.setCategory(category);
	
	PropDouble dGap(2, 0, T("|Gap|"));
	dGap.setCategory(category);
	
	String sArGapIn[] = {T("|Male beam|"), T("|Female beam|"), T("|Both beams|")};
	PropString sGapIn(3,sArGapIn,T("Gap applies to"));
	sGapIn.setCategory(category);
	
	PropDouble dScrewHT(4, U(100), T("|Length|") + " " + T("|screw female beam|"));
	PropDouble dScrewNT(5, U(100), T("|Length|") + " " + T("|screw male beam|"));
	
	category = T("|General|");
	PropDouble dSnap (3, U(200), T("|hsbIntelliSnap|"));
	double dWidth[] = {U(40), U(60), U(80), U(100)};
	double dLength = U(104);
	double dHeight = U(20);
	
// on insert
	if (_bOnInsert)
	{
		showDialog();
		int nConType = sArConType.find(sConType,0);
		
		Beam bm[0];
		if (nConType == 0) // T-Connection
		{
			PrEntity ssE(T("|Select beams|"), Beam());
			if (ssE.go()) {
				bm= ssE.beamSet();
				reportMessage (bm.length() + " " + T("|beams selected|"));
			}
		}
		else
		{
			PrEntity ssE(T("|Select 2 beams|"), Beam());
			while (ssE.go()) 
			{
				Beam bmSet[] = ssE.beamSet();
				// avoid same beam to be appended
				for (int i=0; i< bmSet.length();i++)
					if(bm.find(bmSet[i])<0)
						bm.append(bmSet[i]);
				if (bm.length() < 2)
					ssE = PrEntity (bm.length() + " " + T("|beams selected|") + ", " + (2-bm.length()) + " " + T("|more to select|"));
				else
					break;
			}
			if (bm.length()<2)
			{
				eraseInstance();
				return;	
			}
			else if (bm[0].vecX().isParallelTo(bm[1].vecX()))
				_Pt0 = getPoint();
		}
		// declare TSL Props
		TslInst tsl;
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		Beam lstBeams[2];			// T-connection will be always made with 2 beams
		Element lstElements[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		
		// remove comments and add properties with correct enumeration
		//lstPoints.append(ptYourPoint);
		//lstPropInt.append(nXX);
		lstPropDouble.append(dOffset);
		lstPropDouble.append(dCenterOffset);
		lstPropDouble.append(dGap);		
		lstPropDouble.append(dSnap);	
		lstPropDouble.append(dScrewHT);
		lstPropDouble.append(dScrewNT);		
		lstPropDouble.append(dScrewNT);	
		
		lstPropString.append(sType);
		lstPropString.append(sRelief);	
		lstPropString.append(sConType);	
		lstPropString.append(sGapIn);			
		lstPropString.append(sElemDrill);		

		lstPropInt.append(nQty);
		
		if (nConType == 0) // T-Connection
			for (int i = 0; i < bm.length(); i++)
			{
				Beam bmMale = bm[i];
				Vector3d vxMale = bmMale.vecX();
				Beam bmFemale[0];
				//T connection
				int bOverWriteExisting = TRUE;	//TRUE=>Overwrite,  FALSE=>Not Overwrite
				double dRange = dSnap;		//ExtendDistanceAllowed, use a property to allow user to control the intelliSelect behaviour
				
				// query all possible t-connections
				bmFemale = bmMale .filterBeamsTConnection(bm,dRange,bOverWriteExisting);
	
				// fall back to capsule intersect if this fails
				if (bmFemale.length()<1)
				{
					Beam bmCaps[]=bmMale.filterBeamsCapsuleIntersect(bm);
					for (int j=bmCaps.length()-1; j>=0; j--)
					{
						if (bmMale==bmCaps[j])
							bmCaps.removeAt(j);
					}
					
					// try to detect connection for each caps beam
					for (int j=0;j<bmCaps.length(); j++)
					{
						if (bmCaps[j].vecX().isParallelTo(vxMale )){continue;}
						Point3d pt0 = Line(bmMale.ptCen(),vxMale ).intersect(Plane(bmCaps[j].ptCen(),bmCaps[j].vecD(vxMale)),0);
						if (vxMale.dotProduct(pt0-bmMale.ptCen())<0) vxMale*=-1;
						Body bdMale = bmMale.realBody();
						bdMale.transformBy(vxMale*dRange);
						Body bdCaps = bmCaps[j].realBody();
						if (bdCaps.hasIntersection(bdMale))
							bmFemale.append(bmCaps[j]);
					}			
					
				}
	
	
				//for each beam that makes contact, insert the local instance of this tsl
				lstBeams[0] = bm[i];
				for (int j = 0; j < bmFemale.length();j++)
				{
					// make sure it's not the same beam
					if (bmFemale[j] == bm[i])
						continue;
					lstBeams[1] = bmFemale[j];	
					// create new instance
						
					tsl.dbCreate(scriptName(), vUcsX,vUcsY,lstBeams, lstElements, lstPoints, 
						lstPropInt, lstPropDouble, lstPropString ); 		
				}// next j	
			}// next i
		else if (bm.length() > 1)
		{
			lstBeams[0] = bm[0];	
			lstBeams[1] = bm[1];	
			lstPoints.append(_Pt0);
			tsl.dbCreate(scriptName(), vUcsX,vUcsY,lstBeams, lstElements, lstPoints, 
					lstPropInt, lstPropDouble, lstPropString ); 
		}
		eraseInstance();
		return;
	}	
//end on insert________________________________________________________________________________

	dSnap.setReadOnly(TRUE);

// declare standards
	if (_Beam.length() < 2)
	{
		eraseInstance();
		return;	
	}

// beam refs
	Beam bm0, bm1;
	bm0 = _Beam[0];
	bm1 = _Beam[1];
	Point3d ptCen0=bm0.ptCen(), ptCen1=bm1.ptCen();
//	return;
// assignment // // version 2.8
	Element element0 = bm0.element();
	Element element1 = bm1.element();
	int bAssignSingle = true;
	if (element0.bIsValid() && element1.bIsValid())
		bAssignSingle= false;
	if (element0.bIsValid()) assignToElementGroup(element0, bAssignSingle, 0,'E');	
	if (element1.bIsValid()) assignToElementGroup(element1, bAssignSingle, 0,'E');	

// T, I or parallel connection
	int nConType = sArConType.find(sConType,0);
	int bAllowEachSide = true;
	if (!bm0.vecX().isParallelTo(bm1.vecX()) || nConType!=1)
		bAllowEachSide =false;	
	
// add triggers
	String sTriggerJoist =  T("|Flip Side|");
	addRecalcTrigger(_kContext, sTriggerJoist );
	int bFlipT = _Map.getInt("flipT");
// trigger1: 
	if (_bOnRecalc && _kExecuteKey==sTriggerJoist) 
	{
		if (nConType!=0)
			_Beam.swap(0,1);
		else
		{
			bFlipT=bFlipT?false:true;
			_Map.setInt("flipT",bFlipT);
		}
		setExecutionLoops(2);
		return;
	}
	
// define valid sides	
	String sSides[] = {T("|Top|")};	
	if (bAllowEachSide)sSides.append(T("|Right|"));
	sSides.append(T("|Bottom|"));
	if (bAllowEachSide)sSides.append(T("|Left|"));
	
	double dRotationIncr = 180;
	if (bAllowEachSide )dRotationIncr = 90;
	
// keep flipped instances of versions prior version 2.7
	if (_Map.getInt("flip")==-1)
	{
		 _Map.removeAt("flip", true);
		 _Map.setDouble("Rotation",180);
	}
	
// add side trigger and collect rotation angle
	double dRotation = _Map.getDouble("Rotation");
	for (int i=0; i<sSides.length();i++)
		addRecalcTrigger(_kContext, sSides[i]);
	int nSideTrigger = sSides.find(_kExecuteKey);
	if (_bOnRecalc && (nSideTrigger >-1 || _kExecuteKey==sDoubleClick) )
	{
		if (nSideTrigger>-1)	
			dRotation= nSideTrigger*dRotationIncr;
		else
			dRotation+= dRotationIncr;			
		_Map.setDouble("Rotation", dRotation);	
	}
	
// gap flag
	int nGapIn = sArGapIn.find(sGapIn);
	int bElemDrill= sNoYes.find(sElemDrill);
	
// vectors
	Vector3d vx, vy, vz;
	
// T-Connection
	if (nConType == 0)
	{
		Vector3d vecY = bm0.vecY()*bm0.dD(bm0.vecY())*0.5;
		Vector3d vecZ = bm0.vecZ()*bm0.dD(bm0.vecZ())*0.5;
		
		// check if one of the edges would contact
		Point3d ptEdge[0];
		ptEdge.append(ptCen0 + vecY + vecZ);
		ptEdge.append(ptCen0 - vecY + vecZ);
		ptEdge.append(ptCen0 - vecY - vecZ);
		ptEdge.append(ptCen0 + vecY - vecZ);	
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
		_Pt0 = Line(ptCen0, bm0.vecX()).intersect(Plane(ptCen1,bm1.vecD(bm0.vecX())),0);
		vx = _Pt0 - ptCen0;
		vx = bm1.vecD(vx);	vx.normalize();	//vx.vis(_Pt0,1);
		_Pt0 = Line(ptCen0, bm0.vecX()).intersect(Plane(ptCen1,bm1.vecD(vx)),-0.5 * bm1.dD(vx));
		vz = bm1.vecZ();
		if (vz.isParallelTo(vx))
			vz = bm1.vecY();	
		vy = vx.crossProduct(-vz);
		
		// cut
		Cut ct(_Pt0,vx);
		bm0.addTool(ct,1);	
		ptCen0.vis(1);
	}
// G and I-Connection	
	else if (nConType == 1)
	{
		// the centre line of bm0
		Line ln0(ptCen0, bm0.vecX());
		_Pt0 = ln0.closestPointTo(_Pt0);
		
		vz = bm0.vecZ();
		
		// I: parallel
		if (bm0.vecX().isParallelTo(bm1.vecX()))
		{
			vx = _Pt0-ptCen0;	vx.normalize();	//vx.vis(_Pt0,1);
			vy = vx.crossProduct(-vz);
			//vy.vis(_Pt0,3);
		}			
		else
		{
			_Pt0 = ln0.intersect(Plane(ptCen1, bm1.vecD(bm0.vecX())),0);
			vx = _Pt0-ptCen0;	vx.normalize();	// vx.vis(_Pt0,2);	
			Point3d pt1 = Line(ptCen1, bm1.vecX()).closestPointTo(_Pt0);
			Vector3d vx1 = pt1-ptCen1;	vx1.normalize();	vx1.vis(_Pt0,2);
			Vector3d vyN = vx + vx1; vyN.normalize();
			Vector3d vzN = vx.crossProduct(vyN);
			vx = vyN.crossProduct(vzN);	vx.normalize(); vx.vis(_Pt0,1);	
			vy = vx.crossProduct(vzN);	vy.normalize(); 
			//vy.vis(_Pt0,3);						
		}
		
		// build two section pp's to see if the beams are within a valid position	
		PlaneProfile pp0, pp1;
		pp0 = bm0.envelopeBody().shadowProfile(Plane(_Pt0,vx));
		pp1 = bm1.envelopeBody().shadowProfile(Plane(_Pt0,vx));
		pp0.intersectWith(pp1);			
		//pp0.vis(0);	
		//pp1.vis(1);
		
		// exit if not within valid position range
		if (pp0.area() < U(1)*U(1))
		{
			eraseInstance();
			return;
		}		
		
		// cuts;
		bm0.addTool(Cut(_Pt0,vx),1);			
		bm1.addTool(Cut(_Pt0,-vx),1);		
	}
// parallel-Connection	
	else if (nConType == 2)
	{
		vx = bm0.vecY();
		if (vx.dotProduct(ptCen0-ptCen1)<0)vx*=-1;
		vz = bm0.vecZ();
		vy = vx.crossProduct(-vz);
		
		Line ln0(bm0.ptCenSolid()-vx*.5*bm0.dD(vx), bm0.vecX());
		_Pt0 = ln0.closestPointTo(_Pt0);
		
		Line ln1(bm1.ptCenSolid()+vx*.5*bm1.dD(vx), bm1.vecX());
		Point3d ptOn1= ln1.closestPointTo(_Pt0);
		ptOn1.vis(1);
		
		if (abs(vx.dotProduct(_Pt0-ptOn1))>dEps || !bm0.vecX().isParallelTo(bm1.vecX()))
		{
			reportMessage("\n" + T("|Beams must be parallel and may have no gap in between.|") + " " + T("|Tool will be deleted.|"));	
			//eraseInstance();
			//return;
		}
		
//		vx.vis(_Pt0,1);	
		bm0.vecX().vis(_Pt0,2);	
		bm1.vecX().vis(ptOn1,1);
		_Pt0.vis(1);
	}
	else
	{
		reportMessage("\n" + T("|Not supported|"));
		eraseInstance();
		return;	
	}
	
// rotate around vecX
	CoordSys csRot;
	csRot.setToRotation(dRotation,vx, _Pt0 );
	vy.transformBy(csRot);
	vz.transformBy(csRot);
//	vy.vis(_Pt0,3);	
//	vz.vis(_Pt0,150);			
	
// find type
	int nType = sArType.find(sType);
	double dW = dWidth[nType];
	double dR = U(20);	
	int nRelief = nArRelief[sArRelief.find(sRelief)];
	
// validate axis offset
	if (nQty > 1 && dAxisOffset < dW)
	{
		dAxisOffset.set(dW);
		reportMessage(TN("|The offset between two connectors must be at least set to the width of the selected connector|") + 
		TN("|Value has been set to|") +": " + dW);	
	}
	else if (nQty==1)
	{
		dAxisOffset.set(0);		
	}	
	
	
// refPoint
	Point3d ptRef = _Pt0 + vx * U(28) + vz * (0.5 * bm0.dD(vz)+dOffset) + vy * dCenterOffset;	
	if (bFlipT)
		ptRef.transformBy(vx*(dLength-2*U(28)));
	
	
	ptRef.vis(3);

// get hardware assignment
	int nHWAssignment = _Map.getInt("HardwareAssignment"); // 0 =PartialPlant, 1 = Plant, 2 = ConstructionSite
	String sThisModel = "Top OV " + (40 + (nType * 20));

//region Tag Display
	Vector3d vecX = vx;
	int bShowTag = _Map.getInt("ShowTag");
	int bIsBF = projectSpecial().find("Baufritz", 0, false) >- 1;
	if (!_Map.hasInt("ShowTag") && bIsBF)
	{ 
		bShowTag = true;
		 _Map.setInt("ShowTag", true);
	}
	if (bShowTag)
	{ 
		if (_PtG.length() < 1)_PtG.append(_Pt0 + vecX * 1.5 * bm1.dD(_Z1));
		_PtG[0] += _ZW * _ZW.dotProduct(_Pt0 - _PtG[0]);
		
		Display dp(nHWAssignment==2?4:3); // green in production, cyan onsite
		dp.addViewDirection(_ZW);
		String sDimStyle = _DimStyles.first();
		if(bIsBF)
		{ 
			int n = _DimStyles.findNoCase("BF 1.0" ,- 1);
			if (n>-1)sDimStyle = _DimStyles[n];
		}
		dp.dimStyle(sDimStyle);
		double textHeight = U(90);//dp.textHeightForStyle("O",sDimStyle);
		dp.textHeight(textHeight);
		double dX = dp.textLengthForStyle(sThisModel,sDimStyle, textHeight)+ textHeight;
		double dY = dp.textHeightForStyle(sThisModel,sDimStyle, textHeight) +.5*textHeight;
		LineSeg seg(_PtG[0]- _YW * .5 * dY, _PtG[0] + _XW*dX+ _YW*.5*dY);
		seg.transformBy(-_XW * .5 * dX);
		seg.vis(2);
		PLine pl;pl.createRectangle(seg, _XW, _YW);
		
		dp.draw(sThisModel, _PtG[0] - _XW * .5*(dX-textHeight), _XW, _YW, 1, 0);
		if (nHWAssignment==0)
		dp.color(4); // green in production, cyan onsite
		dp.draw(pl);
		dp.draw(PLine(_Pt0, pl.closestPointTo((_PtG[0]+_Pt0)/2)));
			
	}
	else if (_PtG.length()>0)
		_PtG.setLength(0);
	
// Trigger ShowTag
	String sTriggerShowTag =bShowTag?T("../|Hide Badge|"):T("../|Show Badge|");
	addRecalcTrigger(_kContext, sTriggerShowTag);
	if (_bOnRecalc && _kExecuteKey==sTriggerShowTag)
	{
		bShowTag = bShowTag ? false : true;
		_Map.setInt("ShowTag", bShowTag);		
		setExecutionLoops(2);
		return;
	}
//End Tag Display//endregion 

// pline	
	Point3d pt[0];
	double dBulge[0];
	pt.append(ptRef);																dBulge.append(0);
	pt.append(pt[pt.length()-1] + vy * .5 * (dW - 2*dR));					dBulge.append(0);		
	pt.append(pt[pt.length()-1] + vy *dR - vx * dR);						dBulge.append(tan(22.5));
	pt.append(pt[pt.length()-1] - vx * U(64));								dBulge.append(0);
	pt.append(pt[pt.length()-1] - vy * dR - vx * dR);						dBulge.append(tan(22.5));
	pt.append(pt[pt.length()-1] - vy * (dW - 2*dR));						dBulge.append(0);
	pt.append(pt[pt.length()-1] - vy * dR + vx * dR);						dBulge.append(tan(22.5));				
	pt.append(pt[pt.length()-1] + vx * U(64));								dBulge.append(0);
	pt.append(pt[pt.length()-1] + vy *dR + vx * dR);						dBulge.append(tan(22.5));			
	PLine pl(vz);
	for (int i= 0; i <pt.length(); i++)
		pl.addVertex(pt[i], dBulge[i]);
	pl.close();	
	pl.vis(2);
	// HSB-22143: 
	PLine plMilling = pl;
	
// drill locations
	Point3d ptDr[0];
	String sDZ[0];
	if (nType == 0)
	{
		ptDr.append(ptRef - vx*U(12));	sDZ.append("D");	
		ptDr.append(ptRef - vx*U(52));	sDZ.append("Z");
		ptDr.append(ptRef - vx*U(92));	sDZ.append("D");						
	}	
	else if (nType == 1)
	{
		ptDr.append(ptRef - vx*U(12) - vy*U(10));	sDZ.append("D");	
		ptDr.append(ptRef - vx*U(52) - vy*U(18));	sDZ.append("Z");
		ptDr.append(ptRef - vx*U(92) - vy*U(9));	sDZ.append("D");

		ptDr.append(ptRef - vx*U(52));			   sDZ.append("Z");	

		ptDr.append(ptRef - vx*U(12) + vy*U(10));	sDZ.append("D");	
		ptDr.append(ptRef - vx*U(52) + vy*U(18));	sDZ.append("Z");
		ptDr.append(ptRef - vx*U(92) + vy*U(9));	sDZ.append("D");
	}	
	else if (nType == 2)
	{
		ptDr.append(ptRef - vx*U(12) - vy*U(20));	sDZ.append("D");	
		ptDr.append(ptRef - vx*U(52) - vy*U(28));	sDZ.append("Z");
		ptDr.append(ptRef - vx*U(92) - vy*U(14));	sDZ.append("D");

		ptDr.append(ptRef - vx*U(52));			   sDZ.append("Z");	

		ptDr.append(ptRef - vx*U(12) + vy*U(20));	sDZ.append("D");	
		ptDr.append(ptRef - vx*U(52) + vy*U(28));	sDZ.append("Z");
		ptDr.append(ptRef - vx*U(92) + vy*U(14));	sDZ.append("D");
	}	
	else if (nType == 3)
	{
		ptDr.append(ptRef - vx*U(12) - vy*U(30));	sDZ.append("D");	
		ptDr.append(ptRef - vx*U(52) - vy*U(37.5));	sDZ.append("Z");
		ptDr.append(ptRef - vx*U(92) - vy*U(20));	sDZ.append("D");

		ptDr.append(ptRef - vx*U(52) - vy*U(12.5));	   sDZ.append("Z");	
		ptDr.append(ptRef - vx*U(52) + vy*U(12.5));	   sDZ.append("Z");	
		
		ptDr.append(ptRef - vx*U(12) + vy*U(30));	sDZ.append("D");	
		ptDr.append(ptRef - vx*U(52) + vy*U(37.5));	sDZ.append("Z");
		ptDr.append(ptRef - vx*U(92) + vy*U(20));	sDZ.append("D");
	}
	
// tooling
	House hsMale, hsFemale;
	// set gap values for male and female
	double dGapMale, dGapFemale;
	if (nGapIn == 0 || 	nGapIn == 2)
		dGapMale= dGap;
	if (nGapIn == 1 || 	nGapIn == 2)
		dGapFemale= dGap;
	double dBetween, dEdgeGap, dWidthBeamMin;
	double dWbeam = bm0.dD(vy);
	// HSB-10687: remember points for the ElemMill
	Point3d ptsHs[0];
	if (nQty <= 2)
	{ 
		Point3d ptHs=ptRef;
		if (nQty==2) ptHs.transformBy(-vy*.5*dAxisOffset);
		for (int i=0;i<nQty;i++)
		{
			ptHs.vis(2);
			ptsHs.append(ptHs);
			vx.vis(ptHs);
			vy.vis(ptHs);
			vz.vis(ptHs);
		// 20230410
			hsMale=House(ptHs+vx*dGapMale,vx,(-vz).crossProduct(vx),-vz,dLength+2*dGapMale,dW+2*dGapMale,dHeight,-1,0,1);
			hsFemale=House(ptHs+vx*dGapFemale,vx,(-vz).crossProduct(vx),-vz,dLength+2*dGapFemale,dW+2*dGapFemale,dHeight,-1,0,1);
			
			hsMale.setRoundType(nRelief);
			hsFemale.setRoundType(nRelief);
			hsMale.setEndType(_kFemaleSide);
			hsFemale.setEndType(_kFemaleSide);
			hsMale.cuttingBody().vis(2);
			bm0.addTool(hsMale);
			bm1.addTool(hsFemale);
			ptHs.transformBy(vy*dAxisOffset);
			ptHs.vis(2);
		}
		if (nQty==2)
		{
			dBetween = dAxisOffset-dW;
			dEdgeGap = bm0.dD(vy) - 2 * dW - dBetween;
			dEdgeGap /= 2;
			dWidthBeamMin = 2 * dW + 2*U(10) + U(20);
		}
		else
		{ 
			dBetween = U(20);
			dEdgeGap = bm0.dD(vy) - dW;
			dEdgeGap /= 2;
			dWidthBeamMin = dW + 2*U(10);
		}
	}
	else
	{ 
		dEdgeGap = U(10);
		dWidthBeamMin = nQty * dW + (nQty - 1) * U(20) + U(20);
		// more then 2 parts
		dWbeam = bm0.dD(vy);
		if(nConType == 2)
		{ 
			// parallel connection
			PlaneProfile ppBeams(Plane(bm0.ptCen(), vz));
			ppBeams.unionWith(bm0.envelopeBody().shadowProfile(Plane(bm0.ptCen(), vz)));
			ppBeams.unionWith(bm1.envelopeBody().shadowProfile(Plane(bm0.ptCen(), vz)));
			// get extents of profile
			LineSeg seg = ppBeams.extentInDir(vecX);
			dWbeam = abs(vy.dotProduct(seg.ptStart() - seg.ptEnd()));
		}
		double dRemain = dWbeam - U(20);
		dBetween = dRemain - nQty * dW;
		dBetween /= (nQty - 1);
		double dAxisOffsetBetween = dAxisOffset - dW;
		if(dBetween>U(20) && dAxisOffsetBetween>U(20) && dAxisOffsetBetween<dBetween)
		{
			dBetween = dAxisOffsetBetween;
			dEdgeGap = dWbeam - nQty * dW - (nQty - 1) * dBetween;
			dEdgeGap /= 2;
		}
		
		double dQtyHalf = nQty;
		dQtyHalf /= 2;
		int iQtyHalf = nQty;
		iQtyHalf /= 2;
		
		Point3d ptHs = ptRef;
//		ptHs.vis(3);
		if(dQtyHalf-iQtyHalf>0.2)
		{ 
			// odd numbers 1,3,5
			// first
			ptHs=ptRef;
			ptsHs.append(ptHs);
		// 20230410
			hsMale=House(ptHs+vx*dGapMale,vx,(-vz).crossProduct(vx),-vz,dLength+2*dGapMale,dW+2*dGapMale,dHeight,-1,0,1);
			hsFemale=House(ptHs+vx*dGapFemale,vx,(-vz).crossProduct(vx),-vz,dLength+2*dGapFemale,dW+2*dGapFemale,dHeight,-1,0,1);
			hsMale.setRoundType(nRelief);
			hsFemale.setRoundType(nRelief);
			hsMale.setEndType(_kFemaleSide);
			hsFemale.setEndType(_kFemaleSide);
			bm0.addTool(hsMale);
			bm1.addTool(hsFemale);
			
			// 
			for (int iSide=0;iSide<2;iSide++) 
			{ 
				Vector3d vDir = -vy;
				if (iSide == 1)vDir = vy;
				// sides left right
				for (int iPart = 0; iPart < iQtyHalf; iPart++)
				{ 
					ptHs = ptRef + vDir * ( (iPart+1) * (dW + dBetween));
//					ptHs.vis(2);
					ptsHs.append(ptHs);
					hsMale = House(ptHs + vx * dGapMale, vx, vy ,- vz, dLength + 2 * dGapMale, dW + 2 * dGapMale, dHeight ,- 1, 0, 1);
					hsFemale = House(ptHs + vx * dGapFemale, vx, vy ,- vz, dLength + 2 * dGapFemale, dW + 2 * dGapFemale, dHeight ,- 1, 0, 1);
					
					hsMale.setRoundType(nRelief);
					hsFemale.setRoundType(nRelief);
					hsMale.setEndType(_kFemaleSide);
					hsFemale.setEndType(_kFemaleSide);
					
					bm0.addTool(hsMale);
					bm1.addTool(hsFemale);
				}//next iPart
			}//next iSide
		}
		else
		{ 
			// even quantity numbers
			for (int iSide=0;iSide<2;iSide++) 
			{ 
				Vector3d vDir = -vy;
				if (iSide == 1)vDir = vy;
				// sides left right
				for (int iPart = 0; iPart < iQtyHalf; iPart++)
				{ 
					ptHs = ptRef + vDir * (.5 * (dW + dBetween) + (iPart) * (dW + dBetween));
					ptHs.vis(2);
					ptsHs.append(ptHs);
					hsMale = House(ptHs + vx * dGapMale, vx, vy ,- vz, dLength + 2 * dGapMale, dW + 2 * dGapMale, dHeight ,- 1, 0, 1);
					hsFemale = House(ptHs + vx * dGapFemale, vx, vy ,- vz, dLength + 2 * dGapFemale, dW + 2 * dGapFemale, dHeight ,- 1, 0, 1);
				
					hsMale.setRoundType(nRelief);
					hsFemale.setRoundType(nRelief);
					hsMale.setEndType(_kFemaleSide);
					hsFemale.setEndType(_kFemaleSide);
					
					bm0.addTool(hsMale);
					bm1.addTool(hsFemale);
				}//next iPart
			}//next iSide
		}
	}
	
	
// valid
	int bValidWidth = TRUE;
	if (dW + U(20) > dWbeam)
		bValidWidth = false;
	if (dBetween < U(20) || (dEdgeGap - dCenterOffset) < U(10) || dWbeam < dWidthBeamMin)
		bValidWidth = false;
//Display
	Display dp(253);
	
	// not a valid connector for this beam size
	if (!bValidWidth)
	{
		dp.color(1);	
		String sMsg = "\n*****************************************************************\n" + 
					 	+ T("|NOTE|") + " " + scriptName() + "\n" + T("|Connection|") + " " + bm0.posnum() + "/" + bm1.posnum()  +  " " +
						T("|The selected type is not valid.|");
//						+ "\n" + T("|Beam|") + " " + bm0.posnum() + " " + 
//						T("|should have a mimimal width of|") + " " + (dW+U(20)) +
						"\n*****************************************************************";
		if(dBetween<U(20))
			sMsg += "\n"+T("|Distance between beams|") + " " + (dBetween) + " " + T("|is smaller then 20mm|");
		if((dEdgeGap-dCenterOffset)<U(10))
			sMsg += "\n"+T("|Distance from edge of beam|") + " " + (dEdgeGap-dCenterOffset) + " " + T("|is smaller then 10mm|");
		if(bm0.dD(vy)<dWidthBeamMin)
			sMsg += "\n"+T("|Beam width|") + " " + (dWbeam + " " + T("|must be bigger then|") +" "+dWidthBeamMin);
						
		if (_bOnDbCreated)
			reportNotice(sMsg);
		else				
			reportMessage(sMsg);
	}
	
	Body bd(pl, vz * dHeight, -1);
//	bd.vis(3);
	PLine plMark(vz);
	PLine plCirc(vz);	
	dp.textHeight(U(8));	
	Point3d ptBd= ptRef;
	Vector3d vt =Vector3d(0,0,0);
	if(nQty<=2)
	{
		if(nQty==2)
		{
			vt=-vy*.5*dAxisOffset;		
			bd.transformBy(-vy*.5*dAxisOffset);
			ptBd.transformBy(-vy*.5*dAxisOffset);
		}
		int nThisSide=1;
		for (int i=0;i<nQty;i++)
		{	
			dp.draw(bd);
			PLine pl (ptBd- vx * U(28) - vy * 0.5 * dW,ptBd- vx * U(28) + vy * 0.5 * dW);
			if (bFlipT)
				pl.transformBy(vx*(2*U(28)-dLength));
			dp.draw(pl);
			
			ptBd.transformBy(vy*.5*dAxisOffset);
			
			for(int j= 0; j<ptDr.length(); j++)
			{
				plCirc.createCircle(ptDr[j]+nThisSide*vt, vz, U(7.5));
				//ptDr[j].vis(j);
				dp.draw(plCirc);
				dp.draw(sDZ[j], ptDr[j]+nThisSide*vt, vx, vy, 0,0);
			}
			bd.transformBy(vy*dAxisOffset);
			nThisSide*=-1;
		}
	}
	else
	{ 
		// more then 2 parts
//		double dWbeam = bm0.dD(vy);
//		double dRemain = dWbeam - U(20);
//		double dBetween = dRemain - nQty * dW;
//		dBetween /= (nQty - 1);
//		double dAxisOffsetBetween = dAxisOffset - dW;
//		if(dBetween>U(20) && dAxisOffsetBetween>U(20) && dAxisOffsetBetween<dBetween)
//			dBetween = dAxisOffsetBetween;
			
		double dQtyHalf = nQty;
		dQtyHalf /= 2;
		int iQtyHalf = nQty;
		iQtyHalf /= 2;
		
		Point3d ptHs = ptRef;
		Point3d ptBd = ptRef;
//		ptHs.vis(3);
		if(dQtyHalf-iQtyHalf>0.2)
		{ 
			// odd numbers 1,3,5
			// first
			ptBd = ptRef;
			dp.draw(bd);
			
			PLine pl (ptBd- vx * U(28) - vy * 0.5 * dW,ptBd- vx * U(28) + vy * 0.5 * dW);
			if (bFlipT)
				pl.transformBy(vx*(2*U(28)-dLength));		
			dp.draw(pl);
			for(int j= 0; j<ptDr.length(); j++)
			{
//						plCirc.createCircle(ptDr[j]+nThisSide*vt, vz, U(7.5));
				plCirc.createCircle(ptDr[j], vz, U(7.5));
				plCirc.transformBy(ptBd - ptRef);
				//ptDr[j].vis(j);
				dp.draw(plCirc);
//						dp.draw(sDZ[j], ptDr[j]+nThisSide*vt, vx, vy, 0,0);
				dp.draw(sDZ[j], ptDr[j]+(ptBd - ptRef), vx, vy, 0,0);
			}
			// 
			for (int iSide=0;iSide<2;iSide++) 
			{ 
				Vector3d vDir = -vy;
				if (iSide == 1)vDir = vy;
				// sides left right
				for (int iPart = 0; iPart < iQtyHalf; iPart++)
				{ 
					ptBd = ptRef + vDir * ( (iPart+1) * (dW + dBetween));
//					ptBd.vis(3);
					Body bdCopy = bd;
					bdCopy.transformBy(ptBd - ptRef);
					dp.draw(bdCopy);
					
					PLine pl (ptBd- vx * U(28) - vy * 0.5 * dW,ptBd- vx * U(28) + vy * 0.5 * dW);
					if (bFlipT)
						pl.transformBy(vx*(2*U(28)-dLength));		
					dp.draw(pl);
					
					for(int j= 0; j<ptDr.length(); j++)
					{
//						plCirc.createCircle(ptDr[j]+nThisSide*vt, vz, U(7.5));
						plCirc.createCircle(ptDr[j], vz, U(7.5));
						plCirc.transformBy(ptBd - ptRef);
						//ptDr[j].vis(j);
						dp.draw(plCirc);
//						dp.draw(sDZ[j], ptDr[j]+nThisSide*vt, vx, vy, 0,0);
						dp.draw(sDZ[j], ptDr[j]+(ptBd - ptRef), vx, vy, 0,0);
					}
				}//next iPart
			}//next iSide
		}
		else
		{ 
			// even quantity numbers
			for (int iSide=0;iSide<2;iSide++) 
			{ 
				Vector3d vDir = -vy;
				if (iSide == 1)vDir = vy;
				// sides left right
				for (int iPart = 0; iPart < iQtyHalf; iPart++)
				{ 
					ptBd=ptRef + vDir * (.5 * (dW + dBetween) + (iPart) * (dW + dBetween));
//					ptBd.vis(2);
					Body bdCopy = bd;
					bdCopy.transformBy(ptBd - ptRef);
					dp.draw(bdCopy);
					
					PLine pl (ptBd- vx * U(28) - vy * 0.5 * dW,ptBd- vx * U(28) + vy * 0.5 * dW);
					if (bFlipT)
						pl.transformBy(vx*(2*U(28)-dLength));		
					dp.draw(pl);
					
					for(int j= 0; j<ptDr.length(); j++)
					{
//						plCirc.createCircle(ptDr[j]+nThisSide*vt, vz, U(7.5));
						plCirc.createCircle(ptDr[j]+(ptBd - ptRef), vz, U(7.5));
//						plCirc.transformBy(ptBd - ptRef);
						//ptDr[j].vis(j);
						dp.draw(plCirc);
//						dp.draw(sDZ[j], ptDr[j]+nThisSide*vt, vx, vy, 0,0);
						dp.draw(sDZ[j], ptDr[j]+(ptBd - ptRef), vx, vy, 0,0);
					}	
				}//next iPart
			}//next iSide
		}
	}

// 120 ... 220
	
//region Hardware
// Trigger Hardware Production//region
	String sElemDrillFlags[]={ sNoYes[1],sNoYes[0],sNoYes[1]};
	for (int i=0;i<sMountings.length();i++)
	{ 
		String trigger ="../" + sMountings[i];
		addRecalcTrigger(_kContext,trigger+(i == nHWAssignment ? "   √" : ""));
		if (_bOnRecalc && _kExecuteKey==trigger)
		{
			_Map.setInt("HardwareAssignment",i);
			// set the elemDrill property
			sElemDrill.set(sElemDrillFlags[i]);
			setExecutionLoops(2);
			return;
		}
	}//next i
	//endregion
	
// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	int bRTFound;
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
		{
			bRTFound = true; // flag if this instance has RT reps attached, legacy version will not have this
			hwcs.removeAt(i); 
		}
		
// legacy, remove any entry
	if(!bRTFound)
		for (int i=hwcs.length()-1; i>=0 ; i--) 
			hwcs.removeAt(i); 
	
// declare the groupname of the hardware components
	String sHWGroupName, sHWManufacturer="GH";
	// set group name
	{ 
	// element
		// try to catch the element from the parent entity
		Element elHW =_ThisInst.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())	elHW = (Element)_ThisInst;
		if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}
	
// add main componnent
	{ 
		HardWrComp hwc(sThisModel, nQty); // the articleNumber and the quantity is mandatory		
		hwc.setManufacturer(sHWManufacturer);		
		hwc.setModel(sThisModel);
		hwc.setName("TOP OV");
		hwc.setDescription(T("|Invisible Connector|"));
		hwc.setMaterial("Aluminium");
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(_ThisInst);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		hwc.setCountType(_kCTAmount);
		hwc.setDScaleX(U(104));
		hwc.setDScaleY(nType*U(1));
		hwc.setDScaleZ(U(20));
		hwc.setNotes((nHWAssignment != 2 ? sMountingProduction : sMountingOnSite) +";" + _ThisInst.posnum()+";" + _ThisInst.additionalNotes() );	
		String sNotes = nHWAssignment != 2 ? sMountingProduction : sMountingOnSite;
		hwcs.append(hwc);// apppend component to the list of components
	}
	
// add sub componnent
	{ 
		// 0 =PartialPlant, 1 = Plant, 2 = ConstructionSite
	// screw HT
		double dDiam=U(8);
		String articleNumber = dDiam + " x " + dScrewHT;

		HardWrComp hwc(articleNumber, nQty*(nType==0?1:2)); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer(sHWManufacturer);
		hwc.setModel(articleNumber);
		hwc.setName(T("|GH-Vollgewindeschraube|"));
		hwc.setDescription(T("|GH-Vollgewindeschraube|"));
		hwc.setMaterial(T("|Steel|"));
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(_ThisInst);	
		hwc.setCategory(T("|Fixtures|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		hwc.setCountType(_kCTAmount);
		hwc.setDScaleX(dScrewHT);
		hwc.setDScaleY(dDiam);
		String sNotes = nHWAssignment == 1 ? sMountingProduction : sMountingOnSite;
		hwc.setNotes((nHWAssignment ==1 ? sMountingProduction : sMountingOnSite) +";" + _ThisInst.posnum()+";" + _ThisInst.additionalNotes() );
		// HSB-10687: if plant is selected all screws are set on plant, if site then all on site
		if((sNotes==sMountingOnSite && nHWAssignment==2) || (sNotes==sMountingProduction && nHWAssignment==1))
		{ 
			hwc.setQuantity(nQty * ptDr.length());
		}
		else if(nHWAssignment!=0)
		{ 
			hwc.setQuantity(0);
		}
		
		hwcs.append(hwc);// apppend component to the list of components
	}
// add sub componnent
	{ 
	// screw NT
		double dDiam=U(8);
		String articleNumber = dDiam + " x " + dScrewNT;	
		
		HardWrComp hwc(articleNumber, nQty*(ptDr.length()-(nType==0?1:2))); // the articleNumber and the quantity is mandatory		
		hwc.setManufacturer(sHWManufacturer);
		hwc.setModel(articleNumber);
		hwc.setName(T("|GH-Vollgewindeschraube|"));
		hwc.setDescription(T("|GH-Vollgewindeschraube|"));
		hwc.setMaterial(T("|Steel|"));
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(_ThisInst);	
		hwc.setCategory(T("|Fixtures|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		hwc.setCountType(_kCTAmount);
		hwc.setDScaleX(dScrewNT);
		hwc.setDScaleY(dDiam);
		hwc.setNotes((nHWAssignment!=1 ? sMountingProduction : sMountingOnSite) +";" + _ThisInst.posnum()+";" + _ThisInst.additionalNotes() );
		String sNotes = nHWAssignment != 1 ? sMountingProduction : sMountingOnSite;
		// HSB-10687: if plant is selected all screws are set on plant, if site then all on site
		if((sNotes==sMountingOnSite && nHWAssignment==2) || (sNotes==sMountingProduction && nHWAssignment==1))
		{ 
			hwc.setQuantity(nQty * ptDr.length());
		}
		else if(nHWAssignment!=0)
		{ 
			hwc.setQuantity(0);
		}
		hwcs.append(hwc);// apppend component to the list of components
	}

// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);	
	setCompareKey(scriptName() +"_"+_ThisInst.additionalNotes()+ "_"+sType +"_"+dScrewHT+"_"+dScrewNT+ "_"+sThisModel + "_"+hwcs.length());
	_ThisInst.setHardWrComps(hwcs);	
	//endregion
	
// dxaoutput for hsbExcel
	//dxaout("Name",sArType[nType]);// description
	dxaout("Width", dW/U(1,"mm"));// width
	dxaout("Height", dHeight/U(1,"mm"));// height
	dxaout("Length", U(104)/U(1,"mm"));// length
	dxaout("Group", bm0.groups());// group
	_ThisInst.setModelDescription(sType);
	_ThisInst.setMaterialDescription(T("Steel, zincated"));
	
	// get groups from _Beam
	Group grBm[] = bm0.groups();
	
// get floor group
	Group grFloor[0];
	for (int i = 0; i<grBm.length(); i++)
	{
		String sFloorName = grBm[i].namePart(1);
		if (sFloorName != "")
		{
			Group gr = Group(grBm[i].namePart(0) + "\\" + sFloorName);	
			if(grFloor.find(gr)<0)
				grFloor.append(gr);
		}		
	}
	
// collect all elements from floor group	
	Element elGr[0];	 
	for (int i = 0; i<grFloor.length(); i++)	
	{	
		Group grEl[] = grFloor[i].subGroups(false);
		for (int g = 0; g<grEl.length(); g++)		
		{
			Element elLinked = grEl[g].elementLinked();
			if (elLinked.bIsValid())
				elGr.append(elLinked);
		}
	}
	
// add weinmann drills if elements are different
	Element el0;	//bm0.envelopeBody().vis(0);
	el0 = bm0.element();
	ptRef.vis(1);
	Point3d ptsHsSorted[0];
	ptsHsSorted.append(ptsHs);
	ptsHsSorted = Line(ptRef, vy).orderPoints(ptsHsSorted);
	if (el0.bIsValid())
	{
		double dWNN = U(40);
		double dDrDiam = U(50);
		int nThisSide=1;
		
		Vector3d vxEl, vyEl, vzEl;
		vxEl = el0.vecX();
		vyEl = el0.vecY();
		vzEl = el0.vecZ();
		Plane pnZ(el0.ptOrg(),vzEl);
		
		PLine pl,plSub;
		// HSB-10687:
		pl.createRectangle(LineSeg(ptRef- vy*(.5*(dW+dAxisOffset)+abs(vy.dotProduct(ptsHsSorted[0]-ptRef)))-vx*dLength,ptRef 
				+ vy*(.5*(dW+dAxisOffset)+abs(vy.dotProduct(ptsHsSorted[0]-ptRef)))),vx,vy);	
		pl.projectPointsToPlane(pnZ,vzEl)	;
		PlaneProfile ppNN(pl);
//		ppNN.vis(2);
		
		ppNN.shrink(-U(20));
//		ppNN.vis(2);
		LineSeg lsX =ppNN.extentInDir(vx);
		Vector3d vxNEl = vx.crossProduct(vzEl).crossProduct(-vzEl);
		vxNEl.normalize();
		Point3d ptX = lsX.ptMid()+vxNEl*.5*abs(vxNEl.dotProduct(lsX.ptStart()-lsX.ptEnd()))-vxNEl*U(8);
		pl.createRectangle(LineSeg(ptX- vy*(.5*(dW+dAxisOffset+U(40))+abs(vy.dotProduct(ptsHsSorted[0]-ptRef)))+vx*U(20),
				ptX + vy*(.5*(dW+dAxisOffset+U(40))+abs(vy.dotProduct(ptsHsSorted[0]-ptRef)))),vx,vy);	
		pl.projectPointsToPlane(pnZ,vzEl);
		ppNN.joinRing(pl,_kSubtract);
		ppNN.vis(2);
		for (int i=0;i<nQty;i++)
		{
			if(bElemDrill){
				Vector3d vyDr = bm0.vecD(bm1.vecX());
				
				Vector3d vzEl = el0.vecZ();
				Point3d ptRefEl = ptRef -  vx * U(13);
				Point3d ptDr = ptRefEl+nThisSide*vt;//
				ptDr=ptDr.projectPoint(Plane(el0.zone(1).ptOrg(),el0.zone(1).vecZ()),0);// - vzEl * (vzEl.dotProduct(ptRefEl - el0.zone(1).ptOrg()) - el0.zone(1).dH());
				ptDr += vy * vy.dotProduct(ptsHs[i] - ptDr);
//				ptDr.vis(3);
				
			// version 2.9: add mill instead of drill
				{
					ElemZone zone = el0.zone(1);
					double dX = U(40);
					double dY = dW;
					PLine plTool(vzEl);
					plTool.addVertex(ptDr-vy * .5*(dY-dX));
					plTool.addVertex(ptDr+vy * .5*(dY-dX));
					plTool.addVertex(ptDr+vy * .5*(dY-dX)-vx*dX,1);
					plTool.addVertex(ptDr-vy * .5*(dY-dX)-vx*dX);
					plTool.addVertex(ptDr-vy * .5*(dY-dX),1);
					plTool.transformBy(vx*.5*dX);
					plTool.vis(6);
					// HSB-22143
					if(nHWAssignment==2 && bIsBF)
					{ 
						PlaneProfile ppMilling(plMilling);
						ppMilling.shrink(U(-5));
						PLine plRings[]=ppMilling.allRings();
						plTool=plRings[0];
					}
					
					ElemMill mill(1,plTool,zone.dH() + U(2),1,_kLeft,_kCCWise,_kNoOverShoot);
					el0.addTool(mill);
					
					Body bdTool(plTool,zone.vecZ()* (zone.dH() + U(2)),1);
					bdTool.transformBy(-zone.vecZ()*U(1));
					SolidSubtract sosu(bdTool,_kSubtract);
					
					//sosu.cuttingBody().vis(2);
					
					Sheet sheets[]=element0.sheet();
					sosu.addMeToGenBeamsIntersect(sheets);
				}
//				ElemDrill elDr(1, ptDr, vzEl,el0.zone(1).dH() + U(2), dDrDiam ,1 );
//				el0.addTool(elDr);	
				
				plSub.createRectangle(LineSeg(ptDr - (vx+vy)*.5*(dDrDiam+U(1)),ptDr + (vx+vy)*.5*(dDrDiam+U(1))),vx,vy);	
				plSub.projectPointsToPlane(pnZ,vzEl)	;
				plSub.vis(1);
				ppNN.joinRing(plSub,_kSubtract);
			}
			nThisSide*=-1;
		}			
		ppNN.vis(6);				
			

		PLine plNN[]=ppNN.allRings();
		plNN.append(pl);
		//ppNN.vis(3);
		// append no nail to all intersecting elements
		for (int n = 0; n<plNN.length(); n++)
		{
			PlaneProfile ppNN(plNN[n]);		
			for (int g = 0; g<elGr.length(); g++)
			{
				Element elOther = elGr[g];
				PlaneProfile ppEl(elOther.plEnvelope());
				PlaneProfile ppTest = ppEl;
				ppTest.intersectWith(ppNN);
				if (ppTest.area() > pow(U(1),2))
				{
				// the envelope intersects, now test if the frame would alos intersect
					if (elOther!=el0)
					{
						Beam beams[]=elOther.beam();
						Body bdCombine;
						for (int b=0; b<beams.length();b++)
							bdCombine.combine(beams[b].envelopeBody(false,true));
						PlaneProfile pp = bdCombine.shadowProfile(pnZ);
						pp.intersectWith(ppNN);
						if (pp.area() < pow(U(1),2))
							continue;
					}	
										
				// add noNail and assign	
					elGr[g].addTool(ElemNoNail(1,plNN[n]));
					// deprecated version 2.8
					//if(bElemDrill)
						//assignToElementGroup(elGr[g], false, 0, 'E');
						
				// visualize element link in debug
					if (_bOnDebug)
					{
						PLine(_Pt0,ppEl.extentInDir(vx).ptMid()).vis(g);
					}		
				}
				//ppEl.vis(g);
			}
		}

		// get outer no nail area
		LineSeg lsNN = ppNN.extentInDir(vx);	
		PLine plBoxedNN(vz);
		plBoxedNN.createRectangle(lsNN,vx,vy);
		Map mapNoTool;
		mapNoTool.setPLine("plNT", plBoxedNN);
		if (vz.isCodirectionalTo(el0.vecZ()))
			mapNoTool.setInt("side", 1);			
		else if (vz.isCodirectionalTo(-el0.vecZ()))
			mapNoTool.setInt("side", -1);	
		_Map.setMap("NoElementTool", mapNoTool);
	}	




#End
#BeginThumbnail
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
AHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/__9
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
      <str nm="Comment" vl="HSB-22143: For site modus, change milling for Baufritz" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="6/3/2024 10:20:32 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="20230410: Fix House vetors make sure right hand side" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="4/10/2023 5:36:22 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15918: Weinmann drill to be switsched ON/OFF depending on the state of production {Teilmontage,Werk,Baustelle}" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="7/5/2022 3:16:11 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End