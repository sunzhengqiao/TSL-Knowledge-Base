#Version 8
#BeginDescription
Tags sheet(s) that exceed max. area i(nput by user)
v1.5: 23.jul.2012: David Rueda (dr@hsb-cad.com)




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
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
* v1.5: 23.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
* v1.4: 15-may-2012: David Rueda (dr@hsb-cad.com)
	- Bugfix: Numbering was counting skipped sheeting. Solved
* v1.3: 04-may-2012: David Rueda (dr@hsb-cad.com)
	- Works on xRefs also
	- Tsl will auto recalc itself when any prop. is changed (command hsb_recalc is no longer needed).
	- Solved bugfix when recalculated and only one sheet piece was left (it was still showing one sheet piece even if it did not exceed area).
	- All sheets will be 'remembered' by tsl so user can play around with max. area value.
	- If no sheet exceeds area tsl will be deleted.
* v1.2: 26-apr-2012: David Rueda (dr@hsb-cad.com)
	Numbering sorted by rows and columns
* v1.1: 23-apr-2012: David Rueda (dr@hsb-cad.com)
	Added value to sheeting.label()
* v1.0: 22-apr-2012: David Rueda (dr@hsb-cad.com)
	Release
*/

U(1, "inch");
double dTolerance=U(.01);
String sPropAreaName= T("|Limit area|" + " (sq ft)" );
PropDouble dArea(0, 35, sPropAreaName);
dArea.setFormat( _kNoUnit);
String sPropStarNumName= T("|Start count on|");
PropInt nStartNum(0, 1, sPropStarNumName);
String sPropPrefixName= T("|Prefix|");
PropString sPrefix(0, "", sPropPrefixName);
String sPropColorName= T("|Color|");
PropInt nColor(1, 1, sPropColorName);
String sPropDimstyleName= T("|Dimstyle|");
PropString sDimstyle (1, _DimStyles, sPropDimstyleName);

if(_bOnInsert){
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	showDialogOnce("_Lastinserted");
		
	PrEntity ssE("\n"+T("|Select sheeting|"+"(s)"),Sheet());
	ssE.allowNested(true);
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

if( _bOnRecalc || _kNameLastChangedProp == sPropAreaName || _kNameLastChangedProp == sPropStarNumName || _kNameLastChangedProp == sPropPrefixName
 	|| _kNameLastChangedProp == sPropColorName || _kNameLastChangedProp == sPropDimstyleName)
	_Map.setInt("ExecutionMode",0);

if( _Map.getInt("ExecutionMode")==0)
{
	// Sort sheeting
	// Find any sheet in first row
	Vector3d vPlnX= _Sheet[0].vecX();
	Vector3d vPlnY= _Sheet[0].vecY();
	int nMax=0; // Index of current taken position along _Sheet[]
	
	for( int s=0; s< _Sheet.length(); s++)
	{
		// Find first sheet on row
		double dY=U(40000);
		Sheet shNewAnyFirst= _Sheet[nMax];
		Point3d ptOutNext= shNewAnyFirst.ptCen()+vPlnY*dY;
		int nNewIndex=nMax;
		for( int q=nMax; q< _Sheet.length(); q++)
		{
			Sheet shNext= _Sheet[q];
			Point3d ptq= shNext.ptCen();	
			if( vPlnY.dotProduct(ptOutNext-ptq) < dY)
			{
				shNewAnyFirst= shNext;
				dY=vPlnY.dotProduct(ptOutNext-ptq);
				nNewIndex= q;
			}
		}
		_Sheet.swap(nNewIndex,nMax);
		// We have first sheet in row (not sorted horizontally) in _Sheet[nMax]
		
		// Find any other sheets in same row
		Sheet sh0= _Sheet[nMax];
		Point3d pt0= sh0.ptCen();	
		Body bdSh0= sh0.envelopeBody();
		Point3d ptExtr0[]= bdSh0.extremeVertices( vPlnY);
		Point3d ptTop0= ptExtr0[ ptExtr0.length()-1];
		Point3d ptBottom0= ptExtr0[0];
		for( int t=s+1; t< _Sheet.length(); t++)
		{	
			Sheet sh1= _Sheet[t];
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
					_Sheet.swap(nMax,t);
			}
		}
	
		// Sort in row horizontally 
		for( int i=s; i< nMax; i++)
		{
			for( int j=s; j< nMax; j++)
			{
				if( vPlnX.dotProduct( _Sheet[j].ptCen()- _Sheet[j+1].ptCen())<0)
				{
					_Sheet.swap(j,j+1);
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
	
	int nIndex= 0;
	for( int s=0; s< _Sheet.length(); s++)
	{
		Sheet sh= _Sheet[s];
		if( !sh.bIsValid())
			continue;
		PLine plSh= sh.plEnvelope();
		double dShArea= U(plSh.area());
		dShArea=dShArea/(12*12);
		if( dArea< dShArea-dTolerance)
		{
			Point3d ptD; ptD.setToAverage(plSh.vertexPoints(1));
			int nNum= nStartNum+nIndex;
			nIndex++;
			String sNum= nNum;
			sNum= sPrefix+sNum;
			sh.setLabel( sNum);
			Map map;
			map.setString("VALUE", sNum);
			_Map.setMap( nIndex , map);
			double dVOff=U(10);
			Vector3d vy= sh.vecY();
			_PtG.append(ptD+vy*dVOff);
		}
	}
	_Map.setInt("ExecutionMode",1);
}

	if(_Sheet.length()<=0)
	{
		eraseInstance();
		return
	}

// Display
Display dp( nColor);
dp.dimStyle( sDimstyle);
if( _PtG.length()==0)
{
	reportMessage("\n"+T("|No sheets exceeding|"+" ")+dArea+" SQ FT. Tsl "+T("|will be deleted|"));
	eraseInstance();
	return;
}

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
M7_G_`#^__@GEG]M>//\`GE?_`/@`/_B*/[:\>?\`/*__`/``?_$5ZG11]>A_
MSZC]P?V75_Y_S^__`()Y9_;7CS_GE?\`_@`/_B*/[:\>?\\K_P#\`!_\17J=
M%'UZ'_/J/W!_9=7_`)_S^_\`X)Y9_;7CS_GE?_\`@`/_`(BC^VO'G_/*_P#_
M```'_P`17J=%'UZ'_/J/W!_9=7_G_/[_`/@GEG]M>//^>5__`.``_P#B*/[:
M\>?\\K__`,`!_P#$5ZG11]>A_P`^H_<']EU?^?\`/[_^">6?VUX\_P">5_\`
M^``_^(H_MKQY_P`\K_\`\`!_\17J=%'UZ'_/J/W!_9=7_G_/[_\`@GEG]M>/
M/^>5_P#^``_^(H_MKQY_SRO_`/P`'_Q%>IT4?7H?\^H_<']EU?\`G_/[_P#@
MGEG]M>//^>5__P"``_\`B*/[:\>?\\K_`/\```?_`!%>IT4?7H?\^H_<']EU
M?^?\_O\`^">6?VUX\_YY7_\`X`#_`.(H_MKQY_SRO_\`P`'_`,17J=%'UZ'_
M`#ZC]P?V75_Y_P`_O_X)Y9_;7CS_`)Y7_P#X`#_XBC^VO'G_`#RO_P#P`'_Q
M%>IT4?7H?\^H_<']EU?^?\_O_P"">6?VUX\_YY7_`/X`#_XBC^VO'G_/*_\`
M_``?_$5ZG11]>A_SZC]P?V75_P"?\_O_`.">6?VUX\_YY7__`(`#_P"(H_MK
MQY_SRO\`_P``!_\`$5ZG11]>A_SZC]P?V75_Y_S^_P#X)Y9_;7CS_GE?_P#@
M`/\`XBL[5%\5:UY7]H6-_-Y6=G^AE<9QGHH]!7LE%5',8P?-&E%,B>3RJ1Y9
MUI->;*&B1O%H.G1R(R2):Q*RL,%2%&015^BBO.E+F;9[,(\L5'L%%%%24%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
)110`4444`?_9
`

#End
