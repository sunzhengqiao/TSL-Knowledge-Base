# hsb_AssignOpeningWeight.mcr

## Overview
Calculates the physical weight of window and door openings based on frame material and glazing specifications. It assigns this data to the opening entity for scheduling and draws a visual symbol to indicate if the unit is factory-fitted.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script attaches to Opening entities within ElementWalls. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required entities**: An `Opening` (Window or Door) that is part of an `ElementWall`.
- **Minimum beam count**: 0.
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse to and select `hsb_AssignOpeningWeight.mcr`.

### Step 2: Configure Properties
1. Upon selection, a "Default Property Dialog" will appear.
2. Set the default values for **Glass Type**, **Window Frame Type**, **Factory Fitted**, and **Symbol Scale**.
3. Click **OK** to proceed.

### Step 3: Select Openings
```
Command Line: Select one or More Openings
Action: Click on one or more window/door openings in the model to assign the script and calculated weight.
```
4. Press **Enter** to finalize the selection.

### Step 4: Modify Individual Openings (Optional)
1. Select an opening that has the script assigned.
2. Open the **Properties Palette** (Ctrl+1).
3. Change parameters (e.g., change Glass Type) as needed.
4. Right-click the opening and select **Recalculate weight** to update the weight data based on new parameters.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Glass Type | dropdown | \|SG 4mm\| | Select the glazing specification (e.g., Single Glazing 4mm, Double Glazing). This affects the calculated weight. |
| Window frame type | dropdown | \|Redwood\| | Select the timber species for the frame (e.g., Redwood, Sapele, Meranti). Heavier woods increase the total weight. |
| Factory Fitted | dropdown | No | Determines if the window is assembled in the factory. **Yes** draws a green symbol; **No** draws a red symbol. |
| Symbol Scale | number | 1 | Adjusts the visual size of the fitted/unfitted symbol drawn in the model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate weight | Forces the script to re-evaluate the weight based on the current dimensions and property settings. Use this after changing Glass Type or Window Frame Type. |

## Settings Files
- None required.

## Tips
- **External Walls Only**: This script automatically erases itself if attached to an opening in an internal wall. It only processes external walls.
- **Visual Indicators**:
    - **Green Symbol**: The unit is marked as "Factory Fitted" (Yes).
    - **Red Symbol**: The unit is not factory fitted (No).
- **Updating Weight**: Changing the "Factory Fitted" status automatically updates the visual symbol. However, changing material properties (Glass/Frame) requires you to right-click and select "Recalculate weight" to update the stored weight data.
- **Symbol Visibility**: If the symbol is too small or large, adjust the "Symbol Scale" property in the Properties Palette.

## FAQ
- **Q: Why did the symbol disappear after I inserted the script?**
  - A: The script may have detected that the opening is located in an internal wall, in which case it automatically removes itself.
- **Q: I changed the Glass Type, but the weight didn't update in my reports.**
  - A: You must right-click the opening and select "Recalculate weight" to apply the new material factors to the calculated weight.
- **Q: What does the number written to the entity represent?**
  - A: The script writes a property named `TotalWeight` (in the HSB_OpeningInfo submap) to the opening entity, representing the weight in kilograms (or the current project mass unit).