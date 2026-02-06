# hsbCLT-SihgaPick.mcr

## Overview
Automatically calculates and positions SihgaPick lifting hardware on CLT panels based on panel weight, center of gravity, and installation orientation. It supports both automatic configuration generation via XML tables and manual placement for specific project needs.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on Model entities (Sip/Element) and generates 3D tools (Drills/Bodies). |
| Paper Space | No | Not designed for layout or detailing views. |
| Shop Drawing | No | Creates production data (MapX) but runs in the model context. |

## Prerequisites
- **Required Entities**: A valid Sip or Element (CLT Wall or Floor).
- **Minimum Beams**: 1 Panel required.
- **Required Settings**: `hsbCLT-SihgaPick.xml` configuration file must exist in the `HsbCompany` or `HsbInstall` directory.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-SihgaPick.mcr` from the list.

### Step 2: Select Panel
```
Command Line: Select sip
Action: Click on the CLT wall or floor element to insert the lifting hardware.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | dropdown | SihgaPick | Selects the hardware model. Choose between **SihgaPick** (Standard) or **SihgaPickMax** (Heavy Duty). |
| Association | dropdown | Wall | Defines the installation context. Options: **Wall**, **Floor**, or **Auto**. Determines the load case logic used. |
| LiftDirection | dropdown | Top | Specifies which face is up during lifting. Options: **Top**, **Front**, **Back**, or **Side**. |
| StraightenUp | dropdown | No | If set to **Yes**, the script calculates configurations to ensure the panel hangs vertically. |
| NumDevices | number | 0 | Number of lifting points. **0** = Auto-calculate based on weight. Max 8. |
| Allowed uneveness | number | 20 | Tolerance (mm) for horizontal deviation of lifting points from the ideal edge. |
| ShowStraps | dropdown | Yes | Toggles the visual representation of lifting chains/straps and length labels. |
| ThicknessWallMin | number | 120 | Minimum panel thickness (mm) required to safely use the hardware configuration. |
| ManualMode | dropdown | No | If **Yes**, automatic calculation is disabled. Use OffsetX/Y to place the device manually. |
| OffsetX | number | 0 | Manual horizontal distance (mm) from the panel's origin. Only active in ManualMode. |
| OffsetY | number | 0 | Manual vertical distance (mm) from the panel's origin. Only active in ManualMode. |
| RotZ | number | 0 | Rotation of the device (degrees) around the Z-axis. Only active in ManualMode. |
| ChainWidth | number | 80 | Width or spacing parameter (mm) for the graphical chain representation. |
| SideDrill | dropdown | No | If **Yes**, adds a perpendicular side hole (locking pin) for the device. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the script logic based on current properties and geometry (Standard TSL behavior). |

## Settings Files
- **Filename**: `hsbCLT-SihgaPick.xml`
- **Location**: `HsbCompany/hsbCLT-SihgaPick.xml` or `HsbInstall/hsbCLT-SihgaPick.xml`
- **Purpose**: Contains Type definitions, LoadDefinitions (weight/thickness limits), and configurations for both SihgaPick and SihgaPickMax models. This file is critical for the "Auto" calculation of `NumDevices`.

## Tips
- **Automatic Calculation**: Leave `NumDevices` set to **0** to let the script determine the minimum number of lifting points required based on the panel's weight and center of gravity.
- **Manual Override**: If the automatic placement doesn't suit your specific construction detail, set `ManualMode` to **Yes** and use `OffsetX`, `OffsetY`, and `RotZ` to position the insert exactly where you need it.
- **Visual Feedback**: Toggle `ShowStraps` to **No** if you want to hide the chain/strap graphics in the model to reduce clutter, while keeping the hardware inserts visible.
- **Heavy Panels**: Use the **SihgaPickMax** type for heavier loads or thicker panels. This increases drill depth and uses heavy-duty load tables.

## FAQ
- **Q: The script shows an error "No valid configuration found". Why?**
  **A:** This means the XML settings do not contain a configuration that matches your panel's specific weight, thickness, or lifting angle. Try changing the `Association`, `LiftDirection`, or switching to the `SihgaPickMax` type.
  
- **Q: How do I force the script to use 4 lifting points instead of the 2 it calculated?**
  **A:** Change the `NumDevices` property from **0** to **4**. The script will attempt to place 4 points based on the geometry.

- **Q: Can I use this on floor elements?**
  **A:** Yes. Set the `Association` property to **Floor** or **Auto** to ensure the correct load tables are used for horizontal elements.