#Version 8
#BeginDescription
Last modified by: 
Alberto Jena (aj@hsb-cad.com)
25.02.2011  -  version 1.5






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
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
* date: 25.06.2008
* version 1.0: Release Version
*
* Modify by: Alberto Jena(aj@hsb-cad.com)
* date: 10.11.2008
* version 1.1: Addition of Restraint types
*
* date: 10.05.2010
* version 1.2:	Change the Table and some small fixes on export
*
* date: 03.09.2010
* version 1.3:	Add Properties for other restraint type so the customer can define it
*
* date: 11.02.2011
* version 1.4:	Add group for the new data base
*
*/

Unit (1, "mm");

PropDouble dTh (0, U(2), T("Thickness"));
PropDouble dWi (1, U(36), T("Width"));
PropDouble dLe (2, U(100), T("Length"));
PropInt nQty (0, 1, T("Quantity"));

PropString sDispRep(0, "", T("Show in Disp Rep"));

String strRestraintModels[]={"Other Model Type", "ST-PFS-50", "ST-PFS-75", "ST-PFS-100", "ST-PFS-50-M", "ST-PFS-75-M", "ST-PFS-100-M", "RE240", "RE90"};

PropString sModel(1, strRestraintModels,T("Model Type"), 1);

PropString strCustomRestraintModel (2, "**Other Type**", T("Other Restraint Type"));
strCustomRestraintModel.setDescription( T("Please fill this value if you choose 'Other Model Type' above") );

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

String sRestraintModel;

if (strRestraintModels.find(sModel, 0)==0)
	sRestraintModel=strCustomRestraintModel;
else
	sRestraintModel=sModel;

if (_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	showDialogOnce();
	_Pt0=getPoint(T("Pick a Point"));
	_Beam.append(getBeam(T("Select a Beam")));
	return;
}

Vector3d vx;
Vector3d vy;
Vector3d vz;

String sGroup="";
if (_Map.hasString("Group"))
{
	sGroup=_Map.getString("Group");
}

if (_Beam.length()<1)
{
	eraseInstance();
	return;
}

if (_Map.hasVector3d("vx"))
{
	vx=_Map.getVector3d("vx");
}
else
{
	vx=_Beam[0].vecX();
}
if (_Map.hasVector3d("vy"))
{
	vy=_Map.getVector3d("vy");
}
else
{
	vy=_Beam[0].vecZ();
}
if (_Map.hasVector3d("vz"))
{
	vz=_Map.getVector3d("vz");
}
else
{
	vz=_Beam[0].vecY();
}

vx.vis(_Pt0);
vy.vis(_Pt0);
vz.vis(_Pt0);

setDependencyOnEntity(_Beam[0]);

assignToGroups(_Beam[0]);

PLine plMP(vz);
plMP.addVertex(_Pt0+vx*(dWi*0.5));
plMP.addVertex(_Pt0-vy*(dLe*0.5)+vx*(dWi*0.5));
plMP.addVertex(_Pt0-vy*(dLe*0.5)-vx*(dWi*0.5));
plMP.addVertex(_Pt0-vx*(dWi*0.5));
plMP.close();
Body bdMP(plMP, vz*dTh, 1);

PLine plMP2(-vy);
plMP2.addVertex(_Pt0+vx*(dWi*0.5));
plMP2.addVertex(_Pt0-vz*(dLe)+vx*(dWi*0.5));
plMP2.addVertex(_Pt0-vz*(dLe)-vx*(dWi*0.5));
plMP2.addVertex(_Pt0-vx*(dWi*0.5));
Body bdMP2(plMP2, vy*dTh, 1);

Display dp(-1);
if (sDispRep!="")
	dp.showInDispRep(sDispRep);

dp.draw(bdMP);
dp.draw(bdMP2);

String sCompareKey = (String) sRestraintModel;
setCompareKey(sCompareKey);

String sQty=(String) nQty;
exportToDxi(TRUE);
dxaout(sGroup, "");
dxaout("U_MODEL",sRestraintModel);
dxaout("U_QUANTITY", sQty);
		
Map mp;
mp.setString("Name", sRestraintModel);
mp.setInt("Qty", nQty);

_Map.setMap("TSLBOM", mp);




#End
#BeginThumbnail
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
MQZ@Y/X#I0!\V44YT>*1HY$9'4E65A@@CJ"*;0`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110!J^&]4.B^)-/U'Y,03*S%P2`O0G`YZ$U]7Q2)-$DL9RCJ&4
M^H-?'=?37PVU675_`NGS3;S)&#"S.Y<OM.,DF@#K****`"BBB@`K/URV6ZT:
MY5L`JAD4D9P5Y_Q'XUH44`?*WC"S^R>)+DK'LCGQ,O.=V1\Q_P"^@W_ZJPJ]
M*^*.BFV<3JAS;2F,G:"3&W*DL.@'\W[5YK0`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`5ZY\$-86.[U#1G*#S0)XQM.YB.&YZ8QBO(ZZ+P+JG]D>--,N
M2TPC,PC<1'E@W&#R,C)'Y4`?4E%%%`!1110`4444`>??$K23?V4B(HW7$!"A
M2`S2(=RY)XY.T?3TKYZKZP\1VINM&EVY+Q$2@`@=.OZ$U\Q^([-+#Q#>P1[=
M@?>H5=H4,`P`'MG'X4`9=%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`'6V7Q+\664\<@U1I4C&!%*BE",8Z`#I6G_PN3Q7_>LO^_'_`->O/Z*`/4[3
MXX:M%;(ESI=K/,,[I`Y0-SQQSCBM"Q^.9,S?;]&VQ;>/L\N6W9'KCC&:\<HH
M`]R_X7EI/_0(O?\`OI/\:V?^%O\`A'_GZN?_``':OG2B@#Z5M?B5X0U6*>)M
M36%-NUA<*8]P.>GK7B?CN[T^[U>+[%<BX>*/8\D9S&1DE=I[GDY_#OFN6HH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
#`/_9
`







#End
