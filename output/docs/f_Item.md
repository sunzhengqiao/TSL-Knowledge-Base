# f_Item - Stacking Item Creation Tool

## Overview

| Property | Value |
|----------|-------|
| **Script Name** | f_Item |
| **Type** | Object (O) |
| **Version** | 5.25 |
| **Category** | Stacking / Delivery / Nesting |
| **Supported Entity Types** | Beam, Sheet, SIP, ElementRoof, ElementWall, MassElement, MassGroup, TslInst, ChildPanel |

## Description

The **f_Item** script creates a stackable item representation of timber construction entities (panels, beams, walls, etc.) and displays them in the XY World coordinate system. This tool is essential for logistics planning, delivery organization, and truck loading visualization. Items can be grouped, ordered, and assigned to trucks for efficient material handling and shipping.

The script supports surface quality visualization, custom text formatting, and various display modes for detailed representation of construction elements in stacking views.

## Usage Environment

| Environment | Supported |
|-------------|-----------|
| Model Space | Yes |
| Paper Space | Limited (visualization output) |
| Shop Drawing | No |

## Usage Workflow

### Basic Workflow

1. **Start the Tool**: Execute the f_Item script from the TSL library
2. **Configure Selection Set**: Choose the allowed entity types from the Selection Set dropdown
3. **Select Display Options**: Choose a Display Set or create a custom Override format
4. **Select Entities**: Pick one or more entities in the drawing (beams, panels, walls, etc.)
5. **Place Items**: Click to specify the insertion point for the item visualization
6. **Items Created**: The script generates stackable item representations in XY World view

### Advanced Workflow with Grouping

When multiple entities are selected with grouping/ordering settings configured:

1. Entities are automatically grouped based on GroupBy settings
2. Items are ordered according to OrderBy settings
3. Items are arranged in a grid layout with configurable row/column offsets
4. Automatic rotation based on MaxHeight settings

## Properties Panel Parameters

### Selection Set Category

| Parameter | Type | Description |
|-----------|------|-------------|
| **Allowed Types** | Dropdown | Defines the allowed entity types for selection. Options are configured in the f_Stacking.xml settings file. |

### Display Category

| Parameter | Type | Description |
|-----------|------|-------------|
| **Display Set** | Dropdown | Selects a predefined display configuration. Options include "Disabled" or sets defined in f_Stacking.xml. Each set can define Format, DimStyle, TextHeight, and Color. |
| **Override** | String | Custom text format to display. Uses `@(PropertyName)` syntax. Separate lines with `\P`. Example: `@(PosNum)\P@(Name)` shows position number and name on two lines. |

### Alignment Category

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| **Top Face** | Dropdown | Unchanged, Higher Quality, Lower Quality | Defines the default alignment of the item if it supports quality definitions (for SIPs/panels). |

## Context Menu Options

| Command | Description |
|---------|-------------|
| **Recalc** | Recalculates the item display |
| **Rotate 90deg Z-Axis (Doubleclick)** | Rotates the item 90 degrees around the Z-axis. Also triggered by double-click. |
| **Rotate 90deg X-Axis** | Rotates the item 90 degrees around the X-axis |
| **Flip Side** | Flips the item to show the opposite face (available when quality settings allow) |
| **High Detail / Low Detail** | Toggles between detailed and simplified geometry display |
| **Show Relation / Hide Relation** | Shows/hides a visual connection line between the item and its source entity |
| **Add/Remove Format** | Opens an interactive property selector to add or remove format variables |
| **Add Override** | Adds an override format from property list |
| **Display unstacked items / Disable unstacked display** | Highlights items not assigned to a truck (shows warning overlay) |
| **Setup Ordering** | Configures ordering rules for the current selection set |
| **Setup max Height** | Sets maximum height for vertical stacking (affects rotation behavior) |
| **Block Properties / Unblock Properties** | (KLH mode) Locks/unlocks property editing |

### KLH-Specific Context Menu Options

| Command | Description |
|---------|-------------|
| **Ignore klhLiftingDeviceAdditional** | Ignores the requirement for additional lifting device validation |

## Format Variables

The Override property supports the following format syntax:

### Standard Format Syntax
```
@(PropertyName)
```

### Common Variables
- `@(Name)` - Entity name
- `@(PosNum)` - Position number
- `@(Number)` - Element number
- `@(Length)` / `@(Width)` / `@(Height)` - Dimensions
- `@(Material)` - Material specification
- `@(Weight)` - Calculated weight

### SIP/Panel-Specific Variables
- `@(SurfaceQuality)` - Combined top/bottom quality
- `@(SurfaceQualityTop)` - Top surface quality
- `@(SurfaceQualityBottom)` - Bottom surface quality
- `@(GrainDirection)` - Wood grain direction symbol
- `@(GrainDirectionText)` - "Lengthwise" or "Crosswise"
- `@(GrainDirectionTextShort)` - "Grain LW" or "Grain CW"
- `@(SipComponent.Name)` - SIP component name
- `@(SipComponent.Material)` - SIP component material
- `@(ViewSide)` - "Reference side" or "Opposite side"
- `@(CoatingCode)` - (KLH) Surface coating code

### Opening-Specific Variables
- `@(Width)` / `@(Height)` / `@(Rise)` - Opening dimensions
- `@(SillHeight)` / `@(HeadHeight)` - Vertical positions
- `@(Description)` / `@(Type)` - Opening information

### Special Variables
- `@(Calculate Weight)` - Calculates and displays the entity weight in kg

## Settings Configuration (f_Stacking.xml)

The script reads settings from `f_Stacking.xml` located in the Company or Install settings folder:

### Selection Set Configuration
```xml
<Item>
  <SelectionSet[]>
    <SelectionSet>
      <Name>All Types</Name>
      <AllowedClass[]>
        <String>BEAM</String>
        <String>SHEET</String>
        <String>SIP</String>
        <!-- ... more classes -->
      </AllowedClass[]>
      <GroupBy[]><!-- Grouping rules --></GroupBy[]>
      <OrderBy[]><!-- Ordering rules --></OrderBy[]>
      <MaxHeight>3000</MaxHeight>
    </SelectionSet>
  </SelectionSet[]>
</Item>
```

### Display Set Configuration
```xml
<Item>
  <Set[]>
    <Set>
      <Name>Standard</Name>
      <Format>@(PosNum)\P@(Name)</Format>
      <DimStyle>Standard</DimStyle>
      <TextHeight>100</TextHeight>
      <Color>7</Color>
      <HighDetail>1</HighDetail>
    </Set>
  </Set[]>
</Item>
```

### Surface Quality Visualization
```xml
<Item>
  <SurfaceQuality[]>
    <SurfaceQuality>
      <Name>WSI</Name>
      <Color>1</Color>
      <Transparency>50</Transparency>
    </SurfaceQuality>
  </SurfaceQuality[]>
</Item>
```

### Grid Configuration
```xml
<Item>
  <Grid>
    <RowOffset>1000</RowOffset>
    <ColumnOffset>1000</ColumnOffset>
    <MaxWidth>20000</MaxWidth>
  </Grid>
</Item>
```

## Validation and Error Handling

The script performs several validations:

| Validation | Behavior |
|------------|----------|
| **Already Stacked** | Entities already associated with an item are refused |
| **Invalid Solid** | Entities without valid geometry are skipped |
| **Element with Stacked GenBeams** | Elements containing already-stacked beams are refused |
| **Truck/Item Stacking** | Trucks and items cannot be stacked together |
| **Duplicate Detection** | Duplicate item references are automatically erased |
| **KLH Lifting Device** | (KLH mode) Bottom plates with refinement codes require klhLiftingDeviceAdditional |

## Special Features

### KLH Integration

When the project special identifier is "KLH", additional features are enabled:

- Automatic property locking for production control
- Layer separation text (Lagentrennung) display
- Coating code visualization with magenta color
- Surface quality-based text coloring
- Reference side positioning for R and F panel types
- Integration with klhLiftingDevice and klhDisplay TSLs

### Quality-Based Display

For SIPs with surface quality definitions:
- Contact faces are colored based on quality settings
- Top face alignment can be set to higher or lower quality
- Quality colors are mapped from settings configuration

### Truck Integration

Items can be validated against truck assignments:
- `TruckValidationProperty` in settings defines source property
- Items not assigned to trucks show warning overlay
- Mismatched truck numbers are highlighted

## Tips and Best Practices

1. **Use Display Sets**: Create predefined display sets in f_Stacking.xml for consistent documentation across projects

2. **Group Large Selections**: When creating items from many entities, configure GroupBy and OrderBy settings for organized output

3. **MaxHeight Configuration**: Set appropriate MaxHeight values to control automatic rotation behavior for tall items

4. **Surface Quality Setup**: Configure SurfaceQuality colors in settings for visual quality inspection in stacking views

5. **Format Variables**: Use the "Add/Remove Format" context menu to interactively explore available properties

6. **Detail Level**: Use "Low Detail" mode for faster regeneration with complex geometries

7. **Show Relation**: Enable "Show Relation" to verify item-to-source connections during setup

8. **KLH Production**: In KLH mode, properties are locked by default - use "Unblock Properties" only when modifications are needed

## Related Scripts

- **f_Truck** - Truck/package creation and management
- **f_Layer** - Layer separation configuration
- **hsbGrouping.dll** - Entity grouping and ordering logic
- **klhLiftingDevice** - Lifting device positioning (KLH)
- **klhLiftingDeviceAdditional** - Additional lifting requirements (KLH)
- **klhCoating** - Surface coating configuration (KLH)
- **klhDisplay** - Display configuration (KLH)

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 5.25 | 03.11.2025 | Support for previous styles TT, TL |
| 5.24 | 17.10.2025 | Changed TT to DQ, TL to DL |
| 5.23 | 26.05.2025 | V5.11 only applied on creation |
| 5.22 | 26.03.2025 | Added ViewSide variable for SIPs |
| 5.21 | 24.02.2025 | KLH: Compose body from array of bodies |
| 5.20 | 10.02.2025 | KLH: Magenta color for Oberflachenveredelung |
| 5.19 | 03.02.2025 | Fix transformation for klhCombiTruck |
| 5.18 | 13.01.2025 | Support for klhCombiTruck TSLs |
| 5.17 | 09.12.2024 | Conditional klhLiftingDeviceAdditional ignore command |
| 5.16 | 04.12.2024 | Check for klhLiftingDeviceAdditional |
| 5.15 | 21.10.2024 | DataLink reference to reference entity |
| 5.14 | 05.08.2024 | KLH: Added @(CoatingCode) format |
| 5.13 | 05.10.2023 | KLH: Text color from highest quality |
