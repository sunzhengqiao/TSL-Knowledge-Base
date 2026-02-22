# hsbViewCoordinateDimension

## Overview

`hsbViewCoordinateDimension` is a TSL Object-type script (Type O) that automatically generates coordinate-based dimension annotations for TSL script instances visible within a drawing view. Rather than producing chain or baseline dimensions between members, it reads the origin point (or custom published dimension points) of each TSL instance attached to an element and draws a coordinate value -- the measured distance from a defined reference -- at or near each point. The dimension can include additional formatted text attributes appended to the numeric value, making it suitable for annotating hardware positions, opening locations, or any other TSL-placed object relative to a datum inside a shop drawing or layout view.

The tool supports three types of view contexts: standard AutoCAD Paper Space viewports, hsbCAD ShopDraw viewports (ShopDrawView), and 2D Section views (Section2d with ClipVolume). It is especially useful in shop drawings where precise positional callouts are required for each fastener, bracket, or specialty component placed along an element.

By default, the origin point of every TSL instance visible in the linked view is used as a dimension point. Dimensions can be oriented horizontally or vertically, placed locally near each point or grouped globally in a single dimension column. An optional filter rule system -- driven by an XML settings file -- allows specific TSL script types to be excluded or included selectively.

Version history spans v1.0 (July 2019) through v1.5 (October 2020), with additions including a Reference zone property, non-solid snapping to reference zone outlines, and internal naming improvements.

Keywords: `Dimension`, `Coordinate`, `Format`, `Element`, `Section`, `Shopdrawing`

---

## Usage Environment

| Attribute | Value |
|-----------|-------|
| Script Type | O (Object -- placed as a persistent entity in the drawing) |
| Beams Required | 0 |
| Intended Space | Paper Space (Layout Tab), ShopDraw viewports, or Model Space Section views |
| Recalculates With | Linked viewport, element, section, or clip volume |

This script is placed in one of three contexts:

- **Paper Space layout tab**: the tool is placed outside a viewport and linked to a standard AutoCAD viewport containing an hsbCAD element.
- **Block space containing ShopDraw viewports**: the tool detects ShopDrawView entities in the current space and links to the selected one.
- **Model Space with a Section2d entity**: the tool links to the Section2d and its associated ClipVolume; one instance is created per selected section.

The coordinate values reported in the dimension annotations are calculated in model space and expressed relative to the chosen reference datum (element origin or a specific structural zone face).

---

## Prerequisites

- An active hsbCAD drawing with at least one element (wall, floor, or roof panel) visible inside a viewport or section view.
- TSL script instances (TslInst objects) attached to the element. The script reads each instance's origin point as its default dimension location.
- A valid dimension style (dimstyle) available in the drawing.
- Optionally, an XML settings file named `hsbViewCoordinateDimension.xml` located at `<CompanyPath>\TSL\Settings\` to define custom filter rules. If no file is found, a built-in default filter rule named "Sherpa" is applied (which excludes TSL instances whose ScriptName matches "Sherpa"). The settings file can be managed using the `hsbTslSettingsIO` tool.

TSL script authors who want to publish custom dimension points rather than using the script origin can do so by writing a `Point3dArray` named `"Points"` into a sub-map named `"CoordinateDimension"` in the script's `_Map`:

```c
Map mapCoordinateDimension;
mapCoordinateDimension.setPoint3dArray("Points", ptLocs);
_Map.setMap("CoordinateDimension", mapCoordinateDimension);
```

When this sub-map is present, the coordinate dimension tool uses those published points instead of the TSL origin.

---

## How to Use

### Step 1 -- Launch the Script

Run the insertion command from the AutoCAD command line or a menu entry that calls:

```
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbViewCoordinateDimension")) TSLCONTENT
```

A dialog box appears for configuring properties before placement. You may also pass a catalog entry key as the execute key to bypass the dialog and load a previously saved configuration.

### Step 2 -- Select the View Context

The behavior at insertion depends on the current drawing context:

- **In a Paper Space Layout Tab**: You are prompted to select a viewport (`Select a viewport`). The tool links itself to that viewport and reads the element displayed inside it.
- **In a block space with ShopDraw viewports**: The tool automatically detects ShopDrawView entities in the current space and prompts you to select the desired one.
- **In Model Space**: You are prompted to select one or more Section2d entities (`Select Section2d`). The tool creates one instance per selected section, each linked to its respective ClipVolume, and then erases the temporary insertion instance.

### Step 3 -- Pick a Placement Point

After selecting the view context (for viewport and ShopDraw modes), you are prompted to pick a point outside the Paper Space viewport border (`Pick a point outside of paperspace`). This anchor point determines the side on which global dimension lines are drawn, or serves as the reference origin for global alignment modes.

### Step 4 -- Review the Annotations

After placement, the script recalculates automatically. It collects all TSL instances visible in the linked viewport or section, applies any active filter rule, computes coordinate values from each dimension point relative to the configured reference, and draws the annotations in the drawing. Adjust the Properties Palette parameters to refine the output.

---

## Properties Panel (OPM Parameters)

All parameters are accessible in the AutoCAD Properties Palette (Ctrl+1) when the inserted `hsbViewCoordinateDimension` object is selected.

### Content Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Format** | Text (PropString) | *(empty)* | Defines the text content appended after the numeric coordinate value. Supports `@(VariableName)` tokens to insert entity attributes dynamically. Multiple lines within a single callout are separated by the `\P` character sequence. Common tokens include `@(ScriptName)`, `@(Posnum)`, and `@(Calculate Weight)`. The Format string can be built interactively using the right-click "Add/Remove Format" command. |
| **Filter Rule** | Dropdown (PropString) | `<Disabled>` | Selects a named filter rule from those loaded from the XML settings file. Filter rules define include or exclude criteria based on format attribute matching. When set to `<Disabled>`, no filtering is applied and all TSL instances in the view are dimensioned. If fewer than two rules are available, this field is read-only. |
| **Reference** | Dropdown (PropString) | `byElement` | Sets the datum from which coordinate values are measured. `byElement` uses the element's origin point. Zone options (`Zone -5` through `Zone 5`) set the datum to the extreme face of the specified structural zone within the element. If the specified zone does not exist in the element, the reference falls back to Zone 0 or the element outline. |

### Display Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Alignment** | Dropdown (PropString) | `Horizontal Local` | Controls the direction and placement mode of the dimension annotations. `Horizontal Local` -- dimensions are placed to the left or right of each point, measuring distance along the vertical (Y) axis. `Horizontal Global` -- all dimension lines are projected onto a single horizontal axis at the placement point. `Vertical Local` -- dimensions are placed above or below each point, measuring along the horizontal (X) axis. `Vertical Global` -- all lines are projected onto a single vertical axis. Global modes group all callouts into one aligned column or row; local modes place each callout close to its own dimension point. |
| **Text Height** | Number (PropDouble) | `0` (by dimstyle) | Overrides the text height for all dimension annotations drawn by this instance. A value of `0` inherits height from the selected dimension style. When a viewport scale is active, the effective height is adjusted automatically to match the scale. |
| **Dimstyle** | Dropdown (PropString) | *(drawing default)* | Selects the AutoCAD dimension style used for all annotations. Controls text font, arrowhead type, extension line behavior, and other formatting aspects as defined in the chosen dimstyle. |

---

## Right-Click Menu Options

When you right-click a placed `hsbViewCoordinateDimension` instance, the following context commands appear:

### Add/Remove Format

Launches an interactive command-line session listing all available object variable names (properties) for the entities currently found in the linked view. Each variable is shown with a `(+)` indicator if it is not yet part of the Format string, or `(-)` if it is already included. Enter the index number of a variable to toggle it on or off in the Format property. Enter `0` to exit the session.

This is the recommended workflow for building Format expressions without manually typing `@(...)` tokens. For example, entering the index for `ScriptName` appends `@(ScriptName)` to the Format field, and the annotations immediately update on the next recalculation.

The command also lists a sample value for each property based on actual entities in the current view, making it easy to verify what information is available before adding it.

### Add Viewport

This context command appears only when the instance currently has no linked viewport, ShopDraw view, or section. Selecting it prompts you to pick a viewport in the drawing (`Select a viewport`). After selection the instance links to the chosen viewport and recalculates.

This command is also triggered by a double-click on the instance when it is in the unlinked state.

### Export Default Settings

Visible only when no external XML settings file was found and the script is operating on built-in default settings. Selecting it writes the current default filter rule configuration to `<CompanyPath>\TSL\Settings\hsbViewCoordinateDimension.xml`. This file can then be edited to define custom rules and reloaded via `hsbTslSettingsIO`.

---

## Available Format Tokens

The following `@(VariableName)` tokens can be used inside the Format property. Availability depends on the entity types present in the current view.

### Standard Object Variables

Any property returned by `formatObjectVariables()` for a given entity type is available as a token. These typically include hsbCAD properties such as material, profile, posnum, layer, and any attached property sets.

### Custom Variables

| Token | Applies To | Description |
|-------|-----------|-------------|
| `@(Calculate Weight)` | All entities | Calculates the physical weight of the entity via the `hsbCenterOfGravity` MapIO call. Displayed in kilograms with appropriate decimal precision (two decimals below 10 kg, zero decimals at 10 kg and above). |
| `@(Posnum)` | TslInst | The position number assigned to the TSL instance. |
| `@(Surface Quality)` | Beam | The texture/surface quality property of a beam entity. |
| `@(GrainDirection)` | Sip | Grain direction of a Structural Insulated Panel. |
| `@(GrainDirectionText)` | Sip | Human-readable grain direction text (e.g., Lengthwise, Crosswise). |
| `@(GrainDirectionTextShort)` | Sip | Abbreviated grain direction text. |
| `@(SurfaceQuality)` | Sip | Combined surface quality of top and bottom faces. |
| `@(SurfaceQualityTop)` | Sip | Surface quality of the top face. |
| `@(SurfaceQualityBottom)` | Sip | Surface quality of the bottom face. |
| `@(SipComponent.Name)` | Sip | Name of the first SIP component. |
| `@(SipComponent.Material)` | Sip | Material of the first SIP component. |
| `@(Definition)` | MetalPartCollectionEnt | Definition string of a metal part collection entity. |

---

## Filter Rules and XML Settings

### Rule Structure

Each filter rule in the settings XML specifies one or more `Format`/`Value`/`Operation` combinations:

- **Format**: An `@(VariableName)` expression used to evaluate the entity (e.g., `@(ScriptName)`).
- **Value**: The string value to match against. Multiple values can be specified using a `Value[]` list.
- **Operation**: `0` = exclude matching entities; `1` = include only matching entities.

When a rule is active, the tool iterates over all collected entities and evaluates each format condition. If an exclude operation matches, the entity is removed. If an include operation does not match, the entity is also removed. Multiple format conditions within one rule are evaluated in sequence; the first matching condition determines the result.

### Default Rule

When no XML settings file exists, the script creates a built-in default rule named "Sherpa" that excludes all TSL instances whose `ScriptName` equals "Sherpa". This prevents Sherpa connector annotations from appearing in coordinate dimension output, as Sherpa connectors typically have their own dedicated annotation script.

### XML File Format

The settings file follows the standard `Hsb_Map` XML format:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <lst nm="FilterRule[]">
    <lst nm="FilterRule">
      <str nm="Name" vl="Sherpa"/>
      <lst nm="Format[]">
        <lst nm="Format">
          <str nm="Format" vl="@(ScriptName)"/>
          <str nm="Value" vl="Sherpa"/>
          <int nm="Operation" vl="0"/>
        </lst>
      </lst>
    </lst>
  </lst>
</Hsb_Map>
```

### Managing Settings

- **Location**: `<CompanyPath>\TSL\Settings\hsbViewCoordinateDimension.xml`. If not found there, the script also searches `<InstallPath>\Content\General\TSL\Settings\`.
- **Import/Export**: Use the `hsbTslSettingsIO` tool to import or export the settings file. The settings are cached as a MapObject in the drawing dictionary for performance; changes to the XML file require reimporting.
- **Export Default Settings**: If no XML file exists, use the right-click "Export Default Settings" command to create the initial file with the built-in default rule.

---

## Tips and Notes

**Global vs. Local Alignment**: Use Global alignment for formal shop drawing annotation where a clean stacked column of coordinate values is required along one side of the element. Use Local alignment when points are spread over a large distance and you want each callout positioned directly beside its source point without a projected line.

**Reference Zone Selection**: Choosing the correct Reference zone is important when the element's geometric origin is not at the face from which you measure. For instance, when dimensioning hardware on the exterior face of a wall element, set the Reference to the zone corresponding to that face so that all coordinate values reflect the distance from that face rather than from an internal datum. The script validates the specified zone against the actual element zones; if the selected zone has no height (does not exist), it falls back to Zone 0.

**Snapping Non-Solid TSL Instances to the Reference Zone**: For TSL instances that do not generate a solid body, the tool automatically projects their dimension point onto the nearest edge of the reference zone outline when the raw origin falls outside the visible element outline. This prevents callout leaders from appearing at positions that extend beyond the element boundary in the drawing. This feature was added in version 1.4.

**Protection Range**: The script publishes a protection zone map entry (`ViewProtect`) describing the bounding regions of all drawn callouts as a `PlaneProfile`. Other TSL-based annotation tools in hsbCAD can read this zone to avoid placing their own text in already-occupied areas, reducing label overlap.

**Setup Display**: When the linked viewport exists but no dimensionable TSL entities are found inside it (for example, during a block setup phase before a live element is assigned), the tool draws a setup text label at the placement point showing the script name, active zone index, and current alignment setting. This confirms the tool is correctly placed and configured even before real content is visible. If the tool is in Global alignment mode and the placement point does not intersect the viewport boundary, a red warning message is displayed prompting you to adjust the location.

**Multiple Sections in Model Space**: When inserting from Model Space and selecting multiple Section2d entities in a single operation, the tool creates one `hsbViewCoordinateDimension` instance for each selected section. Each instance is independently linked to its own ClipVolume and maintains its own properties. The temporary insertion instance is erased after creating the per-section instances.

**Coordinate Value Format**: The numeric coordinate value is formatted to zero decimal places in the current drawing units. The `@(...)` format appendix follows immediately after the number. Use the `\P` sequence inside the Format string to split the appendix across multiple lines within a single callout bubble.

**Execution Sequence**: The script sets its sequence number to 500 via `setSequenceNumber(500)`, ensuring it runs after most other TSL tools have completed their geometry generation. This guarantees that all TSL instance origins and published dimension points are available at the time of annotation.

**Catalog Entries**: When inserting with an execute key, the script attempts to match it against saved catalog entry names. If a match is found, properties are loaded from that catalog entry, bypassing the dialog. If no match is found, the last-inserted configuration is applied instead. This enables quick batch insertion of preconfigured dimension setups.

**Multiline Format Expressions**: When the Format property contains `\P` sequences, the annotation text is split into multiple lines. Each line segment is resolved independently for `@(...)` tokens, allowing different variable expressions on different lines of the same callout.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.5 | 20 Oct 2020 | Internal naming bugfix (HSB-9338). |
| 1.4 | 11 Oct 2019 | Enhanced to snap dimension points to the reference zone outline for non-solid TSL instances. Default filter rule definition deployed (HSB-5749). |
| 1.3 | 23 Sep 2019 | Reference property added to specify the reference zone for measurement datum (HSB-5455). |
| 1.2 | 11 Jul 2019 | Invalid range filtered on section views. |
| 1.1 | 05 Jul 2019 | Protection range published. Setup display enhanced. |
| 1.0 | 04 Jul 2019 | Initial release. |
