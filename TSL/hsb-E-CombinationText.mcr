#Version 8
#BeginDescription
version value="1.6" date="20oct2020" author="thorsten.huck@hsbcad.com"
HSB-9338 internal naming bugfix

default format added
bugfix orientation on insert
duplicates will be purged 

new commands to modify text, new display modes

This tsl assigns text values to hsb-E-Combination instances
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords Display;Tag;Badge;formatObject;Electra;Information
#BeginContents
//region Part 1

/// <History>//region
/// <version value="1.6" date="20oct2020" author="thorsten.huck@hsbcad.com"> HSB-9338 internal naming bugfix </version>
/// <version value="1.5" date="19mar2019" author="thorsten.huck@hsbcad.com"> default format added </version>
/// <version value="1.4" date="19mar2019" author="thorsten.huck@hsbcad.com"> bugfix debug </version>
/// <version value="1.3" date="19mar2019" author="thorsten.huck@hsbcad.com"> bugfix orientation on insert </version>
/// <version value="1.2" date="19mar2019" author="thorsten.huck@hsbcad.com"> duplicates will be purged </version>
/// <version value="1.1" date="26feb2019" author="thorsten.huck@hsbcad.com"> new commands to modify text, new display modes </version>
/// <version value="1.0" date="26feb2019" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entities, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl assigns text values to hsb-E-Combination instances 
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsb-E-CombinationText")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "||Add Text||") (_TM "|Select text|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add/Remove Format|") (_TM "|Select text|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Line|") (_TM "|Select text|"))) TSLCONTENT


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
	
	String allowedNames[] = { "hsb-E-Combination"};	
//end constants//endregion

//region Properties
	String sAttributeName=T("|Format|");	
	PropString sAttribute(nStringIndex++, "@(Text 1)\@(Text 2)\@(Text 3)\@(Text 4)\@(Text 5)", sAttributeName);	
	String sAttributeDescription =T("|Defines the format of the composed value.|")+
		TN("|Samples|")+
		TN("   @(Label)@(SubLabel)")+
		TN("   @(Label:L2) |the first two characters of Label|")+
		TN("   @(Label:T1; |the second part of Label if value is separated by blanks, i.e. 'EG AW 2' will return AW'|)")+
		TN("   @(Width:RL1) |the rounded value of width with one decimal.|")+
		TN("R |Right: Takes the specified number of characters from the right of the string.|")+
		TN("L |Left: Takes the specified number of characters from the left of the string.|")+
		TN("S |SubString: Given one number will take all characters starting at the position (zero based).|")+
		T(" |Given two numbers will start at the first number and take the second number of characters.|")+
		TN("T |​Tokeniser: Returns the member of a delimited list using the specified index (zero based). A delimiter can be specified as an optional parameter with the default delimiter being the semcolon character..|")+
		TN("# |Rounds a number. Specify the number of decimals to round to. Trailing zero's are removed.|")+
		TN("RL |​Round Local: Rounds a number using the local regional settings..|");	
	sAttribute.setDescription(sAttributeDescription);
	sAttribute.setCategory(category);;	
//End Properties//endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="hsbInstallationPointSettings";
	Map mapSetting;

// find settings file
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound;
	if (_bOnInsert)
		bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";
	String sFile=findFile(sFullPath); 

// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() && sFile.length()>0)
	{
		mapSetting.readFromXmlFile(sFile);
		mo.dbCreate(mapSetting);
	}		
//End Settings//endregion

//region Read Settings
	double dTextHeight = U(80);
	int nc= _ThisInst.color(), bHideText;
	int nBorderMode=1; // 0 = no border, 1 = border
	int ncFill = -1; // -1 byBlock
	int nt = 70;	// transparency of filling
	String sDimStyle = _DimStyles[0];
{
	String k;
	Map m= mapSetting;//.getMap("SubNode[]");
// new structure
	k="Combination";	
	if (m.hasMap(k))
	{
		m = m.getMap(k);
		k="Text";	
		if (m.hasMap(k))
		{
			m = m.getMap(k);
			k="Hide";			if (m.hasInt(k))	bHideText = m.getInt(k);
			k="Color";			if (m.hasInt(k))	nc = m.getInt(k);
			k="TextHeight";		if (m.hasDouble(k) && m.getDouble(k)>0)	dTextHeight = m.getDouble(k);
			k="DimStyle";		if (m.hasString(k) &&  _DimStyles.find(m.getString(k))>-1)	sDimStyle = m.getString(k);			
			k="Transparency";	if (m.hasInt(k))	nt = m.getInt(k);
			k="FillColor";		if (m.hasInt(k))	ncFill = m.getInt(k);
			k="BorderMode";		if (m.hasInt(k))	nBorderMode = m.getInt(k);
		}
	}	
	
	
}
//End Read Settings//endregion 

// bOnInsert//region
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();

		if (sKey.length()>0)
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
			showDialog();
		
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select entity(s)|"), TslInst());
		if (ssE.go())
			ents.append(ssE.set());
			
	// only E-Combination allowed
		

		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			TslInst t=(TslInst)ents[i];
		// loop until find of array supports caseInsensitive search
			int bOk;
			for (int j=0;j<allowedNames.length();j++) 
			{ 
				if (allowedNames[j].find(t.scriptName(),0,false) == 0)
				{ 
					bOk = true;
					break;
				}	 
				 
			}//next j
			if (!bOk)ents.removeAt(i); 
		}//next i
		
	// create individual instances	
		TslInst tslNew;				
		GenBeam gbsTsl[] = {};		Entity entsTsl[1];			Point3d ptsTsl[1];
		int nProps[]={};			double dProps[]={};			String sProps[]={sAttribute};
		Map mapTsl;	

		for (int i=0;i<ents.length();i++) 
		{ 
			entsTsl[0] = ents[i]; 
			ptsTsl[0] = ((TslInst)ents[i]).ptOrg();
			tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl); 
		}//next i

		eraseInstance();	
		return;
	}	
// end on insert	__________________//endregion
	
//region validate reference and get coordSys
	TslInst tslParent;
	for (int i=_Entity.length()-1; i>=0 ; i--) 
	{ 
		TslInst t=(TslInst)_Entity[i];
	// loop until find of array supports caseInsensitive search
		int bOk;
		for (int j=0;j<allowedNames.length();j++) 
		{ 
			if (allowedNames[j].find(t.scriptName(),0,false) == 0)
			{ 
				tslParent = t;
				break;
			}	 
			 
		}//next j	
	}
	if (!tslParent.bIsValid())
	{ 
		eraseInstance();
		return;
	}
	else 
	{
	// check for duplicates
		Element el = tslParent.element();
		if (el.bIsValid())
		{ 
			Entity ents[] = el.elementGroup().collectEntities(true, TslInst(), _kModelSpace);	
			for (int i=ents.length()-1; i>=0 ; i--) 
			{ 
				TslInst t=(TslInst)ents[i];
				if (t.bIsValid() && (t.scriptName()==scriptName()) && t!=_ThisInst)
				{ 
					Entity _ents[] = t.entity();
					if (_ents.find(tslParent)>-1)
					{
						reportMessage("\n" + scriptName() + ": " + T(" |duplicate found and erased.|"));
						eraseInstance();
						return;
					}
				}
			}//next i
		}
	// set dependency and group assignment
		setDependencyOnEntity(tslParent);
		assignToGroups(tslParent, 'I');
	}

// the parent coordSys
	Map m = tslParent.map();
	CoordSys cs (tslParent.ptOrg(), m.getVector3d("vxE"), m.getVector3d("vyE"), m.getVector3d("vzE"));
	cs.vis(2);
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();		
//End validate reference and get coordSys//endregion 
	
//region Display
// set instance color if byBlock or byEntity on dbCreation on first entity found in block
	if (nc<0)
	{ 
		if(_bOnDbCreated || _bOnRecalc)
		{ 
			if (nc == -1)
				nc = tslParent.color();
			else if (nc == -2 && tslParent.propString(90).length()>0)
			{
				Block block(tslParent.propString(90));
				Entity ents[] = block.entity();
				if (ents.length()>0)
					nc = ents[0].color();
			}
			if (nc!=_ThisInst.color())
				_ThisInst.setColor(nc);			
		}
		else
			nc = _ThisInst.color();
	}

	Display dp(nc);
	dp.dimStyle(sDimStyle);
	dp.addViewDirection(cs.vecY());
	double dFactor = 1;
	double dTextHeightStyle = dp.textHeightForStyle("O",sDimStyle);
	if (dTextHeight>0)
	{
		dFactor=dTextHeight/dTextHeightStyle;
		dTextHeightStyle=dTextHeight;
		dp.textHeight(dTextHeight);
	}	
//End Display//endregion 
		
//End Part 1//endregion 


//region geometry
// get boxing frame
	PLine plFrame = tslParent.map().getPLine("plFrame");
	plFrame.vis(2);
	
// adjust coordSys by frame location
	PlaneProfile pp(plFrame);
	pp.shrink(-dTextHeightStyle/5);
	
// get extents of profile
	LineSeg seg = pp.extentInDir(vecX); seg.vis(1);
	double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
	double dZ = abs(vecZ.dotProduct(seg.ptStart()-seg.ptEnd()));

// set _Pt0 bOnDbCreated
	Vector3d vecSide = vecZ;
	if (vecSide.dotProduct(tslParent.gripPoint(0)-cs.ptOrg())<0)
		vecSide *= -1;

	Point3d ptRef = cs.ptOrg();
	double dDeltaZ = vecZ.dotProduct(seg.ptMid() - ptRef);
	if (dDeltaZ<0)
	{ 
		vecZ *= -1;
		vecX *= -1;
	}
	
	ptRef += vecSide * (abs(dDeltaZ) + .5 * dZ);
	ptRef.vis(93);
	_Pt0 += vecY * vecY.dotProduct(cs.ptOrg() - _Pt0);
	if (_bOnDbCreated)
		_Pt0 = ptRef;
	else if (pp.pointInProfile(_Pt0)==_kPointInProfile)
	{ 
		_Pt0 = pp.closestPointTo(_Pt0);
	}
	else
		ptRef = pp.closestPointTo(_Pt0);





// get text orientation
	Point3d ptNext = plFrame.closestPointTo(_Pt0);
	Vector3d vecXRead = ptNext-_Pt0; vecXRead.normalize(); 
	// horizontal if on wall side
	if (vecZ.dotProduct(_Pt0-(seg.ptMid()-vecZ*.5*dZ))<0)
		vecXRead = vecX;
	Quader qdr(ptRef, vecX, vecY, vecZ, dX, U(100), dZ);
	vecXRead = qdr.vecD(vecXRead);	

	Vector3d vecYRead = vecXRead.crossProduct(-vecY);
	if (vecXRead.dotProduct(_XW) < 0 || vecXRead.isCodirectionalTo(-_YW))
	{
		vecXRead *= -1;
		vecYRead *= -1;
	}
	

//End geometry//endregion  	

//region Trigger
// Trigger AddText//region
	String sTriggerAddText = T("|Add Text|");
	addRecalcTrigger(_kContext, sTriggerAddText );
	if (_bOnRecalc && (_kExecuteKey==sTriggerAddText || _kExecuteKey==sDoubleClick))
	{
		String newAttribute = getString(T("|Enter new line|"));
		if (newAttribute.length()>0)
		{ 
			newAttribute=sAttribute+"\\" + newAttribute;
			sAttribute.set(newAttribute);
		}
		setExecutionLoops(2);
		return;
	}//endregion	

// Trigger RemoveLine//region
	String sTriggerRemoveLine = T("|Remove Text Line|");
	addRecalcTrigger(_kContext, sTriggerRemoveLine );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveLine)
	{
		String sLines[] = sAttribute.tokenize("\\");
		String sPrompt = T("|Remove line by index|");
		reportNotice(sPrompt);	
		for (int i=0;i<sLines.length();i++) 
			reportNotice ("\n("+(i+1)+") " +sLines[i] + "...."+ tslParent.formatObject(sLines[i])); 

	// get index
		int n = getInt(sPrompt);
		n--;
		
		if (n>-1 && n<sLines.length())
		{ 
			String newAttribute;
			for (int i=0;i<sLines.length();i++) 
			{
				if (i == n)continue;
				newAttribute += (newAttribute.length()>0?"\\":"")+sLines[i]; 
			}//next i	
			sAttribute.set(newAttribute);
		}
		setExecutionLoops(2);
		return;
	}//endregion	
//	// TODO Rotation			
// Trigger RotateText//region
//	String sTriggerRotateText = T("|Rotate Text|");
//	addRecalcTrigger(_kContext, sTriggerRotateText );
//	if (_bOnRecalc && (_kExecuteKey==sTriggerRotateText || _kExecuteKey==sDoubleClick))
//	{
//	// prompt for point input
//		String sPrompt = TN("|Select point|");
//		PrPoint ssP(sPrompt, _Pt0); 
//		if (ssP.go()==_kOk) 
//		{
//			Vector3d vecTo =ssP.value()-_Pt0; // append the selected points to the list of grippoints _PtG
//			vecTo.normalize();
//			double dRotation = vecTo.angleTo(vecZ);
//			reportMessage(TN("|angle| ") + dRotation);
//			_Map.setDouble("Rotation", dRotation);
//		}
//		
//		
//		setExecutionLoops(2);
//		return;
//	}//endregion	
//	
//
//	double dRotation = _Map.getDouble("Rotation");
//	if (abs(dRotation)>0)
//	{ 
//		CoordSys csRot;
//		csRot.setToRotation(dRotation, vecY, _Pt0);
//		vecXRead.transformBy(csRot);
//		vecYRead.transformBy(csRot);
//	
//		if (vecXRead.dotProduct(_XW) < 0)
//		{
//			vecXRead *= -1;
//			vecYRead *= -1;
//		}
//	}	
//	

//End Trigger//endregion 


// Trigger AddRemoveFormat//region
	String sObjectVariables[]=tslParent.formatObjectVariables();
	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
	addRecalcTrigger(_kContext, sTriggerAddRemoveFormat );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddRemoveFormat)
	{
		String sPrompt ="\n"+ T("|Select a property by index to add(+) or to remove(-)|");
		reportNotice(sPrompt);
		
		
		for (int s=0;s<sObjectVariables.length();s++) 
		{ 
			String key = sObjectVariables[s]; 
			int bAdd = sAttribute.find(key, 0, false) < 0;
			String value;

			String _value = tslParent.formatObject("@(" + key + ")");
			if (_value.length()>0)
			{ 
				value = _value;
			}

	
			int x = s + 1;
			String sIndex = ((x<10)?"    " + x:"   " + x)+ "  ("+(bAdd?"+":"-")+")  :";
			
			reportNotice("\n"+sIndex+key + "........: "+ value);
			
		}//next i
		int nRetVal = getInt(sPrompt)-1;
		
		
	// select property	
		if (nRetVal>-1 && nRetVal<=sObjectVariables.length())
		{ 
			String newAttrribute = sAttribute;

		// get variable	and append if not already in list	
			String variable ="@(" + sObjectVariables[nRetVal] + ")";
			int x = sAttribute.find(variable, 0);
			if (x>-1)
			{
				int y = sAttribute.find(")", x);
				String left = sAttribute.left(x);
				String right= sAttribute.right(sAttribute.length()-y-1);
				newAttrribute = left + right;
				reportMessage("\n" + sObjectVariables[nRetVal] + " new: " + newAttrribute);				
			}
			else
			{ 
				newAttrribute+="\\@(" +sObjectVariables[nRetVal]+")";
							
			}
			sAttribute.set(newAttrribute);
			reportMessage("\n" + sAttributeName + " " + T("|set to|")+" " +sAttribute);	
		}	
		setExecutionLoops(2);
		return;
	}//endregion























//region resolve attributes
// the content
	String sValues[] = tslParent.formatObject(sAttribute).tokenize("\\");
	String sLines[0];
	
	//region resolve unknown
	for (int i = 0; i < sValues.length(); i++)
	{
		String& value = sValues[i];
		int left = value.find("@(", 0);
		
	// get formatVariables and prefixes
		if (left>-1)
		{ 
			//String sVariables[] = sLines[i].tokenize("@(*)");
			// tokenize does not work for strings like '(@(KEY))'
			String sTokens[0];
			while (value.length() > 0)
			{
				left = value.find("@(", 0);
				int right = value.find(")", left);
				
			// key found at first location	
				if (left == 0 && right > 0)
				{
					String sVariable = value.left(right + 1).makeUpper();

				// opening unsupported by formatObject
//					if (opening.bIsValid())
//					{ 
//						if (sVariable=="@(WIDTH)") sTokens.append(opening.width());
//						else if (sVariable=="@(HEIGHT)") sTokens.append(opening.height());
//						else if (sVariable=="@(RISE)") sTokens.append(opening.rise());
//					}
					// sTokens.append(XX);


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
		sLines.append(value);
	}	
	//End resolve unknown//endregion 	
//End resolve attributes//endregion 

//region draw
// purge if nothing to draw
	if (sLines.length()<1)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|no values to display|"));
		eraseInstance();
		return;
		
	}

	Point3d ptLoc = _Pt0;


// text alignment
	int nNumLine = sLines.length();
	int nXDir = - 1;
	if (vecXRead.isParallelTo(vecX) && vecXRead.dotProduct(_Pt0-seg.ptMid())>0)
		nXDir *= -1;
	else if (vecXRead.isParallelTo(vecZ) && vecXRead.isCodirectionalTo(vecZ))
		nXDir *= -1;
		
// draw leader
	double dLocDistance = Vector3d(ptLoc - ptNext).length();
	if (dLocDistance>3*dTextHeightStyle)
	{ 
		Vector3d vec = ptLoc - seg.ptMid(); vec.normalize();
		LineSeg segs[] = pp.splitSegments(LineSeg(seg.ptMid() - vec * U(10e3), ptLoc + vec * U(10e3)),true);
		
	// align start point towards midpoint	
		Point3d pt1 = ptNext;
		if (segs.length() > 0)
			pt1 = pp.closestPointTo(segs[0].ptEnd());	
		Point3d pt2 = ptLoc - vecXRead * .5* nXDir*dTextHeightStyle;
		PLine plLeader(vecY);		
		plLeader.addVertex(pt1);
		plLeader.addVertex(pt2);
		plLeader.addVertex(ptLoc);
		dp.draw(plLeader);
	}

// box size of text	
	double dRowFactor = 1.2;
	double dRowHeight = dTextHeightStyle * dRowFactor;
	double dXMax;
	double dYMax = dTextHeightStyle*nNumLine;
	for (int i=0;i<nNumLine;i++) 
	{ 
		String& sLine = sLines[i];
		double d=dp.textLengthForStyle(sLine,sDimStyle)*dFactor;
		dXMax=d>dXMax?d:dXMax;
		//dp.draw(sValue,ptLoc, vecX, vecY,0,dYFlag);
		//dYFlag-=3; 
	}
	dXMax += .5*dRowFactor*dTextHeightStyle;
	dYMax += .5*dRowFactor*dTextHeightStyle;


// create boundary pline
	PLine plBoundary(vecY);
	double dRadius = dXMax>dYMax?dXMax*.5:dYMax*.5;
	Point3d ptB = ptLoc;// + nXDir*vecXRead * .5 * dXMax;
	{ 
		ptLoc.vis(2);
		Point3d pt=ptLoc;
		Point3d(ptB - .5 * (vecXRead * dXMax)).vis(1);
		plBoundary.addVertex(pt - .5 * (vecXRead * dXMax - vecYRead * dYMax));
		plBoundary.addVertex(pt - .5 * (vecXRead * dXMax + vecYRead * dYMax),.25);
		plBoundary.addVertex(pt + .5 * (vecXRead * dXMax - vecYRead * dYMax));
		plBoundary.addVertex(pt + .5 * (vecXRead * dXMax + vecYRead * dYMax),.25);
		plBoundary.close();
		
		Point3d pts[] = plBoundary.intersectPoints(Plane(pt, vecYRead));
		pts = Line(pt, -nXDir * vecXRead).orderPoints(pts);
		if (pts.length()>0)
			plBoundary.transformBy(pts[0] - pt);
	}



// draw lines
	Point3d ptTxt = ptLoc + nXDir*vecXRead*.6*dTextHeightStyle-vecYRead*.5*dTextHeightStyle;
	ptTxt += vecYRead * ((nNumLine - 1) * .5) * dRowHeight;
	for (int i=0;i<nNumLine;i++) 
	{
		ptTxt.vis(3);
		String& sLine = sLines[i];
		dp.draw(sLine,ptTxt, vecXRead, vecYRead,nXDir,1); 
		ptTxt -= vecYRead * dRowHeight;
	}	

// draw boundary
	if (nBorderMode==1)
		dp.draw(plBoundary);
	if (nt>0)
	{
		if (nc!=ncFill)dp.color(ncFill);
		dp.draw(PlaneProfile(plBoundary), _kDrawFilled, nt);	
	}
	


//End draw//endregion 
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