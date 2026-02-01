# hsb_Insulation

## Overview

The **hsb_Insulation** script automatically creates solid insulation sheets between timber framing members within wall elements. It fills the cavities formed by studs, plates, and other structural members with insulation material, supporting different insulation types for main areas and connection zones.

**Script Type:** O-Type (Object)
**Version:** 2.23
**Keywords:** Insulation, UK, Wall, Element

## Description

This script analyzes the framing layout of selected wall elements and generates insulation sheets that fit precisely between the timber members. Key features include:

- Creates solid insulation bodies in designated zones
- Supports different insulation products for main areas vs. connection zones (flat studs)
- Respects openings (windows, doors) and their clearance gaps
- Filters walls by type code for selective application
- Displays optional hatch patterns in plan view
- Exports insulation data to the database for material takeoffs

## Properties

### General Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Wall types for this Insulation | String | `EA;EB;` | Wall type codes to insulate. Use semicolon (`;`) to separate multiple types. Leave empty or use specific codes to filter which walls receive insulation. |
| Insulation Name | String (Dropdown) | Crown FrameTherm Roll 40 | Select from predefined insulation products (Crown, Isover, Knauf, Rocksilk, Kingspan) or choose "Other Insulation Type" for custom entry. |
| Other Insulation Type | String | (empty) | Custom insulation name when "Other Insulation Type" is selected above. |
| Attach Insulation to Zone | Integer (Dropdown) | 10 | Target zone for insulation placement. Options: 1-10, 0. Zone 0 attaches to the main framing zone. |
| Insulation Thickness | Double | 90 mm | Thickness of the insulation. If set to 0, the insulation will match the thickness of zone 0 automatically. |
| Insulation Stock Width | Double | 1200 mm | Stock width for material ordering and takeoff calculations. |
| Insulation Stock Length | Double | 8000 mm | Stock length for material ordering and takeoff calculations. |
| Insulation Stock Units | String (Dropdown) | Rolls | Unit type for ordering: Rolls, Slabs, Batts, or Boards. |

### Connection Insulation Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Insulation Name for Connections | String (Dropdown) | Crown FrameTherm Roll 40 | Insulation product for areas around flat/diagonal studs and connections. |
| Other Insulation Type for Connections | String | (empty) | Custom name when "Other Insulation Type" is selected for connections. |
| Insulation Thickness for Connections | Double | 90 mm | Thickness for connection zone insulation. |
| Insulation Stock Width (Connections) | Double | 1200 mm | Stock width for connection insulation material. |
| Insulation Stock Length (Connections) | Double | 8000 mm | Stock length for connection insulation material. |
| Insulation Stock Units (Connections) | String (Dropdown) | Rolls | Unit type for connection insulation. |

### Size Control Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Minimal width/height | Double | 20 mm | Minimum dimension threshold. Insulation sheets smaller than this value will not be created. |
| Minimal Thickness | Double | 20 mm | Minimum thickness threshold. Insulation thinner than this will be skipped. |
| Decrease width of insulation | Double | 0 mm | Reduce the overall width of all insulation sheets by this amount (for fit tolerances). |
| Decrease height of insulation | Double | 0 mm | Reduce the overall height of all insulation sheets by this amount (for fit tolerances). |
| Stop Insulation Flush to Flat Studs | String (Yes/No) | No | When set to Yes, insulation will stop at flat studs that do not span the full zone thickness. |

### Display Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Display Hatch Pattern | String (Yes/No) | Yes | Enable/disable hatch pattern visualization in plan views. |
| Hatch Pattern | String (Dropdown) | (system patterns) | Select hatch pattern style from available AutoCAD patterns. |
| Hatch Scale | Double | 7.5 | Scale factor for the hatch pattern. |
| Hatch Angle | Double | 0 | Rotation angle for the hatch pattern in degrees. |
| Hatch Color | Integer | 51 | Color index for the hatch pattern (1-255). |
| Dimstyle | String (Dropdown) | (system styles) | Dimension style for annotation text. |
| Show Only In Disp Rep Name | String | (empty) | Restrict display to specific display representation names. Leave empty to show in all views. |

## Usage Workflow

### Step 1: Run the Script

1. Launch the script from the Tool Palette or command line
2. On first insertion, the properties dialog appears automatically

### Step 2: Configure Settings

1. **Set Wall Types**: Enter wall type codes (e.g., `EA;EB;`) to filter which walls receive insulation. Use semicolons between multiple codes.
2. **Select Insulation Product**: Choose from the dropdown list or select "Other Insulation Type" and enter a custom name.
3. **Set Thickness**: Enter the desired insulation thickness. Use 0 to automatically match zone 0 thickness.
4. **Configure Connection Insulation**: If your walls have flat studs or angled members, set separate insulation properties for those areas.
5. **Adjust Tolerances**: Use the decrease width/height values if you need gaps for fitting.

### Step 3: Select Elements

When prompted with "Select a set of elements", select one or more wall elements in your drawing. The script will:

- Filter walls based on your wall type settings
- Create a separate insulation instance for each qualifying wall
- Automatically skip walls that do not match the specified type codes

### Step 4: Automatic Generation

The script automatically:

1. Analyzes the framing layout within each wall
2. Identifies cavities between studs
3. Creates insulation sheets sized to fill each cavity
4. Assigns sheets to the specified zone
5. Applies material names and properties
6. Generates display graphics (hatch patterns)
7. Exports data for material takeoffs

## Context Menu Commands

| Command | Description |
|---------|-------------|
| Reapply Insulation Sheets | Regenerates all insulation sheets. Use after making changes to wall framing or insulation properties. |

## Technical Notes

### Zone Assignment

- Insulation is created as Sheet entities assigned to the specified zone
- Default zone is -5 (internal), but can be changed to zones 1-10 or 0
- Zone 0 attaches insulation directly to the main framing zone

### Handling Openings

The script automatically detects window and door openings and:
- Excludes the opening area from insulation
- Respects gap settings around openings (top, bottom, sides)
- Expands exclusion zones by 5mm for clearance

### Flat Stud Handling

When walls contain flat studs (studs oriented differently than standard):
- The script can use a different insulation type for these areas
- The "Stop Insulation Flush to Flat Studs" option controls whether insulation terminates at partial-thickness studs

### Data Export

The script exports two ElemItem records per wall:
- **INSULATION1**: Main insulation (material, thickness, stock dimensions, units)
- **INSULATION2**: Connection insulation (material, thickness, stock dimensions, units)

These records are available for Bill of Materials and material takeoff reports.

### Conflict Resolution

If multiple hsb_Insulation instances exist on the same element:
- The script automatically removes previous instances
- Only the most recent instance remains active

### Dependency Tracking

The script monitors other TSL instances on the element for "noinsulation" areas (such as ventilation zones) and excludes those regions from insulation placement.

## Predefined Insulation Products

The script includes the following insulation products:

**Crown Products:**
- Crown FrameTherm Roll 40/37/35
- Crown FrameTherm Slab 40/37/35
- Crown Universal Slab CS24/CS32/CS48

**Isover Products:**
- Isover Acoustic 25 Roll

**Knauf Products:**
- Knauf RS 45 Slab
- Knauf Earthwool 35 Slab

**Rocksilk Products:**
- Rocksilk Universal Slab RS33/RS45/RS60/RS80/RS100/RS140/RS200

**Kingspan Products:**
- Kingspan Thermawall TW50/TW53/TW70

Select "Other Insulation Type" to enter custom product names.

## Tips

- Use wall type filtering to apply different insulation configurations to different wall types in a single drawing
- Set thickness to 0 for automatic zone-matching when framing depth varies
- Use the decrease width/height properties to create fit tolerances for site installation
- The hatch display helps identify insulated vs. non-insulated areas in plan views
- Run "Reapply Insulation Sheets" after modifying wall framing to update insulation
