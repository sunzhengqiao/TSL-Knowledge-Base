# hsb_Insulation

Automatically fills solid insulation between timber members within wall elements, supporting multiple insulation products, connection-specific insulation, stock size tracking, and visual hatch display.

## Overview

This script creates solid insulation sheets that fill the cavities between timber studs, plates, and framing members inside wall elements. It analyzes the element geometry in zone 0, identifies all beam profiles, subtracts them from the available area, and generates individual insulation sheet entities for each cavity. The result is a complete set of insulation sheets that conform precisely to the spaces between framing members.

Key capabilities of this script include:

- **Automatic cavity detection**: The script projects all beams in zone 0 onto the element plane, identifies the open areas between them, and fills those areas with insulation sheets
- **Dual insulation types**: Supports a primary insulation product for standard cavities and a separate insulation product for connection areas where flat studs or rotated beams create non-standard cavities
- **Wall type filtering**: Apply insulation only to specific wall types (e.g., external walls coded EA, EB) by specifying wall type codes separated by semicolons
- **Opening awareness**: Automatically excludes door and window openings, including their surrounding gap areas, from insulation placement
- **Conflict avoidance**: Detects areas marked by other TSL instances (such as hsb_Vent) that should not receive insulation, and excludes those regions
- **Duplicate prevention**: When inserted on an element that already has an hsb_Insulation instance, the existing instance is automatically removed and replaced
- **Stock size export**: Exports insulation stock dimensions (width, length, unit type) to the element database as ElemItem entries for bill-of-material and quantity takeoff purposes
- **Flat stud handling**: Optionally stops insulation flush at flat studs that do not span the full zone thickness, preventing insulation from wrapping around rotated members
- **Hatch display**: Provides configurable hatch patterns for plan-view visualization of insulation areas, with text labels reading "Insulation" in both front and top views

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O (Object) |
| Beams Required | 0 |
| Implicit Insert | Yes |
| Model Space | Yes |
| Paper Space | No |
| Version | 2.23 |
| Keywords | Insulation, UK, Wall, Element |

This script operates in Model Space on wall elements. It is designed primarily for the UK content workflow but can be used in any hsbCAD project that requires insulation fill within framed wall elements.

## Prerequisites

1. **Wall elements must exist**: One or more wall elements must be present in the drawing before running this script. Each element must contain framing beams (studs, plates, headers) in zone 0
2. **Beam placement complete**: All studs, plates, blocking, and framing members should be placed and finalized before inserting insulation, as the script analyzes the current beam positions to determine cavities
3. **Openings defined**: Any window or door openings should be fully defined in the element so the script can properly exclude those areas from insulation placement
4. **Wall type codes assigned**: If you plan to use the wall type filter property, ensure your elements have the correct wall type codes (e.g., EA, EB) assigned in the element properties

## Usage Steps

### Inserting the Insulation

1. **Launch the script**
   - Run hsb_Insulation from the hsbCAD ribbon, tool palette, or by using the `TSLINSERT` command and selecting `hsb_Insulation.mcr`
   - If run from the command line (not from the tool palette), a properties dialog appears automatically on first insertion for initial configuration

2. **Configure insulation properties**
   - In the Properties Panel (Ctrl+1) or the initial dialog, set the desired insulation product name, thickness, stock sizes, and display options before selecting elements
   - Set the "Wall types for this Insulation" property if you want to restrict insulation to certain wall types (e.g., type `EA;EB;` to limit to external wall types EA and EB)

3. **Select elements**
   - At the command line prompt "Select a set of elements", click on the wall elements you wish to insulate
   - You may select multiple elements in a single selection set
   - Press Enter to confirm the selection

4. **Automatic processing**
   - The script iterates over each selected element
   - For each element, it checks the element code against the wall type filter; elements whose code does not appear in the filter list are skipped
   - A separate hsb_Insulation instance is created on each qualifying element
   - Each instance independently analyzes beam positions and generates insulation sheets for the cavities
   - The original selection instance erases itself after spawning per-element instances

5. **Review results**
   - Insulation sheets appear as colored solids filling the cavities between studs
   - If hatch display is enabled, a hatch pattern appears in plan (top) view
   - The text label "Insulation" appears in both front and top views at the center of each sheet

### Modifying Insulation After Placement

1. **Select the insulation instance** by clicking on it in the drawing
2. **Open the Properties Panel** (Ctrl+1) to adjust parameters such as thickness, insulation name, display settings, or stock sizes
3. **Right-click** on the instance to access the context menu for reapplication (see the Right-Click Menu section below)
4. Changes to properties take effect on the next recalculation or when "Reapply Insulation Sheets" is triggered

### Replacing Insulation

- If you insert hsb_Insulation on an element that already has an existing instance of the same script, the old instance is automatically erased and replaced by the new one
- Only one hsb_Insulation instance can exist per element at a time

## Properties Panel Parameters

### General Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Wall types for this Insulation | String | `EA;EB;` | Semicolon-separated list of wall type codes. Only elements whose element code matches one of these entries will receive insulation. Use semicolons to separate multiple codes (e.g., `EA;EB;EC;`). The element code must match exactly |
| Insulation Name | String (Dropdown) | Crown FrameTherm Roll 40 | Select from a predefined list of insulation products. Available options include Crown FrameTherm Roll (40/37/35), Crown FrameTherm Slab (40/37/35), Crown Universal Slab (CS24/CS32/CS48), Isover Acoustic 25 Roll, Knauf RS 45 Slab, Knauf Earthwool 35 Slab, Rocksilk Universal Slab (RS33/RS45/RS60/RS80/RS100/RS140/RS200), Kingspan Thermawall (TW50/TW53/TW70), and "Other Insulation Type" |
| Other Insulation Type | String | (empty) | When "Other Insulation Type" is selected in the Insulation Name dropdown, this field defines the custom insulation name applied to the created sheets. Ignored when a named product is selected |
| Attach Insulation to Zone | Integer (Dropdown) | 10 | Selects which zone the insulation sheets are assigned to. Displayed values 1 through 10 and 0 map to internal zone indices: 1 through 5 map directly, 6 through 10 map to -1 through -5, and 0 maps to zone 0. The default value of 10 places insulation in zone -5 |
| Insulation Thickness | Double | 90 mm | Thickness of the primary insulation material. If set to 0, the insulation thickness automatically matches the full thickness of zone 0, which is useful when you want insulation to always fill the entire cavity depth |
| Insulation Stock Width | Double | 1200 mm | Stock roll or slab width for the primary insulation product. This value is exported to the element database for bill-of-material reports |
| Insulation Stock Length | Double | 8000 mm | Stock roll or slab length for the primary insulation product. This value is exported to the element database for bill-of-material reports |
| Insulation Stock Units | String (Dropdown) | Rolls | Unit type for primary insulation stock. Options: Rolls, Slabs, Batts, Boards. Used in BOM export |
| Insulation Name for Connections | String (Dropdown) | Crown FrameTherm Roll 40 | Insulation product name for connection areas where flat or rotated studs create secondary cavities. Same product dropdown options as the primary Insulation Name |
| Other Insulation Type for Connections | String | (empty) | Custom name for connection insulation when "Other Insulation Type" is selected in the connections dropdown |
| Insulation Thickness for Connections | Double | 90 mm | Thickness of the insulation used in connection areas (at flat studs or junction framing) |
| Insulation Stock Width (Connections) | Double | 1200 mm | Stock width for connection insulation material, exported to the element database |
| Insulation Stock Length (Connections) | Double | 8000 mm | Stock length for connection insulation material, exported to the element database |
| Insulation Stock Units (Connections) | String (Dropdown) | Rolls | Unit type for connection insulation stock. Options: Rolls, Slabs, Batts, Boards |
| Minimal width/height | Double | 20 mm | Minimum cavity dimension. Any insulation sheet whose width or height is smaller than this value will not be created. This prevents very small slivers of insulation from being generated that would be impractical to install |
| Minimal Thickness | Double | 20 mm | Minimum cavity depth threshold. Any insulation sheet thinner than this value will not be created |
| Decrease width of insulation | Double | 0 mm | Reduces the overall width of all insulation sheets inward by this amount from both edges. Useful for creating a friction-fit tolerance gap between insulation and beams |
| Decrease height of insulation | Double | 0 mm | Reduces the overall height of all insulation sheets inward by this amount from both edges. Useful for creating a friction-fit tolerance gap between insulation and beams |
| Stop Insulation Flush to Flat Studs | String (Yes/No) | No | When set to "Yes", insulation will not be created behind flat studs (studs rotated so they do not span the full zone thickness). This prevents insulation from extending into areas where flat studs partially block the cavity |

### Display Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Display Hatch Pattern | String (Yes/No) | Yes | Enables or disables the display of a hatch pattern on insulation areas when viewed from the top (plan view). Also controls text label visibility |
| Hatch Pattern | String (Dropdown) | (system hatch list) | Selects the hatch pattern style used to represent insulation in plan view. Options are loaded from the AutoCAD system hatch pattern library |
| Hatch Scale | Double | 7.5 mm | Controls the scale (density) of the hatch pattern. Larger values produce a more spread-out pattern; smaller values create denser hatching |
| Hatch Angle | Double | 0 degrees | Rotation angle of the hatch pattern in degrees |
| Hatch Color | Integer | 51 | AutoCAD color index for the hatch pattern, insulation text labels, and sheet display. Valid range: -1 to 255. Values outside this range are automatically reset to 171 |
| Dimstyle | String (Dropdown) | (system dim style list) | Dimension style used for the "Insulation" text labels displayed in front view and top view |
| Show Only In Disp Rep Name | String | (empty) | If a display representation name is specified, the hatch display and text labels are only visible when that display representation is active. Leave empty to show insulation graphics in all display representations |

## Right-Click Menu

| Menu Item | Action |
|-----------|--------|
| **Reapply Insulation Sheets** | Forces a complete recalculation and recreation of all insulation sheets. The script deletes all existing insulation sheets tagged with its internal marker, then regenerates them based on the current beam positions, element geometry, and property values. Use this command after modifying beam positions, adding or removing studs, changing openings, or adjusting any insulation parameters |

## Tips

- **Auto-fit thickness**: Set "Insulation Thickness" to 0 to let the script automatically match the full depth of zone 0. This is especially useful when wall cavity depths vary across a project, as the insulation will always fill the entire available space
- **Friction-fit tolerance**: Use the "Decrease width of insulation" and "Decrease height of insulation" parameters with small values (e.g., 2 to 5 mm) to shrink insulation sheets slightly. This ensures batts fit snugly between studs without bowing the framing or being too difficult to install
- **Wall type filtering**: The wall type filter uses the element code property. Separate multiple wall types with semicolons (e.g., `EA;EB;EC;`). If this field contains `EA;EB;` by default, only elements with codes EA or EB will receive insulation. Modify the list to match your project wall type naming convention, or add all relevant codes to insulate multiple wall types in one pass
- **No insulation appeared after insertion**: The most common cause is a mismatch between the "Wall types for this Insulation" property and the actual element code of the selected wall. Open the Properties Panel of the wall element to verify its code, then ensure that code appears in the insulation script's wall type filter list with proper semicolon separators
- **Connection insulation for corner details**: The script automatically detects flat or rotated studs (beams whose depth in the element Z direction is less than their depth in a 30-degree rotated direction). These areas receive the connection insulation product. Configure the "Insulation Name for Connections" with a different product (for example, rigid foam boards) while keeping the main cavities filled with standard mineral wool
- **Minimum dimension filters**: Use "Minimal width/height" (default 20 mm) and "Minimal Thickness" (default 20 mm) to prevent tiny insulation slivers. If your model produces many very small insulation pieces at beam junctions, increase these values to filter them out
- **Avoiding vent areas**: If an hsb_Vent instance or any TSL that publishes a "noinsulation" polyline in its Map is attached to the same element, those areas are automatically excluded from insulation. No manual adjustment is required
- **Stock sizes for BOM**: The stock width, stock length, and stock units properties are exported as two ElemItem entries per element (INSULATION1 for primary, INSULATION2 for connections). These hidden entries appear in hsbCAD bill-of-material reports and can be used for material ordering and cost estimation
- **Display representation filtering**: Use "Show Only In Disp Rep Name" to limit insulation hatch and text display to a specific display representation. This keeps the insulation visualization from cluttering views where it is not needed, such as framing-only views
- **Reapply after geometry changes**: After modifying beam positions, adding blocking, changing openings, or altering element geometry, right-click the insulation instance and select "Reapply Insulation Sheets" to regenerate the insulation. The script also recalculates automatically when the element is reconstructed
- **One instance per element**: The script enforces a single insulation instance per element. If you insert a new instance on an element that already has one, the old instance is automatically erased. For different insulation in different zones, adjust the "Attach Insulation to Zone" property, or consider using the hsbElementInsulation script for more advanced zone and inventory management

## Technical Notes

- **Script Type**: O-Type (Object). The script is not attached to a specific beam but rather to an element. It requires zero beam selections during insertion (`#NumBeamsReq 0`)
- **Implicit Insert**: The script uses `#ImplInsert 1`, allowing it to be launched from the hsbCAD tool palette without requiring an explicit command-line invocation
- **Multi-element insertion**: During insertion, the script accepts a selection set of multiple elements. It then iterates over each element, creates a separate child instance per qualifying element using `tsl.dbCreate()`, and erases the original parent instance. Each child instance operates independently
- **Element assignment**: The script assigns itself to the element group with the configured zone designation and the 'I' (Insulation) category flag via `assignToElementGroup(el, TRUE, nZone, 'I')`
- **Sheet creation**: Insulation pieces are created as `Sheet` entities with material set to "Insulation" and the user-selected product name. Each sheet is tagged with a MapX sub-map (`"Insulation"`) containing an `"Erase"` flag set to true, allowing the script to identify and selectively remove only its own sheets during reapplication without disturbing other sheets in the same zone
- **Zone mapping**: The user-facing zone dropdown values (1 through 10 and 0) are internally mapped to actual zone indices. Values 1 through 5 map directly; values 6 through 10 map to -1 through -5 respectively; value 0 maps to zone 0. The default selection of 10 places insulation into zone -5
- **Beam filtering logic**: Only beams assigned to zone 0 (via `myZoneIndex() == 0`) are considered as obstructions for cavity calculation. Beams with the beam code prefix "CONNECTOR" (case-insensitive) are excluded. Additionally, beams whose projected shadow profile overlaps the element outline by less than 50% of their total area are excluded, filtering out beams that extend beyond the element boundary
- **Opening gap expansion**: For each opening, the script expands the opening profile by the configured gap side, gap top, and gap bottom values from the opening's properties, plus a 5 mm tolerance buffer. This ensures insulation does not encroach into opening framing or trimmer areas
- **Flat stud detection**: Beams are classified as flat (rotated) if their measured depth along the element Z axis (`dD(vz)`) is less than their depth measured along a vector rotated 30 degrees from the X axis around Z (`dD(vxRot)`). These beams are treated separately for connection insulation placement
- **Duplicate TSL removal**: On insertion or recalculation, the script scans all TSL instances attached to the element. Any existing instance of hsb_Insulation (same script name) with a different entity handle is erased, enforcing a one-instance-per-element constraint
- **ElemItem export**: Two hidden ElemItem entries are created per element: INSULATION1 (primary product data) and INSULATION2 (connection product data). Each contains material name, thickness, stock width, stock length, and unit description. These items are set to hidden (`setShow(_kNo)`) and are used for reporting and BOM extraction
- **Execution mode control**: The script uses an internal integer flag `nExecutionMode` stored in `_Map`. Sheet creation only occurs when this flag is set to 1, which happens during initial insert, on `_bOnElementConstructed` events, and when the user triggers the "Reapply Insulation Sheets" context menu command. After sheet creation completes, the flag is reset to 0
- **Catalog support**: The script calls `setPropValuesFromCatalog(_kExecuteKey)` during `_bOnDbCreated` and `_bOnInsert`, enabling property values to be preloaded from a tool palette catalog definition
- **Color index validation**: The hatch color index is validated to the range -1 to 255. Any value outside this range is automatically reset to 171 (a light brown/olive color)
- **Insertion cycle guard**: The script includes `insertCycleCount() > 1` protection to prevent duplicate insertion cycles from creating redundant instances
- **Version history**: Actively maintained from December 2005 (v1.0) through January 2024 (v2.23), with major milestones including connection insulation (v2.6, March 2010), stock size BOM export (v2.9, February 2011), configurable zone assignment (v2.11, August 2011), MapX-based sheet tagging for selective erasure (v2.18, July 2012), zone 0 linking (v2.20, November 2017), flat stud flush stop option (v2.22, December 2023), and plane profile cleanup (v2.23, January 2024)
