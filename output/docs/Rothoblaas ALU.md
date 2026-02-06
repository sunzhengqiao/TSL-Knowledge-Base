# Rothoblaas ALU

## Overview
Generates 3D geometry, machining (drills and slots), and BOM data for Rothoblaas ALU connectors (AluMini, AluMidi, AluMaxi) used for timber-to-timber or timber-to-concrete connections.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D solid bodies and applies machining to beams. |
| Paper Space | No | Does not create 2D annotations or drawings directly. |
| Shop Drawing | No | Does not generate shop drawing views. |

## Prerequisites
- **Required Entities**: At least 2 GenBeams.
- **Minimum Beam Count**: 2 (One Main Beam, one or more Secondary Beams).
- **Required Settings**: None (uses internal dimension catalogs).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Rothoblaas ALU.mcr`
*(Alternatively, launch via your custom Catalog or Toolbar if mapped).*

### Step 2: Select Main Beam
```
Command Line: Select Main Beam (Male):
Action: Click on the beam that will host the main shank of the connector.
```

### Step 3: Select Secondary Beams
```
Command Line: Select Secondary Beam(s) [Female]:
Action: Click on the intersecting beam(s) that will connect to the main beam.
        Press Enter to finish selection.
```

### Step 4: Configure Parameters
```
Action: Select the script instance in the model.
        Open the Properties Palette (Ctrl+1).
        Adjust the 'Family' and 'Type' to fit your structural requirements.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Family | Dropdown | MIDI | Selects the size series: **MINI** (Small), **MIDI** (Medium), or **MAXI** (Large). Determines thickness and height. |
| Type | Integer | 1 | The specific length configuration of the connector. Higher numbers indicate longer connectors with more fasteners. |
| Connector Mode | Dropdown | Wood/Wood (0) | **0**: Wood-to-Wood (uses nails/screws). **1**: Wood-to-Concrete/Steel (uses chemical dowels/anchors). |
| Shank Drills | Boolean | Yes | If **Yes**, drills the main beam completely through for the connector shank. |
| Slot Alignment | Dropdown | Auto | Controls the rotation of the slot/housing cut into the secondary beam (e.g., Top, Bottom, Auto). |
| Depth | Double | Auto | Sets the depth of drill holes if they are not through-holes (0 or negative often implies full depth). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Extend length to be cut from rod | Expands the available 'Type' list to include custom lengths up to the maximum available rod length from the manufacturer. |

## Settings Files
- **Internal Data**: Uses hardcoded dimension arrays for Mini, Midi, and Maxi series.
- **Mappings**: Can be configured via Execute Keys or Map files for pre-selecting families (optional).

## Tips
- **Auto-Detection**: The script attempts to auto-detect the largest fitting 'Type' based on the beam geometry. If the connector looks too small or large, manually adjust the 'Type' parameter.
- **Pillar Beams**: When using Wood-to-Wood mode on a vertical pillar, the script automatically reduces the quantity of nails on the wing to prevent splitting.
- **Visual Check**: Ensure the "Slot" in the secondary beam aligns correctly with the connector wings. Use the "Slot Alignment" property if the rotation is incorrect.

## FAQ
- **Q: Why are there no drills appearing in my main beam?**
  A: Check the **Shank Drills** property in the palette. If it is set to "No", the holes will not be generated.
- **Q: What happens if I switch Mode from Wood/Wood to Wood/Concrete?**
  A: The script replaces standard wood fasteners (like Anker nails) with heavy-duty fasteners (like Chemical dowels) and adjusts the hole sizes accordingly.
- **Q: How do I get a longer connector than the standard list allows?**
  A: Right-click the script instance and select **Extend length to be cut from rod**. This updates the catalog list to include extended lengths.