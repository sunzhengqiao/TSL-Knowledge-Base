#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
21.10.2013  -  version 1.00

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
/// This tsl shows the planeprofiles of a zone.
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="21.10.2013"></version>

/// <history>
/// AS - 1.00 - 21.10.2013 -	First revision
/// </history>


if( _bOnInsert ){
	if( insertCycleCount()> 1){
		eraseInstance();
		return;
	}
	
	PrEntity ssE(T("|Select a set of entities|"), Entity());
	if (ssE.go())
		_Entity.append(ssE.set());
	
	return;	
}

Display dp(1);
double dSize = U(250);
dp.textHeight(0.5 * dSize);

String arSText[] = {
	"X",
	"Y",
	"Z"
};
int arColor[] = {
	1,
	3,
	150
};

for (int i=0;i<_Entity.length();i++) {
	Entity ent = _Entity[i];
	
	CoordSys csEnt = ent.coordSys();
	
	Vector3d arVector[] = {
		csEnt.vecX(),
		csEnt.vecY(),
		csEnt.vecZ()
	};
	
	for (int j=0;j<arVector.length();j++) {
		Vector3d vector = arVector[j];
		String sText = arSText[j];
		
		dp.color(arColor[j]);
		
		LineSeg lnSeg(csEnt.ptOrg(), csEnt.ptOrg() + vector * dSize);
		dp.draw(lnSeg);
		
		PLine plCircle(vector);
		plCircle.createCircle(csEnt.ptOrg() + vector * 0.85 * dSize, vector, 25);
		dp.draw(plCircle);
		
		dp.draw(sText, csEnt.ptOrg() + vector * dSize, _XU, _YU, 1.25, 1.25, _kDevice);
	}
}



#End
#BeginThumbnail

#End
