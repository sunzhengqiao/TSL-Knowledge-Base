# HSB_T-Anchor.mcr

## Overview
This script inserts and manages connection anchors (such as ties, brackets, or hold-downs) on timber beams. It automatically generates 3D visual representations and compiles hardware data for production lists and shop drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in 3D Model Space. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | This is a modeling tool, not a detailing script. |

## Prerequisites
- **Required Entities**: At least one timber beam (`GenBeam`) must exist in the model.
- **Minimum Beam Count**: 1
- **Required Settings Files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_T-Anchor.mcr` from the list.

### Step 2: Select a Beam
```
Command Line: Select a beam
Action: Click on the timber beam in the model where you want to place the anchor.
```

### Step 3: Select a Position
```
Command Line: Select a position
Action: Click a point on or near the selected beam. This sets the initial reference location along the beam's length.
```

### Step 4: Configure Anchor
```
Action: After insertion, the anchor is created. You can immediately adjust its type and position using the Properties Palette (Ctrl+1).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Anchor** | Header | - | Category header for anchor properties. |
| Blockname anchor | Dropdown | *(Dynamic)* | Selects the specific 3D block (geometry) to represent the anchor (e.g., specific brand or shape). |
| Fastener article | Dropdown | \|None\| | Selects the screw, nail, or bolt type. This updates the Hardware Article Number (e.g., appends "_1" to the block name). |
| Subtype | Text | *(Empty)* | A classification label used by dimensioning scripts to determine how the anchor is tagged or labeled in drawings. |
| X-Offset | Number | 0.0 mm | Adjusts the lateral position of the anchor relative to the beam's centerline (along the beam width). |
| Z-Offset | Number | -125.0 mm | Adjusts the vertical position of the anchor relative to the beam's centerline (along the beam height). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Assign to beam** | Allows you to move the anchor to a different beam. Selecting this option prompts you to pick a new beam, and the script re-attaches the anchor instance to the new selection. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Fine-tuning Position**: Use the **X-Offset** and **Z-Offset** properties in the Properties Palette to slide the anchor along the face of the beam without needing to re-insert it.
- **Beam Deletion**: If you delete the parent beam, the anchor instance will automatically delete itself to prevent errors.
- **BOM Export**: Changing the "Fastener article" will create a new entry in your Hardware/Part list (e.g., changing from "None" to "1" changes the article number from `BlockName` to `BlockName_1`).

## FAQ
- **Q: Why is my anchor not visible after insertion?**
- **A:** Check the **Blockname anchor** property. If it is empty or points to a block definition that does not exist in the current drawing, nothing will be displayed. Select a valid block from the dropdown list.
  
- **Q: Can I rotate the anchor?**
- **A:** The script automatically aligns the anchor based on the selected beam's coordinate system. Manual rotation is handled by the block definition orientation relative to the beam.

- **Q: How do I change the label for this anchor in drawings?**
- **A:** Edit the **Subtype** property in the Properties Palette. This field is read by dimensioning scripts to apply specific text tags or markers.