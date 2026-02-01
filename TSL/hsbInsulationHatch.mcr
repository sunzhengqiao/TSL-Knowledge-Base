#Version 8
#BeginDescription
/// Version 1.3   th@hsbCAD.de   30.11.2009
/// new property 'Linetype'. NOTE: certain linetypes can slow down the calculation time
/// new property 'side' extents toggle of side to properties. the user can use both, either the property
/// or the context command to toggle the side

DE erzeugt eine Dämmungsschraffur innerhalb einer
     beliebigen Polyliniekontur. Eine nicht geschlossene Polylinie wird
     zur Berechnung der Schraffurfläche intern automatisch geschlossen
EN creates insulation hatch inside a pline contour. A pline which is not
    closed will be closed internaly to calculate the hatch area



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl draws an insulation hatch in dependency of a polyline and two grippoints. The width of the 
/// insulation can be controlled via property. No data output supported.
/// </summary>

/// <insert>
/// Select the base point and then a second point to define length and direction
/// Select the bounding polyline.
/// </insert>

/// <property name="Width of Insulation" Lang=en>
/// Sets the width of the insulation. If the insulation intersects the bounding polyline it will be trimmed to the contour
///</property>

/// <command name="Flip Side" Lang=en>
/// Toggles the side of the insulation in relation to the grip points. Default side is right side seen from the start point to the
/// second point.
///</command>


/// History
/// Version 1.3   th@hsbCAD.de   30.11.2009
/// new property 'Linetype'. NOTE: certain linetypes can slow down the calculation time
/// new property 'side' extents toggle of side to properties. the user can use both, either the property
/// or the context command to toggle the side
/// Version 1.2   th@hsbCAD.de   30.11.2009
/// new context command 'flip side' toggles the side of the insulation
/// 26.03.07	th@hsbCAD.de	 minor enhancements

// basics and props
	U(1,"mm");
	String sArNY[] = { T("|No|"), T("|Yes|")};
	PropDouble dWidth(0, U(100), T("|Width of Insulation|"));
	String sArSide[] = {T("|Left|"),T("|Right|")};
	PropString sSide(1, sArSide, T("|Side|"));
	PropString sLinetype(0, _LineTypes, T("|Linetypes|"));

	PropInt nColor(0, 134, T("|Color|"));
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();		
		_Pt0 = getPoint(T("|Select base point|"));
		while (1) {
			PrPoint ssP("\n" + T("|Next point (Defines Direction)|"),_Pt0); 
			if (ssP.go()==_kOk) // do the actual query
				_PtG.append(ssP.value()); // retrieve the selected point
			break;	
		}
		
		if (_PtG.length() < 1)
		{
			eraseInstance();
			return;
		}

		EntPLine pl = getEntPLine();
  		_Entity.append(pl);


		return;		
	}	
//end on insert________________________________________________________________________________

// side
	int nArSide[] = {-1,1};
 	int nSide = nArSide[sArSide.find(sSide,0)];

// add triggers		
	String sTrigger[] ={T("|Flip Side|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);
		
// check trigger
	if (_bOnRecalc && _kExecuteKey==sTrigger[0]) 
	{
		nSide *=-1;
		sSide.set(sArSide[nArSide.find(nSide,0)]);
	}
	
// the bounding contour
	PLine plRec;
	//plRec.createRectangle(LineSeg(_Pt0, _Pt0 + vx * dWidth + vy * dHeight), vx, vy);
	if (_Entity.length() > 0)
	{
		EntPLine epl = (EntPLine)_Entity[0];
  		plRec = epl.getPLine();
		setDependencyOnEntity(_Entity[0]);
	}
	

	Vector3d  vx, vy, vz;
	vy = _PtG[0] - _Pt0;
	vy.normalize();
	vx = vy.crossProduct(_ZU)*nSide;
	vz = _ZU;






	PlaneProfile pp(plRec);
	LineSeg ls = pp.extentInDir(vy);
	pp.vis(6);

	double dHeight;
	dHeight = abs(vy.dotProduct(ls.ptStart()-ls.ptEnd()));
	Point3d ptOrg = _Pt0;
	vx.vis(ptOrg,1);
	vy.vis(ptOrg,3);
	vz.vis(ptOrg,150);		
	
// the standard path of the insulation, pts given for single segments
	Point3d pts[0];
	pts.append(ptOrg);
	pts.append(ptOrg  + vx * .0628 * dWidth + vy * .1515 * dWidth);
	pts.append(ptOrg  + vx * .2143 * dWidth + vy * .2143 * dWidth);

	pts.append(ptOrg  + vx * .2143 * dWidth + vy * .2143 * dWidth);
	pts.append(ptOrg  + vx * .3622 * dWidth + vy * .1741 * dWidth);
	pts.append(ptOrg  + vx * .5 * dWidth + vy * .1072 * dWidth);

	pts.append(ptOrg  + vx * .5 * dWidth + vy * .1072 * dWidth);
	pts.append(ptOrg  + vx * .6378 * dWidth + vy * .0402 * dWidth);
	pts.append(ptOrg  + vx * .7857 * dWidth);

	pts.append(ptOrg  + vx * .7857 * dWidth);
	pts.append(ptOrg  + vx * .9372 * dWidth + vy * .0628 * dWidth);
	pts.append(ptOrg  + vx * dWidth + vy * .2143 * dWidth);

	pts.append(ptOrg  + vx * dWidth + vy * .2143 * dWidth);
	pts.append(ptOrg  + vx * .9372 * dWidth + vy * .3659 * dWidth);
	pts.append(ptOrg  + vx * .7857 * dWidth + vy * .4286 * dWidth);

	pts.append(ptOrg  + vx * .7857 * dWidth + vy * .4286 * dWidth);	
	pts.append(ptOrg  + vx * .6378 * dWidth + vy * .3884 * dWidth);
	pts.append(ptOrg  + vx * .5 * dWidth + vy * .3215 * dWidth);

	pts.append(ptOrg  + vx * .5 * dWidth + vy * .3215 * dWidth);
	pts.append(ptOrg  + vx * .3622 * dWidth + vy * .2545 * dWidth);
	pts.append(ptOrg  + vx * .2143 * dWidth + vy * .2141 * dWidth);

	pts.append(ptOrg  + vx * .2143 * dWidth + vy * .2141 * dWidth);
	pts.append(ptOrg  + vx * .0628 * dWidth + vy * .2771 * dWidth);
	pts.append(ptOrg  + vy * .4288 * dWidth);

	Display dp(nColor);
	dp.lineType(sLinetype);
	int bOk = TRUE;
	while (vy.dotProduct(pts[0] - (ptOrg  + vy * dHeight)) < 0)
	{
		for (int i = 0; i < pts.length()-2; i=i+3)
		{
			PLine pl(vz);
			pl.addVertex(pts[i]);	
			pl.addVertex(pts[i+2],pts[i+1] );	
			// one of the points is outside
			if (pp.pointInProfile(pts[i]) == 1 ||
				pp.pointInProfile(pts[i+1]) == 1 || 
				pp.pointInProfile(pts[i+2]) == 1)
			{
				pl.convertToLineApprox(dWidth/20);
				Point3d ptX[] = pl.vertexPoints(TRUE);
				for (int p = 0; p < ptX.length()-1; p++)
				{
					Vector3d vxP = ptX[p+1]-ptX[p];
					vxP.normalize();
					PLine pl2(vz);
					pl2.addVertex(ptX[p]);
					pl2.addVertex(ptX[p+1])	;	
									
					// both valid
					if (pp.pointInProfile(ptX[p]) != 1 && pp.pointInProfile(ptX[p+1]) != 1)
						dp.draw(pl2);	
					else
					{
						bOk = FALSE;
						int nIndexBackwards =0;
						Point3d ptInt[] = plRec.intersectPoints(ptX[p], vxP);
						for(int x = 0; x < ptInt.length();x++)
						{
							if (vxP.dotProduct(ptInt[x] - ptX[p])>0 && pl2.isOn(ptInt[x]) && (pp.pointInProfile(ptX[p])!=1))
								dp.draw(PLine(ptX[p],ptInt[x]));
							else if (vxP.dotProduct(ptInt[x] - ptX[p+1])<0 && plRec.isOn(ptInt[x]) && pp.pointInProfile(ptX[p+1])!=1)
							{
								ptInt = Line(ptX[p+1], -vxP).orderPoints(ptInt);
								for(int y = 0; y < ptInt.length();y++)
									if (vxP.dotProduct(ptInt[y] - ptX[p+1])<0)
									{
										dp.draw(PLine(ptX[p+1],ptInt[y]));
										break;
									}
								break;
							}
						}	
					}
				}			
			}
			else
				bOk = TRUE;
			if (bOk)
				dp.draw(pl);
		}
		for (int i = 0; i < pts.length(); i++)
			pts[i].transformBy(vy * .4288 * dWidth);
	}




#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0```0`!``#__@`N26YT96PH4BD@2E!%1R!,:6)R87)Y
M+"!V97)S:6]N(%LQ+C4Q+C$R+C0T70#_VP!#`%`W/$8\,E!&049:55!?>,B"
M>&YN>/6ON9'(________________________________________________
M____VP!#`55:6GAI>.N"@NO_____________________________________
M____________________________________Q`&B```!!0$!`0$!`0``````
M`````0(#!`4&!P@)"@L0``(!`P,"!`,%!00$```!?0$"`P`$$042(3%!!A-1
M80<B<10R@9&A""-"L<$54M'P)#-B<H()"A87&!D:)28G*"DJ-#4V-S@Y.D-$
M149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@X2%AH>(B8J2DY25EI>8
MF9JBHZ2EIJ>HJ:JRL[2UMK>XN;K"P\3%QL?(R<K2T]35UM?8V=KAXN/DY>;G
MZ.GJ\?+S]/7V]_CY^@$``P$!`0$!`0$!`0````````$"`P0%!@<("0H+$0`"
M`0($!`,$!P4$!``!`G<``0(#$00%(3$&$D%1!V%Q$R(R@0@40I&AL<$)(S-2
M\!5B<M$*%B0TX27Q%Q@9&B8G*"DJ-38W.#DZ0T1%1D=(24I35%565UA96F-D
M969G:&EJ<W1U=G=X>7J"@X2%AH>(B8J2DY25EI>8F9JBHZ2EIJ>HJ:JRL[2U
MMK>XN;K"P\3%QL?(R<K2T]35UM?8V=KBX^3EYN?HZ>KR\_3U]O?X^?K_P``1
M"`$L`9`#`1$``A$!`Q$!_]H`#`,!``(1`Q$`/P":@`H`*`"@`H`*`&/(%X')
MIV)<K#-TC=!^0H)NV*$<]3C\:+CY6)Y+>HHN+E8OEN!P?UHN/E8F9%]3^M&@
MO>0Y9<\-P:+%*7<DI%!0`4`%`!0`4`%`",P4<T";L1>8[?='Y"G8GF;`+(>I
M(_&@5FP,+>HHN/E8HB8="!1<.5B8D7U/ZT:"]Y"B5@?F%%A\SZDBL&&12*3N
M+0,*`"@`H`*`"@`)`&30!$923A13L1S=A,2-ZC]*-!>\Q3$QZGFBX^5B"%O4
M47#E8%9!T)/XT"LT+YCKU'YBBP^9H>CAO8^E(I.XZ@84`%`!0`4`%`!0!&TH
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
:31#2L1*,L!3(1.$4=A4W->5#J!A0`4``_]D4
`




#End
