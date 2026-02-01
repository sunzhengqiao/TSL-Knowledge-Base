#Version 8
#BeginDescription
version value="1.1" date="16apr2020" author="david.delombaerde@hsbcad.com"
Tool selection from XML equal to hsbCLT_FreeProfile. Issue export to BVX: direction of tool has been fixed. Mirror action added to tsl so that propellertool can be mirrored to the opposite side.

This tsl creates a propeller surface tool on a beam based on one or two polylines.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <History>//region

/// <version value="1.1" date="16apr2020" author="david.delombaerde@hsbcad.com"> Tool selection from XML equal to hsbCLT_FreeProfile. Issue export to BVX: direction of tool has been fixed.
///																					   Mirror action added to tsl so that propellertool can be mirrored to the opposite side.</version>
/// <version value="1.0" date="05dec2017" author="thorsten.huck@hsbcad.com"> initial, derived from hsbCLT-PropellerTool 1.1</version>
/// </History>

/// <insert Lang=en>
/// Select entity and one or two polylines, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a propeller surface tool on a beam based on one or two polylines.
/// Polylines which are not drawn parallel to the XY-plane of the panel will be projected to the upper and lower surface
/// of the panel.
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbPropellerTool")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT

//endregion

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

//end constants//endregion

//region settings

	// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="hsbCLT-FreeProfile";
	Map mapSetting;

	// find settings file
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound;
	if (_bOnInsert)
		bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";
	String sFile=findFile(sFullPath); 
	
	// if no settings file could be found in company try to find it in the installation path.
	if (sFile.length()<1)	sFile=findFile(_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\"+sFileName+".xml");

	// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() && sFile.length()>0)
	{
		mapSetting.readFromXmlFile(sFile);
		mo.dbCreate(mapSetting);
	}		
	
//End settings//endregion

//region read settings
	
	int bHasXmlSetting;
	String sToolNames[0];
	double dDiameters[0];
	double dLengths[0];
	int nToolIndices[0];

	String k;

	Map m,mapTools= mapSetting.getMap("Tool[]");
	for (int i=0;i<mapTools.length();i++) 
	{ 
		Map m= mapTools.getMap(i);
		
		String name;
		int index, bOk=true;
		double diameter, length;
		k="Diameter";		if (m.hasDouble(k) && m.getDouble(k)>0)	diameter = m.getDouble(k);	else bOk = false;
		k="Length";			if (m.hasDouble(k) && m.getDouble(k)>0)	length = m.getDouble(k);	else bOk = false;
		k="Name";			if (m.hasString(k))	name = m.getString(k);		else bOk = false;
		k="ToolIndex";		if (m.hasInt(k))	index = m.getInt(k); 		else bOk = false;
		
		if (bOk && sToolNames.find(name)<0 && nToolIndices.find(index)<0)
		{
			sToolNames.append(name);
			nToolIndices.append(index);
			dDiameters.append(diameter);
			dLengths.append(length);
			bHasXmlSetting = true;
		}	
	}//next i
		
//End read settomgs//endregion 

//region properties
	
	// tooling
	category = T("|Tool|");
	String nToolDescription = T("|Tool|");
	PropString sToolName(nStringIndex++, sToolNames.sorted(), nToolDescription);
	sToolName.setDescription(T("|Defines the CNC Tool|"));
	sToolName.setCategory(category);
	if(sToolNames.findNoCase(sToolName, -1) < 0 && sToolNames.length() > 0)
	{ 
		sToolName.set(sToolNames.first());
		reportMessage("\n" + scriptName() + ": " +T("|Tool definition not found, changed to| "+sToolName));
	}
	
	double dMaximumDeviation = U(1);
	
//End properties//endregion 

// bOnInsert//region

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
				setPropValuesFromCatalog(sLastInserted);					
		}	
		else	
			showDialog();
		
		// prompt for beam
		_Beam.append(getBeam(T("|Select beam|")));
		
		// prompt for 1 or 2 polylines
		PrEntity ssEpl(T("|Select 1 (defining polyline) or 2 polylines (defining + bevel polyline).|"), EntPLine());	
		
		if(ssEpl.go())
		{ 
			Entity ents[] = ssEpl.set();
			for (int i=0;i<ents.length();i++) 
			{ 
				Entity ent = ents[i]; 
				EntPLine epl = (EntPLine) ent;
				if(epl.bIsValid())
				{ 
					PLine pl = epl.getPLine();
					Point3d pts[] = pl.vertexPoints(false);
					
					if (pts.length() < 2) continue;
					
					//  If first and last vertice point of pline are the same then PLine is closed.
					int bIsClosed = Vector3d(pts[0] - pts[pts.length() - 1]).length() < dEps;
					if(bIsClosed)
						reportMessage("\n" + scriptName() + ": " + T("|Closed polylines are not supported.|"));
					else
						_Entity.append(ent);	
				}
			}// next i	
		}
		
		return;
	}	
	
// end on insert	__________________//endregion	
	
//region validate selected beam
		
	if(_Beam.length() < 1)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|Invalid reference.|") + " " + T("|Tool will be deleted|"));
		eraseInstance();
		return;
	}	
	
//End validate selected beam//endregion 

//region set beam and plines
	
	// declare beam
	Beam beam = _Beam[0];
	
	// assign beam to excisting entity or group
	assignToGroups(beam, 'T');
	if (_bOnDbCreated) _ThisInst.setColor(3);
	
	// get PLines from _Entity
	PLine plines[0];
	for (int i=0; i<_Entity.length(); i++) 
	{ 
		Entity ent = _Entity[i];
		
		// setting the dependency on entity
		setDependencyOnEntity(ent);
		
		// cast instance to EntPLine, if casting not allowed EntPLine not valid
		EntPLine epl = (EntPLine)ent;
		
		if(epl.bIsValid())
		{ 
			PLine pl = epl.getPLine();
			Point3d pts[] = pl.vertexPoints(false);
			
			// no valid PLine
			if (pts.length() < 2) continue;
			
			// if first and last vertice point are equal then PLine is closed
			int bIsClosed = Vector3d(pts[0] - pts[pts.length() - 1]).length() < dEps;
			
			if (bIsClosed)
				reportMessage("\n" + scriptName() + ": " + T("|Closed polylines are not supported.|"));
			else if(pl.length() > dEps)
				plines.append(pl);

		}
		
		// only pick the first two PLines
		 if (plines.length() > 1)
		 	break;
		 	
	}//next i
	
	int bIsSingleDef;
	if(plines.length() < 1)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|Invalid reference.|") + " " + T("|Tool will be deleted|"));
		eraseInstance();
		return;	
	}
	else if (plines.length() < 2)
	{ 
		bIsSingleDef = true;
		// use a copy of the only PLIne in the array
		plines.append(plines[0]);
	}
		
//End set beam and plines//endregion 

//region setup coordsys from beam first plane
	
	// vecX - vecX from selected beam
	Vector3d vecX = _X0;
	
	// vecZ - calculated with dotproduct
	Vector3d vecZ = beam.vecD(plines[0].coordSys().vecZ());
	if(vecZ.dotProduct(plines[0].ptMid() - beam.ptCenSolid()) < 0) vecZ *= -1; 			
		
	// vecY - calculate crossproduct
	Vector3d vecY = vecX.crossProduct(-vecZ);//beam.vecY();
	// centerpoint = beam center point of solid
	Point3d ptCen = beam.ptCenSolid();
	// set the _Pt0 to ptCen
	_Pt0 = ptCen;

	// get the height of the beam
	double dZ = beam.dD(vecZ);
	
	// visualize coordSys
	vecX.vis(_Pt0,1);vecY.vis(_Pt0,3);vecZ.vis(_Pt0,150);
	
//End setup coordsys from beam first plane//endregion 

//region setup PropellerTool
	
	//region setup tool
		
		int nToolIndex = sToolNames.find(sToolName, 0);
		int nCncMode = nToolIndices[nToolIndex];
		double dDiameter = dDiameters[nToolIndex];
		double dLength = dLengths[nToolIndex];
	
		// set description of selected tool
		sToolName.setDescription(T("|Defines the CNC Tool|") + ", Ø "+dDiameter + (dLength>0?"/"+dLength:""));
		
	//End setup tool//endregion 

	//region define defining and bevel PLine  + PLine direction
		
		plines[0].vis(5);
		plines[1].vis(30);
		
		reportMessage(TN("|Area 0|" + plines[0].area() + "- |Area 1|" + plines[1].area()));
		
		
		// set biggest PLine as first in array
		if(plines[0].area() < plines[1].area())
			plines.swap(0, 1);
		
		// set defining and bevel PLine
		PLine pl1 = plines[0];	// Defining PLine
		PLine pl2 = plines[1];	// Bevel PLine
		
		Vector3d vecNormal = pl1.coordSys().vecZ();
		
		if(vecNormal.dotProduct(-vecZ) < 0)
			pl1.flipNormal();
		
		//visualize the vecnormal of the defining PLine
		pl1.coordSys().vecZ().vis(pl1.ptStart());
		
		// ensure that the plines are drawn in the same 'direction'
		Vector3d vec1 = pl1.ptEnd() - pl1.ptStart();	vec1.normalize();
		Vector3d vec2 = pl2.ptEnd() - pl2.ptStart();	vec2.normalize();
		if(vec1.dotProduct(vec2)<0)
			pl2.reverse();	
		
		vec1 = pl1.ptEnd() - pl1.ptStart();	vec1.normalize();
		vec2 = pl2.ptEnd() - pl2.ptStart();	vec2.normalize();

	//End setup PLine order + direction//endregion 

	//region PLine projection
		
		// make sure defining PLine is on surface of beam\
		int bIsProjected;
		double d1 = vecZ.dotProduct(pl1.ptMid() - ptCen);
		
		if(abs(d1) < .5 * dZ - dEps)
		{ 
			bIsProjected = true;
			pl1.projectPointsToPlane(Plane(ptCen - vecZ * .5 * dZ, vecZ), vecZ);
		}
		else if (abs(d1) > .5 * dZ - dEps)
		{ 
			bIsProjected = true;
			pl1.projectPointsToPlane(Plane(ptCen + vecZ * .5 * dZ, vecZ), vecZ);
		}
		
		// project Bevel PLine to the perpendicular face
		if(bIsSingleDef)
		{ 	
			Plane pl(pl1.ptMid(), pl1.coordSys().vecZ());	
			//pl.vis(150);
			//Vector most aligned with beam
			Vector3d vecD = beam.vecD(pl1.coordSys().vecZ());
			//vecD.vis(pl1.ptMid(), 3);	
			double distD = beam.dD(pl1.coordSys().vecZ());	
			pl2.projectPointsToPlane(Plane(pl1.ptStart() + vecD* distD, vecD), vecD);	
		}
		
		pl1.vis(4);
		pl2.vis(10);
		
	//End PLine projection//endregion 

//End setup PropellerTool//endregion 

//region Trigger Flip on other tool face
		
	String sTriggerMirror = T("|Mirror to opposite side|");
	addRecalcTrigger(_kContext, sTriggerMirror);
	if (_bOnRecalc && (_kExecuteKey == sTriggerMirror || _kExecuteKey == sDoubleClick))
	{
		// Transform the plines to otherside of the beam
		pl1.projectPointsToPlane(Plane(ptCen - vecZ * .5 * dZ, vecZ), vecZ);
		pl1.vis(20);
		
		Vector3d vecM = pl2.ptMid() - ptCen;
		double dM = vecZ.dotProduct(vecM);
		
		pl2.projectPointsToPlane(Plane(ptCen - vecZ * .5 * (dM * 2), vecZ), vecZ);
		pl2.vis(40);
		
		EntPLine entPl1;
		entPl1.dbCreate(pl1);
		
		EntPLine entPl2;
		entPl2.dbCreate(pl2);
		
		// create TSL
		TslInst tslNew;						Vector3d vecXTsl = _XW;					Vector3d vecYTsl = _YW;
		GenBeam gbsTsl[] = { _Beam[0]};		Entity entsTsl[] ={ entPl1, entPl2};			Point3d ptsTsl[] = { _Pt0};
		int nProps[] ={ };						double dProps[] ={ };						String sProps[] ={ sToolName};
		Map mapTsl;
		
		tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		
		setExecutionLoops(2);
		return;
	}
	
//End Trigger Flip on other tool face//endregion
	
//region validate default side
	
	if (_bOnDbCreated)
	{
		Body bdA = beam.envelopeBody(false, true);
		Body bdB = bdA;
		
		PLine pl3;
		pl3.addVertex(pl1.ptStart());
		pl3.addVertex(pl1.ptMid());
		
		PLine pl4;
		pl4.addVertex(pl2.ptStart());
		pl4.addVertex(pl2.ptMid());
		
		PropellerSurfaceTool tt(pl3, pl4, dDiameter, dMaximumDeviation);
		tt.setMillSide(1);
		tt.setCncMode(nCncMode);
		bdA.addTool(tt);
		
		tt.setMillSide(-1);
		bdB.addTool(tt);
		
		if (bdB.volume() < bdA.volume())
		{
			_Map.setInt("flip", true);
			setExecutionLoops(2);
			return;
		}
	}
	
	int bFlip = _Map.getInt("flip");
	int nSides[] ={ _kLeft, _kRight};
	if (bFlip)
		nSides.swap(0, 1);
	
	int nSide = nSides[0];
	
//End validate default side//endregion
	
//region execute PropellerTool
	
	PropellerSurfaceTool tt(pl1, pl2, dDiameter, dMaximumDeviation);
	tt.setMillSide(nSide);
	tt.setCncMode(nCncMode);
	beam.addTool(tt);
	
//End execute PropellerTool//endregion
	
//region display
	
	if (_bOnDbCreated) _ThisInst.setColor(3);
	Display dp(_ThisInst.color());
	
	Point3d pts1[0];
	Point3d pts2[0];
	
	// on arcs or single segments distribute evenly
	if (pts1.length() < 3 || pts2.length() < 3)
	{
		double d1 = pl1.length();
		double d2 = pl2.length();
		double d = d1 < d2 ? d1 : d2;
		int n = beam.solidLength() < U(10000) ? d / U(400) : d / U(800);
		if (n < 5) n = 5;
		d1 /= n;
		d2 /= n;
		
		pts1.setLength(0);
		pts2.setLength(0);
		for (int i = 0; i < n + 1; i++)
		{
			pts1.append(pl1.getPointAtDist(i * d1));
			pts2.append(pl2.getPointAtDist(i * d2));
		}
	}
	
	// Line over full tool  length
	for (int i = 0; i < pts1.length(); i += 2)
	{
		if (pts2.length() <= i)
			break;
			
		dp.draw(PLine(pts1[i], pts2[i]));
	}
	
	// Half line with direction marker
	for (int i = 1;i < pts1.length(); i += 2)
	{
		if (pts2.length() - 1 <= i)
			break;
		
		Vector3d vecLine(pts2[i] - pts1[i]);
				
		Point3d pt1X = pl1.getPointAtDist(pl1.getDistAtPoint(pts1[i]) + dEps);
		Vector3d vecHorLine(pt1X - pts1[i]);
		Point3d ptLineMid = pts2[i] - vecLine * .5;
		
		PLine plDirectionMark(vecLine);
		plDirectionMark.addVertex(ptLineMid);
		plDirectionMark.addVertex(ptLineMid - vecLine * .1 - vecHorLine * U(50));
		plDirectionMark.addVertex(ptLineMid - vecLine * .1 + vecHorLine * U(50));
		plDirectionMark.close();
		
		PlaneProfile profMark (plDirectionMark);
		
		dp.draw(PLine(pts1[i], ptLineMid));
		dp.draw(profMark, _kDrawFilled);
	}
	
//	dp.textHeight(U(80));
//	dp.draw("D" , pl1.ptStart(), vec1, vec1.crossProduct(vecNormal),1,0);
//	dp.draw("B" , pl2.ptStart(), vec2, vec2.crossProduct(vecNormal),1,0);
	
//End display//endregion 
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
        <int nm="BreakPoint" vl="304" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]" />
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End