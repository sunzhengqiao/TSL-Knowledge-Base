#Version 8
#BeginDescription
#Versions:
1.3 09.06.2022 HSB-15668: Add secondary grid, and its properties 
1.2 08.06.2022 HSB-15668: Outter contour defined by the underlying "Raum" instances 
1.1 08.06.2022 HSB-15668: Add commands to Add/delete points 
1.0 07.06.2022 HSB-15668: initial 


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords Rubner;Gefälledämmung;Insulation;Gradient;Leveling;Stellfüße
#BeginContents
//region <History>
// #Versions
// 1.3 09.06.2022 HSB-15668: Add secondary grid, and its properties Author: Marsel Nakuci
// 1.2 08.06.2022 HSB-15668: Outter contour defined by the underlying "RUB-Raum" instances Author: Marsel Nakuci
// 1.1 08.06.2022 HSB-15668: Add commands to Add/delete points Author: Marsel Nakuci
// 1.0 07.06.2022 HSB-15668: initial Author: Marsel Nakuci

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl creates 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "AdjustableSupport")) TSLCONTENT
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
	String sFileName ="AdjustableSupport";
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

//region Properties
	category="Boden";
	String sLevelName="Gesamte Dicke";	
	PropDouble dLevel(nDoubleIndex++, U(300), sLevelName);	
	dLevel.setDescription(T("|Defines the Level|"));
	dLevel.setCategory(category);
	
	String sThicknessTopName=T("|Thickness|")+" Boden";	
	PropDouble dThicknessTop(nDoubleIndex++, U(20), sThicknessTopName);	
	dThicknessTop.setDescription(T("|Defines the Thickness for the Top Insulation|"));
	dThicknessTop.setCategory(category);
	
	category="Hauptraster";
// grid space X
	String sGridXName="AbstandX 1";
	PropDouble dGridX(nDoubleIndex++, U(600), sGridXName);
	dGridX.setDescription(T("|Defines the space X for the main grid|"));
	dGridX.setCategory(category);
// grid space Y
	String sGridYName="AbstandY 1";
	PropDouble dGridY(nDoubleIndex++, U(600), sGridYName);
	dGridY.setDescription(T("|Defines the space Y for the main grid|"));
	dGridY.setCategory(category);
// grid offset X
	String sOffsetXName=T("|Offset|")+"X 1";	
	PropDouble dOffsetX(nDoubleIndex++, U(0), sOffsetXName);
	dOffsetX.setDescription(T("|Defines the Offset X for the main grid|"));
	dOffsetX.setCategory(category);
// grid offset Y
	String sOffsetYName=T("|Offset|")+"Y 1";	
	PropDouble dOffsetY(nDoubleIndex++, U(0), sOffsetYName);
	dOffsetY.setDescription(T("|Defines the Offset Y for the main grid|"));
	dOffsetY.setCategory(category);
	
	category="Hilfsraster";
	String sGridXhelpName="AbstandX 2";
	PropDouble dGridXhelp(nDoubleIndex++, U(300), sGridXhelpName);	
	dGridXhelp.setDescription(T("|Defines the space X for the helping grid|"));
	dGridXhelp.setCategory(category);
	
	String sGridYhelpName="AbstandY 2";	
	PropDouble dGridYhelp(nDoubleIndex++, U(300), sGridYhelpName);	
	dGridYhelp.setDescription(T("|Defines the space Y for the helping grid|"));
	dGridYhelp.setCategory(category);
	
	String sOffsetXhelpName=T("|Offset|")+"X 2";
	PropDouble dOffsetXhelp(nDoubleIndex++, U(0), sOffsetXhelpName);	
	dOffsetXhelp.setDescription(T("|Defines the Offset X for the helping grid|"));
	dOffsetXhelp.setCategory(category);
	
	String sOffsetYhelpName=T("|Offset|")+"Y 2";
	PropDouble dOffsetYhelp(nDoubleIndex++, U(0), sOffsetYhelpName);
	dOffsetYhelp.setDescription(T("|Defines the Offset Y for the helping grid|"));
	dOffsetYhelp.setCategory(category);
	
	String sDisplayGridHelpName="Sichtbarkeit";	
	PropString sDisplayGridHelp(nStringIndex++, sNoYes, sDisplayGridHelpName);	
	sDisplayGridHelp.setDescription(T("|Defines the visibility of helping grid|"));
	sDisplayGridHelp.setCategory(category);
	
	String sFootCreateHelpName="Stellfuß";	
	PropString sFootCreateHelp(nStringIndex++, sNoYes, sFootCreateHelpName);	
	sFootCreateHelp.setDescription(T("|Defines the whether the foot will be created at helping grid or not|"));
	sFootCreateHelp.setCategory(category);
	
// seal thickness
	category="Boden";
	String sThicknessSealName="Stärke Abdichtung";	
	PropDouble dThicknessSeal(nDoubleIndex++, U(10), sThicknessSealName);
	dThicknessSeal.setDescription(T("|Defines the Thickness of Seal|"));
	dThicknessSeal.setCategory(category);
	
	category = "Darstellung AdjustableSupport";
	String sSymbolFootName=T("|Symbol|");	
	PropString sSymbolFoot(nStringIndex++, sNoYes, sSymbolFootName);
	sSymbolFoot.setDescription(T("|Defines the Symboll for the adjastable Foot|"));
	sSymbolFoot.setCategory(category);
	
	String sTextFootName=T("|Text|");
	PropString sTextFoot(nStringIndex++, sNoYes, sTextFootName);
	sTextFoot.setDescription(T("|Defines the Text|"));
	sTextFoot.setCategory(category);
//End Properties//endregion
	
//region jigs
	String strJigAction1 = "strJigAction1";
	if (_bOnJig && _kExecuteKey == strJigAction1)
	{ 
		Vector3d vecView = getViewDirection();
		Display dpjig(1);
		PLine pl = _Map.getPLine("pl");
		Plane pn(pl.coordSys().ptOrg(), pl.coordSys().vecZ());
		
		Point3d ptJig = _Map.getPoint3d("_PtJig"); 
		
		Point3d ptIntersect;
		int iIntersect=Line(ptJig, vecView).hasIntersection(pn,ptIntersect);
		
		if(iIntersect)
			ptJig = ptIntersect;
//		ptJig = Line(ptJig, vecView).intersect(pn, U(0));
		
		PlaneProfile ppPl(pl.coordSys());
		ppPl.joinRing(pl,_kAdd);
		
		// create grid
		
		if(ppPl.pointInProfile(ptJig)==_kPointOutsideProfile || !iIntersect)
		{ 
//			dpjig.draw(ppPl, _kDrawFilled);
//			return;
			// take the closest vertexpoint
			Point3d pts[] = pl.vertexPoints(true);
			if(pts.length()==0)
			{ 
				reportMessage("\n"+scriptName()+" "+T("|Unexpected: No vertex points|"));
				eraseInstance();
				return;
			}
			Point3d ptClosest = pts[0];
			double dClosest=(ptClosest-ptJig).length();
			for (int ipt=0;ipt<pts.length();ipt++)
			{ 
				if((pts[ipt]-ptJig).length()<dClosest)
				{ 
					dClosest=(pts[ipt]-ptJig).length();
					ptClosest=pts[ipt];
				}
			}//next ipt
			
			ptJig = ptClosest;
		}
		
		PLine plCirc;
		plCirc.createCircle(ptJig, _ZW, U(50));
		PlaneProfile ppCirc(pn);
		ppCirc.joinRing(plCirc, _kAdd);
		Display dpPoint(6);
		dpPoint.draw(ppCirc,_kDrawFilled);
		dpPoint.draw(plCirc);
		
		LineSeg lSegs[0];
		Vector3d vecDirs[]={_XW,-_XW,_YW,-_YW };
		Vector3d vecNormals[]={_YW,_YW,_XW,_XW };
		double dGrids[]={ dGridX,dGridX,dGridY,dGridY};
		double dOffsets[]={ dOffsetX,dOffsetX,dOffsetY,dOffsetY};
		
//		for (int iDir=0;iDir<vecDirs.length();iDir++) 
//		{
//			Vector3d vecDir = vecDirs[iDir]; 
//			Vector3d vecNormal = vecNormals[iDir]; 
//			int iContinue=true;
//			int iStep = 0;
//			while(iContinue)
//			{ 
//				//
//				Point3d ptI=ptJig+iStep*dGrids[iDir]*vecDir;
//				ptI.transformBy(_XW*dOffsetX);
//				ptI.transformBy(_YW*dOffsetY);
//				Line lnI(ptI, vecNormal);
//				
//				Point3d ptsI[] = pl.intersectPoints(lnI);
//				if(iDir==1 || iDir==3)
//				{ 
//					if (iStep == 0)
//					{
//						iStep++;
//						continue;
//					}
//				}
//				
//				LineSeg lSegsI[0];
//				for (int ipt=0;ipt<ptsI.length()-1;ipt++) 
//				{ 
//					//
//					Point3d pt1=ptsI[ipt];
//					Point3d pt2=ptsI[ipt+1];
//					Point3d ptMid=.5*(pt1+pt2);
//					if(ppPl.pointInProfile(ptMid)==_kPointInProfile)
//					{ 
//						lSegsI.append(LineSeg(pt1, pt2));
//					}
//				}//next ipt
//				
//				lSegs.append(lSegsI);
//				if(ptsI.length()==0)
//				{
//					iContinue = false;
//					continue;
//				}
//				
//				iStep++;
//				if(iStep>200)
//				{ 
//					iContinue = false;
//				}
//			}//next iDir
//		}
//		
		
		for (int iDir=0;iDir<vecDirs.length();iDir++) 
		{
			// moving vector
			Vector3d vecDir = vecDirs[iDir]; 
			// line vector
			Vector3d vecNormal = vecNormals[iDir]; 
			int iContinue=true;
			int iStep = 0;
			// to remember for this dir
			LineSeg lSegsDir[0];
			int iStepsDir=abs(dOffsets[iDir])/dGrids[iDir];
			iStepsDir += 2;
			while(iContinue)
			{ 
				//
				Point3d ptI=ptJig+iStep*dGrids[iDir]*vecDir;
				ptI.transformBy(_XW*dOffsetX);
				ptI.transformBy(_YW*dOffsetY);
				Line lnI(ptI, vecNormal);
				
				Point3d ptsI[] = pl.intersectPoints(lnI);
				if(iDir==1 || iDir==3)
				{ 
					if (iStep == 0)
					{
						iStep++;
						continue;
					}
				}
				
				LineSeg lSegsI[0];
				for (int ipt=0;ipt<ptsI.length()-1;ipt++) 
				{ 
					//
					Point3d pt1=ptsI[ipt];
					Point3d pt2=ptsI[ipt+1];
					Point3d ptMid=.5*(pt1+pt2);
					if(ppPl.pointInProfile(ptMid)==_kPointInProfile)
					{ 
						lSegsI.append(LineSeg(pt1, pt2));
						// points of segments with outter contours
//						ptsAll.append(pt1);
//						ptsAll.append(pt2);
						
					}
				}//next ipt
				
				lSegs.append(lSegsI);
				lSegsDir.append(lSegsI);
//				if(iDir<2)
//				{ 
//					lSegsY.append(lSegsI);
//				}
//				else if(iDir>=2)
//				{ 
//					lSegsX.append(lSegsI);
//				}
				if(lSegsDir.length()>0)
				{ 
					// some segments are already drawn for this direction
					if(ptsI.length()==0)
					{
						iContinue = false;
						continue;
					}
				}
				else if(lSegsDir.length()==0)
				{ 
					// try some iterations
					if(iStep>iStepsDir && ptsI.length()==0)
					{ 
		//				reportMessage("\n"+scriptName()+" "+T("|Unexpected: no gridline|"));
						// point was outside the border, no grid in this direction
						iContinue = false;
						continue;
					}
				}
				
				iStep++;
				if(iStep>200)
				{ 
					iContinue = false;
				}
			}//next iDir
		}

		
		for (int iseg=0;iseg<lSegs.length();iseg++) 
		{ 
			LineSeg lSegI=lSegs[iseg];
			Point3d pt1 = lSegI.ptStart();
			Point3d pt2 = lSegI.ptEnd();
			PLine plI;
			plI.addVertex(pt1);
			plI.addVertex(pt2);
			
			dpjig.draw(plI);
		}//next iseg
		
		// draw text
//		dpjig.draw("X", ptJig, _XW, _YW, 0, 0, _kDeviceX);
		
		return;
	}
	
	String strJigAction2 = "strJigAction2";
	if (_bOnJig && _kExecuteKey == strJigAction2)
	{ 
		Vector3d vecView = getViewDirection();
		Display dpJig(1);
		dpJig.textHeight(U(40));
		
		int insertionMode=_Map.getInt("InsertionMode");
		Point3d ptLevel=_Map.getPoint3d("ptLevel");
		Point3d ptsAll[]=_Map.getPoint3dArray("ptsAll");
		Point3d ptsAdded[]=_Map.getPoint3dArray("ptsAdded");
		Point3d ptsDeleted[]=_Map.getPoint3dArray("ptsDeleted");
		PLine pl=_Map.getPLine("pl");
		
		// get valid points and newly inserted points
		Plane pn(ptLevel, _ZW);
		PlaneProfile ppPl(pn);
		ppPl.joinRing(pl,_kAdd);
		// draw text
		Point3d ptJig = _Map.getPoint3d("_PtJig"); 
		ptJig = Line(ptJig, vecView).intersect(pn, U(0));
		
		if(insertionMode==0)
		{ 
			// delete modus
			dpJig.color(1);
			
			Point3d ptSelected;
			double dDistMin = 10e10;
			int iSelected = -1;
			for (int ipt=0;ipt<ptsAll.length();ipt++) 
			{ 
				if((ptsAll[ipt]-ptJig).length()<dDistMin)
				{ 
					ptSelected = ptsAll[ipt];
					dDistMin=(ptsAll[ipt]-ptJig).length();
				}
			}//next ipt
			PLine plCirc;
			plCirc.createCircle(ptSelected, _ZW, U(50));
			PlaneProfile ppCirc(pn);
			ppCirc.joinRing(plCirc, _kAdd);
			
			
//			// draw all points
//			dpJig.color(2);
//			dpJig.draw(ppPl, _kDrawFilled);
//			dpJig.color(3);
//			for (int ipt=0;ipt<ptsAll.length();ipt++) 
//			{ 
//				PLine plCirc;
//				plCirc.createCircle(ptsAll[ipt], _ZW, U(50));
//				PlaneProfile ppCirc(pn);
//				ppCirc.joinRing(plCirc, _kAdd);
//				dpJig.draw(ppCirc,_kDrawFilled);
//				dpJig.draw(plCirc);
//			}//next ipt


			dpJig.color(3);
			for (int ipt=0;ipt<ptsAdded.length();ipt++) 
			{ 
				PLine plCirc;
				plCirc.createCircle(ptsAdded[ipt], _ZW, U(50));
				PlaneProfile ppCirc(pn);
				ppCirc.joinRing(plCirc, _kAdd);
				dpJig.draw(ppCirc,_kDrawFilled);
				dpJig.draw(plCirc);
				 
			}//next ipt
			dpJig.color(1);
			for (int ipt=0;ipt<ptsDeleted.length();ipt++) 
			{ 
				Vector3d vecCrossX = _XW + _YW;
				vecCrossX.normalize();
				Vector3d vecCrossY = -_XW + _YW;
				vecCrossY.normalize();
				
				PlaneProfile ppCross1(pn);
				ppCross1.createRectangle(LineSeg(ptsDeleted[ipt]-vecCrossX*U(110)-vecCrossY*U(20),
				ptsDeleted[ipt]+vecCrossX*U(110)+vecCrossY*U(20)),vecCrossX,vecCrossY);
				
				PlaneProfile ppCross2(pn);
				ppCross2.createRectangle(LineSeg(ptsDeleted[ipt]-vecCrossY*U(110)-vecCrossX*U(20),
				ptsDeleted[ipt]+vecCrossY*U(110)+vecCrossX*U(20)),vecCrossY,vecCrossX);
				dpJig.draw(ppCross1,_kDrawFilled);
				dpJig.draw(ppCross2,_kDrawFilled);
			}//next ipt
			
			
			// point that will be deleted
			dpJig.color(1);
			dpJig.draw(ppCirc,_kDrawFilled);
			dpJig.draw(plCirc);
		}
		else if(insertionMode==1)
		{ 
			// add mode
			dpJig.color(3);
			Display dpError(1);
			if(ppPl.pointInProfile(ptJig)==_kPointOutsideProfile)
			{ 
				dpError.draw(ppPl, _kDrawFilled);
				return
			}
			
		// draw all points
//			dpJig.color(2);
//			dpJig.draw(ppPl, _kDrawFilled);
//			dpJig.color(3);
//			for (int ipt=0;ipt<ptsAll.length();ipt++) 
//			{ 
//				PLine plCirc;
//				plCirc.createCircle(ptsAll[ipt], _ZW, U(50));
//				PlaneProfile ppCirc(pn);
//				ppCirc.joinRing(plCirc, _kAdd);
//				dpJig.draw(ppCirc,_kDrawFilled);
//				dpJig.draw(plCirc);
//				 
//			}//next ipt
			
			
			dpJig.color(3);
			for (int ipt=0;ipt<ptsAdded.length();ipt++) 
			{ 
				PLine plCirc;
				plCirc.createCircle(ptsAdded[ipt], _ZW, U(50));
				PlaneProfile ppCirc(pn);
				ppCirc.joinRing(plCirc, _kAdd);
				dpJig.draw(ppCirc,_kDrawFilled);
				dpJig.draw(plCirc);
				 
			}//next ipt
			dpJig.color(1);
			for (int ipt=0;ipt<ptsDeleted.length();ipt++) 
			{ 
				Vector3d vecCrossX = _XW + _YW;
				vecCrossX.normalize();
				Vector3d vecCrossY = -_XW + _YW;
				vecCrossY.normalize();
				
				PlaneProfile ppCross1(pn);
				ppCross1.createRectangle(LineSeg(ptsDeleted[ipt]-vecCrossX*U(110)-vecCrossY*U(20),
				ptsDeleted[ipt]+vecCrossX*U(110)+vecCrossY*U(20)),vecCrossX,vecCrossY);
				PlaneProfile ppCross2(pn);
				ppCross2.createRectangle(LineSeg(ptsDeleted[ipt]-vecCrossY*U(110)-vecCrossX*U(20),
				ptsDeleted[ipt]+vecCrossY*U(110)+vecCrossX*U(20)),vecCrossY,vecCrossX);
				dpJig.draw(ppCross1,_kDrawFilled);
				dpJig.draw(ppCross2,_kDrawFilled);
				 
			}//next ipt
			
			PLine plCirc;
			plCirc.createCircle(ptJig, _ZW, U(50));
			PlaneProfile ppCirc(pn);
			ppCirc.joinRing(plCirc, _kAdd);
			
			dpJig.color(3);
			dpJig.draw(ppCirc,_kDrawFilled);
			dpJig.draw(plCirc);
			
		}
		
//		dpJig.draw("X", ptJig, _XW, _YW, 0, 0, _kDeviceX);
		return;
	}
//End jigs//endregion 	

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}	
	// standard dialog	
		else
			showDialog();
		
//	// prompt Pline selection
//		_Entity.append(getEntPLine());

	// prompt RUB-Raum selection
		// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select Raum tsls|"), TslInst());
		if (ssE.go())
			ents.append(ssE.set());
			
		TslInst tslRaums[0];
		for (int ient=0;ient<ents.length();ient++) 
		{ 
			TslInst tslI=(TslInst)ents[ient]; 
			if ( ! tslI.bIsValid())continue;
			if (tslI.scriptName() != "Raum")continue;
			if(tslRaums.find(tslI)<0)
				tslRaums.append(tslI);
		}//next ient
		
		TslInst tslRaumBottom;
		double dBottomTsl=10e10;
		int iTslBottom=-1;
		for (int itsl=0;itsl<tslRaums.length();itsl++) 
		{ 
		//	if (tslRaums[itsl].map().hasPoint3d("ptPlane") && tslRaums[itsl].map().hasVector3d("vecPlane"))
			if(tslRaums[itsl].map().hasEntity("TslAlign") && tslRaums[itsl].map().getEntity("TslAlign").bIsValid())
			{
				// aligned
				continue;
			}
			if (tslRaums[itsl].propDouble(0)<dBottomTsl)
			{
				tslRaums[itsl].map().getBody("bd").vis(3);
				tslRaumBottom=tslRaums[itsl];
				dBottomTsl=tslRaums[itsl].propDouble(0);
				iTslBottom=itsl;
			}
		}//next itsl
		
		if(iTslBottom<0)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|No base Raum found|"));
			eraseInstance();
			return;
		}
		
		Plane pn(tslRaumBottom.ptOrg(), _ZW);
		PlaneProfile ppPl(pn);
		for (int itsl=0;itsl<tslRaums.length();itsl++) 
		{ 
			Body bdI = tslRaums[itsl].map().getBody("bd");
		//	bdI.vis(1);
			PlaneProfile ppI = bdI.shadowProfile(pn);
			ppI.shrink(-U(10));
			ppPl.unionWith(ppI);
		}//next itsl
		ppPl.shrink(U(10));
		
		PLine pls[] = ppPl.allRings(true, false);
		if(pls.length()==0)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|Unexpected: no pline found|"));
			eraseInstance();
			return;
		}
		
		PLine pl = pls[0];
		_Map.setEntityArray(tslRaums, false, "tslRaums", "tslRaums","tslRaums");
//		EntPLine ePl = (EntPLine)_Entity[0];
//		if(!ePl.bIsValid())
//		{ 
//			reportMessage("\n"+scriptName()+" "+T("|Non valid Pline|"));
//			eraseInstance();
//			return;
//		}
//		
//		PLine pl = ePl.getPLine();
//		pl.close();
		
		String sStringStart="|Select Insertion Point or [";
		String sOption="gridX/gridY/offseTX/offseTY]|";
		PrPoint ssP(sStringStart+sOption);
		ssP.setSnapMode(true, _kOsModeEnd | _kOsModeMid);
		Map mapArgs;
		mapArgs.setPLine("pl",pl);
		int nGoJig = -1;
		while(nGoJig!= _kNone)
		{ 
			nGoJig = ssP.goJig(strJigAction1, mapArgs); 
			if(nGoJig==_kOk)
			{ 
				// 
				Point3d ptLast = ssP.value();
				Vector3d vecView = getViewDirection();
				Plane pn(pl.coordSys().ptOrg(), pl.coordSys().vecZ());
//				ptLast = Line(ptLast,vecView).intersect(pn, U(0));
				
				Point3d ptIntersect;
				int iIntersect=Line(ptLast, vecView).hasIntersection(pn,ptIntersect);
				if(iIntersect)
					ptLast = ptIntersect;
				
				_Pt0 = ptLast;
				nGoJig = _kNone;
			}
			else if(nGoJig==_kKeyWord)
			{ 
				if(ssP.keywordIndex()==0)
				{ 
					// prompt space X of grid
					// prompt space Y of grid
					String sGridX = getString(T("|Enter Grid Space X, Space X is|")+" "+dGridX);
					double _dGridX = sGridX.atof();
					dGridX.set(_dGridX);
				}
				else if(ssP.keywordIndex()==1)
				{ 
					String sGridY = getString(T("|Enter Grid Space Y, Space Y is|")+" "+dGridY);
					double _dGridY = sGridY.atof();
					dGridY.set(_dGridY);
				}
				else if(ssP.keywordIndex()==2)
				{ 
					String sOffsetX = getString(T("|Enter Offset Space X, Offset Space X is|")+" "+dOffsetX);
					double _dOffsetX = sOffsetX.atof();
					dOffsetX.set(_dOffsetX);
				}
				else if(ssP.keywordIndex()==3)
				{ 
					String sOffsetY = getString(T("|Enter Offset Space Y, Offset Space Y is|")+" "+dOffsetY);
					double _dOffsetY = sOffsetY.atof();
					dOffsetY.set(_dOffsetY);
				}
			}
			else if(nGoJig==_kCancel)
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
		
		return;
	}	
// end on insert	__________________//endregion
	
	
//if(_Entity.length()==0)
//{ 
//	reportMessage("\n"+scriptName()+" "+T("|Pline needed|"));
//	eraseInstance();
//	return;
//}
//
//Entity entPline = (EntPLine)_Entity[0];
//PLine pl = entPline.getPLine();
//if(!entPline.bIsValid())
//{ 
//	reportMessage("\n"+scriptName()+" "+T("|No valid Pline found|"));
//	eraseInstance();
//	return;
//}


Entity entRaums[]=_Map.getEntityArray("tslRaums","tslRaums","tslRaums");
TslInst tslRaums[0];
for (int ient=0;ient<entRaums.length();ient++) 
{ 
	TslInst tslI=(TslInst)entRaums[ient]; 
	if ( ! tslI.bIsValid())continue;
	if (tslI.scriptName() != "Raum")continue;
	if(tslRaums.find(tslI)<0)
		tslRaums.append(tslI);
}//next ient

TslInst tslRaumBottom;
double dBottomTsl=10e10;
int iTslBottom=-1;
Point3d ptBottom;
for (int itsl=0;itsl<tslRaums.length();itsl++) 
{ 
//	if (tslRaums[itsl].map().hasPoint3d("ptPlane") && tslRaums[itsl].map().hasVector3d("vecPlane"))
	if(tslRaums[itsl].map().hasEntity("TslAlign") && tslRaums[itsl].map().getEntity("TslAlign").bIsValid())
	{
		// aligned
		continue;
	}
	if (tslRaums[itsl].propDouble(0)<dBottomTsl)
	{
		tslRaums[itsl].map().getBody("bd").vis(3);
		tslRaumBottom=tslRaums[itsl];
		dBottomTsl=tslRaums[itsl].propDouble(0);
		iTslBottom=itsl;
		ptBottom = tslRaums[itsl].ptOrg();
	}
}//next itsl

if(iTslBottom<0)
{ 
	reportMessage("\n"+scriptName()+" "+T("|No base Raum found|"));
	eraseInstance();
	return;
}

Plane pn(tslRaumBottom.ptOrg(), _ZW);
PlaneProfile _ppPl(pn);
PlaneProfile ppRaums[0];
Point3d ptTop;ptTop.setZ(-U(10e10));
for (int itsl=0;itsl<tslRaums.length();itsl++) 
{ 
	Body bdI = tslRaums[itsl].map().getBody("bd");
//	bdI.vis(1);
	PlaneProfile ppI = bdI.shadowProfile(pn);
	ppRaums.append(ppI);
	ppI.shrink(-U(10));
	_ppPl.unionWith(ppI);
	PlaneProfile ppVer=bdI.shadowProfile(Plane(_Pt0,_XW));
	
	
	Point3d ptTopI = _ZW.dotProduct(ppVer.extentInDir(_ZW).ptEnd()-ppVer.extentInDir(_ZW).ptStart())>0?ppVer.extentInDir(_ZW).ptEnd():ppVer.extentInDir(_ZW).ptStart();
	if(_ZW.dotProduct(ptTopI-ptTop)>0)
	{ 
		ptTop = ptTopI;
	}
	
}//next itsl
ptTop.vis(1);
Point3d ptTopThis = ptBottom +_ZW*(dLevel-dThicknessTop);
ptTopThis.vis(6);


_ppPl.shrink(U(10));

PLine pls[] = _ppPl.allRings(true, false);
if(pls.length()==0)
{ 
	reportMessage("\n"+scriptName()+" "+T("|Unexpected: no pline found|"));
	eraseInstance();
	return;
}

PLine pl = pls[0];

int iFootCreateHelp = sNoYes.find(sFootCreateHelp);
int iSymbolFoot = sNoYes.find(sSymbolFoot);
int iTextFoot=sNoYes.find(sTextFoot);

// negative or zero grid spacing not allowed
if(dGridX<=0)
{ 
	dGridX.set(U(300));
}
if(dGridY<=0)
{ 
	dGridY.set(U(300));
}

Display dp(3);
Display dpFoot(6);
Display dpCirclePlane(1);
dpCirclePlane.addViewDirection(_ZW);

// collect all RUB-Raum inside the pline _region
//Entity entsTsl[]=Group().collectEntities(true, TslInst(),_kModelSpace);
//TslInst tslRaums[0];
//PlaneProfile ppRaums[0];
//Plane pn(pl.coordSys().ptOrg(), pl.coordSys().vecZ());
//PlaneProfile _ppPl(pl.coordSys());
//_ppPl.joinRing(pl,_kAdd);
//for (int ient=0;ient<entsTsl.length();ient++) 
//{ 
//	TslInst tslI =(TslInst) entsTsl[ient];
//	if ( ! tslI.bIsValid())continue;
//	if (tslI.scriptName() != "RUB-Raum")continue;
//	Body bdI = tslI.map().getBody("bd");
////	bdI.vis(1);
//	PlaneProfile ppI = bdI.shadowProfile(pn);
//	PlaneProfile ppIntersect=ppI;
//	if(ppIntersect.intersectWith(_ppPl))
//	{ 
//		if(tslRaums.find(tslI)<0)
//		{
//			tslRaums.append(tslI);
//			ppRaums.append(ppI);
//		}
//	}
//}//next ient


//// get the most bottom tsl for the unterkante
//TslInst tslRaumBottom;
//double dBottomTsl=10e10;
//int iTslBottom=-1;
//for (int itsl=0;itsl<tslRaums.length();itsl++) 
//{ 
////	if (tslRaums[itsl].map().hasPoint3d("ptPlane") && tslRaums[itsl].map().hasVector3d("vecPlane"))
//	if(tslRaums[itsl].map().hasEntity("TslAlign") && tslRaums[itsl].map().getEntity("TslAlign").bIsValid())
//	{
//		// aligned
//		continue;
//	}
//	if (tslRaums[itsl].propDouble(0)<dBottomTsl)
//	{
//		tslRaums[itsl].map().getBody("bd").vis(3);
//		tslRaumBottom=tslRaums[itsl];
//		dBottomTsl=tslRaums[itsl].propDouble(0);
//		iTslBottom=itsl;
//	}
//}//next itsl


//// get the highest raum tsl needed for the determination of the level
//TslInst tslRaumLevel;
//double dLevelTsl = -U(10e10);
//int iTslLevel = -1;
//for (int itsl=0;itsl<tslRaums.length();itsl++) 
//{ 
//	if (tslRaums[itsl].map().hasPoint3d("ptPlane") && tslRaums[itsl].map().hasVector3d("vecPlane"))
//	{
//		// aligned
//		continue;
//	}
//	if (tslRaums[itsl].propDouble(0) > dLevelTsl)
//	{
//		tslRaumLevel = tslRaums[itsl];
//		dLevelTsl = tslRaums[itsl].propDouble(0);
//		iTslLevel = itsl;
//	}
//}//next itsl
//if (iTslLevel >- 1)
//{
//	tslRaums.removeAt(iTslLevel);
//	dLevel.set(dLevelTsl);
//}

// create the highest tslRaum
TslInst tslRaumLevel;
if(_Entity.length()>0)
{ 
	Entity entTslRaumLevel=_Entity[0];
	TslInst tsl=(TslInst)entTslRaumLevel;
	if(tsl.bIsValid())
	{ 
		tslRaumLevel=tsl;
	}
}

if(!tslRaumLevel.bIsValid())
{ 
	// create one
// create TSL
	TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
	GenBeam gbsTsl[] = {}; Entity entsTsl[] = {}; Point3d ptsTsl[] = {_Pt0};
	int nProps[]={}; 
	double dProps[3]; 
	String sProps[]={};
	Map mapTsl;
	
	double dLevelTsl = (dBottomTsl+dLevel)-dThicknessTop;
	dProps[0]=dLevelTsl;// Erhebung
	dProps[1]=dThicknessTop;// thickness
	dProps[2]=U(0);// gradient
	
	
	mapTsl.setPLine("Pline",pl);
	// flag that it is controlled by Stellfüße
	mapTsl.setInt("StellfüßeFlag", true);
	mapTsl.setEntity("Stellfüße",_ThisInst);
// create TSL
	tslNew.dbCreate("Raum",vecXTsl,vecYTsl,gbsTsl,entsTsl,
			ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
	tslNew.transformBy(Vector3d(0, 0, 0));
	if(tslNew.bIsValid())
	{ 
		if(_Entity.length()==1)
		{ 
			_Entity[0]=tslNew;
		}
		else if(_Entity.length()==0)
		{ 
			_Entity.append(tslNew);
		}
		tslRaumLevel = tslNew;
	}
}

if(tslRaumLevel.bIsValid())
{ 
	setDependencyOnEntity(tslRaumLevel);
//	
	if(_ZW.dotProduct(ptTopThis-ptTop)<0)
	{ 
		dLevel.set(_ZW.dotProduct(ptTop-ptBottom)+dThicknessTop);
		double dLevelTslNew = (dBottomTsl+dLevel) - dThicknessTop;
		tslRaumLevel.setPropDouble(0,dLevelTslNew);
		setExecutionLoops(2);
		return
	}


	double dLevelTsl = tslRaumLevel.propDouble(0);
	double dThicknessTsl = tslRaumLevel.propDouble(1);
	if(_kNameLastChangedProp==sLevelName)
	{ 
		// level is changed
		double dLevelTslNew = (dBottomTsl+dLevel) - dThicknessTop;
		tslRaumLevel.setPropDouble(0,dLevelTslNew);
	}
	else if(_kNameLastChangedProp==sThicknessTopName)
	{ 
		tslRaumLevel.setPropDouble(1,dThicknessTop);
		tslRaumLevel.setPropDouble(0,(dBottomTsl+dLevel) - dThicknessTop);
	}
	else if(_kNameLastChangedProp!=sLevelName && _kNameLastChangedProp!=sThicknessTopName)
	{ 
		dThicknessTop.set(dThicknessTsl);
		dLevel.set(dLevelTsl-dBottomTsl+dThicknessTop);
	}
}

double dLevelCalc=(dBottomTsl+dLevel)-dThicknessTop;
//if(tslRaums.find(tslRaumLevel)>-1)
//{ 
//	tslRaums.removeAt(tslRaums.find(tslRaumLevel));
//	ppRaums.removeAt(tslRaums.find(tslRaumLevel));
//}


PLine plLev = pl;
Point3d ptLevel = pl.coordSys().ptOrg();
ptLevel.setZ(U(0));
ptLevel += _ZW * dLevelCalc;
pn=Plane(ptLevel, pl.coordSys().vecZ());
pl.projectPointsToPlane(pn, _ZW);
dp.draw(pl);
_Pt0 = pn.closestPointTo(_Pt0);
//pl.vis(1);
ptLevel.vis(1);
CoordSys csLev(ptLevel, _XW, _YW, _ZW);
PlaneProfile ppPl(csLev);
ppPl.joinRing(pl,_kAdd);

if(ppPl.pointInProfile(_Pt0)==_kPointOutsideProfile)
{ 
//	reportMessage("\n"+scriptName()+" "+T("|insertion point outside of the outter contour|"));
//	eraseInstance();
//	return;

// take the closest vertexpoint
	Point3d pts[] = pl.vertexPoints(true);
	if(pts.length()==0)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|Unexpected: No vertex points|"));
		eraseInstance();
		return;
	}
	Point3d ptClosest = pts[0];
	double dClosest=(ptClosest-_Pt0).length();
	for (int ipt=0;ipt<pts.length();ipt++)
	{ 
		if((pts[ipt]-_Pt0).length()<dClosest)
		{ 
			dClosest=(pts[ipt]-_Pt0).length();
			ptClosest=pts[ipt];
		}
	}//next ipt
	
	_Pt0 = ptClosest;
}

if(_kNameLastChangedProp=="_Pt0")
{ 
	// pt0 is moved
	if(ppPl.pointInProfile(_Pt0)==_kPointOutsideProfile)
	{ 
		_Pt0=ppPl.closestPointTo(_Pt0);
	}
}

LineSeg lSegs[0],lSegsX[0],lSegsY[0];
Vector3d vecDirs[]={_XW,-_XW,_YW,-_YW };
Vector3d vecNormals[]={_YW,_YW,_XW,_XW };
double dGrids[]={ dGridX,dGridX,dGridY,dGridY};
double dOffsets[]={ dOffsetX,dOffsetX,dOffsetY,dOffsetY};

Point3d ptsAll[0];
// store all contour points separately
Point3d ptsSegsContour[0];
for (int iDir=0;iDir<vecDirs.length();iDir++) 
{
	// moving vector
	Vector3d vecDir = vecDirs[iDir]; 
	// line vector
	Vector3d vecNormal = vecNormals[iDir]; 
	int iContinue=true;
	int iStep = 0;
	// to remember for this dir
	LineSeg lSegsDir[0];
	int iStepsDir=abs(dOffsets[iDir])/dGrids[iDir];
	iStepsDir += 2;
	
	while(iContinue)
	{ 
		//
		Point3d ptI=_Pt0+iStep*dGrids[iDir]*vecDir;
		ptI.transformBy(_XW*dOffsetX);
		ptI.transformBy(_YW*dOffsetY);
		Line lnI(ptI, vecNormal);
		
		Point3d ptsI[] = pl.intersectPoints(lnI);
		if(iDir==1 || iDir==3)
		{ 
			if (iStep == 0)
			{
				iStep++;
				continue;
			}
		}
		
		LineSeg lSegsI[0];
		for (int ipt=0;ipt<ptsI.length()-1;ipt++) 
		{ 
			//
			Point3d pt1=ptsI[ipt];
			Point3d pt2=ptsI[ipt+1];
			Point3d ptMid=.5*(pt1+pt2);
			if(ppPl.pointInProfile(ptMid)==_kPointInProfile)
			{ 
				lSegsI.append(LineSeg(pt1, pt2));
				// points of segments with outter contours
				ptsAll.append(pt1);
				ptsAll.append(pt2);
				
			}
		}//next ipt
		
		lSegs.append(lSegsI);
		lSegsDir.append(lSegsI);
		if(iDir<2)
		{ 
			lSegsY.append(lSegsI);
		}
		else if(iDir>=2)
		{ 
			lSegsX.append(lSegsI);
		}
		if(lSegsDir.length()>0)
		{ 
			// some segments are already drawn for this direction
			if(ptsI.length()==0)
			{
				iContinue = false;
				continue;
			}
		}
		else if(lSegsDir.length()==0)
		{ 
			// try some iterations
			if(iStep>iStepsDir && ptsI.length()==0)
			{ 
//				reportMessage("\n"+scriptName()+" "+T("|Unexpected: no gridline|"));
				// point was outside the border, no grid in this direction
				iContinue = false;
				continue;
			}
		}
		
		iStep++;
		if(iStep>200)
		{ 
			iContinue = false;
		}
	}//next iDir
}
ptsSegsContour.append(ptsAll);

// sort lSegsX, lSegsY
// order alphabetically
for (int i=0;i<lSegsX.length();i++) 
	for (int j=0;j<lSegsX.length()-1;j++) 
		if (_YW.dotProduct(lSegsX[j].ptStart()-lSegsX[j+1].ptStart())>dEps)
			lSegsX.swap(j, j + 1);
				
for (int i=0;i<lSegsY.length();i++) 
		for (int j=0;j<lSegsY.length()-1;j++) 
			if (_YW.dotProduct(lSegsY[j].ptStart()-lSegsY[j+1].ptStart())>dEps)
				lSegsY.swap(j, j + 1);

// display Grid as multiple segments for snapping
// draw segments in x
for (int i=0;i<lSegsX.length();i++) 
{ 
	Point3d ptXi[0];
	
	PLine plXi;
	Point3d pt1 = lSegsX[i].ptStart();
	Point3d pt2 = lSegsX[i].ptEnd();
	if(_XW.dotProduct(pt2-pt1)<0)
	{ 
		pt1 = lSegsX[i].ptEnd();
		pt2 = lSegsX[i].ptStart();
	}
	plXi.addVertex(pt1);
	plXi.addVertex(pt2);
	ptXi.append(pt1);
	for (int j=0;j<lSegsY.length();j++) 
	{ 
		PLine plYj;
		plYj.addVertex(lSegsY[j].ptStart());
		plYj.addVertex(lSegsY[j].ptEnd());
		
		Point3d ptsIj[]=plXi.intersectPLine(plYj);
		if(ptsIj.length()==0)
		{ 
			// no intersection found
			continue;
		}
		if(ptsIj.length()!=1)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|Unexpected: More than 1 intersectionpoint at help Grid|"));
			continue;
		}
		ptXi.append(ptsIj);
	}//next j
	
	ptXi.append(pt2);
	
	// draw segments
	for (int ipt=0;ipt<ptXi.length()-1;ipt++) 
	{ 
		LineSeg lSeg(ptXi[ipt],ptXi[ipt+1]);
		dp.draw(lSeg);
	}//next ipt
}//next i

// draw segments in y
for (int i=0;i<lSegsY.length();i++) 
{ 
	Point3d ptYi[0];
	
	PLine plYi;
	Point3d pt1 = lSegsY[i].ptStart();
	Point3d pt2 = lSegsY[i].ptEnd();
	if(_YW.dotProduct(pt2-pt1)<0)
	{ 
		pt1 = lSegsY[i].ptEnd();
		pt2 = lSegsY[i].ptStart();
	}
	plYi.addVertex(pt1);
	plYi.addVertex(pt2);
	ptYi.append(pt1);
	for (int j=0;j<lSegsX.length();j++) 
	{ 
		PLine plXj;
		plXj.addVertex(lSegsX[j].ptStart());
		plXj.addVertex(lSegsX[j].ptEnd());
		
		Point3d ptsIj[]=plYi.intersectPLine(plXj);
		if(ptsIj.length()==0)
		{ 
			// no intersection found
			continue;
		}
		if(ptsIj.length()!=1)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|Unexpected: More than 1 intersectionpoint at help Grid|"));
			continue;
		}
		ptYi.append(ptsIj);
	}//next j
	
	ptYi.append(pt2);
	
	// draw segments
	for (int ipt=0;ipt<ptYi.length()-1;ipt++) 
	{ 
		LineSeg lSeg(ptYi[ipt],ptYi[ipt+1]);
		dp.draw(lSeg);
	}//next ipt
}//next i

// draw contour segments
{ 
	Point3d ptsPl[]=pl.vertexPoints(false);
	for (int ipt=0;ipt<ptsPl.length()-1;ipt++) 
	{ 
		Vector3d vecDir = ptsPl[ipt + 1] - ptsPl[ipt];
		vecDir.normalize();
		// for this segment
		Point3d ptsI[0];
		ptsI.append(ptsPl[ipt]);
		Line lnI(ptsPl[ipt], vecDir);
		for (int jpt=ptsSegsContour.length()-1; jpt>=0 ; jpt--) 
		{ 
			if((lnI.closestPointTo(ptsSegsContour[jpt])-ptsSegsContour[jpt]).length()<dEps)
			{ 
				ptsI.append(ptsSegsContour[jpt]);
				ptsSegsContour.removeAt(jpt);
			}
		}//next jpt
		ptsI.append(ptsPl[ipt+1]);
		// sort
		// order alphabetically
		for (int i=0;i<ptsI.length();i++) 
			for (int j=0;j<ptsI.length()-1;j++) 
				if (vecDir.dotProduct(ptsI[j]-ptsI[j+1])>dEps)
					ptsI.swap(j, j + 1);
			
		
		for (int jpt=0;jpt<ptsI.length()-1;jpt++) 
		{ 
			LineSeg lSeg(ptsI[jpt],ptsI[jpt+1]);
			dp.draw(lSeg);
			 
		}//next jpt
	}//next ipt
}


// get in ptsAll all intersection points between segX and segY
for (int ix=0;ix<lSegsX.length();ix++) 
{ 
	LineSeg lSegIx=lSegsX[ix];
	Point3d pt1 = lSegIx.ptStart();
	Point3d pt2 = lSegIx.ptEnd();
	PLine plIx;
	plIx.addVertex(pt1);
	plIx.addVertex(pt2);
	for (int jy=0;jy<lSegsY.length();jy++) 
	{ 
		LineSeg lSegIy=lSegsY[jy];
		Point3d pt1j = lSegIy.ptStart();
		Point3d pt2j = lSegIy.ptEnd();
		PLine plIy;
		plIy.addVertex(pt1j);
		plIy.addVertex(pt2j);
		
		Point3d ptsIj[]=plIx.intersectPLine(plIy);
		if(ptsIj.length()==0)
		{ 
			// no intersection found
			continue;
		}
		if(ptsIj.length()!=1)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|Unexpected: More than 1 intersectionpoint|"));
			
		}
		ptsAll.append(ptsIj);
	}//next jy
}//next ix

// vertex points of outter contour, pl
{ 
	Point3d ptsPl[]=pl.vertexPoints(true);
	for (int ipt=0;ipt<ptsPl.length();ipt++) 
	{ 
		ptsAll.append(ptsPl[ipt]);
	}//next ipt
}

//// sort points in Y and X direction
//Point3d ptsAllSortedX[0];
//ptsAllSortedX.append(ptsAll);
//Point3d ptsAllSortedY[0];
//ptsAllSortedY.append(ptsAll);
//
//// order alphabetically in Y direction
//	for (int i=0;i<ptsAllSortedX.length();i++)
//		for (int j=0;j<ptsAllSortedX.length()-1;j++) 
//			if (_YW.dotProduct(ptsAllSortedX[j]-ptsAllSortedX[j+1])>=dEps)
//				ptsAllSortedX.swap(j, j + 1);
//			else if(abs(_YW.dotProduct(ptsAllSortedX[j]-ptsAllSortedX[j+1]))<dEps)
//			{
//				if (_XW.dotProduct(ptsAllSortedX[j]-ptsAllSortedX[j+1])>0)
//					ptsAllSortedX.swap(j, j + 1);
//			}
//	
//	// order alphabetically in Y direction
//	for (int i=0;i<ptsAllSortedY.length();i++)
//		for (int j=0;j<ptsAllSortedY.length()-1;j++) 
//			if (_XW.dotProduct(ptsAllSortedY[j]-ptsAllSortedY[j+1])>=dEps)
//				ptsAllSortedY.swap(j, j + 1);
//			else if(abs(_XW.dotProduct(ptsAllSortedY[j]-ptsAllSortedY[j+1]))<dEps)
//			{
//				if (_YW.dotProduct(ptsAllSortedY[j]-ptsAllSortedY[j+1])>0)
//					ptsAllSortedY.swap(j, j + 1);
//			}
//	
//
//for (int ipt=0;ipt<ptsAllSortedX.length()-1;ipt++) 
//{ 
//	Point3d pt1 = ptsAllSortedX[ipt];
//	Point3d pt2 = ptsAllSortedX[ipt+1];
//	
//	if(abs(_YW.dotProduct(pt1-pt2))<dEps)
//	{ 
//		LineSeg lSeg(pt1, pt2);
//		dp.draw(lSeg);
//	}
//	else
//	{ 
//		continue;
//	}
//}//next ipt
//
//for (int ipt=0;ipt<ptsAllSortedY.length()-1;ipt++) 
//{ 
//	Point3d pt1 = ptsAllSortedY[ipt];
//	Point3d pt2 = ptsAllSortedY[ipt+1];
//	
//	if(abs(_XW.dotProduct(pt1-pt2))<dEps)
//	{ 
//		LineSeg lSeg(pt1, pt2);
//		dp.draw(lSeg);
//	}
//	else
//	{ 
//		continue;
//	}
//}//next ipt


int iDisplayGridHelp=sNoYes.find(sDisplayGridHelp);
if(iDisplayGridHelp)
{ 
	// show secondary grid, helping grid
	Display dpGridHelp(2);
	dpGridHelp.transparency(60);
	Point3d ptsAllHelp[0];
	LineSeg lSegs[0],lSegsX[0],lSegsY[0];
	
	double dGrids[]={ dGridXhelp,dGridXhelp,dGridYhelp,dGridYhelp};
	double dOffsets[]={ dOffsetXhelp,dOffsetXhelp,dOffsetYhelp,dOffsetYhelp};
	
	for (int iDir=0;iDir<vecDirs.length();iDir++) 
	{
		// moving vector
		Vector3d vecDir = vecDirs[iDir]; 
		// line vector
		Vector3d vecNormal = vecNormals[iDir]; 
		int iContinue=true;
		int iStep = 0;
		// to remember for this dir
		LineSeg lSegsDir[0];
		int iStepsDir=abs(dOffsets[iDir])/dGrids[iDir];
		iStepsDir += 2;
		while(iContinue)
		{ 
			//
			Point3d ptI=_Pt0+iStep*dGrids[iDir]*vecDir;
			ptI.transformBy(_XW*dOffsetX);
			ptI.transformBy(_YW*dOffsetY);
			Line lnI(ptI, vecNormal);
			
			Point3d ptsI[] = pl.intersectPoints(lnI);
			if(iDir==1 || iDir==3)
			{ 
				if (iStep == 0)
				{
					iStep++;
					continue;
				}
			}
			
			LineSeg lSegsI[0];
			for (int ipt=0;ipt<ptsI.length()-1;ipt++) 
			{ 
				//
				Point3d pt1=ptsI[ipt];
				Point3d pt2=ptsI[ipt+1];
				Point3d ptMid=.5*(pt1+pt2);
				if(ppPl.pointInProfile(ptMid)==_kPointInProfile)
				{ 
					lSegsI.append(LineSeg(pt1, pt2));
					// points of segments with outter contours
					ptsAllHelp.append(pt1);
					ptsAllHelp.append(pt2);
					// check append to list of all points
					if(iFootCreateHelp)
					{ 
						int iAppend1 = true;
						int iAppend2 = true;
						for (int iip=0;iip<ptsAll.length();iip++) 
						{ 
							if((ptsAll[iip]-pt1).length()<U(1))
							{ 
								iAppend1 = false;
								if(iAppend2==false)
									break;
							}
							if((ptsAll[iip]-pt2).length()<U(1))
							{ 
								iAppend2 = false;
								if(iAppend1==false)
									break;
							}
						}//next iip
						if (iAppend1)ptsAll.append(pt1);
						if (iAppend2)ptsAll.append(pt2);
					}
				}
			}//next ipt
			
			lSegs.append(lSegsI);
			lSegsDir.append(lSegsI);
			if(iDir<2)
			{ 
				lSegsY.append(lSegsI);
			}
			else if(iDir>=2)
			{ 
				lSegsX.append(lSegsI);
			}
			if(lSegsDir.length()>0)
			{ 
				// some segments are already drawn for this direction
				if(ptsI.length()==0)
				{
					iContinue = false;
					continue;
				}
			}
			else if(lSegsDir.length()==0)
			{ 
				// try some iterations
				if(iStep>iStepsDir && ptsI.length()==0)
				{ 
	//				reportMessage("\n"+scriptName()+" "+T("|Unexpected: no gridline|"));
					// point was outside the border, no grid in this direction
					iContinue = false;
					continue;
				}
			}
			
			iStep++;
			if(iStep>200)
			{ 
				iContinue = false;
			}
		}//next iDir
	}
	
	
	
	
	// sort lSegsX, lSegsY
// order alphabetically
	for (int i=0;i<lSegsX.length();i++) 
		for (int j=0;j<lSegsX.length()-1;j++) 
			if (_YW.dotProduct(lSegsX[j].ptStart()-lSegsX[j+1].ptStart())>dEps)
				lSegsX.swap(j, j + 1);
					
	for (int i=0;i<lSegsY.length();i++) 
			for (int j=0;j<lSegsY.length()-1;j++) 
				if (_YW.dotProduct(lSegsY[j].ptStart()-lSegsY[j+1].ptStart())>dEps)
					lSegsY.swap(j, j + 1);
		
	// draw segments in x
	for (int i=0;i<lSegsX.length();i++) 
	{ 
		Point3d ptXi[0];
		
		PLine plXi;
		Point3d pt1 = lSegsX[i].ptStart();
		Point3d pt2 = lSegsX[i].ptEnd();
		if(_XW.dotProduct(pt2-pt1)<0)
		{ 
			pt1 = lSegsX[i].ptEnd();
			pt2 = lSegsX[i].ptStart();
		}
		plXi.addVertex(pt1);
		plXi.addVertex(pt2);
		ptXi.append(pt1);
		for (int j=0;j<lSegsY.length();j++) 
		{ 
			PLine plYj;
			plYj.addVertex(lSegsY[j].ptStart());
			plYj.addVertex(lSegsY[j].ptEnd());
			
			Point3d ptsIj[]=plXi.intersectPLine(plYj);
			if(ptsIj.length()==0)
			{ 
				// no intersection found
				continue;
			}
			if(ptsIj.length()!=1)
			{ 
				reportMessage("\n"+scriptName()+" "+T("|Unexpected: More than 1 intersectionpoint at help Grid|"));
				continue;
			}
			ptXi.append(ptsIj);
			// get here the intersection points
			ptsAllHelp.append(ptsIj);
			// check append to list of all points
			if(iFootCreateHelp)
			{ 
				int iAppend1 = true;
				for (int iip=0;iip<ptsAll.length();iip++) 
				{ 
					if((ptsAll[iip]-ptsIj[0]).length()<U(1))
					{ 
						iAppend1 = false;
						break;
					}

				}//next iip
				if (iAppend1)ptsAll.append(ptsIj[0]);
			}
		}//next j
		
		ptXi.append(pt2);
		
		// draw segments
		for (int ipt=0;ipt<ptXi.length()-1;ipt++) 
		{ 
			LineSeg lSeg(ptXi[ipt],ptXi[ipt+1]);
			dpGridHelp.draw(lSeg);
		}//next ipt
	}//next i
	
	// draw segments in y
	for (int i=0;i<lSegsY.length();i++) 
	{ 
		Point3d ptYi[0];
		
		PLine plYi;
		Point3d pt1 = lSegsY[i].ptStart();
		Point3d pt2 = lSegsY[i].ptEnd();
		if(_YW.dotProduct(pt2-pt1)<0)
		{ 
			pt1 = lSegsY[i].ptEnd();
			pt2 = lSegsY[i].ptStart();
		}
		plYi.addVertex(pt1);
		plYi.addVertex(pt2);
		ptYi.append(pt1);
		for (int j=0;j<lSegsX.length();j++) 
		{ 
			PLine plXj;
			plXj.addVertex(lSegsX[j].ptStart());
			plXj.addVertex(lSegsX[j].ptEnd());
			
			Point3d ptsIj[]=plYi.intersectPLine(plXj);
			if(ptsIj.length()==0)
			{ 
				// no intersection found
				continue;
			}
			if(ptsIj.length()!=1)
			{ 
				reportMessage("\n"+scriptName()+" "+T("|Unexpected: More than 1 intersectionpoint at help Grid|"));
				continue;
			}
			ptYi.append(ptsIj);
		}//next j
		
		ptYi.append(pt2);
		
		// draw segments
		for (int ipt=0;ipt<ptYi.length()-1;ipt++) 
		{ 
			LineSeg lSeg(ptYi[ipt],ptYi[ipt+1]);
			dpGridHelp.draw(lSeg);
		}//next ipt
	}//next i
	
}



// Valid points and nonvalid points
Point3d ptsValid[0],ptsNonValid[0];
Display dpCircle(7);
Display dpText(7);
//for (int ipt=0;ipt<ptsAll.length();ipt++) 
//{ 
//	Point3d ptI=ptsAll[ipt];
//	PLine plCircle(_ZW);
//	plCircle.createCircle(ptI,_ZW,U(102.5));
//	
//	dpCircle.draw(plCircle);
//}//next ipt


// calculate insulation thickness for each point
// draw all
for (int iseg=0;iseg<lSegs.length();iseg++) 
{ 
	LineSeg lSegI=lSegs[iseg];
	Point3d pt1 = lSegI.ptStart();
	Point3d pt2 = lSegI.ptEnd();
	PLine plI;
	plI.addVertex(pt1);
	plI.addVertex(pt2);
	dp.draw(plI);
	
	LineSeg lSeg(pt1, pt2);
	dp.draw(lSeg);
}//next iseg


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
		Element elHW =_ThisInst.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())	elHW = (Element)_ThisInst;
		if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}
	
// add main componnent
// the articleNumber and the quantity is mandatory
	HardWrComp hwc("Stellfuß", 1);
	{ 
//		hwc.setManufacturer(sHWManufacturer);
//		
//		hwc.setModel(sHWModel);
//		hwc.setName(sHWName);
//		hwc.setDescription(sHWDescription);
//		hwc.setMaterial(sHWMaterial);
//		hwc.setNotes(sHWNotes);
//		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(_ThisInst);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
//		
//		hwc.setDScaleX(dHWLength);
//		hwc.setDScaleY(dHWWidth);
//		hwc.setDScaleZ(dHWHeight);
	}



if(_Map.hasPoint3dArray("ptsAll"))
{ 
	ptsAll=_Map.getPoint3dArray("ptsAll");
}


Map mapFoots = mapSetting.getMap("Stellfuß[]");
for (int ipt=0;ipt<ptsAll.length();ipt++) 
{ 
	Point3d ptI=ptsAll[ipt]; 
	ptI = pn.closestPointTo(ptI);
//	ptI.vis(1);
	TslInst tslRaum;
	Plane pnRaum;
	Point3d ptRaum;ptRaum.setZ(-10e9);
	for (int itsl=0;itsl<tslRaums.length();itsl++) 
	{ 
		if(ppRaums[itsl].pointInProfile(ptI)!=_kPointOutsideProfile)
		{ 
			Plane pnI(tslRaums[itsl].map().getPoint3d("ptPlaneTop"), tslRaums[itsl].map().getVector3d("vecPlaneTop"));
			Point3d ptPlaneI;
			int iIntersectPnI=Line(ptI,_ZW).hasIntersection(pnI,ptPlaneI);
			ptPlaneI += _ZW * dThicknessSeal;
			if(_ZW.dotProduct(ptPlaneI-ptRaum)>0)
			{
				ptRaum=ptPlaneI;
				tslRaum=tslRaums[itsl];
			}
		}
	}//next itsl
	if(!tslRaum.bIsValid())
	{ 
		continue;
	}
	
	Body bdFoot(ptI, ptRaum, U(55));
	double dLengthFoot=abs(_ZW.dotProduct(ptI-ptRaum));
	Map mapFoot;
	int iFoundFoot;
	for (int im=0;im<mapFoots.length();im++) 
	{ 
		Map mapI = mapFoots.getMap(im); 
		double dHmin=mapI.getDouble("Hmin");
		double dHmax=mapI.getDouble("Hmax");
		if(dLengthFoot>=dHmin && dLengthFoot<=dHmax)
		{ 
			mapFoot = mapI;
			iFoundFoot = true;
			break;
		}
	}//next im
	
	if(iFoundFoot)
	{ 
		// valid point
		ptsValid.append(ptI);
		//
		int iColorFoot = mapFoot.getInt("Color");
		dpFoot.color(iColorFoot);
		
		PlaneProfile ppCircleHatch(csLev);
		PLine plCircleBig;
		plCircleBig.createCircle(ptI, _ZW, U(55));
		PLine plCircleSmall;
		plCircleSmall.createCircle(ptI, _ZW, U(20));
		
		ppCircleHatch.joinRing(plCircleBig, _kAdd);
		ppCircleHatch.joinRing(plCircleSmall, _kSubtract);
		
		if(iSymbolFoot)
		{ 
		// draw hatch o fsymbol
			dpCirclePlane.color(iColorFoot);
			dpCirclePlane.draw(ppCircleHatch, _kDrawFilled);
			
		// draw big circle
			PLine plCircle(_ZW);
			plCircle.createCircle(ptI,_ZW,U(102.5));
			
			dpCircle.draw(plCircle);
		// draw body
			dpFoot.draw(bdFoot);
		}
		if(iTextFoot)
		{ 
			dpText.textHeight(U(40));
			String sHeight = dLengthFoot;
			String sLengthFoot;
			sLengthFoot.format("%.1f", dLengthFoot);
			String sText=mapFoot.getString("Name")+"\PH= "+sLengthFoot+"mm";
			dpText.draw(sText,ptI-_YW*U(80),_XW,_YW,0,-1,_kDeviceX);
		}
		
		HardWrComp hwcI = hwc;
		hwcI.setDScaleX(dLengthFoot);
		String sHWName=mapFoot.getString("Name");
		hwcI.setName(sHWName);
		// apppend component to the list of components
		hwcs.append(hwcI);
	}
	else if(!iFoundFoot)
	{ 
		ptsNonValid.append(ptI);
	}
}//next ipt

// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	
	//endregion


// triggers to add/remove points
//region Trigger AddPoint
	String sTriggerAddPoint = T("|Add/Delete Point|");
	addRecalcTrigger(_kContextRoot, sTriggerAddPoint );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddPoint)
	{
		
		// create dummy copy
		TslInst tslNew;
		{ 
		// create TSL
			Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {}; Entity entsTsl[] = {}; Point3d ptsTsl[] = {_Pt0};
			int nProps[]={}; 
			double dProps[]={dLevel,dThicknessTop,dGridX,dGridY,dOffsetX,dOffsetY,
				dGridXhelp,dGridYhelp,dOffsetXhelp,dOffsetYhelp,dThicknessSeal}; 
			String sProps[]={sNoYes[1],sNoYes[1],sNoYes[0]};
			Map mapTsl;	
			
			mapTsl = _Map;
			entsTsl.append(_Entity);
			//
			
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
			_Map.setEntity("Dummy", tslNew);
		}
		
		
		String sStringStart = "|Select new point to insert or [";
		String sStringOption = "Delete/Finish]";
		String sStringPrompt = T(sStringStart+sStringOption);
		
		PrPoint ssP(sStringPrompt);
		Map mapArgs;
		mapArgs.setInt("InsertionMode", 1);//add
		mapArgs.setPoint3d("ptLevel",ptLevel);
		mapArgs.setPLine("pl", pl);
		
//		mapArgs.setPoint3dArray("ptsValid",ptsValid);
//		mapArgs.setPoint3dArray("ptsNonValid",ptsNonValid);
		mapArgs.setPoint3dArray("ptsAll",ptsAll);
		
		Point3d ptsAdded[0];
		Point3d ptsDel[0];
		int nGoJig = -1;
		
		while (nGoJig != _kNone)
		{
			nGoJig = ssP.goJig(strJigAction2, mapArgs);
			Point3d _ptsAll[] = mapArgs.getPoint3dArray("ptsAll");
			Point3d ptsDeleted[]=mapArgs.getPoint3dArray("ptsDeleted");
			Point3d ptsAdded[]=mapArgs.getPoint3dArray("ptsAdded");
			int iMode = mapArgs.getInt("InsertionMode");
			if (nGoJig == _kOk)
			{
				Point3d ptLast = ssP.value();
				Vector3d vecView = getViewDirection();
				ptLast = Line(ptLast, vecView).intersect(Plane(pn), U(0));
				
				if(iMode==0)
				{ 
					// delete mode
					Point3d ptSelected;
					double dDistMin = 10e10;
					int iSelected = -1;
					for (int ipt=0;ipt<_ptsAll.length();ipt++) 
					{ 
						if((_ptsAll[ipt]-ptLast).length()<dDistMin)
						{ 
							ptSelected = _ptsAll[ipt];
							dDistMin=(_ptsAll[ipt]-ptLast).length();
							iSelected = ipt;
						}
					}//next ipt
					if(iSelected>-1)
					{ 
						
						_ptsAll.removeAt(iSelected);
						mapArgs.setPoint3dArray("ptsAll", _ptsAll);
						// check if found in ptsAdded and remove from there
						int iAddedIndex = -1;
						for (int ipt=0;ipt<ptsAdded.length();ipt++) 
						{ 
							if((ptsAdded[ipt]-ptSelected).length()<U(50))
							{ 
								iAddedIndex = ipt;
								break;
							}
						}//next ipt
						if(iAddedIndex>-1)
						{ 
							ptsAdded.removeAt(iAddedIndex);
						}
						else
						{ 
							// not from the added points
							ptsDeleted.append(ptSelected);
						}
						mapArgs.setPoint3dArray("ptsDeleted", ptsDeleted);
						reportMessage("\n"+scriptName()+" "+T("|ptsDeleted|")+ptsDeleted.length());
						
						mapArgs.setPoint3dArray("ptsAdded", ptsAdded);
						_Map.setPoint3dArray("ptsAll", _ptsAll);
					}
				}
				else if(iMode==1)
				{ 
					// insert mode
					if(ppPl.pointInProfile(ptLast)!=_kPointOutsideProfile)
					{ 
						// avoid double points
						int iDouble;
						for (int ipt=0;ipt<_ptsAll.length();ipt++) 
						{ 
							if((_ptsAll[ipt]-ptLast).length()<U(100))
							{ 
								iDouble = true;
								break;
							}
						}//next ipt
						if(!iDouble)
						{ 
							// check if found in ptsDeleted and remove from there
							int iDeletedIndex = -1;
							for (int ipt=0;ipt<ptsDeleted.length();ipt++) 
							{ 
								if((ptsDeleted[ipt]-ptLast).length()<U(50))
								{ 
									iDeletedIndex = ipt;
									break;
								}
							}//next ipt
							if(iDeletedIndex>-1)
							{ 
								
								_ptsAll.append(ptsDeleted[iDeletedIndex]);
								ptsDeleted.removeAt(iDeletedIndex);
							}
							else
							{ 
								// not from deleted points, add new
								ptsAdded.append(ptLast);
								_ptsAll.append(ptLast);
							}
							mapArgs.setPoint3dArray("ptsAll", _ptsAll);
							mapArgs.setPoint3dArray("ptsAdded", ptsAdded);
							mapArgs.setPoint3dArray("ptsDeleted", ptsDeleted);
							_Map.setPoint3dArray("ptsAll", _ptsAll);
						}
					}
				}
			}
			else if(nGoJig==_kKeyWord)
			{ 
				if (ssP.keywordIndex()==0)
				{ 
					// get mode and change prompt
					
					
					if(iMode==0)
					{ 
						// we are at delete, change to add
						sStringStart = "|Select new point to insert or [";
						sStringOption= "Delete/Finish]";
						sStringPrompt = T(sStringStart+sStringOption);
						mapArgs.setInt("InsertionMode" ,! iMode);
					}
					else if(iMode==1)
					{ 
						// we are at add, change to delete modus
						sStringStart = "|Select new point to delete or [";
						sStringOption= "Add/Finish]";
						sStringPrompt = T(sStringStart+sStringOption);
						mapArgs.setInt("InsertionMode" ,! iMode);
						
					}
					ssP=PrPoint (sStringPrompt);
				}
				else if(ssP.keywordIndex()==1)
				{ 
					// finish
					nGoJig=_kNone;
				}
			}
			else if(nGoJig==_kNone)
			{ 
				// finish
			}
			else if(nGoJig==_kCancel)
			{ 
				nGoJig=_kNone;
			}
		}
		
		tslNew.dbErase();
		_Map.removeAt("Dummy", true);
		
		setExecutionLoops(2);
		return;
	}//endregion	


//region Trigger ResetPoints
	String sTriggerResetPoints = T("|Reset Points|");
	addRecalcTrigger(_kContextRoot, sTriggerResetPoints );
	if (_bOnRecalc && _kExecuteKey==sTriggerResetPoints)
	{
		_Map.removeAt("ptsAll",true);
		_Map.removeAt("ptsDeleted",true);
		_Map.removeAt("ptsAdded",true);
		setExecutionLoops(2);
		return;
	}//endregion

String sResetProps[]={sGridXName,sGridYName,sOffsetXName,sOffsetYName};
if(sResetProps.find(_kNameLastChangedProp)>-1)
{ 
	_Map.removeAt("ptsAll",true);
	_Map.removeAt("ptsDeleted",true);
	_Map.removeAt("ptsAdded",true);
	setExecutionLoops(2);
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
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="1385" />
        <int nm="BREAKPOINT" vl="1546" />
        <int nm="BREAKPOINT" vl="1295" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15668: Add secondary grid, and its properties" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="6/9/2022 11:43:54 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15668: Outter contour defined by the underlying &quot;RUB-Raum&quot; instances" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="6/8/2022 5:27:04 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15668: Add commands to Add/delete points" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="6/8/2022 12:57:06 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15668: initial" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="6/7/2022 6:14:48 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End