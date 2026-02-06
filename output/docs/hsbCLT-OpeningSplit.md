# hsbCLT-OpeningSplit.mcr

## Overview
This script automates the creation of structural header and sill panels around openings in CLT or SIP walls. It calculates the necessary geometry, splits existing wall panels to accommodate the inserts, and applies specific material attributes via Painter definitions.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script works on 3D model entities (Openings, Elements, Panels). |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: At least one Opening, Element (Wall), or Sip (Panel) entity.
- **Minimum Beams**: 0 (Script targets Panels/Sips).
- **Required Settings**: Painter definitions must exist in the `hsbCLT-OpeningSplit` collection in your hsbCAD catalog.
- **Software Version**: hsbCAD version 21.0.108 or 22.0.15 or higher.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or select from your custom toolbar/menu)
Action: Browse and select `hsbCLT-OpeningSplit.mcr`.

### Step 2: Select Geometry
```
Command Line: Select opening(s), element(s) or panel(s) with openings <Enter> to select existing header(s):
Action: Click on the desired openings (windows/doors), the entire wall element, or specific panels. Press Enter to proceed to the next step or to select existing headers.
```

### Step 3: Configure Properties (Optional)
Action: Before pressing Enter to finish, you can adjust the Header/Sill extensions and gaps in the Properties Palette (OPM) if the script focus is active.

### Step 4: Execution
Action: Press Enter. The script will process the geometry, split the panels, create the header/sill inserts, and then erase itself from the drawing.

## Properties Panel Parameters

### Header

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Extension | number | 0 | Defines how far the header panel extends horizontally beyond the opening sides. |
| Horizontal Gap | number | 0 | Defines the horizontal gap between the header panel and the opening jambs. |

### Sill

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Extension | number | 0 | Defines how far the sill panel extends horizontally beyond the opening sides. |
| Split Sill | dropdown | No | Determines if a separate sill panel is created (**Yes**) or if the sill area is merged back into the main wall panels (**No**). |

### Opening

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Top | number | 0 | Defines the vertical gap between the top of the opening and the header panel. |
| Bottom | number | 0 | Defines the vertical gap between the bottom of the opening and the sill panel. |
| Left | number | 0 | Defines the horizontal gap on the left side of the opening. |
| Right | number | 0 | Defines the horizontal gap on the right side of the opening. |

### Painter

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Reference | dropdown | bySelection | Selects the Painter Definition to apply attributes (Material, Grade, Name, etc.) to the new panels. |
| Painter Definition | text | [Internal] | Internal data field used to copy the catalog definition. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script functions as a generator and erases itself after execution. There are no persistent right-click menu options attached to the script instance. |

## Settings Files
- **Painter Collection**: `hsbCLT-OpeningSplit`
- **Location**: hsbCAD Catalog (Company or Install folder)
- **Purpose**: Provides the templates for naming, material grading, and layer assignment for the generated header and sill panels.

## Tips
- **Splitting Logic**: If you set "Split Sill" to **No**, the script will attempt to join the wall panels at the sill location, effectively removing a previous sill split.
- **Existing Headers**: If you want to modify an existing header configuration (e.g., change its width), run the script and press **Enter** immediately at the first prompt. This allows you to select specific existing header entities to process.
- **Circular Openings**: The script automatically detects and skips circular openings; it is designed for rectangular profiles only.
- **Attributes**: Use the "Reference" dropdown in the Properties Palette to ensure your new header and sill panels match the correct material specifications for your project.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  - A: This is a "generator" script. It creates the physical geometry (panels and cuts) and then removes its own instance from the drawing to keep the file size small.
- **Q: How do I change the header size after it has been created?**
  - A: Since the script instance is gone, you must run the script again. You can either delete the existing header and run the script on the opening, or use the "Select existing header(s)" option by pressing Enter at the first prompt.
- **Q: The script didn't create a sill panel.**
  - A: Check the **Split Sill** property in the Properties Palette before running the script. If it is set to "No", the script will merge the sill area into the main wall rather than creating a separate piece.