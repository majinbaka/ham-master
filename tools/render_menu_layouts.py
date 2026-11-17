"""Compose blank 2:3 layout references from the existing nine-slice UI atlas.

Run from the repository root: python3 tools/render_menu_layouts.py
Requires Pillow. No generated scene, reference pixels or text are embedded.
"""
from pathlib import Path
from PIL import Image

OUTPUT = Path('docs/art')
ATLAS = Image.open('assets/ui/frame-atlas.png').convert('RGBA')
SKINS = {'cream': (48, 40), 'cool': (544, 40), 'gold': (1040, 40),
         'cyan': (48, 540), 'paper': (544, 540), 'selected': (1040, 540)}


def panel(canvas, box, skin='cream', cap=14):
    """Stretch only edges and interior; preserve source corner proportions."""
    x, y, width, height = box
    sx, sy = SKINS[skin]
    source_x, source_y = [0, 56, 392, 448], [0, 56, 384, 440]
    cap = min(cap, width // 2, height // 2)
    target_x, target_y = [0, cap, width-cap, width], [0, cap, height-cap, height]
    for row in range(3):
        for col in range(3):
            crop = ATLAS.crop((sx+source_x[col], sy+source_y[row],
                               sx+source_x[col+1], sy+source_y[row+1]))
            size = (target_x[col+1]-target_x[col], target_y[row+1]-target_y[row])
            canvas.alpha_composite(crop.resize(size, Image.NEAREST),
                                   (x+target_x[col], y+target_y[row]))


def base(selected):
    canvas = Image.new('RGBA', (1024, 1536), '#12101c')
    panel(canvas, (12, 12, 360, 80), 'cool')
    for x in [384, 594, 804]:
        panel(canvas, (x, 12, 208, 80), 'cool')
    panel(canvas, (16, 112, 72, 72))
    panel(canvas, (100, 112, 420, 72), 'gold')
    panel(canvas, (12, 1384, 1000, 140), 'cool')
    panel(canvas, (24+selected*164, 1396, 160, 116), 'selected')
    return canvas


def story():
    canvas = base(1)
    for i in range(5):
        panel(canvas, (16, 216+i*148, 342, 132), 'gold' if i == 0 else 'cool')
    panel(canvas, (374, 208, 638, 1136), 'paper')
    panel(canvas, (394, 288, 598, 270), 'cool')
    panel(canvas, (402, 734, 582, 58), 'cream')
    for i in range(5):
        panel(canvas, (406, 806+i*70, 574, 62), 'selected' if i == 0 else 'cool', 10)
    panel(canvas, (520, 1200, 348, 88), 'selected')
    return canvas


def shop():
    canvas = base(3)
    panel(canvas, (16, 204, 992, 112), 'paper')
    for i in range(5):
        panel(canvas, (16+i*199, 334, 194, 74), 'selected' if i == 0 else 'cream')
    panel(canvas, (58, 432, 908, 192), 'gold')
    panel(canvas, (16, 672, 992, 328), 'paper')
    for i in range(4):
        panel(canvas, (44+i*238, 748, 222, 230), 'cool')
    panel(canvas, (16, 1024, 992, 320), 'paper')
    for i in range(3):
        panel(canvas, (40+i*320, 1100, 304, 220), 'cream')
        panel(canvas, (62+i*320, 1256, 260, 48), 'selected', 10)
    return canvas


def profile():
    canvas = base(4)
    panel(canvas, (16, 220, 992, 356), 'paper')
    panel(canvas, (48, 258, 228, 228), 'gold')
    panel(canvas, (320, 346, 644, 44), 'cyan', 10)
    panel(canvas, (316, 420, 648, 88), 'cream')
    panel(canvas, (16, 600, 992, 364), 'paper')
    for i in range(4):
        panel(canvas, (48+i*238, 698, 222, 232), 'cream')
    panel(canvas, (16, 992, 992, 320), 'paper')
    for i in range(4):
        panel(canvas, (76+i*228, 1090, 184, 184), 'cool')
    return canvas


def settings():
    canvas = base(5)
    for i in range(7):
        panel(canvas, (16, 220+i*92, 248, 80), 'selected' if i == 0 else 'cream')
    panel(canvas, (280, 208, 732, 1136), 'paper')
    for y in [244, 478, 744, 950]:
        panel(canvas, (312, y, 668, 48), 'cream', 10)
    for y in [318, 372, 426]:
        panel(canvas, (596, y, 284, 20), 'gold', 8)
        panel(canvas, (798, y-8, 36, 36), 'selected', 8)
    for i in range(3):
        panel(canvas, (584+i*130, 570, 126, 48), 'selected' if i == 2 else 'cool', 10)
    for y in [658, 850, 1026, 1090, 1154]:
        panel(canvas, (888, y, 80, 40), 'selected', 10)
    for i in range(3):
        panel(canvas, (312+i*226, 1230, 216, 64), 'cream')
    return canvas


if __name__ == '__main__':
    for name, render in [('story', story), ('shop', shop), ('profile', profile), ('settings', settings)]:
        render().save(OUTPUT / f'{name}-layout.png')
