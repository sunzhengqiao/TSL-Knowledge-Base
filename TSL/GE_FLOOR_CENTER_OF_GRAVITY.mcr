#Version 8
#BeginDescription
V1.4__28/Apr/2020__DR__- Issue hanging system forcing to restart solved
- Added support for non rectangular elements
- User will be warned if a panel could not be set with lift holes 
- Added custom action: "Remove holes and leave"
- Holes will be relocated when Length Factor is changed
V1.3__9/13/2019__Standartized sorting method
V1.2__09_Sept_2019__Will not take truss/beam that is not reaching past midpoint
V1.1__05_Sept_2019__Will not place holes close to sheathing overlap
V1.0__04_Sept_2019__Will create lifting holes alligned relative to each other
V0.9__03_Sep_2019__Will avoid truss steel plates
V0.8__02_Aug_2019__Supports trusses
V0.7__1October2018__Changed default length factor from 1/3 to 1/2
V0.6__29May2018__Changed default lifting point hole
V0.5__19Feb2018__Centers the point of gravity based on all vertices
V0.4__20April2015__Will insert proper lift holes
V0.3__17July2014__Corrected the 1/4 and 1/3 offsets. Changed the defualt holes inserted
V0.2__11July2014__Will insert lift holes






















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
	Unit(1,"inch");
	int iDebug = false; // debug toggle

//__Define weights
	String arStMat[0];
	double arDWeight[0];//lbs/ft3 or whatever you would like, just dont mix systems
	
	//add lines by material type, All UPPERCASE
	//each material, name, and grade field will be compared. Beams will also have the extrusion profile name compared
	arStMat.append("HSBBEAM");arDWeight.append(50);//default for wood
	arStMat.append("HSBSEET");arDWeight.append(38);//default for sheet
	

//__Define properties
	String arYN[]={"Yes","No"};
	String arStShow[]={"1/2 Length In","1/4 Length In","1/3 Length In"};
	double arDMultiply[]={.5,.25,.333};
	
	PropString psCircleInBy(0,arStShow,"Length Factor",0);
	PropString psShowCirscle(1,arYN,"Show Circle",1);

//__bOnInsert
	if (_bOnInsert){
		
		//showDialogOnce("_Default");
		PrEntity ssE("\nSelect a set of elements",Element());
				if (ssE.go())
				{
					Entity ents[0]; 
					ents = ssE.set(); 
					// turn the selected set into an array of elements
					for (int i=0; i<ents.length(); i++)
					{
						if (ents[i].bIsKindOf(ElementRoof()))
						{
							_Element.append((Element) ents[i]);
							
						
						}
					}
				}
		
		//PREPARE TO CLONING
		// declare tsl props 
		TslInst tsl;
		String sScriptName = scriptName();
	
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[1];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
			
		for(int i=0; i<_Element.length();i++){
			lstEnts[0] = _Element[i];
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
		}
		eraseInstance();
		return;	
		
	}//END if (_bOnInsert)

//__Security
	//Check if there are elements selected. If not erase instance and return to drawing.
	if(_Element.length()==0){
		reportMessage("\nNo Element Found");
		eraseInstance(); return;}
	
	//Assign selected element to el.
	Element el = _Element[0];
	
	//make sure only one is added per element
	TslInst tslElAll[] = el.tslInstAttached();
	for ( int i = tslElAll.length()-1; i > -1 ; i--){
		if ( tslElAll[i].scriptName() == scriptName() && tslElAll[i] != _ThisInst)
		{	
			Map mpHoles = tslElAll[i].map().getMap("mpHoles");
			for(int m=0;m<mpHoles.length();m++)
			{
				Entity ent = mpHoles.getEntity(m);
				if(ent.bIsValid()) ent.dbErase();
			}

			tslElAll[i].dbErase();
		}
	}
	
	
	_Pt0 = el.ptOrg();
	assignToElementGroup(el, TRUE, 0, 'Z');
	setDependencyOnEntity(_Element[0]);

//__Define a datum and total values
	Point3d ptDatum = el.ptOrg();
	double dTotalWeight=0;
	double dTMomentX=U(0), dTMomentY=U(0), dTMomentZ=U(0);

//__Get weight of each object
	Point3d arPtItems[0];
	double arDItemWieight[0];
	double arDItemDistX[0], arDItemDistY[0], arDItemDistZ[0];
	double arDMomentX[0], arDMomentY[0], arDMomentZ[0];
	
//__Collect data to find extents of Element
	Point3d arPtBds[0];
	
//__Loop over each genbeam
	Group elG = el.elementGroup();
	Entity arGb[] = elG.collectEntities(true, Beam(), _kModelSpace);
	arGb.append(elG.collectEntities(true, TrussEntity(), _kModelSpace));
	arGb.append(elG.collectEntities(true, Sheet(), _kModelSpace));
	Body bdAll[0];
	Entity BmNtruss[0];
	Quader qdBmNtruss[0];
	Sheet sheets[0];
	for (int i=0; i<arGb.length(); i++)
	{
		if (arGb[i].bIsKindOf(GenBeam())) 
			{
				GenBeam gbmQ = (GenBeam) arGb[i];
				bdAll.append(gbmQ.realBody());
				Beam bm = (Beam) arGb[i];
				if (bm.bIsValid())
				{
					BmNtruss.append(arGb[i]);
					qdBmNtruss.append(bm.quader());
				}
			}
			else if (arGb[i].bIsKindOf(TrussEntity()))
			{
				TrussEntity te = (TrussEntity) arGb[i];
				TrussDefinition td = te.definition();
				Map mp = td.subMapX("Content");
				double sizes[] = { mp.getVector3d("Length").length(), mp.getVector3d("Width").length(), mp.getVector3d("Height").length()};
				CoordSys csT = te.coordSys();
				Body bdT(csT.ptOrg() + 0.5*sizes[0]*csT.vecX() + 0.5*sizes[2]*csT.vecZ(), csT.vecX(), csT.vecY(), csT.vecZ(), sizes[0], sizes[1], sizes[2], 0, 0, 0);			
				bdAll.append(bdT);
				BmNtruss.append(arGb[i]);
				qdBmNtruss.append(Quader(csT.ptOrg() + 0.5 * sizes[0] * csT.vecX() + 0.5 * sizes[2] * csT.vecZ(), csT.vecX(), csT.vecY(), csT.vecZ(), sizes[0], sizes[1], sizes[2], 0, 0, 0));
			}
	}		
	int iItemsIgnored=0;
	
	for(int i=arGb.length()-1; i>-1; i--)
	{
		GenBeam gb = (GenBeam) arGb[i];
		//__Remove unwanted items
		if (gb.bIsValid())
		{		
			if (gb.bIsDummy() || gb.information().makeUpper().find("LOOSE", 0) > - 1 )
			{
				iItemsIgnored++;
				arGb.removeAt(i);
				continue;
			}
		}
		
		Body bd=bdAll[i];
//		bd.vis(i);
		
		if(gb.bIsKindOf(Sheet()))
			sheets.append((Sheet)gb);
		Point3d arPtV[] = bd.allVertices();
		
		if (arPtV.length() == 0)continue;
		
		Point3d pt = bd.ptCen();//center of mass of a body
		pt.setToAverage(arPtV);
//		pt.vis(i);
		
		arPtBds.append(bd.allVertices());
		
		String stName = gb.bIsValid() ? gb.name().makeUpper() : "";
		String stMat = gb.bIsValid() ? gb.material().makeUpper() : "";
		String stGrade = gb.bIsValid() ? gb.grade().makeUpper() : "";
		
		//__Try to get material ID
		int iMatId = arStMat.find(stMat);
		if(iMatId == -1)iMatId = arStMat.find(stName);
		if(iMatId == -1)iMatId = arStMat.find(stGrade);
		if(iMatId == -1 )
		{
			if (gb.bIsValid() && gb.bIsKindOf(Beam()))
			{
				Beam bm = (Beam)gb;
				iMatId = arStMat.find(bm.extrProfile().makeUpper());
			}			
		}
		
		
		double dWeight=0;
		
		if(iMatId > -1)dWeight = arDWeight[iMatId];
		else if (gb.bIsValid())
		{
			if(gb.bIsKindOf(Beam())) dWeight = arDWeight[0];	
			else if(gb.bIsKindOf(Sheet())) dWeight = arDWeight[1];			
		}
		else if (!gb.bIsValid()) 
		{
			dWeight = arDWeight[0];
		}
		else
		{
			iItemsIgnored++;
			arGb.removeAt(i);
			continue;
		}
		
		dWeight *= (bd.volume()/1728);//Per foot
		
		arPtItems.append(pt);
		arDItemWieight.append(dWeight);
		dTotalWeight += dWeight;
		
		double dx=pt.X()-ptDatum.X();
		double dy=pt.Y()-ptDatum.Y();
		double dz=pt.Z()-ptDatum.Z();
		
		//__Distances
		arDItemDistX.append(dx);
		arDItemDistY.append(dy);
		arDItemDistZ.append(dz);
		
		//__Moments
		arDMomentX.append(dx*dWeight);
		arDMomentY.append(dy*dWeight);
		arDMomentZ.append(dz*dWeight);
		
		dTMomentX += dx*dWeight;
		dTMomentY += dy*dWeight;
		dTMomentZ += dz*dWeight;
	}

//__Do nothing if invalid
	if(arGb.length() == 0 || arPtBds.length() == 0)return;


//__position the new datum	
	ptDatum.transformBy(_XW * dTMomentX/dTotalWeight);
	ptDatum.transformBy(_YW * dTMomentY/dTotalWeight);
	ptDatum.transformBy(_ZW * dTMomentZ/dTotalWeight);



//Draw the center of gravity
	Display dp(7),dpLay(1);
	dp.textHeight(U(3));
	dpLay.textHeight(U(3));
	dpLay.showInDispRep("LayoutDisplay");
	dp.draw("CG",ptDatum,_XW,_YW,1.5,1.5);
	dpLay.draw("CG",ptDatum,_XW,_YW,1.5,1.5,_kDevice);
	
	PLine pl1(ptDatum+U(2)*_XW,ptDatum-U(2)*_XW),pl2(ptDatum+U(2)*_YW,ptDatum-U(2)*_YW);
	dp.draw(pl1);
	dp.draw(pl2);
	dpLay.draw(pl1);
	dpLay.draw(pl2);

//__Show circle for hole placement
	double dFactor = arDMultiply[arStShow.find(psCircleInBy)];
	if(psShowCirscle == arYN[0] || iDebug)
	{
		double dElW = U(0), dElL=U(0);
		arPtBds=Line(_Pt0,el.vecX()).orderPoints(arPtBds);
		dElW = el.vecX().dotProduct(arPtBds[arPtBds.length()-1]-arPtBds[0]);
		arPtBds=Line(_Pt0,el.vecY()).orderPoints(arPtBds);
		dElL = el.vecY().dotProduct(arPtBds[arPtBds.length()-1]-arPtBds[0]);
		
		double dMax=dElW<dElL?dElL:dElW;
		
		dMax -= dMax*dFactor;
		
		PLine plC;
		plC.createCircle(ptDatum,el.vecZ(),dMax/2);
		dp.draw(plC);
		
	}

//__Add data to the map for dxf Export
	Map mpDxf;
	mpDxf.appendPLine("plDxf",pl1);
	mpDxf.appendPLine("plDxf",pl2);	
	Map mpText;
	mpText.setString("stText","CG");
	mpText.setPoint3d("ptText",ptDatum);
	mpText.setVector3d("vxText",_XW);
	mpText.setVector3d("vyText",_YW);
	mpText.setInt("iFlagXText",2);
	mpText.setInt("iFlagYText",2);

	mpDxf.appendMap("mpText",mpText);
	_Map.setMap("mpDxf",mpDxf);	


//__Insertion of lift holes
		Body bdHole[0];
		Body bdSteel[0];
		Sheet arSh1[] = el.sheet(1);
		PlaneProfile ppSheetGaps[0];
		if (arSh1.length()>1)
		{
			String arSheets[0];
			for (int i=0; i<arSh1.length(); i++) { arSheets.append(String().format("%09.4f", (arSh1[i].profShape().extentInDir(el.vecY()).ptMid() - (el.ptOrg() - U(5000)*el.vecY())).dotProduct(el.vecY())) + "@" + i );}
			String arSheetsSorted[] = arSheets.sorted();
			for (int i=1; i<arSheetsSorted.length(); i++) 
			{
				 if (PlaneProfile(arSh1[arSheetsSorted[i].token(1, "@").atoi()].profShape()).intersectWith(PlaneProfile(arSh1[arSheetsSorted[i-1].token(1, "@").atoi()].profShape()))) 
				 {
				 	PlaneProfile ppA(arSh1[arSheetsSorted[i].token(1, "@").atoi()].profShape());
				 	PlaneProfile ppB(PlaneProfile(arSh1[arSheetsSorted[i - 1].token(1, "@").atoi()].profShape()));
				 	ppA.intersectWith(ppB);	
				 	Point3d ptGrips[] = ppA.getGripEdgeMidPoints();
				 	Point3d ptsSorted[] = Line(ppA.extentInDir(el.vecY()).ptMid(), el.vecY()).orderPoints(ptGrips);
				 	double dGapWidth = abs((ppA.extentInDir(el.vecY()).ptStart() - ppA.extentInDir(el.vecY()).ptEnd()).dotProduct(el.vecY()));
				 	ppA.moveGripEdgeMidPointAt(ptGrips.find(ptsSorted.first()), - (U(2) - 0.5 * dGapWidth) * el.vecY());
				 	ppA.moveGripEdgeMidPointAt(ptGrips.find(ptsSorted.last()), (U(2) - 0.5 * dGapWidth) * el.vecY());
				 	ppSheetGaps.append(ppA);
				 }
			}
		}
		
	//Create a trigger
	String stAddHole = "Insert Lift holes";
	addRecalcTrigger(_kContext, stAddHole);

	// TriggerRemoveHoleAndLeave
	String sTriggerRemoveHolesAndLeave = T("|Remove Holes And Leave|");
	addRecalcTrigger(_kContext, sTriggerRemoveHolesAndLeave );
	
	if(_bOnDbCreated || _kExecuteKey == stAddHole || _kExecuteKey==sTriggerRemoveHolesAndLeave || _kNameLastChangedProp == _ThisInst.propStringName(0) || iDebug)
	{
		//__Remove existing
		Map mpHoles = _Map.getMap("mpHoles");
		for(int m=0;m<mpHoles.length();m++)
		{
			Entity ent = mpHoles.getEntity(m);
			if(ent.bIsValid()) ent.dbErase();
		}
		_Map.removeAt("mpHoles", TRUE);
		
		if(_kExecuteKey==sTriggerRemoveHolesAndLeave)
		{ 
			eraseInstance();
			return;
		}
	
		double dMinDistFromEdge = U(10);
		
		LineSeg arLs[0];
		
		double dElW = U(0), dElL=U(0);
		arPtBds=Line(_Pt0,el.vecY()).orderPoints(arPtBds);
		dElL = el.vecY().dotProduct(arPtBds[arPtBds.length()-1]-arPtBds[0]);
		arPtBds=Line(_Pt0,el.vecX()).orderPoints(arPtBds);
		dElW = el.vecX().dotProduct(arPtBds[arPtBds.length()-1]-arPtBds[0]);
		
		double dMax = dElL - dElL*dFactor;
		
		//Create 2 lines
		arLs.append(LineSeg(ptDatum + dMax/2 * el.vecY()+ el.vecX()*dElW , ptDatum + dMax/2 * el.vecY()- el.vecX()*dElW ));
		arLs.append(LineSeg(ptDatum - dMax/2 * el.vecY()+ el.vecX()*dElW , ptDatum - dMax/2 * el.vecY()- el.vecX()*dElW ));
		//get the points
		Point3d arPtLift[0];
		int bIsTouchingPlate = true;
		int iLsQty = arLs.length();
				
		int nSafeLock; // this could be infinite while trying to find a good spot
		for(int i=0;i<iLsQty;i++)
		{
			nSafeLock++; 
			if (nSafeLock > 500.0) // couldn't' find proper locations at this point
			{
				reportNotice("\n" + scriptName() + T(" - |ERROR on element| " ) + el.code() + "-" + el.number() + T(": |Lifting points cannot be defined automatically|.")+T("|Tool will be deleted|.\n"));
				eraseInstance();
				return;				
			} 
			
			Entity entUse[0];			
			Quader qdUse[0];
			Vector3d vcLs = arLs[i].ptEnd() - arLs[i].ptStart();
			Body bdCapsule((arLs[i].ptStart() + arLs[i].ptEnd()) / 2, el.vecX(), el.vecY(), el.vecZ(), U(300), U(.5), U(50));
			String arXdir[0];
			Point3d ptCurrentVertexes[0]; 
			
			for (int j=0; j<qdBmNtruss.length(); j++)
			{				 
				Quader qdJ = qdBmNtruss[j];
				Body bdQdr = Body(qdJ);
				if (abs(qdJ.vecX().dotProduct(el.vecX())) < 0.001 && abs(qdJ.vecX().dotProduct(el.vecZ())) < 0.001 && // quader is perpendicular to el.vecX() and el.vecZ()
					bdCapsule.hasIntersection(bdQdr)) 
				{
					arXdir.append(String().format("%09.4f", (qdJ.ptOrg() - (el.ptOrg() - U(5000) * el.vecX())).dotProduct(el.vecX())) + "@" + j);
					ptCurrentVertexes.append(bdQdr.allVertices());
				}
				
				for (int s = 0; s < sheets.length(); s++)
				{
					Sheet sheet = sheets[s];
					Body bdSheet = sheet.realBody();
					if (bdSheet.intersectWith(bdCapsule))
					{
//						bdSheet.vis(56);
						ptCurrentVertexes.append(bdSheet.allVertices());
					}//next s
				}
			}
			String arXdirSorted[] = arXdir.sorted();
			for (int k=0; k<arXdirSorted.length(); k++) 
			{
				qdUse.append(qdBmNtruss[arXdirSorted[k].token(1, "@").atoi()]);
				entUse.append(BmNtruss[arXdirSorted[k].token(1, "@").atoi()]);
			}
			
			//remove thos that are joined
			for (int q=qdUse.length()-1; q>=1 ; q--) 
			{ 
				Quader qdrCurrent=qdUse[q]; 
				Quader qdrNext = qdUse[q - 1];
				
				if(abs(el.vecX().dotProduct(qdrCurrent.ptOrg()-qdrNext.ptOrg()))< qdrCurrent.dD(el.vecX()) + qdrNext.dD(el.vecX()) + U(.001))
				{ 
					qdUse.removeAt(q);
					qdUse.removeAt(q - 1);
					entUse.removeAt(q);
					entUse.removeAt(q - 1);
					q=q-2;
				}
				
			}//next q
			
			Body bdTsl[0];			
			Quader qdLift[0];
			Vector3d vcCompare = arLs[i].ptMid() - Line(arLs[i].ptMid(), el.vecY()).closestPointTo(ptDatum);	
			vcCompare.normalize();
			
			//got from both ends
			if (iDebug)
			{
				for (int j = 0; j < qdUse.length(); j++)
				{
					qdUse[j].vis(0);
				}
			}
			
			Point3d ptXLimits[] = Line(el.ptOrg(), el.vecX()).orderPoints(ptCurrentVertexes);
			for(int j=0; j<qdUse.length();j++)
			{
				if (iDebug) 
				{
					arPtBds[0].vis(i);
					qdUse[j].vis(1);
				}
				if (j == qdUse.length() -1) continue;
				double dTest=el.vecX().dotProduct(qdUse[j].ptOrg() - ptXLimits.first());
				if(dTest > dMinDistFromEdge)
				{
					Point3d ptLift = Line(arLs[i].ptStart(), el.vecX()).closestPointTo(Line(qdUse[j].ptOrg(), qdUse[j].vecX()));
					Vector3d vcDatum = el.vecY().dotProduct(ptDatum - ptLift) > 0 ? el.vecY() : - el.vecY();					
					if (entUse[j].bIsKindOf(TrussEntity()))
					{
						TrussEntity te = (TrussEntity) entUse[j];
						TrussDefinition td = te.definition();
						TslInst arTsl[] = td.tslInst();
						
						String arTslPos[0];
						for (int k=0; k<arTsl.length(); k++)
						{
							if (arTsl[k].map().hasMap("mpTrussPlate"))
							{
								Map map = arTsl[k].map().getMap("mpTrussPlate");
								PLine plPlate = map.getPLine("plPlate");
								double dPlateThick = map.getDouble("dPlateThick") > 0 ? map.getDouble("dPlateThick") : U(2, "mm");
								Vector3d vcPlate = abs(map.getVector3d("vcPlate").length()) > 0 ? map.getVector3d("vcPlate") : plPlate.coordSys().vecZ();
								plPlate.transformBy(te.coordSys());
								vcPlate.transformBy(te.coordSys());
								Point3d ptsPlate[] = plPlate.vertexPoints(true);
								if ((vcPlate).dotProduct(qdUse[j].ptOrg() - ptsPlate.first()) < 0) vcPlate = - vcPlate;
								vcPlate.normalize();
								plPlate.transformBy((qdUse[j].ptOrg() - ptsPlate.first()).dotProduct(vcPlate) * vcPlate);
								if (!vcPlate.isParallelTo(el.vecZ()))
								{
									Body bdPlate(plPlate, qdUse[j].dD(vcPlate)*vcPlate, 0);									
									if ((bdPlate.ptCen()-ptDatum).dotProduct(vcCompare)>0) { bdTsl.append(bdPlate);}
								}
							}
						}
						
					}
					qdLift.append(qdUse[j]);
//					qdUse[j].vis(3);
					break;
				}
			}
			
			for(int j=qdUse.length()-1;j>-1;j--)
			{
				double dTest=el.vecX().dotProduct(ptXLimits.last() - qdUse[j].ptOrg());
				if(dTest > dMinDistFromEdge)
				{					
					Point3d ptLift = Line(arLs[i].ptStart(), el.vecX()).closestPointTo(Line(qdUse[j].ptOrg(), qdUse[j].vecX()));
					Vector3d vcDatum = el.vecY().dotProduct(ptDatum - ptLift) > 0 ? el.vecY() : - el.vecY();					
					if (entUse[j].bIsKindOf(TrussEntity()))
					{
						TrussEntity te = (TrussEntity) entUse[j];
						TrussDefinition td = te.definition();
						TslInst arTsl[] = td.tslInst();
						PlaneProfile ppTsl[0];
						String arTslPos[0];
						for (int k=0; k<arTsl.length(); k++)
						{
							if (arTsl[k].map().hasMap("mpTrussPlate"))
							{
								Map map = arTsl[k].map().getMap("mpTrussPlate");
								PLine plPlate = map.getPLine("plPlate");
								double dPlateThick = map.getDouble("dPlateThick") > 0 ? map.getDouble("dPlateThick") : U(2, "mm");
								Vector3d vcPlate = abs(map.getVector3d("vcPlate").length()) > 0 ? map.getVector3d("vcPlate") : plPlate.coordSys().vecZ();
								plPlate.transformBy(te.coordSys());
								vcPlate.transformBy(te.coordSys());
								Point3d ptsPlate[] = plPlate.vertexPoints(true);
								if ((vcPlate).dotProduct(qdUse[j].ptOrg() - ptsPlate.first()) < 0) vcPlate = - vcPlate;
								vcPlate.normalize();
								plPlate.transformBy((qdUse[j].ptOrg() - ptsPlate.first()).dotProduct(vcPlate) * vcPlate);
								if (!vcPlate.isParallelTo(el.vecZ()))
								{
									Body bdPlate(plPlate, qdUse[j].dD(vcPlate)*vcPlate, 0);									
									if ((bdPlate.ptCen()-ptDatum).dotProduct(vcCompare)>0) bdTsl.append(bdPlate);									
								}
							}
						}
						
					}
					qdLift.append(qdUse[j]);
//					qdUse[j].vis(3);
					break;
				}
			}
			bdSteel.append(bdTsl);
			int iRedo = qdLift.length() < 2 ? true : false;
			if ( ! iRedo && qdLift[0].ptOrg() == qdLift[1].ptOrg()) iRedo = true;
			reportMessage("\n Redo: " + (iRedo == true ? "true" : "false"));
			if (iRedo) 
			{
				LineSeg ls = arLs[i];
				ls.transformBy(-U(1) * vcCompare);
				arLs.append(ls);
				iLsQty = arLs.length();
				continue;
			}
			String arPlates[0];
			for(int j=0; j<bdTsl.length(); j++) { arPlates.append(String().format("%09.4f", (bdTsl[j].ptCen()-(ptDatum-U(5000)*vcCompare)).dotProduct(vcCompare)) + "@" + j);}
			String arPlatesSorted[] = arPlates.sorted();
			for(int j=arPlatesSorted.length()-1; j>-1; j--)
			{
				Body bdCheck(arLs[i].ptMid(), el.vecX(), el.vecY(), el.vecZ(), arLs[i].length(), U(4, "inch"), qdLift.first().dD(el.vecZ()), 0,0,0); bdHole.append(bdCheck);
				Body bdPlate = bdTsl[arPlatesSorted[j].token(1, "@").atoi()]; 
				if (bdPlate.hasIntersection(bdCheck)) 
				{
					Point3d ptInter[] = bdPlate.intersectPoints(Line(Line(bdPlate.ptCen(), el.vecY()).closestPointTo(ptDatum), vcCompare));
					if (ptInter.length()>0)
					{
						LineSeg ls = arLs[i];
						ls.transformBy(((ptInter.first() - U(2) * vcCompare) - ls.ptMid()).dotProduct(vcCompare) * vcCompare);
						arLs[i] = ls;						
					}
				}
				else 
				{
					PlaneProfile ppLs;
					ppLs.createRectangle(LineSeg(arLs[i].ptStart() - U(0.001) * el.vecY(), arLs[i].ptEnd() + U(0.001) * el.vecY()), el.vecY(), el.vecX());
					for (int k=0; k<ppSheetGaps.length(); k++)
					{
						if (PlaneProfile(ppLs).intersectWith(PlaneProfile(ppSheetGaps[k])))
						{
							LineSeg ls = arLs[i];							
							ls.transformBy( (ppSheetGaps[k].extentInDir(el.vecY()).ptMid()-ppLs.extentInDir(el.vecY()).ptMid()).dotProduct(vcCompare) * vcCompare);
							ls.transformBy(-U(1.25)*vcCompare);
							arLs[i] = ls;
						}
					}
				}
			}
			
			for(int j=0; j<qdLift.length(); j++) 
			{ 
				qdLift[j].vis(58);
				qdLift[j].vis(6);
				arPtLift.append(Line(arLs[i].ptStart(), el.vecX()).closestPointTo(Line(qdLift[j].ptOrg(), qdLift[j].vecX())));
			}
			
		}
		
		//Add the holes
		TslInst tsl;
		String sScriptName = "GE_FLOOR_HOLES";
	
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[1];
		Point3d lstPoints[1];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[2];
		
		lstEnts[0] = el;
		lstPropString[0] = "2-1\"Drills Spaced at 3-3/4\"";
		lstPropString[1] = T("Perpendicular to Joist Direction");
		
		for(int h=0;h<arPtLift.length();h++)
		{
			lstPoints[0] = arPtLift[h];
			
			if(iDebug)
			{ 
				Display dpX (3); double dXl = U(15); Point3d ptX = arPtLift[h]; PLine plTmp (_ZW); plTmp.addVertex(ptX - _XW * dXl * .5); plTmp.addVertex(ptX + _XW * dXl * .5); plTmp.addVertex(ptX); 
				plTmp.addVertex(ptX - _YW * dXl * .5); plTmp.addVertex(ptX + _YW * dXl * .5); dpX.draw(plTmp); plTmp = PLine (_XW); plTmp.addVertex(ptX - _ZW * dXl * .5); plTmp.addVertex(ptX + _ZW * dXl * .5); dpX.draw(plTmp);
				continue;
			}
			
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
			_Map.appendEntity("mpHoles\\entHole", tsl); 
		}
			
	}


if (iDebug)
{
	Display dpDebug(230);
	for (int i=0; i<bdSteel.length(); i++) { dpDebug.draw(bdSteel[i]);}
	dpDebug.color(2);
	for (int i=0; i<bdHole.length(); i++) { dpDebug.draw(bdHole[i]);}
//	dpDebug.color(3);
	//for (int i=0; i<ppSheetGaps.length(); i++) { dpDebug.draw(ppSheetGaps[i], _kDrawFilled);}
	
}
#End
#BeginThumbnail
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
6[5`HHI78U3@G=(?11106%%%%`'__V69I
`













#End
#BeginMapX

#End