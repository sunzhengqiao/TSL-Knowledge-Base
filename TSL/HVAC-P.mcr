#Version 8
#BeginDescription
version value="1.0" date="08aug2018" author="thorsten.huck@hsbcad.com"
initial

This tsl splits a duct beam or connects two beams.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <History>//region
/// <version value="1.0" date="08aug2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select one or two beams to split or connect the selected beam(s)
/// </insert>

/// <summary Lang=en>
/// This tsl splits a duct beam or connects two beams.
/// </summary>//endregion


/// commands
// command to insert and assign
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "HVAC-P")) TSLCONTENT

// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));
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
	//endregion

// bOnInsert//region
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();

//		if (sKey.length()>0)
//		{
//			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
//			for(int i=0;i<sEntries.length();i++)
//				sEntries[i] = sEntries[i].makeUpper();	
//			if (sEntries.find(sKey)>-1)
//				setPropValuesFromCatalog(sKey);
//			else
//				setPropValuesFromCatalog(sLastInserted);					
//		}	
//		else	
//			showDialog();
		
		while(1)
		{ 
		// prompt for beams
			Beam beams[0];
			PrEntity ssE(T("|Select 2 beam(s) to connect or 1 beam to split|"), Beam());
			if (ssE.go())
			{
				Point3d pt;
				beams.append(ssE.beamSet());
				if(beams.length()<1)
				{
					break;
				}
			// split mode
				else if (beams.length()==1)
				{ 
					pt = getPoint(T("|Select split location|"));
					Beam bm = beams[0].dbSplit(pt, pt);
					beams.append(bm);				
				}
				else
				{ 
					Beam bm0 = beams[0];
					Beam bm1 = beams[1];

					Point3d ptCen0 = bm0.ptCenSolid();
					Vector3d vecX0 = bm0.vecX();
					Point3d ptCen1 = bm1.ptCenSolid();
					Vector3d vecX1 = bm1.vecX();
					
					double dX0 = bm0.solidLength();
					double dX1 = bm1.solidLength();

				// validate if parallel
					if (!vecX0.isParallelTo(vecX1))
					{ 
						reportMessage("\n" + scriptName() + ": " +T("|beams are not parallel|"));
						continue;
					}

				// get connection vector based on bm0
					Vector3d vecX = vecX0;
					if (vecX.dotProduct(ptCen1-ptCen0)<0)
						vecX *= -1;
					
					Point3d ptStart = ptCen0 + vecX * .5 * dX0;
					Point3d ptEnd = ptCen1 - vecX * .5 * dX1;					
					pt = (ptStart + ptEnd) / 2;
					
				}
					

			// create TSL
				TslInst tslNew;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {pt};
				int nProps[]={};			double dProps[]={};				String sProps[]={};
				Map mapTsl;	
				
				gbsTsl.append(beams[0]);
				gbsTsl.append(beams[1]);
											
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);				

			}
			else
				break;
				

				
				
		}
		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion

// validate beams
	if (_Beam.length()<2)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|invalid selection set.|"));
		eraseInstance();
		return;
	}
	setEraseAndCopyWithBeams(_kBeam01);
	
// the beams
	Beam bm0 = _Beam[0];
	Beam bm1 = _Beam[1];
	Point3d ptCen0 = bm0.ptCenSolid();
	Vector3d vecX0 = bm0.vecX();
	Vector3d vecY0 = bm0.vecY();
	Vector3d vecZ0 = bm0.vecZ();
	double dX0 = bm0.solidLength();
	Quader qdr(ptCen0, vecX0, vecY0, vecZ0, U(1), U(1), U(1), 0, 0, 0);
	
	Line ln(ptCen0, vecX0);
	_Pt0 = ln.closestPointTo(_Pt0);
	assignToGroups(bm0, 'Z');
	
	Point3d ptCen1 = bm1.ptCenSolid();
	Vector3d vecX1 = bm1.vecX();
	Vector3d vecY1 = bm1.vecY();
	Vector3d vecZ1 = bm1.vecZ();	
	double dX1 = bm1.solidLength();


// get max dimensions
	double dMax0 = bm0.dH() > bm0.dW() ? bm0.dH() : bm0.dW();
	double dMax1 = bm1.dH() > bm1.dW() ? bm1.dH() : bm1.dW();
	double dMax = dMax0 > dMax1 ? dMax0 : dMax1;
// validate if parallel
	if (!vecX0.isParallelTo(vecX1))
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|beams are not parallel|"));
		eraseInstance();
		return;
	}

// get connection vector based on bm0
	Vector3d vecX = vecX0;
	Vector3d vecY = vecY0;
	if (vecX.dotProduct(ptCen1-ptCen0)<0)
	{
		vecX *= -1;
		vecY *= -1;
	}
	Vector3d vecZ = vecX.crossProduct(vecY);
	
// get max section
	double dY0 = bm0.dD(vecY);
	double dZ0 = bm0.dD(vecZ);
	double dY1 = bm1.dD(vecY);
	double dZ1 = bm1.dD(vecZ);
	double dMaxY = dY0>dY1?dY0:dY1;
	double dMaxZ = dZ0>dZ1?dZ0:dZ1;
	
// erase duplicates
	Entity tents[] = bm0.eToolsConnected();
	for (int i=0;i<tents.length();i++) 
	{ 
		TslInst tsl= (TslInst)tents[i];
		if (tsl.bIsValid() && tsl.scriptName()==scriptName())
		{ 
			Beam beams[]=tsl.beam();
			if (beams.find(bm0)>-1 && beams.find(bm1)>0 && tsl!=_ThisInst)
			{ 
				reportMessage("\n" + T("|Removing dupliacte of| ") + scriptName());
				eraseInstance();
				return;
			}
		}
	}//next i

// check if axis offset is too big
	double dOffsetY = abs(vecY0.dotProduct(ptCen1 - ptCen0));
	double dOffsetZ = abs(vecZ0.dotProduct(ptCen1 - ptCen0));
	
	if (dOffsetY>dMax || dOffsetZ>dMax)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|beams are not in line|"));
		eraseInstance();
		return;		
	}
	

// get round state
// collect round
	int bIsRound0 = bm0.extrProfile() == _kExtrProfRound;
	int bIsRound1 = bm1.extrProfile() == _kExtrProfRound;	
	int bDrawAsLinework = !bm1.isVisible();

// straight connection if section is identical
	double dReductionLength;
	if (abs(dY0-dY1)<dEps && abs(dZ0-dZ1)<dEps)
	{
	// Trigger Join//region
		String sTriggerJoin = T("|Join|");
		addRecalcTrigger(_kContext, sTriggerJoin );
		if (_bOnRecalc && (_kExecuteKey==sTriggerJoin || _kExecuteKey==sDoubleClick))
		{
			bm0.dbJoin(bm1);
			eraseInstance();
			return;
		}//endregion	
	
	}
	else
		dReductionLength = dMax0 + dMax1;
	
// add cuts
	Point3d ptStart = _Pt0 - vecX * .5 * dReductionLength;
	Point3d ptEnd = _Pt0 + vecX * .5 * dReductionLength;
	Cut ct0(ptStart, vecX);
	Cut ct1(ptEnd, -vecX);
	bm0.addTool(ct0,_kStretchOnToolChange);
	bm1.addTool(ct1,_kStretchOnToolChange);
	
	
// Display
	int bOk = dOffsetY <= dMax && dOffsetZ <= dMax;
	int nColor = bOk?bm0.color():(bm0.color()==1?6:1);
	//nColor = _ThisInst.color();
	Display dpModel(nColor), dpPlan(nColor);
	if(!bDrawAsLinework && bOk)
	{
		dpPlan.addViewDirection(_ZW);
		dpModel.addHideDirection(_ZW);
	}	
	
// reduction display
	if(dReductionLength>dEps)
	{ 
		Body bd;
		if (bIsRound0 && bIsRound1)
			bd=Body(_Pt0 - vecX * .5 * dReductionLength,_Pt0 + vecX * .5 * dReductionLength, dMax0*.5, dMax1*.5);	// draw a cone
		else
		{
			bd = Body(_Pt0, vecX, vecY, vecZ, dReductionLength, dMaxY, dMaxZ, 0, 0, 0);
			if (abs(dY0-dY1)>dEps)
			{ 
				Vector3d vecYC = vecY;
				for (int i=0;i<2;i++) 
				{ 
					Point3d pt0 = ptStart - vecYC * .5 * dY0;
					Point3d pt1 = ptEnd - vecYC * .5 * dY1;
					Vector3d vecXC = pt1 - pt0;
					vecXC.normalize();
					vecYC = vecXC.crossProduct(-vecZ);	
					if (bm0.vecD(vecYC).dotProduct(ptCen0-pt0) > 0)	vecYC *= -1;
					//vecYC.vis(pt0, i);
					bd.addTool(Cut(pt0, vecYC), 0);	
					vecYC = -vecY;
				}//next i
			}
			if (abs(dZ0-dZ1)>dEps)
			{ 
				Vector3d vecZC = vecZ;
				for (int i=0;i<2;i++) 
				{ 
					Point3d pt0 = ptStart - vecZC * .5 * dZ0;
					Point3d pt1 = ptEnd - vecZC * .5 * dZ1;
					Vector3d vecXC = pt1 - pt0;
					vecXC.normalize();
					vecZC = vecXC.crossProduct(vecY);
					if (bm0.vecD(vecZC).dotProduct(pt0-ptCen0) > 0)vecZC *= -1;
					bd.addTool(Cut(pt0, vecZC), 0);	
					vecZC = -vecZ;
				}//next i
			}			
		}

		dpModel.draw(bd);
		dpPlan.draw(bd.shadowProfile(Plane(ptCen0,qdr.vecD(_ZW))));
	}
	else
	{ 
		PLine pl(_Pt0 - vecX * .5 * dMax, _Pt0 + vecX * .5 * dMax);
		dpPlan.draw(pl);
		dpModel.draw(pl);
	}
	
// publish connection points
	Point3d ptConnects[] ={ ptStart, ptEnd};
	if (dReductionLength>0)
		_Map.removeAt("ptConnect[]",true);		
	else
		_Map.setPoint3dArray("ptConnect[]", ptConnects);	
	
	


	
#End
#BeginThumbnail
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
%S10!_]F/
`

#End
#BeginMapX

#End