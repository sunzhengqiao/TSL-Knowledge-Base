#Version 8
#BeginDescription
The tsl 'MultipageAnchor' anchors any entity (except tsls or other multipages) to a multipage.
The purpose is to keep the relative location also when the multipage is moved.
The instance can be linked to a shopDrawView in blockspace to define the automatic creation of the model instance on generate shopdrawing. 
Each multipage will then have a non plotable instance of the 'MultipageAnchor' to which the user can append entities by using doubleclick or RMC command.
Moving the instance will temporarly highlight the relations.

#Versions
Version 1.1 07.03.2023 HSB-18246 purges invalid multipage and its dependencies , Author Thorsten Huck
Version 1.0 10.02.2023 HSB-17915 initial version of multipage anchor



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
//region <History>
// #Versions
// 1.1 07.03.2023 HSB-18246 purges invalid multipage and its dependencies , Author Thorsten Huck
// 1.0 10.02.2023 HSB-17915 initial version of multipage anchor , Author Thorsten Huck

/// <insert Lang=en>
/// Select a multipage and entities to be anchored or select a shopdraw view in blockspace
/// </insert>

// <summary Lang=en>
// This tsl creates 
// The tsl 'MultipageAnchor' anchors any entity (except tsls or other multipages) to a multipage. 
// The purpose is to keep the relative location also when the multipage is moved.
// The instance can be linked to a shopDrawView in blockspace to define the automatic creation of the model instance on generate shopdrawing. 
// Each multipage will then have a non plotable instance of the 'MultipageAnchor' to which the user can append entities by using doubleclick or RMC command.
// Moving the instance will temporarly highlight the relations.
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "MultipageAnchor")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Entities|") (_TM "|Select multipage anchor|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Entities|") (_TM "|Select multipage anchor|"))) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String tDefault =T("|_Default|");
	String tLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeighht = getViewHeight();	
//endregion 	
	
//end Constants//endregion


//region Properties
	String sSizeName=T("|Size|");	
	PropDouble dSize(nDoubleIndex++, U(10), sSizeName);	
	dSize.setDescription(T("|Defines the Size of the symbolic anchor|"));
	dSize.setCategory(category);
	if (dSize < U(1))dSize.set(U(10));
	
			
//End Properties//endregion 

//region OnInsert
	Entity ents[0]; ents = _Entity;
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();
		
	// Determine types to be selected	
		int bBlockSpace, bSelectPage, bSelectSDV;
		Entity entsSDV[]= Group().collectEntities(true, ShopDrawView(), _kAllSpaces);
		if (entsSDV.length()>0)
		{ 
			bSelectSDV = true;
			Entity entsPages[]= Group().collectEntities(true, MultiPage(), _kAllSpaces);
			if (entsPages.length()>0)
				bSelectPage = true;
		}
		
		
	// prompt for entities
		PrEntity ssE;
		if (bSelectPage && bSelectSDV)
		{
			ssE= PrEntity(T("|Select Shopdraw View or multipage and entities to link|"), BlockRef());
			ssE.addAllowedClass(MultiPage());
			ssE.addAllowedClass(ShopDrawView());
		}
		else if (bSelectSDV)
			ssE= PrEntity(T("|Select Shopdraw View|"), ShopDrawView());	
		else
		{
			ssE= PrEntity(T("|Select multiapge and entities to link|"), BlockRef());
		}
		if (ssE.go())
			ents.append(ssE.set());
	}			
		
	ShopDrawView sdv;	
	MultiPage page;
	Entity entLinks[0];
	for (int i=0;i<ents.length();i++) 
	{ 
		Entity e = ents[i];
		setDependencyOnEntity(e);
		MultiPage p= (MultiPage)e;
		ShopDrawView s= (ShopDrawView)e;
		
		if(p.bIsValid() && !page.bIsValid()) 	
			page = p;
		else if(s.bIsValid() && !sdv.bIsValid()) 	
			sdv = s;			
		else if (!p.bIsValid() && !s.bIsValid())
			entLinks.append(e);
	}//next i		
		
	if(_bOnInsert && (page.bIsValid() || sdv.bIsValid()))
	{	
		if (page.bIsValid())_Entity.append(page);
		else if (sdv.bIsValid())_Entity.append(sdv);
		_Entity.append(entLinks);
		_Pt0 = getPoint();
		return;
	}			
//endregion 

//region Defaults
	Display dp(-1);
	dp.trueColor(lightblue, 60);
	
	if (_bOnDbCreated)setExecutionLoops(2);
	
	int bCreatedByBlockspace = _Map.getInt("createdByBlockSpace");
	if (ents.length()<1 && bCreatedByBlockspace) 
	{ 
		if (bDebug)reportNotice("\nbCreatedByBlockspace no entity yet");
		return;
	}
	else if (ents.length()>0 && _Map.hasInt("createdByBlockSpace")) 
	{
		if (bDebug)reportNotice("\nbCreatedByBlockspace entity found");
		_Map.removeAt("createdByBlockSpace", true);
	}	

	addRecalcTrigger(_kGripPointDrag, "_Pt0");
	int bIsBlockSpace = sdv.bIsValid();
	int bOnDrag = _bOnGripPointDrag && _kExecuteKey == "_Pt0";
	
	Point3d ptOrg;
	Vector3d vecOrg;
	int bOnPageMoved;

//endregion 



//region Blockspace
	if (bIsBlockSpace)
	{ 

	//region On Generate ShopDrawing
		if (_bOnGenerateShopDrawing)
		{
		// Get multipage from _Map
			Entity entCollector = _Map.getEntity(_kOnGenerateShopDrawing +"\\entCollector");
			Map mapTslCreatedFlags = entCollector.subMapX("mpTslCreatedFlags");
			String uid = _Map.getString("UID"); // get the UID from map as instance does not exist onGenerateShopDrawing
			int bIsCreated = mapTslCreatedFlags.hasInt(uid);

			//reportNotice("\nOnGenerateShopDrawing:\nUID: " + uid + "\ncreated by blockspace: " + bIsCreated + "\npage " + entCollector.bIsValid());

			if (!bIsCreated && entCollector.bIsValid())
			{ 
			// create TSL
				TslInst tslNew;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {entCollector};			Point3d ptsTsl[] = {_Pt0};
				int nProps[]={};			
				double dProps[]={dSize};				
				String sProps[]={};
				Map mapTsl;	
				mapTsl.setInt("createdByBlockSpace", true);
				mapTsl.setVector3d("vecOrg", _Pt0-_PtW);
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
				//reportNotice("\ncreated..");
				if (tslNew.bIsValid())
				{
					tslNew.transformBy(Vector3d(0, 0, 0));
				
				// flag entCollector such that on regenaration no additional instances will be created	
					if (!bIsCreated)
					{
						bIsCreated=true;
						mapTslCreatedFlags.setInt(uid, true);
						entCollector.setSubMapX("mpTslCreatedFlags",mapTslCreatedFlags);
					}
				}
			}	
			return;
		}
	//endregion		
		
	//region Draw Setup of Blockspace
		else
		{ 
			setDependencyOnEntity(sdv);
			_Map.setString("UID", _ThisInst.uniqueId()); // store UID to have access during _kOnGenerateShopDrawing
			addRecalcTrigger(_kGripPointDrag, "_Pt0");	
		}//endregion 			

		
	}
//endregion 

//region Model Mode
	else
	{ 
	
	//region Validate Model Mode
		if (!page.bIsValid())
		{ 
			if(bDebug)reportNotice("\nModel mode, no page");
			eraseInstance();
			return;
		}
	// validate show set / multipage	// HSB-18246 purge invalid	
		else
		{ 
			Entity showSet[] = page.showSet();
			
			for (int i=showSet.length()-1; i>=0 ; i--) 
				if (showSet[i].typeDxfName().length()<1)
					showSet.removeAt(i); 

			if (showSet.length()<1)
			{ 
				if(bDebug)reportNotice("\n" + page.handle() + T("|does not contain any showset entity.|"));
				page.dbErase();
				eraseInstance();
				return;
			}
		}
	
		
		
		
		assignToGroups(page, 'T');
		
		
		ptOrg = page.coordSys().ptOrg();
		vecOrg = _Map.getVector3d("vecOrg");
		
		if (_kNameLastChangedProp=="_Pt0" || _bOnDbCreated)	// _Pt0 moved or instance created, update vecOrg
		{ 
			vecOrg = _Pt0 - ptOrg;
			_Map.setVector3d("vecOrg", vecOrg);
		}
		else if (_Map.hasVector3d("vecOrg")) // set relation to ptOrg
		{
			Point3d pt1 = ptOrg + vecOrg;
			if (Vector3d(_Pt0-pt1).length()>dEps)
			{ 
				_Pt0 = ptOrg+ vecOrg;
				bOnPageMoved = true;
			}
		}
		else	// store relation
			_Map.setVector3d("vecOrg", vecOrg);
		
	//endregion 
		
	//region Set transformation or transform linked entities
		for (int i=0;i<entLinks.length();i++) 
		{ 
			BlockRef bref= (BlockRef)entLinks[i]; 
			PLine pl = entLinks[i].getPLine();
			PlaneProfile pp(CoordSys());
			Point3d pts[] = entLinks[i].gripPoints();
			
			if (bref.bIsValid())
			{
				Block block(bref.definition());
				pl.createRectangle(block.getExtents(), _XW, _YW);
				pl.transformBy(bref.coordSys());
				pp.joinRing(pl, _kAdd)	;
			}
			else if (pl.length() > dEps)
			{ 
				pl.close();
				pp.joinRing(pl, _kAdd);		
			}
			else if (pts.length()>0)
			{ 		
				pl.createCircle(pts.first(), _ZW, U(10));
				
			}
			
			pp.joinRing(pl, _kAdd);
			if (pp.area()>pow(dEps,2))
			{ 
				Point3d pt = pp.ptMid();
				String han = entLinks[i].handle();
				Vector3d vec = _Map.getVector3d(han);
				if (bOnPageMoved && !vec.bIsZeroLength())
				{
					entLinks[i].transformBy(( _Pt0 + vec)-pt);
				}
				else
				{
					vec = pt - _Pt0;
					_Map.setVector3d(han, vec);	
				}
			}
			
			
		// Visualize Links	
			if (bOnDrag)
			{ 
				
				dp.draw(pp, _kDrawFilled); 
				dp.draw(PLine(pp.ptMid(),_Pt0)); 			
			}
	
			
		}//next i
		if (bOnDrag)
		{ 
			dp.trueColor(red,0);
			dp.draw(PLine(page.coordSys().ptOrg(),_Pt0)); 
		}
	//endregion 	
		
	}
//endregion 

//region Draw Lock
	{ 
		dp.transparency(60);
		PLine rec;
		double dX = dSize;
		Vector3d vec = .5 * (_XW * dX + _YW * dX);
		rec.createRectangle(LineSeg(_Pt0 - vec, _Pt0 + vec), _XW, _YW);
		rec.offset(.1*dX, false);
		rec.offset(-.1*dX, true);
		dp.draw(rec);
		
		double r = .4 * dX;
		PLine pl(_ZW);
		pl.addVertex(_Pt0 + _XW*r);
		pl.addVertex(_Pt0 + _XW*r+.75*_YW * dX);
		pl.addVertex(_Pt0 -_XW*r+.75*_YW * dX, _Pt0+_YW *(.75*dX+r));
		pl.addVertex(_Pt0 - _XW*r);
		pl.close();
		pl.convertToLineApprox(dEps);
		PlaneProfile pp2(pl);
		PlaneProfile pp3=pp2;
		pp3.shrink(.1*dX);
		pp2.subtractProfile(pp3);
		pp2.joinRing(rec, _kSubtract);
		dp.trueColor(grey);
		dp.draw(pp2,_kDrawFilled);
		dp.draw(pp2);
		dp.trueColor(darkyellow);
		dp.draw(PlaneProfile(rec),_kDrawFilled);
		dp.draw(PlaneProfile(rec));
		
		dp.color(white);
		dp.transparency(0);
		dp.textHeight(.5 * dX);
		dp.draw(entLinks.length(), _Pt0, _XW, _YW, 0, 0);
	}
	if (bIsBlockSpace)
	{ 
		if (bOnDrag)
		{ 
			dp.trueColor(red,0);
			dp.draw(PLine(sdv.coordSys().ptOrg(),_Pt0)); 
		}		
		return;
	}
//endregion 	
	
//region Trigger AddEntities
	String sTriggerAddEntities = T("|Add Entities|");
	addRecalcTrigger(_kContextRoot, sTriggerAddEntities );
	if (_bOnRecalc && (_kExecuteKey==sTriggerAddEntities || _kExecuteKey==sDoubleClick))
	{
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select entities|"), Entity());
		if (ssE.go())
			ents.append(ssE.set());
	
	
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			
		// remove invalid	
			TslInst t = (TslInst)ents[i]; 
			MultiPage p = (MultiPage)ents[i];
			GenBeam g = (GenBeam)ents[i];
			Element e = (Element)ents[i];			
			if (t.bIsValid() || p.bIsValid() || g.bIsValid() || e.bIsValid() )
			{ 
				continue;
			}
			
			if (_Entity.find(ents[i])<0)
				_Entity.append(ents[i]);
		}//next i

		setExecutionLoops(2);
		return;
	}//endregion	
	
//region Trigger RemoveEntities
	String sTriggerRemoveEntities = T("|Remove Entities|");
	addRecalcTrigger(_kContextRoot, sTriggerRemoveEntities );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveEntities)
	{
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select entities|"), Entity());
		if (ssE.go())
			ents.append(ssE.set());
			
		for (int i=0;i<ents.length();i++) 
		{ 
			if (ents[i]==page)
			{ 
				continue;
			}
			int n =_Entity.find(ents[i]);
			if (n>-1)
				_Entity.removeAt(n);
			 
		}//next i
	
		setExecutionLoops(2);
		return;
	}//endregion	

	
	

	
	



#End
#BeginThumbnail


#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="Resource[]">
    <lst nm="IMAGE[]">
      <lst nm="LOCKBLACK">
        <str nm="DESCRIPTION" vl="" />
        <str nm="ENCODING" vl="M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&amp;!@&lt;&amp;!0@'!P&lt;)&quot;0@*#!0-#`L+&#xD;&#xA;M#!D2$P\4'1H?'AT:'!P@)&quot;XG(&quot;(L(QP&lt;*#&lt;I+#`Q-#0T'R&lt;Y/3@R/&quot;XS-#+_&#xD;&#xA;MVP!#`0D)&quot;0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R&#xD;&#xA;M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1&quot;`#4`((#`2(``A$!`Q$!_\0`&#xD;&#xA;M'P```04!`0$!`0$```````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1```@$#`P($`P4%&#xD;&#xA;M!`0```%]`0(#``01!1(A,4$&amp;$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*&#xD;&#xA;M%A&lt;8&amp;1HE)B&lt;H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&amp;EJ&lt;W1U&#xD;&#xA;M=G=X&gt;7J#A(6&amp;AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&amp;&#xD;&#xA;MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ&gt;KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!&#xD;&#xA;M`0$!`0````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1$``@$&quot;!`0#!`&lt;%!`0``0)W``$&quot;&#xD;&#xA;M`Q$$!2$Q!A)!40=A&lt;1,B,H$(%$*1H;'!&quot;2,S4O`58G+1&quot;A8D-.$E\1&lt;8&amp;1HF&#xD;&#xA;M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&amp;5F9VAI:G-T=79W&gt;'EZ@H.$&#xD;&#xA;MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q&lt;;'R,G*TM/4&#xD;&#xA;MU=;7V-G:XN/DY&gt;;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#R:BBBM3,*&#xD;&#xA;M**VO#7A?4O%6IK9:?$3CF20CY4'J30!DV]O-=3+#;Q/+(W14&amp;2:],\.?!;6-&#xD;&#xA;M119]6E73X#SLR&quot;Y'Z@5WMKIWA3X5:&gt;'D(N-39&gt;'*CS'/MZ&quot;N!\0?$;7=;D98&#xD;&#xA;MYVL[?/&quot;0M@X]R*AOL78[./P=\./&quot;\2B_EBNI.?FF&lt;N?R6I_^$_\``^G((K.P&#xD;&#xA;MCD1&gt;`%A_Q%&gt;+X:23&lt;&lt;LY[GJ:MQZ;&lt;.,E0H]^*D9ZW%\3?&quot;4S;9=+$8]6A4_R&#xD;&#xA;M%*5^&amp;?B9R&amp;@M4N).-Q#(1_(5Y6NDC^*7]*4Z0AZR'\J`.VUCX(6MRDEQX&gt;U5&#xD;&#xA;M2#R(Y&amp;#+]`17E.M^&amp;]6\.W)@U.RDA(/#8RI^A'%=GI5_K6A2J^FZ@X53GRV/&#xD;&#xA;MR'\*]%TKQEIGBFT&amp;D^)K*%))/E!8`HQ]B&gt;AIJ3%8^&lt;J*])^(/PMN/#9DU+2@&#xD;&#xA;M\^E]64\M`/?U'O7FU:)W)L%%%%`@HHHH`****`-+0=$N_$.L6^FV:YDE;!;'&#xD;&#xA;M&quot;#N3]*][O+S2/A5X8CT^Q19=0E7KW9N['VK.^&amp;VC6O@[P5-XFU%0+BXC\Q&lt;]&#xD;&#xA;M0F/E`]&quot;&gt;:\TUW6KG7]7GU&amp;Z;+R'Y0.BKV'Y5FW&lt;M(@U#4;O5+V2[O9FEFD.2&#xD;&#xA;MS4MK827'S'Y4]:?867G-YDG$8Z&gt;]=OX:\*7?B&quot;&lt;&quot;-?*M$X&gt;8CI[#U-(9SMO:&#xD;&#xA;M1Q86&amp;,ECZ#)-:]MX=U&gt;[4-#83$&gt;XQ_.NYO\`5/!OP^A\J&lt;K-&gt;X^X%#R9]&gt;&gt;@&#xD;&#xA;MKB]1^/%\^Z/3]*BA4'Y9'DR&lt;?3%.S&quot;XZ3PGKD0RU@^/8BLN&gt;UN+5ML\$D1_V&#xD;&#xA;ME(J:S^.&gt;OPR[KFTMKA/[OW/U`KKM'^*WAGQ*HM-&lt;M([29^`9`&amp;0?\&quot;/2BS%=&#xD;&#xA;M'&quot;T=&quot;#W'2N]\1&gt;`T2U_M'0W\Z`C&lt;8\YP/4'O7!D%201@C@BD,]!\&amp;&gt;+A(%T;&#xD;&#xA;M5R)(7&amp;R-WY_X&quot;:\]^*/@$^'+[^U-/3.F7#=%Y\IO3Z4`D$$'!'0^E&gt;I&gt;'+RW&#xD;&#xA;M\8^%[G1-1422+'M.&gt;X['^5&quot;=@:/F:BM/Q!HL_A_7+K3+CEX'*AL?&gt;'8UF5J9&#xD;&#xA;MA1110`5L^$]'.N^*=/TW.%FE`8XZ`&lt;_TK&amp;KU'X&amp;Z&lt;MSXMN;J2/(M[8[&amp;]&amp;+#&#xD;&#xA;M^E)[#6YT_P`7]72&quot;*R\/VP\M%'F2*.F/X?Y&amp;O+;6`SSJ@Z=ZW_']VUYXYU-F&#xD;&#xA;M8GR9#`,]@&quot;?\:I:7#M@\PCENE9EG2&gt;&amp;M!?6M3BLHAMB7ESZ+74?$/QK!X*TN&#xD;&#xA;M/0]%&quot;+&gt;NF&quot;1_RS'K]?\`&amp;M+P5#%HGA.]UN4?.$9B#Z*,U\\:UJ&lt;VLZS=:A&lt;.&#xD;&#xA;M7&gt;9RV2&gt;@[#\J:5Q-E6XN9KN=Y[B5I)7.69CDFHJ**T)&quot;BBB@1Z)\.?B1&lt;^&amp;[&#xD;&#xA;MR/3]1D:;293MPW)A)[CV]:[[QWX=@CBCUW30#;38,@7H,]&amp;KY]KW[X4:L/$?&#xD;&#xA;M@B\T2^&lt;2-:@HJD_,R'D'\#Q42129Q%;/A?5&amp;TG7;&gt;&lt;$A&quot;VUQZ@UDS0/:SRV\&#xD;&#xA;MGWXF*'ZBFJQ5@PZ@YJ2C&gt;^.&gt;A*L]EKD*@^8/*D(]NG\S7C-?1?C*)=:^#WF9&#xD;&#xA;M!DBA60GK@J,D5\Z5&lt;=B9!1115$A7LWP()5M78=0HKQFO9O@3]W6/]P?RI2V*&#xD;&#xA;MB&lt;7KTC7'B74I&amp;Y=[EB?K6G&quot;@2.-1T`%9&gt;IC/B.\'_3R?YUK+QM%9E'HGBIOL&#xD;&#xA;M7P7S#\I&gt;!&lt;X]^M?.E?17C7_DBT?_`%QCKYUJXDR&quot;BBBJ)&quot;BBB@`KU?X#2,/%&#xD;&#xA;M.HQ9^0V9;'N'7_&amp;O**]5^`W_`&quot;-]_P#]&gt;)_]#6E+8:W+7BQ/+\6ZFH[SEOS-&#xD;&#xA;M8];?C'_D;]0_W_ZFL2LRST^PC67X3:BKC(%O-_Z#7S41AB*^E]+_`.23ZC_U&#xD;&#xA;M[S?^@U\T-]X_6JB)B44459`5[-\&quot;?NZQ_N#^5&gt;,U[-\&quot;?NZQ_N#^5*6Q43BM&#xD;&#xA;M2_Y&amp;2[_Z^3_.M9&gt;HK)U+_D9+O_KY/\ZUEZBLRCT/QK_R15/^N,=?.M?17C7_&#xD;&#xA;M`)(JG_7&amp;.OG6KB3(****HD****`&quot;O5?@-_R-]_\`]&gt;)_]#6O*J]5^`W_`&quot;-]&#xD;&#xA;M_P#]&gt;)_]#6E+8:W+OC'_`)&amp;_4/\`?_J:Q*V_&amp;/\`R-^H?[_]36)699ZCI?\`&#xD;&#xA;MR2?4?^O&gt;;_T&amp;OFAOOGZU]+Z7_P`DGU'_`*]YO_0:^:&amp;^^?K51W%(2BBBK(&quot;O&#xD;&#xA;M9O@3]W6/]P?RKQFO9O@3]W6/]P?RI2V*B&lt;5J7_(R7?\`U\G^=:R]163J6?\`&#xD;&#xA;MA)+O_KY/\ZUEZBLRCT/QK_R15/\`KC'7SK7T5XU_Y(JG_7&amp;.OG6KB3(****H&#xD;&#xA;MD****`&quot;O5?@-_P`C??\`_7B?_0UKRJO5?@-_R-]__P!&gt;)_\`0UI2V&amp;MR[XQ_&#xD;&#xA;MY&amp;_4/]_^IK$K;\8_\C?J'^__`%-8E9EGJ.E_\DGU'_KWF_\`0:^:&amp;^^?K7TO&#xD;&#xA;MI?\`R2?4?^O&gt;;_T&amp;OFAOO'ZU41,2BBBK(-GPYX9O_$U]]GLUVHO,DK?=05ZU&#xD;&#xA;MHWPZBT&gt;`B'7-5@E&lt;?O#:7)A5OP%:?@72HM*\)V:*BB29?-D(ZDFMBZF(/EJ?&#xD;&#xA;MK7R68YO4C)\CLE^)Z-##)K7&lt;XR?X&gt;:,96?[7J3R$Y+FYR2?7.*;_`,(%8?\`&#xD;&#xA;M/_J?_@2?\*ZNBOG)YQC9._M&amp;OF=RPU)=#G)_&quot;&quot;7-G]CGUO6I;7&amp;/(&gt;]9DQ_N&#xD;&#xA;MGBLW_A6.A_\`/2[_`._@_P`*[6BH_M;&amp;_P#/U_&gt;/ZM2_E.*_X5CH?_/2[_[^&#xD;&#xA;M#_&quot;C_A6.A_\`/2[_`._@_P`*[6BG_:V-_P&quot;?K^\/JU+^4XK_`(5CH?\`STN_&#xD;&#xA;M^_@_PH_X5CH?_/2[_P&quot;_@_PKM:*/[6QO_/U_&gt;'U:E_*&lt;5_PK'0_^&gt;EW_`-_!&#xD;&#xA;M_A5NP\!V6ES--I^I:K9RLNTO;W1C)'ID#I7544?VMC?^?K^\/JU+^4Y&gt;;P1:&#xD;&#xA;MW$S33ZIJTLK?&gt;=[LEC]2:9_P@5A_S_ZG_P&quot;!/_UJZNBE_:V-_P&quot;?K^\/J]+^&#xD;&#xA;M4YT&gt;$MEHUK'KVN);L&quot;&amp;B6^;80&gt;N5Z5P'B3X?W&gt;D0O=V4ANK9&gt;6&amp;/G4?UKV&amp;F&#xD;&#xA;MLH=&quot;C`%2,$&amp;NG#9YC*,U)S&lt;EV9$\)2DK)6/FVBO0[WP)&quot;;^Y,&gt;%C,K%1@&lt;#)&#xD;&#xA;MQ17V4&lt;[PS5]3S?J=0]4T`X\.6!]+=::QRQ/O3M&quot;_Y%NQ_P&quot;O=?Y4T]:^*S1^&#xD;&#xA;M\EZGIX?X1****\DZ0HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@#%N/^/F7_?/\&#xD;&#xA;MZ*+C_CYE_P!\_P`Z*[UL8&amp;[H7_(MV/\`U[K_`&quot;IIZT[0O^1;L?\`KW7^5-/6&#xD;&#xA;MM\T^-?,G#_&quot;)1117DG2%%%%`!1110`4444`%%%%`!1110`4444`8MQ_Q\R_[&#xD;&#xA;MY_G11&lt;?\?,O^^?YT5WK8P-W0O^1;L?\`KW7^5-/6G:%_R+=C_P!&gt;Z_RIIZUO&#xD;&#xA;MFGQKYDX?X1****\DZ0HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@#%N/^/F7_?/&#xD;&#xA;M\Z*+C_CYE_WS_.BN];&amp;!NZ%_R+=C_P!&gt;Z_RIIZT[0O\`D6['_KW7^5-/6M\T&#xD;&#xA;M^-?,G#_&quot;)1117DG2%%%%`!1110`4444`%%%%`!1110`4444`8MQ_Q\R_[Y_G&#xD;&#xA;M11&lt;?\?,O^^?YT5WK8P-W0O\`D6['_KW7^5-/6G:%_P`BW8_]&gt;Z_RIIZUOFGQ&#xD;&#xA;MKYDX?X1****\DZ0HHHH`****`&quot;BBB@`HHHH`****`&quot;BBB@#%N/\`CYE_WS_.&#xD;&#xA;MBBX_X^9?]\_SHKO6Q@;N@_\`(MV'_7NO\J:&gt;M8?P\UV'5?&quot;\-MY@-S:KY;J3&#xD;&#xA;MS@=#6X&gt;M=.;P&lt;*O++S(PS3A=&quot;4445XYU!1110`4444`%%%%`!1110`4444`%&#xD;&#xA;M%%17%Q':6TEQ,X2.-2S$G`%-)MV0F[&amp;5&lt;?\`'S+_`+Y_G17F=YX]N&amp;OKAHD/&#xD;&#xA;MEF1BG7IGBBOJ(Y#C'%/E.'ZS3[G-Z=JM[H\_VVQG:&amp;:,XXZ,/&lt;=Z]&gt;T#Q+?:&#xD;&#xA;MCIT&lt;]PL)D9020I';ZT45Z/$D(\D)6U.;!-W:-3^UI_\`GG%^1_QH_M:?_GG%&#xD;&#xA;M^1_QHHKX_E78]#F?&lt;/[6G_YYQ?D?\:/[6G_YYQ?D?\:**.5=@YGW#^UI_P#G&#xD;&#xA;MG%^1_P`:/[6G_P&quot;&gt;&lt;7Y'_&amp;BBCE78.9]P_M:?_GG%^1_QH_M:?_GG%^1_QHHH&#xD;&#xA;MY5V#F?&lt;/[6G_`.&gt;&lt;7Y'_`!H_M:?_`)YQ?D?\:**.5=@YGW#^UI_^&gt;&lt;7Y'_&amp;C&#xD;&#xA;M^UI_^&gt;&lt;7Y'_&amp;BBCE78.9]QKZS&lt;+&amp;2(XLX]#_`(UY9XJ\2ZIJE_/8SW&amp;VVA;B&#xD;&#xA;?.,;0?KZT45[V04X2Q-VEH&lt;N*D_9[G,4445]V&gt;4?_V0``&#xD;&#xA;" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18246 purges invalid multipage and its dependencies" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="3/7/2023 12:27:22 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17915 initial version of multipage anchor" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="2/10/2023 12:10:37 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End