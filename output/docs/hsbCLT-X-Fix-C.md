# hsbCLT-X-Fix-C

## Overview
This script creates and distributes Greenethic X-Fix-C connectors along the common edge of two or more CLT (Cross-Laminated Timber) panels. It automatically detects shared edges between selected panels, calculates optimal connector placement, applies dovetail machining operations to both connected panels, and tracks hardware for bills of materials.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary working environment for CLT panel connections |
| Paper Space | No | Script is for 3D modeling only |

## Prerequisites
- At least two CLT panels (Sip entities) with a common edge, or one panel to be split
- Panels must be properly aligned with adjacent faces touching or slightly overlapping
- Optional: Settings file `hsbCLT-X-Fix-C.xml` in company or installation TSL Settings folder
- Required: `TslUtilities.dll` for dialog functionality

## Usage

### Standard Insertion (Multiple Panels)
1. Launch the script via command line (`TSLINSERT`) or tool palette
2. Configure properties in the dialog or select a catalog entry
3. Select two or more adjacent CLT panels when prompted with "Select panel(s)"
4. Click a second point to indicate the connection direction
5. Connectors are automatically distributed and tooling applied to both panels

### Single Panel Split Mode
1. Launch the script and select a single CLT panel
2. When prompted "Select first point on split axis", click on the panel
3. When prompted "Select second point on split axis", click to define the split line
4. The panel is split and connectors are placed along the new edge

### Edit in Place Mode
For precise individual connector positioning:
1. Right-click an existing X-Fix-C distribution
2. Select "Edit in Place" from context menu
3. Individual connectors are created that can be repositioned using grips
4. Use "Convert To Static" to finalize positioning and make connectors independent

## Parameters

### Type Category
| Parameter | Display Name | Type | Default | Description |
|-----------|--------------|------|---------|-------------|
| sType | Type | Dropdown | 96/130/45 R15 | Connector model selection. Available types: 96/130/45 R15, 96/130/65 R15, 96/130/90 R15, 96/130/130 R15. Types without "R15" suffix are deprecated and no longer manufactured. |
| dPDepth | Depth | Double | 0 mm | Additional depth beyond standard type depth for deeper embedment |

### Distribution Category
| Parameter | Display Name | Type | Default | Description |
|-----------|--------------|------|---------|-------------|
| dOffset1 | Offset 1 | Double | 200 mm | Distance from first panel edge to first connector center |
| dOffset2 | Offset 2 | Double | 200 mm | Distance from second panel edge to last connector center |
| dInterdistance | Interdistance/(Qty) | Double | 1000 mm | Spacing between connectors. Values below 110 mm are interpreted as quantity count. |
| sSide | Side | Dropdown | Reference Side | Panel face for connector placement (Reference Side / Opposite Side) |

**Distribution Logic:**
- Values >= 110 mm: Treated as center-to-center spacing between connectors
- Values < 110 mm: Treated as connector quantity (e.g., "5" places 5 evenly distributed connectors)
- Minimum interdistance constraint: 110 mm (based on connector width)

## Context Menu Commands

| Command | Description |
|---------|-------------|
| Add Panel(s) | Add additional panels to the connection group |
| Remove Panel(s) | Remove panels from the connection group |
| Edit in Place | Convert distribution to individual movable connectors (limited to 1 item) |
| Flip Alignment | Toggle connector alignment to opposite panel edge |
| Recalc Segments | Recalculate when panel geometry changes affect segment count |
| Convert To Static | Make Edit in Place connectors independent of panel geometry |
| Show Tooling / Hide Tooling | Toggle visibility of the machining solid representation |
| Import Settings | Load settings from XML configuration file |
| Export Settings | Save current settings to XML configuration file |

**Admin Commands** (visible only when instance color is set to red/1):
| Command | Description |
|---------|-------------|
| Set Tool Contour | Define custom shape and tooling contours for a connector type |

## Settings Files
- **Filename**: `hsbCLT-X-Fix-C.xml`
- **Locations**:
  - Company: `[hsbCompany]\TSL\Settings\`
  - Installation: `[hsbInstall]\Content\General\TSL\Settings\`
- **Purpose**: Stores connector type definitions, geometric dimensions, display colors, and automatic type selection rules

**Settings Structure:**
- Display: Color and text color settings
- Type[]: Array of connector definitions with Type, Depth, Shape, Tool contours
- ComponentName[]: Optional panel component names for automatic type selection

## Hardware Output

| Field | Value |
|-------|-------|
| Manufacturer | Greenethic |
| Category | Connector |
| Article Number | Type name (e.g., "96/130/45 R15") |
| Quantity | Total connectors in distribution |

Hardware data is attached to the CLT panel and exported to BOMs, hsbMake, and hsbShare.

## Tips and Best Practices

1. **Panel Selection Order**: The first selected panel determines the reference coordinate system and hardware grouping.

2. **Edge Detection**: Ensure panels touch or slightly overlap for proper edge detection. The script analyzes intersection profiles between panels.

3. **Multiple Segments**: For panels with openings near edges, the script automatically creates separate X-Fix-C instances for each disconnected edge segment.

4. **Deprecated Types Warning**: Types without the R15 suffix are legacy products no longer manufactured. A warning displays when selecting deprecated types.

5. **Quantity Mode**: For evenly distributed connectors, enter the desired count as a small number (e.g., "3" for three connectors).

6. **Settings Standardization**: Use Export Settings to save your company's preferred configurations, then share the XML file across projects.

7. **Automatic Type Selection**: Configure ComponentName[] in the settings XML for automatic type selection based on panel component names. This locks the Type parameter to prevent manual changes.

8. **CNC Export**: Tooling exports in Faro Laserscanner format (with tolerance settings) and standard hsbMake/hsbShare formats.

9. **Grip Adjustment**: In distribution mode, drag the grip points at first/last connector positions to adjust offsets visually.

10. **Admin Mode**: Set the instance color to red (1) to access "Set Tool Contour" for defining custom connector shapes.

## Version Information
| Property | Value |
|----------|-------|
| Current Version | 3.7 |
| Script Type | O (Object) |
| Keywords | CLT, Greenethic, Dove |
| Last Updated | 2025-02-06 |
