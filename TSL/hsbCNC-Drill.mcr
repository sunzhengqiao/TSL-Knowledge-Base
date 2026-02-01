#Version 8
#BeginDescription
version  value="2.4" date="26jun20" author="thorsten.huck@hsbcad.com"
HSB-8106 custom layer assignment added 

new properties to display properties
special format variable @(Elevation) will resolve the elevation of the drill in relation to the wall base line

debug controller added
new properties to add optional sink hole 

This TSL creates an element drill or defines an element drill in a replicator definition











#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 5
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Dieses TSL erzeugt eine CNC Bohrung in einer Zone an einem Element bzw. definiert eine Bohrung innerhalb einer Replikations-Definition
/// </summary>
/// <insert Lang=de>
/// This TSL creates an element drill or defines an element drill in a replicator definition
/// </insert>

/// History
///<version  value="2.5" date="26jun20" author="thorsten.huck@hsbcad.com"> HSB-8106 custom layer assignment added II </version>
///<version  value="2.4" date="26jun20" author="thorsten.huck@hsbcad.com"> HSB-8106 custom layer assignment added </version>
///<version  value="2.3" date="05oct18" author="thorsten.huck@hsbcad.com"> new properties to display properties, special format variable @(Elevation) will resolve the elevation of the drill in relation to the wall base line </version>
///<version  value="2.2" date="13jul18" author="thorsten.huck@hsbcad.com"> debug controller added </version>
///<version  value="2.1" date="22mar17" author="thorsten.huck@hsbcad.com"> insert suppports new properties to add optional sink hole </version>
///<version  value="2.0" date="21mar17" author="thorsten.huck@hsbcad.com"> new properties to add optional sink hole </version>
///<version  value="1.9" date="06apr16" author="thorsten.huck@hsbcad.com"> property names updated </version>
///<version  value="1.8" date="10feb15" author="th@hsbCAD.de"> validation of location with replicator dependency fixed </version>
///<version  value="1.7" date="21jan15" author="th@hsbCAD.de"> bugfix solid operations also done on zones below the selected if depth exceeds current zone thickness </version>
///<version  value="1.6" date="21jan15" author="th@hsbCAD.de"> solid operations also done on zones below the selected if depth exceeds current zone thickness </version>
///<version  value="1.5" date="17nov14" author="th@hsbCAD.de"> replicator defined outmost zones fixed </version>
///<version  value="1.4" date="13nov14" author="th@hsbCAD.de"> location solid subtraction fixed </version>
///<version  value="1.3" date="12nov14" author="th@hsbCAD.de"> insert mechanism enhanced, negative values of depth are taken as an additional tool depth of selected zone thickness </version>
///<version  value="1.0" date="25jun13" author="th@hsbCAD.de"> initial</version>


// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));
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
	//endregion
			
	int nZones[0];
	if (_Element.length()>0)
	{
		Element el = _Element[0];
		nZones.append(-99);
		for (int i=-5;i<6;i++)	
			if (el.zone(i).dH()>dEps && i!=0)
				nZones.append(i);
		nZones.append(99);		
	}
	else
	{
		int n[] = {-99,-5,-4,-3,-2,-1,1,2,3,4,5,99};	
		nZones=n;
	}
	String sZoneName = T("|Zone|");
	PropInt nZone(nIntIndex++,nZones,sZoneName);
	nZone.setCategory(category);
		
	String sZoneRelations[]= {T("|Standard|"),T("|Relative|"),T("|Exclusive|")};
	PropString sZoneRelation(nStringIndex++,sZoneRelations,T("|Relation|"));
	sZoneRelation.setCategory(category);	
	
	category = T("|Drill|");
	String sDepthName =T("|Depth|");
	PropDouble dDepth(nDoubleIndex++,U(20),sDepthName);
	dDepth.setDescription(T("|The Depth of the CNC Operation, 0 = byZone, negative value = byZone + additional absolute value|"));
	dDepth.setCategory(category);
	
	String sDiameterName =T("|Diameter|");
	PropDouble dDiameter(nDoubleIndex++,U(68),sDiameterName );
	dDiameter.setDescription(T("|The Diameter of the CNC Operation|"));
	dDiameter.setCategory(category);
	
	String sToolingIndexName=T("|Tooling index|");
	PropInt nToolingIndex(nIntIndex++,1,sToolingIndexName);
	nToolingIndex.setCategory(category);

	category = T("|Drill|") + " 2";
	String sDepth2Name =T("|Depth|") + " ";
	PropDouble dDepth2(nDoubleIndex++,U(0),sDepth2Name);
	dDepth2.setDescription(T("|The Depth of the CNC Operation, 0 = byZone, negative value = byZone + additional absolute value|"));
	dDepth2.setCategory(category);
	
	String sDiameter2Name =T("|Diameter|")+ " ";
	PropDouble dDiameter2(nDoubleIndex++,U(0),sDiameter2Name );
	dDiameter2.setDescription(T("|The Diameter of the CNC Operation|"));
	dDiameter2.setCategory(category);
	
	String sToolingIndex2Name=T("|Tooling index|")+ " ";
	PropInt nToolingIndex2(nIntIndex++,1,sToolingIndex2Name);
	nToolingIndex2.setCategory(category);
	
	category = T("|Display|");
	String sDescriptionName=T("|Description|");	
	PropString sDescription(nStringIndex++, "", sDescriptionName);	
	sDescription.setDescription(T("|Defines the format of the composed value.|")+
	TN("|Samples|")+
	TN("   @(Diameter)@(Depth)")+
	TN("   @(Label:L2) |the first two characters of Label|")+
	TN("   @(Label:T1; |the second part of Label if value is separated by blanks, i.e. 'EG AW 2' will return AW'|)")+
	TN("   @(Width:RL1) |the rounded value of width with one decimal.|")+
	TN("R |Right: Takes the specified number of characters from the right of the string.|")+
	TN("L |Left: Takes the specified number of characters from the left of the string.|")+
	TN("S |SubString: Given one number will take all characters starting at the position (zero based).|")+
	T(" |Given two numbers will start at the first number and take the second number of characters.|")+
	TN("T |​Tokeniser: Returns the member of a delimited list using the specified index (zero based). A delimiter can be specified as an optional parameter with the default delimiter being the semcolon character..|")+
	TN("# |Rounds a number. Specify the number of decimals to round to. Trailing zero's are removed.|")+
	TN("RL |​Round Local: Rounds a number using the local regional settings..|")	+
	TN("A |​Specifies the alias| ") + ";"+"<"+T("|Alias Entry|")+">");
	sDescription.setCategory(category);
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(80), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the text height|"));
	dTextHeight.setCategory(category);
	
	
	
	
	//_kExecuteKey	="BlockDefMode";
// on insert
	if (_bOnInsert)
	{		
		int bBlockDefMode;
		if (_kExecuteKey.find("BlockDefMode",0)>-1)bBlockDefMode=true;
		if (insertCycleCount()>1) { eraseInstance(); return; }		
			
	// declare arrays for tsl cloning
		TslInst tslNew;
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		GenBeam gbAr[0];
		Entity entAr[1];
		Point3d ptAr[1];
		int nArProps[0];
		double dArProps[0];
		String sArProps[0];
		Map mapTsl;
		String sScriptname = scriptName();		

		Vector3d vecZ=_ZU;
		
	// flag this cnc line not to be deleted on bOnElementDeleted		
		mapTsl.setInt("customInsert", true);	
		
	//  model mode	
		if(!bBlockDefMode)
		{
		// analyse a potential execute key
			int bIsValidEntry; // a flag which indicates that the given catalog entry exists
			if (_kExecuteKey.length()>0)
			{
			// get tokens
				String sEntry =  _kExecuteKey;
				
			// query potential catalog entry names
				String sEntries[] = TslInst().getListOfCatalogNames(scriptName());					
				if (sEntries.find(sEntry)>-1)
				{
					bIsValidEntry=true;
					setPropValuesFromCatalog(sEntry);
				}
			}

			PrEntity ssE(T("|Select a sheet of the desired zone or an element|") , Sheet());
			ssE.addAllowedClass(ElementWall());
			ssE.addAllowedClass(ElementRoof());
			Entity ents[0];
			if (ssE.go())
				ents = ssE.set();
			
		// the main entities	
			Sheet sh;
			Element el;
		// take the first sheet or element in the array	
			for (int e=0;e<ents.length();e++)
			{
				if (ents[e].bIsKindOf(Sheet()))
				{
					sh = (Sheet)ents[e];	
					break;
				}
				else if (ents[e].bIsKindOf(Element()))
				{
					el = (Element)ents[e];	
					break;
				}
			}
		// preset dialog values by the selected sheet and its properties
			if (sh.bIsValid())
			{
				el = sh.element();
				if (!el.bIsValid())
				{
					reportMessage(TN("|Sheet must belong to an element.|") + " " + T("|Tool will be deleted.|"));
					eraseInstance();
					return;	
				}
				_Element.append(el);
				nZone.set(sh.myZoneIndex());
				ElemZone elzo = el.zone(nZone);

				vecZ = _Element[0].zone(nZone).vecZ();
			}

			setCatalogFromPropValues(sLastInserted);
			
		// show dialog if no catalog entry used
			if (!bIsValidEntry)	
				showDialog(sLastInserted);		
			
		// if the element is valid but the sheet isn't, set the element	
			if (!sh.bIsValid() && el.bIsValid())
			{
				_Element.append(el);
				ElemZone elzo = el.zone(nZone);	
				vecZ = _Element[0].zone(nZone).vecZ();
			}			
			if (!sh.bIsValid() && !el.bIsValid())
			{	
				reportMessage(TN("|Sheet or element required.|") + " " + T("|Tool will be deleted.|"));
				eraseInstance();
				return;	
			}	
			entAr[0] =_Element[0];
				
		}
	// block def mode	
		else
		{
			setOPMKey("Replicator");
			mapTsl.setInt("isBlockDef",bBlockDefMode);// 1 means block definition mode
			showDialog();		
					
		}

	// collect properties
		nArProps.append(nZone);
		nArProps.append(nToolingIndex);
		nArProps.append(nToolingIndex2);
		
		dArProps.append(dDepth);
		dArProps.append(dDiameter);
		dArProps.append(dDepth2);
		dArProps.append(dDiameter2);
		
		sArProps.append(sZoneRelation);

	// multiple insert
		Point3d ptLast;
		EntPLine epl;	
		while (1) 
		{
			PrPoint ssP2("\n" + T("|Pick insertion point|")); 	
			if (ssP2.go()==_kOk) 
			{
				ptAr[0] = ssP2.value();
				tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
					nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance				
			}
			// no proper selection
			else 
			{ 		
				break; // out of infinite while
			}
		}

			
	
		eraseInstance();
		return;			
	}
// end on insert


// erase
	if (_bOnElementDeleted && !_Map.getInt("customInsert") )
	{
		eraseInstance();
		return;	
	}
	
	if (_bOnDbCreated)setExecutionLoops(2);

// get the defining entity if set
	TslInst tslBlockRef, tslModelRep;
	Map mapReplicator;
	CoordSys csDefine(_Pt0, _XE,_YE,_ZE);
	for (int i=0;i<_Entity.length();i++)
	{
		Entity ent = _Entity[i];		
		if (ent.bIsKindOf(TslInst()))
		{
			TslInst tsl = (TslInst) ent;
			Map map = tsl.map();
			String s =  scriptName();
			if (s=="__HSB__PREVIEW")s="hsbCNC-Drill";
			if (tsl.scriptName() == s && map.getInt("isBlockDef"))
			{
				//reportMessage("\n" + scriptName() + " has a block def dependent TSL " + tsl.scriptName());
				setDependencyOnEntity(ent);
				tslBlockRef= tsl;
				
				if (map.hasMap("Replicator"))
				{
					mapReplicator  = map.getMap("Replicator");
					//_Map.setPLine("pline",mapReplicator.getPLine("pline"));
				}
			}	
			else if (!map.getInt("isBlockDef"))
			{
				//reportMessage("\nmodel ref dependent TSL " + tsl.scriptName());
				setDependencyOnEntity(ent);
				tslModelRep= tsl;
				csDefine = CoordSys(map.getPoint3d("ptOrg"), map.getVector3d("vecX"), map.getVector3d("vecY"), map.getVector3d("vecZ"));
			// store this entity in map to validate it when defining entity is erased
				_Map.setEntity("DefiningEntity", ent);					
			}
		}
	}

// mode
	// 0 = model cnc
	// 1 = replicator defining cnc 
	int bIsBlockDef = _Map.getInt("isBlockDef");

// declare standards
	Vector3d vecX,vecY,vecZ;
	CoordSys cs;
	Point3d ptLocation, ptOrg;
		
// tool type
	int nSgn = nZone/abs(nZone);
	int nZoneRelation = sZoneRelations.find(sZoneRelation);
	csDefine.vis(nSgn);	


// display (model mode is silent)
	Display dp(_ThisInst.color());
	

//region ModelMode
	Element el;
	if (bIsBlockDef<1)
	{	
		if (_Element.length()<1) 
		{
			reportMessage("\n" + scriptName() + " has no valid element");		
			eraseInstance();				
			return;
		}
		el = _Element[0];
		cs = el.coordSys();
		ptOrg = cs.ptOrg();
		vecX=cs.vecX();
		vecY=cs.vecY();
		vecZ=cs.vecZ();
		//_Pt0 = ptOrg;

	// declare a variable for the zone in respect of the option that the zone could be relational to the location of the parent object
		int nThisZone = nZone;
		
	// find outmost zone
		if (abs(nThisZone)==99)
		{
			int nSgnThis = nThisZone /abs(nThisZone);
			int x = 5;
			for (int i=x;i>0;i--)
			{
				nThisZone = i*nSgnThis;
				ElemZone elzo = el.zone(nThisZone);	
				if (elzo.dH()>dEps)break;	
			}			
		}
		ElemZone elzo = el.zone(nThisZone);
		
	// check zone relations	
		if(nZoneRelation==1 && !vecZ.isCodirectionalTo(csDefine.vecZ()))
		{
			nThisZone *=-1;
		// validate this zone	
			int nSgnThis = nThisZone /abs(nThisZone);
			int x = abs(nThisZone);
			for (int i=x;i>0;i--)
			{
				nThisZone = i*nSgnThis;
				elzo = el.zone(nThisZone);	
				if (elzo.dH()>dEps)break;	
			}	
		}
	// exclusive zone relation: the tool is only allowed on the specified zone. if this does not match the current alignment the tool will be deleted	
		else if(nZoneRelation==2)
		{
			int nSgnZone = nZone /abs(nZone);
			int nSgnThis =1;
			if (!vecZ.isCodirectionalTo(csDefine.vecZ()))nSgnThis *=-1;
			if (nSgnThis!=nSgnZone)
			{
				reportMessage("\n" + T("|CNC Tool will be removed due to exclusive zone relation.|"));
				eraseInstance();
				return;	
			}
			
		} 

	// assigning
		if (projectSpecial().find("Lux", 0, false) >- 1)
			assignToElementGroup(el,TRUE, 0,'E');
		else
			assignToElementGroup(el,TRUE, nThisZone,'E');	

	// the depth of the cnc operation
		double dZoneThickness = elzo.dH();
		double dThisDepth = dDepth;
		if (dDepth==0)
			dThisDepth = dZoneThickness ;
		else if (dDepth<0)
			dThisDepth = dZoneThickness +abs(dDepth);

		double dThisDepth2 = dDepth2;
		if (dDepth2==0)
			dThisDepth2 = dZoneThickness ;
		else if (dDepth2<0)
			dThisDepth2 = dZoneThickness +abs(dDepth2);
		


	// distinguish by max depth
		double dMaxDepth = dThisDepth>dThisDepth2?dThisDepth:dThisDepth2;
		double dMaxDiameter = dDiameter>dDiameter2?dDiameter:dDiameter2;

	// in case the depth exceeds zone thickness collect genbeams of intersecting below zones
		GenBeam gbsUnder[0];
		if (dMaxDepth>dZoneThickness+dEps)
		{
			double dCumulatedZoneThickness= dZoneThickness;
			for (int i=abs(nThisZone)-1;i>0;i--)
			{
				int z = i*nSgn;
				double dH2=el.zone(i).dH();
				gbsUnder.append(el.genBeam(z));
				dCumulatedZoneThickness+=dH2;
				if (dCumulatedZoneThickness>=dMaxDepth) 
					break;
			}
		}



	// edit in place
	/*
		int bLink = _Map.getInt("Link2Replicator");
		String sTriggerEdit= T("|Edit in Place|");
		if (bLink )sTriggerEdit= T("|Link to Definition|");
		addRecalcTrigger(_kContext, sTriggerEdit);
		if (_bOnRecalc && _kExecuteKey==sTriggerEdit) 
		{
			if (bLink )
				bLink =false;
			else
				bLink =true;
			_Map.setInt("Link2Replicator", bLink );	
			setExecutionLoops(2);
		}
		// consume the replicator map
		if (!bLink )mapReplicator= Map();	
	*/

		
		if (!mapReplicator.hasVector3d("vecOrg"))
			ptLocation= _Pt0-elzo.vecZ()*(elzo.vecZ().dotProduct(_Pt0-elzo.ptOrg())-elzo.dH());
		else
		{
			Vector3d vecOrg = mapReplicator.getVector3d("vecOrg");
			
			CoordSys cs2ms;
			Map mapModelRep = tslModelRep.map();
			cs2ms.setToAlignCoordSys(_PtW,_XW,_YW,_ZW,mapModelRep.getPoint3d("ptOrg"), mapModelRep.getVector3d("vecX"),mapModelRep.getVector3d("vecY"),mapModelRep.getVector3d("vecZ"));	
			vecOrg .transformBy(cs2ms);
						
			ptLocation = csDefine.ptOrg()+vecOrg;
				
		}
		_Pt0 = ptLocation;
		
	// add tools
	
		int bAdd1 = (dThisDepth>dEps && dDiameter>dEps) && (dDiameter2<dDiameter || (dDiameter2>0 && dThisDepth>dThisDepth2));
		int bAdd2 = (dThisDepth2>dEps && dDiameter2>dEps) && (dDiameter!=dDiameter2 && dDiameter2>0 && dThisDepth!=dThisDepth2);
		if ( bAdd1 || bAdd2)
		{
		// prerequisites of solid tool
			PLine plCirc;
			Body bd;		
		
		
		// elem tool
			if (bAdd1)
			{
				ElemDrill drill(nThisZone, ptLocation, vecZ, dThisDepth ,dDiameter, nToolingIndex);
				el.addTool(drill);
				
				plCirc.createCircle(ptLocation,vecZ, dDiameter/2 );	
				plCirc.vis(2);	
				bd = Body(plCirc,vecZ*(dEps+dThisDepth*2),0 );	
				
			}
			if (bAdd2)
			{
				ElemDrill drill2(nThisZone, ptLocation, vecZ, dThisDepth2 ,dDiameter2, nToolingIndex2);
				el.addTool(drill2);
				
				plCirc.createCircle(ptLocation,vecZ, dDiameter2/2 );	
				plCirc.vis(3);	
				bd.addPart(Body(plCirc,vecZ*(dEps+dThisDepth2*2),0));				
			}			
			
		// collect sheets
			Sheet sheets[] = el.sheet(nThisZone);	
			
		// build a planeProfile of all sheets to validate location
			if (_bOnRecalc || _kNameLastChangedProp=="_Pt0" || _kNameLastChangedProp==sZoneName ||_bOnDebug)
			{
				PlaneProfile pp;
				for (int i=0;i<sheets.length();i++)
				{
					if (pp.area()<pow(dEps,2))
						pp = sheets[i].profShape();
					else
						pp.unionWith(sheets[i].profShape());
				}
				pp.vis(5);
				pp.shrink(-dMaxDiameter);
				
			// invalid
				if (_bOnDebug)
				{
					pp.transformBy(vecZ*U(300));
					pp.vis(2);
				}
				if (pp.pointInProfile(_Pt0)==_kPointOutsideProfile)
				{
					reportMessage("\n" + T("|CNC Tool will be removed due to location.|"));
					eraseInstance();
					return;		
				}	
			}	
			

			GenBeam gbsSolidOperation[0];
			for (int i=0;i<sheets.length();i++)
				gbsSolidOperation.append((GenBeam)sheets[i]);
			gbsSolidOperation.append(gbsUnder);	
			
			SolidSubtract sosu(bd,_kSubtract);
			sosu.cuttingBody().vis(3);
			sosu.addMeToGenBeamsIntersect(gbsSolidOperation);				
		}
		
	// resolve variables of description
		String sText = _ThisInst.formatObject(sDescription);
		{
			String _sText = sText;
			_sText.makeLower();
			int n = _sText.find("@(elevation)", false);
			if (n>-1)
			{ 
				String sLeft = sText.left(n);
				String sRight= sText.right(sText.length()-n-12);
				double dElevation = vecY.dotProduct(_Pt0 - ptOrg);
				sText = sLeft + String().formatUnit(vecY.dotProduct(_Pt0 - ptOrg), 2, 0)+sRight;	
			}
			
		
			
		}
	// get text lines
		String sTexts[] = sText.tokenize("\\n");
		if (projectSpecial().find("Lux", 0, false) >- 1)
				dp.elemZone(el, 0, 'I');
	// draw
		// add grip if not present
		if (sText.length()>0)
		{
			if( _PtG.length()<1)
				_PtG.append(_Pt0 + (vecX - vecY) * .5 * (dDiameter + .2*dTextHeight));
			Point3d pt = _PtG[0];
			double dXFlag = vecX.dotProduct(_Pt0-pt)<0?1:-1;
			double dYFlag = vecY.dotProduct(_Pt0-pt)<0?1:-1;
			//if (dYFlag > 0)pt.transformBy(vecY * (sTexts.length() - 1.5) * dTextHeight);
			for (int i=0;i<sTexts.length();i++) 
			{ 
				dp.draw(sTexts[i], pt, vecX, vecY, dXFlag, dYFlag);			
				if(dYFlag<0)dYFlag-=3; 
				else dYFlag += 3;

			}//next i			
		}
	}// end if model mode		
//endregion End ModelMode
// block definition mode
	else
	{	
		

		ptLocation= _Pt0;
		vecX=_XE;
		vecY=_YE;
		vecZ=_ZE;
	// publish to map
		Map mapReplicator;
		mapReplicator.setVector3d("vecOrg", _Pt0-_PtW);
		_Map.setMap("Replicator", mapReplicator);
		
	// set text height	
		double dSize = U(20);
		if (dDiameter/4<dSize && dDiameter>0) dSize = dDiameter/5;
		dp.textHeight(dSize);

	// draw
		dp.draw(nZone,ptLocation, vecX,vecY, 0,3);
		dp.draw(sZoneRelation.left(1).makeUpper(),ptLocation, vecX,vecY, 0,-3);
		dp.draw(dDepth,ptLocation, vecX,vecY, -1.75,0);
		dp.draw("Ø" + dDiameter,ptLocation, vecX,vecY, 1.2,0);			

		PLine plCirc;
		plCirc.createCircle(ptLocation,vecZ, dDiameter/2 );
		dp.draw(plCirc);
		plCirc.transformBy(-vecZ*dDepth);	
		dp.draw(plCirc);
		dp.draw(PLine(ptLocation,ptLocation-vecZ*dDepth));
		plCirc.createCircle(ptLocation,vecZ, U(1) );
		dp.draw(PlaneProfile(plCirc), _kDrawFilled);
		
		
	// trigger show only linekd entities	
		String sTriggerHide = T("|Hide Definition|");
		addRecalcTrigger(_kContext, sTriggerHide );
		
		if (_bOnRecalc && ( _kExecuteKey==sTriggerHide ||  _kExecuteKey==sDoubleClick))
		{
			_ThisInst.setIsVisible(false);
			setExecutionLoops(2);
			return;
		}		
		
	}	
	









#End
#BeginThumbnail
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
9XEAB`X6(!1^E36JU()7>_8JE3A+9?>?_V9;C
`










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
  <lst nm="TslInfo">
    <lst nm="TSLINFO" />
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End