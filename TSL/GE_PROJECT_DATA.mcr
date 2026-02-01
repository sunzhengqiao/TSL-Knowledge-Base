#Version 8
#BeginDescription
V2.0__16Dec2021__Generalized for NA











#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 0
#KeyWords 
#BeginContents
//Units
Unit(1,"inch");
//Tolerance
double dTolerance=.01;

///////////////////////////////////////////////////////////////////////////////////////////////////// SHEET SPLITTING PROPERTIES /////////////////////////////////////////////////////////////////////////////////////////////////////

int strProp=0,nProp=0,dProp=0;
String arYN[]={"Yes","No"};
String stCat = "GENERAL";

PropString strDim(strProp++,_DimStyles,T("Dim Style"));
strDim.setCategory(stCat);
PropDouble dpTH(dProp++,U(10),T("Text Height"));
dpTH.setCategory(stCat);
//PropDouble dpTblWidth1(dProp++,U(200),T("Project Table Width"));
//dpTblWidth1.setCategory(stCat);
//PropDouble dpTblWidth2(dProp++,U(120),T("Revision Table Width"));
//dpTblWidth2.setCategory(stCat);
//
stCat = "PROJECT DATA";

PropString strPName(strProp++,"",T("Project Name"));
strPName.setCategory(stCat);
PropString strPTitle(strProp++,"",T("Project Title"));
strPTitle.setCategory(stCat);
PropString strPNum(strProp++,"",T("Project Number"));
strPNum.setCategory(stCat);
PropString strPClient(strProp++,"",T("Client"));
strPClient.setCategory(stCat);
PropString strPArchitect(strProp++,"",T( "Architect"));
strPArchitect.setCategory(stCat);
PropString strPAddressLn1(strProp++,"",T("Address Line 1"));
strPAddressLn1.setCategory(stCat);
PropString strPAddressLn2(strProp++,"",T("Address Line 2"));
strPAddressLn2.setCategory(stCat);

PropString strPDesigner(strProp++,"",T("Designer"));
strPDesigner.setCategory(stCat);
PropString strPCheck(strProp++,"",T("Checker"));
strPCheck.setCategory(stCat);

PropString strPDate(strProp++,"",T("Date"));
strPDate.setCategory(stCat);

stCat = "REVISIONS 1";
PropString strRev1Date(strProp++,"",T("Date"));
strRev1Date.setCategory(stCat);
PropString strRev1(strProp++,"",T("Description"));
strRev1.setCategory(stCat);

stCat = "REVISIONS 2";
PropString strRev2Date(strProp++,"",T("Date")+" ");
strRev2Date.setCategory(stCat);
PropString strRev2(strProp++,"",T("Description") + " ");
strRev2.setCategory(stCat);

stCat = "REVISIONS 3";
PropString strRev3Date(strProp++,"",T("Date")+"  ");
strRev3Date.setCategory(stCat);
PropString strRev3(strProp++,"",T("Description") + "  ");
strRev3.setCategory(stCat);

stCat = "REVISIONS 4";
PropString strRev4Date(strProp++,"",T("Date")+"    ");
strRev4Date.setCategory(stCat);
PropString strRev4(strProp++,"",T("Description") + "    ");
strRev4.setCategory(stCat);

stCat = "REVISIONS 5";
PropString strRev5Date(strProp++,"",T("Date")+"     ");
strRev5Date.setCategory(stCat);
PropString strRev5(strProp++,"",T("Description") + "     ");
strRev5.setCategory(stCat);

stCat = "REVISIONS 6";
PropString strRev6Date(strProp++,"",T("Date")+"      ");
strRev6Date.setCategory(stCat);
PropString strRev6(strProp++,"",T("Description") + "      ");
strRev6.setCategory(stCat);

stCat = "REVISIONS 7";
PropString strRev7Date(strProp++,"",T("Date")+"       ");
strRev7Date.setCategory(stCat);
PropString strRev7(strProp++,"",T("Description") + "       ");
strRev7.setCategory(stCat);

stCat = "REVISIONS 8";
PropString strRev8Date(strProp++,"",T("Date")+"        ");
strRev8Date.setCategory(stCat);
PropString strRev8(strProp++,"",T("Description") + "        ");
strRev8.setCategory(stCat);

stCat = "REVISIONS 9";
PropString strRev9Date(strProp++,"",T("Date")+"         ");
strRev9Date.setCategory(stCat);
PropString strRev9(strProp++,"",T("Description") + "         ");
strRev9.setCategory(stCat);

stCat = "REVISIONS 10";
PropString strRev10Date(strProp++,"",T("Date")+"          ");
strRev10Date.setCategory(stCat);
PropString strRev10(strProp++,"",T("Description") + "          ");
strRev10.setCategory(stCat);

stCat = "REVISIONS 11";
PropString strRev11Date(strProp++,"",T("Date")+"           ");
strRev11Date.setCategory(stCat);
PropString strRev11(strProp++,"",T("Description") + "           ");
strRev11.setCategory(stCat);

stCat = "REVISIONS 12";
PropString strRev12Date(strProp++,"",T("Date")+"            ");
strRev12Date.setCategory(stCat);
PropString strRev12(strProp++,"",T("Description") + "            ");
strRev12.setCategory(stCat);

stCat = "REVISIONS 13";
PropString strRev13Date(strProp++,"",T("Date")+"             ");
strRev13Date.setCategory(stCat);
PropString strRev13(strProp++,"",T("Description") + "             ");
strRev13.setCategory(stCat);

stCat = "REVISIONS 14";
PropString strRev14Date(strProp++,"",T("Date")+"               ");
strRev14Date.setCategory(stCat);
PropString strRev14(strProp++,"",T("Description") + "               ");
strRev14.setCategory(stCat);

stCat = "REVISIONS 15";
PropString strRev15Date(strProp++,"",T("Date")+"              ");
strRev15Date.setCategory(stCat);
PropString strRev15(strProp++,"",T("Description") + "              ");
strRev15.setCategory(stCat);

stCat = "REVISIONS 16";
PropString strRev16Date(strProp++,"",T("Date")+"                  ");
strRev16Date.setCategory(stCat);
PropString strRev16(strProp++,"",T("Description") + "                  ");
strRev16.setCategory(stCat);

stCat = "REVISIONS 17";
PropString strRev17Date(strProp++,"",T("Date")+"                ");
strRev17Date.setCategory(stCat);
PropString strRev17(strProp++,"",T("Description") + "                ");
strRev17.setCategory(stCat);

stCat = "DEFAULT WALL FASTENING";

PropString strNailTypeFraming(strProp++,"8d (3 1/4\" x 0.131)", "Framing Fastener Type");
strNailTypeFraming.setCategory(stCat);
PropString strNailType(strProp++,"8d (2 1/2\" x 0.131)", "Sheathing Fastener Type");
strNailType.setCategory(stCat);
PropDouble dEdge(dProp++,U(6),"Edge Spacing");
dEdge.setFormat(_kNone);
dEdge.setCategory(stCat);
PropDouble dField(dProp++,U(12),"Field Spacing");
dField.setFormat(_kNone);
dField.setCategory(stCat);

stCat = "DEFAULT FLOOR FASTENING";
PropString strFloorNailType(strProp++,"8d (2 1/2\" x 0.131)", "Floor Sheathing Fastener");
strFloorNailType.setCategory(stCat);
PropDouble dFloorEdge(dProp++,U(6),"Floor Edge Spacing");
dFloorEdge.setFormat(_kNone);
dFloorEdge.setCategory(stCat);
PropDouble dFloorField(dProp++,U(12),"Floor Field Spacing");
dFloorField.setFormat(_kNone);
dFloorField.setCategory(stCat);



// bOnInsert
if (_bOnInsert){
	if(insertCycleCount()>1)eraseInstance();
	_Pt0=getPoint("\nSelect the upper left corner ot the table");
	showDialogOnce();
}//END if (_bOnInsert)

Display dp(-1);
dp.dimStyle(strDim);


double dTW=dp.textLengthForStyle("TT",strDim);
double dTH=dp.textHeightForStyle("TT",strDim);
double dRatio = dTH/dTW;
if(dpTH>0)
{
	dp.textHeight(dpTH);
	dTH=dpTH;
	dTW=dTH*dRatio;
}

Point3d ptRef=_Pt0- 4*dTH*_YW;


//Liste Left
String arLHdr[0],arLValue[0];
arLHdr.append("Project Name");arLValue.append(strPName);
arLHdr.append("Project Title");arLValue.append(strPTitle);
arLHdr.append("Project Number");arLValue.append(strPNum);
arLHdr.append("Client");arLValue.append(strPClient);
arLHdr.append("Architect");arLValue.append(strPArchitect);
arLHdr.append("Address Line 1");arLValue.append(strPAddressLn1);
arLHdr.append("Address Line 2");arLValue.append(strPAddressLn2);
arLHdr.append("Designer");arLValue.append(strPDesigner);
arLHdr.append("Checked");arLValue.append(strPCheck);
arLHdr.append("Date");arLValue.append(strPDate);
arLHdr.append("Framing Fastener");arLValue.append(strNailTypeFraming);
arLHdr.append("Sheathing Fastener");arLValue.append(strNailType);
arLHdr.append("Edge Spacing"); arLValue.append( dEdge+"\"");
arLHdr.append("Field Spacing"); arLValue.append(dField+"\"");
arLHdr.append("Floor Sheathing Fastener");arLValue.append(strFloorNailType);
arLHdr.append("Floor Edge Spacing"); arLValue.append( dFloorEdge+"\"");
arLHdr.append("Floor Field Spacing"); arLValue.append(dFloorField +"\"");

//List right
String arRHdr[0],arRDate[0], arRValue[0];
arRHdr.append("Revision 1");arRDate.append(strRev1Date);arRValue.append(strRev1);
arRHdr.append("Revision 2");arRDate.append(strRev2Date);arRValue.append(strRev2);
arRHdr.append("Revision 3");arRDate.append(strRev3Date);arRValue.append(strRev3);
arRHdr.append("Revision 4");arRDate.append(strRev4Date);arRValue.append(strRev4);
arRHdr.append("Revision 5");arRDate.append(strRev5Date);arRValue.append(strRev5);
arRHdr.append("Revision 6");arRDate.append(strRev6Date);arRValue.append(strRev6);
arRHdr.append("Revision 7");arRDate.append(strRev7Date);arRValue.append(strRev7);
arRHdr.append("Revision 8");arRDate.append(strRev8Date);arRValue.append(strRev8);
arRHdr.append("Revision 9");arRDate.append(strRev9Date);arRValue.append(strRev9);
arRHdr.append("Revision 10");arRDate.append(strRev10Date);arRValue.append(strRev10);
arRHdr.append("Revision 11");arRDate.append(strRev11Date);arRValue.append(strRev11);
arRHdr.append("Revision 12");arRDate.append(strRev12Date);arRValue.append(strRev12);
arRHdr.append("Revision 13");arRDate.append(strRev13Date);arRValue.append(strRev13);
arRHdr.append("Revision 14");arRDate.append(strRev14Date);arRValue.append(strRev14);
arRHdr.append("Revision 15");arRDate.append(strRev15Date);arRValue.append(strRev15);
arRHdr.append("Revision 16");arRDate.append(strRev16Date);arRValue.append(strRev16);
arRHdr.append("Revision 17");arRDate.append(strRev17Date);arRValue.append(strRev17);
//add Grips
double dpTblWidth1 = U(200);
if(_PtG.length() != 5)
{ 
	_PtG.setLength(5);
	_PtG[0] = ptRef + dpTblWidth1 * _XW;
	_PtG[1] = _PtG[0] + dpTblWidth1 * _XW;
	_PtG[2] = _PtG[1] + dpTblWidth1 * _XW;
	_PtG[3] = _PtG[2] + dpTblWidth1 * _XW;
	_PtG[4] = _PtG[3] + dpTblWidth1 * _XW;
}
Line lnG(ptRef, _XW);
for (int i = 0; i < _PtG.length(); i++)_PtG[i] = lnG.closestPointTo(_PtG[i]);

double dOffsetY = dTH * 2;

Point3d ptText1=ptRef+_XW*dTW-_YW*dTH;
Point3d ptText2=_PtG[0]+dTW*_XW-_YW*dTH;
LineSeg lnSeg1(ptRef,_PtG[4]);


//double dOffset2X=dpTblWidth2/3;

Point3d ptText3=_PtG[1]+_XW*dTW-_YW*dTH;
Point3d ptText4 = _PtG[2] + _XW * dTW - _YW * dTH;
Point3d ptText5 = _PtG[3] + _XW * dTW - _YW * dTH;


if(dpTblWidth1>0)
{
	for(int i=0;i<arLHdr.length();i++)
	{
		String str1=arLHdr[i];
		String str2=arLValue[i];
		
		dp.draw(str1,ptText1,_XW,_YW,1,0);
		dp.draw(str2,ptText2,_XW,_YW,1,0);
		
		
	
		ptText1.transformBy(-_YW*dOffsetY);
		ptText2.transformBy(-_YW*dOffsetY);
		
		if(arLHdr.length()>=arRHdr.length())
		{
			dp.draw(	lnSeg1);
			lnSeg1.transformBy(-_YW*dOffsetY);
		}
	}
}

int iLatestRev = -1;
String stLatestRev = "";
String stLatestRevDate = "";

//if(dpTblWidth2>0)
{
	for(int i=0;i<arRHdr.length();i++)
	{
		String str1=arRHdr[i];
		String str2=arRDate[i];
		String str3=arRValue[i];
		
		if(str2.length() > 0)
		{
			iLatestRev = i+1;
			stLatestRev = str3;
			stLatestRevDate = str2 ;
		}
		
		dp.draw(str1,ptText3,_XW,_YW,1,0);
		dp.draw(str2,ptText4,_XW,_YW,1,0);
		dp.draw(str3,ptText5,_XW,_YW,1,0);
		
		ptText3.transformBy(-_YW*dOffsetY);
		ptText4.transformBy(-_YW*dOffsetY);
		ptText5.transformBy(-_YW*dOffsetY);
		if(arRHdr.length()>arLHdr.length())
		{
			dp.draw(	lnSeg1);
			lnSeg1.transformBy(-_YW*dOffsetY);
		}
		
	}
}	

double dHT = _YW.dotProduct(_PtG[0] - lnSeg1.ptStart());
//boundary
PLine plRec;plRec.createRectangle(LineSeg(ptRef,lnSeg1.ptEnd()),_XW,_YW);
dp.draw(plRec);

//vertical lines
LineSeg lnSegCenter( _PtG[0], _PtG[0] - _YW * dHT);
dp.draw(lnSegCenter);
LineSeg lnSegCenter2( _PtG[1], _PtG[1] - _YW * dHT);
dp.draw(lnSegCenter2);
LineSeg lnSegCenter3( _PtG[2], _PtG[2] - _YW * dHT);
dp.draw(lnSegCenter3);
LineSeg lnSegCenter4( _PtG[3], _PtG[3] - _YW * dHT);
dp.draw(lnSegCenter4);
LineSeg lnSegCenter5( _PtG[4], _PtG[4] - _YW * dHT);
dp.draw(lnSegCenter5);

//Draw Header
LineSeg lnHdr(_Pt0, _PtG[4]);
//lnHdr.transformBy(-4*dTH*_YW);
PLine plHdr;plHdr.createRectangle(lnHdr,_XW,_YW);
dp.draw(plHdr);

dp.textHeight(dTH*2);

dp.draw("Project Information",lnHdr.ptMid(),_XW,_YW,0,0);


///add to settings
String strProjectName="";
if(strPDate.length()>2)strProjectName+=strPName;
if(strPClient.length()>2)strProjectName+=String("-" + strPClient);

setProjectName(strProjectName);
setProjectNumber(strPNum);
String strUser="";
if(strPDesigner.length()>2)strUser+=strPDesigner;
if(strPCheck.length()>2)strUser+=String("-" + strPCheck);
setProjectUser(strUser);
setProjectCity(strPAddressLn1 + " " + strPAddressLn2);
setProjectRevision(iLatestRev);

String srtStreet="";//"Release: "+strPDateRelease;

if(strPDate.length()>2)srtStreet+=String("Start: "+strPDate);

setProjectStreet(srtStreet);

//Create a mapObject
Map mpProjectXData;
mpProjectXData.setMapName("mpProjectXData");
mpProjectXData.setString("stLatestRevisionDescription", stLatestRev);
mpProjectXData.setString("stLatestRevisionDate", stLatestRevDate);
mpProjectXData.setInt("iLatestRevision", iLatestRev);

for(int i=0;i<arLHdr.length();i++)
{
	mpProjectXData.appendString(arLHdr[i],arLValue[i]);
}

Map mpRevList;
mpRevList.setMapName("mpProjectRevisions");
mpRevList.setString("stLatestRevisionDescription", stLatestRev);
mpRevList.setString("stLatestRevisionDate", stLatestRevDate);
mpRevList.setInt("iLatestRevision", iLatestRev);

for(int i=0;i<arRHdr.length();i++)
{
	mpRevList.setString("mpRev" + String(i+1) + "\\Date", arRDate[i]);
	mpRevList.setString("mpRev" + String(i+1) + "\\Description", arRValue[i]);
}

//arLHdr[0],arLValue[0];
Map mpProjetXGenData;
for(int i=0;i<arLHdr.length();i++)
{
	mpProjetXGenData.setString(arLHdr[i], arLValue[i]);
}



Map mp;
mp.setMap("mpProjectXData", mpProjectXData);
mp.setMap("mpXData", mpProjetXGenData);
mp.setMap("mpProjectRevisions", mpRevList);

MapObject moPD("MoProjectData","MoProjectData");
moPD.dbErase();

if(moPD.bIsValid())moPD.setMap(mp);
else moPD.dbCreate(mp);

setSubMapXProject("mpProjectXData", mp);




#End
#BeginThumbnail
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
M/H%%%%;&04444`%6K'_7-_N_UJK5VP^[+]1_6HG\+*CN7***M:=IUSJM_%96
MB;YI6P/0#N3["N=)MV1M)J*NR_X:\/3^(M46VCRD*?--+C[B_P")[5[C9V<&
MGV<5I:QB.&)=J*.W_P!>J6@:';:!I:6=N,M]Z60CF1NYK4KV,-0]E&[W9\EF
M&->)G9?"MO\`,****Z3SPHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`SM6T/3M;@\J_MEDP/E<<.OT/6O.-=^
M&U[9!IM+D-Y".?*/$@'\F_3Z5ZQ16%7#PJ;K4Z\-CJV'^%Z=NA\X2Q20RM%*
MC1R*<,K#!!]Q3:]]UCP]IFNQ;+ZV5G`PLJ\.OT/]#Q7FVN_#G4=/W3:<3>P#
MG:!B1?P[_A^5>=5PDX:K5'T&&S2C6TE[K_KJ<712NC1NR.I5E."",$&DKE/3
M*MZ^(E7GYC_+_(JA5B\?=<$<?*,<57KI@K1,).["BBBK)"BBB@`J[8`[7;L3
MBJ5:%CC[.?7>?Y"HJ?"7#<MQQO+(L<:EW<A551DDGM7M'@WPLGAZP\V<!K^<
M#S6Z[!_<']?4_05C?#_PE]EC36;^/]^XS;QL/N*?XC[GM[5Z!75A,/9>TEN>
M#FF.YW[&F]%OYA1117>>*%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`&/K7AC2]>3_3+<
M"8#`GC^5Q^/?\<UYMKGP\U3329;(&_M_^F:_O!]5[_A^E>PT5A5PU.IJ]SMP
MV/K8?2+NNS/F]O"?B-F+'1+_`"3D_P"CM_A2?\(CXB_Z`E__`-^&_P`*^D:*
MCZJNYU?VO4_E1\W?\(CXB_Z`E_\`]^&_PH_X1'Q%_P!`2_\`^_#?X5](T4?5
M5W#^UZG\J/F[_A$?$7_0$O\`_OPW^%'_``B/B+_H"7__`'X;_"OI&BCZJNX?
MVO4_E1\W?\(CXB_Z`E__`-^&_P`*[7P'X$N9+G[7K-I)#!"V5@F0J9&[9!_A
M'Z]/6O7**:PL;W9%3-:LHN*5KA11172>6%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
64444`%%%%`!1110`4444`%%%%`'_V444
`







#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End