#Version 8
#BeginDescription
version value="1.4" date="09dec21" author="nils.gregor@hsbcad.com">HSB-13520 Bugfix search target beam in horizontal and vertical beams

Beschreibung:
Das Tsl erzeugt einen Schrägschnitt an der Büstung der Öffnung. Der Start- und Endpunkt wird durch die Innenseite des jeweils ersten Ständer mit voller Tiefe außerhalb der Öffnung festgelegt.
Sind seitlich der Öffnung Füllhölzer angebracht, beginnt die Abschrägung der Brüstung an deren Innenseite in Z-Richtung. Die Füllhölzer werden bündig mit der Abschrägung geschnitten.
Das Tsl kann manuell jeder Öffnung hinzugefügt oder an Öffnungen, sowie Elemeten in den Wandetails angeheftet werden.

Summary:
This tsl creates an angled mill at the sill plate of an opening. The start and end point is defined by the inside of the first beam with full zone 0 depth outside the opening.
If the opening contains sidewise packers. The depth is defined by the inside (in Z-direction) of the packers. The packers are stretched and cut to the angle of the sill plate.
The tsl can be used maunally by selecting openings or it can be attached to elements/ openings using the details.

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
//region <History>
// #Versions
/// <version value="1.4" date="09dec21" author="nils.gregor@hsbcad.com">HSB-13520 Bugfix search target beam in horizontal and vertical beams </version>
/// <version value="1.3" date="17nov21" author="nils.gregor@hsbcad.com"> HSB-13520  Fixed rotation of the coordinate system. 
/// <version value="1.2" date="15nov21" author="nils.gregor@hsbcad.com"> HSB-13520  Adjustments in description. 
/// <version value="1.1" date="08nov21" author="nils.gregor@hsbcad.com">HSB-13520  Adjustment of position an behavior</version>
/// <version value="1.0" date="04nov21" author="nils.gregor@hsbcad.com">HSB-13520 initial </version>

/// <insert Lang=en>
/// Select properties or catalog entry and press OK, select openings
/// </insert>

/// <summary Lang=en>
/// This tsl creates an angled mill at the sill plate of an opening. The start and end point is defined by the inside of the first beam with full zone 0 depth outside the opening.
/// If the opening contains sidewise packers. The depth is defined by the inside (in Z-direction) of the packers. The packers are stretched and cut to the angle of the sill plate.
/// The tsl can be used maunally by selecting openings or it can be attached to elements/ openings using the details.
/// </summary>

/// <summary Lang=de>
/// Das Tsl erzeugt einen Schrägschnitt an der Büstung der Öffnung. Der Start- und Endpunkt wird durch die Innenseite des jeweils ersten Ständer mit voller Tiefe außerhalb der Öffnung festgelegt.
/// Sind seitlich der Öffnung Füllhölzer angebracht, beginnt die Abschrägung der Brüstung an deren Innenseite in Z-Richtung. Die Füllhölzer werden bündig mit der Abschrägung geschnitten.
/// Das Tsl kann manuell jeder Öffnung hinzugefügt oder an Öffnungen, sowie Elemeten in den Wandetails angeheftet werden.
/// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbAngleOpeningSill")) TSLCONTENT
//endregion

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
//end Constants//endregion

	String sAngleName=T("|Angle|");	
	PropDouble dAngle(nDoubleIndex++, U(5), sAngleName);	
	dAngle.setDescription(T("|Defines the angle of the sill or sole plate milling.|"));
	dAngle.setCategory(category);
	
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(102), sDepthName);	
	dDepth.setDescription(T("|Defines the starting point of the milling in element Z-direction. If the value is 0, the depth is taken from the packers.|"));
	dDepth.setCategory(category);
	
	String sPackersAreSheetsName=T("|Packers are sheets|");	
	PropString sPackersAreSheets(nStringIndex++, sNoYes, sPackersAreSheetsName);	
	sPackersAreSheets.setDescription(T("|Select if packers are of type beam or sheet.|"));
	sPackersAreSheets.setCategory(category);
	int nPackersAreSheets = sNoYes.find(sPackersAreSheets);
		

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
			
	 // prompt for beams
	 	PrEntity ssE(T("|Select openings|"), Opening());
	 	if (ssE.go())
	 		_Entity = ssE.set();
	 	
	 	for(int i=0; i < _Entity.length(); i++)
	 	{
	 		// create TSL
 			TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
 			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {_Entity[i]};			Point3d ptsTsl[] = {_Pt0};
 			int nProps[]={};			double dProps[]={dAngle, dDepth};				String sProps[]={sPackersAreSheets};
 			Map mapTsl;	
 						
 			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
	 	}
	 	
	 	eraseInstance();
	 	return;
	}
	
	//region mapIO: support property dialog input via map on element creation
	{
		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPINT[]") && _Map.hasMap("PROPDOUBLE[]");
		if (_bOnMapIO)
		{ 
			if (bHasPropertyMap)
			{
				setPropValuesFromMap(_Map);
			}
			showDialog("---");
			_Map = mapWithPropValues();
			return;
		}
		if (_bOnElementDeleted)
		{
			eraseInstance();
			return;
		}
		else if (_bOnElementConstructed && bHasPropertyMap)
		{ 
			setPropValuesFromMap(_Map);
			_Map = Map();
		}	
	}		
//End mapIO: support property dialog input via map on element creation//endregion 

	Opening op;
	Element el;
	int bErase;
	
	//Instance can be added to elements and openings. If added to elements, the instance will be created to each opening separate.
	if(_Entity.length() > 0)
	{
		if(_Entity[0].bIsKindOf(Opening()))
		{
			op = (Opening)_Entity[0];
			el = op.element();
		}
		else if(_Entity[0].bIsKindOf(Element()))
		{
			// when triggered by element calculation
			el = (Element)_Entity[0];
			Opening ops[] = el.opening();
				
			if(ops.length() == 1)
				op = ops[0];
			else if(ops.length() > 1)
			{
		 		// create TSL
	 			TslInst tslNew;				Vector3d vecXTsl= _XW;				Vector3d vecYTsl= _YW;
	 			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};					Point3d ptsTsl[] = {_Pt0};
	 			int nProps[]={};				double dProps[]={dAngle, dDepth};	String sProps[]={sPackersAreSheets};
	 			Map mapTsl;	
 											
				for (int i=0;i<ops.length();i++) 
				{ 
					entsTsl[0]= ops[i]; 
					ptsTsl[0]=ops[i].coordSys().ptOrg();
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				}	
				
				eraseInstance();
				return;
			}
			else
				bErase = true;
		}			
	}
	else
		bErase = true;
				
// validate selection set
	if (bErase)		
	{
		//if(_Element.length() > 0)
		reportMessage("\n" + scriptName() + " " + T("|could not find reference to element.|") + T(" |Instance will be deleted.|"));
		eraseInstance();
		return;				
	}	

	// Opening and element standards
	CoordSys csOp = op.coordSys();
	Vector3d vecXOp = csOp.vecX();
	Vector3d vecYOp = csOp.vecY();
	Point3d ptOpMid = csOp.ptOrg() + 0.5 * vecXOp * op.width() + 0.5 * vecYOp * op.height();
	_Pt0 = ptOpMid;

	CoordSys cs = el.coordSys();
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	Point3d ptOrg = cs.ptOrg();
	assignToElementGroup(el,true, 0,'E');// assign to element tool sublayer
	
	Beam bmAll[] = el.beam();	

	// Wait for element calculation.
	if(bmAll.length() < 1)
		return;
		
	Beam bmVerts[] = vecY.filterBeamsPerpendicular(bmAll);
	Beam bmHors[] = vecX.filterBeamsPerpendicular(bmAll);
	
	//Find sill plate for milling.
	Beam bmsToMill[] = Beam().filterBeamsHalfLineIntersectSort(bmVerts, ptOpMid, - vecY);
	Beam bmToMill;
	
	if(bmsToMill.length() < 1)
	{
		reportMessage("\n"+scriptName()+" "+T("|No beams to mill found.|") + T(" |Instance will be deleted.|"));
		eraseInstance();
		return;		
	}
	else
	{
		bmToMill = bmsToMill.first();
	}
	
	//region Get opening studs and packers
	Point3d ptCheckSides = ptOpMid - vecZ * (vecZ.dotProduct(ptOpMid - el.zone(0).ptOrg()) - U(1));
	GenBeam gbsToCheck[0];
	Point3d ptsMill[0];
	double dBmWidth = el.dBeamWidth();
	double dMaxHeight;
	int bMessage;
	
	for(int i=0; i < 2; i++)
	{
		Vector3d vec = i == 0 ? - vecX : vecX;
		Beam bmsSide[] = Beam().filterBeamsHalfLineIntersectSort(bmHors, ptCheckSides, vec);
		
		for(int j=0; j < bmsSide.length(); j++)
		{
			Beam bm = bmsSide[j];
			double dBmH = bm.dD(vecZ);
							
			if(dBmH +dEps < dBmWidth) // || abs(vecX.dotProduct(bm.ptCen() - ptOpMid)) < 0.5* (op.width() + bm.dD(vecX)) - U(1))
			{
				gbsToCheck.append(bm);
				if(dMaxHeight < dBmH)
					dMaxHeight = dBmH;
			}
			else
			{
				ptsMill.append(bm.ptCen() - vec * 0.5 * bm.dD(vec));
				break;
			}
		}
		
		// Check if opening is at the side and has no beam at this side.
		if(i==0 && ptsMill.length() < 1 || i==1 && ptsMill.length() ==1)
		{
			ptsMill.append(bmToMill.ptCen() + vec * 0.5 * bmToMill.dL());
		}
		
		ptsMill[i].vis(i + 1);
	}
	
	if(nPackersAreSheets)
	{
		Body bdCheck(ptCheckSides - vecX * (0.5 * op.width() - U(1)), ptCheckSides + vecX * (0.5 * op.width() - U(1)), U(0.5));
		Sheet shSide[] = bdCheck.filterGenBeamsIntersect(el.sheet());
		
		for(int j=0; j < shSide.length(); j++)
		{
			Sheet sh = shSide[j];
			if(abs(vecX.dotProduct(sh.ptCen() - ptOpMid)) < 0.5* (op.width() + sh.dD(vecX)) - U(1))
			{
				double dShH = sh.dD(vecZ);
				gbsToCheck.append(sh);
				if(dMaxHeight < dShH)
					dMaxHeight = dShH;
			}
		}
	}			
	//End Get opening studs and packers//endregion 

	//Add tools to sill plate and packers.
	if(ptsMill.length() == 2)
	{
		double dZH = bmToMill.dD(vecZ) > bmToMill.dD(vecY) ? bmToMill.dD(vecZ) :  bmToMill.dD(vecY);
		double dZDir = dDepth != 0 ? dDepth : dMaxHeight;
		
		if(dDepth == 0 && dMaxHeight == 0)
		{
			reportMessage("\n"+scriptName()+" "+T("|No packers were found and depth is set to 0. Plate can not be beveled|"));
			eraseInstance();
			return;
		}
		
		if(dZDir < dEps)
		{
			bMessage = true;			
		}
		else
		{
			bmToMill.envelopeBody().vis(3);
			
			Point3d ptMillMid = ptsMill[0] + 0.5 * (ptsMill[1] - ptsMill[0]); ptMillMid.vis(6);
			Point3d ptTool = ptOpMid - vecX*vecX.dotProduct(ptOpMid - ptMillMid) - vecY*vecY.dotProduct(ptOpMid - bmToMill.ptCen())
							+ vecY * 0.5 * bmToMill.dD(vecY) + vecZ* (vecZ.dotProduct(bmToMill.ptCen() - ptOpMid) - 0.5 * bmToMill.dD(vecZ) + dZDir);
			ptTool.vis(3);
			
			double dMillLength = abs(vecX.dotProduct(ptsMill[1] - ptsMill[0])) + U(0.005);
			
			CoordSys csRot;
			csRot.setToRotation(- dAngle, vecX, cs.ptOrg());
			CoordSys csMill = cs;
			csMill.transformBy(csRot);
			BeamCut bc(ptTool, csMill.vecX(), csMill.vecY(), csMill.vecZ(), dMillLength, 2*dZH, 2*dZH,0,1,0);
			bmToMill.addToolStatic(bc);
			bc.cuttingBody().vis(2);
			
			for(int i=0; i < gbsToCheck.length(); i++)
			{
				GenBeam gb = gbsToCheck[i];
				
				//Stretch sheets, if they are packers
				if(gb.bIsKindOf(Sheet()))
				{
					Sheet sh = (Sheet)gb;
					PlaneProfile pp = sh.profShape();
					int n;
					double d;
					Point3d ptsGrip[] = pp.getGripEdgeMidPoints();
					
					for(int j=0; j < ptsGrip.length();j++)
					{
						if(vecY.dotProduct(ptsGrip[n] - ptsGrip[j]) > d)
						{
							n = j;
							d = vecY.dotProduct(ptsGrip[n] - ptsGrip[j]);
						}
					}
					
					double dDistToMove = vecY.dotProduct (ptsGrip[n] - (bmToMill.ptCen() - vecY * 0.5 * bmToMill.dD(vecY)));
					pp.moveGripEdgeMidPointAt(n, - vecY * abs(dDistToMove));
					PLine plsOut[] = pp.allRings(true, false);
					if (plsOut.length() < 1) continue;
					
					sh.setPlEnvelope(plsOut.first());
					PLine plsIn[] = pp.allRings(false, true);					
					for(int j=0; j < plsIn.length(); j++)
					{
						sh.joinRing(plsIn[j], true);
					}
					gb = sh;
				}
				
				Cut ct(ptTool, -csMill.vecY());
				gb.addToolStatic(ct, _kStretchOnToolChange);
			}			
		}
	}
	else
		bMessage = true;
	
	if(bMessage)
	{
		reportMessage("\n"+scriptName()+" "+T("|Could not detect opening posts.|") + T(" |Instance will be deleted.|"));
		eraseInstance();
		return;			
	}
	
	if(! _bOnDebug)
	{
		eraseInstance();
		return;
	}
		
	
	
	
	
	

	
	
#End
#BeginThumbnail












#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Fixed rotation of the coordinate system." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="11/17/2021 9:35:06 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13520  Adjustments in description. " />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="11/15/2021 9:43:59 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End