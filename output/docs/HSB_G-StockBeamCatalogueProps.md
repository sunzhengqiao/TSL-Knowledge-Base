# HSB_G-StockBeamCatalogueProps.mcr

## Overview
This script serves as a management tool for the timber stock beam catalog. It allows users to create, select, and edit standard beam profiles and their available stock lengths, which are stored in a central company data file.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates as a properties-based tool in the model environment. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: None.
- **Minimum Beam Count**: 0.
- **Required Settings Files**: 
  - The data file `HSB-StockBeamCatalogue.dxx` must exist in the `Abbund` subfolder of your hsbCAD Company directory (e.g., `...\hsbCompany\Abbund\`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-StockBeamCatalogueProps.mcr` from the list.

### Step 2: Configure Properties
```
Action: Immediately after insertion, open the Properties Palette (Ctrl+1).
Note: The script behaves differently based on its internal "Mode" (Add, Select, or Edit), which determines which fields are visible or editable.
```

### Step 3: Update Catalog
```
Action: Modify the visible parameters (Width, Height, Lengths, or Section) as required.
Effect: The script reads from or writes to the 'HSB-StockBeamCatalogue.dxx' file to update the inventory database.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Width | Number | 38 | The thickness of the timber section (mm). Used when adding a new entry. |
| Height | Number | 89 | The depth of the timber section (mm). Used when adding a new entry. |
| Lengths | Text | 5380; 8380 | A list of standard stock lengths available for this section. Separate multiple lengths with a semicolon (`;`). |
| Section | Text/Dropdown | Dynamic | The name identifier for the beam profile. 
- **Dropdown**: In Select mode, choose an existing profile from the catalog.
- **Text**: In Add/Edit mode, view or lock the profile name. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | No custom context menu options are defined for this script. |

## Settings Files
- **Filename**: `HSB-StockBeamCatalogue.dxx`
- **Location**: `<hsbCompanyPath>\Abbund\`
- **Purpose**: Stores the dictionary of stock beam sections and their associated valid lengths.

## Tips
- **Data Persistence**: Ensure the `Abbund` folder path is correctly mapped in your hsbCAD configuration; otherwise, the script cannot find the catalog file.
- **Formatting**: When entering lengths, always use a semicolon with a space to separate values (e.g., `2400; 3000; 4500`) to ensure they are parsed correctly.
- **Editing**: If the Section name is read-only, the script is likely in "Edit" mode, allowing you to update lengths without changing the profile dimensions.

## FAQ
- Q: Why can't I change the Width or Height?
- A: The script may be in "Select" or "Edit" mode. These modes lock the cross-sectional dimensions to ensure existing catalog data integrity. Use "Add" mode (if available via instance configuration) to create new sizes.

- Q: Where is my stock data saved?
- A: Data is saved in the `HSB-StockBeamCatalogue.dxx` file located in your Company directory's `Abbund` folder, not in the drawing file itself.