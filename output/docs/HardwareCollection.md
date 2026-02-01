# HardwareCollection.mcr

## Overview
This script manages and inserts standardized hardware articles (such as fasteners, brackets, or connection plates) into the 3D model. It combines visual representations using DWG blocks with functional manufacturing data (Hardware Wrapper Components) to ensure accurate visualization and production listing (BOM/CAM).

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates in the 3D model environment to place hardware components. |
| Paper Space | No | Not intended for 2D detailing layouts. |
| Shop Drawing | No | Not intended for generating shop drawings directly. |

## Prerequisites
- **Required Entities**: None (requires a point for insertion).
- **Minimum Beam Count**: 0.
- **Required Settings Files**: `HardwareCollection.xml` (must be located in the Company or Install TSL Settings folder).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HardwareCollection.mcr` from the file browser.

### Step 2: Specify Insertion Point
```
Command Line: Insert point:
Action: Click in the Model Space to define where the hardware will be placed.
```

### Step 3: Set Dependency (Optional)
```
Command Line: Select entity (Beam/Wall) or press Enter to continue:
Action: Select a beam, wall, or other element to link the hardware to. 
Note: If selected, the hardware will move/rotate if the host element changes. Press Enter to place hardware independently.
```

### Step 4: Select Hardware Article
```
Dialog: Show Article Dialog
Action: Select an article from the list (e.g., "Simpson H10") to insert it.
Alternative: Click "Add Article" to define a new hardware item on the fly.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sArticle | String | "" | The unique identifier (Name) of the hardware article selected from the settings map. Changing this updates the block and manufacturing data. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Show Article Dialog** | Opens the selection list to choose a different hardware article for this instance. (Also triggered by Double-Click). |
| **Set Dependency** | Allows you to link the hardware to a new host element (Beam/Wall) after insertion. |
| **Set Alignment** | Aligns the hardware component to a selected face or plane in the model. |
| **Rotate** | Prompts for an angle to rotate the hardware around its local Z-axis. |
| **Set Block Definition** | Opens a file dialog to link a specific DWG file as the visual representation for the current article. |
| **Remove Block Definition** | Removes the DWG block link, leaving only the manufacturing data point. |
| **Add Article** | Opens a dialog to create a new hardware definition in the current settings. |
| **Edit Article** | Opens the Hardware Component dialog to modify dimensions, codes, and notes for the currently selected article. |
| **Delete Articles** | Removes unused articles from the settings library. (Fails if the article is currently used in the drawing). |
| **Import Settings** | Loads article definitions from an external XML file. |
| **Export Settings** | Saves the current library of article definitions to an XML file. |

## Settings Files

- **Filename**: `HardwareCollection.xml`
- **Location**: Searches in `_kPathHsbCompany\TSL\Settings` first, then `_kPathHsbInstall\Content\General\TSL\Settings`.
- **Purpose**: Stores the library of hardware articles, mapping Article Names to DWG block paths and Hardware Component properties (Supplier, Code, Dimensions, Notes).

## Tips
- **Dependency Handling**: Always use the "Set Dependency" option if the hardware is attached to a beam. This ensures that if the beam is resized or moved, the hardware updates automatically.
- **Editing Articles**: Use "Edit Article" to update manufacturing details (like length or material code) which will then propagate to all instances of that article in the project.
- **Managing Libraries**: Use "Export Settings" to back up your custom hardware library to a shared location so other users can import it.

## FAQ

- **Q: Can I delete an article from the list?**
  **A:** Only if it is not currently used by any instance in the drawing. If you try to delete an active article, the script will report an error.
  
- **Q: How do I change the visual look of a screw?**
  **A:** Select the hardware instance, right-click, and choose "Set Block Definition". Browse to your custom DWG file.
  
- **Q: Why did my hardware disappear after I changed the article?**
  **A:** The new article selection might point to a Block Definition path that does not exist or is empty. Check the file path in "Edit Article" or assign a valid block using "Set Block Definition".