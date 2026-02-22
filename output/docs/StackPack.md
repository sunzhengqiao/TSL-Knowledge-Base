# StackPack

## Overview

**StackPack** is a packaging and logistics management tool in hsbCAD that allows users to group multiple StackItem entities into organized transport packages. It provides visual representation of packages with customizable dimensions, color coding, layer management, and formatting options for fabrication and logistics planning.

StackPack is part of the hsbCAD Stacking System, which includes:
- **StackItem** - Individual items (elements, beams, panels) prepared for stacking
- **StackPack** - Groups of StackItems organized into packages (this script)
- **StackEntity** - The parent container (truck/trailer) that holds multiple StackPacks

This hierarchical system enables complete logistics planning from individual components through packages to final transport loads.

## Script Metadata

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object) |
| Beams Required | 0 (None) |
| Points Grip | 0 (Dynamic based on shape) |
| Major Version | 3 |
| Minor Version | 4 |
| Last Updated | April 10, 2025 |
| Author | Thorsten Huck |
| DxaOut | 1 |
| ImplInsert | 1 |

### Version History

| Version | Date | Ticket | Description |
|---------|------|--------|-------------|
| 3.4 | 10.04.2025 | HSB-23577 | New command to rotate a package |
| 3.3 | 12.02.2025 | HSB-23372 | Fully supporting new behaviour of controlling properties |
| 3.2 | 19.12.2024 | HSB-23169 | Pack height fixed |
| 3.1 | 22.11.2024 | HSB-21733 | Supports relocation of attached spacers when moved, Z-Filter bugfix |
| 3.0 | 24.09.2024 | HSB-22717 | Element references improved |
| 2.9 | 17.09.2024 | HSB-21161 | Debug messages removed |
| 2.8 | 22.08.2024 | HSB-21998 | Settings introduced to enable custom color coding |
| 2.7 | 16.08.2024 | HSB-21677 | Jigging items improved |
| 2.6 | 02.08.2024 | HSB-22468 | Visibility improved, dragging in plan view turns Z-filtering on |
| 2.5 | 17.07.2024 | HSB-21811 | New property 'Number' added for formatting and unique numbering |
| 2.4 | 21.06.2024 | HSB-22001 | New command to toggle between raw and shrink package size |
| 2.3 | 03.06.2024 | HSB-21677 | Drag jigs made more transparent |
| 2.2 | 10.05.2024 | HSB-21994 | Item list ordered by layer index |
| 2.1 | 08.01.2024 | HSB-20285 | Tag does not contribute to snap points |
| 2.0 | 22.12.2023 | HSB-20893 | Catching tolerance issue in hidden mode |
| 1.7 | 24.11.2023 | HSB-20724 | Supports automatic layer nesting as context command |
| 1.3 | 18.10.2023 | HSB-19659 | First beta release |
| 1.0 | 29.09.2023 | HSB-19659 | Initial version |

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary usage for organizing and visualizing 3D stacks of timber elements |
| Paper Space | No | Not intended for 2D layout or drawing generation |
| Shop Drawing | No | Items can be hidden in shop drawings using Item Mode property |

## Prerequisites

Before using StackPack:

1. **StackItem entities must exist** - Create StackItem instances from elements, beams, or panels that you want to package together
2. **TslUtilities.dll** - Must be available in the hsbCAD Utilities path for dialog functionality:
   - Path: `[Install]\Utilities\DialogService\TslUtilities.dll`
   - Class: `TslUtilities.TslDialogService`
3. **Settings file (optional)** - The script reads configuration from `StackEntity.xml` located in:
   - Company path: `[Company]\TSL\Settings\StackEntity.xml`
   - Installation path: `[Install]\Content\General\TSL\Settings\StackEntity.xml`

## Step-by-Step Usage Guide

### Creating a New Package

1. **Launch the script** using the command:
   ```
   Command: TSLINSERT
   Action: Browse and select 'StackPack.mcr'
   ```
   Or use the AutoLISP command: `(hsb_ScriptInsert "StackPack")`

2. **Configure initial properties** in the dialog:
   - Set a Description for the package
   - Define Length, Width, and Height (or leave at 0 for automatic sizing based on content)
   - Set Spacer Height if spacers will be used under the package
   - Configure display format and text settings

3. **Place the package** by clicking the insertion point in the drawing:
   ```
   Command Line: Select insertion point
   Action: Click in Model Space to define the location for the package
   ```

4. **Add items to the package** using the right-click context menu "Add Items" command.

### Adding Items to a Package

1. Select the StackPack entity
2. Right-click and choose **Add Items**
3. Select the StackItem entities you want to add to the package
4. Pick the target location within the package (or press Enter to keep current positions)

### Adding Nested Items (Automatic Arrangement)

1. Select the StackPack entity
2. Right-click and choose **Add Nested Items**
3. Select the StackItem entities to be automatically arranged
4. Items will be nested using the built-in rectangular nesting algorithm
5. The system automatically:
   - Groups items by their painter definition format
   - Sorts items based on ascending/descending order
   - Arranges items to optimize space within the package

### Removing Items from a Package

1. Select the StackPack entity
2. Right-click and choose **Remove Items**
3. Select the items to remove
4. Pick a new location for the removed items (or press Enter to keep at current position)
5. Removed items are automatically released from the parent relationship

### Moving and Repositioning

- **Drag grips** - Use the location grips (circles at shape vertices) to reposition the package
- **Model view dragging** - Drag in 3D view; Z-filtering is automatically enabled in plan view
- **Sectional view dragging** - Use sectional grips for X/Y/Z plane repositioning
- **Rotate** - Right-click and select "Rotate" to rotate the package and all its contents
- **Toggle size display** - Double-click or use "Show shrink pack/Show raw pack" to toggle between actual content dimensions and user-defined dimensions

### Rotating a Package

1. Select the StackPack entity
2. Right-click and choose **Rotate**
3. The rotation jig appears with interactive controls:
   - **Pick point to rotate** - Move cursor around the center to set rotation angle
   - **[Angle]** - Type a specific angle value in degrees
   - **[Basepoint]** - Select a new rotation center from vertex or edge midpoints
4. Distance from center determines angle snapping:
   - Inside circle: 45-degree snaps
   - 0.5x diameter: 22.5-degree snaps
   - 1.0x diameter: 10-degree snaps
   - 1.5x diameter: 5-degree snaps
   - 2.0x diameter and beyond: 1-degree precision

## Properties Panel Parameters

| Parameter | Type | Default | Category | Description |
|-----------|------|---------|----------|-------------|
| Description | String | (empty) | General | User-defined description for the package |
| Number | Integer | 0 (Auto) | General | Unique package number. Value of 0 auto-assigns the next available number. Modifying this shifts other package numbers accordingly. Setting controls other properties. |
| Item Mode | Dropdown | Edit | General | Controls item visibility: **Edit** (normal editing), **Hidden** (items hidden), **Hide in Shopdrawing** (visible in model, hidden in shop drawings) |
| Length | Length | 0 | Geometry | Package length. 0 = automatically sized to content. Setting controls other properties. |
| Width | Length | 0 | Geometry | Package width. 0 = automatically sized to content. Setting controls other properties. |
| Height | Length | 0 | Geometry | Package height. 0 = automatically sized to content. Setting controls other properties. |
| Spacer Height | Length | 0 | Alignment | Height of spacer blocks under the package for stacking. Changing this moves the package vertically. |
| Format | String | `Package @(Description:D) @(Number:D)\n@(Data.weight:D'0':CU;m:RL2)to` | Display | Text format for the package label. Supports formatting tags. Use `\n` for line breaks. |
| Dimstyle | Dropdown | (varies) | Display | AutoCAD dimension style for text display |
| Text Height | Length | 100mm | Display | Height of displayed text. 0 = use dimension style default |

### Item Mode Options

| Mode | Description |
|------|-------------|
| Edit | Normal mode - items are visible and editable |
| Hidden | Items are completely hidden from view |
| Hide in Shopdrawing | Items visible in model view but hidden in shop drawings |

### Format String Syntax

The Format property supports special formatting tags:

| Tag | Description |
|-----|-------------|
| `@(Description:D)` | Package description |
| `@(Number:D)` | Package number |
| `@(Data.weight:D'0':CU;m:RL2)` | Total weight with unit formatting |
| `@(Data.Volume:D)` | Total volume |
| `@(Data.QuantityItems:D)` | Number of items |
| `@(Data.ItemList:D)` | Comma-separated list of item position numbers |
| `@(StackEntity_Description:D)` | Parent truck description |
| `\n` | Line break |

**Note:** Legacy syntax `@(StackData...)` has been renamed to `@(Data...)`. The script automatically corrects old format strings.

## Right-Click Menu Options

### Root-Level Commands

| Command | Description |
|---------|-------------|
| **Add Items** | Select StackItem entities to add to this package. A jig allows positioning items within the package. Released items are automatically detached from their previous parent. |
| **Add Nested Items** | Add items for automatic nesting/arrangement within the package using the rectangular nesting algorithm |
| **Remove Items** | Select and remove items from the package. Removed items can be repositioned outside the package. |
| **Show shrink pack / Show raw pack** | Toggle between displaying user-defined dimensions (raw) and actual content dimensions (shrink). Also activated by double-clicking. |
| **Rotate** | Rotate the package and all contained items. Options include: angle input, basepoint selection, and snap-to-grid angles based on cursor distance. |

### Settings Commands (Under Settings submenu)

| Command | Description |
|---------|-------------|
| **Display Settings** | Configure component display properties (color, transparency, linetype) - Opens a dynamic dialog with table-style controls |
| **Color Rules** | Configure how items and packages are color-coded: by Layer, by Pack Number, or by Stack Layer |
| **Import Settings** | Load settings from the XML configuration file |
| **Export Settings** | Save current settings to the XML configuration file |

## Settings File Configuration

The StackPack reads settings from `StackEntity.xml`. Key configuration sections:

**File Locations:**
- Company path: `[Company]\TSL\Settings\StackEntity.xml`
- Installation path: `[Install]\Content\General\TSL\Settings\StackEntity.xml`

### Item Settings
```xml
<lst nm="Item">
  <int nm="ColorRule" vl="0"/>  <!-- 0=byLayer, 1=byPackNumber, 2=byStackLayer -->
</lst>
```

### Pack Settings
```xml
<lst nm="Pack">
  <int nm="ColorRule" vl="1"/>  <!-- Color rule for packages (1=byPackNumber, 2=byStackLayer) -->
  <int nm="ColorPack" vl="..."/>  <!-- Default pack color -->
</lst>
```

### Transparency Settings
```xml
<lst nm="Pack\NotStacked">
  <int nm="TransparencyWire" vl="60"/>
  <int nm="TransparencyFill" vl="60"/>
</lst>
<lst nm="Pack\Stacked">
  <int nm="TransparencyWire" vl="60"/>
  <int nm="TransparencyFill" vl="99"/>
</lst>
```

### Sequential Colors
Define custom colors for sequential package numbering:
```xml
<lst nm="Pack\SequentialColor[]">
  <int nm="Color" vl="1"/>
  <int nm="Color" vl="2"/>
  <!-- Additional colors cycle automatically -->
</lst>
```

## Color Rules

The script supports three color coding strategies:

| Rule | Value | Description |
|------|-------|-------------|
| **by Layer** | 0 | Items colored based on their layer index within the package |
| **by Pack Number** | 1 | Items colored based on the package's sequential number |
| **by Stack Layer** | 2 | Items colored based on their position in the parent StackEntity |

## Parent-Child Relationships

StackPack maintains bidirectional relationships with other stacking entities:

### As Child (to StackEntity)
- Stores parent reference in `subMapX("hsb_TruckChild")`
- Contains `ParentHandle` and `ParentUid` keys
- Automatically released when dragged outside parent
- Automatically assigned when dropped onto new StackEntity

### As Parent (to StackItem)
- Stores child references in `_Entity` array
- Each child has `subMapX("hsb_PackageChild")` with relative coordinates
- Layer indices stored in child's map: `LayerIndexPack`, `LayerSubIndexPack`
- Data link stored in child's referenced entity: `subMapX("DataLink")`

## Data Export

StackPack stores the following data in a subMapX named "Data" for use in reports and formatting:

| Data Field | Type | Description |
|------------|------|-------------|
| QuantityItems | Integer | Number of items in the package |
| Weight | Double | Total weight of package contents (no unit) |
| Volume | Double | Total volume of package contents |
| Length | Double | Actual package length |
| Width | Double | Actual package width |
| Height | Double | Actual package height |
| COG | Point3d | Center of gravity point |
| ItemList | String | Text list of contained items (ordered by layer) |

Access these in format strings using: `@(Data.weight:D)`, `@(Data.Volume:D)`, etc.

## Display and Visualization

### View-Dependent Display
- **Plan view (Z-parallel)**: Uses `dpPlan` display with addViewDirection for Z axis
- **Model view**: Uses `dpModel` display with hideDirection for Z axis
- **Sectional views**: Separate display for X, Y, Z sectional grips

### Transparency Behavior
- **Not Stacked**: Wire transparency 60%, Fill transparency 60%
- **Stacked (has items)**: Wire transparency 60%, Fill transparency 99%

### Shape Visualization
- Three orthogonal profiles stored: `ShapeX`, `ShapeY`, `ShapeZ`
- Snap profile stored for intersection detection
- Raw pack vs shrink pack toggle available

## Tips and Best Practices

1. **Auto-numbering**: Leave the Number property at 0 during creation to let the system automatically assign the next available number. The system maintains unique numbering across all packages.

2. **Package sizing**: Set dimensions to 0 for automatic sizing based on content. Use explicit dimensions when you need a fixed package size regardless of contents.

3. **Spacer workflow**: Set Spacer Height before placement if your packages will be stacked with spacers. The insertion point accounts for spacer height automatically. Changing spacer height later moves the entire package.

4. **Rotation precision**: When rotating packages, move the cursor further from the center point for finer angle control (down to 1-degree increments). Closer to center snaps to larger angles (45, 22.5, 10, 5 degrees).

5. **Visibility modes**: Use "Hide in Shopdrawing" mode for packages that should be visible during design but not appear on fabrication drawings.

6. **Format strings**: Customize the Format property to show relevant package information. Use `\n` for line breaks in multi-line labels.

7. **Performance**: For large assemblies, the script uses envelope bodies rather than detailed geometry for better performance.

8. **Color coding**: Use the Color Rules feature to quickly identify which items belong to which shipping layer or package directly in the 3D model.

9. **Share settings**: Save your preferred configuration using Export Settings and use Import Settings to apply the same standards to other StackPack instances in the project.

10. **Nesting workflow**: For best results with Add Nested Items, ensure your StackItems have proper painter definitions assigned for grouping.

11. **Grip behavior**: Location grips automatically filter Z-movement in plan view. Use sectional grips (X_, Y_, Z_ prefixed) for precise positioning in 3D.

12. **Tag positioning**: The tag grip allows repositioning the label independently of the package location.

## Frequently Asked Questions

**Q: Why are my items not showing in the package?**
A: Check the Item Mode property. If set to "Hidden", items will not be visible. Also verify the items are actually StackItem entities (not raw beams or elements).

**Q: How do I move a package to a different StackEntity (truck)?**
A: Use the location grips to drag the package. When released over a different StackEntity, the package will be automatically reassigned to the new parent.

**Q: Can I have multiple packages with the same number?**
A: No. The system automatically maintains unique numbering. If you manually set a number that already exists, other packages are automatically renumbered (incremented) to maintain uniqueness.

**Q: Why does my package change size when I add/remove items?**
A: If Length, Width, or Height are set to 0, the package automatically sizes to fit its contents. Set explicit dimensions if you need a fixed size.

**Q: How do I change the color of the beams in the stack?**
A: Select the StackPack object, open the Properties Palette (Ctrl+1), and look at the Color Rule options. Alternatively, right-click and select "Color Rules" from the Settings submenu.

**Q: Can I share my stack settings with a colleague?**
A: Yes. Right-click the StackPack object, choose "Export Settings" from the Settings submenu to create an XML file, and send it to your colleague. They can then use "Import Settings" to load your configuration.

**Q: Why didn't the script generate a stack?**
A: Ensure you have StackItem entities in your model first. StackPack groups StackItems, not raw beams or elements directly. Use StackItem to prepare your elements first.

**Q: What happens when I copy a package?**
A: The copied package automatically receives a new unique number (duplicate numbers trigger auto-renumbering). Contained items are also copied with their relationships preserved.

**Q: Why is the package label not visible?**
A: Check the Text Height property (0 uses dimstyle default) and ensure the Format string contains valid formatting tags. Also verify the Dimstyle exists in the drawing.

**Q: How does the nesting algorithm work?**
A: The Add Nested Items command uses a rectangular nesting algorithm that groups items by painter definition, sorts them by the specified order, and iteratively attempts to fit them within the package bounds. If the initial area is insufficient, it automatically expands the nesting area.

**Q: What is the difference between "raw pack" and "shrink pack"?**
A: "Raw pack" displays the user-defined dimensions (Length/Width/Height properties). "Shrink pack" displays the actual bounding box of the contained items. Double-click to toggle between modes.

## Related Scripts

- **StackItem** - Create individual stackable items from elements/beams
- **StackEntity** - Create truck/trailer containers for packages
- **StackSpacer** - Add spacer blocks between packages (supports "Items in Pack", "Pack to Pack", and "Entire Stack" relations)
- **StackCreator** - Batch creation of stack items
- **StackSequencer** - Manage package sequencing and numbering
- **StackAxle** - Axle load calculations for transport
- **StackHatch** - Hatching for stack visualizations

## Technical Notes

### Coordinate Systems
The script maintains three orthogonal coordinate systems for sectional views:
- `csX`: YZ plane (width/height view)
- `csY`: XZ plane (length/height view)
- `csZ`: XY plane (length/width view - plan)

### Nesting Parameters
- `dDuration`: 1 second allowed runtime
- `dNestRotation`: 360 degrees (no rotation restriction)
- `bNestInOpening`: false
- Nesting area is dynamically expanded up to 10 iterations if needed

### Dependency Tracking
- Items are tracked via `setDependencyOnEntity()`
- Settings are tracked via `setDependencyOnDictObject()`
- Spacers with "Items in Pack" relation move with the package
