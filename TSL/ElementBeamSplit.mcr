#Version 8
#BeginDescription
#Versions:
1.3 23.05.2022 HSB-15513: add option to select entities manually Author: Marsel Nakuci
1.2 10.05.2022 HSB-15441: Support truss entities as male (cutting) beams Author: Marsel Nakuci
Version 1.1 11.04.2022 HSB-15168 plugin mode improved , Author Thorsten Huck
Version 1.0 08.04.2022 HSB-15168 initail version , Author Thorsten Huck



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.3 23.05.2022 HSB-15513: add option to select entities manually Author: Marsel Nakuci
// 1.2 10.05.2022 HSB-15441: Support truss entities as male (cutting) beams Author: Marsel Nakuci
// 1.1 11.04.2022 HSB-15168 plugin mode improved , Author Thorsten Huck
// 1.0 08.04.2022 HSB-15168 initail version , Author Thorsten Huck

/// <insert Lang=en>
/// Select elements
/// </insert>

// <summary Lang=en>
// This tsl splits beams in an element 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ElementBeamSplit")) TSLCONTENT
//endregion


//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String kLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
	String kBeam = "Beam";
	String kPainterCollection = "ElementBeamSplit";
	String kBySelection =T("|<bySelection>|");
	String tParallelX = T("|X-Parallel|");
	String tParallelY = T("|Y-Parallel|");
	String tDefault =T("|<Default>|");
	String kTruss = T("|Truss|");
	String sMaleDefaultSelections[] = { tParallelX,tParallelY};
	String sFemaleDefaultSelections[] = {tDefault};	
	
//end Constants//endregion
	
//region Properties
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();
	// if a collection was found consider only those of the collection, else take all
	int bHasPainterCollection; 
	for (int i=0;i<sPainters.length();i++) 	{if (sPainters[i].find(kPainterCollection,0,false)>-1){bHasPainterCollection=true;break;}}//next i
	if (bHasPainterCollection)
		for (int i=sPainters.length()-1; i>=0 ; i--) 
			if (sPainters[i].find(kPainterCollection,0,false)<0)
				sPainters.removeAt(i);	
	sPainters = sPainters.sorted();

//region Create Painter by Property
	String sPainterStreamName=T("|Painter Definition|");	
	PropString sPainterStreamMale(2, "", sPainterStreamName);	
	sPainterStreamMale.setDescription(T("|Stores the data of the male painter definition|"));
	sPainterStreamMale.setCategory(category);
	sPainterStreamMale.setReadOnly(bDebug?false:_kHidden);

	if (_bOnDbCreated)
	{
		String _stream = sPainterStreamMale;
		if (_stream.length() > 0)
		{
			// get painter definition from property string	
			Map m;
			m.setDxContent(_stream, true);
			String name = m.getString("Name");
			String type = m.getString("Type").makeUpper();
			String filter = m.getString("Filter");
			String format = m.getString("Format");
			
			// create definition if not present	
			if (m.hasString("Name") && m.hasString("Type") && sPainters.findNoCase(name ,- 1) < 0)//name.find(sPainterCollection, 0, false) >- 1 &&
			{
				PainterDefinition pd(name);
				pd.dbCreate();
				pd.setType(type);
				pd.setFilter(filter);
				pd.setFormat(format);
				
				if (pd.bIsValid())
				{
					sPainters.append(name);
					
				}
			}
		}
	}
	
	String sPainterStreamFemaleName=T("|Painter Definition| ");	
	PropString sPainterStreamFemale(3, "", sPainterStreamFemaleName);	
	sPainterStreamFemale.setDescription(T("|Stores the data of the female painter definition|"));
	sPainterStreamFemale.setCategory(category);
	sPainterStreamFemale.setReadOnly(bDebug?false:_kHidden);
	
	if (_bOnDbCreated)
	{
		String _stream = sPainterStreamFemale;
		if (_stream.length() > 0)
		{
			// get painter definition from property string	
			Map m;
			m.setDxContent(_stream, true);
			String name = m.getString("Name");
			String type = m.getString("Type").makeUpper();
			String filter = m.getString("Filter");
			String format = m.getString("Format");
			
			// create definition if not present	
			if (m.hasString("Name") && m.hasString("Type") && sPainters.findNoCase(name ,- 1) < 0)//name.find(sPainterCollection, 0, false) >- 1 &&
			{
				PainterDefinition pd(name);
				pd.dbCreate();
				pd.setType(type);
				pd.setFilter(filter);
				pd.setFormat(format);
				
				if (pd.bIsValid())
				{
					sPainters.append(name);
					
				}
			}
		}
	}
	
//End Create Painter by Property//endregion 
	String sMaleSelections[0];		sMaleSelections = sMaleDefaultSelections;
	String sFemaleSelections[0];	sFemaleSelections = sFemaleDefaultSelections;
	for (int i=0;i<sPainters.length();i++) 
	{ 
		PainterDefinition pd(sPainters[i]);
		String type = pd.type();
		
		int bValidMaleType = type.find(kBeam,0,false)==0;
		int bValidFemaleType = type.find(kBeam,0,false)==0;
		
		String painter = sPainters[i];
		int n = painter.find("\\", 0, false);
	
	// append collection painters without the collection name	
		if (painter.find(kPainterCollection,0,false)>-1) 
		{ 
			String s = painter.right(painter.length() - n - 1);
			if (sMaleSelections.findNoCase(s,-1)<0 && bValidMaleType)
				sMaleSelections.append(s);
			if (sFemaleSelections.findNoCase(s,-1)<0 && bValidFemaleType)
				sFemaleSelections.append(s);				
		}
	// ignore other collections	
		else if (!bHasPainterCollection && n <0) 
		{
			if (bValidMaleType)sMaleSelections.append(painter); 
			if (bValidFemaleType)sFemaleSelections.append(painter); 			
		}
	}//next i
	
	
category = T("|Filter|");
	String sSelectionDescription = T("|The filtering supports certain defaults which can also be defined by painter definitions.|") + 
		T("|The painter definition may be stored in a collection named 'ElementBeamSplit' in which case it will only collect definitions within this collection.|") +
		T("|If no such collection is found all painters matching the supported types will be collected.|");

	String sMaleSelectionName=T("|Splitting Beams|");	
	PropString sMaleSelection(0, sMaleSelections, sMaleSelectionName,1);	
	sMaleSelection.setDescription(T("|Defines the filter mode for the male entities.| ") + sSelectionDescription);
	sMaleSelection.setCategory(category);
	if (sMaleSelections.find(sMaleSelection) <- 1)sMaleSelection.set(tParallelY);
	//sMaleSelection.setReadOnly(_bOnInsert ? false : _kHidden);
	
	String sFemaleSelectionName=T("|Beams to split|");	
	PropString sFemaleSelection(1, sFemaleSelections, sFemaleSelectionName,0);	
	sFemaleSelection.setDescription(T("|Defines the selection mode for the female entities.| ")+sSelectionDescription);
	sFemaleSelection.setCategory(category);	
	if (sFemaleSelections.find(sFemaleSelection) <- 1)sFemaleSelection.set(tDefault);
	//sFemaleSelection.setReadOnly(_bOnInsert ? false : _kHidden);		
	
category = T("|Tooling|");
	String sGapName=T("|Gap|");	
	PropDouble dGap(0, U(0), sGapName, _kLength);	
	dGap.setDescription(T("|Defines the Gap|"));
	dGap.setCategory(category);
//End Properties//endregion 	

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(kLastInserted);					
		}	
	// standard dialog	
		else	
			showDialog();

	// prompt for elements
		PrEntity ssE(T("|Select elements or <Enter> to select beams manually|"), Element());
	  	if (ssE.go())
			_Element.append(ssE.elementSet());
		
	// clone by element
		for (int i=0;i<_Element.length();i++) 
		{ 
			Element el = _Element[i];
		// create TSL
			TslInst tslNew;
			GenBeam gbsTsl[] = {}; Entity entsTsl[] = {el}; Point3d ptsTsl[] = {el.ptOrg()};
			int nProps[]={}; double dProps[]={dGap}; String sProps[]={sMaleSelection,sFemaleSelection};
			Map mapTsl;	
			
			tslNew.dbCreate(scriptName() , el.vecX(), el.vecY(),gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
		}//next i
 		
 		if(_Element.length()==0)
 		{ 
 			// prompt male/female entities
		// prompt for entities
			Entity entsMale[0];
			PrEntity ssEmale(T("|Select splitting beams or/and trusses|"), Beam());
			ssEmale.addAllowedClass(TrussEntity());
			if (ssEmale.go())
				entsMale.append(ssEmale.set());
				
			
		// prompt for entities
			Beam beamsFemale[0];
			PrEntity ssEfemale(T("|Select Beams to split|"), Beam());
			if (ssEfemale.go())
				beamsFemale.append(ssEfemale.beamSet());
				
			if(entsMale.length()>0 && beamsFemale.length()>0)
			{ 
				// male entities and female beams are selected
			// create TSL
				TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[]={}; Entity entsTsl[]={}; Point3d ptsTsl[]={_Pt0};
				int nProps[]={}; double dProps[]={}; String sProps[]={};
				Map mapTsl;
				mapTsl.setEntityArray(entsMale,true,"Male","Male","Male");
				mapTsl.setEntityArray(beamsFemale,true,"Female","Female","Female");
				
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
								ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
			else
			{ 
				reportMessage("\n"+scriptName()+" "+T("|Splitting beams and beams to split must be selected|"));
				eraseInstance();
				return
			}
 		}
 		
		eraseInstance();
		return;
	}
// end on insert	__________________//endregion

//return
	if(_Element.length()<1)
	{ 
		// this part is when no element is selected
		// Splitting beams and beams to split are manually selected
		Entity entMales[]=_Map.getEntityArray("Male","Male","Male");
		Entity entsFemale[]=_Map.getEntityArray("Female","Female","Female");
		Beam females[0];
		for (int ient=0;ient<entsFemale.length();ient++) 
		{ 
			Beam bmI=(Beam)entsFemale[ient];
			if(bmI.bIsValid() && females.find(bmI)<0)
			{ 
				females.append(bmI);
			}
		}//next ient
		
		
		if(entMales.length()<1 || entsFemale.length()<1)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|no Male or Female entities found|"));
			eraseInstance();
			return;
		}
		
		TrussEntity trusses[0];
		Body bdTrusses[0];
		Quader qdTrusses[0];
		for (int ient=0;ient<entMales.length();ient++) 
		{ 
			TrussEntity trussI = (TrussEntity)entMales[ient];
			if (!trussI.bIsValid())continue;
			if(trusses.find(trussI)<0)
			{
				trusses.append(trussI);
				CoordSys csTruss = trussI.coordSys();
				Vector3d vecXt = csTruss.vecX();
				Vector3d vecYt = csTruss.vecY();
				Vector3d vecZt = csTruss.vecZ();
				Point3d ptOrgTruss = trussI.ptOrg();
				String strDefinition = trussI.definition();
				TrussDefinition trussDefinition(strDefinition);
				Beam beamsTruss[] = trussDefinition.beam();
				Body bdTruss;
				for (int i=0;i<beamsTruss.length();i++) 
				{ 
			//		beamsTruss[i].envelopeBody().vis(4);
					bdTruss.addPart(beamsTruss[i].envelopeBody());
				}//next i
				bdTruss.transformBy(csTruss);
				Point3d ptCenBd = bdTruss.ptCen();
				PlaneProfile ppX = bdTruss.shadowProfile(Plane(ptCenBd, vecXt));
				LineSeg segX = ppX.extentInDir(vecYt);
				Point3d ptCenX = segX.ptMid();
				Point3d ptCenTruss = ptCenX;
				PlaneProfile ppY = bdTruss.shadowProfile(Plane(ptCenBd, vecYt));
				LineSeg segY = ppY.extentInDir(vecXt);
				ptCenTruss += vecXt * vecXt.dotProduct(segY.ptMid() - ptCenTruss);
				double dLx = bdTruss.lengthInDirection(vecXt);
				double dLy = bdTruss.lengthInDirection(vecYt);
				double dLz = bdTruss.lengthInDirection(vecZt);
				Quader qdTruss(ptCenTruss, vecXt, vecYt, vecZt, dLx, dLy, dLz,0,0,0);
				Body bdI(qdTruss);
				qdTrusses.append(qdTruss);
				bdTrusses.append(bdI);
			}
		}//next ient
		
		if (entMales.length()<1)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|could not find any splitting beams or trusses|"));
			if (!bDebug)eraseInstance();
			return;
		}
		
		for (int i=females.length()-1; i>=0 ; i--) 
		if (entMales.find(females[i])>-1)
			females.removeAt(i);
			
		if (females.length()<1)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|could not find any beams to be split|"));
			if (!bDebug)eraseInstance();			
			return;	
		}
		
		Body bdMales[0];
		Beam blockings[0];
		
	//	for (int i=0;i<males.length();i++)
		for (int i=0;i<entMales.length();i++)
		{ 
	//		Body bd = males[i].envelopeBody(true, true);	bd.vis(4);
			Vector3d vecXmale;
			Body bd;
			Beam bmI = (Beam)entMales[i];
			TrussEntity trussI=(TrussEntity)entMales[i];
			if(bmI.bIsValid())
			{
				bd=bmI.envelopeBody(true,true);
				vecXmale=bmI.vecX();
			}
			else if(trussI.bIsValid())
			{
				int iTruss=trusses.find(trussI);
				Body bdI;
				Quader qdI;
				if(iTruss>-1)
				{ 
					bd = bdTrusses[iTruss];
					qdI = qdTrusses[iTruss];
				}
					
				vecXmale=qdI.vecX();
			}
			
			bdMales.append(bd);
			
			Beam bmIntersections[] = bd.filterGenBeamsIntersect(females);
			
			for (int j=0;j<bmIntersections.length();j++) 
			{ 
				Beam b= bmIntersections[j]; 
	//			if (blockings.find(b)<0 && !males[i].vecX().isParallelTo(b.vecX()))
				if (blockings.find(b)<0 && !vecXmale.isParallelTo(b.vecX()))
					blockings.append(b);
			}//next j 
		}//next i
		
		if (blockings.length()<1)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|no intersections found to perform split|"));
			if (!bDebug)eraseInstance();
			return;	
		}
		
		for (int i=blockings.length()-1; i>=0 ; i--) 
		{ 
			Beam& b = blockings[i];
			b.envelopeBody().vis(3);
	//		continue;
			String sExtrProf = b.extrProfile();
			int c = b.color();
			String mat = b.material();
			String name = b.name();
			int nType = b.type();
			String sInformation = b.information();
			String label = b.label();
			String grade = b.grade();
			String subLabel = b.subLabel();
			String subLabel2 = b.subLabel2();
	
			Body bd = b.envelopeBody(true, true);
		
	//		Beam bmIntersections[] = bd.filterGenBeamsIntersect(males);
			Beam bmIntersections[0];
			Entity entIntersections[0];
			for (int ient=0;ient<entMales.length();ient++) 
			{ 
				Beam bmI=(Beam)entMales[ient];
				TrussEntity trussI=(TrussEntity)entMales[ient];
				if(bmI.bIsValid())
				{ 
					Body bdI = bmI.envelopeBody(true, true);
					if(bd.hasIntersection(bdI))
					{ 
						entIntersections.append(bmI);
					}
				}
				else if(trussI.bIsValid())
				{ 
					int iTruss=trusses.find(trussI);
					Body bdI;
					if(iTruss>-1)
					{ 
						bdI = bdTrusses[iTruss];
					}
					else
					{ 
						reportMessage("\n"+scriptName()+" "+T("|Unexpected|"));
					}
					
					if(bd.hasIntersection(bdI))
					{ 
						entIntersections.append(trussI);
					}
				}
			}//next ient
			
			
			Body bdA = bd;
	//		for (int j = 0; j < bmIntersections.length(); j++)
			for (int j = 0; j < entIntersections.length(); j++)
			{
	//			Beam bx = bmIntersections[j];
				Entity entx=entIntersections[j];
	//			Body bdB(bx.ptCen(), bx.vecX(), bx.vecY(), bx.vecZ(), bx.solidLength(), bx.solidWidth()+2*dGap, bx.solidHeight()+2*dGap, 0, 0, 0);
	//			bdB.vis(252);
				
				Beam bmJ = (Beam)entIntersections[j];
				TrussEntity trussJ = (TrussEntity)entIntersections[j];
				
				Body bdB;
				if(bmJ.bIsValid())
				{ 
					bdB=Body (bmJ.ptCen(), bmJ.vecX(), bmJ.vecY(), bmJ.vecZ(), 
						bmJ.solidLength(), bmJ.solidWidth()+2*dGap, bmJ.solidHeight()+2*dGap, 0, 0, 0);
				}
				else if(trussJ.bIsValid())
				{ 
					Quader qdTruss;
					int iTruss=trusses.find(trussJ);
					if(iTruss>-1)
					{ 
						qdTruss = qdTrusses[iTruss];
					}
					Quader qdJ(qdTruss.ptOrg(), qdTruss.vecX(),qdTruss.vecY(),qdTruss.vecZ(),
						qdTruss.dD(qdTruss.vecX()),qdTruss.dD(qdTruss.vecY())+2*dGap,qdTruss.dD(qdTruss.vecZ())+2*dGap,0,0,0);
					bdB=Body(qdJ);
				}
				
	//			bx.realBody().vis(53);
				entx.realBody().vis(53);
				bdA.subPart(bdB);
			}
			
			Body lumps[] = bdA.decomposeIntoLumps();
			for (int j=0;j<lumps.length();j++) 
			{ 
				Body bdConv = lumps[j];
				if (bdConv.lengthInDirection(b.vecX())<U(20))
				{
					continue;
				}
				if (bDebug)
					bdConv.vis(j);
				else
				{ 
					Beam bm;
					bm.dbCreate(bdConv, b.ptCen(), b.vecX(), b.vecY(), b.vecZ(), b.dW(), b.dH());	
	
					bm.setColor(c);
					bm.setMaterial(mat);
					bm.setName(name);
					bm.setType(nType);
					bm.setInformation(sInformation);
					bm.setGrade(grade);
					bm.setLabel(label);
					bm.setSubLabel(subLabel);
					bm.setSubLabel2(subLabel2);
	
					if (sExtrProf != _kExtrProfRectangular && sExtrProf.length()>0)
						bm.setExtrProfile(sExtrProf);
					Element elI = b.element();
					if(elI.bIsValid())
					{
						bm.assignToElementGroup(elI, true, b.myZoneIndex(), 'Z');
					}
					else
					{ 
						bm.assignToGroups(b);
					}
				}
			}//next j
			
			if (!bDebug && b.bIsValid())
				b.dbErase();
			//bdA.vis(i); 
		}//next i

		
		eraseInstance();
		return;
	}

//region mapIO: support property dialog input via map on element creation
	int bHasPropertyMap = _Map.hasMap("PROPSTRING[]")  && _Map.hasMap("PROPDOUBLE[]");
	if (_bOnMapIO)
	{ 
		if (bHasPropertyMap)
			setPropValuesFromMap(_Map);	
		showDialog();
		_Map = mapWithPropValues();
		return;
	}
	if (_bOnElementDeleted)
	{
		eraseInstance();
		return;
	}
	else if ((_bOnElementConstructed || _bOnDbCreated) && bHasPropertyMap)
	{ 
		setPropValuesFromMap(_Map);
		_Map = Map();
	}
//End mapIO: support property dialog input via map on element creation//endregion 

//region ELement Standards
	if (_Element.length()<1)
	{ 
		eraseInstance();
		return;
	}
	Element el = _Element[0];
	Vector3d vecX = el.vecX();
	Vector3d vecY = el.vecY();
	Vector3d vecZ = el.vecZ();
	vecX.vis(_Pt0, 1);
	vecY.vis(_Pt0, 3);
//endregion 


//region Update catalog entries if painters are used but stream is not stored in catalog entry
	if ((sPainterStreamMale.length()==0 && sMaleDefaultSelections.findNoCase(sMaleSelection,-1)<0) || 
		(sPainterStreamFemale.length()==0 && sFemaleDefaultSelections.findNoCase(sFemaleSelection,-1)<0))
	{ 
		String streamMale, streamFemale;
		for (int i=0;i<2;i++) 
		{ 
			String selection = i == 0 ? sMaleSelection : sFemaleSelection;
			if (i==0 && (selection == tParallelX || selection == tParallelY)) { continue;}
			else if (i==1 && (selection == tDefault)) { continue;}
			
			PainterDefinition pd;
			if (bHasPainterCollection && sPainters.findNoCase(kPainterCollection +"\\"+selection,-1)>-1)
				pd = PainterDefinition(kPainterCollection + "\\"+selection);
			else if (sPainters.findNoCase(selection,-1)>-1)
				pd = PainterDefinition(selection);
			
		// Set stream
			if (pd.bIsValid())
			{ 
				Map m;
				m.setString("Name", pd.name());
				m.setString("Type",pd.type());
				m.setString("Filter",pd.filter());
				m.setString("Format",pd.format());
				
				if (i==0)streamMale=m.getDxContent(true);
				else if (i==1)streamFemale=m.getDxContent(true);
			}
		}//next i
		
		String entries[] = TslInst().getListOfCatalogNames("ElementBeamSplit");
		
		for (int i=0;i<entries.length();i++) 
		{ 
			String entry = entries[i]; 
			Map map = TslInst().mapWithPropValuesFromCatalog("ElementBeamSplit", entry);
			
			Map mapProp = map.getMap("PropString[]");
			
			String val0, val1, val2, val3;
			for (int j=0;j<mapProp.length();j++) 
			{ 
				Map m = mapProp.getMap(j);
				int index = m.getInt("nIndex");
				String value= m.getString("strValue");
				
				if (index == 0) val0 = value;
				else if (index == 1) val1 = value;
				else if (index == 2) val2 = value;
				else if (index == 3) val3 = value;
			}//next j 
			
			int bWrite;
			if (val0 == sMaleSelection && val2!= streamMale)
			{ 
				sPainterStreamMale.set(streamMale);
				bWrite = true;
			}
			if (val1 == sFemaleSelection && val3!= streamFemale)
			{ 
				sPainterStreamFemale.set(streamFemale);
				bWrite = true;
			}
			
			if (bWrite)
				setCatalogFromPropValues(entry);
			
		}//next i 
	}
//endregion 
		

//region Get Male Beams
	Entity ents[0];
	Beam beams[] = el.beam();
	for (int ib=0;ib<beams.length();ib++) 
	{ 
		ents.append(beams[ib]);
	}//next ib
	
	TrussEntity trusses[0];
	Body bdTrusses[0];
	Quader qdTrusses[0];
	{ 
		Group grp=el.elementGroup();
		Entity entTrusses[]=grp.collectEntities(true,TrussEntity(),_kModelSpace);
		for (int ient=0;ient<entTrusses.length();ient++) 
		{ 
			TrussEntity trussI = (TrussEntity)entTrusses[ient];
			if (!trussI.bIsValid())continue;
			if(trusses.find(trussI)<0)
			{
				trusses.append(trussI);
				ents.append(trussI);
				CoordSys csTruss = trussI.coordSys();
				Vector3d vecXt = csTruss.vecX();
				Vector3d vecYt = csTruss.vecY();
				Vector3d vecZt = csTruss.vecZ();
				Point3d ptOrgTruss = trussI.ptOrg();
				String strDefinition = trussI.definition();
				TrussDefinition trussDefinition(strDefinition);
				Beam beamsTruss[] = trussDefinition.beam();
				Body bdTruss;
				for (int i=0;i<beamsTruss.length();i++) 
				{ 
			//		beamsTruss[i].envelopeBody().vis(4);
					bdTruss.addPart(beamsTruss[i].envelopeBody());
				}//next i
				bdTruss.transformBy(csTruss);
				Point3d ptCenBd = bdTruss.ptCen();
				PlaneProfile ppX = bdTruss.shadowProfile(Plane(ptCenBd, vecXt));
				LineSeg segX = ppX.extentInDir(vecYt);
				Point3d ptCenX = segX.ptMid();
				Point3d ptCenTruss = ptCenX;
				PlaneProfile ppY = bdTruss.shadowProfile(Plane(ptCenBd, vecYt));
				LineSeg segY = ppY.extentInDir(vecXt);
				ptCenTruss += vecXt * vecXt.dotProduct(segY.ptMid() - ptCenTruss);
				double dLx = bdTruss.lengthInDirection(vecXt);
				double dLy = bdTruss.lengthInDirection(vecYt);
				double dLz = bdTruss.lengthInDirection(vecZt);
				Quader qdTruss(ptCenTruss, vecXt, vecYt, vecZt, dLx, dLy, dLz,0,0,0);
				Body bdI(qdTruss);
				qdTrusses.append(qdTruss);
				bdTrusses.append(bdI);
			}
		}//next ient
	}
	int bHasBeam = beams.length()>0; 
	Beam males[0], females[0];
//	Entity entFemales[0];
	Entity entMales[0];
// filter by default
	if (sMaleSelection == tParallelX)
	{
		males = vecY.filterBeamsPerpendicularSort(beams);
		for (int ient=0;ient<ents.length();ient++) 
		{ 
			Beam bmI=(Beam)ents[ient];
			TrussEntity trussI = (TrussEntity)ents[ient];
			if(bmI.bIsValid())
			{ 
				if(abs(bmI.vecX().dotProduct(vecY))<dEps)
				{ 
					entMales.append(bmI);
				}
			}
			else if(trussI.bIsValid())
			{ 
				CoordSys csTruss = trussI.coordSys();
				Vector3d vecXt = csTruss.vecX();
				if(abs(vecXt.dotProduct(vecY))<dEps)
				{ 
					entMales.append(trussI);
				}
			}
		}//next ient
	}
	else if (sMaleSelection == tParallelY)
	{
		males = vecX.filterBeamsPerpendicularSort(beams);
		for (int ient=0;ient<ents.length();ient++) 
		{ 
			Beam bmI=(Beam)ents[ient];
			TrussEntity trussI = (TrussEntity)ents[ient];
			if(bmI.bIsValid())
			{ 
				if(abs(bmI.vecX().dotProduct(vecX))<dEps)
				{ 
					entMales.append(bmI);
				}
			}
			else if(trussI.bIsValid())
			{ 
				CoordSys csTruss = trussI.coordSys();
				Vector3d vecXt = csTruss.vecX();
				if(abs(vecXt.dotProduct(vecX))<dEps)
				{ 
					entMales.append(trussI);
				}
			}
		}//next ient
	}
	else if (sMaleSelections.findNoCase(sMaleSelection,-1)>-1)
	{ 
		PainterDefinition pd;
		if (bHasPainterCollection && sPainters.findNoCase(kPainterCollection +"\\"+sMaleSelection,-1)>-1)
			pd = PainterDefinition(kPainterCollection + "\\"+sMaleSelection);
		else if (sPainters.findNoCase(sMaleSelection,-1)>-1)
			pd = PainterDefinition(sMaleSelection);	
			
//		males = pd.filterAcceptedEntities(beams);
		entMales = pd.filterAcceptedEntities(ents);
		
	// make sure female painter is not set to same value
		if (sFemaleSelection==sMaleSelection)
		{
			reportMessage("\n" + scriptName() + ": " +sFemaleSelectionName + " " + T("|corrected to| ") + tDefault);
			sFemaleSelection.set(tDefault);
		}
	}
	// default	
	else
	{
		males = vecY.filterBeamsPerpendicularSort(beams);
		for (int ient=0;ient<ents.length();ient++) 
		{ 
			Beam bmI=(Beam)ents[ient];
			TrussEntity trussI = (TrussEntity)ents[ient];
			if(bmI.bIsValid())
			{ 
				if(abs(bmI.vecX().dotProduct(vecY))<dEps)
				{ 
					entMales.append(bmI);
				}
			}
			else if(trussI.bIsValid())
			{ 
				CoordSys csTruss = trussI.coordSys();
				Vector3d vecXt = csTruss.vecX();
				if(abs(vecXt.dotProduct(vecY))<dEps)
				{ 
					entMales.append(trussI);
				}
			}
		}//next ient
	}
	
	if (males.length()<1 && entMales.length()<1)
	{ 
		if (bHasBeam)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|could not find any splitting beams or trusses|"));
			if (!bDebug)eraseInstance();
		}
		return;
	}
//endregion 


//region Get Female Beams
// filter by painter
	if (sFemaleSelection!= tDefault && sFemaleSelections.findNoCase(sFemaleSelection,-1)>-1)
	{ 
		PainterDefinition pd;
		if (bHasPainterCollection && sPainters.findNoCase(kPainterCollection +"\\"+sFemaleSelection,-1)>-1)
			pd = PainterDefinition(kPainterCollection + "\\"+sFemaleSelection);
		else if (sPainters.findNoCase(sFemaleSelection,-1)>-1)
			pd = PainterDefinition(sFemaleSelection);
			
		females = pd.filterAcceptedEntities(beams);
	}
	else
	{
		females = beams;
	}
		
// remove any which is in male set
//	for (int i=females.length()-1; i>=0 ; i--) 
//		if (males.find(females[i])>-1)
//			females.removeAt(i);
			
	for (int i=females.length()-1; i>=0 ; i--) 
		if (entMales.find(females[i])>-1)
			females.removeAt(i);
	
	if (females.length()<1)
	{ 
		if (bHasBeam)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|could not find any beams to be split|"));
			if (!bDebug)eraseInstance();			
		}
		return;	
	}
//endregion 


//region Filter female beams which have an intersection to any male
	Body bdMales[0];
	Beam blockings[0];
	
//	for (int i=0;i<males.length();i++)
	for (int i=0;i<entMales.length();i++)
	{ 
//		Body bd = males[i].envelopeBody(true, true);	bd.vis(4);
		Vector3d vecXmale;
		Body bd;
		Beam bmI = (Beam)entMales[i];
		TrussEntity trussI=(TrussEntity)entMales[i];
		if(bmI.bIsValid())
		{
			bd=bmI.envelopeBody(true,true);
			vecXmale=bmI.vecX();
		}
		else if(trussI.bIsValid())
		{
			int iTruss=trusses.find(trussI);
			Body bdI;
			Quader qdI;
			if(iTruss>-1)
			{ 
				bd = bdTrusses[iTruss];
				qdI = qdTrusses[iTruss];
			}
				
			vecXmale=qdI.vecX();
		}
		
		bdMales.append(bd);
		
		Beam bmIntersections[] = bd.filterGenBeamsIntersect(females);
		
		for (int j=0;j<bmIntersections.length();j++) 
		{ 
			Beam b= bmIntersections[j]; 
//			if (blockings.find(b)<0 && !males[i].vecX().isParallelTo(b.vecX()))
			if (blockings.find(b)<0 && !vecXmale.isParallelTo(b.vecX()))
				blockings.append(b);
		}//next j 
	}//next i
	
	if (blockings.length()<1)
	{ 
		if (bHasBeam)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|no intersections found to perform split|"));
			if (!bDebug)eraseInstance();
		}		
		return;	
	}
//endregion 



//region Split by cloning
	for (int i=blockings.length()-1; i>=0 ; i--) 
	{ 
		Beam& b = blockings[i];
		b.envelopeBody().vis(3);
//		continue;
		String sExtrProf = b.extrProfile();
		int c = b.color();
		String mat = b.material();
		String name = b.name();
		int nType = b.type();
		String sInformation = b.information();
		String label = b.label();
		String grade = b.grade();
		String subLabel = b.subLabel();
		String subLabel2 = b.subLabel2();

		Body bd = b.envelopeBody(true, true);
	
//		Beam bmIntersections[] = bd.filterGenBeamsIntersect(males);
		Beam bmIntersections[0];
		Entity entIntersections[0];
		for (int ient=0;ient<entMales.length();ient++) 
		{ 
			Beam bmI=(Beam)entMales[ient];
			TrussEntity trussI=(TrussEntity)entMales[ient];
			if(bmI.bIsValid())
			{ 
				Body bdI = bmI.envelopeBody(true, true);
				if(bd.hasIntersection(bdI))
				{ 
					entIntersections.append(bmI);
				}
			}
			else if(trussI.bIsValid())
			{ 
				int iTruss=trusses.find(trussI);
				Body bdI;
				if(iTruss>-1)
				{ 
					bdI = bdTrusses[iTruss];
				}
				else
				{ 
					reportMessage("\n"+scriptName()+" "+T("|Unexpected|"));
				}
				
				if(bd.hasIntersection(bdI))
				{ 
					entIntersections.append(trussI);
				}
			}
		}//next ient
		
		
		Body bdA = bd;
//		for (int j = 0; j < bmIntersections.length(); j++)
		for (int j = 0; j < entIntersections.length(); j++)
		{
//			Beam bx = bmIntersections[j];
			Entity entx=entIntersections[j];
//			Body bdB(bx.ptCen(), bx.vecX(), bx.vecY(), bx.vecZ(), bx.solidLength(), bx.solidWidth()+2*dGap, bx.solidHeight()+2*dGap, 0, 0, 0);
//			bdB.vis(252);
			
			Beam bmJ = (Beam)entIntersections[j];
			TrussEntity trussJ = (TrussEntity)entIntersections[j];
			
			Body bdB;
			if(bmJ.bIsValid())
			{ 
				bdB=Body (bmJ.ptCen(), bmJ.vecX(), bmJ.vecY(), bmJ.vecZ(), 
					bmJ.solidLength(), bmJ.solidWidth()+2*dGap, bmJ.solidHeight()+2*dGap, 0, 0, 0);
			}
			else if(trussJ.bIsValid())
			{ 
				Quader qdTruss;
				int iTruss=trusses.find(trussJ);
				if(iTruss>-1)
				{ 
					qdTruss = qdTrusses[iTruss];
				}
				Quader qdJ(qdTruss.ptOrg(), qdTruss.vecX(),qdTruss.vecY(),qdTruss.vecZ(),
					qdTruss.dD(qdTruss.vecX()),qdTruss.dD(qdTruss.vecY())+2*dGap,qdTruss.dD(qdTruss.vecZ())+2*dGap,0,0,0);
				bdB=Body(qdJ);
			}
			
//			bx.realBody().vis(53);
			entx.realBody().vis(53);
			bdA.subPart(bdB);
		}
		
		Body lumps[] = bdA.decomposeIntoLumps();
		for (int j=0;j<lumps.length();j++) 
		{ 
			Body bdConv = lumps[j];
			if (bdConv.lengthInDirection(b.vecX())<U(20))
			{
				continue;
			}
			if (bDebug)
				bdConv.vis(j);
			else
			{ 
				Beam bm;
				bm.dbCreate(bdConv, b.ptCen(), b.vecX(), b.vecY(), b.vecZ(), b.dW(), b.dH());	

				bm.setColor(c);
				bm.setMaterial(mat);
				bm.setName(name);
				bm.setType(nType);
				bm.setInformation(sInformation);
				bm.setGrade(grade);
				bm.setLabel(label);
				bm.setSubLabel(subLabel);
				bm.setSubLabel2(subLabel2);

				if (sExtrProf != _kExtrProfRectangular && sExtrProf.length()>0)
					bm.setExtrProfile(sExtrProf);
				
				bm.assignToElementGroup(el, true, b.myZoneIndex(), 'Z');
			}
		}//next j
		
		if (!bDebug && b.bIsValid())
			b.dbErase();
		//bdA.vis(i); 
	}//next i

//endregion 

// non resident
	if (bHasBeam)
	{ 
		eraseInstance();
		return;
	}




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
        <int nm="BreakPoint" vl="928" />
        <int nm="BreakPoint" vl="930" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15513: add option to select entities manually" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="5/23/2022 1:23:23 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15441: Support truss entities as male (cutting) beams" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="5/10/2022 2:51:40 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15168 plugin mode improved" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="4/11/2022 8:22:29 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15168 initail version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="4/8/2022 5:30:51 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End