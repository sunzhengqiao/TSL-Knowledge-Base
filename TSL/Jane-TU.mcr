#Version 8
#BeginDescription
version value="2.16" date="27mar20" author="marsel.nakuci@hsbCAD.com"

HSB-7129: fix angle of opening for the connector 
HSB-6560: add property depthSlot, add property normal to cut slot normal with male beam, add marking line
HSB-6560: axis of rotation vz is set as _Y0.crossProduct(_Z1)
HSB-6560: part is referenced to the female beam
HSB-5097 fix some vectors
HSB-5097 connection is placed at the intersection of the 2 planes
add property "Drill Male BEam"
bugfix drill location when using female pocket






#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 16
#KeyWords Jane, angle, connector
#BeginContents

/// <summary Lang=en> //region
/// This tsl creates a simpson strongtie Jane-TU hanger
/// </summary>

/// <ExternalURL>
/// http://www.strongtie.eu/media/janetu.pdf
/// </ExternalURL>

/// <summary Lang=de>
/// Dieses TSL definiert Strongtie Jane-TU(S) Verbinder
/// </summary>

/// <summary Lang=en>
/// This tsl creates a Strongtie Jane TU(S) connector
/// </summary>

/// History
///<version value="2.16" date="27mar20" author="marsel.nakuci@hsbCAD.com"> HSB-7129: fix angle of opening for the connector </version>
///<version value="2.15" date="04mar20" author="marsel.nakuci@hsbCAD.com"> HSB-6560: add property depthSlot, add property normal to cut slot normal with male beam, add marking line </version>
///<version value="2.14" date="02mar20" author="marsel.nakuci@hsbCAD.com"> HSB-6560: axis of rotation vz is set as _Y0.crossProduct(_Z1)</version>
///<version value="2.13" date="06feb20" author="marsel.nakuci@hsbCAD.com"> HSB-6560: part is referenced to the female beam </version>
///<version value="2.12" date="30may2019" author="marsel.nakuci@hsbCAD.com"> HSB-5097 fix some vectors </version>
///<version value="2.11" date="29may2019" author="marsel.nakuci@hsbCAD.com"> HSB-5097 connection is placed at the intersection of the 2 planes </version>
///<version value="2.10" date="27may2019" author="marsel.nakuci@hsbCAD.com"> add property "Drill Male Beam" </version>
///<version value="2.9" date="10apr18" author="thorsten.huck@hsbCAD.com"> bugfix drill location when using female pocket </version>
///<version value="2.8" date="13oct16" author="thorsten.huck@hsbCAD.de"> supports multiple non paralellel female beams </version>
///<version value="2.7" date="04aug16" author="thorsten.huck@hsbCAD.de"> supports multiple female beams, slot properties reorganized and corrected </version>
///<version value="2.6" date="12may16" author="thorsten.huck@hsbCAD.de"> pocket in female beam without gap </version>
///<version value="2.5" date="12may16" author="thorsten.huck@hsbCAD.de"> new property to create a pocket in the female beam </version>
///<version value="2.4" date="09may16" author="thorsten.huck@hsbCAD.de"> Properties categorized, Hardware corrected, new property drill depth, angled connection supported </version>
/// Version 2.3   th@hsbCAD.de   22.03.2010
/// Bohrungen bei schrägen Anschlüssen korrigiert
/// Version 2.2   th@hsbCAD.de   08.12.2009
/// Lage Markierung korrigiert
/// Version 2.1   th@hsbCAD.de   23.11.2009
/// Pfostenverbindung ergänzt
/// Version 2.0   th@hsbCAD.de   09.11.2009
/// neue Eigenschaften um Lage des Verbinders anzupassen. HINWEIS: bitte prüfen Sie die Zulässigkeit einer entsprechenden Verschiebung
/// new properties to offset loaction in Y and/or Z direction. NOTE: verify technical allowance of these parameters
/// initial th 27.10.2003
//endregion
	
//region constants
// constants
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
			
	String sNoYes[] = {T("|No|"),T("|Yes|")};

	String sCategoryDisplay = T("|Display|");
	String sCategoryModel = T("|Model|");
	String sCategoryAlignment = T("|Alignment|");
	String sCategoryPocket = T("|Pocket female beam|");
	String sCategorySlot = T("|Slot|");
	
//End constants//endregion

//region get existing dim styles and order them alphabetically 
// order dimstyles
	String sDimStyles[0];sDimStyles = _DimStyles;
	String sTemps[0];sTemps = sDimStyles;
	for(int i=0;i<sTemps.length();i++)
		for(int j=0;j<sTemps.length()-1;j++)
			if (sTemps[j].makeUpper()>sTemps[j+1].makeUpper())
			{
				sTemps.swap(j,j+1);
				sDimStyles.swap(j,j+1);
			}	
	String sDimStyleName=T("|Dimstyle|");	
//End get existing dim styles and order them alphabetically //endregion
	
//region properties
	//Jane Eigenschaftslist

// MODEL
	String sTypeName=T("|Type|");	
	String sTypes[] = { "JANE-TU 12", "JANE-TU 16", "JANE-TU 20", "JANE-TU 24", "JANE-TU 28"};
	PropString sType(nStringIndex++, sTypes, sTypeName);
	sType.setDescription(T("|Defines the Type|"));
	sType.setCategory(sCategoryModel);
// TOOLING
	String sCategoryTooling = T("|Tooling|");	
	
	String sSlotClosedName=T("|bottom closed|");	
	PropString sSlotClosed(nStringIndex++,sNoYes,sSlotClosedName,1);
	sSlotClosed.setDescription(T("|Determines if the connection is visible.|"));
	sSlotClosed.setCategory(sCategorySlot);	
	//
	String sSlotNormalName=T("|Normal|");	
	PropString sSlotNormal(nStringIndex++, sNoYes, sSlotNormalName);	
	sSlotNormal.setDescription(T("|Defines if the Slot Normal with the face of the male beam|"));
	sSlotNormal.setCategory(sCategorySlot);
	
	String sEndLaps[0];
	sEndLaps = sNoYes;
	sEndLaps.append(T("|None|"));
	String sEndLapName=T("|Beam End Lap|");	
	PropString sEndLap(nStringIndex++,sEndLaps,sEndLapName,1);//kind of end joint
	sEndLap.setCategory(sCategoryTooling);	
	
	String sDrillFaces[] = { T("|Side|") + " 1",T("|Side|") + " 2"}; //Ausrichtung Stabdübelbohrung
	String sDrillFaceName=T("|Drill Face|");	
	PropString sDrillFace(nStringIndex++,sDrillFaces,sDrillFaceName);
	sDrillFace.setCategory(sCategoryAlignment );
	
	String sMarks[]={T("|Marking|"),T("|Marking and Description|"),T("|Marking and PosNum|"),T("|None|")};//sMark
	String sMarkName=T("|Marking|");	
	PropString sMark(nStringIndex++,sMarks,sMarkName);
	sMark.setDescription(T("|Sets a marking at the center of the metalpart.|"));	
	sMark.setCategory(sCategoryTooling);
	
	String sDepthFemaleName=T("|Depth|");	
	PropDouble dDepthFemale(nDoubleIndex++,0, sDepthFemaleName);	
	dDepthFemale.setDescription(T("|Defines the depth of a housing in the female beam|"));
	dDepthFemale.setCategory(sCategoryPocket );	
	
	String sGapName=T("|Gap|");	
	PropDouble dGap (nDoubleIndex++,U(20), sGapName);	
	dGap.setDescription(T("|Defines the gap|"));
	dGap.setCategory(sCategorySlot);
	
	String sTxtHName=T("|Text Height|");	
	PropDouble dTxtH(nDoubleIndex++,U(20), sTxtHName);	
	dTxtH.setDescription(T("|Defines the text height|"));
	dTxtH.setCategory(sCategoryDisplay);
	
	String sYOffsetName=T("|Y-Offset Axis|");	
	PropDouble dYOffset(nDoubleIndex++,U(0), sYOffsetName);	
	dYOffset.setCategory(sCategoryAlignment );
	
	String sZOffsetName=T("|Z-Offset Axis|");	
	PropDouble dZOffset(nDoubleIndex++,U(0), sZOffsetName);	
	dZOffset.setCategory(sCategoryAlignment );
	
	PropInt nColor(nIntIndex++,8,T("|Color|"));
	nColor.setCategory(sCategoryDisplay);
	
	PropString sDimStyle(nStringIndex++, sDimStyles, sDimStyleName);
	sDimStyle.setCategory(sCategoryDisplay);
	
	String sDepthName=T("|Drill depth|");	
	PropDouble dDepth(nDoubleIndex++, - U(15), sDepthName);
	dDepth.setDescription(T("|Defines the depth of the drill|") + " " +T("|0 = complete through|")+" " + T("|Negative value specifies remaining depth in realtion to beam dimension|"));
	dDepth.setCategory(sCategoryTooling);
	// add slot depth 
	String sDepthSlotName=T("|Depth Slot|");	
	PropDouble dDepthSlot(nDoubleIndex++, U(8), sDepthSlotName);	
	dDepthSlot.setDescription(T("|Defines the DepthSlot|"));
	dDepthSlot.setCategory(sCategoryTooling);
	
	String sDrillMaleBeamName=T("|Drill Male Beam|");
	PropString sDrillMaleBeam(nStringIndex++, sNoYes, sDrillMaleBeamName, 1);
	sDrillMaleBeam.setDescription(T("|Defines whether the male beam should be drilled or not|"));
	sDrillMaleBeam.setCategory(sCategoryModel);
	
//End properties//endregion 
	
//region parameters for each type
	double dA[] = { U(96), U(134), U(174), U(214), U(254)};
	double dB[] = { U(96), U(116), U(156), U(196), U(236)};
	double dC[] = { U(40), U(60), U(60), U(60), U(60)};
	double dDD[] = {U(102.3), U(106.8), U(106.8),U(106.8),U(106.8)};//hier vorgabewerte für stirnseitiger abstand
	double dDMPegs[] = { U(8), U(12), U(12), U(12), U(12)};
	double dSlB[] = { U(6), U(8.5), U(8.5), U(8.5), U(8.5)};
	int nPegs[] = { 4, 3, 4, 5, 6};
	int nNails[] = { 6, 18, 22, 26, 30};
	
	// standard lengths of pegs
	double dLengthPegs8[] = { U(45), U(60), U(70), U(80), U(90), U(100), U(115), U(120), U(140), U(160)};
	double dLengthPegs12[] = { U(60), U(65), U(80), U(90), U(100), U(115), U(120), U(130), U(140), U(160), U(180), U(200)};
	
	double dThickness = U(3.5);
//End parameters for each type//endregion 	
	
//region oninsert
// on insert
	if (_bOnInsert)
	{
		PropString sStretchOnInsert(7,sNoYes,T("|Stretch on insert|"),0);
		sStretchOnInsert.setDescription(T("|Determines if the male beam needs to be stretched on insert|"));
		showDialog();
		int nStretchOnInsert = sNoYes.find(sStretchOnInsert);

		Beam bmMale[0], bmFemales[0];
		PrEntity ssB(T("|Select male beams|"), Beam());
		if (ssB.go())
			bmMale=ssB.beamSet();			
		PrEntity ssFemale(T("|Select female beam(s)|"), Beam());
		if (ssFemale.go())
			bmFemales=ssFemale.beamSet();
		
		// declare the tslProps
		TslInst tslNew;
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		Beam bmAr[0];
		Entity entAr[0];
		Point3d ptAr[0];
		int nArProps[0];
		double dArProps[0];
		String sArProps[0];
		Map mapTsl;
		mapTsl.setInt("stretch",nStretchOnInsert);
		
		nArProps.append(nColor);
		
		dArProps.append(dDepthFemale);
		dArProps.append(dGap );
		dArProps.append(dTxtH);
		dArProps.append(dYOffset);
		dArProps.append(dZOffset);
		dArProps.append(dDepth);
		dArProps.append(dDepthSlot);
		
		sArProps.append(sType);				
		sArProps.append(sSlotClosed);
		sArProps.append(sSlotNormal);
		
		sArProps.append(sEndLap);		
		sArProps.append(sDrillFace);		
		sArProps.append(sMark);		
		sArProps.append(sDimStyle);
		sArProps.append(sDrillMaleBeam);

		for (int i=0; i<bmMale.length(); i++)
		{
			bmAr.setLength(0);
			Beam bm = bmMale[i];
			Vector3d vecX = bm.vecX();
			Point3d ptCen = bm.ptCenSolid();
			bmAr.append(bm);	
			Beam bmStretchTo[0];
			bmStretchTo = bmMale[i].filterBeamsCapsuleIntersect(bmFemales);
			if(bDebug)reportMessage("\n"+ scriptName() + " has found stretchTo beams " + bmStretchTo.length());
			
		// group stretch beams by connection side: this way the female side could have multiple beams
			for(int v=0;v<2;v++)
			{
			// collect females on this side				
				for (int j=0; j<bmStretchTo.length(); j++)
				{
					Point3d pt = Line(ptCen , vecX).intersect(Plane(bmStretchTo[j].ptCen(),bmStretchTo[j].vecD(vecX)),0);
					double d = vecX.dotProduct(pt - ptCen);
					if (((d>0 && v==0) || (d<0 && v==1)) && bmAr.find(bmStretchTo[j])<0)
						bmAr.append(bmStretchTo[j]);
				}

			// insert with a set of females	
				if(bDebug)reportMessage("\n"+ scriptName() + " has beamset " + bmAr.length() + " on dir " + v);
				if (bmAr.length()>1)
					tslNew.dbCreate(scriptName() , vUcsX, vUcsY, bmAr, entAr, ptAr, nArProps, dArProps, sArProps, _kModelSpace, mapTsl);
					
			}// next v
		}
		eraseInstance();
		return;
	}
//End oninsert//endregion
	
//region standards, general data
// standards
	Beam bm0;
	Beam bm1;
	Beam bmFemales[0];
	bm0 = _Beam[0];// male 
	bm1 = _Beam[1];// female
	
	// male
	Vector3d vecX = bm0.vecX();
	Vector3d vecY = bm0.vecY();
	Vector3d vecZ = bm0.vecZ();
	Point3d ptCen = bm0.ptCenSolid();
	vecX.vis(ptCen, 1);
	vecY.vis(ptCen, 3);
	vecZ.vis(ptCen, 150);
	// female
	Vector3d vecX1 = bm1.vecX();
	Vector3d vecY1 = bm1.vecY();
	Vector3d vecZ1 = bm1.vecZ();
	Point3d ptCen1 = bm1.ptCenSolid();
	vecX1.vis(ptCen1, 1);
	vecY1.vis(ptCen1, 3);
	vecZ1.vis(ptCen1, 150);
	
	// intersection line between planes at male and female beam
	// vector at male most aligned with _ZW
	Vector3d vecMaleZ = bm0.vecD(_ZW);
	Vector3d vecMalePlane = vecX.crossProduct(vecMaleZ);
	
	Vector3d vx, vy, vz;
	vx = _Z1;
	vy = vx.crossProduct(-_Z0);
	// vy need be normalized when vx and _Z0 are not normal
	vy.normalize();
	// vector in direction of intersection of 2 planes of male and female
	vz = vx.crossProduct(vy);
	
	// make it always attached to the female beam
	vx = bm1.vecD(_Z1);
	vz = _Y1;
	vy = vz.crossProduct(vx);
	// make the axis vz as _Y0x_Z1
	vz = _Y0.crossProduct(_Z1);vz.normalize();
	if (vz.dotProduct(_Y1) < 0)vz *= -1;
	vy = vz.crossProduct(vx);
	///
	
	vz.normalize();
	vx.vis(_Pt0,1);
	vy.vis(_Pt0,3);
	vz.vis(_Pt0,150);
	
// male vectors
	Vector3d vecX2 = _X0;
	Vector3d vecY2 = _Y0;
	Vector3d vecZ2 = _Z0;
//End standards, general data//endregion 

//region add grip point to move connection along the intersection line
	if(_PtG.length()<1)
	{ 
		_PtG.append(_Pt0);
	}
	
	Line ln(_Pt0, vz);
	_PtG[0] = ln.closestPointTo(_PtG[0]);
//End TitleComment//endregion 
	
	
//region collect female beams
// collect female beams
	bmFemales.append(_Beam[1]);
	for (int i=1 ; i < _Beam.length() ; i++) 
	{ 
	    Beam beam = _Beam[i]; 
	    if (!beam.vecX().isParallelTo(vx) && beam.vecD(vx).isParallelTo(vx) && bmFemales.find(beam)<0)//
			bmFemales.append(beam);
	}
//End collect female beams//endregion 

	
//region property depthFemale negative is not allowed
// validate depth female
	if (dDepthFemale<0)
	{
		reportMessage("\n" + scriptName() + ": " +T("|Negative values are not allowed for|") + " " + sCategoryPocket);
		dDepthFemale.set(0);
		setExecutionLoops(2);
		return;
	}
//End property depthFemale negative is not allowed//endregion 
	
//region trigger flip side
// TriggerFlipSide
	int bFlip = _Map.getInt("flip");
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContext, sTriggerFlipSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
	{
		String sSide = sDrillFaces[0];
		if (sDrillFace == sDrillFaces[0])sSide = sDrillFaces[1];
		sDrillFace.set(sSide);
		setExecutionLoops(2);
		return;
	}
//End trigger flip side//endregion
// ints
	int nEndLap = sEndLaps.find(sEndLap);	
	int nType= sTypes.find(sType );	
	int nMark = sMarks.find(sMark);
	int bIsSlotClosed = sNoYes.find(sSlotClosed,0);
	int bIsSlotNormal = sNoYes.find(sSlotNormal,0);
	
	
	double dDiamPeg = dDMPegs[nType];
	double dLengthPegs[0];
	if (dDiamPeg == U(8))dLengthPegs = dLengthPegs8;
	else if (dDiamPeg == U(12))dLengthPegs = dLengthPegs12;
	
	double dSlotLength = dDD[nType];

//flip side if mounting direction unsuitable
	if ( vy.dotProduct(vx) <= 0) sDrillFaces.swap(0,1);
	
//region cut/stretch for the male beam
//define Cut
	Point3d p0, p2;
	if (nEndLap  ==  2)
	{
//		p0 = _Pt0 - (U(8) - dDepthFemale) * vx;
//		p0 = _PtG[0] - (U(8) - dDepthFemale) * vx;
//		p0 = _PtG[0] - (dDepthSlot - dDepthFemale) * vx;
		p0 = _PtG[0] - (dDepthSlot) * vx;
	}
	else
	{
//		p0 = _Pt0;
		p0 = _PtG[0];
	}
	Cut ct1(p0, vx);
	//if (!_bOnDbCreated || (_bOnDbCreated && _Map.getInt("stretch")))
	bm0.addTool(ct1,1);
//End cut/stretch for the mael beam//endregion
	
//region draw the to sheets of the connection
//	Point3d ptRef = _Pt0 ;
	Point3d ptRef = _PtG[0];
	ptRef.transformBy(vz * dZOffset + vy * dYOffset + vx * dDepthFemale);
	
	//Schlitzblech, plate at the male beam
//	Point3d ptSlot = ptRef - dThickness  * vx ;
	Vector3d vecX2Hor = vecX2.crossProduct(vz);
	vecX2Hor = vecX2Hor.crossProduct(vz);
	vecX2Hor.normalize();
	double dThicknessSkew = dThickness / (vecX2Hor.dotProduct(vx));
	Point3d ptSlot = ptRef - dThicknessSkew * vecX2Hor;
	ptSlot .vis(6);
	ptRef.transformBy(0.5 * bm0.dD(vz) * vz);
	ptRef.vis(5);
//	ptSlot.vis(3);
	_PtG[0].vis(4);
	Body bd1 (ptSlot + vecX2 * .5 * dThickness , vecX2, vecY2, vecZ2, dSlotLength + .5 * dThickness, dThickness , dB[nType], - 1, 0, 0);
	
//	bd1.vis(3);
	//Grundplatte
	Body bd2 (ptSlot , vx, vy, vz, dThickness , dC[nType], dA[nType], 1, 0, 0);
	bd2.vis(1);
	_Z0.vis(_PtG[0], 2);
	bd1.vis(4);
	// rotate the body with axis of rotation at vy
	// rotation with respect to PtG[0]
	CoordSys csRotate;
	// rotation with respect to ptSlot
	CoordSys csRotateSlot;
	//rotation with respect to ptRef;
	CoordSys csRotateRef;

// angle between _Z0 and vz
	double dAngleZ0toVy = _Z0.angleTo(vz, vy);
	Vector3d vecRotVy = _Z0.crossProduct(vz);
	
//	Vector3d vecRotVy = _Y0.crossProduct(_Z1);vecRotVy.normalize();
//	vecRotVy.normalize();
//	vecRotVy.vis(_Pt0,3);
//	double dAngleZ0toVy = _Z0.angleTo(vz,vecRotVy);
	
////	csRotate.setToRotation(dAngleZ0toVy, vy, _Pt0);
//	csRotate.setToRotation(dAngleZ0toVy, vy, _PtG[0]);
//	csRotateSlot.setToRotation(dAngleZ0toVy, vy, ptSlot);
//	csRotateRef.setToRotation(dAngleZ0toVy, vy, ptRef);
	
	csRotate.setToRotation(dAngleZ0toVy, vecRotVy, _PtG[0]);
	csRotateSlot.setToRotation(dAngleZ0toVy, vecRotVy, ptSlot);
	csRotateRef.setToRotation(dAngleZ0toVy, vecRotVy, ptRef);
	
	bd1.transformBy(csRotateSlot);
	bd1.addPart(bd2);
	bd1.vis(2);
//	csRotate.setToRotation()
	
	//bd1.transformBy(vz*dZOffset+vy*dYOffset);	
//	ptRef.vis(2);
//End draw the to sheets of the connection//endregion
	
//region draw the slot, beamcut at male where the connection is entered
// Slot
	Slot sl1;Slot slNor;
	Vector3d vecX2Rot, vecY2Rot, vecZ2Rot;
	if (bIsSlotClosed) 
	{
		{ 
			vecX2Rot = vecX2; vecX2Rot.transformBy(csRotateRef);vecX2Rot.vis(ptRef);
			vecY2Rot = vecY2; vecY2Rot.transformBy(csRotateRef);vecY2Rot.vis(ptRef);
			vecZ2Rot = vecZ2; vecZ2Rot.transformBy(csRotateRef);vecZ2Rot.vis(ptRef);
			Point3d ptRefRot = ptRef; ptRefRot.transformBy(csRotateRef);//ptRefRot.vis(2);
	//		double dZ = abs(vecZ2.dotProduct(ptRef - ptSlot)) + .5 * dB[nType] + dGap / 2;
			double dZ = abs(vecZ2Rot.dotProduct(ptRef - ptSlot)) + .5 * dB[nType] + dGap / 2;
			if(!bIsSlotNormal)sl1 = Slot(ptRef, vecX2Rot,vecY2Rot,-vecZ2Rot,(dSlotLength+ U(10))*2+ dGap, U(10),dZ , 0,0,1);//bm0.dD(vecZ2) + dGap/2
	//		sl1 = Slot(ptRef , vecX2,vecY2,-vecZ2,(dSlotLength+ U(10))*2+ dGap, U(10),dZ , 0,0,1);//bm0.dD(vecZ2) + dGap/2
		}
		{ 
			// slot normal with the beam
			Vector3d vecXSlotNor = _X0;
			Vector3d vecYSlotNor = vecY2Rot;
			Vector3d vecZSlotNor = vecXSlotNor.crossProduct(vecYSlotNor);
			double dZ = abs(vecZ2Rot.dotProduct(ptRef - ptSlot)) + .5 * dB[nType] + dGap / 2;
			double dZNor = dZ * (vecZSlotNor.dotProduct(vecZ2Rot));
			double dX = (dSlotLength + U(10)) * 2 + dGap;
			double dXNor = dX *(vecZSlotNor.dotProduct(vecZ2Rot));
			dXNor += 2*sqrt(1 - (vecZSlotNor.dotProduct(vecZ2Rot)) * (vecZSlotNor.dotProduct(vecZ2Rot))) * dZ;
			if(bIsSlotNormal)sl1 = Slot(ptRef, vecXSlotNor,vecYSlotNor,-vecZSlotNor,dXNor, U(10),dZNor , 0,0,1);//bm0.dD(vecZ2) + dGap/2
		}
	}
	else
	{
		{ 
			vecX2Rot = vecX2; vecX2Rot.transformBy(csRotate);
			vecY2Rot = vecY2; vecY2Rot.transformBy(csRotate);
			vecZ2Rot = vecZ2; vecZ2Rot.transformBy(csRotate);
			Point3d ptSlotRot = ptSlot; ptSlotRot.transformBy(csRotate);vecZ2Rot.vis(ptSlotRot);
			if(!bIsSlotNormal)sl1 = Slot(ptSlotRot , vecX2Rot, vecY2Rot, vecZ2Rot, (dSlotLength + U(10)) * 2 + dGap, U(10), 0.5 * (dB[nType] + 2*bm0.dD(vz) + dGap), 0, 0, 1);
		}
		{ 
			// slot normal with the beam
			Vector3d vecXSlotNor = _X0;
			Vector3d vecYSlotNor = vecY2Rot;
			Vector3d vecZSlotNor = vecXSlotNor.crossProduct(vecYSlotNor);
			double dZ = abs(vecZ2Rot.dotProduct(ptRef - ptSlot)) + .5 * dB[nType] + dGap / 2;
			double dZNor = dZ * (vecZSlotNor.dotProduct(vecZ2Rot));
			double dX = (dSlotLength + U(10)) * 2 + dGap;
			double dXNor = dX *(vecZSlotNor.dotProduct(vecZ2Rot));
			dXNor += 2*sqrt(1 - (vecZSlotNor.dotProduct(vecZ2Rot)) * (vecZSlotNor.dotProduct(vecZ2Rot))) * dZ;
			if(bIsSlotNormal)sl1 = Slot(ptRef, vecXSlotNor,vecYSlotNor,vecZSlotNor,dXNor, U(10),dZNor*3 , 0,0,1);//bm0.dD(vecZ2) + dGap/2
		}
	}
	
	sl1.cuttingBody().vis(6);
//	slNor.cuttingBody().vis(6);
	
	bm0.addTool(sl1);
//	bm0.addTool(slNor);
//	ptRef.vis(1);
//End draw the slot, beamcut at male where the connection is entered//endregion
	
	
//region House at male beam
//Start EndLap
//	Point3d ptHs = _Pt0;
	Point3d ptHs = _PtG[0];
	// offset values
	ptHs.transformBy(vz * dZOffset + vy * dYOffset);
	// ddepthFemale values
	ptHs += vy * vy.dotProduct(ptSlot - ptHs);
	ptHs.vis(3);
	if (nEndLap==1) 
	{
		ptHs.transformBy(vz * (0.5 *bm0.dD(vz)+dZOffset));
		House hsEndLap(ptHs,vy,vz,-vx, dC[nType]+dGap, dA[nType] +  bm0.dD(vz) + dGap/2, U(10)-dDepthFemale,0,0,1);
		hsEndLap.setEndType(_kFemaleEnd);
		hsEndLap.setRoundType(_kRelief);
		_Beam0.addTool(hsEndLap);
	}
	else if (nEndLap==0)
	{
		House hsEndLap(ptHs,vy,vz,-vx, dC[nType]+dGap, dA[nType] + dGap/2 , U(10)-dDepthFemale,0,0,1);
		hsEndLap.setEndType(_kFemaleEnd);
		hsEndLap.setRoundType(_kRelief);
		_Beam0.addTool(hsEndLap);
	}
//END  EndLap

//End House at male beam//endregion 

// add pocket
	if (dDepthFemale>dEps)
	{
//		Point3d pt = _Pt0;
		Point3d pt = _PtG[0];
		
		pt.transformBy(vz * dZOffset + vy * dYOffset);
		pt += vy * vy.dotProduct(ptSlot - pt);
		
		House hs(pt, vy, vz, vx, dC[nType], dA[nType] , dDepthFemale, 0, 0, 1);
		hs.cuttingBody().vis(6);
		hs.setEndType(_kFemaleSide);
		hs.setRoundType(_kRelief);
		hs.addMeToGenBeamsIntersect(bmFemales);
	}

//region drills
	Point3d pdr, ptDrCen;
	double ddH,ddB,dDelta;
	ddH = U(26);
	ddB = U(18.3);
	dDelta = U(40);
	if (nType == 0 ) { ddB = U(15.3); ddH=U(12); dDelta = U(24);}
	Vector3d vySide = vy;
	if (sDrillFace == sDrillFaces[1])
		vySide = -vy;
//	ptDrCen=  _Pt0;
	ptDrCen = _PtG[0];
	

//	Point3d ptRef = _Pt0 ;
//	ptRef.transformBy(vz*dZOffset+vy*dYOffset+vx*dDepthFemale);	

	ptDrCen.transformBy(vz * dZOffset + bm0.vecD(vySide) * dYOffset);
//	ptDrCen.transformBy( - _X0 * (dDD[nType] + U(3.5) - ddB) + vz * (0.5 * dB[nType] - ddH + U(8)));
	ptDrCen.transformBy( - vx * (dDD[nType] + U(3.5) - ddB) + vz * (0.5 * dB[nType] - ddH + U(8)));
	
	pdr = ptDrCen;
	pdr.transformBy(vx*dDepthFemale+bm0.vecD(vySide) * (0.5* bm0.dD(vySide)+bm0.vecD(vySide).dotProduct(bm0.ptCenSolid()-pdr)));
	
//	pdr.vis(6);
//	vySide.vis(pdr,3);

// set drill depth
	double dDrillDepth = dDepth;
	if (dDrillDepth<0)	dDrillDepth += bm0.dD(vySide);
	else if (dDrillDepth==0 || dDrillDepth>bm0.dD(vySide))dDrillDepth = bm0.dD(vySide);
	
// Drills
	for (int i = 1; i <= nPegs[nType]; i++) 
	{
		Drill dr0 (pdr , pdr - bm0.vecD(vySide)* dDrillDepth, dDMPegs[nType]/2);
		//dr0.cuttingBody().vis(3);
		if(sNoYes.find(sDrillMaleBeam)==1)
		{ 
			// beam
			bm0.addTool(dr0);
		}
		// metal part
		bd1.addTool(dr0);
		pdr = pdr - vz * dDelta;
	}
//End drills//endregion	
	
// Beamcut
//	BeamCut bc0 (ptDrCen+vx*dDepthFemale+ vz * dDelta, _X0,bm0.vecD(vy),vz, dDMPegs[nType], bm0.dD(vy), U(50),0,0,-1);
	BeamCut bc0 (ptDrCen + vx * dDepthFemale + vz * dDelta, vx, vy, vz, dDMPegs[nType], bm0.dD(vy), U(50), 0, 0 ,- 1);
	ptDrCen.vis(7);
	bc0.cuttingBody().vis(5);
//	bd1.addTool(bc0);//// what is this?

// modeldescription	
	String sModelDescription;
//	double dAngle =_X0.angleTo(vx);
	// HSB-7129 angle between to faces of the connector
	double dAngle = _Y0.angleTo(_Z1, _Y0.crossProduct(_Z1));
	if (dAngle > 90)dAngle = 180 - dAngle;
	String sAngle;
	sAngle.formatUnit(dAngle,2,0);
	if (abs(dAngle)>dEps) {
		sModelDescription = "JANE-TU/S " + sType.right(2) + " " + sAngle+ "°";
		dxaout("HSBDESC2",T("BMF Nr. 343") + sType.right(2) + ".30");//Bezeichnung	
	}
	else {
		sModelDescription = sType;
		dxaout("HSBDESC2",T("BMF Nr. 343") + sType.right(2));//Bezeichnung
	}
	model(sModelDescription);
	
// compareKey	
	setCompareKey(sModelDescription);
	material(T("|Steel, zincated|"));

// get special
	int bSetSpecialNotes = projectSpecial().find("Baufritz",0)>-1;

// declare hardware comps for data export
	HardWrComp hwComps[0];	
	String sManufacturer = "StrongTie";
	
	String s1 = sModelDescription;
	HardWrComp hw(s1 , 1);	
	hw.setCategory(T("|Connectors|"));
	hw.setManufacturer(sManufacturer );
	hw.setModel(s1);
	hw.setMaterial(T("|S 250 GD +Z 275|"));
	hw.setDescription(s1);
	hw.setDScaleX(dA[nType]);
	hw.setDScaleY(dB[nType]);
	hw.setDScaleZ(dC[nType]);	
	hwComps.append(hw);
	
	HardWrComp hwScrew(T("|Screw|"), nNails[nType]);	
	hwScrew.setCategory(T("|Connectors|"));
	hwScrew.setManufacturer(sManufacturer);
	hwScrew.setModel("BMF Nr. 95540.00");
	hwScrew.setMaterial(T("|Steel|"));		
	hwScrew.setDescription(T("|Screw|") + " 40x5");
	hwScrew.setDScaleX(U(40));
	hwScrew.setDScaleY(U(5));	
	if (bSetSpecialNotes )hwScrew.setNotes("Montage");
	hwComps.append(hwScrew);	

// format peg article
	String sPegArticle = T("|Peg|");
	if (dLengthPegs.find(dDrillDepth)>-1)
	{
		sPegArticle ="STD"+(dDiamPeg*U(1)/U(1,"mm"))+"X"+(dDrillDepth*U(1)/U(1,"mm"));
		U(1,"mm");
	}
	else
		sManufacturer =T("|Custom|");
		
	HardWrComp hwPeg(sPegArticle , nPegs[nType]);	
	hwPeg.setCategory(T("|Connectors|"));
	hwPeg.setManufacturer(sManufacturer);
	hwPeg.setModel(T("|Peg|"));
	hwPeg.setMaterial(T("|S 235 JR|"));		
	hwPeg.setDescription(T("|Peg|"));
	hwPeg.setDScaleX(dDrillDepth );
	hwPeg.setDScaleY(dDMPegs[nType]);	
	if (bSetSpecialNotes )hwPeg.setNotes("Montage");
	hwComps.append(hwPeg);	
	
	_ThisInst.setHardWrComps(hwComps);
	
// Display
	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	dp.textHeight(dTxtH);
//	if (dTxtH>0)dp.draw(sModelDescription, _Pt0 + vy * 0.25 * dC[nType], vz, vy,0,0,_kDeviceX);
	if (dTxtH>0)dp.draw(sModelDescription, _PtG[0] + vy * 0.25 * dC[nType], vz, vy,0,0,_kDeviceX);
	
	dp.draw(bd1);

//sMarking
//	Point3d pM = Line(_PtG[0], _X0).intersect(_Plf, 0);
//	pM.transformBy(vz*dZOffset+vy*dYOffset);
////	Mark mrk; // default constructor
//	
//	if (nMark == 3)
//		{return;}
//	else if (nMark==0)
//	    mrk = Mark(pM, pM ,- vx);
//	else if (nMark==1)
//	    mrk = Mark(pM, pM ,- vx, sModelDescription);
//	else if (nMark==2)
//	    mrk = Mark(pM,pM,-vx,0); // 0 is index of _Beam0
//
//	for(int i=0;i<bmFemales.length();i++)
//	{
//		bmFemales[i].addTool(mrk);
//	}// next i
	
	// 
	MarkerLine mrkLine;
	Plane pn(_Pt0, _Z1);
	Line ln2(ptSlot, _X0);
	Point3d ptSlotPn = ln2.intersect(pn, 0);
//	ptSlotPn.vis(3);
	Body bd1Env = _Beam1.envelopeBody();
	PlaneProfile pp1 = bd1Env.shadowProfile(pn);
	PLine pls[] = pp1.allRings();
	if (pls.length() < 1)
	{ 
		reportMessage(TN("|unexpected error|"));
		eraseInstance();
		return;
	}
	Line ln3(ptSlotPn, vz);
	Point3d pts[] = pls[0].intersectPoints(ln3);
	if (pts.length() < 2)
	{ 
		reportMessage(TN("|unexpected error|"));
		eraseInstance();
		return;
	}
	PLine plMarking(vx);
	plMarking.addVertex(pts[0]);
	plMarking.addVertex(pts[1]);
	plMarking.vis(2);
	
	pts[0].vis(3);pts[1].vis(3);
	if (nMark == 3)
		{return;}
	else if (nMark==0)
	    mrkLine = MarkerLine (pts[0], pts[1] ,- vx);
	else if (nMark==1)
//	    mrkLine = MarkerLine (pt1Mark, pt2Mark ,- vx, sModelDescription);
	    mrkLine = MarkerLine (pts[0], pts[1] ,- vx);
	else if (nMark==2)
	    mrkLine = MarkerLine (pts[0],pts[1],-vx); // 0 is index of _Beam0

	for(int i=0;i<bmFemales.length();i++)
	{
		bmFemales[i].addTool(mrkLine);
	}// next i
	
////region Publish points to map for shopdrawing
//	Map mapRequests;
//	Map mapRequestPline;
//	mapRequestPline.setVector3d("AllowedView", _Z1);
//	mapRequestPline.setInt("AlsoReverseDirection", true);
//	
//	mapRequestPline.setPLine("pline", plMarking);
//	mapRequestPline.setInt("DrawFilled", 1);
//	mapRequestPline.setInt("color", 1);
//	mapRequests.appendMap("DimRequest", mapRequestPline);
//	_Map.setMap("DimRequest[]", mapRequests);
////End Publish points to map for shopdrawing//endregion 
#End
#BeginThumbnail
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
HT4`<G<6.NZIM6Y5%13D`LH`_+FNDLH6MK&"!B"T<84D=.!5BB@#_V3ZY
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
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO">
        <lst nm="TSLINFO" />
      </lst>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End