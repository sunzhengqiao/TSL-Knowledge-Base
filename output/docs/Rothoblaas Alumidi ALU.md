# Rothoblaas Alumidi ALU Connector

## Overview

The Rothoblaas Alumidi ALU script creates aluminum alloy retractable connectors for timber construction joints. This TSL script supports three connector families: AluMini, AluMidi, and AluMaxi, designed for 90-degree and vertically inclined joints in both indoor and outdoor applications.

**Manufacturer**: Rothoblaas
**Website**: [www.rothoblaas.com](https://www.rothoblaas.com)
**Script Location**: `TSL/Rothoblaas ALU.mcr`
**Version**: 1.18 (June 27, 2025)

## Connector Families

| Family | Height Range (mm) | Description |
|--------|-------------------|-------------|
| **AluMini** | 65-215 | Compact connector for smaller timber connections |
| **AluMidi** | 80-440 | Medium-sized connector with versatile options |
| **AluMaxi** | 384-896 | Large connector for heavy-duty applications |

## Insertion Method

The script supports two insertion methods:

1. **Catalog-based insertion**:
   - Uses predefined catalog entries (MINI, MIDI, MAXI)
   - No dialog appears when catalog entry is specified
   - Properties are automatically set from catalog configuration

2. **Manual selection**:
   - Shows dialog for manual configuration
   - Requires selection of male and female beams

### Command Examples
```auto cad
; Insert with dialog
^C^C(hsb_scriptinsert "Rothoblaas Alu" "Mini")
^C^C(hsb_scriptinsert "Rothoblaas Alu" "Midi")
^C^C(hsb_scriptinsert "Rothoblaas Alu" "Maxi")

; Insert without dialog (using catalog)
^C^C(hsb_scriptinsert "Rothoblaas Alu" "Mini185 no holes")
```

## User Properties (OPM)

### General Properties
| Property | Description | Default | Options |
|----------|-------------|---------|---------|
| **Type** | Sets the type of bracket | Auto detect | Auto detect, 65, 80, 100, 120... (up to max height) |
| **Connection Mode** | Connection type and hardware option | Wood/Wood | AluMini: Wood/Wood<br>AluMidi: Wood/Wood, Wood/Concrete with Screw, Wood/Concrete with chemical Dowel<br>AluMaxi: Wood/Wood, Wood/Concrete with chemical Dowel |

### Shank Drills Properties
| Property | Description | Default |
|----------|-------------|---------|
| **Depth** | Depth of drill operation | 0mm |
| | Negative value changes drilling side | |

### Alignment Properties
| Property | Description | Default |
|----------|-------------|---------|
| **Gap between Beams** | Gap dimension between connected beams | 3mm |
| **Offset Z-Direction** | Vertical offset adjustment | 0mm |

### Housing Properties
| Property | Description | Default | Options |
|----------|-------------|---------|---------|
| **Housing Type** | Type of housing for the connector | Bottom | Bottom, Centered, Top, Full Height, None |
| **Gap** | Gap around metal part of housing | 0mm |
| **Extra depth** | Additional depth of beam cut | 0mm |

### Slot Properties
| Property | Description | Default | Options |
|----------|-------------|---------|---------|
| **Slot** | Location of slot in connector | Top | Top, Bottom, Full height |
| **Gap (X)** | Additional length of slot | 20mm |
| **Gap (Y)** | Additional width of slot | 2mm |
| **Gap (Z)** | Additional height of slot | 20mm |
| **Alignment** | Slot alignment reference | Female beam | Female beam, Male beam |

### Display Properties
| Property | Description | Default |
|----------|-------------|---------|
| **Color** | Display color number | 252 |
| **Dimstyle** | Dimension style | Standard |

## Context Menu Commands

Available context commands after insertion:
- **MINI**: Switch to AluMini connector (if not already)
- **MIDI**: Switch to AluMidi connector (if not already)
- **MAXI**: Switch to AluMaxi connector (if not already)
- **Extend length to be cut from rod**: Extends available types to maximum rod length
- **Flip drill side**: Changes the side of drilling operation

## Technical Specifications

### AluMini Connector
- **Height**: 30mm
- **Thickness s1**: 6mm
- **Thickness s2**: 6mm
- **Width LA**: 45mm
- **Steglange LB**: 109.9mm
- **Small holes diameter**: 7mm
- **Small holes fixings**: HBS+ Screw (7 qty base)
- **Shank holes fastening**: Diameter 0mm (none)

### AluMidi Connector
- **Height**: 40mm
- **Thickness s1**: 6mm
- **Thickness s2**: 6mm
- **Width LA**: 80mm
- **Steglange LB**: 109.4mm
- **Small holes diameter**: 5mm
- **Small holes fixings**: Anker nail (10 qty base)
- **Big holes diameter**: 9mm
- **Big holes fixings**: Chemical dowel (3 qty base)
- **Shank holes fastening**: Diameter 13mm

### AluMaxi Connector
- **Height**: 64mm
- **Thickness s1**: 10mm
- **Thickness s2**: 12mm
- **Width LA**: 130mm
- **Steglange LB**: 172mm
- **Small holes diameter**: 7.5mm
- **Small holes fixings**: Anker nail (24 qty base)
- **Big holes diameter**: 17mm
- **Big holes fixings**: Chemical dowel (6 qty base)
- **Shank holes fastening**: Diameter 17mm

## Usage Instructions

1. **Insert the connector**:
   - Run the command and select either catalog entry (for predefined settings) or manual selection
   - If manual selection is chosen, the dialog will appear

2. **Select beams**:
   - Select one or multiple male beams
   - Select female beams that will connect to the male beams
   - The script will automatically detect compatible connections

3. **Adjust properties**:
   - Use the OPM Properties Palette to modify connector parameters
   - Change connector type, connection mode, housing type, and other options as needed

4. **Context menu commands**:
   - Right-click on the inserted connector for additional options
   - Use family commands to switch between connector types
   - Use "Extend length" to access additional size options

## Notes

- The script automatically detects T-connections between selected beams
- Connector dimensions are optimized for perpendicular connections (±2° tolerance)
- HSB-21424: Number of screws corrected in version 1.18
- HSB-21424: Added H400 and H440 options for AluMidi in version 1.17
- HSB-19683: Added property for slot alignment in version 1.15
- The connector works with both metric and imperial units through the TSL unit conversion system