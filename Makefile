
MKDIR ?= mkdir -p
OPENSCAD ?= openscad

SCAD := \
	Geeetech/rostock_g2_lock_ring.scad \
	Geeetech/rostock_g2_spider.scad \
	Geeetech/rostock_g2_jhead_x1.scad \
	Geeetech/rostock_g2_jhead_x2.scad \
	mk8_extruder_guide.scad \
	rod_end_shim.scad \
	universal_spider.scad \
	e3d_v6_probe.scad \
	e3d_v6_fan_duct.scad \
	e3d_chimera_spider.scad \
	universal_fan_duct.scad

MODELS := \
	geeetech_rostock_g2_lock_ring.stl \
	geeetech_rostock_g2_spider_no_probe.stl \
	geeetech_rostock_g2_spider_z_probe.stl \
	geeetech_rostock_g2_jhead_x1_upper.stl \
	geeetech_rostock_g2_jhead_x1_lower.stl \
	geeetech_rostock_g2_jhead_x2_upper.stl \
	geeetech_rostock_g2_jhead_x2_lower.stl \
	mk8_extruder_guide.stl \
	rod_end_shim.stl \
	universal_spider_plate.stl \
	universal_spider.stl \
	e3d_v6_lock_x1.stl \
	e3d_v6_lock_x2.stl \
	jhead_lock_x1.stl \
	jhead_lock_x2.stl \
	e3d_v6_probe.stl \
	e3d_v6_fan_duct.stl \
	e3d_chimera_spider_no_probe.stl \
	e3d_chimera_spider_z_probe.stl \
	universal_fan_duct.stl


all: $(MODELS:%=stl/%)

clean:
	$(RM) $(MODELS:%=stl/%)

stl-%.scad: $(SCAD)

stl-%.scad:
	echo >$@
	for d in $(SCAD); do echo "use <$$d>" >>$@; done
	echo "$*();" >>$@

stl/%.stl: stl-%.scad
	@$(MKDIR) stl
	openscad -o $@ $^
