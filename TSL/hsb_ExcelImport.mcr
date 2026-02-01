#Version 8
#BeginDescription
TSL used to import beams from an Map generated from an xlsx file

Version 1.2: 
Description: Added variables Extrusion Profiles; Color; End Cuts

Version 1.3
Block References now added using dbCreate.

Version 1.4
Y and Z vectors not being normalized
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <History>//region
/// <version value="1.0" date="VARAIABLE" author="bill.malcolm@hsbcad.com"> initial </version>
/// </History>
// Version:1.2 author: bruno.bortot@hsbcad.com Description: Added variables Extrusion Profiles; Color; End Cuts

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates 
/// </summary>//endregion
PropString pLastAccessedFilePath( 1, "",  "Last File Path" );

String sCatalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( sCatalogNames.find(_kExecuteKey) != -1 )
	setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert) 
{
	int nCreateTrussLocations = true; 
	int nMetric = ( U(1,"mm") == 1.0 );
	
	if( _kExecuteKey == "" || sCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();

	String strAssemblyPath = _kPathHsbInstall + "\\Utilities\\hsbExcelToMap\\hsbExcelToMap.exe";
	String strType = "hsbCad.hsbExcelToMap.HsbCadIO";
	String strFunction = "ExcelToMap";
	Map mapIn;	
	
	mapIn.setString("LastAccessedFilePath", pLastAccessedFilePath);
	
       Map mapRet = callDotNetFunction2( strAssemblyPath, strType, strFunction , mapIn);
	
	String filepath = mapRet.getString("LastAccessedFilePath");

	if (filepath != "")
	{ 
		pLastAccessedFilePath.set(filepath);
	}

	setCatalogFromPropValues(T("_LastInserted"));

	//reportMessage("filepath " +  filepath + "\n");
	
	for (int i=0; i<mapRet.length(); i++) {
		
		String strKey = mapRet.keyAt(i);
		
		if (strKey == "Sheets")
		{ 
			Map sheetsmap = mapRet.getMap(i);
			//reportMessage("\n"+ sheetsmap.getMapKey() + "\n");
			
			for (int j=0; j<sheetsmap.length(); j++) 
			{
				Map sheetmap = sheetsmap.getMap(j);
				String sheetmapkey = sheetmap.getMapKey().makeLower();
				//reportMessage("\n"+ sheetmapkey + "\n");
				
				if (sheetmapkey.find("beam",0) !=-1 )
				{ 
					for (int k=0; k<sheetmap.length(); k++) 
					{
						String strKey = sheetmap.keyAt(k);
						Map row = sheetmap.getMap(k);
						
						// Create a beam...
						Point3d ptOrg;
						Vector3d vecX, vecY, vecZ;
						
						ptOrg.setX(row.getDouble("ptOrg.x"));
						ptOrg.setY(row.getDouble("ptOrg.y"));
						ptOrg.setZ(row.getDouble("ptOrg.z"));
						
						vecX.setX(row.getDouble("vecX.x"));
						vecX.setY(row.getDouble("vecX.y"));
						vecX.setZ(row.getDouble("vecX.z"));
						vecX.normalize();
						//reportNotice("\n V"+vecX);
						
						vecY.setX(row.getDouble("vecY.x"));
						vecY.setY(row.getDouble("vecY.y"));
						vecY.setZ(row.getDouble("vecY.z"));
						vecY.normalize();
						
						vecZ.setX(row.getDouble("vecZ.x"));
						vecZ.setY(row.getDouble("vecZ.y"));
						vecZ.setZ(row.getDouble("vecZ.z"));
						vecZ.normalize();
						
						double length = row.getDouble("length");
						double width = row.getDouble("width");
						double height = row.getDouble("height");
						
						double vecXflag = row.getDouble("VecXflag");
						double vecYflag = row.getDouble("vecYflag");
						double vecZflag = row.getDouble("vecZflag");
						String beamType = row.getString("BeamType");
						//reportNotice("\n V"+vecXflag);
	
						int hsbBeamtype = _BeamTypes.find(beamType, 0); 
						
						String label = row.getString("Label");
						String material = row.getString("Material");
						String grade = row.getString("Grade");
						String name = row.getString("Name");
						String groupname = row.getString("Group");
						
						// Added by BB as per client request 06.07.17
						int nColor=row.getDouble("Color");
						String sExtProfile=row.getString("ExtrusionProfile");
						// End aded by BB
						
						//reportMessage("\n"+ ptOrg + "\n");
						//reportMessage("\n"+ vecX + "\n");
						//reportMessage("\n"+ vecY + "\n");
						//reportMessage("\n"+ vecZ + "\n");
						
						//reportMessage("\n"+ length + ", "+ width + ", " + height + "\n");
						//reportMessage("\n"+ vecXflag + ", "+ vecYflag + ", " + vecZflag + "\n");
						
						Beam bm; 
						bm.dbCreate(ptOrg,vecX,vecY,vecZ,U(length),U(width),U(height), vecXflag, vecYflag, vecZflag);
						bm.setLabel(label);
						bm.setMaterial(material);
						bm.setGrade(grade);
						bm.setName(name);
						bm.setType(hsbBeamtype);
						
						//reportMessage("\n hsbBeamtype"+ hsbBeamtype + "\n");
						
						// Added by BB as per client request 06.07.17
						
						if(sExtProfile !="")
						{
							bm.setExtrProfile(sExtProfile);
						}
						if(nColor !=0)
						{
							bm.setColor(nColor);
						}
						// End added by BB
						
						if (groupname != "")
						{ 
							Group gr(groupname);
							gr.addEntity(bm);
						}
						
						// Added by BB as per client request 06.07.17
						// BeamCut
						double dCut1N=row.getDouble("Cut1N");
						double dCut1P=row.getDouble("Cut1P");
						Point3d ptC1(bm.ptCen() +0.5*bm.dL()*vecX/*+0.5*bm.dH()*vecZ+0.5*bm.dW()*vecY*/);
						Vector3d vecCut1=vecX;
	//					reportNotice("\n V"+vecCut1);
						vecCut1=(vecCut1.rotateBy(dCut1N,vecY)).rotateBy(dCut1P,vecZ);
	//					reportNotice("\n VN"+vecCut1);
						Cut ct1(ptC1,vecCut1);
						bm.addToolStatic(ct1,_kStretchOnInsert);
	//					reportNotice("\n 1N"+dCut1N);
	
						double dCut2N=row.getDouble("Cut2N");
						double dCut2P=row.getDouble("Cut2P");
						Point3d ptC2(bm.ptCen() -0.5*bm.dL()*vecX/*-0.5*bm.dH()*vecZ-0.5*bm.dW()*vecY*/);					
						Vector3d vecCut2=-vecX;
						vecCut2=(vecCut2.rotateBy(dCut2N,vecY));
						vecCut2=vecCut2.rotateBy(dCut2P,vecCut2.crossProduct(vecY));					
						Cut ct2(ptC2,vecCut2);					
						bm.addToolStatic(ct2,_kStretchOnInsert);
						//End added by BB
					}					
				}
				else if (sheetmapkey.find("blockreference", 0) !=-1 )
				{ 
					for (int k = 0; k < sheetmap.length(); k++)
					{
						String strKey = sheetmap.keyAt(k);
						Map row = sheetmap.getMap(k);
						
						// Create a block reference - if exists
						Point3d ptOrg;
						
						ptOrg.setX(row.getDouble("ptOrg.x"));
						ptOrg.setY(row.getDouble("ptOrg.y"));
						ptOrg.setZ(row.getDouble("ptOrg.z"));
						String name = row.getString("Name");
						//reportMessage("\nblock name"+ name + "\n");
						double dScaleX =row.getDouble("Scale.x");
						double dScaleY =row.getDouble("Scale.y");
						double dScaleZ =row.getDouble("Scale.z");
						double dRotation =row.getDouble("Rotation");
						String groupname = row.getString("Group");
						int nColor=row.getDouble("Color");

						Point3d pt = Point3d(0, 0, 0);
						Vector3d vecX = Vector3d(1, 0, 0); 
						Vector3d vecY = Vector3d(0, 1, 0); 
						Vector3d vecZ = Vector3d(0, 0, 1); 
						CoordSys csNew =  CoordSys(ptOrg, vecX, vecY, vecZ);
					
						String tokens[50];
						tokens = name.tokenize("\\");

						//if (_BlockNames.find(name) >- 1)
						{
							//reportMessage("\found block\n");
							//pushCommandOnCommandStack("_-Insert");
							//pushCommandOnCommandStack(name);
							//pushCommandOnCommandStack("X");
							//pushCommandOnCommandStack(dScaleX);
							//pushCommandOnCommandStack("Y");
							//pushCommandOnCommandStack(dScaleY);
							//pushCommandOnCommandStack("Z");
							//pushCommandOnCommandStack(dScaleZ);
							//pushCommandOnCommandStack("Rotate");
							//pushCommandOnCommandStack(dRotation);
							//pushCommandOnCommandStack(ptOrg.X() + "," + ptOrg.Y() + "," + ptOrg.Z());
						}						
						
						if (tokens.length() >0)
						{ 
							String fileName = tokens[tokens.length() - 1];
							
							int index = fileName.find(".", 0);
							String blockName = fileName.left(index);
							//reportMessage("FileName \n" + blockName);
							
							Block newBlock(name);
							
							Display display(-1);
							display.draw(newBlock, Point3d(0, 0, 0));
					
							//reportMessage("Rotated\n" + rotated);
							BlockRef blockRef;
						
							blockRef.dbCreate(csNew, blockName);
							blockRef.setScale(dScaleX, dScaleY, dScaleZ);
							CoordSys csRotate =  CoordSys(pt, vecX, vecY, vecZ);
							
							csRotate.setToRotation(dRotation, vecZ, ptOrg);
							blockRef.transformBy(csRotate);
	
							if (groupname != "")
							{ 
								Group gr(groupname);
								gr.addEntity(blockRef);
							}
	
							if(nColor !=0)
							{
								blockRef.setColor(nColor);
							}							
						}
						
						// Load the block into the drawings

						//else
						//{ 
						//	Block blck(name);
						//	reportMessage("name\n");
						//}
					}
				}
			}
		}
	}
}

eraseInstance();

return;

#End
#BeginThumbnail





















































#End