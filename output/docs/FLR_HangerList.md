# FLR_HangerList

## Overview

| Property | Value |
|----------|-------|
| **Script Name** | FLR_HangerList |
| **Type** | O (Object) |
| **Version** | 9.1 |
| **Category** | Floor Framing / Hardware Configuration |
| **Purpose** | Database configuration script that populates the Simpson/USP hanger catalog for floor framing applications |

## Description

FLR_HangerList is a **configuration utility script** that creates and maintains a comprehensive database of joist hanger specifications. When executed, it populates a MapObject named "Hangers/Simpson" with detailed specifications for over 100 different hanger models from Simpson Strong-Tie and USP brands.

This script serves as the **central hanger catalog** used by floor framing scripts (such as FLR_SimpsonHanger) to automatically select and insert appropriate hangers based on joist dimensions and configurations.

## Usage Environment

| Environment | Supported |
|-------------|-----------|
| Model Space | Yes |
| Paper Space | No |
| Shop Drawing | No |
| Requires Selection | No |

## How It Works

### Execution Flow

1. **Insert the script** into the drawing
2. **Automatic execution** - The script immediately runs its configuration routine
3. **Database population** - All hanger definitions are stored in the MapObject system
4. **Auto-cleanup** - The script instance erases itself after completion
5. **Report** - A confirmation message displays the number of hanger entries loaded

### MapObject Storage

- **Dictionary Key**: `"Hangers"`
- **Sub-key**: `"Simpson"`
- **Access Pattern**: `MapObject("Hangers", "Simpson")`

## Hanger Catalog Structure

Each hanger entry in the catalog contains the following specifications:

### Hanger Properties

| Property | Type | Description |
|----------|------|-------------|
| **dWidth** | Double | Hanger width (joist pocket width) |
| **dJoistHeight** | Double | Maximum joist height the hanger accommodates |
| **dHangerHeight** | Double | Vertical height of the hanger itself |
| **stType** | String | Hanger mounting type (see below) |
| **stWebStiff** | String | Requires web stiffener ("Y" or "N") |
| **stSingleJoist** | String | Compatible single joist profiles |
| **stAngleJoist** | String | Compatible angled joist profiles |
| **stDoubleJoist** | String | Compatible double joist profiles |
| **stTripleJoist** | String | Compatible triple joist profiles |
| **stQuadJoist** | String | Compatible quad joist profiles |
| **stFaceNails** | String | Face nail specification (count-size) |
| **stTopNails** | String | Top nail specification (count-size) |
| **stJoistNails** | String | Joist nail specification (count-size) |
| **stFaceNailsMin** | String | Minimum face nails required |
| **stTopNailsMin** | String | Minimum top nails required |
| **stJoistNailsMin** | String | Minimum joist nails required |

### Hanger Types

| Type Code | Description |
|-----------|-------------|
| **TT** | Top Tab - Small tab present on top of header |
| **F** | Face - Hanger exists solely on face of header, nothing on top |
| **TF** | Top Flange - Flange exists on top of header with nail holes |
| **S** | Skewable - Designed for angled conditions (joist not perpendicular to header) |

## Supported Hanger Models

The catalog includes hangers from two major manufacturers:

### Simpson Strong-Tie Hangers

| Series | Description |
|--------|-------------|
| **HU Series** | Face-mount hangers (HU14, HU3511, HU3516/22, HU416) |
| **HUS Series** | Heavy universal skewable (HUS26, HUS46, HUS48, HUS410, HUS412) |
| **HUC Series** | Concealed flange hangers (HUC410, HUC412, HUC416) |
| **HGUS Series** | Heavy gauge universal skewable (HGUS26-2, HGUS28-2, HGUS26-3, HGUS28-3, HGUS410, HGUS412, HGUS414, HGUS212-4) |
| **HHUS Series** | Heavy hanger universal skewable (HHUS26-2, HHUS46) |
| **IUS Series** | Installed universal skewable (IUS1.81/11.88, IUS2.37/11.88, IUS3.56/16) |
| **ITS Series** | Installed top flange skewable (ITS1.81/11.88, ITS2.37/11.88, ITS3.56/16) |
| **MIU Series** | Modified installed universal (MIU1.81/9, MIU1.81/16, MIU2.37/16, MIU3.56/16, MIU4.75/16) |
| **THA/THAC Series** | Twist hanger adjustable (THA422, THAC422, THA426, THAC426) |
| **MSH Series** | Medium skewable hanger (MSH422, MSH426) |

### USP Compatible Hangers

| USP Model | Simpson Equivalent |
|-----------|-------------------|
| THF17112 | IUS1.81/11.88 |
| THF17157 | IUS1.81/16 |
| THF23118 | IUS2.37/11.88 |
| THF23160 | IUS2.37/16 |
| THF35157 | IUS3.56/16 |
| THO17118 | ITS1.81/11.88 |
| THO35160 | ITS3.56/16 |
| TFL1716 | ITS1.81/16 |
| TFL23118 | ITS2.37/11.88 |
| TFL2316 | ITS2.37/16 |
| THDH Series | HGUS equivalents (THDH26-2, THDH28-2, THDH410, THDH412, THDH414) |
| THD Series | HHUS equivalents (THD26-2, THD46) |
| HDIF Series | HUC equivalents (HDIF410, HDIF412, HDIF416) |
| HD Series | HU equivalents (HD416) |
| HUS Series | Direct USP equivalents (USP HUS26, USP HUS46, USP HUS48, USP HUS410) |
| JUS28-2 | LUS28-2 |

## Compatible Joist Profiles

The hanger catalog supports various joist types:

### BCI Joists (Boise Cascade)
- BCI 4500s (1.8" flange width)
- BCI 60s (2.0" flange width)
- BCI 6000s (1.8" flange width)
- BCI 90s (2.0" flange width)

### VERSA-LAM (Boise Cascade)
- VERSA-LAM 1.7
- VERSA-LAM 2.0

### Other Profiles
- Flat Girder (2x4x16, 2x4x18, 2x4x20)
- Floor Truss (4x2x16, 4x2x18, 4x2x20)

## Usage Workflow

### Step 1: Launch Script

1. Type `TSLINSERT` in the AutoCAD command line
2. Browse to the location of `FLR_HangerList.mcr` and select it
3. Click **Open**

### Step 2: Execute Script

1. Click anywhere in Model Space to insert the script instance
2. The script executes immediately
3. A confirmation message displays: "Set Map with [N] Hanger Entries"
4. The script instance automatically deletes itself

### Step 3: Verification

- The hanger database is now available for use by other modeling scripts
- No persistent geometry remains in the drawing

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not create a persistent object; therefore, there are no properties to edit in the Properties Palette. |

## Context Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | The script instance is removed immediately after execution, so no context menu is available. |

## Technical Notes

### Version History

| Version | Date | Changes |
|---------|------|---------|
| 9.1 | 11/21/2020 | Changed THA and THAC hangers to TT type instead of S |
| 9.0 | 03/05/2020 | Added USP JUS28-2 |
| 8.9 | 09/16/2019 | Added IUS3.56/16 |
| 8.8 | 10/03/2019 | Added HGUS/THDH 26-2, 28-2, 26-3, 28-3 and HHUS46/THD46 |
| 8.7 | 09/10/2019 | Added HGUS212-4 |
| 8.6 | 08/09/2019 | Added HHUS26-2 |
| 8.5 | 08/09/2019 | Added HUS412 |
| 8.4 | 08/03/2019 | Added HU3516/22 |
| 8.3 | 07/11/2019 | Added HUS48, revised to USP HUS48 |
| 8.2 | 07/10/2019 | Added THA422, THAC422, MSH422, THA426, THAC426, MSH426 |
| 8.1 | 07/02/2019 | Added HUS46 and USP equivalents |
| 8.0 | 07/01/2019 | Added HUS26 and USP equivalents |
| 7.9 | 06/24/2019 | Added HU14 |
| 7.8 | 08/18/2018 | Fixed 11.88 hangers to work on 16" joist |
| 7.7 | 01/09/2017 | Added HU3511 |
| 7.6 | 10/12/2016 | Fixed MUI4.75/16 insertion issue |
| 7.5 | 10/12/2016 | Added MIU3.56/16, MIU1.81/11 |
| 7.4 | 09/12/2016 | Added MUI1.81/16 |
| 7.3 | 09/12/2016 | Added MIU2.37/16 |
| 7.2 | 08/08/2016 | Added MIU1.81/9 |
| 7.1 | 06/13/2016 | Added HGUS28-2 |
| 7.0 | 09/12/2014 | Added USP equivalent hangers |
| 6.9 | 09/11/2014 | Added and revised hangers |
| 6.8 | 07/10/2014 | Added DWG name to map object for trigger in slave TSL |

### Unit System

- **Working Units**: Inches (imperial system)
- All dimensions are stored in drawing units via the `U()` conversion function

## Tips and Best Practices

1. **Run Periodically**: Execute this script when you need to refresh the hanger database with the latest specifications

2. **No User Interaction Required**: The script runs automatically upon insertion - no configuration dialogs

3. **Drawing-Specific Storage**: The hanger database is stored per-drawing in the MapObject system

4. **Manufacturer Selection**: Both Simpson and USP hangers are loaded simultaneously; floor framing scripts allow selection between brands

5. **Profile Compatibility**: When using hangers, ensure your joist profiles match the compatibility lists defined in the catalog

6. **Nail Specifications**: Refer to the nail specifications (FaceNails, TopNails, JoistNails) for proper installation requirements

7. **One-Time Use**: You typically only need to run this script once per project or when updating to a new version of the hanger library

8. **Overwrite Behavior**: If you run the script multiple times, it will overwrite the existing hanger database with the definitions in the current version

## FAQ

**Q: I inserted the script, but it disappeared immediately. Did it fail?**
- A: No. This is the expected behavior. The script is designed to load data and then delete its own instance to keep the drawing clean.

**Q: Where can I see the hangers that were loaded?**
- A: The hangers are now part of the internal database. They will appear as options in other scripts that require joist hanger selection (e.g., floor generation or beam connection tools).

**Q: Can I edit the hanger sizes?**
- A: Not through this script. To modify dimensions, you would need to edit the source code of `FLR_HangerList.mcr` or manually adjust the resulting MapObject entries using advanced database tools.

## Related Scripts

- **FLR_SimpsonHanger** - Uses this catalog to insert hangers at joist-to-header connections
- **GenericHanger** - General-purpose hanger tool that may reference this data
- **FastenerEditor** - May use nail specifications from hanger data

## See Also

- Simpson Strong-Tie product catalog for load ratings and installation details
- USP Structural Connectors product specifications
- hsbCAD documentation on floor framing workflows
