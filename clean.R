## download the reported data from wzmli's COVID19-Canada repo

library(shellpipes)
library(McMasterPandemic)
library(readr)
library(dplyr)
library(tidyr)

prov <- unlist(strsplit(targetname(),"[.]"))[1]

url <- "https://raw.githubusercontent.com/wzmli/COVID19-Canada/master/git_push/clean.Rout.csv"
    
dd <- read_csv(url)
    
all <- (dd
	%>% select(Province,Date,Hospitalization,ICU,Ventilator,deceased,newConfirmations,bestTotal)
	%>% group_by(Province)
	%>% mutate(newDeaths=c(NA,diff(deceased))
		, newtotal = bestTotal
		, newTests = diff(c(NA,newtotal))
		, newConfirmations = ifelse((newTests == 0) & (newConfirmations == 0), NA, newConfirmations)
		)
	%>% select(-c(deceased,newTests,newtotal))
	%>% pivot_longer(names_to="var",-c(Date,Province))
	%>% setNames(tolower(names(.)))
	%>% ungroup()
)
    
## translate variable names to internally used values
## drop unused variables
keep_vars <- c("H","ICU","death","report","bestTotal")
    
all_sub <- (all
	%>% mutate_at("var",trans_state_vars)
	%>% filter(var %in% keep_vars)
	)

province_dat <- filter(all_sub, province == prov)

stopifnot(nrow(province_dat) > 0)

print(province_dat)

rdsSave(province_dat)
