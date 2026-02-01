# HSB-ElementSection.mcr

## Overview
Generates a filtered 2D cross-section view of a timber element (wall, roof, or floor) directly within a PaperSpace viewport. It allows for detailed filtering of structural members, visualization of tooling, and display of openings based on a linked Section Manager.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script operates exclusively in PaperSpace layouts. |
| Paper Space | Yes | Requires two Viewports: one for the section and one for the Section Manager. |
| Shop Drawing | Yes | Designed for creating specific manufacturing details and assembly views on layout sheets. |

## Prerequisites
- **Required Entities**:
  - Two valid Viewports must exist in the layout.
  - An hsbCAD Element (Wall/Roof/Floor) assigned to the primary Viewport.
  - An instance of the `HSB-SectionManager.mcr` script loaded in the drawing.
- **Minimum Beam Count**: 0 (Script handles empty elements gracefully).
- **Required Settings**:
  - `HSB_G-FilterGenBeams.mcr`: (Optional but recommended) Provides catalog entries for advanced beam filtering.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB-ElementSection.mcr` from the file dialog.

### Step 2: Select Viewport for Section
```
Command Line: Select a viewport for this section
Action: Click inside the viewport where you want the 2D section cut to be drawn.
```

### Step 3: Select Section Manager Viewport
```
Command Line: Select the viewport of the section manager
Action: Click inside the viewport that contains the HSB-SectionManager instance.
```
*Note: If you select fewer than two viewports, the script instance will be erased automatically.*

### Step 4: Configure Properties
After selection, the **Properties Palette** (Ctrl+1) will activate.
- Adjust filters (Beam Codes, Materials, Labels) to control which parts of the element are drawn.
- Set the **Section ID** (e.g., "A") to label the view.
- Toggle **Opening Info** or **Display Representation** to change visual styles.

## Properties Panel Parameters

### Selection & Filtering
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| genBeamFilterDefinition | Dropdown | | Select a preset filter logic from the `HSB_G-FilterGenBeams` catalog. |
| sFilterBC | Text | | Filter by Beam Code (e.g., `STUD;PLATE`). Separate multiple codes with semicolons. |
| sFilterLabel | Text | | Filter by the main Element Label (e.g., Wall 1). |
| sFilterSubLabel | Text | | Filter by the first sub-label. |
| sFilterSubLabel2 | Text | | Filter by the second sub-label. |
| sFilterMaterial | Text | | Filter by material name (e.g., `C24;GL28h`). |
| sFilterGrade | Text | | Filter by timber strength grade. |
| sFilterName | Text | | Filter by the specific entity name. |
| sFilterHsbId | Text | | Filter by the unique internal hsbCAD ID. |
| sFilterZone | Text | | Filter by construction zone index (e.g., `0;1`). |

### Visual Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sSectionId | Text | A | The label text (e.g., A, B, 1) placed in the viewport to identify the cut. |
| sShowOpeningInfo | Dropdown | No | If "Yes", displays text descriptions (dimensions) inside window/door openings. |
| sUseDispRep | Dropdown | No | If "Yes", uses Display Representations (hatching/styles) instead of raw geometry. |
| sDispRepBeam | Text | | The Display Representation style to use for Beams (when `sUseDispRep` is Yes). |
| sDispRepSheet | Text | | The Display Representation style to use for Sheets (when `sUseDispRep` is Yes). |
| sLineType | Text | | The linetype used for drawing section cut lines. |
| sDimStyle | Text | | The dimension style used for the Section ID label text. |
| sLayeNoPlot | Text | G-Anno-View | The layer for the Section ID marker (usually non-plotting). |

### Tooling & Advanced
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| nZnIndexDrill | Number | 10 | The construction zone index used to determine drill hole color/layer. |
| sZoneCharDrill | Text | Tooling | The layer category for drilling visualization (Zone, Info, Dimension, Tooling). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the section geometry immediately if the Element model changes. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams.mcr`
- **Location**: TSL Catalog or Company Folder
- **Purpose**: Defines complex filtering logic (e.g., "Show only load-bearing studs") that can be selected via the `genBeamFilterDefinition` property.

## Tips
- **Linking Elements**: Ensure the primary Viewport is already linked to the correct hsbCAD Element (Wall/Roof) before inserting the script, or it will exit without drawing.
- **Cleaning Views**: Use `sFilterBC` (Beam Code) to quickly hide cladding or sheathing materials to show only the structural frame.
- **Section Manager**: Keep the Section Manager viewport on the same layout sheet. If the Manager is deleted or moved to another tab, this script will display an error.
- **Visualization**: For presentation plans, enable `sUseDispRep` and assign a hatching style to `sDispRepBeam` to create standard architectural hatch patterns.
- **Move Viewports**: You can move the script's viewport using standard AutoCAD grips. The section contents will automatically update to remain aligned with the model geometry.

## FAQ
- **Q: Why do I see the text "No Section Manager Found!" in my viewport?**
  - A: The script cannot locate the `HSB-SectionManager.mcr` instance in the drawing. Ensure you have inserted the Section Manager script into a viewport on this layout.
- **Q: Why is my section view empty?**
  - A: Your filters might be too restrictive. Check the `sFilterBC`, `sFilterMaterial`, or `genBeamFilterDefinition` properties. Alternatively, the viewport might not be cutting through the physical geometry of the element.
- **Q: Can I dimension this section automatically?**
  - A: This script draws the geometry. Use standard AutoCAD dimensioning tools on top of the generated lines, or check if your Section Manager has automated dimensioning features enabled.
- **Q: How do I change the label from 'A' to 'Detail 1'?**
  - A: Select the script instance, open the Properties Palette (Ctrl+1), and change the `sSectionId` property to "Detail 1".