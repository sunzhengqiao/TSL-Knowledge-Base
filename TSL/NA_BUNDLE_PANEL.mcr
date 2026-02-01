#Version 8
#BeginDescription
#Versions
V2.4 9/24/2021 Will always reset bundle data submapX

V2.3 09/16/2021 Fixed dimensions for flipped panels
V2.2__May 28 2015__Pushes Bundle Data to Element
v2.1 12_3_2014    Removed Very Top Plates   (jf@hsbcadna.com) 














#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 5
#KeyWords 
#BeginContents
int arIColorsToIgnore[] ={ 2, 3, 5, 6, 14, 15, 16, 17, 18, 19, 28, 29, 32, 36, 37, 38, 39, 46, 47, 48, 49, 59, 68, 69};

int iMaxQtyOfAngledBlockings = 5;

double dMaxOpeWidth = U(190.8);
double dMaxOpeHeight = U(79);

MapObject moWallHeights("moWallHeights", "GroupColors");
Map mpWH = moWallHeights.map();
MapObject moFloorLengths("moFloorLengths", "GroupColors");
Map mpFL = moFloorLengths.map();

String stResetColors = T("|Reset colors in this file|");
addRecalcTrigger(_kContextRoot, stResetColors);

if(_kExecuteKey == stResetColors)
{ 
	if (moWallHeights.bIsValid())moWallHeights.dbErase();
	if (moFloorLengths.bIsValid()) moFloorLengths.dbErase();
}

Unit(1, "inch" ) ;
Display dp(7);
Display dp1(2);
Display dp2(32);
Display dp3(3);

//##########################__Properties__###########################
PropString strDimStyle(0,_DimStyles,"DimStyle");
PropString strStack(1,"X-999-999-999","Location(Bundle,Row,Position)");
String arYN[]={"Yes","No"};
PropString strShowHeight(2,arYN,"Show Panel Sizes",0);

PropString strLink(3,arYN,"Link to real panel",1);

PropString strFlip(4,arYN,"Flip me",1);

PropDouble dAddLeft(0,U(0),"Additional Gap Left");
PropDouble dAddRight(1,U(0),"Additional Gap Right");

Point3d ptParentRef = _Pt0;
Entity entParent;

int arColor[] = { - 1, 32};
PropInt pColor(0, arColor, T("|Forced Color|"));
pColor.setCategory(T("|Color Management|"));

PropInt piAssignedColor(1, -1, T("|Color Group|"));
piAssignedColor.setReadOnly(true);
piAssignedColor.setCategory(T("|Color Management|"));

if(_Map.hasMap("mpStackLocation")){
	Map mp=_Map.getMap("mpStackLocation");
	String stId;
	
	String stPrefix=mp.getString("stPrefix");
	if(stPrefix.length()>0)stId+=String(stPrefix + "-");
	
	String stStack= mp.getInt("iStack");
	if(stStack.length() < 3)stStack= String(mp.getInt("iStack")+1000).right(3);
	stId+=String(stStack + "-");
	
	String stRow= mp.getInt("iRow");
	if(stRow.length() < 3)stRow= String(mp.getInt("iRow")+1000).right(3);
	stId+=String(stRow + "-");
	
	String stPlace= mp.getInt("iPlace");
	if(stPlace.length() < 3)stPlace= String(mp.getInt("iPlace")+1000).right(3);	
	stId+=stPlace;
	strStack.set(stId);
	
	if(mp.hasPoint3d("ptParentRef"))ptParentRef = mp.getPoint3d("ptParentRef");
	
	entParent = mp.getEntity("entParent");
	
}
strStack.setReadOnly(TRUE);

int nSortByNumber=1;//if set to 0 it will group like walls together

//##########################__End Properties__###########################


_PtG.setLength(5);
//##########################__Insertion routine__##########################
if(_bOnInsert){
	
	//showDialogOnce("_Default");// Must be here before PrEntity selection, otherwise won't clone itself
	
	
	//__Get existing Slaves
	String stArNamesExisting[0];
	{
		///Group and slaves
		Group gr("X - STACKER","EXPORT","");
		
		///Check to see if it exists for that panel already
		Entity ents[] = gr.collectEntities(FALSE,TslInst(),_kModel);
		for (int i=0; i<ents.length(); i++) {
			TslInst tsl=(TslInst)ents[i];
			Map mp=tsl.map();
			if(mp.hasString("mpStackChildPanel\\stEl"))stArNamesExisting.append(mp.getString("mpStackChildPanel\\stEl"));
		}
	}

	Element arAllEl[0];
	double arDL[0];
	double arDW[0];
	int arNSortEl[0];
	String arAlpha="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	String arNumeric="0123456789";

	PrEntity ssE("\nSelect a set of Wall elements",Element());
	if (ssE.go())
	{
		Element ents[0];
		ents = ssE.elementSet().filterValid();
		
		// turn the selected set into an array of elements
		for (int i = 0; i < ents.length(); i++) {
			Element el = ents[i];
			Wall w = (Wall)el;
			Element elR = (ElementRoof)el;
			
			if (stArNamesExisting.find(el.number()) > - 1)continue;
			//Append wall
			arAllEl.append(el);
			//append name as integer
			String strName = "";
			String strOrig = el.number();
			strOrig.makeUpper();
			for (int s = 0; s < strOrig.length(); s++) {
				String chr = strOrig.getAt(s);
				int nA = arAlpha.find(chr, 0);
				int nN = arNumeric.find(chr, 0);
				if (nA >- 1)strName += nA;
				else if (nN >- 1)strName += nN;
				//else do nothing
			}
			while (strName.length() < 7) strName += "0";
			arNSortEl.append(strName.atoi());
			//append width and length
			double dElW = U(0), dElL = U(0);
			GenBeam arGb[] = el.genBeam();
			Point3d arPtGb[0];
			for (int g = 0; g < arGb.length(); g++)arPtGb.append(arGb[g].envelopeBody().allVertices());
			
			//Collect truss points
			Group elG = el.elementGroup();
			Entity arGbTruss[] = elG.collectEntities(true, TrussEntity(), _kModelSpace);
			for (int i = 0; i < arGbTruss.length(); i++)
			{
				TrussEntity te = (TrussEntity) arGbTruss[i];
				TrussDefinition td = te.definition();
				CoordSys csT = te.coordSys();
				Map mp = td.subMapX("Content");
				if (mp.length() > 0)
				{
					double sizes[] = { mp.getVector3d("Length").length(), mp.getVector3d("Width").length(), mp.getVector3d("Height").length()};
					
					Body bdT(csT.ptOrg() + 0.5 * sizes[0] * csT.vecX() + 0.5 * sizes[2] * csT.vecZ(), csT.vecX(), csT.vecY(), csT.vecZ(), sizes[0], sizes[1], sizes[2], 0, 0, 0);
					arPtGb.append(bdT.allVertices());
				}
				else
				{
					GenBeam arTdBm[] = td.genBeam();
					for (int g = 0; g < arTdBm.length(); g++)
					{
						Body bd = arTdBm[g].envelopeBody();
						bd.transformBy(csT);
						arPtGb.append(bd.allVertices());
					}
					
				}
			}
			
			if (arPtGb.length() > 1) {
				arPtGb = Line(el.ptOrg(), el.vecZ()).orderPoints(arPtGb);
				dElW = abs(el.vecZ().dotProduct(arPtGb[arPtGb.length() - 1] - arPtGb[0]));
				arDW.append(dElW);
				arPtGb = Line(el.ptOrg(), el.vecX()).orderPoints(arPtGb);
				dElL = abs(el.vecX().dotProduct(arPtGb[arPtGb.length() - 1] - arPtGb[0]));
				arDL.append(dElL);
			}
			else if (w.bIsValid()) {
				dElL = abs(el.vecX().dotProduct(w.ptStart() - w.ptEnd()));
				dElW = w.instanceWidth();
				arDW.append(dElW);
				arDL.append(dElL);
			}
			else if (elR.bIsValid())
			{
				PLine plEl = el.plEnvelope();
				Point3d arPt[] = Line(_Pt0, el.vecX()).orderPoints(plEl.vertexPoints(true));
				dElL = abs(el.vecX().dotProduct(arPt[arPt.length() - 1] - arPt[0]));
				arPt = Line(_Pt0, el.vecY()).orderPoints(plEl.vertexPoints(true));
				dElW = abs(el.vecY().dotProduct(arPt[arPt.length() - 1] - arPt[0]));
			}
			
		}
	}
	
	
	if(nSortByNumber){
		Element elD;
		double dD;
		int nD;
		for (int b1=1; b1<arAllEl.length(); b1++) {
			int lb1 = b1;
				for (int b2 = b1-1; b2>=0; b2--) {
	   				if (arNSortEl[lb1]<arNSortEl[b2]) {
					elD = arAllEl[b2]; arAllEl[b2] = arAllEl[lb1];  arAllEl[lb1] = elD;
					dD = arDL[b2]; arDL[b2] = arDL[lb1]; arDL[lb1] = dD;
					dD = arDW[b2]; arDW[b2] = arDW[lb1]; arDW[lb1] = dD;
					nD = arNSortEl[b2]; arNSortEl[b2] = arNSortEl[lb1]; arNSortEl[lb1] = nD;
					lb1=b2;
				}
			}
		}
		
		_Pt0 = getPoint( "Select a reference point to display Wall" ) ;
		
		//PREPARE CLONING
		// declare tsl props 
		TslInst tsl;
		String sScriptName = scriptName();
	
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[1];
		Point3d lstPoints[1];
		
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		lstPropString.append("Standard");
		lstPropString.append("X-999-999-999");
		lstPropString.append("Yes");
		lstPropString.append("No");
		lstPropString.append("No");		
		
		Point3d ptInSlide=_Pt0;
	
		Point3d ptInsert=ptInSlide;
		
		int nLastGroup=1;//Must be sequenced
	
		for(int i=0; i<arAllEl.length();i++){
				
			lstPoints[0] = ptInSlide;
			lstEnts[0] = arAllEl[i];
			//see if it needs to be flipped
			//if(arDL[i]>U(144))lstPropString[4]="Yes";
			//else 
			 lstPropString[4]="No";
		
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );  
			ptInSlide.transformBy(_YW*arDW[i]);
			
			//reportMessage("\nEl:"+arAllEl[i].number()+"="+arNSortEl[i]);
			
		}
		eraseInstance();
		return;		
	}
	else{
		Element elD;
		double dD;
		int nD;
		for (int b1=1; b1<arAllEl.length(); b1++) {
			int lb1 = b1;
				for (int b2 = b1-1; b2>=0; b2--) {
	   				if (arDL[lb1]>arDL[b2]) {
					elD = arAllEl[b2]; arAllEl[b2] = arAllEl[lb1];  arAllEl[lb1] = elD;
					dD = arDL[b2]; arDL[b2] = arDL[lb1]; arDL[lb1] = dD;
					dD = arDW[b2]; arDW[b2] = arDW[lb1]; arDW[lb1] = dD;
					nD = arNSortEl[b2]; arNSortEl[b2] = arNSortEl[lb1]; arNSortEl[lb1] = nD;
					lb1=b2;
				}
			}
		}
		for (int i=0; i<arAllEl.length(); i++){
			_Element.append(arAllEl[i]);
		}
		
		
		_Pt0 = getPoint( "Select a reference point to display Wall" ) ;
	
		///Find the proper Groups
		String arCode[0];
		String arConsol[0];
		double arHeight[0];
		int arNGroup[0];
		
		Element arElNew[0];
		int arNNewGroup[0];
		
		int nGroupCount=1;
		
		for(int i=0; i<_Element.length();i++){
			Element el=_Element[i];
			Wall w=(Wall)el;
			int nGable=0;
			int nGroup=0;
			
			Group arG[]=el.groups();
			
			Body bdWall;
			Beam arBmAll[]=el.beam();
			for(int b=0; b<arBmAll.length();b++){
				String strBC=arBmAll[b].beamCode().token(0);strBC.makeUpper();
				if(strBC != "V")bdWall.combine(arBmAll[b].realBody());
				int arGableTypes[]={ _kSFAngledTPLeft, _kSFAngledTPRight};
				if(arGableTypes.find(arBmAll[b].type())>-1)nGable=1;
			}
			
			////This wall's info
			String strCode=el.code();
			String strConsol=arG[0].namePart(1);
			double dElH=w.baseHeight();
			if(arBmAll.length()>0){
				Point3d arPtExtreme[]=bdWall.extremeVertices(el.vecY());
				dElH=abs(el.vecY().dotProduct(arPtExtreme[0]-arPtExtreme[1]));
			}
			if(nGable){
				nGroup=999;
			}
			else{
				for(int i=0; i<arCode.length();i++){
					if(strCode==arCode[i] &&
					strConsol==arConsol[i] &&
					int(dElH*100)==int(arHeight[i]*100)){//Got a match
						nGroup=arNGroup[i];
						break;
					}
				}
			}
					
			if(nGroup==0){//New Group
				nGroup=nGroupCount;
				nGroupCount++;
				
				arCode.append(el.code());
				arConsol.append(arG[0].namePart(1));
				arHeight.append(dElH);
				arNGroup.append(nGroup);
			}
			//Add it to the list
			arElNew.append(el);
			arNNewGroup.append(nGroup);
		}
		///List is made. Must sort Now
		//		Element>>>> 		arElNew[0];
		//		int>>>>		 	arNNewGroup[0];
		//Sort them by group
		Element elD2;
		int nD2;
		for (int b1=1; b1<arNNewGroup.length(); b1++) {
			int lb1 = b1;
	 		for (int b2 = b1-1; b2>=0; b2--) {
	    			if (arNNewGroup[lb1]<arNNewGroup[b2]) {
		     		elD2 = arElNew[b2]; arElNew[b2] = arElNew[lb1];  arElNew[lb1] = elD2;
					nD2 = arNNewGroup[b2]; arNNewGroup[b2] = arNNewGroup[lb1]; arNNewGroup[lb1] = nD2;
					lb1=b2;
				}
			}
		}
		
		//PREPARE CLONING
		// declare tsl props 
		TslInst tsl;
		String sScriptName = scriptName();
	
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[1];
		Point3d lstPoints[1];
		
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		
		Point3d ptInSlide=_Pt0;
	
		Point3d ptInsert=ptInSlide;
		
		int nLastGroup=1;//Must be sequenced
	
		for(int i=0; i<arElNew.length();i++){
			if(arNNewGroup[i]==nLastGroup)ptInsert.transformBy((arElNew[i].dBeamWidth()+arElNew[i].zone(1).dH()+arElNew[i].zone(2).dH()+arElNew[i].zone(3).dH()+arElNew[i].zone(4).dH()+arElNew[i].zone(-1).dH()+arElNew[i].zone(-2).dH()+arElNew[i].zone(-3).dH()+arElNew[i].zone(-4).dH()) *_YW);
			else{
				ptInSlide.transformBy(_XW*U(180));
				ptInsert=ptInSlide;
			}
			lstPoints[0]=ptInsert;
			lstEnts[0] = arElNew[i];
		
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );  
			
			nLastGroup=arNNewGroup[i];
		}
	}
	eraseInstance();
	return;
	
}//END _bOnInsert
//##########################__End Insertion routine__########################


if(_bOnElementListModified){
	
	Point3d ptCreate=_Pt0;
	
	for(int e=_Element.length()-1;e>0;e--){

		TslInst tsl;
		String sScriptName = scriptName();
	
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[1];
		Point3d lstPoints[1];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		
		//Point3d arPtEl[]=Line(_Pt0,_Element[e].vecX()).orderPoints( _Element[e].plEnvelope().vertexPoints(TRUE));
		//double dMove=_Element[e].vecX().dotProduct(arPtEl[arPtEl.length()-1] - arPtEl[0]);
	

		lstPoints[0]=ptCreate;
		lstEnts[0] = _Element[e];
		
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );  
		_Element.removeAt(e);
		//ptCreate.transformBy(_XW*dMove);
	}
	//eraseInstance();
}


//#####################__Reference entities and geometry__####################
if(_Element.length() ==0)
{ 
	eraseInstance();
	return;
}
Element el = _Element0 ;
ElementRoof elR = (ElementRoof)el;
ElementWallSF elW= (ElementWallSF)el ;
int bStairElement = false;
Wall w = (Wall)el;
//el.setSubType("");


///Group and slaves
Group gr("X - STACKER","EXPORT","");
if(!gr.bExists())gr.dbCreate();
gr.setBIsDeliverableContainer(TRUE);

///Check to see if it exists for that panel already
TslInst arTslStacks[0];
Entity ents[] = gr.collectEntities(FALSE,TslInst(),_kModel);
for (int i=0; i<ents.length(); i++) {
	TslInst tsl=(TslInst)ents[i];
	Map mp=tsl.map();
	if(tsl.scriptName()== scriptName() && tsl != _ThisInst ){
		Map mpTSL=mp.getMap("mpStackChildPanel");
		String strName = mpTSL.getString("stEl");
		
		if(strName==el.number()){
			reportMessage("\nPanel "+ strName + " was selected twice." + "\nAn instance has been deleted");
			eraseInstance();
		}
	}
	if(mp.hasPLine("plStackArea"))arTslStacks.append(tsl);
}
gr.addEntity(_ThisInst,TRUE);

Vector3d vx = el.vecX() ;
Vector3d vy = el.vecY() ;
Vector3d vz = el.vecZ() ;

Entity entsBlocks[] = el.allBlockRefPaths();

String stXRefName = el.xrefName();
Body bdEl;
Point3d arPtBackUpFloor[0];

if(elW.bIsValid())
{
	bdEl = Body(el.plOutlineWall(), vy * w.baseHeight(), 1);
}
else
{
	PLine pl = el.plEnvelope();
	if ( ! vz.isParallelTo(_ZW) || elR.dBeamWidth() == U(0))
	{
		bStairElement = true;
		arPtBackUpFloor.append(pl.vertexPoints(false));
		
		//find the longest segement to set VecX
		if ( ! vz.isParallelTo(_ZW))
		{
			Vector3d newVx = el.vecX();
			double dLongest = U(0);
			for (int e = 0; e < arPtBackUpFloor.length() - 1; e++)
			{
				Vector3d vPt(arPtBackUpFloor[e] - arPtBackUpFloor[e + 1]);
				if (vPt.length() > dLongest)
				{
					dLongest = vPt.length();
					newVx = vPt;
					newVx.normalize();
				}
			}
			vx = newVx;
			vy = vz;
			vz = vx.crossProduct(vy);
		}
	}
	else
	{
		bdEl = Body(elR.plEnvelope(), vz * elR.dBeamWidth(), - 1);
		
		arPtBackUpFloor.append(pl.vertexPoints(true));
		pl.transformBy(elR.dBeamWidth() * vz);
		arPtBackUpFloor.append(pl.vertexPoints(true));
	}
}

//Get bottom plate size
String stBpSize = " No BP", stTpSize = " No TP", stLB = "";
if(elW.bIsValid()) stLB = elW.loadBearing() ? " LB" : " NLB" ;
String stBpMatGrade = "", stTpMatGrade = "";
int iTotalAngledBlockings = 0;
Point3d arPtBmBds[0];
Beam arBm[]=el.beam();
for(int i=0;i<arBm.length();i++)
{ 
	if(bStairElement)arPtBmBds.append(arBm[i].realBody().allVertices());
	else if(elR.bIsValid() && arBm[i].envelopeBody().hasIntersection( bdEl)) arPtBmBds.append(arBm[i].realBody().allVertices());
	else if (arBm[i].type() != _kSFVeryTopPlate && arBm[i].envelopeBody().hasIntersection( bdEl)) arPtBmBds.append(arBm[i].realBody().allVertices());
	
	if (arBm[i].type() == _kSFBottomPlate) { stBpSize = " " + ceil(arBm[i].dW()) + "xBP"; stBpMatGrade = arBm[i].material() + arBm[i].grade(); };
	if (arBm[i].type() == _kSFTopPlate) { stTpSize = " " + ceil(arBm[i].dW()) + "xTP"; stTpMatGrade = arBm[i].material() + arBm[i].grade(); };
	if(arBm[i].type() == _kBlocking || arBm[i].type() == _kSFBlocking || arBm[i].type() == _kCantileverBlock)
	{ 
		AnalysedTool arCuts[] = AnalysedTool().filterToolsOfToolType(arBm[i].analysedTools(), "AnalysedCut");
		
		for(int t=0;t<arCuts.length();t++)
		{
			AnalysedCut ac = (AnalysedCut)arCuts[t];
			if ( ! ac.bIsValid())continue;
			if ( ! ac.normal().isParallelTo(arBm[i].vecX())) 
			{
				iTotalAngledBlockings++;
				break;
			}
		}
	}
}
if (arPtBmBds.length() == 0) arPtBmBds.append(arPtBackUpFloor);

Point3d arPtVx[]=Line(el.ptOrg(),vx).orderPoints(arPtBmBds);
Point3d arPtVy[]=Line(el.ptOrg(),vy).orderPoints(arPtBmBds);
Point3d arPtVz[]=Line(el.ptOrg(),vz).orderPoints(arPtBmBds);

Plane pnSetTop ( Point3d(0,0,0), _ZW ) ;


int nGable=0;
double dPanelLength=U(1);
double dPanelHeight=U(1);
double dPanelThickness=U(1);


//get the color
int iColor = 32;

//get wall height formatted
String stHeightNote;
int Ft = dPanelHeight/12;
int In = dPanelHeight - 12 * Ft;
int Sx = (dPanelHeight - int(dPanelHeight)) * 16;

if(elR.bIsValid())
{
	//Change default orientaiton
	
	PLine plEl = el.plEnvelope();
	if (arPtBmBds.length() > 0)
	{
		dPanelLength = vx.dotProduct(arPtVx.last() - arPtVx.first());
		dPanelHeight = vy.dotProduct(arPtVy.last() - arPtVy.first());
		dPanelThickness = vz.dotProduct(arPtVz.last() - arPtVz.first());
	}
	
	vx = el.vecY();
	vy = -el.vecX();
	vz = vy.crossProduct(vx);
	
	exportWithElementDxa(elR);
	
	int Ft = dPanelLength / 12;
	int In = dPanelLength - 12 * Ft;
	int Sx = (dPanelLength - int(dPanelLength)) * 16;
	
	if (Ft < 10)stHeightNote += "0";
	stHeightNote += (Ft + "-");
	if (In < 10)stHeightNote += "0";
	stHeightNote += (In + "-");
	if (Sx < 10)stHeightNote += "0";
	stHeightNote += Sx;

	String stKey = "_k" + stHeightNote ;
	
	//Manage colors
	
	String arKeysUsed[0];
	int arUsedColors[0];
	for (int c = 0; c < mpFL.length(); c++)
	{
		if (mpFL.hasInt(c))
		{
			arKeysUsed.append(mpFL.keyAt(c));
			arUsedColors.append(mpFL.getInt(c));
		}
	}
	
	
	int iFind = arKeysUsed.find(stKey);
	if (iFind > - 1)
	{
		int iGo = arUsedColors[iFind];//New colors to ignore could be added. Check it each time.
		while (arIColorsToIgnore.find(iGo) > - 1)iGo++;
		iColor = iGo;
		arUsedColors[iFind] = iColor;
	}
	else
	{
		//get a new color
		int iGo = 1;
		while (arUsedColors.find(iGo) > - 1 || arIColorsToIgnore.find(iGo) > - 1)iGo++;
		
		arKeysUsed.append(stKey);
		arUsedColors.append(iGo);
		iColor = iGo;
	}
	piAssignedColor.set(iColor);
	//Store colors
	mpFL = Map();
	for (int c = 0; c < arKeysUsed.length(); c++)
	{
		mpFL.appendInt(arKeysUsed[c], arUsedColors[c]);
	}
	if (moFloorLengths.bIsValid()) moFloorLengths.setMap(mpFL);
	else moFloorLengths.dbCreate(mpFL);
}
else
{
	if ( ! elW.bIsValid() )
	{
		reportMessage( "\nNot the right type of Element" );
		eraseInstance();
	}
	dPanelLength = abs(vx.dotProduct(w.ptStart() - w.ptEnd()));
	dPanelHeight = w.baseHeight();
	dPanelThickness = el.dBeamWidth();
	exportWithElementDxa(elW);
	
	if (arPtBmBds.length() > 0)
	{
		dPanelLength = vx.dotProduct(arPtVx.last() - arPtVx.first());
		dPanelHeight = vy.dotProduct(arPtVy.last() - arPtVy.first());
	}
	
	//get wall height formatted
	int Ft = dPanelHeight / 12;
	int In = dPanelHeight - 12 * Ft;
	int Sx = (dPanelHeight - int(dPanelHeight)) * 16;
	
	if (Ft < 10)stHeightNote += "0";
	stHeightNote += (Ft + "-");
	if (In < 10)stHeightNote += "0";
	stHeightNote += (In + "-");
	if (Sx < 10)stHeightNote += "0";
	stHeightNote += Sx;
	
	stHeightNote += stLB;
	stHeightNote += stBpSize;
	stHeightNote += stTpSize;
	String stElWidth = " W" + round(w.instanceWidth());
	String stKey = "_k" + stHeightNote + stElWidth + stBpMatGrade + stTpMatGrade;
	
	//Manage colors
	
	String arKeysUsed[0];
	int arUsedColors[0];
	for (int c = 0; c < mpWH.length(); c++)
	{
		if (mpWH.hasInt(c))
		{
			arKeysUsed.append(mpWH.keyAt(c));
			arUsedColors.append(mpWH.getInt(c));
		}
	}
	
	
	int iFind = arKeysUsed.find(stKey);
	if (iFind > - 1)
	{
		int iGo = arUsedColors[iFind];//New colors to ignore could be added. Check it each time.
		while (arIColorsToIgnore.find(iGo) > - 1)iGo++;
		iColor = iGo;
		arUsedColors[iFind] = iColor;
	}
	else
	{
		//get a new color
		int iGo = 1;
		while (arUsedColors.find(iGo) > - 1 || arIColorsToIgnore.find(iGo) > - 1)iGo++;
		
		arKeysUsed.append(stKey);
		arUsedColors.append(iGo);
		iColor = iGo;
	}
	piAssignedColor.set(iColor);
	//Store colors
	mpWH = Map();
	for (int c = 0; c < arKeysUsed.length(); c++)
	{
		mpWH.appendInt(arKeysUsed[c], arUsedColors[c]);
	}
	if (moWallHeights.bIsValid()) moWallHeights.setMap(mpWH);
	else moWallHeights.dbCreate(mpWH);
}


//Force color to 32
if (pColor == arColor[1])iColor = 32;

dp.color(iColor);
dp2.color(iColor);




//
//if(elR.bIsValid())
//{
//    //Change default orientaiton
//    vx = el.vecY();
//    vy = el.vecX();
//    PLine plEl = el.plEnvelope();
//    Point3d arPt[] = Line(_Pt0,el.vecX()).orderPoints(plEl.vertexPoints(true));
//    dPanelLength = abs(el.vecX().dotProduct(arPt[arPt.length()-1] - arPt[0]));
//    arPt = Line(_Pt0,el.vecY()).orderPoints(plEl.vertexPoints(true));
//    dPanelHeight = abs(el.vecY().dotProduct(arPt[arPt.length()-1] - arPt[0]));
//    exportWithElementDxa(elR);
//}
//else
//{
//    if (! elW.bIsValid() )
//    {
//        reportMessage( "\nNot the right type of Element" ) ;
//        eraseInstance();
//    }
//    dPanelLength=abs(vx.dotProduct(w.ptStart()-w.ptEnd()));
//    dPanelHeight=w.baseHeight();
//    dPanelThickness=el.dBeamWidth();
//    exportWithElementDxa(elW);
//}
//
//Get opening sizes
Opening arOp[] = el.opening();
Point3d arPtStartOp[0], arPtEndOp[0];
CoordSys csTransformOpPoints;
for(int p=0;p<arOp.length();p++)
{
	Opening op = arOp[p];
	if ( ! op.bIsValid())continue;
	CoordSys csOp = op.coordSys();

	if(strFlip == arYN[0])
	{ 
		arPtStartOp.append(csOp.ptOrg());
		arPtEndOp.append(csOp.ptOrg() + csOp.vecY() * op.heightRough());
		csTransformOpPoints.setToAlignCoordSys(el.ptOrg(), el.vecY(), -el.vecX(), el.vecZ(), _Pt0, _XW, _YW, _ZW);
	}
	else
	{
		arPtStartOp.append(csOp.ptOrg());
		arPtEndOp.append(csOp.ptOrg() + csOp.vecX() * op.widthRough());
		csTransformOpPoints.setToAlignCoordSys(el.ptOrg(), el.vecX(), el.vecY(), el.vecZ(), _Pt0, _XW, _YW, _ZW);
	}
}

//flipped
if(strFlip==arYN[0]) {
	double dTemp[] = { dPanelHeight, dPanelLength};
	dPanelLength = dTemp[0];
	dPanelHeight = dTemp[1];

	//flip vectors after
	Vector3d vTemp[] = { vy, vx};
	vx = vTemp[0];
	vy = vTemp[1];
}


///Get Beams to see construction type
//Beam arBmAll []=el.beam();
//GenBeam arBmGB[]=el.genBeam();
//Point3d arPtBmBds[0];
//for(int i=0;i<arBmGB.length();i++){
//	//remove double top plates
//	String strCode=arBmGB[i].beamCode().token(0);strCode.makeUpper();
//	if(strCode=="V"){
//		arBmGB.removeAt(i);
//		i--;
//		continue;
//	}	// Set a name
//	GenBeam bm=arBmGB[i];
//	
//	//Check to see if it is gable
//	int arGableTypes[]={ _kSFAngledTPLeft, _kSFAngledTPRight};
//	if(arGableTypes.find(bm.type())>-1)nGable=1;
//	
//	//add all vertices to an array
//	arPtBmBds.append(bm.envelopeBody().allVertices());
//}
//
//if (elR.bIsValid())
//{
//	Group elG = el.elementGroup();
//	Entity arGb[] = elG.collectEntities(true, TrussEntity(), _kModelSpace);
//	for (int i = 0; i < arGb.length(); i++)
//	{
//		TrussEntity te = (TrussEntity) arGb[i];
//		TrussDefinition td = te.definition();
//		CoordSys csT = te.coordSys();
//		Map mp = td.subMapX("Content");
//		if (mp.length() > 0)
//		{
//			double sizes[] = { mp.getVector3d("Length").length(), mp.getVector3d("Width").length(), mp.getVector3d("Height").length()};
//			
//			Body bdT(csT.ptOrg() + 0.5 * sizes[0] * csT.vecX() + 0.5 * sizes[2] * csT.vecZ(), csT.vecX(), csT.vecY(), csT.vecZ(), sizes[0], sizes[1], sizes[2], 0, 0, 0);
//			arPtBmBds.append(bdT.allVertices());
//		}
//		else
//		{
//			GenBeam arTdBm[] = td.genBeam();
//			for (int g=0;g<arTdBm.length();g++) 
//			{ 
//				Body bd = arTdBm[g].envelopeBody(); 
//				bd.transformBy(csT);
//				arPtBmBds.append(bd.allVertices());
//			}
//			
//		}
//	}
//}
//
//
//Ordered Point arrays
//Point3d arPtVx[]=Line(el.ptOrg(),vx).orderPoints(arPtBmBds);
//Point3d arPtVy[]=Line(el.ptOrg(),vy).orderPoints(arPtBmBds);
//Point3d arPtVz[]=Line(el.ptOrg(),vz).orderPoints(arPtBmBds);
//
////Make sure I got the best values	
//if(arPtVx.length()>0)dPanelLength=abs(vx.dotProduct(arPtVx[0]-arPtVx[arPtVx.length()-1]));
//if(arPtVy.length()>0)dPanelHeight=abs(vy.dotProduct(arPtVy[0]-arPtVy[arPtVy.length()-1]));
//if(arPtVz.length()>0)dPanelThickness=abs(vz.dotProduct(arPtVz[0]-arPtVz[arPtVz.length()-1]));


//##########################_Actions to take if grips are edited_####################
if ( _kNameLastChangedProp == "_PtG0" ) {
	_PtG[0] = _PtG[0].projectPoint( pnSetTop, 0 ) ;
	_Pt0 = _PtG[0] - _XW * (dPanelLength/2 + dAddLeft) ;
}
if ( _kNameLastChangedProp == "_PtG1" ) {
	_PtG[1] = _PtG[1].projectPoint( pnSetTop, 0 ) ;
	_Pt0 = _PtG[1]  - _XW * (dPanelLength + dAddLeft + dAddRight) ;
}
if ( _kNameLastChangedProp == "_PtG2" ) {
	_PtG[2] = _PtG[2].projectPoint( pnSetTop, 0 ) ;
	_Pt0 = _PtG[2] - _XW * (dPanelLength + dAddLeft + dAddRight) - _YW * dPanelThickness;
}
if ( _kNameLastChangedProp == "_PtG3" ) {
	_PtG[3] = _PtG[3].projectPoint( pnSetTop, 0 ) ;
	_Pt0 = _PtG[3] - _XW * (dPanelLength/2 + dAddLeft) - _YW * dPanelThickness;
}
if ( _kNameLastChangedProp == "_PtG4" ) {
	_PtG[4] = _PtG[4].projectPoint( pnSetTop, 0 ) ;
	_Pt0 = _PtG[4] - _YW * dPanelThickness;
}


//###########################_Create/Set Grips _ ##################################
while ( _PtG.length() < 5 ) {
	_PtG.append( _Pt0 ) ;
}
_PtG[0] = _Pt0 + _XW * (dPanelLength/2 + dAddLeft) ;
_PtG[1] = _Pt0 + _XW * (dPanelLength + dAddLeft + dAddRight);
_PtG[2] = _Pt0 + _XW * (dPanelLength + dAddLeft + dAddRight) + _YW * dPanelThickness;
_PtG[3] = _Pt0 + _XW * (dPanelLength/2 + dAddLeft) + _YW * dPanelThickness;
_PtG[4] = _Pt0 + _YW * dPanelThickness;

///Start to draw
PLine plRec,plL,plR;
plRec.createRectangle(LineSeg(_Pt0,_PtG[2]),_XW,_YW);
plL=PLine(_Pt0,_Pt0+_YW * dPanelThickness/2+_XW * dPanelThickness/2,_PtG[4]);
plR=PLine(_PtG[1],_PtG[1]+_YW * dPanelThickness/2-_XW * dPanelThickness/2,_PtG[2]);

Point3d ptText=_Pt0 + _XW * dPanelLength/2 + _YW * dPanelThickness/2;

String strHeight,strLength;
strHeight.formatUnit(dPanelHeight,strDimStyle);
strLength.formatUnit(dPanelLength,strDimStyle);

String strElName=el.number();
if(strShowHeight==arYN[0])strElName=el.number() +" "+ strLength + "x"+ strHeight ;

if(strFlip==arYN[0]){//It is flipped
	if(strShowHeight==arYN[0])strElName=el.number() +" "+ strHeight + "x"+ strLength ;
	dp.color(80);
	
	dp.draw(plL);
	dp.draw(plR);	
}
if(nGable==1)strElName=el.number() + " - Gable";

//Find proper text height 
double dpTH = U(4);
double dTextLength = dp.textLengthForStyle(strElName, strDimStyle, dpTH);
double dTextHeight = dp.textHeightForStyle(strElName, strDimStyle, dpTH);
double dTestLength = (dPanelLength - U(1.2)) / dTextLength;
double dTestHeight = (dPanelThickness - U(1.2)) / dTextHeight;

double dScale = 1;
if (dTestHeight < dTestLength && dTestHeight < 1) dScale = dTestHeight;
else if (dTestLength < dTestHeight && dTestLength < 1) dScale = dTestLength;

dpTH *= dScale;

dp.textHeight(dpTH);

dp2.draw(plRec);
dp.draw(strElName,ptText,_XW,_YW,0,0);

Body bdElement(ptText, _XW, _YW, _ZW, dPanelLength, dPanelThickness, dPanelHeight, 0, 0, - 1);
dp2.draw(bdElement);

if(abs(dAddLeft) > U(0))
{
	LineSeg ls1(_Pt0, _PtG[4]+_XW*dAddLeft);
	LineSeg ls2(_PtG[4], _Pt0+_XW*dAddLeft);
	PLine plAdd;
	plAdd.createRectangle(ls1,_XW,_YW);
	
	dp.draw(ls1);
	dp.draw(ls2);
	dp.draw(plAdd);
}
if(abs(dAddRight) > U(0))
{
	LineSeg ls1(_PtG[1], _PtG[2]-_XW*dAddRight);
	LineSeg ls2(_PtG[2], _PtG[1]-_XW*dAddRight);
	PLine plAdd;
	plAdd.createRectangle(ls1,_XW,_YW);
	
	dp.draw(ls1);
	dp.draw(ls2);
	dp.draw(plAdd);
}

if(strLink==arYN[0]){
	PLine plLink(_Pt0,el.ptOrg());
	dp.draw(plLink);
}

//Draw Openings
Display dpOp(8);
dpOp.layer("Defpoints");
for (int p = 0; p < arPtStartOp.length(); p++)
{
	Point3d ptS = arPtStartOp[p];
	Point3d ptE = arPtEndOp[p];
	ptS.transformBy(csTransformOpPoints);
	ptE.transformBy(csTransformOpPoints);
	
	ptS = Line(_Pt0, _XW).closestPointTo(ptS);
	ptE = Line(_PtG[3], _XW).closestPointTo(ptE);
	ptS.vis(2);
	ptE.vis(4);
	
	LineSeg ls1(ptS, ptS + _YW * dPanelThickness);
	LineSeg ls2(ptE, ptE - _YW * dPanelThickness);
	
	dpOp.draw(ls1);
	dpOp.draw(ls2);
	
	dpOp.lineType("HIDDEN2");
	LineSeg lsDiag(ptS, ptE);
	dpOp.draw(lsDiag);
}

//Write data agaist the xref for nested walls.
String stChildMetadataKey = "Hsb_StackingChild";
Map mpStacking;
mpStacking.setMapName("Hsb_StackingChild");

el.removeSubMapX("Hsb_NestingChild");

if (entParent.bIsValid())
{
	mpStacking.setString("PARENTUID", entParent.handle());
	if (strFlip == arYN[0])
	{
		Vector3d vx = -_ZW;
		Vector3d vy = _YW;
		Vector3d vz = -_XW;
		double dX = _XW.dotProduct(_Pt0 - ptParentRef);
		double dY = _YW.dotProduct(_Pt0 - ptParentRef);
		double dZ = _ZW.dotProduct(_Pt0 - ptParentRef);
		
		Point3d ptRefWorldNew (dX, dY, ptParentRef.Z());
		mpStacking.setPoint3d("PTRELORG", ptRefWorldNew);
		mpStacking.setPoint3d("PTVECX", ptRefWorldNew + U(1) * vx);
		mpStacking.setPoint3d("PTVECY", ptRefWorldNew + U(1) * vy);
		mpStacking.setPoint3d("PTVECZ", ptRefWorldNew + U(1) * vz);
	}
	else
	{
		Vector3d vx = _XW;
		Vector3d vy = _YW;
		Vector3d vz = _ZW;
		double dX = _XW.dotProduct(_Pt0 - ptParentRef);
		double dY = _YW.dotProduct(_Pt0 - ptParentRef);
		double dZ = _ZW.dotProduct(_Pt0 - ptParentRef);
		
		Point3d ptRefWorldNew (dX, dY, ptParentRef.Z());
		mpStacking.setPoint3d("PTRELORG", ptRefWorldNew);
		mpStacking.setPoint3d("PTVECX", ptRefWorldNew + U(1) * vx);
		mpStacking.setPoint3d("PTVECY", ptRefWorldNew + U(1) * vy);
		mpStacking.setPoint3d("PTVECZ", ptRefWorldNew + U(1) * vz);
	}
}

Map mp;
mp.setMapName("mpStackChildPanel");
mp.setPoint3d("ptRef",ptText);
mp.setDouble("dLength",(dPanelLength + dAddLeft + dAddRight));
mp.setDouble("dHeight",dPanelHeight);
mp.setDouble("dThickness",dPanelThickness);
mp.setString("stEl",el.number());
mp.setEntity("entEl",el);
mp.setPoint3dArray("ptArGrip",_PtG);
mp.setPLine("plEl",plRec);
mp.setEntity("entTsl",_ThisInst);

double dY=ptText.Y(),dX=ptText.X();
mp.setDouble("dY",dY);
mp.setDouble("dX",dX);

_Map.setMap("mpStackChildPanel",mp);

Map mpBundleData = el.subMapX("ElementBundleData");
mpBundleData.setMapName("ElementBundleData");
//__Assign data to the element
if(_Map.hasMap("mpStackLocation"))
{
	
	Map mpS = _Map.getMap("mpStackLocation");
	String stPrefix = mpS.getString("stPrefix");
	int iStack = mpS.getInt("iStack");
	int iRow = mpS.getInt("iRow");
	int iPlace = mpS.getInt("iPlace");
	double dShiftR = mpS.getDouble("dDistFromLeft");
	int iSet = mpS.getInt("iSetNumber");
	int iTruck = mpS.getInt("iTruckNumber");
	int iFlip = strFlip == arYN[0];
	
	//Construct the specific map
	
	//if(!mpBundleData.hasString("BundleName"))
	mpBundleData.setString("BundleName",stPrefix+iStack);
	mpBundleData.setInt("BundleNumber",iStack);
	mpBundleData.setInt("BundleLevelNumber", iRow );
	mpBundleData.setInt("OrdinalPositionInBundleLevel", iPlace );
	mpBundleData.setInt("RotateInBundle", iFlip);
	mpBundleData.setInt("TruckNumber", iTruck);
	mpBundleData.setInt("SetNumber", iSet);
	
	
	double dShiftOut=U(0);
	if(iPlace == 1)dShiftOut = dShiftR + dAddLeft;
	else dShiftOut = dAddLeft;
	
	if(dShiftOut > U(0))mpBundleData.setDouble("ShiftPanelInLevel", dShiftOut );
	
	el.setSubMapX("ElementBundleData", mpBundleData);
	
}

//add the bundle data in the staking map for Produciton controller
mpStacking.setMap("Content", mpBundleData);

if (mpStacking.length() > 0)
{
	el.setSubMapX(stChildMetadataKey, mpStacking);
	el.setInformation(strStack);
}
#End
#BeginThumbnail
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
08U3BG=(?11106%%%%`'_V9FG
`








#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Wil now support stairs" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="1/18/2023 12:33:05 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Will always reset bundle data submapX" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="9/24/2021 11:07:56 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End