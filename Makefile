## This is macpan_flow
## Created by Dubzee 2021

current: target
-include target.mk
Ignore = target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

## Download the data from wzmli site and format 
%.clean.Rout: clean.R
	$(pipeR)

## ON.clean.Rout: clean.R


## Calibrate
%.calibrate.Rout: calibrate.R get_vacdat.R get_%.clean.rds
	$(pipeR)

## ON.calibrate.Rout: calibrate.R


######################################################################
### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff

Makefile: makestuff/00.stamp
makestuff/%.stamp:
	- $(RM) makestuff/*.stamp
	(cd makestuff && $(MAKE) pull) || git clone $(msrepo)/makestuff
	touch $@

-include makestuff/os.mk

## -include makestuff/pipeR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
-include makestuff/pipeR.mk
