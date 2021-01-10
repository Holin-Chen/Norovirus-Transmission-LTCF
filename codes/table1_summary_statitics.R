#descriptive statistic analysis for all norovirus outbreak
library(dplyr)

#characteristics summarized by outbreak 
noro.outbreak.summary <- noro.data_all %>%
  group_by(outbreak) %>%
  summarise(case_num = n(),
            diarrhea_pct = sum(diarrhea=="Y", na.rm = T)/case_num,
            vomit_pct = sum(vomit=="Y", na.rm = T)/case_num,
            diarrhea_num = sum(diarrhea=="Y", na.rm = T),
            vomit_num = sum(vomit=="Y", na.rm = T),
            resident_num = sum(resident_staff_other=="R", na.rm = T),
            resident_pct = resident_num/case_num,
            duration = max(onset.date, na.rm = T)-min(onset.date, na.rm = T)+1,
            onset_missing_num = sum(is.na(onset.date)),
            onset_missing_pct = onset_missing_num/case_num
            )
noro.outbreak.summary$outbreak[noro.outbreak.summary$onset_missing_pct!=0]
noro.outbreak.summary$onset_missing_pct[noro.outbreak.summary$onset_missing_pct!=0]
noro.outbreak.summary$onset_missing_num[noro.outbreak.summary$onset_missing_num!=0]
#only MN-20190035(45%) and WI-2525(19%) have more than 10% missingness of onset date
#WI-2525 has the last symptom onset date for 4 out of 6 cases without 
#start of symptom onset date , maybe can impute the onset date for these 4 cases 

#delete both MN-20190035 and WI-2525 from noro.data_all first
noro.data_all_updated <- noro.data_all[-which(noro.data_all$outbreak=="MN-20190035"),]
#characteristics summarized by outbreak from updated dataset 
noro.outbreak.summary.updated <- noro.data_all_updated %>%
  group_by(outbreak) %>%
  summarise(case_num = n(),
            diarrhea_pct = sum(diarrhea=="Y", na.rm = T)/case_num,
            vomit_pct = sum(vomit=="Y", na.rm = T)/case_num,
            duration = max(onset.date, na.rm = T)-min(onset.date, na.rm = T)+1,
            diarrhea_num = sum(diarrhea=="Y", na.rm = T),
            vomit_num = sum(vomit=="Y", na.rm = T),
            resident_num = sum(resident_staff_other=="R", na.rm = T),
            resident_pct = resident_num/case_num,
            onset_missing_num = sum(is.na(onset.date)),
            onset_missing_pct = onset_missing_num/case_num
  )

hist(noro.outbreak.summary.updated$case_num,breaks = 100) #right-skewed
hist(noro.outbreak.summary.updated$duration,breaks = 50) #right_skewed

mean(noro.outbreak.summary.updated$case_num) #31.37143
sd(noro.outbreak.summary.updated$case_num) #22.06993
summary(noro.outbreak.summary.updated$case_num)

mean(noro.outbreak.summary.updated$duration) #14.4717
sd(noro.outbreak.summary.updated$duration) #8.530628
summary(noro.outbreak.summary.updated$duration)

mean(noro.outbreak.summary.updated$diarrhea_pct) #0.7738226
mean(noro.outbreak.summary.updated$vomit_pct) #0.6444376
mean(noro.outbreak.summary.updated$resident_pct) #0.6245192

mean(noro.outbreak.summary.updated$diarrhea_num) #23.97143
sd(noro.outbreak.summary.updated$diarrhea_num) #15.74646
sum(noro.data_all_updated$diarrhea=="Y",na.rm = T) #2517
sum(noro.data_all_updated$diarrhea=="Y",na.rm = T)/3294 #0.7641166

mean(noro.outbreak.summary.updated$vomit_num) #20.3619
sd(noro.outbreak.summary.updated$vomit_num) #15.37426
sum(noro.data_all_updated$vomit=="Y",na.rm = T) #2138
sum(noro.data_all_updated$vomit=="Y",na.rm = T)/3294 #0.6490589

mean(noro.outbreak.summary.updated$resident_num) #19.24762
sd(noro.outbreak.summary.updated$resident_num) #14.64042
sum(noro.data_all_updated$resident_staff_other=="R",na.rm = T) #2021
sum(noro.data_all_updated$resident_staff_other=="R",na.rm = T)/3294 #0.6135398
 





#update table 1 with denominators delete NA
#characteristics summarized by outbreak from updated dataset 
noro.outbreak.summary.updated <- noro.data_all_updated %>%
  group_by(outbreak) %>%
  summarise(case_num = n(),
            diarrhea_pct = sum(diarrhea=="Y", na.rm = T)/sum(!is.na(diarrhea)),
            vomit_pct = sum(vomit=="Y", na.rm = T)/sum(!is.na(vomit)),
            duration = max(onset.date, na.rm = T)-min(onset.date, na.rm = T)+1,
            diarrhea_num = sum(diarrhea=="Y", na.rm = T),
            vomit_num = sum(vomit=="Y", na.rm = T),
            resident_num = sum(resident_staff_other=="R", na.rm = T),
            resident_pct = resident_num/sum(!is.na(resident_staff_other)),
            onset_missing_num = sum(is.na(onset.date)),
            onset_missing_pct = onset_missing_num/case_num,
            outbreak_year = substr(min(onset.date.char, na.rm = T), 1,4),
            # outbreak_state = substr(outbreak, 1,2),
            outbreak_month = substr(min(onset.date.char, na.rm = T), 6,7)
  )

sum(noro.data_all_updated$diarrhea=="Y",na.rm = T) #2547
sum(noro.data_all_updated$diarrhea=="Y",na.rm = T)/sum(!is.na(noro.data_all_updated$diarrhea)) #0.8504174

sum(noro.data_all_updated$vomit=="Y",na.rm = T) #2155
sum(noro.data_all_updated$vomit=="Y",na.rm = T)/sum(!is.na(noro.data_all_updated$vomit)) #0.7813633

sum(noro.data_all_updated$resident_staff_other=="R",na.rm = T) #2041
sum(noro.data_all_updated$resident_staff_other=="R",na.rm = T)/sum(!is.na(noro.data_all_updated$resident_staff_other)) #0.6274208

median(noro.outbreak.summary.updated$case_num) #26.5
quantile(noro.outbreak.summary.updated$case_num,0.25) #18.25
quantile(noro.outbreak.summary.updated$case_num,0.75) #36.75

median(noro.outbreak.summary.updated$duration) #13
quantile(noro.outbreak.summary.updated$duration,0.25) #8.25
quantile(noro.outbreak.summary.updated$duration,0.75) #18.75

median(noro.outbreak.summary.updated$resident_num) #16.5
quantile(noro.outbreak.summary.updated$resident_num,0.25) #10
quantile(noro.outbreak.summary.updated$resident_num,0.75) #24

median(noro.outbreak.summary.updated$diarrhea_num) #22
quantile(noro.outbreak.summary.updated$diarrhea_num,0.25) #14.25
quantile(noro.outbreak.summary.updated$diarrhea_num,0.75) #28

median(noro.outbreak.summary.updated$vomit_num) #16
quantile(noro.outbreak.summary.updated$vomit_num,0.25) #10
quantile(noro.outbreak.summary.updated$vomit_num,0.75) #27


#create the table 1 for all outbreak by using kable 
table <- NULL
table$variables <- c("Total Cases", "Outbreak Length", "Resident", "Diarrhea Cases", "Vomit Cases")
table$`All Outbreak (n=106)` <- c(paste0(median(noro.outbreak.summary.updated$case_num)," (",quantile(noro.outbreak.summary.updated$case_num,0.25),", ",quantile(noro.outbreak.summary.updated$case_num,0.75),")"),
                                  paste0(median(noro.outbreak.summary.updated$duration)," (",quantile(noro.outbreak.summary.updated$duration,0.25),", ",quantile(noro.outbreak.summary.updated$duration,0.75),")"),
                                  paste0(median(noro.outbreak.summary.updated$resident_num)," (",quantile(noro.outbreak.summary.updated$resident_num,0.25),", ",quantile(noro.outbreak.summary.updated$resident_num,0.75),")"),
                                  paste0(median(noro.outbreak.summary.updated$diarrhea_num)," (",quantile(noro.outbreak.summary.updated$diarrhea_num,0.25),", ",quantile(noro.outbreak.summary.updated$diarrhea_num,0.75),")"),
                                  paste0(median(noro.outbreak.summary.updated$vomit_num)," (",quantile(noro.outbreak.summary.updated$vomit_num,0.25),", ",quantile(noro.outbreak.summary.updated$vomit_num,0.75),")"))
knitr::kable(as.data.frame(table))
