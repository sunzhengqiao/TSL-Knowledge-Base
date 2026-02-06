# hsbItemToArea.mcr

## Overview
Assigns a specific inventory article (material) to selected model entities (such as walls, roofs, or sheets) and calculates their geometric properties (Area, Net Area, Perimeter) for material estimation and quantification.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is designed for 3D model detailing. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | Not a shop drawing generation script. |

## Prerequisites
- **Required Entities**: Element (Wall), ERoofPlane, Sip, Sheet, Opening, EntPLine, or Circle.
- **Minimum Beam Count**: 0.
- **Required Settings Files**:
  - `hsbItemToArea.xml` (Configuration file for groups and classes).
  - `hsbLooseMaterialsUI.dll` (Interface for inventory/material data).

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT` (or run via Catalog Key)
**Action:** Browse and select `hsbItemToArea.mcr`.

### Step 2: Select Material Group
**Dialog:** Dynamic Dialog appears on insertion.
**Action:** Select the **Major** group (Category) from the dropdown list (e.g., "Sheathing", "Insulation"). This selection filters the available articles and determines which types of entities you can select next.

### Step 3: Select Specific Article
**Dialog:** Dynamic Dialog (Continues from Step 2).
**Action:** Select the specific **Article** (Product code) from the list (e.g., "OSB 18mm T&G").

### Step 4: Select Geometric Entities
**Command Line:** `Select a set of [Allowed Classes] or [Allowed Classes]...`
**Action:** Click on the desired entities in the model (e.g., a roof plane or wall face).
*Note: You can select multiple entities to calculate a combined Net Area.*

### Step 5: Place Annotation
**Command Line:** `Insertion point:`
**Action:** Click in the model space to place the text label and leader line indicating the assigned material.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| |Major - Minor group| | dropdown | - | Defines the material category (e.g., Sheathing). Filters the available Articles and valid entity classes. |
| |Article| | dropdown | - | The specific inventory item to assign to the geometry. |
| Area | Double | Calculated | The surface area of the selected entity/entities. |
| NetArea | Double | Calculated | The union of areas if multiple entities are selected (removes overlaps). |
| Perimeter | Double | Calculated | The total perimeter length of the selected geometry. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Move Annotation | Select the script instance and drag the grip to move the text label and leader line. The vector updates automatically. |
| Update Geometry | If the underlying wall or roof is modified, the script recalculates Area and Perimeter automatically. |

## Settings Files
- **Filename**: `hsbItemToArea.xml`
- **Location**: Company or Install path (standard TSL search path).
- **Purpose**: Defines the "Major" groups available for selection and specifies which entity classes (e.g., Element, Sheet) are allowed for each group.

- **Filename**: `hsbLooseMaterialsUI.dll`
- **Location**: hsbCAD application directory.
- **Purpose**: Connects the script to the hsbCAD Inventory database to retrieve available Articles.

## Tips
- **Calculating Totals**: If you select multiple disjointed planes (e.g., several roof sections), the script calculates the **Net Area** (the union of all shapes), which is useful for ordering total material.
- **Filtering**: Pay attention to the **Major** group selection. If you cannot click a certain entity type (e.g., a Wall), check if the selected Major Group allows "Element" class in the XML settings.
- **Visual Feedback**: The leader line created by the script helps identify exactly which surface the material calculation applies to on complex models.

## FAQ
- **Q: I get an error "Wrong definition of the xml file 1001".**
  **A:** The file `hsbItemToArea.xml` is missing, corrupt, or formatted incorrectly. Contact your CAD Manager to restore the file from the company standard.
- **Q: The "Article" dropdown is empty.**
  **A:** There are no items defined in the hsbCAD Inventory for the selected Major-Minor group, or the `hsbLooseMaterialsUI.dll` is missing.
- **Q: Can I change the Article after insertion?**
  **A:** No, the Article selection is read-only after insertion to maintain data integrity. Delete the script instance and re-insert to assign a different material.