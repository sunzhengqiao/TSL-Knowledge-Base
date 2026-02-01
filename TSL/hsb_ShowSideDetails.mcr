#Version 8
#BeginDescription
Last modified by: Chirag Sawjani
date: 30.11.2018-  version 1.0
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents

double dTolerance = U(1, 0.0393701);
String categories[] = 
{
	T("|Filter|"),
	T("|Dimensions|"),
	T("|Details|")
};

String sPaperSpace = T("|paper space|");
String sShopdrawSpace = T("|shopdraw multipage|");
String sArSpace[] = { sPaperSpace , sShopdrawSpace };
PropString sSpace(0,sArSpace,T("|Drawing space|"));

String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);
filterDefinitions.insertAt(0,"");

PropString genBeamFilterDefinition(1, filterDefinitions, T("|Filter definition for genbeams to display|"));
genBeamFilterDefinition.setDescription(T("|Filter definition for beams to nail.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
genBeamFilterDefinition.setCategory(categories[0]);

PropInt nColumn (0, 5, T("Number of Columns"));
nColumn.setCategory(categories[2]);

String sArDisplayMode[] = {T("|Parallel|"),T("|Perpendicular|"),T("|None|")};	
PropString sDisplayModeChain(3,sArDisplayMode,T("|Display mode chain|"), 0);
sDisplayModeChain.setCategory(categories[1]);

PropString sDimStyle(2,_DimStyles,T("Dimstyle"));
sDimStyle.setCategory(categories[1]);

PropDouble dTextOffset(0, U(5), T("|Text offset|"));	
dTextOffset.setCategory(categories[1]);

PropDouble dDimensionOffset(1, U(5), T("|Offset for dimension lines|"));	
dDimensionOffset.setCategory(categories[1]);

PropDouble dDimensionAngledOffset(2, U(5), T("|Offset for angled dimension lines|"));	
dDimensionAngledOffset.setCategory(categories[1]);

PropDouble dDetailScale(3, U(0.25), T("|Detail scale|"));	
dDetailScale.setCategory(categories[2]);

PropDouble dOffsetHorizontal(4, U(30), T("|Horizontal offset between details|"));
dOffsetHorizontal.setCategory(categories[2]);

PropDouble dOffsetVertical(5, U(30), T("|Vertical offset between details|"));
dOffsetVertical.setCategory(categories[2]);

PropInt nColorDetail(1, 32, T("|Detail colour|"));
nColorDetail.setCategory(categories[2]);



if(_bOnInsert)
{
	showDialog();
	//int nSpace = sArSpace.find(sSpace);
	
	_Pt0=getPoint(T("|Pick a point where details will be generated|"));
	if (sSpace == sPaperSpace)
	{	//Paper Space
  		Viewport vp = getViewport(T("Select the viewport from which the element is taken")); // select viewport
		_Viewport.append(vp);
	}
	else if (sSpace == sShopdrawSpace)
	{	//Shopdraw Space
		Entity ent = getShopDrawView(T("|Select the view entity from which the module is taken|")); // select ShopDrawView
		_Entity.append(ent);
	}

	//_Viewport.append(getViewport(T("Select a viewport")));
	return;

}//end bOnInsert


setMarbleDiameter(U(1));

// determine the space type depending on the contents of _Entity[0] and _Viewport[0]
if (_Viewport.length()>0)
	sSpace.set(sPaperSpace);
else if (_Entity.length()>0 && _Entity[0].bIsKindOf(ShopDrawView()))
	sSpace.set(sShopdrawSpace);

sSpace.setReadOnly(TRUE);

Element el;
Entity entAll[0];	

// coordSys
CoordSys ms2ps, ps2ms;	

//paperspace
if ( sSpace == sPaperSpace ){
	Viewport vp;
	if (_Viewport.length()==0) return; // _Viewport array has some elements
	vp = _Viewport[_Viewport.length()-1]; // take last element of array
	_Viewport[0] = vp; // make sure the connection to the first one is lost
	
	// check if the viewport has hsb data
	if (!vp.element().bIsValid()) return;
	
	ms2ps = vp.coordSys();
	ps2ms = ms2ps;
	ps2ms.invert();
	el = vp.element();
}

//shopdrawspace	
if (sSpace == sShopdrawSpace ) {
	
	if (_Entity.length()==0) return; // _Entity array has some elements
	ShopDrawView sv = (ShopDrawView)_Entity[0];
	if (!sv.bIsValid()) return;
	
	// interprete the list of ViewData in my _Map
	ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
	int nIndFound = ViewData().findDataForViewport(arViewData, sv);// find the viewData for my view
	if (nIndFound<0) return; // no viewData found
	
	ViewData vwData = arViewData[nIndFound];
	Entity arEnt[] = vwData.showSetEntities();
	
	ms2ps = vwData.coordSys();
	ps2ms = ms2ps;
	ps2ms.invert();
	
	for (int i = 0; i < arEnt.length(); i++)
	{
		Entity ent = arEnt[i];
		if (arEnt[i].bIsKindOf(Element()))
		{
			el=(Element) ent;
		}
	}
}

if( !el.bIsValid() )return;

//Element vectors
CoordSys csEl=el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

vx.normalize();
vy.normalize();
vz.normalize();

Point3d ptOrgEl=csEl.ptOrg();

//CoordSys coordvp = vp.coordSys();
Vector3d VecX = ms2ps.vecX();
Vector3d VecY = ms2ps.vecY();
Vector3d VecZ = ms2ps.vecZ();

GenBeam genBeams[] = el.genBeam();
Entity genBeamEntities[0];{ }
for (int b=0;b<genBeams.length();b++)
{
	genBeamEntities.append(genBeams[b]);
}

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, genBeamFilterDefinition, filterGenBeamsMap);
if (!successfullyFiltered) {
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 

Entity filteredGenBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
GenBeam gbFiltered[0];
for (int e=0;e<filteredGenBeamEntities.length();e++) 
{
	GenBeam bm = (GenBeam)filteredGenBeamEntities[e];
	if (!bm.bIsValid()) continue;

	gbFiltered.append(bm);
}

GenBeam gbGroupedByPosNum[0];
int posNums[0];
for (int i = 0; i < gbFiltered.length(); i++)
{
	GenBeam genBeamFiltered = gbFiltered[i];
	int posNum = genBeamFiltered.posnum();
	
	//Check if already added
	if (posNums.find(posNum, - 99) != -99) continue;
		
	posNums.append(posNum);
	gbGroupedByPosNum.append(genBeamFiltered);
}

int nDispDelta = _kDimNone, nDispChain = _kDimNone, nDispChainOp = _kDimNone;
if (sDisplayModeChain == sArDisplayMode[0])	
	nDispChain = _kDimPar;
else if (sDisplayModeChain == sArDisplayMode[1])	
	nDispChain = _kDimPerp;

Display dp (-1);
//dp.textHeight(dTextHeight);
dp.dimStyle(sDimStyle);
double textHeightForDisplay = dp.textHeightForStyle("9", sDimStyle);

int nCounter = 0;
int nRows = 0;

for(int g=0; g<gbGroupedByPosNum.length();g++)
{
	GenBeam gbCurr = gbGroupedByPosNum[g];
	Body gbBody = gbCurr.realBody();
	
	//Check for details in 3 orientations
	Point3d ptCen = gbCurr.ptCenSolid();
	Vector3d vecOrientations[] = { gbCurr.vecX(), gbCurr.vecY(), gbCurr.vecZ()};
	CoordSys transformationToWorld[3];
	PLine plDetails[3];
	int nRequiresDetails[3];
	
	for (int v = 0; v < vecOrientations.length(); v++)
	{
		Vector3d& orientation = vecOrientations[v];
		CoordSys cs;
		
		if (v == 0)
		{
			cs.setToAlignCoordSys(gbCurr.ptCen(), gbCurr.vecX(), gbCurr.vecY(), gbCurr.vecZ(), _Pt0, -_ZW, _XW, -_YW);
		}
		else if (v == 1)
		{
			cs.setToAlignCoordSys(gbCurr.ptCen(), gbCurr.vecY(), gbCurr.vecX(), gbCurr.vecY().crossProduct(gbCurr.vecX()), _Pt0, -_ZW, _XW, -_YW);
		}
		else if (v == 2)
		{
			cs.setToAlignCoordSys(gbCurr.ptCen(), gbCurr.vecZ(), gbCurr.vecX(), gbCurr.vecZ().crossProduct(gbCurr.vecX()), _Pt0, -_ZW, _XW, -_YW);
		}
		
		transformationToWorld[v] = cs;
		
	}
	
	for (int v = 0; v < vecOrientations.length(); v++)
	{
		Vector3d& orientation = vecOrientations[v];
		CoordSys& cs = transformationToWorld[v];
		//Check if orientation has a detail
		PlaneProfile ppBm = gbBody.shadowProfile(Plane (ptCen, orientation));
		ppBm.transformBy(cs);

		PLine PlBm[] = ppBm.allRings();
		PLine plValid;
		if (ppBm.numRings() > 1)
		{
			int valid[] = ppBm.ringIsOpening();
			for (int i = 0; i < valid.length(); i++)
			{
				if (valid[i] == FALSE)
				{
					plValid = (PlBm[i]);
				}
			}
		}
		else
		{
			plValid = (PlBm[0]);
		}
		
		Point3d ptBm[] = plValid.vertexPoints(TRUE);
		for (int i = 0; i < ptBm.length() - 1; i++)
		{
			for (int j = i + 1; j < ptBm.length(); j++)
			{
				if ((ptBm[i] - ptBm[j]).length() < dTolerance)
				{
					ptBm.removeAt(j);
					j--;
				}
			}
		}
		int nvertexBm = ptBm.length();
		if (nvertexBm == 4)
		{
			if ((ptBm[0] - ptBm[1]).isParallelTo(ptBm[2] - ptBm[3]) && (ptBm[1] - ptBm[2]).isParallelTo(ptBm[0] - ptBm[3]))
			//if (abs((ptBm[0]-ptBm[1]).dotProduct(ptBm[2]-ptBm[3]))>0.98 && abs((ptBm[1]-ptBm[2]).dotProduct(ptBm[0]-ptBm[3]))>0.98)
			if (abs((ptBm[0] - ptBm[1]).dotProduct(ptBm[1] - ptBm[2])) < 0.01)
			{
				nRequiresDetails[v] = FALSE;
				continue;
			}
		}
		PLine plToAdd;
		for (int i = 0; i < ptBm.length(); i++)
		{
			plToAdd.addVertex(ptBm[i]);
		}
		plToAdd.close();
		
		plDetails[v] = plToAdd;
		nRequiresDetails[v] = TRUE;
	}
	
	 

	for (int i = 0; i < nRequiresDetails.length(); i++)
	{
		int nRequiresDetail = nRequiresDetails[i];
		if ( ! nRequiresDetail) continue;
		
		PLine plDetail = plDetails[i];
//		plDetail.vis();
		// Draw detail

		//reportNotice("\n"+nCounter);
		Point3d ptUp[0];
		Point3d ptDown[0];
		Point3d ptLeft[0];
		Point3d ptRight[0];
		
		Point3d ptBm[] = plDetail.vertexPoints(TRUE);
		Point3d ptCenter;
		ptCenter.setToAverage(ptBm);
		//ptCenter=ptCenter-((_YW*dOffset)*nCounter);
		for (int i = 0; i < ptBm.length(); i++)
		{
			if (_XW.dotProduct(ptBm[i] - ptCenter) > 0)
			{
				ptRight.append(ptBm[i]);
			}
			else
			{
				ptLeft.append(ptBm[i]);
			}
			if (_YW.dotProduct(ptBm[i] - ptCenter) > 0)
			{
				ptUp.append(ptBm[i]);
			}
			else
			{
				ptDown.append(ptBm[i]);
			}
		}
		
		//Angled Dimension
		Point3d ptAngled[0];
		for (int i = 0; i < ptBm.length(); i++)
		{
			int iN = i == ptBm.length() - 1 ? 0 : i + 1;
			
			if ( ! (abs((ptBm[i] - ptBm[iN]).dotProduct(_XW)) < 0.02 || abs((ptBm[i] - ptBm[iN]).dotProduct(_YW)) < 0.02))
			{
				ptAngled.append(ptBm[i]);
				ptAngled.append(ptBm[iN]);
			}
		}
			
		CoordSys cs;
		cs.setToAlignCoordSys(_Pt0, _XW, _YW, _ZW, _Pt0, _XW * dDetailScale, _YW * dDetailScale, _ZW * dDetailScale);
		cs.transformBy(_XW * (dOffsetHorizontal * nCounter));
		cs.transformBy(-_YW * (dOffsetVertical * nRows));
		
		for (int i = 0; i < ptAngled.length() - 1; i += 2)
		{
			Point3d ptDim[0];
			ptDim.append(ptAngled[i]);
			ptDim.append(ptAngled[i + 1]);
			Vector3d vecLine (ptAngled[i] - ptAngled[i + 1]);
			vecLine.normalize();
//			if (  (vecLine.isCodirectionalTo(_YW)))
//				vecLine = - vecLine;
			Vector3d vecDir1 (_ZW.crossProduct(-vecLine));
			DimLine dlAngled(ptAngled[i] + vecDir1 * dDimensionAngledOffset, -vecLine, vecDir1);
			// dimline
			Dim dimAngled (dlAngled, ptDim, "<>", " <> ", nDispChain, _kDimNone);
			dimAngled.setDeltaOnTop(TRUE);
			dimAngled.transformBy	(cs);
			dp.draw(dimAngled);
			
			LineSeg lnAngle (ptAngled[i], ptAngled[i + 1]);
			double dAngle;
			dAngle = vecLine.angleTo(_XW);
			Display dpAngle(-1);
			dpAngle.dimStyle(sDimStyle);
//			dpAngle.textHeight(dTextHeight);
			
			String strAngle = dAngle;
			Point3d ptAngle = lnAngle.ptMid();
			ptAngle.transformBy(cs);
//			dpAngle.draw(strAngle + "º", ptAngle, _XW, _YW, 0, 0);
		}
		
		Point3d ptExtremeBottom;				
		// draw the display of the dim
		if (ptUp.length() > 1)
		{
			Point3d ptExtreme = ptUp[0];
			for (int p = 1; p < ptUp.length(); p++)
			{
				Point3d& pt = ptUp[p];
				if (pt.Y() > ptExtreme.Y()) ptExtreme = pt;
			}
			
			DimLine dlUp(ptExtreme + _YW * dDimensionOffset, _XW, _YW);
			Dim dimUp (dlUp, ptUp, "<>", " <> ", nDispChain, _kDimNone);
			dimUp.setDeltaOnTop(TRUE);
			dimUp.transformBy	(cs);
			dp.draw(dimUp);
		}
		if (ptDown.length() > 1)
		{
			Point3d ptExtreme = ptDown[0];
			for (int p = 1; p < ptDown.length(); p++)
			{
				Point3d& pt = ptDown[p];
				if (pt.Y() < ptExtreme.Y() ) ptExtreme = pt;
			}
			
			DimLine dlDown(ptExtreme - _YW * dDimensionOffset, _XW, _YW);
			Dim dimDown (dlDown, ptDown, "<>", " <> ", nDispChain, _kDimNone);
			dimDown.setDeltaOnTop(FALSE);
			dimDown.transformBy(cs);
			dp.draw(dimDown);
			ptExtremeBottom =ptExtreme.projectPoint(Plane(ptCenter, _XW),0) ;
		}
		if (ptLeft.length() > 1)
		{
			Point3d ptExtreme = ptLeft[0];
			for (int p = 1; p < ptLeft.length(); p++)
			{
				Point3d& pt = ptLeft[p];
				if (pt.X() < ptExtreme.X()) ptExtreme = pt;
			}
			
			DimLine dlLeft(ptExtreme - _XW * dDimensionOffset, _YW, - _XW);
			
			Dim dimLeft (dlLeft, ptLeft, "<>", " <> ", nDispChain, _kDimNone);
			dimLeft.setDeltaOnTop(TRUE);
			dimLeft.transformBy	(cs);
			dp.draw(dimLeft);
		}
		if (ptRight.length() > 1)
		{
			Point3d ptExtreme = ptRight[0];
			for (int p = 1; p < ptRight.length(); p++)
			{
				Point3d& pt = ptRight[p];
				if (pt.X() > ptExtreme.X()) ptExtreme = pt;
			}
			
			DimLine dlRight(ptExtreme + _XW * dDimensionOffset, _YW, - _XW);
			
			Dim dimRight (dlRight, ptRight, "<>", " <> " , nDispChain, _kDimNone);
			dimRight.setDeltaOnTop(FALSE);
			dimRight.transformBy(cs);
			dp.draw(dimRight);
		}
		
		plDetail.transformBy(cs);
		Point3d ptTextRef = ptExtremeBottom - _YW * (dTextOffset );
		ptTextRef.transformBy(cs);
		dp.draw("Posnum: " + gbCurr.posnum(), ptTextRef, _XW, _YW, 0, 0);
		
		dp.color(nColorDetail);
		dp.draw(plDetail);
		dp.color(-1);
				
		nCounter++;
		if(nCounter==nColumn)
		{ 
			nCounter = 0;
			nRows++;
		}
	}
}
#End
#BeginThumbnail


#End