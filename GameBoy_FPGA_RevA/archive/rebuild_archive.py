from pathlib import Path
import base64

here = Path(__file__).resolve().parent
parts = sorted(here.glob("GameBoy_FPGA_RevA.zip.b64.part*"))
if not parts:
    raise SystemExit("No archive parts found")

data = "".join(part.read_text(encoding="ascii").strip() for part in parts)
out = here / "GameBoy_FPGA_RevA.zip"
out.write_bytes(base64.b64decode(data, validate=True))
print(f"Rebuilt: {out}")
