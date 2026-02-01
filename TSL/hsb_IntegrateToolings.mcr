#Version 8
#BeginDescription
Last modified by: Anno Sportel (support.nl@hsbcad.com)
14.06.2018 -  version 1.01
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Tsl to show the datum position.
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="14.06.2018"></version>

/// <history>
/// 1.00 - 14.06.2018 - 	Pilot version
/// 1.01 - 14.06.2018 - 	Set default to no.
/// </hsitory>

String noYes[] = 
{
	T("|No|"),
	T("|Yes|")
};

PropString modifySectionForCnCProp(0, noYes, T("|Modify section for CnC|"), 0);
modifySectionForCnCProp.setDescription(T("|Specifies whether the tool is allowed to grow in its free directions for machine operations.|"));

if (_bOnInsert)
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	Beam selectedBeams[0];
	PrEntity selectedSetOfBeams(T("|Select beams|"), Beam());
	if (selectedSetOfBeams.go())
	{
		selectedBeams.append(selectedSetOfBeams.beamSet());
	}
	
	Beam tools[0];
	PrEntity selectedSetOfToolBeams(T("|Select tools|"), Beam());
	if (selectedSetOfToolBeams.go())
	{
		tools.append(selectedSetOfToolBeams.beamSet());
	}
	
	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Entity lstEntities[0];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	
	for (int t=0;t<tools.length();t++)
	{
		lstBeams.setLength(0);
		
		mapTsl.setEntity("Tool", tools[t]);
		lstBeams.append(tools[t]);
		lstBeams.append(selectedBeams);
		
		TslInst tslNew;
		tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);	
	}
	
	eraseInstance();
	return;
}

Beam toolBeam;
if (_Map.hasEntity("Tool"))
{
	Entity toolBeamEnt = _Map.getEntity("Tool");
	toolBeam = (Beam)toolBeamEnt;
}
_Entity.append(toolBeam);
setDependencyOnEntity(toolBeam);

if (!toolBeam.bIsValid())
{
	eraseInstance();
	return;
}
if (_Beam.length() == 0)
{
	eraseInstance();
	return;
}

String addBeamsCommand = T("|Add beams|");
addRecalcTrigger(_kContext, addBeamsCommand);

String removeBeamsCommand = T("|Remove beams|");
addRecalcTrigger(_kContext, removeBeamsCommand);

if (_kExecuteKey == addBeamsCommand || _kExecuteKey == removeBeamsCommand)
{
	String addRemove = _kExecuteKey == addBeamsCommand ? T("|add|") : T("|remove|");
	PrEntity selectedSetOfBeams(T("|Select beams to| ") + addRemove, Beam());
	if (selectedSetOfBeams.go())
	{
		Beam selectedBeams[] = selectedSetOfBeams.beamSet();
		for (int b=0;b<selectedBeams.length();b++)
		{
			Beam selectedBeam = selectedBeams[b];
			int beamIndex = _Beam.find(selectedBeam);
			if (beamIndex != -1 && _kExecuteKey == removeBeamsCommand)
			{
				_Beam.removeAt(beamIndex);
			}
			else if (beamIndex == -1 && _kExecuteKey == addBeamsCommand)
			{
				_Beam.append(selectedBeam);
			}
		}
	}
}

int modifySectionForCnC = noYes.find(modifySectionForCnCProp, 0);
int toolColor = modifySectionForCnC ? 7 : 1;

Point3d toolOrg = toolBeam.ptCenSolid();
Vector3d toolX = toolBeam.vecX();
Vector3d toolY = toolBeam.vecY();
Vector3d toolZ = toolBeam.vecZ();
double toolLength = toolBeam.solidLength();
double toolWidth = toolBeam.solidWidth();
double toolHeight = toolBeam.solidHeight();

Body toolBody = toolBeam.envelopeBody();

_ThisInst.assignToGroups(toolBeam, 'T');
Display toolDisplay(toolColor);
toolDisplay.draw(LineSeg(toolOrg - toolX * 0.5 * toolLength, toolOrg + toolX * 0.5 * toolLength));

BeamCut tool(toolOrg, toolX, toolY, toolZ, toolLength, toolWidth, toolHeight, 0, 0, 0);
tool.setModifySectionForCnC(modifySectionForCnC);

for (int b=0;b<_Beam.length();b++)
{
	Beam bm = _Beam[b];
	if (bm == toolBeam) continue;
	
	if (bm.envelopeBody().hasIntersection(toolBody))
	{
		bm.addTool(tool);
	}
}
#End
#BeginThumbnail

#End
#BeginMapX

#End