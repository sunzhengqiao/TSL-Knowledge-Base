# ToolTag.mcr

## Overview
This script annotates machining operations (tools) on shop drawings with customizable labels and visual indicators. ToolTag automatically places text labels and shape highlights on timber member shop drawings to identify and describe machining operations such as drills, mortises, slots, beam cuts, housings, and free profiles. This helps fabrication personnel quickly identify required operations by displaying formatted tool information directly on the drawing views.

The script supports multiple display modes, grouping of similar tools, customizable formatting, and integration with the hsbCAD painter filter system for advanced tool selection criteria.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Select GenBeams or MultiPages directly to generate tool tags. |
| Paper Space | Yes | Not primary use case; works through MultiPage views. |
| Block Space | Yes | Primary use case for shop drawing block definitions. Select ShopDrawView viewports to tag. |

## Prerequisites
- **Required Entities**: `ShopDrawView`, `MultiPage`, or `GenBeam` with analyzed tooling operations.
- **Minimum Beam Count**: 0 (GenBeam referenced through MultiPage or directly selected).
- **Optional**: Painter filter definitions in folder `TSL\ToolTag\` for advanced filtering.
- **Required Settings**: A valid `DimStyle` must exist in the drawing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` then select `ToolTag.mcr` from the list.

### Step 2: Context-Dependent Workflow

**If in Block Space (Shop Drawing Block Definition):**
1. A dialog appears to select a catalog entry or choose "New Definition".
2. If creating a new definition, configure tool types, filters, and display formats in the Tool Selection dialog.
3. **Command Line**: `Select shopdraw viewports`
4. **Action**: Select one or more ShopDrawView viewports to tag.
5. **Command Line**: `Select location of setup information`
6. **Action**: Pick a location for the configuration summary table.

**If in Model Space with MultiPages:**
1. **Command Line**: `Select genbeams or multipages`
2. **Action**: Select one or more MultiPage entities.
3. **JIG Display**: A preview shows available orthogonal views.
4. **Command Line**: `Select view`
5. **Action**: Click to select which view to annotate.
6. The Tool Selection dialog appears to configure tagging rules.
7. Adjust display options in the standard dialog, then confirm.

**If in Model Space with GenBeams:**
1. **Command Line**: `Select genbeams or multipages`
2. **Action**: Select GenBeam entities with analyzed tools.
3. A dialog appears to configure tool type and display settings.
4. Tags are created for each matching tool on the selected beams.

### Step 3: Modify After Insertion
- Drag the tag grip to reposition the label.
- Right-click to access context menu options for modifying settings.

## Properties Panel Parameters

### General Category
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tool Type | dropdown | (first) | The machining operation type to tag. Options include Drill, Beamcut, Housing Tool, Mortise, Slot, and Free Profile with various subtypes. Use wildcards like "Drill *" to match all subtypes. |
| Parent Tool Filter | dropdown | Disabled | Filters tools by their parent TSL instance or tool entity. Uses painter definitions from `TSL\ToolTag\` folder. |
| Tool Filter | dropdown | Disabled | Filters tools by their properties (depth, diameter, face index, etc.). Special options: "Disabled" (no filter), "ByLocation" (closest tool to insertion point). |

### Format Category
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Format | text | (empty) | Format string for the tag text. Supports placeholders like `@(Depth:D)`, `@(Diameter:D)`, `@(DepthInView:D)`, `@(Quantity)`. |

### Display Category
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Style | dropdown | Text Label | Visual appearance of the tag. Options: Text Label, Text only, Text Label + Shape, Text only + Shape, Shape only. |
| Leader Style | dropdown | All | Leader line visibility. Options: All (on all grouped instances), Primary Only (first tool only), None (no leaders). |
| DimStyle | dropdown | (first) | Dimension style for text formatting. |
| Text Height | number | 0 | Text height override in drawing units. 0 = use DimStyle setting. |
| Color | integer | 72 | Color index for the tool tag and shape fill. |
| Transparency | integer | 0 | Transparency level (0-100) for shape fill. 0 = opaque. |

## Format Placeholders

The Format parameter supports these placeholders for tool properties:

| Placeholder | Description | Tool Types |
|-------------|-------------|------------|
| `@(Depth:D)` | Tool penetration depth | All |
| `@(DepthInView:D)` | Depth visible in current view orientation | All (when applicable) |
| `@(Diameter:D)` | Hole diameter | Drill |
| `@(Radius:D)` | Hole radius | Drill |
| `@(Angle:D)` | Tool approach angle | Drill, Beamcut, Housing, Mortise, Slot |
| `@(Bevel:D)` | Bevel angle | Drill, Beamcut, Housing, Mortise, Slot |
| `@(Twist:D)` | Twist angle | Beamcut, Housing, Mortise, Slot |
| `@(WidthInView:D)` | Width dimension in view | Beamcut |
| `@(LengthInView:D)` | Length dimension in view | Beamcut |
| `@(MillDiameter:D)` | Mill tool diameter | Free Profile |
| `@(DefiningLength:D)` | Total contour length | Free Profile |
| `@(Quantity)` | Number of grouped tools (shows "Nx " prefix when >1) | All |
| `@(FaceIndex)` | Face orientation (-3 to 3 for Z/Y/X faces) | All |
| `@(IsThrough)` | Whether tool passes completely through | Drill, Beamcut, Slot, Housing |
| `@(SubType)` | Tool subtype identifier | All |
| `@(Type)` | Tool type name | All |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Tool Tag Settings | Opens the tool selection dialog to modify which tools are tagged and their display formats. |
| Leader Style (toggle) | Cycles through leader line visibility options: All, Primary Only, None. |
| Add View | (Block Space only) Add additional ShopDrawView viewports to the tagging scope. |
| Remove View | (Block Space only) Remove the current viewport from tagging scope. |

## Tool Selection Dialog

When configuring tool rules (via "New Definition" or "Tool Tag Settings"), a grid dialog allows defining multiple tagging rules:

| Column | Description |
|--------|-------------|
| Active | Enable/disable this tagging rule. |
| Tool Description | The tool type to match (e.g., "Drill *" for all drills, or a specific subtype). |
| Parent Filter | Painter definition to filter by parent TSL/tool entity source. |
| Tool Filter | Painter definition to filter by tool geometric properties. |
| Display Format | Format string for this specific tool type. |
| Color | Display color index for matched tools. |
| Transparency | Fill transparency (0-100) for shape display. |

## Supported Tool Types

### Drill Subtypes
Perpendicular, Rotated, Tilted, Head, 5-Axis

### Beamcut Subtypes
Seat Cut, Rising Seat Cut, Open Seat Cut, Lap Joint, Birdsmouth, Reversed Birdsmouth, Closed Birdsmouth, Diagonal Seat Cut, Open Diagonal Seat Cut, Blind Birdsmouth, Housing, Housing Throughout, House Rotated, House Tilted, Japanese Hip Cut, Hip Birdsmouth, Valley Birdsmouth, Rising Birdsmouth, Housed 5-Axis, Simple Housing, Rabbet, Dado, 5-Axis, 5-Axis Birdsmouth, 5-Axis Blind Birdsmouth

### Housing Tool Subtypes
Simple, Perpendicular, Rotated, Tilted, 5-Axis, Head Perpendicular, Head Simple Angled, Head Simple Angled Twisted, Head Simple Beveled, Head Compound, Tenon Perpendicular, Tenon Simple Angled, Tenon Simple Angled Twisted, Tenon Simple Beveled, Tenon Compound

### Mortise Subtypes
Simple, Perpendicular, Rotated, Tilted, 5-Axis, Head Perpendicular, Head Simple Angled, Head Simple Angled Twisted, Head Simple Beveled, Head Compound

### Slot Subtypes
Perpendicular, Rotated, Tilted, 5-Axis

### Free Profile Subtypes
Perpendicular, 5-Axis

## Settings Files
- **Filename**: Catalog entries stored in drawing
- **Location**: TSL catalog system within the drawing
- **Painter Definitions**: `TSL\ToolTag\` folder in hsbCAD company/install paths
- **Purpose**: Painter definitions provide reusable filter criteria for tool selection

## Tips
- **Use wildcard tool types**: Select "Drill *" or "Beamcut *" to match all subtypes of a tool category rather than specifying each subtype individually.
- **ByLocation filter mode**: When Tool Filter is set to "ByLocation", the tag follows the insertion point and finds the closest matching tool. This is useful for manually positioning tags on specific tools.
- **Quantity grouping**: Include `@(Quantity)` in your format string to show how many identical tools are grouped under one tag. The script automatically groups tools with matching properties.
- **DepthInView property**: Use `@(DepthInView:D)` instead of `@(Depth:D)` when the view orientation differs from the tool direction. This shows the depth component visible in the current view.
- **Painter filters**: Create custom painter definitions in the `TSL\ToolTag\` folder to build reusable filter criteria for specific tool selection scenarios.
- **Drag the tag**: Grip the tag label to reposition it. A leader line automatically appears when the tag is moved away from the tool shape.
- **Catalog presets**: Save frequently used configurations as catalog entries for quick reuse across multiple drawings.
- **Block space workflow**: When working in block space, the script creates instances automatically when the shop drawing is generated. Configure once in the block definition and it applies to all instances.
- **Text height override**: Set Text Height to 0 to inherit the height from the selected dimension style, ensuring consistency with other annotations.

## FAQ
- **Q: Why are no tools being tagged?**
  **A**: The selected GenBeam may not have analyzed tools, or the filter criteria may be too restrictive. Check that the beam has machining operations applied and try setting filters to "Disabled" to see all available tools.

- **Q: How do I tag only drills on a specific face?**
  **A**: Create a painter definition in `TSL\ToolTag\` that filters by FaceIndex property, then select that filter in the Tool Filter dropdown.

- **Q: Why does the tag show "Nx" prefix?**
  **A**: When multiple identical tools are grouped together, the Quantity placeholder displays the count. If you don't want grouping, remove `@(Quantity)` from the format string.

- **Q: Can I tag tools from multiple beams on one MultiPage?**
  **A**: The script tags tools from the defining GenBeam of each MultiPage view. For multi-beam assemblies, each beam requires its own tagging setup.

- **Q: What is the difference between Parent Filter and Tool Filter?**
  **A**: Parent Filter selects tools based on their source (which TSL or tool entity created them). Tool Filter selects tools based on their geometric properties (diameter, depth, face index, etc.).
