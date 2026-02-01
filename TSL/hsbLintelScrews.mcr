#Version 8
#BeginDescription
#Versions:
Version 1.3 10.05.2023 HSB-18650 standard display published for share and make , Author Thorsten Huck
1.2 14.12.2021 HSB-13751: increase tolerance when comparing parallel vectors Author: Marsel Nakuci
1.1 18.06.2021 HSB-11612: write article nr in hardware not family name Author: Marsel Nakuci
1.0 28.04.2021 HSB-11612: Initial Author: Marsel Nakuci

This TSL allows the user to apply a screw fastener connecting headers/lintels and king stud/ jamb stud. 
For tooling, if the diameter is set as 0 than the screw thread diameter is used. 
A size greater than 0 will overwrite the the tool diameter size. 
If the depth is set as 0 tooling is only applied to king stud/ jamb stud. If set as -1 then the screw length is used. 
A size greater than 0 will extend the tool depth past the king stud/ jamb stud.




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.3 10.05.2023 HSB-18650 standard display published for share and make , Author Thorsten Huck
// Version 1.2 14.12.2021 HSB-13751: increase tolerance when comparing parallel vectors Author: Marsel Nakuci
// Version 1.1 18.06.2021 HSB-11612: write article nr in hardware not family name Author: Marsel Nakuci
// Version 1.0 28.04.2021 HSB-11612: Initial Author: Marsel Nakuci

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This TSL allows the user to apply a screw fastener connecting headers/lintels and king stud/ jamb stud. 
// For tooling, if the diameter is set as 0 than the screw thread diameter is used. 
// A size greater than 0 will overwrite the the tool diameter size. 
// If the depth is set as 0 tooling is only applied to king stud/ jamb stud. If set as -1 then the screw length is used. 
// A size greater than 0 will extend the tool depth past the king stud/ jamb stud.
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbLintelScrews")) TSLCONTENT
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
// alignment
	category = T("|Alignment|");
	String sAngleName=T("|Angle|");	
	PropDouble dAngle(nDoubleIndex++, U(0), sAngleName);	
	dAngle.setDescription(T("|Defines the inclination Angle of the Screw|"));
	dAngle.setCategory(category);
	
	String sQuantityName=T("|Quantity|");	
	int nQuantitys[]={1,2,3};
	PropInt nQuantity(nIntIndex++, 1, sQuantityName);	
	nQuantity.setDescription(T("|Defines the nr. of Screws|"));
	nQuantity.setCategory(category);
	
	String sOffsetName=T("|Offset|");	
	PropDouble dOffset(nDoubleIndex++, U(0), sOffsetName);	
	dOffset.setDescription(T("|Defines the Offset between Screws|"));
	dOffset.setCategory(category);
// tooling
	category = T("|Drill|");
	String sDrillName=T("|Drill|");	
	PropString sDrill(nStringIndex++, sNoYes, sDrillName);	
	sDrill.setDescription(T("|Defines the Drill|"));
	sDrill.setCategory(category);
	// diameter
	String sDiameterDrillName=T("|Diameter|");	
	PropDouble dDiameterDrill(nDoubleIndex++, U(0), sDiameterDrillName);	
	dDiameterDrill.setDescription(T("|Defines the DiameterDrill|"));
	dDiameterDrill.setCategory(category);
	
	// extra Length
	String sLengthDrillName=T("|Depth|");	
	PropDouble dLengthDrill(nDoubleIndex++, U(0), sLengthDrillName);	
	dLengthDrill.setDescription(T("|Defines the extra Length of the Drill|"));
	dLengthDrill.setCategory(category);
//End Properties//endregion 

////region bOnInsert
//	if(_bOnInsert)
//	{
//		if (insertCycleCount()>1) { eraseInstance(); return; }
//					
//	// silent/dialog
//		if (_kExecuteKey.length()>0)
//		{
//			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
//			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
//				setPropValuesFromCatalog(_kExecuteKey);
//			else
//				setPropValuesFromCatalog(sLastInserted);					
//		}	
//	// standard dialog	
//		else	
//			showDialog();
//		
//		
//		return;
//	}	
//// end on insert	__________________//endregion

// bOnInsert//region
if (_bOnInsert)
{
	if (insertCycleCount() > 1) { eraseInstance(); return; }
	
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
			dAngle.setReadOnly(false);
			nQuantity.setReadOnly(false);
			dOffset.setReadOnly(false);
			// Drill
			sDrill.setReadOnly(false);
			dDiameterDrill.setReadOnly(false);
			dLengthDrill.setReadOnly(false);
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
						if (_sManufacturerName.makeUpper() != sManufacturer.makeUpper())
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
						if (sFamilys.length() > 0)sFamily.set(sFamilys[1]);
						sProduct = PropString(2, sProducts, sProductName, 0);
						sProduct.set("---");
						sProduct.setReadOnly(true);
						//
						dAngle.setReadOnly(false);
						nQuantity.setReadOnly(false);
						dOffset.setReadOnly(false);
						// Drill
						sDrill.setReadOnly(false);
						dDiameterDrill.setReadOnly(false);
						dLengthDrill.setReadOnly(false);
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
							if (sFamilys.length() > 0)sFamily.set(sFamilys[1]);
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
								if (_sFamilyName.makeUpper() != sFamily.makeUpper())
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
								dAngle.setReadOnly(false);
								nQuantity.setReadOnly(false);
								dOffset.setReadOnly(false);
								// Drill
								sDrill.setReadOnly(false);
								dDiameterDrill.setReadOnly(false);
								dLengthDrill.setReadOnly(false);
								showDialog("---");
								//						showDialog();
								if (bDebug)reportMessage("\n" + scriptName() + " from dialog ");
								if (bDebug)reportMessage("\n" + scriptName() + " sProduct " + sProduct);
							}
							else
							{
								// see if sTokens[1] is a valid family name as in sFamilys from mapSetting
								int indexSTokens = sProducts.find(sTokens[1]);
								if (indexSTokens >- 1)
								{
									// find
									//				sModel = PropString(1, sModels, sModelName, indexSTokens);
									sProduct.set(sTokens[1]);
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
			if (sFamilys.length() > 0)sFamily.set(sFamilys[1]);
			sProduct.set(sProducts[0]);
			if (sProducts.length() > 0)sProduct.set(sProducts[1]);
		}
	}
	// prompt selection of walls
	Entity ents[0];
	
	PrEntity ssE(T("|Select walls(s) or Enter to select King stud and head|"), ElementWallSF());
	if (ssE.go())
		ents.append(ssE.set());
	
	if (ents.length() > 0)
	{ 
		ElementWallSF eWalls[0];
		for (int i = 0; i < ents.length(); i++)
		{ 
			ElementWallSF eWsF = (ElementWallSF)ents[i];
			if (eWsF.bIsValid() && eWalls.find(eWsF) < 0)eWalls.append(eWsF);
		}//next i
		for (int i=0;i<eWalls.length();i++) 
			_Element.append(eWalls[i]);
		// distribution
	// create TSL
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};		Entity entsTsl[1];			Point3d ptsTsl[] = {_Pt0};
		int nProps[]={nQuantity};			
		double dProps[]={dAngle, dOffset, dDiameterDrill, dLengthDrill};				
		String sProps[]={sManufacturer, sFamily, sProduct, sDrill};
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
		// prompt to select king stud and head
	// prompt for beams
		Beam beams[0];
		PrEntity ssE(T("|Select Studs and Heads of Openings|"), Beam());
		if (ssE.go())
			beams.append(ssE.beamSet());
		
		
		Beam beamsStud[0], beamsHeader[0];
		for (int i=0;i<beams.length();i++) 
		{ 
			if(beams[i].type()==_kKingStud && beamsStud.find(beams[i])<0)
			{
				beamsStud.append(beams[i]);
				continue;
			}
			if(beams[i].type()==_kHeader && beamsHeader.find(beams[i])<0)
			{
				beamsHeader.append(beams[i]);
				continue;
			}
		}//next i
		
		
		for (int iH=0;iH<beamsHeader.length();iH++) 
		{ 
			Beam bmH = beamsHeader[iH];
			Element eH = bmH.element();
			Opening ops[] = eH.opening();
			if (ops.length() == 0)continue;
			for (int iS=0;iS<beamsStud.length();iS++) 
			{ 
				Beam bmS = beamsStud[iS];
				Element eS = bmS.element();
				if (eH != eS)continue;
				
				PlaneProfile ppH = bmH.envelopeBody().shadowProfile(Plane(eH.ptOrg(), eH.vecZ()));
				PlaneProfile ppS = bmS.envelopeBody().shadowProfile(Plane(eH.ptOrg(), eH.vecZ()));
				PlaneProfile ppIntersect = ppH;
				ppIntersect.shrink(-10 * dEps);
				if ( ! ppIntersect.intersectWith(ppS))continue;
				for (int iO=0;iO<ops.length();iO++) 
				{ 
					PLine plShapeOpI = ops[iO].plShape();
					PlaneProfile ppOpI(eH.coordSys());
					ppOpI.joinRing(plShapeOpI, _kAdd);
					// get extents of profile
					LineSeg seg = ppOpI.extentInDir(eH.vecX());
					double dX = abs(eH.vecX().dotProduct(seg.ptStart()-seg.ptEnd()));
					double dY = abs(eH.vecY().dotProduct(seg.ptStart()-seg.ptEnd()));
					
					PlaneProfile ppVert(ppOpI.coordSys());
					PLine pl();
					pl.createRectangle(LineSeg(seg.ptMid()-eH.vecX()*.5*dX-eH.vecY()*U(10e3),
					seg.ptMid() + eH.vecX() * .5 * dX + eH.vecY() * U(10e3)), eH.vecX(), eH.vecY());
					ppVert.joinRing(pl, _kAdd);
					
					if ( ! ppVert.intersectWith(ppH))continue;
					
					PlaneProfile ppHor(ppOpI.coordSys());
					pl = PLine();
					pl.createRectangle(LineSeg(seg.ptMid()-eH.vecX()*U(10e3)-eH.vecY()*.5*dY,
					seg.ptMid() + eH.vecX() *U(10e3)  + eH.vecY() * .5 * dY), eH.vecX(), eH.vecY());
					ppHor.joinRing(pl, _kAdd);
					
					if ( ! ppHor.intersectWith(ppS))continue;
					
					// create TSL
					TslInst tslNew;	Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
					GenBeam gbsTsl[] = {bmH, bmS}; Entity entsTsl[]={ops[iO]}; Point3d ptsTsl[] = {_Pt0};
					int nProps[]={nQuantity};
					double dProps[]={dAngle, dOffset, dDiameterDrill, dLengthDrill};
					String sProps[] ={ sManufacturer, sFamily, sProduct, sDrill};
					Map mapTsl;
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
					break;
				}//next iO
			}//next iS
		}//next iH	
		eraseInstance();
		return;
//			_Beam.append(beams);
//			_Map.setPoint3d("ptStart", ptStart);
//			_Map.setPoint3d("ptEnd", ptEnd);
	}
	return;
}
// end on insert	__________________//endregion
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
	s="Length"; if(mapProduct.hasDouble(s))dLengthScrew = mapProduct.getDouble(s);
	s="ArticleNumber"; if(mapProduct.hasString(s))sArticleNr = mapProduct.getString(s);
}
if(iFamilyFound)
{
	String s;
	s="Diameter Thread"; if(mapFamily.hasDouble(s))dDiameterThread= mapFamily.getDouble(s);
	s="Diameter Head"; if(mapFamily.hasDouble(s))dDiameterHead= mapFamily.getDouble(s);
	s="Length Head"; if(mapFamily.hasDouble(s))dLengthHead= mapFamily.getDouble(s);
	s="url"; if(mapFamily.hasString(s))sUrl= mapFamily.getString(s);
}
int iDrill = sNoYes.find(sDrill);
if(sUrl!="")
	_ThisInst.setHyperlink(sUrl);

if (_Element.length() == 1)
{
	// element mode
	// basic information
	Element eSf = (ElementWallSF)_Element[0];
	if ( ! eSf.bIsValid())
	{
		reportMessage(TN("|no valid stick frame wall|"));
		eraseInstance();
		return;
	}
	Point3d ptOrg = eSf.ptOrg();
	Vector3d vecX = eSf.vecX();
	Vector3d vecY = eSf.vecY();
	Vector3d vecZ = eSf.vecZ();
	CoordSys csEl = eSf.coordSys();
	ElemZone eZone0 = eSf.zone(0);
//	Point3d ptMiddleZone0 = .5 * (eSf.zone(0).ptOrg() + eSf.zone(0).ptOrg() + eSf.zone(0).vecZ()*eSf.zone(0).dH());
	Point3d ptStartZone0 = eZone0.ptOrg();
	Point3d ptEndZone0 = eZone0.ptOrg() + eZone0.vecZ()*eZone0.dH();
	Point3d ptMiddleZone0 = .5 * (ptStartZone0+ptEndZone0);
	ptMiddleZone0.vis(4);
	
	_Pt0 = ptOrg;
	Beam beams[] = eSf.beam();
	Beam beamsVer[] = vecX.filterBeamsPerpendicularSort(beams);
	Beam beamsHor[] = vecY.filterBeamsPerpendicularSort(beams);
	if(beams.length()==0)
	{ 
		return;
	}
	
	Opening ops[] = eSf.opening();
	if(ops.length()==0)
	{ 
		reportMessage(TN("|no opening found|"));
		eraseInstance();
		return;
	}
	// create TSL
	TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[]={nQuantity};
	double dProps[]={dAngle, dOffset, dDiameterDrill, dLengthDrill};				
	String sProps[]={sManufacturer, sFamily, sProduct, sDrill};
	Map mapTsl;	
//	return;
	for (int i=0;i<ops.length();i++) 
	{ 
		Opening opI = ops[i];
		PLine plShapeOpI = opI.plShape();
		PlaneProfile ppOpI(csEl);
		ppOpI.joinRing(plShapeOpI, _kAdd);
		ppOpI.vis(3);
		
		
		// get extents of profile
		LineSeg segOp = ppOpI.extentInDir(vecX);
		Point3d ptCenOp = segOp.ptMid();
		ptCenOp += vecZ * vecZ.dotProduct(ptMiddleZone0 - ptCenOp);
		
		ptCenOp.vis(1);
		
		// get left and right king stud
		Beam bmLeft, bmRight;
		Beam bmsHead[0];
		Beam beamsLeft[] = Beam().filterBeamsHalfLineIntersectSort(beamsVer, ptCenOp, - vecX);
		Beam beamsRight[] = Beam().filterBeamsHalfLineIntersectSort(beamsVer, ptCenOp,  vecX);
		
		int nStep = 4;
		Point3d pt= ptCenOp;
		pt+=vecZ * vecZ.dotProduct(ptStartZone0 - ptCenOp);
		for (int iStep=0;iStep<nStep+1;iStep++) 
		{ 
			pt.vis(1);
			Beam beamsTop[] = Beam().filterBeamsHalfLineIntersectSort(beamsHor, ptCenOp, vecY);
			for (int iT=0;iT<beamsTop.length();iT++)
			{ 
				if(beamsTop[iT].type()==_kHeader)
				{
					if(bmsHead.find(beamsTop[iT])<0)
					{ 
						bmsHead.append(beamsTop[iT]);
					}
				}
			}//next iR
			pt += vecZ * (eZone0.dH() / nStep);
		}//next iStep
		
		
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
		
		for (int iT=0;iT<bmsHead.length();iT++) 
		{ 
			Beam bmHead = bmsHead[iT];
			if(bmLeft.bIsValid() && bmHead.bIsValid()>0)
			{ 
				gbsTsl.setLength(0);
				gbsTsl.append(bmLeft);
				gbsTsl.append(bmHead);
				// 
				entsTsl.setLength(0);
				entsTsl.append(ops[i]);
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
			if(bmRight.bIsValid() && bmHead.bIsValid())
			{ 
				gbsTsl.setLength(0);
				gbsTsl.append(bmRight);
				gbsTsl.append(bmHead);
				// 
				entsTsl.setLength(0);
				entsTsl.append(ops[i]);
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
		}//next iT
	}//next i
	eraseInstance();
	return;
}
else if(_Beam.length()==2 && _Opening.length()==1)
{ 
	if(!_Beam[0].bIsValid() || !_Beam[1].bIsValid())
	{ 
		reportMessage("\n"+scriptName()+" "+T("|Beams not found|"));
		eraseInstance();
		return;
	}
	// beam modus, we have king stud and head
	Beam bmStud, bmHead;
	Element el = _Beam[0].element();
	Element el1 = _Beam[1].element();
	Element elOp = _Opening[0].element();
	if(!el.bIsValid() || !el1.bIsValid() || !elOp.bIsValid())
	{ 
		reportMessage("\n"+scriptName()+" "+T("|beams not part of an element|"));
		eraseInstance();
		return;
	}
	if(el!=el1 || el!=elOp)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|beams and opening not part of same element|"));
		eraseInstance();
		return;
	}
	
	Opening op = _Opening[0];
	
	// basic information
	Point3d ptOrg = el.ptOrg();
	Vector3d vecX = el.vecX();
	Vector3d vecY = el.vecY();
	Vector3d vecZ = el.vecZ();
	vecX.vis(ptOrg, 1);
	vecY.vis(ptOrg, 3);
	vecZ.vis(ptOrg, 5);
	
	CoordSys csOp = op.coordSys();
	Point3d ptOrgOp = csOp.ptOrg();
	Vector3d vecXop = csOp.vecX();
	Vector3d vecYop = csOp.vecY();
	Vector3d vecZop = csOp.vecZ();
	vecXop.vis(ptOrgOp, 1);
	vecYop.vis(ptOrgOp, 3);
	vecZop.vis(ptOrgOp, 5);
	
	_Pt0 = ptOrgOp;
	// HSB-13751
	if(abs(abs(_Beam[0].vecX().dotProduct(vecYop))-1.0)<dEps && abs(abs(_Beam[1].vecX().dotProduct(vecXop))-1.0)<dEps)
	{ 
//		bmStud = _Beam[0];
//		bmHead = _Beam[1];
		_Beam.swap(0, 1);
	}
//	else if(_Beam[1].vecX().isParallelTo(vecYop) && _Beam[0].vecX().isParallelTo(vecXop))
	else if(abs(abs(_Beam[1].vecX().dotProduct(vecYop))-1.0)<dEps && abs(abs(_Beam[0].vecX().dotProduct(vecXop))-1.0)<dEps)
	{ 
//		bmStud = _Beam[1];
//		bmHead = _Beam[0];
	}
	else
	{ 
		reportMessage("\n"+scriptName()+" "+T("|beams not stud or head|"));
		eraseInstance();
		return;
	}
	// male Head
	Beam bm0 = _Beam[0], bm1 = _Beam[1];
	Point3d ptCen0 = bm0.ptCen();
	Vector3d vecX0 = bm0.vecX();
	Vector3d vecY0 = bm0.vecY();
	Vector3d vecZ0 = bm0.vecZ();
	Body bd0 = bm0.envelopeBody();
	// female stud
	Point3d ptCen1 = bm1.ptCen();
	Vector3d vecX1 = bm1.vecX();
	Vector3d vecY1 = bm1.vecY();
	Vector3d vecZ1 = bm1.vecZ();

//	String sType = bm0.type();
//	String ss = _BeamTypes[0];
//	String sHeader = _BeamTypes[_kHeader];//18
//	String sStud = _BeamTypes[_kKingStud];//30
	Vector3d vecX10 = vecX0.dotProduct(ptCen0-ptCen1)>0?vecX0:-vecX0;
//	vecX10.vis(_Pt0, 3);
	Plane pn1(ptCen1 + bm1.vecD(vecX10) *.5* bm1.dD(vecX10), vecX10);
	Line ln0(ptCen0 - bm0.vecD(vecYop) * .5*bm0.dD(-vecYop), vecX0);
	Point3d ptCorner = ln0.intersect(pn1, dEps);
	ptCorner.vis(4);
	Plane pn1Outside(ptCen1 - bm1.vecD(vecX10) * .5 * bm1.dD(vecX10), vecX10);
	
	Display dp(255);
	dp.showInDxa(true); //HSB-18650 standard display published for share and make
	Body bdNail;
	{ 
		Body bdHead(ptCen0, ptCen0 + vecX0 * dLengthHead, .5 * dDiameterHead);
		Body bdN(ptCen0, ptCen0 + vecX0 * dLengthScrew, .5 * dDiameterThread);
		bdNail.addPart(bdHead);
		bdNail.addPart(bdN);
	}
//	bdNail.vis(2);
	CoordSys csNailTransform;
	//region group assignment
	assignToLayer("i");
	assignToGroups(Entity(bm0));
	//End group assignment//endregion 
	// length of drill
	double dLengthDrillReal;
	if(dLengthDrill==0)
	{ 
		// only stud
		dLengthDrillReal= dLengthScrew;
	}
	else if(dLengthDrill<0)
	{
		dLengthDrill.set(-1);
		dLengthDrillReal= dLengthScrew;
	}
	else
	{ 
		dLengthDrillReal = dLengthDrill;
	}
	double dDiameterDrillReal;
	double dLengthDrillExtra;
	if(dDiameterDrill<=0)
	{ 
		dDiameterDrill.set(0);
		dDiameterDrillReal = dDiameterThread;
	}
	else
	{ 
		dDiameterDrillReal = dDiameterDrill;
	}
	Plane pn2(pn1Outside.ptOrg() + bm1.vecD(vecX10) * bm1.dD(vecX10), vecX10);
	
	if(abs(dAngle)>0)
	{ 
		// 2 nails with offset
		Vector3d vecZnail = vecX10.crossProduct(vecYop);
		vecZnail.normalize();
		Vector3d vecXnail = vecX10;
		CoordSys csRotate;
		csRotate.setToRotation(dAngle, vecZnail, ptCorner);
//		vecXnail.rotateBy(dAngle, vecZnail);
		vecXnail.transformBy(csRotate);
		Vector3d vecYnail = vecZnail.crossProduct(vecXnail);
		vecYnail.normalize();
		vecXnail.vis(ptCorner, 1);
		vecYnail.vis(ptCorner, 3);
		vecZnail.vis(ptCorner, 5);
		
		_Pt0 = ptCorner;
		
		Line lnNail(ptCorner, vecXnail);
		Point3d pt1Outside = lnNail.intersect(pn1Outside, dEps);
		pt1Outside.vis(5);
		LineSeg lSegNail(pt1Outside, pt1Outside + vecXnail * dLengthScrew);
		dp.draw(lSegNail);
		// draw screw
		csNailTransform.setToAlignCoordSys(ptCen0, vecX0, vecY0, vecZ0, pt1Outside, vecXnail, vecYnail, vecZnail);
		Body bdI = bdNail;
		bdI.transformBy(csNailTransform);
		bdI.vis(3);
		dp.draw(bdI);
//		dLengthDrillExtra = (.5 * dDiameterDrillReal) * tan(abs(dAngle));
		if(iDrill)
		{ 
//			if(dLengthDrill==0)
//			{ 
//				Line lnDrill(pt1Outside, vecXnail);
//				Point3d pt2Drill = lnDrill.intersect(pn2, dEps);
//				dLengthDrillReal = (pt2Drill - pt1Outside).length() + dLengthDrillExtra;
//			}
			Drill dr(pt1Outside-vecXnail*U(100), pt1Outside + vecXnail * dLengthDrillReal, .5 * dDiameterDrillReal );
			if(dLengthDrill!=0)
				bm0.addTool(dr);
			bm1.addTool(dr);
		}
		if (nQuantity <= 0)nQuantity.set(1);
		
		int nQuantityReal = 1;
		if(nQuantity>1)
		{ 
			for (int iQ=1;iQ<nQuantity;iQ++) 
			{ 
				ptCorner += vecYnail * dOffset;
				lnNail=Line (ptCorner, vecXnail);
				pt1Outside = lnNail.intersect(pn1Outside, dEps);
				Body bdTest(pt1Outside, pt1Outside + vecXnail * U(10e3), dEps);
				if(!bdTest.hasIntersection(bd0))
				{ 
					break;
				}
				nQuantityReal++;
				lSegNail= LineSeg (pt1Outside, pt1Outside + vecXnail * dLengthScrew);
				dp.draw(lSegNail);
				csNailTransform.setToAlignCoordSys(ptCen0, vecX0, vecY0, vecZ0, pt1Outside, vecXnail, vecYnail, vecZnail);
				Body bdI = bdNail;
				bdI.transformBy(csNailTransform);
				dp.draw(bdI);
				bdI.vis(3);
				if(iDrill)
				{ 
//					if(dLengthDrill==0)
//					{ 
//						Line lnDrill(pt1Outside, vecXnail);
//						Point3d pt2Drill = lnDrill.intersect(pn2, dEps);
//						dLengthDrillReal = (pt2Drill - pt1Outside).length() + dLengthDrillExtra;
//					}
					Drill dr(pt1Outside-vecXnail*U(100), pt1Outside + vecXnail * dLengthDrillReal, .5 * dDiameterDrillReal );
					if(dLengthDrill!=0)
						bm0.addTool(dr);
					bm1.addTool(dr);
				}
				
			}//next iQ
			nQuantity.set(nQuantityReal);
		}
	}
	else
	{ 
		// distribution horizontally
		if (nQuantity <= 0)nQuantity.set(1);
		int nQuantityReal = 1;
		Vector3d vecXnail = vecX10;
		Vector3d vecYnail = vecYop;
		Vector3d vecZnail = vecXnail.crossProduct(vecYop);
		vecZnail.normalize();
		
		int iQuantityHalf = nQuantity / 2;
		double dQuantityHalf = nQuantity; dQuantityHalf /= 2;
		
		Line lnNail(ptCen0, vecXnail);
		Point3d pt1OutsideCen= lnNail.intersect(pn1Outside, dEps);
		
		if(dQuantityHalf-iQuantityHalf>dEps)
		{ 
			// odd 
			Point3d ptStart = pt1OutsideCen;
			lnNail=Line (ptStart, vecXnail);
			Point3d pt1Outside = lnNail.intersect(pn1Outside, dEps);
			LineSeg lSegNail(pt1Outside, pt1Outside + vecXnail * dLengthScrew);
			dp.draw(lSegNail);
			csNailTransform.setToAlignCoordSys(ptCen0, vecX0, vecY0, vecZ0, pt1Outside, vecXnail, vecYnail, vecZnail);
			Body bdI = bdNail;
			bdI.transformBy(csNailTransform);
			dp.draw(bdI);
			if(iDrill)
			{ 
//				if(dLengthDrill==0)
//				{ 
//					Line lnDrill(pt1Outside, vecXnail);
//					Point3d pt2Drill = lnDrill.intersect(pn2, dEps);
//					dLengthDrillReal = (pt2Drill - pt1Outside).length() + dLengthDrillExtra;
//				}
				Drill dr(pt1Outside-vecXnail*U(100), pt1Outside + vecXnail * dLengthDrillReal, .5 * dDiameterDrillReal );
				if(dLengthDrill!=0)
					bm0.addTool(dr);
				bm1.addTool(dr);
			}
			int nQuantityReal = 1;
			for (int iSide=0;iSide<2;iSide++) 
			{ 
				ptStart = pt1OutsideCen;
				Vector3d vecSide = vecYnail;
				if (iSide == 1)vecSide = - vecYnail;
				for (int iQ=0;iQ<iQuantityHalf;iQ++) 
				{ 
					ptStart += vecSide * dOffset;
					lnNail=Line (ptStart, vecXnail);
					pt1Outside = lnNail.intersect(pn1Outside, dEps);
					Body bdTest(pt1Outside, pt1Outside + vecXnail * U(10e3), dEps);
					if(!bdTest.hasIntersection(bd0))
					{ 
						break;
					}
					nQuantityReal++;
					lSegNail= LineSeg (pt1Outside, pt1Outside + vecXnail * dLengthScrew);
					dp.draw(lSegNail);
					csNailTransform.setToAlignCoordSys(ptCen0, vecX0, vecY0, vecZ0, pt1Outside, vecXnail, vecYnail, vecZnail);
					Body bdI = bdNail;
					bdI.transformBy(csNailTransform);
					dp.draw(bdI);
					if(iDrill)
					{ 
//						if(dLengthDrill==0)
//						{ 
//							Line lnDrill(pt1Outside, vecXnail);
//							Point3d pt2Drill = lnDrill.intersect(pn2, dEps);
//							dLengthDrillReal = (pt2Drill - pt1Outside).length() + dLengthDrillExtra;
//						}
						Drill dr(pt1Outside-vecXnail*U(100), pt1Outside + vecXnail * dLengthDrillReal, .5 * dDiameterDrillReal );
						if(dLengthDrill!=0)
							bm0.addTool(dr);
						bm1.addTool(dr);
					}
				}//next iQ
			}//next iSide
			nQuantity.set(nQuantityReal);
		}
		else
		{ 
			// even
			Point3d ptStart = pt1OutsideCen;
			int nQuantityReal = 0;
			for (int iSide=0;iSide<2;iSide++) 
			{ 
				ptStart = pt1OutsideCen;
				Vector3d vecSide = vecYnail;
				if (iSide == 1)vecSide = - vecYnail;
				for (int iQ=0;iQ<iQuantityHalf;iQ++) 
				{ 
					ptStart = pt1OutsideCen +vecSide * (.5*dOffset+iQ*dOffset);
					lnNail=Line (ptStart, vecXnail);
					Point3d pt1Outside = lnNail.intersect(pn1Outside, dEps);
					Body bdTest(pt1Outside, pt1Outside + vecXnail * U(10e3), dEps);
					if(!bdTest.hasIntersection(bd0))
					{ 
						break;
					}
					nQuantityReal++;
					LineSeg lSegNail(pt1Outside, pt1Outside + vecXnail * dLengthScrew);
					dp.draw(lSegNail);
					csNailTransform.setToAlignCoordSys(ptCen0, vecX0, vecY0, vecZ0, pt1Outside, vecXnail, vecYnail, vecZnail);
					Body bdI = bdNail;
					bdI.transformBy(csNailTransform);
					dp.draw(bdI);
					if(iDrill)
					{ 
						Drill dr(pt1Outside-vecXnail*U(100), pt1Outside + vecXnail * dLengthDrillReal, .5 * dDiameterDrillReal );
						if(dLengthDrill!=0)
							bm0.addTool(dr);
						bm1.addTool(dr);
					}
				}//next iQ
			}//next iSide
			if (nQuantityReal > 0)
			{
				nQuantity.set(nQuantityReal);
			}
			else
			{ 
				nQuantity.set(1);
				setExecutionLoops(2);
				return;
			}
		}
		
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
			Element elHW =bm0.element(); 
			// check if the parent entity is an element
			if (!elHW.bIsValid())	elHW = (Element)bm0;
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
			HardWrComp hwc(sFamily, nQuantity); // the articleNumber and the quantity is mandatory
			
			hwc.setManufacturer(sManufacturer);
			
			hwc.setModel(sProduct);
			hwc.setArticleNumber(sArticleNr);
//			hwc.setName(sHWName);
//			hwc.setDescription(sHWDescription);
//			hwc.setMaterial(sHWMaterial);
//			hwc.setNotes(sHWNotes);
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(bm0);	
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
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="991" />
        <int nm="BREAKPOINT" vl="1002" />
        <int nm="BREAKPOINT" vl="1008" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18650 standard display published for share and make" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="5/10/2023 1:10:38 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13751: increase tolerance when comparing parallel vectors" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="12/14/2021 2:32:01 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11612: write article nr in hardware not family name" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="6/18/2021 2:33:29 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End