# HSB_G-ContentFormat

## Overview
This script acts as a data inspector and verification tool for timber entities. It allows you to extract specific property data from a selected element (like material or beam code) and check if it contains a target value, which is useful for filtering or quality control.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is designed to work on 3D model elements. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: You must select a single timber entity (Beam, Wall, Panel) when inserting the script.
- **Minimum Beam Count**: N/A (User selects entity interactively).
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-ContentFormat.mcr` from the list.

### Step 2: Select Target Entity
```
Command Line: Select entity
Action: Click on the timber element (beam, panel, etc.) you wish to inspect.
```

### Step 3: Configure Properties
Once the script is inserted and the entity is linked, select the script instance in AutoCAD and open the **Properties Palette** (Ctrl+1).
1.  **Content**: Enter the data format you wish to extract (e.g., `@(Material)` or `@(Beamcode)`).
2.  **Value**: Enter the text you expect to find in that data (e.g., `CLS`).

### Step 4: Verify Data
- To see a list of all available properties for the selected entity, right-click the script instance and choose **Show Available Properties**.
- Press **F2** to open the AutoCAD Text Window and view the full list of properties.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **\|Content\|** | Text | `@(Material)` | The format string used to extract data from the entity. Use tokens like `@(PropertyName)` to access Automatic Properties (e.g., Material, Beamcode). |
| **\|Value\|** | Text | `CLS` | The specific text string to search for within the extracted content. You can use `*` as a wildcard and `;` to separate multiple values. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **\|Show Available Properties\|** | Displays a comprehensive list of all properties (Automatic, MapX, Project Data, and TSL properties) associated with the selected entity in the command line history. |

## Tips
- **Finding Property Names**: If you don't know the exact name of a property (e.g., is it "Width" or "WidthPlane"?), use the **Show Available Properties** context menu option to dump the exact list to the text window.
- **Wildcards**: In the **Value** parameter, use `*` to match parts of a string. For example, searching for `C*` would find "CLS", "C24", etc.
- **Multiple Checks**: You can check for multiple values at once by separating them with a semicolon (e.g., `CLS;C24`).

## FAQ
- **Q: What does the `@()` syntax mean?**
  **A:** This is a placeholder syntax that tells the script to look for an Automatic Property. Anything inside the parentheses (e.g., `@(Material)`) corresponds to a standard property defined in the hsbCAD database.

- **Q: I selected an entity but got an error.**
  **A:** Ensure the entity is a valid hsbCAD timber object (GenBeam, MasterPanel, etc.). Standard AutoCAD lines or polylines will not work.

- **Q: Where can I see the result of the check?**
  **A:** The script updates its internal state based on the check. While it does not create geometry, the "FormatValueFound" status is updated internally, which can be used by other scripts or filtering processes.