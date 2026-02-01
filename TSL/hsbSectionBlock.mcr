#Version 8
#BeginDescription

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
// basics and props
	U(1,"mm");
	double dEps = U(.1);
	
	PropString sViewNr(1, "A", T("View Number"));	
	PropDouble dScale(0,1,T("Scale of Symbol"));	
	
	PropString sDimStyle(0,_DimStyles,T("Dimstyle"));		
	PropInt nColor (0,145,T("Color"));
	reportMessage("\nexceutingTsl execution: " +scriptName() );
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();
		// selection set		
		PrEntity ssE(T("|Select Entities|") + " " + T("|(Solids or shopdraw views)|"), Entity());
		Entity ents[0];
  		if (ssE.go())
    		ents = ssE.set();

	// collect sset
		Entity entArSolids[0], entArViews[0];
		for (int i = 0; i < ents.length(); i++)
		{
			if (ents[i].realBody().volume() > pow(dEps,3)) 
			{
				if(ents[i].bIsKindOf(GenBeam()))
					_GenBeam.append((GenBeam)ents[i]);
				entArSolids.append(ents[i]);
			}	
			else if (ents[i].bIsKindOf(ShopDrawView()))
				entArViews.append(ents[i]);
		}	
		
	// toggle mode
		int nMode;
		if (entArViews.length()>0)
		{
			nMode=1;
			_Entity.append(entArViews);
			_Pt0 = getPoint();
		}	
		else
		{
			_Entity.append(entArSolids);
		// get section line
			_PtG.append(getPoint(T("|Select first point of section line|")));
			Point3d ptLast = _PtG[0];
			while (_PtG.length() < 2) 
			{
				PrPoint ssP2("\n" + T("|Select second point of section line|"),ptLast);
				if (ssP2.go()==_kOk) { // do the actual query
			      ptLast = ssP2.value(); // retrieve the selected point
			      _PtG.append(ptLast); // append the selected points to the list of grippoints _PtG
					// relocate _Pt0 
					_Pt0 = (_PtG[0]+_PtG[1])/2;
			  	}
		  		else  // no proper selection
		     		break; // out of infinite while
			}
			
			PrPoint ssP("\n" + T("|Select direction|"),_PtG[_PtG.length()-1]);
			if (ssP.go()==_kOk)
			      _PtG.append(ssP.value()); 
		}
		return;
	}


// collect sset
	Entity entArViews[0];
	for (int i = 0; i < _Entity.length(); i++)
	{
		if (_Entity[i].bIsKindOf(ShopDrawView()))
			entArViews.append(_Entity[i]);
	}	
	
// detect mode
	int nMode;
	if (entArViews.length()>0)
		nMode=1;	


// section mode
	if (nMode==0)
	{
	
	// validate
		if (_PtG.length()<2)
		{
			eraseInstance();
			return;	
		}
	
	// get coordSys from grips
		Vector3d vx = _PtG[1]-_PtG[0]; vx.normalize();
		Vector3d vz = _PtG[2]-_PtG[1]; vz.normalize();	
		Vector3d vy	= vx.crossProduct(-vz);vy.normalize();
		vz = vx.crossProduct(vy);
		vx.vis(_Pt0,1);
		vy.vis(_Pt0,3);
		vz.vis(_Pt0,150);
		
	// store the coordSys in map to be used in a shopdraw view
		_Map.setVector3d("vx", vx);
		_Map.setVector3d("vy", vy);
		_Map.setVector3d("vz", vz);
		
	
	// section depth
		double dX= vx.dotProduct(_PtG[1]-_PtG[0]);	 	
		double dY= U(20000);	 
		double dZ= vz.dotProduct(_PtG[2]-_Pt0);
		if (dZ<dEps) dZ =U(1);
		
	// the section body		 	
		Body bdSectionQuader(_Pt0,vx,vy,vz,dX,dY,dZ,0,0,1);
		bdSectionQuader.vis(1);
		double dVolumeGros = bdSectionQuader.volume();
		Body bdSection;
		
	// collect the entities to be visualized
		for (int i=0;i<_Entity.length();i++)
		{
			Entity ent = _Entity[i];
			Body bdThis = ent.realBody();
			//PLine(bdThis.ptCen(),_Pt0).vis(3);
			if (bdThis.volume()>pow(dEps,3) && bdSectionQuader.hasIntersection(bdThis))
			{
				Body bdTempQuader= bdSectionQuader;
				bdThis.intersectWith(bdTempQuader);
	
				if (bdSection.volume()<pow(dEps,3))
					bdSection=bdThis;
				else if (bdThis.volume()>pow(dEps,3))
					bdSection.addPart(bdThis);			
			}
		}	
		
		
	// Display
		Display dp(nColor);
		dp.dimStyle(sDimStyle);
		dp.draw(scriptName(),_Pt0,vx,vy,1,0);	
		dp.draw(bdSection);		
	
	
	// Symbols
		if(1)
		{
			Map mapChild, mapSymbol;
			
			double dTxtL=  dp.textLengthForStyle(sViewNr ,sDimStyle)*2;
			double dW = sqrt(2*pow(dTxtL*1.05,2));
			Point3d pt = _PtG[0]-vz*dW;
			// createposnum mask
			PLine plPosNum(vy);
			plPosNum.createCircle(pt,vy,dTxtL);
	
			PLine plArrow(vy);		
			plArrow.addVertex(pt - vx*dW); 
			plArrow.addVertex(pt + vz*dW); 
			plArrow.addVertex(pt + vx*dW); 
			plArrow.addVertex(pt+vx*(dTxtL));
			plArrow.addVertex(pt-vx*(dTxtL),pt+vz*(dTxtL));				
			plArrow.close();
			
		// first grip
			dp.draw(sViewNr,pt,vx,vz,0,0);
			dp.draw(plPosNum);		
			dp.draw(PlaneProfile(plArrow),_kDrawFilled);
			
			mapChild= Map();
			mapChild.setString("text", sViewNr);
			mapChild.setPoint3d("ptOrg", pt);
			mapChild.setDouble("xFlag", 0);
			mapChild.setDouble("yFlag", 0);
			mapChild.setInt("color", nColor);
			mapSymbol.appendMap("childSymbol",mapChild);	
	
			mapChild= Map();
			mapChild.setPLine("pline", plPosNum);
			mapChild.setInt("color", nColor);;
			mapSymbol.appendMap("childSymbol",mapChild);
	
			mapChild= Map();
			mapChild.setPLine("pline", plArrow);
			//mapChild.setString("hatch", "SOLID");
			//mapChild.setDouble("hatchScale", 1);
			//mapChild.setDouble("hatchAngle", 0);
			mapChild.setInt("color", nColor);;
			mapSymbol.appendMap("childSymbol",mapChild);
	
		// second grip
			Vector3d vxTrans = _PtG[1]-_PtG[0];
			plArrow.transformBy(vxTrans );
			plPosNum.transformBy(vxTrans);
			pt.transformBy(vxTrans);		
			dp.draw(sViewNr,pt,vx,vz,0,0);
			dp.draw(plPosNum);		
			dp.draw(PlaneProfile(plArrow),_kDrawFilled);
			
			mapChild= Map();
			mapChild.setString("text", sViewNr);
			mapChild.setPoint3d("ptOrg", pt);
			mapChild.setDouble("xFlag", 0);
			mapChild.setDouble("yFlag", 0);		
			mapChild.setInt("color", nColor);
			mapSymbol.appendMap("childSymbol",mapChild);	
	
			
			mapChild= Map();
			mapChild.setPLine("pline", plPosNum);
			mapChild.setInt("color", nColor);;
			mapSymbol.appendMap("childSymbol",mapChild);	
			
			mapChild= Map();
			mapChild.setPLine("pline", plArrow);
			//mapChild.setString("hatch", "SOLID");
			//mapChild.setDouble("hatchScale", 1);
			//mapChild.setDouble("hatchAngle", 0);
			mapChild.setInt("color", nColor);;
			mapSymbol.appendMap("childSymbol",mapChild);
		
			
	
		// section line
			dp.lineType(T("|Strichpunkt|"));
			PLine plSection(_PtG[0],_PtG[1]);
			dp.draw(plSection);	
			mapChild= Map();
			mapChild.setPLine("pline", plSection);
			mapChild.setString("lineType", T("|Strichpunkt|"));
			mapChild.setInt("color", nColor);;
			mapSymbol.appendMap("childSymbol",mapChild);
	
		// the coordSys of the symbol
			Map mapCoord;
			mapCoord.setPoint3d("_Pt0",_Pt0);
			mapCoord.setVector3d("vx",vx);
			mapCoord.setVector3d("vy",vz);
			mapCoord.setVector3d("vz",vy);
			mapCoord.setVector3d("vecView",vy);
			mapSymbol.setMap("coordSys",mapCoord);	
			_Map.setMap("Symbol[]", mapSymbol);	
		}
	}// END IF section mode
	
	
//___________________________________________________________________________________________________________________________
//shopdraw view mode
	else if (nMode==1)
	{
		Display dp(1);
		
		//if (nDebug>0)
		reportMessage("\nTsl execution: " +scriptName() + ": " + _kExecuteKey + " - " + _bOnGenerateShopDrawing );
		addRecalcTrigger(_kShopDrawEvent, _kShopDrawViewDataShowSet );
		

	// on generation		
		if (_bOnGenerateShopDrawing && _kExecuteKey==_kShopDrawViewDataShowSet ) 
		{	
			// interprete the list of ViewData in my _Map
			ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,2); // 2 means verbose
			
			// use the first entity / ShopDrawView for defining the show set from the define set.
			Entity entView = _Entity[0];
				
			int nIndFound = ViewData().findDataForViewport(arViewData, entView);// find the viewData for my view
			
			Entity entDefine;
			Entity entsShowSet[0];
			if (nIndFound>=0) { // my entView its viewdata is found at index nIndFound
				ViewData vwData = arViewData[nIndFound];
				Entity ents[] = vwData.showSetDefineEntities();
				entsShowSet = vwData.showSetEntities();
				if (ents.length()==1) // in case there is only one entity
					entDefine = ents[0];
				
				for (int t=0; t<entsShowSet .length(); t++)	
					reportNotice("\n" + entsShowSet[t].typeDxfName() );
					
			}
			
			if (!entDefine.bIsValid()) {
				reportMessage("\nError in "+scriptName()+": no define set entity found.");
			}
			else
			{
				String sName = "not a tsl";
				if (entDefine.bIsKindOf(TslInst()))
				{
					TslInst tslThis = (TslInst)entDefine;
					sName = tslThis.scriptName();	
					
				}
				reportMessage("\ndefine set is: " + entDefine.typeDxfName() + " " + sName);
			}
			
			
			TslInst tslDefine = (TslInst )entDefine;
			if (!tslDefine.bIsValid()) {
				reportMessage("\nError in "+scriptName()+": define set entity is not a TslInstance.");
			}
			Map mapTsl = tslDefine.map();
			
		// there was one entity, and this one entity is a MetalPartCollectionEnt
//			else 
			{ 
				// reset the the existing showset and replace by a potential section
//				MetalPartCollectionDef mpcd = mpce.definition();
//				CoordSys csMpc=mpce.coordSys();

//				TslInst tslAr[] = mpcd.tslInst();
				entsShowSet.setLength(0);
				entsShowSet.append(entDefine);
				/*
				for (int t=0; t<tslAr.length(); t++)
				{
					TslInst tsl = tslAr[t];
					if (tsl.scriptName()!=scriptName())
					{
						 continue;
					}
					else
					{
						//tsl.transformBy(csMpc);
						entsShowSet.append(tsl);
					}
					
				// hatch me, cannot be done here!!! move outside _kGenerateShop
					Vector3d vx = tsl.map().getVector3d("vx");
					Vector3d vy = tsl.map().getVector3d("vy");
					Vector3d vz = tsl.map().getVector3d("vz");			
					dp.draw(PLine(_PtW,tsl.ptOrg(),tsl.ptOrg()+vx*U(100) + vy*U(200)) );
					
					
					
					//reportNotice("\n we found a showset of " +entsShowSet.length() );
				}
				*/
				
				
				String strViewData = "ViewData";
				
				// now loop over all the ShopDrawViews and append a map to _Map for each
				int bError;
				for (int e=0; e<_Entity.length(); e++) 
				{
					ShopDrawView sdv = (ShopDrawView)_Entity[e];
					if (!sdv.bIsValid())
						continue;
						
					
					// interprete the list of ViewData in my _Map
					ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
					int nIndFound = ViewData().findDataForViewport(arViewData, sdv);// find the viewData for my view
					if (!bError && nIndFound<0) bError = 2; // no viewData found
					
					String strViewHandle = sdv.handle();
		

				// Compose map for view manipulation, adjust the coordSys set for the view and the showSet
					Map mpViewData;
					// add view identification
					mpViewData.setString("ViewHandle",strViewHandle);

				// add a modified orientation of the view window				
					if (mapTsl.hasVector3d("vecXW"))
					{	
						mpViewData.setVector3d("vecXW",tslDefine.coordSys().vecX());
						mpViewData.setVector3d("vecYW",tslDefine.coordSys().vecY());
						mpViewData.setVector3d("vecZW",tslDefine.coordSys().vecZ());					
						/*mpViewData.setVector3d("vecXW",mapTsl.getVector3d("vecXW"));
						mpViewData.setVector3d("vecYW",mapTsl.getVector3d("vecYW"));
						mpViewData.setVector3d("vecZW",mapTsl.getVector3d("vecZW"));	*/				
					}
					else
					{					
						mpViewData.setVector3d("vecXW",tslDefine.coordSys().vecX());
						mpViewData.setVector3d("vecYW",tslDefine.coordSys().vecY());
						mpViewData.setVector3d("vecZW",tslDefine.coordSys().vecZ());
					}
					// add a modified location of the view window
					mpViewData.setPoint3d("ptOrgW",tslDefine.ptOrg());


					// add new show set
					mpViewData.setEntityArray(entsShowSet, TRUE, "Handle[]", "showSetEntities", "han");

					// now add ViewData[]\\ViewData to _Map
					_Map.appendMap(_kShopDrawViewDataShowSet + "\\" + strViewData + "[]" + "\\" + strViewData, mpViewData); // add to _Map with special key
				}
			}// END IF  this one entity is a genbeam

			
		// for debugging export map
			_Map.writeToDxxFile(_kPathDwg+"\\"+_kShopDrawViewDataShowSet +"_" + scriptName() +".dxx",FALSE);
		}// END IF (_bOnGenerateShopDrawing && _kExecuteKey==_kShopDrawViewDataShowSet )


		// do not draw anything during shopdraw generation
		if (_bOnGenerateShopDrawing==TRUE) 
		{ 
			return;
		}
		
	// display in normal block mode
		// visualize the link to the viewport

		
		for (int e=0; e<_Entity.length(); e++) 
		{
			ShopDrawView sdv = (ShopDrawView)_Entity[e];
			if (!sdv.bIsValid())		continue;
			Point3d pt = (_Pt0+sdv.coordSys().ptOrg())/2;
			PLine pl(_ZW);
			pl.addVertex(_Pt0);
			pl.addVertex(_Pt0-_YW*_YW.dotProduct(_Pt0-pt));
			pl.addVertex(pt);
			pl.addVertex(sdv.coordSys().ptOrg());
			
			dp.draw(pl);	
		}
		dp.draw(scriptName() + " " + T("|defines these views|"), _Pt0, _YW,-_XW, 1,-1.2,_kDevice );
		dp.draw(T("|to display linked TslSection Entities|"), _Pt0, _YW,-_XW, 1,-4.2,_kDevice );	
		
	}// end if shopdraw view mode
	
	
	
	
	

			
#End
#BeginThumbnail

#End
