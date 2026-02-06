# hsbViewTag

## Overview
Automatically generates and manages annotation tags (labels) for structural elements in 2D views, such as floor plans, sections, and shop drawings. It handles grouping, numbering, collision avoidance, and visual formatting based on element properties and viewport contexts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for manual tagging of selected entities or specific point locations. |
| Paper Space | Yes | Automatically detects viewports and clipping profiles to tag elements within the view. |
| Shop Drawing | Yes | Supports Element Viewports and multi-page Shop Drawing blocks. |

## Prerequisites
- **Required Entities**: GenBeams, Elements (Walls/Roofs), Openings, MetalParts, or FastenerAssemblies.
- **Minimum Beam Count**: 0 (Script can run on empty viewports or wait for user selection).
- **Required Settings**: `hsbViewTagSettings.xml` (Optional; script uses defaults if file is missing).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbViewTag.mcr`

### Step 2: Select Context
**If in Model Space:**
```
Command Line: Select entities or [Enter] to select point:
Action: Select the beams, walls, or parts you want to tag, or press Enter to click a specific location in the drawing.
```

**If in Paper Space / Shop Drawing:**
```
Action: The script automatically detects the active viewport and element clipping profiles. Tags will generate automatically for entities visible in that view.
```

### Step 3: Adjust Configuration (Optional)
Right-click the script instance to access Context Menu options (e.g., Painter Group Settings or Assign Posnums) to customize appearance or numbering.

### Step 4: Fine-Tune Layout
Select the generated tags and use AutoCAD grips to drag them to preferred positions. The leader lines will update automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **bHatchSolidPG** | Boolean | false | If true, Painter Groups use a solid hatch pattern for visual highlighting. |
| **nSeqColors** | Integer | Varies (1-7) | Sequence of color indices used to differentiate Painter Groups or tag clusters. |
| **ntPG** | Integer | 0 | Transparency level for Painter Group highlighting (0-100%). |
| **dSectionDepth** | Double (mm) | 0.0 | The depth perpendicular to the section cut line used to determine which elements are tagged. |
| **dSectionOffset** | Double (mm) | 0.0 | Distance from the section line where the tagging calculation begins. |
| **nPriority** | Integer | 50 | Execution priority relative to other scripts (0-100). |
| **nSequence** | Integer | 50 | Sequencing value to manage calculation order. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Assign Posnums** | Scans for GenBeams without position numbers and assigns them automatically. Triggers a recalculation. |
| **Painter Group Settings** | Opens a dialog to configure visual styles for groups, including hatch patterns, color lists, and transparency. |
| **Import Settings** | Loads configuration settings from `hsbViewTagSettings.xml`. |
| **Export Settings** | Saves current configuration to `hsbViewTagSettings.xml`. Prompts for confirmation if the file already exists. |

## Settings Files
- **Filename**: `hsbViewTagSettings.xml`
- **Location**: 
  - Company Path: `_kPathHsbCompany\hsbViewTag`
  - Install Path: `_kPathHsbInstall\Content\General`
- **Purpose**: Stores Painter Group definitions (colors, hatching), formatting rules, and section depth preferences for reuse across projects.

## Tips
- **Section Depth**: In section views, if tags are missing for elements you expect to see, increase the `dSectionDepth` property value.
- **Clutter Reduction**: Use the `ntPG` (Transparency) parameter in Painter Group Settings to make tag backgrounds less obtrusive.
- **Numbering**: If tags appear empty or show "??", use the "Assign Posnums" context menu option to ensure all beams have valid position numbers.
- **Grip Editing**: You can manually move tags by selecting them and using the blue AutoCAD grips. This is useful for resolving overlapping text in dense areas.

## FAQ
- **Q: Why are my tags not appearing in a viewport?**
  A: Check if the viewport has a defined Clipping Profile. Also, verify that the entities within the viewport belong to a Zone included in the script logic or that the `dSectionDepth` covers the element locations.
  
- **Q: Can I share my tag configuration with a colleague?**
  A: Yes. Right-click the script, select "Export Settings", and share the generated XML file. Your colleague can use "Import Settings" to load your configuration.

- **Q: What happens if I change the `nPriority` setting?**
  A: This changes when the script runs relative to other TSL scripts. If tags are being overwritten by other annotations, try lowering the priority number to make this script run earlier.