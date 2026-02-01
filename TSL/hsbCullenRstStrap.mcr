#Version 8
#BeginDescription
#Versions:
Version 1.9 24.09.2024 HSB-20926: Support connection beam wall; , Author Marsel Nakuci
1.8 03/07/2024 HSB-20926: Add property "TextHeight"; add command to control assignment Marsel Nakuci
version value="1.7" date="27.09.2019" author="marsel.nakuci@hsbcad.com"
HSB-5439: display of second beam not possible if only one beam
HSB-5439: initialize grip point _PtG[0] with _Pt0 
HSB-5439: for two genbeams take vec0 from first beam and vec1 from second beam 
HSB-5439 Bug in HSB-5388 was fixed so now don't need the map to save genBeams 
HSB-5439 fix geometry of strap
HSB-5439 improve behaviour and make it similar to sympson strongtie 
HSB-5439 working version
HSB-5439 initial




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 9
#KeyWords 
#BeginContents
/// <History>//region
/// #Versions:
// 1.9 24.09.2024 HSB-20926: Support connection beam wall; , Author Marsel Nakuci
// 1.8 03/07/2024 HSB-20926: Add property "TextHeight"; add command to control assignment Marsel Nakuci
/// <version value="1.7" date="27.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5439: display of second beam not possible if only one beam </version>
/// <version value="1.6" date="27.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5439: initialize grip point _PtG[0] with _Pt0 </version>
/// <version value="1.5" date="16.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5439: for two genbeams take vec0 from first beam and vec1 from second beam </version>
/// <version value="1.4" date="10.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5439: Bug in HSB-5388 was fixed so now don't need the map to save genBeams </version>
/// <version value="1.3" date="10.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5439 fix geometry of strap </version>
/// <version value="1.2" date="08.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5439 improve behaviour and make it similar to sympson strongtie </version>
/// <version value="1.1" date="30.08.2019" author="marsel.nakuci@hsbcad.com"> HSB-5439 working version </version>
/// <version value="1.0" date="28.08.2019" author="marsel.nakuci@hsbcad.com"> HSB-5439 initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates straps between 2 genBeams that form 90 degree angle between each other
/// plane from the first genbeam finds the planes from the 2nd genbeam that are normal to this plane.
/// Direction of the strap is defined from the commmon vector of 2 planes
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCullenRst1Strap")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion


//region constants 
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
	String tDisabled = T("<|Disabled|>"),tDefaultEntry = T("<|Default|>"), tNoGroupAssignment =T("|No group assigment|");
	String sGroupings[] = { tDefaultEntry, tNoGroupAssignment};
//end constants//endregion

//region Functions

//region getMainHardwareDefinition
// Writes the hardware for the hcwl	
HardWrComp getMainHardwareDefinition(int _nQty, String _sModel)
{ 
//	String _sHWArticleNumber="2316495";
	String _sHWArticleNumber=_sModel;
	HardWrComp _hwc(_sHWArticleNumber, _nQty);
	String _sHWManufacturer = "Cullen";
	_hwc.setManufacturer(_sHWManufacturer);
	String _sHWModel =_sModel;
	_hwc.setModel(_sHWModel);
	String sHWDescription = "Restraint Strap Twist";
	_hwc.setDescription(sHWDescription);
	_hwc.setMaterial("30 x 1.2mm Galvanised mild steel – Z275")
	_hwc.setCategory(T("|Connector|"));
	_hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
	return _hwc;
}
//End getMainHardwareDefinitionl//endregion

//region getTextOrientation
// text should continue in the direction of _vx
// vxTxt,vyTxt should have the orientation of reading firection
// nx is calculated fromt _vx the direction the text should run
Map getTextOrientation(Vector3d _vx)
{ 
	Map _m;
	Vector3d _vxTxt=_vx;
	Vector3d _vyTxt=_ZW.crossProduct(_vxTxt);
	
	int _nx=1;
	if(_vx.dotProduct(_XW)<-dEps)
	{ 
		_nx=-1;
		_vxTxt=-_vx;
	}
	else if(_vx.isParallelTo(_YW))
	{ 
		if(_vx.dotProduct(_YW)<0)
		{ 
			_nx=-1;
			_vxTxt=-_vx;
		}
	}
	if(_vyTxt.dotProduct(_YW)<-dEps)
	{ 
		_vyTxt*=-1;
	}
	else if(_vyTxt.isParallelTo(_XW))
	{ 
		if(_vyTxt.dotProduct(_XW)>0)
		{ 
			_vyTxt*=-1;
		}
	}
	_m.setVector3d("vx",_vxTxt);
	_m.setVector3d("vy",_vyTxt);
	_m.setInt("nx", _nx);
	
	return _m;
}
//End getTextOrientation//endregion

//region Function collectTslsByName
	// returns the amount of all tsl instances with a certain scriptname and modifis the input array
	// tsls: the array to search, if empty all tsls in modelspace are taken
	// names: the names of the tsls to be returned
	int getTslsByName(TslInst& tsls[], String names[])
	{ 
		int out;
		
		if (tsls.length()<1)
		{ 
			Entity ents[] = Group().collectEntities(true, TslInst(),  _kModelSpace);
			for (int i=0;i<ents.length();i++) 
			{ 
				TslInst t= (TslInst)ents[i]; 
				//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
				if (t.bIsValid() && names.findNoCase(t.scriptName(),-1)>-1)
					tsls.append(t);
			}//next i
		}
		else
		{ 
			for (int i=tsls.length()-1; i>=0 ; i--) 
			{ 
				TslInst t= (TslInst)tsls[i]; 
				if (t.bIsValid() && names.findNoCase(t.scriptName(),-1)<0)
					tsls.removeAt(i);
			}//next i			
		}
		
		out = tsls.length();
		return out;
	}
//End collectTslsByName //endregion	

//region displayTextPlan
// draws the product code
	void displayTextPlan(Map _min)
	{ 
		double _dTextHeight=U(50);
		if(_min.hasDouble("TextHeight"))
		{ 
			_dTextHeight=_min.getDouble("TextHeight");
		}
		int _nColor=7;
		if(_min.hasInt("Color"))
		{ 
			_nColor=_min.getInt("Color");
		}
		
		Vector3d _vx=_XW;
		Vector3d _vy=_YW;
		if(_min.hasVector3d("vx"))
		{ 
			_vx=_min.getVector3d("vx");
		}
		if(_min.hasVector3d("vy"))
		{ 
			_vy=_min.getVector3d("vy");
		}
		int _nx=-1;
		if(_min.hasInt("nx"))
		{ 
			_nx=_min.getInt("nx");
		}
		
		String sTxt=_min.getString("Text");
		
		Point3d _pt=_min.getPoint3d("pt");
		
		Display _dp(_nColor);
		_dp.textHeight(_dTextHeight);
		_dp.addViewDirection(_ZW);
		
		_dp.draw(sTxt,_pt,_vx,_vy,_nx,0);
		
		
		
		return;
	}
//End displayTextPlan//endregion


//region calcGbPlanes
// calculates all 6 faces of genbeam	
// and the planeprofiles
Map calcGbPlanes(GenBeam _gb)
{ 
// calculates all 6 planes of the genbeam
// and the corresponding planeProfiles for each face
// return as entries in a map
	Map _mOut;
	
	Vector3d _vecX=_gb.vecX();
	Vector3d _vecY=_gb.vecY();
	Vector3d _vecZ=_gb.vecZ();
	Point3d _ptCen=_gb.ptCen();
	double _dL=_gb.dL();
	double _dW=_gb.dW();
	double _dH=_gb.dH();
	
	Body bd=_gb.envelopeBody();
	Vector3d _vecs[]={-_vecX,_vecX,-_vecY,_vecY,-_vecZ,_vecZ};
	Point3d _ptsPlanes[]={_ptCen-.5*_dL*_vecX,_ptCen+.5*_dL*_vecX,
						_ptCen-.5*_dW*_vecY,_ptCen+.5*_dW*_vecY,
						_ptCen-.5*_dH*_vecZ,_ptCen+.5*_dH*_vecZ};
	for (int i=0;i<_vecs.length();i++) 
	{ 
		Vector3d vecI=_vecs[i];
		Point3d ptI=_ptsPlanes[i];
		Plane pnI(ptI,vecI);
		PlaneProfile ppI=bd.extractContactFaceInPlane(pnI,U(1));
		ppI.vis(i+1);
		Map mi;
		mi.setPlaneProfile("pp",ppI);
		mi.setPoint3d("pt",ptI);
		mi.setVector3d("vec",vecI);
		_mOut.appendMap("m",mi);
	}//next i
	
	return _mOut;
}
//End calcGbPlanes//endregion

// get all possible positions
//region calcAllPlaneCouples
// it calculates all possible plane couples
// between 2 beams
// for each plane it also returns the planeprofile of the face

	Map calcAllPlaneCouples(GenBeam _gbs[],double _dWidthStrap)
	{ 
		Map _mOut;
		
		if(_gbs.length()!=2)
		{ 
			_mOut.setInt("Error",true);
			String sError=T("|2 genbeams needed|");
			_mOut.setString("sError",sError);
			return _mOut;
		}
	// 
	// first and second genbeam
		GenBeam _gb0=_gbs[0];
		GenBeam _gb1=_gbs[1];
		
		Vector3d _vecX0=_gb0.vecX();
		Vector3d _vecY0=_gb0.vecY();
		Vector3d _vecZ0=_gb0.vecZ();
		Point3d _ptCen0=_gb0.ptCen();
		double dL0=_gb0.dL();
		double dW0=_gb0.dW();
		double dH0=_gb0.dH();
		
		Vector3d _vecX1=_gb1.vecX();
		Vector3d _vecY1=_gb1.vecY();
		Vector3d _vecZ1=_gb1.vecZ();
		Point3d _ptCen1=_gb1.ptCen();
		double dL1=_gb1.dL();
		double dW1=_gb1.dW();
		double dH1=_gb1.dH();
		
		// calculate planes for each beam
		Map m0=calcGbPlanes(_gb0);
		Map m1=calcGbPlanes(_gb1);
		
		// get all valid couples
		for (int i=0;i<m0.length();i++) 
		{ 
			Map mi=m0.getMap(i);
			PlaneProfile ppi=mi.getPlaneProfile("pp");
			Point3d pti=mi.getPoint3d("pt");
			Vector3d veci=mi.getVector3d("vec");
			Plane pni(pti, veci);
			Point3d ptMidi=ppi.ptMid();
			
			for (int j=0;j<m1.length();j++) 
			{ 
				Map mj=m1.getMap(j);
				
				PlaneProfile ppj=mj.getPlaneProfile("pp");
				Point3d ptj=mj.getPoint3d("pt");
				Vector3d vecj=mj.getVector3d("vec");
				Plane pnj(ptj, vecj);
				Point3d ptMidj=ppj.ptMid();
				if(!veci.isPerpendicularTo(vecj))
				{ 
					// ignore non perpendicular planes
					continue;
				}
				// get the line between 2 planes
				Line lnij=pni.intersect(pnj);
				Vector3d vecij=lnij.vecX();
				
				
				LineSeg segi=ppi.extentInDir(vecij);
				Point3d pti0=segi.ptStart();
				Point3d pti1=segi.ptEnd();
				
				LineSeg segj=ppj.extentInDir(vecij);
				Point3d ptj0=segj.ptStart();
				Point3d ptj1=segj.ptEnd();
				
//				ppi.vis(2);
//				ppj.vis(3);
				// middle point in the direction of line
				Point3d ptMidij;
				// get the middle point between 2 planeprofiles
				{ 
					Point3d pts[]={pti0,pti1,ptj0,ptj1};
					Point3d ptSorted[]=lnij.orderPoints(pts);
					ptMidij=.5*(ptSorted[1]+ptSorted[2]);
					
					// check gow far apart the closest points are
					if(abs(vecij.dotProduct(ptSorted[1]-ptSorted[2]))>U(400))
					{ 
						// too far apart
						continue;
					}
					
				}
				ptMidij=lnij.closestPointTo(ptMidij);
//				ptMidij.vis(3);
				// check that strip of WidthStrap touches the genbeam planeprofiles
				
				// ppi
				{ 
					// toward the i
					Vector3d vecNi=vecij.crossProduct(veci);
					vecNi.normalize();
					if(vecNi.dotProduct(ptMidi-ptMidij)<0)vecNi*=-1;
//					vecNi.vis(ptMidij);
					//
					PlaneProfile ppStripi(ppi.coordSys());
					ppStripi.createRectangle(LineSeg(ptMidij-vecij*U(10e4),
						ptMidij+vecij*U(10e4)+vecNi*_dWidthStrap),vecij,vecNi);
//					ppStripi.vis(3);
					if(!ppStripi.intersectWith(ppi))
					{
						// too far apart, width of connector can not reach both faces
						continue;
					}
				}
				// ppj
				{ 
					// toward the i
					Vector3d vecNj=vecij.crossProduct(vecj);
					vecNj.normalize();
					if(vecNj.dotProduct(ptMidj-ptMidij)<0)vecNj*=-1;
//					vecNj.vis(ptMidij);
					//
					PlaneProfile ppStripj(ppj.coordSys());
					ppStripj.createRectangle(LineSeg(ptMidij-vecij*U(10e4),
						ptMidij+vecij*U(10e4)+vecNj*_dWidthStrap),vecij,vecNj);
//					ppStripj.vis(3);
					if(!ppStripj.intersectWith(ppj))
					{
						// too far apart, width of connector can not reach both faces
						continue;
					}
				}
				// toward ppi
				Vector3d _vecDir=vecij;
				if(_vecDir.dotProduct(ppi.ptMid()-ppj.ptMid())<0)_vecDir*=-1;
//				ptMidij.vis(3);
//				ppi.vis(2);
//				ppj.vis(3);
//				vecij.vis(ptMidij);
				// valid connection
				Map _mi;
				_mi.setPoint3d("pt",ptMidij);
				_mi.setVector3d("vij",vecij);
				_mi.setVector3d("vi", veci);
				_mi.setPlaneProfile("ppi", ppi);
				_mi.setVector3d("vj", vecj);
				_mi.setPlaneProfile("ppj", ppj);
				_mi.setVector3d("vecDir",_vecDir);
				
				_mOut.appendMap("m", _mi);
			}//next j
		}//next i
		
		if(_mOut.length()==0)
		{ 
			_mOut.setInt("Error", true);
			_mOut.setString("sError",T("|Connection between genbeams not possible|"));
		}
		
		//
		return _mOut;
	}
//End calcAllPlaneCouples//endregion 


//region getConnectionByPoint
// from all valid connections in _mIn
// it gets the one closer with the line of connection
	Map getConnectionByPoint(Map _mIn,Point3d _pt)
	{ 
		
		Map _mOut;
		
		if(_mIn.length()==0)
		{ 
			return _mOut;
		}
		
		double _dClosest=U(10e9);
		for (int i=0;i<_mIn.length();i++) 
		{ 
			Map mi=_mIn.getMap(i);
			Line lni(mi.getPoint3d("pt"),mi.getVector3d("vij"));
			Point3d ptLni=lni.closestPointTo(_pt);
			double _dDistI=(ptLni-_pt).length();
			if(_dDistI<_dClosest)
			{ 
				_dClosest=_dDistI;
				_mOut=mi;
			}
		}//next i
		Point3d _ptij=_mOut.getPoint3d("pt");
		Vector3d _vij=_mOut.getVector3d("vij");
		_vij.vis(_ptij);
		return _mOut;
	}
//End getConnectionByPoint//endregion

	Map getConnectionByVectors(Map _mIn,Vector3d _v1,Vector3d _v2)
	{ 
		Map _mOut;
		
		if(_mIn.length()==0)
		{ 
			return _mOut;
		}
		
		double _dClosest=U(10e9);
		for (int i=0;i<_mIn.length();i++) 
		{ 
			Map mi=_mIn.getMap(i);
			
			if(mi.getVector3d("vi").isParallelTo(_v1)
				 && mi.getVector3d("vi").isCodirectionalTo(_v1)
				 && mi.getVector3d("vj").isParallelTo(_v2)
				 && mi.getVector3d("vj").isCodirectionalTo(_v2))
			{ 
				// found
				_mOut=mi;
				break;
			}	 
		}//next i
		Point3d _ptij=_mOut.getPoint3d("pt");
		Vector3d _vij=_mOut.getVector3d("vij");
		_vij.vis(_ptij);
		return _mOut;
	}

//End Functions//endregion


//region Settings
// settings prerequisites
	String sDictionary="hsbTSL";
	String sPath=_kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral=_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName="hsbCullenRstStrap";
	Map mapSetting;

// compose settings file location
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound=_bOnInsert?sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder):false;
	String sFullPath=sPath+"\\"+sFolder+"\\"+sFileName+".xml";

// read a potential mapObject
	MapObject mo(sDictionary,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid())
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
		int nVersion=mapSetting.getInt("GeneralMapObject\\Version");
		String sFile=findFile(sPathGeneral+sFileName+".xml");		// set default xml path
		if (sFile.length()<1) sFile=findFile(sFullPath);				// set custom xml path if no default found
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);	// read the xml from installation directory
		int nVersionInstall=mapSettingInstall.getMap("GeneralMapObject").getInt("Version");
		if(sFile.length()>0 && nVersion!=nVersionInstall)
			reportNotice(TN("|A different Version of the settings has been found for|")+scriptName()+
			TN("|Current Version| ")+nVersion+"	"+_kPathDwg + TN("|Other Version| ") +nVersionInstall+"	"+sFile);
	}
	// Global Settings
	String sTriggerGlobalSetting = T("|Global Settings|");
	String kGlobalSettings = "GlobalSettings", kGroupAssignment= "GroupAssignment";
	int nGroupAssignment;
	Map mapGlobalSettings = mapSetting.getMap(kGlobalSettings);
	if (mapGlobalSettings.hasInt(kGroupAssignment))
		nGroupAssignment = mapGlobalSettings.getInt(kGroupAssignment);	
//End Settings//endregion	

	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode==4)
	{ 
		setOPMKey("GlobalSettings");	
		
		String sGroupAssignmentName=T("|Group Assignment|");	
		PropString sGroupAssignment(nStringIndex++, sGroupings, sGroupAssignmentName);	
		sGroupAssignment.setDescription(T("|Defines to layer to assign the instance|, ") + tDefaultEntry + T(" = |byEntity|"));
		sGroupAssignment.setCategory(category);
		return;
	}	

//region properties
	double dX[] ={ U(400), U(848), U(1350)};
	double dY[] ={ U(200), U(235), U(235)};
	
	String sTypeName = T("|Type|");
	String sTypes[] ={ "RST1", "RST2", "RST3"};
	PropString sType(nStringIndex++, sTypes, sTypeName);
	sType.setDescription(T("|Defines the Type|"));
	sType.setCategory(category);
	
	String sWidthStrapName = T("|WidthStrap|");
	PropDouble dWidthStrap(nDoubleIndex++, U(40), sWidthStrapName);	
	dWidthStrap.setDescription(T("|Defines the WidthStrap|"));
	dWidthStrap.setCategory(category);
	
	category=T("|Display|");
	String sTextHeightName=T("|Text Height|");
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);
	dTextHeight.setDescription(T("|Defines the TextHeight|"));
	dTextHeight.setCategory(category);
//End properties//endregion 
	
	
// bOnInsert//region
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
		
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();

		if (sKey.length() > 0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for (int i = 0; i < sEntries.length(); i++)
				sEntries[i] = sEntries[i].makeUpper();
			if (sEntries.find(sKey) >- 1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
		else
			showDialog();
		
		// prompt for the selection of genBeams
		
		// prompt for entities
			Entity ents[0];
			GenBeam gBeams[0];
			ElementWallSF esf;
			PrEntity ssE(T("|Select genBeam(s) and/or walls|"), GenBeam());
			ssE.addAllowedClass(ElementWallSF());
			if (ssE.go())
				ents.append(ssE.set());
			
			if (ents.length() < 1)
			{ 
				reportMessage(TN("|Select at least one genBeam (beam, sheet or panel)|"));
				eraseInstance();
				return;
			}
			
			for (int e=0;e<ents.length();e++) 
			{ 
				ElementWallSF esfE=(ElementWallSF)ents[e];
				if(esfE.bIsValid())
				{ 
					esf=esfE;
					break;
				}
			}//next e
			
			if(!esf.bIsValid())
			{ 
				// no SF wall selected
			
			// get point (grip point needed to define the position of the connection)
				Point3d pt = getPoint(TN("|Select the Point|"));
							
				// initialize _Pt0 with pt
				_Pt0 = pt;
				// save the point at the grip points
				if (_PtG.length() == 0)
				{ 
					_PtG.append(pt);
				}
				else
				{
					_PtG[0] = pt;
				}
				
				for (int i = 0; i < ents.length(); i++)
				{ 
					GenBeam gb = (GenBeam) ents[i];
					if (gb.bIsValid())
					{ 
						_GenBeam.append(gb);
					}
					if (_GenBeam.length() == 2)
					{ 
						// 2 genBeams found, dont append any more
						break;
					}
				}//next i
				
				// initialize indices in _Map
				// index for side at genBeam1, 1or -1
				_Map.setInt("iVdir", 1);
				// index for side at genBeam2
				_Map.setInt("iVdir1", 1);
				
				// index for placing X at genBeam2 or genBeam1, 0 or 1
				_Map.setInt("iSide", 1);
			}
			else
			{ 
			// beam with wall is selected
			// insert tsl with mode for this connection
			// create TSL
				TslInst tslNew;	Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
				GenBeam gbsTsl[1]; Entity entsTsl[1]; Point3d ptsTsl[]={_Pt0};
				int nProps[]={}; 
				double dProps[]={dWidthStrap,dTextHeight}; 
				String sProps[]={sType};
				Map mapTsl;
				mapTsl.setInt("Mode", 101);
				
				for (int e=0;e<ents.length();e++) 
				{ 
					GenBeam gbE = (GenBeam) ents[e];
					if (gbE.bIsValid())
					{ 
						gbsTsl[0]=gbE;
						entsTsl[0] = esf;
						
						tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
							ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
					}
				}//next e
				
				eraseInstance();
				return;
			}
			
		return;
	}
// end on insert	__________________//endregion


int nMode=_Map.getInt("Mode");
if(nMode==0)
{ 
	// default 1 gb or 2 gbs
	//region validate
		
		if (_GenBeam.length() < 1)
		{ 
			reportMessage(TN("|no genBeam (beam, sheet, panel) found|"));
			eraseInstance();
			return;
		}
		
	//End validate//endregion
	
	_GenBeam[0].envelopeBody().vis(1);
	//_GenBeam[1].envelopeBody().vis(2);
	GenBeam gb,gb1;
	if(_GenBeam.length()>0)
	{ 
		gb=_GenBeam[0];
	}
	if(_GenBeam.length()>1)
	{ 
		gb1=_GenBeam[1];
	}
	
	//region flip beams
		
		if (_GenBeam.length() == 2)
		{ 
			// 2 genBeams, have the command flipGenBeams
			// Trigger flipGenBeams//region
			String sTriggerflipGenBeams = T("|flip genBeams|");
			addRecalcTrigger(_kContext, sTriggerflipGenBeams );
			if (_bOnRecalc && (_kExecuteKey == sTriggerflipGenBeams || _kExecuteKey == sDoubleClick))
			{
				// swap 0 with 1
				_GenBeam.swap(0, 1);
				// trigger recalculation
				setExecutionLoops(2);
				return;
			}//endregion		
		}
		
	//End flip beams//endregion
	
	
	//region add or remove genBeams
		
		if (_GenBeam.length() < 2)
		{ 
			// Trigger addGenBeam//region
			String sTriggeraddGenBeam = T("|Add genBeam|");
			addRecalcTrigger(_kContext, sTriggeraddGenBeam );
			if (_bOnRecalc && (_kExecuteKey == sTriggeraddGenBeam))
			{
				GenBeam genBeamSelected = getGenBeam(TN("|Select the genBeam|"));
				
				if (_GenBeam[0] != genBeamSelected)
				{
					// selected genBeam new, append in _GenBeam
					_GenBeam.append(genBeamSelected);
				}
				setExecutionLoops(2);
				return;
			}//endregion
		}
		
		if (_GenBeam.length() == 2)
		{ 
			// Trigger removeGenBeam//region
			String sTriggerremoveGenBeam = T("|Remove genBeam|");
			addRecalcTrigger(_kContext, sTriggerremoveGenBeam );
			if (_bOnRecalc && (_kExecuteKey==sTriggerremoveGenBeam))
			{
				// get genBeam	
				GenBeam gb = getGenBeam(TN("|Select the genBeam|"));
				int iFound = (_GenBeam.find(gb));
				
				if (iFound >- 1)
				{ 
					// remove from array
					_GenBeam.removeAt(iFound);
				}
				
				setExecutionLoops(2);
				return;
			}//endregion	
		}
		
	//End add or remove beam//endregion 
		
		
	// Trigger flipAtgenBeam1//region
		String sTriggerflipAtgenBeam1 = T("|flip At genBeam 1|");
		addRecalcTrigger(_kContext, sTriggerflipAtgenBeam1 );
		if (_bOnRecalc && (_kExecuteKey == sTriggerflipAtgenBeam1 || _kExecuteKey == sDoubleClick))
		{
			if (_Map.hasInt("iVdir"))
			{ 
				int iVdir = _Map.getInt("iVdir");
				iVdir *= -1;
				_Map.setInt("iVdir", iVdir);
			}
			
			setExecutionLoops(2);
			return;
		}//endregion
		
	// Trigger flipAtgenBeam2//region
		String sTriggerflipAtgenBeam2 = T("|flip At genBeam 2|");
		addRecalcTrigger(_kContext, sTriggerflipAtgenBeam2 );
		if (_bOnRecalc && (_kExecuteKey==sTriggerflipAtgenBeam2 || _kExecuteKey==sDoubleClick))
		{
			if(_Map.hasInt("iVdir1"))
			{ 
				int iVdir1 = _Map.getInt("iVdir1");
				iVdir1 *= -1;
				_Map.setInt("iVdir1", iVdir1);
			}
			
			setExecutionLoops(2);
			return;
		}//endregion
		
	// Trigger swapXY//region
		String sTriggerswapXY = T("|swap X-Y|");
		addRecalcTrigger(_kContext, sTriggerswapXY );
		if (_bOnRecalc && (_kExecuteKey==sTriggerswapXY || _kExecuteKey==sDoubleClick))
		{
			if(_Map.hasInt("iSide"))
			{ 
				int iSide = _Map.getInt("iSide");
				iSide *=-1;
				_Map.setInt("iSide", iSide);
			}
			
			setExecutionLoops(2);
			return;
		}//endregion		
	
	//region Trigger GlobalSettings
	{ 
		// create TSL
		TslInst tslDialog; 			Map mapTsl;						
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
		int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
		addRecalcTrigger(_kContext, sTriggerGlobalSetting);
		if (_bOnRecalc && _kExecuteKey==sTriggerGlobalSetting)	
		{ 
			mapTsl.setInt("DialogMode",4);
			
			String groupAssignment = sGroupings.length()>nGroupAssignment?sGroupings[nGroupAssignment]:tDefaultEntry;
			sProps.append(groupAssignment);
	
			tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
			if (tslDialog.bIsValid())
			{
				int bOk = tslDialog.showDialog();
				if (bOk)
				{ 
					groupAssignment = tslDialog.propString(0);
					nGroupAssignment = sGroupings.findNoCase(groupAssignment, 0);
					
					Map m = mapSetting.getMap(kGlobalSettings);
					m.setInt(kGroupAssignment, nGroupAssignment);								
					mapSetting.setMap(kGlobalSettings, m);
					
					if (mo.bIsValid())mo.setMap(mapSetting);
					else mo.dbCreate(mapSetting);				
				}
				tslDialog.dbErase();
			}
			
		// trigger other instances	to update their layer assignment
			if (nGroupAssignment == 1)
			{
				assignToLayer("0");	
				Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);
				
				TslInst tsls[0];
				String names[] ={ scriptName()};
				int n = getTslsByName(tsls, names);
				for (int i = 0; i < n; i++)
				{
					TslInst tsl = tsls[i];
					Map m = tsl.map();
					m.setInt("setLayer", true);
					tsl.setMap(m);
					tsl.recalc();
				}//next i
			}
			
			setExecutionLoops(2);
			return;	
		}
		//endregion	
	}
	//End Dialog Trigger//endregion 
	
	//region assign
		// Z general item
		if(nGroupAssignment==0)
		{
			assignToGroups(gb);
			if(gb1.bIsValid())
			{ 
				assignToGroups(gb1);
				Element el=gb.element();
				Element el1=gb1.element();
				if(el.bIsValid() && el1.bIsValid())
				{ 
					assignToLayer("0");
					int nz=gb.myZoneIndex();
					int nz1=gb1.myZoneIndex();
					
					assignToElementGroup(el,true,nz,'Z');
					assignToElementGroup(el1,false,nz1,'Z');
				}
			}
		}
	
		if (nGroupAssignment==1)
		{ 
			int bSetLayer = _Map.getInt("setLayer");
			
			if ((_bOnDbCreated || _kNameLastChangedProp==sTriggerGlobalSetting) || bSetLayer)
			{ 
	//			reportNotice("\nflag =" +  bSetLayer);
				assignToLayer("0");	
				_Map.removeAt("setLayer", true);
			}
	//			String layer = _ThisInst.layerName();
	//			if (layer.find("~",0,false)>-1) // assuming a layer consisting a tilde is an hsb group layer previously assigned
	//			{ 
	//				assignToLayer("0");	
	//			}
		}		
	//End assign//endregion 
		
	//region evaluate
	
		if(_PtG.length()<1)
		{ 
			// if TSL is created from another TSL, there is no insert so the ptg
			// must be initialized with _Pt0
			_PtG.append(_Pt0);
	//		// no point was defined
	//		eraseInstance();
	//		return;
		}
		_Pt0.vis(4);
		
	//End evaluate //endregion 
		
		
	//region if _Pt0 is changed, _PtG[0] should not change and it must keep its position
		
		if(_bOnDbCreated)
		{ 
			_Map.setPoint3d("_PtG0", _PtG[0], _kAbsolute);
		}
		
		if (_kNameLastChangedProp != "_PtG0")
		{ 
			// get the saved ptg0
			if(_Map.hasPoint3d("_PtG0"))
			{ 
				_PtG[0] = _Map.getPoint3d("_PtG0");
			}
		}
		_Map.setPoint3d("_PtG0", _PtG[0], _kAbsolute);
		_PtG[0].vis(3);
		
	//End if _Pt0 is changed, _PtG[0] should not change and it must keep its position//endregion 
		
		
	//region data of properties
		
		int iSelectedType = sTypes.find(sType);
	
	//End data of properties//endregion 
		
		
	//region some data for first beam
		
	//	GenBeam gb = _GenBeam[0];
		Vector3d vecX = gb.vecX();
		Vector3d vecY = gb.vecY();
		Vector3d vecZ = gb.vecZ();
		Point3d ptCen = gb.ptCen();
		Point3d ptCenSolid = gb.ptCenSolid();
		double dLength = gb.solidLength();
		double dWidth = gb.solidWidth();
		double dHeight = gb.solidHeight();
		
	//End some data//endregion 
		
	//region 6 bounding planes for the first beam
		
		// first genBeam
		double dDimExtrems[] ={ .5 * dLength, .5 * dLength,
								.5 * dWidth, .5 * dWidth,
								.5 * dHeight, .5 * dHeight};
		Vector3d vecExtrems[] ={ vecX, - vecX, vecY ,- vecY, vecZ ,- vecZ};
		Plane planes[0];
		for (int i = 0; i < 6; i++)
		{
			planes.append(Plane(ptCenSolid + dDimExtrems[i] * vecExtrems[i], vecExtrems[i]));
		}
		Quader qd(ptCenSolid, vecX, vecY, vecZ, dLength, dWidth, dHeight);
		qd.vis(4);
		
		
	//End bounding planes of 2 genBeams//endregion  
		
		
	//region 2planes where connection will be generated
		
		Plane plane0;
		Vector3d vec0;
		Plane plane1;
		Vector3d vec1;
		// line in deirection from ppj to ppi
		Vector3d vecDir0;
	//End 2planes where connection will be generated//endregion 
		
		
	if (_GenBeam.length() == 1)
	{ 
		// index of first plane
		// index of second plane
		int iPlaneClosest = - 1;
		int iPlaneClosest1 = - 1;
		// only one beam
		double dDistMin = 10e12;
		for (int i = 0; i < planes.length(); i++)
		{ 
			for (int j = 0; j < planes.length(); j++)
			{ 
				// dont consider parallel planes
				if (abs(abs(vecExtrems[i].dotProduct(vecExtrems[j])) - 1) < dEps)
				{ 
					// parallel planes
					continue;
				}
				// line between two planes
				int iHasIntersection = planes[i].hasIntersection(planes[j]);
				if ( ! iHasIntersection)
				{ 
					// no intersection
					continue;
				}
				Line ln = planes[i].intersect(planes[j]);
				double dDist = (ln.closestPointTo(_PtG[0]) - _PtG[0]).length();
				
				if (dDist < dDistMin)
				{ 
					dDistMin = dDist;
					iPlaneClosest = i;
					iPlaneClosest1 = j;
				}
			}
		}
		
		// closest plane between i and j
		plane0 = planes[iPlaneClosest];
		vec0 = vecExtrems[iPlaneClosest];
		plane1 = planes[iPlaneClosest1];
		vec1 = vecExtrems[iPlaneClosest1];
		if ((plane1.closestPointTo(_PtG[0]) - _PtG[0]).length() < 
			(plane0.closestPointTo(_PtG[0]) - _PtG[0]).length())
		{ 
			plane0 = planes[iPlaneClosest1];
			vec0 = vecExtrems[iPlaneClosest1];
			plane1 = planes[iPlaneClosest];
			vec1 = vecExtrems[iPlaneClosest];
		}
		
		// project _Pt0 to the edge
		Line ln = plane0.intersect(plane1);
		_Pt0 = ln.closestPointTo(_Pt0);
		
	}
	else
	{ 
		// has second genBeam
		GenBeam gb1 = _GenBeam[1];
		
		Vector3d vecX1 = gb1.vecX();
		Vector3d vecY1 = gb1.vecY();
		Vector3d vecZ1 = gb1.vecZ();
		Point3d ptCen1 = gb1.ptCen();
		Point3d ptCenSolid1 = gb1.ptCenSolid();
		
		// genBeam2
		double dLength1 = gb1.solidLength();
		double dWidth1 = gb1.solidWidth();
		double dHeight1 = gb1.solidHeight();
		double dDimExtrems1[] ={ .5 * dLength1, .5 * dLength1,
								.5 * dWidth1, .5 * dWidth1,
								.5 * dHeight1, .5 * dHeight1};
		Vector3d vecExtrems1[] ={ vecX1, - vecX1, vecY1 ,- vecY1, vecZ1 ,- vecZ1};
		Plane planes1[0];
		for (int i = 0; i < 6; i++)
		{
			planes1.append(Plane(ptCenSolid1 + dDimExtrems1[i] * vecExtrems1[i], vecExtrems1[i]));
		}
		Quader qd1(ptCenSolid1, vecX1, vecY1, vecZ1, dLength1, dWidth1, dHeight1);
		qd1.vis(7);
		
		//region get the closest edge with the grip point
		Map mCouplesValid=calcAllPlaneCouples(_GenBeam,dWidthStrap);
		if(mCouplesValid.getInt("Error"))
		{ 
			reportMessage("\n"+scriptName()+" "+mCouplesValid.getString("sError"));;
			eraseInstance();
			return;
		}
	//	calcGbPlanes(gb);
	
		// get plane by point, from all valid couples
		// get the one where point closer to intersection line
		Map mConnection=getConnectionByPoint(mCouplesValid,_PtG[0]);
		
		
	//	// index of first plane at genBeam0
	//	// index of second plane  at genBeam1
	//	int iPlaneClosest = - 1;
	//	int iPlaneClosest1 = - 1;
	//	double dDistMin = 10e12;
	//	for (int i = 0; i < planes.length(); i++)
	//	{ 
	//		for (int j = 0; j < planes1.length(); j++)
	//		{ 
	//			// dont consider parallel planes
	//			if (abs(abs(vecExtrems[i].dotProduct(vecExtrems1[j])) - 1) < dEps)
	//			{ 
	//				// parallel planes
	//				continue;
	//			}
	//			
	//			// line between two planes
	//			int iHasIntersection = planes[i].hasIntersection(planes1[j]);
	//			if ( ! iHasIntersection)
	//			{ 
	//				// no intersection
	//				continue;
	//			}
	//			Line ln = planes[i].intersect(planes1[j]);
	//			double dDist = (ln.closestPointTo(_PtG[0]) - _PtG[0]).length();
	//			
	//			if (dDist < dDistMin)
	//			{ 
	//				dDistMin = dDist;
	//				iPlaneClosest = i;
	//				iPlaneClosest1 = j;
	//			}
	//		}//next j
	//	}//next i
	//	
	//	// closest plane between i and j
	//	plane0 = planes[iPlaneClosest];
	//	vec0 = vecExtrems[iPlaneClosest];
	//	plane1 = planes1[iPlaneClosest1];
	//	vec1 = vecExtrems1[iPlaneClosest1];
		
		plane0=Plane(mConnection.getPoint3d("pt"),mConnection.getVector3d("vi"));
		vec0=-mConnection.getVector3d("vi");
		plane1=Plane(mConnection.getPoint3d("pt"),mConnection.getVector3d("vj"));
		vec1=-mConnection.getVector3d("vj");
		vecDir0=mConnection.getVector3d("vecDir");
		
		
	//	if ((plane1.closestPointTo(_PtG[0]) - _PtG[0]).length() < 
	//		(plane0.closestPointTo(_PtG[0]) - _PtG[0]).length())
	//	{ 
	//		plane0 = planes1[iPlaneClosest1];
	//		vec0 = vecExtrems1[iPlaneClosest1];
	//		plane1 = planes[iPlaneClosest];
	//		vec1 = vecExtrems[iPlaneClosest];
	//	}
		
	//End get the closest edge with the grip point//endregion 
	
	//region line between 2 planes
		
		Line ln = plane0.intersect(plane1);
		_Pt0 = ln.closestPointTo(_Pt0);
		
	//End line between 2 planes//endregion 
	
	}
		
	//region create 3d part
		int iSide = 1;
		if (_Map.hasInt("iSide"))
		{
			iSide = _Map.getInt("iSide");
		}
		Vector3d vDir = iSide*vec0.crossProduct(vec1);
		if(vDir.dotProduct(vecDir0)<0)vDir*=-1;
		Vector3d vDir1 = -vDir;
		
		int iVdir = 1;
		int iVdir1 = 1;
		
		if (_Map.hasInt("iVdir"))
		{
			iVdir = _Map.getInt("iVdir");
		}
		if (_Map.hasInt("iVdir1"))
		{
			iVdir1 = _Map.getInt("iVdir1");
		}
		Vector3d vNormal = iVdir*vec0.crossProduct(vDir);
		Vector3d vNormal1 = iVdir1*vec1.crossProduct(vDir1);
		Body bd;
		Display dp(252);
		{ 
			vec0.vis(_Pt0, 3);
			
			PLine plShape(vec0);
			Point3d pt = _Pt0;
			plShape.addVertex(pt);
			
			pt += vDir * dWidthStrap;
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += vDir * 0.2 * dWidthStrap + vNormal * 0.2 * dWidthStrap;
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += vDir * (dY[iSelectedType] - 0.2*dWidthStrap);
			plShape.addVertex(pt);
			plShape.vis(4);
			pt += 0.8*dWidthStrap * vNormal;
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt -= vDir * dY[iSelectedType];
			plShape.addVertex(pt);
			plShape.vis(4);
			
			plShape.close();
			plShape.vis(4);
			Body bd0(plShape, vec0 * U(1.2), 1);
			bd0.vis(5);
			bd.addPart(bd0);
			
			// display number
			{
				PlaneProfile pp(plShape);
				// get extents of profile
				LineSeg seg = pp.extentInDir(vDir);
				Point3d ptText = seg.ptMid();
				dp.draw("1", ptText, vDir, vNormal,0,0);
			}
		}
		{  
			PLine plShape(vec1);
			Point3d pt = _Pt0 - vDir1 * dWidthStrap;
			plShape.addVertex(pt);
			
			pt += vDir1 * dWidthStrap;
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += vDir1 * 0.2 * dWidthStrap + vNormal1 * 0.2 * dWidthStrap;
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += vDir1 * (dX[iSelectedType] - dY[iSelectedType] - 1.2 * dWidthStrap);
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt += 0.8*dWidthStrap * vNormal1;
			plShape.addVertex(pt);
			plShape.vis(4);
			
			pt -= vDir1 * (dX[iSelectedType] - dY[iSelectedType] - dWidthStrap);
			plShape.addVertex(pt);
			plShape.vis(4);
			plShape.close();
			plShape.vis(4);
			Body bd1(plShape, vec1 * U(1.2), 1);
			bd1.vis(5);
			bd.addPart(bd1);
			
			// display number
			{
				PlaneProfile pp(plShape);
				// get extents of profile
				LineSeg seg = pp.extentInDir(vDir1);
				Point3d ptText = seg.ptMid();
				dp.draw("2", ptText, vDir1, vNormal1,0,0);
			}
		}
		
		dp.draw(bd);
		
	//End create 3d part//endregion 
	
	//region Display text
		Map mTextOrientation=getTextOrientation(vec0);
		Map mInText;
		{ 
	//		mInText.setInt("Qty",nQty);
	//		mInText.setString("Product","TFPC");
	////		mInText.setInt("Color",7);
			mInText.setString("Text",sType);
	//		mInText.setString("Text","TFPC");
			mInText.setDouble("TextHeight",dTextHeight);
			mInText.setPoint3d("pt",_Pt0+vec0*U(100));
			mInText.setVector3d("vx",mTextOrientation.getVector3d("vx"));
			mInText.setVector3d("vy",mTextOrientation.getVector3d("vy"));
			mInText.setInt("nx",mTextOrientation.getInt("nx"));
		}
		displayTextPlan(mInText);
	//End Display text//endregion 
	
	// hardware
	// Hardware//region
	// collect existing hardware
		HardWrComp hwcs[] = _ThisInst.hardWrComps();
		
	// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
		for (int i=hwcs.length()-1; i>=0 ; i--) 
			if (hwcs[i].repType() == _kRTTsl)
				hwcs.removeAt(i); 
	
	// declare the groupname of the hardware components
		String sHWGroupName;
		// set group name
		{ 
		// element
			// try to catch the element from the parent entity
			Element elHW =_GenBeam[0].element(); 
			// check if the parent entity is an element
			if (!elHW.bIsValid())	elHW = (Element)_GenBeam[0];
			if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
		// loose
			else
			{
				Group groups[] = _ThisInst.groups();
				if (groups.length()>0)	sHWGroupName=groups[0].name();
			}		
		}
	// add main componnent
		{ 
			HardWrComp hwc=getMainHardwareDefinition(1,sType);
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(_GenBeam[0]);	
		// apppend component to the list of components
			hwcs.append(hwc);
		}
		
	// make sure the hardware is updated
		if (_bOnDbCreated)	setExecutionLoops(2);
		_ThisInst.setHardWrComps(hwcs);
	//endregion
}
// beam with wall
else if(nMode==101)
{ 
	// beam with wall
	// evaluate
	Beam bm;
	ElementWall esf;
	
	if(_Beam.length()==1)
	{ 
		bm=_Beam[0];
	}
	if(_Element.length()==1)
	{ 
		esf=(ElementWallSF)_Element[0];
	}
	if(!bm.bIsValid())
	{ 
		reportMessage("\n"+scriptName()+" "+T("|No beam found for the beam wall connection|"));
		eraseInstance();
		return;
	}
	if(!esf.bIsValid())
	{ 
		reportMessage("\n"+scriptName()+" "+T("|No SF wall found for the beam wall connection|"));
		eraseInstance();
		return;
	}
	
	
	// basic information
	Point3d ptOrg=esf.ptOrg();
	Vector3d vecX=esf.vecX();
	Vector3d vecY=esf.vecY();
	Vector3d vecZ=esf.vecZ();
	
	
	// basic information
	Point3d ptCen=bm.ptCen();
	Vector3d vecXbm=bm.vecX();
	Vector3d vecYbm=bm.vecY();
	Vector3d vecZbm=bm.vecZ();
	
	if(!vecZ.isParallelTo(vecXbm))
	{ 
		reportMessage("\n"+scriptName()+" "+T("|beam not perpendicular to the wall|"));
		eraseInstance();
		return;
	}
	
	_Pt0=ptCen;
	
	// find stud for left and right side
	Beam bmLeft, bmRight;
	
	Beam beams[]=esf.beam();
	Beam bmStuds[]=vecX.filterBeamsPerpendicularSort(beams);
	
	Point3d ptLeft=ptCen-vecX*.5*bm.dD(vecX);
	Point3d ptRight=ptCen+vecX*.5*bm.dD(vecX);
	
	
	for (int b=0;b<bmStuds.length();b++) 
	{ 
		Beam bmI=bmStuds[b];
		Point3d ptLeftI=bmI.ptCen()-vecX*.5*bmI.dD(vecX);
		Point3d ptRightI=bmI.ptCen()+vecX*.5*bmI.dD(vecX);
		
		if(!bmLeft.bIsValid())
		if(vecX.dotProduct(ptRightI-ptLeft)>0
			&& vecX.dotProduct(ptLeftI-ptLeft)<0)
		{ 
			bmLeft=bmI;
		}
		if(!bmRight.bIsValid())
		if(vecX.dotProduct(ptRightI-ptRight)>0
			&& vecX.dotProduct(ptLeftI-ptRight)<0)
		{ 
			bmRight=bmI;
		}
		
		if(bmLeft.bIsValid() && bmRight.bIsValid())
		{ 
			break;
		}
	}//next b
	
	vecZ.vis(ptOrg);
	// 
//	return;
	if(bmLeft.bIsValid())
	{ 
		// get all valid conections
		GenBeam gbsTsl[2];
		gbsTsl[0]=bm;
		gbsTsl[1]=bmLeft;
		Map mCouplesValid=calcAllPlaneCouples(gbsTsl,dWidthStrap);
		
		Map mConnectionLeft=getConnectionByVectors(mCouplesValid,-vecX,vecZ);
		Point3d ptConn=mConnectionLeft.getPoint3d("pt");
		
		ptConn.vis(1);
		// insert tsl
		TslInst tslNew;	Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
		
		Entity entsTsl[]={}; Point3d ptsTsl[]={ptConn,ptConn};
		int nProps[]={}; 
		double dProps[]={dWidthStrap,dTextHeight}; 
		String sProps[]={sType};
		Map mapTsl;
		mapTsl.setInt("iVdir", -1);
		mapTsl.setInt("iVdir1", 1);
		mapTsl.setInt("Mode", 0);
		
		tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
						ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
	}
	if(bmRight.bIsValid())
	{ 
		// insert tsl
		// get all valid conections
		GenBeam gbsTsl[2];
		gbsTsl[0]=bm;
		gbsTsl[1]=bmRight;
		Map mCouplesValid=calcAllPlaneCouples(gbsTsl,dWidthStrap);
		
		Map mConnectionLeft=getConnectionByVectors(mCouplesValid,vecX,vecZ);
		Point3d ptConn=mConnectionLeft.getPoint3d("pt");
		
		ptConn.vis(1);
		// insert tsl
		TslInst tslNew;	Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
		
		Entity entsTsl[]={}; Point3d ptsTsl[]={ptConn,ptConn};
		int nProps[]={}; 
		double dProps[]={dWidthStrap,dTextHeight}; 
		String sProps[]={sType};
		Map mapTsl;
		mapTsl.setInt("iVdir", 1);
		mapTsl.setInt("iVdir1", 1);
		mapTsl.setInt("Mode", 0);
		
		tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
						ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
	}
	
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
        <int nm="BreakPoint" vl="705" />
        <int nm="BreakPoint" vl="893" />
        <int nm="BreakPoint" vl="890" />
        <int nm="BreakPoint" vl="1111" />
        <int nm="BreakPoint" vl="1104" />
        <int nm="BreakPoint" vl="318" />
        <int nm="BreakPoint" vl="397" />
        <int nm="BreakPoint" vl="1115" />
        <int nm="BreakPoint" vl="1411" />
        <int nm="BreakPoint" vl="1443" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20926: Support connection beam wall;" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="9/24/2024 4:38:11 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20926: Add property &quot;TextHeight&quot;; add command to control assignment" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="7/3/2024 4:21:14 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End