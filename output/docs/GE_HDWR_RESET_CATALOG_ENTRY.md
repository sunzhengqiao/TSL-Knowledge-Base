# GE_HDWR_RESET_CATALOG_ENTRY.mcr

## Overview
This utility clears the saved configuration for a specific hardware family from the central catalog file. It is used to force the system to prompt for a new data source file (e.g., a new manufacturer list) the next time you insert that hardware component.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs in Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities:** None (Optional: Select an existing hardware instance to auto-populate data).
- **Minimum Beam Count:** 0
- **Required Settings Files:** `TSL_HARDWARE_FAMILY_LIST.dxx` (The catalog file to be modified).

## Usage Steps

### Step 1: Launch Script
Execute the script using the standard hsbCAD insert command.
**Command:** `TSLINSERT` (or your company's custom script insertion alias) → Select `GE_HDWR_RESET_CATALOG_ENTRY.mcr`.

### Step 2: Select Hardware or Enter Manual Mode
The script will prompt you to identify the hardware family to reset.
```
Command Line: Select hardware TSL to reset or hit ENTER to manually set values
Action:
    Option A: Click on an existing hardware TSL instance in your model.
    Option B: Press ENTER to input the details manually.
```

### Step 3: Provide Family Details (If Manual Mode Selected)
If you selected an entity in Step 2, skip this step. If you pressed ENTER, provide the following details when prompted:

```
Command Line: Family Name
Action: Type the exact name of the hardware family (e.g., "HANGER_SIMPSON").
```

```
Command Line: Catalog File Path
Action: Type the folder path where the catalog file is located (e.g., "C:\Project\TSL_Data\").
Note: The script looks for TSL_HARDWARE_FAMILY_LIST.dxx in this folder.
```

### Step 4: Review Result
The script will process the request and report the result on the command line.
- **Success:** "Key found in catalog. RESET SUCCESS."
- **Failure:** "Key NOT found in catalog." (Check spelling or file path).

**Note:** The script instance will automatically erase itself from the drawing immediately after running.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This is a transient utility script. It does not have persistent properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script runs once and erases itself; it does not have a right-click menu. |

## Settings Files
- **Filename:** `TSL_HARDWARE_FAMILY_LIST.dxx`
- **Location:** Derived from the selected entity's attribute 'HSBCOMPANY_TSL_CATALOG_PATH' or entered manually by the user.
- **Purpose:** Stores the links between hardware family names and their specific data source files (TXT/DXF). This script deletes the specific entry for the family you wish to reset.

## Tips
- **Use Selection Mode:** To avoid typing errors, always select an existing hardware instance in the model rather than typing the Family Name manually.
- **Use Case:** Use this script when you need to switch a hardware family to a completely different manufacturer's file (e.g., pointing all "HANGER" elements to a new price list).
- **Permissions:** Ensure you have write permissions to the folder containing the `TSL_HARDWARE_FAMILY_LIST.dxx` file, or the script will fail to update the catalog.

## FAQ
- **Q: Why did the script say "Key NOT found in catalog"?**
- **A:** This means the Family Name you typed does not exist in the specified DXX file. Check your spelling (it is case-insensitive) and verify that the file path points to the correct project catalog.
  
- **Q: Does this delete the physical hardware objects in my drawing?**
- **A:** No. It only deletes the *configuration link* in the catalog file. Existing hardware in the model remains unchanged, but future insertions of that family will ask you to select a source file again.

- **Q: Can I undo the changes made by this script?**
- **A:** No. The script permanently modifies the external DXX catalog file immediately upon execution.