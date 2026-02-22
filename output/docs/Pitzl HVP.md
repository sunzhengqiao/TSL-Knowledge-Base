# Pitzl HVP Connector

## Overview

| Property | Value |
|----------|-------|
| Script Name | Pitzl HVP |
| Type | T (Tool) |
| Version | 2.3 (30.11.2023) |
| Category | Hardware Connector |
| Keywords | connector, pitzl, beam |
| Required Beams | 2 |

## Description

This TSL creates Pitzl HVP connectors between two beams. The HVP (HolzVerbinderPitzl) is an aluminum timber connector system designed for joining secondary beams (joists) to main beams (headers) in timber construction.

The script supports both single HVP connectors and Double HVP configurations for higher load capacities. Multiple families are available ranging from small (880) to extra-extra-large (885) sizes.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates 3D bodies and applies tooling to beams in the model |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites

- **Required Entities**: 2 non-parallel beams (GenBeam or Beam)
- **Minimum Beam Count**: 2
- **Required Settings Files**: None (uses internal article data)

## Supported Connector Families

| Family Code | Description | Article Examples |
|-------------|-------------|------------------|
| 880 | Extra Small (XS) | 88004, 88006, 88008, 88010 |
| 881 | Small (S) | 88107, 88109, 88111, 88113, 88115 |
| 882 | Medium (M) | 88210, 88214 |
| 883 | Large (L) | 88318, 88322 |
| 884 | Extra Large (XL) | 88420, 88425, ... 88460 |
| 885 | XXL | 88540, 88545, ... 88560 |
| Double_882 | Double Medium | 88210.2, 88214.2 |
| Double_883 | Double Large | 88318.2, 88322.2 |
| Double_884 | Double XL | 88420.2 ... 88460.2 |

## Usage Workflow

### Insertion Methods

**Method 1: Standard Insertion (with Dialog)**
1. Execute command: `^C^C(hsb_scriptinsert "Pitzl HVP")`
2. First dialog: Select the connector family/type
3. Second dialog: Configure all properties
4. Select male beam(s) - the beam that will be cut
5. Select female beam(s) - the receiving beam
6. Connectors are automatically placed at beam intersections

**Method 2: Catalog Insertion (without Dialog)**
1. Execute command with execute key: `^C^C(hsb_scriptinsert "Pitzl HVP" "880-Vorgabe")`
2. Format: `<Family>-<CatalogName>` (separator: "-", "_", ";", etc.)
3. If catalog entry exists: Settings are applied automatically, no dialog shown
4. If catalog entry doesn't exist: Only the second dialog is shown (family is preset)
5. Select beams as above

### Key Concepts

- **Male Beam**: The beam that gets cut/notched; typically the secondary beam (joist)
- **Female Beam**: The main beam (header) that receives the connector
- **Milling Option**: Determines how the connector housing is cut into the beams

## Properties Panel Parameters

### Type Category

| Parameter | Type | Values | Description |
|-----------|------|--------|-------------|
| Type | String | 880, 881, 882, 883, 884, 885, Double_882, Double_883, Double_884 | Connector family/type |
| Article | String | e.g., 88004, 88107, etc. | Specific article number (auto-filtered by beam size) |
| Screw Length | Double | 50-200mm (family dependent) | Length of screws used for fastening |

### Tooling Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Milling | String | None | Defines which beam gets the housing: None, Male beam, Female beam, Both |
| Milling tolerance | Double | 1mm | Extra width allowance for housing pocket |
| Shadow Gap | Double | 1-3mm (family dependent) | Gap width when connector is recessed |
| Tool Shape | String | not rounded | Rounding type: not rounded, round, relief, rounded with small diameter, etc. |
| Milling depth in male beam | Double | 4mm | Depth of housing in male beam (4mm = ground plate thickness) |

### Position Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Offset Lateral | Double | 0 | Lateral offset of connector position |
| Offset Vertical | Double | 0 | Vertical offset of connector position |

## Context Menu Options

| Menu Item | Description |
|-----------|-------------|
| Set catalog entry | Creates a catalog entry from the current property values for reuse |

## Technical Specifications by Family

### Type 880 (XS)
- Connector Width: 25mm
- Connector Thickness: 12mm
- Connector Heights: 40, 60, 80, 100mm
- Screw Diameter: 4.5mm
- Screw Lengths: 50, 60, 70, 80mm
- Screw Count: 6, 8, 10, 12 (total)

### Type 881 (S)
- Connector Width: 40mm
- Connector Thickness: 12mm
- Connector Heights: 70, 90, 110, 130, 150mm
- Screw Diameter: 4.5mm
- Screw Lengths: 50, 60, 70, 80mm
- Screw Count: 10, 14, 16, 18, 22 (total)

### Type 882 (M)
- Connector Width: 60mm
- Connector Thickness: 12mm
- Connector Heights: 100, 140mm
- Screw Diameter: 5mm
- Screw Lengths: 60, 80, 100mm
- Screw Count: 18, 24 (total)

### Type 883 (L)
- Connector Width: 80mm
- Connector Thickness: 12mm
- Connector Heights: 180, 220mm
- Screw Diameter: 5mm
- Screw Lengths: 60, 80, 100mm
- Screw Count: 34, 44 (total)

### Type 884 (XL)
- Connector Width: 120mm
- Connector Thickness: 20mm
- Connector Heights: 200-600mm (9 sizes)
- Screw Diameter: 8mm
- Screw Lengths: 160, 180, 200mm
- Screw Count: 16-48 (total)

### Type 885 (XXL)
- Connector Width: 140mm
- Connector Thickness: 20mm
- Connector Heights: 400-600mm (5 sizes)
- Screw Diameter: 8mm
- Screw Lengths: 160, 180, 200mm
- Screw Count: 40-64 (total)

## Error Messages and Validation

The script performs automatic validation and displays warnings:

| Condition | Message/Action |
|-----------|----------------|
| Connector upside down | "Connector is upside down oriented" - Change axis orientation |
| Connector sideways | "Connector is sideward orientated" - Change axis orientation |
| Beam width too small | "Connector is not possible for this beam width" - Select smaller type |
| Screw too long for beam | "Connector with screw length is not possible for this beam width" |
| Milling not possible | "Connector can't be milled into the female beam" - Select other milling option |

## Hardware Export

The script exports hardware component data for BOM and CNC:

- **Connector**: HVP [Article Number]
  - Category: Connectors
  - Manufacturer: Pitzl
  - Material: Aluminium

- **Screws**: [Diameter] x [Length]
  - Quantity: Based on article selection
  - Category: Connectors
  - Manufacturer: Pitzl
  - Material: Steel

## Tips and Best Practices

1. **Beam Selection Order**: Always select male beams (secondary/joists) first, then female beams (headers/main beams)

2. **Parallel Beams**: The script automatically skips parallel beam pairs - only non-parallel intersections receive connectors

3. **Catalog Creation**: Use the context menu "Set catalog entry" to save frequently used configurations for quick access

4. **Milling Options**:
   - "None": Connector sits between beams (requires gap)
   - "Male beam": Housing cut only in male beam
   - "Female beam": Housing cut only in female beam
   - "Both": Housing split between both beams

5. **Shadow Gap**: The shadow gap value cannot exceed the connector thickness; it will be automatically corrected if too large

6. **Tool Shape Note**: Due to machine restrictions, male beam milling is always "not rounded" regardless of the setting

7. **Minimum Distances**: The script automatically calculates minimum beam dimensions based on screw length and connector size

8. **Hyperlink**: Click the connector instance to access the Pitzl product documentation online (language-aware: EN/DE/FR)

## FAQ

**Q: Why did the Article number change automatically after I selected it?**
A: The script detected that the beam dimensions were incompatible with the manually selected article. It automatically adjusted to a suitable size.

**Q: How do I make the connector sit flush with the beam surface?**
A: Set the `Milling` property to `Male beam` or `Female beam` to create the necessary pocket. Set offsets to 0 to align with the intersection.

**Q: Can I move the connector after insertion?**
A: Yes, you can use standard AutoCAD Move commands. Alternatively, adjust the `Offset Lateral` and `Offset Vertical` properties in the Properties Palette for precise positioning.

## Related Resources

- Manufacturer Website: https://www.pitzl-connectors.com
- Product Page: https://www.pitzl-connectors.com/en/products/verbinder/cat/hvp/
