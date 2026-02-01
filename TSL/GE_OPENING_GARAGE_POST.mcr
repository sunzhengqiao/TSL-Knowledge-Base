#Version 8
#BeginDescription
v1.6: 03.nov.2013: David Rueda (dr@hsb-cad.com)
Places head (full or split), side and mid posts around selected opening



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
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
* v1.6: 03.nov.2013: David Rueda (dr@hsb-cad.com)
	- Stickframe path added to mapIn when calling dll
* v1.5: 25.apr.2013: David Rueda (dr@hsb-cad.com)
	- Beam material and grade taken in correct format directly from defaults editor (avoid to combine material!grade!treatment within TSL)
	- Beam name prop not assigned anymore
* v1.4: 22.jun.2012: David Rueda (dr@hsb-cad.com)
	- Thumbnail updated
* v1.3: 20.jun.2012: David Rueda (dr@hsb-cad.com)
	- Added choice to split head post (yes/no) and set mid post length to contact opening top (when head post is split) or head post (when head post is not split)
	- Tsl will automatically recalculate itself when any property is changed (Saving to the user the calling to recalculate)
	- Set default value (#32) for color on beams when not valid value is set
 	- Description added
	- Thumbnail added
* v1.2: 02.may.2012: David Rueda (dr@hsb-cad.com)
	- Bugfix on selection of opening instance and filtering valid instance of it
	- Stop exporting GARAGEPOSTFILE.dxx file
* v1.1: 02.ago.2011: David Rueda (dr@hsb-cad.com): 
	- Changed beam configuration, and relationship with containing element: framing will be on oustider group.
* v1.0: 27.jul.2011: David Rueda (dr@hsb-cad.com): 
	- Release
*/

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
	
String arBmTypes[0];
arBmTypes.append(_BeamTypes);

String sNoYes[]={T("|No|"), T("|Yes|")};
String sFrontBack[]={T("|Front|"), T("|Back|")};
PropString sSide( 0, sFrontBack, T("|Side of wall to frame|"));
int nSide= sFrontBack.find( sSide, 0);

PropString sEmpty1( 1, " ", T("|SIDE POST INFO|"));
sEmpty1.setReadOnly(true);
PropString sSidePostLumberItem(2, sLumberItemNames, T("|Lumber item|"),0);
PropInt nSidePostColor(0, 32, T("|Beam color|"));
PropString sSidePostType( 3, arBmTypes, T("|Beam type|"),12);
PropString sSidePostInformation( 4, "", T("|Information|"));
PropString sSidePostLabel( 5, "", T("|Label|"));
PropString sSidePostSubLabel( 6, "", T("|Sublabel|"));
PropString sSidePostSubLabel2( 7, "", T("|Sublabel2|"));
PropString sSidePostBeamCode( 8, "", T("|Beam code|"));

PropString sEmpty2( 9, "  ", T("|MID POST INFO|"));
sEmpty2.setReadOnly(true);
PropString sMidPostLumberItem(10, sLumberItemNames, T("|Lumber item| "),0);
PropInt nMidPostColor(1, 32, T("|Beam color| "));
PropString sMidPostType(11, arBmTypes, T("|Beam type| "),12);
PropString sMidPostInformation(12, "", T("|Information| "));
PropString sMidPostLabel(13, "", T("|Label| "));
PropString sMidPostSubLabel(14, "", T("|Sublabel| "));
PropString sMidPostSubLabel2(15, "", T("|Sublabel2| "));
PropString sMidPostBeamCode(16, "", T("|Beam code| "));

PropString sEmpty3(17, "   ", T("|HEAD POST INFO|"));
sEmpty3.setReadOnly(true);
PropString sHeadPostLumberItem(18, sLumberItemNames, T("|Lumber item|  "),0);
PropInt nHeadPostColor(2, 32, T("|Beam color|  "));
PropString sHeadPostType(19, arBmTypes, T("|Beam type|  "),12);
PropString sSplitHeader(20, sNoYes, T("|Split at mid post|"),1);
int nSplitHeader=sNoYes.find(sSplitHeader,1);

PropString sHeadPostInformation(21, "", T("|Information|  "));
PropString sHeadPostLabel(22, "", T("|Label|  "));
PropString sHeadPostSubLabel(23, "", T("|Sublabel|  "));
PropString sHeadPostSubLabel2(24, "", T("|Sublabel2|  "));
PropString sHeadPostBeamCode(25, "", T("|Beam code|  "));

PropString sEmpty4(25, "    ", T("|DISPLAY|"));
sEmpty3.setReadOnly(true);
PropDouble dTextHeight(0, U(100,4), "Text height");
PropInt nDisplayColor(3, 2, "Color");

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey); 

_ThisInst.setSequenceNumber(100);

if(_bOnInsert){
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	_Opening.append(getOpening(T("Select garage opening")));
	
	if (_kExecuteKey=="")
		showDialogOnce();
	
	_Map.setInt("ExecutionMode",0);

      setCatalogFromPropValues(T("_LastInserted"));

	return;
}

if( _Opening.length()==0)
{
	eraseInstance();
	return;
}


if( !_Opening[0].bIsValid())
{
	reportMessage("\n" + T("|ERROR|")+": "+T("|not a valid SFOpening|"));
	eraseInstance();
	return;
}
OpeningSF op= (OpeningSF) _Opening[0];

// Get element opening belongs to
Element el0= op.element();
ElementWall el = (ElementWall) el0;

if (!el.bIsValid())
{
	reportMessage("\n" + T("|ERROR|")+": "+T("|Could not find a valid wall element related to this opening|"));
	eraseInstance();
	return;
}

CoordSys csEl=el.coordSys();
Point3d ptElOrg=csEl.ptOrg();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

// Getting values from selected item lumber for SIDE POST
int nSidePostIndex=sLumberItemNames.find(sSidePostLumberItem,-1);
if( nSidePostIndex==-1)
{
	eraseInstance();
	return;	
}

String sSidePostName, sSidePostGrade, sSidePostMaterial;
double dSidePostW, dSidePostH;
for( int m=0; m<mapOut.length(); m++)
{
	String sSelectedKey= sLumberItemKeys[nSidePostIndex];
	String sKey= mapOut.keyAt(m);
	if( sKey==sSelectedKey)
	{
		sSidePostName= mapOut.getString(sKey+"\NAME");
		dSidePostW= mapOut.getDouble(sKey+"\WIDTH");
		dSidePostH= mapOut.getDouble(sKey+"\HEIGHT");reportMessage("\n\nSIDEPOSTH:"+dSidePostH);
		sSidePostGrade= mapOut.getString(sKey+"\HSB_GRADE");
		sSidePostMaterial= mapOut.getString(sKey+"\HSB_MATERIAL");
		break;
	}
}

if( sSidePostName=="" || sSidePostGrade=="" || sSidePostMaterial=="" || dSidePostW==0 || dSidePostH==0)
{
	reportError("\nData incomplete, check values on inventory for selected lumber item"+
		"\nName: "+sSidePostName+"\nMaterial: "+sSidePostMaterial+"\nGrade: "+ sSidePostGrade+"\nWidth: "+ dSidePostW+"\nHeight: "+ dSidePostH);
	eraseInstance();
	return;
}

// Getting values from selected item lumber for MID POST
int nMidPostIndex=sLumberItemNames.find(sMidPostLumberItem,-1);
if( nMidPostIndex==-1)
{
	eraseInstance();
	return;	
}

String sMidPostName, sMidPostGrade, sMidPostMaterial;
double dMidPostW, dMidPostH;
for( int m=0; m<mapOut.length(); m++)
{
	String sSelectedKey= sLumberItemKeys[nMidPostIndex];
	String sKey= mapOut.keyAt(m);
	if( sKey==sSelectedKey)
	{
		sMidPostName= mapOut.getString(sKey+"\NAME");
		dMidPostW= mapOut.getDouble(sKey+"\WIDTH");
		dMidPostH= mapOut.getDouble(sKey+"\HEIGHT");
		sMidPostGrade= mapOut.getString(sKey+"\HSB_GRADE");
		sMidPostMaterial= mapOut.getString(sKey+"\HSB_MATERIAL");
		break;
	}
}

if( sMidPostName=="" || sMidPostGrade=="" || sMidPostMaterial=="" || dMidPostW==0 || dMidPostH==0)
{
	reportError("\nData incomplete, check values on inventory for selected lumber item"+
		"\nName: "+sMidPostName+"\nMaterial: "+sMidPostMaterial+"\nGrade: "+ sMidPostGrade+"\nWidth: "+ dMidPostW+"\nHeight: "+ dMidPostH);
	eraseInstance();
	return;
}

// Getting values from selected item lumber for HEAD POST
int nHeadPostIndex=sLumberItemNames.find(sHeadPostLumberItem,-1);
if( nHeadPostIndex==-1)
{
	eraseInstance();
	return;	
}

String sHeadPostName, sHeadPostGrade, sHeadPostMaterial;
double dHeadPostW, dHeadPostH;
for( int m=0; m<mapOut.length(); m++)
{ 
	String sSelectedKey= sLumberItemKeys[nHeadPostIndex];
	String sKey= mapOut.keyAt(m);
	if( sKey==sSelectedKey)
	{
		sHeadPostName= mapOut.getString(sKey+"\NAME");
		dHeadPostW= mapOut.getDouble(sKey+"\WIDTH");
		dHeadPostH= mapOut.getDouble(sKey+"\HEIGHT");
		sHeadPostGrade= mapOut.getString(sKey+"\HSB_GRADE");
		sHeadPostMaterial= mapOut.getString(sKey+"\HSB_MATERIAL");
		break;
	}
}

if( sHeadPostName=="" || sHeadPostGrade=="" || sHeadPostMaterial=="" || dHeadPostW==0 || dHeadPostH==0)
{
	reportError("\nData incomplete, check values on inventory for selected lumber item"+
		"\nName: "+sHeadPostName+"\nMaterial: "+sHeadPostGrade+"\nGrade: "+ sHeadPostMaterial+"\nWidth: "+ dHeadPostW+"\nHeight: "+ dHeadPostH);
	eraseInstance();
	return;
}


// Get top, left and right points of opening
Body bdOp ( op.plShape(), vz*U(1000, 40), 0);
Point3d ptExtremesOpVy[]= bdOp.extremeVertices(-vy);
Point3d ptOpTop= ptExtremesOpVy[0];
Wall wl= (Wall)el;
Point3d ptElTop= ptElOrg+vy*wl.baseHeight();
Point3d ptExtremesOpVx []= bdOp.extremeVertices(vx);
Point3d ptLeft= ptExtremesOpVx[0]+ vz*( vz.dotProduct(ptElOrg- ptExtremesOpVx[0]) - el.dBeamWidth() * nSide) + vy*vy.dotProduct(ptElTop-ptExtremesOpVx[0]);;
Point3d ptRight= ptExtremesOpVx[ptExtremesOpVx.length()-1] + vz*( vz.dotProduct(ptElOrg- ptExtremesOpVx[ptExtremesOpVx.length()-1]) - el.dBeamWidth() * nSide) + vy*vy.dotProduct(ptElTop-ptExtremesOpVx[ptExtremesOpVx.length()-1]);;

_Pt0= bdOp.ptCen();

Point3d ptMid= ptLeft + vx*vx.dotProduct(ptRight-ptLeft)*.5;
ptMid+= vy*vy.dotProduct(ptOpTop- ptMid) + vz*( vz.dotProduct(ptElOrg- ptMid) - el.dBeamWidth() * nSide);
	
// Ready to create beams
Vector3d vDisplace;
if( nSide==0)
	vDisplace= vz;
else
	vDisplace= -vz;

Beam bmAllCreated[0];

setDependencyOnEntity(el);
_Element.append(el);

if(_Map.getInt("ExecutionMode")==0 || _bOnRecalc || _kNameLastChangedProp!= "" /*ANY PROP*/ ) 
{	
	for( int b=0; b< _Beam.length(); b++)
	{
		_Beam[b].dbErase();	
	}
	
	// SIDE POSTS
	Beam bmCreatedOnSides[0];
	
	Vector3d vBmSideX= vy;
	Vector3d vBmSideY= vDisplace;
	Vector3d vBmSideZ= vBmSideX.crossProduct(vBmSideY);
	double dBmSideL= vy.dotProduct(ptElTop- ptElOrg);
	double dBmSideW= dSidePostW; 
	double dBmSideH= dSidePostH; reportMessage("\n\ndBmSideH:"+dBmSideH);
	Point3d ptBmLeftOrg= ptLeft-vx*dBmSideH*.5+vDisplace*dBmSideW*.5;
	Beam bmLeft; 
	bmLeft.dbCreate( ptBmLeftOrg, vBmSideX, vBmSideY, vBmSideZ, dBmSideL, dBmSideW, dBmSideH, -1, 0, 0);
	bmCreatedOnSides.append(bmLeft);
	_Beam.append(bmLeft);

	// Right side
	Point3d ptBmRightOrg= ptRight+vx*dBmSideH*.5+vDisplace*dBmSideW*.5;
	Beam bmRight;
	bmRight.dbCreate( ptBmRightOrg, vBmSideX, vBmSideY, vBmSideZ, dBmSideL, dBmSideW, dBmSideH, -1, 0, 0);
	bmCreatedOnSides.append(bmRight);
	_Beam.append(bmRight);

	// Setting props on side posts
	if (nSidePostColor> 255 || nSidePostColor< -1) 
		nSidePostColor.set(32);
		
	for( int b=0; b< bmCreatedOnSides.length(); b++)
	{
		Beam bm= bmCreatedOnSides[b];
		bm.setColor(nSidePostColor);
		//bm.setName(sSidePostName); DR: 25.apr.2013
		bm.setGrade(sSidePostGrade);
		bm.setMaterial(sSidePostMaterial);
		bm.setType(arBmTypes.find(sSidePostType,0));
		bm.setInformation(sSidePostInformation);
		bm.setLabel(sSidePostLabel);
		bm.setSubLabel(sSidePostSubLabel);
		bm.setSubLabel2(sSidePostSubLabel2);
		bm.setBeamCode(sSidePostBeamCode);
	}
	
	// HEAD POST
	Vector3d vBmHeadPostX= vx;
	Vector3d vBmHeadPostY= vDisplace;
	Vector3d vBmHeadPostZ= vBmHeadPostX.crossProduct(vBmHeadPostY);
	double dBmHeadPostL= vx.dotProduct(ptRight- ptLeft);
	double dBmHeadPostW= dHeadPostW;
	double dBmHeadPostH= dHeadPostH;
	Point3d ptHeadPostOrg=ptMid+vy*dBmHeadPostH*.5;

	if (nHeadPostColor> 255 || nHeadPostColor< -1) 
		nHeadPostColor.set(32);
		
	Beam bmHeadPost;
	bmHeadPost.dbCreate( ptHeadPostOrg, vBmHeadPostX, vBmHeadPostY, vBmHeadPostZ, dBmHeadPostL, dBmHeadPostW, dBmHeadPostH, 0, 1, 0);
	bmHeadPost.setColor(nHeadPostColor);
	// bmHeadPost.setName(sHeadPostName); DR: 25.apr.2013
	bmHeadPost.setGrade(sHeadPostGrade);
	bmHeadPost.setMaterial(sHeadPostMaterial);
	bmHeadPost.setType(arBmTypes.find(sHeadPostType,0));
	bmHeadPost.setInformation(sHeadPostInformation);
	bmHeadPost.setLabel(sHeadPostLabel);
	bmHeadPost.setSubLabel(sHeadPostSubLabel);
	bmHeadPost.setSubLabel2(sHeadPostSubLabel2);
	bmHeadPost.setBeamCode(sHeadPostBeamCode);
	_Beam.append(bmHeadPost);
	
	// MID POST
	Vector3d vBmMidPostX= vy;
	Vector3d vBmMidPostY= vDisplace;
	Vector3d vBmMidPostZ= vBmMidPostX.crossProduct(vBmMidPostY);
	double dBmMidPostW= dMidPostW;
	double dBmMidPostH= dMidPostH;
	Point3d ptMidPostMidOrg= ptMid+vy*dBmHeadPostH+vDisplace*dBmMidPostW*.5;
	double dBmMidPostL=vy.dotProduct( ptElTop-ptMidPostMidOrg);

	if (nMidPostColor> 255 || nMidPostColor< -1) 
		nMidPostColor.set(32);

	Beam bmMidPost;
	bmMidPost.dbCreate( ptMidPostMidOrg, vBmMidPostX, vBmMidPostY, vBmMidPostZ, dBmMidPostL, dBmMidPostW, dBmMidPostH, 1, 0, 0);
	bmMidPost.setColor(nMidPostColor);
	// bmMidPost.setName(sMidPostName); DR: 25.apr.2013
	bmMidPost.setGrade(sMidPostGrade);
	bmMidPost.setMaterial(sMidPostMaterial);
	bmMidPost.setType(arBmTypes.find(sMidPostType,0));
	bmMidPost.setInformation(sMidPostInformation);
	bmMidPost.setLabel(sMidPostLabel);
	bmMidPost.setSubLabel(sMidPostSubLabel);
	bmMidPost.setSubLabel2(sMidPostSubLabel2);
	bmMidPost.setBeamCode(sMidPostBeamCode);
	_Beam.append(bmMidPost);

	if(nSplitHeader) 
	{
		//Increase mid post length to opening highest point
		Cut ctMid (ptOpTop, -vy);
		bmMidPost.addToolStatic( ctMid, 1);

		// Split head post
		Vector3d vxHead= bmHeadPost.vecX();
		double dSplitDistance= bmMidPost.dD( vxHead);
		Point3d ptFrom= bmMidPost.ptCen() +  vxHead * dSplitDistance *.5;
		Point3d ptTo= bmMidPost.ptCen() -  vxHead * dSplitDistance *.5;
		Beam bmSplit= bmHeadPost.dbSplit( ptFrom, ptTo);
		_Beam.append( bmSplit);
	}

	
	_Map.setInt("ExecutionMode",1);
	return;
}

if (nDisplayColor> 255 || nDisplayColor< -1) 
	nDisplayColor.set(-1);

Display dp(nDisplayColor);
dp.textHeight(dTextHeight);
dp.draw(scriptName()+" - WALL " + el .code() + "-" + el.number(), _Pt0, vx, vy, 0,0);

return;





#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`-H!(L#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#SOQIXT\56
MOCKQ#;V_B7688(M3N4CCCOY55%$K```-@`#C%8?_``G?C#_H:]<_\&,W_P`5
M1X[_`.2A^)?^PK=?^C6KGZ`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`
M@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.
M@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N
M?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A.
M_&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`
M@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.
M@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N
M?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A.
M_&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`
M@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.
M@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N
M?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A.
M_&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`
M@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.
M@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N
M?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A.
M_&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`
M@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.
M@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N
M?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A.
M_&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`
M@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.
M@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N
M?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A.
M_&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`
M@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.
M@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N
M?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A.
M_&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`
M@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.
M@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N
M?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A.
M_&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`
M@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.
M@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N
M?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A.
M_&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`
M@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.
M@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N
M?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A.
M_&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`
M@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.
M@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N
M?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A.
M_&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`
M@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.
M@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N
M?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A.
M_&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`
M@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.
M@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N
M?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A.
M_&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`
M@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.
M@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N
M?^#&;_XJC_A._&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A.
M_&'_`$->N?\`@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJC_A._&'_`$->N?\`
M@QF_^*KGZ*`.@_X3OQA_T->N?^#&;_XJOJ?X07]YJ?PMT:\O[N>[NI//WS3R
M&1VQ/(!ECR<``?A7QQ7U_P#!+_DD.A?]O'_I1)0!\P>._P#DH?B7_L*W7_HU
MJY^N@\=_\E#\2_\`85NO_1K5S]`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%?7_P2_P"20Z%_
MV\?^E$E?(%?7_P`$O^20Z%_V\?\`I1)0!\P>._\`DH?B7_L*W7_HUJY^N@\=
M_P#)0_$O_85NO_1K5S]`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%?7_P2_Y)#H7_`&\?^E$E
M?(%?7_P2_P"20Z%_V\?^E$E`'S!X[_Y*'XE_["MU_P"C6KGZZ#QW_P`E#\2_
M]A6Z_P#1K5S]`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%?7_`,$O^20Z%_V\?^E$E?(%?7_P
M2_Y)#H7_`&\?^E$E`'S!X[_Y*'XE_P"PK=?^C6KGZZ#QW_R4/Q+_`-A6Z_\`
M1K5S]`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%?7_P`$O^20Z%_V\?\`I1)7R!7U_P#!+_DD
M.A?]O'_I1)0!\P>._P#DH?B7_L*W7_HUJY^N@\=_\E#\2_\`85NO_1K5S]`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%?7_P2_P"20Z%_V\?^E$E?(%?7_P`$O^20Z%_V\?\`
MI1)0!\P>._\`DH?B7_L*W7_HUJY^N@\=_P#)0_$O_85NO_1K5S]`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%?7_P2_Y)#H7_`&\?^E$E?(%?7_P2_P"20Z%_V\?^E$E`'S!X
M[_Y*'XE_["MU_P"C6KGZZ#QW_P`E#\2_]A6Z_P#1K5S]`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%?7_`,$O^20Z%_V\?^E$E?(%?7_P2_Y)#H7_`&\?^E$E`'S!X[_Y*'XE
M_P"PK=?^C6KGZZ#QW_R4/Q+_`-A6Z_\`1K5S]`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%?7
M_P`$O^20Z%_V\?\`I1)7R!7U_P#!+_DD.A?]O'_I1)0!\P>._P#DH?B7_L*W
M7_HUJY^N@\=_\E#\2_\`85NO_1K5S]`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%?7_P2_P"2
M0Z%_V\?^E$E?(%?7_P`$O^20Z%_V\?\`I1)0!\P>._\`DH?B7_L*W7_HUJY^
MN@\=_P#)0_$O_85NO_1K5S]`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%?7_P2_Y)#H7_`&\?
M^E$E?(%?7_P2_P"20Z%_V\?^E$E`'S!X[_Y*'XE_["MU_P"C6KGZZ#QW_P`E
M#\2_]A6Z_P#1K5S]`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%?7_`,$O^20Z%_V\?^E$E?(%
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
M%R>(?^?/2_\`OU)_\71_PN3Q#_SYZ7_WZD_^+KSRBCZS6_F#^P\N_P"?*/0_
M^%R>(?\`GSTO_OU)_P#%T?\`"Y/$/_/GI?\`WZD_^+KSRBCZS6_F#^P\N_Y\
MH****P/5"BBB@`KZ_P#@E_R2'0O^WC_THDKY`KZ_^"7_`"2'0O\`MX_]*)*`
M/F#QW_R4/Q+_`-A6Z_\`1K5S]=!X[_Y*'XE_["MU_P"C6KGZ`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`*^O_`()?\DAT+_MX_P#2B2OD"OK_`."7_)(="_[>/_2B2@#Y@\=_
M\E#\2_\`85NO_1K5S]=!X[_Y*'XE_P"PK=?^C6KGZ`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`*^O_@E_R2'0O^WC_P!*)*^0*^O_`()?\DAT+_MX_P#2B2@#Y@\=_P#)0_$O
M_85NO_1K5S]=!X[_`.2A^)?^PK=?^C6KGZ`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*^O_@E
M_P`DAT+_`+>/_2B2OD"OK_X)?\DAT+_MX_\`2B2@#Y@\=_\`)0_$O_85NO\`
MT:U<_70>._\`DH?B7_L*W7_HUJY^@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"OK_`."7_)(=
M"_[>/_2B2OD"OK_X)?\`)(="_P"WC_THDH`^8/'?_)0_$O\`V%;K_P!&M7/U
MT'CO_DH?B7_L*W7_`*-:N?H`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`KZ_\`@E_R2'0O^WC_
M`-*)*^0*^O\`X)?\DAT+_MX_]*)*`/F#QW_R4/Q+_P!A6Z_]&M7/UT'CO_DH
M?B7_`+"MU_Z-:N?H`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`KZ_^"7_)(="_[>/_`$HDKY`K
MZ_\`@E_R2'0O^WC_`-*)*`/F#QW_`,E#\2_]A6Z_]&M7/UT'CO\`Y*'XE_["
MMU_Z-:N?H`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`KZ_^"7_`"2'0O\`MX_]*)*^0*^O_@E_
MR2'0O^WC_P!*)*`/F#QW_P`E#\2_]A6Z_P#1K5S]=!X[_P"2A^)?^PK=?^C6
MKGZ`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`*^O\`X)?\DAT+_MX_]*)*^0*^O_@E_P`DAT+_
M`+>/_2B2@#Y@\=_\E#\2_P#85NO_`$:U<_70>._^2A^)?^PK=?\`HUJY^@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"OK_P""7_)(="_[>/\`THDKY`KZ_P#@E_R2'0O^WC_T
MHDH`^8/'?_)0_$O_`&%;K_T:U<_70>._^2A^)?\`L*W7_HUJY^@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"OK_X)?\DAT+_MX_\`2B2OD"OK_P""7_)(="_[>/\`THDH`^8/
M'?\`R4/Q+_V%;K_T:U<_70>._P#DH?B7_L*W7_HUJY^@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"OK_X)?\`)(="_P"WC_THDKY`KZ_^"7_)(="_[>/_`$HDH`^?/&G@OQ5=
M>.O$-Q;^&M9F@EU.Y>.2.PE974RL000N"".<UA_\()XP_P"A4US_`,%TW_Q-
M%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_
MZ%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`
M$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A
M4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-
M%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_
MZ%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`
M$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A
M4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-
M%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_
MZ%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`
M$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A
M4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-
M%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_
MZ%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`
M$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A
M4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-
M%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_
MZ%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`
M$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A
M4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-
M%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_
MZ%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`
M$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A
M4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-
M%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_
MZ%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`
M$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A
M4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-
M%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_
MZ%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`
M$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A
M4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-
M%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_
MZ%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`
M$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A
M4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-
M%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_
MZ%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`
M$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A
M4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-
M%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_
MZ%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`
M$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A
M4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-
M%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_
MZ%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`
M$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A
M4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-
M%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_
MZ%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`
M$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A
M4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-
M%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_
MZ%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`
M$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A
M4US_`,%TW_Q-%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-
M%%`!_P`()XP_Z%37/_!=-_\`$T?\()XP_P"A4US_`,%TW_Q-%%`!_P`()XP_
MZ%37/_!=-_\`$U]3_""PO-,^%NC6=_:3VEU'Y^^&>,QNN9Y",J>1D$'\:**`
#/__9
`



#End
