#Version 7
#BeginDescription
EN
   creates BMF-Column shoe D, BMF-26104 - BMF 26986 on a post
DE
   erzeugt Postenschuhe vom Typ D, BMF Artikelnummern 26104 - 26986
Version 1.1   2006-01-30   rh@hsb-cad.com



#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 0
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/*Author: Roberto Hallo, rh@hsb-cad.com*
Date: 2006/Jan/25
Version: 1.0. initial version
Modify by Roberto Hallo
Date: 2006/Jan/30
Version: 1.1*/

U(1,"mm");

_X0.vis(_Pt0,1);
_Y0.vis(_Pt0,1);
_Z0.vis(_Pt0,1);
_Pt0.vis();

String strError = "\n" + T("Shoe cannot be used!");
PropDouble dBaseHeigh (0,U(0),T("Base Height"));
String Fixing[]={T("Nails"),T("Screws")};
PropString strFixing (0, Fixing, T("Type of Fixing"),1);

// get male beam size
double dMw = _Beam0.dD(_Y0);
double dMh = _Beam0.dD(_Z0);

// create arrays
double arW[] = { 100, 100, 100, 115, 120, 123, 125, 140, 148, 48, 50, 73,73, 75, 80, 80, 90, 98 };//Male beam sizes

int iIndex = -1;
for (int i=0; i < arW.length(); i++)
{
	if (abs(dMw-U(arW[i])) < 0.0001)
	{
		iIndex = i;
		break;
	}
}

if (iIndex == -1)
{
	reportMessage(strError);
	eraseInstance();
	return;
}

// create arrays for shoe
double dHt= U(5); 
double arHw[] = { 100, 100, 100, 115, 120, 123, 125, 140, 148, 48, 50, 73,73, 75, 80, 80, 90, 98};//Width of shoe
double arHh[] = {40, 70, 90,90,90,90,90,90,90,40,40,40,70,70,40,70,90,60};
double arHle[] = {125, 126, 136, 129, 126, 125, 124, 126, 122, 126, 125, 126, 130, 129, 123, 126, 141, 126};
double arHss [] = {16,16,20,20,20,20,20,20,20,16,16,16,16,16,16,16,20,15};
String strHn[] = {"BMF-26104"," BMF-26107", "BMF-26109", "BMF-26115", "BMF-26120", "BMF-26123",
				   "BMF-26125","BMF-26140", "BMF-26148", "BMF-26484", "BMF-26504", "BMF-26737", 
				   "BMF-26757","BMF-26804","BMF-26807", "BMF-26909", "BMF-26986"};//Type of shoe
String strHt = "D" + arHw[iIndex] +"x" + arHh[iIndex];//Model of shoe

// shoe dimensions
double dHw = U(arHw[iIndex]);
double dHh = U(arHh[iIndex]);
double dHle = U(arHle[iIndex]);
double dHs =U(250);
double dHss = U(arHss[iIndex]);//shank steel diameter

//Streach beam
Cut ct(_Pt0-_X0*(dBaseHeigh+dHs+dHt),_X0);
_Beam0.addTool(ct,TRUE);

Point3d pt= _Pt0;
pt.vis(3);

//Shank steel
Body bCil(_Pt0-_X0*dBaseHeigh, _Pt0-_X0*(dHs+dBaseHeigh),dHss*.5);

Display disp(9);
disp.draw(bCil);

//create the bottom plate
PLine pl1(_X0);
pl1.addVertex(_Pt0-_X0*(dBaseHeigh+dHs+dHt)+_Y0*(dHw+dHt*2)*.5+_Z0*dHh*.5);
pl1.addVertex(_Pt0-_X0*(dBaseHeigh+dHs+dHt)-_Y0*(dHw+dHt*2)*.5+_Z0*dHh*.5);
pl1.addVertex(_Pt0-_X0*(dBaseHeigh+dHs+dHt)-_Y0*(dHw+dHt*2)*.5-_Z0*dHh*.5);
pl1.addVertex(_Pt0-_X0*(dBaseHeigh+dHs+dHt)+_Y0*(dHw+dHt*2)*.5-_Z0*dHh*.5);
Body bbp (pl1,_X0*dHt,1);
disp.draw(bbp);

//create lateral plates
Point3d ptt = _Pt0-_X0*(dBaseHeigh+dHs+dHt) - _Y0*dHw*.5;
ptt.vis();
PLine pl2(-_Y0);
pl2.addVertex(ptt+_Z0*dHh*.5);
pl2.addVertex(ptt-_Z0*dHh*.5);
pl2.addVertex(ptt-_Z0*dHh*.5-_X0*dHle);
pl2.addVertex(ptt+_Z0*dHh*.5-_X0*dHle);
Body blp (pl2,-_Y0*dHt,1);
disp.draw(blp);

CoordSys cs(_Pt0,_X0,_Y0,_Z0);
cs.setToRotation(180, _X0,_Pt0);
blp.transformBy (cs);
disp.draw(blp);

//Hardware
strHn [iIndex] += "-" + strFixing;
strHt += "-" + strFixing;


//Material
setCompareKey(strHn[iIndex]); // shoe name
model (strHt); //Article number
dxaout(strHn[iIndex], strHt);  //Designation
material(T("Galvanized Steel"));



#End
#BeginThumbnail
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
*Y)6__P`;H`__V0``
`


#End
