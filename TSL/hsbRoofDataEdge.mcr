#Version 8
#BeginDescription
#Versions:
Version 1.9 28.10.2025 HSB-24831: Show angles for Baufritz (Markus Sailer) , Author: Marsel Nakuci
1.8 12.04.2021 HSB-11511: write level of the group in hardware group Author: Marsel Nakuci
Version 1.9 28.10.2025 HSB-24831: Show angles for Baufritz , Author: Marsel Nakuci

version value="1.7" date="15dec2020" author="marsel.nakuci@hsbcad.com" 

HSB-10119: roof valley should include the cutting of the two areas of roof planes
count type set to length
bugfix group assignment

/// This tsl determines all types of edges of all selected roofplanes and calculates the individual segment lengths
/// Edit in place mode is supported to allow individual adjustments per segment.
/// Output is supported via hardware and categorized by the key 'RoofEdge'
/// </summary>

/// <summary Lang=en>
/// Dieses TSL berechnet von den gewählten Dachflächen alle Längen und Kantentypen und stellt diese dar.
/// Der Benutzer kann in der Direktbearbeitung (Kontext, bzw. Doppelklick) jedes Segment individuell bearbeiten
/// Die Datenausgabe kann über die Verbindungsmittel erfolgen, der Kategorieschlüssel lautet 'RoofEdge'.




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 9
#KeyWords Roof,Edge
#BeginContents
/// <summary Lang=en>
/// This tsl determines all types of edges of all selected roofplanes and calculates the individual segment lengths
/// Edit in place mode is supported to allow individual adjustments per segment.
/// Output is supported via hardware and categorized by the key 'RoofEdge'
/// </summary>

/// <summary Lang=en>
/// Dieses TSL berechnet von den gewählten Dachflächen alle Längen und Kantentypen und stellt diese dar.
/// Der Benutzer kann in der Direktbearbeitung (Kontext, bzw. Doppelklick) jedes Segment individuell bearbeiten
/// Die Datenausgabe kann über die Verbindungsmittel erfolgen, der Kategorieschlüssel lautet 'RoofEdge'.
/// </summary>

/// <History>
// #Versions:
// 1.9 28.10.2025 HSB-24831: Show angles for Baufritz (Markus Sailer) , Author: Marsel Nakuci
// Version 1.8 12.04.2021 HSB-11511: write level of the group in hardware group Author: Marsel Nakuci
/// <version value="1.7" date="15dec2020" author="marsel.nakuci@hsbcad.com"> HSB-10119: roof valley should include the cutting of the two areas of roof planes </version>
/// <version value="1.6" date="22nov18" author="thorsten.huck@hsbcad.com"> count type set to length </version>
/// <version value="1.5" date="25may18" author="thorsten.huck@hsbcad.com"> bugfix group assignment </version>
/// <version value="1.4" date="05apr17" author="florian.wuermseer@hsbcad.com"> individual edge lines are assigned to the same group as the complete TSL, now (in place edit)</version>
/// <version value="1.3" date="25jan17" author="thorsten.huck@hsbcad.com"> supports and displays base angle and hip/valey angle </version>
/// <version value="1.2" date="15dec16" author="thorsten.huck@hsbcad.com"> child/parent relation to roofData-Schedule added </version>
/// <version value="1.1" date="05dec16" author="thorsten.huck@hsbcad.com"> unit bugfix </version>
/// <version value="1.0" date="22july16" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

// constants
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
	String sProjectSpecial=projectSpecial();
	sProjectSpecial.makeUpper();
	int bBaufritz=sProjectSpecial=="BAUFRITZ";
	
// categories
	String sCategoryGeneral = T("|General|");
	String sCategoryDisplay = T("|Display|");
	String sCategoryHatch = T("|Hatch|");
	String sCategoryCatalogs = T("|Catalog Entries|");
	
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
	PropString sDimStyle(nStringIndex++,sDimStyles,sDimStyleName);//0
	sDimStyle.setCategory(sCategoryDisplay);
	
	String sTxtHName=T("|Text Height|");	
	PropDouble dTxtH(nDoubleIndex++, U(30), sTxtHName);	
	dTxtH.setDescription(T("|Sets the text height|"));
	dTxtH.setCategory(sCategoryDisplay);
	
	String sUnitName = T("|Unit|");
	String sUnits[] = {"mm", "cm", "m", "inch"};
	PropString sUnit(nStringIndex++, sUnits, sUnitName,2);	//2
	sUnit.setDescription(T("|Defines the unit|"));
	sUnit.setCategory(sCategoryDisplay);
	
// predefined types
	String sTypes[] = {T("|Eave|"), T("|Verge Left|"),T("|Verge Right|"), T("|Hip|"), T("|Valley|"),
		T("|Ridge|"), T("|Rising Eave|"), T("|Mono Ridge|"), T("|Opening top|"),T("|Opening bottom|"),
		T("|Opening left|"),	T("|Opening right|"),	T("|Verfallgrat|")};
	
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		
		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(T("|_LastInserted|"));
		}
		else
			showDialog();
		
	// prompt for roofplanes
		Entity entsErps[0];
		PrEntity ssErp(T("|Select roofplane(s)"), ERoofPlane());
  		if (ssErp.go())
			_Entity=ssErp.set();
			
		return;	
	}
// END ON INSERT _______________________________________________________________________________________


// get mode
	int nMode = _Map.getInt("mode");
	// 0 = all edges
	// 1 = individual edge
	int bEdit;

// cast to roofplanes 
	ERoofPlane erps[0];
	PLine plEnvelopes[0];
	for (int i=0;i<_Entity.length();i++)
	{
		ERoofPlane erp = (ERoofPlane)_Entity[i];
		if (erp.bIsValid())
		{
			erp.removeSubMapX("Line[]");
			erps.append(erp);	
			plEnvelopes.append(erp.plEnvelope());
		}
	}
	
	if (erps.length()<1)
	{
		eraseInstance();
		return;	
	}
		
// get link to schedulate table via potential subMapX	
	Map mapX = _ThisInst.subMapX("Hsb_RoofAreaScheduleParent");
	Entity entParent;
	entParent.setFromHandle(mapX.getString("ParentUID"));
	if (bDebug && entParent.bIsValid())reportMessage("\nparent found");
	
// take unit and decimals from first tsl
// unit data
	int nUnit = sUnits.find(sUnit,0);
	double dUnitFactor = 1;
	if (nUnit ==0)	dUnitFactor =U(1)/U(1,"mm")/U(1,"mm");
	else if (nUnit ==1)	dUnitFactor =U(1)/U(1,"cm")/U(1,"mm");
	else if (nUnit ==2)	dUnitFactor =U(1)/U(1,"m")/U(1,"mm");
	else if (nUnit ==3)	dUnitFactor =U(1)/U(1,"inch")/U(1,"mm");
	U(1,"mm");	
	
// collection of all roof line segments
	Map mapLines;
	
// world cs
	CoordSys csW(_PtW,_XW,_YW,_ZW);
	Plane pnW(_PtW, _ZW);
	PlaneProfile ppProtect(csW);
	PlaneProfile ppBem[0];// HSB-24831
	
// the display
	Display dp(-1);
	dp.dimStyle(sDimStyle);
	double dYTxt = dp.textHeightForStyle("O",sDimStyle);
	dp.textHeight(dTxtH);	
	
// order by size	
	for (int i=0;i<erps.length();i++)
		for (int j=0;j<erps.length()-1;j++)
		{
			double d1 = plEnvelopes[j].area();
			double d2 = plEnvelopes[j+1].area();
			if (d1<d2)
			{
				plEnvelopes.swap(j,j+1);
				erps.swap(j,j+1);
			}
		}
	
// mode 0 ALL EDGES  ________________  ALL EDGES  ________________  ALL EDGES  ________________  ALL EDGES  ________________  ALL EDGES
if (nMode==0)
{
// collect all roofplanes
	Entity entsOther[] = Group().collectEntities(true, ERoofPlane(), _kModelSpace);
	ERoofPlane erpsAll[0];
	PLine plsOpening[0];
	for (int i=0;i<entsOther.length();i++)
	{
		ERoofPlane erp = (ERoofPlane)entsOther[i];
		if (erp.bIsValid())
			erpsAll.append(erp);
	}	
	
// find openings to each roofplane of selection set
	ERoofPlane erpsOpening[0];
	for (int x=0;x<erps.length();x++)
	{		
		ERoofPlane erp = erps[x];
		CoordSys cs = erp.coordSys();
		Vector3d vecZ = cs.vecZ();
		Point3d ptOrg = cs.ptOrg();
		PlaneProfile ppErp(erp.plEnvelope());
		for (int i=0;i<erpsAll.length();i++)
		{
			ERoofPlane erpOther = erpsAll[i];
			if (erpOther.bIsValid() && erpOther!=erp)
			{
				CoordSys cs = erpOther.coordSys();
				Point3d pt = cs.ptOrg();
				Vector3d vec=cs.vecZ();
				
			// test if coplanar
				if (!vec.isCodirectionalTo(vecZ) || abs(vecZ.dotProduct(pt-ptOrg))>dEps)continue;
				
			// test if intersecting
				PLine pl = erpOther.plEnvelope();
				PlaneProfile ppErp2(pl);
				PlaneProfile ppInt = ppErp2;
				ppInt.intersectWith(ppErp);
				double dAreaInt = ppInt.area();
				if (dAreaInt<pow(dEps,2))continue;
				double dArea1 = ppErp.area();
				double dArea2 = ppErp2.area();
				
				double d1, d2;
				if (dArea1>0) d1= dAreaInt /dArea1 ;
				if (dArea2>0) d2= dAreaInt /dArea2 ;
				
				if (d2>d1)
				{
					Map map; map.setInt("isOpening", true);
					erpOther.setSubMapX("Opening", map);
					erpsOpening.append(erpOther);
					plsOpening.append(pl);
					
					pl.transformBy(vec*U(10));
					pl.vis(2);
				}
			}	
		}// next i entsOther
	}// next x

//// append auto detected openings to selection set
	for (int x=0;x<erpsOpening.length();x++)
		if (erps.find(erpsOpening[x])<0)
			erps.append(erpsOpening[x]);

// loop roofplanes and test segment per segment on each, store collected relations
	
	for (int i=0;i<erps.length();i++)
	{
		ERoofPlane erpA = erps[i];
		CoordSys csA = erpA.coordSys();
		Vector3d vecXA = csA.vecX();
		Vector3d vecZA = csA.vecZ();
		PLine plA = erpA.plEnvelope();
		Body bd1(plA, vecZA * U(1000));
		bd1.transformBy(-vecZA * U(500));
		bd1.vis(2);
		
	// debug log
		if(bDebug)reportMessage("\nRoofplane " + erpA.roofNumber());
		
	// flag opening
		int bIsOpening = erpA.subMapX("Opening").getInt("isOpening");
		
	// planview profile as pretest
		PlaneProfile ppA(csW);
		{PLine pl=plA;	pl.projectPointsToPlane(pnW,_ZW);	ppA.joinRing(pl,_kAdd);}
		ppA.shrink(-dEps);
		//ppA.vis(i);
		
	// all A segments
		LineSeg segsA[0];
		Point3d ptsA[]=plA.vertexPoints(false);
		for(int a=0;a<ptsA.length()-1;a++)
			segsA.append(LineSeg(ptsA[a],ptsA[a+1]));			
		
		for (int j=i+1;j<erps.length();j++)
		{
			ERoofPlane erpB = erps[j];
			Vector3d vecZB = erpB.coordSys().vecZ();
			PLine plB = erpB.plEnvelope();
			Body bd2(plB, vecZB * U(1000));
			bd2.transformBy(-vecZB * U(500));
		// debug log
			if(bDebug)reportMessage("\n	Roofplane " + erpB.roofNumber());
			
		/// skip openings
			if (erpB.subMapX("Opening").getInt("isOpening"))continue;
			
		// planview profile as pretest
			PlaneProfile ppB(csW);
			{PLine pl=plB;	pl.projectPointsToPlane(pnW,_ZW);	ppB.joinRing(pl,_kAdd);}
			
			double dArea = ppB.area();
			ppBem.append(ppB);// HSB-24831
			
		// skip if not intersecting
			PlaneProfile ppI = ppB;
			if(!ppI.intersectWith(ppA))continue;	
			if (ppI.area()<pow(10*dEps,2))continue;	
			//ppB.vis(i);
			
		// all B segments
			LineSeg segsB[0];
			Point3d ptsB[]=plB.vertexPoints(false);
			for(int b=0;b<ptsB.length()-1;b++)
				segsB.append(LineSeg(ptsB[b],ptsB[b+1]));	

		// test segments one on one for certain types
			if(bDebug)reportMessage(" testing " + segsA.length() + " segments");
			for(int a=0;a<segsA.length();a++)
			{
				Body bdA(segsA[a].ptStart(),segsA[a].ptEnd(), U(1));bdA.vis(1);
				Body bdAlarge(segsA[a].ptStart(),segsA[a].ptEnd(), U(10));bdA.vis(1);
				Vector3d vecDir = segsA[a].ptEnd()-segsA[a].ptStart(); vecDir.normalize();
				Point3d ptMidA = segsA[a].ptMid();
				if (vecDir.dotProduct(_ZW)<0)vecDir*=-1;
				
			// the perp vector to the direction vec
				Vector3d vecPerpA = vecDir.crossProduct(-vecZA);
				if (PlaneProfile(plA).pointInProfile(ptMidA+vecPerpA *dEps)!=_kPointInProfile)
					vecPerpA *=-1;	
				//vecPerpA.vis(ptMidA,4);

			// count entries before
				int nCnt = mapLines.length();
				if(bDebug)reportMessage("\n		A" + a + " testing with " + segsB.length() + " B-segments");
				for(int b=0;b<segsB.length();b++)
				{
					Body bdB(segsB[b].ptStart(),segsB[b].ptEnd(), U(1));bdB.vis(2);
					Body bdBunion(segsB[b].ptStart(),segsB[b].ptEnd(), U(10));
					if (!bdB.intersectWith(bdA))continue;
					// HSB-10119:
					bdBunion.addPart(bdAlarge);
					// get the body included at two roof planes
					bdBunion.intersectWith(bd1);
					{ 
						// regenerate cylinder again
						PlaneProfile ppUnion = bdBunion.shadowProfile(Plane(segsB[b].ptStart(), vecZA));
						Vector3d vecLength = segsB[b].ptStart() - segsB[b].ptEnd();
						vecLength.normalize();
					// get extents of profile
						LineSeg seg = ppUnion.extentInDir(vecLength);
						bdBunion=Body(segsB[b].ptStart()+vecLength*vecLength.dotProduct(seg.ptStart()-segsB[b].ptStart()),
						segsB[b].ptEnd()+vecLength*vecLength.dotProduct(seg.ptEnd()-segsB[b].ptEnd()), U(10));
					}
					bdBunion.intersectWith(bd2);
					{ 
						// regenerate cylinder again
						PlaneProfile ppUnion = bdBunion.shadowProfile(Plane(segsB[b].ptStart(), vecZA));
						Vector3d vecLength = segsB[b].ptStart() - segsB[b].ptEnd();
						vecLength.normalize();
					// get extents of profile
						LineSeg seg = ppUnion.extentInDir(vecLength);
						bdBunion=Body(segsB[b].ptStart()+vecLength*vecLength.dotProduct(seg.ptStart()-segsB[b].ptStart()),
						segsB[b].ptEnd()+vecLength*vecLength.dotProduct(seg.ptEnd()-segsB[b].ptEnd()), U(10));
					}
					if(bDebug)reportMessage("\n			B " + b);
					Point3d ptMidB = segsB[b].ptMid();
					Body bdCommons[] = bdB.decomposeIntoLumps();
					Body bdunionCommons[] = bdBunion.decomposeIntoLumps();
					if(bDebug)reportMessage(", " + bdCommons.length() + " intersecting bodies");
					int iNotValley, iTypeFirst;
					for(int c=0;c<bdCommons.length();c++)
					{
						double dL = bdCommons[c].lengthInDirection(vecDir);
						if (dL>U(10))
						{
							if(bDebug)reportMessage("\n			common body c:" + c );
							Point3d ptsBd[] = bdCommons[c].intersectPoints(Line(ptMidA, vecDir));
							Vector3d vecPerpB = vecDir.crossProduct(-vecZB);
							if (PlaneProfile(plB).pointInProfile(ptMidB +vecPerpB *dEps)!=_kPointInProfile)
							vecPerpB *=-1;	
							vecPerpB.vis(ptMidB ,3);
							
							Vector3d vecZC = vecPerpA+vecPerpB;
							vecZC.normalize();
							vecZC.vis(ptMidB ,150);
							
							double dAngle = abs(vecDir.angleTo(_ZW)-90);
							double dBend = abs(vecZA.angleTo(vecZB));
						// display types
							int nType=-1;
						// ridge or hip
							if (_ZW.dotProduct(vecZC)<0)
							{
								if(vecDir.isPerpendicularTo(_ZW))
									nType=5;	// ridge				
								else	
									nType=3;	// hip
							}
						/// valley
							else
							{	
									nType=4;// valley							
							}
							iTypeFirst = nType;
							ptsBd[0].vis(3);
							ptsBd[ptsBd.length()-1].vis(3);
							double dLength_ = (ptsBd[ptsBd.length() - 1] - ptsBd[0]).length();
							if (nType>-1 && nType!=4)
							{
								vecPerpB.vis(ptMidB,3);
							
								Map m;
								m.setVector3d("vecDir", vecDir);
								m.setVector3d("vecPerpA", vecPerpA);
								m.setVector3d("vecPerpB", vecPerpB);
								m.setString("type", sTypes[nType]);
								m.setDouble("pitch", dAngle);
								m.setDouble("bend", dBend);
								m.setPoint3d("pt1", ptsBd[0]);
								m.setPoint3d("pt2", ptsBd[ptsBd.length()-1]);
								m.appendEntity("roofplane", erpA);
								m.appendEntity("roofplane", erpB);
								mapLines.appendMap("Line", m);
								
								m = erpA.subMapX("Line[]");
								m.setInt(a,true);
								erpA.setSubMapX("Line[]",m);
								
								m = erpB.subMapX("Line[]");
								m.setInt(b,true);
								erpB.setSubMapX("Line[]",m);
								iNotValley = true;
							}
						}
					}// next c
					if (iNotValley)continue;
					if (iTypeFirst != 4)continue;
					for(int c=0;c<bdunionCommons.length();c++)
					{
						double dL = bdunionCommons[c].lengthInDirection(vecDir);
						if (dL>U(10))
						{
							if(bDebug)reportMessage("\n			common body c:" + c );
							Point3d ptsBd[] = bdunionCommons[c].intersectPoints(Line(ptMidA, vecDir));
							Vector3d vecPerpB = vecDir.crossProduct(-vecZB);
							if (PlaneProfile(plB).pointInProfile(ptMidB +vecPerpB *dEps)!=_kPointInProfile)
							vecPerpB *=-1;	
							vecPerpB.vis(ptMidB ,3);
							
							Vector3d vecZC = vecPerpA+vecPerpB;
							vecZC.normalize();
							vecZC.vis(ptMidB ,150);
							
							double dAngle = abs(vecDir.angleTo(_ZW)-90);
							double dBend = abs(vecZA.angleTo(vecZB));
						// display types
							int nType=-1;
						// ridge or hip
							if (_ZW.dotProduct(vecZC)<0)
							{
								if(vecDir.isPerpendicularTo(_ZW))
									nType=5;	// ridge				
								else	
									nType=3;	// hip
							}
						/// valley
							else
							{	
									nType=4;// valley							
							}
//							ptsBd[0].vis(1);
//							ptsBd[ptsBd.length()-1].vis(1);
							double dLength_ = (ptsBd[ptsBd.length() - 1] - ptsBd[0]).length();
							if (nType==4)
							{
								vecPerpB.vis(ptMidB,3);
							
								Map m;
								m.setVector3d("vecDir", vecDir);
								m.setVector3d("vecPerpA", vecPerpA);
								m.setVector3d("vecPerpB", vecPerpB);
								m.setString("type", sTypes[nType]);
								m.setDouble("pitch", dAngle);
								m.setDouble("bend", dBend);
								m.setPoint3d("pt1", ptsBd[0]);
								m.setPoint3d("pt2", ptsBd[ptsBd.length()-1]);
								m.appendEntity("roofplane", erpA);
								m.appendEntity("roofplane", erpB);
								mapLines.appendMap("Line", m);
								
								m = erpA.subMapX("Line[]");
								m.setInt(a,true);
								erpA.setSubMapX("Line[]",m);
								
								m = erpB.subMapX("Line[]");
								m.setInt(b,true);
								erpB.setSubMapX("Line[]",m);
							}
						}
					}// next c
				}// next b
			}// next a
		}// next j of B
		
	// no connection found to another roofplane	
		Map m = erpA.subMapX("Line[]");
		//if(bDebug)reportMessage("\n"+ erpA.roofNumber() + " has lines at " + m);

		for(int a=0;a<segsA.length();a++)
		{
			String key = a;
			if (m.getInt(key)) continue;
			Vector3d vecDir = segsA[a].ptEnd()-segsA[a].ptStart(); vecDir.normalize();
			Point3d ptMidA = segsA[a].ptMid();
			if (vecDir.dotProduct(_ZW)<0)vecDir*=-1;
		
		// the perp vector to the direction vec
			Vector3d vecPerpA = vecDir.crossProduct(-vecZA);
			if (PlaneProfile(plA).pointInProfile(ptMidA+vecPerpA *dEps)!=_kPointInProfile)
				vecPerpA *=-1;	
			vecPerpA.vis(ptMidA ,2);

			int nType=-1;
		// eave, momo ridge and horizontal opening edges
			if (vecDir.isPerpendicularTo(_ZW))
			{
				double d = vecPerpA.dotProduct(_ZW);
				if (d<0 && !bIsOpening)			nType = 7;// mono ridge
				else if (d<0 && bIsOpening)	nType = 8;// opening top
				else if (d>=0 && bIsOpening)	nType = 9;// opening bottom
				else											nType = 0;// eave
			}
		// verges, openings left/right
			else
			{
				double dX = vecPerpA.dotProduct(vecXA);
				if (abs(dX)<.5)							nType = 6; // rising eave
				else if (dX>0 && !bIsOpening)	nType = 1; // left verge
				else if (dX>0 && bIsOpening)		nType = 10;// left opening	
				else if (dX<=0 && !bIsOpening)	nType = 2; // right verge
				else												nType = 11;// right opening
			}
					
		// dump data to map			
			if (nType>-1)
			{
				vecPerpA.vis(ptMidA,4);
				Map m;
				m.setVector3d("vecDir", vecDir);
				m.setVector3d("vecPerpA", vecPerpA);
				m.setString("type", sTypes[nType]);
				m.setPoint3d("pt1", segsA[a].ptStart());
				m.setPoint3d("pt2", segsA[a].ptEnd());
				m.appendEntity("roofplane", erpA);
				mapLines.appendMap("Line", m);
			}						
		}// next a	
	}// next i of A

// TriggerEditInPlace
	String sTriggerEdit = T("|Edit in place|");
	addRecalcTrigger(_kContext, sTriggerEdit );
	if (_bOnRecalc && (_kExecuteKey==sTriggerEdit || _kExecuteKey==sDoubleClick))
	{
		bEdit=true;
	}

}
// END IF mode 0 END IF ALL EDGES  ________________ END IF  ALL EDGES  ________________END IF ALL EDGES  ________________ END IF ALL EDGES  ________________ END IF  ALL EDGES
else if (nMode==1)
{
	// type property
		String sDescName=T("|Type|");	
		PropString sDesc(nStringIndex++, "", sDescName);	
		sDesc.setDescription(T("|Sets the description of the type|"));
		sDesc.setCategory(sCategoryGeneral);

	// validate grips
		if (_PtG.length()<2)
		{
			eraseInstance();
			return;	
		}

	// restore grips when _Pt0 is dragged
	// on the event of changing the _Pt0
		if (_kNameLastChangedProp == "_Pt0")
		{
			for(int i=0;i<_PtG.length();i++)
				if (_Map.hasVector3d("grip"+i))
					_PtG[i]=_PtW+_Map.getVector3d("grip"+i);
	
			setExecutionLoops(2);
			return;
		}	

	// on the event of changing one of the grips
		if (_kNameLastChangedProp.find("_PtG",0)>-1)
		{
			Point3d pts[0];
			pts=_PtG;
			int n = _kNameLastChangedProp.find("_PtG",0);
			if (n==0)
				_PtG[0] = Line(_PtG[1], _XE).closestPointTo(_PtG[0]);
			else if (n==1)
				_PtG[1] = Line(_PtG[0], _XE).closestPointTo(_PtG[1]);
				
//		disabled, takes performance	
//		// trigger parentEntity
//			if (entParent.bIsValid())
//				((TslInst)entParent).recalcNow();
				
			
			setExecutionLoops(2);
			return;
		}		

	// relocate to plane if attached to one
		double dAngle,dBend;
		Vector3d vecDir = _XE;
		if (vecDir.dotProduct(_ZW)<0)
			vecDir*=-1;			
		if (erps.length()==1)
		{
			CoordSys csA = erps[0].coordSys();
			_Pt0 = Line(_Pt0, _ZW).intersect(Plane(csA.ptOrg(), csA.vecZ()),0);	
			for(int i=0;i<_PtG.length();i++)
			{
				_PtG[i] = Line(_PtG[i], _ZW).intersect(Plane(csA.ptOrg(), csA.vecZ()),0);
				_PtG[i] =	erps[0].plEnvelope().closestPointTo(_PtG[i]);
			}
		}
		else if (erps.length()==2)
		{
			CoordSys csA = erps[0].coordSys();
			CoordSys csB = erps[1].coordSys();
			Line ln = Plane(csA.ptOrg(), csA.vecZ()).intersect(Plane(csB.ptOrg(), csB.vecZ()));
			for(int i=0;i<_PtG.length();i++)
				_PtG[i] =ln.closestPointTo(_PtG[i]);
				
			dAngle = abs(vecDir.angleTo(_ZW)-90);	
			dBend = abs(csA.vecZ().angleTo(csB.vecZ()));	
		}	
	
	// write data map
		Map m;
	
		m.setVector3d("vecDir", vecDir);
		m.setVector3d("vecPerpA", _YE);
		m.setString("type", sDesc);
		m.setPoint3d("pt1", _PtG[0]);
		m.setPoint3d("pt2", _PtG[1]);
		m.appendEntity("roofplane", erps[0]);
		
	// set pitch of line
		if (dAngle>dEps)
			m.setDouble("pitch", dAngle);
	// set bend angle of line
		if (dBend>dEps)
			m.setDouble("bend", dBend);		
		mapLines.appendMap("Line", m);
	
	
	// store grips absolute
		for(int i=0;i<_PtG.length();i++)
			_Map.setVector3d("grip"+i, _PtG[i]-_PtW);
	
	//dp.draw(scriptName(), _Pt0, _XE,_YE,0,1.2,_kDevice);
	
}
// END IF mode == 1________________________________________________________________________________________________________________


// read data, dump to hardware, display or create individual instances
	HardWrComp hwcs[0];
	Map mapAddEnts;
	Point3d ptAngleKehle[0];
	Point3d ptAngleFirst[0];
	Point3d ptCenA[0];
	PLine plDirection[0];
	
	for(int i=0;i<mapLines.length();i++)
	{
		Map m=mapLines.getMap(i);
		Vector3d vecDir = m.getVector3d("vecDir");vecDir .normalize();
		Vector3d vecPerpA = m.getVector3d("vecPerpA");
		Vector3d vecPerpB = m.getVector3d("vecPerpB");
		String sType = m.getString("type");
		Point3d pt1 = m.getPoint3d("pt1");
		Point3d pt2 = m.getPoint3d("pt2");
		Point3d ptMid = (pt1+pt2)/2;
		double dPitch = abs(m.getDouble("pitch"));
		double dBend = abs(m.getDouble("bend"));
	
	// create individual instances and continue if in edit creation mode
		if (bEdit) 
		{
		
			Group groups[] = _ThisInst.groups();
		
		// prepare tsl cloning
			TslInst tslNew;
			Vector3d vecXTsl= vecDir;
			Vector3d vecYTsl= vecPerpA;
			GenBeam gbsTsl[] = {};
			Entity entsTsl[0];// = {};
			Point3d ptsTsl[] = {ptMid, pt1, pt2};
			int nProps[]={};
			double dProps[]={dTxtH};
			String sProps[]={sDimStyle,sUnit, sType };
			Map mapTsl;	
			mapTsl.setInt("mode",1);
			if (!vecPerpA.bIsZeroLength()) mapTsl.setVector3d("vecPerpA",vecPerpA);
			if (!vecPerpB.bIsZeroLength()) mapTsl.setVector3d("vecPerpB",vecPerpB);
			String sScriptname = scriptName();

			for(int j=0;j<m.length();j++)
				if (m.hasEntity(j))
				{
					Entity ent =  m.getEntity(j);
					ERoofPlane erp = (ERoofPlane)ent;
					if (erp.bIsValid())entsTsl.append(erp);
				}
			
			tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);
			
			if (tslNew.bIsValid() && groups.length()>0)
				groups[0].addEntity(tslNew);
					
		// store mapX link to a potential schedule
			if (tslNew.bIsValid())
			{
				mapAddEnts.appendEntity("AddArea", tslNew);
			}		
			continue;
			
		}

	// the length
		double dX = (pt1-pt2).length();
	
	// hardware
		HardWrComp hw(sType , 1);	
		hw.setName(sType);
		hw.setCategory("RoofEdge");
		hw.setDScaleX(dX);
		hw.setDAngleA(dPitch);
		hw.setDAngleB(dBend);
		hw.setCountType(_kCTLength);
		String sHWGroupName;
	// HSB-11511: set group name
		{ 
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	
			{
	//			sHWGroupName=groups[0].name();
				sHWGroupName=groups[0].namePart(1);
			}
		}
		hw.setGroup(sHWGroupName);
		hwcs.append(hw);
	
	// string builder
		String sTxt;
	
	// get pitch
		String sPitch;
		if (dPitch>0)
		{
			sPitch.formatUnit(dPitch, 2,1);
			sPitch = " "+sPitch+"°";
		}
	// get bend angle
		String sBend;
		if (dBend>0)
		{
			sBend.formatUnit(dBend, 2,1);
			sBend = "/"+sBend+"°";
		}
		
		// metric
		if (nUnit<3)
		{
			sTxt.formatUnit(dX*dUnitFactor, 2,nUnit);
			sTxt=sType +"("+sTxt+sUnit+sPitch+sBend+")";
		}
		// imperial
		else	
		{
			sTxt.formatUnit((pt1-pt2).length()*dUnitFactor, 4,0);
			sTxt=sType +"("+sTxt+sPitch+dBend+")";
		}
		
		if(bBaufritz)
		{ 
			// HSB-24831
			Point3d ptMidAngle = ptMid;
			Point3d ptMidStart =pt2;
			if(sType=="Kehle")
			{
				ptAngleKehle.append(ptMidAngle);
				ptCenA.append(ptMidStart);
			}
			
			if(sType=="First")
			{ 
				ptAngleFirst.append(ptMidAngle);
				PLine plFirst(pt1, pt2);
				plDirection.append(plFirst);
			}
		}
	
	// location
		Point3d ptLoc= ptMid;
		if (nMode==1) ptLoc = _Pt0;

	// box builder
		double dXTxt = dp.textLengthForStyle(sTxt,sDimStyle);
		if (abs(dYTxt-dTxtH)>dEps && dYTxt > 0)
		{	
			double f = dTxtH/dYTxt;	
			dYTxt =dTxtH;
			dXTxt *=f;
		}
		PLine pl;
		LineSeg seg(ptLoc -.5*(vecDir*dXTxt),ptLoc +.5*(vecDir*dXTxt)+vecPerpA*dYTxt);
		pl.createRectangle(seg,vecDir,vecPerpA );
		pl.vis(2);


	// test interference
		
		if (ppProtect.area()>pow(dEps,2))
		{
			Vector3d vec = vecDir;
			double dDelta = dTxtH*.5;//
			Point3d ptLocTest=ptLoc;
			PlaneProfile ppAdd(pl);
			PlaneProfile ppTest =ppProtect;
			
			ppTest.intersectWith(ppAdd);
			int nCnt;
			CoordSys csMirr; csMirr.setToMirroring(Plane(seg.ptMid(), vec));
			CoordSys csRot; csRot.setToRotation(22.5, _ZW, ptLoc);		
			
			while(ppTest.area()>pow(dEps,2) && nCnt<100)
			{
			// polar offset 
				int bOk;
				for (int r=0; r<16;r++)
				{
					ppAdd.transformBy(vec*dDelta);
					ptLocTest.transformBy(vec*dDelta);
					ppTest=ppProtect;
					ppTest.intersectWith(ppAdd);	
					//if (bDebug){ Display dpDebug(nCnt);dpDebug.draw(ppAdd);}					
					if (ppTest.area()<pow(dEps,2)) 
					{
						bOk=true;
						break;	
					}
					ppAdd.transformBy(-vec*dDelta);
					ptLocTest.transformBy(-vec*dDelta);								
					vec.transformBy(csRot);															
				}	
				if (bOk)break;
				dDelta += dTxtH*.5;
				nCnt++;
			}
			ptLoc=ptLocTest;
			ppProtect.unionWith(ppAdd);			
		}
		else
			ppProtect.joinRing(pl,_kAdd);
		
		dp.draw(sTxt,ptLoc, vecDir, vecPerpA,0,1.5,_kDevice);	
			
	}// next i
	
	if(bBaufritz)
	{ 
		// HSB-24831
		for (int p=0;p<ppBem.length();p++) 
		{ 
			ppBem[p].shrink(-2);
			Point3d ptCent;
			Point3d ptXLine1;
			Point3d ptXLine2;
			Point3d ptFirst = ptAngleFirst[0];
			Point3d ptMidFirst;
			CoordSys csF = plDirection[0].coordSys();
			Vector3d vecX = csF.vecX();
				
			for (int i = 0; i < ptAngleKehle.length(); i++)
			{
				if (ppBem[p].pointInProfile(ptAngleKehle[i]) == _kPointInProfile)
				{
					ptCent = ptCenA[i];
					ptXLine1 = ptAngleKehle[i];
					ptFirst.transformBy(vecX*vecX.dotProduct(ptCent-ptFirst));
					ptMidFirst = (ptFirst+ptCent)/2;
					
				}
			}
			
			for (int i=0;i<ptAngleFirst.length();i++) 
			{
				if (ppBem[p].pointInProfile(ptAngleFirst[i])==_kPointInProfile)
				{ 
					ptXLine2 = ptAngleFirst[i];
				}
			}//next i
			
			PLine plPoint(ptXLine1, ptXLine2);
			Point3d ptArc = plPoint.ptMid();
			Point3d ptArc1 = (ptXLine1+ptMidFirst)/2;
			
			if(vecX.X()==1)
			{ 
				if(ptXLine1.X()>ptXLine2.X() && ptXLine1.Y()<ptXLine2.Y() || ptXLine1.X()<ptXLine2.X() && ptXLine1.Y()>ptXLine2.Y() )
				{ 
					DimAngular dimAng(ptCent, ptXLine1, ptXLine2, ptArc);
					dp.draw(dimAng);
				}
				
				if(ptXLine1.X()>ptXLine2.X() && ptXLine1.Y()>ptXLine2.Y() || ptXLine1.X()<ptXLine2.X() && ptXLine1.Y()<ptXLine2.Y())
				{ 
					DimAngular dimAng(ptCent, ptXLine2, ptXLine1, ptArc);
					dp.draw(dimAng);
				}
				
				if(ptXLine1.X()>ptXLine2.X() && ptXLine1.Y()<ptXLine2.Y() || ptXLine1.X()<ptXLine2.X() && ptXLine1.Y()>ptXLine2.Y() )
				{ 
					DimAngular dimAng1(ptCent,ptMidFirst,ptXLine1,ptArc1);
					dp.draw(dimAng1);
				}
				
				if(ptXLine1.X()>ptXLine2.X() && ptXLine1.Y()>ptXLine2.Y() || ptXLine1.X()<ptXLine2.X() && ptXLine1.Y()<ptXLine2.Y())
				{ 
					DimAngular dimAng1(ptCent,ptXLine1,ptMidFirst,ptArc1);
					dp.draw(dimAng1);
				}
			}
			else
			{ 
				if(ptXLine1.X()>ptXLine2.X() && ptXLine1.Y()<ptXLine2.Y() || ptXLine1.X()<ptXLine2.X() && ptXLine1.Y()>ptXLine2.Y() )
				{ 
					DimAngular dimAng(ptCent, ptXLine2, ptXLine1, ptArc);
					dp.draw(dimAng);
				}
				
				if(ptXLine1.X()>ptXLine2.X() && ptXLine1.Y()>ptXLine2.Y() || ptXLine1.X()<ptXLine2.X() && ptXLine1.Y()<ptXLine2.Y())
				{ 
					DimAngular dimAng(ptCent, ptXLine1, ptXLine2, ptArc);
					dp.draw(dimAng);
				}
				
				if(ptXLine1.X()>ptXLine2.X() && ptXLine1.Y()<ptXLine2.Y() || ptXLine1.X()<ptXLine2.X() && ptXLine1.Y()>ptXLine2.Y() )
				{ 
					DimAngular dimAng1(ptCent, ptXLine1, ptMidFirst, ptArc1);
					dp.draw(dimAng1);
				}
				
				if(ptXLine1.X()>ptXLine2.X() && ptXLine1.Y()>ptXLine2.Y() || ptXLine1.X()<ptXLine2.X() && ptXLine1.Y()<ptXLine2.Y())
				{ 
					DimAngular dimAng1(ptCent, ptMidFirst, ptXLine1, ptArc1);
					dp.draw(dimAng1);
				}
			}
		}//next p
	}
	
// erase if in edit mode 0
	if (bEdit && nMode==0)
	{
	// trigger parent
		if (entParent.bIsValid() && entParent.bIsKindOf(TslInst()) && mapAddEnts.length()>0)
		{
			if(bDebug)reportMessage("\n"+ scriptName() + " appends " + mapAddEnts.length() + "childs to " + entParent.handle());
			
			TslInst tsl =(TslInst)entParent;
			Map map = tsl.map();
			map.setMap("AddArea[]", mapAddEnts);
			tsl.setMap(map);
			tsl.transformBy(Vector3d(0,0,0));
		}
	
		eraseInstance();
		return;	
	}	
	_ThisInst.setHardWrComps(hwcs);							



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
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BJDVI65O?VUA-<QI=W6[R82WS/M
M!)('H`.M6Z`"BBB@`HHHH`***J6.I66II,]C<QW"0RF&1HSD!QC(S[9%`%NB
MBB@`HHHH`****`"BBB@`HHHH`**:S*B%G8*H&22<`4D<B2QK)&=R,,J?44`/
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHKC/''BK^RK8Z?92?Z;*/G8?\LE/]3V_/TK*M6C1@YR-\/AYXBHJ<-V
M0Z]\0X]-U&2SL;9+GR^'D+X&[N!ZXKGKWXIZI#`T@MK.-1T^5B?YURMI:SWM
MU';6T;232-A5'4US6L_:(]3GM+A#&]O(T90]B#@UX4,5B:TF[V7]:'UU/+,'
M32@XIR\_S/H;P1X@?Q+X8@OY]GVC>\<P08`8'C_QTJ?QK4UNZELM`U&[@(6:
M"UED0D9`95)'\J\H^"^K^5J%_H[M\LR">('^\O##\01_WS7J/B;_`)%36/\`
MKQF_]`->[AY<\$SY;,:'L,1**VW7S/GSX7:C>:K\7-/O+^YDN;F03%Y)&R3^
MZ?\`3VKZ8KY&\!^(+7PMXOL]8O(II8(%D#)"`6.Y&48R0.I'>O3;G]H)!,1:
M^'6:+LTMWM8_@%./SKMJP<I:(\BC4C&/O,]LHKA_!'Q.TKQI,UFD,EEJ"KO^
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
G`<G<6.NZIM6Y5%13D`E0!^7-=+9PM;6,$#D%HXPI(Z<"IZ*`/__9
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
        <int nm="BreakPoint" vl="540" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24831: Show angles for Baufritz (Markus Sailer)" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="10/28/2025 9:39:51 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11511: write level of the group in hardware group" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="4/12/2021 8:20:03 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End