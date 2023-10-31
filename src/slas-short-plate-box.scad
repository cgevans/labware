// Two-piece box for SLAS plates. v1.0.0
// Last updated: 2023-10-24
// (c) Constantine Evans, 2023.
// SPDX-License-Identifier:  CC-BY-SA-4.0

$fn = 64;


// Maximum total height of the plate.
plate_max_height = 15;

// SLAS flange height values.
plate_flange_height = 2.41; // [2.41:short, 6.10:medium, 7.62:tall]

// (elements will be multiples of this thickness)
base_thickness = 0.42;
bottom_multiple = 3;
wall_multiple = 3;

// Components will be separated by this tolerance.
inside_tolerance = 0.2;

bottom_thickness = bottom_multiple*base_thickness;
wall_thickness = wall_multiple*base_thickness;

include_components = "both"; // ["top", "bottom", "both"]


if (include_bottom) {
bottom(plate_max_height=plate_max_height, plate_flange_height=plate_flange_height);
}

// Minimal offset to avoid OpenSCAD problems.
minimal_offset = 0.01;


include_top = (include_components == "top" || include_components == "both");
include_bottom = (include_components == "bottom" || include_components == "both");

include <modules/SLAS_plate.scad>


if (include_top) {
translate([include_bottom ? SLAS_PLATE_WIDTH+wall_thickness*2+4 : 0,0,plate_max_height+bottom_thickness*2])
rotate([180,0,0])
top(plate_max_height=plate_max_height, plate_flange_height=plate_flange_height);
}


module extruded_rounded_rectangle(w, h, d, r) {
    hull() {
        translate([-w/2+r, -h/2+r, 0]) cylinder(r=r, h=d, center=true);
        translate([w/2-r, -h/2+r, 0]) cylinder(r=r, h=d, center=true);
        translate([-w/2+r, h/2-r, 0]) cylinder(r=r, h=d, center=true);
        translate([w/2-r, h/2-r, 0]) cylinder(r=r, h=d, center=true);
    }
}

module extruded_half_rounded_rectangle(w, h, d, r) {
    hull() {
        translate([-w/2+r, -h/2+r, 0]) cylinder(r=r, h=d, center=true);
        translate([w/2-r, -h/2+r, 0]) cylinder(r=r, h=d, center=true);
        translate([-w/2+minimal_offset, h/2-minimal_offset, 0]) cylinder(r=minimal_offset, h=d, center=true);
        translate([w/2-minimal_offset, h/2-0, minimal_offset]) cylinder(r=minimal_offset, h=d, center=true);
    }
}

module bottom(plate_max_height=17, plate_flange_height=2.41, neg=false) {

eh = neg ? inside_tolerance : 0;
em = neg ? minimal_offset : 0;

difference()
{
translate([-(SLAS_PLATE_WIDTH + 2*inside_tolerance + 2*wall_thickness + 2*eh)/2, 
    -(SLAS_PLATE_DEPTH + 2*inside_tolerance + 2*wall_thickness + 2*eh)/2, -em])
cube([SLAS_PLATE_WIDTH + 2*inside_tolerance + 2*wall_thickness + 2*eh, 
    SLAS_PLATE_DEPTH + 2*inside_tolerance + 2*wall_thickness + 2*eh, 
    plate_max_height + bottom_thickness + em]);

if (neg==false) {
translate([-(SLAS_PLATE_WIDTH + 2*inside_tolerance)/2, 
    -(SLAS_PLATE_DEPTH + 2*inside_tolerance)/2, 
    bottom_thickness - em])
cube([SLAS_PLATE_WIDTH + 2*inside_tolerance, 
    SLAS_PLATE_DEPTH + 2*inside_tolerance, 
    plate_max_height + minimal_offset + em]);

for (i=[-1:2:1]) {
translate([0,i*(SLAS_PLATE_DEPTH/2+inside_tolerance+wall_thickness/2+eh/2),plate_max_height/2 + plate_flange_height + bottom_thickness + 2])
rotate([90, 0, 0])
color("blue")
extruded_rounded_rectangle(SLAS_PLATE_WIDTH-20-2*eh, plate_max_height, wall_thickness+2*minimal_offset+eh, 2);
}
}
}

}

// bottom(neg=false);
module top(plate_max_height=17, plate_flange_height=2.41) {
difference() {
    translate([-(SLAS_PLATE_WIDTH + 2*inside_tolerance + 4*wall_thickness + 2*inside_tolerance)/2, 
    -(SLAS_PLATE_DEPTH + 2*inside_tolerance + 4*wall_thickness + 2*inside_tolerance)/2, 0])
    cube([SLAS_PLATE_WIDTH + 2*inside_tolerance + 4*wall_thickness + 2*inside_tolerance, 
    SLAS_PLATE_DEPTH + 2*inside_tolerance + 4*wall_thickness + 2*inside_tolerance, 
    plate_max_height + bottom_thickness*2]);
    
    bottom(plate_max_height=plate_max_height, plate_flange_height=plate_flange_height, neg=true);
    translate([0,0,plate_max_height/2 - 5])
    rotate([0, 90, 0])
    extruded_rounded_rectangle(plate_max_height, SLAS_PLATE_DEPTH-20, 2*SLAS_PLATE_WIDTH, 2);
}

lt = SLAS_PLATE_FLANGE_WIDTH - inside_tolerance;
echo(lt);
tlh=2.5;
translate([-(SLAS_PLATE_WIDTH)/2, 
    -(SLAS_PLATE_DEPTH)/2, 
    plate_max_height-tlh])
difference() {
cube([SLAS_PLATE_WIDTH, 
    SLAS_PLATE_DEPTH, 
    tlh+bottom_thickness]);
translate([lt, lt, -minimal_offset])
cube([SLAS_PLATE_WIDTH - lt*2, 
    SLAS_PLATE_DEPTH - lt*2, 
    tlh+bottom_thickness]);
}

drop_height = plate_flange_height + bottom_thickness + 2;
for (i=[-1:2:1]) {
translate([0,i*(SLAS_PLATE_DEPTH/2+inside_tolerance+wall_thickness/2),
    (plate_max_height-drop_height)/2 + drop_height +bottom_thickness/2])
rotate([90, 0, 0])
color("blue")
extruded_half_rounded_rectangle(SLAS_PLATE_WIDTH-20-2*inside_tolerance, plate_max_height-drop_height+bottom_thickness, wall_thickness+2*minimal_offset+2*inside_tolerance, 2);
}

drop_height_inner = plate_flange_height + bottom_thickness ;
for (i=[-1:2:1]) {
translate([0,i*(SLAS_PLATE_DEPTH/2-lt/2),
    (plate_max_height-drop_height_inner)/2 + drop_height_inner ])
rotate([90, 0, 0])
color("orange")
extruded_half_rounded_rectangle(SLAS_PLATE_WIDTH-20-2*inside_tolerance, plate_max_height-drop_height_inner, lt, 2);
}
}

