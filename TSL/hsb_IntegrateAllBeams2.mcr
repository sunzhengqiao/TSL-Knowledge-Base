#Version 8
#BeginDescription
#Versions:
1.4 05.09.2022 HSB-15821: fix properties on insert Author: Marsel Nakuci
1.3 19.07.2022 fix properties on insert Author: Marsel Nakuci
1.2 04.07.2022 HSB-15906: and hidden property to store selected painterdefinition Author: Marsel Nakuci
1.1 24.03.2021 HSB-10541: support painter definition Author: Marsel Nakuci
1.0 15.03.2021 HSB-10541: initial Author: Marsel Nakuci



This TSL inserts T milling between male and female beams of an element
The "T" connection will be created by the TSL "hsbT-Connection"
Male and female beams are filtered by painter definitions
Selected painter definition will be saved in the stream properties sPainterMaleStream and sPainterFemaleStream
and can be saved in the catalog
stream will be saved at the last inserted catalog
Next time the Dialog box will be opened the stream properties will be loaded with the last inserted catalog
At this point all properties can be saved to a different catalog name


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords T,painter,milling, Einfräsung,Element
#BeginContents
//region <History>
// #Versions
// 1.4 05.09.2022 HSB-15821: fix properties on insert Author: Marsel Nakuci
// 1.3 19.07.2022 fix properties on insert Author: Marsel Nakuci
// 1.2 04.07.2022 HSB-15906: and hidden property to store selected painterdefinition Author: Marsel Nakuci
// Version 1.1 24.03.2021 HSB-10541: support painter definition Author: Marsel Nakuci
// Version 1.0 15.03.2021 HSB-10541: initial Author: Marsel Nakuci

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This TSL inserts T milling between male and female beams of an element
// The "T" connection will be created by the TSL "hsbT-Connection"
// Male and female beams are filtered by painter definitions
// Selected painter definition will be saved in the stream properties sPainterMaleStream and sPainterFemaleStream
// and can be saved in the catalog
// stream will be saved at the last inserted catalog
// Next time the Dialog box will be opened the stream properties will be loaded with the last inserted catalog
// At this point all properties can be saved to a different catalog name
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsb_IntegrateAllBeams")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
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
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end Constants//endregion
	
//region Properties
	// tooling
	category = T("|Tooling|");
	String sDepthName=T("|Depth|");
	PropDouble dDepth(nDoubleIndex++, U(0), sDepthName);	
	dDepth.setDescription(T("|Defines the Depth|"));
	dDepth.setCategory(category);
	
	String sGapName=T("|Gap|");	
	PropDouble dGap(nDoubleIndex++, U(0), sGapName);	
	dGap.setDescription(T("|Defines the Gap|"));
	dGap.setCategory(category);
	
// HSB-15906: Property for saving painter stream
	String sPainterMaleStreamName=T("|PainterMaleStream|");	
	PropString sPainterMaleStream(2, "", sPainterMaleStreamName);	
	sPainterMaleStream.setDescription(T("|Defines the PainterMaleStream|"));
	sPainterMaleStream.setCategory(category);
	sPainterMaleStream.setReadOnly(bDebug?0:_kHidden);
	// list of painters
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();
    String sPainterDefault = T("<|Disabled|>");
    sPainters.insertAt(0, sPainterDefault);
	
	String sPainterFemaleStreamName=T("|PainterFemaleStream|");	
	PropString sPainterFemaleStream(3, "", sPainterFemaleStreamName);	
	sPainterFemaleStream.setDescription(T("|Defines the PainterFemaleStream|"));
	sPainterFemaleStream.setCategory(category);
	sPainterFemaleStream.setReadOnly(bDebug?0:_kHidden);
	
	// on insert read catalogs to copy / create painters based on catalog entries
	if (_bOnInsert || _bOnElementConstructed || _bOnDbCreated)
	{
		// HSB-15906: collect streams	
		String streams[0];
		String sScriptOpmName = bDebug ? "hsb_IntegrateAllBeams2" : scriptName();
		String entries[] = TslInst().getListOfCatalogNames(sScriptOpmName);
		int iStreamIndices[] ={ 2, 3};//index 2 and 3 of the stream property
		for (int i = 0; i < entries.length(); i++)
		{
			String& entry = entries[i];
			Map map = TslInst().mapWithPropValuesFromCatalog(sScriptOpmName, entry);
			Map mapProp = map.getMap("PropString[]");
			
			for (int j = 0; j < mapProp.length(); j++)
			{
				Map m = mapProp.getMap(j);
				int index = m.getInt("nIndex");
				String stream = m.getString("strValue");
				if (iStreamIndices.find(index) >- 1 && streams.findNoCase(stream ,- 1) < 0)
				{
					streams.append(stream);
				}
			}//next j
		}//next i
		
		for (int i = 0; i < streams.length(); i++)
		{
			String& stream = streams[i];
			String _painters[0];
			_painters = sPainters;
			if (stream.length() > 0)
			{
				// get painter definition from property string	
				Map m;
				m.setDxContent(stream , true);
				String name = m.getString("Name");
				String type = m.getString("Type").makeUpper();
				String filter = m.getString("Filter");
				String format = m.getString("Format");
				// create definition if not present	
				//				if (m.hasString("Name") && m.hasString("Type") && name.find(sPainterCollection,0,false)>-1 &&
				//					_painters.findNoCase(name,-1)<0)
				if (m.hasString("Name") && m.hasString("Type") && _painters.findNoCase(name,- 1) < 0)
				{
					PainterDefinition pd(name);
					if ( ! pd.bIsValid())
					{
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
		}
	}
	
	
	// painter for male beams
	// add painter property for male beams
	category = T("|Painter|");
	String sPainterMaleName=T("|Male beams|");	
	PropString sPainterMale(nStringIndex++, sPainters, sPainterMaleName);	
	sPainterMale.setDescription(T("|Defines the Painter definition of Male beams|"));
	sPainterMale.setCategory(category);
	// painter for female beams
	// add painter property for female beams
	String sPainterFemaleName=T("|Female beam|");	
	PropString sPainterFemale(nStringIndex++, sPainters, sPainterFemaleName);	
	sPainterFemale.setDescription(T("|Defines the Painter definition of Female beams|"));
	sPainterFemale.setCategory(category);
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
				setPropValuesFromCatalog(sLastInserted);					
		}	
	// standard dialog	
		else
			showDialog();
		//
	// prompt for elements
		PrEntity ssE(T("|Select elements|"), Element());
	  	if (ssE.go())
			_Element.append(ssE.elementSet());
		
	// create TSL
		TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};	Entity entsTsl[] = {};	Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};		
		double dProps[]={dDepth,dGap};
		// HSB-15821: fix order
		String sProps[]={sPainterMale,sPainterFemale,sPainterMaleStream,sPainterFemaleStream};
		Map mapTsl;
		entsTsl.setLength(1);
		for (int i=0;i<_Element.length();i++) 
		{ 
			entsTsl[0] = _Element[i];
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
		}//next i
		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion
//	return
//	sBeamType.setReadOnly(false);
	if(_Element.length()==0)
	{ 
		reportMessage(TN("|no element found|"));
		eraseInstance();
		return;
	}
	Element el = _Element[0];
	
	// basic information
	Point3d ptOrg = el.ptOrg();
	Vector3d vecX = el.vecX();
	Vector3d vecY = el.vecY();
	Vector3d vecZ = el.vecZ();
	
	_Pt0 = ptOrg;
//	return
	// draw text
	Display dp(1);
	dp.draw(scriptName(), _Pt0, vecX, vecY, 0, 0, _kDeviceX);
	
	Beam bmAll[] = el.beam();
	if(bmAll.length()<1)
	{ 
		// not calculated
		return;
	}
	Beam bmHors[] = vecY.filterBeamsPerpendicular(bmAll);
	Beam bmHeaders[0];
	// collect headers
	for (int i=0;i<bmHors.length();i++) 
	{ 
		if(bmHors[i].type()==_kHeader && bmHeaders.find(bmHors[i])<0)
		{ 
			bmHeaders.append(bmHors[i]);
		}
	}//next i
	if(_bOnDbCreated)
	{ 
		
		// prepare TSL hsbT-Connection
		TslInst tslNew;			Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};	Entity entsTsl[] = {};	Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};		double dProps[]={};		String sProps[]={};
		Map mapTsl;
		// 
		int iCoupleIds[0];
		TslInst tslTconnections[0];
		
		Beam beamsMale[0], beamsFemale[0];
		PainterDefinition pDmale, pDfemale;
		if(sPainterMale!=sPainterDefault)
		{ 
			pDmale=PainterDefinition(sPainterMale);
			beamsMale = pDmale.filterAcceptedEntities(bmAll);
		}
		if(sPainterFemale!=sPainterDefault)
		{ 
			pDfemale=PainterDefinition(sPainterFemale);
			beamsFemale = pDfemale.filterAcceptedEntities(bmAll);
		}
		if (pDmale.bIsValid())
		{ 
			Map m;
			m.setString("Name", pDmale.name());
			m.setString("Type",pDmale.type());
			m.setString("Filter",pDmale.filter());
			m.setString("Format",pDmale.format());
			sPainterMaleStream.set(m.getDxContent(true));
		}
		if (pDfemale.bIsValid())
		{ 
			Map m;
			m.setString("Name", pDfemale.name());
			m.setString("Type",pDfemale.type());
			m.setString("Filter",pDfemale.filter());
			m.setString("Format",pDfemale.format());
			sPainterFemaleStream.set(m.getDxContent(true));
		}
		_ThisInst.setCatalogFromPropValues(sLastInserted);
		
//		for (int i=0;i<bmAll.length();i++)
		for (int i=0;i<beamsMale.length();i++)
		{ 
			Beam bm = beamsMale[i];
			int nHeader = false;
			if(bm.type()==_kHeader)
			{ 
				nHeader = true;
			}
			
//			int nType = bm.type();
//			int nIndexType = nBmType.find(nType);
//			int nNotchBeam;
//			if(nIndexType>-1)
//			{ 
//				nNotchBeam = sNoYes.find(sNotches[nIndexType]);
//			}
//			if(nNotchBeam==0)
//			{ 
//				// no is selected 
//	//			continue;
//			}
			
			// 
	//		Beam bmAux[]=bm.filterGenBeamsNotThis(bmAll);
	//		Beam bmToCut[]=bm.filterBeamsCapsuleIntersect(bmAux);
	//		int nIsAngledPlate = FALSE;
//			for (int j=0;j<bmAll.length();j++) 
			for (int j=0;j<beamsFemale.length();j++) 
			{ 
				// female beams
				Beam bmFemale = beamsFemale[j];
//				if (i == j)continue;
//				int iCheckId = 1000 * (j+1) + (i+1);
//				if(iCoupleIds.find(iCheckId)>-1)
//				{
//					continue
//				}
						
				
	//			if (!bm.hasTConnection(bmFemale, U(15), false))
				if (!bm.hasTConnection(bmFemale, U(15), true))
				{ 
					continue;
				}
				// is a potential T connection
				
	//			Beam bmCut=bmToCut[j];
	//			if (bmCut.type() == _kSFAngledTPLeft || bmCut.type() == _kSFAngledTPRight ||
	//			bm.type() == _kSFAngledTPLeft || bm.type() == _kSFAngledTPRight)
	//			{
	//				nIsAngledPlate = TRUE;
	//			}
				// 
//				int nTypeFemale=bmFemale.type();
//				int nIndexFemale=nBmType.find(nTypeFemale);
//				int nNotchBeamFemale=true;			
//				if(nIndexFemale>-1)
//				{
//					nNotchBeamFemale=sNoYes.find(sNotches[nIndexFemale]);
//				}
//				if(nNotchBeamFemale==0)
//				{ 
//					// no is selected 
//					continue;
//				}
//				iCoupleIds.append(1000 * (i+1) + (j+1));
				bm.envelopeBody().vis(1);
				bmFemale.envelopeBody().vis(2);
	
	//			if (bmCut.dD(vecX)>bmCut.dD(vecZ))
	//				continue;
	//			
	//			if (bmCut.hasTConnection(bm, U(15), TRUE))
	//			{
	//				//Not dealing with the situation where we have two angled plates so check
	//				if (
	//					abs(bm.vecX().dotProduct(vecX)) < U(0.99) &&
	//				abs(bm.vecX().dotProduct(vecY)) < U(0.99) &&
	//				abs(bmCut.vecX().dotProduct(vecX)) < U(0.99) &&
	//				abs(bmCut.vecX().dotProduct(vecY)) < U(0.99)
	//				)
	//				{
	//					continue;
	//				}
	//				
	//				Vector3d vecCenters = bm.ptCen() - bmCut.ptCen();
	//				// cutting plane in direction of the female beam
	//				Vector3d vCut = bm.vecD(vecCenters);
	//				vCut.vis(bmCut.ptCen(), 2);
	//				Plane pln (bm.ptCen() - vCut * (bm.dD(vCut) * 0.5), vCut);
	//				
	//				Vector3d vNormalCut = bmCut.vecX();
	//				if (vCut.dotProduct(vNormalCut) < 0)
	//					vNormalCut = -vNormalCut;
	//				
	//				//Check if beam is the first beam intersecting this beam, if not we are not interested
	//				//This is to mitigate issues where beams skim the edge of other beams
	//				Beam bmAllButThis[] = bmCut.filterGenBeamsNotThis(bmAll);
	//				
	//				Beam intersectingBeams[] = Beam().filterBeamsHalfLineIntersectSort(bmAllButThis, bmCut.ptCen(), vNormalCut, TRUE);
	//				bmCut.realBody().vis(j);
	//				vNormalCut.vis(bmCut.ptCen());
	//				for (int z = 0; z < intersectingBeams.length(); z++)
	//				{
	//					intersectingBeams[z].realBody().vis(z);
	//				}
	//				//No intersections found - this should not happen
	//				if (intersectingBeams.length() == 0) continue;
	//				//Its not intersecting with the female beam
	//				if (intersectingBeams[0] != bm) continue;
					
					// add hsbT-Connection TSL
					gbsTsl.setLength(0);
					gbsTsl.append(bm);
					gbsTsl.append(bmFemale);
					//
					dProps.setLength(0);
					dProps.append(dDepth);
					dProps.append(dGap);
					//
					sProps.setLength(0);
					sProps.append(T("|Disabled|"));
//					reportMessage(TN("|create|")+i+j);
					Entity entMales[0], entFemales[0];
					entMales.append(bm);
					entFemales.append(bmFemale);
					mapTsl.setEntityArray(entMales, false, "males", "males", "males");
					mapTsl.setEntityArray(entFemales, false, "females", "females", "females");
					
					tslNew.dbCreate("hsbT-Connection", vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
	//				tslNew.recalc();
					tslNew.transformBy(Vector3d(0, 0, 0));
					if(tslNew.bIsValid() && tslTconnections.find(tslNew)<0)
					{ 
						tslTconnections.append(tslNew);
					}
					if(_Entity.find(tslNew)<0)
					{ 
						_Entity.append(tslNew);
					}
	//			}
			}//next j
		}//next i
//		setExecutionLoops(3);
//		if(_kExecutionLoopCount==0)
//		{
//			setExecutionLoops(3);
//		}
//		else if(_kExecutionLoopCount==1)
//		{ 
//			setExecutionLoops(4);
//		}
//		else if(_kExecutionLoopCount==2)
//		{ 
//			setExecutionLoops(5);
//		}
	}
//	if(_kExecutionLoopCount==0)
//	{
//		setExecutionLoops(3);
//	}
//	else if(_kExecutionLoopCount==1)
//	{ 
//		setExecutionLoops(4);
//	}
//	else if(_kExecutionLoopCount==2)
//	{ 
//		setExecutionLoops(5);
//	}
//	else if(_kExecutionLoopCount==3)
//	{ 
//		setExecutionLoops(6);
//	}
//	else if(_kExecutionLoopCount==4)
//	{ 
//		setExecutionLoops(7);
//	}
//	// recalc all tsls
//	for (int i=0;i<_Entity.length();i++) 
//	{ 
//		TslInst tsl = (TslInst)_Entity[i];
//		if(tsl.bIsValid())
//		{ 
//			// 
//			reportMessage(TN("|recalc|")+i);
//			
//			tsl.recalc();
//			tsl.transformBy(Vector3d(0, 0, 0));
//		}
//	}//next i
//	reportMessage(TN("|_kExecutionLoopCount|")+_kExecutionLoopCount);
	
//	for (int i=0;i<tslTconnections.length();i++) 
//	{ 
//		reportMessage(TN("|i|")+i);
//		
//		tslTconnections[i].recalc();
//		tslTconnections[i].transformBy(Vector3d(0, 0, 0));
//	}//next i
//	// recalc all tsls
//	for (int i=0;i<tslTconnections.length();i++) 
//	{ 
//		reportMessage(TN("|i|")+i);
//		
//		tslTconnections[i].recalc();
//		tslTconnections[i].transformBy(Vector3d(0, 0, 0));
//	}//next i
//	
//	for (int i=0;i<tslTconnections.length();i++) 
//	{ 
//		reportMessage(TN("|i|")+i);
//		
//		tslTconnections[i].recalc();
//		tslTconnections[i].transformBy(Vector3d(0, 0, 0));
//	}//next i
//if(_kExecutionLoopCount==5)
//{ 
//	eraseInstance();
//	return;
//}

	eraseInstance();
	return;
	
	String sNone = T("|None|");
	String sAll = T("|All|");
////region Trigger trigger to select/deselect beam types
//	for (int i=0;i<sBmType.length();i++) 
//	{ 
//		String trigger =sBmType[i];
//		String key = sBmType[i]; 
//		String sAttribute = sBeamType;
//		sAttribute.trimLeft();
//		sAttribute.trimRight();
//		String sTokens[] = sAttribute.tokenize(";");
//		String sAddRemove = " ";
//		for (int iTok=0;iTok<sTokens.length();iTok++) 
//		{ 
//			String sTokI = sTokens[iTok]; 
//			sTokI.makeUpper();
//			String sKeyUpp=key;
//			sKeyUpp.makeUpper();
//			if(sTokI==sKeyUpp)
//			{ 
//				sAddRemove = "√";
//				break;
//			}
//		}//next iTok
//		trigger += "   "+sAddRemove;
//		String variable = sBmType[i];
//		addRecalcTrigger(_kContext,trigger);
//		if (_bOnRecalc && _kExecuteKey==trigger)
//		{
//			String newAttrribute;
//			int x = -1;
//			for (int iTok=0;iTok<sTokens.length();iTok++) 
//			{ 
//				String sTokI = sTokens[iTok]; 
//				sTokI.makeUpper();
//				String sVariableUpp=variable;
//				sVariableUpp.makeUpper();
//				if(sTokI==sVariableUpp)
//				{ 
//					x = iTok;
//					break;
//				}
//			}//next iTok
//			
//			if (x>-1)
//			{
//				// exists
//				sAttribute = "";
//				sTokens.removeAt(x);
//				for (int iTok=0;iTok<sTokens.length();iTok++) 
//				{ 
//					sAttribute += sTokens[iTok] + ";";
//				}//next iTok
//				newAttrribute = sAttribute;
//			}
//			else
//			{ 
//				sAttribute = "";
//				for (int iTok=0;iTok<sTokens.length();iTok++) 
//				{ 
//					sAttribute += sTokens[iTok] + ";";
//				}//next iTok
//				newAttrribute = sAttribute + variable+";";
//				if(key==sNone)
//				{ 
//					// option none turns off everything
//					newAttrribute = sNone;
//				}
//				if(key==sAll)
//				{ 
//					// option none turns off everything
//					newAttrribute = sAll+";";
//					for (int iL=0;iL<sBmType.length();iL++) 
//					{ 
//						if(sBmType[iL]==sNone)
//							continue;
//						newAttrribute += sBmType[iL] + ";";
//					}//next iL
//				}
//				
//				reportMessage("\n" + variable + " new: " + newAttrribute);
//			}
//			sBeamType.set(newAttrribute);
//			
//			setExecutionLoops(2);
//			return;
//		}
//	}//next i
////endregion	
	
	
////region Trigger AddRemoveBeamType
//	String sTriggerAddRemoveBeamType = T("|Add/Remove Beam type|");
//	addRecalcTrigger(_kContextRoot, sTriggerAddRemoveBeamType );
//	if (_bOnRecalc && _kExecuteKey==sTriggerAddRemoveBeamType)
//	{
//		// property where types are selected for notching
//		String sAttribute = sBeamType;
//		String sPrompt;
//		sPrompt+="\n"+  T("|Select a property by index to add or to remove|") + T(", |0 = Exit|");
//		reportNotice("\n"+sPrompt);
//		String sObjectVariables[0];
//		sObjectVariables.append(sBmType);
//		for (int s=0;s<sObjectVariables.length();s++) 
//		{ 
//			String key = sObjectVariables[s]; 
//
//			//String sSelection= sFormat.find(key,0, false)<0?"" : T(", |is selected|");
////			String sAddRemove = sAttribute.find(key,0, false)<0?"   " : "√";
//			sAttribute.trimLeft();
//			sAttribute.trimRight();
//			String sTokens[] = sAttribute.tokenize(";");
//			String sAddRemove = "   ";
//			for (int iTok=0;iTok<sTokens.length();iTok++) 
//			{ 
//				String sTokI = sTokens[iTok]; 
//				sTokI.makeUpper();
//				String sKeyUpp=key;
//				sKeyUpp.makeUpper();
//				if(sTokI==sKeyUpp)
//				{ 
//					sAddRemove = "√";
//					break;
//				}
//			}//next iTok
//			
//			int x = s + 1;
//			String sIndex = ((x<10)?"    " + x:"  " + x)+ "  "+sAddRemove+"   ";//
//			
//			reportNotice("\n"+sIndex+key + "........: ");
//			
//		}//next i
//		reportNotice("\n"+sPrompt);
//		
//		int nRetVal = getInt(sPrompt)-1;	
//
//	// select property	
//		while (nRetVal>-1)
//		{ 
//			if (nRetVal>-1 && nRetVal<=sObjectVariables.length())
//			{ 
//				String newAttrribute;
//				sAttribute=sBeamType;
//				sAttribute.trimLeft();
//				sAttribute.trimRight();
//				String sTokens[] = sAttribute.tokenize(";");
//			// get variable	and append if not already in list	
//				String variable =sObjectVariables[nRetVal];
//				
//				int x = -1;
//				for (int iTok=0;iTok<sTokens.length();iTok++) 
//				{ 
//					String sTokI = sTokens[iTok]; 
//					sTokI.makeUpper();
//					String sVariableUpp=variable;
//					sVariableUpp.makeUpper();
//					if(sTokI==sVariableUpp)
//					{ 
//						x = iTok;
//						break;
//					}
//				}//next iTok
//				
//				if (x>-1)
//				{
//					// exists
//					sAttribute = "";
//					sTokens.removeAt(x);
//					for (int iTok=0;iTok<sTokens.length();iTok++) 
//					{ 
//						sAttribute += sTokens[iTok] + ";";
//					}//next iTok
//					newAttrribute = sAttribute;
//				}
//				else
//				{ 
//					sAttribute = "";
//					for (int iTok=0;iTok<sTokens.length();iTok++) 
//					{ 
//						sAttribute += sTokens[iTok] + ";";
//					}//next iTok
//					newAttrribute = sAttribute + variable+";";
//					reportMessage("\n" + sObjectVariables[nRetVal] + " new: " + newAttrribute);
//				}
//				sBeamType.set(newAttrribute);
////				reportMessage("\n" + sLevelName + " " + T("|set to|")+" " +newAttrribute);	
////				reportNotice("\n" + sLevelName + " " + T("|set to|")+" " +newAttrribute);	
//			}
//			
//			
//			String sAttribute = sBeamType;
//			
//			String sPrompt;
//			sPrompt+="\n"+  T("|Select a property by index to add or to remove|") + T(", |0 = Exit|");
//			reportNotice("\n"+sPrompt);
//			String sObjectVariables[0];
//			sObjectVariables.append(sBmType);
//			for (int s=0;s<sObjectVariables.length();s++) 
//			{ 
//				String key = sObjectVariables[s]; 
//				//String sSelection= sFormat.find(key,0, false)<0?"" : T(", |is selected|");
//	//			String sAddRemove = sAttribute.find(key,0, false)<0?"   " : "√";
//				sAttribute.trimLeft();
//				sAttribute.trimRight();
//				String sTokens[] = sAttribute.tokenize(";");
//				String sAddRemove = "   ";
//				for (int iTok=0;iTok<sTokens.length();iTok++) 
//				{ 
//					String sTokI = sTokens[iTok]; 
//					sTokI.makeUpper();
//					String sKeyUpp=key;
//					sKeyUpp.makeUpper();
//					if(sTokI==sKeyUpp)
//					{ 
//						sAddRemove = "√";
//						break;
//					}
//				}//next iTok
//				
//				int x = s + 1;
//				String sIndex = ((x<10)?"    " + x:"  " + x)+ "  "+sAddRemove+"   ";//
//				reportNotice("\n"+sIndex+key + "........: ");
//			}//next i
//			reportMessage("\n" + sBeamTypeName + " " + T("|set to|")+" " +sBeamType);
//			reportNotice("\n" + "\n"+ sBeamTypeName + " " + T("|set to|")+" " +sBeamType);
//			reportNotice("\n"+sPrompt);
//			
//			nRetVal = getInt(sPrompt)-1;
//		}
//		setExecutionLoops(2);
//		return;
//	}//endregion	
	



#End
#BeginThumbnail



#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15821: fix properties on insert" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="9/5/2022 8:50:49 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="fix properties on insert" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="7/19/2022 9:18:14 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15906: and hidden property to store selected painterdefinition" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="7/4/2022 1:00:02 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-10541: support painter definition" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="3/24/2021 11:15:37 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-10541: initial" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="3/15/2021 8:39:40 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End