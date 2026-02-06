# Sihga PICK Wall.mcr

## Overview
This script automates the insertion and configuration of SIHGA PICK lifting hardware into Stickframe walls. It calculates placement based on the element's center of gravity, validates lifting angles against safety limits, and generates necessary CNC data for manufacturing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for inserting the script and selecting wall elements. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: Stickframe Wall (`ElementWallSF`).
- **Minimum beam count**: N/A (Script operates on wall elements).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Sihga PICK Wall.mcr`

### Step 2: Select Wall
```
Command Line: Select wall(s)
Action: Click on the Stickframe wall element in the drawing you wish to add lifting hardware to.
```
*Note: After selecting the wall, the Properties Panel will automatically open to allow you to configure the lifting settings.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (A) - Quantity | dropdown | 1 | Select the lifting configuration: 1 point, 2 points, 4 points, 4 points with a traverse, or 4 points with hanger chains. |
| (B) - Lifting Belt Length | number | 2000 | Enter the length of the lifting belts (slings) in mm. This determines the maximum allowable distance between points to maintain a safe angle. |
| (C) - Interdistance of Lifting Points | number | 1000 | Enter the desired spacing between lifting points in mm. The script may automatically reduce this value if the belt length is too short to maintain a 45° lifting angle. |
| (D) - Chain / Traverse Length | number | 2000 | Enter the vertical length of the traverse (spreader bar) or hanger chains in mm. Used for calculating angles in 4-point lifts. |
| (E) - Apply Weinmann Tools | dropdown | No | Select "Yes" to generate "No Nail" zones around the lifting points for Weinmann CNC machines. |
| Element weight | text | 0 | Enter the total weight of the wall element in kg. This is used to validate if the current configuration can safely lift the wall. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None available | |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Automatic Distance Adjustment**: If you set the Interdistance too wide for the specified Belt Length, the script will automatically reduce the distance to ensure the lifting angle does not fall below 45°.
- **Safety Validation**: Always populate the "Element weight" field. The script will visually warn you if the wall weight exceeds the capacity of the selected SIHGA PICK configuration.
- **CNC Preparation**: Enable "Apply Weinmann Tools" only if you are using a Weinmann manufacturing machine. This prevents the machine from nailing through the lifting hardware zones.

## FAQ
- **Q: Why did the script change my "Interdistance of Lifting Points" value?**
  **A:** To ensure safety. The script recalculates the geometry to maintain a minimum lifting angle of 45°. If your entered distance would result in a shallower (unsafe) angle, it automatically corrects it.
- **Q: What is the difference between "4 + Traverse" and "4 + Hanger Chains"?**
  **A:** Both use 4 lifting points, but they calculate the crane hook position differently. "4 + Traverse" simulates a spreader bar, while "4 + Hanger Chains" simulates chains hanging from a single point, affecting how the load is distributed.