#Version 8
#BeginDescription
#Versions:
Version 1.3 20.09.2024 HSB-22659: Add support for group assignment; add description , Author Marsel Nakuci
1.2 13.09.2024 HSB-22659: Support distribution at single elements Author: Marsel Nakuci
version value="1.1" date="29.10.2019" author="marsel.nakuci@hsbcad.com" 

This tsl creates Cullen Acoustic Wall Strap
It is usually used as a separator between two walls
It Improves sound insulation against horizontal
impact noise from plugs being inserted into sockets, wall mounted switches,
doors and cupboard doors 

It can be inserted at 
a) 2 genbeams that satisfy the cavity requirement (space between)
b) at an existing wall (at top plate) that will be separated from the next parallel wall

HSB-5438 fix bug at hardware export
HSB-5438 initial




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords Cullen, aws, acoustic, wall, strap, kingspan
#BeginContents
/// <History>//region
/// #Versions:
// 1.3 20.09.2024 HSB-22659: Add support for group assignment; add description , Author Marsel Nakuci
// 1.2 13.09.2024 HSB-22659: Support distribution at single elements Author: Marsel Nakuci
/// <version value="1.1" date="29.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5438 fix bug at hardware export </version>
/// <version value="1.0" date="27.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5438 initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates Cullen Acoustic Wall Strap
/// It Improves sound insulation against horizontal
/// impact noise from plugs being inserted into sockets, wall mounted switches,
/// doors and cupboard doors 
/// It can be inserted at 
/// a) 2 genbeams that satisfy the cavity requirement (space between)
/// b) at an existing wall (at top plate) that will be separated from the next parallel wall

/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCullenAWS")) TSLCONTENT
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

//region Function getTslsByName
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
//End getTslsByName //endregion

//region calcDistributionPp
// it calculates the pp where the distribution will be done
// it returns start and end point
	Map calcDistributionPp(ElementWall _elWall)
	{ 
		Map _mOut;
		if(!_elWall.bIsValid())
		{ 
			String sError=T("|No valid wall found|");
			_mOut.setString("sError", sError);
			_mOut.setInt("Error", true);
			return _mOut;
		}
		
		Beam _beams[]=_elWall.beam();
		if(_beams.length()==0)
		{ 
			String sError=T("|No beam found at wall|");
			_mOut.setString("sError", sError);
			_mOut.setInt("Error", true);
			return _mOut;
		}
		
		// basic information
		Point3d _ptOrg=_elWall.ptOrg();
		Vector3d _vecX=_elWall.vecX();
		Vector3d _vecY=_elWall.vecY();
		Vector3d _vecZ=_elWall.vecZ();
		
		Beam _beamsHor[]=_vecY.filterBeamsPerpendicularSort(_beams);
		
		if(_beamsHor.length()==0)
		{ 
			String sError=T("|No horizontal beams found at wall|");
			_mOut.setString("sError", sError);
			_mOut.setInt("Error", true);
			return _mOut;
		}
		
		Beam _bmTopest=_beamsHor.last();
		Plane _pnTop(_bmTopest.ptCen()+.5*_bmTopest.dD(_vecY)*_bmTopest.vecD(_vecY),
			_vecY);
		PlaneProfile _pp(_pnTop);
		_pp=_bmTopest.envelopeBody().shadowProfile(_pnTop);
		_pp.shrink(-U(5));
		Beam _beamsTop[0];
		
		for (int b=0;b<_beamsHor.length();b++) 
		{ 
			Beam _bmB=_beamsHor[b];
			if(_vecY.dotProduct(_bmB.ptCen()-_bmTopest.ptCen())<U(1))
			{ 
				PlaneProfile _ppB=_bmB.envelopeBody().shadowProfile(_pnTop);
				_ppB.shrink(-U(5));
				_pp.unionWith(_ppB);
			}
		}//next b
		_pp.shrink(U(5));
	// get extents of profile
		LineSeg _seg = _pp.extentInDir(_vecX);
		Point3d _pt0Start=_seg.ptStart();
		Point3d _pt0End=_seg.ptEnd();
		_pt0Start+=_vecZ*_vecZ.dotProduct(_seg.ptMid()-_pt0Start);
		_pt0End+=_vecZ*_vecZ.dotProduct(_seg.ptMid()-_pt0End);
		
		//
		_mOut.setPoint3d("ptStart",_pt0Start);
		_mOut.setPoint3d("ptEnd",_pt0End);
		_mOut.setPoint3d("ptMid",_seg.ptMid());
		_mOut.setPlaneProfile("pp",_pp);
//		_pp.vis(6);
		
		return _mOut;
	}
//End calcDistributionPp//endregion 

//region calcDistribution
// this routine calculates the distribution
// it requires a map that contain the information
// for the calculation of distribution
// it returns a map with the distributed points
	Map calcDistribution(Map _min)
	{ 
		//
		Map _m;
		//
		Point3d _ptsDis[0];
		// input data
		double _dPartLength=_min.getDouble("PartLength");
		Point3d _pt0Start=_min.getPoint3d("pt0Start");
		Point3d _pt0End=_min.getPoint3d("pt0End");
		double _dOffsetBottom=_min.getDouble("OffsetBottom");
		double _dOffsetTop=_min.getDouble("OffsetTop");
		double _dOffsetBetween=_min.getDouble("OffsetBetween");
		Vector3d _vecDistribution=_min.getVector3d("vecDistribution");
		int _nDistribution=_min.getInt("evenDistribution");
		
		int nDistributionType=_min.getInt("DistributionType");
		
		if(nDistributionType==0)
		{ 
			// type 0, in a single row, default type
			Vector3d _vecDir=_pt0End-_pt0Start;
			_vecDir.normalize();
			if(_min.hasVector3d("vecDistribution"))
			{
				_vecDir=_vecDistribution;
			}
			Point3d _pt1=_pt0Start+_vecDir*_dOffsetBottom;
			Point3d _pt2 =_pt0End-_vecDir*(_dOffsetTop+_dPartLength);
			
			double _dDistTot = (_pt2 - _pt1).dotProduct(_vecDir);
			if (_dDistTot < 0)
			{
				String sTxt=T("|no distribution possible|");
				_m.setString("sTxt",sTxt);
				_m.setInt("Error",true);
				return _m;
			}
			if(_dOffsetBetween>0)
			{ 
				// distance is defined
				if(_nDistribution==1)
				{ 
					// even distribution
					double dDistMod=_dOffsetBetween+_dPartLength;
					int iNrParts=_dDistTot/dDistMod;
					double dNrParts=_dDistTot/dDistMod;
					if (dNrParts-iNrParts>0)iNrParts+=1;
					
					double dDistModCalc = 0;
					if (iNrParts != 0)
						dDistModCalc = _dDistTot / iNrParts;
						
					// first point
					Point3d pt;
					pt=_pt0Start+_vecDir*(_dOffsetBottom+_dPartLength/2);
					_ptsDis.append(pt);
					if (dDistModCalc>0)
					{
						for (int i=0;i<iNrParts;i++)
						{
							pt+=_vecDir*dDistModCalc;
							//					pt.vis(1);
							_ptsDis.append(pt);
						}
					}
				}
				else if(_nDistribution==0)
				{ 
					// fixed
					double dDistMod = _dOffsetBetween + _dPartLength;
					int iNrParts = _dDistTot / dDistMod;
		
					// calculated modular distance between subsequent parts
					double dDistModCalc = 0;
					dDistModCalc = dDistMod;
					// first point
					Point3d pt;
					pt=_pt0Start+_vecDir*(_dOffsetBottom+_dPartLength/2);
					_ptsDis.append(pt);
					if(dDistModCalc>0)
					{ 
						for (int i = 0; i < iNrParts; i++)
						{ 
							pt+=_vecDir*dDistModCalc;
				//					pt.vis(1);
							_ptsDis.append(pt);
						}
					}
					// last
					_ptsDis.append(_pt0End-_vecDir *(_dOffsetTop+_dPartLength/2));
				}
			}
			else if(_dOffsetBetween<0)
			{ 
				// negative entry is nr of parts
				double dDistModCalc;
				//
				int nNrParts=-_dOffsetBetween/1;
				if (nNrParts==1)
				{
					dDistModCalc=_dOffsetBottom;
					_ptsDis.append(_pt0Start+_vecDir*_dOffsetBottom);
				}
				else
				{ 
					double dDistMod=_dDistTot/(nNrParts-1);
					dDistModCalc=dDistMod;
					int nNrPartsCalc=nNrParts;
					// clear distance between parts
					double dDistBet=dDistMod-_dPartLength;
					if (dDistBet<0)
					{
						// distance between 2 subsequent parts < 0
						dDistModCalc=_dPartLength;
						// nr of parts in between 
						nNrPartsCalc=_dDistTot/dDistModCalc;
						nNrPartsCalc+=1;
					}
					// first point
					Point3d pt;
					pt=_pt0Start+_vecDir*(_dOffsetBottom+_dPartLength/2);
					_ptsDis.append(pt);
		//			pt.vis(1);
					for (int i=0;i<(nNrPartsCalc-1);i++)
					{
						pt+=_vecDir*dDistModCalc;
						_ptsDis.append(pt);
					}//next i
				}
			}
			else if(_dOffsetBetween==0)
			{ 
				// distribution not possible
			}
	//
		}
		else if(nDistributionType==1)
		{ 
			// distribution in 2 directions, grid in x and y
			double _dDistanceX=_min.getDouble("DistanceX");
			double _dOffsetX=_min.getDouble("OffsetX");
			int _nNrX=_min.getInt("NrX");
			double _dDistanceY=_min.getDouble("DistanceY");
			double _dOffsetY=_min.getDouble("OffsetY");
			int _nNrY=_min.getInt("NrY");
			
			Point3d _pt=_min.getPoint3d("ptCen");
			Vector3d vx=_min.getVector3d("vx");
			Vector3d vn=_min.getVector3d("vn");
			Vector3d vy=vn.crossProduct(vx);
			vy.normalize();
			
			//
			Point3d _ptStart=_pt;
			_ptStart.vis(3);
			_ptStart+=vx*_dOffsetX+vy*_dOffsetY;
			int _nxSpace=_nNrX-1;
			if(_nNrX>1)
			{
				double _dxSpace=_nxSpace;
				_ptStart-=vx*.5*_dxSpace*_dDistanceX;
			}
			int _nySpace=_nNrY-1;
			if(_nNrY>1)
			{
				double _dySpace=_nySpace;
				_ptStart-=vy*.5*_dySpace*_dDistanceY;
			}
			Point3d pti=_ptStart;
			_ptStart.vis(6);
			for (int ix=0;ix<_nxSpace+1;ix++) 
			{ 
//				pti=_ptStart+ix*_dDistanceX*vx;
				for (int iy=0;iy<_nySpace+1;iy++) 
				{ 
					pti=_ptStart+ix*_dDistanceX*vx+iy*_dDistanceY*vy;
//					pti.vis(2);
					_ptsDis.append(pti);
				}//next iy
			}//next ix
			
			
			
		}
		_m.setPoint3dArray("ptsDis",_ptsDis);
		return _m;
	}
//End calcDistribution//endregion 

//region drawBody
// it draws the bodies of connectors		 
	Map drawBody(Map _mIn)
	{ 
		// draws the body of the AWS along the distribution
		Map _mOut;
		PlaneProfile _pp=_mIn.getPlaneProfile("pp");
		Point3d _pts[]=_mIn.getPoint3dArray("pts");
		Entity _entWall=_mIn.getEntity("elWall");
		ElementWall _elWall=(ElementWall)_entWall;
		double _dCavity=_mIn.getDouble("dCavity");
		
		// basic information
		Point3d _ptOrg=_elWall.ptOrg();
		Vector3d _vecX=_elWall.vecX();
		Vector3d _vecY=_elWall.vecY();
		Vector3d _vecZ=_elWall.vecZ();
		
		_pp.vis(2);
		Vector3d _vecSide=_vecZ;
		Point3d _ptMid=_pp.extentInDir(_vecX).ptMid();
	//	_ptMid.vis(3);
		
		Point3d _ptSide=_pp.extentInDir(_vecSide).ptEnd();
		_ptSide.vis(3);
		
		for (int p=0;p<_pts.length();p++) 
		{ 
			_pts[p].vis(1+p);
			 
		}//next p
		
		Vector3d _vxBd=_vecX;
		Vector3d _vzBd=_vecY;
		Vector3d _vyBd=_vzBd.crossProduct(_vxBd);
		_vyBd.normalize();
		
		Point3d _ptBd=_ptMid;
		
		Body _bd(_ptBd,_vxBd,_vyBd,_vzBd,U(70),_dCavity+U(30),U(1.2),
			0,0,1);
		_bd.vis(4);
		Display _dp(3);
		if(_mIn.hasInt("Color"))
		{ 
			_dp.color(_mIn.getInt("Color"));
		}
		for (int p=0;p<_pts.length();p++) 
		{ 
			Point3d _ptp=_pts[p];
			_ptp+=_vecZ*_vecZ.dotProduct(_ptSide-_ptp);
			_ptp+=_vecZ*.5*_dCavity;
			
			Body _bdp=_bd;
			_bdp.transformBy(_ptp-_ptMid);
			_bdp.vis(4);
			_dp.draw(_bdp);
		}//next p
		
		
		return _mOut;
	}
//End drawBody//endregion

//region getHardwares
// returns the hardware comps HardWrComp[]		
	HardWrComp[] getHardwares(Map _mIn, ElementWall _elWall,
		TslInst& _tsl, int _nQty)
	{ 
//		HardWrComp _hwcsOut[0];
		HardWrComp hwcs[]=_tsl.hardWrComps();
		// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
		for (int i=hwcs.length()-1; i>=0 ; i--) 
			if (hwcs[i].repType() == _kRTTsl)
				hwcs.removeAt(i); 
		// _min: in case hardware parameters are defined in_min
		if(_mIn.length()>0)
		{ 
			
		}
		else if(_mIn.length()==0)
		{ 
			// main component
			{ 
				String sHWArticleNumber = "Acoustic Wall Strap";
				int nHWQty=1*_nQty;
				HardWrComp hwc(sHWArticleNumber, nHWQty);
				String sManufacturer = "Cullen";
				hwc.setManufacturer(sManufacturer);
				String sMaterial = "galvanised mild steel - Z600";
				hwc.setMaterial(sMaterial);
				
				hwc.setCategory(T("|Connector|"));
				hwc.setRepType(_kRTTsl);
				
				String sHWGroupName;
				Group groups[]=_elWall.groups();
				if (groups.length()>0)	sHWGroupName=groups[0].name();
				hwc.setGroup(sHWGroupName);
				
				hwc.setLinkedEntity(_elWall);
				hwcs.append(hwc);
			}
			// annular ringshank nails
			{ 
				String sType = "Square Twist Nails";
				HardWrComp hwc(sType, 6*_nQty);
				
				hwc.setCategory(T("|Connector|"));
				hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
				
				String sHWGroupName;
				Group groups[]=_elWall.groups();
				if (groups.length()>0)	sHWGroupName=groups[0].name();
				hwc.setGroup(sHWGroupName);
				
				hwc.setLinkedEntity(_elWall);
				
				// diameter
				hwc.setDScaleX(U(50));
				hwc.setDScaleY(U(3.35));
			// apppend component to the list of components
				hwcs.append(hwc);
			}
		}
//		
		
		return hwcs;
	}
//End getHardwares//endregion

//End Functions//endregion 


//region Settings
//  HSB-20923
// settings prerequisites
	String sDictionary="hsbTSL";
	String sPath=_kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral=_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName="hsbCullenAWS";
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
	String sProduct = "AWS-";
	String sProductCodes[0];
	
	sProductCodes.append(sProduct + "50");
	sProductCodes.append(sProduct + "65");
	sProductCodes.append(sProduct + "75");
	
	String sProductCodeName=T("|Product Code|");	
	PropString sProductCode(nStringIndex++, sProductCodes, sProductCodeName);	
	sProductCode.setDescription(T("|Defines the Product Code|"));
	sProductCode.setCategory(category);
	
	double dCavitys[] ={ U(50), U(65), U(75)};
	
	String sInsertionModeName=T("|Insertion Mode|");
	String sInsertionModes[]={T("|Genbeams|"),T("|Distributed at single walls|")};
	PropString sInsertionMode(nStringIndex++, sInsertionModes, sInsertionModeName);	
	sInsertionMode.setDescription(T("|Defines the InsertionMode|"));
	sInsertionMode.setCategory(category);
	
	// distribution properties
	category=T("|Distribution|");
	String sDistributionName=T("|Rule|");
	String sDistributions[]={ T("|Fixed Distribution|"),T("|Even Distribution|")};
	PropString sDistribution(nStringIndex++,sDistributions,sDistributionName);	
	sDistribution.setDescription(T("|Defines the distribution type|"));
	sDistribution.setCategory(category);	
	
	String sOffsetBottomName=T("|Start Offset|");
	PropDouble dOffsetBottom(nDoubleIndex++,U(350),sOffsetBottomName);
	dOffsetBottom.setDescription(T("|Defines the start offset|"));
	dOffsetBottom.setCategory(category);
	
	String sOffsetTopName=T("|End Offset|");
	PropDouble dOffsetTop(nDoubleIndex++,U(350),sOffsetTopName);
	dOffsetTop.setDescription(T("|Defines the end offset|"));
	dOffsetTop.setCategory(category);
	
	String sOffsetBetweenName=T("|Interdistance|");
	PropDouble dOffsetBetween(nDoubleIndex++,U(1000),sOffsetBetweenName);
	dOffsetBetween.setDescription(T("|Defines the interdistance. Negative entries will define the quantity.|"));
	dOffsetBetween.setCategory(category);
//End properties//endregion 
	
	
// bOnInsert//region
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) {eraseInstance();return;}
						
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[]= TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
	// standard dialog
		else
			showDialog();
		
		int nInsertionMode=sInsertionModes.find(sInsertionMode);
		
		if(nInsertionMode==0)
		{ 
			// genbeams
			// prompt the selection of genbeams
			int iCount = 0;
			while (iCount < 20)
			{ 
				// prompt the genBeam selection
				Entity ents[0];
				GenBeam gBeams[0];
				PrEntity ssE(T("|Select genBeam(s)|"), GenBeam());
				if (ssE.go())
					ents.append(ssE.set());
					
				if (ents.length() < 2)
				{ 
					reportMessage(TN("|Select at least two genBeams (beam, sheet or panel)|"));
					eraseInstance();
					return;
				}
				
				// get point (grip point needed to define the position of the connector)
				Point3d pt = getPoint(TN("|Select the Point|"));
				
				// initialize _Pt0 with pt
				_Pt0 = pt;
				iCount++;
				
				// create TSL
				TslInst tslNew;			Vector3d vecXTsl = _XW;	Vector3d vecYTsl = _YW;
				GenBeam gbsTsl[] = { };	Entity entsTsl[] = { };	Point3d ptsTsl[] = { _Pt0, pt};
				int nProps[]={};		double dProps[]={};	
				String sProps[]={sProductCode,sInsertionMode,sDistribution};
				Map mapTsl;
				
				// pass on the properties
//				sProps.append(sProductCode);
				
				for (int i = 0; i < ents.length(); i++)
				{ 
					GenBeam gb = (GenBeam) ents[i];
					if (gb.bIsValid())
					{ 
						gbsTsl.append(gb);
					}
					if (gbsTsl.length() == 2)
					{ 
						// 2 genBeams found, dont append any more
						break;
					}
				}//next i
			
				tslNew.dbCreate(scriptName(), vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			}
			
			eraseInstance();
			return;
		}
		else if(nInsertionMode==1)
		{ 
			// distributed at top plates of walls
			// prompt selection of walls
			PrEntity ssE(T("|Select wall elements|"), ElementWall());
		  	if (ssE.go())
				_Element.append(ssE.elementSet());
				
		// create TSL
			TslInst tslNew;	Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
			GenBeam gbsTsl[]={}; Entity entsTsl[1]; Point3d ptsTsl[]={_Pt0};
			int nProps[]={}; 
			double dProps[]={dOffsetBottom,dOffsetTop,dOffsetBetween};
			String sProps[]={sProductCode,sInsertionMode,sDistribution};
			Map mapTsl;
			
			for (int e=0;e<_Element.length();e++) 
			{ 
				Element elE=_Element[e];
				ElementWall eWe=(ElementWall)elE;
				if(eWe.bIsValid())
				{ 
					entsTsl[0]=eWe;
					tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
						ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
				}
			}//next e
			
			eraseInstance();
			return;
			
		}
	}	
// end on insert	__________________//endregion


//region group assignment

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
int nInsertionMode=sInsertionModes.find(sInsertionMode);
if(nInsertionMode==0)
{ 
	// genbeam mode
	// hide distribution properties
	sDistribution.setReadOnly(_kHidden);
	dOffsetBottom.setReadOnly(_kHidden);
	dOffsetTop.setReadOnly(_kHidden);
	dOffsetBetween.setReadOnly(_kHidden);
	//
	sInsertionMode.setReadOnly(_kHidden);
	//region validate
		
	if (_GenBeam.length() != 2)
	{ 
		// no beam in selection
		reportMessage(TN("|two beams needed|"));
		eraseInstance();
		return;
	}
		
	//End validate//endregion 
	
	
	setKeepReferenceToGenBeamDuringCopy(_kAllBeams);
	
	//region some data
		
		GenBeam gb = _GenBeam[0];
		Vector3d vecX = gb.vecX();
		Vector3d vecY = gb.vecY();
		Vector3d vecZ = gb.vecZ();
		Point3d ptCen = gb.ptCen();
		Point3d ptCenSolid = gb.ptCenSolid();
		double dLength = gb.solidLength();
		double dWidth = gb.solidWidth();
		double dHeight = gb.solidHeight();
		
		vecX.vis(ptCen, 1);
		vecY.vis(ptCen, 3);
		vecZ.vis(ptCen, 150);
		ptCen.vis(10);
		
		GenBeam gb1 = _GenBeam[1];
		Vector3d vecX1 = gb1.vecX();
		Vector3d vecY1 = gb1.vecY();
		Vector3d vecZ1 = gb1.vecZ();
		Point3d ptCen1 = gb1.ptCen();
		Point3d ptCenSolid1 = gb1.ptCenSolid();
		double dLength1 = gb1.solidLength();
		double dWidth1 = gb1.solidWidth();
		double dHeight1 = gb1.solidHeight();
		
		vecX1.vis(ptCen, 1);
		vecY1.vis(ptCen, 3);
		vecZ1.vis(ptCen, 150);
		ptCen1.vis(10);
		
	//End some data//endregion
	
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
		
	//End evaluate//endregion 
	
	//region 6 bounding planes for the first beam
		
		double dDimExtrems[] ={ .5 * dLength, .5 * dLength,
								.5 * dWidth, .5 * dWidth,
								.5 * dHeight, .5 * dHeight};
		Vector3d vecExtrems[] ={ vecX, - vecX, vecY ,- vecY, vecZ ,- vecZ};
		Plane planes[0];
		for (int i = 0; i < 6; i++)
		{ 
			planes.append(Plane(ptCenSolid + dDimExtrems[i] * vecExtrems[i], vecExtrems[i]));
	//		planes[i].vis(5);
		}//next i
		
		Quader qd(ptCenSolid, vecX, vecY, vecZ, dLength, dWidth, dHeight);
		qd.vis(4);
		
		
		double dDimExtrems1[] ={ .5 * dLength1, .5 * dLength1,
								.5 * dWidth1, .5 * dWidth1,
								.5 * dHeight1, .5 * dHeight1};
		Vector3d vecExtrems1[] ={ vecX1, - vecX1, vecY1 ,- vecY1, vecZ1 ,- vecZ1};
		Plane planes1[0];
		for (int i = 0; i < 6; i++)
		{ 
			planes1.append(Plane(ptCenSolid1 + dDimExtrems1[i] * vecExtrems1[i], vecExtrems1[i]));
	//		planes[i].vis(5);
		}//next i
		
		Quader qd1(ptCenSolid1, vecX1, vecY1, vecZ1, dLength1, dWidth1, dHeight1);
		qd1.vis(3);
		
	//End bounding planes of 2 genBeams//endregion 
	
	//region validate quader positions
		// check if quaders parallel
		int iOK = true;
		Vector3d vX1 = qd1.vecD(qd.vecX());
		Vector3d vY1 = qd1.vecD(qd.vecY());
		Vector3d vZ1 = qd1.vecD(qd.vecZ());
	
		//checks if vectors parallel	
		if (abs(abs(vX1.dotProduct(qd.vecX())) - 1) > 0.1*dEps ||
			abs(abs(vY1.dotProduct(qd.vecY())) - 1) > 0.1*dEps ||
			abs(abs(vZ1.dotProduct(qd.vecZ())) - 1) > 0.1*dEps)
		{ 
			// not parallel
			reportMessage(TN("|genbeams not parallel|"));
			eraseInstance();
			return;
		}
		if ( ! vX1.isParallelTo(qd.vecX()) || 
			 ! vY1.isParallelTo(qd.vecY()) ||
			 ! vZ1.isParallelTo(qd.vecZ()) )
		{ 
		  	// not parallel
			reportMessage(TN("|genbeams not parallel|"));
			eraseInstance();
			return;
		}
			
		// genbeams are parallel toward eachother
		
	//End validate quader positions//endregion 
	
	int iIndexSelected = sProductCodes.find(sProduct);
	
	//region get the closest edge with the 2 beams
		
		// 1- find all pairs of planes from genbeam and genbeam1 that are in same plane 
		// 2- filter all valid edges from pairs of planes , 
		//    those with segment that have common range and are close enough
		// 3- for all edges save the 2 planes thay are created from
		
		// possible plane couples
		Plane planesPossible[0];
		Plane planesPossible1[0];
		// index of planes
		int iPossible[0];
		int iPossible1[0];
		
		for (int i = 0; i < planes.length(); i++)
		{ 
			for (int j = 0; j < planes1.length(); j++)
			{ 
				// see if parallel
				//checks if vectors parallel	
				
				if (abs(abs(vecExtrems[i].dotProduct(vecExtrems1[j])) - 1) > dEps)
				{ 
					// not parallel
					continue;
				}
				if (vecExtrems[i].dotProduct(vecExtrems1[j]) < 0)
				{ 
					// opsite sides
					continue;
				}
				if((planes1[j].closestPointTo(planes[i].ptOrg())-planes[i].ptOrg()).length()>dEps)
				{ 
					// planes not at same level
					continue;
				}
				planesPossible.append(planes[i]);
				planesPossible1.append(planes1[j]);
				iPossible.append(i);
				iPossible1.append(j);
			}//next j
		}//next i
		
		if (planesPossible.length() == 0)
		{ 
			reportMessage("\n"+scriptName()+" "+T("|no common plane found|"));
			eraseInstance();
			return;
		}
		
		// 2 planes for edge at first beam
		Plane plane1;
		int index1;
		Plane plane2;
		int index2;
		// 2 planes for edge at second beam
		Plane plane11;
		int index11;
		Plane plane12;
		int index12;
		
		double dCavity=dCavitys[sProductCodes.find(sProductCode)];
		
		// distance from ptg of middle edge
		double dDistMinPtg=U(10e10);
		
		Line lnBetween;
		int iFound=false;
		for (int i=0;i<planes.length();i++) 
		{ 
			Plane pli=planes[i];
			if (iPossible.find(i)<0)
			{ 
				continue;
			}
			// index of i in array iPossible
			int iIndex=iPossible.find(i);
			for (int j=0;j<planes.length();j++) 
			{ 
				Plane plj = planes[j];
				//checks if vectors parallel	
				if (abs(abs(vecExtrems[i].dotProduct(vecExtrems[j])) - 1) < dEps)
				{ 
					// parallel, no edge
					continue;
				}
				int iHasIntersection = pli.hasIntersection(plj);
				if ( ! iHasIntersection)
				{ 
					// no intersection
					continue;
				}
				Line ln = pli.intersect(plj);
				//-------------------
				for (int ii=0;ii<planes1.length();ii++) 
				{ 
					Plane plii = planes1[ii];
					if (iPossible1.find(ii) < 0)
					{ 
						continue;
					}
					int iIndex1 = iPossible1.find(ii);
					if (iIndex != iIndex1)
					{ 
						continue;
					}
					for (int jj=0;jj<planes1.length();jj++) 
					{ 
						Plane pljj = planes1[jj];
						//checks if vectors parallel	
						if (abs(abs(vecExtrems1[ii].dotProduct(vecExtrems1[jj])) - 1) < dEps)
						{ 
							// parallel, no edge
							continue;
						}
						int iHasIntersection = plii.hasIntersection(pljj);
						if ( ! iHasIntersection)
						{ 
							// no intersection
							continue;
						}
						Line ln1 = plii.intersect(pljj);
						
						//checks if vectors parallel	
						if (abs(abs(ln.vecX().dotProduct(ln1.vecX())) - 1) > dEps)
						{ 
							// not parallel
							continue;
						}
						// check if edges have a common range
						Point3d pt1 = gb.ptCen() - .5 * qd.dD(ln.vecX())*ln.vecX();
						Point3d pt2 = gb.ptCen() + .5 * qd.dD(ln.vecX())*ln.vecX();
						
						Point3d pt11 = gb1.ptCen() - .5 * qd1.dD(ln.vecX())*ln.vecX();
						Point3d pt12 = gb1.ptCen() + .5 * qd1.dD(ln.vecX())*ln.vecX();
	//					pt1.vis(4);
	//					pt2.vis(4);
	//					pt11.vis(4);
	//					pt12.vis(4);
						
						if (abs((pt1 - pt12).dotProduct(ln.vecX())) >= 
								(abs((pt1 - pt2).dotProduct(ln.vecX())) + abs((pt11 - pt12).dotProduct(ln.vecX()))))
						{ 
							continue;
						}
						
						// parallel lines, check the distance from each other and the tolerance
						// vector from 1 edge to the other 
						Vector3d vec12 = ln1.ptOrg() - ln.closestPointTo(ln1.ptOrg());
						double dDist = (vec12).length();
						if (abs(dDist-dCavity)<dEps)
						{ 
							Line lnMiddle(ln.ptOrg() + .5 * vec12,ln.vecX());
							double dDistPtg = (lnMiddle.closestPointTo(_PtG[0]) - _PtG[0]).length();
							
							if (dDistPtg < dDistMinPtg)
							{ 
								// distance between 2 edges
								dDistMinPtg = dDistPtg;
								plane1 = pli;index1 = i;
								plane2 = plj;index1 = j;
								
								plane11 = plii;index11 = ii;
								plane12 = pljj;index12 = jj;
								// line between 2 parallel edges
								lnBetween = lnMiddle;
								iFound = true;
							}
						}
					}//next jj
				}//next ii
			}//next j
		}//next i
		_PtG[0].vis(3);
		if ( ! iFound)
		{ 
			
			reportMessage("\n"+scriptName()+" "+T("|distance between genbeams not correct|"));
			reportMessage("\n"+scriptName()+" "+T("|Required cavity|")+" "+dCavity);
			eraseInstance();
			return;
		}
		
	//End get the closest edge with the 2 beams//endregion 
	
	//region line between 2 edges
		
		Line lnEdge = plane1.intersect(plane2);
		Line lnEdge1 = plane11.intersect(plane12);
		
		lnEdge.vis(2);
		lnEdge1.vis(2);
		lnBetween.vis(3);
		Line ln = lnBetween;
		if(_kNameLastChangedProp=="_Pt0")
		{ 
			reportMessage(TN("|pt0 moved|"));
			_Pt0 = ln.closestPointTo(_Pt0);
		}
		else if (_kNameLastChangedProp == "_PtG0")
		{ 
			// grip point was moved
			// project ptg at the edge found
			_PtG[0] = ln.closestPointTo(_PtG[0]);
			_Pt0 = _PtG[0];
		}
		// if the part is displaced, move the pt0 and ptg0
		// to the found edge
		_Pt0 = ln.closestPointTo(_Pt0);
		_PtG[0] = ln.closestPointTo(_PtG[0]);
		
		_Pt0.vis(4);
		
	//End line between 2 edges//endregion 
	
	//region created 3d part
		
		Vector3d vxBody = ln.vecX();
		Vector3d vyBody = vxBody.crossProduct(plane1.normal());
		vyBody.normalize();
		Vector3d vzBody = vxBody.crossProduct(vyBody);
		vzBody.normalize();
		
		double dLPart = U(70);
		double dWPart = dCavity+U(30);
		double dThicknessPart = U(1.2);
		
		Body bd(_Pt0, vxBody,vyBody, vzBody,
						dLPart, dWPart, dThicknessPart,
						0, 0, -1);
		bd.vis(1);
		
		_PtG[0] = _Pt0 + (vxBody * .5 * dLPart);
		
	//End created 3d part//endregion 
	
	
	//region Display
		
		Display dp(252);
		dp.draw(bd);
		
	//End Display//endregion 
	
	//region group assignment
		if(nGroupAssignment==0)
		{ 
			assignToLayer("i");
			assignToGroups(Entity(gb));
		}
		else if (nGroupAssignment==1)
		{ 
			int bSetLayer = _Map.getInt("setLayer");
			if ((_bOnDbCreated || _kNameLastChangedProp==sTriggerGlobalSetting) || bSetLayer)
			{ 
	//			reportNotice("\nflag =" +  bSetLayer);
				assignToLayer("0");
				_Map.removeAt("setLayer", true);
			}
		}
	//End group assignment//endregion
	
	
	//region hardware export
		
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
			Element elHW =gb.element(); 
			// check if the parent entity is an element
			if (!elHW.bIsValid())
				elHW = (Element)gb;
			if (elHW.bIsValid()) 
				sHWGroupName=elHW.elementGroup().name();
		// loose
			else
			{
				Group groups[] = _ThisInst.groups();
				if (groups.length() > 0)
					sHWGroupName = groups[0].name();
			}
		}
	
	// add main componnent
		{ 
			
			String sType = "Acoustic Wall Strap";
			HardWrComp hwc(sType, 1); // the articleNumber and the quantity is mandatory
			
			String sManufacturer = "Cullen";
			hwc.setManufacturer(sManufacturer);
			
	//			hwc.setModel(sProductCode);
	//		hwc.setName(sHWName);
	//		hwc.setDescription(sHWDescription);
			String sMaterial = "galvanised mild steel - Z600";
			hwc.setMaterial(sMaterial);
	//		hwc.setNotes(sHWNotes);
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(gb);	
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
	//			hwc.setDScaleX(U(180));
	//			hwc.setDScaleY(U(85));
	//			hwc.setDScaleZ(U(1.2));
		// uncomment to specify area, volume or weight
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}
	// annular ringshank nails
		{ 
			String sType = "Square Twist Nails";
			HardWrComp hwc(sType, 6); // the articleNumber and the quantity is mandatory
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(gb);
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			// diameter
			hwc.setDScaleX(U(50));
			hwc.setDScaleY(U(3.35));
		// apppend component to the list of components
			hwcs.append(hwc);
		}
	// make sure the hardware is updated
		if (_bOnDbCreated)
			setExecutionLoops(2);
		
		_ThisInst.setHardWrComps(hwcs);
		
	//End hardware export//endregion 

}//if(nInsertionMode==0)
else if(nInsertionMode==1)
{ 
	// distribution at single Wall element
	// get all top plate and get the planeprofile
	// for distribution
	sInsertionMode.setReadOnly(_kHidden);
	ElementWall eWall;
	if(_Element.length()==1)
	{ 
		eWall=(ElementWall)_Element[0];
	}
	
	if(!eWall.bIsValid())
	{ 
		reportMessage("\n"+scriptName()+" "+T("|No valid ElementWall found|"));
		reportMessage("\n"+scriptName()+" "+T("|Distribution not possible|"));
		eraseInstance();
		return;
	}
	
	// basic information
	Point3d ptOrg=eWall.ptOrg();
	Vector3d vecX=eWall.vecX();
	Vector3d vecY=eWall.vecY();
	Vector3d vecZ=eWall.vecZ();
	
	_Pt0 = ptOrg;
	int nProduct=sProductCodes.find(sProductCode);
	double dCavity=dCavitys[nProduct];
	// get the distribution planeprofile of the top plates
	Map mPpDistribution=calcDistributionPp(eWall);
	if(mPpDistribution.getInt("Error"))
	{ 
		String sError=mPpDistribution.getString("sError");
		reportMessage("\n"+scriptName()+" "+sError);
		eraseInstance();
		return;
	}
	_ThisInst.setAllowGripAtPt0(false);
	Point3d ptStartDistribution=mPpDistribution.getPoint3d("ptStart");
	Point3d ptEndDistribution=mPpDistribution.getPoint3d("ptEnd");
	Point3d ptMidDistribution=mPpDistribution.getPoint3d("ptMid");
	PlaneProfile ppDistribution=mPpDistribution.getPlaneProfile("pp");
	Vector3d vecDirDistribution=vecX;
	int nDistribution=sDistributions.find(sDistribution);
	ptStartDistribution.vis(1);
	ptEndDistribution.vis(3);
	Map minDistribution;
	{ 
		double dPartLength=0;
		minDistribution.setDouble("PartLength", dPartLength);
		minDistribution.setPoint3d("pt0Start",ptStartDistribution);
		minDistribution.setPoint3d("pt0End",ptEndDistribution);
		minDistribution.setDouble("OffsetBottom", dOffsetBottom);
		minDistribution.setDouble("OffsetTop", dOffsetTop);
		minDistribution.setDouble("OffsetBetween", dOffsetBetween);
		minDistribution.setVector3d("vecDistribution", vecDirDistribution);
		minDistribution.setInt("evenDistribution", nDistribution);
	}
	Map mDistribution=calcDistribution(minDistribution);
	Display dp(7);
	if (mDistribution.getInt("Error"))
	{
		dp.color(1);
		String sText=mDistribution.getString("sTxt");;
		dp.draw(sText,ptMidDistribution,_XW,_YW,0,0,_kDeviceX);
		return;
	}
	
	Point3d ptsDis[]=mDistribution.getPoint3dArray("ptsDis");
//	for (int p=0;p<ptsDis.length();p++) 
//	{ 
//		ptsDis[p].vis(1+p);
//	}//next p
	
	Map minDrawBody;
	{ 
		minDrawBody.setInt("Color", 252);
		minDrawBody.setPlaneProfile("pp",ppDistribution);
		minDrawBody.setPoint3dArray("pts",ptsDis);
		minDrawBody.setEntity("elWall",eWall);
		minDrawBody.setDouble("dCavity", dCavity);
	}
	Map mDrawBody=drawBody(minDrawBody);
	
	if(nGroupAssignment==0)
	{ 
	// assign to zone 0 of eWall in information layer
		assignToElementGroup(eWall,true,0,'I');
	}
	else if (nGroupAssignment==1)
	{ 
		int bSetLayer = _Map.getInt("setLayer");
		if ((_bOnDbCreated || _kNameLastChangedProp==sTriggerGlobalSetting) || bSetLayer)
		{ 
//			reportNotice("\nflag =" +  bSetLayer);
			assignToLayer("0");
			_Map.removeAt("setLayer", true);
		}
	}
// get hardwares
	HardWrComp hwcs[0];
	Map mapHardwares;
	hwcs=getHardwares(mapHardwares,eWall,_ThisInst,ptsDis.length());
	if (_bOnDbCreated) setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);
	
	return;
}



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
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="781" />
        <int nm="BREAKPOINT" vl="1337" />
        <int nm="BREAKPOINT" vl="1342" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22659: Add support for group assignment; add description" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="9/20/2024 9:42:42 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22659: Support distribution at single elements" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="9/13/2024 1:56:09 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End