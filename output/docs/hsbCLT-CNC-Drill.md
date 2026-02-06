# hsbCLT-CNC-Drill.mcr

## Overview
This script creates CNC drilling operations (holes) on MasterPanel elements, such as CLT panels. It supports single-point drilling, patterned drilling along a path, or defining holes based on existing selected geometry (circles/polylines).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required. The script interacts with 3D panel geometry. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | This is a 3D model tool for manufacturing data. |

## Prerequisites
- **Required Entities:** A single MasterPanel (CLT or structural timber panel).
- **Minimum Beam Count:** N/A (Requires a MasterPanel, not a beam).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse and select `hsbCLT-CNC-Drill.mcr`.

### Step 2: Configure Initial Properties
A dialog box appears upon insertion.
- **Action:** Set initial parameters like **Diameter**, **Depth**, or **Toolindex** if known. Click OK to proceed.

### Step 3: Select Target Panel
```
Command Line: Select MasterPanel
Action: Click on the CLT panel or MasterPanel you wish to machine.
```

### Step 4: Choose Input Method
```
Command Line: Select polyline(s) and/or circle(s) <Enter> to pick points
Action: You have two choices here:
```
- **Option A (Use Geometry):** Select existing circles or polylines in the drawing that represent the hole locations or path, then press Enter. The script will automatically create holes based on these entities.
- **Option B (Manual Input):** Press Enter without selecting anything to define points manually.

### Step 5: Define Drill Locations
*The prompts here depend on your Property settings:*

**If Diameter is 0:**
```
Command Line: Enter diameter
Action: Type the drill hole diameter (e.g., 12) and press Enter.
```

**If Distributing Holes (Interdistance > 0):**
```
Command Line: Select start point
Command Line: Select next point
Action: Click points to define the path/line. The script will fill in holes between points based on your spacing settings.
```

**If Placing Single Holes (Interdistance = 0):**
```
Command Line: Pick point
Action: Click the location for the hole. The script creates the instance and immediately asks for the next point.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (A) Diameter | Number | 10 | Defines the drill diameter. Set to `0` to detect diameter from selected circles. |
| (B) Depth | Number | 10 | Defines how deep the hole goes. Set to `0` for a through-hole (complete penetration). |
| (C) Toolindex | Number | 0 | The CNC tool ID number from your machine library. |
| (D) Alignment | Dropdown | Top | Specifies the drilling side: **Top** or **Bottom**. |
| Interdistance | Number | 0 | The spacing between holes when creating a row/pattern. `0` means single-point mode. |
| Distribution Mode | Dropdown | Disabled | Logic for spacing: **Disabled**, **Even Distribution** (between endpoints), or **Fixed Distribution**. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Face | Inverts the drilling direction. Swaps the operation between the Top and Bottom faces of the panel. |
| Release Dependency | Breaks the link to the original Polyline/Circle used to create the drill. This allows you to edit the drill position independently using grip points. |
| Recalculate | Refreshes the script geometry if parameters were changed manually. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** This script operates entirely on manual inputs and direct entity selection.

## Tips
- **Through Holes:** Always set **Depth** to `0` if you want the hole to go completely through the panel, regardless of the panel thickness.
- **Using Circles:** If you have a CAD drawing with circles representing where holes go, set **Diameter** to `0` and select those circles in Step 4. The script will adopt the circle's exact diameter and position.
- **Pattern Drilling:** To create a vent or a row of holes, set the **Interdistance** (e.g., 100mm) and **Distribution Mode** to "Fixed". Pick the start and end points, and the script will calculate the intermediate holes.
- **Visualizing Depth:** The script usually provides a visual cue (color/geometry) to indicate which side of the panel (Top vs. Bottom) is being drilled.

## FAQ
- **Q: What happens if I enter a negative diameter?**
  - **A:** The script will detect this as invalid, display an error "invalid diameter Tool will be deleted," and remove the instance from the model.
- **Q: Can I move the holes after I place them?**
  - **A:** Yes. If you created them using manual point picking, select the script instance and drag the blue grip points. If you created them from a polyline, right-click and select **Release Dependency** first to unlock the grips.
- **Q: Why is the "Select polyline" prompt skipped?**
  - **A:** This prompt is skipped if **Diameter** is already set to a value greater than 0 **and** the Distribution Mode is disabled. The script assumes you want to pick single points immediately.