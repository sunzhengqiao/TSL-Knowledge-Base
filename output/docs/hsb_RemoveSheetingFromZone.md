# hsb_RemoveSheetingFromZone.mcr

## Overview
This script allows you to selectively remove sheathing (sheeting) from wall elements based on a specific zone index. It is designed to delete specific layers or sections of automatically generated wall cladding (e.g., removing interior sheeting while keeping exterior sheeting) without deleting the structural wall element itself.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Wall Elements. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Modifies construction geometry, not drawing views. |

## Prerequisites
- **Required Entities**: Wall Elements (`ElementWallSF`) that have sheathing/sheets already generated and attached.
- **Minimum Beams**: 0 (Targets wall elements, not beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `hsb_RemoveSheetingFromZone.mcr` from the list.

### Step 2: Select Wall Elements
```
Command Line: Select one or More Elements
Action: Click on the wall elements from which you wish to remove sheathing.
```
You can select multiple walls at once. Press Enter to confirm selection.

### Step 3: Configure Sheeting Zone (Optional)
1.  Immediately after selecting the walls, the script instance is created.
2.  Select the script instance (or ensure it is selected) and open the **Properties Palette** (OPM).
3.  Locate the **Sheet Zone** property.
4.  Select the zone number corresponding to the sheathing layer you want to delete.
    *   **1-5**: Typically correspond to specific zones on the primary side of the wall.
    *   **6-10**: Typically correspond to zones on the opposite side (mapped to negative indices).

### Step 4: Execute Removal
1.  Trigger a model calculation (if manual) or allow the hsbCAD automatic calculation to proceed.
2.  The script will identify all sheets within the specified zone for the selected walls and erase them.
3.  The script instance will automatically delete itself from the drawing once the operation is complete.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sheet Zone | dropdown | 1 | Select the specific sheathing layer to remove. Options 1-10 map to internal wall zones (1 through 5, and -1 through -5). |

## Right-Click Menu Options
None. This script executes based on insertion and property configuration.

## Settings Files
None. This script does not use external settings files.

## Tips
- **Identify Zones First**: If you are unsure which Zone number corresponds to the sheathing you want to remove, check your Wall Element construction setup or generate a test wall to see how sheeting is indexed.
- **Batch Processing**: You can select as many wall elements as needed during the "Select Elements" prompt. The script will process all of them simultaneously.
- **Script Disappears**: Once the script runs successfully, it removes itself from the drawing. This is normal behavior. To remove sheeting from different zones, you must run the script again.

## FAQ
- **Q: The script vanished after I ran it. Did it fail?**
  - A: No. The script is designed to erase itself after it has deleted the target sheathing to keep your drawing clean.
- **Q: I selected Zone 1 but the interior sheeting is still there.**
  - A: The interior sheeting might be assigned to a different zone index (e.g., Zone 6 or Zone 2 depending on your wall configuration). Try selecting a different Zone number and running the script again.
- **Q: Can I undo this?**
  - A: Yes, you can use the standard AutoCAD `UNDO` command to restore the erased sheathing and the script instance.