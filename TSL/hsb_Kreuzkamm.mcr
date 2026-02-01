#Version 8
#BeginDescription

#End
#Type X
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL inserts a "Kreuzkamm" connection between two beams
/// </summary>

/// <insert Lang=en>
/// select two beams to insert the connection
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>



///<version value="1.0" date="13jan17" author="florian.wuermseer@hsbcad.com"> initial version</version> 


// constants
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));
	
	double dExtraSize = U(40);
	
	String sCatTool = T("|Tools|");
	
	String sGapDepthName=T("|Gap in depth|");	
	PropDouble dGapDepth(nDoubleIndex++, U(0), sGapDepthName);	
	dGapDepth.setDescription(T("|Defines the gap in depth of the connection|"));
	dGapDepth.setCategory(sCatTool);
	
	String sGapWidthName=T("|Gap in width|");	
	PropDouble dGapWidth(nDoubleIndex++, U(0), sGapWidthName);	
	dGapWidth.setDescription(T("|Defines the gap at the side of the connection|"));
	dGapWidth.setCategory(sCatTool);
		
		
	
	
	
	
	
	
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
				setPropValuesFromCatalog(T("|_LastInserted|"));					
		}		
		showDialog();
		
		_Beam.append(getBeam(T("|Select first Beam|")));
		_Beam.append(getBeam(T("|Select second Beam|")));
		_ThisInst.setColor(3);
		return;
	}	
// end on insert

if(_Beam.length() != 2)
{
	
	
	eraseInstance();
	return;
}

// define the Display
Display dp (-1);
PLine plDisplay[0];

double dDepthIntersect = (.5*_Beam0.dD(_Z0) + .5*_Beam1.dD(_Z0)) - _Z0.dotProduct(_Beam1.ptCen() - _Beam0.ptCen());

_Pt0.transformBy(-_Z0*(_Z0.dotProduct(_Pt0 - _Beam0.ptCen())));
_Pt0.transformBy(_Z0*.5*(_Beam0.dD(_Z0)-dDepthIntersect));

Line lnSort (_Pt0, (_X0 + _X1));
Plane pnBeam (_Pt0, _Z0);
//_PtMin.vis(3);

PlaneProfile ppBm0 = _Beam0.envelopeBody().shadowProfile(pnBeam);
PlaneProfile ppBm1 = _Beam1.envelopeBody().shadowProfile(pnBeam);

PlaneProfile ppConnect = ppBm0;
ppConnect.intersectWith(ppBm1);
ppConnect.vis(3);

Point3d ptCons[] = ppConnect.getGripVertexPoints();

if (ptCons.length() != 4)
{
	reportMessage("\n" + T("|invalid connection|"));
	return;
}
	
Point3d ptSorts[0];
ptSorts= ptCons;
ptSorts = lnSort.orderPoints(ptSorts);

int nStart;
for(int i=0; i<ptCons.length(); i++)
{
	if (ptSorts[0] == ptCons[i])
	nStart = i;
}

ptSorts.setLength(0);
for(int i=nStart; i<nStart + ptCons.length(); i++)
{
	int n = i;
	if (i > ptCons.length()-1)
		n = i-ptCons.length();
		
	ptSorts.append(ptCons[n]);
}

for(int i=0; i<ptSorts.length(); i++)
	ptSorts[i].vis(i+1);

PLine plDisp1 (ptSorts[0] - ptSorts[2]);
plDisp1.addVertex(_Pt0);
plDisp1.addVertex(ptSorts[1] + _Z0 *.5*dDepthIntersect);
plDisp1.addVertex(ptSorts[1] - _Z0 *.5*dDepthIntersect);
plDisp1.addVertex(_Pt0);

PLine plDisp2 (ptSorts[0] - ptSorts[2]);
plDisp2.addVertex(_Pt0);
plDisp2.addVertex(ptSorts[3] + _Z0 *.5*dDepthIntersect);
plDisp2.addVertex(ptSorts[3] - _Z0 *.5*dDepthIntersect);
plDisp2.addVertex(_Pt0);

PLine plDisp3 (ptSorts[1] - ptSorts[3]);
plDisp3.addVertex(_Pt0);
plDisp3.addVertex(ptSorts[0] + _Z0 *.5*dDepthIntersect);
plDisp3.addVertex(ptSorts[0] - _Z0 *.5*dDepthIntersect);
plDisp3.addVertex(_Pt0);

PLine plDisp4 (ptSorts[1] - ptSorts[3]);
plDisp4.addVertex(_Pt0);
plDisp4.addVertex(ptSorts[2] + _Z0 *.5*dDepthIntersect);
plDisp4.addVertex(ptSorts[2] - _Z0 *.5*dDepthIntersect);
plDisp4.addVertex(_Pt0);

PlaneProfile ppDisp1 (plDisp1);
PlaneProfile ppDisp2 (plDisp2);
PlaneProfile ppDisp3 (plDisp3);
PlaneProfile ppDisp4 (plDisp4);

dp.draw(ppDisp1, _kDrawFilled);
dp.draw(ppDisp2, _kDrawFilled);
dp.draw(ppDisp3, _kDrawFilled);
dp.draw(ppDisp4, _kDrawFilled);	
	
Point3d pt;
for (int b=0 ; b < _Beam.length() ; b++)
{
	Beam bmThis = _Beam[b];
	PlaneProfile ppThis = bmThis.envelopeBody().shadowProfile(pnBeam);
	
	for (int i=0; i<4; i++)
	{
		int j = i+1;
		if (i==3)
			j = 0;
			
		if (ppThis.pointInProfile((ptSorts[i] + ptSorts[j])/2) == 2)
		{
			pt = (ptSorts[i] + ptSorts[j])/2;
			pt.vis(1);
			Vector3d vecXCon = (_Pt0 - ptSorts[i]);
			Vector3d vecYCon = (_Pt0 - ptSorts[j]);
			Vector3d vecZCon = vecXCon.crossProduct(vecYCon);
			double dX = (_Pt0 - ptSorts[i]).length() + dExtraSize;
			double dY = (_Pt0 - ptSorts[j]).length() + dExtraSize;
			
			if (vecZCon.dotProduct(_Pt0 - bmThis.ptCen()) > 0)
			{
				vecXCon = (_Pt0 - ptSorts[j]);
				vecYCon = (_Pt0 - ptSorts[i]);
				vecZCon = vecXCon.crossProduct(vecYCon);
				dY = (_Pt0 - ptSorts[i]).length() + dExtraSize;
				dX = (_Pt0 - ptSorts[j]).length() + dExtraSize;
			}
			
			vecXCon.normalize();
			vecYCon.normalize();
			vecZCon.normalize();
			
			Vector3d vecTransformX = vecXCon.crossProduct(vecZCon);
			Vector3d vecTransformY = -vecYCon.crossProduct(vecZCon);
			
			Point3d ptToolRef = _Pt0 - vecZCon*(.5*dDepthIntersect - dGapDepth);
			ptToolRef.transformBy(.5*dGapWidth*(vecTransformX + vecTransformY));
			_Pt0.vis(1);
			ptToolRef.vis(6);
			
			ParHouse ph (ptToolRef, vecXCon, vecYCon, vecZCon, dX, dY, dDepthIntersect, 1,1,1);
//			ph.cuttingBody().vis(i+1);
			
			bmThis.addTool(ph);
		}
	}
}

#End
#BeginThumbnail

#End