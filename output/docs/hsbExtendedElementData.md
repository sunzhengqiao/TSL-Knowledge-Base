# hsbExtendedElementData

## Overview

**hsbExtendedElementData** is a comprehensive element analysis and data management tool that serves as the bridge between 3D modeling and production data workflows in hsbCAD. The script calculates, validates, and exports critical geometric quantities for timber construction elements (walls, floors, roofs), enabling accurate material estimation, production planning, and BIM data exchange.

Unlike simple measurement tools, this script provides **parametric calculation logic** with multiple measurement methods, **automatic insulation volume estimation**, and **multi-channel data export** to AutoCAD Property Sets, Excel schedules, and visual on-screen displays. It ensures that element quantities automatically update whenever design changes occur, maintaining data accuracy throughout the project lifecycle.

### Primary Functions

1. **Geometric Analysis Engine**
   - Calculates maximum dimensions (length, height, width) with configurable measurement methods
   - Computes gross and net area, accounting for openings with adjustable thresholds
   - Estimates insulation cavity volume based on structural frame shadow projection
   - Handles complex geometries, multi-zone elements, and non-rectangular profiles

2. **Data Export Hub**
   - Writes calculated values to AutoCAD Property Set Definitions for schedule integration
   - Exports all fields via DXA interface for Excel and external database consumption
   - Provides optional visual data table display aligned to WCS or element coordinates
   - Supports batch element processing with duplicate detection

3. **Production Intelligence**
   - Distinguishes between structural frame (Zone 0) and complete assembly dimensions
   - Filters insignificant openings from net area calculations to match production realities
   - Provides element definition text for production documentation
   - Supports unit conversion for international project workflows (metric and imperial)

### Use Cases

| Scenario | Configuration | Output Used |
|----------|--------------|-------------|
| Material Estimation | Dimension source: Zone 0, Show table: No | Property Set values for schedule tables |
| Transport Planning | Dimension source: entire Element | Length/Width/Height for logistics |
| Insulation Ordering | Net Area threshold: 10000 mm² | Volume field for insulation quantity takeoff |
| BIM Data Export | Property Set Name: IFC_QuantitySet | Property Set values exported to IFC |
| Quality Assurance | Show table: ECS, Color: 1 (Red) | Visual on-screen table for element verification |
| Excel Reporting | All default settings | DXA export fields for custom reports |

---

## Script Classification

| Attribute | Value |
|-----------|-------|
| **Category** | Base/Function |
| **Module** | Element Data & Analysis |
| **Script Type** | O-Type (Object Script) |
| **Version** | 3.0 (July 2014) |
| **Workflow Stage** | Analysis / Documentation / Export |

---

## Working Environment

### Model Space

| Aspect | Details |
|--------|---------|
| **Primary Environment** | Model Space (3D element modeling) |
| **Paper Space** | Not supported (does not generate layout views or shop drawings) |
| **Shop Drawing Mode** | Not applicable |

### Execution Context

| Attribute | Value | Notes |
|-----------|-------|-------|
| **Insertion Mode** | Implicit (`#ImplInsert 1`) | Script instance automatically created after element selection |
| **Beams Required** | 0 | Operates at element level, not on individual beams |
| **Grip Points** | 0 | No manual grip editing required |
| **DXA Output** | Enabled (`#DxaOut 1`) | Data available for Excel export |
| **Execution Loops** | 2 | Runs two calculation passes to resolve geometry dependencies |

---

## Prerequisites

### Required Elements

1. **Existing hsbCAD Element**
   - At least one Element (Wall, Floor, or Roof) must exist in the drawing
   - The script attaches to elements as persistent parametric objects
   - Elements must contain valid geometry (beams and/or sheets)

### Optional But Recommended

2. **AutoCAD Property Set Definition**

   If you plan to export calculated values to Property Sets for use in schedules or BIM workflows, create a Property Set Definition **before** inserting the script. The Property Set should contain one or more of the following properties:

   | Property Name | Type | Description |
   |--------------|------|-------------|
   | `Height` | Real Number (Double) | Element height in selected unit |
   | `Width` | Real Number (Double) | Element width/thickness in selected unit |
   | `Length` | Real Number (Double) | Element length in selected unit |
   | `Perimeter` | Real Number (Double) | Element perimeter in selected unit |
   | `AreaNet` | Real Number (Double) | Net area (gross minus openings) in unit² |
   | `AreaGros` | Real Number (Double) | Gross area in unit² |
   | `Insulation` | Real Number (Double) | Insulation volume in unit³ |

   **Critical**: All properties must be defined as **Real Number** type, not Text. Property names are case-sensitive and must match exactly.

3. **Dimension Style**

   A DimStyle should be configured if you plan to display the visual data table. The DimStyle controls text font, size, and formatting.

---

## Installation and Usage Workflow

### Step 1: Launch the Script

**Method 1 - TSL Browser:**
1. Open the hsbCAD TSL insertion interface
2. Navigate to the script library (typically under Base/Function or Element Analysis)
3. Select **hsbExtendedElementData** from the list
4. Click Insert or double-click the script name

**Method 2 - Command Line:**
1. Type the TSL insertion command (e.g., `hsbTSL` or configured command)
2. Browse and select **hsbExtendedElementData.mcr**
3. Press OK to proceed

### Step 2: Configure Initial Properties

Upon launching, a **properties dialog** appears automatically (triggered by `showDialog()` in the script). This dialog displays all adjustable parameters with their current default values.

**Key Settings to Review Before Insertion:**

| Parameter | Typical Setting | Notes |
|-----------|----------------|-------|
| **Unit** | mm (or m for larger projects) | Affects display table and Property Set values |
| **Decimals** | 1 | Controls visual precision in table display |
| **Length taken from** | Zone 0 (for structural) or entire Element (for logistics) | Choose based on intended use |
| **Height taken from** | Zone 0 (for structural) or entire Element (for logistics) | Usually matches Length setting |
| **Width taken from** | Zone 0 (for structural) or entire Element (for logistics) | Usually matches Length setting |
| **Net Area: ignore Openings** | 0 (count all) or 10000 (filter small penetrations) | Set threshold based on project standards |
| **Color** | 222 (light gray) or 1 (red for QA) | Visual indicator color |
| **Dimstyle** | Select from available DimStyles | Controls text formatting |
| **Show table** | No (for batch processing) or ECS (for visual verification) | Controls on-screen display |
| **Property Set Name** | Select target Property Set or leave blank | Required for schedule integration |

**Configuration Tips:**
- For **batch insertion on many elements**, set "Show table" to **No** to avoid visual clutter
- For **structural material estimation**, use **Zone 0** for all dimension sources
- For **transport/logistics planning**, use **entire Element** for all dimension sources
- For **mixed-use scenarios**, insert the script multiple times with different settings and different Property Sets

Click **OK** to confirm settings and proceed to element selection.

### Step 3: Select Elements

The command line prompts:

```
Select Element
```

**Selection Methods:**
- **Single Element**: Click directly on an element (wall, floor, or roof)
- **Multiple Elements**: Use a window or crossing selection to pick multiple elements at once
- **Select All**: Use standard AutoCAD selection methods (e.g., `ALL`, filtered selection sets)

The script supports **batch processing** and will iterate through all selected elements automatically.

**Duplicate Prevention:**

The script includes intelligent duplicate detection. Before attaching to each selected element, it performs a case-insensitive comparison of its script name against all existing TSL instances on that element.

**Feedback Messages:**

For each element processed, the command line displays:

```
Element 101: data successfully appended.
Element 102: has already extended data attached. no data appended.
Element 103: data successfully appended.
```

- **"data successfully appended"**: The script instance was successfully created and attached
- **"has already extended data attached"**: An instance of hsbExtendedElementData already exists on this element; insertion skipped to prevent duplicate calculations

This ensures that each element has exactly one instance of the script, preventing redundant calculations and data conflicts.

### Step 4: Verify Results

After successful insertion, the script **immediately performs all calculations** and updates display/export channels based on your configuration:

**Visual Verification (if "Show table" is enabled):**

A formatted data table appears near the element showing:
- Level (element group name)
- Code (element code)
- PosNum (element position number)
- Area net (net area in selected unit²)
- Area brut (gross area in selected unit²)
- Length (in selected unit)
- Width (in selected unit)
- Height (in selected unit)
- Insulation (volume in selected unit³)
- Information (element definition text)

**Table Placement:**
- For **Wall elements**: Anchored at the wall arrow point with a small circular marker
- For **Floor/Roof elements**: Anchored at the element origin with a short reference line

**Coordinate System Indicators:**

The script draws three colored axis lines at the element origin to visualize the Element Coordinate System:
- **Red line** (X-axis): Length direction
- **Green line** (Y-axis): Height direction
- **Light blue-gray line** (Z-axis): Width/thickness direction

These indicators help you understand which dimension corresponds to which measurement.

**Property Set Verification (if Property Set Name was selected):**

1. Select the element (not the script instance)
2. Open the AutoCAD Properties palette
3. Scroll to the Property Set section
4. Verify that the calculated values appear in the specified Property Set
5. Values should update automatically if you modify the element geometry

**DXA Export Verification:**

All calculated values are written to the DXA export interface regardless of display settings. You can verify this by running an hsbCAD Excel export or by checking the element's DXA data through the hsbCAD data inspector tools.

### Step 5: Adjust Parameters (Post-Insertion)

After insertion, all parameters remain fully adjustable. The script recalculates automatically whenever you change a parameter value.

**To Modify Parameters:**

1. Select the **script instance** (click on the data table or the reference marker on the element)
2. Open the AutoCAD **Properties palette** (Ctrl+1)
3. Locate the parameters under the TSL properties section
4. Change any value (unit, dimension source, display mode, etc.)
5. Press Enter or click outside the field

The script **immediately recalculates** and updates all display and export channels with the new values.

**Common Adjustments:**

| Scenario | Parameter to Change | New Value |
|----------|---------------------|-----------|
| Switch from structural to logistics dimensions | Length/Height/Width taken from | entire Element |
| Show table for single element QA | Show table | ECS |
| Hide table after verification | Show table | No |
| Filter out small service penetrations | Net Area: ignore Openings < DU² | 10000 (for mm drawings) |
| Change measurement unit for international project | Unit | m (or feet/inch) |
| Redirect output to different Property Set | Property Set Name | Select new Property Set |

---

## Properties Panel Reference

When the script instance is selected, the AutoCAD Properties palette displays the following parameters:

### Unit

| Attribute | Value |
|-----------|-------|
| **Type** | Dropdown (PropString) |
| **Default** | mm |
| **Options** | mm, cm, m, inch, feet |
| **Property Index** | 1 |

**Function:**
Specifies the measurement unit applied to all calculated output values. This affects:
- The on-screen data table display
- Values written to Property Set properties
- The unit suffix appended to dimension strings

**Behavior:**
When you change this parameter, the script immediately converts all calculated dimensions, areas, and volumes to the new unit system and updates all display and export channels.

**Important Notes:**
- DXA export values (for Excel) are **always in millimeters** regardless of this setting
- Property Set values are written as **pure numbers in the selected unit** (no unit suffix in the data)
- For international projects, use **m** (meters) or **feet** consistently across all elements

**Example:**
An element with dimensions 3000mm × 2400mm × 200mm:
- Unit = mm → Display shows "3000mm × 2400mm × 200mm"
- Unit = m → Display shows "3.0m × 2.4m × 0.2m"
- Unit = feet → Display shows "9.84ft × 7.87ft × 0.66ft"

---

### Decimals

| Attribute | Value |
|-----------|-------|
| **Type** | Number (PropInt) |
| **Default** | 1 |
| **Range** | 0, 1, 2, 3, 4 |
| **Property Index** | 1 |

**Function:**
Controls the number of decimal places displayed in the on-screen data table.

**Behavior:**
- Affects **visual formatting only**
- Does **not** affect values written to Property Sets (which retain full precision)
- Does **not** affect DXA export values
- Applies to all numerical fields in the table (dimensions, areas, volumes)

**Use Cases:**
| Decimals | Best For | Example Output |
|----------|----------|----------------|
| 0 | Rough estimates, preliminary design | 3000mm, 7m² |
| 1 | Standard production documentation | 3000.0mm, 7.2m² |
| 2 | Precise engineering calculations | 3000.45mm, 7.23m² |
| 3-4 | High-precision requirements | 3000.456mm, 7.234m² |

---

### Length taken from

| Attribute | Value |
|-----------|-------|
| **Type** | Dropdown (PropString) |
| **Default** | entire Element |
| **Options** | entire Element, Zone 0, Element Outline |
| **Property Index** | 4 |

**Function:**
Determines which geometric reference is used to calculate the element's **length dimension** (measured along the element's local X-axis).

**Option Details:**

**1. entire Element**
- Uses the bounding box extent of **all beams and sheets** across all zones
- Includes structural frame (Zone 0), insulation layers, cladding, finish boards, etc.
- Provides the **maximum overall dimension** of the complete assembly
- **Use for**: Transport planning, storage space calculation, logistics

**2. Zone 0**
- Uses only the beams and sheets assigned to **Zone 0** (structural timber frame)
- Excludes finish materials, cladding, and insulation boards in other zones
- Provides the **structural frame dimension** for material estimation
- **Use for**: Structural material takeoff, timber quantity calculation, engineering

**3. Element Outline**
- Uses the element's 2D **envelope profile** (plEnvelope)
- Represents the design intent outline as defined during element creation
- Independent of actual beam placement or zone assignment
- **Use for**: Architectural coordination, design documentation

**Technical Implementation:**
The script creates shadow profiles by projecting all relevant beams onto the element's XY plane, then measures the extent of the shadow along the X-axis direction. This method correctly handles non-rectangular elements, angled beams, and complex geometries.

**Example:**
A wall element with:
- Zone 0 structural frame: 3000mm long
- Exterior sheathing extends 50mm beyond frame on each end
- Interior gypsum board flush with frame

Results:
- **entire Element**: 3100mm (frame + sheathing overhangs)
- **Zone 0**: 3000mm (frame only)
- **Element Outline**: 3000mm (design outline)

---

### Height taken from

| Attribute | Value |
|-----------|-------|
| **Type** | Dropdown (PropString) |
| **Default** | entire Element |
| **Options** | entire Element, Zone 0, Element Outline |
| **Property Index** | 5 |

**Function:**
Determines which geometric reference is used to calculate the element's **height dimension** (measured along the element's local Y-axis, typically the vertical direction for walls).

**Option Details:**

The options function identically to those described for "Length taken from" above, applied along the height (Y-axis) direction:

- **entire Element**: Full assembly height including all zones
- **Zone 0**: Structural frame height only
- **Element Outline**: Design outline height

**Typical Use:**
- For walls: Usually matches the "Length taken from" setting for consistency
- For floors/roofs: Often set to "Zone 0" to measure structural depth

---

### Width taken from

| Attribute | Value |
|-----------|-------|
| **Type** | Dropdown (PropString) |
| **Default** | entire Element |
| **Options** | entire Element, Zone 0, Wall Outline |
| **Property Index** | 3 |

**Function:**
Determines which geometric reference is used to calculate the element's **width dimension** (thickness, measured along the element's local Z-axis).

**Option Details:**

**1. entire Element**
- Uses the bounding box extent of all beams across all zones
- Measures the complete assembly thickness from exterior face to interior face
- **Use for**: Total build-up thickness, clearance calculations

**2. Zone 0**
- Uses only Zone 0 beams
- Typically represents the structural frame depth
- **Use for**: Structural material estimation

**3. Wall Outline** (Wall elements only)
- Uses the wall's 2D floor plan outline (plOutlineWall) to determine thickness
- Represents the design intent thickness as defined in the floor plan
- **Note**: This option is only meaningful for ElementWall types; for floors and roofs, it behaves like "entire Element"

**Technical Note:**
The script uses a different shadow projection plane for width calculation (element YZ plane instead of XY plane) to correctly measure thickness regardless of element orientation.

**Example:**
A wall element with:
- Zone 0 timber studs: 140mm deep
- Exterior insulation board: 60mm (Zone 1)
- Interior gypsum board: 12.5mm (Zone 2)

Results:
- **entire Element**: 212.5mm (140 + 60 + 12.5)
- **Zone 0**: 140mm (studs only)
- **Wall Outline**: Depends on how the wall outline was defined (typically matches design intent)

---

### Net Area: ignore Openings < DU²

| Attribute | Value |
|-----------|-------|
| **Type** | Number (PropDouble) |
| **Default** | 0 |
| **Unit** | Square drawing units (e.g., mm² if drawing is in mm) |
| **Property Index** | 0 |

**Function:**
Sets a minimum area threshold for openings. Any opening with an area smaller than the specified value will be **ignored** when calculating the Net Area (gross area minus openings).

**Calculation Logic:**

1. The script calculates the gross area from the element envelope
2. It iterates through all openings (windows, doors, service penetrations)
3. For each opening, it checks: `opening.area() > threshold`
4. Only openings that exceed the threshold are subtracted from the gross area

**Use Cases:**

| Threshold Value | Application | Effect |
|----------------|-------------|--------|
| 0 (default) | Standard calculation | All openings are counted, Net Area = Gross Area - All Openings |
| 10000 mm² | Filter small electrical boxes | Ignores penetrations < 100mm × 100mm |
| 50000 mm² | Filter electrical and small HVAC | Ignores penetrations < 224mm × 224mm |
| 250000 mm² | Count only windows/doors | Ignores penetrations < 500mm × 500mm |

**Rationale:**
In production reality, small service penetrations (electrical outlet boxes, small conduits, vent grilles) often do not significantly reduce the material yield or production efficiency. By filtering these out, the Net Area more accurately reflects the **production net area** rather than the **geometric net area**.

**Example:**
A wall element with gross area 7.2 m² (7,200,000 mm²) contains:
- One door opening: 2.0 m² (2,000,000 mm²)
- Two window openings: 1.5 m² each (1,500,000 mm² each)
- Four electrical boxes: 0.015 m² each (15,000 mm² each)

Results:
- **Threshold = 0**: Net Area = 7.2 - 2.0 - 1.5 - 1.5 - (4 × 0.015) = 2.14 m²
- **Threshold = 50000**: Net Area = 7.2 - 2.0 - 1.5 - 1.5 = 2.2 m² (electrical boxes ignored)

---

### Color

| Attribute | Value |
|-----------|-------|
| **Type** | Number (PropInt) |
| **Default** | 222 |
| **Range** | 1 to 255 (AutoCAD Color Index) |
| **Property Index** | 0 |

**Function:**
Sets the display color for:
- The on-screen data table text
- The coordinate system indicator lines (though X, Y, Z axes have predefined colors)
- Any other visual elements drawn by the script

**Common Color Choices:**

| Color Index | Color | Typical Use |
|-------------|-------|-------------|
| 1 | Red | Highlight for quality assurance verification |
| 3 | Green | Standard visibility on dark backgrounds |
| 7 | White/Black | High contrast (color depends on background) |
| 222 | Light Gray | Subtle, low-contrast for reference only |
| 150 | Cyan | Good visibility without high contrast |

**Note:**
The color value corresponds to the standard AutoCAD Color Index (ACI). The actual displayed color depends on your drawing's color scheme and background color settings.

---

### Dimstyle

| Attribute | Value |
|-----------|-------|
| **Type** | Dropdown (PropString) |
| **Default** | (First available DimStyle in drawing) |
| **Options** | All DimStyles defined in the current drawing |
| **Property Index** | 0 |

**Function:**
Selects the AutoCAD Dimension Style used to format the on-screen data table text.

**DimStyle Controls:**
- **Text font** (Arial, Romans, etc.)
- **Text height** (controls the size of table text)
- **Text color** (can override the Color parameter)
- **Text style** (bold, italic, etc.)
- **Text positioning** (left-justified, centered, etc.)

**Selection Guidelines:**

| Drawing Scale | Recommended Text Height | Typical DimStyle |
|---------------|------------------------|------------------|
| 1:100 | 2.5mm (plotted) = 250mm (model) | Standard architectural |
| 1:50 | 2.5mm (plotted) = 125mm (model) | Detail drawings |
| 1:20 | 2.5mm (plotted) = 50mm (model) | Shop drawings |

**Tip:**
Use a DimStyle with a text height appropriate for your model scale. If the table text appears too small or too large, create a custom DimStyle or modify the text height in an existing style, then select it here.

---

### Show table

| Attribute | Value |
|-----------|-------|
| **Type** | Dropdown (PropString) |
| **Default** | No |
| **Options** | No, WCS, ECS (Element coordinate system) |
| **Property Index** | 2 |

**Function:**
Controls whether and how the data table is displayed in the 3D model.

**Option Details:**

**No**
- The data table is **hidden** in the model
- Calculated values are still written to Property Sets (if configured)
- DXA export still functions normally
- **Use for**:
  - Batch processing on many elements to avoid visual clutter
  - Production workflows where only schedule/Excel output is needed
  - Final deliverable drawings where data tables would interfere with clarity

**WCS (World Coordinate System)**
- The table is displayed with text aligned to the **global coordinate axes**
- Text always appears flat relative to the world X-Y plane
- Text remains horizontal and readable regardless of element orientation
- **Use for**:
  - Floor and roof elements (typically horizontal)
  - Situations where you want all tables to have consistent orientation
  - Top-down plan views where element rotation varies

**ECS (Element Coordinate System)**
- The table is displayed with text aligned to the **element's own coordinate system**
- Text rotates with the element
- For wall elements: Text faces the wall's front direction
- For floor/roof elements: Text aligns with element local axes
- **Use for**:
  - Wall elements (text rotates with wall angle)
  - Element-specific verification where you want the table to "belong" to the element visually
  - 3D isometric views where each element has its own orientation

**Table Content:**

When displayed, the table shows:

| Row Label | Data Source |
|-----------|-------------|
| Level | Element group level name (e.g., "Ground Floor", "Level 2") |
| Code | Element code (e.g., "W1", "F2") |
| PosNum | Element position number (e.g., "101", "A-02") |
| Area net | Net area in selected unit² |
| Area brut | Gross area in selected unit² |
| Length | Length dimension in selected unit |
| Width | Width dimension in selected unit |
| Height | Height dimension in selected unit |
| Insulation | Insulation volume in selected unit³ |
| Information | Element definition text |

**Note:**
Rows with empty values or zero values are **automatically hidden** to keep the table compact.

**Visual Reference Marker:**

In addition to the table, the script draws a small visual marker at the anchor point:
- **Wall elements**: Small filled circle at the wall arrow point
- **Floor/Roof elements**: Short reference line at the element origin

---

### Property Set Name

| Attribute | Value |
|-----------|-------|
| **Type** | Dropdown (PropString) |
| **Default** | (empty) |
| **Options** | All Property Set Definitions available in the current drawing |
| **Property Index** | 6 |

**Function:**
Specifies the AutoCAD Property Set Definition where calculated values should be stored for use in schedules, BIM exports, and reports.

**Behavior:**

1. When a Property Set is selected, the script automatically **attaches the Property Set to the element** (if not already attached)
2. The script then writes calculated values to the Property Set properties based on **exact property name matching**
3. If a property name exists in the Property Set and matches one of the supported names (see table below), the script writes the calculated value
4. If a property name does not exist or does not match, it is skipped (no error)

**Supported Property Names (case-sensitive):**

| Property Name | Data Written | Unit |
|--------------|-------------|------|
| `Height` | Element height dimension | Selected unit |
| `Width` | Element width/thickness dimension | Selected unit |
| `Length` | Element length dimension | Selected unit |
| `Perimeter` | Element perimeter | Selected unit |
| `AreaNet` | Net area (gross minus openings) | Selected unit² |
| `AreaGros` | Gross area | Selected unit² |
| `Insulation` | Insulation cavity volume | Selected unit³ |

**Critical Requirements:**

1. **Property names must match exactly** (case-sensitive): `Height` works, `height` does not
2. **Properties must be defined as Real Number (Double)** type in the Property Set Definition
3. **Text-type properties are not supported** and will be skipped

**Setup Workflow:**

**Before inserting the script:**

1. Open AutoCAD Property Set Definition Manager (typically via the hsbCAD interface or AEC menu)
2. Create a new Property Set Definition (e.g., "ElementQuantities")
3. Add properties with the exact names listed above
4. Set each property type to **Real Number** (Double)
5. Assign the Property Set Definition to applicable element types (Wall, Floor, Roof)
6. Save the Property Set Definition

**After inserting the script:**

1. Select this parameter in the Properties palette
2. Choose the Property Set Definition from the dropdown
3. The script immediately attaches the Property Set and writes values
4. Verify by selecting the element and checking the Property Set section in the Properties palette

**Use Cases:**

| Application | Property Set Setup | Workflow |
|-------------|-------------------|----------|
| Schedule Tables | Create Property Set with all quantity fields | Insert script → Create schedule table referencing Property Set |
| IFC Export | Use IFC-compliant property names | Configure IFC export to include the Property Set |
| Excel Reporting | Standard quantity properties | Use hsbCAD Excel export with Property Set mapping |
| Structural Analysis Export | Include Length, Height, Width only | Export Property Sets to structural analysis format |

**Example Property Set Definition (XML snippet):**

```xml
<PropertySetDefinition>
  <Name>ElementQuantities</Name>
  <AppliesTo>Element</AppliesTo>
  <PropertyDefinitions>
    <PropertyDefinition Name="Height" Type="Real" />
    <PropertyDefinition Name="Width" Type="Real" />
    <PropertyDefinition Name="Length" Type="Real" />
    <PropertyDefinition Name="AreaNet" Type="Real" />
    <PropertyDefinition Name="AreaGros" Type="Real" />
    <PropertyDefinition Name="Insulation" Type="Real" />
  </PropertyDefinitions>
</PropertySetDefinition>
```

**Troubleshooting:**

| Issue | Cause | Solution |
|-------|-------|----------|
| Values not appearing in Property Set | Property names don't match | Check spelling and case (e.g., `Height` not `height`) |
| Property shows "#####" or error | Property defined as Text instead of Real Number | Edit Property Set Definition, change type to Real Number |
| Property Set not appearing in dropdown | Property Set not defined in drawing | Create Property Set Definition before inserting script |
| Values not updating after element change | Script instance disabled or deleted | Verify script instance exists and is valid |

---

## Data Export Channels

### DXA Export Interface

The script exports data via the **DXA (Data Exchange for AutoCAD)** interface, which is hsbCAD's standard mechanism for connecting 3D model data to Excel, databases, and external reporting tools.

**All DXA fields are exported in millimeters** regardless of the Unit parameter setting. This ensures consistent data exchange across projects with different unit preferences.

**Exported Fields:**

| Field Name | Description | Data Type | Unit |
|------------|-------------|-----------|------|
| `Level` | Element group level name (e.g., "Ground Floor") | String | N/A |
| `Code` | Element code (e.g., "W1") | String | N/A |
| `Name` | Element position number (e.g., "101") | String | N/A |
| `Sublabel` | Element code (duplicate of Code) | String | N/A |
| `Width` | Element width/thickness | Double | mm |
| `Height` | Element height | Double | mm |
| `Length` | Element length | Double | mm |
| `NetArea` | Net area (gross minus openings) | Double | mm² |
| `Area` | Gross area | Double | mm² |
| `Perimeter` | Element perimeter | Double | mm |
| `Volume` | Insulation cavity volume | Double | mm³ |
| `Info` | Element definition text | String | N/A |

**Usage:**

1. The DXA export is **always active** regardless of display settings or Property Set configuration
2. To access DXA data, use hsbCAD's Excel export function or data extraction tools
3. Create an Excel template that references the DXA field names
4. Run the export to populate the template with calculated values from all elements that have this script attached

**Example Excel Template Mapping:**

| Excel Column | DXA Field | Formula/Mapping |
|--------------|-----------|-----------------|
| A | Name | =DXA.Name |
| B | Code | =DXA.Code |
| C | Length (m) | =DXA.Length / 1000 |
| D | Height (m) | =DXA.Height / 1000 |
| E | Width (mm) | =DXA.Width |
| F | Net Area (m²) | =DXA.NetArea / 1000000 |
| G | Insulation (m³) | =DXA.Volume / 1000000000 |

---

### Property Set Export

When a Property Set Name is selected, the script writes calculated values to the element's Property Set using the `setAttachedPropSetFromMap()` method.

**Property Value Conversion:**

Values are written in the **selected unit** (from the Unit parameter), not in millimeters:

```c
// Example from script code:
if (map.hasDouble("Height"))
    map.setDouble("Height", dHeight / pow(U(1, sUnit, 2), 1), _kNoUnit);
```

The `_kNoUnit` flag indicates that the value is stored as a **pure number** without embedded unit information. The unit context is determined by your Unit parameter setting.

**Important:**

- If you change the Unit parameter after values have been written, the Property Set values will be **recalculated and overwritten** in the new unit system
- Property Set values do **not** include unit suffixes (e.g., stored as `3.5`, not `3.5m`)
- Schedule tables and reports should apply unit labels based on your project standards

---

### Visual Table Display

When "Show table" is set to WCS or ECS, the script renders a formatted text table using the `Display` class and the selected DimStyle.

**Table Layout:**

```
Level:        Ground Floor
Code:         W1
PosNum:       101
Area net:     6.5m²
Area brut:    7.2m²
Length:       3.0m
Width:        0.2m
Height:       2.4m
Insulation:   0.42m³
Information:  External Wall - Insulated Frame
```

**Formatting Rules:**

- Labels are **left-aligned** in the left column
- Values are **left-aligned** in the right column, offset from labels
- The offset distance is calculated based on the longest label text to ensure clean alignment
- Rows with empty or zero values are **automatically hidden**
- All numerical values include unit suffixes (e.g., "m²", "m³")

**Anchor Points:**

| Element Type | Anchor Location | Visual Marker |
|-------------|-----------------|---------------|
| Wall (ElementWall) | Wall arrow point (`ptArrow()`) | Small filled circle, offset 4× diameter in Z direction |
| Floor/Roof | Element origin (`ptOrg()`) | Short reference line extending 20mm in X direction |

**Coordinate System Visualization:**

In addition to the table, the script draws three colored axis lines at the element origin:

```c
vx.vis(ptOrg, 1);   // Red (X-axis)
vy.vis(ptOrg, 3);   // Green (Y-axis)
vz.vis(ptOrg, 150); // Light blue-gray (Z-axis)
```

These lines help users understand the element's local coordinate system and verify the meaning of length/height/width measurements.

---

## Calculation Logic Details

### Dimension Calculation (Shadow Profile Method)

The script uses a **shadow profile projection** technique to calculate maximum dimensions. This method handles complex geometries, non-rectangular elements, and multi-zone assemblies correctly.

**Process:**

1. **Initialize Shadow Profiles**
   ```c
   PlaneProfile ppShadowLength(CoordSys(ptOrg, vx, vy, vz));
   PlaneProfile ppShadowHeight(CoordSys(ptOrg, vx, vy, vz));
   PlaneProfile ppShadowWidth(CoordSys(ptOrg, vx, -vz, vy));
   ```
   Three empty shadow profiles are created, one for each dimension axis.

2. **Iterate Through All Beams**
   ```c
   for (int i = 0; i < gb.length(); i++) {
       if (gb[i].solidLength() < dEps || gb[i].solidHeight() < dEps || gb[i].solidWidth() < dEps)
           continue;  // Skip invalid beams
       Body bd = gb[i].realBody();
       // Project to shadow...
   }
   ```
   Each beam's 3D solid is projected onto the appropriate reference plane.

3. **Apply Zone Filtering**
   ```c
   if (nLengthSource == 0 || (nLengthSource == 1 && gb[i].myZoneIndex() == 0)) {
       // Include this beam in length calculation
   }
   ```
   Beams are included or excluded based on the "taken from" parameter settings.

4. **Union Shadow Profiles**
   ```c
   if (ppShadowLength.area() < pow(dEps, 2))
       ppShadowLength = ppShadowZ;
   else
       ppShadowLength.unionWith(ppShadowZ);
   ```
   Individual beam shadows are combined using Boolean union operations.

5. **Measure Extent**
   ```c
   LineSeg lsShadowLength = ppShadowLength.extentInDir(vx);
   dLength = abs(vx.dotProduct(lsShadowLength.ptStart() - lsShadowLength.ptEnd()));
   ```
   The extent of the combined shadow along each axis gives the maximum dimension.

**Why Shadow Profiles?**

- Correctly handles **angled beams** (e.g., hip rafters, bracing)
- Works with **non-rectangular** element outlines
- Accounts for **overhangs and extensions** automatically
- Independent of beam sequence or naming

---

### Area Calculation

**Gross Area:**
```c
double dAreaBrut = el.plEnvelope().area();
```
Calculated directly from the element's envelope polyline, which represents the outer boundary of the element.

**Net Area:**
```c
double dAreaNet = dAreaBrut;
for (int i = 0; i < op.length(); i++)
    if (op[i].plShape().area() > dMinArea)
        dAreaNet = dAreaNet - op[i].plShape().area();
```

Process:
1. Start with gross area
2. Iterate through all openings
3. For each opening, check if its area exceeds the threshold
4. Subtract qualifying openings from gross area

**Perimeter Calculation:**
```c
Point3d pt[] = el.plEnvelope().vertexPoints(FALSE);
for (int i = 0; i < pt.length() - 1; i++)
    dPeri = dPeri + Vector3d(pt[i] - pt[i+1]).length();
```

Process:
1. Extract vertex points from envelope polyline
2. Sum the distance between consecutive vertices
3. Result is the total perimeter length

---

### Insulation Volume Calculation

The insulation volume calculation is the most complex part of the script. It estimates the volume of the insulation cavity within Zone 0 by using a 2D shadow projection method.

**Conceptual Model:**

Insulation cavity = (Zone 0 beam shadow area - Opening shadow areas) × Zone 0 depth

**Detailed Process:**

**1. Create Zone 0 Projection Plane**
```c
PLine plZn0;
plZn0.createRectangle(LineSeg(ptOrg - vx*U(25000), ptOrg + vx*U(25000) - vz*el.dBeamWidth()), vx, vz);
PlaneProfile ppZn0(plZn0);
```
A large rectangular plane aligned with the element face is created to serve as the reference for testing which beams are within Zone 0.

**2. Project Zone 0 Beams**
```c
for (int i = 0; i < gb.length(); i++) {
    if (gb[i].myZoneIndex() == 0) {
        // Test if beam intersects Zone 0 plane
        PlaneProfile pp = ppZn0;
        pp.intersectWith(ppShadowY);
        if (pp.area() < pow(dEps, 2))
            continue;  // Beam fully outside Zone 0

        // Project beam shadow
        PlaneProfile ppShadowZ = bd.shadowProfile(Plane(ptOrg, vz));
        ppShadowAll.unionWith(ppShadowZ);
    }
}
```

Process:
- Only Zone 0 beams are considered
- Each beam is projected onto the element's face plane (perpendicular to Z-axis)
- Projections are combined using Boolean union
- Beams completely outside the Zone 0 projection area are skipped (prevents errors on complex elements)

**3. Extract Outer Boundary**
```c
PLine plRings[] = ppShadowAll.allRings();
int bIsOp[] = ppShadowAll.ringIsOpening();
PLine plMax;
for (int r = 0; r < plRings.length(); r++)
    if (plMax.area() < plRings[r].area() && !bIsOp[r])
        plMax = plRings[r];
```

The shadow profile may contain multiple rings (outer boundary + holes). The script identifies the largest non-opening ring as the outer boundary.

**4. Subtract Openings**
```c
for (int i = 0; i < op.length(); i++)
    pp.joinRing(op[i].plShape(), _kSubtract);
for (int i = 0; i < plTslOpening.length(); i++)
    pp.joinRing(plTslOpening[i], _kSubtract);
```

Two types of openings are subtracted:
- **Standard hsbCAD openings** (doors, windows)
- **TSL-defined openings** (openings created by other TSL scripts that write a PLine to their map under the key "tslOpening")

**5. Calculate Volume**
```c
dInsulation += pp.area();
// ... after processing all rings:
dInsulation *= el.dBeamWidth();
```

The net shadow area is multiplied by the element's beam width (Zone 0 depth) to estimate the 3D insulation cavity volume.

**Limitations:**

- This is a **2D approximation** based on shadow projection, not a full 3D Boolean calculation
- Assumes uniform cavity depth across the entire element (uses `el.dBeamWidth()`)
- May slightly overestimate volume in complex geometries with varying cavity depths
- Does **not** account for insulation material compression or installation gaps

**Accuracy:**

For typical wall, floor, and roof elements with rectangular cavities and uniform depth, the accuracy is very high (±1-2%). For complex curved or tapered elements, consider this an estimate rather than a precision measurement.

---

## Advanced Usage Scenarios

### Scenario 1: Multi-Configuration Element Analysis

**Challenge:**
You need both structural dimensions (for material ordering) and logistics dimensions (for transport planning) for the same element.

**Solution:**

1. **First insertion** (Structural quantities):
   - Unit: mm
   - Length/Height/Width taken from: Zone 0
   - Show table: No
   - Property Set Name: "StructuralQuantities"

2. **Second insertion** (Logistics quantities):
   - Unit: m
   - Length/Height/Width taken from: entire Element
   - Show table: No
   - Property Set Name: "LogisticsQuantities"

Each element will have two script instances writing to different Property Sets, enabling separate schedule tables for different purposes.

**Note:**
The script's duplicate prevention only checks for existing instances with the **same script name**, not based on configuration. To allow multiple instances, you would need to use different script names or disable the duplicate check.

**Alternative:**
Use a single instance and change the configuration parameters as needed for different reports. Update the Property Set Name before each report generation to write values to the appropriate Property Set.

---

### Scenario 2: Quality Assurance Verification

**Challenge:**
During model review, you need to visually verify element dimensions and spot errors quickly.

**Solution:**

1. Batch-insert the script on all elements:
   - Show table: ECS
   - Color: 1 (Red)
   - Decimals: 1
   - Unit: m (or primary project unit)

2. Perform visual inspection in 3D views:
   - Look for outliers (unusually large/small dimensions)
   - Verify insulation volumes are reasonable
   - Check net area values against expected ranges

3. After verification, switch all instances to hidden:
   - Select all script instances
   - Change "Show table" to "No" via Properties palette
   - Data remains available in Property Sets and DXA export

---

### Scenario 3: Progressive Design Workflow

**Challenge:**
Elements are created in stages (framing first, then cladding added, then interior finish). You need quantities to update automatically as the design progresses.

**Solution:**

1. Insert the script immediately after creating the structural frame:
   - Length/Height/Width taken from: entire Element (will initially reflect frame only)
   - Property Set Name: "ElementQuantities"

2. As you add cladding layers, the script automatically recalculates:
   - Dimensions update to include new layers
   - Insulation volume updates as cavity is refined
   - Property Set values update automatically

3. No manual intervention required—the parametric nature of the script ensures quantities always reflect the current model state

**Benefit:**
Real-time quantity tracking throughout the design process, enabling early cost estimation and material planning.

---

### Scenario 4: Handling Complex Multi-Zone Elements

**Challenge:**
An element has multiple zones with different materials:
- Zone 0: Structural CLT panel (100mm)
- Zone 1: Exterior insulation (60mm)
- Zone 2: Exterior cladding (20mm)
- Zone 3: Interior service cavity (40mm)
- Zone 4: Interior finish (12mm)

You need to report both the structural CLT dimensions and the complete assembly dimensions.

**Solution:**

**For Structural CLT Dimensions:**
- Length/Height/Width taken from: Zone 0
- Result: Dimensions of the 100mm CLT panel only

**For Complete Assembly Dimensions:**
- Length/Height/Width taken from: entire Element
- Result: Dimensions including all layers (232mm total thickness)

**For Insulation Volume (Zone 3 service cavity):**

The script only calculates insulation for Zone 0. To measure Zone 3 cavity:

**Option 1:**
Temporarily reassign the service cavity beams to Zone 0, run the script, then reassign back to Zone 3.

**Option 2:**
Use a separate calculation method or script specifically designed for multi-zone insulation estimation.

**Limitation:**
The current script design focuses on Zone 0 as the primary structural/insulation layer. For elements with multiple insulation zones, consider custom script modifications or alternative tools.

---

## Troubleshooting

### Issue: Table Not Visible After Insertion

**Possible Causes:**

1. **"Show table" set to "No"**
   - Solution: Select the script instance, change "Show table" to WCS or ECS

2. **Table placed outside visible viewport**
   - Solution: Zoom extents or pan to element location
   - For wall elements, check near the wall arrow point
   - For floors/roofs, check near the element origin

3. **Text height too small for current zoom level**
   - Solution: Select a DimStyle with larger text height, or zoom in closer

4. **Color matches background**
   - Solution: Change the Color parameter to a contrasting value (e.g., 1 for red)

---

### Issue: Property Set Values Not Updating

**Possible Causes:**

1. **Property names don't match exactly**
   - Solution: Verify case-sensitive matching (`Height` not `height`)
   - Check for typos or extra spaces

2. **Properties defined as Text instead of Real Number**
   - Solution: Edit the Property Set Definition, change property type to Real Number (Double)

3. **Property Set not attached to element**
   - Solution: Select the script instance, verify Property Set Name is selected
   - Check the element (not script instance) in Properties palette to confirm Property Set attachment

4. **Script instance invalid or deleted**
   - Solution: Verify the script instance still exists on the element
   - If deleted, re-insert the script

5. **Unit mismatch causing confusion**
   - Solution: Remember that Property Set values are in the selected unit, not mm
   - If Unit = m and value shows 3.5, that means 3.5 meters, not 3.5 mm

---

### Issue: Insulation Volume Calculation Seems Incorrect

**Possible Causes:**

1. **Beams not assigned to Zone 0**
   - Solution: Verify that structural beams are in Zone 0
   - Check beam properties in the Properties palette

2. **Openings not properly defined**
   - Solution: Verify openings have valid plShape() polylines
   - Check opening objects in the drawing for errors

3. **Complex element geometry with varying cavity depth**
   - Solution: Understand that the script uses a 2D approximation
   - For complex geometries, consider this an estimate
   - Manually calculate insulation volume for critical elements

4. **Small beams or sheets causing projection errors**
   - Solution: The script filters out beams with dimensions smaller than 0.1mm
   - Verify that structural beams have valid, non-zero dimensions

---

### Issue: Duplicate Prevention Not Working

**Symptom:**
Multiple instances of the script are attached to the same element, causing redundant calculations.

**Cause:**
The duplicate prevention logic compares script names case-insensitively. If you manually renamed the script file or instance, the check may fail.

**Solution:**
1. Manually delete duplicate instances:
   - Select each duplicate script instance individually
   - Press Delete or use the Erase command

2. Verify script name consistency:
   - Ensure all copies of the script have the exact same name
   - Avoid renaming script instances after insertion

---

### Issue: DXA Export Missing Data

**Possible Causes:**

1. **Element not numbered**
   - Solution: Assign a position number to the element using hsbCAD numbering tools
   - The script exports data, but some DXA consumers require numbered elements

2. **Script instance not in selection set**
   - Solution: When running DXA export, ensure the element (and its script instances) are included in the selection set

3. **Excel template field names don't match**
   - Solution: Verify template uses exact DXA field names (case-sensitive)
   - Refer to the Data Export Fields table in this documentation

---

## Related Tools and Workflows

### Schedule Table Creation

After attaching hsbExtendedElementData to multiple elements:

1. Create an AutoCAD Schedule Table definition
2. Configure the table to reference the Property Set used by the script
3. Add columns for desired properties (Height, Width, Length, AreaNet, etc.)
4. Insert the schedule table into a layout viewport
5. The table automatically populates with data from all elements that have the script attached

**Benefit:**
Live-linked schedule that updates automatically when element geometry changes.

---

### Excel Quantity Takeoff

**Workflow:**

1. Attach hsbExtendedElementData to all elements requiring quantity tracking
2. Create an Excel template with formulas referencing DXA field names
3. Run hsbCAD Excel export, selecting the appropriate elements
4. Excel template populates with calculated values
5. Perform additional calculations (totals, material costs, etc.) in Excel

**Example Template Structure:**

| Column | Header | Formula | Result |
|--------|--------|---------|--------|
| A | Position | =DXA.Name | 101 |
| B | Code | =DXA.Code | W1 |
| C | Length (m) | =DXA.Length/1000 | 3.0 |
| D | Height (m) | =DXA.Height/1000 | 2.4 |
| E | Width (mm) | =DXA.Width | 200 |
| F | Gross Area (m²) | =DXA.Area/1000000 | 7.2 |
| G | Net Area (m²) | =DXA.NetArea/1000000 | 6.5 |
| H | Insulation (m³) | =DXA.Volume/1000000000 | 0.42 |
| I | Material Cost | =G1 * $MaterialRate | (calculated) |

---

### IFC Export Integration

For BIM workflows requiring IFC (Industry Foundation Classes) export:

1. Create a Property Set Definition with IFC-compliant property names
2. Attach the script using that Property Set
3. Configure hsbCAD IFC export to include the Property Set
4. Export to IFC format
5. Quantity data is included in the IFC file for use in BIM viewers and analysis tools

**IFC-Compliant Property Names (example):**

- `Qto_WallBaseQuantities.Length`
- `Qto_WallBaseQuantities.Height`
- `Qto_WallBaseQuantities.Width`
- `Qto_WallBaseQuantities.NetSideArea`
- `Qto_WallBaseQuantities.GrossSideArea`

Consult IFC schema documentation for exact property naming conventions based on your target IFC version (IFC2x3, IFC4, etc.).

---

## Technical Implementation Notes

### Execution Architecture

**Script Type:** O-Type (Object)
- The script instance becomes a persistent object in the drawing database
- It maintains a dependency link to its parent element
- Automatic recalculation occurs when:
  - Element geometry changes (beams added/removed/modified)
  - Element zones are modified
  - Openings are added/removed/resized
  - Script parameters are changed via Properties palette

**Execution Loops:**
```c
if (_bOnDbCreated)
    setExecutionLoops(2);
```

The script uses two execution loops to ensure all geometric dependencies are resolved:
- **Loop 1**: Calculate dimensions and areas based on current beam geometry
- **Loop 2**: Recalculate insulation volume and update displays to ensure consistency

**Element Group Assignment:**
```c
assignToElementGroup(el, TRUE, 0, 'E');
```

The script assigns itself to the element group, ensuring:
- It is included in element-based selection sets
- It is exported with the element in data exchange operations
- It is deleted if the parent element is deleted

---

### Performance Considerations

**Calculation Complexity:**

For a typical element with 50 beams and 5 openings:
- Shadow profile operations: O(n) where n = beam count
- Boolean unions: O(n log n) for complex profiles
- Opening subtraction: O(m) where m = opening count
- Total typical execution time: <0.1 seconds

**Optimization Tips:**

1. **Use "entire Element" instead of "Zone 0" when possible**
   - Fewer beams to process = faster calculation
   - Only use Zone 0 filtering when semantically necessary

2. **Set appropriate opening threshold**
   - Filtering small openings reduces Boolean operation count
   - Threshold of 10000-50000 mm² significantly improves performance on elements with many service penetrations

3. **Hide tables on batch processing**
   - Display operations (text rendering) add overhead
   - Use "Show table: No" during batch insertion, enable selectively afterward

4. **Minimize Property Set property count**
   - Only include properties you actually use
   - Fewer properties = less map manipulation overhead

---

### Coordinate System Handling

The script operates in the element's local coordinate system (ECS):

```c
CoordSys cs = el.coordSys();
Point3d ptOrg = cs.ptOrg();
Vector3d vx = cs.vecX();
Vector3d vy = cs.vecY();
Vector3d vz = cs.vecZ();
```

**Element Axes:**
- **X-axis (vx)**: Length direction (typically along the element's primary direction)
- **Y-axis (vy)**: Height direction (typically vertical for walls, thickness for floors)
- **Z-axis (vz)**: Width/thickness direction (typically perpendicular to element face)

**Coordinate System Visualization:**

The colored axis indicators help verify orientation:
```c
vx.vis(ptOrg, 1);   // Red
vy.vis(ptOrg, 3);   // Green
vz.vis(ptOrg, 150); // Light blue-gray
```

This is particularly useful when troubleshooting dimension calculations on angled or rotated elements.

---

### Map-Based Data Exchange

**TSL-Defined Openings:**

The script can detect openings defined by other TSL scripts via the map interface:

```c
TslInst tslList[] = el.tslInst();
PLine plTslOpening[0];
for (int t = 0; t < tslList.length(); t++) {
    Map map = tslList[t].map();
    if (map.hasPLine("tslOpening"))
        plTslOpening.append(map.getPLine("tslOpening"));
}
```

**Usage:**

If you create a custom TSL script that defines openings (e.g., specialized service penetrations, custom cutouts), add this code to your script:

```c
_Map.setPLine("tslOpening", plMyOpening);
```

hsbExtendedElementData will automatically detect and subtract this opening from the insulation calculation.

---

### Error Handling and Robustness

**Invalid Beam Filtering:**
```c
if (gb[i].solidLength() < dEps || gb[i].solidHeight() < dEps || gb[i].solidWidth() < dEps)
    continue;
```

Beams with zero or near-zero dimensions are skipped to prevent:
- Division by zero errors
- Invalid shadow profile generation
- Boolean operation failures

**Tolerance Handling:**
```c
double dEps = U(.1);
```

A tolerance of 0.1mm is used throughout the script for:
- Geometric comparisons
- Area threshold checks
- Boolean operation merging

**Version History (Bug Fixes):**

- **v3.0 (July 2014)**: Fixed insulation calculation failure when studs are fully outside wall outline
- **v2.9 (Oct 2012)**: Made script tolerant of GenBeams with zero X/Y/Z dimensions
- **v2.8 (Mar 2012)**: Added support for TSL-defined openings via map interface
- **v2.7 (Feb 2012)**: Improved tolerance for small opening offsets
- **v2.4 (Oct 2011)**: Fixed tolerance issue in element width calculation

---

## Version Information

| Attribute | Value |
|-----------|-------|
| **Script Version** | 3.0 |
| **Release Date** | July 7, 2014 |
| **Author** | th@hsbCAD.de |
| **Major Version** | 3 |
| **Minor Version** | 0 |

**Version History Summary:**

```
v3.0 (07jul14): Bugfix - insulation calculation failed when studs fully outside wall outline
v2.9 (01oct12): Tolerant against genbeams with zero X/Y/Z dimensions
v2.8 (07mar12): Bugfix property set selection all element types, TSL-defined openings support
v2.7 (03feb12): Insulation calculation tolerates small opening offsets
v2.6 (01feb12): Description enhanced
v2.5 (19oct11): Validation if genbeams are within zone 0 for insulation detection
v2.4 (19oct11): Tolerance issue element width fixed
v2.3 (18oct11): Property set export support, wall element visualization at arrow location
v2.2 (07jun11): Bugfix insulation volume
v2.1 (30nov09): Content standardization
v2.0 (12may09): Simplified insulation calculation (shadow profile method)
v1.9: Enhanced tolerances for complex solids
v1.8: Bugfix insertion on element copies
v1.7: New option to define minimal opening area threshold
v1.6: New width calculation options (element outline, zone 0, wall outline)
v1.5: New info export option (element definition)
v1.4: New length/height calculation options
v1.3: Insulation volume output added
v1.2: New option for element width from entire element or zone 0
```

---

## Summary

**hsbExtendedElementData** is a powerful, multi-purpose element analysis tool that bridges the gap between 3D modeling and production data workflows. By providing parametric dimension calculation, insulation volume estimation, and multi-channel data export, it enables:

✅ **Automated quantity takeoff** for material estimation
✅ **Live-linked schedules** that update with design changes
✅ **BIM-compliant data export** via Property Sets and IFC
✅ **Excel integration** for custom reporting and cost analysis
✅ **Visual quality assurance** through on-screen data tables
✅ **Flexible measurement methods** for different workflow stages (structural vs. logistics)

The script's intelligent handling of multi-zone elements, opening thresholds, and TSL-defined openings makes it suitable for complex timber construction projects with diverse data requirements.

**Best Practices:**

1. **Insert early** in the design process for continuous quantity tracking
2. **Configure Property Sets** before insertion to enable schedule integration
3. **Use appropriate dimension sources** (Zone 0 for structural, entire Element for logistics)
4. **Set opening thresholds** to match production reality
5. **Hide tables** during batch processing to reduce visual clutter
6. **Verify calculations** by spot-checking key elements with manual measurements

**Limitations to Understand:**

- Insulation volume is a **2D shadow-based approximation**, not a full 3D calculation
- Only **Zone 0** is considered for insulation cavity measurement
- Property Set property names must **match exactly** (case-sensitive)
- DXA export values are **always in millimeters**, regardless of Unit setting

For questions, customization requests, or technical support, contact hsbCAD support or consult the hsbCAD TSL scripting documentation.
