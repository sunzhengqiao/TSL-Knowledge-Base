#Version 8
#BeginDescription
version  value="1.0" date="22Jan16" author="thorsten.huck@hsbcad.com"
initial
/// This tsl defines a split location on a wall element

/// Insert the tool by using HSB_PANELTSLSPLITLOCATION or select an element 
/// and insertion point to define an individual split location
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
/// <summary Lang=en>
/// This tsl defines a split location on a wall element
/// To be used with command HSB_PANELTSLSPLITLOCATION
/// </summary>


/// <insert Lang=en>
/// Insert the tool by using HSB_PANELTSLSPLITLOCATION or select an element 
/// and insertion point to define an individual split location
/// </insert>

/// History
///<version  value="1.0" date="22Jan16" author="thorsten.huck@hsbcad.com"> initial </version>



//basics and props
	Unit(1,"mm"); // script uses mm
	double dEps=U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;		
	String sDoubleClick= "TslDoubleClick";	

	String sGapName=T("|Gap|");	
	PropDouble dGap(nDoubleIndex++, U(0), sGapName);
	dGap.setDescription(T("|Defines the gap of the joint|"));

	
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
			
		_Element.append(getElement());
		_Pt0 = getPoint();	
			
		return;		
	}	
// end on insert

// validate selection set
	if (_Element.length()<1 || !_Element[0].bIsKindOf(ElementWall()))		
	{
		reportMessage("\n" + scriptName() + " " + T("|could not find reference to element.|"));
		eraseInstance();
		return;				
	}	
	
/// standards
	Element el = _Element[0];
	CoordSys cs =el.coordSys();
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	Point3d ptOrg = cs.ptOrg();
	PLine plOutlineWall = el.plOutlineWall();
	Point3d ptsOutline[] = plOutlineWall.vertexPoints(true);
	Point3d ptMid;
	ptMid.setToAverage(ptsOutline);
	assignToElementGroup(el, true,0,'C');
	double dZ = el.dBeamWidth();	
	if (dZ<=0)
	{
		ptsOutline=Line(ptOrg, vecZ).orderPoints(ptsOutline);
		if (ptsOutline.length()>0)
			dZ = abs(vecZ.dotProduct(ptsOutline[0]-ptsOutline[ptsOutline.length()-1]));	
	}	

	_Pt0 = el.plOutlineWall().closestPointTo(Line(ptOrg,vecX).closestPointTo(_Pt0));		
	_Pt0.vis(1);	
	
	// if construction is not present display, stay invisible
	GenBeam genBeams[] = el.genBeam();	
	Sip sipsAll[0];
	for (int i=genBeams.length()-1;i>=0;i--)
		if (!genBeams[i].bIsKindOf(Sip()))
			genBeams.removeAt(i);
		else
			sipsAll.append((Sip)genBeams[i]);

// set color
	if (_bOnDbCreated)
	{
		_ThisInst.setColor(6);
		setExecutionLoops(2);
	}




			
	int bShow = genBeams.length()<1;

// if the instance is inerted by tsl split locations it somehow needs a transformation to work //version 1.8	
	if (bShow && _kExecutionLoopCount==1)
	{
		_ThisInst.transformBy(Vector3d(0,0,0));
		if (_bOnDebug)reportMessage("\n" + _ThisInst.handle() + " has been transformed by null vector"); 
	}
	
// declare display and draw
	Display dpPlan(_ThisInst.color());
	if (bShow)
	{
	// build plan symbol
		double dSize = U(10);
		Point3d ptSym = _Pt0;
		Point3d ptsSym[] = {ptSym-vecX*.5*dGap};
		int nInd;
		ptsSym.append(ptsSym[nInd++]+(vecZ-vecX)*dSize);
		ptsSym.append(ptsSym[nInd++]+vecX*(2*dSize+dGap));
		ptsSym.append(ptsSym[nInd++]-(vecZ+vecX)*dSize);
		ptsSym.append(ptsSym[nInd++]-vecZ*dZ);
		ptsSym.append(ptsSym[nInd++]-(vecZ-vecX)*dSize);
		ptsSym.append(ptsSym[nInd++]-vecX*(2*dSize+dGap));
		ptsSym.append(ptsSym[nInd++]+(vecZ+vecX)*dSize);
						
		PLine plSym(vecY);	
		for (int i=0;i<ptsSym.length();i++)
			plSym.addVertex(ptsSym[i]);
		plSym.close();	
		//plSym.vis(6);
		dpPlan.draw(plSym);	
		if (dGap>0)dpPlan.draw(PlaneProfile(plSym),_kDrawFilled);	
	}	
	
	if ((_bOnDbCreated ||_bOnElementConstructed || _bOnDebug) && sipsAll.length()>0)
	{

		Plane pnSplit (_Pt0, vecX);
		for (int i=0;i<sipsAll.length();i++)
		{
		// find intersection points
			Sip sip = sipsAll[i];
			
			Point3d ptsInt[] = sip.plEnvelope().intersectPoints(pnSplit);
			if (ptsInt.length()>0)
			{
			// split the panel and add it to the list of panels
				Sip sipSplit[0];
				sipSplit= sip.dbSplit(pnSplit,dGap);	
				break;	
			}
		}// next i	
	}// END IF ((_bOnDbCre...					
#End
#BeginThumbnail
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
M`)XQ_P#?(J6BBP79%]G@_P">,?\`WR*/L\'_`#QC_P"^14M%%@NR+[/!_P`\
M8_\`OD4?9X/^>,?_`'R*EHHL%V1?9X/^>,?_`'R*/L\'_/&/_OD5+118+LC%
MO"IR(8P1T(45)110*["BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HJK?:A;Z=$LESYNUFVCRX7D.?HH)JC_P
ME&EC^*\_\`9__B*=F)M(-%_Y".O_`/80'_I/#6Q7*^$-=LM8U3Q(EH928K]6
M;?&4X,2)T//6-N#S727=U%8V4]W.2(8(VE<@9.U1D\?04-:BBU:YF^$_^10T
M?_KRB_\`0!7'W<<_B34_$LO]CWE[;/'_`&9:2P-"%0H26;YY%/\`K,'('\(K
M5\'^*]*D\(:4`;L&.W2)@+.5AN4;3RJD'D=C6WINJZ.#'8Z?#)`I)V1I8R1(
M"<D_P`#N:K5-L2::2N,\(ZL^M>&+*[F^6Y">5<+W65#M8'\1G\:VZAM[2VM/
M,^S6\4/FN9'\M`N]CU8XZD^M35,G=W*BK*P4444AA1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`&-H:@:CX@P,9U$$_^`\-;-8^B_\`
M(1U__L(#_P!)X:V*;%'8QO"*A?!VC!1@?8HO_016S6/X3_Y%#1_^O*+_`-`%
M;%#W".P4444AA1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110!#!:PV\EQ)$FUKB3S93D_,VU5S[<*HX]*FHHH`AM+6&QLX;2W39
M#"@CC7).%`P!D\U-110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4R26.%-\LBQH.K,V!2NZQHSNP55&22>`
M*\?\8>)WUN^\FW<BQA.$`_C/]X_TKDQ>+CAH7>KZ(]'+<NGC:G*M$MV>HRZ_
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
B"[@^2#4Y$C[#%;U%`&+:^'Q%>1W4UU)+(AR,UM444`?_V=KY
`

#End