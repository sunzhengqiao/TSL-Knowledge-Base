#Version 8
#BeginDescription
#Versions:
Version 2.6 29/04/2025 HSB-23959: Fix when checking validity for beam as marking entity , Author Marsel Nakuci
2.5 21.12.2023 HSB-20495: Bug fix when getting section width/height Author: Marsel Nakuci
2.4 10.01.2022 HSB-14287: Fix TSL description Author: Marsel Nakuci
Version 2.3 07.12.2021 HSB-14087 group assignment added , Author Thorsten Huck
2.2 23.08.2021 HSB-12447: change TSL type from "X" to "O"; support truss entities as marking entity Author: Marsel Nakuci
version  value="2.1" date="26may2021" author="nils.gregor@hsbcad.com">
HSB-11548 Bugfix selecting face at vertical beams

catalog based insertion supported
DE
erzeugt eine Markierung an zwei kreuzenden Stäben
HINWEIS: die Bearbeitung wird als Beschriftung und/oder als Markierung an die Hundeggermaschine übergeben, kann 
jedoch auch auf Maschinen ohne Inkjet problemlos ausgeführt werden,  solange kein Beschriftungstext eingegeben wird.
Anwendung:
Wählen Sie zuerst alle markierenden Bauteile und/oder eine Dachfläche und dann das Bauteil, welches markiert werden soll.

Schräge Markierungen werden ab der hsbCAD Version 13.2.86 unterstützt

EN
creates marking at intersecting beams
NOTE: the tooling will be transformed as inscription and/or marking, but you can use it without problems on machines
without an inkjet as long as there is no text input.
how to use:
select all beams which act as markers and/or a roofplane, then select beam to mark on

Markings with an angle other than 90° are supported with release hsbCAD 13.2.86














#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 6
#KeyWords Marking;beam;truss
#BeginContents
/// <summary>
/// This tsl creates a marking line with or without description
/// </summary>

/// <insert>
/// Select marking entities (roofplane and/or beams and/or trusses), then select beams to be marked.
/// </insert>

/// <property name="Drawing space">
/// Determines the space and the general behaviour of this tsl. Read only after insert.
/// </property name>

/// <remark>
/// All plates are filtered out from a rooofplane dependent selection set to avoid markings of plates
/// on rafters. However if this is required one can select the plates to insert this kind of marking
/// </remark>

/// <remark>
/// Non perpendicular markings are exported with hundegger macro 6.2 which can not be run on a K1
/// </remark>


/// History
/// #Versions:
// 2.6 29/04/2025 HSB-23959: Fix when checking validity for beam as marking entity , Author Marsel Nakuci
// 2.5 21.12.2023 HSB-20495: Bug fix when getting section width/height Author: Marsel Nakuci
// Version 2.4 10.01.2022 HSB-14287: Fix TSL description Author: Marsel Nakuci
// 2.3 07.12.2021 HSB-14087 group assignment added , Author Thorsten Huck
// Version 2.2 23.08.2021 HSB-12447: change TSL type from "X" to "O"; support truss entities as marking entity Author: Marsel Nakuci
/// <version  value="2.1" date="26may2021" author="nils.gregor@hsbcad.com">HSB-11548 Bugfix selecting face at vertical beams</version>
/// <version  value="2.0" date="25may2021" author="nils.gregor@hsbcad.com">HSB-11548 Bugfix used direction for face of marking</version>
/// <version  value="1.9" date="12.feb2021" author="nils.gregor@hsbcad.com">HSB-4240 Bugfix incorrect end points. Markings follow the contact using "Along marking beam". Calculation UCS independent</version>
/// <version  value="1.8" date="23jun14" author="th@hsbCAD.de"> bugfix insertion for right side with no text </version>
/// <version  value="1.7" date="12apr13" author="th@hsbCAD.de"> catalog based insertion supported </version>
/// Version 1.6   16.10.2008   th@hsbCAD.de
/// DE   Mehrfaches Einfügen auch für zu markierende Bauteile möglich
/// EN   Multiple insert also for marked beams possible
/// Version 1.5   16.08.2008   th@hsbCAD.de
/// DE   Mehrfaches Einfügen möglich
/// EN   Multiple insert selection possible
/// Version 1.4   21.08.2008   th@hsbCAD.de
/// DE oben/unten getauscht
/// EN top/bottom swapped
/// Version 1.3   23.07.2008   th@hsbCAD.de
/// DE Bauteile, welche sich nicht nicht im angegebenen Toleranzbereich überschneiden werden ausgefiltert
/// EN Beams which do not intersect in the range of the given tolerance will be filtered out
/// Version 1.2   02.06.2008   th@hsbCAD.de
/// DE Einstellung 'Markierrichtung' wird korrekt übernommen
/// EN property 'Direction of Marking' corrected on insert
/// Version 1.1   27.05.2008   th@hsbCAD.de
/// DE neue Optionen zur Ausrichtung der Markierung
/// EN new option for marking alignment
/// Version 1.0   30.01.2008   th@hsbCAD.de

// basics and props
	U(1,"mm");
	double dEps = U(0.1);
	String sArNY[] = { T("|No|"), T("|Yes|")};
	String sArFace[]={T("|Front|"),T("|Top|"),T("|Back|"),T("|Bottom|")};
	PropString sFace(0,sArFace,T("|Face of marking|"));
	String sArSide[]={T("|Both|"), T("|Left|"),T("|Center|"),T("|Right|"),T("|None|")};
	PropString sSide(1,sArSide,T("|Side of marking|"));
	String sArDir[]={T("|Along marking beam|"), T("|Recangular on marked beam|")};
	PropString sDir(7,sArDir,T("|Direction of marking|"));
	PropString sPrefix(2,"",T("|Prefix|"));
	String sArAutoTxt[] = {T("|PosNum|"),T("|PosNum + Text|"), T("None")};
	PropString sAutoTxt(3,sArAutoTxt,T("|Autotext|"));
	String sArTextPosition[] = {T("|Bottom|"), T("|Center|"), T("|Top|")};
	PropString sTextPosition(4, sArTextPosition, T("|Text Position|"),1);
	String sArTextAlignment[] = {T("|Right|"), T("|Center|") ,T("|Left|")};
	PropString sTextAlignment(5, sArTextAlignment, T("|Text Alignment|"),2);
	String sArDirection[] = {T("|normal|"),T("|upside down|"),T("|back to front|"),T("|right vertical text|"),T("|front t o back|"),T("|left vertical text|")};
	PropString sDirection(6, sArDirection, T("|Text Direction|"));
	PropInt nDimColor(0,92,T("|Color|"));
	
// on insert
	if(_bOnInsert)
	{
		PropDouble dTol(0,U(5), T("|Detection Range|"));
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
			// show the dialog if no catalog in use
		if (_kExecuteKey == "")
			showDialog();
		// set properties from catalog		
		else	
			setPropValuesFromCatalog(_kExecuteKey);

		PrEntity ssE(T("|Select marking entities (roofplane and/or beams and/or trusses)|"), ERoofPlane());
		ssE.addAllowedClass(Beam());
		ssE.addAllowedClass(TrussEntity());
		ERoofPlane erp;
		Beam bm[0];
		TrussEntity truss[0];
		while (!erp.bIsValid() && bm.length()<1 && truss.length()<1)
		{
	  		if (ssE.go()){
				Entity ents[0];
	    		ents = ssE.set();
				for (int i = 0; i < ents.length(); i++){
				// append only one erp
					if (ents[i].bIsKindOf(ERoofPlane()) && !erp.bIsValid())
						erp =(ERoofPlane)ents[i];
				// do not append any plate type beams
					else if(ents[i].bIsKindOf(Beam()))
					{
						Beam bmEnt =(Beam)ents[i];
						if (	bmEnt.type() != 1 && bmEnt.type() != 2 && bmEnt.type() != 3 && bm.find(bmEnt)<0)// not of plate type
							bm.append(bmEnt);
					}
					else if(ents[i].bIsKindOf(TrussEntity()))
					{ 
						TrussEntity tEnt = (TrussEntity)ents[i];
						if(tEnt.bIsValid() && truss.find(tEnt)<0)
							truss.append(tEnt);
					}
				}// next i
			}// endif go()
			else
				break;
		}// do loop
		
		// collect rafters from erp
		ToolEnt tent = (ToolEnt)erp;
		Beam bmTent[] = tent.beam();
		for (int i = 0; i < bmTent.length(); i++)
		{
			// do not append any plate type beams
			Beam bmEnt =bmTent[i];
			if ((bmEnt .type() != _kTopPlate && bmEnt .type() != _kMidPlate && bmEnt .type() != _kRidge) && bm.find(bmEnt)<0)// not of plate type
				bm.append(bmEnt );
		}
		
		// insert instance per beam
		// declare tsl props
		TslInst tsl;
		String sScriptName = scriptName(); // name of the script
		Vector3d vecUcsX = _XU;
		Vector3d vecUcsY = _YU;
		Beam bmAr[2];
		Beam bmAr1[1];// instance with truss
		Entity entAr[0];
		Entity entAr1[1];// instance with truss
		Point3d ptAr[0];
		int nArProps[0];
		double dArProps[0];
		String sArProps[0];	
		Map mapTsl;

		Beam bmOther[0];
		PrEntity ssBm(T("|Select beams to be marked|"), Beam());
		if (ssBm.go())
			bmOther = ssBm.beamSet();

		nArProps.append(nDimColor);	//0	Color
		
		sArProps.append(sFace);		//0	Face of marking
		sArProps.append(sSide);		//1	Side of marking
		sArProps.append(sPrefix);	//2	Prefix
		sArProps.append(sAutoTxt);	//3	Autotext
		sArProps.append(sTextPosition);	//4	Text Position
		sArProps.append(sTextAlignment);	//5	Text Alignment
		sArProps.append(sDirection);	//6	Text Direction
		sArProps.append(sDir);			//7	Direction of marking
		
		for (int j=0; j< bmOther.length();j++)
		{
			bmAr[1] = bmOther[j];
			bmAr1[0] = bmOther[j];
			for (int i = 0; i < bm.length(); i++)
			{
				bmAr[0] = bm[i];
				
				// check body interference with given tolerance
				Body bd0 = bmAr[0].envelopeBody();
				Body bd1 = bmAr[1].envelopeBody();
				CoordSys cs;
				double dX, dY, dZ;
				dX = (bmAr[0].dL()+U(dTol))/bmAr[0].dL();
				dY = (bmAr[0].dW()+U(dTol))/bmAr[0].dW();
				dZ = (bmAr[0].dH()+U(dTol))/bmAr[0].dH();
				cs.setToAlignCoordSys(bmAr[0].ptCen(),bmAr[0].vecX(),bmAr[0].vecY(),bmAr[0].vecZ(),
					bmAr[0].ptCen(),bmAr[0].vecX()*dX,bmAr[0].vecY()*dY,bmAr[0].vecZ()*dZ);
				bd0.transformBy(cs);
				dX = (bmAr[1].dL()+U(dTol))/bmAr[1].dL();
				dY = (bmAr[1].dW()+U(dTol))/bmAr[1].dW();
				dZ = (bmAr[1].dH()+U(dTol))/bmAr[1].dH();				
				cs.setToAlignCoordSys(bmAr[1].ptCen(),bmAr[1].vecX(),bmAr[1].vecY(),bmAr[1].vecZ(),
					bmAr[1].ptCen(),bmAr[1].vecX()*dX,bmAr[1].vecY()*dY,bmAr[1].vecZ()*dZ);
				bd1.transformBy(cs);
				if (!bmAr[0].vecX().isParallelTo(bmAr[1].vecX()) && bd0.hasIntersection(bd1))
					tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,bmAr, entAr,ptAr,
							nArProps, dArProps,sArProps );
			}
			for (int i=0;i<truss.length();i++) 
			{ 
				entAr1[0] = truss[i];
				TrussEntity tEntI = truss[i];
				if(!truss[i].coordSys().vecX().isParallelTo(bmAr1[0].vecX()))
					tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,bmAr1, entAr1,ptAr,
							nArProps, dArProps,sArProps,_kModelSpace, mapTsl);
			}//next i
		}
		
		if (bm.length()<1 && truss.length()<1)
			eraseInstance();
		// always delete distribution instance
		eraseInstance();
		return;	
	}// end on insert_____________________________________________________________________________________________________________


TrussEntity truss;
for (int i=0;i<_Entity.length();i++) 
{ 
	TrussEntity trussI = (TrussEntity)_Entity[i];
	if(trussI.bIsValid())
	{ 
		truss = trussI;
		break;
	}
}//next i

Beam bm0, bm1;
Quader qd0;
Point3d ptZ0Cen, ptZ1Cen;
Point3d ptContact;
Vector3d  vx,vy,vz, vx1, vy1, vz1;

if(truss.bIsValid())
{ 
	// marking entity is a truss
	// truss beam scenario
	if(!_Beam[0].bIsValid())
	{ 
		reportMessage("\n"+scriptName()+" "+T("|Beam to be marked is missing|"));
		eraseInstance();
		return;
	}
	bm1 = _Beam[0];
	CoordSys csTruss = truss.coordSys();
	csTruss.vis(3);
	Vector3d vecXt = csTruss.vecX();
	Vector3d vecYt = csTruss.vecY();
	Vector3d vecZt = csTruss.vecZ();
	Point3d ptOrgTruss = truss.ptOrg();
	ptOrgTruss.vis(4);
	String strDefinition = truss.definition();
	TrussDefinition trussDefinition(strDefinition);
//	Beam beamsTrussEntity[] = truss.beam();
	Beam beamsTruss[] = trussDefinition.beam();
	Body bdTruss;
	for (int i=0;i<beamsTruss.length();i++) 
	{ 
//		beamsTruss[i].envelopeBody().vis(4);
		bdTruss.addPart(beamsTruss[i].envelopeBody());
	}//next i
	bdTruss.transformBy(csTruss);
// Validation check of connection. A tolerance of 50mm to each side is added
	{ 
		Body bd(bm1.ptCen(), bm1.vecX(), bm1.vecY(), bm1.vecZ(), bm1.dL(), bm1.dW() + U(100), bm1.dH() + U(100));
		if(!bd.hasIntersection(bdTruss))
		{
			reportMessage("\n" + scriptName() + ": " +T("|Truss and beam have lost connection. Delete instance|"));
			eraseInstance();
			return;
		}
	}
	
	Point3d ptCenBd = bdTruss.ptCen();
	PlaneProfile ppX = bdTruss.shadowProfile(Plane(ptCenBd, vecXt));
	// get extents of profile
	LineSeg segX = ppX.extentInDir(vecYt);
	Point3d ptCenX = segX.ptMid();
	Point3d ptCenTruss = ptCenX;
	PlaneProfile ppY = bdTruss.shadowProfile(Plane(ptCenBd, vecYt));
	LineSeg segY = ppY.extentInDir(vecXt);
	ptCenTruss += vecXt * vecXt.dotProduct(segY.ptMid() - ptCenTruss);
	ptCenTruss.vis(9);
	double dLx = bdTruss.lengthInDirection(vecXt);
	double dLy = bdTruss.lengthInDirection(vecYt);
	double dLz = bdTruss.lengthInDirection(vecZt);
	 qd0=Quader(ptCenTruss, vecXt, vecYt, vecZt, dLx, dLy, dLz);
	qd0.vis(6);
//	bdTruss.vis(5);

	ptZ0Cen = ptCenTruss;
	ptZ1Cen = bm1.ptCen();
	ptContact;
	
	// construct vectors
	vx = qd0.vecX();
	if (vx.dotProduct(ptZ1Cen - ptZ0Cen) < 0)vx *= -1;
	vx1 = bm1.vecX();
	if (vx1.dotProduct(ptZ0Cen - ptZ1Cen) < 0)vx1 *= -1;
	Vector3d vecNormal = vx.crossProduct(vx1);
	vecNormal.normalize();
	vz = qd0.vecD(vecNormal);
	if(vz.isParallelTo(vx))
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|unexpected|"));
		eraseInstance();
		return;
	}
	if (vz.dotProduct(ptZ1Cen - ptZ0Cen) < 0)vz *= -1;
	vz1 = bm1.vecD(vecNormal);
	if (vz1.dotProduct(vz) < 0)vz1 *= -1;
	
	vy = vz.crossProduct(vx);
	vy.normalize();
	vy1 = vz1.crossProduct(vx1);
	vy1.normalize();
	vx.vis(ptZ0Cen, 1); vy.vis(ptZ0Cen, 1); vz.vis(ptZ0Cen, 1);
	vx1.vis(ptZ1Cen, 3); vy1.vis(ptZ1Cen, 3); vz1.vis(ptZ1Cen, 3);
	// find pt0
	Plane pn(ptZ0Cen, vy), pn1(ptZ1Cen, vy1);
	Line ln(ptZ0Cen, vx), ln1(ptZ1Cen, vx1);
	Point3d pt = ln.intersect(pn1, dEps);
	Point3d pt1 = ln1.intersect(pn, dEps);
	_Pt0 = .5 * (pt + pt1);
}
else
{ 
	// marking entity is a beam
	// 2 beams scenario

// Validation check of beams 
// HSB-23959: fix check
	if(_Beam.length() != 2 || ! _Beam[0].bIsValid() || ! _Beam[1].bIsValid())
	{
		reportMessage("\n" + scriptName() + ": " +T("|At least one beam is invalid. Delete instance|"));
		eraseInstance();
		return;
	}
	
// standards
	bm0 = _Beam[0];
	bm1 = _Beam[1];
	
// Validation check of connection. A tolerance of 50mm to each side is added
	{ 
		Body bd(bm1.ptCen(), bm1.vecX(), bm1.vecY(), bm1.vecZ(), bm1.dL(), bm1.dW() + U(100), bm1.dH() + U(100));
		if(!bd.hasIntersection(bm0.envelopeBody()))
		{
			reportMessage("\n" + scriptName() + ": " +T("|Beams have lost connection. Delete instance|"));
			eraseInstance();
			return;
		}
	}
	
	ptZ0Cen = bm0.ptCen();
	ptZ1Cen = bm1.ptCen();
	
	// construct vectors
	vx = bm0.vecX();
	if (vx.dotProduct(ptZ1Cen - ptZ0Cen) < 0)vx *= -1;
	vx1 = bm1.vecX();
	if (vx1.dotProduct(ptZ0Cen - ptZ1Cen) < 0)vx1 *= -1;
	Vector3d vecNormal = vx.crossProduct(vx1);
	vecNormal.normalize();
	vz = bm0.vecD(vecNormal);
	if (vz.dotProduct(ptZ1Cen - ptZ0Cen) < 0)vz *= -1;
	vz1 = bm1.vecD(vecNormal);
	if (vz1.dotProduct(vz) < 0)vz1 *= -1;
	vy = vz.crossProduct(vx);
	vy.normalize();
	vy1 = vz1.crossProduct(vx1);
	vy1.normalize();
	vx.vis(ptZ0Cen, 1); vy.vis(ptZ0Cen, 1); vz.vis(ptZ0Cen, 1);
	vx1.vis(ptZ1Cen, 3); vy1.vis(ptZ1Cen, 3); vz1.vis(ptZ1Cen, 3);
	// find pt0
	Plane pn(ptZ0Cen, vy), pn1(ptZ1Cen, vy1);
	Line ln(ptZ0Cen, vx), ln1(ptZ1Cen, vx1);
	Point3d pt = ln.intersect(pn1, dEps);
	Point3d pt1 = ln1.intersect(pn, dEps);
	_Pt0 = .5 * (pt + pt1);
}

// add group assignment // HSB-14087
	assignToGroups(bm1, 'T');
	

	//Vectors bm0
//	vx = _X0;
//	vy = _Y0;
//	vz = _Z0;
//	vx.vis(ptZ0Cen, 1); vy.vis(ptZ0Cen, 1); vz.vis(ptZ0Cen, 1);
	//Vectors bm1
//	vx1 = _X1;
//	vy1 = _Y1;
//	vz1 = _Z1;
//	vx1.vis(ptZ1Cen, 3); vy1.vis(ptZ1Cen, 3); vz1.vis(ptZ1Cen, 3);
//	return;
	int bMarkedIsPost;
	if(vx.dotProduct(ptZ1Cen - ptZ0Cen) < 0)
		vx *= -1;
		
	if(vx1.isParallelTo(_ZW))
	{
		bMarkedIsPost = true;
		
		if(vx1.dotProduct(_ZW) < 0)
			vx1 *= -1;
	}
	
	LineBeamIntersect lbi(ptZ0Cen, vx, bm1);
	int nLbi = lbi.nNumPoints();
	
	if(nLbi == 0 || vx.isParallelTo(vx1))
	{
		reportMessage("\n" + scriptName() + ": " +T("|Parallel beams cannot marked. Instance deleted|"));
		eraseInstance();
		return;
	}
	else
	{
		Vector3d vecY, vecZ;
		Vector3d vec = lbi.vecNrm1();
		
		if(! bMarkedIsPost)
		{
			if(vec.dotProduct(_ZW) < 0)
				vec *= -1;
				
			if(vec.angleTo(_ZW) <= 45)
			{
				vecZ = vec;
				vecY = vecZ.crossProduct(vx1);
			}
			else
			{
				vecY = vec;
				vecZ = vecY.crossProduct(vx1);
			}
			
			if(nLbi==2)
			{
				double dDist = vecY.dotProduct(ptZ1Cen - lbi.pt1());
				
				if(abs(abs(dDist) - 0.5*bm1.dD(vecY)) < dEps)
					dDist = vecY.dotProduct(ptZ1Cen - lbi.pt2());
				
				if(dDist > 0)
					vecY *= -1;
			}
		}
		else
		{
			if(nLbi == 1)
			{
				vecZ = -vec;
				vecY = vecZ.crossProduct(vx1);
			}
			else
			{
				vecY = vec;
				vecZ = vecY.crossProduct(vx1);
			}
		}
		vy1 = vecY;
		vz1 = vecZ;
	}
	
	vy1.vis(ptZ1Cen, 1);
	vz1.vis(ptZ1Cen, 6);

	if(vz1.dotProduct(vx) > dEps)
		vz1 *= -1;
	
//Change direction, if vz1 pointing downwards
	int nSignOrient = 1;
	if(vz1.dotProduct(_ZW) < -dEps)
	{
		sArFace.swap(1, 3);
		nSignOrient = -1;
	}
	
	// int
	int nDirection= sArDirection.find(sDirection,0);
	int nSide= sArSide.find(sSide,0);
	int nFace= sArFace.find(sFace,0);
	int nDir= sArDir.find(sDir,0);
	int nAutoTxt= sArAutoTxt.find(sAutoTxt,0);
	int nTextPosition = sArTextPosition.find(sTextPosition) - 1;
	int nTextAlignment = sArTextAlignment.find(sTextAlignment) - 1;
	
// Dimensions of bm0 and bm1
	double dBm0W,dBm0H;
	double dBm1W, dBm1H;
	if(truss.bIsValid())
	{
		dBm0W = qd0.dD(vy);
		dBm0H= qd0.dD(vz);
	}
	else
	{
		dBm0W= bm0.dD(vy);
		dBm0H= bm0.dD(vz);
		
	}
	// HSB-20495
	dBm1W = bm1.dD(vy1);
	dBm1H = bm1.dD(vz1);

//Create Plane for every side of bm0	
	Plane pnBm0s[4];
	pnBm0s[0] = Plane(ptZ0Cen + vz * 0.5 * dBm0H, vz); 
	pnBm0s[1] = Plane(ptZ0Cen + vy * 0.5 * dBm0W, vy);
	pnBm0s[2] = Plane(ptZ0Cen - vz * 0.5 * dBm0H, -vz);
	pnBm0s[3] = Plane(ptZ0Cen - vy * 0.5 * dBm0W, -vy);	
	
//	for(int i=0; i < pnBm0s.length();i++)
//		pnBm0s[i].vis(i);
	
//Create a Line for every edge of bm1
	Line lnBm1s[4];
	{ 
		int i;
		lnBm1s[i++] = Line(ptZ1Cen + vy1 * 0.5 * dBm1W - vz1 * 0.5 * dBm1H, vx1);
		lnBm1s[i++] = Line(ptZ1Cen + vy1 * 0.5 * dBm1W + vz1 * 0.5 * dBm1H, vx1);
		lnBm1s[i++] = Line(ptZ1Cen - vy1 * 0.5 * dBm1W + vz1 * 0.5 * dBm1H, vx1);
		lnBm1s[i++] = Line(ptZ1Cen - vy1 * 0.5 * dBm1W - vz1 * 0.5 * dBm1H, vx1);
	}
	
	Point3d ptsP[16];
	int nIntersections[16];
	PLine plMark[0];
	PLine plMark2[0];
	PLine plDisplay[0];
	Vector3d vecPnUps[] = { vz1, -vy1, -vz1, vy1};

// Intersect Lines and planes
	for(int i=0; i < 4; i++)
	{
		for(int j=0;j < 4; j++)
		{
			int n = i * 4 + j;
			nIntersections[n] = lnBm1s[j].hasIntersection(pnBm0s[i], ptsP[n]);
		}
	}
	
	if(nIntersections.length() != 16 || ptsP.length() != 16)
	{
		reportMessage("\n" + scriptName() + ": " +T("|Unexpected erroer. Instance deleted|"));
		eraseInstance();
		return;	
	}

// Get all valid intersections. The number should be 8 or 16.
	for(int i=0; i < 4; i++)
	{
		if(nIntersections[i*4] == 0)
			continue;
			
		for(int j=0; j < 4; j++)
		{
			int nNext = (j == 3) ? 0 : j +1;
			int n = i * 4;
			
			Vector3d vec(ptsP[n + nNext] - ptsP[n + j]); 
			vec.normalize();
			
			PLine pl(ptsP[n + j], ptsP[n + nNext]);
			
			if(vec.dotProduct(vecPnUps[j]) < 0)
			{
				vec *= -1;
				pl.reverse();
			}
			
			if(i%2 == 0)
				plMark.append(pl);
			else
				plMark2.append(pl);
		}
	}
	
// Take PLines most square to bm1 if 16 intersections exist
	if(plMark.length() == 8 )
	{
		if(plMark2.length() == 8)
		{
			PLine pls[0], pls2[0];
			for(int i = 0; i < plMark.length();i++)
			{
				int nV = (i > 3) ? i - 4 : i;
				Vector3d vec(plMark[i].ptEnd() - plMark[i].ptStart());
				double dAngle = vec.angleTo(vecPnUps[nV]);

				if( dAngle +dEps < 45 || pnBm0s[1].normal().isPerpendicularTo(vec))
				{
					pls.append(plMark[i]);
					pls2.append(plMark2[i]);
				}
				else
				{
					pls2.append(plMark[i]);
					pls.append(plMark2[i]);
				}
			}
			plMark = pls;
			plMark2 = pls2;
		}
	}
	else
	{
		if(nIntersections.length() != 16 || ptsP.length() != 16)
		{
			reportMessage("\n" + scriptName() + ": " +T("|Unexpected error. Instance deleted|"));
			eraseInstance();
			return;	
		}		
	}
	
	if(plMark.length() == 0 && plMark2.length() == 8)
		plMark = plMark2;
		
	if(plMark.length() != 8)
	{
		reportMessage("\n" + scriptName() + ": " +T("|Unexpected error. Instance deleted|"));
		eraseInstance();
		return;
	}
	
//	for(int i=0; i < ptsP.length();i++)
//		ptsP[i].vis(i);
	
// Get used PLines
	PLine plMs[0];	
	plMs.append(plMark[nFace]);
	plMs.append(plMark[nFace + 4]);
	
// Check and reassign normal and upwards Vectors 
	Vector3d vecPnNorms[4];
	{ 
		int a = (vy1.dotProduct(plMark[0].ptMid() - ptZ1Cen) > 0) ? 1 : - 1;
		vecPnNorms[0] = a * vy1;
		vecPnNorms[2] = - a * vy1;
		a = (vz1.dotProduct(plMark[1].ptMid() - ptZ1Cen) > 0) ? 1 : - 1;
		vecPnNorms[1] = a * vz1;
		vecPnNorms[3] = - a * vz1;
	}
	
// Trigger orientation of marker. Use top/bottom points
	int nOrient = -1;
	if(nDir == 1)
	{
		if(_Map.hasInt("Orientation"))
			nOrient = _Map.getInt("Orientation");
		
		String sTriggerEditInPlaces[] = {T("|Mark top edge|"),T("|Mark bottom edge|")};
		String sTriggerEditInPlace = sTriggerEditInPlaces[nOrient == nSignOrient? 1:0];
		addRecalcTrigger(_kContextRoot, sTriggerEditInPlace );
		if (_bOnRecalc && _kExecuteKey==sTriggerEditInPlace )
			{
			if (nOrient == 1)
			{
				nOrient = -1;
			}
			else
				nOrient= 1;
			_Map.setInt("Orientation",nOrient);
		}
	}

		
// string builder
	String sTxt;
	sTxt = sPrefix;
	if (sTxt.length()>0) sTxt = sTxt + " ";
	if (sTxt == "" && nSide == 4 && nAutoTxt == 2)	
	{
		nAutoTxt = 0;
		sAutoTxt.set(sArAutoTxt[nAutoTxt]);
	}
	
	if (nAutoTxt == 0)
	{
		if(!truss.bIsValid())
			sTxt = sTxt + bm0.posnum();
	}
	if (nAutoTxt == 1)
	{
		if(!truss.bIsValid())
			sTxt = sTxt + bm0.name("posnumandtext") ;
	}
	
//// add a markerline
	if (nDir == 0)
	{	
		Point3d ptMrkL = plMs[0].ptMid();
		Point3d ptMrkR = plMs[1].ptMid();
		MarkerLine mrkLineL( plMs[0].ptStart(), plMs[0].ptEnd(), vecPnNorms[nFace]);
		MarkerLine mrkLineC( (plMs[0].ptStart() + plMs[1].ptStart()) / 2, (plMs[0].ptEnd() + plMs[1].ptEnd()) / 2, vecPnNorms[nFace]);
		MarkerLine mrkLineR (plMs[1].ptStart(), plMs[1].ptEnd(), vecPnNorms[nFace]);
		Mark mrk;
		
		if (nSide == 0)
		{
			mrk = Mark( ptMrkL, ptMrkR, vecPnNorms[nFace], sTxt);
			plDisplay.append(plMs[0]);
			plDisplay.append(plMs[1]);
			bm1.addTool(mrkLineL);
			bm1.addTool(mrkLineR);	
		}
		else if (nSide == 1)
		{
			mrk = Mark(ptMrkL, vecPnNorms[nFace], sTxt);
			plDisplay.append(plMs[0]);
			bm1.addTool(mrkLineL);
		}
		else if (nSide == 2)
		{
			mrk = Mark( (ptMrkL + ptMrkR)/2, vecPnNorms[nFace], sTxt);
			plDisplay.append(PLine((plMs[0].ptStart() + plMs[1].ptStart()) / 2, (plMs[0].ptEnd() + plMs[1].ptEnd()) / 2));	
			bm1.addTool(mrkLineC);
		}
		else if (nSide == 3)
		{
			mrk = Mark(ptMrkR, vecPnNorms[nFace], sTxt);
			plDisplay.append(plMs[1]);
			bm1.addTool(mrkLineR);
		}
		if (nAutoTxt !=2)
		{
			mrk.suppressLine();	
	   		mrk.setTextPosition(nTextPosition,nTextAlignment,nDirection);
			bm1.addTool(mrk);
		}
	}
// add a marker
	else if(nDir == 1)	
	{
		Point3d ptML = (nOrient == 1)? plMs[0].ptEnd() : plMs[0].ptStart();
		Point3d ptMR = (nOrient == 1)? plMs[1].ptEnd() : plMs[1].ptStart();
		PLine plML = PLine(ptML, ptML - nOrient * vecPnUps[nFace] * bm1.dD(vecPnUps[nFace]));
		PLine plMR = PLine(ptMR, ptMR - nOrient * vecPnUps[nFace] * bm1.dD(vecPnUps[nFace]));
		
		Mark mrk;
		if (nSide == 0)
		{
			mrk = Mark( ptML, ptMR, vecPnNorms[nFace], sTxt);
			plDisplay.append(plML);	
			plDisplay.append(plMR);
		}
		else if (nSide == 1)
		{
			mrk = Mark( ptML, vecPnNorms[nFace], sTxt);
			plDisplay.append(plML);	
		}			
		else if (nSide == 2)
		{
			mrk = Mark( (ptML + ptMR)/2, vecPnNorms[nFace], sTxt);
			plDisplay.append(PLine( (plML.ptStart() + plMR.ptStart())/2,(plML.ptEnd() + plMR.ptEnd())/2));	
		}
		else if (nSide == 3)
		{
			mrk = Mark( ptMR, vecPnNorms[nFace], sTxt);
			plDisplay.append(plMR);	
		}

	  	mrk.setTextPosition(nTextPosition,nTextAlignment,nDirection);
		bm1.addTool(mrk);
	}
	
// UI Display
	if (plDisplay.length()>0)
	{
		Display dp(nDimColor);
		for (int i = 0; i < plDisplay.length();i++)
			dp.draw(plDisplay[i]);
	}





#End
#BeginThumbnail
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
<BC0'TZ_(_Q_('1S`'WO#S`````!)14Y$KD)@@@``
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="552" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23959: Fix when checking validity for beam as marking entity" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="4/29/2025 10:01:05 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20495: Bug fix when getting section width/height" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="12/21/2023 12:57:49 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14287: Fix TSL description" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="1/10/2022 10:36:44 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14087 group assignment added" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="12/7/2021 2:06:44 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12447: change TSL type from &quot;X&quot; to &quot;O&quot;; support truss entities as marking entity" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="8/23/2021 2:17:25 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End