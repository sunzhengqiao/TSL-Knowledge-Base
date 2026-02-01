# HSB-SectionManager.mcr

## Overview
Automates the creation and management of 2D section markers (cutting lines) in PaperSpace layouts for timber wall or floor elements. It automatically generates section indicators (A, B, C or 1, 2, 3) on layout views, including optional sections for openings, with tools to visualize and manage the cutting planes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script operates entirely within PaperSpace layouts. |
| Paper Space | Yes | Requires a viewport linked to an hsbCAD Element. |
| Shop Drawing | Yes | Used for detailing views and creating section cuts. |

## Prerequisites
- **Required Entities**: A layout containing a `Viewport` that displays a valid hsbCAD `Element` (Wall or Floor).
- **Minimum Beam Count**: 0 (Script works on the element level, but requires geometry to generate meaningful sections).
- **Required Settings**: 
    - `HSB_G-FilterGenBeams.mcr` (for advanced beam filtering)
    - Standard AutoCAD `DimStyles` and `LineTypes`.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB-SectionManager.mcr` from the catalog.

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport in the layout where you want to generate section markers.
```
*Note: The script will automatically detect the element inside the viewport and generate section markers based on the default properties.*

## Properties Panel Parameters

### Sections
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Standard section depth | Number | 500 mm | Graphical length of the section cut line for standard sections. |
| Opening section depth | Number | 500 mm | Graphical length of the section cut line for openings (windows/doors). |
| Custom section depth | Number | 500 mm | Graphical length for manually added sections. |
| Offset standard horizontal section | Number | 1000 mm | Distance from the reference side to place the horizontal section line. |
| Reference side horizontal offset | Dropdown | Bottom | Sets the reference for the horizontal offset (Top or Bottom). |
| Section Position(s) | Dropdown | Vertical and Horizontal | Determines which sections to generate automatically. |
| Add openings as extra sections | Dropdown | Yes | If 'Yes', adds sections specifically for openings; if 'No', openings may replace standard section locations. |

### Visible Sections
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Visualize sections | Dropdown | No | If 'Yes', draws the cutting plane polygon/hatch; if 'No', only the line and text are shown. |
| Offset | Number | 100 mm | Distance between the viewport (or element) boundary and the start of the section line. |
| Offset visible sections from | Dropdown | Viewport | Calculates the offset distance from either the Viewport or the Element geometry. |
| Line type visible section | Dropdown | *ByLayer* | The CAD LineType assigned to the visualized section plane. |

### Format
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Text Height | Number | 10 mm | Height of the section label text (e.g., "A", "1"). |

### Filter
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter beams and sheets with label | Text | Empty | Excludes beams/sheets matching this label. |
| Filter beams and sheets with material | Text | Empty | Excludes beams/sheets matching this material. |
| Filter beams and sheets with hsbID | Text | Empty | Excludes beams/sheets matching these hsbIDs. |
| Filter zones | Text | Empty | Excludes beams/sheets in these zones. |
| Filter openings with description | Text | Empty | Excludes openings matching this description. |
| Filter definition for GenBeams | Dropdown | Empty | Select a pre-defined filter from `HSB_G-FilterGenBeams.mcr`. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the section markers based on current geometry and property settings. |
| Recalculate All | Clears the internal cache and recalculates all sections. Use this if sections seem stuck or missing. |
| Delete section | Prompts you to enter a Section ID (e.g., "A", "1", "B") to remove a specific section marker from the drawing. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams.mcr`
- **Location**: Company or TSL Catalog path
- **Purpose**: Provides pre-defined filter catalogs to easily exclude specific types of beams (e.g., rafters, gable studs) from the section calculation logic.

## Tips
- **Visualization**: Turn "Visualize sections" to **Yes** temporarily to see exactly where the script is cutting the model. This helps verify that filters are working correctly before plotting.
- **Filtering**: Use the "Filter definition for GenBeams" to quickly exclude common elements like "RidgeBeams" or "Purlins" without needing to know specific material names.
- **Offsets**: If your section markers are overlapping the drawing, increase the "Offset" property. If they are too far away, decrease it or switch "Offset visible sections from" to `Element`.
- **Manual Deletion**: If the auto-generated sections are not where you want them, use the "Delete section" context menu to remove specific ones, and manually draw your own if necessary.

## FAQ
- **Q: Why are no sections showing up?**
  **A**: Check your "Section Position(s)" property. If set to "Vertical Only" but your element is a floor viewed from above, you might need "Horizontal Only". Also, verify that your filters are not excluding every beam in the element.

- **Q: How do I change the section label from 'A' to '1'?**
  **A**: The script automatically assigns letters (A, B, C) to horizontal sections and numbers (1, 2, 3) to vertical sections. You cannot change this convention directly in the properties, but you can delete the auto-generated section and draw a manual one, or modify the script code if customization is required.

- **Q: The section line is too short/long.**
  **A**: Adjust the "Standard section depth" or "Opening section depth" properties in the palette and run "Recalculate".

- **Q: Can I use this on a Roof element?**
  **A**: Yes, provided the Roof is treated as a valid hsbCAD Element within the viewport. The logic relies on finding the longest vertical beam to determine placement, so results may vary based on roof geometry (e.g., flat roofs vs. steep rafters).