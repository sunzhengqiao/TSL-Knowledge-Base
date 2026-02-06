# hsb_GeneralPanelNester.mcr

## Overview
This script automatically nests smaller child panels or closed polylines onto standard-size stock master panels. It optimizes material usage for timber construction by arranging parts efficiently within defined sheet dimensions based on selected styles and sizes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script interacts with 3D geometry and coordinates in the model. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | This is a production/modeling tool, not a drawing generator. |

## Prerequisites
- **Required Entities**: Existing `ChildPanel` entities OR closed `Polylines` (representing parts).
- **Settings**: `SipStyle` and `MasterPanelStyle` entries must exist in your catalog.
- **Property Sets**: If using Polylines, a Property Set definition named `PanelInfo` is required to store data.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_GeneralPanelNester.mcr`

### Step 2: Configure Properties
Before inserting, select the script instance in the drawing to open the **Properties Palette**.
- Set **Objects To Nest** to "Child Panels" or "Polylines".
- Select the desired **Sip style** (if using Polylines) and **MasterPanel style**.
- Enable the stock sheet sizes you wish to use (e.g., set "Use 1220x6000" to "Yes").

### Step 3: Set Insertion Point
```
Command Line: Set point to place master panels
Action: Click in the Model Space to define where the top-left of the stock sheets (Master Panels) will be generated.
```

### Step 4: Select Objects to Nest
*If "Objects To Nest" is set to Child Panels:*
```
Command Line: Select child panels
Action: Select the panel entities you want to arrange on the sheets. Press Enter to confirm.
```

*If "Objects To Nest" is set to Polylines:*
```
Command Line: Select close polylines
Action: Select the closed polylines representing the parts to be nested. Press Enter to confirm.
```

### Step 5: Select Labels (Polylines Only)
```
Command Line: Select labels
Action: Select any Text or MText entities associated with the polylines. These are used to populate the 'PanelInfo' property data. Press Enter if no labels are needed.
```

### Step 6: Processing
The script will now calculate the optimal nesting layout.
- Wait for the calculation to complete (limited by the "Allowed run time in seconds" property).
- Upon success, the nested panels will be moved to the stock sheets, and the script instance will delete itself.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| NESTER INFO | String | - | Read-only field displaying status or error messages. |
| Objects To Nest | Dropdown | Child Panels | Choose whether to nest existing hsbCAD Child Panels or generic Polylines. |
| Sip style | Dropdown | Dynamic | Defines the material and construction style for panels created from Polylines. |
| MasterPanel style | Dropdown | Dynamic | Defines the style for the stock Master Panels (sheets). |
| MasterPanel Name | String | - | Assigns a specific name prefix to the generated Master Panels. |
| Use 1220x4800 | Dropdown | No | Enable to include a 1220x4800mm stock sheet in the nesting calculation. |
| Use 1220x4900 | Dropdown | No | Enable to include a 1220x4900mm stock sheet in the nesting calculation. |
| Use 1220x5100 | Dropdown | No | Enable to include a 1220x5100mm stock sheet in the nesting calculation. |
| Use 1220x5500 | Dropdown | No | Enable to include a 1220x5500mm stock sheet in the nesting calculation. |
| Use 1220x6000 | Dropdown | No | Enable to include a 1220x6000mm stock sheet in the nesting calculation. |
| Use 1220x6250 | Dropdown | No | Enable to include a 1220x6250mm stock sheet in the nesting calculation. |
| Use 1220x6500 | Dropdown | No | Enable to include a 1220x6500mm stock sheet in the nesting calculation. |
| Use 1220x7500 | Dropdown | No | Enable to include a 1220x7500mm stock sheet in the nesting calculation. |
| Allowed run time in seconds | Number | 360 | Maximum time allowed for the nesting algorithm to find a solution. |
| Minimum spacing | Number | 35 | Clearance distance between nested parts (saw kerf/safety margin) in mm. |
| Nester to use | Dropdown | V6 | Selects the algorithm version (Test, V4, V5, or V6). |

## Right-Click Menu Options
There are no specific context menu options added by this script. Configuration is done entirely via the Properties Palette.

## Settings Files
No external settings files (XML) are used by this script. All configuration is handled via Properties and Catalog entries.

## Tips
- **Self-Deleting**: The script instance automatically erases itself after a successful run. You only need to insert it again if you want to re-nest.
- **Dongle Requirement**: If the script fails with "No dongle present," ensure your hsbCAD security dongle is connected.
- **Calculation Time**: If you have many complex parts, increase the "Allowed run time in seconds" to allow the algorithm more time to find a better fit.
- **Polyline Workflow**: When nesting polylines, ensure your text labels are positioned inside the corresponding polyline boundaries so the script can link them correctly.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  - A: This is normal behavior. The script creates the geometry (Master Panels and nested parts) and then removes itself from the drawing to keep the model clean.
- **Q: What happens if the calculation takes too long?**
  - A: The script will stop at the time limit defined in "Allowed run time in seconds" and use the best solution found up to that point. Increase this value if the result is not optimal.
- **Q: Can I mix different stock sizes?**
  - A: Yes. You can enable multiple "Use 1220x..." options (e.g., both 4800 and 6000 lengths) to allow the nester to mix different sheet sizes.