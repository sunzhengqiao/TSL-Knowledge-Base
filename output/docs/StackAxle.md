# StackAxle.mcr

## Overview
This script manages the axle configuration for transport stacks (StackEntity). It allows users to visualize, position, add, and remove axles to calculate and display the load distribution weight on each axle.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment to visualize axles relative to the load. |
| Paper Space | No | Not applicable for layouts. |
| Shop Drawing | No | This is a logistics/planning tool, not a detailing tool. |

## Prerequisites
- **Required Entities**: A `StackEntity` (representing the load) must exist and be selected. A valid `TruckDefinition` must be linked to the stack.
- **Minimum Beams**: 0 (This is not a beam processing script).
- **Required Settings**: `TslUtilities.dll` must be installed. Valid `TruckDefinition` entries must exist in the catalog.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the AutoCAD command line.
2. Select `StackAxle.mcr` from the file list.
3. Select the `StackEntity` (the transport load) you wish to analyze.

### Step 2: Initial Configuration (First Run)
When first inserted, the script will automatically generate a default axle configuration:
*   **Front Axle**: Placed 2000 mm from the start of the load.
*   **Rear Axle**: Placed 1000 mm from the end of the load.

### Step 3: Adjust Axle Positions
1. The script displays triangle markers representing axles.
2. **Drag the diamond-shaped grips** along the length of the stack to reposition axles.
3. The displayed text values update automatically to show the new weight distribution.

### Step 4: Add or Remove Axles
1. Right-click on the script instance to open the context menu.
2. Select **|Add axle|** or **|Remove axle|**.
3. **If Adding**: Click anywhere within the load profile (highlighted area) in the 3D view to place a new axle.
4. **If Removing**: Click on an existing axle marker/grip to delete it.

## Properties Panel Parameters
This script does not expose standard OPM (Properties Palette) parameters. All configuration is handled via interactive grips and the Right-Click Context Menu.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | See Right-Click Menu for controls. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Save Definition** | Saves the current axle configuration (positions) to the parent TruckDefinition catalog. This makes the current layout the default for future stacks using this truck type. |
| **Add axle** | Activates a Jig mode allowing you to click points on the stack to add new axles. |
| **Remove axle** | Activates a Jig mode allowing you to click on existing axles to remove them. |

## Settings Files
- **TruckDefinition**: Catalog entry within the hsbCAD database.
- **Location**: Project/Catalog database.
- **Purpose**: Provides the default axle map and truck style data.

## Tips
- **Visual Cues**:
    - **Blue Axles**: Indicate the configuration is loaded from the TruckDefinition catalog (Style Based).
    - **Red Axles**: Indicate the configuration is specific to this single stack instance (not linked to the catalog).
- **Weight Calculation**: The calculation relies on the `StackEntity` weight and Center of Gravity (COG). Ensure these are accurate in the stack properties before using this script.
- **Boundary Limits**: You cannot place axles outside the projected load profile. The script will ignore clicks outside this area.

## FAQ
- **Q: How do I make my current axle setup the default for all trucks of this type?**
  - A: Arrange the axles as desired, then right-click and select **|Save Definition|**.
- **Q: The script ignores my clicks when adding axles. Why?**
  - A: You must click within the "allowed" load profile area (typically the rectangle of the stack footprint). Clicking outside this boundary has no effect.
- **Q: What happens if I change the weight of the stack?**
  - A: The script will automatically recalculate the weight on each axle the next time it updates (recalculates).