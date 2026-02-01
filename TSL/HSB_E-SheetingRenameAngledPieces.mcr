#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
09.06.2017  -  version 1.01
Renames angled sheeting
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
/// Renames angled sheeting
/// </summary>

/// <insert>
/// Select Roof Elements(s)
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <history>
/// DR - 1.00 - 03.05.2017	- Copied from LP-R-AngledTileLath.mcr - Release
/// DR - 1.01 - 09.06.2017	- Values exposed as properties
/// </history>

Unit (1,"mm");
double dTolerance=U(0.001);

//region OPM
int nZones[]={0,1,2,3,4,5,6,7,8,9,10};
PropInt nZone(0, nZones, "Zone", 5);
PropString sName(0, "", T("|Name|"));
PropString sMaterial(1, "", T("|Material|"));
PropString sGrade(2, "", T("|Grade|"));
PropString sInformation(3, "", T("|Information|"));
PropString sLabel(4, "", T("|Label|"));
PropString sSubLabel(5, "", T("|SubLabel|"));
PropString sSubLabel2(6, "", T("|SubLabel2|"));
PropString sBeamCode(7, "PANLATS", T("|Beam code|"));
PropInt nColor(1,82, T("|Color|"));

// Set properties if inserted with an execute key
String sCatalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( sCatalogNames.find(_kExecuteKey) != -1 )
	setPropValuesFromCatalog(_kExecuteKey);
//endregion

if (_bOnInsert)
{
	if (insertCycleCount() > 1) 
	{
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || sCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();

	setCatalogFromPropValues(T("_LastInserted"));
	
	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Entity lstEntities[1];	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;

	PrEntity ssElements(T("|Select elements|"), Element());
	if (ssElements.go()) 
	{
		Element selectedElements[] = ssElements.elementSet();
		
		for (int e=0;e<selectedElements.length();e++) {
			Element selectedElement = selectedElements[e];
			if (!selectedElement.bIsValid())
				continue;
			
			lstEntities[0] = selectedElement;

			TslInst tslNew;
			tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}		
	}
	
	eraseInstance();
	return;
}

// set properties from catalog
setPropValuesFromCatalog(T("|_LastInserted|"));

int nSelectedZone= nZones.find(nZone);
int nZoneIndex = nSelectedZone;
if( nZoneIndex > 5 )
	nZoneIndex = 5 - nZoneIndex;

if (_Element.length() == 0) {
	reportWarning(T("|invalid or no element selected.|"));
	eraseInstance();
	return;
}

Element el = _Element[0];
if(!el.bIsValid())
{
	eraseInstance();
	return;	
}

CoordSys csEl = el.coordSys();
Point3d ptElOrg  = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
_Pt0 = el.ptOrg();

Sheet shAll[] = el.sheet(nZoneIndex);
Sheet shAlignedTovxEl[]= vyEl.filterBeamsPerpendicular(shAll); // Must be paralell to vxEl
for (int s=0;s<shAlignedTovxEl.length();s++) 
{ 
	Sheet sh= shAlignedTovxEl[s];
	PLine plSh= sh.plEnvelope();
	Point3d ptVertex[]= plSh.vertexPoints(true);
	
	if(ptVertex.length()!=4) // Must have 4 vertexes only
		continue;
	
	int bHasAngleDiferentThan90=false;
	for (int p=0;p<ptVertex.length();p++) // All internal angles must be 90 degrees
	{ 
		Point3d ptCen = ptVertex[p];
		Point3d pt1, pt2;
		if(p==0)
		{
			pt1=ptVertex[p+1];
			pt2=ptVertex[ptVertex.length()-1];
		}
		else if(p==ptVertex.length()-1)
		{
			pt2=ptVertex[p-1];
			pt1=ptVertex[0];
		}
		else
		{
			pt1=ptVertex[p+1];
			pt2=ptVertex[p-1];
		}
		Vector3d v1= pt1-ptCen;v1.normalize();
		Vector3d v2= pt2-ptCen;v2.normalize();
		
		double dScalar= abs(v1.dotProduct(v2));
		if(dScalar>dTolerance)
		{
			bHasAngleDiferentThan90=true;
			break;
		}
	}
	
	if(bHasAngleDiferentThan90)
	{
		sh.setName(sName);
		sh.setMaterial(sMaterial);
		sh.setGrade(sGrade);
		sh.setInformation(sInformation);
		sh.setLabel(sLabel);
		sh.setSubLabel(sSubLabel);
		sh.setSubLabel2(sSubLabel2);
		sh.setBeamCode("PANLATS");
		sh.setColor(nColor);
	}
}
reportMessage(TN("|nZoneIndex|: ")+nZoneIndex);//TODO //aa

eraseInstance();
return;
#End
#BeginThumbnail




#End