$fn = 64;

plate_max_height = 17;

// SLAS plate footprint dimensions
slas_plate_width = 85.48;
slas_plate_length = 127.76;
slas_plate_flange_width = 1.27;
slas_plate_flange_height = 2.41; // short flange

base_thickness = 0.42;

minm = 0.01;

inside_tolerance = 0.2;
bottom_thickness = 2*base_thickness;
wall_thickness = 2*base_thickness;

module extruded_rounded_rectangle(w, h, d, r) {
    hull() {
        translate([-w/2+r, -h/2+r, 0]) cylinder(r=r, h=d, center=true);
        translate([w/2-r, -h/2+r, 0]) cylinder(r=r, h=d, center=true);
        translate([-w/2+r, h/2-r, 0]) cylinder(r=r, h=d, center=true);
        translate([w/2-r, h/2-r, 0]) cylinder(r=r, h=d, center=true);
    }
}

module bottom(neg=false) {

eh = neg ? inside_tolerance : 0;
em = neg ? minm : 0;

difference()
{
translate([-(slas_plate_width + 2*inside_tolerance + 2*wall_thickness + 2*eh)/2, 
    -(slas_plate_length + 2*inside_tolerance + 2*wall_thickness + 2*eh)/2, -em])
cube([slas_plate_width + 2*inside_tolerance + 2*wall_thickness + 2*eh, 
    slas_plate_length + 2*inside_tolerance + 2*wall_thickness + 2*eh, 
    plate_max_height + bottom_thickness + em]);

if (neg==false) {
translate([-(slas_plate_width + 2*inside_tolerance)/2, 
    -(slas_plate_length + 2*inside_tolerance)/2, 
    bottom_thickness - em])
cube([slas_plate_width + 2*inside_tolerance, 
    slas_plate_length + 2*inside_tolerance, 
    plate_max_height + minm + em]);
}

for (i=[-1:2:1]) {
translate([0,i*(slas_plate_length/2+inside_tolerance+wall_thickness/2+eh/2),plate_max_height/2 + slas_plate_flange_height + bottom_thickness + 2 + eh])
rotate([90, 0, 0])
color("blue")
extruded_rounded_rectangle(slas_plate_width-20-2*eh, plate_max_height, wall_thickness+2*minm+eh, 2);
}
}

}

// bottom(neg=false);
module top() {
difference() {
    translate([-(slas_plate_width + 2*inside_tolerance + 4*wall_thickness + 2*inside_tolerance)/2, 
    -(slas_plate_length + 2*inside_tolerance + 4*wall_thickness + 2*inside_tolerance)/2, 0])
    cube([slas_plate_width + 2*inside_tolerance + 4*wall_thickness + 2*inside_tolerance, 
    slas_plate_length + 2*inside_tolerance + 4*wall_thickness + 2*inside_tolerance, 
    plate_max_height + bottom_thickness*2]);
    
    bottom(neg=true);
    translate([0,0,plate_max_height/2 - 5])
    rotate([0, 90, 0])
    extruded_rounded_rectangle(plate_max_height, slas_plate_length-20, 2*slas_plate_width, 2);
}

tlh=2;
translate([-(slas_plate_width)/2, 
    -(slas_plate_length)/2, 
    plate_max_height-tlh])
difference() {
cube([slas_plate_width, 
    slas_plate_length, 
    tlh+bottom_thickness]);
translate([wall_thickness, wall_thickness, -minm])
cube([slas_plate_width - wall_thickness*2, 
    slas_plate_length - wall_thickness*2, 
    tlh+bottom_thickness]);
}
}

bottom();

translate([slas_plate_width+5,0,plate_max_height+bottom_thickness*2])
rotate([180,0,0])
top();