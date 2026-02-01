#Version 8
#BeginDescription
/// Version 1.0   th@hsbCAD.de   08.09.2010




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl displays and controls the grain direction of a panel. Alternatively it defines a potential display
/// of it's entities which are linked to a panel
/// </summary>

/// <insert Lang=en>
/// Select one or multiple sips to attach this tsl. alternativly select a shopdraw viewport to define it's display
/// with shopdrawings
/// </insert>

/// <property Dimstyle Lang=en>
/// The dimstyle controls the textstyle and size of all texts being displayed
/// </property>

/// <property Color Lang=en>
/// The color of the instance.
/// </property>

/// History
/// Version 1.0   th@hsbCAD.de   08.09.2010



// basics and props
	U(1,"mm");
	double dEps = U(.1);
	String sArNY[] = {T("|No|"),T("|Yes|")};
	PropString sShowBOM(1, sArNY, T("|Show List|"));	
	PropString sDimStyle(0, _DimStyles, T("Dimstyle"));		
	PropInt nColor(0,1, T("|Color|"));
	PropInt nColorPosNum(1,20, T("|Color|") + " " + T("|PosNum|"));
	PropInt nColorBackground(2,51, T("|Color|") + " " + T("|Background|") + T("|-2 = do not hide|"));
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

		// show the dialog if no catalog in use
		if (_kExecuteKey == "")
			showDialog();		
		// set properties from catalog		
		else	
			setPropValuesFromCatalog(_kExecuteKey);	
		
		
		Entity ents[0];
		_Entity.append(getShopDrawView());
		_Pt0 = getPoint();
		return;
	}	
//end on insert________________________________________________________________________________
	
// the view		
	ShopDrawView sdv;
	for (int i=0; i<_Entity.length(); i++)
	{
		if (_Entity[i].bIsKindOf(ShopDrawView()))
		{
			sdv = (ShopDrawView)_Entity[i];
			break;	
		}
	}
	reportNotice("Hello");
	
// the display	
	Display dp(nColorPosNum),dpSchedule(nColor);
	dp.dimStyle(sDimStyle);
	dpSchedule.dimStyle(sDimStyle);
	
// the box around the posnum
	PLine plPosNum(_ZW);
	Point3d ptPosNum = _Pt0;
	double dXBox, dYBox;
	{
		double dX = dp.textLengthForStyle("999",sDimStyle)*1.2;
		double dY = dp.textHeightForStyle("999",sDimStyle)*1.2;
			dXBox=dX;
			dYBox=dY;
		PLine pl(_ZW);
		pl.addVertex(_Pt0 - .5*_XW*dX-.4*_YW*dY);
		pl.addVertex(_Pt0 - .5*_XW*dX+.4*_YW*dY);
		pl.addVertex(_Pt0 - (.5*dX-.1*dY)*_XW+.5*_YW*dY,-.5);
		pl.addVertex(_Pt0 + (.5*dX-.1*dY)*_XW+.5*_YW*dY);	
		pl.addVertex(_Pt0 + .5*_XW*dX+.4*_YW*dY,-.5);
		pl.addVertex(_Pt0 + .5*_XW*dX-.4*_YW*dY);					
		pl.addVertex(_Pt0 + (.5*dX-.1*dY)*_XW-.5*_YW*dY,-0.5);
		pl.addVertex(_Pt0 - (.5*dX-.1*dY)*_XW-.5*_YW*dY);
		pl.addVertex(_Pt0 - .5*_XW*dX-.4*_YW*dY,-0.5);	
		pl.close();	
		pl.vis(1);
		plPosNum = pl;
	}


// get view data		
	int bError = 0; // 0 means FALSE = no error
	CoordSys ms2ps, ps2ms;
	if (!bError && !sdv.bIsValid()) bError = 1;
   
// interprete the list of ViewData in my _Map
	ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
	int nIndFound = ViewData().findDataForViewport(arViewData, sdv);// find the viewData for my view
	if (!bError && nIndFound<0) bError = 2; // no viewData found

	Entity entParent;
	MetalPartCollectionEnt mpcAr[0];
	if (!bError)
	{
		ViewData vwData = arViewData[nIndFound];
		ms2ps = vwData.coordSys(); // transformation to view

		// collect the entities of the view
			Entity entSdv[] = vwData.showSetDefineEntities();
			if (entSdv.length()>0)
				entParent = entSdv[0];
			else
				reportMessage(TN("|No define set found.|"));
			/*	
			for (int i=0;i<entSdv.length();i++)
			{
				if(entSdv[i].bIsKindOf(MetalPartCollectionEnt()))
				{
					MetalPartCollectionEnt mpc =(MetalPartCollectionEnt)entSdv[i];
					mpcAr.append(mpc);
				}
			}*/
	}
	
// declare varibale to count the lines to draw	
	int nLines =1;	
	
// collect potential metalPartCollectionEntities of a parent beam
	if (entParent.bIsKindOf(Beam()))
	{
		nLines++;
		Beam bm = (Beam)entParent;
		Entity entTools[] = bm.eToolsConnected();
		for (int t=0; t<entTools.length(); t++) 
		{
			
			if(entTools[t].bIsKindOf(MetalPartCollectionEnt()))
			{
				MetalPartCollectionEnt mpce = (MetalPartCollectionEnt)entTools[t];	
				mpcAr.append(mpce);
			}
		}// next t
	}	


// BOM data
	int nShowBOM = sArNY.find(sShowBOM);
	PlaneProfile ppProtect;

	Vector3d vx = _XW, vy=_YW,vz=_ZW;
	if (nShowBOM)
	{
		
	// make sure we have at least one grip with an x offset to _Pt0
		if (_PtG.length()<1)
			_PtG.append(_Pt0+_XW*U(1000));	
			
	// relocate 
		_PtG[0] = _PtG[0]-_YW*_YW.dotProduct(_PtG[0]-_Pt0)-_ZW*_ZW.dotProduct(_PtG[0]-_Pt0);	
			
	// column definitions NOTE: all arrays must be of same length
		double dColWidth[] = {U(50),U(100),U(80),U(80),U(80),
									 U(80),U(80),U(80),U(80)};
		String sColHeader[] = {T("|Pos|"),T("|Name|"),T("|Qty|"),T("|Profile|"),T("|Material|"),
			T("|Length|"),T("|Width|"),T("|Height|"),T("|Weight|")};	
		String sColParentHeader[] = {T("|Allgemein|"),T("|Allgemein|"),T("|Flooring|"),T("|Flooring|"),T("|Flooring|"),
									  T("|Flooring|"),T("|Flooring|"),T("|Wall|"),T("|Wall|"),T("|Wall|"),
									  T("|Ceiling|"),T("|Ceiling|"),T("|Ceiling|"), T("|Kubatur|")};	
		int nColDataIndex[] = {0,1,2,3,4,5,6,7,8};	
		
	// flag a  column which is not desired by -1
		int nColIndex[] = {0,1,2,3,4,5,6,7,8};		
		
	// order column definitions by index (by now the index is hardcoded, but maybe not in the future
		for (int i=0;i<nColIndex.length();i++)
		{
			for (int j=0;j<nColIndex.length()-1;j++)	
			{
				if (nColIndex[j]>nColIndex[j+1])
				{
					dColWidth.swap(j,j+1);
					sColHeader.swap(j,j+1);
					//sColParentHeader.swap(j,j+1);
					nColIndex.swap(j,j+1);		
					nColDataIndex.swap(j,j+1);
				}
			}
		}		
		
	// get max width
		double dMaxWidth;
		for (int i=0;i<nColIndex.length();i++)
			if (nColIndex[i]>-1)
			{
				dMaxWidth+=dColWidth[i];		
			}
	
	// brut width
		double dWidthGross = _XW.dotProduct(_PtG[0]-_Pt0);
		double dFactor = dWidthGross/dMaxWidth;
		
	
		double dLf = U(15)*dFactor;
		double dTxtH = dLf*.3;
		dpSchedule.textHeight(dTxtH);		
		
		PLine plRec(vz);

	// count lines to draw	
		for (int i=0;i<mpcAr.length();i++)
		{
			nLines ++;
			CoordSys cs = mpcAr[i].coordSys();
			MetalPartCollectionDef mpd = mpcAr[i].definition();
			Beam bm[] = mpd.beam();
			for (int b=0;b<bm.length();b++)
				if (!bm[b].bIsDummy())
					nLines++;
		}	

		
	// draw header
		double dX,dY=dLf;
		Point3d ptRef = _Pt0 + vy*dLf*nLines;
		Point3d ptRef2 = _Pt0+ vy*dLf*nLines;
		for (int i=0;i<nColIndex.length()-1;i++)
		{
			if (nColIndex[i]<0){continue;}
	
			int bDraw;
			if (dX==0)
			{	
				dX=dColWidth[i];
				//if (sColParentHeader[i]!=sColParentHeader[i+1])
				//	bDraw=true;
			}
			//else if (sColParentHeader[i]==sColParentHeader[i+1])
			//{
			//	dX+=dColWidth[i];
			//}
			else
			{
				dX+=dColWidth[i];
				bDraw=true;
			}
		
		// draw parent header		
			if(0)//bDraw)
			{ 
				dX*=dFactor;
				LineSeg ls(ptRef,ptRef+vx*dX-vy*dY);
				ls.ptMid().vis(i);
				ptRef.transformBy(vx*dX);
				
				plRec.createRectangle(ls,vx,vy);
				//dpPlan.draw(plRec);
				//dpPlan.draw(sColParentHeader[i],ls.ptMid(),vx,vy,0,0);	
				dpSchedule.draw(plRec);
				dpSchedule.draw(sColParentHeader[i],ls.ptMid(),vx,vy,0,0);	
				dX=0;
			}
			{
				LineSeg ls(ptRef2,ptRef2+vx*dColWidth[i]*dFactor-vy*dY);
				//ls.transformBy(-vy*dLf);
				plRec.createRectangle(ls,vx,vy);
				//dpPlan.draw(plRec);
				//dpPlan.draw(sColHeader[i],ls.ptMid(),vx,vy,0,0);	
				dpSchedule.draw(plRec);
				dpSchedule.draw(sColHeader[i],ls.ptMid(),vx,vy,0,0);
				ptRef2.transformBy(vx*dColWidth[i]*dFactor)	;		
			}
			
		// draw last parent header		
			if (i==nColIndex.length()-2)
			{
				dX+=dColWidth[i+1]*dFactor;
				LineSeg ls(ptRef,ptRef+vx*dX-vy*dY);
				ls.ptMid().vis(i+1);
				ptRef.transformBy(vx*dX*dFactor);
				
				plRec.createRectangle(ls,vx,vy);
				
				//dpPlan.draw(plRec);
				//dpPlan.draw(sColParentHeader[i+1],ls.ptMid(),vx,vy,0,0);	
				//dpSchedule.draw(plRec);
				//dpSchedule.draw(sColParentHeader[i+1],ls.ptMid(),vx,vy,0,0);	
				
				dX=0;
				
				{
				LineSeg ls(ptRef2,ptRef2+vx*dColWidth[i+1]*dFactor-vy*dY);
				//ls.transformBy(-vy*dLf);
				plRec.createRectangle(ls,vx,vy);
				
				//dpPlan.draw(plRec);
				//dpPlan.draw(sColHeader[i+1],ls.ptMid(),vx,vy,0,0);	
				dpSchedule.draw(plRec);
				dpSchedule.draw(sColHeader[i+1],ls.ptMid(),vx,vy,0,0);				
				
				ptRef2.transformBy(vx*dColWidth[i+1])	;		
				}
				
			}		
		}

	// draw data
		ptRef = _Pt0-vy*dLf+ vy*dLf*nLines;
		ptRef.vis(3);
		double ddX = dTxtH;
		double dTotals[nColIndex.length()];		
		
		dTxtH = dLf*.6;
		dpSchedule.textHeight(dTxtH);	
		
		
	// loop all mps's and label content
		Entity entAr[0];
		if (entParent.bIsKindOf(Beam()))
			entAr.append(entParent);
			
		for (int i=0;i<mpcAr.length();i++)
		{
			CoordSys cs = mpcAr[i].coordSys();
			MetalPartCollectionDef mpd = mpcAr[i].definition();
			Beam bm[] = mpd.beam();

			entAr.append(mpcAr[i]);	
						
		// add posnum label	
			for (int b=0;b<bm.length();b++)
			{	
				if (bm[b].bIsDummy())continue;	
				entAr.append(bm[b]);
				Point3d pt = bm[b].ptCen();
				pt.transformBy(cs);
				pt.transformBy(ms2ps);

				plPosNum.transformBy(pt-ptPosNum);
				ptPosNum.transformBy(pt-ptPosNum);	
							
			// test interference
				PlaneProfile ppTest = ppProtect;	
				PlaneProfile ppPos(plPosNum);
				int n;
				int bDrawGuide;
				ppPos.intersectWith(ppTest);
				while (n<40 && ppPos.area()>pow(dEps,2))
				{
					bDrawGuide=true;
					n++;
					plPosNum.transformBy(bm[b].vecX()*.5*dXBox);
					ptPosNum.transformBy(bm[b].vecX()*.5*dXBox);
					ppPos = PlaneProfile(plPosNum);	
					ppPos.intersectWith(ppTest);
				}
				ppProtect.unionWith(PlaneProfile(plPosNum));

				if (nColorBackground>-2)
				{
					dp.color(nColorBackground);
					dp.draw(PlaneProfile(plPosNum),_kDrawFilled);
					dp.color(nColorPosNum);
				}
				else
					dp.draw(PlaneProfile(plPosNum),_kDrawAsShell);
					
				// draw guide
				if (bDrawGuide)
					dp.draw(PLine(pt,plPosNum.closestPointTo(pt)));		
				dp.draw(plPosNum);
				dp.draw(bm[b].posnum(),ptPosNum,_XW,_YW,0,0,_kDeviceX);
				
				if (i>0 && bm[b]==entParent)continue;
			}
			

			
			for (int e=0;e<entAr.length();e++)
			{
				if (i>0 && entAr[e]==entParent)continue;
				int nThisType;
				if (entAr[e].bIsKindOf(Beam()))
					nThisType =1;
				else if (entAr[e].bIsKindOf(MetalPartCollectionEnt()))
					nThisType =2;
				Beam bmThis = (Beam)entAr[e];		
				
				
				for (int j=0;j<nColIndex.length();j++)
				{
					if (nColIndex[j]<0){continue;}		
					double dX = dColWidth[j]*dFactor;
					LineSeg ls(ptRef,ptRef+vx*dX-vy*dY);
					double dFlagX = 1;
					String s;
					double d;
					Point3d pt;

				// pos	
					if (nColDataIndex[j]==0)
					{
						if (nThisType==1)
						{
							s=bmThis.posnum();
							if (s.length()<2) s="0"+s;
							if (s.length()<3) s="0"+s;							
						}
						else		s = "";
						dFlagX = 0;
						pt = ls.ptMid();	
					}
				// name	
					else if (nColDataIndex[j]==1)
					{
						if (nThisType==1) 			s=bmThis.name();
						else if (nThisType==1)		s = mpd.entryName();
						pt = ptRef-vy*.5*dY + vx*ddX;	
					}
				// qty	
					else if (nColDataIndex[j]==2)
					{
						if (nThisType==1) 			s=99;
						else if (nThisType==2)		s = 1;
						dFlagX = 0;
						pt = ptRef-vy*.5*dY + vx*ddX;	
					}
				// profile	
					else if (nColDataIndex[j]==3)
					{
						if (nThisType==1) s=bmThis.extrProfile();
						else		s = "";
						pt = ptRef-vy*.5*dY + vx*ddX;	
					}
				// material	
					else if (nColDataIndex[j]==4)
					{
						if (nThisType==1) s=bmThis.material();
						else		s = "";
						pt = ptRef-vy*.5*dY + vx*ddX;	
					}
				// Length	
					else if (nColDataIndex[j]==5)
					{
						if (nThisType==1) d=bmThis.solidLength();
						else		d = U(999);
						s.formatUnit(d,2,0);
						pt = ptRef-vy*.5*dY + vx*(dX-ddX);
						dFlagX = -1;	

					}					
				// Width	
					else if (nColDataIndex[j]==6)
					{
						if (nThisType==1) d=bmThis.solidWidth();
						else		d = U(999);
						s.formatUnit(d,2,0);
						pt = ptRef-vy*.5*dY + vx*(dX-ddX);
						dFlagX = -1;	

					}
				// Height	
					else if (nColDataIndex[j]==7)
					{
						if (nThisType==1) d=bmThis.solidHeight();
						else		d = U(999);
						s.formatUnit(d,2,0);
						pt = ptRef-vy*.5*dY + vx*(dX-ddX);
						dFlagX = -1;	

					}
				// Weight	
					else if (nColDataIndex[j]==8)
					{
						d = entAr[e].realBody().volume()* pow(10,-9)*1000;
						dTotals[j]+=d;
						s.formatUnit(d,2,2);
						pt = ptRef-vy*.5*dY + vx*(dX-ddX);
						dFlagX = -1;	
					}					
					plRec.createRectangle(ls,vx,vy);
					
					//dpPlan.draw(s,pt,vx,vy,dFlagX,0);
					//dpPlan.draw(plRec);			
					dpSchedule.draw(s,pt,vx,vy,dFlagX,0);
					dpSchedule.draw(plRec);
								
				// col feed
					ptRef.transformBy(vx*dX);	
				}// next j
				ptRef.transformBy(-vy*dLf);
				ptRef.transformBy(vx*vx.dotProduct(_Pt0-ptRef));
			}// next e
		}				
	}
// END BOM DATA__________________________________________________________________________________________________________________

	// no BOM
	else
	{
	// loop all mps's and label content
		PlaneProfile ppProtect;
		for (int i=0;i<mpcAr.length();i++)
		{
			CoordSys cs = mpcAr[i].coordSys();
			MetalPartCollectionDef mpd = mpcAr[i].definition();
			Beam bm[] = mpd.beam();
		// add posnum label	
			for (int b=0;b<bm.length();b++)
			{	
				if (bm[b].bIsDummy())continue;	
				Point3d pt = bm[b].ptCen();
				pt.transformBy(cs);
				pt.transformBy(ms2ps);

				plPosNum.transformBy(pt-ptPosNum);
				ptPosNum.transformBy(pt-ptPosNum);	
							
			// test interference
				PlaneProfile ppTest = ppProtect;	
				PlaneProfile ppPos(plPosNum);
				int n;
				int bDrawGuide;
				ppPos.intersectWith(ppTest);
				while (n<40 && ppPos.area()>pow(dEps,2))
				{
					bDrawGuide=true;
					n++;
					plPosNum.transformBy(sdv.coordSys().vecX()*.5*dXBox);
					ptPosNum.transformBy(sdv.coordSys().vecX()*.5*dXBox);
					ppPos = PlaneProfile(plPosNum);	
					ppPos.intersectWith(ppTest);
				}
				ppProtect.unionWith(PlaneProfile(plPosNum));

				if (nColorBackground>-2)
				{
					dp.color(nColorBackground);
					dp.draw(PlaneProfile(plPosNum),_kDrawFilled);
					dp.color(nColorPosNum);
				}
				else
					dp.draw(PlaneProfile(plPosNum),_kDrawAsShell);
					
				// draw guide
				if (bDrawGuide)
					dp.draw(PLine(pt,plPosNum.closestPointTo(pt)));		
				dp.draw(plPosNum);
				dp.draw(bm[b].posnum(),ptPosNum,_XW,_YW,0,0,_kDeviceX);
				
				if (i>0 && bm[b]==entParent)continue;
			}
			
		}	
	}


// debug
	if (mpcAr.length()<1)
	{
		dp.draw(PLine(sdv.coordSys().ptOrg(), _Pt0));	
		dp.draw(scriptName(),_Pt0,_XW,_YW,0,0,_kDeviceX);
		
	}	


	
	


#End
#BeginThumbnail


#End
