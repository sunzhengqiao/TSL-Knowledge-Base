# HSB_G-Stack

## Overview
This script generates a 3D bounding box representing a material stack or pack. It is primarily used for logistics planning and transport visualization to determine how timber packs fit onto trucks or within storage areas.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be inserted in Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required entities**: None
- **Minimum beam count**: 0
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-Stack.mcr` from the list.

### Step 2: Configure Dimensions
- **If inserting from a Catalog**: The script will automatically load pre-set dimensions (Length, Width, Height) if a valid Execute Key is present.
- **If inserting manually**: A **Properties** dialog will appear. Enter the dimensions for the stack and click OK.

### Step 3: Place Stack
```
Command Line: |Select a position|
Action: Click in the Model Space to set the origin point (bottom corner) of the stack.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Length | Number | 7200 mm | The longitudinal dimension of the stack (along the X-axis). |
| Width | Number | 2200 mm | The transverse dimension of the stack (along the Y-axis). |
| Height | Number | 2800 mm | The vertical dimension of the stack (along the Z-axis). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific custom menu items are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Linking to Trucks**: If you have a truck entity created with `HSB_G-Truck`, simply move the stack so it physically overlaps with the truck. The script will automatically detect the intersection and link the stack to the truck for visualization.
- **Resizing**: You can adjust the stack size at any time by selecting it and changing the Length, Width, or Height values in the Properties Palette (Ctrl+1).
- **Unit Independence**: The script uses internal unit conversion (function `U()`), so dimensions will adjust correctly regardless of your current drawing units (mm/cm/m).

## FAQ
- **Q: How do I visualize different pack sizes?**
- **A**: Select the stack entity, open the Properties Palette, and modify the Length, Width, or Height to match your specific material pack dimensions.
- **Q: The stack didn't attach to my truck.**
- **A**: Ensure the stack is moved close enough to physically intersect the truck body in the 3D view. The link relies on geometric overlap.