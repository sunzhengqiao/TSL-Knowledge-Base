# hsbLayoutEntityTag

## Overview

| Property | Value |
|----------|-------|
| **Script Name** | hsbLayoutEntityTag |
| **Type** | O (Object) |
| **Version** | 1.9 |
| **Category** | Layout / Paper Space Tagging |
| **Author** | thorsten.huck@hsbcad.com |
| **Last Updated** | 20 Oct 2020 |
| **Keywords** | Layout, Tag, Badge, Number, Description, Label |

**hsbLayoutEntityTag** is a Paper Space tagging tool that creates position number tags (PosNum tags) on layout sheets by looking through viewports into Model Space. It generates collision-free labels for structural entities such as beams, sheets, panels (SIPs), GenBeams, TSL instances, openings, doors, windows, and window assemblies. The script features an intelligent clash detection algorithm that automatically repositions overlapping tags so that every label remains readable and does not obscure other tags or geometry.

The tag content is fully customizable using format instructions written with the `@(<PROPERTY>)` syntax (for example, `@(Length)`, `@(PosNum)`, or `@(Material)`). When no explicit format is specified, the script defaults to displaying the PosNum for beams, sheets, panels, and GenBeams, the script name for TSL instances, or the width and height for openings. Multiple tag styles are available, including plain text, text with a leader line, bordered text, and filled frames, all with optional leader lines pointing to the tagged entity.

Multiple instances of this script can coexist on the same viewport. Each instance is assigned a priority based on its creation time, and the clash detection system respects the tag placement of higher-priority instances, ensuring that later tags do not overlap earlier ones.

## Usage Environment

| Environment | Supported | Notes |
|-------------|-----------|-------|
| Model Space | No | Entities are read from Model Space via viewports, but the script itself lives in Paper Space |
| Paper Space | **Yes** | Primary operating environment -- must be placed on a layout containing at least one viewport |
| Shop Drawing | **Yes** | Designed for annotating production and fabrication drawings with part labels |

## Prerequisites

- **Required Entities**: At least one Viewport on the current Paper Space layout. The viewport can be either an hsbCAD Element Viewport (linked to a wall, floor, or roof element) or a standard AutoCAD (ACA) viewport.
- **Minimum Beam Count**: 0 -- the script works with beams, sheets, SIPs, GenBeams, TSL instances, openings, doors, windows, and window assemblies.
- **Catalog Entries (optional)**: Pre-configured catalog entries can be created and recalled during insertion to quickly apply standard tagging configurations.
- **hsbCAD Element or Manual Selection**: For Element Viewports, entities are collected automatically from the element. For non-element viewports, entities must be added manually using the right-click context menu.

## Usage Steps

### Step 1: Launch the Script

Run the `TSLINSERT` command in AutoCAD and select **hsbLayoutEntityTag** from the script browser. Alternatively, if assigned to a toolbar button or ribbon command, click the corresponding shortcut.

If a catalog entry name is passed as the execute key, the script will automatically load that preset configuration. Otherwise, a dialog appears to let you choose from available catalog entries. If no matching catalog entry is found, the last-inserted configuration is loaded as a fallback.

### Step 2: Select a Viewport

```
Command Prompt: "Select a viewport"
Action:         Click on the viewport frame in Paper Space that displays the Model Space entities
                you want to tag.
```

The selected viewport determines which entities are visible and eligible for tagging. If the viewport is an hsbCAD Element Viewport, the script automatically knows which element (wall, floor, roof) is associated and can collect entities from that element directly.

### Step 3: Pick an Insertion Point

```
Command Prompt: "Pick a point outside of paperspace"
Action:         Click any location in Paper Space to place the script's origin point.
```

This insertion point serves as the reference location for the script's control text and status display. The actual tag positions are calculated dynamically based on entity locations within the viewport.

### Step 4: Configure Properties

After insertion, open the **Properties Palette (OPM)** to review and adjust the tagging parameters. Key settings include:

- **Type**: What kind of entities to tag (Beam, Sheet, Panel, GenBeam, TSL, Opening, Door, Window, Window Assembly, or byZone).
- **Format**: The text format expression that controls what information appears on each tag.
- **Style**: The visual style of the tag (text only, with leader, bordered, filled frame, etc.).
- **Behaviour**: Whether the script automatically assigns PosNums and sets dependencies.

### Step 5: Add Entities (for Non-Element Viewports)

When using a standard (non-hsbCAD) viewport, entities are not automatically collected. Use the right-click context menu to add entities:

1. Right-click the script instance to open the context menu.
2. Select **Add entities** to switch into Model Space.
3. Select the desired entities (beams, sheets, openings, etc.) according to the current Type setting.
4. Press Enter or Escape to confirm and return to Paper Space.

### Step 6: Review and Adjust

The script automatically places tags on each entity with intelligent clash detection. If tags overlap or need repositioning:

- Use the **Set Leader Offset** context command to adjust the distance between the entity and its tag label.
- Use **Add No-Tag Area** to define rectangular zones where tags must not be placed.
- Use **Add/Remove Format** to interactively add or remove property attributes from the tag content.
- Change the **Style** property to switch between text-only, leader, bordered, or filled-frame styles.

## Properties Panel Parameters

### Content Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Type** | String (Dropdown) | byZone | Defines the type of entity to be collected and tagged. Options: **byZone** (collects GenBeams from the active zone), **Beam**, **Sheet**, **Panel** (SIP), **GenBeam**, **TSL**, **Opening**, **Door**, **Window**, **Window Assembly**. When set to "byZone", entities are collected from the current viewport zone automatically. |
| **TSL Names** | String | *(empty)* | Specifies a semicolon-separated list of TSL script names to be displayed. Only active when Type is set to **TSL**. When empty, all available TSL scripts in the viewport are included. Multiple entries should be separated by a semicolon (e.g., `hsbBlocking;hsbBracing`). This field is read-only for all entity types except TSL. |
| **Format** | String | *(empty -- auto)* | Defines the text content and attributes displayed in each tag. Uses `@(<PROPERTY>)` syntax to reference entity properties (e.g., `@(PosNum)`, `@(Length)`, `@(Material)`). Multiple lines are separated by a backslash `\`. Rounding instructions are supported for numeric properties (e.g., `@(Length:0)` rounds to zero decimal places). When left empty, the script uses a sensible default based on the Type: `@(PosNum)` for beams/sheets/panels/GenBeams, `@(Scriptname)` for TSLs, and `@(Width) x @(Height)` for openings. Attributes can also be added or removed interactively through the context menu command **Add/Remove Format**. |
| **Zone** | String | *(empty)* | Defines which zone(s) to collect entities from. When empty, the current active zone of the viewport is used. Enter zone indices separated by semicolons (e.g., `0;1;2`). Enter `99` to collect from all zones. Supports negative zone indices (e.g., `-1;-2`). Values from 6 to 10 are automatically converted to their negative equivalents (6 becomes -1, 7 becomes -2, etc.). |

### Display Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Dimstyle** | String (Dropdown) | *(from drawing)* | Selects the dimension style used for tag text rendering. The dropdown lists all dimension styles available in the current drawing. This controls font, text appearance, and formatting of the tag labels. |
| **Text Height** | Double | 0 | Defines the text height for tag labels. When set to **0**, the text height is calculated automatically based on the viewport scale (`U(100) * viewport scale`). Specify a positive value to override with a fixed text height. |
| **Color** | Integer | -2 | Defines the color of the tag. Special values: **-2** = byEntity (uses each entity's own color), **-1** = byLayer, **0** = byBlock, **>0** = AutoCAD color index number. |
| **Orientation** | String (Dropdown) | byEntity | Defines the text orientation of tags. Options: **byEntity** (aligns the tag text with the entity's local X-axis), **Horizontal** (all tags are horizontal), **Vertical** (all tags are vertical). Tags are automatically flipped for readability when necessary (e.g., upside-down text is mirrored). |
| **Style** | String (Dropdown) | Text only | Defines the visual style of the tag. Options: **Text only** (plain text with no border or leader), **Text + Leader** (text with a leader line pointing to the entity), **Border** (text inside a border shape), **Border+Leader** (bordered text with a leader line), **Filled Frame** (text inside a filled frame with transparency), **Filled Frame+Leader** (filled frame with a leader line). Even-numbered styles have no leader; odd-numbered styles include a leader. |

### General Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Behaviour** | String (Dropdown) | Automatic | Controls how the script handles PosNum assignment and entity dependencies. Options: **Automatic** -- assigns missing PosNums automatically and creates a dependency link to every collected entity so the tag updates when entities change. **Automatic PosNum** -- assigns PosNums but does not create dependency links. **Set Dependencies** -- creates dependency links without assigning PosNums. **Disabled** -- does nothing automatically; tags display only, no PosNum assignment or dependency tracking. |

## Right-Click Menu

The following context commands are available by right-clicking the hsbLayoutEntityTag instance:

| Command | Availability | Description |
|---------|-------------|-------------|
| **Add Viewport** | When no viewport is attached | Prompts you to select a viewport to attach to the script instance. Also triggered by double-clicking the instance. |
| **Add entities** | Non-Element Viewports only | Switches into Model Space and prompts you to select entities matching the current Type setting (beams, sheets, SIPs, GenBeams, TSLs, or openings). Selected entities are added to the script's tracking list and tags are generated for them. The prompt text changes based on the entity type (e.g., "Select beam(s)", "Select sheet(s)"). |
| **Remove entities** | Non-Element Viewports, when entities exist | Switches into Model Space and prompts you to select entities to remove from the tag tracking list. Removed entities will no longer receive tags. |
| **Add/Remove TSL** | When Type = TSL | Displays a numbered list of all available TSL scripts in the command line, with (+) for scripts not yet included and (-) for scripts already included. Enter a number to toggle a script in or out of the TSL Names list. Scripts prefixed with `sd_` and certain internal scripts (dimension, layout, preview, etc.) are automatically excluded from the list. |
| **Set Leader Offset** | When a leader-style is selected | Prompts for X-Offset and Y-Offset values that define the distance between the entity's shadow boundary and the tag label. The default offset is twice the text height in both X and Y directions. Adjusting these values moves all leader-connected tags closer to or further from their entities. |
| **Add/Remove Format** | Always | Displays a numbered list of all available entity properties (object variables) in the command line, with (+) for properties not yet in the format string and (-) for properties already included. Each property is shown with its translated name and a sample value from the first matching entity. Enter a number to add or remove a property from the Format string. This is the recommended way to build complex format expressions interactively. |
| **Only within viewport** / **within viewport or paperspace** | Always (toggles) | Toggles the tag placement area. When set to "Only within viewport", tags are constrained to appear only within the viewport boundary. When set to "within viewport or paperspace", tags may overflow into the surrounding Paper Space area outside the viewport rectangle. The command label reflects the current toggle state. |
| **Add No-Tag Area** | Always | Prompts you to pick two corner points to define a rectangular exclusion zone in Paper Space. Tags will never be placed inside this rectangle. Multiple no-tag areas can be added. This is useful for reserving space for title blocks, legends, or other annotations. |
| **Remove No Tag Area** | When no-tag areas exist | Removes all custom no-tag exclusion areas that were previously defined. All previously blocked regions become available for tag placement again. |
| **Toggle Wall Contour on/off** | Non-Element Viewports, Plan View only | Toggles whether the wall outline (exterior contour) of associated elements is treated as a protected area. When turned on, tags will not be placed inside the wall outline shape, keeping the wall contour clean. |

## Settings

This script does not read from external XML settings files. All configuration is managed through the Properties Panel (OPM) parameters and catalog entries.

**Catalog Entries**: The script supports the standard hsbCAD catalog system. You can save the current property configuration as a named catalog entry and recall it during future insertions. When inserting the script, if a catalog entry name is passed as the execute key, that preset is loaded automatically. Otherwise, the dialog prompts you to select from available entries. If the provided key does not match any existing catalog entry, the last-inserted configuration is used as a fallback.

## Tips

- **Format Expression Syntax**: Use `@(PropertyName)` to insert entity property values. Common properties include `PosNum`, `Name`, `Information`, `Label`, `Sublabel`, `Material`, `Length`, `Width`, and `Height`. For numeric properties, append a colon and the number of decimal places for rounding (e.g., `@(Length:0)` rounds to zero decimals, `@(Width:2)` shows two decimal places).

- **Multi-line Tags**: Separate multiple lines in the Format field using a backslash `\`. For example, `@(PosNum)\@(Material)\@(Length) x @(Width)` creates a three-line tag showing the position number, material, and dimensions.

- **Quantity Display**: Include `@(Quantity)` in the Format string to show how many entities share the same PosNum. This is useful for bill-of-material-style tagging where identical parts should display a count. Note: Quantity is not available for Opening-type entities.

- **SIP-Specific Properties**: When tagging SIP (Panel) entities, additional properties are available: `GrainDirectionText` (shows "Lengthwise" or "Crosswise"), `GrainDirectionTextShort` (abbreviated grain direction), `SurfaceQuality` (shows visible/hidden side quality), `SurfaceQualityTop`, and `SurfaceQualityBottom`. The `SurfaceQuality` property displays both sides in the format "VisibleSide (HiddenSide)", automatically adapting to the panel orientation relative to the view direction.

- **Priority System**: When multiple hsbLayoutEntityTag instances are attached to the same viewport, they are prioritized by creation time (earliest created = highest priority). Higher-priority instances place their tags first, and lower-priority instances must work around them. The current priority is shown in the control display text next to the instance. If tag placement is unsatisfactory, consider the insertion order of your tag instances.

- **Interactive Format Building**: Rather than manually typing complex format strings, use the **Add/Remove Format** context command. This lists all available properties with sample values and lets you toggle them on or off by entering a number. This is especially helpful when you are unsure of the exact property names.

- **Handling Overlapping Tags**: The clash detection algorithm expands outward from the entity center, searching along the entity's shadow profile for an unoccupied location. For beam entities, it tests up to four directions (mirrored about the entity's axes) to find the best position near the center. For non-beam entities, the search follows the outer contour of the shadow profile. If no position is found, the search region grows iteratively up to 100 iterations. To help the algorithm, define **No-Tag Areas** to block regions where tags are not useful, or increase the **Leader Offset** to spread tags further from the entity.

- **Automatic PosNum Assignment**: When **Behaviour** is set to "Automatic" or "Automatic PosNum", the script will automatically assign position numbers to entities that do not yet have one. This can save significant manual effort when preparing shop drawings. Set Behaviour to "Disabled" if you want to control PosNum assignment manually.

- **Grouped Leader Lines**: When multiple entities share the same PosNum, the script intelligently connects multiple leader lines to the same tag label. This avoids duplicate tags for identical parts and keeps the drawing clean.

- **Wall Contour Exclusion**: In plan views with non-element viewports, enable **Toggle Wall Contour** to prevent tags from being placed on top of the wall outline. This keeps the structural contour visible and improves drawing readability.

- **Zone Selection Shortcut**: Enter `99` in the Zone field to collect entities from all zones at once (zones -5 through 5). This is useful for overview drawings that need to show every component regardless of its zone assignment.

- **Entity Sorting by Size**: The script internally sorts entities by their projected area (smallest first). This means smaller entities get tag placement priority, since they are harder to label. Larger entities, which have more surface area for tag placement, are processed last.

- **Opening-Specific Tags**: When tagging openings (doors, windows, or window assemblies), the format supports `@(Width)`, `@(Height)`, and `@(Rise)` properties that are resolved directly from the opening geometry. This is useful for creating window and door schedules on shop drawings.

- **Tag Shape Adaptation**: The script automatically chooses between a circular and a rounded-rectangle tag boundary depending on the text content. Short, single-line tags (up to three lines where the width does not exceed 1.6 times the height) get a circular boundary, while longer or wider content receives a rounded rectangle for better readability.

- **Unnumbered Entity Warning**: Entities that have no PosNum assigned and Behaviour is set to "Automatic" or "Automatic PosNum" will be highlighted in a contrasting color (red or magenta) with a filled frame to visually flag them for attention. The script will then trigger a recalculation to attempt automatic assignment.

## Technical Notes

| Property | Value |
|----------|-------|
| **Script Type** | O (Object -- standalone, not attached to a beam) |
| **Beams Required** | 0 |
| **DXA Output** | Yes (`#DxaOut 1`) -- the script produces DXF/DXA export output |
| **Implicit Insert** | Yes (`#ImplInsert 1`) |
| **Execution Space** | Paper Space (operates on Layout tabs via Viewport references) |
| **Coordinate System** | Uses Viewport coordinate transformations (`ms2ps` and `ps2ms`) to convert between Model Space and Paper Space coordinates |
| **Clash Detection** | Iterative geometric algorithm using `PlaneProfile` intersection tests. Each entity's shadow profile is projected onto the viewport plane, and tag bounding shapes (circles or rounded rectangles) are tested against a cumulative "protected" profile that grows as tags are placed. Up to 100 iterations per entity, expanding outward along the entity contour until a free location is found. |
| **Priority Mechanism** | Based on `CreationTime` stored in `_Map`. When multiple instances share a viewport, they are ordered chronologically. Each instance reads the protected profile from the previous (higher-priority) instance and adds its own tags before passing the updated profile to the next instance via `_Map.setPlaneProfile("ppProtect", ...)`. |
| **Entity Collection** | For Element Viewports, entities are collected directly from the element's API (`el.beam()`, `el.sheet()`, `el.sip()`, `el.genBeam()`, `el.opening()`, etc.), filtered by zone and dummy status. For non-element viewports, entities must be manually added via the `_Entity` array through context commands. |
| **Format Resolution** | Entity property values are resolved using the `formatObject()` method. Unresolved properties (e.g., Opening-specific or SIP-specific attributes like Width, Height, Rise, GrainDirection, SurfaceQuality) are handled through manual type-casting and fallback logic within the script. |
| **Dependency Tracking** | When Behaviour includes dependency setting, the script calls `setDependencyOnEntity()` for each collected entity, ensuring the tag recalculates when the underlying entity changes geometry or properties. |
| **Performance** | Debug mode measures execution time using `getTickCount()`. The script includes performance optimizations such as using `envelopeBody()` for shadow profile generation and limiting the clash resolution iterations to a maximum of 100 steps per entity. |
| **Multi-Instance Coordination** | Uses `_Map.setPlaneProfile("ppProtect", ...)` to publish the protected tag region to other instances on the same viewport. Lower-priority instances read this profile to avoid overlapping with tags placed by higher-priority instances. |
| **Sequence Number** | Set to `1000 + priority` via `_ThisInst.setSequenceNumber()` to control recalculation order among instances sharing the same viewport. |
| **Scale Awareness** | Text height and tag dimensions are calculated relative to the viewport scale. When Text Height is set to 0, the script computes `U(100) * viewport scale` as the default, ensuring consistent visual size regardless of zoom level. |
| **Plan View Detection** | The script detects whether the viewport shows a plan view (top-down) by checking if the view Z-direction is parallel to the world Z-axis. This affects tag orientation, opening profile calculation, and the availability of the Wall Contour toggle. |
| **Beam Sorting** | In Element Viewports with Type=Beam, beams are sorted into horizontal and vertical groups relative to the element's local axes before processing. This optimizes tag placement along the dominant beam directions. |
| **Duplicate Instance Handling** | When a script instance is copied, the system detects duplicate `CreationTime` values and automatically resets the time on the copy, ensuring each instance receives a unique priority. |
