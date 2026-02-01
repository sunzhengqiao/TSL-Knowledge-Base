#Version 8
#BeginDescription
Creates a point, line or area with a specific load and stores that value, it will get export to View.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 14.09.2010 - version 1.0

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
// basics and props
	U(1,"mm");
	String arSType[]= {T("|Point|"),T("|Line|"),T("|Area|")};
	PropString sType(0, arSType, T("|Load Type|"));
	
	PropDouble dMagnitude(0, 1, T("|Load Magnitude|"));
	
	String arSUnits[]={"kg/sq mm", "kg/sq m", "Ibs/sq in", "Ibs/sq ft"};
	PropString sUnits(1, arSUnits, T("|Load Units|"), 1);

	PropInt nColor(0, 1, "Color");

	if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);
	
	if( _bOnInsert )
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		if (_kExecuteKey=="")
			showDialog();
	}
	
	int nType=arSType.find(sType,0);
	
// on insert
	if (_bOnInsert)
	{

		
		if (nType==0)//Point
		{
			_Pt0 = getPoint("\nSelect a point");  	
		}
		else if (nType==1)//Line
		{
			_Pt0 = getPoint("\nSelect start point");
			_PtG.append(getPoint("\nSelect end point"));
		}
		else if (nType==2)//Area
		{
			Point3d ptArToClone[0];
			_Pt0 = getPoint("\nSelect start point");  
			Point3d ptLast = _Pt0;  	
			ptArToClone.append(ptLast);
		 	
			PLine plAux(_ZW);
			plAux.addVertex(ptLast);
			
			EntPLine entAr[0];
			
			while (1)
			{  	
				PrPoint ssP2("\nSelect next point",ptLast);  	
	
				if (ssP2.go()==_kOk) { // do the actual query  	
					
					ptLast = ssP2.value(); // retrieve the selected point
					plAux.addVertex(ptLast);
					EntPLine entPL;
					entPL.dbCreate(plAux);
					entAr.append(entPL);
					ptArToClone.append(ptLast);
					_PtG.append(ptLast); // append the selected points to the list of grippoints _PtG  	
	
				}  	
	
				else { // no proper selection  	
	
					break; // out of infinite while  	
		
				} 
			}
			for (int i=0; i<entAr.length(); i++)
			{
				entAr[i].dbErase();
			}
		}	
		return;
	}	
//end on insert________________________________________________________________________________
	sType.setReadOnly(TRUE);

	Display dp(nColor);
	Point3d ptAll[0];
	if (nType==0)//Point
	{
		Point3d ptDraw = _Pt0;
		ptAll.append(_Pt0);
		PLine pl1(_XW);
		PLine pl2(_YW);
		PLine pl3(_ZW);
		pl1.addVertex(ptDraw+_ZW*U(1));
		pl1.addVertex(ptDraw-_ZW*U(1));
		pl2.addVertex(ptDraw-_XW*U(1));
		pl2.addVertex(ptDraw+_XW*U(1));
		pl3.addVertex(ptDraw-_YW*U(1));
		pl3.addVertex(ptDraw+_YW*U(1));
		
		dp.draw(pl1);
		dp.draw(pl2);
		dp.draw(pl3);
	}
	else if (nType==1)//Line
	{
		dp.draw(PLine(_Pt0,_PtG[0]));
		ptAll.append(_Pt0);
		ptAll.append(_PtG[0]);
	}
	else if (nType==2)
	{
		
		ptAll.append(_Pt0);
		for (int i=0; i<_PtG.length(); i++)
		{
			ptAll.append(_PtG[i]);
		}
		PLine pl(_ZW);
		for (int i=0; i<ptAll.length(); i++)
		{
			pl.addVertex(ptAll[i]);
		}
		pl.close();
		
		dp.draw(pl);
		
	}
	
	Map mp;
	mp.setString("Type", sType);
	mp.setDouble("Magnitude", dMagnitude);
	mp.setString("Units", sUnits);
	mp.setPoint3dArray("Points", ptAll);
	_Map.setMap("Load", mp);	
	

#End
#BeginThumbnail

#End
