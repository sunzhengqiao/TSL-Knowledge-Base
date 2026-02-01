#Version 8
#BeginDescription
#Versions
Version 1.2 21.01.2025 HSB-22556 alignment properties only visible if selected
Version 1.1 08.01.2025 HSB-21565 new property to filter certain dimline alignments
Version 1.0 07.01.2025 HSB-21565 initial version of MultipageController

This tsl creates purges and or realigns existing dimlines of a multipage
Choose either multipages or dimension lines of a multipage.
Alternatively, select the insert option in the block space of a multipage in order to configure it for every newly created shop drawing.


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.2 21.01.2025 HSB-22556 alignment properties only visible if selected , Author Thorsten Huck
// 1.1 08.01.2025 HSB-21565 new property to filter certain dimline alignments , Author Thorsten Huck
// 1.0 07.01.2025 HSB-21565 initial version of MultipageController , Author Thorsten Huck

/// <insert Lang=en>
/// Choose either multipages or dimension lines of a multipage. Alternatively, select the insert option in the block space of a multipage in order to configure it for every newly created shop drawing.
/// </insert>

// <summary Lang=en>
// This tsl creates purges and or realigns existing dimlines of a multipage
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "MultipageController")) TSLCONTENT
//endregion



//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String tDefault =T("|_Default|");
	String tLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String tNo = T("|No|"), tYes = T("|Yes|");
	String sNoYes[] = { tNo, tYes};

	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";

//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	
	
	
	String kScriptDimline = "DimLine", kIsLocal = "IsLocal";
	
	String tFAny = T("<|Any|>"), tFBottom = T("|Bottom|"), tFTop= T("|Top|"), tFHorizontal= T("|Horizontal|"),
		tFLeft = T("|Left|"), tFRight = T("|Right|"), tFVertical = T("|Vertical|"), tFAligned = T("|Aligned|");
	
//end Constants//endregion

//region Functions #FU


//region ArrayToMapFunctions

	//region Function GetDoubleArray
	// returns an array of doubles stored in map
	double[] GetDoubleArray(Map mapIn, int bSorted)
	{ 
		double values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasDouble(i))
				values.append(mapIn.getDouble(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetDoubleArray
	// sets an array of doubles in map
	Map SetDoubleArray(double values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendDouble(key, values[i]);	
		return mapOut;
	}//endregion

	//region Function GetStringArray
	// returns an array of doubles stored in map
	String[] GetStringArray(Map mapIn, int bSorted)
	{ 
		String values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasString(i))
				values.append(mapIn.getString(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetStringArray
	// sets an array of strings in map
	Map SetStringArray(String values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendString(key, values[i]);	
		return mapOut;
	}//endregion

	//region Function GetIntArray
	// returns an array of doubles stored in map
	int[] GetIntArray(Map mapIn, int bSorted)
	{ 
		int values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasInt(i))
				values.append(mapIn.getInt(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetIntArray
	// sets an array of ints in map
	Map SetIntArray(int values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendInt(key, values[i]);	
		return mapOut;
	}//endregion

	//region Function GetBodyArray
	// returns an array of bodies stored in map
	Body[] GetBodyArray(Map mapIn)
	{ 
		Body bodies[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasBody(i))
				bodies.append(mapIn.getBody(i));
	
		return bodies;
	}//endregion

	//region Function SetBodyArray
	// sets an array of bodies in map
	Map SetBodyArray(Body bodies[])
	{ 
		Map mapOut;
		for (int i=0;i<bodies.length();i++) 
			mapOut.appendBody("bd", bodies[i]);	
		return mapOut;
	}//endregion

	//region Function GetPlaneProfileArray
	// returns an array of PlaneProfiles stored in map
	PlaneProfile[] GetPlaneProfileArray(Map mapIn)
	{ 
		PlaneProfile pps[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasPlaneProfile(i))
				pps.append(mapIn.getPlaneProfile(i));
	
		return pps;
	}//endregion

	//region Function SetPlaneProfileArray
	// sets an array of PlaneProfiles in map
	Map SetPlaneProfileArray(PlaneProfile pps[])
	{ 
		Map mapOut;
		for (int i=0;i<pps.length();i++) 
			mapOut.appendPlaneProfile("pp", pps[i]);	
		return mapOut;
	}//endregion

//End ArrayToMapFunctions //endregion 	 	

//region Function FilterDimlineByOrientation
	// filters dimlines by their orientation
	void FilterDimlineByOrientation(TslInst& tslDims[], String filter)
	{ 
		TslInst out[0];
		
		for (int i=0;i<tslDims.length();i++) 
		{ 
			TslInst& t= tslDims[i]; 
			Map m = t.map();
			Vector3d vecDir = m.getVector3d("vecDir");
			Vector3d vecPerp = m.hasVector3d("vecSide")?-m.getVector3d("vecSide"):m.getVector3d("vecPerp");//
			if (vecDir.bIsZeroLength())
				vecDir = vecPerp.crossProduct(_ZW);
			else if (vecPerp.bIsZeroLength())
				vecPerp = vecDir.crossProduct(-_ZW);
			vecPerp.vis(t.ptOrg(), 6);
			
			int bIsHorizontal = vecDir.isParallelTo(_XW);
			int bIsVertical = vecDir.isParallelTo(_YW);
			int bIsBottom = vecPerp.isCodirectionalTo(_YW);
			int bIsTop = vecPerp.isCodirectionalTo(-_YW);
			int bIsLeft = vecPerp.isCodirectionalTo(_XW);
			int bIsRight = vecPerp.isCodirectionalTo(-_XW);
	
			int bAccepted = filter==tFAny;
			if (filter == tFHorizontal && bIsHorizontal)bAccepted = true;
			else if (filter == tFBottom && bIsHorizontal && bIsBottom)bAccepted = true;
			else if (filter == tFTop && bIsHorizontal && bIsTop)bAccepted = true;
			
			else if (filter == tFVertical && bIsVertical)bAccepted = true;
			else if (filter == tFLeft && bIsVertical && bIsLeft)bAccepted = true;
			else if (filter == tFRight && bIsVertical && bIsRight)bAccepted = true;
			
			else if(filter == tFAligned && !bIsVertical && !bIsVertical)bAccepted = true;
			
			if (bAccepted)
				out.append(t);
			
		}//next i
		
		tslDims = out;
		
		return;
	}//endregion

//region Function FilterTslsByName
	// returns all tsl instances with the given scriptname
	// ents: the array to search, if empty all tsls in modelspace are taken
	// name: the name of the tsl to be returned, all if empty
	TslInst[] FilterTslsByName(Entity ents[], String name)
	{ 
		TslInst out[0];
		
		String names[0];
		if (name.length()>0)
			names.append(name);
			
		int bAll = names.length() < 1;
		
		if (ents.length()<1)
			ents = Group().collectEntities(true, TslInst(),  _kMySpace, false);
		
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i]; 
			//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
			if (t.bIsValid())
			{
				if (!bAll && names.findNoCase(t.scriptName(),-1)>-1)
					out.append(t);	
				else if (bAll)
					out.append(t);									
			}
				
		}//next i

		return out;
	
	}//endregion
			
//region Function CollectDimlinesOfPage
	// collects the dimlines associated to a page
	TslInst[] CollectDimlinesOfPage(MultiPage page, PlaneProfile viewProfiles[])
	{ 

		MultiPageView views[] = page.views();
		
		TslInst tslDims[0];
		Entity ents[0];//= Group().collectEntities(true, TslInst(), _kModelSpace);	
		TslInst tsls[] = FilterTslsByName(ents, kScriptDimline);
		
		
		for (int i=0;i<tsls.length();i++) 
		{ 
			TslInst t= tsls[i];//(TslInst)ents[i];
			if (t.bIsValid() && t.entity().find(page)>-1)
			//if (t.bIsValid() && t.scriptName().makeLower() == kScriptDimline.makeLower() && t.entity().find(page)>-1)
			{	
				
			// do not collect if indices specified and not found	
				Map m = t.map();
				int viewIndex = m.getInt("ViewIndex");

				int bAccept = viewProfiles.length()<1;// accept if inserted in model
				if (viewIndex>=0 && viewIndex<views.length())
				{ 
					MultiPageView view = views[viewIndex];
					PlaneProfile ppView(CoordSys());
					ppView.joinRing(view.plShape(), _kAdd);

					for (int j=0;j<viewProfiles.length();j++) 
					{ 
						PlaneProfile pp = viewProfiles[j];
						pp.transformBy(page.coordSys().ptOrg()-_PtW); // stored in blockspace world

						if (ppView.pointInProfile(pp.ptMid())==_kPointInProfile)
						{ 
							bAccept = true;
							//pp.extentInDir(_XW).vis(3);//NOTE: do not move debug instance
							break;
						}
					}//next i

					//ppView.vis(2);
				}

			// append
				if(bAccept)
				{
					tslDims.append(t);
					
//					if (bDebug)
//						PLine(t.ptOrg(), _Pt0).vis(40);
				}
			}
		}//next i		
		return tslDims;
	}//endregion

//region Function CollectDimlineGroups
	// returns a map with the grouped dimlines. local dimlines are excluded, the submap key is made of the view index and vecSide
	// bByReadDiretion: distinguishes between the side of the dimline or the reading direction only. reading direction is relevant for purging
	Map CollectDimlineGroups(TslInst tslDims[], int bByReadDiretion)
	{ 
		Map maps;
		
	//region Collect all groups of dimlines in a map
		//reportNotice("\nCollectDimlineGroups: " + tslDims.length() + " " + bByReadDiretion);
		for (int i=0;i<tslDims.length();i++) 
		{ 
			TslInst& t = tslDims[i];
			if(!t.bIsValid()){ continue;}
			Map m = t.map();
			int viewIndex = m.getInt("ViewIndex");
			Vector3d vecSide = m.getVector3d("vecPerp");
			Point3d ptOrg = t.ptOrg();
			if (m.getInt(kIsLocal)) // ignore local dimensions
			{ 
				continue;
			}
			
			PlaneProfile pp = m.getPlaneProfile("ppAll");
			Point3d ptMid = pp.ptMid();
			
			String key;
			
		// group by by readDirection: any dimline with the same read direction will be accepted
			if(bByReadDiretion)
			{ 
				if (vecSide.isParallelTo(_XW))vecSide = -_XW;
				else if (vecSide.isParallelTo(_YW))vecSide = _YW;
				else if (vecSide.dotProduct(_YW)<0)vecSide *=-1;
				//key = viewIndex + "_";
			}
		// group parallel dimlines
			else if (vecSide.dotProduct(ptMid-ptOrg)<0)
			{
				vecSide *= -1;
				key = viewIndex + "_";
			}	
			else
				key += viewIndex + "_";
			key+= vecSide;// + "_" + (vecSide.dotProduct(ptOrg - ptMid) > dEps ? "A" : "B");
			
			vecSide.vis(ptOrg, 2);
			
			if (maps.hasMap(key))
			{ 
				Map m = maps.getMap(key);
				Entity ents[] =m.getEntityArray("ent[]", " ", "ent");
				ents.append(t);
				m.setEntityArray(ents, true, "ent[]", " ", "ent");
				maps.setMap(key, m);
			}
			else
			{ 
				m.setVector3d("vecSide", vecSide);
				Entity ents[] = { t};
				m.setEntityArray(ents, true, "ent[]", " ", "ent");	
				maps.appendMap(key, m);
			}			
			//reportMessage("\ni" + i + " view index " +viewIndex + " " + vecSide);
		}//next i			
	//endregion		
		return maps;
	}//endregion
 
 //region Function CompareDimlines
 	// returns true if the comparison of the vertices matches
 	int CompareDimlines(Point3d pts1[], Point3d pts2[], Point3d ptOrg1, Point3d ptOrg2, Vector3d vecDir, Vector3d vecDir2)
 	{ 
 		Line ln1(ptOrg1, vecDir);
 		Line ln2(ptOrg2, vecDir);
 		
 		int bMatch =true;;
 		if (!vecDir.isParallelTo(vecDir2))
 		{ 
 			bMatch=false;
 		}
 		else
 		{ 
	  		pts1 = ln1.orderPoints(ln1.orderPoints(pts1, dEps));
	 		pts2 = ln2.orderPoints(ln2.orderPoints(pts2, dEps));	
	 		if (pts1.length()!=pts2.length())
	 		{ 
	 			bMatch=false;
	 		}
	 		else
	 		{ 
		 		PLine pl;
		 		for (int i=0;i<pts1.length();i++) 
		 		{ 
		 			Point3d pt1= pts1[i]; 
		 			Point3d pt2= pts2[i];
		 			
		 			if(bDebug)
		 			{ 
			 			pl.addVertex(pt1);
			 			pl.addVertex(pt2);		 				
		 			}

		 			if (abs(vecDir.dotProduct(pt1-pt2))>dEps)
		 			{ 
		 				bMatch=false;
		 				if(!bDebug)break;
		 			}
		 		}//next i	
		 		//if(bDebug)pl.vis(nc);
	 		}

 		}
 		
 		
 		if (bMatch && bDebug)PLine(ptOrg1, ptOrg2).vis(20);

 		return bMatch;
 	}//endregion
    
  //region Function OrderDimlines
  	// returns an ordered list of dimlines where the first is closest to its viewing profile
  	void OrderDimlinesByOffset(TslInst& tslDims[], Vector3d vecSide)
  	{ 
  		double dists[0];
  		for (int i = 0; i < tslDims.length(); i++)
  		{ 
  			TslInst t = tslDims[i];
  			Map m = t.map();
  			PlaneProfile pp = m.getPlaneProfile("ppAll");	
  			//{Display dpx(1); dpx.draw(pp, _kDrawFilled,20);}
  			double d= abs(vecSide.dotProduct(pp.ptMid() - t.ptOrg()));	
  			dists.append(d);
  		}
  		
  	// order by dist
  		for (int i=0;i<tslDims.length();i++) 
  			for (int j=0;j<tslDims.length()-1;j++) 
  				if (dists[j]<dists[j+1])
  				{ 
  					dists.swap(j, j + 1);
  					tslDims.swap(j, j + 1);
  				}

		if (bDebug)
			for (int i=0;i<tslDims.length();i++)
				PLine(tslDims[i].ptOrg(), _PtW).vis(i+1);

  		return;
  	}//endregion
    
//region Function PurgeDimlines
	// purges dimlines of the same reading direction carrying the same content
	void PurgeDimlines(MultiPage page, TslInst& tslDims[])
	{ 

		Map maps = CollectDimlineGroups(tslDims, true);
		TslInst duplicates[0];
		
	// loop maps
		for (int i = 0; i < maps.length(); i++)
		{
			Map m = maps.getMap(i);
			Vector3d vecDir = m.getVector3d("vecDir");
			Vector3d vecSide = m.getVector3d("vecSide");
			Entity ents[] = m.getEntityArray("ent[]", " ", "ent");			
			TslInst tsls[] = FilterTslsByName(ents,kScriptDimline);
		
			OrderDimlinesByOffset(tsls, vecSide);
		
		
		
			int cnt, nMax = tsls.length() - 1;
			while(tsls.length()>1 && cnt<nMax)
			{ 			
				TslInst t1 = tsls.first(); 
				Point3d pts1[] = t1.subMapX("Sequencing").getPoint3dArray("ptsDim");

				for (int j=tsls.length()-1; j>=0 ; j--) 
				{ 
					TslInst t2 = tsls[j];
					if (t1==t2 || !t2.bIsValid()){ continue;}
					
					Vector3d vecDir2 = m.getVector3d("vecDir");
					Point3d pts2[] = t2.subMapX("Sequencing").getPoint3dArray("ptsDim");
					
					int bMatch = CompareDimlines(pts1, pts2, t1.ptOrg(), t2.ptOrg(), vecDir, vecDir2);

 					if(bMatch)
 					{
 						duplicates.append(t2);
 						
 					// remove from list of all tsls of this page	
						int n = tsls.find(t2);							
						if (n>-1)
							tsls.removeAt(n);	
 						
 					}
				}
				
			// remove the last test instance for the next run	
				int n = tsls.find(t1);							
				if (n>-1)
					tsls.removeAt(n);	

				cnt++; 
			}//do while
		
			
		}//next i

		
		
		int c;
		for (int i=tslDims.length()-1; i>=0 ; i--) 
		{
			TslInst& t = tslDims[i];
			if (bDebug && duplicates.find(t)>-1)
			{ 
				Map m = t.map();
				{Display dpx(c++); dpx.draw(m.getPlaneProfile("DimBounding"), _kDrawFilled,20);}
			}
			else if (t.bIsValid() && duplicates.find(t)>-1)
			{
				t.dbErase();
				tslDims.removeAt(i);
			}
		}								


		
		return;
	}//endregion

//region Function OrderBySide
	// orders dimlines by vecSide and returns corresponding dim bounding profiles
	PlaneProfile[] OrderBySide(TslInst& tsls[], Vector3d vecSide)
	{ 	
	// order bySide
		for (int ii=0;ii<tsls.length();ii++) 
			for (int j=0;j<tsls.length()-1-ii;j++) 
			{	
				double d1 = vecSide.dotProduct(_PtW - tsls[j].ptOrg());
				double d2 = vecSide.dotProduct(_PtW - tsls[j+1].ptOrg());
				
				if (d1>d2)
					tsls.swap(j, j + 1);
			}	

	// Collect bounds
		PlaneProfile pps[0];
		for (int i=0;i<tsls.length();i++) 
		{
			PlaneProfile pp =tsls[i].map().getPlaneProfile("DimBounding"); 
			//{Display dpx(i); dpx.draw(pp, _kDrawFilled,80);}
			pps.append(pp);
		}

		return pps;
	}//endregion

//region Function AlignDimlines
	// aligns dimlines next to each other
	void AlignDimlines(TslInst tslDims[],double baseOffset, double dIntermediateOffset)
	{ 
		int bSetBaseLine = baseOffset > 0;
	
	//Collect all groups of dimlines in a map
		Map maps = CollectDimlineGroups(tslDims, false);

		for (int i=0;i<maps.length();i++) 
		{ 
			Map m = maps.getMap(i);
			Entity ents[] =m.getEntityArray("ent[]", " ", "ent");
			
		// skip first if no baseLineOffset specified	
			if (ents.length()<(bSetBaseLine?1:2)){ continue;}
						
			TslInst tsls[] = FilterTslsByName(ents,"DimLine");// (bDebug?"DimLine".scriptName());			
			Vector3d vecSide = m.getVector3d("vecSide");
			PlaneProfile pps[]= OrderBySide(tsls, vecSide);

		// Align first dimline by baseline offset	
			if (bSetBaseLine && tsls.length()>0)
			{ 
				TslInst& t1 = tsls[0];
				Map m1 = t1.map();
				PlaneProfile pp1 = m1.getPlaneProfile("ppAll");
				if(bDebug){Display dpx(1+i); dpx.draw(pp1, _kDrawFilled,20);}
				
				PlaneProfile& pp2 = pps[0];
				
				LineSeg seg =pp1.extentInDir(vecSide);	
				double d1 = abs(vecSide.dotProduct(seg.ptEnd()-seg.ptStart()));			
				
				Point3d pt1 = pp1.ptMid() - vecSide * .5 * d1;				pt1.vis(1);vecSide.vis(pt1, 3);
				Point3d pt2 = pp2.ptMid() + vecSide * .5 * pp2.dY();		pt2.vis(2);
				
				double dMove = vecSide.dotProduct(pt1 - pt2);
				
				if (abs(dMove)>dEps)
				{ 
					dMove -= baseOffset;
					Map m = t1.map();
					if (m.hasVector3d("vecOrg"))
					{ 
						Vector3d vecOrg = m.getVector3d("vecOrg");
						vecOrg += vecSide * dMove;
						m.setVector3d("vecOrg", vecOrg);
						t1.setMap(m);
					}
					t1.transformBy(vecSide * dMove);
					pp2.transformBy(vecSide * dMove);				
				}				
			}

		// Align any following dimline to the closest dist
			for (int i=0;i<tsls.length()-1;i++) 
			{ 
				
				TslInst& t = tsls[i+1];
				
				PlaneProfile pp1 = pps[i];
				PlaneProfile& pp2 = pps[i+1];				
				
				Point3d pt1 = pp1.ptMid()-vecSide*.5*pp1.dY();	
				Point3d pt2 = pp2.ptMid()+vecSide*.5*pp2.dY();				
				pt1.vis(4); pt2.vis(40);
				double dMove = vecSide.dotProduct(pt1 - pt2);
				
				if (!bDebug && abs(dMove)>dEps)
				{
					Vector3d vecMove = vecSide * (dMove - dIntermediateOffset);
					Map m =t.map();
					if (m.hasVector3d("vecOrg"))
					{ 
						Vector3d vecOrg = m.getVector3d("vecOrg")+vecMove;
						m.setVector3d("vecOrg", vecOrg);
						t.setMap(m);
					}
					t.transformBy(vecMove);
					pp2.transformBy(vecMove);				
				}	
			}
			//reportNotice("\ni" + i + " key " +maps.keyAt(i) + "  reports " + ents.length());
		}
		
		
	
		//return;
	}//endregion	

//region Function GetShopdrawProfiles
	// returns the planeprofiles of the selected shopdrawviews
	PlaneProfile[] GetShopdrawProfiles(ShopDrawView sdvs[])
	{ 
		PlaneProfile pps[0];
		for (int i=0;i<sdvs.length();i++) 
		{ 
			ShopDrawView sdv= sdvs[i]; 

		//Get bounds of viewports		
			PlaneProfile pp(CoordSys());
			Point3d pts[] = sdv.gripPoints();
			Point3d ptCen= sdv.coordSys().ptOrg();
			double dX = U(1000), dY =dX; // something			
			for (int i=0;i<2;i++) 
			{ 
				Vector3d vec = i == 0 ? _XW : _YW;
				pts = Line(_Pt0, vec).orderPoints(pts);
				if (pts.length()>0)	
				{
					double dd = vec.dotProduct(pts.last() - pts.first());
					if (i == 0)dX = dd;
					else dY = dd;
				}
				 
			}//next i
			
			PLine pl;
			Vector3d vec = .5 * (_XW * dX + _YW * dY);
			pl.createRectangle(LineSeg(ptCen - vec, ptCen + vec), _XW, _YW);
			pp.joinRing(pl, _kAdd);		
			//pp.extentInDir(_XW).vis(1);	
			
			pps.append(pp);
				

		}//next i			
		return pps;
	}//endregion

	
//region Function GetDimPlaneProfile
	// modifies the profile passed in by adding text areas and dimline box with an additional margin
	void GetDimPlaneProfile(PlaneProfile& pp, Dim dim, Point3d nodes[], Display dp, double margin)
	{ 
		margin = margin < dEps ? dEps : margin;
		CoordSys cs = pp.coordSys();
		Point3d pt = cs.ptOrg();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		
		Line ln(pt, vecX);
		nodes = ln.orderPoints(ln.projectPoints(nodes));
		PLine pl, plines[] = dim.getTextAreas(dp);
		if (nodes.length()>1)
		{
			pl.createRectangle(LineSeg(nodes.first()-vecY*.5*margin, nodes.last()+vecY*.5*margin), vecX, vecY);
			plines.append(pl);
		}
		for (int i=0;i<plines.length();i++) 
			pp.joinRing(plines[i], _kAdd);

		pp.shrink(-margin);

		return;
	}//endregion	

//region Function DrawDim
	// draws a dimline
	PlaneProfile DrawDim(Point3d nodes[], Point3d ptLoc, Vector3d vecDir, Vector3d vecPerp, Vector3d vecRead, Map mapParams, Display dp)
	{ 
		double textHeight = mapParams.getDouble("textHeight");
		int nDeltaMode = mapParams.getInt("deltaMode"); 
		int nChainMode = mapParams.getInt("chainMode"); 
		int bDeltaOnTop = mapParams.getInt("deltaOnTop");
		int nRefPointMode = mapParams.getInt("refPointMode");
		
		String sDeltaFormat= mapParams.hasString("deltaFormat")?mapParams.getString("deltaFormat"):"<>";
		
		DimLine dl(ptLoc, vecDir, vecPerp);
		dl.setUseDisplayTextHeight(textHeight>0);
		Point3d pts[0];
	
		Dim dim(dl,  pts, "",  "", nDeltaMode, nChainMode); 	
		dim.setDeltaOnTop(bDeltaOnTop);	
		dim.setReadDirection(vecRead);
		for (int i=0;i<nodes.length();i++) 
		{
			nodes[i].vis(i);
			dim.append(nodes[i],sDeltaFormat,(i==0 && nRefPointMode==1?" ":"<>")); // set first to blank if refpoint given 
		}

		if (nodes.length()>1)
		{ 
			dp.draw(dim);
			//dp.draw(text, ptLoc, vecDirText, vecPerpText, nDir, 0);			
		}		

		PlaneProfile pp(CoordSys(ptLoc, vecDir, vecPerp, vecDir.crossProduct(vecPerp)));
		GetDimPlaneProfile(pp, dim, nodes, dp, 0);


		return pp;
	}//endregion
	
//endregion 



//region Properties

category = T("|Dimline|");

	
	String sFilters[]={ tFAny, tFHorizontal,tFVertical, tFBottom, tFTop, tFLeft, tFRight, tFAligned}; 
	String sFilterName=T("|Alignmnet Filter|");	
	PropString sFilter(nStringIndex++, sFilters, sFilterName);	
	sFilter.setDescription(T("|Filters dimensions with the specified orientation.|"));
	sFilter.setCategory(category);
	if (sFilters.findNoCase(sFilter) < 0)sFilter.set(tFAny);

	String sPurgeName=T("|Purge Dimlines|");	
	PropString sPurge(nStringIndex++, sNoYes, sPurgeName);	
	sPurge.setDescription(T("|Defines if redundant dimlines are purged|"));
	sPurge.setCategory(category);
	if (sNoYes.findNoCase(sPurge) < 0)sPurge.set(tYes);
	
	String sAlignName=T("|Realign Dimlines|");	
	PropString sAlign(nStringIndex++, sNoYes, sAlignName);	
	sAlign.setDescription(T("|Specifies whether dimension lines will be realigned with the given properties.|"));
	sAlign.setCategory(category);
	sAlign.setControlsOtherProperties(true);
	if (sNoYes.findNoCase(sAlign) < 0)sAlign.set(tYes);

	String sBaselineOffsetName=T("|Baseline Offset|");	
	PropDouble dBaselineOffset(nDoubleIndex++, U(0), sBaselineOffsetName);	
	dBaselineOffset.setDescription(T("|Defines the offset of the first dimesnion to the dimension object|") +
		T(", |0 = unchanged|"));
	dBaselineOffset.setCategory(category);
	
	String sIntermediateOffsetName=T("|Intermediate Offset|");	
	PropDouble dIntermediateOffset(nDoubleIndex++, U(0), sIntermediateOffsetName);	
	dIntermediateOffset.setDescription(T("|Defines an offset between multiple dimension lines|"));
	dIntermediateOffset.setCategory(category);

	String sProps[] ={sFilter, sPurge,sAlign};
	double dProps[] ={dBaselineOffset,dIntermediateOffset  };
	int nProps[0];

	// enable dialog for other calling tsls
	if (_Map.getInt("isDummy"))
	{ 
		return;
	}

//region Function setReadOnlyFlagOfProperties
	// sets the readOnlyFlag
	void setReadOnlyFlagOfProperties()
	{ 		
		dBaselineOffset.setReadOnly(sAlign==tNo?_kHidden:false);
		dIntermediateOffset.setReadOnly(sAlign==tNo?_kHidden:false);
		return;
	}//endregion	



//End Properties//endregion 

//region OnInsert
	//bDebug = true;
	if(_bOnInsert)
	{
		int bInLayoutTab, bInPaperSpace;
		bInLayoutTab = Viewport().inLayoutTab();
		bInPaperSpace = Viewport().inPaperSpace();
		
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
		{
			setPropValuesFromCatalog(tLastInserted);
			setReadOnlyFlagOfProperties();
		}
		while (showDialog("---") == _kUpdate) // _kUpdate means a controlling property changed.	
		{ 
			setReadOnlyFlagOfProperties(); // need to set hidden state
		}	
		setReadOnlyFlagOfProperties();

	// Detect space by content, find out if we are block space and have some shopdraw viewports
		int bInBlockSpace, bHasSDV;	
		Entity entsSDV[0];
		if (!bInLayoutTab)
		{
			entsSDV= Group().collectEntities(true, ShopDrawView(), _kMySpace, false);
		// shopdraw viewports found and no genbeams or multipages are found
			if (entsSDV.length()>0)
			{ 
				bHasSDV = true;
				Entity ents[0];//= Group().collectEntities(true, GenBeam(), _kAllSpaces);
				ents.append(Group().collectEntities(true, MultiPage(), _kMySpace, false));
				if (ents.length()<1)
				{ 
					bInBlockSpace = true;
				}
			}
		}	

	// Selection
		Entity ents[0];
		
		int bHasPage, bIsViewport, bIsHsbViewport, bHasSection;
		if (bInLayoutTab && bInPaperSpace)
		{ 
			reportNotice("\n" + T("|Paperspace insertion is not supported yet.|"));
			eraseInstance();
			return;
		}
	// Model	
		else
		{ 
		// prompt for entities
			PrEntity ssE;
			if (bInBlockSpace)
			{ 
				ssE = PrEntity(T("|Select shopdraw viewports|") + T("|<Enter> = all views|"), ShopDrawView());
			}	
			else if (bHasSDV)
			{ 
				ssE = PrEntity(T("|Select multipages, dimlines or shopdraw viewports|"), ShopDrawView());
				ssE.addAllowedClass(MultiPage());
				ssE.addAllowedClass(TslInst());
			}			
			else
			{
				ssE = PrEntity(T("|Select multipages or dimlines|"), MultiPage());	
				ssE.addAllowedClass(TslInst());
			}			
			//ssE.allowNested(true);
			
			if (ssE.go())
				ents.append(ssE.set());	

			if (bInBlockSpace && ents.length()<1)
			{ 
				Entity viewEnts[]= Group().collectEntities(true, ShopDrawView(), _kMySpace, false);	
				ents.append(viewEnts);
			}

			for (int i = 0; i < ents.length(); i++)
			{
				ShopDrawView sdv = (ShopDrawView)ents[i];
				if (sdv.bIsValid())
				{ 
					_Pt0 = getPoint();
					break;
				}
			}
			_Entity = ents;
		}

		if(bDebug)_Pt0 = getPoint();
		return;
	}			
//endregion 

//region Collect references
	if (_Map.getInt("BlockSpaceCreated")) 
	{ 
		if (_Entity.length()<1) 
			return; 
		else
			_Map.removeAt("BlockSpaceCreated", true);	
			
//		bDebug = true;	
//		_ThisInst.setDebug(true);			
	}
	
	_ThisInst.setSequenceNumber(20000);
	setReadOnlyFlagOfProperties();// always call the update of properties

	Entity ents[0];
	ents = _Entity;	
	if (_bOnMapIO)
	{
		ents = _Map.getEntityArray("ent[]", "", "ent");
		//reportNotice("\nHelloIO\n"+_Map);
	// set properties by map	
		Map mapProperties = _Map.getMap("Properties");
		
		int bHasPropertyMap =  mapProperties.hasMap("PROPDOUBLE[]") && mapProperties.hasMap("PROPSTRING[]") ;//&& _Map.hasMap("PROPINT[]") &&
		if (bHasPropertyMap)
		{
			setPropValuesFromMap(mapProperties);
			reportNotice("\nHelloIO\n"+mapProperties);
		}

		
		//reportNotice("\nents" +ents);
	}

	MultiPage pages[0];
	ShopDrawView sdvs[0];
	for (int i = 0; i < ents.length(); i++)
	{
		MultiPage page = (MultiPage)ents[i];
		if (page.bIsValid())
		{
			pages.append(page);
			continue;
		}
			
		ShopDrawView sdv = (ShopDrawView)ents[i];
		if (sdv.bIsValid())
			sdvs.append(sdv);	
	}
	TslInst tslDimlines[0];
	if (pages.length()<1 || sdvs.length()<0)
	{
		tslDimlines= FilterTslsByName(ents, kScriptDimline);
	}
//endregion 





//region Page Mode
	if (pages.length()>0)
	{ 		
		//if (_bOnDbCreated)
		//{bDebug = true;		_ThisInst.setDebug(bDebug);}
		int bLog=bDebug;

		PlaneProfile pps[]=GetPlaneProfileArray(_Map.getMap("ViewProfiles[]"));
		
		if (bLog)reportNotice("\n\n" + scriptName() + T(" |optimizes selected pages| (")+pages.length()+")");
		
		
		for (int i=0;i<pages.length();i++) 
		{ 
			MultiPage page= pages[i]; 

			TslInst tslDims[] = CollectDimlinesOfPage(page, pps);
			if (sFilter!=tFAny)FilterDimlineByOrientation(tslDims, sFilter);
			
			int num = tslDims.length();
			if (bLog)reportNotice("\n  " + T("|Page| ") + (i+1) +": "+num +  T(" |dimlines collected|"));
			if(sPurge==sNoYes[1])
			{
				PurgeDimlines(page, tslDims);
				int num2 = tslDims.length();
				if (bLog)reportNotice("\n  " + (num- num2)+  T(" |dimlines purged|"));
				num = num2;
			}
			
			if(num>0 && sAlign==sNoYes[1])
			{
				AlignDimlines(tslDims,dBaselineOffset, dIntermediateOffset);	
				if (bLog)reportNotice("\n  " + num+  T(" |dimlines realigned|"));
			}
		}//next i
		
		if(!bDebug)
		{
			if (bLog)reportNotice("\n  " + T("|The optimization process has been completed.| ")+ T("|Please wait for the screen to refresh.|"));
			eraseInstance();
		}
		return;
	}
//endregion 

//region Dimline Mode
	else if (tslDimlines.length()>0)
	{ 
		if (sFilter!=tFAny)FilterDimlineByOrientation(tslDimlines, sFilter);
		
	// Collect page dependencies
		Map maps;
		for (int i=0;i<tslDimlines.length();i++)
		{ 
			TslInst t = tslDimlines[i];
			Entity ents[] = t.entity();
			for (int j=0;j<ents.length();j++)
			{ 
				MultiPage page = (MultiPage)ents[j];
				
				if (page.bIsValid())
				{ 
					String key = page.handle();
					if (maps.hasMap(key))
					{ 
						Map m = maps.getMap(key);
						Entity ents[] =m.getEntityArray("ent[]", " ", "ent");
						ents.append(t);
						m.setEntityArray(ents, true, "ent[]", " ", "ent");
						maps.setMap(key, m);
					}
					else
					{ 
						Map m;
						m.setEntity("page", page);
						Entity ents[] = {t};
						m.setEntityArray(ents, true, "ent[]", " ", "ent");	
						maps.appendMap(key, m);
					}	
					break;
				}
			}	
		}
		
		for (int i=0;i<maps.length();i++) 
		{ 
			Map m = maps.getMap(i);
			Entity entPage = m.getEntity("page");
			
			MultiPage page= (MultiPage)entPage; 
			if (!page.bIsValid()){ continue;}
			
			Entity ents[] =m.getEntityArray("ent[]", " ", "ent");				
			TslInst tslDims[] = FilterTslsByName(ents, kScriptDimline);
			
			
			if(sPurge==sNoYes[1])
				PurgeDimlines(page, tslDims);
			
			if(sAlign==sNoYes[1])
				AlignDimlines(tslDims,dBaselineOffset, dIntermediateOffset);				 
		}//next i
		
		if(!bDebug)
			eraseInstance();
		return;
	}
//endregion 

//region BlockSpace Mode
	else if (sdvs.length()>0)	
	{ 
	// add shopdraw trigger
		addRecalcTrigger(_kShopDrawEvent, _kShopDrawViewDataShowSet );			
		addRecalcTrigger(_kGripPointDrag, "_Pt0");
		int bDrag = _bOnGripPointDrag && _kExecuteKey == "_Pt0";

		int bLog=false;
	
		PlaneProfile pps[] = GetShopdrawProfiles(sdvs);
		Map mapIndices = _Map.getMap("ViewIndex[]");

//
//		if (bLog)
//		{
//			int indices[] = GetIntArray(mapIndices, false);
//			reportNotice("\n"+scriptName() + _ThisInst.sequenceNumber() + " onGenerate "+_bOnGenerateShopDrawing+ " inds:" + indices);
//		}

		//if (!bDrag)reportNotice("\nBlockSpace _bOnGenerateShopDrawing " + _bOnGenerateShopDrawing+ " mapIndices: "+mapIndices);

	//region On Generate ShopDrawing
		if (_bOnGenerateShopDrawing)
		{ 
			
			//reportNotice("\n" + scriptName() + " set to sequence "+_ThisInst.sequenceNumber() );			
			//if (bLog)reportNotice("\nBlockSpaceCreation starting " + _bOnGenerateShopDrawing);			
			
		// Get multipage from _Map
			Entity entCollector = _Map.getEntity(_kOnGenerateShopDrawing +"\\entCollector");
			Map mapTslCreatedFlags = entCollector.subMapX("mpTslCreatedFlags");
			String uid = _Map.getString("UID"); // get the UID from map as instance does not exist onGenerateShopDrawing
			int bIsCreated = mapTslCreatedFlags.hasInt(uid);	
			
		
			if (!bIsCreated && entCollector.bIsValid())
			{

			// create TSL
				TslInst tslNew;;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {entCollector};			
				Map mapTsl;	
				mapTsl.setInt("BlockSpaceCreated", true);
				Point3d ptsTsl[] = {_Pt0}	;
				//mapTsl.setMap("ViewIndex[]", mapIndices);
				mapTsl.setMap("ViewProfiles[]",_Map.getMap("ViewProfiles[]"));

				
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
				if (tslNew.bIsValid())
				{
					tslNew.setSequenceNumber(200000);
					tslNew.transformBy(Vector3d(0, 0, 0));
					
				// flag entCollector such that on regenaration no additional instances will be created	
					if (!bIsCreated)
					{
						bIsCreated=true;
						mapTslCreatedFlags.setInt(uid, true);
						entCollector.setSubMapX("mpTslCreatedFlags",mapTslCreatedFlags);
					}
				}
			}
		}
	//endregion 
		
	//region Block Space Display
		else
		{ 
			
			dBaselineOffset.setReadOnly(bDebug || sAlign == sNoYes[1] ? false : _kHidden);
			dIntermediateOffset.setReadOnly(bDebug || sAlign == sNoYes[1] ? false : _kHidden);
			
			
			
			
			_Map.setString("UID", _ThisInst.uniqueId()); // store UID to have access during _kOnGenerateShopDrawing

		// Store the index of the viewport in relation to all viewports
			Entity viewEnts[]= Group().collectEntities(true, ShopDrawView(), _kMySpace, false);	
			int bAnyView = viewEnts.length() == sdvs.length();
			
			_Map.setMap("ViewProfiles[]", SetPlaneProfileArray(pps));

			String text = scriptName() + " " ;
			if (sPurge==sNoYes[1] && sAlign==sNoYes[1])
				text += T("|purges redundant and aligns dimlines of selected views|");
			else if (sPurge==sNoYes[1])
				text += T("|purges redundant dimlines of selected views|");
			else if (sAlign==sNoYes[1])
				text += T("|aligns dimlines of selected views|");
			else 
				text += T("|is disabled for selected views|");
			text+= " ("+ sdvs.length() + ")";
			//text += "\n" + sDisplaySetName + ": "+sDisplaySet;
			
			
			Entity ents[0];				
			TslInst tslDims[]= FilterTslsByName(ents, kScriptDimline);
			
		// Remove dimlines not associated to one of the sdvs
			for (int i=tslDims.length()-1; i>=0 ; i--) 
			{ 
				Entity ents[]=tslDims[i].entity();
				if (ents.length()>0 && sdvs.find(ents.first())<0)
				{
					tslDims.removeAt(i);
				}

			}//next i
			
			
			

		//Collect all groups of dimlines in a map
			if (sFilter!=tFAny)FilterDimlineByOrientation(tslDims, sFilter);
			
			
			if(!bDrag && sAlign==sNoYes[1] && tslDims.length()>0)
			{ 
				AlignDimlines(tslDims,dBaselineOffset, dIntermediateOffset);
			}

			
			
			Display dpText(212),dpJig(-1), dpDim(212);
			double textHeight = U(100);
			dpText.textHeight(textHeight);
			dpDim.textHeight(textHeight);
			dpJig.trueColor(darkyellow, 70);

			if (bDrag)
			{ 
				for (int i=0;i<pps.length();i++) 
				{
					dpJig.draw(pps[i], _kDrawFilled);
					dpJig.draw(pps[i]);
				}	
				dpJig.trueColor(purple,60);
				for (int i=0;i<tslDims.length();i++) 
				{
					Map m = tslDims[i].map();
					PlaneProfile pp = m.getPlaneProfile("DimBounding");
					dpJig.draw(pp, _kDrawFilled);
					dpJig.draw(pp);
				}
			}

	
			dpText.draw(text, _Pt0, _XW, _YW, 1.05, -1);	


		//region trigger
		// trigger add view
			String sAddViewTrigger = T("|Add View|");
			addRecalcTrigger(_kContextRoot, sAddViewTrigger );	
			if (_bOnRecalc && _kExecuteKey==sAddViewTrigger )
			{
				PrEntity ssE(T("|Select shopdraw viewports|"), ShopDrawView());
				if (ssE.go()) 
				{
					Entity ents[] = ssE.set();
					for (int e=0; e<ents.length(); e++) 
					{
						ShopDrawView sdv = (ShopDrawView)ents[e];
						if (sdv.bIsValid() && _Entity.find(sdv)<0)
							_Entity.append(sdv);
					}
				}
				setExecutionLoops(2);
				return;
			}

		// trigger remove view
			String sRemoveViewTrigger = T("|Remove View|");
			if (_Entity.length()>1)addRecalcTrigger(_kContextRoot, sRemoveViewTrigger );
			if (_bOnRecalc && _kExecuteKey==sRemoveViewTrigger )
			{
				ShopDrawView sdv = getShopDrawView();
				int n=_Entity.find(sdv);
				if (n>-1)
					_Entity.removeAt(n);
				setExecutionLoops(2);
				return;
			}
		//endregion	
			


		}
	//endregion 			
		return;
	}
//BlockSpace Mode //endregion 









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
        <int nm="BreakPoint" vl="570" />
        <int nm="BreakPoint" vl="512" />
        <int nm="BreakPoint" vl="499" />
        <int nm="BreakPoint" vl="570" />
        <int nm="BreakPoint" vl="512" />
        <int nm="BreakPoint" vl="499" />
        <int nm="BreakPoint" vl="1323" />
        <int nm="BreakPoint" vl="1073" />
        <int nm="BreakPoint" vl="1154" />
        <int nm="BreakPoint" vl="1054" />
        <int nm="BreakPoint" vl="616" />
        <int nm="BreakPoint" vl="608" />
        <int nm="BreakPoint" vl="1258" />
        <int nm="BreakPoint" vl="1248" />
        <int nm="BreakPoint" vl="219" />
        <int nm="BreakPoint" vl="1253" />
        <int nm="BreakPoint" vl="1239" />
        <int nm="BreakPoint" vl="657" />
        <int nm="BreakPoint" vl="635" />
        <int nm="BreakPoint" vl="627" />
        <int nm="BreakPoint" vl="1046" />
        <int nm="BreakPoint" vl="508" />
        <int nm="BreakPoint" vl="432" />
        <int nm="BreakPoint" vl="526" />
        <int nm="BreakPoint" vl="469" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22556 alignment properties only visible if selected" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="1/21/2025 5:37:17 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-21565 new property to filter certain dimline alignments" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="1/8/2025 4:43:49 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-21565 initial version of MultipageController" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="1/7/2025 4:51:17 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End