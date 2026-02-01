#Version 8
#BeginDescription
Cuts sheeting in staggered rows
v1.3: 30-jul-2012: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
*  UNITED STATES OF AMERICA
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* v1.3: 30-jul-2012: David Rueda (dr@hsb-cad.com)
	- Thumbnail added
* v1.2: 30-jan-2011: David Rueda (dr@hsb-cad.com)
	- Cutting direction changed: now rows are cut starting from bottom of sheeting, that way we have less smaller pieces to cut.
* v1.1: 06-jul-2011: David Rueda (dr@hsb-cad.com)
* v1.0: 14-Mar-2011: David Rueda (dr@hsb-cad.com): Release
*/

PropDouble dL(0, U(2438.4, 96), T("|Sheeting length|"));
PropDouble dH(1, U(1219.2, 48), T("|Sheeting height|"));
if(_bOnInsert){
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	PrEntity ssE("\n"+T("|Select sheeting|"+"(s)"),Sheet());
	if( ssE.go())
	{
		_Sheet.append(ssE.sheetSet());
	}
  	
	_Pt0 = getPoint("\n"+T("|Select starting point|"+"(s)"));
	return;
}

if(_Sheet.length()<=0)
{
	eraseInstance();
	return
}

// Splitting sheets in rows
for(int s=0; s<_Sheet.length(); s++)
{
	// Getting info from sheeting
	Sheet sh= _Sheet[s];
	Point3d ptCen=sh.ptCen();
	Vector3d vy=sh.vecY();
	Vector3d vz=sh.vecZ();
	Plane plnProject( ptCen, vz);
	if(vy.dotProduct( _ZW ) <0 && !vz.isParallelTo(_ZW))
	{
		vy=_ZW.projectVector( plnProject);
		vy.normalize();
	}
	Vector3d vx=vy.crossProduct(vz);
	
	// Getting upper and lower points of sheet
	Body bdSh= sh.envelopeBody();
	Point3d ptExtrems[]= bdSh.extremeVertices(vy);
	Point3d ptBtm= ptExtrems[0];
	Point3d ptTop= ptExtrems[ptExtrems.length()-1];
	ptBtm+=vx*vx.dotProduct( ptCen- ptBtm);
	ptTop+=vx*vx.dotProduct( ptCen- ptTop);

	Point3d ptCut= _Pt0;

	// Getting cut points to get rows
	double dMaxH= abs(vy.dotProduct(ptTop-ptBtm));
	double dDist0= 0;
	int n=0;
	while( dDist0 < dMaxH)
	{	
		Point3d ptCt0= ptBtm+ vy* dH* n;
		dDist0= abs( vy.dotProduct( ptBtm-ptCt0));
		if( dDist0 < dMaxH )
			{
				Plane pln0( ptCt0, vy);
				Sheet shTmp[]=sh.dbSplit(pln0, 0);
				if( shTmp.length()>0){
					_Sheet.append( shTmp);
				}
			}
		n++;
	}
}

// Define odd or even rows
Sheet shAll[0];
shAll.append(_Sheet);
for( int s=0; s<shAll.length(); s++)// every sheet is a row
{
	// Getting sheeting info
	Sheet sh= shAll[s];
	Point3d ptCen=sh.ptCen();
	Vector3d vy=sh.vecY();
	Vector3d vz=sh.vecZ();
	Plane plnProject( ptCen, vz);
	if(vy.dotProduct( _ZW ) <0 && !vz.isParallelTo(_ZW))
	{
		vy=_ZW.projectVector( plnProject);
		vy.normalize();
	}
	Vector3d vx=vy.crossProduct(vz);

	//Getting all sheeting paralell
	Sheet shGroup[0];
	shGroup.append(sh);
	for( int t=s+1; t<shAll.length(); t++)
	{
		// Getting sheeting info
		Sheet shTmp= shAll[t];
		Point3d ptCenTmp=shTmp.ptCen();
		Vector3d vyTmp=shTmp.vecY();
		Vector3d vzTmp=shTmp.vecZ();
		Plane plnProjectTmp( ptCenTmp, vzTmp);
		if(vyTmp.dotProduct( _ZW ) <0 && !vzTmp.isParallelTo(_ZW))
		{
			vyTmp=_ZW.projectVector( plnProjectTmp);
			vyTmp.normalize();
		}
		Vector3d vxTmp=vyTmp.crossProduct(vzTmp);
		if( vx.isParallelTo(vxTmp) && vy.isParallelTo(vyTmp) && vz.isParallelTo(vzTmp) && abs(vz.dotProduct(ptCenTmp-ptCen))<0.01 ) // All vectors are paralell, means sheeting are on same plane, from initial piece
		{
			shGroup.append(shTmp);
			shAll.removeAt(t);
			t=s;
		}
	}

	// We have a sorted group of rows, must define which will have odd or even cuts
	// Sorting sheeting pieces
	// Collecting reference points
	Point3d ptCenters[0];
	for(int t=0; t<shGroup.length(); t++)
	{
		Sheet shTmp=	shGroup[t];
		ptCenters.append(shTmp.ptCen());
	}
	// Sorting (based on their center points)
	int nNrOfRows=ptCenters.length();
	int bAscending=TRUE;
	for(int s1=1; s1<nNrOfRows; s1++)
	{
		int s11 = s1;
		for(int s2=s1-1; s2>=0; s2--)
		{
			double dDist11= vy.dotProduct(_Pt0 -  ptCenters[s11]);
			double dDist2= vy.dotProduct(_Pt0 -  ptCenters[s2]);
			int bSort = dDist11 > dDist2;
			if( bAscending )
			{
				bSort = dDist11  < dDist2;
			}
			if( bSort )
			{
				ptCenters.swap(s2, s11);
				shGroup.swap(s2,s11);
				s11=s2;
			}
		}
	}// All rows are sorted
		
	// Getting even and odd rows
	Sheet shEven[0], shOdd[0], shLastRow[0];
	int nRow=0;
	for(int q=0; q<shGroup.length(); q++)
	{
		Sheet shRef= shGroup[q];//shRef.envelopeBody().vis(3);
		Point3d ptExtremeRef[]= shRef.envelopeBody().extremeVertices(vy);
		Point3d ptRefStart= ptExtremeRef[0];
		Point3d ptRefEnd= ptExtremeRef[ptExtremeRef.length()-1];
		Point3d ptRef = PLine(ptRefStart, ptRefEnd).ptMid();
		Sheet shRow[0]; // One row at the time (will contain every piece of sheeting per row)
		shRow.append(shRef);
		shLastRow.setLength(0);
		shLastRow.append(shRef);
		for(int t=q+1; t<shGroup.length(); t++)
		{
			Sheet shTmp= shGroup[t];shTmp.envelopeBody().vis(4);
			Point3d ptExtremeTmp[]= shTmp.envelopeBody().extremeVertices(vy);
			Point3d ptTmpStart= ptExtremeTmp[0];				
			Point3d ptTmpEnd= ptExtremeTmp[ptExtremeTmp.length()-1];				
			Point3d ptTmp= PLine(ptTmpStart, ptTmpEnd).ptMid();
			if( vy.dotProduct(ptRef-ptTmp) < U(1, 0.04))// sh is in same row that shRef is
			{
				shRow.append(shTmp);
				shLastRow.append(shTmp);
				q=t;
			}
			else // We have a complete row (the sheeting was already ordered)
			{
				for(int u= 0; u< shRow.length(); u++)
				{
					Sheet shInRow=shRow[u];
					if( nRow% 2 == 0) // is even row
					{
						shEven.append(shInRow);shInRow.envelopeBody().vis(2);
					}
					
					else // is odd row
					{
						shOdd.append(shInRow);shInRow.envelopeBody().vis(1);
					}
				}
				nRow++;
				break;
			}
		}
	}
	
	// Adding last piece of sheeting (per group) (won't be added in last code) 
	if( nRow% 2 == 0) // is even row
	{
		shEven.append(shLastRow);
	}
	
	else // is odd row
	{
		shOdd.append(shLastRow);
	}
 
	// grouping all rows in one array
	Sheet shAllRows[0];
	shAllRows.append(shEven);
	shAllRows.append(shOdd);

	for(int q=0; q<shAllRows.length(); q++)
	{		
		Sheet shR= shAllRows[q];
		Point3d ptStart; // Reference to start adding cut points to current sheet
		if( q< shEven.length()) // even row
		{
			ptStart= _Pt0;
		}
		else // odd row
		{
			ptStart= _Pt0+vx*dL*.5;
		}
		
		// Getting left and right points on row
		Point3d ptExtremsX[]= shR.envelopeBody().extremeVertices(vx);
		Point3d ptL= ptExtremsX[0];
		Point3d ptR= ptExtremsX[ptExtremsX.length()-1];

		ptStart+=vy*vy.dotProduct(shR.ptCen()-ptStart);
		// Moving ptStart until is outside sheet boundaries
		while (vx.dotProduct( ptStart- ptR)< 0)
		{
			ptStart+=vx*dL;
		}

		// Getting vertical cuts
		Point3d ptCutV= ptStart;
		vx.normalize();
		while (vx.dotProduct( ptCutV- ptL)> 0)
		{
			Plane plnCt( ptCutV, vx);
			shR.dbSplit(plnCt,0);
			ptCutV= ptCutV-vx*dL;
		}
	}
}
eraseInstance();
return




#End
#BeginThumbnail
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
D@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/__9
`

#End
