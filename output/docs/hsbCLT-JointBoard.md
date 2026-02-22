# hsbCLT-JointBoard

## Overview

**hsbCLT-JointBoard** is a TSL script that creates a joint board connection along a common edge between two or more CLT (Cross-Laminated Timber) panels. It automatically calculates the lap joint geometry, applies panel cuts (beamcuts and chamfers), and optionally generates joint board beams with associated hardware data for manufacturing output.

The script operates in three internal modes: **Panel mode** (the primary workflow for connecting CLT panels), **Wall mode** (for inserting into wall elements where it splits panels at a designated location), and **Beam Creation mode** (a transient mode for configuring newly created joint board beams).

| Property | Value |
|----------|-------|
| **Script Type** | Object (O) |
| **Category** | CLT Connection |
| **Version** | 3.4 (25.06.2025) |
| **Required Beams** | 0 (works with Panels) |
| **Keywords** | CLT, Jointboard, Connection |

---

## When to Use

Use this script when you need to:

- Create lap joint connections between adjacent CLT panels that share a common edge
- Split a single panel at a specific line and automatically insert a joint board at the split location
- Join multiple panels together with a consistent joint board profile across all shared edges
- Generate joint board beams as real Beam entities for downstream manufacturing and hardware output
- Apply joint boards within a wall element, automatically splitting contained panels at a designated location

---

## Insertion Methods

### Method 1: Insert as Splitting Tool (Single Panel)

Use this method to split one panel and create a joint board connection at the split.

1. Run the insert command for `hsbCLT-JointBoard`
2. Select **one panel**
3. Select the **first split point** on the panel plane
4. Select the **second split point** to define the splitting line
5. The script splits the selected panel along the defined line and inserts a joint board at the new edge

For roof panels (non-horizontal), the split points are automatically projected onto the panel center plane based on the current alignment setting (Reference Side, Opposite Side, or axis). If the two selected points are identical or too close together, the insertion is cancelled with an error message.

### Method 2: Insert as Single Tool on One Edge

Use this method to modify one edge of a panel without splitting it.

1. Select **one panel**
2. Select **two points on the edge** where you want to attach the lap joint
3. The script inserts a tool at the designated edge without splitting the panel
4. To link another panel later, use the **Add Panel** context menu command

This approach is useful when you want to prepare a panel edge before the adjacent panel exists, or when you prefer to build the connection incrementally.

### Method 3: Insert as Tool to Multiple Panels

Use this method to connect two or more existing panels at their shared edges.

1. **Select all desired panels** (the first selected panel becomes the reference panel)
2. If edges are not all parallel, **pick a point near the edge** you would like to join; alternatively, press Enter to apply joint boards to all detected connections
3. The script automatically detects connecting edges between the selected panels and creates joint board instances

When multiple panels are selected, the script uses a MapIO call to detect all coplanar panel pairs that share opposing edges. If all detected edges are parallel, the script proceeds directly. If edges run in different directions, you are prompted to pick a point near the specific edge to connect, or press Enter to create connections at all detected edges.

### Method 4: Insert via Wall Element

You can also insert the joint board by selecting a wall element instead of individual panels.

1. Select **no panels** (press Enter at the panel selection prompt)
2. Select a **wall element**
3. Pick a **point** on the wall outline
4. When the wall is constructed, the script automatically splits all panels at the insertion location and creates joint boards

This mode is designed for wall-based workflows. The joint board appears as a plan symbol until the element is constructed, at which point it creates the actual panel-mode connections.

### Catalog-Based Insertion

The script supports catalog entries for predefined parameter sets. When inserting with a specific catalog key (e.g., from a ribbon button or palette command), the script automatically applies the catalog values. If catalog entries match panel style names, the corresponding catalog entry is applied based on the first selected panel's style.

Custom insertion commands can be defined in AutoCAD as:
`^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-JointBoard")) TSLCONTENT`

---

## Parameters

### Geometry Properties

| Parameter | Label | Default | Description |
|-----------|-------|---------|-------------|
| **(A) Width** | Width | 100 mm | Width of the joint board, which determines the cut depth into panels from each side |
| **(B) Depth** | Depth | 20 mm | Thickness of the joint board material |

### Gap Properties

| Parameter | Label | Default | Description |
|-----------|-------|---------|-------------|
| **(C) Width** | Width (Gap) | 2 mm | Gap width between the panel faces at the joint. Added to both sides of the board width for the beamcut |
| **(D) Depth** | Depth (Gap) | 2 mm | Gap depth at the joint board interface, offsetting the board from the panel face |
| **(X) Relief Cut** | Relief Cut | 0 mm | Relief cut dimension applied as angled cuts at the panel edges. Not available when Alignment is set to Center (automatically set to 0 and locked) |
| **(H) Gap Panel** | Gap Panel | 0 mm | Gap applied directly to the panel edges by stretching them apart. When set, both male and female panel edges are moved away from the reference point by half the specified value. Added in version 3.4 |

### Chamfer Properties

| Parameter | Label | Default | Description |
|-----------|-------|---------|-------------|
| **(E) Reference Side** | Chamfer (Ref) | 0 mm | Chamfer dimension on the reference (bottom) side of the panels. Only applied when alignment is not Reference Side |
| **(F) Opposite Side** | Chamfer (Opp) | 0 mm | Chamfer dimension on the opposite (top) side of the panels. Only applied when alignment is not Opposite Side |

Chamfers are applied as rotated beamcuts at 45 degrees along the panel edges. When corner connections with other joint board instances are detected, mitred chamfer solids are automatically added.

### General Properties

| Parameter | Label | Default | Description |
|-----------|-------|---------|-------------|
| **(G) Alignment** | Alignment | Reference Side | Joint board position relative to panel faces. Determines which side of the panel the board sits on |
| **Material** | Material | Spruce | Material specification for the joint board. When beams are created, this value transfers to the beam. Becomes read-only after beam creation |
| **Grade** | Grade | (empty) | Grade/strength class of the joint board. Becomes read-only after beam creation |

### Alignment Options

| Option | Description |
|--------|-------------|
| **Reference Side** | Joint board aligned flush with the reference face (bottom) of the panels |
| **Center** | Joint board centered through the panel thickness. Note: Relief Cut is disabled in this mode |
| **Opposite Side** | Joint board aligned flush with the opposite face (top) of the panels |
| **Higher Quality** | Joint board automatically aligned to the panel face with the higher surface quality rating. If both sides have equal quality, the alignment reverts to Reference Side on creation or preserves the previous alignment on recalculation |
| **Lower Quality** | Joint board automatically aligned to the panel face with the lower surface quality rating. If both sides have equal quality, the alignment reverts to Opposite Side on creation or preserves the previous alignment on recalculation |

### Beam Creation Properties (Mode 2)

When beams are created via the **Create beams** command, a separate set of properties appears under the "Creation" OPM group:

| Parameter | Label | Default | Description |
|-----------|-------|---------|-------------|
| **Auto Group** | Auto Group | Joint Board | Group path for organizing joint board beams. Supports hierarchical paths separated by backslash (e.g., `House\Floor\Jointboard`). If only a partial path is given, the script fills in missing levels from the TSL instance's current group assignment |
| **Name** | Name | Joint board | Name assigned to the created beam entities |
| **Color** | Color | 0 | Color index applied to the created beam entities |

---

## Context Menu Commands

Right-click on the joint board instance to access these commands. Commands are organized into root-level and settings-level groups.

### Panel Management (Root Level)

| Command | Description |
|---------|-------------|
| **Add Panel** | Select additional panels to add to the joint board connection. Newly selected panels are appended if not already linked |
| **Remove Panel** | Select one or more panels to remove from the connection. Only available when 3 or more panels are connected. Removed female panels have their edge stretch reset |
| **Add Tool** | Link an external tool entity to the joint board (available in debug mode) |

### Position and Display (Root Level)

| Command | Description |
|---------|-------------|
| **Flip Side** | Toggle the alignment between Reference Side and Opposite Side, or between Higher Quality and Lower Quality. Also triggered by double-clicking the instance |
| **Edit in Place** | Enable stretch grips at the start and end of each joint board segment for manual length adjustment. Only available when no beams have been created |
| **Disable Edit in Place** | Remove stretch grips and return to fully automatic extent calculation |

### Beam Creation (Root Level)

| Command | Description |
|---------|-------------|
| **Create beams** | Convert the joint board visualization into actual Beam entities. Opens a dialog to configure group assignment, name, and color. Previously created beams are erased and recreated. You can optionally select additional joint board instances to apply the same beam creation settings |
| **Create beams (CatalogName)** | For each saved catalog entry, a separate command appears. This allows one-click beam creation with predefined settings without showing the dialog |

When beams are created, the joint board is represented by real Beam entities rather than display-only solids. The beams receive the specified material, grade, and color, and they are assigned to the configured group hierarchy. Hardware output data (article, dimensions, material) is generated for the visualization-based boards but not for beam-based boards.

### Conversion and Cleanup (Root Level)

| Command | Description |
|---------|-------------|
| **Convert to static** | Apply all beamcuts and chamfers as static tools directly onto the panels, then delete the dynamic TSL instance. This makes the cuts permanent and independent of the script |
| **Join + Erase** | Merge all connected panels back into a single panel using `dbJoin`, then delete the TSL instance. This reverses the split operation |

### Settings Management (Settings Level)

| Command | Description |
|---------|-------------|
| **Settings Group Assignment** | Opens a text input dialog to configure the group path for automatic assignment. The group name supports hierarchical notation with backslash separators. Export the settings after changing to share with other users |
| **Grip Mode Creation on/off** | Toggle whether stretch grips (Edit in Place) are automatically enabled on newly inserted instances. The current state is saved to the settings file |
| **Import Settings** | Reload settings from the XML file at the company path. Only available when the settings file exists |
| **Export Settings** | Save current settings to the XML file at the company path. Prompts for confirmation if the file already exists |

### Wall Mode Commands (Root Level)

When the tool is inserted via a wall element, these additional commands appear:

| Command | Description |
|---------|-------------|
| **Flip Side** | Toggle alignment side within the wall thickness |
| **Flip Direction** | Reverse the direction of the joint board within the wall |

---

## Workflow Examples

### Creating a Basic Panel Joint

1. Insert `hsbCLT-JointBoard`
2. Select two adjacent coplanar CLT panels (select the reference panel first)
3. Click near the shared edge between the panels
4. Adjust Width, Depth, Gap, and Chamfer parameters in the Properties Palette as needed
5. The joint board and all associated cuts are automatically calculated and displayed

### Splitting a Panel and Adding a Joint Board

1. Insert `hsbCLT-JointBoard`
2. Select a **single** CLT panel
3. Pick two points defining the split line across the panel
4. The panel is split into two parts, and a joint board is inserted at the new edge
5. Both resulting panels are now connected by the joint board

### Connecting All Edges at Once

1. Select **all panels** that need joint boards
2. When prompted, press **Enter** (instead of picking a point) to apply to all detected connections
3. The script creates one joint board instance per detected edge pair

### Converting to Beams for Manufacturing

1. Create and adjust the joint board connection as needed
2. Right-click the instance and select **Create beams**
3. Optionally select additional joint board instances to apply the same settings
4. In the dialog, configure the group name, beam name, and color
5. The joint boards become real Beam entities with material and grade properties
6. Hardware BOM data is now available through the beam entities

### Adjusting Joint Board Extent Manually

1. Right-click the instance and select **Edit in Place**
2. Stretch grip points appear at the start and end of each joint board segment
3. Drag the grip points along the edge to adjust the board length
4. The beamcuts and display update automatically to match the new extent
5. To return to automatic calculation, right-click and select **Disable Edit in Place**

### Applying Panel Edge Gaps

1. Set the **(H) Gap Panel** property to the desired gap value (e.g., 2 mm)
2. Both male and female panel edges are automatically stretched apart by half the gap value
3. The gap is applied once on creation or when the property changes, and the applied value is stored for subsequent recalculations

### Using Custom Commands from Ribbon or Palette

Define custom AutoCAD commands to trigger specific actions remotely:

- Insert: `^C^C(defun c:JBINSERT() (hsb_ScriptInsert "hsbCLT-JointBoard")) JBINSERT`
- Flip Side: `^C^C(defun c:JBFLIP() (hsb_RecalcTslWithKey (_TM "|Flip Side|") (_TM "|Select joint board|"))) JBFLIP`
- Create Beams (with catalog): `^C^C(defun c:JBCREATE() (hsb_recalcTslWithKey (_TM "|Create beams (MyCatalog)|") (_TM "|Select Tool|"))) JBCREATE`

---

## Technical Notes

### Panel Requirements

- **Minimum panels**: 2 (except when using split mode with a single panel)
- Panels must be **coplanar** -- their Z-axes must be parallel and their thickness ranges must overlap
- Panels must share a **common edge** with opposing normal directions (one male, one female)
- Two panels with normals pointing in the same direction ("two male panels") cannot be connected
- Non-coplanar panels are silently removed from the selection set with a message

### Automatic Behaviors

- **Corner Detection**: When other `hsbCLT-JointBoard` instances exist on the same panels, the script detects corner intersections and automatically adds mitred chamfer cuts. The instance with the lower database handle is treated as the "female" corner
- **Duplicate Merging**: If a panel split creates a duplicate joint board on the same edge (same direction, same properties, same line), the duplicate's panels are merged into the original and the duplicate is erased
- **Surface Quality Awareness**: The Higher Quality and Lower Quality alignment options read surface quality ratings from the panel style. If both sides have identical quality values, the alignment falls back to Reference Side or Opposite Side respectively
- **Color Mapping**: If the settings XML contains a `SurfaceQualityStyle[]` section mapping quality names to colors, the instance color is automatically updated based on the highest surface quality of the connected panels
- **Opening Handling**: Panel openings are detected and excluded from the joint board profile. The joint board does not extend through opening regions
- **Copy with Panels**: The script is configured with `setEraseAndCopyWithBeams` so that when a connected panel is split by another operation, the joint board instance is copied along with the panel

### Beamcut Geometry

The beamcut applied to panels has the following dimensions:
- **Length**: Matches the common range extent along the edge
- **Width**: Joint board width + 2 times the gap width (`dWidth + 2 * dGapWidth`)
- **Depth**: Joint board depth + gap depth (`dDepth + dGapDepth`). When alignment is Reference Side or Opposite Side, the depth is doubled to cut through one face completely

### Hardware Output

When no beams are created, the script generates hardware component data for each board segment:
- **Article**: "Joint Board"
- **Category**: "Board"
- **Model**: Depth x Width (e.g., "Joint Board 20 x 100")
- **Material**: As specified in the Material property
- **Description**: As specified in the Grade property
- **Dimensions**: Length, Width, and Depth of the board segment

### Settings Persistence

Settings are stored in XML format and loaded via the MapObject system:

- **Company path**: `_kPathHsbCompany\TSL\Settings\hsbCLT-JointBoard.xml`
- **Install path**: `_kPathHsbInstall\Content\General\TSL\Settings\hsbCLT-JointBoard.xml`

On first insertion, the script searches the company path first, then falls back to the installation path. The settings are cached in a drawing-level MapObject (`hsbTSL/hsbCLT-JointBoard`) for performance. When a new drawing is opened, the script validates the MapObject version against the XML file version and warns if they differ.

Settings include:
- Default color for new instances
- Surface quality to color mappings
- Beam conversion group name
- Automatic beam conversion flag (creates beams immediately on insert)
- Grip Mode Creation toggle

### Display Behavior

The script provides two display contexts:
- **Model view**: Shows the 3D joint board solid, hidden when looking along the panel's Z-axis
- **Panel view**: Shows a 2D cross-section of the joint profile, visible only when looking along the Z-axis (plan view). This includes the board outline, the beamcut envelope, and a reference line marking the panel edge

---

## Related Scripts

| Script | Relationship |
|--------|--------------|
| `hsbCLT-T-Connector` | T-shaped panel connections (perpendicular panel joins) |
| `hsbCLT-Slot` | Slot-based panel connections |
| `hsbCLT-LapJoint` | Lap joint connections (similar but different geometry) |
| `HSB_PANELTSLSPLITLOCATION` | Command that can be used in conjunction with this script for batch split locations |

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "requires at least 2 panels" | Ensure at least two panels are linked. Use split mode (single panel) or Add Panel command to add the second panel |
| "Two male panels cannot be connected" | The panels have edge normals pointing in the same direction at the connection point. Check that panels are positioned correctly with opposing faces at the shared edge |
| "no common range" | The panels do not share a valid overlapping edge region. Verify that panels are coplanar and their edges actually overlap when projected |
| "Invalid points selected" | The two split points are identical or too close together. Select distinct points that define a clear splitting line |
| "could not find reference to element" | In wall mode, the selected entity is not a valid wall element. Ensure you select an ElementWall |
| "A different Version of the settings has been found" | The settings XML in the file system has a different version than the cached MapObject. Use Import Settings to reload from file, or Export Settings to update the file |
| Joint board not visible | Check that panels are coplanar with overlapping thickness ranges. In wall mode, the joint board only becomes visible after element construction |
| Relief Cut has no effect | Relief Cut is automatically disabled and locked to 0 when Alignment is set to Center |
| Material and Grade are read-only | These properties become read-only after beams are created, since the values are then managed on the beam entities directly |
| Grip points not appearing | Edit in Place is only available when no beams have been created. Also check the Grip Mode Creation setting |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 3.4 | 25.06.2025 | Added Gap Panel property for panel edge gaps (HSB-24228) |
| 3.3 | 05.12.2024 | Save graphics in file for render in hsbView (HSB-23001) |
| 3.2 | 20.11.2024 | Fix connection for angled edge panels (HSB-23017) |
| 3.1 | 19.09.2024 | Performance enhanced (HSB-22701) |
| 3.0 | 17.04.2024 | Custom commands moved to root context menu; import/export settings; grouping option; default grip option (HSB-21901) |
| 2.9 | 04.04.2021 | Fixed moveGripEdgeMidPointAt issues, replaced with add/subtract profile approach (HSB-11210) |
| 2.8 | 30.03.2021 | Added extra tolerance to cut through the body (HSB-10784) |
| 2.7 | 19.02.2021 | Bugfix writing default XML (HSB-10732) |
| 2.6 | 26.10.2020 | Bugfix length of beamcut (HSB-9121) |
| 2.5 | 23.07.2019 | Bugfix relief cut property on insert (HSB-2857) |
| 2.4 | 11.07.2019 | Beam creation on insert supported via settings (HSB-5355) |
| 2.3 | 22.05.2019 | Beamcut alignment fixed (HSB-5076) |
| 2.2 | 16.11.2018 | Corner connection detection with mitred chamfers (HSB-300) |
| 2.1 | 15.11.2018 | Color mapping and join+erase commands (HSB-297, HSB-298, HSB-299) |
| 2.0 | 25.07.2018 | Consistent coordinate system for joint board beams (HSB-4546) |
| 1.9 | 25.05.2018 | Initial consistent coordinate system work |
| 1.8 | 16.04.2018 | Convert to static command added |
| 1.7 | 23.01.2018 | Relief cut option added |
| 1.6 | 04.08.2017 | Beam creation supports naming of joint boards |
| 1.5 | 26.07.2017 | Beam creation for multiple instances with same settings |
| 1.4 | 12.04.2017 | Grouping fixes, gap issue fixes, beam-based beamcut fixes |
| 1.3 | 05.04.2017 | Transparency deactivated on debug |
| 1.2 | 04.04.2017 | Created beams honor alignment; beam-dependent beamcuts |
| 1.1 | 17.11.2016 | Create beams command added |
| 1.0 | 27.10.2016 | Initial release |
