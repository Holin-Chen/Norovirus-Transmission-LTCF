library(dplyr)
library(metafor)
library(expss)
library(lme4)

within_var_Rt <- Rt.data_all %>%
  group_by(outbreak) %>%
  summarise(count = sum(Incidence), 
            within.var = var(R))

between_var_Rt <- anova(lm(R ~ factor(outbreak), Rt.data_all))
between.var.Rt <- between_var_Rt$`Sum Sq`[1]/between_var_Rt$Df[1]

meta.data <- right_join(Rt.data_all, noro.data_all_updated, by=c("outbreak", "date"="onset.date.char"))
meta.data <- left_join(meta.data, within_var_Rt, by="outbreak")
meta.data$between.var <- between.var.Rt
meta.data$weight <- 1/(meta.data$variation+meta.data$within.var+meta.data$between.var)

meta.data <- meta.data[!is.na(meta.data$R),]
meta.data <- meta.data[-which(meta.data$R==0),]

table(meta.data$diarrhea, useNA="ifany")
meta.data$diarrhea[which(meta.data$diarrhea=="NO")] <- "N"
meta.data$diarrhea[which(meta.data$diarrhea=="?")] <- NA
meta.data$diarrhea[which(meta.data$diarrhea=="N/A")] <- NA
meta.data$diarrhea[which(meta.data$diarrhea=="UNKNOWN")] <- NA
meta.data$diarrhea[which(meta.data$diarrhea=="YES")] <- "Y"

table(meta.data$vomit, useNA="ifany")
meta.data$vomit[which(meta.data$vomit=="NO")] <- "N"
meta.data$vomit[which(meta.data$vomit=="?")] <- NA
meta.data$vomit[which(meta.data$vomit=="N (?)")] <- "N"
meta.data$vomit[which(meta.data$vomit=="YES")] <- "Y"

table(meta.data$resident_staff_other, useNA="ifany")
meta.data$resident_staff_other[which(meta.data$resident_staff_other=="E")] <- "S"

meta.mix.reg <- rma.mv(yi=log(R), V=variation+0.01, W=weight, struct="UN",
                       mods=~resident_staff_other + diarrhea + vomit, method="REML", random= ~ 1 | as.factor(outbreak), data=meta.data)

meta.mix.reg_exp <- cbind(exp(meta.mix.reg$beta), exp(meta.mix.reg$ci.lb), exp(meta.mix.reg$ci.ub))





