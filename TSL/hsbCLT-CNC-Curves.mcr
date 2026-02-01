#Version 8
#BeginDescription
#Versions
Version 1.3 23.12.2021 HSB-14259 merged, new jig options , Author Thorsten Huck
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <History>//region
// #Versions
// 1.3 23.12.2021 HSB-14259 merged, new jig options , Author Thorsten Huck
/// <version value="1.2" date="17Apr2018" author="thorsten.huck@hsbcad.com"> translation issue fixed </version>
///	<version value="1.1" date=23oct17" author="thorsten.huck@hsbcad.com"> Alignment 'Center' supported, bulge support for flipped polylines, requires version 21.1.46 / 22.0.30 or newer </version>
/// <version value="1.0" date="13Oct2017" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry, select polylines or circles or specify a set of points,  and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates CNC tools as masterpanel tools.
/// </summary>//endregion


// constants //region
U(1,"mm");	
double dEps =U(.1);
int nDoubleIndex, nStringIndex, nIntIndex;
String sDoubleClick= "TslDoubleClick";
int bDebug=_bOnDebug;
bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
String sDefault =T("|_Default|");
String sLastInserted =T("|_LastInserted|");	
String category = T("|General|");
String sNoYes[] = { T("|No|"), T("|Yes|")};

PLine plMarker(_ZW);
{ 
	plMarker.addVertex(_PtW);
	plMarker.addVertex(_PtW + _XW * U(11) + _YW * U(2));
	plMarker.addVertex(_PtW + _XW * U(45) + _YW * U(2));
	plMarker.addVertex(_PtW + _XW * U(45) - _YW * U(2));
	plMarker.addVertex(_PtW + _XW * U(11) - _YW * U(2));
	plMarker.addVertex(_PtW);
	plMarker.addVertex(_PtW + _XW * U(11) + _YW * U(2));
	plMarker.addVertex(_PtW + _XW * U(11) - _YW * U(2));
	CoordSys csRot; csRot.setToRotation(45, _ZW, _PtW);
	plMarker.transformBy(csRot);
}
PLine plSaw(_ZW);
{ 
	double d = U(15);
	Point3d pt = _PtW + _YW * 2 * d;
	plSaw.addVertex(pt-_XW*4*d);
	plSaw.addVertex(pt+_XW*4*d, _PtW);
	plSaw.addVertex(pt-_XW*6*d);
	plSaw.addVertex(pt+_XW*6*d);
	plSaw.addVertex(pt+_XW*6*d+_YW*d);
	plSaw.addVertex(pt+_XW*8*d);
	plSaw.addVertex(pt+_XW*6*d-_YW*d);
	plSaw.addVertex(pt+_XW*6*d);
}	
PLine plMill(_ZW);
{ 
	double d = U(15);
	Point3d pt = _PtW + _YW * 2 * d;
	plMill.addVertex(pt-_XW*2*d);
	plMill.addVertex(pt+_XW*2*d, _PtW);
	plMill.addVertex(pt-_XW*2*d, pt+_YW*2*d);
	plMill.addVertex(pt-_XW*4*d);
	plMill.addVertex(pt+_XW*4*d);
	plMill.addVertex(pt+_XW*4*d+_YW*d);
	plMill.addVertex(pt+_XW*6*d);
	plMill.addVertex(pt+_XW*4*d-_YW*d);
	plMill.addVertex(pt+_XW*4*d);
}	
//endregion



// properties
String sToolTypes[] ={ T("|Saw|"), T("|Milling|"), T("|Marker|")};
String sToolTypeName="(A)  "+T("|Tool Type|");	
PropString sToolType(0, sToolTypes, sToolTypeName);	
sToolType.setDescription(T("|Defines the ToolType|"));
sToolType.setCategory(category);



category = T("|Geometry|");
String sDepthName="(B)  "+T("|Depth|");	
PropDouble dDepth(0, U(10), sDepthName);	
dDepth.setDescription(T("|Defines the Depth|"));
dDepth.setCategory(category);

String sToolindexName="(C)  "+T("|Toolindex|");	
PropInt nToolindex(0, 0, sToolindexName);	
nToolindex.setDescription(T("|Defines the Toolindex|"));
nToolindex.setCategory(category);

String sAngleName="(D)  "+T("|Saw Angle|");	
PropDouble dAngle(1, U(0), sAngleName);	
dAngle.setDescription(T("|Defines the Angle of the sawline|") + " " + T("|-90° < Value < 90°|"));
dAngle.setCategory(category);


// alignment
category = T("|Alignment|");

String sSides[]= {T("|Left|"),T("|Center|"),T("|Right|")};
int nSides[]={_kLeft, _kCenter,_kRight};
String sSideName="(E)  "+T("|Side|");	
PropString sSide(1, sSides, sSideName);	
sSide.setDescription(T("|Defines the Side|"));
sSide.setCategory(category);

int nFaces[]={ 1, -1};
String sFaces[]= {T("|Top|"),T("|Bottom|")};
String sFaceName="(F)  "+T("|Alignment|");	
PropString sFace(2, sFaces, sFaceName,1);	
sFace.setDescription(T("|Defines the Face|"));
sFace.setCategory(category);

// bOnInsert
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

// get tool type
	int nToolType = sToolTypes.find(sToolType);
	int nSide = nSides[sSides.find(sSide,0)];
	
// prepare tsl cloning
	TslInst tslNew;
	GenBeam gbsTsl[] = {};		Entity entsTsl[2];		Point3d ptsTsl[] = {};
	int nProps[]={nToolindex};	double dProps[]={dDepth, dAngle};	String sProps[]={sToolType,sSide, sFace};
	Map mapTsl;	
	String sScriptname = scriptName();


// prompt for polylines
	Entity entsSelected[0];	
	PrEntity ssEpl(T("|Select Polylines & MasterPanels, <Enter> to draw|"), Entity());
	if (ssEpl.go())
  		entsSelected.append(ssEpl.set());

	MasterPanel masterPanels[0];
  	EntPLine entPLines[0];
	for (int i=0;i<entsSelected.length();i++) 
	{ 
		Entity ent = entsSelected[i]; 
		
		if(ent.bIsA(MasterPanel()))
		{ 
			MasterPanel mp = (MasterPanel)ent;
			if(mp.bIsValid()) masterPanels.append(mp);
			continue;
		}
		
		if(ent.bIsA(EntPLine()))
		{ 
			EntPLine epl = (EntPLine)ent;
			if(epl.bIsValid()) entPLines.append(epl);
		}
	}


  	
  	Plane pnW(_PtW, _ZW);
  	
  	//___if the user hasn't selected anything, allow picking of points to draw tool path
  	if(entsSelected.length() == 0 || (masterPanels.length()==1 && entPLines.length()<1))
  	{ 
  		Point3d ptPicked = getPoint(T("|Select Start point|"));
  		ptPicked = pnW.closestPointTo(ptPicked);
  		Point3d ptsPicked[0];
  		ptsPicked.append(ptPicked);
  		
  		PLine pl(_ZW);
  		pl.addVertex(ptPicked);
  		int iSafe;
  		int nGoJig = -1;
		Map mapArgs;
		mapArgs.setInt("ToolType", nToolType);
		mapArgs.setInt("Side", nSide);

		PrPoint prp(TN("|Select next point [Left/Center/Right/Saw/Mill/mArker]|")); 	
		while (true)
		{	
			mapArgs.setPoint3dArray("pts", ptsPicked);
		    nGoJig = prp.goJig("", mapArgs); 		    
		
		   	if (nGoJig == _kOk)		
			{
				Point3d pt = pnW.closestPointTo(prp.value());
				ptsPicked.append(pt);
				pl.addVertex(pt);
			}	
			else if (nGoJig==_kKeyWord)
			{ 
				if (prp.keywordIndex()==0)
				{ 
					mapArgs.setInt("Side", -1);
					sProps[1] = sSides[0];
				}
				else if (prp.keywordIndex()==1)
				{ 
					mapArgs.setInt("Side", 0);
					sProps[1] = sSides[1];
				}
				else if (prp.keywordIndex()==2)
				{ 
					mapArgs.setInt("Side", 1);
					sProps[1] = sSides[2];
				}
				else if (prp.keywordIndex()==3)
				{ 
					mapArgs.setInt("ToolType", 0);
					sProps[0] = sToolTypes[0];
				}
				else if (prp.keywordIndex()==4)
				{ 
					mapArgs.setInt("ToolType", 1);
					sProps[0] = sToolTypes[1];
				}
				else if (prp.keywordIndex()==5)
				{ 
					mapArgs.setInt("ToolType", 2);
					sProps[0] = sToolTypes[2];
				}				
				
				
			}
			else
			{ 
				break;
			}
		}

		if (masterPanels.length()<1)
		{ 
	  		MasterPanel mp = getMasterPanel();
	  		masterPanels.append(mp); 			
		}

  		EntPLine epl;
  		epl.dbCreate(pl);
  		entPLines.append(epl);		
  	}
  	
  	

	
	//__clone an instance for each Pline/MP intersection
	for(int i=0; i<masterPanels.length(); i++)
	{
		MasterPanel mp = masterPanels[i];
		PLine panelShape = mp.plShape();
		panelShape.projectPointsToPlane(pnW, _ZW);
		PlaneProfile pp(panelShape);
		
		
		for(int k=0; k<entPLines.length(); k++)
		{
			EntPLine epl = entPLines[k];
			PLine pl = epl.getPLine();
			Point3d ptsPLine[] = pl.vertexPoints(true);
			
			if (ptsPLine.length() == 2) ptsPLine.append(pl.ptMid());//__capture simple lines that span across masterpanel
			
			for(int p=0; p<ptsPLine.length(); p++)
			{
				int iPointInProfile = pp.pointInProfile(ptsPLine[p]);
				if(iPointInProfile != 1)//__point is either on or inside of mp outline
				{ 
					entsTsl[0] = mp;
					entsTsl[1] = epl;
					tslNew.dbCreate(sScriptname, _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps);
					break;//__no need to look at further points
				}
			}
		}
	}

	eraseInstance();		
	return;
}	
// end on insert	__________________

if(_bOnJig)
{ 
	Point3d ptsPicked[] = _Map.getPoint3dArray("pts");
	int nToolType = _Map.getInt("toolType");
	int nSide = _Map.getInt("Side");
	
	PLine plSym = plSaw;
	int color = 132;//dark cyan
	if (nToolType == 1)
	{
		plSym = plMill;
		color = 52;//dark yellow
	}
	else if (nToolType == 2)
	{	
		plSym = plMarker;
		color = 212;// dark magenta
	}
	if (nSide==1 && nToolType!=2)
		plSym.transformBy(_YW * U(15));
	
	Display dpJig(color);
	
	PLine plJig(_ZW);
	ptsPicked.append(_Map.getPoint3d("_PtJig"));
	for(int i=0; i<ptsPicked.length(); i++)
	{
		plJig.addVertex(ptsPicked[i]);
		
		
		if(i>0)
		{ 
			Point3d ptm = (ptsPicked[i] + ptsPicked[i - 1]) * .5;
			Vector3d vecX = ptsPicked[i] - ptsPicked[i - 1];
			
			vecX.normalize();
			Vector3d vecY = vecX.crossProduct(-_ZW);
			
			if (nSide == -1)
			{
				vecY *= nSide;
			}
			
			
			PLine pl = plSym;
			CoordSys csx;
			csx.setToAlignCoordSys(_PtW, _XW, _YW, _ZW, ptm, vecX, vecY, vecX.crossProduct(vecY));
			pl.transformBy(csx);
			
			dpJig.draw(pl);
		}
		
		
	}


	dpJig.draw(plJig);
	return;
}



// get master and potential defining entity
MasterPanel master;
PLine plDefining;

if(_Entity.length() < 1)
{ 
	eraseInstance();
	return;
}

Entity ent= _Entity[0]; 
if (ent.bIsKindOf(MasterPanel()) && !master.bIsValid())
{ 
	master = (MasterPanel)ent;
}
else
{ 
	eraseInstance();
	return;
}

EntPLine epl = (EntPLine)_Entity[1];
if(! epl.bIsValid())
{ 
	eraseInstance();
	return;
}

setDependencyOnEntity(epl);
plDefining = epl.getPLine();

// get ints
int nToolType = sToolTypes.find(sToolType);
int nSide = nSides[sSides.find(sSide,0)];
int nFace = nFaces[sFaces.find(sFace,0)];
int nTurn = 0;
int nOShoot = 0;

int bFlipNormal;

// sawline 
if (nToolType==0 && abs(dAngle>=90))
{ 
	dAngle.set(0);
	setExecutionLoops(2);
	return;
}

// milling or marker
else if (nToolType!=0)
{ 
	dAngle.set(0);
	dAngle.setReadOnly(true);
}




// TriggerFlipSide
String sTriggerFlipFace= T("|Flip Face|");
addRecalcTrigger(_kContext, sTriggerFlipFace );
if (_bOnRecalc && (_kExecuteKey==sTriggerFlipFace || _kExecuteKey==sDoubleClick))
{
	nFace *= -1;
	int n = nFaces.find(nFace, 0);
	sFace.set(sFaces[n]);
	
	dAngle.set(-dAngle);
	
	setExecutionLoops(2);
	return;
}


// coordSys
CoordSys csMP = master.coordSys();
Point3d ptSurface = csMP.ptOrg(); // coordSys of MasterPanel is on surface
Vector3d vecZ = csMP.vecZ();
double dOffset = 0;
if (nFace < 0)
{ 
	vecZ *= -1;
	dOffset = -master.dThickness();
	bFlipNormal = true;
}

// ref plane
_Pt0 -= (dOffset + vecZ.dotProduct(_Pt0 - ptSurface)) * vecZ;
Plane pn(_Pt0, vecZ);


if (bFlipNormal)
	plDefining.flipNormal();//setNormal(vecZ);
plDefining.projectPointsToPlane(pn, vecZ);
plDefining.vis(1);

// add saw
if (nToolType==0)
{
	plDefining.convertToLineApprox(dEps);
	ElemSaw tool(0, plDefining, dDepth, nToolindex, nSide, nTurn, nOShoot);
	if(abs(dAngle)>0)
		tool.setAngle(dAngle);
	if(nSide==0)
		tool.setSideToCenter();
	master.addTool(tool);
}
// add mill
else if (nToolType==1)
{
	ElemMill tool(0, plDefining, dDepth, nToolindex, nSide, nTurn, nOShoot);
	if(nSide==0)
		tool.setSideToCenter();			
	master.addTool(tool);
}
// add marker
else if (nToolType==2)
{
	ElemMarker tool(0, plDefining, nToolindex);
	master.addTool(tool);
}	

#End
#BeginThumbnail
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
L,OW7'45<HH`PAX?G"[%U.8)Z<_XU9L-$BL;C[1YTDDF",FM2B@`HHHH`_]D$
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="74" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14259 merged, new jig options" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="12/23/2021 3:42:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Revised Properties, Bugfix on PLine recognition" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="12/15/2021 8:52:34 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End