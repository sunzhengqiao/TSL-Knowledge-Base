#Version 8
#BeginDescription
#Versions:
Version 1.3 20.09.2024 HSB-19771: Add support for hsbCLT-Hilti 
1.2 15.03.2023 HSB-18322: Dont generate any group if property is empty
1.0 08.09.2021 HSB-12697: add description

This TSL creates a plan of connectors in relation to a polyline
The polyline can represent the Concrete floor plate where the House will be built
The TSL will create dimensions of the positions of the connectors
User selects the TSLs that need be considered
Only following TSL instances are considered : "Hilti-Verankerung", "Hilti-Stockschraube"
The TSL instance will be assigned at the defined group in the property. 
If the property is left blank the TSL will assign "Hilti Verankerungsplan"
If the group does not exists, the TSL will create it 
Visibility of the plan can then be controlled via turning On/Off the group

1.1 09.09.2021 HSB-12697: Group assignment of the TSL in group "HiltiVerankerungsplan" for controlling visibility Author: Marsel Nakuci


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords Hilti,Plan,Dimension,HCW,HCWL,HSW
#BeginContents
//region <History>
// Automatically saved contents for tsl
// Date & time: Montag, 14. Mai 2012 11:50:38
/// #Versions:
// 1.3 20.09.2024 HSB-19771: Add support for hsbCLT-Hilti , Author Marsel Nakuci
// 1.2 15.03.2023 HSB-18322: Dont generate any group if property is empty Author: Marsel Nakuci
// Version 1.1 09.09.2021 HSB-12697: Group assignment of the TSL in group "HiltiVerankerungsplan" for controlling visibility Author: Marsel Nakuci
// Version 1.0 08.09.2021 HSB-12697: add description Author: Marsel Nakuci
/// <summary Lang=de>
/// This TSL creates a plan of connectors in relation to a polyline
/// The polyline can represent the Concrete floor plate where the House will be built
/// The TSL will create dimensions of the positions of the connectors
/// User selects the TSLs that need be considered
/// Only following TSL instances are considered : "Hilti-Verankerung", "Hilti-Stockschraube"
/// The TSL instance will be assigned at the defined group in the property. 
/// If the property is left blank the TSL will assign "Hilti Verankerungsplan"
/// If the group does not exists, the TSL will create it 
/// Visibility of the plan can then be controlled via turning On/Off the group
/// Dieses TSL erzeugt einen Verankerungsplan in Abhängigkeit zu einer Polylinie
/// </summary>

/// <insert Lang=de>
/// Polylinie und TSL's wählen, Einfügepunkt angeben
/// </insert>


/// History
///<version  value="1.2" date="14may12" author="th@hsbCAD.de">neues darstellungsabhängiges Konzept, neue Kontextbefehle</version>
///<version  value="1.1" date="18apr12" author="th@hsbCAD.de">lösen der Bemassungen über Kontextbefehl möglich</version>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Hilti-Verankerungsplan")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion


// basics and props
//region Constants 
	U(1,"mm");
	double dEps = U(0.1);
	String sLastInserted=T("|_LastInserted|");
	String sArNY[] = { T("|No|"), T("|Yes|")};
//end Constants//endregion	
	

//region Functions
	//region checkHiltiClt
	// gets only thos that are inserted to one panel and point upward in _ZW
	//HSB-19771
	int checkHiltiClt(TslInst _tsl)
	{ 
		int _ok=true;
		// check name
		if(_tsl.scriptName()!="hsbCLT-Hilti")
		{ 
			_ok=false;
			return _ok;
		}
		// check it is at single panel
		Sip _sipsTsl[]=_tsl.sip();
		if(_sipsTsl.length()!=1)
		{ 
			_ok=false;
			return _ok;
		}
		Vector3d _vecUp=_tsl.map().getVector3d("vecUp");
		if(abs(_vecUp.dotProduct(_ZW)-1.0)>dEps)
		{ 
			_ok=false;
			return _ok;
		}
		return _ok;
	}
//End checkHiltiClt//endregion	
//End Functions//endregion 

//region Properties
	PropDouble dTxtH (0,U(70),T("|Text height|"));
	PropInt nColor (0,6,T("|Color|"));	
	PropString sDimStyle(0,_DimStyles,T("|Dimstyle|"));

	PropString sGroup(1,"Hilti Verankerungsplan",T("|Auto group (seperate Level by '\')|"));	
	sGroup.setDescription(T("|Determines the group (seperate level by '\'), e.g. Hilti VerankerungsPlan\Eg\HCW|"));
//End Properties//endregion

	TslInst tslNew;
	Vector3d vUcsX = _XW;
	Vector3d vUcsY = _YW;
	GenBeam gbAr[0];
	Entity entAr[0];
	Point3d ptAr[0];
	int nArProps[0];
	double dArProps[0];
	String sArProps[0];
	Map mapTsl;
	String sScriptname = "hsbTslDim";	


// list of supported connectors
//	String sAllowedConnectors[] = {"BF-Verankerungswinkel Strongtie HD2P x LR".makeUpper(),
//											 "BF-Verankerungswinkel Bilo".makeUpper()};	
											 
	String sAllowedConnectors[] = {"Hilti-Verankerung".makeUpper(),
											 "Hilti-Stockschraube".makeUpper(),
											 "hsbCLT-Hilti".makeUpper()};	
//region bOnInsert
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
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


		EntPLine epl = getEntPLine();
		PLine pl = epl.getPLine();
		_Entity.append(epl);
	
	// select connectors
		PrEntity ssE(T("|Select TSL(s)|"), TslInst());
		Entity ents[0];  		
		if (ssE.go())
	    	ents = ssE.set();			
		for (int i=0; i< ents.length(); i++)
		{
			TslInst tsl = (TslInst)ents[i];
			if (sAllowedConnectors.find(tsl.scriptName().makeUpper())>-1)
				_Entity.append(ents[i]);
		}	
		_Pt0 = getPoint(); // select point	

		return;	
	}
// end on insert	__________________//endregion


// this script supports 2 modes
	// 0 = insert
	// 1 = dim mode
	int nMode = _Map.getInt("mode");

// validate entities
	EntPLine epl;
	TslInst tsls[0];
	for (int i=_Entity.length()-1; i>=0 ; i--) 
	{ 
		Entity ent = _Entity[i];
		if (ent.bIsKindOf(TslInst ()))
		{
			TslInst tsl = (TslInst)ent;
			if(!tsl.bIsValid())
			{ 
				_Entity.removeAt(i);
				continue;
			}
			if(tsl.scriptName()=="hsbCLT-Hilti")
			{ 
				// HSB-19771
				if(!checkHiltiClt(tsl))
				{ 
					_Entity.removeAt(i);
					continue;
				}
			}
		}
	}//next i
	
	
	
	for(int i=0;i<_Entity.length();i++)
	{
		Entity ent = _Entity[i];
		if (ent.bIsKindOf(EntPLine ()))
		{
			epl = (EntPLine )ent;
			setDependencyOnEntity(_Entity[i]);
		}
		else if (ent.bIsKindOf(TslInst ()))
		{
			TslInst tsl = (TslInst )ent;
			if (tsls.find(tsl)<0)
			{
				tsls.append(tsl);
				setDependencyOnEntity(_Entity[i]);
			}
		}
	}

	if (!epl.bIsValid() || tsls.length()<1)
	{
		eraseInstance();
		return;	
	}
	PLine plContour= epl.getPLine();
	plContour.vis(2);
	
// standards
	Vector3d vz = plContour.coordSys().vecZ();	
	_XE.vis(_Pt0,40);
	_YE.vis(_Pt0,50);
vz.vis(_Pt0);
	Vector3d vecRead = _YW-_XW;
	vecRead.normalize();

// display
	Display dp(nColor);
//	dp.showInDispRep("BF Verankerungsplan");
//	dp.showInDispRep("Hilti Verankerungsplan");
	dp.dimStyle(sDimStyle);	
	dp.textHeight(dTxtH);

//region Assign the tsl to a particular group
	String _sGroup = sGroup;
	_sGroup.trimLeft();
	_sGroup.trimRight();
// HSB-18322:
	if(_sGroup!="")
	{ 
	// create the group
//		if(_sGroup=="")
//			sGroup.set("Hilti Verankerungsplan");
		String sGrp = sGroup;
		Group grpCreate(sGrp);
		if(!grpCreate.bExists())
		{ 
			grpCreate.dbCreate();
		}
		grpCreate.addEntity(_ThisInst, false);
	}
//End Assign the tsl to a particular group//endregion 

// the contour
	PlaneProfile ppContour(plContour);
	Point3d pts[] = plContour.vertexPoints(false);	

// loop selected tsl's to collect points on contour
	Point3d ptsA[0],ptsB[0];
	TslInst tslA[0],tslB[0];
//	
	for(int i=0;i<tsls.length();i++)	
	{
	// distinguish between interior and exterior elements
		int bExposed;
		Vector3d vx_,vy_,vz_;
		if(tsls[i].scriptName()!="hsbCLT-Hilti")
		{ 
			// not an hsbCLT-Hilti tsl
			Element el = tsls[i].element();
			ElementWall elWall = (ElementWall)el;
			vx_=el.vecX();
			vy_=el.vecY();
			vz_=el.vecZ();
			if (elWall.bIsValid()) bExposed = elWall.exposed();
			else continue;
		
	// vectors of element
//		Vector3d vx_=el.vecX(),vy_=el.vecY(),vz_=el.vecZ();
		
		// get the map of the connector
			Map map = tsls[i].map();
			Point3d ptRef = tsls[i].ptOrg();
			if (map.hasPoint3d("ptRef"))
				ptRef = map.getPoint3d("ptRef");		
	
		// draw text perp
			Point3d ptTxt = ptRef +vx_*U(80);
			String sTxt = tsls[i].scriptName();
			if (map.hasString("Type"))
				sTxt = map.getString("Type");				
			dp.draw(sTxt,ptTxt,vz_,-vx_,0,0,_kDevice);
	
		// get closest to pline and find according segment
			Point3d ptClosest = plContour.closestPointTo(ptRef);
			if (!bExposed)
			{
				Vector3d vecs[]={vx_,vz_};
				for (int v=0;v<vecs.length();v++)
				{
				// get intersecting points with polyline
					Point3d ptInt[] = plContour.intersectPoints(Plane(ptRef,vecs[v]));
					double dMin=U(1000000);
					for(int p=0;p<ptInt.length();p++)
					{
						double d=Vector3d(ptInt[p]-ptRef).length();
						if (d<dMin)
						{
							dMin=d;
							ptClosest=ptInt[p];	
						}
					}
					if (v==0)
					{
						ptsA.append(ptClosest);	
						tslA.append(tsls[i]);
					}
					else
					{
						ptsB.append(ptClosest);	
						tslB.append(tsls[i]);					
					}
					//PLine pl(ptClosest,ptRef);
					//pl.vis(i);
				}// next v
			}
			else
			{
				ptsA.append(ptClosest);	
				tslA.append(tsls[i]);
	
				ptClosest.vis(2);
				ptRef.vis(20);
				
			// draw the local perp dimline
				DimLine dl(ptClosest-vx_*dTxtH ,vz_,vx_);
				Dim dim(dl,ptClosest,ptRef);
				dim.setReadDirection(vecRead);
				dim.setDeltaOnTop(false);
				dp.draw(dim);
			}
		}
		else if(tsls[i].scriptName()=="hsbCLT-Hilti")
		{ 
			// HSB-19771 an hsbCLT-Hilti tsl
			Sip sipsTsl[]=tsls[i].sip();
			if(sipsTsl.length()!=1)
			{ 
				// unexpected
				continue;
			}
			Sip sipTsl=sipsTsl[0];
			
			Element el=sipTsl.element();
			if(el.bIsValid())
			{ 
				vx_=el.vecX();
				vy_=el.vecY();
				vz_=el.vecZ();
			}
			else
			{ 
				Vector3d vecZsipTsl=sipTsl.vecZ();
				if(!vecZsipTsl.isPerpendicularTo(_ZW))
				{ 
					continue;
				}
				vx_=_ZW.crossProduct(vecZsipTsl);vx_.normalize();
				if(vx_.dotProduct(_XW)<-dEps)
				{ 
					vx_*=-1;
				}
				else if(abs(vx_.dotProduct(_XW))<dEps)
				{ 
					if(vx_.dotProduct(_YW)<-dEps)
					{ 
						vx_*=-1;
					}
				}
				vy_=_ZW;
				vz_=vx_.crossProduct(vy_);
				vx_.vis(_Pt0,1);
			}
			
			Point3d ptRefs[0];
			Map mapTsl=tsls[i].map();
			if(mapTsl.hasPoint3dArray("ptsDis"))
			{ 
				ptRefs.append(mapTsl.getPoint3dArray("ptsDis"));
			}
			for (int p=0;p<ptRefs.length();p++) 
			{ 
				Point3d ptRef=ptRefs[p];
			// draw text perp
				Point3d ptTxt = ptRef +vx_*U(80);
				String sTxt = tsls[i].scriptName();
//				if (map.hasString("Type"))
//					sTxt = map.getString("Type");
				sTxt="HCW-L";
				dp.draw(sTxt,ptTxt,vz_,-vx_,0,0,_kDevice);
	
			// get closest to pline and find according segment
				Point3d ptClosest = plContour.closestPointTo(ptRef);
				ptsA.append(ptClosest);	
				tslA.append(tsls[i]);
	
				ptClosest.vis(2);
				ptRef.vis(20);
				
			// draw the local perp dimline
				DimLine dl(ptClosest-vx_*dTxtH ,vz_,vx_);
				Dim dim(dl,ptClosest,ptRef);
				dim.setReadDirection(vecRead);
				dim.setDeltaOnTop(false);
				dp.draw(dim);
			}//next p
		}
	}// next i tsl
//	return;
// mode 0
if (nMode==0)
{	
// collect the segments
	LineSeg lsSegments[0];
	DimLine dlExterior[0], dlInterior[0];
	
	for(int p=0;p<pts.length()-1;p++)
	{
		Point3d ptStartEnd[] = {pts[p],pts[p+1]};
		Point3d ptMid = (pts[p]+pts[p+1])/2;
		Vector3d vxSeg = pts[p+1]-pts[p];
		vxSeg.normalize();
		Vector3d vySeg = vxSeg.crossProduct(vz);
		vySeg.normalize();
		if (ppContour.pointInProfile(ptMid-vySeg*dEps)==_kPointOutsideProfile)
		{		
			vySeg*=-1;
			vxSeg*=-1;
			ptStartEnd.swap(0,1);
		}
		lsSegments.append(LineSeg(ptStartEnd[0],ptStartEnd[1]));
		//vxSeg.vis(ptMid,1);
		//vySeg.vis(ptMid,3);			
	}	

// loop segments and find tsls and/or points associated with it
	for(int j=0;j<lsSegments.length();j++)	
	{
	// dimline of this segment
		Point3d pt1=lsSegments[j].ptStart(), pt2=lsSegments[j].ptEnd();
		Vector3d vx=pt2-pt1;
		vx.normalize();
		Vector3d vy=vx.crossProduct(-vz);
//		vx.vis(_Pt0,6);	
//		pt1.vis(1);
//		pt2.vis(2);
		(-vy).vis(_Pt0,60);	

	// declare linked tsl's
		TslInst tslLinked[0];
		//vx.vis(lsSegments[j].ptMid(),1);
		//vy.vis(lsSegments[j].ptMid(),3);
		vecRead.vis(lsSegments[j].ptMid(),2);
	
	// points in vecZ of the element
		for(int p=0;p<ptsA.length();p++)
			if (lsSegments[j].distanceTo(ptsA[p])<dEps)
				tslLinked.append(tslA[p]);

	// points in vecX of the element
		for(int p=0;p<ptsB.length();p++)
			if (lsSegments[j].distanceTo(ptsB[p])<dEps)
				tslLinked.append(tslB[p]);

	// offset to pline
		Point3d pt0 = _Pt0;
		Point3d ptNext  = plContour.closestPointTo(pt0);
		pt0.transformBy(vz*vz.dotProduct(ptNext-pt0));
		double dOffset=Vector3d (ptNext-pt0).length();

		mapTsl = Map();
		mapTsl.setInt("mode",1);
		entAr.setLength(0);
		ptAr.setLength(0);
		
		ptAr.append(pt1-vy*dOffset);
		ptAr.append(pt1);
		ptAr.append(pt2);
	// store points absolute
		for (int i=1; i< ptAr.length(); i++)
			mapTsl.setVector3d("v"+(i-1) , ptAr[i] - _PtW);
		
		entAr.append(epl);
		for (int i=0; i< tslLinked.length(); i++)
			entAr.append(tslLinked[i]);
		nArProps.setLength(0);
		nArProps.append(nColor);
		dArProps.setLength(0);
		dArProps.append(dTxtH);
		sArProps.setLength(0);
		sArProps.append(sDimStyle);
		sArProps.append(sGroup);
		
		tslNew.dbCreate(scriptName(),vx,vy,gbAr,entAr,ptAr,
			nArProps,dArProps,sArProps,_kModelSpace,mapTsl); // create new instance	
//		if (tslNew.bIsValid())
//			tslNew.setPropValuesFromCatalog(T("|_LastInserted|"));

	}//next j
	
// erase the caller
	eraseInstance();
	return;
}// end mode 0

//_________________________________________________________________________________________________________________________
	else if (nMode==1)
	{
	// add  triggers	
		String sTriggerAddTsl = "Verankerung hinzufügen";
		addRecalcTrigger(_kContext, sTriggerAddTsl );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddTsl )
		{
			PrEntity ssE(T("|Select TSL(s)|"), TslInst());
			Entity ents[0];  		
			if (ssE.go())
		    	ents = ssE.set();			
			for (int i=0; i< ents.length(); i++)
			{
				TslInst tsl = (TslInst)ents[i];
				if (sAllowedConnectors.find(tsl.scriptName().makeUpper())>-1 && _Entity.find(ents[i])<0)			
					_Entity.append(ents[i]);
			}
			setExecutionLoops(2);			
		} 	

		String sTriggerRemoveTsl = "Verankerung entfernen";
		addRecalcTrigger(_kContext, sTriggerRemoveTsl );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveTsl )
		{
			PrEntity ssE(T("|Select TSL(s)|"), TslInst());
			Entity ents[0];  		
			if (ssE.go())
		    	ents = ssE.set();			
			for (int i=0; i< ents.length(); i++)
			{
				TslInst tsl = (TslInst)ents[i];
				int n = _Entity.find(ents[i]);
				if (sAllowedConnectors.find(tsl.scriptName().makeUpper())>-1 && n>-1)			
					_Entity.removeAt(n);
			}
			setExecutionLoops(2);
		}	

		String sTriggerDummy = "------------------";
		addRecalcTrigger(_kContext, sTriggerDummy );

	// trigger: add dim point
		String sTriggerAddPoints = T("|Add Points|");
		addRecalcTrigger(_kContext, sTriggerAddPoints );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddPoints ) 
		{
			int nStartGrip = _PtG.length();
			while (1) {
				PrPoint ssP2("\n" + T("|Select point|")); 
				if (ssP2.go()==_kOk) // do the actual query
					_PtG.append(ssP2.value()); // retrieve the selected point	
				else // no proper selection
					break; // out of infinite while	
			}
			// store all grips in map
			for (int i = nStartGrip; i < _PtG.length(); i++)
				_Map.setVector3d("v" + i, _PtG[i] - _PtW);
		}
	// trigger: delete dim point
		String sTriggerDeletePoints = T("|Delete Points|");
		addRecalcTrigger(_kContext, sTriggerDeletePoints );
		if (_bOnRecalc && _kExecuteKey==sTriggerDeletePoints ) 
		{
			Point3d ptDelete[0];
			while (1) {
				PrPoint ssP("\n" + T("|Select point|")); 	
				if (ssP.go()==_kOk) // do the actual query
				{
					Point3d ptRef = ssP.value();
					int n;
					double dDist = U(100000);
					for (int i = 0; i < _PtG.length(); i++)
						if (abs(_XE.dotProduct(_PtG[i]-ptRef ))< dDist )
						{
							n=i;
							dDist = abs(_XE.dotProduct(_PtG[i]-ptRef));
						}	
					if (dDist < U(1000))
					{
						_Map.removeAt("v"+n, TRUE);
						_PtG.removeAt(n);
					}
				}
				else
					break;
			}
		}

	// relocate grip if _Pt0 has moved
		if (_kNameLastChangedProp == "_Pt0")
			for (int i = 0; i < _Map.length(); i++)
				if (_Map.hasVector3d("v" +i) && _PtG.length() > i)
					_PtG[i] =  _PtW + _Map.getVector3d("v" +i);
	
	
	// store all vectors to grips in map
		for (int i = 0; i < _PtG.length(); i++)
			if (_kNameLastChangedProp == "_PtG" + i)
				_Map.setVector3d("v" + i, _PtG[i] - _PtW);	
	
	
		DimLine dl1(_Pt0 ,_XE,_YE);
	// dimpoints
		Point3d ptDim[0];		
		ptDim.append(_PtG);
		ptDim.append(ptsA);
		ptDim.append(ptsB);
		
	// display gouped dimline	
		Dim dim(dl1,ptDim,"<>","<>",_kDimBoth);
		dim.setReadDirection(vecRead);
		if (_YE.dotProduct(vecRead)<0) dim.setDeltaOnTop(false);
		dp.draw(dim);	
	}// end mode 1




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
        <int nm="BreakPoint" vl="251" />
        <int nm="BreakPoint" vl="410" />
        <int nm="BreakPoint" vl="412" />
        <int nm="BreakPoint" vl="446" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19771: Add support for hsbCLT-Hilti" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="9/20/2024 3:07:46 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18322: Dont generate any group if property is empty" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="3/15/2023 2:08:59 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12697: Group assignment of the TSL in group &quot;HiltiVerankerungsplan&quot; for controlling visibility" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="9/9/2021 8:49:10 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12697: add description" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="9/8/2021 12:58:02 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End