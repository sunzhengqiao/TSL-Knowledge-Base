# hsbSolid2PanelConversion.mcr

## Overview
Converts imported 3D solid bodies (generic geometry) into intelligent hsbCAD Panels. It detects complex features like holes and countersinks, maps material properties, and applies grain direction for manufacturing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates exclusively in the 3D model environment. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This is a model generation script, not a detailing script. |

## Prerequisites
- **Required Entities**: A 3D Solid (Body) or a GenBeam in the drawing.
- **Minimum Beam Count**: 0 (Operates on Solids or existing Beams).
- **Required Settings**: None specific.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbSolid2PanelConversion.mcr` from the list.

### Step 2: Select Source Geometry
```
Command Line: (Implicit selection or prompt)
Action: Click on the 3D Solid or GenBeam entity you wish to convert into a panel.
```
*Note: The script will analyze the selected geometry to determine bounding box, voids (holes), and material mapping.*

### Step 3: Review Preview
The script generates a preview of the resulting hsbPanel.
1.  Check the orientation of the panel.
2.  Verify the grain direction (indicated visually).
3.  Inspect detected holes/drills.

### Step 4: Edit Properties (Optional)
With the preview active, open the **Properties Palette** (Ctrl+1).
- Update Material, Code, or other metadata as required.

### Step 5: Finalize Conversion
Confirm the conversion to generate the final hsbPanel entity.
- The original **3D Solid** will be erased.
- The original **GenBeam** (if used) will remain in the drawing.
- The script instance will delete itself automatically upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Material | String | *From Map* | Assigns the timber material to the new panel. |
| Code | String | *From Map* | Sets the element code for the panel. |
| bConversionAccepted | Boolean | False | Toggle to True to finalize the conversion and create the panel. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Create Group from Text | Prompts you to select a text entity in the drawing to create and assign a group to the panel and its tools (Debug mode only). |
| Rotate X-Axis and Grain Direction | Rotates the coordinate system of the preview to adjust the panel's orientation and wood grain direction. |
| Discard Conversion | Cancels the current operation and removes the script instance without creating a panel. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: This script relies on internal geometry analysis and manual property input rather than external XML settings files.

## Tips
- **Original Geometry**: If you convert a standard AutoCAD 3D Solid, the original solid is deleted. If you need to keep it, copy it before running the script.
- **Drill Detection**: The script attempts to create intelligent `hsbPanelDrill` tools for detected holes. If the specific drill TSL is not found, it falls back to static geometry, so the visual result remains correct.
- **PosNum Handling**: If your requested Position Number is already in use, the script will automatically add 1000 to it and store the requested number in `SubLabel2`.

## FAQ
- **Q: Can I convert a Beam into a Panel?**
  - A: Yes, you can select a GenBeam. Unlike a 3D Solid, the original GenBeam will not be deleted after conversion.
- **Q: What happens if the drill detection fails?**
  - A: The script includes a fallback mechanism. If the intelligent drill component cannot be loaded, it creates a static drill representation on the panel so no manufacturing data is lost.
- **Q: How do I cancel the conversion?**
  - A: Right-click on the script instance and select "Discard Conversion" before you finalize the process.