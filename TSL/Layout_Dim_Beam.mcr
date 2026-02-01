#Version 8
#BeginDescription
#Versions:
1.2 23.05.2022 HSB-15514: Truss entities are now recognised for dimensioning Author: Marsel Nakuci
mk:2-9-04:added the first and last perp beam to the dim array and also only dim hsbid 53333 which is set to Trimmer
KR:10-10-2003: added the perpendicular text possibility
KR:1-6-2004: origin is now most "left" point of dimension line, and not the startpoint of the timbers on zone 0
AJ: 06/Jun/2007




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.2 23.05.2022 HSB-15514: Truss entities are now recognised for dimensioning Author: Marsel Nakuci

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl creates 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Layout_Dim_Beam")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion
String arHsbId[] = {"53344","53347","79","80","130","5000","66","67","68","69","74","88","90","73","214"};//these timber ids will not appear in the dim lineType
/////

Unit(1,"mm"); // script uses mm
double dEps =U(.1);

String arDir[]={"Horizontal","Vertical"};
PropString strDir(0,arDir,"Direction");

String arDir1[]={"Left","Right"};
PropString strDir1(1,arDir1,"Dim from");


String arSide[]={"Left","Center","Right", "Left and right"};
int arISide[]={_kLeft, _kCenter, _kRight, _kLeftAndRight};
PropString strSide(2,arSide,"Side of beams/sheets");
int nSide = arISide[arSide.find(strSide,0)];

String arAllZones[]={"Use zone index","All"};
PropString strAllZones(3,arAllZones,"Zones to use");

int arZone[]={-5,-4,-3,-2,-1,0,1,2,3,4,5};
PropInt nZone(0,arZone,"Zone index",5); // index 5 is default


String arTextDir[]={"None","Parallel","Perpendicular"};
int arITextDir[]={_kDimNone,_kDimPar, _kDimPerp};

PropString strTextDirD(4,arTextDir,"Delta text direction");
int nTextDirD = arITextDir[arTextDir.find(strTextDirD,0)];

PropString strTextDirC(5,arTextDir,"Cumm text direction",1);
int nTextDirC = arITextDir[arTextDir.find(strTextDirC,1)];

PropString sDimLayout(6,_DimStyles,T("Dim Style"));

PropInt nDimColor(1,1,T("Color"));
if (nDimColor < 0 || nDimColor > 255) nDimColor.set(0);

if (_bOnInsert) {
  
  reportMessage("\nAfter inserting you can change the OPM value to set the direction, and the zone.");
   _Pt0 = getPoint(); // select point
  Viewport vp = getViewport("Select a viewport, you can add others later on with the HSB_LINKTOOLS command."); // select viewport
  _Viewport.append(vp);

  return;

}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));


// do something for the last appended viewport only
if (_Viewport.length()==0) return; // _Viewport array has some elements
Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
Element el = vp.element();
int nZoneIndex = vp.activeZoneIndex();

Display dp(nDimColor); // use color red
dp.dimStyle(sDimLayout, ps2ms.scale()); // dimstyle was adjusted for display in paper space, sets textHeight

if (_bOnDebug) {
// draw the scriptname at insert point
dp.draw(scriptName() ,_Pt0,_XW,_YW,1,1);
}

DimLine lnPs; // dimline in PS (Paper Space)
Vector3d vecDimDir; 
if (strDir=="Horizontal") {
  lnPs = DimLine(_Pt0, _XW, _YW );
  vecDimDir = _XW;
}
else {
  lnPs = DimLine(_Pt0, _YW, -_XW );
  vecDimDir = _YW;
}


DimLine lnMs = lnPs; lnMs.transformBy(ps2ms); // dimline in MS (Model Space)

Vector3d vecDDMs = vecDimDir; vecDDMs.transformBy(ps2ms);

if (strDir1=="Right") 
	vecDDMs= -vecDDMs;


Point3d pntsMs[0]; // define array of points in MS

Beam arBeams[] = el.beam(); // collect all beams

// find out the origin point for the dimensioning. 
// For that, take the timber perpendicular to the dimline, in most negative direction
Beam arRef[] = vecDDMs.filterBeamsPerpendicularSort(arBeams);
// HSB-15514:
TrussEntity trusses[0];
Body bdTrusses[0];
Quader qdTrusses[0];
PLine plTrusses[0];
Group grp=el.elementGroup();
Entity entTrusses[]=grp.collectEntities(true,TrussEntity(),_kModelSpace);
for (int ient=0;ient<entTrusses.length();ient++) 
{ 
	TrussEntity trussI = (TrussEntity)entTrusses[ient];
	if (!trussI.bIsValid())continue;
	CoordSys csTruss = trussI.coordSys();
	Vector3d vecXt = csTruss.vecX();
	if(abs(vecXt.dotProduct(vecDDMs))>=dEps)
	{ 
		// not normal with vecDDMs
		continue;
	}
	if (trusses.find(trussI) < 0)
	{
		trusses.append(trussI);
		Vector3d vecYt = csTruss.vecY();
		Vector3d vecZt = csTruss.vecZ();
		Point3d ptOrgTruss = trussI.ptOrg();
		String strDefinition = trussI.definition();
		TrussDefinition trussDefinition(strDefinition);
		Beam beamsTruss[] = trussDefinition.beam();
		Body bdTruss;
		for (int i=0;i<beamsTruss.length();i++) 
		{ 
	//		beamsTruss[i].envelopeBody().vis(4);
			bdTruss.addPart(beamsTruss[i].envelopeBody());
		}//next i
		bdTruss.transformBy(csTruss);
		Point3d ptCenBd = bdTruss.ptCen();
		PlaneProfile ppX = bdTruss.shadowProfile(Plane(ptCenBd, vecXt));
		LineSeg segX = ppX.extentInDir(vecYt);
		Point3d ptCenX = segX.ptMid();
		Point3d ptCenTruss = ptCenX;
		PlaneProfile ppY = bdTruss.shadowProfile(Plane(ptCenBd, vecYt));
		LineSeg segY = ppY.extentInDir(vecXt);
		ptCenTruss += vecXt * vecXt.dotProduct(segY.ptMid() - ptCenTruss);
		double dLx = bdTruss.lengthInDirection(vecXt);
		double dLy = bdTruss.lengthInDirection(vecYt);
		double dLz = bdTruss.lengthInDirection(vecZt);
		Quader qdTruss(ptCenTruss, vecXt, vecYt, vecZt, dLx, dLy, dLz,0,0,0);
		Body bdI(qdTruss);
		qdTrusses.append(qdTruss);
		bdTrusses.append(bdI);
		PlaneProfile ppIx=bdI.shadowProfile(Plane(csTruss.ptOrg(),vecXt));
		PlaneProfile ppIy=bdI.shadowProfile(Plane(csTruss.ptOrg(),vecYt));
		PlaneProfile ppIz=bdI.shadowProfile(Plane(csTruss.ptOrg(),vecZt));
		PLine plsIx[]=ppIx.allRings(true,false);
		PLine plsIy[]=ppIy.allRings(true,false);
		PLine plsIz[]=ppIz.allRings(true,false);
		if(plsIx.length()>0)
		{
			plTrusses.append(plsIx[0]);
		}
		if(plsIy.length()>0)
		{
			plTrusses.append(plsIy[0]);
		}
		if(plsIz.length()>0)
		{
			plTrusses.append(plsIz[0]);
		}
	}
}

if (arRef.length()==0 && trusses.length()==0) return;

Beam arBmBot[0];
for (int i=0; i<arBeams.length(); i++)
{
	if (arBeams[i].type()==_kSFBottomPlate)
	{
		arBmBot.append(arBeams[i]);
	}
}

if (arBmBot.length()>0)
{
	Point3d ptExt[0];
	Line ln(arBmBot[0].ptCen(), arBmBot[0].vecX());
	for(int i=0; i<arBmBot.length(); i++)
	{
		Body bd= arBmBot[i].envelopeBody(TRUE,TRUE);
		Point3d ptBody[]=bd.extremeVertices(arBmBot[i].vecX());
		ptExt.append(ptBody);
	}
	ptExt=ln.projectPoints(ptExt);
	ptExt=ln.orderPoints(ptExt);
	pntsMs.append(ptExt[0]);
	pntsMs.append(ptExt[ptExt.length()-1]);
}
else
{
	Beam arFirst[0];
	arFirst.append(arRef[0]);
	if (strDir1=="Right")
		pntsMs.append(lnMs.collectDimPoints(arFirst,_kRight));
	else
		pntsMs.append(lnMs.collectDimPoints(arFirst,_kLeft));
	
	Beam arLast[0];
	arLast.append(arRef[arRef.length()-1]);
	if (strDir1=="Right")
		pntsMs.append(lnMs.collectDimPoints(arLast,_kLeft));
	else
		pntsMs.append(lnMs.collectDimPoints(arLast,_kRight));
}

if (strAllZones=="All") {
    GenBeam arGBeams[] = el.genBeam(); // collect all 
    pntsMs.append(lnMs.collectDimPoints(arGBeams,nSide));
    if(plTrusses.length()>0)
    {
    	pntsMs.append(lnMs.collectDimPoints(plTrusses,nSide));
    }
}
else {
  if (nZone==0) { // we only take the beams
    Beam arBmFl[0];
    for (int b=0; b<arBeams.length(); b++) {
      String strId = arBeams[b].name("hsbId");
      if (arHsbId.find(strId)==-1) {
        arBmFl.append(arBeams[b]);
      }
    }
    pntsMs.append(lnMs.collectDimPoints(arBmFl,nSide));
    if(plTrusses.length()>0)
    {
    	pntsMs.append(lnMs.collectDimPoints(plTrusses,nSide));
    }
  }
  else { // take the sheeting from a zone
    Sheet arSheets[] = el.sheet(nZone); // collect all sheet from the correct zone element 
    pntsMs.append(lnMs.collectDimPoints(arSheets,nSide));
  }
}

Line ln(_Pt0, vecDDMs);
pntsMs=ln.projectPoints(pntsMs);
pntsMs=ln.orderPoints(pntsMs);



Dim dim(lnMs,pntsMs,"<>","<>",nTextDirD,nTextDirC); // def in MS
dim.transformBy(ms2ps); // transfrom the dim from MS to PS
dp.draw(dim); 
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
      <str nm="Comment" vl="HSB-15514: Truss entities are now recognised for dimensioning" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="5/23/2022 2:50:16 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End