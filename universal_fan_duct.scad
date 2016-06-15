//
// Universal fan duct system for G2s spiders
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

// Distance between J-heads
head_gap = 0;	// 0,20,26,30

// Clearance from bed to probe and fan
bed_clearance = 2;

// height of the inlet pipe
height = 80;


// Optimize part for quickest printing - use an integer multiple of the printer's nozzle size
wall_width = 1;    // Wall thickness - should be a multiple of machine_nozzle;

// Size of the output of the blower
blower_out= [16.3, 25.5, 3];

neck_width = 20; // Distance between head bolts for the neck


duct_z = 36; // Height from base to next
duct_height = duct_z;

// Distance from nozzle to probe mount frame
probe_mount = 28;

blower_shift_extra = 10;

neck_height = 35;

// Slope of the foot
foot_slope = 10;

tolerance = 0.15;

// Calculated parameters

neck_size = [blower_out[0]+2*wall_width, neck_width];
duct_slice = 0.1;
joint_tolerance = tolerance;
clip_tolerance = tolerance * 4;


blower_volume = blower_out[0]*blower_out[1]/2;
out_depth = sqrt(blower_volume/PI)*2/sqrt(3);

// Thickness of the outflow
ring_height = blower_volume/(out_depth*2)/1.25;

$fn = 24;

module universal_fan_duct_blower_adapter_fab(size = blower_out, carve = false)
{
    height = out_depth;
    if (!carve) {
       translate([wall_width, wall_width, 0])
            cube([size[0], size[1], height+size[2]]);
        cube([size[0]+2*wall_width, size[1]+wall_width, height]);
        translate([size[0]/2 + wall_width, size[1]+wall_width, 0])
            rotate([90, 0, 0]) cylinder(r = out_depth + wall_width - tolerance, h = size[1] + 10, $fn = 6);
    } else {            
        translate([wall_width*2, wall_width*2, -0.1])
          cube([size[0]-2*wall_width, size[1]-2*wall_width, height+size[2]+0.2]);
        translate([size[0]/2 + wall_width, size[1], 0])
            rotate([90, 0, 0]) cylinder(r = out_depth, h = size[1] + 10 + 0.1, $fn = 6);
        
    }
}

module universal_fan_duct_blower_adapter(size = blower_out)
{
    difference() {
        universal_fan_duct_blower_adapter_fab(size = size, carve = false);
        universal_fan_duct_blower_adapter_fab(size = size, carve = true);
    }

    if (false) {
    	% translate([-wall_width, 18-wall_width, out_depth+20])
        rotate([-90, 180, -90]) blower();
    }
}

module universal_fan_duct_outflow(height = height, head_gap = head_gap, slope = foot_slope, carve = false)
{
    airgap = 10;
    
    angle = atan(head_gap / 2 / (probe_mount + out_depth));
    vent_len = (probe_mount + out_depth - airgap) / cos(angle) / cos(slope);
    vent_width = out_depth*(head_gap > 0 ? 1.5 : 2) + wall_width*2;
    vent_height = blower_volume / (out_depth*sqrt(3));

    translate([airgap, 0, 0]) {
	    difference() {
		rotate([0, 0, -angle]) {
	 
		    
		    // Connector to nozzle
		    translate([0, -vent_width/2, 0]) {
			if (!carve) {
			  cube([vent_len, vent_width, vent_height]);
			} else {
			  translate([-0.1, wall_width, wall_width])
				cube([vent_len + 0.2, (vent_width-3*wall_width)/2, vent_height - wall_width*2]);
			  translate([-0.1, wall_width + (vent_width-2*wall_width + wall_width)/2, wall_width])
				cube([vent_len + 0.2, (vent_width-3*wall_width)/2, vent_height - wall_width*2]);
		       }
		    }
		}
		
		rotate([0, -15, -angle]) if (!carve) {
		    translate([0, -vent_width/2 - wall_width, wall_width*4 - 0.1]) cube([vent_len*2, vent_width + wall_width*2, vent_height*2 + 0.2]);
		} else {
		    translate([0, -vent_width/2 - wall_width - 0.1, wall_width*3 -0.1]) cube([vent_len*2, vent_width + wall_width*2 + 0.2, vent_height*2 + 0.2]);
		}
	    }
	    
	     // Exit ducting & fan mount
	     if (carve)
		rotate([0, 0, -angle]) translate([-wall_width*4, -vent_width/2 - 0.1, 0])
		     rotate([0, -50, 0]) translate([0, 0, -wall_width*8])
		     cube([wall_width*5, vent_width + 0.2, vent_height]);
    }
	    
}

module universal_fan_duct_pipe_fab(height = height, carve = false)
{
    if (!carve) {
      rotate([0, 0, 30]) cylinder(r = out_depth+wall_width, h = height, $fn = 6);
    } else {
      translate([0, 0, -0.1]) rotate([0, 0, 30]) cylinder(r = out_depth, h = height + 0.2, $fn = 6);
    }
}

module universal_fan_duct_pipe(height = height)
{
    difference() {
        universal_fan_duct_pipe_fab(height = height, carve = false);
        universal_fan_duct_pipe_fab(height = height, carve = true);
    }
}

module universal_fan_duct_pipe_connector_fab(height = 10, carve = false, bottom = false)
{
    blower_ro = out_depth + wall_width;
    
    if (!carve) {
        rotate([0, 0, 30]) cylinder(r = blower_ro + wall_width + joint_tolerance, h = height, $fn = 6);
    } else {
        if (bottom) {
           translate([0, 0, wall_width]) rotate([0, 0, 30]) {
                cylinder(r = blower_ro - wall_width, h = height + 0.1, $fn = 6);
            }
            translate([0, 0, height/2 + wall_width*1.5]) rotate([0, 0, 30])
                cylinder(r = blower_ro + joint_tolerance, h = height/2 + 0.1 - wall_width/2, $fn = 6);
        } else {
            translate([0, 0, -0.1]) rotate([0, 0, 30]) {
                cylinder(r = blower_ro + joint_tolerance, h = height/2 + 0.1 - wall_width/2, $fn = 6);
                cylinder(r = blower_ro - wall_width, h = height + 0.2, $fn = 6);
            }
            translate([0, 0, height/2 + wall_width/2]) rotate([0, 0, 30]) cylinder(r = blower_ro + joint_tolerance, h = height/2 + 0.1 - wall_width/2, $fn = 6);
        }
    }
}

module universal_fan_duct_pipe_connector(height = 10)
{
    difference() {
        universal_fan_duct_pipe_connector_fab(height = height, carve = false);
        universal_fan_duct_pipe_connector_fab(height = height, carve = true);
    }
}

module universal_fan_duct_foot_fab(height = height, slope = foot_slope, head_gap = head_gap, carve = false)
{
    blower_ro = (out_depth + wall_width) * 2/sqrt(3);
    
    translate([(probe_mount + out_depth + wall_width)/cos(slope), 0, 0])
    difference() {
        translate([0, 0, -sin(slope)*out_depth])
       rotate([0, slope, 0])
            universal_fan_duct_pipe_connector_fab(height = 10 + ring_height, bottom = true, carve = carve);
        if (!carve) {
            translate([-blower_ro*cos(slope), -blower_ro*cos(slope), -2*sin(slope)*blower_ro]) cube([2*blower_ro*cos(slope), 2*blower_ro*cos(slope), 2*blower_ro*sin(slope)]);
        } else {
            translate([-blower_ro*cos(slope), -blower_ro*cos(slope), 0]) cube([2*blower_ro*cos(slope), 2*blower_ro*cos(slope), wall_width]);
        }
            
    }
  translate([0, head_gap/2, 0]) universal_fan_duct_outflow(height = height, slope = slope, head_gap = head_gap, carve = carve);
  if (head_gap > 0)
      mirror([0, 1, 0]) 
        translate([0, head_gap/2, 0]) universal_fan_duct_outflow(height = height, slope = slope, head_gap = head_gap, carve = carve);
}

module universal_fan_duct_foot(height = 80, bed_clearance = bed_clearance, head_gap = head_gap, slope = foot_slope)
{
    difference() {
        universal_fan_duct_foot_fab(height = height, slope = slope, head_gap = head_gap, carve = false);
        universal_fan_duct_foot_fab(height = height, slope = slope, head_gap = head_gap, carve = true);
        // Uncomment to debug cross section of duct
        // translate([-10, -wall_width, -0.1]) cube([100, 100, 100]);
    }
}

module universal_fan_duct_foot_single(slope = foot_slope)
{
	universal_fan_duct_foot(head_gap = 0, slope = slope);
}

universal_fan_duct_foot_single();

module universal_fan_duct_foot_g2s(slope = foot_slope)
{
	universal_fan_duct_foot(head_gap = 20, slope = slope);
}

module universal_fan_duct_foot_g2s_pro(slope = foot_slope)
{
	universal_fan_duct_foot(head_gap = 26, slope = slope);
}

module universal_fan_duct_foot_e3d_x2(slope = foot_slope)
{
	universal_fan_duct_foot(head_gap = 30, slope = slope);
}

module universal_fan_duct_tubing_connector(tubing_id)
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

module universal_fan_duct_22mm_connector()
{
	universal_fan_duct_tubing_connector(tubing_id = 22);
}

module universal_fan_duct_clip_fab(carve = false, height = 8)
{
    size = [7, 8, 3];
    
    blower_ro = out_depth + wall_width;
    
    translate([probe_mount + blower_ro, 0, 0]) {
        if (!carve) {
            rotate([0, 0, 30]) cylinder(r = blower_ro + clip_tolerance + wall_width, h = height, $fn = 6);
            translate([-blower_ro - wall_width - size[0], -size[1]/2, 0]) cube([size[0] + blower_ro, size[1], size[2]]);
        } else {
            translate([0, 0, -0.1]) rotate([0, 0, 30]) cylinder(r = blower_ro + clip_tolerance, h = height + 0.2, $fn = 6);
            translate([-blower_ro - 3, 0, -0.1]) {
                cylinder(d = 4, h = size[2] + 0.2, $fn = 30);
                translate([0, 0, size[2]/2]) cylinder(r = 5.5/sqrt(3), h = size[2]/2 + 0.2, $fn = 6);
            }
        }
    }   
}

module universal_fan_duct_clip()
{
    difference() {
        universal_fan_duct_clip_fab(carve = false);
        universal_fan_duct_clip_fab(carve = true);
    }
}

if (false) {
% universal_fan_duct_clip();
% translate([20, 22, 0])
    universal_fan_duct_22mm_connector();
% translate([10, 30, 0]) rotate([0, 0, -90]) 
    universal_fan_duct_foot_e3d_x2();
translate([-26, -7, 0]) rotate([0, 0, 90]) 
    universal_fan_duct_foot_single();
% translate([45, 0, 27]) rotate([-90, 0, 0])
    universal_fan_duct_blower_adapter();
}
