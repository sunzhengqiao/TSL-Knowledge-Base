#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
21.01.2014  -  version 1.02
#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl creates marker lines for a t-connection.
/// </summary>

/// <insert>
/// Select 2 beams
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.02" date="21.01.2014"></version>

/// <history>
/// TH - 1.00 - 01.12.2006 -	First revision
/// AS - 1.01 - 21.01.2014 -	Update for Dutch Content
/// AS - 1.02 - 21.01.2014 -	Add option set posnum of male beam (<OTHERPOS>)
/// </history>


// basics and props
	U(1,"mm");
	String sArSide[] = {T("|Contact face|"), T("|Opposite contact face|"), T("|Side|") + " 1", T("|Side|") + " 2"};
	String sArTextPosition[] = {T("|Bottom|"), T("|Center|"), T("|Top|")};
	String sArTextAlignment[] = {T("|Left|"), T("|Center|"), T("|Right|")};
	
	
	PropString sSeperator01(0,"", T("|Marking properties|"));
	PropString sSide(1, sArSide, "     "+T("|Side|"));
	PropString sTxt(2, "", "     "+T("|Text|"));
	PropString sTextPosition(3, sArTextPosition, "     "+T("|Text position|"),1);
	PropString sTextAlignment(4, sArTextAlignment, "     "+T("|Text alignment|"),1);
	PropInt nDirection(0, 0, "     "+T("|Hundegger alignment|"));
				
// bOnInsert
	if(_bOnInsert)
	{	
		showDialogOnce();
		_Beam.append(getBeam(T("|Select male beam|")));	
		_Beam.append(getBeam(T("|Select female beam|")));			
		return;
	}// end bOnINsert
	
// stop
	if (_Beam.length() < 2)
	{
		eraseInstance();
		return;
	}

// set dependency
	_Entity.append(_Beam[0]);
	_Entity.append(_Beam[1]);
	setDependencyOnEntity(_Entity[0]);
	setDependencyOnEntity(_Entity[1]);
		
// int
	int nSide = sArSide.find(sSide);
	int nTextPosition = 	sArTextPosition.find(sTextPosition) - 1;
	int nTextAlignment = sArTextAlignment.find(sTextAlignment) - 1;
	
// Beams
	Beam bm0, bm1;
	bm0 = _Beam[0];
	bm1 = _Beam[1];
	
// marking normal vector
	Vector3d vM;
	double dOff = 0;
	if (nSide == 1)
	{
		vM = _X0;
		dOff = bm1.dD(_X0);
	}
	else if(nSide == 2)
		vM = _Y1;
	else if(nSide == 3)
		vM = -_Y1;	
	else
		vM = -_X0;
		
// get points
	Point3d pt1 = Line(bm0.ptCen() - 0.5 * bm0.dD(_X1) * bm0.vecD(_X1),_X0).intersect(_Plf,dOff);
	Point3d pt2 = Line(bm0.ptCen() + 0.5 * bm0.dD(_X1) * bm0.vecD(_X1),_X0).intersect(_Plf,dOff);

// Display
	Display dp(3);
	dp.draw(PLine (pt1 - 0.5 * _Y1 * bm1.dD(_Y1),pt1 + 0.5 * _Y1  * bm1.dD(_Y1)) );
	dp.draw(PLine (pt2 - 0.5 * _Y1 * bm1.dD(_Y1),pt2 + 0.5 * _Y1  * bm1.dD(_Y1)) );	
	
	pt1.vis(1);
	pt2.vis(2);	


		
// marking
	String sMarkingText = sTxt;
	if( sMarkingText == "<OTHERPOS>" )
		sMarkingText = bm0.posnum();
	Mark mrk( pt1, pt2, vM, sMarkingText);
	mrk.setTextPosition(nTextPosition,nTextAlignment,nDirection);
	bm1.addTool(mrk);
	
		
	

#End
#BeginThumbnail
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
C3CUQ5RO)DK.QT)W5PHHHI#"BBB@`HHHH`****`"BBB@#_]DD
`

#End
