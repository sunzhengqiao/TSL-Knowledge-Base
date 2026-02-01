#Version 8
#BeginDescription
This tsl creates beams out of solids nested within block references.

#Versions
Version 1.1 14.12.2022 HSB-17333 bugfix on complex solids , Author Thorsten Huck
Version 1.0 13.12.2022 HSB-17333 initial version

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.1 14.12.2022 HSB-17333 bugfix on complex solids , Author Thorsten Huck
// 1.0 13.12.2022 HSB-17333 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select blockreferences which contain solids.
/// </insert>

// <summary Lang=en>
// This tsl creates beams out of solids nested within block references.
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "BlockToBeamConverter")) TSLCONTENT

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
	
	double dSmallVol = U(1)*U(1)*U(1);
//end Constants//endregion



//region Properties
	String tDisabled = T("<|Disabled|>");
	String sPropMappings[] = {tDisabled, T("|Name|"), T("|Material|"), T("|Grade|"), T("|Information|"), T("|Label|"), T("|SubLabel|"), T("|SubLabel2|")};


	String sSeparatorName=T("|Separator|");	
	PropString sSeparator(nStringIndex++, "-", sSeparatorName);	
	sSeparator.setDescription(T("|Defines the Separator to identify tokens within the layer name|"));
	sSeparator.setCategory(category);

	String sTypeName=T("|Type|");
	String sTypes[] = { T("|Real Solid|"), T("|Simplified Solid|")};
	PropString sType(nStringIndex++, sTypes, sTypeName);	
	sType.setDescription(T("|Defines if the converted beam will represent the real solid of the source or a simplified solid (faster)|"));
	sType.setCategory(category);


	String sHideName=T("|Set source invisible|");	
	PropString sHide(nStringIndex++, sNoYes, sHideName,1);	
	sHide.setDescription(T("|Defines wether a successfully converted blockreference will be invisible after conversion (use _HSB_SHOWOBJECTS to unhide)|"));
	sHide.setCategory(category);

category = T("|Token|");
	String sToken1Name=T("|Token| 1");	
	PropString sToken1(nStringIndex++, sPropMappings, sToken1Name);	
	sToken1.setDescription(T("|Defines the Token| 1"));
	sToken1.setCategory(category);
	
	String sToken2Name=T("|Token| 2");	
	PropString sToken2(nStringIndex++, sPropMappings, sToken2Name);	
	sToken2.setDescription(T("|Defines the Token| 2"));
	sToken2.setCategory(category);

	String sToken3Name=T("|Token| 3");	
	PropString sToken3(nStringIndex++, sPropMappings, sToken3Name);	
	sToken3.setDescription(T("|Defines the Token| 3"));
	sToken3.setCategory(category);

	String sToken4Name=T("|Token| 4");	
	PropString sToken4(nStringIndex++, sPropMappings, sToken4Name);	
	sToken4.setDescription(T("|Defines the Token| 4"));
	sToken4.setCategory(category);
	
	String sToken5Name=T("|Token| 5");	
	PropString sToken5(nStringIndex++, sPropMappings, sToken5Name);	
	sToken5.setDescription(T("|Defines the Token| 5"));
	sToken5.setCategory(category);	

	String sToken6Name=T("|Token| 6");	
	PropString sToken6(nStringIndex++, sPropMappings, sToken6Name);	
	sToken6.setDescription(T("|Defines the Token| 6"));
	sToken6.setCategory(category);
	
	String sToken7Name=T("|Token| 7");	
	PropString sToken7(nStringIndex++, sPropMappings, sToken7Name);	
	sToken7.setDescription(T("|Defines the Token| 7"));
	sToken7.setCategory(category);	

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
		
		
	// prompt for entities
		PrEntity ssE(T("|Select entities|"), BlockRef());
		if (ssE.go())
			_Entity.append(ssE.set());
			
		
		if (bDebug)_Pt0 = getPoint();
		
		
		return;
	}			
//endregion 


//region Convert
	String sProperties[] = { sToken1, sToken2, sToken3, sToken4, sToken5, sToken6, sToken7};
	int bHide = sHide == sNoYes[1];
	int bBoundingBox = sType == sTypes[1];
	
	reportNotice("\n"+ scriptName() + T("|starting conversion of block references| (")+ _Entity.length() + ")");
	reportNotice("\n" + T("|Please wait|"));
	
	int num;
	String sWait;
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity e = _Entity[i]; 
		BlockRef bref = (BlockRef)e;
		CoordSys cs = bref.coordSys();
		
		String layerName = bref.layerName();
		
		String tokens[0];
		if (sSeparator.length()>0 && layerName.find(sSeparator,0,false)>-1)
			tokens= layerName.tokenize(sSeparator);

		if (e.bIsValid())
		{ 
			Block block (bref.definition());
			Entity ents[] = block.entity();
			
			int ne = ents.length();
			reportNotice("\n	" +ne + (ne==1?T(" |entity|"):T("|entities|") )+T(" |found in block reference on layer| ")+ layerName);
			
			int bOk;
			for (int j=0;j<ents.length();j++) 
			{ 
				Beam bm;
				Body bd = ents[j].realBody();
				bd.transformBy(cs);

	
				if (bDebug)
				{
					bd.transformBy(_Pt0 - bd.ptCen());
					bd.vis(3);
				}
				else if (bd.isNull())
				{ 
					reportNotice("\n" +ents[j].typeDxfName() + T(" |invalid solid, creation failed on blockref| ") + bref.definition() );
					sWait = "";
				}
				else
				{ 
					
					bm.dbCreate(bd, true,bBoundingBox);

				}
				
				if (bm.bIsValid()) // second attempt: try to convert from solid
				{ 
					bOk = true;
					if (sWait.length()>20)
					{ 
						reportNotice(TN("|Please wait|"));
						sWait ="" ;
						
					}
					else
						reportNotice(".");
					sWait += ".";
					//reportNotice(", " + (j+1)+ T(" |beam successfully created|"));
					bm.setColor(e.color());
					bm.assignToLayer(layerName);
					num++;
					
					for (int x=0;x<sProperties.length();x++) 
					{ 
						String property = sProperties[x];
						int n = sPropMappings.findNoCase(property,-1)-1;
						
						if (n == 0 && tokens.length()>n)bm.setName(tokens[n]);
						else if (n == 1 && tokens.length()>n )bm.setMaterial(tokens[n]);
						else if (n == 2 && tokens.length()>n)bm.setGrade(tokens[n]);
						else if (n == 3 && tokens.length()>n)bm.setInformation(tokens[n]);
						else if (n == 4 && tokens.length()>n)bm.setLabel(tokens[n]);
						else if (n == 5 && tokens.length()>n)bm.setSubLabel(tokens[n]);
						else if (n == 6 && tokens.length()>n)bm.setSubLabel2(tokens[n]);
					}//next x						
				}

			}//next j
			
			if (bOk && bHide)
				e.setIsVisible(false);
		}
	}//next i

	if (!bDebug)
	{
		reportNotice("\n" + num + T(" |beams have been converted from blocks| ") + _Entity.length());
		eraseInstance();
		return;
	}



//endregion 










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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17333 bugfix on complex solids" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="12/14/2022 8:35:42 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17333 initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="12/13/2022 8:02:50 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End