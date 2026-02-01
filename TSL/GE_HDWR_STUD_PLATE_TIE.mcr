#Version 8
#BeginDescription
V1.2__01/07/21__Will set hardware group
V1.1__Dec 24 2015__Will export to BisTrack
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
U(1,"inch");

//Blocking minimum length. If space is smaller nothing will be created
	double dMinBlk=U(1.55);

//__Inventory
	String arStType[0],arStCode[0], arStStudSize[0];
	double arDLength[0], arDWidth[0];
	arStType.append("SP"); arStCode.append("SP1");arDLength.append(U(5.0625));arDWidth.append(U(3.5));arStStudSize.append("2x3");
	arStType.append("SP"); arStCode.append("SP2");arDLength.append(U(6.625));arDWidth.append(U(3.5));arStStudSize.append("2x3");
	arStType.append("SP"); arStCode.append("SP4");arDLength.append(U(7.25));arDWidth.append(U(3.5625));arStStudSize.append("2x4");
	arStType.append("SP"); arStCode.append("SP6");arDLength.append(U(7.75));arDWidth.append(U(5.5625));arStStudSize.append("2x6");
	arStType.append("SP"); arStCode.append("SP8");arDLength.append(U(8.3125));arDWidth.append(U(7.3125));arStStudSize.append("2x8");
	arStType.append("SPH"); arStCode.append("SPH4");arDLength.append(U(8.75));arDWidth.append(U(3.5625));arStStudSize.append("2x4");
	arStType.append("SPH"); arStCode.append("SPH4R");arDLength.append(U(8.25));arDWidth.append(U(4.0625));arStStudSize.append("2x4");
	arStType.append("SPH"); arStCode.append("SPH6");arDLength.append(U(9.25));arDWidth.append(U(5.5625));arStStudSize.append("2x6");
	arStType.append("SPH"); arStCode.append("SPH6R");arDLength.append(U(8.75));arDWidth.append(U(6.0625));arStStudSize.append("2x6");
	arStType.append("SPH"); arStCode.append("SPH8");arDLength.append(U(8.375));arDWidth.append(U(7.3125));arStStudSize.append("2x8");
	
	
	
	String arStList[]={"No Selection"};
	Element el;
	String stWallSize="";
	Beam arBm[0];
	if(_Element.length() > 0)el=_Element[0];
	
	if(el.bIsValid())
	{
		arBm = el.beam();
		double dd=el.dBeamWidth();
		if(abs(dd - U(3.5)) < U(0.125)) stWallSize = "2x4";
		else if( abs(dd - U(5.5)) < U(0.125)) stWallSize = "2x6";
		else if( abs(dd - U(7.25)) < U(0.125)) stWallSize = "2x8";
		else if( abs(dd - U(7.5)) < U(0.125)) stWallSize = "2x8";
		else if( abs(dd - U(2.5)) < U(0.125)) stWallSize = "2x3";
		else stWallSize = dd;
		
		if(arStStudSize.find(stWallSize) > -1)
		{
			arStList.setLength(0);
			for(int f=0;f<arStStudSize.length();f++)if(arStStudSize[f] == stWallSize)arStList.append(arStCode[f]);
		}
	}
	
	
	
	
//__Properties
	String arYN[]={"Yes","No"};
	PropString stCode(0,arStList,T("SP Tie"));
	
	String arStLocation[]={"Top","Bottom"};
	PropString stLocation(1,arStLocation,T("Location"));
	
	String arStInstallation[]={"Site Installed","Shop Installed"};
	PropString stInstall(2,arStInstallation,T("Installation"),1);
	
	
//__Property safety
	//is it set to something?	
	if(arStList.find(stCode) == -1 && arStList.length() > 0)
	{
		stCode.set(arStList[0]);
	}
	
	//__Insertion
	if (_bOnInsert)
	{
		
		Beam arBmSelection[0];
		Element arEl[0];
		String arStStudSizePerBeam[0];
		
		String arSizes[0];
		
		PrEntity ssB(T("\nSelect a Stud or Header"), Beam());
		if (ssB.go()) {
			Entity ents[]=ssB.set();
			for(int e=0;e<ents.length();e++){
				if(ents[e].bIsKindOf(Beam())){
					Beam bm = (Beam)ents[e];		
					
					Element el = bm.element();
					if(el.bIsValid())
					{
						String stSize;
						
						if(abs(el.dBeamWidth() - U(3.5)) < U(0.125)) stSize = "2x4";
						else if( abs(el.dBeamWidth() - U(5.5)) < U(0.125)) stSize = "2x6";
						else if( abs(el.dBeamWidth() - U(7.25)) < U(0.125)) stSize = "2x8";
						else if( abs(el.dBeamWidth() - U(7.5)) < U(0.125)) stSize = "2x8";
						else if( abs(el.dBeamWidth() - U(2.5)) < U(0.125)) stSize = "2x3";
						else continue;
						
						if(arSizes.find(stSize) ==-1)arSizes.append(stSize);
						arEl.append(el);
						arBmSelection.append((Beam)ents[e]);
						arStStudSizePerBeam.append(stSize);
					}	
				}
			}
		}
		
		
		for(int i=0;i<arSizes.length();i++)
		{
			String stPrompt = "\nSelect a size for the '" + arSizes[i] + "' wall [";
			
			for(int y=0;y<arStStudSize.length();y++)
			{
				if(arStStudSize[y] == arSizes[i])
				{
					stPrompt+=arStCode[y];
					stPrompt += "/";
				}
			}
			stPrompt = stPrompt.left(stPrompt.length()-1);
			stPrompt += "]";
			
			String stChoice = getString(stPrompt).makeUpper();
			
			for(int f=0;f<arStStudSizePerBeam.length();f++)if(arStStudSizePerBeam[f] == arSizes[i])arStStudSizePerBeam[f] = stChoice;
		}
		
		String stInsertWhere = getString("\nInsert Location [Top/BOttom/Both]").makeUpper();
		
		reportMessage("\nYou selected: " + stInsertWhere);
		if(stInsertWhere == "B")stInsertWhere="BOTH";
		else if(stInsertWhere == "BO")stInsertWhere="BOTTOM";
			
		
		for(int y=0;y<arBmSelection.length();y++)
		{
			Beam bm=arBmSelection[y];
			String stTie = arStStudSizePerBeam[y];
			Element el = arEl[y];
			PLine plEl = el.plEnvelope();
			
			
			Point3d arPt[] = plEl.intersectPoints(Plane(bm.ptCen(),el.vecX()));
			String arStLocation [] = {"Bottom", "Top"};
			arPt=Line(bm.ptCen(),el.vecY()).orderPoints(arPt);
			
			if(arPt.length() != 2)continue;
			if(bm.vecX().isParallelTo(el.vecY()))
			{
				if(stInsertWhere.left(1) == "T")
				{
					arPt.removeAt(0);
					arStLocation.removeAt(0);
				}
				else if(stInsertWhere == "BOTTOM")
				{
					arPt.removeAt(1);
					arStLocation.removeAt(1);
				}
			}
			else
			{
				Point3d ptMid = (arPt[0]+arPt[1])/2;
				if(el.vecY().dotProduct(ptMid - bm.ptCen()) < U(0))
				{
					arPt.removeAt(0);
					arStLocation.removeAt(0);
				}
				else
				{
					arPt.removeAt(1);
					arStLocation.removeAt(1);
				}
			}
			
			stCode.set(stTie);
	
			//_Map.setMap("mpProps", mapWithPropValues());
				

			//__Insert a fresh TSL
			TslInst tsl;
			String sScriptName = scriptName();
		
			Vector3d vecUcsX = _XW;
			Vector3d vecUcsY = _YW;
			Beam lstBeams[1];
			Entity lstEnts[1];
			Point3d lstPoints[1];
			int lstPropInt[0];
			double lstPropDouble[0];
			String lstPropString[3];
				
			lstEnts[0] = el;
			lstBeams[0] = bm;
			lstPropString[0] = stCode;
			lstPropString[2] = stInstall;
			
			for(int i=0; i<arPt.length();i++){
				lstPoints[0] = arPt[i];
				lstPropString[1] = arStLocation[i];
				tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,1,_Map );
			}
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
	
	if(_bOnElementListModified){
		for(int i=0;i<_Element.length();i++){
			ElementWall el=(ElementWall)_Element[i];
			if(!el.bIsValid())continue;
			
			if(el.vecX().dotProduct(el.ptStartOutline()-_Pt0) * el.vecX().dotProduct(el.ptEndOutline()-_Pt0) < U(0)){
				_Element[0]=el;
				_Element.setLength(1);
				break;
			}
		}
	}
	
	
	for(int y=_Beam.length() - 1;y>-1;y--)
	{
		if(!_Beam[y].bIsValid())_Beam.removeAt(y);
	}
	

//__Check Location
	PLine plEl = el.plEnvelope();
	Point3d arPt[] = plEl.intersectPoints(Plane(_Pt0,el.vecX()));
	arPt=Line(_Pt0,el.vecY()).orderPoints(arPt);
	
	if(arPt.length() != 2)
	{	
		//Try to fix for a wall
		ElementWallSF elW = (ElementWallSF)el;
		
		if(elW.bIsValid())
		{
			Point3d ptRefWall = elW.ptStartOutline();
			if( (_Pt0-ptRefWall).length() > (_Pt0-elW.ptEndOutline() ).length())ptRefWall = elW.ptEndOutline();
			_Pt0 = Line(_Pt0,el.vecX()).closestPointTo(ptRefWall);
			
			//Try again
			arPt = plEl.intersectPoints(Plane(_Pt0,el.vecX()));
			arPt=Line(_Pt0,el.vecY()).orderPoints(arPt);
		}
	}
	
	if(arPt.length() != 2)
	{
		//__Diplay an error
		Display dp(1);
		PLine plC;
		plC.createCircle(_Pt0,_ZW,U(3));
		Vector3d vLn(_YW-_XW);
		vLn.normalize();
		PLine plLn(_Pt0+U(3)*vLn,_Pt0-U(3)*vLn);
		dp.draw(plC);
		dp.draw(plLn);
		return;
	}	

//__Point and vector direction
	Point3d ptRef = arPt[0];
	Vector3d vIn=el.vecY();
	if(stLocation == arStLocation[0])
	{
		vIn = -vIn;
		ptRef = arPt[1];
	}
	
//__Fix _Pt0
	_Pt0 = Line(ptRef,el.vecZ()).intersect(Plane(el.ptOrg(),-el.vecZ()), el.dBeamWidth()/2);


//__Is it attached to a stud
	Beam bmAttached;
	
	if(_Beam.length() == 0 || _kNameLastChangedProp == "_Pt0" )
	{
		//__attach to a stud if one is in range
		Beam arBmVert[] = el.vecX().filterBeamsPerpendicularSort(arBm);
		
		double dNearestX = U(0), dNearestY = U(0);
		int iIndexNearest = -1;
		
		for(int i=0;i<arBmVert.length();i++)
		{
			Beam bm=arBmVert[i];
			bm.envelopeBody().vis(i);
			LineSeg ls(bm.ptCen()-bm.vecX()*bm.dL()/2, bm.ptCen()+bm.vecX()*bm.dL()/2);
			Point3d ptNear = ls.closestPointTo(_Pt0);
			
			double dx=abs(el.vecX().dotProduct(_Pt0-ptNear));
			double dy=abs(el.vecY().dotProduct(_Pt0-ptNear));
			
			if(i==0)
			{
				dNearestX = dx;
				dNearestY = dy;
				iIndexNearest=i;
				continue;
			}
			if(abs(dx - dNearestX) < U(0.125))
			{
				if(dNearestY > dy)
				{
					dNearestX = dx;
					dNearestY = dy;
					iIndexNearest=i;
					continue;
				}
				else
				{
					continue;
				}
			}
			if(dy > U(8))continue;
			if(dx<dNearestX)
			{
				dNearestX = dx;
				dNearestY = dy;
				iIndexNearest=i;
				continue;
			}
			break;
		}
		if(iIndexNearest > -1)bmAttached = arBmVert[iIndexNearest];
	}
	else
	{
		bmAttached = _Beam[0];
	}

//__Make sure the tie is centered on the stud
	if(bmAttached.bIsValid())
	{
		Line lnLocation(_Pt0,el.vecX()); 
		Line lnBm(bmAttached.ptCen(), bmAttached.vecX());
		LineSeg lsBm(bmAttached.ptCen()-bmAttached.vecX()*bmAttached.dL()/2, bmAttached.ptCen()+bmAttached.vecX()*bmAttached.dL()/2);
		double dRange = U(8);
		
		int bWasInRange = 0;
		
		if(bmAttached.vecX().isParallelTo(el.vecY()))
		{
			Point3d ptLocation = lnLocation.closestPointTo(lnBm);
			Point3d ptTest = lsBm.closestPointTo(ptLocation);
			double dd = (ptLocation-ptTest).length();
			if( dd < dRange)
			{
				_Pt0 = ptLocation;
				bWasInRange = 1;
			}
		}
		else
		{
			Point3d ptTest = lsBm.closestPointTo(_Pt0);
			Point3d ptLocation = lnLocation.closestPointTo(Line(ptTest,el.vecY()));
			double dd = (ptLocation-ptTest).length();
			if( dd < dRange)
			{
				_Pt0 = ptLocation;
				bWasInRange = 1;
			}
		}
		
		if(bWasInRange)
		{
			if(_Beam.length() ==0)_Beam.append(bmAttached);
			else if(_Beam[0] != bmAttached)_Beam[0] = bmAttached;
		}
	}			
//__Declaire displays
//__Create custom display
	Display dpModel(252), dpTop(252);
	if(stInstall == arStInstallation[1])
	{
		dpModel.color(226);
		dpTop.color(226);
	}
	dpModel.addHideDirection(_ZW);
	dpTop.addViewDirection(_ZW);
	dpTop.textHeight(U(.5));
	
	String stDisplayTop = "Engineering Components Top", stDisplayModel = "Engineering Components Model";
	String arListDisplays[]=_ThisInst.dispRepNames();
//	if(arListDisplays.find(stDisplayTop) > -1)dpTop.showInDispRep(stDisplayTop);
//	if(arListDisplays.find(stDisplayModel) > -1)dpModel.showInDispRep(stDisplayModel);
	
//__My Selected type
	int iType = arStCode.find(stCode);
	String stType = arStType[iType];
	String stCodeSelected = arStCode[iType];
	double dLength = arDLength[iType];
	double dWidth = U(1.25);
	double dThick = U(0.125);
	double dFlange = arDWidth[iType]+2*dThick;

//__Create the body
	Body bdFlange(_Pt0, el.vecZ(), vIn, el.vecX(), dFlange, dThick, dWidth, 0, -1, 0);
	Body bdLeg1(_Pt0+el.vecZ() * dFlange/2, el.vecZ(), vIn, el.vecX(), dThick, dLength, dWidth, -1, 1, 0);
	Body bdLeg2(_Pt0-el.vecZ() * dFlange/2, el.vecZ(), vIn, el.vecX(), dThick, dLength, dWidth, 1, 1, 0);
	
	bdFlange+=bdLeg1;
	bdFlange+=bdLeg2;
	
	dpModel.draw(bdFlange);
	
//__Plane Display
	PLine plRec;
	plRec.createRectangle(LineSeg(_Pt0-el.vecZ()*dFlange/2-el.vecX()*dWidth/2, _Pt0+el.vecZ()*dFlange/2+el.vecX()*dWidth/2), el.vecX(), el.vecZ());
	
	dpTop.draw(plRec);
	Vector3d vx = el.vecZ(), vy = el.vecX();
	if(vy.dotProduct(_YW) < 0)
	{
		vx=-vx;
		vy=-vy;
	}
	dpTop.draw(stCodeSelected,_Pt0, vx, vy, 0,0);
	
///__Layering
	String strPart1="X - Hardware",strPart2="X-Stud-Plate Ties";
	String stLevel = el.elementGroup().namePart(0);
	
	Group gr(strPart1,strPart2,"");
	if(!gr.bExists())gr.dbCreate();
	gr.setBIsDeliverableContainer(TRUE);
	gr.addEntity(_ThisInst,TRUE);	

	if(el.bIsValid())
	{
		if(stInstall == arStInstallation[1])assignToElementGroup(el,TRUE,0,'Z');
		else assignToElementGroup(el,TRUE,0,'I');
	}
	


//__Export
	dxaout("PipelineItem",1);
	dxaout("ItemType","Stud Plate Tie");
	dxaout("ItemDescription", stCodeSelected);
	dxaout("Quantity",1);
	dxaout("QuantityType","Each");
	dxaout("Dependency", el.number());
	dxaout("Notes",stType);
	dxaout("Length",dLength);
	dxaout("Width",dFlange);
	exportToDxi(TRUE);

	
		
	_ThisInst.setModelDescription(stCodeSelected);
	_ThisInst.setMaterialDescription(stType +" Stud Plate Tie");
	_ThisInst.setOriginator("RC Hardware");
	
	
//__Create data for BOM if neccessary
	if(stInstall == arStInstallation[1])
	{
		Map mp;
		mp.setPoint3d("ptLabel",_Pt0+vIn*dLength/2);
		mp.setString("stName",stCodeSelected);
		mp.setInt("iQty",1);
		_Map.setMap("mpPanelShop",mp);

	}
	else
	{
		_Map.removeAt("mpPanelShop",1);
		
	}	
	
	
	
	//Add Hadrware for export
HardWrComp arHwr[0];

HardWrComp hwr;
hwr.setName("SP CLIP");
hwr.setBVisualize(false);
hwr.setDescription("Stud Plate Tie");
hwr.setArticleNumber(stCodeSelected);
hwr.setModel(stType);
hwr.setQuantity(1);
hwr.setCountType("Amount");
hwr.setGroup(stLevel);
hwr.setDOffsetX(dLength);
hwr.setDOffsetY(dFlange);

arHwr.append(hwr);

_ThisInst.setHardWrComps(arHwr);
	
	
#End
#BeginThumbnail
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
=44`%%%%`!1110`4444`%%%%`!1110`4444`?_]E1
`



#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End