# hsb_NotchStuds.mcr

## Overview
Automatically detects header beams within selected wall elements and notches intersecting studs to provide clearance. This tool is essential for detailing wall panels with window or door openings, ensuring proper fitment with optional construction tolerances.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for shop drawing generation. |

## Prerequisites
- **Required Entities**: Elements containing Beams (e.g., wall panels with both studs and headers).
- **Minimum Beam Count**: Elements must contain at least one beam designated as a Header and one perpendicular stud.
- **Required Settings**: None required externally; all settings are handled via Properties.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_NotchStuds.mcr` from the file dialog.

### Step 2: Configure Settings (Optional)
```
Dialog: Show Dynamic Dialog
Action: Adjust parameters such as Header Code and Tolerance if needed, then click OK.
Note: This dialog may only appear during the initial insertion or specific execution modes.
```

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the wall elements (panels) in the model that contain the headers and studs you wish to process. Press Enter to confirm selection.
```

### Step 4: Processing
The script will automatically identify headers, cut the studs, and then erase itself from the model.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tolerance | Number | 1 mm | The additional gap added to the notch dimensions. If multiple headers are stacked, this value is doubled. |
| Beam Code | Text | H | The code used to identify Header beams. Only beams with this code will act as cutting tools. |
| Exclude studs with beam code | Text | (Empty) | A list of beam codes to ignore. Separate multiple codes with a semicolon (e.g., `BLOCK;POST`). Beams with these codes will not be cut. |
| Set notch beams as modules | Dropdown | No | If set to "Yes", notched beams are assigned a unique Module name, labeled "N", and colored Magenta for production tracking. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script instance erases itself immediately after execution, leaving no active right-click menu options. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Script Self-Deletion**: The script automatically erases itself from the model after running. This is normal behavior to prevent duplicate processing.
- **Visual Feedback**:
  - **Flat Studs**: If a stud is flat (height < width), it is colored **Red** and its code is prefixed with 'X'.
  - **Notched Modules**: If "Set notch beams as modules" is "Yes", processed studs turn **Magenta** and receive Label 'N'.
- **Stacked Headers**: The script automatically detects if multiple headers are stacked on top of each other and doubles the tolerance to ensure a clean fit.

## FAQ
- **Q: Why can't I find the script in my model after running it?**
- **A:** The script is designed to run once and then delete itself. The modifications (notches and color changes) remain on the beams, but the script instance is removed.
  
- **Q: How do I undo the changes?**
- **A:** Use the standard AutoCAD `UNDO` command immediately after running the script if the results are not as expected.

- **Q: My studs aren't being cut.**
- **A:** Check your "Beam Code" property. The beams you want to cut *with* (headers) must match this code exactly. Also, ensure the studs you want to cut are not listed in the "Exclude studs with beam code" property.