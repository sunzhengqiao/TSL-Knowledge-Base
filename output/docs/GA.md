# GA.mcr

## Overview
Inserts and manages generic angle bracket connections (metal L-plates) between timber elements. It automates the creation of 3D geometry, beam milling/pocketing, and BOM data for manufacturing lists.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D geometry and beam processing. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities**: GenBeam, GenSheet, or GenPanel (1 or 2 elements).
- **Minimum beam count**: 1.
- **Required settings files**: `AngleBracketCatalog.xml` (or `GenericAngle.xml`) located in the Company or Content\General installation folder.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse to the script location and select `GA.mcr`.

### Step 2: Select Timber Elements
```
Command Line: Select GenBeam/GenSheet/GenPanel:
Action: Click on the primary timber element you wish to connect.
```
*(Note: The script allows selecting a second element immediately after for beam-to-beam connections, or you can press Enter to proceed with a single beam).*

### Step 3: Define Insertion Point
```
Command Line: Specify insertion point:
Action: Click on the face or edge of the selected beam where the bracket should be placed.
```
*   **Single Beam:** The script snaps to the nearest edge based on your click.
*   **Two Beams:** The point defines the intersection line where the two beams meet.

### Step 4: Configure Properties
**Action:** The script inserts the default bracket. Use the **Properties Palette** (Ctrl+1) to select the specific Family, Manufacturer, and Product code required for your design.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sFamily | Dropdown | From XML | The profile family of the angle bracket (e.g., Standard L-Bracket). This determines the base geometric dimensions (Height, Width, Thickness). |
| sProduct | Dropdown | From XML | The specific article number or SKU for purchasing and production lists. |
| sManufacturer | Dropdown | From XML | The supplier of the hardware component. |
| sNail | String | From XML | The article number of the fasteners (nails/screws) used to secure the bracket. |
| iMillingType | Integer | 1 | Machining strategy: 1 (Standard/Surface), 2, or 3 (Recessed/Pocket). Determines how deep the timber is cut. |
| dTolerance | Double | 0.0 mm | Additional clearance added to the cut dimensions. Increase this if the bracket fits too tightly. |
| iRotate180 | Integer | 0 | Flips the orientation of the bracket 180 degrees around the insertion axis (0 = No, 1 = Yes). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap Legs | Swaps the primary and secondary beam roles (flips the connection orientation). Available only for 2-beam connections. |
| Rotate 180 | Flips the bracket orientation relative to the insertion axis without changing the assigned beams. |

## Settings Files
- **Filename**: `AngleBracketCatalog.xml` or `GenericAngle.xml`
- **Location**: `hsbCompany` folder or `Content\General` installation path.
- **Purpose**: Provides the database of available manufacturers, families, product codes, dimensions (dA, dB, dC, dt), and associated fasteners.

## Tips
- **Grip Editing:** Select the inserted bracket to reveal the grip point. Drag the grip along the beam edge to reposition the connection quickly.
- **Double-Click:** Double-clicking an existing connection on two beams acts as a shortcut to "Swap Legs."
- **Recessing:** If you need the bracket to sit inside the timber (flush mount), change the `iMillingType` to 3.
- **Clearance:** If the manufacturing report indicates the pocket is too small, increase the `dTolerance` value in small increments (e.g., 1.0 mm).

## FAQ
- **Q: What happens if the script asks for an XML file?**
  **A:** The script cannot find the required catalog. Ensure your CAD administrator has placed the correct `AngleBracketCatalog.xml` in the correct Company or Content folder.
- **Q: Can I connect more than two beams?**
  **A:** No, this script is designed for single-beam anchoring or connections between exactly two beams.
- **Q: Why does my bracket look rotated wrong?**
  **A:** Use the `iRotate180` property in the Properties Palette or select "Rotate 180" from the right-click context menu.