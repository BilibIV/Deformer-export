#!/usr/bin/env python3
"""Merge a Deformer heightmap patch into the full ASC heightmap.
Usage: python merge_asc.py full.asc heightmap_patch.asc out.asc
Both files must have the same cellsize and the same xll/yll origin convention."""
import sys
import numpy as np

def read_asc(path):
    hdr = {}
    with open(path) as f:
        for _ in range(6):
            k, v = f.readline().split()
            hdr[k.lower()] = float(v)
    data = np.loadtxt(path, skiprows=6)
    return hdr, data

full_h, full = read_asc(sys.argv[1])
patch_h, patch = read_asc(sys.argv[2])
cs = full_h["cellsize"]
assert abs(cs - patch_h["cellsize"]) < 1e-6, "cellsize differs"

col0 = round((patch_h["xllcorner"] - full_h["xllcorner"]) / cs)
row_from_bottom = round((patch_h["yllcorner"] - full_h["yllcorner"]) / cs)
prow, pcol = patch.shape
row0 = full.shape[0] - row_from_bottom - prow
assert col0 >= 0 and row0 >= 0 and col0 + pcol <= full.shape[1] and row0 + prow <= full.shape[0], \
    "patch is outside the full heightmap - check xllcorner/yllcorner offsets"

full[row0:row0 + prow, col0:col0 + pcol] = patch
with open(sys.argv[3], "w") as f:
    f.write(f"ncols {full.shape[1]}\nnrows {full.shape[0]}\n"
            f"xllcorner {full_h['xllcorner']:.3f}\nyllcorner {full_h['yllcorner']:.3f}\n"
            f"cellsize {cs:.3f}\nNODATA_value {full_h.get('nodata_value', -9999):.0f}\n")
    np.savetxt(f, full, fmt="%.2f")
print(f"patched {prow}x{pcol} cells at col {col0}, row {row0}")
