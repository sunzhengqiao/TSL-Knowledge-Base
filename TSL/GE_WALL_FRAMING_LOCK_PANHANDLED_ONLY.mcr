#Version 8
#BeginDescription
GE_WALL_FRAMING_LOCK_PANHANDLED_ONLY
v1.0: 31.oct.2013: David Rueda (dr@hsb-cad.com)
Locks wall(s) framing with previous PANHAND set on beams

NOTICE: If need to unlock or erase TSL and locked beams please use the property pallete or select TSL, right click and select "Custom-> Erase locked beams and TSL". If you only erase TSL manually, all beams will stay present in drawing and won't be erased even if you unframe element.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
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
 v1.0: 31.oct.2013: David Rueda (dr@hsb-cad.com)
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

	String sInput=T("|Select wall(s) to lock|");
	PrEntity ssE(sLn+sInput,Wall());

	if( ssE.go() )
	{
		_Entity.append(ssE.set());
	}
	
	if( _Entity.length()==0)
	{
		eraseInstance();
		return;
	}
	
	// Collect all walls
	Wall walls[0];
	for (int e=0; e< _Entity.length(); e++)
	{
		if( ! _Entity[e].bIsValid())
			continue;
		Entity ent= _Entity[e];
		if( ent.bIsKindOf( Wall()) )
			walls.append((Wall) ent);
	}
	
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

	for( int e=0; e< walls.length(); e++)
	{
		Wall wl= walls[e];
		if( !wl.bIsValid())
			continue;
						
		lstEnts[0]=wl;
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
	}

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

	Element el= (Element) ent;
	
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

	// Define what beams are staying
	Beam bmLock[0];
	for(int b=0;b<bmAll.length();b++)
	{
		Beam bm=bmAll[b];
		if(bm.panhand().bIsValid()) // Panhand is present
		{
			bm.setColor(nLockedBeamsColor);
		}
		else
		{
			bm.dbErase();
		}
	}

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

	Element el= (Element) ent;
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
	
	for(int b=0;b<_Beam.length();b++)
		_Beam[b].setIsVisible(true);
		
	sDisplay="";
}

if(_bOnElementDeleted)
{
	for(int b=0;b<_Beam.length();b++)
		_Beam[b].setIsVisible(false);
	sDisplay=" "+_Beam.length()+" "+T("Beam(s)")+" "+T("|hidden|")+". "+T("|Frame element to unhide.|");
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

#End
