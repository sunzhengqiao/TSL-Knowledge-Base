#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad)
26.08.2015  -  version 1.00
#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl creates a marker line on a specified position
/// </summary>

/// <insert>
/// Select a beam and a position
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="26.08.2015"></version>

/// <history>
/// AS - 1.00 - 26.08.2015 -	Pilot version
/// </history>

PropDouble marbleDiameter(0, U(5), T("|Marble diameter|"));

_Beam0.addTool(Mark(_Pt0, _Y0));

setMarbleDiameter(marbleDiameter);

#End
#BeginThumbnail


#End