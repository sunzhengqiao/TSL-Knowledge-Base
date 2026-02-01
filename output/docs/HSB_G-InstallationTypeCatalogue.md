# HSB_G-InstallationTypeCatalogue.mcr

## Overview
This script creates a dynamic catalogue (legend) of installation types, such as electrical sockets or plumbing fixtures, directly in Model Space. It allows you to define custom symbols and IDs, managing them via an XML file to generate standardized schedules for your drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script inserts the catalogue table at a selected 3D point. |
| Paper Space | No | Not supported for layout insertion. |
| Shop Drawing | No | This is a Model Space management tool. |

## Prerequisites
- **Required Entities**: None.
- **Minimum Beam Count**: 0.
- **Required Settings Files**:
  - `HSB-InstallationTypeCatalogue.xml` (Located in `hsbCompany\Abbund`)
  - `HSB_G-InstallationTypeCatalogueProps.mcr` (Must be in the TSL search path)

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Select 'HSB_G-InstallationTypeCatalogue.mcr' from the file list.
```

### Step 2: Define Insertion Point
```
Command Line: Pick insertion point:
Action: Click in the Model Space where you want the top-left corner of the catalogue table to appear.
```

### Step 3: Initial Configuration (First Run Only)
If this is the first time running the script, a property dialog may appear automatically to set default text styles. Otherwise, the table will generate immediately based on existing data in the XML file.

### Step 4: Manage Catalogue Entries
Once inserted, use the Right-Click Context Menu on the script instance to Add, Edit, or Remove installation types.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Text size** | Number (Double) | U(50) | Controls the height of the text in the table. Changing this scales the entire table (row height, column width). |
| **Dimension style** | String | _DimStyles | Determines the font and text style used for the table headers and content. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add an entry** | Launches a workflow to create a new installation type. You will be prompted to enter a Name, select a Color, pick Polylines to act as the symbol, and pick a Reference Point for that symbol. |
| **Edit an entry** | Opens a list of current entries. Selecting one allows you to modify its Name, Color, and Geometry (Symbol). |
| **Remove an entry** | Opens a list of current entries. Selecting one permanently deletes it from the catalogue and the XML file. |

## Settings Files
- **Filename**: `HSB-InstallationTypeCatalogue.xml`
- **Location**: `hsbCompany\Abbund` directory.
- **Purpose**: Stores the persistent list of installation types (IDs, Names, Colors, and Symbol Geometry) so the data is shared across the project.

## Tips
- **Scaling**: To make the legend readable on a specific plot scale, adjust the **Text size** property in the Properties Palette (Ctrl+1).
- **Symbol Creation**: When adding a symbol, draw the representation (e.g., a circle with lines) using Polylines first. The script will ask you to select these geometry items to "stamp" them into the catalogue.
- **Unique IDs**: The script automatically generates IDs (A, B, C... AA, AB...). If you encounter an ID conflict, check the XML file or use the Edit function to clean up old entries.

## FAQ
- **Q: Why does the table disappear when I move it?**
  - **A**: Ensure you are selecting the script instance, not just the text lines. Use the insertion point grip to move the table safely.
- **Q: How do I change the font of the table?**
  - **A**: Change the **Dimension style** property in the Properties Palette to match your preferred text style (e.g., `Standard` or a custom TTF style).
- **Q: Can I use this for electrical legends?**
  - **A**: Yes, this script is designed specifically for creating MEP (Mechanical, Electrical, Plumbing) legends and symbol catalogues.