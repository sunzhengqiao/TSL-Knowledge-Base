# Simpson StrongTie BT

## Overview
This script inserts and configures Simpson Strong-Tie BT series concealed beam hangers to connect two timber beams (typically a joist to a carrier). It automatically generates the 3D metal connector, applies the necessary machining (slots and holes) to the wood, and adds all components to the hardware list.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is intended for 3D model detailing. |
| Paper Space | No | Not designed for layout or paper space. |
| Shop Drawing | No | This is a model generation script, not a drawing generator. |

## Prerequisites
- **Required Entities**: Two GenBeam entities (a Female/Carrier beam and a Male/Joist beam).
- **Minimum Beam Count**: 2
- **Required Settings**: `TslUtilities.dll` (Required for the selection dialogs during insertion).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or `TSL`)
Action: Select `Simpson StrongTie BT.mcr` from the file dialog.

### Step 2: Select the Supporting Beam
```
Command Line: Select female beam
Action: Click on the main carrier or support beam (the beam that holds the hanger).
```

### Step 3: Select the Supported Beam
```
Command Line: Select male beam
Action: Click on the joist or secondary beam that sits inside the hanger.
```

### Step 4: Select Connector Family
```
Dialog: Select Family
Action: Choose the product family (e.g., BT, BT4, BTALU) from the list.
Note: This dialog appears if TslUtilities.dll is loaded.
```

### Step 5: Select Specific Model
```
Dialog: Select Model
Action: Choose the specific catalog size (e.g., BT280) based on the required dimensions.
Note: The script may attempt to auto-select a size based on beam dimensions before showing this list.
```

### Step 6: Generation
Action: The script generates the connector body, cuts slots in the female beam, drills holes in both beams, and adds the hardware to the BOM.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Family | String | BT | The product family of the connector (e.g., BT, BT4, ALU). Changing this updates the available models. |
| Model | String | BT280 | The specific catalog number defining the physical dimensions of the connector. |
| A (Height) | Double | (Calculated) | The height dimension of the connector derived from the selected model. |
| B (Width) | Double | (Calculated) | The width/depth dimension of the connector. |
| C (Thickness) | Double | (Calculated) | The depth or flange thickness of the connector. |
| Mounting | Int | 1 (Plant) | Determines the assembly stage for production lists (Plant, Partial, On-Site). |
| Drill Alignment | Int | 0 | Controls the orientation of the drill vectors (Standard vs. Aligned). |
| Show Badge | Bool | True | Toggles the visibility of the 2D symbol/markers in plan view. |
| Peg Length | Double | (Auto) | The length of the STD12x bolts calculated based on the female beam width. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Drill Face / Cycle Drill Face | Rotates the alignment of the drill holes on the female beam. Useful for non-standard angles. |
| Hide Badge / Show Badge | Toggles the 2D plan view representation of the connector. |
| Partial Assembly Plant / Plant / Construction Site | Sets the 'Notes' field in the hardware list to indicate where the connector should be installed. |
| Drill not through | Toggles the drilling operation between a through-hole and a blind hole. |

## Settings Files
- **Filename**: N/A (Internal Catalog)
- **Location**: Internal Script Arrays
- **Purpose**: The script contains internal arrays for dimensions and models (BT, BT4, etc.). No external XML file is required for standard operation.

## Tips
- **Quick Edit**: After insertion, you can change the Model or Family directly from the Properties Palette (Ctrl+1) to resize the connector without re-running the command.
- **Dummy Beams**: If you insert the connector on a "Dummy" beam (a placeholder beam), the script will automatically exclude fasteners (nails/pegs) from the hardware list while keeping the connector body.
- **Peg Length**: The script automatically calculates the correct length for the through-bolts (STD12x) based on the width of the female beam. You generally do not need to manually adjust this unless you have specific requirements.
- **Visibility**: If your plan views are too cluttered, right-click the connector instance and select "Hide Badge".

## FAQ
- **Q: The selection dialogs did not appear when I ran the script. Why?**
  A: Ensure `TslUtilities.dll` is loaded in your hsbCAD environment. Without it, the script skips the dialogs and relies on default values or property edits later.
- **Q: Can I use this for concrete beams?**
  A: Yes, select the "BTC" (Concrete) family in the Family selection dialog to access models designed for concrete connections.
- **Q: The holes are drilling in the wrong direction.**
  A: Right-click the connector instance and select "Flip Drill Face" or "Cycle Drill Face" to rotate the drill vectors.