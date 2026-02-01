#Version 8
#BeginDescription
#Versions
Version 2.2 12.02.2025 HSB-23372 fully supporting new behaviour of controlling properties
Version 2.1 29.11.2024 HSB-21733 bugfix position vertical spacers when using fixed length
Version 2.0 22.11.2024 HSB-21733 complete revision, NOT compatible with previous releases, supports horizontal and vertical spacers


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 2
#KeyWords 
#BeginContents
//region Part #1

//region <History>
// #Versions
// 2.2 12.02.2025 HSB-23372 fully supporting new behaviour of controlling properties , Author Thorsten Huck
// 2.1 29.11.2024 HSB-21733 bugfix position vertical spacers when using fixed length , Author Thorsten Huck
// 2.0 22.11.2024 HSB-21733 complete revision, NOT compatible with previous releases, supports horizontal and vertical spacers , Author Thorsten Huck
// 1.3 17.11.2023 HSB-20449 hardware added , Author Thorsten Huck
// 1.2 24.10.2023 HSB-19659 reference link renamed , Author Thorsten Huck
// 1.1 19.10.2023 HSB-19659 additional properties to distinguish between inside/between packs spacers
// 1.0 18.10.2023 HSB-19659 first beta release , Author Thorsten Huck

/// <insert Lang=en>
/// Select stack entities or packs
/// </insert>

// <summary Lang=en>
// This tsl creates spacers of a stacking 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "StackSpacer")) TSLCONTENT

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

	String kTruckParent = "hsb_TruckParent";
	String kTruckChild = "hsb_TruckChild";
	String kPackageParent = "hsb_PackageParent";
	String kPackageChild = "hsb_PackageChild";

	String kDataLink = "DataLink", kData="Data", kScriptItem="StackItem", kScriptPack="StackPack", kScriptStack="StackEntity";
	String tVertical = T("|Vertical|"), tHorizontal= T("|Horizontal|"), sAlignments[] ={tHorizontal, tVertical };
	String kRevertDirection="revertDirection", tFixed = T("|Fixed|"), tEven=T("|Even|"), tVertex= T("|Vertex Points|");
	
	String tRPackItems = T("|Items in Pack|"),tRPack2Pack = T("|Pack to Pack|"),tRStack = T("|Entire Stack|"),   sRelations[] ={ tRPackItems,tRPack2Pack,tRStack};
	String tSpacerHeightName=T("|Spacer Height|");
	
	
	Plane pnW(_PtW,_ZW);
	int nMode = _Map.getInt("mode");
//end Constants//endregion

		
//Part #1 //endregion 

//region Functions

//region Function GetStackOrigin
	// returns the base point of a stack
	Point3d GetStackOrigin(TslInst stack)
	{ 
		Point3d pt;
		Map mapX = stack.subMapX(kTruckParent);
		if (mapX.hasPoint3d("ptOrg"))
			pt = mapX.getPoint3d("ptOrg");	
		else
			reportMessage("\nGetStackOrigin: failed");
		return pt;
	}//endregion

//region Function SnapToClosestAxis
	// returns the closest point of the closest axis
	Point3d SnapToClosestAxis(PLine plAxes[], Point3d pt, Vector3d vecPerp)
	{ 
		Point3d ptOut = pt;
		double dist = U(10e20);
		for (int i=0;i<plAxes.length();i++) 
		{ 
			Point3d ptClosest = plAxes[i].closestPointTo(pt); 
			double d = abs(vecPerp.dotProduct(ptClosest - pt));
			if (d<dist)
			{ 
				dist = d;
				ptOut = ptClosest;
				
			}
		}//next i

		return ptOut;
	}//endregion

//region Function PurgeTslHwcs
	// removes any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	HardWrComp[] PurgeTslHwcs(HardWrComp hwcs[])
	{ 
		for (int i=hwcs.length()-1; i>=0 ; i--) 
			if (hwcs[i].repType() == _kRTTsl)
				hwcs.removeAt(i);
		return hwcs;
	}//endregion

//region Function SummarizeHwcs
	// summarizes hardware components by their article number
	void SummarizeHwcs(HardWrComp& hwcs[], HardWrComp hwcsIn[])
	{ 
	// loop all entries to be added	
		for (int j=0;j<hwcsIn.length();j++) 
		{ 
			HardWrComp hwcIn = hwcsIn[j];
			String articleNumberIn = hwcIn.articleNumber().makeUpper(); 
			int bFound;
			
		// compare with all existing	
			for (int i=0;i<hwcs.length();i++) 
			{ 
				HardWrComp& hwc = hwcs[i];
				String articleNumber = hwc.articleNumber().makeUpper();	
			
			// aricle found: inkrement quantity
				if (articleNumber==articleNumberIn) 
				{
					hwc.setQuantity(hwc.quantity() + hwcIn.quantity());
					bFound = true;
					break;
				}
			}
			
		// article not found: append	
			if (!bFound)
				hwcs.append(hwcIn);
		}//next i

		return;
	}//endregion



//region Function GetGripByName
	// returns the grip index if found in array of grips
	// name: the name of the grip
	int GetGripByName(Grip grips[], String name)
	{ 
		int out = - 1;
		for (int i=0;i<grips.length();i++) 
		{ 
			if (grips[i].name()== name)
			{
				out = i;
				break;
			}	 
		}//next i
		return out;
	}//End getGripByName //endregion

//region Function CreateGrip
	// creates a new grip
	// vecX, vecY: the coordSys and hide directions
	Grip CreateGrip(Point3d ptLoc, int shapeType, String name, Vector3d vecX, Vector3d vecY, int color, String toolTip, Vector3d viewDirections[], Vector3d hideDirections[])
	{ 
		Grip grip;
		grip.setPtLoc(ptLoc);
		grip.setName(name);
		grip.setColor(color);
		grip.setShapeType(shapeType);	
		
		grip.setVecX(vecX);
		grip.setVecY(vecY);
		
		//grip.setIsRelativeToEcs(false);
		//grip.setIsStretchPoint(true);
		if (viewDirections.length()>0)
		{ 
			for (int i=0;i<viewDirections.length();i++) 
				grip.addViewDirection(viewDirections[i]); 
		}
		else if (hideDirections.length()>0)
		{ 
			for (int i=0;i<hideDirections.length();i++) 
				grip.addHideDirection(hideDirections[i]); 		
		}

		grip.setToolTip(toolTip);
		
		//reportNotice("\nGrip "+ name + " added at " + ptLoc);
		return grip;
	}//endregion


//region ArrayToMapFunctions

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
	Map SetBodyArray(Body bodies[], String key)
	{ 
		key = key.length() < 1 ? "body" : key;
		Map mapOut;
		for (int i=0;i<bodies.length();i++) 
			mapOut.appendBody(key, bodies[i]);	
		return mapOut;
	}//endregion
	
//End ArrayToMapFunctions //endregion 	 	




//region Function DrawInvalidSymbol
	// draws the invalid / delete cross
	// pp: a planeprofile carrying the coordsys
	void DrawInvalidSymbol(PlaneProfile pp)
	{ 
		CoordSys cs = pp.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		
		Point3d pt = pp.ptMid();
		double size = getViewHeight() / 30;
		Vector3d vec = vecX * size + vecY * .1 * size;
		PlaneProfile ppx; ppx.createRectangle(LineSeg(pt - vec, pt + vec), vecX, vecY);
		vec = vecY * size + vecX * .1 * size;
		PlaneProfile ppy; ppy.createRectangle(LineSeg(pt - vec, pt + vec), vecX, vecY);
		ppx.unionWith(ppy);
		CoordSys rot; rot.setToRotation(45, vecZ, pt);
		ppx.transformBy(rot);
	
		Display dp(-1);
		dp.trueColor(red);
		dp.draw(ppx, _kDrawFilled, 30);
		dp.draw(ppx);
		
		return;
	}//endregion

//region Function GetGroupedDimstyles
	// returns 2 arrays of same length (translated and source) of dimstyles which match the filter criteria
	// type: 0 = linear, 1 = undefined, 2 = angular, 3= diameter, 4 = Radial, 6 = coordinates, 7= leader and tolerances
	String[] GetGroupedDimstyles(int type, String dimStyles[])
	{ 
		String dimStylesUI[0];
		dimStyles.setLength(0);

	// some types are not supported, fall back to linear
		if (type<0 || type>4)
			type = 0;

	// append potential linear overrides	
		String sOverrides[0];
		for (int i=0;i<_DimStyles.length();i++) 
		{ 
			String dimStyle = _DimStyles[i]; 
			int n = dimStyle.find("$"+type, 0, false);	// indicating it is an override of the dimstyle
			if (n>-1 && dimStyles.find(dimStyle,-1)<0)
			{
				dimStylesUI.append(dimStyle.left(n)); // trim the appendix
				dimStyles.append(dimStyle);
			}
		}//next i

	// append all non overrides	
		for (int i = 0; i < _DimStyles.length(); i++)
		{
			String dimStyle = _DimStyles[i]; 
			int n = dimStyle.find("$", 0, false);	// <0 it is not any override of a dimstyle

			if (n<0 && dimStyles.findNoCase(dimStyle)<0 && dimStylesUI.findNoCase(dimStyle)<0) // do not append any parent of a grouped one
			{ 
				dimStylesUI.append(dimStyle);
				dimStyles.append(dimStyle);				
			}
		}
	
	// nothing found
		if (dimStylesUI.length()<1)
		{ 
			dimStylesUI = _DimStyles;
			dimStyles = _DimStyles;	
		}

	// order alphabetically
		for (int i=0;i<dimStylesUI.length();i++) 
			for (int j=0;j<dimStylesUI.length()-1;j++) 
				if (dimStylesUI[j]>dimStylesUI[j+1])
				{
					dimStylesUI.swap(j, j + 1);
					dimStyles.swap(j, j + 1);
				}
		
		return dimStylesUI;
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
			ents = Group().collectEntities(true, TslInst(),  _kModelSpace);
		
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

//region Function FilterTslsByNames
	// returns all tsl instances with a certain scriptname
	// ents: the array to search, if empty all tsls in modelspace are taken
	// names: the names of the tsls to be returned, all if empty
	TslInst[] FilterTslsByNames(Entity ents[], String names[])
	{ 
		TslInst out[0];
		int bAll = names.length() < 1;
		
		if (ents.length()<1)
			ents = Group().collectEntities(true, TslInst(),  _kModelSpace);
		
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
	


//region Function AppendChilds
	// appends the childs stacked in a stack and in the nested packs and returns the quabtity added
	int AppendChilds(Entity ents[], TslInst& childs[])
	{ 
		int numIn = childs.length();
		TslInst packs[] = FilterTslsByName(ents, kScriptPack);
		TslInst items[] = FilterTslsByName(ents, kScriptItem);
		for (int i=0;i<items.length();i++) 
			if (childs.find(items[i])<0)
				childs.append(items[i]); 


		for (int j=0;j<packs.length();j++) 
		{ 
			TslInst pack = packs[j]; 
			Entity entsPack[] = pack.entity();
			TslInst itemsPack[] = FilterTslsByName(entsPack, kScriptItem); 
			
			for (int i=0;i<itemsPack.length();i++) 
				if (items.find(itemsPack[i])<0)
					childs.append(itemsPack[i]); 				
		}//next j
		
		int numOut = childs.length();
		return numOut-numIn;
	}//endregion

//region Function GetBodies
	// returns the bodies of the given items
	Body[] GetBodies(TslInst items[])
	{ 
		Body bodies[0];
		for (int i=0;i<items.length();i++) 
			bodies.append(items[i].realBody()); 
		return bodies;
	}//endregion	

//region Function GetUnionProfile
	// returns a combined planeprofile
	void GetUnionProfile(PlaneProfile& ppUnion, PlaneProfile pps[])
	{ 
		ppUnion.shrink(-dEps);
		for (int i=0;i<pps.length();i++) 
		{ 
			PlaneProfile pp= pps[i]; 
			pp.shrink(-dEps);
			ppUnion.unionWith(pp);			
		}//next i
		ppUnion.shrink(dEps);			
		return;
	}//endregion

//region Function GetShadows
	// returns the shadow planeprofiles of the given items
	PlaneProfile[] GetShadows(Body bodies[], PLine& hull, Vector3d vecView)
	{ 
		PlaneProfile pps[0];
		Point3d pts[0];
		for (int i=0;i<bodies.length();i++) 
		{
			Body& bd = bodies[i];
			PlaneProfile pp = bd.shadowProfile(Plane(bd.ptCen(), vecView));
			
			//{Display dpx(i); dpx.draw(pp, _kDrawFilled,20);}
			pps.append(pp);
			pts.append(pp.getGripVertexPoints());
		}
		hull.createConvexHull(Plane(_Pt0, vecView), pts);
		
		return pps;
	}//endregion	

////region Function GetRange
//	// returns the  range of the given items
//	PlaneProfile GetRange(TslInst items[])
//	{ 	
//		Body bodies[]=GetBodies(items);
//		PLine plHull;
//		PlaneProfile shadows[]=GetShadows(bodies, plHull);		
//		
//		PlaneProfile ppRange(CoordSys());
//		ppRange.joinRing(plHull, _kAdd);		
//		return ppRange;
//	}//endregion

//region Function GetDistributionParams
	// returns the qty of columns and alters the given interdistance
	int GetDistributionParams(int mode,Vector3d vecDir, double& interdistance, Point3d pts[])
	{ 
		int out;
		double dist= interdistance;

		pts = Line(_Pt0,vecDir).orderPoints(pts);
		double dRange;
		if (pts.length()>0)
			dRange= vecDir.dotProduct(pts.last()-pts.first());

		if (dRange<=dEps)
		{ 
			interdistance = 0;
			return out;
		}

		if (mode==0 && dist>0)// fixed
			out = dRange / dist+1;
		else if (mode==1 && dist>0)// even
		{
			out = dRange / dist+.999999;
			dist = dRange / out;
		}
		else if (mode==2)// vertex
		{
			out = pts.length()-1;
			dist = 0;
		}	
		interdistance = dist;
		return out;
	}//endregion

//region Function CollectDistributionPoints
	// returns the distribution points based on interdistance and width
	Point3d[] CollectDistributionPoints(int distributionMode, Vector3d vecDir, double interdistance, Point3d pts[], double width)
	{ 
		Point3d out[0];
		for (int i=0;i<pts.length()-1;i++) 
		{ 
			Point3d pt1 = pts[i]; 
			Point3d pt2 = pts[i+1];
			
			Point3d ptsXi[] ={ pt1, pt2};
			double dist = interdistance;
			int n = GetDistributionParams(distributionMode, vecDir, dist, ptsXi);

			ptsXi.setLength(0);
			for (int j=0;j<n;j++) 
			{ 
				pt1.vis(j);
				ptsXi.append(pt1);
				pt1 += vecDir * dist;
				
			}//next j
			out.append(ptsXi);
		}//next i
		
	// append last
		if (out.length()>0)
		{ 
			double dLast = vecDir.dotProduct(pts.last() - out.last());
			if (dLast>.5*width)
				out.append(pts.last());
		}		
		
		return out;
	}
	//endregion


//region Function GetRangesAtPoint
	// returns the intersecting ranges representing a spacer at the given axis
	PlaneProfile[] GetRangesAtPoint(PlaneProfile ppRange, Point3d pt, double width)
	{
		CoordSys cs = ppRange.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		
		PlaneProfile hull(cs);
		hull.createRectangle(ppRange.extentInDir(vecX), vecX, vecY);
		
		Vector3d vec = vecX * .5 * width + vecY * U(10e5);
		
		PlaneProfile ppx(cs);
		ppx.createRectangle(LineSeg(pt - vec, pt + vec), vecX, vecY);
		ppx.intersectWith(ppRange);			
		ppx.createRectangle(ppx.extentInDir(vecX), vecX, vecY);
		//{Display dpx(40); dpx.draw(ppx, _kDrawFilled,20);}
		ppx.subtractProfile(ppRange);
		
		//{Display dpx(4); dpx.draw(ppx, _kDrawFilled,20);}		
		PlaneProfile out[0];
		PLine rings[] = ppx.allRings(true, false);
		for (int r=0;r<rings.length();r++) 
		{ 
			PlaneProfile pp(cs);
			pp.joinRing(rings[r],_kAdd); 
			if (pp.dX()>U(2) && pp.dY()>U(2))
			{
				//{Display dpx(60); dpx.draw(pp, _kDrawFilled,20);}	
				out.append(pp);
			}
		}//next r
		
		return out;
	}//endregion

//region Function TrimRanges
	// trims the spacer ranges to a minmal value, ie. at the end of an item or if the location is between two items with a gap
	// returns true or false if the profile has been trimmed
	int TrimRanges(PlaneProfile& pp, PlaneProfile ppShadows[])
	{ 
		int bTrim;
		
		CoordSys cs = pp.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();				
		
		for (int i=0;i<ppShadows.length();i++) 
		{ 
			PlaneProfile ppx= pp;
			ppx.shrink(-U(1));
			//{Display dpx(6); dpx.draw(ppx, _kDrawFilled,20);}
			if (ppx.intersectWith(ppShadows[i]))
			{ 
				
				PlaneProfile ppi= ppShadows[i];
				//{Display dpx(i); dpx.draw(ppi, _kDrawFilled,20);}
				Vector3d vec = vecX * U(10e4) + .5*vecY * ppi.dY();
				Point3d pt = ppi.ptMid();
				PlaneProfile ppMax; ppMax.createRectangle(LineSeg(pt - vec, pt + vec), vecX, vecY);
				ppi = ppMax;
				
				
				
				if (ppi.intersectWith(pp))
				{ 
					pp.subtractProfile(ppMax);
					pp.shrink(dEps); // purge zero dX and or dY rings
					pp.shrink(-dEps);					
					bTrim = true;
				}
				
			}

			 
		}//next i
	
		return bTrim;
	}//endregion

//region Function GetAdjacentIndices
	// returns the indices of the items, shadows and bodies which are adjacent 
	int[] GetAdjacentIndices(PlaneProfile pp, PlaneProfile& shadows[])
	{ 
		int out[0];
		PlaneProfile pps[0];
		for (int i=0;i<shadows.length();i++) 
		{ 
			PlaneProfile ppx= pp;
			ppx.shrink(-U(1));
			//{Display dpx(6); dpx.draw(ppx, _kDrawFilled,20);}
			if (ppx.intersectWith(shadows[i]))
			{
				out.append(i);	 
				pps.append(shadows[i]);
			}
		}//next i		
		shadows = pps;
		return out;
	}//endregion


//region Function GetParent
	// returns the parent stack or pack
	TslInst GetParent(TslInst child)
	{ 
		TslInst parent;
		
		String key, keys[] = child.subMapXKeys();
		if (keys.findNoCase(kPackageChild,-1)>-1)
			key = kPackageChild;
		else if (keys.findNoCase(kTruckChild,-1)>-1)
			key = kTruckChild;			
		
		Map mapX=child.subMapX(key);
		
		String parentUID = mapX.getString("ParentHandle");
		Entity entParent; entParent.setFromHandle(parentUID);
		if(entParent.bIsValid())
		{
			parent = (TslInst)entParent;
			//reportNotice("\nparent found " + parent.scriptName());
		}
		
		return parent;
	}//endregion


//region Function GetEntitiesByRelation
	// returns a stack if the set and the relation match, packs array will be modified
	TslInst GetEntitiesByRelation(String relation, Entity& ents[],TslInst& packs[] )
	{
		TslInst stack, stacks[]= FilterTslsByName(ents, kScriptStack);
		if (stacks.length()>0)
			stack = stacks.first();
			
		packs.setLength(0);
		//reportNotice("\nGetEntitiesByRelation: Relation " + relation);
		if (relation==tRStack || relation==tRPack2Pack)
		{ 
			
			if (stack.bIsValid())
			{
				packs = FilterTslsByName(stack.entity(), kScriptPack);
				//reportNotice("\nGetEntitiesByRelation: packs " + packs.length() + " stacks " + stacks.length());
			}
		}
		else if (relation==tRPackItems)
		{ 
			
			packs = FilterTslsByName(ents, kScriptPack);
			//reportNotice("\nGetEntitiesByRelation: packs " + packs.length());			
		
		// Get parent stack
			for (int i=0;i<packs.length();i++) 
			{ 
				TslInst pack = packs[i]; 
				TslInst stackP = GetParent(pack);
	
				if (!stack.bIsValid() && stackP.bIsValid())// main parent stack
				{
					stack = stackP;
					break;
				}
			}//next i


		}
		
	// remove entities not belonging to the parent stack	
		if (stack.bIsValid())
		{ 
			//reportNotice("\nGetEntitiesByRelation: Stack " + stack.handle());
			for (int i=ents.length()-1; i>=0 ; i--) 
			{ 
				TslInst t = (TslInst)ents[i];
				if (t==stack){ continue;}
				TslInst stackI = GetParent(t);
				if (stackI!=stack)
				{
					//reportNotice("\n   removing " + stackI.scriptName() + " "+stackI.handle());
					ents.removeAt(i);
				}
			}//next i			
		}

		return stack;
	}//endregion


//region Function GetPromptArg
	// returns the list of keyword arguments in dependency of alignment and direction
	String GetPromptArg(String alignment, Vector3d vecDir)
	{ 
		
		String promptArg;
		if (vecDir.isParallelTo(_XW) && alignment == tHorizontal)
			promptArg = T("|[Y-Direction/Vertical/Fixed/Even/PickPoint/Undo]|");
		else if (vecDir.isParallelTo(_YW) && alignment == tHorizontal)
			promptArg = T("|[X-Direction/Vertical/Fixed/Even/PickPoint/Undo]|");
		else if (vecDir.isParallelTo(_YW) && alignment == tVertical)
			promptArg = T("|[X-Direction/Horizontal/Fixed/Even/PickPoint/Undo]|");
		else
			promptArg = T("|[Y-Direction/Horizontal/Fixed/Even/PickPoint/Undo]|");		
		
		return promptArg;
	}//endregion

	
//region Function GetSpacerProfiles
	// returns the bodies of the collected spacers
	Body[] GetSpacerProfiles(CoordSys cs, PlaneProfile& ppSpacers[], PlaneProfile pps[], PlaneProfile ppShadows[], Body bodies[], int trimProfile, double dWidth, double dLength)
	{ 

		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();

		int bIsHorizontal = vecZ.isPerpendicularTo(_ZW);

		Body bdSpacers[0];
		
		for (int j = pps.length() - 1; j >= 0; j--)
		{
			PlaneProfile& pp = pps[j];
			PlaneProfile shadows[0]; shadows = ppShadows;
			int inds[] = GetAdjacentIndices(pp, shadows);
			
			int bTrim = trimProfile ? TrimRanges(pp, shadows) : false;
			
			// remove invalid
			if (pp.dX() < U(1) || pp.dY() < U(1))
			{
				pps.removeAt(j);
				continue;
			}
			Point3d ptm = pp.ptMid();	//ptm.vis(6);
			PLine pl; pl.createRectangle(pp.extentInDir(vecX), vecX, vecY);
			//{Display dpx(j); dpx.draw(PlaneProfile(pp), _kDrawFilled,10);}
			
			
			// Collect contact faces
			CoordSys csContact(ptm, vecZ, - vecX, - vecY);	//csContact.vis(6);
			PlaneProfile ppCommon(csContact);
			Vector3d vec = vecX * .5 * dWidth + vecZ * U(10e3);
			PLine plC; plC.createRectangle(LineSeg(ptm - vec, ptm + vec), vecX, vecZ);
			ppCommon.joinRing(plC, _kAdd);			//ppCommon.vis(3);
			
			// Collect the two contact faces
			Vector3d vecZC = vecY;
			PlaneProfile ppA, ppB;
			for (int i = 0; i < inds.length(); i++)
			{
				int ind = inds[i];
				if (ind < 0 || ind > bodies.length() - 1) { continue; }
				
				Body bd = bodies[ind];			bd.vis(2);
				Point3d ptCen = bd.ptCen();
				int nSide = vecZC.dotProduct(ptCen - ptm) < 0 ?- 1 : 1;
				Point3d ptFace = ptm + nSide * vecZC * .5 * pp.dY();
				PlaneProfile ppContact(CoordSys(ptFace, vecZ, - vecX, - vecY));
				ppContact.unionWith(bd.extractContactFaceInPlane(Plane(ptFace, vecY), dEps));//bd.shadowProfile(Plane(ptCen, vecY)));
				ppContact.intersectWith(ppCommon);
				//ppContact.vis(i);
				
				if (nSide == 1)
				{
					if (ppA.area() < pow(dEps, 2))
						ppA = ppContact;
					else
						ppA.unionWith(ppContact);
				}
				else
				{
					if (ppB.area() < pow(dEps, 2))
						ppB = ppContact;
					else
						ppB.unionWith(ppContact);
				}
			}//next i
			
			ppCommon = ppA;
			ppCommon.intersectWith(ppA);
			ppCommon.transformBy(vecY * vecY.dotProduct(ptm - ppCommon.ptMid()));
			ppCommon.vis(3);
			
		// Set length max common
			Line ln(ptm, vecZ);
			Point3d ptsA[] = ln.orderPoints(ppA.getGripVertexPoints());
			Point3d ptsB[] = ln.orderPoints(ppB.getGripVertexPoints());
			Point3d ptsAB[0]; 
			ptsAB.append(ptsA);
			ptsAB.append(ptsB);
			ptsAB = ln.orderPoints(ptsAB, dEps);
			
			if (ptsA.length()<1 || ptsB.length()<1)
			{ 
				continue;
			}
			
			Point3d ptMin = bIsHorizontal?ptsAB.first():ptm;
			Point3d ptMax = bIsHorizontal?ptsAB.last():ptsA.last();
			ptMin.vis(3);ptMax.vis(3);
			Point3d ptCen = ln.closestPointTo(ptMin + ptMax) * .5;
			double length = vecZ.dotProduct(ptMax - ptMin);			
			if (dLength>dEps)
			{ 
				length = dLength;
				ptCen = ppCommon.ptMid();
			}
			
			ppA.vis(4);			ppB.vis(2);

			
			if (length<dEps ||pl.length()<dEps)
			{ 
				continue;
			}
			
			PLine plx = pl;
			plx.projectPointsToPlane(Plane(bIsHorizontal?ptCen:ptMin, vecZ), vecZ);
			Body bdSpacer(plx, vecZ * length, bIsHorizontal?0:1);
			bdSpacers.append(bdSpacer);
			//bdSpacer.vis(3);
//			dpModel.draw(bdSpacer);
//			dpPlan.draw(pp,_kDrawFilled, bDrag?30:90);
			
			ppSpacers.append(pp);
			//{Display dpx(bTrim); dpx.draw(pp, _kDrawFilled,50);}
		}//next j		
		return bdSpacers;
	}//endregion	

//End Functions //endregion 

//region Part #2

//region JIGS
	String kJigGripDistribute = "JigGripDistribute";

//GripDistribution
	if (_bOnJig && _kExecuteKey== kJigGripDistribute) 
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
		
		PlaneProfile ppRange = _Map.getPlaneProfile("ppRange");
		Vector3d vecDir = _Map.hasVector3d("vecDir")?_Map.getVector3d("vecDir"):_XW;
		
		Point3d pts[] = _Map.getPoint3dArray("pts");
		pts.append(ptJig);		
			
	// if second points opposite reverse direction
		int bOnTop;
		if (pts.length()==2 && vecDir.dotProduct(pts[1]-pts[0])<0)
		{
			vecDir*=-1;
			bOnTop =!bOnTop;
		}
		
		Vector3d vecPerp = vecDir.crossProduct(-_ZU);
		double textHeight = _Map.getDouble("textHeight");
		String dimStyle = _Map.getString("dimStyle");

		double dWidth = _Map.getDouble("width");
		int nDistributionMode = _Map.getInt("distributionMode");
		double dInterdistance = _Map.getDouble("interdistance");
		
		Point3d ptLoc = ppRange.ptMid() - .5 * (_XW * ppRange.dX() + _YW * ppRange.dY());
				
		Point3d ptsX[] = CollectDistributionPoints(nDistributionMode, vecDir, dInterdistance, pts, dWidth);
		for (int i=0;i<ptsX.length();i++) 
			ptsX[i]+=_ZU*_ZU.dotProduct(ptLoc-ptsX[i]); 

		
		Vector3d vecXDim = vecDir;
		Vector3d vecYDim = vecPerp;
		if (vecXDim.crossProduct(vecYDim).dotProduct(vecZView)<0)
			vecXDim *= -1;
	

		DimLine dl (ptLoc -vecYView*U(300), vecXDim, vecYDim); 
		dl.setUseDisplayTextHeight(true);
		Dim dim(dl,  ptsX,"<>",  "<>" ,_kDimPar, _kDimNone); 
		dim.setReadDirection(2 * vecYView - vecXView);
		dim.setDeltaOnTop(bOnTop);	
		
		Display dp(-1);
		dp.addHideDirection(vecDir);
		dp.addHideDirection(-vecDir);
		
		dp.trueColor(lightblue);
		dp.dimStyle(dimStyle);
		dp.textHeight(textHeight<U(100)?U(100):textHeight);
		dp.draw(ppRange, _kDrawFilled, 50);
		ppRange.shrink(-dEps);
		dp.trueColor(darkyellow);
		for (int i=0;i<ptsX.length();i++) 
		{ 
			LineSeg segs[] = ppRange.splitSegments(LineSeg(ptsX[i] - vecPerp * U(10e4), ptsX[i] + vecPerp * U(10e4)), true);		
			dp.draw(segs); 		
			dim.append(ptsX[i], "<>",  "<>"); 
			
		}//next i
		if (ptsX.length()>1)
			dp.draw(dim);
		return;		
	}
//endregion 

//region Properties #PR

category = T("|Spacer|");
	String sWidthName=T("|Width|");	
	PropDouble dWidth(nDoubleIndex++, U(100), sWidthName);	
	dWidth.setDescription(T("|Defines the width of the spacers|"));
	dWidth.setCategory(category);
	
	String sLengthName=T("|Length|");	
	PropDouble dLength(nDoubleIndex++, U(0), sLengthName);	
	dLength.setDescription(T("|Defines the length of the spacers.|, ") + T("|0 = Auto|"));
	dLength.setCategory(category);

	String sAlignmentName=T("|Alignment|");	
	PropString sAlignment(nStringIndex++,sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the alignment of the stacking item|"));
	sAlignment.setCategory(category);
	sAlignment.setControlsOtherProperties(true);
	if (sAlignments.findNoCase(sAlignment,-1)<0)sAlignment.set(tHorizontal);	
	
category = T("|Distribution|");
	String sRelationName=T("|Relation|");	
	PropString sRelation(nStringIndex++, sRelations, sRelationName);	
	sRelation.setDescription(T("|Defines where spacers will be placed|\n") + 
		tRPackItems + 	": "  + T("|between all items of packs|")+"\n"+
		tRPack2Pack + 		": "  + T("|between all packs|")+"\n"+
		tRStack + 		": "  + T("|between all items of a stack|"));
	sRelation.setCategory(category);
	sRelation.setControlsOtherProperties(true);//deselects the entity when invalid
	
	String sInterdistanceName=T("|Interdistance|") ;	
	PropDouble dInterdistance (nDoubleIndex++, U(1000), sInterdistanceName,_kLength);
	dInterdistance.setCategory(category);
	dInterdistance.setDescription(T("|Defines the interdistance of the spacers|"));
	
	
	String sDistributionModeName=T("|Mode|");	
	String sDistributionModes[] ={ tFixed, tEven, tVertex};
	PropString sDistributionMode(nStringIndex++, sDistributionModes, sDistributionModeName);	
	sDistributionMode.setDescription(T("|Defines the Distribution Mode|"));
	sDistributionMode.setCategory(category);	
	

category = T("|Display|");
	String sDimStyles[] = _DimStyles, sDimStylesUI[] = GetGroupedDimstyles(0, sDimStyles); // type: 0 = linear, 1 = undefined, 2 = angular, 3= diameter, 4 = Radial, 6 = coordinates, 7= leader and tolerances
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyleUI(nStringIndex++, sDimStylesUI, sDimStyleName);	
	sDimStyleUI.setDescription(T("|Defines the dimension style.|"));
	sDimStyleUI.setCategory(category);
	
	String sDimStyle = sDimStyles[sDimStylesUI.findNoCase(sDimStyleUI, 0)];

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the text height, 0 = byDimstyle|"));
	dTextHeight.setCategory(category);
	double textHeight;if (dTextHeight>0)textHeight=dTextHeight;else{ Display dp(0); textHeight=dp.textHeightForStyle("G", sDimStyle);}
	
	
//region Function setReadOnlyFlagOfProperties
	// sets the readOnlyFlag
	void setReadOnlyFlagOfProperties()
	{ 	
		sAlignment.setReadOnly(_bOnInsert ? false : true);
		sDistributionMode.setReadOnly(nMode == 1 && !bDebug ? _kHidden : false);
		dInterdistance.setReadOnly(nMode == 1 && !bDebug ? _kHidden : false);
		sDimStyleUI.setReadOnly(_kHidden);
		dTextHeight.setReadOnly(_kHidden);
		return;
	}//endregion	
	
	
	
//End Properties//endregion 

//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
		{
			setPropValuesFromCatalog(tLastInserted);
			setReadOnlyFlagOfProperties();
			while (showDialog("---") == _kUpdate) // _kUpdate means a controlling property changed.	
			{ 
				setReadOnlyFlagOfProperties(); // need to set hidden state
			}	
			setReadOnlyFlagOfProperties();			
		}

		
		if (dWidth<dEps)
		{ 
			reportNotice("\n" + T("|Width must be < 0|"));
			eraseInstance();
			return;
		}
		int nDistributionMode = sDistributionModes.findNoCase(sDistributionMode ,0);
		int bIsHorizontal = sAlignment == tHorizontal;
		
		textHeight;if (dTextHeight>0)textHeight=dTextHeight;else{ Display dp(0); textHeight=dp.textHeightForStyle("G", sDimStyle);}
		
		double dProps[] = { dWidth, dLength, 0, dTextHeight }; // individual instance has no interdistance
		String sProps[] = { sAlignment, sRelation, sDistributionMode, sDimStyle };
		
	// prompt for packs and/or stacks
		Entity ents[0], entsSet[0];
		PrEntity ssE(T("|Select packs and/or stacks|"), TslInst());
		if (ssE.go())
			ents.append(ssE.set());
		entsSet = ents;
		TslInst stack,packs[0];

		String relation = sRelation;
		stack = GetEntitiesByRelation(relation, ents, packs);
		if (stack.bIsValid())// && packs.length()<1)
		{ 			
			ents.append(stack.entity());			
			stack = GetEntitiesByRelation(relation, ents, packs);
		}
		
		int bHasStack = stack.bIsValid();
		int numPack = packs.length();
		
		// accept partial sset
		if (numPack<1)
		{ 
			packs = FilterTslsByName(entsSet, kScriptPack);
			numPack = packs.length();
			//reportNotice("\n" + numPack + " collected from set " + entsSet.length());
		}

		if(!bHasStack && numPack<1)
		{ 
			Map mapIn;
			mapIn.setString("Notice", T("|Spacers can only be created on packs or stacks.|"));
			mapIn.setString("Title", T("|Invalid Selection Set|"));
			Map mpNoticeOut = callDotNetFunction2(sDialogLibrary, sClass, "ShowNotice", mapIn);
			eraseInstance();
			return;
		}
		
		
	// Change mode if no stack found		
		if (relation!=tRPackItems && !stack.bIsValid() && packs.length()>0)
		{ 
			reportMessage(TN("|No stack found in selection set, mode changed to| '") + tRPackItems+"'");
			relation = tRPackItems;
			sProps[1] = relation;
		}
		
		
		

		TslInst items[0];
		//items.append(FilterTslsByName(stack.entity(), kScriptItem));
		for (int i=0;i<packs.length();i++) 
		{
			int num = AppendChilds(packs[i].entity(), items);
		}

		Body bodies[]=GetBodies(items);
		PLine plHull;
		PlaneProfile shadows[]=GetShadows(bodies, plHull, _ZW);
	
		PlaneProfile ppRange(CoordSys());
		GetUnionProfile(ppRange, shadows);

		Point3d ptLoc = ppRange.ptMid() - .5 * (_XW * ppRange.dX() + _YW * ppRange.dY());
		
		Point3d pts[0];
	
	// default direction
		Vector3d vecDir = _XW;
		String promptArg = T("|[Y-Direction/Vertical]|");
		
	// view from left or right
		int bIsSectionView;
		if (vecZView.isParallelTo(_YW))
		{
			bIsSectionView = true;
			vecDir = _XW;
		}
		else if (vecZView.isParallelTo(_XW))
		{
			bIsSectionView = true;
			vecDir = _YW;
			
			// TODO questionable
//			if (!bIsHorizontal)
//			{ 
//				Map mapIn;
//				mapIn.setString("Notice", T("|Vertical spacers not be inserted in stack front view.|"));
//				mapIn.setString("Title", T("|Invalid View|"));
//				Map mpNoticeOut = callDotNetFunction2(sDialogLibrary, sClass, "ShowNotice", mapIn);
//				eraseInstance();
//				return;				
//			}
			
			
		}
		
		Line lnDir(ptLoc, vecDir);
		if (sAlignment == tVertical)
			promptArg = T(" |[Y-Direction/Horizontal]|");
		String prompt = T("|Pick first point of distribution|")+promptArg;

	    Map mapArgs;

	    mapArgs.setInt("_Highlight", in3dGraphicsMode()); 
	    mapArgs.setPoint3dArray("pts", pts);
	    //mapArgs.setPoint3d("ptLoc", _Pt0);
	    mapArgs.setPlaneProfile("ppRange", ppRange);
	    mapArgs.setDouble("width", dWidth);
	    mapArgs.setVector3d("vecDir", vecDir);
	    mapArgs.setDouble("textHeight", textHeight);
	    mapArgs.setString("dimStyle", sDimStyle);
	    mapArgs.setString("alignment", sAlignment);
	    mapArgs.setInt("distributionMode", nDistributionMode);
	    mapArgs.setDouble("interdistance", dInterdistance);
	    
	    PrPoint ssP(prompt);
		int nGoJig = -1;   
		while (nGoJig != _kNone)
		{
			nGoJig = ssP.goJig(kJigGripDistribute, mapArgs);

			if (nGoJig == _kOk)
			{
				Point3d pt = ssP.value(); //retrieve the selected point
				
				int num = pts.length();
				pts.append(pt);
				
			// if second points opposite reverse direction
				if (pts.length()==2 && vecDir.dotProduct(pts[1]-pts[0])<0)
				{ 
					vecDir*=-1;
					mapArgs.setVector3d("vecDir", vecDir);
				}

				if (dInterdistance>0 && pts.length()>1)//nDistributionMode < 2 && 
					pts = CollectDistributionPoints(nDistributionMode, vecDir, dInterdistance, pts, dWidth);
			
				pts = lnDir.orderPoints(lnDir.projectPoints(pts), dEps);
				if (num>0 && pts.length()==num)
					reportMessage(TN("|invalid point, point must be differ in X-direction|"));
				else
					mapArgs.setPoint3dArray("pts", pts);
				
			// keep on prompting if in vertex mode or distribution with less than 2					
				if (nDistributionMode<2 && ((pts.length()>0 && dInterdistance<=dEps) || (pts.length()>1 && dInterdistance>0)))
				{ 
					break;
				}
				else
				{ 	
					String alignment = sAlignment;
					String promptArg = GetPromptArg(alignment, vecDir);
					prompt = T("|Pick next point| ")+promptArg;	
					ssP = PrPoint (prompt, pt);					
				}
				

			}
			else if (nGoJig == _kKeyWord)
			{
				if (ssP.keywordIndex() == 0 && !bIsSectionView)//Direction, not available in sectional views
				{
					vecDir = vecDir.isParallelTo(_XW) ? _YW : _XW;
					mapArgs.setVector3d("vecDir", vecDir);
				}
				else if (ssP.keywordIndex() == 1)//Alignment
				{ 
					String alignment = sAlignment == tVertical ? tHorizontal:tVertical;
					sAlignment.set(alignment);
					mapArgs.setString("alignment", alignment);					
				}
				else if (ssP.keywordIndex() == 2)//fixed
					nDistributionMode = 1;
				else if (ssP.keywordIndex() == 3)//even
					nDistributionMode = 1;
				else if (ssP.keywordIndex() == 4) //vertex
					nDistributionMode = 2;
				else if (ssP.keywordIndex() == 5 && pts.length()>1) //undo
				{ 
					pts.removeAt(pts.length() - 1);
					mapArgs.setPoint3dArray("pts", pts);
				}
				sDistributionMode.set(sDistributionModes[nDistributionMode]);
				mapArgs.setInt("distributionMode", nDistributionMode);
				
				String alignment = sAlignment;
				String promptArg = GetPromptArg(alignment, vecDir);
				
				if (pts.length()<1)
				{
					prompt = T("|Pick first point of distribution| ")+promptArg;
					ssP = PrPoint (prompt);	
				}
				else
				{
					prompt = T("|Pick next point| ")+promptArg;	
					ssP = PrPoint (prompt, pts.last());	
				}
					
				
				
				
			}	
	        else if (nGoJig == _kCancel)
	        { 
	            eraseInstance(); // do not insert this instance
	            return; 
	        }				
		}
		
	// create TSL
		TslInst tslNew;		Vector3d vecXTsl= vecDir;		Vector3d vecYTsl= vecDir.crossProduct(-_ZW);
		GenBeam gbsTsl[] = {};		
		Entity entsTsl[] = {};	
		Point3d ptsTsl[2];
		if (stack.bIsValid())
		{
			ptsTsl[0] = GetStackOrigin(stack);
			entsTsl.append(stack);
		}
		
		for (int i=0;i<packs.length();i++) 
		{
			if (!stack.bIsValid() && i==0)
				ptsTsl[0] = packs[0].ptOrg();
			entsTsl.append(packs[i]);
		}
	
		int nProps[]={};;
		Map mapTsl;	mapTsl.setInt("mode", 1);
		if (entsTsl.length()>0)
			for (int i=0;i<pts.length();i++) 
			{ 
				ptsTsl[1]=pts[i];						
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
			}//next i
		
		eraseInstance();
		return;
	}	
	setReadOnlyFlagOfProperties();
//endregion 

//Part #2 //endregion

//region General
	addRecalcTrigger(_kGripPointDrag, "_Grip");	
	int indexOfMovedGrip = Grip().indexOfMovedGrip(_Grip);
	int bDrag = _bOnGripPointDrag && indexOfMovedGrip >- 1 && _kExecuteKey=="_Grip";
	int bOnDragEnd = !_bOnGripPointDrag && indexOfMovedGrip >- 1;	

// Store ThisInst in _Map to enable debugging with subMapX until HSB-22564 is implemented
	TslInst this = _ThisInst;
	if (bDebug && _Map.hasEntity("thisInst"))
	{
		Entity ent = _Map.getEntity("thisInst");	
		this = (TslInst)ent;
	}
	else if (!bDebug && (_bOnDbCreated || !_Map.hasEntity("thisInst")))
		_Map.setEntity("thisInst", this);

	if (!bDrag)
	{
		this.setDrawOrderToFront(false);
		this.setAllowGripAtPt0(bDebug);
	}

	
	for (int i=0;i<_Entity.length();i++) 
	{ 
		setDependencyOnEntity(_Entity[i]); 
	}//next i

	int bIsHorizontal = sAlignment == tHorizontal;
	Vector3d vecX = _XE;
	Vector3d vecY = bIsHorizontal?_ZE:_YE;
	Vector3d vecZ = bIsHorizontal?-_YE:_ZE;	
	Point3d ptRef = _PtG.length()>0?_PtG[0]:_Pt0;
		
	CoordSys cs(ptRef, vecX, vecY, vecZ);
	cs.vis(6);
	
	// Display
	int nc = 45;
	if (this.color() != nc)this.setColor(nc);
	Display dpPlan(-1), dpText(-1), dpModel(nc);
	dpText.dimStyle(sDimStyle);
	dpText.textHeight(textHeight);

//endregion 




//region Get parent entities
	TslInst packs[0], stack;	
	{
		String relation = sRelation;
		Entity ents[0]; ents = _Entity;
		stack = GetEntitiesByRelation(relation, ents, packs);
	}		

	// HSB-21733
	TruckDefinition td;	
	int bHasStack = stack.bIsValid();
	if (bHasStack)
	{ 
	// Loose pack: remove potential invalid stack	
		if (packs.length()==1 && sRelation==tRPackItems)
		{ 
			int n = _Entity.find(stack);
			TslInst stackP = GetParent(packs.first());
			if (stack!=stackP && n>-1) // remove and invalidate stack
			{
				_Entity.removeAt(n);
				stack = TslInst();
				bHasStack = false;
			}
		}
		if (bHasStack)
		{ 
			if (_Entity.find(stack)<0 )//&& sRelation!=tRPackItems)
				_Entity.append(stack);
			
		// append remotly if not in _Entity of the stack	
			if (stack.entity().find(this)<0)
			{ 
				Entity ents[] ={ this};
				Map m, map=stack.map();;
				m.setEntityArray(ents,true, "ent[]", "", "ent");
				map.setMap("AppendRemoteSet", m);
				stack.setMap(map);
				//reportNotice("\nSpacer " + this.handle() + " has appended itself to stack " + stack.formatObject("@(Number:D)  @(Handle)"));
				stack.transformBy(Vector3d(0, 0, 0));
			}
			
		}	
	}
	


	
	if (bHasStack)
	{ 
		td = TruckDefinition (stack.propString(T("|Definition|")));
		//_Pt0 = GetStackOrigin(stack);
	}
//	Vector3d vecMoved = _Pt0-_Map.getVector3d("vecOrg");
//	_Map.setVector3d("vecOrg", _Pt0 - _PtW);
	//reportNotice("\nEvent Name/ExeKey/Recalc/Zero/Locked" + _kNameLastChangedProp + _kExecuteKey + _bOnRecalc+vecMoved.bIsZeroLength()+ _Map.getInt("Locked"));
	
	if (bDebug)
		dpText.draw(scriptName() + " ("+_Entity.length()+")\nStack: " + stack.bIsValid() + " packs: "+packs.length(), ptRef, _XW, _YW, 0, 0, _kDevice);
//endregion

//region Grip Managment #GM
	//if (bDebug || _bOnRecalc)_Grip.setLength(0);

	//region Create Grip for plan and model view
	String kGripModel = "GripModel";
	int nGripModel = GetGripByName(_Grip,kGripModel);
	if (nGripModel<0)
	{ 
		Vector3d hideDirections[] ={vecZ, -vecZ }, viewDirections[] = { };// give only one or the other
		Grip grip = CreateGrip(ptRef, _kGSTDiamond, kGripModel, vecX, vecZ, 4, T("|Moves the location of the spacers|"), viewDirections, hideDirections);
		_Grip.append(grip);
		nGripModel = _Grip.length() - 1;
		//reportNotice("\nGrip is at " + grip.ptLoc());
		_PtG.setLength(0);
	}
	else
	{
		if (_kNameLastChangedProp==sAlignmentName)
		{
			_Grip[nGripModel].setColor(bIsHorizontal ? 40 : 4);
			_Grip[nGripModel].setShapeType(bIsHorizontal ?_kGSTStar:_kGSTDiamond);
		}
		ptRef = _Grip[nGripModel].ptLoc();
	}
	//endregion 

	//region Create Grip for sectional view
	String kGripSection = "GripSection";
	int nGripSection = GetGripByName(_Grip, kGripSection);
	
	if (nGripSection<0)
	{ 
		Vector3d hideDirections[]= { }, viewDirections[] = {vecZ, - vecZ}; // give only one or the other
		Grip grip = CreateGrip(ptRef, _kGSTStar, kGripSection, vecX, vecY, 40, T("|Moves the location of the spacers|"), viewDirections,hideDirections);
		_Grip.append(grip);
		nGripSection = _Grip.length() - 1;
		//reportNotice("\nGrip is at " + grip.ptLoc());	
	}
	else if (_kNameLastChangedProp==sAlignmentName)
	{
		_Grip[nGripSection].setColor(bIsHorizontal ? 4 : 40);
		_Grip[nGripSection].setShapeType(bIsHorizontal ? _kGSTDiamond : _kGSTStar);
	}//endregion 

	vecY.vis(ptRef, 3);
	vecZ.vis(ptRef, 150);
	
	
	//reportNotice("\nHandle: " + this.handle() + "Grips("+_Grip.length()+") ptRef " + ptRef + "\n_Pt0 " + _Pt0 + "\n");


	Grip grip;
	Vector3d vecApplied;

	if (indexOfMovedGrip>-1)
	{
		grip = _Grip[indexOfMovedGrip];
		vecApplied = grip.vecOffsetApplied();
		
	// transform all locations grips
		if ((indexOfMovedGrip==nGripModel || indexOfMovedGrip==nGripSection))
		{ 
			if (bOnDragEnd)
			{
				ptRef = grip.ptLoc();
				
				if(indexOfMovedGrip==nGripSection)
				{ 
					Point3d ptModel = _Grip[nGripModel].ptLoc();
					ptModel += vecX * vecX.dotProduct(ptRef - ptModel);
					_Grip[nGripModel].setPtLoc(ptModel);					
				}
	
			}
			else if (bDrag)
				ptRef = grip.ptLoc();			
		}
	}

	//dpText.draw(PLine(_PtW, _Pt0, _Grip[nGripModel].ptLoc()));
//endregion 	
	
//region Loop packs
		
	Map mapSpacers;
	int bCollectParentSpacer = sRelation != tRPackItems;
	PlaneProfile ppSpacers[0];
	PlaneProfile ppPacks[0]; Body bdPacks[0];
	for (int p=0;p<packs.length();p++) 
	{ 
		
		Map mapParent;
		
		TslInst pack= packs[p]; 
		double dPackSpacerHeight = pack.propDouble(tSpacerHeightName);
		
		TslInst items[]=FilterTslsByName(pack.entity(), kScriptItem);	
		mapParent.setEntity("parent", pack);
		
		Body bodies[]=GetBodies(items);

		PLine plHull;
		PlaneProfile ppShadows[]=GetShadows(bodies, plHull, vecZ);
	
		PlaneProfile ppRange(cs);
		ppRange.joinRing(plHull, _kAdd);
		
		PlaneProfile ppShadow(cs);
		GetUnionProfile(ppShadow, ppShadows);
		
	//region Pack Bottom: Append pack botoom profile to obtain first spacer between at bottom of pack
		Body bdPackBottom;
		if (bCollectParentSpacer && bIsHorizontal && dPackSpacerHeight>dEps)
		{ 
		// get a body representing the bottom of the pack
			Map m = pack.map();
			PlaneProfile ppShapeZ = m.getPlaneProfile("ShapeZ");
			
			ppShapeZ.transformBy(-_ZW * dPackSpacerHeight);// spacer height
			//{Display dpx(4); dpx.draw(ppShapeZ, _kDrawFilled,20);}
			
			PLine rings[] = ppShapeZ.allRings(true, false);
			for (int r=0;r<rings.length();r++) 
			{ 
				bdPackBottom.addPart(Body(rings[r], _ZW*U(10),-1)); 
				//bdPackBottom.vis(3); 
			}//next r
			

			PlaneProfile pp = bdPackBottom.shadowProfile(Plane(ptRef, vecZ));
			ppShadow.unionWith(pp);

			bodies.append(bdPackBottom);
			ppShadows.append(pp);

		}//endregion 

		//{Display dpx(p+1); dpx.draw(ppShadow, _kDrawFilled,60);}
		//{Display dpx(p+1); dpx.draw(PlaneProfile(plHull), _kDrawFilled,60);}
		
		PlaneProfile pps[] = GetRangesAtPoint(ppShadow, ptRef, dWidth);
		if (sRelation != tRPack2Pack)
		{
			Body bdSpacers[] = GetSpacerProfiles(cs,ppSpacers, pps,ppShadows, bodies, true, dWidth, dLength);
			Map mapBodies = SetBodyArray(bdSpacers, "body");
			mapParent.setMap("Body[]", mapBodies);
		}
		mapSpacers.appendMap("Parent", mapParent);
		
		if (!bCollectParentSpacer){continue;}
		
	// Collect the relevant pack body for pack spacers	
		//{Display dpx(p); dpx.draw(PlaneProfile(ppShadow), _kDrawFilled,20);}
		
		Point3d pts[] = ppShadow.intersectPoints(Plane(ptRef, vecX), true, false);
		pts = Line(ptRef, vecY).orderPoints(pts, dEps);
		
		Body bdPack;
		if (pts.length()>0)
		{ 
			//PLine (pts.first(), pts.last()).vis(2);
			for (int i=0;i<bodies.length();i++) 
			{ 
				Point3d ptsX[]= bodies[i].extremeVertices(vecY); 
				
				if (ptsX.length()>0)
				{ 
//					if (p==1)
//						PLine (_PtW, ptsX[0], ptsX[1],_PtW).vis(6);
					double d0 = abs(vecY.dotProduct(ptsX.first() - pts.first()));
					double d1 = abs(vecY.dotProduct(ptsX.first() - pts.last()));
					double d2 = abs(vecY.dotProduct(ptsX.last() - pts.first()));
					double d3 = abs(vecY.dotProduct(ptsX.last() - pts.last()));
					if (d0<=dEps || d1<=dEps || d2<=dEps || d3<=dEps)
					{ 
						bdPack.addPart(bodies[i]);
					}
				}
				
			}//next i
			
		}
		
		//if (bDebug){Display dpx(1); dpx.draw(bdPack.shadowProfile(Plane(bdPack.ptCen(), vecZView)), _kDrawFilled,20);}
		
		bdPacks.append(bdPack);
		ppPacks.append(ppShadow);
		
	}//next p	
//endregion 	

//region Append loose items to be considered in P2P
	if (sRelation!=tRPackItems && stack.bIsValid())	
	{ 
		TslInst items[] = FilterTslsByName(stack.entity(), kScriptItem);
		
		for (int i=0;i<items.length();i++) 
		{ 
			Body bd = items[i].realBody();
			if (!bd.isNull())
			{ 
				PlaneProfile pp = bd.shadowProfile(Plane(bd.ptCen(), vecZ));
				bdPacks.append(bd);
				ppPacks.append(pp);
			}	 
		}//next i
	}
//endregion 

//region Collect Pack Spacers
	if (ppPacks.length()>1)
	{ 
		PlaneProfile ppShadow(cs);

		
	//region Stack Side: Append stack side profiles to obtain spacers towards side of stack/container
		//int bHasOversize = td.bIsValid() && (td.allowedOversize(_kYP) > dEps || td.allowedOversize(_kYN) > dEps);
		// TODO get dOversizes from stack
	
		if (bCollectParentSpacer && !bIsHorizontal && stack.bIsValid())
		{ 
		// get a body representing the bottom of the pack
			Map m = stack.map();
			PlaneProfile ppShape = vecY.isParallelTo(_YW)?m.getPlaneProfile("ShapeY"):m.getPlaneProfile("ShapeX");
			PlaneProfile ppShapeZ =m.getPlaneProfile("ShapeZ");
//			{Display dpx(4); dpx.draw(ppShape, _kDrawFilled,20);}
//			
			PLine rings[] = ppShape.allRings(true, false);
			for (int r=0;r<rings.length();r++) 
			{
				Body bd1(rings[r], ppShape.coordSys().vecZ() * U(20), -1);
				bd1.transformBy(vecY * .5 * ppShapeZ.dY());
				bd1.vis(211);
				
				PlaneProfile pp1 = bd1.shadowProfile(Plane(ptRef, vecZ));
				bdPacks.append(bd1);
				ppPacks.append(pp1);	
//				ppShadow.unionWith(pp1);

				Body bd2(rings[r], ppShape.coordSys().vecZ() * U(20), 1);
				bd2.transformBy(-vecY * .5 * ppShapeZ.dY());
				bd2.vis(211);
				
				PlaneProfile pp2 = bd2.shadowProfile(Plane(ptRef, vecZ));
				bdPacks.append(bd2);
				ppPacks.append(pp2);
//				pp2.shrink(-dEps);
//				ppShadow.shrink(-dEps);
//				ppShadow.unionWith(pp2);
//				ppShadow.shrink(dEps);
				//bdPackBottom.vis(3); 
			}//next r


		}//endregion 

		
		GetUnionProfile(ppShadow, ppPacks);
		//{Display dpx(40); dpx.draw(ppShadow, _kDrawFilled,20);}
		
		
		PlaneProfile pps[] = GetRangesAtPoint(ppShadow, ptRef, dWidth);
		Body bdSpacers[] = GetSpacerProfiles(cs,ppSpacers, pps,ppPacks, bdPacks, false, dWidth, dLength);	
		Map mapBodies = SetBodyArray(bdSpacers, "body");
		Map mapParent;
		mapParent.setEntity("Parent", stack);
		mapParent.setMap("Body[]", mapBodies);	
		mapSpacers.appendMap("Parent", mapParent);
	}
	
	
	
	
//endregion 

//region Validate Spacers
	if (ppSpacers.length()<1)
	{ 			
		if (bDrag)
		{
			PlaneProfile pp(CoordSys(ptRef, vecX, vecY, vecZ));
			DrawInvalidSymbol(pp);
		}
		else 
		{ 
			if (!bDebug)eraseInstance();
			return;
		}
	}		
//endregion 

//region Draw and Export
	HardWrComp hwcs[] = PurgeTslHwcs(_ThisInst.hardWrComps());
	PLine plAxes[0];
	for (int j=0;j<mapSpacers.length();j++) 
	{ 
		Map mapSpacer= mapSpacers.getMap(j);
		Map mapBodies = mapSpacer.getMap("Body[]");
		Entity parent = mapSpacer.getEntity("parent");
		TslInst t = (TslInst)parent;
		Body bdSpacers[] = GetBodyArray(mapBodies);
		String tag = t.formatObject("@(ScriptName:D) @(" + T("|Number|") + ":D:PL3;0)");
		
		HardWrComp hwcsAdd[0];

		for (int i=0;i<bdSpacers.length();i++) 
		{ 
			Body bd = bdSpacers[i];
			dpModel.draw(bd);
			
			double dW = round(bd.lengthInDirection(vecX));
			double dH = round(bd.lengthInDirection(vecY));
			double dL = round(bd.lengthInDirection(vecZ));

			Point3d ptCen = bd.ptCen();
			Point3d pt1 = ptCen - .5 * (vecX * dW + vecY * dH);
			Point3d pt2 = ptCen + .5 * (vecX * dW + vecY * dH);
			Point3d pt3 = ptCen - .5 * (vecX * dW - vecY * dH);
			Point3d pt4 = ptCen + .5 * (vecX * dW - vecY * dH);
			
			PLine plAxis(ptCen - vecZ * (.5 * dL +textHeight), ptCen + vecZ * (.5 * dL +textHeight));
			plAxis.vis(6);
			
			plAxes.append(plAxis);
			
		// draw cross section symbol	
			PLine pl(pt1, pt2, ptCen, pt4);
			pl.addVertex(pt3);
			pl.transformBy(vecZ * .5 * dL);
			dpModel.draw(pl);
			pl.transformBy(-vecZ *dL);
			dpModel.draw(pl);

		// HWC Export
			Map mapAdd;
			mapAdd.setDouble("dW", dW,_kLength);
			mapAdd.setDouble("dH", dH,_kLength);
			mapAdd.setDouble("dL", dL,_kLength);
			
			String articleNumber = this.formatObject(tag + " @(dW:RL0:PL5;0)x@(dH:RL0:PL5;0)x@(dL:RL0:PL5;0)", mapAdd);
			HardWrComp hwc(articleNumber, 1);
			hwc.setDScaleX(dL);
			hwc.setDScaleY(dW);
			hwc.setDScaleZ(dH);
			hwc.setDescription(tag);
			hwc.setRepType(_kRTTsl);
			hwc.setCategory("StackSpacer");
			hwc.setLinkedEntity(parent);
			hwcsAdd.append(hwc);
			

		}//next i
		SummarizeHwcs(hwcs, hwcsAdd);			 
	}//next j
	if (_bOnDbCreated)	setExecutionLoops(2);				
	this.setHardWrComps(hwcs);	
//endregion 




//region Grip Managment #GM
	//Grip CreateGrip(Point3d ptLoc, int shapeType, String name, Vector3d vecX, Vector3d vecY, int color, String toolTip, Vector3d viewDirections[])
	
//	Point3d ptLocPlan = ptRef, ptLocModel = ptRef;
//
//	if (nGripSection>-1)
//	{ 
//		Point3d pt1 = _Grip[nGripSection].ptLoc()+vecMoved;
//		Point3d pt2 = SnapToClosestAxis(plAxes, pt1+vecApplied, vecY);
//		if ((pt1-pt2).length()>dEps && bOnDragEnd)
//			_Grip[nGripSection].setPtLoc(pt2);
//	}
//
	if (_Grip.length()>0 && !bDrag) 
	{ 
		int index = bIsHorizontal ? nGripModel:nGripSection;
		Grip& grip = _Grip[index];
		Point3d pt1 = grip.ptLoc();
		Point3d pt2 = SnapToClosestAxis(plAxes, pt1, vecY);//+vecApplied
		
		pt1.vis(1);
		pt2.vis(2);
		
		
		
		if (vecY.dotProduct(pt1-pt2)>dEps)// && bOnDragEnd)
		{
			//reportNotice("\npt1 vs pt2 " +indexOfMovedGrip  + " "+grip.name() + " "+ pt1 + " " + pt2);
			grip.setPtLoc(pt2);
		}
	}			

//endregion 

//region Trigger AddItems
	String sTriggerAppend =  T("|Add Stack and/or Packs|");
	if(sRelation==tRPackItems)
	{
		addRecalcTrigger(_kContextRoot, sTriggerAppend );
	}
	if (_bOnRecalc && _kExecuteKey==sTriggerAppend)
	{
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select stack and/or packs|"), TslInst());
		if (ssE.go())
			ents.append(ssE.set());

		String names[] = { kScriptPack, kScriptStack};
		TslInst parents[] = FilterTslsByName(ents, names);
		for (int i=0;i<parents.length();i++) 
			_Entity.append(parents[i]); 
		
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RemovePacks
	String sTriggerRemovePacks = T("|Remove Packs|");
	if (packs.length()>1)addRecalcTrigger(_kContextRoot, sTriggerRemovePacks );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemovePacks)
	{
		
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select packs|"), TslInst());
		if (ssE.go())
			ents.append(ssE.set());
		
		for (int i=0;i<ents.length();i++) 
		{ 
			int n = packs.find(ents[i]);
			if (n<0){ continue;}
			n = _Entity.find(ents[i]);
			if (n>-1)
				_Entity.removeAt(n);
			 
		}//next i

		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RemoveStack
	String sTriggerRemoveStack = T("|Remove Stack|");
	if (stack.bIsValid())addRecalcTrigger(_kContextRoot, sTriggerRemoveStack );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveStack)
	{
		int n = _Entity.find(stack);
		if (n>-1)
			_Entity.removeAt(n);
		setExecutionLoops(2);
		return;
	}//endregion	






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
        <int nm="BreakPoint" vl="305" />
        <int nm="BreakPoint" vl="310" />
        <int nm="BreakPoint" vl="1834" />
        <int nm="BreakPoint" vl="873" />
        <int nm="BreakPoint" vl="1574" />
        <int nm="BreakPoint" vl="1811" />
        <int nm="BreakPoint" vl="1789" />
        <int nm="BreakPoint" vl="1730" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23372 fully supporting new behaviour of controlling properties" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="2/12/2025 2:02:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21733 bugfix position vertical spacers when using fixed length" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="11/29/2024 8:58:40 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21733 complete revision, NOT compatible with previous releases, supports horizontal and vertical spacers" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="11/22/2024 4:13:56 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End