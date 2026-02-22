# PartLabeler

## Overview

The PartLabeler script is designed to create labels for structural components within stick-frame walls and other building elements. It automatically generates labels based on position numbers or other specified criteria, then records this information to MapX for use in reporting and scheduling applications.

**Author:** Craig Colomb
**Version:** 0.21 (February 6, 2024)
**Category:** Labeling & Marking

## Key Features

- **Automatic Label Generation**: Creates alphabetical labels (A, B, C, etc.) for structural components
- **Flexible Labeling Strategies**: Supports both zone-based and element-based labeling approaches
- **Criteria-Based Grouping**: Groups components using custom formatting criteria
- **Duplicate Prevention**: Automatically removes duplicate labels during updates
- **Integration with Reporting**: Stores label data in MapX for use with external systems

## Application

This script is typically used when:
- Creating detailed shop drawings requiring component identification
- Generating reports that reference specific structural elements
- Organizing components for fabrication or installation sequencing
- Creating schedules that reference individual building elements

## User Interface

### Properties Panel (OPM)

The PartLabeler script provides several configurable properties through the AutoCAD Properties Panel:

| Property | Default Value | Description |
|----------|---------------|-------------|
| **Beam Criteria** | @(posnum) | Comma-separated list of formats used to group like beams for labeling |
| **Sheet Criteria** | @(posnum) | Comma-separated list of formats used to group like sheets for labeling |
| **Zones to Label** | (empty) | Specific zones to include in labeling (empty = all zones) |
| **Label Strategy** | Zone | Determines whether labels restart with each zone or are globally unique |

#### Label Strategy Options

- **Zone**: Labels restart with 'A' for each zone (e.g., Zone 1: A, B, C; Zone 2: A, B, C)
- **Element**: Every label in the entire wall/element is unique (e.g., A, B, C, D, E...)

## Usage Instructions

### 1. Inserting the Script

1. Run the PartLabeler command
2. Select one or more elements (walls, floors, roofs) to label
3. The script will automatically create instances on each selected element

### 2. Configuring Labels

1. Select a labeled element
2. Open the Properties Panel (Ctrl+1)
3. Configure the following properties as needed:

   - **Beam Criteria**: Enter formats to group beams (e.g., @(posnum), @(material), @(length))
   - **Sheet Criteria**: Enter formats to group sheets (e.g., @(posnum), @(type), @(thickness))
   - **Zones to Label**: Enter specific zone numbers separated by commas (leave empty for all zones)
   - **Label Strategy**: Choose between Zone-based or Element-based labeling

### 3. Updating Labels

To refresh or update labels:

1. Select any labeled element
2. Use the context menu command: **"Update Labels"**
3. The script will recalculate labels based on current criteria and element properties

## Label Generation Logic

### Alphabetical Label System

The script uses a two-tier alphabetical system:

- **Single letters**: A through Z (26 labels)
- **Compound labels**: AA through AZ, BA through BZ, etc. (continuing beyond Z)

### Grouping Process

1. Components are grouped based on the specified criteria
2. Each unique group receives a sequential label
3. Labels are assigned according to the selected strategy:
   - **Zone strategy**: Groups are independent per zone
   - **Element strategy**: Groups are considered across the entire element

### Example Labeling Scenarios

#### Scenario 1: Zone Strategy with @(posnum)
- Zone 1, posnum 1 → Label "A"
- Zone 1, posnum 2 → Label "B"
- Zone 2, posnum 1 → Label "A" (restarts)

#### Scenario 2: Element Strategy with @(material)
- All 2x4 studs → Label "A"
- All 2x6 studs → Label "B"
- All OSB sheets → Label "C"

## Technical Details

### MapX Data Storage

Labels are stored in the element's MapX data structure:
- Key: "mpLabel"
- Value: Contains the assigned label string
- Accessible through other scripts for reporting

### Position Number Assignment

The script can automatically assign position numbers to components if they don't have them assigned. This ensures that all components can be properly labeled and tracked.

### File Format Integration

The script integrates with hsbCAD's XML configuration system and can read from both:
- Company-specific settings: `_kPathHsbCompany + "\TSL\Settings\"`
- Installation settings: `_kPathHsbInstall + "\Content\General\TSL\Settings\"`

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 0.21 | Feb 6, 2024 | Bugfix on building label array |
| 0.19 | Feb 6, 2024 | Increased size of available labels |
| 0.17 | Oct 4, 2023 | Will erase duplicates |
| 0.16 | Oct 4, 2023 | Set criteria fields to use formatting dialog |
| 0.15 | Sep 26, 2023 | Bugfix on triggering posnum assignment |
| 0.14 | Sep 25, 2023 | Added ExecuteKey trigger for info assignment |
| 0.12 | Sep 25, 2023 | Bugfix in label indices |

## Tips and Best Practices

1. **Consistent Criteria**: Use consistent formatting criteria across similar elements for predictable results
2. **Zone Planning**: Plan your zone layout before applying labels if using zone strategy
3. **Regular Updates**: Use the "Update Labels" command after modifying element properties
4. **Backup Criteria**: Save your criteria configurations for reuse in similar projects
5. **Performance**: The script works efficiently with large numbers of components but may take longer with very complex elements

## Troubleshooting

### Common Issues

**Labels not updating:**
- Ensure you've selected the correct labeled element
- Use the "Update Labels" command from the context menu
- Check if element properties have changed

**Duplicate labels appearing:**
- The script should automatically remove duplicates
- Try running "Update Labels" to refresh the entire labeling system

**No labels generated:**
- Verify that elements contain beams or sheets to label
- Check that your criteria match the actual element properties
- Ensure the script has proper permissions to modify the elements

## Integration with Other Scripts

PartLabeler works seamlessly with other hsbCAD scripts:

- **Reporting Scripts**: Labels can be referenced in custom reports
- **Shop Drawing Scripts**: Labels appear in fabrication drawings
- **Scheduling Scripts**: Labels provide unique identifiers for scheduling
- **Material Takeoff Scripts**: Labels can be grouped by material for BOM generation

## See Also

- [hsbCLT-LabelerEntity] - CLT-specific labeling tool
- [LinkedScheduleTable] - Scheduling system that uses label data
- [ElementTagger] - Alternative labeling system for entities