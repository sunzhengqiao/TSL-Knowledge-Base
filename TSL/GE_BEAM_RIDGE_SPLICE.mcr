#Version 8
#BeginDescription
v1.4: 15-may--2012: David Rueda (dr@hsb-cad.com) 
Ridge splice on selected beam(s)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
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
* v1.4: 15-may--2012: David Rueda (dr@hsb-cad.com)
	- Thumbnail added
* v1.3: 04-Apr--2011: David Rueda (dr@hsb-cad.com)
	- Small change on prompt message, indicating default value to use if user don't set any
* v1.2: 04-Apr--2011: David Rueda (dr@hsb-cad.com)
	- Enhanced to allow blank (or non-numeric) value when overlap distance is needed, then a default value will be set
* v1.1: 01-Apr--2011: David Rueda (dr@hsb-cad.com)
	- Bugfix
* v1.0: 01-Apr--2011: David Rueda (dr@hsb-cad.com)
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
		
		//Defining splice start and end points
		Point3d pt1=ptCen+dL*.5*vBmX;
		Point3d pt2=ptCen-dL*.5*vBmX;
		Point3d ptStart, ptEnd;// ptStart=highest point of splice

		if(pt1.Z()==pt2.Z())//Points are at same height in world coords. (flat beam)
		{
			ptStart=pt1;
			ptEnd=pt2;	
		}
		else
		{
			if(pt1.Z()<pt2.Z())//pt1 is lower than pt2
			{
				ptStart=pt2;
				ptEnd=pt1;	
			}
			else
			{
				ptStart=pt1;
				ptEnd=pt2;	
			}
		}
	
		//Check if there is room for splice along beam lenght
		Body bdBm=bm.realBody();
		Point3d ptBmExtrems[]=bdBm.extremeVertices(vBmX);
		Point3d ptExt1=ptBmExtrems[0];
		Point3d ptExt2=ptBmExtrems[ptBmExtrems.length()-1];
		if(	vBmX.dotProduct(ptStart-ptExt1)<=0||vBmX.dotProduct(ptExt2-ptStart)<=0 //Checking that ptStart is between both extrems of beam
			||
			vBmX.dotProduct(ptEnd-ptExt1)<=0||vBmX.dotProduct(ptExt2-ptEnd)<=0 )//Checking that ptEnd is between both extrems of beam
		{
			reportMessage(T("\n"+"|ERROR: There is no room for splicing beam on selected point|"+"\n"));
			continue;	
		}
		
		//WORK WITH ORIGINAL BEAM AND ITS "EXTENSION"
		//Copy #1: reeplace the part that the cut will throw away
		Beam bmExt;
		bmExt=bm.dbCopy();//"Extension" beam

		//Find plane to cut
		ptStart-=vBmZ*bm.dD(vBmZ)*.5;
		ptEnd+=vBmZ*bm.dD(vBmZ)*.5;
		Point3d pt3=ptStart+vBmY*10;

		//Adding cut to created beams
		//Original beam
		Cut ctOrg(ptStart, ptEnd, pt3, Point3d(0,0,0), 1);
		bm.addToolStatic(ctOrg);
		//Extension beam
		Cut ctOp(ptStart, ptEnd, pt3, Point3d(0,0,0), -1);
		bmExt.addToolStatic(ctOp);

		//WORK WITH EXTRA BEAMS AT SIDE
		//Creating side beams
		Beam bmSide1;
		bmSide1=bm.dbCopy();
		Beam bmSide2;
		bmSide2=bm.dbCopy();
		//Moving them to right position
		double dBmH=bm.dD(vBmY);
		bmSide1.transformBy(vBmY*(dBmH));
		bmSide2.transformBy(-vBmY*(dBmH));
		//Cutting these side beams to set desired length
		Point3d ptCt1=ptCen+dL*.5*vBmX;
		Cut ct1(ptCt1,vBmX);
		Point3d ptCt2=ptCen-dL*.5*vBmX;
		Cut ct2(ptCt2,-vBmX);
		bmSide1.addToolStatic(ct1,TRUE);
		bmSide1.addToolStatic(ct2,TRUE);
		bmSide2.addToolStatic(ct1,TRUE);
		bmSide2.addToolStatic(ct2,TRUE);
	}
	eraseInstance();
	return;
}








#End
#BeginThumbnail
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
M**`"OB#QW_R4/Q+_`-A6Z_\`1K5]OU\0>._^2A^)?^PK=?\`HUJ`.?HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"OM_P)_R3SPU_P!@JU_]%+7Q!7V_X$_Y)YX:_P"P5:_^
MBEH`Z"BBB@`KX@\=_P#)0_$O_85NO_1K5]OU\0>._P#DH?B7_L*W7_HUJ`.?
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"OM_P)_P`D\\-?]@JU_P#12U\05]O^!/\`DGGA
MK_L%6O\`Z*6@#H****`"OB#QW_R4/Q+_`-A6Z_\`1K5]OU\0>._^2A^)?^PK
M=?\`HUJ`.?HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
$@#__V:*`
`



#End
