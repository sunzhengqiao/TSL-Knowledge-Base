#Version 8
#BeginDescription
#Versions:
Version 3.7 12/08/2025 HSB-24243: Fix edge offset for SihgaPickMax , Author Marsel Nakuci
Version 3.6 24/04/2025 20250424: Fix when getting nr layers , Author Marsel Nakuci
Version 3.5 17.02.2025 HSB-22295: Pass on ptCog as argument at calcLiftingParameters , Author: Marsel Nakuci
3.4 13.12.2024 HSB-22295: Fix when finding the configuration for straighten up at Sihga max Author: Marsel Nakuci
3.3 05.12.2024 HSB-22999: save graphics in file for render in hsbView and make Author: Marsel Nakuci
3.2 06/09/2024 HSB-22295: Add property "Allowed uneveness" to control horizontal uneveness of lifting points Marsel Nakuci
3.1 29/08/2024 HSB-22295: Fix when getting dThicknessWallMin Marsel Nakuci
3.0 15/08/2024 HSB-22295: Add property type, support SihgaPickMax from the xml definition Marsel Nakuci
Version 2.1 04.12.2023 HSB-20771 bugfix range error , Author Thorsten Huck
2.0 10.10.2023 HSB-19789 add mapx data from hsbCLT-SihgaPick to single drill
1.9 10.08.2023 HSB-19789: add mapx data from hsbCLT-SihgaPick to Panel
1.8 08.03.2023 HSB-16519: Publish only dimension aligned according to the edge where the sihga points are 
1.7 10.01.2023 HSB-16519: Publish dimRequest map for dimensions

All results must be double checked by the user. The hsbcad company is not giving any guaranty for a correct result
This tool adds Sihga Pick lift devices to CLT- panel. The result must be double checked in any case. The Picks are automatically positioned. In case of an invalid result, you have to contact Sihga and generate the result manually. The manual input mode is not double checked by this tool.

Alle Ergebnisse müssen vom Anwender überprüft werden. Die hsbcad GmbH übernimmt keine Garantie für die Ergebnisse.
Das Werkzeug fügt einem BSP Panel Sihga Pick Hebemittel hinzu. Das Ergebnis ist in jedem Fall zu prüfen. Die Hebemittel werden automatisch erzeugt und platziert. Ist eine automatische Positionierung nicht möglich, wenden Sie sich an Sihga. Sie können das Ergebnis dann manuell erzeugen. Die manuelle Eingabe wird von diesem Werkzeug nicht mehr überprüft.












#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 7
#KeyWords 
#BeginContents
/// <History>//region
/// #Versions:
// 3.7 12/08/2025 HSB-24243: Fix edge offset for SihgaPickMax , Author Marsel Nakuci
// 3.6 24/04/2025 20250424: Fix when getting nr layers , Author Marsel Nakuci
// 3.5 17.02.2025 HSB-22295: Pass on ptCog as argument at calcLiftingParameters , Author: Marsel Nakuci
// 3.4 13.12.2024 HSB-22295: Fix when finding the configuration for straighten up at Sihga max Author: Marsel Nakuci
// 3.3 05.12.2024 HSB-22999: save graphics in file for render in hsbView and make Author: Marsel Nakuci
// 3.2 06/09/2024 HSB-22295: Add property "Allowed uneveness" to control horizontal uneveness of lifting points Marsel Nakuci
// 3.1 29/08/2024 HSB-22295: Fix when getting dThicknessWallMin Marsel Nakuci
// 3.0 15/08/2024 HSB-22295: Add property type, support SihgaPickMax from the xml definition Marsel Nakuci
// 2.1 04.12.2023 HSB-20771 bugfix range error , Author Thorsten Huck
// 2.0 10.10.2023 HSB-19789 add mapx data from hsbCLT-SihgaPick to single drill Author: Stefan Kärger
// 1.9 10.08.2023 HSB-19789: add mapx data from hsbCLT-SihgaPick to Panel Author: Nils Gregor
// 1.8 08.03.2023 HSB-16519: Publish only dimension aligned according to the edge where the sihga points are Author: Marsel Nakuci
// 1.7 10.01.2023 HSB-16519: Publish dimRequest map for dimensions Author: Marsel Nakuci
/// <version value="1.6" date="01nov2021" author="nils.gregor@hsbcad.com"> HSB-13550 Bugfix selecting valid positions </version>
/// <version value="1.5" date="09aug2021" author="nils.gregor@hsbcad.com"> HSB-12606 Corrected repositioning at outside </version>
/// <version value="1.4" date="19jul2021" author="nils.gregor@hsbcad.com"> HSB-12606 Corrected recalculation behaviour </version>
/// <version value="1.3" date="15jul2021" author="nils.gregor@hsbcad.com"> HSB-8998 Set text height of warning, bugfix: typos </version>
/// <version value="1.2" date="12jul2021" author="nils.gregor@hsbcad.com"> HSB-8998 Added image </version>
/// <version value="1.1" date="10may2021" author="nils.gregor@hsbcad.com"> HSB-8998 Changed description </version>
/// <version value="1.0" date="10may2021" author="nils.gregor@hsbcad.com"> HSB-8998 initial </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry and press OK, select sip.
/// </insert>

/// <summary Lang=en>
/// This tool adds Sihga Pick lift devices to CLT- panel. The result must be double checked in any case. 
/// The Picks are automatically positioned. In case of an invalid result you have to contact Sihga and generate the
/// result manually. The manual input mode is not double checked by this tool.
/// The number of devices can be accessed with format by "NumDevices", the strap / chain length by "ChainLength" (1 - 5).
/// </summary>

/// <summary Lang=de>
/// Das Werkzeug fügt einem BSP Panel Sihga Pick Hebemittel hinzu. Das Ergebnis ist in jedem Fall zu prüfen.
/// Die Hebemittel werden automatisch erzeugt und platziert. Ist eine automatische Positionierung nicht möglich,
/// wenden Sie sich an Sihga. Sie können das Ergebnis dann manuell erzeugen. Die maunelle Eingabe wird von 
/// diesem Werkzeug nicht mehr überprüft.
/// Die Anzahl der Hebemittel kann mit Format unter "NumDevices", die Ketten-/ Schlaufenlängen unter "ChainLength" (1 - 5) abgefragt werden.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-SihgaPick")) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	String sScriptName = "hsbCLT-SihgaPick";
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

//region Functions
// HSB-22295
//region getTypes
	// gets all defined types in the mapSetting of xml
	String[]getTypes(Map _mIn)
	{ 
		String _sTypes[0];
		Map mapTypes=_mIn.getMap("Type[]");
		for (int m=0;m<mapTypes.length();m++) 
		{ 
			Map mM=mapTypes.getMap(m);
			if(mM.getMapKey()=="Type")
			{ 
				String _sTypeI=mM.getMapName();
				if(_sTypes.find(_sTypeI)<0)
				{ 
					_sTypes.append(_sTypeI);
				}
			}
			 
		}//next m
		return _sTypes;
	}
//End getTypes//endregion
	
//region getMapType
// gets from mapSetting of xml 
// the map definition for the requested type _sType
	Map getMapType(Map _mIn,String _sType)
	{ 
		Map _mOut;
		Map mapTypes=_mIn.getMap("Type[]");
		for (int m=0;m<mapTypes.length();m++) 
		{ 
			Map mM=mapTypes.getMap(m);
			if(mM.getMapKey()=="Type")
			{ 
				String _sTypeI=mM.getMapName();
				
				if(_sTypeI.makeUpper()==_sType.makeUpper())
				{ 
					_mOut=mM;
					break;
				}
			}
		}//next m
		return _mOut;
	}
//End getMapType//endregion

//region drawDeviceBody
// it draws the representing body of lifting device
// It needs lifting point and lifting vector
	void drawDeviceBody(String _sType, Point3d _ptLift, Vector3d _vecLift,
		Map _mIn)
	{ 
		Body _bd;
		double _dDeviceDepth=U(68);
		if(_sType=="SihgaPickMax")
		{ 
			_dDeviceDepth=U(138);
		}
		
		{ 
			_bd = Body (_ptLift, _ptLift + _vecLift * _dDeviceDepth, U(25));
			_bd = _bd + Body (_ptLift, _ptLift - _vecLift * U(26), U(47));
			_bd = _bd + Body (_ptLift - _vecLift * U(26), _ptLift - _vecLift * U(45), U(33));
			_bd = _bd + Body (_ptLift - _vecLift * U(45), _ptLift- _vecLift* U(82), U(16));
		}
		
		int _nColor=253;
		
		if(_mIn.hasInt("Color"))
		{ 
			_nColor=_mIn.getInt("Color");
		}
		Display _dp(_nColor);
		_dp.draw(_bd);
		return;
	}
//End drawDeviceBody//endregion

//region calcLiftingParameters
// searches xml to find a proper lifting configuration
	Map calcLiftingParameters(Map _mapType, Map _mIn)
	{ 
		// needs the mapLoad from the xml
		// In _mIn are provided
		// sType -> SihgaPick or SihgaPickMax
		// nAssociation -> Auto,Wall or floor
		// In _mOut are written
		// bStraightenUp, dMaxAngle,nNumDevices
		
		Map _mOut;
		int _nNumDevices;
		if(_mIn.getInt("NumDevices"))
		{ 
			_nNumDevices=_mIn.getInt("NumDevices");
		}
		double _dMaxAngle=-1;
		int _bStraightenUp;
		int _nLiftDirection=_mIn.getInt("LiftDirection");// top,front,back,side
		double _dSipWeight=_mIn.getDouble("SipWeight");
		String _sType="SihgaPick";
		if(_mIn.getString("Type")=="SihgaPickMax")
		{ 
			_sType=_mIn.getString("Type");
		}
		int _dZ=_mIn.getDouble("dZ");
		Entity entSip=_mIn.getEntity("Sip");
		Sip _sip=(Sip)entSip;
		Point3d _ptCOG=_mIn.getPoint3d("ptCOG");
		Point3d _ptCen=_sip.ptCenSolid();
		int _nAssociation=_mIn.getInt("Association");
		int _nStraightenUp=_mIn.getInt("StraightenUp");
		Map _map=_mIn.getMap("_map");
		
		if(_sType=="SihgaPick")
		{ 
			// calc lifting parameters for sihgapick
			Map mapLift, mapLoad = _mapType.getMap("LoadDefinition") ;
			if(_nAssociation == 1)
			{
				Map mapWall = mapLoad.getMap("Wall");
		
				if(_nLiftDirection == 0)
					mapLift = mapWall.getMap("Top");
				else if(_nLiftDirection == 3)
					mapLift = mapWall.getMap("Side");
				else
					mapLift = mapWall.getMap("Front/Back");
			}
			else
			{
				mapLift = mapLoad.getMap("Floor/Roof");
			}
			
			for(int i=0; i < mapLift.length(); i++)
			{
				if(mapLift.keyAt(i).find("Upright",-1) > -1)
				{
					if(_dMaxAngle != -1)
					{
						Map map = mapLift.getMap(i);
						for(int j=0; j < map.length(); j+=2)
						{
							if(map.getDouble(j) > _dSipWeight)
							{
								if(map.getDouble(j+1) < _dZ)
								{
									if(_nStraightenUp == true && _dMaxAngle > map.keyAt(j).atof())
										_dMaxAngle = map.keyAt(j).atof();	
									_bStraightenUp = true;
								}
								break;
							}					
						}
						if(!_bStraightenUp && i < mapLift.length()-1)
							_dMaxAngle = - 1;
					}
					else
						continue;		
				}
				
				if(_dMaxAngle > -1)
					break;
		
				Map map = mapLift.getMap(i);
				
				for(int j=0; j < map.length(); j++)
				{
					if(map.getDouble(j) > _dSipWeight)
					{
						int nNum = map.getMapKey().left(1).atoi();
						if(_nAssociation == 2 && nNum < _map.getInt("SetFloorDevices") || 
						_nAssociation == 1 && _map.hasDouble("CheckWallLength") && _sip.dL() > _map.getDouble("CheckWallLength") && nNum < 4||
						_nAssociation == 2 && (_ptCOG - _ptCen).length() > U(1) && nNum < 3 ||
						nNum <  _map.getInt("NumDevices"))
						{
								continue;
						}
						
						_dMaxAngle = map.keyAt(j).atof();
						_nNumDevices = map.getMapKey().left(1).atoi();
		
						break;
					}
				}
			}
			_mOut.setDouble("dMaxAngle",_dMaxAngle);
			_mOut.setInt("nNumDevices",_nNumDevices);
			_mOut.setInt("bStraightenUp",_bStraightenUp);
		}
		else
		{ 
			// calc lifting parameters for SihgaPickMax
			int _nNrLayers=_mIn.getInt("NrLayers");
			int _bNrLayersFound=_mIn.getInt("bNrLayersFound");
			
			Map mapLift, mapLoad = _mapType.getMap("LoadDefinition") ;
			if(_nAssociation==1)
			{
				Map mapWallLayerThickness = mapLoad.getMap("Wall");
				
				Map mapWallTypes=mapWallLayerThickness.getMap("WallType[]");
				
				if(_bNrLayersFound)
				{ 
					// nr layers found, do calculation with nr layers				
					int _bLiftingConfigurationFound;
					for (int im=0;im<mapWallTypes.length();im++) 
					{ 
						Map mIm=mapWallTypes.getMap(im);
						double _dThicknessMin=mIm.getDouble("ThicknessMin");
						int _nNrLayersMin=mIm.getInt("NrLayersMin");
						
						if(_dZ<_dThicknessMin || _nNrLayers!=_nNrLayersMin)
						{ 
							continue;
						}
						// get corresponding map
						Map mapWall=mIm;
						if(_nLiftDirection == 0)
							mapLift = mapWall.getMap("Top");
						else if(_nLiftDirection == 3)
							mapLift = mapWall.getMap("Side");
						else
							mapLift = mapWall.getMap("Front/Back");
							
						for(int i=0; i < mapLift.length(); i++)
						{
							if(mapLift.keyAt(i).find("Upright",-1) > -1)
							{
								if(_dMaxAngle != -1)
								{
									Map map = mapLift.getMap(i);
									for(int j=0; j < map.length(); j+=2)
									{
										if(map.getDouble(j) > _dSipWeight)
										{
											if(map.getDouble(j+1) < _dZ)
											{
												if(_nStraightenUp == true && _dMaxAngle > map.keyAt(j).atof())
													_dMaxAngle = map.keyAt(j).atof();	
												_bStraightenUp = true;
											}
											break;
										}					
									}
									if(!_bStraightenUp && i < mapLift.length()-1)
										_dMaxAngle = - 1;
								}
								else
									continue;		
							}
							
							if(_dMaxAngle > -1)
							{
								_bLiftingConfigurationFound=true;
								break;
							}
					
							Map map = mapLift.getMap(i);
							
							for(int j=0; j < map.length(); j++)
							{
								if(map.getDouble(j) > _dSipWeight)
								{
									int nNum = map.getMapKey().left(1).atoi();
									if(_nAssociation == 2 && nNum < _map.getInt("SetFloorDevices") || 
									_nAssociation == 1 && _map.hasDouble("CheckWallLength") && _sip.dL() > _map.getDouble("CheckWallLength") && nNum < 4||
									_nAssociation == 2 && (_ptCOG - _ptCen).length() > U(1) && nNum < 3 ||
									nNum <  _map.getInt("NumDevices"))
									{
										continue;
									}
									
									_dMaxAngle = map.keyAt(j).atof();
									_nNumDevices = map.getMapKey().left(1).atoi();
									
									_bLiftingConfigurationFound=true;
									break;
								}
							}
						}
						if(_bLiftingConfigurationFound)
						{ 
							break;
						}
					}//next im
					
				}//_bNrLayersFound
				else if (!_bNrLayersFound)
				{ 
					// it must be satisfied for each nr layer with required thickness
					int _bLiftingConfigurationFound;
					int _bLayerConfigurationAllFound=true; //configuration found for all layers
					// we need to find the worst configuration of layer
					// that satisfies the panel weight
					double _dWeightMinLayers=10e9;
					double _dMaxAngleMinLayers;
					int _nNumDevicesMinLayers;
					int _bStraightenUpMinLayers=-1;
					
					for (int im=0;im<mapWallTypes.length();im++) 
					{ 
						int _dWeightMinI = 10e9;
						Map mIm=mapWallTypes.getMap(im);
						double _dThicknessMin=mIm.getDouble("ThicknessMin");
						int _nNrLayersMin=mIm.getInt("NrLayersMin");
						
						if(_dZ<_dThicknessMin)
						{ 
							// dont check this, thickness not satisfied
							continue;
						}
						// at least one configuration must be found for each layer
						int _bLayerConfigurationFound;
						// get corresponding map
						Map mapWall=mIm;
						if(_nLiftDirection == 0)
							mapLift = mapWall.getMap("Top");
						else if(_nLiftDirection == 3)
							mapLift = mapWall.getMap("Side");
						else
							mapLift = mapWall.getMap("Front/Back");
							
						for(int i=0; i < mapLift.length(); i++)
						{
							if(mapLift.keyAt(i).find("Upright",-1) > -1)
							{
								// HSB-22295
//								if(_dMaxAngle != -1)
								{
									Map map = mapLift.getMap(i);
									int nNum = map.getMapKey().left(1).atoi();
									for(int j=0; j < map.length(); j+=2)
									{
										double _dwj=map.getDouble(j);
										if(map.getDouble(j) > _dSipWeight)
										{
											if(map.getDouble(j+1) < _dZ)
											{
												_bStraightenUp = true;
												// HSB-22295
//												if(_nStraightenUp == true && _dMaxAngle > map.keyAt(j).atof())
												if(_nStraightenUp == true)
												{
													_dMaxAngle = map.keyAt(j).atof();
													_dWeightMinLayers=map.getDouble(j);
													_dMaxAngleMinLayers=_dMaxAngle;
													_nNumDevicesMinLayers=nNum;
													_bStraightenUpMinLayers=_bStraightenUp;
												}
												
												// worst configuration
												if(map.getDouble(j)<_dWeightMinLayers)
												{ 
													// worst configuration
													_dWeightMinLayers=map.getDouble(j);
													_dMaxAngleMinLayers=_dMaxAngle;
													_nNumDevicesMinLayers=nNum;
													_bStraightenUpMinLayers=_bStraightenUp;
												}
												_bLayerConfigurationFound=true;
												break;
											}
//											break;
										}					
									}
									if(!_bStraightenUp && i < mapLift.length()-1)
										_dMaxAngle = - 1;
								}
//								else
//									continue;		
							}
							
							if(_dMaxAngle > -1)
							{
//								_bLiftingConfigurationFound=true;
								_bLayerConfigurationFound=true;
								break;
							}
							
							Map map = mapLift.getMap(i);
							for(int j=0; j < map.length(); j++)
							{
								if(map.getDouble(j) > _dSipWeight)
								{
									int nNum = map.getMapKey().left(1).atoi();
									if(_nAssociation == 2 && nNum < _map.getInt("SetFloorDevices") || 
									_nAssociation == 1 && _map.hasDouble("CheckWallLength") && _sip.dL() > _map.getDouble("CheckWallLength") && nNum < 4||
									_nAssociation == 2 && (_ptCOG - _ptCen).length() > U(1) && nNum < 3 ||
									nNum <  _map.getInt("NumDevices"))
									{
										continue;
									}									
									// 
									// worst configuration
									if(map.getDouble(j)<_dWeightMinLayers)
									{ 
										// worst configuration
										_dWeightMinLayers=map.getDouble(j);
										_dMaxAngleMinLayers=map.keyAt(j).atof();
										_nNumDevicesMinLayers=map.getMapKey().left(1).atoi();
										if(mapLift.keyAt(i).find("Upright",-1) > -1)
										{ 
											_bStraightenUpMinLayers=true;
										}
										else
										{ 
											_bStraightenUpMinLayers=false;
										}
//										_nNumDevicesMinLayers=nNum;
									}
									
									
//									_dMaxAngle = map.keyAt(j).atof();
//									_nNumDevices = map.getMapKey().left(1).atoi();
									
									_bLayerConfigurationFound=true;
//									_bLiftingConfigurationFound=true;
									break;
								}
							}//for(int j=0; j < map.length(); j++)
						}//for(int i=0; i < mapLift.length(); i++)
						if(!_bLayerConfigurationFound)
						{
							_bLayerConfigurationAllFound=false;
							// no configuration found for this layer
							break;
						}
//						if(_bLiftingConfigurationFound)
//						{ 
//							break;
//						}
					}//next im for (int im=0;im<mapWallTypes.length();im++) 
					if(_bLayerConfigurationAllFound)
					{ 
						_dMaxAngle=_dMaxAngleMinLayers;
						_nNumDevices=_nNumDevicesMinLayers;
						_bStraightenUp=_bStraightenUpMinLayers;
					}
					else
					{ 
						_mOut.setInt("Error",true);
						_mOut.setString("sError",T("|Nr of layers for panel not found. Weight not fulfilled for all layers|"));
					}
				}// else if (!_bNrLayersFound)
			}
			else if(_nAssociation!=1)
			{
				mapLift = mapLoad.getMap("Floor/Roof");
				
				for(int i=0; i < mapLift.length(); i++)
				{
					if(mapLift.keyAt(i).find("Upright",-1) > -1)
					{
						if(_dMaxAngle != -1)
						{
							Map map = mapLift.getMap(i);
							for(int j=0; j < map.length(); j+=2)
							{
								if(map.getDouble(j) > _dSipWeight)
								{
									if(map.getDouble(j+1) < _dZ)
									{
										// second row in xml
										if(_nStraightenUp == true && _dMaxAngle > map.keyAt(j).atof())
											_dMaxAngle = map.keyAt(j).atof();	
										_bStraightenUp = true;
									}
									break;
								}					
							}
							if(!_bStraightenUp && i < mapLift.length()-1)
								_dMaxAngle = - 1;
						}
						else
							continue;		
					}
					
					if(_dMaxAngle > -1)
						break;
			
					Map map = mapLift.getMap(i);
					for(int j=0; j < map.length(); j++)
					{
						if(map.getDouble(j) > _dSipWeight)
						{
							int nNum = map.getMapKey().left(1).atoi();
							if(_nAssociation == 2 && nNum < _map.getInt("SetFloorDevices") || 
							_nAssociation == 1 && _map.hasDouble("CheckWallLength") && _sip.dL() > _map.getDouble("CheckWallLength") && nNum < 4||
							_nAssociation == 2 && (_ptCOG - _ptCen).length() > U(1) && nNum < 3 ||
							nNum <  _map.getInt("NumDevices"))
							{
								continue;
							}
							
							_dMaxAngle = map.keyAt(j).atof();
							_nNumDevices = map.getMapKey().left(1).atoi();
			
							break;
						}
					}
				}
			}
			//
			_mOut.setDouble("dMaxAngle",_dMaxAngle);
			_mOut.setInt("nNumDevices",_nNumDevices);
			_mOut.setInt("bStraightenUp",_bStraightenUp);
		}
		return _mOut;
	}
//End calcLiftingParameters//endregion

//region getNrLayers
	int getNrLayers(Sip _sip)
	{ 
		int _nrLayers;
		
		SipStyle sipStyle=SipStyle(_sip.style());
		
		_nrLayers=sipStyle.numSipComponents();
		return _nrLayers;
		
//		String sSipStyle=_sip.style();
//		
//		String sTokens0[]=sSipStyle.tokenize("-");
//		String sTokens1[]=sSipStyle.tokenize("_");
//		String sTokens[0];
//		if(sTokens0.length()>sTokens1.length())
//		{ 
//			sTokens.append(sTokens0);
//		}
//		else
//		{ 
//			sTokens.append(sTokens1);
//		}
//		
//		int nrLayerOptions[]={1,3,5,7,9};
//		int _bNrLayersFound;
//		for (int i=0;i<sTokens.length();i++) 
//		{ 
//			// for each token
//			for (int j=0;j<nrLayerOptions.length();j++) 
//			{ 
//				String sj=nrLayerOptions[j]+"s";
//				String sj1=nrLayerOptions[j]+"n";
//				if(sTokens[i].find(sj,-1,false)>-1)
//				{ 
//					_nrLayers=nrLayerOptions[j];
//					_bNrLayersFound=true;
//					break;
//				}
//				else if(sTokens[i].find(sj1,-1,false)>-1)
//				{ 
//					_nrLayers=nrLayerOptions[j];
//					_bNrLayersFound=true;
//					break;
//				}
//			}//next j
//			if(_bNrLayersFound)
//			{ 
//				break;
//			}
//		}//next i
//		
//		return _nrLayers;
	}
//End getNrLayers//endregion

//region visPp
// it visualises a planeprofile moved with _vec
	void visPp(PlaneProfile _pp, Vector3d _vec)
	{ 
		//
		_pp.transformBy(_vec);
		_pp.vis(6);
		_pp.transformBy(-_vec);
		return;
	}
//End visPp//endregion

//region calcPpOutline
// calculates the ppOutline of a planeprofile
// it tries to cleanup small points but not reliable
	PlaneProfile calcPpOutline(PlaneProfile _pp, 
		Point3d _pt,Vector3d _vec)
	{ 
		// _pt-> ptcen
		// _vec-> vecZ
		Plane _pn(_pt,_vec);
		PlaneProfile _ppOutline(_pn);
		
		PLine _plOutlines[] = _pp.allRings(true, false);	
		for(int i =0; i<_plOutlines.length(); i++)
		{
			Point3d pts[]=_plOutlines[i].vertexPoints(true);
			
			for(int j=pts.length()-1; j>-1; j--)
			{
				if(j==pts.length()-1)
				{
					Vector3d v(pts[j] - pts[0]); 
					if(v.length() < U(0.5))
						pts.removeAt(j);
				}
				else if(j ==0)
				{
					Vector3d v(pts[0]-pts.last()); 
					if(v.length() < U(0.5))
						pts.removeAt(j);			
				}
				else
				{
					Vector3d v(pts[j] - pts[j + 1]);
					if(v.length() < U(0.5))
						pts.removeAt(j);					
				}
			}
			
			for(int j = pts.length()-1; j > -1; j--)
			{
				if(j == pts.length()-1)
				{
					Vector3d v(pts[j] - pts[0]); 
					v.normalize(); 
					if((_plOutlines[i].closestPointTo(pts[j] + v*U(1)) - (pts[j] + v*U(1))).length() < U(0.3))
						pts.removeAt(j);		
				}
				else if(j ==0)
				{
					Vector3d v(pts[0] - pts.last()); 
					v.normalize();
					if((_plOutlines[i].closestPointTo(pts[j] + v*U(1)) - (pts[j] + v*U(1))).length() < U(0.3))
						pts.removeAt(j);			
				}
				else
				{
					Vector3d v(pts[j] - pts[j + 1]);
					v.normalize();
					if((_plOutlines[i].closestPointTo(pts[j] + v*U(1)) - (pts[j] + v*U(1))).length() < U(0.3))
						pts.removeAt(j);				
				}									
			}	
	
			PLine pl;
			for(int i=0; i < pts.length(); i++)
			{
				pl.addVertex(pts[i]);
			}
			pl.close();
			PlaneProfile pp(pl);
			if(pp.area() > dEps)
			{
				_ppOutline.joinRing(pl, false);	
			}
			else
			{
				_ppOutline.joinRing(_plOutlines[i], false);
			}
		}
		return _ppOutline;
	}
//End calcPpOutline//endregion


//region cleanUpPline
	// this function will clean plines
	// it will remove points inside a line
	// it will leave only the corner points of a pline
	Map cleanUpPline(PLine plIn)
	{ 
		Map _m;
//		Point3d pts[]=plIn.vertexPoints(false);
		Point3d pts[]=plIn.vertexPoints(true);
		CoordSys csPl=plIn.coordSys();
		PLine plOut=plIn;
		
		if(pts.length()<3)
		{ 
			_m.setPLine("pl",plOut);
			return _m;
		}
		
		Point3d ptsAddition[0];  
		Point3d ptsFinal[0];  
		int nIndicesAdd[0];
		int nAdditionalPoints;
		if(pts.length()>2)
		{ 
			nAdditionalPoints=pts.length()-2;
		}
		for (int p=0;p<pts.length()-2+nAdditionalPoints;p++) 
		{ 
			int nIndp=p;
			if(p>pts.length()-1)
			{
				nIndp=p-(pts.length());
			}
			if(nIndicesAdd.find(nIndp)>-1)
			{ 
				// point already removed
				continue;
			}
			// point 0
			Point3d ptP=pts[nIndp];
			// vec01
			Vector3d vecDirP;
			Line lnp;
			for (int j=p+1;j<pts.length()+nAdditionalPoints;j++) 
			{ 
				int nIndj=j;
				int nIndjPrev=j-1;
				if(nIndj>pts.length()-1)
				{
					nIndj=j-(pts.length());
				}
				if(nIndjPrev>pts.length()-1)
				{
					nIndjPrev=(j-1)-(pts.length());
				}

				if(nIndicesAdd.find(nIndjPrev)>-1)
				{ 
					continue;
				}
				Point3d ptJ=pts[nIndj];
				lnp=Line(.5*(ptP+ptJ),vecDirP);
				if(j==p+1)
				{ 
					// point 1
					vecDirP=ptJ-ptP;// last with first
					vecDirP.normalize();// vector 01
				}
				else
				{ 
					Vector3d vecDirJ=ptJ-ptP;// last with 0
					vecDirJ.normalize();
					Vector3d vecDirJ1=ptJ-pts[nIndjPrev];// last with previous
					vecDirJ1.normalize();
					if(abs(abs(vecDirP.dotProduct(vecDirJ))-1.0)<.1*dEps
					&& abs(abs(vecDirP.dotProduct(vecDirJ1))-1.0)<.1*dEps)
					{
						// parallel 0-1 is parallel to 0-last and 01 is parallel to previous-last (check to remove previous)
						// HSB-22319
						// do the distance from line check
						// the vector direction not very accurate
						Point3d ptAtLine=lnp.closestPointTo(pts[nIndjPrev]);
						if((ptAtLine-pts[nIndjPrev]).length()<U(1))
						{ 
//							ptAtLine.vis(6);
//							lnp.vis(2);
							// parallel
							ptsAddition.append(pts[nIndjPrev]);
							nIndicesAdd.append(nIndjPrev);
						}
					}
					else
					{ 
						
						// new direction
						break;
					}
				}
			}//next j
		}//next p
		
		for (int p=0;p<pts.length();p++) 
		{ 
			if(nIndicesAdd.find(p)<0)
			{
				ptsFinal.append(pts[p]); 
			}
		}//next p
		ptsFinal.append(ptsFinal[0]);
		
		for (int p=0;p<ptsFinal.length();p++) 
		{ 
			Point3d ptFinal=ptsFinal[p];
//			ptFinal.vis(6); 
		}//next p
		
		if(ptsAddition.length()>0)
		{ 
			// addition points found
			plOut=PLine(csPl.vecZ());
			for (int p=0;p<ptsFinal.length();p++) 
			{ 
				plOut.addVertex(ptsFinal[p]);
			}//next p
			_m.setPoint3dArray("ptsAddition",ptsAddition);
		}
		else
		{ 
			plOut=plIn;
		}
		
		_m.setPLine("pl",plOut);
		return _m;
//		return plOut;
	}
//End cleanUpPline//endregion
//End Functions//endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="hsbCLT-SihgaPick";
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
//End Settings//endregion	

//region Properties
	int nMode = (_Map.hasInt("nMode")) ? _Map.getInt("nMode") : 0;
	
	String sCenterOfGravityTsl = "hsbCenterOfGravity";
	
	String sAssociationNames[] = {T("|Automatic|"), T("|Wall|"), T("|Floor/Roof|")};	
	String sAssociationName=T("|Association|");	
	PropString sAssociation(nStringIndex++, sAssociationNames, sAssociationName);	
	sAssociation.setDescription(T("|Defines the association|"));
	sAssociation.setCategory(category);	
	int nAssociation = sAssociationNames.find(sAssociation, 0);
	
	String sLiftDirectionNames[] = {T("|Top|") , T("|Front|"), T("|Back|"), T("|Side|")};
	String sLiftDirectionName=T("|Position of Sihga Pick|");	
	PropString sLiftDirection(nStringIndex++, sLiftDirectionNames, sLiftDirectionName);	
	sLiftDirection.setDescription(T("|Defines the position of the Sihga Pick devices for walls|"));
	sLiftDirection.setCategory(category);
	int nLiftDirection = sLiftDirectionNames.find(sLiftDirection, 0);
	
	String sStraightenUpName=T("|Check Straighten up panel|");	
	PropString sStraightenUp(nStringIndex++, sNoYes, sStraightenUpName);	
	sStraightenUp.setDescription(T("|Check if the panel can be straighten up. Only allowed for walls|"));
	sStraightenUp.setCategory(category);
	int nStraightenUp = sNoYes.find(sStraightenUp);
	
	category = T("|Chain length and lifting type|");
	String sStrap2dLengthName=T("|Chain hanger length|");	
	PropDouble dStrap2dLength(nDoubleIndex++, U(3000), sStrap2dLengthName);	
	dStrap2dLength.setDescription(T("|Defines the chain length of a hanger for floor/roof and for walls with 2 devices|"));
	dStrap2dLength.setCategory(category);	

	String sLiftingTypeNames[] = { T("|Traverse|"), T("|Chain with straps|")};
	String sLiftingTypeName=T("|Lifting type four devices|");	
	PropString sLiftingType(nStringIndex++, sLiftingTypeNames, sLiftingTypeName);	
	sLiftingType.setDescription(T("|Defines the lifting type for walls, if four devices are needed|"));
	sLiftingType.setCategory(category);
	int nLiftingType = sLiftingTypeNames.find(sLiftingType, 0);	
	
	String sTraverseLengthName=T("|Traverse length|");	
	PropDouble dTraverseLength(nDoubleIndex++, U(2000), sTraverseLengthName);	
	dTraverseLength.setDescription(T("|Defines the length of the Traverse|"));
	dTraverseLength.setCategory(category);
	
	String sStrapTraverseLengthName=T("|Strap length for Traverse|");	
	PropDouble dStrapTraverseLength(nDoubleIndex++, U(1000), sStrapTraverseLengthName);	
	dStrapTraverseLength.setDescription(T("|Defines the chain or strap length connecting the devices with the traverse|"));
	dStrapTraverseLength.setCategory(category);
	
	String sChainLengthName=T("|Chain length|");	
	PropDouble dChainLength(nDoubleIndex++, U(4000), sChainLengthName);	
	dChainLength.setDescription(T("|Defines the chain length for a chain and strap lifting combination|"));
	dChainLength.setCategory(category);
	
	String sStrapChainLengthName=T("|Strap length for chain combination|");	
	PropDouble dStrapChainLength(nDoubleIndex++, U(2000), sStrapChainLengthName);	
	dStrapChainLength.setDescription(T("|Defines the length of the strap connected with the devices and attached to the chain|"));
	dStrapChainLength.setCategory(category);		
	
	category = T("|Settings|");
	String sShowStrapsName=T("|Show chain assembly|");	
	PropString sShowStraps(nStringIndex++, sNoYes, sShowStrapsName);	
	sShowStraps.setDescription(T("|Defines the ShowStraps|"));
	sShowStraps.setCategory(category);
	int nShowStraps = sNoYes.find(sShowStraps);
	// HSB-22295
	category=T("|General|");
	// get types
	String sTypes[]=getTypes(mapSetting);
	String sTypeName=T("|Type|");	
	PropString sType(nStringIndex++, sTypes, sTypeName);	
	sType.setDescription(T("|Defines the Type|"));
	sType.setCategory(category);
	
	// HSB-22295: allowed uneveness, 2 lifting points can be allowed to be on uneven levels
	String sAllowedUnevenessName=T("|Allowed uneveness|");
	PropDouble dAllowedUneveness(nDoubleIndex++, U(10), sAllowedUnevenessName);
	dAllowedUneveness.setDescription(T("|Defines the horizontal uneveness between 2 lifting points. If the user changes this property he bares responsibility about the correctness and safety of results.|")+
		+" "+T("|Negative or 0 entries will disable the check and allow for unbounded Uneveness.|"));
	dAllowedUneveness.setCategory(category);
//End Properties//endregion


	// Set direction if restarted with 2nd lift direction
	if(_Map.hasInt("nAss"))
	{
		sAssociation.set(sAssociationNames[_Map.getInt("nAss")]);
		sLiftDirection.set(sLiftDirectionNames[_Map.getInt("nDir")]);
		_Map.removeAt("nAss", true);
		_Map.removeAt("nDir", true);
	}
	
//region bOnInsert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
		setOPMKey("Insert");
		
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		// HSB-22295
		int nKey=sTypes.findNoCase(sKey);
		if(nKey>-1)
		{ 
			// type defined in the key
			sType.set(sTypes[nKey]);
//			sType.setReadOnly(_kReadOnly);
		}
		
		category = T("|Rules|");
		String sSecoundLiftingName=T("|Add devices for 2nd lifting direction|");	
		PropString sSecoundLifting(nStringIndex++, sNoYes, sSecoundLiftingName);	
		sSecoundLifting.setDescription(T("|Adds devices in a secound direction.|"));
		sSecoundLifting.setCategory(category);
		
		String sWallFrontHorName=T("|Align devices in wall front direction horizontal|");	
		PropString sWallFrontHor(nStringIndex++, sNoYes, sWallFrontHorName);	
		sWallFrontHor.setDescription(T("|The devices are aligned horizontal, if placed at the front or back side|"));
		sWallFrontHor.setCategory(category);		
		
		String sFloorRoofNumName=T("|Lift floor/roof panel with more than 2 devices|");	
		PropString sFloorRoofNum(nStringIndex++, sNoYes, sFloorRoofNumName);	
		sFloorRoofNum.setDescription(T("|Floor/ roof planes are lifted with more than 2 devices|"));
		sFloorRoofNum.setCategory(category);
		
		String sWallLengthToNumName=T("|Use 4 Picks for walls longer than|");	
		PropDouble dWallLengthToNum(nDoubleIndex++, U(0), sWallLengthToNumName);	
		dWallLengthToNum.setDescription(T("|Use 4 devices, when walls longer than value.|"));
		dWallLengthToNum.setCategory(category);
		
	// silent/dialog
		if (sKey.length()>0 && nKey<0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}
		else
		{
//			showDialogOnce();		
			showDialogOnce("---");
		}
		
	// get selection set
		PrEntity ssE(T("|Select panels|"), Sip());
		Entity ents[0];
		if (ssE.go())
			ents = ssE.set();
		
		// create TSL
		TslInst tslNew;					Map mapTsl; 
		int bForceModelSpace = true;	
		String sExecuteKey;	
		String sCatalogName = sLastInserted;
		String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
		GenBeam gbsTsl[1];		Entity entsTsl[0];			Point3d ptsTsl[1];
		int nProps[]={};
		double dProps[]={dStrap2dLength, dTraverseLength, dStrapTraverseLength, 
			dChainLength, dStrapChainLength,dAllowedUneveness};
		String sProps[]={sAssociation, sLiftDirection, sStraightenUp, sLiftingType, sShowStraps,sType};
		
		if((sLiftDirectionNames.find(sLiftDirection) == 1 || sLiftDirectionNames.find(sLiftDirection) == 2) && sNoYes.find(sWallFrontHor) == 1)
			mapTsl.setInt("AlignmentFrontBack", true);
		if(sNoYes.find(sFloorRoofNum) == 1)
			mapTsl.setInt("SetFloorDevices", 3);
		if(dWallLengthToNum > dEps)
		mapTsl.setDouble("CheckWallLength", dWallLengthToNum);
		if(sNoYes.find(sSecoundLifting) == 1)
			mapTsl.setInt("Add 2nd LiftDirectionOnce", true);
		
		for(int i=0; i < ents.length(); i++)
		{
			Sip sip = (Sip)ents[i];
			gbsTsl[0] = sip;
			ptsTsl[0] = gbsTsl[0].ptCen();
			
			//tslNew.dbCreate(sScriptName , _XE ,_YE,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 	
			tslNew.dbCreate(sScriptName , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
		}
		
		eraseInstance();	
		return;	
	}
// end on insert	__________________//endregion


// declare panel standards
	if (_Sip.length()<1)
	{
		reportMessage("\n" + scriptName() + ": " +T("|Invalid reference.|") + " " + T("|Tool will be deleted|"));
		eraseInstance();
		return;
	}
	
	Sip sip = _Sip[0];
	CoordSys cs = sip.coordSys();
	Vector3d vecX = sip.vecX();
	Vector3d vecY = sip.vecY();
	Vector3d vecZ = sip.vecZ();
	Point3d ptCen = sip.ptCenSolid();
	double dZ = sip.dH();
	Body bdSip = sip.realBody();
	vecX.vis(ptCen, 1);vecY.vis(ptCen, 3);vecZ.vis(ptCen, 150);
	
	// set dependency and assignment
	int nEntity = _Entity.find(sip);
	if (nEntity<0)
	{
		_Entity.append(sip);
		nEntity=0;	
	}
	if (nEntity>-1) setDependencyOnEntity(_Entity[nEntity]);
	// HSB-22295: check property type
	int nType=sTypes.find(sType);
	if(nType<0)
	{
		sType.set(sTypes[0]);
		nType=0;
	}
	String sHyperlinks[]={"https://www.sihga.com/pick/",
						  "https://www.sihga.com/pick-max/"};
	String sHyperlink=sHyperlinks[nType];
//	_ThisInst.setHyperlink("https://www.sihga.com/ecommerce/product?category_id=153948&product_id=546961");
	_ThisInst.setHyperlink(sHyperlink);
	// HSB-22295
	Map mapType=getMapType(mapSetting,sType);
	double dThicknessFloorMins[]={U(70),U(140)};
	double dThicknessFloorVisibleMins[]={U(90),U(160)};
	double dThicknessWallMins[]={U(90),U(100)};
	
	double dThicknessFloorMin=dThicknessFloorMins[nType];
	double dThicknessFloorVisibleMin=dThicknessFloorVisibleMins[nType];
	// Fix the thickness
	double dThicknessWallMin=dThicknessWallMins[nType];
	
	
	Element element = sip.element();
	int bIsElement = element.bIsValid();
	
	if(bIsElement)
		assignToElementGroup(element, true, 0, 'I');
	else
		assignToGroups(sip, 'I');
	
	Vector3d vZW;
	_ThisInst.setAllowGripAtPt0(false);
	int bError;


//region Get center of gravity
	Point3d ptCOG = ptCen;
	double dSipWeight;
	{ 
		Map mapIO;
		Map map;
		map.setEntity("Entity", sip);
		mapIO.setMap("Entity[]", map);
		TslInst().callMapIO(sCenterOfGravityTsl, mapIO);
		ptCOG = mapIO.getPoint3d("ptCen");
		dSipWeight = mapIO.getDouble("Weight");	

		if(dSipWeight < dEps)
		{
			map.setDouble("Weight", 500);
			map.setPoint3d("ptCen", ptCen);
			mapIO.setMap("Entity[]", map);
			TslInst().callMapIO(sCenterOfGravityTsl, mapIO);
			ptCOG = mapIO.getPoint3d("ptCen");
			dSipWeight = mapIO.getDouble("Weight");	
		}
	}		
//End Get center of gravity//endregion 
	
	ptCOG.vis(6);
	double dAllowedUnevenessCalc=dAllowedUneveness>dEps?dAllowedUneveness:U(10e5);
	
// Set sequence to position text in free area
	int nSequence = _Map.getInt("Sequence");
	TslInst tsls[] = sip.tslInstAttached();
	for(int i=0; i < tsls.length();i++)
	{
		TslInst tsl = tsls[i];
		String s=tsl.scriptName();
		
		if(tsl != _ThisInst && tsl.scriptName() == _ThisInst.scriptName())
		{
			String sAssociationTsl = tsl.propString(sAssociationName);
			if(sAssociation == sAssociationTsl)
			{
				String sLiftDirectionTsl = tsl.propString(sLiftDirectionName);
				if(sLiftDirection == sLiftDirectionTsl)
				{
					reportMessage("\n"+scriptName()+" "+T("|Instance with same association already attached|"));
					eraseInstance();
					return;						
				}	
			}
			
			int n = tsl.map().getInt("Sequence");
			if(!_Map.hasInt("Sequence") && n > nSequence)
				nSequence = n;
		}
	}
	
	if(! _Map.hasInt("Sequence"))
	{
		_Map.setInt("Sequence", nSequence + 1);	
		_Pt0 -= _YU * (nSequence + 1) * U(100);
	}
	
	// Define Vector in lifting direction
	if(_Map.hasVector3d("VecZW"))
		vZW = _Map.getVector3d("VecZW");
		
	// no association set
	if (sAssociationNames.find(sAssociation, -1) == 0)
	{
		int bGrainInfo = - 1;
		Map mapSip = sip.subMap("ExtendedProperties");
		Element element = sip.element();
		Vector3d vecZ = sip.vecZ();
		Point3d ptCen = sip.ptCen();
		double dZ = sip.dH();
				
		if( mapSip.hasInt("IsFloor"))
		 	bGrainInfo = mapSip.getInt("IsFloor")? 2 : 1;
						
		// test wall nAssociation
		if(element.bIsValid())
		{
			if(element.bIsKindOf(ElementWall()))
			{
				nAssociation = 1;	
				_Map.setVector3d("VecZW", element.vecY());
			}
			else
				nAssociation = 2;	
		}
		// get info from grain direction
		else if(bGrainInfo > -1)
			nAssociation = bGrainInfo;
		else if (vecZ.isPerpendicularTo(_ZW))
			nAssociation = 1;
		// any panel with a bevel is considered to be roof panel
		else if (!vecZ.isPerpendicularTo(_ZW) && !vecZ.isParallelTo(_ZW))
			nAssociation = 2;
		// any panel with a perp to ZW and any elevation above world 0 is considered to be floor panel
		else if (vecZ.isParallelTo(_ZW) && _ZW.dotProduct(ptCen -_PtW)>.5*dZ)
			nAssociation = 2;
		// default assoc will be wall
		else	
			nAssociation = 1;	
		sAssociation.set(sAssociationNames[nAssociation]);
	}	
	
	if(vZW.length() < dEps)
	{
		if(nAssociation == 2)
		{
			vZW = vecZ;					
			if(vZW.dotProduct(_ZW) < 0 && ! vecZ.isPerpendicularTo(_ZW))
				vZW *= -1;
		}
		else if(nAssociation == 1 && vZW.length() < dEps)
		{
			if(vecY.isPerpendicularTo(_ZW) && vecX.isParallelTo(_ZW) || vecX.isPerpendicularTo(_ZW) && vecY.isParallelTo(_ZW))
				vZW = _ZW;
			else
			{
//				// Openings wider than high are assumed to be windows and be 
//				PlaneProfile ppSip = bdSip.getSlice(Plane(ptCen, vecZ));
//				LineSeg seg = ppSip.extentInDir(vecX);
//				PLine pl;
//				pl.createRectangle(seg, vecX, vecY);
//				PlaneProfile ppHull(pl);
//				ppHull.shrink(U(-1));
//				ppHull.intersectWith(ppSip);
//				PLine pls[] = ppHull.allRings(false, true);
//				for(int i=0; i < pls.length(); i++)
//				{
//					PlaneProfile pp(pls[i]);
//					if(ppSip.pointInProfile(pp.ptMid()) == _kPointOutsideProfile)
//					{
//						Point3d ptM = pp.ptMid();
//						Point3d ptsLR[2];
//						Vector3d vecs[] = { vecX, vecY};
//						int nRun;
//						while((ptsLR[0] != Point3d(0,0,0) || ptsLR[1] != Point3d(0,0,0)) && nRun < 3)
//						{
//							LineSeg segs[] = ppSip.splitSegments(LineSeg(ptM - vecX * U(10000), ptM + vecX * U(10000)), true);
//							for(int j=0; j < segs.length(); j++)
//							{
//								if(vecX.dotProduct(segs[j].ptMid() - ptM) < 0 && ptsLR[0] != Point3d(0,0,0))
//									ptsLR[0] = segs[j].ptMid();
//								else if(vecX.dotProduct(segs[j].ptMid() - ptM) > 0 && ptsLR[1] != Point3d(0,0,0))
//									ptsLR[1] = segs[j].ptMid();
//							}	
//							nRun++;
//						}
//						Point3d pt = (ptsLR[0] == Point3d(0, 0, 0)) ? ptsLR[1] : ptsLR[0];
//						Vector3d vecF(pt - ptM);
//						vecF.normalize();
//						Vector3d vecPerp = vecF.crossProduct(vecZ);
//						LineSeg segOp = pp.extentInDir(vecF);
//						
//						if(vecF.dotProduct(segOp.ptEnd() - segOp.ptStart()) < abs(vecPerp.dotProduct(segOp.ptEnd() - segOp.ptStart())))
//							vecF *= -1;
//						vZW = vecF;
//					}
////					if (pp.area() < pow(U(600), 2)) continue;
//				}
				if(vZW.length() > dEps)
				{}
			 	else if(U(2550) < sip.dW()  && sip.dW() < U(3000))
					vZW = vecY;
				else if(U(2550) < sip.dL() && sip.dL() < U(3000))
					vZW = vecX;
				else if(sip.dL() > sip.dW())
					vZW = vecY;
				else
					vZW = vecX;				
			}		
		}
	}

	// Display text 
	Display dpError(6);
	dpError.textHeight(U(100));
	dpError.showInDxa(true);// HSB-22999
	Vector3d vecDimWall = vZW.crossProduct(vecZ);
	Vector3d vecXText, vecYText;
	
	if(bIsElement)
	{
		vecXText = element.vecX();
		vecYText = element.vecY();
	}
	else
	{
		double dAngleToW = vecDimWall.angleTo(_XW);
		if(dAngleToW < 45+dEps || dAngleToW+ dEps > 135)
		{
			if(dAngleToW > 90)
				vecDimWall *= -1;
		}
		else
		{
			if(vecDimWall.dotProduct(_YW) < 0)
				vecDimWall *= -1;
		}	
		vecXText = (nAssociation == 2) ? _XW : vecDimWall;
		vecYText = (nAssociation == 2) ? _YW : _ZW;		
	}

	
// Genral settings and definitions for the sihga Pick
	Point3d ptsLiftDevices[0];
	Vector3d vecLiftDevices[0];	
	PlaneProfile ppValidPosition;
	PLine plsLifting[0];

	int nNumDevices;// to be found
	double dEdgeOffset = U(250);
	// HSB-24243
	if(sType=="SihgaPickMax")dEdgeOffset=U(500);
	double dLiftDirOffset = U(150);
	double dSinkHolePick = U(100);
	double dDrillDiamPick = U(50.5); 
	double dDrillDepths[]={U(72),U(142)};
//	double dDrillDepth = U(70);
	double dDrillDepth =dDrillDepths[nType];
	double dMaxAngle = -1;// max inclination angle of rope with device
	double bStraightenUp;// to be found when finding position
	
	// nLiftDirection ->Top, front, back, side
	// 
	
	// dz,
	SipStyle sipStyle=SipStyle(sip.style());
	int nrLayers=getNrLayers(sip);
	int bNrLayersFound=(nrLayers>1);
//	int nrLayers=sipStyle.numSipComponents();
	
	//Check if panel is symetric. If not 3 devices are required		
	if(nAssociation == 2 && (ptCOG - ptCen).length() > U(10))
	{ 
		reportMessage("\n"+scriptName()+" "+T("|Panel is asymmetric. 3 devices are required|"));
		nNumDevices = 3;
	}	
	
	if(nType==1)
	{ 
		if(nAssociation==1)
		{
			// walls
			if(nLiftDirection!=0)
			{ 
//				reportMessage("\n"+scriptName()+" "+T("|Position|")+" "+sLiftDirection+" "+T("|for|")+" "+sType+" "+T("|is not supported|"));
//				reportMessage("\n"+scriptName()+" "+T("|Changing to|")+" --> "+sLiftDirectionNames[0]);
				
				String s1;
				if(nLiftDirection==1)
				{ 
					s1=T("|Position Front for type SihgaPickMax is not supported|");
				}
				else if(nLiftDirection==2)
				{ 
					s1=T("|Position Back for type SihgaPickMax is not supported|");
				}
				else if(nLiftDirection==3)
				{ 
					s1=T("|Position Side for type SihgaPickMax is not supported|");
				}
				String s2=T("|Property Position is changed to Top|");
				
				reportMessage("\n"+scriptName()+" "+s1);
				reportMessage("\n"+scriptName()+" "+s2);
				
				sLiftDirection.set(sLiftDirectionNames[0]);
				nLiftDirection=0;
			}
		}
	}
	
	// calc lifting parameters from the xml file
	// Get number of devices form xml file
	Map mOutLiftingParameters;
	{ 
		Map mInLiftingParameters;
		mInLiftingParameters.setString("Type",sType);
		mInLiftingParameters.setDouble("dZ",dZ);
		mInLiftingParameters.setEntity("Sip",sip);
		mInLiftingParameters.setInt("Association",nAssociation);
		mInLiftingParameters.setInt("StraightenUp",nStraightenUp);
		mInLiftingParameters.setInt("NumDevices",nNumDevices);
		mInLiftingParameters.setInt("LiftDirection",nLiftDirection);
		mInLiftingParameters.setDouble("SipWeight",dSipWeight);
		mInLiftingParameters.setInt("NrLayers",nrLayers);
		mInLiftingParameters.setInt("bNrLayersFound",bNrLayersFound);// 20250424
//		mInLiftingParameters.setInt("bNrLayersFound",false);
		
		mInLiftingParameters.setMap("_map",_Map);
		mInLiftingParameters.setPoint3d("ptCOG",ptCOG);
		
//		Map mapLoad = mapType.getMap("LoadDefinition") ;
		Map _mOutLiftingParameters=calcLiftingParameters(mapType,mInLiftingParameters);
		mOutLiftingParameters=_mOutLiftingParameters;
		nNumDevices=_mOutLiftingParameters.getInt("nNumDevices");
		dMaxAngle=_mOutLiftingParameters.getDouble("dMaxAngle");
		bStraightenUp=_mOutLiftingParameters.getInt("bStraightenUp");
	}
	
	if(_Map.hasInt("NumDevices") && dMaxAngle == -1)
	{
		nNumDevices = _Map.getInt("NumDevices");
		dMaxAngle = 45;
	}
	
	// Set devices and vectors from manual imput
	{ 
		Map mapLiftDevices = _Map.getMap("LiftDevices");
		if(mapLiftDevices.length()/2 == nNumDevices)
			for(int i=0; i < mapLiftDevices.length()/2; i++)
			{
				ptsLiftDevices.append(mapLiftDevices.getPoint3d(i*2));	
				vecLiftDevices.append(mapLiftDevices.getVector3d(i * 2 + 1));
			}
	}
	
	int bManualInput = _Map.getInt("ManualInput");	
	int bHasPoints = ptsLiftDevices.length() > 0 && !bManualInput;
	int bSihgaText = _Map.getInt("CheckedWithSihga");
	
	if(_kNameLastChangedProp == sAssociationName || _kNameLastChangedProp == sLiftDirectionName || _kNameLastChangedProp == sLiftingTypeName)
	{
		_PtG.setLength(0);
		_Map.removeAt("VecZW", true);
		_Map.removeAt("ManualInput", true);
		_Map.removeAt("LiftDevices", true);	
		_Map.removeAt("SingleMode", true);
		_Map.removeAt("CheckedWithSihga", true);
		//_Map.removeAt("NumDevices", true);
		_Map.removeAt("TxtShorterStraps", true);
		setExecutionLoops(2);
		return;
	}
	
	if(dMaxAngle == -1)
	{
		if(!bError &&  !bSihgaText)
			dpError.draw(T("|Panel is too heavy|"), _Pt0, vecXText, vecYText,0,0,_kDeviceX);
		bError = true;
	}
	if(nStraightenUp == 1 && bStraightenUp == false)
	{
		if(!bError && !bSihgaText)
			dpError.draw(T("|Panel is too heavy to straight it up|"), _Pt0, vecXText, vecYText,0,0,_kDeviceX );
		bError = true;
	}
	
	double dStrapLength;
	if(nAssociation==2 || nAssociation==1 && nNumDevices<4)
		dStrapLength=dStrap2dLength;
	else if(nLiftingType==0)
		dStrapLength=dStrapTraverseLength;
	else
		dStrapLength=dStrapChainLength;
	
	double dStrapHorizontal=(nNumDevices>1)?dStrapLength*sin(dMaxAngle):0;
	double dLiftExtreme;
	double dMaxInterdistance;
	Point3d ptForStrapLength;
	Vector3d vecForStrapLength;
	
	if(nNumDevices>1)
		dMaxInterdistance=dStrapHorizontal;
	dLiftExtreme=dMaxInterdistance;
	
	if(!bManualInput)
	{
		if(nNumDevices>1 && (dStrapHorizontal<dEdgeOffset || nNumDevices==4 && nLiftingType==1 && 2*dStrapHorizontal+U(200)<dEdgeOffset))
		{
			if(!bError && !bSihgaText)
				dpError.draw(T("|Lifting chain/strap is too short|"), _Pt0, vecXText, vecYText,0,0,_kDeviceX);
			bError=true;
		}
		if(nNumDevices==4)
		{
			if(nLiftingType==1 && dChainLength<U(1999))
			{
				if(!bError && !bSihgaText)
					dpError.draw(T("|Top chain for lifting is too short|"),_Pt0, vecXText, vecYText,0,0,_kDeviceX);
				bError=true;
			}
		}	
	}

	// Define interdistance of devices
	if(nNumDevices==4 && nAssociation==1)
	{		
		// Using traverse
		if(nLiftingType==0)
		{
			if(dMaxInterdistance>0.5*dTraverseLength-dEdgeOffset)
				dMaxInterdistance=0.5*dTraverseLength-dEdgeOffset;
				
			if(dMaxInterdistance < dEdgeOffset)
			{ 
				if(!bError && !bSihgaText)
					dpError.draw(T("|Interdistance of Picks below minimum|"),_Pt0, vecXText, vecYText,0,0,_kDeviceX);
				bError = true;			
			}
				
			dLiftExtreme = 0.5 * dTraverseLength + dMaxInterdistance;
		}
		// Using chain / strap combination
		else
		{
			// Interdistance for plumb lifting
			double dBPt = 0.5 * dStrapLength * sin(dMaxAngle);
			
			if(dBPt  - dEdgeOffset < U(100))
			{ 
				if(!bError && !bSihgaText)
					dpError.draw(T("|Strap/Chain is too short|"),_Pt0, vecXText, vecYText,0,0,_kDeviceX);
				bError = true;
			}
			
			double dPerCent =0.7;
			
			while(dPerCent < 1)
			{
				dMaxInterdistance = dBPt - dPerCent * (dBPt - dEdgeOffset);
				
				// Assumed value to start most outside
				double dStrap1Length = (pow(dStrapLength, 2) - pow(2*dMaxInterdistance, 2)) / (2 * dStrapLength - 4 * dMaxInterdistance * cos(90 - dMaxAngle));
				double dStrap2Length = dStrapLength - dStrap1Length; 
				double dEllipseHeight = pow(pow(0.5 * dStrapLength, 2) - pow(dMaxInterdistance, 2) , 0.5);
				double dMaxHorizontal = cos(90 - dMaxAngle) * dStrap1Length;			
				double dAngleChain = atan((sin(90 - dMaxAngle) * dStrap1Length / (cos(90 - dMaxAngle)*dStrap1Length - dMaxInterdistance)) * pow(0.5*dStrapLength,2) / pow(dEllipseHeight,2));
				dLiftExtreme = dChainLength * cos(dAngleChain) + dMaxHorizontal;	
				
				if(dLiftExtreme - 2 * dMaxInterdistance - dEdgeOffset > 0)
					break;
				dPerCent += 0.05;
			}
		}
	}
	
	// Panel need min thickness of 90mm for upright lifting
	// HSB-22295
//	if(nAssociation == 2 && dZ < U(70) || nAssociation == 1 && dZ < U(90))
	if(nAssociation == 2 && dZ < dThicknessFloorMin || nAssociation == 1 && dZ < dThicknessWallMin)
	{
		if(!bError && !bSihgaText)
			dpError.draw(T("|Panel thickness too small for top lifting|"), _Pt0, vecXText, vecYText,0,0,_kDeviceX );
		bError = true;	
	}
	
	//Indipendent positioning of devices.
	int bSingleMode = _Map.getInt("SingleMode");
	if(bSingleMode && !bHasPoints)
	{	
		Point3d ptToCheck;
		int bCheck,  nPtG;
		
		if( _kNameLastChangedProp.find("_PtG", -1) > -1)
		{
			nPtG = _kNameLastChangedProp.right(1).atoi();
			ptToCheck =_PtG[nPtG];
			bCheck = true;
		}			
		else if(_PtG.length() < 1 && ptsLiftDevices.length() == nNumDevices)
		{
			for(int i=0; i < ptsLiftDevices.length(); i++)
				_PtG.append(ptsLiftDevices[i]);	
			ptToCheck = _PtG[0];
			bCheck = true;
		}
		else if(_PtG.length() == nNumDevices && ptsLiftDevices.length() < 1)
		{
			ptToCheck = _PtG[0];
			bCheck = true;
		}
		else if(_PtG.length() != nNumDevices && ptsLiftDevices.length() != nNumDevices)		
		{
			_PtG.setLength(0);
			ptsLiftDevices.setLength(0);
			// Create odd result. The custumer has to change it to vailid result			
			PlaneProfile ppSingle = bdSip.getSlice(Plane(ptCen,vecZ));
			
			if(nAssociation == 1)
			{
				Vector3d vecPerp = vZW.crossProduct(vecZ);
				Point3d ptsEdge[] = ppSingle.intersectPoints(Plane(ptCOG, vecPerp), true, false);
				ptsEdge = Line(ptCOG, -vZW).orderPoints(ptsEdge);
				Point3d pt = ptsEdge[0];	
				double dPoints = nNumDevices * U(500);
				pt -= vecPerp * (dPoints / 2);
							
				while(_PtG.length() < nNumDevices)
				{
					_PtG.append(ppSingle.closestPointTo(pt));
					pt += vecPerp * U(500);
					dPoints -= U(500);
				}			
			}
			else
			{
				_PtG.append(ptCOG + vecX.rotateBy(45, vecZ) * U(250));
				if(nNumDevices != 3)
				{
					_PtG.append(ptCOG + vecX.rotateBy(225, vecZ) * U(250));
					
					if(nNumDevices == 4)
					{
						_PtG.append(ptCOG + vecX.rotateBy(135, vecZ) * U(250));
						_PtG.append(ptCOG + vecX.rotateBy(315, vecZ) * U(250));
					}
				}
				else
				{
					_PtG.append(ptCOG + vecX.rotateBy(165, vecZ) * U(250));
					_PtG.append(ptCOG + vecX.rotateBy(285, vecZ) * U(250));					
				}			
			}
			ptToCheck = _PtG[0];
			bCheck = true;			
		}
		
		if(bCheck)
		{
			//Floor/roof and front/back
			if(nAssociation == 2 || nAssociation == 1 && (nLiftDirection== 1 || nLiftDirection == 2))
			{
				int nSign = (nLiftDirection == 2 && nAssociation== 1)? - 1 : 1;
				Vector3d vecUp = (nAssociation == 2)?  vZW : vecZ;
				Plane pn(ptCen + vecUp * nSign * 0.5 * dZ ,- vecUp);
				PlaneProfile ppSingle = bdSip.extractContactFaceInPlane(pn, dEps);
				
				if(ppSingle.pointInProfile(ptToCheck) == _kPointOutsideProfile)
					ptToCheck = ppSingle.closestPointTo(ptToCheck);
					
				_PtG[nPtG] = pn.closestPointTo(ptToCheck);	
				vecLiftDevices.setLength(0);
				
				for(int i=0; i < _PtG.length(); i++)
					vecLiftDevices.append(-nSign * vecUp);
			}
			// wall top and side
			else
			{
				Plane pn(ptCen,vecZ);
				PlaneProfile ppSingle = bdSip.getSlice(pn);		
				_PtG[nPtG] = ppSingle.closestPointTo(ptToCheck);
				
				vecLiftDevices.setLength(0);
						
				for(int i=0; i < _PtG.length(); i++)
				{
					Vector3d vec(_PtG[i] - ptCOG);
					vec.normalize();
							
					Point3d pt = _PtG[i] + vec * U(0.5); 
					Vector3d vecT(pt - ppSingle.closestPointTo(pt));
					vecT.normalize();
					vecLiftDevices.append(-vecT);	
				}								
			}
		}	
		
		Map map;
		for(int i=0; i < _PtG.length(); i++)
		{
			map.appendPoint3d("ptLift", _PtG[i]);	
			map.appendVector3d("vecLift", vecLiftDevices[i]);				
		}
				
		_Map.setMap("LiftDevices", map);							
		ptsLiftDevices = _PtG;				

	}	
	
	// Position devices for floor/ roof panels
	if(nAssociation == 2 && !bHasPoints && !bSingleMode)
	{
	// Get valid area for devices
		int bSurfaceVisible;
		double dRequiredDepth=(dZ<dThicknessFloorVisibleMin && !bSurfaceVisible)?dThicknessFloorMin:dThicknessFloorVisibleMin;
		Vector3d vecUp = vZW;
		
		Point3d ptTopCen = ptCOG + vecUp*vecUp.dotProduct(ptCen - ptCOG) + vecUp * (0.5 * dZ); 

		PLine pl;
		pl.createCircle(ptTopCen, vecUp, dMaxInterdistance);
		PlaneProfile ppMaxDeviceArea(pl); 
		PlaneProfile ppManual;
		Point3d ptsVertex[0];
		
		//Create PlaneProfile with free lifting area
		{ 
			PlaneProfile ppTop = bdSip.extractContactFaceInPlane(Plane(ptTopCen + vecUp*U(1), vecUp), dRequiredDepth);
			double d = ppTop.area(); 
			PlaneProfile ppFreeLiftArea(Plane(ptTopCen, vecUp));
			
//			vecUp.vis(ptTopCen,3);
//			ppTop.vis(6);
			
			PLine plOutLines[] = ppTop.allRings(true, false);		
			for(int i=0;i < plOutLines.length();i++)
			{
				ppFreeLiftArea.joinRing(plOutLines[i], false);				
			}
				
			ppManual = ppFreeLiftArea;
			ppFreeLiftArea.shrink(dEdgeOffset);	
			
			PLine plOps[] = ppTop.allRings(false, true);
			for(int i=0; i < plOps.length(); i++)
			{
				PlaneProfile pp(plOps[i]);
				
				// Don´t use tools from previous run
				int bContinue;
				Map mapLiftPts = _Map.getMap("LiftPts");
				for(int j=0; j < mapLiftPts.length(); j++)
				{
					if(pp.pointInProfile(mapLiftPts.getPoint3d(j)) == _kPointInProfile)
					{
						LineSeg seg = pp.extentInDir(vecX);
						if(vecX.dotProduct(seg.ptEnd() - seg.ptStart()) - U(50.5) < dEps)
						{
							bContinue = true;
							break;							
						}
					}
				}
				if (bContinue) continue;

				pp.shrink(-dEdgeOffset);
				ppFreeLiftArea.subtractProfile(pp);
			}
			
			ppMaxDeviceArea.intersectWith(ppFreeLiftArea); 
			
			ptsVertex = ppMaxDeviceArea.getGripVertexPoints();
			
			// Inner circle for min distance between devices
			PLine plInner;
			plInner.createCircle(ptTopCen, vecUp, dEdgeOffset);
			ppMaxDeviceArea.joinRing(plInner, true);
		}
			
		double dRotateAngle = 5;
		
		// If number of lifting devices is even, check first the vertex points. 
		if(nNumDevices != 3 && !bManualInput && !bError)
		{
			int nMaxTests;
			double dMaxArea;
				
			for(int i=0; i < ptsVertex.length(); i++)
			{
				Vector3d vec(ptsVertex[i] - ptTopCen);	vec.normalize();
				Vector3d vecPerp = vec.crossProduct(vecUp);
				Point3d pts[] = ppMaxDeviceArea.intersectPoints(Plane(ptTopCen, vecPerp),true, true);
					
				if (pts.length() < 2) continue;
				pts = Line(ptTopCen, vec).orderPoints(pts);
				if (abs((pts.first() - ptTopCen).length() - (pts.last() - ptTopCen).length()) > dEps) continue;					
				Point3d ptsD[] = { pts.first(), pts.last()};

				//Get area of device point/ center. Biggset areais assumed to give best position
				double dTestArea = abs(vecX.dotProduct(ptsD[0] - ptTopCen) * vecY.dotProduct(ptsD[0] - ptTopCen));
						
				if(dMaxArea < dTestArea)
				{
					if(nNumDevices == 2 )
					{
						ptsLiftDevices = ptsD;
						dMaxArea = dTestArea;							
					}
					else
					{
						// Check if opposite side has a sytemtric result
						Point3d ptsTemp[0]; ptsTemp = ptsD;
							
						for(int j = 0; j < 2; j++)
						{
							Point3d ptsT[] = ppMaxDeviceArea.intersectPoints(Plane(ptsD[j], vecX), true, true);
							if (ptsT.length() < 2) continue;	
							ptsT = Line(ptsD[j], vecY).orderPoints(ptsT);
							if (abs((ptsT.first() - ptTopCen).length() - (ptsT.last() - ptTopCen).length()) < dEps) 
								ptsTemp.append(ptsT.last() == ptsD[j] ? ptsT.first() : ptsT.last());							
						}

						if(ptsTemp.length() == 4 )
						{
							ptsLiftDevices = ptsTemp;
							dMaxArea = dTestArea;
						}					
					}
				}					
			}			
		}			
		
		// If number of lifting devices is uneaven or vertexpoint check has no result, check by rotating planes the best position
//		if(ptsLiftDevices.length() != nNumDevices)
		{
			double dRotated, dMaxDist;				
			Vector3d vecs[0], vecPerps[0]; 			
				
			if(nNumDevices == 3)
			{
				Vector3d v[] = { vecX, vecX.rotateBy(120, vecUp), vecX.rotateBy(240, vecUp)};
				vecs = v;
				Vector3d vp[] = { vecY, vecY.rotateBy(120, vecUp), vecY.rotateBy(240, vecUp)};	
				vecPerps = vp;
			}
			else
			{
				Vector3d v[] =  { vecX};
				vecs = v;
				Vector3d vp[] = { vecY};
				vecPerps = vp;
			}
				
			int nMaxDegrees[] = { 0, 180, 120, 90};
			
			if(!bManualInput && !bError && nNumDevices>0)
			{
				while(dRotated < nMaxDegrees[nNumDevices-1])
				{
					Point3d ptsTemp[0];
					// Get all possible lifting points	
					for(int i=0; i < vecs.length(); i++)
					{
						Point3d ptsT[] = ppMaxDeviceArea.intersectPoints(Plane(ptTopCen, vecPerps[i]), true, true);
						if (ptsT.length() < 1) continue;
						ptsT = Line(ptTopCen, vecs[i]).orderPoints(ptsT);
						ptsTemp.append(ptsT.last());
							
						if(nNumDevices !=3)
						{
							ptsTemp.append(ptsT.first());	
								
							if(nNumDevices == 4)
							{
								Point3d ptsT4[] = ppMaxDeviceArea.intersectPoints(Plane(ptTopCen, vecPerps[i].rotateBy(360 - 2*dRotated, vecUp)), true, true);
								if (ptsT4.length() < 1) continue;
								ptsT4 = Line(ptTopCen,  vecs[i].rotateBy(360 - 2*dRotated, vecUp)).orderPoints(ptsT4);
								ptsTemp.append(ptsT4.last());			
								ptsTemp.append(ptsT4.first());		
							}
						}
					}
						
					// Get point closest to COG	 and check if other points with same distance are inside the free lifting area
					if(ptsTemp.length() == nNumDevices)
					{
						double dSmallest;
						for(int m = 1; m < ptsTemp.length(); m++)
						{
							if(nNumDevices == 3)
							{
								if(m==1)
									dSmallest = (ptsTemp[0] - ptTopCen).length();
								if((ptsTemp[m] - ptTopCen).length() < (ptsTemp[0] - ptTopCen).length())
								{
									ptsTemp.swap(0, m);	
									dSmallest = (ptsTemp[0] - ptTopCen).length();
								}
							}
							else
							{								
								double dArea1 = abs(vecX.dotProduct(ptsTemp[0] - ptTopCen) * vecY.dotProduct(ptsTemp[0] - ptTopCen));
								double dArea2 = abs(vecX.dotProduct(ptsTemp[m] - ptTopCen) * vecY.dotProduct(ptsTemp[m] - ptTopCen));
									
								if(m==1)
									dSmallest = dArea1;
								if(dArea2 < dArea1)
								{								
									ptsTemp.swap(0, m);		
									dSmallest = dArea2;
								}
							}
						}
							
						if(dSmallest > dMaxDist)
						{
							Point3d ptsAdd[0];
							double dDist = (ptsTemp[0] - ptTopCen).length();							
							Vector3d vecUse[0];
							vecUse = vecs;
								
							if(nNumDevices != 3)
							{
								vecUse.append(-vecs[0]);
									
								if(nNumDevices == 4)
								{
									Vector3d v = vecs[0].rotateBy(360 - 2 * dRotated, vecUp);
									vecUse.append(v);
									vecUse.append(-v);
								}
							}
								
							for(int i=0; i < vecUse.length(); i++)
							{
								Point3d pt = ptTopCen + vecUse[i] * dDist; 
								if(ppMaxDeviceArea.pointInProfile(pt) == _kPointOutsideProfile)
									break;
								ptsAdd.append(pt); 
							}
								
							if(ptsAdd.length() == nNumDevices )
							{
								ptsLiftDevices = ptsAdd;							
								dMaxDist = dSmallest;
							}
						}
					}
					
					// Rotate vectors for next try
					for(int i=0; i < vecs.length(); i++)
					{
						vecs[i] = vecs[i].rotateBy(dRotateAngle, vecUp);
						vecPerps[i] = vecPerps[i].rotateBy(dRotateAngle, vecUp);
					}
									
					dRotated += dRotateAngle;
				}				
			}
			//Manual positioning of devices. If automatic creation failed, an invalid default positioning is created.
			else if(bManualInput)
			{
				if( _kNameLastChangedProp.find("_PtG", -1) > -1)
				{
					int nPtG = _kNameLastChangedProp.right(1).atoi();
					int nNumPtGs = _PtG.length();
					
					if(ppManual.pointInProfile(_PtG[nPtG]) == _kPointOutsideProfile)
						_PtG[nPtG] = ppManual.closestPointTo(_PtG[nPtG]);
					
					//_PtG[nPtG] += vecUp * vecUp.dotProduct(_PtG[nPtG] - ptTopCen);
					_PtG[nPtG] = Plane(ptTopCen, vecUp).closestPointTo(_PtG[nPtG]);
					Vector3d vecPtG(_PtG[nPtG] - ptTopCen);
					Vector3d vecs[0];
					
					if(nNumPtGs == 2)
						vecs.append(vecPtG.rotateBy(180, vecUp));
					if(nNumPtGs == 3)
					{
						vecs.append(vecPtG.rotateBy(120, vecUp));
						vecs.append(vecPtG.rotateBy(240, vecUp));
					}
					if(nNumPtGs == 4)
					{
						Point3d pts4[] = ppManual.intersectPoints(Plane(_PtG[nPtG], vecX), true, false);
						pts4 = Line(_PtG[nPtG], vecY).orderPoints(pts4);
						
						int nSign = (abs(vecY.dotProduct(_PtG[nPtG] - pts4[0])) > abs(vecY.dotProduct(_PtG[nPtG] - pts4.last()))) ? - 1 : 1;
						double dAngle = vecPtG.angleTo(vecX);
						vecs.append(vecPtG.rotateBy(180, vecUp));						
						vecs.append(vecPtG.rotateBy(nSign * 2*dAngle, vecUp));	
						vecs.append(vecs.last().rotateBy(180, vecUp));	
					}
					
					ptsLiftDevices.setLength(0);
					
					int n;
					for(int i=0; i < _PtG.length(); i++)
					{													
						if(i == nPtG)
						{
							ptsLiftDevices.append(_PtG[i]);
							continue;
						}
						_PtG[i] = ptTopCen + vecs[n];
						ptsLiftDevices.append(_PtG[i]);
						n++;
					}	
					
					Map map;
					for(int i=0; i < ptsLiftDevices.length(); i++)
					{
						map.appendPoint3d("ptLift", ptsLiftDevices[i]);	
						map.appendVector3d("vecLift", -vecUp);				
					}
			
					_Map.setMap("LiftDevices", map);					
				}	
				else
				{
					// Get all possible lifting points	
					if(ptsLiftDevices.length() > 0 && ptsLiftDevices.length() == nNumDevices)
						_PtG = ptsLiftDevices;
						
					else
					{
						if(_PtG.length() != nNumDevices)
							_PtG.setLength(0);
						Point3d ptsT[0];
						for(int i=0; i < vecs.length(); i++)
						{
							if(nNumDevices != 3)
							{
								if(ptsVertex.length() > 0 )
								{
									vecs[i] = Vector3d(ptsVertex[0] - ptTopCen);
									vecs[i].normalize();								
								}
								else
								if(vecs[i].isParallelTo(vecX) || vecs[i].isParallelTo(vecY))
									vecs[i] = vecs[i].rotateBy(45, vecUp);

							}
							dRotated = vecs[i].angleTo(vecX);
							Point3d ptsTT[] = ppMaxDeviceArea.intersectPoints(Plane(ptTopCen, vecPerps[i]), true, true);
							if (ptsTT.length() < 1) continue;
							ptsTT = Line(ptTopCen, vecs[i]).orderPoints(ptsTT);
							ptsT.append(ptsTT.last());
										
							if(nNumDevices !=3)
							{
								ptsT.append(ptsTT.first());	
										
								if(nNumDevices == 4)
								{
									Point3d pts4[] = ppManual.intersectPoints(Plane(ptsT.last(), vecX), true, false);
									pts4 = Line(ptsT.last(), vecY).orderPoints(pts4);
									int nSign = (abs(vecY.dotProduct(ptsT.last() - pts4[0])) > abs(vecY.dotProduct(ptsT.last() - pts4.last()))) ? - 1 : 1;
									double dAngle = vecs[i].angleTo(vecX);														
									Point3d ptsT4[] = ppMaxDeviceArea.intersectPoints(Plane(ptTopCen, vecPerps[i].rotateBy(nSign * 2*dAngle, vecUp)), true, true);
									
//									Point3d ptsT4[] = ppMaxDeviceArea.intersectPoints(Plane(ptTopCen, vecPerps[i].rotateBy(360 - 2*dRotated, vecUp)), true, true);
									if (ptsT4.length() < 1) continue;
									ptsT4 = Line(ptTopCen,  vecs[i].rotateBy(360 - 2*dRotated, vecUp)).orderPoints(ptsT4);
									ptsT.append(ptsT4.last());			
									ptsT.append(ptsT4.first());		
								}
							}							
						}
						
						int n;
						double dMinDist = U(20000);
						Vector3d vecPts[0];
						for(int i=0; i < ptsT.length(); i++)
						{
							if((ptsT[i] - ptTopCen).length() < dMinDist)
							{
								n = i;
								dMinDist = (ptsT[i] - ptTopCen).length();
							}
							Vector3d vec = (ptsT[i] - ptTopCen);
							vec.normalize();
							vecPts.append(vec);
						}
						
						for(int i=0; i < ptsT.length(); i++)
						{
							_PtG.append(ptTopCen + vecPts[i] * dMinDist);
							ptsLiftDevices.append(_PtG.last());
						}
						
						Map map;
						for(int i=0; i < ptsLiftDevices.length(); i++)
						{
							map.appendPoint3d("ptLift", ptsLiftDevices[i]);	
							map.appendVector3d("vecLift", -vecUp);				
						}
				
						_Map.setMap("LiftDevices", map);						
					}				
				}						
				ppValidPosition = ppMaxDeviceArea;
			}
			if(ptsLiftDevices.length() >0)
			{
				Point3d ptTopLifting = ptTopCen + vecUp * pow((pow(dChainLength, 2) - pow((ptsLiftDevices[0] - ptTopCen).length(), 2)), 0.5);
					
				for(int i=0; i < ptsLiftDevices.length(); i++)
				{
					plsLifting.append(PLine(ptsLiftDevices[i], ptTopLifting));
				}					
			}
		}
		
		vecLiftDevices.setLength(0);
		for(int i=0; i < ptsLiftDevices.length(); i++)
			vecLiftDevices.append(-vecUp);
			
		if(ptsLiftDevices.length() < 1)
		{
			if(!bError && !bSihgaText)
				dpError.draw(T("|Cannot find valid position|"),_Pt0, vecXText, vecYText,0,0,_kDeviceX);
			bError = true;
		}
			
		if(_bOnDebug)
		{
//			for(int i=0; i < ptsLiftDevices.length(); i++)
//			{
//				ptsLiftDevices[i].vis(2);
//			}
		}
	}

	// Position devices for walls
	else if(nAssociation == 1 && !bHasPoints && !bSingleMode)
	{	
	// Get valid area for devices
	
		double dZDevice = U(90);
		Point3d ptSide = ptCen;

		if(nLiftDirection == 1)
			ptSide = ptCen + vecZ * 0.5 * (dZ - dZDevice);		
		else if(nLiftDirection == 2)
			ptSide = ptCen - vecZ * 0.5 * (dZ - dZDevice);

		int bIsFrontBack = (nLiftDirection == 1 || nLiftDirection == 2) ? true : false;
		Vector3d vecHor =  -vZW.crossProduct(vecZ);	
		Plane pnMid(ptCen, vecZ); 
		PlaneProfile ppDevice(pnMid);
		ppDevice.unionWith(bdSip.getSlice(Plane(ptSide+vecZ*0.5*(dZDevice-dEps), vecZ)));	
		ppDevice.intersectWith(bdSip.getSlice(Plane(ptSide-vecZ*0.5*(dZDevice-dEps), -vecZ)));
		
		PlaneProfile ppManual;
		PLine plsManual[0];
		visPp(ppDevice,vecZ*U(500));
		//Remove surplus vertex points. Only vertex points at corners remain
		
		// what is the aim of this planeprofile??
//		PlaneProfile ppOutline=calcPpOutline(ppDevice,ptCen,vecZ);
		PlaneProfile ppOutline(Plane(ptCen,vecZ));
		//
		{ 
			PlaneProfile ppOutlineCen(Plane(ptCen, vecZ));
			ppOutlineCen.unionWith(ppDevice);
//			ppOutlineCen.vis(6);
			PLine plsOutlineCen[]=ppOutlineCen.allRings(true,false);
			if(plsOutlineCen.length()>0)
			{ 
				Map mCleanUpPline=cleanUpPline(plsOutlineCen[0]);
				Point3d ptsAddition[]=mCleanUpPline.getPoint3dArray("ptsAddition");
//				PLine pl=plsOutlineCen[0];
//				if(ptsAddition.length()>0)
//				{ 
//					pl=mCleanUp.getPLine("pl");
//				}
				PLine pl=mCleanUpPline.getPLine("pl");
				ppOutline=PlaneProfile(pl);
//				ppOutline.vis(3);
			}
		}
		
//		PlaneProfile ppOutline(pnMid);
//		{
//			PLine plOutlines[] = ppDevice.allRings(true, false);	
//			for(int i =0; i < plOutlines.length(); i++)
//			{
//				Point3d pts[] = plOutlines[i].vertexPoints(true);
//				
//				for(int j=pts.length()-1; j > -1; j--)
//				{
//					if(j==pts.length()-1)
//					{
//						Vector3d v(pts[j] - pts[0]); 
//						if(v.length() < U(0.5))
//							pts.removeAt(j);
//					}
//					else if(j ==0)
//					{
//						Vector3d v(pts[0] - pts.last()); 
//						if(v.length() < U(0.5))
//							pts.removeAt(j);			
//					}
//					else
//					{
//						Vector3d v(pts[j] - pts[j + 1]);
//						if(v.length() < U(0.5))
//							pts.removeAt(j);					
//					}
//				}
//				
//				for(int j = pts.length()-1; j > -1; j--)
//				{
//					if(j == pts.length()-1)
//					{
//						Vector3d v(pts[j] - pts[0]); 
//						v.normalize(); 
//						if((plOutlines[i].closestPointTo(pts[j] + v*U(1)) - (pts[j] + v*U(1))).length() < U(0.3))
//							pts.removeAt(j);		
//					}
//					else if(j ==0)
//					{
//						Vector3d v(pts[0] - pts.last()); 
//						v.normalize();
//						if((plOutlines[i].closestPointTo(pts[j] + v*U(1)) - (pts[j] + v*U(1))).length() < U(0.3))
//							pts.removeAt(j);			
//					}
//					else
//					{
//						Vector3d v(pts[j] - pts[j + 1]);
//						v.normalize();
//						if((plOutlines[i].closestPointTo(pts[j] + v*U(1)) - (pts[j] + v*U(1))).length() < U(0.3))
//							pts.removeAt(j);				
//					}									
//				}	
//
//				PLine pl;
//				for(int i=0; i < pts.length(); i++)
//				{
//					pl.addVertex(pts[i]);
//				}
//				pl.close();
//				PlaneProfile pp(pl);
//				if(pp.area() > dEps)
//					ppOutline.joinRing(pl, false);	
//				else
//					ppOutline.joinRing(plOutlines[i], false);
//			}
//		}


//		visPp(ppDevice,vecZ*U(350));
//		visPp(ppOutline,vecZ*U(550));

		Point3d ptsAllVertices[] = ppOutline.getGripVertexPoints();
//		for (int p=0;p<ptsAllVertices.length();p++) 
//		{ 
//			ptsAllVertices[p].vis(p+1);
//		}//next p
		
		//Define valid area for front/ back
		if(bIsFrontBack)
		{
			ppOutline.shrink(dLiftDirOffset);	
			PLine plsOp[] = ppDevice.allRings(false, true);
			for(int i=0; i < plsOp.length(); i++)
			{
				PlaneProfile pp(plsOp[i]);
				
				// Don´t use tools from previous run
				int bContinue;
				Map mapLiftPts = _Map.getMap("LiftPts");
				for(int j=0; j < mapLiftPts.length(); j++)
				{
					if(pp.pointInProfile(mapLiftPts.getPoint3d(j)) == _kPointInProfile)
					{
						LineSeg seg = pp.extentInDir(vecX);
						if(vecHor.dotProduct(seg.ptEnd() - seg.ptStart()) - U(50.5) < dEps || vecHor.dotProduct(seg.ptEnd() - seg.ptStart()) - U(100) < dEps )
						{
							bContinue = true;
							break;							
						}
					}
				}
				if (bContinue) continue;
			
				pp.shrink(-dLiftDirOffset);
				ppOutline.subtractProfile(pp);
			}
		}

		ppManual = ppOutline;
		
		// Check if panel is smaller than max allowed lifting distance
		{
			LineSeg seg = ppDevice.extentInDir(vecHor);
			double d1 = abs(vecHor.dotProduct(ptCOG - seg.ptStart()));
			double d2 = abs(vecHor.dotProduct(ptCOG - seg.ptEnd()));
			
			if(nLiftDirection == 3)
			{
				dLiftExtreme = (d1 < d2) ? d2 : d1;
			}
			else
			{
				double d3 = (d1 < d2) ? d1 : d2;
				if(d3 - dEdgeOffset < dLiftExtreme)
					dLiftExtreme = d3;				
			}
				
			double dSipHeight = abs(vZW.dotProduct(seg.ptEnd() - seg.ptStart()));	
			PLine plLiftArea;
			plLiftArea.createRectangle(LineSeg(ptCOG - vecHor * dLiftExtreme, ptCOG + vecHor * dLiftExtreme + vZW * dSipHeight), vecHor, vZW);
			if(plLiftArea.area() > pow(dEps,2))
				ppOutline.intersectWith(PlaneProfile(plLiftArea));	
		}
			
		Point3d ptExtreme, ptToCheck, ptsLiftTemps[0], ptsExtreme[0];
		PlaneProfile ppInMid, ppValidPos[0] ;
		Line lnZDown(ptCOG, - vZW);			
		int nMaxRuns;
		int bCheckFirst, bFirstHasPos;		
		PLine plVertices[0];
		
		//Define valid area for top and side
		if(!bIsFrontBack) 
		{
			Point3d ptsVertex[] = ppOutline.getGripVertexPoints();
			if (ptsVertex.length() > 0) ptsVertex.append(ptsVertex[0]);
			
			//#HSB-13550 cleanup vertex points to create useful PLines
			for(int i = ptsVertex.length()-1; i > -1;i--)
			{
				 if(ppOutline.pointInProfile(ptsVertex[i] + vZW * 2*dEps) != _kPointOutsideProfile)
				 	ptsVertex.removeAt(i);
			}
	
			for(int i=0; i < ptsVertex.length()-1; i++)
			{
				ptsVertex[i].vis(i );
				int nNext = i + 1;
				PLine pl(ptsVertex[i], ptsVertex[nNext]);
				if(pl.length() > dEps)
				{
					Vector3d vec(ptsVertex[i] - ptsVertex[nNext]);
					if(vZW.dotProduct(vec) < 0)
							vec *= - 1;	
														
					if(nLiftDirection == 3)
					{
						double dAng = (bManualInput) ? 45 : 0.5;
							if(vec.angleTo(vZW) < dAng)
								plVertices.append(pl);									
					}		
					else if(ppOutline.pointInProfile(pl.ptMid() + vZW * 2*dEps) == _kPointOutsideProfile)
					{
						//#HSB-13550 Check that this line is not the bottom of an opening
						PLine plCheck(pl.ptStart()+vZW*U(1), pl.ptEnd()+vZW*U(1), pl.ptEnd() + vZW * U(10000), pl.ptStart() + vZW * U(10000));
						plCheck.close();
						PlaneProfile ppFreeDirectionCheck(plCheck);
						ppFreeDirectionCheck.vis(2);
						double dPPArea = ppFreeDirectionCheck.area();
						ppFreeDirectionCheck.subtractProfile(ppOutline);
						
						double dd = ppFreeDirectionCheck.area() - dPPArea;
						
						if((nLiftDirection == 0 && vec.angleTo(vZW) < 45) || abs(ppFreeDirectionCheck.area() - dPPArea) > pow(U(1),2))
							continue;
						plVertices.append(pl);	
						pl.vis(1);
					}
				}
			}	
			
			//In automatic mode the distances to COG must be the same
			if(nLiftDirection == 3)
			{
				PLine plsKeep[0];
				double dDists[0];
				double dMaxDist=(bManualInput)?U(5000):U(50);
				
				for(int i=0; i < plVertices.length(); i++)
				{
					double dDist = vecHor.dotProduct(ptCOG - plVertices[i].ptMid());
					for(int j=0; j < dDists.length(); j++)
					{
						if( dDist * dDists[j] < 0 && abs(dDists[j] + dDist) < dMaxDist)
						{ 
							plsKeep.append(plVertices[i]);
							plsKeep.append(plVertices[j]);
						}
					}
					dDists.append(dDist);
				}
				plVertices = plsKeep;
				
				if(plVertices.length() < 1)
				{
					if(!bError && !bSihgaText)
						dpError.draw(T("|Cannot find valid position|"),_Pt0, vecXText, vecYText,0,0,_kDeviceX);
					bError = true;
				}
				else
				{
					plsManual = plVertices;
				}
			}
			
			Vector3d vecLiftDir = (nLiftDirection == 3) ? vZW : vecHor;
			Vector3d vecLiftPerp = (nLiftDirection == 3) ? vecHor : vZW;
			
			double dOffset = (nLiftDirection == 3) ? dLiftDirOffset : dEdgeOffset;
						
			// Create for each side a PlaneProfile that only contains valid positions for the lifting devices
			for(int i=0; i < plVertices.length(); i++)
			{
				PLine plV = plVertices[i]; plV.vis(6);
				Point3d ptM = plV.ptMid();
				Point3d pts[] ={ plV.ptStart(), plV.ptEnd()};
				
				Vector3d vecPP(pts[0] - pts[1]);
				vecPP.normalize();
				Vector3d vecPerp = vecZ.crossProduct(vecPP);
				if(ppOutline.pointInProfile(ptM + vecPerp* dEps) == _kPointOutsideProfile)
					vecPerp *= -1;
				
				Plane pn(ptM + vecPerp * U(0.2), vecPerp);
				PlaneProfile pp = bdSip.getSlice(pn); pp.vis(3);
									
				PLine plOps[] = pp.allRings(false, true);
				PLine plRings[] = pp.allRings(true, false);
				
				for(int j=0; j < plRings.length(); j++)
				{
					PlaneProfile p(plRings[j]);
					if(p.pointInProfile(ptM) == _kPointInProfile)
					{
						pp = p;
						break;
					}
				}
				
				if(pp.area() < pow(dEps,2))
					continue;
						
				//Adjust the ends of the edge. 
				{
					LineSeg seg = pp.extentInDir(vecLiftDir);
					pts = Line(pts[0], vecLiftDir).orderPoints(pts);;			
					double dExtremes[] = { vecLiftDir.dotProduct(pts[0] - seg.ptStart()), vecLiftDir.dotProduct(seg.ptEnd() - pts[1])};
					int nSigns[] = { 1, - 1};
					
					for(int j=0; j < pts.length();j++)
					{
						if(dExtremes[j] < dOffset)
						{
							pts[j] += nSigns[j] * vecLiftDir * (dOffset - dExtremes[j]);	
							if(Line(pts[j], vecLiftPerp).hasIntersection(pn))
								pts[j] = Line(pts[j], vecLiftPerp).intersect(pn, 0);
						}		
						// Shorten the length at the corner, so the Pick has enough space
						if( ptsAllVertices.find(pts[j]) > -1) 
						{
							pts[j] += nSigns[j] * vecLiftDir * 0.5 * dSinkHolePick;		
							if(Line(pts[j], vecLiftPerp).hasIntersection(pn))
								pts[j] = Line(pts[j], vecLiftPerp).intersect(pn, 0);				
						}					
					}
	
					if(vecLiftDir.dotProduct(pts[1] - pts[0]) < dEps)
						continue;					
				}

				ptsExtreme.append(pts[0]);
				ptsExtreme.append(pts[1]);
				
				// Create PlaneProfile with valid positions
				PLine plR;
				plR.createRectangle(LineSeg(pts[0] - vecZ * dZ, pts[1] + vecZ * dZ), vecPP, vecZ);
				PlaneProfile ppR(plR);
				
				for(int d=0; d < plOps.length(); d++)
				{
					PlaneProfile p(plOps[d]);
					
					// Don´t use tools from previous run
					int bContinue;
					Map mapLiftPts = _Map.getMap("LiftPts");
					for(int j=0; j < mapLiftPts.length(); j++)
					{
						if(p.pointInProfile(mapLiftPts.getPoint3d(j)) == _kPointInProfile)
						{
							LineSeg seg = p.extentInDir(vecX);
							double d = vecHor.dotProduct(seg.ptEnd() - seg.ptStart());

							if(d - U(50.5) < dEps)
							{
								bContinue = true;
								break;							
							}
						}
					}
					if (bContinue) continue;
					p.shrink(-dEdgeOffset);
					//ppR.subtractProfile(p);
				}	
				
				ppR.intersectWith(pp);				
				ppR.vis(2);

				// For lifting direction top Planeprofiles with the same height get united
				for(int j=0; j < ppValidPos.length(); j++)
				{
					CoordSys csPP = ppValidPos[j].coordSys();
					if(nLiftDirection == 0 && vecPerp.isParallelTo(csPP.vecZ()) && abs(vecPerp.dotProduct(csPP.ptOrg() - ptM)) < dEps)
					{
						ppValidPos[j].unionWith(ppR);
						break;
					}
					else if(j == ppValidPos.length()-1)
					{
						ppValidPos.append(ppR);
						break;
					}
				}					
				if(ppValidPos.length() < 1)
					ppValidPos.append(ppR);							
			}
		}
		
		if(!bManualInput && ppValidPos.length() < 1 && (bIsFrontBack && ppOutline.area() < pow(U(1),2)))
		{ 
			if(!bError && !bSihgaText)
				dpError.draw(TN("|Cannot find valid position|"), _Pt0, vecXText, vecYText, 0,0,_kDeviceX);
			bError = true;				
		}
		
		// Get position for side placement
		if(nLiftDirection == 3)
		{
			//Automatic input
			if(!bManualInput && !bError && !bHasPoints)
			{
				for(int i=0; i < ppValidPos.length(); i++)
					ppValidPos[i].vis(i + 1);
				
				double dDist = U(10000);
				for(int i=0; i < ppValidPos.length()-1; i+= 2)
				{
					LineSeg seg1 = ppValidPos[i].extentInDir(vZW);
					LineSeg seg2 = ppValidPos[i + 1].extentInDir(vZW);
					double dL1 = vZW.dotProduct(seg1.ptEnd() - seg1.ptStart());
					double dL2 = vZW.dotProduct(seg2.ptEnd() - seg2.ptStart());
					double dDSegs = vZW.dotProduct(seg1.ptEnd() - seg2.ptEnd());
					double dMax;
					Point3d pt, ptMax;
					int nRuns;
					Vector3d vecToMid = vecHor;
					
					if(vecToMid.dotProduct(ptCOG - seg1.ptEnd()) < 0)
						vecToMid *= -1;
					
					//Get position of possible same height
					if(dDSegs > - dEps)
					{
						if(dDSegs > dL1)
						{
							ptsLiftTemps.append(seg1.ptEnd());
							ptsLiftTemps.append(seg2.ptStart());
							vecLiftDevices.append(vecToMid);
							vecLiftDevices.append(-vecToMid);
							nRuns = 10;
						}
						else
						{
							pt = seg1.ptEnd() - vZW * dDSegs;		pt.vis(5);
							ptMax = seg1.ptEnd();	ptMax.vis(4);
							dMax = dL1;
						}
					}
					else
					{
						if(-dDSegs > dL2)
						{
							ptsLiftTemps.append(seg2.ptStart());
							ptsLiftTemps.append(seg1.ptEnd());
							vecLiftDevices.append(vecToMid);
							vecLiftDevices.append(-vecToMid);
							nRuns = 10;
						}
						else
						{
							pt = seg2.ptEnd() + vZW * dDSegs;
							ptMax = seg2.ptEnd();
							dMax = dL2;
						}
					}
					
					if(nRuns == 0)
						pt = pnMid.closestPointTo(pt);
					
					CoordSys cs1 = ppValidPos[i].coordSys();
					CoordSys cs2 = ppValidPos[i + 1].coordSys();
					Plane pn1(cs1.ptOrg(), cs1.vecZ());
					Plane pn2(cs2.ptOrg(), cs2.vecZ());
					
					while(ptsLiftTemps.length() < 2 && vZW.dotProduct(ptMax - pt) < dMax + dEps && nRuns < 50)
					{
						Line ln(pt, vecHor);
						Point3d pt1 = ln.intersect(pn1, 0);
						Point3d pt2 = ln.intersect(pn2, 0);
						
						if(ppValidPos[i].pointInProfile(pt1) != _kPointOutsideProfile && ppValidPos[i+1].pointInProfile(pt2) != _kPointOutsideProfile)
						{
							ptsLiftTemps.append(pt1);
							ptsLiftTemps.append(pt2);
							vecLiftDevices.append(vecToMid);
							vecLiftDevices.append(-vecToMid);
						}
						else
							pt -= vZW * U(100);	
							
						nRuns++;
					}
				}		
			}	
			//Manual input
			else if(bManualInput)
			{
				if( _kNameLastChangedProp.find("_PtG", -1) > -1)
				{
					int nPtG = _kNameLastChangedProp.right(1).atoi();
					ptToCheck = _PtG[nPtG];
						
					if(plsManual.length() > 0)
					{
						double dDist = U(20000);
						Point3d pt;		
							
						for(int i=0; i < plsManual.length(); i++)
						{
							Point3d ptT = plsManual[i]. closestPointTo(_PtG[nPtG]);
							double d = (_PtG[nPtG] - ptT).length();
							if(d < dDist)
							{
								dDist = d;
								pt = ptT;
							}
						}
						_PtG[nPtG] = pt;
							
						vecLiftDevices.setLength(0);
						
						for(int i=0; i < _PtG.length(); i++)
						{
							Vector3d vec(_PtG[i] - ptCOG);
							vec.normalize();
							
							Point3d pt = _PtG[i] + vec * U(0.5); 
							Vector3d vecT(pt - ppManual.closestPointTo(pt));
							vecT.normalize();
							vecLiftDevices.append(-vecT);	
						}
					}
					else
					{
						_PtG[nPtG] = ppManual.closestPointTo(_PtG[nPtG]);
						
						vecLiftDevices.setLength(0);
							
						for(int i=0; i < _PtG.length(); i++)
						{
							Vector3d vec(_PtG[i] - ptCOG);
							vec.normalize();
							
							Point3d pt = _PtG[i] + vec * U(0.5); 
							Vector3d vecT(pt - ppManual.closestPointTo(pt));
							vecT.normalize();
							vecLiftDevices.append(-vecT);	
						}
					}
					
					Map map;
					for(int i=0; i < _PtG.length(); i++)
					{
						map.appendPoint3d("ptLift", _PtG[i]);	
						map.appendVector3d("vecLift", vecLiftDevices[i]);				
					}
			
					_Map.setMap("LiftDevices", map);				
				}				
				else if(ptsLiftDevices.length() > 0)
				{
					_PtG = ptsLiftDevices;			
				}
				else 
				{
					Point3d pts[2];
					double dDistMax = U(-20000), dDistMin = U(20000);
					for(int i=0; i < plsManual.length();i++)
					{
						double d = vecHor.dotProduct(plsManual[i].ptMid() - ptCOG);
						if(d < dDistMin)
						{
							dDistMin = d;
							pts[0] = plsManual[i].ptMid();
						}
						if(d > dDistMax)
						{
							dDistMax = d;
							pts[1] = plsManual[i].ptMid();
						}
					}	
						
					if(dDistMax != U(-20000) && dDistMin != U(20000))
					{
						_PtG.append(pts[0]);
						_PtG.append(pts[1]);
						
						vecLiftDevices.setLength(0);
							
						for(int i=0; i < _PtG.length(); i++)
						{
							Vector3d vec(_PtG[i] - ptCOG);
							vec.normalize();
									
							Point3d pt = _PtG[i] + vec * U(0.5); 
							Vector3d vecT(pt - ppManual.closestPointTo(pt));
							vecT.normalize();
							vecLiftDevices.append(-vecT);	
						}							
					}
					
					Map map;
					for(int i=0; i < _PtG.length(); i++)
					{
						map.appendPoint3d("ptLift", _PtG[i]);	
						map.appendVector3d("vecLift", vecLiftDevices[i]);				
					}
			
					_Map.setMap("LiftDevices", map);	
				}					
			}
			ptsLiftDevices.setLength(0);
			ptsLiftTemps = _PtG;
		}
		// All directions beside side. Get start point.
		else 
		{
			Vector3d vecSearchDir = vecHor;
			double dDeviceDist;
			double dDistToLiftPoint = (nLiftingType == 0 && nNumDevices == 4) ? 0.5 * dTraverseLength : 0;		
	
			for(int i=0; i < ppValidPos.length(); i++)
			{
				LineSeg seg = ppValidPos[i].extentInDir(vecSearchDir);

				if(vecHor.dotProduct(ptCOG - seg.ptStart()) > 2 * dEdgeOffset + dDeviceDist && vecHor.dotProduct(seg.ptEnd() - ptCOG) > 2 * dEdgeOffset + dDeviceDist )
				{ 
					ppInMid = ppValidPos[i];
//					if(abs(vZW.dotProduct(ptsExtreme[0] - ptsExtreme[1])) > U(10))
					if(abs(vZW.dotProduct(ptsExtreme[0] - ptsExtreme[1])) > dAllowedUnevenessCalc)
					{
						ptToCheck = ( vZW.dotProduct(ptsExtreme[0] - ptsExtreme[1]) > dEps ) ? ptsExtreme[1] : ptsExtreme[0];							
					}
					else
					{
						ptToCheck =  abs( vecHor.dotProduct(ptsExtreme[1] - ptCen)) >  abs( vecHor.dotProduct(ptsExtreme[0] - ptCen)) ? ptsExtreme[1] : ptsExtreme[0];	
					}

//					ptToCheck.vis(4);
					bCheckFirst = true;
				}								
			}
			
			ptsExtreme = Line(ptCOG, vecSearchDir).orderPoints(ptsExtreme);
			
			if(bIsFrontBack)
			{
				if(nNumDevices == 1)
				{
					LineSeg segSingle(ptCOG, ptCOG + vZW * U(50000));
					LineSeg segsSingle[] = ppOutline.splitSegments(segSingle, true);
					if(segsSingle.length() > 0)
					{
						Point3d ptSingle = segsSingle.last().ptEnd();
						ptSingle += (nLiftDirection == 2) ? - vecZ * 0.5 * dZ : vecZ * 0.5 * dZ;
						ptsLiftDevices.append(ptSingle);
						vecLiftDevices.append((nLiftDirection == 2) ?  vecZ : -vecZ);
					}
				}

				bCheckFirst = true;	
				ppInMid = ppOutline; ppOutline.vis(3);
				LineSeg seg = ppOutline.extentInDir(vecHor);	seg.vis(2);
				ptsExtreme.append(seg.ptStart());
				ptsExtreme.append(seg.ptEnd());
					
				for(int i=0; i < ptsExtreme.length(); i++)
				{
					Point3d pts[] = ppOutline.intersectPoints(Plane(ptsExtreme[i], vecHor),true, false);
					if (pts.length() < 1) continue;
					pts = lnZDown.orderPoints(pts);
					ptsExtreme[i] = pts[0];
				}				
				ptToCheck = (abs(vecHor.dotProduct(ptsExtreme[0] - ptCOG)) < abs(vecHor.dotProduct(ptsExtreme[1] - ptCOG))) ? ptsExtreme[0] : ptsExtreme[1];				
//				ptToCheck.vis(1);
			}

			{ 
				Point3d ptsExtr[0]; ptsExtr = ptsExtreme;
				for(int i=0; i < ptsExtr.length(); i++)
				{
					for(int j=i; j < ptsExtr.length(); j++)
					{
						if((ptsExtr[j] - ptCOG).length() > (ptsExtr[i] - ptCOG).length())
							ptsExtr.swap(i, j);
					}
				}
				if(ptsExtr.length() > 1)
				{
					double dHExtr = vZW.dotProduct(ptsExtreme[0] - ptsExtreme[1]);
					if(abs(dHExtr) > U(100))
						ptExtreme = (dHExtr > 0) ? ptsExtreme[1] : ptsExtreme[0];
					else
						ptExtreme = (abs(vecHor.dotProduct(ptCOG - ptsExtreme[0])) > abs(vecHor.dotProduct(ptCOG - ptsExtreme[1]))) ? ptsExtreme[0] : ptsExtreme[1];			
//					ptExtreme.vis(1);
					if(abs(dHExtr) > dStrapLength)
					{
						if(!bError && !bSihgaText)
							dpError.draw(T("|Lifting chain/strap is too short|"), _Pt0, vecXText, vecYText, 0, 0,_kDeviceX);
						bError = true;				
					}					
				}
				else if(ptsExtr.length() > 0)
					ptExtreme = ptsExtr[0];
				else
					ptExtreme = ptCOG;
			}
			
			dDeviceDist =(nNumDevices == 4)? dMaxInterdistance : 0;		
			int bSideChecked;
			Point3d ptStrapTopOther;
			int bStrapTopOther;
			Vector3d vecDeviceTemps[4];
			
			// Create horizontal top edge
			if(_Map.getInt("AlignmentFrontBack") && bIsFrontBack)
			{
				Point3d ptLowest;
						
				if( _kNameLastChangedProp.find("_PtG", -1) > -1)
				{
					int nPtG = _kNameLastChangedProp.right(1).atoi();
					ptLowest = _PtG[nPtG];							
				}
				else if(ptsLiftDevices.length() > 0)
				{
					Point3d pts[] = lnZDown.orderPoints(ptsLiftDevices);
					ptLowest = pts.last();
				}
				else
					ptLowest = ptExtreme;
					
				LineSeg seg = ppManual.extentInDir(vZW); 
				PLine pl;
				pl.createRectangle(seg, vecHor, vZW);
				PlaneProfile pp(pl);
				double d = vZW.dotProduct(ptLowest - seg.ptStart());
				pp.transformBy(vZW * d);
				//ppManual.subtractProfile(pp);
				ppInMid.subtractProfile(pp);
						
				ppManual.vis(6);
			}
//			ptExtreme.vis(2);
			
		//Find valid position for top front or back
			if(!bManualInput && !bError && nNumDevices > 1)
			{	
				while(ptsLiftTemps.length() < nNumDevices && nMaxRuns < 5)
				{
					if(nMaxRuns == 0 && !bCheckFirst && nLiftDirection != 3)
						ptToCheck = ptExtreme;
					
					if(vecSearchDir.dotProduct(ptCOG - ptToCheck) < 0)
						vecSearchDir *= -1;
		
					int nMaxRuns2;	
					
					while( nMaxRuns2 < 10)
					{
						int bAdded;
						Vector3d vecDevice;
						
						if(bCheckFirst)
						{
							if(ppInMid.pointInProfile(ptToCheck) != _kPointOutsideProfile)
							{
								vecDevice = ppInMid.coordSys().vecZ();
								bAdded = true;	
							}
						}					
						else
						{
							for(int i=0; i < ppValidPos.length(); i++)
							{								
								if(ppValidPos[i].pointInProfile(ptToCheck) != _kPointOutsideProfile)
								{
									bAdded = true;
									vecDevice = ppValidPos[i].coordSys().vecZ();
									
									if(nNumDevices == 4 && nLiftingType == 1)
									{
										Point3d ptT = ppManual.closestPointTo(ptToCheck + vecSearchDir * U(1));
										Vector3d vec(ptCOG - ptT);
										vec.normalize();
										Point3d pt = ptT + vec * dEps;
										vec = Vector3d(pt - ppManual.closestPointTo(pt));
										vec.normalize(); 
										vecDeviceTemps[0] = vec;										
									}
									break;
								}							
							}
						}
						
						if(vecDevice.dotProduct(vZW) > 0)
							vecDevice *= -1;
							
						if(bAdded)
						{
							// Get top point for angle calculation
							Vector3d vecStrap, vecChain;
							Point3d ptCrane, ptStrap1Top, ptStrap2Top, ptToCheck2;
							
							if(nLiftDirection == 0)
								ptToCheck = pnMid.closestPointTo(ptToCheck);
	
						// Lifttype Chain with straps 
							if(nLiftingType == 1 && nNumDevices == 4)
							{
								Point3d ptStrapTop = ptToCheck + vecSearchDir * dMaxInterdistance + vZW * pow((pow(0.5 * dStrapLength, 2) - pow(dMaxInterdistance,2)), 0.5);
								Vector3d vecStrap1= Vector3d(ptStrapTop - ptToCheck);
								vecStrap1.normalize();
								vecStrap1 = vecStrap1.rotateBy(180, vZW);
								Vector3d vecStrapPerp1 = vecStrap1.crossProduct(vecZ);
								Vector3d vecStrap2, vecChain, vecStrapPerp2, vecPPUp;
								Vector3d vecPick[0];
								Point3d pts2[0];
								
								double dBeta = 30;
									
								if(bCheckFirst)
								{
									pts2 = ppInMid.intersectPoints(Plane(ptStrapTop, vecStrapPerp1), true, false);
												
									if(pts2.length() > 0)
									{
										pts2 = lnZDown.orderPoints(pts2);									
									}
								}					
								else
								{
									for(int i=0; i < ppValidPos.length(); i++)
									{	
										pts2 = ppValidPos[i].intersectPoints(Plane(ptStrapTop, vecStrapPerp1), true, false);
												
										if(pts2.length() > 0)
										{
											pts2 = lnZDown.orderPoints(pts2);
											break;
										}
									}									
								}
							
							//Check position on one side
								if(pts2.length() > 0)
								{
									pts2[0] = pnMid.closestPointTo(pts2[0]); 
									Vector3d vecEdge(pts2[0] - ptToCheck);
									double dInter = 0.5 * vecEdge.length();
									vecEdge.normalize();
									double dToCOG = abs(vecHor.dotProduct(ptCOG - ptToCheck));
									dToCOG = dToCOG / cos(vecEdge.angleTo(vecSearchDir));

									double dAdd = 1;

									for(int n=0; n < 2; n++)
									{
										for(int i=0; i < 80; i++)
										{
											double dStrap1Length = (pow(dStrapLength, 2) - pow(2*dInter, 2)) / (2 * dStrapLength - 4 * dInter * cos(dBeta));		
											double dStrap1Hor = cos(dBeta) * dStrap1Length;		
											double dHTop = dStrap1Length * sin(dBeta);
											double dA = atan(dHTop / (2 * dInter - dStrap1Hor));
											dA = (dA < 0) ? -1*(90 + dA) : 90 - dA;
											double dAngleChain = 90 - ((90 - dBeta) + dA) / 2 + dA;
											double dL1 = dChainLength * cos(dAngleChain) + dStrap1Hor;		
											double dHTotal = dChainLength * sin(dAngleChain) + dHTop;
											double dAnglePlumb = vZW.angleTo(vecEdge);
											double dL2 = dHTotal / tan(dAnglePlumb);
											dL2 = (dAnglePlumb > 90 + dEps) ? dL2 : - dL2;
											double dL0 = dL1 + dL2;
												
											if(i > 0 && dL0 < dToCOG)
											{													
												vecPPUp = vecEdge .crossProduct(vecZ);
												if(vecPPUp.dotProduct(vZW) < 0)
													vecPPUp *= -1;
												
												ptCrane = ptToCheck + vecEdge * dL1 + vecPPUp * dHTotal;
												ptStrap1Top = ptToCheck + vecEdge * dStrap1Hor + vecPPUp * dHTop;	
												double ds = (ptStrap1Top - ptToCheck).length();
												vecStrap1 = (ptStrap1Top - ptToCheck); vecStrap1.normalize(); 
												vecStrap2 = (ptStrap1Top - pts2[0]); vecStrap2.normalize(); 
												vecChain = (ptCrane - ptStrapTop); vecChain.normalize();
												break;
											}
											dBeta += dAdd;										
										}
										
										if(n== 0)
											dBeta -= 1;
										dAdd = 0.05;
									}
								}	
	
								if(90 - dBeta > dMaxAngle + dEps)
									bAdded = false;
								else
								if(pts2.length() > 0)
								{
									ptToCheck2 = pts2[0];	

									if(vecPPUp.length() > dEps)
										vecDeviceTemps[1] = -vecPPUp;
								}
								else
									bAdded = false;
									
							// Check other side		
								if(!bSideChecked && bAdded)
								{
									vecSearchDir *= -1;
									ptStrap2Top = ptStrap1Top + vecSearchDir * 2 * vecSearchDir.dotProduct(ptCOG - ptStrap1Top);
									vecStrap1 = vecStrap1.rotateBy(180, vZW);	
									vecStrap2 = vecStrap2.rotateBy(180, vZW);	
									vecChain = vecChain.rotateBy(180, vZW);

									Vector3d vecPerp = vecChain.crossProduct(vecZ);
									Point3d pts[0];
										
									if(bCheckFirst)
										pts = ppInMid.intersectPoints(Plane(ptStrap2Top, vecPerp), true, false);
									else
									{
										for(int i=0; i < ppValidPos.length(); i++)
										{	
											pts = ppValidPos[i].intersectPoints(Plane(ptStrap2Top, vecPerp), true, false);
														
											if(pts.length() > 0)
												break;
										}												
									}
											
									if(pts.length() > 0)
									{
										pts = lnZDown.orderPoints(pts);
										ptStrap2Top = pts[0] + vecChain * U(300);
									}

									ptStrap2Top = pnMid.closestPointTo(ptStrap2Top);
									int nRun;
									double dPrevious;
									Point3d ptsO[0];
									vecStrapPerp1 = vecStrap1.crossProduct(vecZ);
									vecStrapPerp2 = vecStrap2.crossProduct(vecZ);
										
								// The result is found by compaing to results with different heights. 
									while(nRun < 10)
									{

										double dToTop1, dToTop2;
										Point3d ptsS1[0], ptsS2[0];

										if(bCheckFirst)
											ptsS1 = ppInMid.intersectPoints(Plane(ptStrap2Top, vecStrapPerp1), true, false);
										else
										{
											for(int i=0; i < ppValidPos.length(); i++)
											{	
												ptsS1 = ppValidPos[i].intersectPoints(Plane(ptStrap2Top, vecStrapPerp1), true, false);
															
												if(ptsS1.length() > 0)
												{
													ptsS1 = lnZDown.orderPoints(ptsS1);	
													
													Point3d ptT = ppManual.closestPointTo(ptsS1[0] + vecSearchDir * U(1));
													Vector3d vec(ptCOG - ptT);
													vec.normalize();
													Point3d pt = ptT + vec * dEps;
													vec = Vector3d(pt - ppManual.closestPointTo(pt));
													vec.normalize(); 
													vecDeviceTemps[2] = vec;
													
													break;
												}
											}												
										}

										if(ptsS1.length() > 0)
										{
											ptsS1[0] = pnMid.closestPointTo(ptsS1[0]);
											dToTop1 = (ptStrap2Top -ptsS1[0]).length();							
											
											{											
												if(bCheckFirst)
													ptsS2 = ppInMid.intersectPoints(Plane(ptStrap2Top, vecStrapPerp2), true, false);
												else
												{
													for(int i=0; i < ppValidPos.length(); i++)
													{	
														ptsS2 = ppValidPos[i].intersectPoints(Plane(ptStrap2Top, vecStrapPerp2), true, false);
																	
														if(ptsS2.length() > 0)
														{
															ptsS2 = lnZDown.orderPoints(ptsS2);
															ptsS2[0] = pnMid.closestPointTo(ptsS2[0]);
															Point3d ptT = ppManual.closestPointTo(ptsS2[0] + vecSearchDir * U(1));
															Vector3d vec(ptCOG - ptT);
															vec.normalize();
															Point3d pt = ptT + vec * dEps;
															vec = Vector3d(pt - ppManual.closestPointTo(pt));
															vec.normalize(); 
															vecDeviceTemps[3] = vec;
															
															break;
														}
													}
												}
												
												if(ptsS2.length() > 0)
												{
													ptsS2 = lnZDown.orderPoints(ptsS2);
													ptsS2[0] = pnMid.closestPointTo(ptsS2[0]);
													dToTop2 = (ptStrap2Top - ptsS2[0]).length();
													
													if(abs(dStrapLength - dToTop1 - dToTop2) < U(1))
													{
														ptsLiftTemps.append(ptToCheck);
														ptsLiftTemps.append(ptToCheck2);
														ptsLiftTemps.append(ptsS1[0]);
														ptsLiftTemps.append(ptsS2[0]);
														vecLiftDevices.setLength(0);
														
														plsLifting.setLength(0);
														plsLifting.append(PLine(ptsLiftTemps[0], ptStrap1Top));
														plsLifting.append(PLine(ptsLiftTemps[1], ptStrap1Top));
														plsLifting.append(PLine(ptStrap1Top, ptCrane));
														plsLifting.append(PLine(ptsLiftTemps[2], ptStrap2Top));
														plsLifting.append(PLine(ptsLiftTemps[3], ptStrap2Top));
														plsLifting.append(PLine(ptStrap2Top, ptCrane));
														
														if(bCheckFirst)
														{
															for(int i=0; i < 4; i++)
																vecLiftDevices.append(vecDevice);
														}
														else
															vecLiftDevices = vecDeviceTemps;
														
														nMaxRuns = 100;
														nMaxRuns2 = 100;
														break;
													}
												}
											}
										}
										
										if( ptsS2.length() > 0)
										{
											if(dPrevious == 0)
											{
												dPrevious = dToTop1 + dToTop2;
												ptStrap2Top += (dPrevious - dStrapLength < 0) ?  vecChain * U(100) : -vecChain * U(100);
											}
											else
											{
												double dNow = dToTop1 + dToTop2;
												double dDiff = dNow- dPrevious;
												double dDist = dStrapLength - dNow;
												ptStrap2Top += vecChain * dDist / dDiff * U(100);
											}
										}
										nRun++;
									}
								}
							}
						// Traverse lifting or 2 devices
							else
							{	
								double dToCOG = vecSearchDir.dotProduct(ptCOG - ptToCheck);		
								double dToStrapTop = (nNumDevices == 4) ? dToCOG - 0.5 * dTraverseLength : dToCOG;
								Point3d ptStrapTop = (bStrapTopOther)? ptStrapTopOther : ptToCheck + vecSearchDir * dToStrapTop + vZW * pow((pow(dStrapLength, 2) - pow(dToStrapTop,2)), 0.5);
								vecStrap = Vector3d(ptStrapTop - ptToCheck);
								vecStrap.normalize();
								double dAngle = vZW.angleTo(vecStrap);		
	
								ptCrane = (nNumDevices == 4)?  ptStrapTop + vecSearchDir * 0.5*dTraverseLength : ptStrapTop;
								ptForStrapLength = ptCrane;
								vecForStrapLength = vecSearchDir;
									
								Vector3d vecPP2;
									
								//Check angle < 45 °
								if(!bIsFrontBack && vecStrap.angleTo(-vecDevice) > 45)
									bAdded = false;
								
							//Traverse lifting, check 2nd device
								if(bAdded && nNumDevices == 4)
								{
									Vector3d vecStrap2 = vecStrap.rotateBy(180, vZW);
									Vector3d vecStrap2Perp = vecStrap2.crossProduct(vecZ);
									Point3d pts2[0];
										
									if(bCheckFirst)
									{
										pts2 = ppInMid.intersectPoints(Plane(ptStrapTop, vecStrap2Perp), true, false);
												
										if(pts2.length() > 0)
										{
											pts2 = lnZDown.orderPoints(pts2);
											vecPP2 = ppInMid.coordSys().vecZ();
										}
									}					
									else
									{
										for(int i=0; i < ppValidPos.length(); i++)
										{	
											pts2 = ppValidPos[i].intersectPoints(Plane(ptStrapTop, vecStrap2Perp), true, false);
													
											if(pts2.length() > 0)
											{
												pts2 = lnZDown.orderPoints(pts2);
												vecPP2 = ppValidPos[i].coordSys().vecZ();
												break;
											}
										}	
									}									
									
									if(vZW.dotProduct(vecPP2) < 0)
										vecPP2 *= -1;
		
									if(pts2.length() < 1)
										bAdded = false;
									else if(!bIsFrontBack && vecStrap.angleTo(vecPP2) > dMaxAngle + dEps)
										bAdded = false;
									else
									{	
										if(nLiftDirection == 0)
											pts2[0] = pnMid.closestPointTo(pts2[0]);
											
										ptsLiftTemps.append(pts2[0]);	pts2[0].vis(4);
										
										if(vecPP2.length() > dEps)
											vecLiftDevices.append(- vecPP2);
									}										
									ptCrane=ptStrapTop+2*vecSearchDir*dDistToLiftPoint;
								}
								
								int bAddPtO;
								Point3d ptsO[0];
							
							// Precheck opposite position
								if(!bSideChecked && bAdded)
								{
									Vector3d vecOther = vecStrap.rotateBy(180, vZW);
									Vector3d vecOtherPerp = vecOther.crossProduct(vecZ);
									vecOther.vis(ptCrane, 1);
											
									if(bCheckFirst)
									{
										ptsO = ppInMid.intersectPoints(Plane(ptCrane, vecOtherPerp), true, false);
												
										if(ptsO.length() > 0)
										{
											ptsO = lnZDown.orderPoints(ptsO); 
											
											if(bIsFrontBack)
											{
												double dDist = vZW.dotProduct(ptsO[0] - ptToCheck);
												Point3d ptTest = (dDist > dEps)?   ptToCheck : ptsO[0];
														
												double dCheck = vZW.dotProduct(ptTest - ptCOG); 
														
												if(dCheck > U(300)) // Sihga Pick must be minimum 300 mm above the CoG
												{
													if(dDist > dEps)
													{
														Point3d pt = ptsO[0] + vZW * dDist;
														if(ppInMid.pointInProfile(pt) != _kPointOutsideProfile)
															ptsO[0] = pt;
													}
													else
													{
														Point3d pt = ptToCheck + vZW * dDist;
														if(ppInMid.pointInProfile(pt) != _kPointOutsideProfile)
															ptToCheck = pt;	
													}
												}
											}	
										}	
										
										if(ptsO.length() < 1)
										{
											bAdded = false;												
										}
										else
										{
											// 
											if(vZW.dotProduct(ptToCheck - ptsO[0]) >dAllowedUnevenessCalc)
											{
												// check in height
												bAdded = false;
											}
											else
												bAddPtO = true;												
										}																	
									}					
									else
									{
										for(int i=0; i < ppValidPos.length(); i++)
										{	
											ptsO = ppValidPos[i].intersectPoints(Plane(ptCrane, vecOtherPerp), true, false);
														
											if(ptsO.length() > 0)
											{
												ptsO = lnZDown.orderPoints(ptsO);
												bAddPtO = true;
			
												break;
											}
										}	
										if(ptsO.length() < 1)
											bAdded = false;
									}
												
									if(!bIsFrontBack && vecStrap.angleTo(-vecDevice) > 45)
										bAdded = false;
		
										
									if(bAdded)
									{
										ptsLiftTemps.append(ptToCheck);
										vecLiftDevices.append(vecDevice);
												
										if(bAddPtO)
											ptToCheck = ptsO[0];		
//										ptToCheck.vis(6);
									}
								}	
							}
									
							if(bAdded)
							{
								ptStrapTopOther = ptCrane;
								bStrapTopOther = true;
								
								if(bSideChecked)
								{
									ptsLiftTemps.append(ptToCheck);
									vecLiftDevices.append(vecDevice);
									break;
								}
								else
								{
									bSideChecked = true;
									break;
								}
							}
						}	
						
					// Find next position. This one has invalid result
						if(!bAdded)
						{
							int newPt;
							
//							for(int i=vecDeviceTemps.length()-1; i > -1; i--)
//								vecDeviceTemps.removeAt(i);
							vecDeviceTemps.setLength(4);
							
							while(!newPt && vecSearchDir.dotProduct(ptCOG - ptToCheck) > 0)
							{
								ptToCheck = ptToCheck + vecSearchDir * U(100);
								Plane pn(ptToCheck, vecSearchDir);
								if(bCheckFirst)
								{
									Point3d pts[] = ppInMid.intersectPoints(pn, true, false);
									if(pts.length() > 0)
									{
										pts = lnZDown.orderPoints(pts);
										ptToCheck = pts[0];
//										ptToCheck.vis(4);
										newPt = true;
									}
								}
								else
								{
									for(int i=0; i < ppValidPos.length(); i++)
									{
										Point3d pts[] = ppValidPos[i].intersectPoints(pn, true, false);
										if(pts.length() > 0)
										{
											pts = lnZDown.orderPoints(pts);
											ptToCheck = pts[0];
											newPt = true;
											break;
										}								
									}
								}
							}					
							
							if(! newPt && bCheckFirst && !bIsFrontBack)
							{
								bCheckFirst = false;
								nMaxRuns = 0;
								nMaxRuns2 = 0;
								ptToCheck = ptExtreme;
							}
							ptsLiftTemps.setLength(0);
							vecLiftDevices.setLength(0);
							bSideChecked = false;	
							bStrapTopOther = false;
						}			
						nMaxRuns2++;
					}	
					nMaxRuns++;
				}	
			}
		// Manual input
			else if(bManualInput)
			{
				ppManual.vis(3);
					double dPtGToCOGs[0];
					Point3d ptToCheck2;
					vecSearchDir = Vector3d(0, 0, 0);
	
					if( _kNameLastChangedProp.find("_PtG", -1) > -1)
					{
						int nPtG = _kNameLastChangedProp.right(1).atoi();
						ptToCheck = _PtG[nPtG];
						ptToCheck = pnMid.closestPointTo(ptToCheck);
						
						double dToCOG = vecHor.dotProduct(ptCOG - _PtG[nPtG]);
						vecSearchDir = (dToCOG > 0) ? vecHor : -vecHor;
						dToCOG = abs(dToCOG);
					
						//Check max. position
						double dMaxToCOG;
						if(nNumDevices == 2)
							dMaxToCOG = dStrap2dLength - U(100);
						else
						{
							if(nLiftingType == 0)
								dMaxToCOG = 0.5 * dTraverseLength + dStrapTraverseLength - U(100);
							else
								dMaxToCOG = dChainLength * 0.7 + dStrapChainLength - U(100);
						}							
						
						for(int i=0; i < _PtG.length(); i++)
						{
							if (i == nPtG) continue;
							if(vecSearchDir.dotProduct(ptCOG - _PtG[i]) > 0)
							{
								ptToCheck2 = _PtG[i];
								ptToCheck2 = ppManual.closestPointTo(ptToCheck2);
								break;
							}
						}						
						double dInterCheckPoints = vecSearchDir.dotProduct(ptToCheck - ptToCheck2);
						dMaxToCOG -= (dInterCheckPoints > 0) ? dInterCheckPoints : 0;
						dInterCheckPoints = abs(dInterCheckPoints);
						
						LineSeg segMax = ppManual.extentInDir(vecHor);
						if(dMaxToCOG > abs(vecHor.dotProduct(segMax.ptStart() - ptCOG)) - 0.5*dSinkHolePick)
							dMaxToCOG = abs(vecHor.dotProduct(segMax.ptStart() - ptCOG)) - 0.5 * dSinkHolePick;
						if(dMaxToCOG > abs(vecHor.dotProduct(segMax.ptEnd() - ptCOG)) - 0.5*dSinkHolePick)
							dMaxToCOG = abs(vecHor.dotProduct(segMax.ptEnd() - ptCOG)) - 0.5 * dSinkHolePick;
						
						if(abs(dToCOG) > dMaxToCOG)
						{
							ptToCheck += vecSearchDir * (dToCOG - dMaxToCOG);
						}
						
						if(bIsFrontBack)
						{
							if(_Map.getInt("AlignmentFrontBack") == false)
							{
								Point3d ptsC[] = ppManual.intersectPoints(Plane(ptToCheck, vecHor), true, false);
								if(ptsC.length() > 0)
								{
									ptsC = lnZDown.orderPoints(ptsC);
									ptToCheck = ptsC[0];
								}
							}
							else
							{
								if (vZW.dotProduct(ptToCheck - ptCOG) < U(300))
									ptToCheck += vZW * (vZW.dotProduct(ptCOG - ptToCheck) + U(300));
								if(ppManual.pointInProfile(ptToCheck) == _kPointOutsideProfile)
									ptToCheck = ppManual.closestPointTo(ptToCheck);									
							}
							
							ptToCheck = pnMid.closestPointTo(ptToCheck);
						}
						else if (nLiftDirection == 0)
						{
							if(vZW.dotProduct(ptToCheck - ptCOG) < U(300))
							{ 
								ptToCheck = Plane(ptCOG + vZW * U(500), vZW).closestPointTo(ptToCheck);
							}
							ptToCheck = ppManual.closestPointTo(ptToCheck);		//ptToCheck.vis(1);					
						}

						if(nNumDevices == 4)
						{							
							if(nLiftingType == 1)
							{ 
								if(dInterCheckPoints > dStrapChainLength - U(100))
								{
									ptToCheck = ptToCheck2 - vecSearchDir * (dStrapChainLength - U(100));
									ptToCheck = ppManual.closestPointTo(ptToCheck);								
								}
							}
							else if(nLiftingType == 0)
							{
								Point3d ptsPtG[0]; ptsPtG = _PtG;
								ptsPtG = lnZDown.orderPoints(ptsPtG);
								double dToLowest = vZW.dotProduct(ptsPtG[0] - ptsPtG.last());
								dToLowest = dStrapTraverseLength - dToLowest;
								
								if(dInterCheckPoints > dToLowest - U(10))
								{
									ptToCheck = ptToCheck2 - vecSearchDir * 2 * (dToLowest - U(10));
									ptToCheck = ppManual.closestPointTo(ptToCheck);				
								}							
							}
						}
						
						Map map;
						if(_PtG.length() == vecLiftDevices.length())
						{
							for(int i=0; i < _PtG.length(); i++)
							{
								map.appendPoint3d("ptLift", _PtG[i]);	
								map.appendVector3d("vecLift", vecLiftDevices[i]);				
							}
					
							_Map.setMap("LiftDevices", map);								
						}
					
						_PtG.setLength(0);
						ptsLiftDevices.setLength(0);
					}				
					else if(ptsLiftDevices.length() == nNumDevices)
					{
						ptToCheck = ptsLiftDevices[0];		//ptToCheck.vis(2);	
						
						if(bIsFrontBack)
						{
							if (vZW.dotProduct(ptToCheck - ptCOG) < U(300))
							ptToCheck += vZW * (vZW.dotProduct(ptCOG - ptToCheck) + U(300));
							if(ppManual.pointInProfile(ptToCheck) == _kPointOutsideProfile)
								ptToCheck = ppManual.closestPointTo(ptToCheck);		
						}
					}
					else 
					{
						ptToCheck = ptExtreme;
						
						if(bIsFrontBack)
						{
							if (vZW.dotProduct(ptToCheck - ptCOG) < U(300))
							ptToCheck += vZW * (vZW.dotProduct(ptCOG - ptToCheck) + U(300));
							if(ppManual.pointInProfile(ptToCheck) == _kPointOutsideProfile)
								ptToCheck = ppManual.closestPointTo(ptToCheck);					
						}
						else if (nLiftDirection == 0)
							ptToCheck = ppManual.closestPointTo(ptToCheck);
						
						if(nNumDevices == 4 && nLiftingType == 1)
						{
							double dToCOG = vecHor.dotProduct(ptCOG - ptToCheck);
							vecSearchDir = (dToCOG > 0) ? vecHor : -vecHor;
							
							double dToCheck2 = (abs(dToCOG) + U(80) < dMaxInterdistance) ? abs(dToCOG) * 0.8 : dMaxInterdistance;
							
							ptToCheck2 = ppManual.closestPointTo(ptToCheck + vecSearchDir * dToCheck2);
							
						}
						
						_PtG.setLength(0);
						ptsLiftDevices.setLength(0);					
					}
					
					if(nLiftDirection == 0)
						ptToCheck = pnMid.closestPointTo(ptToCheck);		
						
					Point3d ptsLift[] = { ptToCheck}; 
					Point3d ptTopLifting;
					int bChainStrap = nLiftingType == 1 && nNumDevices == 4;
							
					if( ! bChainStrap)
					{											
						vecSearchDir = vecHor;
						double dToCOG = vecHor.dotProduct(ptCOG - ptToCheck);		
						if(dToCOG < 0)
						{ 
							vecSearchDir *= -1;
							dToCOG *= -1;
						}
//						ptToCheck.vis(6);
						
						plsLifting.setLength(0);
						double dToTopLift = (nNumDevices == 4) ? dToCOG - 0.5 * dTraverseLength : dToCOG;
						ptTopLifting = ptToCheck + vecSearchDir * dToTopLift + vZW * pow( pow(dStrapLength, 2) - pow(dToTopLift, 2), 0.5 );

						ptForStrapLength = ptTopLifting;
						if(nNumDevices == 4)
							ptForStrapLength += vecSearchDir * 0.5 * dTraverseLength;

						vecForStrapLength = vecHor;
						//plsLifting.append(PLine(ptToCheck, ptTopLifting));
						Vector3d vecStrap(ptTopLifting - ptToCheck);
						vecStrap.normalize();
						vecStrap = vecStrap.rotateBy(180, vZW);
						Vector3d vecPerp = vecStrap.crossProduct(vecZ);
						vecLiftDevices.setLength(0);
						Point3d ptsStrapTop[] ={ptTopLifting };
								
						if(nLiftDirection == 0)
						{
							Point3d pt = ptToCheck + vecStrap * U(0.5); 
							Vector3d vec(pt - ppManual.closestPointTo(pt));
							vec.normalize();
							vecLiftDevices.append(-vec);									
						}
						
									
						for(int i=0; i < nNumDevices-1; i++)
						{
							Point3d ptsT[]= ppManual.intersectPoints(Plane(ptTopLifting, vecPerp), true, false);		
										
							if(ptsT.length() > 0)
							{
								ptsT = lnZDown.orderPoints(ptsT);	
								ptsLift.append(pnMid.closestPointTo(ptsT[0]));
								Point3d pt = ptsLift.last() + vecStrap * U(0.5);
								Vector3d vec(pt - ppManual.closestPointTo(pt));
								vec.normalize();
								vecLiftDevices.append(-vec);										
							}	
														
								
							if(i ==0 && nNumDevices == 4 && nLiftingType == 0)
							{
								ptTopLifting += vecSearchDir * dTraverseLength;	
								ptsStrapTop.append(ptTopLifting);
							}
							else if(i == 1)
							{
								vecPerp = vecPerp.rotateBy(180, vZW);		
								vecStrap = vecStrap.rotateBy(180, vZW);
							}
						}						
					}	
					else // nLiftType == 1
					{							
						if(vecSearchDir.length() < dEps)
						{
							Point3d pts[0];
							if(_PtG.length() < 1)
							{
								for(int i=0; i < ptsLiftDevices.length(); i++)
									pts.append(ptsLiftDevices[i]);										
							}
							else
							{
								for(int i=0; i < _PtG.length(); i++)
									pts.append(_PtG[i]);	
								_PtG.setLength(0);
							}
			
							if(pts.length() > 1)
							{
								vecSearchDir = (vecHor.dotProduct(pts[0] - ptCOG) > 0) ? - vecHor : vecHor;
								ptsLift.setLength(0);
								pts = Line(ptCOG, vecSearchDir).orderPoints(pts);	
								ptsLift.append(pts[0]); 		
								ptsLift.append(pts[1]);
							}
							else
							{
								if(!bError && !bSihgaText)
									dpError.draw(T("|Cannot find valid position|"), _Pt0, vecXText, vecYText,0,0,_kDeviceX);
								bError = true;
							}
						}
						else
						{									
							ptsLift.setLength(0);
							ptsLift.append(ptToCheck); 								
							ptsLift.append(ptToCheck2);
							ptsLift = Line(ptCOG, vecSearchDir).orderPoints(ptsLift);
						}
						
						if(ptsLift.length() < 2)
							return;
						ptsLift[1].vis(6);
								
						int bCalcLower = true;
						int nRunCalc;
						
						while(bCalcLower && nRunCalc < 3)
						{
							Point3d ptCrane, ptCrane2, ptStrapTop, ptStrapTop2;
							double dBeta = 15, dStrap1Length;
							Vector3d vecStrap1, vecStrap2, vecChain;
							
							bCalcLower = false;
	
							Vector3d vecEdge(ptsLift[1] - ptsLift[0]); 
							double dInter = 0.5 * vecEdge.length();
							vecEdge.normalize();
							if(vecEdge.dotProduct(ptCOG - ptsLift[0]) < 0)
								vecEdge *= -1;
							Vector3d vecPPUp = vecEdge .crossProduct(vecZ);
							if(vecPPUp.dotProduct(vZW) < 0)
								vecPPUp *= -1;
							double dToCOG = vecSearchDir.dotProduct(ptCOG - ptsLift[0]);
							dToCOG = dToCOG / cos(vecEdge.angleTo(vecSearchDir));										
							double dRise = 1;																	
													
							for(int r=0; r < 2; r++)
							{
								for(int i=0; i < 80; i++)
								{
									double dStrap1Length = (pow(dStrapLength, 2) - pow(2*dInter, 2)) / (2 * dStrapLength - 4 * dInter * cos(dBeta));
									double dStrap1Hor = cos(dBeta) * dStrap1Length;	
									double dHTop = dStrap1Length * sin(dBeta);
									double dA = atan(dHTop / (2 * dInter - dStrap1Hor));
									dA = (dA < 0) ? -1*(90 + dA) : 90 - dA;												
									double dAngleChain = 90 - ((90 - dBeta) + dA) / 2 + dA;
									double dL1 = dChainLength * cos(dAngleChain) + dStrap1Hor;		
									double dHTotal = dChainLength * sin(dAngleChain) + dHTop;
									double dAnglePlumb = vZW.angleTo(vecEdge);
									double dL2 = dHTotal / tan(dAnglePlumb);
									dL2 = (dAnglePlumb > 90 + dEps) ? dL2 : - dL2;
									double dL0 = dL1 + dL2;
														
									if(dL0 <= dToCOG + U(0.05))
									{	
										ptCrane = ptsLift[0] + vecEdge * dL1 + vecPPUp * dHTotal; 
										ptStrapTop = ptsLift[0] + vecEdge * dStrap1Hor + vecPPUp * dHTop;
										vecStrap1 = (ptStrapTop - ptsLift[0]); vecStrap1.normalize(); 
										vecStrap2 = (ptStrapTop - ptsLift[1]); vecStrap2.normalize(); 
										vecChain = (ptCrane - ptStrapTop); vecChain.normalize();
											
										break;
									}
									dBeta += dRise;										
								}	
								if(r ==0)
									dBeta -= 1;
								dRise *= 0.05;
							}								
	
							ptStrapTop2 = ptStrapTop + vecSearchDir * 2 * abs(vecSearchDir.dotProduct(ptCOG - ptStrapTop));
							vecSearchDir *= -1;
							vecStrap1 = vecStrap1.rotateBy(180, vZW);	
							vecStrap2 = vecStrap2.rotateBy(180, vZW);	
							vecChain = vecChain.rotateBy(180, vZW);
							
							{ 
								Vector3d vecPerp = vecChain.crossProduct(vecZ);
								Point3d pts[] = ppManual.intersectPoints(Plane(ptStrapTop2, vecPerp), true, false);
								if(pts.length() > 0)
								{
									pts = lnZDown.orderPoints(pts);
									ptStrapTop2 = pts[0] + vecChain * U(300);
								}											
							}
											
							int nRun;
							double dPrevious;
							while(ptsLift.length() < 4 && nRun < 10)
							{
								Vector3d vecStrapPerp1 = vecStrap1.crossProduct(vecZ), vecStrapPerp2 = vecStrap2.crossProduct(vecZ);
								Point3d ptsS1[] = ppManual.intersectPoints(Plane(ptStrapTop2, vecStrapPerp1), true, false);
								double dToTop1, dToTop2;
										
								if(ptsS1.length() > 0)
								{
									ptsS1 = lnZDown.orderPoints(ptsS1);
									ptsS1[0] = pnMid.closestPointTo(ptsS1[0]);
									dToTop1 = (ptStrapTop2 - ptsS1[0]).length();
											
									Point3d ptsS2[] =ppManual.intersectPoints(Plane(ptStrapTop2, vecStrapPerp2), true, false);
									if(ptsS2.length() > 0)
									{
										ptsS2 = lnZDown.orderPoints(ptsS2);
										ptsS1[0] = pnMid.closestPointTo(ptsS1[0]);
										dToTop2 = (ptStrapTop2 - ptsS2[0]).length();	
												
										if(abs(dStrapLength - dToTop1 - dToTop2) < U(1))
										{
											ptCrane2 = ptStrapTop2 + vecChain * dChainLength;
											double dHCrane = vZW.dotProduct(ptCrane2 - ptCrane);
	
											if(abs(dHCrane) < U(1) || dHCrane > 0)
											{
												ptsLift.append(ptsS1[0]);
												ptsLift.append(ptsS2[0]);	
												ptCrane = Plane(ptCOG, vecSearchDir).closestPointTo(ptCrane);
												break;
											}
											else
											{
												ptsLift.setLength(0);
												ptsLift.append(ptsS1[0]);
												ptsLift.append(ptsS2[0]);	
												bCalcLower = true;
												nRunCalc++;
												break;
											}
										}
									}
								}
	
								if(dPrevious == 0)
								{
									dPrevious = dToTop1 + dToTop2;
									ptStrapTop2 += (dPrevious - dStrapLength < 0) ?  vecChain * U(100) : -vecChain * U(100);
								}
								else
								{
									double dNow = dToTop1 + dToTop2;
									double dDiff = dNow- dPrevious;
									double dDist = dStrapLength - dNow;
									ptStrapTop2 += vecChain * dDist / dDiff * U(100);
								}												
								nRun++;
							}	
							
							if(ptsLift.length() == 4)
							{		
								vecLiftDevices.setLength(0);
								for(int i= 0; i < 4; i++)
								{
									Point3d pt = ptsLift[i] + vZW * U(0.5);
									Vector3d vec(pt - ppManual.closestPointTo(pt));
									vec.normalize(); 
									vecLiftDevices.append(-vec);									
								}	
								
								plsLifting.setLength(0);
								plsLifting.append(PLine(ptsLift[0], ptStrapTop));
								plsLifting.append(PLine(ptsLift[1], ptStrapTop));
								plsLifting.append(PLine(ptStrapTop, ptCrane));	
								plsLifting.append(PLine(ptsLift[2], ptStrapTop2));
								plsLifting.append(PLine(ptsLift[3], ptStrapTop2));
								plsLifting.append(PLine(ptStrapTop2, ptCrane));
							}
						}
					// Create odd result. The custumer has to change it to vailid result
						if(ptsLift.length() < nNumDevices || ptsLift.length() != vecLiftDevices.length())
						{
							Vector3d vecPerp = vZW.crossProduct(vecZ);
							Point3d ptsEdge[] = ppManual.intersectPoints(Plane(ptCOG, vecPerp), true, false);
							ptsEdge = lnZDown.orderPoints(ptsEdge);
							Point3d pt = ptsEdge[0];	
							double dPoints = nNumDevices * U(500);
							pt -= vecPerp * (dPoints - U(500));
							
							while(_PtG.length() < nNumDevices)
							{
								ptsLift.append(ppManual.closestPointTo(pt));
								pt += vecPerp * U(500);
								Vector3d vecEdge = ((pt + vZW *U(1)) - ppManual.closestPointTo(pt + vZW * U(1)));
								vecEdge.normalize();	
								vecLiftDevices.append(-vecEdge);
							}
						}
					}
					_PtG = ptsLift;	
					ptsLiftDevices.setLength(0);
					ptsLiftTemps = _PtG;			
		
					if(bIsFrontBack)
					{
						vecLiftDevices.setLength(0);
						Vector3d vecDir = (nLiftDirection == 2)? - vecZ : vecZ;
						for(int i=0; i < ptsLift.length(); i++)
							vecLiftDevices.append(vecDir);
					}
											
					Map map;
					for(int i=0; i < ptsLift.length(); i++)
					{
						map.appendPoint3d("ptLift", ptsLift[i]);	
						map.appendVector3d("vecLift", vecLiftDevices[i]);				
					}			
					_Map.setMap("LiftDevices", map);	
			}
		}
				
		if(ptsLiftTemps.length() == nNumDevices)
		{
			ptsLiftDevices = ptsLiftTemps;
			
			if(bIsFrontBack)
			{
				vecLiftDevices.setLength(0);
				int nSign = (nLiftDirection == 2)?  1 : -1;
				ptForStrapLength -= nSign * vecZ * 0.5 * dZ;
				for(int i=0; i < ptsLiftDevices.length(); i++)
				{
					ptsLiftDevices[i] -= nSign * vecZ * 0.5 * dZ;
					vecLiftDevices.append(nSign * vecZ);	
				}
				for (int i = 0; i < plsLifting.length(); i++)
				{
					plsLifting[i].transformBy( - nSign * vecZ * 0.5 * dZ);
				}
			}
		}	
	}
	
	if(ptsLiftDevices.length() != vecLiftDevices.length() || ptsLiftDevices.length() != nNumDevices)
	{
		if(!bError && !bSihgaText)
			dpError.draw(T("|Cannot find valid position|"), _Pt0, vecXText, vecYText,0,0,_kDeviceX);
		bError = true;
	}
	
	Display dpTxt(253);	
	dpTxt.showInDxa(true);// HSB-22999
	String sStrapLs[0];
	Point3d ptStrapLs[0];
	
	//Create PLines for construction else than ChainStrap combination
	if(!(bHasPoints && !bManualInput) &&  !bSingleMode)
	{
		if(nAssociation == 1 && ptsLiftDevices.length() > 0 && plsLifting.length() < 1)
		{
			if(!(nLiftingType == 1 && nNumDevices == 4))
			{
				plsLifting.setLength(0);
				Point3d ptsLift[0]; ptsLift = ptsLiftDevices;
				ptsLift = Line(ptsLift[0], vecForStrapLength).orderPoints(ptsLift);
				
				// Longest strap should be given strap length
				double dDist;
				int nPt;
				for(int i=0; i < ptsLift.length();i++)
				{
					double d = vZW.dotProduct(ptForStrapLength - ptsLift[i]);
					if(d > dDist)
					{
						nPt = i;
						dDist = d;
					}
				}			
				double dRequiredDist = abs(vecForStrapLength.dotProduct(ptsLift[nPt] - ptForStrapLength));
				if(nNumDevices == 4)
					dRequiredDist = abs(dRequiredDist - 0.5 * dTraverseLength);
				dRequiredDist = pow((pow(dStrapLength,2) - pow(dRequiredDist,2)), 0.5);
				ptForStrapLength += vZW * (dRequiredDist - vZW.dotProduct(ptForStrapLength - ptsLift[nPt]));
				
				for(int i=0; i < ptsLift.length(); i++)
				{
					Point3d pt = 	ptForStrapLength;
					double dStrap = dStrap2dLength;
	
					if(nNumDevices == 4)
					{
						pt += (i < 2) ? - vecForStrapLength * 0.5 * dTraverseLength : vecForStrapLength * 0.5 * dTraverseLength;
						dStrap = dStrapTraverseLength;
					}
					plsLifting.append(PLine(ptsLift[i], pt));
					
					if(i==3)
					{
						plsLifting.append(PLine(pt, pt - vecForStrapLength * dTraverseLength));
					}			
				}
			}	
		}		
	}
	else if(!bSingleMode)
	{
		plsLifting.setLength(0);
		Map mapPLs = _Map.getMap("LiftDevices\\PLsLifting");
		for(int i=0; i < mapPLs.length(); i++)
			plsLifting.append(mapPLs.getPLine(i));
	}
	
// Trigger ManualInput
	String sTriggerManualInput =bManualInput?T("|Accept manual input|"):T("|Manual input|");
	addRecalcTrigger(_kContextRoot, sTriggerManualInput);
	if (_bOnRecalc && _kExecuteKey==sTriggerManualInput)
	{
		bManualInput = bManualInput ? false : true;
		_Map.setInt("ManualInput", bManualInput);	
		
		Map map;
		Map mapPLs;
		if(!bManualInput)
			_PtG.setLength(0);

		for(int i=0; i < ptsLiftDevices.length(); i++)
		{
			map.appendPoint3d("ptLift", ptsLiftDevices[i]);	
			map.appendVector3d("vecLift", vecLiftDevices[i]);				
		}
		for(int i=0; i < plsLifting.length(); i++)
			mapPLs.appendPLine("pl", plsLifting[i]);
		map.setMap("PLsLifting", mapPLs);

		_Map.setMap("LiftDevices", map);
		
		setExecutionLoops(2);
		return;
	}	


// Trigger AutomaticInput//region
	if(_Map.hasMap("LiftDevices") || _Map.hasInt("NumDevices"))
	{
		// Trigger SingleMode//region
		String sTriggerSingleMode = T("|Move devices individual|");
		if(!_Map.getInt("SingleMode"))
			addRecalcTrigger(_kContextRoot, sTriggerSingleMode );
		if (_bOnRecalc && _kExecuteKey==sTriggerSingleMode)
		{
			_Map.setInt("SingleMode", true);			
			setExecutionLoops(2);
			return;
		}//endregion	
		
		
		String sTriggerAutomaticInput = T("|Reset manual input|");
		addRecalcTrigger(_kContextRoot, sTriggerAutomaticInput );
		if (_bOnRecalc && _kExecuteKey==sTriggerAutomaticInput)
		{
			_PtG.setLength(0);
			_Map.removeAt("VecZW", true);
			_Map.removeAt("ManualInput", true);
			_Map.removeAt("LiftDevices", true);	
			_Map.removeAt("SingleMode", true);
			_Map.removeAt("CheckedWithSihga", true);
			_Map.removeAt("NumDevices", true);
			_Map.removeAt("TxtShorterStraps", true);
			_Map.removeAt("SetFloorDevices", true);
			_Map.removeAt("CheckWallLength", true);
			
			setExecutionLoops(2);
			return;
		}//endregion		
		
	// Trigger PositionCheckedWithSihga//region
		String sTriggerPositionCheckedWithSihga = T("|Result checked with Sihga|");
		if(!_Map.getInt("CheckedWithSihga"))
			addRecalcTrigger(_kContextRoot, sTriggerPositionCheckedWithSihga );
		if (_bOnRecalc && _kExecuteKey==sTriggerPositionCheckedWithSihga)
		{
			_Map.setInt("CheckedWithSihga", true);
			setExecutionLoops(2);
			return;
		}//endregion		
	}
	//else
	{
		// Trigger SetNumDevices//region
		String sTriggerSetNumDevices = T("|Set number of devices|");
		addRecalcTrigger(_kContextRoot, sTriggerSetNumDevices );
		if (_bOnRecalc && _kExecuteKey==sTriggerSetNumDevices)
		{
			int bValid ;
			int nNumDevices = 1;
			while(!bValid)
			{
				String sNumDevices = getString(T("|Set number of 1-4|"));
				nNumDevices = sNumDevices.atoi();
				if(nNumDevices < 1 || nNumDevices > 4)
				{
					reportMessage("\n"+scriptName()+" "+T("|Number of devices must be 1-4|"));
				}
				if(nAssociation == 1 && nNumDevices == 3)
				{
					reportMessage("\n"+scriptName()+" "+T("|3 devices only allowed for roof/ floor panels|"));
				}
				else if((nAssociation != 1 || (nLiftDirection == 0 || nLiftDirection == 3)) && nNumDevices == 1)
				{
					reportMessage("\n"+scriptName()+" "+T("|1 device only allowed for wall panels with lift direction front/ back|"));
				}
				else
				{
					nNumDevices = sNumDevices.atoi();
					bValid = true;
				}
			}
			
			_Map.setInt("NumDevices", nNumDevices);
			
			setExecutionLoops(2);
			return;
		}//endregion	
	}

	
	// Trigger ChangeSide//region
	String sTriggerChangeSide = T("|Change Side|");
	addRecalcTrigger(_kContextRoot, sTriggerChangeSide );
	if (_bOnRecalc && _kExecuteKey==sTriggerChangeSide)
	{
		if(nAssociation == 2)
			_Map.setVector3d("VecZW", - vZW);
		else
		{
			Point3d pt = getPoint(T("|Select point at edge|"));
			PlaneProfile pp = bdSip.getSlice(Plane(ptCen, vecZ));
			pt = pp.closestPointTo(pt);
			Vector3d vec(pt - ptCOG);
			vec.normalize();			
//			pt += vec * dEps;
//			Vector3d vecEdgePerp(pt - pp.closestPointTo(pt));
//			vecEdgePerp.normalize();
			Vector3d vecZW;
			
			double d1 = vec.angleTo(vecX); if(d1 > 90 + dEps) d1 = abs(180 - d1);
			double d2 = vec.angleTo(vecY); if(d2 > 90 + dEps) d2 = abs(180 - d2);
			if(d1 < d2)
			{
				if(vec.dotProduct(vecX) > 0)
					vecZW = vecX;
				else
					vecZW = -vecX;					
			}
			else
			{
				if(vec.dotProduct(vecY) > 0)
					vecZW = vecY;
				else
					vecZW = -vecY;					
			}
			_Map.setVector3d("VecZW", vecZW);
		}
			
		_Map.setInt("ManualInput", false);	
		_Map.removeAt("LiftDevices", true);	
		_PtG.setLength(0);
			
		setExecutionLoops(2);
		return;
	}//endregion	

	
	// Trigger 2ndLiftDirection//region
	String sTrigger2ndLiftDirection = T("|Add 2nd lifting direction|");
	addRecalcTrigger(_kContext, sTrigger2ndLiftDirection );
	if ( _kExecuteKey==sTrigger2ndLiftDirection || _Map.hasInt("Add 2nd LiftDirectionOnce"))
	{
		_Map.removeAt("Add 2nd LiftDirectionOnce", true);
		int nAss = (nAssociation == 1) ? 2 : 1;
		int nDir = 0;
			
		// create TSL
		TslInst tslNew;
		int bForceModelSpace = true;	
		String sCatalogName =sLastInserted;
		String sExecuteKey;
		String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
		GenBeam gbsTsl[] = {sip};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};
		double dProps[]={dStrap2dLength, dTraverseLength, dStrapTraverseLength, 
			dChainLength, dStrapChainLength,dAllowedUneveness};
		String sProps[]={sAssociation, sLiftDirection, sStraightenUp, sLiftingType, sShowStraps};
		Map mapTsl;	
		mapTsl.setInt("nAss", nAss);
		mapTsl.setInt("nDir", nDir);

		if(_Map.hasInt("SetFloorDevices"))
			mapTsl.setInt("SetFloorDevices", 3);
		if(_Map.getDouble("CheckWallLength") > dEps)
			mapTsl.setDouble("CheckWallLength", _Map.getDouble("CheckWallLength"));


		tslNew.dbCreate(sScriptName , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);					
		//tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
	}//endregion	
	
// Trigger AlignmentFrontBack
	int bAlignmentFrontBack = _Map.getInt("AlignmentFrontBack");
	String sTriggerAlignmentFrontBack =bAlignmentFrontBack?T("|Align devices at top|"):T("|Align devices horizontal|");
	addRecalcTrigger(_kContext, sTriggerAlignmentFrontBack);
	if (_bOnRecalc && _kExecuteKey==sTriggerAlignmentFrontBack)
	{
		bAlignmentFrontBack = bAlignmentFrontBack ? false : true;
		_Map.setInt("AlignmentFrontBack", bAlignmentFrontBack);		
		setExecutionLoops(2);
		return;
	}		

	for(int i=0; i < ptsLiftDevices.length()-1; i++)
	{
		if((ptsLiftDevices[i] - ptsLiftDevices[i+1]).length() < 2* dEdgeOffset)
		{ 
			if(!bError )
				dpError.draw(T("|Interdistance of Picks below minimum|"), _Pt0, vecXText, vecYText,0,0,_kDeviceX);
			bError = true;
		}
	}
	
	if(!bSihgaText && !bError && (bManualInput || bHasPoints))
	{		
		dpError.draw(T("|Manual input. Check position with Sihga|"), _Pt0, vecXText, vecYText,0,0, _kDeviceX);
	}
	
	if(bError && ptsLiftDevices.length() < nNumDevices)
		_PtG.setLength(0);
	
	Map mapRequests;
	if(ptsLiftDevices.length() == nNumDevices && plsLifting.length() > 0 && nNumDevices > 1)
	{
		Vector3d vecXT=(sip.dL()<sip.dW())?vecY:vecX;
		Vector3d vecYT=(sip.dL()<sip.dW())?vecX:vecY;
		Map mapRequestTxt;	
		
		if(bError && !bSihgaText)
		{
			String sTxtLine1(T("|Invalid result. Check with Sihga|"));
			
			// draw in element view and publish dimrequest text	
			//mapRequestTxt.setInt("deviceMode", _kDevice);		
			//mapRequestTxt.setString("dimStyle", sDimStyle);	
			mapRequestTxt.setInt("Color", 1);
			mapRequestTxt.setVector3d("AllowedView", vecZ);				
			mapRequestTxt.setPoint3d("ptLocation",ptCen);		
			mapRequestTxt.setVector3d("vecX", vecXT);
			mapRequestTxt.setVector3d("vecY", vecYT);
			//mapRequestTxt.setDouble("textHeight", dTxtH);
			mapRequestTxt.setDouble("dXFlag", 0);
			mapRequestTxt.setDouble("dYFlag", 0);			
			mapRequestTxt.setString("text", sTxtLine1);	
			mapRequests.appendMap("DimRequest",mapRequestTxt);
		}
		
		for(int i=0; i < ptsLiftDevices.length();i++)
		{
			String sTxtLine1 = T("|P| " + (i+1));
			mapRequestTxt.setInt("Color", 253);
			mapRequestTxt.setVector3d("AllowedView", vecZ);				
			mapRequestTxt.setPoint3d("ptLocation",ptsLiftDevices[i] + vecXText * U(30));		
			mapRequestTxt.setVector3d("vecX", vecXT);
			mapRequestTxt.setVector3d("vecY", vecYT);
			//mapRequestTxt.setDouble("textHeight", dTxtH);
			mapRequestTxt.setDouble("dXFlag", 1);
			mapRequestTxt.setDouble("dYFlag", 0);			
			mapRequestTxt.setString("text", sTxtLine1);	
			mapRequests.appendMap("DimRequest",mapRequestTxt);				
		}
		
//		_Map.setMap("DimRequest[]", mapRequests);
	}
	
	//if(!bError || bHasPoints || bManualInput)
	{
		Plane pnMid(ptCen, vecZ);
		PlaneProfile ppDevice(pnMid);
		ppDevice.unionWith(bdSip.extractContactFaceInPlane(Plane(ptCen + vecZ * 0.5 * (dZ - dEps), vecZ), dEps));	
		ppDevice.unionWith(bdSip.extractContactFaceInPlane(Plane(ptCen - vecZ * 0.5 * (dZ - dEps), -vecZ), dEps));
		Map mapLiftPts;
//		double dDrillDepth = (dZ < U(90)) ? dZ : U(90);
		ppDevice.vis(2);
		for(int i=0; i < ptsLiftDevices.length(); i++)
		{
			if(ppDevice.pointInProfile(ptsLiftDevices[i]) == _kPointInProfile)
			{
				Drill dr(ptsLiftDevices[i] - vecLiftDevices[i] * (dDrillDepth + U(1)), ptsLiftDevices[i] - vecLiftDevices[i] * U(1), U(50));
				
			// HSB-19795 add mapx data to sheet
			 	Map mapxInfo;
				mapxInfo.setInt("Quantity", nNumDevices);
				mapxInfo.setString("Name", "SihgaPick");
				mapxInfo.setDouble("Diameter", dDrillDiamPick);
				mapxInfo.setDouble("Depth", dDrillDepth);
				mapxInfo.setString("Assotiation", sAssociation);
				
				dr.setSubMapX("SihgaPick", mapxInfo);
				sip.addTool(dr);
				
				// store the drill to remove it later from the body
				dr.cuttingBody().vis(3);
				
			}
			
//			Drill dr(ptsLiftDevices[i] - vecLiftDevices[i] *U(1), ptsLiftDevices[i] + vecLiftDevices[i] * U(72), U(25.25));
			Drill dr(ptsLiftDevices[i] - vecLiftDevices[i] *U(1), ptsLiftDevices[i] + vecLiftDevices[i] * dDrillDepth, U(25.25));
			dr.cuttingBody().vis(3);
			
		// HSB-19795 add mapx data to sheet
			Map mapxInfo;
			mapxInfo.setInt("Quantity", nNumDevices);
			mapxInfo.setString("Name", "SihgaPick");
			mapxInfo.setDouble("Diameter", dDrillDiamPick);
			mapxInfo.setDouble("Depth", dDrillDepth);
			mapxInfo.setString("Assotiation", sAssociation);
			
			dr.setSubMapX("SihgaPick", mapxInfo);
			sip.addTool(dr);

			mapLiftPts.appendPoint3d("ptLift", ptsLiftDevices[i], _kAbsolute);
		}
		_Map.setMap("LiftPts", mapLiftPts);

		// draw Sihga Pick lifting device
		Display dpDevice(253);
		dpDevice.showInDxa(true);// HSB-22999
		for(int i=0; i < ptsLiftDevices.length(); i++)
		{
//			Body bdModelLift;			
//			bdModelLift = Body (ptsLiftDevices[i], ptsLiftDevices[i] + vecLiftDevices[i] * U(68), U(25));
//			bdModelLift = bdModelLift + Body (ptsLiftDevices[i], ptsLiftDevices[i] - vecLiftDevices[i] * U(26), U(47));
//			bdModelLift = bdModelLift + Body (ptsLiftDevices[i] - vecLiftDevices[i] * U(26), ptsLiftDevices[i] - vecLiftDevices[i] * U(45), U(33));
//			bdModelLift = bdModelLift + Body (ptsLiftDevices[i] - vecLiftDevices[i] * U(45), ptsLiftDevices[i] - vecLiftDevices[i] * U(82), U(16));
//			dpDevice.color(253);
//			dpDevice.draw(bdModelLift);
			Map mInDrawDevice;
			drawDeviceBody(sType, ptsLiftDevices[i], vecLiftDevices[i], mInDrawDevice);
		}		
		
		if(nNumDevices > 1)
		{
			String sStrap = T("|Strap| ");
			String sChain = T("|Chain| ");
			String sTraverse = T("|Traverse| ");
			String sLength = T("|L=| ");
			String sMap = "ChainLength";
			double dStrapL;
			int n = 1;
			
			_Map.setString("Qty", nNumDevices);
			
			for(int i=0; i < plsLifting.length(); i++)
			{	
				if(nShowStraps)
				{
					Point3d pt=plsLifting[i].ptMid();
					Point3d ptCOGT=ptCOG+vZW*vZW.dotProduct(pt-ptCOG);
					Vector3d vec(pt-ptCOGT);
					vec.normalize();
					if(nAssociation == 1)
					{
						vec=Vector3d(pt+vec*U(0.5)-plsLifting[i].closestPointTo(pt+vec*U(0.5)));
						vec.normalize();							
					}
					
					String sTxt = T("|L=| ") + round(plsLifting[i].length());
					Vector3d vecPerp=vec.crossProduct(vecZ);
					if(nAssociation==2)
					{
						Vector3d v=vec;
						vec=vecPerp;
						vecPerp=-v;
					}
					
					dpTxt.draw(sTxt,pt+vec*U(50),vecPerp,vec,0,0);
					dpDevice.draw(plsLifting[i]);
				}
				
				// Length of straps/ chains added to _Map. Can be read with e.g. viewTag Tsl
				if(nAssociation == 2 || plsLifting.length() == 2)
				{
					_Map.setString(sMap +  (i+1), sChain +  (i+1) + sLength + plsLifting[i].length());
				}
				else if(plsLifting.length() > 2)
				{
					if(nLiftingType == 0)
					{
						if(i < plsLifting.length() -1)
							_Map.setString(sMap + (i+1), sChain +  (i+1) + sLength + plsLifting[i].length());	
						else
							_Map.setString(sMap +  (i+1), sTraverse +  (i+1) + sLength + plsLifting[i].length());	
					}
					else if(plsLifting.length() == 6)
					{
						dStrapL += plsLifting[i].length();
						if(i == 2)
						{
							_Map.setString(sMap + n, sStrap + "1/2" + sLength + (dStrapL - plsLifting[i].length()));	
							_Map.setString(sMap + (n+1), sChain + "1" + sLength + plsLifting[i].length());	
							n+=2;
							dStrapL = 0;
						}
						if(i == 5)
						{
							_Map.setString(sMap + n, sStrap + "3/4" + sLength + (dStrapL - plsLifting[i].length()));	
							_Map.setString(sMap + (n+1), sChain + "2" + sLength + plsLifting[i].length());	
						}
					}
				}
			}
		}
	}
//	for (int ii=0;ii<ptsLiftDevices.length();ii++) 
//	{ 
//		ptsLiftDevices[ii].vis(1);
//	}//next ii
	
// HSB-16519: Publish mapRequest with dimension points for all ptsLiftDevices
	if(ptsLiftDevices.length()>0)
	{ 
		Map mapRequestDim;
	// HSB-16519: dimension in the direction of the two points
	// points located at the edge
//		mapRequestDim.setString("DimRequestPoint","DimRequestPoint");
		mapRequestDim.setString("DimRequestChain","DimRequestChain");
		mapRequestDim.setDouble("MinimumOffsetFromDimLine",500);
		mapRequestDim.setString("stereotype", "hsbCLT-SihgaPick");
		mapRequestDim.setInt("setIsChainDimReferencePoint",true);
		// Z
		mapRequestDim.setPoint3d("ptRef",ptsLiftDevices[0]);
		mapRequestDim.setPoint3dArray("Node[]",ptsLiftDevices);
		
	// aligned dimensions with their distribution vector
		mapRequestDim.setVector3d("AllowedView",vecZ);
		mapRequestDim.setInt("AlsoReverseDirection",false);
		Vector3d vecAligned=ptsLiftDevices[1]-ptsLiftDevices[0];vecAligned.normalize();
		Vector3d vecNormalDim=vecZ.crossProduct(vecAligned);vecNormalDim.normalize();
		mapRequestDim.setVector3d("vecDimLineDir", vecAligned);
		mapRequestDim.setVector3d("vecPerpDimLineDir", vecNormalDim);
		mapRequests.appendMap("DimRequest",mapRequestDim);
		
		mapRequestDim.setVector3d("AllowedView",-vecZ);
		mapRequestDim.setVector3d("vecPerpDimLineDir", -vecNormalDim);
		mapRequests.appendMap("DimRequest",mapRequestDim);
	}
	
// HSB-16519
	if(mapRequests.length()>0)
		_Map.setMap("DimRequest[]", mapRequests);
	else
		_Map.removeAt("DimRequest[]",true);

// HSB-19795 add mapx data to sheet
	Map mapxInfo;
	mapxInfo.setInt("Quantity", nNumDevices);
	mapxInfo.setString("Name", "SihgaPick");
	mapxInfo.setDouble("Diameter", dDrillDiamPick);
	mapxInfo.setDouble("Depth", dDrillDepth);
	mapxInfo.setString("Assotiation", sAssociation);
	
	sip.setSubMapX("SihgaPick", mapxInfo);
	









#End
#BeginThumbnail
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
?!8_M31HDLD:X,I50N]N>6(`R>,GFLZB@`HHHI@?_V0``


















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="Resource[]">
    <lst nm="IMAGE[]" />
  </lst>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="1882" />
        <int nm="BreakPoint" vl="1637" />
        <int nm="BreakPoint" vl="250" />
        <int nm="BreakPoint" vl="323" />
        <int nm="BreakPoint" vl="4310" />
        <int nm="BreakPoint" vl="4308" />
        <int nm="BreakPoint" vl="4315" />
        <int nm="BreakPoint" vl="282" />
        <int nm="BreakPoint" vl="283" />
        <int nm="BreakPoint" vl="274" />
        <int nm="BreakPoint" vl="356" />
        <int nm="BreakPoint" vl="497" />
        <int nm="BreakPoint" vl="1151" />
        <int nm="BreakPoint" vl="4334" />
        <int nm="BreakPoint" vl="4340" />
        <int nm="BreakPoint" vl="2889" />
        <int nm="BreakPoint" vl="3598" />
        <int nm="BreakPoint" vl="3594" />
        <int nm="BreakPoint" vl="3948" />
        <int nm="BreakPoint" vl="3970" />
        <int nm="BreakPoint" vl="3418" />
        <int nm="BreakPoint" vl="3419" />
        <int nm="BreakPoint" vl="3236" />
        <int nm="BreakPoint" vl="3314" />
        <int nm="BreakPoint" vl="3357" />
        <int nm="BreakPoint" vl="1466" />
        <int nm="BreakPoint" vl="391" />
        <int nm="BreakPoint" vl="419" />
        <int nm="BreakPoint" vl="261" />
        <int nm="BreakPoint" vl="364" />
        <int nm="BreakPoint" vl="365" />
        <int nm="BreakPoint" vl="404" />
        <int nm="BreakPoint" vl="412" />
        <int nm="BreakPoint" vl="500" />
        <int nm="BreakPoint" vl="571" />
        <int nm="BreakPoint" vl="1468" />
        <int nm="BreakPoint" vl="1510" />
        <int nm="BreakPoint" vl="555" />
        <int nm="BreakPoint" vl="1516" />
        <int nm="BreakPoint" vl="551" />
        <int nm="BreakPoint" vl="1476" />
        <int nm="BreakPoint" vl="1469" />
        <int nm="BreakPoint" vl="1404" />
        <int nm="BreakPoint" vl="1403" />
        <int nm="BreakPoint" vl="1386" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24243: Fix edge offset for SihgaPickMax" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="8/12/2025 2:56:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="20250424: Fix when getting nr layers" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="4/24/2025 9:12:27 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22295: Pass on ptCog as argument at calcLiftingParameters" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="2/17/2025 3:18:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22295: Fix when finding the configuration for straighten up at Sihga max" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="12/13/2024 3:02:30 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22999: save graphics in file for render in hsbView and make" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="12/5/2024 8:55:22 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22295: Add property &quot;Allowed uneveness&quot; to control horizontal uneveness of lifting points" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="9/6/2024 2:10:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22295: Fix when getting dThicknessWallMin" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="8/29/2024 12:41:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22295: Add property type, support SihgaPickMax from the xml definition" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="8/15/2024 11:38:47 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20771 bugfix range error" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="12/4/2023 9:15:11 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19789 add mapx data from hsbCLT-SihgaPick to single drill" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="10/10/2023 10:05:32 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19789 add mapx data from hsbCLT-SihgaPick to Panel" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="8/10/2023 11:48:19 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16519: Publish only dimension aligned according to the edge where the sihga points are" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="3/8/2023 3:39:32 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16519: Publish dimRequest map for dimensions" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="1/10/2023 4:34:50 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End