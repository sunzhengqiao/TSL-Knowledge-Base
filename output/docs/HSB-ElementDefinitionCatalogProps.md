# HSB-ElementDefinitionCatalogProps.mcr

## Overview
This script acts as a Catalog Manager for construction element definitions (such as wall or floor types). It allows you to create, edit, rename, or select element configurations and their associated zoning/layering attributes directly from the AutoCAD Properties Palette, updating a central XML database file.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates as a data utility; does not create visible geometry. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Not intended for manufacturing views. |

## Prerequisites
- **Required Entities:** None.
- **Minimum Beam Count:** 0.
- **Required Settings:**
  - `HSB-ElementDefinitionCatalog.xml` (or a custom XML filename defined in the project Map).
  - The XML file must exist in the company folder (`...\Abbund`) or the legacy content path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB-ElementDefinitionCatalogProps.mcr`

### Step 2: Place the Definition Object
```
Command Line: Insert point [or click to place]:
Action: Click any point in the Model Space.
```
*Note: The script instance will immediately disappear from the screen. This is normal behavior. It runs as a "ghost" object to handle data updates without creating visual clutter.*

### Step 3: Manage Properties
1.  If your system is set up to select the object automatically, the **Properties Palette** will open.
2.  Depending on the **Mode** set by your system administrator or calling script, you will see different fields:
    -   **Add (Mode 1):** Enter new Type, SubType, and Zone details.
    -   **Select (Mode 2):** Choose a definition from the dropdown list.
    -   **Edit (Mode 3):** Select a definition to modify its Zone attributes.
    -   **Rename (Mode 4):** Change the Type or SubType of an existing definition.
3.  Modify the fields as needed. Changes are automatically written to the XML catalog file.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Mode | System Set | 0 | Determines the operation: 1=Add New, 2=Select, 3=Edit, 4=Rename. Typically set by the calling macro. |
| Type-SubType | Dropdown/Text | - | The unique identifier for the catalog entry. Displays as a dropdown in Select mode. |
| Type | Text | - | The main category (e.g., "Wall", "Roof"). |
| SubType | Text | - | The specific variation (e.g., "External_300mm"). |
| Zone 0 | Text | - | Attribute for the core or reference layer of the element. |
| Zone 1 - Zone 5 | Text | - | Attributes for sequential layers or zones within the assembly. |
| Zone 6 - Zone 10 | Text | - | Extended zone attributes for complex assemblies. |
| On top of Zone 00 | Text | - | Specifies the layer/zone on the exterior/positive side of the core. |
| At the back of Zone 00 | Text | - | Specifies the layer/zone on the interior/negative side of the core. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the script logic, useful if the XML file was modified externally or if the Mode changes. |

## Settings Files
- **Filename:** `HSB-ElementDefinitionCatalog.xml` (or custom name defined in Map)
- **Location:** `...\_kPathHsbCompany\Abbund\` (Legacy: `...\Content\Dutch\Element\`)
- **Purpose:** Stores the library of element definitions, Types, SubTypes, and their associated Zone attributes used by the project.

## Tips
- This script is best used as a "Catalog Editor" for BIM Managers. It avoids the need to manually edit XML files in a text editor.
- If the script vanishes after insertion but you need to modify it again, you may need to use the "Select Last" command or a specific catalog selection tool provided in your hsbCAD toolbar, as the object has no geometry to click on.
- Ensure the XML file is not "Read-Only" if you are in Add or Edit mode, or the script will fail to save changes.

## FAQ
- **Q: Why did the element disappear immediately after I clicked to insert it?**
  - A: This script is a data utility. It performs its function (updating the catalog) and erases its graphical instance to keep your drawing clean.
- **Q: How do I switch between "Add" and "Edit" modes?**
  - A: The Mode is usually controlled by the Map settings or the specific macro used to launch the script. Consult your system administrator to create shortcuts for specific modes.