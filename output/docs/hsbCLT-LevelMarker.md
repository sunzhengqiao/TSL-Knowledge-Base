# hsbCLT-LevelMarker.mcr

## Overview
Generates and manages elevation level markers (level stamps) attached to CLT panels in the 3D model. These markers indicate floor levels or ceiling heights and maintain a parent-child relationship system for coordinated level management across multiple panels.

| Property | Value |
|----------|-------|
| **Script Type** | O (Object) |
| **Version** | 1.1 |
| **Last Updated** | 03 July 2014 |
| **Author** | th@hsbCAD.de |
| **Category** | CLT, Level Markers, Symbols |
| **Required Beams** | 0 |
| **Required Entities** | CLT Panels (Sip) |

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary workspace for 3D model interaction |
| Paper Space | No | Not applicable for layout views |
| Shop Drawing | No | Not applicable for detail/element drawings |

## Prerequisites
- **Required Entities**: CLT Panels (Sip entities) must exist in the model
- **Panel Orientation**: Panels must be either:
  - Aligned in the XY World plane (horizontal), OR
  - Perpendicular to the Z-World axis (vertical walls)
- **KLH Project Special**: For KLH projects, panels must have labels starting with "W" or containing "*W"

## How It Works

### Parent-Child System
The script implements a hierarchical marker system:
- **Parent Marker**: The first marker instance created during insertion
- **Child Markers**: Automatically created on additional selected panels
- Child markers inherit properties from the parent and cannot be modified independently
- Moving the parent marker causes all child markers to maintain alignment

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
```
Or drag and drop `hsbCLT-LevelMarker.mcr` from the catalog.

### Step 2: Configure Properties
If not executed from a Catalog Key, a dynamic dialog appears:

| Setting | Description |
|---------|-------------|
| **Elevation** | The height value to display (e.g., 500 for +500.00) |
| **Size** | Physical size of the marker symbol and text |
| **Style** | Finished Face (solid) or Raw Face (outline) |
| **Type** | Floor (arrow up) or Ceiling (arrow down) |
| **Dimstyle** | Text style from drawing dimension styles |
| **Color** | Color index for marker geometry |

*Note: If executed from a Catalog Key with predefined properties, this dialog is skipped.*

### Step 3: Select CLT Panels
```
Command Line: Select CLT panels
```
Click on the CLT panels you wish to mark. Press Enter when finished.

**Selection Rules**:
- Only Sip entities are accepted
- Panels are filtered based on orientation matching the first selected panel
- Panels must intersect the calculated elevation plane

### Step 4: Set Location
```
Command Line: Select insertion point
```
Click a point in the model space to define the reference plane for the elevation.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Elevation** | PropDouble | 500 | The numeric height value displayed on the marker. Shows as "+0" when set to 0. |
| **Size** | PropDouble | 50 | Controls the physical size/scale of the triangle symbol and text height in model units |
| **Style** | PropString | Finished Face | Determines marker appearance:<br>- **Finished Face**: Filled solid triangle<br>- **Raw Face**: Wireframe outline triangle |
| **Type** | PropString | Floor | Determines arrow direction:<br>- **Floor**: Arrow points UP<br>- **Ceiling**: Arrow points DOWN |
| **Dimstyle** | PropString | *First available* | Text style for elevation label (populated from drawing DimStyles, sorted alphabetically) |
| **Color** | PropInt | 211 | Color index for marker geometry and text (standard AutoCAD color index) |

### Parameter Dependencies

| Condition | Behavior |
|-----------|----------|
| Child Instance | Elevation, Size, Style, Type become read-only |
| Child Position | Automatically aligned to parent's elevation plane |
| Parent Modification | All children update automatically |

## Right-Click Context Menu

| Menu Item | Description |
|-----------|-------------|
| **Add Childs** | Opens panel selection dialog. Creates new child marker instances on selected panels and links them to this parent. Duplicates are automatically filtered. |
| **Delete Childs** | Removes all child marker instances associated with this level marker. The parent instance remains intact. |

## Visual Output

The marker displays as:
- **Triangle Symbol**: Equilateral triangle pointing up (Floor) or down (Ceiling)
- **Base Line**: Horizontal line at the marker origin
- **Elevation Text**: Numeric value displayed above/below the triangle
- **Parent/Child Distinction**: Parents draw their base line in a different color (1 or 3) than children

## Technical Notes

### Orientation Detection
The script automatically detects panel orientation from the first selected panel:
- **3D Mode**: Panel's Z-vector is perpendicular to World-Z (vertical walls)
- **2D Mode**: Panel's Z-vector is parallel to World-Z (horizontal panels)

### Intersection Logic
For a panel to receive a marker:
1. Panel must match the detected orientation (3D or 2D)
2. The elevation plane must intersect the panel's envelope
3. For KLH projects, panel label must contain "W" designation

### Coordinate System
- The reference plane normal is stored in the Map for persistence
- Child markers synchronize their position along the normal direction
- Z-axis is derived from the associated panel's coordinate system

## Tips

1. **Always Modify the Parent**: To change elevation for all markers in a level, select and modify the parent instance. Children will update automatically.

2. **Identifying Parents vs Children**: Parent markers have a different colored base line (typically color 1 or 3), while children use the default color.

3. **Moving Levels**: Use AutoCAD Move or Grip Edit on the parent instance. All children will reposition to maintain the same elevation plane.

4. **Adding Panels Later**: Use the "Add Childs" context menu to add markers to additional panels without recreating the entire level.

5. **Zero Elevation Display**: When Elevation is set to 0, the text displays with a special prefix character.

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Script disappears immediately | Ensure valid CLT panels (Sip) are selected and they intersect the elevation plane |
| Child markers don't update | Verify you're modifying the parent instance, not a child |
| Panels are ignored | Check panel orientation matches the first selected panel; for KLH projects, verify panel labels |
| Wrong text style | Change the Dimstyle property to select from available dimension styles |
| Cannot modify properties on child | This is expected behavior - modify the parent instance instead |

## Related Scripts

| Script | Relationship |
|--------|--------------|
| `hsbCLT-*` | Other CLT panel tools |
| `hsbTslDim` | General dimensioning utilities |
| `hsbViewTag` | View tagging functionality |

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.1 | 03 Jul 2014 | th@hsbCAD.de | Bugfix for special detection |
| 1.0 | 03 Jul 2014 | th@hsbCAD.de | Initial release |
