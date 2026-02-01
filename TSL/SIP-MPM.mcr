#Version 8
#BeginDescription
#Versions
Version 1.1 26.02.2025 HSB-23420 painter based grouping supported
Version 1.0 07.05.2024 HSB-21851 initial version

This tsl creates nested master panels
Select panels, child panles and/or masterpanles to created nested master panels


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.1 26.02.2025 HSB-23420 painter based grouping supported , Author Thorsten Huck
// 1.0 07.05.2024 HSB-21851 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select panels, child panles and/or masterpanles to created nested master panels
/// </insert>

// <summary Lang=en>
// This tsl creates nested master panels
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "SIP-MPM")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Stock Sizes|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Clone Stock Sizes|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Import Settings|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Export Settings|") (_TM "|Select Tool|"))) TSLCONTENT
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
	String sNoYes[] = { T("|No|"), T("|Yes|")};

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
	
	int bAlignVertical = true;
	int kAscending = 1, kDescending = 0;
	Vector3d vecXM = bAlignVertical ? _YW : _XW;
	Vector3d vecYM = bAlignVertical ?- _XW : _YW;
	double dXYMinimum = U(100);
	double dColumnOffsetMaster = U(600), dColumnOffsetChild = U(100);
	double dRowOffsetMaster = U(8000);
	String kCallNester = "CallNester", kYield = "Yield";
	
	String sTriggerAddStockSize = T("|Add Stock Sizes|");
//end Constants//endregion

//region Functions

//region Function AppendEntities
	// appends entities to an array of genbeams avoiding duplicates
	void AppendGenbeams(GenBeam& ents[], Entity entsAdd[])
	{ 
		for (int i=0;i<entsAdd.length();i++) 
			if(ents.find(entsAdd[i])<0)
			{
				GenBeam gb = (GenBeam)entsAdd[i];
				if (gb.bIsValid())
					ents.append(gb); 
			}
		return;
	}//endregion
	



//region PlaneProfile Functions
	
	//region Function dDProfile
	// returns the bounding dimension in a given direction
	// pp: the planeprofile to examine
	// vecDir: the direction
	double dDProfile(PlaneProfile pp, Vector3d vecDir)
	{ 
		LineSeg seg = pp.extentInDir(pp.coordSys().vecX());
		double dD = abs(vecDir.dotProduct(seg.ptEnd()-seg.ptStart()));
		return dD;
	}//End double//endregion

	//region Function RotateProfile
	// rotates the profile and coordSys to the specified max direction and returns extents vec 
	// t: the tslInstance to 
	Vector3d RotateCoordSys(PlaneProfile pp, CoordSys& cs, int nXY)
	{ 
		double dx = dDProfile(pp, _XW);
		double dy = dDProfile(pp, _YW);

		if ((dx > dy && nXY==1) || (dy > dx && nXY==0))
		{
			CoordSys rot;
			rot.setToRotation(90, _ZW, pp.ptMid());
			cs.transformBy(rot);
			double dt = dy;
			dy = dx;
			dx = dt;
		}
		return (_XW * dx + _YW * dy);
	}//endregion


//endregion 

//region Sip Functions #SF

	//region Function ProfNesting
	// returns the planeprofile of a panel transformed by csTrans
	PlaneProfile ProfNesting(Sip sip, CoordSys csTrans)
	{ 
		PlaneProfile pp( CoordSys(sip.ptCen(),sip.vecX(), sip.vecY(), sip.vecZ()));
		pp.joinRing(sip.plEnvelope(), _kAdd);
		pp.transformBy(csTrans);
		
	// align to positive world Z
		CoordSys csx=pp.coordSys();
		if (csx.vecZ().isParallelTo(_ZW))
		{ 
			csx.transformBy(_ZW * _ZW.dotProduct(_PtW - csx.ptOrg()));
			if (csx.vecZ().isCodirectionalTo(-_ZW))
				csx = CoordSys(csx.ptOrg(), csx.vecX(), csx.vecX().crossProduct(-_ZW), _ZW );	
			PlaneProfile ppx(csx);
			ppx.unionWith(pp);
			pp = ppx;
		}
		return pp;
	}//End PlaneProfile //endregion

	//region Function CollectStyles
	// returns the styles of the sips
	String[] CollectStyles(Sip sips[])
	{ 
	// Get unique styles
		String styles[0];
		for (int i=0;i<sips.length();i++) 
		{ 
			Sip& sip = sips[i];
			if (!sip.bIsValid())continue;
			
			String style = sip.style(); 
			if (styles.findNoCase(style,-1)<0)
				styles.append(style);	 
		}//next i	
		return styles;
	}//End String[]//endregion

	//region Function CollectPlaneProfiles
	// returns an array of planeprofiles and the min and max dimension found in all
	PlaneProfile[] CollectPlaneProfiles(Sip sips[], double& dMin, double& dMax)//
	{ 
		PlaneProfile pps[0];
		for (int i=0;i<sips.length();i++) 
		{ 
			Sip& sip= sips[i]; 
			CoordSys cs(sip.ptCen(), sip.vecX(), sip.vecY(), sip.vecZ());
			PlaneProfile pp(cs);
			pp.joinRing(sip.plShadow(), _kAdd);
			
			double dx = pp.dX();
			double dy = pp.dY();
			dMin = dx < dMin || dMin<=0 ? dx : dMin;
			dMin = dy < dMin || dMin<=0 ? dy : dMin;
			dMax = dMax < dx ? dx : dMax;
			dMax = dMax < dy ? dy : dMax;			
	
			pps.append(pp);			 
		}//next i

		return pps;
	} //endregion

	//region Function SortByPainter
	// returns the styles and orders the passed sips
	// t: the tslInstance to 
	´void SortByPainter(Sip& sips[], String painterDef, int bAscending)
	{ 
		PainterDefinition pd(painterDef);
		if (!pd.bIsValid())
		{
			reportMessage(TN("|Painter invalid|: ") + painterDef);			
			return;
		}

		String type = pd.type();
		if (type !="Panel" && type!="GenBeam")
		{ 
			reportMessage(TN("|Type of Painter Definition invalid, unexpected type:| ") + type);			
			return;			
		}
		String ftr = pd.formatToResolve();
		int bHasLength = ftr.find("@(Length", 0, false) >- 1;
		int bHasLength2= ftr.find("@(SolidLength", 0, false) >- 1;
		int bHasWidth = ftr.find("@(Width", 0, false) >- 1;
		int bHasWidth2 =ftr.find("@(SolidWidth", 0, false) >- 1;
		
		Sip sipsX[] = pd.filterAcceptedEntities(sips);

	// Sort each style as subset
		Sip sipsOut[0];
		String styles[]=CollectStyles(sipsX);
		for (int j = 0; j < styles.length(); j++)
		{
		// Collect sips of same style
			String styleJ = styles[j];
			Sip sipsS[0];
			for (int i = 0; i < sipsX.length(); i++)
			{
				Sip sip = sipsX[i];
				if (sip.bIsValid() && styleJ==sip.style())
					sipsS.append(sipsX[i]);
			}

		// collect tags
			String tags[0];
			for (int i = 0; i < sipsS.length(); i++)
			{ 
				Sip& e = sipsS[i];
				String tag;
				
				if (ftr.length()>0 && ftr.find("@(",0, false)>-1)
				{ 
					Map m;
					if (bHasLength || bHasWidth || bHasLength2 || bHasWidth2)
					{ 
						double dL = e.dL();
						double dW = e.dW();
						double dL2 = e.solidLength();
						double dW2 = e.solidWidth();				
						if (dL<dW)
						{ 
							dL = dW;
							dW = e.dL();
						}
						if (dL2<dW2)
						{ 
							dL2 = dW2;
							dW2 = e.solidLength();
						}				
						m.setDouble("Length", dL);
						m.setDouble("Width", dW);
						m.setDouble("SolidLength", dL);
						m.setDouble("SolidWidth", dW);				
					}
					
					tag = e.formatObject(ftr, m);				
					
				}
				else // no grouping defined
					tag = e.uniqueId();	
				tags.append(tag);
			}//next i			

		// order by tag
			for (int i=0;i<tags.length();i++) 
				for (int j=0;j<tags.length()-1;j++) 
				{
					String s1 = tags[j];//filters[j] + tags[j];
					String s2 = tags[j+1];//filters[j+1] + tags[j+1];
					if (s1>s2)
					{
						sipsS.swap(j, j + 1);
						tags.swap(j, j + 1);
					}						
				}

		// sort descending			
			if (!bAscending)
			{ 
				sipsS.reverse();
				tags.reverse();
			}
			
			sipsOut.append(sipsS);
		}// next style j

		sips = sipsOut;

		return;
	}//End void function//endregion	

	//region Function GetSipsNoChilds
	// returns all sips not having a childpanel associated.
	Sip[] GetSipsNoChilds(Sip sips[])
	{ 
		Sip sipWithChilds[0], sipsOut[0];;		
		Entity entChilds[] = Group().collectEntities(true, ChildPanel(), _kModelSpace);

	// Collect any sip and its associated child
		for (int i=0;i<entChilds.length();i++) 
		{ 
			ChildPanel child= (ChildPanel)entChilds[i];
			if (child.bIsValid())
			{ 
				Sip sip = child.sipEntity();
				if (sips.find(sip)>-1)
					sipWithChilds.append(sip);
			}			 
		}//next i
	
	// Collect any sip of the input which has no child
		for (int i=0;i<sips.length();i++) 
			if (sipWithChilds.find(sips[i])<0)
				sipsOut.append(sips[i]);
				
		return sipsOut;
	}//End Sip[] //endregion

//Sip Functions //endregion 

//region ChildPanel Functions #CF


	//region Function FilterChilds1And2
	// returns
	ChildPanel[] FilterChilds1And2(ChildPanel childs1[], ChildPanel childs2[])
	{ 
		ChildPanel out[0];
		for (int i=0;i<childs1.length();i++) 
			if (childs2.find(childs1[i])>-1)
				out.append(childs1[i]); 

		return out;
	}//endregion



	//region Function GetChildDims
	// returns the min and max dimensions of all childs
	void GetChildDims(ChildPanel childs[], double& mins[] , double& maxs[])
	{ 
		for (int i=0;i<childs.length();i++) 
		{ 
			ChildPanel child = childs[i];
			Sip sip = child.sipEntity();
	
			double dX = sip.solidLength();
			double dY = sip.solidWidth();
			
			double min = dX < dY ? dX : dY;
			double max = dX < dY ? dY : dX; 
			
			mins.append(min);
			maxs.append(max);
		}//next i
	}//endregion

	//region Function AppendChilds
	// appends childs unique
	void AppendChilds(ChildPanel& childs[],ChildPanel childsAdd[])
	{
		for (int i=0;i<childsAdd.length();i++) 
			if(childs.find(childsAdd[i])<0)
				childs.append(childsAdd[i]); 
	}//endregion

	//region Function FilterChildsSingular
	// returns the childs which can not be nested in the given direction
	// A: the min nesting dimenision
	// B: the max nesting dimenision
	ChildPanel[] FilterChildsSingular(ChildPanel childs[], double A, double B, double gap, int bCheckMax)
	{ 
		ChildPanel out[0];
		double mins[0], maxs[0];
		GetChildDims(childs, mins, maxs);
		
		for (int i=0;i<childs.length();i++) 
		{ 
			ChildPanel& child = childs[i];
			double a = maxs[i];
			double b = mins[i];
			if (a > A || b > B) { continue;};
			
		// remaining dimensions	
			double dA = A - a - gap;
			double dB = B - b - gap;

			int bCanNest;
			for (int j=0;j<childs.length();j++)
			{ 
				if (i == j && childs.length()>1)continue;
				double aj = maxs[j];
				double bj = mins[j];
			
			// check larger dim
				if(bCheckMax && dA>=aj && B>=bj)
				{ 
					bCanNest = true;
					break;
				}
			// check smaller  dim	
				if(!bCheckMax && ((dB>=bj && A>=aj) || (dB>=aj && A>=bj)))
				{ 
					bCanNest = true;
					break;
				}				
			}
			if (!bCanNest)
				out.append(child);
		}//next i
		
		return out;
	}//endregion

	//region Function FilterChildsSingularAll
	// returns the childs which can not be nested in the given direction
	ChildPanel[]  FilterChildsSingularAll(ChildPanel childs[], double dLengths[], double dWidths[], double gap, int bCheckMax)
	{ 
		ChildPanel out[0];
	// Collect childs which can only be nested one by minimal dimension	
		for (int i=0;i<dLengths.length();i++) 
		{ 
			ChildPanel childsI[]= FilterChildsSingular(childs, dLengths[i], dWidths[i], gap,bCheckMax);			
			AppendChilds(out, childsI); 
		}//next i
		return out;
	}//endregion

	//region Function FilterChildsNotThis
	// mimics filterGenBeamsNotThis
	ChildPanel[] FilterChildsNotThis(ChildPanel childs[], ChildPanel childsNot[])
	{ 
		ChildPanel out[0];
		for (int i=0;i<childs.length();i++) 
		{ 
			ChildPanel& child = childs[i]; 
			if (childsNot.find(child)<0)
				out.append(child);
		}//next i	
		return out;
	}//endregion

	//region Function OrderChilds
	// returns the childs ordered by orderType
	// orderType: 0=byLength, 1=byWidth, 2 = bySmallest, 4=byArea
	int kOTLength=0, kOTWidth=1, kOTSmallest=2, kOTArea=4; 
	void OrderChilds(ChildPanel& childs[], int bAscending, int orderType)
	{ 
		double mins[0] , maxs[0];
		GetChildDims(childs, mins ,maxs);

		
	// order phase 2 by orderType ascending
		for (int i=0;i<childs.length();i++) 
			for (int j=0;j<childs.length()-1;j++) 
			{
				double dX1 = maxs[j];
				double dY1 = mins[j];
				double area1 = dX1 * dY1;
				double dMax1 = dX1>dY1?dX1:dY1;
				
				double dX2 = maxs[j+1];
				double dY2 = mins[j+1];
				double area2 = dX2 * dY2;
				double dMax2 = dX2>dY2?dX2:dY2;
				
				int bSwap;
				if (orderType == kOTLength && dX1 > dX2)bSwap = true;
				else if (orderType==kOTWidth && dY1>dY2)bSwap = true;
				else if (orderType==kOTSmallest && dMax1>dMax2)bSwap = true;
				else if (orderType==kOTArea && area1>area2)bSwap = true;

				if (bSwap)
				{
					mins.swap(j, j + 1);
					maxs.swap(j, j + 1);
					childs.swap(j, j + 1);
				}
			}
		if (!bAscending)
		{ 
			childs.reverse();
		}

		return;
	}//endregion

	//region Function GetChildsFromMap
	// returns the child panels of a map with list of childs in its root map
	ChildPanel[] GetChildsFromMap(Map mapChilds)
	{ 
		ChildPanel out[0];
		for (int i=0;i<mapChilds.length();i++) 
		{ 
			Map m = mapChilds.getMap(i);
			Entity e = m.getEntity("ent");
			if (e.bIsValid())
			{ 
				ChildPanel c = (ChildPanel)e;
				if (c.bIsValid())
					out.append(c);
			}				 
		}//next i
		return out;
	}//endregion

	//region Function CollectChildsByStyle
	// returns an array of (child) entities which mtch the given style
	Entity[] CollectChildsByStyle(ChildPanel childs[], String style)
	{ 
		Entity out[0];
		for (int i=0;i<childs.length();i++) 
		{ 
			Sip sip = childs[i].sipEntity();
			if (sip.style()==style)
				out.append(childs[i]);					 
		}//next i
		return out;
	}//endregion
	
	//region Function CollectChildsFromSips
	// returns the child panels of the selected sips
	ChildPanel[] CollectChildsFromSips(Sip sips[])
	{ 
		ChildPanel out[sips.length()];	// kepping the sequence	
		Entity entChilds[] = Group().collectEntities(true, ChildPanel(), _kModelSpace);	

	// Collect any sip and its associated child
		for (int i=0;i<entChilds.length();i++) 
		{ 
			ChildPanel child= (ChildPanel)entChilds[i];
			if (child.bIsValid())
			{ 
				Sip sip = child.sipEntity();
				int n = sips.find(sip);
				if (n>-1)
					out[n]=child;
			}			 
		}//next i

		return out;	
	}//endregion

	//region Function DrawFlattened
	// draws the flattend profiles in sequence
	void DrawChildsFlattened(ChildPanel childs[], String format, Display dp, int color, Point3d ptLoc, String desc)
	{ 
		
			
		Display dp2(color);
		dp2.textHeight(U(300));	
		dp2.draw(desc, ptLoc, _XW, _YW ,-1, 1);
		
		for (int i=0;i<childs.length();i++) 
		{ 
			ChildPanel child = childs[i]; 
			Sip sip = child.sipEntity();
			
			PlaneProfile pp = ProfNesting(sip, child.sipToMeTransformation()); 
			double dx = dDProfile(pp, _XW);
			double dy = dDProfile(pp, _YW);
			pp.transformBy(ptLoc - pp.ptMid());
			pp.transformBy(.5*(_XW*dx+_YW*dy));
			
			String text = sip.formatObject(format);
			dp.color(_Sip.find(sip)>-1?252:color);
			dp.draw(pp, _kDrawFilled, 90);
			dp.draw(pp);
			dp.draw(text, pp.ptMid(), _XW, _YW, 0, 0);		
			
			ptLoc += _XW * dx;
			//dpText.draw(PLine(pp.ptMid(), childs[x].realBody().ptCen()));		 
		}//next i
		return;
	}//End DrawFlattened //endregion
	
	//region Function CollectChildsFullDim
	// returns childs wich require full size in given direction to be nested
	ChildPanel[] CollectChildsFullDim(ChildPanel childs[], int bCheckWidth, double dLengths[], double dWidths[], double gap)
	{
		ChildPanel out[0];
			
		double dSmallest;	
		double dMins[0];
		double dMaxs[0];
		for (int i = 0; i < childs.length(); i++)
		{
			ChildPanel child = childs[i];
			Sip sip = child.sipEntity();
	
			double dX = sip.solidLength();
			double dY = sip.solidWidth();
			
			double dMin = dX < dY ? dX : dY;
			double dMax = dX < dY ? dY : dX;
			
			dMins.append(dMin);
			dMaxs.append(dMax);	
			
			dSmallest = dSmallest > dMin || dSmallest<=dEps ? dMin : dSmallest;
		}

		
		for (int i = 0; i < childs.length(); i++)
		{
			ChildPanel child = childs[i];

			double dA = dMins[i];
			double dB = dMaxs[i];

			int bFitsMaster;
			int bCollect=true;
			for (int j=0;j<dLengths.length();j++) 
			{ 
				double dXM = dWidths[j];
				double dYM = dLengths[j];
				
				double dAM= dXM < dYM ? dXM : dYM;
				double dBM= dXM < dYM ? dYM : dXM;
				
				if (dA<dAM && dB<dBM)
					bFitsMaster = true;
				
				
				if (bCheckWidth)
				{ 
					double dRemainingDim = dAM - dA - gap;
					double dMinDimForNesting = dAM-dXYMinimum - gap;
					if (dRemainingDim>=dSmallest && dRemainingDim>dA && dA<dMinDimForNesting)
					{ 
						bCollect = false;
						break;
					}					
				}
				else
				{ 
					double dRemainingDim = dBM - dB - gap;
					double dMinDimForNesting = dBM-dXYMinimum - gap;
					if (dRemainingDim>=dSmallest && dRemainingDim>dB && dB<dMinDimForNesting)
					{ 
						bCollect = false;
						break;
					}					
				}
		


			}// next j
			if (bCollect && bFitsMaster)
			{ 
				out.append(child);
			}				
		}// next i	
		return out;
	}//endregion	




//End ChildPanel //endregion 

//region Nesting Functions

	//region Function SetMapXNestingData
	// returns the are of the given planeprofile and stores it as submapx
	// t: the tslInstance to 
	double SetMapXNestingData(Entity& ent, PlaneProfile pp)
	{ 
		double area = pp.area();
		
		Map mapX = ent.subMapX("NestingData");
		mapX.setPlaneProfile("pp", pp);
		mapX.setDouble("area", area, _kArea);
		ent.setSubMapX("NestingData", mapX);		
		
		return area;
	}//endregion
	
	//region Function GetMapXNestingData
	// returns
	// t: the tslInstance to 
	double GetMapXNestingData(Entity ent, PlaneProfile& pp)
	{ 
		Map mapX = ent.subMapX("NestingData");
		pp = mapX.getPlaneProfile("pp");
		double area = mapX.getDouble("area");
		return area;
	}//End GetMapXNestingData //endregion

	//region Function GetMapXNestingArea
	// returns
	double GetMapXNestingArea(Entity ent)
	{ 
		double area = ent.subMapX("NestingData").getDouble("area");
		return area ;
	} //endregion

	//region Function SetChildNestingMap
	// returns a map for feeding the nester with child data
	// dMasterA, dMasterB: overrides to use full master size instead of real shape (if childs can only be nested one per corresponding dir)
	Map SetChildNestingMap(Entity entChild)
	{ 
		ChildPanel child = (ChildPanel)entChild;
		Sip sip = child.sipEntity();
		PlaneProfile pp = ProfNesting(sip, child.sipToMeTransformation() );
		double area = SetMapXNestingData(child, pp);

		Map out;
		out.setEntity("ent", child);
		out.setPlaneProfile("prof", pp);
		return out;
	}//endregion

	//region Function SetChildNestingMapWidth
	// returns a map for feeding the nester with child data
	// dMasterA, dMasterB: overrides to use full master size instead of real shape (if childs can only be nested one per corresponding dir)
	Map SetChildNestingMapWidth(Entity entChild, double width)
	{ 
		ChildPanel child = (ChildPanel)entChild;
		Sip sip = child.sipEntity();
		PlaneProfile pp = ProfNesting(sip, child.sipToMeTransformation() );
		
		PlaneProfile ppArea;
		CoordSys cs = pp.coordSys();
		double dx = pp.dX();
		double dy = pp.dY();
		Vector3d vecx = cs.vecX();
		Vector3d vecy = cs.vecY();
		
		if (dy>dx)
		{ 
			dx = dy;
			dy = pp.dX();
			vecx = vecy;
			vecy = cs.vecX();
		}
		Vector3d vec = .5 * vecx * dx + .5 * vecy * width;
		ppArea.createRectangle(LineSeg(pp.ptMid() - vec, pp.ptMid() + vec), vecx, vecy);
		ppArea.vis(6);

		double area = SetMapXNestingData(child, ppArea);

		Map out;
		out.setEntity("ent", child);
		out.setPlaneProfile("prof", pp);
		return out;
	}//endregion

	//region Function FindBestSingleMaster
	// returns the index of the best fitting master, -1 if none
	int FindBestMasterIndex(PlaneProfile pp, double lengths[], double widths[])
	{ 
		
//					ChildPanel child = childs[i]; 
//			Sip sip = child.sipEntity();
//			
//			PlaneProfile pp = ProfNesting(sip, child.sipToMeTransformation());
		
		int out = - 1;

		double dx = pp.dX();
		double dy = pp.dY();
		double dD;
		if(dx<dy)
		{ 
			dy = dx;
			dx = pp.dY();
		}
		double yieldBest, area = dx * dy;
		for (int i=0;i<lengths.length();i++) 
		{ 
			double dX = lengths[i];
			double dY = widths[i];
			if (dX<dx ||dY<dy){ continue;}
			
			double areaM = dX*dY;
			double yield = area / areaM;
			if (yield>yieldBest)
			{ 
				yieldBest = yield;
				out = i;
			}
		}//next i
		return out;
	}//endregion


	//region Function PurgePLines
	// purges all valid entplines from the dwg
	void PurgePLines(EntPLine epls[])
	{ 
	//Purge temp master plines	
		for (int i = epls.length() - 1; i >= 0; i--)
			if (epls[i].bIsValid())
				epls[i].dbErase();
		return;		
	}//endregion

	//region Function GetBestYield
	// returns the yield if the best result and sets bestIndex
	double GetBestYield(int& bestIndex, Map mapResults)
	{ 
		bestIndex = -1;
		double dBestYield;
		for (int i= 0; i< mapResults.length(); i++)
		{
			double yield = mapResults.getMap(i).getDouble(kYield);
			if (yield > dBestYield)
			{
				dBestYield = yield;
				bestIndex = i;
			}
		}	
		return dBestYield;
	}//endregion

	//region Function GetGrossYield
	// returns the additional gross yield which is based on the dimension wich cannot be nested with any other item
	// nAB: 0 = calculate yield based on greater dim of master, 1 = smaller dim (B)
	double GetGrossYield(ChildPanel childs[], Map mapResult, int nAB, int verbose)
	{ 
		double out;

		PlaneProfile ppMaster = mapResult.getPlaneProfile("prof");
		
		double A = dDProfile(ppMaster, vecXM);
		double B = dDProfile(ppMaster, vecYM);
		
		Map mapChilds = mapResult.getMap("Child[]");
		ChildPanel cs[] = GetChildsFromMap(mapChilds);
		double mins[0], maxs[0];
		GetChildDims(cs, mins, maxs);
		
		for (int i=0;i<cs.length();i++)
		{ 
		// the resulting child is of unique length	
			if (childs.find(cs[i])>-1)
			{ 
				Sip sip = cs[i].sipEntity();
				PlaneProfile pp = ProfNesting(sip, CoordSys());
				double areaNet = pp.area();
				double area = nAB==0?A*mins[i]:maxs[i]*B;
				double deltaArea = area - areaNet;
				if (deltaArea>0)
				{ 
					double deltaYield = deltaArea / ppMaster.area()*100;
					out += deltaYield;
					if (verbose>0)reportNotice("\n      modifying relevant yield due to unique length by " + (deltaYield) + "% " + (nAB==0?"Length":"Width") );
				}						
			}
		}		
		return out;
	}//endregion

//endregion 

//region Other Functions

	//region Function GetMasterStockSizes
	// returns if stock sizes could be found and the corresponding arrays
	// mapStyles: the stock map
	int GetMasterStockSizes(Map mapStyles, String style, double& lengths[], double& widths[])
	{ 

	// Get default dimensions from settings
		for (int i=0;i<mapStyles.length();i++) 
		{ 
			Map mapStyle= mapStyles.getMap(i);
			String name = mapStyle.getString("name").makeUpper();
			
			if (name == style.makeUpper())
			{ 
				Map mapSizes= mapStyle.getMap("Size[]");
				for (int j=0;j<mapSizes.length();j++) 
				{ 
					Map m = mapSizes.getMap(j);
					double dx = m.getDouble("dX");
					double dy = m.getDouble("dY");
					
					if (dx<=0 ||dy<=0){ continue;}					
					if (dx<dy) // ensure length is always larger dim
					{ 
						dx = dy;
						dy = m.getDouble("dX");
					}
					
					// TODO validate entries for duplicates	
					lengths.append(dx);
					widths.append(dy);					
				}
			}	 
		}//next i

	// order by width ascending
		for (int i=0;i<lengths.length();i++) 
			for (int j=0;j<lengths.length()-1;j++) 
				if (widths[j]>widths[j+1])
				{
					lengths.swap(j, j + 1);
					widths.swap(j, j + 1);
				}

	// order by length ascending
		for (int i=0;i<lengths.length();i++) 
			for (int j=0;j<lengths.length()-1;j++) 
				if (lengths[j]>lengths[j+1])
				{
					lengths.swap(j, j + 1);
					widths.swap(j, j + 1);
				}
		
		
		
		
		
		return lengths.length()>0;
	}////endregion

	//region Function GetTagPLine
	// returns an offseted and rounded pline
	PLine GetTagPLine(String text, Display dp, CoordSys cs, double textHeight, String dimStyle)
	{ 
		Point3d pt = cs.ptOrg();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();		

		dp.dimStyle(dimStyle);
		if (textHeight > 0)dp.textHeight(textHeight);
		else textHeight = dp.textHeightForStyle("O", dimStyle);
		double dx = dp.textLengthForStyle(text, dimStyle, textHeight);
		double dy = dp.textHeightForStyle(text, dimStyle, textHeight);
		

	// Build tag pline	
		Vector3d vec = .5 * (vecX * dx + vecY * dy);
		PLine plTag;
		plTag.createRectangle(LineSeg(pt-vec, pt+vec), vecX, vecY);
		plTag.offset(-.35 * textHeight, true);
		plTag.convertToLineApprox(dEps);
		plTag.vis(6);
		return plTag;
	}//End GetTagPLine //endregion

	//region Function CollectSips
	// returns two arrays of panels and childs
	// ents: an array of entities
	void CollectSips(Entity ents[], Sip& sips[], ChildPanel& childs[])
	{ 
		for (int i=0;i<ents.length();i++) 
		{ 
			ChildPanel child=(ChildPanel)ents[i]; 
			if (child.bIsValid())
			{ 
				Sip sip = child.sipEntity();
				if (sip.bIsValid() && sips.find(sip)<0)
				{ 
					sips.append(sip);
					childs.append(child);
				}
			}		 
		}//next i
		for (int i=0;i<ents.length();i++) 
		{ 
			Sip sip=(Sip)ents[i]; 
			if (sips.find(sip)<0)
			{ 
				sips.append(sip);
				childs.append(ChildPanel());
			}
		}//next i		
		return;
	}//End CollectSips //endregion

	//region Function GetPlaneProfiles
	// returns
	// t: the tslInstance to 
	PlaneProfile[] GetPlaneProfiles(Sip sips[], ChildPanel childs[])
	{ 
		PlaneProfile pps[0];
		if (sips.length()!=childs.length())
		{ 
			reportNotice("\n" + T("|Unexpected error collecting profiles|"));
			return pps;
		}
	
		for (int i=0;i<sips.length();i++) 
		{ 
			Sip sip = sips[i];
			CoordSys cs(sip.ptCen(), sip.vecX(), sip.vecY(), sip.vecZ());
			PlaneProfile pp(cs);			
			if (!sip.bIsValid())
			{ 
				pps.append(pp);
				continue;
			}

			pp.joinRing(sip.plEnvelope(),_kAdd); 
			
			ChildPanel child = childs[i];
			if (child.bIsValid())
				pp.transformBy(child.sipToMeTransformation());
			pps.append(pp);
		}//next i
		return pps;
	}//End GetPlaneProfiles //endregion

	//region Function CollectTypes
	// returns
	// t: the tslInstance to 
	void CollectTypes(Entity ents[], MasterPanel& masters[],  ChildPanel& childs[],Sip& sips[])
	{ 
		
	// Collect subtypes
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity& e = ents[i];
			MasterPanel master=(MasterPanel)e; 
			ChildPanel child=(ChildPanel)e; 
			Sip sip=(Sip)e; 
			if (master.bIsValid() && masters.find(master)<0)
				masters.append(master);
			else if (child.bIsValid() && childs.find(child)<0)
				childs.append(child);
			else if (sip.bIsValid() && sips.find(sip)<0)
				sips.append(sip);				
		}//next i	
		return;	
	}//End CollectTypes //endregion

	//region Function CollectChildsFromMasters
	// returns
	// t: the tslInstance to 
	void CollectChildsFromMasters(MasterPanel masters[],  ChildPanel& childs[])
	{ 
	// Collect from master
		for (int i=0;i<masters.length();i++) 
		{ 
			MasterPanel& master=masters[i]; 
			if (master.bIsValid())
			{ 
				ChildPanel nestedChilds[] = master.nestedChildPanels();
				for (int j=0;j<nestedChilds.length();j++) 
					if (childs.find(nestedChilds[j])<0)
						childs.append(nestedChilds[j]);
			}		 
		}//next i
		return;
	}//End CollectChildsFromMasters //endregion
	
	//region Function CollectChildsFromMasters
	// returns
	// t: the tslInstance to 
	void CollectSipsFromChilds(ChildPanel childs[],  Sip& sips[])
	{ 
	// Collect from master
		for (int i=0;i<childs.length();i++) 
		{ 
			ChildPanel& child=childs[i]; 
			if (child.bIsValid())
			{ 
				Sip sip = child.sipEntity();
				if (sip.bIsValid() && sips.find(sip)<0)
					sips.append(sip);
			}		 
		}//next i
		return;
	}//End CollectChildsFromMasters //endregion		

	//region Function GetSipChildRelations
	// returns all sips not having a childpanel associated. modifies the arrays to have matching sip/child arrays
	GenBeam[] GetSipChildRelations(GenBeam& gbs[], ChildPanel& childs[])
	{ 
		GenBeam gbsOut[0], gbsIn[] = gbs;;		
		Entity entChilds[] = Group().collectEntities(true, ChildPanel(), _kModelSpace);
		gbs.setLength(0);
		childs.setLength(0);
	
	// Collect any sip and its associated child
		for (int i=0;i<entChilds.length();i++) 
		{ 
			ChildPanel child= (ChildPanel)entChilds[i];
			if (child.bIsValid())
			{ 
				Sip sip = child.sipEntity();
				if (gbsIn.find(sip)>-1)
				{ 
					childs.append(child);
					gbs.append(sip);
				}
			}			 
		}//next i
	
	// Collect any sip of the input which has no child
		for (int i=0;i<gbsIn.length();i++) 
			if (gbs.find(gbsIn[i])<0)
				gbsOut.append(gbsIn[i]);
				
		return gbsOut;
	}//End GetSipsNoChilds //endregion

	//region Function GetFlattendTransformations
	// returns an array of transformations to flatten the array in XY-World
	// t: the tslInstance to 
	CoordSys[] GetFlattendTransformations(PlaneProfile pps[], Point3d ptRef, double maxWidth)
	{ 
		CoordSys css[0];
		
		Vector3d vecColumn;
		for (int i = 0; i < pps.length(); i++)
		{
			PlaneProfile pp = pps[i];
			CoordSys cs = pp.coordSys();

			CoordSys ms2ps = cs;
			ms2ps.invert();
			ms2ps.transformBy(ptRef - _PtW);		// tranform to location
			ms2ps.transformBy(vecColumn);			// tranform column location

			pp.transformBy(ms2ps);
			
		// Rotate if dx exceeds max width	
			double dx = dDProfile(pp, _XW);
			if (maxWidth>0 && dx>maxWidth)
			{ 
				CoordSys csRot;
				csRot.setToRotation(90, _ZW, pp.ptMid());
				pp.transformBy(csRot);			
				ms2ps.transformBy(csRot);					
			}
	
	
		// Vertical bottom alignment
			double dy = dDProfile(pp, _YW);
			Vector3d vecBot = _YW*.5*dy;
			pp.transformBy(vecBot);
			ms2ps.transformBy(vecBot);
	
		// Column alignment left
			Vector3d vecDX = _XW * .5 * dDProfile(pp, _XW);
			pp.transformBy(vecDX);
			ms2ps.transformBy(vecDX);
			//pp.vis(i);

			// next item
			vecColumn += (vecDX*2 + _XW * dColumnOffsetChild);


			css.append(ms2ps);
		}
	
		return css;
	}//End GetFlattendTransformations //endregion
	
	//region Function CallNester
	// calls nesting based on a map containing childs, master and optional nester data
	// and returns success of operation and potential left over entities
	// bTransformToMaster: boolean to deactivate/activate transformation
	int CallNester(Map& mapNesting, int bTransformToMaster, Entity& entLeftOvers[])
	{ 
		entLeftOvers.setLength(0);
		String k;
		
	// set default nester data
		double dDuration = 1;
		int bNestInOpening = false;
		double dNestRotation = 90;
		
	//region Validate input and set nester
		Map mapNestData = mapNesting.getMap("NestData");		
		Map mapChilds = mapNesting.getMap("Child[]");
		Map mapMasters = mapNesting.getMap("Master[]");
		int verboseMode = mapNesting.getInt("verboseMode");
		if (mapChilds.length()<1 || mapMasters.length()<1)
		{ 
			reportNotice("\nCall Nester: Invalid mapNesting");
			return false;
		}
		
		
		
		
		NesterCaller nester;		
		
	//endregion 	
	
	//region Nester Data
		NesterData nd;
		nd.setAllowedRunTimeSeconds(dDuration); //seconds
		nd.setMinimumSpacing(U(8));
		//nd.setChildOffsetX(-.5*dGapX);
		nd.setGenerateDebugOutput(bDebug);
		nd.setNesterToUse(_kNTRectangularNester);				
		
	// Get custom nester data	
		k= "AllowedRunTimeSeconds";	if (mapNestData.hasDouble(k)) 	nd.setAllowedRunTimeSeconds(mapNestData.getDouble(k));
		k= "MinimumSpacing";		if (mapNestData.hasDouble(k)) 	nd.setMinimumSpacing(mapNestData.getDouble(k));
		k= "NesterToUse";			if (mapNestData.hasInt(k)) 		nd.setNesterToUse(mapNestData.getInt(k));
				
	//endregion 	

	//region Childs
		int numChild;
		for (int j=0;j<mapChilds.length();j++) 
		{ 
			Map m = mapChilds.getMap(j);
			int nestInOpenings;
			double rotationAllowance=90;
			k= "NestInOpenings";	if (m.hasInt(k)) 	nestInOpenings = m.getInt(k);
			k= "RotationAllowance";	if (m.hasDouble(k)) 	rotationAllowance = m.getDouble(k);				
			
			Entity ent = m.getEntity("ent");
			PlaneProfile pp = m.getPlaneProfile("prof");
			if (!ent.bIsValid()){ continue;}
			
			numChild++;
			NesterChild nc(ent.handle(),pp);
			nc.setNestInOpenings(nestInOpenings);
			nc.setRotationAllowance(rotationAllowance);
			nester.addChild(nc); 
		}//next j
		if (numChild<1)
		{ 
			reportNotice("\nCall Nester: invalid childs");
			return false;
		}		
	//endregion 

	//region Master
		for (int j=0;j<mapMasters.length();j++)
		{ 
			Map mapMaster = mapMasters.getMap(j);
			Entity entMaster = mapMaster.getEntity("ent");
			PlaneProfile ppMaster = mapMaster.getPlaneProfile("prof");
			if (!entMaster.bIsValid() || ppMaster.area()<pow(dEps,2))
			{ 
				if (verboseMode>0)
					reportNotice("\nCall Nester: invalid master " +entMaster.bIsValid() + " area " + ppMaster.area());
				return false;
			}
			NesterMaster nm(entMaster.handle(), ppMaster);
			nester.addMaster(nm);				
		}
			
	//endregion 
	
	//region Log messages
		if (verboseMode>0)
		{ 
			String msg;
			for (int m=0; m<nester.masterCount(); m++) 
				msg+=TN("|Masterpanel|") + " " + nester.masterOriginatorIdAt(m);
			msg += "\n   "+nester.childCount() + " " + T(" | childs to be nested|");			
		}			
	//endregion 			
		
	//region Call Nester
		int nSuccess = nester.nest(nd, true);
		if (verboseMode>0)reportMessage("\nNestResult: "+nSuccess);
		if (nSuccess!=_kNROk) 
		{
			reportNotice("\n" + scriptName() + ": " + T("|Not possible to nest|"));
			if (nSuccess==_kNRNoDongle)
				reportNotice("\n" + scriptName() + ": " + T("|No dongle present|"));
			setExecutionLoops(2);
			return false;
		}	
		
	// collect  nesting results
		///master indices
		int nMasterIndices[] = nester.nesterMasterIndexes();	
		int nLeftOverChilds[] = nester.leftOverChildIndexes();
		//endregion

	//region Loop over the nester masters
		Map mapMasterResults;
		for (int m=0; m<nMasterIndices.length(); m++) 
		{
			
		// Master	
			int nIndexMaster = nMasterIndices[m];			
			Entity entMaster;
			entMaster.setFromHandle(nester.masterOriginatorIdAt(nIndexMaster));
			double areaMaster = GetMapXNestingArea(entMaster);
			if (verboseMode>0)
				reportNotice("\n\n   Master: "+nIndexMaster  + entMaster.formatObject("@(Handle)   @(NestingData.Area:CU;m:RL2)m²"));
			
		// Childs
			int nChildIndices[] = nester.childListForMasterAt(nIndexMaster);
			CoordSys csWorldXformIntoMasters[] = nester.childWorldXformIntoMasterAt(nIndexMaster);
			if (nChildIndices.length()!=csWorldXformIntoMasters.length()) 
			{
				reportNotice("\n" + scriptName()+": " + T("|The nesting result is invalid!|"));
				break;
			}
			
		// Report and/or Locate the childs within the master
			double areaChilds;
			Map mapNestedChilds;
			for (int c=0; c<nChildIndices.length(); c++) 
			{
				Entity entChild;		
				entChild.setFromHandle(nester.childOriginatorIdAt(nChildIndices[c]));
				if (!entChild.bIsValid()){ reportNotice("\nsetFromHandle failed on " + c); continue;}
				double areaChild = GetMapXNestingArea(entChild);
				areaChilds += areaChild;
				if (verboseMode>0)
					reportNotice("\n   Child: "+ c +  entChild.formatObject(" @(Handle)   @(NestingData.Area:CU;m:RL2)m²"));	
				
				if (bTransformToMaster)
				{ 
					CoordSys cs = csWorldXformIntoMasters[c];
					entChild.transformBy(cs);					
				}
				
				mapNestedChilds.appendEntity("Child", entChild);
			}
			
		// Get and store yield
			double yield = (areaMaster > 0 ? areaChilds/areaMaster:0) * 100;
			Map m = mapMasters.getMap(nIndexMaster);
			m.setDouble(kYield, yield);
			m.setMap("Child[]", mapNestedChilds);
			
			
			//mapMasters.setMap(nIndexMaster, m);
			//mapNesting.setMap("Master[]", mapMasters);
			if (mapNestedChilds.length()>0)
			{ 
				mapMasterResults.appendMap(nIndexMaster, m);
				if (verboseMode>0)
					reportNotice("\n   Master: "+nIndexMaster + entMaster.formatObject(" has @(Yield)%, left overs ("+nLeftOverChilds.length() +")",m));
			}

		}//endregion 
		
		mapNesting.setMap("MasterResult[]", mapMasterResults);
		//reportNotice("\n   #Results: "+mapMasterResults.length() + " vs " + mapNesting.getMap("master[]").length());
		
		
		
	//region Collect potential left over entities for further processing
		for (int c=0; c<nLeftOverChilds.length(); c++) 
		{
			Entity ent; 
			ent.setFromHandle(nester.childOriginatorIdAt(nLeftOverChilds[c]));			
			if (ent.bIsValid())
				entLeftOvers.append(ent);

		}	
	//endregion 

		return true;
	}//endregion

	//region Function CallNester2
	// calls nesting based on a map containing childs, master and optional nester data
	// and returns success of operation and potential left over entities
	// bTransformToMaster: boolean to deactivate/activate transformation
	Map CallNester2(Map mapNesting, int bTransformToMaster, Entity& entLeftOvers[])
	{ 
		Map out;
		entLeftOvers.setLength(0);
		String k;
		
	// set default nester data
		double dDuration = 1;
		int bNestInOpening = false;
		double dNestRotation = 90;
		
	//region Validate input and set nester
		Map mapNestData = mapNesting.getMap("NestData");
		Map mapChilds = mapNesting.getMap("Child[]");
		Map mapMasters = mapNesting.getMap("Master[]");
		int verboseMode = mapNesting.getInt("verboseMode");
		if (mapChilds.length()<1 || mapMasters.length()<1)
		{ 
			out.setString("err", "Call Nester2: Invalid mapNesting");
			reportNotice("\n" + out.getString("err"));
			return out;			
		}
		
		NesterCaller nester;		
		
	//endregion 	
	
	//region Nester Data
		NesterData nd;
		nd.setAllowedRunTimeSeconds(dDuration); //seconds
		nd.setMinimumSpacing(U(8));
		//nd.setChildOffsetX(-.5*dGapX);
		nd.setGenerateDebugOutput(bDebug);
		nd.setNesterToUse(_kNTRectangularNester);				
		
	// Get custom nester data	
		k= "AllowedRunTimeSeconds";	if (mapNestData.hasDouble(k)) 	nd.setAllowedRunTimeSeconds(mapNestData.getDouble(k));
		k= "MinimumSpacing";		if (mapNestData.hasDouble(k)) 	nd.setMinimumSpacing(mapNestData.getDouble(k));
		k= "NesterToUse";			if (mapNestData.hasInt(k)) 		nd.setNesterToUse(mapNestData.getInt(k));
				
	//endregion 	

	//region Childs
		int numChild;
		for (int j=0;j<mapChilds.length();j++) 
		{ 
			Map m = mapChilds.getMap(j);
			int nestInOpenings;
			double rotationAllowance=90;
			k= "NestInOpenings";	if (m.hasInt(k)) 	nestInOpenings = m.getInt(k);
			k= "RotationAllowance";	if (m.hasDouble(k)) 	rotationAllowance = m.getDouble(k);				
			
			Entity ent = m.getEntity("ent");
			PlaneProfile pp = m.getPlaneProfile("prof");
			if (!ent.bIsValid()){ continue;}
			
			numChild++;
			NesterChild nc(ent.handle(),pp);
			nc.setNestInOpenings(nestInOpenings);
			nc.setRotationAllowance(rotationAllowance);
			nester.addChild(nc); 
		}//next j
		if (numChild<1)
		{ 			
			out.setString("err", "Call Nester2: invalid childs" );
			reportNotice("\n" + out.getString("err"));
			return out;
		}		
	//endregion 

	//region Master
		for (int j=0;j<mapMasters.length();j++)
		{ 
			Map mapMaster = mapMasters.getMap(j);
			Entity entMaster = mapMaster.getEntity("ent");
			PlaneProfile ppMaster = mapMaster.getPlaneProfile("prof");
			if (!entMaster.bIsValid() || ppMaster.area()<pow(dEps,2))
			{ 
				out.setString("err", "Call Nester2: invalid master " +entMaster.bIsValid() + " area " + ppMaster.area() );
				reportNotice("\n" + out.getString("err"));
				return out;
			}
			NesterMaster nm(entMaster.handle(), ppMaster);
			nester.addMaster(nm);				
		}
			
	//endregion 
	
	//region Log messages
		if (verboseMode>0)
		{ 
			String msg;
			for (int m=0; m<nester.masterCount(); m++) 
				msg+=TN("|Masterpanel|") + " " + nester.masterOriginatorIdAt(m);
			msg += "\n   "+nester.childCount() + " " + T(" | childs to be nested|");			
		}			
	//endregion 			
		
	//region Call Nester
		int nSuccess = nester.nest(nd, true);
		//if (verboseMode>0)reportNotice("\nNestResult: "+nSuccess);
		if (nSuccess!=_kNROk) 
		{
			String msg = scriptName() + ": " + T("|Not possible to nest|");
			if (nSuccess==_kNRNoDongle)
				msg+= T(", |dongle not found|");
			out.setString("err",msg);
			out.setInt("NestResult", nSuccess);
			reportNotice("\n" + out.getString("err"));
			return out;
		}	
		
	// collect  nesting results
		///master indices
		int nMasterIndices[] = nester.nesterMasterIndexes();	
		int nLeftOverChilds[] = nester.leftOverChildIndexes();
		//endregion

	//region Loop over the nester masters
		Map mapMasterResults;
		for (int m=0; m<nMasterIndices.length(); m++) 
		{
			
		// Master	
			int nIndexMaster = nMasterIndices[m];			
			Entity entMaster;
			entMaster.setFromHandle(nester.masterOriginatorIdAt(nIndexMaster));
			double areaMaster = GetMapXNestingArea(entMaster);
			if (verboseMode>0)
				reportNotice("\n      Master: "+nIndexMaster  + entMaster.formatObject("@(Handle)   @(NestingData.Area:CU;m:RL2)m²"));
			
		// Childs
			int nChildIndices[] = nester.childListForMasterAt(nIndexMaster);
			CoordSys csWorldXformIntoMasters[] = nester.childWorldXformIntoMasterAt(nIndexMaster);
			if (nChildIndices.length()!=csWorldXformIntoMasters.length()) 
			{
				reportNotice("\n" + scriptName()+": " + T("|The nesting result is invalid!|"));
				break;
			}
			
		// Report and/or Locate the childs within the master
			double areaChilds;
			Map mapNestedChilds;
			for (int c=0; c<nChildIndices.length(); c++) 
			{
				Entity entChild;		
				entChild.setFromHandle(nester.childOriginatorIdAt(nChildIndices[c]));
				if (!entChild.bIsValid()){ reportNotice("\nsetFromHandle failed on " + c); continue;}
				double areaChild = GetMapXNestingArea(entChild);
				areaChilds += areaChild;
				if (verboseMode>0)
					reportNotice("\n      Child: "+ c +  entChild.formatObject(" @(Handle)   @(NestingData.Area:CU;m:RL2)m²"));	
				
				if (bTransformToMaster)
				{ 
					CoordSys cs = csWorldXformIntoMasters[c];
					entChild.transformBy(cs);					
				}
				
				Map m = SetChildNestingMap(entChild);
				mapNestedChilds.appendMap("Child", m);
			}
			
		// Get and store yield
			double yield = (areaMaster > 0 ? areaChilds/areaMaster:0) * 100;
			Map m = mapMasters.getMap(nIndexMaster);
			m.setDouble(kYield, yield);
			m.setMap("Child[]", mapNestedChilds);
			
			
			//mapMasters.setMap(nIndexMaster, m);
			//mapNesting.setMap("Master[]", mapMasters);
			if (mapNestedChilds.length()>0)
			{ 
				out.appendMap(nIndexMaster, m);
				if (verboseMode>0)
					reportNotice("\n      Master["+nIndexMaster + T("] |Yield|: ")+entMaster.formatObject(" @(Yield)%, left overs ("+nLeftOverChilds.length() +")",m));
			}

		}//endregion 

		//reportNotice("\n   #Results: "+mapMasterResults.length() + " vs " + mapNesting.getMap("master[]").length());
		
		
		
	//region Collect potential left over entities for further processing
		for (int c=0; c<nLeftOverChilds.length(); c++) 
		{
			Entity ent; 
			ent.setFromHandle(nester.childOriginatorIdAt(nLeftOverChilds[c]));			
			if (ent.bIsValid())
				entLeftOvers.append(ent);

		}	

	//endregion 

		return out;
	}//endregion
	
	//region Function getDimStyles
	// returns the relevant dimstyles
	// t: the tslInstance to 
	void GetDimStyles(int nDimMode, String& sDimStyles[], String& sSourceDimStyles[])
	{ 
	
		sDimStyles.setLength(0);
		sSourceDimStyles.setLength(0);
		
	// Find DimStyle Overrides, order and add Linear only
		String key = "$1"; // linear
		if(nDimMode==0)
			key = "$3";
		else if(nDimMode==1)
			key = "$4";
		else if(nDimMode==2)
			key = "$3";
		else if(nDimMode==3)// arc measure: use angular
			key = "$2";			
		
	// append potential linear overrides	
		String sOverrides[0];
		for (int i=0;i<_DimStyles.length();i++) 
		{ 
			String dimStyle = _DimStyles[i]; 
			int n = dimStyle.find(key, 0, false);	// indicating it is a linear override of the dimstyle
			if (n>-1 && sSourceDimStyles.find(dimStyle,-1)<0)
			{
				sDimStyles.append(dimStyle.left(n));
				sSourceDimStyles.append(dimStyle);
			}
		}//next i
		
	// append all non overrides	
		for (int i = 0; i < _DimStyles.length(); i++)
		{
			String dimStyle = _DimStyles[i]; 
			int nx = dimStyle.find("$", 0, false);	// <0 it is not any override of the dimstyle
			if (nx<0 && sDimStyles.findNoCase(dimStyle)<0)
			{ 
				sDimStyles.append(dimStyle);
				sSourceDimStyles.append(dimStyle);				
			}
		}

	// order alphabetically
		for (int i=0;i<sDimStyles.length();i++) 
		{ 
			for (int j=0;j<sDimStyles.length()-1;j++) 
				if (sDimStyles[j]>sDimStyles[j+1])
				{
					sDimStyles.swap(j, j + 1);
					sSourceDimStyles.swap(j, j + 1);
					}
		}

		return;
	}//endregion

//endregion 



//End Functions//endregion

//region Settings - Properties - OnInsert
		
//region Painter Collections
	String tDisabled = T("<|Disabled|>");
	String sPainterCollection = "SIP Nesting\\";
	String sPainters[0],sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();
	for (int i=0;i<sAllPainters.length();i++) 
	{ 
		if (sAllPainters[i].find(sPainterCollection,0,false)==0)
		{
			String s = sAllPainters[i];
			s = s.right(s.length() - sPainterCollection.length());
			if (sPainters.findNoCase(s,-1)<0)
				sPainters.append(s);
		}		 
	}//next i
	int bFullPainterPath = sPainters.length() < 1;
	if (bFullPainterPath)
	{ 
		for (int i=0;i<sAllPainters.length();i++) 
		{ 
			String s = sAllPainters[i];
			if (sPainters.findNoCase(s,-1)<0)
				sPainters.append(s);
		}//next i		
	}
	sPainters.insertAt(0, tDisabled);
	String sPainterDesc = T(" |If a painter collection named 'SIP Nesting' is found only painters of this collection are considered.|");
//endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="SIP-MPM";
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
	
	
	Map mapStyles = mapSetting.getMap("Style[]");
	
	
	
	
	double dMaxWidth = U(1223);
	int mode = _Map.getInt("mode");
	// 1: instance holding all childpanels to create masters
	// 99: sip based test instance
//End Settings//endregion	

//region Properties
category = T("|Filter + Grouping|");
	String sPainterName=T("|Painter|");	
	
	PropString sPainter(nStringIndex++, sPainters, sPainterName);	
	sPainter.setDescription(T("|Defines the painter definition to filter and group entities|") +sPainterDesc );
	sPainter.setCategory(category);
	int nPainter = sPainters.findNoCase(sPainter,-1);
	if (nPainter<0){ nPainter=0;sPainter.set(sPainters[nPainter]);}
	String sPainterDef = bFullPainterPath ? sPainter : sPainterCollection + sPainter;	
	//Catch case sensity, weired :-<
	{ 
		int n = sAllPainters.findNoCase(sPainterDef ,- 1);
		if (n>-1)
			sPainterDef = sAllPainters[n];
	}


	String tAscending = T("|Ascending|"), tDescending = T("|Descending|"), sSortDirections[] ={ tAscending, tDescending};
	String sSortDirectionName=T("|Sort Direction|");	
	PropString sSortDirection(nStringIndex++,sSortDirections, sSortDirectionName);	
	sSortDirection.setDescription(T("|Defines the Sorting Direction|"));
	sSortDirection.setCategory(category);	

category = T("|Nesting|");
	String sMinYieldName=T("|Minimal Yield %|");	
	PropDouble dMinYield(nDoubleIndex++,80, sMinYieldName, _kNoUnit);	
	dMinYield.setDescription( T("|The minimum yield denotes the acceptable yield that will not be forwarded to the nesting process.|")+ T(" |A value of zero dispatches all panels to the nester.|"));
	dMinYield.setCategory(category);

	String sGapName=T("|Gap|");	
	PropDouble dGap(nDoubleIndex++, U(8), sGapName);	
	dGap.setDescription(T("|Defines the Gap betwenn the child panels|"));
	dGap.setCategory(category);


category = T("|Display|");
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "@(ElementNumber:D)\n@(Style)\n@(SolidLength:RL0)x@(SolidWidth:RL0)", sFormatName);	
	sFormat.setDescription(T("|Defines the format how properties of a child panel will be displayed|"));
	sFormat.setCategory(category);
	if (_Sip.length()<1)sFormat.setDefinesFormatting(Sip());
	else sFormat.setDefinesFormatting(_Sip.first());
	
	String sDimStyles[0], sSourceDimStyles[0];
	GetDimStyles(-1, sDimStyles, sSourceDimStyles);
	
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(nStringIndex++, sDimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
	String dimStyle = sSourceDimStyles[sDimStyles.find(sDimStyle,0)];
	if (_DimStyles.findNoCase(dimStyle ,- 1) < 0)dimStyle = _DimStyles.first();

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(60), sTextHeightName,_kLength);	
	dTextHeight.setDescription(T("|Defines the TextHeight|"));
	dTextHeight.setCategory(category);	

	int nProps[]={};			
	double dProps[]={dMinYield,dGap, dTextHeight};				
	String sProps[]={sPainter,sSortDirection,sFormat,sDimStyle};
	
	
//End Properties//endregion 

//region Property Dependent Functions

	//region Function CreateMaster
	// creates the masterpanel expecting the profile to carry the master coordsys
	MasterPanel CreateMaster(PlaneProfile ppMaster, String style)
	{ 
		if (ppMaster.area()<pow(dEps,2))
		{ 
			reportNotice("\nCreateMaster: " + T("|Unexpected Error|"));
			return MasterPanel();
		}
		CoordSys csEcs = ppMaster.coordSys();
		LineSeg seg = ppMaster.extentInDir(-csEcs.vecX());	//seg.vis(2);
		Point3d ptRef = ppMaster.ptMid() - (seg.ptStart() - seg.ptMid());
		
		MasterPanel master;
		master.dbCreate(style, csEcs, ppMaster.dX(), ppMaster.dY());
		master.setPtRef(ptRef);	ptRef.vis(2);
		
	// create TSL
		TslInst tslNew;
		GenBeam gbsTsl[] = {};		
		Entity entsTsl[] = {master};			
		Point3d ptsTsl[] = {ptRef-csEcs.vecY() * U(50)};
		Map mapTsl;	mapTsl.setInt("mode", 1);
			
		tslNew.dbCreate(bDebug?sFileName:scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);					
	
		return master;
	}//endregion	


//endregion 

//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
		
	//region Setup Mode
		if (mapStyles.length()<1)
		{ 
			String msg1 = TN("|Please use the context menu and select master panels representing the allowed styles.|");
			String msg2 = TN("|The first specified style may also be cloned for all other styles.|");
			
			reportNotice("\n*** " + scriptName() + T("|Setup|") +" ***" + TN("|You need to configure the allowed master panel styles.|") + 
			 msg1 + msg2);
			
			sFormat.set(msg1 + "\n"+ T("|Command|: ")+sTriggerAddStockSize+msg2 + "\n ");
			_Map.setInt("mode", 3);
			_Pt0 = getPoint();
			return;
		}
	//endregion 		
		
		
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();
		

		
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select entities|"), Sip());
		ssE.addAllowedClass(ChildPanel());
		ssE.addAllowedClass(MasterPanel());
		if (ssE.go())
			ents.append(ssE.set());

		Sip sips[0];
		MasterPanel masters[0];
		ChildPanel childs[0];
		
		CollectTypes(ents, masters, childs, sips);
		CollectChildsFromMasters(masters, childs);
		CollectSipsFromChilds(childs, sips);

		_Pt0 = getPoint();

	//region Create a sip based test instance
		int bCreateSipTest=false;
		if (bCreateSipTest)	
		{ 
			_Map.setInt("mode", 99);
			_Sip.append(sips);
			return;
		}
	//endregion 


	//region Create AllChildPanel instance
		sPainterDef = bFullPainterPath ? sPainter : sPainterCollection + sPainter;
		if (sPainterDef!=tDisabled)
		{
			SortByPainter(sips, sPainterDef, sSortDirection == tAscending);	
		}
		Sip sipsNoChild[] = GetSipsNoChilds(sips);

	// Collect profiles and flattend transformations	
		double dMin, dMax;
		PlaneProfile pps[]=CollectPlaneProfiles(sips,dMin,dMax);	
		CoordSys css[] = GetFlattendTransformations(pps, _Pt0, dMaxWidth);	

	// get flattend profiles and create missing childs
		for (int i=0;i<sips.length();i++) 
		{ 
			Sip sip = sips[i]; 
			PlaneProfile pp = pps[i]; 
			CoordSys ms2ps = css[i];
			
			if (sip.bIsValid() && sipsNoChild.find(sip) >-1)
			{ 
				pp.transformBy(ms2ps);
				Point3d pt = pp.ptMid() - _YW * dRowOffsetMaster;
				ChildPanel child;
				child.dbCreate(sip, pt, pp.dX()>pp.dY()?-_XW:_YW);
				childs.append(child);	
			}
		}//next i

		for (int i=0;i<childs.length();i++) 
			_Entity.append(childs[i]); 
		
		
	// Purge all selected masters
		for (int i=masters.length()-1; i>=0 ; i--) 
			if (masters[i].bIsValid())
				masters[i].dbErase(); 
	
		_Map.setInt("mode", 4);
		return;			
	//endregion 

	}			
//endregion 

//region Display
	Display dpWhite(-1),dpText(5), dp(0);
	dpWhite.trueColor(rgb(255, 255, 254));
	
	dpText.dimStyle(dimStyle);
	double textHeight = dTextHeight;
	if (textHeight<=0)
	{
		textHeight = dpText.textHeightForStyle("O", dimStyle);
	}
	dpText.textHeight(textHeight);
			
//endregion 

// Settings - Properties - Insert //endregion 

//region #FU

//region Nesting Functions

	//region Function RunPreNesting
	// returns the childs which were successfully nested
	MasterPanel[] RunPreNesting(ChildPanel childsIn[], PlaneProfile ppRawMasters[], Map& mapNesting, int verboseMode, Point3d& ptLoc)
	{ 
		MasterPanel out[0]; 
		String sMasterStyle = mapNesting.getString("Style");
		
	//Run pline pre-nesting and and post process nesting
		ChildPanel childsRun[0], childsOut[0];
		childsRun = childsIn;
		int nMaxAttempt = childsRun.length();
		int bDoNest = childsIn.length() > 0, cnt;
		while(cnt<nMaxAttempt && bDoNest && childsRun.length()>0)
		{
			reportNotice("\nRun Pre Nesting: run " +(cnt+1) + " on childs (" + childsRun.length()+")");
			
			Map mapNestData, mapMaster,mapMasters;
			
		//region Build input for temp pline based nesting input
			EntPLine epls[0];
			for (int j=0;j<ppRawMasters.length();j++)
			{ 
				PlaneProfile ppRaw = ppRawMasters[j];
				PLine pl; pl.createRectangle(ppRaw.extentInDir(_XW), _XW, _YW);

				for (int i=0;i<nMaxAttempt;i++) 
				{ 
					EntPLine epl;
					epl.dbCreate(pl);
					//epl.setColor(i); epl.transformBy(_YW * (i * U(20)));
					epls.append(epl);
					double area = SetMapXNestingData(epl, PlaneProfile(pl));

					mapMaster.setEntity("ent", epl);
					mapMaster.setPlaneProfile("prof", ppRaw);	
					mapMasters.appendMap("Master", mapMaster);
				}//next i
				
			}
			mapNesting.setMap("Master[]", mapMasters);
			
			
			Map mapChilds;// = mapNesting.getMap("Child[]");
			for (int i=0;i<childsRun.length();i++) 
			{ 
				ChildPanel child = childsRun[i];
				Sip sip = child.sipEntity();
				PlaneProfile pp = ProfNesting(sip, child.sipToMeTransformation() );
				double area = SetMapXNestingData(child, pp);
	
				Map m;
				m.setEntity("ent", child);
				m.setPlaneProfile("prof", pp);
				mapChilds.appendMap("child", m);
			}//next i
			mapNesting.setMap("Child[]", mapChilds);			
								
		//endregion 	

		//region Run nester and get best accepted result
			mapNesting.setInt("verboseMode", false);
			Entity entLeftOvers[0];
			int bOk= CallNester(mapNesting, false,entLeftOvers);
			
			
		// Get max yield
			double dBestYield; 
			int nBestIndex = -1;
			{ 
				Map maps = mapNesting.getMap("Master[]");
				for (int j=0;j<maps.length();j++) 
				{
					double yield = maps.getMap(j).getDouble(kYield);
					if (yield>dBestYield)
					{ 
						dBestYield = yield;
						nBestIndex = j;
					}				
				}
			}
			if(verboseMode>0)reportNotice("\nBest yield " + dBestYield + "%, Index " + nBestIndex);				
			
			if (dBestYield<dMinYield)
			{ 
				if(verboseMode>0)reportNotice("...rejected -> does not match min requested value");
				bDoNest = false;
			}				
		//endregion 	


		//region Run real nesting based on best result of pre-nesting
			else
			{ 
				mapNesting.setInt("verboseMode", verboseMode);
				
			// Get size from prenesting result	
				mapMasters = mapNesting.getMap("Master[]");
				mapMaster = mapMasters.getMap(nBestIndex);
				
				PlaneProfile ppMaster = mapMaster.getPlaneProfile("prof");
				double dx = ppMaster.dX();
				double dy = ppMaster.dY();
				if (dx<dEps || dy<dEps)
				{
					reportNotice("\nRun Pre Nesting: BestIndex= " +nBestIndex+ " invalid master profile during attempt " + cnt);
				// Purge temp master plines	
					for (int i=epls.length()-1; i>=0 ; i--) 
						if (epls[i].bIsValid())
							epls[i].dbErase(); 
					break;
				}
				
			// Create new Masterpanel	
				
				CoordSys csEcs(ptLoc+.5*(dx*_XW + dy*_YW), _YW, -_XW, _ZW);//
				MasterPanel master;
				master.dbCreate(sMasterStyle, csEcs, dy, dx);
				master.setPtRef(ptLoc+_XW*ppMaster.dX());				
				double area = SetMapXNestingData(master, ppMaster);
			
			
			// Rebuild nestings map
				ppMaster.createRectangle(LineSeg(ptLoc, ptLoc + (dx * _XW + dy * _YW)), _YW ,- _XW);
				Map m;
				m.setEntity("ent", master);
				m.setPlaneProfile("prof",ppMaster);

				mapMasters = Map();
				mapMasters.appendMap("Master", m);
				mapNesting.setMap("Master[]", mapMasters);
				mapNesting.setInt("verboseMode", verboseMode);
				
			// Call nesting	
				Entity entLeftOvers2[0];
				int bOk= CallNester(mapNesting, true, entLeftOvers2);
				
				if(verboseMode>0)reportNotice("\nRun Pre Nesting:  creating master " + dx + "x" + dy + " nBestIndex " +nBestIndex + " yield " + mapMaster.getDouble(kYield));
				
				ChildPanel childLeftOvers[0];
				for (int i=0;i<entLeftOvers2.length();i++) 
					childLeftOvers.append((ChildPanel)entLeftOvers2[i]); 
				
				if (childLeftOvers.length()==childsRun.length())
				{ 
					if (master.bIsValid())
						master.dbErase();
						
				// Purge temp master plines	
					for (int i=epls.length()-1; i>=0 ; i--) 
						if (epls[i].bIsValid())
							epls[i].dbErase();
							
					reportNotice("\nThe input and leftovers identical, no succesful result");
					break;
				} 
				else if (master.bIsValid())
					out.append(master);
				
				
			// Create masters tsl
				TslInst tslNew;
				GenBeam gbsTsl[] = {};					
				Point3d ptsTsl[] = {ptLoc};
				Entity entsTsl[] = {master};
				Map mapTsl; mapTsl.setInt("mode", 1);
				
				ptsTsl[0] = ptLoc - _YW * textHeight;
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
				
				ptLoc.transformBy(_XW * (dx + dColumnOffsetMaster));

				childsRun = childLeftOvers;
				cnt++;	
				reportNotice("\nnext attempt with childs (" + childsRun.length()+")");
			}
								
		//endregion 

		//region Purge temp master plines	
			for (int i=epls.length()-1; i>=0 ; i--) 
				if (epls[i].bIsValid()) 
					epls[i].dbErase(); 					
		//endregion 

		}//do while				
	
		return out;
	}//endregion

//endregion 

	//region Function ValidateMasterStyle
	// returns if the corresponding masterpanelStyle could be found

	int ValidateMasterStyle(String& style)
	{ 
		String styles[] = MasterPanelStyle().getAllEntryNames();
		int bValid =styles.findNoCase(style,-1)>-1;
		if (!bValid)
		{ 
		// Custom convention 'xxx SIP'	
			if (style.right(4).makeUpper()==" SIP")
				style = style.left(style.length()-4).trimRight();
			bValid =styles.findNoCase(style,-1)>-1;	
		}
		return bValid;
	}//End ValidateMasterStyle //endregion

	//region Function SingleDispatches
	// returns
	// t: the tslInstance to 
	GenBeam [] SingleDispatches(GenBeam gbs[],PlaneProfile pps[], int& indices[], double minYield, double dMinDim, double dLengths[], double dWidths[])
	{ 

	// Collect panels which can be nested one on one with expected yield
		GenBeam out[0];		
		indices.setLength(0);
		for (int i=0;i<gbs.length();i++) 
		{ 
			GenBeam gb = gbs[i]; 
			PlaneProfile pp = pps[i]; 
			double dX = pp.dX();
			double dY = pp.dY();

			for (int j=0;j<dLengths.length();j++) 
			{ 
				double dXM = dWidths[j];
				double dYM = dLengths[j];
				int bXOverYM = dXM < dYM ? true : false;
				double dMinM = bXOverYM ? dXM : dYM;
				
				double dMasterArea = dXM * dYM;
	
				double dXS = dX;
				double dYS = dY;
				int bXOverYS = dXS < dYS ? true : false;
				double dMinS = bXOverYS ? dX : dY;
				
				int bNoNesting;
				double dRemainingWidth = dMinM - dMinS - dGap;
				
				double dMinWidthForNesting = dMinM - dGap-dXYMinimum;
				if (dRemainingWidth<dXYMinimum || dMinS>dMinWidthForNesting)
					bNoNesting = true;
	
				else if (dMinS>dMinDim) // it's not the smallest panel of the set
				{
					dMinWidthForNesting = dMinM - dGap-dMinDim;
				}

				//(dMinDim>dXYSipDim?dMinDim:dXYSipDim);
//				if (dMinWidthForNesting<dXYSipDim)
//					dMinWidthForNesting = dXYSipDim;
	
	
				double dLeftOverWidth = dMinM - dMinS;
	
			// accept also strips which would have a left over diemnsion below the min value	
				if (bNoNesting)//dLeftOverWidth<dXYSipDim || 
				{ 
					if (bXOverYS)
						dXS =bXOverYM?dXM:dYM;
					else
						dYS =bXOverYM?dXM:dYM;
				}
				
				double dSipArea = dXS * dYS;
				int bx = dXM >= dXS;
				int by = dYM >= dYS;
				if (!bx || !by)
				{ 
					bx = dYM >= dXS;
					by = dXM >= dYS;
				}
				
				double yield = dMasterArea>0?dSipArea / dMasterArea:0;			
				if (yield>0 && yield>minYield && bx && by)
				{ 
					out.append(gb);
					indices.append(j);
					break;
				}				 
			}//next j
		}//next i	
		return out;
	}//End SingleDispatches //endregion

	//region Function CollectMinMaxGroups
	// returns an array of maps which contain groups of childs of similar dimensions
	Map[] CollectMinMaxChildGroups(ChildPanel childs[], int minMaxMode)
	{ 
		Map mapGroups[0];
		double dimGroups[0];

		double mins[0], maxs[0];
		GetChildDims(childs, mins, maxs);

		
		for (int i=0;i<childs.length();i++) 
		{ 
			ChildPanel child = childs[i];
			double dD;
			if(minMaxMode==0)
				dD= mins[i];	
			else if(minMaxMode==1)
				dD= maxs[i];					
			dD = round(dD);
			
			int n = dimGroups.find(dD);
			Map mapGroup;
			if (n<0)
			{
				dimGroups.append(dD);
				mapGroup.setDouble("dD", dD);
				mapGroups.append(mapGroup);
				n = mapGroups.length()-1;
			}
			else
			{
				mapGroup = mapGroups[n];
			}
			
			Map mapChilds = mapGroup.getMap("Child[]");
			mapChilds.appendEntity("Child", child);
			mapGroup.setMap("Child[]", mapChilds);
			mapGroups[n] = mapGroup;
		}//next i	
		
		return mapGroups;
	}//End //endregion

	//region Function CollectMinMaxGroups
	// returns how many groups of the same min or max dim can be found
	void CollectMinMaxGroups(GenBeam sipsSet[], GenBeam gbs[],PlaneProfile pps[], int minMaxMode, int& numGroups, double& dimGroups[])
	{ 
		dimGroups.setLength(0);
		numGroups.setLength(0);
		
		for (int i=0;i<sipsSet.length();i++) 
		{ 
			GenBeam& gb= sipsSet[i]; 
			int x = gbs.find(gb);
			if (x<0){ continue;}

			PlaneProfile& pp = pps[x]; 
			double dX = pp.dX();
			double dY = pp.dY();
			double dD;
			if(minMaxMode==0)
				dD= dX < dY ? dX : dY;	
			else if(minMaxMode==1)
				dD= dX > dY ? dX : dY;					
			dD = round(dD);
			
			int n = dimGroups.find(dD);
			if (n<0)
			{
				dimGroups.append(dD);
				numGroups.append(1);
			}
			else
			{ 
				numGroups[n]++;
			}
		}//next i	
		
		return ;
	}//End CollectMinMaxGroups //endregion	

	//region Function CollectMinMaxGbs
	// returns
	GenBeam[] CollectMinMaxGbs(GenBeam gbs[],PlaneProfile pps[], int minMaxMode, double dDGroup)
	{ 
		GenBeam out[0];
		for (int i=0;i<gbs.length();i++) 
		{ 
			GenBeam& gb= gbs[i]; 
	
			PlaneProfile& pp = pps[i]; 
			double dX = pp.dX();
			double dY = pp.dY();
			double dD;
			if(minMaxMode==0)
				dD= dX < dY ? dX : dY;	
			else if(minMaxMode==1)
				dD= dX > dY ? dX : dY;					
			dD = round(dD);	
			
			if (abs(dD-dDGroup)<dEps)
			{ 
				out.append(gb);
			}
			
			
		}//next j
	
		return out;
	}//End CollectMinMaxGbs //endregion

	//region Function FilterNotThis
	// mimics filterGenBeamsNotThis
	GenBeam[] FilterNotThis(GenBeam gbs[], GenBeam gbsNot[])
	{ 
		GenBeam out[0];
		for (int i=0;i<gbs.length();i++) 
		{ 
			GenBeam& gb = gbs[i]; 
			if (gbsNot.find(gb)<0)
				out.append(gb);
		}//next i		
		return out;
	}//End FilterNotThis //endregion
	
	//region Function FilterNotThis
	// mimics filterGenBeamsNotThis
	Entity[] FilterNotThisEntity(GenBeam gbs[], GenBeam gbsNot[])
	{ 
		Entity out[0];
		for (int i=0;i<gbs.length();i++) 
		{ 
			GenBeam& gb = gbs[i]; 
			if (gbsNot.find(gb)<0)
				out.append(gb);
		}//next i	
		return out;
	}//endregion

	//region Function DrawFlattened // TODO
	// returns
	// t: the tslInstance to 
	void DrawFlattened(GenBeam sipsSet[], GenBeam gbs[], PlaneProfile pps[],CoordSys css[], int color)
	{ 
		dpText.color(color);
		
		for (int i=0;i<sipsSet.length();i++) 
		{ 
			GenBeam gb = sipsSet[i]; 
			int x = gbs.find(gb);
			if (x < 0)continue;
			
			PlaneProfile pp = pps[x]; 
			CoordSys ms2ps = css[x];
			
			pp.transformBy(ms2ps);
			
			String text = gb.formatObject(sFormat);

			dpText.draw(pp, _kDrawFilled, 90);
			dpText.draw(pp);
			dpText.draw(text, pp.ptMid(), _XW, _YW, 0, 0);		
			
			//dpText.draw(PLine(pp.ptMid(), childs[x].realBody().ptCen()));		 
		}//next i
		return;
	}//End DrawFlattened //endregion
	
	//region Function CollectChildEntitiesByGenBeams
	// returns the child panels of the selected genbeams/sips
	// t: the tslInstance to 
	Entity[] CollectChildEntitiesByGenBeams(GenBeam gbs[])
	{ 
		Entity out[0];		
		Entity entChilds[] = Group().collectEntities(true, ChildPanel(), _kModelSpace);	

	// Collect any sip and its associated child
		for (int i=0;i<entChilds.length();i++) 
		{ 
			ChildPanel child= (ChildPanel)entChilds[i];
			if (child.bIsValid())
			{ 
				Sip sip = child.sipEntity();
				int n = gbs.find(sip);
				if (n>-1)
				{
					gbs.removeAt(n); // make sure we get only one child per sip
					out.append(child);
				}
			}			 
		}//next i

		return out;	
	}//End CollectChildEntitiesByGenBeams //endregion

//endregion



//region Painter Grouping
	if (mode == 4)
	{ 

	//region Get child panels
		ChildPanel childsAll[0];
		Sip sipsAll[0];
		for (int i=0;i<_Entity.length();i++) 
		{ 
			ChildPanel child =(ChildPanel) _Entity[i]; 
			if (!child.bIsValid()){ continue;}
			{ 
				Sip sip = child.sipEntity();
				sipsAll.append(sip);
				childsAll.append(child);
			} 
		}//next i

	// Collect and sort sips		
		SortByPainter(sipsAll, sPainterDef, sSortDirection == tAscending);	
		PainterDefinition pd(sPainterDef);
		String format = pd.format();
		
	// Collect groups into maps
		Map maps;
		for (int i=0;i<sipsAll.length();i++)
		{ 
			Entity e = sipsAll[i];
			String key = e.formatObject(format);
			if (maps.hasMap(key))
			{ 
				Map m = maps.getMap(key);
				Entity ents[] = m.getEntityArray("ent[]", "", "ent");
				ents.append(e);
				m.setEntityArray(ents, true, "ent[]", "", "ent");
				maps.setMap(key, m);
			}
			else
			{ 
				Map m;
				Entity ents[] = { e};
				m.setEntityArray(ents, true, "ent[]", "", "ent");
				maps.setMap(key, m);
			}			
		}
		
		
	// create mode 0 instances for each group
		Point3d pt = _Pt0;
		for (int i=0;i<maps.length();i++) 
		{ 
			Map m = maps.getMap(i);
			Entity ents[] = m.getEntityArray("ent[]", "", "ent");
			
			GenBeam gbs[0];
			AppendGenbeams(gbs, ents);
			Entity entsTsl[] = CollectChildEntitiesByGenBeams(gbs);

		// create TSL
			TslInst tslNew;
			GenBeam gbsTsl[] = {};					
			Point3d ptsTsl[] = {pt};
			
			Map mapTsl;	
			mapTsl.setInt("mode", 0);			


			if (!bDebug)
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
			else
				ptsTsl[0].vis(1);

			pt.transformBy(_YW * U(10000));
		}//next i
		
		
		
		if (bDebug)
			dpText.draw(scriptName() , _Pt0, _XW,_YW,1,0);
		else
			eraseInstance();
		return;
	}
//endregion 








//region Child Panel Mode #M0
	if (mode==0)
	{ 
		
	//region Set References and Defaults
		int nVerbose=1;	
		int nPhase=_Map.getInt("phase");


	//region Trigger CallNester
		int bNest = _Map.getInt(kCallNester);
		String sTriggerCallNester = T("|Nesting|");
		//if (sNester != tDisabledEntry)
			addRecalcTrigger(_kContextRoot, sTriggerCallNester );
		if (_bOnRecalc && (_kExecuteKey==sTriggerCallNester || _kExecuteKey==sDoubleClick))
		{
			_Map.setInt(kCallNester, true);		
			setExecutionLoops(2);
			return;
		}//endregion

	//region Get child panels
		ChildPanel childsAll[0];
		Sip sipsAll[0];
		for (int i=0;i<_Entity.length();i++) 
		{ 
			ChildPanel child =(ChildPanel) _Entity[i]; 
			if (!child.bIsValid()){ continue;}
			{ 
				Sip sip = child.sipEntity();
				sipsAll.append(sip);
				childsAll.append(child);
			} 
		}//next i
		if (childsAll.length()<1) 
		{ 
			reportMessage("\n"+scriptName() + T(": |No child panels found|"));
			eraseInstance();
			return;
		}	
		
	// Collect profiles	
		double dMin, dMax;
		PlaneProfile pps[]=CollectPlaneProfiles(sipsAll, dMin, dMax);	
		CoordSys css[] = GetFlattendTransformations(pps, _Pt0, dMaxWidth);
		
		String styles[] = CollectStyles(sipsAll);		
				
	//End Get child panels //endregion 

	//region Create one instance per style
		if (styles.length()>1)
		{ 
			//bDebug = true;
			if (nVerbose)	reportNotice("\nCreate an instance per style ("+styles.length()+")");

		// create TSL
			TslInst tslNew;
			GenBeam gbsTsl[] = {};					
			Point3d ptsTsl[] = {_Pt0};
			
			Map mapTsl;	
			mapTsl.setInt("mode", 0);

			for (int j=0;j<styles.length();j++) 
			{ 
				String style = styles[j]; 
				
			// get master style and stock sizes	
				String sMasterStyle = style;
				int bValidStyle = ValidateMasterStyle(sMasterStyle);
				if (!bValidStyle)
				{
					reportNotice("\n" +  T("|Could not find masterpanel style| '") + sMasterStyle + "'");
					continue;
				}
				double dLengths[0], dWidths[0];
				GetMasterStockSizes(mapStyles, sMasterStyle, dLengths, dWidths);
				double dYOffsetStyle = dRowOffsetMaster+ (dLengths.length() > 0 ?dLengths.last(): U(6000));
				
			// Create instance for style
				Entity entsTsl[] = CollectChildsByStyle(childsAll, style);
				if (entsTsl.length()>0)
				{ 
					if (nVerbose)	reportNotice("\n"+ style+ ",  create instance with childs ("+entsTsl.length()+")");
					if (!bDebug)
						tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
					else
						ptsTsl[0].vis(1);
					ptsTsl[0] += _YW * dYOffsetStyle;
				}
			}//next j style

			if (!bDebug)eraseInstance();
			return;
		}				
	//Create one instance per style //endregion 

	//region Get master style and stock sizes
		String style = styles.first();
		String sMasterStyle = style;
		int bValidStyle = ValidateMasterStyle(sMasterStyle);// validates and modifies ifd required
		if (!bValidStyle) 
		{ 
			dpText.draw("XX"+mode, _Pt0, _XW, _YW, 1, 0);
			reportNotice("\nUnexpected: Masterstyle not found.");
			return;
		}			
	
	// Get default dimensions from settings
		double dLengths[0], dWidths[0];
		if (!GetMasterStockSizes(mapStyles,sMasterStyle,dLengths, dWidths))
		{ 
		// fall back to something
			reportNotice("\n" + T("|Could not find any stock sizes for style| ") + sMasterStyle + T(" |Using default 5.5m x 1.22m instead.|"));
			dLengths.append(U(5500));
			dWidths.append(U(1223));
		}
		
	// Collect default master profiles for prenesting
		PlaneProfile ppRawMasters[0];
		for (int i=0;i<dLengths.length();i++) 
		{ 
			PlaneProfile pp(CoordSys());
			Vector3d vec = .5*(vecXM*dLengths[i]+vecYM*dWidths[i]); 
			pp.createRectangle(LineSeg(_Pt0-vec, _Pt0 + vec), _XW, _YW);
			ppRawMasters.append(pp);
		}//next i

	//endregion 

	//region Sort and filter selection
		ChildPanel childs[0];
		if (sPainter!=tDisabled)
		{
			Sip sipsSorted[] = sipsAll;
			SortByPainter(sipsSorted, sPainterDef, sSortDirection == tAscending);	
			childs = CollectChildsFromSips(sipsSorted);
		}
		else
			childs = childsAll;
	//endregion 

			
	//End Set References and Defaults //endregion 	


	MasterPanel mastersAll[0];
	ChildPanel childsNested[0], childsP1[0], childsP2[0],childsP3[0],childsP4[0],childsP5[0];

	Point3d ptLoc = _Pt0;


	int bDrawPhases = false; //#PH0

	int bRunPhase1 = true;
	int bRunPhase2= true;
	int bRunPhase3 = true;
	int bRunPhase4 = true;
	int bRunPhase5 = true;
	int bRunPhase6 = true;	

//	int bRunPhase1 = true;
//	int bRunPhase2= true;
//	int bRunPhase3 = false;
//	int bRunPhase4 = false;
//	int bRunPhase5 = false;
//	int bRunPhase6 = false;	

//	int bRunPhase1 = false;
//	int bRunPhase2= false;
//	int bRunPhase3 = true;
//	int bRunPhase4 = false;
//	int bRunPhase5 = false;
//	int bRunPhase6 = false;	

//	int bRunPhase1 = false;
//	int bRunPhase2= false;
//	int bRunPhase3 = false;
//	int bRunPhase4 = false;
//	int bRunPhase5 = true;
//	int bRunPhase6 = true;	


//region PHASE 1 Collect unique by width

	int phase = 1;
	int nPreview=1;

	if (bDrawPhases)DrawChildsFlattened(childs, sFormat, dpText, nPreview++, _Pt0-_YW*(1+nPreview)*dRowOffsetMaster, "Selection Set\nexpected yield ("+childs.length()+")\nunique length");
		


// #PH1
// Collect childs which can only be nested one by minimal dimension	
	int bCheckMax; // 0 = check smaller dim, 1 = check larger dim
	childsP1 = FilterChildsSingularAll(childs, dLengths, dWidths, dGap, bCheckMax);
	OrderChilds(childsP1, kDescending, kOTArea); // order by area
	if (bDrawPhases)DrawChildsFlattened(childsP1, sFormat, dpText, nPreview++, _Pt0-_YW*(1+nPreview)*dRowOffsetMaster, " ("+childsP1.length()+")\nunique width");
	
	bCheckMax = 1;
	
	childsP2 = FilterChildsSingularAll(childs, dLengths, dWidths, dGap, bCheckMax);	
	OrderChilds(childsP2, kDescending, kOTArea); // order by area
	//DrawChildsFlattened(childsP2, sFormat, dpText, nPreview++, _Pt0-_YW*(1+nPreview)*dRowOffsetMaster, " ("+childsP2.length()+")\nunique length");

	
	
	if(bRunPhase1 && childsP1.length()>0)
	{ 
		//if (nVerbose>0)reportNotice("\n"+T("*** |Phase| ")+phase+T(" |Collecting unique width| (")+ childsP1.length() + " / " + childs.length()+ ")");

	//region Prerequisites
		TslInst tslNew;
		GenBeam gbsTsl[] = {};					
		Point3d ptsTsl[] = {ptLoc};		
		Map mapTsl;	mapTsl.setInt("mode", 1); // expecting masterpanel	
				
		int nIndexMasters[0]; // describes the index of the used master
		for (int i = 0; i < childsP1.length(); i++) nIndexMasters.append(-1);		
				
	//endregion 
		
	//region Collect parameters of each panel and assign masterindex if yield matches	
		double mins[0], maxs[0];
		GetChildDims(childsP1, mins, maxs);
		double yields[childsP1.length()];
		int nUsedMasterIndices[0];	// a unique index list of all use mastersizes
		for (int i=0;i<dLengths.length();i++) 
		{ 
			for (int j = 0; j < childsP1.length(); j++)
			{
				ChildPanel& child = childsP1[j];
				if(dLengths[i]<maxs[j])
				{
					continue;
				}
				else
				{ 

					double& myYield = yields[j];
					
				// yield only reflects length as none could be nested in width	
					double yield = (maxs[j] / dLengths[i])*100;
					
				// If panel also has no potential nesting possibilities in length accept with max yield = 100
					if (childsP2.find(child)>-1 && yield<dMinYield)
					{ 
						Sip sip = child.sipEntity();
						PlaneProfile pp = ProfNesting(sip, child.sipToMeTransformation());
						
						int nx = FindBestMasterIndex(pp, dLengths, dWidths);
						if (i==nx)
						{ 
							if (bDebug)reportNotice("\n"+sip.handle()+" Accepting max width / length " + nx + " vs " + i);
							yield = 100;
						}	
					}
			
				// store yield and save identified master shape index	
					if (yield>=dMinYield && myYield<yield)
					{ 
						myYield = yield;
						nIndexMasters[j] = i;
						if (nUsedMasterIndices.find(i)<0)
							nUsedMasterIndices.append(i);
					}					
				}
			}
		}//next i	
		
	//endregion 

	//region Collect and create by master index
		ChildPanel childsP1M[0];
		for (int j = 0; j < childsP1.length(); j++)
		{
			ChildPanel& child=childsP1[j];
			for (int i=0;i<nUsedMasterIndices.length();i++) 			
				if (nIndexMasters[j] == nUsedMasterIndices[i])
				{
					childsP1M.append(child);
					break;
				}
		}

	// Creation
		int numCreated;
		for (int j=0;j<nUsedMasterIndices.length();j++)
		{ 
		// master size	
			int indexM = nUsedMasterIndices[j];
			if (indexM<0){ continue;}
			double A = dLengths[indexM];
			double B = dWidths[indexM];

			for (int i=0;i<childsP1M.length();i++) 	
			{ 
				int index = nIndexMasters[i];
				if (index!=indexM){ continue;}
				
			// Master
				Vector3d vecm = .5 * (vecXM * A + vecYM * B);
				
				Point3d ptCenM = ptLoc+vecm;				
				LineSeg segMaster(ptLoc - vecm, ptLoc + vecm);		segMaster.vis(3);
				PlaneProfile ppm;
				ppm.createRectangle(segMaster, vecXM, vecYM);
				Vector3d vecDXM = _XW * dDProfile(ppm, _XW);
				Vector3d vecDYM = _YW * dDProfile(ppm, _YW);
				
				ppm.transformBy(.5 * (vecDXM+vecDYM));
				PlaneProfile ppMaster(CoordSys(ppm.ptMid(), vecXM, vecYM, _ZW));
				ppMaster.unionWith(ppm);
				//if (bDebug){ Display dp(211);dp.draw(ppMaster,_kDrawFilled,70);}
			
			
			// Child
				ChildPanel& child = childsP1M[i];
				Sip sip = child.sipEntity();
				
				
				PlaneProfile pp = ProfNesting(sip, child.sipToMeTransformation());
				childsNested.append(child);
				//if (bDebug){ Display dp(211);dp.draw(pp,_kDrawFilled,70);}

				CoordSys cs2Master;			
				Vector3d vecExt = RotateCoordSys(pp, cs2Master, 1);

				//if (bDebug){ Display dp(211);dp.draw(ppMaster,_kDrawFilled,70);}
				double dx = .5*(dDProfile(ppMaster, _XW) - dDProfile(pp, _XW));
				double dy = .5*(dDProfile(ppMaster, _YW) - dDProfile(pp, _YW));
				cs2Master.transformBy((ppMaster.ptMid()-pp.ptMid())+_XW*dx-_YW*dy);				
				
				if (_Sip.find(sip)<0)
				{ 
					child.transformBy(cs2Master);
					_Sip.append(sip);	
					MasterPanel master = CreateMaster(ppMaster, sMasterStyle);
					if (master.bIsValid())
					{ 
						mastersAll.append(master);
						numCreated++;
					}	
					
					if (mastersAll.length()%20==0)
						ptLoc += _XW*_XW.dotProduct(_Pt0-ptLoc)+_YW*dRowOffsetMaster;		
					else
						ptLoc += _XW * (dDProfile(ppMaster, _XW) + dColumnOffsetMaster);		
					
				}
				else
					numCreated++;
			}			
		}

		if (nVerbose>0)reportNotice(TN("*** |Phase| ") +phase +": "+ mastersAll.length()+  T(" |Master panels created with single child association| "));
	//End Collect and create //endregion 			
	}

//End PHASE 1 //endregion 

//region PHASE 2: Collect unique by length
	//#PH2
	phase++;
	bCheckMax = 1;
	childs = FilterChildsNotThis(childs, childsNested);
	childsP2 = FilterChildsNotThis(childsP2, childsNested);	

	if (bRunPhase2 && childsP2.length()>0)
	{ 
		if (nVerbose>0)reportNotice("\n"+T("*** |Phase| ")+phase+T(" |Collecting unique length| (")+ childsP2.length() + " / " + childs.length()+ ")");
		OrderChilds(childsP2, kDescending, kOTArea); // order by area
		if (bDrawPhases)DrawChildsFlattened(childsP2, sFormat, dpText, nPreview++, _Pt0-_YW*(1+nPreview)*dRowOffsetMaster, "Phase "+phase+" ("+childsP2.length()+")\nunique length");
		EntPLine epls[0];
		ChildPanel childsRun[0];
		childsRun = childsP2;

		int cnt;
		while (cnt<childsP2.length() && childsRun.length()>0)
		{ 
			cnt++;
			if (nVerbose>0)reportNotice("\n      " + cnt + T(": |nesting| ") + + childsRun.length() + T(" |panels|"));
			ptLoc.vis(4+cnt);
			
			Map mapNesting, mapMasters, mapMaster,mapChilds;
			mapNesting.setString("Style", sMasterStyle);
			
			for (int j=0;j<ppRawMasters.length();j++)
			{ 
				CoordSys csm(ppRawMasters[j].ptMid(), vecXM, vecYM, _ZW);
				PlaneProfile ppRaw(csm);
				ppRaw.unionWith(ppRawMasters[j]);
				LineSeg seg = ppRaw.extentInDir(_XW);
				CoordSys cst; cst.setToTranslation((ptLoc - ppRaw.ptMid()) - (seg.ptMid()-seg.ptEnd()));
				ppRaw.transformBy(cst);
				seg.transformBy(cst); // transform to lower left = ptLoc
				
				PLine pl; pl.createRectangle(seg, _XW, _YW);
	
//				for (int i=0;i<childsRun.length();i++) 
//				{ 
					EntPLine epl;
					epl.dbCreate(pl);	//epl.setColor(i); epl.transformBy(_YW * (i * U(20)));
					epls.append(epl);
					double area = SetMapXNestingData(epl, PlaneProfile(pl));
	
					mapMaster.setEntity("ent", epl);
					mapMaster.setPlaneProfile("prof", ppRaw);	
					mapMasters.appendMap("Master", mapMaster);
//				}//next i		
			}		
	
			for (int i=0;i<childsRun.length();i++) 
			{ 			
				Map m = SetChildNestingMap(childsRun[i]);
				mapChilds.appendMap("child", m);
			}//next i
			
			mapNesting.setMap("Master[]", mapMasters);
			mapNesting.setMap("Child[]", mapChilds);		
			mapNesting.setInt("verboseMode", 0);
			
			int bTransformToMaster = false;
			Entity entLeftOvers[0];
			Map mapResults = CallNester2(mapNesting, bTransformToMaster, entLeftOvers);	
			int nBestIndex = -1;
			double dBestYield=GetBestYield(nBestIndex, mapResults);

		// Accept larger yield if for nested childs which cannot be nested in length direction with other panels
			if (nBestIndex>-1 && dMinYield>0 && dBestYield<dMinYield)
				dBestYield += GetGrossYield(childsP2, mapResults.getMap(nBestIndex), 0, 0);

		// Yield accepted
			if (nBestIndex>-1 && dBestYield>dMinYield)
			{ 
	
				Map mapResult = mapResults.getMap(nBestIndex);
				PlaneProfile ppMaster = mapResult.getPlaneProfile("prof");
				mapNesting.setInt("verboseMode", 0);
				
				mapMasters = Map();
				mapMaster.setEntity("ent",  mapResult.getEntity("ent"));
				mapMaster.setPlaneProfile("prof", ppMaster);	
				mapMasters.appendMap("Master", mapMaster);
				mapNesting.setMap("Master[]", mapMasters);
				
				mapChilds = mapResult.getMap("Child[]");
				mapNesting.setMap("Child[]",mapChilds);
	
				//if (bDebug){ Display dp(4+cnt);dp.draw(ppMaster,_kDrawFilled,90);}
				if (nVerbose>0)reportNotice(", "+dBestYield + T(" |% yield accepted of child panels| (") + mapChilds.length()+ ")");
	
			// Call the nester and transform childs	
				if (mapChilds.length()>0)
				{ 
					int bTransform = true;
					
					// avoid transformation / creation whein in debug
					{ 
						ChildPanel cps[] = GetChildsFromMap(mapChilds);
						for (int i=0;i<cps.length();i++) 
						{ 
							Sip sip=cps[i].sipEntity();
							if (_Sip.find(sip)<0)
								_Sip.append(sip);
							else
								bTransform = false;
							 
						}//next i		
					}


					mapResults= CallNester2(mapNesting, bTransform, entLeftOvers);
					for (int i=0;i<mapChilds.length();i++) 
					{ 
						Map m = mapChilds.getMap(i);
						Entity e = m.getEntity("ent");
						if (e.bIsValid())
							childsNested.append((ChildPanel)e); 				 
					}//next i
					childsRun = FilterChildsNotThis(childsRun, childsNested);
					if (!bDebug && bTransform)
					{ 
						MasterPanel _master = CreateMaster(ppMaster, sMasterStyle);
						if (_master.bIsValid())
							mastersAll.append(_master);	
					}

					
					if (mastersAll.length()%20==0)
						ptLoc += _XW*_XW.dotProduct(_Pt0-ptLoc)+_YW*dRowOffsetMaster;		
					else
						ptLoc += _XW * (dDProfile(ppMaster, _XW) + dColumnOffsetMaster);					
				}	
			}
	
			PurgePLines(epls);//Purge temp master plines				
			if (dMinYield>0 && dBestYield<dMinYield)
			{ 
				if (nVerbose>0)reportNotice(", "+round(dBestYield) +"% best attempt below expected yield." + dMinYield + "% -> exit phase "+ phase );
				break;
			}									
		}// do while	
	}
//endregion 

//region PHASE 3  Collect unique by length, but nest with all remaining items
	// #PH3
	phase++;
	childs = FilterChildsNotThis(childs, childsNested);	
	childsP3= FilterChildsNotThis(childsP2, childsNested); 	
	if (bRunPhase3 && childsP3.length()>0)
	{ 
		if (nVerbose>0)reportNotice(TN("*** |Phase| ")+phase+ T(" |Collecting unique length combining with remaining items| ") + childsP3.length() + " + "+ childs.length());
		OrderChilds(childsP3, kDescending, kOTArea); // order by area
		if (bDrawPhases)DrawChildsFlattened(childsP3, sFormat, dpText, nPreview++, _Pt0-_YW*(1+nPreview)*dRowOffsetMaster, T("|Phase|")+phase + "("+childsP3.length()+" + "+ childs.length()+")\ntest unique length");
		
		EntPLine epls[0];
		ChildPanel childsRun[0];
		childsRun = childsP3;

		int cnt;
		while (cnt<childsP3.length() && childsRun.length()>0)
		{ 

			cnt++;
			if (nVerbose>0)reportNotice("\n      " + cnt + T(": |nesting| ") +  childsRun.length() + T(" |panels|"));
			ptLoc.vis(2+cnt);
			

		// Build protected nesting area for first item		
			PlaneProfile ppMain;
			double mins[0] , maxs[0];
			GetChildDims(childsRun, mins ,maxs);
			if (mins.length()>0)
			{ 
				
				double dx = (bAlignVertical ? mins[0] : U(10e4))+dGap;
				double dy = (bAlignVertical?U(10e4):mins[0]);
				ppMain.createRectangle(LineSeg(ptLoc-_YW*dy, ptLoc+_XW*dx+_YW*dy), vecXM, vecYM);
				//ppMain.vis(3);
			}
			else// unexpected
			{ 
				continue;
				
			}
			
		// Get first item and transform to location
			ChildPanel child = childsRun.first();
			Sip sip = child.sipEntity();
			PlaneProfile ppFirst = ProfNesting(sip, child.sipToMeTransformation());
			{ 					
				childsNested.append(child);				
				CoordSys cs2Master;			
				Vector3d vecExt = RotateCoordSys(ppFirst, cs2Master, 1);
				double dx = sip.solidLength();
				double dy = sip.solidWidth();
				cs2Master.transformBy((ptLoc-ppFirst.ptMid()));//+vecXM*.5*dx+vecYM*.5*dy);	
				//cs2Master.transformBy((ptLoc-ppFirst.ptMid())+_XW*.5*dx+_YW*.5*dy);
				
				if (_Sip.find(sip)<0)
				{ 					
					child.transformBy(cs2Master);
					PlaneProfile pp = ProfNesting(sip, child.sipToMeTransformation());
					child.transformBy(.5*(_XW*dDProfile(pp,_XW)+_YW*dDProfile(pp,_YW)));
				}
				//reportNotice("\n      "+sip.handle()+" Main Panel Size " +dx + " x " +dy);
			}				

			Map mapNesting, mapMasters, mapMaster,mapChilds;
			mapNesting.setString("Style", sMasterStyle);
			
			PlaneProfile ppFull(CoordSys());
			for (int j=0;j<ppRawMasters.length();j++)
			{ 
				CoordSys csm(ppRawMasters[j].ptMid(), vecXM, vecYM, _ZW);
				PlaneProfile ppRaw(csm);
				ppRaw.unionWith(ppRawMasters[j]);
				LineSeg seg = ppRaw.extentInDir(_XW);
				CoordSys cst; cst.setToTranslation((ptLoc - ppRaw.ptMid()) - (seg.ptMid()-seg.ptEnd()));
				ppRaw.transformBy(cst);//ppRaw.vis(2);
				
			// refuse masters which are too small
				if (mins.length()>0)
				{ 
					double dx = dDProfile(ppRaw, vecXM);
					double dy = dDProfile(ppRaw, vecYM);
					if (dx<maxs[0] || dy < mins[0])
					{
						reportNotice(".");//"refusing master " +dx + " x " +dy + " for panel "+maxs[0] + " x " +mins[0]);
						continue;
					}
				}
				ppFull = ppRaw;
				ppRaw.subtractProfile(ppMain);
				seg = ppRaw.extentInDir(_XW);//seg.vis(2);
				PLine pl; pl.createRectangle(seg, _XW, _YW);	
				
			//region Dummy PLine creation
				EntPLine epl;
				epl.dbCreate(pl);	//epl.setColor(i); 
				epls.append(epl);
				double area = SetMapXNestingData(epl, PlaneProfile(pl));
				//pl.transformBy(_YW * (j * U(20)));	//pl.vis(6);

				mapMaster.setEntity("ent", epl);
				mapMaster.setPlaneProfile("prof", ppRaw);
				mapMaster.setPlaneProfile("profFull", ppFull);
				mapMasters.appendMap("Master", mapMaster);					
			//endregion 

			}
	
		// skip first child for prenesting
			for (int i=1;i<childsRun.length();i++) 
			{ 			
				Map m = SetChildNestingMap(childsRun[i]);
				mapChilds.appendMap("child", m);
			}//next i

		// append remaining panels
			for (int i=0;i<childs.length();i++) 
			{ 		
				if (childsRun.find(childs[i])<0)
				{ 
					Map m = SetChildNestingMap(childs[i]);
					mapChilds.appendMap("child", m);						
				}
			}//next i
			
			//if (nVerbose>0)reportNotice("("  + mapChilds.length() + ")");

			mapNesting.setMap("Master[]", mapMasters);
			mapNesting.setMap("Child[]", mapChilds);		
			mapNesting.setInt("verboseMode", 0);
			
			int bTransformToMaster = false;
			Entity entLeftOvers[0];
			Map mapResults = CallNester2(mapNesting, bTransformToMaster, entLeftOvers);	
			int nBestIndex = -1;
			double dBestYield=GetBestYield(nBestIndex, mapResults);

		// Yield accepted
			if (nBestIndex>-1)// && dBestYield>dMinYield)
			{ 
				Map mapResult = mapResults.getMap(nBestIndex);
				if (mapResult.hasPlaneProfile("profFull"))
					ppFull = mapResult.getPlaneProfile("profFull");				
							
				PlaneProfile ppMaster = mapResult.getPlaneProfile("prof");
				mapNesting.setInt("verboseMode", 0);
				
				mapMasters = Map();
				mapMaster.setEntity("ent",  mapResult.getEntity("ent"));
				mapMaster.setPlaneProfile("prof", ppMaster);	
				mapMasters.appendMap("Master", mapMaster);
				mapNesting.setMap("Master[]", mapMasters);
				
			// rebuild childmap excluding first	
				mapChilds = mapResult.getMap("Child[]");
				mapNesting.setMap("Child[]",mapChilds);
	
				//if (bDebug){ Display dp(4+cnt);dp.draw(ppMaster,_kDrawFilled,90);}
				if (nVerbose>0)reportNotice(", "+dBestYield + T(" |% accepted of child panels| (") + mapChilds.length()+ ")");
			
			// Call the nester and transform childs	
				int bTransform = true;	
				if (mapChilds.length()>0)
				{ 			
					// avoid transformation / creation whein in debug
					{ 
						ChildPanel cps[] = GetChildsFromMap(mapChilds);
						for (int i=0;i<cps.length();i++) 
						{ 
							Sip sipX=cps[i].sipEntity();
							if (_Sip.find(sipX)<0)
								_Sip.append(sipX);
							else
								bTransform = false;
							 
						}//next i		
					}	
					
					mapResults= CallNester2(mapNesting, bTransform, entLeftOvers);
					nBestIndex = -1;
					dBestYield=GetBestYield(nBestIndex, mapResults);
				
					mapResult = mapResults.getMap(nBestIndex);
					mapChilds = mapResult.getMap("Child[]");
					for (int i=0;i<mapChilds.length();i++) 
					{ 
						Map m = mapChilds.getMap(i);
						Entity e = m.getEntity("ent");
						if (e.bIsValid())
							childsNested.append((ChildPanel)e); 				 
					}//next i
					

					childsRun = FilterChildsNotThis(childsRun, childsNested);
					childs = FilterChildsNotThis(childs, childsNested);
					
				
				}
				if (!bDebug && ppFull.area()>pow(dEps,2) && (bTransform || mapChilds.length()<1))
				{ 
					MasterPanel _master = CreateMaster(ppFull, sMasterStyle);
					mastersAll.append(_master);	
					ptLoc += _XW * (dDProfile(ppFull, _XW) + dColumnOffsetMaster);	
				}
			}
			else
			{ 
				int nx = FindBestMasterIndex(ppFirst, dLengths, dWidths);
				
				
				CoordSys csm(ppRawMasters[nx].ptMid(), vecXM, vecYM, _ZW);
				ppFull = PlaneProfile(csm);
				ppFull.unionWith(ppRawMasters[nx]);
				LineSeg seg = ppFull.extentInDir(_XW);
				CoordSys cst; cst.setToTranslation((ptLoc - ppFull.ptMid()) - (seg.ptMid()-seg.ptEnd()));
				ppFull.transformBy(cst);//ppRaw.vis(2);
				double areaM = ppFull.area();
				
				int bCreateMaster = !bDebug && areaM > pow(dEps, 2);
				if (_Sip.find(sip)<0)
					_Sip.append(sip);			
				else
					bCreateMaster = false;

				if(bCreateMaster)
				{ 
					MasterPanel _master = CreateMaster(ppFull, sMasterStyle);
					if (_master.bIsValid())
						mastersAll.append(_master);	
					
					if (mastersAll.length()%20==0)
						ptLoc += _XW*_XW.dotProduct(_Pt0-ptLoc)+_YW*dRowOffsetMaster;		
					else
						ptLoc += _XW * (dDProfile(ppFull, _XW) + dColumnOffsetMaster);
				}					

				
				if (nVerbose>0)reportNotice(", "+(areaM>0?ppFirst.area()/areaM*100:"?") + T(" |% accepted of child panel|"));
				childsRun = FilterChildsNotThis(childsRun, childsNested);
				childs = FilterChildsNotThis(childs, childsNested);
				//reportNotice("\n"+sip.formatObject("@(Handle) @(SolidLength:RL0) x @(SolidWidth:RL0)")+" cnt"+cnt + " best:" +nBestIndex+" yield"+ dBestYield + T(" % (") + mapChilds.length()+ ") dx" + ppFull.dX() + " dy:"+ppFull.dY());	
			}

			PurgePLines(epls);//Purge temp master plines

		}// do while
	}	
	
//PHASE 3 //endregion 

//region PHASE 4: Collect panels which can only be nested in main direction
	//#PH4
	phase++;
	childs = FilterChildsNotThis(childs, childsNested);
	childsP4 = FilterChildsNotThis(childs, childsNested);
	if (bRunPhase4 && childsP4.length()>0)
	{ 
		double mins[0] , maxs[0];
		GetChildDims(childsP4, mins ,maxs);	
		
		for (int i=childsP4.length()-1; i>=0 ; i--) 
		{ 
			ChildPanel child =childsP4[i]; 
			
			int bCanRotate;
			for (int j=0;j<dWidths.length();j++) 
			{ 
				if (maxs[i]<=dWidths[j])
				{
					bCanRotate = true;
					break;
				}
			}//next j
			if (bCanRotate)
			{
				childsP4.removeAt(i);
				mins.removeAt(i);
				maxs.removeAt(i);
			}
		}//next i
		if (bDrawPhases)DrawChildsFlattened(childsP4, sFormat, dpText, nPreview++, _Pt0-_YW*(1+nPreview)*dRowOffsetMaster, T("|Phase| ") +phase +" ("+childsP4.length()+")\nno rotation");

		bCheckMax=0; // 0 = check smaller dim, 1 = check larger dim
		ChildPanel childsX[] = FilterChildsSingularAll(childs, dLengths, dWidths, dGap, bCheckMax);
		ChildPanel cpSingles[] = FilterChilds1And2(childsX, childsP4);
		OrderChilds(cpSingles, kDescending, kOTLength); // order by area
		if (bDrawPhases)DrawChildsFlattened(cpSingles, sFormat, dpText, nPreview++, _Pt0-_YW*(1+nPreview)*dRowOffsetMaster, T("|Phase| ") +phase +" ("+cpSingles.length()+")\nno rotation + single width");

		EntPLine epls[0];
		ChildPanel childsRun[0];
		childsRun = cpSingles;

	//region try nesting
		int cnt;
		while (cnt < childsP4.length() && childsRun.length() > 0)
		{
			cnt++;
			if (nVerbose > 0)reportNotice("\n      " + cnt + T(" : |nesting| ") + + childsRun.length() + T(" |panels|"));
			ptLoc.vis(phase + cnt);
			
			Map mapNesting, mapMasters, mapMaster, mapChilds;
			mapNesting.setString("Style", sMasterStyle);

			for (int j=0;j<ppRawMasters.length();j++)
			{ 
				CoordSys csm(ppRawMasters[j].ptMid(), vecXM, vecYM, _ZW);
				PlaneProfile ppRaw(csm);
				ppRaw.unionWith(ppRawMasters[j]);
				LineSeg seg = ppRaw.extentInDir(_XW);
				CoordSys cst; cst.setToTranslation((ptLoc - ppRaw.ptMid()) - (seg.ptMid()-seg.ptEnd()));
				ppRaw.transformBy(cst);
				seg.transformBy(cst); // transform to lower left = ptLoc
				PLine pl; pl.createRectangle(seg, _XW, _YW);

				EntPLine epl;
				epl.dbCreate(pl);	//epl.setColor(i); epl.transformBy(_YW * (i * U(20)));
				epls.append(epl);
				double area = SetMapXNestingData(epl, PlaneProfile(pl));
				pl.vis(j);

				mapMaster.setEntity("ent", epl);
				mapMaster.setPlaneProfile("profFull", ppRaw);
				mapMaster.setPlaneProfile("prof", ppRaw);//ppSub);	
				mapMasters.appendMap("Master", mapMaster);
	
			}	
			
		// Collect childs for 
			for (int i=0;i<childsRun.length();i++) 
			{ 			
				Map m = SetChildNestingMap(childsRun[i]);//SetChildNestingMapWidth(childsRun[i], width);//
				mapChilds.appendMap("child", m);
			}//next i

			mapNesting.setMap("Master[]", mapMasters);
			mapNesting.setMap("Child[]", mapChilds);		
			mapNesting.setInt("verboseMode", 0);

			int bTransformToMaster = false;
			Entity entLeftOvers[0];
			Map mapResults = CallNester2(mapNesting, bTransformToMaster, entLeftOvers);	
			int nBestIndex = -1;
			double dBestYield=GetBestYield(nBestIndex, mapResults);

		// Override yield by full width
			if (nBestIndex>-1)
			{ 
				Map mapResult = mapResults.getMap(nBestIndex);
				PlaneProfile ppMaster = mapResult.getPlaneProfile("prof");
				
				ChildPanel childsX[] = GetChildsFromMap(mapResult.getMap("Child[]"));
				double mins[0] , maxs[0];
				GetChildDims(childsX, mins ,maxs);
	
				double areaM = ppMaster.area();
				double areaC;
				for (int i=0;i<childsX.length();i++) 
				{ 
					areaC += ppMaster.dY() * maxs[i];
					 
				}//next i
				double yieldFullWidth = areaM > pow(dEps, 2) ? areaC / areaM*100 : 0;
				if (yieldFullWidth>dBestYield)
					dBestYield = yieldFullWidth;
			}

		// Yield accepted
			if (nBestIndex>-1 && dBestYield>dMinYield)
			{ 
	
				Map mapResult = mapResults.getMap(nBestIndex);
				PlaneProfile ppMaster = mapResult.getPlaneProfile("prof");
				mapNesting.setInt("verboseMode", 0);
				
				mapMasters = Map();
				mapMaster.setEntity("ent",  mapResult.getEntity("ent"));
				mapMaster.setPlaneProfile("prof", ppMaster);	
				mapMasters.appendMap("Master", mapMaster);
				mapNesting.setMap("Master[]", mapMasters);
				
				mapChilds = mapResult.getMap("Child[]");
				mapNesting.setMap("Child[]",mapChilds);
	
				//if (bDebug){ Display dp(4+cnt);dp.draw(ppMaster,_kDrawFilled,90);}
				if (nVerbose>0)reportNotice(", "+dBestYield + T(" |% yield accepted of child panels| (") + mapChilds.length()+ ")");
	
			// Call the nester and transform childs	
				if (mapChilds.length()>0)
				{ 
					int bTransform = true;
					
					// avoid transformation / creation whein in debug
					{ 
						ChildPanel cps[] = GetChildsFromMap(mapChilds);
						for (int i=0;i<cps.length();i++) 
						{ 
							Sip sip=cps[i].sipEntity();
							if (_Sip.find(sip)<0)
								_Sip.append(sip);
							else
								bTransform = false;
							 
						}//next i		
					}


					mapResults= CallNester2(mapNesting, bTransform, entLeftOvers);
					for (int i=0;i<mapChilds.length();i++) 
					{ 
						Map m = mapChilds.getMap(i);
						Entity e = m.getEntity("ent");
						if (e.bIsValid())
							childsNested.append((ChildPanel)e); 				 
					}//next i
					childsRun = FilterChildsNotThis(childsRun, childsNested);
					if (!bDebug && bTransform)
					{ 
						MasterPanel _master = CreateMaster(ppMaster, sMasterStyle);
						if (_master.bIsValid())
							mastersAll.append(_master);	
							
							
						if (mastersAll.length()%20==0)
							ptLoc += _XW*_XW.dotProduct(_Pt0-ptLoc)+_YW*dRowOffsetMaster;		
						else
							ptLoc += _XW * (dDProfile(ppMaster, _XW) + dColumnOffsetMaster);			
								
					}

					//ptLoc += _XW * (dDProfile(ppMaster, _XW) + dColumnOffsetMaster);					
				}	
			}

			PurgePLines(epls);//Purge temp master plines
			
			if (dMinYield>0 && dBestYield<dMinYield)
			{ 
				if (nVerbose>0)reportNotice(", "+round(dBestYield) +"% best attempt below expected yield." + dMinYield + "% -> exit phase "+ phase );
				break;
			}				
			
			
		}// do while
	//endregion 
	

	}
	

//endregion 

//region PHASE 5: Collect groups of childs similar length
	// #PH5
	phase++;
	childs = FilterChildsNotThis(childs, childsNested);
	childsP5 = FilterChildsNotThis(childs, childsNested);
	if (bRunPhase5 && childsP5.length()>0)
	{
		
		double _minYield = 75;
		OrderChilds(childsP5, kDescending, kOTLength); // order by length
		if (bDrawPhases)DrawChildsFlattened(childsP5, sFormat, dpText, nPreview++, _Pt0-_YW*(nPreview+1)*dRowOffsetMaster, "Group nesting -> nest ("+childsP5.length()+")");
		
	//region Collect grouops
		double dMaxDimGroups[0]; int nMaxNumGroups[0];
		Map mapGroups[] = CollectMinMaxChildGroups(childsP5, 1);		
		if (mapGroups.length()>0 && nVerbose>0)
			reportNotice(TN("*** |Phase| ")+phase+  T(": |groups of similar length| (") + mapGroups.length() + ")");	
		else if (nVerbose>0)
			reportNotice(TN("*** |Phase| ")+phase+  T(": |no groups of similar length found| "));				
	//endregion 	
	
		
		for (int g = 0; g < mapGroups.length(); g++)
		{
			
		//region Get Group Data
			Map mapGroup = mapGroups[g];
			Map mapChilds = mapGroup.getMap("Child[]");
			
			ChildPanel childsRun[0];
			for (int j = 0; j < mapChilds.length(); j++)
			{
				Entity e = mapChilds.getEntity(j);
				if (e.bIsValid())
					childsRun.append((ChildPanel)e);
				
			}//next j
			int maxRun = childsRun.length();
			double dD = mapGroup.getDouble("dD"); //the group size, used to create submaster size	
			EntPLine epls[0];

			if (childsRun.length()<2)			
			{
				if (nVerbose>0)reportNotice("\n      "+(g+1)+ T(" |not enough panels of length| ") + dD + " ("+ childsRun.length() + ")");
				continue;
			}
			else if (nVerbose>0)
				reportNotice("\n      " + (g+1)+ T(": |Length of Group| ") + dD + " ("+ childsRun.length() + ")");

		//endregion 	

		//region run nesting for subset

			int cnt;
			while (cnt<maxRun && childsRun.length()>0)
			{ 
				cnt++;
				//if (nVerbose>0)reportNotice("\n      " + cnt + T(": |nesting| ") +  childsRun.length() + T(" |panels|"));
				ptLoc.vis(4+cnt);
				
				Map mapNesting, mapMasters, mapMaster,mapChilds;
				mapNesting.setString("Style", sMasterStyle);
				
				for (int j=0;j<ppRawMasters.length();j++)
				{ 
					CoordSys csm(ppRawMasters[j].ptMid(), vecXM, vecYM, _ZW);
					PlaneProfile ppRaw(csm);
					ppRaw.unionWith(ppRawMasters[j]);
					LineSeg seg = ppRaw.extentInDir(_XW);
					CoordSys cst; cst.setToTranslation((ptLoc - ppRaw.ptMid()) - (seg.ptMid()-seg.ptEnd()));
					ppRaw.transformBy(cst);
					seg.transformBy(cst); // transform to lower left = ptLoc
					
					PlaneProfile ppSub;
					ppSub.createRectangle(LineSeg(ptLoc, ptLoc + _YW * dD + _XW * dDProfile(ppRaw, _XW)), vecXM, vecYM);
					//ppSub.vis(6);
					//seg = ppSub.extentInDir(_XW);					//seg.vis(2);
					PLine pl; pl.createRectangle(seg, _XW, _YW);

					EntPLine epl;
					epl.dbCreate(pl);	//epl.setColor(i); epl.transformBy(_YW * (i * U(20)));
					epls.append(epl);
					double area = SetMapXNestingData(epl, PlaneProfile(pl));
	
					pl.vis(j);
	
					mapMaster.setEntity("ent", epl);
					mapMaster.setPlaneProfile("profFull", ppRaw);
					mapMaster.setPlaneProfile("prof", ppRaw);//ppSub);	
					mapMasters.appendMap("Master", mapMaster);
		
				}		
		
				for (int i=0;i<childsRun.length();i++) 
				{ 			
					Map m = SetChildNestingMap(childsRun[i]);
					mapChilds.appendMap("child", m);
				}//next i

//				//if (nVerbose>0)reportNotice(T(", |child panels send to nester| (")  + mapChilds.length() + ")");

				mapNesting.setMap("Master[]", mapMasters);
				mapNesting.setMap("Child[]", mapChilds);		
				mapNesting.setInt("verboseMode", 0);
				
				int bTransformToMaster = false;
				Entity entLeftOvers[0];
				Map mapResults = CallNester2(mapNesting, bTransformToMaster, entLeftOvers);	
				int nBestIndex = -1;
				double dBestYield=GetBestYield(nBestIndex, mapResults);
	
			// Yield accepted
				if (nBestIndex>-1 && dBestYield>dMinYield)
				{ 	
					Map mapResult = mapResults.getMap(nBestIndex);
					PlaneProfile ppMaster = mapResult.getPlaneProfile("prof");
					mapNesting.setInt("verboseMode", 0);
					
					mapMasters = Map();
					mapMaster.setEntity("ent",  mapResult.getEntity("ent"));
					mapMaster.setPlaneProfile("prof", ppMaster);	
					mapMasters.appendMap("Master", mapMaster);
					mapNesting.setMap("Master[]", mapMasters);
					
					mapChilds = mapResult.getMap("Child[]");

					mapNesting.setMap("Child[]",mapChilds);
		
					if (bDebug){ Display dp(4+cnt);dp.draw(ppMaster,_kDrawFilled,90);}
					if (nVerbose>0)reportNotice(TN("      |accepting with yield| ")  + dBestYield + T(" |of child panels| (") + mapChilds.length()+ ")");
		
				// Call the nester and transform childs	
					if (mapChilds.length()>0)
					{ 
						mapResults= CallNester2(mapNesting, true, entLeftOvers);
						nBestIndex = -1;
						dBestYield=GetBestYield(nBestIndex, mapResults);
					
						mapResult = mapResults.getMap(nBestIndex);
						mapChilds = mapResult.getMap("Child[]");
						
						childsNested.append(GetChildsFromMap(mapChilds));

						childsRun = FilterChildsNotThis(childsRun, childsNested);
						childs = FilterChildsNotThis(childs, childsNested);
						
						if (!bDebug)
						{ 
							MasterPanel _master = CreateMaster(ppMaster, sMasterStyle);
							if (_master.bIsValid())
								mastersAll.append(_master);						
						}
	
						if (mastersAll.length()%20==0)
							ptLoc += _XW*_XW.dotProduct(_Pt0-ptLoc)+_YW*dRowOffsetMaster;		
						else
							ptLoc += _XW * (dDProfile(ppMaster, _XW) + dColumnOffsetMaster);

						//ptLoc += _XW * (dDProfile(ppMaster, _XW) + dColumnOffsetMaster);					
					}	
				}
				else
				{ 
					PurgePLines(epls);//Purge temp master plines
					if (nVerbose>0)reportNotice("\n      "+round(dBestYield) +T("% |best attempt is below expected yield| ") + dMinYield + "% -> exit group "+ (g+1) );
					break;
				}					

				if (bDebug)ptLoc += _XW * (U(1223) + dColumnOffsetMaster);	
			}// do while	
			PurgePLines(epls);//Purge temp master plines
		//endregion 

			if (bDebug)ptLoc += _XW * (U(1223) + dColumnOffsetMaster);	
		}//next i	
	
		
	}
	

//endregion 

//region PHASE 6
	//#PH6
	double dLeftOverYield = dMinYield;
	phase++;
	childs = FilterChildsNotThis(childs, childsNested);
	OrderChilds(childs, kDescending, kOTArea); // order by area	
	if (bRunPhase6 && childs.length()>0)
	{ 
		if (nVerbose>0)reportNotice(TN("*** |Phase| ")+phase+  T(": |nesting of left overs| (") + childs.length() + ")");
			
		EntPLine epls[0];
		ChildPanel childsRun[0];
		childsRun = childs;
		
	//region try nesting
		int cnt;
		while (cnt < childs.length() && childsRun.length() > 0)
		{
			cnt++;
			if (nVerbose > 0)reportNotice("\n      " + cnt + T(" : |nesting| ") + + childsRun.length() + T(" |panels|"));
			ptLoc.vis(phase + cnt);
			
			Map mapNesting, mapMasters, mapMaster, mapChilds;
			mapNesting.setString("Style", sMasterStyle);

			for (int j=0;j<ppRawMasters.length();j++)
			{ 
				CoordSys csm(ppRawMasters[j].ptMid(), vecXM, vecYM, _ZW);
				PlaneProfile ppRaw(csm);
				ppRaw.unionWith(ppRawMasters[j]);
				LineSeg seg = ppRaw.extentInDir(_XW);
				CoordSys cst; cst.setToTranslation((ptLoc - ppRaw.ptMid()) - (seg.ptMid()-seg.ptEnd()));
				ppRaw.transformBy(cst);
				seg.transformBy(cst); // transform to lower left = ptLoc
				PLine pl; pl.createRectangle(seg, _XW, _YW);

				EntPLine epl;
				epl.dbCreate(pl);	//epl.setColor(i); epl.transformBy(_YW * (i * U(20)));
				epls.append(epl);
				double area = SetMapXNestingData(epl, PlaneProfile(pl));
				pl.vis(j);

				mapMaster.setEntity("ent", epl);
				mapMaster.setPlaneProfile("profFull", ppRaw);
				mapMaster.setPlaneProfile("prof", ppRaw);//ppSub);	
				mapMasters.appendMap("Master", mapMaster);
	
			}	
			
		// Collect childs for 
			for (int i=0;i<childsRun.length();i++) 
			{ 			
				Map m = SetChildNestingMap(childsRun[i]);//SetChildNestingMapWidth(childsRun[i], width);//
				mapChilds.appendMap("child", m);
			}//next i

			mapNesting.setMap("Master[]", mapMasters);
			mapNesting.setMap("Child[]", mapChilds);		
			mapNesting.setInt("verboseMode", 0);

			int bTransformToMaster = false;
			Entity entLeftOvers[0];
			Map mapResults = CallNester2(mapNesting, bTransformToMaster, entLeftOvers);	
			int nBestIndex = -1;
			double dBestYield=GetBestYield(nBestIndex, mapResults);

			if (dBestYield<dLeftOverYield)
			{
				dLeftOverYield = dBestYield;
			}

//		// Override yield by full width
//			if (nBestIndex>-1)
//			{ 
//				Map mapResult = mapResults.getMap(nBestIndex);
//				PlaneProfile ppMaster = mapResult.getPlaneProfile("prof");
//				
//				ChildPanel childsX[] = GetChildsFromMap(mapResult.getMap("Child[]"));
//				double mins[0] , maxs[0];
//				GetChildDims(childsX, mins ,maxs);
//	
//				double areaM = ppMaster.area();
//				double areaC;
//				for (int i=0;i<childsX.length();i++) 
//				{ 
//					areaC += ppMaster.dY() * maxs[i];
//					 
//				}//next i
//				double yieldFullWidth = areaM > pow(dEps, 2) ? areaC / areaM*100 : 0;
//				if (yieldFullWidth>dBestYield)
//					dBestYield = yieldFullWidth;
//			}

		// Yield accepted
			if (nBestIndex>-1 && dBestYield>=dLeftOverYield)
			{ 
	
				Map mapResult = mapResults.getMap(nBestIndex);
				PlaneProfile ppMaster = mapResult.getPlaneProfile("prof");
				mapNesting.setInt("verboseMode", 0);
				
				mapMasters = Map();
				mapMaster.setEntity("ent",  mapResult.getEntity("ent"));
				mapMaster.setPlaneProfile("prof", ppMaster);	
				mapMasters.appendMap("Master", mapMaster);
				mapNesting.setMap("Master[]", mapMasters);
				
				mapChilds = mapResult.getMap("Child[]");
				mapNesting.setMap("Child[]",mapChilds);
	
				//if (bDebug){ Display dp(4+cnt);dp.draw(ppMaster,_kDrawFilled,90);}
				if (nVerbose>0)reportNotice(", "+dBestYield + T(" |% yield accepted of child panels| (") + mapChilds.length()+ ")");
	
			// Call the nester and transform childs	
				if (mapChilds.length()>0)
				{ 
					int bTransform = true;
					
					// avoid transformation / creation whein in debug
					{ 
						ChildPanel cps[] = GetChildsFromMap(mapChilds);
						for (int i=0;i<cps.length();i++) 
						{ 
							Sip sip=cps[i].sipEntity();
							if (_Sip.find(sip)<0)
								_Sip.append(sip);
							else
								bTransform = false;
							 
						}//next i		
					}


					mapResults= CallNester2(mapNesting, bTransform, entLeftOvers);
					for (int i=0;i<mapChilds.length();i++) 
					{ 
						Map m = mapChilds.getMap(i);
						Entity e = m.getEntity("ent");
						if (e.bIsValid())
							childsNested.append((ChildPanel)e); 				 
					}//next i
					childsRun = FilterChildsNotThis(childsRun, childsNested);
					if (!bDebug && bTransform)
					{ 
						MasterPanel _master = CreateMaster(ppMaster, sMasterStyle);
						if (_master.bIsValid())
							mastersAll.append(_master);	
					}

					if (mastersAll.length()%20==0)
						ptLoc += _XW*_XW.dotProduct(_Pt0-ptLoc)+_YW*dRowOffsetMaster;		
					else
						ptLoc += _XW * (dDProfile(ppMaster, _XW) + dColumnOffsetMaster);				
				}	
			}

			PurgePLines(epls);//Purge temp master plines
			
			if (dMinYield>0 && dBestYield<dLeftOverYield)
			{ 
				if (nVerbose>0)reportNotice(", "+round(dBestYield) +"% best attempt below expected yield." + dLeftOverYield + "% -> exit phase "+ phase );
				break;
			}				
			
			
		}// do while
	//endregion 
				
		
	}
	
	
	
//endregion 


//region Create Over All Instance
	if (mastersAll.length()>0)
	{ 
		//bDebug = true;
		if (nVerbose)	reportNotice("\nCreating summary ("+styles.length()+")");

	// create TSL
		TslInst tslNew;
		GenBeam gbsTsl[] = {};					
		Point3d ptsTsl[] = {_Pt0-_YW*U(1000)};
		Entity entsTsl[0];
		for (int i=0;i<mastersAll.length();i++) 
			entsTsl.append(mastersAll[i]); 
		dProps[2] = U(500);
		
		Map mapTsl;	
		mapTsl.setInt("mode", 2);
		if (!bDebug)
			tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
		else
			ptsTsl[0].vis(1);

	}		
//endregion 
	




	childs = FilterChildsNotThis(childs, childsNested);
	if (bDrawPhases)DrawChildsFlattened(childs, sFormat, dpText, nPreview++, _Pt0-_YW*(1+nPreview)*dRowOffsetMaster, T("|Last Phase| ") +phase +" ("+childs.length()+")\nleft over");	
	
	if (!bDrawPhases)
		eraseInstance();

return;


//region PHASE 7: Collect unique by length
	//#PH7
	phase++;
	bCheckMax = 1;
	childsP5 = FilterChildsNotThis(childs, childsNested);
	
	OrderChilds(childsP5, kDescending, kOTArea); // order by area
	if (bDrawPhases)DrawChildsFlattened(childsP5, sFormat, dpText, nPreview++, _Pt0-_YW*(1+nPreview)*dRowOffsetMaster, "remaining childs before Phase 5 ("+childs.length()+")");
	if (childsP5.length()>0)
	{ 
		if (nVerbose>0)
			reportNotice(TN("*** |Phase|")+phase+  T(": |any left over| "));
			
		if (bDrawPhases)DrawChildsFlattened(childsP5, sFormat, dpText, nPreview++, _Pt0-_YW*(1+nPreview)*dRowOffsetMaster, "Phase "+phase+" ("+childsP5.length()+")\nany left over");
		EntPLine epls[0];
		ChildPanel childsRun[0];
		childsRun = childsP5;

		int cnt;
		while (cnt<childsP5.length() && childsRun.length()>0)
		{ 
			cnt++;
			if (nVerbose>0)reportNotice("\n" + T("   |nesting attempt| ") + cnt + T(" |of child panels| (") + childsRun.length() + ")");
			ptLoc.vis(4+cnt);
			
			Map mapNesting, mapMasters, mapMaster,mapChilds;
			mapNesting.setString("Style", sMasterStyle);
			
			for (int j=0;j<ppRawMasters.length();j++)
			{ 
				CoordSys csm(ppRawMasters[j].ptMid(), vecXM, vecYM, _ZW);
				PlaneProfile ppRaw(csm);
				ppRaw.unionWith(ppRawMasters[j]);
				LineSeg seg = ppRaw.extentInDir(_XW);
				CoordSys cst; cst.setToTranslation((ptLoc - ppRaw.ptMid()) - (seg.ptMid()-seg.ptEnd()));
				ppRaw.transformBy(cst);
				seg.transformBy(cst); // transform to lower left = ptLoc
				
				PLine pl; pl.createRectangle(seg, _XW, _YW);
	
				for (int i=0;i<childsRun.length();i++) 
				{ 
					EntPLine epl;
					epl.dbCreate(pl);	//epl.setColor(i); epl.transformBy(_YW * (i * U(20)));
					epls.append(epl);
					double area = SetMapXNestingData(epl, PlaneProfile(pl));
	
					mapMaster.setEntity("ent", epl);
					mapMaster.setPlaneProfile("prof", ppRaw);	
					mapMasters.appendMap("Master", mapMaster);
				}//next i		
			}		
	
			for (int i=0;i<childsRun.length();i++) 
			{ 			
				Map m = SetChildNestingMap(childsRun[i]);
				mapChilds.appendMap("child", m);
			}//next i
			
			mapNesting.setMap("Master[]", mapMasters);
			mapNesting.setMap("Child[]", mapChilds);		
			mapNesting.setInt("verboseMode", 1);
			
			int bTransformToMaster = false;
			Entity entLeftOvers[0];
			Map mapResults = CallNester2(mapNesting, bTransformToMaster, entLeftOvers);	
			int nBestIndex = -1;
			double dBestYield=GetBestYield(nBestIndex, mapResults);


	
		// Yield accepted
			if (nBestIndex>-1 && dBestYield>dMinYield)
			{ 
	
				Map mapResult = mapResults.getMap(nBestIndex);
				PlaneProfile ppMaster = mapResult.getPlaneProfile("prof");
				mapNesting.setInt("verboseMode", 1);
				
				mapMasters = Map();
				mapMaster.setEntity("ent",  mapResult.getEntity("ent"));
				mapMaster.setPlaneProfile("prof", ppMaster);	
				mapMasters.appendMap("Master", mapMaster);
				mapNesting.setMap("Master[]", mapMasters);
				
				mapChilds = mapResult.getMap("Child[]");
				mapNesting.setMap("Child[]",mapChilds);
	
				if (bDebug){ Display dp(4+cnt);dp.draw(ppMaster,_kDrawFilled,90);}
				if (nVerbose>0)reportNotice("\n   chosen best = " + nBestIndex + " childs:" + mapChilds.length());
	
			// Call the nester and transform childs	
				if (mapChilds.length()>0)
				{ 
					mapResults= CallNester2(mapNesting, true, entLeftOvers);
					for (int i=0;i<mapChilds.length();i++) 
					{ 
						Map m = mapChilds.getMap(i);
						Entity e = m.getEntity("ent");
						if (e.bIsValid())
							childsNested.append((ChildPanel)e); 				 
					}//next i
					childsRun = FilterChildsNotThis(childsRun, childsNested);
					if (!bDebug)
					{ 
						MasterPanel _master = CreateMaster(ppMaster, sMasterStyle);
						if (_master.bIsValid())
							mastersAll.append(_master);						
					}

					
					if (mastersAll.length()%20==0)
						ptLoc += _XW*_XW.dotProduct(_Pt0-ptLoc)+_YW*dRowOffsetMaster;		
					else
						ptLoc += _XW * (dDProfile(ppMaster, _XW) + dColumnOffsetMaster);				
				}	
			}
			
			if (dMinYield>0 && dBestYield<dMinYield)
			{ 
				if (nVerbose>0)reportNotice("\n   "+round(dBestYield) +T("% |best attempt below expected yield|") + dMinYield + "%");
				break;
			}			
			PurgePLines(epls);//Purge temp master plines			
		}// do while
		
	}
	
	childs = FilterChildsNotThis(childs, childsNested);	
	
//endregion 

		
	ptLoc += _YW * dRowOffsetMaster;
	if (bDrawPhases)DrawChildsFlattened(childs, sFormat, dpText, nPreview++, _Pt0-_YW*(nPreview+1)*dRowOffsetMaster, "left over");	
	
	
	if (!bDrawPhases)
		eraseInstance();
	
	return;	
	
	
	
	
//
//	ptLoc += _YW * dRowOffsetMaster;
//	if (bDrawPhases)DrawChildsFlattened(childs, sFormat, dpText, nPreview++, _Pt0-_YW*(nPreview+1)*dRowOffsetMaster, "left over all");
	
	//region Phase x1: Collect childs wich require full width to be nested
		if (0 && nPhase<2)
		{ 
			ChildPanel childsP1[0];

//
//			childsP1 =childs;// CollectChildsFullDim(childs, true, dLengths,dWidths, dGap);
//			OrderChilds(childsP1, false, 0);
//			
//			Point3d ptLoc = _Pt0 + _YW * dRowOffsetMaster;
//			DrawChildsFlattened(childsP1, sFormat, dpText, 1, ptLoc, "msg");
			
			Map mapNesting;
			mapNesting.setString("Style", sMasterStyle);
			MasterPanel masters[]= RunPreNesting(childsP1, ppRawMasters, mapNesting,1, ptLoc);
//			
			reportNotice("\n" + masters.length() + " masters created");
			
			_Map.setInt("Phase", 3);
			
//			//double dTests[] = { U(4000)};

			childsP2 = CollectChildsFullDim(childs, false, dLengths,dWidths, dGap);
			ptLoc += _YW * dRowOffsetMaster;
			DrawChildsFlattened(childsP2, sFormat, dpText, 2, ptLoc, "msg");
		}
		
		
		
		
	//endregion 
		
//if (!bDebug)eraseInstance();		



	}
	
//endregion 

//region MasterPanelMode #M1
	else if (mode==1)
	{ 
				
	//region Trigger CallNester
		int bNest = _Map.getInt(kCallNester);
		String sTriggerCallNester = T("|Nesting|");
		//if (sNester != tDisabledEntry)
			addRecalcTrigger(_kContextRoot, sTriggerCallNester );
		if (_bOnRecalc && (_kExecuteKey==sTriggerCallNester || _kExecuteKey==sDoubleClick))
		{
			_Map.setInt(kCallNester, true);		
			setExecutionLoops(2);
			return;
		}//endregion

	//region Master
		MasterPanel master;
		ChildPanel childs[0];
		for (int i=0;i<_Entity.length();i++) 
		{ 
			MasterPanel _master =(MasterPanel) _Entity[i]; 
			if (!master.bIsValid() && _master.bIsValid())
			{
				master = _master;
				setDependencyOnEntity(master);
				childs = master.nestedChildPanels();
				continue;
			}

		}//next i
		if (!master.bIsValid())
		{ 
			eraseInstance();
			return;
		}
		Point3d ptRef = master.ptRef();
		
		String sMasterStyle = master.style();
		double dLengths[0], dWidths[0];
		GetMasterStockSizes(mapStyles, sMasterStyle, dLengths, dWidths);

	//endregion 

	//region Nesting Data
		PlaneProfile ppMasterNet(CoordSys(ptRef, _YW, -_XW, _ZW));
		ppMasterNet.joinRing(master.plShape(), _kAdd);
		ppMasterNet.vis(3);
		double dMasterArea = SetMapXNestingData(master, ppMasterNet);
		if (dMasterArea<pow(dEps,2))
		{ 
			reportNotice("\n" + T("|Unexpected error in masterpanel mode|"));
			dpText.draw(scriptName(), _Pt0, _XW, _YW, 1, 0);
			return;
		}
		//{ Display dp(3); dp.draw(ppMasterNet, _kDrawFilled, 70);}

		Map mapNesting, mapNestData, mapMaster,mapMasters;		
		mapMaster.setEntity("ent", master);
		mapMaster.setPlaneProfile("prof", ppMasterNet);	
		mapMasters.appendMap("Master", mapMaster);
		mapNesting.setMap("Master[]", mapMasters);

		mapNestData.setDouble("AllowedRunTimeSeconds", 1);
		mapNestData.setDouble("MinimumSpacing", dGap);
		mapNestData.setDouble("NesterToUse", _kNTRectangularNester);
		mapNesting.setMap("NestData", mapNestData);			
	//endregion 

	//region Order Childs
	// Sort by Painter
		if (nPainter>-1)
		{ 
			Sip sipsSorted[0];
			for (int i=0;i<childs.length();i++) 
				sipsSorted.append(childs[i].sipEntity()); 
			SortByPainter(sipsSorted, sPainterDef, sSortDirection == tAscending);	
			childs = CollectChildsFromSips(sipsSorted);
		}
		else
			OrderChilds(childs, kDescending, kOTArea);	
	//endregion 

	//region Validate dependencies
		for (int i=0;i<_Entity.length();i++) 
		{ 
			ChildPanel child =(ChildPanel)_Entity[i];
			if (!child.bIsValid()){ continue;}
			int n = childs.find(child);
			if (n<0)
			{ 
				Sip sip = child.sipEntity();
				PlaneProfile pp = ProfNesting(sip, child.sipToMeTransformation() );
			
				_Entity.removeAt(n);
				
			// find potential other master	
				Entity ents[] = Group().collectEntities(true, MasterPanel(), _kModelSpace);
				for (int j=0;j<ents.length();j++) 
				{ 
					MasterPanel _master = (MasterPanel)ents[j];
					if (_master.bIsValid())
					{ 
						PlaneProfile ppm(_master.plShape());
						if (ppm.intersectWith(pp))
						{ 
							TslInst tsls[] = _master.tslInstAttached();
							for (int ii=0;ii<tsls.length();ii++) 
							{ 
								TslInst& t = tsls[ii];
								if (t.scriptName()==scriptName())
								{ 
									Map m = t.map();
									m.setInt(kCallNester, true);
									t.setMap(m);
									t.transformBy(Vector3d(0, 0, 0));
									break;
								} 
							}//next t
							break;
						}
					} 
				}//next i				
			}
		}		
	//endregion 

	//region Child Display
		PlaneProfile ppChildsAll(CoordSys()), pps[0];
		double dChildArea;
		Map mapChilds;
		for (int i=0;i<childs.length();i++) 
		{ 
			ChildPanel child = childs[i];
			Sip sip = child.sipEntity();
			PlaneProfile pp = ProfNesting(sip, child.sipToMeTransformation() );
			pps.append(pp);
			
		// Check if in master
			PlaneProfile ppTest = pp;
			if (ppTest.intersectWith(ppMasterNet))
			{ 
				_Entity.append(child);
				setDependencyOnEntity(child);
			}
			ppChildsAll.unionWith(pp);
			
			//{ Display dp(i+1); dp.draw(pp, _kDrawFilled, 70);}
			double area = SetMapXNestingData(child, pp);
			dChildArea += area;

			Map m;
			m.setEntity("ent", child);
			m.setPlaneProfile("prof", pp);
			mapChilds.appendMap("child", m);
			
			String text = sip.formatObject(sFormat);
			if (text.length()>0)
			{ 
				PLine plTag = GetTagPLine(text, dpText, CoordSys(pp.ptMid(), _XW,_YW,_ZW), textHeight, dimStyle);
				dpText.draw(plTag);
				dpWhite.draw(PlaneProfile(plTag), _kDrawFilled, 20);
				dpText.draw(text, pp.ptMid() , _XW, _YW, 0, 0);
			}	
		}//next i			
	//endregion 
		
	//region Nesting
		mapNesting.setMap("Child[]", mapChilds);
		mapNesting.setInt("verboseMode", false);// 0 = no reporting, 1 = show log messages
		if (bNest)
		{
			int bTransformToMaster = ! bDebug;
			Entity entLeftOvers[0];
			int bOk= CallNester(mapNesting, bTransformToMaster, entLeftOvers);
			
			if (bDebug)
			{ 
				Map maps = mapNesting.getMap("Master[]");
				for (int j=0;j<maps.length();j++) 
					reportNotice("\n" + j +" submap = "+maps.getMap(j).getDouble("myYield"));				
			}

			_Map.removeAt(kCallNester, true);	
		}			
	//endregion 	

	//region Check and draw intersections
		PLine rings[] = ppChildsAll.allRings(true, false);	
		if (rings.length()!=childs.length())
		{ 
			PlaneProfile ppInt(CoordSys());
			for (int i=0;i<pps.length();i++) 
			{ 
				PlaneProfile pp1 = pps[i]; 
				for (int j=i+1;j<pps.length();j++) 
				{ 
					PlaneProfile pp2 = pps[j]; 
					if (pp2.intersectWith(pp1))
					{
						pp2.vis(3);
						ppInt.unionWith(pp2);
					}
				}//next j				 
			}//next i

			dp.trueColor(red);
			ppInt.extentInDir(_XW).vis(2);
			dp.draw(ppInt);
			dp.draw(ppInt, _kDrawFilled, 20);
		}
	//endregion 

	//region Display
		double dYield = dMasterArea > 0 ? (dChildArea / dMasterArea) * 100 : 0;		
		Map mapAdd;
		mapAdd.setDouble("Yield",dYield);// (master.dYield()*100));////
		if (dYield<dMinYield)
			dpText.color(1);

		String text = master.formatObject("@(Number) (@(Length) x @(Width))\nYield: @(Yield)%", mapAdd);
		dpText.draw(text, _Pt0 , vecXM, vecYM, 1, -1);

		dp.trueColor(green, 50);
		dp.lineType("DASHED",25);
		for (int i=0;i<dLengths.length();i++) 
		{ 
			double dL = dLengths[i];
			if (abs(dL - ppMasterNet.dX()) < dEps)continue;
			Point3d pt = ptRef + vecXM * dL;
			LineSeg seg(pt, pt+vecYM*ppMasterNet.dY());
			
		// do not shwo shorter ruler if intersecting with any child	
			LineSeg segs[] = ppChildsAll.splitSegments(seg, true);
			if (segs.length() > 0)continue;
			
//			seg.vis(2);
			dp.draw(seg); 
		}//next i	
	//endregion 


	}
//endregion 

//region All Master Yield Mode #M2
	else if (mode==2)
	{ 	
		sPainter.setReadOnly(_kHidden);
		sSortDirection.setReadOnly(_kHidden);
		dGap.setReadOnly(_kHidden);

		int bApplyNumber = _bOnDbCreated || bDebug || _Map.getInt("ApplyNumber");
		
	// Collect masters
		MasterPanel masters[0];
		for (int i=0;i<_Entity.length();i++) 
		{ 
			MasterPanel master = (MasterPanel)_Entity[i]; 
			if (master.bIsValid())
			{ 
				setDependencyOnEntity(master);
				masters.append(master);
			}
		}//next i
		
	//region Apply Numbers
		if (bApplyNumber)
		{ 
			int lastNumber;
			Entity ents[] = Group().collectEntities(true, MasterPanel(), _kModelSpace);
			for (int i=0;i<ents.length();i++) 
			{ 
				MasterPanel master = (MasterPanel)ents[i];
				int number = master.number();
				if (masters.find(master)<0 && number>0 && number>lastNumber)
					lastNumber = number;	 
			}//next i
			
			for (int i=0;i<masters.length();i++) 
			{ 
				lastNumber++;
				masters[i].setNumber(lastNumber); 				 
			}//next i	
			_Map.removeAt("ApplyNumber", true);
		}
	//endregion 	

			
	// Collect Yields
		double dSumMasterArea, dMasterAreas[0], dSumChildArea, dChildAreas[0];
		PlaneProfile pps[0];
		for (int i=0;i<masters.length();i++) 
		{ 
			MasterPanel& master = masters[i]; 
			double areaM= master.plShape().area();
			ChildPanel childs[] = master.nestedChildPanels();
			
			double areaC;
			for (int c=0;c<childs.length();c++) 
			{ 
				ChildPanel child = childs[c];
				Sip sip = child.sipEntity();
				PlaneProfile pp = ProfNesting(sip, child.sipToMeTransformation() );
				pps.append(pp);
				areaC += pp.area();
			}//next c
			
			dSumMasterArea += areaM;
			dSumChildArea += areaC;
			
			dMasterAreas.append(areaM);
			dChildAreas.append(areaC);
 
		}//next i
		
		double dOverallYield = dSumMasterArea>0?dSumChildArea/dSumMasterArea*100:0;
		if (dOverallYield<dMinYield)
			dpText.color(1);
			
		Map mapAdd;
		mapAdd.setDouble("Yield",dOverallYield);////		
		
		String text = T("|Yield| ")+_ThisInst.formatObject("@(Yield:RL1)%", mapAdd);

		PLine plTag = GetTagPLine(text, dpText, CoordSys(_Pt0, _XW, _YW, _ZW), textHeight, dimStyle);
		PlaneProfile pp(CoordSys(_Pt0, _XW, _YW, _ZW));
		pp.joinRing(plTag, _kAdd);
		
		dpText.draw(plTag);
		dpWhite.draw(PlaneProfile(plTag), _kDrawFilled, 20);
		dpText.draw(text, pp.ptMid() , _XW, _YW, 0, 0);		
		
	//region Trigger ApplyNumbers
		String sTriggerApplyNumbers = T("|Apply Numbers|");
		addRecalcTrigger(_kContextRoot, sTriggerApplyNumbers );
		if (_bOnRecalc && _kExecuteKey==sTriggerApplyNumbers)
		{
			_Map.setInt("ApplyNumber", true);		
			setExecutionLoops(2);
			return;
		}//endregion	

	}//endregion

//region Setup Mode
	else if (mode == 3)
	{ 
		Map mapAdd;
		String text = _ThisInst.formatObject(sFormat, mapAdd);

		PLine plTag = GetTagPLine(text, dpText, CoordSys(_Pt0, _XW, _YW, _ZW), textHeight, dimStyle);
		PlaneProfile pp(CoordSys(_Pt0, _XW, _YW, _ZW));
		pp.joinRing(plTag, _kAdd);
		
		dpText.draw(plTag);
		dpWhite.draw(PlaneProfile(plTag), _kDrawFilled, 20);
		dpText.draw(text, _Pt0, _XW, _YW, 0, 0);			
	}
//endregion 

//region Sip Based Test Instance
	else if (mode == 99)
	{ 

	// Collect and sort sips	
		Sip sips[] = _Sip;
			
		SortByPainter(sips, sPainterDef, sSortDirection == tAscending);	
		Sip sipsNoChild[] = GetSipsNoChilds(sips);
		
	// Collect profiles and flattend transformations	
		double dMin, dMax;
		PlaneProfile pps[]=CollectPlaneProfiles(sips,dMin, dMax);	
		CoordSys css[] = GetFlattendTransformations(pps, _Pt0, dMaxWidth);		
		
	// draw flattend shapes and some text output	
		for (int i=0;i<sips.length();i++) 
		{ 
			GenBeam gb = sips[i]; 
			PlaneProfile pp = pps[i]; 
			CoordSys ms2ps = css[i];
			
			pp.transformBy(ms2ps);
			
			String text = gb.formatObject(sFormat);
	
			dpText.draw(pp, _kDrawFilled, 90);
			dpText.draw(pp);
			dpText.color(sipsNoChild.find(gb) < 0 ? 3 : 1);
			dpText.draw(text, pp.ptMid(), _XW, _YW, 0, 0);		
			
			 
		}//next i		
		
		return;
	}
//endregion 


//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//region Trigger DAdd Stock Sizes
	addRecalcTrigger(_kContextRoot, sTriggerAddStockSize );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddStockSize)	
	{ 
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select master panels|"), MasterPanel());
		if (ssE.go())
			ents.append(ssE.set());

	
	// Loop masters	
		for (int j=0;j<ents.length();j++) 
		{ 
			MasterPanel master = (MasterPanel)ents[j]; 
			if (master.bIsValid())
			{ 
				String style = master.style();
				double dL = master.dLength();
				double dW = master.dWidth();
				if (bDebug)reportNotice("\nSearching " + style + " " + dL + " " + dW);
				
				
			// Find style	
				Map mapStyle;
				for (int i=0;i<mapStyles.length();i++) 
				{ 
					Map _mapStyle= mapStyles.getMap(i);
					String name = _mapStyle.getString("name").makeUpper();
					if (name == style.makeUpper())
					{ 
						mapStyle = _mapStyle;
						mapStyles.removeAt(i, true);
						if (bDebug)reportNotice("...style map exists");
						break;			
					}
				}
				if (mapStyle.length()<1)
				{ 
					mapStyle.setString("Name", style);
				}

			// Find entry
				int bExists;
				Map mapSizes= mapStyle.getMap("Size[]");
				for (int j=0;j<mapSizes.length();j++) 
				{ 
					Map m = mapSizes.getMap(j);
					double dx = m.getDouble("dX");
					double dy = m.getDouble("dY");
					
					if (abs(dL-dx)<dEps && abs(dW-dy)<dEps)
					{
						if (bDebug)reportNotice("...size exists" + dx +"="+dL + " vs " + dy + "="+dW);
						bExists = true;
						break;
					}					
				}
	
			// Append new entry										
				if (!bExists)
				{ 
					Map mapSize;
					mapSize.setDouble("dX", dL);
					mapSize.setDouble("dY", dW);
					mapSizes.appendMap("Size", mapSize);
					mapStyle.setMap("Size[]", mapSizes);				
					if (bDebug)reportNotice("\nadding " + style + " " + dL + " " + dW);
				}	
				mapStyles.appendMap("Style", mapStyle);
			}
		}//next i				
			
		mapSetting.setMap("Style[]", mapStyles);
		if (mo.bIsValid())mo.setMap(mapSetting);
		else mo.dbCreate(mapSetting);	

		setExecutionLoops(2);
		return;	
	}
	//endregion	

//region Clone Stock Sizes
//region Trigger CloneStockSizes
	String sTriggerCloneStockSizes = T("|Clone Stock Sizes|");
	if (mapStyles.length()==1 && MasterPanelStyle().getAllEntryNames().length()>1)
		addRecalcTrigger(_kContextRoot, sTriggerCloneStockSizes );
	if (_bOnRecalc && _kExecuteKey==sTriggerCloneStockSizes)
	{
		Map mapStyle= mapStyles.getMap(0);
		String name = mapStyle.getString("name").makeUpper();
		
		String styles[]= MasterPanelStyle().getAllEntryNames();
		for (int i=0;i<styles.length();i++) 
		{ 
			String style = styles[i].makeUpper(); 

			if (name != style)
			{ 
				Map _mapStyle = mapStyle;
				_mapStyle.setString("Name", styles[i]);
				mapStyles.appendMap("Style", _mapStyle);		
			}
		}//next i

		mapSetting.setMap("Style[]", mapStyles);
		if (mo.bIsValid())mo.setMap(mapSetting);
		else mo.dbCreate(mapSetting);

		setExecutionLoops(2);
		return;
	}//endregion	
		
//endregion 




//region Trigger Import/Export Settings
	if (findFile(sFullPath).length()>0)
	{ 
		String sTriggerImportSettings = T("|Import Settings|");
		addRecalcTrigger(_kContext, sTriggerImportSettings );
		if (_bOnRecalc && _kExecuteKey==sTriggerImportSettings)
		{
			mapSetting.readFromXmlFile(sFullPath);	
			if (mapSetting.length()>0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);	
				reportMessage(TN("|Settings successfully imported from| ") + sFullPath);	
			}
			setExecutionLoops(2);
			return;
		}			
	}

// Trigger ExportSettings
	if (mapSetting.length() > 0)
	{
		String sTriggerExportSettings = T("|Export Settings|");
		addRecalcTrigger(_kContext, sTriggerExportSettings );
		if (_bOnRecalc && _kExecuteKey == sTriggerExportSettings)
		{
			int bWrite;
			if (findFile(sFullPath).length()>0)
			{ 
				String sInput = getString(T("|Are you sure to overwrite existing settings?|") + " [" + T("|No|") +"/"+T("|Yes|")+"]").left(1);
				bWrite = sInput.makeUpper() == T("|Yes|").makeUpper().left(1);
			}
			else bWrite = true;
				
			if (bWrite && mapSetting.length() > 0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
				
			// make sure the path exists	//HSB-10750
				int bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
				
			// write file	
				mapSetting.writeToXmlFile(sFullPath);
				
			// report rsult of writing	
				if (findFile(sFullPath).length()>0)		reportMessage(TN("|Settings successfully exported to| ") + sFullPath);
				else									reportMessage(TN("|Failed to write to| ") + sFullPath);		
			}
			
			setExecutionLoops(2);
			return;
		}
	}
	//endregion 
}
//End Dialog Trigger//endregion 







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
        <int nm="BreakPoint" vl="2229" />
        <int nm="BreakPoint" vl="2229" />
        <int nm="BreakPoint" vl="2290" />
        <int nm="BreakPoint" vl="2290" />
        <int nm="BreakPoint" vl="4050" />
        <int nm="BreakPoint" vl="4042" />
        <int nm="BreakPoint" vl="2087" />
        <int nm="BreakPoint" vl="2091" />
        <int nm="BreakPoint" vl="2050" />
        <int nm="BreakPoint" vl="2183" />
        <int nm="BreakPoint" vl="2183" />
        <int nm="BreakPoint" vl="2200" />
        <int nm="BreakPoint" vl="2200" />
        <int nm="BreakPoint" vl="2041" />
        <int nm="BreakPoint" vl="2045" />
        <int nm="BreakPoint" vl="2004" />
        <int nm="BreakPoint" vl="441" />
        <int nm="BreakPoint" vl="420" />
        <int nm="BreakPoint" vl="2229" />
        <int nm="BreakPoint" vl="2229" />
        <int nm="BreakPoint" vl="2290" />
        <int nm="BreakPoint" vl="2290" />
        <int nm="BreakPoint" vl="2087" />
        <int nm="BreakPoint" vl="2091" />
        <int nm="BreakPoint" vl="2050" />
        <int nm="BreakPoint" vl="2183" />
        <int nm="BreakPoint" vl="2183" />
        <int nm="BreakPoint" vl="2200" />
        <int nm="BreakPoint" vl="2200" />
        <int nm="BreakPoint" vl="2041" />
        <int nm="BreakPoint" vl="2045" />
        <int nm="BreakPoint" vl="2004" />
        <int nm="BreakPoint" vl="441" />
        <int nm="BreakPoint" vl="420" />
        <int nm="BreakPoint" vl="486" />
        <int nm="BreakPoint" vl="472" />
        <int nm="BreakPoint" vl="495" />
        <int nm="BreakPoint" vl="2229" />
        <int nm="BreakPoint" vl="2229" />
        <int nm="BreakPoint" vl="2290" />
        <int nm="BreakPoint" vl="2290" />
        <int nm="BreakPoint" vl="4047" />
        <int nm="BreakPoint" vl="4039" />
        <int nm="BreakPoint" vl="2087" />
        <int nm="BreakPoint" vl="2091" />
        <int nm="BreakPoint" vl="2050" />
        <int nm="BreakPoint" vl="2183" />
        <int nm="BreakPoint" vl="2183" />
        <int nm="BreakPoint" vl="2200" />
        <int nm="BreakPoint" vl="2200" />
        <int nm="BreakPoint" vl="2041" />
        <int nm="BreakPoint" vl="2045" />
        <int nm="BreakPoint" vl="2004" />
        <int nm="BreakPoint" vl="441" />
        <int nm="BreakPoint" vl="420" />
        <int nm="BreakPoint" vl="2229" />
        <int nm="BreakPoint" vl="2229" />
        <int nm="BreakPoint" vl="2290" />
        <int nm="BreakPoint" vl="2290" />
        <int nm="BreakPoint" vl="2087" />
        <int nm="BreakPoint" vl="2091" />
        <int nm="BreakPoint" vl="2050" />
        <int nm="BreakPoint" vl="2183" />
        <int nm="BreakPoint" vl="2183" />
        <int nm="BreakPoint" vl="2200" />
        <int nm="BreakPoint" vl="2200" />
        <int nm="BreakPoint" vl="2041" />
        <int nm="BreakPoint" vl="2045" />
        <int nm="BreakPoint" vl="2004" />
        <int nm="BreakPoint" vl="441" />
        <int nm="BreakPoint" vl="420" />
        <int nm="BreakPoint" vl="486" />
        <int nm="BreakPoint" vl="472" />
        <int nm="BreakPoint" vl="495" />
        <int nm="BreakPoint" vl="3696" />
        <int nm="BreakPoint" vl="4025" />
        <int nm="BreakPoint" vl="4365" />
        <int nm="BreakPoint" vl="3511" />
        <int nm="BreakPoint" vl="2723" />
        <int nm="BreakPoint" vl="1894" />
        <int nm="BreakPoint" vl="4157" />
        <int nm="BreakPoint" vl="2674" />
        <int nm="BreakPoint" vl="2524" />
        <int nm="BreakPoint" vl="2465" />
        <int nm="BreakPoint" vl="2495" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23420 painter based grouping supported" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="2/26/2025 3:16:43 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21851 initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="5/7/2024 3:38:38 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End