#Version 8
#BeginDescription
V0.10_Nov10 2011__Will erase after done working







































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 10
#KeyWords 
#BeginContents
Unit(1,"inch");

//Notes
//Need to redefine how the row if found.
int nStr=0,nDbl=0,nInt=0;

String arYN[]={"Yes","No"};

PropString stEmpty(nStr,"------------------------","GENERAL PROPERTIES");nStr++;
stEmpty.set("------------------------");
stEmpty.setReadOnly(TRUE);



if(_bOnInsert){
	if(insertCycleCount()>1)eraseInstance();
	
	int iStart = getInt("Start number");
	
	Group gr("X - STACKER","EXPORT","");
	
	Entity entsAll[] = gr.collectEntities(FALSE,TslInst(),_kModel);
	
	TslInst arTslList[0];
	
	PrEntity ssE("\nSelect stacks in desired sequence or press Enter",TslInst());
	if(ssE.go()){
		
		Entity ents[]=ssE.set();
		
		for(int e=0;e<ents.length();e++){
			TslInst tsl=(TslInst)ents[e];
			if(!tsl.bIsValid())continue;
			
			if(tsl.map().hasMap("mpStackMaster")){
				int iRemove=entsAll.find(tsl);
				if(iRemove > -1)entsAll.removeAt(iRemove);
				
				arTslList.append(tsl);
			}
		}
	}
	
	//add all others unselected			
	for(int e=0;e<entsAll.length();e++){
		TslInst tsl=(TslInst)entsAll[e];
		if(!tsl.bIsValid())continue;
			
		if(tsl.map().hasMap("mpStackMaster")){
		
			arTslList.append(tsl);
		}
	}			
				
	//Label the list
	for(int e=0;e<arTslList.length();e++){
		Map mp=arTslList[e].map();
		mp.setInt("mpStackMaster\\iStackNumber",iStart);
		mp.setInt("mpStackMaster\\iCount",(e+1));
		mp.setInt("mpStackMaster\\iStackQty",arTslList.length());
		arTslList[e].setMap(mp);
		
		//reportMessage("\nStack " + iStart + " - Count " + String(e+1) + " QTY " + arTslList.length());
		
		
		iStart++;
	}
	reportMessage("\nLabeled a total of " + arTslList.length()	+ " Stacks");
}
		



eraseInstance();














#End
#BeginThumbnail
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
08U3BG=(?11106%%%%`'_V9FG
`






#End
#BeginMapX

#End