# hsbFreeProfile.mcr

## Overview
This tool allows you to create custom-shaped cutouts, pockets, or decorative profiles on timber elements (beams, panels, CLT, etc.) by selecting an existing 2D polyline. It supports both visual modeling for drawings and CNC output for manufacturing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in 3D model context. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This is a modeling/cam script, not a detailing script. |

## Prerequisites
- **Required Entities**:
  - A GenBeam (Beam, Sheet, Panel, SIP, or CLT element).
  - A 2D Polyline (EntPLine) defining the shape of the cut.
- **Minimum Beam Count**: 1
- **Required Settings**: None strictly required, but `Hsb_Settings` is referenced if Tool Diameter is set to 0 (Auto).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbFreeProfile.mcr` from the list.

### Step 2: Configure Properties (Optional)
- **Action**: The Properties Palette will appear automatically upon insertion (unless run from a specific catalog configuration).
- **Action**: Adjust default parameters like Depth, Diameter, or Tool Index if needed before selecting geometry.

### Step 3: Select Element
```
Command Line: Select beam
Action: Click on the timber element (Beam, Panel, CLT) you wish to modify.
```

### Step 4: Select Profile Shape
```
Command Line: Select polyline
Action: Click on the 2D Polyline that defines the shape of the profile or cutout.
```

### Step 5: Define Cut Side (Conditional)
```
Command Line: Select point to close free profile or to define part to cut
Action: Only appears if the 'Mill Side' property is set to |auto side|. Click on the side of the polyline where you want the material removed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Depth | Number | 0 | The depth of the cut. A value of 0 means the cut goes all the way through the material (perforation). |
| Diameter | Number | 0 | The diameter of the cutting tool. Enter 0 to automatically look up the tool diameter from Hsb_Settings based on the Tool Index. |
| Tool index | Integer | 0 | The CNC mode or tool ID assigned to this operation. Maps the operation to a specific machine tool during export. |
| Solid path only | Dropdown | \|No\| | If "No", models as a volumetric pocket (removed material). If "Yes", models as a surface path (visual line/groove). |
| Machine path only | Dropdown | \|Yes\| | If "Yes", the machine follows the path contour (routing). If "No", the machine treats the enclosed area as a pocket to be milled out. |
| Mill side | Dropdown | \|auto side\| | Defines the cut orientation relative to the polyline: Left, Right, Center, or Auto (prompts for point selection). |
| Cut Def As One | Dropdown | \|No\| | Optimization setting. If "No", trims the polyline to the beam boundary for efficient code. If "Yes", exports the full original polyline path. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Ecs | Adds an Entity Coordinate System (ECS) marker. This allows you to rotate and move the 2D profile in 3D space independent of the original polyline's orientation. |

## Settings Files
- **Filename**: `Hsb_Settings` (Referenced)
- **Location**: Database/Company Standards
- **Purpose**: Provides default tool diameters when the `Diameter` property is set to 0.

## Tips
- **Editing the Shape**: You can grip-edit the original Polyline in AutoCAD after insertion, and the FreeProfile will automatically update to match the new geometry.
- **3D Orientation**: Use the "Add Ecs" right-click option if your profile needs to be cut at an angle or projected onto a complex face. Move the Ecs marker to reorient the tool path.
- **Through Cuts**: Leave `Depth` as 0 for a cut that penetrates the entire beam or panel thickness.

## FAQ
- **Q: The script disappeared after I deleted the beam.**
- A: This is normal behavior. The script is linked to the beam; if the beam is erased, the script erases itself to prevent errors.
- **Q: What is the difference between Solid path only and Machine path only?**
- A: *Solid path only* controls what you see in the 3D model (Volume vs. Line). *Machine path only* controls how the CNC machine cuts (Contour vs. Pocket Area).
- **Q: How do I change the size of the cutter bit without measuring?**
- A: Set the `Diameter` property to 0 and ensure the correct `Tool index` is selected. The system will pull the correct size from your standard settings.