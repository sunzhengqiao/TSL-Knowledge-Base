# hsbPanelHeaderAboveOpening

## Overview
Generates a structural header beam above a selected wall opening and automatically cuts the surrounding Structural Insulated Panels (SIPs) to accommodate the new beam.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Must be used within an hsbCAD project. |
| Paper Space | No | Not applicable for layout generation. |
| Shop Drawing | No | This is a 3D model generation script. |

## Prerequisites
- **Required Entities:** An existing Opening entity.
- **Parent Element:** The Opening must be assigned to an Element.
- **Components:** The Element must contain Structural Insulated Panels (SIPs). If the element only has beams, this script will not perform machining.
- **Minimum Beam Count:** None required prior to running.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbPanelHeaderAboveOpening.mcr`

### Step 2: Configure Dimensions
*If a dynamic dialog appears upon insertion:*
- Verify the default height, width, and extension values.
- Adjust as necessary for your specific construction requirements.

### Step 3: Select Opening
```
Command Line: Select opening
Action: Click on the desired opening (door or window) in your model.
```
**Result:** The script inserts a header beam and creates a void (cut) in any intersecting SIPs within the wall element.

### Step 4: Adjustments (Optional)
- Select the newly created script instance (or the opening it is associated with).
- Open the **Properties Palette** (Ctrl+1).
- Modify parameters (e.g., extend the header further left or right) and the model will update automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Height | Number | 100mm | The vertical cross-sectional height (depth) of the header beam. |
| Width | Number | 100mm | The thickness of the header beam (usually matches the wall thickness). |
| Extension Left | Number | 100mm | How far the beam extends past the left side of the opening. |
| Extension Right | Number | 100mm | How far the beam extends past the right side of the opening. |
| Offset Z | Number | 0 | Vertical displacement. Positive values move the beam up; negative values move it down relative to the top of the opening. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific custom items to the right-click context menu. |

## Settings Files
- No external settings files are required for this script.

## Tips
- **Bearing Length:** Use the *Extension Left* and *Extension Right* properties to ensure the header has adequate bearing on the supporting wall studs.
- **SIP Integration:** Ensure your Element definition actually includes SIP entities; otherwise, the automatic void cutting feature will not generate any machining.
- **Offset Z:** If you need the header to sit *flush* with the top of the opening (e.g., for specific aesthetic or structural reasons), check your `Offset Z` value. A standard header usually sits directly on top.

## FAQ

- **Q: The beam was created, but the SIPs weren't cut. Why?**
  A: Verify that the wall element actually contains SIP entities. If the element is defined strictly as a stud frame without panel objects, the script has nothing to cut.

- **Q: Can I use this on multiple openings at once?**
  A: No, this script requires you to select a single opening instance per insertion.

- **Q: What units does this script use?**
  A: The script respects your current hsbCAD project units, though the defaults are displayed in millimeters (mm).