#Version 8
#BeginDescription
MK:13-8-04: all blocking shows label up or down. Up/DN
10/8/04:MK - this tsl will show the plan and section studs using different symbols. This is all based upon hsbID values.






















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
String arDir[]={"Horizontal","Vertical"};
PropString strDir(1,arDir,"Direction");


// symbols :  '/'  
//                   'O'   : letter O (not number zero)
//                   '\\'     need to have a double backslash
//                   'X'
//                   ' '      need blank (not empty otherwise TSL doesn't work)



String arHsbId[]={"78002","78005","78006","78007","18","114","412","130","24","81","82","131","133","79","80","30","87","89","695","699","138","76","74","696","75","73","695","32","139","140","2023","413","78000","78001","78010", "4"};
char arCross[]={'X',               'X',         'X',         'X',       'X',   'X',     'D',    '/',     'X',   'X'  ,'X',   'X',      'X',    'X',   'X',   'X',   'X',  'X',   '\\',    '\\',    'X',   'X',   '/',    '\\',   'X',   '/',   '\\',    ' ',     'O',    'O',      'L',     'O',      'X',         'X',        'X',       'O'};


 if (strDir==arDir[1]) { // vertical
 	String arHsbIdVer[]={"32","4","83","78","12","86","94","71","114","3","5"};
	char arCrossVer[]={'X','X','X','X','/','X','X','X',' ',' ',' '};
	arHsbId=arHsbIdVer;
	arCross=arCrossVer;
 }


if (_bOnInsert) {
  Viewport vp = getViewport("Select the viewport from which the element is taken"); // select viewport
  _Viewport.append(vp);

  return;

}

Display dp(-1); // use color of entity for frame
dp.dimStyle("HSB-vp-block"); // dimstyle was adjusted for display in paper space, sets textHeight



// do something for the last appended viewport only
if (_Viewport.length()==0) return; // _Viewport array has some elements
Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;
	
/////////////////////////

Element el = vp.element();

CoordSys csVp = _Viewport[0].coordSys();



  Beam arBeam[0]; 
  arBeam  = el.beam();

for (int i=0; i<arBeam.length(); i++) {
    // loop over list items
    int bOK = false;
    Beam bm = arBeam[i];


    int iHsbId = arHsbId.find(bm.name("hsbId"));	

	if (iHsbId>-1){

		double dHL = bm.dL()/2;
		double dHH = bm.dH()/2;
		double dHW = bm.dW()/2;

    		Point3d ptM = bm.ptCen();
   		Point3d pta = bm.ptCen()+bm.vecX()*dHL+bm.vecY()*dHW+bm.vecZ()*dHH;
   		Point3d ptb = bm.ptCen()-bm.vecX()*dHL-bm.vecY()*dHW-bm.vecZ()*dHH;

   		Point3d ptc = bm.ptCen()+bm.vecX()*dHL-bm.vecY()*dHW+bm.vecZ()*dHH;
   		Point3d ptd = bm.ptCen()-bm.vecX()*dHL+bm.vecY()*dHW-bm.vecZ()*dHH;


            ptM.transformBy(csVp);
		pta.transformBy(csVp);
		ptb.transformBy(csVp);
		PLine L1(pta,ptb);

 		ptc.transformBy(csVp);
		ptd.transformBy(csVp);
		PLine L2(ptc,ptd);

		double dStr = dHW*.8;
		if (dHH<dHW){
			dStr = dHH*.8;
		}
		PLine Plcir; Plcir.createCircle(ptM,bm.vecX(),dStr);

		Body bdBeam = bm.realBody();
		bdBeam.transformBy(csVp);
		dp.draw(bdBeam);

    		char Cross = arCross[iHsbId];
   	
    		if (Cross=='X') {
			dp.draw(L1);
			dp.draw(L2);
    		}	   	

   	
    		if (Cross=='/') {
			dp.draw(L1);
    		}	   	

   	
    		if (Cross=='\\') {
			dp.draw(L2);
    		}	   	


    		if (Cross=='O') {
			Plcir.transformBy(csVp);
			dp.draw(Plcir);
    		}	   

	if (Cross=='U') {
			//Plcir.transformBy(csVp);
			//dp.draw(Plcir);

String strU = "Up";
dp.draw(strU,ptM,_XW,_YW,0,0);


   		}	
	if (Cross=='L') {
			//Plcir.transformBy(csVp);
			//dp.draw(Plcir);

String strL = "L";
dp.draw(strL,ptM,_XW,_YW,0,0);


   		}	 	

	if (Cross=='T') {
			//Plcir.transformBy(csVp);
			//dp.draw(Plcir);

String strL = "T";
dp.draw(strL,ptM,_XW,_YW,0,0);


   		}	 	

	if (Cross=='D') {
			//Plcir.transformBy(csVp);
			//dp.draw(Plcir);

String strD = "Dn";
dp.draw(strD,ptM,_XW,_YW,0,0);

}

	if (Cross=='S') {
			//Plcir.transformBy(csVp);
			//dp.draw(Plcir);

String strS = "S";
dp.draw(strS,ptM,_XW,_YW,0,0);


   		}	


	}
}
















#End
#BeginThumbnail







#End
