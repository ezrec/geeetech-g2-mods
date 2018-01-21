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

// Origin is the bottom center of the screw threads
// The nozzle is 12.5mm high
// The nozzle defaults to the 0.3mm geometry
// Children attached at the nozzle top
module e3d_v6_nozzle() {
    translate([0, 0, -(12.5-10.7+3+1.5)])
    {
        difference() {
            union() {
                cylinder(d1=0.75, d2=(0.75+2*cos(125-90)*(12.5-10.7)), h=(12.5-10.7), $fn=10);
                translate([0, 0, (12.5-10.7)]) {
                    cylinder(r=7/sqrt(3), h=3, $fn=6);
                    translate([0, 0, 3]) {
                        cylinder(d=5, h=1.5);
                        translate([0,0, 1.5]) {
                            cylinder(d=6, h=6, $fn=15);
                        }
                    }
                }
            }
            translate([0, 0, -0.1])
                cylinder(r=0.3, h=(12.5-10.7)+0.1);
            translate([0, 0, 12.5-10.7])
                cylinder(d=2, h=10.7+0.1, $fn=10);
        }

        children();
    }
}

// vim: set shiftwidth=4 expandtab: //
