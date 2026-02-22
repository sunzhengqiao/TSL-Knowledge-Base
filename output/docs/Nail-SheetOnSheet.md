# Nail-SheetOnSheet.mcr

## Overview

Creates nailing patterns (nail lines) to connect overlapping sheets or panels based on configurable strategies, spacing, and detection rules. This tool uses **Painter Definitions** to detect which sheets should be nailed together, making it highly flexible for different construction scenarios.

**Key Features:**
- Automatic detection of overlapping sheets via Painter filters
- Multiple nailing strategies: Perimeter only, Grid only, or combined
- Zone-based processing for multi-layer constructions
- Configuration and rule system for reusable nailing presets
- Works with Sheets, Panels, and SIPs

| Property | Value |
|----------|-------|
| **Script Type** | O (Object) |
| **Version** | 1.2 (December 8, 2021) |
| **Required Beams** | 0 |
| **Category** | Manufacturing / CNC Nailing |
| **Minimum hsbCAD Version** | 23 (requires Painter Definitions) |

---

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary operating environment |
| Paper Space | No | Not applicable |
| Shop Drawing | No | Generates 3D nail data |

---

## Prerequisites

- **hsbCAD Version 23 or higher** (Painter Definition system required)
- **Target Entities**: Sheets, Panels, or SIPs attached to Elements
- **Painter Definitions**: Must be configured for contact detection (can be auto-created)
- **Configuration File**: `Nail-Configuration.xml` (auto-generated if missing)

---

## Step-by-Step Usage

### Method 1: By Element Selection (Standard)

1. **Launch the command**
   - Type `TSLINSERT` and select `Nail-SheetOnSheet.mcr`
   - Or use the hsbCAD ribbon/toolbar

2. **Configure properties in the dialog**
   - Set Tool Index, Spacing, Strategy, and Painter settings
   - Click OK when ready

3. **Select Elements**
   - Command prompt: `Select elements`
   - Click on the wall, floor, or roof elements containing the sheets to be nailed
   - The script will automatically:
     - Detect all zones within each element
     - Clone itself for each zone
     - Process sheets layer by layer

### Method 2: By Sheet Selection (Material-Based)

1. **Launch the command**

2. **Set Painter to "bySheet"**
   - In the properties dialog, select `Nailing\bySheet` as the Painter
   - This activates material-based processing

3. **Select Sheets**
   - Command prompt: `Select sheets`
   - Click on individual sheets to nail
   - The script will:
     - Collect unique material names
     - Create Painter Definitions for each material (if not existing)
     - Create separate TSL instances per material per element

---

## Properties Panel Parameters

### Tooling Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Tool Index** | Integer | 1 | CNC tool/nail gun identifier for production data export |
| **Spacing** | Length | 70 mm | Distance between consecutive nails along a line |
| **Spacing Mode** | Dropdown | Fixed Spacing | How to distribute nails along each segment |
| **Strategy** | Dropdown | Perimeter | Which nail lines to generate |

**Spacing Mode Options:**
- **Fixed Spacing**: Places nails at exact intervals; last segment may be shorter
- **Even Spacing**: Distributes nails evenly across the full length
- **Fixed Spacing, Last odd**: Fixed spacing with special handling for the final nail position

**Strategy Options:**
- **Perimeter**: Nails only around the edges of overlapping areas
- **Perimeter + Grid**: Edge nails plus intermediate grid lines
- **Grid**: Only internal grid lines (no edge nailing)

### Sheet Category (Target Sheets)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Painter** | Dropdown | bySheet | Filter defining which sheets receive nails |
| **Offset Edge** | Length | 20 mm | Default inset from sheet edges |
| **Offset Bottom** | Length | 0 mm | Override for bottom edge (0 = use Offset Edge) |
| **Offset Top** | Length | 0 mm | Override for top edge (0 = use Offset Edge) |
| **Merge Gap** | Length | 0 mm | Distance to merge adjacent contours |

**Painter Filter Options:**
- `Nailing\bySheet`: Filter by sheet material (creates per-material instances)
- `Nailing\byZoneBelow`: All sheets in zones below the current zone
- Custom Painter Definitions: Any Sheet/Panel/SIP-type painter

### Grid Category (Internal Field Nailing)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Offset** | Length | 0 mm | Starting offset for grid lines (0 = center of zone) |
| **Spacing Mode** | Dropdown | Fixed Spacing | How grid spacing is calculated |
| **Alignment** | Dropdown | Horizontal | Direction of grid lines |

*Note: Grid parameters are hidden when Strategy is set to "Perimeter" only.*

**Grid Alignment Options:**
- **Horizontal**: Grid lines run left-right (nails placed on vertical spacing)
- **Vertical**: Grid lines run up-down (nails placed on horizontal spacing)

**Grid Spacing Mode Options:**
- **Fixed Spacing**: Exact intervals from start
- **Even Spacing**: Distributes grid lines across the zone
- **Fixed Spacing, first and last odd**: Fixed with edge adjustment

### Contact Category (Sheets Being Nailed Into)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Painter** | Dropdown | byZoneBelow | Filter defining sheets to nail INTO |
| **Offset Edge** | Length | 20 mm | Inset from contact area edges |
| **Merge Gap** | Length | 0 mm | Distance to merge adjacent contact contours |

---

## Zone-Based Processing

This script processes nailing **per zone**, making it ideal for multi-layer constructions:

1. **Zone Detection**: Script identifies all unique zone indices in selected sheets
2. **Auto-Cloning**: Creates one instance per zone for independent processing
3. **Layer Logic**:
   - Positive zones: Process layers from outside toward inside
   - Negative zones: Process layers from inside toward outside
   - Contact detection only considers zones "below" (closer to structure)

**Example**: A wall with exterior sheathing (Zone 1), studs (Zone 0), and interior gypsum (Zone -1):
- Zone 1 instance: Nails exterior sheathing into studs
- Zone -1 instance: Nails interior gypsum into studs

---

## Right-Click Context Menu

| Menu Item | Description |
|-----------|-------------|
| **Edit in Place** | Opens properties dialog; generates nail lines as separate NailLine entities on OK |
| **Add new Configuration** | Creates a new named configuration group |
| **Remove Configuration** | Deletes an existing configuration and all its rules |
| **Save as rule** | Saves current settings as a named rule within the current configuration |
| **Delete rule** | Removes a specific rule from a configuration |
| **Show Rule Definitions** | Reports all configurations and rules to the command line |

---

## Configuration System

### Settings File

- **Filename**: `Nail-Configuration.xml`
- **Location**: `{Company}\TSL\Settings\` or `{Install}\Content\General\TSL\Settings\`
- **Purpose**: Stores reusable configurations and rules

### Structure

```
Configuration[]
├── Configuration Name 1
│   └── Rule[]
│       ├── Rule Name 1 (stores all property values)
│       └── Rule Name 2
└── Configuration Name 2
    └── Rule[]
```

### Using Rules

1. Configure all parameters as needed
2. Right-click > **Save as rule**
3. Enter or select a Configuration name
4. Enter a Rule name (defaults to Painter name)
5. If rule exists, confirm overwrite

Rules can be applied using the companion tool `Nail-App.mcr` for batch processing.

---

## Workflow Examples

### Example 1: Standard Wall Sheathing Nailing

```
1. Launch Nail-SheetOnSheet
2. Set properties:
   - Tool Index: 1
   - Spacing: 150 mm
   - Spacing Mode: Even Spacing
   - Strategy: Perimeter
   - Sheet Painter: Nailing\OSB
   - Contact Painter: Nailing\byZoneBelow
3. Select wall elements
4. Nailing automatically generated at all OSB-to-stud contacts
```

### Example 2: Floor Deck with Field Nailing

```
1. Launch Nail-SheetOnSheet
2. Set properties:
   - Tool Index: 2
   - Spacing: 300 mm (perimeter)
   - Strategy: Perimeter + Grid
   - Grid Offset: 0 (centered)
   - Grid Spacing Mode: Fixed Spacing
   - Grid Alignment: Horizontal
3. Select floor elements
4. Generates edge nailing at 300mm + internal grid lines
```

### Example 3: Save and Reuse Configuration

```
1. Configure all settings for "Standard Wall Sheathing"
2. Right-click > Save as rule
3. Configuration: "Project Alpha"
4. Rule Name: "Exterior OSB 150mm"
5. Later: Use Nail-App to apply this rule to all walls
```

---

## Technical Notes

### Nail Generation Process

1. **Profile Collection**: Gathers sheet profiles based on Painter filter
2. **Contact Detection**: Finds overlapping areas with contact entities
3. **Profile Intersection**: Calculates where target sheets overlap contacts
4. **Edge Offset**: Applies edge/bottom/top offsets to nailable area
5. **Segment Generation**: Creates line segments for perimeter and/or grid
6. **NoNail Zones**: Subtracts areas defined in element's NoNail profile
7. **Nail Placement**: Distributes nails along segments per spacing mode

### Performance Considerations

- Uses `envelopeBody()` for contact detection (faster than `realBody()`)
- Profiles are processed in element local coordinates
- Short segments (< 0.5 * spacing) are skipped automatically

### Debug Mode

When Debug is enabled:
- Displays text label showing zone and nail count
- Does not erase the instance after processing
- Shows colored profile visualization

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| **No nails generated** | 1. Verify Painter settings match your sheet types<br>2. Check that sheets actually overlap<br>3. Ensure Zone assignment is correct |
| **Wrong sheets being nailed** | Review Sheet Painter filter; may need to create specific Painter Definition |
| **Missing nails at edges** | Reduce Offset Edge value or check Merge Gap setting |
| **Nails in openings** | Define NoNail profiles on the element |
| **Configuration not saving** | Verify write permissions to Company\TSL\Settings folder |
| **"Painter Contact not valid" error** | Painter Definition will be auto-created; let script re-run |

---

## Related Scripts

| Script | Purpose |
|--------|---------|
| **Nail-App.mcr** | Batch applies saved rules to multiple elements |
| **Nail-Configuration.xml** | Settings file storing configurations |
| Painter Definition scripts | Create/manage Painter filters |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.2 | 08.12.2021 | Added context commands to remove rules and show all rules in report dialog |
| 1.1 | 29.04.2021 | Added grid nailing capability |
| 1.0 | 23.04.2021 | Initial release - sheet on sheet nailing |

---

## Tips and Best Practices

1. **Use Configurations**: Create named configurations for different nailing standards (e.g., "Residential Wall", "Commercial Floor")

2. **Painter Naming Convention**: Use descriptive names like `Nailing\OSB-Exterior` for clarity

3. **Zone Planning**: Design your element zones with nailing in mind - consistent zone numbering simplifies setup

4. **Test with Debug**: Enable debug mode to visualize zones and nail counts before production

5. **Batch Processing**: Configure one element correctly, save as rule, then use Nail-App for the rest

6. **Spacing Calculation**: For even spacing, the script automatically calculates the adjusted spacing to fit nails evenly

7. **Multi-Material Projects**: Use "bySheet" mode when different materials need different nail patterns
