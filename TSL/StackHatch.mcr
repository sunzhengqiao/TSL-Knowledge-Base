#Version 8
#BeginDescription
#Versions
Version 1.3 09.01.2025 HSB-22814 tolerance of orthogonal faces increased. hidden surface removal improved
Version 1.2 11.12.2024 HSB-22814 hidden surface removal further improved, color index property visible on insert
Version 1.1 05.12.2024 HSB-22814 hidden surface removal and perfomance improved, color rule added
Version 1.0 28.11.2024 HSB-22814 initial version


This tsl creates hatchings on shopdrawings



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords Stacking
#BeginContents
//region Part #1
		

//region <History>
// #Versions
// 1.3 09.01.2025 HSB-22814 tolerance of orthogonal faces increased. hidden surface removal improved , Author Thorsten Huck
// 1.2 11.12.2024 HSB-22814 hidden surface removal further improved, color index property visible on insert , Author Thorsten Huck
// 1.1 05.12.2024 HSB-22814 hidden surface removal and perfomance improved, color rule added , Author Thorsten Huck
// 1.0 28.11.2024 HSB-22814 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select multipages or add to block space
/// </insert>

// <summary Lang=en>
// This tsl creates hatchings on shopdrawings
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "StackHatch")) TSLCONTENT
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

	String kPainterCollection ="Shopdrawing\\Stacking\\" ;
	String tDisabled = T("<|Disabled|>");
	String kScriptStack = "StackEntity", kScriptPack = "StackPack",  kScriptItem = "StackItem", kScriptSpacer= "StackSpacer";
//end Constants //endregion
		
//End Part #1 //endregion 

//region Functions //#Fu

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

//region Function CollectShopdrawViews
	// returns all ShopDrawViews
	ShopDrawView[] CollectShopdrawViews(Entity ents[])
	{ 
		ShopDrawView sdvs[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			ShopDrawView sdv = (ShopDrawView)ents[i]; 
			if (sdv.bIsValid()) 
				sdvs.append(sdv);	
		}		
		return sdvs;
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

//region Function PurgeProfiles
	// removes planeprofiles which are perpendicular or negative to view diretcion
	void PurgeProfiles(PlaneProfile& pps[], Vector3d vecView)
	{ 
		for (int i=pps.length()-1; i>=0 ; i--) 
		{ 
			Vector3d vecZ = pps[i].coordSys().vecZ();
			
			
		
			
			if (vecZ.isPerpendicularTo(vecView) || abs(vecZ.dotProduct(vecView))<0.001)
			{
				//vecZ.vis(pps[i].ptMid(), 1);
				pps.removeAt(i);
			}

			
//			else
//			{ 
//				{Display dpx(i); dpx.draw(pps[i], _kDrawFilled,50);}
//			}
		}//next i

		return;
	}//endregion


//region Function HasIntersectingVertices
	// returns true if any of the vertices of pp2 is within the projection of pp1
	int HasIntersectingVertices(PlaneProfile pp1, PlaneProfile pp2)
	{ 
		CoordSys cs1 = pp1.coordSys();
		Vector3d vecZ = cs1.vecZ();
		Plane pn(cs1.ptOrg(), vecZ);
		
		int bHasIntersection;
		Point3d pts[] = pp2.getGripVertexPoints();
		for (int i=0;i<pts.length();i++) 
		{ 
			if (Line(pts[i],_ZW).hasIntersection(pn, pts[i]) && pp1.pointInProfile(pts[i])==_kPointInProfile)
			{ 
				bHasIntersection = true;
				break;
			}
			 
		}//next i		
		return bHasIntersection;
	}//endregion

//region Function RemoveHiddenPlaneProfiles
	// subtacts the parts of a planeprofile which is behind any other
	void RemoveHiddenPlaneProfiles(PlaneProfile& pps[],int& indices[], Vector3d vecView, int bIsOrtho, int bHasEntitiesOfStack)//#RHidden
	{ 
	// order by elevation	
		if (bIsOrtho)
		{ 
			double elevations[0];
			for (int i=0;i<pps.length();i++) 
				elevations.append(pps[i].coordSys().ptOrg().Z());
		
		// order by elevation
			for (int i=0;i<pps.length();i++) 
				for (int j=0;j<pps.length()-1-1;j++) 
					if (elevations[j]>elevations[j+1])
					{ 
						indices.swap(j, j + 1);
						elevations.swap(j, j + 1);
						pps.swap(j, j + 1);
					}
			
//			for (int i=0;i<pps.length();i++) 
//				{Display dpx(i+1); dpx.draw(pps[i], _kDrawFilled,40);}			
		}
	
		
//		PlaneProfile ppOpenings[0];
//		int nOpIndices[0];
//		for (int i=0;i<pps.length();i++)
//		{ 
//			CoordSys cs = pps[i].coordSys();
//			PLine rings[] = pps[i].allRings(false, true);
//			for (int r=0;r<rings.length();r++) 
//			{ 
//				PlaneProfile pp(cs);
//				pp.joinRing(rings[r], _kAdd);
//				ppOpenings.append(pp);	
//				nOpIndices.append(i);
//			}//next r	
//		}
		
		
//		double areas[0];
//		for (int i=0;i<pps.length();i++) 
//			areas.append(pps[i].area());
//	// order byArea
//		for (int i=0;i<pps.length();i++) 
//			for (int j=0;j<pps.length()-1-1;j++) 
//				if (areas[j]<areas[j+1])
//				{ 
//					indices.swap(j, j + 1);
//					areas.swap(j, j + 1);
//					pps.swap(j, j + 1);
//				}

		
		for (int i=pps.length()-1; i>=0 ; i--) 
		{ 
			PlaneProfile& pp1=pps[i];
			CoordSys cs1 = pp1.coordSys();
			Vector3d vecZ = cs1.vecZ();
			Plane pn(cs1.ptOrg(), vecZ);
			
			//{Display dpx(i+1); dpx.draw(pp1, _kDrawFilled,20);}
			//pp1.vis(i+1);
			
			int nRemove=-1;
			for (int j=0;j<pps.length();j++) 
			{ 
				if (i==j){ continue;}
				
				PlaneProfile& pp2=pps[j];
				
				// simplified intersection test (genbeam etc)
				if (!bHasEntitiesOfStack && !HasIntersectingVertices(pp1,pp2))
				{ 
					//pp2.vis(6);					
					continue;
				}
				//pp2.vis(2);
				
				
				CoordSys cs2 = pp2.coordSys();
				Plane pn2(cs2.ptOrg(), cs2.vecZ());
				int b2IsParallelZ = cs2.vecZ().isParallelTo(_ZW);
				PlaneProfile pp2i = pp2;
				if (!b2IsParallelZ)
					pp2i.project(pn, vecView, dEps);
				
				//if (HasIntersectingVertices(pp1,pp2i))
				if (pp2i.intersectWith(pp1))
				{ 
					//pp2i.intersectWith(pp1);
					Point3d pt2 = pp2i.ptMid();
					Point3d pt1 = pt2;
					Line(pt2, vecView).hasIntersection(pn2, pt2);
					
					double dZ = vecView.dotProduct(pt2 - pt1);
					
				// 2 is above 1	
					if (dZ>0)
					{ 
//						{Display dpx(4); dpx.draw(pp1, _kDrawFilled,60);}
//						{Display dpx(1); dpx.draw(pp2i, _kDrawFilled,20);}
						pp1.subtractProfile(pp2i);
						if (pp1.area()<pow(dEps,2))
						{ 
							nRemove = i;
							break;
						}						
					}
				// 1 is above 2	
					else
					{ 
						if (!b2IsParallelZ)
							pp2i.project(pn2, vecView, dEps);
						pp2.subtractProfile(pp2i);						
						if (pp2.area()<pow(dEps,2))
						{ 
							nRemove = j;
							break;
						}							
					}
				}
			}
			if (nRemove>-1)
			{
				if(bDebug)pps[nRemove].vis(6);
				pps.removeAt(nRemove);
				indices.removeAt(nRemove);
			}

		}// next i
	
		if (bDebug)
			for (int i=0;i<pps.length();i++)
			{
				pps[i].vis(i);
			}

		return;
	}//endregion		

//region Function AppendEntities
	// appends entities to an existing array checking for duplicates
	void AppendTslEntities(Entity& ents[], TslInst tsls[])
	{ 
		for (int i=0;i<tsls.length();i++) 
		{
			Entity e = tsls[i];
			if (ents.find(e)<0)
				ents.append(e);			
		}
		return;
	}//endregion

//region Function AppendTsls
	// appends entities to an existing array checking for duplicates
	void AppendTsls(TslInst& tsls[], TslInst tslsAdd[])
	{ 
		for (int i=0;i<tslsAdd.length();i++) 
		{
			TslInst t = tslsAdd[i];
			if (tsls.find(t)<0)
				tsls.append(t);			
		}
		return;
	}//endregion	

//region Function CollectCollectionPainters
	// returns all painters of a specific folder / collection, if folder not given return all
	String[] CollectCollectionPainters(String folder)
	{ 
		String painters[] = PainterDefinition().getAllEntryNames().sorted();
		if (folder.length()>0)			
			for (int i=painters.length()-1; i>=0 ; i--) 
				if (painters[i].find(folder,0,false)<0)
					painters.removeAt(i);				
		return painters;
	}//endregion

//region Function PurgeFolderName
	// returns a map which can be consumed by a comboBox of the dialog service
	// values[]: an array of strings
	// folder: an optional folder to be removed
	String[] PurgeFolderName(String values[], String folder)
	{ 
		String out[0];
		for (int i=0;i<values.length();i++) 
		{
			String value = values[i];
			value.replace(folder, "");
			if (value.length()>0 && out.findNoCase(value,-1)<0)
				out.append(value);	 	
		}
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

//region Function FilterTslsByName
	// returns all tsl instances with the given scriptname
	// ents: the array to search, if empty all tsls in modelspace are taken
	// name: the name of the tsl to be returned, all if empty
	TslInst[] FilterTslsByName(Entity ents[], String& nameX)
	{ 
		TslInst out[0];
		
		String names[0];
		if (nameX.length()>0)
			names.append(nameX);
			
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

//region Function GetPacks
	// returns the items of the parent stackXX
	TslInst[] GetPacks(TslInst parents[])
	{ 
		TslInst packs[0];
		
		for (int i=0;i<parents.length();i++) 
		{ 
			Entity ents[] = parents[i].entity();
			TslInst _packs[]=FilterTslsByName(ents, kScriptPack);
			for (int j=0;j<_packs.length();j++) 
				if(packs.find(_packs[j])<0)
					packs.append(_packs[j]); 
		}//next i

		return packs;
	}//endregion

//region Function GetItems
	// returns the items of the parent stackXX
	TslInst[] GetItems(TslInst parents[])
	{ 
		TslInst items[0];
		
		for (int i=0;i<parents.length();i++) 
		{ 
			Entity ents[] = parents[i].entity();
			TslInst packs[]=FilterTslsByName(ents, kScriptPack);
			for (int p=0;p<packs.length();p++)
			{ 
				TslInst _items[]=FilterTslsByName(packs[p].entity(), kScriptItem);
				for (int j=0;j<_items.length();j++) 
					if(items.find(_items[j])<0)
						items.append(_items[j]);
			}
			TslInst _items[]=FilterTslsByName(ents, kScriptItem);
			for (int j=0;j<_items.length();j++) 
					if(items.find(_items[j])<0)
						items.append(_items[j]);
		}//next i

		return items;
	}//endregion


//region Function GetGenBeamBody
	// returns the body of the genbeam by shapeMode
	Body GetGenBeamBody(GenBeam genbeam,int shapeMode)
	{ 
		GenBeam g = genbeam;
		Body bd;
		if (shapeMode == 1)bd =g.envelopeBody(false,true);
		else if (shapeMode == 2)bd =g.envelopeBody(true,true);
		else if (shapeMode == 3){bd =g.envelopeBody();}
		else bd =g.realBody();
		return bd;
	}//End GetGenBeamBody //endregion	

//region Function GetMetalPartBody // HSB-23088
	// returns the body of the metalpart by shapeMode
	Body GetMetalPartBody(MetalPartCollectionEnt ce, int shapeMode, PainterDefinition pd)
	{ 
		Body out;
		
		if (shapeMode<1)
			return ce.realBodyTry();
		
		
		MetalPartCollectionDef cd = ce.definitionObject();
		CoordSys cs = ce.coordSys();
		
	// get from genbeam	
		GenBeam gbs[] = cd.genBeam();
		if (pd.bIsValid())gbs = pd.filterAcceptedEntities(gbs);
		
		for (int i=0;i<gbs.length();i++) 
		{ 
			Body bd;
			GenBeam g = gbs[i];
			if (g.bIsDummy())continue;
			bd = GetGenBeamBody(g, shapeMode );		
			
			if (!bd.isNull())
			{
				bd.transformBy(cs);
				out.combine(bd);
			}
		}//next i

	// get from entity
		Entity ents[] = cd.entity();
		if (pd.bIsValid())ents = pd.filterAcceptedEntities(ents);
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity e= ents[i]; 
			if (gbs.find(e)>-1){ continue;}
			
			Body bd;
			GenBeam g = (GenBeam)e;
			MetalPartCollectionEnt ce2 = (MetalPartCollectionEnt)e;
			if (g.bIsValid())
			{ 
				if (g.bIsDummy())continue;
				bd = GetGenBeamBody(g, shapeMode );					
			}
			else if (ce2.bIsValid())
			{ 
				bd = GetMetalPartBody(ce2, shapeMode, pd );					
			}			
			else
				bd = e.realBodyTry();
			
			if (!bd.isNull())
			{
				bd.transformBy(cs);
				out.combine(bd);
			}
		}//next i

		return out;
	}//endregion
	
//region Function GetBlockRefBody
	// returns
	Body GetBlockRefBody(BlockRef bref, int shapeMode, PainterDefinition pd)
	{ 
		Body out;
		
		if (shapeMode<1)
			return bref.realBodyTry();
		
		
		Block block(bref.definition());
		CoordSys cs = bref.coordSys();
		
	// get from genbeam	
		GenBeam gbs[] = block.genBeam();
		if (pd.bIsValid())gbs = pd.filterAcceptedEntities(gbs);
		
		for (int i=0;i<gbs.length();i++) 
		{ 
			Body bd;
			GenBeam g = gbs[i];
			if (g.bIsDummy())continue;
			bd = GetGenBeamBody(g, shapeMode );		
			
			if (!bd.isNull())
			{
				bd.transformBy(cs);
				out.combine(bd);
			}
		}//next i

	// get from entity
		Entity ents[] = block.entity();
		if (pd.bIsValid())ents = pd.filterAcceptedEntities(ents);
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity e= ents[i]; 
			if (gbs.find(e)>-1){ continue;}
			
			Body bd;
			GenBeam g = (GenBeam)e;
			MetalPartCollectionEnt ce2 = (MetalPartCollectionEnt)e;
			if (g.bIsValid())
			{ 
				if (g.bIsDummy())continue;
				bd = GetGenBeamBody(g, shapeMode );					
			}
			else if (ce2.bIsValid())
			{ 
				bd = GetMetalPartBody(ce2, shapeMode, pd );					
			}			
			else
				bd = e.realBodyTry();
			
			if (!bd.isNull())
			{
				bd.transformBy(cs);
				out.combine(bd);
			}
		}//next i

		return out;
	}//endregion


//region Function GetSimpleBody
	// returns a simplified body of an entity
	Body GetSimpleBody(Entity ent, int shapeMode)
	{ 
		Body bd;
	
		GenBeam gb = (GenBeam)ent;
		MetalPartCollectionEnt ce = (MetalPartCollectionEnt)ent;
		BlockRef bref = (BlockRef)ent;
		TslInst tsl= (TslInst)ent;
		if (gb.bIsValid())
			bd = GetGenBeamBody(gb, 0);//shapeMode
		else if (ce.bIsValid())
		{ 
			bd = GetMetalPartBody(ce, shapeMode, PainterDefinition());//
		}			
		else if (bref.bIsValid())
		{ 
			bd = GetBlockRefBody(bref, shapeMode, PainterDefinition());
		}
		else if (tsl.bIsValid() && tsl.scriptName().find("Stack",0,false)==0)
			bd = ent.realBody(_XW+_YW+_ZW);
			
		if (bd.isNull())
		{ 
			Quader q = ent.bodyExtents();
			if (q.dX()<=dEps || q.dY()<=dEps || q.dZ()<=dEps)
				bd = ent.realBody(_XW+_YW+_ZW);
			else
				bd = Body(q.pointAt(0, 0, 0), q.vecX(), q.vecY(), q.vecZ(), q.dX(), q.dY(), q.dZ(), 0, 0, 0);
		}		
		return bd;
	}//endregion

//region Function GetBodies
	// returns a sync array of realbodies
	Body[] GetBodies(Entity ents[])
	{ 
		Body bodies[0];
		
	// Collect bodies of showset		
		for (int i = 0; i < ents.length(); i++)
		{
			Entity ent = ents[i];
			
			Body bd = GetSimpleBody(ent, 3);//envelope(true,true)

			//Body bd = ent.realBody(_XW+_YW+_ZW);
			bodies.append(bd);
		}
		
		return bodies;
	}//endregion
	
//region MultipageView Functions
		

//region Function FindClosestView
	// returns the view with the closest origin
	MultiPageView FindClosestView(Point3d ptRef, MultiPage page, PlaneProfile& ppView)
	{ 
		ptRef.setZ(0);
		MultiPageView view,views[]=page.views();
		
		double dist = U(10e10);
		for (int i=0;i<views.length();i++) 
		{ 
			PlaneProfile pp(CoordSys());
			pp.joinRing(views[i].plShape(),_kAdd); 
			Point3d pt = pp.ptMid()-.5*(_XW*pp.dX()+_YW*pp.dY()); 
			
			double d = (pt - ptRef).length();
			if (d<dist)
			{ 
				dist = d;
				view = views[i];
				ppView = pp;
			}
		}//next i
		
		return view;
	}//endregion
	
//region Function GetViewPlaneProfiles
	// returns the view with the closest origin
	PlaneProfile[] GetViewPlaneProfiles(MultiPage page)
	{ 
		PlaneProfile pps[0];
		MultiPageView views[]=page.views();

		for (int i=0;i<views.length();i++) 
		{ 
			PlaneProfile pp(CoordSys());
			pp.joinRing(views[i].plShape(),_kAdd); 
			pps.append(pp);
		}//next i
		
		return pps;
	}//endregion	
		
	//End MultipageView Functions //endregion		
		
//region Draw Functions
		
//region Function DrawDrag
	// draws some graphics during drag
	void DrawDrag(PlaneProfile pps[], Point3d ptJig)
	{ 

	    Display dp(-1);
	    dp.trueColor(lightblue, 50);

	    double dMin = U(10e6);
	    int n;
	    for (int i=0;i<pps.length();i++) 
	    { 
	    	double d = (pps[i].closestPointTo(ptJig)-ptJig).length();
	    	if (d<dMin)
	    	{ 
	    		dMin = d;
	    		n = i;
	    	}	    	 
	    }//next i
	    for (int i=0;i<pps.length();i++)
	    { 
	    	dp.trueColor(n==i?darkyellow:lightblue, n==i?0:50);
	    	dp.draw(pps[i], _kDrawFilled);
	    }

		return;
	}//endregion		
			
	//End Draw Functions //endregion


//End Functions //endregion 

// Jig Insert
	String kJigInsert = "JigInsert";
	if (_bOnJig && _kExecuteKey==kJigInsert) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
		
	    PlaneProfile pps[] = GetPlaneProfileArray(_Map);
		if (pps.length()>0)
			ptJig.setZ(pps[0].coordSys().ptOrg().Z());
	    DrawDrag(pps, ptJig);

	    return;
	}
////endregion 


	int tick = getTickCount();
	//reportNotice("\n" + _ThisInst.handle() + " start: " + tick);

//region Part #2

//region Properties

	String tVByLocation= T("|View byLocation|"), tVAll = T("|All Views|"), tVOrtho= T("|Orthogonal Views|"), sViews[] = {tVByLocation,tVAll,tVOrtho };
	String sViewName=T("|View|");	
	PropString sView(0, sViews, sViewName);	
	sView.setDescription(T("|Defines the set of views where the hatching will be applied, byLocation = the viewport where the origin point is closest to the lower left corner.|"));
	sView.setCategory(category);
	if (sViews.findNoCase(sView ,- 1) < 0)sView.set(tVByLocation);

category = T("|Display|");

	String sPainters[] = CollectCollectionPainters(kPainterCollection);
	String sDisplayFilters[] = PurgeFolderName(sPainters, kPainterCollection);
	
	String tDefaultEntry= T("<|Default|>"),sDisplaySets[] ={tDefaultEntry};
	sDisplaySets.append(sDisplayFilters);
	
	String sDisplaySetName=T("|Display Set|");	
	PropString sDisplaySet(1, sDisplaySets, sDisplaySetName);	
	sDisplaySet.setDescription(T("|Specifies the set of entities that will be rendered.|") + 
		T("|The default setting will utilize the current showset of the view, but painters can further specify additional filters within the folder| '" + kPainterCollection + "'"));
	sDisplaySet.setCategory(category);
	if (sDisplayFilters.findNoCase(sDisplaySet ,- 1) < 0)sDisplaySet.set(tDefaultEntry);

	String tColorByParent = T("|byParent|"),tColorByIndex = T("|byColorIndex|"), sColors[] ={tDefaultEntry, tColorByParent,tColorByIndex};
	String sColorName=T("|Color Rule|");	
	PropString sColor(3, sColors, sColorName);	
	sColor.setDescription(T("|Defines the color of the objects.|") + T("|<Default> uses the color of the entity, byParent tries to find the parent (i.e. the pack of an item) to derive the color from.|"));
	sColor.setCategory(category);
	sColor.setControlsOtherProperties(true);

	String sColorIndexName=T("|Color|");	
	PropInt nColorIndex(2, -1, sColorIndexName);	
	nColorIndex.setDescription(T("|Defines the color index if color rule is set to| ")+tColorByIndex + T("|Any color index < 0 will set the color rule to| " + tDefaultEntry));
	nColorIndex.setCategory(category);
	nColorIndex.setReadOnly((bDebug || sColor == tColorByIndex || _bOnInsert) ? false : _kHidden);
	nColorIndex.setControlsOtherProperties(true);

	String sTransparencyName=T("|Transparency|");	
	PropInt nTransparency(0, 20, sTransparencyName);	
	nTransparency.setDescription(T("|Defines the Transparency|"));
	nTransparency.setCategory(category);
	
category = T("|Edges|");

	String sDrawEdgeName=T("|Draw Edges|");	
	PropString sDrawEdge(2, sNoYes, sDrawEdgeName,1);	
	sDrawEdge.setDescription(T("|Defines wether the edges of the faces shall be drawn|"));
	sDrawEdge.setCategory(category);
	sDrawEdge.setControlsOtherProperties(true);
	if (sNoYes.findNoCase(sDrawEdge ,- 1) < 0)sDrawEdge.set(sNoYes[1]);
	int bDrawEdge = sDrawEdge == sNoYes[1];
	
	String sColorEdgeName=T("|Color|");	
	PropInt nColorEdge(1, 252, sColorEdgeName);	
	nColorEdge.setDescription(T("|Defines the color of the edges, -1 = byEntity|"));
	nColorEdge.setCategory(category);
	nColorEdge.setReadOnly(bDebug || bDrawEdge ? false : _kHidden);
	
// TODO: simple offset gives different offset on single/duplex edges	
//	String sEdgeThicknessName=T("|Thickness|");	
//	PropDouble dEdgeThickness(nDoubleIndex++, U(0), sEdgeThicknessName);	
//	dEdgeThickness.setDescription(T("|Defines the thickness of the edge, 0 = byEntity|"));
//	dEdgeThickness.setCategory(category);
//	dEdgeThickness.setReadOnly(bDebug || bDrawEdge ? false : _kHidden);

	int nProps[]={nTransparency,nColorEdge,nColorIndex};			
	double dProps[]={};				String sProps[]={sView,sDisplaySet,sDrawEdge,sColor};
	
	
//End Properties//endregion 

//region OnInsert
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
			showDialog();
		
		int nProps[]={nTransparency,nColorEdge};			double dProps[]={};				String sProps[]={sView,sDisplaySet,sDrawEdge};
	
	// Detect space by content, find out if we are block space and have some shopdraw viewports
		int bInBlockSpace, bHasSDV;	
		Entity entsSDV[0];
		if (!bInLayoutTab)
		{
			entsSDV= Group().collectEntities(true, ShopDrawView(), _kAllSpaces);
		
		// shopdraw viewports found and no genbeams or multipages are found
			if (entsSDV.length()>0)
			{ 
				bHasSDV = true;
				Entity ents[]= Group().collectEntities(true, GenBeam(), _kAllSpaces);
				ents.append(Group().collectEntities(true, MultiPage(), _kAllSpaces));
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
				ssE = PrEntity(T("|Select shopdraw viewports|"), ShopDrawView());
			}	
			else if (bHasSDV)
			{ 
				ssE = PrEntity(T("|Select multipages or shopdraw viewports|"), ShopDrawView());
				ssE.addAllowedClass(MultiPage());
			}			
			else
			{
				ssE = PrEntity(T("|Select multipages|"), MultiPage());				
			}			
			//ssE.allowNested(true);
			
			if (ssE.go())
				ents.append(ssE.set());	


		}
		
	// Clone
		MultiPage pages[0];
		
		for (int i = 0; i < ents.length(); i++)
		{
			MultiPage page = (MultiPage)ents[i];
			if (page.bIsValid())
				pages.append(page);
		}
		
		Vector3d vecPage; // the translation from the origin if multiple pages are selected
		if (sView==tVByLocation && pages.length()>0)
		{ 
			MultiPage page = pages.first();
			
		//region PrPoint with Jig
			PrPoint ssP(T("|Select viewport|")); // second argument will set _PtBase in map
		    Map mapArgs;
		   	mapArgs = SetPlaneProfileArray(GetViewPlaneProfiles(page));
		   	int nGoJig = -1;
		    while (nGoJig != _kOk && nGoJig != _kNone)
		    {
		        nGoJig = ssP.goJig(kJigInsert, mapArgs); 
		        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
		        
		        if (nGoJig == _kOk)
		        {
		            Point3d ptPick = ssP.value(); //retrieve the selected point
		            vecPage = ptPick - page.coordSys().ptOrg();
		        }
		        else if (nGoJig == _kCancel)
		        { 
		            eraseInstance(); // do not insert this instance
		            return; 
		        }
		    }			
		//endregion 



		}
		for (int i=0;i<ents.length();i++) 
		{ 
			MultiPage page = (MultiPage)ents[i];
			ShopDrawView sdv = (ShopDrawView)ents[i];

			Point3d pt = _PtW;
			if (page.bIsValid())
				pt = page.coordSys().ptOrg() + vecPage;
		
		// create TSL
			TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {ents[i]};	Point3d ptsTsl[] = {pt};
			Map mapTsl;	
						
			tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
			
		}//next i

		eraseInstance();
		return;
	}			
//endregion 

//region Standards
	int bCreatedByBlockspace = _Map.getInt("BlockSpaceCreated");
	
	if (bCreatedByBlockspace) 
	{ 
		if (_Entity.length()<1) 
		{ 
			return; 
		}
		else
		{
			_Map.removeAt("BlockSpaceCreated", true);
		}		
	}	
	
	
	if (_Entity.length()<1)
	{ 
		reportNotice("\n" + T("|Invalid reference.|"));
		eraseInstance();
		return;
	}
	CoordSys cs();
	MultiPage page = (MultiPage)_Entity[0];
	ShopDrawView sdv = (ShopDrawView)_Entity[0];
	Plane pnW(_PtW, _ZW);
	Line lnZ(_PtW, _ZW);
	
	Entity showSet[0];
	Body bdShowSet[0];
	
	addRecalcTrigger(_kGripPointDrag, "_Pt0");
	int bDrag = _bOnGripPointDrag && _kExecuteKey == "_Pt0";		
	_ThisInst.setDrawOrderToFront(true);
	CoordSys ms2ps, ps2ms;
	
	int bViewByLocation = sView == tVByLocation;
	int bViewAll= sView == tVAll;
	int bViewOrtho= sView == tVOrtho;

	Display dp(-1),dpText(202);
	dpText.textHeight(U(100));
	
	PainterDefinition pd;
	if (sDisplaySet!=tDefaultEntry)
	{ 
		int n = sDisplayFilters.findNoCase(sDisplaySet ,- 1);
		pd=PainterDefinition (sPainters[n]);
		
	}	

//endregion 

//End Part #2 //endregion 

//region Block Mode // ShopDrawView  
	if (sdv.bIsValid())
	{ 
		
	// add shopdraw trigger
		addRecalcTrigger(_kShopDrawEvent, _kShopDrawViewDataShowSet );			
		
		ShopDrawView sdvs[]=CollectShopdrawViews(_Entity);
		PlaneProfile pps[] = GetShopdrawProfiles(sdvs);

	//region On Generate ShopDrawing
		if (_bOnGenerateShopDrawing)
		{ 
			int bLog=false;
			if (bLog)reportNotice("\nBlockSpaceCreation starting " + _bOnGenerateShopDrawing);
			
		// Get multipage from _Map
			Entity entCollector = _Map.getEntity(_kOnGenerateShopDrawing +"\\entCollector");
			Map mapTslCreatedFlags = entCollector.subMapX("mpTslCreatedFlags");
			String uid = _Map.getString("UID"); // get the UID from map as instance does not exist onGenerateShopDrawing
			int bIsCreated = mapTslCreatedFlags.hasInt(uid);

			if (!bIsCreated && entCollector.bIsValid())
			{
				if (bLog)reportNotice("\nBlockSpaceCreation for " + sdvs.length() + " views");
				
				for (int i = 0; i < sdvs.length(); i++)
				{ 
					ShopDrawView sdv = sdvs[i];
					Map mapX=sdv.subMapX("StackHatch");
					int nViewIndex = mapX.hasInt("viewIndex")?mapX.getInt("viewIndex"):-1;

					ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets, 0);
					int nIndFound = ViewData().findDataForViewport(viewDatas, sdv);//find the viewData for my view
					if (nIndFound < 0) { continue; }
					ViewData viewData = viewDatas[nIndFound];
					
//				// make sure the view refers to a genbeam	
//					GenBeam gb = GetDefiningGenBeam(viewData.showSetDefineEntities());
//					if (!gb.bIsValid()) { continue; }
					
				// Transformations
					CoordSys ms2ps = viewData.coordSys();
					CoordSys ps2ms = ms2ps;
					ps2ms.invert();					

				// create TSL
					TslInst tslNew;;
					GenBeam gbsTsl[] = {};		Entity entsTsl[] = {entCollector};			
					Map mapTsl;	
					mapTsl.setInt("BlockSpaceCreated", true);
					

					PlaneProfile pp = pps[i];
					double dX = pp.dX();
					double dY = pp.dY();
					Point3d ptsTsl[] = { pp.ptMid() - .5 * (_XW*dX+_YW*dY)}	;

					//mapTsl.setInt("BlockViewIndex", nViewIndex); // store the relative index of the shopdrawview to make sure only selected views will contribute once
					//mapTsl.setString("ViewHandle", viewData.viewHandle());
					tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			

					if (tslNew.bIsValid())
					{
						tslNew.transformBy(Vector3d(0, 0, 0));
						
					// flag entCollector such that on regenaration no additional instances will be created	
						if (!bIsCreated)
						{
							bIsCreated=true;
							mapTslCreatedFlags.setInt(uid, true);
							entCollector.setSubMapX("mpTslCreatedFlags",mapTslCreatedFlags);
						}
					}
					
					if (sView!=tVByLocation)
					{ 
						break;
					}


				}// next i
			}
		}
	//endregion 
	
	
	//region Block Space Display
		else
		{ 
			_Map.setString("UID", _ThisInst.uniqueId()); // store UID to have access during _kOnGenerateShopDrawing
			
			
			// Store the index of the viewport in relation to all viewports
			Entity viewEnts[]= Group().collectEntities(true, ShopDrawView(), _kMySpace);			
			for (int i=0;i<sdvs.length();i++) 
			{ 
				int n = viewEnts.find(sdvs[i]);
				Map mapX;
				mapX.setInt("viewIndex", n);
				sdvs[i].setSubMapX("StackHatch", mapX);				 
			}//next i
			
			
			String text = scriptName() + " " + T("|specifying stack hatches of selected views| (") + sdvs.length() + ")";
			text += "\n" + sDisplaySetName + ": "+sDisplaySet;
			
			Display dpJig(-1);
			dpJig.trueColor(darkyellow, 70);

				
			if (bDrag)
				for (int i=0;i<pps.length();i++) 
				{
					dpJig.draw(pps[i], _kDrawFilled);
					dpJig.draw(pps[i]);
				}
	
			dpText.draw(text, _Pt0, _XW, _YW, 1, -1);	
				
			
		// draw preview
			for (int i=0;i<pps.length();i++) 
			{ 
				PlaneProfile pp = pps[i];
				double dX = pp.dX();
				double dY = pp.dY();
				
				Point3d ptx = pp.ptMid()-.5*(_XW*dX+_YW*dY); 
				
				dY *= .1;
				PlaneProfile ppx; ppx.createRectangle(LineSeg(ptx, ptx + _XW * .8 * dX + _YW * dY), _XW, _YW);
				
				dpJig.trueColor(purple);
				
				for (int i=0;i<3;i++) 
				{ 
					
					if (nTransparency>0)
						dpJig.draw(ppx, _kDrawFilled, nTransparency);	
					else
						dpJig.draw(ppx, _kDrawFilled);					
	
					if (bDrawEdge)
					{ 
						dp.color(nColorEdge<0?_ThisInst.color():nColorEdge);
						dp.draw(ppx);
					}					
					
					ppx.transformBy(_YW * dY);
					dpJig.trueColor(i==0?orange:petrol);
				}//next i

			}
	

		//region Trigger
		// trigger set view
			String sSetViewTrigger = T("|Set View|");
			if (sView==tVByLocation)addRecalcTrigger(_kContextRoot, sSetViewTrigger );	
			if (_bOnRecalc && _kExecuteKey==sSetViewTrigger )
			{
				sdv = getShopDrawView();
				_Entity.setLength(0);
				_Entity.append(sdv);
				
				sdvs.setLength(0);
				sdvs.append(sdv);
				pps = GetShopdrawProfiles(sdvs);
			}		
		
		
		// trigger add view
			String sAddViewTrigger = T("|Add View|");
			if (sView!=tVByLocation)addRecalcTrigger(_kContextRoot, sAddViewTrigger );	
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
			}
		
		// trigger remove view
			String sRemoveViewTrigger = T("|Remove View|");
			if (sView!=tVByLocation)addRecalcTrigger(_kContextRoot, sRemoveViewTrigger );
			if (_bOnRecalc && _kExecuteKey==sRemoveViewTrigger )
			{
				ShopDrawView sdv = getShopDrawView();
				int n=_Entity.find(sdv);
				if (n>-1)
					_Entity.removeAt(n);
				setExecutionLoops(2);
			}
		//endregion	
			
			if((_kNameLastChangedProp=="_Pt0" ||_kExecuteKey==sSetViewTrigger || _kNameLastChangedProp==sViewName) && pps.length()>0)
			{
				_Pt0 = pps[0].ptMid()-.5*(_XW*pps[0].dX()+_YW*pps[0].dY()); 
				setExecutionLoops(2);
			}
			if (_kNameLastChangedProp==sViewName)
			{
				Entity entsSDV[] = Group().collectEntities(true, ShopDrawView(), _kMySpace);
				for (int i=0;i<entsSDV.length();i++) 
					entsSDV[i].removeSubMapX("StackHatch");				 

				if (sView==tVByLocation)
					_Entity.setLength(1);
				else
				{ 
					_Entity.append(entsSDV); 
				}
				setExecutionLoops(2);
			}
			
			
			return;
		}
	//endregion 

		dp.draw(scriptName(), _Pt0, _XW, _YW, 0, 0);
		return;
	}
//endregion 


//region Events
	if (_kNameLastChangedProp==sColorIndexName)
	{ 
		if (nColorIndex < 0 && sColor == tColorByIndex)
		{
			sColor.set(tDefaultEntry);
			setExecutionLoops(2);
			return;
		}
	}
	if (_kNameLastChangedProp==sColor)
	{ 
		if (nColorIndex >-1 && sColor != tColorByIndex)
		{
			nColorIndex.set(-1);
			setExecutionLoops(2);
			return;
		}
	}	
//endregion 






//region Page              
	if (page.bIsValid())
	{ 
//		_ThisInst.setDrawOrderToFront(false);
		setDependencyOnEntity(page);

	//region Keep Location when dragging page
		Point3d ptOrg = page.coordSys().ptOrg();
		Vector3d vecOrg = ptOrg - _PtW;		
		if (_Map.hasVector3d("vecOrg"))
		{ 
			Point3d ptPrevOrg = _Map.getVector3d("vecOrg");
			Vector3d vecPageMove = ptOrg - ptPrevOrg;
			if (!vecPageMove.bIsZeroLength())
			{ 
				_Pt0.transformBy(vecPageMove);
				_Map.setVector3d("vecOrg", vecOrg);
				setExecutionLoops(2);
				return;
			}
		}
		else
			_Map.setVector3d("vecOrg", vecOrg);			
	//endregion 

	//region Collect Views by mode
		Entity entDefine, defineSet[] = page.defineSet();
		entDefine = defineSet.length()>0?defineSet.first():Entity();
		CoordSys csDefine;
		if (entDefine.bIsValid())
		{ 
			GenBeam g = (GenBeam)entDefine;
			TslInst t = (TslInst)entDefine;
			MetalPartCollectionEnt ce = (MetalPartCollectionEnt)entDefine;
			Element el = (Element)entDefine;
			if (g.bIsValid())csDefine = g.coordSys();
			else if (t.bIsValid())csDefine = t.coordSys();
			else if (ce.bIsValid())csDefine = ce.coordSys();
			else if (el.bIsValid())csDefine = el.coordSys();
			else
			{ 
				csDefine = entDefine.bodyExtents().coordSys();
			}
		}	
		
		
		
		MultiPageView views[0];		
		Plane pnW(_PtW, _ZW);
		int bIsOrtho;
		
		
		if (bViewByLocation)
		{ 
		// on drag
			if(bDrag)
			{ 
				PlaneProfile pps[] = GetViewPlaneProfiles(page);
				DrawDrag(pps, _Pt0);
				return;
			}

			PlaneProfile ppView;
			MultiPageView view = FindClosestView(_Pt0, page, ppView);
			//{Display dpx(1); dpx.draw(ppView, _kDrawFilled,20);}
			if(ppView.dX()<dEps)
			{ 
				reportMessage("\n" + scriptName() + T("|Unexpected error|"));
				eraseInstance();
				return;
			}
			
			if(_kNameLastChangedProp=="_Pt0")
				_Pt0 = ppView.ptMid()-.5*(_XW*ppView.dX()+_YW*ppView.dY()); 			
			
			views.append(view);
			showSet = view.showSet();
			
			ms2ps = view.modelToView();
			ps2ms = ms2ps;ps2ms.invert();
			
					
			Vector3d vecZMS=csDefine.vecZ();		
			vecZMS.transformBy(ms2ps);vecZMS.normalize();
			bIsOrtho = vecZMS.isParallelTo(_ZW) || vecZMS.isPerpendicularTo(_ZW);
			
	
		}
		else if (bViewAll || bViewOrtho)
		{
			showSet = page.showSet();	
			views = page.views();
		}
		
			
	//endregion 

	//region Collect relevant entities
		Entity entities[0];
		
		//region Stack specific collection
		String sStackNames[] ={ kScriptStack, kScriptPack};

		TslInst stack, stacks[]= FilterTslsByName(showSet, kScriptStack);
		TslInst packs[]= FilterTslsByName(showSet, kScriptPack);
		TslInst items[]= FilterTslsByName(showSet, kScriptItem);
		TslInst spacers[]= FilterTslsByName(showSet, kScriptSpacer);
		
		if (stacks.length()>0)
		{ 
			stack = stacks.first();
			Entity ents[] = stack.entity();
			AppendTsls(packs, FilterTslsByName(ents, kScriptPack));
			AppendTsls(items, FilterTslsByName(ents, kScriptItem));
			AppendTsls(spacers, FilterTslsByName(ents, kScriptSpacer));
		}
		for (int i=0;i<packs.length();i++) 
		{ 
			Entity ents[] = packs[i].entity();
			AppendTsls(items, FilterTslsByName(ents, kScriptItem));
			AppendTsls(spacers, FilterTslsByName(ents, kScriptSpacer));		 
		}//next index
		
		if (sDisplaySet!=tDefaultEntry) // do not hatch the satck by default
		{
			AppendTslEntities(entities, stacks);
			AppendTslEntities(entities, packs);
		}	
		AppendTslEntities(entities, items);
		AppendTslEntities(entities, spacers);
		
		int bHasEntitiesOfStack = spacers.length() > 0 || stacks.length() > 0 || packs.length() > 0 || items.length() > 0;
		
		
//		// on all views or if the one selected is an iso view distinguish the dominant alignment to distinguish best ordering
//		int bMostlyVertical, nNumVertical, nNumHorizontal;
//		if (!bIsOrtho || bViewAll)
//		{ 
//			for (int i=0;i<items.length();i++) 
//			{ 
//				int bHorizontal= items[i].propString(T("|Alignment|"))==T("|Horizontal|"); 
//				if (bHorizontal)
//					nNumHorizontal++;
//				else
//					nNumVertical++;
//			}//next i
//			bMostlyVertical = nNumVertical >= nNumHorizontal;			
//		}

		//endregion 
	
	// Filter set
		if (entities.length()<1)
			entities = showSet;
		if (pd.bIsValid())
			entities = pd.filterAcceptedEntities(entities);

	// Group Assignment / non plotable state
		if (entities.length()<1)
		{ 
			_ThisInst.assignToGroups(page, 'T');
			dp.color(12);
			double textHeight = U(150);
			dp.textHeight(textHeight);
			dp.draw(scriptName() + T("|no solids found|"),_Pt0+(_XW+_YW)*textHeight, _XW,_YW,1,1,_kDevice);
			return;
		}
		else
			_ThisInst.assignToGroups(page);

		Body bodies[] = GetBodies(entities);
	
	//endregion 

	// Loop views	
		for (int v=0;v<views.length();v++) 
		{ 
			Entity ents[0];		ents = entities;
			Body bdEnts[0];		bdEnts = bodies;

			MultiPageView& view = views[v];
			int index = view.pageIndex();
			ms2ps = view.modelToView();
			ps2ms = ms2ps;ps2ms.invert();			
		
			Vector3d vecZMS=csDefine.vecZ();		
			vecZMS.transformBy(ms2ps);vecZMS.normalize();
			bIsOrtho = vecZMS.isParallelTo(_ZW) || vecZMS.isPerpendicularTo(_ZW);
			
			if (bViewOrtho && !bIsOrtho){ continue;} // only ortho views

			
			
//		// Get overall shadows and overall shadow
//			PlaneProfile ppShadow(CoordSys()), ppShadows[0];
//			
//			for (int i=0;i<bdEnts.length();i++) 
//			{ 
//				Body& bd = bdEnts[i];
//				bd.transformBy(ms2ps);
//				PlaneProfile pp(CoordSys());
//				pp.unionWith(bdEnts[i].shadowProfile(pnW));
//				ppShadows.append(pp);
//				
//				//{Display dpx(i); dpx.draw(pp, _kDrawFilled,20);}
//				
//				pp.shrink(-dEps);
//				ppShadow.unionWith(pp);
//			}//next i
//			ppShadow.shrink(-dEps);	

			PlaneProfile ppsAll[0];int indices[0];//same length!
			for (int i=0;i<bdEnts.length();i++) 
			{ 
				Body& bd = bdEnts[i];
				bd.transformBy(ms2ps);
				Map m;
				m.appendBody("bd", bdEnts[i]);
				PlaneProfile pps[] = m.getBodyAsPlaneProfilesList("SimpleBody");
				PurgeProfiles(pps, _ZW); 
				
				for (int j=0;j<pps.length();j++) 
				{ 
					
					ppsAll.append(pps[j]);
					indices.append(i); 
				}//next j
			}//next i

			RemoveHiddenPlaneProfiles(ppsAll, indices, _ZW, bIsOrtho, bHasEntitiesOfStack);

			for (int i=0;i<ppsAll.length();i++) 			
			{ 
				
				Entity ent = ents[indices[i]];
				
				//{Display dpx(indices[i]+1); dpx.draw(ppsAll[i], _kDrawFilled,20);}
				PlaneProfile pp = ppsAll[i];
				if (!bDebug)
					pp.project(pnW, _ZW, dEps);
				int c = ent.color();
				
				if (sColor == tColorByIndex && nColorIndex>-1)
					c = nColorIndex;
				else
				{ 
					int nItem = items.find(ent);
					if (sColor==tColorByParent && nItem>-1)
					{ 
						TslInst parent = GetParent(items[nItem]);
						if (parent.bIsValid())
							c = parent.color();
					}					
				}

				if (c>256)	dp.trueColor(c);
				else		dp.color(c);

				if (nTransparency>0)
					dp.draw(pp, _kDrawFilled,nTransparency);
				else
					dp.draw(pp, _kDrawFilled);	
				

			//region Draw Egde
				if (bDrawEdge)
				{ 
					dp.color(nColorEdge<0?c:nColorEdge);
//					if (dEdgeThickness>0)
//					{ 
//						PlaneProfile ppSub = pp;
//						ppSub.shrink(dEdgeThickness);
//						pp.subtractProfile(ppSub);
//						dp.draw(pp,_kDrawFilled);
//					}
//					else
						dp.draw(pp);
				}
			//endregion 


				
			}//next i


		
		}
	
		//{Display dpx(252); dpx.draw(ppShadow, _kDrawFilled,30);}
	}//End page //endregion 	
	
	//dp.draw(scriptName(), _Pt0, _XW, _YW, 0, 0);
	//if (bDebug)reportNotice("\n" + _ThisInst.handle() + " end delta " + (getTickCount()-tick));



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
        <int nm="BreakPoint" vl="581" />
        <int nm="BreakPoint" vl="581" />
        <int nm="BreakPoint" vl="1428" />
        <int nm="BreakPoint" vl="1707" />
        <int nm="BreakPoint" vl="439" />
        <int nm="BreakPoint" vl="403" />
        <int nm="BreakPoint" vl="393" />
        <int nm="BreakPoint" vl="342" />
        <int nm="BreakPoint" vl="359" />
        <int nm="BreakPoint" vl="1702" />
        <int nm="BreakPoint" vl="1692" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22814 tolerance of orthogonal faces increased. hidden surface removal improved" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="1/9/2025 3:45:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22814 hidden surface removal further improved, color index property visible on insert" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="12/11/2024 3:39:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22814 hidden surface removal and perfomance improved, color rule added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="12/5/2024 3:54:31 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22814 initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="11/28/2024 5:56:32 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End