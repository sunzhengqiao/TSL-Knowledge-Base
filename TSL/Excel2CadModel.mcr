#Version 8
#BeginDescription
#Versions:
Version 1.4 11.11.2025 HSB-24891: Fix when running hsbExcelToMap , Author: Marsel Nakuci
Version 1.3 12.12.2023 HSB-20437 bugfix beam color , Author Thorsten Huck
Version 1.2 22.07.2021    HSB-11827 debug message removed , Author Thorsten Huck
Version 1.1 28.05.2021    HSB-11827    bugfix assigning sublabel , Author Thorsten Huck
Version 1.0 25.05.2021    HSB-11872    initial version , Author Thorsten Huck

// This tsl creates beams, sheets, panels and/or blockreferences if from an excel list if the required data is sufficently defined in the corresponding sheets.
// The excel worksheets must be named 'Beam', 'Sheet', 'Panel' and 'BlockRef' for the corresponding types. 
// They must contain columns for length, width and height for any genbeam and a block or block path name for block references.
// All other properties / values are optional




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.4 11.11.2025 HSB-24891: Fix when running hsbExcelToMap , Author: Marsel Nakuci
// #Versions:
// 1.3 12.12.2023 HSB-20437 bugfix beam color , Author Thorsten Huck
// 1.2 22.07.2021 HSB-11827 debug message removed , Author Thorsten Huck
// 1.1 28.05.2021 HSB-11827 bugfix assigning sublabel , Author Thorsten Huck
// 1.0 25.05.2021 HSB-11872 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select import file and press enter.
/// </insert>

// <summary Lang=en>
// This tsl creates beams, sheets, panels and/or blockreferences if from an excel list if the required data is sufficently defined in the corresponding sheets.
// The excel worksheets must be named 'Beam', 'Sheet', 'Panel' and 'BlockRef' for the corresponding types. 
// They must contain columns for length, width and height for any genbeam and a block or block path name for block references.
// All other properties / values are optional.
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Excel2CadModel")) TSLCONTENT
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
	
	
	//region Function GetHsbVersionNumber
	// returns the main version number 27,28, 29..., 0 if it fails
	int GetHsbVersionNumber()
	{ 		
		String oeVersion = hsbOEVersion().makeUpper();
	
		int hsbVersion;

		int n1 = oeVersion.find("(",0, false)+1;
		int n2 = oeVersion.find(")", n1+1, false)-1;
		String mid = oeVersion.mid(n1, n2 - n1+1);
		mid.replace("BUILD ", "");
		String tokens[] = mid.tokenize(",");
		if (tokens.length()>0)
			hsbVersion = tokens.first().atoi();
	
		return hsbVersion;
	}//endregion	
	
	int nVersionNumber = GetHsbVersionNumber();
	String strAssemblyPath = _kPathHsbInstall + "\\Utilities\\hsbExcelToMap\\hsbExcelToMap"+ (nVersionNumber>=28?".dll":".exe");
	String strType = "hsbCad.hsbExcelToMap.HsbCadIO";
	String strFunction = "ExcelToMap";
	Map mapIn;	
//end Constants//endregion


//region Properties
	String sLastPathName=T("|Path|");	
	PropString sLastPath(nStringIndex++, "", sLastPathName);	
	sLastPath.setDescription(T("|Defines the last used path|"));
	sLastPath.setCategory(category);	
//End Properties//endregion 


//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
		setPropValuesFromCatalog(sLastInserted);
		
		mapIn.setString("LastAccessedFilePath", sLastPath);
		_Map = callDotNetFunction2( strAssemblyPath, strType, strFunction , mapIn);
		String filepath = _Map.getString("LastAccessedFilePath");
		if (filepath != "")
		{ 
			sLastPath.set(filepath);
			setCatalogFromPropValues(sLastInserted);	
		}
		return;
	}	
// end on insert	__________________//endregion


	Point3d ptRef = _PtW;
	String styleNames[] = SipStyle().getAllEntryNames();

//region Creation
	for (int i = 0; i < _Map.length(); i++)
	{	
		String k = _Map.keyAt(i);
		if (k == "Sheets")
		{ 
			Map mapXLSheets = _Map.getMap(i);
			for (int j = 0; j < mapXLSheets.length(); j++)
			{
				Map mapXLSheet = mapXLSheets.getMap(j);
				
				k = mapXLSheet.getMapKey();
				int bIsBeam = k.find("Beam", 0, false) >- 1;
				int bIsSheet = k.find("Sheet", 0, false) >- 1;
				int bIsSip = k.find("Sip", 0, false) >- 1 || k.find("Panel", 0, false) >- 1;
				int bIsBlock = k.find("BlockRef", 0, false) >- 1;
				
				int bIsGenBeam = bIsBeam || bIsSheet || bIsSip;
				
				for (int q = 0; q < mapXLSheet.length(); q++)
				{ 
					Entity ent;
					Map m = mapXLSheet.getMap(q);
					
					double dX, dY, dZ, dXFlag=1, dYFlag=1, dZFlag=1;
					String material, label, subLabel, information, name, grade, extrProfile ,groupName ;
					int color, qty=1,beamtype;
				
					Point3d ptOrg = ptRef;
					int bMove=true; 
					Vector3d vecX,vecY,vecZ;
				
				// Any Class
					groupName = m.getString("groupName");
					k = "ptOrg.x";	if (m.hasDouble(k))	{ptOrg.setX(m.getDouble(k)); bMove=false;}
					k = "ptOrg.y";	if (m.hasDouble(k))	{ptOrg.setY(m.getDouble(k)); bMove=false;}
					k = "ptOrg.z";	if (m.hasDouble(k))	{ptOrg.setZ(m.getDouble(k)); bMove=false;}
					
					k = "vecX.x";	if (m.hasDouble(k))	vecX.setX(m.getDouble(k));
					k = "vecX.y";	if (m.hasDouble(k))	vecX.setY(m.getDouble(k));
					k = "vecX.z";	if (m.hasDouble(k))	vecX.setZ(m.getDouble(k));
					
					k = "vecY.x";	if (m.hasDouble(k))	vecY.setX(m.getDouble(k));
					k = "vecY.y";	if (m.hasDouble(k))	vecY.setY(m.getDouble(k));
					k = "vecY.z";	if (m.hasDouble(k))	vecY.setZ(m.getDouble(k));
					
					k = "vecZ.x";	if (m.hasDouble(k))	vecZ.setX(m.getDouble(k));
					k = "vecZ.y";	if (m.hasDouble(k))	vecZ.setY(m.getDouble(k));
					k = "vecZ.z";	if (m.hasDouble(k))	vecZ.setZ(m.getDouble(k));
					
					if (vecX.bIsZeroLength() || vecY.bIsZeroLength() || vecZ.bIsZeroLength())
					{
						vecX = _XW;
						vecY = _YW;
						vecZ = _ZW;
					}	
					
					CoordSys cs(ptOrg, vecX, vecY, vecZ);
					
					k = "VecXflag";	if (m.hasDouble(k))	dXFlag=m.getDouble(k);
					k = "VecYflag";	if (m.hasDouble(k))	dYFlag=m.getDouble(k);
					k = "VecZflag";	if (m.hasDouble(k))	dZFlag=m.getDouble(k);
					
					k = "Color";	if (m.hasDouble(k))	color=m.getDouble(k);
					k = "Quantity";	if (m.hasDouble(k))	qty=m.getDouble(k);
					
				// GenBeam	
					if (bIsGenBeam)
					 {
					 	dX = U(m.getDouble("Length"));
					 	dY = U(m.getDouble("Width"));
					 	dZ = U(m.getDouble("Height"));
					 	if (dX < dEps || dY < dEps || dZ < dEps){continue;}// geoemetry is mandatory
					 	
					 	material = m.getString("material");
					 	label = m.getString("label");
					 	subLabel = m.getString("subLabel");
					 	information = m.getString("information");
					 	name = m.getString("name");
					 	grade = m.getString("grade");
					 	extrProfile = m.getString("extrProfile");
					 	beamtype =_BeamTypes.find(m.getString("beamtype"),0);						 	
					}	
					
				// Beam
					if (bIsBeam)
					{ 
						double dCut1N=m.getDouble("Cut1N");
						double dCut1P=m.getDouble("Cut1P");
						double dCut2N=m.getDouble("Cut2N");
						double dCut2P=m.getDouble("Cut2P");

						Beam x; 
						if (!bDebug)
						{ 
							x.dbCreate(ptOrg,vecX,vecY,vecZ,dX,dY,dZ, dXFlag, dYFlag, dZFlag);
							if (abs(dCut1N)!=0 || abs(dCut1P)!=0)
							{ 
								Point3d pt=x.ptCen() + vecX * .5 * x.dL();
								Vector3d vecCut=vecX;
								vecCut=(vecCut.rotateBy(dCut1N,vecY)).rotateBy(dCut1P,vecZ);
								Cut cut(pt,vecCut);	
								x.addToolStatic(cut,_kStretchOnInsert);
							}
							if (abs(dCut2N)!=0 || abs(dCut2P)!=0)
							{ 
								Point3d pt=x.ptCen() - vecX * .5 * x.dL();
								Vector3d vecCut=-vecX;
								vecCut=(vecCut.rotateBy(dCut2N,vecY));
								vecCut=vecCut.rotateBy(dCut2P,vecCut.crossProduct(vecY));	
								Cut cut(pt,vecCut);	
								x.addToolStatic(cut,_kStretchOnInsert);
							}						
							
							x.setLabel(label);
							x.setSubLabel(subLabel);
							x.setInformation(information);
							x.setMaterial(material);
							x.setGrade(grade);
							x.setName(name);
							
							x.setType(beamtype);
							x.setColor(color);	
							
							if (extrProfile.length()>0 && ExtrProfile().getAllEntryNames().findNoCase(extrProfile,-1)>-1)
								x.setExtrProfile(extrProfile);
								
							
							
							for (int n=1;n<qty;n++) 
							{ 
								Beam x2;
								x2=x.dbCopy();
								if (bMove)x2.transformBy(vecZ * dZ);	 
							}//next n
							ent = x;							
						}
						else
						{ 
							Body bd(ptOrg,vecX,vecY,vecZ,dX,dY,dZ, dXFlag, dYFlag, dZFlag);
							bd.vis(color);
							for (int n=1;n<qty;n++) 
							{ 
								if (bMove)bd.transformBy(vecZ * dZ);	 
								bd.vis(color);
							}//next n	
						}

						if (bMove)ptRef -= vecY * dY;

					}
						
				// Sheet
					else if (bIsSheet)
					{ 
						Sheet x; 
						if (!bDebug)
						{ 
							x.dbCreate(ptOrg,vecX,vecY,vecZ,dX,dY,dZ, dXFlag, dYFlag, dZFlag);
						
							x.setLabel(label);
							x.setSubLabel(label);
							x.setInformation(information);
							x.setMaterial(material);
							x.setGrade(grade);
							x.setName(name);
	
							x.setColor(color);	
							
							for (int n=1;n<qty;n++) 
							{ 
								Sheet x2;
								x2=x.dbCopy();
								if (bMove)x2.transformBy(vecZ * dZ);	 
							}//next n
							ent = x;							
						}
						else
						{ 
							Body bd(ptOrg,vecX,vecY,vecZ,dX,dY,dZ, dXFlag, dYFlag, dZFlag);
							bd.vis(color);
							for (int n=1;n<qty;n++) 
							{ 
								if (bMove)bd.transformBy(vecZ * dZ);	 
								bd.vis(color);
							}//next n	
						}

						if (bMove)ptRef -= vecY * dY;

					}
						
				// Sip/Panel
					else if (bIsSip)
					{ 
						Sip x;
						
						String style = m.getString("style");
						if (style.length() < 1)style = "ExcelImport";
						
						SipStyle sipStyle(style);
						double dThickness = sipStyle.dThickness();
						SipComponent sps[] = sipStyle.sipComponents();
						
					// could not find style	
						if (styleNames.find(style)<0 || sps.length()<1)
						{ 
							String _material = material.length() > 0 ? material : "Wood";
							SipComponent sps[]={ SipComponent("Comp0", _material, dZ)};
							
							sipStyle.dbCreate(dZ);
							sipStyle.setSipComponents(sps, 0);
						}
					// default thickness invalid
						else if (dZ>0 && dThickness<dEps && sps.length()>0)
						{ 
							sps.first().setDThickness(dZ);
							sipStyle.setSipComponents(sps, 0);
						}					
					// given style does not match thickness
						else if (dZ>0 && abs(dThickness-dZ)>0)
						{ 
							reportNotice(TN("|Row| ")+i+  T("\n|The thickness of the style| " + style + T(" |does not match the given thickness| (")+dZ+")"));
							continue;
						}
						
						
						
						if (!bDebug)
						{ 
							PLine pl;
							pl.createRectangle(LineSeg(ptOrg - .5 * (vecX * dX + vecY * dY), ptOrg + .5 * (vecX * dX + vecY * dY)), vecX, vecY);
							x.dbCreate(pl, style, dZFlag);
						
							x.setLabel(label);
							x.setSubLabel(label);
							x.setInformation(information);
							x.setMaterial(material);
							x.setGrade(grade);
							x.setName(name);
	
							x.setColor(color);	
							
							for (int n=1;n<qty;n++) 
							{ 
								Sip x2;
								x2=x.dbCopy();
								if (bMove)x2.transformBy(vecZ * dZ);	 
							}//next n
							ent = x;							
						}
						else
						{ 
							Body bd(ptOrg,vecX,vecY,vecZ,dX,dY,dZ, dXFlag, dYFlag, dZFlag);
							bd.vis(color);
							for (int n=1;n<qty;n++) 
							{ 
								if (bMove)bd.transformBy(vecZ * dZ);	 
								bd.vis(color);
							}//next n	
						}

						if (bMove)ptRef -= vecY * dY;

					}
						
				// BlockRef
					else if (bIsBlock)
					{ 
						String fullPath = findFile(m.getString("Name"));
						String definition = m.getString("Name");
						
					// user can specify name or full block path
						if (fullPath.length()>0)
						{ 
							int n = definition.find("\\", 0, false);
							int max;
							while(n>0 && max<20)
							{ 
								definition = definition.right(definition.length() - n-1);
								n = definition.find("\\", 0, false);
								max++;
							}
							n = definition.find(".dwg", 0, false);
							if (n>-1)
								definition = definition.left(definition.length() - 4);	
						}
						
						
					// try to import if not found	
						if (_BlockNames.findNoCase(definition,-1)<0)
						{ 
	
							fullPath = findFile(definition);
							if (fullPath.length()>0)
							{ 
								Block block(fullPath);
								LineSeg seg = block.getExtents();
							}
							else
								continue;
						}
						
						
						double dScaleX = 1,dScaleY = 1, dScaleZ = 1;
						k = "Scale.x";	if (m.hasDouble(k))	dScaleX=m.getDouble(k);
						k = "Scale.y";	if (m.hasDouble(k))	dScaleX=m.getDouble(k);
						k = "Scale.z";	if (m.hasDouble(k))	dScaleX=m.getDouble(k);
						dScaleX = dScaleX > 0 ? dScaleX : 1;
						dScaleY = dScaleY > 0 ? dScaleY : 1;
						dScaleZ = dScaleZ > 0 ? dScaleZ : 1;
						
						CoordSys csScaled(cs.ptOrg(),vecX*dScaleX,vecY*dScaleY,vecZ*dScaleZ);
						BlockRef x;
						x.dbCreate(csScaled, definition); 
						
						if (x.bIsValid())
						{ 
							ent=x;	
							for (int n=1;n<qty;n++) 
							{ 
								Entity entNew;
								entNew = x.dbCopy();
								entNew.setColor(color);
							}//next n	
						}
					}
					
				// Any
					ent.setColor(color);	
					if (groupName.length()>0)
					{ 
						Group gr(groupName);
						if (!gr.bExists())gr.dbCreate();
						gr.addEntity(ent);
					}
				}
				

				
				
				
			}// nxet j
		}
	}// next i
	
	if (!bDebug)
	{
		eraseInstance();
		return;
	}
//End Creation//endregion 


	




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
        <int nm="BreakPoint" vl="291" />
        <int nm="BreakPoint" vl="282" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24891: Fix when running hsbExcelToMap" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="11/11/2025 4:07:59 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20437 bugfix beam color" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="12/12/2023 2:04:13 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11827 debug message removed" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="7/22/2021 9:09:40 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11827 bugfix assigning sublabel" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="5/28/2021 11:37:56 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11872 initial version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="5/25/2021 12:57:43 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End