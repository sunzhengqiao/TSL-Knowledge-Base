#Version 8
#BeginDescription


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl creates a language independent header (field description) for multipage blocks or displays a block
/// </summary>

/// <insert>
/// Select an insertion point and a shopdraw view placeholder
/// </insert>

/// <property name="Show Field Description" Lang=en>
/// Shows the designated string to define a language independent header.
/// </ property >

/// <property name="Show Block" Lang=en>
/// If the given name corresponds with a block in the drawing this block will be shown at the last grip point and
/// the field selected will not be displayed
/// </ property >

/// <property name="Scale Factor" Lang=en>
/// Scales the display of a valid block
/// </ property >

/// <remark Lang=en>
/// Administrative tool, can be replaced by regular ACA text
/// </remark>

/// <remark Lang=en>
/// Replaces functionality of previously used sd_ViewPortHeader
/// </remark>

/// History
/// Version 1.0   th@hsbCAD.de   08.01.2009



// basics and props
	U(1,"mm");
	double dEps = U(0.001);

	String sArTxt[] = {T("|Project|"),T("|Project #|"),T("|Street|"),T("|City|"),T("|Revision|"),T("|User|"),
		T("|Comment|"),T("|DWG Name|"),T("|Option Directory|"),T("|Date|"),T("|Quantity|"), T("|Material|"),
		T("|Grade|"), T("|Name|"), T("|Label|"),  T("|Sublabel|"), T("|Sublabel2|"),T("|Width|"),T("|Pos|"),T("|Slope|"),
		T("|GRH|"),T("|GRF|"),T("|Length|"),T("|Height|"),T("|Profile|"),T("|Thickness|"), T("|EPS|"),T("|EPS Material|"),
		T("|Skin Bottom|"),T("|Skin Top|"), T("|Skin Bottom Material|"),T("|Skin Top Material|"), T("|Masterpanel #|"), T("|Flipped|"),
		T("|Scale|"), T("|Scale Factor Abbreviation|"), T("|Modified|"), T("|Weight|"), T("|Description|")};
// sort entries
	for (int i=0; i<sArTxt.length(); i++)			
		for (int j=0; j<sArTxt.length()-1; j++)
			if (sArTxt[i]<sArTxt[j])
				sArTxt.swap(i,j);			
		
	PropString sTxt(1,sArTxt,T("|Show Field Description|"));	
	PropString sBlock(2,"",T("|Show Block (disables Field Description)|"));	
	
	PropInt nColor (0,-1,T("|Color|"));	
	PropString sDimStyle(0,_DimStyles,T("|Dimstyle|"));
	PropDouble dScale(1,1, T("|Scale Factor|"));
	PropDouble dAngle(2,0, T("|Rotation Angle|"));
	PropDouble dTxtH(0,U(70), T("|Text Height|"));		
	
	String sArVertical[] = {T("|Bottom|"),T("|Center|"),T("|Top|")};
	PropString sVertical(3,sArVertical,T("|Vertical Alignment|") + " " + T("|(Field Only)|"),1);
	String sArHorizontal[] = {T("|Left|"),T("|Center|"),T("|Right|")};
	PropString sHorizontal(4,sArHorizontal,T("|Horizontal Alignment|") + " " + T("|(Field Only)|"),0);	
	
// on insert
	if(_bOnInsert) 
	{
		//if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();
		_Pt0 = getPoint(); // select point
			
		ShopDrawView sl = getShopDrawView();
		_Entity.append(sl);
		return;
	}
//end on insert________________________________________________________________________________


// the view
	ShopDrawView sl;
	for (int i=0; i<_Entity.length(); i++)
	{
		if (_Entity[i].bIsKindOf(ShopDrawView()))
		{
			ShopDrawView sl = (ShopDrawView)_Entity[i];
			break;	
		}
	}


	
	
// vectors
	Vector3d vx=_XW,vy=_YW;
	CoordSys cs;
	cs.setToRotation(dAngle,_ZW,_Pt0);
	vx.transformBy(cs);
	vy.transformBy(cs);

// alignment
	int nHorizontal = sArHorizontal.find(sHorizontal,0)-1;
	int nVertical = sArVertical.find(sVertical,0)-1;
		
		
// the display
	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	dp.textHeight(dTxtH);

// draw
	if (sBlock == "")
		dp.draw(sTxt,_Pt0,vx,vy,nHorizontal ,nVertical);	
	else
	{
		Block bl(sBlock);
		dp.draw(bl ,_Pt0,vx*dScale,vy*dScale,_ZW*dScale);	
	}		
	

#End
#BeginThumbnail
M_]C_X``02D9)1@`!``$`:P!K``#__@`?3$5!1"!496-H;F]L;V=I97,@26YC
M+B!6,2XP,0#_VP"$`!T4%1D5$AT9%QD@'ATB*T@O*R@H*UD_0S1(:5QO;6=<
M961T@Z>-='N>?61ED<:3GJRRN[V[<(S-W,NVVJ>WN[0!'B`@*R8K52\O5;1X
M97BTM+2TM+2TM+2TM+2TM+2TM+2TM+2TM+2TM+2TM+2TM+2TM+2TM+2TM+2T
MM+2TM+2TM/_$`:(```$%`0$!`0$!```````````!`@,$!08'"`D*"P$``P$!
M`0$!`0$!`0````````$"`P0%!@<("0H+$``"`0,#`@0#!04$!````7T!`@,`
M!!$%$B$Q008346$'(G$4,H&1H0@C0K'!%5+1\"0S8G*""0H6%Q@9&B4F)R@I
M*C0U-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H.$A8:'
MB(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4U=;7
MV-G:X>+CY.7FY^CIZO'R\_3U]O?X^?H1``(!`@0$`P0'!00$``$"=P`!`@,1
M!`4A,08205$'87$3(C*!"!1"D:&QP0DC,U+P%6)RT0H6)#3A)?$7&!D:)B<H
M*2HU-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H*#A(6&
MAXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&Q\C)RM+3U-76
MU]C9VN+CY.7FY^CIZO+S]/7V]_CY^O_``!$(`2P!D`,!$0`"$0$#$0'_V@`,
M`P$``A$#$0`_`.CH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
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
D"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@#__9
`

#End
