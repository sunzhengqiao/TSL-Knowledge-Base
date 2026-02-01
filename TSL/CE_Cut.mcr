#Version 8
#BeginDescription

V0.13 4/15/2022 Revised graphics to be consistent with other Collection space scripts cc

V1.0 4/20/2022 Initial public release cc
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents


/*
<>--<>--<>--<>--<>--<>--<>--<>____ Craig Colomb _____<>--<>--<>--<>--<>--<>--<>--<>



//######################################################################################
//############################ Documentation #########################################

Declares a Cut inside a CollecitionEntity to act on attached beams

mpCut
	|_stTarget {"Parent", "Children", "All"}
	|_ptCut
	|_vCut

Requirements


//########################## End Documentation #########################################
//######################################################################################

                              craig.colomb@hsbcad.com
<>--<>--<>--<>--<>--<>--<>--<>_____ hsbcad.us  _____<>--<>--<>--<>--<>--<>--<>--<>

*/
	
String stYN[] = { "No", "Yes"};
String stSpecial = projectSpecial();
int bInDebug = stSpecial == "db" || stSpecial == scriptName();
if(_bOnDebug) bInDebug = true;


//region  Props_and_Basics
//######################################################################################		
//######################################################################################	

String stTargetBeams[] = {"Parent", "Child"};
PropString psTargetBeam(0, stTargetBeams, "Target Beams", 2);



if(_bOnInsert)
{
	showDialogOnce();
	_Pt0 = getPoint("Select Insertion Point");
	PrPoint prp("Indicate Cut direction", _Pt0);
	if (prp.go()) _PtG.append(prp.value());
	
	if(_PtG.length() == 0)//__was not properly selected
	{ 
		eraseInstance();
		return;
	}
	
	Vector3d vSelectedDirection = _PtG[0] - _Pt0;
	if(vSelectedDirection.length() == 0)//__bad selection
	{ 
		reportMessage("\nDirection not successfully indicated");
		eraseInstance();
		return;
	}
	
	_Map.setVector3d("vLastCutDir", vSelectedDirection);
	
	
	return;
}


Display dp ( 8 ) ;
String stDisplayReps[] = TslInst().dispRepNames();
if (stDisplayReps.find("CE_Tools") >=0) dp.showInDispRep("CE_Tools");

//######################################################################################
//######################################################################################	
//endregion End Props_and_Basics 			


Point3d& ptCutDirection = _PtG[0];
Point3d& ptCutOrg = _Pt0;

Vector3d vLastCutDir = _Map.getVector3d("vLastCutDir");
if(vLastCutDir.length() > 0)//__check for overlapping grips
{ 
	Vector3d vCheck = ptCutDirection - ptCutOrg;
	if(vCheck.length() < U(1, "mm"))
	{ 
		vLastCutDir.normalize();
		ptCutDirection = ptCutOrg + vLastCutDir * U(50, "mm");
	}
}

Vector3d vCut = ptCutDirection - ptCutOrg;
vCut.normalize();
_Map.setVector3d("vLastCutDir", vCut);

ptCutDirection = ptCutOrg + vCut * U(50, "mm");//__maintain consistent distance

Map mpCut;
mpCut.setString("stTarget", psTargetBeam);
mpCut.setVector3d("vCut", vCut);
mpCut.setPoint3d("ptCut", ptCutOrg);
_Map.setMap("mpCut", mpCut);


Vector3d vRef = vCut.isParallelTo(_ZW) ? _XW : _ZW;
Vector3d vPerp = vCut.crossProduct(vRef);
Vector3d vCross = vCut.crossProduct(vPerp);

double dCrossW = U(19, "mm");
double dArrowW = U(8, "mm");

PLine plView(ptCutOrg, ptCutOrg + vPerp * dCrossW, ptCutOrg - vPerp * dCrossW, ptCutOrg);
plView.addVertex(ptCutOrg + vCross * dCrossW);
plView.addVertex(ptCutOrg - vCross * dCrossW);
dp.draw(plView);

plView = PLine(ptCutOrg, ptCutDirection, ptCutDirection - vCut * dArrowW + vPerp * dArrowW);
plView.addVertex(ptCutDirection);
plView.addVertex(ptCutDirection - vCut * dArrowW - vPerp * dArrowW);
dp.draw(plView);
CoordSys csRotate;
csRotate.setToRotation(90, vCut, ptCutOrg);
plView.transformBy(csRotate);
dp.draw(plView);
Point3d ptArrowBase = ptCutDirection - vCut * dArrowW;
plView.createCircle(ptArrowBase, vCut, dArrowW);
dp.draw(plView);



	
	
	

	
	
	
	
	
	
	
	
	

#End
#BeginThumbnail


#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Initial public release" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="4/20/2022 8:33:22 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Revised graphics to be consistent with other Collection space scripts" />
      <int nm="MAJORVERSION" vl="0" />
      <int nm="MINORVERSION" vl="13" />
      <str nm="DATE" vl="4/15/2022 4:26:37 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End