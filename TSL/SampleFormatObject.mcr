#Version 8
#BeginDescription
version value="1.1" date="09jan2020" author="thorsten.huck@hsbcad.com"
ERoofplanes added, grain symbol fixed

/// This tsl provides sample code to implement formatObject, resolve unknown properties and to provide a general UI via context command.
/// Copy all relevant parts and assign some TODO variables by your local variables
/// In case some variables are not resolved, please add them including a comment.
/// Please document tsls which are using this sample code in order to provide an update.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords formatObject;Display
#BeginContents
/// <History>//region
/// <version value="1.1" date="09jan2020" author="thorsten.huck@hsbcad.com"> ERoofplanes added, grain symbol fixed</version>
/// <version value="1.0" date="09dec2019" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl provides sample code to implement formatObject, resolve unknown properties and to provide a general UI via context command.
/// Copy all relevant parts and assign some TODO variables by your local variables
/// In case some variables are not resolved, please add them including a comment.
/// Please document tsls which are using this sample code in order to provide an update.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "SampleFormatObject")) TSLCONTENT

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
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "", sFormatName);	
	sFormat.setDescription(T("|Defines the Format|"));
	sFormat.setCategory(category);
//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(sKey,-1)>-1)			
				setPropValuesFromCatalog(sKey);
			else
				showDialog();					
		}		
		else	
			showDialog();
		
	// prompt for entities
		PrEntity ssE(T("|Select entity(s)|"), Entity());
		if (ssE.go())
			_Entity.append(ssE.set());
	
		_Pt0 = getPoint();
		return;
	}	
// end on insert	__________________//endregion
	

// validate sset
	if (_Entity.length()<1)
	{ 
		reportMessage("\n"+ scriptName() + ": " +T("|Invalid selection set| ")+T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
	Entity ents[0];
	ents = _Entity;


//region Collect list of available object variables and append properties which are unsupported by formatObject (yet)
	String sObjectVariables[0];
	for (int i=0;i<ents.length();i++) 
	{ 
		String _sObjectVariables[0];
		_sObjectVariables.append(ents[i].formatObjectVariables());
		
	// append all variables, they might vary by type as different property sets could be attached
		for (int j=0;j<_sObjectVariables.length();j++)  
		{
			String var =_sObjectVariables[j];
			if(sObjectVariables.find(var)<0)
				sObjectVariables.append(var); 
		}				
	}//next

//region Add custom variables for format resolving
	// adding custom variables or variables which are currently not supported by core
	for (int i=0;i<ents.length();i++)
	{ 
		String k;

	// all solids
		k = "Calculate Weight"; if (sObjectVariables.find(k) < 0 && ents[i].realBody().volume()>pow(dEps,3))sObjectVariables.append(k);
			
		if (ents[i].bIsKindOf(Sip()) || ents[i].bIsKindOf(ChildPanel()))
		{ 
			k = "GrainDirection";		if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "GrainDirectionText";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "GrainDirectionTextShort";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SurfaceQuality";	if(sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SurfaceQualityTop";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SurfaceQualityBottom";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SipComponent.Name";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SipComponent.Material";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);		
		}
		else if (ents[i].bIsKindOf(Beam()))
		{ 
			k = "Surface Quality";		if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);		
		}		
		else if (ents[i].bIsKindOf(Opening()))
		{ 
			k = "Width"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "Height"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "Rise"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "SillHeight";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "HeadHeight";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "Description";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "Type"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			k = "OpeningDescription";	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			if (ents[i].bIsKindOf(OpeningSF()))
			{ 
				k = "GapSide"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
				k = "GapTop"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
				k = "GapBottom"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);			
				k = "StyleNameSF"; 	if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);
			}
		}
		// metalpart collection entity	
		else if (ents[i].bIsKindOf(MetalPartCollectionEnt()))
		{ 
			k = "Definition"; if (sObjectVariables.find(k) < 0)sObjectVariables.append(k);	
		}	
		
	}	
	
// get translated list of variables
	String sTranslatedVariables[0];
	for (int i=0;i<sObjectVariables.length();i++) 
		sTranslatedVariables.append(T("|"+sObjectVariables[i]+"|")); 
	
// order both arrays alphabetically
	for (int i=0;i<sTranslatedVariables.length();i++) 
		for (int j=0;j<sTranslatedVariables.length()-1;j++) 
			if (sTranslatedVariables[j]>sTranslatedVariables[j+1])
			{
				sObjectVariables.swap(j, j + 1);
				sTranslatedVariables.swap(j, j + 1);
			}			
//End add custom variables//endregion 


//End get list of available object variables//endregion 

//region Trigger AddRemoveFormat
	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
	addRecalcTrigger(_kContext, "../"+sTriggerAddRemoveFormat );
	if (_bOnRecalc && (_kExecuteKey=="../"+sTriggerAddRemoveFormat || _kExecuteKey==sTriggerAddRemoveFormat))
	{
		String sPrompt;
//		if (bHasSDV && entsDefineSet.length()<1)
//			sPrompt += "\n" + T("|NOTE: During a block setup only limited properties are accesable, but you can enter \nany valid format expression or use custom catalog entries.|");
		sPrompt+="\n"+ T("|Select a property by index to add(+) or to remove(-)|") + T(" ,|-1 = Exit|");
		reportNotice(sPrompt);
		
		for (int s=0;s<sObjectVariables.length();s++) 
		{ 
			String key = sObjectVariables[s]; 
			String keyT = sTranslatedVariables[s];
			String sValue;
			for (int j=0;j<ents.length();j++) 
			{ 
				String _value = ents[j].formatObject("@(" + key + ")");
				if (_value.length()>0)
				{ 
					sValue = _value;
					break;
				}
			}//next j

			String sAddRemove = sFormat.find(key,0, false)<0?"(+)" : "(-)";
			int x = s + 1;
			String sIndex = ((x<10)?"    " + x:"   " + x)+ "  "+sAddRemove+"  :";
			
			reportNotice("\n"+sIndex+keyT + "........: "+ sValue);
			
		}//next i
		int nRetVal = getInt(sPrompt)-1;
				
	// select property	
		while (nRetVal>-1)
		{ 
			if (nRetVal>-1 && nRetVal<=sObjectVariables.length())
			{ 
				String newAttrribute = sFormat;
	
			// get variable	and append if not already in list	
				String var ="@(" + sObjectVariables[nRetVal] + ")";
				int x = sFormat.find(var, 0);
				if (x>-1)
				{
					int y = sFormat.find(")", x);
					String left = sFormat.left(x);
					String right= sFormat.right(sFormat.length()-y-1);
					newAttrribute = left + right;
					reportMessage("\n" + sObjectVariables[nRetVal] + " new: " + newAttrribute);				
				}
				else
				{ 
					newAttrribute+="@(" +sObjectVariables[nRetVal]+")";
								
				}
				sFormat.set(newAttrribute);
				reportMessage("\n" + sFormatName + " " + T("|set to|")+" " +sFormat);	
			}
			nRetVal = getInt(sPrompt)-1;
		}
	
		setExecutionLoops(2);
		return;
	}	
	
	
//endregion 

//region Resolve format by entity
	Vector3d vecXView = _XW;// TODO specify reading direction, vecZView to resolve combined surface quality bottom/top
	Vector3d vecYView = _YW;
	
	

	Display dp(1);
	double dTextHeight = U(100); 	
	dp.textHeight(dTextHeight);// TODO the textheight is only required for symbols like the grain direction. the output string needs to reserve blank space for it

	for (int i=0;i<ents.length();i++) 
	{ 
		CoordSys ms2ps(_PtW, _XW, _YW, _ZW); // TODO assign modelspace to paperspace transformation if text needs to be displayed in paperspace
		Vector3d vecZView = vecXView.crossProduct(vecYView);
		Entity ent = ents[i]; 
		Beam bm = (Beam)ent;
		Sheet sh = (Sheet)ent;
		Sip sip = (Sip)ent;
		Opening opening = (Opening)ent;
		OpeningSF openingSF = (OpeningSF)ent;
		Element element = (Element)ent;
		TslInst tsl = (TslInst)ent;
		MetalPartCollectionEnt mpce = (MetalPartCollectionEnt)ent;
		ChildPanel child = (ChildPanel)ent;
		ERoofPlane erp = (ERoofPlane)ent;
		
		Point3d ptCen;
		{
			Point3d pts[] = ent.gripPoints();
			if (pts.length()>0)ptCen.setToAverage(ent.gripPoints());
		}
		
		
		int bIsSolid = ent.realBody().volume() > pow(dEps, 3);

	//region Sip & tsl specifics
		Vector3d vecXGrain, vecYGrain;
		int nRowGrain = - 1;
		double dLengthBeforeGrain; // the potential line number of the grain symbol and the amount of characters in the same row befor symbol
		int nGrainMode = -1; // 0 = X lengthwise, 1 = Y crosswise, 2 = Z parallel to view
		String sqTop,sqBottom; 
		SipComponent components[0];
		HardWrComp hwcs[0];
		
		if (child.bIsValid())
			sip = child.sipEntity();
		
	// sip specifics		
		if (sip.bIsValid())
		{
			vecXGrain = sip.woodGrainDirection();
			vecYGrain = vecXGrain.crossProduct(sip.vecZ());
			if (!vecXGrain.bIsZeroLength())
			{
				if (child.bIsValid())
				{
					vecXGrain.transformBy(child.sipToMeTransformation());
					vecYGrain.transformBy(child.sipToMeTransformation());
				}
				vecXGrain.transformBy(ms2ps);
				vecYGrain.transformBy(ms2ps);
												
				nGrainMode = sip.vecX().isParallelTo(vecXGrain) ? 0 : 1;
				if (nGrainMode>-1 && !vecZView.bIsZeroLength() && vecXGrain.isParallelTo(vecZView))
					nGrainMode = 2;
			}

			SipStyle style(sip.style());
			sqTop = sip.surfaceQualityOverrideTop();
			if (sqTop.length() < 1)sqTop = style.surfaceQualityTop();
			if (sqTop.length() < 1)sqTop = "?";
			int nQualityTop = SurfaceQualityStyle(sqTop).quality();
			
			sqBottom = sip.surfaceQualityOverrideBottom();
			if (sqBottom.length() < 1)sqBottom = style.surfaceQualityBottom();
			if (sqBottom.length() < 1)sqBottom = "?";
			int nQualityBottom = SurfaceQualityStyle(sqBottom).quality();
			
			components = style.sipComponents();
			
			ptCen = sip.ptCen();
			ms2ps.setToAlignCoordSys(ptCen, sip.vecX(), sip.vecY(), sip.vecZ(), ptCen, vecXView , vecYView, vecZView);
		}
	// tsl specifics	
		else if (tsl.bIsValid())
		{
			hwcs = tsl.hardWrComps();
		}
		
		
	//End Sip & tsl specifics//endregion 	


		String sLines[0];// store the resolved variables by line (if \P was found)	
		String sValues[0];	
		String sValue=  ent.formatObject(sFormat);
	
	// parse for any \P (new line)
		int left= sValue.find("\\P",0);
		while(left>-1)
		{
			sValues.append(sValue.left(left));
			sValue = sValue.right(sValue.length() - 2-left);
			left= sValue.find("\\P",0);
		}
		sValues.append(sValue);	
	
	// resolve unknown variables
		for (int v= 0; v < sValues.length(); v++)
		{
			String& value = sValues[v];
			int left = value.find("@(", 0);
			
		// get formatVariables and prefixes
			if (left>-1)
			{ 
				// tokenize does not work for strings like '(@(KEY))'
				String sTokens[0];
				while (value.length() > 0)
				{
					left = value.find("@(", 0);
					int right = value.find(")", left);
					
				// key found at first location	
					if (left == 0 && right > 0)
					{
						String sVariable = value.left(right + 1);
	
					// any solid	
						if (bIsSolid && sVariable.find("@(Calculate Weight)",0,false)>-1)
						{
							Map mapIO,mapEntities;
							mapEntities.appendEntity("Entity", ents[i]);
							mapIO.setMap("Entity[]",mapEntities);
							TslInst().callMapIO("hsbCenterOfGravity", mapIO);
							double dWeight = mapIO.getDouble("Weight");// / dConversionFactor;
							
							String sTxt;
							if (dWeight<10)	sTxt.formatUnit(dWeight, 2,1);			
							else			sTxt.formatUnit(dWeight, 2,0);
							sTxt = sTxt + " kg";						
							sTokens.append(sTxt);
						}

					// SIP
						else if (sip.bIsValid())
						{ 
							if (sVariable.find("@(GrainDirectionText)",0,false)>-1)
								sTokens.append(vecXGrain.isParallelTo(_XW) ? T("|Lengthwise|") : T("|Crosswise|"));
							else if (sVariable.find("@(GrainDirectionTextShort)",0,false)>-1)
								sTokens.append(vecXGrain.isParallelTo(_XW) ? T("|Grain LW|") : T("|Grain CW|"));
							else if (sVariable.find("@(surfaceQualityBottom)",0,false)>-1)
								sTokens.append(sqBottom);	
							else if (sVariable.find("@(surfaceQualityTop)",0,false)>-1)
								sTokens.append(sqTop);	
							else if (sVariable.find("@(SurfaceQuality)",0,false)>-1)
							{
								String sQualities[] ={sqBottom, sqTop};
								if (!vecZView.bIsZeroLength() && sip.vecZ().isCodirectionalTo(vecZView))sQualities.swap(0, 1);
								String sQuality = sQualities[0] + " (" + sQualities[1] + ")";
								sTokens.append(sQuality);	
							}
							else if (sVariable.find("@(Graindirection)",0,false)>-1 && !vecXGrain.bIsZeroLength())
							{
								nRowGrain = sLines.length();
								String sBefore;
								for (int j=0;j<sTokens.length();j++) 
									sBefore += sTokens[j]; // the potential characters before the grain direction symbol
								dLengthBeforeGrain = dp.textLengthForStyle(sBefore, _DimStyles.first(), dTextHeight);
								sTokens.append("    ");//  4 blanks, symbol size max 4 characters lengt
							}
							else if (sVariable.find("@(SipComponent.Name)",0,false)>-1)
								sTokens.append(SipStyle(sip.style()).sipComponentAt(0).name());								
							else if (sVariable.find("@(SipComponent.Material)",0,false)>-1)
								sTokens.append(SipStyle(sip.style()).sipComponentAt(0).material());								
						}
					// OPENING	
						else if (opening.bIsValid())
						{
							if (sVariable.find("@(Width)", 0, false) >- 1)			sTokens.append(opening.width());
							else if (sVariable.find("@(Height)", 0, false) >- 1)	sTokens.append(opening.height());
							else if (sVariable.find("@(Rise)", 0, false) >- 1)		sTokens.append(opening.rise());
							else if (sVariable.find("@(SillHeight)", 0, false) >- 1)		sTokens.append(opening.sillHeight());
							else if (sVariable.find("@(HeadHeight)", 0, false) >- 1)		sTokens.append(opening.headHeight());
							else if (sVariable.find("@(Description)", 0, false) >- 1)		sTokens.append(opening.description());
							else if (sVariable.find("@(Type)", 0, false) >- 1)		sTokens.append(opening.type());
						}
					// OPENING SF	
						else if (openingSF.bIsValid())
						{ 							
							if (sVariable.find("@(GapSide)",0,false)>-1)		sTokens.append(openingSF.dGapSide());
							else if (sVariable.find("@(GapTop)",0,false)>-1)		sTokens.append(openingSF.dGapTop());
							else if (sVariable.find("@(GapBottom)",0,false)>-1)		sTokens.append(openingSF.dGapBottom());
							else if (sVariable.find("@(StyleNameSF)",0,false)>-1)		sTokens.append(openingSF.styleNameSF());
						}
					// BEAM
						else if (bm.bIsValid())
						{ 
							if (sVariable.find("@(Surface Quality)",0,false)>-1)	sTokens.append(bm.texture());
						}
					// MetalPartCollectionEnt
						else if (mpce.bIsValid())
						{ 
							if (sVariable.find("@(Definition)",0,false)>-1)	sTokens.append(mpce.definition());
						}
					// RoofPlane
						else if (erp.bIsValid())
						{ 
							if (sVariable.find("@(RoofNumber)",0,false)>-1)	sTokens.append(erp.roofNumber());
							else if (sVariable.find("@(Code)",0,false)>-1)	sTokens.append(erp.code());
						}	
						value = value.right(value.length() - right - 1);
					}
				// any text inbetween two variables	
					else if (left > 0 && right > 0)
					{
						sTokens.append(value.left(left));
						value = value.right(value.length() - left);
					}
				// any postfix text
					else
					{
						sTokens.append(value);
						value = "";
					}
				}
	
				for (int j=0;j<sTokens.length();j++) 
					value+= sTokens[j]; 
			}
			//sAppendix += value;
			sLines.append(value);
		}	
		
	// text out
		String sText;
		for (int j=0;j<sLines.length();j++) 
		{ 
			sText += sLines[j];
			if (j < sLines.length() - 1)sText += "\\P";		 
		}//next j
		
	// debug // TODO remove
		if (1)
		{ 
			reportMessage("\nEntity " + ent.handle() + " resolves format " + sFormat + " into this string\n" + sText + "("+sText.length()+")");	
			
			dp.draw(sText, ptCen, vecXView, vecYView, 0, 0);
			dp.draw(PLine(ptCen, _Pt0));
			
			// draw the grain direction symbol
			if (nRowGrain>-1 && sLines.length()>0)
			{ 
				double dYBox = dp.textHeightForStyle(sText, _DimStyles.first(), dTextHeight);
				double dRowHeight = dYBox / sLines.length();
				double dX = vecXView.isParallelTo(vecXGrain) ? 2*dp.textLengthForStyle("O", _DimStyles.first(), dTextHeight) : .8*dTextHeight;
				Point3d pt = ptCen + vecYView * (.5*(dYBox-dRowHeight)-nRowGrain*dRowHeight);
				if (dLengthBeforeGrain > 0)pt += vecXView * .5 * (dLengthBeforeGrain + dX);
				PLine pl;	
				pl.addVertex(pt - vecXGrain * .5 * dX - vecYGrain * .5 * dTextHeight);
				pl.addVertex(pt - vecXGrain  * dX);
				pl.addVertex(pt + vecXGrain  * dX);
				pl.addVertex(pt + vecXGrain * .5 * dX + vecYGrain * .5 * dTextHeight);
				dp.draw(pl);
			}			
			
			if (i==0)dp.draw(sFormat, _Pt0, vecXView, vecYView, 0, 0);
		}

	}//next i
		
//End Resolve format by entity//endregion 

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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End