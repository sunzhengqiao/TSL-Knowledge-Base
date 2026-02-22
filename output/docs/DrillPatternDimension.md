# DrillPatternDimension

## Overview

| Property | Value |
|----------|-------|
| **Script Name** | DrillPatternDimension |
| **Type** | Object (O) |
| **Version** | 1.7 (March 15, 2023) |
| **Category** | Shop Drawing / Dimensioning |
| **Author** | Thorsten Huck |
| **Required Beams** | 0 |

### Description
Creates multiple instances to automatically dimension drill patterns on timber elements. The script detects drill patterns (1D and 2D), creates dimension lines, and generates tags with drill quantity and diameter information. It works with GenBeams, MultiPages, ChildPanels, and ShopDrawView entities.

---

## Usage Environment

| Environment | Supported | Notes |
|-------------|-----------|-------|
| **Model Space** | Yes | Can dimension GenBeams directly |
| **Paper Space** | Yes | Via MultiPage support |
| **Block Space** | Yes | Works with ShopDrawView entities |
| **Shop Drawing Generation** | Yes | Automatic creation during shop drawing generation |

---

## Prerequisites

- **Required Entities**: GenBeam, MultiPage, ChildPanel, or ShopDrawView
- **Minimum Beam Count**: 0 (selection depends on target entity type)
- **Required Dependencies**: `hsbGeoPattern.dll` must be available in the installation path

---

## Usage Workflow

### Basic Workflow

1. **Insert the Tool**: Run the script and select target entities (GenBeams, MultiPages, ChildPanels, or ShopDrawViewports)
2. **Configure Settings**: Set dimension style, text height, and pattern detection parameters in the Properties Palette
3. **Automatic Detection**: The script automatically detects drill patterns using the hsbGeoPattern.dll
4. **Dimension Generation**: Creates dimension lines with pattern tags showing quantity and diameter

### Selection Options

| Entity Type | Behavior |
|-------------|----------|
| **GenBeam** | Select individual timber beams for dimensioning |
| **MultiPage** | Select multipage elements for coordinated dimensioning across views |
| **ChildPanel** | Select child panels with associated SIP entities |
| **ShopDrawView** | Select shop drawing viewports in block space mode |

### Pattern Detection

The script automatically identifies:

- **1D Patterns**: Linear drill arrangements along a single axis
- **2D Patterns**: Grid-based drill arrangements in two axes
- **Loose Drills**: Individual drills not part of any detected pattern

---

## Properties Panel Parameters

### Display Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Dimstyle** | String | (from drawing) | Defines the dimension style used for all dimension lines and tags |
| **Text Height** | Double | 0 | Text height for dimension labels. Set to 0 to use the dimension style default |

### Dimline Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Delta Format** | String | `<>[@(PatternIndex:D)]` | Format string for dimension line labels. Use `<>` for the dimension value. Supports pattern properties: PatternIndex, Diameter, Quantity, Depth, Bevel, Angle |
| **Delta/Chain Mode** | String | `parallel / parallel` | Display mode for dimension lines. Options: parallel/perpendicular combinations for delta and chain dimensions |

### Tag Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Format** | String | `@(Quantity)x O@(Diameter)\P[@(PatternIndex:D)]` | Format string for pattern tags. Supports: Quantity, Diameter, PatternIndex, Radius, Depth, Bevel, Angle |

### Pattern Detection Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Max. Interdistance** | Double | 200 mm | Maximum distance between drills to detect them as part of the same pattern |
| **Pattern Mode** | String | All | Detection mode: "All", "1 dimensional", or "2 dimensional" |
| **Location Overlap Count** | Integer | 1-4 | Maximum number of patterns an individual drill may belong to |

---

## Context Menu Options

### For Pattern Dimension Lines (mode=3)

| Command | Description |
|---------|-------------|
| **Remove Drills** | Select and remove specific drills from the current dimension line. Creates a new loose dimension line with removed drills |
| **Flip Delta <> Chain** | Toggle the position of delta and chain dimension text above/below the dimension line |

### For Loose Dimension Lines (mode=4)

| Command | Description |
|---------|-------------|
| **Add Points** | Add custom reference points to the dimension line |
| **Remove Points** | Remove custom reference points from the dimension line |
| **Add Drills** | Select additional drills to include in the dimension line |

### General Options

| Command | Description |
|---------|-------------|
| **Reset Modifications** | Restore all removed drills and reset the pattern to its original state |
| **Add Viewports** | (Block space mode) Add more ShopDrawViewports to the dimension set |
| **Remove Viewports** | (Block space mode) Remove ShopDrawViewports from the dimension set |

---

## Selection Interaction

### Jig Mode Operations

When using "Remove Drills" or "Add/Remove Points":

- **Click on a drill/point**: Select individual items
- **Click and drag left-to-right**: Create a green fence to select items fully inside
- **Click and drag right-to-left**: Create a blue fence to select any intersecting items

### Visual Feedback

| Color | Meaning |
|-------|---------|
| **Light blue circles** | Unselected drill locations |
| **Red circles** | Selected drill locations (for removal) |
| **Mini rectangle indicator** | Shows current selection mode (solid = full selection, dashed = intersection) |

---

## Formatting Tokens

### Available Properties for Format Strings

| Token | Description |
|-------|-------------|
| `@(Quantity)` | Number of drills in the pattern |
| `@(Diameter)` | Drill diameter |
| `@(Radius)` | Drill radius (half of diameter) |
| `@(PatternIndex)` | Sequential pattern number |
| `@(PatternIndex:D)` | Pattern number with leading zeros |
| `@(Depth)` | Drill depth |
| `@(Bevel)` | Bevel angle |
| `@(Angle)` | Drill angle |
| `@(AngleA)` | Primary pattern direction angle (for 2D patterns) |
| `@(AngleB)` | Secondary pattern direction angle (for 2D patterns) |
| `<>` | The actual dimension value |
| `\P` | Line break in multi-line tags |

---

## Tips and Best Practices

### Dimension Style Configuration

- Use a consistent dimension style across your drawings for professional appearance
- Set text height to 0 to inherit from the dimension style, or specify explicitly for overrides

### Pattern Detection Tuning

- Adjust "Max. Interdistance" based on your typical drill spacing patterns
- Increase the value for patterns with variable spacing
- Decrease for tight, regular patterns to avoid false pattern detection

### Working with MultiPages

- The script automatically places dimensions outside the viewport collision areas
- Dimensions are drawn in front of other entities for better visibility

### Modifying Dimensions

- Use "Remove Drills" to exclude specific drills from pattern dimensioning
- Use "Add Points" on loose dimension lines to include additional reference points
- Use "Reset Modifications" to start fresh if you've made unwanted changes

### Format String Examples

| Format | Result Example |
|--------|----------------|
| `@(Quantity)x O@(Diameter)` | "5x O12" for 5 drills of 12mm diameter |
| `[@(PatternIndex:D)]` | "[01]" for pattern number 1 |
| `O@(Diameter) x @(Depth)` | "O12 x 100" for 12mm diameter, 100mm depth |

---

## FAQ

**Q: Can I use this script on a standard beam in Model Space?**

A: Yes, you can select a GenBeam directly in Model Space to dimension its drill patterns.

**Q: What happens if I change the scale of my drawing?**

A: The script respects the MultiPage view scale. For best results in Paper Space, ensure the view scale is set correctly.

**Q: How do I restore a drill point I accidentally deleted from the dimension?**

A: Right-click the script instance and select **Reset Modifications** to restore all points to their original state.

**Q: Can I dimension multiple beams at once?**

A: Yes, select multiple GenBeams or use a MultiPage to dimension multiple elements in a coordinated way.

**Q: What is the difference between 1D and 2D pattern detection?**

A: 1D patterns detect drills arranged along a single line, while 2D patterns detect grid-based arrangements. Use the Pattern Mode setting to control which types to detect.

---

## Technical Notes

### Internal Modes

| Mode | Description |
|------|-------------|
| Mode 0 | Initial insertion and entity selection |
| Mode 1 | Pattern detection and child instance creation |
| Mode 2 | Tag mode for pattern labels |
| Mode 3 | Dimension line mode for patterns |
| Mode 4 | Loose dimension line mode |
| Mode 5 | Block space mode for ShopDrawView |

### Server-Client Architecture

- The first created instance acts as the "server" storing pattern data
- Child instances (tags, dimension lines) are "clients" that read from the server
- Modifications (removed drills) are tracked in the server's SubMapX

### Dependencies

- Requires `hsbGeoPattern.dll` for pattern detection algorithm
- Works with standard AutoCAD dimension styles
- Integrates with hsbCAD MultiPage and ShopDraw systems

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.7 | 15.03.2023 | Creation by blockspace mode improved, dimlines always drawn in front of other entities |
| 1.6 | 15.06.2022 | Supports definition in multipage blockspace for automatic model creation |
| 1.5 | 02.05.2022 | Formatting on dimlines suppressed when perpendicular to 2D pattern |
| 1.4 | 26.04.2022 | Creation by Multipage supported |
| 1.3 | 25.04.2022 | Loose drills added |
| 1.2 | 22.04.2022 | Alignment shopdrawings enhanced |
| 1.1 | 07.04.2022 | New commands to add/remove points and drill locations |
| 1.0 | 28.03.2022 | Initial version |
