#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
14.11.2013  -  version 1.00
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
/// 
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="14.11.2013"></version>

/// <history>
/// AS - 1.00 - 14.11.2013 -	Pilot version
/// </history>


PropString separator01(0, "", T("|Style|"));
separator01.setReadOnly(true);

PropString dimStyle(1, _DimStyles, "     "+T("|Dimension style|"));
PropInt headerColor(0, 1, "     "+T("|Textcolor header|"));
PropInt contentColor(1, 5, "     "+T("|Textcolor content|"));

PropDouble columnWidth(0, U(500), "     "+T("|Column width|"));
PropDouble rowHeight(1, U(75), "     "+T("|Row height|"));

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	_Pt0 = getPoint(T("|Select a position|"));
	return;
}


Entity stickFrameEntities[] = Group().collectEntities(true, ElementWallSF(), _kModelSpace);

String wallTypes[0];
int amounts[0];
for (int i = 0; i < stickFrameEntities.length(); i++) {
	ElementWallSF stickFrameWall = (ElementWallSF)stickFrameEntities[i];
	
	int wallIndex = wallTypes.find(stickFrameWall.code());
	if (wallIndex == -1) {
		wallTypes.append(stickFrameWall.code());
		amounts.append(1);
	}
	else {
		amounts[wallIndex] += 1;
	}
}

// Display
Display headerDisplay(headerColor);
headerDisplay.dimStyle(dimStyle);
Display contentDisplay(contentColor);
contentDisplay.dimStyle(dimStyle);

// Draw headers
Point3d startPositionRow = _Pt0 - _YW * rowHeight;
Point3d startPositionColumn = startPositionRow;
headerDisplay.draw("WallType", startPositionColumn, _XW, _YW, 1, 1);
startPositionColumn += _XW * columnWidth;
headerDisplay.draw("Amount", startPositionColumn, _XW, _YW, 1, 1);

// Draw content
for (int i = 0;i < wallTypes.length(); i++){
	String wallType = wallTypes[i];
	int amount = amounts[i];
	
	startPositionRow -= _YW * rowHeight;
	startPositionColumn = startPositionRow;
	headerDisplay.draw(wallType, startPositionColumn, _XW, _YW, 1, 1);
	startPositionColumn += _XW * columnWidth;
	headerDisplay.draw(amount, startPositionColumn, _XW, _YW, 1, 1);
}
#End
#BeginThumbnail

#End
