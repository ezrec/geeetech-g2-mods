//
// Copyright (C) 2015, Jason S. McMullan <jason.mcmullan@gmail.com>
// All right reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer,
//    without modification, immediately at the beginning of the file.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS\'\' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// All units are in mm

include <v6_block.scad>;
include <v6_break.scad>;
include <v6_nozzle.scad>;

// Oriented such that (x,y,z)=(0,0,0) is the top, front, left corner
module e3d_v6_chimera_block () {
    translate([0, 0, -30])
    difference() {
        union () {
            cube([30, 18, 30]);
            // Left filament inlet port
            translate([6, 6, 30])
                    cylinder(r=3, h=1);
            // Right filament inlet port
            translate([24, 6, 30])
                    cylinder(r=3, h=1);
        }
        
        // Rear cooling
        for (i = [0:6]) {
            translate([-0.1, 12, i*4+1.75])
                cube([30.2, 6.1, 2.5]);
        }

        // Top mounting holes
        translate([6, 15, 30])
            drill_down(diameter=3, depth=8);
        translate([15, 3, 30])
            drill_down(diameter=3, depth=8);
        translate([24, 15, 30])
            drill_down(diameter=3, depth=8);

        // Side mounting holes
        translate([10.5, 0, 20]) rotate([90, 0, 0])
            drill_down(diameter=3, depth=8);
        translate([19.5, 0, 20]) rotate([90, 0, 0])
            drill_down(diameter=3, depth=8);
        translate([15, 0, 10]) rotate([90, 0, 0])
            drill_down(diameter=3, depth=8);
    }
}

module e3d_v6_chimera_extruder()
{
    e3d_v6_nozzle();
    translate([-16, -8, 18])
        e3d_v6_block();
    translate([0, 0, 3])
        e3d_v6_break();
}

module e3d_v6_chimera()
{
    % translate([0, 18, -30]) rotate([90, 0, 0])
        fan(size=30, height=10);
    e3d_v6_chimera_block();
    translate([6, 6, -49.6]) rotate([0, 0, -90])
        e3d_v6_chimera_extruder();
    translate([24, 6, -49.6]) rotate([0, 0, 90])
        e3d_v6_chimera_extruder();
}

// vim: set shiftwidth=4 expandtab: //
