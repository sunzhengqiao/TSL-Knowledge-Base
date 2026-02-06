# hsbCAD Electrical Fixture

## Overview
Inserts electrical fixtures (e.g., sockets, switches, aerials) into timber wall elements and links them to specific electrical circuits to generate manufacturing data and visualizations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment to calculate geometry and assign tools to elements. |
| Paper Space | No | This script does not function in layout views. |
| Shop Drawing | No | This script is for detailing and manufacturing, not for generating 2D shop drawings directly. |

## Prerequisites
- **Required Entities**:
  - An existing **Element** (Wall) in the model.
  - An existing **Electrical Circuit** TSL instance in the model.
- **Minimum Beam Count**: 0 (This script targets Elements, not individual beams).
- **Required Settings Files**:
  - `electricallibrary.xml` must be present in the hsbCAD Content folder (`...\Content\UK\TSL\Standard\Electrical\`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCAD_Electrical Fixture.mcr` from the available scripts list.

### Step 2: Specify Height
```
Command Line: Height
Action: Type the vertical elevation (in mm) where the fixture should be placed relative to the element's coordinate origin. Press Enter.
```

### Step 3: Specify Lateral Position
```
Command Line: Lateral Position
Action: Type the horizontal distance (in mm) from the element's coordinate origin. Press Enter.
```

### Step 4: Select Electrical Circuit
```
Command Line: Select electrical circuit
Action: Click on the existing 'Electrical Circuit' instance (TSL) in the drawing that you wish to associate this fixture with.
```

### Step 5: Configure Fixture
```
Action: The Properties Palette will open automatically.
1. Select the desired 'Fixture' type (e.g., Double Socket) from the dropdown list.
2. Adjust 'Milling Depth' if necessary (default is 0 for automatic calculation).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Circuit | String | None | (Read-only) Displays the name of the electrical circuit this fixture is linked to. |
| Fixture | Dropdown | *First in library* | Select the specific electrical device type (e.g., Double Socket, TV Aerial) from the library. |
| Milling Depth '0=Automatic' | Number | 0 | Sets the depth of the back box milling. **0** calculates depth based on sheathing zones automatically. Enter a value (mm) to override. |
| Turning direction | Dropdown | Against course | Determines the CNC tool travel direction: "Against course" or "With course". |
| Overshoot | Dropdown | No | Specifies if the CNC tool should overrun the cut profile ("Yes" or "No") to ensure clean edges. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *(None)* | This script does not add custom items to the right-click context menu. Use standard AutoCAD/hsbCAD commands to modify or erase the instance. |

## Settings Files
- **Filename**: `electricallibrary.xml`
- **Location**: `[hsbCAD Install Path]\Content\UK\TSL\Standard\Electrical\`
- **Purpose**: Provides the list of available fixtures, their internal codes, and geometry definitions used to populate the 'Fixture' dropdown and determine the correct symbol and milling type.

## Tips
- **Automatic Milling Depth**: Leave the 'Milling Depth' set to 0. The script will automatically sum the thickness of the wall's outer sheathing zones to determine the correct pocket depth.
- **Positioning**: The "Height" and "Lateral Position" are defined relative to the Element's local coordinate system. If you place a fixture incorrectly, you must erase the instance and re-insert it; these coordinates are not editable properties after insertion.
- **Circuit Linking**: Ensure you select the correct Circuit instance. The script draws a visual connection line to the circuit and exports the relationship to production data (DXA).
- **Milling Types**: Only specific fixture types (such as sockets requiring back boxes) will generate CNC milling operations. Items like switches or aerials may only generate visual symbols and data points.

## FAQ
- **Q: I get an error "No Electrical Library items found." What should I do?**
- **A:** Ensure that `electricallibrary.xml` exists in the correct directory (`...\Content\UK\TSL\Standard\Electrical\`). If the file is missing or corrupted, the script cannot load fixture definitions and will abort.

- **Q: Can I move the fixture after I have inserted it?**
- **A:** No. The insertion coordinates (Height and Lateral Position) are only requested during the initial insertion command (`_bOnInsert`). To move the fixture, you must erase the current instance and run the script again at the new location.

- **Q: Why is no CNC milling tool generated for my socket?**
- **A:** Check the 'Fixture' property you selected. Ensure it is a type defined in the library that requires routing (e.g., "Double Socket"). Also, verify that the element has valid material zones defined if you are using the Automatic Milling Depth setting.