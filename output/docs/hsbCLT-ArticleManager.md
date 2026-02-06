# hsbCLT-ArticleManager

## Overview
Assigns and manages CLT (Cross Laminated Timber) layer composition data—such as materials, grades, and thickness—to structural timber panels. It allows users to attach specific "Article" definitions to panels so that detailed build-up information is available for labels, lists, and production data export.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Works on 3D model elements. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not intended for 2D drawing generation. |

## Prerequisites
- **Required Entities**: Structural panels of type `Sip` or `MasterPanel`.
- **Minimum Beam Count**: N/A (Targets panels).
- **Required Settings**:
    - `CLT-ArticleManager.xml` (Default catalog located in `company\tsl\settings` or install folder).
    - Surface Quality Styles defined in the catalog.
    - (Optional) Excel file for bulk importing articles.

## Usage Steps

### Step 1: Launch Script
Command: `hs_ScriptInsert` → Select `hsbCLT-ArticleManager.mcr` from the list.

### Step 2: Select Panels
```
Command Line: Select panels
Action: Click on one or more structural timber panels (Sip or MasterPanel) in the model to which you want to assign CLT data. Press Enter to confirm selection.
```

### Step 3: Assign Article
```
Action: With the panel(s) selected, open the Properties Palette (Ctrl+1). Locate the "Article" property dropdown. Select the desired article definition from the list that matches your panel's thickness and surface qualities.
```

### Step 4: Verify Assignment
```
Action: Check the visual feedback. If the assignment is successful, the panel should appear normal. If the panel displays a solid fill with a warning (e.g., "Could not find matching data"), the catalog may be missing a definition matching your panel's specific geometry or quality.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Article | dropdown | (Empty) | Selects the specific pre-defined panel construction (Article) from the catalog. This determines the total thickness, surface quality, and the specific make-up of individual timber layers. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Import Excel Articles | Opens a file dialog to select an Excel file. Parses the file to update the internal article catalog with new definitions (requires columns: Thickness, Quality 1, Quality 2, Components). |
| Export Settings | Saves the currently loaded article definitions (catalog) to `CLT-ArticleManager.xml` in the company settings folder. If the file exists, you will be prompted to confirm overwriting. |

## Settings Files
- **Filename**: `CLT-ArticleManager.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings\` or `_kPathHsbInstall\Content\General\TSL\Settings\`
- **Purpose**: Stores the article catalog, including definitions for Thickness, Quality 1, Quality 2, and Component strings.

## Tips
- **Visual Errors**: If your panel turns transparent red/filled after assigning the script, it means no article in the catalog matches the panel's thickness or surface qualities. Use the "Import Excel Articles" context menu option to load the correct data.
- **Bulk Updates**: You can select multiple panels and run the script simultaneously. If they share the same geometric properties, you can update them all at once via the Properties Palette.
- **Data Usage**: The data written by this script is stored in the entity's `SubMapX` under the key `CLT_ArticleData`. This can be referenced in Lists/Labels to show individual layer thicknesses or materials.

## FAQ
- **Q: I see a red overlay over my panel saying "No article definitions found." What do I do?**
  A: The script cannot find a catalog entry that matches your panel's specific Thickness and Surface Qualities. Use the Right-Click menu -> "Import Excel Articles" to load your specific catalog, or ensure your Surface Quality Styles match the XML definitions exactly.
- **Q: What format should the Excel import file have?**
  A: The Excel file must contain the specific column headers: `Thickness`, `Quality 1`, `Quality 2`, and `Components`.
- **Q: Can I use this on regular beams?**
  A: No, this script is designed specifically for CLT panels (`Sip` and `MasterPanel` entities).