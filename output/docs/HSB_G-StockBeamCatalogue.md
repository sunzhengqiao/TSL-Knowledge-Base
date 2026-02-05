# HSB_G-StockBeamCatalogue.mcr

## Overview
This script inserts a visual schedule (table) into the model that displays standard stock timber sections and their available lengths. It serves as both a display tool and a catalog manager, allowing you to add, edit, or remove inventory entries directly from the context menu.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The schedule is inserted at a user-selected point in the model. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not intended for manufacturing drawings. |

## Prerequisites
- **Required Entities**: None
- **Minimum Beam Count**: 0
- **Required Settings Files**:
  - `HSB_G-StockBeamCatalogueProps.mcr` (Script dependency)
  - `HSB-StockBeamCatalogue.dxx` (Expected location: `...\hsbCompany\Abbund`)

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` → Select `HSB_G-StockBeamCatalogue.mcr`

### Step 2: Insert the Catalog
```
Command Line: Select a position
Action: Click anywhere in the Model Space to place the top-left corner of the stock beam table.
```

### Step 3: Configure Properties (Optional)
Once placed, the Properties Palette will appear automatically. You can adjust the text size or dimension style before the table finishes generating.

### Step 4: View or Modify
The table will display the current contents of the catalog file. Right-click the table to Add, Edit, or Remove entries.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Text size** | Number | U(50) | Sets the height of the text characters. This also scales the grid (row height = 2x text size, column width = 10x text size). |
| **Dimension style** | String | (Empty) | Selects the dimension style (font, color) to use for the table text and headers. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add an entry** | Opens a dialog to create a new stock beam entry. You must input Width, Height, and a list of Lengths (separated by semicolons). |
| **Edit an entry** | Allows you to modify the available lengths for an existing section. First, select the section from a list, then update the length string. |
| **Remove an entry** | Deletes a section completely from the catalog. Select the section from the list to confirm removal. |

## Settings Files
- **Filename**: `HSB-StockBeamCatalogue.dxx`
- **Location**: `_kPathHsbCompany\Abbund`
- **Purpose**: Stores the catalog data persistently. When you Add/Edit/Remove entries, this file is updated so the changes are visible across all drawings using this script.

## Tips
- **Formatting Lengths**: When adding or editing entries, separate multiple lengths with a semicolon (e.g., `2000;2400;3000`).
- **Scaling**: If the table is too small to read, select it and increase the **Text size** property in the Properties Palette.
- **Duplicate Checks**: The system prevents duplicate section sizes (Width x Height). If you try to add a size that already exists, use the **Edit an entry** option instead.

## FAQ
- **Q: I tried to add a beam but got a warning that it already exists. What do I do?**
  A: This means the specific Width x Height combination is already in the catalog. Use the "Edit an entry" right-click option to modify the lengths for that existing size.
- **Q: How do I move the table to a different spot?**
  A: Use the standard AutoCAD `MOVE` command or drag the grip located at the insertion point (top-left of the table).
- **Q: My text looks huge/tiny compared to the rest of the drawing.**
  A: Select the schedule, open the Properties Palette (Ctrl+1), and change the **Text size** parameter to a value suitable for your plot scale.