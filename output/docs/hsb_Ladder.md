# hsb_Ladder.mcr

## Overview
Automatically generates a structural Gable Ladder (ladder frame) at a roof gable end. It creates longitudinal rafters and cross blocking (dwangs) based on a selected roof plane and a reference element to facilitate cladding and barge board fixing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script generates 3D construction beams here. |
| Paper Space | No | Not applicable for this script. |
| Shop Drawing | No | Not applicable for this script. |

## Prerequisites
- **Required Entities**:
  - 1x Roof Plane (`ERoofPlane`)
  - 1x Reference Element (e.g., a wall plate or beam defining the gable position)
- **Minimum Beam Count**: 0
- **Required Settings**:
  - A valid **Floor Group** must be set current if you intend to use the "Gable Ladder Name" (Element creation) feature.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_Ladder.mcr`

### Step 2: Configure Initial Properties (Optional)
A "Properties" dialog will appear automatically upon insertion. You can accept the defaults or adjust key dimensions (like Width, Height, and Distribution) here. You can also change these later in the Properties Palette.

### Step 3: Select Roof Plane
```
Command Line: Select Roofplane
Action: Click on the Roof Plane that defines the pitch and geometry for the gable end.
```

### Step 4: Select Reference Element
```
Command Line: Select Reference Element
Action: Click on the structural element (e.g., top plate or trimmer) that positions the ladder vertically and horizontally.
```

### Step 5: Generation
The script calculates the geometry, generates the ladder beams, and groups them (if a Component Name is provided). The script instance erases itself, leaving only the construction beams.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Gable Ladder Name (sCompName) | Text | GL1 | Name of the manufacturing component. If filled, groups beams into an Element. |
| Notes (sNotes) | Text | | User notes for the element. |
| Dimstyle (sDimStyle) | Dropdown | _DimStyles | Dimension style applied to the element. |
| Timber Width (dWidth) | Number | 38 | Thickness of the timber used for rafters and blocking (mm). |
| Timber Height (dHeight) | Number | 90 | Depth of the timber used for rafters and blocking (mm). |
| Material (sMaterial) | Text | CLS | Material code (e.g., CLS). |
| Grade (sGrade) | Text | C16 | Structural grade of the timber. |
| Back Span (dBackSpan) | Number | 650 | Horizontal depth of the ladder frame (length of cross blocking) in mm. |
| Thickness Spandrel (dThicknessSpandrel) | Number | 101 | Vertical setback/offset of the ladder top from the reference element (mm). |
| Distribution (dDistribution) | Number | 600 | On-center spacing between cross blocking/dwang (mm). |
| Minimum Length (dMinLength) | Number | 150 | Minimum allowable length for the last timber segment (mm). |
| Sides Offset Cross Blocking (dOffsetBlocking) | Number | 20 | Distance from the eave end to the center of the first cross dwang (mm). |
| Alignment (sOrientation) | Dropdown | Below Plane | Sets ladder position: "Below Plane" (standard infill) or "Above Plane" (external). |
| Max Timber Length (dMaxTimberLength) | Number | 4780 | Maximum stock length. Rafters longer than this will be split. |
| Color (nColor) | Number | 171 | AutoCAD color index for the generated beams. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None Specified) | This script does not add custom items to the right-click context menu. Use the Properties Palette (Ctrl+1) to modify parameters and regenerate the ladder. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files; all configuration is done via the Properties Palette.

## Tips
- **Element Creation**: If you provide a "Gable Ladder Name", ensure a Floor Group is active in the drawing. If not, the script will display an error and erase itself.
- **Splitting Rafters**: If your gable is very long, the script will automatically splice the longitudinal rafters at the interval defined in "Max Timber Length".
- **Spacing Logic**: The script ensures the last gap at the top of the ladder does not fall below the "Minimum Length" setting. If space is tight, it may adjust the top spacing.
- **Orientation**: Use "Alignment" > "Above Plane" if you are applying the ladder to the exterior of the roof structure, or "Below Plane" for standard infill.

## FAQ
- **Q: The script disappeared immediately after I selected the elements. Why?**
- **A:** This usually happens if you entered a "Gable Ladder Name" but did not have a valid Floor Group set current. Make a floor group current and try again. It can also happen if the Reference Element does not intersect the Roof Plane geometry.
- **Q: How do I change the spacing of the cross dwangs?**
- **A:** Select any of the generated beams and open the Properties Palette (Ctrl+1). Change the "Distribution" value, and the ladder will update automatically.
- **Q: Can I move the ladder up or down?**
- **A:** Yes. Use the "Thickness Spandrel" property to adjust the vertical position relative to the reference element, or change the "Alignment" to toggle between the inside and outside of the roof plane.