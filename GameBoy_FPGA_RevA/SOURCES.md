# Source / verification notes

The design was drawn from public hardware documentation rather than a cloned commercial board.

- **Game Boy cartridge bus pinout**: GBDev Pan Docs, External Connectors.
- **Tang Nano 9K module/header mapping**: Sipeed Tang Nano 9K official documentation/schematic, cross-checked against public KiCad module libraries.
- **SN74LVC8T245 package/control behavior**: Texas Instruments datasheet; VCCA is the FPGA-side 3.3 V domain, VCCB is the cartridge-side 5 V domain.

Before manufacture, re-check all footprints and current datasheets for the exact manufacturer part numbers you purchase.
