// Two-piece box for SLAS plates. v0.1.0
// Last updated: 2023-10-24
// (c) Constantine Evans, 2023.
// SPDX-License-Identifier:  CC-BY-SA-4.0

$fn = 64;

include <modules/SLAS_plate.scad>;

minimal_offset = 0.01;

module extruded_rounded_rectangle(w, d, h, r, cz=false) {
    translate([0, 0, cz ? 0 : h/2])
    hull() {
        translate([-w/2+r, -d/2+r, 0]) cylinder(r=r, h=h, center=true);
        translate([w/2-r, -d/2+r, 0]) cylinder(r=r, h=h, center=true);
        translate([-w/2+r, d/2-r, 0]) cylinder(r=r, h=h, center=true);
        translate([w/2-r, d/2-r, 0]) cylinder(r=r, h=h, center=true);
    }
}

/*
difference() {
extruded_rounded_rectangle(SLAS_PLATE_WIDTH, SLAS_PLATE_DEPTH, SLAS_PLATE_FLANGE_HEIGHT_SHORT, SLAS_PLATE_FLANGE_RADIUS_OUTSIDE_CORNER);

w = 2;
translate([0,0,-minimal_offset])
extruded_rounded_rectangle(SLAS_PLATE_WIDTH-2*w, SLAS_PLATE_DEPTH-2*w, SLAS_PLATE_FLANGE_HEIGHT_SHORT+2*minimal_offset, SLAS_PLATE_FLANGE_RADIUS_OUTSIDE_CORNER-w);
}
*/