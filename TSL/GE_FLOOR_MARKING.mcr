#Version 8
#BeginDescription
V2.9_RL_7July2014__Offset the mark that was too close to the end of the beams
V2.8_CC_12June2014__Now considers all beams in Floor Group, not just Element Group
V2.7_CC_11June2014__Making uses Label only
V2.6_JF_June 10 2014__Marking uses Label + SubLabel
V2.5_JF_June 10 2014__Sets element number in label field
V2.4_RL_June 5 2012__Every squash block adds a mark
V2.3_RL_June 4 2012__Will mark squash blocking locations
V2.2_RL_May 3 2011__Bugfix on TSL deletion
V2.1_RL_April 12 2011_Will now delete existing marking TSLs attahced to the element upon insert
V2.0_RL_Mar23 2010_Added El Area in Element subtype field
Version 1.9 Fix Error of line plane intersection
Version 1.8 Modified coding for different element numbers for the semi
Version 1.7 Forces the element number to the sublabel
Version 1.6 Fixed inkjet marking for semi floors
Version 1.5 Fixed Anglular Beam Marks
Version 1.4 Set panel number to beam sublabel
Verison 1.3 Will reverse Beam vecZ when dotproduct is < 0 from el.vecZ
Version 1.2 Removed Text Heigth coding
Version 1.1 Has multiple insert
HSB-Mark-Beams places marks on places where two beams are touching each other. Head-to-head contacts are nog considerd.
































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 9
#KeyWords 
#BeginContents

Unit(1,"mm");

String arHSBid[0];
String arMinimiser[0];
String arLabel[0];

arHSBid.append("14");
arMinimiser.append("B");
arLabel.append("B");

arHSBid.append("114");
arMinimiser.append("S");
arLabel.append("S");

arHSBid.append("114");
arMinimiser.append("S");
arLabel.append("");

arHSBid.append("117");
arMinimiser.append("S");
arLabel.append("");

arHSBid.append("10002");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("10003");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("102");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("105");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("128");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("130");
arMinimiser.append("J");
arLabel.append("");

arHSBid.append("131");
arMinimiser.append("K");
arLabel.append("");

arHSBid.append("133");
arMinimiser.append("K");
arLabel.append("");

arHSBid.append("138");
arMinimiser.append("K");
arLabel.append("");

arHSBid.append("139");
arMinimiser.append("K");
arLabel.append("");

arHSBid.append("81");
arMinimiser.append("K");
arLabel.append("");

arHSBid.append("82");
arMinimiser.append("K");
arLabel.append("");

arHSBid.append("79");
arMinimiser.append("J");
arLabel.append("");

arHSBid.append("80");
arMinimiser.append("J");
arLabel.append("");

arHSBid.append("88");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("89");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("90");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("95");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("96");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("97");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("98");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("99");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("84");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("85");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("214");
arMinimiser.append("K");
arLabel.append("");

arHSBid.append("18");
arMinimiser.append("S");
arLabel.append("");

arHSBid.append("24");
arMinimiser.append("S");
arLabel.append("");

arHSBid.append("25");
arMinimiser.append("S");
arLabel.append("");

arHSBid.append("30");
arMinimiser.append("S");
arLabel.append("");

arHSBid.append("31");
arMinimiser.append("S");
arLabel.append("");

arHSBid.append("78000");
arMinimiser.append("SS");
arLabel.append("");

arHSBid.append("26");
arMinimiser.append("K");
arLabel.append("");

arHSBid.append("73");
arMinimiser.append("J");
arLabel.append("");

arHSBid.append("74");
arMinimiser.append("J");
arLabel.append("");

arHSBid.append("66");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("67");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("68");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("69");
arMinimiser.append("C");
arLabel.append("");

arHSBid.append("75");
arMinimiser.append("K");
arLabel.append("");

arHSBid.append("76");
arMinimiser.append("K");
arLabel.append("");

arHSBid.append("4101");
arMinimiser.append("J");
arLabel.append("");

arHSBid.append("41145");
arMinimiser.append("J");
arLabel.append("");

arHSBid.append("41143");
arMinimiser.append("R");
arLabel.append("");

arHSBid.append("41141");
arMinimiser.append("J");
arLabel.append("");

arHSBid.append("12");
arMinimiser.append("B");
arLabel.append("");

arHSBid.append("41147");
arMinimiser.append("R");
arLabel.append("");

arHSBid.append("10001");
arMinimiser.append("V");
arLabel.append("");




// bOnInsert
if (_bOnInsert){
	
	//showDialogOnce("_Default");
	PrEntity ssE("\nSelect a set of elements",Element());
			if (ssE.go())
			{
				Entity ents[0]; 
				ents = ssE.set(); 
				// turn the selected set into an array of elements
				for (int i=0; i<ents.length(); i++)
				{
					if (ents[i].bIsKindOf(ElementRoof()))
					{
						_Element.append((Element) ents[i]);
						
					
					}
				}
			}
	
	//PREPARE TO CLONING
	// declare tsl props 
	TslInst tsl;
	String sScriptName = scriptName();

	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Beam lstBeams[0];
	Entity lstEnts[1];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
		
	for(int i=0; i<_Element.length();i++){
		lstEnts[0] = _Element[i];
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
	}
	eraseInstance();
	return;	
	
}//END if (_bOnInsert)

//Check if there are elements selected. If not erase instance and return to drawing.
if(_Element.length()==0){
	reportMessage("\nNo Element Found");
	eraseInstance(); return;}

//Assign selected element to el.
Element el = _Element[0];

//make sure only one is added per element
TslInst tslElAll[] = el.tslInstAttached();
for ( int i = tslElAll.length()-1; i > -1 ; i--){
	if ( tslElAll[i].scriptName() == scriptName() && tslElAll[i].handle() != _ThisInst.handle())
	{	
		Element elTsl=tslElAll[i].element();
		String strEl;
		
		if(elTsl.bIsValid())strEl=elTsl.number();
		
		if(strEl==el.number()){
			tslElAll[i].dbErase();
			//eraseInstance();
			//return;
		}
	}
}

Group gpAll[] = el.groups();
Group gpFloor =gpAll[0].namePart(0) + "\\" +  gpAll[0].namePart(1);
Entity entsFloor[] = gpFloor.collectEntities(true, Beam(), _kModelSpace);
Beam bmsFloor[0];
for (int i=0; i<entsFloor.length(); i++)
{
	Beam bm = (Beam)entsFloor[i];
	if (bm.bIsValid()) bmsFloor.append(bm);
}



//get El area and write to subtype
PLine plEl=el.plEnvelope();
el.setSubType(String().formatUnit((plEl.area()/144),2,2)+" sqft");







//Create coordsys.
CoordSys csEl = el.coordSys();
assignToElementGroup(el,TRUE,0,'Z');






//Get all beams from this element.
Beam arBm[] = el.beam();

//On debug only
//Display all beams of the element.
if(_bOnDebug){
  Display dp(32);
  for(int i=0; i<arBm.length(); i++){
    dp.draw(arBm[i].realBody());
  }
}

int iFindSemi=el.number().find("-",0);
String strEleNumLeft=el.number().token(0,"-");
String strEleNumRight=el.number().token(1,"-");

//reportMessage("strEleNumLeft ="+strEleNumLeft+" ");
//reportMessage("strEleNumRight ="+strEleNumRight+" ");
//Loop over all beams.
for(int i=0; i<arBm.length(); i++){
	String sTemp;
	String strBeamSubLabel2=arBm[i].subLabel2();
	 arBm[i].setLabel(el.number());
	if(iFindSemi>0 && strBeamSubLabel2!=""){
		if(strBeamSubLabel2==strEleNumLeft || strBeamSubLabel2==strEleNumRight)    sTemp=arBm[i].subLabel2();
	}
	else sTemp=el.number();


	CoordSys csBm=arBm[i].coordSys();
	int nZ=csBm.vecZ().dotProduct(el.vecZ())<0?-1:1;
	if(nZ==-1){
		csBm=CoordSys(csBm.ptOrg(),csBm.vecX(),csBm.vecY(),csBm.vecZ()*nZ);
		arBm[i].setCoordSys(csBm);
	}

	
	Vector3d vMarkEnd=arBm[i].vecX();
	if(vMarkEnd.isParallelTo(el.vecY())){
		if(vMarkEnd.dotProduct(el.vecY())<0)vMarkEnd=-arBm[i].vecX();
	}
	else{
		if(vMarkEnd.dotProduct(el.vecX())<0)vMarkEnd=-arBm[i].vecX();
	}
	
	
	String strMarkC2=arBm[i].label()+"-"+arBm[i].subLabel();
	Mark mkProject2(arBm[i].ptCen()-(arBm[i].solidLength()/2-U(300))*vMarkEnd,arBm[i].vecZ(),strMarkC2);
	mkProject2.suppressLine();
	mkProject2.setTextPosition(0,0,0);
	//mkProject2.setTextHeight(U(7));
	arBm[i].addTool(mkProject2);
	
	

	String strLabel = "";
	String strHSBid = arBm[i].hsbId();
	int foundID = arHSBid.find(strHSBid );
	if (foundID>-1){
		strLabel=arLabel[foundID];
	}

	//arBm[i].setLabel(strLabel);

  //Define points on both sides of the beam
  Point3d ptBm1 = arBm[i].ptCen() - 0.5 * arBm[i].vecY() * arBm[i].dW();
  Point3d ptBm2 = arBm[i].ptCen() + 0.5 * arBm[i].vecY() * arBm[i].dW();
  //Define a line through those points in the vecX direction of this beam.
  Line lnBm1(ptBm1, arBm[i].vecX());
  Line lnBm2(ptBm2, arBm[i].vecX());

 


  //get the angle of the beam on the positive side of the beam Add a ">" sign to it (this is the token).
  String sCutAngle =arBm[i].strCutP() + ">";
  //filter the angle out of sCutAngle (0.00>30.00>). Get index 1 of the string use ">" as seperation sign.
  String sAngle = sCutAngle.token(0,">");
  //Convert angle to double
  double dAngle = sAngle.atof();
sAngle = abs(dAngle);

  if(abs(dAngle)>.001){
  	Point3d ptMark= arBm[i].ptCen()+(0.5*arBm[i].dL())*arBm[i].vecX();
  	Vector3d vecNormalFace = arBm[i].vecY();
	
	if (dAngle>0){
		sAngle = "/"+sAngle;
	}
	else{
		sAngle = "\\"+sAngle;
	}
    	Mark mark1( ptMark, vecNormalFace,sAngle );
	mark1.setTextPosition(0,-1,0);
    	arBm[i].addTool(mark1);
  }


  //get the angle of the beam on the positive side of the beam Add a ">" sign to it (this is the token).
  String sCutAngleN =arBm[i].strCutN() + ">";
  //filter the angle out of sCutAngle (0.00>30.00>). Get index 1 of the string use ">" as seperation sign.
  String sAngleN = sCutAngleN.token(0,">");
  //Convert angle to double
  double dAngleN = sAngleN.atof();
  sAngleN = abs(dAngleN);
  if(abs(dAngleN)>.001){
  	Point3d ptMark= arBm[i].ptCen()+(-0.5*arBm[i].dL())*arBm[i].vecX();
  	Vector3d vecNormalFace = arBm[i].vecY();
	
	if (dAngleN>0){
		sAngleN = "\\"+sAngleN;
	}
	else{
		sAngleN = "/"+sAngleN;
	}
    	Mark mark1( ptMark, vecNormalFace,sAngleN );
	mark1.setTextPosition(0,1,0);

    	//arBm[i].addTool(mark1);
  }

 //Filter all beams with a T-connection on this beam. dRange is 0.
  //Beam arBmT[] = arBm[i].filterBeamsTConnection(arBm, 0.5 * arBm[i].dW(), TRUE);
Beam arBmT[] = arBm[i].filterBeamsTConnection(bmsFloor, 0.5 * arBm[i].dW(), TRUE);
//__Converted to work on all beams in floor, not just this Element__CC_12June2014

  //Loop over all beams with a T-connection with male beam.
  for(int j=0; j<arBmT.length(); j++){
    //Eliminate head-to-head beams.
    if( arBmT[j].hasTConnection(arBm[i], 0.5 * arBm[i].dW(), TRUE) ) continue;

    //Vector in direction of centerpoint of male beam
    Vector3d vecNormalFace = arBmT[j].vecZ();
    Vector3d vOff = arBmT[j].vecX().crossProduct(el.vecZ()) ;
	
	if(vOff.dotProduct(arBmT[j].ptCen()-arBm[i].ptCen())>0)vOff=-vOff;  

   // if( arBmT[j].vecY().dotProduct(arBm[i].ptCen() - arBmT[j].ptCen()) < 0 ){
    //  vecNormalFace = -arBmT[j].vecY();
    //}
    //Point for plane to find intersection with lines.
    Point3d ptMarkPlane = arBmT[j].ptCen() + 0.5 * vecNormalFace * arBmT[j].dD(vecNormalFace);
    Point3d ptMarkEdge = arBmT[j].ptCen() + 0.5 * vOff * arBmT[j].dD(vOff);	

    //Define points on beam with a T-connection
    //Find intersection points with lines and a plane
    if (abs(lnBm1.vecX().dotProduct(arBmT[j].vecY()))<0.01 || !lnBm1.hasIntersection(Plane(ptMarkEdge, vOff) )) continue;
    if (abs(lnBm2.vecX().dotProduct(arBmT[j].vecY()))<0.01 || !lnBm2.hasIntersection(Plane(ptMarkEdge, vOff) ) ) continue;
    Point3d ptMark1 = lnBm1.intersect(Plane(ptMarkEdge, vOff),0);
    Point3d ptMark2 = lnBm2.intersect(Plane(ptMarkEdge, vOff),0);

	Plane pnTop(ptMarkPlane,vecNormalFace);
	
	ptMark1=ptMark1.projectPoint(pnTop,U(0));
	ptMark2=ptMark2.projectPoint(pnTop,U(0));
	

	String strMark = arBm[i].subLabel();

    Mark mark( ptMark1, ptMark2, vecNormalFace,strMark );
    //Add tool to the female beam of the T-connection.
    arBmT[j].addTool(mark);
  }
}



//Start Marking squash blocking packs
{
	// build lists of items to display
	
	Beam arBmAll[]=el.beam();
	Beam arBmBlk[]=el.vecZ().filterBeamsParallel(arBmAll);
	
	//Find each beam one by one in the pack
	for(int i=arBmBlk.length()-1;i>-1;i--)
	{
		Beam bm=arBmBlk[i];
		
		//int iCheck=arBmBlk.find(bm);
		//if(iCheck != i){
		//	arBmBlk.removeAt(i);
		//	continue;
		//}
		//int iCheck2=arBmAll.find(bm);
		//if(iCheck2 >-1){
		//	arBmAll.removeAt(i);
		//}
		if(1)
		{//new code		
			double dAdd=U(3);
			Body bdPack(bm.ptCen(), bm.vecX(), bm.vecY(), bm.vecZ(),U(200),bm.dW()+dAdd,bm.dH()+dAdd) ;

			
			for(int j=0;j<arBmAll.length();j++)
			{
				Beam bmJ=arBmAll[j];
				if(bmJ.vecX().isParallelTo(el.vecZ()))continue;
				if(bmJ.dH() < U(50))continue;
				
				Body bdJoist(bmJ.ptCen(), bmJ.vecX(), bmJ.vecY(), bmJ.vecZ(),bmJ.dL() - U(40),bmJ.dW(),bmJ.dH()) ;
				
				if(bdJoist.hasIntersection(bdPack))
				{
					//Mark it
					if(bmJ.vecX().isParallelTo(bm.vecY()))
					{
						Mark mark( bm.ptCen() - bm.vecY() * bm.dW()/2,bm.ptCen() + bm.vecY() * bm.dW()/2, bmJ.vecZ() ,"SB" );
	   					//Add tool to the female beam of the T-connection.
						bmJ.addTool(mark);
					}
					else if(bmJ.vecX().isParallelTo(bm.vecZ()))
					{
						Mark mark( bm.ptCen() - bm.vecZ() * bm.dH()/2,bm.ptCen() + bm.vecZ() * bm.dH()/2, bmJ.vecZ() ,"SB" );
	   					//Add tool to the female beam of the T-connection.
						bmJ.addTool(mark);
					}				
				}
			}	
		}
		else
		{
			Beam arBmCollect1[0],arBmCollect2[0];
			
			arBmCollect1.append(bm);
			arBmBlk.removeAt(i);
			
			int iSafe=0;
			while(1)
			{
				if(iSafe++ > 100)break;
				if(arBmCollect1.length() == 0)break;
				
				Beam arBmRange[]=arBmCollect1[0].filterBeamsCenterDistanceYZRange(arBmBlk,U(38.1),U(1));
				
				for(int j=0;j<arBmRange.length();j++)
				{
					int iFind=arBmBlk.find(arBmRange[j]);
					if(iFind > -1)arBmBlk.removeAt(iFind);
					arBmCollect1.append(arBmRange[j]);
				}
				
				if(arBmRange.length()==0)
				{
					arBmCollect2.append(arBmCollect1[0]);
					arBmCollect1.removeAt(0);
				}
			}
			
			//reset i
			i=arBmBlk.length()-1;
			
			
			
			Point3d arPtsCen[0];
			
			for(int j=0;j<arBmCollect2.length();j++)
			{
				Beam bm=arBmCollect2[j];		
				arPtsCen.append(bm.ptCen());
			}
			
			Point3d ptRef;
			ptRef.setToAverage(arPtsCen);
			
			
			Point3d arPty[0], arPtz[0];
			Vector3d vy =arBmCollect2[0].vecY(), vz =arBmCollect2[0].vecZ();
			
			for(int j=0;j<arBmCollect2.length();j++)
			{
				Beam bm=arBmCollect2[j];		
				arPty.append(bm.envelopeBody().extremeVertices(vy));
				arPtz.append(bm.envelopeBody().extremeVertices(vz));
			}
			arPty = Line(ptRef,vy).orderPoints(arPty);
			arPtz = Line(ptRef,vz).orderPoints(arPtz);	
			double dYZ[]={vy.dotProduct(arPty[arPty.length()-1] - arPty[0]),vz.dotProduct(arPtz[arPtz.length()-1] - arPtz[0])};
			double dAdd=U(3);
			
			Body bdPack(ptRef, vy.crossProduct(vz), vy,vz,U(20),dYZ[0]+dAdd,dYZ[1]+dAdd) ;
			//bdPack.vis(2);
			
			//PLine pl(ptRef+vy*dYZ[0]/2+vz*dYZ[1]/2,ptRef-vy*dYZ[0]/2-vz*dYZ[1]/2);
			//Display dp(2);
			//dp.draw(pl);	
			
			for(int j=0;j<arBmAll.length();j++)
			{
				Beam bm=arBmAll[j];
				if(bm.vecX().isParallelTo(el.vecZ()))continue;
				
				if(bm.envelopeBody().hasIntersection(bdPack))
				{
					//Mark it
					if(bm.vecX().isParallelTo(vy))
					{
						Mark mark( arPty[0], arPty[arPty.length()-1], bm.vecZ() ,"SB" );
	   					//Add tool to the female beam of the T-connection.
						bm.addTool(mark);
					}
					else if(bm.vecX().isParallelTo(vz))
					{
						Mark mark( arPtz[0], arPtz[arPtz.length()-1], bm.vecZ() ,"SB" );
	   					//Add tool to the female beam of the T-connection.
						bm.addTool(mark);
					}				
				}
			}	
		}			
	}
}
	












//place marble on origin of element. (only shown if no display is used in tsl)
_Pt0 = el.ptOrg();

Display dp(-1);
dp.textHeight(U(25));
dp.draw("M",_Pt0,el.vecX(),el.vecY(),-1,-1);

//change marble diameter
setMarbleDiameter(U(1));






























#End
#BeginThumbnail



























#End
#BeginMapX

#End