#Version 8
#BeginDescription
version value="1.5" date="20Nov2018" author="thorsten.huck@hsbcad.com"
helper guide line added

hardware output added

helper line support, new HVAC-System support 
connection points published

This tsl creates a G-connection of ductwork beams.
#End
#Type G
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
/// <History>//region
/// <version value="1.5" date="20Nov2018" author="thorsten.huck@hsbcad.com"> helper guide line added </version>
/// <version value="1.4" date="09aug2018" author="thorsten.huck@hsbcad.com"> hardware output added </version>
/// <version value="1.3" date="18Jul2018" author="thorsten.huck@hsbcad.com"> helper line support, new HVAC-System support </version>
/// <version value="1.2" date="18Jul2018" author="thorsten.huck@hsbcad.com"> renamed</version>
/// <version value="1.1" date="21jun2018" author="thorsten.huck@hsbcad.com"> connection points published </version>
/// <version value="1.0" date="20jun2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entities, select properties or catalog entry and press OK
/// </insert>

/// <remark Lang=en>
/// Requires settings file HVAC.xml in the <company>\tsl\settings path
/// </remark>

/// <summary Lang=en>
/// This tsl creates a G-connection of ductwork beams. 
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "HVAC-G")) TSLCONTENT 


//endregion
// constants //region
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
	//endregion


// SETTINGS //region
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sScript ="HVAC";
	Map mapSetting;

// find settings file
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound;
	if (_bOnInsert)
		bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
	String sFullPath = sPath+"\\"+sFolder+"\\"+sScript+".xml";
	String sFile=findFile(sFullPath); 

// read a potential mapObject
	MapObject mo(sDictionary ,sScript);
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
	//endregion		
	

// bOnInsert
	if(_bOnInsert)
	{
//		if (insertCycleCount()>1) { eraseInstance(); return; }
//					
//	// silent/dialog
//		String sKey = _kExecuteKey;
//		sKey.makeUpper();
//
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

	// separate selection
		PrEntity ssB(T("|Select 2 ductwork beams|"), Beam());
		Beam beams[0];
		int nCycle; // count the user attempts to select beams
		while (_Beam.length()<2)
		{
			if (ssB.go())
			{
				beams=ssB.beamSet();
				for (int i=0; i<beams.length();i++)
				{
					int n =_Beam.find(beams[i]);
				// append first
					if (_Beam.length()==0)
						_Beam.append(beams[i]);
				// do not add the same again		
					else if (n>-1)
					{
						if (nCycle>0)reportMessage(" " + T("|refused (Duplicate)|"));
						continue;							
					}
				// test parallelism or append
					else
					{
					// test parallelism
						Vector3d vx = _Beam[0].vecX();
						if (beams[i].vecX().isParallelTo(vx))	
						{
							reportMessage(" " + T("|refused (parallel)|"));
							continue;	
						}
					// append	
						else
							_Beam.append(beams[i]);						
					}	
				// only two needed
					if (_Beam.length()==2)break;	
				}
				if (beams.length()<1)
				{ 
					eraseInstance();
					return;
				}
			}
			else
			{
				eraseInstance();
				break;	
			}
			
			if (_Beam.length()==1)
			{
				nCycle++;
				ssB=PrEntity (T("|Select second ductwork beam|"), Beam());	
			}	
		}

		return;
	}	
// end on insert	__________________

// validate beams
	if (_Beam.length()<2)
	{ 
		eraseInstance();
		return;
	}
	setEraseAndCopyWithBeams(_kBeam01);
	
	Beam bm0=_Beam[0], bm1=_Beam[1];
	_Entity.append(bm0);
	_Entity.append(bm1);
	setDependencyOnEntity(bm0);
	setDependencyOnEntity(bm1);
	
	


// validate alignment
	if (bm0.vecX().isParallelTo(bm1.vecX()))
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|this tool is not applicable to parallel beams.|"));	
		eraseInstance();
		return;		
	}
	Point3d ptCen0 = bm0.ptCenSolid();
	Point3d ptCen1 = bm1.ptCenSolid();
	Plane pnW(ptCen0, _ZW);
	_X.vis(_Pt0, 1);
	_Y.vis(_Pt0, 3);
	_Z.vis(_Pt0, 150);

//	_XE.vis(_Pt0, 30);
//	_YE.vis(_Pt0, 30);
	_X0.vis(ptCen0, 40);
	_X1.vis(ptCen1, 40);
	
	if (bDebug)reportMessage("\n" + scriptName() + ": " +T("|starting...|") + " " + _ThisInst.handle() +"("+_kExecutionLoopCount+")");

	double dDiameter = bm0.dD(_X);//dHeight>0?0:dWidth;

// get extrusion profile rings if any
	PLine plShapeRings[0];
	ExtrProfile ep =bm0.extrProfile(); 
	PlaneProfile ppEp;
	if (ep.entryName()!=_kExtrProfRound && ep.entryName()!= _kExtrProfRectangular)
	{ 
		ppEp = ep.planeProfile();
		ppEp.transformBy(CoordSys(ptCen0, _Y0, _Z0,_X0));
		//ppEp.vis(2);
	}
	

// defaults
	double dRadius, dInsulation;	
	String sName;
	double dWidth=bm0.dW(), dHeight=bm0.dH();
	
// get duct child definition if any
	Map mapChild = bm0.subMapX("HvacChild");
	if (mapChild.length()<1)mapChild = bm1.subMapX("HvacChild");
	//reportMessage("\n" + scriptName() + ": " +T("|map|") + mapChild);
	
	if (mapChild.length()>0)
	{ 
		String k;
		k = "Name"; if (mapChild.hasString(k))sName = mapChild.getString(k);
		k = "Height"; if (mapChild.hasDouble(k))dHeight = mapChild.getDouble(k);
		k = "Width"; if (mapChild.hasDouble(k))dWidth = mapChild.getDouble(k);
		k = "Radius"; if (mapChild.hasDouble(k))dRadius = mapChild.getDouble(k);
		k = "Diameter"; if (mapChild.hasDouble(k))dDiameter = mapChild.getDouble(k);
		k = "Insulation"; if (mapChild.hasDouble(k))dInsulation = mapChild.getDouble(k);
//		double dDiameter = dHeight <= 0 ? dWidth : 0;			
	}

	
	
// get radius
	double dAngle = _X0.angleTo(_X1);
	if (dAngle > 90)dAngle = 180 - dAngle;
	Point3d ptCen = _Pt0 - _Z * dRadius;ptCen.vis(6);
	PLine plArc(_Y);
	Point3d ptStart = _Pt0 - _X0 * dRadius+_Y*_Y.dotProduct(ptCen0-_Pt0); ptStart.vis(0);
	Point3d ptEnd = _Pt0 - _X1 * dRadius+_Y*_Y.dotProduct(ptCen1-_Pt0); ptEnd.vis(5);


// cut beams
	bm0.addTool(Cut(ptStart, dRadius<dEps?-_X:_X0), _kStretchOnToolChange);
	bm1.addTool(Cut(ptEnd, dRadius<dEps?_X:_X1), _kStretchOnToolChange);

// validate
	int bInPlane = abs(_Y.dotProduct(ptStart - ptEnd))<dEps;	
	Point3d _ptEnd = ptEnd + _Y * _Y.dotProduct(ptStart - ptEnd);
	
// publish connection points
	Point3d ptConnects[] ={ ptStart, ptEnd};
	_Map.setPoint3dArray("ptConnect[]", ptConnects);
	
	
// flag if the connection is in XY-Plane
	int bIsXYPlane= bm0.vecD(_Y).isParallelTo(bm1.vecD(_Y)) &&  bm0.vecD(_Y).isParallelTo(bm0.vecZ());


//
	Point3d ptCenMax;
	int bOk = Line(ptStart, bm0.vecY()).hasIntersection(Plane(ptEnd, _X1), ptCenMax);
	if (bOk && abs(dAngle-90)>dEps)
	{
		ptCenMax.vis(5);
		double dRadiusMax = Vector3d(_Pt0-ptCenMax).length();
		if (dRadiusMax>dRadius)
			dRadius = dRadiusMax;
		ptCen = _Pt0 - _Z * dRadius;
	}

// Displays
	int nColor = bm0.color();
	if (!bInPlane)nColor = nColor == 1 ? 6 : 1;
	//nColor = _ThisInst.color();
	Display dpModel(nColor), dpPlan(nColor);
	int bDrawAsLinework = !bm0.isVisible();	
	if(!bDrawAsLinework)
	{
		dpPlan.addViewDirection(_ZW);
		dpModel.addHideDirection(_ZW);
	}
	
	
	
// alert
	if (!bInPlane)
	{ 
		PlaneProfile pp = bm1.envelopeBody().shadowProfile(Plane(ptEnd, bm1.vecX()));
		pp.shrink(-U(20));
		LineSeg seg = pp.extentInDir(bm1.vecY());
		dpModel.draw(PLine(seg.ptStart(), seg.ptMid(), seg.ptEnd()));
		dpModel.draw(pp.extentInDir(-bm1.vecZ()));
		dpModel.draw(T("|Not possible|"), ptEnd, _XW, _YW, 0, 0, _kDeviceX);
	}

// create and draw arc//region	
	Body bdArc;
	if(dRadius>0)
	{ 
		
		int nDir =(_X0.dotProduct(_X) < 0)?-1:1;
		plArc.addVertex(ptStart);
		plArc.addVertex(_ptEnd,nDir*tan(dAngle/4));
		plArc.vis(2);

	// draw arc as helper line
		if (!bInPlane)
		{ 
			dpModel.draw(plArc);		
		}

	// draw LineWork
		if (bDrawAsLinework)
		{ 
			;//dpModel.draw(plArc);		
		}
	// draw arced body
		else
		{ 
		// create arc secments
			double dL = plArc.length();
			double dMinYZ = bm0.dW() < bm0.dH() ? bm0.dW(): bm0.dH();
			int nNum = dL/dMinYZ;
			if (nNum > 10)nNum = 10;
			else if (nNum <5)nNum = 5;
			double dDist = nNum>0?dL / nNum:0;
		
			Point3d ptPrev;
			Body bdSegs[0];
			LineSeg segsX[0];
			Vector3d vecPrev;
			Body bdPrev;
			
			for (int j=0;j<nNum;j++) 
			{ 
				Point3d pt1 = plArc.getPointAtDist(j * dDist);
				Point3d pt2 = plArc.getPointAtDist((j+1) * dDist);
				Point3d pt3;
				if (j<nNum-1)pt3= plArc.getPointAtDist((j+2) * dDist);
				else pt3 = pt2 - _X1 * dDiameter;
				LineSeg seg2 (pt2, pt3);
				LineSeg seg1(pt1, pt2);
		//		seg1.vis(1);
		//		seg2.vis(2);
				
				Vector3d vec1 = pt2 - pt1; vec1.normalize();// vec1.vis(pt1, 0);
				Vector3d vec2 = pt3 - pt2; vec2.normalize();
				
				Vector3d vecM1 = vecPrev.bIsZeroLength() ?_X0 : vecPrev + vec1;vecM1.normalize();
				Vector3d vecM2 = (j==nNum-1)?-_X1:vec1 + vec2; vecM2.normalize();
				
				Cut ct1(pt1,-vecM1);
				Cut ct2(pt2,vecM2);
				
				Body bdSeg;
				if (ep.entryName()==_kExtrProfRound)
					bdSeg=Body(pt1-vec1*.5* dDiameter, pt2+vec1*.5* dDiameter, dDiameter * .5+dInsulation);
				else if (ppEp.area()>pow(dEps,2))
				{ 
					Vector3d vecYS = vec1.crossProduct(-_Y);vecYS.normalize();
					CoordSys cs, csEp=ppEp.coordSys();
		
					cs.setToAlignCoordSys(csEp.ptOrg(), csEp.vecX(), csEp.vecY(), csEp.vecZ(), pt1, vecYS, _Y, vec1);
					ppEp.transformBy(cs);
					//ppEp.vis(1);
		
					PLine plRings[] = ppEp.allRings();
					int bIsOp[] = ppEp.ringIsOpening();
					for (int r=0;r<plRings.length();r++)
						if (!bIsOp[r])
							bdSeg.combine(Body(plRings[r], vec1*(seg1.length()+2*dDiameter),1));
					bdSeg.transformBy(-vec1 * dDiameter);
		
		
		
				}			
				else
				{ 
					Vector3d vecX = vec1;
					Vector3d vecZ = bIsXYPlane?_Y:_Z;
					Vector3d vecY = vecX.crossProduct(-vecZ);vecY.normalize();
					vecZ = vecX.crossProduct(vecY);vecZ.normalize();
					bdSeg = Body(pt1 - vec1 * .5 * dDiameter, vecX, vecY, vecZ, seg1.length() + dDiameter,dWidth,dHeight, 1, 0, 0);
				}
		
		
				bdSeg.addTool(ct1, 0);
				bdSeg.addTool(ct2, 0);
		
		//		vecM1.vis(pt2, 3);
				bdSeg.vis(j);
				dpModel.draw(bdSeg);
				bdArc.combine(bdSeg);
				vecPrev = vec1;
				
			}
			
		// draw plan view
			dpPlan.draw(bdArc.shadowProfile(pnW));
			if (bm1.vecX().isParallelTo(_ZW))dpPlan.draw(bdArc.extractContactFaceInPlane(Plane(ptEnd,_ZW),dEps));
			if (bm0.vecX().isParallelTo(_ZW))dpPlan.draw(bdArc.extractContactFaceInPlane(Plane(ptStart,_ZW),dEps));				
		}
	
	
	
		
	}
// draw mitre symbol	
	else if(!bDrawAsLinework)
	{
		PlaneProfile pp = bm0.realBody().extractContactFaceInPlane(Plane(_Pt0, _X), dEps);
		pp.shrink(U(2));
		dpModel.draw(pp);
		dpPlan.draw(pp);
		;//endregion
	}
// draw nothing if radius <=0 and bDrawAsLinework


// draw helper lines
	PLine pl0(ptStart, ptStart -_X0 * (_W0+_H0));
	PLine pl1(ptEnd, ptEnd - _X1 * (_W1+_H1));
	dpModel.draw(pl0);
	dpModel.draw(pl1);
	dpPlan.draw(pl0);
	dpPlan.draw(pl1);


// publish arc length
	_Map.setPLine("plHvac", plArc);
	
// debug display	
	if (_bOnDebug )//|| (bdArc.volume()<pow(dEps,3))// && dRadius>dEps))
		dpModel.draw(scriptName(), _Pt0, _XW, _YW, 1, 0);
	
// Hardware//region
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
		Group groups[] = _ThisInst.groups();
		if (groups.length()>0)
			sHWGroupName=groups[0].name();
	}
	
// add main componnent and compareKey
	{ 
		String articleNumber= T("|Arc| ") + dAngle+"°" + T(" |Radius| ")+dRadius;
		String model, family;
		
	// get first valid family and child
		double dY;
		for (int i=0;i<_Beam.length();i++) 
		{ 
			Beam& b = _Beam[i];
			Map m = b.subMapX("HvacChild");
			family = m.getString("FamilyName");
			if(model.length()<1)
				model = m.getString("Name");
			
			if (dY<=0)
			{ 
				if (m.hasDouble("Diameter"))
				{ 
					dY = m.getDouble("Diameter");
					articleNumber+= " "+T("|DN| ")+dY;	
				}
				else
				{ 
					dY = m.getDouble("Width");
					articleNumber+= " "+dY+"x"+m.getDouble("Height");		
				}
			}

		}//next i

		setCompareKey(scriptName() + "_" + articleNumber);
		
		if (dRadius>0)
		{ 
			HardWrComp hwc(articleNumber, 1); // the articleNumber and the quantity is mandatory
			
	//		hwc.setManufacturer(sHWManufacturer);
			hwc.setModel(model);
			hwc.setName(family);
	//		hwc.setDescription(sHWDescription);
	//		hwc.setMaterial(sHWMaterial);
	//		hwc.setNotes(sHWNotes);
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(_ThisInst);	
			hwc.setCategory(T("|HVAC|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			hwc.setDScaleX(bdArc.lengthInDirection(_X0));
			hwc.setDScaleY(bdArc.lengthInDirection(_Y0));
			hwc.setDScaleZ(bdArc.lengthInDirection(_Z0));
			
		// apppend component to the list of components
			hwcs.append(hwc);			
		}

	}



// make sure the hardware is updated
	if (_bOnDbCreated)
		setExecutionLoops(2);
				
	_ThisInst.setHardWrComps(hwcs);	
	//endregion	
	
	
#End
#BeginThumbnail
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
HZ*`.3N+'7=4VK<JBHIR`2H`_+FNELH6MK&"!R"T<84D=.!4]%`'_V5S_
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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End