# BMF Balkenschuh.mcr

## Overview
Generates BMF brand metal beam hangers (shoes) to connect a supporting beam and a supported beam. The script creates the 3D geometry, handles hardware listings (BOM), manages layout markings, and adds specific milling for base plate recesses.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script works exclusively in the 3D model. |
| Paper Space | No | Not intended for 2D detailing views. |
| Shop Drawing | No | Does not generate 2D views directly, but links to production data. |

## Prerequisites
- **Required entities**: Two `GenBeam` objects (Supporting Beam and Supported Beam).
- **Minimum beam count**: 2
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `BMF Balkenschuh.mcr` from the file browser.

### Step 2: Select Supporting Beam (Male)
```
Command Line: Select supporting beam:
Action: Click on the main beam (typically the beam carrying the load vertically).
```

### Step 3: Select Supported Beam (Female)
```
Command Line: Select supported beam:
Action: Click on the joist or secondary beam that will rest inside the hanger.
```

### Step 4: Configure Properties (Optional)
```
Action: Select the inserted script instance and open the Properties Palette (Ctrl+1) to adjust settings like Orientation, Milling, or Markings.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Offset length (RS)** | number | -2 mm | Adjusts the geometric offset of the connection relative to the beam intersection. |
| **Bottom milling (Ausblattung)** | dropdown | Yes | If "Yes", creates a recess in the bottom of the supporting beam so the hanger base plate sits flush. |
| **Marking (Markierung)** | dropdown | None | Adds layout lines or text on the supported beam to assist with assembly. Options: Marking, Marking + Text, Marking + Number, None. |
| **Orientation (IA)** | dropdown | Outside | Sets the mounting side. "Outside" typically selects 3000-series articles; "Inside" selects 4000-series articles. |
| **Layer (sLayer)** | dropdown | 'T' Tool | Assigns the 3D body to a specific CAD layer ('T' Tool, 'I' Information, 'J' Autoinfo). |
| **Color (nColor)** | number | 252 | Sets the AutoCAD color index for the hanger visualization. |
| **|Stereotype| (sStereotype)** | text | Assembly | Defines shop drawing behavior (e.g., `*` shows all dimension chains). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Assign to** | Toggles the logical assignment of the script instance between the Supporting Beam (Male) and the Supported Beam (Female). This affects how the connection is grouped and exported. |

## Settings Files
No external settings files are required for this script.

## Tips
- **Beam Heights**: The script automatically selects the correct BMF Article Number based on the height of the supporting beam (Male beam). Ensure your beam heights correspond to standard BMF sizes (ranges approx 36mm - 200mm).
- **Flush Mounting**: If the metal base plate should be visible (sitting under the beam), set **Bottom milling (Ausblattung)** to "No". If it should be recessed into the beam, set it to "Yes".
- **Assembly Marks**: Use the **Marking** property to draw scribe lines on the female beam. This is very helpful on the construction site to know exactly where to place the beam relative to the hanger.

## FAQ
- **Q: How do I switch between the different BMF hanger series (e.g., for inside/outside corners)?**
  A: Change the **Orientation (IA)** property in the Properties Palette. The script will automatically update the internal Article Number based on this setting and the beam height.
- **Q: Why does my hanger look too small or too large?**
  A: The script sizes the hanger based on the height of the *Supporting Beam* (the first beam you selected). Check that this beam has the correct cross-section height.
- **Q: Can I use this for beams that are not perpendicular?**
  A: The script is designed for perpendicular connections. Using it on skewed beams may result in geometric inaccuracies.