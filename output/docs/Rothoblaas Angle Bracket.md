# Rothoblaas Angle Bracket - User Guide

## Overview

The Generic Angle Bracket script (GA.mcr) creates angle brackets for connecting timber beams. It supports multiple manufacturers including Rothoblaas, Simpson, and other angle bracket systems. This script automatically generates parametric angle bracket connections that adapt to beam geometry and include proper hardware specifications.

## Key Features

- **Multi-manufacturer support**: Rothoblaas, Simpson, and other angle bracket systems
- **Flexible configurations**: Works with 1 or 2 beams
- **Parametric design**: Automatically adjusts dimensions based on selected product
- **Milling options**: Male, female, or both milling types
- **Hardware integration**: Automatically includes bracket and fastener specifications
- **Interactive positioning**: Grip point control for precise placement

## Script Type
- **Type**: O-Object (Creates new entities)
- **Beams Required**: 0 (prompts for beams during insertion)
- **Grip Points**: 0 (position controlled by _PtG[0])

## Usage

### Basic Workflow

1. **Insert the Script**
   - Run the command: `TSLCONTENT`
   - Or browse to the script in hsbCAD

2. **Select Manufacturer**
   - Choose from available manufacturers (Rothoblaas, Simpson, etc.)
   - Selection determines available products and families

3. **Select Family/Product**
   - Choose the specific angle bracket family
   - Select the exact product model

4. **Select Connector Type**
   - Choose nails, screws, or other fastener types

5. **Position the Bracket**
   - Select the beam(s) to connect
   - Click to position the bracket

### Insertion Methods

#### Single Beam Connection
- Select one beam and a point
- Bracket automatically connects to the nearest face
- Right-click options to swap legs or rotate 180°

#### Double Beam Connection
- Select two intersecting beams
- Bracket connects at the intersection line
- Double-click to flip between beams

## User Properties (OPM)

### General Properties
| Property | Description | Values |
|----------|-------------|---------|
| **Manufacturer** | Bracket manufacturer | Rothoblaas, Simpson, etc. |
| **Family** | Product family | Specific to manufacturer |
| **Product** | Exact bracket model | Specific to family |
| **Nail/Screw** | Fastener type | Nails, screws, etc. |

### Milling Properties
| Property | Description | Values |
|----------|-------------|---------|
| **Milling Type** | Milling configuration | None, Male, Female, Both |
| **Tolerance** | Milling tolerance | Custom value (mm) |

### Single Beam Options
| Property | Description | Values |
|----------|-------------|---------|
| **Swap Legs** | Swap bracket legs | No, Yes |
| **Rotate 180°** | Rotate bracket | No, Yes |

## Hardware Integration

### Main Bracket Component
- **Manufacturer**: Set based on selection
- **Model**: Family description from XML
- **Dimensions**: Automatically set based on product specs
- **Material**: Defined in manufacturer settings

### Fastener Components
- **Type**: Based on selected nail/screw type
- **Quantity**: Defined in product specifications
- **Diameter**: Set according to requirements

## Positioning and Behavior

### Grip Point Control
- The grip point (_PtG[0]) controls the attachment face
- Moving the grip point automatically adjusts the bracket orientation
- _Pt0 follows the intersection line while maintaining connection

### Automatic Adjustments
- Bracket stays within beam boundaries
- Projects to intersection planes when beams move
- Maintains proper clearances and tolerances

## Context Menu Options

### For Double Beam Connections
- **Flip GenBeams**: Swap which beam is primary
- **Remove GenBeam**: Remove one beam from connection

### For Single Beam Connections
- **Swap Legs**: Exchange bracket leg positions
- **Rotate 180°**: Rotate bracket orientation
- **Add GenBeam**: Connect a second beam

## XML Configuration

The script reads configuration from:
- **Company Path**: `\TSL\Settings\AngleBracketCatalog.xml`
- **Installation Path**: `\Content\General\TSL\Settings\`

### XML Structure
```xml
<Hsb_Map>
  <lst nm="Manufacturer[]">
    <lst nm="ManufacturerName">
      <str nm="Name" vl="Rothoblaas"/>
      <str nm="Material" vl="Steel"/>
      <lst nm="Family[]">
        <lst nm="FamilyName">
          <str nm="Name" vl="Product Name"/>
          <str nm="Description" vl="Family Description"/>
          <lst nm="Product[]">
            <lst nm="ProductName">
              <dbl nm="A" vl="100"/>
              <dbl nm="B" vl="50"/>
              <dbl nm="C" vl="20"/>
              <dbl nm="t" vl="5"/>
            </lst>
          </lst>
          <lst nm="Nail[]">
            <lst nm="NailType">
              <str nm="Name" vl="Screw M8"/>
              <dbl nm="Diameter" vl="8"/>
              <int nm="Number" vl="4"/>
            </lst>
          </lst>
        </lst>
      </lst>
    </lst>
  </lst>
</Hsb_Map>
```

## Common Products

### Rothoblaas Angle Brackets
- **Typ F70**: Post base connections
- **Typ R**: General angle brackets
- **Typ X**: Specialized configurations
- **ALU**: Aluminum brackets
- **Titan**: Heavy-duty steel brackets

## Tips and Best Practices

### For Designers
1. **Double-click** to quickly flip between beams in double-beam connections
2. **Use grip points** for precise positioning when beams are not perfectly aligned
3. **Check milling type** for proper fit with connected components

### For CNC Fabrication
1. **Milling tolerance** ensures proper fit
2. **Both milling** option provides maximum flexibility
3. **Male milling** creates protrusions for tighter fits

### For Quantity Takeoff
1. **Hardware is automatically added** to the parts list
2. **Fastener quantities** are included based on product specs
3. **Multiple brackets** create separate hardware items

## Troubleshooting

### Common Issues

**"No Family found for manufacturer"**
- Check XML configuration files
- Verify manufacturer name in settings
- Ensure XML files are in correct locations

**"Bracket not positioning correctly"**
- Use grip point to reposition
- Check beam intersections
- Verify beam orientation

**"Milling not appearing"**
- Set milling type to "Male", "Female", or "Both"
- Check tolerance settings
- Verify material thickness matches specifications

## Version History

- **v2.16** (2024-09-13): Enhanced family validation for manufacturers
- **v2.15** (2022-10-07): Improved XML loading priority
- **v2.14** (2022-10-07): Updated XML structure with family descriptions
- **v2.13** (2022-09-09): New XML structure similar to GenericHanger
- **v2.12** (2022-09-07): XML renamed to AngleBracketCatalog
- **v2.11** (2020-02-07): Fixed milling rotation issues
- **v2.10** (2020-02-04): Fixed milling when rotated
- **v2.9** (2020-02-03): Added right-click options for rotation
- **v2.8** (2019-11-18): Fixed boundary calculation bugs

## Keyboard Shortcuts

- **Double-click**: Flip beams (double-beam) or rotate (single-beam)
- **Right-click**: Access context menu options
- **Enter**: Confirm selection without specifying point

## Related Scripts

- **GenericHanger**: Similar functionality for hanger connections
- **FastenerManager**: Manages fastener elements
- **hsb_PocketPointLoad**: Point load connections

---

*This documentation covers the Generic Angle Bracket script with specific focus on Rothoblaas products. For manufacturer-specific details, refer to the product catalogs and XML configuration files.*