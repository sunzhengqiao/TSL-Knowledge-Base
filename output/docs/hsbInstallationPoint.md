# hsbInstallationPoint

## Overview

The **hsbInstallationPoint** TSL script defines an electrical installation point with its associated combinations (electrical outlets, switches, junction boxes) on a wall element. It creates wire chases (vertical and horizontal routing channels) through the wall framing and manages the machining operations required for electrical conduit installation.

This script serves as the **parent controller** for electrical combination elements (**hsb-E-Combination**) and automatically generates:
- Vertical wire chases (milling cuts through studs)
- Horizontal wire chases (routing between combinations)
- No-nail zones in sheeting areas to prevent fastener penetration near conduits
- Drill holes at top and bottom plates for conduit passage
- Hardware component exports for material takeoffs (conduit lengths, diameters)

---

## Script Information

| Property | Value |
|----------|-------|
| **Script Type** | O (Object) |
| **Workspace** | Model Space |
| **Required Beams** | 0 (attaches to wall element) |
| **Major Version** | 13 |
| **Minor Version** | 8 |
| **Keywords** | Installation, Point, Electro |

---

## Prerequisites

The script requires the following components to function properly:

| Component | Location |
|-----------|----------|
| **hsb-E-Combination.mcr** | TSL script directory |
| **hsbElectricalTsl.dll** | `<hsbCAD>\utilities\ElectraTsl\` |
| **Block definitions** | `<hsbCompany>\Block\Electrical\` subdirectories |
| **Settings file** (optional) | `<hsbCompany>\TSL\Settings\hsbInstallationPointSettings.xml` |

---

## Step-by-Step Usage Guide

### Creating an Installation Point

1. **Start the command** by running `hsbInstallationPoint` from the TSL menu or command line

2. **Configure in the dialog**:
   - Select a catalog entry (predefined electrical configuration) or configure manually
   - Set machining parameters (width, depth, alignment)
   - Specify number of conduits for each side

3. **Select a wall** when prompted to "Select a wall"

4. **Choose insertion point(s)**:
   - Click a point on the wall surface
   - You can place multiple installation points on the same wall
   - Press Enter when done with current wall

5. **Continue or finish**:
   - Select another wall for additional installations, or
   - Press Enter to complete the command

### Adding Combinations (Outlets, Switches)

1. **Double-click** on an existing installation point, or
2. Right-click and select **Add Combination**
3. **Select a catalog entry** for the electrical device type
4. **Specify elevation**:
   - Enter a value in the dialog, or
   - Pick a point in the model to override the elevation
5. The combination is automatically linked and aligned

### Moving Between Wall Sides

| Command | Behavior |
|---------|----------|
| **Flip Side** | Moves installation point to opposite face; combinations remain in place |
| **Flip Side Combinations** | Moves installation point AND all combinations to opposite face |

### Reassigning to a Different Wall

1. Right-click and select **Assign to Wall**
2. Select the new wall element
3. Pick a point for the new insertion location
4. Room links are automatically released during reassignment

### Room Assignment

1. The script **automatically detects** rooms (AEC Space or hsbRaum TSL) at insertion
2. To manually assign: Right-click > **Assign to Room** > Select the room entity
3. To release: Right-click > **Release from Room**
4. Room data is used for:
   - Floor thickness calculation
   - Hardware export organization
   - Room number/level tagging in reports

---

## Properties Panel Parameters

### Machining (Icon Side)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Alignment** | Dropdown | Both | Wire chase direction: None, Bottom, Top, or Both |
| **Width** | Length | 60 mm | Width of the wire chase milling |
| **Depth** | Length | 27 mm | Depth of wire chase (typically equals conduit diameter) |
| **Conduits** | Integer | 0 | Number of conduit cables (0-10) |

### Machining Opposite Side

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Alignment** | Dropdown | None | Wire chase direction on opposite wall face |
| **Width** | Length | 60 mm | Width of opposite side milling |
| **Depth** | Length | 27 mm | Depth of opposite side conduit |
| **Conduits** | Integer | 0 | Number of conduit cables on opposite side |

### Machining Sheeting

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **bottom** | Yes/No | No | Add extra tool at bottom sheeting (icon side) |
| **top** | Yes/No | No | Add extra tool at top sheeting (icon side) |
| **Opposite Side bottom** | Yes/No | No | Add extra tool at bottom (opposite side) |
| **Opposite Side top** | Yes/No | No | Add extra tool at top (opposite side) |

### Display

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Dimstyle** | Dropdown | First available | Dimension style for text labels |
| **Text Height** | Length | 40 mm | Overrides text size of selected dimension style |
| **Color** | Integer | 1 | Display color index for installation graphics |

---

## Right-Click Context Menu Commands

| Command | Description |
|---------|-------------|
| **Flip Side** | Moves installation to opposite wall face; combinations stay in original positions |
| **Flip Side Combinations** | Moves installation AND all combinations to opposite face; position indices inverted |
| **Assign to Wall** | Reassigns to a different wall element; releases room links |
| **Copy Installation** | Creates complete copy with all combinations on another wall/location |
| **Move Wirechase** | Relocates wirechase tooling horizontally without moving installation point |
| **Add Combination** | Opens dialog to add new electrical combination (outlet, switch, etc.) |
| **Align Combination Symbols** | Reorders and aligns symbols by elevation in plan view |
| **Edit plan view symbol offset** | Adjusts spacing scale factor between symbols in plan view |
| **Override Conduit Diameter** | Sets custom nominal diameters for icon/opposite side (0 = no override) |
| **Assign to Room / Release from Room** | Links/unlinks to AEC Space or hsbRaum room object |
| **Set floor thickness** | Manually specify floor thickness when no room assigned |

---

## Wire Chase Direction (Alignment)

| Mode | Behavior |
|------|----------|
| **None** | No vertical wire chase created |
| **Bottom** | Wire chase extends from floor level up to first combination |
| **Top** | Wire chase extends from last combination to ceiling |
| **Both** | Wire chase runs the full height of the wall |

---

## Settings Configuration

The script reads settings from `hsbInstallationPointSettings.xml` in `<hsbCompany>\TSL\Settings\`.

### Display Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `IconSideColor` | Integer | 3 (Green) | Color index for icon side graphics |
| `OppositeSideColor` | Integer | 4 (Cyan) | Color index for opposite side graphics |
| `DrawWirechaseOutline` | Integer | 1 | Draw wire chase outline in element view |
| `DrawPlanConduits` | Integer | 1 | Draw conduit symbols in plan view |
| `DrawRoomAlert` | Integer | 1 | Show "Room ?" alert when no room linked |

### Wire Chase Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `ExtentWirechase` | Integer | 0 | Extend wire chase fully through last combination |
| `ExtentWirechaseOffset` | Length | 0 | Additional extension length |
| `ConduitExtraDepth` | Length | 0 | Additional depth for all conduit millings |
| `ConduitExtraWidth` | Length | 0 | Additional width for all conduit millings |
| `WirechaseNoNail` | Integer | 1 | No-nail zone generation mode |

### Group Assignment Settings

| Parameter | Type | Description |
|-----------|------|-------------|
| `Group` | String | Additional group name (e.g., "Electro") |
| `GroupElement` | String | Third-level group subdivision |

### Advanced Settings (InstallationPoint Subsection)

| Parameter | Type | Description |
|-----------|------|-------------|
| `UseGenbeamReference` | Integer | Project reference point onto beam envelope (0=outline, 1=genbeam) |
| `VerticalTool[]` | Map | Custom drill settings for top/bottom plates |
| `SkewedMilling` | Map | Settings for angled milling at bottom plate |

### Vertical Tool Configuration

| Parameter | Type | Description |
|-----------|------|-------------|
| `Alignment` | Integer | -1 = bottom plate, 1 = top plate |
| `Diameter` | Length | Drill diameter |
| `Offset` | Length | Offset from beam edge |
| `depth` | Length | Drill depth (0 = use zone height) |
| `ExtraDepth` | Length | Additional depth beyond zone |
| `ToolIndex` | Integer | CNC tool index for output |

---

## Display Representations

The script generates graphics for different view types:

| View Type | Display Content |
|-----------|-----------------|
| **Element View** | Wire chase outline, conduit lines, device symbols |
| **Plan View** | Symbol blocks with optional conduit circles |
| **3D View** | Reference line from insertion point to wall face |

### Color Coding

| Condition | Color | Meaning |
|-----------|-------|---------|
| Icon side milling only | Green (3) | Installation facing user |
| Opposite side milling only | Cyan (4) | Back side of wall |
| Both sides | ByBlock (0) | Milling on both faces |
| Custom project (Lux) | Magenta (6) | Opposite side in custom mode |

---

## Hardware Export

The script generates hardware components for material takeoffs:

| Category | Component | Properties |
|----------|-----------|------------|
| Electrical | Conduit DN[diameter] | Length = wire chase length x conduit count |

Export includes:
- Room number or "Exterior Installation" designation
- Element number reference
- Conduit nominal diameter (DN20, DN25, DN32, or custom override)

---

## Automatic Features

### Room Detection

- Automatically finds AEC Space or hsbRaum entities in the same floor group
- Derives floor thickness from room properties
- Supports property sets: "Höhe_Fußboden", "Raum-Nummer", "Etage"

### Symbol Alignment

- Automatically sorts combination symbols by elevation during insertion
- Separate sorting for each wall side (icon vs. opposite)

### Wall Split Handling

- Automatically reassigns to closest wall element when walls are split
- Preserves child combination relationships

### No-Nail Zone Generation

Creates protection zones in sheeting layers to prevent fastener penetration near conduits:
- Mode 1: All intersecting beams generate no-nail areas
- Mode 2: Icon side horizontal beams only

---

## Tips and Best Practices

### Efficient Workflow

1. **Room Assignment First**: Assign rooms before adding combinations for accurate elevation references
2. **Catalog Usage**: Create catalog entries for common configurations to speed up insertion
3. **Batch Insertion**: Place multiple installation points on one wall before pressing Enter
4. **Symbol Alignment**: Use "Align Combination Symbols" after manual editing to clean up plan view

### Conduit Sizing

- Width should accommodate: Number of Conduits x (Depth + Extra Width)
- Minimum milling width: 50 mm
- The script automatically calculates width when conduits are changed

### Troubleshooting

| Issue | Solution |
|-------|----------|
| "Room ?" alert displayed | Assign room or set custom floor thickness |
| Combinations not visible | Check display representation settings |
| Wire chase not cutting beams | Set Alignment to Bottom, Top, or Both |
| Multiple rooms detected | Manually select the correct room |
| Symbols overlapping | Run "Align Combination Symbols" |

### Performance Notes

- Uses `envelopeBody()` instead of `realBody()` for better performance
- Zone filtering limits beam collection to relevant areas only
- Large numbers of combinations may require multiple recalculation loops

---

## Version History Highlights

| Version | Date | Description |
|---------|------|-------------|
| 13.8 | 07.02.2025 | Fix "ProjectSpecial" handling, beamcut face sharing |
| 13.7 | 04.02.2025 | Check when beamcuts share same face |
| 13.6 | 15.11.2024 | Code optimization, reduced envelopeBody usage |
| 13.4 | 22.03.2024 | Wall join reference handling |
| 13.3 | 11.07.2023 | Skewed milling support at bottom plate |
| 12.8 | 09.02.2021 | Offset value controls tooling offset |
| 12.7 | 08.02.2021 | Standard update procedure integration |

---

## Related Scripts

| Script | Relationship |
|--------|--------------|
| **hsb-E-Combination** | Child script for individual electrical devices |
| **hsbRaum** | Room definition TSL for automatic room detection |
| **hsbViewTag** | Custom annotation tags in views |

---

## Example Workflows

### Standard Electrical Installation

1. Insert hsbInstallationPoint on target wall
2. Select predefined catalog entry in dialog
3. Set Alignment to "Bottom" for floor-to-device routing
4. Configure Width/Depth based on conduit specifications
5. Set Conduits to number of cables required
6. Double-click to add combinations at appropriate elevations
7. Use "Align Combination Symbols" to organize plan view
8. Assign to room for proper floor height calculation

### Multi-Side Installation

1. Insert installation point on wall
2. Set Alignment to "Both" for wire chase on both wall faces
3. Configure Icon Side parameters for front face
4. Configure Opposite Side parameters for back face
5. Add combinations as needed for each side
6. Use "Flip Side" to verify opposite side placement

### Copying Installation to Another Wall

1. Select installation point
2. Right-click > "Copy Installation"
3. Select target wall
4. Click new position
5. All combinations are copied with proper relationships
