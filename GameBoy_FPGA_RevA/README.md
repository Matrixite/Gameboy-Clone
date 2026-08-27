# GameBoy FPGA Rev-A

Reference carrier-board project for a Game Boy compatible FPGA handheld built around the **Sipeed Tang Nano 9K**, with a real 32-pin Game Boy cartridge connector, 5 V/3.3 V bus translation, buttons, audio, and display break-out through the FPGA module.

## Status

This is a **Rev-A reference design** intended for bring-up and further engineering, not a guaranteed fabrication-ready production board.

The cartridge connector footprint is intentionally marked **PROVISIONAL**. Its electrical pinout and 1.5 mm contact pitch are represented, but the mechanical body, mounting tabs and exact pad geometry must be checked against the specific replacement cartridge socket selected before ordering a PCB.

The supplied HDL is a **safe hardware bring-up stub**, not a complete Game Boy implementation.

## Main architecture

- Sipeed Tang Nano 9K FPGA module
- 27 MHz FPGA module clock
- Original-style 32-pin Game Boy cartridge interface
- Cartridge +5 V supply
- A0-A15 cartridge address bus
- D0-D7 bidirectional cartridge data bus
- PHI, /RD, /WR and /CS control signals
- Bidirectional/open-drain style /RES handling
- SN74LVC8T245 level translation between 3.3 V FPGA I/O and 5 V cartridge bus
- Data transceiver disabled by default during configuration
- Cartridge VIN audio input support
- FPGA left/right PWM audio outputs with RC filtering and VIN mixing
- A, B, Start, Select and D-pad buttons through a PCF8574 I2C GPIO expander
- Tang Nano LCD / HDMI connectivity retained through the module

## Directory layout

```text
GameBoy_FPGA_RevA/
├── GameBoy_FPGA.kicad_pcb
├── GameBoy_FPGA.kicad_pro
├── GameBoy_FPGA.pro
├── GameBoy_FPGA.sch
├── GameBoy_FPGA-cache.lib
├── fp-lib-table
├── BOM.csv
├── MANIFEST.txt
├── SANITY_CHECK.txt
├── SOURCES.md
├── GameBoy_FPGA.pretty/
│   ├── GameBoy_DMG_CartSlot_32P_1.5mm_PROVISIONAL.kicad_mod
│   └── TangNano9K_Module.kicad_mod
├── constraints/
│   └── gameboy_top.cst
├── docs/
│   ├── bringup_checklist.md
│   └── cartridge_bus.md
└── hdl/
    └── gameboy_top_stub.v
```

## Cartridge electrical notes

The classic Game Boy cartridge interface is a 5 V bus. The FPGA side is 3.3 V, therefore direct connection of cartridge signals to FPGA GPIO is not acceptable.

The design uses SN74LVC8T245 translators for address/control and data paths. The data bus translator output-enable is held disabled until firmware/HDL intentionally enables it, reducing the chance of bus contention while the FPGA is configuring.

The Game Boy cartridge reset signal can be driven by either side, so the design treats it as a wired/open-drain style signal rather than driving it push-pull from the FPGA.

See `docs/cartridge_bus.md` for the cartridge connector mapping used by the project.

## FPGA firmware

`hdl/gameboy_top_stub.v` is only intended to make first-power tests safer. A full implementation still needs, at minimum:

- LR35902 compatible CPU
- PPU and LCD timing
- APU
- boot/startup behavior
- joypad register interface
- timer and interrupt system
- serial interface if desired
- cartridge bus controller
- MBC1/MBC2/MBC3/MBC5 and other mapper behavior as required
- cartridge RAM / RTC behavior where applicable

When implementing the cartridge controller, never enable FPGA drive onto D0-D7 at the same time that the cartridge is expected to drive those lines.

## Mechanical warning

**Do not fabricate this PCB until J1 has been checked against the exact cartridge socket you intend to buy.** Replacement Game Boy cartridge sockets vary in mounting-tab position, plastic body shape and pin geometry.

The provisional footprint is provided so electrical placement and routing work can proceed while a final connector is chosen.

## Bring-up sequence

1. Verify there are no shorts between 5 V, 3.3 V and GND.
2. Power the board with no cartridge installed.
3. Verify 5 V and 3.3 V rails.
4. Program only the safe bring-up HDL stub first.
5. Confirm cartridge bus translators remain disabled where expected.
6. Check PHI and control outputs with an oscilloscope/logic analyzer.
7. Insert a sacrificial/simple ROM-only cartridge before testing valuable cartridges.
8. Verify address/control levels at the cartridge are approximately 5 V logic levels where appropriate.
9. Verify FPGA-side signals stay within 3.3 V I/O limits.
10. Only then begin enabling reads and mapper logic.

## KiCad compatibility

The project includes both modern KiCad project/PCB naming and legacy schematic/cache files generated for maximum practical portability. Open the `.kicad_pro` project first in a current KiCad release.

## Sources

See `SOURCES.md` for references used while preparing the design.
