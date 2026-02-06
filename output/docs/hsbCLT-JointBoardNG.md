# hsbCLT-JointBoardNG.mcr

## Overview
This script generates a connecting spline or joint board to bridge gaps or join two CLT/SIP panels. It allows you to create either a physical timber beam for manufacturing (CNC/BOM) or a graphical representation for visualization.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in 3D Model Space. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not designed for 2D detailing views. |

## Prerequisites
- **Required Entities**: At least one CLT or SIP panel (`Sip` entity).
- **Minimum Beam Count**: 0 (Operates on panels/elements).
- **Required Settings**: None strictly required, though an XML settings file can be used for preset configurations.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-JointBoardNG.mcr` from the list.

### Step 2: Select Panels
```
Command Line: Select Sip entities:
Action: Click on the CLT or SIP panels you wish to connect or fill a gap between. Press Enter to confirm selection.
```

### Step 3: Position and Preview
```
Command Line: Specify location or [Press Enter to accept]:
Action: Move your mouse to adjust the board's position relative to the panels. A graphical preview will appear. Click to place the board, or press Enter to accept the default calculated position.
```

### Step 4: Configuration (Optional)
After insertion, select the generated joint board and modify dimensions or settings in the Properties Palette (Ctrl+1).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Width | Number | 100 mm | The thickness of the timber joint board. |
| Height | Number | 200 mm | The vertical height (depth) of the joint board. |
| GapWidth | Number | 0 mm | Horizontal clearance (tolerance) between the board and panel edges. |
| GapHeight | Number | 0 mm | Vertical clearance (tolerance) between the board and panel edges. |
| Face | Dropdown | 0 | Aligns the board relative to the panel surface (e.g., Center, Positive side, Negative side). |
| ConvertToBeam | Yes/No | No | If **Yes**, creates a physical GenBeam for production. If **No**, creates a graphical Body only. |
| AutoGroup | String | hsbDefault | The construction group name assigned to the generated element. |
| TextHeight | Number | 2.5 mm | The height of annotation text or dimensions (if visible). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Flip Side** | Toggles the board alignment (Center/Positive/Negative) relative to the panel surface. |
| **Join + Erase** | Joins the selected panels into a single database entity and removes this script instance. |
| **Erase** | Deletes the generated joint board and removes the script instance from the drawing. |
| **Settings** | Opens a dialog to quickly adjust dimensions, beam mode, and display properties. |
| **Import Settings** | Loads configuration parameters from an external XML file. |
| **Export Settings** | Saves the current configuration parameters to an external XML file. |

## Settings Files
- **Filename**: `hsbCLT-JointBoardNG.xml`
- **Location**: hsbCAD Company or Install path.
- **Purpose**: Stores default values for dimensions, material assignments, and visual settings so they can be shared between projects or users.

## Tips
- **Visual vs. Real**: If you need the joint board to appear in your Cut Lists or CNC files, ensure **ConvertToBeam** is set to **Yes**.
- **Tolerances**: Use the **GapWidth** and **GapHeight** parameters if you need assembly clearance between the spline and the panels.
- **Quick Adjustment**: If the board is inserted on the wrong side of the wall, simply right-click the element and select **Flip Side**.
- **Grouping**: Use the **AutoGroup** property to ensure the board is organized correctly in your CAD tree and reports.

## FAQ
- **Q: Why does the board disappear when I change views?**
  - **A:** Ensure **ConvertToBeam** is set to **Yes** if you want a permanent constructible element. If set to **No**, it creates a "Body" which depends on specific display settings.
- **Q: Can I use this script for standard timber beams?**
  - **A:** No, this script is specifically designed for CLT and SIP panels (`Sip` entities). It will not function correctly on standard beams.
- **Q: How do I save my preferred board size for future use?**
  - **A:** Configure the parameters in the Properties Palette, then right-click the element and choose **Export Settings** to save them to an XML file. You can import these settings for future instances.