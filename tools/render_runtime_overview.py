"""Assemble the Flutter runtime captures in the original four-column layout."""

import argparse
from pathlib import Path

from PIL import Image, ImageDraw

SCREEN_ORDER = (
    "home", "shop", "profile", "settings", "launch",
    "beasts", "battle",
)
MODAL_GROUPS = ("home", "shop", "profile", "settings")
COLUMNS = 4
WIDTH, HEIGHT = 390, 844
LABEL_HEIGHT = 28


def assemble(paths: list[Path], output: Path) -> None:
    rows = (len(paths) + COLUMNS - 1) // COLUMNS
    canvas = Image.new("RGB", (COLUMNS * WIDTH, rows * (HEIGHT + LABEL_HEIGHT)), "#263d35")
    labels = ImageDraw.Draw(canvas)
    for index, path in enumerate(paths):
        left = index % COLUMNS * WIDTH
        top = index // COLUMNS * (HEIGHT + LABEL_HEIGHT)
        labels.text((left + 8, top + 8), f"{path.stem} 390x844 text 1x", fill="white")
        with Image.open(path) as capture:
            if capture.size != (WIDTH, HEIGHT):
                raise ValueError(f"Unexpected size for {path}: {capture.size}")
            canvas.paste(capture.convert("RGB"), (left, top + LABEL_HEIGHT))
    canvas.save(output, quality=90, optimize=True)


def main() -> None:
    default = Path(__file__).resolve().parents[1] / "docs" / "art" / "runtime-preview"
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("captures", type=Path, nargs="?", default=default)
    root = parser.parse_args().captures
    modals = [path for group in MODAL_GROUPS for path in sorted((root / "modals").glob(f"{group}-*.png"))]
    if not modals:
        parser.error(f"No modal captures in {root / 'modals'}")
    assemble([root / f"{screen}.png" for screen in SCREEN_ORDER], root / "overview.jpg")
    assemble(modals, root / "overview-modals.jpg")


if __name__ == "__main__":
    main()
