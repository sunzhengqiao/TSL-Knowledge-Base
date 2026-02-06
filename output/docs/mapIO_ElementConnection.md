# mapIO_ElementConnection.mcr

## Overview
This script automatically analyzes the geometric relationship between two wall elements to determine their connection type (e.g., corner, T-junction, or mitre). It is primarily designed to run within the MapIO process to ensure correct fabrication data and connection properties are assigned during export.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script analyzes 3D wall geometry in the model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This script operates on 3D model elements, not 2D drawings. |

## Prerequisites
- **Required Entities**: 2 Wall Elements (`ElementWall`).
- **Minimum Beam Count**: 2
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `mapIO_ElementConnection.mcr` from the file dialog.

### Step 2: Select First Wall
```
Command Line: [Select Element]
Action: Click on the first wall element you wish to analyze.
```

### Step 3: Select Second Wall
```
Command Line: [Select Element]
Action: Click on the second wall element that connects to the first one.
```

### Step 4: Specify Location
```
Command Line: [Specify Point]
Action: Click a point near the intersection or connection area of the two walls.
```

### Step 5: Execution
The script will calculate the connection type. If run manually, it may report results to the command line. If run via MapIO, it updates the element data silently for downstream processing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose user-editable parameters in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No specific context menu items are added by this script. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: No external settings files are used by this script.

## Tips
- **Drawing Accuracy**: Ensure your wall elements intersect or touch accurately in the 3D model. The script uses a small tolerance (0.1 mm) to detect connections, but large gaps will prevent correct classification.
- **MapIO Automation**: While you can insert this script manually to check a connection, it is most effective when triggered automatically by the MapIO export process to batch-process all wall connections in a project.
- **Entity Types**: The script handles standard walls, SIP walls, and log walls, adjusting the connection logic (Corner vs. T-junction vs. Mitre) based on the specific wall types selected.

## FAQ
- **Q: Why did the script disappear immediately after I selected the elements?**
  - A: The script is designed to perform its analysis and then erase itself from the drawing once the logic is complete, especially if it detects an error (like fewer than 2 elements) or finishes successfully in a MapIO context.
- **Q: What connection types can this script identify?**
  - A: It can identify various types including Corner Male/Female, T-junction Male/Female, Mitre connections, Parallel connections, and specific SIP wall joints.
- **Q: Can I change the tolerance for detecting touching walls?**
  - A: The tolerance is hard-coded (0.1 mm) to maintain consistency across the project. You must ensure your model geometry meets this standard.