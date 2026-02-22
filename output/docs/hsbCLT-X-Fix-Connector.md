# hsbCLT-X-Fix-Connector

Creates X-Fix connectors between Cross-Laminated Timber (CLT) panels.

---

## Overview

The hsbCLT-X-Fix-Connector tool places X-Fix mechanical connectors at the junction between two CLT panels. X-Fix connectors are dovetail-shaped fasteners manufactured by Greenethic that create strong, invisible connections between panel edges. The tool supports two connector models (C70 and C90) with different penetration depths, and can automatically distribute multiple connectors along the joint edge based on spacing parameters.

This tool is designed for:
- Connecting adjacent CLT panels along their edges
- Splitting a single panel and inserting connectors at the split line
- Wall-based CLT constructions where panels need to be joined

---

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary workspace for CLT panel connections |
| Paper Space | No | |
| Shop Drawing | No | |

- **Script Type**: Object (O-Type)
- **Beams Required**: 0 (works with SIP/CLT panels)
- **Associativity**: Fully associative - connectors update automatically when linked panels move or change

---

## Prerequisites

Before using this tool:
1. Have at least two CLT panels (SIP entities) in your model that share a common edge, OR
2. Have a single CLT panel that you want to split and connect, OR
3. Have an Element (wall/floor/roof) containing CLT panels

---

## Usage

### Insertion Workflow

1. **Start the command** by inserting the TSL (TSLINSERT command, select hsbCLT-X-Fix-Connector)

2. **Select panels**: Choose one of the following methods:

   **Scenario A: Connect two existing panels (Standard Mode)**
   - Select 2 or more SIP panels that are aligned edge-to-edge
   - The connectors will be automatically generated along all detected joints

   **Scenario B: Split and Connect (Split Mode)**
   - Select 1 SIP panel
   - **Command Line**: "Select first point on split axis" - Click a point on the panel
   - **Command Line**: "Select second point on split axis" - Click a second point
   - The panel is split into two, and connectors are applied to the new joint

   **Scenario C: Wall/Element Mode**
   - Press Enter to skip panel selection
   - Select a Wall/Floor/Roof Element
   - Click a point on the element to define the connector location
   - The tool will detect existing CLT panels in the element and create connectors at split locations

3. **Adjust parameters** in the Properties Palette as needed

### Double-Click Behavior

Double-clicking an existing X-Fix connector toggles the alignment between Reference Side and Opposite Side.

---

## Parameters

The following parameters are available in the AutoCAD Properties Palette (OPM):

### Type Category

| Parameter | Default | Description |
|-----------|---------|-------------|
| **(A) Type** | X-fix C70 | Connector model selection. Options: **X-fix C70** (70mm depth) or **X-fix C90** (90mm depth) |

### Distribution Category

| Parameter | Default | Description |
|-----------|---------|-------------|
| **(B) Offset 1** | 200 mm | Distance from the start of the edge to the first connector. Cannot be negative (automatically corrected to 0). |
| **(C) Offset 2** | 200 mm | Distance from the end of the edge to the last connector. Cannot be negative (automatically corrected to 0). |
| **(D) Interdistance** | 1000 mm | Maximum spacing between connectors. The tool calculates the actual quantity to evenly distribute connectors. Minimum: 110 mm (resets to 1000mm if lower). |

### General Category

| Parameter | Default | Description |
|-----------|---------|-------------|
| **(E) Alignment** | Reference Side | Which face of the panel to place connectors on. Options: **Reference Side** or **Opposite Side**. |

### Reference Side Category

| Parameter | Default | Description |
|-----------|---------|-------------|
| **(F) Chamfer** | 0 mm | Chamfer size (45-degree) on the reference side of the panel edge. |

### Opposite Side Category

| Parameter | Default | Description |
|-----------|---------|-------------|
| **(G) Chamfer** | 0 mm | Chamfer size (45-degree) on the opposite side of the panel edge. |

---

## Context Menu

Right-click on an X-Fix connector instance to access:

| Menu Item | Description |
|-----------|-------------|
| **Recalc edge** | Recalculates the edge detection and redistributes connectors. Useful after panel geometry changes. |

---

## Tips

- **Connector quantity**: The tool automatically calculates how many connectors are needed based on the edge length and interdistance. If the edge is too short (less than Offset1 + Offset2 + 110mm), only one connector is placed at the center.

- **Grip points**: Two grip points appear at the start and end of the connector distribution zone. Drag these grips to adjust Offset 1 and Offset 2 visually.

- **Duplicate prevention**: The tool automatically detects if another X-Fix connector already exists on the same edge and will delete duplicates with a warning message.

- **Edge detection**: When placing connectors, the tool snaps to the nearest valid edge at the panel intersection. Move the insertion point to target a different edge.

- **Hardware output**: The tool supports hardware export. Connectors are categorized as "Connector" with manufacturer "Greenethic" and include model information (X-fix C70 or X-fix C90) with physical dimensions.

- **Visual display**: Connectors display differently based on viewing direction - a cross-shaped outline when viewed from above/below, and a profile view when viewed from the side.

- **Panel splitting**: When splitting a single panel, the split is permanent and creates two separate panels. The connector is then placed at the new joint. If the split operation fails, the tool will be deleted with a warning message.

- **Minimum spacing**: The interdistance cannot be less than 110mm due to the physical size of the X-Fix connector (approximately 65mm width on each side).

- **Coplanar requirement**: Selected panels must be coplanar and parallel for the connector to work properly. Non-coplanar panels are automatically excluded.

---

## FAQ

- **Q: The script failed when I tried to split a panel. Why?**
  - A: The split line might result in a geometry that cannot be processed, or it was outside the panel bounds. The script will delete itself if the split operation fails.

- **Q: Why did my spacing change to 1000mm automatically?**
  - A: The Interdistance value must be greater than 110mm to fit the tool geometry. If you entered a lower value, the script resets it to the default 1000mm.

- **Q: How do I switch the connector to the other panel face?**
  - A: Use the Alignment property in the Properties Palette or simply double-click the script instance in the model to toggle the reference side.

- **Q: Why was my connector deleted with a message about another connector?**
  - A: The tool prevents duplicate connectors on the same edge. If a connector already exists at that location, the new one is automatically removed.

---

## Version History

| Version | Date | Notes |
|---------|------|-------|
| 1.6 | 2024-12-05 | Added graphics output for hsbView rendering |
| 1.5 | 2017-05-24 | Supplier name convention adjusted |
| 1.4 | 2017-05-24 | Fixed tool assignment on edges with tongue/groove or lap connections |
| 1.3 | 2017-04-03 | Added hardware output support |
| 1.2 | 2016-06-15 | Added chamfer functionality |
| 1.1 | 2016-04-11 | Changed tool to dovetail shape; removed lengthwise connector |
| 1.0 | 2016-03-16 | Initial release |
