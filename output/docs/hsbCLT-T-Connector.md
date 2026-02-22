# hsbCLT-T-Connector

## Overview

The **hsbCLT-T-Connector** creates a T-shaped metal connector for Cross-Laminated Timber (CLT) panels. This connector is used to join CLT panels at T-junctions, where one panel (the "male" panel) meets another panel (the "female" panel) perpendicularly. The script automatically creates the metal connector geometry, cuts a slot in the male CLT panel for insertion, and generates drill patterns for fastening.

| Property | Value |
|----------|-------|
| **Script Type** | Object (O-Type) |
| **Version** | 1.0 |
| **Author** | th@hsbCAD.de |
| **Date** | September 16, 2014 |
| **Requires Beams** | 0 |
| **Grip Points** | 0 |

## Purpose

This tool is designed for timber structure designers who need to create structural connections between CLT panels at T-junctions. It automates the following tasks:

- Creates a T-shaped metal plate geometry
- Cuts a precise slot in the male CLT panel to receive the connector
- Generates drill hole patterns for fastener installation
- Optionally stretches the male panel edge to meet a perpendicular female panel

## Environment

| Setting | Value |
|---------|-------|
| **Workspace** | Model Space |
| **Context** | CLT panel connections and assemblies |
| **Drawing Units** | Millimeters (mm) |
| **DXA Output** | Enabled |
| **ImplInsert** | Enabled |

## Prerequisites

Before using this tool, ensure the following:

1. **Male CLT Panel Required:** At least one CLT panel (SIP) must exist in the drawing to serve as the "male" panel. This is the panel that will receive the slot cut.

2. **Female CLT Panel (Optional):** A second non-parallel CLT panel can be selected as the "female" panel for automatic stretching functionality.

3. **Edge Proximity:** Position your insertion point at or near the edge where you want the connector placed.

## Usage

### Step-by-Step Insertion Workflow

1. **Launch the script** from the hsbCAD menu or toolbar

2. **Configure Settings:** If not using a catalog key, a configuration dialog will appear allowing you to set initial parameters

3. **Select the Male CLT Panel:** Click on the primary panel where the slot will be cut. This panel must be a valid SIP (Structural Insulated Panel)

4. **Optionally Select the Female CLT Panel:** If you want to enable automatic panel stretching:
   - Click on a second panel that is NOT parallel to the male panel
   - Press Enter to skip this step if stretching is not needed

5. **Pick the Insertion Point:** Click near the edge where you want the connector located. The script automatically identifies the nearest edge and positions the connector accordingly

### Command Prompts

| Prompt | Description |
|--------|-------------|
| "Select male CLT Panel" | Required selection of the primary panel |
| "Select female CLT Panel (optional)" | Optional selection for stretching functionality |
| Point selection | Click to place the connector |

### Automatic Behaviors

| Behavior | Description |
|----------|-------------|
| **Edge Detection** | The script finds the closest edge to your insertion point |
| **Slot Cutting** | A slot is automatically cut into the male panel to accommodate the connector |
| **Panel Stretching** | If a female panel is selected and is perpendicular, the male panel edge is stretched to meet it |
| **Drill Pattern** | Holes are drilled through both the connector and the CLT panel for fastening |
| **Group Assignment** | The connector is automatically assigned to group 'I' of the male panel |

## Parameters

Parameters are organized into categories and accessible via the AutoCAD Properties Palette (OPM).

### Geometry

These parameters define the physical dimensions of the T-shaped metal connector.

| Parameter | Default | Range | Description |
|-----------|---------|-------|-------------|
| **Length** | 300 mm | > 0 | Overall length of the T-connector along the panel edge |
| **Width** | 100 mm | > 0 | Width of the connector base (horizontal flange that extends outward) |
| **Height** | 215 mm | > 0 | Height of the connector (vertical portion that inserts into the slot) |
| **Thickness** | 10 mm | > 0 | Metal plate thickness of the connector |

### Location

These parameters control the positioning of the connector relative to the panel.

| Parameter | Default | Description |
|-----------|---------|-------------|
| **Edge Offset** | 40 mm | Distance from the panel edge to the connector position. Positive values move the connector inward from the edge |
| **Center Offset** | 0 mm | Offset along the panel thickness direction (Z-axis) for fine-tuning placement. Use for connectors that need to be centered or offset from the panel centerline |

### Slot

These parameters control the clearance between the connector and the slot cut into the CLT panel. Proper gap settings ensure the connector can be inserted during assembly.

| Parameter | Default | Description |
|-----------|---------|-------------|
| **Gap X** | 10 mm | Clearance in the length direction (along the panel edge). Larger values allow more tolerance |
| **Gap Y** | 1 mm | Clearance in the height direction (connector insertion depth). Minimal gap for tight fit |
| **Gap Z** | 1 mm | Clearance in the thickness direction (panel thickness). Minimal gap for alignment |

**Slot Formula:** The slot dimensions are calculated as:
- Slot Length = Connector Length + (2 x Gap X)
- Slot Height = Connector Height + Gap Y
- Slot Width = Connector Thickness + (2 x Gap Z)

### Drill Pattern

These parameters control the fastener hole pattern on the connector.

| Parameter | Default | Range | Description |
|-----------|---------|-------|-------------|
| **Diameter** | 14 mm | > 0 | Diameter of the drill holes for fasteners. Must match your fastener specifications |
| **Rows** | 5 | >= 1 | Number of rows in the drill pattern (vertical direction) |
| **Offset Row** | 42 mm | > 0 | Spacing between adjacent rows |
| **Columns** | 5 | >= 1 | Number of columns in the drill pattern (horizontal direction) |
| **Offset Column** | 42 mm | > 0 | Spacing between adjacent columns |
| **Pattern Mode** | 1 Pattern | 1 or 2 | Select "1 Pattern" for a single centered pattern, or "2 Patterns" for mirrored patterns on both sides of the connector |
| **Pattern Offset X** | 0 mm | >= auto | Horizontal offset for pattern positioning. In 2-pattern mode, this value is auto-corrected if too small |
| **Pattern Offset Y** | 0 mm | any | Vertical offset for pattern positioning |

**Pattern Mode Details:**
- **1 Pattern:** Creates a single centered drill pattern. Best for standard connections
- **2 Patterns:** Creates two mirrored patterns on opposite sides of the connector. Best for heavy-load applications requiring more fasteners

**Auto-Correction:** When using 2-pattern mode, if Pattern Offset X is too small, it is automatically adjusted to: `((Columns - 1) / 2 + 0.5) x Offset Column`

## Menu Options

This script supports catalog-based insertion for standardized configurations:

| Trigger | Behavior |
|---------|----------|
| **Execute Key Present** (`_kExecuteKey` is set) | Automatically loads predefined property values from the catalog |
| **No Execute Key** | Displays configuration dialog on insertion for manual parameter setting |

## Tips and Best Practices

### Panel Selection

1. **Selection Order Matters:** Always select the male panel first. The male panel is the one that receives the slot cut. The second (female) panel should be perpendicular to the male panel.

2. **Edge Selection:** Click your insertion point close to the intended edge. The script calculates the distance to all panel edges and selects the nearest one. Greater accuracy in clicking results in more predictable placement.

### Panel Stretching

3. **Using Female Panel Stretching:** When you select a second (female) panel:
   - The female panel must NOT be parallel to the male panel
   - The female panel's Z-axis must be parallel to the insertion edge normal
   - The male panel edge will stretch to meet the female panel
   - This creates tight, precise T-junctions

4. **Multiple Connectors:** Each connector tracks which edge it was placed on. Multiple connectors can be placed on different edges of the same panel without interfering with each other's stretching behavior.

### Pattern Configuration

5. **Pattern Mode Selection:**
   - Use "1 Pattern" for standard connections with fasteners centered on the connector
   - Use "2 Patterns" for heavier loads or larger connectors requiring fasteners on both sides
   - The auto-correction feature prevents overlapping patterns in 2-pattern mode

6. **Drill Hole Planning:** Ensure the drill pattern fits within your connector dimensions. Consider:
   - Pattern Width = (Columns - 1) x Offset Column
   - Pattern Height = (Rows - 1) x Offset Row
   - Verify these values fit within the connector Length and Height

### Gap Settings

7. **Manufacturing Tolerances:** The default gap values provide reasonable clearance for typical manufacturing tolerances:
   - Increase gap values if you need more tolerance for site installation
   - Decrease them for tighter fits (not recommended for manufacturing)
   - Gap X (10mm) is larger to allow insertion clearance
   - Gap Y and Z (1mm each) are minimal for alignment precision

### Visualization

8. **Connector Color:** The connector is displayed in color 252 (light gray) for visibility. This helps distinguish it from CLT panels during design review.

9. **Modifying After Placement:** All parameters can be adjusted in the Properties Palette after placement. The connector, slot, and drill pattern will automatically update when you change any parameter.

## Troubleshooting

| Problem | Possible Cause | Solution |
|---------|---------------|----------|
| Script erases immediately | No CLT panel selected | Ensure you select a valid SIP panel |
| "Unexpected error" message | Cannot identify valid edge | Click closer to an actual panel edge |
| Panel does not stretch | Female panel is parallel to male | Select a non-perpendicular panel |
| Connector in wrong position | Insertion point far from intended edge | Click closer to the target edge |
| Patterns overlap in 2-pattern mode | Pattern Offset X too small | Value is auto-corrected; adjust manually if needed |

## Technical Details

### Script Behavior

- **Recalculation:** The script recalculates automatically when any parameter changes or when linked panels move
- **Slot Direction:** The slot is cut in the -Z direction from the insertion point, with the slot normal in the -Y direction
- **Drill Pattern Origin:** The drill pattern starts at the lower portion of the connector's vertical section

### Dependencies

- The connector is automatically set to erase and copy with the associated beam/group
- The script assigns itself to group 'I' of the male panel for organizational purposes

## Related Scripts

| Script | Description |
|--------|-------------|
| hsbCLT-X-Fix-Connector | X-shaped connector for CLT panels |
| hsbCLT-X-Fix-C | C-shaped connector variant |
| hsbCLT-Slot | General slot cutting tool for CLT |
| hsbCLT-Pocket | Pocket creation for CLT panels |
