#Version 8
#BeginDescription
Tags if sheeting pieces are CUT or UNCUT (Complete length of piece)
v1.2: 13.ago.2012: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
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
* v1.2: 13.ago.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
* v1.1: 04-may-2012: David Rueda (dr@hsb-cad.com)
	- Works with xRefs also
* v1.0: 27-apr-2012: David Rueda (dr@hsb-cad.com)
	Release
*/

U(1, "inch");
double dTolerance=U(.01);
String sChoices[]= {T("|CUT|"), T("|UNCUT|")};
String sPropChoiceName= T("|Tag on|");
PropString sChoice( 0, sChoices, sPropChoiceName,0);
int nChoice= sChoices.find( sChoice, 0);
String sPropStartNumName= T("|Start count on|");
PropInt nStartNum(0, 1, sPropStartNumName);
String sPropPrefixName= T("|Prefix|");
PropString sPrefix(1, "", sPropPrefixName);
PropInt nColor(1, 1, T("|Color|"));
PropString sDimstyle (2, _DimStyles, T("|Dimstyle|"));

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	showDialogOnce("_Lastinserted");
		
	PrEntity ssE("\n"+T("|Select sheeting|"+"(s)"),Sheet());
	ssE.allowNested(TRUE);
	if( ssE.go())
	{
		_Sheet.append(ssE.sheetSet());
	}
  	
	_Map.setInt("ExecutionMode",0);
	
	return;
}

if(_Sheet.length()<=0)
{
	eraseInstance();
	return
}

if( _bOnRecalc || _kNameLastChangedProp == sPropChoiceName || _kNameLastChangedProp == sPropStartNumName || _kNameLastChangedProp == sPropPrefixName )
	_Map.setInt("ExecutionMode",0);

if( _Map.getInt("ExecutionMode")==0)
{
	/* Filter CUT/UNCUT sheets based on these rules:
		- One length is 8 ft.
		- Other length is 4 ft.
		- Area is 32 SQ FT
	*/ 
	
	Sheet shDisp[0];
	double dArea= U(32);
	double dL1= U(96);
	double dL2= U(48);
	Sheet shCut[0], shUncut[0];
	for( int s=0; s< _Sheet.length(); s++)
	{
		Sheet sh= _Sheet[s];
		if( !sh.bIsValid())
		{
			continue;
		}
		sh.setLabel("");
		
		PLine plSh= sh.plEnvelope();
		double dShArea= U(plSh.area());
		dShArea=dShArea/(12*12);
		if( abs(dArea-dShArea)<dTolerance) // Sheet has needed area but don't know if has proper sizes, might be uncut piece
		{
			double dL= sh.solidLength();
			double dW= sh.solidWidth();
			if( 
				(
					abs(dL-dL1)<dTolerance 
					&& 
					abs(dW-dL2)<dTolerance
				) 
			|| 
				(
					abs(dL-dL2)<dTolerance 
					&& 
					abs(dW-dL1)<dTolerance
				)
			)
				shUncut.append(sh);
		}
		else
			shCut.append(sh);
	}

	Sheet shDisplay[0];
	if( nChoice==0) // Show cut pieces
		shDisplay= shCut;
	else // show uncut pieces
		shDisplay= shUncut;
	
	// Sort sheeting
	// Find any sheet in first row
	Vector3d vPlnX= _Sheet[0].vecX();
	Vector3d vPlnY= _Sheet[0].vecY();
	int nMax=0; // Index of current taken position along _Sheet[]
	
	for( int s=0; s< shDisplay.length(); s++)
	{
		// Find first sheet on row
		double dY=U(40000);
		Sheet shNewAnyFirst= shDisplay[nMax];
		Point3d ptOutNext= shNewAnyFirst.ptCen()+vPlnY*dY;
		int nNewIndex=nMax;
		for( int q=nMax; q< shDisplay.length(); q++)
		{
			Sheet shNext= shDisplay[q];
			Point3d ptq= shNext.ptCen();	
			if( vPlnY.dotProduct(ptOutNext-ptq) < dY)
			{
				shNewAnyFirst= shNext;
				dY=vPlnY.dotProduct(ptOutNext-ptq);
				nNewIndex= q;
			}
		}
		shDisplay.swap(nNewIndex,nMax);
		// We have first sheet in row (not sorted horizontally) in _Sheet[nMax]
		
		// Find any other sheets in same row
		Sheet sh0= shDisplay[nMax];
		Point3d pt0= sh0.ptCen();	
		Body bdSh0= sh0.envelopeBody();
		Point3d ptExtr0[]= bdSh0.extremeVertices( vPlnY);
		Point3d ptTop0= ptExtr0[ ptExtr0.length()-1];
		Point3d ptBottom0= ptExtr0[0];
		for( int t=s+1; t< shDisplay.length(); t++)
		{	
			Sheet sh1= shDisplay[t];
			Point3d pt1= sh1.ptCen();
			Body bdSh1= sh1.envelopeBody();	
			Point3d ptExtr1[]= bdSh1.extremeVertices(vPlnY);
			Point3d ptTop1= ptExtr1[ ptExtr1.length()-1];
			Point3d ptBottom1= ptExtr1[ 0];
			if( 	(vPlnY.dotProduct( pt0- ptBottom1) >0 && vPlnY.dotProduct( ptTop1- pt0) >0)
				||
				(vPlnY.dotProduct( pt1- ptBottom0) >0 && vPlnY.dotProduct( ptTop0- pt1) >0))
			{
					nMax++;
					shDisplay.swap(nMax,t);
			}
		}
	
		// Sort in row horizontally 
		for( int i=s; i< nMax; i++)
		{
			for( int j=s; j< nMax; j++)
			{
				if( vPlnX.dotProduct( shDisplay[j].ptCen()- shDisplay[j+1].ptCen())<0)
				{
					shDisplay.swap(j,j+1);
				}
			}
		}
		// Row is horizontally sorted
		
		s=nMax;
		nMax++;
		// Next row
	}
	// _Sheet is sorted by rows and columns

	// Creating _Ptg for every sheet
	_PtG.setLength(0);
	
	for( int s=0; s< shDisplay.length(); s++)
	{
		Sheet sh= shDisplay[s];
		if( !sh.bIsValid())
			continue;
		PLine plSh= sh.plEnvelope();
		Point3d ptD; ptD.setToAverage(plSh.vertexPoints(1));
		String sIndex= s+1;
		int nNum= nStartNum+s;
		String sNum= nNum;
		sNum= sPrefix+sNum;
		sh.setLabel( sNum);
		Map map;
		map.setString("VALUE", sNum);
		_Map.setMap( sIndex , map);
		double dVOff=U(10);
		Vector3d vy= sh.vecY();
		_PtG.append(ptD+vy*dVOff);
	}
	_Map.setInt("ExecutionMode",1);
}

// Display
Display dp( nColor);
dp.dimStyle( sDimstyle);
for( int p=0; p<_PtG.length(); p++)
{
	Point3d pt= _PtG[p];
	if( !_Map.hasMap( p+1))
		continue;
	Map map= _Map.getMap(p+1);
	String sNum= map.getString("VALUE");
	dp.draw( sNum, _PtG[p], _XW, _YW, 0,0);
}
_Pt0= Point3d(0,0,0);

return;




#End
#BeginThumbnail
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
G`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`__9
`

#End
