#Version 8
#BeginDescription
DACH
Dieses TSL erzeugt eine Gehrung oder eine Eckverbindung zwischen zwei Stäben (optional mit Fuge)


EN
This tsl creates a mitre or corner connection between two beams (optioanl with gap)

version value="1.0" date="27sep13" author="th@hsbCAD.de"
initial

#End
#Type G
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents

/// <summary Lang=de>
/// Dieses TSL erzeugt eine Gehrung oder eine Eckverbindung zwischen zwei Stäben (optional mit Fuge)
/// </summary>

/// <summary Lang=en>
/// This tsl creates a mitre or corner connection between two beams (optioanl with gap)
/// </summary>

/// <insert Lang=en>
/// Select 2 beams
/// </insert>

///<version value="1.0" date="27sep13" author="th@hsbCAD.de"> initial </version>

// basics and prop
	U(1,"mm");
	double dEps = U(0.1);

// define double click action execute key
	String sDoubleClickAction = "TslDoubleClick";

	String sToolTypes[] = {T("|Mitre|"), T("|Corner|")};
	PropString sToolType(0, sToolTypes, T("|Tool Type|"));	
	sToolType.setDescription(T("|Defines the tool type|")+ " " + T("|Double Click to swap sides|"));

	PropDouble dGap(0, 0, T("|Gap|") );	
	dGap.setDescription(T("|Defines the gap|"));
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }	
		String sKey = _kExecuteKey;
		sKey.makeUpper();

	// preset props when called from content/catalog	
		if (sKey=="MITRE")
		{
			sToolType.set(sToolTypes[0]);
			setCatalogFromPropValues(T("|_LastInserted|"));	
		}
		else if (sKey=="CORNER")
		{
			sToolType.set(sToolTypes[1]);
			setCatalogFromPropValues(T("|_LastInserted|"));	
		}
		else if (sKey.length()>0)
			setPropValuesFromCatalog(_kExecuteKey);
		else
			showDialog();
			
	// separate selection
		PrEntity ssB(T("|Select 2 beams|"), Beam());
		Beam beams[0];
		int nCycle; // count the user attempts to select beams
		while (_Beam.length()<2)
		{
			if (ssB.go())
			{
				beams=ssB.beamSet();
				for (int i=0; i<beams.length();i++)
				{
					int n =_Beam.find(beams[i]);
				// append first
					if (_Beam.length()==0)
						_Beam.append(beams[i]);
				// do not add the same again		
					else if (n>-1)
					{
						if (nCycle>0)reportMessage(" " + T("|refused (Duplicate)|"));
						continue;							
					}
				// test parallelism or append
					else
					{
					// test parallelism
						Vector3d vx = _Beam[0].vecX();
						if (beams[i].vecX().isParallelTo(vx))	
						{
							reportMessage(" " + T("|refused (parallel)|"));
							continue;	
						}
					// append	
						else
							_Beam.append(beams[i]);						
					}	
				// only two needed
					if (_Beam.length()==2)break;	
				}				
			}
			else
				break;	
			
			if (_Beam.length()==1)
			{
				nCycle++;
				ssB=PrEntity (T("|Select second beam|"), Beam());	
			}	
		}
	}	
// end on insert	

// standards
	Beam beams[0];
	beams = _Beam;
	
	int nColor = 1;
	_Pt0.vis(nColor);
	
	
// type
	int nToolType= sToolTypes.find(sToolType);

// Display
	Display dp(0);
	
	
// cuts
	Cut ct0, ct1;
	// mitre
	if (nToolType==0)
	{

		_Xf.vis(_Pt0, nColor);
		_Y.vis(_Pt0, nColor);
		_Z.vis(_Pt0, nColor);		
		ct0=Cut(_Pt0-_Xf*.5*dGap,_Xf);
		ct1=Cut (_Pt0+_Xf*.5*dGap,-_Xf);
		
		PLine plCirc;
		plCirc.createCircle(_Pt0,_Xf, .1*(beams[0].dH()+beams[0].dW()));
		dp.draw(plCirc);
	}
	// corner
	else if (nToolType==1)
	{
		Vector3d vecs[0];
		vecs.append(_X0);
		vecs.append(_X1);
		
	// swap beam array on double click	
		int bSwap = _Map.getInt("swap");
		if (_bOnRecalc && _kExecuteKey==sDoubleClickAction)
		{
			if (!bSwap)bSwap=true;
			else bSwap = false;
			_Map.setInt("swap", bSwap);
		}	
		
		if (bSwap)
		{		
			beams.swap(0,1);	
			vecs.swap(0,1);		
		}
		
		Vector3d vecD0=beams[1].vecD(vecs[0]), vecD1=beams[0].vecD(vecs[1]);
		Plane pn0(beams[1].ptCen(),vecD0);
		Plane pn1(beams[0].ptCen(),vecD1);
		Point3d pt0 = Line(beams[0].ptCen(),vecs[0]).intersect(pn0,.5*beams[1].dD(vecs[0]));
		Point3d pt1 = Line(beams[1].ptCen(),vecs[1]).intersect(pn1,-.5*beams[0].dD(vecs[1])-dGap);
		ct0=Cut(pt0,vecD0);
		ct1=Cut(pt1,vecD1);

		PLine plCirc;
		plCirc.createCircle(pt0,vecD0, .1*(beams[0].dH()+beams[0].dW()));
		dp.draw(plCirc);
		plCirc.createCircle(pt1,vecD1, .1*(beams[0].dH()+beams[0].dW()));
		dp.draw(plCirc);
	}

	beams[0].addTool(ct0,1);
	beams[1].addTool(ct1,1);
		
	
	
	
		
		


#End
#BeginThumbnail
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
/R;^[^O\`(JG3@]5^)__9
`


#End
