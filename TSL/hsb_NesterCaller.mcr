#Version 8
#BeginDescription

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 0
#KeyWords 
#BeginContents
Unit(1,"mm");
PropInt pAccept(0,0,T("Accept nester result"));

if (_bOnInsert) {
	PrEntity ssE(T("|Select a set of sheets to be nested|"), Sheet());
	if (ssE.go()) {
		_Sheet = ssE.sheetSet();
	}
	return;
}

NesterData nd;
nd.setAllowedRunTimeSeconds(U(360)); // seconds
nd.setMinimumSpacing(U(2));
nd.setGenerateDebugOutput(false);
nd.setNesterToUse(_kNTAutoNesterV4);

String strNestAction= T("|Nest in EntPLine|");
addRecalcTrigger(_kContext, strNestAction);
if (_bOnRecalc && _kExecuteKey==strNestAction) 
{
	EntPLine entPline = getEntPLine();
	if (entPline.bIsValid())
	{
		// construct a NesterCaller object adding masters and childs
		NesterCaller nester;
		for (int s=0; s<_Sheet.length(); s++)
		{
			Sheet sh = _Sheet[s];
			NesterChild nc(sh.handle(),sh.profShape());
			nc.setRotationAllowance(90);
			nester.addChild(nc);
		}
	
		NesterMaster nm(entPline.handle(), PlaneProfile(entPline.getPLine()));
		nester.addMaster(nm);
	
		// report NesterCaller object content
		reportMessage("\nMasterList" );
		for (int m=0; m<nester.masterCount(); m++)
		{
			NesterMaster master = nester.masterAt(m);
			reportMessage("\nMaster "+m+" "+nester.masterOriginatorIdAt(m) + " == " + master.originatorId() );
		}
		reportMessage("\nChildList" );
		for (int c=0; c<nester.childCount(); c++)
		{
			NesterChild child = nester.childAt(c);
			reportMessage("\nChild "+c+" "+nester.childOriginatorIdAt(c) + " == " + child .originatorId() );
		}
	
		// do the actual nesting
		int nSuccess = nester.nest(nd);
		reportMessage("\nNestResult: "+nSuccess);
		if (nSuccess!=_kNROk)
		{
			reportNotice(T("|Not possible to nest|"));
			if (nSuccess==_kNRNoDongle)
				reportNotice(T("|No dongle present|"));
			return;
		}
	
		// examine the nester result
		reportMessage("\nLeft over MasterList" );
		int arLeftOverMaster[] = nester.leftOverMasterIndexes();
		for (int m=0; m<arLeftOverMaster.length() ; m++) 
		{
			reportMessage("\nMaster "+m+" "+nester.masterOriginatorIdAt(m));
		}
	
		reportMessage("\nLeft over ChildList" );
		int arLeftOverChild[] = nester.leftOverChildIndexes();
		for (int c=0; c<arLeftOverChild.length(); c++)
		{
			reportMessage("\nChild "+c+" "+nester.childOriginatorIdAt(c));
		}
	
		// loop over the nester masters
		int arMaster[] = nester.nesterMasterIndexes();
		for (int m=0; m<arMaster.length(); m++)
		{
			int nIndexMaster = arMaster[m];
			reportMessage("\nResult "+nIndexMaster +" "+nester.masterOriginatorIdAt(nIndexMaster) );
			int arChild[] = nester.childListForMasterAt(nIndexMaster);
			CoordSys arWorldXformIntoMaster[] = nester.childWorldXformIntoMasterAt(nIndexMaster);
			if (arChild.length()!=arWorldXformIntoMaster.length())
			{
				reportNotice("Nesterresult invalid");
				break;
			}
			// show the childs within the master
			for (int c=0; c<arChild.length(); c++)
			{
				int nIndexChild = arChild[c];
				String strChild = nester.childOriginatorIdAt(nIndexChild);
				reportMessage("\n Child "+nIndexChild+" "+strChild );
				if (pAccept==1)
				{
					Entity ent; ent.setFromHandle(strChild);
					CoordSys cs = arWorldXformIntoMaster[c];
					ent.transformBy(cs);
				}
			}
		}
	}
}

#End
#BeginThumbnail

#End
