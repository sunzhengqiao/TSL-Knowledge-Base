# ModelDimension.mcr

## Overview
Automatically generates dimension lines for specific timber machining (such as cuts, drills, or housings) on beams within the 3D model or on 2D shop drawings (MultiPages). It allows users to define rules based on tool types to create intelligent, model-driven annotations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Select a GenBeam to dimension tools in 3D. |
| Paper Space | Yes | Select a MultiPage (Shop Drawing) frame to dimension tools in 2D views. |
| Shop Drawing | Yes | Fully integrated with MultiPage views and coordinate systems. |

## Prerequisites
- **Required Entities**: A `GenBeam` (in Model Space) or a `MultiPage` (in Paper Space).
- **Minimum Beams**: 1.
- **Required Settings**: `ModelDimension.xml` (Located in `Company\TSL\Settings` or `Install\Content\General\TSL\Settings`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `ModelDimension.mcr` from the list.

### Step 2: Select Target Entity
```
Command Line: Select multipage or GenBeam
Action: Click on a timber beam in the model view OR click the border of a shop drawing page in a layout.
```
*After selection, the script instance is created attached to that entity.*

### Step 3: Configure Dimensions
*Note: The script does not automatically draw dimensions immediately upon insertion. You must define rules via the Right-Click menu.*
1.  Select the newly inserted script instance.
2.  Right-click and choose **|Append Tool|** to define what to dimension.
3.  Follow the prompts to pick a specific tool (e.g., a cut or drill) graphically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tool Type | Dropdown | Dynamic | The general category of the machining to dimension (e.g., *AnalysedBeamCut*, *AnalysedDrill*). |
| Subtype | Dropdown | Dynamic | The specific type of machining (e.g., *Birdsmouth*, *SeatCut*, *Perpendicular*). Selecting "All Types" applies dimensions to every tool in the category. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **|Set View|** | Opens a dialog to configure specific views (e.g., Plan, Elevation) where the dimensions should appear. |
| **|Append Tool|** | Starts a graphical selection process. Click on a specific cut or drill in the model/drawing to add a rule for dimensioning that specific tool type. |
| **|Add Points|** | Allows manual selection of points on the screen to create custom dimension lines not tied to a specific tool. |
| **|Renove Tool|** | Opens a list of currently active tool rules. Select one to remove it and stop generating dimensions for that specific tool type. |

## Settings Files
- **Filename**: `ModelDimension.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings` or `_kPathHsbInstall\Content\General\TSL\Settings`
- **Purpose**: Defines the available stereotypes, tool mappings, and version information for model dimensioning.

## Tips
- **Stacking Rules**: You can use the **|Append Tool|** command multiple times on the same script. This allows you to dimension different features (e.g., all Birdsmouth cuts AND all Perpendicular drills) using a single script instance.
- **Manual Override**: If the automatic tool detection misses a detail, use **|Add Points|** to manually dimension that specific location.
- **Clean Up**: If dimensions disappear or look wrong, check if the beam or tool definitions have changed. Use **|Renove Tool|** to clear conflicting rules and re-add them.
- **View Specificity**: Use **|Set View|** to ensure dimensions only appear in the correct elevation or plan view, keeping other views clean.

## FAQ
- **Q: Why don't I see dimensions immediately after inserting the script?**
  - **A**: The script requires configuration. You must right-click the script instance and select **|Append Tool|** or **|Add Points|** to define what needs to be dimensioned.
- **Q: Can I use this in both the 3D model and the 2D drawings?**
  - **A**: Yes. When inserting, simply select a beam for 3D model dimensions, or select a MultiPage frame for 2D shop drawing dimensions.
- **Q: How do I dimension a specific type of cut?**
  - **A**: Right-click the script, choose **|Append Tool|**, and then click directly on the cut in the drawing/model. The script will automatically detect its type and create a rule for it.