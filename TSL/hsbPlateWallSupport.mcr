#Version 8
#BeginDescription
#Versions:
Version 1.35 15/07/2025 HSB-24281: Set name and grade at created beams , Author Marsel Nakuci
1.34 23.01.2024 HSB-21189: Include beams at the wall envelope
1.33 02.02.2023 HSB-17747: Replace "T-Einfräsung" with "T-Connection"
1.32 18.11.2022 HSB-17096: Fix catalog for "T-Einfräsung"
1.31 11.10.2022 HSB-16751: Add property to control Stud-Plate milling
version value="1.30" date="20okt21" author="marsel.nakuci@hsbcad.com" 
HSB-13545: on "reset" and "reset and delete" beam trigger must be active
HSB-13545: regeneration of construction only when properties are changed or when manually triggered
HSB-9641: beam UCS same as existing beams, improve symbol
HSB-5977: set type to readonly after insert </version> 
HSB-5977: fix bug at beamcut on right 
HSB-5977: store analysed cut for type 4 
Description purged

Select walls, select main beams enter properties gap and type of connection and press OK

This tsl creates connection beteen SF walls and main beams Pfette intersecting the walls
There are 3 types of connection that can be selected at the properties
if the top beam of the wall is intersected by the main beam Pfette then the top beam
will be split into 2 parts
If the new created vertical beams of the support, intersect the existing beams of the 
sf wall, the beams of existing sf wall are removed
Two user defined commands are defined  
Reset - wil delete the generated beams of the connection and join the previously splitted beams
Reset and Delete - will reset and delete the TSL instance.

If one of the cataloges at the property "catalog sheet cut out" is selected then the 
TSL "hsbPlateWallSheetCut" is called and the sheets are cut out. In this property 
it can be selected one of the catalogues previously save. The sheet cutting is done only in 
bOnInsert and can not be modified later on.







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 35
#KeyWords stick, frame, wall, sf, rubner, Pfette, support
#BeginContents
/// <History>//region
/// #Versions:
// 1.35 15/07/2025 HSB-24281: Set name and grade at created beams , Author Marsel Nakuci
// 1.34 23.01.2024 HSB-21189: Include beams at the wall envelope Author: Marsel Nakuci
// 1.33 02.02.2023 HSB-17747: Replace "T-Einfräsung" with "T-Connection" Author: Marsel Nakuci
// 1.32 18.11.2022 HSB-17096: Fix catalog for "T-Einfräsung" Author: Marsel Nakuci
// 1.31 11.10.2022 HSB-16751: Add property to control Stud-Plate milling Author: Marsel Nakuci
/// <version value="1.30" date="20okt21" author="marsel.nakuci@hsbcad.com"> HSB-13545: on "reset" and "reset and delete" beam trigger must be active </version>
/// <version value="1.29" date="19okt21" author="marsel.nakuci@hsbcad.com"> HSB-13545: regeneration of construction only when properties are changed or when manually triggered </version>
/// <version value="1.28" date="09nov20" author="marsel.nakuci@hsbcad.com"> HSB-9641: beam UCS same as existing beams, improve symbol </version>
/// <version value="1.27" date="24.01.2019" author="marsel.nakuci@hsbcad.com"> HSB-5977: set type to readonly after insert </version>
/// <version value="1.26" date="21.11.2019" author="marsel.nakuci@hsbcad.com"> HSB-5977: fix bug at beamcut on right </version>
/// <version value="1.25" date="19.11.2019" author="marsel.nakuci@hsbcad.com"> HSB-5977: store analysed cut for type 4 </version>
/// <version value="1.24" date="19.11.2019" author="marsel.nakuci@hsbcad.com"> HSB-5977: comments in yt case </version>
/// <version value="1.23" date="22oct2019" author="thorsten.huck@hsbcad.com"> Description purged </version>
/// <version value="1.22" date="17.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5769 email Do 17.10.2019 10:00 </version>
/// <version value="1.21" date="17.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5769 consider opening for type 2 </version>
/// <version value="1.20" date="16.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5769 beams at type 2 only created when they are not found </version>
/// <version value="1.19" date="16.10.2019" author="marsel.nakuci@hsbcad.com"> change tsl picture for type 2, no horizontal beam anymore;dont save points of cuts in map as absolute, problem during copying </version>
/// <version value="1.18" date="15.10.2019" author="marsel.nakuci@hsbcad.com"> HSBCAD-466 fix from email Do 10.10.2019 14:49 </version>
/// <version value="1.17" date="14.10.2019" author="marsel.nakuci@hsbcad.com"> HSBCAD-466 fix from email Do 10.10.2019 14:49 </version>
/// <version value="1.16" date="26.09.2019" author="marsel.nakuci@hsbcad.com"> HSBCAD-466 improve placement of beams for typ 2 </version>
/// <version value="1.15" date="25.09.2019" author="marsel.nakuci@hsbcad.com"> HSBCAD-466 for typ 2, distribution starts from the middle and gap is created by applying beamcut </version>
/// <version value="1.14" date="25.09.2019" author="marsel.nakuci@hsbcad.com"> HSBCAD-466 add beamcut for typ 2 </version>
/// <version value="1.13" date="25.09.2019" author="marsel.nakuci@hsbcad.com"> HSBCAD-466 dont allow duplication of TSL, pass over property sTopOpen when creating TSL, when element is regenerated return and wait until it gets generated, create milling between newBeamLeft and top beam, support when there is opening below  </version>
/// <version value="1.12" date="24.09.2019" author="marsel.nakuci@hsbcad.com"> HSBCAD-466 prompt only selection of beams(pfete and at least a beam of wall); dont prompt selection of wall envelope, not practical </version>
/// <version value="1.11" date="13May2019" author="marsel.nakuci@hsbcad.com"> HSBCAD-466 bug fix when joining skew topn beams  </version>
/// <version value="1.10" date="10May2019" author="marsel.nakuci@hsbcad.com"> HSBCAD-466 add proprty Oben Offen </version>
/// <version value="1.9" date="06May2019" author="marsel.nakuci@hsbcad.com"> include description for the "hsbPlateWallSheetCut" </version>
/// <version value="1.8" date="06May2019" author="marsel.nakuci@hsbcad.com"> change TSL pisture </version>
/// <version value="1.7" date="06May2019" author="marsel.nakuci@hsbcad.com"> call in boninsert hsbPlateWallSheetCut to cut the sheets </version>
/// <version value="1.6" date="02May2019" author="marsel.nakuci@hsbcad.com"> fix bug in iBeamTrigger=true </version>
/// <version value="1.5" date="30Apr2019" author="marsel.nakuci@hsbcad.com"> consider openings underneath </version>
/// <version value="1.4" date="27Mar2019" author="marsel.nakuci@hsbcad.com"> change claculation </version>
/// <version value="1.3" date="26Mar2019" author="marsel.nakuci@hsbcad.com"> cleanup + safer </version>
/// <version value="1.2" date="06Mar2019" author="marsel.nakuci@hsbcad.com"> Picture + fixes </version>
/// <version value="1.1" date="05Mar2019" author="marsel.nakuci@hsbcad.com"> Add capabilities like dependencies </version>
/// <version value="1.0" date="07Feb2019" author="marsel.nakuci@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select walls, select main beams enter properties describing the gap, type of connection and 
/// the cataloge for the cutting of the sheets and press OK.
/// </insert>

/// <summary Lang=en>
/// This tsl creates connection beteen SF walls and main beams Pfette intersecting the walls
/// There are 3 types of connection that can be selected at the properties
/// if the top beam of the wall is intersected by the main beam Pfette then the top beam
/// will be split into 2 parts
/// If the new created vertical beams of the support, intersect the existing beams of the 
/// sf wall, the beams of existing sf wall are removed
/// Two user defined commands are defined.
/// Reset - wil delete the generated beams of the connection and join the previously splitted beams
/// Reset and Delete - will reset and delete the TSL instance

/// If one of the cataloges at the property "catalog sheet cut out" is selected then the 
/// TSL "hsbPlateWallSheetCut" is called and the sheets are cut out. In this property 
/// it can be selected one of the catalogues previously save. The sheet cutting is done only in 
/// bOnInsert and can not be modified later on.
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbPlateWallSupport")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Reset|") (_TM "|Select Tool|"))) TSLCONTENT
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
	// gap between pfette and the vertical beam 
	String sGapName=T("|Gap|");	
	PropDouble dGap(nDoubleIndex++, U(0), sGapName);
	dGap.setDescription(T("|Defines the Gap|"));
	dGap.setCategory(category);
	
	// modeling types of the connection
	String sTypes[] ={ T("|Type| 1 "), T("|Type| 2"), T("|Type| 3"), T("|Type| 4")};
	String sTypeName=T("|Types| (A)");	
	PropString sType(nStringIndex++, sTypes, sTypeName);	// stype
	sType.setDescription(T("|Defines the Types|"));
	sType.setCategory(category);
	// catalog entries for the hsbPlateWallSheetCut
	String shsbPlateWallSheetCut = "hsbPlateWallSheetCut";
	String sEntriesHsbPlateWallSheetCut[] = TslInst().getListOfCatalogNames(shsbPlateWallSheetCut).sorted();
	category = T("|Sheet cutting|");
	String sCatalogEntries[0];
	sCatalogEntries.append(T("|Disabled|"));
	sCatalogEntries.append(sEntriesHsbPlateWallSheetCut);
	String sCatalogName=T("|Catalog sheet cut out|");
	PropString sCatalog(nStringIndex++, sCatalogEntries, sCatalogName);// default is disabled
	sCatalog.setDescription(T("|Defines the Catalog for the|")+" hsbPlateWallSheetCut."+
							T("|To create a new catalog, use the TSL|")+ " hsbPlateWallSheetCut.");
	sCatalog.setCategory(category);
	
	String sTopOpenName=T("|Open at the top|");	
	PropString sTopOpen(nStringIndex++, sNoYes, sTopOpenName);	
	sTopOpen.setDescription(T("|Defines if the top beam should be cutted or not in the case when the intersecting beam does not touch it|"));
	sTopOpen.setCategory(category);
	
	
	// HSB-16751
	category = T("|Stud-Plate Milling|");
	String sMillingStudPlateName=T("|Milling|");
//	String sTeinfraesung = "T-Einfräsung";
	String sTeinfraesung = "T-Connection";
	String sEntriesTeinfraesung[] = TslInst().getListOfCatalogNames(sTeinfraesung).sorted();
	String sMillingStudPlates[0];
//	sMillingStudPlates.append(T("|Default|"));
	sMillingStudPlates.append(sEntriesTeinfraesung);
	int nIndexDefault = 0;
	if(sMillingStudPlates.find(T("|Default|"))>-1)
	{ 
		nIndexDefault=sMillingStudPlates.find(T("|Default|"));
	}
	else if(sMillingStudPlates.find(sDefault)>-1)
	{ 
		nIndexDefault=sMillingStudPlates.find(sDefault);
	}
	PropString sMillingStudPlate(nStringIndex++,sMillingStudPlates, sMillingStudPlateName,nIndexDefault);	
	sMillingStudPlate.setDescription(T("|Defines the catalog for the|")+" T-Einfräsung");
	sMillingStudPlate.setCategory(category);
//End properties //endregion
	
//region bOnInsert
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) {eraseInstance(); return;}
		// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		
		if (sKey.length() > 0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for (int i = 0; i < sEntries.length(); i++)
				sEntries[i] = sEntries[i].makeUpper();
			if (sEntries.find(sKey) >- 1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
		else
			showDialog();
		
		// prompt for the selection of intersecting beams (Pfete) and the beams belonging to walls
		PrEntity ssE(T("|Select intersecting beams and beams of the walls|"), Beam());
//		ssE.addAllowedClass(ElementWallSF());
		if (ssE.go())
			_Entity.append(ssE.set());

		// investigate all walls from the beams
		
		if (_Entity.length()<2)
		{
			// It must be at least 1 intersecting beam and 1 beam belonging to the wall
			reportMessage(("|There should be selected at least an intersecting beam and a beam belonging to the wall|"));
			eraseInstance();
		}
		
		Beam beams[0];
		// loop all selected entities
		for (int i = 0; i < _Entity.length(); i++)
		{
			Beam bm = (Beam)_Entity[i];
			if (bm.bIsValid())
			{ 
				if (beams.find(bm) < 0)
				{ 
					beams.append(bm);//collect beams
				}
			}
		}
		
		// get all the walls from all the selected beams
		ElementWallSF walls[0];
		for (int i = 0; i < beams.length(); i++)
		{ 
			Beam bm = beams[i];
			// get element from beam bm
			Element el = bm.element();
			if (el.bIsValid())
			{ 
				// valid element
				// cast the WallSF
				ElementWallSF w = (ElementWallSF)el;
				if (w.bIsValid())
				{ 
					// valid sfwall, append
					if (walls.find(w) < 0)
					{ 
						walls.append(w);
					}
				}
			}
		}//next i
		
//		// prompt for the whole selection at once WallSF and beams
//		PrEntity ssE(T("|Select Walls and intersecting beams|"), Beam());
//		ssE.addAllowedClass(ElementWallSF());
//		
//		if (ssE.go())
//			_Entity.append(ssE.set());
//			
//		if (_Entity.length()<2)
//		{
//			// It must be at least 1 WallSF and 1 intersecting beam
//			reportMessage(("|There should be selected at least a Wall and a beam|"));
//			eraseInstance();
//		}
//		
//		Beam beams[0];
//		ElementWallSF walls[0];
//		// loop all selected entities
//		for (int i=0;i<_Entity.length();i++) 
//		{ 
//			Beam bm = (Beam)_Entity[i];
//			if(bm.bIsValid())
//				beams.append(bm);// collect beams
//			else
//			{ 
//				ElementWallSF wall = (ElementWallSF)_Entity[i];
//				if(wall.bIsValid())
//					walls.append(wall);// collect walls
//			}
//		}//next i
		if(walls.length()<1)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|no wall selected|"));
			eraseInstance();
			return;
		}
		Beam beamsWall[] = walls[0].beam();// beams of AF wall
		
	// create TSL
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[1];			Entity entsTsl[1];				Point3d ptsTsl[] = {_Pt0};
		int nProps[] ={ };			
		double dProps[] ={ dGap};		
		String sProps[] ={ sType, sCatalogEntries[0], sTopOpen,sMillingStudPlate};
		Map mapTsl;
		
	// for each intersection of wall with a purlin create a TSL instance
	// loop all beams
//		Display dp;
//		dp.color(3);
		int iTslCount = 0;
		if(beams.length()<1)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|no beam was selected|"));
			eraseInstance();
			return;
		}
		for (int i=0;i<beams.length();i++)// for all selected beams 
		{
			if(!beams[i].bIsValid())
			{ 
				continue;
			}
			Beam b = beams[i];
			Vector3d vecXBeam = b.vecX();
			Vector3d vecYBeam = b.vecY();
			Vector3d vecZBeam = b.vecZ();
			double dLengthBeam = b.solidLength();
			
			Point3d ptCen = b.ptCen();
			// loop all walls
			
			Line lBeam(ptCen, vecXBeam);
			for (int j=0;j<walls.length();j++)// for all walls 
			{ 
				ElementWallSF w = walls[j];
				Vector3d vecXWall = w.vecX();
				Vector3d vecYWall = w.vecY();
				Vector3d vecZWall = w.vecZ();
				double dWallBeamWidth = w.dBeamWidth();// width corresponds to width of wall
				double dWallBeamHeight = w.dBeamHeight();
				// 
				if(abs(vecXBeam.dotProduct(vecXWall))>dEps && abs(vecXBeam.dotProduct(vecYWall))>dEps)
				{
					// wall and beam are not normal to each other
					// skew beams to wall are also supported 
				}
				
				if (abs(vecXBeam.dotProduct(vecZWall))<dEps)
				{ 
					// beam in the plane of wall, not allowed
//					reportMessage(("|Beam lies in the plane of wall, excluded|"));
					// message is redundant
					continue;
				}
				
				// get point in wall
				Point3d ptOrg = w.ptOrg();// 
				Point3d ptOrg2 = ptOrg - dWallBeamWidth * vecZWall;
				//plane of wall
				Plane planeWall(ptOrg, vecZWall);
				Plane planeWall2(ptOrg2, vecZWall); // plane going through second point ptOrg2
				// check if beam and wall have intersection
				// get the body of the beam
				Body bodyBeam = b.envelopeBody(true, true);
//				Body bodyBeam = b.realBody();
				
				// shadow of the body in xy of wall
				PlaneProfile pPBeam = bodyBeam.shadowProfile(planeWall);
				//PLine plWall = w.plOutlineWall();// outline of element in XY plane
				PlaneProfile ppWall = w.plEnvelope();//if no point is given, point is PtOrg, cut with plane in xy of wall
				// HSB-21189 include planeprofile of beams
				// it can be that envelope doesnot include beams
				{ 
					PlaneProfile ppBeams(ppWall.coordSys());
					Beam beams[]=w.beam();
					for (int b=0;b<beams.length();b++) 
					{ 
						ppBeams.unionWith(beams[b].envelopeBody().shadowProfile(planeWall)); 
					}//next b
					ppBeams.shrink(U(5));
					ppBeams.shrink(-U(5));
					ppBeams.shrink(-U(5));
					ppBeams.shrink(U(5));
					PLine plOutters[]=ppBeams.allRings(true,false);
					Point3d ptsConvexHull[0];
					for (int ipl=0;ipl<plOutters.length();ipl++) 
					{ 
						ptsConvexHull.append(plOutters[ipl].vertexPoints(true));
					}//next ipl
					PLine plConvexHull;
					plConvexHull.createConvexHull(planeWall,ptsConvexHull);
					ppWall.joinRing(plConvexHull,_kAdd);
				}
				
				// check intersection of 2 planeprofiles
				int isIntersect = pPBeam.intersectWith(ppWall);
				if(!isIntersect)
				{
					// if beam is outside the area of the wall
					reportMessage("\n"+scriptName()+" "+T("|Beam lies outside of the wall area|"));
					continue;
				}
				Point3d ptIntersect;// intersection with first plane
				Point3d ptIntersect2;// intersection with second plane
				//find the intersection point of the beam and the wall
				int iWallHasIntersect = lBeam.hasIntersection(planeWall, ptIntersect); //return TRUE if intersect is found, and set in ptIntersect.
				if(!iWallHasIntersect)
				{
					// no intersection with first plane, try second plane
					reportMessage("\n"+scriptName()+" "+T("|no intersection of beam axis with wall plane, parallel|"));
					continue;
				}
				lBeam.hasIntersection(planeWall2, ptIntersect2);
				// from ptIntersect and ptIntersect2 get the one closer
				Vector3d v1 = ptIntersect - ptCen;
				Vector3d v2 = ptIntersect2 - ptCen;
				double dClosestDistance = v1.length();
				if(v2.length()<dClosestDistance)
				{ 
					dClosestDistance = v2.length();
				}
				
				if((.5*dLengthBeam - dClosestDistance)<0.1*dWallBeamWidth)
				{ 
					// beam does not penetrate enough into the wall
					reportMessage("\n"+scriptName()+" "+T("|Beam does not penetrate enough into the wall|"));
					continue;
				}
				// see how deep the beam enteres the wall plane
				
				//see if beam is long enough to intersect with wall
				PlaneProfile pp = bodyBeam.getSlice(planeWall); // profile of intersection
				PlaneProfile pp2 = bodyBeam.getSlice(planeWall2);
				// make a union of pp and pp2
				pp.unionWith(pp2); // pp in the plane of ptOrg
				if (pp.area() < dEps) //pow(dEps, 2))
				{
					reportMessage("\n"+scriptName()+" "+T("|No slice between beam and any of wall planes|"));
					continue;
				}
//				dp.draw(pp);
				
				iTslCount = iTslCount + 1;
				if (bDebug)reportMessage("\n" + scriptName() + "entering tsl nr. : " + iTslCount);
				
				ptsTsl[0] = ptIntersect;// intersection with first plane of the wall
				gbsTsl[0] = b;// main beam, Pfette in _Beam[0]
				entsTsl[0] = w;//the wall in _Element[0];
				
				// create tsl for each beam wall intersection
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				
				//region cut the sheets
				// TSL for the cutting of sheets
					if(sCatalogEntries.find(sCatalog)>0)
					{ 
						String sTslName = "hsbPlateWallSheetCut";
					// create TSL
						String strExecuteKey = "";
						String strEvent = ""; // default is "OnDbCreated"
					
						tslNew.dbCreate(sTslName , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, sCatalog, _kModelSpace, mapTsl, strExecuteKey, strEvent);
					}
			//End cut the sheets//endregion 
			}//next j
		}//next i
		eraseInstance();
		return;
	}// end _bOnInsert
	
//End bOnInsert//endregion 
//return;
// do the modeling for each tsl
// beam and wall properties
if(bDebug)reportMessage("\n"+ scriptName() + " triggered TSL........");
	
//region if no intersecting beam pfette or element
	if(_Beam.length()<1)
	{ 
		// no beam 
		reportMessage("\n"+scriptName()+" "+T("|no intersecting beam found|"));
		eraseInstance();
		return;
	}
	
	if(_Element.length()<1)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|no element found|"));
		eraseInstance();
		return;
	}
	
//End if no intersecting beam pfette or element//endregion 
	
//region set the property type to readonly
	
	sType.setReadOnly(true);
//End set the property type to readonly//endregion 
//region guard from duplicated TSL
	// delete previously defined TSL that have the same
	// element and the same beam
	// TSL is assigned to the group of element so get all TSL in this group
	
	TslInst tslAttached[] = _Element[0].tslInst();
	for (int i = 0; i < tslAttached.length(); i++)
	{ 
		TslInst tsli = tslAttached[i];
		String ss = tsli.scriptName();
		String sss = scriptName();
//		if (tsli.scriptName() != scriptName())
		if (tsli.scriptName() != "hsbPlateWallSupport")
		{ 
			continue;
		}
		Beam beamsTslI[] = tsli.beam();
		if (beamsTslI.length() == 0)
		{ 
			continue;
		}
		if (beamsTslI[0] != _Beam[0])
		{
			// tsl is from this element but for another Pfette
			continue;
		}
		if (tsli == _ThisInst)
		{ 
			// is this tsl
			continue;
		}
		reportMessage("\n"+scriptName()+" "+T("|Existing TSL was deleted and replaced with the newly inserted one|"));
		// apply the set command and delete
		String sExecuteKey = T("|reset|");;
		tsli.recalcNow(sExecuteKey);
		tsli.dbErase();
	}//next i

//End guard from duplicated TSL//endregion 
	if(bDebug)reportMessage("\n"+ scriptName() + " kexecutekey: "+_kExecuteKey);
	
	
//region set catalog entry for sheet cutting to read only
	// this can only be controlled on boninsert
	sCatalog.setReadOnly(true);	
//End set catalog entry for sheet cutting to read only//endregion 
	
//region dependency with the Pfette
// create dependency with the main Pfette
	Entity entMainBeam = (Entity)_Beam[0];
	_Entity.append(entMainBeam);
	setDependencyOnEntity(entMainBeam);
//End dependency with the Pfette//endregion 
	
	
//region _bOnElementConstructed, when wall recalculated, delete previously saved global variables
	if(_bOnElementConstructed)
	{ 
	// delete all previously saved maps
	// wall is calculated again
		// section
		_Map.removeAt("dHeight", true);
		_Map.removeAt("dWidth", true);
		_Map.removeAt("ptSectionCenter", true);
		//generated beams
		_Map.removeAt("beamsForDel", true);
	}	
//End _bOnElementConstructed, when wall recalculated, delete previously saved global variables//endregion 

//region section data in map
// get existing section data and position
	double dHeightExisting = _Map.getDouble("dHeight");
	double dWidthExisting = _Map.getDouble("dWidth");
	Point3d ptSectionCenterExisting = _Map.getPoint3d("ptSectionCenter");
	double dGapExisting = _Map.getDouble("dGap");

//End section data in map//endregion 

//region main data
//existing data
	Vector3d vecXBeam = _Beam[0].vecX();
	Vector3d vecYBeam = _Beam[0].vecY();
	Vector3d vecZBeam = _Beam[0].vecZ();
	Point3d ptCen = _Beam[0].ptCen(); // center point of beam
	vecXBeam.vis(_Pt0, 1);
	vecYBeam.vis(_Pt0, 3);
	vecZBeam.vis(_Pt0, 150);
	ptCen.vis(4);
	
// stick frame wall and properties
	ElementWallSF w = (ElementWallSF)_Element[0];
	Vector3d vecXWall = w.vecX();
	Vector3d vecYWall = w.vecY();
	Vector3d vecZWall = w.vecZ();
// beam dimensions
	double dBeamWidth = _Beam[0].dD(vecXWall); // dimension in direction most aligned with vecXWall
	double dBeamHeight = _Beam[0].dD(vecYWall);
// get beam dimensions of beams in stick frame wall
	double dWallBeamWidth = w.dBeamWidth(); // width corresponds to width of wall
	double dWallBeamHeight = w.dBeamHeight(); // height
	Point3d ptOrg = w.ptOrg(); // origin point of wall
	vecXWall.vis(ptOrg, 1);
	vecYWall.vis(ptOrg, 3);
	vecZWall.vis(ptOrg, 150);
	ptOrg.vis(3);
	Point3d ptOrg2 = ptOrg - dWallBeamWidth * vecZWall;
	ptOrg2.vis(3);
	
// wall plane going through origin point
	Plane planeWall(ptOrg, vecZWall);// plane going through the plane in ptOrg
	Plane planeWall2(ptOrg2, vecZWall); // plane going through second point ptOrg2		

//End main data//endregion 

//region check if there is intersection of beam body with any of 2 vertical wall planes
//Get plane profiles of beam with the 2 planes
	Body bodyBeam = _Beam[0].envelopeBody(true, false); // solid body of beam
	PlaneProfile pp = bodyBeam.getSlice(planeWall); // profile of intersection with plane in ptorg
	pp.vis(1);
	double sliceArea = pp.area();
	
	PlaneProfile pp2 = bodyBeam.getSlice(planeWall2);// profile of beam-wall intersection with plane at second point
	pp2.vis(1);
// make a union of pp and pp2
	pp.unionWith(pp2); // pp in the plane of ptOrg, get the total profile
	if (pp.area() < pow(dEps, 2))
	{ 
		reportMessage("\n"+scriptName()+" "+T("|No slice between beam and any of wall planes|"));
		eraseInstance();
		return;
	}
	pp.vis(1);
	
//End check if there is intersection of beam body with any of 2 vertical wall planes//endregion 

//region TSL symbol
// TSL symbol
	Display dp(3);
	PlaneProfile ppMiddle = pp;
	LineSeg lSeg1 = ppMiddle.extentInDir(vecXWall);// 
	Point3d ptSectionCenter = .5 * (lSeg1.ptStart() + lSeg1.ptEnd());// current center
	
	LineSeg lSeg2 = ppMiddle.extentInDir(vecYWall);
	PLine pLrect;
	pLrect.createRectangle(lSeg1, vecXWall, vecYWall);
	PlaneProfile pPsymbol(pLrect);
	dp.draw(pPsymbol); // draw the rectangle of the envelope
	dp.draw(lSeg1); // draw 1st diagonal
	dp.draw(lSeg2); // draw 2nd diagonal
	// HSB-9641: add 2 other lines
	{ 
		PLine pls[] = ppMiddle.allRings();
		PLine pl = pls[0];
		
		ppMiddle.transformBy(vecXWall * U(10));
		LineSeg lSeg1 = ppMiddle.extentInDir(vecXWall);
		Line ln1(lSeg1.ptStart(), Vector3d(lSeg1.ptStart() - lSeg1.ptEnd()));
		Point3d pts1[] = pl.intersectPoints(ln1);
		LineSeg _lSeg1(pts1[0], pts1[1]);
		LineSeg lSeg2 = ppMiddle.extentInDir(vecYWall);
		Line ln2(lSeg2.ptStart(), Vector3d(lSeg2.ptStart() - lSeg2.ptEnd()));
		Point3d pts2[] = pl.intersectPoints(ln2);
		LineSeg _lSeg2(pts2[0], pts2[1]);
		
		dp.draw(_lSeg1); // draw 1st diagonal
		dp.draw(_lSeg2);
		
		ppMiddle.transformBy(-vecXWall * U(20));
		LineSeg lSeg1_ = ppMiddle.extentInDir(vecXWall);
		Line ln1_(lSeg1_.ptStart(), Vector3d(lSeg1_.ptStart() - lSeg1_.ptEnd()));
		Point3d pts1_[] = pl.intersectPoints(ln1_);
		LineSeg _lSeg1_(pts1_[0], pts1_[1]);
		LineSeg lSeg2_ = ppMiddle.extentInDir(vecYWall);
		Line ln2_(lSeg2_.ptStart(), Vector3d(lSeg2_.ptStart() - lSeg2_.ptEnd()));
		Point3d pts2_[] = pl.intersectPoints(ln2_);
		LineSeg _lSeg2_(pts2_[0], pts2_[1]);
		
		dp.draw(_lSeg1_); // draw 1st diagonal
		dp.draw(_lSeg2_);
		
		PLine plCircle(vecZWall);
		plCircle.createCircle(lSeg1.ptMid()-vecXWall*U(10), vecZWall, U(20));
		PlaneProfile ppCircle(pPsymbol.coordSys());
		ppCircle.joinRing(plCircle, _kAdd);
		dp.draw(ppCircle, _kDrawFilled);
	}
	// set pt0 to the center of symbol
	_Pt0 = lSeg1.ptMid();
	
// assign TSL symbol to element group
	_ThisInst.assignToElementGroup(w, true, 0, 'T');
	
//region plane profile with gap
	PlaneProfile pPsymbolGap(pPsymbol.coordSys());
	Point3d pt1SegGap = lSeg1.ptStart() - dGap * vecXWall;
	Point3d pt2SegGap = lSeg1.ptEnd() + dGap * vecXWall;
	if(sNoYes.find(sTopOpen)==1)
	{ 
		// option YES is selected
		pt2SegGap += 10e5 * vecYWall;
	}
	LineSeg lSeg3(pt1SegGap, pt2SegGap);
	PLine pLrect3;
	pLrect3.createRectangle(lSeg3, vecXWall, vecYWall);
	pPsymbolGap.joinRing(pLrect3, false);
	pPsymbolGap.vis(3);
	Point3d pBottomLeftGap = lSeg3.ptStart();
	Point3d pTopRightGap = lSeg3.ptEnd();
	pBottomLeftGap.vis(4);
	pTopRightGap.vis(4);
//End plane profile with gap//endregion 


// a coordinate system that transforms coordinate from world coordinate system to wall coordinate system
	CoordSys world2wall; // from world cs to wall cs 
	Point3d ptTest(3, 4, 6);
	world2wall.setToAlignCoordSys(Point3d(0,0,0), vecXWall , vecYWall, vecZWall, Point3d(0,0,0), _XW, _YW, _ZW);
	ptTest.transformBy(world2wall);

// extremes of bounding box of plane profile
	LineSeg lSegMax = pp.extentInDir(vecXWall);
	lSegMax.vis(2);// diagonal of the enveloping plane profile
	Point3d pBottomLeft = lSegMax.ptStart();
	Point3d pTopRight = lSegMax.ptEnd();

// get extreme points bottom(-vecYWall), left (-vecXWall), top(vecYWall), right(vecXWall)
//copy of p1,p2 in local coord	

//	pBottomLeft.vis(4);
//	pTopRight.vis(4);

// width and height of pp
	double ppWidthX = abs(vecXWall.dotProduct(lSegMax.ptStart() - lSegMax.ptEnd()));	// width in Wall X
	double ppHeightY = abs(vecYWall.dotProduct(lSegMax.ptStart() - lSegMax.ptEnd())); // Height in Wall Y
//End TSL symbol//endregion 
// Control tsls "T-Einfräsung
	int nMillingStudPlate=sMillingStudPlates.find(sMillingStudPlate);
	Entity entsTslMilling[] = _Map.getEntityArray("entsTslMilling", "", "");
	if(entsTslMilling.length()>0)
	{
		TslInst tsls[0];
		for (int i=entsTslMilling.length()-1; i>=0 ; i--) 
		{ 
			TslInst tslI=(TslInst)entsTslMilling[i];
			if(tslI.bIsValid() && tsls.find(tslI)<0)
			{
				tsls.append(tslI);
			}
		}//next i
		if(tsls.length()>0)
		{ 
			sMillingStudPlate.setReadOnly(false);
		}
		else
		{ 
			sMillingStudPlate.setReadOnly(_kHidden);
		}
		if(_kNameLastChangedProp==sMillingStudPlateName)
		{ 
			if(nMillingStudPlate>0)
			{ 
				// catalog is selectes
				for (int itsl=0;itsl<tsls.length();itsl++) 
				{ 
					tsls[itsl].setPropValuesFromCatalog(sMillingStudPlate);
				}//next itsl
			}
			else if(nMillingStudPlate==0)
			{ 
				if(sEntriesTeinfraesung.find(sMillingStudPlate)>-1)
				{ 
					for (int itsl=0;itsl<tsls.length();itsl++) 
					{ 
						tsls[itsl].setPropValuesFromCatalog(sMillingStudPlate);
					}//next itsl
				}
				else
				{ 
					for (int itsl=0;itsl<tsls.length();itsl++) 
					{ 
						tsls[itsl].setPropDouble(0,U(0));
						tsls[itsl].setPropDouble(1,U(0));
//						tsls[itsl].setPropString(0,sNoYes[1]);
//						tsls[itsl].setPropInt(0,3);
					}//next itsl
				}
			}
		}
	}


// gap or sTopOpen is changed
// this need to join all beams and generate the split again
	int iTriggerRecalc;
	
// compare dBeamWidth,dBeamHeight,ptSectionCenter with dLengthExisting,dWidthExisting,ptSectionCenterExisting
	int iBeamTrigger;
//	iBeamTrigger = abs(dBeamWidth - dWidthExisting) > dEps
//		 			|| abs(dBeamHeight - dHeightExisting) > dEps
//		 			|| (ptSectionCenter - ptSectionCenterExisting).length() > dEps;

// reset trigger 
	String sTriggerReset = T("|reset|");
	addRecalcTrigger(_kContext, sTriggerReset );
// reset and delete trigger
	String sTriggerResetAndDelete = T("|reset and delete|");
	addRecalcTrigger(_kContext, sTriggerResetAndDelete );
	// HSB-13545
	String sTriggerRegenerateConstruction = T("|regenerate construction|");
	addRecalcTrigger(_kContext, sTriggerRegenerateConstruction);
	
	// recalc from change of properties
	iTriggerRecalc = (_kNameLastChangedProp == sTopOpenName || _kNameLastChangedProp == sGapName ||
	_kExecuteKey == sTriggerReset || _kExecuteKey == sTriggerResetAndDelete);
	// command regenerate construction
	if(_bOnRecalc && _kExecuteKey == sTriggerRegenerateConstruction)
	{ 
		iTriggerRecalc = true;
		iBeamTrigger = true;
	}
	
	// if a command is selected
	int iRecalcCommand=(_bOnRecalc && (_kExecuteKey == sTriggerReset || _kExecuteKey == sTriggerResetAndDelete 
			 || _kExecuteKey == sTriggerRegenerateConstruction));
	
	
	if (!iBeamTrigger && !iTriggerRecalc && !iRecalcCommand && !_bOnDbCreated)
   	{
		return;
   	}
	
//region if section is changed, join and stretch the splitted beams
// get all beams in stick frame wall
	Beam beamsWall[] = w.beam();
	// check if there are beams at the element
	{ 
		if (beamsWall.length() == 0)
		{ 
			// no beam is yet generated at walls
			// wait until it gets generated
//			reportMessage(("|wait until element gets generated|"));
			return;
		}
	}
	
	//region get analysed cut from most left and most right SF Top Plate
	Beam beamsTop[0];
	
	for (int i = 0; i < beamsWall.length(); i++)
	{ 
		Beam bmi=beamsWall[i];
		int iTypesTop[] ={ _kSFTopPlate, _kSFAngledTPLeft, _kSFAngledTPRight };
		if (iTypesTop.find(bmi.type()) >- 1)
		{ 
			// its a top plate
			beamsTop.append(bmi);
		}
	}//next i
	if (beamsTop.length() == 0)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|unexpected error|"));
		reportMessage("\n"+scriptName()+" "+T("|no top beam|"));
		eraseInstance();
		return;
	}
	
	Beam bmLeft = beamsTop[0];
	Beam bmRight = beamsTop[0];
	for (int i = 0; i < beamsTop.length(); i++)
	{ 
		if ((beamsTop[i].ptCen() - bmLeft.ptCen()).dotProduct(vecXWall) < 0)
		{ 
			// on the left
			bmLeft = beamsTop[i];
		}
		if ((beamsTop[i].ptCen() - bmRight.ptCen()).dotProduct(vecXWall) > 0)
		{ 
			// on the left
			bmRight = beamsTop[i];
		}
	}//next i
	
	// vertical studs
	Beam beamsVer[]=vecXWall.filterBeamsPerpendicularSort(beamsWall);
	Beam bmStud;
	String sName;// HSB-24281
	String sGrade;// HSB-24281
	if(beamsVer.length()>0)
	{
		bmStud=beamsVer.first();
		sName=bmStud.name();// HSB-24281
		sGrade=bmStud.grade();// HSB-24281
		for (int b=0;b<beamsVer.length();b++) 
		{ 
			if(beamsVer[b].type()==_kStud)
			{ 
				bmStud=beamsVer[b];
				sName=bmStud.name();// HSB-24281
				sGrade=bmStud.grade();// HSB-24281
				break;
			}
		}//next b
	}
	
	// get the cuts of top beams when they are skwe beams not horizontally
	// analysed tools
	AnalysedTool atsLeft[] = bmLeft.analysedTools();
	// analysed cuts
	AnalysedCut acsLeft[0];
	for (int i = 0; i < atsLeft.length(); i++)
	{ 
		AnalysedTool ati = atsLeft[i];
		AnalysedCut ct = (AnalysedCut)ati;
		if (ct.bIsValid())
		{ 
			acsLeft.append(ct);
		}
	}//next i
	Point3d ptLeftCut = acsLeft[0].ptOrg();
	Vector3d vNormalLeft = acsLeft[0].normal();
	for (int i = 0; i < acsLeft.length(); i++)
	{ 
		AnalysedCut aci = acsLeft[i]; 
		if ((aci.ptOrg() - ptLeftCut).dotProduct(vecXWall) < 0)
		{ 
			ptLeftCut = aci.ptOrg();
			vNormalLeft = aci.normal();
		}
	}//next i
	
	if(!_Map.hasPoint3d("ptLeftCut"))
	{
		_Map.setPoint3d("ptLeftCut", ptLeftCut);
		_Map.setVector3d("vNormalLeft", vNormalLeft);
	}
	
	// analysed tools on the right
	AnalysedTool atsRight[] = bmRight.analysedTools();
	// analysed cuts on the right
	AnalysedCut acsRight[0];
	for (int i = 0; i < atsRight.length(); i++)
	{ 
		AnalysedTool ati = atsRight[i];
		AnalysedCut ct = (AnalysedCut)ati;
		if (ct.bIsValid())
		{ 
			acsRight.append(ct);
		}
	}//next i
	Point3d ptRightCut = acsRight[0].ptOrg();
	Vector3d vNormalRight = acsRight[0].normal();
	for (int i = 0; i < acsRight.length(); i++)
	{ 
		AnalysedCut aci = acsRight[i]; 
		if ((aci.ptOrg() - ptRightCut).dotProduct(vecXWall) > 0)
		{ 
			ptRightCut = aci.ptOrg();
			vNormalRight = aci.normal();
		}
	}//next i
		
	if(!_Map.hasPoint3d("ptRightCut"))
	{
		_Map.setPoint3d("ptRightCut", ptRightCut);
		_Map.setVector3d("vNormalRight", vNormalRight);
	}
	
	
	// set analysed cut if it changes
	if(_Map.hasPoint3d("ptLeftCut"))
	{ 
		Point3d ptLeftCutMap = _Map.getPoint3d("ptLeftCut");
//		reportMessage(("|ptLeftCutMap.X()|")+ptLeftCutMap.X());
		
		Vector3d vNormalLeftMap = _Map.getVector3d("vNormalLeft");
		if (abs((ptLeftCutMap - ptLeftCut).dotProduct(vecXWall)) > dEps)
		{ 
			// set the new cut at the beam
			Cut ct(ptLeftCutMap, vNormalLeftMap);
			bmLeft.addToolStatic(ct,_kStretchOnToolChange);
		}
	}
	if(_Map.hasPoint3d("ptRightRightCut"))
	{ 
		Point3d ptRightCutMap = _Map.getPoint3d("ptRightCut");
//		reportMessage(("|ptRightCutMap.X()|")+ptRightCutMap.X());
		
		Vector3d vNormalRightMap = _Map.getVector3d("vNormalRight");
		if (abs((ptRightCutMap - ptRightCut).dotProduct(vecXWall)) > dEps)
		{ 
			// set the new cut at the beam
			Cut ct(ptRightCutMap, vNormalRightMap);
			bmRight.addToolStatic(ct,_kStretchOnToolChange);
		}
	}
	
	//End get analysed cut from most left and most right SF Top Plate//endregion
	
// trigger if section is changed, width, height or position
	// do this always
	// beam or open top and gap
	if(iBeamTrigger || iTriggerRecalc)
	{
if (bDebug)reportMessage("\n" + scriptName() + " enteres section..");
		
	// get existing pBottomLeft and pTopRight
	// needed to join the existing beams. The geometry must be checked with the existing geometry
		Point3d pBottomLeftExist;
		Point3d pTopRightExist;
		pBottomLeftExist = pBottomLeftGap - (vecXWall * .5 * (dWidthExisting - dBeamWidth)
										 + vecXWall * (dGapExisting - dGap)
					                  - (vecYWall * .5 * (dHeightExisting - dBeamHeight)))
					                  +(ptSectionCenterExisting-ptSectionCenter);
		pTopRightExist = pTopRightGap + (vecXWall * .5 * (dWidthExisting - dBeamWidth)
										 + vecXWall * (dGapExisting - dGap)
					              	+ (vecYWall * .5 * (dHeightExisting - dBeamHeight)))
					              	+(ptSectionCenterExisting-ptSectionCenter);
					              
if(bDebug)reportMessage("\n"+ scriptName() + "dWidthExisting "+dWidthExisting);
if(bDebug)reportMessage("\n"+ scriptName() + "dHeightExisting "+dHeightExisting);
if(bDebug)reportMessage("\n"+ scriptName() + "dGapExisting "+dGapExisting);
		
if(bDebug)reportMessage("\n"+ scriptName() + "dBeamWidth "+dBeamWidth);
if(bDebug)reportMessage("\n"+ scriptName() + "dBeamHeight "+dBeamHeight);
if(bDebug)reportMessage("\n"+ scriptName() + "dGap "+dGap);
		
		pBottomLeftExist.vis(2);
		pTopRightExist.vis(2);
		
	// save current geometry
		_Map.removeAt("dHeight", true);
		_Map.removeAt("dWidth", true);
		_Map.removeAt("ptSectionCenter", true);
		_Map.removeAt("dGap",true);
		_Map.setDouble("dHeight", dBeamHeight);
		_Map.setDouble("dWidth", dBeamWidth);
		_Map.setPoint3d("ptSectionCenter", ptSectionCenter);
		_Map.setDouble("dGap", dGap);
		
	// erase geometry if 
if(bDebug)reportMessage("\n"+ scriptName() + " enters iBeamTrigger");
		
		// erase the current geometry 
		Beam beamsWallJoin[0];
		beamsWallJoin = beamsWall;
		// do the calculation to get all beams and join them
		for (int i = 0; i < beamsWall.length(); i++)
		{ 
			Beam bmi = beamsWall[i];
			if(abs(bmi.vecX().dotProduct(vecXWall))<dEps)
			{ 
				// vertical beams are excluded
				continue;
			}
			Body bodyBmi = bmi.envelopeBody(true, true);
			Plane pnTop(ptOrg, vecYWall);// horizontal plane
			PlaneProfile ppBmiTop = bodyBmi.shadowProfile(pnTop);
		// get extents of profile
			LineSeg seg = ppBmiTop.extentInDir(vecXWall);
			Vector3d vecXi = bmi.vecX();//as direction of vecXWall
			if (bmi.vecX().dotProduct(vecXWall) < 0)vecXi *= -1;
			// vecX in direction of vecXWall
			Line lnBmi(bmi.ptCen(), vecXi);
			Point3d ptsBmi[0];
			ptsBmi.append(seg.ptStart());
			ptsBmi.append(seg.ptEnd());
		// safer
			if(ptsBmi.length()<2)
			{ 
				reportMessage("\n"+scriptName()+" "+T("|unexpected error..|"));
				eraseInstance();
				return;
			}
			
		// see if ptsBmi[0] or ptsBmi[1] between pBottomLeft and pTopRight
			int iIsPtLeftInside=(ptsBmi[0].dotProduct(vecXWall)>=(pBottomLeftExist.dotProduct(vecXWall)-dEps))
			 && (ptsBmi[0].dotProduct(vecXWall) <= (pTopRightExist.dotProduct(vecXWall) + dEps));
			 
			 int iIsPtRightInside=(ptsBmi[1].dotProduct(vecXWall)>=(pBottomLeftExist.dotProduct(vecXWall)-dEps))
			 && (ptsBmi[1].dotProduct(vecXWall) <= (pTopRightExist.dotProduct(vecXWall) + dEps));
			
			if( !(iIsPtLeftInside || iIsPtRightInside) )
			{ 
				// no point ptsBmi[0] or ptsBmi[1] not inside pBottomLeft,pTopRight
				// no valid beam for joining
				continue;
			}
			if(iIsPtLeftInside && iIsPtRightInside)
			{ 
				// beam all inside pBottomLeft,pTopRight
				continue;
			}
			
			int iJoined = false;
			// find the beam to be joined with bmi
			for (int j=0;j<beamsWallJoin.length();j++) 
			{ 
				Beam bmj = beamsWallJoin[j];
				if(abs(bmi.vecX().dotProduct(bmj.vecX()))-1.0>dEps)
				{ 
					// not parallel colinear
					continue;
				}
				Point3d ptClosest = lnBmi.closestPointTo(bmj.ptCen());
				if ((ptClosest-bmj.ptCen()).length()>dEps)
				{ 
					// not same axis
					continue;
				}
				
				// parallel and same axis, candidate for joining
				Body bodyBmj = bmj.envelopeBody(true, true);
				PlaneProfile ppBmjTop = bodyBmj.shadowProfile(pnTop);
				
			// get extents of profile
				LineSeg seg = ppBmjTop.extentInDir(vecXWall);
				
				Point3d ptsBmj[0];
				ptsBmj.append(seg.ptStart());
				ptsBmj.append(seg.ptEnd());
				if(ptsBmj.length()<2)
				{ 
					reportMessage("\n"+scriptName()+" "+T("|unexpected error...|"));
					eraseInstance();
					return;
				}
				
				int iIsPtLeftInsideJ=(ptsBmj[0].dotProduct(vecXWall)>=(pBottomLeftExist.dotProduct(vecXWall)-dEps))
				 && (ptsBmj[0].dotProduct(vecXWall) <= (pTopRightExist.dotProduct(vecXWall) + dEps));
				 
				int iIsPtRightInsideJ=(ptsBmj[1].dotProduct(vecXWall)>=(pBottomLeftExist.dotProduct(vecXWall)-dEps))
				 && (ptsBmj[1].dotProduct(vecXWall) <= (pTopRightExist.dotProduct(vecXWall) + dEps));
				
				// left point is between pBottomLeft and pTopRight
				if( iIsPtLeftInside )
				{ 
					// left point in ptsBmi
					if( iIsPtRightInsideJ )
					{ 
						// join both beams
						bmj.dbJoin(bmi);
						if(bDebug)reportMessage("\n"+ scriptName() + " enters join 1...");
						iJoined = true;
					}
				}
				// right point is between pBottomLeft and pTopRight
				if( iIsPtRightInside )
				{ 
					// left point in ptsBmi
					if( iIsPtLeftInsideJ )
					{ 
						// join both beams
						bmi.dbJoin(bmj);
						if(bDebug)reportMessage("\n"+ scriptName() + " enters join 2...");
						iJoined = true;
					}
				}
			}//next j
			
			// bmi is cutted but no beam was found to join it
			// apply the new cut/stretch
			if(!iJoined)
			{ 
				// beam could not join, find the other beam to apply the cut
				for (int j=0;j<beamsWallJoin.length();j++) 
				{ 
					Beam bmj = beamsWallJoin[j];
					if(abs(bmj.vecX().dotProduct(vecXWall))<dEps)
					{ 
						// vertical beams are excluded
						continue;
					}
					Body bodyBmj = bmj.envelopeBody(true, true);
					Plane pnTop(ptOrg, vecYWall);// horizontal plane
					PlaneProfile ppBmjTop = bodyBmj.shadowProfile(pnTop);
				// get extents of profile
					LineSeg seg = ppBmjTop.extentInDir(vecXWall);
					Vector3d vecXj = bmj.vecX();//as direction of vecXWall
					if (bmj.vecX().dotProduct(vecXWall) < 0)vecXj *= -1;
					// vecX in direction of vecXWall
					Line lnBmj(bmj.ptCen(), vecXj);
					Point3d ptsBmj[0];
					ptsBmj.append(seg.ptStart());
					ptsBmj.append(seg.ptEnd());
				// safer
					if(ptsBmj.length()<2)
					{ 
						reportMessage("\n"+scriptName()+" "+T("|unexpected error..|"));
						eraseInstance();
						return;
					}
					// check if this beam is also cutted
					int iIsPtLeftInsideJ=(ptsBmj[0].dotProduct(vecXWall)>=(pBottomLeftExist.dotProduct(vecXWall)-dEps))
					 && (ptsBmj[0].dotProduct(vecXWall) <= (pTopRightExist.dotProduct(vecXWall) + dEps));
					 
					int iIsPtRightInsideJ=(ptsBmj[1].dotProduct(vecXWall)>=(pBottomLeftExist.dotProduct(vecXWall)-dEps))
					 && (ptsBmj[1].dotProduct(vecXWall) <= (pTopRightExist.dotProduct(vecXWall) + dEps));
					 
					 if((iIsPtLeftInside && iIsPtLeftInsideJ) ||
					    (iIsPtRightInside && iIsPtRightInsideJ))
					 { 
					 	// both cutted on the left, no common point for applying the cut/stretch
					 	continue;
					 }
					 if(!((iIsPtLeftInside && iIsPtRightInsideJ)||
					 	  (iIsPtRightInside && iIsPtLeftInsideJ)))
					 { 
					 	continue;
					 }
					 // cutted on opposite sides, find intersetion point and apply the cut/stretch
					 Line lni(bmi.ptCen(), bmi.vecX());
					 Plane pnj(bmj.ptCen(), bmj.vecD(vecYWall));
					 // intersection of line with plane
					 Point3d ptIntersect;
					 int iHasIntersect = lni.hasIntersection(pnj, ptIntersect);
					 if(!iHasIntersect)
					 { 
					 	continue;
	//				 	reportMessage(TN("|unexpected error|"));
					 }
					 Cut cutStretchRight (ptIntersect, vecXWall);
					 Cut cutStretchLeft (ptIntersect, -vecXWall);
					 
					 // apply cut/stretch on the left and right
					 if(bDebug)reportMessage("\n"+ scriptName() + " stretch the beams...");
					 if((iIsPtLeftInside && iIsPtRightInsideJ))
					 { 
					 	bmi.addToolStatic(cutStretchLeft, _kStretchOnToolChange);
					 	bmj.addToolStatic(cutStretchRight, _kStretchOnToolChange);
					 }
					 else if((iIsPtRightInside && iIsPtLeftInsideJ))
					 { 
					 	bmi.addToolStatic(cutStretchRight, _kStretchOnToolChange);
					 	bmj.addToolStatic(cutStretchLeft, _kStretchOnToolChange);
					 }
				}//next j
			}
		}//next i
		// delete the previously generated beams
		// only if not type 2
		int iType = sTypes.find(sType);
		if (iType != 1)
		{ 
			// not second type
			Entity beamsForDel[] = _Map.getEntityArray("beamsForDel", "", "");
			if(beamsForDel.length()>0)
			{ 
				for (int i=beamsForDel.length()-1; i>=0 ; i--) 
				{ 
					Beam bmi = (Beam)beamsForDel[i];
					if(bmi.bIsValid())
					{
						bmi.dbErase();
					}
				}//next i
			}
			// delete from map
			_Map.removeAt("beamsForDel", true);
		}
	}
//End if section is changed//endregion 	


	// Trigger VARIABLE//region
	if (_bOnRecalc && (_kExecuteKey==sTriggerReset || _kExecuteKey==sDoubleClick || _kExecuteKey==sTriggerResetAndDelete))
	{
		Beam beamsWallJoin[0];
		beamsWallJoin = beamsWall;
//		beamsWallJoin.append(beamsWall);
		// do the calculation to get all beams and join them
		for (int i = 0; i < beamsWall.length(); i++)
		{ 
			Beam bmi = beamsWall[i];
			if(abs(bmi.vecX().dotProduct(vecXWall))<dEps)
			{ 
				// vertical beams are excluded
				continue;
			}
			Body bodyBmi = bmi.envelopeBody(true, true);
			Plane pnTop(ptOrg, vecYWall);// horizontal plane
			PlaneProfile ppBmiTop = bodyBmi.shadowProfile(pnTop);
		// get extents of profile
			LineSeg seg = ppBmiTop.extentInDir(vecXWall);
			Vector3d vecXi = bmi.vecX();//as direction of vecXWall
			if (bmi.vecX().dotProduct(vecXWall) < 0)vecXi *= -1;
			// vecX in direction of vecXWall
			Line lnBmi(bmi.ptCen(), vecXi);
			Point3d ptsBmi[0];
			ptsBmi.append(seg.ptStart());
			ptsBmi.append(seg.ptEnd());
		// safer
			if(ptsBmi.length()<2)
			{ 
				reportMessage("\n"+scriptName()+" "+T("|unexpected error..|"));
				eraseInstance();
				return;
			}
			
		// see if ptsBmi[0] or ptsBmi[1] between pBottomLeft and pTopRight
			int iIsPtLeftInside=(ptsBmi[0].dotProduct(vecXWall)>=(pBottomLeftGap.dotProduct(vecXWall)-dEps))
			 && (ptsBmi[0].dotProduct(vecXWall) <= (pTopRightGap.dotProduct(vecXWall) + dEps));
			 
			 int iIsPtRightInside=(ptsBmi[1].dotProduct(vecXWall)>=(pBottomLeftGap.dotProduct(vecXWall)-dEps))
			 && (ptsBmi[1].dotProduct(vecXWall) <= (pTopRightGap.dotProduct(vecXWall) + dEps));
			
			if( !(iIsPtLeftInside || iIsPtRightInside) )
			{ 
				// no point ptsBmi[0] or ptsBmi[1] not inside pBottomLeft,pTopRight
				// no valid beam for joining
				continue;
			}
			if(iIsPtLeftInside && iIsPtRightInside)
			{ 
				// beam all inside pBottomLeft,pTopRight
				continue;
			}
			
			// find the beam to be joined with bmi
			for (int j=0;j<beamsWallJoin.length();j++) 
			{ 
				Beam bmj = beamsWallJoin[j];
				if(abs(bmi.vecX().dotProduct(bmj.vecX()))-1.0>dEps)
				{ 
					// not parallel colinear
					continue;
				}
				Point3d ptClosest = lnBmi.closestPointTo(bmj.ptCen());
				if ((ptClosest-bmj.ptCen()).length()>dEps)
				{ 
					// not same axis
					continue;
				}
				
				// parallel and same axis, candidate for joining
				Body bodyBmj = bmj.envelopeBody(true, true);
				PlaneProfile ppBmjTop = bodyBmj.shadowProfile(pnTop);
				
			// get extents of profile
				LineSeg seg = ppBmjTop.extentInDir(vecXWall);
				
				Point3d ptsBmj[0];
				ptsBmj.append(seg.ptStart());
				ptsBmj.append(seg.ptEnd());
				if(ptsBmj.length()<2)
				{ 
					reportMessage("\n"+scriptName()+" "+T("|unexpected error...|"));
					eraseInstance();
					return;
				}
				
				int iIsPtLeftInsideJ=(ptsBmj[0].dotProduct(vecXWall)>=(pBottomLeftGap.dotProduct(vecXWall)-dEps))
				 && (ptsBmj[0].dotProduct(vecXWall) <= (pTopRightGap.dotProduct(vecXWall) + dEps));
				 
				int iIsPtRightInsideJ=(ptsBmj[1].dotProduct(vecXWall)>=(pBottomLeftGap.dotProduct(vecXWall)-dEps))
				 && (ptsBmj[1].dotProduct(vecXWall) <= (pTopRightGap.dotProduct(vecXWall) + dEps));
				
				// left point is between pBottomLeft and pTopRight
				if( iIsPtLeftInside )
				{ 
					// left point in ptsBmi
					if( iIsPtRightInsideJ )
					{ 
						// join both beams
						bmj.dbJoin(bmi);
						if(bDebug)reportMessage("\n"+ scriptName() + " enters join 1");
						
					}
				}
				// right point is between pBottomLeft and pTopRight
				if( iIsPtRightInside )
				{ 
					// left point in ptsBmi
					if( iIsPtLeftInsideJ )
					{ 
						// join both beams
						bmi.dbJoin(bmj);
						if(bDebug)reportMessage("\n"+ scriptName() + " enters join 2");
						
					}
				}
			}//next j
		}//next i
		// from all displaced beams from type 2, put them at their initial position
		{ 
			for (int i = 0; i < beamsWall.length(); i++)
			{ 
				Beam bmi = beamsWall[i]; 
				Map mapXexist = bmi.subMapX("mapX");
				if ( mapXexist.hasPoint3d("ptInitial"))
				{ 
					if (mapXexist.hasString("handle"))
					{ 
						if (_ThisInst.handle() == mapXexist.getString("handle"))
						{ 
							Point3d ptInitial = mapXexist.getPoint3d("ptInitial");
							bmi.transformBy((ptInitial - bmi.ptCen()).dotProduct(vecXWall) * vecXWall);
						}
					}
				}
			}//next i
		}
		
		// create the vertical beams for type 2
		{ 
			if (_Map.hasPoint3dArray("ptsVertDel"))
			{
				Point3d ptsVertDelMap[] = _Map.getPoint3dArray("ptsVertDel");
//				reportMessage(("|ptsVertDelMap.length():|") + ptsVertDelMap.length());
				
				Beam beamsWallHor[0];
				beamsWallHor.append(beamsWall);
				// remove from beamswallHor the vertical beams
				for (int i=beamsWallHor.length()-1; i>=0 ; i--) 
				{ 
					Beam bmi = beamsWallHor[i];
					//checks if vectors parallel	
					if (abs(abs(vecYWall.dotProduct(bmi.vecX())) - 1) < dEps)
					{ 
						beamsWallHor.removeAt(i);
					}
				}//next i
				
				if (ptsVertDelMap.length() > 0)
				{ 
					// create the beams
					for (int i = 0; i < ptsVertDelMap.length(); i++)
					{ 
						Point3d pt = ptsVertDelMap[i];
						
						Beam beamsTopLeft[] = Beam().filterBeamsHalfLineIntersectSort(beamsWallHor, pt, vecYWall);
						Beam beamsBottomLeft[]=Beam().filterBeamsHalfLineIntersectSort(beamsWallHor, pt, -vecYWall);
						
						Beam beamBottomLeft;
						Beam beamTopLeft;
						
						if (beamsBottomLeft.length() > 0)
						{ 
							beamBottomLeft = beamsBottomLeft[beamsBottomLeft.length() - 1];
						}
						if (beamsTopLeft.length() > 0)
						{ 
							beamTopLeft = beamsTopLeft[beamsTopLeft.length() - 1];
						}
						
						
						int iColor = beamTopLeft.color();
						String sMaterial = beamTopLeft.name("material");
						
						Beam bmNew;
						bmNew.dbCreate(pt, vecYWall, - vecXWall, vecZWall, U(10), dWallBeamHeight, dWallBeamWidth ,0, 0, 0 );
						bmNew.assignToElementGroup(w, true, 0, 'Z');
						
						if (beamBottomLeft.bIsValid())
						{
							bmNew.stretchDynamicTo(beamBottomLeft);
						}
						else
						{ 
							reportMessage("\n"+scriptName()+" "+T("|no valid bottom...|"));
						}
						if (beamTopLeft.bIsValid())
						{
							bmNew.stretchDynamicTo(beamTopLeft);
						}
						else
						{ 
							reportMessage("\n"+scriptName()+" "+T("|no valid top...|"));
						}
						
						bmNew.setColor(iColor);
						bmNew.setMaterial(sMaterial);
						// HSB-24281
						bmNew.setName(sName);
						bmNew.setGrade(sGrade);
						
						if (beamsWall.find(bmNew) < 0)
						{ 
							beamsWall.append(bmNew);
						}
						
						// set t-einfräsung if top beam is skewed
						if (abs(abs(beamTopLeft.vecX().dotProduct(vecXWall)) - 1) > 0)
						{ 
						// create TSL
							TslInst tslNew;	Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
							GenBeam gbsTsl[] = {}; Entity entsTsl[] = {}; Point3d ptsTsl[] = {_Pt0};
							int nProps[]={}; double dProps[]={}; String sProps[]={};
							Map mapTsl;	
							
							// properties
							// depth
							dProps.setLength(0);
							dProps.append(U(0));
							// dSideGap
							dProps.append(U(0));
							// HSB-17747:
//							// mill completely
//							sProps.append(T("|Yes|"));
//							// color, default green
//							nProps.append(3);
							// male beam
							gbsTsl.append(bmNew);
							// female beam
							gbsTsl.append(beamTopLeft);
							
							tslNew.dbCreate(sTeinfraesung , vecXTsl , vecYTsl, gbsTsl, entsTsl, 
								ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
							if(sEntriesTeinfraesung.find(sMillingStudPlate)>-1)
							{ 
								tslNew.setPropValuesFromCatalog(sMillingStudPlate);
							}
						}
					}//next i
				}
			}
		}
		
		// delete the previously generated beams
		Entity beamsForDel[] = _Map.getEntityArray("beamsForDel", "", "");
		if(beamsForDel.length()>0)
		{ 
			for (int i=beamsForDel.length()-1; i>=0 ; i--) 
			{ 
				Beam bmi = (Beam)beamsForDel[i];
				if(bmi.bIsValid())
				{
					bmi.dbErase();
				}
			}//next i
		}
		// delete from map
		_Map.removeAt("beamsForDel", true);
		
		
	//region apply cuts at the middle beam for type 4
		if (_Map.hasPoint3d("ptTyp4Cut"))
		{ 
			// apply the cut
			Point3d ptCut = _Map.getPoint3d("ptTyp4Cut");
			Vector3d vecNormalCut = _Map.getVector3d("vNormalTyp4Cut");
			Cut ct(ptCut, vecNormalCut);
			// get the beam
			Entity entExisting;
			Beam bmExisting;
			if (_Map.hasEntity("bmExistingTyp4"))
			{ 
				entExisting = _Map.getEntity("bmExistingTyp4");
				bmExisting = (Beam) entExisting;
				bmExisting.addToolStatic(ct, _kStretchOnToolChange);
			}
		}
	//End apply cuts at the middle beam for type 4//endregion 
		
		
//		setExecutionLoops(2);
		if(_kExecuteKey==sTriggerResetAndDelete)
		{ 
			eraseInstance();
		}
		return;
	}//endregion
	
//region connection must not be generated if opening
	// get openings of the wall
	Opening openings[] = w.opening();
	pp2 = pp;// envelope without gap
	double dExtend = dWallBeamHeight + dGap;
	pp2.shrink(-dExtend);
	LineSeg segEnvelope = pp2.extentInDir(vecXWall);
	Point3d ptsEnv[0];
	ptsEnv.append(segEnvelope.ptStart());
	ptsEnv.append(segEnvelope.ptEnd());
	Line ln(ptsEnv[0], vecXWall);
	// order points according to vecXWall
	ptsEnv = ln.orderPoints(ptsEnv);
	// an integer which tracks if there is opening below
	int iHasOp = false;
	for (int i = 0; i < openings.length(); i++)
	{ 
		Opening o = openings[i];
		LineSeg segOpening = PlaneProfile(o.plShape()).extentInDir(vecXWall);
		Point3d ptsOp[0];
		ptsOp.append(segOpening.ptStart());
		ptsOp.append(segOpening.ptEnd());
		Line lnOp(ptsOp[0], vecXWall);
		ptsOp = lnOp.orderPoints(ptsOp);
		
		if((ptsOp[0].dotProduct(vecXWall) > ptsEnv[1].dotProduct(vecXWall) || ptsOp[1].dotProduct(vecXWall) < ptsEnv[0].dotProduct(vecXWall))) 
		{ 
		// opening outside of the envelope area
			continue;
		}
		else 
		{ 
		// no further calculation, elements must not be further generated
		// delete previously generated beams
		// delete the previously generated beams
		
			iHasOp = true;
//			Entity beamsForDel[] = _Map.getEntityArray("beamsForDel", "", "");
//			if(beamsForDel.length()>0)
//			{ 
//				for (int i=beamsForDel.length()-1; i>=0 ; i--) 
//				{ 
//					Beam bmi = (Beam)beamsForDel[i];
//					if(bmi.bIsValid())
//					{
//						bmi.dbErase();
//					}
//				}//next i
//			}
//			// delete from map
//			_Map.removeAt("beamsForDel", true);
//			return;
		}
	}//next i

//End connection must not be generated if opening//endregion 
	
	
//region recreate the deleted vertical beams of type 2 at their original position
	// create for both sides left and right
	if (_Map.hasPoint3dArray("ptsVertDel"))
	{
		Point3d ptsVertDelMap[] = _Map.getPoint3dArray("ptsVertDel");
		Beam beamsWallHor[0];
		beamsWallHor.append(beamsWall);
		// remove from beamswallHor the vertical beams
		for (int i=beamsWallHor.length()-1; i>=0 ; i--) 
		{ 
			Beam bmi = beamsWallHor[i];
			//checks if vectors parallel	
			if (abs(abs(vecYWall.dotProduct(bmi.vecX())) - 1) < dEps)
			{ 
				beamsWallHor.removeAt(i);
			}
		}//next i
		
		if (ptsVertDelMap.length() > 0)
		{ 
			// create the beams
			for (int i = 0; i < ptsVertDelMap.length(); i++)
			{ 
				Point3d pt = ptsVertDelMap[i];
				pt.vis(4);
				Beam beamsTopLeft[] = Beam().filterBeamsHalfLineIntersectSort(beamsWallHor, pt, vecYWall);
				Beam beamsBottomLeft[]=Beam().filterBeamsHalfLineIntersectSort(beamsWallHor, pt, -vecYWall);
				if (beamsTopLeft.length() > 0 && beamsBottomLeft.length() > 0)
				{ 
					Beam beamBottomLeft = beamsBottomLeft[beamsBottomLeft.length() - 1];
					Beam beamTopLeft = beamsTopLeft[beamsTopLeft.length() - 1];
					if (beamBottomLeft.bIsValid() && beamTopLeft.bIsValid())
					{ 
						int iColor = beamTopLeft.color();
						String sMaterial = beamTopLeft.name("material");
						Beam bmNew;
						bmNew.dbCreate(pt, vecYWall, - vecXWall, vecZWall, U(10), dWallBeamHeight, dWallBeamWidth ,0, 0, 0 );
						bmNew.assignToElementGroup(w, true, 0, 'Z');
						bmNew.stretchDynamicTo(beamBottomLeft);
						bmNew.stretchDynamicTo(beamTopLeft);
						
						bmNew.setColor(iColor);
						bmNew.setMaterial(sMaterial);
						// HSB-24281
						bmNew.setName(sName);
						bmNew.setGrade(sGrade);
						
						if (beamsWall.find(bmNew) < 0)
						{ 
							beamsWall.append(bmNew);
						}
						
						// set t-einfräsung if top beam is skewed
						if (abs(abs(beamTopLeft.vecX().dotProduct(vecXWall)) - 1) > 0)
						{ 
						// create TSL
							TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
							GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
							int nProps[]={};			double dProps[]={};				String sProps[]={};
							Map mapTsl;	
							
							// properties
							// depth
							dProps.setLength(0);
							dProps.append(U(0));
							// dSideGap
							dProps.append(U(0));
							// HSB-17747:
							// mill completely
//							sProps.append(T("|Yes|"));
//							// color, default green
//							nProps.append(3);
							// male beam
							gbsTsl.append(bmNew);
							// female beam
							gbsTsl.append(beamTopLeft);
							
							tslNew.dbCreate(sTeinfraesung , vecXTsl , vecYTsl, gbsTsl, entsTsl, 
								ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
							if(sEntriesTeinfraesung.find(sMillingStudPlate)>-1)
							{ 
								tslNew.setPropValuesFromCatalog(sMillingStudPlate);
							}
						}
					}
				}
			}//next i
		}
	}
//End recreate the deleted vertical beams at their original position//endregion 
	
if(bDebug)reportMessage("\n"+ scriptName() + "dGap "+dGap);
//region splitt the beams
	Point3d pLeftExtreme = pBottomLeft - .5 * dWallBeamWidth * vecZWall 
                         - (dGap + dWallBeamHeight + dEps) * vecXWall - .5 * ( dWallBeamHeight) * vecYWall;
	Point3d pRightExtreme = pBottomLeft - .5 * dWallBeamWidth * vecZWall + (ppWidthX 
	                           + dGap + dWallBeamHeight + dEps) * vecXWall - .5 * ( dWallBeamHeight) * vecYWall;
	Point3d pCen = .5 * (pLeftExtreme + pRightExtreme);
	
	// get the top beam of the sf wall
	// delete if it intersect the main beam Pfette
	// split all beams that intersect with the main Pfette
	Point3d pBottomLeftCut = pBottomLeft - dGap * vecXWall;
	Point3d pTopRightCut = pTopRight + dGap * vecXWall;
	Cut cutLeft(pBottomLeftCut, vecXWall);
	// cuts the right beam
	Cut cutRight(pTopRightCut ,- vecXWall);
	
	// do the calculation for splitting the beams
	// entry of the splitted beams is empty generate again
	for (int i=0;i<beamsWall.length();i++) 
	{
		Beam bmi = beamsWall[i];
		// vertical beams are excluded
		if(bmi.vecX().dotProduct(vecXWall)<dEps)
		{
			// beam vertical, normal with VecXWall is excluded
			continue;
		}
		Body bodyBmi = bmi.envelopeBody(true, true);
		// make sure the cut is always generated
		PlaneProfile ppZBeami = bodyBmi.shadowProfile(Plane(ptOrg, vecZWall));
		ppZBeami.vis(90);
		int iHasIntersection = ppZBeami.intersectWith(pPsymbolGap);
		
//		int iHasIntersection = bodyBeam.hasIntersection(bodyBmi); // intersection between 2 beam bodies
		if(!iHasIntersection)
		{ 
			// no intersection, consider next beam
			continue;
		}
		
		// create a left and a right plane of the pp Symbol
		Plane plLeft(pBottomLeftCut-dEps*vecXWall, vecXWall);// plane at left
		Plane plRight(pTopRightCut+dEps*vecXWall, vecXWall);// plane at right
		
		PlaneProfile ppLeft = bodyBmi.getSlice(plLeft);// cut with left plane
		PlaneProfile ppRight = bodyBmi.getSlice(plRight);
		//a)only left
		if(ppLeft.numRings()>0 && ppRight.numRings()<1)
		{ 
			bmi.addToolStatic(cutLeft, _kStretchOnToolChange);
		}
		//b) only right
		else if(ppRight.numRings()>0 && ppLeft.numRings()<1)
		{ 
			bmi.addToolStatic(cutRight, _kStretchOnToolChange);// remains in the right side
		}
		//c) both sides have cuts
		else if(ppLeft.numRings()>0 && ppRight.numRings()>0)
		{ 
			// left top beam is also cut with the right plane
			// one continuous beam cutted left and right
			//Line of the beam
			
			Line lnBeam(bmi.ptCen(), bmi.vecX());
			//Plane of pCen
			Plane plCen(pCen, vecXWall);// plane in middle of pp symbol
			Point3d pIntersect;
			int iHasInter = lnBeam.hasIntersection(plCen, pIntersect);
			//Cuts
			Cut cutLeft(pBottomLeftCut, vecXWall);// cuts the left beam
			Cut cutRight(pTopRightCut ,- vecXWall);// cuts the right beam
			
			if(bmi.vecX().dotProduct(vecXWall)>0)
			{ 
				// beam same direction as vecXWall
				Beam newBeamRight = bmi.dbSplit(pIntersect, pIntersect);
				// check that cutLeft not lefter than left point/////////!!!!!!!!!!!!!!
				bmi.addToolStatic(cutLeft, _kStretchOnToolChange);
				newBeamRight.addToolStatic(cutRight, _kStretchOnToolChange);
				beamsWall.append(newBeamRight);// the newly created beam added at wall beams
			}
			else if(bmi.vecX().dotProduct(vecXWall)<0)
			{ 
				// beam X oposite to vecXWall
				Beam newBeamLeft = bmi.dbSplit(pIntersect, pIntersect);
				bmi.addToolStatic(cutRight, _kStretchOnToolChange);// remains in the right side
				newBeamLeft.addToolStatic(cutLeft, _kStretchOnToolChange);// newly created in the left side
				beamsWall.append(newBeamLeft);// the newly created beam added at wall beams
			}
		}
	}//next i
//End splitt the beams//endregion 
	
//region bCreate
	// iTriggerRecalc==_kNameLastChangedProp==sGapName || _kNameLastChangedProp==sTopOpenName
	int bCreate=false; // flag for deciding for the dbCreate 
	if(_bOnDbCreated || _bOnElementConstructed || _bOnRecalc || iBeamTrigger || iTriggerRecalc
	   || _kNameLastChangedProp==sTypeName)
   { 
   		// each time any of those is triggered, bCreate will be set to true
   		//_bOnDbCreated - first time the entity is entererd in database
   		//_bOnElementConstructed - each time the element attached to the TSL (Wall) is constructed
   		//_bOnElementRecalc - each time the element attached to the TSL is recalculated
   		//iBeamTrigger - each time intrsecting beam is modified
   		//_kNameLastChangedProp - each time any of the properties is changed
   		bCreate = true;
   }
   
//End bCreate//endregion
//	bCreate = true;////
//	reportMessage(("|iBeamTrigger: |")+iBeamTrigger);
//	reportMessage(("|bCreate: |")+bCreate);
if(bDebug)reportMessage("\n"+ scriptName() + " bCreate: "+bCreate);
	
	// dont trigger if bonrecalc but section and position are the same
   	if (_bOnRecalc && !iBeamTrigger)
   	{
//   		bCreate = false;
   	}
	if(!bCreate)
	{ 
		// nothing happens otherwise
		return;
	}
	
//region apply cuts at the middle beam for type 4
	if (_Map.hasPoint3d("ptTyp4Cut"))
	{ 
		// apply the cut
		Point3d ptCut = _Map.getPoint3d("ptTyp4Cut");
		Vector3d vecNormalCut = _Map.getVector3d("vNormalTyp4Cut");
		Cut ct(ptCut, vecNormalCut);
		// get the beam
		Entity entExisting;
		Beam bmExisting;
		if (_Map.hasEntity("bmExistingTyp4"))
		{ 
			entExisting = _Map.getEntity("bmExistingTyp4");
			bmExisting = (Beam) entExisting;
			bmExisting.addToolStatic(ct, _kStretchOnToolChange);
		}
	}
//End apply cuts at the middle beam for type 4//endregion 
	
	
//region delete previously generated beams before the new generation
	// get beams previously generated to be deleted
// use _Map instead of _Beams, because _Beams is also used to storing
// modified beams, e.g. beams with Cut
	
	int iType = sTypes.find(sType);
	if (iType != 1)
	{ 
		Entity beamsForDel[] = _Map.getEntityArray("beamsForDel", "", "");
		if(beamsForDel.length()>0)
		{ 
			for (int i=beamsForDel.length()-1; i>=0 ; i--) 
			{ 
				Beam bmi = (Beam)beamsForDel[i];
				if(bmi.bIsValid())
				{
					bmi.dbErase();
				}
		//		beamsForDel[i].dbErase();// delete existing beams
			}//next i
			_Map.removeAt("beamsForDel", true);
		}
	}
	
	Beam beamsForDel[0];
	// get all beamsfrodel
	Entity ebeamsForDel[] = _Map.getEntityArray("beamsForDel", "", "");
	if(ebeamsForDel.length()>0)
	{ 
		for (int i = 0; i < ebeamsForDel.length(); i++)
		{ 
			Beam bmi = (Beam)ebeamsForDel[i];
			if(bmi.bIsValid())
			{
				if (beamsForDel.find(bmi) < 0)
				{ 
					beamsForDel.append(bmi);
				}
			}
	//		beamsForDel[i].dbErase();// delete existing beams
		}//next i
	}
//End delete previously generated beams//endregion 

//region generate connection
	// get int number of selected property from the list
	Entity beamsForDelStore[0];// beams to be deleted
	if (iType == 0)
	{
		//End apply cuts at the middle beam for type 4//endregion 
		// type1
		// generate this type
		// delete existing vertical beams in SF wall
		pCen.vis(4);
		Beam beamsLeftDel[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, pCen, - vecXWall);
		Beam beamsRightDel[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, pCen, vecXWall);
		
		for (int i = beamsLeftDel.length() - 1; i >= 0; i--)
		{ 
			// 0 - reserved for the main beam Pfette
			// 1,2 - reserved for the beams where cut will be applied
			// 3,4.. - reserved for 
			Beam bm = beamsLeftDel[i];
			if(abs(abs(bm.vecX().dotProduct(vecYWall)) - bm.vecX().length()*vecYWall.length())>dEps)
			{ 
				// beam not vertical will be excluded
				continue;
			}
			Body bodyBeam = bm.envelopeBody(true, true);
			// shadow of the body in xy of wall
			PlaneProfile pPBeam = bodyBeam.shadowProfile(planeWall);
			LineSeg lSegBeam = pPBeam.extentInDir(vecXWall);
			Point3d ptTopRight = lSegBeam.ptEnd();
			if((ptTopRight-pLeftExtreme).dotProduct(vecXWall)>0)
			{ 
				// ptTopRight on the right of pLeftExtreme, beam must be deleted
				beamsLeftDel[i].dbErase();
			}
		}//next i
	
		for (int i = beamsRightDel.length() - 1; i >= 0; i--)
		{ 
			Beam bm = beamsRightDel[i];
			if(abs(abs(bm.vecX().dotProduct(vecYWall)) - bm.vecX().length()*vecYWall.length())>dEps)
			{ 
				// beam not vertical will be excluded
				continue;
			}
			Body bodyBeam = bm.envelopeBody(true, true);
			// shadow of the body in xy of wall
			PlaneProfile pPBeam = bodyBeam.shadowProfile(planeWall);
			LineSeg lSegBeam = pPBeam.extentInDir(vecXWall);
			Point3d ptBottomLeft = lSegBeam.ptStart();
			if((ptBottomLeft-pRightExtreme).dotProduct(vecXWall)<0)
			{ 
				// ptBottomLeft on the left of pRightExtreme, beam must be deleted
				beamsRightDel[i].dbErase();
			}
		}//next i
		// end - delete existing vertical beams in SF wall
		
		// point at the center of the first vertical beam on the left
		Point3d ptLeft = pBottomLeft - .5 * dWallBeamWidth * vecZWall - (dGap + .5 * dWallBeamHeight) * vecXWall;
		Point3d ptRight = pBottomLeft - .5 * dWallBeamWidth * vecZWall + (ppWidthX + dGap + .5 * dWallBeamHeight) * vecXWall;
		
		// find bounding beams at top and bottom for the beam at left side
		Beam beamsTopLeft[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, ptLeft, vecYWall);
		Beam beamsBottomLeft[]=Beam().filterBeamsHalfLineIntersectSort(beamsWall, ptLeft, -vecYWall);
		// find beams at top and bottom for the beam at right side
		Beam beamsTopRight[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, ptRight, vecYWall);
		Beam beamsBottomRight[]=Beam().filterBeamsHalfLineIntersectSort(beamsWall, ptRight, -vecYWall);
		
		if (beamsTopLeft.length()<1 || beamsBottomLeft.length()<1
				 || beamsTopRight.length() < 1 || beamsBottomRight.length() < 1)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|stick frame wall has no beam at the top or bottom|"));
			// just return and leave the TSL in the drawing
			return;
		}
		// beams at left
		Beam beamTopLeft = beamsTopLeft[beamsTopLeft.length() - 1];
		Beam beamBottomLeft = beamsBottomLeft[beamsBottomLeft.length() - 1];
		// beams at right
		Beam beamTopRight = beamsTopRight[beamsTopRight.length() - 1];
		Beam beamBottomRight = beamsBottomRight[beamsBottomRight.length() - 1];
		// if there is opening below, take the first beam
		if (iHasOp)
		{ 
			beamBottomLeft = beamsBottomLeft[0];
			beamBottomRight = beamsBottomRight[0];
		}
		
	// get material and color of the wall beam
		String sMaterial = beamTopLeft.name("material");
		int iColor = beamTopLeft.color();
		
	// generate beam at the left
		Beam newBeamLeft;
		newBeamLeft.dbCreate(ptLeft, vecYWall, - vecXWall, vecZWall, 1.0/100, dWallBeamHeight, dWallBeamWidth );
		newBeamLeft.assignToElementGroup(w, true, 0, 'Z');
		newBeamLeft.stretchDynamicTo(beamTopLeft);
		newBeamLeft.stretchDynamicTo(beamBottomLeft);
		newBeamLeft.setColor(iColor);
		newBeamLeft.setMaterial(sMaterial);
		// HSB-24281
		newBeamLeft.setName(sName);
		newBeamLeft.setGrade(sGrade);
		// save the instance of the new beam to the TSL
		// _Beam[0] is the main beam Pfete
		Beam newBeamRight;
		newBeamRight.dbCreate(ptRight, vecYWall, - vecXWall, vecZWall, 1.0/100, dWallBeamHeight, dWallBeamWidth );
		newBeamRight.assignToElementGroup(w, true, 0, 'Z');
		newBeamRight.stretchDynamicTo(beamTopRight);
		newBeamRight.stretchDynamicTo(beamBottomRight);
		newBeamRight.setColor(iColor);
		newBeamRight.setMaterial(sMaterial);
		// HSB-24281
		newBeamRight.setName(sName);
		newBeamRight.setGrade(sGrade);
		
		// create t-Einfräsung milling between the vertical and the top beam
		if (abs(abs(beamTopLeft.vecX().dotProduct(vecXWall)) - 1) > 0)
		{ 
			// beam not aligned with vecXWall, create milling
			Entity entsTslMillingNew[0];
			
		// delete previously created TSL
			{ 
				Entity entsTslMilling[] = _Map.getEntityArray("entsTslMilling", "", "");
				if(entsTslMilling.length()>0)
				{ 
					for (int i=entsTslMilling.length()-1; i>=0 ; i--) 
					{ 
						TslInst tsli = (TslInst)entsTslMilling[i];
						if(tsli.bIsValid())
						{
							tsli.dbErase();
						}
					}//next i
				}
				// delete from map
				_Map.removeAt("entsTslMilling", true);
			}
		// create TSL
			TslInst tslNew;	Vector3d vecXTsl=_XW; Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[]={}; Entity entsTsl[]={}; Point3d ptsTsl[] = {_Pt0};
			int nProps[]={}; double dProps[]={}; String sProps[]={};
			Map mapTsl;	
			
			// properties
			// depth
			dProps.setLength(0);
			dProps.append(U(0));
			// dSideGap
			dProps.append(U(0));
			// HSB-17747:
			// mill completely
//			sProps.append(T("|Yes|"));
//			// color, default green
//			nProps.append(3);
			// male beam
			gbsTsl.append(newBeamLeft);
			// female beam
			gbsTsl.append(beamTopLeft);
			
			tslNew.dbCreate(sTeinfraesung , vecXTsl , vecYTsl, gbsTsl, entsTsl, 
				ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			
			if(sEntriesTeinfraesung.find(sMillingStudPlate)>-1)
			{ 
				tslNew.setPropValuesFromCatalog(sMillingStudPlate);
			}
			// save in map
			entsTslMillingNew.append(tslNew);
			
			gbsTsl.setLength(0);
			// male beam
			gbsTsl.append(newBeamRight);
			// female beam
			gbsTsl.append(beamTopRight);
			
			tslNew.dbCreate(sTeinfraesung , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			if(sEntriesTeinfraesung.find(sMillingStudPlate)>-1)
			{ 
				tslNew.setPropValuesFromCatalog(sMillingStudPlate);
			}
			// save in map
			entsTslMillingNew.append(tslNew);
			if (entsTslMillingNew.length() > 0)
			{ 
				// some angle brackets are created, save in map
				_Map.setEntityArray(entsTslMillingNew, true, "entsTslMilling", "", "");
			}
		}
		
		// generate horizontal beam
		Point3d pHorizontal = ptLeft + (0.5 * ppWidthX + dGap + .5 * dWallBeamHeight) * vecXWall - .5 * ( dWallBeamHeight) * vecYWall;
		
		Beam newBeamHorizontal;
		newBeamHorizontal.dbCreate(pHorizontal, vecXWall, vecYWall, vecZWall, 1.0/100, dWallBeamHeight, dWallBeamWidth );
		newBeamHorizontal.assignToElementGroup(w, true, 0, 'Z');
		newBeamHorizontal.stretchDynamicTo(newBeamLeft);
		newBeamHorizontal.stretchDynamicTo(newBeamRight);
		newBeamHorizontal.setColor(iColor);
		newBeamHorizontal.setMaterial(sMaterial);
		// HSB-24281
		newBeamHorizontal.setName(sName);
		newBeamHorizontal.setGrade(sGrade);
		Point3d ptMiddle = newBeamHorizontal.ptCen() - dWallBeamHeight * vecYWall;
		
		Beam newBeamMiddle;
		newBeamMiddle.dbCreate(ptMiddle, vecYWall, - vecXWall, vecZWall, 1.0/100, dWallBeamHeight, dWallBeamWidth );
		newBeamMiddle.assignToElementGroup(w, true, 0, 'Z');
		newBeamMiddle.stretchDynamicTo(newBeamHorizontal);
		newBeamMiddle.stretchDynamicTo(beamBottomRight);
		newBeamMiddle.setColor(iColor);
		newBeamMiddle.setMaterial(sMaterial);
		// HSB-24281
		newBeamMiddle.setName(sName);
		newBeamMiddle.setGrade(sGrade);
		
		// store in map all newly created beams
		beamsForDelStore.append(Beam(newBeamLeft));
		beamsForDelStore.append(Beam(newBeamRight));
		beamsForDelStore.append(Beam(newBeamHorizontal));
		beamsForDelStore.append(Beam(newBeamMiddle));
		_Map.setEntityArray(beamsForDelStore, true, "beamsForDel", "", "");
	}
	else if (iType == 1)
	{ 
		//End apply cuts at the middle beam for type 4//endregion 
if(bDebug)reportMessage("\n"+ scriptName() + "Enters typ 2 ");
if(bDebug)reportMessage("\n"+ scriptName() + " dGap Type 2: "+dGap);		
		// second type,similar to type 1 but space between 2 vertical beams is filled
		// delete existing vertical beams in SF wall
		pCen.vis(4);
		Beam beamsLeftDel[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, pCen-dEps*vecXWall, - vecXWall);
		Beam beamsRightDel[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, pCen+dEps*vecXWall, vecXWall);
		// exclude from beamsRightDel any beam if contained in beamsLeftDel
		for (int i = beamsRightDel.length() - 1; i >= 0; i--)
		{ 
			if (beamsLeftDel.find(beamsRightDel[i]) >- 1)
			{ 
				beamsRightDel.removeAt(i);
			}
		}//next i
		
		// counter for the vertical beams to be deleted
		Point3d ptsVertDel[0];
		
		// end - delete existing vertical beams in SF wall
		pLeftExtreme.vis(1);
		pRightExtreme.vis(1);
		// point at the center of the first vertical beam on the left
		Point3d ptLeft = pBottomLeft - .5 * dWallBeamWidth * vecZWall - (dGap + .5 * dWallBeamHeight) * vecXWall;
		Point3d ptRight = pBottomLeft - .5 * dWallBeamWidth * vecZWall + (ppWidthX + dGap + .5 * dWallBeamHeight) * vecXWall;
		
		Beam beamsWallHor[0];
		beamsWallHor.append(beamsWall);
		// remove from beamswallHor the vertical beams
		for (int i=beamsWallHor.length()-1; i>=0 ; i--) 
		{ 
			Beam bmi = beamsWallHor[i];
			//checks if vectors parallel	
			if (abs(abs(vecYWall.dotProduct(bmi.vecX())) - 1) < dEps)
			{ 
				beamsWallHor.removeAt(i);
			}
		}//next i
		
		// find beams at top and bottom for the beam at left side
		Beam beamsTopLeft[] = Beam().filterBeamsHalfLineIntersectSort(beamsWallHor, ptLeft, vecYWall);
		Beam beamsBottomLeft[] = Beam().filterBeamsHalfLineIntersectSort(beamsWallHor, ptLeft, - vecYWall);
		// find beams at top and bottom for the beam at right side
		Beam beamsTopRight[] = Beam().filterBeamsHalfLineIntersectSort(beamsWallHor, ptRight, vecYWall);
		Beam beamsBottomRight[] = Beam().filterBeamsHalfLineIntersectSort(beamsWallHor, ptRight, - vecYWall);
		
//		if (beamsTopLeft.length()<1 || beamsBottomLeft.length()<1
//				|| beamsTopRight.length()<1 || beamsBottomRight.length()<1)
//		{
//			reportMessage(TN("|stick frame wall has no beam at the top or bottom|"));
//	//		eraseInstance();
//			return;
//		}
		
		Beam beamTopLeft;
		Beam beamBottomLeft;
		if (beamsTopLeft.length() > 0)
		{ 
			// beams at left
			beamTopLeft = beamsTopLeft[beamsTopLeft.length() - 1];
			beamBottomLeft = beamsBottomLeft[beamsBottomLeft.length() - 1];
		}
		
		Beam beamTopRight;
		Beam beamBottomRight;
		if (beamsTopRight.length() > 0)
		{ 
			// beams at right
			beamTopRight = beamsTopRight[beamsTopRight.length() - 1];
			beamTopRight.envelopeBody().vis(2);
			beamBottomRight = beamsBottomRight[beamsBottomRight.length() - 1];
		}
		
		// if there is opening below, take the first beam
		if (iHasOp)
		{ 
			if (beamsBottomLeft.length() > 0)
			{
				beamBottomLeft = beamsBottomLeft[0];
			}
			if (beamsBottomRight.length() > 0)
			{
				beamBottomRight = beamsBottomRight[0];
			}
		}
		
		String sMaterial;
		int iColor;
		if (beamTopLeft.bIsValid())
		{ 
			sMaterial = beamTopLeft.name("material");
			iColor = beamTopLeft.color();
		}
		else if (beamTopRight.bIsValid())
		{ 
			sMaterial = beamTopRight.name("material");
			iColor = beamTopRight.color();
		}
//		reportMessage(("|iBeamTrigger: |")+iBeamTrigger);
		
		// left and right beam needed for checking the collusion
		Beam beamLeft;
		Beam beamRight;
		Beam beamLeftMap;
		Beam beamRightMap;
		{ 
			if (_Map.hasEntity("newBeamLeft") && _Map.hasEntity("newBeamRight"))
			{
				Entity eBeamLeft = _Map.getEntity("newBeamLeft");
				Entity eBeamRight = _Map.getEntity("newBeamRight");
				beamLeftMap = (Beam)eBeamLeft;
				beamRightMap = (Beam)eBeamRight;
			}
		}
		
		if ( ! iBeamTrigger && ! iTriggerRecalc && (beamLeftMap.bIsValid() || beamRightMap.bIsValid()))
		{ 
			if(bDebug)reportMessage("\n"+ scriptName() + " no trigger here");
			
//			return;
			if(_Map.hasEntity("newBeamLeft") && _Map.hasEntity("newBeamRight"))
			{ 
				Entity eBeamLeft = _Map.getEntity("newBeamLeft");
				Entity eBeamRight = _Map.getEntity("newBeamRight");
				beamLeft = (Beam)eBeamLeft;
				beamRight = (Beam)eBeamRight;
			}
			else
			{ 
				reportMessage("\n"+scriptName()+" "+T("|unexpected error|"));
				reportMessage("\n"+scriptName()+" "+T("|left or right beam not found|"));
				eraseInstance();
				return;
			}
		}
		else
		// start drawing the beams from the middle point and going left and right
		{ 
			for (int ii = beamsForDel.length() - 1; ii >= 0; ii--)
			{ 
				beamsForDel[ii].dbErase(); 
			}//next ii
			
			//start of the left edge of the first vertical beam
			Point3d ptMiddle = .5 * (ptLeft + ptRight);
			ptMiddle.vis(3);
			// draw beams on left until they are inside the ppWidthX + 2 * dGap 
			double dLengthBeamHorizontal = ppWidthX + 2 * dGap;
			
			// draw left and right
			int iNrBeamsSide = .5 * dLengthBeamHorizontal / dWallBeamHeight;
			Beam newBeamMiddle[0];
			Point3d pt;
			// it will do the following if at least 1 beam per side is accomodated 
			for (int i = 0; i < iNrBeamsSide; i++)
			{ 
				// right
				pt = ptMiddle + i * dWallBeamHeight * vecXWall;
				Beam beamsBottomRight[] = Beam().filterBeamsHalfLineIntersectSort(beamsWallHor, pt, - vecYWall);
				Beam beamBottomRight = beamsBottomRight[beamsBottomRight.length() - 1];
				if (iHasOp)
				{ 
					if (beamsBottomRight.length() > 0)
					{
						beamBottomRight = beamsBottomRight[0];
					}
				}
				
				if (beamBottomRight.bIsValid())
				{ 
					Beam bmNew;
					bmNew.dbCreate(pt, vecYWall, - vecXWall, vecZWall, U(10), dWallBeamHeight, dWallBeamWidth ,- 1, -1, 0 );
					bmNew.assignToElementGroup(w, true, 0, 'Z');
					bmNew.stretchDynamicTo(beamBottomRight);
					bmNew.setColor(iColor);
					bmNew.setMaterial(sMaterial);
					// HSB-24281
					bmNew.setName(sName);
					bmNew.setGrade(sGrade);
					//
					newBeamMiddle.append(bmNew);
					beamsForDelStore.append(bmNew);
				}
				
				// left
				pt = ptMiddle - i * dWallBeamHeight * vecXWall;
				Beam beamsBottomLeft[]=Beam().filterBeamsHalfLineIntersectSort(beamsWallHor, pt, -vecYWall);
				Beam beamBottomLeft = beamsBottomLeft[beamsBottomLeft.length() - 1];
				if (iHasOp)
				{ 
					if (beamsBottomLeft.length() > 0)
					{
						beamBottomLeft = beamsBottomLeft[0];
					}
				}
				
				if (beamBottomLeft.bIsValid())
				{ 
					Beam bmNew;
					bmNew.dbCreate(pt, vecYWall, - vecXWall, vecZWall, U(10), dWallBeamHeight, dWallBeamWidth ,- 1, 1, 0 );
					bmNew.assignToElementGroup(w, true, 0, 'Z');
					bmNew.stretchDynamicTo(beamBottomLeft);
					bmNew.setColor(iColor);
					bmNew.setMaterial(sMaterial);
					// HSB-24281
					bmNew.setName(sName);
					bmNew.setGrade(sGrade);
					//
					newBeamMiddle.append(bmNew);
					beamsForDelStore.append(bmNew);
				}
			}//next i
			if (iNrBeamsSide == 0)
			{ 
				if (dLengthBeamHorizontal > dWallBeamHeight)
				{ 
					// a full beam can be accomodated
					//draw a full beam and what remains; start from right
					// right -> full beam
					pt = ptMiddle + .5 * dLengthBeamHorizontal * vecXWall;
					Beam bmNew;
					bmNew.dbCreate(pt, vecYWall, - vecXWall, vecZWall, U(10), dWallBeamHeight, dWallBeamWidth ,- 1, 1, 0 );
					bmNew.assignToElementGroup(w, true, 0, 'Z');
					bmNew.stretchDynamicTo(beamBottomRight);
					bmNew.setColor(iColor);
					bmNew.setMaterial(sMaterial);
					// HSB-24281
					bmNew.setName(sName);
					bmNew.setGrade(sGrade);
					//
					newBeamMiddle.append(bmNew);
					beamsForDelStore.append(bmNew);
					// left -> cutted beam
					pt = pt - vecXWall * dWallBeamHeight;
					bmNew.dbCreate(pt, vecYWall, - vecXWall, vecZWall, U(10), (dLengthBeamHorizontal - dWallBeamHeight), dWallBeamWidth ,- 1, 1, 0 );
					bmNew.assignToElementGroup(w, true, 0, 'Z');
					bmNew.stretchDynamicTo(beamBottomLeft);
					bmNew.setColor(iColor);
					bmNew.setMaterial(sMaterial);
					// HSB-24281
					bmNew.setName(sName);
					bmNew.setGrade(sGrade);
					//
					newBeamMiddle.append(bmNew);
					beamsForDelStore.append(bmNew);
				}
				else
				{ 
					// one beam that need to be cutted
					pt = ptMiddle;
					Beam bmNew;
					bmNew.dbCreate(pt, vecYWall, - vecXWall, vecZWall, U(10), dLengthBeamHorizontal, dWallBeamWidth ,- 1, 0, 0 );
					bmNew.assignToElementGroup(w, true, 0, 'Z');
					bmNew.stretchDynamicTo(beamBottomRight);
					bmNew.setColor(iColor);
					bmNew.setMaterial(sMaterial);
					// HSB-24281
					bmNew.setName(sName);
					bmNew.setGrade(sGrade);
					//
					newBeamMiddle.append(bmNew);
					beamsForDelStore.append(bmNew);
				}
			}
			
			// newBeamLeft, newBeamRight
			if (iNrBeamsSide > 0)
			{ 
				pt = ptMiddle + iNrBeamsSide * dWallBeamHeight * vecXWall;
			}
			else
			{ 
				pt = ptMiddle + .5 * dLengthBeamHorizontal * vecXWall;
			}
			
			Beam newBeamRight;
			if (beamTopRight.bIsValid() && beamBottomRight.bIsValid())
			{ 
				newBeamRight.dbCreate(pt, vecYWall, - vecXWall, vecZWall, 1.0/100, dWallBeamHeight, dWallBeamWidth,- 1, -1, 0 );
				newBeamRight.assignToElementGroup(w, true, 0, 'Z');
				newBeamRight.stretchDynamicTo(beamTopRight);
				newBeamRight.stretchDynamicTo(beamBottomRight);
				newBeamRight.setColor(iColor);
				newBeamRight.setMaterial(sMaterial);
				// HSB-24281
				newBeamRight.setName(sName);
				newBeamRight.setGrade(sGrade);
				//
				beamsForDelStore.append(newBeamRight);
			}
			
			if (iNrBeamsSide > 0)
			{ 
				pt = ptMiddle - iNrBeamsSide * dWallBeamHeight * vecXWall;
			}
			else
			{ 
				pt = ptMiddle - .5 * dLengthBeamHorizontal * vecXWall;
			}
			
			Beam newBeamLeft;
			if (beamTopLeft.bIsValid() && beamBottomLeft.bIsValid())
			{ 
				newBeamLeft.dbCreate(pt, vecYWall, - vecXWall, vecZWall, 1.0/100, dWallBeamHeight, dWallBeamWidth,- 1, 1, 0 );
				newBeamLeft.assignToElementGroup(w, true, 0, 'Z');
				newBeamLeft.stretchDynamicTo(beamTopLeft);
				newBeamLeft.stretchDynamicTo(beamBottomLeft);
				newBeamLeft.setColor(iColor);
				newBeamLeft.setMaterial(sMaterial);
				// HSB-24281
				newBeamLeft.setName(sName);
				newBeamLeft.setGrade(sGrade);
				//
				beamsForDelStore.append(newBeamLeft);
			}
			
			// save in map the extreme newBeamLeft and newBeamRight
			_Map.setEntity("newBeamLeft", newBeamLeft);
			_Map.setEntity("newBeamRight", newBeamRight);
			beamLeft = newBeamLeft;
			beamRight = newBeamRight;
			
//			// delete beams that collide on the left side
//			for (int i = beamsLeftDel.length() - 1; i >= 0; i--)
//			{ 
//				// 0 - reserved for the main beam Pfette
//				// 1,2 - reserved for the beams where cut will be applied
//				// 3,4.. - reserved for 
//				Beam bm = beamsLeftDel[i];
//				
//				if(abs(abs(bm.vecX().dotProduct(vecYWall)) - bm.vecX().length()*vecYWall.length())>dEps)
//				{ 
//					// beam not vertical will be excluded
//					continue;
//				}
//				Point3d ptLeftExtreme = newBeamLeft.ptCen();
//				
//				if ((bm.ptCen() - newBeamLeft.ptCen()).dotProduct(vecXWall) > dEps)
//				{ 
//					// beam fully colluded, erase it 
//					// save the center position for regeneration
//					if (ptsVertDel.find(beamsLeftDel[i].ptCen()) < 0)
//					{ 
//						// new point, append it
//						ptsVertDel.append(beamsLeftDel[i].ptCen());
//					}
//					// erase the beam
//					beamsLeftDel[i].dbErase();
//				}
//				else if ((bm.ptCen() - newBeamLeft.ptCen()).dotProduct(vecXWall) > -dWallBeamHeight)
//				{ 
//					// not a full collision, delete it and recreate it displaced
////					if (ptsVertDel.find(beamsLeftDel[i].ptCen()) < 0)
////					{ 
//						// new point, append it
////						ptsVertDel.append(beamsLeftDel[i].ptCen());
////					}
//					
//					// create new beam at new position
//					Point3d pt = beamsLeftDel[i].ptCen();
//					pt += (newBeamLeft.ptCen() - dWallBeamHeight * vecXWall - pt).dotProduct(vecXWall) * vecXWall;
//					// save in mapx
//					Map mapXexist = beamsLeftDel[i].subMapX("mapX");
//					if ( ! mapXexist.hasPoint3d("ptInitial"))
//					{ 
//						Map mapX;
//						mapX.setPoint3d("ptInitial", beamsLeftDel[i].ptCen());
//						// save the TSL handle
//						mapX.setString("handle", _ThisInst.handle());
//						beamsLeftDel[i].setSubMapX("mapX", mapX);
//					}
//					
//					// displace the beam at new position 
//					Vector3d vecDisp = (pt - beamsLeftDel[i].ptCen()).dotProduct(vecXWall) * vecXWall;
//					if (vecDisp.length() > dEps)
//					{ 
//						beamsLeftDel[i].transformBy(vecDisp);
//					}
//
//					
////					Beam beamsTopLeft[] = Beam().filterBeamsHalfLineIntersectSort(beamsWallHor, pt, vecYWall);
////					Beam beamsBottomLeft[]=Beam().filterBeamsHalfLineIntersectSort(beamsWallHor, pt, -vecYWall);
////					if (beamsTopLeft.length() > 0 && beamsBottomLeft.length() > 0)
////					{ 
////						Beam beamBottomLeft = beamsBottomLeft[beamsBottomLeft.length() - 1];
////						Beam beamTopLeft = beamsTopLeft[beamsTopLeft.length() - 1];
////						
////						int iColor = beamTopLeft.color();
////						String sMaterial = beamTopLeft.name("material");
////						
////						Beam bmNew;
////						bmNew.dbCreate(pt, vecYWall, vecXWall, - vecZWall, U(10), dWallBeamHeight, dWallBeamWidth ,- 1, 0, 0 );
////						bmNew.assignToElementGroup(w, true, 0, 'Z');
////						bmNew.stretchDynamicTo(beamBottomLeft);
////						bmNew.stretchDynamicTo(beamTopLeft);
////						
////						bmNew.setColor(iColor);
////						bmNew.setMaterial(sMaterial);
////						beamsForDelStore.append(bmNew);
////					}
////					// erase the beam
////					// beam will be sowieso deleted because there is collusion
////					beamsLeftDel[i].dbErase();
//				}
//			}//next i
//			
//			// delete beams that collide on the right side
//			for (int i = beamsRightDel.length() - 1; i >= 0; i--)
//			{ 
//				// 0 - reserved for the main beam Pfette
//				// 1,2 - reserved for the beams where cut will be applied
//				// 3,4.. - reserved for 
//				Beam bm = beamsRightDel[i];
//				
//				if(abs(abs(bm.vecX().dotProduct(vecYWall)) - bm.vecX().length()*vecYWall.length())>dEps)
//				{ 
//					// beam not vertical will be excluded
//					continue;
//				}
//				Point3d ptRightExtreme = newBeamRight.ptCen();
//				
//				if ((bm.ptCen() - newBeamRight.ptCen()).dotProduct(vecXWall) < -dEps)
//				{ 
//					// beam fully colluded, erase it 
//					// save the center position for regeneration
//					if (ptsVertDel.find(beamsRightDel[i].ptCen()) < 0)
//					{ 
//						// new point, append it
//						ptsVertDel.append(beamsRightDel[i].ptCen());
//					}
//					// erase the beam
//					beamsRightDel[i].dbErase();
//				}
//				else if ((bm.ptCen() - newBeamRight.ptCen()).dotProduct(vecXWall) < dWallBeamHeight)
//				{ 
//					// not a full collision, delete it and recreate it displaced
////					if (ptsVertDel.find(beamsRightDel[i].ptCen()) < 0)
////					{ 
////						// new point, append it
////						ptsVertDel.append(beamsRightDel[i].ptCen());
////					}
////					 create new beam at new position
//					Point3d pt = beamsRightDel[i].ptCen();
//					pt += (newBeamRight.ptCen() + dWallBeamHeight * vecXWall - pt).dotProduct(vecXWall) * vecXWall;
//					// save in mapx
//					Map mapXexist = beamsRightDel[i].subMapX("mapX");
//					if ( ! mapXexist.hasPoint3d("ptInitial"))
//					{ 
//						Map mapX;
//						mapX.setPoint3d("ptInitial", beamsRightDel[i].ptCen());
//						// save the TSL handle
//						mapX.setString("handle", _ThisInst.handle());
//						beamsRightDel[i].setSubMapX("mapX", mapX);
//					}
//					
//					// displace the beam at new position 
//					Vector3d vecDisp = (pt - beamsRightDel[i].ptCen()).dotProduct(vecXWall) * vecXWall;
//					if (vecDisp.length() > dEps)
//					{ 
//						beamsRightDel[i].transformBy(vecDisp);
//					}
//					
//					
////					Beam beamsTopRight[] = Beam().filterBeamsHalfLineIntersectSort(beamsWallHor, pt, vecYWall);
////					Beam beamsBottomRight[]=Beam().filterBeamsHalfLineIntersectSort(beamsWallHor, pt, -vecYWall);
////					if (beamsTopRight.length() > 0 && beamsBottomRight.length() > 0)
////					{ 
////						Beam beamBottomRight = beamsBottomRight[beamsBottomRight.length() - 1];
////						Beam beamTopRight = beamsTopRight[beamsTopRight.length() - 1];
////						
////						int iColor = beamTopRight.color();
////						String sMaterial = beamTopRight.name("material");
////						
////						Beam bmNew;
////						bmNew.dbCreate(pt, vecYWall, vecXWall, - vecZWall, U(10), dWallBeamHeight, dWallBeamWidth ,- 1, 0, 0 );
////						bmNew.assignToElementGroup(w, true, 0, 'Z');
////						bmNew.stretchDynamicTo(beamBottomRight);
////						bmNew.stretchDynamicTo(beamTopRight);
////						
////						bmNew.setColor(iColor);
////						bmNew.setMaterial(sMaterial);
////						beamsForDelStore.append(bmNew);
////					}
////					// beam will be sowieso deleted because there is collusion
////					// erase the beam
////					beamsRightDel[i].dbErase();
//				}
//			}//next i
//			
//			_Map.setPoint3dArray("ptsVertDel", ptsVertDel);
//
//			reportMessage(("|ptsVertDel collected:|")+ptsVertDel.length());
//			
			// create milling
			if ((beamTopLeft.bIsValid() && abs(abs(beamTopLeft.vecX().dotProduct(vecXWall)) - 1) > 0)
				|| (beamTopRight.bIsValid() && abs(abs(beamTopRight.vecX().dotProduct(vecXWall)) - 1) > 0))
			{ 
				// beam not aligned with vecXWall, create milling
				Entity entsTslMillingNew[0];
				
			// delete previously created TSL
				{ 
					Entity entsTslMilling[] = _Map.getEntityArray("entsTslMilling", "", "");
					if(entsTslMilling.length()>0)
					{ 
						for (int i=entsTslMilling.length()-1; i>=0 ; i--) 
						{ 
							TslInst tsli = (TslInst)entsTslMilling[i];
							if(tsli.bIsValid())
							{
								tsli.dbErase();
							}
						}//next i
					}
					// delete from map
					_Map.removeAt("entsTslMilling", true);
				}
			// create TSL
				TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
				int nProps[]={};			double dProps[]={};				String sProps[]={};
				Map mapTsl;	
				
				// properties
				// depth
				dProps.setLength(0);
				dProps.append(U(0));
				// dSideGap
				dProps.append(U(0));
				// HSB-17747:
				// mill completely
//				sProps.append(T("|Yes|"));
//				// color, default green
//				nProps.append(3);
				
				if (newBeamLeft.bIsValid() && beamTopLeft.bIsValid())
				{ 
					// male beam
					gbsTsl.append(newBeamLeft);
					// female beam
					gbsTsl.append(beamTopLeft);
					
					tslNew.dbCreate(sTeinfraesung , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
					if(sEntriesTeinfraesung.find(sMillingStudPlate)>-1)
					{ 
						tslNew.setPropValuesFromCatalog(sMillingStudPlate);
					}
					// save in map
					entsTslMillingNew.append(tslNew);
				}
				
				if (newBeamRight.bIsValid() && beamTopRight.bIsValid())
				{ 
					gbsTsl.setLength(0);
					// male beam
					gbsTsl.append(newBeamRight);
					// female beam
					gbsTsl.append(beamTopRight);
					
					tslNew.dbCreate(sTeinfraesung , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
					if(sEntriesTeinfraesung.find(sMillingStudPlate)>-1)
					{ 
						tslNew.setPropValuesFromCatalog(sMillingStudPlate);
					}
					// save in map
					entsTslMillingNew.append(tslNew);
				}
				
				if (entsTslMillingNew.length() > 0)
				{ 
					// some angle brackets are created, save in map
					_Map.setEntityArray(entsTslMillingNew, true, "entsTslMilling", "", "");
				}
			}
			
			// create beamcut
			if (abs((ptMiddle - .5 * dLengthBeamHorizontal * vecXWall - pt).dotProduct(vecXWall)) > 1 * dEps)
			{ 
				Entity entsTslBeamCutNew[0];
				// delete previously created TSL
				{ 
					Entity entsTslBeamCut[] = _Map.getEntityArray("entsTslBeamCut", "", "");
					if(entsTslBeamCut.length()>0)
					{ 
						for (int i=entsTslBeamCut.length()-1; i>=0 ; i--) 
						{ 
							TslInst tsli = (TslInst)entsTslBeamCut[i];
							if(tsli.bIsValid())
							{
								tsli.dbErase();
							}
						}//next i
					}
					// delete from map
					_Map.removeAt("entsTslBeamCut", true);
				}
				
				double dWidthCut = abs((ptMiddle - .5 * dLengthBeamHorizontal * vecXWall - pt).dotProduct(vecXWall));
				// get extents of profile
				LineSeg seg = ppMiddle.extentInDir(vecXWall);
				
			// create TSL
				TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
				int nProps[]={};			double dProps[]={};				String sProps[]={};
				Map mapTsl;	
				
				// length
				dProps.append(0);
				// width, 0-> all through
				dProps.append(0);
				// depth 
				dProps.append(dWidthCut);
				// offset
				dProps.append(0);
				
				// reference side
				{ 
					String sReferenceSides[] = { T("|ECS| Y"), T("|ECS| Z"), T("|ECS| -Y"), T("|ECS| -Z")};
					// find the most aligned direction with vecXWall
					sProps.append(sReferenceSides[0]);
					if (abs(newBeamLeft.vecY().dotProduct(vecXWall) + 1) < dEps)
					{ 
						// T("|ECS| -Y")
						sProps[0] = sReferenceSides[2];
					}
					else if (abs(newBeamLeft.vecZ().dotProduct(vecXWall) - 1) < dEps)
					{ 
						// T("|ECS| +Z")
						sProps[0] = sReferenceSides[1];
					}
					else if (abs(newBeamLeft.vecZ().dotProduct(vecXWall) + 1) < dEps)
					{ 
						// T("|ECS| -Z")
						sProps[0] = sReferenceSides[3];
					}
				}
				
				// length
				{ 
					Point3d ptBottomCut = seg.ptStart();
					if (seg.ptEnd().dotProduct(vecYWall) < ptBottomCut.dotProduct(vecYWall))
					{ 
						ptBottomCut = seg.ptEnd();
					}
					
					Point3d ptTopCut = newBeamLeft.ptCen() + .5 * newBeamLeft.solidLength() * vecYWall;
					Point3d ptCenCut = .5 * (ptBottomCut + ptTopCut);
					// length
					dProps[0] = abs((ptTopCut - ptBottomCut).dotProduct(vecYWall));
					ptsTsl[0] = ptCenCut;
					
				}
				
				// add to the beam
//			entsTsl.append(newBeamLeft);
				gbsTsl.append(newBeamLeft);			
							
				tslNew.dbCreate("hsbBeamcut" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
				// save in map
				entsTslBeamCutNew.append(tslNew);
				
				// right---
				// length
				{ 
					Point3d ptBottomCut = seg.ptStart();
					if (seg.ptEnd().dotProduct(vecYWall) < ptBottomCut.dotProduct(vecYWall))
					{ 
						ptBottomCut = seg.ptEnd();
					}
					
					Point3d ptTopCut = newBeamRight.ptCen() + .5 * newBeamRight.solidLength() * vecYWall;
					Point3d ptCenCut = .5 * (ptBottomCut + ptTopCut);
					// length
					dProps[0] = abs((ptTopCut - ptBottomCut).dotProduct(vecYWall));
					ptsTsl[0] = ptCenCut;
					
				}
				gbsTsl[0] = newBeamRight;
				// reference side
				{ 
					String sReferenceSides[] = { T("|ECS| Y"), T("|ECS| Z"), T("|ECS| -Y"), T("|ECS| -Z")};
					// find the most aligned direction with vecXWall
					sProps[0] = (sReferenceSides[0]);
					if (abs(newBeamRight.vecY().dotProduct(vecXWall) - 1) < dEps)
					{ 
						// T("|ECS| -Y")
						sProps[0] = sReferenceSides[2];
					}
					else if(abs(newBeamRight.vecZ().dotProduct(vecXWall) + 1) < dEps)
					{ 
						// T("|ECS| +Z")
						sProps[0] = sReferenceSides[1];
					}
					else if(abs(newBeamRight.vecZ().dotProduct(vecXWall) - 1) < dEps)
					{ 
						// T("|ECS| -Z")
						sProps[0] = sReferenceSides[3];
					}
				}
				
				tslNew.dbCreate("hsbBeamcut" , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
				// save in map
				entsTslBeamCutNew.append(tslNew);
				
				if (entsTslBeamCutNew.length() > 0)
				{ 
					// some angle brackets are created, save in map
					_Map.setEntityArray(entsTslBeamCutNew, true, "entsTslBeamCut", "", "");
				}
			}// create beamcut
			
			_Map.setEntityArray(beamsForDelStore, true, "beamsForDel", "", "");
		}
		// delete beams that collide with the new beams
		{ 
			
			// remove from beamsLeftDel and beamsRightDel
			// the created beams in beamsForDel
			for (int i=beamsLeftDel.length()-1; i>=0 ; i--) 
			{ 
				if (beamsForDel.find(beamsLeftDel[i]) >- 1)
				{ 
					beamsLeftDel.removeAt(i);
				}
			}//next i
			
			for (int i=beamsRightDel.length()-1; i>=0 ; i--) 
			{ 
				if (beamsForDel.find(beamsRightDel[i]) >- 1)
				{ 
					beamsRightDel.removeAt(i);
				}
			}//next i
			
//			beamLeft;
//			beamRight;
			// test collusion with the left and the right beam
			
			
			// delete beams that collide on the left side
			for (int i = beamsLeftDel.length() - 1; i >= 0; i--)
			{ 
				// 0 - reserved for the main beam Pfette
				// 1,2 - reserved for the beams where cut will be applied
				// 3,4.. - reserved for 
				Beam bm = beamsLeftDel[i];
				
				if(abs(abs(bm.vecX().dotProduct(vecYWall)) - bm.vecX().length()*vecYWall.length())>dEps)
				{ 
					// beam not vertical will be excluded
					continue;
				}
				Point3d ptLeftExtreme = beamLeft.ptCen();
				
				if ((bm.ptCen() - beamLeft.ptCen()).dotProduct(vecXWall) > dEps)
				{ 
					// beam fully colluded, erase it 
					// save the center position for regeneration
					if (ptsVertDel.find(beamsLeftDel[i].ptCen()) < 0)
					{ 
						// new point, append it
						ptsVertDel.append(beamsLeftDel[i].ptCen());
					}
					// erase the beam
					beamsLeftDel[i].dbErase();
				}
				else if ((bm.ptCen() - beamLeft.ptCen()).dotProduct(vecXWall) > -dWallBeamHeight)
				{ 
					// not a full collision, delete it and recreate it displaced
//					if (ptsVertDel.find(beamsLeftDel[i].ptCen()) < 0)
//					{ 
						// new point, append it
//						ptsVertDel.append(beamsLeftDel[i].ptCen());
//					}
					
					// create new beam at new position
					Point3d pt = beamsLeftDel[i].ptCen();
					pt += (beamLeft.ptCen() - dWallBeamHeight * vecXWall - pt).dotProduct(vecXWall) * vecXWall;
					// save in mapx
					Map mapXexist = beamsLeftDel[i].subMapX("mapX");
					if ( ! mapXexist.hasPoint3d("ptInitial"))
					{ 
						Map mapX;
						mapX.setPoint3d("ptInitial", beamsLeftDel[i].ptCen());
						// save the TSL handle
						mapX.setString("handle", _ThisInst.handle());
						beamsLeftDel[i].setSubMapX("mapX", mapX);
					}
					
					// displace the beam at new position 
					Vector3d vecDisp = (pt - beamsLeftDel[i].ptCen()).dotProduct(vecXWall) * vecXWall;
					if (vecDisp.length() > dEps)
					{ 
						beamsLeftDel[i].transformBy(vecDisp);
					}
				}
			}//next i
			
			// delete beams that collide on the right side
			for (int i = beamsRightDel.length() - 1; i >= 0; i--)
			{ 
				// 0 - reserved for the main beam Pfette
				// 1,2 - reserved for the beams where cut will be applied
				// 3,4.. - reserved for 
				Beam bm = beamsRightDel[i];
				
				if(abs(abs(bm.vecX().dotProduct(vecYWall)) - bm.vecX().length()*vecYWall.length())>dEps)
				{ 
					// beam not vertical will be excluded
					continue;
				}
				Point3d ptRightExtreme = beamRight.ptCen();
				
				if ((bm.ptCen() - beamRight.ptCen()).dotProduct(vecXWall) < -dEps)
				{ 
					// beam fully colluded, erase it 
					// save the center position for regeneration
					if (ptsVertDel.find(beamsRightDel[i].ptCen()) < 0)
					{ 
						// new point, append it
						ptsVertDel.append(beamsRightDel[i].ptCen());
					}
					// erase the beam
					beamsRightDel[i].dbErase();
				}
				else if ((bm.ptCen() - beamRight.ptCen()).dotProduct(vecXWall) < dWallBeamHeight)
				{ 
					// not a full collision, delete it and recreate it displaced
//					if (ptsVertDel.find(beamsRightDel[i].ptCen()) < 0)
//					{ 
//						// new point, append it
//						ptsVertDel.append(beamsRightDel[i].ptCen());
//					}
//					 create new beam at new position
					Point3d pt = beamsRightDel[i].ptCen();
					pt += (beamRight.ptCen() + dWallBeamHeight * vecXWall - pt).dotProduct(vecXWall) * vecXWall;
					// save in mapx
					Map mapXexist = beamsRightDel[i].subMapX("mapX");
					if ( ! mapXexist.hasPoint3d("ptInitial"))
					{ 
						Map mapX;
						mapX.setPoint3d("ptInitial", beamsRightDel[i].ptCen());
						// save the TSL handle
						mapX.setString("handle", _ThisInst.handle());
						beamsRightDel[i].setSubMapX("mapX", mapX);
					}
					
					// displace the beam at new position 
					Vector3d vecDisp = (pt - beamsRightDel[i].ptCen()).dotProduct(vecXWall) * vecXWall;
					if (vecDisp.length() > dEps)
					{ 
						beamsRightDel[i].transformBy(vecDisp);
					}
				}
			}//next i
			
			_Map.setPoint3dArray("ptsVertDel", ptsVertDel);
//			reportMessage(("|ptsVertDel collected:|")+ptsVertDel.length());
		}
		
	}
	else if (iType == 2)
	{
		// delete existing vertical beams in SF wall
		pCen.vis(4);
		Beam beamsLeftDel[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, pCen, - vecXWall);
		Beam beamsRightDel[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, pCen, vecXWall);
		
		for (int i = beamsLeftDel.length() - 1; i >= 0; i--)
		{ 
			// 0 - reserved for the main beam Pfette
			// 1,2 - reserved for the beams where cut will be applied
			// 3,4.. - reserved for 
			Beam bm = beamsLeftDel[i];
			if(abs(abs(bm.vecX().dotProduct(vecYWall)) - bm.vecX().length()*vecYWall.length())>dEps)
			{ 
				// beam not vertical will be excluded
				continue;
			}
			Body bodyBeam = bm.envelopeBody(true, true);
			// shadow of the body in xy of wall
			PlaneProfile pPBeam = bodyBeam.shadowProfile(planeWall);
			LineSeg lSegBeam = pPBeam.extentInDir(vecXWall);
			Point3d ptTopRight = lSegBeam.ptEnd();
			if((ptTopRight-pLeftExtreme).dotProduct(vecXWall)>0)
			{ 
				// ptTopRight on the right of pLeftExtreme, beam must be deleted
				beamsLeftDel[i].dbErase();
			}
		}//next i
	
		for (int i = beamsRightDel.length() - 1; i >= 0; i--)
		{ 
			Beam bm = beamsRightDel[i];
			if(abs(abs(bm.vecX().dotProduct(vecYWall)) - bm.vecX().length()*vecYWall.length())>dEps)
			{ 
				// beam not vertical will be excluded
				continue;
			}
			Body bodyBeam = bm.envelopeBody(true, true);
			// shadow of the body in xy of wall
			PlaneProfile pPBeam = bodyBeam.shadowProfile(planeWall);
			LineSeg lSegBeam = pPBeam.extentInDir(vecXWall);
			Point3d ptBottomLeft = lSegBeam.ptStart();
			if((ptBottomLeft-pRightExtreme).dotProduct(vecXWall)<0)
			{ 
				// ptBottomLeft on the left of pRightExtreme, beam must be deleted
				beamsRightDel[i].dbErase();
			}
		}//next i
		// end - delete existing vertical beams in SF wall
		
		// point at the center of the horizontal beam
		// upper edge of the middle horizontal beam
		Point3d ptMiddleUp = pBottomLeft + (.5 * ppWidthX ) * vecXWall - .5 * dWallBeamWidth * vecZWall;
		// center of the middle horizontal beam
		Point3d ptMiddleCenter = ptMiddleUp - .5 * dWallBeamHeight * vecYWall;
		// bottom edge of the middle horizontal beam
		Point3d ptMiddleDown = ptMiddleCenter - .5 * dWallBeamHeight * vecYWall;
		
		// find beams at the left and right side
		// Left side bounding beams
		Beam beamsLeftUp[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, ptMiddleUp, -vecXWall);
		Beam beamLeftUp;
		if(beamsLeftUp.length()>0)
		{ 
			beamLeftUp = beamsLeftUp[0];
		}
		Beam beamsLeftDown[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, ptMiddleDown, - vecXWall);
		Beam beamLeftDown;
		if(beamsLeftDown.length()>0)
		{ 
			beamLeftDown = beamsLeftDown[0];
		}
		//
		if(beamsLeftUp.length()<1 && beamsLeftDown.length()<1)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|No bounding beam on the left side for the horizontal beam|"));
			return;
		}
		// Right side bounding beams
		Beam beamsRightUp[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, ptMiddleUp, vecXWall);
		Beam beamRightUp;
		if(beamsRightUp.length()>0)
		{
			beamRightUp = beamsRightUp[0];
		}
		Beam beamsRightDown[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, ptMiddleDown, vecXWall);
		Beam beamRightDown;
		if(beamsRightDown.length()>0)
		{
			beamRightDown = beamsRightDown[0];
		}
		
		if(beamsRightUp.length()<1 && beamsRightDown.length()<1)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|No bounding beam on the right side for the horizontal beam|"));
			return;
		}
		// the horizontal middle beam
		String sMaterial = beamsLeftUp[0].name("material");
		int iColor = beamsLeftUp[0].color();
		Beam newBeamMiddle;
		newBeamMiddle.dbCreate(ptMiddleCenter, vecXWall, vecYWall, vecZWall, 1.0/100, dWallBeamHeight, dWallBeamWidth );
		newBeamMiddle.assignToElementGroup(w, true, 0, 'Z');
		if(beamLeftUp==beamLeftDown)
		{
			newBeamMiddle.stretchDynamicTo(beamLeftUp);
		}
		else
		{
			// multiple strech
			newBeamMiddle.stretchDynamicToMultiple(beamLeftUp, beamLeftDown);
		}
		if(beamRightUp==beamRightDown)
		{
			newBeamMiddle.stretchDynamicTo(beamRightUp);
		}
		else
		{
			// multiple strech
			newBeamMiddle.stretchDynamicToMultiple(beamRightUp, beamRightDown);
		}
		newBeamMiddle.setColor(iColor);
		newBeamMiddle.setMaterial(sMaterial);
		// HSB-24281
		newBeamMiddle.setName(sName);
		newBeamMiddle.setGrade(sGrade);
		//
	//	_Beam.append(newBeamMiddle);
		beamsForDelStore.append(newBeamMiddle);
		
		// points for the 2 vertical beams between the horizontal beem underneath
		// and the top Beam Pfette


		// point in the middle of the section of the left vertical beam
		Point3d ptL1 = ptMiddleUp + dEps * vecYWall - (.5 * ppWidthX + dGap + .5 * dWallBeamHeight  ) * vecXWall;
		ptL1.vis(2);
		// point in the middle of the section of the right vertical beam
		Point3d ptR1 = ptMiddleUp + (dEps+U(1)) * vecYWall + (.5 * ppWidthX + dGap + .5 * dWallBeamHeight ) * vecXWall;
		ptR1.vis(2);
		
	// generate left vertical beam
		Beam newBeamLeft;
		newBeamLeft.dbCreate(ptL1, vecYWall, - vecXWall, vecZWall, U(1), dWallBeamHeight, dWallBeamWidth);
		// get top bounding beam
		Beam beamsTop[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, ptL1, vecYWall);
		if(beamsTop.length()<1)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|No bounding beam at the top for the vertical beam on the left|"));
			return;
		}
		Beam beamTop = beamsTop[0];// get only the first beam that is cought
		newBeamLeft.assignToElementGroup(w, true, 0, 'Z');
		newBeamLeft.stretchDynamicTo(newBeamMiddle);
		newBeamLeft.stretchDynamicTo(beamTop);
		newBeamLeft.setColor(iColor);
		newBeamLeft.setMaterial(sMaterial);
		// HSB-24281
		newBeamLeft.setName(sName);
		newBeamLeft.setGrade(sGrade);
	//	_Beam.append(newBeamLeft);
		beamsForDelStore.append(newBeamLeft);
		
	// generate right vertical beam
		Beam newBeamRight;
		newBeamRight.dbCreate(ptR1, vecYWall, - vecXWall ,vecZWall, U(1), dWallBeamHeight, dWallBeamWidth);
		// get top bounding beam
		beamsTop = Beam().filterBeamsHalfLineIntersectSort(beamsWall, ptR1, vecYWall);
		if(beamsTop.length()<1)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|No bounding beam at the top for the vertical beam on the right|"));
			return;
		}
		beamTop = beamsTop[0];
		
		newBeamRight.assignToElementGroup(w, true, 0, 'Z');
		newBeamRight.stretchDynamicTo(newBeamMiddle);
		newBeamRight.stretchDynamicTo(beamTop);
		newBeamRight.setColor(iColor);
		newBeamRight.setMaterial(sMaterial);
		// HSB-24281
		newBeamRight.setName(sName);
		newBeamRight.setGrade(sGrade);
		beamsForDelStore.append(newBeamRight);
		
		// create t-Einfräsung milling between the vertical and the top beam
		if (abs(abs(beamTop.vecX().dotProduct(vecXWall)) - 1) > 0)
		{ 
			// beam not aligned with vecXWall, create milling
			Entity entsTslMillingNew[0];
			
		// delete previously created TSL
			{ 
				Entity entsTslMilling[] = _Map.getEntityArray("entsTslMilling", "", "");
				if(entsTslMilling.length()>0)
				{ 
					for (int i=entsTslMilling.length()-1; i>=0 ; i--) 
					{ 
						TslInst tsli = (TslInst)entsTslMilling[i];
						if(tsli.bIsValid())
						{
							tsli.dbErase();
						}
					}//next i
				}
				// delete from map
				_Map.removeAt("entsTslMilling", true);
			}
		// create TSL
			TslInst tslNew;	Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[]={}; Entity entsTsl[]={}; Point3d ptsTsl[] = {_Pt0};
			int nProps[]={}; double dProps[]={}; String sProps[]={};
			Map mapTsl;	
			
			// properties
			// depth
			dProps.setLength(0);
			dProps.append(U(0));
			// dSideGap
			dProps.append(U(0));
			// HSB-17747:
			// mill completely
//			sProps.append(T("|Yes|"));
//			// color, default green
//			nProps.append(3);
			// male beam
			gbsTsl.append(newBeamLeft);
			// female beam
			gbsTsl.append(beamTop);
			
			tslNew.dbCreate(sTeinfraesung , vecXTsl , vecYTsl, gbsTsl, entsTsl, 
				ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			if(sEntriesTeinfraesung.find(sMillingStudPlate)>-1)
			{ 
				tslNew.setPropValuesFromCatalog(sMillingStudPlate);
			}
			// save in map
			entsTslMillingNew.append(tslNew);
			
			gbsTsl.setLength(0);
			// male beam
			gbsTsl.append(newBeamRight);
			// female beam
			gbsTsl.append(beamTop);
			
			tslNew.dbCreate(sTeinfraesung, vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			if(nMillingStudPlate>0)
				tslNew.setPropValuesFromCatalog(sMillingStudPlate);
			// save in map
			entsTslMillingNew.append(tslNew);
			
			if (entsTslMillingNew.length() > 0)
			{ 
				// some angle brackets are created, save in map
				_Map.setEntityArray(entsTslMillingNew, true, "entsTslMilling", "", "");
			}
		}
		
	// generate bottom vertical beam
		Point3d ptVerticalBottom;
		ptVerticalBottom = ptMiddleDown - (dEps+U(1)) * vecYWall;
		ptVerticalBottom.vis(7);
		Beam newBeamVerticalBottom;
		newBeamVerticalBottom.dbCreate(ptVerticalBottom, vecYWall, - vecXWall ,vecZWall, U(1), dWallBeamHeight, dWallBeamWidth);
		
		ptVerticalBottom.vis(5);
		// bottom bounding beam
		Beam beamsBottom[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, ptVerticalBottom, - vecYWall);
		Beam beamBottom = beamsBottom[0]; // bottom horizontal bounding beam
		
		// strech the beam
		newBeamVerticalBottom.assignToElementGroup(w, true, 0, 'Z');
		newBeamVerticalBottom.stretchDynamicTo(beamBottom);
		newBeamVerticalBottom.stretchDynamicTo(newBeamMiddle);
		newBeamVerticalBottom.setColor(iColor);
		newBeamVerticalBottom.setMaterial(sMaterial);
		// HSB-24281
		newBeamVerticalBottom.setName(sName);
		newBeamVerticalBottom.setGrade(sGrade);
		beamsForDelStore.append(newBeamVerticalBottom);
		
		_Map.setEntityArray(beamsForDelStore, true, "beamsForDel", "", "");
	}
	else if (iType == 3)
	{ 
		// type 4  from Reinhard Hain
		// it will be the same as type 3 but the middle beam wil not be generated
		// if an existing vertical beam is within the range of this type, then the beam will be cut 
		// and streched to the existing horizontal beam
		
		// delete existing vertical beams in SF wall
		pCen.vis(4);
		ptCen -= vecYWall * 1.5*dBeamHeight;
		// notice the existing beams on left and right
		Beam beamsLeft[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, pCen, - vecXWall);
		Beam beamsRight[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, pCen, vecXWall);
		// existing beams that must not be deleted but be streched to the horizontal beam
		Beam beamsLeftExisting[0];
		Beam beamsRightExisting[0];
		
		for (int i = beamsLeft.length() - 1; i >= 0; i--)
		{ 
			// 0 - reserved for the main beam Pfette
			// 1,2 - reserved for the beams where cut will be applied
			// 3,4.. - reserved for 
			Beam bm = beamsLeft[i];
			if(abs(abs(bm.vecX().dotProduct(vecYWall)) - bm.vecX().length()*vecYWall.length())>dEps)
			{ 
				// beam not vertical will be excluded
				continue;
			}
			Body bodyBeam = bm.envelopeBody(true, true);
			// shadow of the body in xy of wall
			PlaneProfile pPBeam = bodyBeam.shadowProfile(planeWall);
			LineSeg lSegBeam = pPBeam.extentInDir(vecXWall);
			Point3d ptTopRight = lSegBeam.ptEnd();
			
			if((ptTopRight-pLeftExtreme).dotProduct(vecXWall)>0)
			{ 
				// ptTopRight on the right of pLeftExtreme, beam must be deleted
				beamsLeftExisting.append(beamsLeft[i]);
			}
		}//next i
		
		for (int i = beamsRight.length() - 1; i >= 0; i--)
		{ 
			Beam bm = beamsRight[i];
			if (abs(abs(bm.vecX().dotProduct(vecYWall)) - bm.vecX().length() * vecYWall.length()) > dEps)
			{ 
				// beam not vertical will be excluded
				continue;
			}
			Body bodyBeam = bm.envelopeBody(true, true);
			// shadow of the body in xy of wall
			PlaneProfile pPBeam = bodyBeam.shadowProfile(planeWall);
			LineSeg lSegBeam = pPBeam.extentInDir(vecXWall);
			Point3d ptBottomLeft = lSegBeam.ptStart();
			if ((ptBottomLeft - pRightExtreme).dotProduct(vecXWall) < 0)
			{ 
				// ptBottomLeft on the left of pRightExtreme, beam must be deleted
				beamsRightExisting.append(beamsRight[i]);
			}
		}//next i
		
		// point at the center of the horizontal beam
		// upper edge of the middle horizontal beam
		Point3d ptMiddleUp = pBottomLeft + (.5 * ppWidthX ) * vecXWall - .5 * dWallBeamWidth * vecZWall;
		// center of the middle horizontal beam
		Point3d ptMiddleCenter = ptMiddleUp - .5 * dWallBeamHeight * vecYWall;
		// bottom edge of the middle horizontal beam
		Point3d ptMiddleDown = ptMiddleCenter - .5 * dWallBeamHeight * vecYWall;
		
		// find beams at the left and right side
		// Left side bounding beams
		Beam beamsLeftUp[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, ptMiddleUp, -vecXWall);
		Beam beamLeftUp;
		if (beamsLeftUp.length() > 0)
		{ 
			// get the first beam that is not in the beamsLeftExisting
			for (int ii = 0; ii < beamsLeftUp.length(); ii++)
			{ 
				if (beamsLeftExisting.find(beamsLeftUp[ii]) < 0)
				{ 
					// not contained at the beamsLeftExisting
					beamLeftUp = beamsLeftUp[ii];
					break;
				}
				 
			}//next ii
		}
		Beam beamsLeftDown[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, ptMiddleDown, - vecXWall);
		Beam beamLeftDown;
		if (beamsLeftDown.length() > 0)
		{ 
			// get the first beam that is not in the beamsLeftExisting
			for (int ii = 0; ii < beamsLeftDown.length(); ii++)
			{ 
				if (beamsLeftExisting.find(beamsLeftDown[ii]) < 0)
				{ 
					// not contained at the beamsLeftExisting
					beamLeftDown = beamsLeftDown[ii];
					break;
				}
				 
			}//next ii
		}
		
		if (beamsLeftUp.length() < 1 && beamsLeftDown.length() < 1)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|No bounding beam on the left side for the horizontal beam|"));
			return;
		}
		// Right side bounding beams
		Beam beamsRightUp[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, ptMiddleUp, vecXWall);
		Beam beamRightUp;
		if(beamsRightUp.length()>0)
		{
			// get the first beam that is not in the beamsLeftExisting
			for (int ii = 0; ii < beamsRightUp.length(); ii++)
			{ 
				if (beamsRightExisting.find(beamsRightUp[ii]) < 0
					  && beamsLeftExisting.find(beamsRightUp[ii]) < 0)
				{ 
					// not contained at the beamsLeftExisting and not contained at the beamsLeftExisting
					beamRightUp = beamsRightUp[ii];
					break;
				}
				 
			}//next ii
		}
		Beam beamsRightDown[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, ptMiddleDown, vecXWall);
		Beam beamRightDown;
		if(beamsRightDown.length()>0)
		{
			// get the first beam that is not in the beamsLeftExisting
			for (int ii = 0; ii < beamsRightDown.length(); ii++)
			{ 
				if (beamsRightExisting.find(beamsRightDown[ii]) < 0 
					 && beamsLeftExisting.find(beamsRightDown[ii]) < 0)
				{ 
					// not contained at the beamsRightExisting and not contained at the beamsLeftExisting
					beamRightDown = beamsRightDown[ii];
					break;
				}
				 
			}//next ii
		}
		if (beamsRightUp.length() < 1 && beamsRightDown.length() < 1)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|No bounding beam on the right side for the horizontal beam|"));
			return;
		}
		//
		// the horizontal middle beam
		String sMaterial = beamsLeftUp[0].name("material");
		int iColor = beamsLeftUp[0].color();
		Beam newBeamMiddle;
		newBeamMiddle.dbCreate(ptMiddleCenter, vecXWall, vecYWall, vecZWall, 1.0/100, dWallBeamHeight, dWallBeamWidth );
		newBeamMiddle.assignToElementGroup(w, true, 0, 'Z');
		if(beamLeftUp==beamLeftDown)
		{
			newBeamMiddle.stretchDynamicTo(beamLeftUp);
		}
		else
		{
			// multiple strech
			newBeamMiddle.stretchDynamicToMultiple(beamLeftUp, beamLeftDown);
		}
		if(beamRightUp==beamRightDown)
		{
			newBeamMiddle.stretchDynamicTo(beamRightUp);
		}
		else
		{
			// multiple strech
			newBeamMiddle.stretchDynamicToMultiple(beamRightUp, beamRightDown);
		}
		newBeamMiddle.setColor(iColor);
		newBeamMiddle.setMaterial(sMaterial);
		// HSB-24281
		newBeamMiddle.setName(sName);
		newBeamMiddle.setGrade(sGrade);
		beamsForDelStore.append(newBeamMiddle);
		
		// point in the middle of the section of the left vertical beam
		Point3d ptL1 = ptMiddleUp + dEps * vecYWall - (.5 * ppWidthX + dGap + .5 * dWallBeamHeight  ) * vecXWall;
		ptL1.vis(2);
		// point in the middle of the section of the right vertical beam
		Point3d ptR1 = ptMiddleUp + (dEps+U(1)) * vecYWall + (.5 * ppWidthX + dGap + .5 * dWallBeamHeight ) * vecXWall;
		ptR1.vis(2);
		
	// generate left vertical beam
		Beam newBeamLeft;
		newBeamLeft.dbCreate(ptL1, vecYWall, - vecXWall , vecZWall, U(1), dWallBeamHeight, dWallBeamWidth);
		// get top bounding beam
		Beam beamsTop[] = Beam().filterBeamsHalfLineIntersectSort(beamsWall, ptL1, vecYWall);
		if(beamsTop.length()<1)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|No bounding beam at the top for the vertical beam on the left|"));
			return;
		}
		Beam beamTop = beamsTop[0];// get only the first beam that is cought
		newBeamLeft.assignToElementGroup(w, true, 0, 'Z');
		newBeamLeft.stretchDynamicTo(newBeamMiddle);
		newBeamLeft.stretchDynamicTo(beamTop);
		newBeamLeft.setColor(iColor);
		newBeamLeft.setMaterial(sMaterial);
		// HSB-24281
		newBeamLeft.setName(sName);
		newBeamLeft.setGrade(sGrade);
	//	_Beam.append(newBeamLeft);
		beamsForDelStore.append(newBeamLeft);
		
	// generate right vertical beam
		Beam newBeamRight;
		newBeamRight.dbCreate(ptR1, vecYWall, - vecXWall ,vecZWall, U(1), dWallBeamHeight, dWallBeamWidth);
		// get top bounding beam
		beamsTop = Beam().filterBeamsHalfLineIntersectSort(beamsWall, ptR1, vecYWall);
		if(beamsTop.length()<1)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|No bounding beam at the top for the vertical beam on the right|"));
			return;
		}
		beamTop = beamsTop[0];
		
		newBeamRight.assignToElementGroup(w, true, 0, 'Z');
		newBeamRight.stretchDynamicTo(newBeamMiddle);
		newBeamRight.stretchDynamicTo(beamTop);
		newBeamRight.setColor(iColor);
		newBeamRight.setMaterial(sMaterial);
		// HSB-24281
		newBeamRight.setName(sName);
		newBeamRight.setGrade(sGrade);
		beamsForDelStore.append(newBeamRight);
		
		// create t-Einfräsung milling between the vertical and the top beam
		if (abs(abs(beamTop.vecX().dotProduct(vecXWall)) - 1) > 0)
		{ 
			// beam not aligned with vecXWall, create milling
			Entity entsTslMillingNew[0];
			
		// delete previously created TSL
			{ 
				Entity entsTslMilling[] = _Map.getEntityArray("entsTslMilling", "", "");
				if(entsTslMilling.length()>0)
				{ 
					for (int i=entsTslMilling.length()-1; i>=0 ; i--) 
					{ 
						TslInst tsli = (TslInst)entsTslMilling[i];
						if(tsli.bIsValid())
						{
							tsli.dbErase();
						}
					}//next i
				}
				// delete from map
				_Map.removeAt("entsTslMilling", true);
			}
		// create TSL
			TslInst tslNew;	Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
			GenBeam gbsTsl[]={}; Entity entsTsl[]={}; Point3d ptsTsl[]={_Pt0};
			int nProps[]={}; double dProps[]={}; String sProps[]={};
			Map mapTsl;	
			
			// properties
			// depth
			dProps.setLength(0);
			dProps.append(U(0));
			// dSideGap
			dProps.append(U(0));
			// HSB-17747
			// mill completely
//			sProps.append(T("|Yes|"));
//			// color, default green
//			nProps.append(3);
			// male beam
			gbsTsl.append(newBeamLeft);
			// female beam
			gbsTsl.append(beamTop);
			
			tslNew.dbCreate(sTeinfraesung, vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			if(nMillingStudPlate>0)
				tslNew.setPropValuesFromCatalog(sMillingStudPlate);
			// save in map
			entsTslMillingNew.append(tslNew);
			
			gbsTsl.setLength(0);
			// male beam
			gbsTsl.append(newBeamRight);
			// female beam
			gbsTsl.append(beamTop);
			
			tslNew.dbCreate(sTeinfraesung , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			if(sEntriesTeinfraesung.find(sMillingStudPlate)>-1)
				tslNew.setPropValuesFromCatalog(sMillingStudPlate);
			// save in map
			entsTslMillingNew.append(tslNew);
			
			if (entsTslMillingNew.length() > 0)
			{ 
				// some angle brackets are created, save in map
				_Map.setEntityArray(entsTslMillingNew, true, "entsTslMilling", "", "");
			}
		}
		
		// get existing analysed cuts to remember them when reset or 
		// when they are recreated again
		// we will set te beams at existing cuts
		Beam bmExisting;
		if (beamsLeftExisting.length() > 0)
		{ 
			bmExisting = beamsLeftExisting[0];
		}
		if (beamsRightExisting.length() > 0)
		{ 
			bmExisting = beamsRightExisting[0];
		}
		if ( ! _Map.hasPoint3d("ptTyp4Cut"))
		{ 
			// point does not exist, get the cut and save it
			if (bmExisting.bIsValid())
			{ 
				AnalysedTool ats[] = bmExisting.analysedTools();
				AnalysedCut acs[0];
				
				for (int i = 0; i < ats.length(); i++)
				{ 
					AnalysedTool ati = ats[i];
					AnalysedCut ct = (AnalysedCut)ati;
					if (ct.bIsValid())
					{ 
						acs.append(ct);
					}
				}//next i
				
				Point3d ptCut = acs[0].ptOrg();
				Vector3d vNormalCut = acs[0].normal();
				// 
				for (int i = 0; i < acs.length(); i++)
				{ 
					AnalysedCut aci = acs[i];
					if ((aci.ptOrg() - ptCut).dotProduct(vecYWall) > 0)
					{ 
						ptCut = aci.ptOrg();
						vNormalCut = aci.normal();
					}
				}//next i
				
				_Map.setPoint3d("ptTyp4Cut", ptCut);
				_Map.setVector3d("vNormalTyp4Cut", vNormalCut);
				// save bmExisting
				_Map.setEntity("bmExistingTyp4", bmExisting);
			}
		}
		
	// modify existing beam, apply cuts to the horizontal beam
		Cut ct;
		if (beamsLeftExisting.length() > 0 || beamsRightExisting.length() > 0)
		{ 
			// beams to be modified exist, 
			// cut them to the existing horizontal beam
			Point3d ptCut = newBeamMiddle.ptCen() - vecYWall * .5 * newBeamMiddle.dD(vecYWall);
			ct = Cut(ptCut, vecYWall);
		}
		
		for (int i = 0; i < beamsLeftExisting.length(); i++)
		{ 
			Beam bm = beamsLeftExisting[i];
			bm.addToolStatic(ct, _kStretchOnToolChange);
			 
		}//next i
		for (int i = 0; i < beamsRightExisting.length(); i++)
		{ 
			Beam bm = beamsRightExisting[i];
			bm.addToolStatic(ct, _kStretchOnToolChange);
			 
		}//next i
		
				
		_Map.setEntityArray(beamsForDelStore, true, "beamsForDel", "", "");
	}
	
//End generate connection//endregion 






#End
#BeginThumbnail
M0DW2S0@``````#8$```H````$@4``+L!```!``@``````)S)"```````````
M````````````````````@```@````("``(````"``(``@(```,#`P`#`W,``
M\,JF```@0```(&```""````@H```(,```"#@``!`````0"```$!```!`8```
M0(```$"@``!`P```0.```&````!@(```8$```&!@``!@@```8*```&#```!@
MX```@````(`@``"`0```@&```("```"`H```@,```(#@``"@````H"```*!`
M``"@8```H(```*"@``"@P```H.```,````#`(```P$```,!@``#`@```P*``
M`,#```#`X```X````.`@``#@0```X&```."```#@H```X,```.#@`$````!`
M`"``0`!``$``8`!``(``0`"@`$``P`!``.``0"```$`@(`!`($``0"!@`$`@
M@`!`(*``0"#``$`@X`!`0```0$`@`$!`0`!`0&``0$"``$!`H`!`0,``0$#@
M`$!@``!`8"``0&!``$!@8`!`8(``0&"@`$!@P`!`8.``0(```$"`(`!`@$``
M0(!@`$"`@`!`@*``0(#``$"`X`!`H```0*`@`$"@0`!`H&``0*"``$"@H`!`
MH,``0*#@`$#```!`P"``0,!``$#`8`!`P(``0,"@`$#`P`!`P.``0.```$#@
M(`!`X$``0.!@`$#@@`!`X*``0.#``$#@X`"`````@``@`(``0`"``&``@`"`
M`(``H`"``,``@`#@`(`@``"`("``@"!``(`@8`"`((``@""@`(`@P`"`(.``
M@$```(!`(`"`0$``@$!@`(!`@`"`0*``@$#``(!`X`"`8```@&`@`(!@0`"`
M8&``@&"``(!@H`"`8,``@&#@`("```"`@"``@(!``("`8`"`@(``@("@`("`
MP`"`@.``@*```("@(`"`H$``@*!@`("@@`"`H*``@*#``("@X`"`P```@,`@
M`(#`0`"`P&``@,"``(#`H`"`P,``@,#@`(#@``"`X"``@.!``(#@8`"`X(``
M@."@`(#@P`"`X.``P````,``(`#``$``P`!@`,``@`#``*``P`#``,``X`#`
M(```P"`@`,`@0`#`(&``P""``,`@H`#`(,``P"#@`,!```#`0"``P$!``,!`
M8`#`0(``P$"@`,!`P`#`0.``P&```,!@(`#`8$``P&!@`,!@@`#`8*``P&#`
M`,!@X`#`@```P(`@`,"`0`#`@&``P("``,"`H`#`@,``P(#@`,"@``#`H"``
MP*!``,"@8`#`H(``P*"@`,"@P`#`H.``P,```,#`(`#`P$``P,!@`,#`@`#`
MP*``\/O_`*2@H`"`@(````#_``#_````__\`_P```/\`_P#__P``____`/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________V]O__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________;_________________________________
M____________________________________________________________
M______________________________;_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________V]O______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M]O_________V]O;_____________________________________________
M____________________________________________________________
M________________________]O__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________V___V____
M]O;V]O;V]O;V]O;V]O;_______________________;V]O;V]O__________
M____]O_V]O;V]O_____________V"`<']0<'"/______________________
M______;V]O__________]O______________________]O;V]O;V________
M________________________________________________]O;V]O;V]O__
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________;V]O:O70P-
M#0P,#0Q,IO;V]O____________________^:2$A(2%%1_____________Z-(
M24E(24GV______\'K)I12$A(2$A(2%!(6JP(____]O____\(]?>DFUI124E(
M2$A(49KL]O______________________]@<'[0<'!P?W!_<'!PC_________
M]@@']^T'!P<'"/;_____".T']O___________P@']P<'!P<']_<'!P<(]O;_
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________]O;V]J]=7E8.#0T-#0T-
M#56O]O;V____________________FDA(2$A(4?____________^C2$A(2$A(
M]O____912$A(2$A(2$A(2$A04$A(29O_______])2$E(2$A(2$A(2$A02$A(
M2$B:!_________________\'!^T'!P<'!P<'!P?W!P<'_______V!P<'!P?M
M!P<'!^T'!_;_]O<'!_;_________".T'!P<'[>T'!P?W!_<'!P?W!_;_____
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________V__________;VKUX5%A86%@X.#0T-#0Y65K?V
M_____________________YI(2%!(2%'_____________HTA(2$A(2/;____V
M24A(2$A(2$A(4%!(4%!02$A14?;_____44A(4$A(2$A(2%!(2$A02$A(2$GW
M______________8'!P<'!P<'[0<'!_?M!^T'!______V!P<'!^T'!P?W[0<'
M!P<'!P<'!P?V________!P<'!^T'!P<'!^T'!P<'!P<'!P?_____________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________V___V]O:W7E46%A<7%Q<.#@X.#@X.#E96]O;_____
M______________^:2%!(2%!1_____________Z-(2%!02$CV____]DA12$A(
M4%!(2$A(4%!(4$A02$B:_____U%(4$A(4%!02$A(2%!(2$A(4$A(2??_____
M______\'[0?W!P?M!P<'"`@'!P<'!P?_____!P<'!P<'[0<'!P?M!P<'!^T'
M!_<']O______!P<'[>WM!P<(]O8("`<'!P<'!P?W____________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________;V]K=>5A86%Q86%Q<7#@X.#@T.#A865E[V]O__________
M________FDA(2%!(4?__]O________^C2%!02$A(]O____9(2$A(2$A(25%1
M45%(2$A(2$A02`C___]02%!(4$A(2$A)2$A(2$A(2$A(2$A)]?________\'
M!P<'!P<']O_____________V____!P?M!^T']O______]O8'!_<'!P<'!_;_
M____"`?M!P?W"/____________\(!P<'!___________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______V[UY5%A87%Q<7%A<7%PX.#@X.#0X.%Q969O;V________________
M_YI(2$A(2%'___;_________HTA(4$A(2/;___;V24E1H_<'________]5%(
M4$A(2$BD____45!(2$A(4)JCK/7U]:Q:24A(4%!(2%'_______\(!P<'[0?V
M_____________________P<'!P<']O____________\'[0<'!P?V_____P<'
M!P<']O______________]@?W!_?_________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________________V
MIE56%A86%Q<7%Q<7%Q<6#@X.#@T.#A<6%E:O]O;____V__________^:2$A(
M2$A1_____________Z-(2%!(2$CV____]J0(_______________V45!04$A(
MFO___U%02%!(2)K___________=(2$A(4$A([?______!P<'[>WV________
M______________\'!P<'!________________P@'!P<']O____8'!P<'!___
M______________8'!P<'________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________]E4-%A86
M%Q<7%Q<7%Q<7%PX.#@X.#@X7%Q865>_V]O______________FDA(2$A(4?__
M__________^C2$A(2$A(]O_______________________YI(4%!(2%+___]1
M2$A04$B:____________[$A02$A02)K_____".T'!P<'________________
M_______V[0<'!P?_______________\(!P<'!_;___\'!P<'!___________
M_______V!P<'!_______________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________8-#0T.5E<7%Q<7
M%Q<7%Q<.#0T.#0X-%A87%A95[_;V__;__________YI(2$A02%'_________
M____HTA(2$A(2/;_______________________]12%!(2$A2____44A04%!(
MFO____________]12%!(4$A)_____P<'[0<']O______________________
M]@<'!P<'________________"`<'!P?V____!^T'!P?_________________
M]@<'!P?_____________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________V#0T-#@X.%Q<7%Q<7%Q<6
M%@T-#0T-%186%Q<7%EWV]O____________^:2$A(4$A1_____________Z-(
M2$A(2$CV______________________^L24A(4$A(FO___U%(4$A(2)K_____
M________HTA(2$A(2/;___\'!^T'!_________________________\']P?M
M!________________P@'!_<']O__]NT'[0?V__________________8'!P<'
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________[PT-#@X.#@X7%Q<7%Q<6%A8-#4U5
MK^]6%Q<7%Q869O;V____________FDA(2%!(4?____________^C2$A(2$A(
M]O_________UHZ*:FIJ:FII12$A(4$A02*3___]12%!(2$B:____________
M_^U(2$A(2$CU____!^T'[0?_________________________!P<'[0?V____
M__________\(!P<'!_;___8'!P?W]O_________________V!P<'!_______
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________]J\-#0T.#@X.#A87%A86%E955:;O]O;V5A87
M%Q<7%Q:F]O;__________YI(2$A02%'_____________HTA(4$A(2/;_____
M__=12$A02$A(2$A02$A(4$A(4$@(____24A(2$A(FO_________V__\(2$A(
M2$A([?__]NT'!^T(_________________________P<'!^T'!PC_________
M____"`<'[0?V___V!_<'!___________________]@<'!P?_____________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________V]O:=#0T.#@X.#@X.#EY>IJ_O]O;V]O;V]EX7%Q<7%Q86
M5J_V_______V__^:2$A(4$A1_____________Z-(2%!02$CV_____Z-(2%!(
M2$A(2$A(2$A(4$A02$B:_____U%(2$A(2)K_____________]DA02$A(2/?_
M__;M!P<'"/__________________________!^T'!P<'!P<'!P<'!P<'[0?M
M!P<']O__".T'!P?___________________8'!P<'____________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________;V5`T-#0X.#@T-#@VO]O;V]O;___;V__9>%A<7%Q87%Q96[_;_
M____]O__FDA(2%!(4?____________^C2$A04$A(]O____5(2$A(2$A(2$A(
M4%!(2$A(2$A1]O____]12%!(2$B:______________](4$A(2$CW___V]P<'
M!_;___________________________8'!P<'!P?W]P<']P<'!_<'!P<'!_;_
M__8'!^WM___________________V!P<'!___________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M]O_V]E0-#0X.#0T.#0T-IO;V]O;V_______V7A86%Q<7%Q875EWV]O______
M_YI(2$A02%'_____________HTA(4%!02?;___]:2$A02%!(2%!(2%!(2$A(
M2$F;]O______45!(4$A(FO______________2$A(4$A0]___]@?M!P<(____
M________________________]@?W!P<'!P<'!P<']_<'!P?W!P?V___V[0<'
M]___________________]@<']P?_________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________]O__]O94
M#0X.#@X.#@X.#57V]O;V]O______]F86%Q<.%PX6%@Y5IO;_______^:2$A0
M4$A1________]O___Z-(4%!02$GV____24A(2$A(2$A1FE%1FEJ:FZ0(____
M_____U%02$A02)K_____________"$A04$A(2.W___8'[>T'"/__________
M____________________]@<'!P<'!P<'!P<'!P<'!P<']O__]@<'[0?_____
M______________8'!P<'________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________V[UY7%Q<6
M#@X.#@T-K_;____V]O__]O8-#0T.#@X.#@T-#:;V]O______FDA02%!(4?__
M____]O____^C2%!02%!(]O__"$A04$A(2*/_______________________]1
M4$A(2$B:______;______^U(2$A04$CU____!P<'[0?_________________
M____________________]O;V]O____\(!P<'!_;___;M!P<']O__________
M_______V!_?W!_______________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________]O9G7A\7%Q=75Q<6
M%E_V]O__]O____:F#0T-#@X.#@X.#0SO]O_______YI(4$A02%'_____]O_V
M]O__FTA(2$A02/___P=(2$A(2%'_________________________44A(2$A(
MFO____________^C2%!(4$A("/___P<'[0<'________________________
M________________________"`<'!P?V____!P<'!PC_________________
M]@<'!P?_____________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________V]F8>'Q<?%Q<7'Q]>K_;V
M____]O;V50T-#0X.#@X-#DU5]O;_______^:4$A02$A1]?___________U%(
M2%!(2$G___\'2$A(2$A1_________________________U%(2$A(2)K_____
M________24A(2%!(2?____\']P<'!_;_____________________________
M__________________8'!P<']O___P<'!P<'__________________8'!_<'
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________]O:_7A\?%Q<7%Q<?'UZO]O;____V
M[PP-#0X.#@X.#0U-IO;_________FDA(2$A(2$BC"?_______Z1(2$A(2$B:
M____"$A(2$A(2`G_______________\'[?____]12$A(2$A1[/;________V
MFDA02%!(2)K_____]@<'!^T']O__________________________________
M__________\'!P<'[?;____V!P<'[0C________________V]P<'!_______
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________;_____]K=>'Q\?'Q<?%Q\>7K?V]O__]E4-#0T.
M#@X.#0T-3?;__________YI(4$A(2$A02$B:[?4']5%02$A(2$A(]_____]1
M2$A(2$A1[0C______PD'[:-)2)O_____45!(4%!(2$A(4:/W[>RC2%!02%!(
M2$GU______\'!^WM!P?_________________________________________
M___V!P<'!P?______P?M!P<'"/______________]@<']P?_____________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________V]O____;VKUX?'Q\?'Q<?'QY>O_;V]N\-#0T.#@X.#0T-
M#57V__________^:2$A(2%!(2$A(2$A(2$A02$A(2%!(2`C_____FDA(2$A(
M2$A)2%%)44A(2$A(2$BC_____U%02%!(2%!04$A(2$A(2%!(2%!02$A2___V
M____]NWM!P?M!PC_______________________;________________V!P<'
M!P<'______\(!^T'!_<']O_________V!P?W!P<'____________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________]O9F7A\?%Q<?'Q<?7EX(]O9=#0X.#@X.#@X-#0VG]O__
M________FDA(2$A02$A(4%!(2$A(2$A02$A(2:/______P=)2$A(4$A(2$A(
M2$A04$A(2$A(H_____]12$A(4%!(4%!(4$A02%!(2$A(2%%1"/____;___\(
M!_<'!P<'!P<("/8("`@'!P<'______\'!P<'"/;V]O;V]@@'!P?M!P?M]O__
M_____P<'!P<'!P<'!P<'!P<'!_<'!P<'!___________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________V]F9?%Q\7%Q\7'Q\>7K?O#`T.#@X.#@X.#@T,[_;_________
M_YI02$A02%!(24A(4$A(2$A02$A(25+_________[4E(2$A(2$A(2%!(2$A(
M2$A(2*/_____44A(2$A(4$A02$A04$A02$A02$A1!_______]O____8']P?M
M!P<'!P<'!P<'!_<'!_______!P<'!^X'!P<'!P<'!^T'!P<'"/__________
M"/<'!P<']P<'!_?M!P<'!^T'!P?_________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____]O8(7E\7%Q\?%Q<?'Q]?7PT-#0T-#@X.#@X-5/;V__________^:2$A(
M2$A02$A(2$A(2$A(2$A(2)O___________\'44A(2$A02$A02$A(2$A(2$BC
M_____U%(2$A(4%FC2$A(2$A(2$A(2$F:"/______________]@?W!P<'!P<'
M!P<'[0<'!P?______P?W!P?M!P<'!P<'!P<'[>T'"/_____________V!P<'
M!P<']_<'!^WW!P?M!^T'________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________________V
M]K=>'Q<?%Q\7'Q\7'Q<-#@T-#0T.#@X.#:;V____________FDA(2$A(4?\)
M]:-12$A(2$A1HP?________________UFU%(2$A(2$A(2$A(6NP'______]1
M2$A(2$B:_PFL44A(2$E(4:,'____________________]@@'!P?M!P<'!P?M
M!P<'______\(!P?W[0<'!P<'!P?M!P<(___________________V"`<'!P<'
M]P<'"/;V!P<'!_______________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________]O;VKUX?
M'Q<7'Q<?'Q<7%PX.#@T.#@X.#0WO_______V_____YI)2$A02%'________V
M"`CV________________________"/7U[?7M]0<(____________44A(2$A(
MFO______]O;V]O_____________________________V]O;V]@CV]O______
M________]O8("`@'"`@(]O;_____________________________________
M]@<'!P?_____________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________]O:G7A<?%Q<?
M%Q<?%Q\7#@X-#0X-#0U5]O____________^:2$A02%!1________________
M]O__________________________________]O_______U%(2$A(2)K_____
M____________________________________________________________
M________________________]O____________________________8'!^T'
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________;V]F9>'Q<7%Q\7'Q\7
M%Q<.#@X-#0T-I_;_____________FDA(2%!(4?______________________
M______________________________________]12$A(2$B:____________
M____________________________________________________________
M_______________________________________________V!P<'!_______
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________]O;V7A8?'Q<?'Q\7%Q<7#@X.
M#@T-3._V_____________YI(4$A(4%'_______________;_____________
M___V____________________________44A(4$A(FO_____V____________
M____________________________________________________________
M________________________________________]@<'!P?_____________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________V]K=>'Q\?'Q\7'Q\7%Q<.#@X-#57V
M]O;___________^:2%!(2$A1____________________________________
M_________________________U%(2%!02)K_________________________
M____________________________________________________________
M__________________________________8'!P<'____________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________;VKUX?'Q<?'Q<7'Q\7%PX-#0VF]O;_____
M________FDA(2$A04?__________________________________________
M__________________]14$A(4$B:________________________________
M____________________________________________________________
M___________________________V!P?M!___________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________V]O9G7A\?%Q\7'Q<?%Q<7#@T-[_;_]O__________
M_YI(2%!02%'_]O______________________________________________
M____________24A(2$A(FO______________________________________
M____________________________________________________________
M____________________]@<'!P?_________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________;V]F9>7AX>'Q]>7E]?7Q8-3?;___;___________^;2$A(
M2$A1________________________________________________________
M_____U%(2$A(2)K_____________________________________________
M____________________________________________________________
M______________8'[0?M________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________]O;V[^^WKZ^GIUY>7EY>59[V________________FDA(4%!04?__
M________________________________________________________]O])
M2%!(2$B:____________________________________________________
M____________________________________________________________
M_______V!P?M[?______________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____]O;V]O;V]O;V]@BW[Z_O]O_______________ZQ(2%!(4%'_________
M____________________________________________________FTA(2$A(
MFO__________________________________________________________
M____________________________________________________________
M]@<'!^W_____________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___V]O;V]O;V]O;V]O;_________________]5%(2$A1________________
M_______________________________________________L44A(2)K_____
M____________________________________________________________
M______________________________________________________8'[0?W
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____]O__]O;________________V___VFDE(4?______________________
M_________________________________________PE22$F:____________
M____________________________________________________________
M________________________________________________!P<']_______
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________U25+_____________________________
M______________________________________=)6___________________
M____________________________________________________________
M___________________________________________V!^W_____________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________:C____________________________________
M________________________________"*3_________________________
M____________________________________________________________
M______________________________________\(____________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________;_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________;_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________;_____]O______
M____________________________________________________________
M______;_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________]O__]O______________
M__________________________________________________________;_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________``#_____________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________\`________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____`/______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__])`/______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________P``________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P`'`/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P#_`/______________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________20#_____________________
M____________________________________________________________
M________________``#_________________________________________
M________________________________________________________``<`
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________20<`
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__\`_P#_____________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P#_________________________________________________________
M____________________________________________________________
M______________________________________________________\`__\`
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________TD'`/__________________________
M____________________________________________________________
M_________TD'`/______________________________________________
M_________________________________________________TD'!P#_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``<'`/______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________`````````````````/____\`____
M`````````````````/__________________________________________
M____________________________________________________________
M____________________________``````````````````#___\`!P<'````
M`````````````/______________________________________________
M____________________________________________________________
M_________________________P````````````````#___\`_____P``````
M`````````/__________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P`'!P<`__\`````````````________________
M______________________________________\`````````````````____
M_P`'!P<`````````````````____________________________________
M__________________\``````````````````/____])!P<'````````````
M````________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________``````!)24E)24E)
M24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)
M24E)24E)24E)24E)24E)24E)24E)24E)24E)`/___TD'!P<`24E)24E)24E)
M24E)24E)24E)24E)24E)20!)24E)24E)24E)24E)24E)24E)24E)24E)24E)
M24E)24E)24D`24E)24E)24E)24E)24E)24E)24E)24D``````/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________`/________\`____`/__________
M__\`________________________________________________________
M____________________________________________________________
M____________________________20<'!P<'!P<`____20<'!P<'!P<'!P<`
M____________________________________________________________
M____________________________________________________________
M________________________`/________\`____`/____________\`____
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________``````!)
M24E)24E)20#___])!P<'!TE)!P<'`/______________________________
M______________________________________])!P<'!P<'!P#___])!P<'
M!P<'!P<'!P#_________________________________________________
M__________________\`!P<'!P<'!P#___\`!P<'!P<'!P<'!P#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P#__P`'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P#__________P#__P#_____________`/__
M____________________________________________________________
M____________________________________________________________
M_____________________TD'!P<'!P<'!P#__TD'!P<'!P<'!P<'`/______
M____________________________________________________________
M____________________________________________________________
M_________________P#__________P#_`/______________`/__________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<`__\`!P<'!P<'!P<'!P#_____________________________________
M________________________________20<'!P<'!P<'`/__20<'!P<'!P<'
M!P<`________________________________________________________
M____________``<'!P<'!P<'`/__20<'!P<'!P<'!P<`________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'`/\`!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\`__________\`_P#______________P#_________
M____________________________________________________________
M____________________________________________________________
M______________])!P<'!P<'!P<'```'!P<'!P<'!P<'!P#_____________
M____________________________________________________________
M____________________________________________________________
M__________\`____________``#______________P#_________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P#_
M20<'!P<'!P<'!P<`____________________________________________
M_________________________TD'!P<'!P<'!P#_``<'!P<'!P<'!P<'`/__
M____________________________________________________________
M_____P`'!P<'!P<'!P<```<'!P<'!P<'!P<'`/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P#_20<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`/___________P``______________\`________________
M____________________________________________________________
M____________________________________________________________
M________20<'!P<'!P<'!P!)!P<'!P<'!P<'!P<`____________________
M____________________________________________________________
M____________________________________________________________
M____`/___________P``______________\`________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'`$D'!P<'
M!P<'!P<'`/__________________________________________________
M__________________])!P<'!P<'!P<'`$D'!P<'!P<'!P<'!P#_________
M__________________________________________________________\`
M!P<'!P<'!P<'```'!P<'!P<'!P<'!P#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P#_____________________________`/______________________
M____________________________________________________________
M____________________________________________________________
M_TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________________________
M____________________________________________________________
M_________________________________________________________P#_
M____________________________`/______________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P#_________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________
M____________________________________________________``<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\`
M_____________________________P#_____________________________
M____________________________________________________________
M______________________________________________________])!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________________________
M____________________________________________________________
M__________________________________________________\`________
M_____________________P#_____________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________
M_____________________________________________P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________`/______
M______________________\`____________________________________
M____________________________________________________________
M________________________________________________20<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`________________________________________
M____________________________________________________________
M____________________________________________`/______________
M______________\`____________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________________
M______________________________________\`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P#_____________
M________________`/__________________________________________
M____________________________________________________________
M_________________________________________TD'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'`/______________________________________________
M____________________________________________________________
M_____________________________________P#_____________________
M________`/__________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`____________________________________
M________________________________``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<`________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\`____________________
M_________P#_________________________________________________
M____________________________________________________________
M__________________________________])!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P#_____________________________________________________
M____________________________________________________________
M______________________________\`____________________________
M_P#_________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/__________________________________________
M_________________________P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________])!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'
M!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________`/__________________________
M__\`________________________________________________________
M____________________________________________________________
M____________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M____________________________________________________________
M____________________________________________________________
M________________________`/____________________________\`____
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P#_________________________________________________
M__________________\`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P#_____________________________`/__
M____________________________________________________________
M____________________________________________________________
M_____________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______
M____________________________________________________________
M____________________________________________________________
M_________________P#_____________________________`/__________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<`________________________________________________________
M____________``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\`_____________________________P#_________
M____________________________________________________________
M____________________________________________________________
M______________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________
M____________________________________________________________
M____________________________________________________________
M__________\`_____________________________P#_________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__
M____________________________________________________________
M_____P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`/____________________________\`________________
M____________________________________________________________
M____________________________________________________________
M________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____________________
M____________________________________________________________
M____________________________________________________________
M____`/____________________________\`________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/__________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________
M__________________________________________________________\`
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P#_____________________________`/______________________
M____________________________________________________________
M____________________________________________________________
M_TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________________________
M____________________________________________________________
M_________________________________________________________P#_
M____________________________`/______________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________
M____________________________________________________``<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\`
M_____________________________P#_____________________________
M____________________________________________________________
M______________________________________________________])!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________________________
M____________________________________________________________
M__________________________________________________\`________
M_____________________P#_____________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________
M_____________________________________________P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________`/______
M______________________\`____________________________________
M____________________________________________________________
M________________________________________________20<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`________________________________________
M____________________________________________________________
M____________________________________________`/______________
M______________\`____________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________________
M______________________________________\`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P#_____________
M________________`/__________________________________________
M____________________________________________________________
M_________________________________________TD'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'`/______________________________________________
M____________________________________________________________
M_____________________________________P#_____________________
M________`/__________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`____________________________________
M________________________________``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<`________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\`____________________
M_________P#_________________________________________________
M____________________________________________________________
M__________________________________])!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P#_____________________________________________________
M____________________________________________________________
M______________________________\`____________________________
M_P#_________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/__________________________________________
M_________________________P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________])!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'
M!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________`/__________________________
M__\`________________________________________________________
M____________________________________________________________
M____________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M____________________________________________________________
M____________________________________________________________
M________________________`/____________________________\`____
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P#_________________________________________________
M__________________\`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P#_____________________________`/__
M____________________________________________________________
M____________________________________________________________
M_____________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______
M____________________________________________________________
M____________________________________________________________
M_________________P#_____________________________`/__________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<`________________________________________________________
M____________``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P=)!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\`_____________________________P#_________
M____________________________________________________________
M____________________________________________________________
M______________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________
M____________________________________________________________
M____________________________________________________________
M__________\`_____________________________P#_________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__
M____________________________________________________________
M_____P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`/____________________________\`________________
M____________________________________________________________
M____________________________________________________________
M________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____________________
M____________________________________________________________
M____________________________________________________________
M____`/____________________________\`________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/__________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________
M__________________________________________________________\`
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P#_____________________________`/______________________
M____________________________________________________________
M____________________________________________________________
M_TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________________________
M____________________________________________________________
M_________________________________________________________P#_
M____________________________`/______________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________
M____________________________________________________``<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\`
M_____________________________P#_____________________________
M____________________________________________________________
M______________________________________________________])!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________________________
M____________________________________________________________
M__________________________________________________\`________
M_____________________P#_____________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________
M_____________________________________________P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________`/______
M______________________\`____________________________________
M____________________________________________________________
M________________________________________________20<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`________________________________________
M____________________________________________________________
M____________________________________________`/______________
M______________\`____________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________________
M______________________________________\`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P#_____________
M________________`/__________________________________________
M____________________________________________________________
M_________________________________________TD'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'`/______________________________________________
M____________________________________________________________
M_____________________________________P#_____________________
M________`/__________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`____________________________________
M________________________________``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<`________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\`____________________
M_________P#_________________________________________________
M____________________________________________________________
M__________________________________])!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P#_____________________________________________________
M____________________________________________________________
M______________________________\`____________________________
M_P#_________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/__________________________________________
M_________________________P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________])!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'
M!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________`/__________________________
M__\`________________________________________________________
M____________________________________________________________
M____________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M____________________________________________________________
M____________________________________________________________
M________________________`/____________________________\`____
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P#_________________________________________________
M__________________\`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P#_____________________________`/__
M____________________________________________________________
M____________________________________________________________
M_____________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______
M____________________________________________________________
M____________________________________________________________
M_________________P#_____________________________`/__________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<`________________________________________________________
M____________``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\`_____________________________P#_________
M____________________________________________________________
M____________________________________________________________
M______________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________
M____________________________________________________________
M____________________________________________________________
M__________\`_____________________________P#_________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__
M____________________________________________________________
M_____P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`/____________________________\`________________
M____________________________________________________________
M____________________________________________________________
M________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____________________
M____________________________________________________________
M____________________________________________________________
M____`/____________________________\`________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/__________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________
M__________________________________________________________\`
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P#_____________________________`/______________________
M____________________________________________________________
M____________________________________________________________
M_TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________________________
M____________________________________________________________
M_________________________________________________________P#_
M____________________________`/______________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________
M____________________________________________________``<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\`
M_____________________________P#_____________________________
M____________________________________________________________
M______________________________________________________])!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________________________
M____________________________________________________________
M__________________________________________________\`________
M_____________________P#_____________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________
M_____________________________________________P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________`/______
M______________________\`____________________________________
M____________________________________________________________
M________________________________________________20<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`________________________________________
M____________________________________________________________
M____________________________________________`/______________
M______________\`____________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________________
M______________________________________\`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P#_____________
M________________`/__________________________________________
M____________________________________________________________
M_________________________________________TD'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'`/______________________________________________
M____________________________________________________________
M_____________________________________P#_____________________
M________`/__________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`____________________________________
M________________________________``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<`________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\`____________________
M_________P#_________________________________________________
M____________________________________________________________
M__________________________________])!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P#_____________________________________________________
M____________________________________________________________
M______________________________\`____________________________
M_P#_________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/__________________________________________
M_________________________P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________])!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'
M!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________`/__________________________
M__\`________________________________________________________
M____________________________________________________________
M____________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M____________________________________________________________
M____________________________________________________________
M________________________`/____________________________\`____
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P#_________________________________________________
M__________________\`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P#_____________________________`/__
M____________________________________________________________
M____________________________________________________________
M_____________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______
M____________________________________________________________
M____________________________________________________________
M_________________P#_____________________________`/__________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<`________________________________________________________
M____________``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\`_____________________________P#_________
M____________________________________________________________
M____________________________________________________________
M______________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________
M____________________________________________________________
M____________________________________________________________
M__________\`_____________________________P#_________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__
M____________________________________________________________
M_____P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`/____________________________\`________________
M____________________________________________________________
M____________________________________________________________
M________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____________________
M____________________________________________________________
M____________________________________________________________
M____`/____________________________\`________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/__________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________
M__________________________________________________________\`
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P#_____________________________`/______________________
M____________________________________________________________
M____________________________________________________________
M_TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________________________
M____________________________________________________________
M_________________________________________________________P#_
M____________________________`/______________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________
M____________________________________________________``<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\`
M_____________________________P#_____________________________
M____________________________________________________________
M______________________________________________________])!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________________________
M____________________________________________________________
M__________________________________________________\`________
M_____________________P#_____________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________
M_____________________________________________P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________`/______
M______________________\`____________________________________
M____________________________________________________________
M________________________________________________20<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`________________________________________
M____________________________________________________________
M____________________________________________`/______________
M______________\`____________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________________
M______________________________________\`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P#_____________
M________________`/__________________________________________
M____________________________________________________________
M_________________________________________TD'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'`/______________________________________________
M____________________________________________________________
M_____________________________________P#_____________________
M________`/__________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`____________________________________
M________________________________``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<`________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\`____________________
M_________P#_________________________________________________
M____________________________________________________________
M__________________________________])!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P#_____________________________________________________
M____________________________________________________________
M______________________________\`____________________________
M_P#_________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/__________________________________________
M_________________________P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________])!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'
M!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________`/__________________________
M__\`________________________________________________________
M____________________________________________________________
M____________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M____________________________________________________________
M____________________________________________________________
M________________________`/____________________________\`____
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P#_________________________________________________
M__________________\`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P#_____________________________`/__
M____________________________________________________________
M____________________________________________________________
M_____________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______
M____________________________________________________________
M____________________________________________________________
M_________________P#_____________________________`/__________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<`________________________________________________________
M____________``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\`_____________________________P#_________
M____________________________________________________________
M____________________________________________________________
M______________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________
M____________________________________________________________
M____________________________________________________________
M__________\`_____________________________P#_________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__
M____________________________________________________________
M_____P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`/____________________________\`________________
M____________________________________________________________
M____________________________________________________________
M________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____________________
M____________________________________________________________
M____________________________________________________________
M____`/____________________________\`________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/__________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________
M__________________________________________________________\`
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P#_____________________________`/______________________
M____________________________________________________________
M____________________________________________________________
M_TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________________________
M____________________________________________________________
M_________________________________________________________P#_
M____________________________`/______________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________
M____________________________________________________``<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\`
M_____________________________P#_____________________________
M____________________________________________________________
M______________________________________________________])!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________________________
M____________________________________________________________
M__________________________________________________\`________
M_____________________P#_____________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________
M_____________________________________________P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________`/______
M______________________\`____________________________________
M____________________________________________________________
M________________________________________________20<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`________________________________________
M____________________________________________________________
M____________________________________________`/______________
M______________\`____________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________________
M______________________________________\`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P#_____________
M________________`/__________________________________________
M____________________________________________________________
M_________________________________________TD'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'`/______________________________________________
M____________________________________________________________
M_____________________________________P#_____________________
M________`/__________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`____________________________________
M________________________________``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<`________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\`____________________
M_________P#_________________________________________________
M____________________________________________________________
M__________________________________])!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P#_____________________________________________________
M____________________________________________________________
M______________________________\`____________________________
M_P#_________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/__________________________________________
M_________________________P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________])!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'
M!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________`/__________________________
M__\`________________________________________________________
M____________________________________________________________
M____________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M____________________________________________________________
M____________________________________________________________
M________________________`/____________________________\`____
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P#_________________________________________________
M__________________\`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P#_____________________________`/__
M____________________________________________________________
M____________________________________________________________
M_____________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______
M____________________________________________________________
M____________________________________________________________
M_________________P#_____________________________`/__________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<`________________________________________________________
M____________``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\`_____________________________P#_________
M____________________________________________________________
M____________________________________________________________
M______________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________
M____________________________________________________________
M____________________________________________________________
M__________\`_____________________________P#_________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__
M____________________________________________________________
M_____P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`/____________________________\`________________
M____________________________________________________________
M____________________________________________________________
M________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____________________
M____________________________________________________________
M____________________________________________________________
M____`/____________________________\`________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/__________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________
M__________________________________________________________\`
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P#_____________________________````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M`$E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)
M24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)
M24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)24E)20#_
M____________________________`/______________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P``````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M``````````````````````````````````````````````````````<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\`
M_____________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________
M_____________________P#_____________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________`/______
M______________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________
M______________\`____________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P#_____________
M________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________
M________`/__________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<`________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P=)
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\`____________________
M_________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____________________________
M_P#_________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________])!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'
M!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________`/__________________________
M__])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'`/____________________________\`____
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P#_____________________________20<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P#_____________________________`/__________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\`_____________________________TD'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<`_____________________________P#_________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`/____________________________])!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'`/____________________________\`________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P#_____________________________20<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_
M____________________________`/______________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\`
M_____________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________
M_____________________P#_____________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________`/______
M______________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________
M______________\`____________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P#_____________
M________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________
M________`/__________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<`________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\`____________________
M_________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____________________________
M_P#_________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________])!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'
M!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________`/__________________________
M__])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'`/____________________________\`____
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P#_____________________________20<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P#_____________________________`/__________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\`_____________________________TD'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<`_____________________________P#_________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`/____________________________])!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'`/____________________________\`________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P#_____________________________20<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_
M____________________________`/______________________________
M_____________P#_____________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/__________________________________________________
M____________________________________________________________
M_________P#_________________________________________________
M__________________________________________________________\`
M_____________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________
M_____________________P#_____________________________________
M______\`____________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/__________________________________________
M____________________________________________________________
M_________________P#_________________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________________________________________________
M____________________________________________________________
M__\`________________________________________________________
M____________________________________________________`/______
M______________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________
M______________\`____________________________________________
M`/__________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P#_________________________________________________
M____________________________________________________________
M__________\`________________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P`'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M____________________________________________________________
M________________________________________________________`/__
M____________________________________________________________
M_____________________________________________P#_____________
M________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________
M________`/___________________________________________P#_____
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<`________________________________________________________
M____________________________________________________________
M____`/______________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P`'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M____________________________________________________________
M_________________________________________________P#_________
M____________________________________________________________
M______________________________________\`____________________
M_________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P``````````____________________________
M_P#___________________________________________\`____________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__
M____________________________________________________________
M_________________________________________________________P#_
M____________________________________________________________
M____________________________________________________________
M__________________________________________________])!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P``````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
M````````````!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________________________________________________
M__________________________________________\`________________
M____________________________________________________________
M________________________________`/__________________________
M__\`````````````````````````````````````````````24E)24E)24E)
M24E)24E)24E)24E)20``````````````````````````````````````7PL+
M"PL+"PL+"PL+"PL+"PL+"PL+"PL+"PL+"PL+"PL+"PL+"PL+"PL+"PL+"PL+
M"PL+"PL+"PL+"PL+"PL+"PL+"PL+"U\5````````````````````````````
M`````````$E)24E)24E)24E)24E)24E)24E)24D`````````````````````
M``````````````#_________`/____________________________\`____
M________________________________________`/__________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'````````````````````````````````
M```````+"PL+"PL+"PL+"PL+"PL+"PL+"PL+"PL+"PL+"PL+"U]?7U]?7U]?
M7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7P``````````````````
M````````````````````!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________
M____________________________________________________________
M__________________________________________________\`________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________7^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^\5________________________________
M____``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M_________________________P#_____________________________`/__
M_________________________________________TD'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<`_____________________________________Q5?[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^]?%?__________________________________
M_P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________________________
M_________________P#_____________________________`/__________
M____________________________``````#_________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U\5________________________
M____________``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________
M____________________________________________________________
M________________________________________`````/______________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/___________________________________P!?[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?`/___________________________________P!)
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M____________________________________________________________
M______________________\`````_P#_____________________________
M____________________________________________________________
M__________________\`_____________________________P#_________
M__________________________________])!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'``#__________________________________P`+7^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^]?``#__________________________________P``20<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________________________
M__________\`_____________________________P#_________________
M_________________P```/____\`________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`_____________________________________Q5?[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U\``/______________________________
M_____P!)!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________
M____________________________________________________________
M_____________________________P```/___P#_____________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M````_________________________________P`+"U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?````_________________________________P``20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M____________________________________________________________
M____________````______\`____________________________________
M____________________________________________________________
M____________`/____________________________\`________________
M____________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'````
M__________________________________\`"PM?[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O7P```/________________________________\``$D'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`________________________________________
M____`/____________________________\`________________________
M______\```#_________`/______________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/____________________________________\5[U_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?````_________________________________P``
M20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________________
M____________________________________________________________
M_________________P````#_______\`____________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P```/__
M______________________________\`"PM?[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O7P```/________________________________\``$D'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________________
M____________________________________________________________
M_P```/__________`/__________________________________________
M____________________________________________________________
M_____P#_____________________________`/______________________
M_____________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P```/______
M____________________________``L+7^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M7^\```#_________________________________``!)!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'`/___________________________________________P#_
M____________________________`/________________________\`````
M_____________P#_____________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_____________________________________%>]?[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[P```/________________________________\``$D'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`____________________________________
M____________________________________________________________
M______\```#_____________`/__________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<```#_________
M________________________``L+[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^\`
M``#_________________________________``!)!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/__________________________________________________
M_________________________________________________P````#_____
M_________P#_________________________________________________
M__________________________________________________________\`
M_____________________________P#_____________________________
M______________])!P<'!P<'!P<'!P<'!P<'!P<'!P<```#_____________
M_____________________P`+"^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O````
M_________________________________P``20<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P#___________________________________________\`________
M_____________________P#_____________________````____________
M______\`____________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M_________________________________Q7O[U_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^]?[^\```#_________________________________``!)!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/__________________________________________
M________________________________________________________````
M_________________P#_________________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'````________________
M_________________P`+"^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O````____
M_____________________________P``20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________________________________________________
M______________________________________\```#_________________
M__\`________________________________________________________
M____________________________________________________`/______
M______________________\`____________________________________
M________20<'!P<'!P<'!P<'!P<'!P<'!P<'````____________________
M______________\`"POO[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[P```/______
M__________________________\``$D'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M____________________________________________`/______________
M______________\`_________________P```/______________________
M`/__________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M__________________________\5[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M````_________________________________P``20<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P#_________________________________________________
M_____________________________________________P```/__________
M__________\`________________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'!P<'!P<'!P<'!P<'!P<'!P```/______________________
M__________\`"POO[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[P```/__________
M______________________\``$D'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M____________________________________________________________
M____________________________````________________________`/__
M____________________________________________________________
M_____________________________________________P#_____________
M________________`/__________________________________________
M_TD'!P<'!P<'!P<'!P<'!P<'!P<'!P```/__________________________
M________``L+[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^\```#_____________
M____________________``!)!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______
M_____________________________________P#_____________________
M________`/____________\```#__________________________P#_____
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________%>_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[P```/__
M______________________________\``$D'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<`________________________________________________________
M_________________________________P````#_____________________
M____`/______________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<```#_____________________________
M____``L+[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^\```#_________________
M________________``!)!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M____________________________________________________________
M_________________P```/___________________________P#_________
M____________________________________________________________
M______________________________________\`____________________
M_________P#___________________________________________])!P<'
M!P<'!P<'!P<'!P<'!P<'!P<```#_________________________________
M_P`+"^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O````____________________
M_____________P``20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________
M______________________________\`____________________________
M_P#_______\`````_____________________________P#_____________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M_____________Q7O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^\```#_________
M________________________``!)!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__
M____________________________________________________________
M______________________\```#_____________________________``#_
M____________________________________________________________
M____________________________________________________________
M__________________________________________________])!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'````_________________________________P`+
M"^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O````________________________
M_________P``20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________________________________________________
M_____P````#______________________________P#_________________
M____________________________________________________________
M________________________________`/__________________________
M__\`____________________________________________20<'!P<'!P<'
M!P<'!P<'!P<'!P<'````__________________________________\`"POO
M[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^]?[^_O[P```/__________________________
M______\``$D'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____________________
M________________________`/____________________________\`____
M````_________________________________P#_____________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M______\5[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O````________________
M_________________P``20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________
M____________________________________________________________
M____________````________________________________`/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P```/________________________________\`"POO[^_O
M7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[P```/______________________________
M__\``$D'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M______________________________________________________\```#_
M________________________________``#_________________________
M____________________________________________________________
M_________________________P#_____________________________`/__
M_________________________________________TD'!P<'!P<'!P<'!P<'
M!P<'!P<'!P```/__________________________________``L+[^_O[U_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^]?[^_O[^\```#_________________________________
M``!)!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________________________
M_________________P#_____________________________`````/______
M____________________________``#_____________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M%>_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[P```/______________________
M__________\``$D'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________
M____________________________________________________________
M`````/________________________________\``/__________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<```#_________________________________``L+[^_O[^]?[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^\```#_________________________________``!)
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M____________________________________________````____________
M________________________`/__________________________________
M____________________________________________________________
M__________________\`_____________________________P#_________
M__________________________________])!P<'!P<'!P<'!P<'!P<'!P<'
M!P<```#__________________________________P`+"^_O[^_O7^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O7^_O[^_O````_________________________________P``20<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________________________
M__________\`_________________________P````#_________________
M_____________________P``____________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`_____________________________________Q7O[^_O
M[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^\```#_____________________________
M____``!)!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________
M_________________________________________________P```/______
M________________________________``#_________________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M````_________________________________P`+"^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O7^_O[^_O````_________________________________P``20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M________________________________`````/______________________
M__________________\```#_____________________________________
M____________________________________________________________
M____________`/____________________________\`________________
M____________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'````
M__________________________________\`"POO[^_O[U_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M7^_O[^_O[P```/________________________________\``$D'!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`________________________________________
M____`/____________________\```#_____________________________
M_________________P```/______________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/____________________________________\5[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O````_________________________________P``
M20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________________
M______________________________________\```#_________________
M____________________________````____________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P```/__
M______________________________\`"POO[^_O[^]?[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[P```/________________________________\``$D'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________________
M_____________________P```/__________________________________
M________________``#_________________________________________
M____________________________________________________________
M_____P#_____________________________`/______________________
M_____________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P```/______
M____________________________``L+[^_O[^_O7^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O
M[^\```#_________________________________``!)!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'`/___________________________________________P#_
M________________````________________________________________
M______________\```#_________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P``__________________________________\``._O[^_O[^]?[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^]?[^_O[^_O[P```/________________________________\``$D'!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`____________________________________
M____________________________````____________________________
M_________________________P``________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<```#_________
M________________________``L+[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^\`
M``#_________________________________``!)!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/__________________________________________________
M__________\```#_____________________________________________
M____________``#_____________________________________________
M__________________________________________________________\`
M_____________________________P#_____________________________
M______________])!P<'!P<'!P<'!P<'!P<'!P<'!P<```#_____________
M_____________________P```._O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^\`````
M_________________________________P````<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P#___________________________________________\`________
M_____P```/__________________________________________________
M_________P#_________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P```/__
M________________________________``L+[^_O[^_O[U_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^\```#_________________________________````!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/__________________________________________
M________________`````/______________________________________
M_____________________P#_____________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<'!P<'!P<'!P<'!P<`````________________
M________________``````OO[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^\``````/__
M_____________________________P`````'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________________________________________________
M````________________________________________________________
M_____P#_____________________________________________________
M____________________________________________________`/______
M______________________\`____________________________________
M________20<'!P<'!P<'!P<'!P<'!P<'!P<```````#_________________
M_____________P`````+[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O````````````````````````
M``````````````````````````````````````````````<'!P<'!P<'!P<`
M____________________________________________`/_______P````#_
M____________________________________________________________
M_P#_________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<```#_________
M_________________________P`+"^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^\`
M`````/______________________________``````!)!P<'!P<'!P<'!P<'
M!P<'!P<'!P#_________________________________________________
M_____P```/__________________________________________________
M_____________P#_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'!P<'!P<`````````````````````````````````````````
M````````````````````````````[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O````````````````````````````
M``````````````````````````````````````````<'!P<'!P<'!P<`____
M________________________________________________`````/______
M_________________________________________________________P#_
M____________________________________________________________
M_____________________________________________P#_____________
M________________`/__________________________________________
M_TD'!P<'!P<'!P<'````````````````````````````````````````````
M``````````````````````````OO[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O`%\`````````````````````````````
M`````````````````````````````````````$D'!P<'!P<'!P<'`/______
M_____________________________________P#___\```#_____________
M_____________________________________________________P#_____
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'````________________
M__________________\`"POO[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\`````````````````````
M````````````````````````````````````````````````20<'!P<'!P<'
M!P<`__________________________________________________\```#_
M____________________________________________________________
M_____P#_____________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P<'!P<'!P<`````````````````````````````````````````````````
M``````````````````!?``OO[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O````````````````````````````````````
M`````````````````````$E)24E)24E)24E)!P<'!P<'!P<'`/__________
M_____________________________________P```/__________________
M_________________________________________________P#_________
M____________________________________________________________
M______________________________________\`____________________
M_________P#___________________________________________])!P<'
M!P<'!P<'`$E)24E)24E)20``````````````````````````````````````
M``````L+"PL+"PL+"PL+[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[PM?"PL+"PL+"P``````````````````````````
M`````````````````$E)24E)24E)20!)!P<'!P<'!P<'!P#_____________
M______________________________\`````________________________
M______________________________________________\`____________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P```/______________________
M____________``L+[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O`%\+"PL+"PL+````````````````
M````````````````````````````24E)24E)24E)24D'!P<'!P<'!P<'`/__
M__________________________________________\`````____________
M_________________________________________________________P#_
M____________________________________________________________
M____________________________________________________________
M__________________________________________________])!P<'!P<'
M!P<'!TE)24E)24E)20``````````````````````````````````````````
M``L+"PL+"PL+"U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?"PL+"PL+"PL`````````````````````````````
M`````````````$E)24E)24E)24E)!P<'!P<'!P<'!P#_________________
M__________________________\```#_____________________________
M__________________________________________\`________________
M____________________________________________________________
M________________________________`/__________________________
M__\`____________________________________________20<'!P<'!P<'
M!P=)24E)24E)24D```````````````````````````````````````````L+
M"PL+"PL+"PM?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^]?[^_O[^_O[^_O``````#_________________________
M_____P```$E)!P<'!P<'!P<'!P<'!P<'!P<'!P<`____________________
M____________________`````/__________________________________
M________________________________________`/__________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<```#_____________________________
M_____P`+"^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U\+"PL+"PL+"PL`````````````````````
M````````````````````24E)24E)24E)24D'!P<'!P<'!P<'!P#_________
M________________________________````________________________
M__________________________________________________\`________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'``````#______________________________P````L+[^_O
M[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O``````#_____________________________
M__\``$E)20<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M______________\`````________________________________________
M____________________________________`/______________________
M____________________________________________________________
M_________________________P#_____________________________`/__
M_________________________________________TD'!P<'!P<'!P<'!P<'
M!P<'!P<'!P````#_________________________________``L+[^_O[^_O
M[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O7^_O[^_O[^_O[^\```#_________________________________
M``!)20<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________________________
M_________P```/______________________________________________
M_________________________________P#_________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'````__________________________________\`
M"POO[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O"P```/______________________
M__________\``$E)!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________
M_____________________P```/__________________________________
M____________________________________________`/______________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<```#_________________________________``L+[^_O[^_O[^_O
M[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O7^_O[^_O[^_O[^\```#_________________________________``!)
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M____````____________________________________________________
M_____________________________P#_____________________________
M____________________________________________________________
M__________________\`_____________________________P#_________
M__________________________________])!P<'!P<'!P<'!P<'!P<'!P<'
M!P<```#__________________________________P`+"^_O[^_O[^_O[^]?
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M7^_O[^_O[^_O[^_O````_________________________________P``20<'
M!P<'!P<'!P<'!P<'!P<'!P<'!P#_______________________________\`
M``#_________________________________________________________
M__________________________\`________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P```/__________________________________``L+[^_O
M[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^\```#_____________________________
M____``!)!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________
M_________P````#_____________________________________________
M_____________________________________P#_____________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M````_________________________________P`+"^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O````_________________________________P``20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#______________________________P```/__
M____________________________________________________________
M______________________\`____________________________________
M____________________________________________________________
M____________`/____________________________\`________________
M____________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'````
M__________________________________\`"POO[^_O[^_O[^_O[U_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O
M[^_O[^_O[P```/________________________________\``$E)!P<'!P<'
M!P<'!P<'!P<'!P<'!P<`____________________________````________
M____________________________________________________________
M____________________`/______________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<```#__________________________________P`+"^_O[^_O[^_O
M[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^]?[^_O[^_O[^_O[^_O````_________________________________P``
M20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#___________________________\`
M``#_________________________________________________________
M______________________________\`____________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P```/__
M______________________________\```OO[^_O[^_O[^_O[^]?[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[P```/________________________________\``$D'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`_________________________P````#_____________
M____________________________________________________________
M________________`/__________________________________________
M____________________________________________________________
M_____P#_____________________________`/______________________
M_____________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<```#_____
M____________________________`!4+[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O
M[^\`%?___________________________________P!)!P<'!P<'!P<'!P<'
M!P<'!P<'!P<'`/______________________`````/__________________
M____________________________________________________________
M_____________P#_____________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M````__________________________________\`"POO[^_O[^_O[^_O[^]?
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[P`5`/__________________________________`$E)!P<'
M!P<'!P<'!P<'!P<'!P<'!P<`________________________````________
M____________________________________________________________
M________________________`/__________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P=)`/__________
M_________________________Q7O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M%?___________________________________P`'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/____________________\```#_________________________
M____________________________________________________________
M_________P#_________________________________________________
M__________________________________________________________\`
M_____________________________P#_____________________________
M______________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________
M______________________\5[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[Q7_
M__________________________________\`!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'!P#__________________P```/______________________________
M____________________________________________________________
M______\`____________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P```/__
M________________________________``L+[^_O[^_O[^_O[^_O7^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O%?___________________________________P`'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<'`/___________________P```/__________________
M____________________________________________________________
M_________________P#_________________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M__________________\5[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[Q7_____
M______________________________\`!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________````____________________________________
M____________________________________________________________
M__\`________________________________________________________
M____________________________________________________`/______
M______________________\`____________________________________
M________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________
M________________%>_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^\5________
M`````/________\`````________``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`
M______________\```#_________________________________________
M__________________________________________________________\`
M`/__________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<```#_________
M_________________________P`+"^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[Q7___________________________________\`!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'!P#______________P````#_____________________________
M____________________________________________________________
M_________P``________________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________`````/________\`
M````________%>_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^\5________````
M`/________\`````________``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M_________P```/______________________________________________
M_____________________________________________________P```/__
M____________________________________________________________
M_____________________________________________P#_____________
M________________`/__________________________________________
M_TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________`````/__________````
M`/_______Q7O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O%?_______P``````
M______\``````/_______P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______
M__\`````____________________________________________________
M______________________________________________\`````_P#_____
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'````________________
M__________________\`"POO[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^\5____
M____`````/________\`````________``<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P<`__________\```#_________________________________________
M__________________________________________________________\`
M``#_`/______________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/_______P``````______\``````/__
M_____Q7O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O%?_______P``````____
M__\``````/_______P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/_______P``
M``#_________________________________________________________
M_________________________________________P````#__P#_________
M____________________________________________________________
M______________________________________\`____________________
M_________P#___________________________________________])!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'`/_______P``````________``````#_____
M__\5[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[Q7_______\``````/______
M``````#_______\`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____````____
M____________________________________________________________
M____________________________________````______\`____________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P````#_____________________
M__________\`````[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O%?_______P``
M````______\``````/_______P`'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__
M____````____________________________________________________
M________________________________________________````_____P#_
M____________________________________________________________
M____________________________________________________________
M__________________________________________________])!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_______\``````/____\```````#_______\5
M[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[Q7_______\``````/____\`````
M``#_______\`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#___\```#_________
M____________________________________________________________
M______________________________\```#_______\`________________
M____________________________________________________________
M________________________________`/__________________________
M__\`____________________________________________20<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P#_______\``````/______````````________%>_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^\5________``````#_____````````
M________``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`_P```/______________
M____________________________________________________________
M_________________________P```/__________`/__________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P<'!P<'!P<'!P``````````````````````````````````````````````
M``````````````````````#O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[Q7_______\``````/__
M__\```````#_______\`!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_`````/__
M____________________________________________________________
M____________________________________`````/________\`________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`________``````#_____````````________%>_O[^_O
M[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O7^_O[^_O[^_O[^_O[^_O[^\5________``````#_____````````____
M____``<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`````____________________
M____________________________________________________________
M____________________````____________`/______________________
M____________________________________________________________
M_________________________P#_____________________________`/__
M_________________________________________TD'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<`________````````_____P```````/_______Q7O[^_O[^_O
M[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M7^_O[^_O[^_O[^_O[^_O[^_O%?________\`````_____P``````________
M_P`'!P<'!P<'!P<'!P<'!P<'!P<'!P````#_________________________
M____________________________________________________________
M_____________P````#______________P#_________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<'!P!)24E)24E)24D`````````````````````````````````````````
M```+"PL+"PL+"PL`"^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^\5________``````#_____````
M````________``<'!P<'!P<'!P<'!P<'!P<'!P<'!P```/______________
M____________________________________________________________
M_________________________P```/______________`/______________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/________\`````````````````_________Q7O[^_O[^_O[^_O
M[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O%?________\`````````````````_________P`'
M!P<'!P<'!P<'!P<'!P<'!P<'`````/______________________________
M____________________________________________________________
M________`````/_______________P#_____________________________
M____________________________________________________________
M__________________\`_____________________________P#_________
M__________________________________])!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'`/________\``````````````````/________\5[^_O[^_O[^_O[^_O
M[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O
M[^_O[^_O[^_O[^_O[Q7_________`````````````````/________\`!P<'
M!P<'!P<'!P<'!P<'!P<```#_____________________________________
M____________________________________________________________
M__\```#_____________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P<'
M24E)24E)24E)```````````````````````````````````````````+"PL+
M"PL+"PL+"^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^]?[^_O[^_O[^_O[^_O[^_O[^_O%?________\`````````````````____
M_____P`'!P<'!P<'!P<'!P<'!P<'!P<```#_________________________
M____________________________________________________________
M______________\```#_________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________`````````````````/________\5[^_O[^_O[^_O[^_O[^_O
M[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[Q7_________`````````````````/________\`!P<'!P<'
M!P<'!P<'!P<'!P```/__________________________________________
M_________________________________________________________P``
M`/__________________________________________________________
M____________________________________________________________
M____________`/____________________________\`________________
M____________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_
M________``````````````````#_________%>_O[^_O[^_O[^_O[^_O[^_O
M[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O
M[^_O[^_O[^\5_________P```````````````/__________``<'!P<'!P<'
M!P<'!P<'````________________________________________________
M____________________________________________________````____
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<``````/______________________________````"^_O[^_O[^_O
M[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[Q7_________`````````````````/________\`
M!P<'!P<'!P<'!P<'!P<'````____________________________________
M____________________________________________________________
M____````____________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M_____P```````````````/__________%>_O[^_O[^_O[^_O[^_O[^_O[U_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^\5_________P```````````````/__________``<'!P<'!P<'!P<'
M!P<```#_____________________________________________________
M______________________________________________\```#_________
M____________________________________________________________
M____________________________________________________________
M_____P#_____________________________`/______________________
M_____________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________
M__\```````````````#__________Q7O[^_O[^_O[^_O[^_O[^_O[^]?[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O
M[^_O%?__________``````````````#__________P`'!P<'!P<'!P<'!P``
M`/__________________________________________________________
M_________________________________________P```/______________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M````__________________________________\`"POO[^_O[^_O[^_O[^_O
M[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^\5_________P```````````````/__________``<'!P<'
M!P<'!P<'`````/______________________________________________
M____________________________________________________`````/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M``````````````#__________Q7O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M%?__________``````````````#__________P`'!P<'!P<'!P<'````____
M____________________________________________________________
M____________________________________````____________________
M____________________________________________________________
M__________________________________________________________\`
M_____________________________P#_____________________________
M______________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________````
M````````````__________\5[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_
M_________P``````````````__________\`!P<'!P<'!P````#_________
M____________________________________________________________
M_____________________________P````#_________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P```/__
M________________________________``L+[^_O[^_O[^_O[^_O[^_O[^_O
M7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O%?__________``````````````#__________P`'!P<'!P<'!P``
M`/__________________________________________________________
M_________________________________________P```/______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#__________P``````
M``````#___________\5[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_____
M_____P````````````#___________\`!P<'!P<'`````/______________
M____________________________________________________________
M________________________`````/______________________________
M____________________________________________________________
M____________________________________________________`/______
M______________________\`____________________________________
M________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#___________\`````````
M````____________%>_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^\5________
M__\`````````````____________``<'!P<```#_____________________
M____________________________________________________________
M__________________\```#_____________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<```#_________
M_________________________P`5"^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[Q7__________P````````````#___________\`!P<'!P<```#_________
M____________________________________________________________
M______________________________\```#_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`__________\`````````````
M____________%>_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^\5__________\`
M````````````____________``<'!P```/__________________________
M____________________________________________________________
M_____________P```/__________________________________________
M____________________________________________________________
M_____________________________________________P#_____________
M________________`/__________________________________________
M_TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____________`````````````/__
M_________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?___________P``
M`````````/___________P`'````________________________________
M____________________________________________________________
M________````________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________%>_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5____
M______\`````````````____________``<`````____________________
M____________________________________________________________
M__________________\`````____________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/___________P```````````/______
M_____Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?___________P``````
M`````/___________P````#_____________________________________
M____________________________________________________________
M__\```#_____________________________________________________
M____________________________________________________________
M______________________________________\`____________________
M_________P#___________________________________________])!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'`/___________P````````````#_________
M__\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7___________\`````````
M`/__________`````/__________________________________________
M________________________________________________________````
M`/__________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M_____________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?__________
M_P```````````/__________````________________________________
M____________________________________________________________
M________````________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________])!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#___________\``````````/____________\5
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7___________\``````````/__
M______\`````________________________________________________
M__________________________________________________\`````____
M____________________________________________________________
M____________________________________________________________
M________________________________`/__________________________
M__\`____________________________________________20<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P#_____________``````````#_____________%>_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5____________``````````#_____
M_P```/______________________________________________________
M_____________________________________________P```/__________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/_______P````#_________``````#_
M______\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7___________\`````
M`````/_______P```/__________________________________________
M_________________________________________________________P``
M`/__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________``````````#_____________%>_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^\5____________``````````#_____````
M____________________________________________________________
M________________________________________````________________
M____________________________________________________________
M____________________________________________________________
M_________________________P#_____________________________`/__
M_________________________________________TD'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<`_____________P``````````_____________Q7O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O%?____________\`````````__\```#_____
M____________________________________________________________
M__________________________________\```#_____________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_______\``````/______````````________
M%>_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5____________``````````#_
M__\```#_____________________________________________________
M______________________________________________\```#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/____________\```````#______________Q7O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O%?____________\```````#__P```/__________
M____________________________________________________________
M_____________________________P```/__________________________
M____________________________________________________________
M____________________________________________________________
M__________________\`_____________________________P#_________
M__________________________________])!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'`/______________````````______________\5[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[Q7_____________````````````________________
M____________________________________________________________
M________________________````________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`________``````#______P```````/_______Q7O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?____________\`````````````____
M____________________________________________________________
M__________________________________\`````____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_____________````````______________\5[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[Q7_____________``````````#_____________________
M____________________________________________________________
M__________________\```#_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________`/____________________________\`________________
M____________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_
M_____________P```````/______________%>_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^\5_____________P```````/__________________________
M____________________________________________________________
M____________`````/__________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/_______P```````/____\```````#_______\5[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[Q7_____________````````________________
M____________________________________________________________
M________________________````________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M__________\``````/______________%>_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^\5______________\``````/______________________________
M____________________________________________________________
M______\`````________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P#_____________________________`/______________________
M_____________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________
M________``````#______________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^]?[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O%?___________P````````#_________________________________
M____________________________________________________________
M_P```/______________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________``````````````````#_________%>_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^\5_____________P```````/______________________
M____________________________________________________________
M_____________P```/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M_____P``_________________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M%?__________````_P``________________________________________
M________________________________________________________````
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\`
M_____________________________P#_____________________________
M______________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________
M__\``/________________\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O
M[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_
M______\```#___\``/__________________________________________
M__________________________________________________\```#_____
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M_____P``````````````````_________Q7O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O%?_______P````#__P``________________________________
M____________________________________________________________
M_P````#_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M__________________\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_____
M_P```/______________________________________________________
M_____________________________________________P```/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________`/______
M______________________\`____________________________________
M________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________
M________________%>_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O
M[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5__\`````
M____________________________________________________________
M______________________________________\`````________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M````````````````__________\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[U_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[Q7___\```#_________________________________________________
M__________________________________________________\```#_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M____________%>_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5_P````#_____
M____________________________________________________________
M_________________________________P````#_____________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P#_____________
M________________`/__________________________________________
M_TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____________________________
M_________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O
M[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O````____________
M____________________________________________________________
M____________________________````____________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#__________P``````
M`````````/__________%>_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5````
M____________________________________________________________
M________________________________________````________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M_____Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O``#_________________
M____________________________________________________________
M______________________\```#_________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\`____________________
M_________P#___________________________________________])!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'`/__________________________________
M__\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O
M7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_____________________
M____________________________________________________________
M_________________P```/______________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____________````````````
M`/___________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?__________
M____________________________________________________________
M_____________________________P```/__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________])!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#___________________________________\5
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_________________________
M____________________________________________________________
M____________````____________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________`/__________________________
M__\`____________________________________________20<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P#_____________________________________%>_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O7^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5____________________________
M____________________________________________________________
M______\```#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/___________P````````````#_____
M______\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O
M[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_________________
M____________________________________________________________
M_________________P````#_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________%>_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^\5________________________________
M____________________________________________________________
M_P```/______________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P#_____________________________`/__
M_________________________________________TD'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<`_____________________________________Q7O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O%?__________________________________
M______________________________________________________\`````
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#___________\`````````````____________
M%>_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5________________________
M____________________________________________________________
M______\```#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/___________________________________Q7O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O%?______________________________________
M_________________________________________________P````#_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\`_____________________________P#_________
M__________________________________])!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'`/____________________________________\5[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[Q7_________________________________________
M____________________________________________````____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`_____________P``````````_____________Q7O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?______________________________
M________________________________________________________````
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#___________________________________\5[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[Q7_____________________________________________
M______________________________________\```#_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`/____________________________\`________________
M____________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_
M____________________________________%>_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O7^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^\5________________________________________________
M_________________________________P```/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/____________\``````````/____________\5[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[Q7_____________________________________
M____________________________________________`````/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M________________________________%>_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O7^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^\5____________________________________________________
M____________________________````____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P#_____________________________`/______________________
M_____________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________
M_____________________________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O%?______________________________________________________
M_____________________P````#_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#______________P```````/______________%>_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^\5____________________________________________
M_________________________________P```/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M_________________________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^]?[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M%?__________________________________________________________
M________________`````/______________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\`
M_____________________________P#_____________________________
M______________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________
M______________________\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O7^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_
M____________________________________________________________
M__________\```#_____________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M__________\```````#______________Q7O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^]?[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O%?__________________________________________________
M______________________\```#_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M__________________\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[U_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_____
M____________________________________________________________
M_____P```/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________`/______
M______________________\`____________________________________
M________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________
M________________%>_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?
M[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5________
M____________________________________________________________
M````________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M_____P``````______________\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[U_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[Q7_________________________________________________________
M__________\`````____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M____________%>_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O
M[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5____________
M______________________________________________________\```#_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P#_____________
M________________`/__________________________________________
M_TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____________________________
M_________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O
M7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?______________
M_________________________________________________P```/______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M``#_________________%>_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^]?[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5____
M____________________________________________________________
M````________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M_____Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?__________________
M__________________________________________\`````____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\`____________________
M_________P#___________________________________________])!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'`/__________________________________
M__\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O7^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_____________________
M_____________________________________P````#_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M_____________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O
M[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?__________
M_________________________________________________P```/______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________])!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#___________________________________\5
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_________________________
M________________________________````________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________`/__________________________
M__\`____________________________________________20<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P#_____________________________________%>_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[U_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5____________________________
M__________________________\```#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M______\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_________________
M______________________________________\```#_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________%>_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^\5________________________________
M_____________________P```/__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P#_____________________________`/__
M_________________________________________TD'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<`_____________________________________Q7O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[U_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O%?__________________________________
M________________````________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M%>_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5________________________
M__________________________\`````____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/___________________________________Q7O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O%?______________________________________
M__________\```#_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\`_____________________________P#_________
M__________________________________])!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'`/____________________________________\5[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[Q7_________________________________________
M____`````/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`_____________________________________Q7O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?______________________________
M________________````________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#___________________________________\5[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[Q7___________________________________________\`
M````________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`/____________________________\`________________
M____________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_
M____________________________________%>_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^]?7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^\5_________________________________________P```/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/____________________________________\5[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[Q7_____________________________________
M_____P```/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M________________________________%>_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^\5________________________________________````________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P#_____________________________`/______________________
M_____________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________
M_____________________________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^]?[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O%?____________________________________\```#_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_____________________________________%>_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^\5_____________________________________P````#_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M_________________________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M%?___________________________________P```/__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\`
M_____________________________P#_____________________________
M______________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________
M______________________\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O7^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_
M______________________________\`````________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M_________________________________Q7O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O%?________________________________\```#_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M__________________\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O7^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_____
M_________________________P````#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________`/______
M______________________\`____________________________________
M________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_____________________
M________________%>_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M7^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5________
M____________________````____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M__________________________\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[Q7_____________________________````________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M____________%>_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5____________
M______________\```#_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P#_____________
M________________`/__________________________________________
M_TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____________________________
M_________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O
M7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?______________
M_________P```/______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M____________________%>_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^]?[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5____
M_____________________P```/__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M_____Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[U_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?__________________
M____````____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\`____________________
M_________P#___________________________________________])!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'`/__________________________________
M__\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^]?[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7___________________\`
M``#_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________________
M_____________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?__________
M_________P````#_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________])!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#___________________________________\5
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^]?[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7__________________P```/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________`/__________________________
M__\`____________________________________________20<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P#_____________________________________%>_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5______________\`````________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________________________
M______\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^]?
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_______________\`
M``#_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________%>_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[U_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^\5_____________P````#_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P#_____________________________`/__
M_________________________________________TD'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<`_____________________________________Q7O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O%?__________````____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_____________________________________
M%>_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[U_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5____________````________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/___________________________________Q7O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O%?________\```#_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\`_____________________________P#_________
M__________________________________])!P<'!P<'!P<'!P<'!P<'!P<'
M!P<'`/___________________________________P`5[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[Q7______P```/______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`____________________________________`!7O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?______`````/__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#_________________________________```5[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[Q7_____````____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`/____________________________\`________________
M____________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_
M______________________________\```#_%>_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^\5_P````#_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<'!P<'`/_______________________________P```/\5[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[Q7__P```/______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M________________________`````/__%>_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^\5`````/______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P#_____________________________`/______________________
M_____________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________
M__________________\`````_____Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O7^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O``#_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P<'!P<'!P<'!P<'
M!P#___________________________\```#_____%>_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^\```#_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M_____________P```/_______Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O7^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M%?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\`
M_____________________________P#_____________________________
M______________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/______________
M________````__________\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M7^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`____
M____________________````_________Q7O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O%?__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'!P#_________________
M__\```#___________\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________`/______
M______________________\`____________________________________
M________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#__________________P``
M`/______________%>_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O
M[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________
M________`````/____________\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^]?[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[Q7_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'!P<'!P<'!P<'!P<'!P<'!P<`________________````____
M____________%>_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P#_____________
M________________`/__________________________________________
M_TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`_____________P````#_________
M_________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O
M[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P<'!P<'!P<'!P<'!P<'!P<'!P#______________P``
M`/__________________%>_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/__________`````/______________
M_____Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\`____________________
M_________P#___________________________________________])!P<'
M!P<'!P<'!P<'!P<'!P<'!P<'`/________\```#_____________________
M__\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O
M[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD'!P<'!P<'!P<'!P<'!P<'!P<'!P<`__________\```#_________
M_____________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________])!P<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#______P```/________________________\5
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^]?
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________`/__________________________
M__\`____________________________________________20<'!P<'!P<'
M!P<'!P<'!P<'!P<'!P#_____````____________________________%>_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________])
M!P<'!P<'!P<'!P<'!P<'!P<'!P<'`/____\`````____________________
M______\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________20<'!P<'!P<'!P<'
M!P<'!P<'!P<'!P<`__\```#_____________________________%>_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^\5________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P#_____________________________`/__
M_________________________________________TD'!P<'!P<'!P<'!P<'
M!P<'!P<'!P<``````/_______________________________Q7O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O%?__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________20<'!P<'
M!P<'!P<'!P<'!P<'!P<'!P#_````________________________________
M%>_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________TD'!P<'!P<'!P<'!P<'!P<'
M!P<'!P<`````_________________________________Q7O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O%?______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\`_____________________________P#_________
M__________________________________])!P<'!P<'!P<'!P<'!P<'!P<'
M!P```/____________________________________\5[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[Q7_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________TD'!P<'!P<'!P<'
M!P<'!P<'!P<'!P```/___________________________________Q7O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________])!P<'!P<'!P<'!P<'!P<'!P<'````
M______________________________________\5[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[Q7_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`/____________________________\`________________
M____________________________20<'!P<'!P<'!P<'!P<'!P<```#_____
M____________________________________%>_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^\5________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________])!P<'!P<'!P<'!P<'!P<'
M!P<```#_______________________________________\5[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[Q7_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________20<'!P<'!P<'!P<'!P<'!P```/__________
M________________________________%>_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^\5____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P#_____________________________`/______________________
M_____________________TD'!P<'!P<'!P<'!P<'````________________
M_____________________________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O%?______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________20<'!P<'!P<'!P<'!P<`````____
M________________________________________%>_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^\5____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________TD'!P<'!P<'!P<'!P<```#_____________________
M_________________________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M%?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\`
M_____________________________P#_____________________________
M______________])!P<'!P<'!P<'`````/__________________________
M______________________\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________TD'!P<'!P<'!P<'````________________
M_________________________________Q7O[^_O[^_O[^_O[^_O[^_O[^_O
M[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O%?__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________])!P<'!P<'!P<`````________________________________
M__________________\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________`/______
M______________________\`____________________________________
M________20<'!P<'!P```/______________________________________
M________________%>_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________])!P<'!P<'!P```/__________________________
M__________________________\5[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[Q7_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____20<'!P<'````____________________________________________
M____________%>_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P#_____________
M________________`/__________________________________________
M_TD'!P<```#_________________________________________________
M_________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O%?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________20<'!P````#_____________________________________
M____________________%>_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^\5____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________TD'
M!P```/______________________________________________________
M_____Q7O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O%?__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\`____________________
M_________P#___________________________________________\`````
M____________________________________________________________
M__\5[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[Q7_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____TD```#_________________________________________________
M_____________Q7O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O%?__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________P````#_____
M__________________________________________________________\5
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[Q7_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________`/__________________________
M__\`________________________________________````____________
M________________________________________________________%>_O
M[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^\5____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________````
M____________________________________________________________
M______\5[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[Q7_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\```#_________________
M____________________________________________________%>_O[^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M7^_O[^_O[^_O[^_O[^_O[^_O[^\5________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P#_____________________________`/__
M_________________________________P```/______________________
M_________________________________________________Q7O[^_O[^_O
M[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O
M[^_O[^_O[^_O[^_O[^_O[^_O%?__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P```/__________
M____________________________________________________________
M%>_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^\5________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________````____________________________
M_____________________________________________Q7O[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O
M[^_O[^_O[^_O[^_O[^_O%?______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\`_____________________________P#_________
M______________________\```#_________________________________
M__________________________________________\5[^_O[^_O[^_O[^_O
M[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O
M[^_O[^_O[^_O[^_O[Q7_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________P````#_____________________
M_____________________________________________________Q7O[^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^]?[^_O[^_O[^_O[^_O[^_O[^_O%?______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________P```/______________________________________
M______________________________________\5[^_O[^_O[^_O[^_O[^_O
M[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[Q7_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`/____________________________\`________________
M__________\`````____________________________________________
M____________________________________%>_O[^_O[^_O[^_O[^_O[^_O
M7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O
M[^_O[^_O[^\5________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________\```#_________________________________
M______________________________________________\5[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[Q7_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P````#_________________________________________________
M________________________________%>_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O
M[^_O[^\5____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P#_____________________________`/______________________
M````________________________________________________________
M_____________________________Q7O[^_O[^_O[^_O[^_O[^_O7^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O
M[^_O%?______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________````____________________________________________
M________________________________________%>_O[^_O[^_O[^_O[^_O
M[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O
M[^_O[^_O[^_O[^\5____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\```#_
M____________________________________________________________
M_________________________Q7O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O
M%?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\`
M_____________________________P#__________________P```/______
M____________________________________________________________
M______________________\5[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[Q7_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M`````/______________________________________________________
M_________________________________Q7O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O
M[^_O[^_O%?__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________````____________
M____________________________________________________________
M__________________\5[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[Q7_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________`/______
M______________________\`_____________P````#_________________
M____________________________________________________________
M________________%>_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^\5________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________P```/______
M____________________________________________________________
M__________________________\5[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O
M[Q7_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________`````/______________________
M____________________________________________________________
M____________%>_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^\5____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P#_____________
M________________`/________\```#_____________________________
M____________________________________________________________
M_________Q7O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O%?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\```#_________________
M____________________________________________________________
M____________________%>_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^\5____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P```/__________________________________
M____________________________________________________________
M_____Q7O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O%?__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\`____________________
M_________P#_____````________________________________________
M____________________________________________________________
M```5[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[Q7_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________````____________________________
M____________________________________________________________
M____________`!7O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^_O%?__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________\```#_____________________________________________
M______________________________________________________\````5
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[Q7_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________`/__________________________
M__\`_P```/__________________________________________________
M_________________________________________________P```/__%>_O
M[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^\5____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M________________`````/______________________________________
M____________________________________________________________
M`````/\5[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[Q7_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M````________________________________________________________
M____________________________________________````____%>_O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O7^_O[^_O[^_O[^_O[^\5________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P#__________________________P````#_
M____________________________________________________________
M_____________________________________P````#______Q7O[^_O[^_O
M[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[U_O[^_O[^_O[^_O[^_O%?__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M_____P```/__________________________________________________
M_________________________________________________P```/______
M%>_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O[^\5________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________`````/______
M____________________________________________________________
M________________________________`````/_______Q7O[^_O[^_O[^_O
M[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[U_O[^_O[^_O[^_O[^_O%?______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\`______________________\```#_____________
M____________________________________________________________
M__________________________\```#___________\5[^_O[^_O[^_O[^_O
M7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M7^_O[^_O[^_O[^_O[Q7_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M______________________________________________________\```#_
M____________________________________________________________
M______________________________________\```#__________Q7O[^_O
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[U_O[^_O[^_O[^_O[^_O%?______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________P```/__________________
M____________________________________________________________
M_____________________P```/____________\5[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[Q7_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`/__________________````________________________
M____________________________________________________________
M________________````________________%>_O[^_O[^_O[^_O7^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O
M[^_O[^_O[^\5________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M__________________________________________\`````____________
M____________________________________________________________
M__________________________\`````______________\5[^_O[^_O[^_O
M[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O7^_O[^_O[^_O[^_O[Q7_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________\```#_____________________________
M____________________________________________________________
M__________\```#_________________%>_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O
M[^_O[^\5____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P#_____________`````/__________________________________
M____________________________________________________________
M____`````/___________________Q7O[^_O[^_O[^_O[U_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O%?______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M________________________________````________________________
M____________________________________________________________
M________________````____________________%>_O[^_O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?
M[^_O[^_O[^_O[^\5____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\`````________________________________________
M__________________________________________________________\`
M````_____________________Q7O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^_O
M%?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\`
M_________P```/______________________________________________
M_____________________________________________________P```/__
M______________________\5[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^_O[Q7_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M_____________________P```/__________________________________
M____________________________________________________________
M_____P```/_______________________Q7O[^_O[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O
M[^_O[^_O%?__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____````____________________________________________________
M________________________________________________````________
M__________________\5[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O[Q7_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________`/____\`
M``#_________________________________________________________
M__________________________________________\```#_____________
M________________%>_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[^\5________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M__________\```#_____________________________________________
M_____________________________________________________P````#_
M__________________________\5[^_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O
M[Q7_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________P```/__
M____________________________________________________________
M_____________________________________P```/__________________
M____________%>_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^\5____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P#_````________
M____________________________________________________________
M________________________________````________________________
M_________Q7O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O%?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M__________________________________________________________\`
M````________________________________________________________
M__________________________________________\```#_____________
M____________________%>_O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[^\5____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________\```#_____________
M____________________________________________________________
M_________________________P````#_____________________________
M_____Q7O[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O%?__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________`````/__________________
M____________________________________________________________
M____________________`````/__________________________________
M__\5[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O[^_O[Q7_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M________________________________________________````________
M____________________________________________________________
M________________________________````________________________
M_____________Q7O[^_O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^_O%?__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________\`````________________________
M____________________________________________________________
M______________\```#_______________________________________\5
M[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[Q7_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P```/______________________________
M____________________________________________________________
M_________P```/__________________________________________%>_O
M[^_O[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^\5____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M_____________________________________P```/__________________
M____________________________________________________________
M_____________________P```/__________________________________
M______\5[^_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[^_O[Q7_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________````____________________________________
M____________________________________________________________
M____````____________________________________________%>_O[^_O
M[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^]?[^_O[^_O[^\5________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\```#_________________________________________
M__________________________________________________________\`
M``#______________________________________________Q7O[^_O[^_O
M7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[U_O[^_O[^_O%?__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M_________________________P````#_____________________________
M____________________________________________________________
M_________P````#_____________________________________________
M%>_O[^_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^]?[^_O[^_O[^\5________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________P```/______________________________________________
M_____________________________________________________P```/__
M_____________________________________________Q7O[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[U_O[^_O[^_O%?______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__\`````____________________________________________________
M______________________________________________\`````________
M__________________________________________\5[^_O[^_O7^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^]?[^_O[^_O[Q7_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M______________\```#_________________________________________
M__________________________________________________________\`
M``#__________________________________________________Q7O[^_O
M[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[U_O[^_O[^_O%?______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________P``
M``#_________________________________________________________
M_________________________________________P````#_____________
M______________________________________\5[^_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O7^_O[^_O[Q7_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________````____
M____________________________________________________________
M____________________________________````____________________
M____________________________________%>_O[^_O[U_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[U_O[^_O[^\5________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____````____________________________________________________
M________________________________________________````________
M______________________________________________\5[^_O[^_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O7^_O[^_O[Q7_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________\```#_________
M____________________________________________________________
M______________________________\```#_________________________
M________________________________%>_O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O
M[^_O[^\5____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________`/___________________P```/______________
M____________________________________________________________
M_________________________P```/______________________________
M_____________________________Q7O[^_O[U_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O
M[^_O%?______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M______________________________\`____________________`````/__
M____________________________________________________________
M____________________________________`````/__________________
M________________________________________%>_O[^_O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[U_O[^_O[^\5____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________`/__________________````____________________
M____________________________________________________________
M____________________````____________________________________
M_________________________Q7O[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^_O
M%?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________P#_______________\```#_________________________
M____________________________________________________________
M_____________P````#_________________________________________
M______________________\5[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O[Q7_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M________________________`/_______________P```/______________
M____________________________________________________________
M_________________________P```/______________________________
M_________________________________Q7O[^_O[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M7^_O[^_O%?__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________P#______________P```/______________________________
M____________________________________________________________
M________`````/______________________________________________
M__________________\5[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O[Q7_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______\`__________\`````____________________________________
M____________________________________________________________
M__\```#_____________________________________________________
M________________%>_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^\5________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M_________________P#___________\```#_________________________
M____________________________________________________________
M______________\```#_________________________________________
M__________________________\5[^_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O
M[Q7_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__\`_________P````#_________________________________________
M_________________________________________________________P``
M`/__________________________________________________________
M____________%>_O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^\5____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M`/______````________________________________________________
M____________________________________________________````____
M____________________________________________________________
M_________Q7O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[U_O[^_O%?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M__________\`________````____________________________________
M____________________________________________________________
M____````____________________________________________________
M____________________%>_O[U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[^\5____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________`/__
M__\```#_____________________________________________________
M______________________________________________\```#_________
M____________________________________________________________
M_____Q7O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O%?__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________P#__P``
M`/__________________________________________________________
M_________________________________________P```/______________
M____________________________________________________________
M__\5[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[Q7_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____`/__`````/______________________________________________
M____________________________________________________`````/__
M____________________________________________________________
M_____________Q7O[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^_O%?__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________P#_````____
M____________________________________________________________
M____________________________________````____________________
M__________________________________________________________\5
M[^_O7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[Q7_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________\```#_________
M____________________________________________________________
M_____________________________P````#_________________________
M________________________________________________________%>_O
M7^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^\5____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M_________________________________________________________P``
M`/__________________________________________________________
M_________________________________________P```/______________
M____________________________________________________________
M______\5[^]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O7^_O[Q7_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________\``/______________
M____________________________________________________________
M________________________`````/______________________________
M____________________________________________________%>_O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^]?[^\5________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________`/__________________
M____________________________________________________________
M__________________\```#_____________________________________
M_________________________________________________Q7O7^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O7^_O%?__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M__________________________________________________\`________
M____________________________________________________________
M______________________________\```#_________________________
M____________________________________________________________
M%>]?[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^]?[^\5________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________`/______________________
M____________________________________________________________
M_____________P```/__________________________________________
M_____________________________________________Q7O7^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[U_O%?______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________P#_________________________
M____________________________________________________________
M________````________________________________________________
M__________________________________________\5[U_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^]?[Q7_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________`/______________
M____________________________________________________________
M__________________\`````____________________________________
M_____________________________________________________Q7O7^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[U_O%?______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________P#_____________________________
M____________________________________________________________
M__\```#_____________________________________________________
M______________________________________\5[U_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^]?[Q7_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________\`________________________________
M________________________________________________________````
M`/__________________________________________________________
M____________________________________%5_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O7^\5________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M_____________________________________P#_____________________
M____________________________________________________________
M________````________________________________________________
M______________________________________________\57^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^]?[Q7_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________\`____________________________________
M__________________________________________________\`````____
M____________________________________________________________
M________________________________%5_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[U\5____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________`/______________________________________
M_____________________________________________P```/__________
M____________________________________________________________
M_____________________________U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^]?%?______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M______________________________\`____________________________
M_________________________________________________________P``
M`/__________________________________________________________
M________________________________________%5_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[U\5____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________`/__________________________________________
M________________________________________````________________
M____________________________________________________________
M_________________________U_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O[^_O
M%?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________P#_____________________________________________
M__________________________________\```#_____________________
M____________________________________________________________
M______________________]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?
M7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M________________________`/__________________________________
M______________________________________________\```#_________
M____________________________________________________________
M_________________________________U]?7U]?7U]?7U]?7U]?7U]?7U]?
M7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?
M7U]?7U]?%?__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________P#_________________________________________________
M_____________________________P```/__________________________
M____________________________________________________________
M__________________]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?
M7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U]?7U______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______\`____________________________________________________
M________________________````________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M_________________P#_________________________________________
M__________________________________\`````____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__\`________________________________________________________
M__________________\```#_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M`/__________________________________________________________
M____________`````/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M__________\`________________________________________________
M________________________````________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________`/__
M____________________________________________________________
M______\`````________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________`/______
M____________________________________________________________
M_P```/______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M__\``/______________________________________________________
M_____________P```/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________`/__________
M________________________________________________________````
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________\``/______________
M__________________________________________________\```#_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M______________________________________________________\`____
M____________________________________________________________
M_P````#_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\``/__________________
M_____________________________________________P```/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\`________________________
M______________________________________\`````________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M_____________________________________________P``____________
M__________________________________________________\```#_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________\`____________________________
M_________________________________P````#_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________````____________________________
M____________________________````____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M______________________________________\``/__________________
M________________________________________````________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P```/______________________________
M______________________\```#_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P``________________________________
M_________________P```/______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M__________________________________\```#_____________________
M_____________________________P```/__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________\``/__________________________________
M____________````____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P```/__________________________________
M______\```#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M________________________________``#_________________________
M_________________P````#_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\``/______________________________________
M_P```/______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________`/____________________________________\`````
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________`/______________________________
M______\```#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`/___________________________________P````#_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________`/__________________________________````____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________`/__________________________________````
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____`/________________________________\```#_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M`/_______________________________P```/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M__________\``/______________________________`````/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________`/__
M____________________________````____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________P#_____
M_____________________P````#_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____`/___________________________P```/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________P#_________
M________________`````/______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________\`____________
M__________\```#_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M_________________________________________________________P#_
M______________________\```#_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________\`________________
M_____P```/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________`/__________________
M````________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M__________________________________________________\`________
M____________````____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________`/________________\```#_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________P#______________P```/______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________`/______________
M`````/______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________P#_____________````____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________\`_________P````#_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M_____________________________________P#__________P```/______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________\`________`````/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________`/____\```#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M______________________________\`______\```#_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________`/___P```/__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________P#_````________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M________________________`/\`````____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________P````#_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______\``/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M_________________P``________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__\`________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M`/__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M__________\`________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________`/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________P#_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____`/______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________P#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________\`____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M_________________________________________________________P#_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________\`________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________`/__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M__________________________________________________\`________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________`/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________````________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________````````````````````________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P```````````/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P```/______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__\``````````````````/______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________P``
M````````````________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\```#_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________````
M``````````````#_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________\`````____
M`````/______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________````____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________P````#_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________````______\`````
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P```/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________`````/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________`````/_______P```/______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\`
M``#_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\`````________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________P```/________\`````____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________````____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________P``````____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________`````/__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P```/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``````#_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________`````/__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\```#_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________\``````/______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________``````#_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________````________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________P``````____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________P````````#_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P```/______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________``````#_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__\```````#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\```#_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______\`````________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________````
M````________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________````____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P````#_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________P````#_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\`
M_____P```/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\`````
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________````________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________````__\`
M``#_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________````_________P```/______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________P````#______P````#_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________P``````````____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________P````#_______\```#_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________\`````______\`````____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\``````````/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________````______\`````____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________P```/______````____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\```````#_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________P``````__\`````____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`````````````/__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________\`````________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________`````````````/__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____P```````````/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________P```/______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______\``````````/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P```````/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\```#_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____``#_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________P``________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\``/______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________``#_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________P``____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\``/__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________``#_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_P``________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\``/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________``#_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
A_________________________________________P``





















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
        <int nm="BreakPoint" vl="836" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24281: Set name and grade at created beams" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="35" />
      <str nm="DATE" vl="7/15/2025 9:08:40 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-21189: Include beams at the wall envelope" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="34" />
      <str nm="DATE" vl="1/23/2024 1:34:14 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17747: Replace &quot;T-Einfräsung&quot; with &quot;T-Connection&quot;" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="33" />
      <str nm="DATE" vl="2/2/2023 8:49:56 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17096: Fix catalog for &quot;T-Einfräsung&quot;" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="32" />
      <str nm="DATE" vl="11/18/2022 9:21:12 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16751: Add property to control Stud-Plate milling" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="31" />
      <str nm="DATE" vl="10/11/2022 8:58:58 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End