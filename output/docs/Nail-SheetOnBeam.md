# Nail-SheetOnBeam.mcr

## Overview
This script creates nail lines on sheets and beams based on painter configurations. It automates the generation of nail patterns for structural timber elements, applying predefined sheathing schedules (e.g., for OSB or Plywood) to wall panels, floor elements, or roof assemblies. The script uses PainterDefinitions to identify valid nailing zones and manages a library of reusable nailing rules via XML configuration files.

## Script Metadata

| Property | Value |
|----------|-------|
| **Type** | O (Object) |
| **Version** | 2.1 |
| **Last Updated** | 17/04/2025 |
| **Major Version** | 2 |
| **Minor Version** | 1 |
| **Beams Required** | 0 |
| **Keywords** | Nail; Naillines; Element; CNC |
| **hsbCAD Version** | 23 or higher (for PainterDefinitions support) |

### Version History
| Version | Date | Description |
|---------|------|-------------|
| 2.1 | 17/04/2025 | HSB-22987: Fix when stretching planeprofiles with multiple rings |
| 2.0 | 23.12.2021 | HSB-12218: Enhanced logging if a painter could not find requested entities |
| 1.9 | 08.12.2021 | HSB-13560: New context commands to remove a rule from a configuration and to show all rules in report dialog |
| 1.8 | 22.10.2021 | HSB-13560: Request prepared |
| 1.7 | 23.01.2021 | HSB-10442: Painterdefinitions stored in rule for auto-creation in painterless drawings |
| 1.6 | 21.01.2021 | HSB-8687: Bugfix using beam painter definition |
| 1.5 | 20.01.2021 | HSB-10410/10414: Short nailsegments handling and centered nail line for small extends |

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D geometry and machining operations |
| Paper Space | No | Not applicable |
| Shop Drawing | No | Not applicable |

## Prerequisites
- **Required Entities**: `GenBeam` or `Sheet` elements within an Element (wall, floor, roof)
- **Minimum Beam Count**: 0 (You can select a single sheet or multiple beams)
- **Required Settings**:
  - `Nail-Configuration.xml` (Must exist in `_kPathHsbCompany\TSL\Settings` or `_kPathHsbInstall\Content\General\TSL\Settings`)
- **hsbCAD Version**: 23 or higher (required for PainterDefinitions support)

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` -> Select `Nail-SheetOnBeam.mcr`

Alternatively, use the AutoCAD command:
```
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Nail-SheetOnBeam")) TSLCONTENT
```

### Step 2: Select Elements
Two selection modes are available:

**Mode A: Sheet-Based Selection (bySheet)**
1. Select "bySheet" as the Sheet Painter
2. Click on the sheet materials you want to apply nailing to
3. The script will:
   - Automatically create PainterDefinitions for each unique sheet material
   - Generate separate nailing instances for each element containing those sheets

**Mode B: Element-Based Selection**
1. Select elements (walls, floors, roofs) directly
2. The script creates one instance per selected element
3. Use the Properties Palette to configure nailing parameters

### Step 3: Configure Parameters
Use the Properties Palette (OPM) to adjust:
- **Tool Index**: CNC tool identifier
- **Spacing**: Distance between nails
- **Spacing Mode**: How spacing is calculated
- **Strategy**: Nailing pattern approach
- **Offset values**: Edge and beam offsets

### Step 4: (Optional) Save as Rule
If you have configured a nailing pattern you want to reuse:
1. Right-click the script instance
2. Select **Save as rule**
3. Enter the Configuration name and Rule Name in the dialog

## Properties Panel Parameters

### Tooling Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Tool Index** | Integer | 1 | Defines the CNC tool index for the nailing operation. This number corresponds to the tool number in your CNC machine setup. |
| **Spacing** | Double | 70 mm | Defines the distance between consecutive nails along the nail line. |
| **Spacing Mode** | Dropdown | Fixed Spacing | Determines how spacing is calculated: <br> - **Fixed Spacing**: Uses exact spacing value <br> - **Even Spacing**: Adjusts spacing to distribute nails evenly <br> - **Fixed Spacing, Last odd**: Fixed spacing with special handling for last nail |
| **Strategy** | Dropdown | Default | Defines the nailing strategy: <br> - **Default**: Standard nailing along beam contact areas <br> - **Combine vertical naillines**: Joins vertical studs at same grid location <br> - **Sheet perimeter**: Nails along the perimeter of each sheet <br> - **X-HalfGrid**: Creates a half-grid pattern centered on vertical beams |

### Sheet Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Painter** | Dropdown | bySheet | Defines the Painter filter for identifying which sheets to nail. PainterDefinitions filter sheets based on material, zone, or other properties. |
| **Offset Edge** | Double | 20 mm | General edge offset from all sheet edges. This prevents nails from being placed too close to the edge of the sheet. |
| **Offset Bottom** | Double | 0 mm | Additional offset at the bottom of a wall or on the -Y-Side of an element. Set to 0 to use the general Edge Offset value. |
| **Offset Top** | Double | 0 mm | Additional offset at the top of a wall or on the +Y-Side of an element. Set to 0 to use the general Edge Offset value. |

### Beam Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Painter** | Dropdown | byFrame | Defines the Painter filter for identifying contact beams (studs, joists, rafters). Default "byFrame" filters non-dummy beams in zone 0. |
| **Offset Beam Edge** | Double | 20 mm | Offset from the edges of the beam contact area. |
| **Offset Beam End** | Double | 50 mm | Offset from the ends of beams, allowing for end-distance requirements in nailing patterns. |

### Hidden Properties (Advanced)

| Parameter | Type | Description |
|-----------|------|-------------|
| **Beam Painter Definition** | String (Hidden) | Stores serialized data of the beam/contact painter definition for persistence across sessions. |
| **Contact Painter Definition** | String (Hidden) | Stores serialized data of the contact painter definition. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Edit in Place** | Activates the script for modification. Can also be triggered by double-clicking the instance. When activated with this command, the script creates individual NailLine entities that can be edited independently. |
| **Add new Configuration** | Opens a dialog to create a new group/container for organizing nailing rules. Enter a name for the new configuration set. |
| **Remove Configuration** | Opens a dropdown to delete an existing configuration and all its rules from the settings file. Available only when more than one configuration exists. |
| **Save as rule** | Opens a dialog to save the current instance's settings (spacing, offsets, painters) as a reusable preset. Prompts for Configuration and Rule Name. |
| **Delete rule (ConfigurationName)** | Opens a dialog filtered to a specific configuration to allow deletion of a specific nailing preset. One menu item appears for each configuration. |
| **Show Rule Definitions** | Prints a comprehensive text report of all configurations and their rule parameters to the report console for review. |
| **Show Debug Info on/off** | Toggles visual debugging information on screen, showing the nail profiles and zones. |

## Nailing Strategies Explained

### Default Strategy
Standard nailing approach that:
1. Identifies contact areas between beams and sheets
2. Creates nail lines along the center of each beam contact area
3. Applies edge and end offsets
4. Clips nail lines to the sheet boundary

### Combine Vertical Naillines
Specialized for wall framing with studs:
1. Groups vertical studs that share the same X-grid location
2. Joins their contact profiles into continuous areas
3. Creates single nail lines spanning multiple studs at the same position
4. Reduces the number of nail lines while maintaining coverage

### Sheet Perimeter
Designed for edge nailing:
1. Traces the perimeter of each sheet
2. Creates nail lines along all four edges
3. Splits perimeter segments at beam contact locations
4. Adds a single centered nail line if sheet width is smaller than stud height

### X-HalfGrid
Optimized for wide sheet areas:
1. Divides sheets wider than half the zone width
2. Finds vertical beam locations near the center of wide areas
3. Creates nail lines at these intermediate locations
4. Also nails the outer perimeter of the sheet

## Spacing Modes Explained

### Fixed Spacing
- Uses the exact spacing value specified
- If a segment is shorter than half the spacing, no nails are added
- The nail line is truncated to fit complete spacing intervals

### Even Spacing
- Automatically adjusts spacing to distribute nails evenly
- Ensures nails are placed at both ends of each segment
- Calculated as: actual_spacing = segment_length / (nail_count + 1)

### Fixed Spacing, Last Odd
- Fixed spacing with special handling
- Ensures the last nail doesn't fall in an awkward position
- Useful for aesthetic nailing patterns

## Settings Files

### Configuration File
- **Filename**: `Nail-Configuration.xml`
- **Location**: Searches in this order:
  1. `_kPathHsbCompany\TSL\Settings\Nail-Configuration.xml`
  2. `_kPathHsbInstall\Content\General\TSL\Settings\Nail-Configuration.xml`

### Structure
The XML file stores:
- **Configurations**: Named groups of nailing rules
- **Rules**: Individual nailing presets with all property values
- **PainterDefinitions**: Stored within rules for auto-creation

### Import/Export
Use the XML-Settings ribbon command or call `hsbTslSettingsIO` to import/export configurations between drawings or computers.

## Tips and Best Practices

### Workflow Tips
- **Start with Presets**: Use saved rules for common nailing patterns to ensure consistency
- **Zone Management**: The script automatically creates separate instances for each zone in multi-zone elements
- **Painter Definitions**: If your drawing lacks PainterDefinitions, the script can auto-create them from the rule data

### Performance Tips
- **Purge Empty Instances**: The script automatically deletes itself if no valid nail lines are generated
- **Use Strategies Wisely**: "Combine vertical naillines" is fastest for standard wall framing; "Sheet perimeter" processes each sheet individually

### Troubleshooting Tips
- **Missing Nails**: Check that your PainterDefinitions correctly filter the intended beams/sheets
- **Incorrect Spacing**: Verify that Spacing Mode is set correctly for your needs
- **Edge Issues**: Adjust Offset values if nails are too close to or too far from edges

## FAQ

**Q: Why did the script disappear after I inserted it?**
A: The script automatically erases itself if it does not generate any nail lines. Check that:
- Your selected elements contain valid beams and sheets
- The PainterDefinitions are correctly filtering entities
- The sheets are in the same zone as the beams

**Q: Where are my nail rules stored?**
A: They are stored in the `Nail-Configuration.xml` file. If you move the project to a new PC, copy this XML file to retain your custom rules. The file is also stored inside the DWG via MapObject.

**Q: How do I change the nailing pattern on a single sheet without changing the rule?**
A: Double-click the instance (Edit in Place), change the parameters in the Properties Palette, and ensure you do not use the "Save as rule" option. Alternatively, save it under a new rule name.

**Q: What happens when I use "Edit in Place"?**
A: The script creates individual NailLine entities that are no longer controlled by the script. This allows manual editing but breaks the parametric relationship.

**Q: Can I use this script without PainterDefinitions?**
A: This tool requires PainterDefinitions and is only available for hsbCAD version 23 or higher. However, if you insert a saved rule containing PainterDefinition data, the script will auto-create the necessary definitions.

**Q: How do I handle overlapping sheets?**
A: The script processes each sheet's nailable area separately. Use the Strategy options to control how nail lines are generated in complex situations.

## Related Scripts

| Script | Relationship |
|--------|--------------|
| **Nail-App** | Parent tool for inserting a full set of nailing rules by configuration |
| **hsbTslSettingsIO** | Utility for importing/exporting XML settings between drawings |

## Technical Notes

### Automatic Behaviors
1. **Zone Cloning**: If no specific zone is assigned, the script creates clones for each zone detected in the element
2. **Painter Auto-Creation**: When using "bySheet" selection, PainterDefinitions are automatically created for each unique material
3. **No-Nail Profile**: The script respects the element's NoNailProfile, subtracting these areas from the nailable zone
4. **Short Segment Handling**: Segments shorter than half the spacing (in Fixed mode) or very short segments are skipped

### Validation Rules
- Spacing must be greater than 0 (auto-adjusted if invalid)
- Element reference must be valid
- At least one beam and one sheet must match the painter filters
- Configuration names must be unique within the settings file
