# GE_HDWR_STRAP_TWIST_HTS.mcr

## Overview
Generates 3D models and scheduling data for Simpson Strong-Tie Twist Straps (HTS and H-series). It connects trusses or rafters to top plates to provide wind uplift resistance.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for inserting and visualizing 3D hardware. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required Entities:** At least one Beam or Truss Entity.
- **Minimum Beam Count:** 1.
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_HDWR_STRAP_TWIST_HTS.mcr`

### Step 2: Select Structural Member
```
Command Line: Select a Beam or a Truss Entity
Action: Click on the rafter, truss, or joist where the strap will be applied. You can select multiple members if needed.
```

### Step 3: Locate Insertion Point
```
Command Line: Select insertion Point
Action: Click in the model to define where the strap will penetrate the member (typically at the heel or bearing point).
```

### Step 4: Define Strap Type
```
Command Line: Strap Type [HTS16/HTS20/HTS24/HTS28/HTS30/H2.5/H2.5A/H2.5T/H8] <HTS20>
Action: Type the specific strap code (e.g., HTS20) and press Enter. Pressing Enter without typing defaults to HTS20.
```

### Step 5: Attach to Wall Display (Optional)
```
Command Line: Select an Entitie or Element to attach Display to (Optional)
Action: Select a wall or element if you wish to associate this hardware with a specific schedule or wall display group. Press Enter to skip.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Strap type | Dropdown | HTS20 | Selects the hardware model (HTS16, HTS20, HTS24, HTS28, HTS30, H2.5, H2.5A, H2.5T, H8). |
| Direction | Dropdown | 1 | Flips the strap orientation along the beam axis (1 or -1). |
| Side | Dropdown | 1 | Flips the strap to the opposite side of the beam (1 or -1). |
| Heel Height | Number | 0 | Adjusts the vertical extension of the lower leg. Use this for double top plates or to reach wall studs. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add wall(s) to the display | Opens a selection box to choose wall elements. This links the hardware instance to those walls for reporting purposes. |
| Remove all walls from the display | Removes any previously linked wall elements from this hardware instance. |

## Settings Files
None required. All dimensions are internal to the script based on the selected Strap type.

## Tips
- **Quick Adjustments:** After insertion, select the hardware and use the Properties panel (Ctrl+1) to flip the `Direction` or `Side` without re-inserting.
- **Double Plates:** If using double top plates, increase the `Heel Height` value to ensure the strap extends through to the bottom plate or wall stud.
- **Vertical Members:** This script cannot be applied to vertical columns; ensure you select a horizontal or sloped beam/rafter.

## FAQ
- **Q: Why did I get the error "Wrong Selection"?**
  **A:** You likely selected a vertical beam or an object that is not a valid Beam or Truss Entity. Select a rafter or truss bottom chord and try again.
- **Q: Can I change the strap size after inserting?**
  **A:** Yes. Select the strap in the model, open the Properties palette, and change the "Strap type" dropdown. The 3D model will update automatically.
- **Q: How do I make the strap appear on my wall schedule?**
  **A:** Right-click the strap instance and choose "Add wall(s) to the display", then select the relevant wall element.