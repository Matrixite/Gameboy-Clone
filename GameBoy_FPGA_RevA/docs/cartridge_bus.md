# Game Boy cartridge bus notes

## 32-pin cartridge interface used by the schematic

| Pin | Signal | Direction from console viewpoint | Rev A handling |
|---:|---|---|---|
| 1 | VDD | Power | +5 V cartridge rail |
| 2 | PHI | Out | U4 3.3→5 V |
| 3 | /WR | Out | U4 3.3→5 V |
| 4 | /RD | Out | U4 3.3→5 V |
| 5 | /CS | Out | U4 3.3→5 V |
| 6–21 | A0–A15 | Out | U2/U3 3.3→5 V |
| 22–29 | D0–D7 | Bidirectional | U5 dual-supply bidirectional |
| 30 | /RESET | Bidirectional/open-drain behavior | BSS138 + 10k pullups each side |
| 31 | VIN | Audio input from cartridge | AC-coupled to audio mix |
| 32 | GND | Power | Ground |

## Data translator direction

For SN74LVC8T245, DIR controls A→B when high and B→A when low. In Rev A:

- A side = FPGA / 3.3 V
- B side = cartridge / 5 V
- `DATA_DIR=1`: FPGA writes to cartridge
- `DATA_DIR=0`: FPGA reads cartridge
- `DATA_OE_N=1`: translator high impedance

The PCB uses a pull-up on `DATA_OE_N` so the data bus stays disconnected while the FPGA is configuring. A pull-down on `DATA_DIR` makes the harmless default direction cartridge→FPGA.

## Mapper support

MBC1/MBC2/MBC3/MBC5 and cartridge RAM/RTC logic are physically in the cartridge. A compatible FPGA console does not emulate those mapper chips for a real cartridge; it must instead present bus timing/addresses/control signals compatible with a real Game Boy so the cartridge's own MBC behaves correctly.

## CGB considerations

CGB-compatible cartridges use the same cartridge connector. CGB operation is mainly a core/clock/timing/display feature, not a different connector. Validate edge rates and timing on hardware before claiming full CGB compatibility.
