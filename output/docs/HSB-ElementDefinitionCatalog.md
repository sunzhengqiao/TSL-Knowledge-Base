# HSB-ElementDefinitionCatalog.mcr

## Overview
This script manages a configuration catalog that maps Element Types and Subtypes to specific Construction Zones. It provides a visual table in Model Space and allows users to add, edit, remove, or rename catalog entries via a right-click context menu.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script requires interactive placement in Model Space. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not intended for manufacturing details. |

## Prerequisites
- **Required entities:** None
- **Minimum beam count:** 0
- **Required settings files:** 
  - `HSB-ElementDefinitionCatalogProps.mcr` (Required for input dialogs)
  - `{sFileName}.xml` (Created automatically if missing)

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB-ElementDefinitionCatalog.mcr`

### Step 2: Configure Properties
```
Action: A properties dialog appears upon insertion.
```
- Set the **Catalog name** to define or load a specific XML file (e.g., "ProjectA_Catalog").
- Select a **Dimension style** to control the text appearance of the table.

### Step 3: Select Insertion Point
```
Command Line: Select a position
Action: Click in the Model Space to place the catalog visualization table.
```

### Step 4: Automatic Migration (If applicable)
```
Action: The script checks if the catalog file exists in the new location.
```
- If found, it loads the data.
- If not found in the new location but found in the legacy location, it automatically migrates the data to the new location and notifies you.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Catalog name | Text | HSB-ElementDefinitionCatalog | Specifies the filename of the XML database to use. Change this to switch between different project catalogs or create a new one. |
| Dimension style | Dropdown | _DimStyles | Determines the font, text size, and arrow style used for the visual catalog table. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add entry | Opens a dialog to create a new catalog entry by defining a Type, Subtype, and Zone assignments. |
| Edit entry | Select an existing entry from a list to modify its Zone definitions or properties. |
| Remove entry | Select an existing entry to permanently delete it from the catalog. |
| Rename entry | Select an entry to change its Type or Subtype name while keeping its Zone data intact. |
| Clear catalog | Deletes all entries from the currently loaded XML file, effectively resetting the catalog. |

## Settings Files
- **Filename**: `{Catalog Name}.xml`
- **Location**: `_kPathHsbCompany\Abbund` or `_kPathHsbCompany\Content\Dutch\Element`
- **Purpose**: Stores the Element Definition mappings (Types, Subtypes, and Zones 00-10). This file serves as the database for the catalog.

## Tips
- **Project Management:** Use the **Catalog name** property to maintain separate catalogs for different clients or standards (e.g., type "StandardWall" to load `StandardWall.xml`).
- **Visual Updates:** If the table text is too small or large, change the **Dimension style** in the properties palette; the table will automatically regenerate.
- **Duplicate Handling:** If you try to add an entry with a Type/Subtype combination that already exists, the script will warn you and abort the save. Use "Edit entry" instead.
- **File Migration:** If you recently updated hsbCAD, the script will automatically find and move your old catalog files to the new folder structure.

## FAQ
- **Q: Why did my catalog entries disappear?**
  - A: You likely changed the "Catalog name" property. Ensure the name matches the XML file containing your data.
  
- **Q: Can I use this script to link different wall types to specific layers?**
  - A: Yes, by defining Zones (00-10) in the catalog entries, you can map specific Element Types/Subtypes to logical construction layers used by other scripts.

- **Q: What happens if I run the insert command twice in the same session?**
  - A: The script automatically erases the previous instance to prevent duplicates in the drawing.

- **Q: I received a message "Cannot write the catalog to..."**
  - A: Check your file permissions. The folder where the XML is being saved might be read-only.