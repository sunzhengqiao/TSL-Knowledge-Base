#Version 8
#BeginDescription
Creates a table in model with the wall group, wall code, wall height, pitch, nailing information and lintel information of the selected elements.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 16.09.2010 - version 1.2

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
*  Copyright (C) 2008 by
*  hsbSOFT 
*  IRELAND
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
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 08.09.2010
* version 1.0: Release Version
*
* date: 14.09.2010
* version 1.1: Fix issue with multiple angles
*
* date: 16.09.2010
* version 1.2: Change the way to calculate the height of the wall
*/

Unit (1, "mm");

PropString sTitle(5, "Checking Table", T("|Table Title|"));

PropString sDimStyle(6,_DimStyles,T("|Dimstyle|"));
PropInt nColor (1, 7, T("|Table Text Color|"));
PropInt nTitleColor (2, 4, T("|Title Color|"));
PropInt nHeaderColor (3, -1, T("|Header Color|"));
PropInt nLineColor(4, -1, T("|Line Color|"));

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialogOnce();	

	_Pt0=getPoint("Pick a Point");

	PrEntity ssE(T("Please select Elements"),Element());
 	if (ssE.go())
	{
 		Entity ents[0];
 		ents = ssE.set();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			Element el = (ElementWall) ents[i];
 			_Element.append(el);
 		 }
 	}

 	if (_Element.length()== 0)eraseInstance();
	return;
}

if( _Element.length()==0 ){eraseInstance(); return;}


///////////////////////////////////
// display
Display dp(nColor);
dp.dimStyle(sDimStyle);
LineSeg ls(_Pt0-_XW*U(5), _Pt0+_XW*U(5));
LineSeg ls1(_Pt0-_YW*U(5), _Pt0+_YW*U(5));
dp.draw(ls);
dp.draw(ls1);

double dTotalArea;
double dTotalVolume;


//Levels Information
String sWallGroup[0];
String sWallCode[0];
String sWallHeight[0];
String sWallPitch[0];
String sWallNailing[0];
String sWallLintel[0];

int nNum=0;

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];

	//Element vectors
	CoordSys csEl=el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();

	int bNew = TRUE;
	
	String sHeader[0];
	String strGroup;
	Group grp[]=el.groups();
	String strCode=el.code();
	if (grp.length()>0)
	{
		strGroup=grp[0].namePart(0);
	}

	for (int l=0; l<nNum; l++)
	{
		if ( (strGroup==sWallGroup[l]) && (strCode==sWallCode[l]) )
		{
			bNew = FALSE;
			break; // out of inner for loop, we have found the equal one
		}
	}
	
	//It's a completely new group
	if (bNew)
	{
		sWallGroup.append(strGroup);
		sWallCode.append(strCode);
		sWallHeight.append("");
		sWallPitch.append("");
		sWallNailing.append("");
		sWallLintel.append("");
		nNum++;
	}
}


//Sort the Groups

//Sort the Arrays to Display

int nNrOfRows=sWallGroup.length();
int bAscending=TRUE;

for(int s1=1; s1<nNrOfRows; s1++)
{
	int s11 = s1;
	for(int s2=s1-1; s2>=0; s2--)
	{
		int bSort = sWallCode[s11] > sWallCode[s2];
		if( bAscending )
		{
			bSort = sWallCode[s11] < sWallCode[s2];
		}
		if( bSort )
		{
			sWallGroup.swap(s2, s11);
			sWallCode.swap(s2, s11);
			sWallHeight.swap(s2, s11);
			sWallPitch.swap(s2, s11);
			sWallNailing.swap(s2, s11);
			sWallLintel.swap(s2, s11);
			s11=s2;
		}
	}
}

for(int s1=1; s1<nNrOfRows; s1++)
{
	int s11 = s1;
	for(int s2=s1-1; s2>=0; s2--)
	{
		int bSort = sWallGroup[s11] > sWallGroup[s2];
		if( bAscending )
		{
			bSort = sWallGroup[s11] < sWallGroup[s2];
		}
		if( bSort )
		{
			sWallGroup.swap(s2, s11);
			sWallCode.swap(s2, s11);
			sWallHeight.swap(s2, s11);
			sWallPitch.swap(s2, s11);
			sWallNailing.swap(s2, s11);
			sWallLintel.swap(s2, s11);
			s11=s2;
		}
	}
}

//End of the sorting

int nBmTypeValidForConvex[0];
nBmTypeValidForConvex.append(_kSFStudRight);
nBmTypeValidForConvex.append(_kSFStudLeft);	
nBmTypeValidForConvex.append(_kSFAngledTPLeft);
nBmTypeValidForConvex.append(_kSFAngledTPRight);	
nBmTypeValidForConvex.append(_kKingStud);
nBmTypeValidForConvex.append(_kSFTopPlate);
nBmTypeValidForConvex.append(_kSFBottomPlate);

for (int t=0; t<sWallGroup.length(); t++)
{
	Element elThisGroup[0];
	String sGroupName=sWallGroup[t];
	String sGroupCode=sWallCode[t];
	
	for (int e=0; e<_Element.length(); e++)
	{
		Element el=_Element[e];
		
		String strGroup;
		Group grp[]=el.groups();
		String strCode=el.code();
		if (grp.length()>0)
		{
			strGroup=grp[0].namePart(0);
		}
	
		if ( (strGroup==sGroupName) && (strCode==sGroupCode) )
		{
			elThisGroup.append(el);
		}
	}
	
	//Columns
	int nHeight[0];
	String sPitchLeft[0];
	String sPitchRight[0];
	String sNailingInfo[0];
	String sHeaderDesc[0];

	for (int e=0; e<elThisGroup.length(); e++)
	{
		Element el=elThisGroup[e];
		//Element vectors
		CoordSys csEl=el.coordSys();
		Vector3d vx = csEl.vecX();
		Vector3d vy = csEl.vecY();
		Vector3d vz = csEl.vecZ();

		//Add all the information of the elements
		//BaseHeight
		
		Beam bmAll[]=el.beam();
		Point3d ptBeamVerticesForConvex[0];
		
		for (int i=0; i<bmAll.length(); i++)
		{
			Beam bm=bmAll[i];
			int nBeamType=bm.type();
			if (nBmTypeValidForConvex.find(nBeamType, -1) != -1)
			{
				Body bd=bm.realBody();
				Point3d ptBeamVertices[]=bd.allVertices();
				ptBeamVerticesForConvex.append(ptBeamVertices);
			}
		}
		
		//Extract the plane in contact with the face of the element
		Plane plnZ(el.ptOrg(), vz);
		//Project all vertex points to the plane and create the convex hull encompassing all the vertices
		ptBeamVerticesForConvex= plnZ.projectPoints(ptBeamVerticesForConvex);
		
		PLine plConvexHull;
		plConvexHull.createConvexHull(plnZ, ptBeamVerticesForConvex);
		//plConvexHull.vis();
		
		PlaneProfile plEl(plnZ);
		plEl.joinRing(plConvexHull, false);
		LineSeg ls=plEl.extentInDir(vy);
		
		double dHEl=abs(vy.dotProduct(ls.ptStart()-ls.ptEnd()));
		
		int nHEl=(int) dHEl;
		int nLoc = nHeight.find(nHEl, -1);
		if (nLoc == -1)
			nHeight.append(nHEl);
		
		//Pitch
		Beam bmAngleLeft[0];
		Beam bmAngleRight[0];
		
		for (int i=0; i<bmAll.length(); i++)
		{
			if (bmAll[i].type()==_kSFAngledTPLeft)
			{
				bmAngleLeft.append(bmAll[i]);
			}
			else if (bmAll[i].type()==_kSFAngledTPRight)
			{
				bmAngleRight.append(bmAll[i]);
			}
		}
		
		if (bmAngleLeft.length()>=1)
		{
			Vector3d vxBm=bmAngleLeft[0].vecX();
			if (vxBm.dotProduct(vx)<0)
				vxBm=-vxBm;
			double dAuxAngleLeft=vx.angleTo(vxBm);
			String sAux; 
			sAux.formatUnit(dAuxAngleLeft, sDimStyle);
			int nLoc = sPitchLeft.find(sAux, -1);
			if (nLoc == -1)
				sPitchLeft.append(sAux);
		}
		
		if (bmAngleRight.length()>=1)
		{
			Vector3d vxBm=bmAngleRight[0].vecX();
			if (vxBm.dotProduct(-vx)<0)
				vxBm=-vxBm;
			double dAuxAngleRight=-vx.angleTo(vxBm);
			String sAux; 
			sAux.formatUnit(dAuxAngleRight, sDimStyle);
			int nLoc = sPitchRight.find(sAux, -1);
			if (nLoc == -1)
				sPitchRight.append(sAux);
		}
		
		//Nailing
		double dAuxEdge=0;
		double dAuxCenter=0;
		String strNailing="";
		TslInst tslAll[]=el.tslInstAttached();
		for (int i=0; i<tslAll.length(); i++)
		{
			if ( tslAll[i].scriptName() == "hsb_Apply Naillines to Elements")
			{
				Map mpTSL=tslAll[i].map();
				if (mpTSL.hasMap("NailingInfo"))
				{
					Map mpNailInfo=mpTSL.getMap("NailingInfo");
					dAuxEdge=mpNailInfo.getDouble("dPerimeter1");
					dAuxCenter=mpNailInfo.getDouble("dIntermediate1");
				}
				break;
			}
		}
		strNailing="Perimeter "+dAuxEdge+"mm" +"/Intermediate " +dAuxCenter+"mm";
		if (dAuxEdge!=0 || dAuxCenter!=0)
		{
			int nLoc = sNailingInfo.find(strNailing, -1);
			if (nLoc == -1)
				sNailingInfo.append(strNailing);
		}
		//Header Description
		ElemText et[0];
		et = el.elemTexts(); 
		for (int i = 0; i <et.length(); i++)
		{
			Point3d ptTextorig = et[i].ptOrg();
			String eltext = et[i].text();
		
			String textCode = et[i].code();
			String textSubCode = et[i].subCode();
		
			if(textCode=="WINDOW" && textSubCode == "HEADER")
			{
				int nLoc = sHeaderDesc.find(eltext, -1);
				if (nLoc == -1)
					sHeaderDesc.append(eltext);
			}
		}
		
	}//End element this group
	
	//Store the information of that Group
	
	String sAllHeights;
	for (int i=0; i<nHeight.length(); i++)
	{
		String sAux=nHeight[i];
		//sAux.formatUnit(nHEl, sDimStyle);
		sAllHeights+=sAux;
		if (i<nHeight.length()-1)
			sAllHeights+=" - ";
	}
	sWallHeight[t]=sAllHeights;
	
	String sAllPitch;
	for (int i=0; i<sPitchLeft.length(); i++)
	{
		sPitchLeft[i]+="°";
		sAllPitch+=sPitchLeft[i];
		if (i<sPitchLeft.length()-1)
			sAllPitch+=" - ";
	}
	for (int i=0; i<sPitchRight.length(); i++)
	{
		//if ( i==0 && sPitchLeft.length()>0 )
		//{
			//sAllPitch+=" - ";
		//}
		sPitchRight[i]+="°";
		sAllPitch+=sPitchRight[i];
		if (i<sPitchRight.length()-1)
			sAllPitch+=" - ";
	}
	sWallPitch[t]=sAllPitch;
	
	String sAllNailing;
	for (int i=0; i<sNailingInfo.length(); i++)
	{
		sAllNailing+=sNailingInfo[i];
		if (i<sNailingInfo.length()-1)
			sAllNailing+=" - ";
	}
	sWallNailing[t]=sAllNailing;
	
	String sAllLintel;
	for (int i=0; i<sHeaderDesc.length(); i++)
	{
		sAllLintel+=sHeaderDesc[i];
		if (i<sHeaderDesc.length()-1)
			sAllLintel+=" - ";
	}
	sWallLintel[t]=sAllLintel;
}


//Display
Display dpTitle(nTitleColor);
dpTitle.dimStyle(sDimStyle);
Display dpHeader(nHeaderColor);
dpHeader.dimStyle(sDimStyle);
Display dpLine(nLineColor);


int nNumberOfColumns=6;    //////////////////////////////////////////
//Create table-entries
//Row index
int nRowIndex = 0;
//Row height
double dRowHeight = 1.5 * dpHeader.textHeightForStyle("Max Weight", sDimStyle);

//Column width
double dColumnW = 1.25 * dpHeader.textLengthForStyle("Max Weight", sDimStyle);

double dColumnWidthAr[]={dColumnW, dColumnW, dColumnW, dColumnW, dColumnW, dColumnW};

for (int i=0; i<sWallGroup.length(); i++)
{
	//Wall Group
	if (dColumnWidthAr[0]<(1.25 * dpHeader.textLengthForStyle(sWallGroup[i], sDimStyle)))
		dColumnWidthAr[0]=1.25 * dpHeader.textLengthForStyle(sWallGroup[i], sDimStyle);
	//Wall Code
	if (dColumnWidthAr[1]<(1.25 * dpHeader.textLengthForStyle(sWallCode[i], sDimStyle)))
		dColumnWidthAr[1]=1.25 * dpHeader.textLengthForStyle(sWallCode[i], sDimStyle);
	//Wall Height
	if (dColumnWidthAr[2]<(1.25 * dpHeader.textLengthForStyle(sWallHeight[i], sDimStyle)))
		dColumnWidthAr[2]=1.25 * dpHeader.textLengthForStyle(sWallHeight[i], sDimStyle);
	//Wall Pitch
	if (dColumnWidthAr[3]<(1.25 * dpHeader.textLengthForStyle(sWallPitch[i], sDimStyle)))
		dColumnWidthAr[3]=1.25 * dpHeader.textLengthForStyle(sWallPitch[i], sDimStyle);
	//Wall Lintel
	if (dColumnWidthAr[4]<(1.25 * dpHeader.textLengthForStyle(sWallLintel[i], sDimStyle)))
		dColumnWidthAr[4]=1.25 * dpHeader.textLengthForStyle(sWallLintel[i], sDimStyle);
	//Wall Area
	if (dColumnWidthAr[5]<(1.25 * dpHeader.textLengthForStyle(sWallNailing[i], sDimStyle)))
		dColumnWidthAr[5]=1.25 * dpHeader.textLengthForStyle(sWallNailing[i], sDimStyle);
}

double dColumnWidth;
for (int i=0; i<dColumnWidthAr.length(); i++) 
{ 
	dColumnWidth += dColumnWidthAr[i];
}


//Point in the midle between the Title and the Heager Row
Point3d ptOrgTable=_Pt0 - _YW * 2 * dRowHeight;
//Draw header of table
dpLine.draw( PLine(ptOrgTable + _YW * 2 * dRowHeight, ptOrgTable + _XW * dColumnWidth + _YW * 2 * dRowHeight) );
dpTitle.textHeight(1.5 * dRowHeight);
dpTitle.draw( sTitle, ptOrgTable + _XW * .5 * dColumnWidth + _YW * dRowHeight, _XW, _YW, 0, 0);
dpLine.draw( PLine(ptOrgTable, ptOrgTable + _XW * dColumnWidth) );
PLine plColumnBorder(ptOrgTable, ptOrgTable + _YW * 2 * dRowHeight);
dpLine.draw(plColumnBorder);
plColumnBorder.transformBy(_XW * dColumnWidth);
dpLine.draw(plColumnBorder);
//Draw column-names of table
Point3d ptTxt = ptOrgTable - _YW * nRowIndex * dRowHeight - _YW * .5 * dRowHeight;
double dCW=0;
dpHeader.draw( "Group", ptTxt + _XW * (dCW+dColumnWidthAr[0]*0.5), _XW, _YW, 0, 0);	dCW+=dColumnWidthAr[0];
dpHeader.draw( "Type", ptTxt + _XW * (dCW+dColumnWidthAr[1]*0.5), _XW, _YW, 0, 0);	dCW+=dColumnWidthAr[1];
dpHeader.draw( "Height", ptTxt + _XW * (dCW+dColumnWidthAr[2]*0.5), _XW, _YW, 0, 0);	dCW+=dColumnWidthAr[2];
dpHeader.draw( "Pitch", ptTxt + _XW * (dCW+dColumnWidthAr[3]*0.5), _XW, _YW, 0, 0);	dCW+=dColumnWidthAr[3];
dpHeader.draw( "Lintel", ptTxt + _XW * (dCW+dColumnWidthAr[4]*0.5), _XW, _YW, 0, 0);	dCW+=dColumnWidthAr[4];
dpHeader.draw( "Nailing", ptTxt + _XW * (dCW+dColumnWidthAr[5]*0.5), _XW, _YW, 0, 0);	dCW+=dColumnWidthAr[5];

plColumnBorder = PLine(ptOrgTable, ptOrgTable - _YW * dRowHeight);
dpLine.draw(plColumnBorder);
for( int i=0;i<nNumberOfColumns;i++ ){
	plColumnBorder.transformBy(_XW * dColumnWidthAr[i]);
	dpLine.draw(plColumnBorder);
}

nRowIndex++;

for (int i=0; i<sWallGroup.length(); i++)
{	
	//Upper left corner of row
	Point3d ptRow = ptOrgTable - _YW * nRowIndex * dRowHeight;
	//Create PLine to draw as border of the row
	PLine plRowBorder(ptRow, ptRow + _XW * dColumnWidth);
	
	
	//Row border
	dpLine.draw(plRowBorder);
	//Column borders
	plColumnBorder.transformBy(-_XW * dColumnWidth - _YW * dRowHeight);
	dpLine.draw(plColumnBorder);
	for( int j=0;j<nNumberOfColumns;j++ ){
		plColumnBorder.transformBy(_XW * dColumnWidthAr[j]);
		dpLine.draw(plColumnBorder);
	}			
	//Display of the arrays o ptRow	
	Point3d ptTxt = ptRow - _YW * .5 * dRowHeight;
	
	//Show here the display
	double dCW=0;

	int nFlag=TRUE;
	if (i>0)
	{
		if (sWallGroup[i-1]==sWallGroup[i])
			nFlag=FALSE;
	}

	if (nFlag)
		dp.draw( sWallGroup[i], ptTxt + _XW * (dCW+dColumnWidthAr[0]*0.5), _XW, _YW, 0, 0);
	dCW+=dColumnWidthAr[0];
	dp.draw( sWallCode[i], ptTxt + _XW * (dCW+dColumnWidthAr[1]*0.5), _XW, _YW, 0, 0);		dCW+=dColumnWidthAr[1];
	dp.draw( sWallHeight[i], ptTxt + _XW * (dCW+dColumnWidthAr[2]*0.5), _XW, _YW, 0, 0);		dCW+=dColumnWidthAr[2];
	dp.draw( sWallPitch[i], ptTxt + _XW * (dCW+dColumnWidthAr[3]*0.5), _XW, _YW, 0, 0);		dCW+=dColumnWidthAr[3];
	dp.draw( sWallLintel[i], ptTxt + _XW * (dCW+dColumnWidthAr[4]*0.5), _XW, _YW, 0, 0);		dCW+=dColumnWidthAr[4];
	dp.draw( sWallNailing[i], ptTxt + _XW * (dCW+dColumnWidthAr[5]*0.5), _XW, _YW, 0, 0);		dCW+=dColumnWidthAr[5];
	//dpHeader.draw(nQty[i], ptTxt + _XW * 5.5 * dColumnWidth, _XW, _YW, 0, 0);
	//dpHeader.draw(sDescription[i], ptTxt + _XW * 5.5 * dColumnWidth, _XW, _YW, 0, 0);
	
	//Transform row border and Increase row-index
	plRowBorder.transformBy(-_YW * dRowHeight);
	nRowIndex++;
	
	//Border of last row
	if( nRowIndex > 0 ){
		dpLine.draw(PLine(ptOrgTable - _YW * nRowIndex * dRowHeight, ptOrgTable - _YW * nRowIndex * dRowHeight + _XW * dColumnWidth));
	}
}

//assignToElementFloorGroup(_Element[0], TRUE, 0, 'I');















#End
#BeginThumbnail




#End
