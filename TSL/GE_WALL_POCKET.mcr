#Version 8
#BeginDescription
Creates wall pocket on selected wall and based on given beam or point
V1.12__3June2018__Added additional king studs, dialog box popup upon beam selection, added 2x/4x/6x/8x/Custom stud sizes in pocket beams, overshoot pocket size with studs option, fixed kingstud intersecting parallel beam error
V1.11__7Mar2018__Added header to possible beams to stretch to.
V1.10__5Feb2018__Added plate types to be collected
V1.9__20 Oct 2015_RL_Studs under beam get supporting beam type. properly versioned
V1.8: 14 oct 2015_RL_Will stay within wall; changed king placement to be auto or forced; Will not delete king studs when on auto; bugfix on doubling studs; bufix on stud clean up, body was offset
v1.7: 23.jul.2012: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 12
#KeyWords 
#BeginContents

Unit (1,"inch");

//Allowed Sheet thicknesses for the gap//Add all the ones you want to use
String arSheetName[0];
String arSheetMat[0];
double dSheetThick[0];
arSheetName.append("Filler Sheet");arSheetMat.append("1/4 Filler");dSheetThick.append(U(0.25));
arSheetName.append("Filler Sheet");arSheetMat.append("1/2 OSB");dSheetThick.append(U(0.5));
arSheetName.append("Filler Sheet");arSheetMat.append("7/16 OSB");dSheetThick.append(U(0.4375));
arSheetName.append("Filler Sheet");arSheetMat.append("5/8 OSB");dSheetThick.append(U(0.625));
arSheetName.append("Filler Sheet");arSheetMat.append("3/4 Plywood");dSheetThick.append(U(0.75));

///Here we add all the post types you would like to use
String arName[0];
String arMat[0];
double ardW[0];
double ardH[0];

//	List to pick from;	Mat assigned;	Size Face 2;	Size Face 1(el.vecX())	
arName.append("4x4 Post");arMat.append("4x4");ardW.append(U(3.5));ardH.append(U(3.5));
arName.append("6x6 Post");arMat.append("6x6");ardW.append(U(5.5));ardH.append(U(5.5));


// counts propints, propstrings, propdoubles,
String arYN[]={"Yes","No"};

PropString strEmpty0(13,"  - - - - - - - - - - - - - - - -  ", "Studs"); 
strEmpty0.setReadOnly(TRUE);

double arMiddleStudSize[] = {U(1.5), U(2.5), U(3.5), U(5.5), U(7.25), U(1.5)};
String arMiddleStuds[] = {"2x","3x","4x","6x","8x", "Custom"};
PropString middleStudSize(14,arMiddleStuds,"  Pocket Stud Size"); 

PropDouble bmW(5,U(1.5),"    Stud Width (if Custom Size)");

PropString overShootPkt(16,arYN,"    Overshoot Pocket Size for Studs",0); 

PropDouble pkW(0,U(3),"  Pocket Width (A)"); 

String arKingLocation[]={"Auto","Both","Left","Right"};
PropString strKingLocation(6,arKingLocation,"  King Placement"); 
int nKingPlace=arKingLocation.find(strKingLocation);
if(nKingPlace==-1) nKingPlace=0;

String arExtraKingLocation[]={"Auto","Both","Left","Right", "None"};
PropString strExtraKingLocation(15,arExtraKingLocation,"  Additional King Placement"); 

PropString strEmpty1(0,"  - - - - - - - - - - - - - - - -  ", "Location and Size"); 
strEmpty1.setReadOnly(TRUE);

PropDouble pkH(1,U(9.25),"  Elevation of Beam in Wall (B)"); 

String arCalcFromChoices[]={"Top of Wall","Bottom of Wall"};

PropString strCalcFrom(1,arCalcFromChoices,"  Elevation taken from"); 

PropDouble gapSide(2,U(0),"  Gap Side"); 

PropDouble gapBot(3,U(0),"  Gap Bottom"); 

PropString strEmpty2(2,"  - - - - - - - - - - - - - - - -  ", "Extras"); 
strEmpty2.setReadOnly(TRUE);

PropInt nColor(0,-1,T("  Line Color")); 

PropString strSheetFill(3,arYN,"  Fill gaps with sheathing",0); 

PropString strAddPlate(4,arYN,"  Add plate below beam",1); 

String arPlateOptions[]={"to be cut", "to be kept full"};

PropString strEndStudsKeep(5, arPlateOptions ,"  Plates",1); 

int bKeepPlates = (strEndStudsKeep == arPlateOptions[0]) ? FALSE:TRUE;

//NC Prop
PropString strEmpty3(7,"  - - - - - - - - - - - - - - - -  ", "CNC Operations"); 
strEmpty3.setReadOnly(TRUE);

PropString arZonesMilled(8,"",T("  Zones to mill seperated  by ;")); 

PropInt nToolingIndex(1,0,T("  Tooling index")); 

String arSSide[]= {T("Left"),T("Right")};
int arNSide[]={_kLeft, _kRight};
PropString strSide(9,arSSide,T("  Side"),1); 
int nSide = arNSide[arSSide.find(strSide,0)];

String arSTurn[]= {T("Against course"),T("With course")};
int arNTurn[]={_kTurnAgainstCourse, _kTurnWithCourse};
PropString strTurn(10,arSTurn,T("  Turning direction"),0); 
int nTurn = arNTurn[arSTurn.find(strTurn,0)];

String arSOShoot[]= {T("No"),T("Yes")};
int arNOShoot[]={_kNo, _kYes};
PropString strOShoot(11,arSOShoot,T("  Overshoot"),0); 
int nOShoot = arNOShoot[arSOShoot.find(strOShoot,0)];

String arSVacuum[]= {T("No"),T("Yes")};
int arNVacuum[]={_kNo, _kYes};
PropString strVacuum(12,arSVacuum,T("  Vacuum"),0); 
int nVacuum = arNVacuum[arSVacuum.find(strVacuum,0)];

double dTPkW; // pocket length

Element el;
ElementWallSF elW;
Wall w;

double dElH;
double dElW;

//Create context command
String cntxCreatBms ="Re-calculate Pocket";

addRecalcTrigger(_kContext,cntxCreatBms);

if(_bOnInsert)
{
	if(insertCycleCount()>2)eraseInstance();
	_Element.append(getElement("\nSelect a Stud Framed Wall"));

	el =_Element[0];
	elW =(ElementWallSF)el;
	w =(Wall)el;

	if(!elW.bIsValid())
	{
		reportWarning("\nNot a proper Stickframe Element selected.");
		eraseInstance();
		return;
	}

	dElH = w.baseHeight();
	dElW = el.dBeamWidth();

    if (_Element.length() == 0)
    {
        reportMessage("\nNo Element found");
        eraseInstance();return;
    }

	Map mpBmHandles;
	Beam bmIntersect;

	PrEntity ssE("\nSelect a Beam OR press Enter to select a point for the pocket",Beam());
 	if (ssE.go()) 
    { 
		Entity ents[0];
   		ents = ssE.set(); 
   		for (int i=0; i<ents.length(); i++) 
        { 
			Beam bm = (Beam)ents[i];
			if(bm.bIsValid())
            {
				_Beam.append(bm);
            	mpBmHandles.appendString(bm.handle(),bm.handle());
			}
		}
	}

	if(_Beam.length()==0){
		_Pt0=(getPoint("\nSelect Point"));
		showDialogOnce();
	}
	else 
	{
        //make sure beam selection is good
        _Map.appendMap("BmHandles",mpBmHandles);
         Vector3d vBm=_Beam[0].vecX();

        Map mpHandlesToTake=_Map.getMap("BmHandles");
        
        for (int i=_Beam.length()-1; i>-1; i--)
		{
            if(! mpHandlesToTake.hasString(_Beam[i].handle()))_Beam.removeAt(i);
        }

        int nPassed=1;
        Body bdCombined;

        if(_Beam.length()==0) nPassed=0;
        
        for (int i=0; i<_Beam.length(); i++)
		{
            Beam bm1=_Beam[i];
            
            bdCombined += bm1.envelopeBody();
            int bIsGood=0;
            Body bdThis(bm1.ptCen(),bm1.vecX(),bm1.vecY(),bm1.vecZ(),bm1.dL(),bm1.dD(bm1.vecY())+U(0.1),bm1.dD(bm1.vecZ())+U(0.1),0,0,0);
            
            if(_Beam.length()==1)
			{
                bIsGood=1;
                break;
            }
            
            for (int j=0; j<_Beam.length(); j++) {
                if(i==j)continue;
                Beam bm2=_Beam[j];
                Body bdOther(bm2.ptCen(),bm2.vecX(),bm2.vecY(),bm2.vecZ(),bm2.dL(),bm2.dD(bm2.vecY())+U(0.1),bm2.dD(bm2.vecZ())+U(0.1),0,0,0);
                
                if(bdThis.hasIntersection(bdOther) && bm2.vecX().isParallelTo(vBm)){
                    bIsGood=1;
                    break;
                }
            }
            
            if(!bIsGood){
                nPassed=0;
                break;
            }
        } 

        if(nPassed)
		{
            //remove wall faces
            Body bdOut(el.ptOrg(),el.vecX(),el.vecY(),el.vecZ(),U(5000),U(5000),U(1000),0,0,1);
            Body bdIn(el.ptOrg()-el.vecZ()*el.dBeamWidth(),el.vecX(),el.vecY(),-el.vecZ(),U(5000),U(5000),U(1000),0,0,1);
            bdCombined-=bdOut;
            bdCombined-=bdIn;	
            //remove wall ends
            Point3d arPtWEnds[]={elW.ptStartOutline(), elW.ptEndOutline()};
            arPtWEnds=Line(el.ptOrg(),el.vecX()).orderPoints(arPtWEnds);
			
            if(arPtWEnds.length()==2)
			{
                Body bdL(arPtWEnds[0],el.vecX(),el.vecY(),el.vecZ(),U(5000),U(5000),U(1000),-1,0,0);
                Body bdR(arPtWEnds[1],el.vecX(),el.vecY(),-el.vecZ(),U(5000),U(5000),U(1000),1,0,0);
                bdCombined-=bdL;
                bdCombined-=bdR;	
            }
            
            Point3d arPtExtremY[]=bdCombined.extremeVertices(el.vecY());
            Point3d arPtExtremX[]=bdCombined.extremeVertices(el.vecX());
            
            double dPW=U(0),dPH=U(0);
            if(arPtExtremX.length()>1)
			{
                dPW=abs(el.vecX().dotProduct(arPtExtremX[0]-arPtExtremX[1]));
                
                pkW.set(dPW);
                _Pt0=arPtExtremX[0]+el.vecX()*dPW/2;
            }
            if(arPtExtremY.length()>1)
			{
                dPH=abs(el.vecY().dotProduct(arPtExtremY[0]-el.ptOrg()));
                
                pkH.set(dPH);
                pkH.setReadOnly(TRUE);
                
                strCalcFrom.set(arCalcFromChoices[1]);
                strCalcFrom.setReadOnly(TRUE);
            }	

            showDialogOnce();
            pkW.set(dPW);
			pkH.set(dPH);
			strCalcFrom.set(arCalcFromChoices[1]);
        }
        else
		{
            reportWarning("\n\nBeam selection is not correct.\n\nPlease adjust pocket in the OPM.");
            _Beam.setLength(0);
        }
    }
}


if(_bOnElementListModified){
	//wall might have been split
	
	for(int i=_Element.length()-1;i>-1;i--){
		ElementWall elW=(ElementWall)_Element[i];
		if(! elW.bIsValid()){
			_Element.removeAt(i);
			continue;
		}
		Point3d arPt[]={elW.ptStartOutline(),elW.ptEndOutline()};
		
		if(elW.vecX().dotProduct(arPt[0]-_Pt0) * elW.vecX().dotProduct(arPt[1]-_Pt0) <0){
			_Element[0]=elW;
			_Element.setLength(1);
			break;
		}
	}
	if(_Element.length()!=1)eraseInstance();	
}

// Set Stud's X Length
if (middleStudSize != "Custom")
{	
	bmW.set(arMiddleStudSize[arMiddleStuds.find(middleStudSize)]);
}
// creates bigger pocket for bigger beam
if (pkW < bmW)
{
	pkW.set(bmW);
}

// creates overshoot
if (overShootPkt == "Yes"&& bmW != U(0))
{
	double newWidth = 0;
	while (1)
	{
		if (newWidth < pkW)
		{
			newWidth += bmW;
		}
		else
		{
			break;
		}
	}
	pkW.set(newWidth);
}


if(_bOnInsert || _bOnElementConstructed || _kExecuteKey==cntxCreatBms ){
	//Clear beams in Map
	Map mpClear;
	if(_Map.hasMap("mpBm"))
		mpClear=_Map.getMap("mpBm");
	
	Entity entPanHand;
	
	int bEraseAll=1;
	GenBeam entsErase[0];
	
	for (int i=0; i<mpClear.length(); i++) {
		if(mpClear.hasEntity("bm"+i))
		{
			Entity ent=mpClear.getEntity("bm"+i);
			
			Beam gbEnt=(Beam)ent;
			
			if(gbEnt.panhand().bIsValid()){
				entPanHand=gbEnt.panhand();
				bEraseAll=0;
			}
			entsErase.append(gbEnt);
		}
	}
	
	if(bEraseAll){
		for (int i=0; i<entsErase.length(); i++) entsErase[i].dbErase();	
		_Map.removeAt("mpBm",1);
	}
	else{
		for (int i=0; i<entsErase.length(); i++) {
			entsErase[i].setPanhand(entPanHand);
			entsErase[i].setColor(3);
		}
		return;
	}
}


dTPkW=(pkW+gapSide*2)+U(0.0125);//added tolerance V1.2

assignToElementGroup(el,TRUE,0,'Z');
Display dp(nColor);

//Display
////ptCreate is at end of pocket
//Move _Pt0
Plane pnElBase(el.ptOrg(),el.vecY());
Plane pnElCen(el.ptOrg()-el.vecZ()*el.dBeamWidth()/2,el.vecZ());

_Pt0=_Pt0.projectPoint(pnElBase,U(0));
_Pt0=_Pt0.projectPoint(pnElCen,U(0));



//Check to see if it is on end of panel
Point3d ptEnds[]={elW.ptEndOutline(),elW.ptStartOutline()};
if(el.vecX().dotProduct(ptEnds[0]-ptEnds[1])>0)ptEnds.swap(0,1);
ptEnds[0].vis(3);
double dSizeEndCheck=pkW/2+gapSide;

double dStart=el.vecX().dotProduct(_Pt0-ptEnds[0]);
double dEnd=el.vecX().dotProduct(ptEnds[1]-_Pt0);


int doKingLeft=TRUE;
int doKingRight=TRUE;
int doExtraKingLeft= TRUE;
int doExtraKingRight=TRUE;

if(dStart<dSizeEndCheck+U(0.01))
{
	_Pt0=_Pt0.projectPoint(Plane(ptEnds[0]+el.vecX()*dSizeEndCheck,el.vecX()),U(0));
	doKingLeft=FALSE;
	doExtraKingLeft = FALSE;
}
else if(dStart<dSizeEndCheck+U(1.51))
{
	doKingLeft=FALSE;
	doExtraKingLeft=FALSE;
}
else if(dStart<dSizeEndCheck+U(3.01))
{
	doExtraKingLeft=FALSE;
}

if(dEnd<dSizeEndCheck+U(0.01))
{
	_Pt0=_Pt0.projectPoint(Plane(ptEnds[1]-el.vecX()*dSizeEndCheck,el.vecX()),U(0));
	doKingRight=FALSE;
	doExtraKingLeft = FALSE;
}
else if(dEnd<dSizeEndCheck+U(1.51))
{
	doKingRight=FALSE;
	doExtraKingLeft=FALSE;
}
else if(dEnd<dSizeEndCheck+U(3.01))
{
	doExtraKingRight=FALSE;
}

PLine plX1(_Pt0 - dElW/2*el.vecZ() - dTPkW/2*el.vecX() , _Pt0 + dElW/2*el.vecZ() + dTPkW/2*el.vecX());
PLine plX2(_Pt0 + dElW/2*el.vecZ() - dTPkW/2*el.vecX() , _Pt0 - dElW/2*el.vecZ() + dTPkW/2*el.vecX());

dp.draw(plX1);
dp.draw(plX2);

if(nKingPlace !=0)
{
    
	if ((strKingLocation == "Left" & strExtraKingLocation == "Right") || (strKingLocation == "Right" & strExtraKingLocation == "Left"))
	{
		strKingLocation.set("Both");
		strExtraKingLocation.set("None");
	}

	if(strExtraKingLocation == "Both")
	{
		doExtraKingRight = doExtraKingLeft = true;
	}
	else if(strExtraKingLocation == "Left")
	{
		doExtraKingLeft = true;
		doExtraKingRight = false;
	}
	else if(strExtraKingLocation == "Right")
	{
		doExtraKingLeft = false;
		doExtraKingRight = true;
	}

	if(strKingLocation == "Both" || (strKingLocation == "Left" & strExtraKingLocation == "Right") || (strKingLocation == "Right" & strExtraKingLocation == "Left"))
	{
		doKingRight = doKingLeft = true;
	}
	else if(strKingLocation == "Left")
	{
		doKingLeft = true;
		doKingRight = false;
		doExtraKingRight = false;
	}
	else if(strKingLocation == "Right")
	{
		doKingLeft = false;
		doKingRight = true;
		doExtraKingLeft = false;
	}
	if (strExtraKingLocation == "None")
	{
		doExtraKingRight = false;
		doExtraKingLeft = false;
	}
}
else
{
    if (strExtraKingLocation == "None")
	{
		doExtraKingRight = false;
		doExtraKingLeft = false;
	}

	//see if it goes into important framing
	Beam arBmVert[]=el.vecX().filterBeamsPerpendicularSort(el.beam());
	int iTypesKeep[]={ _kKingPost, _kKingStud, _kSFSupportingBeam, _kPost};
	
	for(int x=arBmVert.length()-1;x>-1;x--)
	{
		Beam bm=arBmVert[x];
		if(iTypesKeep.find(bm.type()) > -1)
		{
			continue;
		}
		if(bm.panhand().bIsValid())
		{
			continue;
		}
			
		arBmVert.removeAt(x);
	}
	
	Point3d ptRefLeft = _Pt0 - dTPkW/2*el.vecX() , ptRefRight = _Pt0 + dTPkW/2*el.vecX();
	
	for(int i=0;i<arBmVert.length();i++)
	{
		Point3d pts[]=arBmVert[i].envelopeBody().extremeVertices(el.vecX());
		double ddL = el.vecX().dotProduct(ptRefLeft - pts[1]);
		double ddR = el.vecX().dotProduct(pts[0] - ptRefRight);
		if(ddL > U(0) && ddL < U(1.5))doKingLeft = false;
		if(ddR > U(0) && ddR < U(1.5))doKingRight = false;
	}
	
	
}

//Set proper height

if(strCalcFrom==arCalcFromChoices[0])
{
	PLine plWall=el.plEnvelope();
	plWall.vis(1);
	
	Point3d arPtInt[]=plWall.intersectPoints(Plane(_Pt0,el.vecX()));
	if(arPtInt.length()>1){
		if(arPtInt[0].Z()>arPtInt[1].Z())dElH=el.vecY().dotProduct(arPtInt[0]-el.ptOrg());
		else dElH=el.vecY().dotProduct(arPtInt[1]-el.ptOrg());
	}
}

Plane pnPk;

double dJSize=U(1);
double dBmSize=pkH+gapBot;
if(strCalcFrom==arCalcFromChoices[0])dJSize=dElH-pkH;
else {
	dJSize=pkH;
	dBmSize=dElH-(pkH-gapBot);
}

pnPk=Plane(_Pt0+dJSize*el.vecY(),el.vecY());

Point3d ptRef=_Pt0.projectPoint(pnPk,U(0));
ptRef.transformBy(-el.vecY()*gapBot);
Point3d ptMillRef = ptRef;
//Move for extra plate
if(strAddPlate==arYN[0])ptRef.transformBy(-el.vecY()*U(1.5));


///Select some element beams
//all beams
Beam arBm[] = el.beam();
//beams to stretch to
Beam arBmH[0];
//beams to split and cut
Beam arBmHFix[0];
//beams to delete if in the way
Beam arBmV[]=el.vecX().filterBeamsPerpendicular(arBm);

//types to fix in arBmHFix
int arTypesToFix[]={_kSFBlocking, _kBlocking};
if(!bKeepPlates){
	
	arTypesToFix.append( _kTopPlate);
	arTypesToFix.append( _kSFTopPlate);	
	arTypesToFix.append( _kSFAngledTPLeft);
	arTypesToFix.append( _kSFAngledTPRight);
	arTypesToFix.append( _kSFVeryTopPlate);
}
else
{
	// Check if beams (if provided) will interfiere with plates, then those must be splited anyway
	int bInterference= false;
	if( _Beam.length() > 0)
	{
		Body dbBeamToCheck;
		for( int b=0; b< _Beam.length(); b++)
		{
			dbBeamToCheck.combine( _Beam[b].realBody());
		}	
		Beam bmAllHorizontals[]= el.vecX().filterBeamsParallel( arBm);
		for( int b=0; b< bmAllHorizontals.length(); b++)
		{
			Beam bm= bmAllHorizontals[b];bm.envelopeBody().vis();
			int nType= bm.type();
			if( nType == _kTopPlate || nType == _kSFTopPlate || nType == _kSFAngledTPLeft || nType == _kSFAngledTPRight || nType == _kSFVeryTopPlate)
			{
				Body bdBm= bm.envelopeBody();
				if( bdBm.hasIntersection( 	dbBeamToCheck))
				{
					bInterference= true;
					reportMessage("\ninterfierence");
				}
			}
		}
	}
	
	if( bInterference)
	{
		arTypesToFix.append( _kTopPlate);
		arTypesToFix.append( _kSFTopPlate);	
		arTypesToFix.append( _kSFAngledTPLeft);
		arTypesToFix.append( _kSFAngledTPRight);
		arTypesToFix.append( _kSFVeryTopPlate);
	}
}

//Count the amount of panhands
int nPanHandCount=0;
for(int i=0; i<arBm.length(); i++) {
	Entity ent=arBm[i].panhand();
	if(ent.bIsValid())nPanHandCount++;
	
	int arTypeIgnor[]={ _kSFBlocking, _kBlocking};	
	if(arBm[i].vecX().isParallelTo(el.vecX()) && arTypeIgnor.find(arBm[i].type())==-1)arBmH.append(arBm[i]);
	if(arBm[i].type()== _kSFAngledTPLeft || arBm[i].type()== _kSFAngledTPRight ||  arBm[i].type()== _kSFTopPlate ||  arBm[i].type()== _kSFBottomPlate || arBm[i].type() == _kHeader) arBmH.append(arBm[i]);
	
	if(arTypesToFix.find(arBm[i].type()) > -1){
		arBmHFix.append(arBm[i]);
		arBm[i].realBody().vis(3);
	}

}
Beam arAllBeams[0];
arAllBeams.append(arBmH);
arAllBeams.append(_Beam);

if(arBm.length()-nPanHandCount<1){
	
	//simply draw lines and return to drawing
	
	PLine pl1,pl2,pl3,pl4,pl5,pl6,pl7,pl8;
	pl1=PLine(ptRef-el.vecX()*pkW/2+el.vecZ()*el.dBeamWidth()/2,ptRef+el.vecX()*pkW/2-el.vecZ()*el.dBeamWidth()/2) ;
	pl2=PLine(ptRef+el.vecX()*pkW/2+el.vecZ()*el.dBeamWidth()/2,ptRef-el.vecX()*pkW/2-el.vecZ()*el.dBeamWidth()/2) ;
	
	dp.draw(pl1);
	dp.draw(pl2);
	
	if(doKingLeft){
		pl3.createRectangle(LineSeg(ptRef-el.vecX()*pkW/2+el.vecZ()*el.dBeamWidth()/2,ptRef-el.vecX()*(pkW/2+U(1.5))-el.vecZ()*el.dBeamWidth()/2),el.vecX(),el.vecZ());
		pl4=PLine(ptRef-el.vecX()*pkW/2+el.vecZ()*el.dBeamWidth()/2,ptRef-el.vecX()*(pkW/2+U(1.5))-el.vecZ()*el.dBeamWidth()/2);
		pl5=PLine(ptRef-el.vecX()*pkW/2-el.vecZ()*el.dBeamWidth()/2,ptRef-el.vecX()*(pkW/2+U(1.5))+el.vecZ()*el.dBeamWidth()/2);
		dp.draw(pl3);
		dp.draw(pl4);
		dp.draw(pl5);
		
		if(nKingPlace==1){
			pl3.transformBy(-el.vecX()*U(1.5));
			pl4.transformBy(-el.vecX()*U(1.5));
			pl5.transformBy(-el.vecX()*U(1.5));
			dp.draw(pl3);
			dp.draw(pl4);
			dp.draw(pl5);
		}
	}
	if(doKingRight){
		pl6.createRectangle(LineSeg(ptRef+el.vecX()*pkW/2+el.vecZ()*el.dBeamWidth()/2,ptRef+el.vecX()*(pkW/2+U(1.5))-el.vecZ()*el.dBeamWidth()/2),el.vecX(),el.vecZ());
		pl7=PLine(ptRef+el.vecX()*pkW/2+el.vecZ()*el.dBeamWidth()/2,ptRef+el.vecX()*(pkW/2+U(1.5))-el.vecZ()*el.dBeamWidth()/2);
		pl8=PLine(ptRef+el.vecX()*pkW/2-el.vecZ()*el.dBeamWidth()/2,ptRef+el.vecX()*(pkW/2+U(1.5))+el.vecZ()*el.dBeamWidth()/2);
		dp.draw(pl6);
		dp.draw(pl7);
		dp.draw(pl8);
		if(nKingPlace==2){
			pl6.transformBy(el.vecX()*U(1.5));
			pl7.transformBy(el.vecX()*U(1.5));
			pl8.transformBy(el.vecX()*U(1.5));
			dp.draw(pl6);
			dp.draw(pl7);
			dp.draw(pl8);
		}
	}	
	return;
}

//define how many pieces are needed under the beam
int nStudQty=dTPkW/bmW;
double dRest=dTPkW-nStudQty*bmW;

//Use these indexes
int arIndexesSheet[0];

//add some sheeting
if(dRest>U(0.125) && strSheetFill==arYN[0]){

	//Adding the Sheeting
	Beam bmSheet;
	int nSheet1=-1,nSheet2=-1,nSheet3=-1,nSheet4=-1;
	double dSmallest=U(10),dLargest=0;
	for (int i=1; i<dSheetThick.length(); i++) {
		if(dSheetThick[i]<dSmallest)dSmallest=dSheetThick[i];
		if(dSheetThick[i]>dLargest)dLargest=dSheetThick[i];
		//direct match
		int nSheetMatchCount=dRest/dSheetThick[i];
		if(abs(nSheetMatchCount*dSheetThick[i] - dRest)<U(0.01)){
			for (int c=0; c<nSheetMatchCount; c++) {
				arIndexesSheet.append(i);
			}
			break;
		}	
	}
	
	Map mpScenarios;
	double dSmallestLeft=U(2000);
	int mpIndex=0;
	if(dRest>dSmallest && arIndexesSheet.length()==0){
		double dleftOver=dRest;
		for (int i=0; i<dSheetThick.length(); i++) {
			double dDiff1=dRest-dSheetThick[i];
			if(dDiff1<dleftOver && dDiff1>U(-0.01)){
				dleftOver=dDiff1;
				nSheet1=i;
				nSheet2=-1;
				nSheet3=-1;
				nSheet4=-1;
				
				if(dleftOver<dSmallest){//make a new map
					Map mp;
					mp.appendInt("ShCount",1);
					mp.appendDouble("dLeft",dleftOver);
					mp.appendInt("nSheet1",i);
					mp.appendInt("nSheet2",-1);
					mp.appendInt("nSheet3",-1);
					mp.appendInt("nSheet4",-1);
					mpScenarios.appendMap("mpSh"+mpIndex,mp);
					mpIndex++;
					if(dleftOver<dSmallestLeft)dSmallestLeft=dleftOver;
				}
			}
			for (int j=0; j<dSheetThick.length(); j++) {
				double dDiff2=dRest-(dSheetThick[i]+dSheetThick[j]);
				if(dDiff2<dleftOver && dDiff2>U(-0.01)){
					dleftOver=dDiff2;	
					nSheet1=i;
					nSheet2=j;
					nSheet3=-1;
					nSheet4=-1;	
					
					if(dleftOver<dSmallest){//make a new map
						Map mp;
						mp.appendInt("ShCount",2);
						mp.appendDouble("dLeft",dleftOver);
						mp.appendInt("nSheet1",i);
						mp.appendInt("nSheet2",j);
						mp.appendInt("nSheet3",-1);
						mp.appendInt("nSheet4",-1);
						mpScenarios.appendMap("mpSh"+mpIndex,mp);
						mpIndex++;
						if(dleftOver<dSmallestLeft)dSmallestLeft=dleftOver;
					}
				}
				for (int k=0; k<dSheetThick.length(); k++) {
					double dDiff3=dRest-(dSheetThick[i]+dSheetThick[j]+dSheetThick[k]);
					if(dDiff3<dleftOver && dDiff3>U(-0.01)){
						dleftOver=dDiff3;	
						nSheet1=i;
						nSheet2=j;	
						nSheet3=k;
						nSheet4=-1;
						
						if(dleftOver<dSmallest){//make a new map
							Map mp;
							mp.appendInt("ShCount",3);
							mp.appendDouble("dLeft",dleftOver);
							mp.appendInt("nSheet1",i);
							mp.appendInt("nSheet2",j);
							mp.appendInt("nSheet3",k);
							mp.appendInt("nSheet4",-1);
							mpScenarios.appendMap("mpSh"+mpIndex,mp);
							mpIndex++;
							if(dleftOver<dSmallestLeft)dSmallestLeft=dleftOver;
						}
					}
					for (int r=0; r<dSheetThick.length(); r++) {
						double dDiff4=dRest-(dSheetThick[i]+dSheetThick[j]+dSheetThick[k]+dSheetThick[r]);
						if(dDiff4<0)break;
						if(dDiff4<dleftOver && dDiff4>U(-0.01)){
							dleftOver=dDiff4;	
							nSheet1=i;
							nSheet2=j;	
							nSheet3=k;
							nSheet4=r;
							
							if(dleftOver<dSmallest){//make a new map
								Map mp;
								mp.appendInt("ShCount",3);
								mp.appendDouble("dLeft",dleftOver);
								mp.appendInt("nSheet1",i);
								mp.appendInt("nSheet2",j);
								mp.appendInt("nSheet3",k);
								mp.appendInt("nSheet4",r);
								mpScenarios.appendMap("mpSh"+mpIndex,mp);
								mpIndex++;
								if(dleftOver<dSmallestLeft)dSmallestLeft=dleftOver;
							}
						}
					}
				}	
			}
		}
	}
	
	int nTake=-1;
	int nShQty=5;
	for (int s=0; s<mpScenarios.length(); s++) {
		Map mp=mpScenarios.getMap("mpSh"+s);
		
		double dd=mp.getDouble("dLeft");
		int n=mp.getInt("ShCount");
		
		if(abs(dd-dSmallestLeft)<U(0.01) && n<nShQty){
			nSheet1=mp.getInt("nSheet1");
			nSheet2=mp.getInt("nSheet2");
			nSheet3=mp.getInt("nSheet3");
			nSheet4=mp.getInt("nSheet4");
			nShQty=n;
		}
	}

	if(nSheet1!=-1)arIndexesSheet.append(nSheet1);
	if(nSheet2!=-1)arIndexesSheet.append(nSheet2);	
	if(nSheet3!=-1)arIndexesSheet.append(nSheet3);	
	if(nSheet4!=-1)arIndexesSheet.append(nSheet4);		
}

///List of supporting members and props
double arDx[0];
String arIds[0];
int arTypes[0];
String arMats[0];
String arNames[0];	

int nSheetQty=arIndexesSheet.length();

if(nSheetQty>nStudQty){
	for(int i=0;i<nSheetQty;i++){
		
		if(i<=nSheetQty){
			arDx.append( dSheetThick[arIndexesSheet[i]]);
			arIds.append("25000");
			arTypes.append(_kSheeting);
			arMats.append(arSheetMat[arIndexesSheet[i]]);
			arNames.append(arSheetName[arIndexesSheet[i]]);	
		}
		if(i<=nStudQty-1){
			arDx.append( bmW);
			arIds.append("114");
			arTypes.append( _kSFSupportingBeam );
			arMats.append("Stud");
			arNames.append("Stud");	
		}
	}
}
else
{
	for(int i=0;i<nStudQty;i++){

		if(i<=nStudQty){
			arDx.append( bmW);
			arIds.append("114");
			arTypes.append(_kSFSupportingBeam);
			arMats.append("Stud");
			arNames.append("Stud");
		}
		if(i<nSheetQty){
			arDx.append( dSheetThick[arIndexesSheet[i]]);
			arIds.append("25000");
			arTypes.append(_kSheeting);
			arMats.append(arSheetMat[arIndexesSheet[i]]);
			arNames.append(arSheetName[arIndexesSheet[i]]);	
		}
	}
}	


//check if an end stud needs to be full
int bFullLeft=0,bFullRight=0;

if(bKeepPlates && !doKingLeft)bFullLeft=1;
if(bKeepPlates && !doKingRight)bFullRight=1;

if(bFullLeft && arDx[0]<U(1.49) && arDx.length()>1){
	arDx.swap(0,1);
	arIds.swap(0,1);
	arTypes.swap(0,1);
	arMats.swap(0,1);
	arNames.swap(0,1);	
}

int nLast=arDx.length()-1;

if(bFullRight && arDx[nLast]<U(1.49) && arDx.length()>1){
	arDx.swap(nLast,nLast-1);
	arIds.swap(nLast,nLast-1);
	arTypes.swap(nLast,nLast-1);
	arMats.swap(nLast,nLast-1);
	arNames.swap(nLast,nLast-1);	
}

//Map to delete beams
Map mp;

//Start creating beams
Point3d ptCreate=ptRef-el.vecX()*dTPkW/2;

String strModule="Pk_Wall_"+el.number()+"_"+ _ThisInst.handle();
int nMapKey=0;

if(_bOnInsert || _bOnElementConstructed || _kExecuteKey==cntxCreatBms)
{

		// Get props from ANY stud (not part of an assembly) to set them on created STUDS
	Beam bmAny;
	for( int b=0; b< arBm.length(); b++)
	{
		Beam bm= arBm[b];
		if( bm.type() == _kStud && bm.information() == "")
		{
			bmAny=bm;
			break;
		}
	}
	
	String sNewStudLabel;
	String sNewStudSubLabel;
	String sNewStudSubLabel2;
	String sNewStudGrade;
	String sNewStudMaterial;
	String sNewStudInformation;
	String sNewStudBeamCode;
	String sNewStudName;
	

	if(bmAny.bIsValid())
	{
		sNewStudLabel= bmAny.label();
		sNewStudSubLabel= bmAny.subLabel();
		sNewStudSubLabel2= bmAny.subLabel2();
		sNewStudGrade= bmAny.grade();
		sNewStudMaterial= bmAny.material();
		sNewStudBeamCode= bmAny.beamCode();
		sNewStudName= bmAny.name();
		sNewStudInformation= "";
	}

	if(doKingLeft)
	{
		Beam bm1;
		bm1.dbCreate(ptCreate,-el.vecY(),el.vecZ(),el.vecX(),U(12),dElW,U(1.5),1,0,-1);
		bm1.setColor(2);	
		bm1.setHsbId("114");	
		bm1.setType(_kStud);
		bm1.setModule(strModule);
		bm1.setInformation("");

		bm1.setName(sNewStudName);	
		bm1.setMaterial(sNewStudMaterial);
		bm1.setGrade(sNewStudGrade);
		bm1.setLabel(sNewStudLabel);
		bm1.setSubLabel(sNewStudSubLabel);
		bm1.setSubLabel2(sNewStudSubLabel2);
		bm1.setBeamCode(sNewStudBeamCode);
		bm1.assignToElementGroup(el,true,0,'Z');
			
		//find where to stretch to
		Point3d ptLine=ptCreate-el.vecX()*U(0.75)+(dElW/2-U(0.75))*el.vecZ();
		Beam arBmStretch1[]=Beam().filterBeamsHalfLineIntersectSort(arBmH,ptLine,-el.vecY());
		Beam arBmStretch2[]=Beam().filterBeamsHalfLineIntersectSort(arAllBeams,ptLine,el.vecY());
		if(arBmStretch1.length()>0)bm1.stretchDynamicTo(arBmStretch1[0]);
		if(arBmStretch2.length()>0)bm1.stretchDynamicTo(arBmStretch2[0]);	
		
		//Set to a map
		mp.appendEntity("Bm"+nMapKey,bm1);
		nMapKey++;
		
        		
        if(doExtraKingLeft) // added v1.12
		{
			Point3d kingPtCreate = ptCreate - el.vecX()*U(1.5);

			Beam bm1;
			bm1.dbCreate(kingPtCreate,-el.vecY(),el.vecZ(),el.vecX(),U(12),dElW,U(1.5),1,0,-1);
			bm1.setColor(2);	
			bm1.setHsbId("114");	
			bm1.setType(_kStud);
			bm1.setModule(strModule);
			bm1.setInformation("");

			bm1.setName(sNewStudName);	
			bm1.setMaterial(sNewStudMaterial);
			bm1.setGrade(sNewStudGrade);
			bm1.setLabel(sNewStudLabel);
			bm1.setSubLabel(sNewStudSubLabel);
			bm1.setSubLabel2(sNewStudSubLabel2);
			bm1.setBeamCode(sNewStudBeamCode);
			bm1.assignToElementGroup(el,true,0,'Z');
				
			//find where to stretch to
			Point3d ptLine=kingPtCreate-el.vecX()*U(0.75)+(dElW/2-U(0.75))*el.vecZ();
			Beam arBmStretch1[]=Beam().filterBeamsHalfLineIntersectSort(arBmH,ptLine,-el.vecY());
			Beam arBmStretch2[]=Beam().filterBeamsHalfLineIntersectSort(arAllBeams,ptLine,el.vecY());
			if(arBmStretch1.length()>0)bm1.stretchDynamicTo(arBmStretch1[0]);
			if(arBmStretch2.length()>0)bm1.stretchDynamicTo(arBmStretch2[0]);	
			
			//Set to a map
			mp.appendEntity("Bm"+nMapKey,bm1);
			nMapKey++;
		} 
	} 
	
	Beam bmPlate;
	
	// Plates under pocket
	if(strAddPlate==arYN[0]){
		Beam bm1;
		bm1.dbCreate(ptCreate,el.vecX(),el.vecZ(),el.vecY(),dTPkW,dElW,U(1.5),1,0,1);
		bm1.setColor(2);	
		bm1.setHsbId("12");	
		bm1.setType(_kSFBlocking);
		bm1.setName("Pocket Block");	
		bm1.setMaterial("Blocking");
		bm1.assignToElementGroup(el,true,0,'Z');		
		bm1.setModule(strModule);
		
		//Set to a map
		mp.appendEntity("Bm"+nMapKey,bm1);
		nMapKey++;	
		
		bmPlate=bm1;
	}
	
	double dGrow=U(0);
	
	// Verticals under pocket
	for(int i=0;i<arDx.length();i++){
		Beam bm1;
		ptCreate.vis(i);
		bm1.dbCreate(ptCreate,-el.vecY(),el.vecZ(),el.vecX(),U(1),dElW,arDx[i],1,0,1);
		bm1.setColor(2);
		bm1.setHsbId(arIds[i]);	
		bm1.setType(arTypes[i]);
		bm1.setModule(strModule); 
		bm1.setInformation("");

		bm1.setName(sNewStudName);	
		bm1.setMaterial(sNewStudMaterial);
		bm1.setGrade(sNewStudGrade);
		bm1.setLabel(sNewStudLabel);
		bm1.setSubLabel(sNewStudSubLabel);
		bm1.setSubLabel2(sNewStudSubLabel2);
		bm1.setBeamCode(sNewStudBeamCode);
		bm1.assignToElementGroup(el,true,0,'Z');
	
		//find where to stretch to
		Point3d ptLine=ptCreate+el.vecX()*arDx[i]/2+(dElW/2-U(0.75))*el.vecZ();
		Beam arBmStretch1[]=Beam().filterBeamsHalfLineIntersectSort(arBmH,ptLine,-el.vecY());
		if(arBmStretch1.length()>0)bm1.stretchDynamicTo(arBmStretch1[0]);
		
		//If kept full on end
		if(bFullLeft && i==0){
			Beam arBmStretch2[]=Beam().filterBeamsHalfLineIntersectSort(arAllBeams,ptLine,el.vecY());
			if(arBmStretch2.length()>0)bm1.stretchDynamicTo(arBmStretch2[0]);
			if(bmPlate.bIsValid())bmPlate.stretchDynamicTo(bm1);
		}
		if(bFullRight && i==arDx.length()-1){
			Beam arBmStretch2[]=Beam().filterBeamsHalfLineIntersectSort(arAllBeams,ptLine,el.vecY());
			if(arBmStretch2.length()>0)bm1.stretchDynamicTo(arBmStretch2[0]);
			if(bmPlate.bIsValid())bmPlate.stretchDynamicTo(bm1);
		}
		
		//move point for next beam
		ptCreate.transformBy(el.vecX()*arDx[i]);
		
		//Set to a map
		mp.appendEntity("Bm"+nMapKey,bm1);
		nMapKey++;
		
		//grow size
		dGrow+=arDx[i];
	}
		
	// Right king
	if(doKingRight){
		ptCreate.transformBy(el.vecX()*(dTPkW-dGrow));
		Beam bmK;

		bmK.dbCreate(ptCreate,-el.vecY(),el.vecZ(),el.vecX(),U(12),dElW,U(1.5),1,0,1);
		bmK.setColor(2);	
		bmK.setHsbId("114");	
		bmK.setType(_kStud);
		bmK.setModule(strModule);
		bmK.setInformation("");
		bmK.setName(sNewStudName);	
		bmK.setMaterial(sNewStudMaterial);
		bmK.setGrade(sNewStudGrade);
		bmK.setLabel(sNewStudLabel);
		bmK.setSubLabel(sNewStudSubLabel);
		bmK.setSubLabel2(sNewStudSubLabel2);
		bmK.setBeamCode(sNewStudBeamCode);
		bmK.assignToElementGroup(el,true,0,'Z');			
		
		//find where to stretch to
		Point3d ptLine=ptCreate+el.vecX()*U(0.75)+(dElW/2-U(0.75))*el.vecZ();
		Beam arBmStretch1[]=Beam().filterBeamsHalfLineIntersectSort(arBmH,ptLine,-el.vecY());
		Beam arBmStretch2[]=Beam().filterBeamsHalfLineIntersectSort(arAllBeams,ptLine,el.vecY());
		if(arBmStretch1.length()>0){
			bmK.stretchDynamicTo(arBmStretch1[0]);
		}
		if(arBmStretch2.length()>0){
			bmK.stretchDynamicTo(arBmStretch2[0]);		
		}
		
		//Set to a map
		mp.appendEntity("Bm"+nMapKey,bmK);
		nMapKey++;	

        
		if(doExtraKingRight) // added v1.12
		{
			Point3d kingPtCreate = ptCreate + el.vecX()*U(1.5);
			
			Beam bmK;
			bmK.dbCreate(kingPtCreate,-el.vecY(),el.vecZ(),el.vecX(),U(12),dElW,U(1.5),1,0,1);
			bmK.setColor(2);	
			bmK.setHsbId("114");	
			bmK.setType(_kStud);
			bmK.setModule(strModule);
			bmK.setInformation("");
			bmK.setName(sNewStudName);	
			bmK.setMaterial(sNewStudMaterial);
			bmK.setGrade(sNewStudGrade);
			bmK.setLabel(sNewStudLabel);
			bmK.setSubLabel(sNewStudSubLabel);
			bmK.setSubLabel2(sNewStudSubLabel2);
			bmK.setBeamCode(sNewStudBeamCode);
			bmK.assignToElementGroup(el,true,0,'Z');			
			
			//find where to stretch to
			Point3d ptLine=kingPtCreate+el.vecX()*U(0.75)+(dElW/2-U(0.75))*el.vecZ();
			Beam arBmStretch1[]=Beam().filterBeamsHalfLineIntersectSort(arBmH,ptLine,-el.vecY());
			Beam arBmStretch2[]=Beam().filterBeamsHalfLineIntersectSort(arAllBeams,ptLine,el.vecY());
			
			if(arBmStretch1.length()>0) bmK.stretchDynamicTo(arBmStretch1[0]);
			if(arBmStretch2.length()>0) bmK.stretchDynamicTo(arBmStretch2[0]);		
			
			//Set to a map
			mp.appendEntity("Bm"+nMapKey,bmK);
			nMapKey++;	
		} 	
	} 	
		
	_Map.appendMap("mpBm",mp);


	//Clean out studs in the way
	
	double dPkBdW=dTPkW;
	double dMoveBd=U(0);
	if(doKingLeft){
		dPkBdW+=U(1.5);
		dMoveBd-=U(0.75);
	}
	if(doKingRight){
		dPkBdW+=U(1.5);
		dMoveBd+=U(0.75);
	}

    if(doExtraKingLeft)
	{
		dPkBdW+=U(1.5);
		dMoveBd-=U(0.75);
	}

	if(doExtraKingRight)
	{
		dPkBdW+=U(1.5);
		dMoveBd+=U(0.75);
	}
	
	
	Body bdCleanOut(_Pt0,el.vecX(),el.vecY(),el.vecZ(),(dPkBdW-U(0.125)),U(500),U(12),0,1,0);
	bdCleanOut.transformBy(el.vecX()*dMoveBd);	
	
	for (int i=0; i<arBmV.length();i++){
		if(arBmV[i].realBody().hasIntersection(bdCleanOut))arBmV[i].dbErase();
	}
	
	//cutting of plates and blocking
	//helpfull bodies at each side
	Body bdLeft(_Pt0- (dTPkW+U(3))/2*el.vecX(),_Pt0- (dTPkW+U(3))/2*el.vecX() + U(1000)*el.vecY(),U(.5));
	Body bdRight(_Pt0+ (dTPkW+U(3))/2*el.vecX(),_Pt0+ (dTPkW+U(3))/2*el.vecX() + U(1000)*el.vecY(),U(.5));
	Cut ctL(_Pt0- dTPkW/2*el.vecX(),el.vecX());
	Cut ctR(_Pt0+ dTPkW/2*el.vecX(),-el.vecX());
	Cut ctLBlk(_Pt0- (dTPkW+U(3))/2*el.vecX(),el.vecX());
	Cut ctRBlk(_Pt0+ (dTPkW+U(3))/2*el.vecX(),-el.vecX());
	
	for (int i=0; i<arBmHFix.length();i++){
		int nTypesBlk[]={_kBlocking, _kSFBlocking};
		//cutLeft
		if(arBmHFix[i].realBody().hasIntersection(bdLeft) && !arBmHFix[i].realBody().hasIntersection(bdRight)){
			if(nTypesBlk.find(arBmHFix[i].type())>-1)arBmHFix[i].addToolStatic(ctLBlk);
			else arBmHFix[i].addToolStatic(ctL);
		}
		//cut Right on left end
		if(arBmHFix[i].realBody().hasIntersection(bdRight) && !doKingLeft){
			if(nTypesBlk.find(arBmHFix[i].type())>-1)arBmHFix[i].addToolStatic(ctRBlk);
			else arBmHFix[i].addToolStatic(ctR);
		}
		//cut right
		if(arBmHFix[i].realBody().hasIntersection(bdRight) && !arBmHFix[i].realBody().hasIntersection(bdLeft)){
			if(nTypesBlk.find(arBmHFix[i].type())>-1)arBmHFix[i].addToolStatic(ctRBlk);
			else arBmHFix[i].addToolStatic(ctR);
		}		
		//cut Left on Right end
		if(arBmHFix[i].realBody().hasIntersection(bdLeft) && !doKingRight){
			if(nTypesBlk.find(arBmHFix[i].type())>-1)arBmHFix[i].addToolStatic(ctLBlk);
			else arBmHFix[i].addToolStatic(ctL);
		}
		//double
		if(arBmHFix[i].realBody().hasIntersection(bdRight) && arBmHFix[i].realBody().hasIntersection(bdLeft)){
			Beam bmNew=arBmHFix[i].dbCopy();
			if(nTypesBlk.find(arBmHFix[i].type())>-1){
				arBmHFix[i].addToolStatic(ctRBlk);			
				bmNew.addToolStatic(ctLBlk);	
			}
			else{
				arBmHFix[i].addToolStatic(ctR);			
				bmNew.addToolStatic(ctL);	
			}
		}	
	}
}


//apply milling
if(arZonesMilled.length()>0){
	
	//break out string
	int nZonesToMill[0];
	int nGo=1,nCount=0;
	
	while(nGo)
	{
		String strTok=arZonesMilled.token(nCount,";",TRUE);

		if(strTok.length()>0)
		{
			int nZone=strTok.atoi();
			if(nZone<0)nZonesToMill.append(nZone);
			else if(nZone>0 && nZone<6)nZonesToMill.append(nZone);
			else if(nZone>5)nZonesToMill.append(5-nZone);
		}
		else
		{
			nGo=0;
			break;
		}
		nCount++;
	}
	
	
	PLine plMill;
	if(!doKingLeft){
		plMill.addVertex(ptMillRef-dTPkW/2*el.vecX());
		plMill.addVertex(ptMillRef+dTPkW/2*el.vecX());
		plMill.addVertex(ptMillRef+dTPkW/2*el.vecX()+dBmSize*el.vecY());
	}
	else if(!doKingRight){
		plMill.addVertex(ptMillRef-dTPkW/2*el.vecX()+dBmSize*el.vecY());
		plMill.addVertex(ptMillRef-dTPkW/2*el.vecX());
		plMill.addVertex(ptMillRef+dTPkW/2*el.vecX());
	}	
	else{
		plMill.addVertex(ptMillRef-dTPkW/2*el.vecX()+dBmSize*el.vecY());
		plMill.addVertex(ptMillRef-dTPkW/2*el.vecX());
		plMill.addVertex(ptMillRef+dTPkW/2*el.vecX());
		plMill.addVertex(ptMillRef+dTPkW/2*el.vecX()+dBmSize*el.vecY());
	}	



	for (int i=0; i<nZonesToMill.length();i++){
		ElemZone elZ=el.zone(nZonesToMill[i]);
		
		double dZThick=elZ.dH();
		if(dZThick>U(0)){
			
			ElemMill elMill(nZonesToMill[i],plMill,0,nToolingIndex,nSide,nTurn,nOShoot);
			elMill.setVacuum(nVacuum);
			el.addTool(elMill);

		}
	}
}

if(_bOnInsert)return;

#End
#BeginThumbnail
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
%XH`__]D`
`
end
11300















#End
#BeginMapX

#End