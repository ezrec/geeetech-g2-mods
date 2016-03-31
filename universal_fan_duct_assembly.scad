//
// Universal fan duct system for G2s spiders, debug assemblies
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
use <universal_probe.scad>
use <blower_40mm.scad>
use <E3D/v6_lite.scad>
use <mini_height_sensor.scad>
use <Geeetech/rostock_g2_spider.scad>

include <universal_fan_duct.scad>

module universal_fan_duct_assembly_x2() {
    % rotate([0, 0, -90]) universal_spider() {
            rotate([0, 0, 90]) e3d_v6_lite();
            rotate([0, 0, 90]) e3d_v6_lite();
    }
    * rotate([0, 0, -90]) universal_probe(bed_clearance = 1, post_clearance = 5);
    translate([0, 0, -48 - bed_clearance]) {
            universal_fan_duct_foot(head_gap = 30);
            translate([probe_mount + out_depth + wall_width, 0, 10/2 + wall_width/2])
                universal_fan_duct_pipe();
      }
    translate([0, 0, 6]) universal_fan_duct_clip();
    translate([0, 0, 20]) universal_fan_duct_22mm_connector();
}

module universal_fan_duct_assembly_x1() {
    % rotate([0, 0, -90]) universal_spider() {
            rotate([0, 0, 90]) e3d_v6_lite();
    }
    translate([0, 0, -48 - bed_clearance]) {
            universal_fan_duct_foot(head_gap = 0);
            translate([probe_mount + out_depth + wall_width, 0, 10/2 + wall_width/2])
                universal_fan_duct_pipe();
    }
    translate([0, 0, 6]) universal_fan_duct_clip();
    translate([0, 0, 20]) universal_fan_duct_22mm_connector();
}

universal_fan_duct_assembly_x2();
