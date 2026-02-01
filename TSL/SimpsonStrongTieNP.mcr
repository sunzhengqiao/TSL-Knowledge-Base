#Version 8
#BeginDescription
version value="1.6" date=08jan2020" author="marsel.nakuci@hsbcad.com"

HSB-6312: adapt the simpson strongtie values
Eigenschaften kategorisiert und z.T. zusammengefasst. 
HINWEIS nicht kompatibel zu bereits eingefügten Instanzen 

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 1
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// This tsl creates metal plate connectors
/// </summary> 

/// <version  value=”1.4” date=”20february09”></version>

/// History
///<version value="2.0" date=08jan2020" author="marsel.nakuci@hsbcad.com"> HSB-6312: adapt the simpson strongtie values </version>
///<version value="1.5" date=27oct17" author="thorsten.huck@hsbcad.com"> Eigenschaften kategorisiert und z.T. zusammengefasst. HINWEIS nicht kompatibel zu bereits eingefügten Instanzen </version>
/// Version 1.4   20.02.2009   th@hsbcad.de
/// new property "stretch beams" will turn on/off the streching behaviour.
/// Version 1.3   10.04.2006   hs@hsbcad.de
///    -Blech immer rechtwinklig zu parallelen Balken
/// Version 1.2   14.08.2005   hs@hsbcad.de
///    -Vorschaubitmap eingefügt
/// Version 1.1   12.08.2005   hs@hsbcad.de
///    -Syntax verbessert
///    -Auswahl der Balken auf drei begrenzt
/// Version 1.0   11.08.2005   hs@hsbcad.de
///    -fügt verschieden BMF-Lochbleche zur Verbindung zweier (dreier) Balken ein
///    -optionale besteht die Möglichkeit ein Lochblech an den Rändern der Balken zuschneiden zu lassen
// constants //region
	U(1,"mm");	
	double dEps = U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick = "TslDoubleClick";
	int bDebug = _bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL", 0) >- 1 ? true : (projectSpecial().makeUpper().find(scriptName().makeUpper(), 0) >- 1 ? true : bDebug));
	String sDefault = T("|_Default|");
	String sLastInserted = T("|_LastInserted|");
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	//endregion
	
	
	String sArType1[51];
	for (int i = 0; i < 23; i++)
		sArType1[i] = (T("BMF-Lochblech"));
	for (int i = 23; i < 51; i++)
		sArType1[i] = (T("BMF-Lochblechstreifen"));
	
	String sArType2[] = { "15/40/120", "15/40/160", "15/50/200", "15/60/140", "15/60/160", "15/60/180", "15/60/200", "15/60/220", "15/60/240", "15/60/300", "15/60/340", "15/60/420",
						  "15/60/500", "15/80/100", "15/80/140", "15/80/180", "15/80/200", "15/80/220", "15/80/240", "15/80/260", "15/80/280", "15/80/300", "15/80/340", "15/80/380", "15/80/420", "15/80/500", 
						  "15/100/140", "15/100/180", "15/100/200", "15/100/220", "15/100/240", "15/100/300", "15/100/340", "15/100/380",
						  "15/120/160", "15/120/220", "15/120/240", "15/120/260", "15/120/300", "15/120/340", "15/120/380",
						  "15/140/140", "15/140/180", "15/140/200", "15/140/220", "15/140/240", "15/140/260", "15/140/300", "15/140/380", "15/140/420",
						  "15/160/180", "15/160/220", "15/160/240", "15/160/260", "15/160/340", "15/160/380", "15/160/400", "15/160/420", 
						  "15/180/180", "15/180/220", 
						  "15/200/220", "15/200/260", 
						  "15/220/220", "15/220/260", "15/220/300", 
						  "15/240/180", "15/240/220", "15/240/260", "15/240/300", 
						  "15/260/260", 
						  "15/280/220", "15/280/260", "15/280/300", 
						  "15/320/140", 
						  "20/40/120", "20/40/160", "20/50/200", "20/60/140", "20/60/160", "20/60/200", "20/60/240", "20/80/160", "20/80/200", "20/80/240", "20/80/300", 
						  "20/100/140", "20/100/160", "20/100/200", "20/100/240", "20/100/260", "20/100/300", "20/100/400", "20/100/500", 
						  "20/120/160", "20/120/200", "20/120/240", "20/120/260", "20/120/300", "20/120/400", 
						  "20/140/200", "20/140/240", "20/140/400", "20/160/300", "20/160/400", "20/200/300", "20/350/40", "20/620/1240", "25/620/1240", "30/620/1240"};
	
//	String sArType2[] = {"40x120x2,0","40x160x2,0","50x200x2,0","60x140x2,0","60x200x2,0","60x240x2,0","80x200x2,0","80x240x2,0","80x300x2,0","100x140x2,0",
//							"100x200x2,0","100x240x2,0","100x260x2,0","100x300x2,0","100x400x2,0","100x500x2,0","120x200x2,0","120x240x2,0","120x260x2,0",
//							"120x300x2,0","140x400x2,0","160x400x2,0","200x300x2,0","40x1200x2,0","60x1200x2,0","80x1200x2,0","100x1200x2,0","120x1200x2,0",
//							"140x1200x2,0","160x1200x2,0","180x1200x2,0","200x1200x2,0","220x1200x2,0","240x1200x2,0","260x1200x2,0","280x1200x2,0","300x1200x2,0",
//							"40x1200x2,5","60x1200x2,5","80x1200x2,5","100x1200x2,5","120x1200x2,5","140x1200x2,5","160x1200x2,5","180x1200x2,5","200x1200x2,5",
//							"220x1200x2,5","240x1200x2,5","260x1200x2,5","280x1200x2,5","300x1200x2,5"};
	String sArType[sArType2.length()];
	for (int i = 0; i < sArType2.length(); i++)
	{ 
//		sArType[i] = (sArType2[i] + " " + sArType1[i]);
		sArType[i] = "NP"+sArType2[i];
	}
	
	category = T("|Model|");
	String sTypeName=T("|Type|");	
	PropString sType(nStringIndex++, sArType, sTypeName);	
	sType.setDescription(T("|Defines the Type|"));
	sType.setCategory(category);

	String sType1;
	sType1 = sType;

	double dLengths[] = { U(120), U(160), U(200), U(140), U(160), U(180), U(200), U(220), U(240), U(300), U(340), U(420), U(500), U(100), U(140), U(180), U(200), U(220), U(240), U(260), U(280), U(300), 
						  U(340), U(380), U(420), U(500), U(140), U(180), U(200), U(220), U(240), U(300), U(340), U(380), U(160), U(220), U(240), U(260), U(300), U(340), U(380), U(140), U(180), 
						  U(200), U(220), U(240), U(260), U(300), U(380), U(420), U(180), U(220), U(240), U(260), U(340), U(380), U(400), U(420), U(180), U(220), U(220), U(260), U(220), U(260), 
						  U(300), U(180), U(220), U(260), U(300), U(260), U(220), U(260), U(300), U(140), U(120), U(160), U(200), U(140), U(160), U(200), U(240), U(160), U(200), U(240), U(300), 
						  U(140), U(160), U(200), U(240), U(260), U(300), U(400), U(500), U(160), U(200), U(240), U(260), U(300), U(400), U(200), U(240), U(400), U(300), U(400), U(300), U(40),
						  U(1240), U(1240), U(1240)};
//	double dLengths[] = {U(120),U(160),U(200),U(140),U(200),U(240),U(200),U(240),U(300),U(140),U(200),U(240),U(260),U(300),U(400),
//							U(500),U(200),U(240),U(260),U(300),U(400),U(400),U(300),U(1200),U(1200),U(1200),U(1200),U(1200),U(1200),
//							U(1200),U(1200),U(1200),U(1200),U(1200),U(1200),U(1200),U(1200),U(1200),U(1200),U(1200),U(1200),U(1200),
//							U(1200),U(1200),U(1200),U(1200),U(1200),U(1200),U(1200),U(1200),U(1200)};
							
							
	double dWidths[] = { U(40), U(40), U(50), U(60), U(60), U(60), U(60), U(60), U(60), U(60), U(60), U(60), U(60), U(80), U(80), U(80), U(80), U(80), U(80), U(80), U(80), U(80), U(80), U(80), U(80), U(80),
		U(100), U(100), U(100), U(100), U(100), U(100), U(100), U(100), U(120), U(120), U(120), U(120), U(120), U(120), U(120), U(140), U(140), U(140), U(140), U(140), U(140), U(140), U(140), U(140),
		U(160), U(160), U(160), U(160), U(160), U(160), U(160), U(160), U(180), U(180), U(200), U(200), U(220), U(220), U(220), U(240), U(240), U(240), U(240), U(260), U(280), U(280), U(280), U(320), U(40), U(40),
		U(50), U(60), U(60), U(60), U(60), U(80), U(80), U(80), U(80), U(100), U(100), U(100), U(100), U(100), U(100), U(100), U(100), U(120), U(120), U(120), U(120), U(120), U(120), U(140), U(140), U(140),
		U(160), U(160), U(200), U(350), U(620), U(620), U(620)};
//	double dWidths[] = {U(40),U(40),U(50),U(60),U(60),U(60),U(80),U(80),U(80),U(100),U(100),U(100),U(100),U(100),U(100),U(100),U(120),U(120),U(120),U(120),U(140),
//							U(160),U(200),U(40),U(60),U(80),U(100),U(120),U(140),U(160),U(180),U(200),U(220),U(240),U(260),U(280),U(300),U(40),U(60),U(80),U(100),
//							U(120),U(140),U(160),U(180),U(200),U(220),U(240),U(260),U(280),U(300)};
	
	double dThicknesses[109];
	for (int i = 0; i < 74; i++)
	{ 
		dThicknesses[i] = U(1.5);
	}//next i
	for (int i = 74; i < 108; i++)
	{ 
		dThicknesses[i] = U(2);
	}//next i
	dThicknesses[108] = U(3);
	
//	double dThicknesses[] = {U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),
//							U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.0),U(2.5),U(2.5),U(2.5),U(2.5),
//							U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5),U(2.5)};
	
	
	category = T("|Custom Shape|");
	
	String sFreeSteelPlateName=category;	
	PropString sFreeSteelPlate(nStringIndex++, sNoYes, sFreeSteelPlateName);	
	sFreeSteelPlate.setDescription(T("|Defines the Free Steel Plate|"));
	sFreeSteelPlate.setCategory(category);
	
	String sLengthName=T("|Length|");	
	PropDouble dLength(nDoubleIndex++, U(3000), sLengthName);	
	dLength.setDescription(T("|Defines the Length|"));
	dLength.setCategory(category);
	
	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(1300), sWidthName);	
	dWidth.setDescription(T("|Defines the Width|"));
	dWidth.setCategory(category);
	
	double dFreeThicknesses[] = {U(1.5), U(2.0), U(2.5), U(3.0)};
	String sThicknessName=T("|Thickness|");	
	PropDouble dThickness(nDoubleIndex++, dFreeThicknesses, sThicknessName);	
	dThickness.setDescription(T("|Defines the Thickness|"));
	dThickness.setCategory(category);
	
// general
	category = T("|Model|");
	String sArticle1Name=T("|Article|");	
	PropString sArticle1(nStringIndex++, "", sArticle1Name);	
	sArticle1.setDescription(T("|Defines the Article|"));
	sArticle1.setCategory(category);
	
	String sMaterial1Name=T("|Material1|");	
	PropString sMaterial1(nStringIndex++, "Stahl, feuerverzinkt", sMaterial1Name);	
	sMaterial1.setDescription(T("|Defines the Material|"));
	sMaterial1.setCategory(category);
	
	category = T("|Nails|");
	PropString sMod2 (nStringIndex++, "Kammnagel", T("|Model|"));
	sMod2.setCategory(category);
	
	String sArticle2Name=T("|Article|") + " ";	
	PropString sArticle2(nStringIndex++, "", sArticle2Name);	
	sArticle2.setDescription(T("|Defines the Article|"));
	sArticle2.setCategory(category);
	
	String sMaterial2Name=T("|Material|") + " ";	
	PropString sMaterial2(nStringIndex++, "Stahl, feuerverzinkt", sMaterial2Name);	
	sMaterial2.setDescription(T("|Defines the Material|"));
	sMaterial2.setCategory(category);
	
	String sDiameterName=T("|Diameter|");	
	PropDouble dDiameter(nDoubleIndex++, U(0), sDiameterName);	
	dDiameter.setDescription(T("|Defines the Diameter|"));
	dDiameter.setCategory(category);
	
	String sLength2Name=T("|Length|")+ " ";	
	PropDouble dLength2(nDoubleIndex++, U(0), sLength2Name);	
	dLength2.setDescription(T("|Defines the Length|"));
	dLength2.setCategory(category);
	
	String sNumNailName=T("|Amount|");	
	PropInt nNumNail(nIntIndex++, 8, sNumNailName);	
	nNumNail.setDescription(T("|Defines the amount of nails|"));
	nNumNail.setCategory(category);
	int nNumNail1 = nNumNail;
	
	category = T("|Model|");
	PropDouble dOffset (5, U(0), T("Offset of Steel strap"));
	dOffset.setCategory(category);
	
	PropString sDuplex (9, sNoYes, T("|Duplex|"), 1);
	sDuplex.setCategory(category);
	
	String sArSide[] = {T("|Left|"), T("|Right|")};
	PropString sSide (10, sArSide, T("|Side|"));
	sSide.setCategory(category);
	
	PropString sStretch(12, sNoYes, T("|Stretch|"), 1);	
	//PropString sShow (12, sNoYes, T("Show Holes"), 0);
	sStretch.setCategory(category);
	
// display
	category = T("|Display|");
	PropString sDescription (11, sNoYes, T("Show description"),1);	
	sDescription.setCategory(category);
	
	PropDouble dxFlag (6, U(200), T("X-flag"));
	dxFlag.setCategory(category);
	
	PropDouble dyFlag (7, U(300), T("Y-flag"));
	dyFlag.setCategory(category);
	
	PropString sDimStyle (13, _DimStyles, T("Dimstyle"));
	sDimStyle.setCategory(category);
	
	PropInt nColor (1,171,T("Color"));
	nColor.setCategory(category);
	
	int nBd = 1;
	
// find type
	int f; 							 				
	for(int i = 0; i < sArType.length(); i++){				
		if (sType == sArType[i]) 			
			f = i;
	}
	
	int l;
	for(int i = 0; i < dFreeThicknesses.length(); i++){
		if (dThickness == dFreeThicknesses[i])
			l = i;
	}


// free steel strap
	double dL, dW, dT;
	dL = dLengths[f];
	dW = dWidths[f];
	dT = dThicknesses[f];
	if (sFreeSteelPlate == sNoYes[1]){
		dL = dLength;
		dW = dWidth;
		dT = dFreeThicknesses[l];
		sType1 = (T("|BMF-Lochblech|") + ": " + dL + "x" + dW + "x" + dT);
		sArType1[f] = (T("|BMF-Lochblech|"));	
		sArType2[f] = (dW + "x" + dL + "x" + dT);					
	}
	else if (sFreeSteelPlate == sNoYes[0]){
		int i = 1;
		dLength.setReadOnly(i);
		dWidth.setReadOnly(i);
		dThickness.setReadOnly(i);
	}
		
// get entity
	if (_bOnInsert){
		_Beam.append(getBeam(T("|Select first Beam|")));
		_Beam.append(getBeam(T("|Select second Beam|")));
		
			if(_Beam.length() < 2)
				return;	
		// declare standards	
		Beam bm1 = _Beam[0];
		Beam bm2 = _Beam[1];	

		Vector3d vx1, vy1, vz1, vx2, vy2, vz2;
		vx1 = bm1.vecX().normal();
		vx2 = bm2.vecX().normal();
		vz1 = vx1.crossProduct(vx2).normal();
		vz2 = vz1.normal();
		vy1 = vx1.crossProduct(vz1).normal();
		vy2 = vx2.crossProduct(vz2).normal();
		
		if (vx1.isParallelTo(vx2) && !(bm1.ptCen() - bm2.ptCen()).isParallelTo(vx1)){
			_Pt0 = getPoint();
		}
		
		if (!vx1.isParallelTo(vx2)){
			while(1){
				PrEntity ssE (T("Select optional beam"), Beam());
				if (ssE.go() == _kOk)
					_Beam.append(ssE.beamSet());
				else 
					break;
			}
		}
			
		showDialog();
		return;
	}

	
	int bStretch = sNoYes.find(sStretch);
	sStretch.setReadOnly(true);

// declare standards	
	Beam bm1 = _Beam[0];
	Beam bm2 = _Beam[1];	

	Vector3d vx1, vy1, vz1, vx2, vy2, vz2;
	vx1 = bm1.vecX().normal();
	vx2 = bm2.vecX().normal();
	vz1 = vx1.crossProduct(vx2).normal();
	vz2 = vz1.normal();
	vy1 = vx1.crossProduct(vz1).normal();
	vy2 = vx2.crossProduct(vz2).normal();
	
	CoordSys cs(_Pt0, vx1, vy1, vz1);
	
	double dH1, dW1, dH2, dW2;
	dH1 = bm1.dD(vz1);
	dW1 = bm1.dD(vy1);
	dH2 = bm2.dD(vz2);
	dW2 = bm2.dD(vy2);

// integer for changing sides
	int nSide = 1;
	if(sSide == sArSide[1])	
		nSide = -1;

	Body bd;
			
// get _Pt0
	// for parallel
	if (vx1.isParallelTo(vx2)){
		
		// for parallel but not in one line
		if (!(bm1.ptCen() - bm2.ptCen()).isParallelTo(vx1)){
			vx1 = bm1.vecX().normal();
			vx2 = bm2.vecX().normal();
			vz1 = vx1.crossProduct(bm1.ptCen() - bm2.ptCen()).normal();
			vz2 = vz1.normal(); vz2.vis(_Pt0, 2);
			vy1 = vx1.crossProduct(vz1).normal();
			vy2 = vx2.crossProduct(vz2).normal();
			
			Line ln2 (bm2.ptCen(), vx2);
			Point3d pt1;
			pt1 = ln2.closestPointTo(_Pt0);
			Vector3d v12;
			v12 = bm1.ptCen() - bm2.ptCen();
			if (vy1.dotProduct(v12) < 0)
				vy1 = - vy1;			
			//_Pt0 = pt1 + v12/2;
		
			// one hardware
			if(sDuplex == sNoYes[0]){	
				// body
				Point3d ptInsert = _Pt0 + nSide * dH2/2 * vz2 + dOffset * vy1.normal();
				bd = Body(ptInsert, vy1.normal(), vx2, vz2, dL, dW, dT, 0, 0, nSide * 1); 
			}
		
			// two hardwares
			if(sDuplex == sNoYes[1]){
				// body
				Point3d ptInsert1 = _Pt0 - dH2/2 * vz2 + dOffset * vy1.normal();
				Point3d ptInsert2 = _Pt0 + dH2/2 * vz2 + dOffset * vy1.normal();
				Body bd1 (ptInsert1, vy1.normal(), vx2, vz2, dL, dW, dT, 0, 0, -1); 
				Body bd2 (ptInsert2, vy1.normal(), vx2, vz2, dL, dW, dT, 0, 0, 1); 
				bd = bd1 + bd2;
		
				// lock sSide
				int i = 1;
				sSide.setReadOnly(i);
			
				// numbers
				nNumNail1 = nNumNail1 * 2;
				nBd = nBd * 2;
			}	
		}
			
		// for parallel and in one line
		if((bm1.ptCen() - bm2.ptCen()).isParallelTo(vx1)){	
			vx1 = bm1.vecX().normal();
			vx2 = bm2.vecX().normal();
			vz1 = bm1.vecZ().normal();
			vz2 = vz1.normal();
			vy1 = vx1.crossProduct(vz1).normal();
			vy2 = vx2.crossProduct(vz2).normal();
			
			Vector3d v12;
			Vector3d vX = v12;
			v12 = (bm1.ptCen() - bm2.ptCen()).normal();
			Point3d pt1 = bm1.ptCen() - v12 * bm1.solidLength()/2;
			Point3d pt2 = bm2.ptCen() + v12 * bm2.solidLength()/2;
			pt1.vis(2);
			pt2.vis(2);
			_Pt0 = pt1 - v12 * (pt1 - pt2).length()/2;
			
			// one hardware
			if(sDuplex == sNoYes[0]){	
				// body
				Point3d ptInsert = _Pt0 + nSide * dH2/2 * vz2 + dOffset * v12.normal();
				bd = Body(ptInsert, vx1, vy1, vz1, dL, dW, dT, 0, 0, nSide * 1); 
			}
		
			// two hardwares
			if(sDuplex == sNoYes[1]){
				// body
				Point3d ptInsert1 = _Pt0 - dH2/2 * vz2 + dOffset * v12.normal();
				Point3d ptInsert2 = _Pt0 + dH2/2 * vz2 + dOffset * v12.normal();
				Body bd1 (ptInsert1, vx1, vy1, vz1, dL, dW, dT, 0, 0, -1); 
				Body bd2 (ptInsert2, vx1, vy1, vz1, dL, dW, dT, 0, 0, 1); 
				bd = bd1 + bd2;
		
				// lock sSide
				int i = 1;
				sSide.setReadOnly(i);
			
				// numbers
				nNumNail1 = nNumNail1 * 2;
				nBd = nBd * 2;
			}
		}
	}
	
	// for T-Connection
	if(_Beam.length() < 3){
		if(!vx1.isParallelTo(vx2)){
			if((bm2.ptCen() - bm1.ptCen()).dotProduct(vy2) > 0)
				vy2 = -vy2;
			Line ln1 (bm1.ptCen(), vx1);
			Plane pn2 (bm2.ptCen(), vy2);
			Point3d pt1;
			pt1 = ln1.intersect(pn2, 0) + dW2/2 * vy2;
			pt1.vis(2);
			_Pt0 = ln1.closestPointTo(pt1);
			
			// cut
			Cut ct (_Pt0, -vy2);
			if (bStretch)
				bm1.addTool(ct, 1);
			
			// one hardware
			if(sDuplex == sNoYes[0]){	
				// body
				Point3d ptInsert = _Pt0 + nSide * dH2/2 * vz1 + dOffset * vx1;
				bd = Body(ptInsert, vx1, vy1, vz1, dL, dW, dT, 0, 0, nSide * 1); 
			}
			
			// two hardwares	
			else if(sDuplex == sNoYes[1]){
				// body
				Point3d ptInsert1 = _Pt0 - dH2/2 * vz1 + dOffset * vx1;
				Point3d ptInsert2 = _Pt0 + dH2/2 * vz1 + dOffset * vx1;
				Body bd1 (ptInsert1, vx1, vy1, vz1, dL, dW, dT, 0, 0, -1); 
				Body bd2 (ptInsert2, vx1, vy1, vz1, dL, dW, dT, 0, 0, 1); 
				bd = bd1 + bd2;
		
				// lock sSide
				int i = 1;
				sSide.setReadOnly(i);
				
				// numbers
				nNumNail1 = nNumNail1 * 2;
				nBd = nBd * 2;
			}	
		}
	}
	
	// for 3 beams
	if(_Beam.length() > 2){
		// declare standards	
		Beam bm3 = _Beam[2];	

		Vector3d vx3, vy3, vz3;
		vx3 = bm3.vecX().normal();
		vz3 = vx3.crossProduct(vx2).normal();
		vy3 = vx3.crossProduct(vz3).normal();
		
		if(!vx1.isParallelTo(vx2)){
			if((bm2.ptCen() - bm1.ptCen()).dotProduct(vy2) > 0)
				vy2 = -vy2;
			Line ln1 (bm1.ptCen(), vx1);
			Plane pn1 (bm2.ptCen(), vy2);
			Point3d pt1;
			pt1 = ln1.intersect(pn1, 0);
			pt1.vis(3);
			if((bm2.ptCen() - bm3.ptCen()).dotProduct(vy2) > 0)
				vy2 = -vy2;
			Line ln3 (bm3.ptCen(), bm3.vecX());
			Plane pn3 (bm2.ptCen(), vy2);
			Point3d pt3;
			pt3 = ln3.intersect(pn3, 0);
			pt3.vis(2);
			_Pt0 = pt1 + (pt3 - pt1)/2;
			Plane pn (bm2.ptCen(), vz2);
			_Pt0 = _Pt0.projectPoint(pn, 0);
			
			// cut
			if((bm2.ptCen() - bm1.ptCen()).dotProduct(vy2) > 0)
				vy2 = -vy2;
			vy2.vis(_Pt0, 0);
			Cut ct1 (_Pt0 + bm2.dD(vy2)/2 * vy2, -vy2);
			Cut ct2 (_Pt0 - bm2.dD(vy2)/2 * vy2, vy2);
			if (bStretch)
			{
				bm1.addTool(ct1, 1);
				bm3.addTool(ct2, 1);
			}
			
			// one hardware
			if(sDuplex == sNoYes[0]){	
				// body
				Point3d ptInsert = _Pt0 + nSide * dH2/2 * vz1 + dOffset * vx2;
				bd = Body(ptInsert, vy2, vx2, vz2, dL, dW, dT, 0, 0, nSide * 1);
				
				// cutbody on beamside
				if((pt1 - bm1.ptCen()).dotProduct(vy1) > 0)
					vy1 = -vy1;
				Cut ct1 (bm1.ptCen() + (bm1.dD(vy1))/2 * vy1, vy1);
				if (bStretch)
					bd.addTool(ct1);
				if((pt3 - bm1.ptCen()).dotProduct(vy3) < 0)
					vy3 = -vy3;
				Cut ct3 (bm3.ptCen() + (bm3.dD(vy3))/2 * vy3, vy3);
				if (bStretch)
					bd.addTool(ct3);
			}
			
			// two hardwares	
			if(sDuplex == sNoYes[1]){
				// body
				Point3d ptInsert1 = _Pt0 - dH2/2 * vz3 + dOffset * vx2;
				Point3d ptInsert2 = _Pt0 + dH2/2 * vz3 + dOffset * vx2;
				Body bd1 (ptInsert1, vy2, vx2, vz2, dL, dW, dT, 0, 0, -1); 
				Body bd2 (ptInsert2, vy2, vx2, vz2, dL, dW, dT, 0, 0, 1); 
				bd = bd1 + bd2;
		
				// lock sSide
				int i = 1;
				sSide.setReadOnly(i);
				
				// cutbody on beamside
				if((pt1 - bm3.ptCen()).dotProduct(vy1) < 0)
					vy1 = -vy1;
				Cut ct1 (bm1.ptCen() + (bm1.dD(vy1))/2 * vy1, vy1);
				if (bStretch)
					bd.addTool(ct1);
				if((pt3 - bm1.ptCen()).dotProduct(vy3) < 0)
					vy3 = -vy3;
				Cut ct3 (bm3.ptCen() + (bm3.dD(vy3))/2 * vy3, vy3);
				if (bStretch)
					bd.addTool(ct3);
				
				// numbers
				nNumNail1 = nNumNail1 * 2;
				nBd = nBd * 2;
			}	
		}
	}

/*// drill
	if (sShow == sNoYes[1]){
		
		if(_Beam.length() > 2){
			vx1 = vy2;
			vy1 = vx2;
			vz1 = vz2;
		} 
		
		if (vx1.isParallelTo(vx2) && !(bm1.ptCen() - bm2.ptCen()).isParallelTo(vx1)){
			vx1 = vy2;
			vy1 = vx2;
			vz1 = vz2;		
		}
		Drill dr(_Pt0 - vx1 * (dL/2 - U(10)) - vy1 * (dW/2 - U(10)) - vz1 * U(5000), vz1, U(10000), U(2.5));
		Drill dr1(_Pt0 - vx1 * (dL/2 - U(30)) - vy1 * dW/2 - vz1 * U(5000), vz1, U(10000), U(2.5));
		bd.addTool(dr);
		bd.addTool(dr1);
		
		// integer for counting nails
		int nN1;
		int nN2;
		
		double dU = (dW - U(20))/U(20);
		int nU = (int)dU;
		double dU1 = dW/U(20);
		int nU1 = (int)dU1;
		for(int i = 0; i < nU + 1; i++){
			double dT = (dL - U(10))/U(40);
			int nT = (int)dT;
			nN1 = nT + 1;
			for(int z = 0; z < nT; z++){
				dr.transformBy(vx1 * U(40));
				bd.addTool(dr);
				bd.vis();
			}
			if (i != nU){
				dr.transformBy(-vx1 * nT * U(40));
				dr.transformBy(vy1 * U(20));
				bd.addTool(dr);
				bd.vis();
			}
		}
	
		for(int i = 0; i < nU1 + 1; i++){
			double dT = (dL - U(30))/U(40);
			int nT = (int)dT;
			nN2 = nT + 1;
			for(int z = 0; z < nT; z++){
				dr1.transformBy(vx1 * U(40));
				bd.addTool(dr1);
				bd.vis();
			}
			if (i != nU1){
				dr1.transformBy(-vx1 * nT * U(40));
				dr1.transformBy(vy1 * U(20));
				bd.addTool(dr1);
				bd.vis();
			}
		}
		
		//counting Nails
		int nNumNailum = nN1 * (nU + 1) + nN2 * (nU1 - 1);
		if (nNumNail == 0)
			nNumNail1 = nNumNailum * nBd;						
	}*/

// get Grippoints
_Pt0.vis(3);
	if (_PtG.length() < 1)
		_PtG.append(_Pt0 + dxFlag * _XW + dyFlag * _YW);
	
	dxFlag.setReadOnly(TRUE);
	dyFlag.setReadOnly(TRUE);

//Flag
	double dF;
	if(dxFlag == 0 && dyFlag == 0)
		dF = U(1);
	PLine pl1 (_Pt0, _PtG[0]);

// display
	Display dpbd(nColor);
	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	
// show text
	dp.addViewDirection(_ZW);
	int nChange = 1;
	if (sDescription == sNoYes[1]){
		_PtG[0].vis(1);
		if ((_PtG[0] - _Pt0).dotProduct(_XW) < 0)  //vzE.crossProduct(vy)
			nChange = -1;

		int dYFlag = 3;
		
//		dp.draw (sArType1[f], _PtG[0], _XW, _YW, nChange, dYFlag, _kDeviceX); 
		dp.draw ("Lochblech", _PtG[0], _XW, _YW, nChange, dYFlag, _kDeviceX); 
		
		dYFlag = -3;
		
		dp.draw (sArType2[f], _PtG[0], _XW, _YW, nChange, dYFlag, _kDeviceX);
		
		if(dF != U(1))
			dp.draw(pl1);
	}
	
// show body
	dpbd.draw(bd);
	
// hardware
	Hardware( "Lochblech", sType1, sArticle1, dL, 0, nBd, sMaterial1, "");
	Hardware( T("Nail"), sMod2, sArticle2, dLength2, dDiameter, nNumNail1, sMaterial2, "");

// setCompareKey
	setCompareKey(String(dL) + String(dW) + String(dT) + sType + sArticle1 + sMaterial1
					+ sMod2 + sArticle2 + sMaterial2 + String(dDiameter) + String(dLength2) + nNumNail1);
	
#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0```0`!``#__@`N26YT96PH4BD@2E!%1R!,:6)R87)Y
M+"!V97)S:6]N(%LQ+C4Q+C$R+C0T70#_VP!#`%`W/$8\,E!&049:55!?>,B"
M>&YN>/6ON9'(________________________________________________
M____VP!#`55:6GAI>.N"@NO_____________________________________
M____________________________________Q`&B```!!0$!`0$!`0``````
M`````0(#!`4&!P@)"@L0``(!`P,"!`,%!00$```!?0$"`P`$$042(3%!!A-1
M80<B<10R@9&A""-"L<$54M'P)#-B<H()"A87&!D:)28G*"DJ-#4V-S@Y.D-$
M149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@X2%AH>(B8J2DY25EI>8
MF9JBHZ2EIJ>HJ:JRL[2UMK>XN;K"P\3%QL?(R<K2T]35UM?8V=KAXN/DY>;G
MZ.GJ\?+S]/7V]_CY^@$``P$!`0$!`0$!`0````````$"`P0%!@<("0H+$0`"
M`0($!`,$!P4$!``!`G<``0(#$00%(3$&$D%1!V%Q$R(R@0@40I&AL<$)(S-2
M\!5B<M$*%B0TX27Q%Q@9&B8G*"DJ-38W.#DZ0T1%1D=(24I35%565UA96F-D
M969G:&EJ<W1U=G=X>7J"@X2%AH>(B8J2DY25EI>8F9JBHZ2EIJ>HJ:JRL[2U
MMK>XN;K"P\3%QL?(R<K2T]35UM?8V=KBX^3EYN?HZ>KR\_3U]O?X^?K_P``1
M"`'P`>`#`1$``A$!`Q$!_]H`#`,!``(1`Q$`/P"E0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`*`2<`9/M0!9B@"\O@GT["I;*2)NM(H<!0(,T`)0`H&*`%
MH`3-`"9H`,4`&<4`)UH`7%`!F@`Q0`M`!0`A-`&=5D!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`#XXVD.%_.BXTKEJ.-8QQU[FHN4E8D`S0,7I0(0F@``S0`X<
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
&*`"@`/_9
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
        <int nm="BreakPoint" vl="119" />
        <int nm="BreakPoint" vl="294" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End