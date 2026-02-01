#Version 8
#BeginDescription
Split Top and Bottom plates

Modified by: Anno Sportel (anno.sportel@hsbcad.com)
Date: 19.05.2014 - version 1.01











#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This splits the top and bottom plates.
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="19.05.2014"></version>

/// <history>
/// AJ - 1.00 - 07.05.2014 - 	Pilot version
/// AS - 1.01 - 19.05.2014 - 	Add translation pipes, add support for attachment to wall definition.
/// </history>



Unit(1,"mm"); // script uses mm

String sArNY[] = {T("|No|"), T("|Yes|")};

double dLengthTop=U(6000);
double dLengthBottom=U(5000);

// Load the values from the catalog
if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	//Getting walls	
	if (insertCycleCount()>1) { eraseInstance(); return; }
	//if (_kExecuteKey=="")
	//	showDialogOnce();
	
	PrEntity ssE(T("|Please select Element|"),ElementWall());
 	if (ssE.go())
	{
 		Element ents[0];
 		ents = ssE.elementSet();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			ElementWall el = (ElementWall) ents[i];
 			_Element.append(el);
 		 }
 	}
	
	_Map.setInt("ManualInsert", true);

	if(_Element.length()==0){
		eraseInstance();
		return;
	}

	return;
}	

if (_Element.length() == 0)
{
	reportMessage(T("|No selected walls, TSL will be deleted|!"));
	eraseInstance(); 
	return; 
}

int bManualInsert = false;
if( _Map.hasInt("ManualInsert") )
	bManualInsert = _Map.getInt("ManualInsert");


for(int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	CoordSys csEl = el.coordSys();
	Vector3d vx=csEl.vecX();
	Vector3d vy=csEl.vecY();
	Vector3d vz=csEl.vecZ();	
	
	//Get all the beam and calculate which ones can not be delete
	Beam bmAll[]=el.beam();
	if (bmAll.length()==0)
		continue;
	
	Plane plnY(el.ptOrg(), vy);
	Plane plnZ(el.ptOrg(), vz);
	
	_Pt0=plnZ.closestPointTo(_Pt0);
	_Pt0=plnY.closestPointTo(_Pt0);
	
	Beam bmTopPlates[0];
	Beam bmBottomPlates[0];
	Beam bmCripples[0];
	Beam bmBlocking[0];
	Beam bmToCheckDeletion[0];
	
	for(int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		int nBmType=bm.type();
		if (nBmType==_kSFTopPlate || nBmType==_kSFAngledTPLeft || nBmType==_kSFAngledTPRight) 
		{
			Body bd=bm.envelopeBody(false, true);
			bmTopPlates.append(bm);
		}
		else if (nBmType==_kSFBottomPlate)
		{
			Body bd=bm.realBody();
			bmBottomPlates.append(bm);
		}
	}
	
	//Calculate the size off the profile post

	for (int i=0; i<bmBottomPlates.length(); i++)
	{
		Beam bm=bmBottomPlates[i];
		Point3d ptLeft=bm.ptCenSolid()-bm.vecX()*(bm.solidLength()*0.5);
		Point3d ptRight=bm.ptCenSolid()+bm.vecX()*(bm.solidLength()*0.5);
		
		Vector3d vxSplit=bm.vecX();
		int nFlip=false;
		if (vx.dotProduct(vxSplit)<0)
		{
			Point3d ptAux=ptRight;
			ptLeft=ptRight;
			ptRight=ptAux;
			vxSplit=-vxSplit;
			nFlip=true;
		}
		if (bm.solidLength()>dLengthBottom)
		{
			Point3d ptSplit=ptRight-vxSplit*dLengthBottom;
			Beam bmResult=bm.dbSplit(ptSplit, ptSplit);
			if (nFlip)
			{
				if (bmResult.solidLength()>dLengthBottom)
				{
					Point3d ptSplit2=ptRight-vxSplit*dLengthBottom*2;
					bmResult.dbSplit(ptSplit2, ptSplit2);
				}
			}
			else
			{
				if (bm.solidLength()>dLengthBottom)
				{
					Point3d ptSplit2=ptRight-vxSplit*dLengthBottom*2;
					bm.dbSplit(ptSplit2, ptSplit2);
				}
			}
				
		}
	}


	for (int i=0; i<bmTopPlates.length(); i++)
	{
		Beam bm=bmTopPlates[i];
		Point3d ptLeft=bm.ptCenSolid()-bm.vecX()*(bm.solidLength()*0.5);
		Point3d ptRight=bm.ptCenSolid()+bm.vecX()*(bm.solidLength()*0.5);
		
		Vector3d vxSplit=bm.vecX();
		int nFlip=false;
		if (vx.dotProduct(vxSplit)<0)
		{
			Point3d ptAux=ptRight;
			ptLeft=ptRight;
			ptRight=ptAux;
			vxSplit=-vxSplit;
			nFlip=true;
		}
		if (bm.solidLength()>dLengthBottom && bm.solidLength()<dLengthTop)
		{
			Point3d ptSplit=ptLeft+vxSplit*dLengthBottom;
			Beam bmResult=bm.dbSplit(ptSplit, ptSplit);
		}
		else if (bm.solidLength()>dLengthTop)
		{
			Point3d ptSplitRight=bm.ptCenSolid()+vxSplit*dLengthBottom*0.5;
			Point3d ptSplitLeft=bm.ptCenSolid()-vxSplit*dLengthBottom*0.5;
			
			if (nFlip)
			{
				Beam bmResult=bm.dbSplit(ptSplitRight, ptSplitRight);
				bmResult.dbSplit(ptSplitLeft, ptSplitLeft);
			}
			else
			{
				Beam bmResult=bm.dbSplit(ptSplitRight, ptSplitRight);
				bm.dbSplit(ptSplitLeft, ptSplitLeft);
			}
		}
	}
}

if( _bOnElementConstructed || bManualInsert ){
	eraseInstance();
	return;
}












#End
#BeginThumbnail

#End
