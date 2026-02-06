# hsbCLT-AssignMasterpanelPosnumData.mcr

## Overview
Batch assigns Position Numbers, Names, and Information to selected MasterPanels using customizable format strings and automatic incrementing counters.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates exclusively in Model Space. |
| Paper Space | No | Not supported for Paper Space entities. |
| Shop Drawing | No | This script does not process shop drawing views. |

## Prerequisites
- **Required entities**: MasterPanel entities must exist in the drawing.
- **Minimum beam count**: 1 (usually used on multiple panels).
- **Required settings files**: None (internal catalogs may be used for presets).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-AssignMasterpanelPosnumData.mcr`

### Step 2: Configure Properties
*Note: This step may occur automatically if a specific Catalog preset is chosen, or a dialog may appear.*
1.  If prompted, set the desired parameters in the dialog (Start Number, Name Format, etc.).
2.  Alternatively, properties can be adjusted via the Properties Palette if the script instance is selected before selecting panels.

### Step 3: Select Entities
```
Command Line: Select entity(s)
Action: Click on the MasterPanels you wish to update. Press Enter to confirm selection.
```

### Step 4: Processing
The script automatically processes the selected entities, applies the numbering and naming logic, and then erases itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Start Number | number | 0 | Defines the starting number for indexing. The next available number will be assigned. Set to 0 to disable position numbering. |
| Format (Name) | text | @(Style) | Defines the name of the masterpanel. Use format expressions and/or text. Supports tokens like @(Style), @(SipComponent.Material), @(surfaceQuality). |
| Index (Name) | number | 1 | Defines the start number for an increment appended to the name (e.g., Wall_01). Set to 0 to disable. |
| Format (Information) | text | @(Style) | Sets the information field of the masterpanel. Supports the same format expressions as the Name field. |
| Index (Information) | number | 0 | Defines the start number for an increment appended to the information field. Set to 0 to disable. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific custom context menu items are added by this script. |

## Settings Files
- **Filename**: N/A (Uses internal script logic or standard catalogs)
- **Location**: N/A
- **Purpose**: Script relies on internal properties; no external settings file is strictly required for basic execution.

## Tips
- **Renaming Only**: If you only want to update the Name or Information fields without changing the Position Numbers, set the **Start Number** to `0`.
- **Custom Formats**: You can mix static text with dynamic tokens. For example, `Wall-@(Style)` will result in names like `Wall-CLT240`.
- **Data Availability**: Ensure your panels have valid SIP/Style data assigned. Tokens like `@(SipComponent.Material)` will return empty if the material is not defined in the panel construction.
- **Avoiding Duplicates**: The script scans the entire Model Space to ensure the Position Number assigned is unique.

## FAQ
- **Q: What happens if I run the script twice on the same panels?**
  A: If the Start Number is > 0, the script will attempt to find the next available free number in the model, potentially re-numbering the panels again. If Start Number is 0, it will re-apply the Name/Information formats.
- **Q: How do I include the panel thickness in the name?**
  A: Use the token `@(SipComponent.Thickness)` in the Format field.
- **Q: Can I number panels out of order?**
  A: The script assigns numbers sequentially based on the selection order and the available numbers in the model. To number out of order, select panels one by one or in specific groups.