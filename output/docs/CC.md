# CC - Concealed Connector for Wall Panels

## Overview

The CC script creates concealed connectors (specifically Knapp Walco Z40 and Z32 connectors) for connecting prefabricated wall panels. These blue-galvanized steel brackets create a dovetail-like connection that tightens when wall panels are slid together.

### Key Features
- Creates concealed connectors for wall panel connections
- Supports Knapp Walco Z40 and Z32 connector types
- Works with two parallel beams from different walls
- Automatic tooling application (drills and milling)
- Distribution mode for multiple connectors
- Marking option for installation identification

## Supported Hardware

### Connector Types
- **Knapp Walco Z40**: Standard connector (40mm width)
- **Knapp Walco Z32**: Narrow connector (32mm width)

### Manufacturer Support
- Knapp (primary manufacturer)
- Other manufacturers configurable via XML settings

## Insertion Modes

### 1. Single Instances at Studs
Places individual connectors at selected studs on two walls.

**Workflow:**
1. Select first vertical stud (principal beam)
2. Select second parallel stud (connecting beam)
3. Connector automatically positioned at the connection point

### 2. Distribution at Studs
Places multiple connectors along a distribution line.

**Parameters:**
- **Quantity**: Number of connectors to place
- **Interdistance**: Space between connectors
- **Start**: Distance from beginning of distribution
- **End**: Distance from end of distribution
- **Distribution Mode**:
  - Equally: Automatic spacing
  - Fixed: Use exact interdistance

## Properties

### Product Selection
| Property | Description | Options |
|---------|-------------|---------|
| Manufacturer | Connector manufacturer | List from XML configuration |
| Product | Specific connector type | Depends on selected manufacturer |

### General Properties
| Property | Description | Default |
|---------|-------------|---------|
| Insertion Mode | How connectors are placed | Single Instances at Studs |

### Distribution Properties
| Property | Description | Default |
|---------|-------------|---------|
| Quantity | Number of connectors | 1 |
| Interdistance | Space between connectors | 500mm |
| Start | Starting distance | 100mm |
| End | Ending distance | 100mm |
| Distribution Mode | Spacing method | Equally |

### Tooling Properties
| Property | Description | Default |
|---------|-------------|---------|
| Drill Depth | Depth for drilling operations | 40mm |
| Drill Diameter | Diameter for drilling operations | 6mm |
| Milling Width | Width for milling operations | 45mm |
| Milling Depth | Total milling depth for both connectors | 15mm |

### Position Properties
| Property | Description | Default |
|---------|-------------|---------|
| Offset Z | Side offset of connector | 0mm |
| Offset X | Depth offset of connector | 0mm |

### Marking Properties
| Property | Description | Options |
|---------|-------------|---------|
| Marking | Add installation marks | No, Yes |

## Usage Instructions

### Basic Connection
1. **Select CC** from the tool palette
2. **Choose Manufacturer** and **Product** from dropdown lists
3. **Select Insertion Mode**:
   - Single: Place one connector pair
   - Distribution: Place multiple connectors
4. **Select two vertical studs** from different walls
5. **Adjust properties** as needed:
   - Tooling parameters for drilling/milling
   - Offsets for positioning
   - Marking for identification

### Distribution Mode
1. Set **Quantity**, **Interdistance**, **Start**, and **End** values
2. Select the two parallel studs
3. Connectors automatically distributed along the stud alignment

### Connector Swapping
- Right-click and select **"Swap Connectors"** to reverse male/female orientation
- Automatically adjusts offsets when swapped

### Exploding Distribution
- Right-click and select **"Explode distribution"** to convert distributed connectors into individual instances

## Technical Details

### Beam Requirements
- Must select two vertical studs
- Beams must be parallel
- Beams must belong to two different walls
- Maximum distance between beams: 100mm

### Connector Orientation
- **Male connector**: Attached to first selected beam
- **Female connector**: Attached to second selected beam
- Connectors automatically oriented based on beam alignment

### Tooling Application
- **Drills**: Applied based on XML specifications
- **Milling**: Creates recesses for connector installation
- Marking: Adds installation marks when enabled

## XML Configuration

The script reads configuration from:
- Company path: `TSL\Settings\CC.xml`
- Installation path: `Content\General\TSL\Settings\CC.xml`

### Configuration Structure
```xml
<Manufacturer>
  <Product>
    <Geometry>  <!-- 3D models -->
    <Tool>      <!-- Drilling/milling parameters -->
    <Hardware>  <!-- Connector hardware list -->
```

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.5 | 01/04/2025 | Fix group assignment, fix connector position |
| 1.4 | 01/04/2025 | Fix position of connector |
| 1.3 | 20/03/2025 | Add "Marking" property, add color parameter in XML |
| 1.2 | 24/06/2024 | Add tooling (drill, milling) parameters as instance properties |
| 1.1 | 21/06/2024 | Add mode distribution at 2 studs |
| 1.0 | 10/04/2024 | Initial release |

## Best Practices

1. **Beam Selection**: Always select vertical studs for proper alignment
2. **Distance Check**: Ensure beams are within 100mm of each other
3. **Tooling Settings**: Adjust drill/milling parameters based on material thickness
4. **Marking**: Enable marking for complex installations to aid identification
5. **Distribution**: Use distribution mode for multiple connections along a wall line

## Troubleshooting

### Common Issues
- **"2 beams not parallel"**: Select properly aligned vertical studs
- **"2 beams too far apart"**: Ensure beams are within 100mm
- **"2 beams must belong to 2 SF walls"**: Select beams from different wall elements
- **"2 Beams can not be connected"**: Check beam orientation and proximity

### Tips
- Use visual debugging (if available) to see beam alignment
- Test connector placement in a small area first
- Verify hardware quantities in XML configuration