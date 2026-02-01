#Version 8
#BeginDescription
A generic routine for removing a box volume from a beam, to be used in a CollectionEntity in combination with ApplyCustomAssembly TSL
V1.0 4/20/2022 Public Release cc

V0.75__20June2020__Refactored script
V0.74__30November2018__Added operation mode value to map
V0.73__28November2018__Allows panels to be selected as well as beams
V0.72_19December2016_Added control for exact or dynamic drill requests
V0.70__15September2016__Assigned display to "CE_Tools" if it exists
V0.65__14September2016__Improved graphics
V0.60_11September2016__Add Target Beams Property and function
V0.55__11September2016__Revised tool information storage format
V0.50__11September2016__Incepetion

V0.50_10September2016__Inception









V1.1 2/23/2023 Revisd Grips to be length control only cc

V1.11 2/24/2023 Added arrow to preserve designer sanity cc

V1.12 4/5/2023 Revised mpDrill format when in both end anchor mode cc

1.14 8/20/2024 Bugfix in drill depth cc

1.16 8/20/2024 Added user control of text height cc
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 16
#KeyWords 
#BeginContents
Unit (1, "mm" ) ;

double dInitialDepth = U(150);
int bInDebug = projectSpecial() == "db" || projectSpecial() == scriptName();
if (_bOnDebug) bInDebug = true;
_ThisInst.setDebug(bInDebug);

PropDouble pdDiameter ( 0, U(12), T( "Internal Drill Diameter" ) ) ;
PropDouble pdDrillDiameter( 1, U(15), T( "Applied Drill Diameter" ) ) ;
PropDouble pdDrillLength(2, 0, "Overall Drill Length");
pdDrillLength.setDescription("Reports current length between grips");
pdDrillLength.setReadOnly(true);

String stTargetBeams[] = {"Parent", "Children", "All"};
PropString psTargetBeam(0, stTargetBeams, "Target Beams", 2);

String stOperationModes[] = { "Anchor End 1", "Anchor End 2", "Anchor Both"};
PropString psOperationMode (1, stOperationModes, "Operation Mode");
PropDouble pdTextH(3, U(.3, "inch"), T("|Text Height|"));

int bAnchor1 = psOperationMode == stOperationModes[0];
int bAnchor2 = psOperationMode == stOperationModes[1];
int bAnchorBoth = psOperationMode == stOperationModes[2];

_ThisInst.setAllowGripAtPt0(false);

if(_bOnInsert)
{
	showDialogOnce();
	
	PrEntity prEntity("\nSelect a beam or panel to tool in Assembly", GenBeam());
	if (prEntity.go()) 
	{
		Entity selected[] = prEntity.set();
		if (selected.length() > 0) _Entity = selected;
	}
	
	Point3d ptLocationRef = getPoint("Select Insertion Point");
	
	PrPoint prp("Select Drill Direction", ptLocationRef);
	
	Map mpJig;
	mpJig.setDouble("dDrillDiameter", pdDrillDiameter);
	mpJig.setDouble("dDiameter", pdDiameter);
	mpJig.setDouble("dDrillDepth", pdDrillLength);
	
	if(prp.goJig("", mpJig) == _kOk)
	{ 
		Point3d ptPicked = prp.value();
		Vector3d vDrill = ptPicked - ptLocationRef;
		if(pdDrillLength == 0)
		{ 
			pdDrillLength.set(vDrill.length());
		}
		else
		{
			vDrill.normalize();
			vDrill *= pdDrillLength;
		}
		_PtG.append(ptLocationRef);
		_PtG.append(ptLocationRef + vDrill);
		_Map.setVector3d("vGrips", vDrill);
	}
	else
	{ 
		eraseInstance();
		return;
	}
	
	return;
}

if(_bOnJig)
{ 
	double dDiam = _Map.getDouble("dDiameter");
	double dDrillDiam = _Map.getDouble("dDrillDiameter");
	Point3d ptBase = _Map.getPoint3d("_PtBase");
	Point3d ptJig = _Map.getPoint3d("_PtJig");
	double dDrillDepth = _Map.getDouble("dDrillDepth");
	
	
	Vector3d vJig = ptJig - ptBase;
	if (vJig.length() < U(.001, "inch")) return;
	if(dDrillDepth == 0) dDrillDepth = vJig.length();
	vJig.normalize();
	
	_ThisInst.setDebug(true);
	Body bdDrill(ptBase, ptBase + vJig * dDrillDepth, dDrillDiam/2);
	if(dDiam > 0)
	{ 
		Body bd (ptBase, ptBase + vJig * dDrillDepth / 5, dDiam / 2);
		bdDrill += bd;
	}
	bdDrill.vis(3);
	
	return;
}

String addBeams = "Add beams to be tooled";
String removeBeams = "Remove beams to be tooled";

addRecalcTrigger(_kContextRoot, addBeams);
addRecalcTrigger(_kContextRoot, removeBeams);

if(_kExecuteKey == addBeams)
{
	PrEntity prEntity("\nSelect a beam or panel to tool", GenBeam());
	
	if (prEntity.go()) _Entity = prEntity.set();
}

if(_kExecuteKey == removeBeams)
{
	PrEntity prEntity("\nSelect a beam or panel to tool", GenBeam());
	
	if (prEntity.go())
	{
		Entity arGenBeams[] = prEntity.set();
		
		for (int i = 0; i < arGenBeams.length(); i++)
		{
			int iFind = _Entity.find(arGenBeams[i]);
			if (iFind > - 1) _Entity.removeAt(iFind);
		}
	}
}
if(_PtG.length() < 2)
{ 
	reportMessage("/n" + scriptName() + " Has Changed. You will need to reinsert");
	eraseInstance();
	return;
}

Point3d& ptDrill = _PtG[0];
Point3d& ptDrillEnd = _PtG[1];

if(_kNameLastChangedProp == "_PtG0" || _kNameLastChangedProp == "_PtG1")
{ 
	Vector3d vGrips = _Map.getVector3d("vGrips");
	Point3d ptLine = _kNameLastChangedProp == "_PtG0" ? ptDrillEnd : ptDrill;
	Line lnGrips(ptLine, vGrips);
	ptDrill = lnGrips.closestPointTo(ptDrill);
	ptDrillEnd = lnGrips.closestPointTo(ptDrillEnd);
	
	double dGripSeparation = (ptDrill - ptDrillEnd).length();
	pdDrillLength.set(dGripSeparation);
}


Vector3d vDrill = ptDrillEnd - ptDrill;




vDrill.normalize();

if(_kNameLastChangedProp == "Overall Drill Length")
{ 
	ptDrillEnd = ptDrill + vDrill * pdDrillLength;
}

Display dp(8);
dp.textHeight(pdTextH);
String stDisplayReps[] = TslInst().dispRepNames();
if (stDisplayReps.find("CE_Tools") >= 0) dp.showInDispRep("CE_Tools");


Body bdDrill (ptDrill, ptDrillEnd, pdDrillDiameter / 2);
if(pdDiameter > 0)
{ 
	Body bd(ptDrill, ptDrill + vDrill * pdDrillDiameter / 5, pdDiameter / 2);
	bdDrill += bd;
}
dp.draw(bdDrill);

if(pdDiameter > 0)
{ 
	for(int i=0; i<_Entity.length(); i++)
	{
		Entity ent = _Entity[i];
		GenBeam gb = (GenBeam)ent;
		if ( ! gb.bIsValid()) continue;
		Vector3d vOverDrill = vDrill * U(.2, "inch");
		Drill dr(ptDrill, ptDrillEnd + vOverDrill, pdDiameter / 2);
		gb.addTool(dr);
	}
}


ptDrill.vis(1);
ptDrillEnd.vis(3);
vDrill.vis(ptDrill, 4);

Map mpDrill;

if(bAnchor1 )
{ 
	mpDrill.setPoint3d("ptDrillEnd", ptDrillEnd);
	mpDrill.setVector3d("vDrill", vDrill);
	mpDrill.setDouble("dRadius", pdDrillDiameter / 2);
	mpDrill.setString("stTargetBeams", psTargetBeam);

}

if(bAnchor2 )
{ 
	mpDrill.setPoint3d("ptDrillEnd", ptDrill);
	mpDrill.setVector3d("vDrill", -vDrill);
	mpDrill.setDouble("dRadius", pdDrillDiameter / 2);
	mpDrill.setString("stTargetBeams", psTargetBeam);
	
}

if(bAnchorBoth)
{ 
	mpDrill.setPoint3d("ptDrillEnd", ptDrillEnd);
	mpDrill.setPoint3d("ptDrillEnd2", ptDrill);
	mpDrill.setVector3d("vDrill", vDrill);
	mpDrill.setDouble("dRadius", pdDrillDiameter / 2);
	mpDrill.setString("stTargetBeams", psTargetBeam);
}

_Map.setMap("mpDrill", mpDrill);
_Map.setVector3d("vGrips", vDrill);
	
Vector3d vPerpRef = vDrill.isParallelTo(_ZW) ? _XW : _ZW;
Vector3d vTextRef = vPerpRef.crossProduct(vDrill);
vTextRef.normalize();
dp.draw("1", ptDrillEnd, vDrill, vTextRef, 0, 0);
dp.draw("2", ptDrill, vDrill, vTextRef, 0, 0);

//__Graphics

Point3d ptDrillAnchor = mpDrill.getPoint3d("ptDrillEnd");
Vector3d vDrillDir = mpDrill.getVector3d("vDrill");

Point3d ptArrowEnd = ptDrillAnchor - vDrillDir * U(1.5, "inch");
Vector3d vArrowPerp = vDrillDir.crossProduct(vPerpRef);
double dArrowL = U(.3, "inch");
double dArrowW = U(.17, "inch");
Vector3d vArrowDraw = vDrillDir * dArrowL + vArrowPerp * dArrowW / 2;
PLine plArrow(ptDrillAnchor, ptArrowEnd, ptArrowEnd + vArrowDraw, ptArrowEnd);
vArrowDraw = vArrowDraw.rotateBy(180, vDrillDir);
plArrow.addVertex(ptArrowEnd + vArrowDraw);
dp.draw(plArrow);

CoordSys csRotate;
csRotate.setToRotation(90, vDrillDir, ptDrill);
plArrow.transformBy(csRotate);
dp.draw(plArrow);

if(bAnchorBoth)
{ 
	Point3d ptDrillMid = ptDrillEnd + (ptDrill - ptDrillEnd) / 2;
	CoordSys csMirror;
	csMirror.setToMirroring(Plane(ptDrillMid, vDrillDir));
	plArrow.transformBy(csMirror);
	dp.draw(plArrow);
}


#End
#BeginThumbnail












#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Added user control of text height" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="16" />
      <str nm="Date" vl="8/20/2024 12:09:12 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Bugfix in drill depth" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="8/20/2024 10:53:15 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Revised mpDrill format when in both end anchor mode" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="4/5/2023 4:17:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Added arrow to preserve designer sanity" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="2/24/2023 9:58:35 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Revisd Grips to be length control only" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="2/23/2023 12:34:36 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Public Release" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="4/20/2022 10:40:08 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End