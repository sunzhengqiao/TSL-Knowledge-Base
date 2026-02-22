# hsbCLT-Lifter

Automated lifting device placement tool for CLT (Cross-Laminated Timber) panels. This script calculates optimal positions for various lifting hardware types based on panel weight, dimensions, and association type (wall or roof/floor).

---

## Overview

The hsbCLT-Lifter tool automates the placement of lifting devices on CLT panels for transportation and erection. It supports multiple lifting device families from various manufacturers and automatically:

- Calculates the required number of devices based on panel weight and device load capacity
- Determines optimal placement positions considering edge offsets, panel geometry, and contact surfaces
- Creates the necessary drill holes, pockets, or other tooling for CNC fabrication
- Generates hardware component data for material lists and shop drawings
- Detects panel association (wall vs. roof/floor) and adapts placement logic accordingly
- Supports multi-directional lifting configurations for complex erection sequences

The script intelligently adapts to panel orientation (wall vs. roof/floor) and adjusts device placement, quantity defaults, and drill configurations accordingly.

---

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | Object (O-Type) |
| Environment | Model Space |
| Version | 8.6 |
| Required Beams | 0 (works with SIP/CLT panels) |
| Keywords | lifting device, CLT, strap, Wuerth, Steel anchor, Rampa |

---

## Prerequisites

Before using this tool:

1. **CLT panels must exist** -- The script works with SIP (Structural Insulated Panel) or CLT panel entities in the drawing.
2. **Panels should be part of Elements** -- For best automatic association detection, panels should belong to Wall, Roof, or Floor elements.
3. **Settings file (optional)** -- Custom lifting device catalogs can be configured via an XML settings file at the company or installation path.
4. **hsbCenterOfGravity** -- This script is called internally to calculate panel weight for automatic type and quantity selection.

---

## Step-by-Step Usage Guide

### Basic Insertion

1. **Launch the command** from the hsbCAD ribbon or command line.
2. **Choose lifting device family** in the properties dialog. Available families include:
   - Lifting Strap (loop-type devices)
   - Rampa (threaded insert system)
   - Wuerth (pocket-type system)
   - Steel Anchor (bolt with edge drill)
   - Schmid Schrauben (Rapid T-Lift system)
   - Pitzl (powerclamp system)
3. **Select device type** -- The script shows available types filtered by panel thickness and load capacity. Choose "Automatic" to let the script select based on panel weight.
4. **Configure parameters** -- Set quantity, edge offset, distribution offset, and other properties as needed. Values of 0 use catalog defaults.
5. **Confirm placement** -- Click OK to accept the property dialog.
6. **Select CLT panels or elements** -- You can select:
   - Individual CLT/SIP panels
   - Complete Wall, Roof, or Floor elements (all contained panels will be processed)
7. The script creates one lifting device instance per panel. Panels that already have a lifting device attached are automatically excluded from multi-panel selections.

### First-Time Usage

When the command is called for the first time (no default catalog entry exists), the script displays an informational notice explaining that it will save the current property settings as a default catalog entry for future use. These defaults can be changed at any time through the property dialog.

### Single Panel with Multiple Directions

When selecting a single panel that already has lifting devices attached:

1. The script displays existing lifting directions as colored arrows on the panel.
2. **Select a new lifting direction** by clicking a point that indicates the desired direction relative to the panel center.
3. If the selected direction does not duplicate an existing one, a new lifting device is added for that direction.
4. If the direction already exists, the script reports a message and cancels the operation.

### Ribbon/Command Line Insertion

The script supports parameterized insertion via the execute key using the syntax:

- `FamilyName?CatalogEntry` -- Inserts with a specific family and catalog entry
- `Single` -- Inserts in single-device mode

This allows ribbon buttons or LISP routines to call the script with preset family selections.

### Edit Existing Devices

1. **Select the lifting device** in the drawing.
2. Modify parameters in the **Properties Palette** (OPM).
3. **Right-click** to access context menu options for advanced operations.
4. **Double-click** to flip the device to the opposite panel face.
5. Use **Edit in Place** to convert automatic device distribution to individual devices for manual repositioning.

---

## Properties Panel Parameters

### Alignment Category

| Parameter | Description | Default |
|-----------|-------------|---------|
| **Quantity** | Number of lifting devices per lifting direction. Set to 0 for automatic calculation based on panel weight and device load capacity. For walls, the default automatic logic uses 1 device for panels under 2000 mm wide, and 2 for wider panels. For roof/floor, up to 4 devices may be placed automatically. | 0 (Automatic) |
| **Edge Offset** | Distance from the panel edge to the device center. Set to 0 to use the catalog default for the selected device type. This property becomes read-only for wall associations with Rampa or Wuerth families. | 0 (Automatic) |
| **Distribution Offset** | Controls spacing when multiple devices are needed. Enter a fraction relative to the panel dimension (e.g., "1/3" for one-third spacing), or a specific distance value. Set to 0 for automatic even distribution. When a corner-rule child type is selected, this property is set to "Not Applicable" and becomes read-only. | 1/3 |

### Model Category

| Parameter | Description | Default |
|-----------|-------------|---------|
| **Association** | Panel type classification affecting device orientation and placement logic. Options: Automatic, Wall, Roof/Floor. In Automatic mode, the script detects the association from the element type, panel orientation relative to the world coordinate system, or extended panel properties. The detected association is shown in the property description. | Automatic |
| **Type** | Specific lifting device model from the selected family. Set to "Automatic" for weight-based selection. The list is filtered by panel thickness (MinThickness/MaxThickness) and association type. Types are ordered by load capacity. | Automatic |

### Tooling Category

| Parameter | Description | Default |
|-----------|-------------|---------|
| **Diameter** | Override the default drill or tool diameter. Set to 0 to use catalog defaults. | 0 (Automatic) |
| **Depth** | Override the default drill or tool depth. Set to 0 to use catalog defaults. If the catalog depth is 0, the full panel thickness is used. | 0 (Automatic) |
| **Interdistance** | For Lifting Strap family on roof/floor panels: spacing between double drill holes. Only editable when the association is Roof/Floor and the family is Lifting Strap. Set to 0 to use catalog defaults. | 0 (Automatic) |
| **Width** | For Wuerth family with pocket tools: override the pocket width. Only visible for Wuerth/Schmid type families. | 0 (Automatic) |

### Edge Drill Category (Steel Anchor family only)

These properties only appear when the Steel Anchor family is selected:

| Parameter | Description | Default |
|-----------|-------------|---------|
| **Depth** (Edge) | Depth of the horizontal edge drill for bolt insertion. Set to 0 to use catalog defaults. | 0 (From catalog) |
| **Diameter** (Edge) | Diameter of the edge drill hole. Set to 0 to use catalog defaults. | 0 (From catalog) |
| **Z-Offset** | Vertical offset of edge drill from panel face. Negative values measure from the main drill depth. Set to 0 to use catalog defaults. | 0 (From catalog) |

---

## Right-Click Menu Options

### Device Manipulation

| Command | Description |
|---------|-------------|
| **Flip Side** | Switches the device to the opposite panel face. Also triggered by double-clicking the device. The default face is determined by surface quality settings (higher quality face) for walls, or the top face for roof/floor panels. |
| **Set lifting direction** | Replaces all existing lifting directions with a single new direction. Prompts the user to click a point indicating the desired direction. A jig preview shows existing directions (in red) and the proposed new direction (in blue). |
| **Add lifting direction** | Adds an additional lifting direction without removing existing ones, enabling multi-point lifting configurations. Only available when the device is not in corner-rule mode. |
| **Edit in Place** | Converts automatic device distribution into individual device instances. Each device becomes independently movable and editable. This is useful for fine-tuning positions on irregularly shaped panels. Only available in collection mode (not on individual devices). |

### Family Switching

| Command | Description |
|---------|-------------|
| **-> [Family Name]** | Switches to a different lifting device family while preserving the current placement point, quantity, offsets, and association. The menu lists all configured families except the currently active one. If the new family does not support the current association, the script resets to the previous family. |

### Tooling Control

| Command | Description |
|---------|-------------|
| **No CNC tooling** / **Add CNC tooling** | Toggle whether drill holes and cuts are applied to the panel for CNC fabrication. When CNC tooling is suppressed, the device is still visualized and counted in hardware lists, but no physical modifications are applied to the panel geometry. The hardware notes field receives a "No CNC" annotation. |
| **Add Marking Drill** / **Remove Marking Drill** | For Lifting Strap on Roof/Floor panels only: adds or removes an orientation marking drill. The marking drill is a shallow hole used to indicate device orientation during assembly. |
| **Set Marking Depth/Alignment** | Configure the marking drill depth. Negative values flip the marking drill to the opposite panel side. Enter 0 to remove the marking drill entirely. Only visible when a marking drill is active. |
| **Add loose lifting device** / **Remove loose lifting device** | For Lifting Strap devices that overlap with a panel opening: marks the device as "loose" (not physically attached through the opening). The article number receives an "L" prefix to indicate manual handling is required during erection. This toggle only appears when the device position intersects with an opening area. |

### Shop Drawing Options

| Command | Description |
|---------|-------------|
| **Show Dimension in Shopdrawing** / **Hide Dimension in Shopdrawing** | Toggle dimension display for this lifting device in shop drawings. When enabled, the script generates dimension request data that sd_drillPattern uses for shop drawing layout. Dimension lines are constrained to the edge vectors of the device placement. |

### Settings Management

| Command | Description |
|---------|-------------|
| **Tool Description Settings** | Opens a dialog to configure the format string for tool descriptions in CNC export. Supports format expressions such as `@(Type)` to resolve TSL properties. Also allows setting the MapX key name and entry name for exporter definitions. |
| **Configure Secondary Lifting Device** | Set up automatic creation of a secondary lifting device when this device is placed. The secondary device uses the opposite association (wall devices get a roof/floor secondary, and vice versa). The dialog lists available families filtered to support the opposite association type. Select "None" to disable. |
| **Import Settings** | Reload the device catalog settings from the XML configuration file. This overwrites the in-memory settings with the file contents. Only available when a settings file exists on disk. |
| **Export Settings** | Save the current in-memory settings to the XML configuration file. If a file already exists, the script asks for confirmation before overwriting. The script creates the Settings folder if it does not exist. |

---

## Automatic Association Detection

When the Association property is set to "Automatic," the script determines the panel type using the following priority:

1. **Extended Properties** -- Checks the panel's `ExtendedProperties` sub-map for an `IsFloor` flag (set by other CLT tools).
2. **Attached Property Sets** -- Searches attached property sets for an "Association" key with values "Wall" or "Roof/Floor."
3. **Element Type** -- If the panel belongs to an `ElementWall`, association is set to Wall.
4. **Panel Orientation** -- Panels with their Z-axis perpendicular to the world Z-axis are classified as Wall. Panels with a beveled orientation (not perpendicular to both world Z and X) are classified as Roof/Floor.
5. **Elevation** -- Horizontal panels above world origin elevation are classified as Roof/Floor.
6. **Default** -- If none of the above conditions match, the default is Wall.

---

## Automatic Type and Quantity Selection

When the Type property is set to "Automatic," the script:

1. Calculates the panel weight using `hsbCenterOfGravity`.
2. Iterates through available device types (ordered by ascending load capacity).
3. For each type, checks whether the combined load capacity of the default number of devices exceeds the panel weight.
4. Also verifies that the panel thickness falls within the type's MinThickness and MaxThickness range.
5. If no single type can carry the load, the script increases the device count and retries.

Default device counts:
- **Wall panels under 2000 mm wide**: 1 device
- **Wall panels 2000 mm or wider**: 2 devices
- **Roof/Floor panels (Rampa, over 8000 mm, thickness under 80 mm)**: 3 devices
- **Roof/Floor panels (other)**: 4 devices

---

## Device Placement Logic

### Wall Association

- Devices are distributed along the horizontal extent of the panel.
- The default lifting direction is upward (world Z direction).
- Edge offset is measured from the panel shadow contour, considering the contact surfaces of both reference and opposite sides for accurate clearance.
- For Rampa and Wuerth families, devices align with gable edges and beveled surfaces.
- The reference face is determined by surface quality: the higher-quality face is preferred.

### Roof/Floor Association

- Devices are distributed in a grid pattern across the panel surface.
- For even numbers of devices, they are arranged in rows. For odd numbers, a triangular distribution is used.
- The default lifting direction is perpendicular to the panel face (upward in world coordinates).
- Lifting Strap devices use double drills with configurable interdistance and optional angle rotation.

### Corner Rule (Child Rule 1)

When a device type has `ChildRule=1` in the settings, devices are placed at the upper corners of wall panels. This is used for Steel Anchor devices that require placement at extreme boundary positions. The distribution offset property becomes inactive in this mode.

---

## Settings Files

### File Location

The script looks for settings in this order:
1. **Company folder**: `[hsbCompany]\TSL\Settings\hsbCLT-Lifter.xml`
2. **Installation folder**: `[hsbInstall]\Content\General\TSL\Settings\hsbCLT-Lifter.xml`

Settings are cached in memory as a `MapObject` with dictionary key `"hsbTSL"` and entry name `"hsbCLT-Lifter"` for performance. Changes made through the dialog or import/export commands update both the in-memory cache and the file.

### Settings Structure

The XML file defines lifting device families with their properties:

```xml
<Hsb_Map>
  <lst nm="Family[]">
    <lst nm="Family">
      <str nm="Name" vl="|Lifting Strap|"/>
      <int nm="Rule" vl="0"/>
      <int nm="HideDescriptionShopdraw" vl="0"/>
      <dbl nm="MaxRange" ut="L" vl="0"/>
      <dbl nm="minHorizontalOffset" ut="L" vl="0"/>
      <str nm="secondaryFamily" vl=""/>
      <lst nm="Text">
        <dbl nm="Rotation" vl="0"/>
        <dbl nm="XFlag" vl="1"/>
        <dbl nm="YFlag" vl="0"/>
      </lst>
      <lst nm="Child[]">
        <lst nm="Child">
          <str nm="Name" vl="SW-1000"/>
          <dbl nm="EdgeOffset" ut="L" vl="104"/>
          <dbl nm="Diameter" ut="L" vl="30"/>
          <dbl nm="Depth" ut="L" vl="0"/>
          <dbl nm="Interdistance" ut="L" vl="92"/>
          <dbl nm="InterdistanceAngle" vl="0"/>
          <dbl nm="MaxLoad" ut="N" vl="1000"/>
          <dbl nm="MinThickness" ut="L" vl="60"/>
          <dbl nm="MaxThickness" ut="L" vl="200"/>
          <int nm="Association" vl="1"/>
          <int nm="Color" vl="0"/>
          <int nm="ChildRule" vl="0"/>
        </lst>
      </lst>
    </lst>
  </lst>
  <lst nm="General">
    <dbl nm="TextHeight" ut="L" vl="0"/>
    <str nm="DimStyle" vl=""/>
    <dbl nm="MaxRange" ut="L" vl="0"/>
    <int nm="RequestShopdraw" vl="0"/>
  </lst>
  <lst nm="ToolDescriptionFormat">
    <str nm="Format" vl="@(Type)"/>
    <str nm="MapName" vl="TimberTec"/>
    <str nm="KeyName" vl="LiftingDevice"/>
  </lst>
</Hsb_Map>
```

### Key Configuration Properties

#### Family Level

| Property | Description |
|----------|-------------|
| **Name** | Display name of the family. Names enclosed in pipe characters (e.g., `\|Lifting Strap\|`) are translated via the internationalization system. |
| **Rule** | Family behavior type: 0 = Lifting Strap, 1 = Rampa/Pitzl, 2 = Wuerth/Schmid, 3 = Steel Anchor |
| **HideDescriptionShopdraw** | If set to 1, suppresses the device description text in shop drawing output. |
| **MaxRange** | Maximum allowed spacing between devices. Overrides the calculated distribution distance if exceeded. Can be set at General, Family, or Child level (cascading). |
| **minHorizontalOffset** | Minimum horizontal offset subtracted from the panel extent when calculating device distribution. |
| **secondaryFamily** | Name of a family to automatically create as a secondary lifting device with the opposite association. |
| **Text** | Sub-node controlling text display: Rotation (angle), XFlag and YFlag (alignment multipliers). |

#### Child Level

| Property | Description |
|----------|-------------|
| **Name** | Device type name and article identifier |
| **MaxLoad** | Maximum load capacity in kg (used for automatic type selection and validation) |
| **MinThickness** | Minimum panel thickness in mm for device applicability. Devices are excluded from selection if the panel is thinner. |
| **MaxThickness** | Maximum panel thickness in mm for device applicability. Devices are excluded from selection if the panel is thicker. |
| **Association** | 0 = Both wall and roof/floor, 1 = Wall only, 2 = Roof/Floor only |
| **EdgeOffset** | Default distance from panel edge to device center |
| **Diameter** | Drill or tool diameter |
| **Depth** | Drill or tool depth (0 = full panel thickness) |
| **Interdistance** | Double-drill spacing (Lifting Strap family) |
| **InterdistanceAngle** | Rotation angle for angled double drills |
| **Color** | Display color index for the device visualization |
| **ChildRule** | 0 = Standard distribution, 1 = Corner placement (Steel Anchor at panel corners) |

#### Steel Anchor Additional Properties

| Property | Description |
|----------|-------------|
| **DiameterEdge** | Edge drill diameter |
| **DepthEdge** | Edge drill depth |
| **ZOffsetEdge** | Vertical offset of edge drill from panel face |
| **ZOffsetRabbetEdge** | Additional offset when device is near a rabbet or lap joint to avoid oscillation issues |

#### Hardware Output Properties

Each child can define a `Hardware[]` sub-node to customize BOM output:

| Property | Description |
|----------|-------------|
| **articleNumber** | Custom article number (defaults to the child Name) |
| **category** | Hardware category (defaults to "LiftingDevice") |
| **material** | Material description |
| **description** | Human-readable description |
| **manufacturer** | Manufacturer name |
| **model** | Model designation |
| **notes** | Additional notes |
| **scaleX/Y/Z** | Scale factors for hardware component representation |
| **quantity** | Override quantity per device (defaults to total device count) |

#### General Section

| Property | Description |
|----------|-------------|
| **TextHeight** | Override text height for device labels |
| **DimStyle** | Dimension style name for shop drawing dimensions |
| **MaxRange** | Global maximum device spacing |
| **RequestShopdraw** | Default shop drawing dimension request state (0 = off, 1 = on) |

#### Tool Description Format Section

| Property | Description |
|----------|-------------|
| **Format** | Format expression for CNC tool descriptions, e.g., `@(Type)` resolves to the device type name |
| **MapName** | MapX key name for exporter integration (default: "TimberTec") |
| **KeyName** | Entry name within the MapX for exporter integration (default: "LiftingDevice") |

---

## Supported Lifting Device Families

### Lifting Strap (Rule 0)

- Loop-type devices inserted through drilled holes in the panel face.
- For wall associations: single drill per device, distributed along the panel width.
- For roof/floor associations: double-drill configuration with configurable interdistance. An optional `InterdistanceAngle` rotates the drill pair.
- Supports an optional marking drill for orientation indication during assembly.
- Detects when device position overlaps with panel openings and offers the "loose device" toggle.
- Strap length for walls is calculated from the panel real body shadow to account for non-rectangular geometries.
- Default types: H1 (800 kg), H1.1 (2000 kg), H2 (1600 kg), H2.1 (4000 kg).

### Rampa (Rule 1)

- Threaded insert system using a single drill hole per device.
- For wall associations: aligns with the closest panel edge, adapting to gable and beveled geometries. The drill direction follows the edge normal.
- For roof/floor associations: standard perpendicular drilling from the device face.
- Default types: M10 (200 kg), M12 (310 kg), M16 (680 kg), M20 (1340 kg).

### Pitzl (Rule 1)

- Powerclamp system (Pitzl PC D40-90).
- Uses the same rule type as Rampa (single drill).
- Default parameters: 40 mm diameter, 93 mm depth, 1500 kg max load, 60 mm minimum panel thickness.
- Displays a 3D device model visualization in the drawing.
- Automatically included in the family list even when not defined in the settings file.

### Wuerth / Schmid Schrauben (Rule 2)

- Pocket-type systems using rectangular beam cuts or large-diameter drills.
- For wall associations: pocket orientation adapts to gable walls with beveled edges. The cut direction aligns with the closest panel edge.
- Supports both circular drill shapes and rectangular pocket shapes (using BeamCut tools).
- A Width property override controls the pocket dimension when using beam cut shapes.
- Schmid Schrauben Rapid T-Lift 12 and 16 are included as default types.

### Steel Anchor (Rule 3)

- Bolt system requiring two perpendicular drill operations per device: a main face drill and a horizontal edge drill.
- For wall associations with ChildRule 1: devices are placed at upper panel corners with edge drills directed into the panel from the top edge.
- For standard wall placement: edge drills are directed from the nearest panel edge.
- Automatically detects tongue-and-groove and rabbet/lap joint connections and extends or repositions the edge drill to avoid joint interference.
- The `ZOffsetRabbetEdge` parameter provides additional edge drill offset near rabbet edges to prevent oscillation issues.
- Connected TSL tools (tongue-groove, lap joint) are detected via their Map data to determine male/female joint locations.

---

## Hardware Output

The script generates hardware components (HardWrComp) for each lifting device instance:

- **Article Number**: Derived from the child type name. Prefixed with "L" for loose devices.
- **Category**: "LiftingDevice"
- **Description**: Family name. Prefixed with "Loose" for loose devices.
- **Group**: Inherited from the parent element group.
- **Linked Entity**: The CLT panel (SIP).
- **Representation Type**: TSL (distinguishes script-generated hardware from user-defined components).
- **Quantity**: Total number of devices across all lifting directions.

Custom hardware output can be defined per child type using the `Hardware[]` sub-node in the settings XML, allowing multiple hardware components per device (e.g., bolt, washer, nut).

---

## DataLink Integration

The script registers itself as a DataLink reference on the parent panel. Only the first sibling instance (when multiple lifting devices are attached to the same panel) stores the DataLink reference. This allows other scripts and panel export functionality to access lifting device properties through the DataLink mechanism.

---

## Tips and Best Practices

1. **Use Automatic mode first** -- Let the script calculate device count and type based on panel weight, then adjust if needed. The automatic detection considers panel thickness ranges defined in the settings.

2. **Check thickness compatibility** -- Devices with `MinThickness` or `MaxThickness` restrictions are automatically filtered from the type list. If no compatible types exist for your panel thickness, the script falls back to the unfiltered list.

3. **Configure secondary devices** -- Use "Configure Secondary Lifting Device" to automatically add roof/floor lifting points when placing wall devices (or vice versa). The secondary device is created once when the primary device is first attached.

4. **Save catalog entries** -- After configuring properties for a specific project, save them as catalog entries in the OPM for quick reuse. The script automatically saves a "Last Inserted" entry for convenience.

5. **Review before fabrication** -- Use "No CNC tooling" temporarily when checking placement, then enable tooling for final CNC output. The "No CNC" note is added to hardware output for traceability.

6. **Edge offset considerations** -- For panels with rabbets or lap joints, the script automatically adjusts Steel Anchor edge drill positions. The `ZOffsetRabbetEdge` setting provides additional control to avoid joint interference.

7. **Opening detection** -- For Lifting Strap devices, the script detects when a device position overlaps with a panel opening. Mark it as "loose" to indicate manual handling during erection.

8. **Multi-direction lifting** -- Use "Add lifting direction" to create lifting devices for different erection phases. Each direction gets its own set of devices with independent placement logic.

9. **Edit in Place** -- Convert automatic distributions to individual devices for precise manual adjustment on irregular panel shapes. Individual devices can be repositioned by dragging, and their edge offset updates automatically based on distance from the panel boundary.

10. **Tool description format** -- Configure the tool description format to match your CNC export requirements. The format expression `@(Type)` resolves to the device type name, and custom prefixes or suffixes can be added.

---

## Frequently Asked Questions

### Q: Why does the script show an error on small panels?

A: The script requires minimum panel dimensions to place lifting devices safely. If a panel is too small for the configured edge offsets, the script uses a fallback placement at the panel center and displays an alert (colored ring around the device). Try reducing the edge offset or using a device family with a smaller edge offset requirement.

### Q: How do I change the lifting device for an existing panel?

A: Select the lifting device instance, right-click, and choose "-> [Family Name]" from the context menu to switch to a different family. The placement point, quantity, and offset settings are preserved. If the new family does not support the current association, the script automatically reverts to the previous family.

### Q: Why are some device types not shown in the list?

A: Device types are filtered based on:
- **Panel thickness**: Types with `MinThickness` or `MaxThickness` restrictions that do not match the panel are hidden.
- **Association type**: Types configured for Wall only do not appear on Roof/Floor panels, and vice versa. Types with Association = 0 appear for both.
- **Load capacity**: Types are sorted by ascending load capacity in the selection list.

### Q: How do I add custom lifting devices?

A: Use "Export Settings" to save the current configuration to XML. Edit the file to add new families or child entries following the XML structure. Then use "Import Settings" to reload. New families should specify a unique Name, appropriate Rule type (0-3), and at least one Child entry with Name, Diameter, Depth, MaxLoad, EdgeOffset, and Association values.

### Q: What happens when a lifting device is placed over an opening?

A: For Lifting Strap devices (Rule 0), the script enlarges the opening contour by the drill diameter and checks for intersection. If the device overlaps an opening, the "Add loose lifting device" context command becomes available. When marked as loose, the article number is prefixed with "L" and the hardware description includes "Loose" to flag manual handling during erection.

### Q: How do I control dimensions in shop drawings?

A: Use the "Show Dimension in Shopdrawing" or "Hide Dimension in Shopdrawing" right-click command. When enabled, the script creates dimension request data consumed by sd_drillPattern for shop drawing layout. Dimensions are constrained to the edge direction vectors of each device.

### Q: Can I have different lifting systems on the same panel?

A: Yes, there are two approaches:
- **Add lifting direction**: Creates additional lifting points for different erection phases using the same family.
- **Configure Secondary Lifting Device**: Automatically creates a device from a different family with the opposite association when the primary device is placed.

### Q: How does the "Edit in Place" feature work?

A: When activated, the script creates individual device instances (mode 1) for each calculated position and removes the original collection instance (mode 0). Individual devices have their quantity locked to 1 and their distribution offset disabled. They can be repositioned by moving their insertion point, and the edge offset automatically recalculates based on the distance from the panel boundary.

### Q: Why does the association keep changing?

A: When set to "Automatic," the script re-evaluates the association each time it recalculates. If the panel element type or orientation changes, the detected association may change. To lock a specific association, set the property explicitly to "Wall" or "Roof/Floor" instead of "Automatic."

---

## Related Scripts

- **hsbCenterOfGravity** -- Calculates panel weight (called internally for automatic type and quantity selection)
- **sd_drillPattern** -- Shop drawing dimension patterns for drill operations (consumes dimension request data from this script)
- **hsbCLT-Drill** -- General-purpose drilling for CLT panels
- **hsbGrainDirection** -- Provides optional marking drill parameters
- **hsbCLT-TongueGroove** / **hsbCLT-LapJoint** -- Connection tools detected by Steel Anchor rule for edge drill repositioning
