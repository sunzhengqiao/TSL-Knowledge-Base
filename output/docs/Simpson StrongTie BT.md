# Simpson StrongTie BT

## Overview

This script inserts and configures **Simpson Strong-Tie BT series concealed beam hangers** to connect timber beams (typically a joist to a carrier beam). It automatically generates the 3D metal connector, applies the necessary machining (slots, housings, and holes) to the wood members, and adds all components to the hardware bill of materials.

| Property | Value |
|----------|-------|
| **Script Type** | T (Tool) |
| **Version** | 2.9 (04.07.2023) |
| **Required Beams** | 2 (Male + Female) |
| **Category** | Connector / Fixture / Hanger |
| **Keywords** | Connector, Fixture, BMF, StrongTie, Simpson, Hanger |

## Script Metadata

| Header | Value |
|--------|-------|
| `#Version` | 8 |
| `#Type` | T (Tool) |
| `#NumBeamsReq` | 2 |
| `#MajorVersion` | 2 |
| `#MinorVersion` | 9 |
| `#DxaOut` | 1 (DXF output enabled) |
| `#ImplInsert` | 1 (Implicit insertion) |

### Version History

| Version | Date | Change Description |
|---------|------|-------------------|
| 2.9 | 04.07.2023 | HSB-19431: Depth slot corrected |
| 2.8 | 06.07.2022 | HSB-15932: Set hardware qty to 0 if dummy male beam |
| 2.7 | 21.12.2021 | HSB-14106: Display published for hsbMake and hsbShare |
| 2.6 | 30.06.2021 | HSB-12460: Instance assigned to I-Layer of female beam |
| 2.5 | 29.04.2021 | HSB-11734: Bugfix peg length |
| 2.4 | 04.11.2020 | HSB-9480: TU values decimal separator fix |
| 2.3 | 30.09.2020 | HSB-9036: Peg length fixed when height/width swapped |
| 2.2 | 16.09.2020 | HSB-8198: Added Jane-TU family |
| 2.1 | 28.07.2020 | HSB-8422: AdditionalNotes considered for posnum generation |
| 2.0 | 02.07.2020 | HSB-8182: Badge alignment corrected |

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| **Model Space** | Yes | Primary environment - for 3D model detailing |
| **Paper Space** | No | Not designed for layout or paper space |
| **Shop Drawing** | No | This is a model generation script, not a drawing generator |

## Prerequisites

- **Required Entities**: Two GenBeam entities
  - **Male Beam (Joist)**: The secondary beam that sits inside the hanger
  - **Female Beam (Carrier)**: The main support beam that holds the hanger
- **Minimum Beam Count**: 2
- **Required DLL**: `TslUtilities.dll` (for selection dialogs during insertion)

## Supported Product Families

| Family | Code | Description | Can Be Angled | URL Reference |
|--------|------|-------------|---------------|---------------|
| **BT** | BT | Standard concealed beam hangers | No | strongtie.de/products/detail/balkentrager/809 |
| **BT4** | BT4 | 4-hole concealed beam hangers | No | strongtie.de/products/detail/balkentrager/886 |
| **BTALU** | BTALU | Aluminum concealed beam hangers | No | strongtie.de/products/detail/balkentrager-alu/481 |
| **BTC** | BTC | Concrete concealed beam hangers | No | strongtie.de/products/detail/balkentrager/497 |
| **BTN** | BTN | Narrow concealed beam hangers | No | strongtie.de/products/detail/balkentrager/482 |
| **TU** | TU | Adjustable concealed beam hangers | **Yes** | strongtie.de/products/detail/balkentrager-tu/57 |

### Available Models by Family

#### BT Family (Standard)
| Model | Min Height (mm) | A (Height) | B (Width) | C (Thickness) |
|-------|----------------|------------|-----------|---------------|
| BT280 | 320 | 280 | 103 | 62 |
| BT320 | 360 | 320 | 103 | 62 |
| BT360 | 400 | 360 | 103 | 62 |
| BT400 | 440 | 400 | 103 | 62 |
| BT440 | 480 | 440 | 103 | 62 |
| BT480 | 520 | 480 | 103 | 62 |
| BT520 | 560 | 520 | 103 | 62 |
| BT560 | 600 | 560 | 103 | 62 |
| BT600 | 640 | 600 | 103 | 62 |

#### BT4 Family
| Model | Min Height (mm) | A (Height) | B (Width) | C (Thickness) |
|-------|----------------|------------|-----------|---------------|
| BT4-90 | 100 | 90 | 103 | 61 |
| BT4-120 | 160 | 120 | 103 | 61 |
| BT4-160 | 200 | 160 | 103 | 61 |
| BT4-200 | 240 | 200 | 103 | 61 |
| BT4-240 | 280 | 240 | 103 | 61 |

#### BTC Family (Concrete)
| Model | Min Height (mm) | A (Height) | B (Width) | C (Thickness) |
|-------|----------------|------------|-----------|---------------|
| BTC120 | 160 | 120 | 128 | 96 |
| BTC160 | 200 | 160 | 128 | 96 |
| BTC200 | 240 | 200 | 128 | 96 |
| BTC240 | 280 | 240 | 128 | 96 |
| BTC280 | 320 | 280 | 128 | 96 |
| ... | ... | ... | ... | ... |
| BTC600 | 640 | 600 | 128 | 96 |

#### TU Family (Angled Connections)
| Model | Min Height (mm) | A (Height) | B (Width) | C (Thickness) |
|-------|----------------|------------|-----------|---------------|
| TU12 | 100 | 96 | 97.5 | 40 |
| TU16 | 160 | 134 | 104.5 | 60 |
| TU20 | 200 | 174 | 104.5 | 60 |
| TU24 | 240 | 214 | 104.5 | 60 |
| TU28 | 280 | 254 | 104.5 | 60 |

## Usage Steps

### Step 1: Launch Script
```
Command: TSL (or TSLINSERT)
Action: Select "Simpson StrongTie BT.mcr" from the file dialog.
```

**Alternative Commands** (Direct Family Selection):
```
TSLCONTENT          - Opens script with default family
TSLCONTENT BT       - Opens with BT family pre-selected
TSLCONTENT BTC      - Opens with BTC (Concrete) family pre-selected
TSLCONTENT BTALU    - Opens with BTALU family pre-selected
TSLCONTENT BTN      - Opens with BTN family pre-selected
TSLCONTENT BT4      - Opens with BT4 family pre-selected
```

### Step 2: Select Male Beams
```
Command Line: Select male beams
Action: Click on the joist(s) or secondary beam(s) that will sit inside the hanger.
Note: You can select multiple male beams for batch insertion.
```

### Step 3: Select Female Beams
```
Command Line: Select female beam(s)
Action: Click on the carrier or support beam(s) that will hold the hanger.
Note: If you accidentally select a beam as both male and female, it will be automatically excluded from the female selection.
```

### Step 4: Select Family (if Dialog Appears)
```
Dialog: Family Selection
Action: Choose the product family (BT, BT4, BTALU, BTC, BTN, TU).
Note: This dialog appears if no family was specified in the command or if TslUtilities.dll is loaded.
```

### Step 5: Select Model
```
Dialog: Model Selection
Options: Automatic (default) or specific catalog size
Note: "Automatic" selects the appropriate model based on the male beam height.
```

### Step 6: Generation
The script automatically:
1. Creates the 3D metal connector body
2. Applies **Slot** machining to the male beam
3. Applies **House** (pocket) machining to both beams (if configured)
4. Drills **holes** for the through-bolts
5. Adds **markings** on the female beam (if configured)
6. Adds hardware components to the BOM

## Properties Panel Parameters (OPM)

### Model Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Family** | String | BT | Product family selection. Changing this resets Model to "Automatic". Options: BT, BT4, BTALU, BTC, BTN, TU |
| **Model** | String | Automatic | Specific catalog number. "Automatic" selects based on beam height. Read-only when beams are not perpendicular. |

### Alignment Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Axis Offset between double connector** | Double | 80 mm | Offset between double connectors. Must be >= 80mm for valid double connector usage. |
| **Offset Y** | Double | 0 mm | Lateral offset of the metal part in Y-direction. |
| **Offset Z** | Double | 0 mm | Vertical offset of the metal part in Z-direction. |

### Connecting Tool Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Type** | String | Female Beam | Defines which beam receives the housing cut. Options: Female Beam, Main Beam, Saw Cut |
| **Alignment** | String | Bottom | Location of the housing cut. Options: Bottom, Centered, Top |
| **Offset Screw Heads** | Double | 20 mm | Depth of the end beam lap or offset of the sawcut. |
| **Gap (X)** | Double | 2 mm | Additional depth of the beamcut. |
| **Gap (YZ)** | Double | 2 mm | Gap around the metal part of the beamcut. |

### Slot Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Alignment** | String | Top | Slot location on the male beam. Options: Top, Bottom, Full height |
| **Gap (X)** | Double | 20 mm | Additional length of the slot. |
| **Gap (Y)** | Double | 2 mm | Additional width of the slot. |
| **Gap (Z)** | Double | 20 mm | Additional height of the slot. |

### Drill Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Drill offset X** | Double | 1 mm | Moves drills in negative connection direction to create mounting tension. |
| **Drill Alignment** | String | Right | Controls drill hole orientation. Options: Right, Left, Complete Through |

### Marking Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Marking** | String | Marking | Type of marking on the female beam. Options: Marking, Marking and Description, Marking and PosNum, None, Marking Fastener |

## Right-Click Menu Options (Context Menu)

### Drill Controls

| Menu Item | Action |
|-----------|--------|
| **Flip Drill Face** | Rotates the drill hole alignment from Right to Left (or vice versa). Only available for single connectors. |
| **Cycle Drill Face** | Cycles through all three drill alignment options: Right -> Left -> Complete Through -> Right. Can also be triggered by double-clicking the connector. |
| **Drill not through** / **Drill complete through** | Toggles between blind hole and through-hole drilling. |

### Badge Display

| Menu Item | Action |
|-----------|--------|
| **Hide Badge** | Hides the 2D plan view representation of the connector. |
| **Show Badge** | Shows the 2D plan view representation (displays the model name with a leader line). |

### Mounting Location (Hardware Assignment)

| Menu Item | BOM Note | Description |
|-----------|----------|-------------|
| **Partial Assembly Plant** | "Partial Assembly Plant" | Connector to be installed at partial assembly stage. |
| **Plant** | "Plant" | Connector to be installed at factory/main plant. |
| **Construction Site** | "Construction Site" | Connector to be installed on-site. |

## Generated Hardware Components

The script adds the following components to the Bill of Materials:

### Main Component (Connector)
| Property | Value |
|----------|-------|
| **Article Number** | Model name (e.g., BT280) |
| **Category** | Connector |
| **Name** | Family (BT, BT4, etc.) |
| **Description** | Concealed Hanger |
| **Material** | S 250 GD +Z 275 |
| **Manufacturer** | Simpson StrongTie |
| **Quantity** | 1 (or 2 for double connectors) |

### Sub-Component (Peg/Bolt)
| Property | Value |
|----------|-------|
| **Article Number** | STD12x[L]-B (e.g., STD12x100-B) |
| **Category** | Fixtures |
| **Name** | Peg |
| **Description** | Peg 12x[Length] |
| **Material** | S 235 JR |
| **Length Options** | 60, 80, 100, 115, 120, 140, 160, 180, 200 mm (auto-selected based on beam width) |

### Sub-Component (Nails)
| Property | Value |
|----------|-------|
| **Article Number** | CNA4.0x50 |
| **Category** | Fixtures |
| **Name** | Nail |
| **Description** | Nail |
| **Material** | C9D |
| **Quantity** | Based on selected model (varies by connector size) |

## Double Connector Mode

The script automatically detects and enables **double connector mode** when:

1. The **Axis Offset between double connector** >= the connector thickness (C dimension)
2. The male beam width is sufficient (>= 2 x C)
3. The top edge of the male beam does not exceed the top edge of the female beam

**Double connector behavior:**
- Creates two mirrored metal parts
- Doubles the hardware quantities
- Halves the drill depth per side (unless drilling through)

### Requirements for Double Connectors
- Male beam width must be >= 160mm
- Top edge alignment constraint must be satisfied
- Offset between connectors must be >= 80mm

## Tips and Best Practices

### Quick Model Selection
- Use command-line shortcuts like `TSLCONTENT BT4` to skip the family selection dialog
- Select "Automatic" model to let the script choose the right size based on beam height

### Modifying Existing Connectors
- After insertion, change **Model** or **Family** directly from the Properties Palette (Ctrl+1)
- The connector will recalculate and resize automatically
- If a model is not valid for the current geometry, the script reverts to the last valid family

### Working with Dummy Beams
- If the male beam is a "Dummy" (placeholder) beam, the script automatically:
  - Sets connector quantity to 0 in the hardware list
  - Sets peg quantity to 0
  - Keeps the 3D geometry for visualization

### Drill Hole Adjustments
- If holes are drilling in the wrong direction, use **Cycle Drill Face** (or double-click)
- For angled connections, only the **TU** family supports non-perpendicular beams

### Visibility Management
- Use **Hide Badge** to reduce visual clutter in plan views
- Badge colors indicate mounting location: Green (Plant), Cyan (Construction Site), Yellow (Partial)

## Troubleshooting

### "Could not find a valid model"
**Cause**: The selected family does not have a model size appropriate for your beam height.
**Solution**:
- Select a different Family with larger models
- Check that the male beam height meets the minimum requirements

### "Beams must be perpendicular"
**Cause**: Most families require beams to meet at 90 degrees.
**Solution**: Use the **TU** family which supports angled connections.

### "The geometry of beam does not allow the usage of a double connector"
**Cause**: The male beam is too narrow or incorrectly positioned.
**Solution**:
- Ensure male beam width >= 160mm
- Align the top edges of both beams
- Reduce the connector offset if needed

### Dialog does not appear
**Cause**: `TslUtilities.dll` is not loaded or the entry was found in the catalog.
**Solution**:
- Ensure TslUtilities.dll is in your hsbCAD installation
- Check if a catalog entry exists for your selection (script uses catalog values if found)

### Hardware not appearing in BOM
**Cause**: The male beam is marked as a Dummy beam.
**Solution**: This is intentional - Dummy beams have zero hardware quantities.

## Related Scripts

| Script | Purpose |
|--------|---------|
| `Hilti-*.mcr` | Alternative hanger systems from Hilti |
| `Rothoblaas *.mcr` | Alternative connector systems from Rothoblaas |
| `GenericHanger.mcr` | Generic hanger for non-catalog connectors |
| `GA.mcr` | Generic angle bracket system |

## Technical Notes

### Coordinate System
The script calculates connector orientation based on:
- `_XU`, `_YU`, `_ZU`: Current UCS axes
- `_XW`, `_YW`, `_ZW`: World coordinate system axes
- Beam direction vectors for proper alignment

### Auto-Model Selection Logic
When Model is set to "Automatic", the script:
1. Gets the male beam height (or contact face height for post connections)
2. Finds the largest model where MinHeight <= beam height
3. Selects that model automatically

### Layer Assignment
- The TSL instance is automatically assigned to the **I-Layer** (Information Layer) of the female beam for proper organization

### Hyperlink
Each connector instance has a hyperlink to the Simpson StrongTie product page for the selected family.
