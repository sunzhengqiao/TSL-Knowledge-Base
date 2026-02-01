#Version 8
#BeginDescription
v1.2: 28.oct.2013: David Rueda (dr@hsb-cad.com)
Locks wall(s) framing (excluding opening(s) framing) OR opening(s) framing (excluding wall framing) to avoid losing customization when re-frame.
NOTICE: If need to unlock or erase TSL and locked beams/sheathing, please use the property pallete or select it, right click and select "Custom-> Erase locked beams and TSL". If you only erase TSL manually, all beams and sheathing will stay present in drawing and won't be erased even if you unframe element.

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/*
  COPYRIGHT
  ---------------
  Copyright (C) 2011 by
  hsbSOFT 

  The program may be used and/or copied only with the written
  permission from hsbSOFT, or in accordance with
  the terms and conditions stipulated in the agreement/contract
  under which the program has been supplied.

  All rights reserved.

 REVISION HISTORY
 -------------------------
 v1.2: 28.oct.2013: David Rueda (dr@hsb-cad.com)
	- Avoided deletion of other TSL instances, it was deleting for other openings
 v1.1: 11.oct.2013: David Rueda (dr@hsb-cad.com)
	- Added work with sheething
 v1.0: 12.jul.2013: David Rueda (dr@hsb-cad.com)
	- Release
*/

U(1,"mm");
String strDelete= T("|Erase locked beams and TSL|");
addRecalcTrigger(_kContext, strDelete);
String sOptions[]={"No",T("|Unlock|")};
PropString sUnlock(0,sOptions,T("|Unlock framing|"),0);
int nUnlock=sOptions.find(sUnlock,0);

if (_kExecuteKey==strDelete || nUnlock)
{
	for( int i=0; i< _Beam.length();i++)
		_Beam[i].dbErase();
	for(int s=0;s<_Sheet.length();s++)
		_Sheet[s].dbErase();
	eraseInstance();
	return;
}

String sLn="\n";
int nLockedBeamsColor=4;
int nNotLockedBeamsColor=32;
int nLockedSheetingColor=5;

if(_bOnInsert)
{	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	String sChoices[]={T("|Complete walls|"),T("|Openings only|"),T("|Walls and not openings|")};
	int nChoice= getInt(sLn+T("|Lock framing of:|")+" "+sChoices);
	if( nChoice < 0 || nChoice > 2)
	{
		nChoice=0;
		reportMessage(sLn+T("|Invalid value, default will be used|")+": "+sChoices[nChoice]);
	}
	
	String sInput=T("|Select wall(s) to lock|");
	PrEntity ssE(sLn+sInput,Element());
	if( nChoice==1) // Openings only
	{
		sInput=T("|Select wall(s) containing openings and/or individual opening(s)|");
		ssE.addAllowedClass(Opening());
	}

	if( ssE.go() )
	{
		_Entity.append(ssE.set());
	}
	
	if( _Entity.length()==0)
	{
		eraseInstance();
		return;
	}
	
	// Collect all walls and openings
	Wall walls[0];
	Opening openings[0];
	for (int e=0; e< _Entity.length(); e++)
	{
		if( ! _Entity[e].bIsValid())
			continue;
		Entity ent= _Entity[e];
		if( ent.bIsKindOf( Wall()) )
			walls.append((Wall) ent);
		else if( ent.bIsKindOf( Opening() ) )
			openings.append ( (Opening) ent);
	}
	// Got all walls and openings
	
	// Clonning TSL
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
	
	if( nChoice==0 || nChoice==2) // Wall lock
	{
		for( int e=0; e< walls.length(); e++)
		{
			Wall wl= walls[e];
			if( !wl.bIsValid())
				continue;
							
			lstEnts[0]=wl;
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
		}
	}
	else // Opening lock 
	{
		// Collect openings from walls
		for( int e=0; e< walls.length(); e++)
		{
			Element el= (Element)walls[e];
			if( !el.bIsValid())
				continue;
			openings.append( el.opening());
		}
		
		for( int o=0; o< openings.length(); o++)
		{
			Opening op= openings[o];
			if( !op.bIsValid())
				continue;
				
			lstEnts[0]= op;
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
		}
	}
	
	_Map.setInt("LockType",nChoice);
	_Map.setInt("ExecutionMode",0);
	
	eraseInstance();
	return;
}

if( _Entity.length() == 0)
{
	eraseInstance();
	return;
}

if( !_Map.getInt("ExecutionMode"))
{
	Entity ent=_Entity[0];
	if( !ent.bIsValid())
	{
		eraseInstance();
		return;
	}

	int bLockWall;
	Element el;
	Opening opToLock;
	
	// Will be only one entity, either wall or opening. If wall, is wall lock; else if opening, is opening lock
	if( ent.bIsKindOf( Wall()))
	{
		el= (Element) ent;
		
		// Erase all other TSL's
		TslInst tlsAll[]=el.tslInstAttached();
		for (int i=0; i<tlsAll.length(); i++)
		{
			String sName = tlsAll[i].scriptName();
			if (sName == scriptName() && tlsAll[i].handle()!= _ThisInst.handle())
			{
				tlsAll[i].dbErase();
			}
		}
		bLockWall=true;
	}
	else if( ent.bIsKindOf( Opening()))
	{
		opToLock= (Opening) ent;
		if( !opToLock.bIsValid())
		{
			eraseInstance();
			return;
		}
		el= opToLock.element();
		
		// Erase any other instance of this TSL
		Map subMapX= opToLock.subMapX(scriptName());
		if( subMapX.length()>0)
		{
			for( int e=subMapX.length()-1; e>=0;e-- )
			{
				String sKey= subMapX.keyAt(e);
				Entity ent= subMapX.getEntity(sKey);
				TslInst tsl=(TslInst)ent;
				if(!tsl.bIsValid())
					continue;
				if(sKey != _ThisInst.handle())
				{
					// Erase if has same name
					tsl.dbErase();
			 	}
			}
		}
		else
			opToLock.removeSubMapX(scriptName());
		
		// Add keys and submap to future deletions at insertion
		Map subMapXNew;
		subMapXNew.setEntity(_ThisInst.handle(), _ThisInst);
		opToLock.setSubMapX(scriptName(), subMapXNew);
	}
	else
	{
		eraseInstance();
		return;
	}

	if( !el.bIsValid())
	{
		eraseInstance();
		return;
	}
	
	assignToElementGroup(el,1);
	
	Beam bmAll[]= el.beam();
	if( bmAll.length()==0)
	{
		reportNotice(sLn+T("|Message from|")+" "+scriptName()+" TSL : "+T("|Wall|")+" "+el.number()+" "+ T("|must be framed prior this operation.|"));
		eraseInstance();
		return;
	}
	
	CoordSys csEl=el.coordSys();
	Point3d ptElOrg=csEl.ptOrg();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	
	PlaneProfile ppEl(el.plOutlineWall());
	LineSeg ls=ppEl.extentInDir(vx);
	double dElLength=abs(vx.dotProduct(ls.ptStart()-ls.ptEnd()));
	
	ls=ppEl.extentInDir(vz);
	ElemZone elzStart= el.zone(-10);
	ElemZone elzEnd= el.zone(10);
	double dElWidth=abs(vz.dotProduct(elzStart.coordSys().ptOrg()-elzEnd.coordSys().ptOrg()));
	
	Point3d ptElStart= ptElOrg;
	Point3d ptElEnd= ptElOrg+vx*dElLength;
	Point3d ptElCenter= ptElOrg+vx*dElLength*.5-vz*dElWidth*.5;
	
	// Collect openings to work with (can be 0 to n when wall lock, or 1 only when opening lock
	Opening openings[0];
	if(bLockWall)
	{
		openings.append(el.opening());
	}
	else // opening lock
	{
		openings.append(opToLock);
	}
	
	// Search beams around openings, assign to keep/erase array
	Beam bmAllAroundOpenings[0];
	for( int i=0; i<openings.length();i++)
	{
		Opening op= openings[i];
		if( !op.bIsValid())
			continue;
			
		// Search one beam around this opening
		PLine plOp= op.plShape();
		Point3d ptCen= Body(plOp, vz,0).ptCen();
		ptCen+=vz*vz.dotProduct(ptElCenter-ptCen);
		Beam bmAllIntersecting[]= Beam().filterBeamsHalfLineIntersectSort( bmAll, ptCen, vx);
		Beam bmAnyOnModule= bmAllIntersecting[0];
		String sModule= bmAnyOnModule.module();
		
		// Search all beams on module
		for( int b=0; b< bmAll.length(); b++)
		{
			if( bmAll[b].module()== sModule)
			{
				bmAllAroundOpenings.append(bmAll[b]);
			}
		}
	}

	// Search beams that don't belong to ANY opening module
	Beam bmAllNotAroundOpenings[0];
	for( int i=0; i< bmAll.length(); i++)
	{
		Beam bm0= bmAll[i];
		int bInModule;
		for( int j=0; j< bmAllAroundOpenings.length(); j++)
		{
			Beam bm1= bmAllAroundOpenings[j];
			if( bm0== bm1)
				bInModule= true;				
		}
		if( !bInModule)
			bmAllNotAroundOpenings.append(bm0);
	}

	// Define what beams are staying
	int nChoice=_Map.getInt("LockType"); // String sChoices[]={T("|Complete walls|"),T("|Openings only|"),T("|Walls and not openings|")};

	Beam bmLock[0];
	if( bLockWall)
	{
		if(nChoice==0) // Complete walls
		{
			bmLock= bmAllNotAroundOpenings;
			bmLock.append(bmAllAroundOpenings);
		}
		else
			bmLock= bmAllNotAroundOpenings;
	}
	else
		bmLock= bmAllAroundOpenings;
	
	// Change panhand and set color 1 to locked beams, set color 32 to all others
	_Entity.append( _ThisInst);

	// Add keys and submap to future deletions at insertion
	Map subMapX;
	subMapX.setInt("Locked",1);

	for( int i=0; i< bmAll.length(); i++)
	{
		Beam bm0= bmAll[i];
		int bLocked;
		for( int j=0; j< bmLock.length(); j++)
		{
			Beam bm1= bmLock[j];
			if( bm0== bm1)
			{
				bm0.setSubMapX(scriptName(), subMapX);
				bLocked= true;	
			}
		}
		if( bLocked)
		{
			bm0.setPanhand( _ThisInst );
			bm0.setColor(nLockedBeamsColor);
		}
		else if( !bm0.subMapX(scriptName()).getInt("Locked"))
			bm0.setColor(nNotLockedBeamsColor);
	}
	
	_Beam= bmLock;
	_Sheet=el.sheet();
	if(_Sheet.length()>0)
		_Map.setInt("SheetingColor",_Sheet[0].color());
	
	for(int s=0;s<_Sheet.length();s++)
	{
		_Sheet[s].setPanhand(_ThisInst);
		_Sheet[s].setColor(nLockedSheetingColor);
	}
	
	/* Taken out DR: 28-oct-2013
	// Erase all other TSL entities
	TslInst tsls[]=el.tslInst();
	for(int t=0;t<tsls.length();t++)
	{
		TslInst tsl=tsls[t];
		if(tsl.scriptName()== _ThisInst.scriptName() && tsl.handle()== _ThisInst.handle())
			continue;
		tsl.dbErase();
	}*/ 

	_Map.setInt("ExecutionMode",1);
}

String sDisplay;
if( _bOnElementConstructed)
{
	Entity ent=_Entity[0];
	if( !ent.bIsValid())
	{
		eraseInstance();
		return;
	}

	Element el;
	
	// Will be only one entity, either wall or opening. If wall, is wall lock; else if opening, is opening lock
	if( ent.bIsKindOf( Wall()))
	{
		el= (Element) ent;
	}
	else if( ent.bIsKindOf( Opening()))
	{
		Opening opToLock= (Opening) ent;
		if( !opToLock.bIsValid())
		{
			eraseInstance();
			return;
		}
		el= opToLock.element();
	}
	else
	{
		eraseInstance();
		return;
	}

	if( !el.bIsValid())
	{
		eraseInstance();
		return;
	}

	// Erase all other beams that are not around openings
	Vector3d vz= el.vecZ();
	Beam bmAll[]=el.beam(); 
	Beam bmLock[0];bmLock.append(_Beam);
	
	for( int i=0; i< bmAll.length(); i++)
	{		
		Beam bm0= bmAll[i];
		PlaneProfile pp0= bm0.envelopeBody().getSlice(Plane(bm0.ptCen(), vz));
		pp0.shrink(U(1));
		PLine plAllRings[]= pp0.allRings();
		PLine pl0= plAllRings[0];
		Body bd0 (pl0, vz*el.dBeamWidth(),0);
		for( int j=0; j< bmLock.length(); j++)
		{
			Beam bm1= bmLock[j];
			Body bdIntersection= bm0.envelopeBody();
			//bdIntersection.intersectWith(bm1.envelopeBody());
			if(bd0.hasIntersection(bm1.envelopeBody()) && bm0!= bm1 && !bm0.subMapX(scriptName()).getInt("Locked"))
				bm0.dbErase();
		}	
	}
	
	// Erase new sheeting
	Sheet shNew[]=el.sheet();
	Sheet shErase[0];
	int	nSheetingColor=_Map.getInt("SheetingColor");

	for(int s=0;s<shNew.length();s++)
	{
		int bLock=false;
		for(int t=0;t<_Sheet.length();t++)
		{
			if(shNew[s]==_Sheet[t])
				bLock=true;
		}
		
		if(!bLock)
			shErase.append(shNew[s]);
		else
			shNew[s].setColor(nSheetingColor);
	}
	for(int s=0;s<shErase.length();s++)
	{
		shErase[s].dbErase();
	}
	
	for(int b=0;b<_Beam.length();b++)
		_Beam[b].setIsVisible(true);
	for(int s=0;s<_Sheet.length();s++)
		_Sheet[s].setIsVisible(true);
	sDisplay="";
}

if(_bOnElementDeleted)
{
	for(int b=0;b<_Beam.length();b++)
		_Beam[b].setIsVisible(false);
	for(int s=0;s<_Sheet.length();s++)
		_Sheet[s].setIsVisible(false);
	sDisplay=" "+_Beam.length()+" "+T("Beam(s)")+" "+T("|and|")+" "+_Sheet.length()+" "+T("|Sheet(s)|")+" "+T("|hidden|")+". "+T("|Frame element to unhide.|");
}
Entity ent= _Entity[0];
if( !ent.bIsValid())
{
	eraseInstance();
	return;
}

Display dp(1);
Vector3d vx, vz;
if( ent.bIsKindOf( Wall()))
{
	ElementWall el= (ElementWall)_Entity[0];
	vx=el.vecX();
	vz=-el.vecZ();

	PLine plEl= el.plOutlineWall();
	dp.draw(plEl);
	double dOffset= U(350);
	_Pt0= el.ptArrow()+el.vecZ()*dOffset;
}
else if( ent.bIsKindOf( Opening())) // lock opening
{
	Opening op= (Opening)_Entity[0];
	CoordSys csOp= op.coordSys();
	Point3d ptOrg= csOp.ptOrg();
	vx=csOp.vecX();
	vz=csOp.vecZ();
	Element el= op.element();
	double dElementW= el.dBeamWidth();

	double dWidth= op.width();
	double dThickness= dElementW;
	PLine plOp;
	plOp.createRectangle(LineSeg(ptOrg+vz* dThickness*.5, ptOrg-vz* dThickness*.5+vx* dWidth), vx, vz);
	dp.draw(plOp);
	PLine plOp1;
	plOp1.addVertex(ptOrg);
	plOp1.addVertex(ptOrg+vx*dWidth);
	dp.draw(plOp1);

	double dOffset= U(50);
	_Pt0= ptOrg+ vx* dWidth*.5+vz*(dElementW*.5+dOffset);
}

else
{
	eraseInstance();
	return;
}
	
// Draw lock symbol
// Draw rectangle
PLine plLock(_ZW);
double dW=U(60);
double dH=U(40);
Point3d ptStart= _Pt0;
Point3d pt, ptTxt;
pt=ptStart+vx*dW*.5-vz*dH*.5;
plLock.addVertex(pt);
pt+=-vx*dW;
plLock.addVertex(pt);
pt+=vz*dH;
plLock.addVertex(pt);
pt+=vx*dW;
plLock.addVertex(pt);
pt-=vz*dH;
plLock.addVertex(pt);
dp.draw(plLock);

// Draw silver bulge
PLine plSilver(_ZW);
double dFromEdgeToBulge=dW*.1;
double dStraightSide=dH*.4;
double dSilverThickness=dW*.13;
double dExternalRadius= (dW-dFromEdgeToBulge*2)*.5;
Point3d ptOnExternalArc= ptStart+vz*(dH*.5+dStraightSide+dExternalRadius);
Point3d ptOnInternalArc=ptOnExternalArc-vz*dSilverThickness;
// External arc
pt=ptStart+vx*dW*.5+vz*dH*.5;
pt+=-vx*dFromEdgeToBulge;
plSilver.addVertex(pt);
pt+=vz*dStraightSide;
plSilver.addVertex(pt);
pt=ptStart-vx*dW*.5+vz*dH*.5;
pt+=vx*dFromEdgeToBulge;
pt+=vz*dStraightSide;
plSilver.addVertex(pt, ptOnExternalArc);
pt-=vz*dStraightSide;
plSilver.addVertex(pt);
//Internal arc
pt+=vx*dSilverThickness;
plSilver.addVertex(pt);
pt+=vz*dStraightSide;
plSilver.addVertex(pt);
pt=ptStart+vx*dW*.5+vz*dH*.5;
pt-=vx*(dFromEdgeToBulge+dSilverThickness);
pt+=vz*dStraightSide;
plSilver.addVertex(pt, ptOnInternalArc);
pt=ptStart+vx*dW*.5+vz*dH*.5;
pt-=vx*(dFromEdgeToBulge+dSilverThickness);
plSilver.addVertex(pt);
dp.draw(plSilver);

// Display beam and sheeting hidden text
Vector3d vxT=vx,vyT=vz;
int nz=-1;
if(vxT.dotProduct(_XW)<0)
{
	vxT=-vx;
	vyT=-vz;
	nz=-nz;
}
ptTxt=_Pt0-vz*dH;
dp.draw(sDisplay,ptTxt,vxT,vyT,0,nz);
#End
#BeginThumbnail
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
944`%%%%`!1110`4444`%%%%`!1110!__V5%`
`


#End
