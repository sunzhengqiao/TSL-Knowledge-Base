# HSB_E-Identification & Marking

## Overview
Automatically labels timber beams within an element with production marks (Position, Element, and Project numbers) and sets machining reference faces for assembly and manufacturing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D Elements and GenBeams. |
| Paper Space | No | Not designed for 2D drawings or layouts. |
| Shop Drawing | No | Does not generate shop drawing views directly. |

## Prerequisites
- **Required Entities**: An existing Element (e.g., Wall, Roof, Floor) containing GenBeams.
- **Minimum Beam Count**: 1.
- **Required Settings Files**: `HSB_G-FilterGenBeams` (Optional, used for advanced beam filtering).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `HSB_E-Identification & Marking.mcr` from the file dialog.

### Step 2: Select Element
```
Command Line: Select Element:
Action: Click on the desired Element (Wall/Panel) in the Model Space.
```
Note: Once selected, the script attaches to the element. No further command line input is required; all configuration is done via the Properties Palette.

### Step 3: Configure Properties
Action: Select the newly attached script instance in the model (or select the Element and find the script in the Properties Palette under "Data") to adjust marking settings.

## Properties Panel Parameters

### General Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Identifier | Text | "" | Unique tag for this script instance. Only one instance per identifier can be attached to an element. Use this to run multiple marking configurations on the same element. |
| Preferred beam face | Dropdown | |Outside| | Sets the preferred marking face (Outside or Inside) based on the element orientation. |

### Filters
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter definition female beams | Dropdown | "" | Select a predefined filter for female beams (referencing HSB_G-FilterGenBeams). |
| Female beam codes to filter | Text | "" | Filter female beams by specific beam codes. **Note:** Only applies if the Filter Definition above is blank. |
| Filter definition male beams | Dropdown | "" | Select a predefined filter for male beams. |
| Male beam codes to filter | Text | "" | Filter male beams by specific beam codes. **Note:** Only applies if the Filter Definition above is blank. |

### Identification
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Add beam identification | Dropdown | |Yes| | Enable or disable beam identification marking. |
| Add beam ID for beams longer than | Number | 0 | Minimum beam length required to print the Beam ID. |
| Add element number for beams longer than | Number | 250 | Minimum beam length required to print the Element Number. |
| Add project number for beams longer than | Number | 500 | Minimum beam length required to print the Project Number. |
| Override beam identification | Text | "" | Custom text to override the standard identification. |
| Position Text | Dropdown | |Center| | Sets the text position along the beam (Start, Center, or End). |
| Offset Text | Number | 0 | Specifies the offset distance for the text. |
| UCS used for position | Dropdown | |Use beam ucs| | Coordinate system used for positioning the text (Beam UCS or Element UCS). |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams`
- **Location**: Company or Install path (`_kPathHsbCompany` or `_kPathHsbInstall`)
- **Purpose**: Provides a list of named filter definitions to be used in the "Filter definition" properties.

## Tips
- **Multiple Instances**: You can attach this script multiple times to the same element (e.g., one for the top plate, one for the bottom plate) by using different **Identifier** values.
- **Face Selection**: Ensure your elements have correct inside/outside orientation defined, as the script relies on this to place the marks.
- **Length Control**: Use the length minimum parameters to prevent cluttering small offcuts or blocking hardware with text.
- **Filtering Hierarchy**: The script checks the "Filter definition" first. If that is empty, it falls back to the "Beam codes to filter" field.

## FAQ
- **Q: Why are some beams not getting marked even though "Add beam identification" is Yes?**
  - A: Check the **Minimum length** settings; if a beam is shorter than the defined value, the mark will be skipped. Also, verify that your **Filters** are not excluding the specific beam codes.
- **Q: Can I mark both the Inside and Outside faces of the element?**
  - A: Yes. Insert the script twice. Set one instance **Identifier** to "MarkOut" (Preferred face: Outside) and the second to "MarkIn" (Preferred face: Inside).
- **Q: What is the difference between Beam UCS and Element UCS for positioning?**
  - A: **Beam UCS** positions text relative to the individual beam's length and orientation. **Element UCS** positions text relative to the entire wall/panel's coordinate system.