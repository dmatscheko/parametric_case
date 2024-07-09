// (c) DMA 2024
// Customizable Electronic Component Case
// All dimensions are in millimeters

/* [Inner Case Dimensions] */
// Length of the inner compartment
inner_length = 89; // [0.0:0.1:1000]
// Width of the inner compartment
inner_width = 43; // [0.0:0.1:1000]
// Thickness of the PCB board
pcb_thickness = 1.65; // [0.0:0.1:10]
// Height of the compartment above the PCB
inner_height_above_pcb = 8; // [0.0:0.1:1000]
// Height of the compartment below the PCB
inner_height_below_pcb = 22; // [0.0:0.1:1000]

/* [Case Parameters] */
// Thickness of the side walls
wall_thickness = 2; // [0.1:0.1:15]
// Thickness of the floor and ceiling
floor_ceiling_thickness = 2.0; // [0.2:0.1:15]
// Radius of the side edge fillets
side_fillet_radius = 1.0; // [0.1:0.1:15]
// Radius of the bottom edge fillets
bottom_fillet_radius = 1.0; // [0.1:0.1:15]

/* [Mounting Posts] */
// Distance between mounting posts along the length (center to center)
mount_length = 82.5; // [0.0:0.1:1000]
// Distance between mounting posts along the width (center to center)
mount_width = 37; // [0.0:0.1:1000]
// Diameter of the mounting posts
post_diameter = 8; // [0.0:0.1:30]
// Diameter of the screw holes in the posts
screw_hole_diameter = 2.6; // [0.0:0.1:10]
// Diameter of the wider part of the screw holes
screw_hole_thick_diameter = 3.0; // [0.0:0.1:15]
// Dimensions of the post cutout [Length, Width, Height]
post_cutout = [82.5, 43, 2.0]; // [0.0:0.1:1000]
// Lengthwise offset
post_cutout_length_offset = 0.0; // [0.0:0.1:1000]
// Widthwise offset
post_cutout_width_offset = 0.0; // [0.0:0.1:1000]
// Enable post cutout in the top half
post_cutout_top = true;
// Enable post cutout in the bottom half
post_cutout_bottom = false;

/* [Side Wall Openings] */
// Width of the square hole
square_hole_width = 9; // [0.0:0.1:100]
// Height of the square hole
square_hole_height = 3.2; // [0.0:0.1:100]
// Diameter of the round hole
round_hole_diameter = 3; //[1:0.1:100]

/* [Ventilation] */
// Width of each ventilation slit
vent_slit_width = 1.5; // [0.0:0.1:1000]
// Length of each ventilation slit
vent_slit_length = 15; // [0.0:0.1:1000]
// Spacing between ventilation slits
vent_slit_spacing = 3; // [0.0:0.1:1000]
// Gap between outermost slits and walls
vent_end_gap = 3; // [0.0:0.1:1000]

/* [Interlocking Mechanism] */
// Height of the interlocking lip
interlock_height = 1.5; // [0.0:0.1:100]
// Visible gap between top and bottom parts when closed
interlock_visible_gap = 0.5; // [0.0:0.1:100]
// Sideway gap between the interlocking walls for better fit after 3D printing
interlock_gap = 0.1; // [0.0:0.1:20]

/* [Display Options] */
// Offset between top and bottom half
parts_offset = 80; // [0.0:0.1:1000]
// Show the top half of the case
show_top = true;
// Show the bottom half of the case
show_bottom = true;

/* [Advanced] */
// Global resolution for curved surfaces
$fn = 150; // [3:1:400]
// small epsilon for overlap
e = 0.01;

// Calculated dimensions
case_length = inner_length + 2 * wall_thickness;
case_width = inner_width + 2 * wall_thickness;
case_height = inner_height_above_pcb + inner_height_below_pcb + pcb_thickness + 2 * floor_ceiling_thickness;
bottom_height = inner_height_below_pcb + pcb_thickness + floor_ceiling_thickness;
top_height = inner_height_above_pcb + floor_ceiling_thickness;

module rounded_box(size, height) {
    difference() {
        hull() {
            // Fillet of bottom
            scale = bottom_fillet_radius / side_fillet_radius;
            translate([side_fillet_radius, side_fillet_radius, bottom_fillet_radius])
                scale([1, 1, scale]) sphere(r=side_fillet_radius);
            translate([size.x - side_fillet_radius, side_fillet_radius, bottom_fillet_radius])
                scale([1, 1, scale]) sphere(r=side_fillet_radius);
            translate([side_fillet_radius, size.y - side_fillet_radius, bottom_fillet_radius])
                scale([1, 1, scale]) sphere(r=side_fillet_radius);
            translate([size.x - side_fillet_radius, size.y - side_fillet_radius, bottom_fillet_radius])
                scale([1, 1, scale]) sphere(r=side_fillet_radius);
            // Fillet of walls
            translate([side_fillet_radius, side_fillet_radius, bottom_fillet_radius])
                cylinder(r=side_fillet_radius, h=size.z - bottom_fillet_radius);
            translate([size.x - side_fillet_radius, side_fillet_radius, bottom_fillet_radius])
                cylinder(r=side_fillet_radius, h=size.z - bottom_fillet_radius);
            translate([side_fillet_radius, size.y - side_fillet_radius, bottom_fillet_radius])
                cylinder(r=side_fillet_radius, h=size.z - bottom_fillet_radius);
            translate([size.x - side_fillet_radius, size.y - side_fillet_radius, bottom_fillet_radius])
                cylinder(r=side_fillet_radius, h=size.z - bottom_fillet_radius);
        }
        // Hollow out
        translate([wall_thickness, wall_thickness, floor_ceiling_thickness])
            cube([case_length - 2*wall_thickness, 
                  case_width - 2*wall_thickness, 
                  height - floor_ceiling_thickness + e]);
    }
}

// Why is this much slower than the above in OpenSCAD?
//module rounded_cube(size) {
//    hull() {
//        scale = bottom_fillet_radius / side_fillet_radius;
//        corners = [
//            [side_fillet_radius, side_fillet_radius, bottom_fillet_radius],
//            [size.x - side_fillet_radius, side_fillet_radius, bottom_fillet_radius],
//            [side_fillet_radius, size.y - side_fillet_radius, bottom_fillet_radius],
//            [size.x - side_fillet_radius, size.y - side_fillet_radius, bottom_fillet_radius]
//        ];
//        for (corner = corners) translate(corner) {
//            cylinder(r=side_fillet_radius, h=size.z - bottom_fillet_radius);
//            scale([1, 1, scale]) sphere(r=side_fillet_radius);
//        }
//    }
//}

module ventilation_slits(length, height) {
    available_length = length - 2 * vent_end_gap;
    num_vent_slits = floor(available_length / (vent_slit_width + vent_slit_spacing));
    real_slit_spacing = (available_length - vent_slit_width * num_vent_slits) / (num_vent_slits - 1);
    
    translate([vent_end_gap, 0, -e])
        for (i = [0:num_vent_slits-1])
            translate([i * (vent_slit_width + real_slit_spacing), 0, 0])
                cube([vent_slit_width, vent_slit_length, floor_ceiling_thickness + 2*e]);
}

module mounting_posts(is_bottom) {
    difference() {
        // Mounting posts
        post_height = is_bottom ? inner_height_below_pcb : inner_height_above_pcb;
        for (x = [0, mount_length], y = [0, mount_width]) {
            translate([wall_thickness + (inner_length - mount_length)/2 + x, 
                       wall_thickness + (inner_width - mount_width)/2 + y, 
                       floor_ceiling_thickness - e]) {
                difference() {
                    cylinder(d = post_diameter, h = post_height + e);
                    cylinder(d = screw_hole_diameter, h = post_height + 1);
                }
            }
        }
        
        // Post cutouts
        if ((is_bottom && post_cutout_bottom) || (!is_bottom && post_cutout_top)) {
            translate([wall_thickness + (inner_length - post_cutout.x)/2 + post_cutout_length_offset,
                    wall_thickness + (inner_width - post_cutout.y)/2 + post_cutout_width_offset,
                    post_height + floor_ceiling_thickness - post_cutout.z])
                cube([post_cutout.x, post_cutout.y, post_cutout.z + e]);
        }
    }
}

module screw_holes() {
    for (x = [0, mount_length], y = [0, mount_width]) {
        translate([wall_thickness + (inner_length - mount_length)/2 + x, 
                   wall_thickness + (inner_width - mount_width)/2 + y, 
                   -e]) {
            cylinder(d = screw_hole_thick_diameter, h = top_height + 2*e);
            cylinder(h = screw_hole_thick_diameter/2, r1 = screw_hole_thick_diameter, r2 = screw_hole_thick_diameter/2);
        }
    }
}

module interlocking_mechanism(is_bottom, height) {
    interlock_width = wall_thickness / 2;
    if (is_bottom) {
        // Create inside lip by cutting from outside, with gap
        translate([-e, -e, height - interlock_height - interlock_visible_gap])
            cube([case_length, interlock_width + interlock_gap + e, interlock_height + interlock_visible_gap + e]);
        translate([-e, case_width - interlock_width - interlock_gap, height - interlock_height - interlock_visible_gap])
            cube([case_length + 2*e, interlock_width + interlock_gap + e, interlock_height + interlock_visible_gap + e]);
        translate([-e, -e, height - interlock_height - interlock_visible_gap])
            cube([interlock_width + interlock_gap + e, case_width + 2*e, interlock_height + interlock_visible_gap + e]);
        translate([case_length - interlock_width - interlock_gap, -e, height - interlock_height - interlock_visible_gap])
            cube([interlock_width + interlock_gap + e, case_width + 2*e, interlock_height + interlock_visible_gap + e]);
    } else {
        // Create outside lip
        translate([wall_thickness - interlock_width, wall_thickness - interlock_width, height])
            cube([case_length - 2*wall_thickness + 2*interlock_width, 
                  case_width - 2*wall_thickness + 2*interlock_width, 
                  interlock_height + e]);
    }
}

module side_holes(height) {
    // Square hole
    translate([-e, case_width/2 - square_hole_width/2, height - square_hole_height])
        cube([wall_thickness + 2*e, square_hole_width, square_hole_height]);
    
    // Round hole
    translate([case_length - wall_thickness - e, case_width/2, height - round_hole_diameter/2])
        rotate([0, 90, 0])
            cylinder(d = round_hole_diameter, h = wall_thickness + 2*e);
    translate([case_length - wall_thickness - e, case_width/2 - round_hole_diameter/2, height - round_hole_diameter/2])
        cube([wall_thickness + 2*e, round_hole_diameter, interlock_height + round_hole_diameter/2 + 1]);
}

module round_hole_positive(height) {
    difference() {
        translate([case_length - wall_thickness, case_width/2 - round_hole_diameter/2, height - interlock_height - interlock_visible_gap])
            cube([wall_thickness, round_hole_diameter, interlock_height + interlock_visible_gap + round_hole_diameter/2]);
        translate([case_length - wall_thickness - e, case_width/2, height + round_hole_diameter/2])
            rotate([0, 90, 0])
                cylinder(d = round_hole_diameter, h = wall_thickness + 2*e);
    }
}

module case_half(is_bottom) {
    height = is_bottom ? bottom_height : top_height;
    
    difference() {
        
        union() {
        
            difference() {
                rounded_box([case_length, case_width, is_bottom ? height : height + interlock_height], height);
                
                if (!is_bottom) side_holes(height);
                
                // Ventilation slits
                translate([wall_thickness, (case_width - vent_slit_length) / 2, 0])
                    ventilation_slits(case_length - 2*wall_thickness, floor_ceiling_thickness);
            }

            mounting_posts(is_bottom);
        }
        
        // Mounting posts screw hole through floor/ceiling
        if (!is_bottom) screw_holes();
        
        // Interlocking mechanism
        interlocking_mechanism(is_bottom, height);
    }
    
    if (is_bottom) round_hole_positive(height);
}

// Generate the case
if (show_bottom) case_half(true);
if (show_top) translate([0, parts_offset, 0]) case_half(false);