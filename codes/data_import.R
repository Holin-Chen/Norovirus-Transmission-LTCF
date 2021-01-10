#extract the data from Wisconsin;
library("readxl")

#extract all the data file names;
dataFileNames <- list.files("./data-checked/Wisconsin", full.names=TRUE, recursive = TRUE, include.dirs = TRUE)

noro.data <- matrix(NA, nrow=1, ncol=6)

for (i in 1:length(dataFileNames)){
  tmp <- read_excel(path = dataFileNames[i], sheet = "Line List")
  noro.data <- rbind(noro.data,cbind(rep(substr(dataFileNames[i],26,32),length(tmp$`Case Number`)), tmp$`Case Number`,tmp$`Symptom Onset Date (MM/DD/YYYY)`, tmp$`Resident/Staff/Other`,tmp$Diarrhea,tmp$Vomit))
}

noro.data <- as.data.frame(noro.data)
names(noro.data) <- c("outbreak","case.id","onset","resident_staff_other","diarrhea","vomit")

#remove lines without case ID;
noro.data <- noro.data[which(!is.na(noro.data$case.id)),]
#format variables;
#onset date;
noro.data$onset <- as.numeric(noro.data$onset)
noro.data$onset.date <- NA
noro.data$onset.date[which(noro.data$onset<100000)] <- as.Date(noro.data$onset[which(noro.data$onset<100000)],origin="1899-12-30")
noro.data$onset.date[which(noro.data$onset>100000)] <- as.Date(as.character(as.POSIXct(noro.data$onset[which(noro.data$onset>100000)], origin='1970-01-01', tz = "GMT")))
noro.data <- noro.data[,-which(names(noro.data)=="onset")]
noro.data$onset.date.char <- as.character(as.Date(noro.data$onset.date,origin="1970-01-01"))

#other variables;
noro.data$resident_staff_other <- toupper(noro.data$resident_staff_other)
noro.data$resident_staff_other[which(noro.data$resident_staff_other=="RESIDENT")] <- "R"
noro.data$resident_staff_other[which(noro.data$resident_staff_other=="STAFF")] <- "S"
noro.data$diarrhea <- toupper(noro.data$diarrhea)
noro.data$vomit <- toupper(noro.data$vomit)
noro.data <- noro.data[,c(1,3:7,2)]

#delete "fake" case with only case ID
noro.data <- noro.data[-which(is.na(noro.data$resident_staff_other)&
                                is.na(noro.data$diarrhea)&is.na(noro.data$vomit)&
                                is.na(noro.data$onset.date)&is.na(noro.data$onset.date.char)),]

#summary of variable in WI
table(noro.data$resident_staff_other,useNA = "ifany") #no missing S/R info
table(noro.data$diarrhea,useNA = "ifany") #305 missing diarrhea info 
table(noro.data$vomit,useNA = "ifany") # 524 missing vomit info
table(noro.data$onset.date.char,useNA = "ifany")
sum(is.na(noro.data$onset.date.char)) #12 onset date unknown


### import norovirus outbreak data from MI ###

dataFileNames_MI <- list.files("./data-checked/Minnesota", full.names=TRUE, recursive = TRUE, include.dirs = TRUE)
dataFileNames_MI <- dataFileNames_MI[grep("*MN",dataFileNames_MI)]


noro.data_MI <- matrix(NA, nrow=1, ncol=6)

for (i in 1:length(dataFileNames_MI)){
  tmp <- read_excel(path = dataFileNames_MI[i], sheet = "Line List")
  noro.data_MI <- rbind(noro.data_MI,cbind(rep(substr(dataFileNames_MI[i],26,36),length(tmp$`Case Number`)), tmp$`Case Number`,tmp$`Symptom Onset Date (MM/DD/YYYY)`, tmp$`Resident/Staff/Other`,tmp$`Diarrhea (Y/N)`,tmp$`Vomit   (Y/N)`))
}

noro.data_MI <- as.data.frame(noro.data_MI)
names(noro.data_MI) <- c("outbreak","case.id","onset","resident_staff_other","diarrhea","vomit")

tmp <- read_excel(path = "./Data-Checked/Minnesota/MN-20190112-checked.xlsx", sheet = "Line List")
noro.data_MI_1 <- cbind(rep(("MN-20190112"),length(tmp$`Case Number`)), tmp$`Case Number`,tmp$`Symptom Onset Date (MM/DD/YYYY)`, tmp$`Resident/Staff/Other`,tmp$Diarrhea,tmp$Vomit)
noro.data_MI_1 <- as.data.frame(noro.data_MI_1)
names(noro.data_MI_1) <- c("outbreak","case.id","onset","resident_staff_other","diarrhea","vomit")
noro.data_MI_1 <- noro.data_MI_1[which(!is.na(noro.data_MI_1$case.id)),]

noro.data_MI <- rbind(noro.data_MI,noro.data_MI_1)

#format variables;
#onset date;
noro.data_MI$onset <- as.numeric(noro.data_MI$onset)
noro.data_MI$onset.date <- NA
noro.data_MI$onset.date[which(noro.data_MI$onset<100000)] <- as.Date(noro.data_MI$onset[which(noro.data_MI$onset<100000)],origin="1899-12-30")
noro.data_MI$onset.date[which(noro.data_MI$onset>100000)] <- as.Date(as.character(as.POSIXct(noro.data_MI$onset[which(noro.data_MI$onset>100000)], origin='1970-01-01', tz = "GMT")))
noro.data_MI <- noro.data_MI[,-which(names(noro.data_MI)=="onset")]
noro.data_MI$onset.date.char <- as.character(as.Date(noro.data_MI$onset.date,origin="1970-01-01"))

#other variables;
noro.data_MI$resident_staff_other <- toupper(noro.data_MI$resident_staff_other)
noro.data_MI$resident_staff_other[which(noro.data_MI$resident_staff_other=="RESIDENT")] <- "R"
noro.data_MI$resident_staff_other[which(noro.data_MI$resident_staff_other=="STAFF")] <- "S"
noro.data_MI$diarrhea <- toupper(noro.data_MI$diarrhea)
noro.data_MI$vomit <- toupper(noro.data_MI$vomit)

#delete "fake" case with only case ID
noro.data_MI <- noro.data_MI[-which(is.na(noro.data_MI$resident_staff_other)&
                                is.na(noro.data_MI$diarrhea)&is.na(noro.data_MI$vomit)&
                                is.na(noro.data_MI$onset.date)&is.na(noro.data_MI$onset.date.char)),]
#create case ID in MI
noro.data_MI$case.id <- NULL
for (i in 1:length(noro.data_MI$outbreak)){
  noro.data_MI$case.id[1] <- 1
  if (noro.data_MI$outbreak[i]==noro.data_MI$outbreak[i+1]){
    noro.data_MI$case.id[i+1] <- noro.data_MI$case.id[i] + 1
  }
  if (noro.data_MI$outbreak[i]!=noro.data_MI$outbreak[i+1]){
    noro.data_MI$case.id[i+1] <- 1
  }
}

#summary of variable in MI
table(noro.data_MI$resident_staff_other,useNA = "ifany") #1 missing S/R info
table(noro.data_MI$diarrhea,useNA = "ifany") #38 missing diarrhea info 
table(noro.data_MI$vomit,useNA = "ifany") # 49 missing vomit info
table(noro.data_MI$onset.date.char,useNA = "ifany")
sum(is.na(noro.data_MI$onset.date.char)) #11 onset date unknown




### import norovirus outbreak data from NM ###

dataFileNames_NM <- list.files("./data-checked/New Mexico", full.names=TRUE, recursive = TRUE, include.dirs = TRUE)
dataFileNames_NM <- dataFileNames_NM[grep("*NM",dataFileNames_NM)]

noro.data_NM <- matrix(NA, nrow=1, ncol=6)

for (i in 1:length(dataFileNames_NM)){
  tmp <- read_excel(path = dataFileNames_NM[i], sheet = "Line List")
  noro.data_NM <- rbind(noro.data_NM,cbind(rep(substr(dataFileNames_NM[i],27,37),length(tmp$`Case Number`)), tmp$`Case Number`,tmp$`Symptom Onset Date (MM/DD/YYYY)`, tmp$`Resident/Staff/Other`,tmp$`Diarrhea (Y/N)`,tmp$`Vomit   (Y/N)`))
}

noro.data_NM <- as.data.frame(noro.data_NM)
names(noro.data_NM) <- c("outbreak","case.id","onset","resident_staff_other","diarrhea","vomit")
#format variables;
#onset date;
noro.data_NM$onset <- as.numeric(noro.data_NM$onset)
noro.data_NM$onset.date <- NA
noro.data_NM$onset.date[which(noro.data_NM$onset<100000)] <- as.Date(noro.data_NM$onset[which(noro.data_NM$onset<100000)],origin="1899-12-30")
noro.data_NM$onset.date[which(noro.data_NM$onset>100000)] <- as.Date(as.character(as.POSIXct(noro.data_NM$onset[which(noro.data_NM$onset>100000)], origin='1970-01-01', tz = "GMT")))
noro.data_NM <- noro.data_NM[,-which(names(noro.data_NM)=="onset")]
noro.data_NM$onset.date.char <- as.character(as.Date(noro.data_NM$onset.date,origin="1970-01-01"))

#other variables;
noro.data_NM$resident_staff_other <- toupper(noro.data_NM$resident_staff_other)
noro.data_NM$resident_staff_other[which(noro.data_NM$resident_staff_other=="RESIDENT")] <- "R"
noro.data_NM$resident_staff_other[which(noro.data_NM$resident_staff_other=="STAFF")] <- "S"
noro.data_NM$diarrhea <- toupper(noro.data_NM$diarrhea)
noro.data_NM$vomit <- toupper(noro.data_NM$vomit)

#delete "fake" case with only case ID
noro.data_NM <- noro.data_NM[-which(is.na(noro.data_NM$resident_staff_other)&
                                      is.na(noro.data_NM$diarrhea)&is.na(noro.data_NM$vomit)&
                                      is.na(noro.data_NM$onset.date)&is.na(noro.data_NM$onset.date.char)),]

#summary of variable in NM
table(noro.data_NM$resident_staff_other,useNA = "ifany") #101 missing S/R info
table(noro.data_NM$diarrhea,useNA = "ifany") #106 missing diarrhea info 
table(noro.data_NM$vomit,useNA = "ifany") # NO missing vomit info
table(noro.data_NM$onset.date.char,useNA = "ifany")
sum(is.na(noro.data_NM$onset.date.char)) #NO missing onset date

#create case ID in MI
noro.data_NM$case.id <- NULL
for (i in 1:length(noro.data_NM$outbreak)){
  noro.data_NM$case.id[1] <- 1
  if (noro.data_NM$outbreak[i]==noro.data_NM$outbreak[i+1]){
    noro.data_NM$case.id[i+1] <- noro.data_NM$case.id[i] + 1
  }
  if (noro.data_NM$outbreak[i]!=noro.data_NM$outbreak[i+1]){
    noro.data_NM$case.id[i+1] <- 1
  }
}


### import norovirus outbreak data from SC ###

dataFileNames_SC <- list.files("./Data-Checked/South Carolina", full.names=TRUE, recursive = TRUE, include.dirs = TRUE)
dataFileNames_SC <- dataFileNames_SC[grep("*SC-",dataFileNames_SC)]

noro.data_SC <- matrix(NA, nrow=1, ncol=6)

for (i in 2:length(dataFileNames_SC)){
  tmp <- read_excel(path = dataFileNames_SC[i], sheet = "Line List", col_names = F)
  noro.data_SC <- rbind(noro.data_SC,cbind(rep(substr(dataFileNames_SC[i],31,34),length(tmp$`...1`)), tmp$`...1`,tmp$`...2`,tmp$`...6`,tmp$`...8`,tmp$`...9`))
}
noro.data_SC <- as.data.frame(noro.data_SC)
names(noro.data_SC) <- c("outbreak","case.id","resident_staff_other","onset","diarrhea","vomit")

noro.data_SC_1 <- read_excel(path = dataFileNames_SC[1], sheet = "Linelist", col_names = F)
noro.data_SC_1 <- cbind(rep(substr(dataFileNames_SC[1],31,34)), noro.data_SC_1[,c("...5","...1","...6","...8","...9")])
names(noro.data_SC_1) <- c("outbreak","case.id","resident_staff_other","onset","diarrhea","vomit")
 
noro.data_SC <- rbind(noro.data_SC_1, noro.data_SC)

#delete colname 
noro.data_SC <- noro.data_SC[-which(noro.data_SC$diarrhea=="D (Y/N)"),] 
noro.data_SC <- noro.data_SC[-which(noro.data_SC$diarrhea=="D                 (Y/N)"),]
noro.data_SC <- noro.data_SC[-which(is.na(noro.data_SC$resident_staff_other)&
                                      is.na(noro.data_SC$diarrhea)&is.na(noro.data_SC$vomit)&
                                      is.na(noro.data_SC$onset)),]

#format variables;
#onset date;
noro.data_SC$onset[grep("@",noro.data_SC$onset)] <- gsub("@.*","",noro.data_SC$onset[grep("@",noro.data_SC$onset)])
noro.data_SC$onset[which(noro.data_SC$onset=="2/18/2015 ")] <- "2/18/15"
noro.data_SC$onset[grep("am",noro.data_SC$onset)] <- gsub("am","",noro.data_SC$onset[grep("am",noro.data_SC$onset)])
noro.data_SC$onset[which(noro.data_SC$onset=="April 14 2015")] <- "4/14/15"
noro.data_SC$onset[grep("/",noro.data_SC$onset)] <- as.Date(noro.data_SC$onset[grep("/",noro.data_SC$onset)], "%m/%d/%y") 

noro.data_SC$onset <- as.numeric(noro.data_SC$onset)
noro.data_SC$onset.date <- NA
noro.data_SC$onset.date[which(noro.data_SC$onset<40000)] <- noro.data_SC$onset[which(noro.data_SC$onset<40000)]
noro.data_SC$onset.date[which(noro.data_SC$onset>40000)] <- as.Date(noro.data_SC$onset[which(noro.data_SC$onset>40000)],origin="1899-12-30")
noro.data_SC <- noro.data_SC[,-which(names(noro.data_SC)=="onset")]
noro.data_SC$onset.date.char <- as.character(as.Date(noro.data_SC$onset.date,origin="1970-01-01"))

#other variables;
noro.data_SC$resident_staff_other <- toupper(noro.data_SC$resident_staff_other)
noro.data_SC$resident_staff_other[which(noro.data_SC$resident_staff_other=="RESIDENT"|
                                          noro.data_SC$resident_staff_other=="RES"|
                                          noro.data_SC$resident_staff_other=="RES."|
                                          noro.data_SC$resident_staff_other=="RESDIENT")] <- "R"
noro.data_SC$resident_staff_other[which(noro.data_SC$resident_staff_other=="STAFF")] <- "S"
noro.data_SC$diarrhea <- toupper(noro.data_SC$diarrhea)
noro.data_SC$vomit <- toupper(noro.data_SC$vomit)



#summary of variable in SC
table(noro.data_SC$resident_staff_other,useNA = "ifany") #NO missing S/R info
table(noro.data_SC$diarrhea,useNA = "ifany") #2 missing diarrhea info 
table(noro.data_SC$vomit,useNA = "ifany") # 9 missing vomit info
table(noro.data_SC$onset.date.char,useNA = "ifany")
sum(is.na(noro.data_SC$onset.date.char)) #1 missing onset date

#create case ID in MI
noro.data_SC$case.id <- NULL
for (i in 1:length(noro.data_SC$outbreak)){
  noro.data_SC$case.id[1] <- 1
  if (noro.data_SC$outbreak[i]==noro.data_SC$outbreak[i+1]){
    noro.data_SC$case.id[i+1] <- noro.data_SC$case.id[i] + 1
  }
  if (noro.data_SC$outbreak[i]!=noro.data_SC$outbreak[i+1]){
    noro.data_SC$case.id[i+1] <- 1
  }
}



### import norovirus outbreak data from OH ###
dataFileNames_OH <- list.files("./Data-Checked/Ohio", full.names=TRUE, recursive = TRUE, include.dirs = TRUE)
tmp <- read_excel(path = dataFileNames_OH, sheet = "Line List")
noro.data_OH <- cbind(rep("OH-2019-05-029",length(tmp$`Case Number`)), tmp$`Case Number`,tmp$`Symptom Onset Date (MM/DD/YYYY)`, tmp$`Resident/Staff/Other`,tmp$Diarrhea,tmp$Vomit)
noro.data_OH <- as.data.frame(noro.data_OH)
names(noro.data_OH) <- c("outbreak","case.id","onset","resident_staff_other","diarrhea","vomit")

#delete colname 
noro.data_OH <- noro.data_OH[-1,]


noro.data_OH$onset <- as.numeric(noro.data_OH$onset)
noro.data_OH$onset.date <- NA
noro.data_OH$onset.date[which(noro.data_OH$onset<100000)] <- as.Date(noro.data_OH$onset[which(noro.data_OH$onset<100000)],origin="1899-12-30")
noro.data_OH$onset.date[which(noro.data_OH$onset>100000)] <- as.Date(as.character(as.POSIXct(noro.data_OH$onset[which(noro.data_OH$onset>100000)], origin='1970-01-01', tz = "GMT")))
noro.data_OH <- noro.data_OH[,-which(names(noro.data_OH)=="onset")]
noro.data_OH$onset.date.char <- as.character(as.Date(noro.data_OH$onset.date,origin="1970-01-01"))

#other variables;
noro.data_OH$resident_staff_other <- toupper(noro.data_OH$resident_staff_other)
noro.data_OH$resident_staff_other[which(noro.data_OH$resident_staff_other=="RESIDENT")] <- "R"
noro.data_OH$resident_staff_other[which(noro.data_OH$resident_staff_other=="STAFF")] <- "S"
noro.data_OH$diarrhea <- toupper(noro.data_OH$diarrhea)
noro.data_OH$vomit <- toupper(noro.data_OH$vomit)


noro.data_OH <- noro.data_OH[,c(1,3:7,2)]

#summary of variable in OH
table(noro.data_OH$resident_staff_other,useNA = "ifany") #NO missing S/R info
table(noro.data_OH$diarrhea,useNA = "ifany") #NO missing diarrhea info 
table(noro.data_OH$vomit,useNA = "ifany") # NO missing vomit info
table(noro.data_OH$onset.date.char,useNA = "ifany")
sum(is.na(noro.data_OH$onset.date.char)) #NO missing onset date

### aggregate all the dataset together ###
noro.data_all <- rbind(noro.data_SC,noro.data_MI,noro.data_NM,noro.data_OH,noro.data)
noro.data_all <- noro.data_all[,c(1,7,6,2:5)]
save(noro.data_all,file="all line lists dataset.RDA")
