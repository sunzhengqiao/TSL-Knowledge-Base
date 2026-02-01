#Version 8
#BeginDescription
V1.5__09/13/2019__Standartized sorting method
V1.4__July_30_2019__Supports trusses
V1.3__Dec_12_2018__Added Upper, Lower and Up&Low blocking
V1.2__Dec_05_2018__Fixed blockings sizes
v1.1__Nov_06_2018__Fixed multiple method behavior
v1.0__Aug 13 2018__Creates squash blocking reference to first selected point and direction (second selected grip point). Xaxis and Yaxis options change stacking direction. Custom trigger releases beams from script and stores it in dwg.
Added single block and multiple blocks insertion methods.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
Unit(1, "inch" ) ;
Display dp(6);

String By4 = T("|2x4 Blocks|");
String By6= T("|2x6 Blocks|");
String By8 = T("|2x8 Blocks|");
String By10 = T("|2x10 Blocks|");
String By12 = T("|2x12 Blocks|");
String arBsize[] = {By4, By6, By8, By10, By12};
PropString prBsize(0, arBsize, "Size");
String Xaxis = T("|X-axis|");
String Yaxis = T("|Y-axis|");
String arOrient[] = {Xaxis, Yaxis};
PropString prOrient(1, arOrient, "Blocking orientation",0);
int ibmNum[] = {1, 2, 3, 4, 5, 6};
PropInt bmNum(2, ibmNum, "Number of Blocks");
String Uno = T("|One block|");
String Multi = T("|Multiple blocks|");
String arMethod[] ={ Uno, Multi};
PropString strMethod(3, arMethod, "Insertion method", 0);
String stUp = T("|Upper blocking|");
String stDwn = T("|Lower blocking|");
String stUpDwn = T("|Upper & Lower blocking|");
String arType[] = { " ", stUp, stDwn, stUpDwn};
PropString prBlockingType(4, arType, "Blocking type", 0);

if (_bOnInsert) {
    showDialogOnce();

    _Element.append(getElementRoof("Select Floor Element"));

    _Pt0 = getPoint("Select reference point");
    Point3d ptlast = _Pt0;
    while (_PtG.length()<1){
        PrPoint prPt("Select direction", ptlast);
        if (prPt.go()==_kOk){
            ptlast = prPt.value();
            _PtG.append(ptlast);
        }
        else{
            break;
        }
    }  
    return;
}

Element el = _Element0;
Plane pnEl(el.ptOrg(),el.vecZ());
_Pt0=_Pt0.projectPoint(pnEl,0);
_PtG[0] = _PtG[0].projectPoint(pnEl, 0);

Vector3d vecDir = _PtG[0]-_Pt0; 
int FlagX;
int FlagY;
Vector3d velY = el.vecY();
Vector3d velX = el.vecX();
Vector3d elZ = el.vecZ();
Vector3d velY45 = velY.rotateBy(45, elZ);
Vector3d velX45 = velX.rotateBy(45, elZ);


if (_bOnElementDeleted) return;
Vector3d vecRef[] = { velY, velY45, -velY,  -velY45, velX,  velX45, -velX,  -velX45 };
int bXFlags[] = {0, -1, 0, 1, 1, 1, -1, -1 };
int bYFlags[] = {1, 1, -1, -1, 0, 1, 0, -1 };
int a;
double dmaxCheck;
for (int i =0; i<vecRef.length(); i++)
{
	if (vecDir.dotProduct(vecRef[i]) == 1) 
	{
		a = i;
		break;
	}
	if (vecDir.dotProduct(vecRef[i])>dmaxCheck) 
	{
		dmaxCheck = vecDir.dotProduct(vecRef[i]);
		a = i;
	}
	
}
Vector3d vecSelect = vecRef[a];


FlagX = bXFlags[a];
FlagY = bYFlags[a];

Quader bmJoist[0];
Group elG = el.elementGroup();
Entity entTrusses[] = elG.collectEntities(true, TrussEntity(), _kModelSpace);
for (int i=0; i<entTrusses.length(); i++)
{
	TrussEntity te = (TrussEntity) entTrusses[i];
	TrussDefinition td = te.definition();
	Map mp = td.subMapX("Content");
	double sizes[] = { mp.getVector3d("Length").length(), mp.getVector3d("Width").length(), mp.getVector3d("Height").length()};
	CoordSys csT = te.coordSys();
	Quader qdT(csT.ptOrg() + 0.5*sizes[0]*csT.vecX() + 0.5*sizes[2]*csT.vecZ(), csT.vecX(), csT.vecY(), csT.vecZ(), sizes[0], sizes[1], sizes[2], 0, 0, 0);
	if (qdT.vecX().isParallelTo(velY) && sizes[0]>U(6)) bmJoist.append(qdT);	
}
Beam bmAll[] = el.beam();
for (int i=0; i<bmAll.length(); i ++) 
{
	if (bmAll[i].vecX().isParallelTo(velY) && bmAll[i].dL() > U(6)) bmJoist.append(bmAll[i].quader());
}

double bmL;
if (bmJoist.length() == 0) bmL = el.dBeamWidth();
else bmL = bmJoist[0].dD(elZ);
double bmW;
double bmH;

if (prBlockingType != " ") 
{
	prOrient.set(Xaxis);
	bmNum.set(1);
	strMethod.set(Multi);
}

if (prOrient == Yaxis){
    bmW = U(1.5);
    if (prBsize == By4) bmH = U(3.5);
    else if (prBsize == By6) bmH = U(5.5);
    else if (prBsize == By8) bmH = U(7.25);
    else if (prBsize == By10) bmH = U(9.25);
    else bmH = U(11.25);
}
else {
    bmH = U(1.5);
    if (prBsize == By4) bmW = U(3.5);
    if (prBsize == By4) bmW = U(3.5);
    else if (prBsize == By6) bmW = U(5.5);
    else if (prBsize == By8) bmW = U(7.25);
    else if (prBsize == By10) bmW = U(9.25);
    else bmW = U(11.25);
}




Body bdSq[0];
Point3d ptBlock;
int dFlagX;
int dFlagY;

Point3d ptRefGeneral[0];
int arFlagsX[0];
int arFlagsY[0];
Quader bmInside[0];
Point3d ptLimitMid;
if (strMethod == Multi) 
{
	Vector3d vecln;		
	Display dp0(1);
	
	String strErr = "Move grip point to intersect joist";
	
	if (vecDir.dotProduct(velX)>0) vecln = velX;
	else vecln = - velX;
	Line lnDir(_Pt0, vecln);
	Point3d ptDir = lnDir.closestPointTo(_PtG[0]);

	_PtG[0] = ptDir;

	Vector3d vecLimit = ptDir - _Pt0;
	LineSeg ln0(ptDir, _Pt0);
	vecLimit.normalize();
	
	PLine plCheck(elZ);
	plCheck.createRectangle(LineSeg(_Pt0 + U(0.1) * vecLimit.crossProduct(elZ), ptDir - U(0.1) * vecLimit.crossProduct(elZ)), vecLimit, vecLimit.crossProduct(elZ));
	for (int i=0; i<bmJoist.length(); i++)
	{
		PlaneProfile ppJ = Body(bmJoist[i]).extractContactFaceInPlane(Plane(bmJoist[i].ptOrg(), elZ), 1.1 * 0.5 * bmJoist[i].dD(elZ));
		if (ppJ.intersectWith(PlaneProfile(plCheck))) bmInside.append(bmJoist[i]);
	}
	if (bmInside.length()>1)
	{
		Quader qdTemp[0];
		qdTemp.append(bmInside);
		String arTemp[0];
		for (int i = 0; i < qdTemp.length(); i++) 
		{
			String stInclude = qdTemp[i].vecX().isPerpendicularTo(velX) ? "@+" : "@-";
			arTemp.append(String().format("%09.4f", abs((qdTemp[i].ptOrg() - (_PtW - U(5000) * velX)).dotProduct(velX))) + "@" + i +stInclude);
		}
		String arTempSorted[] = arTemp.sorted();
		bmInside.setLength(0);
		for (int i = 0; i < arTempSorted.length(); i++) if (arTempSorted[i].token(2, "@") == "+") bmInside.append(qdTemp[arTempSorted[i].token(1, "@").atoi()]);
	}

	for (int i=0;i<bmInside.length();i++) 
	{ 
		Quader bmi = bmInside[i]; 
		Point3d ptDown = bmi.ptOrg() - 0.5 * bmi.dD(bmi.vecY()) * velX;
		ptDown = Plane(_Pt0, velY).closestPointTo(ptDown);
		ptDown = Plane(el.ptOrg(), elZ).closestPointTo(ptDown);
		ptRefGeneral.append(ptDown);
		arFlagsX.append(-1);
		arFlagsY.append(0);
		Point3d ptUp = bmi.ptOrg() + 0.5 * bmi.dD(bmi.vecY()) * velX;
		ptUp = Plane(_Pt0, velY).closestPointTo(ptUp);
		ptUp = Plane(el.ptOrg(), elZ).closestPointTo(ptUp);
		ptRefGeneral.append(ptUp);
		arFlagsX.append(1);
		arFlagsY.append(0);
	}
	Point3d ptsX[] = { _Pt0, ptDir};
	if (vecLimit.dotProduct(velX) < 0) ptsX.swap(0, 1);
	ptLimitMid = LineSeg(ptsX[0], ptsX[1]).ptMid();
	if ( (ptRefGeneral.first()-ptsX[0]).dotProduct(velX)<0 ) 
	{
		ptRefGeneral.removeAt(0);
		arFlagsX.removeAt(0);
		arFlagsY.removeAt(0);
	}
	if ( (ptRefGeneral.last()-ptsX[1]).dotProduct(velX)>0 ) 
	{
		ptRefGeneral.removeAt(ptRefGeneral.length() - 1);
		arFlagsX.removeAt(arFlagsX.length() - 1);
		arFlagsY.removeAt(arFlagsY.length() - 1);
	}

}
else ptRefGeneral.append(_Pt0);
if (prBlockingType == " ")
{
	for (int p = 0; p < ptRefGeneral.length(); p++) {
		
		if (strMethod == Multi)
		{
			FlagX = arFlagsX[p];
			FlagY = arFlagsY[p];
		}
		for (int i = 0; i < bmNum; i++) {
			
			Point3d ptRef0;
			
			
			
			
			if (prOrient == Yaxis)
			{
				if (FlagY == 0)
				{
					ptRef0 = ptRefGeneral[p] - 0.5 * bmNum * bmW * velY;
					dFlagX = FlagX;
					dFlagY = 1;
					
				}
				else
				{
					ptRef0 = ptRefGeneral[p];
					dFlagY = FlagY;
					dFlagX = FlagX;
				}
				ptBlock = ptRef0 + i * dFlagY * bmW * velY;
			}
			if (prOrient == Xaxis)
			{
				if (FlagX == 0)
				{
					ptRef0 = ptRefGeneral[p] - 0.5 * bmNum * bmH * velX;
					dFlagY = FlagY;
					dFlagX = 1;
				}
				else
				{
					ptRef0 = ptRefGeneral[p];
					dFlagY = FlagY;
					dFlagX = FlagX;
					
				}
				ptBlock = ptRef0 + i * dFlagX * bmH * velX;
			}
			
			
			
			Vector3d vcX = - elZ;
			Vector3d vcY = velY;
			Vector3d vcZ = velX;
			vcX.normalize();
			vcY.normalize();
			vcZ.normalize();
			Body bd(ptBlock, vcX, vcY, vcZ, bmL, bmW, bmH, 1, dFlagY, dFlagX);
			bdSq.append(bd);
			
			
		}
	}
}
else 
{
	if (bmInside.length() < 2) reportError("Less then 2 joist between selected boundaries");
	ptLimitMid = Plane(bmInside[0].ptOrg(), el.vecZ()).closestPointTo(ptLimitMid);
	for (int i=1; i<bmInside.length(); i++)
	{
		Quader bmFirst = bmInside[i - 1];
		Quader bmSecond = bmInside[i];
		double dBmH = bmFirst.dD(el.vecZ());
		double dist = abs((bmSecond.ptOrg() - bmFirst.ptOrg()).dotProduct(el.vecX()));
		Point3d ptBlocking = Plane(ptLimitMid, el.vecY()).closestPointTo(bmFirst.ptOrg());
		if (prBlockingType == stUp || prBlockingType == stUpDwn)
		{
			ptBlocking += (0.5 * dBmH - 0.5 * bmH) * el.vecZ();
		} 
		else ptBlocking -= (0.5 * dBmH - 0.5 * bmH) * el.vecZ();
		Body bd(ptBlocking + 0.5 * dist * el.vecX(), el.vecX(), el.vecY(), el.vecZ(), dist-0.5*(bmFirst.dD(bmFirst.vecY())+bmSecond.dD(bmSecond.vecY()))-U(0.25), bmW, bmH, 0, 0, 0);
		bdSq.append(bd);
		if (prBlockingType == stUpDwn) 
		{
			bd.transformBy((bmH - dBmH) * el.vecZ());
			bdSq.append(bd);
		}
	}
}
	
for (int i=0; i<bdSq.length(); i++)
	{
		dp.draw(bdSq[i]);
	}

addRecalcTrigger( _kContext, "Commit Beams to Dwg" ) ;
if ( _kExecuteKey == "Commit Beams to Dwg" ) {
	Map mpTSL;
	for ( int i = 0; i < bdSq.length(); i++) {
		Map mpBm;
		Beam bmNew;
		bmNew.dbCreate(bdSq[i]);
		bmNew.setType(_kBlocking);
		if (prBsize == By4) bmNew.setName("2x4");
		else bmNew.setName("2x6");
		
		bmNew.setHsbId("12");
		bmNew.setInformation("SQUASH BLOCKING");
		if (bmAll.length() == 0) bmNew.setColor(el.color());
		else bmNew.setColor(bmAll.first().color());
		bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
		Point3d ptBeamCen = bmNew.ptCen();
		Vector3d vX = bmNew.vecX() * bmNew.dL();
		Vector3d vY = bmNew.vecY() * bmNew.dW();
		Vector3d vZ = bmNew.vecZ() * bmNew.dH();
		mpBm.setPoint3d( "ptBeamCen", ptBeamCen );
		mpBm.setVector3d( "vX", vX );
		mpBm.setVector3d( "vY", vY );
		mpBm.setVector3d( "vZ", vZ );
		mpBm.setEntity( "Beam", bmNew );
		
		String stName = "Squash blocks";
		GenBeam gb[0];
		Entity ent[0]; ent.append( el );
		Point3d pt[0];
		int i[0];
		double d[0];
		String st[0];
		
		TslInst tsl;
		tsl.dbCreate( stName, _XW, _YW, gb, ent, pt, i, d, st, TRUE, mpBm );
	}
	eraseInstance();
	return;
}


#End
#BeginThumbnail















#End
#BeginMapX

#End