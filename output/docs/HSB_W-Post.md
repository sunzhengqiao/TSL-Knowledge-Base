# HSB_W-Post.mcr

## Overview
This script inserts a vertical steel post (column) into a timber wall element to provide structural reinforcement. It supports optional top and bottom steel connection plates and automatically handles the cutting and splitting of existing timber top and bottom plates to accommodate the new post.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D wall elements and geometry. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Not intended for manufacturing views. |

## Prerequisites
- **Required Entities**: An `ElementWall` with valid Top Plate (Beam type `_kSFTopPlate`) and Bottom Plate (Beam type `_kSFBottomPlate`) already existing in the model.
- **Minimum Beam Count**: 2 (The top and bottom plates of the wall).
- **Required Settings**: Access to an Extrusion Profile Catalog to select steel sections.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_W-Post.mcr` from the list.

### Step 2: Select Wall Element
```
Command Line: Please select Element
Action: Click on the target timber wall in the drawing that requires the post.
```

### Step 3: Pick Insertion Point
```
Command Line: Pick a reference point to insert post
Action: Click near the location along the wall where you want the post to be placed.
```

### Step 4: Configure Properties
After placement, select the inserted script instance and adjust the dimensions, profile, and plate settings in the Properties Palette to fit your design requirements.

## Properties Panel Parameters

### General Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Extrusion profile name | dropdown | *Empty* | Select the steel profile catalog name (e.g., HEA, IPE). Leave empty to use manual dimensions. |
| Default post width | number | 70 mm | Width of the post (along wall length). Used if profile is Rectangular or Round. |
| Default post height | number | 70 mm | Depth of the post (perpendicular to wall). Used if profile is Rectangular or Round. |
| Alignment | dropdown | Left | Aligns the post relative to the clicked point: Left, Center, or Right. |
| Offset top | number | 0 mm | Vertical adjustment at the top. Positive moves the post up. |
| Offset bottom | number | 0 mm | Vertical adjustment at the bottom. Positive moves the post down. |
| Zone to assign the plates | dropdown | 1 | Assigns the generated plates to a specific manufacturing zone. |

### Top Plate Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Create plate top | dropdown | No | Set to "Yes" to generate a steel plate at the top of the post. |
| Plate top width | number | 1500 mm | Horizontal length of the top plate along the wall. |
| Plate top height | number | 150 mm | Vertical height of the top plate. |
| Plate top thickness | number | 250 mm | Thickness of the top plate. |
| Plate top offset X | number | 0 mm | Horizontal shift of the top plate relative to the post. |
| Plate top offset Y | number | 0 mm | Vertical shift of the top plate relative to the post top. |

### Bottom Plate Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Create plate bottom | dropdown | No | Set to "Yes" to generate a steel plate at the bottom of the post. |
| Plate bottom width | number | 1500 mm | Horizontal length of the bottom plate along the wall. |
| Plate bottom height | number | 150 mm | Vertical height of the bottom plate. |
| Plate bottom thickness | number | 250 mm | Thickness of the bottom plate. |
| Plate bottom offset X | number | 0 mm | Horizontal shift of the bottom plate relative to the post. |
| Plate bottom offset Y | number | 0 mm | Vertical shift of the bottom plate relative to the post bottom. |

## Right-Click Menu Options
Standard hsbCAD context menu options apply.
*   **Recalculate**: Refreshes the script geometry based on current wall properties and script settings.
*   **Delete**: Removes the script and associated generated steel plates.

## Settings Files
-   **Extrusion Profile Catalog**: Referenced by the `sProfile` property.
-   **Location**: Defined in your hsbCAD configuration (Company or Install path).
-   **Purpose**: Provides the geometric definition for standard steel profiles (e.g., HEA100, IPE200).

## Tips
-   **Reference Point**: The "Alignment" setting (Left/Center/Right) is calculated based on the point you clicked in Step 3. If the post isn't where you expected, try changing the alignment or pick the point again.
-   **Manual Dimensions**: If you need a custom rectangular steel size not in your catalog, leave the "Extrusion profile name" empty and use the "Default post width" and "Default post height" fields.
-   **Plate Splitting**: The script automatically cuts the existing timber top and bottom plates around the steel post. The width of the steel post determines the gap in the timber.

## FAQ
-   **Q: Why didn't a steel plate generate?**
    -   A: Ensure the "Create plate top" or "Create plate bottom" property is set to "Yes".
-   **Q: The post is floating or cutting into the floor.**
    -   A: Check the "Offset bottom" property. Adjusting this value will move the bottom of the post up or down relative to the wall's bottom plate.
-   **Q: Can I use this on a wall without top/bottom plates?**
    -   A: No, the script requires a valid ElementWall with recognized Top and Bottom plates to calculate the post height and perform splitting.