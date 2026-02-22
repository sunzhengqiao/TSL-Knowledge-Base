# hsbElementInsulation

Calculates and displays insulation material within timber frame elements (walls, roofs, floors) based on zone definitions.

## Overview

This script automatically calculates the insulation area for a selected element by analyzing the zone geometry and existing framing members. It subtracts beam profiles from the zone contour to determine where insulation material can be placed, then generates visual representations and optional sheet entities for quantity takeoff and fabrication.

The insulation calculation considers:
- Element zone thickness and boundaries
- Existing beams, studs, and blocking within the zone
- Openings (doors, windows, roof openings)
- Connected elements at corners (female walls)
- User-defined floor contours for roof/floor elements
- R-value for thermal performance tracking

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O (Object) |
| Beams Required | 0 |
| Model Space | Yes |
| Paper Space | No |
| Version | 3.17 |
| Keywords | insulation, Dammung |

## Prerequisites

1. **Element must exist**: The script requires a wall, roof, or floor element to be present in the drawing
2. **Zone definition**: The target element must have at least one defined zone with measurable thickness
3. **Optional - Inventory database**: For article selection, the hsbInventory database should be configured with insulation materials in the "Ancillary/Insulation" category

## Step-by-Step Usage Guide

### Basic Insertion

1. **Start the command**
   - Type the command to insert hsbElementInsulation or access it via the hsbCAD ribbon/menu

2. **Configure properties in the dialog**
   - Select an Article from inventory (if available) or specify Material/Manufacturer/Thickness manually
   - Choose the target Zone number
   - Set display options (Color, Transparency, Patterns)
   - Click OK

3. **Select element(s)**
   - When prompted "Select element(s)", click on one or more wall/roof/floor elements
   - Press Enter to confirm selection

4. **Optional: Select floor contour polylines**
   - For roof or floor elements, you may be prompted to "Select polyline(s) that define the outer contour"
   - Select polylines if needed, or press Enter to skip

5. **Result**
   - The script creates one insulation instance per selected element
   - Insulation area is calculated and displayed
   - Sheet entities are created if configured

### Adding/Subtracting Areas

After insertion, you can modify the insulation coverage:

1. **Select the insulation instance** in the drawing
2. **Right-click** to open the context menu
3. Choose:
   - **Add Area**: Select polylines to add insulation coverage
   - **Subtract Area**: Select polylines to remove insulation coverage
   - **Select Floor Contour**: Define the outer boundary for roof/floor elements

### Edit Insulation in Place

For fine-tuning individual insulation panels:

1. Right-click the insulation instance
2. Select **Edit Insulation in Place**
3. The script creates separate editable instances for each insulation field
4. Modify grip points to adjust coverage areas

## Properties Panel Parameters

### Insulation Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Article | String (Dropdown) | - | Select insulation article from inventory. When selected, Material, Manufacturer, and Thickness are auto-populated from inventory data. |
| Material | String | - | Material description (e.g., "Mineral Wool", "Cellulose"). Read-only when Article is selected from inventory. |
| Manufacturer | String | - | Supplier/manufacturer name. Read-only when Article is selected from inventory. |
| Thickness | Double | 0 | Insulation thickness in current units. Set to 0 to use full zone thickness. Read-only when Article has defined thickness. |
| Thickness Variable | Dropdown | Default | **Default**: Insulation fills entire zone, including areas with reduced thickness (flat studs). **Rigid**: Insulation only placed where full stock thickness fits, leaving gaps at obstructions. |
| Tolerance | String | "0" | Gap value applied around insulation edges. Applied only to vertical edges (left and right) in element view. |
| R-Value | String | - | Thermal resistance value (rate of heat flow reduction). Written to the "grade" property of generated insulation sheets. |

### General Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone | Integer (Dropdown) | - | Target zone number (-5 to +5). Only zones with defined thickness are available. |
| Alignment | Dropdown | disabled | Distribution pattern: **disabled** (single piece), **horizontal** (horizontal strips), **vertical** (vertical strips). Requires inventory items with length/width dimensions. |
| Color | Integer | 41 | AutoCAD color index for display (1-255). |
| Transparency | Integer | 0 | Transparency percentage for solid fill (0-99). 0 = opaque, higher = more transparent. |

### Element View Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Pattern | Dropdown | disabled | Hatch pattern for element (section) view. Options include SOLID, standard hatch patterns, or "disabled". |
| Pattern Scale | Double | 1 | Scale factor for the selected hatch pattern. |

### Plan View Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Pattern | Dropdown | disabled | Hatch pattern for plan (top) view. Options include SOLID, standard hatch patterns, or "disabled". |
| Pattern Scale | Double | 1 | Scale factor for the selected hatch pattern. |

### Painter Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Walls | Dropdown | Disabled | Painter definition filter to exclude specific beams from insulation calculation. Select from available "hsbElementInsulation" painter definitions. Supported types: Element, ElementWall, ElementWallStickFrame, ElementRoof. |

### Instance Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Delete Instance | Yes/No | No | When set to "Yes", the TSL instance is deleted after creating insulation sheets, leaving only the sheet entities. |

### Wall-Specific Parameter (Hidden for Roofs/Floors)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Height | Double | 0 | Limits the vertical extent of insulation from the wall floor outline. Set to 0 for complete height coverage. Only visible for wall elements. Useful for limiting insulation below certain heights (e.g., below ribbon windows). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Select Floor Contour** | Select polylines to define the outer boundary for roof/floor element insulation. Polylines are projected onto the element plane. |
| **Subtract Area** | Select closed polylines to exclude areas from insulation coverage. Useful for equipment zones or service areas. Double-click also triggers this function. |
| **Add Area** | Select closed polylines to include additional areas in insulation coverage. |
| **Edit Insulation in Place** | Breaks the insulation into individual editable panels with grip points for fine adjustment. |
| **Erase Insulation Sheeting** | Removes all generated insulation sheet entities while keeping the TSL instance. |
| **Edit Inventory** | Opens the hsbInventory editor dialog for managing insulation articles. Only visible if hsbLooseMaterialsUI.dll is available. |
| **Database on/off** | Toggles reading insulation articles from the inventory database. Shows "Database on" when active, "Database off" when disabled. Useful when inventory is not needed. |
| **Import Settings** | Loads settings from the XML configuration file in the Company TSL/Settings folder. Only visible if settings file exists. |
| **Export Settings** | Saves current settings to the XML configuration file. Prompts for confirmation if file exists. |

## Settings Files

### File Location

Settings are loaded from (in order of priority):
1. **Company path**: `[Company]\TSL\Settings\hsbElementInsulation.xml`
2. **Installation path**: `[Install]\Content\General\TSL\Settings\hsbElementInsulation.xml`

### XML Structure

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
    <lst nm="Inventory">
        <str nm="MinorGroup" vl=""/>  <!-- Inventory minor group filter -->
        <str nm="MajorGroup" vl=""/>  <!-- Inventory major group filter -->
        <int nm="ReadDatabase" vl="1"/>  <!-- 1 = read from DB, 0 = skip DB -->
    </lst>
    <lst nm="Group">
        <str nm="ObjectName" vl=""/>  <!-- Group name for organizing instances -->
    </lst>
    <lst nm="Pattern[]">
        <lst nm="Pattern">
            <str nm="Name" vl="Default"/>
            <lst nm="Wall">
                <str nm="Code" vl="*"/>  <!-- Wall codes: * for all, or specific codes like "F;A;EA" -->
            </lst>
            <int nm="CreateSheet" vl="1"/>  <!-- 1 = create sheets, 0 = display only -->
            <dbl nm="MinWidthHeight" ut="L" vl="0"/>  <!-- Minimum insulation piece size -->
            <int nm="SheetColor" vl="-3"/>  <!-- Sheet color: -3=use property color, -2=by zone, 1-255=ACI -->
            <lst nm="ZoneMapping[]">
                <lst nm="ZoneMapping">
                    <int nm="GeometricZone" vl="0"/>
                    <int nm="AssigningZone" vl="0"/>
                </lst>
            </lst>
        </lst>
    </lst>
    <lst nm="GeneralMapObject">
        <int nm="Version" vl="1"/>
    </lst>
    <unit ut="L" uv="millimeter"/>
</Hsb_Map>
```

### Key Settings

| Setting | Description |
|---------|-------------|
| `Inventory/MajorGroup` | Filter articles by major group (default: "Ancillary") |
| `Inventory/MinorGroup` | Filter articles by minor group (default: "Insulation") |
| `Inventory/ReadDatabase` | Set to 1 to read from inventory database, 0 to skip |
| `Pattern/Wall/Code` | Wall codes where this pattern applies. Use "*" for all walls, or specific codes separated by semicolons. |
| `CreateSheet` | Set to 1 to generate Sheet entities for quantity takeoff |
| `MinWidthHeight` | Minimum dimension for insulation pieces (filters out small gaps) |
| `SheetColor` | Color for generated sheets: -3=use property color, -2=by zone color, positive=ACI color |
| `ZoneMapping` | Maps geometric zones to different assignment zones (for special cases) |
| `Group/ObjectName` | Custom group name for organizing insulation instances |

## Tips

1. **Multiple layers**: Insert one TSL instance per insulation layer. The script automatically stacks multiple layers within the same zone by tracking layer positions.

2. **Inventory integration**: Configure your insulation products in hsbInventory under "Ancillary/Insulation" for quick selection and automatic property population.

3. **Visual verification**: Use the Transparency property to see through the insulation display and verify coverage against the framing.

4. **Roof/Floor elements**: For roof and floor elements without inner beam rings, select polylines to define the floor contour boundary.

5. **Custom exclusions**: Draw polylines around areas (HVAC ducts, service chases) and use "Subtract Area" to exclude them from insulation.

6. **Wall code filtering**: Use the settings XML to define different insulation patterns for different wall types (exterior vs. interior, fire-rated, etc.).

7. **Rigid vs Default strategy**:
   - Use **Default** for flexible insulation (mineral wool, cellulose) that compresses around obstructions
   - Use **Rigid** for board insulation (foam, wood fiber) that requires precise fit

8. **Painter filters**: Create painter definitions starting with "hsbElementInsulation\" to filter which walls receive insulation based on custom criteria.

9. **Height limitation**: For walls, use the Height parameter to limit insulation to a specific height (e.g., below windows).

10. **R-value tracking**: Enter the R-value to have it written to the insulation sheet's grade property for thermal calculations and reports.

## FAQ

**Q: Why is no insulation displayed?**
A: Check that the selected zone has defined thickness and contains beams. The script requires at least one beam in the zone to calculate the insulation boundary. Verify the zone number in the Properties panel.

**Q: How do I change the insulation thickness after insertion?**
A: Select the insulation instance, open the Properties panel, and modify the Thickness value. If an Article with fixed thickness is selected, you must either choose a different article or switch to manual entry.

**Q: Can I use different insulation types in the same element?**
A: Yes, insert multiple TSL instances with different zone numbers or materials. Each instance handles one layer.

**Q: Why are some small areas not insulated?**
A: The script filters out very small gaps by default. Check the MinWidthHeight setting in the XML configuration or adjust the Tolerance property.

**Q: How do I remove the insulation sheets but keep the display?**
A: Right-click the instance and select "Erase Insulation Sheeting". The visual display remains but sheets are deleted.

**Q: Why does the Article dropdown show no items?**
A: Verify that the hsbInventory database exists and contains items in the "Ancillary/Insulation" category (or the categories specified in the settings XML). Also check that hsbLooseMaterialsUI.dll is available.

**Q: How do I update insulation when the element changes?**
A: The TSL instance automatically recalculates when the referenced element is modified. If needed, manually regenerate by selecting the instance and pressing Enter.

**Q: Can I control which walls get insulation automatically?**
A: Yes, use the Painter filter property to apply insulation only to walls matching specific painter definitions. Also configure the Pattern/Wall/Code in the settings XML for wall code filtering.

**Q: What is the Height parameter used for?**
A: The Height parameter (available for wall elements only) limits the vertical extent of insulation from the wall floor outline. Set to 0 for complete height coverage. This is useful when you want insulation only up to a certain height, such as below a ribbon window.

**Q: How does the script handle corner connections?**
A: The script automatically detects connected "female" walls at corners and excludes their intersection area from the insulation calculation to prevent overlapping material.

**Q: Why is tolerance only applied to vertical edges?**
A: The tolerance (gap) is designed to prevent insulation from touching studs at the sides. It is not applied to top and bottom edges to ensure complete vertical coverage.

**Q: What does the R-value do?**
A: The R-value represents the thermal resistance of the insulation. When entered, this value is written to the "grade" property of each generated insulation sheet, enabling thermal performance tracking in reports and calculations.

## Technical Notes

### Baufritz-Specific Behavior

For projects named "BAUFRITZ", the script includes special handling:
- Zone 0 insulation with "Hobelspane" material is excluded for wall codes M, N, O, P, H, I
- "Holzweichfaser Zone 2" material is excluded in Zone 2 for wall codes F, G, J, K, L, M, N, O, P, H, I
- Newly inserted instances at the same zone automatically replace existing instances
- Zone 6 sheets are considered as additional contour for insulation calculation
- Insulation groups are kept separate from element groups

### Sheet Entity Properties

When insulation sheets are created, the following properties are set:
- **Material**: From the Material property
- **Name**: From the Article property (if specified)
- **Information**: From the Manufacturer property
- **Label**: "InsulationSheet"
- **Color**: Based on SheetColor setting (-2 = zone color, -3 = property color, positive = ACI)
- **Grade**: R-value (if specified)
- **Zone Assignment**: Based on ZoneMapping or current zone

### Hardware Components

The script creates hardware components for each insulation piece with:
- Article number as component name
- Manufacturer, description, material from properties
- Zone number in notes
- Dimensions (X, Y scale from profile, Z from thickness)
- Area in offset (m2)
