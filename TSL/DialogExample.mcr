#Version 8
#BeginDescription

V0.12 4/9/2024 Added new input for DynamicDialog cc
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 12
#KeyWords 
#BeginContents
//__this is simply to streamline working with my standard snippets
int bInDebug = true;
int bListSelector, bOptions, bText, bNotice, bMultiNotice, bAsk, bYesNo, bDynamic;
//bListSelector = true;
//bOptions = true;
//bText = true; 
//bNotice = true;
//bAsk = true;
//bYesNo = true;
//bMultiNotice = true;

bDynamic = true;

String ShowSelectAll = "ShowSelectAll";
String Title = "Title";
String Prompt = "Prompt";
String Alignment = "Alignment";
String Selection = "Selection";
String SelectedIndex = "SelectedIndex";
String SelectionsKey = "Selection[]";
String WasCancelled = "WasCancelled";
String ItemsKey = "Items[]";
String ControlTypeKey = "ControlType";
String ColumnDefinitionsKey = "mpColumnDefinitions";
String RowDefinitionsKey = "mpRowDefinitions";
String NameKey = "Name";
String ComboBoxType = "ComboBox";
String TextBoxType = "TextBox";
String CheckBoxType = "CheckBox";
String LabelType = "Label";
String IntegerBox = "IntegerBox";
String DoubleBox = "DoubleBox";
String Width = "Width";
String Height = "Height";
String MinWidth = "MinWidth";
String MinHeight = "MinHeight";
String MaxWidth = "MaxWidth";
String MaxHeight = "MaxHeight";
String DialogConfigMapKey = "mpDialogConfig";
String ErrorMessageKey = "ErrorMessage";
String PrefillTextKey = "PrefillText";
String PrefillIsSelected = "PrefillIsSelected";
String stShowDynamic = "ShowDynamicDialog";


if (_bOnInsert)
{
	//__this is the location and naming structure of the .dll
	String stDll = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String stClass = "TslUtilities.TslDialogService";
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";
	
	
	/// <summary>
	/// This displays a combobox with a search field above.
	/// The intention is to enable the user to make a selection from a long list.
	/// The available selections are filtered by matching text in the search field
	/// </summary>
	///        /// <param name="mpIn">
    ///     mpIn
    ///     |_Items[]  //__String entries, key is ignored
    ///     |   |_stItem: "This is an Item"
    ///     |   |_stItem: "Also an Item"
    ///     |   |_stItem: "Another solid Item"
    ///     |   |_"Item from int": 0
    ///     |   |_"Another int item": 0
    ///     |   |_"Selected item": 1
    ///     |   |_mpItem: #  //__map entries, key is ignored
    ///     |   |   |_Text: "This is an Item"
    ///     |   |   |_ToolTip: "This is a tooltip"
    ///     |   |   |_IsSelected: 0
    ///     |   |_...
    ///     |_Title: "Title Text of Dialog"
    ///     |_Prompt: "Prompt Text of Dialog"
    ///     |_Alignment: "Left"  //__optional, default is Left. Other options are Right and Center
    ///     |_SelectedIndex: #  //_initially selected index is optional
	/// <param name="mpOut">
	/// mpOut should have a single key "Selection" with the selected item as String
	/// </param>
	/// <returns>irrelevant</returns>
	
	Map mpItems;
	mpItems.setString("st", "This is an Item");
	mpItems.appendString("st", "Also an Item");
	mpItems.appendString("st", "Jimmy");
	mpItems.appendString("st", "Jimmy 4"); //__try using 4 in the search box.
	
	mpItems.appendInt("List Item from Int", 0);
	mpItems.appendInt("Selected List Item", 1);
	
	Map mpItem;
	mpItem.setString("Text", "Map Item");
	mpItem.setString("ToolTip", "Description of Map Item");//__only Map entries can declare ToolTips
	mpItem.setInt("IsSelected", 0);
	mpItems.appendMap("mp", mpItem);
	
	mpItem.setString("Text", "Another Item");
	mpItem.setString("ToolTip", "Description of Another");//__only Map entries can declare ToolTips
	mpItem.setInt("IsSelected", 0);
	mpItems.appendMap("mp", mpItem);
	
	
	mpItem.setString("Text", "Third Thingy");
	mpItem.setString("ToolTip", "Description 3!!");//__only Map entries can declare ToolTips
	mpItem.setInt("IsSelected", 0);
	mpItems.appendMap("mp", mpItem);
	
	Map mpListIn; 
	mpListIn.setMap("Items[]", mpItems);
	mpListIn.setString("Title", "**Custom Title**");
	mpListIn.setString("Prompt", "List Prompt");
	mpListIn.setInt("EnableMultipleSelection", 1);
	mpListIn.setInt("ShowSelectAll", 1);
	//__if this line is uncommented, it will override other entries and ensure the 3rd item is selected
	//mpListIn.setInt("SelectedIndex", 3);
	Map mpOut;
	if(bListSelector) mpOut = callDotNetFunction2(stDll, stClass, listSelectorMethod, mpListIn);
//	reportMessage("\nList Selection returned " + mpOut.getString("Selection"));
//	
//	reportMessage("\n");
//	reportMessage("\n**********");
//	reportMessage("\n");

	Map mpNoticeIn;
	mpNoticeIn.setString("Selection", mpOut.getString("Selection"));
	mpNoticeIn.setString("SelectedIndex", mpOut.getString("SelectedIndex"));
	mpNoticeIn.setString("Title", "**Custom Title**");
	if(bNotice) callDotNetFunction2(stDll, stClass, showMultilineNotice, mpNoticeIn);
	
//	if(bInDebug)
//	{ 
//		String stMapName = mpOut.getMapKey() == "" ? mpOut.getMapName() : mpOut.getMapKey();
//		if (stMapName == "") stMapName = scriptName() + ".mpDebug.dxx";
//		String stPath = _kPathDwg + "\\" + stMapName ;
//		mpOut.writeToDxxFile(stPath);
//		String stMapExplorerPath = _kPathHsbInstall + "\\Utilities\\hsbMapExplorer\\hsbMapExplorer.exe";
//		spawn_detach("", stMapExplorerPath, "\"" + stPath + "\"", "");				
//	}
	
	
	
	/// <summary>
	/// This displays a list of RadioButtons labeled with supplied text. Only one can be selected
	/// Optionally an index can be specified to define initial selection
	/// Returns the text and index from the selected option
	/// If nothing selected or dialog canceled empty String and selected index -1 are returned
	/// </summary>
	/// <param name="mpIn">
	/// mpIn
	///     |_Options[]  //__any key and type is legal in Options list
	///     |   |_stOption: "This is an Option"
	///     |   |_stOption: "Also an Option"
	///     |   |_stOption: "Another solid Option"
	///     |   |_...
	///     |
	///     |_SelectedIndex: #  //_initially selected index is optional
	/// </param>
	/// <param name="mpOut">
	/// mpOut
	///     |_Selection: //__the text of the selected option
	///     |_SelectedIndex: //__index in the input list of the selected option
	/// </param>


	
	Map mpOptionsOut;
	if(bOptions) mpOptionsOut = callDotNetFunction2(stDll, stClass, optionsMethod, mpListIn);
	if (bInDebug) reportMessage("\nmpOptionsOut.getInt(\"SelectedIndex\") = " + mpOptionsOut.getInt("SelectedIndex"));
	if (bInDebug) reportMessage("\nmpOptionsOut.getString(\"Selection\") = " + mpOptionsOut.getString("Selection"));
	
	reportMessage("\n");
	reportMessage("\n**********");
	reportMessage("\n");
	
	
	/// <summary>
	/// Presents the user with a dialog containing a simple text box
	/// </summary>
	/// <param name="mpIn">
	/// mpIn
	///     |_Title: "Title Text of Dialog"
	/// </param>
	/// <param name="mpOut">
	/// mpOut
	///     |_Text: "Whatever the user entered"
	/// </param>
	/// <returns>
	/// True if text was entered and OK pressed.
	/// False if text is blank or dialog was canceled.
	/// </returns>
	Map mpTextIn;
	mpTextIn.setString("Title", "**Custom Title**");
	Map mpTextOut;
	if(bText) 
	{
		mpTextOut = callDotNetFunction2(stDll, stClass, simpleTextMethod, mpTextIn);
		if(bInDebug) reportMessage("\nmpTextOut.getString(\"Text\") = " + mpTextOut.getString("Text"));
	}
	
	
	reportMessage("\n");
	reportMessage("\n**********");
	reportMessage("\n");
	
	/// <summary>
	/// Asks a binary (Yes/No) question. Options for providing custom prompts and tool tip prompts
	/// </summary>
	/// <param name="mpIn">
	/// mpIn uses keys shown below, all are Strings
	/// </param>
	/// <param name="mpOut">
	/// mpOut is not utilized. The returning boolean is the answer
	/// </param>
	/// <param name="question">Question to display to user</param>
	/// <param name="positivePrompt">Optional. Text for 'positive' reply button. Default is 'Yes'</param>
	/// <param name="negativePrompt">Optional. Text for 'negative' reply button. Default is 'No'</param>
	/// <param name="positiveToolTip">Optional. Text to show over positive button on hover</param>
	/// <param name="negativeToolTip">Optional. Text to show over negative button on hover</param>
	/// <returns>
	/// True if the user clicked the positive prompt
	/// False if the user clicked the negative prompt, or cancelled
	/// </returns>
	
	Map mpAskIn;
	mpAskIn.setString("question", "Do you like Jimmy?");
	mpAskIn.setString("Title", "**Custom Title**");
	Map mpAskOut;
	if(bAsk)
	{
		mpAskOut = callDotNetFunction2(stDll, stClass, askYesNoMethod, mpAskIn);
		if(bInDebug) reportMessage("\nmpAskOut.getInt(\"Answer\") = " + mpAskOut.getInt("Answer"));
	}
	
	
	reportMessage("\n");
	
	
	mpAskIn.setString("positivePrompt", "He's Awesome");
	mpAskIn.setString("negativePrompt", "Bad Jimmy");
	mpAskIn.setString("positiveToolTip", "Click here if you'd like to see Jimmy every day");
	mpAskIn.setString("negativeToolTip", "Click here if you'd rather poke sticks in your eye than talk to Jimmy");
	mpAskIn.setString("Title", "**Custom Title**");
	if(bYesNo)
	{ 
		mpAskOut = callDotNetFunction2(stDll, stClass, askYesNoMethod, mpAskIn);
		if(bInDebug) reportMessage("\nmpAskOut.getInt(\"Answer\") = " + mpAskOut.getInt("Answer"));
	}
	
	
	reportMessage("\n");
	reportMessage("\n**********");
	reportMessage("\n");
	
	/// <summary>
	/// Displays a simple message
	/// </summary>
	/// <param name="mpIn">
	/// 
	/// mpIn
	///     |_"notice": "You tried to divide by zero, bad user"
	///     |_"showCancel": 0 is false, any other int is true
	/// 
	/// </param>
	/// <param name="mpOut">
	/// Not utilized
	/// </param>
	/// 
	/// <param name="notice">Text to display in message box</param>
	/// <param name="showCancel">Show or hide Cancel button</param>
	/// <returns>Nothing is returned in mpOut</returns>
	//Map mpNoticeIn;
	mpNoticeIn.setString("Notice", "You are using a super awesome dialog service");
	mpNoticeIn.setString("Title", "**Custom Title**");
	
	if(bNotice)
	{ 
		Map mpNoticeOut = callDotNetFunction2(stDll, stClass, showNoticeMethod, mpNoticeIn);
		if(bInDebug) reportMessage("\nmpNoticeOut.length() = " + mpNoticeOut.length());
		
		reportMessage("\n");
	}
	
	
	/// <summary>
	/// Shows a notice dialog with multiple lines
	/// </summary>
	/// <param name="mpIn">
	/// All root level entries are converted to String and displayed. Keys are irrelevant.
	/// mpIn
	///     |_"key": "Some text here"
	///     |_"whatever": "More text here"
	/// </param>
	/// <param name="mpOut">
	/// mpOut is not utilized
	/// </param>
	/// <returns></returns>
	mpNoticeIn.setString("st", "Jimmy says Notice Me!");
	mpNoticeIn.setDouble("Jimmy", 4.2);
	mpNoticeIn.setVector3d("WorldX", _XW);
	
	if(bMultiNotice)
	{ 
		Map mpNoticeOut = callDotNetFunction2(stDll, stClass, showMultilineNotice, mpNoticeIn);
		if(bInDebug) reportMessage("\nmpNoticeOut.length() = " + mpNoticeOut.length());
	}
	
	if (bDynamic)
{
    Map mpDynamic ;
    Map mpDialogConfig ;
    mpDialogConfig.setString(Title, "Dynamic Dialog");
    mpDialogConfig.setDouble(Height, 400);
    mpDialogConfig.setDouble(Width, 700);
    mpDialogConfig.setDouble(MaxHeight, 800);
    mpDialogConfig.setDouble(MaxWidth, 1000);
        mpDialogConfig.setDouble(MinHeight, 120);
    mpDialogConfig.setDouble(MinWidth, 180);
    mpDialogConfig.setString("Description", "Please review and input");
    mpDynamic.setMap(DialogConfigMapKey, mpDialogConfig);

    Map mpColumnDefinitions ;
    Map mpColumn1 ;
    mpColumn1.setString(ControlTypeKey, LabelType);
    mpColumnDefinitions.setMap("Name", mpColumn1);

    Map mpColumn2 ;
    mpColumn2.setString(ControlTypeKey, TextBoxType);
    mpColumnDefinitions.setMap("Text", mpColumn2);

    Map mpColumn3 ;
    mpColumn3.setString(ControlTypeKey, CheckBoxType);
    mpColumnDefinitions.setMap("Check Box", mpColumn3);

    Map mpColumn4 ;
    mpColumn4.setString(ControlTypeKey, ComboBoxType);
    Map mpItems ;
    mpItems.setString("Item 1", "Item 1");
    mpItems.setString("Item 2", "Item 2");
    mpItems.setString("Item 3", "Item 3");
    mpColumn4.setMap(ItemsKey, mpItems);
    mpColumnDefinitions.setMap("Combo Box", mpColumn4);

    Map mpColumn5 ;
    mpColumn5.setString(ControlTypeKey, IntegerBox);
    mpColumnDefinitions.setMap("Count", mpColumn5);

    Map mpColumn6 ;
    mpColumn6.setString(ControlTypeKey, DoubleBox);
    mpColumnDefinitions.setMap("Double", mpColumn6);

    mpDynamic.setMap(ColumnDefinitionsKey, mpColumnDefinitions);

    Map mpRowDefinitions ;
    for (int i = 0; i < 5; i++)
    {
        Map mpRow ;
        mpRow.setString("Text", "Text Entry " + i);
        mpRow.setInt("Check Box", i % 2);
        mpRow.setString("Combo Box", "Item " + (i+1));
        mpRow.setInt("Count", i);
        mpRow.setDouble("Double", i*13.34);
        mpRowDefinitions.setMap("Row #" + (i+1), mpRow);
    }

    mpDynamic.setMap(RowDefinitionsKey, mpRowDefinitions);

    mpOut = callDotNetFunction2(stDll, stClass, stShowDynamic, mpDynamic);

    int iDB = mpOut.length();
}
	
	reportMessage("\n");
	reportMessage("\n");
	
	
	eraseInstance();
	return;
}
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
      <str nm="Comment" vl="Added new input for DynamicDialog" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="4/9/2024 8:11:16 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End