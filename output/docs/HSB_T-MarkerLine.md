# HSB_T-MarkerLine.mcr

## Overview
This script automatically creates a marking line (and optional text) on a "female" beam to indicate the exact intersection location or identity of a perpendicular "male" beam (T-connection). It is useful for fabrication preparation to visualize where cross-members connect.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used in the 3D model to visualize beam intersections. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not designed for 2D drawing generation. |

## Prerequisites
- **Required Entities:** Two Beams (GenBeams).
- **Minimum Beam Count:** 2
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_T-MarkerLine.mcr` from the file list.

### Step 2: Select Male Beam
```
Command Line: Select male beam
Action: Click on the beam that intersects (the cross-member).
```

### Step 3: Select Female Beam
```
Command Line: Select female beam
Action: Click on the main beam that the male beam connects into.
```

*Note: After selecting the beams, the script will generate the marking on the female beam. You can then modify the appearance via the Properties Palette.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Side** | Dropdown | Contact face | Determines which face of the female beam the marking is applied to. Options include the face touching the male beam, the opposite side, or the lateral sides. |
| **Text** | Text | [Empty] | The text content to mark on the beam. Use `<OTHERPOS>` to automatically display the Position Number of the selected Male Beam. |
| **Text Position** | Dropdown | Center | Controls vertical placement relative to the marker line (Bottom, Center, or Top). |
| **Text Alignment** | Dropdown | Center | Controls horizontal justification relative to the line (Left, Center, or Right). |
| **Direction** | Number | 0 | Controls text rotation/orientation for CNC machine output (Hundegger). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the mark position if you manually edit the geometry of the beams. |
| Erase | Removes the script instance from the model. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** This script does not rely on external settings files.

## Tips
- **Dynamic Labeling:** Enter the exact string `<OTHERPOS>` (without quotes) into the **Text** property. The script will automatically read and display the Position Number of the Male Beam. If the Male Beam's number changes in the Project Manager, the mark will update automatically.
- **Visual Clarity:** Use the **Side** property to move the mark to a visible face if the default contact face is obscured or already crowded with other marks.
- **Auto-Cleanup:** If you delete one of the beams connected to this script, the script instance will automatically delete itself to prevent errors.

## FAQ
- **Q: How can I mark the beam with the name of the intersecting beam?**
  - A: Select the script instance, open the Properties palette, and in the **Text** field, type `<OTHERPOS>`.
- **Q: Can I move the mark to the other side of the beam?**
  - A: Yes. Select the script instance, find the **Side** property in the Properties palette, and change it to "Opposite contact face" or "Side 1/2".
- **Q: Why did the marking disappear?**
  - A: This script requires both beams to exist. If you deleted either the Male or Female beam, the script will automatically remove itself. Re-run the command to recreate it.