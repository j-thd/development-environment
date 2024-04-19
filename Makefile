## Setting up PATH variable
arm-toolchain := C:\Program Files\ArmCompilerforEmbedded6.22\bin
tivaware-toolchain := C:\ti\TivaWare_C_Series-2.2.0.295\tools\bin
gnuwin32-bin := C:\Program Files (x86)\GnuWin32\bin

export PATH:=$(arm-toolchain);$(tivaware-toolchain);$(gnuwin32-bin);$(PATH)

target-device := TM4C123GH6PM
startup-code := ./device/$(target-device)
scatter-file := $(startup-code)/scatter.txt
cpu := cortex-m4

## FINDING FILES TO BUILD
# Find all regular source files and create target names pointing to them in the build directory.
build-dir := ./build
source-dir := ./src
sub-source-dirs := $(shell find $(source-dir) -type d) # installed findutils on windows to make this work. There's no "nice" other solution
all-source-dirs := $(source-dir) $(sub-source-dirs) #$(addprefix $(source-dir)/, $(sub-source-dirs))

# Find all regular source files with these extensions, put wildcards in them, and use wildcard command to actually match them existing files
source-file-extensions := c s
all-source-wildcards := $(foreach var,$(source-file-extensions), $(addsuffix /*.$(var),$(all-source-dirs)))
all-source-files := $(wildcard $(all-source-wildcards))

# Find all startup code (located in just one folder preferably)
startup-code-source-files := $(wildcard $(startup-code)/*.s) $(wildcard $(startup-code)/*.c)
startup-code-object-files := $(startup-code-source-files:%=$(build-dir)/%.o)

# Finally generate all the target object file names
all-object-files := $(all-source-files:%=$(build-dir)/%.o) $(startup-code-object-files)

## TARGET FILES
target-image := $(build-dir)/image/$(target-device).axf
target-binary := $(build-dir)/image/$(target-device).bin

# Finding the correct mkdir on windows (by using where). This overrides the default mkdir, which is not an executable. 
# Not sure if this works on Unix systems, too. Also not sure how to handle it if it returns multiple values
MKDIR ?= $(shell where mkdir)



# Include paths
inc_custom_cmsis := C:\code\custom-cmsis
inc_arm_core_cmsis := C:\code\custom-cmsis\CMSIS-arm-default\Core\Include
INC_PATH := $(inc_cmsis)



#.PHONY: all
#all: source-files startup-code

all: $(target-binary)

.PHONY: flash
flash: $(target-binary)
	lmflash $^ -v -i ICDI 

$(target-binary): $(target-image)
	$(MKDIR) -p $(@D)
	fromelf --bin -o $@ $^

# Link all object files into target image
$(target-image): $(all-object-files)
	$(MKDIR) -p $(@D)
	armlink --scatter=$(scatter-file) $^ -o $@

# Build all c-files
$(build-dir)/%.c.o: %.c
	$(MKDIR) -p $(@D)
	armclang -c -g -std=c11 -D$(target-device) --include-directory=$(inc_custom_cmsis) -I$(inc_arm_core_cmsis) --target=arm-arm-none-eabi -mcpu=$(cpu) $< -o $@ 

# Build all assembly s-files
$(build-dir)/%.s.o: %.s
	$(MKDIR) -p $(@D)
	armclang  -masm=auto -c -g -std=c11 -D$(target-device) --include-directory=$(inc_custom_cmsis) -I$(inc_arm_core_cmsis) --target=arm-arm-none-eabi -mcpu=$(cpu) $< -o $@ 

#startup-code:$(wildcard $(startup-code)/*.s) $(wildcard $(startup-code)/*.c) 
#	armclang -masm=auto -Wa,armasm,--diag_suppress=A1950W -c -g -D$(target-device) --include-directory=$(inc_custom_cmsis) -I$(inc_arm_core_cmsis) --target=arm-arm-none-eabi -mcpu=$(cpu) $?


# Phony target for debugging.
.PHONY: perp
perp:
	find $(source-dir) -type d
	@echo $(all-source-files)
	@echo $(all-object-files)



.PHONY: clean
clean:
	rm -r $(build-dir)