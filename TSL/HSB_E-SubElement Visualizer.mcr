#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
13.09.2013  -  version 1.00

This tsl visualizes sub-elements in the main element.


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
/// This tsl creates sub-elements from openings and modules.
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="13.09.2013"></version>

/// <history>
/// AS - 1.00 - 13.09.2013 -	First revision
/// </history>


if( _bOnInsert ){
	_Viewport.append(getViewport(T("|Select a viewport|")));
	_Pt0 = getPoint(T("|Select a position|"));
	
	return;	
}

Display dpName(-1);
dpName.textHeight(U(5));
dpName.draw(_ThisInst.scriptName(), _Pt0, _XW, _YW, 1, 2);

if( _Viewport.length() == 0 ){
	reportWarning(TN("|No viewport selected|"));
	eraseInstance();
	return;
}

Viewport vp = _Viewport[0];

Element el = vp.element();
if( !el.bIsValid() )
	return;

CoordSys ms2ps = vp.coordSys();

Display dp(-1);

Map mapSubElements = el.subMapX("SubElement[]");
for( int i=0;i<mapSubElements.length();i++ ){
	if( !mapSubElements.hasEntity(i) || mapSubElements.keyAt(i) != "SubElement".makeUpper() )
		continue;
	
	Entity ent = mapSubElements.getEntity(i);
	Element elSub = (Element)ent;
	if( !elSub.bIsValid() )
		continue;
	
	GenBeam arGBm[] = elSub.genBeam();
	for( int j=0;j<arGBm.length();j++ ){
		GenBeam gBm = arGBm[j];
		dp.color(gBm.color());
		Body bdGBm = gBm.realBody();
		bdGBm.transformBy(ms2ps);
		dp.draw(bdGBm);
	}
}


#End
#BeginThumbnail

#End
