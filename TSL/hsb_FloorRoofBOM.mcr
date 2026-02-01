#Version 8
#BeginDescription
Creates a BOM of the beams and sheeting that are attach to the roof/floor and categorize them in groups.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 12.05.2010 - version 1.0

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
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2009 by
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
* date: 28.08.2009
* version 1.0: Release Version 
*
* date: 01.09.2009
* version 1.1: Order reset to include Locating plate 
*
* date: 14.09.2009
* version 1.2: Add the option to filter materials
*
* date: 01.10.2009
* version 1.3: Sort the timbers by length and height
*
* date: 29.10.2009
* version 1.4: Add the Grade Column
*/

int nLunit = 2; // architectural (only used for beam length, others depend on hsb_settings)
int nPrec = 0; // precision (only used for beam length, others depend on hsb_settings)

Unit(1,"mm"); // script uses mm

PropString sDimStyle(0,_DimStyles, "Dim Style");
//PropString propHeader(1,"Text can be changed in the OPM","Table header");
PropInt nColor(0,3,"Color");

PropString strMaterial (1,"",T("Materials to exclude from the BOM"));
strMaterial.setDescription(T("Please fill the materials that you dont need to be list on the BOM, use ';' if you want to filter more that 1 material"));


String sArrMaterials[0];
String sExtType=strMaterial;
sExtType.trimLeft();
sExtType.trimRight();
sExtType=sExtType+";";
for (int i=0; i<sExtType.length(); i++)
{
	String str=sExtType.token(i);
	str.trimLeft();
	str.trimRight();
	str.makeUpper();
	if (str.length()>0)
		sArrMaterials.append(str);
}



if (_bOnInsert)
{
	_Pt0 = getPoint("Pick the Insertion Point"); // select point
	Viewport vp = getViewport("Select the viewport from which the element is taken"); // select viewport
	_Viewport.append(vp);
	return;
}

double dOffset=U(3);

int nBeamType[0];
int nLevel[0];

nBeamType.append(_kSFJackOverOpening);			nLevel.append(3);
nBeamType.append(_kSFJackUnderOpening);			nLevel.append(3);
nBeamType.append(_kCrippleStud);						nLevel.append(3);
nBeamType.append(_kSFTransom);						nLevel.append(4);
nBeamType.append(_kKingStud);							nLevel.append(3);
nBeamType.append(_kSill);								nLevel.append(4);
nBeamType.append(_kSFAngledTPLeft);					nLevel.append(2);
nBeamType.append(_kSFAngledTPRight);				nLevel.append(2);
nBeamType.append(_kSFBlocking);						nLevel.append(6);
nBeamType.append(_kSFSupportingBeam);				nLevel.append(3);
nBeamType.append(_kStud);								nLevel.append(3);
nBeamType.append(_kSFStudLeft);						nLevel.append(3);
nBeamType.append(_kSFStudRight);						nLevel.append(3);
nBeamType.append(_kSFTopPlate);						nLevel.append(2);
nBeamType.append(_kSFBottomPlate);					nLevel.append(1);
nBeamType.append(_kHeader);							nLevel.append(5);
nBeamType.append(_kLocatingPlate);					nLevel.append(0);
nBeamType.append(_kTypeNotSet);						nLevel.append(6);


int nBeamTypeToAvoid[0];
nBeamTypeToAvoid.append(_kBlocking);


String sLevelName[0];
sLevelName.append("Locating Plate"); //0
sLevelName.append("Bottom Plate"); //1
sLevelName.append("Top Plate"); //2
sLevelName.append("Stud"); //3
sLevelName.append("Transom"); //4
sLevelName.append("Lintel"); //5
sLevelName.append("Blocking"); //6
sLevelName.append("Generic");//Generic should be always the last one in this array

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));

Display dp(nColor); // use color of entity for frame
dp.dimStyle(sDimStyle); // dimstyle was adjusted for display in paper space, sets textHeight

// do something for the last appended viewport only
if (_Viewport.length()==0) return; // _Viewport array has some elements
Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;


CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
Element el = vp.element();

Beam bmAll[]=el.beam();

Map mpBeams;

for (int i=0; i<bmAll.length(); i++)
{
	Beam bm=bmAll[i];
	int nBmType=bm.type();
	
	int nAvoid=nBeamTypeToAvoid.find(nBmType, -1);
	if (nAvoid!=-1)
		continue;
	
	int nLocation=nBeamType.find(nBmType, -1);
	if (nLocation!=-1)
	{
		//It's one of the groups from above
		int nLevelValue=nLevel[nLocation];
		String sBeamCategory=sLevelName[nLevelValue];
		mpBeams.appendEntity(sBeamCategory, bm);
		
		
	}
	else
	{
		//Generic Beam
		mpBeams.appendEntity("Generic", bm);
	}
}

Point3d ptDraw=_Pt0;
String sTitle="Prefabricated Cuts";
double dTxtH=dp.textHeightForStyle(sTitle, sDimStyle);
dp.draw(sTitle,ptDraw,_XW,_YW,1,-1);
ptDraw=ptDraw-_YW*(dTxtH*1.5);


for (int t=0; t<sLevelName.length(); t++)
{
	String sGroupName=sLevelName[t];
	Beam arBeam[0];

	// build lists of items to display
	int nNum = 0; // number of different items; make sure nNum is always the size of the arrays
	int arCount[0]; // counter of equal

	String arPos[0]; // posnum
	String arW[0]; // width
	String arH[0]; // height
	String arL[0]; // length or height
	double arDLength[0];
	String arCN[0];
	String arCP[0];
	String arMaterial[0];
	String arGrade[0];
	
	double dTxtLCount=0;
	double dTxtLPos=0;
	double dTxtLW=0;
	double dTxtLL=0;
	double dTxtLCN=0;
	double dTxtLMaterial=0;
	double dTxtLGrade=0;
	
	int j;

	for (int m=0; m<mpBeams.length(); m++)
	{
		if (mpBeams.keyAt(m)==sGroupName)
		{
			Entity ent=mpBeams.getEntity(m);
			Beam bmFromMp=(Beam) ent;
			if (bmFromMp.bIsValid())
				arBeam.append(bmFromMp);
			
		}
	}// End Map Beams Loop
	
	//reportNotice("\n"+sGroupName+" "+arBeam.length());
	
	for (int i=0; i<arBeam.length(); i++)
	{
		// loop over list items
		int bNew = TRUE;
		Beam bm = arBeam[i];
		for (int l=0; l<nNum; l++)
		{
			String strPos = String(bm.posnum());
			if (strPos=="-1") strPos = "";

			String strLength; strLength.formatUnit(bm.solidLength(),nLunit,nPrec);
			String strWidth; strWidth.formatUnit(bm.dW(),sDimStyle);
			String strHeight; strHeight.formatUnit(bm.dH(),sDimStyle);
			if ( (strHeight==arH[l]) && (strPos==arPos[l]) && (strWidth==arW[l]) && (strLength==arL[l]))
			{
				bNew = FALSE;
				arCount[l]++;
				j = l;
				break; // out of inner for loop, we have found the equal one
			}
		}
		if (bNew)
		{ // a new item for the list is found
			String strPos = String(bm.posnum());
			if (strPos=="-1") strPos = "";

			j = nNum;
			double dLength1=bm.solidLength();
			String strLength; strLength.formatUnit(dLength1, nLunit, nPrec);
			String strWidth; strWidth.formatUnit(bm.dW(), sDimStyle);
			String strHeight; strHeight.formatUnit(bm.dH(), sDimStyle);
			arCount.append(1);
			arW.append(strWidth);
			arL.append(strLength);
			arDLength.append(dLength1);
			arPos.append(strPos);
			arH.append(strHeight);
			arCN.append(bm.strCutN());
			arCP.append(bm.strCutP());
			arMaterial.append(bm.material());
			arGrade.append(bm.grade());

			//Check the space needed for the table
			double dAux=dp.textLengthForStyle("Amount", sDimStyle);
			if (dTxtLCount < dAux)
				dTxtLCount = dAux;
				
			dAux=dp.textLengthForStyle(strPos, sDimStyle);
			if (dTxtLPos < dAux)
				dTxtLPos= dAux;
				
			dAux=dp.textLengthForStyle(strWidth+ " x " +strHeight, sDimStyle);
			if (dTxtLW < dAux)
				dTxtLW= dAux;

			dAux=dp.textLengthForStyle(strLength, sDimStyle);
			if (dTxtLL< dAux)
				dTxtLL= dAux;
				
			dAux=dp.textLengthForStyle(bm.strCutN()+" - "+bm.strCutP(), sDimStyle);
			if (dTxtLCN< dAux)
				dTxtLCN= dAux;
			
			dAux=dp.textLengthForStyle(bm.material(), sDimStyle);
			if (dTxtLMaterial < dAux)
				dTxtLMaterial= dAux;
			
			dAux=dp.textLengthForStyle(bm.grade(), sDimStyle);
			if (dTxtLGrade < dAux)
				dTxtLGrade= dAux;

			nNum++;
		}
	}	
	
	if (arBeam.length()>0)
	{
		//The information of that Group is ready to display
		//Display the Title of the Group
		dp.draw(sGroupName,ptDraw,_XW,_YW,1,-1);
		ptDraw=ptDraw-_YW*(dTxtH*1.5);
		Point3d ptBaseLine=ptDraw;
		//Check if the title is not bigger than the text on the columns
		
		double dAux=dp.textLengthForStyle("Ref", sDimStyle);
		if (dTxtLPos < dAux)
			dTxtLPos= dAux;
		
		dAux=dp.textLengthForStyle("Dimension", sDimStyle);
		if ( (dTxtLW) < dAux)
			dTxtLW= dAux;

		dAux=dp.textLengthForStyle("Length", sDimStyle);
		if (dTxtLL< dAux)
			dTxtLL= dAux;
		
		dAux=dp.textLengthForStyle("Angle", sDimStyle);
		if (dTxtLCN< dAux)
			dTxtLCN= dAux;

		//Display the Title of each column
		dp.draw("Ref",ptBaseLine,_XW,_YW,1,-1);
		ptBaseLine=ptBaseLine+_XW*(dTxtLPos+U(dOffset));

		dp.draw("Dimension",ptBaseLine,_XW,_YW,1,-1);
		ptBaseLine=ptBaseLine+_XW*(dTxtLW+U(dOffset));

		dp.draw("Length",ptBaseLine,_XW,_YW,1,-1);
		ptBaseLine=ptBaseLine+_XW*(dTxtLL+U(dOffset));
		
		dp.draw("Angle",ptBaseLine+_XW*(dTxtLCN*0.4),_XW,_YW,1,-1);
		ptBaseLine=ptBaseLine+_XW*(dTxtLCN+U(dOffset));

		dp.draw("Amount",ptBaseLine,_XW,_YW,1,-1);
		ptBaseLine=ptBaseLine+_XW*(dTxtLCount+U(dOffset));
		
		dp.draw("Material",ptBaseLine,_XW,_YW,1,-1);
		ptBaseLine=ptBaseLine+_XW*(dTxtLMaterial+U(dOffset));

		dp.draw("Grade",ptBaseLine,_XW,_YW,1,-1);
		ptBaseLine=ptBaseLine+_XW*(dTxtLGrade+U(dOffset));

		ptDraw=ptDraw-_YW*(dTxtH*1.5);
				
		//Sort the Arrays to Display
		
		int nNrOfRows=arPos.length();
		int bAscending=TRUE;
		
		for(int s1=1; s1<nNrOfRows; s1++)
		{
			int s11 = s1;
			for(int s2=s1-1; s2>=0; s2--)
			{
				int bSort = arDLength[s11] > arDLength[s2];
				if( bAscending )
				{
					bSort = arDLength[s11] < arDLength[s2];
				}
				if( bSort )
				{
					arPos.swap(s2, s11);
					arW.swap(s2, s11);
					arH.swap(s2, s11);
					arL.swap(s2, s11);
					arDLength.swap(s2, s11);
					arCN.swap(s2, s11);
					arCP.swap(s2, s11);
					arCount.swap(s2, s11);
					arMaterial.swap(s2, s11);
					arGrade.swap(s2, s11);
		
					s11=s2;
				}
			}
		}
		
		
		for(int s1=1; s1<nNrOfRows; s1++)
		{
			int s11 = s1;
			for(int s2=s1-1; s2>=0; s2--)
			{
				int bSort = arH[s11] < arH[s2];
				if( bAscending )
				{
					bSort = arH[s11] > arH[s2];
				}
				if( bSort )
				{
					arPos.swap(s2, s11);
					arW.swap(s2, s11);
					arH.swap(s2, s11);
					arL.swap(s2, s11);
					arDLength.swap(s2, s11);
					arCN.swap(s2, s11);
					arCP.swap(s2, s11);
					arCount.swap(s2, s11);
					arMaterial.swap(s2, s11);
					arGrade.swap(s2, s11);

					s11=s2;
				}
			}
		}
		//End of the sorting
		
		
		
		for (int d=0; d<arPos.length(); d++)
		{
			ptBaseLine=ptDraw;

			//Display the Values of each row
			dp.draw(arPos[d],ptBaseLine,_XW,_YW,1,-1);//+_XW*(dTxtLPos*.3)
			ptBaseLine=ptBaseLine+_XW*(dTxtLPos+U(dOffset));
	
			dp.draw(arW[d]+" x "+arH[d],ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLW+U(dOffset));
	
			dp.draw(arL[d],ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLL+U(dOffset));
	
			dp.draw(arCN[d]+" - "+arCP[d],ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLCN+U(dOffset));
	
			dp.draw(arCount[d],ptBaseLine+_XW*(dTxtLCount*.45),_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLCount+U(dOffset));
	
			dp.draw(arMaterial[d],ptBaseLine,_XW,_YW,1,-1);//+_XW*(dTxtLGrade*.45)
			ptBaseLine=ptBaseLine+_XW*(dTxtLMaterial+U(dOffset));
			
			dp.draw(arGrade[d],ptBaseLine,_XW,_YW,1,-1);//+_XW*(dTxtLGrade*.45)
			ptBaseLine=ptBaseLine+_XW*(dTxtLGrade+U(dOffset));

			ptDraw=ptDraw-_YW*(dTxtH*1.5);

		}
		ptDraw=ptDraw-_YW*(dTxtH*1.5);
		
	}
}//End loop throw all levels

//BOM for Sheetings
Sheet shAll[]=el.sheet();

Map mpSheet;

String strSheetNames[0];
for (int i=0; i<shAll.length(); i++)
{
	Sheet sh=shAll[i];
	String sName=sh.name();
	String sMaterial=sh.material();
	sMaterial.makeUpper();
	int nLocation=strSheetNames.find(sName, -1);
	if (sArrMaterials.find(sMaterial, -1)==-1)//Filter the material Names
	{
		if (nLocation==-1)
		{
			strSheetNames.append(sName);
		}
	}
}

sTitle="Wallboard";
dp.draw(sTitle,ptDraw,_XW,_YW,1,-1);
ptDraw=ptDraw-_YW*(dTxtH*1.5);


for (int t=0; t<strSheetNames.length(); t++)
{
	String sGroupName=strSheetNames[t];
	Sheet arSheet[0];

	// build lists of items to display
	int nNum = 0; // number of different items; make sure nNum is always the size of the arrays
	int arCount[0]; // counter of equal

	String arPos[0]; // posnum
	String arW[0]; // width
	String arT[0]; // thickness
	String arL[0]; // length or height
	
	double dTxtLCount=0;
	double dTxtLPos=0;
	double dTxtLW=0;
	double dTxtLT=0;

	
	int j;

	for (int m=0; m<shAll.length(); m++)
	{
		if (shAll[m].name()==sGroupName)
		{
			arSheet.append(shAll[m]);
		}
	}// End Map Beams Loop
	
	//reportNotice("\n"+sGroupName+" "+arSheet.length());
	
	for (int i=0; i<arSheet.length(); i++)
	{
		// loop over list items
		int bNew = TRUE;
		Sheet sh = arSheet[i];
		for (int l=0; l<nNum; l++)
		{
			String strPos = String(sh.posnum());
			if (strPos=="-1") strPos = "";

			String strLength; strLength.formatUnit(sh.dL(),nLunit,nPrec);
			String strWidth; strWidth.formatUnit(sh.dW(),sDimStyle);
			String strThick; strThick.formatUnit(sh.dH(),sDimStyle);
			if ( (strThick==arT[l]) && (strPos==arPos[l]) && (strWidth==arW[l]) && (strLength==arL[l]))
			{
				bNew = FALSE;
				arCount[l]++;
				j = l;
				break; // out of inner for loop, we have found the equal one
			}
		}
		if (bNew)
		{ // a new item for the list is found
			String strPos = String(sh.posnum());
			if (strPos=="-1") strPos = "";

			j = nNum;
			
			String strLength; strLength.formatUnit(sh.dL(),nLunit,nPrec);
			String strWidth; strWidth.formatUnit(sh.dW(),sDimStyle);
			String strThick; strThick.formatUnit(sh.dH(),sDimStyle);
			arCount.append(1);
			arW.append(strWidth);
			arL.append(strLength);
			arPos.append(strPos);
			arT.append(strThick);

			//Check the space needed for the table
			double dAux=dp.textLengthForStyle("Amount", sDimStyle);
			if (dTxtLCount < dAux)
				dTxtLCount = dAux;
			dAux=dp.textLengthForStyle(strPos, sDimStyle);
			if (dTxtLPos < dAux)
				dTxtLPos= dAux;
			dAux=dp.textLengthForStyle(strWidth+ " x " +strLength, sDimStyle);
			if (dTxtLW < dAux)
				dTxtLW= dAux;

			dAux=dp.textLengthForStyle(strThick, sDimStyle);
			if (dTxtLT< dAux)
				dTxtLT= dAux;

			nNum++;
		}
	}	
	
	if (arSheet.length()>0)
	{
		//The information of that Group is ready to display
		//Display the Title of the Group
		dp.draw(sGroupName,ptDraw,_XW,_YW,1,-1);
		ptDraw=ptDraw-_YW*(dTxtH*1.5);
		Point3d ptBaseLine=ptDraw;
		//Check if the title is not bigger than the text on the columns
		
		double dAux=dp.textLengthForStyle("Ref", sDimStyle);
		if (dTxtLPos < dAux)
			dTxtLPos= dAux;
		
		dAux=dp.textLengthForStyle("Dimension", sDimStyle);
		if ( (dTxtLW) < dAux)
			dTxtLW= dAux;

		dAux=dp.textLengthForStyle("Thickness", sDimStyle);
		if (dTxtLT< dAux)
			dTxtLT= dAux;
		

		//Display the Title of each column
		dp.draw("Ref",ptBaseLine,_XW,_YW,1,-1);
		ptBaseLine=ptBaseLine+_XW*(dTxtLPos+U(dOffset));

		dp.draw("Dimension",ptBaseLine,_XW,_YW,1,-1);
		ptBaseLine=ptBaseLine+_XW*(dTxtLW+U(dOffset));

		dp.draw("Thickness",ptBaseLine,_XW,_YW,1,-1);
		ptBaseLine=ptBaseLine+_XW*(dTxtLT+U(dOffset));
		

		dp.draw("Amount",ptBaseLine,_XW,_YW,1,-1);
		ptBaseLine=ptBaseLine+_XW*(dTxtLCount+U(dOffset));

		ptDraw=ptDraw-_YW*(dTxtH*1.5);
				
		for (int d=0; d<arPos.length(); d++)
		{
			ptBaseLine=ptDraw;

			//Display the Values of each row
			dp.draw(arPos[d],ptBaseLine+_XW*(dTxtLPos*.3),_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLPos+U(dOffset));
	
			dp.draw(arW[d]+" x "+arL[d],ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLW+U(dOffset));
	
			dp.draw(arT[d],ptBaseLine+_XW*(dTxtLT*.45),_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLT+U(dOffset));
			
	
			dp.draw(arCount[d],ptBaseLine+_XW*(dTxtLCount*.45),_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLCount+U(dOffset));
	
			ptDraw=ptDraw-_YW*(dTxtH*1.5);

		}
		ptDraw=ptDraw-_YW*(dTxtH*1.5);
		
	}
}//End loop throw all levels






























#End
#BeginThumbnail

#End
