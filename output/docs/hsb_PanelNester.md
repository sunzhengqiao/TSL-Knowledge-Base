# hsb_PanelNester.mcr

## Overview
This script automates the nesting of timber panels (either existing Child Panels or closed Polylines) onto standard Master Panel sheets. It calculates an optimal layout to minimize material waste and generates the nested geometry in the model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in 3D Model Space. |
| Paper Space | No | Not supported for layout or nesting. |
| Shop Drawing | No | This is a pre-production/modeling tool. |

## Prerequisites
- **Required Entities**:
  - Existing `ChildPanel` entities OR closed `Polylines` (EntPLine).
  - If using Polylines, `Text` or `MText` entities (Labels) are recommended for naming.
- **Required Settings**:
  - **Nesting Dongle**: A valid hsbCAD nesting license key/dongle must be present.
  - **SipStyle**: Definitions must exist in the catalog (if nesting from Polylines).
  - **MasterPanelStyle**: Definitions must exist in the catalog.
  - **Property Sets**: A Property Set definition named `PanelInfo` containing a property `PanelCode` is required when nesting Polylines.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Select `hsb_PanelNester.mcr` from the file dialog.

### Step 2: Configure Parameters
1. The script will either display a dynamic dialog or populate the Properties Palette.
2. Set the **Objects To Nest** (Child Panels or Polylines).
3. Select the appropriate **Sip style** and **MasterPanel style**.
4. Toggle the desired sheet sizes (e.g., **Use 1220x6000**).
5. Adjust **Minimum spacing** or **Reduce length/width** if necessary for saw kerfs.

### Step 3: Set Origin
```
Command Line: Set point to place master panels
Action: Click in the Model Space to define the insertion point for the nested sheets (e.g., 0,0,0).
```

### Step 4: Select Objects
The prompt depends on your selection in Step 2.

**Option A: Nesting Child Panels**
```
Command Line: Select child panels
Action: Select the existing Child Panel entities you wish to nest and press Enter.
```

**Option B: Nesting Polylines**
```
Command Line: Select close polylines
Action: Select the closed Polylines representing your panels and press Enter.
Command Line: Select labels
Action: Select Text/MText entities to name the panels (Optional, press Enter to skip).
```

### Step 5: Generation
The script runs the nesting algorithm. If successful, it creates the Master Panels and places the nested panels inside them. The script instance then erases itself automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Objects To Nest** | dropdown | Child Panels | Choose between nesting existing Child Panels or creating new ones from Polylines. |
| **Sip style** | dropdown | *Empty* | Style assigned to new panels created from Polylines. |
| **MasterPanel style** | dropdown | *Empty* | Style assigned to the generated stock sheets. |
| **MasterPanel Name** | text | *Empty* | Prefix name for the generated Master Panels. |
| **Use 1220x4800** | dropdown | No | Include this specific sheet size in the nesting stock. |
| **Use 1220x4900** | dropdown | No | Include this specific sheet size in the nesting stock. |
| **Use 1220x5100** | dropdown | No | Include this specific sheet size in the nesting stock. |
| **Use 1220x5500** | dropdown | No | Include this specific sheet size in the nesting stock. |
| **Use 1220x6000** | dropdown | No | Include this specific sheet size in the nesting stock. |
| **Use 1220x6250** | dropdown | No | Include this specific sheet size in the nesting stock. |
| **Use 1220x6500** | dropdown | No | Include this specific sheet size in the nesting stock. |
| **Use 1220x7500** | dropdown | No | Include this specific sheet size in the nesting stock. |
| **Reduce length by** | number | 0 | Trims the length of the Master Panels (e.g., for saw blade thickness). |
| **Reduce width by** | number | 0 | Trims the width of the Master Panels. |
| **Allowed run time in seconds** | number | 360 | Maximum time the nesting engine is allowed to calculate. |
| **Minimum spacing** | number | 35 | Distance required between nested parts. |
| **Nester to use** | dropdown | Test | Select the nesting algorithm version (Test, V4, V5, V6). |

## Right-Click Menu Options
This script does not add specific items to the entity context menu. It runs once upon insertion and deletes itself.

## Settings Files
This script relies on standard hsbCAD catalogs rather than external XML files:
- **SipStyle Catalog**: Defines the construction makeup of panels.
- **MasterPanelStyle Catalog**: Defines the material/properties of the stock sheets.

## Tips
- **Dongle Required**: If the script reports "No dongle present", ensure your hardware security key is connected or your network license is active.
- **Polyline Workflow**: When nesting Polylines, ensure the Text labels are inside the Polyline boundaries. The script links the text to the panel via the `PanelCode` property.
- **Algorithm Selection**: Use the "Test" nester for instant previews. Use "V6" for the best optimization, but be aware it may take longer to process large quantities.
- **Re-running**: Since the script erases itself, simply run `TSLINSERT` again if you need to adjust settings or re-nest.

## FAQ
- **Q: Why did my script disappear after running?**
  - **A**: This is normal behavior. The script is a "one-shot" generator. It creates the geometry and removes itself from the drawing to prevent clutter.
- **Q: I see the error "Not possible to nest".**
  - **A**: This means the parts cannot fit into the selected sheet sizes with the current spacing. Try enabling larger sheet sizes (e.g., 1220x7500) or reducing the "Minimum spacing".
- **Q: What happens if I select Polylines but no Labels?**
  - **A**: The script will still generate the panels, but the `PanelCode` property in the resulting data may be empty or default.