#Version 8
#BeginDescription
v0.7: 03.nov.2013: David Rueda (dr@hsb-cad.com)
Places opening guards on every opening of selected wall(s)

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 7
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
* v0.7: 03.nov.2013: David Rueda (dr@hsb-cad.com)
	- Stickframe path added to mapIn when calling dll
* v0.6: 21.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
* v0.5: 13.ago.2012: David Rueda (dr@hsb-cad.com)
	- Set type kSupportingCrossBeam to created beams
	- Module property of blocks set from opening module
	- Information property of blocks will be filled only if user specifically defines it (manually)
* v0.4: 14.mar.2012: David Rueda (dr@hsb-cad.com)
	- Lumber item info pulled from inventory
	- Set dependency of tsl to element
	- Assigned tsl to element group
	- Display added
	- Tsl now can be added as plugin to wall definition
	- Beam color set by custom or assembly values
*v0.3 Will erase existing beam if manually inserted. hsbIds are 776, 777 and 778.
*v0.2 Small elevation change
*v0.1 Puts guard rails in opes
*/

U(1,"inch");

String sLumberItemKeys[0];
String sLumberItemNames[0];

// Calling dll to fill item lumber prop.
Map mapIn;
Map mapOut;

//Setting info
String sCompanyPath = _kPathHsbCompany;
mapIn.setString("CompanyPath", sCompanyPath);

String sStickFramePath= _kPathHsbWallDetail;
mapIn.setString("StickFramePath", sStickFramePath);

String sInstallationPath			= 	_kPathHsbInstall;
mapIn.setString("InstallationPath", sInstallationPath);

String sAssemblyFolder			=	"\\Utilities\\hsbFramingDefaultsEditor";
String sAssembly					=	"\\hsbFramingDefaults.Inventory.dll";
String sAssemblyPath 			=	sInstallationPath+sAssemblyFolder+sAssembly;
String sNameSpace				=	"hsbSoft.FramingDefaults.Inventory.Interfaces";
String sClass						=	"InventoryAccessInTSL";
String sClassName				=	sNameSpace+"."+sClass;
String sFunction					=	"GetLumberItems";

mapOut = callDotNetFunction2(sAssemblyPath, sClassName, sFunction, mapIn);

// filling lumber items
for( int m=0; m<mapOut.length(); m++)
{
	String sKey= mapOut.keyAt(m);
	String sName= mapOut.getString(sKey+"\NAME");
	if( sKey!="" && sName!="")
	{
		sLumberItemKeys.append( sKey );
		sLumberItemNames.append( sName);
	}
}

String sTab="     ";
// OPM 
PropString sEmpty(0, " ", T("|Blocking info|"));
sEmpty.setReadOnly(true);
	PropString sEmpty1(1, " ", sTab+T("|Auto|"));
	sEmpty1.setReadOnly(true);
	
		PropString sBlockLumberItem(2, sLumberItemNames, sTab+sTab+T("|Lumber item|"),0);

	PropString sEmpty2(3, "If no value is set, values are taken from inventory (one or many). ", sTab+T("|Manual| "));
	sEmpty2.setReadOnly(true);

		double dReal[0];// Real sizes
		String sNominal[0];// Nominal sizes
		dReal.append(U(19.05,0.75));		sNominal.append("1");		//index:	0
		dReal.append(U(38.10,1.50));		sNominal.append("2");		//index:	1
		dReal.append(U(63.50,2.50));		sNominal.append("3");		//index:	2
		dReal.append(U(88.90,3.50));		sNominal.append("4");		//index:	3
		dReal.append(U(139.70,5.50));	sNominal.append("6");		//index:	4
		dReal.append(U(184.15,7.25));	sNominal.append("8");		//index:	5
		dReal.append(U(234.95,9.25));	sNominal.append("10");		//index:	6
		dReal.append(U(285.75,11.25));	sNominal.append("12");		//index:	7
		dReal.append(U(336.55,13.25));	sNominal.append("14");		//index:	8
		dReal.append(U(387.35,15.25));	sNominal.append("16");		//index:	9
		
		//Filling nominal sizes
		String sarBmS[0];//Nominals FOR 2" WIDTH ONLY 
		for(int i=0;i<sNominal.length();i++){
			sarBmS.append("2x"+sNominal[i]);
		}
		sarBmS.append(T("|From inventory|"));

		PropString sBlockSizeOPM(4, sarBmS, sTab+sTab+T("|Beam size|"), sarBmS.length()-1);

		String sBmColorOptions[]={T("|Copy from assembly|"), T("|Custom|")};
		PropString sBmColorOption(5,sBmColorOptions,sTab+sTab+"Blocking color",0);
		int nColorOption=sBmColorOptions.find(sBmColorOption,0);
		
		PropInt nBlockColorOPM(0, 2, sTab+sTab+T("|Custom color|"));
		PropString sBlockNameOPM(6, "", sTab+sTab+T("|Name|"));
		PropString sBlockMaterialOPM(7, "", sTab+sTab+T("|Material|"));
		PropString sBlockGradeOPM(8, "", sTab+sTab+T("|Grade|"));
		PropString sBlockInformationOPM(9, "", sTab+sTab+T("|Information|"));
		PropString sBlockLabelOPM(10, "", sTab+sTab+T("|Label|"));
		PropString sBlockSubLabelOPM(11, "", sTab+sTab+T("|Sublabel|"));
		PropString sBlockSubLabel2OPM(12, "", sTab+sTab+T("|Sublabel2|"));
		PropString sBlockBeamCodeOPM(13, "", sTab+sTab+T("|Beam code|"));

if (_bOnInsert){

	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	PrEntity ssE("\nSelect a set of elements",Element());
			if (ssE.go())
			{
				Entity ents[0]; 
				ents = ssE.set(); 
				// turn the selected set into an array of elements
				for (int i=0; i<ents.length(); i++)
				{
					if (ents[i].bIsKindOf(Wall()))
					{
						_Element.append((Element) ents[i]);
					}
				}
			}
	
	if (_kExecuteKey=="")
	{
		showDialogOnce();
		setCatalogFromPropValues(T("_LastInserted"));
	}
	
	//PREPARE TO CLONING
	// declare tsl props 
	TslInst tsl;
	String sScriptName = scriptName();

	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Beam lstBeams[0];
	Entity lstEnts[1];
	Point3d lstPoints[1];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];

	lstPropString.append(sEmpty);
	lstPropString.append(sEmpty1);
	lstPropString.append(sBlockLumberItem);
	lstPropString.append(sEmpty2);
	lstPropString.append(sBlockSizeOPM);	
	lstPropString.append(sBmColorOption);
	lstPropString.append(sBlockNameOPM);
	lstPropString.append(sBlockMaterialOPM);
	lstPropString.append(sBlockGradeOPM);
	lstPropString.append(sBlockInformationOPM);
	lstPropString.append(sBlockLabelOPM);
	lstPropString.append(sBlockSubLabelOPM);
	lstPropString.append(sBlockSubLabel2OPM);
	lstPropString.append(sBlockBeamCodeOPM);
	lstPropInt.append(nBlockColorOPM);
		
	for(int i=0; i<_Element.length();i++){
		lstEnts[0] = _Element[i];
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
	}
	eraseInstance();
	return;	
	
}//END if (_bOnInsert)

_Map.setInt("ExecutionMode",0);

Element el=_Element0;
if(!el.bIsValid()){
	eraseInstance();
}

setDependencyOnEntity(el);
assignToElementGroup( el, 1, 0, 'Z');

// Getting info from element
CoordSys csEl=el.coordSys();
Vector3d vx=csEl.vecX();
Vector3d vy=csEl.vecY();
Vector3d vz=csEl.vecZ();
Point3d ptOrg=csEl.ptOrg();
_Pt0=ptOrg;

Beam arBmAll[]=el.beam();
Beam arBmHorizontal[]=vy.filterBeamsPerpendicularSort(arBmAll);
Beam arBmVertical[]=vx.filterBeamsPerpendicularSort(arBmAll);
Opening arOpAll[]=el.opening();

// Getting values from selected item lumber for blocking
int nBlockIndex=sLumberItemNames.find(sBlockLumberItem,-1);

// Get props from inventory
String sBlockNameFromInventory, sBlockMaterialFromInventory, sBlockGradeFromInventory;
double dBlockWFromInventory, dBlockHFromInventory;
for( int m=0; m<mapOut.length(); m++)
{
	String sSelectedKey= sLumberItemKeys[nBlockIndex];
	String sKey= mapOut.keyAt(m);
	if( sKey==sSelectedKey)
	{
		sBlockNameFromInventory= mapOut.getString(sKey+"\NAME");
		dBlockWFromInventory= mapOut.getDouble(sKey+"\WIDTH");
		dBlockHFromInventory= mapOut.getDouble(sKey+"\HEIGHT");
		sBlockGradeFromInventory= mapOut.getString(sKey+"\HSB_GRADE");
		sBlockMaterialFromInventory= mapOut.getString(sKey+"\HSB_MATERIAL");
		break;
	}
}

String sBlockMaterial, sBlockGrade;
double dBlockW, dBlockH;
int nSizeIndex=sarBmS.find(sBlockSizeOPM);
if(nSizeIndex==sarBmS.length()-1) // Last value on sarBmS (From inventory)
{
	sBlockMaterial=sBlockMaterialFromInventory;
	sBlockGrade=sBlockGradeFromInventory;
	if(sBlockMaterialOPM!="")
		sBlockMaterial=sBlockMaterialOPM;
	if(sBlockGradeOPM!="")
		sBlockGrade=sBlockGradeOPM;
	dBlockW=dBlockWFromInventory;
	dBlockH=dBlockHFromInventory;
}
else
{
	sBlockMaterial=sBlockMaterialOPM;
	sBlockGrade=sBlockGradeOPM;
	dBlockW=U(38.1, 1.5);
	dBlockH=dReal[nSizeIndex];
}	

String sBlockName=sBlockNameOPM;
String sBlockLabel=sBlockLabelOPM;
String sBlockSubLabel=sBlockSubLabelOPM;
String sBlockSubLabel2=sBlockSubLabel2OPM;
String sBlockBeamCode=sBlockBeamCodeOPM;
//set  information
String sBlockInformation;
if( sBlockInformationOPM!= "")
	sBlockInformation=sBlockInformationOPM;
	
if( !_Map.getInt("ExecutionMode") || _bOnElementConstructed )
{
	
	// Create brace for every opening in element
	for(int o=0;o<arOpAll.length();o++){
		Opening op=arOpAll[o];
		CoordSys csOp=op.coordSys();
		Vector3d vxOp=csOp.vecX();
		Vector3d vyOp=csOp.vecY();
		Vector3d vzOp=csOp.vecZ();
		Point3d ptOrgOp=csOp.ptOrg();
		OpeningSF opSF=(OpeningSF)op;
		
		int bIsMedicalCab=FALSE;
		
		String str1;
		if(opSF.bIsValid()){
			//str1=opSF.descrSF();
			str1=opSF.openingDescr();
			ptOrgOp.transformBy(-el.vecY()*opSF.dGapBottom());
		}
		str1.makeUpper();
	
		String arStr2[]={"CAB","AP"};
		for(int s=0;s<arStr2.length();s++)
		{
			String str2=arStr2[s];
			
			if(str1.find(str2,0)>-1)
			{
				bIsMedicalCab=TRUE;
				break;	
			}
		}
		
		if(bIsMedicalCab)continue;
		
		PlaneProfile ppOpe(op.plShape());
		double dShrink=U(-1.5);
		double dOpeW=op.width();
		if(opSF.bIsValid()){
			dShrink-=opSF.dGapSide();
			dOpeW+=2*opSF.dGapSide();
		}
		ppOpe.shrink(dShrink);
		
		PLine arPlRing[]=ppOpe.allRings();
			
		PLine plOp=arPlRing[0];
		Body bdOp(plOp,el.vecZ()*U(40),0);
		double dDistBase=el.vecY().dotProduct(ptOrgOp-el.ptOrg());
		
		
		//make sure it needs it
		if(dDistBase >= U(40.25))continue;

		int bIsDoor=dDistBase<=U(2)?TRUE:FALSE;
		int bIsDoubled=dOpeW>U(42.875)?TRUE:FALSE;
		int bIsDoubledMid=dOpeW>U(57.125)?TRUE:FALSE;
				
		String strModName="none";
		for(int b=0;b<arBmAll.length();b++){
			if(arBmAll[b].realBody().hasIntersection(bdOp) && arBmAll[b].module().length()>1){
				strModName=arBmAll[b].module();
				break;
			}
		}
		if(strModName=="none"){
			reportMessage("\nTSL "+ scriptName()+" could not find an opening module name on wall " + el.number());
			continue;
		}

		Point3d ptMidOp=csOp.ptOrg()+vxOp*op.width()/2;
		Body bdEdgeFind(ptMidOp+U(4)*vyOp-vxOp*U(200),ptMidOp+U(4)*vyOp+vxOp*U(200),U(4));
		bdEdgeFind.vis(5);
		Beam arBmMod[0];
		Beam arBmEdgePossible[0];
		Point3d arPtBms[0];
	
		for(int b=0;b<arBmAll.length();b++){
			if(arBmAll[b].hsbId()=="777" || arBmAll[b].hsbId()=="778" || arBmAll[b].hsbId()=="776"){
				arBmAll[b].dbErase();
				continue;
			}
			if(arBmAll[b].module()==strModName){
				arBmMod.append(arBmAll[b]);
				arPtBms.append(arBmAll[b].realBody().allVertices());
				if(arBmAll[b].realBody().hasIntersection(bdEdgeFind))arBmEdgePossible.append(arBmAll[b]);
			}
		}
		arPtBms=Line(el.ptOrg(),el.vecY()).orderPoints(arPtBms);
		
		Beam arBmV[]=vxOp.filterBeamsPerpendicularSort(arBmEdgePossible);
		Beam bmLeft,bmRight;
		Point3d arPtExtents[0];
		for(int b=1;b<arBmV.length();b++){
			double dd=vxOp.dotProduct(ptMidOp-arBmV[b].ptCen());
			if(vxOp.dotProduct(ptMidOp-arBmV[b].ptCen())<U(0)){
				bmLeft=arBmV[b-1];
				bmRight=arBmV[b];
				arPtExtents.append(bmLeft.realBody().extremeVertices(vxOp));
				arPtExtents.append(bmRight.realBody().extremeVertices(vxOp));
				break;
			}
		}
		
		if(arPtExtents.length()!=4){
			reportMessage("\nTSL "+ scriptName()+" could not find side studs for an opening on wall " + el.number());
			continue;
		}
		
		arPtExtents=Plane(el.ptOrg(),el.vecY()).projectPoints(arPtExtents);
		double dGuardL=abs(el.vecX().dotProduct(arPtExtents[1]-arPtExtents[2]));
		
		ptMidOp.setToAverage(arPtExtents);
		ptMidOp=ptMidOp.projectPoint(Plane(el.ptOrg()-el.dBeamWidth()*el.vecZ(),el.vecZ()),U(0));	
	
		//Create Beams
		Beam bmNew;
		bmNew.dbCreate(ptMidOp,el.vecX(),el.vecZ(),el.vecY(),dGuardL,dBlockW,dBlockH,0,1,0);
		bmNew.assignToElementGroup( el, true, 0, 'Z');
		bmNew.assignToLayer(bmLeft.layerName());
		_Beam.append( bmNew);
				
		// Setting created beams props.
		// Setting block props
		int nBlockColor;
		if( nColorOption) // Custom
			nBlockColor=nBlockColorOPM;
		else // From assembly
		{
			if( bmLeft.bIsValid())
				nBlockColor=bmLeft.color();
			else
				nBlockColor=nBlockColorOPM;
		}
	
		if (nBlockColor > 255 || nBlockColor < -1) 
			nBlockColor=-1;
			
		bmNew.setColor(nBlockColor);
		bmNew.setName(sBlockName);
		bmNew.setGrade(sBlockGrade);
		bmNew.setMaterial(sBlockMaterial);
		bmNew.setType(_kSupportingCrossBeam);
		bmNew.setInformation(sBlockInformation);
		bmNew.setLabel(sBlockLabel);
		bmNew.setSubLabel(sBlockSubLabel);
		bmNew.setSubLabel2(sBlockSubLabel2);
		bmNew.setBeamCode(sBlockBeamCode);	
		bmNew.setModule(strModName);
		bmNew.setHsbId("777"); //OLDER CODE
		
		if(bIsDoor){
			Beam bm1=bmNew.dbCopy();
			bm1.setHsbId("776");
			_Beam.append( bm1);
			Beam bm2=bmNew.dbCopy();
			_Beam.append( bm2);
			bm1.transformBy(el.vecY()*U(3.25));
			bm2.transformBy(el.vecY()*U(21));
			
			if(bIsDoubledMid){
				Beam bm3=bm2.dbCopy();
				bm3.transformBy(el.vecZ()*U(1.5));
				bm3.setHsbId("778");
				_Beam.append( bm3);
			}
		}
		bmNew.transformBy(el.vecY()*U(42));
		if(bIsDoubled){
			Beam bm=bmNew.dbCopy();
			bm.transformBy(el.vecZ()*U(1.5));
			bm.setHsbId("778");
		}
	}
	
	_Map.setInt("ExecutionMode",1);
}

Display dp(0);
for( int b=0; b< _Beam.length(); b++)
{
	// Display beam's body
	Beam bm= _Beam[b];
	if( !bm.bIsValid())
		continue;
	Plane plnZ( bm.ptCen(), vz);
	PlaneProfile ppBeamSlice= bm.envelopeBody().getSlice( plnZ);
	dp.draw( ppBeamSlice);
	
	//Display cross in beam center
	double dCrL= U(50, 2);
	PLine plCrossBmCenter;
	plCrossBmCenter.addVertex(bm.ptCen());
	plCrossBmCenter.addVertex(bm.ptCen()+vy*dCrL*.5);
	plCrossBmCenter.addVertex(bm.ptCen()-vy*dCrL*.5);
	plCrossBmCenter.addVertex(bm.ptCen());
	plCrossBmCenter.addVertex(bm.ptCen()+vx*dCrL*.5);
	plCrossBmCenter.addVertex(bm.ptCen()-vx*dCrL*.5);
	dp.draw(plCrossBmCenter);

}

return;




#End
#BeginThumbnail
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
6HHHH`****`"BBB@`HHHH`****`/_V8HH
`


#End
