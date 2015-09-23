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


// Set of rod-end shims for the Geeetech G2/G2s Delta Rostock Mini printer,
// to eleminate slop in the rod-end bearings.
//
// Install on the aluminum rod-end bearings prior to installing the rod-ends.
//
// Although 16 are printed, you only need the best 12.
// Measure with calipers - height of the shims should be no
// more than 0.6mm, and no less than 0.2mm.

module rod_end_shim() {
	for (x = [0:3]){
		for (y = [0:3]) {
			translate([x*12, y*12, 0])
			difference() {
				cylinder(d=8, h=0.4, $fn=60);
				cylinder(d=6.5, h=0.4, $fn=60);
			}
		}
	}
}
