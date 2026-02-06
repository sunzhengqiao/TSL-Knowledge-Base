# Simpson StrongTie BS.mcr

## Overview
Inserts and configures Simpson Strong-Tie face-mount timber hangers (BSN, BSI, BSIL, BSD, BSDIL) to connect two perpendicular timber beams in the model. It automatically selects the correct hanger size based on the supported beam dimensions and adds the necessary hardware and nails to the Bill of Materials (BOM).

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Interaction with 3D beams is required. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Marks are generated in the model; dimension requests are sent to the map. |

## Prerequisites
- **Required Entities**: Two `GenBeam` entities or Element groups.
- **Minimum Beam Count**: 2 beams.
- **Geometry**: Beams must intersect or touch at approximately 90 degrees (perpendicular).
- **Dimensions**: The supported (male) beam width and height must match a standard Simpson Strong-Tie size defined in the internal catalog (e.g., 40mm width x 99mm height).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Simpson StrongTie BS.mcr`

### Step 2: Select Beams
```
Command Line: Select 2 beams
Action: Click on the Supporting Beam (Female/Carrier) first, then click the Supported Beam (Male).
```
*Note: The script will verify that the beams are perpendicular. If the connection is valid, it will automatically generate the hanger.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Flush Mounted | Boolean | false | If set to true, adjusts the hanger vertical position to sit flush with the bottom of the supporting beam. |
| Nailing Schedule | Integer | 0 | Determines the nailing pattern. <br>0 = Full Nailing (Standard)<br>1 = Partial Nailing (Reduced) |
| Marking Style | Integer | 0 | Sets the visual marking style on the beam.<br>0 = None<br>1-8 = Various Line Styles<br>9 = Text Label |
| Marking Text | String | "" | Custom text string to use for the marking label (if Marking Style is 9). |
| Include Male PosNum | Boolean | false | If true, appends the supported (male) beam's position number to the marking text (e.g., "FEM/MAL"). |
| Purge Hardware | Boolean | false | If set to true, the script will delete all associated hardware components on the next update/calculation. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Assign to Supported Beam | Changes the assignment of the script instance to the male beam. Useful for organizing the BOM or if the hierarchy of the connection changes. |
| Assign to Supporting Beam | Changes the assignment of the script instance to the female beam (default behavior). |

## Settings Files
- **Filename**: None (Internal Catalog)
- **Location**: N/A
- **Purpose**: This script uses internal arrays (`sArticlesRaw`, `dAs`, `dBs`) to store the Simpson Strong-Tie catalog data. No external XML settings file is required.

## Tips
- **Auto-Sizing**: You do not need to manually type the part number (e.g., BSN40/99). The script automatically looks up the correct part number based on the width and height of the supported (male) beam.
- **BOM Accuracy**: To update the nail count in your reports, simply change the **Nailing Schedule** property from "Full" (0) to "Partial" (1) and regenerate.
- **Clash Detection**: The script checks for intersections with other items. If it detects a clash, it will automatically delete itself to prevent model errors. Check your log for the message "Intersects with other item" if the tool disappears.
- **Visual Marking**: Enable **Marking Style** (set to 1-9) to draw lines or text on the beam face, which helps CNC operators or assembly teams identify where to install the hardware.

## FAQ
- **Q: Why did the script disappear after I inserted it?**
  A: The script likely detected a geometric intersection with another tool or entity, or the beams were not perpendicular. Check the command line history or log for an error message.
  
- **Q: Can I use this for non-standard beam sizes?**
  A: No. The script relies on a lookup table of standard Simpson Strong-Tie dimensions. If your beam size does not match a catalog entry (e.g., width 42mm), the script will fail to find a valid hanger.

- **Q: How do I change the hanger from a BSN to a BSD type?**
  A: The script logic selects the series based on the internal catalog mapping. Generally, you must ensure your beam dimensions match the specific series required (BSN vs BSD). If the dimensions overlap, you may need to modify the script code to prioritize one series over the other.