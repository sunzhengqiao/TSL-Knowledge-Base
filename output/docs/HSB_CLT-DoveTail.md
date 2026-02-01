# HSB_CLT-DoveTail.mcr

## Overview
Automates the creation of a structural dovetail connection (mortise and tenon) between a standard timber beam and a CLT panel. This script creates an interlocking mechanical joint designed for strong assembly without additional metal fasteners.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model elements. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Does not generate 2D annotations or views directly. |

## Prerequisites
- **Required Entities:**
  - 1 Timber Beam (Standard structural element).
  - 1 CLT Panel (Sip entity).
- **Minimum Entity Count:** 2 (One Beam and One Panel).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_CLT-DoveTail.mcr` from the file dialog.

### Step 2: Select the Main Beam
```
Command Line: Select beam
Action: Click on the timber beam that will form the male "tenon" part of the connection.
```

### Step 3: Select the CLT Panel
```
Command Line: Select panel
Action: Click on the CLT panel that will receive the "pocket" or slot for the connection.
```

## Properties Panel Parameters

Once the script is inserted, select the script instance in the model to edit these parameters in the Properties Palette.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Dovetail** | Header | N/A | Visual separator for the connection settings. |
| **Width** | Number | 40 mm | The length of the dovetail along the longitudinal axis of the beam. |
| **Height** | Number | 80 mm | The vertical height of the dovetail across the face of the beam. Ensure this fits within the beam height. |
| **Depth** | Number | 20 mm | How deep the dovetail penetrates into the CLT panel (determines tenon thickness). Ensure this is less than the panel thickness. |
| **Angle** | Number | 20° | The taper angle of the dovetail sides. A steeper angle holds tighter; a shallower angle is easier to assemble. |

## Right-Click Menu Options

There are no custom context menu options for this script. Use the Properties Palette to modify parameters.

## Settings Files
- **Filename:** None required.
- **Location:** N/A
- **Purpose:** N/A

## Tips
- **Visual Feedback:** If the joint looks incorrect, move the Beam or Panel using standard CAD Move commands. The script will automatically recalculate the connection geometry based on the new positions.
- **Assembly Clearance:** If you require clearance for glue or easier assembly, slightly reduce the **Depth** parameter relative to the panel thickness.
- **Validation:** The script will automatically delete itself if you select an invalid beam or panel during insertion. Ensure you select a valid Beam first and a valid Sip (Panel) second.

## FAQ
- **Q: Why did the script disappear immediately after I selected the elements?**
  - A: The script performs validity checks. If the first selection was not a valid Beam or the second selection was not a valid CLT Panel (Sip), the script self-destructs. Re-insert and ensure you select the correct entity types.

- **Q: Can I use this to connect two regular beams together?**
  - A: No, this script is specifically designed to connect a Timber Beam to a CLT Panel (Sip entity).

- **Q: What happens if I resize the beam after inserting the connection?**
  - A: The connection parameters (Width/Height) do not automatically update to match the new beam size. You must manually check the Properties Palette to ensure the dovetail dimensions still fit within the resized beam.