#Version 8
#BeginDescription
v1.4: 03.nov.2013: David Rueda (dr@hsb-cad.com)
GE_TRUSS_GABLE_END_BRACING_DYNAMIC_PROPS
Places gable end bracing on selected TRUSS ENTITY
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
//////////////////////////////////		COPYRIGHT				//////////////////////////////////  
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
* v1.4: 03.nov.2013: David Rueda (dr@hsb-cad.com)
	- Stickframe path added to mapIn when calling dll
* v1.3: 19.mar.2013: David Rueda (dr@hsb-cad.com) 
	- Description updated
* v1.2: 19.ago.2012: David Rueda (dr@hsb-cad.com) 
	- Thumbnail added
* v1.1: 19.jan.2012: David Rueda (dr@hsb-cad.com): 
	- Set _kBrace type to created beams
	- Created beams assigned to same group than truss.
* v1.0: 01.dic.2011: David Rueda (dr@hsb-cad.com): Release

*/
double dTolerance=U(0.01, 0.0004);

if(_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	_Entity.append( getEntity(T("|Select truss|")));
	if(!_Entity[0].bIsKindOf(TrussEntity()))
	{
		reportMessage(T("|No valid truss selected|"));
		eraseInstance();
		return;
	}
	
	_Pt0=getPoint(T("|Pick front side of truss|"));

    	setCatalogFromPropValues(T("_LastInserted"));

	_Map.setInt("ExecutionMode",0);

	return;
}
// End _bOnInsert

//Setting info
String sCompanyPath 			= _kPathHsbCompany;
String sInstallationPath			= _kPathHsbInstall;

String sAssemblyFolder			=	"\\Utilities\\hsbFramingDefaultsEditor";
String sAssembly					=	"\\hsbFramingDefaults.Inventory.dll ";
String sAssemblyPath 			=	sInstallationPath+sAssemblyFolder+sAssembly;
String sNameSpace				=	"hsbSoft.FramingDefaults.Inventory.Interfaces";
String sClass						=	"InventoryAccessInTSL";
String sClassName				=	sNameSpace+"."+sClass;
String sFunction					=	"GetLumberItems";

// Filling lumber items
Map mapIn;
mapIn.setString("CompanyPath", sCompanyPath);
mapIn.setString("InstallationPath", sInstallationPath);
String sStickFramePath= _kPathHsbWallDetail;
mapIn.setString("StickFramePath", sStickFramePath);

String sXMLFileName="GE_TRUSS_GABLE_END_BRACING_CUSTOM_PROPS";

Map mapLumberItems=callDotNetFunction2(sAssemblyPath, sClassName, sFunction, mapIn); // This map to be passed to the next dll, to open gable settings
mapLumberItems.setString("CompanyPath", sCompanyPath);
mapLumberItems.setString("InstallationPath", sInstallationPath);
mapLumberItems.setString("XMLFileName", sXMLFileName);
mapLumberItems.writeToDxxFile("mapLumberItems");

// Get map with gable settings from dll
Map mapSettings;
sAssemblyFolder			=	"\\Utilities\\TslCustomSettings";
sAssembly				=	"\\TSL_Edit_Gable_End_Settings.dll ";
sAssemblyPath 			=	sInstallationPath+sAssemblyFolder+sAssembly;
sNameSpace				=	"TSL_Edit_Gable_End_Settings";
sClass						=	"EditGableEnd";
sClassName				=	sNameSpace+"."+sClass;
sFunction					=	"fnEditGableEndSettings";
mapSettings= callDotNetFunction2(sAssemblyPath, sClassName, sFunction, mapLumberItems);


if(_Map.getInt("ExecutionMode")==0)
{
	if(_Entity.length()==0)
	{
		eraseInstance();
		return;	
	}
	
	TrussEntity teTruss;
	if(_Entity[0].bIsKindOf(TrussEntity()));
		teTruss= (TrussEntity)_Entity[0];
	
	if (!teTruss.bIsValid())
	{
		eraseInstance();
		return;
	}

	String strDefinition = teTruss.definition();
	TrussDefinition trussDefinition(strDefinition);
	CoordSys csTruss= teTruss.coordSys();
	Point3d ptTrussOrg=csTruss.ptOrg();
	Vector3d vTrussX=csTruss.vecX();
	Vector3d vTrussY=csTruss.vecY();
	Vector3d vTrussZ=csTruss.vecZ();
	_Pt0+=vTrussX*vTrussX.dotProduct(ptTrussOrg-_Pt0);

	// Getting COPY of all beams (TO BE ERASED AFTER ALL PROCESS, this will make Beam() functions available)
	Beam bmAllInTruss[]=trussDefinition.beam();
	Beam bmVerticalsBlock[0];
	bmVerticalsBlock=vTrussX.filterBeamsPerpendicularSort(bmAllInTruss);

	for (int b=0; b< bmVerticalsBlock.length(); b++)
	{
		Beam bm=bmVerticalsBlock[b];
		if(!bm.bIsValid())
			continue;

		Body bdBm= bm.realBody();
		if(_Map.getInt("ExecutionMode")==0)
		{
			Beam bmCopy;						// NOTICE: All copies (stored at _Beam) must be erased at the end of tsl process
			bmCopy.dbCreate(bdBm);
			bmCopy.transformBy( csTruss);
			bmCopy.setColor(1);
			_Beam.append(bmCopy); 
		}
	}
				
	Vector3d vFront=vTrussZ; // Pointing back to front of truss
	if(vFront.dotProduct(_Pt0-ptTrussOrg)<0)
		vFront=-vFront;
	_Pt0=ptTrussOrg+vFront*U(50,2);
	
	// _Beam contains all vertical beams to be added a lumber piece
	for(int b=0; b<_Beam.length(); b++)
	{
		Beam bm=_Beam[b];
		Point3d bmCen=bm.ptCen();
		Body bdBm=bm.realBody();
		
		// Get lowest point on top cut on beam
		Vector3d vxBm=bm.vecX();
		if(vxBm.dotProduct(_ZW)<0)
			vxBm=-vxBm; // Making sure it always points UP
		
		Point3d ptSide1=bmCen+vTrussX*(bm.dD(vTrussX)*.5-dTolerance);
		Line lnSide1(ptSide1, -vxBm);
		Point3d ptAllPointsOnSide1[]=bdBm.intersectPoints(lnSide1);
		Point3d ptHighestOnSide1=ptAllPointsOnSide1[0];
		
		Point3d ptSide2=bmCen-vTrussX*(bm.dD(vTrussX)*.5-dTolerance);
		Line lnSide2(ptSide2, -vxBm);
		Point3d ptAllPointsOnSide2[]=bdBm.intersectPoints(lnSide2);
		Point3d ptHighestOnSide2=ptAllPointsOnSide2[0];	
		Vector3d vShortestSide;
		Point3d ptTopLongerSide, ptTopShorterSide;
		if(ptHighestOnSide1.Z()>ptHighestOnSide2.Z())
		{
			vShortestSide=bm.vecD((ptHighestOnSide2-ptHighestOnSide1));
			ptTopLongerSide=ptHighestOnSide1;
			ptTopShorterSide=ptHighestOnSide2;
		}
		else
		{
			vShortestSide=bm.vecD((ptHighestOnSide1-ptHighestOnSide2));
			ptTopLongerSide=ptHighestOnSide2;
			ptTopShorterSide=ptHighestOnSide1;
		}
		
		// Find front point on beam center
		Point3d ptBmFront=bm.ptCen()+bm.vecD(vFront)*bm.dD(vFront)*.5;

		// Define new beams vectors
		Vector3d vBmX=_ZW;
		Vector3d vBmY=vTrussX;
		Vector3d vBmZ=vBmX.crossProduct(vBmY);
		
		// Start cases depending on beam length
		double dL=bm.dL();
		int nOption=-1;
		double dTopGap, dBottomGap, dBmW, dBmH;
		dTopGap=dBottomGap=dBmW=dBmH=0;
		String sBmGrade, sBmMaterial;
		
		// Get info from settings map
		for (int i=0; i<mapSettings.length()-1; i++) 
		{
			String sKey = mapSettings.keyAt(i);
			double dLimit=sKey.atof();
			String sKeyNext= mapSettings.keyAt(i+1);
			double dLimitNext=sKeyNext.atof();
			if( dLimit<dL && dL<= dLimitNext) // Lenght is in this range
			{
				nOption=mapSettings.getInt(sKeyNext+"\CONNECTION_TYPE");
				if(nOption>=0)
				{
					dTopGap=(mapSettings.getDouble(sKeyNext+"\TOP_OFFSET"))*25.4;
					dBottomGap=mapSettings.getDouble(sKeyNext+"\BOTTOM_OFFSET")*25.4;
					dBmW=mapSettings.getDouble(sKeyNext+"\WIDTH")*25.4;
					dBmH=mapSettings.getDouble(sKeyNext+"\HEIGHT")*25.4;
					sBmGrade=mapSettings.getString(sKeyNext+"\MATERIAL");
					sBmMaterial=mapSettings.getString(sKeyNext+"\GRADE");
				}
			}
		}

		String sKey = mapSettings.keyAt(0);
		double dLimit=sKey.atof();
		if( dL< dLimit) // Lenght is in this range
		{
			nOption=mapSettings.getInt(sKey+"\CONNECTION_TYPE");
			if(nOption>=0)
			{
				dTopGap=(mapSettings.getDouble(sKey+"\TOP_OFFSET"))*25.4;
				dBottomGap=mapSettings.getDouble(sKey+"\BOTTOM_OFFSET")*25.4;
				dBmW=mapSettings.getDouble(sKey+"\WIDTH")*25.4;
				dBmH=mapSettings.getDouble(sKey+"\HEIGHT")*25.4;
				sBmGrade=mapSettings.getString(sKey+"\MATERIAL");
				sBmMaterial=mapSettings.getString(sKey+"\GRADE");
			}
		}
		
		if(nOption<0)
			continue;

		// Define cuts
		Cut ctTopOnShorterSide(ptTopShorterSide-_ZW*dTopGap, _ZW);
		Cut ctTopOnLongerSide(ptTopLongerSide-_ZW*dTopGap, _ZW);
		Cut ctBottom(bm.ptCen()-_ZW*(bm.dL()*.5-dBottomGap), -_ZW);
		

		Point3d ptCen=ptBmFront;

		if (nOption==0) // SINGLE L
		{
			// Place a beam at shortest side of beam with "L" connection on front of gable web
			// Realign center to back of truss
			ptCen-=vFront*dBmH*.5;
			ptCen+=vShortestSide*(bm.dD(vShortestSide)*.5+dBmW*.5);
			if(_Map.getInt("ExecutionMode")==0)
			{	
				Beam bmNew; 
				bmNew.dbCreate(ptCen, vBmX, vBmY, vBmZ, U(25,1), dBmW, dBmH, 0,0,0);
				bmNew.addToolStatic(ctTopOnShorterSide,1);
				bmNew.addToolStatic(ctBottom,1);
				bmNew.setGrade(sBmGrade);
				bmNew.setMaterial(sBmMaterial);
				bmNew.setColor(32);
				bmNew.setType(_kBrace);
				bmNew.assignToGroups(teTruss);
			}
		}
		
		else if (nOption==1) // SINGLE T
		{
			// Place a beam at center line on back of beam with "T" connection
			ptCen-=vFront*(dBmH*.5+bm.dD(vFront));
			if(_Map.getInt("ExecutionMode")==0)
			{	
				Beam bmNew; 
				bmNew.dbCreate(ptCen, vBmX, vBmY, vBmZ, U(25,1), dBmW, dBmH, 0,0,0);
				bmNew.addToolStatic(ctTopOnShorterSide,1);
				bmNew.addToolStatic(ctBottom,1);
				bmNew.setGrade(sBmGrade);
				bmNew.setMaterial(sBmMaterial);
				bmNew.setColor(32);
				bmNew.setType(_kBrace);
				bmNew.assignToGroups(teTruss);
			}
		}

		else if (nOption==2) // DOUBLE L 
		{
			// Place a beam to each side of beam with "L" connection on front of gable web
			// At shortest side
			// Realign center to back of truss
			ptCen-=vFront*dBmH*.5;
			ptCen+=vShortestSide*(bm.dD(vShortestSide)*.5+dBmW*.5);
			if(_Map.getInt("ExecutionMode")==0)
			{	
				Beam bmNew; 
				bmNew.dbCreate(ptCen, vBmX, vBmY, vBmZ, U(25,1), dBmW, dBmH, 0,0,0);
				bmNew.addToolStatic(ctTopOnShorterSide,1);
				bmNew.addToolStatic(ctBottom,1);
				bmNew.setGrade(sBmGrade);
				bmNew.setMaterial(sBmMaterial);
				bmNew.setColor(32);
				bmNew.setType(_kBrace);
				bmNew.assignToGroups(teTruss);
			}
			// At longest side (other side if same height)
			// Realign center to back of truss
			ptCen=ptBmFront;
			ptCen-=vFront*dBmH*.5;
			ptCen-=vShortestSide*(bm.dD(vShortestSide)*.5+dBmW*.5);
			if(_Map.getInt("ExecutionMode")==0)
			{	
				Beam bmNew2; 
				bmNew2.dbCreate(ptCen, vBmX, vBmY, vBmZ, U(25,1), dBmW, dBmH, 0,0,0);
				bmNew2.addToolStatic(ctTopOnLongerSide,1);
				bmNew2.addToolStatic(ctBottom,1);
				bmNew2.setGrade(sBmGrade);
				bmNew2.setMaterial(sBmMaterial);
				bmNew2.setColor(32);					
				bmNew2.setType(_kBrace);
				bmNew2.assignToGroups(teTruss);
			}
		}

		else if (nOption==3) // DOUBLE T
		{
			// Place 2 beams at sides on back of beam with "T" connection
			// At shortest side
			ptCen=ptBmFront-vFront*bm.dD(vFront);
			ptCen-=vFront*dBmH*.5;
			ptCen+=vShortestSide*(bm.dD(vShortestSide)*.5-dBmW*.5);
			if(_Map.getInt("ExecutionMode")==0)
			{	
				Beam bmNew; 
				bmNew.dbCreate(ptCen, vBmX, vBmY, vBmZ, U(25,1), dBmW, dBmH, 0,0,0);
				bmNew.addToolStatic(ctTopOnShorterSide,1);
				bmNew.addToolStatic(ctBottom,1);
				bmNew.setGrade(sBmGrade);
				bmNew.setMaterial(sBmMaterial);
				bmNew.setColor(32);
				bmNew.setType(_kBrace);
				bmNew.assignToGroups(teTruss);
			}
			// At longest side (other side if same height)
			// Realign center to back of truss
			ptCen=ptBmFront-vFront*bm.dD(vFront);
			ptCen-=vFront*dBmH*.5;
			ptCen-=vShortestSide*(bm.dD(vShortestSide)*.5-dBmW*.5);
			if(_Map.getInt("ExecutionMode")==0)
			{	
				Beam bmNew2; 
				bmNew2.dbCreate(ptCen, vBmX, vBmY, vBmZ, U(25,1), dBmW, dBmH, 0,0,0);
				bmNew2.addToolStatic(ctTopOnLongerSide,1);
				bmNew2.addToolStatic(ctBottom,1);
				bmNew2.setGrade(sBmGrade);
				bmNew2.setMaterial(sBmMaterial);
				bmNew2.setColor(32);					
				bmNew2.setType(_kBrace);
				bmNew2.assignToGroups(teTruss);
			}
		}
	}
	
	for(int b=0; b<_Beam.length(); b++)
		_Beam[b].dbErase();

	_Map.setInt("ExecutionMode",1);
}

eraseInstance();
return;






#End
#BeginThumbnail
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
(FHY@4'<__]F_
`


#End
