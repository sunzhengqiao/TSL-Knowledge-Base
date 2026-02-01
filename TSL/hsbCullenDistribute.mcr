#Version 8
#BeginDescription
#Versions:
2.6 13.09.2024 HSB-20921: Add offset property for GA at soleplate Author: Marsel Nakuci
version value="2.5" date="07feb20" author="marsel.nakuci@hsbcad.com" 
HSB-5435: add distribution for AG, distribution applicable for sheets and horizontal beam of wall
HSB-5435 fix distribution when nNrParts is inserted for ST-PFS 
HSB-5435 distribution of ST-PFS hsbCullenDistribute 
HSB-5435 set for PC also iSideSelected 
HSB-5435 fix distribution for PC
HSB-5435 change name, add property type to pick what type to be distributed 
HSB-5435 cleanup 
HSB-5435 fix bug for walls with different heights 
HSB-5435 delete instance after generation, add property swap x-y, if dDistanceBetween<0, calculation is done based on the nNrParts 
HSB-5435 initial



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 6
#KeyWords cullen, FAS, distribute, kingspan
#BeginContents
/// <History>//region
/// #Versions:
// 2.6 13.09.2024 HSB-20921: Add offset property for GA at soleplate Author: Marsel Nakuci
/// <version value="2.5" date="07feb20" author="marsel.nakuci@hsbcad.com"> HSB-5435: add distribution for AG, distribution applicable for sheets and horizontal beam of wall</version>
/// <version value="2.4" date="04feb20" author="marsel.nakuci@hsbcad.com"> HSB-5435 fix distribution when nNrParts is inserted for ST-PFS</version>
/// <version value="2.3" date="04feb20" author="marsel.nakuci@hsbcad.com"> HSB-5435 distribution of ST-PFS hsbCullenDistribute</version>
/// <version value="2.2" date="29.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5435 set for PC also iSideSelected </version>
/// <version value="2.1" date="27.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5435 fix distribution for PC </version>
/// <version value="2.0" date="24.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5435 change name, add property type to pick what type to be distributed </version>
/// <version value="1.3" date="23.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5435 cleanup </version>
/// <version value="1.2" date="23.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5435 fix bug for walls with different heights </version>
/// <version value="1.1" date="22.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5435 delete instance after generation, add property swap x-y, if dDistanceBetween<0, calculation is done based on the nNrParts </version>
/// <version value="1.0" date="22.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5435 initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates 
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCullenFASdistribute")) TSLCONTENT
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
	
	
//region properties
	// type to be distribute
	// framing anchor or panel closer
	String sTypes[] ={ "FAS", "PC", "ST-PFS", "GA Cullen"};
	
	String sTypeName=T("|Type|");	
	PropString sType(nStringIndex++, sTypes, sTypeName);
	sType.setDescription(T("|Defines the Type|"));
	sType.setCategory(category);
		
	// distance from the bottom
	String sDistanceBottomName=T("|Distance Bottom/Start|");	
	PropDouble dDistanceBottom(nDoubleIndex++, U(0), sDistanceBottomName);	
	dDistanceBottom.setDescription(T("|Defines the Distance at the Bottom|"));
	dDistanceBottom.setCategory(category);
	
	// distance from the top
	String sDistanceTopName=T("|Distance Top/End|");	
	PropDouble dDistanceTop(nDoubleIndex++, U(0), sDistanceTopName);	
	dDistanceTop.setDescription(T("|Defines the Distance at the Top|"));
	dDistanceTop.setCategory(category);
	
	// distance in between
	String sDistanceBetweenName=T("|Distance Between|");	
	PropDouble dDistanceBetween(nDoubleIndex++, U(0), sDistanceBetweenName);	
	dDistanceBetween.setDescription(T("|Defines the Distance Between the parts|"));
	// . Negative number will indicate nr of parts from the integer part of the inserted double
	dDistanceBetween.setCategory(category);
	
	// nr of parts along the height (common region)
	String sNrPartsName=T("|Nr. Parts|");	
//	int nNrPartss[]={1,2,3};
	PropInt nNrParts(nIntIndex++, 0, sNrPartsName);	
	nNrParts.setDescription(T("|Defines the Nr. Parts to be distributed along the walls|"));
	nNrParts.setCategory(category);
	
	String sSwapXYName=T("|Swap X-Y|");	
	PropString sSwapXY(nStringIndex++, sNoYes, sSwapXYName);	
	sSwapXY.setDescription(T("|Swap the parts upside down|"));
	sSwapXY.setCategory(category);
	
	// HSB-20921
	category=T("|Soleplate|");
	String sOffsetAngleBracketName=T("|Offset|")+" "+"GA";
	PropDouble dOffsetAngleBracket(nDoubleIndex++, U(10), sOffsetAngleBracketName);
	dOffsetAngleBracket.setDescription(T("|Defines the OffsetAngleBracket|"));
	dOffsetAngleBracket.setCategory(category);
	
//End properties//endregion 

	
// bOnInsert//region
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) {eraseInstance();return;}
						
		// silent/dialog
			if (_kExecuteKey.length()>0)
			{
				String sEntries[]= TslInst().getListOfCatalogNames(scriptName());
				if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
					setPropValuesFromCatalog(_kExecuteKey);
				else
					setPropValuesFromCatalog(sLastInserted);
			}
		// standard dialog
			else
				showDialog();
		
		// prompt selection of walls
		String sPromptText = T("|Select the crossing stick frame walls(s)|");
		if (sTypes.find(sType) == 2)
		{ 
			// "ST-PFS" is choosen
			// show dialog to enter properties of the hsbCullenSt
			sPromptText=T("|Select the stick frame walls(s)|");
			
//			reportMessage(TN("|ST-PFS| is choosen"));
//			eraseInstance();
//			return;
		}
		else if (sTypes.find(sType) == 3)
		{ 
			// "GA" is selected
			sPromptText=T("|Select the sheet or horizontal beam of the wall|");
		}
		
		// prompt element selection
		if (sTypes.find(sType) == 0 || sTypes.find(sType) == 1 || sTypes.find(sType) == 2)
		{ 
			// prompt for entities
			Entity ents[0];
			Element eles[0];
			PrEntity ssE(sPromptText, ElementWallSF());
			if (ssE.go())
				eles.append(ssE.elementSet());
				
			_Element.append(eles);
		}
		else if(sTypes.find(sType) == 3)
		{ 
			Entity ents[0];
			PrEntity ssE(T("|Select the sheet or horizontal beam of the wall where bracket will be distributed|"), Beam());
			ssE.addAllowedClass(Sheet());
			if (ssE.go())
				ents.append(ssE.set());
				
			
			Beam bm = (Beam) ents[0];
			if(bm.bIsValid())
			{ 
				_Beam.append(bm);
				reportMessage(TN("|beam was selected|"));
			}
			Sheet sh = (Sheet) ents[0];
			if(sh.bIsValid())
			{ 
				_Sheet.append(sh);
				reportMessage(TN("|sheet was selected|"));
			}
			
			// prompt selection of point for the definition of edge
			Point3d pt;
			PrPoint ssP(TN("|Select point that define the edge of the bracket|")); 
			if (ssP.go()==_kOk) 
				_Pt0 = (ssP.value()); //append the selected points to the list of grippoints _PtG
		}
		
		return;
	}
// end on insert	__________________//endregion	
	
	
	if (sTypes.find(sType) == 0 || sTypes.find(sType) == 1)
	{ 
		// distribution along the height for two walls
		// mode 0, sort out male elements from female elements
		int iMode = _Map.getInt("iMode");
	//	iMode = 0;
		if (iMode == 0)
		{ 
			// set iMode=1
			iMode = 1;
			_Map.setInt("iMode", iMode);
			// redistribution mode
			if (_Element.length() < 2)
			{ 
				// at least 2 walls are needed
				reportMessage(TN("|at least 2 walls needed|"));
				eraseInstance();
				return;
			}
			
			// array of strings representing the couples already created
			String sCouples[0];
			
			// create all possible couples male female
			// for each couple insert a TSL instance
			// use the code from RUB-GV
			for (int i = 0; i < _Element.length() - 1; i++)
			{ 
				// element i
				ElementWallSF el0 = (ElementWallSF) _Element[i];
				if ( ! el0.bIsValid())
				{
					continue;
				}
				// general data of el0
				Point3d ptOrg0 = el0.ptOrg();
				Vector3d vecX0 = el0.vecX();
				Vector3d vecY0 = el0.vecY();
				Vector3d vecZ0 = el0.vecZ();
				//
				Plane pn0(ptOrg0, vecY0);
				
				// ploutline from top in XZ plane
				_Element[0].plEnvelope(ptOrg0).vis(4);
				PLine plOutlineWall0 = el0.plOutlineWall();
				PlaneProfile ppOutlineWall0(plOutlineWall0);
				ppOutlineWall0.transformBy(vecX0 * U(200));
				ppOutlineWall0.vis(3);
				Point3d ptsThis[] = plOutlineWall0.vertexPoints(true);
				// plEnvelope of XY plane
				PLine plEnvelope0 = el0.plEnvelope(ptOrg0);
				plEnvelope0.transformBy(vecX0*U(200));
				plEnvelope0.vis(2);
				// points in vertical vecY
				Point3d pts0[] = Line(_Pt0, vecY0).orderPoints(plEnvelope0.vertexPoints(true));
				// loop all other elements
				for (int j = 0; j < _Element.length(); j++)
				{ 
					// element j
					ElementWallSF el1 = (ElementWallSF)_Element[j];
					if ( ! el1.bIsValid())
					{ 
						continue;
					}
					if (el0 == el1)
					{ 
						// not with itself
						continue;
					}
					// general data of el0
					Point3d ptOrg1 = el1.ptOrg();
					Vector3d vecX1 = el1.vecX();
					Vector3d vecY1 = el1.vecY();
					Vector3d vecZ1 = el1.vecZ();
					// dont consider parallel walls
	//				//checks if vectors parallel	
	//				if (abs(abs(vecX0.dotProduct(vecX1)) - 1) < dEps)
	//				{ 
	//					// parallel
	//					continue;
	//				}
					//
					Plane pn1(ptOrg1, vecY1);
					// 
					PLine plOutlineWall1 = el1.plOutlineWall();
					plOutlineWall1.projectPointsToPlane(pn0, vecY0);
					PlaneProfile ppOutlineWall1(plOutlineWall1);
					Point3d ptsOther[] = plOutlineWall1.vertexPoints(true);
					// 
					PLine plEnvelope1 = el1.plEnvelope();
					// points in vertical vecY
					Point3d pts1[] = Line(_Pt0, vecY0).orderPoints(plEnvelope1.vertexPoints(true));
					
					// test Z-Elevation
					double d00 = vecY0.dotProduct(pts0.last() - pts1.first());
					//
					double dff = vecY0.dotProduct(pts1.first() - pts0.first());
					double dll = vecY0.dotProduct(pts1.last() - pts0.last());
					if (dff > d00 || -dll > d00)
					{
						// dont have a common range in z direction
						continue;
					}
					// common points on contour
					int nOnThis = 0, nOnOther = 0;
					Point3d ptsOnThis[0], ptsOnOther[0];
					// points from the other wall
					for (int p = 0; p < ptsOther.length(); p++)
					{
						double d = (ptsOther[p] - plOutlineWall0.closestPointTo(ptsOther[p])).length();
						if (d < dEps)
						{
							ptsOnThis.append(ptsOther[p]);// collect connecting points between 2 walls
							nOnThis++;// count points of wall in el1 that are connected with wall in el0
						}
					}
					// points from this wall at other wall 
					for (int p = 0; p < ptsThis.length(); p++)
					{
						double d = (ptsThis[p] - plOutlineWall1.closestPointTo(ptsThis[p])).length();
						if (d < dEps)
						{
							ptsOnOther.append(ptsThis[p]);
							nOnOther++;
						}
					}
					
					String sCouple = i;
					sCouple+= j;
					String sCouple2 = j;
					sCouple2+= i;
					
					if (sCouples.find(sCouple) >- 1 || sCouples.find(sCouple2) >- 1)
					{ 
						// one or the other is found
						// connection of wall i with j already exists
						// dont create distribution
						
						continue;
					}
					sCouples.append(sCouple);
//					reportMessage("\n"+ scriptName() + " enters...");
//					reportMessage("\n"+ scriptName() + " nOnThis:"+nOnThis);
//						reportMessage("\n"+ scriptName() + " nOnOther:"+nOnOther);
						
					// create tsl for the couple of walls
	
					if (sTypes.find(sType) == 0)
					{ 
						// Fas is selected
					
						// 
						if ((nOnThis == 1 && nOnOther == 2))
						{ 
							// corner connection
							ElementWallSF eMale = el0;
							ElementWallSF eFemale = el1;
							Point3d pt = ptsOnOther[0];
							
							if ((ptsOnThis[0] - ptsOnOther[0]).length() < (ptsOnThis[0] - ptsOnOther[1]).length())
							{ 
								pt = ptsOnOther[1];
							}
							
						// create TSL
							TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
							GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {pt};
							int nProps[]={};			double dProps[]={};				String sProps[]={};
							Map mapTsl;	
							
							// start with flag 1
							mapTsl.setInt("iMode", 1);
							// add properties
							sProps.append(sType);
							//
							dProps.append(dDistanceBottom);
							dProps.append(dDistanceTop);
							dProps.append(dDistanceBetween);
							nProps.append(nNrParts);
							sProps.append(sSwapXY);
							// add elements
							entsTsl.append(eMale);
							entsTsl.append(eFemale);
							
							// create TSL
							tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
						}
						//
						if ((nOnThis == 2 && nOnOther == 1))
						{ 
							// corner connection
							ElementWallSF eMale = el1;
							ElementWallSF eFemale = el0;
							Point3d pt = ptsOnThis[0];
							
							if ((ptsOnThis[0] - ptsOnOther[0]).length() < (ptsOnThis[1] - ptsOnOther[0]).length())
							{ 
								pt = ptsOnThis[1];
							}
							
						// create TSL
							TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
							GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {pt};
							int nProps[]={};			double dProps[]={};				String sProps[]={};
							Map mapTsl;	
							
							// start with flag 1
							mapTsl.setInt("iMode", 1);
							// add properties
							sProps.append(sType);
							//
							dProps.append(dDistanceBottom);
							dProps.append(dDistanceTop);
							dProps.append(dDistanceBetween);
							nProps.append(nNrParts);
							sProps.append(sSwapXY);
							// add elements
							entsTsl.append(eMale);
							entsTsl.append(eFemale);
							
							// create TSL
							tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
						}
						
						if ((nOnThis == 2 && nOnOther == 0) || (nOnThis == 0 && nOnOther == 2))
						{ 
							// "T" connection
							// create 2 tsl for each side
							{ 
								ElementWallSF eMale = el1;
								ElementWallSF eFemale = el0;
								// point for each side
								Point3d pt1;
								Point3d pt2;
								if (nOnThis == 0)
								{ 
									eMale = el0;
									eFemale = el1;
									pt1 = ptsOnOther[0];
									pt2 = ptsOnOther[1];
									
								}
								else
								{ 
									pt1 = ptsOnThis[0];
									pt2 = ptsOnThis[1];
								}
							// create TSL
								TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
								GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {pt1};
								int nProps[]={};			double dProps[]={};				String sProps[]={};
								Map mapTsl;	
								
								// start with flag 1
								mapTsl.setInt("iMode", 1);
								// add properties
								sProps.append(sType);
								//
								dProps.append(dDistanceBottom);
								dProps.append(dDistanceTop);
								dProps.append(dDistanceBetween);
								nProps.append(nNrParts);
								sProps.append(sSwapXY);
								// add elements
								entsTsl.append(eMale);
								entsTsl.append(eFemale);
								
								// create 1st TSL
								tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
								
								ptsTsl[0] = pt2;
								// create 2nd TSL
								tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
							}
						}
					}// if (sTypes.find(sType) == 0)
					else if (sTypes.find(sType) == 1)
					{ 
//						reportMessage("\n"+ scriptName() + " nOnThis:"+nOnThis);
//						reportMessage("\n"+ scriptName() + " nOnOther:"+nOnOther);
						
						// Type PC is selected
						if ((nOnThis == 1 && nOnOther == 2))
						{ 
							// corner connection
							ElementWallSF eMale = el0;
							ElementWallSF eFemale = el1;
							// point at the outer corner
							Point3d pt = ptsOnThis[0];
							
						// create TSL
							TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
							GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {pt};
							int nProps[]={};			double dProps[]={};				String sProps[]={};
							Map mapTsl;	
							
							// start with flag 1
							mapTsl.setInt("iMode", 1);
							// add properties
							sProps.append(sType);
							//
							dProps.append(dDistanceBottom);
							dProps.append(dDistanceTop);
							dProps.append(dDistanceBetween);
							nProps.append(nNrParts);
							sProps.append(sSwapXY);
							// add elements
							entsTsl.append(eMale);
							entsTsl.append(eFemale);
							
							// create TSL
							tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
						}
						//
						if ((nOnThis == 2 && nOnOther == 1))
						{ 
							// corner connection
							ElementWallSF eMale = el1;
							ElementWallSF eFemale = el0;
							// point at outer side of corner
							Point3d pt = ptsOnOther[0];
							
						// create TSL
							TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
							GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {pt};
							int nProps[]={};			double dProps[]={};				String sProps[]={};
							Map mapTsl;	
							
							// start with flag 1
							mapTsl.setInt("iMode", 1);
							// add properties
							sProps.append(sType);
							//
							dProps.append(dDistanceBottom);
							dProps.append(dDistanceTop);
							dProps.append(dDistanceBetween);
							nProps.append(nNrParts);
							sProps.append(sSwapXY);
							// add elements
							entsTsl.append(eMale);
							entsTsl.append(eFemale);
							
							// create TSL
							tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
						}
						// 
						if ((nOnThis == 2 && nOnOther == 2))
						{ 
							// parallel connection
							ElementWallSF eMale = el1;
							ElementWallSF eFemale = el0;
							Point3d pt = ptsOnThis[0];
							if (vecZ0.dotProduct(vecZ1) < 0)
							{ 
								// parallel walls one oposite directions
								continue;
							}
							if (abs((pt - ptOrg0).dotProduct(vecZ0)) > abs((ptsOnThis[1] - ptOrg0).dotProduct(vecZ0)))
							{ 
								pt = ptsOnThis[1];
							}
							
						// create TSL
							TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
							GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {pt};
							int nProps[]={};			double dProps[]={};				String sProps[]={};
							Map mapTsl;	
							
							// start with flag 1
							mapTsl.setInt("iMode", 1);
							// add properties
							sProps.append(sType);
							//
							dProps.append(dDistanceBottom);
							dProps.append(dDistanceTop);
							dProps.append(dDistanceBetween);
							nProps.append(nNrParts);
							sProps.append(sSwapXY);
							// add elements
							entsTsl.append(eMale);
							entsTsl.append(eFemale);
							
							// create TSL
							tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
						}
					}
				}//next j
			}//next i
			
			// delete TSL
			eraseInstance();
			return;
		}
		
		// calculation part 
		if (_Element.length() != 2)
		{ 
			reportMessage(TN("|unexpected error|"));
			eraseInstance();
			return;
		}
		
	//	_Pt0 = _Element[0].ptOrg();
		
		iMode = _Map.getInt("iMode");
		// first is male beam
		ElementWallSF el0 = (ElementWallSF) _Element[0];
		Point3d ptOrg0 = el0.ptOrg();
		Vector3d vecX0 = el0.vecX();
		Vector3d vecY0 = el0.vecY();
		Vector3d vecZ0 = el0.vecZ();
		// second is female beam
		ElementWallSF el1 = (ElementWallSF) _Element[1];
		Point3d ptOrg1 = el1.ptOrg();
		Vector3d vecX1 = el1.vecX();
		Vector3d vecY1 = el1.vecY();
		Vector3d vecZ1 = el1.vecZ();
		
	// pt0 is where the intersection is located
		
		
		if (sTypes.find(sType) == 0)
		{ 
			// FAS is selected
		
		//region common range
			
			// get the common range
			PLine plEnvelope0 = el0.plEnvelope();
			// points in vertical vecY
			Point3d pts0[] = Line(_Pt0, vecY0).orderPoints(plEnvelope0.vertexPoints(true));
			pts0 = Line(_Pt0, vecY0).projectPoints(pts0);
			
			PLine plEnvelope1 = el1.plEnvelope();
			// points in vertical vecY
			Point3d pts1[] = Line(_Pt0, vecY1).orderPoints(plEnvelope1.vertexPoints(true));
			pts1 = Line(_Pt0, vecY1).projectPoints(pts1);
			
			Point3d ptMin = pts0.first();
			if (pts1.first().dotProduct(vecY0) > ptMin.dotProduct(vecY0))
			{ 
				ptMin = pts1.first();
			}
			Point3d ptMax = pts0.last();
			if (pts1.last().dotProduct(vecY0) < ptMax.dotProduct(vecY0))
			{ 
				ptMax = pts1.last();
			}
			ptMin.vis(3);
			ptMax.vis(3);
			
			if (ptMin.dotProduct(vecY0) >= ptMax.dotProduct(vecY0))
			{ 
				reportMessage(TN("|no common range|"));
				eraseInstance();
				return;
			}
			
		//End common range//endregion 
			
			
		//region common vector
			
			Vector3d vecY = vecZ0.crossProduct(vecZ1);
			vecY.normalize();
			if (vecY.dotProduct(vecY0) < 0)
			{ 
				vecY *= -1;
			}
			
		//End common vector//endregion 
			
			
		//region Display
			
			Display dp(7);
			PLine pl(vecY);
			pl.createCircle(_Pt0, vecY, U(60));
			PlaneProfile pp(pl);
			
			dp.draw(pp);
			dp.draw(pp, _kDrawFilled, 20);
			
		//End Display//endregion
			
			
		//region vectors pointing in direction of _Pt0
			
			Point3d ptStart0 = el0.zone(0).ptOrg();
			Point3d ptEnd0 = ptStart0 + el0.zone(0).vecZ() * el0.zone(0).dH();
			
			ptStart0.vis(4);
			ptEnd0.vis(4);
			
			Point3d ptStart1 = el1.zone(0).ptOrg();
			Point3d ptEnd1 = ptStart1 + el1.zone(0).vecZ() * el1.zone(0).dH();
			
			// vector of male el0 in direction of vecZ0 but pointing the direction of _Pt0
			Vector3d vecDir0 = vecZ0;
			if (abs((_Pt0 - ptStart0).dotProduct(vecZ0)) < abs((_Pt0 - ptEnd0).dotProduct(vecZ0)))
			{ 
				vecDir0 = - vecZ0;
			}
			Vector3d vecDir1 = vecZ1;
			if (abs((_Pt0 - ptStart1).dotProduct(vecZ1)) < abs((_Pt0 - ptEnd1).dotProduct(vecZ1)))
			{ 
				vecDir1 = - vecZ1;
			}
			
			vecDir0.vis(_Pt0);
			vecDir1.vis(_Pt0);
			
		//End vectors pointing in direction of _Pt0//endregion 
			
			
		//region side of xy
			
			int iSideSelected = sNoYes.find(sSwapXY);
			if (iSideSelected == 0)
			{ 
				iSideSelected = 1;
			}
			else
			{ 
				iSideSelected = -1;
			}
			
		//End side of xy//endregion	
			
			
		//region distribution
		
			double dPartLength = U(125);
			double dPartBottom = U(61.5);
			Point3d ptsDis[0];
			
			if (dDistanceBottom < 0)
			{ 
				dDistanceBottom.set(0);
			}
			if (dDistanceTop < 0)
			{ 
				dDistanceTop.set(0);
			}
			
			// by default calculate with dDistBetween
			
		//	if(_kNameLastChangedProp != sNrPartsName)
			if (dDistanceBetween >= 0)
			{ 
				// this calculation enters only if dDistanceBetween >= 0
				// otherwise the calculation based on the nNrParts will follow
				// area between start of first and start of last
				Point3d pt1 = ptMin + vecY0 * dDistanceBottom;
				Point3d pt2 = ptMax - vecY0 * (dDistanceTop + dPartLength);
				
				double dDistTot = (pt2 - pt1).dotProduct(vecY0);
				
				// modular distance
				double dDistMod = dDistanceBetween + dPartLength;
				
				// take only the full part from the integer
				int iNrParts = dDistTot / dDistMod;
				
				// calculated modular distance between subsequent parts
				double dDistModCalc = dDistTot / iNrParts;
				
				// first point
				Point3d pt;
				pt = ptMin + vecY * (dDistanceBottom + dPartBottom);
				pt.vis(1);
				ptsDis.append(pt);
				for (int i = 0; i < iNrParts; i++)
				{ 
					pt += vecY * dDistModCalc;
					pt.vis(1);
					ptsDis.append(pt);
				}
				
				// set calculated distance
				dDistanceBetween.set(dDistModCalc - dPartLength);
				// set nr parts
				nNrParts.set(iNrParts + 1);
			}
			
		//	if (_kNameLastChangedProp == sNrPartsName)
			if (dDistanceBetween < 0)
			{ 
				// area between start of first and start of last
				Point3d pt1 = ptMin + vecY0 * dDistanceBottom;
				Point3d pt2 = ptMax - vecY0 * (dDistanceTop + dPartLength);
				
				double dDistTot = (pt2 - pt1).dotProduct(vecY0);
				
				if (nNrParts < 2)
				{ 
					// at least 2 parts are needed
					nNrParts.set(2);
				}
				
				// modular distance between parts
				double dDistMod = dDistTot / (nNrParts - 1);
				// clear distance between parts
				double dDistBet = dDistMod - dPartLength;
				
				//
				double dDistModCalc = dDistMod;
				int nNrPartsCalc = nNrParts;
				
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
				pt = ptMin + vecY * (dDistanceBottom + dPartBottom);
				ptsDis.append(pt);
				pt.vis(1);
				for (int i = 0; i < (nNrPartsCalc - 1); i++)
				{ 
					pt += vecY * dDistModCalc;
					pt.vis(1);
					ptsDis.append(pt);
				}//next i
				
				// set distance between parts
				dDistanceBetween.set(dDistBet);
				// set the calculated nNrParts
				nNrParts.set(nNrPartsCalc);
			}
			
		//End distribution//endregion 
			
			
		//region create parts for each point
			
			GenBeam gbs0[] = el0.genBeam();
			GenBeam gbs1[] = el1.genBeam();
			// plane with normal in vecY
			Plane pnY(_Pt0, vecY);
			
			// delete existing distribution
			Entity entsTslExist[] = _Map.getEntityArray("entsTslNew", "", "");
			if (entsTslExist.length() > 0)
			{ 
				for (int i = entsTslExist.length() - 1; i >= 0; i--)
				{ 
					TslInst tsli = (TslInst)entsTslExist[i];
					if (tsli.bIsValid())
					{
						tsli.dbErase();
					}
				}//next i
			}
			// array of TSL entities
			Entity entsTslNew[0];
			for (int i = 0; i < ptsDis.length(); i++)
			{ 
				// point a little outside of the ploutline
				Point3d ptOut = ptsDis[i] + (vecDir0 + vecDir1) * dEps;
				// get the 2 genbeams from el0 and el1
				
				GenBeam gb0 = gbs0[0];
				GenBeam gb1 = gbs1[0];
				double dDist0 = 10e10;
				double dDist1 = 10e10;
				
				for (int ii = 0; ii < gbs0.length(); ii++)
				{ 
					// point in the plane pnY
					Point3d pt = pnY.closestPointTo(ptOut);
					// planeprofile of body of genBeam in pnY
					PlaneProfile pp = gbs0[ii].envelopeBody().shadowProfile(pnY);
					// distance from planeprifile
					double dd = (pt - pp.closestPointTo(pt)).length();
					
					if(dd<dDist0)
					{ 
						dDist0 = dd;
						gb0 = gbs0[ii];
					}
				}//next ii
				
				gb0.envelopeBody().vis(5);
				
				
				for (int ii = 0; ii < gbs1.length(); ii++)
				{ 
					// point in the plane pnY
					Point3d pt = pnY.closestPointTo(ptOut);
					// planeprofile of body of genBeam in pnY
					PlaneProfile pp = gbs1[ii].envelopeBody().shadowProfile(pnY);
					// distance from planeprifile
					double dd = (pt - pp.closestPointTo(pt)).length();
					
					if(dd<dDist1)
					{ 
						dDist1 = dd;
						gb1 = gbs1[ii];
					}
				}//next ii
				
				gb1.envelopeBody().vis(5);
				
				if ( ! gb0.bIsValid() || !gb1.bIsValid())
				{ 
					reportMessage(TN("|part can not be created|"));
				}
				
				// create hsbCullaenFAS
			// create TSL
				TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {ptsDis[i]};
				int nProps[]={};			double dProps[]={};				String sProps[]={};
				Map mapTsl;	
				
				//
				mapTsl.setInt("iSide" ,iSideSelected);
				
				// 2 genbeams
				gbsTsl.append(gb0);
				gbsTsl.append(gb1);
				
				
				tslNew.dbCreate("hsbCullenFAS" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				
				entsTslNew.append(tslNew);
			}//next i
			
			if (entsTslNew.length() > 0)
			{ 
				_Map.setEntityArray(entsTslNew, true, "entsTslNew", "", "");
			}
			
		//End create parts for each point//endregion 
				
			_Pt0.vis(2);
		}
		else if (sTypes.find(sType) == 1)
		{ 
		//region common range	
			// get the common range
			PLine plEnvelope0 = el0.plEnvelope();
			// points in vertical vecY
			Point3d pts0[] = Line(_Pt0, vecY0).orderPoints(plEnvelope0.vertexPoints(true));
			pts0 = Line(_Pt0, vecY0).projectPoints(pts0);
			
			PLine plEnvelope1 = el1.plEnvelope();
			// points in vertical vecY
			Point3d pts1[] = Line(_Pt0, vecY1).orderPoints(plEnvelope1.vertexPoints(true));
			pts1 = Line(_Pt0, vecY1).projectPoints(pts1);
			
			Point3d ptMin = pts0.first();
			if (pts1.first().dotProduct(vecY0) > ptMin.dotProduct(vecY0))
			{ 
				ptMin = pts1.first();
			}
			Point3d ptMax = pts0.last();
			if (pts1.last().dotProduct(vecY0) < ptMax.dotProduct(vecY0))
			{ 
				ptMax = pts1.last();
			}
	//		ptMin.vis(3);
	//		ptMax.vis(3);
			
			if (ptMin.dotProduct(vecY0) >= ptMax.dotProduct(vecY0))
			{ 
				reportMessage(TN("|no common range|"));
				eraseInstance();
				return;
			}
		//End common range//endregion 
		
		//region common vector
			
			Vector3d vecY;
			//checks if vectors parallel	
			if (abs(abs(vecZ0.dotProduct(vecZ1)) - 1) < dEps)
			{ 
				// parallel
				vecY = vecY0;
			}
			else
			{ 
				vecY = vecZ0.crossProduct(vecZ1);
				vecY.normalize();
				if (vecY.dotProduct(vecY0) < 0)
				{ 
					vecY *= -1;
				}
			}
			
		//End common vector//endregion 
		
		
		//region Display
			
			Display dp(7);
			PLine pl(vecY);
			pl.createCircle(_Pt0, vecY, U(60));
			PlaneProfile pp(pl);
			
			dp.draw(pp);
			dp.draw(pp, _kDrawFilled, 20);
			
		//End Display//endregion
		
		//region vectors pointing in direction of _Pt0
			
			Point3d ptStart0 = el0.zone(0).ptOrg();
			Point3d ptEnd0 = ptStart0 + el0.zone(0).vecZ() * el0.zone(0).dH();
			
			ptStart0.vis(4);
			ptEnd0.vis(4);
			
			Point3d ptStart1 = el1.zone(0).ptOrg();
			Point3d ptEnd1 = ptStart1 + el1.zone(0).vecZ() * el1.zone(0).dH();
			
			// vector of male el0 in direction of vecZ0 but pointing the direction of _Pt0
			Vector3d vecDir0 = vecZ0;
			if (abs((_Pt0 - ptStart0).dotProduct(vecZ0)) < abs((_Pt0 - ptEnd0).dotProduct(vecZ0)))
			{ 
				vecDir0 = - vecZ0;
			}
			Vector3d vecDir1 = vecZ1;
			if (abs((_Pt0 - ptStart1).dotProduct(vecZ1)) < abs((_Pt0 - ptEnd1).dotProduct(vecZ1)))
			{ 
				vecDir1 = - vecZ1;
			}
			// x vector of male wall pointing direction of male
			// x vector of female wall pointing direction of female
			Vector3d vecXmale = vecX0;
			{ 
				PLine plOutlineWall0 = el0.plOutlineWall();
				PlaneProfile ppOutlineWall0(plOutlineWall0);
			// get extents of profile
				LineSeg seg = ppOutlineWall0.extentInDir(vecX0);
				Point3d ptMiddle = seg.ptMid();
				if ((ptMiddle - _Pt0).dotProduct(vecXmale) < 0)
				{ 
					// vecxmale points toward the male wall
					vecXmale *= -1;
				}
			}
			Vector3d vecXfemale = -vecXmale;
			vecXmale.vis(_Pt0);
			vecXfemale.vis(_Pt0);
			
	//		vecDir0.vis(_Pt0);
	//		vecDir1.vis(_Pt0);
			
		//End vectors pointing in direction of _Pt0//endregion 
		
		//region side of xy
			
			int iSideSelected = sNoYes.find(sSwapXY);
			if (iSideSelected == 0)
			{ 
				iSideSelected = 1;
			}
			else
			{ 
				iSideSelected = -1;
			}
			
		//End side of xy//endregion	
		
		
		//region distribution
		
			double dPartLength = U(180);
			double dPartBottom = U(90);
			Point3d ptsDis[0];
			
			if (dDistanceBottom < 0)
			{ 
				dDistanceBottom.set(0);
			}
			if (dDistanceTop < 0)
			{ 
				dDistanceTop.set(0);
			}
			
			// by default calculate with dDistBetween
			
		//	if(_kNameLastChangedProp != sNrPartsName)
			if (dDistanceBetween >= 0)
			{ 
				// this calculation enters only if dDistanceBetween >= 0
				// otherwise the calculation based on the nNrParts will follow
				if (dDistanceBetween < 0)
				{ 
					dDistanceBetween.set(0);
				}
				// area between start of first and start of last
				Point3d pt1 = ptMin + vecY0 * dDistanceBottom;
				Point3d pt2 = ptMax - vecY0 * (dDistanceTop + dPartLength);
				
				double dDistTot = (pt2 - pt1).dotProduct(vecY0);
				
				// modular distance
				double dDistMod = dDistanceBetween + dPartLength;
				
				// take only the full part from the integer
				int iNrParts = dDistTot / dDistMod;
				
				// calculated modular distance between subsequent parts
				double dDistModCalc = dDistTot / iNrParts;
				
				// first point
				Point3d pt;
				pt = ptMin + vecY * (dDistanceBottom + dPartBottom);
	//			pt.vis(1);
				ptsDis.append(pt);
				for (int i = 0; i < iNrParts; i++)
				{ 
					pt += vecY * dDistModCalc;
	//				pt.vis(1);
					ptsDis.append(pt);
				}
				
				// set calculated distance
				dDistanceBetween.set(dDistModCalc - dPartLength);
				// set nr parts
				nNrParts.set(iNrParts + 1);
			}
			
		//	if (_kNameLastChangedProp == sNrPartsName)
			if (dDistanceBetween < 0)
			{ 
				// area between start of first and start of last
				Point3d pt1 = ptMin + vecY0 * dDistanceBottom;
				Point3d pt2 = ptMax - vecY0 * (dDistanceTop + dPartLength);
				
				double dDistTot = (pt2 - pt1).dotProduct(vecY0);
				
				if (nNrParts < 2)
				{ 
					// at least 2 parts are needed
					nNrParts.set(2);
				}
				
				// modular distance between parts
				double dDistMod = dDistTot / (nNrParts - 1);
				// clear distance between parts
				double dDistBet = dDistMod - dPartLength;
				
				//
				double dDistModCalc = dDistMod;
				int nNrPartsCalc = nNrParts;
				
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
				pt = ptMin + vecY * (dDistanceBottom + dPartBottom);
				ptsDis.append(pt);
	//			pt.vis(1);
				for (int i = 0; i < (nNrPartsCalc - 1); i++)
				{ 
					pt += vecY * dDistModCalc;
	//				pt.vis(1);
					ptsDis.append(pt);
				}//next i
				
				// set distance between parts
				dDistanceBetween.set(dDistBet);
				// set the calculated nNrParts
				nNrParts.set(nNrPartsCalc);
			}
			
		//End distribution//endregion 
		
		
		//region create parts for each point
			
			GenBeam gbs0[] = el0.genBeam();
			GenBeam gbs1[] = el1.genBeam();
			// plane with normal in vecY
			Plane pnY(_Pt0, vecY);
			// pnZ is set with the male element (wall)
			Plane pnZ(_Pt0, vecZ0);
			// delete existing distribution
			Entity entsTslExist[] = _Map.getEntityArray("entsTslNew", "", "");
			if (entsTslExist.length() > 0)
			{ 
				for (int i = entsTslExist.length() - 1; i >= 0; i--)
				{ 
					TslInst tsli = (TslInst)entsTslExist[i];
					if (tsli.bIsValid())
					{
						tsli.dbErase();
					}
				}//next i
			}
			// array of TSL entities
			Entity entsTslNew[0];
			for (int i = 0; i < ptsDis.length(); i++)
			{ 
				// point a little outside of the ploutline
				Point3d ptOut = ptsDis[i] + (vecDir0 + vecDir1) * dEps;
				Point3d ptOutMale = ptsDis[i] + vecDir0 * 100*dEps + vecXmale * U(5);
				Point3d ptOutFemale = ptsDis[i] + vecDir0 * dEps + vecXfemale * U(5);
	//			ptOutMale.vis(2);
	//			ptOutFemale.vis(2);
				
				// get the 2 genbeams from el0 and el1
				GenBeam gb0 = gbs0[0];
				GenBeam gb1 = gbs1[0];
				// distance at the projected horizontal plane
				double dDist0 = 10e10;
				double dDist1 = 10e10;
				// distance at the projected verticla plane
				double dDist0Vert = 10e10;
				double dDist1Vert = 10e10;
				
				for (int ii = 0; ii < gbs0.length(); ii++)
				{ 
					// point in the plane pnY
					Point3d pt = pnY.closestPointTo(ptOutMale);
					pt.vis(3);
					// planeprofile of body of genBeam in pnY
					PlaneProfile pp = gbs0[ii].envelopeBody().shadowProfile(pnY);
					// horizontal distance from planeprofile 
	//				pp.vis(1);
	//				Point3d p1 = pp.closestPointTo(pt);
	//				p1.vis(4);
					double dd = (pt - pp.closestPointTo(pt)).length();
					// vertical distance
					PlaneProfile ppVert = gbs0[ii].envelopeBody().shadowProfile(pnZ);
					double ddVer = (pt - ppVert.closestPointTo(pt)).length();
					
					if (ppVert.pointInProfile(ptOutMale) != _kPointInProfile)
					{ 
						// point can not see the profile
						continue;
					}
					if(dd<=dDist0)
					{ 
	//					pp.vis(1);
	//					p1.vis(4);
						dDist0 = dd;
						gb0 = gbs0[ii];
					}
				}//next ii
				
				gb0.envelopeBody().vis(1);
				for (int ii = 0; ii < gbs1.length(); ii++)
				{ 
					// point in the plane pnY
					Point3d pt = pnY.closestPointTo(ptOutFemale);
					// planeprofile of body of genBeam in pnY
					PlaneProfile pp = gbs1[ii].envelopeBody().shadowProfile(pnY);
					// distance from planeprifile
					double dd = (pt - pp.closestPointTo(pt)).length();
					PlaneProfile ppVert = gbs1[ii].envelopeBody().shadowProfile(pnZ);
					if (ppVert.pointInProfile(ptOutFemale) != _kPointInProfile)
					{ 
						// point can not see the profile
						continue;
					}
					if(dd<dDist1)
					{ 
						dDist1 = dd;
						gb1 = gbs1[ii];
					}
				}//next ii
				
				gb1.envelopeBody().vis(1);
				if ( ! gb0.bIsValid() || !gb1.bIsValid())
				{ 
					reportMessage(TN("|part can not be created|"));
				}
				
				// create hsbCullaenFAS
			// create TSL
				TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {ptsDis[i]};
				int nProps[]={};			double dProps[]={};				String sProps[]={};
				Map mapTsl;	
				
				// set iside
				mapTsl.setInt("iSide" ,iSideSelected);
				
				// 2 genbeams
				gbsTsl.append(gb0);
				gbsTsl.append(gb1);
				
				
				tslNew.dbCreate("hsbCullenPC" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				
				entsTslNew.append(tslNew);
			}//next i
			
			if (entsTslNew.length() > 0)
			{ 
				_Map.setEntityArray(entsTslNew, true, "entsTslNew", "", "");
			}
			
		//End create parts for each point//endregion 
		}
	}
	else if(sTypes.find(sType) == 2)
	{ 
		// distribution for each wall in horizontal 
		//"ST-PFS" is choosen
		if (_Element.length() == 0)
		{ 
			reportMessage(TN("|no element found|"));
			eraseInstance();
			return;
		}
		int iMode = _Map.getInt("iMode");
		if (iMode == 0)
		{
			iMode = 1;
			_Map.setInt("iMode", iMode);
			
			for (int i = 0; i < _Element.length(); i++)
			{ 
				// create TSL
				TslInst tslNew;			Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {};	Entity entsTsl[] = {};	Point3d ptsTsl[] = {_Pt0};
				int nProps[]={};		double dProps[]={};		String sProps[]={};
				Map mapTsl;
				
				// start with flag 1
				mapTsl.setInt("iMode", 1);
				// add properties
				sProps.append(sType);
				//
				dProps.append(dDistanceBottom);
				dProps.append(dDistanceTop);
				dProps.append(dDistanceBetween);
				nProps.append(nNrParts);
				sProps.append(sSwapXY);
				// add elements
				entsTsl.append(_Element[i]);
//				reportMessage(TN("|distribution ongoing|"));
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				
			}//next i
			
			// delete TSL
			eraseInstance();
			return; 
		}
		// mode 1
		// calculation part
		// distribution is finished, calculation for a single element
		iMode = _Map.getInt("iMode");
//		reportMessage(TN("|calculation for each element|"));
		
		if (_Element.length() != 1)
		{ 
			reportMessage(TN("|unexpected error|"));
			eraseInstance();
			return;
		}
		
		Element el = _Element[0];
		Vector3d vecX = el.vecX();
		Vector3d vecY = el.vecY();
		Vector3d vecZ = el.vecZ();
		Point3d ptOrg = el.ptOrg();
		
		Beam beamsAll[] = el.beam();
		// vertical studs
		Beam beamsVert[] = vecX.filterBeamsPerpendicularSort(beamsAll);
		
		// project points in line and order them	
		// order alphabetically
		for (int i=0;i<beamsVert.length();i++) 
			for (int j=0;j<beamsVert.length()-1;j++) 
				if (beamsVert[j].ptCen().dotProduct(vecX)>beamsVert[j+1].ptCen().dotProduct(vecX))
					beamsVert.swap(j, j + 1);
		
		
		if (dDistanceBottom < 0)dDistanceBottom.set(0);
		if (dDistanceTop < 0)dDistanceTop.set(0);
//		if (dDistanceBetween <= 0)dDistanceBetween.set(dEps);
		if (dDistanceBetween <= 0)
		{ 
			if (nNrParts <= 0)
			{ 
				// set minimum 1
				nNrParts == 1;
			}
		}
		
		// do the distribution
		// start and end beam of the distribution
		Beam beamStart, beamEnd;
		
		Point3d ptStart = beamsVert[0].ptCen() + vecX * dDistanceBottom;
		Point3d ptEnd = beamsVert.last().ptCen() - vecX * dDistanceTop;
		ptStart.vis(1);
		ptEnd.vis(1);
		
		double dDistStartBeam = 10e6;
		double dDistEndBeam = 10e6;
		
		for (int ii=0;ii<beamsVert.length();ii++) 
		{ 
			Beam bm = beamsVert[ii];
			if(abs((bm.ptCen()-ptStart).dotProduct(vecX))<dDistStartBeam)
			{ 
				dDistStartBeam = abs((bm.ptCen() - ptStart).dotProduct(vecX));
				beamStart = bm;
			}
			
			if(abs((bm.ptCen()-ptEnd).dotProduct(vecX))<dDistEndBeam)
			{ 
				dDistEndBeam = abs((bm.ptCen() - ptEnd).dotProduct(vecX));
				beamEnd = bm;
			}
			 
		}//next ii
		beamStart.envelopeBody().vis(2);
		beamEnd.envelopeBody().vis(2);
		
		if ((beamEnd.ptCen() - beamStart.ptCen()).dotProduct(vecX) < 0 ||(dDistanceBetween <= 0 && nNrParts==1))
		{ 
			// create only for this
			// create TSL
			TslInst tslNew;			Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};	Entity entsTsl[] = {};	Point3d ptsTsl[] = {_Pt0};
			int nProps[]={};		double dProps[]={};		String sProps[]={};
			Map mapTsl;	
			// 
			gbsTsl.append(beamStart);

			tslNew.dbCreate("hsbCullenSt" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			eraseInstance();
			return;
		}
		double dDistanceBetweenCalc = dDistanceBetween;
		if (dDistanceBetween <= 0)
		{ 
			// calculation for nNrParts
			double dd = ((beamEnd.ptCen() - beamStart.ptCen()).dotProduct(vecX));
			if(nNrParts>1)
			dDistanceBetweenCalc = dd / (nNrParts - 1);
		}
		
		Beam beamsVertRemain[0];
		beamsVertRemain.append(beamsVert);
		beamsVertRemain.removeAt(beamsVertRemain.find(beamStart));
//		beamsVertRemain.removeAt(beamsVertRemain.find(beamEnd));
		
		Beam beamsDistribution[0];
		beamsDistribution.append(beamStart);
		beamsDistribution.append(beamEnd);
		
		
		Point3d pt = beamStart.ptCen();
		pt.vis(4);
		int iCount = 0;
		int iStop = 0;
		while (iCount < 100 && !iStop)
		{ 
			iCount++;
			pt += vecX * dDistanceBetweenCalc;
			// find beam
			Beam beamFound;
			double dDist = 10e6;
			for (int ii=0;ii<beamsVertRemain.length();ii++) 
			{ 
				Beam bm = beamsVertRemain[ii];
				if(abs((bm.ptCen()-pt).dotProduct(vecX))<dDist)
				{ 
					dDist = abs((bm.ptCen() - pt).dotProduct(vecX));
					beamFound = bm;
				}
			}
			if ((beamFound.ptCen() - beamEnd.ptCen()).dotProduct(vecX) > 0)
			{ 
				break;
			}
			if (beamFound == beamEnd )
			{ 
				break;
			}
			beamsDistribution.append(beamFound);
			beamsVertRemain.removeAt(beamsVertRemain.find(beamFound));
			pt = beamFound.ptCen();
			pt.vis(4);
			beamFound.envelopeBody().vis(4);
			
			if(beamsVertRemain.length()==0)
			{ 
				break;
			}
		}
		_Pt0 = ptOrg;
		
		// create tsl for each beamsDistribution
		for (int ii = 0; ii < beamsDistribution.length(); ii++)
		{ 
			// call the tsl
			// create TSL
			TslInst tslNew;			Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};	Entity entsTsl[] = {};	Point3d ptsTsl[] = {_Pt0};
			int nProps[]={};		double dProps[]={};		String sProps[]={};
			Map mapTsl;	
			// 
			gbsTsl.append(beamsDistribution[ii]);

			tslNew.dbCreate("hsbCullenSt" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
		}//next ii
	}
	else if(sTypes.find(sType)==3)
	{ 
		// GA is selected
		// prompt selection of a beam or sheet
		// prompt for beams
		
		if(_Sheet.length()>0)
		{ 
			// sheet is selected
			Sheet sh = _Sheet[0];
			Element el = sh.element();
			// distribution only for horizontal beam
			Vector3d vecX = el.vecX();
			Vector3d vecY = el.vecY();
			Vector3d vecZ = el.vecZ();
			// get all sheets of zone of sh
			Sheet sheets[0];
			int iZones[] ={ -5 ,- 4 ,- 3 ,- 2 ,- 1, 1, 2, 3, 4, 5};
			for (int i = 0; i < iZones.length(); i++)
			{ 
				Sheet sheetsZone[] = el.sheet(iZones[i]);
				if(sheetsZone.find(sh)>-1)
				{ 
					sheets.append(sheetsZone);
					break;
				}
			}//next i
			
			if (sheets.length() == 0)
			{ 
				reportMessage(TN("|unexpected error|"));
				eraseInstance();
				return;
			}
//			return;
			// get pp
			PlaneProfile pp(el.coordSys());
			PlaneProfile pps[0];
			for (int i=0;i<sheets.length();i++) 
			{ 
				pp.joinRing(sheets[i].plEnvelope(), _kAdd);
				PlaneProfile ppi(el.coordSys());
				ppi.joinRing(sheets[i].plEnvelope(), _kAdd);
				pps.append(ppi);
			}//next i
			pp.vis(1);
			Line ln(_Pt0, vecX);
			// get extents of profile
			LineSeg seg = pp.extentInDir(vecX);
			Point3d ptMin = seg.ptStart();ptMin = ln.closestPointTo(ptMin);
			Point3d ptMax = seg.ptEnd();ptMax = ln.closestPointTo(ptMax);
			if((ptMax-ptMin).dotProduct(vecX)<0)
			{ 
				ptMin = seg.ptEnd();
				ptMax = seg.ptStart();
			}
			
			ptMin.vis(1);
			ptMax.vis(1);
			// distribute along the beam
			double dPartLength = U(100);
			double dPartBottom = U(50);
			Point3d ptsDis[0];
			
			if (dDistanceBottom < 0)
			{ 
				dDistanceBottom.set(0);
			}
			if (dDistanceTop < 0)
			{ 
				dDistanceTop.set(0);
			}
			
			if (dDistanceBetween >= 0)
			{ 
				// this calculation enters only if dDistanceBetween >= 0
				// otherwise the calculation based on the nNrParts will follow
				// area between start of first and start of last
				Point3d pt1 = ptMin + vecX * dDistanceBottom;pt1.vis(1);
				Point3d pt2 = ptMax - vecX * (dDistanceTop + dPartLength);pt2.vis(1);
				
				double dDistTot = (pt2 - pt1).dotProduct(vecX);
				
				// modular distance
				double dDistMod = dDistanceBetween + dPartLength;
				
				// take only the full part from the integer
				int iNrParts = dDistTot / dDistMod;
				
				// calculated modular distance between subsequent parts
				double dDistModCalc = dDistTot / iNrParts;
				
				// first point
				Point3d pt;
				pt = ptMin + vecX * (dDistanceBottom + dPartBottom);
				pt.vis(1);
				ptsDis.append(pt);
				for (int i = 0; i < iNrParts; i++)
				{ 
					pt += vecX * dDistModCalc;
					pt.vis(1);
					ptsDis.append(pt);
				}
				
				// set calculated distance
				dDistanceBetween.set(dDistModCalc - dPartLength);
				// set nr parts
				nNrParts.set(iNrParts + 1);
			}
			if (dDistanceBetween < 0)
			{ 
				// area between start of first and start of last
				Point3d pt1 = ptMin + vecX * dDistanceBottom;pt1.vis(1);
				Point3d pt2 = ptMax - vecX * (dDistanceTop + dPartLength);pt2.vis(1);
				
				double dDistTot = (pt2 - pt1).dotProduct(vecX);
				
				if (nNrParts < 2)
				{ 
					// at least 2 parts are needed
					nNrParts.set(2);
				}
				
				// modular distance between parts
				double dDistMod = dDistTot / (nNrParts - 1);
				// clear distance between parts
				double dDistBet = dDistMod - dPartLength;
				
				//
				double dDistModCalc = dDistMod;
				int nNrPartsCalc = nNrParts;
				
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
				pt = ptMin + vecX * (dDistanceBottom + dPartBottom);
				ptsDis.append(pt);
				pt.vis(1);
				for (int i = 0; i < (nNrPartsCalc - 1); i++)
				{ 
					pt += vecX * dDistModCalc;
					pt.vis(1);
					ptsDis.append(pt);
				}//next i
				
				// set distance between parts
				dDistanceBetween.set(dDistBet);
				// set the calculated nNrParts
				nNrParts.set(nNrPartsCalc);
			}
			// distribute for each point from ptsDis
			for (int i = 0; i < ptsDis.length(); i++)
			{ 
				// create TSL
				TslInst tslNew;			Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {};	Entity entsTsl[] = {};	Point3d ptsTsl[] = {ptsDis[i], ptsDis[i]};
				int nProps[]={};		double dProps[]={};		String sProps[]={};
				Map mapTsl;
				
				Sheet shFound;
				//get the sheet
				for (int ii=0;ii<pps.length();ii++) 
				{ 
					PlaneProfile ppi = pps[ii];
					ppi.shrink(-dEps);
				// get extents of profile
					LineSeg seg = ppi.extentInDir(vecX);
					double dSum=abs((seg.ptStart()-ptsDis[i]).dotProduct(vecX))
								 + abs((seg.ptEnd() - ptsDis[i]).dotProduct(vecX));
					if(dSum<=abs((seg.ptStart()-seg.ptEnd()).dotProduct(vecX)))
					{ 
						shFound = sheets[ii];
						break;
					}
				}//next ii
				
				if(!shFound.bIsValid())
				{ 
					reportMessage(TN("|unexpected error|"));
					eraseInstance();
					return;
				}
				
				gbsTsl.append(shFound);
				// tolerance
				dProps.append(0);
				// manufacturer, family, model, nail
				sProps.append("Cullen Metal Angle Bracket");
				sProps.append("SP");
				sProps.append("SP-100x100x50");
				sProps.append("screw+square twist nails");
				
				tslNew.dbCreate("GA" , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, 
								nProps, dProps, sProps, _kModelSpace, mapTsl);
			}//next i
			
		}
		else if (_Beam.length() > 0)
		{ 
			// beam is selected
			Beam bm = _Beam[0];
			Beam bms[0];bms.append(bm);
			Element el = bm.element();
			// distribution only for horizontal beam
			Vector3d vecX;
			Vector3d vecY;
			Vector3d vecZ;
			// HSB-20921
			int bSolePlate=bm.name().find("soleplate",-1,false)>-1;
			if(el.bIsValid())
			{ 
				vecX = el.vecX();
				vecY = el.vecY();
				vecZ = el.vecZ();
			}
			else if(!el.bIsValid())
			{ 
				vecX = bm.vecX();
				vecY = bm.vecD(_ZW);
				vecZ=vecX.crossProduct(vecY);
			}
			Beam bmHorizontals[] = vecY.filterBeamsPerpendicularSort(bms);
			if(bmHorizontals.length()==0)
			{ 
				reportMessage(TN("|only horizontal beams are allowed for inserting distribution|"));
				eraseInstance();
				return;
			}
//			return;
			Line ln(_Pt0, vecX);
			Point3d ptMin = bm.ptCen() - .5 * bm.solidLength() * vecX;ptMin = ln.closestPointTo(ptMin);
			Point3d ptMax = bm.ptCen() + .5 * bm.solidLength() * vecX;ptMax = ln.closestPointTo(ptMax);
			
			// distribute along the beam
			double dPartLength = U(100);
			double dPartBottom = U(50);
			Point3d ptsDis[0];
			
			if (dDistanceBottom < 0)
			{ 
				dDistanceBottom.set(0);
			}
			if (dDistanceTop < 0)
			{ 
				dDistanceTop.set(0);
			}
			
			if (dDistanceBetween >= 0)
			{ 
				// this calculation enters only if dDistanceBetween >= 0
				// otherwise the calculation based on the nNrParts will follow
				// area between start of first and start of last
				Point3d pt1 = ptMin + vecX * dDistanceBottom;pt1.vis(1);
				Point3d pt2 = ptMax - vecX * (dDistanceTop + dPartLength);pt2.vis(1);
				
				double dDistTot = (pt2 - pt1).dotProduct(vecX);
				
				// modular distance
				double dDistMod = dDistanceBetween + dPartLength;
				
				// take only the full part from the integer
				int iNrParts = dDistTot / dDistMod;
				
				// calculated modular distance between subsequent parts
				double dDistModCalc = dDistTot / iNrParts;
				
				// first point
				Point3d pt;
				pt = ptMin + vecX * (dDistanceBottom + dPartBottom);
				pt.vis(1);
				ptsDis.append(pt);
				for (int i = 0; i < iNrParts; i++)
				{ 
					pt += vecX * dDistModCalc;
					pt.vis(1);
					ptsDis.append(pt);
				}
				
				// set calculated distance
				dDistanceBetween.set(dDistModCalc - dPartLength);
				// set nr parts
				nNrParts.set(iNrParts + 1);
			}
			if (dDistanceBetween < 0)
			{ 
				// area between start of first and start of last
				Point3d pt1 = ptMin + vecX * dDistanceBottom;pt1.vis(1);
				Point3d pt2 = ptMax - vecX * (dDistanceTop + dPartLength);pt2.vis(1);
				
				double dDistTot = (pt2 - pt1).dotProduct(vecX);
				
				if (nNrParts < 2)
				{ 
					// at least 2 parts are needed
					nNrParts.set(2);
				}
				
				// modular distance between parts
				double dDistMod = dDistTot / (nNrParts - 1);
				// clear distance between parts
				double dDistBet = dDistMod - dPartLength;
				
				//
				double dDistModCalc = dDistMod;
				int nNrPartsCalc = nNrParts;
				
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
				pt = ptMin + vecX * (dDistanceBottom + dPartBottom);
				ptsDis.append(pt);
				pt.vis(1);
				for (int i = 0; i < (nNrPartsCalc - 1); i++)
				{ 
					pt += vecX * dDistModCalc;
					pt.vis(1);
					ptsDis.append(pt);
				}//next i
				
				// set distance between parts
				dDistanceBetween.set(dDistBet);
				// set the calculated nNrParts
				nNrParts.set(nNrPartsCalc);
			}
			// distribute for each point from ptsDis
//			return;
			for (int i = 0; i < ptsDis.length(); i++)
			{ 
				// create TSL
				TslInst tslNew;			Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {};	Entity entsTsl[] = {};	Point3d ptsTsl[] = {ptsDis[i], ptsDis[i]};
				int nProps[]={};		double dProps[]={};		String sProps[]={};
				Map mapTsl;
				gbsTsl.setLength(0);
				gbsTsl.append(bm);
				// tolerance
				dProps.setLength(0);
				dProps.append(0);
				// manufacturer, family, model, nail
				sProps.setLength(0);
//				sProps.append("Cullen Metal Angle Bracket");
				sProps.append("Cullen UK");
				sProps.append("SP");
				sProps.append("SP-100x100x50");
				sProps.append("screw+square twist nails");
				if(bSolePlate)
				{ 
					// HSB-20921
					sProps.append(T("|female|"));
					dProps[0]=-dOffsetAngleBracket;
				}
				
				tslNew.dbCreate("GA" , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, 
								nProps, dProps, sProps, _kModelSpace, mapTsl);
				if(tslNew.bIsValid() && bSolePlate)
				{ 
					tslNew.setPropString(4,T("|female|"));
					tslNew.setPropDouble(0,-dOffsetAngleBracket);
				}
			}//next i
		}
	}
	
// delete instance after the generation
eraseInstance();
return;


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
        <int nm="BreakPoint" vl="1475" />
        <int nm="BreakPoint" vl="1509" />
        <int nm="BreakPoint" vl="1717" />
        <int nm="BreakPoint" vl="1845" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20921: Add offset property for GA at soleplate" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="9/13/2024 6:06:20 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End