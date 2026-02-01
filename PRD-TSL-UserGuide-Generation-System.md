# PRD: TSL Script User Guide Auto-Generation System

## 1. Project Background

### 1.1 Current State
- TSL script library contains **1,218 .mcr files**
- These scripts are core functional extensions for hsbCAD (AutoCAD-based timber construction CAD system)
- Currently lacking end-user documentation

### 1.2 Objective
Use LLM API (GLM4/Claude) to batch-generate **user-facing guides** for each TSL script, targeting non-programmers.

### 1.3 Target User Profile
- **Role**: Timber structure designers, CAD operators
- **Technical Level**: Familiar with AutoCAD/hsbCAD operations, but no programming knowledge
- **Needs**: Know how to use each tool and adjust parameters

---

## 2. Script Classification System

### 2.1 Primary Category Statistics

| Category | Count | Percentage | Description |
|----------|-------|------------|-------------|
| **Base** | 407 | 33.4% | Base functionality scripts |
| **Function** | 222 | 18.2% | Functional modules |
| **Region** | 112 | 9.2% | Regional market specific |
| **Other** | 110 | 9.0% | Uncategorized |
| **StickFrame** | 91 | 7.5% | Frame structures |
| **Hardware** | 71 | 5.8% | Hardware vendors |
| **CLT** | 62 | 5.1% | Cross Laminated Timber |
| **Workflow** | 59 | 4.8% | Workflow processes |
| **Manufacturing** | 45 | 3.7% | Manufacturing related |
| **SIP** | 27 | 2.2% | Structural Insulated Panels |
| **MEP** | 12 | 1.0% | Mechanical/Electrical/Plumbing |

### 2.2 Hierarchical Category Structure

```
TSL Scripts (1218)
├── By Structure Type
│   ├── StickFrame/ (91)      # Frame structures
│   │   ├── Wall (52)         # Walls
│   │   ├── Roof (17)         # Roofs
│   │   ├── Floor (16)        # Floors
│   │   └── Truss (6)         # Trusses
│   ├── CLT/ (62)             # Cross Laminated Timber
│   └── SIP/ (27)             # Structural Insulated Panels
│
├── By Function Module Function/ (222)
│   ├── Element (75)          # Element operations HSB_E-*
│   ├── General (70)          # General functions HSB_G-*
│   ├── Display (21)          # Display functions HSB_D-*
│   ├── Tool (19)             # Tool operations HSB_T-*
│   ├── Core (13)             # Core functions HSB-*
│   ├── Info (12)             # Information queries HSB_I-*
│   ├── Panel (5)             # Panel functions HSB_P-*
│   ├── Sheet (4)             # Sheet operations HSB_S-*
│   └── Log (3)               # Log functions HSB_L-*
│
├── By Hardware Vendor Hardware/ (71)
│   ├── Simpson (17)          # Simpson StrongTie
│   ├── BMF (11)              # BMF hardware
│   ├── Rothoblaas (10)       # Rothoblaas fasteners
│   ├── Hilti (9)             # Hilti
│   ├── Alpine (4)            # Alpine load carriers
│   ├── Pitzl (4)             # Pitzl post bases
│   ├── GenericAngle (4)      # Generic angle brackets GA
│   ├── Generic (4)           # Generic hardware
│   ├── Merk (3)              # Merk hardware
│   ├── Sherpa (2)            # Sherpa connectors
│   ├── Sihga (2)             # Sihga fasteners
│   └── Knapp (1)             # Knapp connectors
│
├── By Regional Market Region/ (112)
│   ├── DACH (89)             # German-speaking region GE_*
│   └── NorthAmerica (23)     # North America NA_*
│
├── By Workflow Workflow/ (59)
│   ├── Layout (20)           # Layout/plotting
│   ├── Logistics (20)        # Logistics/stacking
│   ├── ShopDrawing (18)      # Shop drawings
│   └── Batch (1)             # Batch processing
│
├── By Manufacturing Type Manufacturing/ (45)
│   ├── Nailing (16)          # Nailing
│   ├── Drilling (11)         # Drilling
│   ├── Cutting (10)          # Cutting
│   ├── Milling (5)           # Milling
│   └── CNC (3)               # CNC processing
│
├── MEP/ (12)
│   ├── HVAC (6)              # HVAC
│   ├── Installation (3)      # Installation points
│   ├── Electrical (2)        # Electrical
│   └── General (1)           # General
│
├── Base Scripts Base/ (407)
│   ├── Function (214)        # hsb_* base functions
│   ├── Core (188)            # hsb* core scripts
│   ├── DataIO (4)            # mapIO_* data mapping
│   └── CutElement (1)        # CE_* cut elements
│
└── Other/ (110)              # Uncategorized
```

### 2.3 Timber Structure Types

| Structure Type | Script Prefix | Characteristics |
|----------------|---------------|-----------------|
| **Stick Frame** | HSB_W, HSB_R, FLR_, GE_WALL | Traditional wood frame, studs, beams, joists |
| **CLT** | hsbCLT-* | Cross Laminated Timber, large solid panels for walls, floors, roofs |
| **SIP** | hsb_SIP-*, SIP* | Structural Insulated Panels, OSB + insulation core |

### 2.4 Detailed Category Statistics

| Category Path | Count | Typical Scripts |
|---------------|-------|-----------------|
| Base/Function | 214 | hsb_CreateElement, hsb_WallBOM |
| Base/Core | 188 | hsbBeamcut, hsbBlocking |
| Region/DACH | 89 | GE_WALL_SHEAR_WALL, GE_BEAM_* |
| Function/Element | 75 | HSB_E-NailClusters, HSB_E-Insulation |
| Function/General | 70 | HSB_G-BillOfMaterial, HSB_G-Stack |
| CLT | 62 | hsbCLT-Drill, hsbCLT-Opening |
| StickFrame/Wall | 52 | HSB_W-Blocking, HSB_W-Post |
| SIP | 27 | hsb_SIP-CoverStrips, SIP-MPM |
| Region/NorthAmerica | 23 | NA_WALL_SHOP_DRAWING |
| Function/Display | 21 | HSB_D-Element, HSB_D-Sheet |
| Workflow/Layout | 20 | Layout_Dim_Beam, hsbLayoutDim |
| Workflow/Logistics | 20 | Stack*, f_Lorry, f_Package |
| Function/Tool | 19 | HSB_T-Drill, HSB_T-BeamCut |
| Workflow/ShopDrawing | 18 | sd_BeamAssembly, sd_MetalpartBOM |
| Hardware/Simpson | 17 | Simpson StrongTie *.mcr |
| StickFrame/Roof | 17 | HSB_R-GutterForFlatRoof |
| StickFrame/Floor | 16 | FLR_Chase, FLR_LADDER |
| Manufacturing/Nailing | 16 | Nail-App, hsbNailing |
| Function/Core | 13 | HSB-ElementDefinition |
| Function/Info | 12 | HSB_I-ShowElementInfo |
| Hardware/BMF | 11 | BMF Balkenschuh, BMF U Shoe |
| Manufacturing/Drilling | 11 | DrillDistribution, FreeDrill |
| Hardware/Rothoblaas | 10 | Rothoblaas WHT, Rothoblaas Titan |
| Manufacturing/Cutting | 10 | QuickSlice, MultiSaw |
| Hardware/Hilti | 9 | Hilti-P2P, Hilti-Verankerung |
| HVAC | 6 | HVAC.mcr, HVAC-T.mcr |
| StickFrame/Truss | 6 | GE_TRUSS_LABEL |
| Manufacturing/Milling | 5 | FrustrumMill, EdgeRounding |
| Function/Panel | 5 | HSB_P-Electrical |
| Hardware/* (other) | 20 | Alpine, Pitzl, Sherpa, Merk, etc. |
| Other/Uncategorized | 110 | Standalone tools, example scripts |

---

## 3. Processing Strategy

### 3.1 Batch Processing Priority

| Batch | Category | Count | Priority | Reason |
|-------|----------|-------|----------|--------|
| 1 | Hardware/* | 71 | High | Most commonly used, clear parameters |
| 2 | StickFrame/* | 91 | High | Core frame structure functionality |
| 3 | CLT | 62 | High | Professional CLT tools |
| 4 | Function/* | 222 | Medium | Functional modules, more complex |
| 5 | Workflow/* | 59 | Medium | Workflow tools |
| 6 | Manufacturing/* | 45 | Medium | Manufacturing related |
| 7 | SIP | 27 | Medium | SIP specific |
| 8 | Region/* | 112 | Low | Region specific, can be deferred |
| 9 | Base/* | 407 | Low | Base scripts, large quantity |
| 10 | Other | 110 | Low | Requires manual review |

### 3.2 Category-Specific Prompt Templates

#### 3.2.1 Hardware Category (Hardware/*)

```markdown
# Role
You are an hsbCAD timber structure hardware installation expert.

# Script Information
{extracted_json}

# Output Requirements
1. **Product Overview**: Brand and type of hardware
2. **Application Scenarios**: Applicable connections (beam-beam, beam-column, wall-floor, etc.)
3. **Parameter Description**:
   - Model selection parameters
   - Size adjustment parameters
   - Installation options
4. **Usage Steps**: Select connection objects → Adjust parameters → Confirm installation
5. **Output Content**: What information the generated hardware list contains
```

#### 3.2.2 Structure Tools Category (StickFrame/*, CLT, SIP)

```markdown
# Role
You are an hsbCAD timber structure design expert.

# Script Information
{extracted_json}

# Output Requirements
1. **Function Overview**: What structural operation this tool performs
2. **Structure Type**: Applicable to frame/CLT/SIP structures
3. **Prerequisites**: What elements need to be created first
4. **Parameter Description**: Detailed explanation of each adjustable parameter
5. **Operation Steps**: Complete workflow from object selection to operation completion
6. **Related Tools**: What other tools are typically used together
```

#### 3.2.3 Workflow Category (Workflow/*)

```markdown
# Role
You are an hsbCAD production workflow expert.

# Script Information
{extracted_json}

# Output Requirements
1. **Workflow Position**: Where this tool fits in the overall workflow
2. **Function Description**: What task it accomplishes
3. **Input Requirements**: What prerequisite data is needed
4. **Parameter Configuration**: Adjustable options
5. **Output Results**: What files/drawings/lists are generated
6. **Downstream Integration**: What the output can be used for
```

---

## 4. Technical Implementation

### 4.1 System Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           Processing Pipeline                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐               │
│   │   .mcr      │     │  Classifier │     │  Prompt     │               │
│   │   Scripts   │────▶│  Group by   │────▶│  Selector   │               │
│   │   1218      │     │  Category   │     │  Match Tmpl │               │
│   └─────────────┘     └─────────────┘     └─────────────┘               │
│                                                  │                       │
│                                                  ▼                       │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐               │
│   │  Markdown   │     │   LLM       │     │   JSON      │               │
│   │  User Guide │◀────│   API       │◀────│  Extracted  │               │
│   │   Output    │     │   Call      │     │   Data      │               │
│   └─────────────┘     └─────────────┘     └─────────────┘               │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 4.2 Key Modules

#### 4.2.1 Classifier (classifier.py)
```python
def classify_script(filename: str) -> dict:
    """Returns classification info based on filename"""
    return {
        'category': 'Hardware/Simpson',
        'prompt_template': 'hardware',
        'priority': 1
    }
```

#### 4.2.2 Parser (parser.py)
```python
def parse_mcr(filepath: str) -> dict:
    """Extracts key script information"""
    return {
        'name': 'Simpson StrongTie Anchor',
        'type': 'T',
        'version': '1.2',
        'num_beams_required': 2,
        'parameters': [...],
        'description': '...'
    }
```

#### 4.2.3 Prompt Selector (prompt_selector.py)
```python
def get_prompt(category: str, script_info: dict) -> str:
    """Selects appropriate prompt template based on category"""
    templates = {
        'Hardware': hardware_template,
        'StickFrame': structure_template,
        'Workflow': workflow_template,
        'default': general_template
    }
    return templates.get(category.split('/')[0], templates['default'])
```

### 4.3 Project File Structure

```
tools/
├── __init__.py
├── classifier.py           # Script classifier
├── parser.py               # .mcr file parser
├── prompt_selector.py      # Prompt template selector
├── api_client.py           # LLM API client
├── generator.py            # Documentation generator
├── templates/
│   ├── hardware.md         # Hardware prompt
│   ├── structure.md        # Structure tools prompt
│   ├── workflow.md         # Workflow prompt
│   └── general.md          # General prompt
├── config.json             # Configuration file
└── main.py                 # Main entry point

data/
├── script_classification.json  # Classification results
└── term_glossary.json          # Term glossary

docs/                           # Generated documentation
├── index.md
├── Hardware/
│   ├── Simpson/
│   ├── Hilti/
│   └── ...
├── StickFrame/
├── CLT/
└── ...
```

---

## 5. Cost and Time Estimation

### 5.1 API Call Cost (Single-Pass)

| Category | Count | Avg Input Tokens | Avg Output Tokens | Est. Cost |
|----------|-------|------------------|-------------------|-----------|
| Hardware | 71 | 1500 | 1200 | $0.35 |
| StickFrame | 91 | 2000 | 1500 | $0.60 |
| CLT | 62 | 2000 | 1500 | $0.40 |
| Function | 222 | 2500 | 1500 | $1.60 |
| Workflow | 59 | 2000 | 1200 | $0.35 |
| Manufacturing | 45 | 1800 | 1200 | $0.30 |
| SIP | 27 | 2000 | 1500 | $0.20 |
| Region | 112 | 2000 | 1500 | $0.70 |
| Base | 407 | 2000 | 1200 | $2.00 |
| Other | 110 | 2000 | 1200 | $0.60 |
| **Total** | **1218** | - | - | **~$7** |

### 5.2 6-Pass Iterative Approach

| Approach | Tokens/Script | Total Cost | Quality |
|----------|---------------|------------|---------|
| Single-pass | ~3,500 | ~$7 | Medium |
| 6-pass | ~8,000 | ~$20 | High |

### 5.3 Processing Time

Assuming API rate limit of 30 requests/minute:
- Total processing time = 1218 / 30 ≈ 41 minutes (pure API calls)
- Including parsing and writing ≈ 1.5-2 hours (single-pass)
- 6-pass approach ≈ 6-8 hours

---

## 6. Discussion Items

### 6.1 Confirmed
- [x] Classification system established
- [x] Priority order determined
- [x] Documentation output format: Markdown
- [x] Multi-pass iterative analysis approach
- [x] UI extraction as core pass

### 6.2 To Be Determined
- [ ] Output language: English only or bilingual?
- [ ] Term glossary: Standard terminology translation table?
- [ ] Quality review: Review percentage and process?
- [ ] Documentation hosting: Integration with hsbCAD help system?
- [ ] Update mechanism: How to trigger regeneration when scripts update?

### 6.3 Parent-Child TSL Relationships (Phase 2)

Some TSL scripts work as **suites** - users launch the main/parent TSL, which internally controls child TSLs. Users never directly launch child scripts.

**Known Suite Examples:**
| Main TSL | Child TSLs | Purpose |
|----------|------------|---------|
| `MultipageController` | `MultipageAnchor`, dimension TSLs | Shop drawing generation |
| `HVAC` | `HVAC-T`, `HVAC-G`, `HVAC-P` | MEP routing system |
| `HSB_G-Stack` | `HSB_G-StackItem` | Logistics stacking |
| `FastenerManager` | `FastenerEditor`, `FastenerInspector` | Fastener management |

**Strategy:**
1. **Phase 1**: Generate individual documentation for all 1,218 scripts
2. **Phase 2**: Post-analysis to identify parent-child relationships by scanning for:
   - `TslInst.dbCreate("ScriptName", ...)` calls
   - `hsb_ScriptInsert("ScriptName", ...)` calls
   - Script name string references
3. **Phase 3**: Create suite documentation linking related scripts
4. **Phase 4**: Add cross-references and "See Also" sections

This relationship mapping is deferred to Phase 2 after initial documentation is complete.

---

## 7. Appendix

### A. Classification Configuration

Classification results saved to `script_classification.json`, containing:
- Classification of all 1218 scripts
- File list for each category
- Hierarchical structure definition

### B. Terminology Glossary

| English | German | Description |
|---------|--------|-------------|
| Beam | Balken | Timber member |
| Stud | Ständer | Wall stud |
| Joist | Balken | Floor/roof beam |
| Plate | Platte | Bottom/top plate |
| Sheathing | Beplankung | OSB/plywood covering |
| Blocking | Aussteifung | Blocking/nogging |
| Opening | Öffnung | Door/window opening |
| Drill | Bohrung | Machining operation |
| Cut | Schnitt | Machining operation |
| Mill | Fräsung | Machining operation |
| Hanger | Balkenträger | Hardware connector |
| Anchor | Anker | Fastener |
| Strap | Flachstahlanker | Tie strap |

### C. Major Hardware Vendors

| Vendor | Region | Main Products |
|--------|--------|---------------|
| Simpson StrongTie | Global | Connectors, anchors, hangers |
| Hilti | Global | Anchoring systems, fasteners |
| Rothoblaas | Europe | Hidden connectors, angle brackets |
| BMF | Germany | Beam hangers, post bases |
| Pitzl | Germany | Post base systems |
| Alpine | North America | Load bearing reaction hardware |

---

*Document Version: 2.0*
*Created: 2026-01-21*
*Status: Classification Complete - Pending Implementation*
