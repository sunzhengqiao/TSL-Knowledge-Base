#Version 8
#BeginDescription
Reduces the size of headers to fit the allowable space above an opening and produces a report of what has been ripped down.

Modified by: Chirag Sawjani (csawjani@itw-industry.com)
Date: 15.08.2012  -  version 1.5

















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
* Created by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 10.02.2011
* version 1.0: Release Version
*
* date: 15.02.2011
* version 1.1: Remove Packer if it's below the header
*
* date: 15.02.2011
* version 1.2: Added property to set minimum depth of header
*
* date: 16.02.2011
* version 1.3: Report changed to show the Opening description.
*
* date: 21.05.2012
* version 1.4: Added SFPacker to packer check.
*
* date: 15.08.2012
* version 1.5: Add a property for only report a list of the elements where the opening clash with the header and also add beams by code to the rip option.
*/

_ThisInst.setSequenceNumber(-90);

Unit(1,"mm"); // script uses mm

String sArYesNo[]={T("|No|"),T("|Yes|")};


PropString sYesNoBlocking (0,sArYesNo,T("Show Report of Ripped Headers"),1);

PropDouble dMinDepthOfHeader(0,U(140),T("Enter Minimum Depth of Header"));

PropString sFilterBeams(1, "", T("|Include Beams with Code|"));
sFilterBeams.setDescription(T("|Separate multiple entries by|") +" ';'");

PropString sOnlyReport(2, sArYesNo, T("Only Show Report"),1);
sOnlyReport.setDescription(T("It will only show the report of the openigns that clash with the header and wont cut the header"));


if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nYesNoBlocking = sArYesNo.find(sYesNoBlocking, 0);
int nYesNoReport = sArYesNo.find(sOnlyReport, 0);

if(_bOnInsert)
{

	if (insertCycleCount()>1) { eraseInstance(); return; }
	
	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}


// transform filter tsl property into array
String sBeamFilter[0];
String sList = sFilterBeams;
int bBmFilter;

while (sList.length()>0 || sList.find(";",0)>-1)
{
	String sToken = sList.token(0);	
	sToken.trimLeft();
	sToken.trimRight();		
	sToken.makeUpper();
	sBeamFilter.append(sToken);
	//double dToken = sToken.atof();
	//int nToken = sToken.atoi();
	int x = sList.find(";",0);
	sList.delete(0,x+1);
	sList.trimLeft();	
	if (x==-1)
		sList = "";	
}


int nErase=FALSE;

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
			
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();
	
	Beam bmAll[]=el.beam();
	Opening opAll[]=el.opening();
	Beam bmHeader[0];
	Beam bmSupporting[0];
	Beam bmPacker[0];
	PlaneProfile ppAboveOpening;
	Plane pnOpening;
	if (bmAll.length()<1)	
	{
		continue;
	}
	else
	{
		nErase=TRUE;
	}
	
	//Find all beams which are headers
	for(int i=0;i<bmAll.length();i++)
	{
		Beam bm=bmAll[i];
		String sBeamCode=bm.beamCode();
		if(bm.type()==_kHeader)
		{
			bmHeader.append(bm);
		}
		else if(bm.type()==_kBeam || bm.type()==_kSFPacker)
		{
			bmPacker.append(bm);
		}
		else if(sBeamFilter.find(bm.beamCode().token(0), -1) != -1)
		{
			bmHeader.append(bm);
		}
	}
	
	for(int i=0;i<opAll.length();i++)
	{
		Beam bmHeadersAboveOpening[0];
		PlaneProfile ppHeadersAboveOpening(csEl);
		Opening op=opAll[i];
		OpeningSF opSF=(OpeningSF)op;
		PLine plOpening=op.plShape();
		PlaneProfile ppOpening(csEl);
		ppOpening.joinRing(plOpening,false);
		ppOpening.vis(1);
		LineSeg lsOpening=ppOpening.extentInDir(vy);
		lsOpening.vis();
		Point3d ptOpeSegmentStart=lsOpening.ptStart();
		Point3d ptOpeSegmentEnd=lsOpening.ptEnd();
			
		//Extend end point of Line segment to create a bigger plane profile in the Y Vector of the wall
		Point3d ptNewEndPoint=ptOpeSegmentEnd+U(15000)*vy;
		LineSeg lnNewSegment(ptOpeSegmentStart,ptNewEndPoint);
		
		//Create Rectangle covering the opening and the beams above the opening
		PLine plAboveOpening;
		plAboveOpening.createRectangle(lnNewSegment,vx,vy);
		ppAboveOpening=PlaneProfile(plAboveOpening);
		ppAboveOpening.vis(2);
		//Create a Plane that can be used for the shadow profile
		pnOpening=Plane(ptOpeSegmentStart,vz);
		
		//Check if any blocking pieces are above the opening, if so delete them.
		for(int i=0;i<bmHeader.length();i++)
		{
			Beam bm=bmHeader[i];
			Body bd=bm.realBody();
			bd.vis(i);
			PlaneProfile ppBeam=bd.shadowProfile(pnOpening);
			ppBeam.intersectWith(ppAboveOpening);
			ppBeam.vis();
		  
			if(ppBeam.area()>U(10))
			{
				bmHeadersAboveOpening.append(bm);
				ppHeadersAboveOpening.unionWith(ppBeam);
			}
		}
		
		//Check the distance from the top of the opening to the underside of the header (assuming all headers are same depth)
		if(ppHeadersAboveOpening.area()>U(1)*U(1))
		{
			PlaneProfile ppHeader=ppHeadersAboveOpening;
			LineSeg lsHeader=ppHeader.extentInDir(vy);
			lsOpening.vis();
			Point3d ptHeaderLSStart=lsHeader.ptStart();
			Point3d ptHeaderLSEnd=lsHeader.ptEnd();

			
			//Get Vertical Distance
			ptHeaderLSStart.vis();
			ptOpeSegmentEnd.vis();
			Vector3d vecUndersideHeader=ptHeaderLSStart-ptOpeSegmentEnd;
			double dDistanceToUndersideOfHeader=vecUndersideHeader.dotProduct(vy);
			

			
			//If the distance is less than zero then the header is crossing into the opening so we can rip the headers
			if(dDistanceToUndersideOfHeader<0)
			{
	
				if (nYesNoReport)
				{
					reportNotice("\n"+"Opening in wall "+el.number()+" is overlaping with header.");
				}
				else
				{
					double dNewBeamDepth;	
					int nRipHeaderError=0;
					for(int j=0;j<bmHeadersAboveOpening.length();j++)
					{
						Beam bm=bmHeadersAboveOpening[j];
						double dOriginalBeamDepth=bm.dD(vy);
						dNewBeamDepth=dOriginalBeamDepth+dDistanceToUndersideOfHeader+U(0.01); //Tolerance added
						double dCheckNewDepth=dOriginalBeamDepth-dNewBeamDepth;
						
						//Check if the ripped header is greater than the minimum allowed depth
						if(dNewBeamDepth>=dMinDepthOfHeader && dCheckNewDepth>U(0.5))
						{
							bm.setD(-vy,dNewBeamDepth);
							bm.transformBy(vy*abs(dDistanceToUndersideOfHeader/2));
						}
						else
						{
							if(dCheckNewDepth<U(0.5))
							{
								nRipHeaderError=1;
								reportMessage("\n"+"Header of Wall "+el.number()+" already ripped to height of opening.");
								break;							
							}
							else
							{
								nRipHeaderError=1;
								reportMessage("\n"+"Header of Wall "+el.number()+" cannot be ripped. Minimum Depth of "+dMinDepthOfHeader +"mm exceeded.");
								break;
							}
						}
					}

					//Check if there is a packer under the opening
					for(int i=0;i<bmPacker.length();i++)
					{
						Beam bm=bmPacker[i];
						Body bd=bm.realBody();
						PlaneProfile ppBeam=bd.shadowProfile(pnOpening);
						PlaneProfile ppOp=op.plShape();
						ppOp.shrink(U(1));
						ppBeam.intersectWith(ppOp);
						ppBeam.vis();
					
						if(ppBeam.area()>U(10))
						{
							bm.dbErase();
						}
					}
					
					if(nYesNoBlocking && nRipHeaderError==0)
					{
						String sNewBeamDepth;
						sNewBeamDepth.formatUnit(dNewBeamDepth,2,1);
						reportNotice("\n"+"Header above Opening "+opSF.openingDescr()+" in Wall "+el.number()+" has been ripped to "+sNewBeamDepth+"mm");
					}
				}
			}
		}
		else
		{
			reportMessage("Error in finding distance to underside of header");
		}
	}
}

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}

















#End
#BeginThumbnail




#End
