#Version 8
#BeginDescription
V6.3__09/13/2019__Standartized sorting method
V6.2__July_31_2019__Supports trusses. Fixed squash blockings
V6.1__Jan_07_2019__Will not delete blocking on element generation
V6.0__Added Lower Block with Squash Blocking option. Beam sort neglects beams with X-axis not in element XY plane.
V.5.0_ _No stretching , 1/8 gap each side, Full bay distribution from selected point, Distribution limits acording to shortest beam
V4.0__Fixed stretching to joists. added option for blocking sizes.
V3.0__Added option for manual distribution, option for squash blocks extra height
V2.6__Bugfix
V2.5__13Oct2017__Works on shorter pieces as well
V2.4__13Oct2017__Will ignor flat 2x6 material
V2.3__27Sept2017__Can insert based on a selection
V2.2_Jan 25 2013_Added upper 2x4
Version 2.1 Checks for Panhand beams
Version 2.0 Can now select 2 floors when inserting the ladder
Version 1.9 Added a take away value from the rim length
Version 1.8 Spaced ladders to 32 inch
Version 1.7 Will now Remain in Floor if inserted manualy
Version 1.6 Fixed _Beam sorting when inserted from Details
Verison 1.5 Revised to have double squash blocks
Version 1.4 Added a property to set double squash seperately so that DSP's keep existing functionality
Version 1.3 Changed vectors and locations for SquashBlocks options  CC
Version 1.2 Added ladder options
Version 1.1 Addapted for roof ladders as well
Version 1.0





















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 6
#MinorVersion 3
#KeyWords 
#BeginContents
Unit (1,"inch");
String joistBlocking = T("|Joist Blocking|");
String ULFLat = T("|Upper & Lower Flat Blocking|");
String UppFlat = T("|Upper Flat Blocking|");
String LowFlat = T("|Lower Flat Blocking|");
String SqBlocking = T("|Squash Blocking|");
String SqDoublesided = T("|Squash Blocking (double sided)|");
String LowAndSqBlocking = T("|Lower Block With Squash Blocking|");
String UppVert = T("|Upper Blocking|");

String stSelection = "Selection";
String arTypes[]={joistBlocking,ULFLat,UppFlat, LowFlat, SqBlocking, SqDoublesided, LowAndSqBlocking, UppVert,stSelection };
PropString strType(0,arTypes,"Blocking type");
 

//Number of blocks
PropInt nNrOfBlocks(1,0,"Number of Blocks. 0 = unlimited",1);
PropDouble dDistrib (2, U(16), "Distrubution");
String TwoByFour = T("|2x4|");
String TwoBySix = T("|2x6|");
String arSize[] ={ TwoByFour, TwoBySix};
PropString strSize(3, arSize, "Blocking size",0);
PropDouble dSqH(4, U(0), "Squash Blocks extra height");


double dBmL = U(1);
String Automatic = T("|Full bay length|");
String Manual = T("|Manual distribution limits|");
String arMethod[] ={ Automatic, Manual};
PropString strMethod(5, arMethod, "Distribution method", 0);
String AutoDetect = T("|Automatic bay boundaries detection|");
String ManualSelect = T("|Manualy select limit beams|");
String arDetect[] = { AutoDetect, ManualSelect};
PropString strDetect(6, arDetect, "Limit method", 0);


String stSelect = "Select beam to copy as blocking";
addRecalcTrigger(_kContext, stSelect);
String stSelectionRemove = "Remove selected beam";
addRecalcTrigger(_kContext, stSelectionRemove);
String stReGenerate = "Regenerate Blocking";
addRecalcTrigger(_kContext, stReGenerate);
String stLimitBeams = "Reselect limit beams";
addRecalcTrigger(_kContext, stLimitBeams);
_ThisInst.setSequenceNumber(200);

if(_kExecuteKey == stSelectionRemove)
{ 
	_Map.removeAt("mpBeamSelection", true);
}

//This is the insert routine
//that takes care of the selection of an element
if (_bOnInsert || _kExecuteKey == stSelect)
{
	if (insertCycleCount() > 1)eraseInstance();
	if (_bOnInsert)
	{
		
		showDialogOnce("");
		// the constructor of PrEntity requires a type of entity. Here we use Element()
		PrEntity ssE("\nSelect 1 floor or 2 floors\nThe ladder will belong to first floor selected\n", ElementRoof());
		if (ssE.go()) { //let the prompt class do its job, only one run
			Entity ents[0]; //the PrEntity will return a list of entities, and not elements
			// copy the list of selected entities to a local array: for performance and readability
			ents = ssE.set();
			// turn the selected set into an array of elements
			for (int i = 0; i < ents.length(); i++) {
				ElementRoof el = (ElementRoof)ents[i]; //cast the entity to a element
				_Element.append(el);
			}
			// Make the insertion point the origin of the first element selected.
			if (_Element.length() == 0) {
				// No elements selected then blow this instance away!
				eraseInstance();
			}
		}
		if (strMethod == Automatic) _Pt0 = getPoint("\n Select an insertion point within stud bay");
		if (strMethod == Manual)
		{
			_PtG.append(getPoint("\n Select an insertion point within stud bay -start distribution"));
			Point3d ptlast = _PtG[0];
			while (_PtG.length() < 2)
			{
				PrPoint prp2("\n Select an insertion point within stud bay -end distribution", ptlast);
				if (prp2.go() == _kOk)
				{
					ptlast = prp2.value();
					_PtG.append(ptlast);
				}
				else
				{
					break;
				}
			}
			_Pt0 = _PtG[0];
			
			
		}
		if (strDetect == ManualSelect) 
		{
			PrEntity ssB("\n Select limit beams(trusses)", Beam());
			ssB.addAllowedClass(TrussEntity());
			if (ssB.go())
			{
				Entity ents[] = ssB.set();
				_Entity.append(ents.first());
				_Entity.append(ents.last());
			}
		}

		
	}
	else
	{
		strType.set(stSelection);
	}
	
	
	if (strType == stSelection )
	{
		Entity ent = getEntity("\nSelect a beam(truss) to copy for blocking");
		Beam bm = (Beam) ent;
		TrussEntity te = (TrussEntity) ent;
		Map mpBm;
		if (bm.bIsValid() || te.bIsValid())
		{
			mpBm.setEntity("beamCopy", ent);
			_Map.setMap("mpBeamSelection" , mpBm);
		}
	}
}

if (_Beam.length()>0){
	for (int i=0; i<_Beam.length(); i++) if (_Beam[i].bIsValid()) _Entity.append(_Beam[i]);
	_Beam.setLength(0);
}
	
	if (_kExecuteKey == stLimitBeams)
	{
		for (int i=_Entity.length()-1; i>-1; i--)
		{
			if (!_Entity[i].bIsKindOf(Element())) _Entity.removeAt(i);
		}		
		PrEntity ssB("\n Select limit beams(trusses)", Beam());
		ssB.addAllowedClass(TrussEntity());
		if (ssB.go())
		{
			Entity ents[] = ssB.set();
			_Entity.append(ents.first());
			_Entity.append(ents.last());
		}		
	}
	
	Entity arBmLad[0];
	
	Display dp(-1);
	PLine pl1, pl2, pl3, pl4;
	
	//TSL might be inserted from Details. We do not want it to stick to the element.
	int nDeleteScript = 0;
	Entity arBmAll[0];
	Element el;

{
	if (_Element.length() == 0) {
		eraseInstance();
	}
	
	
	el = _Element.first();
	
	Beam arBm1[] = el.beam();
	Group elG1 = el.elementGroup();
	Entity entTrusses1[] = elG1.collectEntities(true, TrussEntity(), _kModelSpace);	
	
	if (arBm1.length() == 0 && entTrusses1.length() == 0) { return; }
	else
	{
		arBmAll.append(entTrusses1);
		for (int i = 0; i < arBm1.length(); i++) arBmAll.append((Entity) arBm1[i]);
	}
	
	Element el2;
	if (_Element.length() > 1)
	{
		el2 = _Element[1];
		Beam arBm2[] = el2.beam();
		Group elG2 = el2.elementGroup();
		Entity entTrusses2[] = elG2.collectEntities(true, TrussEntity(), _kModelSpace);	
		if (arBm2.length()>0 || entTrusses2.length()>0)
		{
			arBmAll.append(entTrusses2);
			for (int i = 0; i < arBm2.length(); i++) arBmAll.append((Entity) arBm2[i]);
		}
	}
	
	assignToElementGroup(el, TRUE, 0, 'Z');
}
//else 
//{
//	el = _Element.first(); 
//	assignToElementGroup(el, TRUE, 0, 'Z');
//}


if (strDetect == AutoDetect) {
	Entity arBm[0];
	String arTemp[0];
	Quader qdBm[0];
	Beam bmsOnly[0];
	for (int i = 0; i < arBmAll.length(); i++)
	{
		Quader qdI;
		if (arBmAll[i].bIsKindOf(Beam())) 
		{
			Beam bmQ = (Beam) arBmAll[i];
			qdI = bmQ.quader();			
		}
		else if (arBmAll[i].bIsKindOf(TrussEntity()))
		{
			TrussEntity te = (TrussEntity) arBmAll[i];
			TrussDefinition td = te.definition();
			Map mp = td.subMapX("Content");
			double sizes[] = { mp.getVector3d("Length").length(), mp.getVector3d("Width").length(), mp.getVector3d("Height").length()};
			CoordSys csT = te.coordSys();
			Quader qdT(csT.ptOrg() + 0.5*sizes[0]*csT.vecX() + 0.5*sizes[2]*csT.vecZ(), csT.vecX(), csT.vecY(), csT.vecZ(), sizes[0], sizes[1], sizes[2], 0, 0, 0);			
			qdI = qdT;
		}
		
		if (qdI.vecX().isParallelTo(el.vecZ())) continue;
		if (qdI.vecX().isPerpendicularTo(el.vecX())) 
		{
			arBm.append(arBmAll[i]);
			qdBm.append(qdI);
			arTemp.append(String().format("%09.4f", abs((qdI.ptOrg() - (_PtW - U(5000) * el.vecX())).dotProduct(el.vecX()))) + "@" + String(arBm.length() - 1));
			if (arBmAll[i].bIsKindOf(Beam())) bmsOnly.append((Beam) arBmAll[i]);
		}
	}
	if (arBm.length()>1)
	{
		Entity entTemp[0];
		Quader qdTemp[0];
		String arTempSorted[] = arTemp.sorted();
		for (int i = 0; i < arTemp.length(); i++)
		{
			entTemp.append(arBm[arTempSorted[i].token(1, "@").atoi()]);
			qdTemp.append(qdBm[arTempSorted[i].token(1, "@").atoi()]);
		}
		arBm.setLength(0);
		arBm.append(entTemp);
		qdBm.setLength(0);
		qdBm.append(qdTemp);
	}
		
	if (arBm.length() == 0)return;
	
	//Count the amount of panhands
	int nPanHandCount = 0;
	
	for (int i = 0; i < bmsOnly.length(); i++)
	{
		Entity ent = bmsOnly[i].panhand();
		if (ent.bIsValid())nPanHandCount++;
	}
	
	if (bmsOnly.length() - nPanHandCount < 1)return;
	
	
	
	for (int i = 1; i < arBm.length(); i++)
	{
		Quader bmBefore = qdBm[i - 1];
		Quader bmAfter = qdBm[i];
		double dBefore = el.vecX().dotProduct(bmBefore.ptOrg() - _Pt0);
		double dAfter = el.vecX().dotProduct(bmAfter.ptOrg() - _Pt0);
		if (dBefore * dAfter < 0)
		{
			arBmLad.append(arBm[i-1]);
			arBmLad.append(arBm[i]);
			break;
		}
	}
}
		


	

Entity arBmToUse[0];
if (_Entity.length() >= 2) 
{
	for (int i=_Entity.length()-1; i>-1; i--)
	{
		if (!_Entity[i].bIsKindOf(Element())) arBmToUse.append(_Entity[i]);
	}	
	nDeleteScript = 0;
}
else if (arBmLad.length() >= 2) 
{
	arBmToUse.append(arBmLad);
	nDeleteScript = 0;
}
else 
{
	Display dpEr(1);
	String strEr = "Bay limit beams not found";
	dpEr.textHeight(U(2));
	dpEr.draw(strEr, _Pt0, el.vecY(), -el.vecX(), 1, 0);
	
}

//Clear Map

if( _kExecuteKey == stReGenerate)
{
	Map mpBms = _Map.getMap("mpBms");
	
	for(int i=0; i<mpBms.length(); i++) 
	{
		Entity ent=mpBms.getEntity(i);
		if(ent.bIsValid())	ent.dbErase();
	}
	_Map.removeAt("mpBms", true);
}

int bIsBeam1 = arBmToUse[0].bIsKindOf(Beam()) ? true : false;
int bIsBeam2 = arBmToUse[1].bIsKindOf(Beam()) ? true : false;

///Set the proper type
if(!_bOnInsert)
{
	if (bIsBeam1)
	{	
		Beam bm = (Beam) arBmToUse[0];
		String strCode1= bm.beamCode().token(0);strCode1.makeUpper();		
		if (strCode1 == "X") {
			strType.set(joistBlocking);
			nDeleteScript = 1;
			dDistrib.set(U(32));
		}
		
		else if (strCode1 == "Y") {
			strType.set(LowAndSqBlocking);
			nDeleteScript = 1;
			dDistrib.set(U(32));
		}
		
	}
	if (bIsBeam2)
	{
		Beam bm = (Beam) arBmToUse[1];
		String strCode2= bm.beamCode().token(0);strCode2.makeUpper();
		if (strCode2 == "X") {
			strType.set(joistBlocking);
			arBmToUse.swap(0, 1);
			nDeleteScript = 1;
			dDistrib.set(U(32));
		}
		else if (strCode2 == "Y") {
			strType.set(LowAndSqBlocking);
			arBmToUse.swap(0, 1);
			nDeleteScript = 1;
			dDistrib.set(U(32));
		}
	}
}


Entity bm1 = arBmToUse[0];
Entity bm2 = arBmToUse[1];
Quader qd1, qd2;
for (int i=0; i<arBmToUse.length(); i++)
{
	Quader qdI;
	if (arBmToUse[i].bIsKindOf(Beam())) 
	{
		Beam bmQ = (Beam) arBmToUse[i];
		qdI = bmQ.quader();			
	}
	else if (arBmToUse[i].bIsKindOf(TrussEntity()))
	{
		TrussEntity te = (TrussEntity) arBmToUse[i];
		TrussDefinition td = te.definition();
		Map mp = td.subMapX("Content");
		double sizes[] = { mp.getVector3d("Length").length(), mp.getVector3d("Width").length(), mp.getVector3d("Height").length()};
		CoordSys csT = te.coordSys();
		Quader qdT(csT.ptOrg() + 0.5*sizes[0]*csT.vecX() + 0.5*sizes[2]*csT.vecZ(), csT.vecX(), csT.vecY(), csT.vecZ(), sizes[0], sizes[1], sizes[2], 0, 0, 0);			
		qdI = qdT;
	}
	if (i == 0) qd1 = qdI;
	if (i == 1) qd2 = qdI;
}


double dBlkW = qd1.dD(qd1.vecY());
double dBlkH = qd1.dD(qd1.vecZ());
String extProf[] = ExtrProfile().getAllEntryNames();
String stEP = "";
if (bm1.bIsKindOf(Beam()))
{
	Beam bm = (Beam) bm1;
	stEP = bm.extrProfile();
}

if(_Map.hasMap("mpBeamSelection"))
{ 
	Map mp = _Map.getMap("mpBeamSelection");
	Entity ent = mp.getEntity("beamCopy");	
	
	if (ent.bIsKindOf(Beam())) 
	{
		Beam bmQ = (Beam) ent;
		dBlkW = bmQ.dW();
		dBlkH = bmQ.dH();
		stEP = bmQ.extrProfile();
	}
	else if (ent.bIsKindOf(TrussEntity()))
	{
		TrussEntity te = (TrussEntity) ent;
		TrussDefinition td = te.definition();
		Map mp = td.subMapX("Content");
		double sizes[] = { mp.getVector3d("Length").length(), mp.getVector3d("Width").length(), mp.getVector3d("Height").length()};
		dBlkW = sizes[1];
		dBlkH = sizes[2];
	}
	
}

Quader qdLongest = qd1;
Quader qdShortest = qd2;
if (qd1.dD(qd1.vecX())<qd2.dD(qd2.vecX()))
{
	qdLongest = qd2;
	qdShortest = qd1;
}

	
Vector3d vMF=qd1.vecX().crossProduct(_ZW);
if(vMF.dotProduct(qd1.ptOrg()-qd2.ptOrg())>0)vMF=-vMF;
//vMF.vis(bm1.ptCen(),1);
vMF.normalize();

//take away this from the length
double dTakeAway=U(5.5); 

Point3d arPtEnds[0];
if (strMethod == Automatic) 
{
	arPtEnds.append(qdShortest.ptOrg() - 0.5 * (qdShortest.dD(qdShortest.vecX()) - dTakeAway) * qdShortest.vecX());
	arPtEnds.append(qdShortest.ptOrg() + 0.5 * (qdShortest.dD(qdShortest.vecX()) - dTakeAway) * qdShortest.vecX());
	arPtEnds.append(qdLongest.ptOrg() - 0.5 * (qdLongest.dD(qdLongest.vecX()) - dTakeAway) * qdLongest.vecX());
	arPtEnds.append(qdLongest.ptOrg() + 0.5 * (qdLongest.dD(qdLongest.vecX()) - dTakeAway) * qdLongest.vecX());
}
Point3d ptBayCen = qd1.ptOrg() - 0.5 * qd1.dD(qd1.vecX()) * qd1.vecX();
Line lnbmS(qdShortest.ptOrg() - 0.5 * qdShortest.dD(qdShortest.vecX()) * qdShortest.vecX(), qdShortest.vecX());
Line lnbmL(qdLongest.ptOrg() - 0.5 * qdLongest.dD(qdLongest.vecX()) * qdLongest.vecX(), qdLongest.vecX());
Line lnbm1(qd1.ptOrg() - 0.5 * qd1.dD(qd1.vecX()) * qd1.vecX(), qd1.vecX());
double bmCenDiff = abs((qdShortest.ptOrg() - lnbmL.closestPointTo(qdShortest.ptOrg())).length());
ptBayCen = ptBayCen + 0.5*bmCenDiff * vMF;
Line lnBayCen(ptBayCen, qd1.vecX());

Line lnProject(qd1.ptOrg() - 0.5 * qd1.dD(qd1.vecX()) * qd1.vecX()-(0.5*bmCenDiff-U(2))*qd1.vecY(), qd1.vecX());
if (strMethod == Manual)_Pt0 = lnProject.closestPointTo(_Pt0);
if (strMethod == Automatic)_Pt0 = lnBayCen.closestPointTo(_Pt0);
 

Plane pnEl(el.ptOrg(),el.vecZ());
Point3d ptDraw = _Pt0.projectPoint(pnEl, 0);

Vector3d vTxt=el.vecY();
if(vTxt.dotProduct(_YW)<0)vTxt=-el.vecY();

Vector3d vTxtY=_ZW.crossProduct(vTxt);


pl2=PLine(ptDraw+U(8)*el.vecY(),ptDraw-U(8)*el.vecY());dp.draw(pl2);
pl3.addVertex(ptDraw+U(5)*el.vecY()+U(1.5)*el.vecX());
pl3.addVertex(ptDraw+U(8)*el.vecY());
pl3.addVertex(ptDraw+U(5)*el.vecY()-U(1.5)*el.vecX());
dp.draw(pl3);
pl4.addVertex(ptDraw-U(5)*el.vecY()+U(1.5)*el.vecX());
pl4.addVertex(ptDraw-U(8)*el.vecY());
pl4.addVertex(ptDraw-U(5)*el.vecY()-U(1.5)*el.vecX());
dp.draw(pl4);
dp.textHeight(U(1.5));
dp.draw("Ladder",ptDraw+U(1)*vTxtY,vTxt,vTxtY,0,1);


if (strMethod == Manual) 
{
	_PtG[0] = lnBayCen.closestPointTo(_PtG[0]);
	_PtG[1] = lnBayCen.closestPointTo(_PtG[1]);
}
Point3d arPtEndRef[0];
if (strMethod == Automatic) {
	arPtEnds = Line(qdShortest.ptOrg(), qdShortest.vecX()).orderPoints(arPtEnds);
	arPtEndRef.append(arPtEnds[1]);
	arPtEndRef.append(arPtEnds[2]);
	
}
qd1.ptOrg().vis(3);
qd2.ptOrg().vis(5);
//////////////////////////////////////////////////////////////////////////
if(nDeleteScript==1 || _bOnInsert  || _kExecuteKey == stReGenerate)
{
	double blWidth = U(1.5);
	double blLength;
	if (strSize == TwoByFour) blLength = U(3.5);
	else blLength = U(5.5);
	String squashSize = strSize == TwoByFour ? "2x4" : "2x6";
	////////////////////////standard Joist Blocking
	if(strType==joistBlocking || strType==stSelection){
		Point3d arPtBlock[0];
		if (strMethod == Automatic) {
			Point3d ptRef = _Pt0;
			arPtBlock.append(ptRef);
			//arPtBlock.append(ptRef);
			
			Point3d ptRef1 = ptRef;
			Point3d ptRef2 = ptRef;
			for (int i = 0; i < 50; i++) {
				ptRef1.transformBy(qd1.vecX() * dDistrib);
				if (qd1.vecX().dotProduct(ptRef1 - arPtEndRef[0]) * qd1.vecX().dotProduct(ptRef1 - arPtEndRef[1]) < 0) arPtBlock.append(ptRef1);
				else break;				
			}
			for (int i = 0; i < 50; i++) {
				ptRef2.transformBy(qd1.vecX() *- 1 * dDistrib);
				if (qd1.vecX().dotProduct(ptRef2 - arPtEndRef[0]) * qd1.vecX().dotProduct(ptRef2 - arPtEndRef[1]) < 0) arPtBlock.append(ptRef2);
				else break;
			}
		}
		if (strMethod == Manual){
			Vector3d vecDistr = _PtG[1] - _PtG[0];
			double limits = abs((_PtG[1] - _PtG[0]).length());
			Point3d ptRef0 = _PtG[0];
			arPtBlock.append(ptRef0);
			if (nNrOfBlocks != 0){
				double eqdist = limits/(nNrOfBlocks-1);
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlock.append(ptRef0);
					else break;
				}
			}
			else {
				double d0Distr = dDistrib;
				double devide = limits/d0Distr;
				if (devide < 1) reportError("Manual limits smaller then distribution value");
				while(devide>=1)
				{
					devide--;
				}
				double remainder = devide;
				double newNumBlocks;
				if (remainder < 1) newNumBlocks = ceil(limits/d0Distr);								
				else newNumBlocks = (limits / d0Distr) +1;
				double eqdist = limits / newNumBlocks;
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlock.append(ptRef0);
					else break;
				}
			}
		}
	
		for (int i=0; i<arPtBlock.length(); i++) {	
			Point3d pt=arPtBlock[i];
			Vector3d vH=vMF.crossProduct(qd1.vecX());vH.normalize();
			pt.vis(1);
			Beam bmNew;
			bmNew.dbCreate(pt,vMF,qd1.vecX(),vH,bmCenDiff-qd1.dD(vMF)-U(0.25),dBlkW, dBlkH,0,0,0);
//			bmNew.stretchDynamicTo(bm1);
//			bmNew.stretchDynamicTo(bm2);
			
			bmNew.setType(_kBlocking);
			if (extProf.find(stEP)>-1) bmNew.setExtrProfile( stEP);
			bmNew.setHsbId("12");
			bmNew.setColor(bm1.color());
			bmNew.setInformation("JOIST BLOCKING"); 
			_Map.appendEntity("mpBms\\entBm", bmNew);
			bmNew.setPanhand(el);
			Element el1=bm1.element();
			if(el.bIsValid())bmNew.assignToElementGroup(el,TRUE,0,'Z');
			else bmNew.assignToLayer(bm1.layerName());
			
		}
	}
	
	///////////////////////Upper & lower block
	if(strType==ULFLat){
		Vector3d vH=vMF.crossProduct(qd1.vecX());vH.normalize();
		if(vH.dotProduct(Point3d(0,0,0)-Point3d(0,0,200))<0) vH=-vH;
		
		Point3d arPtBlockUP[0];
		if (strMethod == Automatic) {
			Point3d arptU = _Pt0 - qd1.dD(qd1.vecZ()) / 2 * vH;
			arPtBlockUP.append(arptU);
			
			Point3d ptRef1 = arptU;
			Point3d ptRef2 = arptU;
			for (int i = 0; i < 50; i++)
			{
				
				ptRef1.transformBy(qd1.vecX() * dDistrib);
				if (qd1.vecX().dotProduct(ptRef1 - arPtEndRef[0]) * qd1.vecX().dotProduct(ptRef1 - arPtEndRef[1]) < 0) arPtBlockUP.append(ptRef1);
				else break;
			}
			for (int i = 0; i < 50; i++)
			{
				
				ptRef2.transformBy(qd1.vecX() *- 1 * dDistrib);
				if (qd1.vecX().dotProduct(ptRef2 - arPtEndRef[0]) * qd1.vecX().dotProduct(ptRef2 - arPtEndRef[1]) < 0) arPtBlockUP.append(ptRef2);
				else break;
			}
		}
		if (strMethod == Manual){
			Vector3d vecDistr = _PtG[1] - _PtG[0];
			double limits = abs((_PtG[1] - _PtG[0]).length());
			Point3d ptRef0 = _PtG[0] - qd1.dD(qd1.vecZ())/2*vH;
			arPtBlockUP.append(ptRef0);
			if (nNrOfBlocks != 0){
				double eqdist = limits/(nNrOfBlocks-1);
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlockUP.append(ptRef0);
					else break;
				}
			}
			else {
				double d0Distr = dDistrib;
				double devide = limits/d0Distr;
				if (devide < 1) reportError("Manual limits smaller then distribution value");
				while(devide>=1)
				{
					devide--;
				}
				double remainder = devide;
				double newNumBlocks;
				if (remainder < 1) newNumBlocks = ceil(limits/d0Distr);								
				else newNumBlocks = (limits / d0Distr) +1;
				double eqdist = limits / newNumBlocks;
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlockUP.append(ptRef0);
					else break;
				}
			}
		}
		Point3d arPtBlockL[0];
		if (strMethod == Automatic) {
			Point3d arptL = _Pt0 + qd1.dD(qd1.vecZ()) / 2 * vH - vH * U(1.5);
			arPtBlockL.append(arptL);
			
			Point3d ptRef3 = arptL;
			Point3d ptRef4 = arptL;
			for (int i = 0; i < 50; i++)
			{
				
				ptRef3.transformBy(qd1.vecX() * dDistrib);
				if (qd1.vecX().dotProduct(ptRef3 - arPtEndRef[0]) * qd1.vecX().dotProduct(ptRef3 - arPtEndRef[1]) < 0) arPtBlockL.append(ptRef3);
				else break;
			}
			for (int i = 0; i < 50; i++)
			{
				
				ptRef4.transformBy(qd1.vecX() *- 1 * dDistrib);
				if (qd1.vecX().dotProduct(ptRef4 - arPtEndRef[0]) * qd1.vecX().dotProduct(ptRef4 - arPtEndRef[1]) < 0) arPtBlockL.append(ptRef4);
				else break;
			}
		}
		if (strMethod == Manual){
			Vector3d vecDistr = _PtG[1] - _PtG[0];
			double limits = abs((_PtG[1] - _PtG[0]).length());
			Point3d ptRef0 = _PtG[0] +qd1.dD(qd1.vecZ())/2*vH -vH*U(1.5);
			arPtBlockL.append(ptRef0);
			if (nNrOfBlocks != 0){
				double eqdist = limits/(nNrOfBlocks-1);
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlockL.append(ptRef0);
					else break;
				}
			}
			else {
				double d0Distr = dDistrib;
				double devide = limits/d0Distr;
				if (devide < 1) reportError("Manual limits smaller then distribution value");
				while(devide>=1)
				{
					devide--;
				}
				double remainder = devide;
				double newNumBlocks;
				if (remainder < 1) newNumBlocks = ceil(limits/d0Distr);								
				else newNumBlocks = (limits / d0Distr) +1;
				double eqdist = limits / newNumBlocks;
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlockL.append(ptRef0);
					else break;
				}
			}
		}
	
	
		for (int i=0; i<arPtBlockUP.length(); i++) {	
			Point3d pt=arPtBlockUP[i];			
			pt.vis(3);
			Beam bmNew;
			bmNew.dbCreate(pt,vMF,qd1.vecX(),vH,bmCenDiff-qd1.dD(vMF)-U(0.25), blLength , blWidth ,0,0,1);
			bmNew.setType(_kBlocking);
			bmNew.setName(squashSize);
			bmNew.setHsbId("12");
			bmNew.setInformation("UPPER BLOCKING"); 
			bmNew.setColor(bm1.color());
			_Map.appendEntity("mpBms\\entBm", bmNew);
			bmNew.setPanhand(el);
			Element el1=bm1.element();
			if(el.bIsValid())bmNew.assignToElementGroup(el,TRUE,0,'Z');
			else bmNew.assignToLayer(bm1.layerName());			
		}
		for (int i=0; i<arPtBlockL.length(); i++) 
		{
			Point3d pt=arPtBlockL[i];	
			pt.vis(3);
			Beam bmNew;
			bmNew.dbCreate(pt,vMF,qd1.vecX(),vH,bmCenDiff-qd1.dD(vMF)-U(0.25), blLength , blWidth ,0,0,1);
			bmNew.setType(_kBlocking);
			bmNew.setName(squashSize);
			bmNew.setHsbId("12");
			bmNew.setInformation("LOWER BLOCKING");
			bmNew.setColor(bm1.color());
			_Map.appendEntity("mpBms\\entBm", bmNew);
			bmNew.setPanhand(el);
			Element el1=bm1.element();
			if(el.bIsValid())bmNew.assignToElementGroup(el,TRUE,0,'Z');
			else bmNew.assignToLayer(bm1.layerName());			
		}
		
	}
	
	////////////////////////Upper block
	if(strType==UppFlat){
		Vector3d vH=vMF.crossProduct(qd1.vecX());vH.normalize();
		if(vH.dotProduct(Point3d(0,0,0)-Point3d(0,0,200))<0) vH=-vH;
		
		Point3d arPtBlock[0];
		if (strMethod == Automatic) {
			Point3d ptRef = _Pt0 - qd1.dD(qd1.vecZ()) / 2 * vH;
			arPtBlock.append(ptRef);
			
			Point3d ptRef1 = ptRef;
			Point3d ptRef2 = ptRef;
			for (int i = 0; i < 50; i++) {
				ptRef1.transformBy(qd1.vecX() * dDistrib);
				if (qd1.vecX().dotProduct(ptRef1 - arPtEndRef[0]) * qd1.vecX().dotProduct(ptRef1 - arPtEndRef[1]) < 0) arPtBlock.append(ptRef1);
				else break;
			}
			for (int i = 0; i < 50; i++) {
				ptRef2.transformBy(qd1.vecX() *- 1 * dDistrib);
				if (qd1.vecX().dotProduct(ptRef2 - arPtEndRef[0]) * qd1.vecX().dotProduct(ptRef2 - arPtEndRef[1]) < 0) arPtBlock.append(ptRef2);
				else break;
			}
		}
		if (strMethod == Manual){
			Vector3d vecDistr = _PtG[1] - _PtG[0];
			double limits = abs((_PtG[1] - _PtG[0]).length());
			Point3d ptRef0 = _PtG[0]- qd1.dD(qd1.vecZ())/2*vH;
			arPtBlock.append(ptRef0);
			if (nNrOfBlocks != 0){
				double eqdist = limits/(nNrOfBlocks-1);
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlock.append(ptRef0);
					else break;
				}
			}
			else {
				double d0Distr = dDistrib;
				double devide = limits/d0Distr;
				if (devide < 1) reportError("Manual limits smaller then distribution value");
				while(devide>=1)
				{
					devide--;
				}
				double remainder = devide;
				double newNumBlocks;
				if (remainder < 1) newNumBlocks = ceil(limits/d0Distr);								
				else newNumBlocks = (limits / d0Distr) +1;
				double eqdist = limits / newNumBlocks;
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlock.append(ptRef0);
					else break;
				}
			}
		}
	
		for (int i=0; i<arPtBlock.length(); i++) {	
			Point3d pt=arPtBlock[i];
			
			pt.vis(1);
			Beam bmNew;
			bmNew.dbCreate(pt,vMF,qd1.vecX(),vH,bmCenDiff-qd1.dD(vMF)-U(0.25), blLength , blWidth ,0,0,1);
			bmNew.setType(_kBlocking);
			bmNew.setName(squashSize);
			bmNew.setHsbId("12");
			bmNew.setInformation("UPPER BLOCKING"); 
			bmNew.setColor(bm1.color());
			_Map.appendEntity("mpBms\\entBm", bmNew);
			bmNew.setPanhand(el);
			Element el1=bm1.element();
			if(el.bIsValid())bmNew.assignToElementGroup(el,TRUE,0,'Z');
			else bmNew.assignToLayer(bm1.layerName());
			
		}
	}
	
	////////////////////////Lower Block
	if(strType==LowFlat ){
		Vector3d vH=vMF.crossProduct(qd1.vecX());vH.normalize();
		if(vH.dotProduct(Point3d(0,0,0)-Point3d(0,0,200))<0) vH=-vH;
		
		Point3d arPtBlock[0];
		if (strMethod == Automatic){
			Point3d ptRef=_Pt0 + qd1.dD(qd1.vecZ())/2*vH;
			arPtBlock.append(ptRef);
			Point3d ptRef1=ptRef;
			Point3d ptRef2=ptRef;
			for(int i=0; i<50; i++) {
				ptRef1.transformBy(qd1.vecX()*dDistrib);
				if(qd1.vecX().dotProduct(ptRef1-arPtEndRef[0]) * qd1.vecX().dotProduct(ptRef1-arPtEndRef[1])<0) arPtBlock.append(ptRef1);
				else break;
			}
			for (int i=0; i<50; i++) {
				ptRef2.transformBy(qd1.vecX()*-1*dDistrib);
				if(qd1.vecX().dotProduct(ptRef2-arPtEndRef[0]) * qd1.vecX().dotProduct(ptRef2-arPtEndRef[1])<0) arPtBlock.append(ptRef2);
				else break;
			}
		}
		if (strMethod == Manual){
			Vector3d vecDistr = _PtG[1] - _PtG[0];
			double limits = abs((_PtG[1] - _PtG[0]).length());
			Point3d ptRef0 = _PtG[0] +qd1.dD(qd1.vecZ())/2*vH;
			arPtBlock.append(ptRef0);
			if (nNrOfBlocks != 0){
				double eqdist = limits/(nNrOfBlocks-1);
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlock.append(ptRef0);
					else break;
				}
			}
			else {
				double d0Distr = dDistrib;
				double devide = limits/d0Distr;
				if (devide < 1) reportError("Manual limits smaller then distribution value");
				while(devide>=1)
				{
					devide--;
				}
				double remainder = devide;
				double newNumBlocks;
				if (remainder < 1) newNumBlocks = ceil(limits/d0Distr);								
				else newNumBlocks = (limits / d0Distr) +1;
				double eqdist = limits / newNumBlocks;
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlock.append(ptRef0);
					else break;
				}
			}
		}
	
		for (int i=0; i<arPtBlock.length(); i++) {	
			Point3d pt=arPtBlock[i];
			Beam bmNew;
			bmNew.dbCreate(pt,vMF,qd1.vecX(),vH,bmCenDiff-qd1.dD(vMF)-U(0.25), blLength , blWidth ,0,0,-1);
			bmNew.setType(_kBlocking);
			bmNew.setName(squashSize);
			bmNew.setHsbId("12");
			bmNew.setInformation("LOWER BLOCKING");
			bmNew.setColor(bm1.color());
			_Map.appendEntity("mpBms\\entBm", bmNew);
			bmNew.setPanhand(el);
			Element el1=bm1.element();
			if(el.bIsValid())bmNew.assignToElementGroup(el,TRUE,0,'Z');
			else bmNew.assignToLayer(bm1.layerName());
			
		}
	}
	////////////////////////Squash Blocks
	if(strType==SqBlocking ){
		Vector3d vH=vMF.crossProduct(qd1.vecX());vH.normalize();
		if(vH.dotProduct(Point3d(0,0,0)-Point3d(0,0,200))<0) vH=-vH;
		
		Point3d arPtBlock[0];
		if (strMethod == Automatic) {
			Point3d ptRef = _Pt0 + 0.5*qdLongest.dD(vH)*vH;
			arPtBlock.append(ptRef);
			
			Point3d ptRef1 = ptRef;
			Point3d ptRef2 = ptRef;
			for (int i = 0; i < 50; i++) {
				ptRef1.transformBy(qdLongest.vecX() * dDistrib);
				if (qdLongest.vecX().dotProduct(ptRef1 - arPtEndRef[0]) * qdLongest.vecX().dotProduct(ptRef1 - arPtEndRef[1]) < 0) arPtBlock.append(ptRef1);
				else break;
			}
			for (int i = 0; i < 50; i++) {
				ptRef2.transformBy(qdLongest.vecX() *- 1 * dDistrib);
				if (qdLongest.vecX().dotProduct(ptRef2 - arPtEndRef[0]) * qdLongest.vecX().dotProduct(ptRef2 - arPtEndRef[1]) < 0) arPtBlock.append(ptRef2);
				else break;
			}
		}
		if (strMethod == Manual){
			Vector3d vecDistr = _PtG[1] - _PtG[0];
			double limits = abs((_PtG[1] - _PtG[0]).length());
			Point3d ptRef0 = _PtG[0] + 0.5*qd1.dD(qd1.vecZ()) * vH;
			arPtBlock.append(ptRef0);
			if (nNrOfBlocks != 0){
				double eqdist = limits/(nNrOfBlocks-1);
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlock.append(ptRef0);
					else break;
				}
			}
			else {
				double d0Distr = dDistrib;
				double devide = limits/d0Distr;
				if (devide < 1) reportError("Manual limits smaller then distribution value");
				while(devide>=1)
				{
					devide--;
				}
				double remainder = devide;
				double newNumBlocks;
				if (remainder < 1) newNumBlocks = ceil(limits/d0Distr);								
				else newNumBlocks = (limits / d0Distr) +1;
				double eqdist = limits / newNumBlocks;
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlock.append(ptRef0);
					else break;
				}
			}
		}
	
		double sqH = dSqH;
		for (int i=0; i<arPtBlock.length(); i++) {	
			Point3d pt=arPtBlock[i];
			
			pt.vis(1);
			Vector3d vcIn1 = (pt - Line(pt, vMF).closestPointTo(qd1.ptOrg()));
			vcIn1.normalize();
			Beam bmNew;
			bmNew.dbCreate(pt-(0.5*bmCenDiff-0.5*qd1.dD(vMF))*vcIn1,vH,qd1.vecX(),vcIn1,qd1.dD(qd1.vecZ())+sqH-blWidth, blLength , blWidth ,-1,0,1);
			bmNew.setType(_kBlocking);
			bmNew.setName(squashSize);
			bmNew.setHsbId("12");
			bmNew.setInformation("SQUASH BLOCKING"); 
			bmNew.setColor(bm1.color());
			_Map.appendEntity("mpBms\\entBm", bmNew);
			bmNew.setPanhand(el);
			Vector3d vcIn2 = (pt - Line(pt, vMF).closestPointTo(qd2.ptOrg()));
			vcIn2.normalize();
			Beam bmNew2;
			bmNew2.dbCreate(pt-(0.5*bmCenDiff-0.5*qd2.dD(vMF))*vcIn2,vH,qd1.vecX(),vcIn2,qd1.dD(qd1.vecZ())+sqH -blWidth, blLength, blWidth,-1,0,1);
			bmNew2.setType(_kBlocking);
			bmNew2.setName(squashSize);
			bmNew2.setHsbId("12");
			bmNew2.setInformation("SQUASH BLOCKING"); 
			bmNew2.setColor(bm1.color());
			_Map.appendEntity("mpBms\\entBm", bmNew2);
			bmNew2.setPanhand(el);
			Element el1=bm1.element();
			if(el.bIsValid()){
				bmNew.assignToElementGroup(el,TRUE,0,'Z');
				bmNew2.assignToElementGroup(el,TRUE,0,'Z');
			}
			else{
				bmNew.assignToLayer(bm1.layerName());
				bmNew2.assignToLayer(bm1.layerName());
			}
		}
	}
	////////////////////////Lower Blocking and Squash blocking
	if(strType==LowAndSqBlocking ){
		Vector3d vH=vMF.crossProduct(qd1.vecX());vH.normalize();
		if(vH.dotProduct(Point3d(0,0,0)-Point3d(0,0,200))<0) vH=-vH;
		
		Point3d arPtBlock[0];
		if (strMethod == Automatic) {
			Point3d ptRef =_Pt0  ;
			arPtBlock.append(ptRef);
			
			Point3d ptRef1 = ptRef;
			Point3d ptRef2 = ptRef;
			for (int i = 0; i < 50; i++) {
				ptRef1.transformBy(qdLongest.vecX() * dDistrib);
				if (qdLongest.vecX().dotProduct(ptRef1 - arPtEndRef[0]) * qdLongest.vecX().dotProduct(ptRef1 - arPtEndRef[1]) < 0) arPtBlock.append(ptRef1);
				else break;
			}
			for (int i = 0; i < 50; i++) {
				ptRef2.transformBy(qdLongest.vecX() *- 1 * dDistrib);
				if (qdLongest.vecX().dotProduct(ptRef2 - arPtEndRef[0]) * qdLongest.vecX().dotProduct(ptRef2 - arPtEndRef[1]) < 0) arPtBlock.append(ptRef2);
				else break;
			}
		}
		if (strMethod == Manual){
			Vector3d vecDistr = _PtG[1] - _PtG[0];
			double limits = abs((_PtG[1] - _PtG[0]).length());
			Point3d ptRef0 = _PtG[0] ;
			arPtBlock.append(ptRef0);
			if (nNrOfBlocks != 0){
				double eqdist = limits/(nNrOfBlocks-1);
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlock.append(ptRef0);
					else break;
				}
			}
			else {
				double d0Distr = dDistrib;
				double devide = limits/d0Distr;
				if (devide < 1) reportError("Manual limits smaller then distribution value");
				while(devide>=1)
				{
					devide--;
				}
				double remainder = devide;
				double newNumBlocks;
				if (remainder < 1) newNumBlocks = ceil(limits/d0Distr);								
				else newNumBlocks = (limits / d0Distr) +1;
				double eqdist = limits / newNumBlocks;
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlock.append(ptRef0);
					else break;
				}
			}
		}
	
		double sqH = dSqH;
		for (int i=0; i<arPtBlock.length(); i++) {	
			Point3d pt=arPtBlock[i];
			
			Point3d ptbmNew1 = pt - (0.5 * bmCenDiff - 0.5*qd1.dD(vMF)) * vMF + ((qd1.dD(qd1.vecZ())/2)-blWidth)*vH;
			ptbmNew1.vis(1);
			Beam bmNew;
			bmNew.dbCreate(ptbmNew1,vH,qd1.vecX(),vMF,qd1.dD(qd1.vecZ())+sqH-blWidth, blLength , blWidth ,-1,0,1);
			bmNew.setType(_kBlocking);
			bmNew.setName(squashSize);
			bmNew.setHsbId("12");
			bmNew.setInformation("SQUASH BLOCKING");
			bmNew.setColor(bm1.color());
			_Map.appendEntity("mpBms\\entBm", bmNew);
			bmNew.setPanhand(el);
			Beam bmNew2;
			Point3d ptbmNew2 = pt + (0.5 * bmCenDiff - 0.5*qd2.dD(vMF)) * vMF + ((qd1.dD(qd1.vecZ())/2)-blWidth)*vH;
			ptbmNew2.vis(5);
			bmNew2.dbCreate(ptbmNew2,vH,qd1.vecX(),vMF,qd1.dD(qd1.vecZ())+sqH -blWidth, blLength, blWidth,-1,0,-1);
			bmNew2.setType(_kBlocking);
			bmNew2.setName(squashSize);
			bmNew2.setHsbId("12");
			bmNew2.setInformation("SQUASH BLOCKING");
			bmNew2.setColor(bm1.color());
			_Map.appendEntity("mpBms\\entBm", bmNew2);
			bmNew2.setPanhand(el);
			Beam bmNew3;
			Point3d ptbmNew3 = pt + 0.5 * qd1.dD(qd1.vecZ()) * vH;
			bmNew3.dbCreate(ptbmNew3,vMF,qd1.vecX(),vH,bmCenDiff-qd1.dD(vMF)-U(0.25), blLength , blWidth ,0,0,-1);
			bmNew3.setType(_kBlocking);
			bmNew3.setName(squashSize);
			bmNew3.setHsbId("12");
			bmNew3.setInformation("LOWER BLOCKING");
			bmNew3.setColor(bm1.color());
			_Map.appendEntity("mpBms\\entBm", bmNew3);
			bmNew3.setPanhand(el);
			Element el1=bm1.element();
			if(el.bIsValid()){
				bmNew.assignToElementGroup(el,TRUE,0,'Z');
				bmNew2.assignToElementGroup(el,TRUE,0,'Z');
				bmNew3.assignToElementGroup(el,TRUE,0,'Z');
			}
			else{
				bmNew.assignToLayer(bm1.layerName());
				bmNew2.assignToLayer(bm1.layerName());
				bmNew3.assignToLayer(bm1.layerName());
			}
		}
	}
	////////////////////////Squash Blocks double sided
	if(strType==SqDoublesided){
		Vector3d vH=vMF.crossProduct(qd1.vecX());vH.normalize();
		if(vH.dotProduct(Point3d(0,0,0)-Point3d(0,0,200))<0) vH=-vH;
		
		Point3d arPtBlock[0];
		if (strMethod == Automatic) {
			Point3d ptRef = _Pt0 + 0.5*qdLongest.dD(vH)*vH ;//Point at bottom of Joist
			arPtBlock.append(ptRef);
			
			Point3d ptRef1 = ptRef;
			Point3d ptRef2 = ptRef;
			for (int i = 0; i < 50; i++) {
				ptRef1.transformBy(qd1.vecX() * dDistrib);
				if (qd1.vecX().dotProduct(ptRef1 - arPtEndRef[0]) * qd1.vecX().dotProduct(ptRef1 - arPtEndRef[1]) < 0) arPtBlock.append(ptRef1);
				else break;
			}
			for (int i = 0; i < 50; i++) {
				ptRef2.transformBy(qd1.vecX() *- 1 * dDistrib);
				if (qd1.vecX().dotProduct(ptRef2 - arPtEndRef[0]) * qd1.vecX().dotProduct(ptRef2 - arPtEndRef[1]) < 0) arPtBlock.append(ptRef2);
				else break;
			}
		}
		if (strMethod == Manual){
			Vector3d vecDistr = _PtG[1] - _PtG[0];
			double limits = abs((_PtG[1] - _PtG[0]).length());
			Point3d ptRef0 = _PtG[0] + 0.5*qd1.dD(vH)* vH;
			arPtBlock.append(ptRef0);
			if (nNrOfBlocks != 0){
				double eqdist = limits/(nNrOfBlocks-1);
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlock.append(ptRef0);
					else break;
				}
			}
			else {
				double d0Distr = dDistrib;
				double devide = limits/d0Distr;
				if (devide < 1) reportError("Manual limits smaller then distribution value");
				while(devide>=1)
				{
					devide--;
				}
				double remainder = devide;
				double newNumBlocks;
				if (remainder < 1) newNumBlocks = ceil(limits/d0Distr);								
				else newNumBlocks = (limits / d0Distr) +1;
				double eqdist = limits / newNumBlocks;
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlock.append(ptRef0);
					else break;
				}
			}
		}
		
		double sqH = dSqH;
		for (int i=0; i<arPtBlock.length(); i++) {	
			Point3d pt=arPtBlock[i];
			
			pt.vis(1);
			Vector3d vcIn1 = (pt - Line(pt, vMF).closestPointTo(qd1.ptOrg()));
			vcIn1.normalize();
			Beam bmNew;
			bmNew.dbCreate(pt-(0.5*bmCenDiff-0.5*qd1.dD(vMF))*vcIn1,vH,qd1.vecX(),vcIn1,qd1.dD(qd1.vecZ())+sqH - blWidth, blLength , blWidth,-1,0,1);
			bmNew.setType(_kBlocking);
			bmNew.setName(squashSize);
			bmNew.setHsbId("12");
			bmNew.setInformation("SQUASH BLOCKING");
			bmNew.setColor(bm1.color());
			_Map.appendEntity("mpBms\\entBm", bmNew);
			
			Beam bmNewc;
			bmNewc.dbCreate(pt-(0.5*bmCenDiff+0.5*qd1.dD(vMF))*vcIn1,vH,qd1.vecX(),vcIn1,qd1.dD(qd1.vecZ())+sqH - blWidth, blLength , blWidth,-1,0,-1);
			bmNewc.setType(_kBlocking);
			bmNewc.setName(squashSize);
			bmNewc.setHsbId("12");
			bmNewc.setInformation("SQUASH BLOCKING");
			bmNewc.setColor(bm1.color());
			_Map.appendEntity("mpBms\\entBm", bmNewc);
			
			Vector3d vcIn2 = (pt - Line(pt, vMF).closestPointTo(qd2.ptOrg()));
			vcIn2.normalize();
			Beam bmNew2;			
			bmNew2.dbCreate(pt-(0.5*bmCenDiff-0.5*qd2.dD(vMF))*vcIn2,vH,qd1.vecX(), vcIn2,qd1.dD(qd1.vecZ())+sqH - blWidth, blLength, blWidth,-1,0,1);
			bmNew2.setType(_kBlocking);
			bmNew2.setName(squashSize);
			bmNew2.setHsbId("12");
			bmNew2.setInformation("SQUASH BLOCKING"); 
			bmNew2.setColor(bm1.color());
			_Map.appendEntity("mpBms\\entBm", bmNew2);
						
			Beam bmNew2c;			
			bmNew2c.dbCreate(pt-(0.5*bmCenDiff+0.5*qd2.dD(vMF))*vcIn2,vH,qd1.vecX(), vcIn2,qd1.dD(qd1.vecZ())+sqH - blWidth, blLength, blWidth,-1,0,-1);
			bmNew2c.setType(_kBlocking);
			bmNew2c.setName(squashSize);
			bmNew2c.setHsbId("12");
			bmNew2c.setInformation("SQUASH BLOCKING"); 
			bmNew2c.setColor(bm1.color());
			_Map.appendEntity("mpBms\\entBm", bmNew2c);
			
			Element el1=bm1.element();
			if(el.bIsValid()){
				bmNew.assignToElementGroup(el,TRUE,0,'Z');
				bmNew2.assignToElementGroup(el,TRUE,0,'Z');
			}
			else{
				bmNew.assignToLayer(bm1.layerName());
				bmNew2.assignToLayer(bm1.layerName());
			}
		}
	}
	////////////////////////Upper block 2x4
	if(strType==UppVert){
		Vector3d vH=vMF.crossProduct(qd1.vecX());vH.normalize();
		if(vH.dotProduct(Point3d(0,0,0)-Point3d(0,0,200))<0) vH=-vH;
		
		Point3d arPtBlock[0];
		if (strMethod == Automatic) {
			Point3d ptRef = _Pt0 - qd1.dD(qd1.vecZ()) / 2 * vH;
			arPtBlock.append(ptRef);
			
			Point3d ptRef1 = ptRef;
			Point3d ptRef2 = ptRef;
			for (int i = 0; i < 50; i++) {
				ptRef1.transformBy(qd1.vecX() * dDistrib);
				if (qd1.vecX().dotProduct(ptRef1 - arPtEndRef[0]) * qd1.vecX().dotProduct(ptRef1 - arPtEndRef[1]) < 0) arPtBlock.append(ptRef1);
				else break;
			}
			for (int i = 0; i < 50; i++) {
				ptRef2.transformBy(qd1.vecX() *- 1 * dDistrib);
				if (qd1.vecX().dotProduct(ptRef2 - arPtEndRef[0]) * qd1.vecX().dotProduct(ptRef2 - arPtEndRef[1]) < 0) arPtBlock.append(ptRef2);
				else break;
			}
		}
		if (strMethod == Manual){
			Vector3d vecDistr = _PtG[1] - _PtG[0];
			double limits = abs((_PtG[1] - _PtG[0]).length());
			Point3d ptRef0 = _PtG[0] - qd1.dD(qd1.vecZ())/2*vH;
			arPtBlock.append(ptRef0);
			if (nNrOfBlocks != 0){
				double eqdist = limits/(nNrOfBlocks-1);
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlock.append(ptRef0);
					else break;
				}
			}
			else {
				double d0Distr = dDistrib;
				double devide = limits/d0Distr;
				if (devide < 1) reportError("Manual limits smaller then distribution value");
				while(devide>=1)
				{
					devide--;
				}
				double remainder = devide;
				double newNumBlocks;
				if (remainder < 1) newNumBlocks = ceil(limits/d0Distr);								
				else newNumBlocks = (limits / d0Distr) +1;
				double eqdist = limits / newNumBlocks;
				for(int i=0; i<50; i++){
					vecDistr.normalize();
					ptRef0.transformBy(vecDistr*eqdist);
					if((limits*vecDistr).dotProduct(_PtG[1]-ptRef0)>=0) arPtBlock.append(ptRef0);
					else break;
				}
			}
		}
	
		for (int i=0; i<arPtBlock.length(); i++) {	
			Point3d pt=arPtBlock[i];
			
			pt.vis(1);
			Beam bmNew;
			bmNew.dbCreate(pt,vMF,qd1.vecX(),vH,bmCenDiff-qd1.dD(vMF)-U(0.25), blWidth , blLength ,0,0,1);	
			bmNew.setType(_kBlocking);
			bmNew.setName(squashSize);
			bmNew.setHsbId("12");
			bmNew.setInformation("UPPER BLOCKING"); 
			bmNew.setColor(bm1.color());
			_Map.appendEntity("mpBms\\entBm", bmNew);
			bmNew.setPanhand(el);
			Element el1=bm1.element();
			if(el.bIsValid())bmNew.assignToElementGroup(el,TRUE,0,'Z');
			else bmNew.assignToLayer(bm1.layerName());
			
		}
	}
}

if(nDeleteScript==1)eraseInstance();

















#End
#BeginThumbnail

























#End
#BeginMapX

#End