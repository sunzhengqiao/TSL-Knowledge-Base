# hsbInstallationPoint.mcr

## Overview
This script creates electrical or mechanical installation points (such as sockets, switches, or junction boxes) within timber wall elements. It automatically generates cable channels (wirechases), required millings/drillings, 2D plan symbols, and safety "no-nail" zones.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | All geometric operations (milling, model graphics) occur here. |
| Paper Space | No | |
| Shop Drawing | No | While it creates entities used in shop drawings (like no-nail zones), it is not a script run *inside* a shop drawing layout. |

## Prerequisites
- **Required Entities**: An Element containing GenBeams (studs/plates) or Sheets.
- **Minimum Beam Count**: 0 (Script creates geometry based on the Element structure).
- **Required Settings Files**:
  - `<hsbCompany>\\tsl\\settings` or local drawing path must contain XML configuration files.
  - Block definitions must exist in `<hsbCompany>\\Block\\Electrical`.
  - `hsb-E-Combination.mcr` and `hsbElectricalTsl.dll` must be accessible.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbInstallationPoint.mcr`

### Step 2: Select Configuration
```
Dialog: Select Configuration
Action: Select the desired preset from the list (populated from XML files in your settings folder).
Note: This sets default dimensions, symbols, and tooling strategies for the insertion.
```

### Step 3: Define Location
```
Command Line: Select Element/Point
Action: Click on the target wall Element or the specific location where the installation point should be placed.
Note: If prompted, select the specific GenBeam (stud) if the installation requires a specific reference surface.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| UseGenbeamReference | Boolean | 0 | If **1**, positions the point relative to the physical surface of the selected beam. Use this for walls with variable cladding or thickness. |
| WirechaseNoNail | Integer | 0 | Determines how "No-Nail" zones are calculated (0=Off, 1=Icon side horizontals only, etc.). Use this to prevent nailing into cables. |
| ConduitExtraWidth | Number | 0 | Adds extra width (in mm) to the standard cable channel milling. |
| ExtentWirechase | Boolean | 0 | If **1**, forces the cable channel to mill completely through the last structural member (e.g., bottom plate) to ensure continuity. |
| ExtentWirechaseOffset | Number | 0 | Extends the cable channel by a specific distance (mm) beyond the default endpoint. |
| CombinationStandardDiameter | Number | 68 | Sets the diameter (in mm) for circular drillings associated with the installation point. |
| Offset | Number | 0 | Shifts the machining position relative to the symbol's insertion point (mm). |
| FloorThickness | Number | Calculated | Defines the floor structure thickness. Used if a Room boundary is not detected to calculate vertical routing depth. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Set floor thickness | Prompts the user to manually enter the floor thickness if the script could not automatically detect a room boundary. |
| Vorgabe laden | Reloads the default settings from the selected configuration (XML) file, resetting any manual changes made in the properties palette. |
| export Settings | Exports the currently set parameters to a new XML configuration file for future reuse. |

## Settings Files
- **Filename**: `<scriptName>Settings.xml`
- **Location**: Searches in `<hsbCompany>\\tsl\\settings`, current drawing path, or `<hsbCompany>\\Block\\Electrical`.
- **Purpose**: Defines specific parameters for different installation types, including standard diameters, symbol styles, and default offsets.

## Tips
- **Cladded Walls**: If working on walls with uneven cladding, set `UseGenbeamReference` to **1** and select the underlying stud to ensure the box sits flush with the timber structure.
- **Safety Zones**: Enable `WirechaseNoNail` to automatically generate polygons in your drawings that indicate where fasteners must not be used, protecting the cables.
- **Reusability**: If you frequently use a specific non-standard setup (e.g., a specific channel depth), configure it once and use "export Settings" to save it as a new preset.

## FAQ
- **Q: Why is my cable channel not going through the bottom plate?**
  A: Check the `ExtentWirechase` property. If it is set to 0, the channel stops at the calculated boundary. If set to 1, ensure the `FloorThickness` allows the routing to continue.
- **Q: What does "Vorgabe laden" mean?**
  A: It is German for "Load Preset". It reloads the original factory or project defaults for the selected configuration.