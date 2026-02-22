# HSB_G-AttachMapXAsPropSet

## Overview

| Property | Value |
|----------|-------|
| Script Name | HSB_G-AttachMapXAsPropSet |
| Type | Object (O-Type) |
| Version | 1.02 |
| Category | Data Management / Property Sets |
| Last Modified | 12.11.2019 |
| Author | Robert Pol (robert.pol@hsbcad.com) |
| Beams Required | 0 |
| Implicit Insert | Yes |

**HSB_G-AttachMapXAsPropSet** is a one-shot utility script that reads MapX metadata stored internally on drawing entities and converts that metadata into AutoCAD Property Sets. Property Sets are a standard AutoCAD mechanism for attaching custom structured data to objects. Once created, they become visible in the AutoCAD Properties Palette, can be included in Schedule Tables, and can be exported to external formats such as IFC or BOM spreadsheets.

In the hsbCAD ecosystem, many scripts and processes attach MapX key-value data to beams, panels, elements, sheets, and other entities during modeling and manufacturing workflows. While MapX data is powerful for inter-script communication, it is invisible to standard AutoCAD tools and cannot be scheduled or reported on directly. This script bridges that gap by transforming hidden MapX data into fully accessible Property Sets that integrate with the broader AutoCAD data model.

The script operates as a fire-and-forget tool: it processes the selected entities, creates and populates the Property Sets, and then erases itself from the drawing. No permanent TSL instance remains after execution.

## Usage Environment

| Environment | Supported | Notes |
|-------------|-----------|-------|
| Model Space | Yes | Primary use case for converting MapX data on 3D model entities |
| Paper Space | Yes | Can process entities in paper space viewports |
| Shop Drawing | Yes | Useful for attaching property data to shop drawing entities |

This script operates wherever entities with MapX data exist. Because it is an Object-type script with zero beam requirements, it is not tied to any specific beam or element and can be used freely in any drawing context.

## Prerequisites

Before running this script, ensure the following conditions are met:

1. **Entities with MapX Data**: At least one entity in the drawing must contain MapX metadata. MapX data is typically created by other TSL scripts during modeling workflows (for example, manufacturing information, material properties, scheduling data, or custom attributes).

2. **Entity Selection Access**: The entities you want to process must be selectable in the current drawing state. Entities on locked layers or in frozen viewports cannot be selected.

3. **hsbCAD Installation**: A working hsbCAD installation is required, as the script relies on hsbCAD-specific API functions for MapX access and Property Set creation.

4. **No Special Settings Files**: This script does not require any XML configuration files, settings directories, or external resources. It works entirely from the data already present on the selected entities.

## Usage Steps

### Step 1: Launch the Script

Insert the script using any of the standard hsbCAD methods:

- **TSL Library Browser**: Navigate to the script library, locate `HSB_G-AttachMapXAsPropSet`, and double-click to insert.
- **Command Line**: Type `TSLINSERT` and press Enter, then browse to or type `HSB_G-AttachMapXAsPropSet.mcr`.
- **Ribbon/Toolbar**: If configured in your workspace, use the assigned toolbar button.

Because the script has the **Implicit Insert** flag set, it begins execution immediately upon insertion without requiring a placement point.

### Step 2: Select Entities

After launching, the command line displays the following prompt:

```
Select one or more entities
```

**Action**: Click on the entities in the drawing that contain MapX data you want to convert to Property Sets. You can:

- **Click individual entities** one at a time.
- **Use a window or crossing selection** to select multiple entities at once.
- **Press Enter** when you have finished selecting to confirm the selection and proceed.

If you accidentally start the script a second time (double-click or repeated command), the script detects the duplicate insertion cycle and automatically erases the extra instance without processing.

### Step 3: Automatic Processing

Once you confirm the selection, the script processes each selected entity automatically. For every entity, it:

1. **Retrieves all MapX keys** stored on the entity.
2. **Iterates through each MapX key** and reads the associated Map data.
3. **Checks for nested Maps**: If any entry within a MapX key contains a sub-Map (a Map nested inside another Map), the script handles it specially:
   - Creates a separate Property Set for the nested Map.
   - Names the Property Set using dot notation: `ParentKey.ChildKey` (for example, if the parent MapX key is `Manufacturing` and the nested Map key is `Dimensions`, the resulting Property Set is named `Manufacturing.Dimensions`).
   - Removes the nested Map entry from the parent to prevent duplicate data.
4. **Creates Property Set Definitions** if they do not already exist. The script checks the list of available Property Set definitions in the drawing before creating new ones, avoiding duplicates.
5. **Attaches Property Sets** to the entity. Even if the definition already exists, the script ensures the Property Set is attached to the current entity.
6. **Populates Property Set values** from the MapX data, transferring all key-value pairs from the Map into the corresponding Property Set fields.

### Step 4: Completion and Self-Removal

After all selected entities have been processed, the script automatically erases itself from the drawing. You will not see any residual TSL instance in the drawing after execution.

No confirmation dialog is shown. The script completes silently. To verify results, proceed to inspect the processed entities (see Tips section below).

### What Happens If No Entities Are Selected

If you press Enter without selecting any entities, or if the selection set is empty, the script displays the following notice in the command line:

```
No entitie selected.
```

The script then erases itself without making any changes to the drawing.

## Properties Panel Parameters

This script does not define any Properties Panel (OPM) parameters. It is a one-shot processing tool that operates entirely through the entity selection prompt at insertion time.

Because the script erases itself after execution, there is no persistent instance whose properties could be edited in the Properties Palette.

## Right-Click Menu

This script does not register any right-click context menu options. It has no persistent instance that would support context menu interaction.

## Settings

This script does not use any external settings files. It does not read from XML configuration files in the `_kPathHsbCompany` or `_kPathHsbInstall` Settings directories.

All behavior is determined entirely by the MapX data present on the selected entities. There are no configurable options, preferences, or modes to adjust.

## Tips

### Verifying the Results

After running the script, select one of the processed entities and open the **AutoCAD Properties Palette** (press `Ctrl+1` or use the `PROPERTIES` command). Scroll through the property categories to find the newly created Property Sets. They will appear as additional property groups, named according to the original MapX keys.

### Batch Processing Multiple Entities

You can select as many entities as needed in a single operation. The script iterates through all selected entities and processes each one individually. This is much more efficient than running the script repeatedly for individual entities.

### Understanding the Dot Notation for Nested Data

When the script encounters nested Maps within a MapX key, it creates separate Property Sets with dot-separated names. For example:

| MapX Structure | Resulting Property Set Name |
|----------------|----------------------------|
| `Manufacturing` (top-level key) | `Manufacturing` |
| `Manufacturing` > `CNC` (nested Map) | `Manufacturing.CNC` |
| `Manufacturing` > `Material` (nested Map) | `Manufacturing.Material` |

This hierarchical naming allows you to identify the origin and relationship of Property Sets at a glance.

### Using Property Sets with Schedule Tables

Once Property Sets are attached, you can create AutoCAD **Schedule Tables** (also known as Property Data Tables) that reference these properties. This enables you to:

- Generate material lists and bills of materials.
- Create quantity takeoffs based on MapX-derived data.
- Produce custom reports that include data previously hidden in MapX.

### Using Property Sets for IFC Export

Property Sets created by this script are compatible with IFC export workflows. When exporting to IFC format, these Property Sets can be mapped to IFC Property Sets, ensuring that the metadata travels with the model into downstream applications (structural analysis, project management, etc.).

### Backup Before Running

Because the script removes nested Map entries from the parent MapX data after converting them to Property Sets, consider saving your drawing before running the script. While the data is preserved in the Property Sets, the original MapX structure is modified. If you need to restore the original MapX layout, you would need to revert to the saved drawing.

### Running on Entities Without MapX Data

If you select entities that have no MapX data attached, the script simply skips them without error. No Property Sets are created for entities with empty MapX, and the script still erases itself normally.

### Re-Running on Already Processed Entities

If you run the script again on entities that have already been processed:

- **Existing Property Set definitions are not duplicated**. The script checks for existing definitions and skips creation if a matching name is found.
- **Property Set values are updated**. The script populates values regardless of whether the Property Set was newly created or already existed, so values are refreshed from the current MapX data.
- **Nested Maps that were previously removed** will not be present in a second run (they were removed during the first run), so only top-level MapX data is reprocessed.

## Technical Notes

### Script Type and Lifecycle

- **O-Type (Object)**: This script operates as a standalone object, not attached to any specific beam or element.
- **Implicit Insert**: The `#ImplInsert 1` flag means the script begins execution immediately upon insertion, without requiring the user to place it at a specific point.
- **Self-Erasing**: The script calls `eraseInstance()` at the end of execution (and in all early-exit code paths), ensuring no residual TSL instance remains in the drawing.
- **Insert Cycle Guard**: The script checks `insertCycleCount() > 1` to prevent duplicate execution if the user accidentally triggers multiple insertions.

### MapX to Property Set Conversion Logic

The conversion follows this algorithm for each selected entity:

1. Call `entity.subMapXKeys()` to get all top-level MapX key names.
2. For each key, retrieve the Map via `entity.subMapX(mapXKey)`.
3. Iterate through the Map entries. For each entry that is itself a Map (`mapx.hasMap(index2)`):
   a. Extract the nested Map and construct a dot-notation name (`ParentKey.ChildKey`).
   b. Check `entity.availablePropSetNames()` for an existing definition with that name.
   c. If no definition exists, create one via `entity.createPropSetDefinition(name, map, true)`.
   d. Attach the Property Set via `entity.attachPropSet(name)`.
   e. Populate values via `entity.setAttachedPropSetFromMap(name, subMap)`.
   f. Remove the nested Map entry from the parent (`mapx.removeAt(index2, true)`) and decrement the loop index.
4. After processing all nested Maps, process the remaining (non-nested) entries in the parent Map using the same create-attach-populate pattern.

### Key API Functions Used

| Function | Purpose |
|----------|---------|
| `entity.subMapXKeys()` | Returns an array of all MapX key names on the entity |
| `entity.subMapX(key)` | Returns the Map associated with a specific MapX key |
| `mapx.hasMap(index)` | Checks if the entry at the given index is a nested Map |
| `mapx.getMap(index)` | Retrieves the nested Map at the given index |
| `subMapX.getMapKey()` | Returns the key name of a nested Map entry |
| `entity.availablePropSetNames()` | Returns all Property Set definition names available in the drawing |
| `entity.createPropSetDefinition(name, map, bool)` | Creates a new Property Set definition from a Map |
| `entity.attachPropSet(name)` | Attaches a Property Set to the entity |
| `entity.setAttachedPropSetFromMap(name, map)` | Populates Property Set values from a Map |
| `mapx.removeAt(index, bool)` | Removes an entry from the Map at the specified index |
| `eraseInstance()` | Removes the TSL instance from the drawing |
| `insertCycleCount()` | Returns how many times the insertion cycle has run (guards against duplicates) |

### Translation Keys

The script uses the following translation keys:

| Key | English Text | Context |
|-----|-------------|---------|
| `\|Select one or more entities\|` | Select one or more entities | Command line prompt for entity selection |
| `\|No entitie selected.\|` | No entitie selected. | Notice displayed when selection is empty |

Note: The text "No entitie selected." contains a legacy typo ("entitie" instead of "entity"). This matches the original script source.

### Unit System

The MapX section of the script file specifies millimeter as the length unit and radian as the angle unit. However, this script does not perform any geometric calculations or unit conversions during execution. The unit settings are part of the standard TSL file metadata but do not affect the script's behavior.

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.00 | 28.08.2019 | RP | First revision - basic MapX to Property Set conversion |
| 1.01 | 30.08.2019 | RP | Added check to avoid creating duplicate Property Set definitions |
| 1.02 | 12.11.2019 | RP | Added support for nested Maps as separate Property Sets with dot notation naming |

## Related Scripts

- **MapX-producing scripts**: Any TSL script that writes MapX data to entities (manufacturing tools, material assignment scripts, scheduling utilities) creates the data that this script converts.
- **HSB_G-BillOfMaterial**: Bill of Material generation scripts that may read Property Set data created by this script.
- **HSB_G-PropertyMapping**: Property mapping utilities that work with entity metadata in similar ways.
- **HSB_G-EntityInformation**: Entity information scripts that display and manage entity properties.
- **Schedule Table scripts**: AutoCAD Schedule Table workflows that reference Property Sets for reporting and quantity takeoffs.
- **IFC Export tools**: Export workflows that map Property Sets to IFC data for interoperability with external applications.
