# Gameboy-Clone

An FPGA-based Game Boy compatible handheld hardware project designed around the **Sipeed Tang Nano 9K** and a **real 32-pin Game Boy cartridge slot**.

The goal of this project is to build a standalone Game Boy-style system that runs original cartridges directly through FPGA logic, while keeping the cartridge bus electrically safe for both the FPGA and genuine 5 V cartridges.

> **Project status:** Rev-A / work in progress. The current design is a reference and bring-up platform, not yet a fabrication-ready production board.

## Features

- Sipeed **Tang Nano 9K** FPGA module
- Real **32-pin Game Boy cartridge interface**
- 5 V cartridge power
- Full cartridge address bus: **A0-A15**
- Bidirectional cartridge data bus: **D0-D7**
- Cartridge control signals: **PHI, /RD, /WR, /CS and /RES**
- **3.3 V ↔ 5 V level translation** using SN74LVC8T245 devices
- Safe data-bus output-enable behaviour during FPGA configuration
- Open-drain/bidirectional handling for cartridge reset
- Cartridge **VIN audio** input support
- Stereo FPGA audio output with RC filtering and cartridge-audio mixing
- D-pad, A, B, Start and Select controls
- PCF8574 I²C GPIO expander for buttons
- Tang Nano LCD / HDMI connectivity retained
- 27 MHz FPGA clock constraint
- KiCad schematic and PCB project files
- Custom Game Boy cartridge and Tang Nano footprints
- FPGA constraints and safe HDL bring-up stub
- BOM and hardware bring-up documentation

## Hardware architecture

```text
                    ┌─────────────────────┐
                    │   Tang Nano 9K FPGA │
                    │      3.3 V I/O      │
                    └─────────┬───────────┘
                              │
                   3.3 V / 5 V translation
                              │
                    ┌─────────▼───────────┐
                    │  Game Boy Cart Bus  │
                    │ A0-A15 / D0-D7      │
                    │ PHI /RD /WR /CS     │
                    │ /RES / VIN / +5 V   │
                    └─────────┬───────────┘
                              │
                    ┌─────────▼───────────┐
                    │ Original Game Boy   │
                    │     Cartridge       │
                    └─────────────────────┘
```

The original Game Boy cartridge interface is a **5 V bus**, while the Tang Nano FPGA uses **3.3 V I/O**. The cartridge signals therefore pass through level translators rather than being connected directly to FPGA pins.

The cartridge data bus is bidirectional. Its translator is disabled by default while the FPGA is configuring to reduce the risk of bus contention.

## Cartridge support

The hardware exposes the signals required for original Game Boy cartridges. Actual game compatibility is determined by the FPGA core and cartridge-controller logic.

A complete implementation will eventually need support for items such as:

- ROM-only cartridges
- MBC1
- MBC2
- MBC3
- MBC5
- Cartridge RAM
- Battery-backed RAM
- RTC-equipped cartridges
- Other special cartridge hardware where required

Mapper/MBC support is **not yet implemented in the supplied HDL stub**.

## FPGA core status

The current `gameboy_top_stub.v` is a **hardware bring-up stub only**. It is intended to provide a safer starting point for checking the PCB and cartridge interface.

A complete Game Boy FPGA implementation still requires at least:

- LR35902-compatible CPU
- PPU
- APU
- Timer system
- Interrupt controller
- Joypad registers
- Cartridge bus controller
- MBC/mapper logic
- Boot/startup behaviour
- LCD/video output path
- Audio generation
- Optional serial/link-port implementation

## Repository structure

```text
Gameboy-Clone/
├── README.md
└── GameBoy_FPGA_RevA/
    ├── GameBoy_FPGA.kicad_pcb
    ├── GameBoy_FPGA.kicad_pro
    ├── GameBoy_FPGA.pro
    ├── GameBoy_FPGA.sch
    ├── BOM.csv
    ├── SOURCES.md
    ├── fp-lib-table
    ├── GameBoy_FPGA.pretty/
    │   ├── GameBoy_DMG_CartSlot_32P_1.5mm_PROVISIONAL.kicad_mod
    │   └── TangNano9K_Module.kicad_mod
    ├── constraints/
    │   └── gameboy_top.cst
    ├── docs/
    │   ├── bringup_checklist.md
    │   └── cartridge_bus.md
    ├── hdl/
    │   └── gameboy_top_stub.v
    └── archive/
        ├── GameBoy_FPGA_RevA.zip.b64.part*
        └── rebuild_archive.py
```

## Opening the KiCad project

Open:

```text
GameBoy_FPGA_RevA/GameBoy_FPGA.kicad_pro
```

in a current version of KiCad.

The project also contains legacy-format support files for portability.

## Important cartridge socket warning

The current Game Boy cartridge connector footprint is marked **PROVISIONAL**.

The electrical pinout and nominal contact spacing are represented, but replacement cartridge sockets can differ in:

- mounting-tab position
- plastic body dimensions
- pin geometry
- board-edge spacing

**Do not order a PCB until the J1 footprint has been checked against the exact cartridge connector that will be used.**

## Recommended bring-up procedure

1. Inspect the board for shorts before fitting a cartridge.
2. Power the board with no cartridge installed.
3. Verify the 5 V and 3.3 V rails.
4. Program the safe FPGA bring-up stub.
5. Confirm the cartridge data transceiver is disabled when expected.
6. Check PHI and cartridge control signals with a logic analyser or oscilloscope.
7. Confirm FPGA-side signals remain within 3.3 V limits.
8. Test first with a simple or expendable ROM-only cartridge.
9. Verify address and control timing before enabling writes.
10. Add cartridge-controller and MBC logic gradually.

## Archive copy

The `GameBoy_FPGA_RevA/archive/` directory contains a Base64-split copy of the original project ZIP.

To reconstruct it, run:

```bash
cd GameBoy_FPGA_RevA/archive
python rebuild_archive.py
```

This recreates the original `GameBoy_FPGA_RevA.zip` archive.

## Current limitations

- FPGA Game Boy core is not yet complete
- MBC mapper support is not yet implemented
- Cartridge socket footprint must still be mechanically verified
- PCB routing and hardware should be reviewed before fabrication
- Hardware has not yet been validated on a manufactured Rev-A board

## Project goals

The long-term aim is a self-contained FPGA Game Boy clone capable of running **real original cartridges** while recreating the main Game Boy hardware in programmable logic rather than software emulation.

Possible future additions include:

- Full DMG-compatible FPGA core
- Game Boy Color support
- MBC1/MBC2/MBC3/MBC5 support
- Cartridge RTC support
- Original-style LCD or modern IPS display support
- Link port
- Battery operation and charging
- Integrated audio amplifier and speaker
- Save-RAM handling
- Improved cartridge-slot mechanical design

## Disclaimer

This is an independent hobby hardware project and is not affiliated with or endorsed by Nintendo.

Original Game Boy cartridges and associated trademarks remain the property of their respective owners.
