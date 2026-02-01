#Version 8
#BeginDescription

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
Unit(1,"mm");

PropInt nNumberOfSills(0, 1, "|Number of sills to create|");

if (_bOnInsert)
{
	if (insertCycleCount() > 1) { eraseInstance(); return; }
	if (_kExecuteKey == "")
		showDialog();
		
	PrEntity ssE(T("Select one or More Elements"), ElementWallSF());
	if ( ssE.go() ) {
		_Element.append(ssE.elementSet());
	}
	
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if (_Element.length() == 0) 
{
	eraseInstance(); 
	return;
}

int nErase=false;

for (int i = 0; i < _Element.length(); i++)
{
	Element el = _Element[i];
	Opening openings[] = el.opening();
	
	Point3d elOrg = el.ptOrg();
	_Pt0 = elOrg;
	//Define a ccordsys of the element.
	CoordSys csEl = el.coordSys();
	//Define a useful set of vectors.
	Vector3d vX = csEl.vecX(); vX.vis(elOrg, 1);
	Vector3d vY = csEl.vecY(); vY.vis(elOrg, 3);
	Vector3d vZ = csEl.vecZ(); vZ.vis(elOrg, 150);
	
	Beam arBm[] = el.beam();
	if(arBm.length() > 0)
	{ 
		nErase=true;
	}
	
	for (int i = 0; i < openings.length(); i++)
	{
		OpeningSF opSf = (OpeningSF) openings[i];
		if ( ! opSf.bIsValid()) continue;
		
		//Get the shape of the opening as a poly line
		PLine plOp = opSf.plShape();
		
		//Move the poliline to to the center of the zone0
		Plane plnMidZone0(elOrg - vZ * el.dBeamWidth() * 0.5, vZ);
		plOp.projectPointsToPlane(plnMidZone0, vZ);
		
		//Get the points of this poly line
		Point3d arPtOp[] = plOp.vertexPoints(TRUE);
		
		//Calculate the center pointof the opening
		Point3d ptOpCen;
		for (int j = 0; j < arPtOp.length(); j++) {
			Point3d pt = arPtOp[j];
			ptOpCen = ptOpCen + pt;
		}
		ptOpCen = ptOpCen / arPtOp.length();
		ptOpCen.vis(5);
		//calculate the left and right point of the opening.
		Point3d ptLeft = ptOpCen - vX * 0.5 * opSf.width();
		Point3d ptRight = ptOpCen + vX * 0.5 * opSf.width();
		
		Beam bmSills[0];
		Beam bmBottomPlates[0];
		Beam bmJacks[0];
		
		//Loop over all beams
		for (int j = 0; j < arBm.length(); j++) {
			//Assign the current beam to bm.
			Beam bm = arBm[j];
			//Continue if the current beam is NOT a sill.
			if (bm.type() == _kSill)
			{
				//Check if the sill belongs to this opening.
				double d1 = vX.dotProduct(bm.ptCen() - ptLeft);
				double d2 = vX.dotProduct(bm.ptCen() - ptRight);
				if ( (d1 * d2) < 0 ) {
					bmSills.append(bm);
				}
			}
			
			if (bm.type() == _kSFJackUnderOpening)
			{
				//Check if the sill belongs to this opening.
				double d1 = vX.dotProduct(bm.ptCen() - ptLeft);
				double d2 = vX.dotProduct(bm.ptCen() - ptRight);
				if ( (d1 * d2) < 0 ) {
					bmJacks.append(bm);
				}
			}
			
			if (bm.type() == _kSFBottomPlate)
			{
				bmBottomPlates.append(bm);
			}
		}
		
		//Sort the sills and bottom plates to get bottom most sill and top most bottom plate
		bmSills = Beam().filterBeamsHalfLineIntersectSort(bmSills, ptOpCen, - vY);
		bmBottomPlates = Beam().filterBeamsHalfLineIntersectSort(bmBottomPlates, ptOpCen, - vY);
		
		//Insufficient data to work with
		if (bmSills.length() == 0 || bmBottomPlates.length() == 0) continue;
		
		Beam bottomMostSill = bmSills[bmSills.length() - 1];
		Beam topMostBottomPlate = bmBottomPlates[0];
		double sillThickness = bottomMostSill.dD(vY);
		
		Point3d ptUndersideOfSill = bottomMostSill.ptCen() - vY * sillThickness * 0.5;
		Point3d ptTopOfBottomPlate = topMostBottomPlate.ptCen() + vY * topMostBottomPlate.dD(vY) * 0.5;
//		bottomMostSill.realBody().vis();
//		topMostBottomPlate.realBody().vis();
//		ptUndersideOfSill.vis();
//		ptTopOfBottomPlate.vis();
		double dSpaceAvailableForExtraSills = abs((ptUndersideOfSill - ptTopOfBottomPlate).dotProduct(vY));
		
		//Check if there is enough room to fit all the extra sills
		if (dSpaceAvailableForExtraSills < sillThickness * nNumberOfSills) continue;
		
		//Create sills
		Beam lastSill;
		for(int n=1 ; n <= nNumberOfSills ; n++)
		{ 
			//Copy sill
			Beam bmCopy = bottomMostSill.dbCopy();
			if ( ! bmCopy.bIsValid()) continue;
			bmCopy.transformBy(-vY * sillThickness * n);
			lastSill = bmCopy;
			dSpaceAvailableForExtraSills -= sillThickness;
		}
		
		//Sort out the jacks
		if ( ! lastSill.bIsValid()) continue;
		for(int b=0; b < bmJacks.length() ; b++)
		{ 
			Beam bmJack = bmJacks[b];
			
			if(dSpaceAvailableForExtraSills <= 0 )
			{ 
				//No space to stretch jacks.
				bmJack.dbErase();
				continue;
			}
			
			bmJack.stretchStaticTo(lastSill, TRUE);
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
#BeginMapX

#End