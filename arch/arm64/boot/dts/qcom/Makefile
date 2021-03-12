# SPDX-License-Identifier: GPL-2.0
ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY),y)
	dtbo-$(CONFIG_ARCH_SDMMAGPIE) += \
		sdmmagpie-idp-overlay.dtbo \
		sdmmagpie-atp-overlay.dtbo \
		sdmmagpie-rumi-overlay.dtbo \
		sdmmagpie-qrd-overlay.dtbo \
		davinci-sdmmagpie-overlay.dtbo \
		davinci_m0a-sdmmagpie-overlay.dtbo \
		davinci_m0b-sdmmagpie-overlay.dtbo \
		phoenix-sdmmagpie-overlay.dtbo \
		tucana-sdmmagpie-overlay.dtbo \
		toco-sdmmagpie-overlay.dtbo \
		sdmmagpiep-idp-overlay.dtbo \
		sdmmagpiep-atp-overlay.dtbo \
		sdmmagpiep-qrd-overlay.dtbo \
		sdmmagpie-external-codec-idp-overlay.dtbo \
		sdmmagpie-usbc-idp-overlay.dtbo \
		sdmmagpie-dual-display-idp-overlay.dtbo

sdmmagpie-idp-overlay.dtbo-base := sdmmagpie.dtb
sdmmagpie-atp-overlay.dtbo-base := sdmmagpie.dtb
sdmmagpie-rumi-overlay.dtbo-base := sdmmagpie.dtb
sdmmagpie-qrd-overlay.dtbo-base := sdmmagpie.dtb
davinci-sdmmagpie-overlay.dtbo-base := sdmmagpie.dtb
tucana-sdmmagpie-overlay.dtbo-base := sdmmagpie.dtb
toco-sdmmagpie-overlay.dtbo-base := sdmmagpie.dtb
davinci_m0a-sdmmagpie-overlay.dtbo-base := sdmmagpie.dtb
davinci_m0b-sdmmagpie-overlay.dtbo-base := sdmmagpie.dtb
phoenix-sdmmagpie-overlay.dtbo-base := sdmmagpie.dtb
sdmmagpiep-idp-overlay.dtbo-base := sdmmagpiep.dtb
sdmmagpiep-atp-overlay.dtbo-base := sdmmagpiep.dtb
sdmmagpiep-qrd-overlay.dtbo-base := sdmmagpiep.dtb
sdmmagpie-external-codec-idp-overlay.dtbo-base := sdmmagpie.dtb
sdmmagpie-usbc-idp-overlay.dtbo-base := sdmmagpie.dtb
sdmmagpie-dual-display-idp-overlay.dtbo-base := sdmmagpie.dtb
else
dtb-$(CONFIG_ARCH_SDMMAGPIE)	+= sdmmagpie-rumi.dtb \
	sdmmagpie-idp.dtb \
	sdmmagpie-atp.dtb \
	sdmmagpie-qrd.dtb \
	sdmmagpiep-idp.dtb \
	sdmmagpiep-atp.dtb \
	sdmmagpiep-qrd.dtb \
	davinci-sdmmagpie.dtb \
	tucana-sdmmagpie.dtb \
	toco-sdmmagpie.dtb \
	davinci_m0a-sdmmagpie.dtb \
	davinci_m0b-sdmmagpie.dtb \
	phoenix-sdmmagpie.dtb \
	sdmmagpie-external-codec-idp.dtb \
	sdmmagpie-usbc-idp.dtb \
	sdmmagpie-dual-display-idp.dtb
endif

ifeq ($(CONFIG_ARM64),y)
always		:= $(dtb-y)
subdir-y	:= $(dts-dirs)
else
targets += dtbs
targets += $(addprefix ../, $(dtb-y))

$(obj)/../%.dtb: $(src)/%.dts FORCE
	$(call if_changed_dep,dtc)

ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY),y)
$(obj)/%.dtbo:$(src)/../../../../arm64/boot/dts/qcom/%.dts FORCE
	$(call if_changed_dep,dtc)
	$(call if_changed,dtbo_verify)

dtbs: $(addprefix $(obj)/,$(dtb-y)) $(addprefix $(obj)/,$(dtbo-y))
else
dtbs: $(addprefix $(obj)/../,$(dtb-y))
endif
endif
clean-files	:= *.dtb *.dtbo
