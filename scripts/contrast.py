#!/usr/bin/env python3
"""WCAG contrast ratios for colour pairs.

Usage: contrast.py "#1F2937 on #FFFFFF" "#9CA3AF on #F7F7FB" ...
Each pair is "<foreground> on <background>", hex colours (#RGB or #RRGGBB).
Prints the ratio and pass/fail for normal text (4.5), large text and UI parts (3.0).
"""
import sys


def lum(hex_colour):
    h = hex_colour.strip().lstrip('#')
    if len(h) == 3:
        h = ''.join(c * 2 for c in h)
    rgb = [int(h[i:i + 2], 16) / 255 for i in (0, 2, 4)]
    lin = [c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4 for c in rgb]
    return 0.2126 * lin[0] + 0.7152 * lin[1] + 0.0722 * lin[2]


def ratio(fg, bg):
    a, b = sorted((lum(fg), lum(bg)), reverse=True)
    return (a + 0.05) / (b + 0.05)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    for pair in sys.argv[1:]:
        fg, _, bg = pair.partition(' on ')
        r = ratio(fg, bg)
        verdict = lambda ok: 'pass' if ok else 'FAIL'
        print(f"{fg.strip()} on {bg.strip()}: {r:.2f}:1  text {verdict(r >= 4.5)} · large text / UI {verdict(r >= 3)}")
