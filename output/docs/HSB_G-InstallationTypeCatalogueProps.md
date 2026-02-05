# HSB_G-InstallationTypeCatalogueProps

## Overview
This script manages the catalog of installation types (e.g., electrical sockets, water pipes) within the hsbCAD environment. It allows users to add, select, or edit installation categories and their associated color codes, which are stored in a central XML file for use by other scripts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates here to manage data catalog settings. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities:** None.
- **Minimum Beam Count:** 0.
- **Required Settings Files:** 
  - `HSB-InstallationTypeCatalogue.xml` must be present in the company folder structure (usually `_kPathHsbCompany\Abbund`).

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Select `HSB_G-InstallationTypeCatalogueProps.mcr` from the file list.

### Step 2: Insert Script Instance
```
Command Line: [Insertion Point]
Action: Click a location in the Model Space to insert the script instance.
```
*Note: Upon insertion, the script may initialize and prepare the XML data link. Select the script instance after insertion to access its properties.*

### Step 3: Configure Properties
**Action:** With the script instance selected, open the **Properties Palette** (Ctrl+1).
- Use the **Installation type** field to define or select a category.
- Use the **Color index** to assign a visual color to the installation type.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Installation type | Dropdown / Text | "" | The name of the installation type (e.g., "Electricity/Socket"). In "Select" mode, this is a dropdown list populated from the XML catalog. In "Add" or "Edit" modes, this is a text input field. |
| Color index | Number | -1 | The AutoCAD color index (0-255) assigned to the installation type. Use -1 for default/undefined. |
| Id | Text (Read Only) | "" | The unique internal identifier for the entry. This is only visible in "Edit" mode and cannot be changed. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | No specific custom context menu items are added by this script. Configuration is done via the Properties Palette. |

## Settings Files
- **Filename**: `HSB-InstallationTypeCatalogue.xml`
- **Location**: `\\_kPathHsbCompany\Abbund` (Company Folder)
- **Purpose**: Stores the catalog entries (IDs, Names, Color Indices) that define the available installation types for the project.

## Tips
- **XML Location:** Ensure the `HSB-InstallationTypeCatalogue.xml` file exists in your company's `Abbund` folder. If the file is missing, the dropdown lists for selection may be empty.
- **Data Persistence:** Changes made to the properties (Name/Color) are typically written back to the XML file, ensuring the catalog is updated for all users/scripts accessing that file.
- **Modes:** The script behavior (Adding vs. Selecting vs. Editing) is determined by internal logic (Mode) linked to the instance. You may see different input fields (Text vs. Dropdown) depending on the current mode of the instance.

## FAQ
- **Q: I cannot see a dropdown list for "Installation type".**
  - A: The script might be in "Add" or "Edit" mode. Ensure the XML file exists and is correctly formatted. The dropdown only appears in "Select" mode (Mode 2).
- **Q: Where is the installation data actually stored?**
  - A: The data is stored in the `HSB-InstallationTypeCatalogue.xml` file, not inside the drawing file. This allows the catalog to be shared across multiple projects.