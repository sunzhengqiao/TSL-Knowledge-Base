# GCS (General Column Shoe)

## Overview
This script inserts a manufacturer-defined metal column shoe (connector) at the base of a timber column. It automatically generates the 3D solid geometry of the hardware and drills the necessary bolt holes into the wood post.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model to create solids and modify timber beams. |
| Paper Space | No | Script does not generate 2D drawings directly. |
| Shop Drawing | No | Script focuses on physical detailing (bodies and drilling). |

## Prerequisites
- **Required Entities**: 1 Timber Column (GenBeam)
- **Minimum Beam Count**: 1
- **Required Settings Files**: `GCS.xml` (Catalog database containing manufacturer dimensions and drill patterns)

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT` (or click the specific Ribbon button if configured)
**Action:** Select `GCS.mcr` from the list of available scripts.

### Step 2: Select Timber Column
**Command Line:** `Select column/post:`
**Action:** Click on the timber column (GenBeam) in the drawing where you want to install the base shoe.

### Step 3: Configure Shoe
**Dialog:** `GCS - General Column Shoe`
**Action:** 
1. Select the **Manufacturer** from the dropdown (e.g., Simpson Strong-Tie).
2. Select the **Family** (e.g., PVD).
3. Select the specific **Article Number** (SKU) for the size required.
4. Click **OK**.

*Note: If you launched the script from a catalog token, these settings may be pre-selected.*

### Step 4: Review and Adjust
The script will generate the shoe geometry and holes. If the shoe does not fit or is oriented incorrectly, select the inserted shoe and use Right-Click options to adjust.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Manufacturer | String | Simpson Strong-Tie | The manufacturer of the column shoe. |
| Family | String | PVD | The product family or line. |
| Article Number | String | PVD 210 | The specific catalog code defining size and geometry. |
| Top Tolerance (Height/Width) | Number | 2.0 mm | Clearance gap added around the timber for the top plate to ensure fit. |
| Middle Extendable | Integer (0/1) | 0 (No) | If set to 1, indicates the shoe has a telescopic middle section for height adjustment. |
| Top Drill Diameter | Number | 12.0 mm | Diameter of the bolt holes to drill into the column. |
| Top Drill Rows / Columns | Number | 2 | The number of bolt holes in the vertical and horizontal directions (grid layout). |
| Drill Alignment | String | Front | The direction from which the drill is processed (Front, Right, Back, Left). |
| Material | String | Galvanized Steel | The material finish assigned to the 3D body. |
| Is Rotated | Boolean | False | Toggles the shoe orientation 90 degrees relative to the column axis. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Rotate | Rotates the shoe 90 degrees around the vertical axis. If the shoe is extendable, it toggles orientation; if not, it checks if the post fits the new orientation. |
| Flip Drill Face | Reverses the direction of the drill vector (e.g., drills from the opposite side). |
| Cycle Drill Face | Cycles the drill direction through the sequence: Front → Right → Back → Left. |

## Settings Files
- **Filename**: `GCS.xml`
- **Location**: `_kPathHsbCompany` or `_kPathHsbInstall`
- **Purpose**: This XML file acts as the catalog database. It stores the mapping of Manufacturers, Families, and Article Numbers to their specific geometric dimensions (width, height, depth), drill patterns, and material properties.

## Tips
- **Fit Check**: If you see an error "Post size does not fit selected column shoe," your timber column is too large for the selected hardware. Try a larger Article Number or check your post dimensions.
- **XML Requirement**: Ensure `GCS.xml` is present in your Company folder. If the script cannot find this file, it will display an error and delete the instance immediately.
- **Rectangular Posts**: For rectangular columns, use the **Rotate** context menu option to ensure the shoe width aligns correctly with the narrower or wider face of the timber.

## FAQ
- **Q: Why did the script disappear immediately after I selected the column?**
  - **A:** The script could not locate the required `GCS.xml` catalog file in your standard folders. Please contact your CAD Manager to ensure the configuration file is installed correctly.
  
- **Q: Can I change the drill size without changing the whole shoe?**
  - **A:** Yes, you can manually modify the `Top Drill Diameter` in the Properties Palette after insertion, though this should match the physical bolts intended for use.

- **Q: What does "Extendable" mean?**
  - **A:** It refers to column shoes that have a slotted middle bar to allow height adjustments (e.g., for site leveling). When enabled, it affects how the script handles rotation and dimension checks.