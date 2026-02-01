# BMF Column Shoe ISB Maxi

## Overview
This script generates the 3D model and necessary machining details for a BMF steel column shoe (ISB series). It creates the steel connection hardware and automatically cuts a slot in the timber column to anchor it securely to a concrete foundation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates 3D geometry and modifies the beam in the model. |
| Paper Space | No | This script does not generate 2D views or drawings. |
| Shop Drawing | No | Not intended for shop drawing generation. |

## Prerequisites
- **Required Entities**: A single timber column (GenBeam) must exist in the model.
- **Minimum Beam Count**: 1 (The script must be applied to a beam).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT` or right-click on a beam in the model.
**Action:** Select the script file `BMF Column shoe ISB maxi.mcr` from the file browser.

### Step 2: Select Beam
**Action:** Click on the timber column (GenBeam) where you wish to install the column shoe.
*Note: The script typically attaches to the bottom of the column based on the beam's coordinate system.*

### Step 3: Adjust Position and Parameters
**Action:** Once inserted, select the generated connection or the beam. Press `Ctrl+1` to open the **Properties Palette**.
**Action:** Modify the parameters (see below) to fit your specific connection requirements (e.g., shoe size, fixing type, height offset).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Type** (prStrType) | dropdown | ISB-160 | Select the model of the BMF column shoe. Options: ISB-160, ISB-260, ISB-Maxi. Changing this updates the physical dimensions of the shoe and the slot size in the wood. |
| **Base Height** (dBaseHeigh) | number | 0 | Sets the vertical offset (Z-axis) of the shoe relative to the bottom of the timber column. Use this to adjust for grout gaps or concrete cover. |
| **Type of Fixing** (strFixing) | dropdown | Dowels | Specifies the anchoring method for the shoe. Options: Dowels or Bolts. This updates the Article Number and labeling for ordering purposes. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific custom items to the right-click context menu. All adjustments are made via the Properties Palette. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: All configuration is handled via script properties.

## Tips
- **Grout Gaps**: Use the **Base Height** parameter to lower the steel shoe if you need to leave space for grout between the timber column and the concrete foundation.
- **BOM Updates**: Changing the **Type of Fixing** (Dowels vs. Bolts) updates the Article Number in the Bill of Materials (BOM), ensuring you order the correct hardware package.
- **Visualizing the Cut**: If the shoe does not appear to fit correctly, check your UCS or the beam's orientation. The script cuts a slot based on the beam's local coordinate system.

## FAQ
- **Q: Why is the shoe not appearing at the bottom of my column?**
  **A:** Check the **Base Height** property. If it is set to a high value, the shoe may be pushed far down or up relative to the insertion point.
- **Q: Does this script draw the anchor bolts into the concrete?**
  **A:** No, this script models the steel shoe attached to the timber column and the necessary slot. Anchors into the concrete are typically handled as separate 2D details or specific concrete elements.