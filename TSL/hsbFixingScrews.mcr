#Version 8
#BeginDescription
#Versions:
1.9 10.05.2023 HSB-18650 standard display published for share and make
1.8 14.09.2021 HSB-13076: set distribution to center when angle is set to 0 (only on property change) Author: Marsel Nakuci
1.7 03.09.2021 HSB-13077: fix bug when reading manufacturer, family, product from _kExecuteKey Author: Marsel Nakuci
1.6 23.07.2021 HSB-12662: TSL works with ElementWall not only ElementWallSF Author: Marsel Nakuci
1.5 18.06.2021 HSB-11613: fix bug: write article nr in hardware instead of family name, add trigger to generate single instances
1.4 29.05.2021 small improvement in jig Author: Marsel Nakuci
1.3 12.05.2021 HSB-11613: add command line options, support mapIo  Author: Marsel Nakuci
1.2 04.05.2021 HSB-11613: Fix bug at start/end distance for distribution Author: Marsel Nakuci
1.1 02.05.2021 HSB-11613: Add some graphics interface in Jig Author: Marsel Nakuci
1.0 29.04.2021 HSB-11613: initial Author: Marsel Nakuci



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 9
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.9 10.05.2023 HSB-18650 standard display published for share and make , Author Thorsten Huck
// Version 1.8 14.09.2021 HSB-13076: set distribution to center when angle is set to 0 (only on property change) Author: Marsel Nakuci
// Version 1.7 03.09.2021 HSB-13077: fix bug when reading manufacturer, family, product from _kExecuteKey Author: Marsel Nakuci
// Version 1.6 23.07.2021 HSB-12662: TSL works with ElementWall not only ElementWallSF Author: Marsel Nakuci
// Version 1.5 18.06.2021 HSB-11613: fix bug: write article nr in hardware instead of family name, add trigger to generate single instances Author: Marsel Nakuci
// Version 1.4 29.05.2021 small improvement in jig Author: Marsel Nakuci
// Version 1.3 12.05.2021 HSB-11613: add command line options, support mapIo  Author: Marsel Nakuci
// Version 1.2 04.05.2021 HSB-11613: Fix bug at start/end distance for distribution Author: Marsel Nakuci
// Version 1.1 02.05.2021 HSB-11613: Add some graphics interface in Jig Author: Marsel Nakuci
// Version 1.0 29.04.2021 HSB-11613: initial Author: Marsel Nakuci

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl creates 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbFixingScrews")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
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


//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="ScrewCatalog";
	Map mapSetting;

// compose settings file location
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound = _bOnInsert ? sFolders.find(sFolder) >- 1 ? true : makeFolder(sPath + "\\" + sFolder) : false;
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";

// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() )
	{
		String sFile=findFile(sFullPath); 
	// if no settings file could be found in company try to find it in the installation path
		if (sFile.length()<1) sFile=findFile(sPathGeneral+sFileName+".xml");	
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);			
		}
	}
	// validate version when creating a new instance
	if(_bOnDbCreated)
	{ 
		int nVersion = mapSetting.getInt("GeneralMapObject\\Version");
		String sFile = findFile(sPathGeneral + sFileName + ".xml");		// set default xml path
		if (sFile.length()<1) sFile=findFile(sFullPath);				// set custom xml path if no default found
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);	// read the xml from installation directory
		int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");		
		if(sFile.length()>0 && nVersion!=nVersionInstall)
			reportNotice(TN("|A different Version of the settings has been found for|") + scriptName()+
			TN("|Current Version| ")+nVersion + "	" + _kPathDwg + TN("|Other Version| ") +nVersionInstall + "	" + sFile);
	}
//End Settings//endregion


	String sManufacturers[0];
	sManufacturers.append("---");
	{ 
		// get the models of this family and populate the property list
		Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
		for (int i = 0; i < mapManufacturers.length(); i++)
		{
			Map mapManufacturerI = mapManufacturers.getMap(i);
			if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
			{
				String _sManufacturerName = mapManufacturerI.getString("Name");
				if (sManufacturers.find(_sManufacturerName) < 0)
				{
					sManufacturers.append(_sManufacturerName);
				}
			}
		}
	}
	
	if (sManufacturers.length()<1)
	{ 
		reportMessage("\n"+ scriptName() + ": "+ T("|Could not find manufacturer data.| ")+ T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
	
//region Properties
	category = T("|Component|");
	// Manufacturer
	String sManufacturerName=T("|Manufacturer|");	
	PropString sManufacturer(nStringIndex++, sManufacturers, sManufacturerName);
	sManufacturer.setDescription(T("|Defines the Manufacturer|"));
	sManufacturer.setCategory(category);
	// Family
	String sFamilys[0];
	sFamilys.append("---");
	String sFamilyName=T("|Family|");	
	PropString sFamily(nStringIndex++, "", sFamilyName);	
	sFamily.setDescription(T("|Defines the Family|"));
	sFamily.setCategory(category);
	// Product
	String sProducts[0];
	sProducts.append("---");
	String sProductName=T("|Product|");
	PropString sProduct(nStringIndex++, "", sProductName);
	sProduct.setDescription(T("|Defines the Product|"));
	sProduct.setCategory(category);
	
	category=T("|Alignment|");
	String sAlignmentName=T("|Alignment|");
//	String sAlignments[] ={ T("|+X|"), T("|-X|"), T("|+Y|"), T("|-Y|"), T("|+Z|"), T("|-Z|") };
	String sAlignments[] ={ "+X", "-X", "+Y", "-Y", "+Z", "-Z"};
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the face of the Genbeam where the nails will be placed|"));
	sAlignment.setCategory(category);
	
	//inclination; angle wrt axis of distribution
	String sAngleName=T("|Angle|");	
	PropDouble dAngle(nDoubleIndex++, U(30), sAngleName);
	dAngle.setDescription(T("|Defines the inclination angle of the Nail. Rotation axis is defined from the direction of distribution|"));
	dAngle.setCategory(category);
	
	// gap for start of nail from the face
	String sGapNailName=T("|Offset from Plate|");	
	PropDouble dGapNail(nDoubleIndex++, U(13), sGapNailName);	
	dGapNail.setDescription(T("|Defines the position of Start (Head) of Nail. Value represents distance from the Face|"));
	dGapNail.setCategory(category);
	
	// distribution
	category=T("|Distribution|");
	String sModeDistributionName=T("|Mode of Distribution|");	
	String sModeDistributions[] ={ T("|Even|"), T("|Fixed|")};
	PropString sModeDistribution(nStringIndex++, sModeDistributions, sModeDistributionName);	
	sModeDistribution.setDescription(T("|Defines the Mode of Distribution|"));
	sModeDistribution.setCategory(category);
	
	//distance from the bottom / start
//	String sDistanceBottomName = T("|Distance Start|");
	String sDistanceBottomName = T("|Start Distance|");
	PropDouble dDistanceBottom(nDoubleIndex++, U(0), sDistanceBottomName);
	dDistanceBottom.setDescription(T("|Defines the Distance at the Start|"));
	dDistanceBottom.setCategory(category);
	// distance from the top/end
//	String sDistanceTopName = T("|Distance End|");
	String sDistanceTopName = T("|End Distance|");
	PropDouble dDistanceTop(nDoubleIndex++, U(0), sDistanceTopName);
	dDistanceTop.setDescription(T("|Defines the Distance at the End|"));
	dDistanceTop.setCategory(category);
	
	// distance in between/ nr of parts (when negative input)
//	String sDistanceBetweenName=T("|Max. Distance between / Number| ");	
	String sDistanceBetweenName=T("|Max. Distance between / Number| ");	
	PropDouble dDistanceBetween(nDoubleIndex++, U(500), sDistanceBetweenName);	
	dDistanceBetween.setDescription(T("|Defines the Distance Between the parts. -integer indicates nr of parts|"));
	// . Negative number will indicate nr of parts from the integer part of the inserted double
	dDistanceBetween.setCategory(category);
	// screw types
	// nr of parts/distance in between
//	String sDistanceBetweenResultName=T("|Real Distance between|");	
	String sDistanceBetweenResultName=T("|Real Distance between|");	
	PropDouble dDistanceBetweenResult(nDoubleIndex++, U(0), sDistanceBetweenResultName);	
	dDistanceBetweenResult.setDescription(T("|Shows the calculated distance between the articles|"));
	dDistanceBetweenResult.setReadOnly(true);
	dDistanceBetweenResult.setCategory(category);
	
	String sNrResultName=T("|Nr.|");	
//	int nNrResults[]={1,2,3};
	PropInt nNrResult(nIntIndex++, 0, sNrResultName);	
	nNrResult.setDescription(T("|Shows the calculated quantity of articles|"));
	nNrResult.setReadOnly(true);
	nNrResult.setCategory(category);
	
	// wall relevant properties
	category=T("|Wall Distribution Rules|");
	// property relevant for insertion in element
	String sZoneName=T("|Zone|");	
	int nZones[] ={ -1, 1};
	PropInt nZone(nIntIndex++, nZones, sZoneName);	
	nZone.setDescription(T("|Defines the Zone|"));
	nZone.setCategory(category);
	// 
	String sBeamName=T("|Beam|");
	String sBeams[] ={ _BeamTypes[_kSFTopPlate], _BeamTypes[_kSFBottomPlate], T("|Both|")};
	PropString sBeam(nStringIndex++, sBeams, sBeamName);	
	sBeam.setDescription(T("|Defines the Beam type where the nails are applied|"));
	sBeam.setCategory(category);
	// windows area excluded
	String sWindowExcludeName=T("|Exclude Window|");	
	PropString sWindowExclude(nStringIndex++, sNoYes, sWindowExcludeName);
	sWindowExclude.setDescription(T("|Defines whether the are below Window should be excluded for nailing|"));
	sWindowExclude.setCategory(category);
	
	// tooling
	category = T("|Drill|");
	String sDrillName=T("|Drill|");	
	PropString sDrill(nStringIndex++, sNoYes, sDrillName);	
	sDrill.setDescription(T("|Defines if Drill should be applied|"));
	sDrill.setCategory(category);
	// diameter
	String sDiameterDrillName=T("|Diameter|");	
	PropDouble dDiameterDrill(nDoubleIndex++, U(0), sDiameterDrillName);	
	dDiameterDrill.setDescription(T("|Defines the Diameter of Drill|"));
	dDiameterDrill.setCategory(category);
	
	// extra Length
	String sLengthDrillName=T("|Depth|");
	PropDouble dLengthDrill(nDoubleIndex++, U(0), sLengthDrillName);	
	dLengthDrill.setDescription(T("|Defines the Length of the Drill|"));
	dLengthDrill.setCategory(category);
//End Properties//endregion 


//region jig
	String strJigAction1 = "strJigAction1";
	if (_bOnJig && _kExecuteKey==strJigAction1) 
	{ 
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		int iModeDistribution = sModeDistributions.find(sModeDistribution);
		// graphic display of properties
		Display dpp(252);
		Display dpHighlight(3);
		Display dpTxt(5);
//		Display dpSelected(44);
		if(_Map.hasMap("mapProps"))
		{
			// original coord
			Map mapPropsCoord=_Map.getMap("mapPropsCoord");
			Vector3d vecXgraph = mapPropsCoord.getVector3d("vecXgraph");
			Vector3d vecYgraph = mapPropsCoord.getVector3d("vecYgraph");
			Vector3d vecZgraph = mapPropsCoord.getVector3d("vecZgraph");
			Point3d ptStartGraph=mapPropsCoord.getPoint3d("ptStartGraph");
			//
			double dHview = getViewHeight();
			Vector3d vecXview = getViewDirection(0)*.001*dHview;
			Vector3d vecYview = getViewDirection(1)*.001*dHview;
			Vector3d vecZview = getViewDirection(2)*.001*dHview;
			Point3d ptStartGraphView = ptStartGraph;
			// set the point outside of genbeam
			{ 
				Body bdGb = _Map.getBody("bdGb");
				PlaneProfile ppGb = bdGb.shadowProfile(Plane(ptStartGraph, vecZview));
				ppGb.shrink(-U(20));
				// get extents of profile
				LineSeg seg = ppGb.extentInDir(vecXview);
				ptStartGraphView = seg.ptEnd();
			}
			dpTxt.textHeight(dHview*.02);
			dpp.textHeight(dHview*.02);
			CoordSys csGraphTransform;
			csGraphTransform.setToAlignCoordSys(ptStartGraph,vecXgraph,vecYgraph,vecZgraph,
												ptStartGraphView, vecXview, vecYview, vecZview 	);
			Map mapPropsGraph = _Map.getMap("mapProps");
			for (int i=0;i<mapPropsGraph.length();i++) 
			{ 
				Map mapI = mapPropsGraph.getMap(i);
				PlaneProfile ppProp = mapI.getPlaneProfile("ppProp");
				ppProp.transformBy(csGraphTransform);
				dpp.color(252);
				dpp.draw(ppProp, _kDrawFilled);
				if(ppProp.pointInProfile(ptJig)==_kPointInProfile)
					dpHighlight.draw(ppProp, _kDrawFilled, 60);
				String sTxtProp = mapI.getString("txtProp");
				Point3d ptTxtProp = mapI.getPoint3d("ptTxtProp");
				ptTxtProp.transformBy(csGraphTransform);
//				dpp.draw(sTxtProp, ptTxtProp, vecXview, vecYview, 0, 0);
				dpTxt.draw(sTxtProp, ptTxtProp, vecXview, vecYview, 0, 0);
				// options
				Map mapOps = mapI.getMap("mapOps");
				for (int iOp=0;iOp<mapOps.length();iOp++) 
				{ 
					Map mapIop = mapOps.getMap(iOp);
					PlaneProfile ppOp = mapIop.getPlaneProfile("ppOp");
					ppOp.transformBy(csGraphTransform);
					int iColorOp=mapIop.getInt("colorOp");
					dpp.color(iColorOp);
					dpp.draw(ppOp, _kDrawFilled);
					if(ppOp.pointInProfile(ptJig)==_kPointInProfile)
						dpHighlight.draw(ppOp, _kDrawFilled, 60);
					Point3d ptTxtOp = mapIop.getPoint3d("ptTxtOp");
					ptTxtOp.transformBy(csGraphTransform);
					String sTxtOp = mapIop.getString("txtOp");
//					dpp.draw(sTxtOp, ptTxtOp, vecXview, vecYview, 0, 0);
					if(iColorOp==1)
						dpTxt.color(iColorOp);
					dpTxt.draw(sTxtOp, ptTxtOp, vecXview, vecYview, 0, 0);
					dpp.color(252);
					dpTxt.color(5);
				}//next iOp
				
			}//next i
//			Map map
		}
		
		Point3d ptPlane = _Map.getPoint3d("ptPlane");
//		Vector3d vecPlane = _Map.getVector3d("vecPlane");
		// quad
		Point3d ptCen = _Map.getPoint3d("ptCen");
		Vector3d vecX = _Map.getVector3d("vecX");
		Vector3d vecY = _Map.getVector3d("vecY");
		Vector3d vecZ = _Map.getVector3d("vecZ");
		
		double dLength = _Map.getDouble("dLength");
		double dWidth = _Map.getDouble("dWidth");
		double dHeight = _Map.getDouble("dHeight");
		// 
		double dDiameterThread = _Map.getDouble("dDiameterThread");
		
		Quader qd(ptCen, vecX, vecY, vecZ, dLength, dWidth, dHeight);
		
		Vector3d vecs[] ={ vecX ,- vecX, vecY ,- vecY, vecZ ,- vecZ};
		
		Vector3d vecViewdirection = getViewDirection();
		Vector3d vecAlign = qd.vecD(vecViewdirection);
		for (int iV=0;iV<vecs.length();iV++) 
		{ 
			if(vecs[iV].isCodirectionalTo(vecAlign))
			{ 
				sAlignment.set(sAlignments[iV]);
				break;
			}
			 
		}//next iV
		int iAlignment = sAlignments.find(sAlignment);
		Vector3d vecPlane = vecs[iAlignment];
		Vector3d vecXplane, vecYplane;
		Plane pn(ptCen + vecPlane * .5 * qd.dD(vecPlane), vecPlane);
		
		Vector3d vecsMain[] ={ vecX, vecY, vecZ};
		for (int i=0;i<vecsMain.length();i++) 
		{ 
			if(!vecPlane.isParallelTo(vecsMain[i]))
			{ 
				vecXplane = vecsMain[i];
				break;
			}
		}//next i
		vecYplane = vecPlane.crossProduct(vecXplane);
		
		Display dpJig(3);
//		Point3d ptJigPlane = pn.closestPointTo(ptJig);
		Point3d ptJigPlane = ptJig.projectPoint(pn, dEps, vecViewdirection);
		
		PLine pl;
		pl.createRectangle(LineSeg(ptCen-vecXplane*.5*qd.dD(vecXplane)-vecYplane*.5*qd.dD(vecYplane),
			ptCen + vecXplane * .5 * qd.dD(vecXplane) + vecYplane * .5 * qd.dD(vecYplane)), vecXplane, vecYplane);
		PlaneProfile ppPlane(pn);
		ppPlane.joinRing(pl,_kAdd);
//		dpJig.transparency(98);
		dpJig.draw(ppPlane, _kDrawFilled, 99);
		
		if(!_Map.hasPoint3d("ptJig0"))
		{ 
			// we are at first prompt, prompt for first point of distribution
			LineSeg lSeg(ptJigPlane-vecXplane*.5*dDiameterThread-vecYplane*.5*dDiameterThread, 
			ptJigPlane + vecXplane * .5 * dDiameterThread + vecYplane * .5 * dDiameterThread);
			dpJig.draw(lSeg);
			CoordSys csRot;
			csRot.setToRotation(90, vecPlane, ptJigPlane);
			lSeg.transformBy(csRot);
			dpJig.draw(lSeg);
			
			pl = PLine();
			pl.createCircle(ptJigPlane, vecPlane, dDiameterThread * .5);
			
			PlaneProfile ppDrill(pn);
			ppDrill.joinRing(pl, _kAdd);
			dpJig.color(1);
			dpJig.draw(ppDrill, _kDrawFilled, 30);
		}
		else
		{ 
			// second point of distribution
			Point3d ptStart = _Map.getPoint3d("ptJig0");
			Point3d ptEnd = ptJigPlane;
			Vector3d vecDir = ptEnd - ptStart;vecDir.normalize();
			double dLengthTot = (ptEnd - ptStart).dotProduct(vecDir);
			if (dDistanceBottom + dDistanceTop > dLengthTot)
			{ 
				dpJig.color(1);
				String sText = TN("|no distribution possible|");
				dpJig.draw(sText, ptJigPlane, _XW, _YW, 0, 0, _kDeviceX);
				return;
			}
			double dPartLength = 0;
			Point3d pt1 = ptStart + vecDir * dDistanceBottom;
			Point3d pt2 = ptEnd - vecDir * (dDistanceTop+ dPartLength);
			double dDistTot = (pt2 - pt1).dotProduct(vecDir);
			if (dDistTot < 0)
			{ 
				dpJig.color(1);
				String sText = TN("|no distribution possible|");
				dpJig.draw(sText, ptJigPlane, _XW, _YW, 0, 0, _kDeviceX);
				return;
			}
			Point3d ptsDis[0];
			if (dDistanceBetween >= 0)
			{ 
				// 2 scenarion even, fixed
				if (iModeDistribution == 0)
				{
					// even
					
					// distance in between > 0; distribute with distance
					// modular distance
					double dDistMod = dDistanceBetween + dPartLength;
					int iNrParts = dDistTot / dDistMod;
					double dNrParts = dDistTot / dDistMod;
					if (dNrParts - iNrParts > 0)iNrParts += 1;
					// calculated modular distance between subsequent parts
					
					double dDistModCalc = 0;
					if (iNrParts != 0)
						dDistModCalc = dDistTot / iNrParts;
					
					// first point
					Point3d pt;
					pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
					//				pt.vis(1);
					ptsDis.append(pt);
					if (dDistModCalc > 0)
					{
						for (int i = 0; i < iNrParts; i++)
						{
							pt += vecDir * dDistModCalc;
							//					pt.vis(1);
							ptsDis.append(pt);
						}
					}
					//				dDistanceBetweenResult.set(dDistModCalc-dPartLength);
					// set nr of parts
					//					dDistanceBetweenResult.set(-(ptsDis.length()));
					//				nNrResult.set(ptsDis.length());
				}
				else if(iModeDistribution==1)
				{ 
					// fixed
					// distance in between > 0; distribute with distance
					// modular distance
					double dDistMod = dDistanceBetween + dPartLength;
					int iNrParts = dDistTot / dDistMod;
		//			double dNrParts=dDistTot / dDistMod;
		//			if (dNrParts - iNrParts > 0)iNrParts += 1;
					// calculated modular distance between subsequent parts
					
					double dDistModCalc = 0;
		//			if (iNrParts != 0)
		//				dDistModCalc = dDistTot / iNrParts;
					dDistModCalc = dDistMod;
					// first point
					Point3d pt;
					pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
				//				pt.vis(1);
					ptsDis.append(pt);
					if(dDistModCalc>0)
					{ 
						for (int i = 0; i < iNrParts; i++)
						{ 
							pt += vecDir * dDistModCalc;
				//					pt.vis(1);
							ptsDis.append(pt);
						}
					}
					// last
					ptsDis.append(ptEnd- vecDir * (dDistanceTop + dPartLength / 2));
//					dDistanceBetweenResult.set(dDistModCalc-dPartLength);
					// set nr of parts
				//					dDistanceBetweenResult.set(-(ptsDis.length()));
//					nNrResult.set(ptsDis.length());
				}
			}
			else
			{ 
				double dDistModCalc;
				//
				int nNrParts = -dDistanceBetween / 1;
				if(nNrParts==1)
				{ 
					dDistModCalc = dDistanceBottom;
					ptsDis.append(ptStart + vecDir * dDistanceBottom );
				}
				else
				{ 
					double dDistMod = dDistTot / (nNrParts - 1);
					dDistModCalc = dDistMod;
					int nNrPartsCalc = nNrParts;
					// clear distance between parts
					double dDistBet = dDistMod - dPartLength;
					if (dDistBet < 0)
					{ 
						// distance between 2 subsequent parts < 0
						
						dDistModCalc = dPartLength;
						// nr of parts in between 
						nNrPartsCalc = dDistTot / dDistModCalc;
						nNrPartsCalc += 1;
					}
					// first point
					Point3d pt;
					pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
					ptsDis.append(pt);
					pt.vis(1);
					for (int i = 0; i < (nNrPartsCalc - 1); i++)
					{ 
						pt += vecDir * dDistModCalc;
						pt.vis(1);
						ptsDis.append(pt);
					}//next i
				}
				// set calculated distance between parts
			//					dDistanceBetweenResult.set(dDistModCalc-dPartLength);
//				dDistanceBetweenResult.set(dDistModCalc-dPartLength);
				// set nr of parts
//				nNrResult.set(ptsDis.length());
			}
			
			for (int i=0;i<ptsDis.length();i++) 
			{ 
				Point3d pt = ptsDis[i];
				
				pl = PLine();
				pl.createCircle(pt, vecPlane, dDiameterThread * .5);
				
				PlaneProfile ppDrill(pn);
				ppDrill.joinRing(pl, _kAdd);
				dpJig.color(1);
				dpJig.draw(ppDrill, _kDrawFilled, 30);
			}//next i
		}
		
		return;
	}
//End jig//endregion 

// bOnInsert//region
if (_bOnInsert)
{
	if (insertCycleCount() > 1) { eraseInstance(); return; }
	
	int iWallSelection=true;
	// prompt selection of walls
	Entity ents[0];
	PrEntity ssE(T("|Select walls(s) or Enter to select single Genbeam|"), ElementWallSF());
	if (ssE.go())
		ents.append(ssE.set());
	
	if(ents.length()<=0)
	{ 
		// beam mode
		iWallSelection = false;
		_GenBeam.append(getGenBeam(T("|Select Beam, Sheet or Panel|")));
		nZone.setReadOnly(_kHidden);
		sBeam.setReadOnly(_kHidden);
		sWindowExclude.setReadOnly(_kHidden);
	}
	
	// get opm key from the _kExecuteKey
	String sTokens[] = _kExecuteKey.tokenize("?");
	
	// load properties from catalogue if a catalogue is choosen
	// if executekey is a catalogue then load properties from this catalogue
	// catalogue should not be a manufacturer
	int iCatalog = false;
	if (sTokens.length() == 1 && _kExecuteKey.length() > 0)
	{
//		reportNotice("\n _kExecuteKey " + _kExecuteKey);
//		String files[] = getFilesInFolder(_kPathHsbCompany + "\\tsl\\catalog\\", scriptName() + " * .xml");
//		for (int i = 0; i < files.length(); i++)
//		{
//			String entry = files[i].left(files[i].length() - 4);
//			reportNotice("\n files " + entry);
//			String sEntries[] = TslInst().getListOfCatalogNames(entry);
//			
//			reportNotice("\n using sEntries " + sEntries);
//			if (sEntries.findNoCase(_kExecuteKey ,- 1) >- 1)
//			{
//				Map map = _ThisInst.mapWithPropValuesFromCatalog(entry, _kExecuteKey);
//				setPropValuesFromMap(map);
//				
//				reportNotice("\n using map " + map);
//				break;
//			}
//		}//next i

		// silent/dialog
		if (_kExecuteKey.length() > 0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(_kExecuteKey ,- 1) >- 1)
			{
				if(sManufacturers.find(sTokens[0])<0)
				{
					setPropValuesFromCatalog(_kExecuteKey);
					iCatalog = true;
				}
			}
		}
	}
	
	if(!iCatalog)
	{
		String sOpmKey;
		if (sTokens.length() > 0)
		{
			sOpmKey = sTokens[0];
		}
		else
		{
			sOpmKey = "";
		}
		// get the Manufacturer from the _kExecuteKey or from the dialog box
		// validate the opmkeys, should be one of the Manufacturers supported
		if (sOpmKey.length() > 0)
		{
			String s1 = sOpmKey;
			s1.makeUpper();
			int bOk;
			
			for (int i = 0; i < sManufacturers.length(); i++)
			{
				String s2 = sManufacturers[i];
				s2.makeUpper();
				if (s1 == s2)
				{
					bOk = true;
					sManufacturer.set(T(sManufacturers[i]));
					//					setOPMKey(sManufacturers[i]);
					sManufacturer.setReadOnly(true);
					
					break;
				}
			}//next i
			// the opmKey does not match any family name -> reset
			if ( ! bOk)
			{
				reportNotice("\n" + scriptName() + ": " + T("|NOTE, the specified OPM key| '") +sOpmKey+T("' |cannot be found in the list of Manufacturers.|"));
				sOpmKey = "";
			}
		}
		else
		{
			// sOpmKey not specified, show the dialog
			sManufacturer.setReadOnly(false);
			if (sManufacturers.length() > 0)sManufacturer.set(sManufacturers[1]);
			sFamily.set("---");
			sFamily.setReadOnly(true);
			sProduct.set("---");
			sProduct.setReadOnly(true);
			// alignment
//			sAlignment.setReadOnly(false);
			sAlignment.setReadOnly(_kHidden);
			dAngle.setReadOnly(false);
			dGapNail.setReadOnly(false);
//			nZone.setReadOnly(_kHidden);
			// Drill
			sModeDistribution.setReadOnly(false);
			dDistanceBottom.setReadOnly(false);
			dDistanceTop.setReadOnly(false);
			dDistanceBetween.setReadOnly(false);
			showDialog("---");
			//			setOPMKey(sManufacturer);
			//			sOpmKey = sManufacturer;
		}
	
		// from the mapSetting get all the defined families
		if (sManufacturer != "---")
		{
			if (mapSetting.length() > 0)
			{
				Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
				if (mapManufacturers.length() < 1)
				{
					// wrong definition of the map
					reportMessage(TN("|wrong definition of the map, no Manufacturer|"));
					eraseInstance();
					return;
				}
				// find choosen Manufacturer
				for (int i = 0; i < mapManufacturers.length(); i++)
				{
					Map mapManufacturerI = mapManufacturers.getMap(i);
					if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
					{
						String _sManufacturerName = mapManufacturerI.getString("Name");
						String _sManufacturer = sManufacturer;_sManufacturer.makeUpper();
						if (_sManufacturerName.makeUpper() != _sManufacturer)
						{
							// not this family, keep looking
							continue;
						}
					}
					else
					{
						// not a Manufacturer map
						continue;
					}
					
					// map of the selected Manufacturer is found
					// get its families
					Map mapFamilys = mapManufacturerI.getMap("Family[]");
					if (mapFamilys.length() < 1)
					{
						// wrong definition of the map
						reportMessage(TN("|no Family definition for this manufacturer|"));
						eraseInstance();
						return;
					}
					for (int j = 0; j < mapFamilys.length(); j++)
					{
						Map mapFamilyJ = mapFamilys.getMap(j);
						if (mapFamilyJ.hasString("Name") && mapFamilys.keyAt(j).makeLower() == "family")
						{
							String sName = mapFamilyJ.getString("Name");
							if (sFamilys.find(sName) < 0)
							{
								// populate sFamilies
								sFamilys.append(sName);
								if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
							}
						}
					}
					
					// set the Family
					if (sTokens.length() < 2)//Family not defined in opmkey, showdialog
					{
						// set array of sFamilys and get the first by default
						// manufacturer is set, set as readOnly
						sManufacturer.setReadOnly(true);
						sFamily.setReadOnly(false);
						sFamily = PropString(1, sFamilys, sFamilyName, 0);
						sFamily.set(sFamilys[0]);
						if (sFamilys.length() > 1)sFamily.set(sFamilys[1]);
						sProduct = PropString(2, sProducts, sProductName, 0);
						sProduct.set("---");
						sProduct.setReadOnly(true);
						//
						sAlignment.setReadOnly(_kHidden);
						dAngle.setReadOnly(false);
						dGapNail.setReadOnly(false);
//						nZone.setReadOnly(_kHidden);
						// distribution
						sModeDistribution.setReadOnly(false);
						dDistanceBottom.setReadOnly(false);
						dDistanceTop.setReadOnly(false);
						dDistanceBetween.setReadOnly(false);
						showDialog("---");
						//					showDialog();
						
						if (bDebug)reportMessage("\n" + scriptName() + " from dialog ");
						if (bDebug)reportMessage("\n" + scriptName() + " sProduct " + sProduct);
					}
					else
					{
						// see if sTokens[1] is a valid Family name as in sFamilys from mapSetting
						int indexSTokens = sFamilys.find(sTokens[1]);
						if (indexSTokens >- 1)
						{
							// find
							//				sFamily = PropString(1, sFamilys, sFamilyName, indexSTokens);
							sFamily.set(sTokens[1]);
							if (bDebug)reportMessage("\n" + scriptName() + " from tokens ");
						}
						else
						{
							// wrong definition in the opmKey, accept the first Family from the xml
							reportMessage(TN("|wrong definition of the OPM key|"));
							sFamily.set(sFamilys[0]);
							if (sFamilys.length() > 1)sFamily.set(sFamilys[1]);
						}
					}
					if (sFamily != "---")
					{
						// for the chosen family get Familys and nails. first find the map of selected family
						for (int j = 0; j < mapFamilys.length(); j++)
						{
							Map mapFamilyJ = mapFamilys.getMap(j);
							if (mapFamilyJ.hasString("Name") && mapFamilys.keyAt(j).makeLower() == "family")
							{
								String _sFamilyName = mapFamilyJ.getString("Name");
								String _sFamily = sFamily;_sFamily.makeUpper();
								if (_sFamilyName.makeUpper() != _sFamily)
								{
									// not this family, keep looking
									continue;
								}
							}
							else
							{
								// not a manufacturer map
								continue;
							}
							
							// mapFamilyJ is found, populate types and nails
							// map of the selected Family is found
							// get its types
							Map mapProducts = mapFamilyJ.getMap("Product[]");
							if (mapProducts.length() < 1)
							{
								// wrong definition of the map
								reportMessage(TN("|no Product definition for this family|"));
								eraseInstance();
								return;
							}
							
							for (int k = 0; k < mapProducts.length(); k++)
							{
								Map mapProductK = mapProducts.getMap(k);
								//								if (mapProductK.hasString("Name") && mapProducts.keyAt(k).makeLower() == "product")
								if (mapProductK.hasString("Description") && mapProducts.keyAt(k).makeLower() == "product")
								{
									//									String sName = mapProductK.getString("Name");
									String sName = mapProductK.getString("Description");
									String sNameProduct = sName;
									sNameProduct = mapFamilyJ.getDouble("Diameter Thread") + "x" + mapProductK.getDouble("Length");
									sName = sNameProduct;
									if (sProducts.find(sName) < 0)
									{
										// populate sProducts
										sProducts.append(sName);
										if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
									}
								}
							}
							
							// set the family
							if (sTokens.length() < 3)
							{
								// Product not set in opm key, show the dialog to get the opm key
								// set array of sProducts and get the first by default
								// family is set, set as readOnly
								sManufacturer.setReadOnly(true);
								sFamily.setReadOnly(true);
								
								sProduct.setReadOnly(false);
								sProduct = PropString(2, sProducts, sProductName, 0);
								sProduct.set(sProducts[0]);
								if (sProducts.length() > 0)sProduct.set(sProducts[1]);
								// Alignment
								sAlignment.setReadOnly(_kHidden);
								dAngle.setReadOnly(false);
								dGapNail.setReadOnly(false);
//								nZone.setReadOnly(_kHidden);
								// distribution
								sModeDistribution.setReadOnly(false);
								dDistanceBottom.setReadOnly(false);
								dDistanceTop.setReadOnly(false);
								dDistanceBetween.setReadOnly(false);
								showDialog("---");
								//						showDialog();
								if (bDebug)reportMessage("\n" + scriptName() + " from dialog ");
								if (bDebug)reportMessage("\n" + scriptName() + " sProduct " + sProduct);
							}
							else
							{
								// see if sTokens[2] is a valid family name as in sFamilys from mapSetting
								int indexSTokens = sProducts.find(sTokens[2]);
								if (indexSTokens >- 1)
								{
									// find
									//				sModel = PropString(1, sModels, sModelName, indexSTokens);
									sProduct.set(sTokens[2]);
									if (bDebug)reportMessage("\n" + scriptName() + " from tokens ");
								}
								else
								{
									// wrong definition in the opmKey, accept the first family from the xml
									reportMessage(TN("|wrong definition of the OPM key|"));
									sProduct.set(sProducts[0]);
									if (sProducts.length() > 0)sProduct.set(sProducts[1]);
								}
							}
							// familys and nails are set
							break;
						}
						// family is set
						break;
					}
					else
					{
						sProduct.set(sProducts[0]);
						if (sProducts.length() > 0)sProduct.set(sProducts[1]);
						break;
					}
				}
			}
		}
		else
		{
			sFamily.set(sFamilys[0]);
			if (sFamilys.length() > 1)sFamily.set(sFamilys[1]);
			sProduct.set(sProducts[0]);
			if (sProducts.length() > 1)sProduct.set(sProducts[1]);
		}
	}
	
//	// prompt selection of walls
//	Entity ents[0];
//	PrEntity ssE(T("|Select walls(s) or Enter to select single beam|"), ElementWallSF());
//	if (ssE.go())
//		ents.append(ssE.set());
	
	if (ents.length() > 0)
	{ 
//		ElementWallSF eWalls[0];
		ElementWall eWalls[0];
		for (int i = 0; i < ents.length(); i++)
		{ 
//			ElementWallSF eWsF = (ElementWallSF)ents[i];
			ElementWall eW = (ElementWall)ents[i];
//			if (eWsF.bIsValid() && eWalls.find(eWsF) < 0)eWalls.append(eWsF);
			if (eW.bIsValid() && eWalls.find(eW) < 0)eWalls.append(eW);
		}//next i
		for (int i=0;i<eWalls.length();i++) 
			_Element.append(eWalls[i]);
		// distribution
		if(eWalls.length()==0)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|no SF Wall|"));
			
		}
	// create TSL
		TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {}; Entity entsTsl[1]; Point3d ptsTsl[] = {_Pt0};
		int nProps[]={nNrResult, nZone };
		double dProps[]={dAngle, dGapNail, dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult, dDiameterDrill, dLengthDrill};
		String sProps[]={sManufacturer, sFamily, sProduct, sAlignment, sModeDistribution, sBeam, sWindowExclude, sDrill};
		Map mapTsl;	
		for (int i=0;i<eWalls.length();i++) 
		{ 
			if ( ! eWalls[i].bIsValid())continue;
			
			entsTsl[0] = eWalls[i];
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
		}//next i
		eraseInstance();
		return;
	}
	else
	{ 
//		_GenBeam.append(getGenBeam(T("|Select Beam, Sheet or Panel|")));
		GenBeam gb = _GenBeam[0];
		assignToLayer("i");
		assignToGroups(Entity(gb));
		// basic information
		Point3d ptCen = gb.ptCen();
		Vector3d vecX = gb.vecX();
		Vector3d vecY = gb.vecY();
		Vector3d vecZ = gb.vecZ();
		int iModeDistribution = sModeDistributions.find(sModeDistribution);
//		String sStringStart = "|Select drill point [";
		String sStringStart = "|Select drill point [";
		String sStringStart2 = "|Select second drill point [";
		String sAlignmentOptions[] ={ "+X", "-X", "+Y", "-Y", "+Z", "-Z"};
		String sClickOptions[] ={ "firstDrill"};
		
//		String sAlignmentOption ="+X/-X/+Y/-Y/+Z/-Z]|";
//		sAlignmentOption = "";
//		String sClickOption="First Drill]|";
		String sClickOption="firstDrill/";
		String sDistributeOptions;
		if(iModeDistribution==0)
		{ 
			sDistributeOptions = "Fixed/";
		}
		else if(iModeDistribution==1)
		{ 
			sDistributeOptions = "eVen/";
		}
		sDistributeOptions += "Start/";
		sDistributeOptions += "End/";
		sDistributeOptions += "Between]|";
//		String sAlignmentOptionCurrent;
//		int iAlignment = sAlignments.find(sAlignment);
//		String sAlignmentOptionsValid[0];
//		for (int i=0;i<sAlignmentOptions.length();i++) 
//		{ 
//			if (i == iAlignment)continue;
//			sAlignmentOptionsValid.append(sAlignmentOptions[i]);
//		}//next i
//		
//		for (int i=0;i<sAlignmentOptionsValid.length()-1;i++) 
//		{ 
//			sAlignmentOption += sAlignmentOptionsValid[i] + "/";
//		}//next i
//		sAlignmentOption += sAlignmentOptionsValid[sAlignmentOptionsValid.length() - 1] + "]|";
//		sAlignmentOptionCurrent = sAlignmentOption;
//		String sStringPrompt = sStringStart + sAlignmentOption;
		// first prompt
//		PrPoint ssP(sStringStart + sAlignmentOption);
		PrPoint ssP(sStringStart+sDistributeOptions);
		// second prompt
//		PrPoint ssP2(sStringStart2 + sAlignmentOption, _Pt0);
		PrPoint ssP2(sStringStart2 + sClickOption+sDistributeOptions, _Pt0);
		
//		String sStringPromptCurrent = sStringPrompt;
		Map mapArgs;
		mapArgs.setString("alignment", sAlignment);
		mapArgs.setString("modeDistribution", sModeDistribution);
		
		Quader qd(ptCen, vecX, vecY, vecZ, gb.solidLength(), gb.solidWidth(), gb.solidHeight());
		mapArgs.setPoint3d("ptCen", ptCen);
		mapArgs.setVector3d("vecX", vecX);
		mapArgs.setVector3d("vecY", vecY);
		mapArgs.setVector3d("vecZ", vecZ);
		mapArgs.setDouble("dLength", gb.solidLength());
		mapArgs.setDouble("dWidth", gb.solidWidth());
		mapArgs.setDouble("dHeight", gb.solidHeight());
		mapArgs.setBody("bdGb", gb.envelopeBody());
		// ///////////
		mapArgs.setDouble("dDiameterThread", U(10));
//		int iSingle = dDistanceBetween == -1 ? true : false;
		int iSingle = false;
		int iFirstPrompt = true;
		int nGoJig = -1;
		Vector3d vecs[] ={ vecX ,- vecX, vecY ,- vecY, vecZ ,- vecZ};
		// prepare dialogbox
		// create a map for each property
		PlaneProfile ppMode, ppModes[0];
		PlaneProfile ppStart, ppEnd, ppBetween;
		Vector3d vecXgraph;
		Vector3d vecYgraph;
		Vector3d vecZgraph;
		Point3d ptStartGraph;
		// 
		Map mapPropsGraph;
		Map mapMode, mapModeOps;
		Map mapStart, mapEnd, mapBetween;
		int iColorSelected = 1;
		{ 
			vecXgraph = _XW;
			vecYgraph = _YW;
			vecZgraph = _ZW;
			ptStartGraph = ptCen;
			
			Map mapPropsCoord;
			mapPropsCoord.setPoint3d("ptStartGraph", ptStartGraph, _kAbsolute);
			mapPropsCoord.setVector3d("vecXgraph", vecXgraph, _kAbsolute);
			mapPropsCoord.setVector3d("vecYgraph", vecYgraph, _kAbsolute);
			mapPropsCoord.setVector3d("vecZgraph", vecZgraph, _kAbsolute);
			double dLengthBox = U(100);
			double dWidthBox = U(70);
			double dGapBox = U(10);
			Point3d pt = ptStartGraph;
			PlaneProfile ppBox(Plane(ptStartGraph, vecZgraph));
			{ 
				PLine pl;
				pl.createRectangle(LineSeg(pt, 
					pt + vecXgraph*dLengthBox - vecYgraph*dWidthBox), vecXgraph, vecYgraph);
				ppBox.joinRing(pl, _kAdd);
			}
			// mapMode
			{ 
//				pt += (dLengthBox + dGapBox) * vecXgraph;
				PlaneProfile pp=ppBox;
				pp.transformBy(pt - ptStartGraph);
				// property name
				mapMode.setPlaneProfile("ppProp", pp);
				ppMode = pp;
				String _sModeDistributionName = T("|Mode\P of \PDistribution|");
				mapMode.setString("txtProp", _sModeDistributionName);
				Point3d ptTxtProp = pt + .5 * dLengthBox * vecXgraph - .5 * dWidthBox * vecYgraph;
				mapMode.setPoint3d("ptTxtProp", ptTxtProp, _kAbsolute);
				
				// Options
				Map mapOps;
				Map mapEven = mapMode;
				PlaneProfile ppI= pp;
				ppI.transformBy(-vecYgraph * (dWidthBox+dGapBox));
				pt.transformBy(-vecYgraph * (dWidthBox+dGapBox));
				Point3d ptTxtOp = pt + .5 * dLengthBox * vecXgraph - .5 * dWidthBox * vecYgraph;
				mapEven.setPlaneProfile("ppOp", ppI);
				int iColorOp = 252;
				if (iModeDistribution == 0)iColorOp = iColorSelected;
				mapEven.setPoint3d("ptTxtOp", ptTxtOp, _kAbsolute);
				mapEven.setString("txtOp", T("|Even|"));
				mapEven.setInt("colorOp", iColorOp);
				ppModes.append(ppI);
				mapOps.appendMap("mapOp", mapEven);
				Map mapFixed=mapMode;
				ppI.transformBy(-vecYgraph * (dWidthBox+dGapBox));
				pt.transformBy(-vecYgraph * (dWidthBox+dGapBox));
				ptTxtOp = pt + .5 * dLengthBox * vecXgraph - .5 * dWidthBox * vecYgraph;
				iColorOp = 252;
				if (iModeDistribution == 1)iColorOp = iColorSelected;
				mapFixed.setPlaneProfile("ppOp", ppI);
				mapFixed.setPoint3d("ptTxtOp", ptTxtOp, _kAbsolute);
				mapFixed.setString("txtOp", T("|Fixed|"));
				mapFixed.setInt("colorOp", iColorOp);
				ppModes.append(ppI);
				mapOps.appendMap("mapOp", mapFixed);
				//
				mapModeOps = mapOps;
				mapMode.setMap("mapOps", mapOps);
				mapPropsGraph.appendMap("mapProp", mapMode);
			}
			// mapStart;
			{ 
				pt = ptStartGraph + vecXgraph*1*(dLengthBox + dGapBox);
				PlaneProfile pp=ppBox;
				pp.transformBy(pt - ptStartGraph);
				mapStart.setPlaneProfile("ppProp", pp);
				ppStart = pp;
				String _sDistanceBottomName = T("|Start \P Distance|")+"\P"+dDistanceBottom;
				mapStart.setString("txtProp", _sDistanceBottomName);
				Point3d ptTxtProp = pt + .5 * dLengthBox * vecXgraph - .5 * dWidthBox * vecYgraph;
				mapStart.setPoint3d("ptTxtProp", ptTxtProp, _kAbsolute);
				mapPropsGraph.appendMap("mapProp", mapStart);
			}
			// mapEnd;
			{ 
				pt = ptStartGraph + vecXgraph*2*(dLengthBox + dGapBox);
				PlaneProfile pp=ppBox;
				pp.transformBy(pt - ptStartGraph);
				mapEnd.setPlaneProfile("ppProp", pp);
				ppEnd = pp;
				String _sDistanceTopName = T("|End \P Distance|")+"\P"+dDistanceTop;
				mapEnd.setString("txtProp", _sDistanceTopName);
				Point3d ptTxtProp = pt + .5 * dLengthBox * vecXgraph - .5 * dWidthBox * vecYgraph;
				mapEnd.setPoint3d("ptTxtProp", ptTxtProp, _kAbsolute);
				mapPropsGraph.appendMap("mapProp", mapEnd);
			}
			// mapBetween;
			{ 
				pt = ptStartGraph + vecXgraph*3*(dLengthBox + dGapBox);
				PlaneProfile pp=ppBox;
				pp.transformBy(pt - ptStartGraph);
				mapBetween.setPlaneProfile("ppProp", pp);
				ppBetween = pp;
				String _sDistanceTopName = T("|Between \P Distance|")+"\P"+dDistanceBetween;
				mapBetween.setString("txtProp", _sDistanceTopName);
				Point3d ptTxtProp = pt + .5 * dLengthBox * vecXgraph - .5 * dWidthBox * vecYgraph;
				mapBetween.setPoint3d("ptTxtProp", ptTxtProp, _kAbsolute);
				mapPropsGraph.appendMap("mapProp", mapBetween);
			}
			mapArgs.setMap("mapProps", mapPropsGraph);
			mapArgs.setMap("mapPropsCoord", mapPropsCoord);
			
		}
		while (nGoJig != _kOk && nGoJig != _kNone)
		{
			if(iFirstPrompt)
			{
				nGoJig = ssP.goJig(strJigAction1, mapArgs);
			}
			else
			{
				nGoJig = ssP2.goJig(strJigAction1, mapArgs);
			}
			
			if (nGoJig == _kOk)
			{ 
				
				// original coord
				//
				double dHview = getViewHeight();
				Vector3d vecXview = getViewDirection(0)*.001*dHview;
				Vector3d vecYview = getViewDirection(1)*.001*dHview;
				Vector3d vecZview = getViewDirection(2)*.001*dHview;
				Point3d ptStartGraphView = ptStartGraph;
				// set the point outside of genbeam
				{ 
					PlaneProfile ppGb = gb.envelopeBody().shadowProfile(Plane(ptStartGraph, vecZview));
					ppGb.shrink(-U(20));
					// get extents of profile
					LineSeg seg = ppGb.extentInDir(vecXview);
					ptStartGraphView = seg.ptEnd();
				}
				CoordSys csGraphTransform;
				csGraphTransform.setToAlignCoordSys(ptStartGraph,vecXgraph,vecYgraph,vecZgraph,
							ptStartGraphView, vecXview, vecYview, vecZview);
				int iGraphClick;
				
//				_Pt0 = ssP.value(); //retrieve the selected point
//				_PtG.append(ptLast); //append the selected points to the list of grippoints _PtG
				Point3d ptJig;
				if(iFirstPrompt)
					ptJig= ssP.value();
				else
					ptJig= ssP2.value();
				
				PlaneProfile ppModeTransform = ppMode;
				ppModeTransform.transformBy(csGraphTransform);
				if(ppModeTransform.pointInProfile(ptJig)==_kPointInProfile)
				{
					iGraphClick = true;
					nGoJig = -1;
					continue;
				}
				Map mapModeOpsNew;
				for (int iM=0;iM<ppModes.length();iM++) 
				{ 
					PlaneProfile ppModesTransformI = ppModes[iM];
					ppModesTransformI.transformBy(csGraphTransform);
					if(ppModesTransformI.pointInProfile(ptJig)==_kPointInProfile)
					{
						iGraphClick = true;
						sModeDistribution.set(sModeDistributions[iM]);
						for (int iiM=0;iiM<mapModeOps.length();iiM++) 
						{ 
							Map mapI = mapModeOps.getMap(iiM); 
							if(iiM!=iM)
							{ 
								//
								mapI.setInt("colorOp", 252);
								mapModeOpsNew.appendMap("mapOp", mapI);
							}
							else
							{ 
								//
								mapI.setInt("colorOp", iColorSelected);
								mapModeOpsNew.appendMap("mapOp", mapI);
							}
						}//next iiM
						// update ssP
						String sDistributeOptions;
						int iModeDistribution=sModeDistributions.find(sModeDistribution);
						if(iModeDistribution==0)
						{ 
							sDistributeOptions = "Fixed/";
						}
						else if(iModeDistribution==1)
						{ 
							sDistributeOptions = "eVen/";
						}
						sDistributeOptions += "Start/";
						sDistributeOptions += "End/";
						sDistributeOptions += "Between]|";
						ssP=PrPoint(sStringStart+sDistributeOptions);
						ssP2=PrPoint(sStringStart2+sClickOption+sDistributeOptions, _Pt0);
						//
						nGoJig = -1;
						// continue for loop
//						continue;
						break;
					}
				}//next iM
				if (iGraphClick)
				{
					mapMode.setMap("mapOps", mapModeOpsNew);
					Map mapPropsGraphNew;
					for (int iM=0;iM<mapPropsGraph.length();iM++) 
					{ 
						if(iM==0)
						{ 
							mapPropsGraphNew.appendMap("mapProp", mapMode);
						}
						else
						{ 
							Map mm = mapPropsGraph.getMap(iM);
							mapPropsGraphNew.appendMap("mapProp", mm);
						}
					}//next iM
					
//					mapPropsGraph.appendMap("mapProp", mapMode);
					mapPropsGraph = mapPropsGraphNew;
					mapArgs.setMap("mapProps", mapPropsGraph);
					nGoJig = -1;
					continue;
				}
				PlaneProfile ppStartTransform = ppStart;
				ppStartTransform.transformBy(csGraphTransform);
				if(ppStartTransform.pointInProfile(ptJig)==_kPointInProfile)
				{
					String sEnter = getString(TN("|Enter Start Distance|")+" "+dDistanceBottom);
					dDistanceBottom.set(sEnter.atof());
					Map mapStartNew = mapStart;
					String _sDistanceBottomName = T("|Start \P Distance|")+"\P"+dDistanceBottom;
					mapStartNew.setString("txtProp", _sDistanceBottomName);
					Map mapPropsGraphNew;
					for (int iM=0;iM<mapPropsGraph.length();iM++) 
					{ 
						if(iM==1)
						{ 
							mapPropsGraphNew.appendMap("mapProp", mapStartNew);
						}
						else
						{ 
							Map mm = mapPropsGraph.getMap(iM);
							mapPropsGraphNew.appendMap("mapProp", mm);
						}
						 
					}//next iM
					mapPropsGraph = mapPropsGraphNew;
					mapArgs.setMap("mapProps", mapPropsGraph);
					iGraphClick = true;
					nGoJig = -1;
					// next while loop
					continue;
				}
				PlaneProfile ppEndTransform = ppEnd;
				ppEndTransform.transformBy(csGraphTransform);
				if(ppEndTransform.pointInProfile(ptJig)==_kPointInProfile)
				{
					String sEnter = getString(TN("|Enter End Distance|")+" "+dDistanceTop);
					dDistanceTop.set(sEnter.atof());
					Map mapEndNew = mapEnd;
					String _sDistanceTopName = T("|End \P Distance|")+"\P"+dDistanceTop;
					mapEndNew.setString("txtProp", _sDistanceTopName);
					Map mapPropsGraphNew;
					for (int iM=0;iM<mapPropsGraph.length();iM++) 
					{ 
						if(iM==2)
						{ 
							mapPropsGraphNew.appendMap("mapProp", mapEndNew);
						}
						else
						{ 
							Map mm = mapPropsGraph.getMap(iM);
							mapPropsGraphNew.appendMap("mapProp", mm);
						}
					}//next iM
					mapPropsGraph = mapPropsGraphNew;
					mapArgs.setMap("mapProps", mapPropsGraph);
					iGraphClick = true;
					nGoJig = -1;
					// next while loop
					continue;
				}
				PlaneProfile ppBetweenTransform = ppBetween;
				ppBetweenTransform.transformBy(csGraphTransform);
				if(ppBetweenTransform.pointInProfile(ptJig)==_kPointInProfile)
				{
					String sEnter = getString(TN("|Enter Between Distance|")+" "+dDistanceBetween);
					dDistanceBetween.set(sEnter.atof());
					Map mapBetweenNew = mapBetween;
					String _sDistanceBetweenName = T("|Between \P Distance|")+"\P"+dDistanceBetween;
					mapBetweenNew.setString("txtProp", _sDistanceBetweenName);
					Map mapPropsGraphNew;
					for (int iM=0;iM<mapPropsGraph.length();iM++) 
					{ 
						if(iM==3)
						{ 
							mapPropsGraphNew.appendMap("mapProp", mapBetweenNew);
						}
						else
						{ 
							Map mm = mapPropsGraph.getMap(iM);
							mapPropsGraphNew.appendMap("mapProp", mm);
						}
					}//next iM
					mapPropsGraph = mapPropsGraphNew;
					mapArgs.setMap("mapProps", mapPropsGraph);
					iGraphClick = true;
					nGoJig = -1;
					// next while loop
					continue;
				}
				Vector3d vecViewdirection = getViewDirection();
				Vector3d vecAlign = qd.vecD(vecViewdirection);
				for (int iV=0;iV<vecs.length();iV++) 
				{ 
					if(vecs[iV].isCodirectionalTo(vecAlign))
					{ 
						sAlignment.set(sAlignments[iV]);
						break;
					}
					 
				}//next iV
				
				int iAlignment = sAlignments.find(sAlignment);
				
//				Vector3d vecViewdirection = getViewDirection();
				
				Vector3d vecPlane = vecs[iAlignment];
				Vector3d vecXplane, vecYplane;
				Plane pn(ptCen + vecPlane * .5 * qd.dD(vecPlane), vecPlane);
				
				Vector3d vecsMain[] ={ vecX, vecY, vecZ};
				for (int i=0;i<vecsMain.length();i++) 
				{ 
					if(!vecPlane.isParallelTo(vecsMain[i]))
					{ 
						vecXplane = vecsMain[i];
						break;
					}
				}//next i
				vecYplane = vecPlane.crossProduct(vecXplane);
				
				Point3d ptJigPlane = ptJig.projectPoint(pn, dEps, vecViewdirection);
//				Point3d ptJigPlane = pn.closestPointTo(ptJig);
				// update request if changed
				String sDistributeOptions;
				int iModeDistribution=sModeDistributions.find(sModeDistribution);
				if(iModeDistribution==0)
				{ 
					sDistributeOptions = "Fixed/";
				}
				else if(iModeDistribution==1)
				{ 
					sDistributeOptions = "eVen/";
				}
				sDistributeOptions += "Start/";
				sDistributeOptions += "End/";
				sDistributeOptions += "Between]|";
				ssP=PrPoint(sStringStart+sDistributeOptions);
				if(iFirstPrompt)
				{ 
					mapArgs.setPoint3d("ptJig0", ptJigPlane);
					_Pt0 = ptJigPlane;
					
					if(!iSingle)
					{ 
						// not single distance, distribution
						iFirstPrompt = false;
//						ssP2 = PrPoint(sStringStart2+sAlignmentOptionCurrent, _Pt0);
						ssP2 = PrPoint(sStringStart2+sClickOption+sDistributeOptions, _Pt0);
						nGoJig = -1;
					}
				}
				else
				{ 
					mapArgs.setPoint3d("ptJig1", ptJigPlane);
					_PtG.append(ptJigPlane);
				}
				
	            _Map.setMap("mapJig", mapArgs );
			}
			else if (nGoJig == _kKeyWord)
			{
				int iIndex = -1;
				if(iFirstPrompt)
					iIndex= ssP.keywordIndex();
				else
					iIndex= ssP2.keywordIndex();
				if (iIndex >= 0)
				{ 
					int iModeDistribution = sModeDistributions.find(sModeDistribution);
					if(iFirstPrompt)
					{
						String sDistributeOptions;
						// its prompt for first point
						if(ssP.keywordIndex()==0)
						{ 
							if(iModeDistribution==0)
							{ 
								sModeDistribution.set(sModeDistributions[1]);
								sDistributeOptions = "eVen/";
							}
							else
							{ 
								sModeDistribution.set(sModeDistributions[0]);
								sDistributeOptions = "Fixed/";
							}
							sDistributeOptions += "Start/";
							sDistributeOptions += "End/";
							sDistributeOptions += "Between]|";
							ssP=PrPoint(sStringStart+sDistributeOptions);
							// update map of graphics
							Map mapModeOpsNew;
							for (int iiM=0;iiM<mapModeOps.length();iiM++) 
							{ 
								Map mapI = mapModeOps.getMap(iiM); 
								if(iiM==iModeDistribution)
								{ 
									//
									mapI.setInt("colorOp", 252);
									mapModeOpsNew.appendMap("mapOp", mapI);
								}
								else
								{ 
									//
									mapI.setInt("colorOp", iColorSelected);
									mapModeOpsNew.appendMap("mapOp", mapI);
								}
							}//next iiM
							mapMode.setMap("mapOps", mapModeOpsNew);
							Map mapPropsGraphNew;
							for (int iM=0;iM<mapPropsGraph.length();iM++) 
							{ 
								if(iM==0)
								{ 
									mapPropsGraphNew.appendMap("mapProp", mapMode);
								}
								else
								{ 
									Map mm = mapPropsGraph.getMap(iM);
									mapPropsGraphNew.appendMap("mapProp", mm);
								}
							}//next iM
							mapPropsGraph = mapPropsGraphNew;
							mapArgs.setMap("mapProps", mapPropsGraph);
						}
						else if(ssP.keywordIndex()==1)
						{ 
							String sEnter = getString(TN("|Enter Start Distance|")+" "+dDistanceBottom);
							dDistanceBottom.set(sEnter.atof());
							// update map
							Map mapStartNew = mapStart;
							String _sDistanceBottomName = T("|Start \P Distance|")+"\P"+dDistanceBottom;
							mapStartNew.setString("txtProp", _sDistanceBottomName);
							Map mapPropsGraphNew;
							for (int iM=0;iM<mapPropsGraph.length();iM++) 
							{ 
								if(iM==1)
								{ 
									mapPropsGraphNew.appendMap("mapProp", mapStartNew);
								}
								else
								{ 
									Map mm = mapPropsGraph.getMap(iM);
									mapPropsGraphNew.appendMap("mapProp", mm);
								}
								 
							}//next iM
							mapPropsGraph = mapPropsGraphNew;
							mapArgs.setMap("mapProps", mapPropsGraph);
						}
						else if(ssP.keywordIndex()==2)
						{ 
							String sEnter = getString(TN("|Enter End Distance|")+" "+dDistanceTop);
							dDistanceTop.set(sEnter.atof());
							// update map
							Map mapEndNew = mapEnd;
							String _sDistanceTopName = T("|End \P Distance|")+"\P"+dDistanceTop;
							mapEndNew.setString("txtProp", _sDistanceTopName);
							Map mapPropsGraphNew;
							for (int iM=0;iM<mapPropsGraph.length();iM++) 
							{ 
								if(iM==2)
								{ 
									mapPropsGraphNew.appendMap("mapProp", mapEndNew);
								}
								else
								{ 
									Map mm = mapPropsGraph.getMap(iM);
									mapPropsGraphNew.appendMap("mapProp", mm);
								}
							}//next iM
							mapPropsGraph = mapPropsGraphNew;
							mapArgs.setMap("mapProps", mapPropsGraph);
						}
						else if(ssP.keywordIndex()==3)
						{ 
							String sEnter = getString(TN("|Enter Between Distance|")+" "+dDistanceBetween);
							dDistanceBetween.set(sEnter.atof());
							// update map
							Map mapBetweenNew = mapBetween;
							String _sDistanceBetweenName = T("|Between \P Distance|")+"\P"+dDistanceBetween;
							mapBetweenNew.setString("txtProp", _sDistanceBetweenName);
							Map mapPropsGraphNew;
							for (int iM=0;iM<mapPropsGraph.length();iM++) 
							{ 
								if(iM==3)
								{ 
									mapPropsGraphNew.appendMap("mapProp", mapBetweenNew);
								}
								else
								{ 
									Map mm = mapPropsGraph.getMap(iM);
									mapPropsGraphNew.appendMap("mapProp", mm);
								}
							}//next iM
							mapPropsGraph = mapPropsGraphNew;
							mapArgs.setMap("mapProps", mapPropsGraph);
						}
					}
					else
					{ 
						String sDistributeOptions;
						// prompt for seond point
						if(ssP2.keywordIndex()==0)
						{ 
							mapArgs.removeAt("ptJig0",true);
							iFirstPrompt = true;
							if(iModeDistribution==0)
							{ 
								sDistributeOptions = "Fixed/";
							}
							else
							{ 
								sDistributeOptions = "eVen/";
							}
							sDistributeOptions += "Start/";
							sDistributeOptions += "End/";
							sDistributeOptions += "Between]|";
							ssP=PrPoint(sStringStart+sDistributeOptions);
							nGoJig = -1;
						}
						else if(ssP2.keywordIndex()==1)
						{ 
							if(iModeDistribution==0)
							{ 
								sModeDistribution.set(sModeDistributions[1]);
								sDistributeOptions = "eVen/";
							}
							else
							{ 
								sModeDistribution.set(sModeDistributions[0]);
								sDistributeOptions = "Fixed/";
							}
							sDistributeOptions += "Start/";
							sDistributeOptions += "End/";
							sDistributeOptions += "Between]|";
							ssP2=PrPoint(sStringStart2+sClickOption+sDistributeOptions, _Pt0);
							// update map of graphics
							Map mapModeOpsNew;
							for (int iiM=0;iiM<mapModeOps.length();iiM++) 
							{ 
								Map mapI = mapModeOps.getMap(iiM); 
								if(iiM==iModeDistribution)
								{ 
									//
									mapI.setInt("colorOp", 252);
									mapModeOpsNew.appendMap("mapOp", mapI);
								}
								else
								{ 
									//
									mapI.setInt("colorOp", iColorSelected);
									mapModeOpsNew.appendMap("mapOp", mapI);
								}
							}//next iiM
							mapMode.setMap("mapOps", mapModeOpsNew);
							Map mapPropsGraphNew;
							for (int iM=0;iM<mapPropsGraph.length();iM++) 
							{ 
								if(iM==0)
								{ 
									mapPropsGraphNew.appendMap("mapProp", mapMode);
								}
								else
								{ 
									Map mm = mapPropsGraph.getMap(iM);
									mapPropsGraphNew.appendMap("mapProp", mm);
								}
							}//next iM
							mapPropsGraph = mapPropsGraphNew;
							mapArgs.setMap("mapProps", mapPropsGraph);
						}
						else if(ssP2.keywordIndex()==2)
						{ 
							String sEnter = getString(TN("|Enter Start Distance|")+" "+dDistanceBottom);
							dDistanceBottom.set(sEnter.atof());
							// update map
							Map mapStartNew = mapStart;
							String _sDistanceBottomName = T("|Start \P Distance|")+"\P"+dDistanceBottom;
							mapStartNew.setString("txtProp", _sDistanceBottomName);
							Map mapPropsGraphNew;
							for (int iM=0;iM<mapPropsGraph.length();iM++) 
							{ 
								if(iM==1)
								{ 
									mapPropsGraphNew.appendMap("mapProp", mapStartNew);
								}
								else
								{ 
									Map mm = mapPropsGraph.getMap(iM);
									mapPropsGraphNew.appendMap("mapProp", mm);
								}
								 
							}//next iM
							mapPropsGraph = mapPropsGraphNew;
							mapArgs.setMap("mapProps", mapPropsGraph);
						}
						else if(ssP2.keywordIndex()==3)
						{ 
							String sEnter = getString(TN("|Enter End Distance|")+" "+dDistanceTop);
							dDistanceTop.set(sEnter.atof());
							// update map
							Map mapEndNew = mapEnd;
							String _sDistanceTopName = T("|End \P Distance|")+"\P"+dDistanceTop;
							mapEndNew.setString("txtProp", _sDistanceTopName);
							Map mapPropsGraphNew;
							for (int iM=0;iM<mapPropsGraph.length();iM++) 
							{ 
								if(iM==2)
								{ 
									mapPropsGraphNew.appendMap("mapProp", mapEndNew);
								}
								else
								{ 
									Map mm = mapPropsGraph.getMap(iM);
									mapPropsGraphNew.appendMap("mapProp", mm);
								}
							}//next iM
							mapPropsGraph = mapPropsGraphNew;
							mapArgs.setMap("mapProps", mapPropsGraph);
						}
						else if(ssP2.keywordIndex()==4)
						{ 
							String sEnter = getString(TN("|Enter Between Distance|")+" "+dDistanceBetween);
							dDistanceBetween.set(sEnter.atof());
							// update map
							Map mapBetweenNew = mapBetween;
							String _sDistanceBetweenName = T("|Between \P Distance|")+"\P"+dDistanceBetween;
							mapBetweenNew.setString("txtProp", _sDistanceBetweenName);
							Map mapPropsGraphNew;
							for (int iM=0;iM<mapPropsGraph.length();iM++) 
							{ 
								if(iM==3)
								{ 
									mapPropsGraphNew.appendMap("mapProp", mapBetweenNew);
								}
								else
								{ 
									Map mm = mapPropsGraph.getMap(iM);
									mapPropsGraphNew.appendMap("mapProp", mm);
								}
							}//next iM
							mapPropsGraph = mapPropsGraphNew;
							mapArgs.setMap("mapProps", mapPropsGraph);
						}
					}
				}
			}
			else if (nGoJig == _kCancel)
	        { 
	            eraseInstance(); // do not insert this instance
	            return; 
	        }
		}
		return;
	}
	return;
}
// end on insert	__________________//endregion

//region mapIO: support property dialog input via map on element creation
	{
		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPINT[]") && _Map.hasMap("PROPDOUBLE[]");
		if (_bOnMapIO)
		{ 
			if (bHasPropertyMap)
				setPropValuesFromMap(_Map);	
			showDialog();
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

Map mapManufacturer;
Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
if(sManufacturer!="---")
{ 
	// get mapManufacturer
	for (int i = 0; i < mapManufacturers.length(); i++)
	{ 
		Map mapManufacturerI = mapManufacturers.getMap(i);
		if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
		{
			String _sManufacturerName = mapManufacturerI.getString("Name");
			String _sManufacturer = sManufacturer;_sManufacturer.makeUpper();
			if (_sManufacturerName.makeUpper() != _sManufacturer)
			{
				continue;
			}
		}
		else
		{ 
			// not a manufacturer map
			continue;
		}
		mapManufacturer = mapManufacturers.getMap(i);
		break;
	}
	// set family and product
//	int indexManufacturer = sManufacturers.find(sManufacturer);
	Map mapFamilys = mapManufacturer.getMap("Family[]");
	sFamilys.setLength(0);
	sFamilys.append("---");
	for (int i = 0; i < mapFamilys.length(); i++)
	{
		Map mapFamilyI = mapFamilys.getMap(i);
		if (mapFamilyI.hasString("Name") && mapFamilys.keyAt(i).makeLower() == "family")
		{
			String sName = mapFamilyI.getString("Name");
			if (sFamilys.find(sName) < 0)
			{
				// populate sFamilys with all the sFamilys of the selected manufacturer
				sFamilys.append(sName);
			}
		}
	}
	int indexFamily = sFamilys.find(sFamily);
	if (indexFamily >- 1 )
	{
		// selected sFamily contained in sFamilys
		sFamily = PropString(1, sFamilys, sFamilyName, indexFamily);
//			sFamily.set(sFamilys[indexFamily]);
		if(sManufacturer!="---"&& indexFamily==0 && _kNameLastChangedProp==sManufacturerName)
		{
			sFamily.set(sFamilys[1]);
//					sFamily = PropString(1, sFamilys, sFamilyName, 1);
		}
	}
	else
	{
		// existing sFamily is not found, Family has been changed so set 
		// to sFamily the first Family from sFamilys
		sFamily = PropString(1, sFamilys, sFamilyName, 1);
		sFamily.set(sFamilys[1]);
	}
	if (sFamily != "---")
	{ 
		// get map of Family
		Map mapFamily;
		for (int i = 0; i < mapFamilys.length(); i++)
		{ 
			Map mapFamilyI = mapFamilys.getMap(i);
			if (mapFamilyI.hasString("Name") && mapFamilys.keyAt(i).makeLower() == "family")
			{
				String _sFamilyName = mapFamilyI.getString("Name");
				String _sFamily = sFamily;_sFamily.makeUpper();
				if (_sFamilyName.makeUpper() != _sFamily)
				{
					continue;
				}
			}
			else
			{ 
				// not a manufacturer map
				continue;
			}
			mapFamily = mapFamilys.getMap(i);
			break;
		}
// set Type
		Map mapProducts = mapFamily.getMap("Product[]");
		sProducts.setLength(0);
		for (int i = 0; i < mapProducts.length(); i++)
		{
			Map mapProductI = mapProducts.getMap(i);
//			if (mapProductI.hasString("Name") && mapProducts.keyAt(i).makeLower() == "product")
			if (mapProductI.hasString("Description") && mapProducts.keyAt(i).makeLower() == "product")
			{
//				String sName = mapProductI.getString("Name");
				String sName = mapProductI.getString("Description");
				String sNameProduct = sName;
				sNameProduct = mapFamily.getDouble("Diameter Thread") + "x" + mapProductI.getDouble("Length");
				sName = sNameProduct;
				if (sProducts.find(sName) < 0)
				{
					// populate sProducts with all the sProducts of the selected categry
					sProducts.append(sName);
				}
			}
		}
		int indexProduct = sProducts.find(sProduct);
		if (indexProduct >- 1)
		{
			// selected sModelis contained in sModels
			sProduct = PropString(2, sProducts, sProductName, indexProduct);
			if(sFamily!="---"&& indexProduct==0 && (_kNameLastChangedProp==sManufacturerName || _kNameLastChangedProp==sFamilyName))
			{
				sProduct.set(sProducts[0]);
//					sProduct = PropString(2, sProducts, sProductName, 1);
			}
		}
		else
		{
			// existing sModel is not found, Product has been changed so set 
			// to sModel the first Model from sModels
			sProduct = PropString(2, sProducts, sProductName, 0);
			sProduct.set(sProducts[0]);
		}
	}
	else
	{ 
		sProducts.setLength(0);
		sProducts.append("---");
		sProduct = PropString(2, sProducts, sProductName, 0);
		sProduct.set(sProducts[0]);
	}
}
else
{ 
	sFamilys.setLength(0);
	sFamilys.append("---");
	
	sFamily = PropString(1, sFamilys, sFamilyName, 0);
	sFamily.set(sFamilys[0]);
	sProducts.setLength(0);
	sProducts.append("---");
	sProduct = PropString(2, sProducts, sProductName, 0);
	sProduct.set(sProducts[0]);
}

// get map of the selected product
Map mapFamily;
Map mapProduct;
int iFamilyFound = false;
int iProductFound = false;
{ 
	Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
	if(sManufacturer!="---")
	{ 
		for (int i = 0; i < mapManufacturers.length(); i++)
		{ 
			Map mapManufacturerI = mapManufacturers.getMap(i);
			if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
			{
				String _sManufacturerName = mapManufacturerI.getString("Name");
				String _sManufacturer = sManufacturer;_sManufacturer.makeUpper();
				if (_sManufacturerName.makeUpper() == _sManufacturer)
				{
					// this manufacturer
					Map mapManufacturer = mapManufacturerI;
					Map mapFamilys = mapManufacturer.getMap("Family[]");
					for (int ii = 0; ii < mapFamilys.length(); ii++)
					{
						Map mapFamilyI = mapFamilys.getMap(ii);
						if (mapFamilyI.hasString("Name") && mapFamilys.keyAt(ii).makeLower() == "family")
						{
//							String sName = mapFamilyI.getString("Name");
							String _sFamilyName = mapFamilyI.getString("Name");
							String _sFamily = sFamily;_sFamily.makeUpper();
							if (_sFamilyName.makeUpper() == _sFamily)
							{ 
								// this family
								mapFamily = mapFamilyI;
								iFamilyFound = true;
								Map mapProducts = mapFamily.getMap("Product[]");
								for (int iii = 0; iii < mapProducts.length(); iii++)
								{ 
									Map mapProductI = mapProducts.getMap(iii);
//									if (mapProductI.hasString("Name") && mapProducts.keyAt(iii).makeLower() == "product")
									if (mapProductI.hasString("Description") && mapProducts.keyAt(iii).makeLower() == "product")
									{ 
//										String sName = mapProductI.getString("Name");
//										String sName = mapProductI.getString("Description");
//										String _sProductName = mapProductI.getString("Name");
										String _sProductName = mapProductI.getString("Description");
										String sNameProduct = _sProductName;
										sNameProduct = mapFamily.getDouble("Diameter Thread") + "x" + mapProductI.getDouble("Length");
										_sProductName = sNameProduct;
										String _sProduct = sProduct;_sProduct.makeUpper();
										if (_sProductName.makeUpper() == _sProduct)
										{ 
											mapProduct = mapProductI;
											iProductFound = true;
											break;
										}
									}
								}
								if (iProductFound)break;
							}
						}
					}
					if (iProductFound)break;
				}
			}
		}
	}
}
double dLengthScrew;
double dDiameterThread;
// head of nail
double dLengthHead;
double dDiameterHead;
// URL
String sUrl, sArticleNr;
if(iProductFound)
{
	String s;
	s = "Length"; if(mapProduct.hasDouble(s))dLengthScrew = mapProduct.getDouble(s);
	s = "ArticleNumber"; if(mapProduct.hasString(s))sArticleNr = mapProduct.getString(s);
}
if(iFamilyFound)
{
	String s;
	s="Diameter Thread"; if(mapFamily.hasDouble(s))dDiameterThread= mapFamily.getDouble(s);
	s="Diameter Head"; if(mapFamily.hasDouble(s))dDiameterHead= mapFamily.getDouble(s);
	s="Length Head"; if(mapFamily.hasDouble(s))dLengthHead= mapFamily.getDouble(s);
	s="url"; if(mapFamily.hasString(s))sUrl= mapFamily.getString(s);
}
//return;
if(_Element.length()==1)
{ 
	// create instances for element
//	Element eSf = (ElementWallSF)_Element[0];
	Element eSf = (ElementWall)_Element[0];
	if ( ! eSf.bIsValid())
	{
//		reportMessage(TN("|no valid stick frame wall|"));
		reportMessage("\n"+scriptName()+" "+T("|no valid wall element|"));
		eraseInstance();
		return;
	}
	Point3d ptOrg = eSf.ptOrg();
	Vector3d vecX = eSf.vecX();
	Vector3d vecY = eSf.vecY();
	Vector3d vecZ = eSf.vecZ();
	CoordSys csEl = eSf.coordSys();
	ElemZone eZone0 = eSf.zone(0);
	// on side of zone -1
	Point3d ptStartZone0 = eZone0.ptOrg();
	// on side of zone 1
	Point3d ptEndZone0 = eZone0.ptOrg() + eZone0.vecZ()*eZone0.dH();
//	double dZone0H=eZone0.dH();
//	double dBeamWidth=eSf.dBeamWidth();
	if(eZone0.dH()==0)
		ptEndZone0 = eZone0.ptOrg() + eZone0.vecZ()*eSf.dBeamWidth();
	
	Beam beams[] = eSf.beam();
	Beam beamsHor[] = vecY.filterBeamsPerpendicularSort(beams);
	Beam beamsVer[] = vecX.filterBeamsPerpendicularSort(beams);
	if(beams.length()==0)
	{ 
		return;
	}
//	if(eSf.dBeamWidth()==0)
//		ptEndZone0 = eZone0.ptOrg() + eZone0.vecZ()*beams[0].dD(vecZ);
	Point3d ptMiddleZone0 = .5 * (ptStartZone0+ptEndZone0);
	if(eSf.dBeamWidth()==0 && eZone0.dH()==0)
		ptMiddleZone0 += vecZ * vecZ.dotProduct(beams[0].ptCen() - ptMiddleZone0);
//	ptStartZone0.vis(1);
//	ptEndZone0.vis(1);
	ptMiddleZone0.vis(1);
	ptOrg.vis(2);
//	_Pt0 = ptOrg;
	Opening ops[] = eSf.opening();
	Opening opsWindow[0], opsDoor[0];
	for (int i=0;i<ops.length();i++) 
	{ 
		Opening opI = ops[i];
		PLine plShapeOpI = opI.plShape();
		PlaneProfile ppOpI(csEl);
		ppOpI.joinRing(plShapeOpI, _kAdd);
//		ppOpI.shrink(-U(20));
		ppOpI.vis(2);
		
		LineSeg segOp = ppOpI.extentInDir(vecX);
		Point3d ptCenOp = segOp.ptMid();
		ptCenOp += vecZ * vecZ.dotProduct(ptMiddleZone0 - ptCenOp);
		ptCenOp.vis(1);
		Beam beamsBottomOp[] = Beam().filterBeamsHalfLineIntersectSort(beamsHor, ptCenOp, -vecY);
		if(beamsBottomOp.length()>0)
		{ 
			int iWindow;
			for (int iB=0;iB<beamsBottomOp.length();iB++) 
			{ 
				String sBmType = _BeamTypes[beamsBottomOp[iB].type()];
				int iSill = _kSill;
				if( beamsBottomOp[iB].type()==_kSill)
				{ 
					opsWindow.append(ops[i]);
					iWindow = true;
					break;
				}
			}//next iB
			if (iWindow)continue;
			opsDoor.append(ops[i]);
		}
	}//next i
//	return;
	// create TSL
	TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
	GenBeam gbsTsl[1]; Entity entsTsl[] = {}; Point3d ptsTsl[2];
	int nProps[]={nNrResult, nZone};
	double dProps[]={dAngle, dGapNail, dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult, dDiameterDrill, dLengthDrill};
	String sProps[]={sManufacturer, sFamily, sProduct, sAlignment, sModeDistribution, sBeam, sWindowExclude, sDrill};
	Map mapTsl;
	
	Beam bmTopPlate, bmBottomPlate;
	PlaneProfile ppEnvelope = eSf.plEnvelope();
	ppEnvelope.vis(3);
	{ 
	// get extents of profile
		LineSeg seg = ppEnvelope.extentInDir(vecX);
		Point3d ptView = seg.ptMid();
		ptView += vecZ * vecZ.dotProduct(ptMiddleZone0 - ptView);
		ptView.vis(5);
		Beam beamsTop[] = Beam().filterBeamsHalfLineIntersectSort(beamsHor, ptView, vecY);
		if(beamsTop.length()>0)
			bmTopPlate = beamsTop[beamsTop.length() - 1];
		
		Beam beamsBottom[] = Beam().filterBeamsHalfLineIntersectSort(beamsHor, ptView, -vecY);
		if(beamsBottom.length()>0)
			bmBottomPlate = beamsBottom[beamsBottom.length() - 1];
	}
	
	int iBeam = sBeams.find(sBeam);
	int iBeamTop = (iBeam == 0 || iBeam == 2);
	int iBeamBottom = (iBeam == 1 || iBeam == 2);
	
	if(iBeamTop)
	{ 
		// distribution for top beam
		// basic information
		Beam bmI = bmTopPlate;
		Point3d ptCen0 = bmI.ptCen();
		Vector3d vecX0 = bmI.vecX();
		Vector3d vecY0 = bmI.vecY();
		Vector3d vecZ0 = bmI.vecZ();
		
		Vector3d vecXdistribution = vecY.crossProduct(eZone0.vecZ());
		
		Point3d ptStart = ptCen0 - .5*vecXdistribution * bmI.solidLength();
		ptStart -= bmI.vecD(vecY) * .5*bmI.dD(vecY);
		Vector3d vecSide = nZone == 1 ? bmI.vecD(eZone0.vecZ()) :- bmI.vecD(eZone0.vecZ());
//		vecSide.vis(ptCen0);
		ptStart+=bmI.vecD(vecSide) * .5*bmI.dD(vecSide);
		ptStart.vis(2);
		Point3d ptEnd = ptCen0 + .5*vecXdistribution * bmI.solidLength();
		ptEnd += vecY0 * vecY0.dotProduct(ptStart-ptEnd);
		ptEnd += vecZ0 * vecZ0.dotProduct(ptStart-ptEnd);
		ptEnd.vis(2);
		
		int nProps[]={nNrResult, nZone };
		double dProps[]={dAngle, dGapNail, dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult, dDiameterDrill, dLengthDrill};				
		String sProps[]={sManufacturer, sFamily, sProduct, sAlignment, sModeDistribution, sBeam, sWindowExclude, sDrill};
		
		if(nZone==1)
		{ 
			double _dAngle = -dAngle;
			dProps[0] = _dAngle;
		}
		Vector3d vecs[] ={ vecX0, - vecX0, vecY0, - vecY0, vecZ0, - vecZ0};
		Vector3d vecAlign = bmI.vecD(-vecY);
		for (int i=0;i<vecs.length();i++) 
		{ 
			if(vecAlign.isCodirectionalTo(vecs[i]))
			{ 
				String _sAlignment = sAlignments[i];
				sProps[3] = _sAlignment;
				break;
			}
			 
		}//next i
		gbsTsl[0] = bmI;
		ptsTsl[0] = ptStart;
		ptsTsl[1] = ptEnd;
		tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
	}
	if(iBeamBottom)
	{ 
		// distribution for bottom beam
		int iWindowExclude = sNoYes.find(sWindowExclude);
		
		// basic information
		Beam bmI = bmBottomPlate;
		Point3d ptCen0 = bmI.ptCen();
		Vector3d vecX0 = bmI.vecX();
		Vector3d vecY0 = bmI.vecY();
		Vector3d vecZ0 = bmI.vecZ();
		ptCen0.vis(5);
		Vector3d vecXdistribution = vecY.crossProduct(eZone0.vecZ());
		
		Point3d ptStart = ptCen0 - .5*vecXdistribution * bmI.solidLength();
		ptStart+= bmI.vecD(vecY) * .5*bmI.dD(vecY);
		Vector3d vecSide = nZone == -1 ? bmI.vecD(eZone0.vecZ()) :-bmI.vecD(eZone0.vecZ());
//		vecSide.vis(ptCen0);
		ptStart-=bmI.vecD(vecSide) * .5*bmI.dD(vecSide);
		ptStart.vis(2);
		Point3d ptEnd = ptCen0 + .5*vecXdistribution * bmI.solidLength();
		ptEnd += vecY0 * vecY0.dotProduct(ptStart-ptEnd);
		ptEnd += vecZ0 * vecZ0.dotProduct(ptStart-ptEnd);
		ptEnd.vis(2);
		
		PlaneProfile ppWall = bmI.envelopeBody().shadowProfile(Plane(ptOrg, vecZ));
		PlaneProfile pps[0];
		PlaneProfile ppsOp[0];
		Beam bmOpStuds[0];
		if(iWindowExclude)
		{ 
			PlaneProfile ppOpIlong(csEl);
			for (int iW=0;iW<opsWindow.length();iW++) 
			{ 
				Opening opI = opsWindow[iW];
				PLine plShapeOpI = opI.plShape();
				PlaneProfile ppOpI(csEl);
				ppOpI.joinRing(plShapeOpI, _kAdd);
				// get extents of profile
				LineSeg segOpI = ppOpI.extentInDir(vecX);
				double dXop = abs(vecX.dotProduct(segOpI.ptStart()-segOpI.ptEnd()));
				double dYop = abs(vecY.dotProduct(segOpI.ptStart()-segOpI.ptEnd()));
				Point3d ptCenOpI = segOpI.ptMid();
				ptCenOpI += vecZ * vecZ.dotProduct(ptMiddleZone0 - ptCenOpI);
				Beam bmLeft, bmRight;
				Beam beamsLeft[] = Beam().filterBeamsHalfLineIntersectSort(beamsVer, ptCenOpI, - vecX);
				Beam beamsRight[] = Beam().filterBeamsHalfLineIntersectSort(beamsVer, ptCenOpI,  vecX);
				if(beamsLeft.length()>0)
				{ 
					for (int iL=0;iL<beamsLeft.length();iL++) 
					{ 
						if(beamsLeft[iL].type()==_kKingStud)
						{
							bmLeft = beamsLeft[iL];
							break;
						}
					}//next iL
				}
				if(beamsRight.length()>0)
				{ 
					for (int iR=0;iR<beamsRight.length();iR++) 
					{ 
						if(beamsRight[iR].type()==_kKingStud)
						{
							bmRight = beamsRight[iR];
							break;
						}
					}//next iR
				}
				Point3d ptLeft = bmLeft.ptCen() - bmLeft.vecD(vecXdistribution) * .5*bmLeft.dD(vecXdistribution);
				Point3d ptRight = bmRight.ptCen() + bmRight.vecD(vecXdistribution) * .5*bmRight.dD(vecXdistribution);
				Point3d ptLeftOp = segOpI.ptMid() - .5 * dXop * vecXdistribution;
				Point3d ptRightOp = segOpI.ptMid() + .5 * dXop * vecXdistribution;
				Point3d ptLeftExtr = vecXdistribution.dotProduct(ptLeft-ptLeftOp)<0?ptLeft:ptLeftOp;
				Point3d ptRightExtr = vecXdistribution.dotProduct(ptRight-ptRightOp)>0?ptRight:ptRightOp;
				
				PLine pl;
//				pl.createRectangle(LineSeg(segOpI.ptMid()-.5*dXop*vecX-vecY*U(10e3),
//					segOpI.ptMid() + .5 * dXop * vecX + vecY * U(10e3)), vecX, vecY);
				pl.createRectangle(LineSeg(ptLeftExtr-vecXdistribution*U(145)-vecY*U(10e3),
					ptRightExtr+vecXdistribution*U(145) + vecY * 2*U(10e3)), vecX, vecY);
				ppOpIlong.joinRing(pl, _kAdd);
				PlaneProfile pp(csEl);
				pp.joinRing(pl, _kAdd);
				ppsOp.append(pp);
				// collect for each opening left and right King Stud
				bmOpStuds.append(bmLeft);
				bmOpStuds.append(bmRight);
				ppWall.joinRing(pl, _kSubtract);
			}//next iW
			PLine pls[] = ppWall.allRings(true, false);
			
			for (int iPl=0;iPl<pls.length();iPl++) 
			{ 
				PlaneProfile pp(csEl);
				pp.joinRing(pls[iPl], _kAdd);
				pps.append(pp);
			}//next iPl
		// order alphabetically
			for (int i=0;i<pps.length();i++) 
			{	
				for (int j=0;j<pps.length()-1;j++) 
				{ 
					Point3d ptJ = pps[j].ptMid();
					Point3d ptJ1 = pps[j+1].ptMid();
					if (vecXdistribution.dotProduct(ptJ-ptJ1)>0)
					{
						pps.swap(j, j + 1);
					}
				}
			}
		}
		else
		{ 
			pps.append(ppWall);
		}
		
		int nProps[]={nNrResult, nZone };
		double dProps[]={dAngle, dGapNail, dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult, dDiameterDrill, dLengthDrill};				
		String sProps[]={sManufacturer, sFamily, sProduct, sAlignment, sModeDistribution, sBeam, sWindowExclude, sDrill};
		
		if(nZone==-1)
		{ 
			double _dAngle = -dAngle;
			dProps[0] = _dAngle;
		}
		Vector3d vecs[] ={ vecX0, - vecX0, vecY0, - vecY0, vecZ0, - vecZ0};
		Vector3d vecAlign = bmI.vecD(vecY);
		for (int i=0;i<vecs.length();i++) 
		{ 
			if(vecAlign.isCodirectionalTo(vecs[i]))
			{ 
				String _sAlignment = sAlignments[i];
				sProps[3] = _sAlignment;
				break;
			}
			 
		}//next i
		gbsTsl[0] = bmI;
		
		for (int iP=0;iP<pps.length();iP++) 
		{ 
			// get extents of profile
			LineSeg seg = pps[iP].extentInDir(vecXdistribution);
			ptsTsl[0] = ptStart;
			ptsTsl[0]+=vecXdistribution*vecXdistribution.dotProduct(seg.ptStart()-ptStart);
			ptsTsl[1] = ptStart;
			ptsTsl[1]+=vecXdistribution*vecXdistribution.dotProduct(seg.ptEnd()-ptStart);
			if(iP!=0 && iP!=(pps.length()-1))
			{ 
				double _dDistanceBottom = 0;
				double _dDistanceTop = 0;
				dProps[2] = _dDistanceBottom;
				dProps[3] = _dDistanceTop;
			}
//			else
//			{ 
//				dProps[2] = dDistanceBottom;
//				dProps[3] = dDistanceTop;
//			}
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
		}//next iP
		// 3 nails for opening
		for (int iP=0;iP<ppsOp.length();iP++) 
		{ 
			// Left
			dProps[0] = dAngle;
			if(nZone==1)
			{ 
				double _dAngle = -dAngle;
				dProps[0] = _dAngle;
			}
			Beam bmL = bmOpStuds[2 * iP];
			Beam bmR = bmOpStuds[(2 * iP)+1];
			LineSeg seg = pps[iP].extentInDir(vecXdistribution);
			ptsTsl[0] = ptStart;
			Point3d ptBm=bmL.ptCen()+bmL.vecD(vecXdistribution) * .5*bmL.dD(vecXdistribution);
			ptsTsl[0]+=vecXdistribution*vecXdistribution.dotProduct(ptBm-ptStart);
			ptsTsl[1] = ptsTsl[0]-vecXdistribution*U(145);
			ptsTsl[0].vis(1);
			ptsTsl[1].vis(1);
			double _dDistanceBottom = U(85);
			double _dDistanceBetween = U(30);
			dProps[2] = _dDistanceBottom;
			dProps[4] = _dDistanceBetween;
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			// Right
			dProps[0] = dAngle;
			if(nZone==-1)
			{ 
				double _dAngle = -dAngle;
				dProps[0] = _dAngle;
			}
			ptsTsl[0] = ptStart;
			ptBm=bmR.ptCen()-bmR.vecD(vecXdistribution) * .5*bmR.dD(vecXdistribution);
			ptsTsl[0]+=vecXdistribution*vecXdistribution.dotProduct(ptBm-ptStart);
			ptsTsl[1] = ptsTsl[0]+vecXdistribution*U(145);
			ptsTsl[0].vis(1);
			ptsTsl[1].vis(1);
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
		}//next iP
	}
	eraseInstance();
	return;
//	int zz;
}
else
{
	nZone.setReadOnly(_kHidden);
	sBeam.setReadOnly(_kHidden);
	sWindowExclude.setReadOnly(_kHidden);
	addRecalcTrigger(_kGripPointDrag, "_Pt0");
	
	if (_GenBeam.length() == 0)
	{
		reportMessage(TN("|no genbeam found|"));
		eraseInstance();
		return;
	}
	
	GenBeam gb = _GenBeam[0];
	// basic information
	CoordSys cs = gb.coordSys();
	Point3d ptCen = gb.ptCen();
	Vector3d vecX = gb.vecX();
	Vector3d vecY = gb.vecY();
	Vector3d vecZ = gb.vecZ();
	
	double dLength = gb.solidLength();
	double dWidth = gb.solidWidth();
	double dHeight = gb.solidHeight();
	
	Quader qd(ptCen, vecX, vecY, vecZ, dLength, dWidth, dHeight);
	assignToGroups(gb);
	setKeepReferenceToGenBeamDuringCopy(_kBeam0);
	Display dpNail(252);
	Body bdNail;
	{
		Body bdHead(ptCen, ptCen + vecX * dLengthHead, .5 * dDiameterHead);
		Body bdN(ptCen, ptCen + vecX * dLengthScrew, .5 * dDiameterThread);
		bdNail.addPart(bdHead);
		bdNail.addPart(bdN);
	}
	
	Vector3d vecs[] ={ vecX ,- vecX, vecY ,- vecY, vecZ ,- vecZ};
	int iAlignment = sAlignments.find(sAlignment);
	Vector3d vecPlane = vecs[iAlignment];
	Vector3d vecXplane, vecYplane;
	Plane pn(ptCen + vecPlane * .5 * qd.dD(vecPlane), vecPlane);
	// plane of nail start considering gap from face
	Plane pnNailStart(ptCen + vecPlane * (.5 * qd.dD(vecPlane) + dGapNail), vecPlane);
	
	_Pt0 = pn.closestPointTo(_Pt0);
	int iSingle = _PtG.length() == 0 ? true : false;
	
	Vector3d vecsMain[] ={ vecX, vecY, vecZ};
	for (int i = 0; i < vecsMain.length(); i++)
	{
		if ( ! vecPlane.isParallelTo(vecsMain[i]))
		{
			vecXplane = vecsMain[i];
			break;
		}
	}//next i
	vecYplane = vecPlane.crossProduct(vecXplane);
	if (_GenBeam.length() == 1)
	{
		//region Trigger addGenbeam
		String sTriggeraddGenbeam = T("|add Genbeam|");
		addRecalcTrigger(_kContextRoot, sTriggeraddGenbeam );
		if (_bOnRecalc && _kExecuteKey == sTriggeraddGenbeam)
		{
			GenBeam gbI = getGenBeam(T("|select Genbeam|"));
			if (_GenBeam.find(gbI) < 0)_GenBeam.append(gbI);
			setExecutionLoops(2);
			return;
		}//endregion
		
	}
	else
	{
		//region Trigger removeGenbeam
		String sTriggerremoveGenbeam = T("|remove Genbeam|");
		addRecalcTrigger(_kContextRoot, sTriggerremoveGenbeam );
		if (_bOnRecalc && _kExecuteKey == sTriggerremoveGenbeam)
		{
			if (_bOnRecalc && _kExecuteKey == sTriggerremoveGenbeam)
			{
				GenBeam gbI = getGenBeam(T("|select Genbeam|"));
				int iIndexGb = _GenBeam.find(gbI);
				if (iIndexGb > - 1)_GenBeam.removeAt(iIndexGb);
				setExecutionLoops(2);
				return;
			}//endregion
			setExecutionLoops(2);
			return;
		}//endregion
		
	}
	int iDrill = sNoYes.find(sDrill);
//	if (iSingle)
//	{
//		sModeDistribution.setReadOnly(_kHidden);
//		dDistanceBottom.setReadOnly(_kHidden);
//		dDistanceTop.setReadOnly(_kHidden);
//		dDistanceBetweenResult.setReadOnly(_kHidden);
//		dAngle.setReadOnly(_kHidden);
//		
//		if (_bOnGripPointDrag && (_kExecuteKey == "_Pt0"))
//		{
//			Display dp(3);
//			Point3d ptStart = _Pt0;
//			
//			Point3d ptText = _Pt0;
//			dp.color(1);
//			Point3d pt = ptStart;
//			PLine pl;
//			pl = PLine();
//			pl.createCircle(pt, vecPlane, dDiameterThread * .5);
//			
//			PlaneProfile ppDrill(pn);
//			ppDrill.joinRing(pl, _kAdd);
//			dp.color(1);
//			dp.draw(ppDrill, _kDrawFilled, 30);
//				
//			return;
//		}
//		Body bdReal = gb.envelopeBody(true, true);
//		bdReal.vis(4);
//		Display dp(1);
//		Point3d ptsDisValid[0];
//		Vector3d vecXnail = - vecPlane;
//		Vector3d vecZnail = vecXplane;
//		Point3d pt0NailStart = _Pt0;
//		pt0NailStart = pnNailStart.closestPointTo(_Pt0);
//		Vector3d vecYnail = vecZnail.crossProduct(vecXnail);
//		CoordSys csNailTransform;
//		double dLengthDrillReal;
//		if (dLengthDrill == 0)
//		{
//			dLengthDrillReal = dLengthScrew;
//		}
//		else if (dLengthDrill < 0)
//		{
//			dLengthDrill.set(-1);
//			dLengthDrillReal = dLengthScrew;
//		}
//		else
//		{
//			dLengthDrillReal = dLengthDrill;
//		}
//		double dDiameterDrillReal;
//		if (dDiameterDrill <= 0)
//		{
//			dDiameterDrill.set(0);
//			dDiameterDrillReal = dDiameterThread;
//		}
//		else
//		{
//			dDiameterDrillReal = dDiameterDrill;
//		}
//		
//		{
//			Point3d pt = _Pt0;
//			Point3d ptGap = pnNailStart.closestPointTo(pt);
//			csNailTransform.setToAlignCoordSys(ptCen, vecX, vecY, vecZ, ptGap, vecXnail, vecYnail, vecZnail);
//			// drill start and end wrt realbody when it goes throug it
//			Point3d ptStart, ptEnd;
//			{
//				//			PlaneProfile ppSlice = bdReal.getSlice(Plane(pt, vecXplane));
//				PlaneProfile ppSlice = bdReal.getSlice(Plane(pt, vecZnail));
//				PLine plSlices[] = ppSlice.allRings();
//				if (plSlices.length() == 0)return;
//				//			Line lnDrill(pt, vecPlane);
//				Line lnDrill(ptGap, vecXnail);
//				Point3d ptsIntersect[0];
//				for (int i = 0; i < plSlices.length(); i++)
//				{
//					Point3d ptsI[] = plSlices[i].intersectPoints(lnDrill);
//					ptsIntersect.append(ptsI);
//				}//next i
//				if (ptsIntersect.length() == 0)return;
//				ptStart = ptsIntersect[0];
//				ptEnd = ptsIntersect[0];
//				for (int i = 0; i < ptsIntersect.length(); i++)
//				{
//					if (vecPlane.dotProduct(ptsIntersect[i] - ptStart) > 0)
//					{
//						ptStart = ptsIntersect[i];
//					}
//					if (vecPlane.dotProduct(ptsIntersect[i] - ptStart) < 0)
//					{
//						ptEnd = ptsIntersect[i];
//					}
//				}//next i
//			}
//			ptsDisValid.append(ptStart);
//			PLine pl;
//			//		pl.createCircle(ptStart, vecPlane, U(.5));
//			pl.createCircle(ptGap, vecXnail, U(.5));
//			//		pl.vis(4);
//			pl.projectPointsToPlane(pn, vecXnail);
//			//		pl.vis(5);
//			
//			PlaneProfile pp(Plane(ptStart, vecPlane));
//			pp.joinRing(pl, _kAdd);
//			dp.draw(pp, _kDrawFilled);
//			ptStart.vis(3);
//			ptEnd.vis(3);
//			
//			
//			//	if(dDepth0==0)
//			//	{
//			//			dDrillDepth = abs(vecPlane.dotProduct(ptStart - ptEnd));
//			//			dDrillDepth = abs(vecXnail.dotProduct(ptStart - ptEnd));
//			//	}
//			//Body bdDrillMain(ptStart + vecPlane * dEps, ptStart - vecPlane * (dDrillDepth + dEps), .5 * dDiameter0);
//			//SolidSubtract sosu(bdDrillMain, _kSubtract);
//			//		Drill drill0(ptStart + vecPlane * dEps, ptStart - vecPlane * (dDrillDepth + dEps), .5 * dDiameterThread);
//			if (iDrill)
//			{
//				Drill drill0(ptGap - vecXnail * dEps, ptGap + vecXnail * (dLengthDrillReal + dEps), .5 * dDiameterDrillReal);
//				gb.addTool(drill0);
//				if (_GenBeam.length() > 1)
//				{
//					if (dLengthDrill != 0)
//						_GenBeam[1].addTool(drill0);
//				}
//			}
//			//		LineSeg lSeg (ptStart, ptStart - vecPlane * dDrillDepth);
//			LineSeg lSeg (ptGap, ptGap + vecXnail * dLengthDrillReal);
//			dp.color(252);
//			dp.draw(lSeg);
//			
//			//		pp.transformBy(- vecPlane * dDrillDepth);
//			//		pp.transformBy(vecXnail * dDrillDepth);
//			pl = PLine();
//			pl.createCircle(ptGap + vecXnail * dLengthDrillReal, vecXnail, U(.5));
//			pp = PlaneProfile (Plane(ptGap + vecXnail * dLengthDrillReal, vecXnail));
//			pp.joinRing(pl, _kAdd);
//			dp.color(1);
//			dp.draw(pp, _kDrawFilled);
//			
//			Body bdI = bdNail;
//			bdI.transformBy(csNailTransform);
//			dpNail.draw(bdI);
//			
//		}
//	}
//	else
	{
		addRecalcTrigger(_kGripPointDrag, "_PtG0");
		
		_PtG[0] = pn.closestPointTo(_PtG[0]);
		if (dDistanceBetween == 0)
			dDistanceBetween.set(U(5));
		
		if (_bOnGripPointDrag && (_kExecuteKey == "_Pt0" || _kExecuteKey == "_PtG0"))
		{
			Display dp(3);
			Point3d ptStart = _Pt0;
			Point3d ptEnd = _PtG[0];
			Vector3d vecDir = _PtG[0] - _Pt0;vecDir.normalize();
			double dLengthTot = (ptEnd - ptStart).dotProduct(vecDir);
			Point3d ptText = _Pt0;
			if (_kExecuteKey == "_PtG0")ptText = _PtG[0];
			LineSeg lSeg(ptStart, ptEnd);
			dp.color(1);
			dp.draw(lSeg);
			if (dDistanceBottom + dDistanceTop > dLengthTot)
			{
				dp.color(1);
				String sText = TN("|no distribution possible|");
				dp.draw(sText, ptText, _XW, _YW, 0, 0, _kDeviceX);
				return;
			}
			
			double dPartLength = 0;
			Point3d pt1 = ptStart + vecDir * dDistanceBottom;
			Point3d pt2 = ptEnd - vecDir * (dDistanceTop + dPartLength);
			double dDistTot = (pt2 - pt1).dotProduct(vecDir);
			if (dDistTot < 0)
			{
				dp.color(1);
				String sText = TN("|no distribution possible|");
				dp.draw(sText, ptText, _XW, _YW, 0, 0, _kDeviceX);
				return;
			}
			Point3d ptsDis[0];
			
			if (dDistanceBetween >= 0)
			{
				// distance in between > 0; distribute with distance
				// modular distance
				double dDistMod = dDistanceBetween + dPartLength;
				int iNrParts = dDistTot / dDistMod;
				double dNrParts = dDistTot / dDistMod;
				if (dNrParts - iNrParts > 0)iNrParts += 1;
				// calculated modular distance between subsequent parts
				
				double dDistModCalc = 0;
				if (iNrParts != 0)
					dDistModCalc = dDistTot / iNrParts;
				
				// first point
				Point3d pt;
				pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
				//				pt.vis(1);
				ptsDis.append(pt);
				if (dDistModCalc > 0)
				{
					for (int i = 0; i < iNrParts; i++)
					{
						pt += vecDir * dDistModCalc;
						//					pt.vis(1);
						ptsDis.append(pt);
					}
				}
				//				dDistanceBetweenResult.set(dDistModCalc-dPartLength);
				// set nr of parts
				//					dDistanceBetweenResult.set(-(ptsDis.length()));
				//				nNrResult.set(ptsDis.length());
			}
			else
			{
				double dDistModCalc;
				//
				int nNrParts = - dDistanceBetween / 1;
				if (nNrParts == 1)
				{
					dDistModCalc = dDistanceBottom;
					ptsDis.append(ptStart + vecDir * dDistanceBottom );
				}
				else
				{
					double dDistMod = dDistTot / (nNrParts - 1);
					dDistModCalc = dDistMod;
					int nNrPartsCalc = nNrParts;
					// clear distance between parts
					double dDistBet = dDistMod - dPartLength;
					if (dDistBet < 0)
					{
						// distance between 2 subsequent parts < 0
						
						dDistModCalc = dPartLength;
						// nr of parts in between 
						nNrPartsCalc = dDistTot / dDistModCalc;
						nNrPartsCalc += 1;
					}
					// first point
					Point3d pt;
					pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
					ptsDis.append(pt);
					pt.vis(1);
					for (int i = 0; i < (nNrPartsCalc - 1); i++)
					{
						pt += vecDir * dDistModCalc;
						pt.vis(1);
						ptsDis.append(pt);
					}//next i
				}
				// set calculated distance between parts
				//					dDistanceBetweenResult.set(dDistModCalc-dPartLength);
				//				dDistanceBetweenResult.set(dDistModCalc-dPartLength);
				// set nr of parts
				//				nNrResult.set(ptsDis.length());
			}
			
			for (int i = 0; i < ptsDis.length(); i++)
			{
				Point3d pt = ptsDis[i];
				PLine pl;
				pl = PLine();
				pl.createCircle(pt, vecPlane, dDiameterThread * .5);
				
				PlaneProfile ppDrill(pn);
				ppDrill.joinRing(pl, _kAdd);
				dp.color(1);
				dp.draw(ppDrill, _kDrawFilled, 30);
				
			}//next i
			return;
		}
		
		
		
		int iModeDistribution = sModeDistributions.find(sModeDistribution);
		Point3d ptStart = _Pt0;
		Point3d ptEnd = _PtG[0];
		// direction of distribution
		Vector3d vecDir = _PtG[0] - _Pt0;vecDir.normalize();
		
		// HSB-13076
		if(_kNameLastChangedProp==sAngleName || _bOnDbCreated)
		{ 
			int iMultiple180;
			double dFac = dAngle / U(180);
			int iFac = dFac;
			if (abs(dAngle - (iFac * U(180))) < dEps)iMultiple180 = true;
			// set to center
			if(iMultiple180)
			{ 
				Vector3d vecWidth = vecX.crossProduct(gb.vecD(vecPlane));
				_Pt0 += vecWidth * vecWidth.dotProduct(gb.ptCen() - _Pt0);
				_PtG[0] += vecWidth * vecWidth.dotProduct(gb.ptCen() - _PtG[0]);
				setExecutionLoops(2);
				return;
			}
		}
		
		double dLengthTot = (ptEnd - ptStart).dotProduct(vecDir);
		if (dDistanceBottom + dDistanceTop > dLengthTot)
		{
			reportMessage(TN("|no distribution possible|"));
			return;
		}
		double dPartLength = 0;
		Point3d pt1 = ptStart + vecDir * dDistanceBottom;
		Point3d pt2 = ptEnd - vecDir * (dDistanceTop + dPartLength);
		double dDistTot = (pt2 - pt1).dotProduct(vecDir);
		if (dDistTot < 0)
		{
			reportMessage(TN("|no distribution possible|"));
			return;
		}
		Point3d ptsDis[0];
		if (dDistanceBetween >= 0)
		{
			// 2 scenarion even, fixed
			if (iModeDistribution == 0)
			{
				// even
				
				// distance in between > 0; distribute with distance
				// modular distance
				double dDistMod = dDistanceBetween + dPartLength;
				int iNrParts = dDistTot / dDistMod;
				double dNrParts = dDistTot / dDistMod;
				if (dNrParts - iNrParts > 0)iNrParts += 1;
				// calculated modular distance between subsequent parts
				
				double dDistModCalc = 0;
				if (iNrParts != 0)
					dDistModCalc = dDistTot / iNrParts;
				
				// first point
				Point3d pt;
				pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
				//				pt.vis(1);
				ptsDis.append(pt);
				if (dDistModCalc > 0)
				{
					for (int i = 0; i < iNrParts; i++)
					{
						pt += vecDir * dDistModCalc;
						//					pt.vis(1);
						ptsDis.append(pt);
					}
				}
				dDistanceBetweenResult.set(dDistModCalc - dPartLength);
				// set nr of parts
				//					dDistanceBetweenResult.set(-(ptsDis.length()));
				nNrResult.set(ptsDis.length());
			}
			else if (iModeDistribution == 1)
			{
				// fixed
				// distance in between > 0; distribute with distance
				// modular distance
				double dDistMod = dDistanceBetween + dPartLength;
				int iNrParts = dDistTot / dDistMod;
				//			double dNrParts=dDistTot / dDistMod;
				//			if (dNrParts - iNrParts > 0)iNrParts += 1;
				// calculated modular distance between subsequent parts
				
				double dDistModCalc = 0;
				//			if (iNrParts != 0)
				//				dDistModCalc = dDistTot / iNrParts;
				dDistModCalc = dDistMod;
				// first point
				Point3d pt;
				pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
				//				pt.vis(1);
				ptsDis.append(pt);
				if (dDistModCalc > 0)
				{
					for (int i = 0; i < iNrParts; i++)
					{
						pt += vecDir * dDistModCalc;
						//					pt.vis(1);
						ptsDis.append(pt);
					}
				}
				// last
				ptsDis.append(ptEnd - vecDir * (dDistanceTop + dPartLength / 2));
				dDistanceBetweenResult.set(dDistModCalc - dPartLength);
				// set nr of parts
				//					dDistanceBetweenResult.set(-(ptsDis.length()));
				nNrResult.set(ptsDis.length());
			}
		}
		else
		{
			double dDistModCalc;
			//
			int nNrParts = - dDistanceBetween / 1;
			if (nNrParts == 1)
			{
				dDistModCalc = dDistanceBottom;
				ptsDis.append(ptStart + vecDir * dDistanceBottom );
			}
			else
			{
				double dDistMod = dDistTot / (nNrParts - 1);
				dDistModCalc = dDistMod;
				int nNrPartsCalc = nNrParts;
				// clear distance between parts
				double dDistBet = dDistMod - dPartLength;
				if (dDistBet < 0)
				{
					// distance between 2 subsequent parts < 0
					
					dDistModCalc = dPartLength;
					// nr of parts in between 
					nNrPartsCalc = dDistTot / dDistModCalc;
					nNrPartsCalc += 1;
				}
				// first point
				Point3d pt;
				pt = ptStart + vecDir * (dDistanceBottom + dPartLength / 2);
				ptsDis.append(pt);
				pt.vis(1);
				for (int i = 0; i < (nNrPartsCalc - 1); i++)
				{
					pt += vecDir * dDistModCalc;
					pt.vis(1);
					ptsDis.append(pt);
				}//next i
			}
			// set calculated distance between parts
			//					dDistanceBetweenResult.set(dDistModCalc-dPartLength);
			dDistanceBetweenResult.set(dDistModCalc - dPartLength);
			// set nr of parts
			nNrResult.set(ptsDis.length());
		}
		Body bdReal = gb.envelopeBody(true, true);
		bdReal.vis(4);
		Display dp(1);
		dp.showInDxa(true); //HSB-18650 standard display published for share and make
		Point3d ptsDisValid[0];
		Vector3d vecXnail = - vecPlane;
		Vector3d vecZnail = vecDir;
		Point3d pt0NailStart = _Pt0;
		pt0NailStart = pnNailStart.closestPointTo(_Pt0);
		CoordSys csRotate;
		csRotate.setToRotation(dAngle, vecZnail, pt0NailStart);
		vecXnail.transformBy(csRotate);
		Vector3d vecYnail = vecZnail.crossProduct(vecXnail);
		vecYnail.normalize();
		vecXnail.vis(pt0NailStart, 1);
		vecYnail.vis(pt0NailStart, 3);
		vecZnail.vis(pt0NailStart, 5);
		CoordSys csNailTransform;
		double dLengthDrillReal;
		if (dLengthDrill == 0)
		{
			dLengthDrillReal = dLengthScrew;
		}
		else if (dLengthDrill < 0)
		{
			dLengthDrill.set(-1);
			dLengthDrillReal = dLengthScrew;
		}
		else
		{
			dLengthDrillReal = dLengthDrill;
		}
		double dDiameterDrillReal;
		if (dDiameterDrill <= 0)
		{
			dDiameterDrill.set(0);
			dDiameterDrillReal = dDiameterThread;
		}
		else
		{
			dDiameterDrillReal = dDiameterDrill;
		}
		for (int i = 0; i < ptsDis.length(); i++)
		{
			Point3d pt = ptsDis[i];
			Point3d ptGap = pnNailStart.closestPointTo(pt);
			csNailTransform.setToAlignCoordSys(ptCen, vecX, vecY, vecZ, ptGap, vecXnail, vecYnail, vecZnail);
			// drill start and end wrt realbody when it goes throug it
			Point3d ptStart, ptEnd;
			{
				//			PlaneProfile ppSlice = bdReal.getSlice(Plane(pt, vecXplane));
				PlaneProfile ppSlice = bdReal.getSlice(Plane(pt, vecDir));
				PLine plSlices[] = ppSlice.allRings();
				if (plSlices.length() == 0)continue;
				//			Line lnDrill(pt, vecPlane);
				Line lnDrill(ptGap, vecXnail);
				Point3d ptsIntersect[0];
				for (int i = 0; i < plSlices.length(); i++)
				{
					Point3d ptsI[] = plSlices[i].intersectPoints(lnDrill);
					ptsIntersect.append(ptsI);
				}//next i
				if (ptsIntersect.length() == 0)continue;
				ptStart = ptsIntersect[0];
				ptEnd = ptsIntersect[0];
				for (int i = 0; i < ptsIntersect.length(); i++)
				{
					if (vecPlane.dotProduct(ptsIntersect[i] - ptStart) > 0)
					{
						ptStart = ptsIntersect[i];
					}
					if (vecPlane.dotProduct(ptsIntersect[i] - ptStart) < 0)
					{
						ptEnd = ptsIntersect[i];
					}
				}//next i
			}
			ptsDisValid.append(ptStart);
			PLine pl;
			//		pl.createCircle(ptStart, vecPlane, U(.5));
			pl.createCircle(ptGap, vecXnail, U(.5));
			//		pl.vis(4);
			pl.projectPointsToPlane(pn, vecXnail);
			//		pl.vis(5);
			
			PlaneProfile pp(Plane(ptStart, vecPlane));
			pp.joinRing(pl, _kAdd);
			dp.draw(pp, _kDrawFilled);
			ptStart.vis(3);
			ptEnd.vis(3);
			
			
			//	if(dDepth0==0)
			//	{
			//			dDrillDepth = abs(vecPlane.dotProduct(ptStart - ptEnd));
			//			dDrillDepth = abs(vecXnail.dotProduct(ptStart - ptEnd));
			//	}
			//Body bdDrillMain(ptStart + vecPlane * dEps, ptStart - vecPlane * (dDrillDepth + dEps), .5 * dDiameter0);
			//SolidSubtract sosu(bdDrillMain, _kSubtract);
			//		Drill drill0(ptStart + vecPlane * dEps, ptStart - vecPlane * (dDrillDepth + dEps), .5 * dDiameterThread);
			if (iDrill)
			{
				Drill drill0(ptGap - vecXnail * dEps, ptGap + vecXnail * (dLengthDrillReal + dEps), .5 * dDiameterDrillReal);
				gb.addTool(drill0);
				if (_GenBeam.length() > 1)
				{
					if (dLengthDrill != 0)
						_GenBeam[1].addTool(drill0);
				}
			}
			//		LineSeg lSeg (ptStart, ptStart - vecPlane * dDrillDepth);
			LineSeg lSeg (ptGap, ptGap + vecXnail * dLengthDrillReal);
			dp.color(252);
			dp.draw(lSeg);
			
			//		pp.transformBy(- vecPlane * dDrillDepth);
			//		pp.transformBy(vecXnail * dDrillDepth);
			pl = PLine();
			pl.createCircle(ptGap + vecXnail * dLengthDrillReal, vecXnail, U(.5));
			pp = PlaneProfile (Plane(ptGap + vecXnail * dLengthDrillReal, vecXnail));
			pp.joinRing(pl, _kAdd);
			dp.color(1);
			dp.draw(pp, _kDrawFilled);
			
			Body bdI = bdNail;
			bdI.transformBy(csNailTransform);
			dpNail.draw(bdI);
			
			//	if(dDiameter1>0)
			//	{
			//		// sink hole
			//		double dSinkDepth1 = dDepth1;
			//		if(dDepth1==0)
			//			dSinkDepth1 = dDiameter1 * .5;
			//
			//		// second point of cone
			//		double _dRadius2 = .5 * dDiameter0 - dEps;
			//		double _dDepth2 = (1-(_dRadius2 / (.5 * dDiameter1))) * dSinkDepth1;
			//
			//		Body bdSink1(ptStart, ptStart - vecPlane * _dDepth2, .5*dDiameter1, _dRadius2);
			//		SolidSubtract sosu1(bdSink1, _kSubtract);
			//		gb.addTool(sosu1);
			//	}
			//
			//	if(dDiameter2>0)
			//	{
			//		// sink hole
			//		double dSinkDepth2 = dDepth2;
			//		if(dDepth2==0)
			//			dSinkDepth2 = dDiameter2 * .5;
			//
			//		// second point of cone
			//		double _dRadius2 = .5 * dDiameter0 - dEps;
			//		double _dDepth2 = (1-(_dRadius2 / (.5 * dDiameter2))) * dSinkDepth2;
			//
			//		Body bdSink1(ptStart-vecPlane*dDrillDepth, ptStart-vecPlane*dDrillDepth+ vecPlane * _dDepth2, .5*dDiameter2, _dRadius2);
			//		SolidSubtract sosu2(bdSink1, _kSubtract);
			//		gb.addTool(sosu2);
			//	}
		}//next i
		
		if (ptsDisValid.length() == 0)
		{
			reportMessage(TN("|distribution outside the genbeam|"));
			//		eraseInstance();
			return;
		}
		
	//region Trigger generateSingleInstances
		String sTriggergenerateSingleInstances = T("|generate Single Instances|");
		addRecalcTrigger(_kContextRoot, sTriggergenerateSingleInstances );
		if (_bOnRecalc && _kExecuteKey==sTriggergenerateSingleInstances)
		{
			// create TSL
			TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[0]; Entity entsTsl[] = {}; Point3d ptsTsl[2];
			int nProps[]={nNrResult, nZone};
			double dProps[]={dAngle, dGapNail, dDistanceBottom, dDistanceTop, dDistanceBetween, dDistanceBetweenResult, dDiameterDrill, dLengthDrill};				
			String sProps[]={sManufacturer, sFamily, sProduct, sAlignment, sModeDistribution, sBeam, sWindowExclude, sDrill};
			Map mapTsl;
			// dDistanceBottom
			dProps[2] = 0;
			dProps[4] = -1;
			for (int iB=0;iB<_Beam.length();iB++) 
			{ 
				gbsTsl.append(_Beam[iB]); 
			}//next iB
			
//			for (int iP=0;iP<ptsDisValid.length();iP++) 
			for (int iP=0;iP<ptsDis.length();iP++) 
			{ 
				ptsTsl[0] = ptsDis[iP]; 
				ptsTsl[1] = ptsTsl[0]+vecDir*U(100); 
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}//next iP
			
			eraseInstance();
			return;
		}//endregion	
	}
	
	
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
		// element
			// try to catch the element from the parent entity
			Element elHW =gb.element(); 
			// check if the parent entity is an element
			if (!elHW.bIsValid())	elHW = (Element)gb;
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
			HardWrComp hwc(sFamily, nNrResult); // the articleNumber and the quantity is mandatory
			
			hwc.setManufacturer(sManufacturer);
			
			hwc.setModel(sProduct);
			hwc.setArticleNumber(sArticleNr);
//			hwc.setName(sHWName);
//			hwc.setDescription(sHWDescription);
//			hwc.setMaterial(sHWMaterial);
//			hwc.setNotes(sHWNotes);
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(gb);	
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			hwc.setDScaleX(dLengthScrew);
			hwc.setDScaleY(dDiameterThread);
//			hwc.setDScaleZ(dHWHeight);
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}
	
	// make sure the hardware is updated
		if (_bOnDbCreated)	setExecutionLoops(2);				
		_ThisInst.setHardWrComps(hwcs);	
		//endregion
}




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
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18650 standard display published for share and make" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="5/10/2023 1:07:18 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13076: set distribution to center when angle is set to 0 (only on property change)" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="9/14/2021 11:30:44 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13077: fix bug when reading manufacturer, family, product from _kExecuteKey" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="9/3/2021 6:29:59 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12662: TSL works with ElementWall not only ElementWallSF" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="7/23/2021 6:17:50 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11613: fix bug: write article nr in hardware instead of family name" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="6/18/2021 2:39:43 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="small improvement in jig" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="5/29/2021 7:30:54 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11613: add command line options, support mapIo " />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="5/12/2021 8:52:02 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End