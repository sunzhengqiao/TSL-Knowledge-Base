#Version 8
#BeginDescription
version value="1.02" date=29jan2019" author="david.rueda@hsbcad.com"

Creates brace drills on beams of type brace and every connected beams (1 instance per pair of beams)
#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
//region history
/// <History>
/// <version value="1.00" date="10jan2019" author="david.rueda@hsbcad.com"> initial </version>
/// <version value="1.01" date=28jan2019" author="david.rueda@hsbcad.com"> Search for female beams improved and drill alignment (to male or female center) added so user can use a simple brace representation instead a real beam  </version>
/// <version value="1.02" date=29jan2019" author="david.rueda@hsbcad.com"> Added end cut to brace  </version>
/// </History>

/// <insert Lang=en>
/// Select beams(s)
/// </insert>

/// <summary Lang=en>
/// Creates brace drills on beams of type brace and every connected beams (1 instance per pair of beams)
/// </summary>
//endregion
{
// constants //region
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
	String sDistributionMode = T("|Distribution Mode|");
	String sSingleInsertion = T("|Single Insertion|");
	String sInsertionPoint = T("|Insertion Point|");
	Display dp(255);
	dp.textHeight(U(50));
	//endregion
	
//region properties and triggers
	category = T("|Main drill|");
	String sDiameterName=T("|Diameter|");
	PropDouble dDiameter(nDoubleIndex++, U(12), sDiameterName);	
	dDiameter.setDescription(T("|Defines the diameter of the main drill|"));
	dDiameter.setCategory(category);	

	category = T("|Sinkhole|");
	String sDiameterSinkholeName=T("|Diameter| ");
	PropDouble dDiameterSinkhole(nDoubleIndex++, U(50), sDiameterSinkholeName);	
	dDiameterSinkhole.setDescription(T("|Defines the diameter of the sinkhole|"));
	dDiameterSinkhole.setCategory(category);
	
	String sDepthName=T("|Depth|");
	PropDouble dDepth(nDoubleIndex++, U(15), sDepthName);	
	dDepth.setDescription(T("|Defines the sinkhole depth on receiving beam|"));
	dDepth.setCategory(category);
	
	String sDepthBraceName=T("|Depth on brace|");
	PropDouble dDepthBrace(nDoubleIndex++, U(15), sDepthBraceName);	
	dDepthBrace.setDescription(T("|Defines the sinkhole depth on the brace|"));
	dDepthBrace.setCategory(category);
	
	category = T("|Offsets|");
	String sDrillAlignments[] = {T("|To brace center|"), T("|To female center|")};
	String sDrillAlignmentName=T("|Drill alignment|");
	PropString sDrillAlignment(nStringIndex++, sDrillAlignments, sDrillAlignmentName, 1);	
	sDrillAlignment.setDescription(T("|Defines if drill will be aligned to the brace or the female beam center|"));
	sDrillAlignment.setCategory(category);
	int nDrillAlignment= sDrillAlignments.find(sDrillAlignment, 0);
	
	String sOffsetLateralName=T("|Lateral|");
	PropDouble dOffsetLateral(nDoubleIndex++, U(0), sOffsetLateralName);	
	dOffsetLateral.setDescription(T("|Defines the lateral offset|"));
	dOffsetLateral.setCategory(category);
	
	String sOffsetDepthName=T("|Normal|");
	PropDouble dOffsetDepth(nDoubleIndex++, U(0), sOffsetDepthName);	
	dOffsetDepth.setDescription(T("|Defines the offset on direction normal to the connection|"));
	dOffsetDepth.setCategory(category);
	
	category = T("|Hardware info|");
	String sMakerName=T("|Maker|");
	PropString sMaker(nStringIndex++, "", sMakerName);	
	sMaker.setDescription(T("|Defines the maker|"));
	sMaker.setCategory(category);
	
	String sProductNameName=T("|Product name|");
	PropString sProductName(nStringIndex++, "", sProductNameName);	
	sProductName.setDescription(T("|Defines the product name|"));
	sProductName.setCategory(category);
	
	// TriggerVARIABLE//region
	if (_bOnRecalc && _kExecuteKey==sDoubleClick)
	{
		eraseInstance();
		return;
	}//endregion	
	
	//endregion
	
//region bOnInsert
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
		{
			if (bDebug)
			{
				Point3d ptInsertion = getPoint();
				_Map.setPoint3d(sInsertionPoint, ptInsertion);
			}
			else
				showDialog();
		}
		
		Beam bmConstruction[0];
		PrEntity ssConstruction(T("|Select construction|"), Beam());
		if (ssConstruction.go())
			_Beam.append(ssConstruction.beamSet());
		
		if (_Beam.length() == 0)
		{
			eraseInstance();
			return;
		}
		
		_Map.setInt(sDistributionMode, 1);
		
		return;
		
	}//end on insert__________________________________________________________________________________________________________
	//endregion
	
	int bDistributionMode = _Map.getInt(sDistributionMode);
	if (bDebug)dp.color(bDistributionMode);
	
	if (bDistributionMode) // emulating bOnInsert
	{
		dp.draw(scriptName(), _Map.getPoint3d(sInsertionPoint), _XW, _YW, 0, 0, _kDevice);	
		
	//collect posts and no posts
		Beam bmBraces[0], bmOthers[0];
		for (int b = 0; b < _Beam.length(); b++)
		{
			Beam bm = _Beam[b];
			if (bm.bIsDummy())
				continue;
			
			if (bm.type() == _kBrace)
				bmBraces.append(bm);
			else
				bmOthers.append(bm);
		}//next index
		
		if (bmBraces.length() == 0 || bmOthers.length() == 0)
		{
			eraseInstance();
			return;
		}
		
	// prepare for clonning
		TslInst tslNew;				Vector3d vecXTsl = _XW;			Vector3d vecYTsl = _YW;
		GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { };
		int nProps[] ={ };			
		double dProps[] ={ dDiameter, dDiameterSinkhole, dDepth, dDepthBrace, dOffsetLateral, dOffsetDepth};
		String sProps[] ={ sDrillAlignment, sMaker, sProductName}; 
		Map mapTsl;
		
		if (bmBraces.length() == 1)
			mapTsl.setInt(sSingleInsertion, true); // to display error messages when user insert a single instance
		
	//collect all connections (one per post)
		int nBraces, nDrills;
		for (int b = 0; b < bmBraces.length(); b++)
		{
			Beam bmBrace = bmBraces[b];
			Point3d ptCen = bmBrace.ptCenSolid();
			Vector3d vecX = bmBrace.vecX();
			Beam bmTConnecteds [0];
			Beam bmPotentialConnections[] = bmBrace.filterBeamsHalfLineIntersectSort(bmOthers, ptCen, vecX);
			if(bmPotentialConnections.length() >0)
				{ bmTConnecteds.append(bmPotentialConnections[0]);}
			bmPotentialConnections.setLength(0);
			bmPotentialConnections = bmBrace.filterBeamsHalfLineIntersectSort(bmOthers, ptCen, -vecX);
			if(bmPotentialConnections.length() >0)
				{ bmTConnecteds.append(bmPotentialConnections[0]);}

			for (int c = 0; c < bmTConnecteds.length(); c++)
			{
				Beam bmConnected = bmTConnecteds[c];
				
				gbsTsl.setLength(0);
				gbsTsl.append(bmBrace);
				gbsTsl.append(bmConnected);
				
				//time to clone
				if ( ! bDebug)
				{
					if ( _kExecutionLoopCount == 0)
						tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
				}
				else
				{
					bmConnected.envelopeBody().vis(c);
					dp.draw(scriptName(), bmConnected.ptCenSolid(), _XW, _YW, 0, 0, _kDevice);
				}
				nDrills++;
			}//next index
		}//next index
		
		if ( _kExecutionLoopCount == 0)
		{
			reportMessage("\n" + scriptName() + ": " + bmBraces.length() + T(" |brace(s) found|"));
			reportMessage("\n" + scriptName() + ": " + nDrills + T(" |drill(s) created|"));
		}
		
		if ( ! bDebug)
		{
			eraseInstance();
		}
		
		return;
	}
	else // connection mode
	{	
		int bSingleInsertion = _Map.getInt(sSingleInsertion);
		
		if (_Beam.length() != 2 )
		{
			eraseInstance();
			return;
		}
		
		Beam bmBrace = _Beam0;
		Beam bmFemale = _Beam1;
		if ( bmBrace.type() != _kBrace)
		{
			if (bSingleInsertion)
				reportMessage("\n" + scriptName() + T(" |- Error|: ") + T("|not valid beam of type brace found|\n"));
			
			eraseInstance();
			return;
		}
		
	// Erasing all TSL's attached to bmBrace
		Entity ent = bmBrace;
		Map subMap= ent.subMap(scriptName());
		for ( int e = subMap.length() - 1; e >= 0; e--)
		{
			String sKey = subMap.keyAt(e);
			Entity ent = subMap.getEntity(sKey);
			TslInst tsl = (TslInst)ent;
			if ( ! tsl.bIsValid())
				continue;
			if( scriptName() != tsl.scriptName())
				continue;
				
			if (sKey != _ThisInst.handle())
			{				
				// Erase if has same name and they're at same insertion point
				Point3d ptInsert = tsl.ptOrg();
				if ( (ptInsert - _Pt0).length() < dEps )
				{
					tsl.dbErase();
					reportMessage("\n" + scriptName() + ": " + T("|Duplicated removed|"));
				}
			}
		}
		
		// Add keys and submap to future deletions at insertion
		subMap.setEntity(_ThisInst.handle(), _ThisInst);
		ent.setSubMap(scriptName(), subMap);

	// define main points
		Point3d ptAlignment = bmBrace.ptCenSolid();
		if(nDrillAlignment == 1)
			ptAlignment = bmFemale.ptCenSolid();
			
		Point3d ptStart = _Pt0 + _X1 * dOffsetLateral  + _Y1 * (_Y1.dotProduct(ptAlignment - _Pt0) + dOffsetDepth) + _Z1 * (bmFemale.dD(_Z1)); // added dEps
		Plane plnExternalBrace(bmBrace.ptCenSolid() + bmBrace.vecD(-_Z1) * bmBrace.dD(_Z1) * .5, bmBrace.vecD(-_Z1));
		Point3d pt1 = Line(ptStart + _X1 * dDiameterSinkhole * .5, -_Z1).intersect(plnExternalBrace, 0);
		Point3d pt2 = Line(ptStart - _X1 * dDiameterSinkhole * .5, -_Z1).intersect(plnExternalBrace, 0);
		Point3d ptStartBrace, ptEnd;
		if(_Z1.dotProduct(ptStart-pt1) < _Z1.dotProduct(ptStart-pt2))
		{ 
			ptStartBrace = pt1;
			ptEnd = pt2;
		}
		else
		{ 
			ptStartBrace = pt2;
			ptEnd = pt1;
		}
		ptEnd += _X1 * _X1.dotProduct(ptStart - ptEnd);
		ptStartBrace += _X1 * _X1.dotProduct(ptStart - ptStartBrace) + _Z1 * dDepthBrace;
		
	// Drills and end cut
		// main drill		
		Drill drill (ptStart + _Z1 * dEps, ptEnd, dDiameter * .5);
		bmBrace.addTool(drill);
		bmFemale.addTool(drill);
		
		// sinkhole in female
		Drill sinkHoleFemale (ptStart - _Z1 * dDepth,  ptStart + _Z1 * U(50),dDiameterSinkhole * .5);
		bmFemale.addTool(sinkHoleFemale);
		
		// sinkhole in brace
		Drill sinkholeBrace (ptStartBrace, ptEnd, dDiameterSinkhole * .5);
		bmBrace.addTool(sinkholeBrace);
		
		// end cut
		Vector3d vCut = bmFemale.vecD(bmFemale.ptCen() - bmBrace.ptCen()); vCut.normalize();
		Point3d ptCut = bmFemale.ptCenSolid() - vCut * bmFemale.dD(vCut) * .5;
		Cut cut(ptCut, vCut);
		bmBrace.addTool(cut, true);

		assignToGroups(bmBrace);

		if(bDebug)
		{ 
			ptStart.vis();
			bmFemale.envelopeBody().vis();
			pt1.vis();
			pt2.vis();
			ptCut += _X1 * _X1.dotProduct(ptStart - ptCut);
			// Draw Point3d
			Display dpX (3); double dXl = U(500); Point3d ptX = (ptStartBrace+ptEnd)/2; PLine plTmp (_ZW); plTmp.addVertex(ptX - _XW * dXl * .5); plTmp.addVertex(ptX + _XW * dXl * .5); plTmp.addVertex(ptX); 
			plTmp.addVertex(ptX - _YW * dXl * .5); plTmp.addVertex(ptX + _YW * dXl * .5); dpX.draw(plTmp); plTmp = PLine (_XW); plTmp.addVertex(ptX - _ZW * dXl * .5); plTmp.addVertex(ptX + _ZW * dXl * .5); dpX.draw(plTmp);
			vCut.vis(ptCut);
			ptCut.vis();
		}
		
	// Display
		Display dp(3);
		LineSeg ls (ptStart, ptEnd);
		dp.draw(ls);
		
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
				Element elHW =bmBrace.element(); 
				// check if the parent entity is an element
				if (!elHW.bIsValid())
					elHW = (Element)bmBrace;
				if (elHW.bIsValid()) 
					sHWGroupName=elHW.elementGroup().name();
			// loose
				else
				{
					Group groups[] = _ThisInst.groups();
					if (groups.length()>0)
						sHWGroupName=groups[0].name();
				}		
			}
			
		// add main componnent
			{ 
				String sHWArticleNumber = sMaker;				
				if (sProductName != "")
				{
					if(sMaker != "")
						sHWArticleNumber += " - " + sProductName;
					else
						sHWArticleNumber = sProductName;
				}
				if(sHWArticleNumber == "")
					sHWArticleNumber = scriptName();
				
				String sHWName = sProductName;
				if(sHWName == "")
					sHWName = scriptName();
					
				HardWrComp hwc(sHWArticleNumber, 1); // the articleNumber and the quantity is mandatory
				
				hwc.setManufacturer(sMaker);
				
				hwc.setName(sHWName);
				
				hwc.setGroup(sHWGroupName);
				hwc.setLinkedEntity(bmBrace);	
				hwc.setCategory(T("|Connector|"));
				hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
				
				hwc.setDScaleX(abs(_Z1.dotProduct(ptStart-ptEnd)));
				hwc.setDScaleY(dDiameter);
				hwc.setDScaleZ(0);
			
			// apppend component to the list of components
				hwcs.append(hwc);
			}
		
		// make sure the hardware is updated
			if (_bOnDbCreated)
				setExecutionLoops(2);
						
			_ThisInst.setHardWrComps(hwcs);	
			//endregion
		
	}//endregion
}
#End
#BeginThumbnail
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
&6U10!__9

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