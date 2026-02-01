#Version 8
#BeginDescription
Last modified by: Robert Pol (robert.pol@hsbcad.com)
06.02.2017  -  version 1.00

This tsl will trigger a tsl in a viewport
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
///This tsl will trigger a tsl in a viewport
/// </summary>

/// <insert>
/// Select a viewport
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="06.02.2017"></version>

/// <history>
/// RP - 1.00 - 06.02.2017 -	First version

/// </history>


PropString dimStyle(0, _DimStyles, T("|Dimension style text|"));
PropString tslName(1, "HSB_E-Replicator", T("|Tsl to trigger|"));
PropString executekey(2, "setInViewport", T("|Execute Key|"));

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	_Viewport.append(getViewport(T("|Select a viewport|")));
	_Pt0 = getPoint(T("|Select a position|"));
	
	showDialog();
	return;
}

if( _Viewport.length() == 0 ){
	eraseInstance();
	return;
}
// get the viewport
Viewport vp = _Viewport[0];

// Draw name
String sInstanceNameAndDescription = _ThisInst.scriptName();

Display dpName(1);
dpName.dimStyle(dimStyle);
dpName.draw(sInstanceNameAndDescription, _Pt0, _XW, _YW, 1, 2);

double dTextHeightName = dpName.textHeight(20);

Element el = vp.element();
if( !el.bIsValid() )
	return;
	
TslInst allTsls[] = el.tslInst();

for (int i =0;i< allTsls.length();i++)
{
	TslInst tsl = allTsls[i];
	
	if (tsl.scriptName() == tslName)
		tsl.recalcNow(executekey);
		
}
;
#End
#BeginThumbnail



#End