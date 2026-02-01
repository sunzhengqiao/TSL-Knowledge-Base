#Version 8
#BeginDescription
Stretches selected wall to another wall, if angle between them is not 90 or 180 applies non-standard configurations (angled connection).
These tsl’s MUST BE ATTACHED IN THE DRAWING in order to this tsl work properly:
- GE_WDET_SEARCH_ANGLED_CONNECTIONS
- GE_WALLS_SKEWED_TEE_CONNECTION
- GE_WDET_AUTOLADDER
- GE_WALLS_MITER_TO_MITER_ANGLED
v1.3: 21.jul.2012: David Rueda (dr@hsb-cad.com)




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/*
*************************************************************************
 COPYRIGHT
 ---------
 Copyright (C) 2010 by
 hsbSOFT
 ECUADOR

 The program may be used and/or copied only with the written
 permission from hsbSOFT, or in accordance with
 the terms and conditions stipulated in the agreement/contract
 under which the program has been supplied.
 All rights reserved.
*************************************************************************
v1.3: 21.jul.2012: David Rueda (dr@hsb-cad.com)
	- Thumbnail updated
v1.2: 04-may-2011: David Rueda (dr@hsb-cad.com)		- Bugfix: tsl will erase itself, will avoid wrong behavior on angled connections
v1.1: 14-apr-2011: David Rueda (dr@hsb-cad.com)		- Bugfix: now tsl won't move openings.
v1.0: 02-apr-2011: David Rueda (dr@hsb-cad.com)		- Released
*/

if(_bOnInsert){
	
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}
	
	PrEntity ssE(T("\n|Select wall(s) to stretch|"),Element());
	
	if(ssE.go())
	{ 
		Entity ents[0];
		ents = ssE.set();
		for (int i=0; i<ents.length(); i++) 
		{
			Element el = (Element)ents[i]; // cast the entity to a element 
			_Element.append(el);
		}
	}

	if( _Element.length()<1){
		eraseInstance();
		return;
	}
	
	Element el=getElement(T("|Select wall to stretch to|"));
	ElementWall elFemale=(ElementWall)el;

	if (!elFemale.bIsValid())
	{
		eraseInstance();
		return;
	}
		
	for(int e=0;e<_Element.length();e++)
	{
		ElementWall elMale=(ElementWall) _Element[e];
		if (!elMale.bIsValid())
		{
			eraseInstance();
			return;
		}
		
		//Getting Info from elements
		//Male el
		CoordSys csMaleEl=elMale .coordSys();
		Point3d ptMaleOrg=csMaleEl.ptOrg();	
		Vector3d vxMale=csMaleEl.vecX();
		PLine plElMale=elMale.plOutlineWall();
		Point3d ptElMale[]=plElMale.vertexPoints(1);
		Point3d ptMaleRef;
		ptMaleRef.setToAverage(ptElMale);

		//Female el
		CoordSys csFemaleEl=elFemale .coordSys();
		Point3d ptFemaleOrg=csFemaleEl.ptOrg();
		Vector3d vxFemale=csFemaleEl.vecX();
		Vector3d vzFemale=csFemaleEl.vecZ();
			
		//Filter out paralell elements
		if(1-(vxMale.dotProduct(vxFemale))<U(0.001, 0.00001))
		{
			reportMessage(T("|Walls are paralell|"));
			continue;
		}
		
		//Define proper point for create plane
		Point3d pt1=ptFemaleOrg;
		Point3d pt2=ptFemaleOrg-vzFemale*elFemale.dBeamWidth();	
		Point3d ptPln;
		if((ptMaleRef-pt1).length()<(ptMaleRef-pt2).length())
		{
			ptPln=pt1;
		}
		else
		{
			ptPln=pt2;
		}
	
		//Creating plane
		Plane pln(ptPln,vzFemale);

		//Stretching ACAWall to defined plane
		Wall wallMale=(Wall)elMale;
		Point3d ptStart=wallMale.ptStart();
		Point3d ptEnd=wallMale.ptEnd();
		//Find new point
		Line lnProjection(ptStart, vxMale);
		Point3d ptProjected=lnProjection.intersect(pln, 0);
		//On of these points must be relocated, need to find out which one
		if((ptProjected-ptStart).length()<(ptProjected-ptEnd).length())// ptStart is the closest one, will be relocated
		{
			Point3d ptNewStart;
			ptNewStart=ptProjected;
			wallMale.setStartEnd(ptNewStart, ptEnd, 1);
		}
		else// ptEnd is the closest one, will be relocated
		{
			Point3d ptNewEnd;
			ptNewEnd=ptProjected;
			wallMale.setStartEnd(ptStart, ptNewEnd, 1);			
		}
		
		//Work with openings: GETTING ORIGINAL POINTS - in some cases opening will be moved from its original insertion point due to the reference it has to start/end of wall. This is to relocate it to original point
		Opening opEl[]=elMale.opening();
		for(int o=0;o<opEl.length();o++)
		{
			Opening op=opEl[o];
			PLine plOp=op.plShape();
			plOp.vis();
		}
		
		//Stretching hsbWall to defined plane
		elMale.stretchOutlineTo(pln);
			
		//Filter out perpendicular elements
		if(abs(vxMale.dotProduct(vxFemale))<U(0.00001, 0.0000001))
		{
			//Do nothing
			continue;
		}

		//Clone GE_WDET_SEARCH_ANGLED_CONNECTIONS tsl
		// declare tsl props 
		TslInst tsl;
		String sScriptName = "GE_WDET_SEARCH_ANGLED_CONNECTIONS";
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[2];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		lstEnts[0] = elMale;
		lstEnts[1] = elFemale;
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
	}
}
eraseInstance();
return;





#End
#BeginThumbnail
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
H0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!__V5%`
`

#End
