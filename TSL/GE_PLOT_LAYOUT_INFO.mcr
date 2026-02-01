#Version 8
#BeginDescription
V1.5 02/25/2022  Added rotation and diagonal options
V1.4 09/14/2021  Added bundle info option
Version 1.3 added a new property to ignor Balk code A
Version 1.2 Added el code
Version 1.1 Added functionality to accept floors






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
Unit(1,"mm"); // script uses mm
double dLumberDensity = .0185185185; //__DF average, lbs/in^3
double dSheathingDensity = .0235;//__OSB & Zip sheathing average
String stNailingPropSetName = "Wall Nailing Schedule";

PropString pDimStyle(0,_DimStyles,"DimStyle");
//pDimStyle.setDescription("Select dimstyle with proper viewport scaling and dimension format.");

PropDouble dTH(2,U(0),"Text Heigth. If 0 uses DimStyle");
PropInt iRotation(6, 0, "Rotation");

String arJustification[]={ "Left", "Right"};
PropString stJustification(5, arJustification, "Justification" );


String strInformation = T("Information");//Wall and Floor
String strdefinition = T("definition");//Wall and Floor
String strSubType = T("Subtype");//Wall and Floor
String strSpacing = T("Spacing");//Wall and Floor
String strBaseHeight = T("Element Height (Y-Dir)");
String strFrameThickness= T("Frame Thickness");//Wall and Floor
String strStudLength= T("Stud Length");//Wall
String strWallL= T("Element Length (X-Dir)");
String strWallDiag= T("Element Diagonal");
String strWallGroup= T("Element Group");
String strStudFirst= T("First Stud location");
String strBPL= T("Bottom Plate Length");//Wall Only
String strProject = T("Project Name");//Wall and Floor
String strNumber = T("Project Number");//Wall and Floor
String strStreet = T("Project Street");//Wall and Floor
String strComment =T( "Project Comment");//Wall and Floor
String strDesigner = T("Designer");//Wall and Floor
String strRev = T("Project Revision");//Wall and Floor
String strSpecial = T("Project Special");//Wall and Floor
String strElCode = T("Element Code");//Wall and Floor
String strDwg = T("Dwg Name");//Wall and Floor
String strDwgFull = T("Dwg Full Name");//Wall and Floor
String strMatZ1 = T("Material Zone 1");//Wall and Floor
String strEdgeNailSpacing = T("Edge Nail Spacing");//Wall and Floor
String strFieldNailSpacing = T("Field Nail Spacing");//Wall and Floor
String strBundleInfo = T("Bundle Info");
String strPanelWeight = T("Panel Weight");


int iGp[]={0,1,2};

String strTypes[] = {strInformation,strdefinition,strSubType,strSpacing,strBaseHeight,strFrameThickness,
					strMatZ1,strStudLength,strWallL,strWallDiag,strWallGroup,strStudFirst,strBPL, strPanelWeight,strProject,strNumber,
					strStreet,strComment,strDesigner,strRev,strSpecial,strElCode,strDwg,strDwgFull,
					strEdgeNailSpacing,strFieldNailSpacing, strBundleInfo};
					
strTypes = strTypes.sorted();

PropString pType(1,strTypes,"Type of data");
PropInt iG(0,iGp,"What level of group");

String arStringFS[]={"Left","Center","Right"};
PropString strFSL(2,arStringFS,"Side of first stud to measures to");

String arYN[]={"Yes","No"};
PropString strIgnorVTP(3,arYN,"Ignor Balk code A for wall height",1);
PropString strMultiply(4,arYN,"Multiply output by 25.4",1);

double dmm=1;
if(strMultiply==arYN[0])dmm=25.4;

if (_bOnInsert) {
  
  showDialog();
   _Pt0 = getPoint("Select location"); // select point
  Viewport vp = getViewport("Select the viewport from which the element is taken"); // select viewport
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
Element el = vp.element();
TslInst arTslEl[]=el.tslInstAttached();

Map mpNail;
for(int t=0;t<arTslEl.length();t++){
	Map mp=arTslEl[t].map();
	if(mp.hasMap("NailOverride")){
		mpNail=mp.getMap("NailOverride");
		break;
	}
}


CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
double dScale = ps2ms.scale();


LineSeg lnSeg=el.segmentMinMax();

// text to be displayed
String strText;

if (pType==strInformation) {
  strText = el.information();
}
else if (pType==strDwg) {
  strText = dwgName();
}
else if (pType==strMatZ1) {
	ElemZone elZ=el.zone(1);
	strText = String().formatUnit(elZ.dH(),pDimStyle) + " " + elZ.material();
}
else if (pType==strEdgeNailSpacing) {
	strText = "8d @ 6\" o.c.";
	if(mpNail.hasString("NailType"))strText =mpNail.getString("NailType") + " @ " + mpNail.getDouble("NailSpaceEdge") + "\" o.c.";
}
else if (pType==strFieldNailSpacing) {
	strText = "8d @ 12\" o.c.";
	if(mpNail.hasString("NailType"))strText =mpNail.getString("NailType") + " @ " + mpNail.getDouble("NailSpaceField") + "\" o.c.";
}
else if (pType==strDwgFull) {
  strText = dwgFullName();
}
else if (pType==strdefinition) {
  strText = el.definition();
}
else if (pType==strElCode) {
  strText = el.code();
}
else if (pType==strSubType) {
  strText = el.subType();
}
else if (pType==strSpacing) {
  ElementWallSF elWSF = (ElementWallSF) el;
  if (elWSF.bIsValid()) strText.formatUnit(elWSF.spacingBeam()*dmm,pDimStyle);
  ElementRoof elR= (ElementRoof) el;
  if (elR.bIsValid()) strText.formatUnit(elR.dBeamSpacing()*dmm,pDimStyle);

}
else if (pType==strProject){
	strText=projectName();
}
else if (pType==strNumber){
	strText=projectNumber();
}
else if (pType==strStreet){
	strText=projectStreet();
}
else if (pType==strComment){
	strText=projectComment();
}
else if (pType==strDesigner){
	strText=projectUser();
}
else if (pType==strRev){
	strText=projectRevision();
}
else if (pType==strSpecial){
	strText=projectSpecial();
}
else if (pType==strBaseHeight) {
	 ElementWallSF elWSF = (ElementWallSF) el;
	if (elWSF.bIsValid()){
		Beam arBm1[]=el.beam();
		if(arBm1.length()<1)return;
		Point3d arPt[0];
		for (int b=0; b<arBm1.length(); b++) {
			String strCode=arBm1[b].beamCode().token(0);
			strCode.makeUpper();
			if(strIgnorVTP==arYN[1])arPt.append(arBm1[b].realBody().allVertices());
			else if(strCode != "A")arPt.append(arBm1[b].realBody().allVertices());
		}
		Line ln(el.ptOrg(),el.vecY());
		Point3d arPtLn[]=ln.orderPoints(arPt);
		double dElH=el.vecY().dotProduct(arPtLn[arPtLn.length()-1]-arPtLn[0]);
		Wall wll=(Wall)el;
		if (wll.bIsValid()) strText.formatUnit(dElH*dmm,pDimStyle);
	}
	else{
		double dElH = abs(el.vecY().dotProduct(lnSeg.ptStart()-lnSeg.ptEnd()));
		strText.formatUnit(dElH*dmm,pDimStyle);
	}
		
}
else if (pType==strWallL) {
	Wall wll = (Wall) el;
	if (wll.bIsValid()){
		double dL = (abs(el.vecX().dotProduct(wll.ptStart()-wll.ptEnd())));
		strText.formatUnit(dL*dmm,pDimStyle);
	}
	else{
		double dElL = abs(el.vecX().dotProduct(lnSeg.ptStart()-lnSeg.ptEnd()));
		strText.formatUnit(dElL*dmm,pDimStyle);
	}
}

else if (pType == strWallDiag && el.bIsValid()) {
		
		
	Display dpLS(2);
	String arLineTypes[0];
	arLineTypes = _LineTypes;
	if (arLineTypes.find("HIDDEN2") > - 1)dpLS.lineType("HIDDEN2");
	else if (arLineTypes.find("HIDDEN") > - 1)dpLS.lineType("HIDDEN");
	
	Point3d arPtBds[0];
	Beam arBm[] = el.beam();
	for (int i = 0; i < arBm.length(); i++) {
		
		Beam bm = arBm[i];
		if (bm.type() == _kBlocking || bm.type() == _kSFBlocking) continue;
		if (strIgnorVTP == arYN[0])
		{
			String strCode = bm.beamCode().token(0);
			strCode.makeUpper();
			if (strCode == "A" || strCode == "V")continue;				
		}
		
		Line ln(bm.ptCen() - bm.vecY() * bm.dW() / 2, bm.vecX());
		Point3d pts[] = bm.realBody().allVertices();//ln.projectPoints(bm.realBody().extremeVertices(bm.vecX()));
		arPtBds.append(pts);
	}
	
	Plane pnFlat(_PtW, _ZW);
	pnFlat.transformBy(ps2ms);
	arPtBds = pnFlat.projectPoints(arPtBds);
	
	
	if (arPtBds.length() == 0) {
		strText = "Not Found";
	}
	else
	{
		
		Line lnLR(el.ptOrg(), el.vecX()), lnBU(el.ptOrg(), el.vecY());
		arPtBds = lnBU.orderPoints(arPtBds);
		
		Point3d ptHalfWallUp = (arPtBds[0] + arPtBds[arPtBds.length() - 1]) / 2;
		
		
		Point3d ptTL, ptTR, ptBL, ptBR;
		//__Figure these points out
		{
			
			double dTol = U(.25);
			
			arPtBds = lnLR.orderPoints(arPtBds);
			
			
			Point3d arPtTop[0], arPtBot[0];
			for (int p = 0; p < arPtBds.length(); p++)
			{
				if ((arPtBds[p] - ptHalfWallUp).dotProduct(el.vecY()) > U(0))arPtTop.append(arPtBds[p]);
				else arPtBot.append(arPtBds[p]);
			}
			
			//Top
			{
				Point3d arPtTopL[0], arPtTopR[0];
				
				for (int p = 0; p < arPtTop.length(); p++) {
					Point3d pt = arPtTop[p];
					pt.transformBy(ms2ps);
					pt.vis(20);
					
					
					if (abs(el.vecX().dotProduct(arPtTop[p] - arPtTop[0])) <= dTol)arPtTopL.append(arPtTop[p]);
					else if (abs(el.vecX().dotProduct(arPtTop[arPtTop.length() - 1] - arPtTop[p])) <= dTol)arPtTopR.append(arPtTop[p]);
				}
				arPtTopL = lnBU.orderPoints(arPtTopL);
				arPtTopR = lnBU.orderPoints(arPtTopR);
				ptTL = arPtTopL[arPtTopL.length() - 1];
				ptTR = arPtTopR[arPtTopR.length() - 1];
			}
			//Bottom
			{
				Point3d arPtBottomL[0], arPtBottomR[0];
				
				for (int p = 0; p < arPtBot.length(); p++) {
					if (abs(el.vecX().dotProduct(arPtBot[p] - arPtBot[0])) <= dTol)arPtBottomL.append(arPtBot[p]);
					else if (abs(el.vecX().dotProduct(arPtBot[arPtBot.length() - 1] - arPtBot[p])) <= dTol)arPtBottomR.append(arPtBot[p]);
				}
				arPtBottomL = lnBU.orderPoints(arPtBottomL);
				arPtBottomR = lnBU.orderPoints(arPtBottomR);
				ptBL = arPtBottomL[0];
				ptBR = arPtBottomR[0];
			}
		}
		
		LineSeg lnSeg(ptBL, ptTR);
		
		strText.formatUnit(lnSeg.length() * dmm, pDimStyle);
		
		lnSeg.transformBy(ms2ps);
		dpLS.draw(lnSeg);
		}
	}
else if (pType==strWallGroup) {
	Group g=el.elementGroup();
	String str=g.name();
	//for(int n = 0;n<g.length();n++){
		
		
		
	//}
	String sGroup = g.namePart(iG);
	//if(iG==0)sGroup=sGroup.token(0,"\\");
  strText=sGroup;//.formatUnit(sGroup,pDimStyle);
}
else if (pType==strFrameThickness) {
  strText.formatUnit(el.dBeamWidth()*dmm,pDimStyle);
}
else if (pType == strPanelWeight)
{ 
	double dTotalWeight = 0;
	GenBeam arGb[] = el.genBeam();
	for(int i=0;i<arGb.length();i++)
	{ 
		GenBeam gb = arGb[i];
		
		if(gb.bIsKindOf(Beam()))
		{ 
			dTotalWeight += gb.volume() * dLumberDensity;
		}
		if(gb.bIsKindOf(Sheet()))
		{ 
			dTotalWeight += gb.volume() * dSheathingDensity;
		}
	}
	strText = ceil(dTotalWeight) + " LBS";
}
else if (pType==strStudLength) {
  Beam bms[0]; // declare new array of beams with arraylength 0
  bms = el.beam(); // get all beams of element
  double dLen = 0; // declare variable dLen
  for (int b=0; b<bms.length(); b++) { // loop over all beams
    //if (bms[b].name("hsbId")=="99") { // take only hsbid 99
    if (bms[b].type()==_kStud) { // take only stud
      dLen = bms[b].dL(); // this length is without the end tools, eg tenon
      break; // stop for loop, we have found one
    }
  }
  strText.formatUnit(dLen*dmm,pDimStyle);
}
else if (pType==strBPL) {
  Beam bms[0]; // declare new array of beams with arraylength 0
  bms = el.beam(); // get all beams of element
  double dLen = 0; // declare variable dLen
  for (int b=0; b<bms.length(); b++) { // loop over all beams
    //if (bms[b].name("hsbId")=="99") { // take only hsbid 99
    if (bms[b].type()==_kSFBottomPlate) { // take only stud
      dLen = bms[b].dL(); // this length is without the end tools, eg tenon
      break; // stop for loop, we have found one
    }
  }
  strText.formatUnit(dLen*dmm,pDimStyle);
}
else if (pType==strStudFirst) {
	Point3d ptNewOrg=el.ptOrg();
	Beam arBm[]=el.beam();
	Beam bms[0]; // declare new array of beams with arraylength 0
	Beam bmA[]=el.vecX().filterBeamsPerpendicularSort(el.beam());
	for (int b=0; b<bmA.length(); b++) { // loop over all beams
		String Mod = bmA[b].module();
		if (bmA[b].type()==_kStud && Mod=="" )bms.append(bmA[b]);//if (bmA[b].type()==_kStud||bmA[b].type()==_kSFJackOverOpenig||bmA[b].type()==_kSFJackUnderOpening)bms.append(bmA[b]);
		String arIds[]={"105","214","4101"};   
		if (arIds.find(bmA[b].hsbId())>-1 && abs(el.vecX().dotProduct(bmA[b].ptCen()-el.ptOrg()))>U(39))bms.append(bmA[b]);
	}
	for (int i=0; i<arBm.length(); i++) { 
		if (arBm[i].type()==_kSFBottomPlate) { 
			ptNewOrg=arBm[i].ptCen()-el.vecX()*0.5*arBm[i].dL();
			break;
		}
	}
	//double dLen
	if(bms.length()==0){
		strText="None found";
	}

	//double dLen = abs(el.vecX().dotProduct(bms[0].ptCen()-el.ptOrg())); // this length is without the end tools, eg tenon
	else if(abs(el.vecX().dotProduct(bms[0].ptCen()-el.ptOrg()))<U(39)){strText="None found";} 
	else{
		double dAdd=0;
		String strLetter=" C";
		if(strFSL==arStringFS[0]){
			dAdd=bms[0].dD(el.vecX())/2*-1;
			strLetter=" L";
		}
		else if(strFSL==arStringFS[2]){
			dAdd=bms[0].dD(el.vecX())/2;
			strLetter=" R";
		}	
		String strText1;strText1.formatUnit((abs(el.vecX().dotProduct(bms[0].ptCen()-ptNewOrg))+dAdd)*dmm,pDimStyle);
		strText=strText1+strLetter;
	}
}
else if (pType==strBundleInfo){
	strText = "N/A";
	Group gr("X - STACKER","EXPORT","");	
	Entity entsAll[] = gr.collectEntities(FALSE,TslInst(),_kModel);
	for (int i=0; i<entsAll.length(); i++) {
		TslInst tsl = (TslInst) entsAll[i];
		Map map = tsl.bIsValid() ? tsl.map() : Map();
		if(map.hasMap("mpStackLocation")){
			Entity entX = map.getEntity("mpStackChildPanel\\entEl");
			Element elX = (Element) entX;
			if (!elX.bIsValid()) continue;
			if (elX.handle() != el.handle()) continue;
			Map mp=map.getMap("mpStackLocation");
			String stId;			
			String stPrefix=mp.getString("stPrefix");
			if(stPrefix.length()>0)stId+=String(stPrefix + "-");			
			String stStack= mp.getInt("iStack");
			if(stStack.length() < 3)stStack= String(mp.getInt("iStack")+1000).right(3);
			stId+=String(stStack + "-");			
			String stRow= mp.getInt("iRow");
			if(stRow.length() < 3)stRow= String(mp.getInt("iRow")+1000).right(3);
			stId+=String(stRow + "-");			
			String stPlace= mp.getInt("iPlace");
			if(stPlace.length() < 3)stPlace= String(mp.getInt("iPlace")+1000).right(3);	
			stId+=stPlace;
			strText = stId;	
			break;
		}
		else continue;
	}
}










// when debug is on, and the string is empty, replace it with ...
if ( (_bOnDebug) && (strText=="") ) {
    strText = "...";
}
Display dp(-1); // use color of entity
dp.dimStyle(pDimStyle);
if(dTH!=0){
	dp.textHeight(dTH);
} 

CoordSys csRotate;
csRotate.setToRotation(iRotation,_ZW,_Pt0);

CoordSys csDraw(_PtW,_XW,_YW,_ZW);
csDraw.transformBy(csRotate);


int iXFlag = 1;
if(stJustification == arJustification[1])iXFlag = -1;

// draw the text at insert point
dp.draw(strText ,_Pt0,csDraw.vecX(),csDraw.vecY(),iXFlag,1);

























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
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Added panel weight" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="1/10/2023 10:02:45 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="V1.5 02/25/2022  Added rotation and diagonal options" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="2/25/2022 9:21:15 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End