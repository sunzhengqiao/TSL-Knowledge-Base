#Version 8
#BeginDescription
V1.3__March 17 2016__Ref lines will reflec selected point
V1.1 & 1.2, Will now take sheathing into account
V1.0__April 11 2013__Added options to distribut from both ends, Will add refference lines as well. If from both ends it will change the distribution to 6 on the last wall
V0.2__April 10 2013__Bugfix on while loop
V0.1_Feb 4 2013__Used to splice walls with user interaction






















































1.31 6/28/2023 Added rounding to wall length test cc
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 31
#KeyWords 
#BeginContents
Unit (1,"inch");


int stProp=0,nProp=0,dProp=0;
String arYN[]={"Yes","No"};


PropString stEmpty1(stProp++,"- - - - - - - - - - - - - - - -",T("BREAK PROPERTIES"));
stEmpty1.setReadOnly(true);
PropDouble pdMaxLength(dProp++,U(144),T("Max Wall Length"));
String arSides[]={T("Left"),T("Right"),T("Left on Zone"),T("Right on Zone"),T("Pick Point"),T("Left - Right"),T("Left - Right on  Zone")};
PropString strSide(stProp++,arSides,T("Starting Side"));

int arZone[]={-5,-4,-3,-2,-1,1,2,3,4,5};
PropInt iZone(nProp++,arZone,T("Zone Index"),5); // index 5 is default
PropString strWallSides(stProp++,arYN,T("Wall Sides"),1);
PropString strWallCenters(stProp++,arYN,T("Wall Centerlines"),1);

String arOpSides[]={T("Sides"),T("In From Last Kings"),T("None")};
PropString strOpes(stProp++,arOpSides,T("Openings"));


// bOnInsert
if (_bOnInsert){
	
	showDialogOnce("");
	_Map.setMap("mpProps", mapWithPropValues());
	
	PrEntity ssE("\n"+T("Select a set of elements"),ElementWallSF());
	
	if (ssE.go())
	{
		Entity ents[0]; 
		ents = ssE.set(); 
		// turn the selected set into an array of elements
		for (int i=0; i<ents.length(); i++)
		{
			if (ents[i].bIsKindOf(ElementWallSF()))
			{
				Element el=(Element)ents[i];
				Vector3d vXEl = el.vecX();
				Point3d arPtAll[]=Line(el.ptOrg(),vXEl).orderPoints(el.plOutlineWall().vertexPoints(TRUE));
				
				double dElL=U(0);
				if(arPtAll.length()>0)
				{
					dElL=abs(vXEl.dotProduct(arPtAll[0]-arPtAll[arPtAll.length()-1]));
					dElL = round(dElL * 10000)/10000;//__safety against rounding errors
				}
				reportMessage("\ndElL = " + dElL);
				reportMessage("\npdMaxLength = " + pdMaxLength);
				reportMessage("\ndElL>pdMaxLength = " + (dElL>pdMaxLength));
				
				if(dElL>pdMaxLength)
				{
					_Element.append((Element) ents[i]);
				}
			}
		}
	}
	
	if(strSide == arSides[4])
	{
		_Map.setPoint3d("ptRef",getPoint(T("\nSelect a distribution point")));

	}



	//PREPARE TO CLONING
	// declare tsl props 
	TslInst tsl;
	String sScriptName = scriptName();

	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Beam lstBeams[0];
	Entity lstEnts[1];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	lstPropDouble.append(pdMaxLength);
	lstPropString.append(strSide);
		
	for(int i=0; i<_Element.length();i++){
		lstEnts[0] = _Element[i];
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,1,_Map  );
	}
	eraseInstance();
	return;	
	
}//END if (_bOnInsert)
//On insert


//set properties from map
if(_Map.hasMap("mpProps")){
	setPropValuesFromMap(_Map.getMap("mpProps"));
	_Map.removeAt("mpProps",0);
}

if(_Map.hasPoint3d("ptRef"))_Pt0 = _Map.getPoint3d("ptRef");


if(_Element.length()==0)eraseInstance();

Element el=_Element[0];
ElementWallSF elW = (ElementWallSF)el;
Point3d ptElOrg = el.ptOrg();
Vector3d vXEl = el.vecX();
Vector3d vZEl = el.vecZ();
Vector3d vYEl = el.vecY();

if(!elW.bIsValid())eraseInstance();

assignToElementGroup(el,TRUE,0,'Z');

double dTH=U(1.5);
Display dp(12);

dp.textHeight(dTH);



//Get text vectors
Vector3d vTest(_YW-(_XW*0.8));
int iFlagText=-1;

Vector3d vxTxt=-vZEl,vyTxt=-vXEl;
double dAngleTest=vyTxt.angleTo(vTest);
if(dAngleTest>90){
	vxTxt=-vZEl;
	vyTxt=vXEl;
	iFlagText=1;
}
vxTxt=vyTxt.crossProduct(_ZW);



TslInst tslElAll[] = el.tslInstAttached();
for ( int i = 0; i < tslElAll.length(); i++)	if ( tslElAll[i].scriptName() == scriptName() && tslElAll[i] != _ThisInst)tslElAll[i].dbErase();

Point3d arPtSplitables[0];
Point3d arPtStartEnd[0];

//add some start and end points
{
	Point3d arPtAll[]=Line(ptElOrg,vXEl).orderPoints(el.plOutlineWall().vertexPoints(TRUE));
	
	arPtStartEnd.append(arPtAll[0]);
	arPtStartEnd.append(arPtAll[arPtAll.length()-1]);
	
	if(arPtStartEnd.length()==0)eraseInstance();
	//possible stop here
	if(abs(vXEl.dotProduct(arPtStartEnd[0]-arPtStartEnd[arPtStartEnd.length()-1])) <= pdMaxLength)eraseInstance();

}




String strSlip=T("Do The Splits");
addRecalcTrigger(_kContext,strSlip);
String strSetGrips=T("Reset Splitable Points");
addRecalcTrigger(_kContext,strSetGrips);
String strSetDistrib=T("Set Distibution Point");
addRecalcTrigger(_kContext,strSetDistrib);
String strAddPoint=T("Add Spliting Point");
addRecalcTrigger(_kContext,strAddPoint);

//Set a new distribution point
if (_kExecuteKey==strSetDistrib){
	strSide.set(arSides[4]);
	
	_Pt0 = getPoint("Pick a new reference point");
	_Map.setPoint3d("ptRef",_Pt0);
}


//Add a new point
if (_kExecuteKey==strAddPoint){

	_PtG.append(getPoint("\nSelect a new point"));
	Map mpKeep = _Map.getMap("mpKeep");
	mpKeep.appendInt("index",_PtG.length()-1);
	_Map.setMap("mpKeep",mpKeep);
}

//Get vector direction
Vector3d vDir;
Line lnDir;
{
	vDir=vXEl;
	
	if(strSide==arSides[1] || strSide==arSides[3])vDir=-vXEl;
	if(strSide==arSides[4])
	{
		Point3d ptMid = (arPtStartEnd[0]+arPtStartEnd[1])/2;
		if(vXEl.dotProduct(ptMid - _Pt0) < U(0))vDir=-vXEl;
	}
	lnDir = Line(ptElOrg,vDir);
	arPtStartEnd=lnDir.orderPoints(arPtStartEnd);
}


//set ptRef
Point3d ptsRef[0];
{
	//safety
	if((strSide == arSides[4] && !_Map.hasPoint3d("ptRef")) || arSides.find(strSide) == -1)strSide.set(arSides[0]);
	
	Line lnPt0(ptElOrg-vYEl*el.dBeamWidth()/2,vXEl);
	
	if(strSide == arSides[0])
	{
		//left
		Point3d pts[]=lnPt0.orderPoints(arPtStartEnd);
		_Pt0 = lnPt0.closestPointTo(pts[0]);
	}
	else if(strSide == arSides[1])
	{
		//right
		Point3d pts[]=lnPt0.orderPoints(arPtStartEnd);
		_Pt0 = lnPt0.closestPointTo(pts[pts.length()-1]);
	}
	else if(strSide == arSides[2])
	{
		//left on zone
		PlaneProfile pp = el.profBrutto(iZone);
		Point3d arPts[0];
		PLine plRings[]=pp.allRings();
		for(int y =0;y<plRings.length();y++)arPts.append(plRings[y].vertexPoints(TRUE));
		if(arPts.length() == 0)arPts.append(arPtStartEnd);
		
		Point3d pts[]=lnPt0.orderPoints(arPts);
		_Pt0 = lnPt0.closestPointTo(pts[0]);
		ptsRef.append(lnPt0.closestPointTo(pts[0]));
		ptsRef.append(lnPt0.closestPointTo(pts[pts.length()-1]));
	}
	else if(strSide == arSides[3])
	{
		//right on zone
		PlaneProfile pp = el.profBrutto(iZone);
		Point3d arPts[0];
		PLine plRings[]=pp.allRings();
		for(int y =0;y<plRings.length();y++)arPts.append(plRings[y].vertexPoints(TRUE));
		if(arPts.length() == 0)arPts.append(arPtStartEnd);
		
		Point3d pts[]=lnPt0.orderPoints(arPts);
		_Pt0 = lnPt0.closestPointTo(pts[pts.length()-1]);
		ptsRef.append(lnPt0.closestPointTo(pts[pts.length()-1]));
		ptsRef.append(lnPt0.closestPointTo(pts[0]));
	}
	else if(strSide == arSides[4])
	{
		_Pt0 = lnPt0.closestPointTo(_Map.getPoint3d("ptRef")) ;
	}
	else if(strSide == arSides[6])
	{
		//right -left on zone
		PlaneProfile pp = el.profBrutto(iZone);
		Point3d arPts[0];
		PLine plRings[]=pp.allRings();
		for(int y =0;y<plRings.length();y++)arPts.append(plRings[y].vertexPoints(TRUE));
		if(arPts.length() == 0)arPts.append(arPtStartEnd);
		
		Point3d pts[]=lnPt0.orderPoints(arPts);
		_Pt0 = lnPt0.closestPointTo(pts[pts.length()-1]);
		ptsRef.append(lnPt0.closestPointTo(pts[0]));
		ptsRef.append(lnPt0.closestPointTo(pts[pts.length()-1]));
	}
	
	else
	{
		//left
		Point3d pts[]=lnPt0.orderPoints(arPtStartEnd);
		_Pt0 = lnPt0.closestPointTo(pts[0]);		
	}
	
	
	//safety
	if(ptsRef.length() == 0) ptsRef = lnPt0.orderPoints(arPtStartEnd);
	else ptsRef = lnPt0.orderPoints(ptsRef);
	
}


char chTok=_kNameLastChangedProp.getAt(0);

if (_kExecuteKey==strSetGrips || (chTok != '_' && chTok != NULL) || _bOnInsert || _bOnDbCreated || _kExecuteKey==strSetDistrib)
{
	
	int arIKeep[0];
	Point3d arPtKeep[0];
	Map mpKeep;
	if(_kExecuteKey!=strSetGrips && _kNameLastChangedProp != "_Pt0")
	{
		mpKeep=_Map.getMap("mpKeep");
		for(int y=0;y<mpKeep.length();y++)arIKeep.append(mpKeep.getInt(y));
		
		for(int k=0;k<arIKeep.length();k++)arPtKeep.append(_PtG[arIKeep[k]]);
	}
	
	if(arSides.find(strSide) == 5 || arSides.find(strSide) == 6)
	{
		//go from both ends
		double dElL=vDir.dotProduct(ptsRef[1]-ptsRef[0]);
		int nPtQty=dElL/pdMaxLength;
		Point3d ptL=arPtStartEnd[0],ptR=arPtStartEnd[1];
		
		for(int i=0;i<nPtQty;i++){
			ptL.transformBy(vDir*pdMaxLength);
			ptR.transformBy(-1*vDir*pdMaxLength);
			arPtSplitables.append(ptL);
			arPtSplitables.append(ptR);
		}
	}
	else
	{
		//Get a start point close to the begining
		double dDistMove = vDir.dotProduct(_Pt0-arPtStartEnd[0]);
		int iTimesMove = dDistMove/elW.spacingBeam();
		if(dDistMove > U(0))iTimesMove++;
		
		Point3d ptS2 = _Pt0 - vDir*iTimesMove*elW.spacingBeam();
		ptS2.vis(3);

		Point3d ptStart = ptS2+vDir*pdMaxLength;
		
		//add points in between based on max length
		double dElL=vDir.dotProduct(arPtStartEnd[1]-ptStart);
		int nPtQty=dElL/pdMaxLength + 1;
		
		for(int i=0;i<nPtQty;i++){
			arPtSplitables.append(ptStart);
			ptStart.transformBy(vDir*pdMaxLength*(i+1));
		}
	}	
	//add opening points
	if(strOpes != arOpSides[2])
	{
		Opening arOp[]=el.opening();
		
		for(int i=0;i<arOp.length();i++){
			OpeningSF op=(OpeningSF)arOp[i];
			CoordSys csOp=op.coordSys();
			Point3d ptOp[]={csOp.ptOrg()-(op.dGapSide()+op.dBeam() )*csOp.vecX(),csOp.ptOrg()+(op.dGapSide()+op.dBeam()+op.widthRough())*csOp.vecX()};
			ptOp=Line(ptElOrg,vXEl).orderPoints(ptOp);
			
			//remove splitables on opes
			for(int j=arPtSplitables.length()-1;j>-1;j--)	if(vXEl.dotProduct(arPtSplitables[j]-ptOp[0]) * vXEl.dotProduct(arPtSplitables[j]-ptOp[1])<0)arPtSplitables.removeAt(j);
			
			int nL=0,nR=0,nRK=0,nLK=0;
			int bDoManual=false;
			
			int iSafe2=0;
			while(TRUE)
			{
				iSafe2++;
				if(iSafe2 ==100)break;
				
				if(!op.bIsValid())
				{
					bDoManual=true;
					break;
				}
	
				if(op.numBeamsNoSupport()>1)nLK+=op.numBeamsNoSupport();
				if(op.numBeamsSupport()>1)nL+=op.numBeamsSupport();
				if(op.numBeamsNoSupportRight()>1)nRK+=op.numBeamsNoSupportRight();
				if(op.numBeamsSupportRight()>1)nR+=op.numBeamsSupportRight();	
				
				if(nL+nR+nLK+nRK == 0)
				{
					bDoManual=true;
					break;
				}
				break;
				
			}
			
			if(bDoManual)
			{
				Beam arBm[]=vXEl.filterBeamsPerpendicular(el.beam());
				
				Point3d ptCenOp=csOp.ptOrg()+op.widthRough()/2*csOp.vecX() +op.heightRough()/2*csOp.vecY() ;
				ptCenOp = ptCenOp.projectPoint(Plane(ptElOrg-vZEl*el.dBeamWidth()/2,vZEl),U(0));
				
				Beam arBmR[]=Beam().filterBeamsHalfLineIntersectSort(arBm,ptCenOp,vXEl);
				Beam arBmL[]=Beam().filterBeamsHalfLineIntersectSort(arBm,ptCenOp,-vXEl);
				
				for(int b=0;b<arBmR.length();b++)
				{
					arBmR[b].envelopeBody().vis(3);
					if(arBmR[b].type() == _kSFSupportingBeam)nR++;
					else if(arBmR[b].type() == _kKingStud )nRK++;
					else break;
				}
				for(int b=0;b<arBmL.length();b++)
				{
					arBmL[b].envelopeBody().vis(3);
					if(arBmL[b].type() == _kSFSupportingBeam)nL++;
					else if(arBmL[b].type() == _kKingStud )nLK++;
					else break;
				}			
			}
			
			if(strOpes == arOpSides[1] && nL*nR > 0)
			{
				ptOp[0].transformBy(-vXEl*nL*el.dBeamHeight() );
				ptOp[1].transformBy(vXEl*nR*el.dBeamHeight());	
			}
			else
			{
				ptOp[0].transformBy(-vXEl*(nL+nLK)*el.dBeamHeight());
				ptOp[1].transformBy(vXEl*(nR+nRK)*el.dBeamHeight());					
			}
			
			arPtSplitables.append(ptOp);	
				
		}
	}//finish opening
	
	//add T connecting walls
	if(strWallSides == arYN[0] || strWallCenters == arYN[0])
	{
		Element arEl[]=elW.getConnectedElements();
		Point3d ptsIn[]={arPtStartEnd[0]+vDir*1.5*el.dBeamWidth(),arPtStartEnd[1]-vDir*1.5*el.dBeamWidth()};
		
		for(int y=0;y<arEl.length();y++)
		{
			Element elC=arEl[y];
			if(!elC.vecX().isPerpendicularTo(vXEl))continue;
			
			Point3d ptsC[0];
			if(strWallCenters == arYN[0])ptsC.append(elC.ptOrg()-elC.vecZ()*elC.dBeamWidth()/2);
			if(strWallSides == arYN[0])
			{
				ptsC.append(elC.ptOrg()-elC.vecZ()*elC.dBeamWidth());
				ptsC.append(elC.ptOrg());
			}
			for(int d=0;d<ptsC.length();d++)
			{
				Plane pnC(ptsC[d],elC.vecZ());
				Point3d pt=lnDir.intersect(pnC,U(0));
				pt.vis(1);
				if(vDir.dotProduct(pt-ptsIn[0]) * vDir.dotProduct(pt-ptsIn[1]) < U(0))arPtSplitables.append(pt);	
			}
		}
	}
	
	
	
	arPtSplitables=lnDir.orderPoints(arPtSplitables);
	arPtSplitables=lnDir.projectPoints(arPtSplitables);
	_PtG.setLength(0);
	
	_PtG=arPtSplitables;
	
	mpKeep=Map();
	for(int p=0;p<arPtKeep.length();p++)
	{
		_PtG.append(arPtKeep[p]);
		mpKeep.appendInt("index",_PtG.length()-1);
	}
	_Map.setMap("mpKeep",mpKeep);
}//END if (_kExecuteKey==strSetGrips || (chTok != '_' && chTok != NULL) || _bOnInsert || _bOnDbCreated || _kNameLastChangedProp == "_Pt0" ){


arPtStartEnd=lnDir.orderPoints(arPtStartEnd);
arPtStartEnd=lnDir.projectPoints(arPtStartEnd);

ptsRef=lnDir.orderPoints(ptsRef);
ptsRef=lnDir.projectPoints(ptsRef);

//remove unwanted point
{
	int arIRemoved[0];
	Opening arOp[]=el.opening();
	for(int i=_PtG.length()-1;i>-1;i--)
	{
		if(vXEl.dotProduct(_PtG[i]-arPtStartEnd[0]) * vXEl.dotProduct(_PtG[i]-arPtStartEnd[1])>0)
		{
			_PtG.removeAt(i);
			arIRemoved.append(i);
			continue;
		}
		for(int p=0;p<arOp.length();p++)
		{
			CoordSys csOp = arOp[p].coordSys();
			Point3d arPtsOp[]={csOp.ptOrg(),csOp.ptOrg()+csOp.vecX()*arOp[p].width()};
			if(vXEl.dotProduct(_PtG[i]-arPtsOp[0]) * vXEl.dotProduct(_PtG[i]-arPtsOp[1])<0)
			{
				_PtG.removeAt(i);
				arIRemoved.append(i);
				break;
			}
		}	
	}
	Map mpKeep = _Map.getMap("mpKeep");
	for(int i=mpKeep.length()-1;i>-1;i--)
	{
		int index=mpKeep.getInt(i);
		if(arIRemoved.find(index) > -1)mpKeep.removeAt(i,TRUE);
	}
	
	_Map.setMap("mpKeep",mpKeep);
}
	
	
//LineSeg
String arLineTypes[0];
arLineTypes=_LineTypes;
{
	LineSeg ls(arPtStartEnd[0],arPtStartEnd[1]);
	ls.transformBy(U(16)*vZEl);
	
	Display dpLS(3);
	if(arLineTypes.find("DOT") > -1)dpLS.lineType("DOT");
	else if(arLineTypes.find("HIDDEN2") > -1)dpLS.lineType("HIDDEN2");
	else if(arLineTypes.find("HIDDEN") > -1)dpLS.lineType("HIDDEN");
	
	dpLS.draw(ls);
}	
	
	
//Move _Ptg if needed and group points
Point3d arPtG[0];
double arDistDp[0];
int arPtgDp[0];


Line lnG1(arPtStartEnd[0],vDir);
Line lnG2(arPtStartEnd[0]+U(16)*vZEl,vDir);
for(int i=0;i<_PtG.length();i++){
	Point3d pt1=lnG1.closestPointTo(_PtG[i]),pt2=lnG2.closestPointTo(_PtG[i]);
	
	int bUp=0;
	if(Vector3d(_PtG[i]-pt1).length()>Vector3d(_PtG[i]-pt2).length()){
		bUp=1;
		_PtG[i]=pt2;
	}
	else{
		_PtG[i]=pt1;
	}
	arPtgDp.append(bUp);
	arPtG.append(_PtG[i]);
	arDistDp.append(vDir.dotProduct(_PtG[i]-arPtStartEnd[0]));
}

//sort the points
for ( int i = arDistDp.length() -1; i >=0  ; i-- ) {		
	int iMax = i ;			
	for ( int j = 0; j	<= i  ; j++ ) {
		if ( arDistDp[ iMax ] < arDistDp[j]) {
			iMax = j ;
		}
	}		
	arDistDp.swap(iMax, i ) ;
	arPtG.swap(iMax, i ) ;
	arPtgDp.swap(iMax, i ) ;
}


//draw lines
Point3d ptLast=arPtStartEnd[0];
for(int i=0;i<arPtG.length();i++){
	dp.color(2);
	
	double dDistLast=vDir.dotProduct(arPtG[i]-ptLast);
	double dDist=arDistDp[i];//vDir.dotProduct(arPtG[i]-arPtStartEnd[0]);
	
	String strDist;strDist.formatUnit(dDist,4,2);
	String strDistLast;strDistLast.formatUnit(dDistLast,4,2);
	
	if(arPtgDp[i])
	{
		dp.color(3);
		ptLast = arPtG[i];
	}
	
	LineSeg lnSeg(arPtG[i],arPtG[i]+U(16)*vZEl);
	dp.draw(lnSeg);
	dp.textHeight(U(1.5));

	Point3d ptT=arPtG[i]+dTH*vZEl+vyTxt*dTH;
	
	dp.draw(strDistLast,ptT,vxTxt,vyTxt,iFlagText,1);

	ptT=arPtG[i]+2*dTH*vZEl-vyTxt*dTH;
	strDist.formatUnit(arDistDp[i],4,2);
	dp.draw(strDist,ptT,vxTxt,vyTxt,iFlagText,-1);

}

//draw first and last lines
for(int i=0;i<arPtStartEnd.length();i++){
	dp.color(12);
	LineSeg lnSeg(arPtStartEnd[i],arPtStartEnd[i]+U(32)*vZEl);
	dp.draw(lnSeg);
	
	double dDist=vDir.dotProduct(arPtStartEnd[i]-arPtStartEnd[0]);
	String strDist;strDist.formatUnit(dDist,4,2);
	
	Point3d ptT=arPtStartEnd[i]+U(17)*vZEl+vyTxt*dTH;
	dp.textHeight(U(1.5));
	
	if(i)
	{
		String strDist2;strDist2.formatUnit(vDir.dotProduct(arPtStartEnd[i]-ptLast),4,2);
		dp.draw(strDist,arPtStartEnd[i]+U(4)*vZEl-vyTxt*dTH,vxTxt,vyTxt,iFlagText,-1);
		dp.draw(strDist2,ptT,vxTxt,vyTxt,iFlagText,1);
	}
	else
	{
		dp.draw(strDist,ptT,vxTxt,vyTxt,iFlagText,1);
	}
}
//draw refference marks
{
	double dFactorLong=U(48),dFactorShort = elW.spacingBeam();
	int iShortGo=(dFactorLong+U(0.125))/dFactorShort;
	Point3d arPtLong[0],arPtShort[0];
	//ptsRef
	
	
	//Get a start point close to the begining
	double dDistMove = vDir.dotProduct(_Pt0-ptsRef[0]);
	int iTimesMove = dDistMove/dFactorShort;
	if(dDistMove > U(0))iTimesMove++;
	
	Point3d ptS2 = _Pt0 - vDir*iTimesMove*dFactorShort;
	
	double dGrow=dFactorShort,dMax=vDir.dotProduct(ptsRef[1]-ptS2) ;
	int iQtyLine = dMax/dGrow;
	
	//Point3d ptS=ptsRef[0],ptE=ptsRef[1];
	Point3d ptS=ptS2,ptE=ptsRef[1];
	
	for(int g=0;g<iQtyLine;g++)
	{
		ptS.transformBy(vDir*dFactorShort);
		
		double dThis = dFactorShort*(g+1);
		int bLong = false;

		if(dThis/dFactorLong - int(dThis/dFactorLong) < U (0.01))bLong = true;
		
		if(bLong)arPtLong.append(ptS);
		else arPtShort.append(ptS);
	}
	
	
	Display dpRef(2);
	for(int h=0;h<arPtLong.length();h++)
	{
		LineSeg ls(arPtLong[h],arPtLong[h]-vZEl*2*el.dBeamWidth());
		dpRef.draw(ls);
	}
	dpRef.color(5);
	for(int h=0;h<arPtShort.length();h++)
	{
		LineSeg ls(arPtShort[h],arPtShort[h]-vZEl*1.5*el.dBeamWidth());
		dpRef.draw(ls);
	}	
}


//draw ref point
if(strSide==arSides[4])
{
	double dd=U(1);
	PLine pl;
	pl.addVertex(_Pt0+vXEl*dd);
	pl.addVertex(_Pt0-vXEl*dd);
	pl.addVertex(_Pt0+vZEl*dd,-1*dd/4);
	pl.addVertex(_Pt0-vZEl*dd);
	pl.close(dd/4);
	
	
	
	dp.color(7);
	dp.draw(pl);
	
}


if (_kExecuteKey==strSlip){
	
	for(int i=0;i<_PtG.length();i++){
		if(!arPtgDp[i])continue;
		for(int e=0;e<_Element.length();e++){
			Element el=_Element[e];
			Wall w=(Wall)el;
			if(!w.bIsValid())continue;
			
			Point3d arPtAll[]=Line(ptElOrg,vXEl).orderPoints(el.plOutlineWall().vertexPoints(TRUE));
			Point3d arPt[]={arPtAll[0],arPtAll[arPtAll.length()-1]};
			
			double d1=vXEl.dotProduct(arPt[0]-_PtG[i]),d2=vXEl.dotProduct(arPt[1]-_PtG[i]);
			
			if(d1*d2<0 && abs(d1)>U(1.5) && abs(d2)>U(1.5)){
				Wall wNew=w.dbSplit(_PtG[i]);
				Element elNew=(Element)wNew;
				_Element.append(elNew);
				break;
			}
		}
	}
	
	//change distribution on wall furthest right
	if(arSides.find(strSide) == 5 || arSides.find(strSide) == 6)
	{
		double dLarg=U(0);
		ElementWallSF el;
		for(int e=0;e<_Element.length();e++)
		{
			ElementWallSF ele=(ElementWallSF)_Element[e];
			if(!ele.bIsValid())continue;
			
			double dDist=vDir.dotProduct(ele.ptOrg()-_PtW);
			if(e==0 || dDist>dLarg)
			{
				el=ele;
				dLarg = dDist;
			}
		}
		
		if(el.bIsValid())
		{
			el.setDistributionType(6);
			
		}
	}
	
	eraseInstance();
}


































#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`%(`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#M:***`"EI
M*6@!U.%-IPH`6G4VGB@!13Q313A0`X4\4P4\4`.%/%-%.%`#Q3Q3!3Q0`\4\
M4P4\4`.%/%-%/%`#A3Q3!4@H`<*>*8*>*`'"GBFBG"@!PIXIHIPH`<*<*;3Q
M0`HIPIM.%`#J6D%+0`M%%%`!5/5+A;6PEE8X"J2:N5RGCB\\C23$#\TI"_XT
M`><2R--,\C?>=BQ_&F444`%%%%`!39'$<;.>@&:=5'4Y=L(C!Y8\_2@#+=B[
MLQZDY-)110,**Z#PQX1O?$SRM#(D%O$0'E<9Y]`.YK:O/A9J\(W6MS;7(_ND
ME&_7C]:`.%HK;U#PAKNEVDUW>6)B@AQO?S$(Y(`Q@\\D5B4`>G4444""E%)2
MT`.IPIM.%`#A3A313A0`X4X4T4X4`/%.%-%.%`#Q3Q3!3Q0`X4\4T4X4`/%/
M%,%/%`#Q3Q3!3Q0`\4\4P4\4`.%/%,%/%`#Q3A313Q0`X4X4T4\4`.%.%-%.
M%`#A3A313A0`HI:04M`"T444`':O,_'%YYVIQP`\1KD_4_\`ZJ](G?RX6;T%
M>-:M<F[U6YFSD,Y`^@X%`%.BBB@`HHHH`*P[V7S;EB.B_**UKF7R;=W[XP/K
M6%0`4444#/2/!@GU+X?ZQIFFS^3J'FD@H^QL,%P<CD9VL,^U+H^H:T?AA<3Z
M??S_`&VQNB/,8B9B@P2N7W9&&_(<8XKB_#T>NMJBOX?:X6\48)BQMV^C[OEQ
M]?YUH:%XEU+P1J5W:M:I<1[]D]N7VD,N1E6P1_0\=*`.FU+4M8\1_#!KV9HX
MFCDVW*B+"W"!AAER?EP<9]<&O-*[/Q3X_O\`6K)M+73&TZ)B#/YLFZ1L'(7&
M!M'3GG/3BN,H`].HHHH$%***6@!:<*;3A0`X4X4T4X4`.%/%,%/%`#A3Q3!3
MQ0`X4\4P4\4`/%/%,%/%`#Q3Q3!3Q0`X4\4T4X4`/%/%,%/%`#Q3Q3!3Q0`X
M4\4P4\4`.%/%-%.%`#A3A313A0`X4ZFBG4`**6D%.H`****`,;Q->?8]&GD!
MPVW`^IX%>1UW?CZ]Q'#:J?O-N/T%<)0`4444`%%%!(`)/:@#,U.7++$.W)K/
MI\TAEF9SW/%,H&%%%7=/TC4-5\W[!:R7!B`+A.2`>G%`'H'@6:6S\":O=Z9"
MDVI)(V$89SA5V\#D@9)QWY&:\XNKJ>]O);JZ8/<2N7D(4*"3UX'2M7P]XAU'
MPK?O<P0F6%SY=Q;R$J'QZ'LPY_,_4=F_C/P#JW[[5-.D@N#RWFV#NQ/^]$&S
M^=`":U-9^,/A\VM_8UM;RS;:5!SC!`*AL#*X((X_K7F5=KXF\;V%]HXT3P_9
M/;V)(,DKQ^7N`.=JKUY."2<=,8.<CBJ`/3J***!"THI*44`**<*;3Z`%%.%-
M%.%`#Q3A313A0`X4\4T4X4`/%/%,%/%`#A3Q3!3Q0`\4\4P4\4`/%/%,%/%`
M#Q3A313Q0`X4\4T4X4`/%.%-%.%`#Q3A313A0`X4X4T4X4`.%.IHIU`#J!12
MT`%(QVJ3Z"EJIJ,ZVUC+(QP%4DT`>8>*[O[5KDH!RL8"#^9_G6)4D\K3SR2M
M]YV+'\:CH`****`"JNH2^7;$#J_%6JQ]1EWW&T=$X_&@"I1110,*UM!\2ZCX
M:N))M/2U?S5"R)<(Q!`Z8(88/YUDT4`=SX3\27>AZ1>7,V@75[83W!:6:W92
M$.!D;6QZCDD5J?\`"4_#O5O^/ZP^R2-U\VR9#^+Q@C\S4?PUCO[K2]0M"8WT
MN9FC<!RLL3E<$KQ@@CW&",\YKGM6\`Z[ILSB*U:\@!^62`;B1_N]0:!&IX@T
M7P<V@76HZ#J<4L\6PK##=K(.6`.1RW0UP=/N+*:VE'VFU>*0=/,C*D?G3*!G
MIU%%%`A:44E+0`X4ZFBG"@!U.%-IPH`<*<*:*>*`'"G"FBGB@!PIXI@IXH`>
M*>*8*>*`'"GBFBGB@!PIXI@J04`.%/%,%/%`#Q3A313Q0`X4\4P4\4`.%.%-
M%/H`<*44@IU`"BG4@I:`'4M)2T`%<OXVO/L^CM&#AI2$'X]?TS745YMXZO/-
MU"*W!X0%C^/3^5`')T444`%%%%`#)7$43.>PS6`Q+,6/4G)K3U.7$:Q#^(Y/
MTK+H&%%%%`!1110!O^%[?Q->73P^'KVYM@"&E96'EKZ%@P()_`FN[O+CQWX<
MTB6_O-0T>_BA`+K)`ZN<D#@KM'4^E4O`LES_`,('JZ:1L&J+(Q7(!/*C:<'C
MLV,\9%4K.XU*?X<>(AJEQ=S7"3(/]*8EEY3C!Z?2@0OBCQ?JEWX;^P:KX?-G
M]OCCDAN([@2(0"K\@J"#CC')&:\^KTQI;C5?A%--JR`R6Y'V>5E"E@&`5O3N
M5XZUYG0,].HHHH$+3A3:=0`HIPIHIPH`<*<*:*<*`'"GBFBG"@!PIXI@IXH`
M>*<*:*<*`'BGBF"GB@!XIXI@IXH`>*>*8*>*`'"GBFBGB@!PIXI@IXH`<*>*
M:*<*`'"GTT4X4`.%.%-%.%`#A2BD%**`'4M)2T`1S/LA9O05XWXDO4_MJ9Y'
M)W'C`Z5Z_?(TEJZKU(KR+7_#EXUT\NPD9S0!FI+'*/D<-]#3ZQ)X&MFQ(RJ1
M_M4Q=6,/'G;AZ$9J7**W9K&A5G\,6_D;U%8Z^((<?-$^?]GI4<^O@Q,(XL$C
M`):H=:"ZG1#+L5+:`EW+YMRS=AP*AJ@;V4]`H_"HS<S'^,_A4/$0.J.38A[M
M(TZ:75?O,!]3667=NK,?J:;4/$]D=$<D_FG^!IFXA'5Q^'-1F\B'3<?H*H45
M#Q$SICDU!;MLW=&\5W_A[4/MFFE0Q&V2.3E)5]"/Y$<CZ$@^@1?&;2YK4IJ&
M@7V\CYDA,4L9/U9E/Z55^'3Z+I/@W5->O+83S6\Q63;&'D"87:%!]23WQZ]*
MM?\`"5?#+6O^/ZP6TD;KYMDR'\7C!'YFMHRG:]UJ<%:EAE-P5.5EU7_!.3\7
M?$.]\3Q)9V]O]@T]#N,>\,\I'3<1P`/09YYSTQR!ED;J['\:]%\3^'O!/_"-
MWFJ>'M3BEGAV%88;Q9!RZJ<J<MT)[UYQ7/5<U+WF>K@(X:5.]*.W=:GLU%%%
M>@?(BTZFTZ@!13A2"EH`<*=313Q0`X4X4T4X4`/%.%-%/%`#A3Q3!3Q0`\4X
M4T4\4`.%/%-%/%`#A3Q313A0`\4\4P4\4`/%.%-%/%`#A3A313A0`\4X4T4Z
M@!PIPIM.H`<*=313J`%JKJ;7":7=/:MMN%B9HS@'D#/0U:K-U34UL(R6Z4,<
M79IGF$WB?6[C._4IQG^X0G_H.*S)YYKK_7S22Y_ON3_.BX"K<2!/N!CM^F>*
MCKS&WLS[>E"FHJ4$E\BK)91OV%49M)!Y6MBBD:G,2Z=(G05G7$;JVTCI7;.J
M[26'`K%F@25F8CJ:0S`B6620(@))K7BL$0?/\[?I4UG;HAD91SG;FJFJ:C<6
M\GV:QMO/N,98M]V,=L^_M792IQC'FD?.8_&5JM9T*.R[=2V(4'1%_*@P(>J+
M^5<Q)+XC<[C=QQ?[*J/\*C%]XAMCN\^.<>A4?X"M/:PV.-Y?BE[W*='-8*P)
MC^5O3M6>RE6*L,$=15K0]9&JB2*6+R;J+ED]1ZBI=4B".DG3=P:RK4X\O-$[
M\MQM55?857<]$^%>BP+I6HZS>W@2SDW6\UO(5$3H`"6DSZ;N.F.?6K\WPO\`
M#6L;IM%U9HU)Z12+.B_KG\S6;\--&.M^%]:L;FY_XE]R_EO"$Y5\`AU;/TR"
M#G`]\Y.H?!_7+.X,NGFUN\9V/&_E2?KC'YT)+D7NW%.4OK-2U7D=_D1^)OAC
M>>'M,FU7[=;7-O;E<G84?YF"C`Y'4^M<172ZI8^--,TV:WU1M7_L\[1*L\K3
M1=1CYB2!SCH1S7-5SU+7T5CU\(ZC@_:24G?='LU%%%>D?%BTZFTZ@!PIPIHI
MPH`<*<*:*<*`'"GBF"GB@!PIXI@IXH`<*>*:*<*`'BGBF"GB@!XIXI@IXH`>
M*>*8*>*`'BG"FBG"@!XIXI@IXH`<*>*8*>*`'"G4T4\4`.%.%-%.%`"TX4@I
M:`%KG_%-MYMDS#TKH*IZI#YUDXQVH`\6E7;*P]#3*NZG#Y-ZXQWJE7GUE:;/
MK\MJ>TPT?+3[@HHHK,[BO=OMBV]VXJA4]T^^8CLO%04AAIG[VRWX^](__H1I
M&C4._`R6R?>IM%7.EQG_`&W_`/0S4CVDI=B,8)]:[:L7*"2/F<OK4Z6)G*H[
M;_F4'MT;M5633U/2MC['+_L_G1]CE]!^=<WLI]CVO[0PW\Z.>L[(V_B&VE7C
M>CHWOQD5IZY'_H2X'\=6QI\OVZWF.W;'NSSSR,5+J$(>!01_%72DU1:9XTZD
M*F81E3=U=$/@KP?K/B2>6;3[Z33X8"`]RLKH=WHNT@D_B*[X^&OB1I"YT[Q0
ME]&/^6=R`S'\74G_`,>%1^#8)[[X>ZSI.EW'D:B92RE'V,`P7!R.1G:PS[4W
M2+[7U^%5Q-IVH3MJ%A=$>8Y$[-&,$K\V[(PWY#CM2II**W+Q<IU*LK*-DTK-
M=^M_^"4?$^I^/)/"FH6OB#1[)+/$?F743!2O[Q<<;V#9.!QCK7F->L:UJ>N>
M*/A')>S>5#)')MNT$6!<(K*0RY/RX.,^N#7D&63U%8UMTST,LTIRC9)IO1?+
MU/;:**45WGR8M+24M`#A3A313A0`X4X4T4X4`.%/%-%.%`#Q3A313A0`\4\4
MP4\4`.%2"F"GB@!PIXIHIPH`>*>*8*>*`'BGBF"GB@!XIPIHIPH`>*<*:*<*
M`'BG"FBG"@!PIPIHIPH`=2BDI:`%ILJ[XF'J*=2T`>3^*;;RKUFQU-<]7>>,
M[3^,"N#KDQ*V9]!DE325/YA39'V1LWH*=52]?A4'?DURGO%,\G)HHHH`CTG6
M=+MM/6&>]ACE5WW*S<CYC5W_`(2'1O\`H(V__?58SZ)ILCL[6B%F.2<GD_G2
M?V#I?_/FGYG_`!KK6(26Q\_/)IRDWS+4VO\`A(=&_P"@C!_WU1_PD&C?]!&#
M_OJL7^P=,_Y\T_,_XU:A\(V<W/V%$7U8FJC7YG9(PJ95[)<TYI&A_P`)#HW_
M`$$;?_OJB6^M+ZWW6LZRJK<E>E.MO"&CP,'-G&[#^]R/RJYJ42Q6:*BA5#8`
M`P!5U+\CN<V$4%BH*+OJ4++4+[3+M;K3[N2VG48W)@AAZ,#P1]:U?#7BN\\+
MS2&&W2ZM9L>9`S["".A5L'GGH1SQTK%BBDG?9%&\CG^%%)-(Z/&Y1U96'4,,
M$5PQG*.J/J:N'I54XR6^_P`MCJ?$GC^[\0Z<VGPV`LK:3'G,TN]W`.0HP``,
M@9.3GIQ7G.H(B.(UZ]36M<3""%G/;H/6L!W+N68Y).345JKEN=66X*G17N+1
M?F>U4M)2UZQ^?"BEI!2B@!PIPIHIPH`<*<*:*>*`'"G"FBGB@!PIPIHIXH`<
M*>*:*<*`'BGBF"GB@!XIXI@IXH`>*>*8*>*`'"GBF"GB@!XIPIHIXH`<*>*8
M*>*`'"G"FBG"@!PIPIHIPH`<*<*;3A0`M%%%`'.^*K;S;)FQT%>5R+MD9?0U
M[1JL/G63C':O(-3B\F]=?>L:ZO`]'*ZG)B5YZ%.LN9_,E9NW:K]R^R$^IX%9
MM<!]:%%%%`#DC>1MJ*6;T`K1M]%F?!F81CT')K0T`B?1X9@@4L6!Q[,1_2K.
MHW7]GV;W'V:XN-O_`"S@3<Q_"NR%"-KR/G,5FU5R<*2MYD4&GP6_W$RW]X\F
MI]E<5<Z_X@U-BEK;IID&?OR#=)^7;\OQK2\'6TD%UJ2RW,MS(1$S22MDD_-_
MA6L9PORQ."MA\1R>VJ_B3:_K-WILT=M8V!N)I%W;V.$3G'-8UM)JLSO+J5TL
MA8#;%&N%3_&M_7QBYB_W/ZU:\*>(=/T"XN?[2L)KN&=0O[N-'V$'J0Q''/;-
M85)N4N2]D>K@L-"E06)47*7;YV.D\$:E:Z/X-U74EMS-=6\N712`S+@;>>RY
M)Y]C2K\3])O%V:MX?N,>JB.=1^9!_(5>TSQ1X`$TDL,D%A),ACE6>!X$*GLV
M0$/_`-<^]0W'P_\`#^N1R3:+JP16[P2+.BY],'/ZU=IJ*4;,Y'+#U*TI5^:+
M;T?8YCQ=JG@'5O#=W)I/E1ZJA0Q1^5)"V=ZAL*0%/RYZ9KS*NZ\3_#&_\.:5
M<:G_`&A;W%K`5W?*R.=S!1@<CJ?6N%KSZ[DY>\K'V.4QI1H-4JCFK[OIHM/Z
M[GME+24M>P?G`HIU-%.%`#J44E.H`<*<*:*<*`'"GBFBG"@!PIXI@IXH`>*<
M*:*>*`'"GBFBGB@!PIXIHIPH`>*>*8*>*`'BGBF"GB@!PIXIHIPH`<*>*:*<
M*`'"G"FBGT`**<*2E%`#J=3:=0`M%%%`#)EWQ,OJ*\I\46WDWS''4UZSVKS_
M`,;6X16F/0#)I-75BZ<W":DNAYQ>/F0(/X:K4%S(=YZGFBO+>C/NHM22:"BB
MB@97TGQJNAJ-.U33YDA1V\N>/G(+$\@_7L:[?3-8TW5X]]C>13<9*@X8?4=1
M7'.B2(4D164]0PR*Q[CPW:M)YUI)):3#D-&>`?Z?A75#$=&>!B<G;;E39ZC<
M6%O=#]]$K'UZ'\ZKZ?HT6G75S-%(S"<(-K?P[<]_QK@[7Q-XIT+"W2+JEJO4
MG[X'U'/Y@UU6D>/M#U4B.28V5P>/+N.`3[-T_/%;Q<).Z/+JPQ%*/LYWMV#Q
M'$_G0N$;:%P6QQUK,TVWM[O4(;:ZN?LL<K;!,5W*C'INY'&>,]LYKNPJ2(""
MKHPX(Y!%<_XBTVUBL_/2%5=GVG'0@Y[5C5I:\YZ6`Q_N1PUK/9,ZB#X:QPZ1
M>I<%;B^VL;5XW*\[>`0>.M>6ZIX*\1VETUQ-H=TK*>)($WE?^!)G%>E^$]2U
M:+P%K%W%=27<T'FB%II][0E8P1]_J!G.">@[]*Y6Q^,GB*WVB\LM/O%'4J&A
M8_CEA_X[6=14K+6QUX.ICU.I:"J6=G?]/^&*,6C>)KOP'?:E+K=V;")]DUC=
MRNVX*5(QNSCDCICI7%UZ'XH^*LOB'09=+M]*-IY^!-(\P?"@@X7`'7'4]NWI
MYY7+7Y;KE=SW\J5;V<W5IJ%WHCVREI*6O8/S@6G"D%**`'4X4T4X4`.%.%-%
M.%`#Q3A313A0`\4\4P4\4`.%/%,%/%`#Q3Q3!3Q0`\4\4P4\4`/%.%-%/%`#
MA3Q313A0`\4X4T4\4`.%.%-%/%`#A3A313A0`ZG"FBG"@!:=3:=0`M%%%`!7
M%?$'']F!!]Z0_H*[6N$\52_;;B8#E8QL'X=?UH`\H7C*^AIU.G3R[MU]:;7G
M5E:;/L<NJ>TPT7VT^X****S.TGL[.:^N5@@7+'UZ`>IKHKCPS#;:5/)O:2X1
M"P;H!CDX%7O"EDL6E_:<`O,QY]@<8_/-5_$/BRUTF]33([>2[NY!\ZI]V)3W
M8_TKKA2BH<TCY[%8^M/$>RH[)_?_`,`Y"F0Z%9:QJ=O%/;*Y:09(X)`Y//TS
M3ZB?6-1T2YAO+"RCNMNX2*_88[8YS7/3^)'LXN_L)65W8Z6Y\'WFF*T_A?49
M;-QEOLDK;X7/L#]TU@W/BV_O+"XL-6TS[)>V[C)7(5SST!_H379^%O%EEXIM
MY/)1H+J''FV[GE?<'N*Q?B+IH\BVU%!C#>7)[YZ']#777;5-N)\]E483QD(5
M>_XFK\)([5TOI9M3V32R>6]D\B;)T*]2AYR"2,@^QS4^M?!H23R2Z+J"1(QR
M(+D'"^P<9./J/SKSGP_X3O\`Q9>M:V5O&ZH`999>$C!]3_0<UZ+:_"SQ)I<(
M_LSQ9+;N/^64<DJ1_D"1_P".US4[5*:4HWL>WC>;"8N52E747+HU^=D_T.,U
MSX?>(/#]C+?7<$+6D6-\L4H(&2`.#@]2.U<M7:^*M5\<:;:S:#XBNC-;7`&'
M>%/G"L&&UU`SR!G.37%5RU5&,K1_$]W+ZE>I1YJ]F[Z..S7]7/;*6DI:]H_,
MAU**2E%`#A3A3:<*`'"GCK313A0`X4\4P4\4`.%/%,%/%`#Q3Q3!3Q0`X4\4
MP5(*`'"GBF"GB@!XIXI@IXH`>*<*:*>*`'"GBF"GB@!PIXI@IXH`<*<*:*<*
M`'"G"FBG"@!:=24M`"T444`5K^Y%K92S=P/E^O:N%E&]&SSFNB\27/,5L#_M
MM_3^M<_2&CS[6H?*O<X[U1KH/$UO@[P*YX'(!KEQ,=4SZ'):GNRI_,6CM117
M*>X>D>&MLGAC2Y%``>V1R!ZD`G]:X#4E8:M>LZ[9&F8O]<_X8KJOAM?1W/AC
M[#TFT^9X'4GG&25/X@_H:/$WAFXGN6OK%/,+\R1#KGU'K7;6BY07*?,Y;5A1
MQ,E5TOU.,HJ22WFA;;+#)&WHRD&G16EU<<06TLIZ?(A-<5F?2\T4KWT&>'XV
M@\>Z;-;)EIUDBN`/[FTG)_$"NV\>1J?"5TS`95XROUW`?R)J+PAX4GT^X?5-
M1`6Z==L46<^4I]??_/>JGQ,U%(M/MM-5@99G\U@#R%'`_,G]*ZM8T'S'A)0J
MYK!47>S5_EJR]\/FN8_ACK<FC@'51+)MVC+9V+C`[G&<>]>:0^(->M+HSQ:Y
MJB3@Y):[=LGW5B0?Q%:?@OQ5J7AC56>S@>[MY@!/:#.7`Z,O7##/T/0]B/0+
MGQC\.-4E,VL:<]O>=76XTZ0R9]S&&!_$UC'WX+EE9H].LEA<54=:C[2,]4TK
MM>1%>ZA+XO\`@Y<ZAJL2"\M7RDJK@.RL!N`[9!(/OFO'Z]!\:?$&RU;1UT'P
M_9M;::"/,=HQ'O`.0JIV&<')P>.E>?5EB))R5G?0]#):4Z=&3E'E3DVD^B/;
M*6DI:]8_/!U.%-IPH`<*<*:*<*`'"G"FBG"@!PIXIHIPH`>*<*:*>*`'"GBF
M"GB@!XIXI@IXH`>*>*8*>*`'"GBFBGB@!PIXI@IXH`>*<*:*<*`'BG"FBG"@
M!PIU(.M.%`"TX4@IPH`6EI!2T`+2$@`D]!2UG:W<_9].<`_-)\@_K^E`'+WM
MP;J\EF[,W'T[57HHI%&)X@@\RV)QVKB5XROH:]&U"/S+5A[5Y[.GEW3K65=7
M@>CE=3DQ*7?0;1117`?5E.'4[WPIK@URQ0RP.`EY;Y^^OK[$>O;\37K^@>)=
M)\2VHGTVZ1VQEX6.)$^J_P!>E>6=1@UG1^$FU*_7^R?.@NSR#`<`>_M^8KII
M5K>ZSQ<?EJFW5@[=SWS;1MK@-*\&^.(8MMQXUEB7J!Y7GM^)8_UJQ=>`_$]Z
MFR?Q_?[,\B*U$1/XJPKKOY'S_(KV<C5\3>,-*\+P?Z3*)KQA^ZM(B#(Y^G8>
MYKQG4-1N]7U":_O6!GF;)"_=0=E'L!_CWKI;[X3ZII*27%FZZ@>K-D^:1]#U
M^@-<DZ-&[(ZE64X96&"#7FXJI-OE:LC[/(<%AZ<75C-2EY=#UCX;ZI8Z'X#U
MK5EMC/>6TN943`=DPNP9[+G=^1J9/B]X?U%/+UGP]<!?]R.X0?F0?TK)^&&K
M>&-+@NSK%[;VMY*Y13.Y17B*C(;^$C.>M=#=?#'POKQ:ZT/4Q"K')%O(L\0^
M@SD?G6T/:>SCR6/.Q2P:QM58IR3OHT<]XIOOAWJ?AN[GT5((=5&PQ1B*2!OO
MKNPI`4_+GIFO-J[KQ/\`#&_\.:5<:G_:%O<6L!7<-K(YW,%&!R.I]:X6N2OS
M<WO*Q]%E2IJ@_95'-7W?31:?UW/;*6@4M>P?FXHIPIM.%`#A3A313A0`X4X4
MT4\4`.%.%-%/%`#A3Q3!3Q0`\4X4T4X4`/%/%-%.%`#Q3Q3!3Q0`\4\4P4\4
M`.%/%-%/%`#A3A313Q0`X4\4P4\4`.%.%-%.%`#J<*:*=0`HI:04HH`6N5\0
M7/G7PA!^6(8_$_Y%=/(VR-FQG`SCUKA9F=YW:3[[,2WUH&B.BBBD,9(NZ-A[
M5P&LP^5?9QU->A5Q_B:WPV\"DU=6+IS<)J:Z&!12`Y`-+7F/0^X335T%>M^%
M='BTS1H6"CSYT$DKXYYY`_"O';QG2QN'C^^L;%?KBO<=*OTU;P[:ZA9D$3VX
M=,<X;'3\#Q^%=.&BKMGB9U4DHQIK9F'XB^('AOPQ.;:_OMUT!DP0+O<?7'`_
M$BN:3XY>%F=5:TU5`3RQA3`_)Z\OEMO+O)WG0FZ:1FE>09<N3SD^N:&56&&4
M$'L14/&ZZ(ZZ?#-X7G/7T/H7P_XIT7Q1`\ND7J3^7]^,@JZ?53SCWKCOBCX<
MA%JFN6\8616"7&T?>!X#'WSQ^(KA_A[8SQ?$/3)]/#(&+K<JGW3'M.<^V<?C
MBO5/B?>PVO@^6V<CS;J1$C7//RL&)_3]:UE.-6BY,X*&'JX#,X4HO=K[F>(4
MT1HL@D50L@Z.O##\1S3J*\M-K8^[E&,E:2N7VUS6)+&2QEU:^FLY,;X)IVD4
MX((^]G'(!XQ5"BBFY.6[)IT:=)-4XI)]CVT4HI*45[I^4"TX4T4X4`.%.%-%
M.%`#A3Q3*>*`'"GBF"GB@!PIXIHIXH`<*>*8*>*`'BGBF"GB@!XIPIHIXH`>
M*<*:*<*`'BGBF"GB@!PIXIHIPH`<*>*:*<*`'"G"FBG"@!PIU-%.%`"THH%+
M0!2U*<06K'/:O-;VZ=KMG5R#GJ#7I&I6ANH"@KB+[P_/$S,H)H`H0ZFXXE7<
M/4<&K\5S%-]QQGT/6L>6VDB.&4BHN0:!W.BK$\00>9;$XIT-_-%P3O7T:GW=
MW#<VK*WR-CH>GYT`<(O`(]#76^$?"]EXCL[J6:YF1X)O+*QXQ]T'N/>N5F79
M<NO8U=T#X@MX-DU"T.B7-\)YEE$D;[0/D48^Z?2N/DC[5\Q]#]8JO`1E2WV^
MX[\_#/3""#>7>#_N_P"%:?A/PC'X1M)K.UU&[N+1WWI#<;2(B>NT@`X/I_\`
M7K@7^/2(Q4^%KO(Z_O\`_P"PI/\`A?B?]"K=_P#@1_\`85O%TX['F58XRLO?
M39V^O?#[1->N6NI4EM[ESEY("!N^H((S[UB+\'M)#?-J-Z5]!L']*P_^%]H.
MOA6[_P#`C_["I;;XXRWDPAM?!VH3RGHD4I9C^`2H<*,G=HZ*>)S*E#EC)I(]
M%T+PQI?AV%DT^WV,_P!^5CN=OJ:\[^)_AZ]1#KEYJIN%,PA@M1#M2%"">#DY
M/')[_@!5FZ^,&J64)FN_`.L6\0ZO+N5?S,=<SXD^)R>,M'.GC1IK(I*LN^27
M<#@$8QM'K2K\BI.)KE:Q,L="J];O5[^IQ]%%%>4??A1110![;2BDI:]X_)!1
M3A2"G4`**<*04X4`.IPIHIPH`>*<*:*<*`'BGBF"GB@!PIXIHIXH`<*>*8*>
M*`'BGBF"GB@!XIXI@IXH`>*<*:*<*`'BG"FBGB@!PIPIHIPH`<*<*04Z@!13
MA313A0`ZEI*6@`ICQ)(,,H-/HH`R;O1(+@'Y1FN<OO##IDQBNYI"H/44`>47
M&G3P$[D-4I4.Q@17K-QIT$X.4%8%_P"&%<$QB@#Q._W6][D$@$]*AN+WRH22
M/F/`KH_%FB36<A<J<#O7#7$IFDSV'2N'%Z69]1PZG4YJ;V6O]?<,)))).2:]
M@^''@.S.FPZWJL*SS3?-;PR#*HN>&([D_I7C;MLC9C_"":^HVE70_"IE4%UL
M;+<`>X1/_K5EA*:DW*70]#B'%U*5.%&D[.7;MV^9XS\4M,^S>-`88E474,;(
MJ=S]WI^%>L>$?#%MX:T6&!(U^U.H:XEQRS=QGT'05XYX.;4?%?C_`$^75KM[
MN193/(S=%5<L%4'@+G`P/6OH&XF2VMY9Y6"QQ(78GL`,FNC#QBY2J(\C-ZU6
MG1HX.3U25_T7R!D5T9'4,K#!!&017B?Q.\'0:)<1:IIT?EV=RQ62)1\L;]>/
M0'GCMBN8\.ZWJT/Q-L=76^GD.H7ZPW,3R$J4D8+CZ#(Q]!7LOQ1B23P#?,R@
MF)XG4^AW@?R)IU'"M2;70G!0Q&6XZ%.?VK)KUT_`^?J***\L^\"BBB@#VVEI
M*=7O'Y(**<*:*=0`ZG"FBG"@!PIXI@IXH`<*>*8*>*`'"GBFBG"@!XIXI@IX
MH`>*>*8*>*`'"GBFBGB@!PIXI@IXH`>*>*8*>*`'"GBF"GB@!PI],%/%`#J=
M313J`'4M(*6@!U+24M`!1110`4444`%%%4M5U*#2=,GOKEL1PH6/J?0#W)XH
M;MJQQBY-16[/.OBOJ,$$$=A%@W$PW/C^%/\`Z_\`0UX\5KH-9U&?6-1N+ZY.
M9)FSCLH[`>P%83##&O(KU/:2N?HF5X182DH=7OZE6YC+6LJKU*$#\J^FO#U]
M!XF\%6-R762.\LPLA`XW%=KC'US7S;BM;P?X]U7X?S26WV8WVB2R;S"#AHB>
MI4]OH>#[5KA*BBW%]3@XAPE2K&%6FK\I[#X&\`'PG>WEW<727$LH\N$HI&U,
MYR<]SQ],>]3_`!,UI=(\'7$:OB>\/V>,`\X/WC],9_,>M9!^,-BUDLL'AOQ!
M+.P!$0M,#_OK-><>)-3\3>+M0%[?Z5<P1H-L%JD3D1+[G'+'N?8>E=%64:5/
ME@>-@:5;'8U5J[T5FWZ;([CX<^`(=MCXDO+E)LCS;>!!PI[%CZCT]:U_BYJ<
M=KX42PW#S;R9<+W*J=Q/Y[:YOP5XWC\*>!8],N='U:XU"VGE6.VBM'^=6<L&
M+D;0/F(ZD\=*XCQ'J.O:YJ#ZMK5K-`7PD<9C81PKV09_$D]SFHFXTZ/+'J=6
M$A6QN9>UK/2#_+9(QZ*3-+7G'V@4444`>VTX4VG5[Q^2"BG"FBG4`.%.%-%.
M%`#J>*:*<*`'"GBFBG"@!XIXI@IXH`<*>*:*<*`'BGBF"GB@!XIXI@IXH`>*
M>*8*>*`'"GBF"GB@!XIPIHIPH`>*<*:*<*`'"G"FBG4`.%**04HH`=2TE+0`
M4444`%%%%`!7D'Q+\2?;]0&D6SYM[9LRD?Q2>GX?SSZ5WGC/Q$OA[0Y)$8?:
MIOW<"^_K]!U_+UKP9F9W9W8LS'))/)-<>*JV7(CZ3(<#S2^LS6BV]>_R&GI5
M"88>M"J=RO.:X#ZU.S*]>Z_#_P`&V6E:-;:C<P1S:A<H)=[@-Y:GD!?3CJ:\
M&N',=M+(O54)'Y5]1:=J$5[X?MM0M0'CEMEEC`/4%<@5U8.";<GT/!XDQ4X0
MA1@[*6_^1H45\JZMJ6OZWJ$MY?:[>K([']W%(RI&,\*H!Z"J'DZC_P!!S4/^
M_P`W^-;_`%NF>2N'L8U>WXH^N:X#XO\`/@R/_K[3^35X+Y.H_P#0<U#_`+_-
M_C4T(NT5EGU"ZN5;!VS2%@"/J:SJXF$H-([,!D>)HXF%2>R=QN**E*TTK7GG
MV0W-&:"*2@#V^G4VG5[Q^2#A2T@IPH`44\4T4X4`.%.%-%/%`#A3A313Q0`X
M4\4P4\4`/%/%,%/%`#Q3A313Q0`X4\4T4\4`.%/%-%.%`#Q3Q3!3Q0`X4X4T
M4\4`.%.%-%/%`"TZD'6EH`<*=313A0`M+24M`!1110`4R218HVD=@JJ,DD\`
M4^N&^)>I7=OH7V6T0[)SMGD!Y5?3'O\`X^M3.7+%LVP]'VU6-.]KL\Y\7^('
M\0ZY)<*3]FC^2!3_`'?7ZGK^7I6#117D2DY.[/T:C2C2@J<-D%=%X=\#7/BJ
MRFN+>]@A$4GEE74DYP#V^M<[76>`_'WAWPG!JEIK%W)#-+<K*@6%GROEJ.H!
M[@UI0A&<[2.'-<35P^'YZ6]RT?@SJ+`@ZK:8/!^1J[+X?^&-<\(Z=)I6H:E;
M7NGH2UKL5A)%DY*\\%>_M_*A_P`+J\#?]!.;_P`!9/\`"C_A=7@;_H)S?^`L
MG^%=\*=.F_=/DL5C<5BXI5=;>0FO?"C3]4OY+RQO'L6E)9XO+#ID^G(Q^M<]
M_P`*:U'_`*"MK_WPU=%_PNKP-_T$YO\`P%D_PH_X75X&_P"@G-_X"R?X5,J%
M%N]C>EFV84HJ*EHNZN<[_P`*:U+_`*"MI_WPU8OBCX>WGA?2EOY[Z"9#*(]J
M*0<D'U^E=Y_PNKP-_P!!.;_P%D_PKF_'/Q"\-^*_#HLM(O))ITG21E:!TPN&
M[D5E5H4HP;1Z&`S;'UL3"G-Z-ZZ'FU%%%><?9"$4PK4E%`SV@4ZBBO>/R0<*
M<***`'"G"BB@!PIXHHH`<*>***`'BGBBB@!PIXHHH`>*>***`'BGBBB@!XIP
MHHH`>*>***`'"GBBB@!PIXHHH`<*=110`X4HHHH`6EHHH`****`"N)\9Z3<W
ML+&+)&***`/(KRPGM)&61",>U5:**X<52BES(^HR+'5JDW0F[I+YA4,EK;RL
M6D@B=CW9`3117&?3M)[F?-9VP;_CWB_[X%1_9+;_`)]XO^^!114R;-*=.%MD
M'V2V_P"?>+_O@4?9+;_GWB_[X%%%+F9I[*'9!]DMO^?>+_O@4](HXL^7&B9Z
6[5`HHI78U3@G=(?11106%%%%`'__V69I
`





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
      <str nm="Comment" vl="Added rounding to wall length test" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="31" />
      <str nm="Date" vl="6/28/2023 8:39:36 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End