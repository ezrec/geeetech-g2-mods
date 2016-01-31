//
// Copyright (C) 2015, Jason S. McMullan <jason.mcmullan@gmail.com>
// All right reserved.
//
// Licensed under the MIT License:
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
// All units are in mm

use <universal_spider.scad>
use <e3d_v6_probe.scad>
use <E3D/v6_lite.scad>
use <blower_40mm.scad>
use <mini_height_sensor.scad>
use <Geeetech/rostock_g2_spider.scad>

// Clearance from bed to probe and fan
bed_clearance = 1;

// Thickness of the outflow
ring_height = 6;

// Optimize part for quickest printing - use an integer multiple of the printer's nozzle size
wall_width = 1;    // Wall thickness - should be a multiple of machine_nozzle;

// Size of the output of the blower
blower_out= [16.3, 25.5, 3];
out_depth = 5;

// Size of the tubing
tubing_id = 22;

neck_width = 20; // Distance between head bolts for the neck

blower_volume = blower_out[0]*blower_out[1]/2;

duct_z = 36; // Height from base to next
duct_height = duct_z;

head_gap = 30; // Distance between J-heads

// Distance from nozzle to probe mount frame
probe_mount = 28;

blower_shift_extra = 10;

neck_height = 35;

tolerance = 0.15;

// Calculated parameters

neck_size = [blower_out[0]+2*wall_width, neck_width];
duct_slice = 0.1;

$fn = 24;

module e3d_v6_fan_duct_blower_adapter_fab(height=7, size = blower_out, carve = false)
{
    if (!carve) {
       translate([wall_width, wall_width, 0])
            cube([size[0], size[1], height+size[2]]);
        cube([size[0]+2*wall_width, size[1]+wall_width, height]);
        translate([size[0]/2 + wall_width, size[1] + wall_width, 0])
            rotate([90, 0, 0]) cylinder(d = size[0] + wall_width, h = size[1]);
        translate([size[0]/2 + wall_width, size[1], 0])
            rotate([90, 0, 0]) cylinder(r = out_depth + wall_width - tolerance, h = size[1] + 10, $fn = 6);
    } else {            
        translate([wall_width*2, wall_width*2, -0.1])
          cube([size[0]-2*wall_width, size[1]-2*wall_width, height+size[2]+0.2]);
        translate([size[0]/2 + wall_width, size[1], 0])
            rotate([90, 0, 0]) cylinder(d = size[0], h = size[1] - wall_width*2);
        translate([size[0]/2 + wall_width, size[1] - wall_width*2, 0])
            rotate([90, 0, 0]) cylinder(r = out_depth, h = size[1] + 10 + 0.1, $fn = 6);
        
    }
}

module e3d_v6_fan_duct_blower_adapter(height=7, size = blower_out)
{
    difference() {
        e3d_v6_fan_duct_blower_adapter_fab(height = height, size = size, carve = false);
        e3d_v6_fan_duct_blower_adapter_fab(height = height, size = size, carve = true);
    }

    % translate([-wall_width, 18-wall_width, height+20])
        rotate([-90, 180, -90]) blower();
}

module e3d_v6_fan_duct_outlet(ro=15, ri=8, height = 4, carve = false)
{
    rotate_extrude(convexity=4) {
        translate([ri, 0]) {
            if (!carve) {
                square([ro-ri, height]);
            } else {
                polygon([[wall_width, -0.1], [wall_width*2, -0.1], 
                         [ro-ri-wall_width, height*0.3], 
                         [ro-ri-wall_width, height-wall_width], 
                         [wall_width, height-wall_width]]);
            }
        }
    }
}

module e3d_v6_fan_duct_outflow(height = 50, ring_height = 4, head_gap = head_gap, carve = false)
{
    ri = 7;
    ro = ri + wall_width*2 + 4;
    cut = ro * 2;
    
    angle = atan(head_gap / 2 / (probe_mount + out_depth));
    vent_len = (probe_mount + out_depth) / cos(angle);
    vent_width = out_depth*sqrt(3) + wall_width*2;

    difference() {
        rotate([0, 0, -angle]) {
            // Exit ducting & fan mount
            
            // Connector to nozzle
            translate([ri+wall_width, -vent_width/2, 0]) {
                if (!carve) {
                  cube([vent_len - ri - wall_width, vent_width, ring_height]);
                } else {
                  translate([-0.1, wall_width, wall_width])
                        cube([vent_len - ri + 0.2, (vent_width-3*wall_width)/2, ring_height - wall_width*2]);
                  translate([-0.1, wall_width + (vent_width-2*wall_width + wall_width)/2, wall_width])
                        cube([vent_len - ri + 0.2, (vent_width-3*wall_width)/2, ring_height - wall_width*2]);
               }
            }
              
            e3d_v6_fan_duct_outlet(ro = ro, ri = ri, height = ring_height, carve = carve);
        }
        rotate([0, -20, 0]) if (!carve) {
            translate([-ro, -cut/2, wall_width - 0.1]) cube([ro*3, cut, ring_height*2 + 0.2]);
        } else {
            translate([-ro, -(cut+2)/2, -0.1]) cube([ro*3, cut + 2, ring_height*2 + 0.2]);
        }
    }
}

module e3d_v6_fan_duct_pipe(height = 50, ring_height = 4, head_gap = head_gap, carve = false)
{
    translate([probe_mount + out_depth + wall_width, 0, 0]) {
        if (!carve) {
          rotate([0, 0, 30]) cylinder(r = out_depth+wall_width, h = height - wall_width, $fn = 6);
        } else {
          translate([0, 0, wall_width]) rotate([0, 0, 30]) cylinder(r = out_depth, h = height + 0.1, $fn = 6);
        }
    }
}

module e3d_v6_fan_duct_fab(height = 50, ring_height = 4, head_gap = head_gap, carve = false)
{
  e3d_v6_fan_duct_pipe(height = height, carve = carve);
  translate([0, head_gap/2, 0]) e3d_v6_fan_duct_outflow(height = height, ring_height = ring_height, head_gap = head_gap, carve = carve);
  if (head_gap > 0)
      mirror([0, 1, 0]) 
        translate([0, head_gap/2, 0]) e3d_v6_fan_duct_outflow(height = height, ring_height = ring_height, head_gap = head_gap, carve = carve);
}

module e3d_v6_fan_duct(height = 50, ring_height = 4, bed_clearance = 2, head_gap = head_gap)
{
    difference() {
        e3d_v6_fan_duct_fab(height = height, ring_height = ring_height, head_gap = head_gap, carve = false);
        e3d_v6_fan_duct_fab(height = height, ring_height = ring_height, head_gap = head_gap, carve = true);
        // Uncomment to debug crposs section of duct
        // translate([-10, -wall_width, -0.1]) cube([100, 100, 100]);
    }
}

module e3d_v6_fan_duct_connector()
{
     translate([probe_mount + out_depth +wall_width, 0, 0]) rotate([0, 0, 30]) difference() {
        union() {
                cylinder(r = out_depth+wall_width*2, h = 10, $fn = 6);
            translate([0, 0, 10])
                cylinder(r1 = out_depth+wall_width*2, r2 = tubing_id/2, h=10);
            translate([0, 0, 20])
                cylinder(r = tubing_id/2, h = 10);
        }
        translate([0, 0, -0.1]) {
            cylinder(r = out_depth+wall_width+tolerance, h = 10 + 0.2, $fn = 6);
            translate([0, 0, 10])
                cylinder(r1 = out_depth, r2 = tubing_id/2 - wall_width, h = 10 + 0.1);
            translate([0, 0, 20])
                cylinder(r = tubing_id/2 - wall_width, h = 10+0.2);
        }
    }
}

module e3d_v6_fan_duct_clip_fab(carve = false, height = 8)
{
    size = [7, 8, 3];
    
    blower_ro = out_depth + wall_width;
    
    translate([probe_mount + blower_ro, 0, 0]) {
        if (!carve) {
            rotate([0, 0, 30]) cylinder(r = blower_ro + wall_width, h = height, $fn = 6);
            translate([-blower_ro - wall_width - size[0], -size[1]/2, 0]) cube([size[0] + blower_ro, size[1], size[2]]);
        } else {
            translate([0, 0, -0.1]) rotate([0, 0, 30]) cylinder(r = blower_ro + tolerance, h = height + 0.2, $fn = 6);
            translate([-blower_ro - wall_width - 3, 0, -0.1])
                cylinder(d = 4, h = size[2] + 0.2, $fn = 30);
        }
    }   
}

module e3d_v6_fan_duct_clip()
{
    difference() {
        e3d_v6_fan_duct_clip_fab(carve = false);
        e3d_v6_fan_duct_clip_fab(carve = true);
    }
}

module e3d_v6_fan_duct_joint(height = 10)
{
    blower_ro = out_depth + wall_width;
    
    difference() {
        rotate([0, 0, 30]) cylinder(r = blower_ro + wall_width, h = height, $fn = 6);
        translate([0, 0, -0.1]) rotate([0, 0, 30]) {
            cylinder(r = blower_ro + tolerance, h = height/2 + 0.1 - wall_width/2, $fn = 6);
            cylinder(r = blower_ro - wall_width, h = height + 0.2, $fn = 6);
        }
        translate([0, 0, height/2 + wall_width/2]) rotate([0, 0, 30]) cylinder(r = blower_ro + tolerance, h = height/2 + 0.1 - wall_width/2, $fn = 6);
    }
}

module e3d_v6_fan_duct_plate(head_gap = head_gap) {
    e3d_v6_fan_duct(height = 80, ring_height = ring_height, head_gap = head_gap);
    translate([20, head_gap * 1.20, 0]) rotate([0, 0, 180])
        e3d_v6_fan_duct(height = 80, ring_height = ring_height, head_gap = 0);
    translate([-45, -4, 0]) e3d_v6_fan_duct_clip();
    translate([5,  18, 0]) e3d_v6_fan_duct_clip();
    translate([10, 15, 30]) rotate([0, 180, 0]) e3d_v6_fan_duct_connector();
    translate([10, 5, 30]) rotate([0, 180, 120]) e3d_v6_fan_duct_connector();
    translate([-15, -30, blower_out[1] + wall_width]) rotate([-90, 0, 90]) e3d_v6_fan_duct_blower_adapter();
    translate([-5, 15, 0]) e3d_v6_fan_duct_joint();
}

module e3d_v6_fan_duct_assembly_x2() {
    render() rotate([0, 0, -90]) universal_spider() {
            rotate([0, 0, 90]) e3d_v6_lite();
            rotate([0, 0, 90]) e3d_v6_lite();
    }
    rotate([0, 0, -90]) e3d_v6_probe(bed_clearance = 1, post_clearance = 5);
    # translate([0, 0, -48 - bed_clearance]) e3d_v6_fan_duct(height = 80, ring_height = ring_height, head_gap = 30);
    # translate([0, 0, 6]) e3d_v6_fan_duct_clip();
    # translate([0, 0, 20]) e3d_v6_fan_duct_connector();
}

module e3d_v6_fan_duct_assembly_x1() {
    render() rotate([0, 0, -90]) universal_spider() {
            rotate([0, 0, 90]) e3d_v6_lite();
    }
    # translate([0, 0, -48 - bed_clearance]) e3d_v6_fan_duct(height = 80, ring_height = ring_height, head_gap = 0);
    # translate([0, 0, 6]) e3d_v6_fan_duct_clip();
    # translate([0, 0, 20]) e3d_v6_fan_duct_connector();
}

// 37 = Geeetech j-heads
// 47 = E3D heads
// % e3d_v6_fan_duct_assembly_x1();
e3d_v6_fan_duct_plate(head_gap = head_gap);
