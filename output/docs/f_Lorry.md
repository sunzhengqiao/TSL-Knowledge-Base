# f_Lorry.mcr

## Overview
This script creates a parametric 3D representation of a truck loading bay. It is used to plan and visualize timber shipments, ensuring that transport packages fit within the truck's physical dimensions and do not collide with one another during stacking.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment to visualize the truck and packages. |
| Paper Space | No | Not designed for 2D layout or detailing. |
| Shop Drawing | No | Does not generate 2D manufacturing drawings. |

## Prerequisites
- **Required Entities:** `f_LorryPackage` (TslInst entities) are required to add cargo to the truck.
- **Minimum Beam Count:** 0.
- **Required Settings:** `f_Stacking.xml` (Expected path: `Company\TSL\Settings\` or `Install\Content\General\TSL\Settings\`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `f_Lorry.mcr` from the catalog.

### Step 2: Configure Truck Properties
```
Command Line: (Dialog appears automatically on first insert)
Action: Enter the Length, Width, Height, and Description for the truck in the Properties dialog.
```
*Note: You can modify these later via the Properties palette.*

### Step 3: Set Insertion Point
```
Command Line: Specify insertion point:
Action: Click in the Model Space to place the base point of the truck lorry.
```

### Step 4: Add Packages (Post-Insertion)
```
Action: Select the Lorry instance in the model.
Action: Right-click and select "Add Lorry Package" from the context menu (or double-click the element).
```

### Step 5: Select Cargo
```
Command Line: Select TslInst entities:
Action: Select the timber package scripts (`f_LorryPackage`) you wish to load onto the truck. Press Enter to confirm selection.
```

### Step 6: Position Packages
```
Command Line: Specify placement point [Alignment options...]:
Action: Click to position the package. 
Optional: Type a number (1-9) to snap alignment:
  1: Front-Left | 2: Front-Center | 3: Front-Right
  4: Center-Left | 5: Center-Center | 6: Center-Right
  7: Back-Left | 8: Back-Center | 9: Back-Right
```
*Repeat for each selected package.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Length | Number | 13600 mm | Defines the total loading length of the truck bed. |
| Width | Number | 2500 mm | Defines the internal width of the truck available for loading. |
| Height | Number | 2700 mm | Defines the maximum vertical stacking height allowed for the load. |
| Description | Text | Truck | A user-defined label for the truck instance (e.g., "Site A Delivery"). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Lorry Package | Opens the selection filter to pick package entities. Allows you to align and attach selected packages to the truck using the placement jig. |

## Settings Files
- **Filename**: `f_Stacking.xml`
- **Location**: `Company\TSL\Settings\` or `Install\Content\General\TSL\Settings\`
- **Purpose**: Provides configuration data for stacking logic and object mapping.

## Tips
- **Quick Alignment**: While placing a package, type `5` to quickly center it, or `1`-`9` to snap it to specific corners of the placement cursor.
- **Visual Validation**: The script draws **Red** volumes where packages overlap or clash with each other. Adjust package positions manually to resolve these conflicts.
- **Resizing Warning**: If you reduce the Length or Width of the truck in the properties, any packages that fall outside the new boundaries will be automatically unlinked from the truck.

## FAQ
- **Q: What do the numbers 1 through 9 mean during placement?**
  **A:** These represent the alignment anchor of the package relative to your cursor. For example, "1" anchors the Front-Left corner of the package to your cursor, while "9" anchors the Back-Right corner.
  
- **Q: I see red boxes on my load. What does that mean?**
  **A:** Red boxes indicate a clash. This means two or more packages are occupying the same physical space, or a package is intersecting incorrectly. You must move the packages to resolve this.

- **Q: My package disappeared when I changed the truck size. Why?**
  **A:** The script validates that packages fit inside the truck envelope. If you shrink the truck dimensions so a package sits outside the new boundary, it is automatically unlinked (removed) from the truck.