# hsbBOM.mcr

## Overview
This script generates Bills of Materials (BOM) tables and places Position Number (PosNum) labels on structural elements. It automates the creation of production lists and material take-offs for timber framing projects in Modelspace, Paperspace, or Shopdrawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Processes selected entities or the entire project depending on interaction. |
| Paper Space | Yes | Requires selection of an `hsbViewport` to filter visible elements. |
| Shop Drawing | Yes | Supports multipage blocks; requires viewport selection within the detail. |

## Prerequisites
- **Required Entities**: GenBeams, Sheets, or TSL instances (connectors/scripts) must exist in the drawing.
- **Viewport**: An `hsbViewport` is required when running the script in Paperspace or Shopdraw space.
- **Selection**: In Modelspace, you must have entities to select.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` (or via the hsbCAD Toolbar/Catalog).
**Action**: Browse and select `hsbBOM.mcr` from the list and confirm insertion.

### Step 2: Select Entities or Viewport
The script prompts differ based on your current CAD space:

*   **In Modelspace:**
    ```
    Command Line: Select entities:
    Action: Click on the Beams, Sheets, or TSLs you want to include. Press Enter to finish selection.
    ```

*   **In Paperspace or Shopdraw:**
    ```
    Command Line: Select hsbViewport:
    Action: Click on the viewport frame that defines the view you want to create a BOM for.
    ```

### Step 3: Place BOM Table
```
Command Line: Insertion point:
Action: Click in the drawing to position the top-left corner of the BOM table/list.
```

### Step 4: Adjust Properties (Optional)
**Action**: Select the inserted BOM object (usually represented by an insertion point grip). Open the **Properties Palette** (Ctrl+1) to toggle labels, change filters, or modify sorting.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Drawing space** | Integer | 0 | Sets the working context: 0=Model, 1=Paper, 2=Shopdraw. Read-only after insert. |
| **nShowPosNumBm** | Integer | 1 | Controls labels on Beams. 0=None, 1=PosNum, 2=Name, 3=PosNum+Name, 4=Only in BOM, 5=PosNum+Size. |
| **nShowPosNumSh** | Integer | 1 | Controls labels on Sheets/Panels. 0=None, 1=PosNum, 2=Name, 3=PosNum+Name, 4=Only in BOM. |
| **nShowPosNumTSL** | Integer | 1 | Controls labels on Connectors/TSLs. 0=None, 1=PosNum, 2=Name, 3=PosNum+Name, 4=Only in BOM, 5=PosNum+Size. |
| **nPosNumAlignment** | Integer | 1 | Label orientation. 0=Horizontal (World X), 1=Aligned to Entity, 2=Outside Entity (prevents overlap). |
| **bShowCompAngles** | Boolean | 0 | If 1, shows complementary saw angles (90 - cut angle) in the BOM. |
| **sFilterMaterial** | String | "" | Filters BOM by material type (e.g., "C24;GL24h"). Leave empty to include all. |
| **sFilterTsl** | String | "" | Filters BOM by TSL/Connector names (e.g., "Screw;Plate"). Leave empty for all. |
| **nSortCol** | Integer | 0 | Determines which column the BOM table is sorted by (index number). |
| **bShowLogPosNum** | Boolean | 0 | If 1, uses Blockbau/Log house specific numbering format (Label + Sublabel + Layer). |
| **nColor** | Integer | 38 | Sets the CAD color index for the text labels. |
| **nHideDisplay** | Integer | 0 | Filters visibility based on Zone Index. Used to show/hide elements from specific construction phases. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add Entity to BOM** | Allows you to select new entities and append them to the existing BOM table without deleting and re-running the script. |

## Settings Files
- **Data Source**: TSLBOM map data (internal/exported data).
- **Purpose**: Provides the logic for naming and dimensioning TSL components if they are not explicitly defined in the script.

## Tips
- **Use "Outside Entity" Alignment**: If your drawing is dense, set `nPosNumAlignment` to **2**. This pushes the labels outside the timber width so they don't cover your geometry.
- **Table Only Mode**: If you only need a list and don't want text cluttering the drawing views, set the `nShowPosNum` options to **4** (Only in BOM).
- **Material Filtering**: You can type multiple materials in `sFilterMaterial` separated by semicolons (e.g., `C24;Kerto-S`) to generate a list for just specific grades.
- **Moving the Table**: Click the BOM insertion point to activate the grip and drag the table to a new location.

## FAQ
- **Q: Why are some of my beams missing from the list?**
  **A**: Check the `sFilterMaterial` or `sFilterTsl` properties. You may have a filter active that excludes certain materials or connector types. Also check `nHideDisplay` (Zone Filter).
- **Q: Can I update the list if I change beam sizes?**
  **A**: Yes. Select the BOM insertion point and right-click. If the list doesn't update automatically, use the `hsbRefresh` command or delete and re-insert the script.
- **Q: What is the difference between "PosNum" and "Name"?**
  **A**: "PosNum" is the unique assembly mark assigned by hsbCAD numbering rules. "Name" is the generic name of the element (e.g., "Rafter" or "Stud").
- **Q: How do I list hardware separately?**
  **A**: Use the `sFilterTsl` property to type the name of your hardware script (e.g., "Screw"), or create separate BOM scripts for structure and hardware.