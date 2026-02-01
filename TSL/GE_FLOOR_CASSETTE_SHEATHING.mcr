#Version 8
#BeginDescription
V1.16__03/24/2020__DR__Added <3/4 4x8 TG USG S1>
V1.15__02/11/2020
V1.14__02/10/2020__Added 1/8inch sheathing gap (static)
V1.13__9/13-2019__Standartized sorting method
V1.12__02_Aug_2019__Supports trusses
V1.11__21May2019__Changed sheathing width to 47.8125 afer reviewing feedback from Ben
V1.10__21May2019__Changed sheathing width to 47.5 in lieu of 47.75
V1.9__June 12 2018__Added 4x12 T&G__BDF
V1.8__June 11 2018__Changed T&G material name and thickness to match KPN lookup table__BDF
V1.7__June 4 2018__Checks to see if polyline and floor cassette intersect
V1.6__Unknown....
V1.5__Oct 10 2017__Changed tongue depth
V1.4__May 2 2016__Added a tolenrance on the sheathing length of 0.02
V1.3__Dec 10 2015__Updated sheathing material names
V1.2__June 2 2015__Will now assign groove and tongue edges on floors sheets
V1.1__Increased T&G Value
V1.0__21April2015__Have removed the Panel designation from subLabel... it was redundant
V0.9__Will store data for the sheething install sequence
V0.8__20April2015__Changed sheet sizes
V0.7__19April 2015__Added gap finctionality for the SPM output
V0.6__15Sept 2014__Revised sheet widths and uncommented a very important line!
V0.5__11Sept2014__Fixed penings when contained within sheets
V0.4__8Sept2014__Added 4x12 sheathing and corrected _Pt0 at insert
V0.3__22August2014__Will write panel number in subLabel Field
V0.2__9July2014__Sheathing raised up above joists
V0.1__9July2014_Ready to be tested




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 16
#KeyWords 
#BeginContents
	Unit(1,"inch");
	double dTolerance = U(0.02);
	
	String arSheetList[0], arMatName[0];
	double arDWidths[0], arDHeight[0], arDThick[0], arDTG[0];
	int arIColor[0];
	
	arSheetList.append("4x8 T&G");arMatName.append("23/32 4x8 TG");arDWidths.append(U(47.76));arDHeight.append(U(96));arDThick.append(U(0.71875));arDTG.append(U(0.1975)); arIColor.append(30);
	arSheetList.append("4x10 T&G");arMatName.append("23/32 4x10 TG");arDWidths.append(U(47.76));arDHeight.append(U(120));arDThick.append(U(0.71875));arDTG.append(U(0.1975));arIColor.append(40);	
	arSheetList.append("4x12 T&G");arMatName.append("23/32 4x12 TG");arDWidths.append(U(47.76));arDHeight.append(U(144));arDThick.append(U(0.71875));arDTG.append(U(0.1975));arIColor.append(40);		
	arSheetList.append("3/4 4x8 TG USG S1");arMatName.append("3/4\" USG STRUCTURAL PANEL CONCRETE SUBFLOOR");arDWidths.append(U(47.76));arDHeight.append(U(96));arDThick.append(U(0.75));arDTG.append(U(0.1975)); arIColor.append(30);
	
//__Properties
	int iSP=0,iDP=0;
	
	String arYN[]={"Yes","No"};
	
	PropString strEmpty0(iSP++," ","SHEATHING PROPERTIES");
	strEmpty0.setReadOnly(TRUE);
	
	PropString stMat(iSP++,arSheetList,"  Material");
	if(arSheetList.find(stMat) == -1)stMat.set(arSheetList[0]);
	
	String arAllignment[]={"Bottom Left","Bottom Right", "Top Left", "Top Right"};
	double arXDir[] = {1,-1,1,-1};
	double arYDir[] = {1,1,-1,-1};
	PropString psDistrib(iSP++,arAllignment,"  Distribution from",1);
	
	PropDouble dMinStagger(iDP++,U(12),"  Minimum Staggered Offset");
	
	String arHoldChoices[]={"None","Even Rows","Odd Rows","All Rows"};
	
	PropString strEmpty1(iSP++," ","LEFT EDGE PROPERTIES");
	strEmpty1.setReadOnly(TRUE);
	
	PropDouble dLeftHold(iDP++,U(0),"  Min. Hold Value");
	PropString stLeftHold(iSP++,arHoldChoices,"  Rows to Hold");
	
	PropString strEmpty2(iSP++," ","RIGHT EDGE PROPERTIES");
	strEmpty2.setReadOnly(TRUE);
	
	PropDouble dRightHold(iDP++,U(0),"  Min. Hold Value ");
	PropString stRightHold(iSP++,arHoldChoices,"  Rows to Hold ");	
	double dBBGap = U(0.125);
	
//__bOnInsert or element copied or split
	if (_bOnInsert || _bOnElementListModified)
	{
	
		if(_Element.length() == 0)
		{
			showDialog();

			PrEntity ssE("\nSelect a set of cassettes",ElementRoof());
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
		}
		
		_Map.setMap("mpProps", mapWithPropValues());
		
		//CLONE
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
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,1,_Map );
		}
		eraseInstance();
		return;	
		
	}//END if (_bOnInsert)

//__set properties from map
	if(_Map.hasMap("mpProps")){
		setPropValuesFromMap(_Map.getMap("mpProps"));
		_Map.removeAt("mpProps",0);
	}


//__Safety
	if(_Element.length()==0){
		eraseInstance();
		return;
	}

	ElementRoof el = (ElementRoof) _Element[0];
	if(!el.bIsValid()){
		eraseInstance();
		return;
	}

	TslInst arTSL[]=el.tslInstAttached();
	for (int tsl=0; tsl<arTSL.length();tsl++){
		if(arTSL[tsl].scriptName() == scriptName() && arTSL[tsl] != _ThisInst){
			arTSL[tsl].dbErase();
		}
	}

	assignToElementGroup(el,TRUE,1,'T');
	setDependencyOnEntity(_Element[0]);	
	Map mpX = el.subMapX(scriptName());
	
	
//__Add context commands
	Plane pnEl(el.ptOrg(),el.vecZ());

	String stAddPL="Set sheathed area from polyline";
	String stRemovePL="Remove polyline area";
	
	addRecalcTrigger(_kContext, stAddPL);
	addRecalcTrigger(_kContext, stRemovePL);
	
	
	if(_kExecuteKey == stAddPL)
	{
		EntPLine entPl = getEntPLine("\nSelect a closed polyline that defines the sheathed area");
		PLine pl = entPl.getPLine();
		
		Point3d arPtPl[]=pl.vertexPoints(TRUE);
		if(arPtPl.length() > 2)
		{
			//fix it
			pl.close();
			pl.projectPointsToPlane(pnEl, el.vecZ());
			pl.setNormal(el.vecZ());
			mpX.setPLine("plSheetArea", pl);
			el.removeSubMapX(scriptName());
			el.setSubMapX(scriptName(),mpX);
			
			entPl.dbErase();
		}
	}
	if(_kExecuteKey == stRemovePL)
	{
		mpX.removeAt("plSheetArea",1);
		el.removeSubMapX(scriptName());
		el.setSubMapX(scriptName(),mpX);
	}
	
//__Get an outline and make a display	
	PlaneProfile ppZ1;
		
	if(mpX.hasPLine("plSheetArea"))
	{
		ppZ1 = PlaneProfile(mpX.getPLine("plSheetArea"));
	}
	//Safety 1
	if(ppZ1.numRings() == 0)ppZ1 = el.profBrutto(1);
	//Safety 2
	if(ppZ1.numRings() == 0)ppZ1 = el.profBrutto(0);
	//Safety 3
	if(ppZ1.numRings() == 0)ppZ1 = PlaneProfile(el.plEnvelope());
	
	ppZ1.vis(1);


	//Test area
	PlaneProfile ppTest1 = ppZ1, ppTest2 = PlaneProfile(el.plEnvelope());
	PLine arRings1[]=ppTest1.allRings();
	
	
	if( mpX.hasPLine("plSheetArea") && arRings1.length() > 0)
	{
		Body bd1(arRings1[0], el.vecZ() * U(1000)), bd2(el.plEnvelope(), el.vecZ()*U(1000));
		
		if(! bd1.hasIntersection(bd2))
		{ 	
			reportMessage("\nSheathing area off element " + el.number());
			Display dp1(1);
			dp1.draw(ppZ1);
			
			LineSeg ls(el.ptOrg(), ppZ1.closestPointTo(el.ptOrg()));
			dp1.draw(ls);
			return;
		}
	}



//__Define origine and refference coordsys to work from
	Vector3d vx = el.vecX() * arXDir[arAllignment.find(psDistrib)];
	Vector3d vy = el.vecY() * arYDir[arAllignment.find(psDistrib)]; 

	
	Point3d arPtOutline[] = Line(el.ptOrg(),vx).orderPoints(ppZ1.getGripVertexPoints());
	//Point fare right
	Point3d ptFR = arPtOutline[arPtOutline.length()-1];
	Line lnEdge(arPtOutline[0], vy);
	arPtOutline = Line(el.ptOrg(),vy).orderPoints(arPtOutline);
	Point3d ptFB = arPtOutline[0];
	
	Point3d ptRef = Line(arPtOutline[0], vx).closestPointTo(lnEdge);
	
	//Reset it
	if(_kNameLastChangedProp == "  Distribution from" || _kExecuteKey == stAddPL || _kExecuteKey == stRemovePL || _bOnInsert || _bOnDbCreated )_Pt0=ptRef;
		
//__Set ptRef within the first sheet length
	int iSheet = arSheetList.find(stMat);
	double dDistOrg = vy.dotProduct(_Pt0-ptRef) ; 

	if(dDistOrg > arDWidths[iSheet] || dDistOrg < U(-0.125))
	{
		//Move it
		int iMove = dDistOrg/(arDWidths[iSheet]-arDTG[iSheet]);
		double dMove = (arDWidths[iSheet]-arDTG[iSheet])*iMove;
		if(dDistOrg < U(0))
		{
			dMove *=-1;
			dMove-=arDWidths[iSheet];
			dMove-=arDTG[iSheet];
		}
		_Pt0.transformBy(-vy * dMove);
	}
	
	LineSeg ls(ptRef,ptRef + vy * arDWidths[iSheet]);
	_Pt0 = ls.closestPointTo(_Pt0);
	ptRef = _Pt0;

//__Add my display
	Display dp(-1);
	PLine plC;
	PLine plx(_Pt0-U(0.5)*vx,_Pt0+U(2)*vx);
	PLine plxArrow(_Pt0+U(1.5)*vx+U(0.25)*vy,_Pt0+U(2)*vx,_Pt0+U(1.5)*vx-U(0.25)*vy);
	PLine ply(_Pt0-U(0.5)*vy,_Pt0+U(2)*vy);
	PLine plyArrow(_Pt0+U(1.5)*vy+U(0.25)*vx,_Pt0+U(2)*vy,_Pt0+U(1.5)*vy-U(0.25)*vx);
	
	dp.color(1);
	
	plC.createCircle(_Pt0,el.vecZ(),U(.25));
	dp.draw(plC);
	dp.textHeight(U(.25));
	dp.draw("SHEET",_Pt0+U(0.75)*vy,-el.vecY(),el.vecX(),0,2);
	dp.draw("REF",_Pt0+U(0.75)*vx,el.vecX(),el.vecY(),0,-2);
	
	
	dp.color(4);
	
	dp.draw(plx);
	dp.draw(plxArrow);
	
	dp.draw(ply);
	dp.draw(plyArrow);

//__Store the data
	_Map.setVector3d("mpSheathingRef\\vx" , vx);
	_Map.setVector3d("mpSheathingRef\\vy" , vy);
	_Map.setPoint3d("mpSheathingRef\\ptRef" , _Pt0);
	
//__Set some triggers	
	String strRecalcSheet="Re-distribute sheathing on floor";
	addRecalcTrigger(_kContext,strRecalcSheet);
	
	if(_kExecuteKey == strRecalcSheet || _bOnElementConstructed || _bOnInsert || _bOnDbCreated || _kNameLastChangedProp != "" || _kExecuteKey == stAddPL || _kExecuteKey == stRemovePL)
	{
	//__Get main profile
		PLine plOuterRing;
		PlaneProfile ppMain = ppZ1;
		
		PLine arPl[]=ppMain.allRings();
		if(arPl.length() != 1)
		{
			reportMessage("\nRing count incorrect");
			return;
		}
		plOuterRing = arPl[0];
		
		Body bdEl(plOuterRing, el.vecZ()*U(12), 0);
		double dElL=bdEl.lengthInDirection(vy), dElW=bdEl.lengthInDirection(vx);
		Point3d ptMidRef = ptRef + vx*dElW/2 + vy*dElL/2;
		Line lnXMid(ptMidRef, vx);
		
	//__Get opening areas
		OpeningRoof arOp[0];
		PlaneProfile arPpOpe[0];
		
		Group arGr[]=el.groups();
		for	(int i=0;i<arGr.length();i++){
			Entity ents[]=arGr[i].collectEntities(TRUE,OpeningRoof(),_kModelSpace);
			
			for	(int j=0;j<ents.length();j++){
				OpeningRoof opR=(OpeningRoof)ents[j];
				Body bdOp(opR.plShape(),el.vecZ()*U(2000),0);
				PlaneProfile ppShape(opR.plShape());
				bdOp.vis(5);
				
				if(bdOp.hasIntersection(bdEl))
				{
					arOp.append(opR);
					arPpOpe.append(ppShape);
				}
			}
		}
	
	//Clear old sheets
		Sheet arSh[]=el.sheet(1);
		for (int i = arSh.length()-1; i > -1 ; i--)arSh[i].dbErase();
		
	//__Collect splitting beams	
		 
			Group elG = el.elementGroup();
			Entity arBm[] = elG.collectEntities(true, Beam(), _kModelSpace);
			arBm.append(elG.collectEntities(true, TrussEntity(), _kModelSpace));
			Quader qdAll[0], qdTemp[0];
			Entity entTemp[0];
			String arTemp[0];
			for (int i=0; i<arBm.length(); i++)
			{
				Quader qdI;
				if (arBm[i].bIsKindOf(Beam())) 
				{
					Beam bmQ = (Beam) arBm[i];
					qdI = bmQ.quader();
				}
				else if (arBm[i].bIsKindOf(TrussEntity()))
				{
					TrussEntity te = (TrussEntity) arBm[i];
					TrussDefinition td = te.definition();
					Map mp = td.subMapX("Content");
					double sizes[] = { mp.getVector3d("Length").length(), mp.getVector3d("Width").length(), mp.getVector3d("Height").length()};
					CoordSys csT = te.coordSys();
					Quader qdT(csT.ptOrg() + 0.5*sizes[0]*csT.vecX() + 0.5*sizes[2]*csT.vecZ(), csT.vecX(), csT.vecY(), csT.vecZ(), sizes[0], sizes[1], sizes[2], 0, 0, 0);			
					qdI = qdT;
				}
				if (qdI.vecX().isPerpendicularTo(vx))
				{
					qdTemp.append(qdI);
					entTemp.append(arBm[i]);
					arTemp.append(String().format("%09.4f", abs((qdI.ptOrg() - (_PtW - U(5000) * vx)).dotProduct(vx))) + "@" + String(qdTemp.length() - 1) );
				}
			}
			String arTempSorted[] = arTemp.sorted();
			arBm.setLength(0);
			for (int i=0; i<arTempSorted.length(); i++)
			{
				arBm.append(entTemp[arTempSorted[i].token(1, "@").atoi()]);
				qdAll.append(qdTemp[arTempSorted[i].token(1, "@").atoi()]);
			}
		
				
	//__Collect left and right subtracting profiles		
		PlaneProfile ppLeftSub, ppRightSub;
		double dTrueLeftHold = U(0), dTrueRightHold = U(0);
		
		//Left
		if(dLeftHold > U(0) && stLeftHold != arHoldChoices[0])
		{
			double dFind = U(0);
			
			for(int i=0; i<qdAll.length(); i++)
			{
				double dDist = vx.dotProduct(qdAll[i].ptOrg() - ptRef);
				if(dDist >= dLeftHold)
				{
					dTrueLeftHold = dDist;
					Point3d pt=lnXMid.closestPointTo(qdAll[i].ptOrg());
					PLine pl;
					pl.createRectangle(LineSeg(pt-vy*dElL,pt+vy*dElL-vx*2*dTrueLeftHold),vx,vy);
					ppLeftSub = PlaneProfile(pl);
					break;
				}
			}
		}
		//Right
		if(dRightHold > U(0) && stRightHold != arHoldChoices[0])
		{
			double dFind = U(0);
			
			for(int i=qdAll.length()-1; i> -1; i--)
			{
				double dDist = -vx.dotProduct(qdAll[i].ptOrg() - ptFR);
				if(dDist >= dRightHold)
				{
					dTrueRightHold = dDist;
					Point3d pt=lnXMid.closestPointTo(qdAll[i].ptOrg());
					PLine pl;
					pl.createRectangle(LineSeg(pt-vy*dElL,pt+vy*dElL+vx*2*dTrueRightHold),vx,vy);
					ppRightSub = PlaneProfile(pl);
					break;
				}
			}
		}
		//ppLeftSub.vis(2);
		//ppRightSub.vis(2);


	//__Start sheathing per row. drop on low in case refference point is moved	
		double dShW = 	arDWidths[iSheet], dShH = arDHeight[iSheet], dShT = arDThick[iSheet], dGap = arDTG[iSheet];
		
		int iAdd = vy.dotProduct(ptRef - ptFB) > U(0.01)? 1 : 0;
		
		Point3d ptGo=ptRef-vy*dShW*iAdd;
		PLine plRow;plRow.createRectangle(LineSeg(ptGo-U(1)*vx,ptGo+vx*(dElW+U(2)) + vy*dShW), vx, vy);
		PlaneProfile ppRow(plRow);
		
		//__Collection updated after each row
		Point3d arPtPreviousSplits[0];
		Vector3d vLastSplitDir = -vx;
	
	//__Loop over each row	
		for(int i=0; i < ((dElL/dShW)+iAdd); i++)
		{
			//__Main area
			PlaneProfile ppAll = ppZ1;
				
			//__Sheet are	
			PLine pl = plRow;
			Body bdRow(pl, el.vecZ()*U(12),0);
			PlaneProfile pp = ppRow;
			
			//__Make sure it touches
			if( ! bdRow.hasIntersection(bdEl))
			{
				ppRow.transformBy(vy * dShW);
				plRow.transformBy(vy * dShW);
				continue;
			}
			
			//__Remove left
			if(dTrueLeftHold > U(0))
			{
				if(stLeftHold == arHoldChoices[3]//all
					|| (stLeftHold == arHoldChoices[1] && i%2 != 0)//even... keep in mind that we start at 0 and not 1
					|| (stLeftHold == arHoldChoices[2] && i%2 == 0)//odd
					)
				{
					pp.subtractProfile(ppLeftSub);
				}
			}
			//__Remove Right
			if(dTrueRightHold > U(0))
			{
				if(stRightHold == arHoldChoices[3]//all
					|| (stRightHold == arHoldChoices[1] && i%2 != 0)//even... keep in mind that we start at 0 and not 1
					|| (stRightHold == arHoldChoices[2] && i%2 == 0)//odd
					)
				{
					pp.subtractProfile(ppRightSub);
				}
			}
			
			//__Make shape to current plane
			pp.intersectWith(ppAll);
			
			//__Remove openings
			for(int j=0; j<arPpOpe.length(); j++)
			{
				PlaneProfile ppOp = arPpOpe[j];
				pp.subtractProfile(ppOp);
			}
			pp.vis(2);
			//continue;	
			
			//__Loop over each right and split
			PLine arRings[] = pp.allRings();
			int arIRingIsOpe[] = pp.ringIsOpening();
			
			//__Split this sheathing up
			Point3d arPtSplits[0];
			Vector3d vGo=vLastSplitDir*-1;
			
			for(int r=0; r<arRings.length(); r++)
			{
				//Stop for an opening
				if(arIRingIsOpe[r])continue;
				
				Point3d arPtSheet[] = lnXMid.orderPoints(arRings[r].vertexPoints(TRUE));
				double dRingL = vx.dotProduct(arPtSheet[arPtSheet.length()-1] - arPtSheet[0]);
				
				//__Create sheets then split
				CoordSys csS(el.ptOrg(),el.vecY(),-el.vecX(),el.vecZ());
				PlaneProfile ppS(csS);
				ppS.joinRing(arRings[r],FALSE);
				ppS.vis(i+r);
				
				Sheet sh;
				sh.dbCreate(ppS,arDThick[iSheet],1);
				sh.setName(arMatName[iSheet]);
				sh.setMaterial(arMatName[iSheet]);
				sh.assignToElementGroup(el,TRUE,1,'Z');
				sh.setColor(arIColor[iSheet]);
				//sh.setSubLabel2("Panel-" + el.number());
				
				//__REmove opes again
				//rings completely contained do not create holes
				for(int yy=0;yy<arPpOpe.length();yy++){
					PLine arPlRs[]=arPpOpe[yy].allRings();
					if(arPlRs.length() == 0)continue;
					
					sh.joinRing(arPlRs[0],true);
					continue;
				}
				
				
				if(dRingL > (dShH+dTolerance))
				{
					//Create a sheet list
					Sheet arSheets[]={sh};
	
					
					Point3d arPtEnds[] = Line(ptRef, vGo).orderPoints(arPtSheet);
					Point3d arPtTopBot[] = Line(ptRef, vy).orderPoints(arPtSheet);
					Point3d ptSplit = arPtEnds[0];
					
					//New beam sort
					Entity arBmUse[0];
					arBmUse.append(arBm);
					Quader qdUse[0];
					qdUse.append(qdAll);
					if (arBm.length()>0)
					{						
						String arTempx[0];
						for (int t=0; t<qdAll.length(); t++)
						{
							if (qdAll[t].vecX().isPerpendicularTo(vGo)) arTempx.append(String().format("%09.4f", abs((qdAll[t].ptOrg() - (_PtW - U(5000) * vGo)).dotProduct(vGo))) + "@" + t);
						}
						String arTempxSorted[] = arTempx.sorted();
						qdUse.setLength(0);
						arBmUse.setLength(0);
						for (int t=0; t<arTempxSorted.length(); t++)
						{
							qdUse.append(qdAll[arTempxSorted[t].token(1, "@").atoi()]);
							arBmUse.append(arBm[arTempxSorted[t].token(1, "@").atoi()]);
						}
					}
										
					int iSafe=0;
					while(iSafe<30)
					{
						iSafe++;
						Point3d ptIdeal = ptSplit + vGo * dShH;
						ptIdeal.vis(7);
						
						//Left over is within size
						if(vGo.dotProduct(ptIdeal - arPtEnds[arPtEnds.length()-1]) > U(0))break;
						
						for(int p=qdUse.length()-1 ; p>-1 ; p--)
						{
							Quader bm=qdUse[p];
														
							//is it in range//Maybe none worked
							double dx = vGo.dotProduct(ptIdeal - bm.ptOrg());
							if(dx < U(-0.01))continue;
							
							double dStart = vGo.dotProduct(bm.ptOrg()- ptSplit);
							if(dStart < U(0))
							{
								//looped all crossing beams... no sence to continue
								iSafe = 1000;
								reportMessage("\nA sheet cannot be split on panel " + el.number());
								break;
							}
							
							//does the beam cross under
							Point3d ptBmEnds[]={bm.ptOrg()+bm.vecX()*0.5*bm.dD(bm.vecX()), bm.ptOrg()-bm.vecX()*0.5*bm.dD(bm.vecX())};
							if(bm.vecX().dotProduct(ptBmEnds[0] - arPtTopBot[0]) * bm.vecX().dotProduct(ptBmEnds[1] - arPtTopBot[0]) > U(0)
								&& bm.vecX().dotProduct(ptBmEnds[0] - arPtTopBot[arPtTopBot.length()-1]) * bm.vecX().dotProduct(ptBmEnds[1] - arPtTopBot[arPtTopBot.length()-1]) > U(0)
							)continue;
							
							//Is it too close to another split
							if(dMinStagger > U(0))
							{
								int bOk=TRUE;
								for(int v=0; v<arPtPreviousSplits.length();v++)
								{
									if(abs(vGo.dotProduct(arPtPreviousSplits[v] - bm.ptOrg())) < dMinStagger)
									{
										bOk = FALSE;
										break;
									}
								}
								if( ! bOk)continue;
							}
							
							//We made it
							ptSplit = Line(ptSplit,vGo).closestPointTo(bm.ptOrg());
							arPtSplits.append(ptSplit);
							Sheet shNew[0];
							for(int ss=0; ss<arSheets.length(); ss++)
							{
								shNew.append(arSheets[ss].dbSplit(Plane(ptSplit,vx), dBBGap));
							}
							arSheets.append(shNew);
							
							break;
						}
					}
					
					
				}
			}
			vLastSplitDir = vGo;
			arPtPreviousSplits = arPtSplits;
			
			ppRow.transformBy(vy * (dShW-dGap));
			plRow.transformBy(vy * (dShW-dGap));
		}//__Loop over each row	 END
	}
	
	
	
	//__Label groove and tongue edges
	Sheet arSh[]= el.sheet(1);
		
	if(arSh.length() > 0 )
	{
		Vector3d vSort = -el.vecY();
		Vector3d vEdge = vSort.crossProduct(el.vecZ());
		double dShW = arDWidths[iSheet];
		
		//Sort sheets 
		for ( int i = arSh.length() -1; i >=0  ; i-- ) {	
		
			Point3d pts[] = arSh[i].envelopeBody().extremeVertices(vSort);	
			double d1=vSort.dotProduct(pts[0] - el.ptOrg());
			int iMax = i ;			
			for ( int j = 0; j	<= i  ; j++ ) {
				Point3d pts2[] = arSh[j].envelopeBody().extremeVertices(vSort);	
				double d2=vSort.dotProduct(pts2[0] - el.ptOrg());
				if ( d1 < d2 ) {
					d1=d2;
					iMax = j ;
				}
			}		
			arSh.swap(iMax, i ) ;
		}
		
		//__Label edges
		Point3d ptLast = _PtW;
		for ( int i = 0; i < arSh.length()  ; i++ ) 
		{	
			Sheet sh = arSh[i];
			if(!sh.bIsValid())continue;
			
			Point3d pts[] = sh.envelopeBody().extremeVertices(vSort);
			
			double dSize = vSort.dotProduct(pts[1]-pts[0]);
			
			int hasGrooveEdge = 1;
			
			if(abs(dSize - dShW) < U(0.0125))
			{
				hasGrooveEdge = 1;
			}
			else if(i==0 || (abs(vSort.dotProduct(pts[0] - ptLast)) < U(0.125) && i==1) )
			{
				//First row	
				if(abs(dSize - dShW) < U(0.0125))
				{
					hasGrooveEdge = 1;
				}
				else
				{
					hasGrooveEdge = 0;
				}
			}
				
			ptLast = pts[0];
			
			//__Assign edge
			String stEdge = "Groove";
			Point3d ptEdge = pts[0];
			
			if(!hasGrooveEdge)
			{
				stEdge = "Tongue";
				ptEdge = pts[1];
			}
			
			
			Point3d ptsEdge[0];
			Point3d arPtsBd[]=sh.envelopeBody().allVertices();
			Line lnEdge(ptEdge,vEdge);
			
			for(int j=0;j<arPtsBd.length();j++)
			{
				Point3d ptLine = lnEdge.closestPointTo(arPtsBd[j]);
				
				if( (ptLine - arPtsBd[j]).length() < U(0.0125))ptsEdge.append(ptLine);
			}
			ptsEdge = lnEdge.orderPoints(ptsEdge);
			
			if(ptsEdge.length() > 1)
			{
				//we have an edge
				LineSeg ls(ptsEdge[0], ptsEdge[ptsEdge.length()-1]);
				ls.vis(i);
				
				Map map;
				map.setPoint3d("ptStart", ptsEdge[0]);
				map.setPoint3d("ptEnd",ptsEdge[ptsEdge.length()-1]);
				map.setString("EdgeName", stEdge);
						
				CncExport tl("OutlineEdgeInfo",map);
				sh.addTool(tl);
			}
			arSh[i].envelopeBody().vis(i);
		}
	}








#End
#BeginThumbnail
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
6[5`HHI78U3@G=(?11106%%%%`'__V69I
`




















#End
#BeginMapX

#End