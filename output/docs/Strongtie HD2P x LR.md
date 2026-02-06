# Strongtie HD2P x LR.mcr

## Overview
Generates the 3D geometry and machining data for the Simpson Strong-Tie HD2P 2-piece hold-down tie rod system, used to resist uplift in timber wall panels. It automatically creates the metal connector bodies, drill holes for anchor bolts, routing cuts in the studs, and "no-nail" protection zones on the wall element.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D bodies, cuts, and drilling operations. |
| Paper Space | No | Not intended for 2D layout generation. |
| Shop Drawing | No | Generates model data only, not drawing views. |

## Prerequisites
- **Required Entities**: At least one `GenBeam` (stud) and an enclosing `Element` (wall).
- **Minimum Beam Count**: 1 stud.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Strongtie HD2P x LR.mcr`

### Step 2: Configure Connector Type
```
Command Line: Select Tie Rod Type
Action: A dialog box appears. Select the desired hardware variant (e.g., HD2P1L-B, HD2P1R-B) from the list and click OK.
```

### Step 3: Select Studs
```
Command Line: Select studs
Action: Click on the vertical wood studs in the model where you want to install the hold-downs. Press Enter to confirm selection.
```

### Step 4: Define Location and Orientation
```
Command Line: Pick point on desired side
Action: Click a point in the model to position the connector. 
Note: The vertical orientation (up or down) is calculated based on this point's height relative to the wall element's origin.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | String | HD2P1L-B | Specifies the hardware variant (Size 1 or 2, Left or Right). Changing this updates the bracket dimensions, number of fastener holes, and anchor bolt diameter. |
| NoNail | String | 2;3 | Defines which construction layers (Element Zones) are protected from nailing. Enter zone numbers separated by semicolons (e.g., "2;3"). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the connector geometry and cuts to reflect changes in the wall, stud positions, or property settings. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files; all configuration is handled via the Properties Palette and input dialogs.

## Tips
- **Orientation Control**: The script automatically determines if the connector should face "Up" or "Down" based on where you click relative to the wall's origin (usually the bottom-left corner). If the connector appears upside down, try picking a point significantly higher or lower on the wall.
- **Multi-Insert**: You can select multiple studs in Step 3. The script will generate a connector for each selected stud based on the single configuration chosen in Step 2.
- **No-Nail Zones**: Ensure the `NoNail` property matches your specific wall layering (e.g., layer 2 for studs, 3 for sheathing) to prevent the nailing machine from shooting into the metal bracket.

## FAQ
- **Q: I see an "Invalid connection" message. What does this mean?**
- **A:** You likely did not select any valid studs or the selected beams are not perpendicular to the wall element. Select at least one valid stud and try again.
- **Q: How do I switch between a Left-hand and Right-hand connector?**
- **A:** Select the connector, open the Properties Palette (Ctrl+1), and change the **Type** property (e.g., change `...L-B` to `...R-B`).
- **Q: Why is my drill hole the wrong size?**
- **A:** The drill hole size is tied to the Type property. Ensure you have selected the correct hardware variant (HD2P1 uses 9mm, HD2P2 uses 6.5mm).