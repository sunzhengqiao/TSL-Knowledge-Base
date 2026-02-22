# hsbEntityTag

## Overview

**hsbEntityTag** is a versatile labeling and annotation tool that reads property values from hsbCAD entities and displays them as visual tags in the drawing. It automatically extracts data such as position numbers, element numbers, article numbers, or any user-defined format expression, and renders the result with configurable text styles, shapes, leader lines, and colors.

The tool operates in both Model Space and Paper Space. In shop drawing contexts it integrates with ShopDrawView viewports, Section2D objects, and MultiPage layouts to support bulk tag creation with automatic quantity grouping. Tags remain parametric: when the referenced entity changes, the tag recalculates and updates its displayed text.

**Version:** 7.7
**Script Type:** O-Type (Object)
**Required Beams:** 0

---

## Usage Environment

| Environment | Supported | Notes |
|-------------|-----------|-------|
| Model Space | Yes | Primary usage; select any entity and place a tag |
| Paper Space | Yes | Works through ShopDrawView viewports |
| Block Editor | Yes | Creates tags linked to ShopDrawView objects, then mirrors them into Model Space |
| Sections | Yes | Bulk creation filtered by Painter Definitions; entities are clipped to section range |
| Multi-Page | Yes | Bulk creation across all views of a MultiPage; supports equality grouping |

---

## Prerequisites

- hsbCAD installed and configured with valid dimension styles in the drawing.
- Target entities (beams, panels, elements, metal parts, openings, trusses, etc.) must already exist.
- For shop drawing usage, ShopDrawView objects must be present in the block.
- For section-based tagging, Section2D objects must be available in the drawing.
- For filtered bulk creation, at least one Painter Definition should be configured.

---

## Step-by-Step Usage Guide

### Basic Tag Insertion (Model Space)

1. **Launch the tool** from the TSL menu, command line, or a catalog entry.

2. **Configure tag properties in the dialog.**
   The dialog appears with settings organized in four categories (General, Reference, Alignment, Display). Key settings include:
   - **Format**: The property expression that defines the displayed text. Leave empty for automatic detection based on entity type.
   - **Style**: Visual shape of the tag (Text, Box, Revision Cloud, or Triangle).
   - **Dimstyle**: The drawing dimension style that controls text appearance and height.
   - **Direction**: Text orientation (Horizontal, Vertical, X-Aligned, Y-Aligned).
   - **Alignment**: Anchor point of the text relative to the insertion point (nine-point grid from Top-Left to Bottom-Right).
   - **Leader Style**: Connection line from the tag to the entity (Disabled, Straight, Leader, Arrow, Dot, or their Multi variants).
   Click OK to confirm.

3. **Select entities.**
   When prompted, select one or more entities. Supported entity types:
   - GenBeam (timber members)
   - Sheet (panel sheets)
   - Sip (structural insulated panels / CLT panels)
   - Element (wall, roof, or floor assemblies)
   - Opening (doors, windows)
   - MetalPart (metal hardware and connectors)
   - TslInst (TSL script instances)
   - TrussEntity (roof trusses)
   - BlockRef (block references)
   - MasterPanel (master panels)
   - FastenerAssembly (fastener assemblies)
   - MassGroup (mass groups)
   - ChildPanel (child panels within master panels)
   - RoofPlane (roof planes)
   - Polyline (closed polylines display area; open polylines display length)

4. **Place the tag.**
   A jig preview follows your cursor showing the tag text. Click to place it. During placement you can use keyboard options:
   - **Assign Visible Entity** keyword: Select a different entity as the visual reference while keeping the original data link.
   - **Textheight** keyword: Enter a new text height interactively.
   Press Escape to cancel insertion.

5. **Multiple entities.**
   If you select more than one entity, the tool automatically creates one tag per entity, each positioned at the geometric center of its entity.

### Shop Drawing / Block Space Usage

1. **Open a block** containing ShopDrawView objects.
2. Launch hsbEntityTag.
3. Select the ShopDrawView viewport(s).
4. For each viewport, a tag instance is created in Model Space referencing the visible entities in that viewport.

### Section-Based Bulk Creation

1. During entity selection, select one or more Section2D objects.
2. Set the **Filter** property to a Painter Definition name to filter which entity types receive tags.
3. Tags are automatically created for every entity that passes the filter and falls within the section clip range.
4. Use **Equal Parts Format** to group identical items. Nearby items (within a range based on multiples of text height) that resolve to the same equality expression are consolidated, and a quantity is displayed.
5. The **Placement** property controls whether tags land at the entity center (Default) or outside the display area (Outside Range).

### Multi-Page Bulk Creation

1. Select a MultiPage entity during insertion.
2. If the MultiPage has multiple viewports, click inside the desired viewport to assign the tag.
3. Set the **Filter** property:
   - **Default**: Uses the defining entity only.
   - **Visible Set of Entities**: Includes all entities visible in the current showset.
   - **[Painter Definition name]**: Applies the named Painter Definition filter to the showset.
4. Use **Equal Parts Format** to group identical items within proximity.
5. Tags are created for all matching entities; identical items within a grouping distance (based on text height multiples) are consolidated with a quantity count.

---

## Properties Panel Parameters

### General Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Format** | String | (empty = auto) | Format expression defining the displayed text. Uses `@(PropertyName)` syntax. Leave empty to auto-detect based on entity type. |

### Reference Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Allow selection in XRef** | String (Yes/No) | No | When set to Yes, entity selection also allows picking entities nested inside block references or external references. |
| **Filter** | String | Default | Filters which entities receive tags. Options: Default (selected object), Visible Set of Entities (all visible entities in showset), or any configured Painter Definition name. Only visible when the tag is linked to a ShopDrawView, Section, or MultiPage. |
| **Group Assignment** | String | Default | Controls which layer the tag instance is assigned to. Default assigns the tag to the entity's own layer. Off places it on layer 0. Custom group names are also available. |
| **Equal Parts Format** | String | (empty) | Defines the rules for evaluating property equality to group identical items for quantity counting. Only visible in shop drawing, section, or multipage contexts. |

### Alignment Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Direction** | String | Horizontal | Text direction. Options: Horizontal, Vertical, X-Aligned (follows entity X-axis), Y-Aligned (follows entity Y-axis). |
| **Alignment** | String | Mid-Center | Text alignment relative to the insertion point. Nine-point grid: Top-Left, Top-Center, Top-Right, Mid-Left, Mid-Center, Mid-Right, Bottom-Left, Bottom-Center, Bottom-Right. |
| **Placement** | String | Default | Tag positioning strategy. Default places the tag at the geometric center of the entity. Outside Range places it outside the entity display area. Only visible when a non-default Filter is active. |

### Display Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Style** | String | Text | Visual style of the tag. Options: Text (plain text), Box (text inside a rectangle), Revision Cloud (text inside a revision cloud shape), Triangle (triangular marker). |
| **Dimstyle** | String | (first available) | Drawing dimension style that controls text font, height, and formatting. Only linear dimension styles are listed. |
| **Text Height** | Double | 0 | Text height in drawing units. When set to 0, the height is taken from the selected Dimstyle. |
| **Color** | Integer | 0 | Tag color. 0 = by instance color. -1 = by entity (can map surface quality colors via the 'SQ' alias). -2 = sequential coloring (used with GenericHanger scripts for visual differentiation). |
| **Transparency** | Integer | 0 | Background fill transparency. Positive values (1-99) fill with white at the specified transparency. Negative values (-1 to -99) fill with the tag's text color at the specified transparency. 0 = no fill. |
| **Leader Linetype** | String | Disabled | Linetype used for the leader line. Set to Disabled to hide the leader. Otherwise select from available drawing linetypes. Toggling this also toggles Leader Style. |
| **Leader Style** | String | Disabled | Style of the leader line endpoint. Options: Disabled, Straight (plain line), Leader (angled leader), Arrow (arrowhead), Dot (circle), Multi Straight, Multi Leader, Multi Arrow, Multi Dot. The "Multi" variants draw additional leader lines to sibling entities that share the same property value. |

---

## Right-Click Context Menu

| Command | Availability | Description |
|---------|-------------|-------------|
| **Clone Tag** | Model Space only (not in block, section, or SDV mode) | Creates copies of the current tag on other entities of the same type. Select target entities one by one; for each, specify an insertion point. The clone inherits all properties from the source tag. |
| **Assign Visible Entity** | Model Space only (not in SDV or section mode) | Reassigns the tag's visual reference to a different entity. The tag still reads data from the original defining entity, but draws its leader toward the newly assigned visible entity. Optionally reposition the tag. |
| **Release Visible Entity** | Only when a visible entity override exists | Removes the custom visible entity assignment and reverts to the original defining entity for both data and visual reference. |
| **Redraw Draw Outline** | Model Space only (not in page, SDV, or section mode) | Opens a dialog to configure outline display around the tagged entity. Settings include Zone (element zone index), Color, Transparency, Fill Color, and a toggle to enable or disable the outline. The outline is drawn on the specified zone layer. |
| **Set Plot Scale Factor** | Only when the Format contains "ScaleFactor" | Prompts for manual entry of the plot scale factor value. Also triggered by double-clicking the tag. |

---

## Format Expression Reference

### Automatic Formats by Entity Type

When the **Format** property is left empty, the tool selects an appropriate default expression:

| Entity Type | Auto Format | Example Output |
|-------------|-------------|----------------|
| GenBeam (Beam) | `@(PosNum)` | "1" |
| Element (Wall/Roof/Floor) | `@(ElementNumber)` | "W-101" |
| TSL Instance | `@(ScriptName)` | "GenericHanger" |
| Opening | `@(Width:RL0)x@(Height:RL0)` | "900x2100" |
| MetalPart | `@(Definition)` | "AngleBracket_90" |
| TrussEntity | `@(TrussMark:D)` | "T1" |
| Polyline (closed) | `Area: @(Area)` | "Area: 2.5m2" |
| Polyline (open) | `Length: @(Length)` | "Length: 3500mm" |
| BlockRef | `@(BlockName:D)` | "DetailA" |
| MasterPanel | `@(Number)` | "P-001" |
| FastenerAssembly | `@(ArticleNumber)` | "HIT-V 5.8" |
| MassGroup | `@(Description)` or `Massgroup @(Handle:D)` | "Steel Plate" or "Massgroup 2A3F" |
| Other | `@(TypeName)` | "GenBeam" |

### Format Syntax

| Syntax | Description | Example |
|--------|-------------|---------|
| `@(PropertyName)` | Basic property lookup | `@(PosNum)` |
| `@(PropertyName:D)` | Returns empty string if property not found (instead of showing the raw expression) | `@(TrussMark:D)` |
| `@(PropertyName:RL0)` | Rounded length with zero decimal places | `@(Width:RL0)` |
| `@(PropertyName:A;SQ)` | Maps value through the alias definition named 'SQ' | `@(Quality:A;SQ)` |
| Combined expressions | Free text mixed with multiple property tokens | `@(Width:RL0)x@(Height:RL0)` |

### Commonly Used Format Variables

| Variable | Applicable Entity Types | Description |
|----------|------------------------|-------------|
| `@(PosNum)` | Beams, Panels, TSL Instances | Position number (assigned during numbering) |
| `@(ElementNumber)` | Elements | Element identification number |
| `@(Definition)` | MetalParts, General entities | Entity definition name |
| `@(ScriptName)` | TSL Instances | Name of the TSL script |
| `@(Width)`, `@(Height)`, `@(Length)` | Beams, Openings | Dimensional properties |
| `@(SolidWidth)`, `@(SolidHeight)`, `@(SolidLength)` | Beams | Solid body dimensions |
| `@(SizeX)`, `@(SizeY)`, `@(SizeZ)` | General entities | Bounding box dimensions |
| `@(ArticleNumber)` | FastenerAssemblies | Fastener article number |
| `@(BlockName)` | BlockRefs | Block definition name |
| `@(TrussMark)` | TrussEntity | Truss identification mark |
| `@(Number)` | MasterPanels | Panel number |
| `@(Quantity)` | All numbered entities | Count of identical items (requires numbering to be applied; resolves to "0" if not numbered) |
| `@(TotalWeight)` | MetalParts | Total weight multiplied by quantity |
| `@(Area)` | Closed polylines | Enclosed area |
| `@(Length)` | Open polylines | Total polyline length |
| `@(SurfaceQualityTopStyle)` | Panels (Sip) | Top surface quality designation |
| `@(SurfaceQualityBottomStyle)` | Panels (Sip) | Bottom surface quality designation |
| `@(XRefName)` | Entities nested in XRefs | Name of the parent external reference |
| `@(modelDescription)` | TSL Instances | Model description character (A-Z) |
| `@(Handle)` | All entities | AutoCAD handle (unique ID) |
| `@(DxfName)` | All entities | DXF entity type name |
| `@(ColorIndex)` | Beams | Entity color index |
| `@(GroupFloorHeight)`, `@(GroupHeight)` | Elements | Element group height values |
| `@(ScaleFactor)` | Special | Plot scale factor (triggers Set Plot Scale Factor context command) |
| `@(DATALINK....)` | TSL Instances | Access to nested data link properties |

---

## Settings and Configuration

### External Files

This script does not require dedicated XML settings files for basic operation. It integrates with the following drawing-level and system-level configurations:

- **Painter Definitions**: Used for entity filtering in shop drawing and section contexts. All configured Painter Definitions are listed in the Filter dropdown. Reserved filter names ("Default", "Visible Set of Entities") cannot be used as Painter Definition names.
- **Dimension Styles**: Drawing-level dimension styles control text font, height, and formatting. Only linear dimension styles (and their type-specific overrides denoted by `$0`, `$2`, etc.) are shown.
- **Alias Definitions**: An alias named 'SQ' can map surface quality values to specific colors when the Color property is set to -1.
- **Catalog Entries**: The tool supports catalog-based insertion. If launched with a catalog entry name as the execute key, properties are loaded from that catalog silently (without showing the dialog).

### Map Data (Internal Storage)

The tag stores its state in the instance Map, including:
- `UID`: Unique identifier for shop drawing generation.
- `VisibleEntity`: Reference to an optional visible entity override.
- `DrawOutline`: Sub-map containing outline display settings (Draw, Zone, Color, transparency, FillColor).
- `PlotScale`: Custom plot scale factor value.
- `vecOrg`: Relative location offset (used for MultiPage repositioning).
- `isPageDependant`: Flag indicating the tag should auto-erase if the parent MultiPage is deleted.

---

## Behavioral Details

### Leader Line Behavior

- The leader line is **automatically suppressed** when the tag insertion point falls inside the entity shape or opening boundary. This prevents overlapping leaders.
- When using `@(SurfaceQualityTopStyle)` or `@(SurfaceQualityBottomStyle)`, the leader automatically points toward the corresponding face of the panel. In non-front views on shop drawings, the format automatically swaps to display the quality of the face closest to the tag position.
- The "Multi" leader variants (Multi Straight, Multi Arrow, Multi Dot) draw additional leader lines from the tag to all sibling entities that share the same property value. Duplicate projection positions are filtered out. Multi leaders are supported for GenBeam, MetalPart, FastenerAssembly, MasterPanel, and Element entities.
- Toggling Leader Linetype to Disabled automatically sets Leader Style to Disabled, and vice versa. The last-used values are remembered.

### Tag Z-Position

Tags draw at the highest Z-location of the entity and its references. This ensures tags remain visible in visual styles (shaded views) and are not hidden behind solid geometry.

### View Direction Sensitivity

Tags are optimized for the view direction at the time of insertion. For X-Aligned and Y-Aligned directions, the tag orientation follows the entity's local coordinate system axes. A warning is issued if the current view direction is parallel to the Z-axis (plan view looking straight down), as this can cause display issues with certain alignment modes.

### XRef and Block Reference Handling

- When **Allow selection in XRef** is set to Yes, entities nested within block references or external references can be selected for tagging.
- XRef path prefixes are automatically stripped from resolved property values (for example, `ElementNumber` returns just the number, not the full XRef path).
- If a tag is linked to a BlockRef and that BlockRef is exploded, the tag becomes static text (no longer updates dynamically).
- In section contexts with XRef content, metal parts and other entities within XRefs are supported with style data and quantity counting via the equality format.

### Quantity Counting

- The `@(Quantity)` variable requires the entity to have been numbered (using hsbCAD's numbering system). If the entity is not numbered, it resolves to "0".
- In section and multipage contexts, the **Equal Parts Format** property defines which properties must match for two entities to be considered identical. Only entities within a proximity range (multiples of the text height) are grouped together.
- The `@(TotalWeight)` variable for metal parts multiplies the individual weight by the quantity.

### Automatic Cleanup

- Tags linked to Section2D objects are automatically purged (erased) if the parent section is deleted during recalculation.
- Tags linked to MultiPage objects are automatically erased if the MultiPage is deleted (tracked via the `isPageDependant` flag).
- Tags with a filter that returns no matching entities are automatically erased (introduced in version 7.7).
- During insertion, existing hsbEntityTag instances and entities with zero-volume bodies are automatically removed from the selection set to prevent tagging tags.

### Catalog Support

The tool supports catalog-based insertion using `setPropValuesFromCatalog()`. When launched with a catalog entry name, properties are loaded without showing the insertion dialog. The "LastInserted" catalog entry stores the most recently used settings for quick re-insertion.

---

## Tips and Best Practices

1. **Use auto-format for speed.** Leave the Format field empty to let the tool auto-detect the most relevant property. This works well for common workflows like labeling beams with position numbers or openings with dimensions.

2. **Combine format expressions.** You can mix free text with multiple property tokens, such as `@(PosNum) - @(Definition)` to show both the position number and the definition name in one tag.

3. **Use Multi leaders for grouped labeling.** When several beams or metal parts share the same property value, use Multi Arrow or Multi Dot leader styles. The tool draws a single tag with multiple leader lines pointing to each matching sibling entity.

4. **Leverage Equal Parts Format for quantities.** In shop drawing and section contexts, set the Equal Parts Format to the same expression as your Format to group identical items. For example, if Format is `@(Definition)` and Equal Parts Format is also `@(Definition)`, entities with the same definition within proximity are grouped with a quantity count.

5. **Surface quality tagging.** For CLT or panel face labeling, use `@(SurfaceQualityTopStyle)` or `@(SurfaceQualityBottomStyle)`. Set Color to -1 and configure an 'SQ' alias to map quality values to specific colors. The leader automatically adjusts to point toward the corresponding face.

6. **Set view before insertion.** Tags are created for the current view direction. For best results with X-Aligned or Y-Aligned directions, ensure the correct view is active before inserting tags.

7. **Use Placement = Outside Range** for dense drawings. When creating tags via filters on sections or multipages, the Outside Range placement positions tags outside the entity boundary, reducing visual clutter.

8. **Clone Tag for repetitive labeling.** Instead of inserting new tags one by one, place a single tag with the desired settings, then use the Clone Tag context command to quickly copy it to other entities of the same type.

9. **Outline display for highlighting.** Use the Redraw Draw Outline context command to draw a colored outline around the tagged entity on a specific zone layer. This is useful for quality assurance or highlighting specific parts in shop drawings.

10. **Triangle style for hangers.** The Triangle style works especially well with GenericHanger scripts. When a parent entity provides sequential colors (Color = -2), each tag in a group receives a different color for visual differentiation.

11. **Background fill for readability.** Use positive Transparency values (e.g., 50) for a semi-transparent white background behind the tag text. Use negative values (e.g., -50) for a colored background matching the text color.

12. **Text height override during insertion.** During the point-selection jig, use the Textheight keyword option to interactively change the text height without reopening the dialog.

---

## Frequently Asked Questions

**Q: The tag shows the raw format expression (e.g., "@(PosNum)") instead of the actual value.**

A: The entity may not have the requested property, or the property name may be misspelled. Verify that the format expression matches available properties for the entity type. Use an empty Format to let auto-detection choose the correct property. If using `:D` suffix (e.g., `@(PosNum:D)`), the tag will show an empty string instead of the raw expression when the property is not found.

**Q: How do I display quantity counts for identical parts?**

A: Include `@(Quantity)` in your Format. The entities must have been numbered using hsbCAD's numbering system. In shop drawing or section contexts, also set the Equal Parts Format to define equality criteria. Entities that are not numbered will show "0" for quantity.

**Q: The tag disappears when I switch views.**

A: Tags are created for a specific view direction. If the current view is perpendicular to the tag's original insertion view, the tag may not display. Create separate tags in each view where they should be visible.

**Q: How do I tag entities inside an XRef or block reference?**

A: Set the "Allow selection in XRef" property to "Yes" before selecting entities. This enables nested selection within block references and external references. Note that XRef path prefixes are automatically stripped from resolved values.

**Q: Can I copy a tag to multiple similar entities quickly?**

A: Yes. Right-click the tag and choose "Clone Tag". This opens a selection loop where you can pick entities of the same type one by one and specify insertion points for each clone. All clones inherit the source tag's properties.

**Q: The leader line overlaps with my entity or opening.**

A: The leader is automatically suppressed when the tag is positioned inside the entity shape or opening boundary. Move the tag outside the entity boundary to show the leader, or set Leader Style to "Disabled" to hide it entirely.

**Q: How do I show different colors for surface quality values?**

A: Set the Color property to -1. Then create an Alias definition named 'SQ' in your hsbCAD configuration that maps each surface quality value to a color index. The tag will use the mapped color automatically.

**Q: My tag is not updating when the entity changes.**

A: Verify the entity reference is still valid. If the tag was linked to a block reference that was subsequently exploded, the tag becomes static text and no longer updates. In that case, delete the tag and create a new one. Also check that the tag's dependency chain is intact (no broken references).

**Q: How does the "Visible Set of Entities" filter work?**

A: This option is only available in shop drawing contexts (when linked to a ShopDrawView or MultiPage). It includes all entities in the current showset (the set of entities visible in the viewport). Combined with Equal Parts Format, it groups identical items within a proximity range (based on multiples of the text height) for consolidated labeling with quantity display.

**Q: Why does my tag get deleted automatically?**

A: Tags are automatically erased in several situations: (1) The parent Section2D object was deleted. (2) The parent MultiPage was deleted. (3) The Filter returns no matching entities (introduced in version 7.7). (4) A MultiPage has no valid views. Check whether the referenced parent object still exists.

**Q: Can I use this tool with catalog entries for standardized tagging?**

A: Yes. Save your preferred tag settings as a catalog entry. When launching hsbEntityTag with a catalog name, properties are loaded silently without showing the dialog. This is useful for automated or standardized workflows.

**Q: What happens when I select both model entities and ShopDrawView viewports?**

A: The tool prioritizes ShopDrawView viewports. If any viewports are found in the selection, it enters shop drawing mode and creates tags for entities visible through those viewports. Model entities in the same selection are handled separately only if no viewports are present.

---

## Version History (Recent)

| Version | Date | Key Changes |
|---------|------|-------------|
| 7.7 | Feb 2025 | Tags auto-erase when filter returns no entities |
| 7.6 | Feb 2025 | Painter filter visible when inserted on MultiPage in Model Space |
| 7.5 | Jun 2025 | Block space detection improved |
| 7.4 | Jun 2025 | Multi leaders selectable in block space |
| 7.3 | Jun 2025 | Metal part performance improved in sections and multipages |
| 7.0 | Jun 2025 | Accepts multipages without defineSet if showSet is valid |
| 6.8 | May 2025 | New "Visible Set of Entities" filter for shop drawings |
| 6.6 | May 2025 | Bulk creation within multipage showset with equality grouping |
| 6.4 | Apr 2025 | New Placement property (Default / Outside Range) |
| 5.6 | Feb 2025 | Multi leader styles added |
| 5.4 | Feb 2025 | FastenerAssembly support; new leader styles (Arrow, Dot) |
| 5.1 | Nov 2024 | Triangle style; sequential colors; modelDescription support |
| 4.7 | Oct 2024 | Section support with Painter Definition filtering |

---

## Related Tools

| Tool | Relationship |
|------|-------------|
| **hsbLayoutEntityTag** | Layout-specific variant for Paper Space tag placement |
| **hsbMultipage** | Multi-page shop drawing controller; provides the MultiPage entities that hsbEntityTag can reference |
| **PainterDefinition** | Entity filtering system used by the Filter property for bulk tag creation |
| **GenericHanger** | Hanger scripts that support sequential color tagging with the Triangle style |
| **hsbViewTag** | View-based tag placement tool (complementary to entity-based tagging) |
| **hsbLayoutTag** | Layout tag tool for Paper Space annotations |
