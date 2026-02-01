# Hilti-Verankerungsplan.mcr

## Overview
This script automatically generates a 2D anchoring plan by dimensioning Hilti connectors relative to a selected boundary polyline, such as a concrete slab edge. It creates visual markers and dimension lines indicating where to place anchors on the foundation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates entirely in ModelSpace. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities:**
  - A **Polyline** representing the boundary (e.g., slab edge).
  - One or more **TSL instances** of type: `Hilti-Verankerung`, `Hilti-Stockschraube`, or `hsbCLT-Hilti`.
- **Minimum beam count:** 0 (This script works with TSL instances and Polylines, not directly with beams).
- **Required settings:** None (Standard TSL environment).

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse and select `Hilti-Verankerungsplan.mcr`.

### Step 2: Configure Properties
**Action:** A properties dialog will appear (unless launched from a catalog preset).
- Adjust settings like **Text Height**, **Color**, or **Dimstyle** if necessary.
- Click **OK** to proceed.

### Step 3: Select Boundary Polyline
```
Command Line: Select Polyline
Action: Click on the Polyline that represents the edge or boundary you want to dimension against.
```

### Step 4: Select Connectors
```
Command Line: Select TSL(s)
Action: Select the Hilti connector instances (Hilti-Verankerung, Hilti-Stockschraube, etc.) you wish to include in the plan. Press Enter to confirm selection.
```

### Step 5: Place Reference Point
```
Command Line: Select Point
Action: Click a point in the drawing to determine the position and offset of the dimension lines.
```
*The script will now generate the dimension lines and text labels.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Text height (`dTxtH`) | Number | U(70) | Sets the height of the text labels. This also affects the spacing of dimension lines to prevent overlap. |
| Color (`nColor`) | Number | 6 | The CAD color index (1-255) used for all generated text and dimensions. |
| Dimstyle (`sDimStyle`) | Dropdown | _DimStyles | Select the dimension style to apply (controls arrows, ticks, and fonts). |
| Auto group (`sGroup`) | Text | Hilti Verankerungsplan | Assigns the generated plan to a specific group in the project browser. Use `\` to create sub-groups (e.g., `Level1\Anchors`). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Verankerung hinzufügen** (Add Connector) | Allows you to select additional TSL connectors to be added to the existing dimension plan. |
| **Verankerung entfernen** (Remove Connector) | Allows you to select connectors to be removed from the dimension plan. |
| **Add Points** | Allows you to manually pick points in the drawing to be added as dimension references on the line. |
| **Delete Points** | Allows you to select and remove manually added dimension points. |

## Settings Files
- **Catalog Entry:** `_kExecuteKey`
- **Location:** hsbCAD Catalog
- **Purpose:** If a catalog entry exists, it can pre-fill the Properties Panel (Text height, Color, etc.) and skip the initial configuration dialog.

## Tips
- **Moving Dimensions:** Select the generated plan and drag the **Grip Point** (the point selected in Step 5) to move the entire dimension line while maintaining relative positions.
- **Visibility Control:** Use the `sGroup` property to organize your plans. You can easily toggle the visibility of all anchors for a specific floor or section via the Project Browser.
- **Valid Connectors:** The script automatically filters out invalid connectors. For example, `hsbCLT-Hilti` connectors pointing downwards or attached to multiple panels will be ignored without an error message.
- **Dimension Style:** Ensure your chosen `sDimStyle` exists in the drawing before running the script, or it may default to the standard style.

## FAQ
- **Q: The script disappeared after I selected the point. Did it fail?**
  - **A:** Not necessarily. The script works in "Generation Mode." It creates child instances for the dimensions and often erases the parent script instance to keep the drawing clean. Check if your dimension lines appeared.
  
- **Q: Why are some of my connectors not showing up in the dimensions?**
  - **A:** Ensure the connectors are of the correct type (`Hilti-Verankerung`, `Hilti-Stockschraube`, `hsbCLT-Hilti`). Also, verify that Wall elements associated with the connectors are set to "exposed" if required by your configuration.

- **Q: How do I change the text size after the plan is created?**
  - **A:** Select the dimension plan instance, open the **Properties Palette (OPM)**, and modify the `Text height (`dTxtH`) value. The graphics will update automatically.