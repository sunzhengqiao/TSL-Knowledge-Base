# StackEntity.mcr

## Overview

| Property | Value |
|----------|-------|
| **Script Type** | Object (O) |
| **Version** | 3.2 |
| **Last Updated** | 12.02.2025 |
| **Authors** | Thorsten Huck, Marsel Nakuci |
| **Required Beams** | 0 |
| **Category** | Logistics / Transport Planning |

**Purpose**: This script creates and manages a truck definition entity for logistics planning. It provides 3D visualization of truck loading areas, calculates weight distribution and axle loads, manages stacking layers for timber packages, and validates dimensions against truck configurations.

---

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| **Model Space** | Yes | Primary workspace for 3D truck visualization |
| **Paper Space** | Limited | Display only; not intended for editing |
| **Shop Drawing** | Yes | Integrates with PainterDefinitions for documentation |

---

## Prerequisites

- **Required entities**: None (inserts as standalone entity)
- **Minimum beam count**: 0
- **Related scripts**: StackItem, StackPack, StackAxle (created automatically as children)
- **Required files**: `TslUtilities.dll` for dialog services
- **Optional**: TruckDefinition styles stored in the drawing database

---

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Select: StackEntity
```

### Step 2: Pick Insertion Point
```
Command Line: Pick insertion point.
Action: Click in Model Space to place the truck base location.
```

**Note**: If no truck definitions exist, the script displays a warning message and prompts you to create a definition using the "Edit Definition" context menu.

### Step 3: Configure Truck (Optional)
After insertion, use the Properties Palette or right-click context menu to:
- Select a Truck Definition style
- Adjust dimensions, weights, and display settings
- Add or remove stacked items

---

## Properties Panel Parameters

### General Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Description** | String | "" | Descriptive name for this truck load (e.g., "Delivery to Site A") |
| **Delivery** | String | "" | Delivery information or destination |
| **Number** | Integer | 0 | Unique truck number for identification. Set to 0 for automatic numbering. Duplicate numbers are automatically renumbered. |
| **Definition** | String | "" | Select from available TruckDefinition styles. Defines truck dimensions and load profiles. |

### Display Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **DimStyle** | String | First available | Dimension style for text display |
| **Text Height** | Double | 200 mm | Height of text in the tag. Set to 0 to use DimStyle default. |
| **Format** | String | "@(Description:D) @(Number:D)\n@(Delivery:D)" | Format template for the tag display. Supports placeholders: @(Description:D), @(Number:D), @(Delivery:D), @(Weight), @(Volume), @(QuantityItems), @(QuantityPacks) |

### Load Definition Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Tara** | Double | 0 kg | Unladen weight (curb weight) of the truck in kilograms. Used to calculate net cargo capacity. |
| **Gross Weight** | Double | 0 kg | Maximum legally permissible total weight (Truck + Cargo) in kilograms. |

---

## Format Placeholders

The **Format** property supports the following placeholders for dynamic text generation:

| Placeholder | Description |
|-------------|-------------|
| `@(Description:D)` | Description property value |
| `@(Number:D)` | Truck number |
| `@(Delivery:D)` | Delivery information |
| `@(Weight)` | Total weight of loaded items (kg) |
| `@(Volume)` | Total volume of loaded items (m3) |
| `@(QuantityItems)` | Number of individual items |
| `@(QuantityPacks)` | Number of packages |
| `@(QuantityItemPacks)` | Total count of items + packages |
| `@(LoadLength)` | Actual load length (mm) |
| `@(LoadWidth)` | Actual load width (mm) |
| `@(LoadHeight)` | Actual load height (mm) |
| `@(COG)` | Center of gravity coordinates |

**Example Format String:**
```
@(Description:D) - Truck #@(Number:D)
Weight: @(Weight) kg | Volume: @(Volume) m3
```

---

## Right-Click Context Menu Options

### In Normal Mode

| Menu Item | Description |
|-----------|-------------|
| **Edit Definition** | Opens the Truck Definition editor dialog. Allows creating or modifying truck dimensions, load profiles, and display settings. |
| **Add Items** | Opens selection dialog to add StackItem or StackPack entities to this truck. Selected items are attached and can be repositioned. |
| **Remove Items** | Opens selection dialog to remove items from this truck. Removed items can be placed at a new location. |
| **Settings** | Opens display settings dialog for configuring color rules (byLayer, byPackNumber, byStackLayer). |
| **Asynchronous/Synchronous Oversize Width** | Toggles whether left and right width oversizes adjust independently (Asynchronous) or together (Synchronous). |
| **Import Settings** | Loads truck configuration from an XML file at `%CompanyPath%\TSL\Settings\StackEntity.xml`. |
| **Export Settings** | Saves current settings to an XML file for reuse. |

### In Edit Definition Mode

| Menu Item | Description |
|-----------|-------------|
| **Save Definition** | Saves the current truck configuration to the TruckDefinition database. |
| **Add Load Profile** | Adds a new load profile rectangle by picking points or selecting existing polylines. |
| **Set truck display** | Select body entities to define the custom graphical representation of the truck. |

---

## Grip Points

The StackEntity provides interactive grip points for visual adjustment:

| Grip | Color | Description |
|------|-------|-------------|
| **Location** | Red circle | Moves the entire stack and all associated packs and items. Drag to reposition the truck. |
| **Tag** | Green circle | Adjusts the position of the information tag. Only visible when Format is not empty. |
| **Oversize X+** | Yellow arrow | Adjusts allowed oversize in the +X direction. |
| **Oversize X-** | Yellow arrow | Adjusts allowed oversize in the -X direction. |
| **Oversize Y+** | Yellow arrow | Adjusts allowed oversize in the +Y direction (left side). |
| **Oversize Y-** | Yellow arrow | Adjusts allowed oversize in the -Y direction (right side). |
| **Oversize Z+** | Yellow arrow | Adjusts allowed oversize in the +Z direction (height). |

**Oversize Behavior**:
- When **Synchronous Oversize Width** is enabled: Moving the Y+ grip also moves Y- and vice versa.
- When **Asynchronous Oversize Width** is enabled: Each side adjusts independently.

---

## Stacking Layers

The StackEntity automatically organizes loaded items into stacking layers:

- **Layer Index**: The main stacking sequence number (1, 2, 3...)
- **Sub-Index**: Position within each layer (1.1, 1.2, 2.1, 2.2...)

Layer information is stored in each child item's Map data:
- `LayerIndexStack`: Main layer number
- `LayerSubIndexStack`: Sub-position within layer

### Color Rules

Items can be colored according to different rules (configured via **Settings**):

| Rule | Description |
|------|-------------|
| **byLayer** | Items retain their original layer colors |
| **byPackNumber** | Items are colored by package number |
| **byStackLayer** | Items are colored by their stacking layer position |

---

## Axle Load Calculation

The StackEntity calculates axle load distribution based on:
- Total loaded weight
- Center of Gravity (COG) position
- Axle positions (read from StackAxle child)

**Note**: Axle load calculation requires a StackAxle child entity attached to the StackEntity. The StackAxle is automatically created when inserting a new StackEntity.

---

## Data Export and Formatting

The StackEntity stores the following data in its subMapX for use in reports and drawings:

| Key | Type | Description |
|-----|------|-------------|
| `QuantityItems` | Integer | Number of StackItem children |
| `QuantityPacks` | Integer | Number of StackPack children |
| `QuantityItemPacks` | Integer | Total children count |
| `Weight` | Double | Total weight in kg |
| `Volume` | Double | Total volume in m3 |
| `COG` | Point3d | Center of gravity coordinates |
| `LoadLength` | Double | Actual load extent in X (mm) |
| `LoadWidth` | Double | Actual load extent in Y (mm) |
| `LoadHeight` | Double | Actual load extent in Z (mm) |
| `Description` | String | Description text |
| `Item[]` | Entity array | References to child StackItems |

---

## Settings Files

| Setting | Location |
|---------|----------|
| **User Settings** | `%CompanyPath%\TSL\Settings\StackEntity.xml` |
| **Default Settings** | `%InstallPath%\Content\General\TSL\Settings\StackEntity.xml` |

Settings include:
- ColorRule selection
- Custom display preferences

---

## Related Scripts

| Script | Relationship |
|--------|--------------|
| **StackItem** | Child entity representing individual stacked elements (beams, panels) |
| **StackPack** | Child entity representing grouped packages of items |
| **StackAxle** | Child entity defining axle positions for weight distribution |
| **TruckDefinition** | Database entry storing truck dimension styles |

---

## PainterDefinitions

The StackEntity creates and uses the following PainterDefinitions for shop drawings:

| Painter Name | Filter | Purpose |
|--------------|--------|---------|
| **Stacks** | `ScriptName = 'StackItem'` | Display stacked items |
| **Packages** | `ScriptName = 'StackPack'` | Display packages |
| **Items + Packages** | Combined filter | Display both items and packages |
| **Spacer** | `ScriptName = 'StackSpacer'` | Display spacers |
| **Show Set** | All stack-related scripts | Display complete stack set |
| **Selection Set** | `ScriptName = 'StackEntity'` | Display truck entities only |

PainterDefinitions are located at: `Shopdrawing\Stacking\`

---

## Tips and Best Practices

### Weight Management
- Set **Tara** accurately to get correct net cargo calculations
- Monitor total weight against **Gross Weight** to avoid overloading
- Use the COG visualization to balance loads across axles

### Organization
- Use meaningful **Description** values for easy identification in lists
- Let the script auto-number by setting **Number** to 0
- Use consistent **Format** templates across your project

### Workflow
1. Create or select a TruckDefinition first
2. Insert the StackEntity at the desired location
3. Use **Add Items** to attach StackItems or StackPacks
4. Drag items or use the Location grip to adjust positions
5. Check weight/volume in the tag display

### Troubleshooting

| Issue | Solution |
|-------|----------|
| "No truck definitions found" message | Use **Edit Definition** to create a new TruckDefinition, or import one |
| Items not appearing in stack | Ensure items are StackItem or StackPack scripts; use **Add Items** to attach |
| Tag not visible | Check that **Format** property is not empty; adjust **Text Height** |
| Duplicate numbers | The script auto-renumbers; check the command line for renumber messages |
| Oversize grips not visible | Oversize grips appear when items extend beyond the base truck dimensions |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 3.2 | 12.02.2025 | Full support for new controlling properties behavior |
| 3.1 | 10.01.2025 | Added axle load calculation |
| 3.0 | 22.11.2024 | Supports relocation of attached spacers when moved |
| 2.9 | 24.09.2024 | Improved element references |
| 2.8 | 17.09.2024 | Debug messages removed |
| 2.7 | 06.09.2024 | Tag visible in model view |
| 2.6 | 22.08.2024 | Settings introduced for custom color coding |
| 2.5 | 16.08.2024 | Improved jigging items |
| 2.4 | 26.07.2024 | Z-load dimension from base point; bugfix for insert without definitions |
| 2.3 | 16.07.2024 | Load dimensions exposed: @(LoadLength), @(LoadWidth), @(LoadHeight) |
| 2.2 | 25.06.2024 | Oversizes and load dimensions prepared |
| 2.1 | 27.02.2024 | Added 'Number' property for unique identification |
| 2.0 | 21.12.2023 | Improved wireframe display; format property and tag grips |
| 1.4 | 18.10.2023 | First beta release |

---

## See Also

- [StackItem.md](StackItem.md) - Individual item stacking
- [StackPack.md](StackPack.md) - Package grouping
- [StackAxle.md](StackAxle.md) - Axle position definition
- [f_Truck.md](f_Truck.md) - Truck-related formatting utilities
