# hsbCLT-PrintText

## Overview
This script places dynamic text labels on CLT panels or beams in the 3D model. It is primarily used to display fabrication information, such as position numbers or dimensions, directly on the element surface for identification in drawings and exports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted onto a valid 3D panel or beam. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: A CLT panel or beam (Element/GenBeam).
- **Minimum Beam Count**: 0 (Uses Element reference).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-PrintText.mcr`

### Step 2: Select Element
```
Command Line: Select Element
Action: Click on the CLT panel or beam you wish to label.
```

### Step 3: Pick Text Location
```
Command Line: Pick Location
Action: Click a point on the panel face or edge to define where the text will be placed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Format | text | @(Posnum) @(SolidLength) | Defines the content of the text using dynamic macros (e.g., @(Label), @(Length)). You can mix static text with variables. |
| Alignment | dropdown | Reference Side | Determines which face of the panel the text is placed on (Reference Side or Opposite Side). |
| Text Position | dropdown | bottom left | Sets the justification of the text relative to the picked point (e.g., Top Left, Center Center, Bottom Right). |
| Text Orientation | dropdown | Positive X-Axis | Sets the rotation angle of the text relative to the element's local axes (X or Y axis directions). |
| Text Height | number | U(50) | Defines the physical height of the text characters on the panel. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Immediately toggles the text between the "Reference Side" and the "Opposite Side" of the panel. This can also be triggered by double-clicking the script instance. |

## Settings Files
No external settings files are required.

## Tips
- **Dynamic Macros**: Use the `Format` property to pull real data from the model. For example, `@(Posnum)` pulls the element's position number, and `@(Width:RL1)` pulls the width rounded to 1 decimal.
- **Moving Text**: You can grip-edit the insertion point in the model to slide the text along the panel edge. The text will automatically snap to the nearest edge on the current face.
- **Quick Flip**: Double-click the text in the model to instantly flip it to the other side of the panel without opening the properties palette.

## FAQ
- **Q: Why did my text disappear?**
- **A:** Check if the "Text Height" is set too small or if the script was moved to a location where it cannot project onto the geometry. Also, ensure the referenced element has not been deleted.
- **Q: How do I display the material name?**
- **A:** Enter `@(Material)` (or similar property name) into the `Format` field in the properties palette.
- **Q: Can I change the text rotation?**
- **A:** Yes, use the "Text Orientation" dropdown in the properties to rotate the text 90 degrees or align it with the panel's local Y-axis.