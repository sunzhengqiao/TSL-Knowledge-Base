# StackItem

Creates stackable items from selected CAD entities for use with the StackPack and StackEntity (Truck/Stack) tool set. This script generates flattened 2D representations of beams, panels, elements, and metal parts for logistics planning and transportation layout.

---

## Overview

StackItem is part of the stacking tool suite in hsbCAD that allows users to visualize and organize timber components for transport loading. When you insert a StackItem, it creates a simplified representation of the selected entity that can be:

- Assigned to a StackPack (grouping multiple items together)
- Assigned to a StackEntity/Truck (loading onto a transport vehicle)
- Rotated and flipped to optimize loading arrangements
- Filtered by painter definitions or content filters

The tool automatically calculates the item's footprint, center of gravity, and provides various display options for shop drawings and model views.

---

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object) |
| Workspace | Model Space |
| Beams Required | 0 |
| Version | 4.4 |

---

## Prerequisites

Before using StackItem, ensure you have:

1. **Entities to stack**: Beams, sheets, panels, elements, or metal parts in your drawing
2. **Optional**: Painter definitions configured for filtering specific entity types
3. **Settings file**: StackEntity.xml (automatically loaded from company or installation path)

**Supported Entity Types:**
- GenBeam (beams and sheets)
- Panel (SIP panels)
- Element (walls, roofs, floors)
- MetalPart and MetalPartCollection
- TslInst (AssemblyDefinition scripts)

---

## Step-by-Step Usage Guide

### Inserting a StackItem

1. **Launch the script**
   - From the TSL ribbon/toolbar, select StackItem
   - Or type the command to insert StackItem

2. **Configure filter settings** (dialog appears)
   - **Filter**: Select a painter definition to filter which entities are accepted, or use `<bySelection>` to accept any selected entity
   - **Sorting**: Choose Ascending, Descending, or Disabled for sorting order
   - **Alignment**: Choose Horizontal (flat) or Vertical (standing)
   - **Spacer Height**: Enter the height of spacers/dunnage beneath the item
   - Click OK to proceed

3. **Select entities**
   - Select one or more beams, panels, elements, or other supported entities
   - Press Enter to confirm selection
   - If using a filter, only matching entities will be accepted

4. **Place the item**
   - Move the cursor to position the stack item preview
   - The preview shows the flattened footprint of the selected entity
   - **Keyboard options during placement:**
     - Type `H` or `V` to toggle between Horizontal/Vertical alignment
     - Type `R` to rotate the preview by 90 degrees
   - Click to place the item(s)

5. **Result**
   - A StackItem is created for each selected entity
   - Items display their footprint outline and optional label text
   - Items can now be assigned to StackPack or StackEntity for loading layouts

### Modifying Existing StackItems

**Via Properties Panel:**
- Select a StackItem and modify properties in the AutoCAD Properties Palette (see Properties Panel Parameters below)

**Via Right-Click Menu:**
- Select a StackItem, right-click to access rotation and flip commands (see Right-Click Menu Options below)

**Via Grip Points:**
- Drag the base grip to reposition the item
- Drag items into a StackPack or StackEntity to assign them
- Drag items out of a pack/stack to unassign them
- Drag the tag grip (circular) to move the label position

---

## Properties Panel Parameters

### Filter Category

| Parameter | Description | Default |
|-----------|-------------|---------|
| **Filter** | Painter definition used to filter which entities are accepted. Use `<bySelection>` to accept any selected entity. Controls which Sorting options are available. | `<bySelection>` |
| **Sorting** | Sorting order for items: Disabled, Ascending, or Descending. Only visible when Filter is set to `<bySelection>`. | Disabled |
| **Content Filter** | Secondary painter definition to filter the content within an item (e.g., exclude certain sheeting zones from the stacking calculation). Use `<Default>` for no content filtering. Hidden for single GenBeam sources. | `<Default>` |

### Alignment Category

| Parameter | Description | Default |
|-----------|-------------|---------|
| **Alignment** | Item orientation: Horizontal (flat lying) or Vertical (standing upright). Affects which spacer properties are visible. | Horizontal |
| **Spacer Height** | Height of spacers/dunnage beneath the item in current drawing units. Used for accurate loading height calculations. | 0 |
| **Vertical Spacer Thickness** | Thickness of vertical spacers between items. Only visible when Alignment is set to Vertical. | 0 |

### Display Category

| Parameter | Description | Default |
|-----------|-------------|---------|
| **Format** | Format string for the item label display. Uses hsbCAD format tokens. Controls what information appears in the tag. | `@(PosNum:D)` |
| **Resolution** | Detail level for the item geometry. Options: Low Detail (envelope only), Medium Detail (simplified profiles), Medium Profile Detail, High Detail (full geometry). Affects performance. | Medium Detail |
| **Projection Display** | Controls which boundary projection lines are shown in model views: None, Top, Bottom, Front, Back, Left, Right, or combinations (e.g., Top + Bottom, All). | None |
| **Dimstyle** | Dimension style used for labels and measurements. XRef dimension styles are automatically excluded. | (Drawing default) |
| **Text Height** | Text height for labels. Enter 0 to use the dimension style's default text height. | 0 |

---

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Rotate** | Opens an interactive rotation jig. Select an axis (X, Y, or Z) by clicking near the corresponding colored circle (Red=X, Green=Y, Blue=Z), then drag to rotate. Snap increments change based on distance from center: 45 degrees near center, 22.5 degrees, 10 degrees, 5 degrees, 1 degree furthest out. Options during rotation: type `A` to enter a precise angle value, `B` to pick a new basepoint, or `R` to define a reference line for alignment. |
| **Flip Face** | Flips the item 180 degrees around its local X-axis (turns the item over like a pancake). |
| **Rotate 90** | Rotates the item 90 degrees clockwise around its Z-axis. |
| **Rotate 180** | Rotates the item 180 degrees around its Z-axis. |
| **Flip + Rotate** | Combines Flip Face and Rotate 180 operations in sequence (flips over and rotates). |
| **Update XRef-Data** | Updates datalinks when the item references entities in external references (XRefs). Prompts if the XRef file cannot be locked. |
| **Component Settings** | Opens a dialog to configure advanced display components. Available components include Center of Gravity marker, Grain Direction arrow (panels only), and Surface Quality indicators (panels only). Each component can have separate visibility settings for Item, Pack, and Stack states. |

---

## Component Settings Dialog

The Component Settings dialog allows customization of visual components displayed on stack items. Each row in the dialog defines one component with the following columns:

| Column | Description |
|--------|-------------|
| **Component** | Type of visual component: Center of Gravity, Grain Direction, Highest Surface Quality, or Lowest Surface Quality |
| **Applies to** | Entity type this component applies to: Any Type, GenBeam, Beam, Sheet, Panel, Element, Wall, Roof/Floor, or MetalPart |
| **Visibility Item** | Show component when item is standalone (not in pack/stack) |
| **Visibility Pack** | Show component when item is assigned to a StackPack |
| **Visibility Stack** | Show component when item is assigned to a StackEntity |
| **Scale** | Size multiplier for the component (must be > 0) |
| **Color** | Color index: -1 = use item color, -2 = use Surface Quality alias mapping, or specific AutoCAD color index |
| **Transparency** | Transparency level (0-100, where 0 is opaque) |

---

## Settings Files

StackItem uses settings from the **StackEntity.xml** configuration file.

**File Locations (searched in order):**
1. Company path: `[hsbCompanyPath]\TSL\Settings\StackEntity.xml`
2. Installation path: `[hsbInstallPath]\Content\General\TSL\Settings\StackEntity.xml`

**Settings Structure:**
- `Item\Horizontal\Plan` - Horizontal alignment display settings (wireframe and fill transparency)
- `Item\Vertical\Plan` - Vertical alignment display settings
- `Item\Components\MPROWDEFINITIONS` - Component display configurations (COG, Grain Direction, Surface Quality)
- `ColorRule` - Color assignment rule (0=byLayerPackIndex, 1=byPackNumber, 2=byStackIndex)
- `SequentialColors` - Color palette for layer-based coloring

**Note:** When a version mismatch is detected between the drawing's settings and the installation settings, a notification is displayed with options to update.

---

## Grip Points

StackItem provides multiple grip points for manipulation:

| Grip Type | Appearance | Function |
|-----------|------------|----------|
| **Tag Grip** | Circle at label position | Moves the position of the item's text label in plan view |
| **Corner Grips** | Circles at shape corners | Reposition the entire item; snap onto StackPack or StackEntity to assign |
| **Edge Grips** | Circles at edge midpoints | Reposition along specific axes |

**Grip Behavior:**
- When dragging onto a StackPack or StackEntity, the target is highlighted
- Release to assign the item to that pack/stack
- Color changes automatically based on assignment status

---

## DataLink Integration

StackItem maintains bidirectional data links with its source entity through the DataLink subMapX:

- **StackItem reference** stored on source entity
- **StackPack reference** updated when assigned to a pack
- **StackEntity reference** updated when assigned to a stack/truck

This enables other tools to query stacking relationships programmatically.

---

## Tips

1. **Efficient Selection**: Use painter definitions (Filter property) to quickly select only specific types of entities. For example, create a painter for "Panels" to stack only panel elements.

2. **Vertical vs Horizontal**: Use Horizontal alignment for flat items like floor panels. Use Vertical alignment for wall panels that will be transported standing up.

3. **Spacer Heights**: Set the Spacer Height to match your actual dunnage/bearer dimensions for accurate loading height calculations in the truck layout.

4. **Quick Rotation**: During the interactive Rotate command, move closer to the center for coarser snap angles (45 degrees) or further away for finer control (1 degree).

5. **Drag Assignment**: Simply drag a StackItem's grip point onto a StackPack or StackEntity to assign it. The item color will change to indicate assignment status.

6. **Content Filtering**: Use the Content Filter to exclude certain components from the stacked representation, such as sheeting zones that will be mounted on-site rather than pre-installed.

7. **Format Strings**: Customize the Format property to display relevant information. Common tokens include:
   - `@(PosNum:D)` - Position number
   - `@(SolidLength:RL0:PL5;0)` - Length with rounding
   - `@(SolidHeight:RL0:PL3;0)` - Height with rounding
   - `@(ElementName)` - Element name
   - `@(Weight)` - Calculated weight (if available)

8. **Resolution Performance**: Use "Low Detail" or "Medium Detail" for large projects with many items to improve performance. Switch to "High Detail" only when needed for detailed visualization.

9. **Surface Quality Colors**: Set Color to -2 in Component Settings to map Surface Quality values to specific colors using the 'SQ' alias configuration.

10. **Duplicate Prevention**: The script automatically prevents duplicate StackItems for the same source entity and purges orphaned duplicates.

---

## Frequently Asked Questions

**Q: Why can't I select certain entities when inserting a StackItem?**

A: The Filter property may be restricting which entities are accepted. Check the Filter setting in the properties dialog - if a specific painter is selected, only entities matching that painter's criteria will be accepted. Set Filter to `<bySelection>` to accept any valid entity type.

**Q: How do I assign a StackItem to a pack or truck?**

A: There are two methods:
1. Drag the item's grip point and drop it onto an existing StackPack or StackEntity
2. Use the StackPack or StackEntity script and select the items to include

**Q: Why does my StackItem show in a different color?**

A: Item colors indicate assignment status:
- Original entity color: Item is standalone (unassigned)
- Sequential colors: Item is assigned to a StackPack (color indicates layer position)
- Different sequential palette: Item is assigned to a StackEntity/Truck

**Q: Can I stack Elements (walls/floors/roofs)?**

A: Yes, Elements are fully supported. The script will create a flattened representation of the entire element including all beams, sheets, and hardware. For complex elements, the resolution may automatically fall back to "Low Detail" if the geometry is too complex.

**Q: How do I change the label text shown on items?**

A: Modify the Format property to customize what information is displayed. The format uses hsbCAD's format token system - see the hsbCAD documentation for available tokens.

**Q: Why is the Vertical Spacer Thickness property hidden?**

A: This property only appears when Alignment is set to Vertical. It defines the spacing between vertically stacked items for clearance during transport.

**Q: How do I update items after modifying the source entity?**

A: StackItems automatically recalculate when their source entity changes due to dependency tracking. If you need to force an update, use the REGEN command or select the items and use the hsbCAD recalculate function.

**Q: Can I use StackItem with XRefs?**

A: Yes, StackItem supports entities from external references. Use the "Update XRef-Data" right-click command to refresh datalinks. Note that the XRef file must be closed (not open in another AutoCAD session) for the update to succeed.

**Q: Why is the Content Filter property hidden for some items?**

A: The Content Filter is only available for Element-type sources and TslInst sources. It is hidden when the source is a single GenBeam (beam or sheet) since there is no sub-content to filter.

**Q: What happens if I already have a StackItem attached to an entity?**

A: The script prevents duplicate StackItems for the same entity. If an orphaned (unassigned) StackItem exists and is invisible, selecting the entity again will make the existing item visible rather than creating a duplicate.

---

## Related Scripts

| Script | Purpose |
|--------|---------|
| **StackPack** | Groups multiple StackItems into a package for organized loading |
| **StackEntity** | Creates truck/transport layouts for loading StackItems and StackPacks |
| **AssemblyDefinition** | Can be used as source entities for StackItem |
| **hsbCenterOfGravity** | Called internally to calculate weight and center of gravity |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 4.4 | 18.06.2025 | Grip move behavior improved for smoother drag operations |
| 4.3 | 28.02.2025 | New component display supporting MetalPartCollections |
| 4.2 | 12.02.2025 | Component settings dialog prepared (development) |
| 4.1 | 12.02.2025 | Full support for new controlling properties behavior |
| 4.0 | 31.01.2025 | Items excluded from sectional views |
| 3.9 | 19.12.2024 | Panel element orientation fixed for element-dependent panels |
| 3.8 | 19.12.2024 | Property assignment for projection/dimstyle fixed |
| 3.7 | 12.12.2024 | Vertical spacer height available during insert |
| 3.6 | 06.12.2024 | XRef datalink support added, text size issue resolved |
| 3.5 | 29.11.2024 | Content Filter property added for excluding sheeting zones |
| 3.4 | 29.11.2024 | Performance improvement for MetalPart shape type |
| 3.3 | 24.09.2024 | Element references improved |
| 3.2 | 17.09.2024 | Invisible orphaned items made visible on re-selection |
| 3.1 | 17.09.2024 | Insert jig supports vertical/horizontal toggle, UCS alignment corrected |
| 3.0 | 11.09.2024 | Parent assignment with spacer height fixed |
| 2.9 | 22.08.2024 | Custom color coding settings introduced |
| 2.8 | 20.08.2024 | Projection Display property added |
| 2.7 | 16.08.2024 | Jigging improved, solid detailing improved |
| 2.6 | 05.08.2024 | Rotate command for any main axis |
| 2.5-2.4 | 29.07.2024 | Vertical element stacking improved |
| 2.3 | 03.06.2024 | Drag jigs made more transparent |
| 2.2 | 10.05.2024 | Pack update when dragging location |
| 2.1 | 08.05.2024 | StackItem written to Datalink subMapX |
| 2.0 | 13.12.2023 | Low/high resolution improved, selection set filtering |
| 1.9 | 01.12.2023 | Element support added |
| 1.4 | 18.10.2023 | First beta release |
| 1.0 | 27.09.2023 | Initial version |

---

## Technical Notes

**Coordinate System Handling:**
- The script automatically aligns the item's coordinate system based on the source entity type
- For element-dependent panels, the element's coordinate system is used
- World Coordinate System (WCS) alignment is enforced during insert

**Performance Considerations:**
- Resolution settings significantly impact performance with many items
- Body caching is used to avoid recalculating geometry when only non-geometry properties change
- Low Detail mode uses simple envelope geometry

**Automatic Duplicate Prevention:**
- The script checks for existing StackItems attached to the same entity
- Orphaned items (parent no longer exists) are automatically made visible
- Purge messages appear in the command line when duplicates are removed
