
MKDIR ?= mkdir -p
OPENSCAD ?= openscad

SCAD := \
	Geeetech/rostock_g2_lock_ring.scad \
	Geeetech/rostock_g2_spider.scad \
	Geeetech/rostock_g2_jhead_x1.scad \
	Geeetech/rostock_g2_jhead_x2.scad \
	mk8_extruder_guide.scad \
	rod_end_shim.scad \
	e3d_v6_mount.scad \
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
	e3d_v6_x1_mount_upper.stl \
	e3d_v6_x1_mount_lower.stl \
	e3d_v6_x2_mount_upper.stl \
	e3d_v6_x2_mount_lower.stl \
	e3d_v6_x2_spider.stl \
	e3d_v6_x2_lock.stl \
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
