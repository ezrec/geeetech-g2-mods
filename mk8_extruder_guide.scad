

module mk8_extruder_guide()
{
    translate([0, 0, 10]) rotate([180, 0, 0])
    difference() {
        union() {
            cylinder(d=8, h=6, $fn=24);
            translate([0, 0, 6])
                cylinder(d=12, h=4, $fn=24);
        }
        translate([0, 0, -0.1]) cylinder(d1=3, d2=10, h=10.2, $fn=24);
    }
}

mk8_extruder_guide();
