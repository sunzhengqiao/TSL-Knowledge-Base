#Version 8
#BeginDescription
Dieses TSL erzeugt ein Stirnblatt.
Wählen Sie den Stab und den Einfügepunkt und bestimmen Sie die Parameter der Bearbeitung.

version  value="1.2" date="02jul13" author="th@hsbCAD.de">
beam stretch added
export flag set

#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=de>
/// Dieses TSL erzeugt ein Stirnblatt
/// </summary>


/// <insert Lang=de>
/// Wählen Sie den Stab und den Einfügepunkt und bestimmen Sie die Parameter der Bearbeitung.
/// </insert>

/// History

///<version  value="1.2" date="02jul13" author="th@hsbCAD.de"> beam stretch added </version>
///<version  value="1.1" date="27jun13" author="th@hsbCAD.de"> export flag set </version>
///<version  value="1.0" date="15dec11" author="th@hsbCAD.de"> initial </version>


//basics and props
	U(1,"mm");
	double dEps=U(.1);
	
	String sArRelief[] = {T("|not rounded|"),T("|rounded|"),T("|relief|"),T("|rounded with small diameter|"),T("|relief with small diameter|"),T("|rounded|")};
	int nArRelief[] ={_kNotRound, _kRound, _kRelief, _kRoundSmall,_kReliefSmall,_kRounded };	

	PropDouble dY(0,U(80),T("|Width|"));	
	PropDouble dZ(1,U(80),T("|Height|"));	
	PropDouble dX(2,U(9),T("|Depth|"));	
	PropDouble dOffsetY(3,U(0),T("|Offset|") + " Y");
	PropDouble dOffsetZ(4,U(0),T("|Offset|") + " Z");	
	PropDouble dGap(5, 0, T("|Gap|"));
	PropString sRelief(0, sArRelief, T("|Relief|"));
	
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

		// show the dialog if no catalog in use
		if (_kExecuteKey == "")
			showDialog();		
		// set properties from catalog		
		else	
			setPropValuesFromCatalog(_kExecuteKey);
			
		_Beam.append(getBeam());
		_Pt0 = getPoint();	
		return;	
				
	}	
	
// stretch the beam
	_Beam[0].addTool(Cut(_Pt0,_X0),1);

// set ints and doubles
	int nRelief = nArRelief[sArRelief.find(sRelief)];	
	
	Point3d ptRef = _Pt0 +_Y0 *dOffsetY+_Z0*dOffsetZ;
	House hs(ptRef,_Y0,_Z0,-_X0,dY + 2*dGap,dZ + 2*dGap,dX,0,0,1);
	hs.setRoundType(nRelief);
	hs.setEndType(_kFemaleEnd);	
	_Beam[0].addTool(hs);
	
// Display
	Display dp(4);
	dp.draw(PLine(ptRef, ptRef-_X0*dX));
		
		

#End
#BeginThumbnail
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
-W]W]?Y%TZ<'JOQ/_V;6\
`


#End
