#Version 8
#BeginDescription
/// Um eine übersichtliche Einzelzeichnung zu erhalten ist es mitunter gewünscht ein bestimmtes Koordinatensystem
/// einer Massengruppe festlegen zu können. Dies wird in hsbCAD 2012 mittels des nachfolgend beschrieben TSL's
/// 'hsbTSL ECS Symbol' durchgeführt, in Version 2013 wird voraussichtlich wie für Metallteil-Kollektionen das Objekt
/// 'hsbCAD ECS Symbol' Verwendung finden.

/// Version 1.0   th@hsbCAD.de   08.09.2011
/// inital
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Um eine übersichtliche Einzelzeichnung zu erhalten ist es mitunter gewünscht ein bestimmtes Koordinatensystem
/// einer Massengruppe festlegen zu können. Dies wird in hsbCAD 2012 mittels des nachfolgend beschrieben TSL's
/// 'hsbTSL ECS Symbol' durchgeführt, in Version 2013 wird voraussichtlich wie für Metallteil-Kollektionen das Objekt
/// 'hsbCAD ECS Symbol' Verwendung finden.
/// </summary>

/// <insert Lang=de>
/// Rufen Sie den Befehl über die Multifunktionsleiste hsbContentDACH oder über den TSL-Manager auf und geben Sie den Einfügepunkt an. 
/// </insert>

/// History
/// Version 1.1   th@hsbCAD.de   11.10.2017 export flag activated
/// Version 1.0   th@hsbCAD.de   08.09.2011
/// inital



//basics and props
	U(1,"mm");
	double dEps=U(.1);
	double dRadius = U(50);
	PropDouble dCompassGridAngle (0,15,T("|Grid Angle|"),_kAngle);
// on insert
	if (_bOnInsert){
		if (insertCycleCount()>1) { eraseInstance(); return; }

		_Pt0 = getPoint();
		_PtG.append(_Pt0+_XU*2*dRadius);
		_PtG.append(_Pt0+_YU*2*dRadius);
		_PtG.append(_Pt0+_ZU*2*dRadius);
		
		return;
	}	
	
// validate grips
	if (_PtG.length()<3)
	{
		_PtG.setLength(0);	
		_PtG.append(_Pt0+_XU*2*dRadius);
		_PtG.append(_Pt0+_YU*2*dRadius);
		_PtG.append(_Pt0+_ZU*2*dRadius);		
	}	
	
// standards
	Vector3d vx,vy,vz;
	vx = _PtG[0]-_Pt0; vx.normalize();	
	vy = _PtG[1]-_Pt0; vy.normalize();
	vz = _PtG[2]-_Pt0; vz.normalize();
			
// X-Grip
	if (_kNameLastChangedProp == "_PtG0")
	{
		vx = _PtG[0]-_Pt0;
		vx.normalize();
		if (vx.isParallelTo(vz))
		{
			vz = vx.crossProduct(vy);
			vy = vx.crossProduct(-vz);	
		}
		else
		{
			vy = vx.crossProduct(-vz);	
			vz = vx.crossProduct(vy);			

		}		
	}
// Y-Grip
	else if (_kNameLastChangedProp == "_PtG1")
	{
		vy = _PtG[1]-_Pt0;
		vy.normalize();		

		if (vy.isParallelTo(vz))
		{
			vz = vx.crossProduct(vy);		
			vx = vy.crossProduct(vz);	
		}
		else
		{
			vx = vy.crossProduct(vz);			
			vz = vx.crossProduct(vy);		
		}		
		
	}	
// Z-Grip
	else if (_kNameLastChangedProp == "_PtG2")
	{
		vz = _PtG[2]-_Pt0;
		vz.normalize();
		if (vz.isParallelTo(vx))
		{
			vx = vy.crossProduct(vz);
			vy = vx.crossProduct(-vz);	
		}
		else
		{
			vy = vx.crossProduct(-vz);				
			vx = vy.crossProduct(vz);
		}		
				
	}	
	
	if (_kNameLastChangedProp.find("_PtG",0)>-1)
	{
		_PtG[0]=_Pt0+vx*2*dRadius;
		_PtG[1]=_Pt0+vy*2*dRadius;
		_PtG[2]=_Pt0+vz*2*dRadius;		
	}
	
// Display
	Display	dp(1);
	PLine plCirc;
	plCirc.createCircle(_Pt0, vz, dRadius);
	dp.draw(plCirc);
	PLine plShort (_Pt0+vx*dRadius,_Pt0+vx*dRadius*1.2);
	PLine plLong (_Pt0+vx*dRadius,_Pt0+vx*dRadius*1.4);
	CoordSys csRot;
	
	int n = 360/dCompassGridAngle;
	double dAngle = 360/n;
	if (abs(dAngle-dCompassGridAngle)>dEps) dCompassGridAngle.set(dAngle);
	
	csRot.setToRotation(dAngle,vz,_Pt0);
	for (int i=0;i<n;i++)
	{
		if (i%3==0)
			dp.draw(plLong);
		else
			dp.draw(plShort);
		plShort.transformBy(csRot);	
		plLong.transformBy(csRot);
	}
	
// draw coordSys
	PLine plVector(_Pt0,_PtG[0]);
	plCirc.createCircle(_PtG[0]-vx*.4*dRadius, vx, .2*dRadius);
	PLine plArrow1(_PtG[0]-(2*vx+vz)*.2*dRadius, _PtG[0],_PtG[0]-(2*vx-vz)*.2*dRadius );
	PLine plArrow2(_PtG[0]-(2*vx+vy)*.2*dRadius, _PtG[0],_PtG[0]-(2*vx-vy)*.2*dRadius );

	int nArColor[] = {1,3,150};		
	for (int i=0;i<nArColor.length();i++)
	{
		dp.color(nArColor[i]);
		dp.draw(plCirc);
		dp.draw(plArrow1);
		dp.draw(plArrow2);
		dp.draw(plVector);
		
		if (i==0)
			csRot.setToRotation(90,vz,_Pt0);
		else if (i==1)
			csRot.setToRotation(90,vx,_Pt0);
		plVector.transformBy(csRot);
		plCirc.transformBy(csRot);
		plArrow1.transformBy(csRot);
		plArrow2.transformBy(csRot);	
	}
	
// finally set my coordSys
	_XE = vx;
	_YE = vy;
	_ZE = vz;	
	_Map.setInt("isTslEcsMarker",true);// just make sure this works also if someone changes the scriptName
	
#End
#BeginThumbnail
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
M/B_]WJ>C_(T_#G_(L:3_`->4/_H`K3K,\.?\BQI/_7E#_P"@"M.LZW\67JS2
MC_#CZ(****R-`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*YGX@?\B/J/_;/_P!&
M+735S/Q`_P"1'U'_`+9_^C%KIP7^\T_\2_,Y\7_N]3T?Y&GX<_Y%C2?^O*'_
M`-`%:=9GAS_D6-)_Z\H?_0!6G6=;^++U9I1_AQ]$%%%%9&@4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%<S\0/\`D1]1_P"V?_HQ:Z:N9^('_(CZC_VS_P#1BUTX
M+_>:?^)?F<^+_P!WJ>C_`"-/PY_R+&D_]>4/_H`K3K,\.?\`(L:3_P!>4/\`
MZ`*TZSK?Q9>K-*/\./H@HHHK(T"BBF&6-9EA,BB5E+*A;D@8!('H-P_,>M`)
M7'T444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`5S/Q`_Y$?4?^V?_HQ:Z,2QF9H1(IE50S(#
MR`<@$CT.TX^A]*YSX@?\B/J/_;/_`-&+73@O]YI_XE^9SXQ6P]2_\K_(T_#G
M_(L:3_UY0_\`H`K3K,\.?\BQI/\`UY0_^@"M.LZW\67JS2C_``X^B"BBBLC0
M*\W\-3?\)3\3]6UIC$]MI<?V6UVR9QDLH92``P($IYSC>,9P".O\6:LVA^%=
M1U!"RRQ0D1,J@E78A5.#Q@,P)]O6L[X=:2ND^";$87S;I?M4A5B0Q?E>O0[-
M@('&1^-<\_>J1CVU_P`CUL+:A@JM?K+W%^<OPLOF=511170>2%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`445SUUXRTJUG,2F:?'5X5!7.>F21
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
%110!_]GL
`


#End