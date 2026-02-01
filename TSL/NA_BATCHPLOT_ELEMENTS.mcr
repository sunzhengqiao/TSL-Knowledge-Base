#Version 8
#BeginDescription
#Versions
V1.3 8/15/2024 Added translation, drop down for layout tabs and filter for walls with openings. RL
V1.2 8/15/2024 Corrected the copying of files. File paths need to use a forward slash. RL

V1.1 12/22/2021 Will now support any element type
V1.0 9/30/2021 TSL to plot element PDFs with specified file name format from specified layout tab


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
Unit(1, "inch");

String arYN[] ={ T("|Yes|"), T("|No|")};
String arLayouts[] = Layout().getAllEntryNames();
PropString psNameFormat(0, "@(ElementNumber)", T("|PDF Name Format|"));

PropString psLayoutName(1, arLayouts, T("|Layout Tab Name|"));

PropString psFilterForOpenings(2, arYN, T("|Take only walls with openings|"), 1);

if (_bOnInsert)
{
	if (insertCycleCount()>1)
	{
		eraseInstance();
		return;
	}
	showDialog();
	PrEntity ssE("\n Select walls to print:", Element());
	ssE.addAllowedClass(TslInst());
	ssE.allowNested(true);
	if (ssE.go()) 
	{
		Entity ents[] = ssE.set();
		for (int i; i<ents.length(); ++i)
		{
			if (ents[i].bIsKindOf(Element())) 
			{
				Element elS = (Element)ents[i];
				if (elS.bIsValid()) 
				{
					Opening arOp[] = elS.opening();
					if(psFilterForOpenings == arYN[0] && arOp.length() > 0)	_Element.append(elS);
					else if (psFilterForOpenings == arYN[1]) _Element.append(elS);
				}
			}
			else 
			{
				TslInst tsl = (TslInst)ents[i];
				if (!tsl.bIsValid()) continue;	
				Map mpTsl = tsl.map();
				if (mpTsl.hasMap("mpStackChildPanel"))
				{			
					Map mpReg = mpTsl.getMap("mpStackChildPanel");
					Entity entEl = mpReg.getEntity("entEl");
					Element elS = (Element)entEl;
					if (elS.bIsValid()) _Element.append(elS);
				}
			}
		}
	}
}

	String arLoc[] = _kPathPersonalTemp.tokenize("\\");
	String stLoc = arLoc[0];
	for (int i = 1; i < arLoc.length(); ++i) stLoc += "\\\\" + arLoc[i];
	String stSwitchToWallshop = "( vlax-for lay (vla-get-Layouts (vla-get-activedocument (vlax-get-acad-object))) (if ( = (wcmatch (vla-get-name lay) \"*"+psLayoutName+"*\") T) (setvar \"ctab\" (vla-get-name lay)) ))";
	pushCommandOnCommandStack(stSwitchToWallshop);
	String arFiles[0], arErrors[0];	
	pushCommandOnCommandStack("(princ \" PDF name format: "+psNameFormat+"\\n\")");
	for (int i; i<_Element.length(); ++i)
	{
		Element el = _Element[i];
		if (!el.bIsValid()) continue; 
		String elNumber = el.number();		
		pushCommandOnCommandStack("(princ \"Batch Plot "+elNumber+"\\n\")");
		String elCommandNumber = el.number();
		Entity entXref = el.blockRef();
		BlockRef bkXref = (BlockRef) entXref;
		String stXrefDefinition = bkXref.definition();
		if (stXrefDefinition != "" && bkXref.bIsValid()) elCommandNumber = stXrefDefinition + "|" + elCommandNumber;	
		String stPDFname = el.formatObject(psNameFormat);
		pushCommandOnCommandStack("(Hsb_Lisp_setViewport \""+elCommandNumber+"\")");
		pushCommandOnCommandStack("(Command \"_regenall\")");		
		pushCommandOnCommandStack("(Hsb_PlotLayoutNt 1 \""+stLoc+"\" \""+stPDFname+"\" \"DWG To PDF.pc3\" 0 \"ANSI_B_(11.00_x_17.00_Inches)\" 0 0 0 1)");
		arFiles.append(stPDFname+".pdf");
	}
	pushCommandOnCommandStack("(princ \"Printing completed\")");	
	for (int i; i<arFiles.length(); ++i)
	{
		String createdFile = _kPathPersonalTemp;
		createdFile.replace("\\", "/");
		String destinationFile = _kPathDwg;
		destinationFile.replace("\\", "/");
		pushCommandOnCommandStack("(vl-file-copy \""+createdFile +"/"+arFiles[i]+"\" \""+ destinationFile +"/"+arFiles[i]+"\" T)");		
	}
	pushCommandOnCommandStack("(princ \"Copying PDF files completed\\n\")");	
	if (arErrors.length()>0)
	{
		for (int i; i<arErrors.length(); ++i)
		{
			pushCommandOnCommandStack(arErrors[i]);
		}
	}
	eraseInstance();
	return;

#End
#BeginThumbnail











#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Added translation, drop down for layout tabs and filter for walls with openings." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="8/15/2024 12:11:41 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Corrected the copying of files. File paths need to use a forward slash." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="8/15/2024 11:45:41 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End