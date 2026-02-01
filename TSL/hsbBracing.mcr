#Version 8
#BeginDescription
#Versions
1.5 10.05.2023 HSB-18650 standard display published for share and make

1.4 31.03.2022 HSB-9044: Support side/zone changing on jig modus
1.3 31.03.2022 HSB-9044: Support gable walls
1.2 28.03.2022 HSB-9044: Implement for sheeting
1.1 28.03.2022 HSB-9044: Fix angle calculation on jig mode
1.0 07.03.2022 HSB-9044: initial version






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords Bracing;Brace;stiffener
#BeginContents
//region <History>
// #Versions
// 1.5 10.05.2023 HSB-18650 standard display published for share and make , Author Thorsten Huck
// 1.4 31.03.2022 HSB-9044: Support side/zone changing on jig modus Author: Marsel Nakuci
// 1.3 31.03.2022 HSB-9044: Support gable walls Author: Marsel Nakuci
// 1.2 28.03.2022 HSB-9044: Implement for sheeting Author: Marsel Nakuci
// 1.1 28.03.2022 HSB-9044: Fix angle calculation on jig mode Author: Marsel Nakuci
// 1.0 07.03.2022 HSB-9044: initial version Author: Marsel Nakuci

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl creates 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbBracing")) TSLCONTENT
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
	double dLMin=U(1800),dLMax=U(2700);
	double dAngleMin=U(30),dAngleMax=U(60);
	
	double dWidthSheet = U(900);
//	double dHeightSheet = U(2700);
	double dHeightSheet = U(400);
	double dThicknessSheet = U(400);
//region Properties
	// type of bracing/sheeting
	String sTypeName=T("|Type|");
	String sTypes[]={T("|Cross Brace|"), T("|Sheet|")};
	PropString sType(nStringIndex++, sTypes, sTypeName);	
	sType.setDescription(T("|Defines the Type of the bracing|"));
	sType.setCategory(category);
	
	// zone to define the side of the bracing/sheeting
	String sZoneName=T("|Zone|");
//	String sZones[] ={ "1", "-1", T("|Both|")};
	String sZones[] ={ "1", "-1"};
	PropString sZone(nStringIndex++, sZones, sZoneName);	
	sZone.setDescription(T("|Defines the Zone for the side of the bracing|"));
	sZone.setCategory(category);
	// option to add or not stud ties at studs
	String sStudTieName=T("|Stud Tie|");	
	PropString sStudTie(nStringIndex++, sNoYes, sStudTieName);	
	sStudTie.setDescription(T("|Defines the StudTie|"));
	sStudTie.setCategory(category);
	
	// 
	// manufacturers of the angle bracket
	String sManufacturers[0];
	String sManufacturerName = T("|Manufacturer|");
	PropString sManufacturer(nStringIndex++, sManufacturers, sManufacturerName);
	sManufacturer.setDescription(T("|Defines the Manufacturer|"));
	sManufacturer.setCategory(category);
	
	String sFamilies[0];
	String sFamilyName = T("|Family|");
	PropString sFamily(nStringIndex++, sFamilies.sorted(), sFamilyName);
	
	sFamily.setDescription(T("|Defines the Family|"));
	sFamily.setCategory(category);
	
	String sModels[0];
	String sModelName = T("|Model|");
	PropString sModel(nStringIndex++, sModels, sModelName);	
	sModel.setDescription(T("|Defines the Model|"));
	sModel.setCategory(category);
	
//End Properties//endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="hsbBracing";
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

//region get sManufacturers from the mapSetting
//	String sManufacturers[0];
	{ 
		// get the models of this family and populate the property list
		Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
		for (int i = 0; i < mapManufacturers.length(); i++)
		{
			Map mapManufacturerI = mapManufacturers.getMap(i);
			if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
			{
				String sManufacturerName = mapManufacturerI.getString("Name");
				if (sManufacturers.find(sManufacturerName) < 0)
				{
					sManufacturers.append(sManufacturerName);
				}
			}
		}
	}
//End get sManufacturers from the mapSetting//endregion 
	
//region jig
	String strJigAction1 = "strJigAction1";
	if (_bOnJig && _kExecuteKey == strJigAction1)
	{ 
		Vector3d vecView=getViewDirection();
		Entity entEl=_Map.getEntity("Element");
		Element el=(Element)entEl;
		int iType=_Map.getInt("Type");
		int iStudTie=_Map.getInt("StudTie");
		int iZone=_Map.getInt("Zone");
		int nZone = 1;
		
		// basic information
		Point3d ptOrg=el.ptOrg();
		Vector3d vecX=el.vecX();
		Vector3d vecY=el.vecY();
		Vector3d vecZ=el.vecZ();
		Point3d pts[]=_Map.getPoint3dArray("pts");
		Point3d ptJig=_Map.getPoint3d("_PtJig"); 
		
		Map mapModel = _Map.getMap("Model");
		
		Display dpjig(3);
		Display dpjigWarning(40);
		
		Display dpError(1);
		Display dpJigLight(2);
		Display dpDim1(6);
		dpDim1.textHeight(U(50));
		Display dpDim6(6);
		dpDim6.textHeight(U(50));
		Display dpDimIso(6);
		dpDimIso.textHeight(U(50));
		dpJigLight.transparency(80);
		dpError.textHeight(U(100));
		// draw text
		Vector3d vecZone = vecZ;
		if(iZone==1)
		{ 
			// zone -1 is selected
			vecZone*=-1;
			nZone = - 1;
		}
		
		dpDim1.addViewDirection(vecZone);
		dpDim6.addViewDirection(-vecZone);
		dpDimIso.addHideDirection(vecZone);
		dpDimIso.addHideDirection(-vecZone);
		ElemZone eZone0=el.zone(0);
		Plane pn(eZone0.ptOrg()+eZone0.vecZ()*.5*eZone0.dH(),eZone0.vecZ());
		ptJig=Line(ptJig, vecView).intersect(pn, U(0));
		dpjig.textHeight(U(300));
//		dpjig.draw(iZone, ptJig, _XW, _YW, 0, 0, _kDeviceX);
		
		if(iType==0)
		{ 
			if(mapModel.hasDouble("WidthMin"))
				dLMin=mapModel.getDouble("WidthMin");
			if(mapModel.hasDouble("WidthMax"))
				dLMax=mapModel.getDouble("WidthMax");
			if(mapModel.hasDouble("AngleMin"))
				dAngleMin=mapModel.getDouble("AngleMin");
			if(mapModel.hasDouble("AngleMax"))
				dAngleMax=mapModel.getDouble("AngleMax");
		// bracing type is selected
			if(pts.length()==0)
			{ 
				// first point to be selected
				dpjig.textHeight(U(200));
				for (int iDir=0;iDir<2;iDir++) 
				{ 
					int iFlagDir=1;
					if(iDir==1)iFlagDir=-1;
					int iBracingFound=false;
					// no first point, display default bracing
					// with ptjig as first point
//					if(iStudTie==0)
					{ 
						// bracing at studs
					// first and second point, bottom and top
						Point3d pt1Bottom, pt1Top, pt2Bottom, pt2Top;
						// no stud tie, bracing is placed at studs
						// get the closest stud
						Point3d pt1=ptJig;
						// 2. point for direction
						Point3d pt2=pt1+iFlagDir*vecX*U(100);
						// 
						Vector3d vecDir=vecX*vecX.dotProduct(pt2-pt1);
						vecDir.normalize();
						Beam beams[]=el.beam();
						Beam bmStuds[]=vecX.filterBeamsPerpendicularSort(beams);
//						Beam bmHors[]=vecY.filterBeamsPerpendicular(beams);
						// accept diagonal beams for gable walls
						Beam bmHors[0];
						for (int ibm=0;ibm<beams.length();ibm++) 
						{ 
							if(bmStuds.find(beams[ibm])<0)
								bmHors.append(beams[ibm]);
						}//next ibm
						
						// first diagonal
						Beam bmTop1,bmBottom1;
						// second diagonal
						Beam bmTop2,bmBottom2;
						Beam bmStud1, bmStud2;
						bmStud1=bmStuds[bmStuds.length()-1];
						double dDistMin=U(10e5);
						for (int ib=0;ib<bmStuds.length();ib++) 
						{ 
							double dDistI=abs(vecX.dotProduct(pt1-bmStuds[ib].ptCen()));
							if(dDistI<dDistMin)
							{ 
								bmStud1=bmStuds[ib];
								dDistMin=dDistI;
							}
						}//next ib
						
						Point3d ptLook=bmStud1.ptCen();
						Beam bmStud12;
						if(iStudTie==1)
						{ 
							dDistMin=U(10e5);
							for (int ib=0;ib<bmStuds.length();ib++) 
							{ 
								if(bmStuds[ib]==bmStud1)continue;
								double dDistI=abs(vecX.dotProduct(pt1-bmStuds[ib].ptCen()));
								if(dDistI<dDistMin)
								{ 
									bmStud12=bmStuds[ib];
									dDistMin=dDistI;
								}
							}//next ib
							ptLook=.5*(bmStud1.ptCen()+bmStud12.ptCen());
						}
	//					dpjig.draw(bmStud1.envelopeBody());//!!!!!
						
						
						Beam beamsTop[]=Beam().filterBeamsHalfLineIntersectSort(bmHors, ptLook, vecY);
						
						// draw text
//						dpjig.draw("X", ptLook, vecX, vecY, 0, 0, _kDeviceX);
//						if(beamsTop.length()==0)
//						{ 
//							return;
//						}
						
						bmTop1=beamsTop[beamsTop.length()-1];
						Beam beamsBottom[]=Beam().filterBeamsHalfLineIntersectSort(bmHors, ptLook, -vecY);
						bmBottom1=beamsBottom[beamsBottom.length()-1];
						pt1+=vecX*vecX.dotProduct(ptLook-pt1);
						int iIntersect=Line(ptLook,vecY)
							.hasIntersection(Plane(bmBottom1.ptCen()-bmBottom1.vecD(vecY)*.5*bmBottom1.dD(vecY),bmBottom1.vecD(vecY)),pt1Bottom);
						iIntersect=Line(ptLook,vecY)
							.hasIntersection(Plane(bmTop1.ptCen()+bmTop1.vecD(vecY)*.5*bmTop1.dD(vecY),bmTop1.vecD(vecY)),pt1Top);
						
						Beam bmStudsDir[] = vecDir.filterBeamsPerpendicularSort(bmStuds);
	//					bmStudsDir[0].envelopeBody().vis(2);
	//					int iBm1 = bmStudsDir.find(bmStud1);
						
						for (int ibm=bmStudsDir.length()-1; ibm>=0 ; ibm--) 
						{ 
							Beam bmI=bmStudsDir[ibm];
							Beam bmI2;
							Beam bmTopI,bmBottomI;
							double dDistI;
							Point3d ptLook = bmI.ptCen();
							if(iStudTie==1)
							{ 
								if (ibm == 0)break;
								ptLook =.5 *(bmStudsDir[ibm-1].ptCen()+bmI.ptCen());
								bmI2=bmStudsDir[ibm-1];
							}

							dDistI= abs(vecX.dotProduct(ptLook-pt1));
							if(dDistI>dLMax)
							{
								continue;
							}

							else
							{ 
								// check the angle
								Beam bmTopI,bmBottomI;
								Beam beamsTopI[]=Beam().filterBeamsHalfLineIntersectSort(bmHors,ptLook,vecY);
								if(beamsTopI.length()==0)
								{ 
									continue;
								}
								bmTopI=beamsTopI[beamsTopI.length()-1];
								Beam beamsBottomI[]=Beam().filterBeamsHalfLineIntersectSort(bmHors,ptLook,-vecY);
								if(beamsBottomI.length()==0)
								{ 
									continue;
								}
								bmBottomI=beamsBottomI[beamsBottomI.length()-1];
								//
								int iIntersect=Line(ptLook,vecY).hasIntersection(Plane(bmBottomI.ptCen()-bmBottomI.vecD(vecY)*.5*bmBottomI.dD(vecY),bmBottomI.vecD(vecY)),pt2Bottom);
								if(!iIntersect)
								{ 
									continue;
								}
								iIntersect=Line(ptLook,vecY).hasIntersection(Plane(bmTopI.ptCen()+bmTopI.vecD(vecY)*.5*bmTopI.dD(vecY),bmTopI.vecD(vecY)),pt2Top);
								if(!iIntersect)
								{ 
									continue;
								}
	//							_PtG[1] = pt2Bottom;
								pt2Bottom.vis(6);
								pt2Top.vis(6);
								// check the angle 
								Vector3d vec1=pt2Top-pt1Bottom;
								Vector3d vecXangle = vecX;
								vec1.normalize();
								if(vec1.dotProduct(vecXangle)<0)vecXangle*=-1;
								Vector3d vecRef = vec1.crossProduct(vecXangle);
								vecRef.normalize();
//								vec1.vis(pt1Bottom);
//								vecXangle.vis(pt1Bottom);
//								vecRef.vis(pt1Bottom);
//								double dAngle1=vec1.angleTo(vecXangle,vecRef);
								double dAngle1=vec1.angleTo(vecXangle);
								if (dAngle1 > U(90))dAngle1 -= U(90);
								if(dAngle1>dAngleMax)
								{ 
									// not possible
	//								reportMessage("\n"+scriptName()+" "+T("|bracing not possible|"));
	//								eraseInstance();
	//								return;
									
//									dpError.draw("Not possible", ptJig, vecX, vecY, 0, 0, _kDeviceX);
									break;
								}
								else if(dAngle1<dAngleMin)
								{ 
									continue;
								}
								Vector3d vec2=pt1Top-pt2Bottom;
								vec2.normalize();
								if(vec2.dotProduct(vecXangle)<0)vecXangle*=-1;
								vecRef = vec2.crossProduct(vecXangle);
								vecRef.normalize();
//								double dAngle2=vec2.angleTo(vecXangle,vecRef);
								double dAngle2=vec2.angleTo(vecXangle);
								if (dAngle2 > U(90))dAngle2 -= U(90);
								
								if(dAngle1>dAngleMax)
								{ 
									// not possible
	//								reportMessage("\n"+scriptName()+" "+T("|bracing not possible|"));
	//								eraseInstance();
	//								return;
								}
								
								else if(dAngle1<dAngleMin)
								{ 
									continue;
								}
								
								bmTop2 = bmTopI;
								bmBottom2 = bmBottomI;
								// valid connection
								iBracingFound=true;
								break;
							}
						}//next ibm
						if(!iBracingFound)
						{ 
	//						reportMessage("\n"+scriptName()+" "+T("|Bracing not possible|"));
	//						eraseInstance();
							if(iDir==0)
							{ 
								// check next direction
								continue;
							}
							else
							{ 
								dpError.draw("Bracing not possible", ptJig, vecX, vecY, 0, 0, _kDeviceX);
								return;
							}
						}
						
//						dpjig.draw(bmTop1.envelopeBody());
						// draw text
//						dpjig.draw("pt2Top", pt2Top, vecX, vecY, 0, 0, _kDeviceX);
//						dpjig.draw("pt1Top", pt1Top, vecX, vecY, 0, 0, _kDeviceX);
						Vector3d vecXbracing=pt2Top-pt1Bottom;
						vecXbracing.normalize();
						Vector3d vecYbracing=vecZ.crossProduct(vecXbracing);
						vecYbracing.normalize();
						
						PlaneProfile ppSubtractTop1(el.coordSys());
						PLine plSubtractTop1;
						plSubtractTop1.createRectangle(LineSeg(pt1Top-bmTop1.vecX()*U(10e4),
							pt1Top+bmTop1.vecX()*2*U(10e4)+bmTop1.vecD(vecY)*U(10e3)),bmTop1.vecX(),bmTop1.vecD(vecY));
				//		plSubtractTop1.vis(3);
						ppSubtractTop1.joinRing(plSubtractTop1, _kAdd);
						
						PlaneProfile ppSubtractTop2(el.coordSys());
						PLine plSubtractTop2;
						plSubtractTop2.createRectangle(LineSeg(pt2Top-bmTop2.vecX()*U(10e4),
							pt2Top+bmTop1.vecX()*2*U(10e4)+bmTop2.vecD(vecY)*U(10e3)),bmTop2.vecX(),bmTop2.vecD(vecY));
				//		plSubtractTop2.vis(3);
						ppSubtractTop2.joinRing(plSubtractTop1, _kAdd);
						
						PlaneProfile ppSubtractBottom1(el.coordSys());
						PLine plSubtractBottom1;
						plSubtractBottom1.createRectangle(LineSeg(pt1Bottom-bmBottom1.vecX()*U(10e4),
							pt1Bottom+bmBottom1.vecX()*2*U(10e4)-bmBottom1.vecD(vecY)*U(10e3)),bmBottom1.vecX(),bmBottom1.vecD(vecY));
				//		plSubtractTop1.vis(3);
						ppSubtractBottom1.joinRing(plSubtractBottom1, _kAdd);
				//		ppSubtractBottom1.vis(3);
						
						PlaneProfile ppSubtractBottom2(el.coordSys());
						PLine plSubtractBottom2;
						plSubtractBottom2.createRectangle(LineSeg(pt2Bottom-bmBottom2.vecX()*U(10e4),
							pt2Bottom+bmBottom2.vecX()*2*U(10e4)-bmBottom2.vecD(vecY)*U(10e3)),bmBottom2.vecX(),bmBottom2.vecD(vecY));
				//		plSubtractTop1.vis(3);
						ppSubtractBottom2.joinRing(plSubtractBottom2, _kAdd);
				//		ppSubtractBottom2.vis(3);
						
						PlaneProfile pp1(Plane(pt1Top,vecZ));
						PLine pl1;
						pl1.createRectangle(LineSeg(pt1Bottom-vecXbracing*U(100)-vecYbracing*U(15),pt2Top+vecXbracing*U(100)+vecYbracing*U(15)),
								vecXbracing, vecYbracing);
						
						pl1.transformBy(vecZone*.5*eZone0.dH());
						pl1.vis(1);
						pp1.joinRing(pl1, _kAdd);
						pp1.subtractProfile(ppSubtractBottom1);
						pp1.subtractProfile(ppSubtractTop1);
						pp1.transformBy(vecZone*.5*eZone0.dH());
				//		double ddd = eZone0.dH();
						pp1.vis(4);
						PLine pls1[] = pp1.allRings(true, false);
						pl1 = pls1[0];
						
						
						Body bd1(pl1, vecZone*U(2));
						
						// second bracing
						vecXbracing=pt2Bottom-pt1Top;
						vecXbracing.normalize();
						vecYbracing=vecZ.crossProduct(vecXbracing);
						vecYbracing.normalize();
						
						PlaneProfile pp2(Plane(pt1Top,vecZ));
						PLine pl2;
						pl2.createRectangle(LineSeg(pt1Top-vecXbracing*U(100)-vecYbracing*U(15),pt2Bottom+vecXbracing*U(100)+vecYbracing*U(15)),
								vecXbracing, vecYbracing);
				//		pl2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
						pp2.joinRing(pl2, _kAdd);
						pp2.subtractProfile(ppSubtractBottom2);
						pp2.subtractProfile(ppSubtractTop2);
						pp2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
						PLine pls2[] = pp2.allRings(true, false);
						pl2 = pls2[0];
						pl2.vis(3);
						Body bd2(pl2, vecZone * U(2));
						bd2.vis(3);
				//		dp.draw(pl1);
						dpjig.draw(bd1);
						dpjig.draw(bd2);
					}
					if(iBracingFound)
						break;
				}//next iDir
			}
//				else if(pts.length()==1)
			else if(pts.length()>0)
			{ 
				dpjig.textHeight(U(200));
//				dpjig.draw(pts.length(), ptJig, vecX, vecY, 0, 0, _kDeviceX);
				// draw text

				// 2 points 
				// second point to decide the bracing
//				if (iStudTie == 0)
				{
					// bracing at studs
					Entity entStud1 = _Map.getEntity("Stud1");
					Beam bmStud1 = (Beam)entStud1;
					Beam bmStud12;
					Point3d ptLook = bmStud1.ptCen();
					if(iStudTie==1)
					{ 
						Entity entStud12=_Map.getEntity("Stud12");
						bmStud12=(Beam)entStud12;
						ptLook=.5*(bmStud1.ptCen()+bmStud12.ptCen());
					}
					// first and second point, bottom and top
					Point3d pt1Bottom, pt1Top, pt2Bottom, pt2Top;
					// no stud tie, bracing is placed at studs
					// get the closest stud
					Point3d pt1 = pts[0];
					
//					dpjig.draw("pt1", pt1, vecX, vecY, 0, 0, _kDeviceX);
					Point3d pt2 = ptJig;
					Vector3d vecDir = vecX * vecX.dotProduct(pt2 - pt1);
					vecDir.normalize();
					Beam beams[] = el.beam();
					Beam bmStuds[] = vecX.filterBeamsPerpendicularSort(beams);
//					Beam bmHors[] = vecY.filterBeamsPerpendicular(beams);
					// accept diagonal beams for gable walls
					Beam bmHors[0];
					for (int ibm=0;ibm<beams.length();ibm++) 
					{ 
						if(bmStuds.find(beams[ibm])<0)
							bmHors.append(beams[ibm]);
					}//next ibm
					Beam bmTop1, bmBottom1;
					// second diagonal
					Beam bmTop2, bmBottom2;
					double dAngle1, dAngle2, dLength2;
					Beam bmStud2;
					Beam beamsTop[] = Beam().filterBeamsHalfLineIntersectSort(bmHors, ptLook, vecY);
					bmTop1 = beamsTop[beamsTop.length() - 1];
					Beam beamsBottom[] = Beam().filterBeamsHalfLineIntersectSort(bmHors, ptLook, - vecY);
					bmBottom1 = beamsBottom[beamsBottom.length() - 1];
					pt1 += vecX * vecX.dotProduct(ptLook- pt1);
					int iIntersect = Line(ptLook, vecY)
					.hasIntersection(Plane(bmBottom1.ptCen() - bmBottom1.vecD(vecY) * .5 * bmBottom1.dD(vecY), bmBottom1.vecD(vecY)), pt1Bottom);
					iIntersect = Line(ptLook, vecY)
					.hasIntersection(Plane(bmTop1.ptCen() + bmTop1.vecD(vecY) * .5 * bmTop1.dD(vecY), bmTop1.vecD(vecY)), pt1Top);
					Beam bmStudsDir[] = vecDir.filterBeamsPerpendicularSort(bmStuds);
					
					// get min max bmStud2
					Point3d pt2MinBottom, pt2MinTop;
					Point3d pt2MaxBottom, pt2MaxTop;
					Beam bmStudMin2, bmStudMax2;
					Beam bmTopMin2, bmTopMax2;
					Beam bmBottomMin2, bmBottomMax2;
					// min max found valid angles
					double dAngle2Min1 = U(10e5), dAngle2Max1 = -U(10e5);
					double dAngle2Min2 = U(10e5), dAngle2Max2 = -U(10e5);
					// min max found valid lengths
					double dLength2Min = U(10e5), dLength2Max = -U(10e5);
					//
					double dDistMin = U(10e4);
					int iMinFound, iMaxFound;
					for (int ibm = bmStudsDir.length()-1; ibm >= 0; ibm--)
					{
						Beam bmI = bmStudsDir[ibm];
						Beam bmI2;
						Point3d ptLook=bmI.ptCen();
						if(iStudTie==1)
						{ 
							if(ibm==0)break;
							bmI2=bmStudsDir[ibm-1];
							ptLook=.5*(bmI.ptCen()+bmI2.ptCen());
						}
						Beam bmTopI, bmBottomI;
						double dLengthI = (vecDir.dotProduct(ptLook-pt1));
						double dDistI = abs(vecDir.dotProduct(ptLook- ptJig));
						
//						if (dDistI > dLMax)
//						{
//							continue;
//						}
//						else
						{
							// check the angle
							Point3d pt2TopI,pt2BottomI;
							Beam bmTopI, bmBottomI;
							Beam beamsTopI[] = Beam().filterBeamsHalfLineIntersectSort(bmHors, ptLook, vecY);
							if (beamsTopI.length() == 0)
							{
								continue;
							}
							bmTopI=beamsTopI[beamsTopI.length()-1];
							Beam beamsBottomI[] = Beam().filterBeamsHalfLineIntersectSort(bmHors, ptLook, - vecY);
							if (beamsBottomI.length() == 0)
							{
								continue;
							}
							bmBottomI=beamsBottomI[beamsBottomI.length()-1];
							
							//
							int iIntersect=Line(ptLook,vecY)
								.hasIntersection(Plane(bmBottomI.ptCen()-bmBottomI.vecD(vecY)*.5*bmBottomI.dD(vecY),bmBottomI.vecD(vecY)),pt2BottomI);
							if ( !iIntersect)
							{
								continue;
							}
							iIntersect=Line(ptLook,vecY)
								.hasIntersection(Plane(bmTopI.ptCen()+bmTopI.vecD(vecY)*.5*bmTopI.dD(vecY),bmTopI.vecD(vecY)),pt2TopI);
							if ( !iIntersect)
							{
								continue;
							}
							
							Vector3d vec1 = pt2TopI-pt1Bottom;
							Vector3d vecXangle = vecDir;
							vec1.normalize();
							if (vec1.dotProduct(vecXangle) < 0)vecXangle *= -1;
							Vector3d vecRef=vec1.crossProduct(vecXangle);
							vecRef.normalize();
//							vec1.vis(pt1Bottom);
//							vecXangle.vis(pt1Bottom);
//							vecRef.vis(pt1Bottom);
//							double dAngleI1=vec1.angleTo(vecXangle, vecRef);
							double dAngleI1=vec1.angleTo(vecXangle);
							if (dAngleI1 > U(90))dAngleI1 -= U(90);
							Vector3d vec2=pt1Top-pt2BottomI;
							vec2.normalize();
							if(vec2.dotProduct(vecXangle)<0)vecXangle*=-1;
							vecRef=vec2.crossProduct(vecXangle);
							vecRef.normalize();
//							double dAngleI2=vec2.angleTo(vecXangle,vecRef);
							double dAngleI2=vec2.angleTo(vecXangle);
							if (dAngleI2 > U(90))dAngleI2 -= U(90);
							if (dDistI < dDistMin)
							{
								// get closest possible beam
								dDistMin=dDistI;
								bmStud2=bmI;
								bmBottom2=bmBottomI;
								bmTop2=bmTopI;
								dAngle1=dAngleI1;
								dAngle2=dAngleI2;
								dLength2=dLengthI;
								pt2Bottom=pt2BottomI;
								pt2Top=pt2TopI;
							}
							if (dAngleI1>dAngleMax)
							{
								// bracing not possible
//								break;
							}
							else if (dAngleI1<dAngleMin)
							{
//								continue;
							}
							// valid bracing
							if(dAngleI1>=dAngleMin && dAngleI1<=dAngleMax
							&& dAngleI2>=dAngleMin && dAngleI2<=dAngleMax
							&& dLengthI>=dLMin && dLengthI<=dLMax)
							{ 
								// capture min max valid bracings
								if(dLengthI<dLength2Min)
								{ 
									iMinFound = true;
									dLength2Min=dLengthI;
									bmStudMin2=bmI;
									dAngle2Min1=dAngleI1;
									dAngle2Min2=dAngleI2;
									pt2MinBottom = pt2BottomI;
									pt2MinTop = pt2TopI;
									bmBottomMin2 = bmBottomI;
									bmTopMin2 = bmTopI;
								}
								if(dLengthI>dLength2Max)
								{ 
									iMaxFound = true;
									dLength2Max=dLengthI;
									bmStudMax2=bmI;
									dAngle2Max1=dAngleI1;
									dAngle2Max2=dAngleI2;
									pt2MaxBottom = pt2BottomI;
									pt2MaxTop = pt2TopI;
									bmBottomMax2= bmBottomI;
									bmTopMax2 = bmTopI;
									
								}
							}
						}
					}
					
					// display in jig
					// top profile subtract
					PlaneProfile ppSubtractTop1(el.coordSys());
					PLine plSubtractTop1;
					plSubtractTop1.createRectangle(LineSeg(pt1Top-bmTop1.vecX()*U(10e4),
						pt1Top+bmTop1.vecX()*2*U(10e4)+bmTop1.vecD(vecY)*U(10e3)),bmTop1.vecX(),bmTop1.vecD(vecY));
			//		plSubtractTop1.vis(3);
					ppSubtractTop1.joinRing(plSubtractTop1, _kAdd);
					// bottom profile subtract
					PlaneProfile ppSubtractBottom1(el.coordSys());
					PLine plSubtractBottom1;
					plSubtractBottom1.createRectangle(LineSeg(pt1Bottom-bmBottom1.vecX()*U(10e4),
						pt1Bottom+bmBottom1.vecX()*2*U(10e4)-bmBottom1.vecD(vecY)*U(10e3)),bmBottom1.vecX(),bmBottom1.vecD(vecY));
			//		plSubtractTop1.vis(3);
					ppSubtractBottom1.joinRing(plSubtractBottom1, _kAdd);
					int iClock = vecDir.dotProduct(vecX) > 0;
					// Min
					if (iMinFound)
					{ 
						PlaneProfile ppSubtractBottom2(el.coordSys());
						PLine plSubtractBottom2;
						plSubtractBottom2.createRectangle(LineSeg(pt2MinBottom-bmBottomMin2.vecX()*U(10e4),
							pt2MinBottom+bmBottomMin2.vecX()*2*U(10e4)-bmBottomMin2.vecD(vecY)*U(10e3)),bmBottomMin2.vecX(),bmBottom2.vecD(vecY));
				//		plSubtractTop1.vis(3);
						ppSubtractBottom2.joinRing(plSubtractBottom2, _kAdd);
						
						PlaneProfile ppSubtractTop2(el.coordSys());
						PLine plSubtractTop2;
						plSubtractTop2.createRectangle(LineSeg(pt2MinTop-bmTop2.vecX()*U(10e4),
							pt2MinTop+bmTop1.vecX()*2*U(10e4)+bmTop2.vecD(vecY)*U(10e3)),bmTop2.vecX(),bmTop2.vecD(vecY));
				//		plSubtractTop2.vis(3);
						ppSubtractTop2.joinRing(plSubtractTop1, _kAdd);
						
						Vector3d vecXbracing=pt2MinTop-pt1Bottom;
						vecXbracing.normalize();
						Vector3d vecYbracing=vecZ.crossProduct(vecXbracing);
						vecYbracing.normalize();
						PlaneProfile pp1(Plane(pt1Top,vecZ));
						PLine pl1;
						pl1.createRectangle(LineSeg(pt1Bottom-vecXbracing*U(100)-vecYbracing*U(2),
							pt2MinTop+vecXbracing*U(100)+vecYbracing*U(2)),
								vecXbracing, vecYbracing);
						
						pl1.transformBy(vecZone*.5*eZone0.dH());
						pl1.vis(1);
						pp1.joinRing(pl1, _kAdd);
						pp1.subtractProfile(ppSubtractBottom1);
						pp1.subtractProfile(ppSubtractTop1);
						pp1.transformBy(vecZone*.5*eZone0.dH());
				//		double ddd = eZone0.dH();
						pp1.vis(4);
						PLine pls1[] = pp1.allRings(true, false);
						dpJigLight.draw(pp1, _kDrawFilled);
						if(pls1.length()==0)return;
						pl1 = pls1[0];
						Body bd1(pl1, vecZone*U(2));
						
						// second bracing
						vecXbracing=pt2MinBottom-pt1Top;
						vecXbracing.normalize();
						vecYbracing=vecZ.crossProduct(vecXbracing);
						vecYbracing.normalize();
						
						PlaneProfile pp2(Plane(pt1Top,vecZ));
						PLine pl2;
						pl2.createRectangle(LineSeg(pt1Top-vecXbracing*U(100)-vecYbracing*U(2),
							pt2MinBottom+vecXbracing*U(100)+vecYbracing*U(2)),
								vecXbracing, vecYbracing);
				//		pl2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
						pp2.joinRing(pl2, _kAdd);
						pp2.subtractProfile(ppSubtractBottom2);
						pp2.subtractProfile(ppSubtractTop2);
						pp2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
						dpJigLight.draw(pp2, _kDrawFilled);
						
						PLine pls2[] = pp2.allRings(true, false);
						pl2 = pls2[0];
						pl2.vis(3);
						Body bd2(pl2, vecZone * U(2));
						bd2.vis(3);
				//		dp.draw(pl1);
//						dpJigLight.draw(bd1);
//						dpJigLight.draw(bd2);
						// display angle and arc
						{
							// draw text
							// arc left
							Vector3d vecXzone = vecY.crossProduct(vecZone);
							{ 
								Vector3d vec1=pt2MinTop-pt1Bottom;
								vec1.normalize();
								Point3d ptArc1 = pt1Bottom + vec1 * U(200);
								Point3d ptArc2 = pt1Bottom + vecDir * U(200);
								Vector3d vecArcMiddle = vec1 + vecDir;
								vecArcMiddle.normalize();
								Point3d ptArcMiddle = pt1Bottom + vecArcMiddle * U(200);
								PLine plArc(vecZ);
								plArc.addVertex(ptArc1);
								plArc.addVertex(ptArc2,U(200), iClock,true);
								
//								plArc.addVertex(ptArc2,ptArcMiddle);
//								plArc.addVertex(ptArc2,ptArcMiddle);
//								plArc.addVertex(ptArc2,ptArcMiddle);
								dpDim1.draw(plArc);
								dpDim6.draw(plArc);
								dpDimIso.draw(plArc);
								
								Vector3d vecXdim1 = vecArcMiddle.dotProduct(vecXzone)>0?vecArcMiddle:-vecArcMiddle;
								Vector3d vecYdim = vecZone.crossProduct(vecXdim1);
								String sAngle2Min1;sAngle2Min1.format("%.1f", dAngle2Min1);
								dpDim1.draw(sAngle2Min1, ptArcMiddle, vecXdim1, vecYdim, 0, 0);
								dpDim6.draw(sAngle2Min1, ptArcMiddle, -vecXdim1, vecYdim, 0, 0);
								dpDimIso.draw(sAngle2Min1, ptArcMiddle, _XW, _YW, 0, 0,_kDeviceX);
							}
							// arc right
							{ 
								Vector3d vec1=pt1Top-pt2MinBottom;
								vec1.normalize();
								Point3d ptArc1 = pt2MinBottom + vec1 * U(200);
								Point3d ptArc2 = pt2MinBottom + -vecDir * U(200);
								Vector3d vecArcMiddle = vec1 + -vecDir;
								vecArcMiddle.normalize();
								Point3d ptArcMiddle = pt2MinBottom + vecArcMiddle * U(200);
								PLine plArc(-vecZ);
								plArc.addVertex(ptArc1);
//								plArc.addVertex(ptArc2,ptArcMiddle);
//								plArc.addVertex(ptArcMiddle,ptArc2);
//								plArc.addVertex(ptArc2,ptArcMiddle);
								plArc.addVertex(ptArc2,U(200), -iClock,true);

								dpDim1.draw(plArc);
								dpDim6.draw(plArc);
								dpDimIso.draw(plArc);
								Vector3d vecXdim1 = vecArcMiddle.dotProduct(vecXzone)>0?vecArcMiddle:-vecArcMiddle;
								Vector3d vecYdim = vecZone.crossProduct(vecXdim1);
								String sAngle2Min2;sAngle2Min2.format("%.1f", dAngle2Min2);
								dpDim1.draw(sAngle2Min2, ptArcMiddle, vecXdim1, vecYdim, 0, 0);
								dpDim6.draw(sAngle2Min2, ptArcMiddle, -vecXdim1, vecYdim, 0, 0);
								dpDimIso.draw(sAngle2Min2, ptArcMiddle, _XW, _YW, 0, 0,_kDeviceX);
							}
							
							// DimLine requires a dimstyle
							Vector3d vecXdimHor1 = vecXzone;
							
//							DimLine dl(pt1Bottom - vecY * U(100), vecXdimHor1, vecYdim);
//							Dim dim(dl, pt1Bottom, pt2MinBottom );
//							dpDim1.draw(dim);
							
							// 
							LineSeg seg(pt1Bottom-vecDir*U(50)-vecY*U(150), 
								pt2MinBottom + vecDir * U(50) - vecY * U(150));
							LineSeg seg1(pt1Bottom-vecY*U(150+50), 
								pt1Bottom - vecY * U(150-50));
							LineSeg seg2(pt2MinBottom-vecY*U(150+50), 
								pt2MinBottom - vecY * U(150-50));
							dpDim1.draw(seg);							
							dpDim6.draw(seg);							
							dpDimIso.draw(seg);							
							dpDim1.draw(seg1);
							dpDim6.draw(seg1);
							dpDimIso.draw(seg1);
							dpDim1.draw(seg2);
							dpDim6.draw(seg2);
							dpDimIso.draw(seg2);
							String sLength2Min;sLength2Min.format("%.1f", dLength2Min);
							dpDim1.draw(sLength2Min, seg.ptMid(), vecXdimHor1, vecY, 0, 1.2);
							dpDim6.draw(sLength2Min, seg.ptMid(), -vecXdimHor1, vecY, 0, 1.2);
							dpDimIso.draw(sLength2Min, seg.ptMid(), _XW, _YW, 0, 1.2,_kDeviceX);
						}
					}
					// Max
					if(iMaxFound)
					{ 
						PlaneProfile ppSubtractBottom2(el.coordSys());
						PLine plSubtractBottom2;
						plSubtractBottom2.createRectangle(LineSeg(pt2MaxBottom-bmBottomMax2.vecX()*U(10e4),
							pt2MaxBottom+bmBottomMax2.vecX()*2*U(10e4)-bmBottomMax2.vecD(vecY)*U(10e3)),bmBottomMax2.vecX(),bmBottomMax2.vecD(vecY));
				//		plSubtractTop1.vis(3);
						ppSubtractBottom2.joinRing(plSubtractBottom2, _kAdd);
						
						PlaneProfile ppSubtractTop2(el.coordSys());
						PLine plSubtractTop2;
						plSubtractTop2.createRectangle(LineSeg(pt2MaxTop-bmTop2.vecX()*U(10e4),
							pt2MaxTop+bmTop1.vecX()*2*U(10e4)+bmTop2.vecD(vecY)*U(10e3)),bmTop2.vecX(),bmTop2.vecD(vecY));
				//		plSubtractTop2.vis(3);
						ppSubtractTop2.joinRing(plSubtractTop1, _kAdd);
						
						Vector3d vecXbracing=pt2MaxTop-pt1Bottom;
						vecXbracing.normalize();
						Vector3d vecYbracing=vecZ.crossProduct(vecXbracing);
						vecYbracing.normalize();
						
						PlaneProfile pp1(Plane(pt1Top,vecZ));
						PLine pl1;
						pl1.createRectangle(LineSeg(pt1Bottom-vecXbracing*U(100)-vecYbracing*U(2),pt2MaxTop+vecXbracing*U(100)+vecYbracing*U(2)),
								vecXbracing, vecYbracing);
						
						pl1.transformBy(vecZone*.5*eZone0.dH());
						pl1.vis(1);
						pp1.joinRing(pl1, _kAdd);
						pp1.subtractProfile(ppSubtractBottom1);
						pp1.subtractProfile(ppSubtractTop1);
						pp1.transformBy(vecZone*.5*eZone0.dH());
						dpJigLight.draw(pp1, _kDrawFilled);
				//		double ddd = eZone0.dH();
						pp1.vis(4);
						PLine pls1[] = pp1.allRings(true, false);
						if(pls1.length()==0)return;
						pl1 = pls1[0];
						Body bd1(pl1, vecZone*U(2));
						
						// second bracing
						vecXbracing=pt2MaxBottom-pt1Top;
						vecXbracing.normalize();
						vecYbracing=vecZ.crossProduct(vecXbracing);
						vecYbracing.normalize();
						
						PlaneProfile pp2(Plane(pt1Top,vecZ));
						PLine pl2;
						pl2.createRectangle(LineSeg(pt1Top-vecXbracing*U(100)-vecYbracing*U(2),pt2MaxBottom+vecXbracing*U(100)+vecYbracing*U(2)),
								vecXbracing, vecYbracing);
				//		pl2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
						pp2.joinRing(pl2, _kAdd);
						pp2.subtractProfile(ppSubtractBottom2);
						pp2.subtractProfile(ppSubtractTop2);
						pp2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
						dpJigLight.draw(pp2, _kDrawFilled);
						
						PLine pls2[] = pp2.allRings(true, false);
						pl2 = pls2[0];
						pl2.vis(3);
						Body bd2(pl2, vecZone * U(2));
						bd2.vis(3);
				//		dp.draw(pl1);
//						dpjig.draw(bd1);
//						dpjig.draw(bd2);
						// display angle and arc
						{
							// draw text
							Vector3d vecXzone = vecY.crossProduct(vecZone);
							// arc left
							{ 
								Vector3d vec1=pt2MaxTop-pt1Bottom;
								vec1.normalize();
								Point3d ptArc1 = pt1Bottom + vec1 * U(400);
								Point3d ptArc2 = pt1Bottom + vecDir * U(400);
								Vector3d vecArcMiddle = vec1 + vecDir;
								vecArcMiddle.normalize();
								Point3d ptArcMiddle = pt1Bottom + vecArcMiddle * U(400);
								PLine plArc(vecZ);
								plArc.addVertex(ptArc1);
//								plArc.addVertex(ptArc2,ptArcMiddle);
//								plArc.addVertex(ptArcMiddle,ptArc2);
//								plArc.addVertex(ptArc2,ptArcMiddle);
								plArc.addVertex(ptArc2,U(400), iClock,true);
								dpDim1.draw(plArc);
								dpDim6.draw(plArc);
								dpDimIso.draw(plArc);
								
								Vector3d vecXdim1 = vecArcMiddle.dotProduct(vecXzone)>0?vecArcMiddle:-vecArcMiddle;
								Vector3d vecYdim = vecZone.crossProduct(vecXdim1);
								String sAngle2Max1;sAngle2Max1.format("%.1f", dAngle2Max1);
								dpDim1.draw(sAngle2Max1, ptArcMiddle, vecXdim1, vecYdim, 0, 0);
								dpDim6.draw(sAngle2Max1, ptArcMiddle, -vecXdim1, vecYdim, 0, 0);
								dpDimIso.draw(sAngle2Max1, ptArcMiddle, _XW, _YW, 0, 0,_kDeviceX);
							}
							// arc right
							{ 
								Vector3d vec1=pt1Top-pt2MaxBottom;
								vec1.normalize();
								Point3d ptArc1 = pt2MaxBottom + vec1 * U(200);
								Point3d ptArc2 = pt2MaxBottom + -vecDir * U(200);
								Vector3d vecArcMiddle = vec1 + -vecDir;
								vecArcMiddle.normalize();
								Point3d ptArcMiddle = pt2MaxBottom + vecArcMiddle * U(200);
								PLine plArc(-vecZ);
								plArc.addVertex(ptArc1);
//								plArc.addVertex(ptArc2,ptArcMiddle);
//								plArc.addVertex(ptArcMiddle,ptArc2);
//								plArc.addVertex(ptArc2,ptArcMiddle);
								plArc.addVertex(ptArc2,U(200), -iClock,true);
								dpDim1.draw(plArc);
								dpDim6.draw(plArc);
								dpDimIso.draw(plArc);
								Vector3d vecXdim1 = vecArcMiddle.dotProduct(vecXzone)>0?vecArcMiddle:-vecArcMiddle;
								Vector3d vecYdim = vecZone.crossProduct(vecXdim1);
								String sAngle2Max2;sAngle2Max2.format("%.1f", dAngle2Max2);
								dpDim1.draw(sAngle2Max2, ptArcMiddle, vecXdim1, vecYdim, 0, 0);
								dpDim6.draw(sAngle2Max2, ptArcMiddle, -vecXdim1, vecYdim, 0, 0);
								dpDimIso.draw(sAngle2Max2, ptArcMiddle, _XW, _YW, 0, 0,_kDeviceX);
							}
							
							// DimLine requires a dimstyle
							Vector3d vecXdimHor1 = vecXzone;
							
//							DimLine dl(pt1Bottom - vecY * U(100), vecXdimHor1, vecYdim);
//							Dim dim(dl, pt1Bottom, pt2MinBottom );
//							dpDim1.draw(dim);
							
							// 
							LineSeg seg(pt1Bottom-vecDir*U(50)-vecY*U(300), 
								pt2MaxBottom + vecDir * U(50) - vecY * U(300));
							LineSeg seg1(pt1Bottom-vecY*U(300+50), 
								pt1Bottom - vecY * U(300-50));
							LineSeg seg2(pt2MaxBottom-vecY*U(300+50), 
								pt2MaxBottom - vecY * U(300-50));
							dpDim1.draw(seg);							
							dpDim6.draw(seg);							
							dpDimIso.draw(seg);							
							dpDim1.draw(seg1);
							dpDim6.draw(seg1);
							dpDimIso.draw(seg1);
							dpDim1.draw(seg2);
							dpDim6.draw(seg2);
							dpDimIso.draw(seg2);
							String sLength2Max;sLength2Max.format("%.1f", dLength2Max);
							dpDim1.draw(sLength2Max, seg.ptMid(), vecXdimHor1, vecY, 0, 1.2);
							dpDim6.draw(sLength2Max, seg.ptMid(), -vecXdimHor1, vecY, 0, 1.2);
							dpDimIso.draw(sLength2Max, seg.ptMid(), _XW, _YW, 0, 1.2,_kDeviceX);
						}
					}
					// Brace
					{ 
						PlaneProfile ppSubtractBottom2(el.coordSys());
						PLine plSubtractBottom2;
						plSubtractBottom2.createRectangle(LineSeg(pt2Bottom-bmBottom2.vecX()*U(10e4),
							pt2Bottom+bmBottom2.vecX()*2*U(10e4)-bmBottom2.vecD(vecY)*U(10e3)),bmBottom2.vecX(),bmBottom2.vecD(vecY));
				//		plSubtractTop1.vis(3);
						ppSubtractBottom2.joinRing(plSubtractBottom2, _kAdd);
						
						PlaneProfile ppSubtractTop2(el.coordSys());
						PLine plSubtractTop2;
						plSubtractTop2.createRectangle(LineSeg(pt2Top-bmTop2.vecX()*U(10e4),
							pt2Top+bmTop1.vecX()*2*U(10e4)+bmTop2.vecD(vecY)*U(10e3)),bmTop2.vecX(),bmTop2.vecD(vecY));
				//		plSubtractTop2.vis(3);
						ppSubtractTop2.joinRing(plSubtractTop1, _kAdd);
						
						Vector3d vecXbracing=pt2Top-pt1Bottom;
						vecXbracing.normalize();
						Vector3d vecYbracing=vecZ.crossProduct(vecXbracing);
						vecYbracing.normalize();
						
						PlaneProfile pp1(Plane(pt1Top,vecZ));
						PLine pl1;
						pl1.createRectangle(LineSeg(pt1Bottom-vecXbracing*U(100)-vecYbracing*U(15),pt2Top+vecXbracing*U(100)+vecYbracing*U(15)),
								vecXbracing, vecYbracing);
						
						pl1.transformBy(vecZone*.5*eZone0.dH());
						pl1.vis(1);
						pp1.joinRing(pl1, _kAdd);
						pp1.subtractProfile(ppSubtractBottom1);
						pp1.subtractProfile(ppSubtractTop1);
						pp1.transformBy(vecZone*.5*eZone0.dH());
				//		double ddd = eZone0.dH();
						pp1.vis(4);
						PLine pls1[] = pp1.allRings(true, false);
						if(pls1.length()==0)return;
						pl1 = pls1[0];
						Body bd1(pl1, vecZone*U(2));
						
						// second bracing
						vecXbracing=pt2Bottom-pt1Top;
						vecXbracing.normalize();
						vecYbracing=vecZ.crossProduct(vecXbracing);
						vecYbracing.normalize();
						
						PlaneProfile pp2(Plane(pt1Top,vecZ));
						PLine pl2;
						pl2.createRectangle(LineSeg(pt1Top-vecXbracing*U(100)-vecYbracing*U(15),pt2Bottom+vecXbracing*U(100)+vecYbracing*U(15)),
								vecXbracing, vecYbracing);
				//		pl2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
						pp2.joinRing(pl2, _kAdd);
						pp2.subtractProfile(ppSubtractBottom2);
						pp2.subtractProfile(ppSubtractTop2);
						pp2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
						PLine pls2[] = pp2.allRings(true, false);
						pl2 = pls2[0];
						pl2.vis(3);
						Body bd2(pl2, vecZone * U(2));
						bd2.vis(3);
				//		dp.draw(pl1);
						if(dAngle1>=dAngleMin && dAngle1<=dAngleMax
							&& dAngle2>=dAngleMin && dAngle2<=dAngleMax
							&& dLength2>=dLMin && dLength2<=dLMax)
						{ 
							dpjig.draw(bd1);
							dpjig.draw(bd2);
						}
						else
						{ 
							dpError.draw(bd1);
							dpError.draw(bd2);
						}
						// display angle and arc
						{
							// draw text
							Vector3d vecXzone = vecY.crossProduct(vecZone);
							// arc left
							{ 
								Vector3d vec1=pt2Top-pt1Bottom;
								vec1.normalize();
								Point3d ptArc1 = pt1Bottom + vec1 * U(600);
								Point3d ptArc2 = pt1Bottom + vecDir * U(600);
								Vector3d vecArcMiddle = vec1 + vecDir;
								vecArcMiddle.normalize();
								Point3d ptArcMiddle = pt1Bottom + vecArcMiddle * U(600);
								PLine plArc(vecZ);
								plArc.addVertex(ptArc1);
//								plArc.addVertex(ptArc2,ptArcMiddle);
//								plArc.addVertex(ptArcMiddle,ptArc2);
//								plArc.addVertex(ptArc2,ptArcMiddle);
								plArc.addVertex(ptArc2,U(600), iClock,true);
								
								if(dAngle1<dAngleMin || dAngle1>dAngleMax)
								{ 
									dpDim1.color(1);
									dpDim6.color(1);
									dpDimIso.color(1);
								}
								else
								{ 
									dpDim1.color(3);
									dpDim6.color(3);
									dpDimIso.color(3);
								}
								dpDim1.draw(plArc);
								dpDim6.draw(plArc);
								dpDimIso.draw(plArc);
								Vector3d vecXdim1 = vecArcMiddle.dotProduct(vecXzone)>0?vecArcMiddle:-vecArcMiddle;
								Vector3d vecYdim = vecZone.crossProduct(vecXdim1);
								String sAngle1;sAngle1.format("%.1f", dAngle1);
								dpDim1.draw(sAngle1, ptArcMiddle, vecXdim1, vecYdim, 0, 0);
								dpDim6.draw(sAngle1, ptArcMiddle, -vecXdim1, vecYdim, 0, 0);
								dpDimIso.draw(sAngle1, ptArcMiddle, _XW, _YW, 0, 0,_kDeviceX);
								dpDim1.color(6);
								dpDim6.color(6);
								dpDimIso.color(6);
							}
							// arc right
							{ 
								Vector3d vec1=pt1Top-pt2Bottom;
								vec1.normalize();
								Point3d ptArc1 = pt2Bottom + vec1 * U(200);
								Point3d ptArc2 = pt2Bottom + -vecDir * U(200);
								Vector3d vecArcMiddle = vec1 + -vecDir;
								vecArcMiddle.normalize();
								Point3d ptArcMiddle = pt2Bottom + vecArcMiddle * U(200);
								PLine plArc(-vecZ);
								plArc.addVertex(ptArc1);
	//							plArc.addVertex(ptArc2,ptArcMiddle);
//								plArc.addVertex(ptArcMiddle,ptArc2);
//								plArc.addVertex(ptArc2,ptArcMiddle);
								plArc.addVertex(ptArc2,U(200), -iClock,true);
								
								if(dAngle2<dAngleMin || dAngle2>dAngleMax)
								{ 
									dpDim1.color(1);
									dpDim6.color(1);
									dpDimIso.color(1);
								}
								else
								{ 
									dpDim1.color(3);
									dpDim6.color(3);
									dpDimIso.color(3);
								}
								dpDim1.draw(plArc);
								dpDim6.draw(plArc);
								dpDimIso.draw(plArc);
								Vector3d vecXdim1 = vecArcMiddle.dotProduct(vecXzone)>0?vecArcMiddle:-vecArcMiddle;
								Vector3d vecYdim = vecZone.crossProduct(vecXdim1);
								String sAngle2;sAngle2.format("%.1f", dAngle2);
								dpDim1.draw(sAngle2, ptArcMiddle, vecXdim1, vecYdim, 0, 0);
								dpDim6.draw(sAngle2, ptArcMiddle, -vecXdim1, vecYdim, 0, 0);
								dpDimIso.draw(sAngle2, ptArcMiddle, _XW, _YW, 0, 0,_kDeviceX);
								dpDim1.color(6);
								dpDim6.color(6);
								dpDimIso.color(6);
							}
							
							// DimLine requires a dimstyle
							Vector3d vecXdimHor1 = vecXzone;
							
//							DimLine dl(pt1Bottom - vecY * U(100), vecXdimHor1, vecYdim);
//							Dim dim(dl, pt1Bottom, pt2MinBottom );
//							dpDim1.draw(dim);
							
							// 
							LineSeg seg(pt1Bottom-vecDir*U(50)-vecY*U(450), 
								pt2Bottom + vecDir * U(50) - vecY * U(450));
							LineSeg seg1(pt1Bottom-vecY*U(450+50), 
								pt1Bottom - vecY * U(450-50));
							LineSeg seg2(pt2Bottom-vecY*U(450+50), 
								pt2Bottom - vecY * U(450-50));
							if(dLength2<dLMin || dLength2>dLMax)
							{ 
								dpDim1.color(1);
								dpDim6.color(1);
								dpDimIso.color(1);
							}
							else
							{ 
								dpDim1.color(3);
								dpDim6.color(3);
								dpDimIso.color(3);
							}
							dpDim1.draw(seg);							
							dpDim6.draw(seg);							
							dpDimIso.draw(seg);							
							dpDim1.draw(seg1);
							dpDim6.draw(seg1);
							dpDimIso.draw(seg1);
							dpDim1.draw(seg2);
							dpDim6.draw(seg2);
							dpDimIso.draw(seg2);
							String sLength2;sLength2.format("%.1f", dLength2);
							dpDim1.draw(sLength2, seg.ptMid(), vecXdimHor1, vecY, 0, 1.2);
							dpDim6.draw(sLength2, seg.ptMid(), -vecXdimHor1, vecY, 0, 1.2);
							dpDimIso.draw(sLength2, seg.ptMid(), _XW, _YW, 0, 1.2,_kDeviceX);
							dpDim1.color(6);
							dpDim6.color(6);
							dpDimIso.color(6);
						}
					}
				}
			}
		}
		else if(iType==1)
		{ 
			if(mapModel.hasDouble("Width"))
				dWidthSheet=mapModel.getDouble("Width");
			if(mapModel.hasDouble("Height"))
				dHeightSheet=mapModel.getDouble("Height");
			if(mapModel.hasDouble("Thickness"))
				dThicknessSheet=mapModel.getDouble("Thickness");
			PlaneProfile ppSheet = _Map.getPlaneProfile("sheet");
			
			// sheet is selected
			if(pts.length()==0)
			{
				// first point to be selected
				dpjig.textHeight(U(200));
//				dpjig.draw(ppSheet, _kDrawFilled);
				for (int iDir = 0; iDir < 2; iDir++)
				{
					int iFlagDir = 1;
					if (iDir == 1)iFlagDir = -1;
					int iBracingFound = false;
					{ 
						// bracing at studs
					// first and second point, bottom and top
						Point3d pt1Bottom, pt1Top, pt2Bottom, pt2Top;
						Point3d pt1=ptJig;
						// 2. point for direction
						Point3d pt2=pt1+iFlagDir*vecX*U(100);
						// 
						Vector3d vecDir=vecX*vecX.dotProduct(pt2-pt1);
						vecDir.normalize();
						Beam beams[]=el.beam();
						
//						Beam bmStuds[]=vecX.filterBeamsPerpendicularSort(beams);
						Beam bmStuds[]=vecDir.filterBeamsPerpendicularSort(beams);
//						Beam bmHors[]=vecY.filterBeamsPerpendicular(beams);
						Beam bmHors[0];
						for (int ibm=0;ibm<beams.length();ibm++) 
						{ 
							if(bmStuds.find(beams[ibm])<0)
								bmHors.append(beams[ibm]);
						}//next ibm
						// first diagonal
						Beam bmTop1,bmBottom1;
						// second diagonal
						Beam bmTop2,bmBottom2;
						Beam bmStud1, bmStud2;
						bmStud1=bmStuds[bmStuds.length()-1];
						double dDistMin=U(10e5);
						for (int ib=0;ib<bmStuds.length();ib++) 
						{ 
							double dDistI=abs(vecX.dotProduct(pt1-bmStuds[ib].ptCen()));
							if(dDistI<dDistMin)
							{ 
								bmStud1=bmStuds[ib];
								dDistMin=dDistI;
							}
						}//next ib
						
						Point3d ptLook=bmStud1.ptCen();
						if(bmStuds.find(bmStud1)==0 && !iStudTie)
						{ 
							ptLook-=vecDir*.5*bmStud1.dD(vecDir);
						}
						Beam bmStud12;
						if(iStudTie==1)
						{ 
							dDistMin=U(10e5);
							for (int ib=0;ib<bmStuds.length();ib++) 
							{ 
								if(bmStuds[ib]==bmStud1)continue;
								double dDistI=abs(vecX.dotProduct(pt1-bmStuds[ib].ptCen()));
								if(dDistI<dDistMin)
								{ 
									bmStud12=bmStuds[ib];
									dDistMin=dDistI;
								}
							}//next ib
							ptLook=.5*(bmStud1.ptCen()+bmStud12.ptCen());
						}
//						dpjig.draw(bmStud1.envelopeBody());
						Beam beamsTop[]=Beam().filterBeamsHalfLineIntersectSort(bmHors, ptLook, vecY);
						bmTop1=beamsTop[beamsTop.length()-1];
						Beam beamsBottom[]=Beam().filterBeamsHalfLineIntersectSort(bmHors, ptLook, -vecY);
						bmBottom1=beamsBottom[beamsBottom.length()-1];
						pt1+=vecX*vecX.dotProduct(ptLook-pt1);
						int iIntersect=Line(ptLook,vecY)
							.hasIntersection(Plane(bmBottom1.ptCen()-bmBottom1.vecD(vecY)*.5*bmBottom1.dD(vecY),bmBottom1.vecD(vecY)),pt1Bottom);
						iIntersect=Line(ptLook,vecY)
							.hasIntersection(Plane(bmTop1.ptCen()+bmTop1.vecD(vecY)*.5*bmTop1.dD(vecY),bmTop1.vecD(vecY)),pt1Top);
						Beam bmStudsDir[] = vecDir.filterBeamsPerpendicularSort(bmStuds);
						
						for (int ibm=bmStudsDir.length()-1; ibm>=0 ; ibm--) 
						{ 
							Beam bmI=bmStudsDir[ibm];
							Beam bmI2;
							Beam bmTopI,bmBottomI;
							double dDistI;
							Point3d ptLook = bmI.ptCen();
							if(iStudTie==1)
							{ 
								if (ibm == 0)break;
								ptLook =.5 *(bmStudsDir[ibm-1].ptCen()+bmI.ptCen());
								bmI2=bmStudsDir[ibm-1];
							}

							dDistI= abs(vecX.dotProduct(ptLook-pt1));
							if(dDistI>dLMax)
							{
								continue;
							}

							else
							{ 
								// check the angle
								Beam bmTopI,bmBottomI;
								Beam beamsTopI[]=Beam().filterBeamsHalfLineIntersectSort(bmHors,ptLook,vecY);
								if(beamsTopI.length()==0)
								{ 
									continue;
								}
								bmTopI=beamsTopI[beamsTopI.length()-1];
								Beam beamsBottomI[]=Beam().filterBeamsHalfLineIntersectSort(bmHors,ptLook,-vecY);
								if(beamsBottomI.length()==0)
								{ 
									continue;
								}
								bmBottomI=beamsBottomI[beamsBottomI.length()-1];
								//
								int iIntersect=Line(ptLook,vecY).hasIntersection(Plane(bmBottomI.ptCen()-bmBottomI.vecD(vecY)*.5*bmBottomI.dD(vecY),bmBottomI.vecD(vecY)),pt2Bottom);
								if(!iIntersect)
								{ 
									continue;
								}
								iIntersect=Line(ptLook,vecY).hasIntersection(Plane(bmTopI.ptCen()+bmTopI.vecD(vecY)*.5*bmTopI.dD(vecY),bmTopI.vecD(vecY)),pt2Top);
								if(!iIntersect)
								{ 
									continue;
								}
	//							_PtG[1] = pt2Bottom;
								pt2Bottom.vis(6);
								pt2Top.vis(6);
								// check the angle 
								Vector3d vec1=pt2Top-pt1Bottom;
								Vector3d vecXangle = vecX;
								vec1.normalize();
								if(vec1.dotProduct(vecXangle)<0)vecXangle*=-1;
								Vector3d vecRef = vec1.crossProduct(vecXangle);
								vecRef.normalize();
//								vec1.vis(pt1Bottom);
//								vecXangle.vis(pt1Bottom);
//								vecRef.vis(pt1Bottom);
//								double dAngle1=vec1.angleTo(vecXangle,vecRef);
								double dAngle1=vec1.angleTo(vecXangle);
								if (dAngle1 > U(90))dAngle1 -= U(90);
								if(dAngle1>dAngleMax)
								{ 
									// not possible
	//								reportMessage("\n"+scriptName()+" "+T("|bracing not possible|"));
	//								eraseInstance();
	//								return;
									
//									dpError.draw("Not possible", ptJig, vecX, vecY, 0, 0, _kDeviceX);
									break;
								}
								else if(dAngle1<dAngleMin)
								{ 
									continue;
								}
								Vector3d vec2=pt1Top-pt2Bottom;
								vec2.normalize();
								if(vec2.dotProduct(vecXangle)<0)vecXangle*=-1;
								vecRef = vec2.crossProduct(vecXangle);
								vecRef.normalize();
//								double dAngle2=vec2.angleTo(vecXangle,vecRef);
								double dAngle2=vec2.angleTo(vecXangle);
								if (dAngle2 > U(90))dAngle2 -= U(90);
								
								if(dAngle1>dAngleMax)
								{ 
									// not possible
	//								reportMessage("\n"+scriptName()+" "+T("|bracing not possible|"));
	//								eraseInstance();
	//								return;
								}
								
								else if(dAngle1<dAngleMin)
								{ 
									continue;
								}
								
								bmTop2 = bmTopI;
								bmBottom2 = bmBottomI;
								// valid connection
								iBracingFound=true;
								break;
							}
						}//next ibm
						if(!iBracingFound)
						{ 
	//						reportMessage("\n"+scriptName()+" "+T("|Bracing not possible|"));
	//						eraseInstance();
							if(iDir==0)
							{ 
								// check next direction
								continue;
							}
							else
							{ 
								dpError.draw("Bracing not possible", ptJig, vecX, vecY, 0, 0, _kDeviceX);
								return;
							}
						}
						
						
						PLine plSheetCreate;
						plSheetCreate.createRectangle(LineSeg(pt1Bottom,pt2Top),vecDir,vecY);
						PlaneProfile ppSheetCreate(ppSheet.coordSys());
						ppSheetCreate.joinRing(plSheetCreate,_kAdd);
						dpjig.draw(ppSheetCreate, _kDrawFilled);
						dpjig.color(7);
						dpjig.draw(ppSheetCreate);
						dpjig.draw(plSheetCreate);
						dpjig.color(3);
					}
					if(iBracingFound)
						break;
				}//next iDir
			}
			else if(pts.length()>0)
			{ 
				
				// second point for the sheeting
				{ 
					Entity entStud1 = _Map.getEntity("Stud1");
					Beam bmStud1 = (Beam)entStud1;
					dpjig.textHeight(U(200));
					
					Beam bmStud12;
					Point3d ptLook = bmStud1.ptCen();
					if(iStudTie==1)
					{ 
						Entity entStud12=_Map.getEntity("Stud12");
						bmStud12=(Beam)entStud12;
						ptLook=.5*(bmStud1.ptCen()+bmStud12.ptCen());
					}
					// first and second point, bottom and top
					Point3d pt1Bottom, pt1Top, pt2Bottom, pt2Top;
					// no stud tie, bracing is placed at studs
					// get the closest stud
					Point3d pt1 = pts[0];
					
					Point3d pt2 = ptJig;
					Vector3d vecDir = vecX * vecX.dotProduct(pt2 - pt1);
					vecDir.normalize();
					Beam beams[] = el.beam();
					Beam bmStuds[] = vecDir.filterBeamsPerpendicularSort(beams);
					if(bmStuds.find(bmStud1)==0 && !iStudTie)
					{ 
						ptLook-=vecDir*.5*bmStud1.dD(vecDir);
					}
					Beam bmHors[] = vecY.filterBeamsPerpendicular(beams);
					
					// get the most bottom point of ppSheet
					Point3d ptBottomMax, ptTopMax;
					{ 
						// get extents of profile
						LineSeg seg = ppSheet.extentInDir(vecX);
						ptBottomMax = vecY.dotProduct(seg.ptStart()-seg.ptEnd())<0?seg.ptStart():seg.ptEnd();
						ptTopMax = vecY.dotProduct(seg.ptStart()-seg.ptEnd())>0?seg.ptStart():seg.ptEnd();
					}
//					pt1Bottom=Line(bmStud1.ptCen(),vecY).intersect(Plane(ptBottomMax,vecY),U(0));
					pt1Bottom=Line(ptLook,vecY).intersect(Plane(ptBottomMax,vecY),U(0));
					
					PLine plRec12;
					plRec12.createRectangle(LineSeg(pt1,pt2),vecX,vecY);
					PlaneProfile ppRec12(ppSheet.coordSys());
					ppRec12.joinRing(plRec12, _kAdd);
					int iCreate;
					if (ppRec12.intersectWith(ppSheet))iCreate = true;
					if (iCreate)
					{
						// draw sheets
						Point3d ptStartCol = pt1Bottom, ptStartRow = pt1Bottom;
						PlaneProfile ppSheetsCreated[0];
						int iFullSheet[0];
						for (int icol = 0; icol < 200; icol++)
						{
							//						if(vecDir.dotProduct(ptJig-ptStartCol)<dWidthSheet)
							if (vecDir.dotProduct(ptJig - ptStartCol) < 0)
							{
								// break colums
								break;
							}
							// add sheets
							for (int irow = 0; irow < 200; irow++)
							{
								//							if(vecY.dotProduct(ptJig-ptStartRow)<dHeightSheet)
								if (vecY.dotProduct(ptJig - ptStartRow) < 0)
								{
									ptStartRow = pt1Bottom;
									ptStartCol += vecDir * dWidthSheet;
									//								continue;
									//								break;
								}
								//							if(vecDir.dotProduct(ptJig-ptStartCol)<dWidthSheet)
								if (vecDir.dotProduct(ptJig - ptStartCol) < 0)
								{
									// break colums
									break;
								}
								// add sheet
								PlaneProfile ppSheetNew(ppSheet.coordSys());
								PLine plSheetNew;
								Point3d ptI = ptStartRow;
								ptI += vecX * vecX.dotProduct(ptStartCol - ptI);
								
								plSheetNew.createRectangle(LineSeg(ptI,
								ptI + vecDir * dWidthSheet + vecY * dHeightSheet), vecDir, vecY);
								ppSheetNew.joinRing(plSheetNew, _kAdd);
								//							dpjig.draw("V", ptI, vecX, vecY, 0, 0, _kDeviceX);
								//							dpjig.draw(ppSheetNew,_kDrawFilled);
								// get intersection with ppSheet
								PlaneProfile ppSheetIntersect = ppSheetNew;
								ppSheetIntersect.intersectWith(ppSheet);
								PlaneProfile ppSubtract = ppSheetNew;
								ppSubtract.subtractProfile(ppSheet);
								
								if (ppSubtract.area() < pow(dEps, 2) && ppSheetIntersect.area() > pow(dEps, 2))
								{
									// intersects but not all inside
									ptStartRow += vecY * dHeightSheet;
									ppSheetsCreated.append(ppSheetIntersect);
									iFullSheet.append(true);
								}
								else if (ppSubtract.area() > pow(dEps, 2) && ppSheetIntersect.area() > pow(dEps, 2))
								{
									ppSheetsCreated.append(ppSheetIntersect);
									iFullSheet.append(false);
									ptStartRow += vecY * dHeightSheet;
									
									//								PlaneProfile ppTop(ppSheet.coordSys());
									//								PLine plTop;
									//								plTop.createRectangle(LineSeg(ptI + vecY * dHeightSheet, ptI + vecY * (dHeightSheet + U(50)) + vecDir * dWidthSheet),vecDir,vecY);
									//								ppTop.joinRing(plTop,_kAdd);
									//								ppTop.vis(4);
									//								PlaneProfile ppRight(ppSheet.coordSys());
									//								PLine plRight;
									//								plRight.createRectangle(LineSeg(ptI+vecDir*dWidthSheet, ptI+vecY*dHeightSheet+vecDir*(dWidthSheet+U(50))),vecDir,vecY);
									//								ppRight.joinRing(plRight,_kAdd);
									//								ppRight.vis(4);
									//
									//								if(ppTop.intersectWith(ppSheet))
									//								{
									//									ptStartRow+=vecY*dHeightSheet;
									//									ppSheetsCreated.append(ppSheetIntersect);
									//									ppSheetIntersect.vis(6);
									//
									//									iFullSheet.append(false);
									//								}
									//								else if(ppRight.intersectWith(ppSheet))
									//								{
									//									ptStartRow = pt1Bottom;
									//									ptStartCol += vecDir * dWidthSheet;
									//									ppSheetsCreated.append(ppSheetIntersect);
									//									iFullSheet.append(false);
									//								}
								}
								else if (ppSheetIntersect.area() < pow(dEps, 2))
								{
									ptStartRow = pt1Bottom;
									ptStartCol += vecDir * dWidthSheet;
									//								break;
								}
								else
								{
									// no intersection, increment col
									ptStartRow = pt1Bottom;
									ptStartCol += vecDir * dWidthSheet;
								}
							}//next irow
						}//next icol
						//					dpjig.draw(ppSheetsCreated.length(), ptJig, vecX, vecY, 0, 0, _kDeviceX);
						for (int ip = 0; ip < ppSheetsCreated.length(); ip++)
						{
							if (iFullSheet[ip])
							{
								dpjig.transparency(50);
								dpjig.draw(ppSheetsCreated[ip], _kDrawFilled);
								
								dpjig.transparency(0);
								dpjig.color(7);
								dpjig.draw(ppSheetsCreated[ip]);
								dpjig.color(3);
							}
							else
							{
								dpjigWarning.transparency(50);
								dpjigWarning.draw(ppSheetsCreated[ip], _kDrawFilled);
								
								dpjigWarning.transparency(0);
								dpjigWarning.color(7);
								dpjigWarning.draw(ppSheetsCreated[ip]);
								dpjigWarning.color(40);
							}
							
						}//next ip
					}
				}
			}
		}
		
		return;
	}
//End jig//endregion 
	
//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		String sTokens[] = _kExecuteKey.tokenize("?");
//		reportMessage("\n"+scriptName()+" "+T("|sTokens[0]|")+T(sTokens[0]));
//		reportMessage("\n"+scriptName()+" "+T("|sTypes[0]|")+sTypes[1]);
		
		// HSB-8922: load properties from catalogue if a catalogue is choosen
		// if executepaletkey is a catalogue then load properties from this catalogue
		// catalogue should not be a familyname
		if (sTokens.length()==1 && _kExecuteKey.length()>0 
			&& T(sTokens[0])!=sTypes[0] && T(sTokens[0])!=sTypes[1])
		{ 
//			reportNotice("\n _kExecuteKey " +_kExecuteKey);
			String files[] =  getFilesInFolder(_kPathHsbCompany+"\\tsl\\catalog\\", scriptName()+"*.xml");
			for (int i=0;i<files.length();i++) 
			{ 
				String entry = files[i].left(files[i].length() - 4);
//				reportNotice("\n files " + entry);
				String sEntries[] = TslInst().getListOfCatalogNames(entry);
				
//				reportNotice("\n using sEntries " + sEntries);
				if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				{ 
					Map map = _ThisInst.mapWithPropValuesFromCatalog(entry, _kExecuteKey);
					setPropValuesFromMap(map);
					
//					reportNotice("\n using map " + map);
					break;
				}
			}//next i
		}
		else
		{
			sStudTie.setReadOnly(_kHidden);
			sManufacturer.setReadOnly(_kHidden);
			sFamily.setReadOnly(_kHidden);
			sModel.setReadOnly(_kHidden);
			// get opm key from the _kExecuteKey
			String sOpmKey;
			if (sTokens.length() > 0)
			{
				sOpmKey = sTokens[0];
			}
			else
			{
				sOpmKey = "";
			}
			// get the family from the _kExecuteKey or from the dialog box
			// validate the opmkeys, should be one of the families supported
			if (sOpmKey.length() > 0)
			{
				String s1 = sOpmKey;
				//				s1.makeUpper();
				int bOk;
				int iType = sTypes.find(T(s1));
				if (iType >- 1)
				{
					sType.set(sTypes[iType]);
					sType.setReadOnly(true);
					bOk = true;
				}
				if ( ! bOk)
				{
					reportNotice("\n" + scriptName() + ": " + T("|NOTE, the specified OPM key| '") +sOpmKey+T("' |cannot be found in the list of Types.|"));
					sOpmKey = "";
				}
			}
			else
			{
				// sOpmKey not specified, show the dialog
				sType.setReadOnly(false);
				sManufacturer.set("---");
				sManufacturer.setReadOnly(_kReadOnly);
				sFamily.set("---");
				sFamily.setReadOnly(true);
				sModel.set("---");
				sModel.setReadOnly(true);
				showDialog("---");
				sOpmKey = sType;
			}
			int iType = sTypes.find(sType);
			Map mapType;
			if (iType == 0)
			{
				mapType = mapSetting.getMap("Bracing");
				sStudTie.setReadOnly(false);
			}
			else if (iType == 1)
			{
				mapType = mapSetting.getMap("Sheeting");
				sStudTie.setReadOnly(_kReadOnly);
			}
			
			Map mapManufacturers = mapType.getMap("Manufacturer[]");
			if (mapManufacturers.length() < 1)
			{
				// wrong definition of the map
				reportMessage("\n"+scriptName()+" "+T("|no manufacturer definition for this type|"));
				eraseInstance();
				return;
			}
			for (int j = 0; j < mapManufacturers.length(); j++)
			{
				Map mapManufacturerJ = mapManufacturers.getMap(j);
				if (mapManufacturerJ.hasString("Name") && mapManufacturers.keyAt(j).makeLower() == "manufacturer")
				{
					String sName = mapManufacturerJ.getString("Name");
					if (sFamilies.find(sName) < 0)
					{
						// populate sFamilies
						sManufacturers.append(sName);
						if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
					}
				}
			}
			
			// set the manufacturer
			if (sTokens.length() < 2)//manufacturer not defined in opmkey, showdialog
			{
				sType.setReadOnly(true);
				sManufacturer.setReadOnly(false);
				sManufacturer = PropString(3, sManufacturers, sManufacturerName, 0);
				sManufacturer.set(sManufacturers[0]);
				sFamily = PropString(4, sFamilies, sFamilyName, 0);
				sFamily.set("---");
				sFamily.setReadOnly(true);
				sModel = PropString(5, sModels, sModelName, 0);
				sModel.set("---");
				sModel.setReadOnly(true);
				showDialog("---");
			}
			else
			{
				int indexSTokens = sManufacturers.find(sTokens[1]);
				sManufacturer = PropString(3, sManufacturers, sManufacturerName, 0);
				if (indexSTokens >- 1)
				{
					// find
					sManufacturer.set(sTokens[1]);
					if (bDebug)reportMessage("\n" + scriptName() + " from tokens ");
				}
				else
				{
					// wrong definition in the opmKey, accept the first model from the xml
					reportMessage("\n"+scriptName()+" "+T("|wrong definition of the OPM key|"));
					sManufacturer.set(sManufacturers[0]);
				}
			}
			
			// for the chosen manufacturer get families and models. first find the map of selected manufacturer
			for (int j = 0; j < mapManufacturers.length(); j++)
			{
				Map mapManufacturerJ = mapManufacturers.getMap(j);
				if (mapManufacturerJ.hasString("Name") && mapManufacturers.keyAt(j).makeLower() == "manufacturer")
				{
					String sManufacturerName = mapManufacturerJ.getString("Name");
					if (sManufacturerName.makeUpper() != sManufacturer.makeUpper())
					{
						// not this manufacturer, keep looking
						continue;
					}
				}
				else
				{
					// not a manufacturer map
					continue;
				}
				
				// mapManufacturerJ is found, populate families and nails
				// map of the selected manufacturer is found
				// get its families
				Map mapFamilies = mapManufacturerJ.getMap("Family[]");
				if (mapFamilies.length() < 1)
				{
					// wrong definition of the map
					reportMessage("\n"+scriptName()+" "+T("|no family definition for this manufacturer|"));
					eraseInstance();
					return;
				}
				for (int k = 0; k < mapFamilies.length(); k++)
				{
					Map mapFamilyK = mapFamilies.getMap(k);
					if (mapFamilyK.hasString("Name") && mapFamilies.keyAt(k).makeLower() == "family")
					{
						String sName = mapFamilyK.getString("Name");
						if (sFamilies.find(sName) < 0)
						{
							// populate sFamilies
							sFamilies.append(sName);
							if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
						}
					}
				}
				
				// set the family
				if (sTokens.length() < 3)
				{ 
					// family not set in opm key, show the dialog to get the opm key
					// set array of sfamilies and get the first by default
					// family is set, set as readOnly
					sManufacturer.setReadOnly(true);
					sFamily.setReadOnly(false);
					sFamily = PropString(4, sFamilies, sFamilyName, 0);
					sFamily.set(sFamilies[0]);
					sModel = PropString(5, sModels, sModelName, 0);
					sModel.set("---");
					sModel.setReadOnly(true);

					showDialog("---");
//						showDialog();
					if(bDebug)reportMessage("\n"+ scriptName() + " from dialog ");
					if(bDebug)reportMessage("\n"+ scriptName() + " sFamily "+sFamily);
				}
				else
				{ 
					int indexSTokens = sFamilies.find(sTokens[2]);
					if (indexSTokens >- 1)
					{ 
						// find
						sFamily.set(sTokens[2]);
						if(bDebug)reportMessage("\n"+ scriptName() + " from tokens ");
					}
					else
					{ 
						// wrong definition in the opmKey, accept the first family from the xml
						reportMessage("\n"+scriptName()+" "+T("|wrong definition of the OPM key|"));
						sFamily.set(sFamilies[0]);
					}
				}
				// for the chosen family get models. first find the map of selected family
				for (int j = 0; j < mapFamilies.length(); j++)
				{
					Map mapFamilyJ = mapFamilies.getMap(j);
					if (mapFamilyJ.hasString("Name") && mapFamilies.keyAt(j).makeLower() == "family")
					{
						String sFamilyName = mapFamilyJ.getString("Name");
						if (sFamilyName.makeUpper() != sFamily.makeUpper())
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
					
					// mapFamilyJ is found, populate models and nails
					// map of the selected family is found
					// get its models
					Map mapModels = mapFamilyJ.getMap("Product[]");
					if (mapModels.length() < 1)
					{
						// wrong definition of the map
						reportMessage("\n"+scriptName()+" "+T("|no product definition for this family|"));
						eraseInstance();
						return;
					}
					
					for (int k = 0; k < mapModels.length(); k++)
					{
						Map mapModelK = mapModels.getMap(k);
						if (mapModelK.hasString("Name") && mapModels.keyAt(k).makeLower() == "product")
						{
							String sName = mapModelK.getString("Name");
							if (sModels.find(sName) < 0)
							{
								// populate sModels
								sModels.append(sName);
								if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
							}
						}
					}
					
					// set the model
					if (sTokens.length() < 4)
					{ 
						// model not set in opm key, show the dialog to get the opm key
						// set array of smodels and get the first by default
						// family is set, set as readOnly
						sManufacturer.setReadOnly(true);
						sFamily.setReadOnly(true);
						sModel.setReadOnly(false);
						sModel = PropString(5, sModels, sModelName, 0);
						sModel.set(sModels[0]);
						showDialog("---");
//						showDialog();
						if(bDebug)reportMessage("\n"+ scriptName() + " from dialog ");
						if(bDebug)reportMessage("\n"+ scriptName() + " sModel "+sModel);
					}
					else
					{ 
						// see if sTokens[1] is a valid model name as in sModels from mapSetting
						int indexSTokens = sModels.find(sTokens[3]);
						if (indexSTokens >- 1)
						{ 
							// find
							sModel.set(sTokens[3]);
							if(bDebug)reportMessage("\n"+ scriptName() + " from tokens ");
						}
						else
						{ 
							// wrong definition in the opmKey, accept the first model from the xml
							reportMessage("\n"+scriptName()+" "+T("|wrong definition of the OPM key|"));
							sModel.set(sModels[0]);
						}
					}
					// models are set
					break;
				}
				// family is set
				break;
			}
		}
		
	// silent/dialog
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
		
		
		Element el = getElement(T("|Select wall|"));
		if(el.bIsValid())
			_Element.append(el);
		else
		{
			eraseInstance();
			return;
		}
		
		// basic information
		Point3d ptOrg=el.ptOrg();
		Vector3d vecX=el.vecX();
		Vector3d vecY=el.vecY();
		Vector3d vecZ=el.vecZ();
		ElemZone eZone0=el.zone(0);
		Plane pn(eZone0.ptOrg()+eZone0.vecZ()*.5*eZone0.dH(),eZone0.vecZ());
		// get point
		int iType = sTypes.find(sType);
		Map mapModel;
		// get mapModel
		{ 
			Map mapType;
			if (iType == 0)
			{
				mapType = mapSetting.getMap("Bracing");
				sStudTie.setReadOnly(false);
			}
			else if (iType == 1)
			{
				mapType = mapSetting.getMap("Sheeting");
				sStudTie.setReadOnly(_kReadOnly);
			}
			Map mapManufacturers = mapType.getMap("Manufacturer[]");
			Map mapManufacturer;
			for (int i = 0; i < mapManufacturers.length(); i++)
			{ 
				Map mapManufacturerI = mapManufacturers.getMap(i);
				if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
				{
					String sManufacturerName = mapManufacturerI.getString("Name");
					
					if (sManufacturerName.makeUpper() != sManufacturer.makeUpper())
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
			Map mapFamilies = mapManufacturer.getMap("Family[]");
			Map mapFamily;
			for (int i = 0; i < mapFamilies.length(); i++)
			{ 
				Map mapFamilyI = mapFamilies.getMap(i);
				if (mapFamilyI.hasString("Name") && mapFamilies.keyAt(i).makeLower() == "family")
				{
					String sFamilyName = mapFamilyI.getString("Name");
					
					if (sFamilyName.makeUpper() != sFamily.makeUpper())
					{
						continue;
					}
				}
				else
				{ 
					// not a family map
					continue;
				}
				
				mapFamily = mapFamilies.getMap(i);
				break;
			}
			Map mapModels = mapFamily.getMap("Product[]");
//			Map mapModel;
			for (int i = 0; i < mapModels.length(); i++)
			{ 
				Map mapModelI = mapModels.getMap(i);
				if (mapModelI.hasString("Name") && mapModels.keyAt(i).makeLower() == "product")
				{
					String sModelName = mapModelI.getString("Name");
					
					if (sModelName.makeUpper() != sModel.makeUpper())
					{
						continue;
					}
				}
				else
				{ 
					// not a model map
					continue;
				}
				
				mapModel = mapModels.getMap(i);
				break;
			}
		}
		
		int iStudTie = sNoYes.find(sStudTie);
		int iZone=sZones.find(sZone);
		int nZone = 1;
		if(iType==0)
		{ 
			// cross bracing
			String sStringStart = "|Select first point or|";
			String sStringStart2 = "|Select end point or|";
			String sZoneOption = "Zone -1";
			if(iZone==1)sZoneOption="zOne 1";
			String sStringOption = "["+"Start/"+sZoneOption+"]";
			String sStringOption0 = "["+sZoneOption+"]";
			String sStringPrompt = T(sStringStart)+sStringOption0;
			PrPoint ssP(sStringPrompt);
			ssP.setSnapMode(true, _kOsModeEnd | _kOsModeMid);
			Map mapArgs;
			mapArgs.setEntity("Element",el);
			mapArgs.setInt("Type",iType);
			mapArgs.setInt("StudTie",iStudTie);
			mapArgs.setInt("Zone",iZone);
			// set mapModel
			mapArgs.setMap("Model", mapModel);
			int nGoJig = -1;
			while (nGoJig != _kNone)
			{
				nGoJig = ssP.goJig(strJigAction1, mapArgs);
				if (nGoJig == _kOk)
				{
					Point3d ptLast = ssP.value();
					Vector3d vecView = getViewDirection();
					ptLast = Line(ptLast, vecView).intersect(pn, U(0));
					// add point to the list of points
					Point3d pts[0];
					if (mapArgs.hasPoint3dArray("pts"))
					{
						pts = mapArgs.getPoint3dArray("pts");
					}
					if(pts.length()==1)
					{ 
						// first point already there save second and finish
						nGoJig = _kNone;
						_PtG.setLength(0);
						_PtG.append(pts);
						_PtG.append(ptLast);
					}
					else
					{ 
						// first point is selected, prepare for the 2. prompt
						pts.append(ptLast);
						mapArgs.setPoint3dArray("pts", pts);
						if(pts.length()>=1)
						{ 
							// second point prompt
							int iZone_ = mapArgs.getInt("Zone");
								
							sZoneOption = "Zone -1";
							int _iZone = 0;
							
							if(iZone_==1)
							{ 
								// options
								_iZone = 1;
								sZoneOption = "zOne 1";
							}
							mapArgs.setInt("Zone",_iZone);
	
							sStringOption = "["+"Start/"+sZoneOption+"]";
							sStringPrompt = T(sStringStart2) + sStringOption;
							ssP=PrPoint(sStringPrompt);
							sZone.set(sZones[_iZone]);
						}
						// save the stud
//						if(iStudTie==0)
						{ 
							Beam bmStud1;
							Point3d pt1=ptLast;
							Beam beams[]=el.beam();
							Beam bmStuds[]=vecX.filterBeamsPerpendicularSort(beams);
							bmStud1=bmStuds[bmStuds.length()-1];
							double dDistMin=U(10e5);
							for (int ib=0;ib<bmStuds.length();ib++) 
							{ 
								double dDistI=abs(vecX.dotProduct(pt1-bmStuds[ib].ptCen()));
								if(dDistI<dDistMin)
								{ 
									bmStud1=bmStuds[ib];
									dDistMin=dDistI;
								}
							}//next ib
							mapArgs.setEntity("Stud1", bmStud1);
							if(iStudTie==1)
							{ 
								Beam bmStud12;
								double dDistMin=U(10e5);
								for (int ib=0;ib<bmStuds.length();ib++) 
								{ 
									if (bmStuds[ib] == bmStud1)continue;
									double dDistI=abs(vecX.dotProduct(pt1-bmStuds[ib].ptCen()));
									if(dDistI<dDistMin)
									{ 
										bmStud12=bmStuds[ib];
										dDistMin=dDistI;
									}
								}//next ib
								mapArgs.setEntity("Stud12", bmStud12);
							}
						}
					}
				}
				else if (nGoJig == _kKeyWord)
				{ 
					Point3d pts[0];
					if (mapArgs.hasPoint3dArray("pts"))
					{
						pts = mapArgs.getPoint3dArray("pts");
					}
					if (ssP.keywordIndex() >= 0)
					{
						if (pts.length() == 0)
						{
							if (ssP.keywordIndex() == 0)
							{
								// Start is selected
								Point3d pts[0];
								mapArgs.setPoint3dArray("pts", pts);
								mapArgs.removeAt("Stud1",true);
								mapArgs.removeAt("Stud12",true);
								
								int iZone_ = mapArgs.getInt("Zone");
									
								sZoneOption = "Zone -1";
								int _iZone = 0;
								
								if(iZone_==0)
								{ 
									// options
									_iZone = 1;
									sZoneOption = "zOne 1";
								}
								
								mapArgs.setInt("Zone",_iZone);
								sStringOption0 = "["+sZoneOption+"]";
								sStringPrompt = T(sStringStart) + sStringOption0;
								ssP=PrPoint(sStringPrompt);
								sZone.set(sZones[_iZone]);
							}
						}
						else if(pts.length()>0)
						{ 
							if (ssP.keywordIndex() == 0)
							{
								// Start is selected
								Point3d pts[0];
								mapArgs.setPoint3dArray("pts", pts);
								mapArgs.removeAt("Stud1",true);
								mapArgs.removeAt("Stud12",true);
								
								
								int iZone_ = mapArgs.getInt("Zone");
								
								sZoneOption = "Zone -1";
								int _iZone = 0;
								if(iZone_==1)
								{ 
									// options
									_iZone = 1;
									sZoneOption = "zOne 1";
								}
								mapArgs.setInt("Zone",_iZone);
								sStringOption0 = "["+sZoneOption+"]";
								sStringPrompt = T(sStringStart) + sStringOption0;
								
					 			ssP=PrPoint(sStringPrompt);
							}
							else if(ssP.keywordIndex() == 1)
							{ 
								int iZone_ = mapArgs.getInt("Zone");
								
								sZoneOption = "Zone -1";
								int _iZone = 0;
								if(iZone_==0)
								{ 
									// options
									_iZone = 1;
									sZoneOption = "zOne 1";
								}
								mapArgs.setInt("Zone",_iZone);
	
								sStringOption = "["+"Start/"+sZoneOption+"]";
								sStringPrompt = T(sStringStart2) + sStringOption;
								ssP=PrPoint(sStringPrompt);
								sZone.set(sZones[_iZone]);
							}
						}
					}
				}
				else if (nGoJig == _kCancel)
		        { 
		            eraseInstance(); // do not insert this instance
		            return; 
		        }
		        else if(nGoJig==_kNone)
		        { 
		        	// ToDo: insert the preview
		        	eraseInstance();
		        	return;
		        }
			}
			
//			Point3d pts[0];
//			String sPromptStart = T("|Click start point|");
//			pts.append(getPoint(sPromptStart));
//			String sPromptEnd = T("|Click end point for direction|");
//			PrPoint ssP(sPromptEnd, pts[pts.length()-1]);
//			if(ssP.go()==_kOk)
//			{ 
//				pts.append(ssP.value());
//			}
//			_PtG.append(pts);
		}
		else if(iType==1)
		{ 
			// Sheet
			Point3d pts[0];
//			String sStringStart = "|Select first point|";
			String sStringStart = "|Select first point or|";
			String sStringStart2 = "|Select end point or|";
			String sZoneOption = "Zone -1";
			if(iZone==1)sZoneOption="zOne 1";
//			String sStringOption = "Start]";
			String sStringOption = "["+"Start/"+sZoneOption+"]";
			String sStringOption0 = "["+sZoneOption+"]";
			String sStringPrompt = T(sStringStart)+sStringOption0;
			PrPoint ssP(sStringPrompt);
			ssP.setSnapMode(true, _kOsModeEnd | _kOsModeMid);
			Map mapArgs;
			mapArgs.setEntity("Element",el);
			mapArgs.setInt("Type",iType);
			mapArgs.setInt("Zone",iZone);
			// set mapModel
			mapArgs.setMap("Model", mapModel);
			// get ppsheet
			Point3d ptSheet = ptOrg;
			Vector3d vecZsheet = vecZ;
			Vector3d vecYsheet = vecY;
			Vector3d vecXsheet = vecY.crossProduct(vecZ);
			vecXsheet.normalize();
			if(iZone==1)
			{ 
				nZone = -1;
				ptSheet = ptSheet - el.vecZ() * el.zone(0).dH();
				vecZsheet *= -1;
				vecXsheet *= -1;
			}
			CoordSys csSheet(ptSheet,vecXsheet,vecYsheet,vecZsheet);
			PlaneProfile ppSheet(csSheet);
			ppSheet.joinRing(el.plEnvelope(), _kAdd);
			mapArgs.setPlaneProfile("sheet",ppSheet);
			
			int nGoJig = -1;
			while (nGoJig != _kNone)
			{
				nGoJig = ssP.goJig(strJigAction1, mapArgs);
				if (nGoJig == _kOk)
				{
					Point3d ptLast = ssP.value();
					Vector3d vecView = getViewDirection();
					ptLast = Line(ptLast, vecView).intersect(pn, U(0));
					// add point to the list of points
					Point3d pts[0];
					if (mapArgs.hasPoint3dArray("pts"))
					{
						pts = mapArgs.getPoint3dArray("pts");
					}
					if (pts.length() == 1)
					{
						// first point already there save second and finish
						nGoJig = _kNone;
						_PtG.setLength(0);
						_PtG.append(pts);
						_PtG.append(ptLast);
					}
					else
					{
						// first point is selected, prepare for the 2. prompt
						pts.append(ptLast);
						mapArgs.setPoint3dArray("pts", pts);
						if (pts.length() >= 1)
						{
							// second point prompt
							int iZone_ = mapArgs.getInt("Zone");
								
							sZoneOption = "Zone -1";
							int _iZone = 0;
							Point3d _ptSheet = ptOrg;
							Vector3d _vecZsheet = vecZ;
							Vector3d _vecYsheet = vecY;
							Vector3d _vecXsheet = vecY.crossProduct(vecZ);
							_vecXsheet.normalize();
							if(iZone_==1)
							{ 
								// plane profile
								_ptSheet = _ptSheet - el.vecZ() * el.zone(0).dH();
								_vecZsheet *= -1;
								_vecXsheet *= -1;
								// options
								_iZone = 1;
								sZoneOption = "zOne 1";
							}
							
							CoordSys _csSheet(_ptSheet,_vecXsheet,_vecYsheet,_vecZsheet);
							PlaneProfile _ppSheet(_csSheet);
							_ppSheet.unionWith(ppSheet);
							mapArgs.setPlaneProfile("sheet",_ppSheet);
							mapArgs.setInt("Zone",_iZone);
	
							sStringOption = "["+"Start/"+sZoneOption+"]";
							sStringPrompt = T(sStringStart2) + sStringOption;
							ssP=PrPoint(sStringPrompt);
							sZone.set(sZones[_iZone]);
						}
						// save the stud
						{ 
							Beam bmStud1;
							Point3d pt1=ptLast;
							Beam beams[]=el.beam();
							Beam bmStuds[]=vecX.filterBeamsPerpendicularSort(beams);
							bmStud1=bmStuds[bmStuds.length()-1];
							double dDistMin=U(10e5);
							for (int ib=0;ib<bmStuds.length();ib++) 
							{ 
								double dDistI=abs(vecX.dotProduct(pt1-bmStuds[ib].ptCen()));
								if(dDistI<dDistMin)
								{ 
									bmStud1=bmStuds[ib];
									dDistMin=dDistI;
								}
							}//next ib
							mapArgs.setEntity("Stud1", bmStud1);
							if(iStudTie==1)
							{ 
								Beam bmStud12;
								double dDistMin=U(10e5);
								for (int ib=0;ib<bmStuds.length();ib++) 
								{ 
									if (bmStuds[ib] == bmStud1)continue;
									double dDistI=abs(vecX.dotProduct(pt1-bmStuds[ib].ptCen()));
									if(dDistI<dDistMin)
									{ 
										bmStud12=bmStuds[ib];
										dDistMin=dDistI;
									}
								}//next ib
								mapArgs.setEntity("Stud12", bmStud12);
							}
						}
					}
				}
				else if (nGoJig == _kKeyWord)
				{ 
					Point3d pts[0];
					if (mapArgs.hasPoint3dArray("pts"))
					{
						pts = mapArgs.getPoint3dArray("pts");
					}
					if (ssP.keywordIndex() >= 0)
					{
						if(pts.length()==0)
						{ 
							if (ssP.keywordIndex() == 0)
							{ 
								int iZone_ = mapArgs.getInt("Zone");
								
								sZoneOption = "Zone -1";
								int _iZone = 0;
								Point3d _ptSheet = ptOrg;
								Vector3d _vecZsheet = vecZ;
								Vector3d _vecYsheet = vecY;
								Vector3d _vecXsheet = vecY.crossProduct(vecZ);
								_vecXsheet.normalize();
								
								if(iZone_==0)
								{ 
									// plane profile
									_ptSheet = _ptSheet - el.vecZ() * el.zone(0).dH();
									_vecZsheet *= -1;
									_vecXsheet *= -1;
									// options
									_iZone = 1;
									sZoneOption = "zOne 1";
								}
								
								CoordSys _csSheet(_ptSheet,_vecXsheet,_vecYsheet,_vecZsheet);
								PlaneProfile _ppSheet(_csSheet);
								_ppSheet.unionWith(ppSheet);
								mapArgs.setPlaneProfile("sheet",_ppSheet);
								mapArgs.setInt("Zone",_iZone);
								sStringOption0 = "["+sZoneOption+"]";
								sStringPrompt = T(sStringStart) + sStringOption0;
								ssP=PrPoint(sStringPrompt);
								sZone.set(sZones[_iZone]);
							}
						}
						else if(pts.length()>0)
						{ 
							if (ssP.keywordIndex() == 0)
							{
								// Start is selected
								Point3d pts[0];
								mapArgs.setPoint3dArray("pts", pts);
								mapArgs.removeAt("Stud1",true);
								mapArgs.removeAt("Stud12",true);
								
								
								int iZone_ = mapArgs.getInt("Zone");
								
								sZoneOption = "Zone -1";
								int _iZone = 0;
								Point3d _ptSheet = ptOrg;
								Vector3d _vecZsheet = vecZ;
								Vector3d _vecYsheet = vecY;
								Vector3d _vecXsheet = vecY.crossProduct(vecZ);
								_vecXsheet.normalize();
								
								if(iZone_==1)
								{ 
									// plane profile
									_ptSheet = _ptSheet - el.vecZ() * el.zone(0).dH();
									_vecZsheet *= -1;
									_vecXsheet *= -1;
									// options
									_iZone = 1;
									sZoneOption = "zOne 1";
								}
								
								CoordSys _csSheet(_ptSheet,_vecXsheet,_vecYsheet,_vecZsheet);
								PlaneProfile _ppSheet(_csSheet);
								_ppSheet.unionWith(ppSheet);
								mapArgs.setPlaneProfile("sheet",_ppSheet);
								mapArgs.setInt("Zone",_iZone);
								sStringOption0 = "["+sZoneOption+"]";
								sStringPrompt = T(sStringStart) + sStringOption0;
								
					 			ssP=PrPoint(sStringPrompt);
							}
							else if(ssP.keywordIndex() == 1)
							{ 
								int iZone_ = mapArgs.getInt("Zone");
								
								sZoneOption = "Zone -1";
								int _iZone = 0;
								Point3d _ptSheet = ptOrg;
								Vector3d _vecZsheet = vecZ;
								Vector3d _vecYsheet = vecY;
								Vector3d _vecXsheet = vecY.crossProduct(vecZ);
								_vecXsheet.normalize();
								if(iZone_==0)
								{ 
									// plane profile
									_ptSheet = _ptSheet - el.vecZ() * el.zone(0).dH();
									_vecZsheet *= -1;
									_vecXsheet *= -1;
									// options
									_iZone = 1;
									sZoneOption = "zOne 1";
								}
								
								CoordSys _csSheet(_ptSheet,_vecXsheet,_vecYsheet,_vecZsheet);
								PlaneProfile _ppSheet(_csSheet);
								_ppSheet.unionWith(ppSheet);
								mapArgs.setPlaneProfile("sheet",_ppSheet);
								mapArgs.setInt("Zone",_iZone);
	
								sStringOption = "["+"Start/"+sZoneOption+"]";
								sStringPrompt = T(sStringStart2) + sStringOption;
								ssP=PrPoint(sStringPrompt);
								sZone.set(sZones[_iZone]);
							}
						}
					}
				}
				else if(nGoJig == _kCancel)
				{ 
					eraseInstance();
					return;
				}
				else if(nGoJig==_kNone)
				{ 
					eraseInstance();
					return;
				}
			}
			
//			pts.append(getPoint(sPromptStart));
//			String sPromptEnd = T("|Click end point|");
//			PrPoint ssP(sPromptEnd, pts[pts.length()-1]);
//			if(ssP.go()==_kOk)
//			{ 
//				pts.append(ssP.value());
//			}
//			_PtG.append(pts);
		}
		return;
	}	
// end on insert	__________________//endregion
	
//
if(_Element.length()==0)
{ 
	reportMessage("\n"+scriptName()+" "+T("|one wall is needed|"));
	eraseInstance();
	return;
}
//return;
//region fix properties
//return;
int iType=sTypes.find(sType);
Map mapType;
if (iType == 0)
{
	mapType = mapSetting.getMap("Bracing");
	sStudTie.setReadOnly(false);
}
else if (iType == 1)
{
	mapType = mapSetting.getMap("Sheeting");
	sStudTie.setReadOnly(_kReadOnly);
}
	
Map mapManufacturers = mapType.getMap("Manufacturer[]");
sManufacturers.setLength(0);
for (int i = 0; i < mapManufacturers.length(); i++)
{
	Map mapManufacturerI = mapManufacturers.getMap(i);
	if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
	{
		String sName = mapManufacturerI.getString("Name");
		if (sManufacturers.find(sName) < 0)
		{
			// populate sManufacturers with all the Manufacturers of the selected manufacturer
			sManufacturers.append(sName);
		}
	}
}
int indexManufacturer = sManufacturers.find(sManufacturer);
if (indexManufacturer >- 1)
{
	// selected sModelis contained in sModels
	sManufacturer = PropString(3, sManufacturers, sManufacturerName, indexManufacturer);
}
else
{
	// existing sModel is not found, manufacturer has been changed so set 
	// to sModel the first Model from sModels
	sManufacturer = PropString(3, sManufacturers, sManufacturerName, 0);
	sManufacturer.set(sManufacturers[0]);
}
Map mapManufacturer;
for (int i = 0; i < mapManufacturers.length(); i++)
{ 
	Map mapManufacturerI = mapManufacturers.getMap(i);
	if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
	{
		String sManufacturerName = mapManufacturerI.getString("Name");
		
		if (sManufacturerName.makeUpper() != sManufacturer.makeUpper())
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
sFamilies.setLength(0);
// get the models of this family and populate the property list
Map mapFamilies = mapManufacturer.getMap("Family[]");
sFamilies.setLength(0);
for (int i = 0; i < mapFamilies.length(); i++)
{
	Map mapFamilyI = mapFamilies.getMap(i);
	if (mapFamilyI.hasString("Name") && mapFamilies.keyAt(i).makeLower() == "family")
	{
		String sName = mapFamilyI.getString("Name");
		if (sFamilies.find(sName) < 0)
		{
			// populate sFamilies with all the families of the selected manufacturer
			sFamilies.append(sName);
		}
	}
}
int indexFamily = sFamilies.find(sFamily);
if (indexFamily >- 1)
{
	// selected sModelis contained in sModels
	sFamily = PropString(4, sFamilies, sFamilyName, indexFamily);
}
else
{
	// existing sModel is not found, family has been changed so set 
	// to sModel the first Model from sModels
	sFamily = PropString(4, sFamilies, sFamilyName, 0);
	sFamily.set(sFamilies[0]);
}
Map mapFamily;
for (int i = 0; i < mapFamilies.length(); i++)
{ 
	Map mapFamilyI = mapFamilies.getMap(i);
	if (mapFamilyI.hasString("Name") && mapFamilies.keyAt(i).makeLower() == "family")
	{
		String sFamilyName = mapFamilyI.getString("Name");
		
		if (sFamilyName.makeUpper() != sFamily.makeUpper())
		{
			continue;
		}
	}
	else
	{ 
		// not a family map
		continue;
	}
	
	mapFamily = mapFamilies.getMap(i);
	break;
}
sModels.setLength(0);
// get the models of this family and populate the property list
Map mapModels = mapFamily.getMap("Product[]");
sModels.setLength(0);
for (int i = 0; i < mapModels.length(); i++)
{
	Map mapModelI = mapModels.getMap(i);
	if (mapModelI.hasString("Name") && mapModels.keyAt(i).makeLower() == "product")
	{
		String sName = mapModelI.getString("Name");
		if (sModels.find(sName) < 0)
		{
			// populate sModels with all the model of the selected manufacturer
			sModels.append(sName);
		}
	}
}
int indexModel = sModels.find(sModel);
if (indexModel >- 1)
{
	// selected sModelis contained in sModels
	sModel = PropString(5, sModels, sModelName, indexModel);
}
else
{
	// existing sModel is not found, model has been changed so set 
	// to sModel the first Model from sModels
	sModel = PropString(5, sModels, sModelName, 0);
	sModel.set(sModels[0]);
}
Map mapModel;
for (int i = 0; i < mapModels.length(); i++)
{ 
	Map mapModelI = mapModels.getMap(i);
	if (mapModelI.hasString("Name") && mapModels.keyAt(i).makeLower() == "product")
	{
		String sModelName = mapModelI.getString("Name");
		
		if (sModelName.makeUpper() != sModel.makeUpper())
		{
			continue;
		}
	}
	else
	{ 
		// not a model map
		continue;
	}
	
	mapModel = mapModels.getMap(i);
	break;
}
//End fix properties//endregion 
//
Element el=_Element[0];
// basic information
Point3d ptOrg=el.ptOrg();
Vector3d vecX=el.vecX();
Vector3d vecY=el.vecY();
Vector3d vecZ=el.vecZ();

_ThisInst.setAllowGripAtPt0(false);
_Pt0=ptOrg;
assignToElementGroup(el, true, 0, 'Z');
//return;
int iZone=sZones.find(sZone);
int nZone = 1;
Vector3d vecZone = vecZ;
if(iZone==1)
{ 
	// zone -1 is selected
	vecZone*=-1;
	nZone = -1;
}

ElemZone eZone0=el.zone(0);
Plane pn(eZone0.ptOrg()+eZone0.vecZ()*.5*eZone0.dH(),eZone0.vecZ());
pn.vis(3);
//return;

Point3d ptMiddle=ptOrg;
ptMiddle=pn.closestPointTo(ptMiddle);

if(iType==0)
{ 
	for (int pt=0;pt<_PtG.length();pt++) 
	{ 
		_PtG[pt]=Line(ptMiddle,vecX).closestPointTo(_PtG[pt]);
	//	_PtG[pt]=pn.closestPointTo(_PtG[pt]); 
	}//next pt
}
else if(iType==1)
{ 
	for (int pt=0;pt<_PtG.length();pt++) 
	{ 
		pn.closestPointTo(_PtG[pt]);
	//	_PtG[pt]=pn.closestPointTo(_PtG[pt]); 
	}//next pt
}

addRecalcTrigger(_kGripPointDrag, "_PtG1");
addRecalcTrigger(_kGripPointDrag, "_PtG0");
if(iType==0)
{ 
	// bracing
	if(_PtG.length()!=2)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|2 points needed for the definition of bracing|"));
		eraseInstance();
		return;
	}
	if(mapModel.hasDouble("WidthMin"))
		dLMin=mapModel.getDouble("WidthMin");
	if(mapModel.hasDouble("WidthMax"))
		dLMax=mapModel.getDouble("WidthMax");
	if(mapModel.hasDouble("AngleMin"))
		dAngleMin=mapModel.getDouble("AngleMin");
	if(mapModel.hasDouble("AngleMax"))
		dAngleMax=mapModel.getDouble("AngleMax");
	int iStudTie = sNoYes.find(sStudTie);
	
	{
		Display dp(3);
		dp.showInDxa(true);
		Display dpError(1);
		Display dpJigLight(2);
		Display dpDim1(6);
		dpDim1.textHeight(U(50));
		Display dpDim6(6);
		dpDim6.textHeight(U(50));
		Display dpDimIso(6);
		dpDimIso.textHeight(U(50));
		dpJigLight.transparency(80);
		dpDim1.addViewDirection(vecZone);
		dpDim6.addViewDirection(-vecZone);
		dpDimIso.addHideDirection(vecZone);
		dpDimIso.addHideDirection(-vecZone);
		// get the closest stud
		Point3d pt1=_PtG[0];
		// 2. point for direction
		Point3d pt2=_PtG[1];
		
		if (_bOnGripPointDrag && _kExecuteKey=="_PtG0")
		{ 
			pt1=_PtG[1];
			pt2=_PtG[0];
		}
		Vector3d vecDir = vecX * vecX.dotProduct(pt2 - pt1);
		vecDir.normalize();
		Beam beams[] = el.beam();
		Beam bmStuds[] = vecX.filterBeamsPerpendicularSort(beams);
//		Beam bmHors[] = vecY.filterBeamsPerpendicular(beams);
		// accept diagonal beams for gable walls
		Beam bmHors[0];
		for (int ibm=0;ibm<beams.length();ibm++) 
		{ 
			if(bmStuds.find(beams[ibm])<0)
				bmHors.append(beams[ibm]);
		}//next ibm
		Beam bmStud1, bmStud2;
		Beam bmStud12,bmStud21;
		bmStud1=bmStuds[bmStuds.length()-1];
		double dDistMin=U(10e5);
		for (int ib=0;ib<bmStuds.length();ib++) 
		{ 
			double dDistI=abs(vecX.dotProduct(pt1-bmStuds[ib].ptCen()));
			if(dDistI<dDistMin)
			{ 
				bmStud1=bmStuds[ib];
				dDistMin=dDistI;
			}
		}//next ib
		if(iStudTie==1)
		{ 
			dDistMin=U(10e5);
			for (int ib=0;ib<bmStuds.length();ib++) 
			{ 
				if(bmStuds[ib]==bmStud1)continue;
				double dDistI=abs(vecX.dotProduct(pt1-bmStuds[ib].ptCen()));
				if(dDistI<dDistMin)
				{ 
					bmStud12=bmStuds[ib];
					dDistMin=dDistI;
				}
			}//next ib
		}
		// bracing at studs
//		Entity entStud1 = _Map.getEntity("Stud1");
//		Beam bmStud1 = (Beam)entStud1;
//		Beam bmStud12;
		Point3d ptLook = bmStud1.ptCen();
		if(iStudTie==1)
		{ 
//			Entity entStud12=_Map.getEntity("Stud12");
//			bmStud12=(Beam)entStud12;
			ptLook=.5*(bmStud1.ptCen()+bmStud12.ptCen());
		}
		// first and second point, bottom and top
		Point3d pt1Bottom, pt1Top, pt2Bottom, pt2Top;
		// no stud tie, bracing is placed at studs
		// get the closest stud
		
		
		Beam bmTop1, bmBottom1;
		// second diagonal
		Beam bmTop2, bmBottom2;
		double dAngle1, dAngle2, dLength2;
//		Beam bmStud2;
		
		Beam beamsTop[] = Beam().filterBeamsHalfLineIntersectSort(bmHors, ptLook, vecY);
		bmTop1 = beamsTop[beamsTop.length() - 1];
		Beam beamsBottom[] = Beam().filterBeamsHalfLineIntersectSort(bmHors, ptLook, - vecY);
		bmBottom1 = beamsBottom[beamsBottom.length() - 1];
		pt1 += vecX * vecX.dotProduct(ptLook- pt1);
		int iIntersect = Line(ptLook, vecY)
		.hasIntersection(Plane(bmBottom1.ptCen() - bmBottom1.vecD(vecY) * .5 * bmBottom1.dD(vecY), bmBottom1.vecD(vecY)), pt1Bottom);
		iIntersect = Line(ptLook, vecY)
		.hasIntersection(Plane(bmTop1.ptCen() + bmTop1.vecD(vecY) * .5 * bmTop1.dD(vecY), bmTop1.vecD(vecY)), pt1Top);
		Beam bmStudsDir[] = vecDir.filterBeamsPerpendicularSort(bmStuds);
		
		// get min max bmStud2
		Point3d pt2MinBottom, pt2MinTop;
		Point3d pt2MaxBottom, pt2MaxTop;
		Beam bmStudMin2, bmStudMax2;
		Beam bmTopMin2, bmTopMax2;
		Beam bmBottomMin2, bmBottomMax2;
		// min max found valid angles
		double dAngle2Min1 = U(10e5), dAngle2Max1 = -U(10e5);
		double dAngle2Min2 = U(10e5), dAngle2Max2 = -U(10e5);
		// min max found valid lengths
		double dLength2Min = U(10e5), dLength2Max = -U(10e5);
		//
		dDistMin = U(10e4);
		int iMinFound, iMaxFound;
		for (int ibm = bmStudsDir.length()-1; ibm >= 0; ibm--)
		{
			Beam bmI = bmStudsDir[ibm];
			Beam bmI2;
			Point3d ptLook=bmI.ptCen();
			if(iStudTie==1)
			{ 
				if(ibm==0)break;
				bmI2=bmStudsDir[ibm-1];
				ptLook=.5*(bmI.ptCen()+bmI2.ptCen());
			}
			Beam bmTopI, bmBottomI;
			double dLengthI = (vecDir.dotProduct(ptLook-pt1));
			double dDistI = abs(vecDir.dotProduct(ptLook- pt2));
			
//						if (dDistI > dLMax)
//						{
//							continue;
//						}
//						else
			{
				// check the angle
				Point3d pt2TopI,pt2BottomI;
				Beam bmTopI, bmBottomI;
				Beam beamsTopI[] = Beam().filterBeamsHalfLineIntersectSort(bmHors, ptLook, vecY);
				if (beamsTopI.length() == 0)
				{
					continue;
				}
				bmTopI=beamsTopI[beamsTopI.length()-1];
				Beam beamsBottomI[] = Beam().filterBeamsHalfLineIntersectSort(bmHors, ptLook, - vecY);
				if (beamsBottomI.length() == 0)
				{
					continue;
				}
				bmBottomI=beamsBottomI[beamsBottomI.length()-1];
				
				//
				int iIntersect=Line(ptLook,vecY)
					.hasIntersection(Plane(bmBottomI.ptCen()-bmBottomI.vecD(vecY)*.5*bmBottomI.dD(vecY),bmBottomI.vecD(vecY)),pt2BottomI);
				if ( !iIntersect)
				{
					continue;
				}
				iIntersect=Line(ptLook,vecY)
					.hasIntersection(Plane(bmTopI.ptCen()+bmTopI.vecD(vecY)*.5*bmTopI.dD(vecY),bmTopI.vecD(vecY)),pt2TopI);
				if ( !iIntersect)
				{
					continue;
				}
				
				Vector3d vec1 = pt2TopI-pt1Bottom;
				Vector3d vecXangle = vecDir;
				vec1.normalize();
				if (vec1.dotProduct(vecXangle) < 0)vecXangle *= -1;
				Vector3d vecRef=vec1.crossProduct(vecXangle);
				vecRef.normalize();
//				vec1.vis(pt1Bottom);
//				vecXangle.vis(pt1Bottom);
//				vecRef.vis(pt1Bottom);
//							double dAngleI1=vec1.angleTo(vecXangle, vecRef);
				double dAngleI1=vec1.angleTo(vecXangle);
				if (dAngleI1 > U(90))dAngleI1 -= U(90);
				Vector3d vec2=pt1Top-pt2BottomI;
				vec2.normalize();
				if(vec2.dotProduct(vecXangle)<0)vecXangle*=-1;
				vecRef=vec2.crossProduct(vecXangle);
				vecRef.normalize();
//							double dAngleI2=vec2.angleTo(vecXangle,vecRef);
				double dAngleI2=vec2.angleTo(vecXangle);
				if (dAngleI2 > U(90))dAngleI2 -= U(90);
				if (dDistI < dDistMin)
				{
					// get closest possible beam
					dDistMin=dDistI;
					bmStud2=bmI;
					bmStud21=bmI2;
					bmBottom2=bmBottomI;
					bmTop2=bmTopI;
					dAngle1=dAngleI1;
					dAngle2=dAngleI2;
					dLength2=dLengthI;
					pt2Bottom=pt2BottomI;
					pt2Top=pt2TopI;
				}
				if (dAngleI1>dAngleMax)
				{
					// bracing not possible
//								break;
				}
				else if (dAngleI1<dAngleMin)
				{
//								continue;
				}
				// valid bracing
				if(dAngleI1>=dAngleMin && dAngleI1<=dAngleMax
				&& dAngleI2>=dAngleMin && dAngleI2<=dAngleMax
				&& dLengthI>=dLMin && dLengthI<=dLMax)
				{ 
					// capture min max valid bracings
					if(dLengthI<dLength2Min)
					{ 
						iMinFound = true;
						dLength2Min=dLengthI;
						bmStudMin2=bmI;
						dAngle2Min1=dAngleI1;
						dAngle2Min2=dAngleI2;
						pt2MinBottom = pt2BottomI;
						pt2MinTop = pt2TopI;
						bmBottomMin2 = bmBottomI;
						bmTopMin2 = bmTopI;
					}
					if(dLengthI>dLength2Max)
					{ 
						iMaxFound = true;
						dLength2Max=dLengthI;
						bmStudMax2=bmI;
						dAngle2Max1=dAngleI1;
						dAngle2Max2=dAngleI2;
						pt2MaxBottom = pt2BottomI;
						pt2MaxTop = pt2TopI;
						bmBottomMax2= bmBottomI;
						bmTopMax2 = bmTopI;
						
					}
				}
			}
		}
		
		// display in jig
		// top profile subtract
		PlaneProfile ppSubtractTop1(el.coordSys());
		PLine plSubtractTop1;
		plSubtractTop1.createRectangle(LineSeg(pt1Top-bmTop1.vecX()*U(10e4),
			pt1Top+bmTop1.vecX()*2*U(10e4)+bmTop1.vecD(vecY)*U(10e3)),bmTop1.vecX(),bmTop1.vecD(vecY));
//		plSubtractTop1.vis(3);
		ppSubtractTop1.joinRing(plSubtractTop1, _kAdd);
		// bottom profile subtract
		PlaneProfile ppSubtractBottom1(el.coordSys());
		PLine plSubtractBottom1;
		plSubtractBottom1.createRectangle(LineSeg(pt1Bottom-bmBottom1.vecX()*U(10e4),
			pt1Bottom+bmBottom1.vecX()*2*U(10e4)-bmBottom1.vecD(vecY)*U(10e3)),bmBottom1.vecX(),bmBottom1.vecD(vecY));
//		plSubtractTop1.vis(3);
		ppSubtractBottom1.joinRing(plSubtractBottom1, _kAdd);
		int iClock = vecDir.dotProduct(vecX) > 0;
		// Min
		if (iMinFound)
		{ 
			PlaneProfile ppSubtractBottom2(el.coordSys());
			PLine plSubtractBottom2;
			plSubtractBottom2.createRectangle(LineSeg(pt2MinBottom-bmBottomMin2.vecX()*U(10e4),
				pt2MinBottom+bmBottomMin2.vecX()*2*U(10e4)-bmBottomMin2.vecD(vecY)*U(10e3)),bmBottomMin2.vecX(),bmBottom2.vecD(vecY));
	//		plSubtractTop1.vis(3);
			ppSubtractBottom2.joinRing(plSubtractBottom2, _kAdd);
			
			PlaneProfile ppSubtractTop2(el.coordSys());
			PLine plSubtractTop2;
			plSubtractTop2.createRectangle(LineSeg(pt2MinTop-bmTop2.vecX()*U(10e4),
				pt2MinTop+bmTop1.vecX()*2*U(10e4)+bmTop2.vecD(vecY)*U(10e3)),bmTop2.vecX(),bmTop2.vecD(vecY));
	//		plSubtractTop2.vis(3);
			ppSubtractTop2.joinRing(plSubtractTop1, _kAdd);
			
			Vector3d vecXbracing=pt2MinTop-pt1Bottom;
			vecXbracing.normalize();
			Vector3d vecYbracing=vecZ.crossProduct(vecXbracing);
			vecYbracing.normalize();
			PlaneProfile pp1(Plane(pt1Top,vecZ));
			PLine pl1;
			pl1.createRectangle(LineSeg(pt1Bottom-vecXbracing*U(100)-vecYbracing*U(2),
				pt2MinTop+vecXbracing*U(100)+vecYbracing*U(2)),
					vecXbracing, vecYbracing);
			
			pl1.transformBy(vecZone*.5*eZone0.dH());
			pl1.vis(1);
			pp1.joinRing(pl1, _kAdd);
			pp1.subtractProfile(ppSubtractBottom1);
			pp1.subtractProfile(ppSubtractTop1);
			pp1.transformBy(vecZone*.5*eZone0.dH());
	//		double ddd = eZone0.dH();
			pp1.vis(4);
			PLine pls1[] = pp1.allRings(true, false);
			if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
			{
				dpJigLight.draw(pp1, _kDrawFilled);
			}
			if(pls1.length()==0)return;
			pl1 = pls1[0];
			Body bd1(pl1, vecZone*U(2));
			
			// second bracing
			vecXbracing=pt2MinBottom-pt1Top;
			vecXbracing.normalize();
			vecYbracing=vecZ.crossProduct(vecXbracing);
			vecYbracing.normalize();
			
			PlaneProfile pp2(Plane(pt1Top,vecZ));
			PLine pl2;
			pl2.createRectangle(LineSeg(pt1Top-vecXbracing*U(100)-vecYbracing*U(2),
				pt2MinBottom+vecXbracing*U(100)+vecYbracing*U(2)),
					vecXbracing, vecYbracing);
	//		pl2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
			pp2.joinRing(pl2, _kAdd);
			pp2.subtractProfile(ppSubtractBottom2);
			pp2.subtractProfile(ppSubtractTop2);
			pp2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
			if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
				dpJigLight.draw(pp2, _kDrawFilled);
			
			PLine pls2[] = pp2.allRings(true, false);
			pl2 = pls2[0];
			pl2.vis(3);
			Body bd2(pl2, vecZone * U(2));
			bd2.vis(3);
	//		dp.draw(pl1);
//				dpJigLight.draw(bd1);
//				dpJigLight.draw(bd2);
			// display angle and arc
			{
				// draw text
				// arc left
				Vector3d vecXzone = vecY.crossProduct(vecZone);
				{ 
					Vector3d vec1=pt2MinTop-pt1Bottom;
					vec1.normalize();
					Point3d ptArc1 = pt1Bottom + vec1 * U(200);
					Point3d ptArc2 = pt1Bottom + vecDir * U(200);
					Vector3d vecArcMiddle = vec1 + vecDir;
					vecArcMiddle.normalize();
					Point3d ptArcMiddle = pt1Bottom + vecArcMiddle * U(200);
					PLine plArc(vecZ);
					plArc.addVertex(ptArc1);
//					plArc.addVertex(ptArc2,ptArcMiddle);
					
					plArc.addVertex(ptArc2,U(200), iClock,true);
					if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
					{ 
						dpDim1.draw(plArc);
						dpDim6.draw(plArc);
						dpDimIso.draw(plArc);
					}
					Vector3d vecXdim1 = vecArcMiddle.dotProduct(vecXzone)>0?vecArcMiddle:-vecArcMiddle;
					Vector3d vecYdim = vecZone.crossProduct(vecXdim1);
					String sAngle2Min1;sAngle2Min1.format("%.1f", dAngle2Min1);
					if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
					{ 
						dpDim1.draw(sAngle2Min1, ptArcMiddle, vecXdim1, vecYdim, 0, 0);
						dpDim6.draw(sAngle2Min1, ptArcMiddle, -vecXdim1, vecYdim, 0, 0);
						dpDimIso.draw(sAngle2Min1, ptArcMiddle, _XW, _YW, 0, 0,_kDeviceX);
					}
				}
				// arc right
				{ 
					Vector3d vec1=pt1Top-pt2MinBottom;
					vec1.normalize();
					Point3d ptArc1 = pt2MinBottom + vec1 * U(200);
					Point3d ptArc2 = pt2MinBottom + -vecDir * U(200);
					Vector3d vecArcMiddle = vec1 + -vecDir;
					vecArcMiddle.normalize();
					Point3d ptArcMiddle = pt2MinBottom + vecArcMiddle * U(200);
					PLine plArc(-vecZ);
					plArc.addVertex(ptArc1);
//							plArc.addVertex(ptArc2,ptArcMiddle);
//					plArc.addVertex(ptArcMiddle,ptArc2);
					plArc.addVertex(ptArc2,U(200), -iClock,true);
//					ptArc2.vis(2);
//					ptArcMiddle.vis(2);
//					plArc.vis(1);
					if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
					{ 
						dpDim1.draw(plArc);
						dpDim6.draw(plArc);
						dpDimIso.draw(plArc);
					}
					Vector3d vecXdim1 = vecArcMiddle.dotProduct(vecXzone)>0?vecArcMiddle:-vecArcMiddle;
					Vector3d vecYdim = vecZone.crossProduct(vecXdim1);
					String sAngle2Min2;sAngle2Min2.format("%.1f", dAngle2Min2);
					if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
					{ 
						dpDim1.draw(sAngle2Min2, ptArcMiddle, vecXdim1, vecYdim, 0, 0);
						dpDim6.draw(sAngle2Min2, ptArcMiddle, -vecXdim1, vecYdim, 0, 0);
						dpDimIso.draw(sAngle2Min2, ptArcMiddle, _XW, _YW, 0, 0,_kDeviceX);
					}
				}
				
				// DimLine requires a dimstyle
				Vector3d vecXdimHor1 = vecXzone;
				
//							DimLine dl(pt1Bottom - vecY * U(100), vecXdimHor1, vecYdim);
//							Dim dim(dl, pt1Bottom, pt2MinBottom );
//							dpDim1.draw(dim);
				
				// 
				LineSeg seg(pt1Bottom-vecDir*U(50)-vecY*U(150), 
					pt2MinBottom + vecDir * U(50) - vecY * U(150));
				LineSeg seg1(pt1Bottom-vecY*U(150+50), 
					pt1Bottom - vecY * U(150-50));
				LineSeg seg2(pt2MinBottom-vecY*U(150+50), 
					pt2MinBottom - vecY * U(150-50));
				if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
				{ 
					dpDim1.draw(seg);							
					dpDim6.draw(seg);							
					dpDimIso.draw(seg);							
					dpDim1.draw(seg1);
					dpDim6.draw(seg1);
					dpDimIso.draw(seg1);
					dpDim1.draw(seg2);
					dpDim6.draw(seg2);
					dpDimIso.draw(seg2);
				}
				String sLength2Min;sLength2Min.format("%.1f", dLength2Min);
				if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
				{ 
					dpDim1.draw(sLength2Min, seg.ptMid(), vecXdimHor1, vecY, 0, 1.2);
					dpDim6.draw(sLength2Min, seg.ptMid(), -vecXdimHor1, vecY, 0, 1.2);
					dpDimIso.draw(sLength2Min, seg.ptMid(), _XW, _YW, 0, 1.2,_kDeviceX);
				}
			}
		}
		// Max
		if(iMaxFound)
		{ 
			PlaneProfile ppSubtractBottom2(el.coordSys());
			PLine plSubtractBottom2;
			plSubtractBottom2.createRectangle(LineSeg(pt2MaxBottom-bmBottomMax2.vecX()*U(10e4),
				pt2MaxBottom+bmBottomMax2.vecX()*2*U(10e4)-bmBottomMax2.vecD(vecY)*U(10e3)),bmBottomMax2.vecX(),bmBottomMax2.vecD(vecY));
	//		plSubtractTop1.vis(3);
			ppSubtractBottom2.joinRing(plSubtractBottom2, _kAdd);
			
			PlaneProfile ppSubtractTop2(el.coordSys());
			PLine plSubtractTop2;
			plSubtractTop2.createRectangle(LineSeg(pt2MaxTop-bmTop2.vecX()*U(10e4),
				pt2MaxTop+bmTop1.vecX()*2*U(10e4)+bmTop2.vecD(vecY)*U(10e3)),bmTop2.vecX(),bmTop2.vecD(vecY));
	//		plSubtractTop2.vis(3);
			ppSubtractTop2.joinRing(plSubtractTop1, _kAdd);
			
			Vector3d vecXbracing=pt2MaxTop-pt1Bottom;
			vecXbracing.normalize();
			Vector3d vecYbracing=vecZ.crossProduct(vecXbracing);
			vecYbracing.normalize();
			
			PlaneProfile pp1(Plane(pt1Top,vecZ));
			PLine pl1;
			pl1.createRectangle(LineSeg(pt1Bottom-vecXbracing*U(100)-vecYbracing*U(2),pt2MaxTop+vecXbracing*U(100)+vecYbracing*U(2)),
					vecXbracing, vecYbracing);
			
			pl1.transformBy(vecZone*.5*eZone0.dH());
			pl1.vis(1);
			pp1.joinRing(pl1, _kAdd);
			pp1.subtractProfile(ppSubtractBottom1);
			pp1.subtractProfile(ppSubtractTop1);
			pp1.transformBy(vecZone*.5*eZone0.dH());
			if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
			{
				dpJigLight.draw(pp1, _kDrawFilled);
			}
			pp1.vis(4);
			PLine pls1[] = pp1.allRings(true, false);
			if(pls1.length()==0)return;
			pl1 = pls1[0];
			Body bd1(pl1, vecZone*U(2));
			
			// second bracing
			vecXbracing=pt2MaxBottom-pt1Top;
			vecXbracing.normalize();
			vecYbracing=vecZ.crossProduct(vecXbracing);
			vecYbracing.normalize();
			
			PlaneProfile pp2(Plane(pt1Top,vecZ));
			PLine pl2;
			pl2.createRectangle(LineSeg(pt1Top-vecXbracing*U(100)-vecYbracing*U(2),pt2MaxBottom+vecXbracing*U(100)+vecYbracing*U(2)),
					vecXbracing, vecYbracing);
	//		pl2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
			pp2.joinRing(pl2, _kAdd);
			pp2.subtractProfile(ppSubtractBottom2);
			pp2.subtractProfile(ppSubtractTop2);
			pp2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
			if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
			{
				dpJigLight.draw(pp2, _kDrawFilled);
			}
			
			PLine pls2[] = pp2.allRings(true, false);
			pl2 = pls2[0];
			pl2.vis(3);
			Body bd2(pl2, vecZone * U(2));
			bd2.vis(3);
	//		dp.draw(pl1);
//						dpjig.draw(bd1);
//						dpjig.draw(bd2);
			// display angle and arc
			{
				// draw text
				Vector3d vecXzone = vecY.crossProduct(vecZone);
				// arc left
				{ 
					Vector3d vec1=pt2MaxTop-pt1Bottom;
					vec1.normalize();
					Point3d ptArc1 = pt1Bottom + vec1 * U(400);
					Point3d ptArc2 = pt1Bottom + vecDir * U(400);
					Vector3d vecArcMiddle = vec1 + vecDir;
					vecArcMiddle.normalize();
					Point3d ptArcMiddle = pt1Bottom + vecArcMiddle * U(400);
					PLine plArc(vecZ);
					plArc.addVertex(ptArc1);
//							plArc.addVertex(ptArc2,ptArcMiddle);
//					plArc.addVertex(ptArcMiddle,ptArc2);
//					plArc.addVertex(ptArc2,ptArcMiddle);
					plArc.addVertex(ptArc2,U(400), iClock,true);
					if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
					{ 
						dpDim1.draw(plArc);
						dpDim6.draw(plArc);
						dpDimIso.draw(plArc);
					}
					
					Vector3d vecXdim1 = vecArcMiddle.dotProduct(vecXzone)>0?vecArcMiddle:-vecArcMiddle;
					Vector3d vecYdim = vecZone.crossProduct(vecXdim1);
					String sAngle2Max1;sAngle2Max1.format("%.1f", dAngle2Max1);
					if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
					{ 
						dpDim1.draw(sAngle2Max1, ptArcMiddle, vecXdim1, vecYdim, 0, 0);
						dpDim6.draw(sAngle2Max1, ptArcMiddle, -vecXdim1, vecYdim, 0, 0);
						dpDimIso.draw(sAngle2Max1, ptArcMiddle, _XW, _YW, 0, 0,_kDeviceX);
					}
				}
				// arc right
				{ 
					Vector3d vec1=pt1Top-pt2MaxBottom;
					vec1.normalize();
					Point3d ptArc1 = pt2MaxBottom + vec1 * U(200);
					Point3d ptArc2 = pt2MaxBottom + -vecDir * U(200);
					Vector3d vecArcMiddle = vec1 + -vecDir;
					vecArcMiddle.normalize();
					Point3d ptArcMiddle = pt2MaxBottom + vecArcMiddle * U(200);
					PLine plArc(-vecZ);
					plArc.addVertex(ptArc1);
//							plArc.addVertex(ptArc2,ptArcMiddle);
//					plArc.addVertex(ptArcMiddle,ptArc2);
//					plArc.addVertex(ptArc2,ptArcMiddle);
					plArc.addVertex(ptArc2,U(200), -iClock,true);
					if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
					{ 
						dpDim1.draw(plArc);
						dpDim6.draw(plArc);
						dpDimIso.draw(plArc);
					}
					Vector3d vecXdim1 = vecArcMiddle.dotProduct(vecXzone)>0?vecArcMiddle:-vecArcMiddle;
					Vector3d vecYdim = vecZone.crossProduct(vecXdim1);
					String sAngle2Max2;sAngle2Max2.format("%.1f", dAngle2Max2);
					if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
					{ 
						dpDim1.draw(sAngle2Max2, ptArcMiddle, vecXdim1, vecYdim, 0, 0);
						dpDim6.draw(sAngle2Max2, ptArcMiddle, -vecXdim1, vecYdim, 0, 0);
						dpDimIso.draw(sAngle2Max2, ptArcMiddle, _XW, _YW, 0, 0,_kDeviceX);
					}
				}
				
				// DimLine requires a dimstyle
				Vector3d vecXdimHor1 = vecXzone;
				
//							DimLine dl(pt1Bottom - vecY * U(100), vecXdimHor1, vecYdim);
//							Dim dim(dl, pt1Bottom, pt2MinBottom );
//							dpDim1.draw(dim);
				
				// 
				LineSeg seg(pt1Bottom-vecDir*U(50)-vecY*U(300), 
					pt2MaxBottom + vecDir * U(50) - vecY * U(300));
				LineSeg seg1(pt1Bottom-vecY*U(300+50), 
					pt1Bottom - vecY * U(300-50));
				LineSeg seg2(pt2MaxBottom-vecY*U(300+50), 
					pt2MaxBottom - vecY * U(300-50));
				if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
				{ 
					dpDim1.draw(seg);							
					dpDim6.draw(seg);							
					dpDimIso.draw(seg);							
					dpDim1.draw(seg1);
					dpDim6.draw(seg1);
					dpDimIso.draw(seg1);
					dpDim1.draw(seg2);
					dpDim6.draw(seg2);
					dpDimIso.draw(seg2);
				}
				String sLength2Max;sLength2Max.format("%.1f", dLength2Max);
				if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
				{ 
					dpDim1.draw(sLength2Max, seg.ptMid(), vecXdimHor1, vecY, 0, 1.2);
					dpDim6.draw(sLength2Max, seg.ptMid(), -vecXdimHor1, vecY, 0, 1.2);
					dpDimIso.draw(sLength2Max, seg.ptMid(), _XW, _YW, 0, 1.2,_kDeviceX);
				}
			}
		}
		// Brace
		{ 
			PlaneProfile ppSubtractBottom2(el.coordSys());
			PLine plSubtractBottom2;
			plSubtractBottom2.createRectangle(LineSeg(pt2Bottom-bmBottom2.vecX()*U(10e4),
				pt2Bottom+bmBottom2.vecX()*2*U(10e4)-bmBottom2.vecD(vecY)*U(10e3)),bmBottom2.vecX(),bmBottom2.vecD(vecY));
	//		plSubtractTop1.vis(3);
			ppSubtractBottom2.joinRing(plSubtractBottom2, _kAdd);
			
			PlaneProfile ppSubtractTop2(el.coordSys());
			PLine plSubtractTop2;
			plSubtractTop2.createRectangle(LineSeg(pt2Top-bmTop2.vecX()*U(10e4),
				pt2Top+bmTop1.vecX()*2*U(10e4)+bmTop2.vecD(vecY)*U(10e3)),bmTop2.vecX(),bmTop2.vecD(vecY));
	//		plSubtractTop2.vis(3);
			ppSubtractTop2.joinRing(plSubtractTop1, _kAdd);
			
			Vector3d vecXbracing=pt2Top-pt1Bottom;
			vecXbracing.normalize();
			Vector3d vecYbracing=vecZ.crossProduct(vecXbracing);
			vecYbracing.normalize();
			
			PlaneProfile pp1(Plane(pt1Top,vecZ));
			PLine pl1;
			pl1.createRectangle(LineSeg(pt1Bottom-vecXbracing*U(100)-vecYbracing*U(15),pt2Top+vecXbracing*U(100)+vecYbracing*U(15)),
					vecXbracing, vecYbracing);
			
			pl1.transformBy(vecZone*.5*eZone0.dH());
			pl1.vis(1);
			pp1.joinRing(pl1, _kAdd);
			pp1.subtractProfile(ppSubtractBottom1);
			pp1.subtractProfile(ppSubtractTop1);
			pp1.transformBy(vecZone*.5*eZone0.dH());
	//		double ddd = eZone0.dH();
			pp1.vis(4);
			PLine pls1[] = pp1.allRings(true, false);
			if(pls1.length()==0)return;
			pl1 = pls1[0];
			Body bd1(pl1, vecZone*U(2));
			
			// second bracing
			vecXbracing=pt2Bottom-pt1Top;
			vecXbracing.normalize();
			vecYbracing=vecZ.crossProduct(vecXbracing);
			vecYbracing.normalize();
			
			PlaneProfile pp2(Plane(pt1Top,vecZ));
			PLine pl2;
			pl2.createRectangle(LineSeg(pt1Top-vecXbracing*U(100)-vecYbracing*U(15),pt2Bottom+vecXbracing*U(100)+vecYbracing*U(15)),
					vecXbracing, vecYbracing);
	//		pl2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
			pp2.joinRing(pl2, _kAdd);
			pp2.subtractProfile(ppSubtractBottom2);
			pp2.subtractProfile(ppSubtractTop2);
			pp2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
			PLine pls2[] = pp2.allRings(true, false);
			pl2 = pls2[0];
			pl2.vis(3);
			Body bd2(pl2, vecZone * U(2));
			bd2.vis(3);
	//		dp.draw(pl1);
			if(dAngle1>=dAngleMin && dAngle1<=dAngleMax
				&& dAngle2>=dAngleMin && dAngle2<=dAngleMax
				&& dLength2>=dLMin && dLength2<=dLMax)
			{ 
				dp.draw(bd1);
				dp.draw(bd2);
			}
			else
			{ 
				dpError.draw(bd1);
				dpError.draw(bd2);
			}
			// display angle and arc
			{
				// draw text
				Vector3d vecXzone = vecY.crossProduct(vecZone);
				// arc left
				{ 
					Vector3d vec1=pt2Top-pt1Bottom;
					vec1.normalize();
					Point3d ptArc1 = pt1Bottom + vec1 * U(600);
					Point3d ptArc2 = pt1Bottom + vecDir * U(600);
					Vector3d vecArcMiddle = vec1 + vecDir;
					vecArcMiddle.normalize();
					Point3d ptArcMiddle = pt1Bottom + vecArcMiddle * U(600);
					PLine plArc(vecZ);
					plArc.addVertex(ptArc1);
//							plArc.addVertex(ptArc2,ptArcMiddle);
//					plArc.addVertex(ptArcMiddle,ptArc2);
//					plArc.addVertex(ptArc2,ptArcMiddle);
					plArc.addVertex(ptArc2,U(600), iClock,true);
					if(dAngle1<dAngleMin || dAngle1>dAngleMax)
					{ 
						dpDim1.color(1);
						dpDim6.color(1);
						dpDimIso.color(1);
					}
					else
					{ 
						dpDim1.color(3);
						dpDim6.color(3);
						dpDimIso.color(3);
					}
					if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
					{ 
						dpDim1.draw(plArc);
						dpDim6.draw(plArc);
						dpDimIso.draw(plArc);
					}
					Vector3d vecXdim1 = vecArcMiddle.dotProduct(vecXzone)>0?vecArcMiddle:-vecArcMiddle;
					Vector3d vecYdim = vecZone.crossProduct(vecXdim1);
					String sAngle1;sAngle1.format("%.1f", dAngle1);
					if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
					{ 
						dpDim1.draw(sAngle1, ptArcMiddle, vecXdim1, vecYdim, 0, 0);
						dpDim6.draw(sAngle1, ptArcMiddle, -vecXdim1, vecYdim, 0, 0);
						dpDimIso.draw(sAngle1, ptArcMiddle, _XW, _YW, 0, 0,_kDeviceX);
						dpDim1.color(6);
						dpDim6.color(6);
						dpDimIso.color(6);
					}
				}
				// arc right
				{ 
					Vector3d vec1=pt1Top-pt2Bottom;
					vec1.normalize();
					Point3d ptArc1 = pt2Bottom + vec1 * U(200);
					Point3d ptArc2 = pt2Bottom + -vecDir * U(200);
					Vector3d vecArcMiddle = vec1 + -vecDir;
					vecArcMiddle.normalize();
					Point3d ptArcMiddle = pt2Bottom + vecArcMiddle * U(200);
					PLine plArc(-vecZ);
					plArc.addVertex(ptArc1);
//							plArc.addVertex(ptArc2,ptArcMiddle);
//					plArc.addVertex(ptArcMiddle,ptArc2);
//					plArc.addVertex(ptArc2,ptArcMiddle);
					plArc.addVertex(ptArc2,U(200), -iClock,true);
					if(dAngle2<dAngleMin || dAngle2>dAngleMax)
					{ 
						dpDim1.color(1);
						dpDim6.color(1);
						dpDimIso.color(1);
					}
					else
					{ 
						dpDim1.color(3);
						dpDim6.color(3);
						dpDimIso.color(3);
					}
					if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
					{ 
						dpDim1.draw(plArc);
						dpDim6.draw(plArc);
						dpDimIso.draw(plArc);
					}
					Vector3d vecXdim1 = vecArcMiddle.dotProduct(vecXzone)>0?vecArcMiddle:-vecArcMiddle;
					Vector3d vecYdim = vecZone.crossProduct(vecXdim1);
					String sAngle2;sAngle2.format("%.1f", dAngle2);
					if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
					{ 
						dpDim1.draw(sAngle2, ptArcMiddle, vecXdim1, vecYdim, 0, 0);
						dpDim6.draw(sAngle2, ptArcMiddle, -vecXdim1, vecYdim, 0, 0);
						dpDimIso.draw(sAngle2, ptArcMiddle, _XW, _YW, 0, 0,_kDeviceX);
						dpDim1.color(6);
						dpDim6.color(6);
						dpDimIso.color(6);
					}
				}
				
				// DimLine requires a dimstyle
				Vector3d vecXdimHor1 = vecXzone;
				
//							DimLine dl(pt1Bottom - vecY * U(100), vecXdimHor1, vecYdim);
//							Dim dim(dl, pt1Bottom, pt2MinBottom );
//							dpDim1.draw(dim);
				
				// 
				LineSeg seg(pt1Bottom-vecDir*U(50)-vecY*U(450), 
					pt2Bottom + vecDir * U(50) - vecY * U(450));
				LineSeg seg1(pt1Bottom-vecY*U(450+50), 
					pt1Bottom - vecY * U(450-50));
				LineSeg seg2(pt2Bottom-vecY*U(450+50), 
					pt2Bottom - vecY * U(450-50));
				if(dLength2<dLMin || dLength2>dLMax)
				{ 
					dpDim1.color(1);
					dpDim6.color(1);
					dpDimIso.color(1);
				}
				else
				{ 
					dpDim1.color(3);
					dpDim6.color(3);
					dpDimIso.color(3);
				}
				if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
				{ 
					dpDim1.draw(seg);							
					dpDim6.draw(seg);							
					dpDimIso.draw(seg);							
					dpDim1.draw(seg1);
					dpDim6.draw(seg1);
					dpDimIso.draw(seg1);
					dpDim1.draw(seg2);
					dpDim6.draw(seg2);
					dpDimIso.draw(seg2);
				}
				String sLength2;sLength2.format("%.1f", dLength2);
				if (_bOnGripPointDrag && (_kExecuteKey=="_PtG1" || _kExecuteKey=="_PtG0"))
				{ 
					dpDim1.draw(sLength2, seg.ptMid(), vecXdimHor1, vecY, 0, 1.2);
					dpDim6.draw(sLength2, seg.ptMid(), -vecXdimHor1, vecY, 0, 1.2);
					dpDimIso.draw(sLength2, seg.ptMid(), _XW, _YW, 0, 1.2,_kDeviceX);
					dpDim1.color(6);
					dpDim6.color(6);
					dpDimIso.color(6);
					return;
				}
			}
			
		// save hardware
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
				Element elHW =el.element(); 
				// check if the parent entity is an element
				if (!elHW.bIsValid())	elHW = (Element)el;
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
				HardWrComp hwc(sModel, 1); // the articleNumber and the quantity is mandatory
				
				hwc.setManufacturer(mapManufacturer.getString("Name"));
				
//					hwc.setModel(sHWModel);
//					hwc.setName(sHWName);
//					hwc.setDescription(sHWDescription);
//					hwc.setMaterial(sHWMaterial);
//					hwc.setNotes(sHWNotes);
				
				hwc.setGroup(sHWGroupName);
				hwc.setLinkedEntity(el);	
				hwc.setCategory(T("|Connector|"));
				hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
				double dHWLength = (pt1Bottom - pt2Top).length() + bmTop2.dD(vecZ) + bmBottom1.dD(vecZ);
				hwc.setDScaleX(dHWLength);
				hwc.setDScaleY(mapModel.getDouble("Width"));
				hwc.setDScaleZ(mapModel.getDouble("Thickness"));
				
			// apppend component to the list of components
				hwcs.append(hwc);
			}
			{ 
				HardWrComp hwc(sModel, 1); // the articleNumber and the quantity is mandatory
				
				hwc.setManufacturer(mapManufacturer.getString("Name"));
				
//					hwc.setModel(sHWModel);
//					hwc.setName(sHWName);
//					hwc.setDescription(sHWDescription);
//					hwc.setMaterial(sHWMaterial);
//					hwc.setNotes(sHWNotes);
				
				hwc.setGroup(sHWGroupName);
				hwc.setLinkedEntity(el);	
				hwc.setCategory(T("|Connector|"));
				hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
				double dHWLength = (pt2Bottom - pt1Top).length() + bmTop2.dD(vecZ) + bmBottom1.dD(vecZ);
				hwc.setDScaleX(dHWLength);
				hwc.setDScaleY(mapModel.getDouble("Width"));
				hwc.setDScaleZ(mapModel.getDouble("Thickness"));
				
			// apppend component to the list of components
				hwcs.append(hwc);
			}

		// make sure the hardware is updated
			if (_bOnDbCreated)	setExecutionLoops(2);				
			_ThisInst.setHardWrComps(hwcs);	
			//endregion
		}
		
		// add studtie
		// create TSL
		// cleanup stud tie
		String sKeysDelete[0];
		if (iStudTie == 0 && _kNameLastChangedProp == sStudTieName)
		{
			String ss[] ={ "tslLeftTop", "tslLeftBottom", "tslRightTop", "tslRightBottom" };
			sKeysDelete.append(ss);
		}
		else if(_kNameLastChangedProp == "_PtG0")
		{ 
			String ss[] ={ "tslLeftTop", "tslLeftBottom" };
//			String ss[] ={ "tslLeftTop", "tslLeftBottom", "tslRightTop", "tslRightBottom" };
			
			sKeysDelete.append(ss);
		}
		else if(_kNameLastChangedProp == "_PtG1")
		{ 
			String ss[] ={ "tslRightTop", "tslRightBottom" };
//			String ss[] ={ "tslLeftTop", "tslLeftBottom", "tslRightTop", "tslRightBottom" };
			
			sKeysDelete.append(ss);
		}
		// left beam top
		for (int itsl=0; itsl<sKeysDelete.length(); itsl++)
		{
			Entity ent = _Map.getEntity(sKeysDelete[itsl]);
			ent.dbErase();
			_Map.removeAt(sKeysDelete[itsl], true);
		}
		if(_kNameLastChangedProp == sZoneName)
		{ 
			String sKeys[] ={ "tslLeftTop", "tslLeftBottom", "tslRightTop", "tslRightBottom" };
			for (int itsl=0; itsl<sKeys.length(); itsl++)
			{
				Entity ent = _Map.getEntity(sKeys[itsl]);
				TslInst tslI = (TslInst)ent;
				tslI.setPropString(3, sZone);
			}
		}
		
		if(iStudTie==1)
		{ 
			TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[2]; Entity entsTsl[1]; Point3d ptsTsl[] = {_Pt0};
			int nProps[]={}; double dProps[]={}; String sProps[]={T("<|Disabled|>"),T("<|Disabled|>"),T("|Left|"),sZone};
			Map mapTsl;
			mapTsl.setInt("mode", 1);
			entsTsl[0] = el;
			Beam bmMale1=vecDir.dotProduct(bmStud12.ptCen()-bmStud1.ptCen())>0?bmStud12:bmStud1;
			Beam bmMale2=vecDir.dotProduct(bmStud21.ptCen()-bmStud2.ptCen())<0?bmStud21:bmStud2;
			Beam bmMales[] ={ bmMale1, bmMale1, bmMale2, bmMale2};
			Beam bmFemales[] ={ bmTop1, bmBottom1, bmTop2, bmBottom2};
			String sKeys[] ={ "tslLeftTop", "tslLeftBottom", "tslRightTop", "tslRightBottom" };
			// left beam top
			for (int itsl=0;itsl<bmMales.length();itsl++) 
			{ 
				Beam bmMale = bmMales[itsl]; 
				Beam bmFemale = bmFemales[itsl]; 
				Entity ent = _Map.getEntity(sKeys[itsl]);
				TslInst tsl = (TslInst)ent;
				if(!tsl.bIsValid())
				{ 
					gbsTsl[0]=bmMale;
					gbsTsl[1]=bmFemale;
	
					tslNew.dbCreate("hsbStudTie" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
						ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
					_Map.setEntity(sKeys[itsl], tslNew);
				}
			}//next itsl
		}
	}
	
	
	return;
//	if(iStudTie==0)
//	{ 
//		// cleanup stud tie
//		String sKeys[] ={ "tslLeftTop", "tslLeftBottom", "tslRightTop", "tslRightBottom" };
//		// left beam top
//		for (int itsl=0; itsl<sKeys.length(); itsl++)
//		{
//			Entity ent = _Map.getEntity(sKeys[itsl]);
//			ent.dbErase();
//			_Map.removeAt(sKeys[itsl], true);
//		}
//	// first and second point, bottom and top
//		Point3d pt1Bottom, pt1Top, pt2Bottom, pt2Top;
//		// no stud tie, bracing is placed at studs
//		// get the closest stud
//		Point3d pt1=_PtG[0];
//		// 2. point for direction
//		Point3d pt2=_PtG[1];
//		// 
//		Vector3d vecDir=vecX*vecX.dotProduct(pt2-pt1);
//		vecDir.normalize();
//		Beam beams[]=el.beam();
//		Beam bmStuds[]=vecX.filterBeamsPerpendicularSort(beams);
//		Beam bmHors[]=vecY.filterBeamsPerpendicular(beams);
//		if(bmStuds.length()==0 || bmHors.length()==0)
//		{ 
//			reportMessage("\n"+scriptName()+" "+T("|no stud or plate found|"));
//			eraseInstance();
//			return;
//		}
//		// first diagonal
//		Beam bmTop1,bmBottom1;
//		// second diagonal
//		Beam bmTop2,bmBottom2;
//		double dAngle1, dAngle2, dLength2;
//		
//		Beam bmStud1, bmStud2;
//		bmStud1=bmStuds[bmStuds.length()-1];
//		double dDistMin=U(10e5);
//		for (int ib=0;ib<bmStuds.length();ib++) 
//		{ 
//			double dDistI=abs(vecX.dotProduct(pt1-bmStuds[ib].ptCen()));
//			if(dDistI<dDistMin)
//			{ 
//				bmStud1=bmStuds[ib];
//				dDistMin=dDistI;
//			}
//		}//next ib
//		bmStud1.envelopeBody().vis(5);
//		
//		Beam beamsTop[]=Beam().filterBeamsHalfLineIntersectSort(bmHors, bmStud1.ptCen(), vecY);
//		if(beamsTop.length()==0)
//		{ 
//			reportMessage("\n"+scriptName()+" "+T("|unexpected: no top plate|"));
//			eraseInstance();
//			return;
//		}
//		bmTop1=beamsTop[beamsTop.length()-1];
//		bmTop1.envelopeBody().vis(6);
//		Beam beamsBottom[]=Beam().filterBeamsHalfLineIntersectSort(bmHors, bmStud1.ptCen(), -vecY);
//		if(beamsBottom.length()==0)
//		{ 
//			reportMessage("\n"+scriptName()+" "+T("|unexpected: no bottom plate|"));
//			eraseInstance();
//			return;
//		}
//		bmBottom1=beamsBottom[beamsBottom.length()-1];
//		bmBottom1.envelopeBody().vis(6);
//		// get next stud that fulfills the requirements
//		// Length 1800-2700
//		// inclination angle 30-60
//		// try to get the largest length
//		pt1+=vecX*vecX.dotProduct(bmStud1.ptCen()-pt1);
//		_PtG[0]=pt1;
//		vecDir.vis(pt1);
//		
//		int iIntersect=Line(bmStud1.ptCen(),bmStud1.vecX()).hasIntersection(Plane(bmBottom1.ptCen()-bmBottom1.vecD(vecY)*.5*bmBottom1.dD(vecY),vecY),pt1Bottom);
//		_PtG[0] = pt1Bottom;
//		if(!iIntersect)
//		{ 
//			reportMessage("\n"+scriptName()+" "+T("|unexpected: no bracing point|"));
//			eraseInstance();
//			return;
//		}
//		iIntersect=Line(bmStud1.ptCen(),bmStud1.vecX()).hasIntersection(Plane(bmTop1.ptCen()+bmTop1.vecD(vecY)*.5*bmTop1.dD(vecY),vecY),pt1Top);
//		if(!iIntersect)
//		{ 
//			reportMessage("\n"+scriptName()+" "+T("|unexpected: no bracing point|"));
//			eraseInstance();
//			return;
//		}
//		
//		pt1Bottom.vis(6);
//		pt1Top.vis(6);
//		
//		Beam bmStudsDir[] = vecDir.filterBeamsPerpendicularSort(bmStuds);
//		bmStudsDir[0].envelopeBody().vis(2);
//		
//		// get min max bmStud2
//		Point3d pt2MinBottom, pt2MinTop;
//		Point3d pt2MaxBottom, pt2MaxTop;
//		Beam bmStudMin2, bmStudMax2;
//		Beam bmTopMin2, bmTopMax2;
//		Beam bmBottomMin2, bmBottomMax2;
//		// min max found valid angles
//		double dAngle2Min = U(10e5), dAngle2Max = -U(10e5);
//		// min max found valid lengths
//		double dLength2Min = U(10e5), dLength2Max = -U(10e5);
//		//
//		dDistMin = U(10e4);
//		
////		int iBm1 = bmStudsDir.find(bmStud1);
//		int iBracingFound=false;
//		
//		for (int ibm = bmStudsDir.length()-1; ibm >= 0; ibm--)
//		{
//			Beam bmI = bmStudsDir[ibm];
//			Beam bmTopI, bmBottomI;
//			double dLengthI = (vecDir.dotProduct(bmI.ptCen() - pt1));
//			double dDistI = abs(vecDir.dotProduct(bmI.ptCen() - _PtG[1]));
//			
////						if (dDistI > dLMax)
////						{
////							continue;
////						}
////						else
//			{
//				// check the angle
//				Point3d pt2TopI,pt2BottomI;
//				Beam bmTopI, bmBottomI;
//				Beam beamsTopI[] = Beam().filterBeamsHalfLineIntersectSort(bmHors, bmI.ptCen(), vecY);
//				if (beamsTopI.length() == 0)
//				{
//					continue;
//				}
//				bmTopI=beamsTopI[beamsTopI.length()-1];
//				Beam beamsBottomI[] = Beam().filterBeamsHalfLineIntersectSort(bmHors, bmI.ptCen(), - vecY);
//				if (beamsBottomI.length() == 0)
//				{
//					continue;
//				}
//				bmBottomI=beamsBottomI[beamsBottomI.length()-1];
//				
//				//
//				int iIntersect=Line(bmI.ptCen(),bmI.vecX())
//					.hasIntersection(Plane(bmBottomI.ptCen()-bmBottomI.vecD(vecY)*.5*bmBottomI.dD(vecY),vecY),pt2BottomI);
//				if ( !iIntersect)
//				{
//					continue;
//				}
//				iIntersect=Line(bmI.ptCen(),bmI.vecX())
//					.hasIntersection(Plane(bmTopI.ptCen()+bmTopI.vecD(vecY)*.5*bmTopI.dD(vecY),vecY),pt2TopI);
//				if ( !iIntersect)
//				{
//					continue;
//				}
//				
//				Vector3d vec1 = pt2TopI-pt1Bottom;
//				Vector3d vecXangle = vecDir;
//				vec1.normalize();
//				if (vec1.dotProduct(vecDir) < 0)vecXangle *= -1;
//				Vector3d vecRef=vec1.crossProduct(vecXangle);
//				vecRef.normalize();
////				vec1.vis(pt1Bottom);
////				vecXangle.vis(pt1Bottom);
////				vecRef.vis(pt1Bottom);
////							double dAngleI1=vec1.angleTo(vecXangle, vecRef);
//				double dAngleI1=vec1.angleTo(vecXangle);
//				if (dAngleI1 > U(90))dAngleI1 -= U(90);
//				Vector3d vec2=pt1Top-pt2BottomI;
//				vec2.normalize();
//				if(vec2.dotProduct(vecX)<0)vecXangle*=-1;
//				vecRef=vec2.crossProduct(vecXangle);
//				vecRef.normalize();
////							double dAngleI2=vec2.angleTo(vecXangle,vecRef);
//				double dAngleI2=vec2.angleTo(vecXangle);
//				if (dAngleI2 > U(90))dAngleI2 -= U(90);
//				if (dDistI < dDistMin)
//				{
//					// get closest possible beam
//					dDistMin=dDistI;
//					bmStud2=bmI;
//					bmBottom2=bmBottomI;
//					bmTop2=bmTopI;
//					dAngle1=dAngleI1;
//					dAngle2=dAngleI2;
//					dLength2=dLengthI;
//					pt2Bottom=pt2BottomI;
//					pt2Top=pt2TopI;
//				}
//				if (dAngleI1>dAngleMax)
//				{
//					// bracing not possible
////								break;
//				}
//				else if (dAngleI1<dAngleMin)
//				{
////								continue;
//				}
//				// valid bracing
//				if(dAngleI1>=dAngleMin && dAngleI1<=dAngleMax
//				&& dAngleI2>=dAngleMin && dAngleI2<=dAngleMax
//				&& dLengthI>=dLMin && dLengthI<=dLMax)
//				{ 
//					// capture min max valid bracings
//					if(dLengthI<dLength2Min)
//					{ 
//						dLength2Min=dLengthI;
//						bmStudMin2=bmI;
//						dAngle2Min=dAngleI1<dAngleI2?dAngleI1:dAngleI2;
//						pt2MinBottom = pt2BottomI;
//						pt2MinTop = pt2TopI;
//						bmBottomMin2 = bmBottomI;
//						bmTopMin2 = bmTopI;
//					}
//					if(dLengthI>dLength2Max)
//					{ 
//						dLength2Max=dLengthI;
//						bmStudMax2=bmI;
//						dAngle2Max=dAngleI1>dAngleI2?dAngleI1:dAngleI2;
//						pt2MaxBottom = pt2BottomI;
//						pt2MaxTop = pt2TopI;
//						bmBottomMax2= bmBottomI;
//						bmTopMax2 = bmTopI;
//						
//					}
//				}
//				
//			}
//			
//		}
//		
////		for (int ibm=bmStudsDir.length()-1; ibm>=0 ; ibm--) 
////		{ 
////			Beam bmI=bmStudsDir[ibm];
////			Beam bmTopI,bmBottomI;
////			double dDistI = abs(vecX.dotProduct(bmI.ptCen() - pt1));
////			if(dDistI>dLMax)
////			{
////				continue;
////			}
////			else
////			{ 
////				// check the angle
////				Beam bmTopI,bmBottomI;
////				Beam beamsTopI[]=Beam().filterBeamsHalfLineIntersectSort(bmHors, bmI.ptCen(), vecY);
////				if(beamsTopI.length()==0)
////				{ 
////					continue;
////				}
////				bmTopI=beamsTopI[beamsTopI.length()-1];
////				Beam beamsBottomI[]=Beam().filterBeamsHalfLineIntersectSort(bmHors, bmI.ptCen(), -vecY);
////				if(beamsBottomI.length()==0)
////				{ 
////					continue;
////				}
////				bmBottomI=beamsBottomI[beamsBottomI.length()-1];
////				//
////				int iIntersect=Line(bmI.ptCen(),bmI.vecX()).hasIntersection(Plane(bmBottomI.ptCen()-bmBottomI.vecD(vecY)*.5*bmBottomI.dD(vecY),vecY),pt2Bottom);
////				if(!iIntersect)
////				{ 
////					continue;
////				}
////				iIntersect=Line(bmI.ptCen(),bmI.vecX()).hasIntersection(Plane(bmTopI.ptCen()+bmTopI.vecD(vecY)*.5*bmTopI.dD(vecY),vecY),pt2Top);
////				if(!iIntersect)
////				{ 
////					continue;
////				}
////				_PtG[1] = pt2Bottom;
////				pt2Bottom.vis(6);
////				pt2Top.vis(6);
////				// check the angle 
////				Vector3d vec1=pt2Top-pt1Bottom;
////				Vector3d vecXangle = vecX;
////				vec1.normalize();
////				if(vec1.dotProduct(vecX)<0)vecXangle*=-1;
////				Vector3d vecRef = vec1.crossProduct(vecXangle);
////				vecRef.normalize();
////				vec1.vis(pt1Bottom);
////				vecXangle.vis(pt1Bottom);
////				vecRef.vis(pt1Bottom);
//////				double dAngle1=vec1.angleTo(vecXangle,vecRef);
////				double dAngle1=vec1.angleTo(vecXangle);
////				if (dAngle1 > U(90))dAngle1 -= U(90);
////				if(dAngle1>dAngleMax)
////				{ 
////					// not possible
////					reportMessage("\n"+scriptName()+" "+T("|bracing not possible|"));
////					eraseInstance();
////					return;
////				}
////				else if(dAngle1<dAngleMin)
////				{ 
////					continue;
////				}
////				Vector3d vec2=pt1Top-pt2Bottom;
////				vec2.normalize();
////				if(vec2.dotProduct(vecX)<0)vecXangle*=-1;
////				vecRef = vec2.crossProduct(vecXangle);
////				vecRef.normalize();
//////				double dAngle2=vec2.angleTo(vecXangle,vecRef);
////				double dAngle2=vec2.angleTo(vecXangle);
////				if (dAngle2 > U(90))dAngle2 -= U(90);
////				if(dAngle1>dAngleMax)
////				{ 
////					// not possible
////					reportMessage("\n"+scriptName()+" "+T("|bracing not possible|"));
////					eraseInstance();
////					return;
////				}
////				
////				else if(dAngle1<dAngleMin)
////				{ 
////					continue;
////				}
////				
////				bmTop2 = bmTopI;
////				bmBottom2 = bmBottomI;
////				// valid connection
////				iBracingFound=true;
////				break;
////			}
////		}//next ibm
////		
//		if(!iBracingFound)
//		{ 
////			reportMessage("\n"+scriptName()+" "+T("|Bracing not possible|"));
////			eraseInstance();
////			return;
//		}
//		
//		Display dp(3);
//		// first bracing
//		Vector3d vecXbracing=pt2Top-pt1Bottom;
//		vecXbracing.normalize();
//		Vector3d vecYbracing=vecZ.crossProduct(vecXbracing);
//		vecYbracing.normalize();
//		
//		PlaneProfile ppSubtractTop1(el.coordSys());
//		PLine plSubtractTop1;
//		plSubtractTop1.createRectangle(LineSeg(pt1Top-bmTop1.vecX()*U(10e4),
//			pt1Top+bmTop1.vecX()*2*U(10e4)+bmTop1.vecD(vecY)*U(10e3)),bmTop1.vecX(),bmTop1.vecD(vecY));
////		plSubtractTop1.vis(3);
//		ppSubtractTop1.joinRing(plSubtractTop1, _kAdd);
//		
//		PlaneProfile ppSubtractTop2(el.coordSys());
//		PLine plSubtractTop2;
//		plSubtractTop2.createRectangle(LineSeg(pt2Top-bmTop2.vecX()*U(10e4),
//			pt2Top+bmTop1.vecX()*2*U(10e4)+bmTop2.vecD(vecY)*U(10e3)),bmTop2.vecX(),bmTop2.vecD(vecY));
////		plSubtractTop2.vis(3);
//		ppSubtractTop2.joinRing(plSubtractTop1, _kAdd);
//		
//		PlaneProfile ppSubtractBottom1(el.coordSys());
//		PLine plSubtractBottom1;
//		plSubtractBottom1.createRectangle(LineSeg(pt1Bottom-bmBottom1.vecX()*U(10e4),
//			pt1Bottom+bmBottom1.vecX()*2*U(10e4)-bmBottom1.vecD(vecY)*U(10e3)),bmBottom1.vecX(),bmBottom1.vecD(vecY));
////		plSubtractTop1.vis(3);
//		ppSubtractBottom1.joinRing(plSubtractBottom1, _kAdd);
////		ppSubtractBottom1.vis(3);
//		
//		PlaneProfile ppSubtractBottom2(el.coordSys());
//		PLine plSubtractBottom2;
//		plSubtractBottom2.createRectangle(LineSeg(pt2Bottom-bmBottom2.vecX()*U(10e4),
//			pt2Bottom+bmBottom2.vecX()*2*U(10e4)-bmBottom2.vecD(vecY)*U(10e3)),bmBottom2.vecX(),bmBottom2.vecD(vecY));
////		plSubtractTop1.vis(3);
//		ppSubtractBottom2.joinRing(plSubtractBottom2, _kAdd);
////		ppSubtractBottom2.vis(3);
//		
//		
//		PlaneProfile pp1(Plane(pt1Top,vecZ));
//		PLine pl1;
//		pl1.createRectangle(LineSeg(pt1Bottom-vecXbracing*U(100)-vecYbracing*U(15),pt2Top+vecXbracing*U(100)+vecYbracing*U(15)),
//				vecXbracing, vecYbracing);
//		
//		pl1.transformBy(vecZone*.5*eZone0.dH());
//		pl1.vis(1);
//		pp1.joinRing(pl1, _kAdd);
//		pp1.subtractProfile(ppSubtractBottom1);
//		pp1.subtractProfile(ppSubtractTop1);
//		pp1.transformBy(vecZone*.5*eZone0.dH());
////		double ddd = eZone0.dH();
//		pp1.vis(4);
//		PLine pls1[] = pp1.allRings(true, false);
//		pl1 = pls1[0];
//		
//		
//		Body bd1(pl1, vecZone*U(2));
//		bd1.vis(3);
////		pl1.vis(3);
//		// second bracing
//		vecXbracing=pt2Bottom-pt1Top;
//		vecXbracing.normalize();
//		vecYbracing=vecZ.crossProduct(vecXbracing);
//		vecYbracing.normalize();
//		
//		PlaneProfile pp2(Plane(pt1Top,vecZ));
//		PLine pl2;
//		pl2.createRectangle(LineSeg(pt1Top-vecXbracing*U(100)-vecYbracing*U(15),pt2Bottom+vecXbracing*U(100)+vecYbracing*U(15)),
//				vecXbracing, vecYbracing);
////		pl2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
//		pp2.joinRing(pl2, _kAdd);
//		pp2.subtractProfile(ppSubtractBottom2);
//		pp2.subtractProfile(ppSubtractTop2);
//		pp2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
//		PLine pls2[] = pp2.allRings(true, false);
//		pl2 = pls2[0];
//		pl2.vis(3);
//		Body bd2(pl2, vecZone * U(2));
//		bd2.vis(3);
////		dp.draw(pl1);
//		dp.draw(bd1);
//		dp.draw(bd2);
////		dp.draw(pl2);
//	}
//	else if(iStudTie==1)
//	{ 
//		// stud tie is added
//		// find 2 middle spaces that fulfill conditions
//		// and add stud tie at the outter studs
//		// first and second point, bottom and top
//		Point3d pt1Bottom, pt1Top, pt2Bottom, pt2Top;
//		// get the closest stud
//		Point3d pt1=_PtG[0];
//		// 2. point for direction
//		Point3d pt2=_PtG[1];
//		//
//		pt1.vis(3);
//		pt2.vis(3);
//		Vector3d vecDir=vecX*vecX.dotProduct(pt2-pt1);
//		vecDir.normalize();
//		Beam beams[]=el.beam();
//		Beam bmStuds[]=vecX.filterBeamsPerpendicularSort(beams);
//		Beam bmHors[]=vecY.filterBeamsPerpendicular(beams);
//		if(bmStuds.length()==0 || bmHors.length()==0)
//		{ 
//			reportMessage("\n"+scriptName()+" "+T("|no stud or plate found|"));
//			eraseInstance();
//			return;
//		}
//		// first diagonal
//		Beam bmTop1,bmBottom1;
//		// second diagonal
//		Beam bmTop2,bmBottom2;
//		
//		// 2 beams on one side
//		Beam bmStud11, bmStud12;
//		// 2 beams on the other side
//		Beam bmStud21,bmStud22;
//		
//		// get bmStud11
//		bmStud11=bmStuds[bmStuds.length()-1];
//		double dDistMin=U(10e5);
//		for (int ib=0;ib<bmStuds.length();ib++) 
//		{ 
//			double dDistI=abs(vecX.dotProduct(pt1-bmStuds[ib].ptCen()));
//			if(dDistI<dDistMin)
//			{ 
//				bmStud11=bmStuds[ib];
//				dDistMin=dDistI;
//			}
//		}//next ib
//		bmStud11.envelopeBody().vis(5);
//		// get bmStud12
//		dDistMin=U(10e5);
//		for (int ib=0;ib<bmStuds.length();ib++) 
//		{ 
//			if(bmStuds[ib]==bmStud11)continue;
//			double dDistI=abs(vecX.dotProduct(pt1-bmStuds[ib].ptCen()));
//			if(dDistI<dDistMin)
//			{ 
//				bmStud12=bmStuds[ib];
//				dDistMin=dDistI;
//			}
//		}//next ib
//		bmStud12.envelopeBody().vis(5);
//		
//		Point3d ptMiddle12=.5*(bmStud11.ptCen()+bmStud12.ptCen());
//		ptMiddle12.vis(4);
//		
//		Beam beamsTop[]=Beam().filterBeamsHalfLineIntersectSort(bmHors, ptMiddle12, vecY);
//		if(beamsTop.length()==0)
//		{ 
//			reportMessage("\n"+scriptName()+" "+T("|unexpected: no top plate|"));
//			eraseInstance();
//			return;
//		}
//		bmTop1=beamsTop[beamsTop.length()-1];
//		Beam beamsBottom[]=Beam().filterBeamsHalfLineIntersectSort(bmHors, ptMiddle12, -vecY);
//		if(beamsBottom.length()==0)
//		{ 
//			reportMessage("\n"+scriptName()+" "+T("|unexpected: no bottom plate|"));
//			eraseInstance();
//			return;
//		}
//		bmBottom1=beamsBottom[beamsBottom.length()-1];
//		pt1+=vecX*vecX.dotProduct(ptMiddle12-pt1);
//		_PtG[0]=pt1;
//		vecDir.vis(pt1);
//		
//		if(vecDir.dotProduct(bmStud12.ptCen()-bmStud11.ptCen())<0)
//		{ 
//			Beam bmStud11_ = bmStud11;
//			bmStud11=bmStud12;
//			bmStud12=bmStud11_;
//		}
//		
//		int iIntersect=Line(ptMiddle12,vecY).hasIntersection(Plane(bmBottom1.ptCen()-bmBottom1.vecD(vecY)*.5*bmBottom1.dD(vecY),vecY),pt1Bottom);
//		_PtG[0] = pt1Bottom;
//		if(!iIntersect)
//		{ 
//			reportMessage("\n"+scriptName()+" "+T("|unexpected: no bracing point|"));
//			eraseInstance();
//			return;
//		}
////		pt1Bottom.vis(2);
//		iIntersect=Line(ptMiddle12,vecY).hasIntersection(Plane(bmTop1.ptCen()+bmTop1.vecD(vecY)*.5*bmTop1.dD(vecY),vecY),pt1Top);
//		if(!iIntersect)
//		{ 
//			reportMessage("\n"+scriptName()+" "+T("|unexpected: no bracing point|"));
//			eraseInstance();
//			return;
//		}
////		pt1Bottom.vis(6);
////		pt1Top.vis(6);
//		
//		Beam bmStudsDir[] = vecDir.filterBeamsPerpendicularSort(bmStuds);
////		int iBm1 = bmStudsDir.find(bmStud1);
//		int iBracingFound=false;
//		for (int ibm=bmStudsDir.length()-1; ibm>=1 ; ibm--) 
//		{ 
//			Beam bmI=bmStudsDir[ibm];
//			Beam bmI1=bmStudsDir[ibm-1];
//			Beam bmTopI,bmBottomI;
//			
//			Point3d ptMiddle12I=.5*(bmI.ptCen()+bmI1.ptCen());
//			
//			double dDistI = abs(vecX.dotProduct(ptMiddle12I - pt1));
//			if(dDistI>dLMax)
//			{
//				continue;
//			}
//			else
//			{ 
//				// check the angle
//				Beam bmTopI,bmBottomI;
//				Beam beamsTopI[]=Beam().filterBeamsHalfLineIntersectSort(bmHors,ptMiddle12I,vecY);
//				if(beamsTopI.length()==0)
//				{ 
//					continue;
//				}
//				bmTopI=beamsTopI[beamsTopI.length()-1];
//				Beam beamsBottomI[]=Beam().filterBeamsHalfLineIntersectSort(bmHors,ptMiddle12I,-vecY);
//				if(beamsBottomI.length()==0)
//				{ 
//					continue;
//				}
//				bmBottomI=beamsBottomI[beamsBottomI.length()-1];
//				//
//				int iIntersect=Line(ptMiddle12I,vecY).hasIntersection(Plane(bmBottomI.ptCen()-bmBottomI.vecD(vecY)*.5*bmBottomI.dD(vecY),vecY),pt2Bottom);
//				if(!iIntersect)
//				{ 
//					continue;
//				}
//				iIntersect=Line(ptMiddle12I,vecY).hasIntersection(Plane(bmTopI.ptCen()+bmTopI.vecD(vecY)*.5*bmTopI.dD(vecY),vecY),pt2Top);
//				if(!iIntersect)
//				{ 
//					continue;
//				}
//				_PtG[1] = pt2Bottom;
//				pt2Bottom.vis(6);
//				pt2Top.vis(6);
//				// check the angle 
//				Vector3d vec1=pt2Top-pt1Bottom;
//				Vector3d vecXangle = vecX;
//				vec1.normalize();
//				if(vec1.dotProduct(vecX)<0)vecXangle*=-1;
//				Vector3d vecRef = vec1.crossProduct(vecXangle);
//				vecRef.normalize();
////				double dAngle1=vec1.angleTo(vecXangle,vecRef);
//				double dAngle1=vec1.angleTo(vecXangle);
//				if (dAngle1 > U(90))dAngle1 -= U(90);
//				if(dAngle1>dAngleMax)
//				{ 
//					// not possible
//					reportMessage("\n"+scriptName()+" "+T("|bracing not possible|"));
//					eraseInstance();
//					return;
//				}
//				else if(dAngle1<dAngleMin)
//				{ 
//					continue;
//				}
//				Vector3d vec2=pt1Top-pt2Bottom;
//				vec2.normalize();
//				if(vec2.dotProduct(vecX)<0)vecXangle*=-1;
//				vecRef = vec2.crossProduct(vecXangle);
//				vecRef.normalize();
//				double dAngle2=vec2.angleTo(vecXangle,vecRef);
//				if(dAngle1>dAngleMax)
//				{ 
//					// not possible
//					reportMessage("\n"+scriptName()+" "+T("|bracing not possible|"));
//					eraseInstance();
//					return;
//				}
//				
//				else if(dAngle1<dAngleMin)
//				{ 
//					continue;
//				}
//				
//				bmTop2 = bmTopI;
//				bmBottom2 = bmBottomI;
//				bmStud21=bmI1;
//				bmStud22=bmI;
//				// valid connection
//				iBracingFound=true;
//				break;
//			}
//		}//next ibm
//		
//		if(!iBracingFound)
//		{ 
//			reportMessage("\n"+scriptName()+" "+T("|Bracing not possible|"));
//			eraseInstance();
//			return;
//		}
//		
//		Display dp(3);
//		// first bracing
//		Vector3d vecXbracing=pt2Top-pt1Bottom;
//		vecXbracing.normalize();
//		Vector3d vecYbracing=vecZ.crossProduct(vecXbracing);
//		vecYbracing.normalize();
//		
//		PlaneProfile ppSubtractTop1(el.coordSys());
//		PLine plSubtractTop1;
//		plSubtractTop1.createRectangle(LineSeg(pt1Top-bmTop1.vecX()*U(10e4),
//			pt1Top+bmTop1.vecX()*2*U(10e4)+bmTop1.vecD(vecY)*U(10e3)),bmTop1.vecX(),bmTop1.vecD(vecY));
////		plSubtractTop1.vis(3);
//		ppSubtractTop1.joinRing(plSubtractTop1, _kAdd);
//		
//		PlaneProfile ppSubtractTop2(el.coordSys());
//		PLine plSubtractTop2;
//		plSubtractTop2.createRectangle(LineSeg(pt2Top-bmTop2.vecX()*U(10e4),
//			pt2Top+bmTop1.vecX()*2*U(10e4)+bmTop2.vecD(vecY)*U(10e3)),bmTop2.vecX(),bmTop2.vecD(vecY));
////		plSubtractTop2.vis(3);
//		ppSubtractTop2.joinRing(plSubtractTop1, _kAdd);
//		
//		PlaneProfile ppSubtractBottom1(el.coordSys());
//		PLine plSubtractBottom1;
//		plSubtractBottom1.createRectangle(LineSeg(pt1Bottom-bmBottom1.vecX()*U(10e4),
//			pt1Bottom+bmBottom1.vecX()*2*U(10e4)-bmBottom1.vecD(vecY)*U(10e3)),bmBottom1.vecX(),bmBottom1.vecD(vecY));
////		plSubtractTop1.vis(3);
//		ppSubtractBottom1.joinRing(plSubtractBottom1, _kAdd);
////		ppSubtractBottom1.vis(3);
//		
//		PlaneProfile ppSubtractBottom2(el.coordSys());
//		PLine plSubtractBottom2;
//		plSubtractBottom2.createRectangle(LineSeg(pt2Bottom-bmBottom2.vecX()*U(10e4),
//			pt2Bottom+bmBottom2.vecX()*2*U(10e4)-bmBottom2.vecD(vecY)*U(10e3)),bmBottom2.vecX(),bmBottom2.vecD(vecY));
////		plSubtractTop1.vis(3);
//		ppSubtractBottom2.joinRing(plSubtractBottom2, _kAdd);
////		ppSubtractBottom2.vis(3);
//
//		PlaneProfile pp1(Plane(pt1Top,vecZ));
//		PLine pl1;
//		pl1.createRectangle(LineSeg(pt1Bottom-vecXbracing*U(100)-vecYbracing*U(15),pt2Top+vecXbracing*U(100)+vecYbracing*U(15)),
//				vecXbracing, vecYbracing);
//		
//		pl1.transformBy(vecZone*.5*eZone0.dH());
////		pl1.vis(1);
//		pp1.joinRing(pl1, _kAdd);
//		pp1.subtractProfile(ppSubtractBottom1);
//		pp1.subtractProfile(ppSubtractTop1);
//		pp1.transformBy(vecZone*.5*eZone0.dH());
////		double ddd = eZone0.dH();
//		pp1.vis(4);
//		PLine pls1[] = pp1.allRings(true, false);
//		pl1 = pls1[0];
//		
//		
//		Body bd1(pl1, vecZone*U(2));
//		bd1.vis(3);
//		// second bracing
//		vecXbracing=pt2Bottom-pt1Top;
//		vecXbracing.normalize();
//		vecYbracing=vecZ.crossProduct(vecXbracing);
//		vecYbracing.normalize();
//		
//		PlaneProfile pp2(Plane(pt1Top,vecZ));
//		PLine pl2;
//		pl2.createRectangle(LineSeg(pt1Top-vecXbracing*U(100)-vecYbracing*U(15),pt2Bottom+vecXbracing*U(100)+vecYbracing*U(15)),
//				vecXbracing, vecYbracing);
////		pl2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
//		pp2.joinRing(pl2, _kAdd);
//		pp2.subtractProfile(ppSubtractBottom2);
//		pp2.subtractProfile(ppSubtractTop2);
//		pp2.transformBy(vecZone*(.5*eZone0.dH()+U(2)));
//		PLine pls2[] = pp2.allRings(true, false);
//		pl2 = pls2[0];
//		pl2.vis(3);
//		Body bd2(pl2, vecZone * U(2));
//		bd2.vis(3);
////		dp.draw(pl1);
//		dp.draw(bd1);
//		dp.draw(bd2);
//		
//		// add stud tie
//	// create TSL
//		TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
//		GenBeam gbsTsl[2]; Entity entsTsl[1]; Point3d ptsTsl[] = {_Pt0};
//		int nProps[]={}; double dProps[]={}; String sProps[]={T("<|Disabled|>"),T("<|Disabled|>"),T("|Left|"),sZone};
//		Map mapTsl;
//		mapTsl.setInt("mode", 1);
//		entsTsl[0] = el;
//		
//		Beam bmMales[] ={ bmStud12, bmStud12, bmStud21, bmStud21};
//		Beam bmFemales[] ={ bmTop1, bmBottom1, bmTop2, bmBottom2};
//		String sKeys[] ={ "tslLeftTop", "tslLeftBottom", "tslRightTop", "tslRightBottom" };
//		// left beam top
//		for (int itsl=0;itsl<bmMales.length();itsl++) 
//		{ 
//			Beam bmMale = bmMales[itsl]; 
//			Beam bmFemale = bmFemales[itsl]; 
//			Entity ent = _Map.getEntity(sKeys[itsl]);
//			TslInst tsl = (TslInst)ent;
//			if(!tsl.bIsValid())
//			{ 
//				gbsTsl[0]=bmMale;
//				gbsTsl[1]=bmFemale;
//
//				tslNew.dbCreate("hsbStudTie" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
//					ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
//				_Map.setEntity(sKeys[itsl], tslNew);
//			}
//		}//next itsl
//	}

}
else if(iType==1)
{ 
	// sheet
	if(_PtG.length()!=2)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|2 points needed for the definition of bracing|"));
		eraseInstance();
		return;
	}

	if(mapModel.hasDouble("Width"))
		dWidthSheet=mapModel.getDouble("Width");
	if(mapModel.hasDouble("Height"))
		dHeightSheet=mapModel.getDouble("Height");
	if(mapModel.hasDouble("Thickness"))
		dThicknessSheet=mapModel.getDouble("Thickness");	
	Display dp(3), dpWarning(40);
	dp.showInDxa(true);
	Point3d pt1Bottom, pt1Top, pt2Bottom, pt2Top;
	
	Point3d pt1=_PtG[0];
		// 2. point for direction
	Point3d pt2=_PtG[1];
	
	// get ppsheet
	Point3d ptSheet = ptOrg;
	Vector3d vecZsheet = vecZ;
	Vector3d vecYsheet = vecY;
	Vector3d vecXsheet = vecY.crossProduct(vecZ);
	vecXsheet.normalize();
	if(nZone==-1)
	{ 
		ptSheet = ptSheet - el.vecZ() * el.zone(0).dH();
		vecZsheet *= -1;
		vecXsheet *= -1;
	}
	CoordSys csSheet(ptSheet,vecXsheet,vecYsheet,vecZsheet);
	PlaneProfile ppSheet(csSheet);
	ppSheet.joinRing(el.plEnvelope(), _kAdd);
//	ppSheet.transformBy(vecZ * U(300));
	ppSheet.vis(1);
	
	Vector3d vecDir = vecX * vecX.dotProduct(pt2 - pt1);
	vecDir.normalize();
	Beam beams[] = el.beam();
	Beam bmStuds[] = vecX.filterBeamsPerpendicularSort(beams);
	Beam bmHors[] = vecY.filterBeamsPerpendicular(beams);
	Beam bmStud1, bmStud2;
	Beam bmStud12,bmStud21;
	bmStud1=bmStuds[bmStuds.length()-1];
	double dDistMin=U(10e5);
	for (int ib=0;ib<bmStuds.length();ib++) 
	{ 
		double dDistI=abs(vecX.dotProduct(pt1-bmStuds[ib].ptCen()));
		if(dDistI<dDistMin)
		{ 
			bmStud1=bmStuds[ib];
			dDistMin=dDistI;
		}
	}//next ib
	Point3d ptLook = bmStud1.ptCen();
	if(bmStuds.find(bmStud1)==0)
	{ 
		ptLook-=vecDir*.5*bmStud1.dD(vecDir);
	}
	// get the most bottom point of ppSheet
	Point3d ptBottomMax, ptTopMax;
	{ 
		// get extents of profile
		LineSeg seg = ppSheet.extentInDir(vecX);
		ptBottomMax = vecY.dotProduct(seg.ptStart()-seg.ptEnd())<0?seg.ptStart():seg.ptEnd();
		ptTopMax = vecY.dotProduct(seg.ptStart()-seg.ptEnd())>0?seg.ptStart():seg.ptEnd();
	}
//	pt1Bottom=Line(bmStud1.ptCen(),vecY).intersect(Plane(ptBottomMax,vecY),U(0));
	pt1Bottom=Line(ptLook,vecY).intersect(Plane(ptBottomMax,vecY),U(0));
	
	PLine plRec12;
	plRec12.createRectangle(LineSeg(pt1,pt2),vecX,vecY);
	PlaneProfile ppRec12(ppSheet.coordSys());
	ppRec12.joinRing(plRec12, _kAdd);
	int iCreate;
	if (ppRec12.intersectWith(ppSheet))iCreate = true;
	if(iCreate)
	{ 
		// draw sheets
		Point3d ptStartCol=pt1Bottom,ptStartRow=pt1Bottom;
		PlaneProfile ppSheetsCreated[0];
		int iFullSheet[0];
		ptStartCol.vis(1);
		ptStartRow.vis(1);
	//	return;
		for (int icol=0;icol<200;icol++) 
		{ 
	//		if(vecDir.dotProduct(pt2-ptStartCol)<dWidthSheet)
			if(vecDir.dotProduct(pt2-ptStartCol)<0)
			{ 
				// break colums
				break;
			}
			// add sheets
			for (int irow=0;irow<200;irow++) 
			{ 
	//			if(vecY.dotProduct(pt2-ptStartRow)<dHeightSheet)
				if(vecY.dotProduct(pt2-ptStartRow)<0)
				{ 
					ptStartRow=pt1Bottom;
					ptStartCol+=vecDir*dWidthSheet;
	//								continue;
	//								break;
				}
	//			if(vecDir.dotProduct(pt2-ptStartCol)<dWidthSheet)
				if(vecDir.dotProduct(pt2-ptStartCol)<0)
				{ 
					// break colums
					break;
				}
				// add sheet
				PlaneProfile ppSheetNew(ppSheet.coordSys());
				PLine plSheetNew;
				Point3d ptI = ptStartRow;
				ptI += vecX * vecX.dotProduct(ptStartCol - ptI);
				ptI.vis(2);
				plSheetNew.createRectangle(LineSeg(ptI, 
					ptI+vecDir*dWidthSheet+vecY*dHeightSheet),vecDir,vecY);
				ppSheetNew.joinRing(plSheetNew,_kAdd);
	//							dpjig.draw("V", ptI, vecX, vecY, 0, 0, _kDeviceX);
	//							dpjig.draw(ppSheetNew,_kDrawFilled);
				// get intersection with ppSheet
				PlaneProfile ppSheetIntersect=ppSheetNew;
				int iIntersect=ppSheetIntersect.intersectWith(ppSheet);
				PlaneProfile ppSubtract=ppSheetNew;
				ppSubtract.subtractProfile(ppSheet);
				
				if(ppSubtract.area()<pow(dEps,2) && ppSheetIntersect.area()>pow(dEps,2))
				{
					// intersects but not all inside
					ptStartRow+=vecY*dHeightSheet;
					ppSheetsCreated.append(ppSheetIntersect);
					ppSheetIntersect.vis(6);
					iFullSheet.append(true);
				}
				else if(ppSubtract.area()>pow(dEps,2) && ppSheetIntersect.area()>pow(dEps,2))
				{ 
					
					ppSheetsCreated.append(ppSheetIntersect);
					iFullSheet.append(false);
					ptStartRow+=vecY*dHeightSheet;
					
					
	//				PlaneProfile ppTop(ppSheet.coordSys());
	//				PLine plTop;
	//				plTop.createRectangle(LineSeg(ptI + vecY * dHeightSheet, ptI + vecY * (dHeightSheet + U(50)) + vecDir * dWidthSheet),vecDir,vecY);
	//				ppTop.joinRing(plTop,_kAdd);
	//				ppTop.vis(4);
	//				PlaneProfile ppRight(ppSheet.coordSys());
	//				PLine plRight;
	//				plRight.createRectangle(LineSeg(ptI+vecDir*dWidthSheet, ptI+vecY*dHeightSheet+vecDir*(dWidthSheet+U(50))),vecDir,vecY);
	//				ppRight.joinRing(plRight,_kAdd);
	//				ppRight.vis(4);
	//				if(ppTop.intersectWith(ppSheet))
	//				{ 
	//					ptStartRow+=vecY*dHeightSheet;
	//					ppSheetsCreated.append(ppSheetIntersect);
	//					ppSheetIntersect.vis(6);
	//					
	//					iFullSheet.append(false);
	//				}
	//				else if(ppRight.intersectWith(ppSheet))
	//				{
	//					ptStartRow = pt1Bottom;
	//					ptStartCol += vecDir * dWidthSheet;
	//					ppSheetsCreated.append(ppSheetIntersect);
	//					iFullSheet.append(false);
	//				}
				}
				else if(ppSheetIntersect.area()<pow(dEps,2))
				{ 
					ptStartRow=pt1Bottom;
					ptStartCol+=vecDir*dWidthSheet;
	//				break;
				}
				else
				{ 
					// no intersection, increment col
					ptStartRow=pt1Bottom;
					ptStartCol+=vecDir*dWidthSheet;
				}
			}//next irow
		}//next icol
		for (int ip=0;ip<ppSheetsCreated.length();ip++) 
		{ 
			if(iFullSheet[ip])
			{
				ppSheetsCreated[ip].vis(3);
				dp.draw(ppSheetsCreated[ip]);
			}
			else
			{
				ppSheetsCreated[ip].vis(40);
				dpWarning.draw(ppSheetsCreated[ip]);
			}
			Sheet shNew;
			shNew.dbCreate(ppSheetsCreated[ip], dThicknessSheet,1);
			shNew.assignToElementGroup(el, TRUE, nZone, 'Z');
			shNew.setColor(1);
		}//next ip
	}
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
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="4720" />
        <int nm="BreakPoint" vl="4721" />
        <int nm="BreakPoint" vl="4712" />
        <int nm="BreakPoint" vl="4774" />
        <int nm="BreakPoint" vl="4779" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18650 standard display published for share and make" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="5/10/2023 12:58:18 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-9044: Support side/zone changing on jig modus" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="3/31/2022 6:36:07 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-9044: Support gable walls" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="3/31/2022 1:29:56 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-9044: Implement for sheeting" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="3/28/2022 4:49:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-9044: Fix angle calculation on jig mode" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="3/28/2022 8:48:51 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-9044: initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="3/7/2022 4:08:10 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End