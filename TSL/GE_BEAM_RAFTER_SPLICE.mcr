#Version 8
#BeginDescription
v1.3: 15-may--2012: David Rueda (dr@hsb-cad.com) 
Rafter splice on selected beam(s)
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
* v1.3: 15-may--2012: David Rueda (dr@hsb-cad.com)
	- Thumbnail added
* v1.2: 11-Apr--2011: David Rueda (dr@hsb-cad.com)
	- Making sure displaced piece is the lower one of the 2 resultants from every rafter
* v1.1: 06-Apr--2011: David Rueda (dr@hsb-cad.com)
	- Bug fix, copy was extended to infinite...
* v1.0: 04-Apr--2011: David Rueda (dr@hsb-cad.com)
	- Release
*/

if (_bOnInsert) 
{
	if( insertCycleCount()>1 )
	{ 
		eraseInstance();
		return;
	}
	
	PrEntity ssE("\n"+T("|Select beam(s) to splice|"),Beam());
	
	if( ssE.go() )
	{
		_Beam.append(ssE.beamSet());
	}

	_Pt0=getPoint(T("|Select splice midpoint|"));
	
	//Getting direction for ne beams
	Point3d ptDir=getPoint(T("|Offset direction for new beams|"));
	Vector3d vInput(ptDir-_Pt0);//This vector can be ponting to anywhere, even paralell to beam because is user defined

	//Getting and casting splice value
	String sL=getString(T("|Set splice overlap <2'-0''>|"));
	double dL=sL.atof();
	if(dL==0)// User set nothing or a non-numeric value. Default value must be inserted
	{
		double dDef=(U(610,24));
		dL=dDef;
	}

	if(_Beam.length()<=0)
	{
		eraseInstance();
		return;	
	}

	if(dL<=0)
	{
		reportMessage("\n"+T("|Length must ve positive value|"));
		eraseInstance();
		return;	
	}
	
	Beam bmAll[0];
	bmAll.append(_Beam);
	
	for(int b=0;b<_Beam.length();b++)
	{
		Beam bm=_Beam[b];

		//Getting beam's reference
		Point3d ptBmCen=bm.ptCen();
		Vector3d vBmX=bm.vecX();
		Vector3d vBmZ=bm.vecD(_ZW);
		Vector3d vBmY=vBmZ.crossProduct(vBmX);

		//Getting proyected point on beam
		Point3d ptTmp1=ptBmCen+vBmX*10;
		Point3d ptTmp2=ptBmCen-vBmX*10;
		ptTmp1.setZ(0);ptTmp2.setZ(0);//Must be vertical aligned to get projection plane
		Vector3d vTmp(ptTmp2-ptTmp1);
		Plane pln0(_Pt0,vTmp);
		Line lnX(ptBmCen,vBmX);
		Point3d ptCen=lnX.intersect(pln0,0);

		Point3d ptStart=ptCen+dL*.5*vBmX;
		Point3d ptEnd=ptCen-dL*.5*vBmX;

		//Check if there is room for splice along beam lenght
		Body bdBm=bm.realBody();
		Point3d ptBmExtrems[]=bdBm.extremeVertices(vBmX);
		Point3d ptExt1=ptBmExtrems[0];
		Point3d ptExt2=ptBmExtrems[ptBmExtrems.length()-1];
		if(	vBmX.dotProduct(ptStart-ptExt1)<=0||vBmX.dotProduct(ptExt2-ptStart)<=0 //Checking that ptStart is between both extrems of beam
			||
			vBmX.dotProduct(ptEnd-ptExt1)<=0||vBmX.dotProduct(ptExt2-ptEnd)<=0 )//Checking that ptEnd is between both extrems of beam
		{
			reportMessage(T("\n"+"|ERROR: There is no room for splice on selected point|"+"\n"));
			continue;
		}
		
		//Cut beam
		Beam bmNew;
		bmNew=bm.dbSplit(ptEnd, ptStart);
		bmAll.append(bmNew);
		
		//Moving one of the pieces
		//Must find vector pointing to SIDE of beam
		Vector3d vDir=vBmY;
		if(vDir.dotProduct(vInput)<=0)
		{
			vDir=-vDir;
		}
		double dDist=bm.dD(vBmY);
		//Define which piece is gonna be displaced
		if(bm.ptCen().Z()<bmNew.ptCen().Z())//
		{
			bm.transformBy(vDir*dDist);
		}
		else
		{
			bmNew.transformBy(vDir*dDist);
		}
	}

	eraseInstance();
	return;
}




#End
#BeginThumbnail
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
M-GH]%<Y_PMG1?^A+_P#*H_\`\11_PMG1?^A+_P#*H_\`\17E?V?5[H]#ZY3\
MSHZ*YS_A;.B_]"7_`.51_P#XBC_A;.B_]"7_`.51_P#XBC^SZO=!]<I^9H^)
MO^1)U[_KWB_]*(:\:KOO$GQ'M-9T"YTRP\.IIYN=JRS->-,=BL'P`0`#N5>>
M>,\<Y'`UZ.&I2I4^61Q5ZBJ3YD%%%%;F(4444`%>Q_#W_DEL_P#V&F_]$)7C
ME=UX0^(5KX:\.2Z/=Z%_:,;W9N@_VLPX)15Q@*?[I[]ZRK0<Z;BNII2DHS4F
M=[17.?\`"V=%_P"A+_\`*H__`,11_P`+9T7_`*$O_P`JC_\`Q%>9_9]7NCO^
MN4_,Z.BN<_X6SHO_`$)?_E4?_P"(H_X6SHO_`$)?_E4?_P"(H_L^KW0?7*?F
M.\??\B.W_82M_P#T5/7E-=IXO\>6_B32HM.LM#3381.)Y6-RTS.RJRJ!D#``
M=L]<\=,<\77I8>FZ=-19PUIJ<W)!1116QD%%%%`!7N7AW_DE_A?_`+>__1QK
MPVO1=`^)MEI'A?3]%O/#?V[[%YFV;[<8L[W+'Y0A]0.IZ5CB*;J4W&)K1FH3
M4F=E17.?\+9T7_H2_P#RJ/\`_$4?\+9T7_H2_P#RJ/\`_$5YO]GU>Z.[ZY3\
MSHZ*YS_A;.B_]"7_`.51_P#XBC_A;.B_]"7_`.51_P#XBC^SZO=!]<I^93^)
MG_(&T/\`Z^+O_P!!@KS>NJ\9>,(O%)LH[;2DTZVM=[",3M*S.^W<2Q`XPBX&
M/7DYXY6O4HP<*:B^AP59*4W)!1116AF%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
A44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'__9
`



#End
