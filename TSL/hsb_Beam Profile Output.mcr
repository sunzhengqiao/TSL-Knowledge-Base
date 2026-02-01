#Version 8
#BeginDescription
1.8 24/11/2022 Use Internal Angles, Expose some properties and improve them with categories. AJ
v: 1.7 material property overide added, name property overide omitted, set grade to C24.
v: 1.6 dim arrangement refined, input defaults refined
v: 1.5 allow to show in columns the result  Date: 18/Oct/2006  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.4 show text for the Angles  Date: 28/Sep/2006  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.3 allow to filter by many types of beams Date: 07/Aug/2006  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.3 review some bugs and optimization of the code Date: 07/Aug/2006  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.2 bug fix with the mirror profile  Date: 31/Aug/2006  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.1 add Angular Dim and fix some bugs  Date: 21/Aug/2006  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.0 initial version  Date: 14/Aug/2006  Author: Alberto Jena (aj@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
// basics and props
	U(1,"mm");
	
	PropDouble dTolerance(0, U(1), T("Tolerance"));
	PropDouble dOffset(1, U(600), T("Distance between Profiles"));
	PropDouble dOffsetText(2, U(300), T("Text Offset"));


	//PropString sProfile (0, "Profile", T("Name to use"));
	PropString sMaterial (0, "Profiled Timber", T("New Material")); sMaterial.setCategory(T("Beam Properties"));
	PropString sNewGrade(8, "C24", T("New Grade")); sNewGrade.setCategory(T("Beam Properties"));
	PropString sLabel (1, "PT", T("New Label prefix")); sLabel.setCategory(T("Beam Properties"));

	PropDouble dAngleTextHeight(3, 20, T("Text Height Angle"));
	PropDouble dAngleOffset(4, 10, T("Offset Angle Text"));
	
	PropString sDimStyle(2, _DimStyles,T("Dimstyle"));
	PropInt nColor (0,90,T("Color"));
	PropInt nColumn (1, 5, T("Number of Columns"));

	
	String sArDisplayMode[] = {T("Parallel"),T("Perpendicular"),T("None")};
	//PropString sDisplayModeDelta(3,sArDisplayMode,T("Display mode Delta"));
	PropString sDisplayModeChain(3,sArDisplayMode,T("Display mode Chain"), 0);
	
	//String sArVectorReference[] = {T("X Vector"),T("Y Vector")};
	//PropString sDisplayVectorReference(5,sArVectorReference,T("Angular Dim in Direction of"), 0);
	//int nVectorReference = sDisplayVectorReference.find(sArVectorReference, 0);

	PropString sMessage (4, "STEEL", T("Beam Filter by Grade 1:")); sMessage.setCategory(T("Filters"));
	sMessage.trimLeft();
	sMessage.trimRight();
	PropString sMessage2 (5, "-", T("Beam Filter by Grade 2:")); sMessage2.setCategory(T("Filters"));
	sMessage2.trimLeft();
	sMessage2.trimRight();
	PropString sMessage3 (6, "?", T("Beam Filter by Grade 3:")); sMessage3.setCategory(T("Filters"));
	sMessage3.trimLeft();
	sMessage3.trimRight();
	PropString sMessage4 (7, "?", T("Beam Filter by Grade 4:")); sMessage4.setCategory(T("Filters"));
	sMessage4.trimLeft();
	sMessage4.trimRight();

	String sListOfCodes = sMessage+";"+sMessage2+";"+sMessage3+";"+sMessage4+";";
	String arSCode[0];
	int nIndexCode = 0; 
	int sIndexCode = 0;
	while(sIndexCode < sListOfCodes.length()-1){
		String sTokenCode = sListOfCodes.token(nIndexCode,";");
		nIndexCode++;
		if(sTokenCode.length()==0){
			sIndexCode++;
			continue;
		}
	sIndexCode = sListOfCodes.find(sTokenCode,0);
	sTokenCode.trimLeft();
	sTokenCode.trimRight();
	sTokenCode.makeUpper();
	arSCode.append(sTokenCode);
	}

if( _bOnInsert )
{
	showDialogOnce();
	_Pt0=getPoint(T("Select the point where is going to be located the report"));
	PrEntity ssE(T("Select a set of beams"),Beam());
	if( ssE.go() ) {
	_Beam = ssE.beamSet();
	}
	return;
}

if (_Beam.length()==0)
{
	eraseInstance();
	return;
}

String strChangeEntity = T("Select extra Beams");
addRecalcTrigger(_kContext, strChangeEntity);


if (_bOnRecalc && _kExecuteKey==strChangeEntity) 
{
	PrEntity ssE(T("Select a set of beams"),Beam());
	if( ssE.go() ) {
	_Beam.append(ssE.beamSet());
	}
}

for (int b=0; b<_Beam.length()-1; b++)
{
	for (int c=b+1; c<_Beam.length(); c++)
	{
		if (_Beam[b]==_Beam[c])
		{
			_Beam.removeAt(c);
			c--;
		}
	}
}

Beam bm[0];
PLine ArrPlBm[0];
PLine AllPlToDim[0];


//String strList[] = { T("No"), T( "Yes")}; 
//PropString strMultipleLines (2,strList,T("Multiple Lines"), 0);
//int bMultipleLines = strMultipleLines == T("No");
//int nCornerBoard = sArCornerBoard.find(sCornerBoard, 0);


for (int b=0; b<_Beam.length(); b++)
{
	String strGrade=_Beam[b].grade();
	strGrade.makeUpper();
	
	int aux=arSCode.find(strGrade,-1);
	
	if (arSCode.find(strGrade,-1)==-1)
	{
		PlaneProfile ppBm=_Beam[b].realBody().shadowProfile(Plane (_Beam[b].ptCen(), _Beam[b].vecX()));
		CoordSys cs;
		cs.setToAlignCoordSys(_Beam[b].ptCen(), _Beam[b].vecX(), _Beam[b].vecY(), _Beam[b].vecZ(), _PtW, _XW, _YW, _ZW); 
		ppBm.transformBy(cs);
		PLine PlBm[]=ppBm.allRings();
		PLine plValid;
		if (ppBm.numRings()>1)
		{
			int valid[]=ppBm.ringIsOpening();
			for (int i=0; i<valid.length(); i++)
			{
				if (valid[i]==FALSE)
				{
					plValid=(PlBm[i]);
				}
			}
		}
		else
		{
			plValid=(PlBm[0]);
		}
		
		plValid.setNormal(_ZW);

		Point3d ptBm[]=plValid.vertexPoints(TRUE);
		for (int i=0; i<ptBm.length()-1; i++)
		{
			for (int j=i+1; j<ptBm.length(); j++)
			{
				if ((ptBm[i]-ptBm[j]).length()<dTolerance)
				{
					ptBm.removeAt(j);
					j--;
				}
			}
		}
		int nvertexBm=ptBm.length();
		if (nvertexBm==4)
		{
			if ((ptBm[0]-ptBm[1]).isParallelTo(ptBm[2]-ptBm[3]) && (ptBm[1]-ptBm[2]).isParallelTo(ptBm[0]-ptBm[3]))
			//if (abs((ptBm[0]-ptBm[1]).dotProduct(ptBm[2]-ptBm[3]))>0.98 && abs((ptBm[1]-ptBm[2]).dotProduct(ptBm[0]-ptBm[3]))>0.98)
				if (abs((ptBm[0]-ptBm[1]).dotProduct(ptBm[1]-ptBm[2]))<0.01)
					continue;
		}
		PLine plToAdd;
		for (int i=0; i<ptBm.length(); i++)
		{
			plToAdd.addVertex(ptBm[i]);
		}
		plToAdd.close();
		ArrPlBm.append(plToAdd);
		bm.append(_Beam[b]);
	}
}

CoordSys csMirX;
csMirX.setToMirroring (Line(_PtW, _XW));
CoordSys csMirY;
csMirY.setToMirroring (Line(_PtW, _YW));
CoordSys csMirZ;
csMirZ.setToMirroring (Line(_PtW, _ZW));

for (int b=0; b<ArrPlBm.length(); b++)
{
	PLine PlBm[0];
	PlBm.append(ArrPlBm[b]);
	PLine plAuxX=ArrPlBm[b];
	PLine plAuxY=ArrPlBm[b];
	PLine plAuxZ=ArrPlBm[b];
	plAuxX.transformBy(csMirX);
	plAuxY.transformBy(csMirY);
	plAuxZ.transformBy(csMirZ);
	PlBm.append(plAuxX);
	PlBm.append(plAuxY);
	PlBm.append(plAuxZ);
	int flag=FALSE;
	for (int n=0; n<PlBm.length(); n++)
	{
		Point3d ptBm[]=PlBm[n].vertexPoints(TRUE);
		int nvertexBm=ptBm.length();
		/////////////////////////////
		for (int i=0; i<ptBm.length()-1; i++)
		{
			for (int j=i+1; j<ptBm.length(); j++)
			{
				if ((ptBm[i]-ptBm[j]).length()<dTolerance)
				{
					ptBm.removeAt(j);
					j--;
				}
			}
		}
		////////////////////////////
		for (int i=0; i<AllPlToDim.length(); i++)
		{
			PLine plPp=AllPlToDim[i];
			Point3d ptPp[]=plPp.vertexPoints(TRUE);
			int nvertexPp=ptPp.length();
			int count=0;
			if (nvertexPp!=nvertexBm)
				continue;
			for (int x=0; x<ptBm.length(); x++)
				for (int y=0; y<ptPp.length(); y++)
					if ((ptBm[x]-ptPp[y]).length()<=dTolerance)
						count++;
			if (count==nvertexBm && nvertexPp==nvertexBm)
				flag=TRUE;
		}
	}
	if (flag==FALSE)
	{
		AllPlToDim.append(PlBm[0]);
	}
}

int a=AllPlToDim.length();
int qtyOfProf[AllPlToDim.length()];

//reportNotice("\n"+a);


for (int b=0; b<bm.length(); b++)
{
	PLine PlBm[0];
	PlBm.append(ArrPlBm[b]);
	PLine plAuxX=ArrPlBm[b];
	PLine plAuxY=ArrPlBm[b];
	PLine plAuxZ=ArrPlBm[b];
	plAuxX.transformBy(csMirX);
	plAuxY.transformBy(csMirY);
	plAuxZ.transformBy(csMirZ);
	PlBm.append(plAuxX);
	PlBm.append(plAuxY);
	PlBm.append(plAuxZ);
	int flag=FALSE;
	for (int n=0; n<PlBm.length(); n++)
	{
		Point3d ptBm[]=PlBm[n].vertexPoints(TRUE);
		int nvertexBm=ptBm.length();
		for (int i=0; i<AllPlToDim.length(); i++)
		{
			PLine plPp=AllPlToDim[i];
			Point3d ptPp[]=plPp.vertexPoints(TRUE);
			int nvertexPp=ptPp.length();
			int count=0;
			if (nvertexPp!=nvertexBm)
				continue;
			for (int x=0; x<ptBm.length(); x++)
				for (int y=0; y<ptPp.length(); y++)
					if ((ptBm[x]-ptPp[y]).length()<=dTolerance)
						count++;
			if (count==nvertexBm && nvertexPp==nvertexBm)
			{
				qtyOfProf[i]++;
				String aux=sLabel;
				aux=aux+(i+1);
				//bm[b].setName(sProfile);
				bm[b].setMaterial(sMaterial);
				bm[b].setLabel(aux);
				bm[b].setGrade(sNewGrade);
				flag=TRUE;
				break;
			}
		}
		if(flag==TRUE)
		{
			break;
		}
	}
}

// restrict color index
	if (nColor > 255 || nColor < -1) nColor.set(171);

// some ints on dim props			
	int nDispDelta = _kDimNone, nDispChain = _kDimNone, nDispChainOp = _kDimNone;
//	if (sDisplayModeDelta == sArDisplayMode[0])	
//		nDispDelta = _kDimPar;
//	else if (sDisplayModeDelta == sArDisplayMode[1])	
//		nDispDelta = _kDimPerp;
	if (sDisplayModeChain == sArDisplayMode[0])	
		nDispChain = _kDimPar;
	else if (sDisplayModeChain == sArDisplayMode[1])	
		nDispChain = _kDimPerp;		

// Display
Display dp (nColor);
dp.dimStyle(sDimStyle);

CoordSys cs;
cs.setToAlignCoordSys(_PtW, _XW, _YW, _ZW, _Pt0, _ZW, _XW, _YW);

Point3d ptUp[0];
Point3d ptDown[0];
Point3d ptLeft[0];
Point3d ptRight[0];
//_XW.vis(_Pt0,1);
//_YW.vis(_Pt0,2);
//_ZW.vis(_Pt0,150);

//for (int b=0; b<1; b++)
int nCounter=0;
int nFiles=0;
for (int b=0; b<AllPlToDim.length(); b++)
{
	nCounter=b/nColumn;
	//reportNotice("\n"+nCounter);
	ptUp.setLength(0);
	ptDown.setLength(0);
	ptLeft.setLength(0);
	ptRight.setLength(0);

	AllPlToDim[b].transformBy(cs);
	AllPlToDim[b].transformBy(_XW * (dOffset*nFiles));
	AllPlToDim[b].transformBy(-_YW * (dOffset*nCounter));
	Point3d ptBm[]=AllPlToDim[b].vertexPoints(TRUE);
	Point3d ptCenter;
	ptCenter.setToAverage(ptBm);
	//ptCenter=ptCenter-((_YW*dOffset)*nCounter);

	for (int i=0; i<ptBm.length(); i++)
	{
		if (_XW.dotProduct(ptCenter-ptBm[i])>0)
		{
			ptLeft.append(ptBm[i]);
		}
		else
		{
			ptRight.append(ptBm[i]);
		}
		if (_YW.dotProduct(ptCenter-ptBm[i])>0)
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
	for (int i=0; i<ptBm.length(); i++)
	{
		int iN = i==ptBm.length()-1 ? 0 : i+1;
		
		if (!(abs((ptBm[i]-ptBm[iN]).dotProduct(_XW))<0.02 || abs((ptBm[i]-ptBm[iN]).dotProduct(_YW))<0.02))
		{
			ptAngled.append(ptBm[i]);
			ptAngled.append(ptBm[iN]);
		}
	}
	
	if (nDispChain != _kDimNone)
	{
		for (int i = 0; i < ptAngled.length() - 1; i += 2)
		{
			Point3d ptDim[0];
			ptDim.append(ptAngled[i]);
			ptDim.append(ptAngled[i + 1]);
			Vector3d vecLine (ptAngled[i] - ptAngled[i + 1]);
			vecLine.normalize();
			if ( ! (vecLine.isCodirectionalTo(_YW)))
				vecLine = - vecLine;
			Vector3d vecDir1 (_ZW.crossProduct(-vecLine));
			DimLine dlAngled(ptCenter + vecDir1 * U(200), - vecLine, vecDir1);
			// dimline
			Dim dimAngled (dlAngled, ptDim, "<>", " <> ", nDispChain, _kDimNone);
			dimAngled.setDeltaOnTop(TRUE);
			dp.draw(dimAngled);
			
		}
	}
	
	//Angle calculation
	ptBm.append(ptBm[0]);
	ptBm.append(ptBm[1]);
	
	Display dpAngle(0);
	dpAngle.dimStyle(sDimStyle);
	dpAngle.textHeight(dAngleTextHeight);
	for (int i = 0; i < ptBm.length() - 2; i++)
	{ 
		Vector3d vecThis (ptBm[i+1] - ptBm[i]);
		Vector3d vecNext (ptBm[i+1] - ptBm[i + 2]);
		
		vecThis.normalize();
		vecNext.normalize();
		
	
		
		Vector3d vOffsetAngle = vecThis + vecNext; vOffsetAngle.normalize();
		
		double dAngle;
		dAngle = vecThis.angleTo(vecNext, -_ZW);
		
		if (abs(dAngle - 90) < 1) continue;

		String strAngle = int (dAngle);
		dpAngle.draw(strAngle+"º",ptBm[i + 1]+dAngleOffset*vOffsetAngle,_XW,_YW,0,0);
	}
	
	// create the dim
	if (nDispChain != _kDimNone)
	{
		// make up a dimline
		DimLine dlUp(ptCenter - _YW * U(150), _XW, _YW);
		DimLine dlDown(ptCenter + _YW * U(150), _XW, _YW);
		DimLine dlLeft(ptCenter - _XW * U(150), _YW, - _XW);
		DimLine dlRight(ptCenter + _XW * U(150), _YW, - _XW);
		
		// dimline
		Dim dimUp (dlUp, ptUp, "<>", " <> ", nDispChain, _kDimNone);
		dimUp.setDeltaOnTop(FALSE);
		Dim dimDown (dlDown, ptDown, "<>", " <> ", nDispChain, _kDimNone);
		dimDown.setDeltaOnTop(TRUE);
		Dim dimLeft (dlLeft, ptLeft, "<>", " <> ", nDispChain, _kDimNone);
		dimLeft.setDeltaOnTop(TRUE);
		Dim dimRight (dlRight, ptRight, "<>", " <> " , nDispChain, _kDimNone);
		dimRight.setDeltaOnTop(FALSE);
		
		// draw the display of the dim
		if (ptUp.length() > 1)
			dp.draw(dimUp);
		if (ptDown.length() > 1)
			dp.draw(dimDown);
		if (ptLeft.length() > 1)
			dp.draw(dimLeft);
		if (ptRight.length() > 1)
			dp.draw(dimRight);
	}
	//dp.setColor(2);
	dp.draw(AllPlToDim[b]);
	int pflaux=b+1;
	String str = sLabel;
	str=str+pflaux;
	String str1=qtyOfProf[b];
	dp.draw(str+" "+"("+str1+")",ptCenter-_XW*U(100) -_YW*U(dOffsetText),_XU,_YU,1,1);
	dxaout(str, str1);
	
	nFiles++;
	
	if (nFiles>=nColumn)
		nFiles=0;
}





#End
#BeginThumbnail




#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Use Internal Angles, Expose some properties and improve them with categories." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="11/24/2022 10:01:05 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End