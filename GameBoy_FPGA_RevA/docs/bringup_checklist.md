# Hardware bring-up checklist

1. Do not insert a valuable cartridge on first power-up.
2. Power the Tang Nano/carrier with J1 empty and confirm +3.3 V / +5 V rails.
3. Confirm U5 `DATA_OE_N` is high during FPGA configuration.
4. Load `hdl/gameboy_top_stub.v`; verify /RD, /WR, /CS remain high and the data bus is high-Z.
5. Verify the cartridge-side translated address/control levels are not floating or over-voltage.
6. Confirm reset is released by pull-ups and that the FPGA never drives it high.
7. Use a sacrificial/common cartridge for first bus tests.
8. Implement read-only ROM fetches before write cycles or cartridge RAM.
9. Add MBC timing tests, then CGB timing if required.
10. Only after bus validation connect final display/audio hardware and design the enclosure.
