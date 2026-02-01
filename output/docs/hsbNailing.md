# hsbNailing

**Version:** 5.3
**Last Updated:** 20.10.2022
**Script Type:** O-Type (Object)
**Keywords:** Element, Nailing, CNC, Nail

---

## Description

hsbNailing is a comprehensive nailing automation tool that creates nail lines on timber elements (walls, floors, roofs). The script automatically generates nailing patterns based on catalog entries that match your model criteria, such as material, zone, wall type, and exposure settings.

This script supports four distinct nailing modes:
- **Nail on Laths** - Creates nail lines along laths/battens
- **Nail on Sheeting** - Creates nail lines on sheet materials (OSB, plywood, etc.)
- **Nail on Studs** - Creates nail lines directly on stud members
- **Nail on Grid Studs** - Creates nail lines following the stud grid pattern

The script works by analyzing your element configuration and automatically applying the appropriate nailing rules from your pre-configured catalog entries.

---

## How It Works

1. **Select Elements** - Choose one or more wall, floor, or roof elements
2. **Catalog Matching** - The script searches for catalog entries that match your element properties (zone, material, wall code, exposure, load bearing status)
3. **Automatic Application** - Matching nailing configurations are automatically applied to your elements
4. **Instance Creation** - Sub-instances are created for each nailing type (hsbNailing-Lath, hsbNailing-Sheet, hsbNailing-Stud, hsbNailing-StudGrid)

---

## Properties

### Tooling Zone

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Material | String | (empty) | Filter beams by material name. Leave empty to include all materials. Separate multiple entries with semicolon (;) |
| Exclude Color | Integer | 0 | Exclude beams with this color index. Use 0 for no color filtering |

### Contact Zone

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Material | String | (empty) | Filter contact zone beams by material. Separate multiple entries with semicolon (;) |
| Exclude Color | Integer | 0 | Exclude contact beams with this color index. Use 0 for no color filtering |

### Nailing

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Zone | Integer | (selection) | Target zone index. Options: -5, -4, -3, -2, -1, 1, 2, 3, 4, 5 |
| Nailing tool index | Integer | 1 | Color/tool index for the generated nail lines |
| Maximum nailing spacing | Double | 50 mm | Maximum distance between nails along the nail line |
| Combine Nail Lines | Double | 0 mm | If greater than zero, colinear nail lines will be combined over multiple sheets when gaps are smaller than this value |

### Filter

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Element Filter | String | (empty) | Filter by wall codes or element types. Separate multiple values with semicolon. Valid types: Wall, Floor, Roof, Multielement |
| Exposed | Dropdown | Disabled | Filter walls by exposure. Options: Disabled, Interior, Exterior |
| Load Bearing Walls | Dropdown | Disabled | Filter walls by structural type. Options: Disabled, Not Load Bearing, Load Bearing |

### Mode-Specific Properties

#### Nail on Laths (Mode 2)

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Distance from sheeting edge | Double | 20 mm | Offset from the sheeting zone edge |
| Distance end beams | Double | 20 mm | Offset from beam/lath ends |
| Distance from beam edge | Double | 5 mm | Minimum side offset to the beam |
| Max. Offset Vertical Nailline | Double | 50 mm | Maximum offset for vertical nail lines before creating additional lines on loose edges |
| Distance from sheeting edge (loose Edge) | Double | 50 mm | Edge offset for nailing on loose sheeting edges |

#### Nail on Sheeting (Mode 3)

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Distance from sheeting edge | Double | 20 mm | Offset from sheet edges |
| Distance end beams | Double | 20 mm | Offset from beam ends |
| Merge gaps | Double | 0 mm | Gap tolerance for merging adjacent nail segments |

#### Nail on Grid Studs (Mode 5)

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| X-Grid | Double | 0 mm | Defines a grid in X-direction. Redundant nail lines between grid points are suppressed |

---

## Usage Workflow

### Initial Setup (Creating Catalog Entries)

1. **Start the Script** - Insert hsbNailing and press Enter (without selecting elements) to enter setup mode
2. **Select Nailing Type** - Choose from: Nail on laths, Nail on sheeting, Nail on studs, Nail on grid studs
3. **Optional: Select Reference Beam** - Click a beam to automatically capture its zone and material for the catalog entry
4. **Optional: Select Contact Material Beam** - Click another beam to capture the contact zone material
5. **Configure Properties** - Adjust the nailing parameters in the dialog
6. **Save Catalog Entry** - The configuration is automatically saved with an auto-generated name based on zone, material, and filter settings

### Applying Nailing to Elements

1. **Start the Script** - Insert hsbNailing
2. **Select Elements** - Select one or more wall, floor, or roof elements
3. **Automatic Processing** - The script will:
   - Remove any existing nail lines and nailing instances from selected elements
   - Search through all catalog entries
   - Apply matching configurations based on zone, material, wall code, exposure, and load bearing properties
   - Create nail line instances for each matching configuration

### Modifying Existing Nailing

After nailing instances are created, you can:
- Select individual nailing instances in the drawing
- Modify properties through the AutoCAD Properties Palette (OPM)
- Changes will recalculate automatically

---

## Important Notes

- **Existing nail lines are removed** when the script runs on an element. The script reports how many instances and nail lines were deleted.
- **Catalog entries are zone-specific** - Each entry targets a specific zone index and material combination.
- **Multiple catalog entries can apply** to a single element if their filter criteria match.
- **Material filtering is case-insensitive** - "OSB" and "osb" are treated as equivalent.
- **Saw line protection** - The script automatically detects and avoids nailing in areas marked with element saw tools.
- **No-nail zones** - The script respects no-nail definitions from other TSL scripts attached to the element.

---

## Settings File

The script reads additional configuration from an XML settings file located at:
`<Company Path>\TSL\Settings\hsbNailing.xml`

This file can contain:
- Material-specific exclusive name filters
- Sheet conversion settings (ConvertSheet parameter)

Example settings structure:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <lst nm="Mode[]">
    <lst nm="StudGrid">
      <lst nm="Material[]">
        <lst nm="XPS">
          <lst nm="ExclusiveName[]">
            <str nm="ExclusiveName" vl="Schwelle-Hauseingang"/>
          </lst>
        </lst>
      </lst>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

---

## Sub-Instances Created

When applied to elements, the script creates named sub-instances:
- **hsbNailing-Lath** - Nailing on laths/battens
- **hsbNailing-Sheet** - Nailing on sheet materials
- **hsbNailing-Stud** - Nailing on individual studs
- **hsbNailing-StudGrid** - Nailing following stud grid pattern

---

## Troubleshooting

| Issue | Possible Cause | Solution |
|-------|----------------|----------|
| No nail lines created | No matching catalog entries | Create catalog entries in setup mode with matching zone/material |
| Wrong nailing pattern | Filter criteria mismatch | Check Element Filter, Exposed, and Load Bearing settings |
| Missing nail lines in areas | Saw line protection active | Check for element saw tools in the target zone |
| Instance deleted automatically | Element not found or invalid | Ensure the element is properly constructed |
