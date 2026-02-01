#Version 8
#BeginDescription
Add a PunchMarker tool to the sip that gets translated into a cnc curve on the child panel if a PunchMarker tool is present in the machine configuration.

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 1
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <History>//region
/// <version  value="1.0" date="20Aug13" author="KR">Initial version</version>
/// <version  value="1.1" date="31Oct13" author="KR">Modified position of pline to surface of sip.</version>
/// <version  value="1.2" date="29Apr20" author="david.delombaerde@hsbcad.com"> Add maprequest so that punchmarker is showed in Shopdrawings. Add posibility to recreate punchmarker tool on Masterpanel.</version>
/// </History>

/// <insert Lang=en>
/// On insert, select the sip, and the pline. Set the property value vertex distance to specify
/// the punch marker interdistance.
/// </insert>

/// <summary Lang=en>
/// Add a PunchMarker tool to the sip that gets translated into a cnc curve on the 
/// child panel if a PunchMarker tool is present in the machine configuration.
/// If the property vertex distance is set to 0, punches are placed at the vertex locations 
/// of the PLine. In case the vertex distance is set, punches are placed using this value.
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ScriptName")) TSLCONTENT
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
//end constants//endregion

//region Properties
		
	PropDouble vertexRadius(0, U(20), T("|Vertex display radius|"));
	PropDouble vertexDistance(1, U(0), T("|Vertex distance|"));

//End Properties//endregion 

if (_bOnInsert) {
	
	//region Version 1.1
		
		//_GenBeam.append(getSip());
		//_Entity.append(getEntPLine(TN("|Select tool path|")));	
		
	//End Version 1.1//endregion 
		
	//Prompt user to select Panel or to select a Masterpanel
	PrEntity ssE(TN("|Select a Sip or select MasterPanel|"), GenBeam());
	ssE.addAllowedClass(MasterPanel());
	
	Entity ents[0];
	
	// Collect selected entities
	if(ssE.go())
		ents.append(ssE.set());
	
	// Try to cast _Entity tot GenBeam
	GenBeam gb = (GenBeam)ents[0];
	// Try to cast _Entity to MasterPanel
	MasterPanel mp = (MasterPanel)ents[0];
			
	// Set int if handling with MasterPanel
	int bIsMasterPanel = 0;
	
	if (gb.bIsValid())
	{ 		
		_GenBeam.append(gb);
		_Entity.append(getEntPLine(TN("|Select tool path|")));
	}
	else if(mp.bIsValid())
	{ 	
		bIsMasterPanel = 1;
		_Entity.append(mp);		
	}
	
	// create TSL
	TslInst tslNew;								Vector3d vecXTsl= _XW;						Vector3d vecYTsl= _YW;
	GenBeam gbsTsl[0]; gbsTsl=_GenBeam;		Entity entsTsl[0]; entsTsl = _Entity;			Point3d ptsTsl[] = { _Pt0};
	int nProps[]={};								double dProps[]={};							String sProps[]={};
	Map mapTsl;	
	
	mapTsl.setInt("Mode", bIsMasterPanel);
	
	tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
	
	eraseInstance();
	return;

}

int nMode = _Map.getInt("Mode");

if(nMode == 0) // Display PunchMarker on Sip
{ 
	// required conditions for existance of this tsl in this mode
	if (_GenBeam.length() == 0 || 
		!_GenBeam[0].bIsValid() || 
		_Entity.length() == 0 || 
		!_Entity[0].bIsValid()) 
	{
		eraseInstance();
		return;
	}
	
	GenBeam genbeam = _GenBeam[0];
	EntPLine polyEnt = (EntPLine) _Entity[0];
	if (!polyEnt.bIsValid()) {
		eraseInstance();
		return;
	}
	
	// tsl behaviour
	PLine pline = polyEnt.getPLine();
	_Pt0 = pline.ptStart();
	setDependencyOnEntity(polyEnt);
	pline.vis(1);
	
	// define geometry
	CoordSys csPl = pline.coordSys();
	Vector3d vecN = csPl.vecZ();
	
	// make sure the PLine its normal is pointing outwards of sip
	if (vecN.dotProduct(csPl.ptOrg() - genbeam.ptCen()) < 0)
	{
		vecN = -vecN;
	}
	double dimGB = genbeam.dD(vecN);
	pline.transformBy((0.5*dimGB + vecN.dotProduct( genbeam.ptCen() - csPl.ptOrg() ))*vecN);
	
	// reconstruct plPath from vertexDistance
	PLine plPath = pline;
	if (abs(vertexDistance)>U(1)) // only do this if bigger than 1 mm
	{
		Point3d pts[0];
		double dDist = 0;
		double dDistMax = pline.length()+U(0.00001); // add a small epsilon
		
		for (int s=0; s<1000; s++) // max 1000
		{
			if (dDist > dDistMax)
				break;
				
			Point3d ptC = pline.getPointAtDist(dDist);
			pts.append(ptC);
			dDist += vertexDistance;
		}
		
		if (pts.length()>1) 
		{
			plPath = PLine(vecN);
			for (int p=0; p<pts.length(); p++) 
				plPath.addVertex(pts[p]);
		}
		else
		{
			plPath = PLine(); // reset polyline
		}
	}
	
	PlaneProfile plProf(Plane(_Pt0, vecN));
	Map mapRequest, mapRequests;
	
	// display
	Display dp(-1);
	dp.textHeight((vertexRadius>U(10)) ? vertexRadius : U(10));
	Point3d pnts[] = plPath.vertexPoints(1);
	if (pnts.length()>0) {
		
		dp.draw(plPath);
		mapRequest = Map();
		mapRequest.setVector3d("AllowedView",vecN);
		mapRequest.setInt("Color", -1);		
		mapRequest.setPLine("pline", plPath);	
		mapRequests.appendMap("DimRequest",mapRequest);	
		
		for(int i=0; i<pnts.length(); i++)
		{
			PLine plCir;
			plCir.createCircle(pnts[i], vecN, vertexRadius);
			dp.draw(plCir);
			plProf.joinRing(plCir, false);			
		}
	}
	else
	{
		dp.draw(T("|No vertices found|"), _Pt0, _XU, _YU, 0,0);
	}
	
	//region Maprequest PlaneProfile
		
		mapRequest = Map();
		mapRequest.setVector3d("AllowedView",vecN);
		mapRequest.setInt("DrawFilled", 0);
		mapRequest.setInt("Transparency", 1);
		mapRequest.setInt("Color", -1);
		mapRequest.setPlaneProfile("PlaneProfile", plProf);
		mapRequests.appendMap("DimRequest", mapRequest);
	
	//End Maprequest PlaneProfile//endregion 
		
	// create tool
	if (pnts.length()>0) {
		Map map;
		map.setPLine("path",plPath);
		CncExport tool("PUNCHMARKER",map);
		genbeam.addTool(tool);
	}
	
	// publish dim requests	
	_Map.setMap("DimRequest[]", mapRequests);
}
else if (nMode == 1) // Display PunchMarker on MasterPanel
{ 
	// Set the two propdoubles on readonly
	vertexRadius.setReadOnly(1);
	vertexDistance.setReadOnly(1);
	
	// Check if tsl is already created on the MasterPanel
	TslInst instances[] = _Entity[0].tslInstAttached();
		
	if (instances.length() > 0)
	for (int i=0;i<instances.length();i++) 
	{ 
		TslInst inst = instances[i]; 
		
		if(inst.scriptName() == _ThisInst.scriptName() && inst != _ThisInst)
		{ 	
			reportMessage(TN("|tsl already created on this masterpanel|"));
			eraseInstance();
			return;	
		}
	}//next i
		
	// required conditions for existance of this tsl in this mode
	if (_Entity.length() == 0 || !_Entity[0].bIsValid()) 
	{
		eraseInstance();
		return;
	}
		
	MasterPanel mp = (MasterPanel)_Entity[0];
	
	// Validate MasterPanel
	if(!mp.bIsValid())
	{ 
		eraseInstance();
		return;
	}
		
	ChildPanel childs[] = mp.nestedChildPanels();
	for (int i=0;i<childs.length();i++) 
	{ 
		// Get child panel instance from master
		ChildPanel child = childs[i];
		// Get Sip from child panel
		Sip sip = child.sipEntity();
		
		// Transform ptCen to center of child panel
		CoordSys sip2Child;
		sip2Child = child.sipToMeTransformation();
		Point3d ptCen = sip.ptCenSolid();
		ptCen.transformBy(sip2Child);
		
		TslInst tslRequests[0];
		Entity entTools[] = sip.eToolsConnected();
		
		for (int j=0;j<entTools.length();j++) 
		{ 
			TslInst  tsl = (TslInst)entTools[j]; 
			
			if (!tsl.bIsValid() || tsl.scriptName() != _ThisInst.scriptName()) continue;
			Map m = tsl.map();
			
			if (m.hasMap("DimRequest[]"))
			{
				tslRequests.append(tsl);
			}
		}//next j		
		
		if (tslRequests.length() <1)
		{ 
			eraseInstance();
			return;
		}
		
		for (int k=0;k<tslRequests.length();k++) 
		{ 
			Map mapRequests = tslRequests[k].map().getMap("DimRequest[]");
			for (int n=0;n<mapRequests.length();n++) 
			{ 
				Map m = mapRequests.getMap(n);
				m.transformBy(sip2Child);
				if(m.hasPLine("pline"))
				{ 					
					Vector3d vecZView = m.getVector3d("AllowedView");
					int nc = m.getInt("Color");
					Display dpr(nc);
					PLine pl = m.getPLine("pline");
					dpr.draw(pl);
				}	 
				else if(m.hasPlaneProfile("planeprofile"))
				{ 
					Vector3d vecZView = m.getVector3d("AllowedView");
					int drawFilled = m.getInt("DrawFilled");
					int transparency = m.getInt("Transparency");
					int nc = m.getInt("Color");
					Display dpr(nc);
					PlaneProfile pp = m.getPlaneProfile("PlaneProfile");
					dpr.draw(pp, drawFilled, transparency);
					
				}
			}//next n
			
		}//next k
		
	}//next i
}
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