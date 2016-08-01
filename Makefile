
MKDIR ?= mkdir -p
OPENSCAD ?= openscad

SCAD := \
	Geeetech/rostock_g2_lock_ring.scad \
	Geeetech/rostock_g2_spider.scad \
	Geeetech/rostock_g2_jhead_x1.scad \
	Geeetech/rostock_g2_jhead_x2.scad \
	Geeetech/rostock_pro_spider.scad \
	mk8_extruder_guide.scad \
	rod_end_shim.scad \
	e3d_chimera_spider.scad \
	ptfe_splicer.scad \
	universal_spider.scad \
	universal_probe.scad \
	universal_fan_duct.scad \
	mcspider.scad

MODELS := \
	geeetech_rostock_g2_lock_ring.stl \
	geeetech_rostock_g2_spider_no_probe.stl \
	geeetech_rostock_g2_spider_z_probe.stl \
	geeetech_rostock_g2_jhead_x1_upper.stl \
	geeetech_rostock_g2_jhead_x1_lower.stl \
	geeetech_rostock_g2_jhead_x2_upper.stl \
	geeetech_rostock_g2_jhead_x2_lower.stl \
	geeetech_rostock_pro_spider.stl \
	mk8_extruder_guide.stl \
	rod_end_shim.stl \
	e3d_v6_lock_x1.stl \
	e3d_v6_lock_x2.stl \
	jhead_lock_x1.stl \
	jhead_lock_x2.stl \
	e3d_chimera_spider_no_probe.stl \
	e3d_chimera_spider_z_probe.stl \
	ptfe_splicer.stl \
	universal_spider.stl \
	universal_spider_plate.stl \
	universal_probe.stl \
	universal_fan_duct_blower_adapter.stl \
	universal_fan_duct_foot_single.stl \
	universal_fan_duct_foot_g2s.stl \
	universal_fan_duct_foot_g2s_pro.stl \
	universal_fan_duct_foot_e3d_x2.stl \
	universal_fan_duct_clip.stl \
	universal_fan_duct_pipe.stl \
	universal_fan_duct_pipe_connector.stl \
	universal_fan_duct_22mm_connector.stl \
	mcspider_lock_x1_fan.stl \
	mcspider_lock_x1_foot.stl \
	mcspider_lock_x2.stl \
	mcspider_foot.stl \
	mcspider_effector.stl



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
