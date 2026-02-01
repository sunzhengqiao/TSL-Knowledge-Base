#Version 8
#BeginDescription
Displays area of selected sheeting(s)
v1.2: 10.ago.2012: David Rueda (dr@hsb-cad.com)


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
* v1.2: 10.ago.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
* v1.1: 04-may-2012: David Rueda (dr@hsb-cad.com)
	- Works on xRefs also
	- Offset props. eliminated, display will be centered on sheet
* v1.0: 22-apr-2012: David Rueda (dr@hsb-cad.com)
	Release
*/

U(1, "inch");
PropInt nColor(0, 1, T("|Color|"));
PropString sDimstyle (0, _DimStyles, T("|Dimstyle|"));

if(_bOnInsert){
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	showDialogOnce("_Lastinserted");
	
	Sheet shAll[0];
	PrEntity ssE("\n"+T("|Select sheeting|"+"(s)"),Sheet());
	ssE.allowNested(true);
	if( ssE.go())
	{
		shAll.append(ssE.sheetSet());
	}
  	
	for( int s=0; s< shAll.length(); s++)
	{
		Sheet sh= shAll[s];
		if( !sh.bIsValid())
			continue;
		_Sheet.append( shAll[s]);
	}
	
	_Map.setInt("ExecutionMode",0);
	
	return;
}

if(_Sheet.length()<=0)
{
	eraseInstance();
	return
}


Display dp( nColor);
dp.dimStyle( sDimstyle);

if( _bOnRecalc)
	_Map.setInt("ExecutionMode",0);
	
if( _Map.getInt("ExecutionMode")==0)
{
	_PtG.setLength(0);
	
	for( int s=0; s< _Sheet.length(); s++)
	{
		Sheet sh= _Sheet[s];
		if( !sh.bIsValid())
			continue;
		
		double dVOff= U(5);
		Vector3d vD= _YW;
		Vector3d vx= sh.vecX();
		double dAngle= vx.angleTo( _XW);
		if( dAngle<45)
			dVOff=U(10);
		else
			dVOff=U(15);
		PLine plSh= sh.plEnvelope();
		Point3d ptD; ptD.setToAverage(plSh.vertexPoints(1));
		double dShArea= U(plSh.area());
		dShArea=dShArea/(12*12);
		String sIndex= s+1;
		Map map;
		map.setDouble("Value", dShArea);
		_PtG.append(ptD);
		_Map.setMap( sIndex , map);
	}
	_Map.setInt("ExecutionMode",1);
}

for( int p=0; p<_PtG.length(); p++)
{
	Point3d pt= _PtG[p];
	if( !_Map.hasMap( p+1))
		continue;
	Map map= _Map.getMap(p+1);
	double dShArea= map.getDouble("Value");
	String sShArea; sShArea= sShArea.formatUnit(dShArea, 2, 2) + " SQ FT";
	dp.draw( sShArea, pt, _XW, _YW, 0,0);
}

return;




#End
#BeginThumbnail
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
B***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#__V:*`
`

#End
