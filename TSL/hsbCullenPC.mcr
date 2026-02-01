#Version 8
#BeginDescription
version value="1.6" date="03.feb.20" author="marsel.nakuci@hsbcad.com" 

HSB-5434: load the block from company folder if not found in this dwg 
HSB-5434: add trigger to swap TSL in xy 
HSB-5434: fix bug at hardware export 
HSB-5434: if found use the block for the display 
HSB-5434: double instead of int 
panel closer add hardware
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords cullen, panel, closer, pc, kingspan
#BeginContents
/// <History>//region
/// <version value="1.6" date="03.feb.20" author="marsel.nakuci@hsbcad.com"> HSB-5434: load the block from company folder if not found in this dwg </version>
/// <version value="1.5" date="29.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5434: add trigger to swap TSL in xy </version>
/// <version value="1.4" date="29.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5434: fix bug at hardware export </version>
/// <version value="1.3" date="28.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5434: if found use the block for the display </version>
/// <version value="1.2" date="27.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5434: double instead of int </version>
/// <version value="1.1" date="25.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5434: panel closer add hardware </version>
/// <version value="1.0" date="24.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5434: initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates cullen panel closer TSL for 2 genbeams
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCullenPC")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|swap X-Y|") (_TM "|select the  hsbCullenPC TSL|"))) TSLCONTENT
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
	
	
//region properties
	
	double dLPart = U(180);
	double dWPart = U(85);
	double dThicknessPart = U(1.2);
	
	String sProduct = "PWS-";
	String sProductCodes[0];
	
	sProductCodes.append(sProduct + "200");
	sProductCodes.append(sProduct + "240");
	
//	String sProductCodeName=T("|Product Code|");	
//	PropString sProductCode(nStringIndex++, sProductCodes, sProductCodeName);	
//	sProductCode.setDescription(T("|Defines the Product Code|"));
//	sProductCode.setCategory(category);
	
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
//		else	
//			showDialog();
		
		// prompt the selection of genbeams
		int iCount = 0;
		while (iCount < 20)
		{ 
			// prompt the genBeam selection
			Entity ents[0];
			GenBeam gBeams[0];
			PrEntity ssE(T("|Select genBeam(s)|"), GenBeam());
			if (ssE.go())
				ents.append(ssE.set());
				
			if (ents.length() < 2)
			{ 
				reportMessage(TN("|Select at least two genBeams (beam, sheet or panel)|"));
				eraseInstance();
				return;
			}
			
			// get point (grip point needed to define the position of the connector)
			Point3d pt = getPoint(TN("|Select the Point|"));
			
			// initialize _Pt0 with pt
			_Pt0 = pt;
			iCount++;
			
			// create TSL
			TslInst tslNew;			Vector3d vecXTsl = _XW;	Vector3d vecYTsl = _YW;
			GenBeam gbsTsl[] = { };	Entity entsTsl[] = { };	Point3d ptsTsl[] = { _Pt0, pt};
			int nProps[]={};		double dProps[]={};	String sProps[]={};
			Map mapTsl;
			
			// pass on the properties
			
			// set map
			_Map.setInt("iSide", 1);
			
			for (int i = 0; i < ents.length(); i++)
			{ 
				GenBeam gb = (GenBeam) ents[i];
				if (gb.bIsValid())
				{ 
					gbsTsl.append(gb);
				}
				if (gbsTsl.length() == 2)
				{ 
					// 2 genBeams found, dont append any more
					break;
				}
			}//next i
			tslNew.dbCreate(scriptName(), vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		}
		
		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion
	
//region validate
	
	if (_GenBeam.length() != 2)
	{ 
		// no beam in selection
		reportMessage(TN("|two beams needed|"));
		eraseInstance();
		return;
	}
	
//End validate//endregion 
	
//region mode of tsl
	
	int iMode = _Map.getInt("iMode");
	if (iMode == 0)
	{ 
		_Map.setInt("iMode", 1);
	}

//End mode of tsl//endregion 
	
//region swap x-y
		
// Trigger swapXY//region
	
	String sTriggerswapXY = T("|swap X-Y|");
	addRecalcTrigger(_kContext, sTriggerswapXY );
	if (_bOnRecalc && (_kExecuteKey == sTriggerswapXY || _kExecuteKey == sDoubleClick))
	{
		if (_Map.hasInt("iSide"))
		{ 
			int iSide = _Map.getInt("iSide");
			iSide *=-1;
			_Map.setInt("iSide", iSide);
		}
		
		setExecutionLoops(2);
		return;
		
	}//endregion

//End swap x-y//endregion 
	
//region fill map values if not found
	
	if ( ! _Map.hasInt("iSide"))
	{ 
		_Map.setInt("iSide", 1);
	}

//End fill map values if not found//endregion 

setKeepReferenceToGenBeamDuringCopy(_kAllBeams);

//region some data
	
	GenBeam gb = _GenBeam[0];
	Vector3d vecX = gb.vecX();
	Vector3d vecY = gb.vecY();
	Vector3d vecZ = gb.vecZ();
	Point3d ptCen = gb.ptCen();
	Point3d ptCenSolid = gb.ptCenSolid();
	double dLength = gb.solidLength();
	double dWidth = gb.solidWidth();
	double dHeight = gb.solidHeight();
	
	vecX.vis(ptCen, 1);
	vecY.vis(ptCen, 3);
	vecZ.vis(ptCen, 150);
	ptCen.vis(10);
	
	GenBeam gb1 = _GenBeam[1];
	Vector3d vecX1 = gb1.vecX();
	Vector3d vecY1 = gb1.vecY();
	Vector3d vecZ1 = gb1.vecZ();
	Point3d ptCen1 = gb1.ptCen();
	Point3d ptCenSolid1 = gb1.ptCenSolid();
	double dLength1 = gb1.solidLength();
	double dWidth1 = gb1.solidWidth();
	double dHeight1 = gb1.solidHeight();
	
	vecX1.vis(ptCen, 1);
	vecY1.vis(ptCen, 3);
	vecZ1.vis(ptCen, 150);
	ptCen1.vis(10);
	
//End some data//endregion 

//region evaluate
	
	if(_PtG.length()<1)
	{ 
		// if TSL is created from another TSL, there is no insert so the ptg
		// must be initialized with _Pt0
		_PtG.append(_Pt0);
//		// no point was defined
//		eraseInstance();
//		return;
	}
	_Pt0.vis(4);
	
//End evaluate//endregion 

//region 6 bounding planes for the first beam
	
	double dDimExtrems[] ={ .5 * dLength, .5 * dLength,
							.5 * dWidth, .5 * dWidth,
							.5 * dHeight, .5 * dHeight};
	Vector3d vecExtrems[] ={ vecX, - vecX, vecY ,- vecY, vecZ ,- vecZ};
	Plane planes[0];
	for (int i = 0; i < 6; i++)
	{ 
		planes.append(Plane(ptCenSolid + dDimExtrems[i] * vecExtrems[i], vecExtrems[i]));
//		planes[i].vis(5);
	}//next i
	
	Quader qd(ptCenSolid, vecX, vecY, vecZ, dLength, dWidth, dHeight);
	qd.vis(4);
	
	
	double dDimExtrems1[] ={ .5 * dLength1, .5 * dLength1,
							.5 * dWidth1, .5 * dWidth1,
							.5 * dHeight1, .5 * dHeight1};
	Vector3d vecExtrems1[] ={ vecX1, - vecX1, vecY1 ,- vecY1, vecZ1 ,- vecZ1};
	Plane planes1[0];
	for (int i = 0; i < 6; i++)
	{ 
		planes1.append(Plane(ptCenSolid1 + dDimExtrems1[i] * vecExtrems1[i], vecExtrems1[i]));
//		planes[i].vis(5);
	}//next i
	
	Quader qd1(ptCenSolid1, vecX1, vecY1, vecZ1, dLength1, dWidth1, dHeight1);
	qd1.vis(3);
	
//End bounding planes of 2 genBeams//endregion 
	
	
//region get the closest edge with the 2 beams
	
	// 1- find all pairs of planes from genbeam and genbeam1 that are in same plane 
	// 2- filter all valid edges from pairs of planes , 
	//    those with segment that have common range and are close enough
	// 3- for all edges save the 2 planes thay are created from
	
	// possible plane couples
	Plane planesPossible[0];
	Plane planesPossible1[0];
	// index of planes
	int iPossible[0];
	int iPossible1[0];
	
	for (int i = 0; i < planes.length(); i++)
	{ 
		for (int j = 0; j < planes1.length(); j++)
		{ 
			// see if parallel
			//checks if vectors parallel	
			
			if (abs(abs(vecExtrems[i].dotProduct(vecExtrems1[j])) - 1) > dEps)
			{ 
				// not parallel
				continue;
			}
			if (vecExtrems[i].dotProduct(vecExtrems1[j]) < 0)
			{ 
				// opsite sides
				continue;
			}
			if((planes1[j].closestPointTo(planes[i].ptOrg())-planes[i].ptOrg()).length()>dEps)
			{ 
				// planes not at same level
				continue;
			}
			planesPossible.append(planes[i]);
			planesPossible1.append(planes1[j]);
			iPossible.append(i);
			iPossible1.append(j);
		}//next j
	}//next i
	
	if (planesPossible.length() == 0)
	{ 
		reportMessage(TN("|no common plane found|"));
		eraseInstance();
		return;
	}
	
	
	// 2 planes for edge at first beam
	Plane plane1;
	int index1;
	Plane plane2;
	int index2;
	// 2 planes for edge at second beam
	Plane plane11;
	int index11;
	Plane plane12;
	int index12;
	
	
	double dToleranceAllowed = U(50);
	// distance between 2 edges
	double dDistMin = U(50);
	// distance from ptg of middle edge
	double dDistMinPtg = U(10e10);
	Line lnBetween;
	for (int i=0;i<planes.length();i++) 
	{ 
		Plane pli = planes[i];
		if (iPossible.find(i) < 0)
		{ 
			continue;
		}
		// index of i in array iPossible
		int iIndex = iPossible.find(i);
		for (int j=0;j<planes.length();j++) 
		{ 
			Plane plj = planes[j];
			//checks if vectors parallel	
			if (abs(abs(vecExtrems[i].dotProduct(vecExtrems[j])) - 1) < dEps)
			{ 
				// parallel, no edge
				continue;
			}
			int iHasIntersection = pli.hasIntersection(plj);
			if ( ! iHasIntersection)
			{ 
				// no intersection
				continue;
			}
			Line ln = pli.intersect(plj);
			//-------------------
			for (int ii=0;ii<planes1.length();ii++) 
			{ 
				Plane plii = planes1[ii];
				if (iPossible1.find(ii) < 0)
				{ 
					continue;
				}
				int iIndex1 = iPossible1.find(ii);
				if (iIndex != iIndex1)
				{ 
					continue;
				}
				for (int jj=0;jj<planes1.length();jj++) 
				{ 
					Plane pljj = planes1[jj];
					//checks if vectors parallel	
					if (abs(abs(vecExtrems1[ii].dotProduct(vecExtrems1[jj])) - 1) < dEps)
					{ 
						// parallel, no edge
						continue;
					}
					int iHasIntersection = plii.hasIntersection(pljj);
					if ( ! iHasIntersection)
					{ 
						// no intersection
						continue;
					}
					Line ln1 = plii.intersect(pljj);
					
					
					//checks if vectors parallel	
					if (abs(abs(ln.vecX().dotProduct(ln1.vecX())) - 1) > dEps)
					{ 
						// not parallel
						continue;
					}
					// check if edges have a common range
					Point3d pt1 = gb.ptCen() - .5 * qd.dD(ln.vecX())*ln.vecX();
					Point3d pt2 = gb.ptCen() + .5 * qd.dD(ln.vecX())*ln.vecX();
					
					Point3d pt11 = gb1.ptCen() - .5 * qd1.dD(ln.vecX())*ln.vecX();
					Point3d pt12 = gb1.ptCen() + .5 * qd1.dD(ln.vecX())*ln.vecX();
//					pt1.vis(4);
//					pt2.vis(4);
//					pt11.vis(4);
//					pt12.vis(4);
					
					if (abs((pt1 - pt12).dotProduct(ln.vecX())) >= 
							(abs((pt1 - pt2).dotProduct(ln.vecX())) + abs((pt11 - pt12).dotProduct(ln.vecX()))))
					{ 
						continue;
					}
					
					// parallel lines, check the distance from each other and the tolerance
					// vector from 1 edge to the other 
					Vector3d vec12 = ln1.ptOrg() - ln.closestPointTo(ln1.ptOrg());
					double dDist = (vec12).length();
					if (dDist < dToleranceAllowed)
					{ 
						Line lnMiddle(ln.ptOrg() + .5 * vec12,ln.vecX());
						double dDistPtg = (lnMiddle.closestPointTo(_PtG[0]) - _PtG[0]).length();
						
						if (dDistPtg < dDistMinPtg)
						{ 
							// distance between 2 edges
							dDistMinPtg = dDistPtg;
							plane1 = pli;index1 = i;
							plane2 = plj;index1 = j;
							
							plane11 = plii;index11 = ii;
							plane12 = pljj;index12 = jj;
							// line between 2 parallel edges
							lnBetween = lnMiddle;
							
							if (dDist <= dDistMin)
							{ 
								dDistMin = dDist;
							}
						}
					}
				}//next jj
			}//next ii
		}//next j
	}//next i
	_PtG[0].vis(3);
	
//End get the closest edge with the 2 beams//endregion 
	
	
//region line between 2 edges
	
	Line lnEdge = plane1.intersect(plane2);
	Line lnEdge1 = plane11.intersect(plane12);
	
	lnEdge.vis(2);
	lnEdge1.vis(2);
	lnBetween.vis(3);
	Line ln = lnBetween;
	if(_kNameLastChangedProp=="_Pt0")
	{ 
		reportMessage(TN("|pt0 moved|"));
		_Pt0 = ln.closestPointTo(_Pt0);
	}
	else if (_kNameLastChangedProp == "_PtG0")
	{ 
		// grip point was moved
		// project ptg at the edge found
		_PtG[0] = ln.closestPointTo(_PtG[0]);
		_Pt0 = _PtG[0];
	}
	// if the part is displaced, move the pt0 and ptg0
	// to the found edge
	_Pt0 = ln.closestPointTo(_Pt0);
	_PtG[0] = ln.closestPointTo(_PtG[0]);
	
	_Pt0.vis(4);
	
//End line between 2 edges//endregion 

//region Display
	
	Display dp(252);
	
	
//End Display//endregion 
//region created 3d part
	
	Vector3d vxBody = ln.vecX();
	if (iMode == 0)
	{ 
		// at first time favour the position
		// in +_ZW, +_XW, +_YW
		_Map.setInt("iSideDefault", 1);
		if (vxBody.dotProduct(_ZW) > 0)
		{ 
			_Map.setInt("iSideDefault", - 1);
		}
		else if (abs(vxBody.dotProduct(_ZW)) < dEps)
		{ 
			// normal with _ZW, check _XW
			if (vxBody.dotProduct(_XW) > 0)
			{ 
				_Map.setInt("iSideDefault", - 1);
			}
			else if (abs(vxBody.dotProduct(_XW)) < dEps)
			{ 
				// normal with _XW, check _YW
				if (vxBody.dotProduct(_YW) > 0)
				{ 
					_Map.setInt("iSideDefault", - 1);
				}
			}
		}
	}
	int iSideDefault = _Map.getInt("iSideDefault");
	int iSide = 1;
	if (_Map.hasInt("iSide"))
	{
		iSide = _Map.getInt("iSide");
	}
	
	vxBody = iSide * vxBody * iSideDefault;
	Vector3d vyBody = vxBody.crossProduct(plane1.normal());
	vyBody.normalize();
	Vector3d vzBody = vxBody.crossProduct(vyBody);
	vzBody.normalize();

	// try to locate the block
	Point3d ptBlock = _Pt0 + vxBody * .5 * dLPart;
	int iIndexBlock = _BlockNames.find("Panel Closer");
	if (iIndexBlock >- 1)
	{ 
		int zz;
		Block block(_BlockNames[iIndexBlock]);
//		block.vis(ptBlock, -vyBody, vzBody, -vxBody);
		dp.draw(block,ptBlock, -vyBody, vzBody, -vxBody);
	}
	else
	{ 
		// try to import from the hsbCompany\Block directory
		String sPath = _kPathHsbCompany;
		String sFolder = "Block";
		String sFileName = "Panel Closer";
		String sFolders[] = getFoldersInFolder(sPath);
		String sFullPath = sPath + "\\" + sFolder + "\\" + sFileName + ".dwg";
		String sFile = findFile(sFullPath);
		if (sFile.length() > 0)
		{
			Block block(sFile);
			dp.draw(block,ptBlock, -vyBody, vzBody, -vxBody);
		}
		else
		{ 
			// not found in company folder, create it here
			Body bd(_Pt0, vxBody,vyBody, vzBody,
					dLPart, dWPart, dThicknessPart,
					0, 0, -1);
			bd.vis(1);
			dp.draw(bd);
		}
		
	}
	_PtG[0] = _Pt0 + (vxBody * .5 * dLPart);
	
//End created 3d part//endregion 
	
	
//region group assignment
	
	assignToLayer("i");
	assignToGroups(Entity(gb));
	
//End group assignment//endregion 


//region hardware export
	
// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 
	
// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{ 
	// element
		// try to catch the element from the parent entity
		Element elHW =gb.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())
			elHW = (Element)gb;
		if (elHW.bIsValid()) 
			sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length() > 0)
				sHWGroupName = groups[0].name();
		}
	}

// add main componnent
	{ 
		
		String sType = "Panel closer";
		HardWrComp hwc(sType, 1); // the articleNumber and the quantity is mandatory
		
		String sManufacturer = "Cullen";
		hwc.setManufacturer(sManufacturer);
		
//			hwc.setModel(sProductCode);
//		hwc.setName(sHWName);
//		hwc.setDescription(sHWDescription);
		String sMaterial = "galvanised mild steel - Z275";
		hwc.setMaterial(sMaterial);
//		hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(gb);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(U(180));
		hwc.setDScaleY(U(85));
		hwc.setDScaleZ(U(1.2));
	// uncomment to specify area, volume or weight
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}
// annular ringshank nails
	{ 
		String sType = "Annular Ringshank Nails";
		HardWrComp hwc(sType, 18); // the articleNumber and the quantity is mandatory
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(gb);
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		// diameter
		hwc.setDScaleX(U(50));
		hwc.setDScaleY(U(3.35));
	// apppend component to the list of components
		hwcs.append(hwc);
	}
// make sure the hardware is updated
	if (_bOnDbCreated)
		setExecutionLoops(2);
	
	_ThisInst.setHardWrComps(hwcs);	
	
//End hardware export//endregion 

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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo">
    <lst nm="TSLINFO" />
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End