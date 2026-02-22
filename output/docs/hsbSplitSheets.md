# hsbSplitSheets

Distributes sheets or beams across an element zone using user-defined split points, expanding outward from a base point in all four directions.

---

## Overview

**hsbSplitSheets** generates a grid-based panel layout within a wall, floor, or roof zone. You select a reference sheet to define the target zone, pick a starting point, and optionally add split points where panels should be divided. The tool fills the zone in all four directions from the base point, creating regularly spaced sheets that respect the zone boundary and openings. Results can be output as either sheets or beams.

---

## Environment

| Property | Value |
|----------|-------|
| Type | O-Type (Object) |
| Works In | Model Space |
| Version | 1.8 |
| Requires | A sheet assigned to an element |

---

## Prerequisites

1. An element (wall, floor, or roof) must exist in the drawing.
2. At least one sheet must be present in the target zone for zone selection.
3. The sheet must belong to an element group.

---

## Usage

### Step 1: Select Target Zone
When prompted, click on an existing sheet in the zone you want to panel. The tool reads zone properties (thickness, material, dimensions, gap) from this sheet.

**Prompt:** "Select a sheet of desired zone"

### Step 2: Set Base Point
Click to define the origin for the distribution. The sheet grid expands outward from this point.

**Prompt:** "Select first distribution point"

> If the current UCS Z-axis is parallel to World Z, the base point is automatically projected onto the element plane.

### Step 3: Add Split Points (Optional)
Add points where sheets should be divided. Press Escape or Enter to finish.

**Prompt:** "Select additional distribution point (optional)"

### Step 4: Preview and Adjust
A gray 3D preview shows the proposed layout. Adjust parameters in the Properties Palette; the preview updates automatically. A crosshair marker indicates the base point.

### Step 5: Execute
Right-click and choose **Create Sheets** or **Create Beams** from the context menu. All existing sheets in the zone are removed and replaced with the new distribution. The tool instance deletes itself after execution.

Double-clicking the tool also triggers execution.

---

## Parameters

### Compose Rule

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Source | Dropdown | Zone contour | Boundary source: **Zone contour** uses the element net profile; **Generated sheets** merges existing sheet outlines (respecting openings) |
| Merge Gap | Length | 10 mm | Tolerance for closing small gaps when merging existing sheets |
| Target Object | Dropdown | Sheets | Output type: **Sheets** or **Beams** |
| Zone | Integer | Auto | Zone index (-5 to 5); set automatically from the selected sheet |

### Geometry

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Width | Length | 1250 mm | Standard panel width (horizontal direction) |
| Length | Length | 3000 mm | Standard panel length (vertical direction) |
| Thickness | Length | Auto | Read from zone height; editable |
| Gap | Length | 10 mm | Spacing between adjacent panels |

### Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Material | String | Auto | Material code; inherited from zone |
| Label | String | Empty | Primary label for generated objects |
| Sublabel | String | Empty | Secondary label |
| Grade | String | Empty | Material grade designation |

> When the zone defines variables for `width`, `height sheet`, and `gap`, these values are automatically applied on insertion.

---

## Context Menu

| Command | Description |
|---------|-------------|
| **Create [Sheets/Beams]** | Executes the distribution, replacing all existing zone sheets. Label reflects current Target Object setting. |
| **Add Split Points** | Opens point selection to add additional division locations to the existing layout. |

---

## Tips

- Place split points at opening edges so panel joints align with windows and doors.
- Use **Generated sheets** as source when you want to redistribute panels while preserving a custom zone boundary that differs from the net contour.
- Panels smaller than 1 mm squared (sheets) or 1 mm cubed (beams) are automatically filtered out.
- Generated objects inherit the zone color, material, label, sublabel, and grade you specify.
- Increase **Merge Gap** when combining existing sheets that have small gaps between them.
- The tool supports catalog-based insertion: properties can be preset through a catalog key.

---

## FAQ

**Q: Why does the tool disappear after I click Create?**
A: This is by design. The tool acts as a temporary layout calculator and removes itself after generating the final geometry.

**Q: What is the difference between Sheets and Beams output?**
A: Sheets are 2D panel objects with thickness (OSB, plywood). Beams are volumetric 3D solids suitable for CLT or mass timber workflows.

**Q: Can I add more split points after the initial placement?**
A: Yes. Right-click the tool and select **Add Split Points** to enter additional division locations.

---

## Related Scripts

- **hsbSheetDistribution** -- Alternative sheet layout approach
- **hsbRedistributeSheets** -- Redistribute existing sheets
- **hsbSplitSheets** works within the element/zone framework alongside standard sheeting tools
