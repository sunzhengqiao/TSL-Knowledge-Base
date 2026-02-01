#Version 8
#BeginDescription
#Versions
Version 4.0 24.04.2025 HSB-23933 index is suppressed when only a single, unique definition is found
Version 3.9 24.01.2025 HSB-23360 bugfix avoid infinite loop on creation
Version 3.8 22.01.2025 HSB-23360 purging dataLink submapX entry on erase of assembly, requires 27.3.4 or higher
Version 3.7 16.12.2024 HSB-23198 potential prefix variables will be purged if no valid prefix index can be collected
Version 3.6 16.12.2024 HSB-23198 byContact now accepts also intersecting solids, prefix property fix on insert
Version 3.5 11.12.2024 HSB-23105 bugfix showDialog with no existing painter definitions
Version 3.4 05.12.2024 HSB-23105 new property for creation strategy: byContact bundles items which are making contact to eachother
Version 3.3 02.12.2024 HSB-22961 debug message removed
Version 3.2 12.11.2024 HSB-22961 strategy of prefix indices improved, add/remove commands and performance improved, all painter  definitions accepted
Version 3.1 23.09.2024 HSB-22715 duplicates prevented when using painter definitions																					
Version 3.0 16.09.2024 HSB-22680 subindices improved, new commands to swap indices if enabled
Version 2.9 01.08.2024 HSB-22486 child entities reference to assembly via DataLink submapx, i.e. @(DataLink.AssemblyDefinition.Name:D)
Version 2.8 21.06.2024 HSB-22308 2D Blocks no longer contribute to the solid
Version 2.7 19.06.2024 HSB-22278 a new property 'Prefix' has been added to support prefix based indexing of the assembly name
Version 2.6 31.05.2024 HSB-22130 Add command to highlight entities of the assembly 
Version 2.5 02.05.2024 HSB-21727 posnum assignment improved
Version 2.4 21.03.2024 HSB-21717 catching solid tolerances for posnum generation
Version 2.3 19.01.2024 HSB-21168 new properties to specify start posnum of assembly and its items
Version 2.2 01.12.2023 HSB-20820 new option to rotate coordSys
Version 2.1 24.11.2023 HSB-20646 comparison key ignores box location but considers assembly properties for posnum creation
Version 2.0 22.11.2023 HSB-20646 new property to enable/diable automatic numbering of assembeld genbeams, supporting massgroups as parent container if it contains genbeams
Version 1.9 12.09.2023 HSB-20036 assembly name (format) and information written to submapX "AssemblyDefinition.Name" and "AssemblyDefinition.Information"
Version 1.8 12.09.2023 HSB-20026 new read only property 'weight', base point set to point of gravity

Version 1.7 20.07.2023 HSB-19578 coordsys on legacy creation adjusted
Version 1.6 20.07.2023 HSB-19578 legacy creation based on stud assemblies added, bounding dimensions published as length, width and height
Version 1.5 20.07.2023 HSB-19490 property 'Name' renamed to 'Format' accepting format expressions, automatic posnum generation added
Version 1.4 20.04.2023 HSB-18761 bugfix collection entity is referenced and in block edit mode
Version 1.3 16.03.2023 HSB-15141 beta version of method to collect quader from collectionEntity renamed
Version 1.2 07.03.2023 HSB-18207 supports assemblies containing curved beams
Version 1.1 06.03.2023 HSB-18207 performance enhanced, new commands to alter coordinate system
Version 1.0 03.03.2023 HSB-18207 initial version of assembly definition


This tsl defines an assembly.






























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 4
#MinorVersion 0
#KeyWords 
#BeginContents
//region Part #1
		
//region <History>
// #Versions
// 4.0 24.04.2025 HSB-23933 index is suppressed when only a single, unique definition is found , Author Thorsten Huck
// 3.9 24.01.2025 HSB-23360 bugfix avoid infinite loop on creation , Author Thorsten Huck
// 3.8 22.01.2025 HSB-23360 purging dataLink submapX entry on erase of assembly, requires 27.3.4 or higher , Author Thorsten Huck
// 3.7 16.12.2024 HSB-23198 potential prefix variables will be purged if no valid prefix index can be collected , Author Thorsten Huck
// 3.6 16.12.2024 HSB-23198 byContact now accepts also intersecting solids, prefix property fix on insert , Author Thorsten Huck
// 3.5 11.12.2024 HSB-23105 bugfix showDialog with no existing painter definitions , Author Thorsten Huck
// 3.4 05.12.2024 HSB-23105 new property for creation strategy: byContact bundles items which are making contact to eachother , Author Thorsten Huck
// 3.3 02.12.2024 HSB-22961 debug message removed , Author Thorsten Huck
// 3.2 12.11.2024 HSB-22961 strategy of prefix indices improved, add/remove commands and performance improved, all painter  definitions accepted , Author Thorsten Huck
// 3.1 23.09.2024 HSB-22715 duplicates prevented when using painetr definitions , Author Thorsten Huck																									  
// 3.0 16.09.2024 HSB-22680 subindices improved, new commands to swap indices if enabled , Author Thorsten Huck
// 2.9 01.08.2024 HSB-22486 child entities reference to assembly via DataLink submapx, i.e. @(DataLink.AssemblyDefinition.Name:D) , Author Thorsten Huck
// 2.8 21.06.2024 HSB-22308 2D Blocks no longer contribute to the solid. , Author Thorsten Huck
// 2.7 19.06.2024 HSB-22278 a new property 'Prefix' has been added to support prefix based indexing of the assembly name , Author Thorsten Huck
// 2.6 31.05.2024 HSB-22130 Add command to highlight entities of the assembly Author: Marsel Nakuci
// 2.5 02.05.2024 HSB-21727 posnum assignment improved , Author Thorsten Huck
// 2.4 21.03.2024 HSB-21717 catching solid tolerances for posnum generation , Author Thorsten Huck
// 2.3 19.01.2024 HSB-21168 new properties to specify start posnum of assembly and its items , Author Thorsten Huck
// 2.2 01.12.2023 HSB-20820 new option to rotate coordSys , Author Thorsten Huck
// 2.1 24.11.2023 HSB-20646 comparison key ignores box location for posnum creation but considers assembly properties , Author Thorsten Huck
// 2.0 22.11.2023 HSB-20646 new property to enable/diable automatic numbering of assembeld genbeams, supporting massgroups as parent container if it contains genbeams , Author Thorsten Huck
// 1.9 12.09.2023 HSB-20036 assembly name (format) and information written to submapX "AssemblyDefinition.Name" and "AssemblyDefinition.Information" , Author Thorsten Huck
// 1.8 12.09.2023 HSB-20026 new read only property 'weight', base point set to point of gravity , Author Thorsten Huck
// 1.7 20.07.2023 HSB-19578 coordsys on legacy creation adjusted , Author Thorsten Huck
// 1.6 20.07.2023 HSB-19578 legacy creation based on stud assemblies added, bounding dimensions published as length, width and height , Author Thorsten Huck
// 1.5 20.07.2023 HSB-19490 property 'Name' renamed to 'Format' accepting format expressions, automatic posnum generation added , Author Thorsten Huck
// 1.4 20.04.2023 HSB-18761 bugfix collection entity is referenced and in block edit mode , Author Thorsten Huck
// 1.3 16.03.2023 HSB-15141 beta version of method to collect quader from collectionEntity renamed , Author Thorsten Huck
// 1.2 07.03.2023 HSB-18207 supports assemblies containing curved beams , Author Thorsten Huck
// 1.1 06.03.2023 HSB-18207 performance enhanced, new commands to alter coordinate system , Author Thorsten Huck
// 1.0 03.03.2023 HSB-18207 initial version of assembly definition, Author Thorsten Huck
// 
/// <insert Lang=en>
/// Select entities to build an assembly
/// </insert>

// <summary Lang=en>
// This tsl defines an assembly.
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "AssemblyDefinition")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Entities|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Entities|") (_TM "|Select tool|"))) TSLCONTENT

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
	
	
	String tDisabledEntry = T("<|Disabled|>");
	String kPreviousPos = "previousPos";
	String kDataLink = "DataLink";
	
	String kAssemblyDef = "AssemblyDefinition";
//end Constants//endregion


//region Functions

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

//region Function GetGenBeamBody
	// returns
	// t: the tslInstance to 
	Body GetGenBeamBody(GenBeam genbeam,int shapeMode)
	{ 
		GenBeam g = genbeam;
		Beam b = (Beam)g;
		//int bIsRound = b.bIsValid() && b.extrProfile()==T("|Round|")?true:false;
		//reportNotice("\nGetGenBeamBody: bIsRound " + bIsRound);
		Body bd;
		if (shapeMode == 1)bd =g.envelopeBody(false,true);
		else if (shapeMode == 2)bd =g.envelopeBody(true,true);
		else if (shapeMode == 3){bd =g.envelopeBody();}
		else bd =g.realBody();
		return bd;
	} //endregion	

//region Function GetMetalPartBody // HSB-23088
	// returns
	Body GetMetalPartBody(MetalPartCollectionEnt ce, int shapeMode, PainterDefinition pd)
	{ 
		Body out;
		//reportNotice("\nGetMetalPartBody: shapeMoode " + shapeMode);
		if (shapeMode<1)
		{
			//reportNotice("...realBodyTry");
			return ce.realBodyTry();
		}
		
		
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
		if (gb.bIsValid())
			bd = GetGenBeamBody(gb, shapeMode);
		else if (ce.bIsValid())
		{ 
			bd = GetMetalPartBody(ce,shapeMode , PainterDefinition());
		}			
		else if (bref.bIsValid())
		{ 
			bd = GetBlockRefBody(bref, shapeMode, PainterDefinition());
		}			
			
		if (bd.isNull())
		{ 
			Quader q = ent.bodyExtents();
			if (q.dX()<=dEps || q.dY()<=dEps || q.dZ()<=dEps)
				bd = ent.realBody();
			else
				bd = Body(q.pointAt(0, 0, 0), q.vecX(), q.vecY(), q.vecZ(), q.dX(), q.dY(), q.dZ(), 0, 0, 0);
		}		
		return bd;
	}//endregion
	
//region Function DrawViewShadow
	// draws a shadow of all entities in the current view. if no color is specified (<0) the entity color will be used
	void DrawViewShadow(Entity ents[], int color)
	{ 
		Display dpJig(3), dpTxt(255);
		dpTxt.textHeight(getViewHeight() / 25);
		Plane pn(_PtW, vecZView);
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam gb = (GenBeam)ents[i];
			Body bd = GetSimpleBody(ents[i],1);
			if (bd.isNull())continue;
			
			pn = Plane(bd.ptCen(), vecZView);
			PlaneProfile pp = bd.shadowProfile(pn);
			
			int c = color<0?ents[i].color():color;
			if (gb.bIsValid() && gb.posnum()<1)
			{
				c = 1;
				dpJig.transparency(20);	
				dpTxt.draw(T("|Invalid PosNum|"), pp.ptMid(), _XW, _YW, 0, 0, _kDevice);
			}
			else
				dpJig.transparency(50);
			
			if (c>256)
				dpJig.trueColor(c);
			else
				dpJig.color(c);
			dpJig.draw(bd);
			dpJig.draw(pp,_kDrawFilled);
			
		}//next i		
		
		
		return;
	}//endregion	

//region Function GetViewShadow
	// draws a shadow of all entities in the current view. if no color is specified (<0) the entity color will be used
	PlaneProfile GetViewShadow(Entity ents[])
	{ 
		Plane pn(_PtW, vecZView);
		PlaneProfile ppShadow;
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam gb = (GenBeam)ents[i];
			Body bd = GetSimpleBody(ents[i],1);
			if (bd.isNull())continue;
			
			pn = Plane(bd.ptCen(), vecZView);
			PlaneProfile pp = bd.shadowProfile(pn);
			
			if (ppShadow.area()<pow(dEps,2))
				ppShadow = pp;
			else
				ppShadow.unionWith(pp);

		}//next i		
		
		
		return ppShadow;
	}//endregion

//region Function FilterTslsByName
	// returns all tsl instances with a certain scriptname
	// ents: the array to search, if empty all tsls in modelspace are taken
	// names: the names of the tsls to be returned, all if empty
	TslInst[] FilterTslsByName(Entity ents[], String names[])
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

//region Function RemoveDataLink
	// removes assemblyDefinition datalink from the entity and returns if it has been removed from a valid assembly
	int RemoveDataLink(Entity& e)
	{ 
		int bValidAssembly, bOk;
		String keys[] = e.subMapXKeys();
		if (keys.findNoCase(kDataLink ,- 1) >- 1)
		{
			Map m = e.subMapX(kDataLink);
			Entity assembly = m.getEntity(kAssemblyDef);			
			bValidAssembly = assembly.bIsValid();

		// assemblyDefinition found in datalink		
			bOk = m.removeAt(kAssemblyDef, true);	
			
		// no more datalink found, remove all	
			if (m.length()<1)
				e.removeSubMapX(kDataLink);	
		// keep other data links		
			else
				e.setSubMapX(kDataLink, m);	
				
			//if (bDebug)reportNotice("\nassembly datalink released from " + e.typeDxfName() + " removed: " + bOk);				
		}
		return bOk;
	}//endregion

//region Function PurgeAssemblyReference
	// purges the datalink from any entity if invalid 
	void PurgeAssemblyReference(Entity& e)
	{ 
		String keys[] = e.subMapXKeys();
		if (keys.findNoCase(kDataLink,-1)>-1)
		{ 
			Map m = e.subMapX(kDataLink);
			Entity ref = m.getEntity(kAssemblyDef);
			if (!ref.bIsValid())
			{ 
			// assemblyDefinition found in datalink		
				m.removeAt(kAssemblyDef, true);					

			// no more datalink found, remove all	
				if (m.length()<1)
					e.removeSubMapX(kDataLink);	
			// keep other data links		
				else
					e.setSubMapX(kDataLink, m);			
				//if (bDebug)
				reportNotice("\nreference purged from " + e.typeDxfName());
			}
			else
				reportNotice("\ninvalid reference of " + e.typeDxfName());
		}			
		return;
	}//endregion	

//region Function ReleaseFromAssembly
	// returns the entities which were successfully removed
	Entity[] ReleaseFromAssembly(Entity entsIn[])
	{ 
		Entity out[0];		
		for (int i=0;i<entsIn.length();i++) 
		{ 
			Entity& e = entsIn[i];
			Map m = e.subMapX(kDataLink);
			
			Entity entAssembly = m.getEntity(kAssemblyDef);
			TslInst assembly = (TslInst)entAssembly;
			if(assembly.bIsValid())
			{ 
				Entity ents[] = assembly.entity();
				int num1 = ents.length();
				int n = ents.find(e);
				if (n>-1)
				{ 
					int ok = RemoveDataLink(e);	
					out.append(e);
					ents.removeAt(n);
				}	
				int num2 = ents.length();
				if (num2<num1)
				{ 
					Map map = assembly.map();
					map.setEntityArray(ents, true, "RemoteEnt[]", "", "RemoteEnt");	
					assembly.setMap(map);
					assembly.transformBy(Vector3d(0, 0, 0));	

					if(bDebug)
					{
						int num3 = assembly.entity().length();
						reportNotice("\nReleaseFromAsembly: " + (num3==num2?"succeeded":"failed"));
					}
				}				
			}
		}

		return out;
	}//endregion


//region Function AssignToAssembly
	// assigns the assembly datalink submapx to the entities and modifies the _Entity array of the assembly
	void AssignToAssembly(TslInst& assembly, Entity entsIn[])
	{ 
		if (assembly.bIsValid())
		{
			Entity ents[] = assembly.entity();
			int num1 = ents.length();
			for (int i=0;i<entsIn.length();i++) 
			{ 	
				Entity& e = entsIn[i];
				Map m = e.subMapX(kDataLink);
				m.setEntity(kAssemblyDef, assembly);
				e.setSubMapX(kDataLink, m);
				
				if (ents.find(e)<0)
					ents.append(e);
				
			}//next i
			int num2 = ents.length();
						
			if (num2>num1)
			{ 
				Map map = assembly.map();
				map.setEntityArray(ents, true, "RemoteEnt[]", "", "RemoteEnt");	
				assembly.setMap(map);
				assembly.transformBy(Vector3d(0, 0, 0));
								
				if (bDebug)
				{
					int num3 = assembly.entity().length();
					reportNotice("\nAssignToAsembly: " + (num3==num2?"succeeded":"failed"));
				}
			}		
		}

		return;
	}//endregion


//region Function GetClosestIndex
	// returns the index of the closest planeprofile to the given point
	int GetClosestIndex(PlaneProfile pps[], Point3d pt)
	{ 
		int n = - 1;
		
	    double dMin = U(10e6);
	    for (int i=0;i<pps.length();i++) 
	    { 
	    	double d = (pps[i].closestPointTo(pt)-pt).length();
	    	if (d<dMin)
	    	{ 
	    		dMin = d;
	    		n = i;
	    	}	    	 
	    }//next i		
		
		return n;
	}//endregion



//region Function GetCompareKeyByProfile
	// returns a compare key composed of the dimensions of the given planeProfiles
	String GetCompareKeyByProfile(CoordSys cs, PlaneProfile ppX, PlaneProfile ppY, PlaneProfile ppZ)
	{ 
		String key;
		
		Point3d ptCen = cs.ptOrg();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		
		// HSB-21727 considering mirrored assemblies
		Point3d ptX; ptX.setToAverage(ppX.getGripVertexPoints());ptX.vis(1);
		Point3d ptY; ptY.setToAverage(ppY.getGripVertexPoints());ptY.vis(3);
		Point3d ptZ; ptZ.setToAverage(ppZ.getGripVertexPoints());ptZ.vis(150);		
		
		int nRound = 10;  // HSB-22680 decreased tolerance by one digit, previously 100
		double dxy = vecY.dotProduct(ptX - ptCen); dxy = round(dxy * nRound)/nRound;
		double dxz = vecZ.dotProduct(ptX - ptCen); dxz = round(dxz * nRound)/nRound;
		double dyx = vecX.dotProduct(ptY - ptCen); dyx = round(dyx * nRound)/nRound;
		double dyz = vecZ.dotProduct(ptY - ptCen); dyz = round(dyz * nRound)/nRound;
		double dzx = vecX.dotProduct(ptZ - ptCen); dzx = round(dzx * nRound)/nRound;
		double dzy = vecY.dotProduct(ptZ - ptCen); dzy = round(dzy * nRound)/nRound;		
		
		key= "__" + dxy+"_" + dxz+"_" + dyx+"_" + dyz+"_" + dyz+"_" + dzx+"_" + dzy;
		
		return key;
	}//endregion

//endregion 

//END Part 1//endregion 


//region Part #2

//region JIG


// Jig SwapIndex
	String kJigSwapIndex = "SwapIndex";
	if (_bOnJig && _kExecuteKey==kJigSwapIndex) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
	    Point3d pt1 = _Map.getPoint3d("pt1");
		//PlaneProfile ppThis = _Map.getPlaneProfile("ppThis");
		
	// get all siblings and their indices	
		Map mapSiblings = _Map.getMap("Sibling[]");
	    PlaneProfile ppSiblings[0];
	    for (int i=0;i<mapSiblings.length();i++) 
	    	if (mapSiblings.hasPlaneProfile(i))
	    		ppSiblings.append(mapSiblings.getPlaneProfile(i));
		if (ppSiblings.length()<1)
			return;
			
	//  get all others and their indices
		Map mapOthers = _Map.getMap("Other[]");		
	    PlaneProfile ppOthers[0];
	    int indices[0];
	    for (int i=0;i<mapOthers.length();i++) 
	    {
	    	if (mapOthers.hasPlaneProfile(i))
	    		ppOthers.append(mapOthers.getPlaneProfile(i));
	    	if (mapOthers.hasInt(i))
	    		indices.append(mapOthers.getInt(i));	    		
	    }

		ptJig.setZ(ppSiblings.first().coordSys().ptOrg().Z());

	    
	    Display dp(-1),dpWhite(-1),dpTxt(-1);
	    dpWhite.trueColor(rgb(255, 255, 254),1);
	    dpTxt.trueColor(rgb(0, 0, 1));
	    double textHeight = dViewHeight / 25;
	    if (textHeight>U(200))
	    { 
	    	textHeight = U(200);
	    }
	    String dimStyle = _DimStyles.first();
	    dpTxt.dimStyle(dimStyle);
	    dpTxt.textHeight(textHeight);
	    dp.trueColor(darkyellow, 30);
	    
	// draw siblings
		for (int i=0;i<ppSiblings.length();i++)
	    { 
	    	Point3d ptLoc = ppSiblings[i].ptMid();
	    	dp.draw(ppSiblings[i], _kDrawFilled);
	    }
		
	    double dMin = U(10e6);
	    int n=GetClosestIndex(ppOthers, ptJig);
	    for (int i=0;i<ppOthers.length();i++)
	    { 
	    // display source and target text	
			if (n == i)
			{
				// display source
				dp.trueColor(darkyellow, 30);
				String sourceTxt = _Map.getString("ResolvedPrefix") + "." + indices[i];
				Vector3d vec = .5 * (_XW * dpTxt.textLengthForStyle(sourceTxt, dimStyle, textHeight) + _YW * dpTxt.textHeightForStyle(sourceTxt, dimStyle, textHeight));
				for (int j = 0; j < ppSiblings.length(); j++)
				{
					Point3d ptLoc = ppSiblings[j].ptMid();
					dp.draw(ppSiblings[j], _kDrawFilled);
					
					PLine box;
					box.createRectangle(LineSeg(ptLoc - vec, ptLoc + vec), _XW, _YW);
					box.offset(-.2 * textHeight, true);
					box.convertToLineApprox(dEps);
					dpWhite.draw(PlaneProfile(box), _kDrawFilled);
					dpTxt.draw(sourceTxt, ptLoc, _XW, _YW, 0, 0, _kDeviceX);
				}//next j
				
				// display target
				String targetTxt = _Map.getString("ResolvedPrefix") + "." + _Map.getInt("PrefixIndex");
				vec = .5 * (_XW * dpTxt.textLengthForStyle(targetTxt, dimStyle, textHeight) + _YW * dpTxt.textHeightForStyle(targetTxt, dimStyle, textHeight));
				
				for (int j = 0; j < ppOthers.length(); j++)
				{
					if (indices[j]!=indices[i])
					{
						dp.trueColor(lightblue);
						dp.draw(ppOthers[j], _kDrawFilled, 50);
						continue;
					}
					Point3d ptLoc = ppOthers[j].ptMid();
					PLine box;
					box.createRectangle(LineSeg(ptLoc - vec, ptLoc + vec), _XW, _YW);
					box.offset(-.2 * textHeight, true);
					box.convertToLineApprox(dEps);
					dpWhite.draw(PlaneProfile(box), _kDrawFilled);
					dpTxt.draw(targetTxt, ptLoc, _XW, _YW, 0, 0, _kDeviceX);
					
					dp.trueColor(orange);
					dp.draw(ppOthers[j], _kDrawFilled, 30);
				}
			}
						
			
	    }
	    
	    
	    return;
	}


// Jig SetSequence
	String kJigSetSequence = "SetSequence";
	if (_bOnJig && _kExecuteKey==kJigSetSequence) 
	{ 
		Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point	

	    PlaneProfile pps[0];
	    int indices[0];
	    for (int i=0;i<_Map.length();i++) 
	    {
	    	if (_Map.hasPlaneProfile(i))
	    		pps.append(_Map.getPlaneProfile(i));
	    	if (_Map.hasInt(i))
	    		indices.append(_Map.getInt(i));	    		
	    }

	    double textHeight = dViewHeight / 25;
	    String dimStyle = _DimStyles.first();		
		
	    Display dp(-1),dpWhite(-1),dpTxt(-1);
	    dpWhite.trueColor(rgb(255, 255, 254),1);
	    dpTxt.trueColor(rgb(0, 0, 1));
	    dpTxt.dimStyle(dimStyle);
	    dpTxt.textHeight(textHeight);
		
		for (int i=0;i<pps.length();i++)
		{
			dp.trueColor(lightblue);
			dp.draw(pps[i], _kDrawFilled,20);
		}
		
	    return;		
	}
//endregion 

//region Properties
	String sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();
	
//region Painter Collections
	String sPainterCollection = "Assembly\\";
	String sPainters[0];
	for (int i=0;i<sAllPainters.length();i++) 
	{ 
		PainterDefinition pd(sAllPainters[i]);
		if (!pd.bIsValid())// || pd.format().find("@(",0, false)<0)
			continue;
	
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
			PainterDefinition pd(s);
			if (!pd.bIsValid())// || pd.format().find("@(",0, false)<0)
				continue;		
	
			if (sPainters.findNoCase(s,-1)<0)
				sPainters.append(s);
		}//next i		
	}
	
//region AutoCreate Certain definitions
	String tLegacyAssemblySelectionSet = T("|Legacy Assemblies|");
	if (_bOnInsert ||_bOnDebug)	
	{ 
		Entity ents[] = Group().collectEntities(true,TslInst(),  _kModelSpace);
		int bHasLegacy;
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i]; 
			if (t.scriptName().find("studassembly",0,false)>-1)
			{ 
				bHasLegacy = true;
				break;
			}
			 
		}//next i
		
		if (bHasLegacy && sPainters.findNoCase(tLegacyAssemblySelectionSet,-1)<0)
		{ 
			String name = tLegacyAssemblySelectionSet;
			String painter = sPainterCollection + name;
			PainterDefinition pd(painter);	
			if (!pd.bIsValid())
			{ 
				pd.dbCreate();
				if (pd.bIsValid())
				{ 
					pd.setType("TslInstance");
					pd.setFilter("Contains(ScriptName,'studassembly')");
					pd.setFormat("@(ScriptName)");
				}
			}	
				
			if (pd.bIsValid() && sPainters.findNoCase(name,-1)<0)
				sPainters.append(name);		
		}			
	}
//endregion 	

	sPainters.insertAt(0, tDisabledEntry);
//endregion 	
	

category = T("|Creation|");

	String tSTDefault = T("<|Default|>"), tSTContact = T("|byContact|"), sStrategies[] = {tSTDefault, tSTContact };
	String sStrategyName=T("|Strategy|");	
	PropString sStrategy(8, sStrategies, sStrategyName);	
	sStrategy.setDescription(T("|Outlines the strategy for gathering components of an assembly.|") + 
		T("|<Default> will use the chosen items in accordance with the filtering rule. |")+
		T("|'byContact' will generate an assembly for each primary component, including secondary items that come into contact with the primary component.|"));
	sStrategy.setCategory(category);
	sStrategy.setReadOnly((bDebug || _bOnInsert) ? false : _kHidden);

	String sPainterName=T("|Filter|");	
	String sPainterDesc = T(" |If a painter collection named 'Assembly' is found, only painters of this collection are considered.|");
	PropString sPainter(0, sPainters, sPainterName);	
	sPainter.setDescription(T("|Defines the painter definition to filter entities.|") +sPainterDesc );
	sPainter.setCategory(category);
	int nPainter = sPainters.find(sPainter);
	if (nPainter<0){ nPainter=0;sPainter.set(sPainters[nPainter]);}
	String sPainterDef = bFullPainterPath ? sPainter : sPainterCollection + sPainter;

	String sPrefixFormatName=T("|Prefix|");	
	PropString sPrefixFormat(7, "", sPrefixFormatName,1);	
	sPrefixFormat.setDescription(T("|Defines a prefix of the assembly.|") + T("|A prefix will be used to create incremental indices for the assemblies containing the same prefix.|"));
	sPrefixFormat.setCategory(category);
	
	String sStartPosAssemblyName=T("|Start PosNum Assembly|");	
	PropInt nStartPosAssembly(nIntIndex++, 1, sStartPosAssemblyName);	
	nStartPosAssembly.setDescription(T("|Defines the first potential posnum of an assembly.|") + T(" |If the posnum is already occupied the next available posnum will be given.|"));
	nStartPosAssembly.setCategory(category);

	String tDisabled = T("<|Disabled|>"), tAutoPos = T("|Automatic|"), sApplyPosnums[] ={ tDisabled, tAutoPos};
	String sApplyPosNumName=T("|Apply PosNums|");	
	PropString sApplyPosNum(6, sApplyPosnums, sApplyPosNumName,1);	
	sApplyPosNum.setDescription(T("|Defines the if nested entities will get an automatic posnum assigned|") + T("|Note: The posnums of the nested entities are used to compare the content of an assmbly.|"));
	sApplyPosNum.setCategory(category);
	sApplyPosNum.setControlsOtherProperties(true);
	
	String sStartPosName=T("|Start PosNum|");	
	PropInt nStartPos(nIntIndex++, 1, sStartPosName);	
	nStartPos.setDescription(T("|Defines the first potential posnum of an item of the assembly.|") + T(" |If the psonum is already occupied the next available posnum will be given.|") + 
	T(" |Only relevant if| ") + sApplyPosNumName + " = " + tAutoPos );
	nStartPos.setCategory(category);
	if (!bDebug && !_bOnInsert && sApplyPosNum == tDisabled)
		nStartPos.setReadOnly(_kHidden);

	
category = T("|General|");
	String sFormatName=T("|Format|");	
	PropString sFormat(1, T("|Assembly| @(PosNum)"), sFormatName);	
	sFormat.setDescription(T("|Defines the name of the assembly by using format variables|"));
	sFormat.setCategory(category);
	
	String sMaterialName=T("|Material|");	
	PropString sMaterial(2, "", sMaterialName);	
	sMaterial.setDescription(T("|Defines the Material|"));
	sMaterial.setCategory(category);

	String sGradeName=T("|Grade|");	
	PropString sGrade(3, "", sGradeName);	
	sGrade.setDescription(T("|Defines the Grade|"));
	sGrade.setCategory(category);
	
	String sQualityName=T("|Quality|");	
	PropString sQuality(4, "", sQualityName);	
	sQuality.setDescription(T("|Defines the Quality|"));
	sQuality.setCategory(category);
	
	String sInformationName=T("|Information|");	
	PropString sInformation(5, "", sInformationName);	
	sInformation.setDescription(T("|Defines the Information|"));
	sInformation.setCategory(category);
	
	String sWeightName=T("|Weight|");	
	PropDouble dWeight(1, U(0), sWeightName,_kNoUnit);	
	dWeight.setDescription(T("|Defines the Weight|"));
	dWeight.setCategory(category);
	dWeight.setReadOnly(true);

category = T("|Display|");
	String sScaleName=T("|Scale|");	
	PropDouble dScale(0, 1, sScaleName, _kNoUnit);	
	dScale.setDescription(T("|Defines the scale of the symbol, value must be >0|"));
	dScale.setCategory(category);

	
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
			showDialog();
		
		int nPainter = sPainters.find(sPainter);
		if (nPainter<0){ nPainter=0;sPainter.set(sPainters[nPainter]);}
		
	// Collect assemblies of this dwg
		Entity entsAss[] = Group().collectEntities(true, TslInst(), _kModelSpace);

	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select entities|"), Entity());
		if (ssE.go())
			ents.append(ssE.set());
	
	
	/// remove entities which are already assembled
		int numRejected;
		for (int i=0;i<entsAss.length();i++) 
		{ 
			TslInst t= (TslInst)entsAss[i];
			if (t.bIsValid()&& t.scriptName()==scriptName())
			{ 
				Entity entsT[] = t.entity();
				for (int j=ents.length()-1; j>=0 ; j--) 
					if (entsT.find(ents[j])>-1)
					{
						//reportMessage("\n"+ents[j].handle() + " refused");
						ents.removeAt(j); 
						numRejected++;
					}
			}		 
		}//next i

		if (nPainter>0)
		{ 
			sPainterDef = bFullPainterPath ? sPainter : sPainterCollection + sPainter;
			PainterDefinition pd(sPainterDef);
			ents = pd.filterAcceptedEntities(ents);
		}

		_Entity = ents;	
		
	//region Create single instances for each potential massgroup and remove from list
		for (int i=_Entity.length()-1; i>=0 ; i--) 
		{ 
			Entity e =_Entity[i]; 
			MassGroup mg = (MassGroup)e;
			if (mg.bIsValid())
			{ 
			// create TSL
				TslInst tslNew;;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {mg};		Point3d ptsTsl[] = {mg.coordSys().ptOrg()};
				int nProps[]={nStartPosAssembly,nStartPos};	double dProps[]={dScale};		
				String sProps[]={tDisabledEntry,sFormat, sMaterial, sGrade, sQuality, sInformation,sApplyPosNum, sStrategy};
				Map mapTsl;	
							
				tslNew.dbCreate(scriptName() , _XU ,_YU,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				_Entity.removeAt(i);
			}
		}//next i
		
		
			
	//endregion 	

		
		if (numRejected>0)
			reportMessage("\n" + scriptName() + ": " + numRejected + T("|already linked to ther assemblies.|"));
		
		if (ents.length()<1)
			eraseInstance();
		return;
	}			
//End onINsert //endregion 

//region Standards and References		
	Entity entDefine,ents[0];
	
	// set _Entity remotly
	if (_Map.indexAt("RemoteEnt[]")>-1)
	{ 
		ents = _Map.getEntityArray("RemoteEnt[]", "", "RemoteEnt");
		if (ents.length()>0)
			_Entity = ents;
		_Map.removeAt("RemoteEnt[]", true);
	}
	ents = _Entity;		

	if (ents.length() < 1)
	{
		if(bDebug)reportNotice("\nno entities");
		eraseInstance();
		return;
	}

// Store ThisInst in _Map to enable debugging with subMapX until HSB-22564 is implemented
	TslInst this = _ThisInst;
	if (bDebug && _Map.hasEntity("thisInst"))
	{
		Entity ent = _Map.getEntity("thisInst");	
		this = (TslInst)ent;
	}
	else if (!bDebug && (_bOnDbCreated || !_Map.hasEntity("thisInst")))
		_Map.setEntity("thisInst", this);

	//region MassGroup Assembly: append all nested entities
	if (_Entity.length()>0 && _Entity[0].bIsKindOf(MassGroup()))
	{ 
		MassGroup mg = (MassGroup)_Entity[0];
		_Entity.append(mg.entity());
		ents = _Entity;
		int n = ents.find(mg);
		if (n>-1)
			ents.removeAt(n);
	}
	//endregion 	
	
	if (_kNameLastChangedProp==sStartPosAssemblyName)
	{ 
		_ThisInst.releasePosnum();
		setExecutionLoops(2);
		return;
	}	
	
	Vector3d vecX=_XE, vecY=_YE, vecZ=_ZE;
	int bDrag = _bOnGripPointDrag && _kExecuteKey == "_Pt0";
	int bApplyPosNum = sApplyPosNum == tAutoPos;
	int bRecalc = _kNameLastChangedProp == sPrefixFormatName || _bOnDbCreated;
	if (bRecalc)
		setExecutionLoops(2);	
	

	
		
//endregion 

//END Part 2//endregion

//region Create assembly instances by filter or legacy tsl
	//if (sStrategy == tSTContact) bDebug = true;
	if ((sStrategy == tSTContact && !bDebug) && _kExecutionLoopCount==0)//(sStrategy == tSTContact || bDebug)
	{ 
		//bDebug = true;
		
		Display dp(4);
		dp.textHeight(U(100));
		double dGap = dEps;
		
		
	//region Collect indexed faces of each solid
		Body bodies[0]; Entity solids[0];
		for (int i=0;i<_Entity.length();i++) 
		{
			Body bd = GetSimpleBody(_Entity[i],3);// HSB-23198 shapeMode set realBody 0 instead envelope 3
			if (!bd.isNull())
			{ 
				bodies.append(bd);
				solids.append(_Entity[i]);
			}
		}
		Map mapContacts[bodies.length()]; // container to store the item indices which make contact	
		
		PlaneProfile pps[0]; int inds[0];// inds is keeping the reference to the entity
		for (int i=0;i<bodies.length();i++) 
		{
			Body& bd = bodies[i];
			//bd.vis(i);
			Map m;
			m.setBody("Body", bd);
			PlaneProfile ppsI[] = m.getBodyAsPlaneProfilesList("SimpleBody");
			for (int j=0;j<ppsI.length();j++) 
			{ 
				//{Display dpx(i); dpx.draw(ppsI[j], _kDrawFilled,80);}
				pps.append(ppsI[j]);
				inds.append(i); 
			}//next j
		}		
	//endregion 	
	
	//region Find contacts
		int nLast = -1;
		for (int i=0;i<pps.length();i++) 
		{ 
			int ind1 = inds[i];
			PlaneProfile pp1= pps[i]; 
			CoordSys cs1 = pp1.coordSys();
			Vector3d vecZ1 = cs1.vecZ();
			Point3d pt1 = cs1.ptOrg();
			
			if (bDebug && nLast<ind1)
			{ 
				Body bd1 = bodies[ind1];
				nLast = ind1;
				dp.color(_Entity[ind1].color());
				dp.draw(ind1, bd1.ptCen(), _XW, _YW, 0, 0, _kDeviceX);
			}
			

			int nLast2=-1; //the index of the last collected body, used to skip multiple tests on the same body onve a contact has been found
			int numContacts[0];	

			for (int j=0;j<pps.length();j++) 
			{ 
				int ind2 = inds[j];

				if (ind2>ind1)
				{ 
					PlaneProfile pp2= pps[j]; 
					CoordSys cs2 = pp2.coordSys();
					Vector3d vecZ2 = cs2.vecZ();
					Point3d pt2 = cs2.ptOrg();
					
				// skip next profile test of the same body	
					if(nLast2==ind2)
					{ 
						continue;//nLast2!=ind2 && 
					}
	
				// accept only faces which are counter codirectional and not too far away
					if (vecZ1.isCodirectionalTo(-vecZ2) && abs(vecZ1.dotProduct(pt2-pt1))<=dGap)
					{
					 	PlaneProfile ppContact = pp2;
					 	//Display dpx(1); dpx.draw(ppContact, _kDrawFilled,40);
					 	ppContact.intersectWith(pp1);
					 	if (ppContact.area()>pow(U(3),2))
					 	{

							if (nLast2<ind2)
								nLast2 = ind2;
							
					 		if (bDebug)
					 		{ 
						 		dp.color(_Entity[ind2].color());
						 		dp.draw(ind2, pt2, _XW, _YW, 0, 0, _kDeviceX);
						 		Display dpx(3); dpx.draw(ppContact, _kDrawFilled,80);				 			
					 		}
					 		numContacts.append(ind2);// only debug
					 		
					 		Map& map1 = mapContacts[ind1];
					 		Map& map2 = mapContacts[ind2];
					 		
					 		map1.setInt(ind2, ind2);
					 		map2.setInt(ind1, ind1);

					 	}
					}					
				}

			}//next j
			
		// Display contact and store in entity/body map

			if (bDebug)
			{ 
				Point3d ptCen1 = bodies[ind1].ptCen();
				for (int j=0;j<numContacts.length();j++) 
				{ 
					int n = numContacts[j];
					Point3d ptCen2 = bodies[n].ptCen();
					PLine(ptCen1, ptCen2).vis(3);
				}				
			}
		}//next i			
	//Find contacts //endregion 


	//region Find Solid Intersections as accepted contacts
		for (int i=0;i<bodies.length()-1;i++) 
		{ 
			int ind1 = i;
			Body bd1 = bodies[i]; 
			for (int j=i+1;j<bodies.length();j++) 
			{ 
				int ind2 = j;
				Body bd2 = bodies[ind2];
				
				if (bd2.hasIntersection(bd1))
				{ 
			 		Map& map1 = mapContacts[ind1];
			 		Map& map2 = mapContacts[ind2];
			 		
			 		map1.setInt(ind2, ind2);
			 		map2.setInt(ind1, ind1);	
			 		
			 		if (bDebug)
			 		{ 
			 			PLine(bodies[ind1].ptCen(), bodies[ind2].ptCen()).vis(6);
			 		}
			 		
				}
				 
			}//next i			 
		}//next i	
	//endregion 

	//region Function DepthFirstSearch
		// Searches recursivly if an index belongs to a group. Each entry which has not been collected
		// will be appended if it is mapped as neighbor
		void DepthFirstSearch(int ind, int& visited[], Map& mapGroup, Map mapNeighbors[])
		{ 
			visited.append(ind);
			int inds[] = GetIntArray(mapGroup, false);
			inds.append(ind);
			mapGroup = SetIntArray(inds, "ind");
	
			int indsNeighbor[] = GetIntArray(mapNeighbors[ind], false);
			for (int j=0;j<indsNeighbor.length();j++)
			{ 
				int n = indsNeighbor[j];
				if (visited.find(n)<0)
				{ 
					DepthFirstSearch(n, visited, mapGroup, mapNeighbors);
				}
			}
	
			return;
		}//endregion	

	//region Collect groups of item indices
		Map mapGroups;
		int visitedIndices[0];
		for (int i=0;i<mapContacts.length();i++)
		{ 
			int ind = i;
			if (visitedIndices.find(ind)<0)
			{ 
				Map mapGroup;				
				DepthFirstSearch(ind, visitedIndices, mapGroup, mapContacts);
				mapGroups.appendMap("Group", mapGroup);
			}
		}			
	//endregion 

	//region Create new instances of AssemblyDefinition by detected groups
		int numCreated;
		for (int i=0;i<mapGroups.length();i++) 
		{ 
			int inds[] = GetIntArray(mapGroups.getMap(i), false);
			
			Entity entsTsl[0];
			for (int j=0;j<inds.length();j++) 
			{ 
				int n = inds[j];
				if (n>-1 && n<solids.length())
					entsTsl.append(solids[n]);	 
			}//next j
			
			TslInst tslNew;
			int nProps[]={nStartPosAssembly,nStartPos};	
			double dProps[]={dScale};		
			String sProps[]={tDisabledEntry,sFormat, sMaterial, sGrade, sQuality, sInformation,sApplyPosNum, sPrefixFormat,tSTDefault};//HSB-23198
			Map mapTsl;					
			GenBeam gbsTsl[0];
			Point3d ptsTsl[] = {_Pt0};
			if (!bDebug)
			{
				// strategy set to default to avoid endless creation
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl); 
			}
			if (tslNew.bIsValid())
			{
				numCreated++;	
				tslNew.transformBy(Vector3d(0, 0, 0));
			}		
			


		}//next i
			
	//endregion 

		reportNotice("\n" + numCreated + T(" |assemblies created|"));
		
		if (bDebug)
			dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 0);
		else
			eraseInstance();
		return;
	}

	else if (nPainter>0 && _kExecutionLoopCount==0)
	{ 
		PainterDefinition pd(sPainterDef);
		String format = pd.formatToResolve();
		String ftr = pd.formatToResolve();
		
		int numCreated;
		
	//region Legacy conversion creation
		if (sPainter == tLegacyAssemblySelectionSet)
		{ 
			TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;					
			int nProps[]={nStartPosAssembly,nStartPos};	double dProps[]={dScale};		
			String sProps[]={tDisabledEntry,sFormat, sMaterial, sGrade, sQuality, sInformation,sApplyPosNum, sStrategy};
			Map mapTsl;					GenBeam gbsTsl[0];
			mapTsl.setInt("SwapYZ", true); // a simple work aroundto set ECS of legacies
			
		// Create per definition tsl	
			for (int i=0;i<ents.length();i++) 
			{ 
				TslInst t= (TslInst)ents[i];
								
			// collect entities	
				Entity entsTsl[] = t.entity();
				GenBeam gbs[] = t.genBeam();
				for (int j=0;j<gbs.length();j++) 
					entsTsl.append(gbs[j]); 
		
				Point3d ptsTsl[] = {t.ptOrg()}; 

				if (!bDebug)
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl); 
				if (tslNew.bIsValid())
				{
					numCreated++;	
					tslNew.transformBy(Vector3d(0, 0, 0));
				}
					
			}//next i

			reportNotice("\n" + numCreated + T(" |assemblies created|"));
			if ( ! bDebug)eraseInstance();
			return;
		}
	//endregion 	
		
	
	//region Creation Filtering by label, sublable etc
	// Collect values
		String sUniques[0];
	
		String sNames[ents.length()];
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity& e = ents[i]; 
			
			String f = e.formatObject(ftr);
			if (f == format)f = ""; //refuse items which do not return a filter result
			sNames[i]=f;
			
		// collect unique filter conditions	
			if (f.length()>0 && sUniques.findNoCase(f,-1)<0)
				sUniques.append(f);			
		}//next i
		
	//region Create by unique 
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};		Point3d ptsTsl[] = {_Pt0};																		   
		int nProps[]={nStartPosAssembly,nStartPos};	double dProps[]={dScale};				
		String sProps[]={tDisabledEntry,sFormat, sMaterial, sGrade, sQuality, sInformation, sApplyPosNum, sStrategy};
		Map mapTsl;	

		//reportNotice("\n"+_ThisInst.handle() +" Uniques detected " + sUniques.length());	
		for (int i=0;i<sUniques.length();i++) 
		{ 
			String unique = sUniques[i];
			Entity entsTsl[0];
			double volumes[0];
			for (int j=0;j<ents.length();j++) 
				if (sNames[j]==unique)
				{
					entsTsl.append(ents[j]); 
					Body bd = ents[j].realBody();
					volumes.append(bd.volume());
					if (bDebug)
					{ 
						bd.transformBy(_XW * U(4));
						if(bDebug)bd.vis(i);
					}					

				}
				
		// order by volume
			for (int a=0;a<entsTsl.length();a++) 
				for (int b=0;b<entsTsl.length()-1;b++) 
					if (volumes[b]<volumes[b+1])
					{
						entsTsl.swap(b, b + 1);
						volumes.swap(b, b + 1);
					}
			
			if (entsTsl.length()>0)
				ptsTsl[0] = entsTsl.first().realBody().ptCen();

			if (bDebug)
			{ 
				Display dp(i);
				dp.textHeight(U(40));
				dp.draw(unique, ptsTsl[0], _XW, _YW, 0, 0, _kDeviceX);
			}
			else if (entsTsl.length()>0)
			{
				Entity e=entsTsl.first();
				sProps[1] = unique;
				sProps[2] = e.formatObject("@(Material:D)");
				sProps[3] = e.formatObject("@(Grade:D)");
				sProps[4] = e.formatObject("@(Quality:D)");
				sProps[5] = e.formatObject("@(Information:D)");
				
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				if (tslNew.bIsValid())
					//reportNotice("\n" + tslNew.handle() + " created");									 
					numCreated++;
			}
		}//next i	
		//endregion 

	//endregion 	

		if (!bDebug)
		{ 
			reportNotice("\n" + numCreated + T(" |assemblies created|"));
			eraseInstance();
			return;
		}
	}
	else if (!_bOnDbCreated) // HSB-23360 avoid infinite loop on creation
		addRecalcTrigger(_kErase, TRUE);
//endregion 

//region Assembly	
	sPainter.setReadOnly(bDebug?false:_kHidden);
	Body bodies[ents.length()];
	CoordSys cs(); // the coordSys of the assembly is derived from the biggest entity
	double dMaxVol;
	int bHasCurvedStyle;

//region Release items posnums
	if((_kNameLastChangedProp == sApplyPosNumName ||_kNameLastChangedProp == sStartPosName) && bApplyPosNum)
	{
	// Collect existing posnums
		GenBeam gbs[0];
		int posnums[0], cnt;
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam g = (GenBeam)ents[i];
			if (g.bIsValid())
			{
				int n = g.posnum();
				if (n>0)
				{ 
					cnt++;
					g.releasePosnum(false);
					gbs.append(g);
					posnums.append(n);				
				}
			}
		}
		
//	// Release any related posnum	

//		Entity entsGb[] = Group().collectEntities(true, GenBeam(), _kModelSpace);
//		for (int i=0;i<entsGb.length();i++) 
//		{ 
//			GenBeam g = (GenBeam)ents[i];
//			if (g.bIsValid())
//			{
//				int n = g.posnum();
//				if (posnums.find(n) >- 1)
//				{
//					g.releasePosnum(false);
//					cnt++;
//				}
//			}
//		}		
		if (cnt>-0)
			reportMessage("\n" + T("|Releasing| ") +cnt + T(" |posnums of related genbeams.|"));

		setExecutionLoops(2);
		return;
	}
//endregion 


//region Collect bodies and coordSys
	Point3d pts[0]; // collector for all vertices
	GenBeam genBeams[0];
	MetalPartCollectionEnt ces[0];
	BlockRef brefs[0];
	String sDefinitions[0];
	for (int i=0;i<ents.length();i++) 
	{ 
		Entity e = ents[i]; 
		setDependencyOnEntity(e);
		
		Beam bm = (Beam)e;
		GenBeam gb = (GenBeam)e;
		MetalPartCollectionEnt ce = (MetalPartCollectionEnt)e;
		BlockRef bref = (BlockRef)e;
		CoordSys csI();
		
		Body bd;
		if (bm.bIsValid())
		{
			csI = bm.coordSys();	csI.vis(2);
			bd = bm.envelopeBody(false, true);
			
			CurvedStyle curve = bm.curvedStyle();
			if (curve != _kStraight)
			{ 
				bHasCurvedStyle = true;
				if(bDebug)curve.closedCurve().vis(6);
			}
			
			
			if (bApplyPosNum && bm.posnum()<0)
				bm.assignPosnum(nStartPos<1?1:nStartPos, true);	
			genBeams.append(bm);	
			
		}
		else if (gb.bIsValid())
		{
			csI = gb.coordSys();csI.vis(3);
			bd = gb.envelopeBody(false, true);
			
			if (bApplyPosNum && gb.posnum()<0)
				gb.assignPosnum(nStartPos<1?1:nStartPos, true);	
			genBeams.append(gb);	
		}	
		else if (ce.bIsValid())
		{ 
			ces.append(ce);
			sDefinitions.append("mpce_" + ce.formatObject("@(Definition)")); // prefix definition to distinguish between brefs and ces	
					
			csI = ce.coordSys();csI.vis(4);			
			bd = GetMetalPartBody(ce, 1, PainterDefinition());
			if(bDebug)bd.vis(3);						
		}
		else if (bref.bIsValid())
		{ 
			brefs.append(bref);
			String def = bref.definition();
			sDefinitions.append("bref_" + def); // prefix definition to distinguish between brefs and ces
			
			csI = bref.coordSysScaled();csI.vis(6);
			Block block(def);
			LineSeg seg = block.getExtents();
	
			seg.transformBy(csI);
			//seg.vis(2);
			Point3d pt1 = seg.ptStart(), pt2 = seg.ptEnd();
			double dX = abs(csI.vecX().dotProduct(pt2-pt1));
			double dY = abs(csI.vecY().dotProduct(pt2-pt1));
			double dZ = abs(csI.vecZ().dotProduct(pt2-pt1));
			
			if (dX>dEps && dY>dEps && dZ>dEps)
			{ 
				bd = Body(seg.ptMid(), csI.vecX(), csI.vecY(), csI.vecZ(), dX, dY, dZ, 0, 0, 0);			
				if(bDebug)bd.vis(4);					
			}


		}				
		else	
		{			
			bd = e.realBody();
			sDefinitions.append("ent_" + e.typeDxfName());csI.vis(7);
		}
		
		if (!bd.isNull())
		{
			//reportNotice("\ni"+i  + e.formatObject(": @(ScriptName:D)@(Label:D) - @(Posnum:PL3;0:D) - @(Typename)"));
			bodies[i] = bd;
			pts.append(bd.allVertices());
			double d = bd.volume();
			if (d > dMaxVol)
			{
				entDefine = e;
				dMaxVol = d;
				cs = csI;

			}
		}
	}//next i

	int bHasInvalidPosnum;
	for (int i=0;i<genBeams.length();i++) 
	{ 
		int pos = genBeams[i].posnum();
		if (pos<1)
		{ 
			bHasInvalidPosnum = true;
			break;
		}
		 
	}//next i
	



//endregion 

//region Trigger 
	
//AddEntities
	String sTriggerAddEntities = T("|Add Entities|");
	addRecalcTrigger(_kContextRoot, sTriggerAddEntities );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddEntities)
	{

	// Collect assemblies of this dwg
		Entity entsAss[] = Group().collectEntities(true, TslInst(), _kModelSpace);

	// prompt for entities
		Entity entsAdd[0];
		PrEntity ssE(T("|Select entities|"), Entity());
		if (ssE.go())
			entsAdd.append(ssE.set());

	/// remove entities which are already assembled
		Entity entsX[0]; // a list of entities which will be reassigned or refused
		for (int i=0;i<entsAss.length();i++) 
		{ 
			TslInst t= (TslInst)entsAss[i];
			if (t.bIsValid()&& t.scriptName()==scriptName() && t!=this)
			{ 
				Entity entsT[] = t.entity();
				for (int j=entsAdd.length()-1; j>=0 ; j--) 
					if (entsT.find(entsAdd[j])>-1)
					{
						//reportMessage("\n"+entsAdd[j].handle() + T( " |cannot be added as it belongs to another assembly.|"));
						entsX.append(entsAdd[j]);
						entsAdd.removeAt(j); 
					}
			}		 
		}//next i
		
	// prompt for add or remove HSB-22961
		if (entsX.length()>0)
		{ 
			String ret = getString("\n" + T("|Reassign assembled entities| (") + entsX.length()+ ") " + T("|[Yes/No]|"));
			ret = ret.makeUpper().left(1);
			
		// Default is to reassign	
			if (ret !="N")
			{ 
			// release from previous and append to entsAdd	
				Entity removals[] = ReleaseFromAssembly(entsX);
				for (int i=0;i<removals.length();i++) 
					entsAdd.append(removals[i]); 
			}
		}

		if (bDebug)reportNotice("\nAdding "+ entsAdd.length());
		int num;
		for (int i=0;i<entsAdd.length();i++) 
		{ 
			Entity e = entsAdd[i];
			TslInst t = (TslInst)e;
			if(t.bIsValid() &&  t.scriptName() == scriptName()) 
			{ 
				continue;
			}			
			
			int n = _Entity.find(e);
			if (n<0)
			{
				num++;
				_Entity.append(e);
			}			
		}//next i
		reportMessage("\n"+num + T(" |entities append|"));
		
		setExecutionLoops(2);
		return;
	}
	
//RemoveEntities
	String sTriggerRemoveEntities = T("|Remove Entities|");
	addRecalcTrigger(_kContextRoot, sTriggerRemoveEntities );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveEntities)
	{
	// prompt for entities
		Entity entsX[0];
		PrEntity ssE(T("|Select entities|"), Entity());
		if (ssE.go())
			entsX.append(ssE.set());

		for (int i=0;i<entsX.length();i++) 
		{ 
			Entity& e = entsX[i];
			int n = _Entity.find(e);

			String keys[] = e.subMapXKeys();
			int bHasRef = RemoveDataLink(e); // HSB-22961
		// remove entity anyway	
			if (n>-1)
				_Entity.removeAt(n);
			//reportNotice("\n" + _Entity.length() + " remaining");
		}//next i

		if (_Entity.length()<1)
		{
			reportMessage("\n" + scriptName() + ": " +T("|All references have been removed, assembly definition erased.|"));			
			eraseInstance();
		}
		else
			setExecutionLoops(2);
		return;
	}	

	
//region Trigger Flip/Swap
		
//FlipX-Axis
	String sTriggerFlipX = T("|Flip X-Axis|");
	int bFlipX = _Map.getInt("FlipX");
	addRecalcTrigger(_kContextRoot, sTriggerFlipX);
	if (_bOnRecalc && _kExecuteKey==sTriggerFlipX)
	{
		bFlipX = bFlipX?false:true;	
		_Map.setInt("FlipX", bFlipX);
		setExecutionLoops(2);
		return;
	}

//FlipY-Axis
	String sTriggerFlipY = T("|Flip Y-Axis|");
	int bFlipY = _Map.getInt("FlipY");
	addRecalcTrigger(_kContextRoot, sTriggerFlipY);
	if (_bOnRecalc && _kExecuteKey==sTriggerFlipY)
	{
		bFlipY = bFlipY?false:true;	
		_Map.setInt("FlipY", bFlipY);
		setExecutionLoops(2);
		return;
	}

//FlipZ-Axis
	String sTriggerFlipZ = T("|Flip Z-Axis|");
	int bFlipZ = _Map.getInt("FlipZ");
	addRecalcTrigger(_kContextRoot, sTriggerFlipZ);
	if (_bOnRecalc && _kExecuteKey==sTriggerFlipZ)
	{
		bFlipZ = bFlipZ?false:true;	
		_Map.setInt("FlipZ", bFlipZ);
		setExecutionLoops(2);
		return;
	}

//Trigger SwapXY
	String sTriggerSwapXY = T("|Swap XY-Axis|");
	int bSwapXY = _Map.getInt("SwapXY");	
	addRecalcTrigger(_kContextRoot, sTriggerSwapXY );
	if (_bOnRecalc && _kExecuteKey==sTriggerSwapXY)
	{
		bSwapXY = bSwapXY?false:true;	
		_Map.setInt("SwapXY", bSwapXY);	
		setExecutionLoops(2);
		return;
	}

//Trigger SwapYZ
	String sTriggerSwapYZ = T("|Swap YZ-Axis|");
	int bSwapYZ = _Map.getInt("SwapYZ");	
	addRecalcTrigger(_kContextRoot, sTriggerSwapYZ );
	if (_bOnRecalc && _kExecuteKey==sTriggerSwapYZ)
	{
		bSwapYZ = bSwapYZ?false:true;	
		_Map.setInt("SwapYZ", bSwapYZ);	
		setExecutionLoops(2);
		return;
	}
	
//Trigger SwapXZ
	String sTriggerSwapXZ = T("|Swap XZ-Axis|");
	int bSwapXZ = _Map.getInt("SwapXZ");	
	addRecalcTrigger(_kContextRoot, sTriggerSwapXZ );
	if (_bOnRecalc && _kExecuteKey==sTriggerSwapXZ)
	{
		bSwapXZ = bSwapXZ?false:true;	
		_Map.setInt("SwapYZ", bSwapXZ);	
		setExecutionLoops(2);
		return;
	}//endregion 
		
//region Trigger RotateX
	double dRotationX = _Map.getDouble("RotationX");
	String sTriggerRotateX = T("|Rotate X-Axis|");
	addRecalcTrigger(_kContextRoot, sTriggerRotateX );
	if (_bOnRecalc && _kExecuteKey==sTriggerRotateX)
	{
		_Map.setDouble("RotationX", getDouble(T("|Rotation Angle|") + " ("+dRotationX+")"))	;	
		setExecutionLoops(2);
		return;
	}//endregion
	
//region Trigger HighlightGenbeams	// HSB-22130
	int nHighlight=_Map.getInt("Highlight");
	String sTriggerHighlightGenbeams = T("|Highlight Entities|");
	if(nHighlight)
		sTriggerHighlightGenbeams = T("|Don't highlight Entities|");
	addRecalcTrigger(_kContextRoot, sTriggerHighlightGenbeams );
	if (_bOnRecalc && (_kExecuteKey==sTriggerHighlightGenbeams || _kExecuteKey==sDoubleClick))
	{
		_Map.setInt("Highlight",!nHighlight);
		
		setExecutionLoops(2);
		return;
	}
	
	if(nHighlight)
	{ 
		Display dp(2),dpTop(2);
		// Iso
		dp.addHideDirection(_ZW);
		// Top
		dpTop.addViewDirection(_ZW);
		
		for (int ig=0;ig<_Entity.length();ig++) 
		{ 
			Body bd=_Entity[ig].realBody();
			PlaneProfile pp=bd.shadowProfile(Plane(bd.ptCen(),_ZW));
			PlaneProfile ppDir=bd.shadowProfile(Plane(bd.ptCen(),getViewDirection()));
//			if(gensArray.find(_Entity[ig])<0)
			{ 
				dp.draw(_Entity[ig].realBody());
				dpTop.draw(pp,_kDrawFilled,40);
				dp.draw(ppDir,_kDrawFilled,40);
				dp.draw(ppDir);
			}
		}//next ig
	}//endregion
	
//endregion	

//region Detect max dimension relative to coordSys
	double dX, dY, dZ;
	Point3d ptCen=_Pt0;
	for (int i=0;i<3;i++) 
	{ 
		Vector3d vecDir = i==0?cs.vecX():(i==1?cs.vecY():cs.vecZ());
		
		Line ln(_Pt0, vecDir);
		Point3d ptsDir[] = ln.orderPoints(ln.projectPoints(pts), dEps);
		if (ptsDir.length() < 1)continue;
		
		Point3d ptm = (ptsDir.last() + ptsDir.first()) * .5;
		ptCen += vecDir * vecDir.dotProduct(ptm - ptCen);
		
		double dD = abs(vecDir.dotProduct(ptsDir.last() - ptsDir.first()));
		
	// HSB-21717 catch tolerances on geometry comparison: Multiply by 100 to preserve two decimal places
		{
		    double rounded = round(dD * 100);
		    // Divide by 100 to restore the original scale
		    dD=rounded / 100;
		}
		if (i == 0) dX = dD;
		else if (i == 1) dY = dD;
		else dZ = dD;			
	}//next i		
//endregion 

//region Build assembly coordSys from max dimensions
	vecX = cs.vecX();
	vecY = cs.vecY();
	vecZ = cs.vecZ();
	
	// always pointing upwards in world
	if (!vecX.isPerpendicularTo(_ZW) && vecX.dotProduct(_ZW)<0)
	{ 
		vecX *= -1;
		vecY *= -1;
	}
	
	// vecY maps the second largest dimension
	if (!bHasCurvedStyle && dZ>dY)
	{ 
		Vector3d vec = vecY;
		vecY = vecZ;
		vecZ = vec;
		double d = dY;
		dY = dZ;
		dZ = d;
	}

	
	if (bFlipX)
	{ 
		vecX *= -1;
		vecY *= -1;
	}
	if (bFlipY)
	{ 
		vecY *= -1;
		vecZ *= -1;
	}
	if (bFlipZ)
	{ 
		vecX *= -1;
		vecZ *= -1;
	}
	if (bSwapXY)
	{ 
		Vector3d vec = vecY;
		vecY = vecX;
		vecX = - vec;
		
		double d = dY;
		dY = dX;
		dX = d;
	}
	if (bSwapYZ)
	{ 
		Vector3d vec = vecY;
		vecY = vecZ;
		vecZ = - vec;
		
		double d = dY;
		dY = dZ;
		dZ = d;
	}
	if (bSwapXZ)
	{ 
		Vector3d vec = vecX;
		vecX = vecZ;
		vecZ = - vec;
		
		double d = dX;
		dX = dZ;
		dZ = d;
	}	
	if (dRotationX!=0)
	{ 
		CoordSys csRot;
		csRot.setToRotation(dRotationX, vecX, ptCen);
		vecY.transformBy(csRot);
		vecZ.transformBy(csRot);
	}
	CoordSys csx(ptCen, vecX, vecY, vecZ);
	if(bDebug)csx.vis(7);//bodies.length());
	
//endregion 

//endregion 


//region Draw Linked during drag
	if (bDrag)
	{ 
		DrawViewShadow(ents,-1);// -1 = draw with entity color
		return;	
	}	
//endregion

//region Get shadows in main view directions
	cs = CoordSys(ptCen, vecX, vecY, vecZ);
	PlaneProfile ppX(CoordSys(ptCen, -vecY, -vecZ, vecX));
	PlaneProfile ppY(CoordSys(ptCen, vecX, -vecZ, vecY));
	PlaneProfile ppZ(csx);
	Plane pnX(ptCen, vecX);
	Plane pnY(ptCen, vecY);
	Plane pnZ(ptCen, vecZ);
	for (int j=0;j<3;j++) 
	{ 	
		PlaneProfile& ppj= j==0?ppX:(j==1?ppY:ppZ);
		Plane pn(ptCen, ppj.coordSys().vecZ());
		for (int i=0;i<bodies.length();i++) 
		{ 
			PlaneProfile pp= bodies[i].shadowProfile(pn);
			pp.shrink(-dEps);
			ppj.unionWith(pp);		 
		}//next i
		ppj.shrink(dEps);	
	}//next j	
	
	if (bDebug)
	{ 
		ppX.vis(1);
		ppY.vis(3);
		ppZ.vis(150);	
	}

//endregion 


//region Property Resolving

	
//region Weight and COG
	Point3d ptCenGrav = ptCen;	
	double weight;
	{ 
		Map mapIO;
		Map mapEntities;
		for (int i=0;i<ents.length();i++)
		{
			Entity& e = ents[i];
			GenBeam gb = (GenBeam)e;
			if (gb.bIsValid() && gb.bIsDummy())
			{ 
				continue;
			}
			String ss = e.typeDxfName();
			if (e.realBodyTry().isNull())
			{ 
				continue;
			}
			mapEntities.appendEntity("Entity", e);
			
//			Map mapIO2;
//			Map mapEntities2;
//			mapEntities2.appendEntity("Entity", e);
//			mapIO2.setMap("Entity[]",mapEntities2);
//			TslInst().callMapIO("hsbCenterOfGravity", mapIO2);
//			
//			Map mapX;
//			mapX.setDouble("Weight", mapIO2.getDouble("Weight"));
//			e.setSubMapX("COG", mapX);			
		}

		mapIO.setMap("Entity[]",mapEntities);
		TslInst().callMapIO("hsbCenterOfGravity", mapIO);
		ptCenGrav = mapIO.getPoint3d("ptCen");// returning the center of gravity
		weight = mapIO.getDouble("Weight");// returning the weight	
		dWeight.set(weight);
	}//endregion 

	
//region Format Resolving #1
	String k;
	String vars[] = this.formatObjectVariables();
	Map mapAdd;

	
	String varsDef[] = entDefine.formatObjectVariables().sorted();
	String sTypeDef ="Ref_";//entDefine.formatObject("@(TypeName)");
	
	for (int i=0;i<varsDef.length();i++) 
	{ 
		k = sTypeDef+varsDef[i];
		if (vars.findNoCase(k, -1)>-1){ continue;}
		
		String value = entDefine.formatObject("@(" + varsDef[i] + ")");
		if (k.find("isParallelTo",0,false)>-1 || k.find("isPerpendicularTo",0,false)>-1)
			mapAdd.setString(k, value); 
		else if (k.find("Height",0,false)>-1 || k.find("Width",0,false)>-1  || k.find("Length",0,false)>-1   || k.find("Depth",0,false)>-1)
			mapAdd.setDouble(k, value.atof(), _kLength); 
		else if (k.find("Area",0,false)>-1)
			mapAdd.setDouble(k, value.atof(), _kArea); 
		else if (k.find("Index",0,false)>-1)
			mapAdd.setInt(k, value.atoi()); 

		else if (k.find("Volume",0,false)>-1) 
			mapAdd.setDouble(k, value.atof(),_kVolume); 
		else
			mapAdd.setString(k, value); 
		vars.append(k);

	}//next i
	
	
	
		
//endregion 	

//endregion 	

//region PosNumCriteria
	int pos = this.posnum();
	int bPosHasChanged;
	
	String sName=sFormat, sResolvedPrefix;
	sResolvedPrefix = this.formatObject(sPrefixFormat, mapAdd).trimLeft().trimRight();		
	int nPrefixIndex=_Map.getInt("PrefixIndex"); // 0 if not found
	int bRemoteLock = _Map.getInt("Locked"); // a flag which is set if the prefix index is changed remotly
	//reportNotice("\n" + this.handle() + " starting with prefixIndex " +nPrefixIndex);
	//k="PrefixIncrement";	int nPrefixIncrement=_Map.hasInt(k)?1:_Map.getInt(k);




	if (!bDrag)
	{ 
	//region collect and append posnums
		int posnums[0];// collection of posnums to build posnum criteria of the assembly
		// HSB-20646 string  params added
		String compareKey = dX+"_"+dY+"_"+dZ + "_" + sMaterial+ "_" + sGrade+ "_" + sQuality+ "_" + sInformation+"_"+sResolvedPrefix;
		
		compareKey+= GetCompareKeyByProfile(CoordSys (ptCen, vecX, vecY, vecZ), ppX, ppY, ppZ);

		for (int i=0;i<genBeams.length();i++) 
		{  
			int pos = genBeams[i].posnum();
			if (pos >- 1)posnums.append(pos);
		}//next i
		posnums = posnums.sorted();
		for (int i=0;i<posnums.length();i++) 
			compareKey += "_"+posnums[i]; 				
		//endregion 	

 	//region collect and append definitions		
		sDefinitions= sDefinitions.sorted();
		for (int i=0;i<sDefinitions.length();i++) 
		{
			String definition = sDefinitions[i];
			compareKey += "-"+definition;	
		}
		
		// HSB-22961 append sorted center offsets for each metalpart or block
		{ 
			int nRound = 10;
			Point3d ptCens[0];
			for (int i=0;i<ents.length();i++) 
				if (ces.find(ents[i])>-1 || brefs.find(ents[i])>-1)
					ptCens.append(bodies[i].ptCen());
			
			ptCens = Line(ptCen,vecZ).orderPoints(ptCens);
			ptCens = Line(ptCen,vecY).orderPoints(ptCens);
			ptCens = Line(ptCen,vecX).orderPoints(ptCens);
			
			for (int i=0;i<ptCens.length();i++) 
			{ 
				double x = vecX.dotProduct(ptCens[i] - ptCen);x = round(x * nRound)/nRound;
				double y = vecY.dotProduct(ptCens[i] - ptCen);y = round(y * nRound)/nRound;
				double z = vecZ.dotProduct(ptCens[i] - ptCen);z = round(z * nRound)/nRound;
				
				compareKey += " CE" + x + "_" + y + "_" + z;
				ptCens[i].vis(i); 
				 
			}//next i
		}

		//endregion 

		//if (bDebug)		reportNotice("\n" + this.handle() + " " + compareKey);		
		setCompareKey(compareKey);	
		
		
		if (pos<0 || compareKey!=_Map.getString("compareKey"))
		{ 
			this.releasePosnum();
			this.assignPosnum(nStartPosAssembly, true); 
			pos = this.posnum();
		}
		
		_Map.setString("compareKey", compareKey);
		
		bPosHasChanged = _Map.hasInt(kPreviousPos) && _Map.getInt(kPreviousPos) != pos;
		if (bPosHasChanged)
		{ 
			if (bDebug)reportNotice("\n"+this.handle()+" pos has changed");
			_Map.removeAt("PrefixIndex", true);
			nPrefixIndex = 0;
			setExecutionLoops(2);
		}
	}

//endregion 

//region Assembly Symbol Solid
	double dAxisMin = U(20);
	double dXS=dAxisMin*dScale, dYS=dAxisMin*dScale, dZS=dAxisMin*dScale;
	if (dX>=dY && dX>=dZ)
	{ 
		dXS *= 2;
		if (dY>=dZ)
			dZS *= .5;
		else
			dYS *= .5;
	}
	else if (dY>=dX && dY>=dZ)
	{ 
		dYS *= 2;
		if (dX>=dZ)
			dZS *= .5;
		else
			dXS *= .5;
	}
	else
	{ 
		dZS *= 2;
		if (dX>=dY)
			dYS *= .5;
		else
			dXS *= .5;
	}
	
	Display dpModel(bHasInvalidPosnum?1:-1);
	double dDims[] ={ dXS, dYS, dZS};
	dDims = dDims.sorted();
	double textHeight = dDims.length()>0?.25*dDims.first():U(20);
	dpModel.textHeight(textHeight);
	
	
//endregion 

//region Format Resolving #2


	k="posnum"; if (vars.findNoCase(k,-1)<0)	{mapAdd.setInt(k, pos); vars.append(k);}	
	k="Length"; if (vars.findNoCase(k,-1)<0)	{mapAdd.setDouble(k, dX); vars.append(k);}
	k="Width"; if (vars.findNoCase(k,-1)<0)		{mapAdd.setDouble(k, dY); vars.append(k);}
	k="Height"; if (vars.findNoCase(k,-1)<0)	{mapAdd.setDouble(k, dZ); vars.append(k);}
	k="Weight"; if (vars.findNoCase(k,-1)<0)	{mapAdd.setDouble(k, weight);vars.append(k);}
	
//region Prefix based Increment	
	int bAddPrefix = true;
	if (sResolvedPrefix.length()>0 && !bRemoteLock)
	{ 
		String prefix = sResolvedPrefix.makeUpper();
		//if (bDebug)reportNotice("\n"+this.handle()+ " Prefix: "+prefix+" executing...");
		
	// Collect all assemblies with the same resolved prefix
		Entity ents[0];
		String names[] = { (bDebug?kAssemblyDef:scriptName())};
		TslInst tsls[] = FilterTslsByName(ents, names); // all assemblies
		
		TslInst assemblies[0];// assemblies with same prefix
		int nAssemblyIndices[0]; // the collected prefix indices
		
		TslInst siblings[0]; // identical assemblies, same pos and prefix
		int nSiblingIndices[0]; // the collected prefix indices
		
		if (bDebug)reportNotice("\n   "+this.handle()+ ":   " + tsls.length()+" tsl assemblies found");
		
		int nUniquePosNums[0], nUniqueIndices[0];
		String sUniquePrefixes[0];
		
		for (int i=0;i<tsls.length();i++) 
		{ 
			TslInst& t = tsls[i];
			Map m = t.map();
			String prefixI = m.getString("PrefixResolved").makeUpper();
			
			if (sUniquePrefixes.find(prefixI)<0)
				sUniquePrefixes.append(prefixI);			
	
			if (prefixI==prefix)
			{	
				int posI = t.posnum();
				if (nUniquePosNums.find(posI)<0)
					nUniquePosNums.append(posI);
				
				int index = m.getInt("PrefixIndex");
				if (index>0 && nUniqueIndices.find(index)<0)
					nUniqueIndices.append(index);
					
				if (posI == pos)
				{
					siblings.append(t);
					nSiblingIndices.append(index);	
				}
				assemblies.append(t);
				nAssemblyIndices.append(index);		
			}
		}//next i
		nUniquePosNums = nUniquePosNums.sorted();
		nUniqueIndices = nUniqueIndices.sorted();
		if (bDebug)
			reportNotice("\n   "+this.handle()+ "\n   " + 
			siblings.length()+" identical assemblies found wih prefix " + prefix +"\n   " +
			assemblies.length() + " with same prefix");
			//+ " prefixes: " + sUniquePrefixes);// uqPos:" +nUniquePosNums+ " uqInds:" +nUniqueIndices);


	// No prefix index for assemblies which appear to be unique		
		if (nUniquePosNums.length()==1)// && assemblies.length()==1)
		{ 
			bAddPrefix = false;
		}


	//region Trigger ResetIndex
		String sTriggerResetIndex = T("|Reset Index|");
		//if (nPrefixIndex>assemblies.length())
		if (bAddPrefix)
			addRecalcTrigger(_kContextRoot, sTriggerResetIndex );
		if (_bOnRecalc && _kExecuteKey==sTriggerResetIndex)
		{
			_Map.removeAt("PrefixIndex", true);		
			setExecutionLoops(2);
			
			pushCommandOnCommandStack("_HSB_Recalc");
			pushCommandOnCommandStack("(handent \""+this.handle()+"\")");	
			pushCommandOnCommandStack("(Command \"\")");
	
			return;
		}//endregion	
	
	//region Trigger SwapIndices
		String sTriggerSwapIndices = T("|Swap Indices|");
		if (assemblies.length()>1 && bAddPrefix)
			addRecalcTrigger(_kContextRoot, sTriggerSwapIndices );
		if (_bOnRecalc && _kExecuteKey==sTriggerSwapIndices)
		{

		//region PrPoint with Jig
			PrPoint ssP(T("|Pick a point near the assembly to swap the index|"), _Pt0); // second argument will set _PtBase in map
		    ssP.setSnapMode(TRUE, 0); // turn off all snaps
		    Map mapArgs, mapOthers, mapSiblings;
			PlaneProfile ppOthers[0], ppSiblings[0];
			TslInst tslOthers[0], tslSiblings[0];
			mapArgs.setPoint3d("pt1", this.ptOrg());
			mapArgs.setString("ResolvedPrefix", sResolvedPrefix);
			mapArgs.setInt("PrefixIndex", nPrefixIndex);
			for (int i=0;i<assemblies.length();i++) 
			{ 
				TslInst& t = assemblies[i];
				Map m = t.map();
				String prefixI = m.getString("PrefixResolved").makeUpper();
				PlaneProfile pp = GetViewShadow(t.entity());
				if (t.posnum() == this.posnum())
				{
					mapSiblings.appendPlaneProfile("pp", pp);
					ppSiblings.append(pp);
					tslSiblings.append(t);
					
				}
				else
				{
					mapOthers.appendPlaneProfile("pp", pp);
					ppOthers.append(pp);
					mapOthers.appendInt("index", nAssemblyIndices[i]);
					tslOthers.append(t);
				}
				 
			}//next i
			mapArgs.appendMap("Sibling[]", mapSiblings);
			mapArgs.appendMap("Other[]", mapOthers);


		    int nGoJig = -1;
		    
		    TslInst tslOther;
		    
		    while (nGoJig != _kOk && nGoJig != _kNone)
		    {
		        nGoJig = ssP.goJig(kJigSwapIndex, mapArgs); 
		        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
		        
		        if (nGoJig == _kOk)
		        {
		            Point3d ptPick = ssP.value(); //retrieve the selected point

				    double dMin = U(10e6);
				    int n=GetClosestIndex(ppOthers, ptPick);         
		            if (n>-1)
		            { 
		            	tslOther = tslOthers[n];	            	
		            	int otherIndex =tslOther.map().getInt("PrefixIndex");
		            	int thisIndex = nPrefixIndex;
		            	
		            	if (otherIndex>0 && thisIndex>0)
		            	{ 
		            		
		            	// set indices
		            		TslInst tslPushs[0];
		            		// collect targets		            		
		            		if(bDebug)reportNotice("\nfrom " +thisIndex + "->"+otherIndex+ "\ntarget " + tslOthers);
		            		for (int j=0;j<tslOthers.length();j++) 
		            		{ 
		            			TslInst& assembly = tslOthers[j];
		            			int index = assembly.map().getInt("PrefixIndex");		            			
		            			if (index==otherIndex && thisIndex>-1)
		            			{ 
		            				Map m = assembly.map();
				            		m.setInt("PrefixIndex", thisIndex);
				            		m.setInt("Locked", true);
				            		assembly.setMap(m);	
				            		
				            		tslPushs.append(assembly);				            		
				            		if(bDebug)reportNotice("\n   target " +index + " modified to " + thisIndex+ " vs " + assembly.map().getInt("PrefixIndex"));
		            			}
		            		}
		            		// collect sources
		            		if(bDebug)reportNotice("\nsource " + tslSiblings);
		            		for (int j=0;j<tslSiblings.length();j++)
		            		{ 
		            			TslInst& assembly = tslSiblings[j];
		            			int index = assembly.map().getInt("PrefixIndex");
		            			if (assembly==this)
		            			{ 
		            				nPrefixIndex = otherIndex;
		            				_Map.setInt("PrefixIndex", otherIndex);
		            				if(bDebug)reportNotice("\n   ME " +index + " modified to " + otherIndex + " vs " + _Map.getInt("PrefixIndex"));
		            				continue;
		            			}
		            			
		            			else if (index==thisIndex && otherIndex>-1)
		            			{ 
		            				Map m = assembly.map();
				            		m.setInt("PrefixIndex", otherIndex);
				            		m.setInt("Locked", true);
				            		assembly.setMap(m);	
				            		
				            		tslPushs.append(assembly);				            		
				            		if(bDebug)reportNotice("\n   source " +index + " modified to " + otherIndex + " vs " + assembly.map().getInt("PrefixIndex"));
		            			}
		            		}		            		
		            	// push
		            		for (int j=0;j<tslPushs.length();j++)	            		
							{
								if(bDebug)reportNotice("\n   pushing " + tslPushs[j].handle());
								
			            		pushCommandOnCommandStack("_HSB_Recalc");
								pushCommandOnCommandStack("(handent \""+tslPushs[j].handle()+"\")");	
								pushCommandOnCommandStack("(Command \"\")");								
							}

		            	}
		            	
		            	
		            }
		            
		            
		        }
		        else if (nGoJig == _kCancel)
		        { 
		            break;
		        }
		    }			
		//endregion 

			setExecutionLoops(2);
			return;
		}
	//Trigger SwapIndices //endregion	
	

	// AddPrefix
		if (bAddPrefix)
		{ 
		// Check if the assigned index can be kept	
			if (nPrefixIndex < 1)setExecutionLoops(2);
			int bKeepExisting = (!bPosHasChanged && nPrefixIndex > 0);// && nPrefixIndex <= assemblies.length();
	
		// Check if one of the identical assemblies has a lower prefix
			int nMinIndex = -1;
			for (int i=0;i<siblings.length();i++) 
			{ 
				int ind = nSiblingIndices[i]; 	
				if (ind> 0 && (nMinIndex == -1 || ind < nMinIndex))
					nMinIndex = ind;
			}//next i
			if (nMinIndex>-1)
			{
				if(nMinIndex==nPrefixIndex)
					bKeepExisting = true;
				else
					nPrefixIndex = nMinIndex;
			}
		
		// assign new index	
			if (bPosHasChanged || nMinIndex<0)
			{ 
				//reportNotice("\nAssign new, Loop "+_kExecutionLoopCount + "\n	"+this.handle() + " "+ nUniquePosNums + " contains ? "+this.posnum() + "\n	uniqueindices: " + nUniqueIndices);			
				nPrefixIndex=1;
				for (int i=0;i<nUniqueIndices.length();i++) 
				{ 
					if (nPrefixIndex==nUniqueIndices[i])
					{
						nPrefixIndex++;
					}
					else // accept free index
					{ 
						break;
					}				
				}
				//reportNotice("\n...." + nPrefixIndex);
			}				
		}

		

	
	}
	if (bRemoteLock)
	{ 
		if (bDebug)reportNotice("\n"+this.handle()+ " is locked for prefix");
		_Map.removeAt("Locked", true);	
	}
	//endregion 	

//		
//	_Map.setDouble("Length", dX);
//	_Map.setDouble("Width", dY);
//	_Map.setDouble("Height", dZ);

	String format = sFormat;
	if (bAddPrefix)
	{
		k = "PrefixIndex"; 			mapAdd.setInt(k, nPrefixIndex);
	}
	// purge potential prefix index variables // HSB-23198 potential prefix variables will be purged if no valid prefix index can be collected
	else
	{ 
		int x1 = format.find("@(Prefixindex", 0, false);
		if (x1>-1)
		{ 
			String arg = format.right(format.length()-x1);
			int x2 = arg.find(")", 0, false);
			if (x2>-1)
			{
				arg = arg.left(x2+1);
				format.replace(arg, "");
			}
		}
	}
	
	// get name by specified format
	if (format.find("@(",0,false)>-1)
	{ 
		sName = this.formatObject(format, mapAdd);
	}
		
		
	// HSB-22961 if no prefix attached and last char is '.' remove '.' of formatting arg (if any)
	if (!bAddPrefix && (sName.right(1)=="." || sName.right(1)=="-" || sName.right(1)=="_") )
		sName = sName.left(sName.length() - 1);
		
	// publish additional to properties	
	sFormat.setDefinesFormatting(this,mapAdd);
	sPrefixFormat.setDefinesFormatting(this,mapAdd);

	k = "Length"; 		if (abs(_Map.getDouble(k)-dX)>dEps)	_Map.setDouble(k, dX);
	k = "Width"; 		if (abs(_Map.getDouble(k)-dY)>dEps)	_Map.setDouble(k, dY);
	k = "Height"; 		if (abs(_Map.getDouble(k)-dZ)>dEps)	_Map.setDouble(k, dZ);
	

	k = "Name"; 			if (_Map.getString(k)!=sName)			_Map.setString(k, sName);
	k = "Prefix"; 			if (_Map.getString(k)!=sPrefixFormat)	_Map.setString(k, sPrefixFormat);	
	k = "PrefixResolved"; 	if (_Map.getString(k)!=sResolvedPrefix)	_Map.setString(k, sResolvedPrefix);		
	k = "PrefixIndex";
	if (!bAddPrefix)
		_Map.removeAt(k, true);
	else if (_Map.getInt(k)!=nPrefixIndex)		
	{
		//reportNotice("\nAssign new index ´, Loop " + _kExecutionLoopCount + " index = " + nPrefixIndex);
		_Map.setInt(k, nPrefixIndex);
	}
	_Map.setInt(kPreviousPos, pos);



	
		
	Body bd(ptCenGrav, vecX, vecY, vecZ, dXS, dYS, dZS, 0, 0, 0);
	dpModel.draw(sName, ptCenGrav, vecX, vecY, 0, 0,_kDevice);
	dpModel.draw(bd);
	
//endregion 


//region Extent subMapX of asssembled entitities with coordSys relation
//	// this will be needed to identify items in relation to the view direction in shopdrawings
//	Vector3d vecDirs[] = { vecX, vecY, vecZ};
//	String keys[] ={ "IsCodirectionalToAssemblyX", "IsCodirectionalToAssemblyY", "IsCodirectionalToAssemblyZ"};
	for (int i=0;i<ents.length();i++) 
	{ 
		Entity& e= ents[i]; 	

		Map mapX = e.subMapX(kDataLink);
		mapX.setEntity(kAssemblyDef, this);
		e.setSubMapX(kDataLink, mapX);
	}//next i
	
//endregion 


//region Display coordinate axises
	_Pt0 = ptCenGrav;
	
	Point3d ptAxis=ptCenGrav;
	double dXAxis = .5*dX;	if(dX > dAxisMin*2) dXAxis = dAxisMin*2;
	double dYAxis = .5*dY;	if(dY > dAxisMin) dYAxis = dAxisMin ;
	double dZAxis = .5*dZ;	if(dZ > dAxisMin) dZAxis = dAxisMin ;
	if (dScale > 0)
	{
		dXAxis *= dScale;
		dYAxis *= dScale;
		dZAxis *= dScale;
	}

	//PLine plReference (_PtG[0], _PtG[1]);
	PLine plXPos (ptAxis, ptAxis+vecX*dXAxis);
	PLine plXNeg (ptAxis, ptAxis-vecX*dXAxis);
	PLine plYPos (ptAxis, ptAxis+vecY*dYAxis);
	PLine plYNeg (ptAxis, ptAxis-vecY*dYAxis);
	PLine plZPos (ptAxis, ptAxis+vecZ*dZAxis);
	PLine plZNeg (ptAxis, ptAxis-vecZ*dZAxis);

	Display dpAxis(-1);
	dpAxis.color(1);		dpAxis.draw(plXPos);
	//dpAxis.color(14);		dpAxis.draw(plXNeg);
	dpAxis.color(3);		dpAxis.draw(plYPos);
	//dpAxis.color(96);		dpAxis.draw(plYNeg);
	dpAxis.color(150);		dpAxis.draw(plZPos);
	//dpAxis.color(154);		dpAxis.draw(plZNeg);
//endregion 

//region Publish data
	_XE = vecX;
	_YE = vecY;
	_ZE = vecZ;
	
	if (!bDrag)
	{ 
		Map mapX;
		mapX.setVector3d("vecX", vecX);
		mapX.setVector3d("vecY", vecY);
		mapX.setVector3d("vecZ", vecZ);
		mapX.setPlaneProfile("ppX", ppX);
		mapX.setPlaneProfile("ppY", ppY);
		mapX.setPlaneProfile("ppZ", ppZ);
		
		if (entDefine.bIsValid())
			assignToGroups(entDefine, 'T');
			
		this.setSubMapX(kAssemblyDef, mapX);
		
		
	}

	
	addRecalcTrigger(_kGripPointDrag, "_Pt0");	
	if(bDebug)_Pt0.vis(1);
//endregion 


		
// on erase	
	if (_bOnDbErase && sStrategy!=tSTContact)
	{ 
		//reportNotice("\nOnErase");
		
		String names[0];
		int numTotal, nums[0];
		
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity& e =  ents[i]; 
			int bRemoved = RemoveDataLink(e);

			if (bRemoved)
			{ 
				String name = e.formatObject("@(ScriptName:D)@(Definition:D)");
				if (name.length()<1)
					name = e.formatObject("@(TypeName)");
	
				int n = names.findNoCase(name ,- 1);
				if (n<0)
				{ 
					nums.append(1);
					names.append(name);
				}
				else
				{ 
					nums[n]++;
				}
				numTotal++;
			}
	
		}//next i
		reportMessage("\n"+sName + ": "+ + numTotal+"/"+ents.length() + T(" |entities have been released|, "));
		for (int i=0;i<nums.length();i++) 
			reportMessage((i>0?", ":"") + names[i]+ "("+nums[i]+")"); 

		return;
	}


////region HSB-22961 Validate datalinks to assemblies
//	// TODO observe if negative impact on performance
//	{ 
//		Entity ents[] = Group().collectEntities(true, Entity(), _kModelSpace, false);
//		for (int i=0;i<ents.length();i++) 
//		{ 
//			Entity& e = ents[i];
//			PurgeAssemblyReference(e);
//		}//next i
//		
//	}	
////endregion 






























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
        <int nm="BreakPoint" vl="2702" />
        <int nm="BreakPoint" vl="1659" />
        <int nm="BreakPoint" vl="1351" />
        <int nm="BreakPoint" vl="385" />
        <int nm="BreakPoint" vl="2624" />
        <int nm="BreakPoint" vl="2381" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23933 index is suppressed when only a single, unique definition is found" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="4/24/2025 9:48:37 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23360 bugfix avoid infinite loop on creation" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="1/24/2025 10:15:29 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23360 purging dataLink submapX entry on erase of assembly, requires 27.3.4 or higher" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="1/22/2025 9:21:43 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23198 potential prefix variables will be purged if no valid prefix index can be collected" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="12/16/2024 2:00:43 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23198 byContact now accepts also intersecting solids, prefix property fix on insert" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="12/16/2024 12:05:36 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23105 bugfix showDialog with no existing painter definitions" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="12/11/2024 4:00:22 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23105 new property for creation strategy: byContact bundles items which are making contact to eachother" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="12/5/2024 12:14:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22961 debug message removed" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="12/2/2024 3:55:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22961 strategy of prefix indices improved, add/remove commands and performance improved, all painter  definitions accepted" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="11/12/2024 12:14:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22715 duplicates prevented when using painter definitions" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/23/2024 4:45:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22680 subindices improved, new commands to swap indices if enabled" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="9/16/2024 4:11:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22486 child entities reference to assembly via DataLink submapx, i.e. @(DataLink.AssemblyDefinition.Name:D)" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="8/1/2024 9:17:04 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22308 2D Blocks no longer contribute to the solid." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="6/21/2024 4:29:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22278 a new property 'Prefix' has been added to support prefix based indexing of the assembly name" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="6/19/2024 11:19:44 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22130: Add command to highlight entities of the assembly" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="5/31/2024 8:16:09 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21727 posnum assignment improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="5/2/2024 9:28:09 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21717 catching solid tolerances for posnum generation" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="3/21/2024 9:25:54 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21168 new properties to specify start posnum of assembly and its items" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="1/19/2024 11:26:08 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20820 new option to rotate coordSys" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="12/1/2023 2:55:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20646 comparison key ignores box location for posnum creation" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="11/24/2023 4:39:26 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20646 new property to enable/diable automatic numbering of assembeld genbeams, supporting massgroups as parent container if it contains genbeams" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="11/22/2023 3:07:10 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20036 assembly name (format) and information written to submapX &quot;AssemblyDefinition.Name&quot; and &quot;AssemblyDefinition.Information&quot;" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="9/12/2023 10:08:05 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20026 new read only property 'weight', base point set to point of gravity" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="9/12/2023 9:00:37 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19578 coordsys on legacy creation adjusted" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="7/20/2023 1:54:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19578 legacy creation based on stud assemblies added, bounding dimensions published as length, width and height" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="7/20/2023 1:21:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19490 property 'Name' renamed to 'Format' accepting format expressions, automatic posnum generation added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="7/20/2023 10:14:49 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18761 bugfix collection entity is referenced and in block edit mode" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="4/20/2023 4:43:56 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15141 beta version of method to collect quader from collectionEntity renamed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="3/16/2023 8:21:04 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18207 supports assemblies containing curved beams" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="3/7/2023 12:04:48 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18207 performance enhanced, new commands to alter coordinate system" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="3/6/2023 3:25:09 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18207 initial version of assembly definition" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="3/3/2023 8:41:15 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End