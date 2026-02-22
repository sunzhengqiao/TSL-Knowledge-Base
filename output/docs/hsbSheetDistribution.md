# hsbSheetDistribution

Redistributes sheet or SIP (Structural Insulated Panel) materials on wall and roof elements with customizable alignment, staggering patterns, and automatic cutting at constraining beam locations.

## Overview

The **hsbSheetDistribution** script redesigns the layout of sheet materials (such as OSB, plywood, gypsum) or SIPs on timber frame elements. It replaces existing sheets or SIPs in a specified zone with a new distribution pattern based on user-defined alignment, gaps, and staggering offsets.

**Key Capabilities:**
- Redistribute sheets or SIPs on Wall Elements (ElementWall) and Roof Elements (ElementRoof)
- Support for standalone sheets/SIPs not assigned to elements
- Four alignment modes: Element-based, Sheet-based, Reference Axis X, and Reference Axis Y
- Staggered joint patterns for structural performance (running bond)
- Automatic cutting at constraining beam centerlines using Painter Definitions
- Live visual preview (jigging) during interactive placement
- Per-zone configuration stored in the Element's mapX data
- Catalog-based insertion for automated or batch workflows

**Version:** 1.15 (February 2025)

## Environment

| Property | Value |
|----------|-------|
| Script Type | Object (O-Type) |
| Environment | Model Space |
| Beams Required | 0 |
| Supported Entities | ElementWall, ElementRoof, Sheet, Sip |
| Self-Erasing | Yes (removes itself after creating new sheets) |

## Prerequisites

Before using this script:

1. **Existing Sheets or SIPs** -- The target element must already contain sheets or SIPs in the zone you want to redistribute. The script reads dimensions, material, and properties from the existing sheets.
2. **Element Structure** (optional) -- For beam-constrained distribution, the element should contain framing members (studs, joists) that are parallel to the element X or Y axis.
3. **Painter Definitions** (optional) -- For cutting sheets at beam locations, configure painter definitions under the `hsbSheetDistribution` collection. A default painter (`BeamGridY`) is created automatically if none exists.

## Usage

### Basic Workflow

1. **Launch the Script**
   - Command line: `hsb_ScriptInsert "hsbSheetDistribution"`
   - Or use the hsbCAD ribbon/menu

2. **Select Target Entity**
   - Prompt: *Select Wall, Roof Element or a Sheet/SIP from the Element*
   - You may select a Wall Element, Roof Element, individual Sheet, or individual SIP
   - If a Sheet or SIP is selected, the script automatically determines the zone from the selected entity and loads any previously saved settings for that zone

3. **Configure Distribution Parameters**
   - A dialog appears with alignment mode, sheet dimensions, gaps, staggering, and constraining beam options
   - Previously saved settings (from Element mapX or the last-inserted catalog) are loaded automatically
   - Adjust settings as needed and confirm with OK

4. **Position the Distribution**
   - Prompt: *Select reference point [options...]*
   - Click to set the reference point for sheet placement
   - A live preview shows the resulting distribution pattern in real-time as you move the cursor
   - Use command-line keywords to switch modes or adjust parameters interactively (see table below)
   - The red and green axis indicators at the reference point show the X and Y directions

5. **Confirm Placement**
   - Press Enter or right-click to accept the shown distribution
   - The original sheets/SIPs in the zone are erased and replaced with new ones matching the distribution pattern
   - Settings are saved to the Element's mapX and to the `_LastInserted` catalog for future reuse

### Command-Line Keywords During Placement

While placing, type these keywords at the command line to adjust settings interactively:

| Keyword | Action |
|---------|--------|
| `ELementmodus` | Switch to Element alignment mode |
| `SHeetmodus` | Switch to Sheet/SIP alignment mode |
| `referenceaxisX` | Switch to Reference Axis X mode |
| `referenceaxisY` | Switch to Reference Axis Y mode |
| `leFTtop` | Set alignment to Left Top |
| `lefTMiddle` | Set alignment to Left Middle |
| `lefTBottom` | Set alignment to Left Bottom |
| `middlETop` | Set alignment to Middle Top |
| `middlEMiddle` | Set alignment to Middle Middle |
| `middlEBottom` | Set alignment to Middle Bottom |
| `rightTOp` | Set alignment to Right Top |
| `rightMIddle` | Set alignment to Right Middle |
| `rightBOttom` | Set alignment to Right Bottom |
| `staggerinGX` | Set staggering direction to X |
| `staggerinGY` | Set staggering direction to Y |
| `staggeriNG` | Enter a new staggering offset value |
| `gaPX` | Enter a new Gap X value |
| `gaPY` | Enter a new Gap Y value |
| `LEngth` | Enter a new sheet length value |
| `WIdth` | Enter a new sheet width value |

Note: The capital letters in each keyword indicate the shortcut characters you can type. The available keywords shown at the prompt change dynamically based on the currently selected mode -- for example, alignment options are only shown in Element or Sheet mode, not in Reference Axis modes.

## Parameters

### Alignment Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Modus** | List | Element | Distribution mode. **Element**: align to element corners. **Sheet/SIP**: pick placement point interactively. **Reference Axis X**: horizontal reference through element center. **Reference Axis Y**: vertical reference through element center |
| **Alignment** | List | Left Top | Reference corner for distribution. Combines horizontal (Left / Middle / Right) and vertical (Top / Middle / Bottom). In Element mode, refers to element corners. In Sheet mode, refers to the sheet corner placed at the picked point |
| **Staggering Offset** | Length | 0 | Offset between alternating rows to create staggered (running bond) joints. Typically set to half the sheet width for standard running bond patterns |
| **Staggering Direction** | List | X | Direction of staggering: **X** (horizontal) or **Y** (vertical), relative to the element coordinate system |
| **Position Reference Axis** | List | Left Sheet Left Element | Predefined alignment positions for Reference Axis modes. Used primarily when saving position in a catalog for automated insertion. Seven options available (see Distribution Modes section) |

### Zone Category

| Parameter | Type | Range | Description |
|-----------|------|-------|-------------|
| **Zone** | Integer | -5 to +5 | Sheet zone index on the element. Positive values are typically exterior side, negative values interior side. Zone 0 is the central default zone. When a Sheet or SIP is selected during insertion, the zone is determined automatically |

### Sheet Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Length** | Length | 0 | Sheet length dimension. When set to 0, uses the largest existing sheet length from the zone |
| **Width** | Length | 0 | Sheet width dimension. When set to 0, uses the largest existing sheet width from the zone |
| **Thickness** | Length | 0 | Sheet thickness. When set to 0, uses the zone height or existing sheet thickness |
| **Name** | Text | (empty) | Override sheet name for generated sheets. When empty, preserves the existing sheet name |
| **Material** | Text | (empty) | Override material name. When empty, preserves the existing material. Also checks the zone variable `material` if defined |
| **Gap X** | Length | 0 | Horizontal gap between adjacent sheets in the X direction |
| **Gap Y** | Length | 0 | Vertical gap between sheet rows in the Y direction |

### Constraining Beams Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Painter** | List | Disabled | Painter definition for selecting constraining beams. Must be from the `hsbSheetDistribution` collection. When enabled, sheets are automatically cut at beam centerlines. Only beams parallel to the element X or Y axis and matching the painter filter are considered |
| **Sheet on first/last Beam axis** | Yes/No | No | Controls sheet edge alignment at the first and last constraining beams. **No**: sheets are not cut at the axis of the first/last beam; sheet edges align with beam edges. **Yes**: sheets end exactly at the beam centerlines of the first and last beams |

## Distribution Modes Explained

### Element Mode
The distribution starts from a corner of the element boundary. The **Alignment** parameter determines which corner serves as the origin:
- **Left Top**: distribution originates from the upper-left corner of the element
- **Middle Middle**: distribution centers on the element
- **Right Bottom**: distribution originates from the lower-right corner

The center of the first sheet is placed at the selected element corner, and sheets tile outward in both directions to fill the entire element.

### Sheet/SIP Mode
You interactively pick a point on the element surface. The **Alignment** parameter determines which part of the sheet is placed at that point:
- **Left Top**: the upper-left corner of the sheet is placed at the picked point
- **Middle Middle**: the center of the sheet is placed at the picked point

This mode provides maximum control over exact sheet placement.

### Reference Axis X / Y Mode
Sheets are aligned to a reference axis running through the element center. This is useful for symmetric layouts, such as facade sheeting that must be centered.

- **Reference Axis X**: uses a horizontal reference line through the element center
- **Reference Axis Y**: uses a vertical reference line through the element center

The **Position Reference Axis** parameter offers seven alignment options:

| Option | Description |
|--------|-------------|
| Left Sheet Left Element | Left edge of sheet aligns with left edge of element |
| Right Sheet Middle Element | Right edge of sheet aligns with center of element |
| Middle Sheet Middle Element | Center of sheet aligns with center of element |
| Left Sheet Middle Element | Left edge of sheet aligns with center of element |
| Right Sheet Right Element | Right edge of sheet aligns with right edge of element |
| Middle Sheet Left Element | Center of sheet aligns with left edge of element |
| Middle Sheet Right Element | Center of sheet aligns with right edge of element |

During interactive placement, the script calculates all seven positions and selects the one closest to your cursor position.

## Painter Definitions for Constraining Beams

When a Painter Definition is selected (not Disabled), the script filters beams from the element to determine where sheet joints should fall. This ensures sheets are cut at structural member locations as required by building codes.

### How It Works

1. The script retrieves all beams from the element and filters them using the selected Painter Definition
2. Only beams whose X-axis is parallel to the element X or Y axis are kept; non-parallel beams are discarded
3. Beams are sorted along the direction perpendicular to their axis
4. Sheets are placed between beam centerlines, with optional gap offsets
5. The **Sheet on first/last Beam axis** setting controls whether the outermost beams act as cut boundaries

### Default Painter Definition

The script automatically creates a default painter named `BeamGridY` if it does not exist:

- **Collection**: hsbSheetDistribution
- **Name**: BeamGridY
- **Type**: Beam
- **Filter**: `(Equals(ZoneIndex,0))and(Equals(IsParallelToElementY,'true'))and(Equals(IsDummy,'false'))`

This default targets non-dummy beams in Zone 0 that run parallel to the element Y axis (typically studs in a wall element).

### Creating Custom Painter Definitions

Create additional painters under the `hsbSheetDistribution` collection to target specific beam configurations. Only painters of type "Beam" or "GenBeam" are accepted. Examples:
- Beams parallel to Element X axis (e.g., floor joists)
- Beams in a specific zone index
- Beams with specific labels or grades

Painter definitions are automatically copied via catalog when the painter stream property is populated. This allows distributing painter configurations across projects.

## Catalog and Settings Persistence

### Automatic Catalog Saving
After each insertion, the script saves its current property values to the `_LastInserted` catalog. This means the next time you insert the script, your previous settings are restored.

### Element mapX Storage
Settings are stored per zone in the element's mapX under the key `hsbSheetDistribution`. Each zone has its own sub-map (e.g., `zone0`, `zone1`, `zone-1`) containing:
- All property values (modus, alignment, sheet dimensions, gaps, staggering, painter)
- The grip point (distribution origin) as `PointJig`

When the element recalculates, the script reads these stored settings and re-applies the distribution automatically.

### Silent / Catalog-Based Insertion
When inserted with an execute key matching a catalog name (e.g., via element definition), the script loads properties from that catalog and skips the dialog. This enables fully automated distribution as part of element construction.

## Tips and Best Practices

1. **Start with Existing Sheets** -- The script uses existing sheet dimensions when Length/Width are set to 0. This preserves material specifications automatically.

2. **Use Staggering for Structural Performance** -- Set a staggering offset (typically half the sheet width, e.g., 600 mm for 1200 mm wide sheets) to create running bond patterns that improve racking resistance.

3. **Constrain to Beams for Code Compliance** -- Enable a painter definition to ensure sheet joints fall on framing members, which is often required by building codes.

4. **Save Settings to Catalog** -- After configuring optimal settings, they are automatically saved to `_LastInserted`. Create named catalogs for different assembly types (e.g., exterior sheathing vs. interior gypsum).

5. **Per-Zone Configuration** -- When working with multi-zone elements, configure each zone separately. Select a sheet from the target zone to ensure the correct zone is pre-selected.

6. **Use Reference Axis Modes for Symmetry** -- When sheets need to be centered on an element (e.g., for facade symmetry), use Reference Axis X or Y modes with the Middle Sheet Middle Element position.

7. **SIP Support** -- The script fully supports SIP panels. SIP-specific properties such as wood grain direction, style, and X-axis orientation are preserved from the original SIP to the newly created ones.

8. **Live Preview** -- Take advantage of the interactive jigging preview. Move your cursor to see how the distribution will look before committing. The preview works in both plan view and isometric views.

9. **Openings Are Preserved** -- The script respects openings in sheets and SIPs. Opening profiles from the original entities are subtracted from the overall distribution area.

10. **Standalone Sheets/SIPs** -- For sheets or SIPs not part of an element, the script assigns the new entities to the same groups as the original. The distribution origin and body intersection use ray-based projection for accurate placement.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| No sheets appear after running | Verify the selected zone contains sheets or SIPs. Check if the Zone parameter matches the target zone index |
| Sheets not cutting at beams | Verify the Painter Definition filter matches your beam configuration. Beams must be parallel to the element X or Y axis and must pass the painter filter. Check that the painter is of type Beam or GenBeam |
| Distribution position is off | Try switching between Element, Sheet, and Reference Axis modes. In Element mode, the alignment refers to element corners. In Sheet mode, it refers to sheet corners |
| Settings not persisting on recalculation | Settings are stored in the Element mapX per zone. Ensure the script was inserted at least once with a valid grip point so `PointJig` is saved |
| Unexpected zone index error | When selecting a sheet/SIP, ensure it belongs to a valid zone. The script validates that the zone exists and contains sheets |
| Sheets overlapping | Increase Gap X and Gap Y values. Check that the staggering offset does not cause sheets to overlap (staggering should typically be less than the sheet width) |
| Painter not appearing in the list | Painter definitions must belong to the `hsbSheetDistribution` collection and be of type Beam or GenBeam. Other types are filtered out |
| Preview looks correct but result differs | The calculation logic matches the jig logic. If discrepancies occur, check that beam configuration has not changed between preview and confirmation |

## Technical Notes

- The script erases itself after execution (`eraseInstance()`). It creates the new sheet/SIP entities, deletes the originals, writes settings to mapX, and then removes the TSL instance.
- Settings are persisted in the Element's mapX under the `hsbSheetDistribution` key, with each zone stored as a separate sub-map (`zone0`, `zone1`, etc.).
- The grip point (distribution origin) is stored per zone as `PointJig` for recalculation.
- When working with standalone sheets/SIPs (not part of an element), the script assigns new entities to the same groups as the original using `assignToGroups()`.
- Sheet properties (label, subLabel, subLabel2, information, grade, color) are copied from the first existing sheet/SIP to all newly created ones.
- The script uses `envelopeBody()` for beam shadow projections during constraint calculations for performance.
- Painter definitions can be distributed across drawings via the hidden `Painter Definition` property, which serializes the painter data into a DX content stream stored in the catalog.

---

*This documentation was generated for hsbCAD TSL script version 1.15 (February 2025)*
