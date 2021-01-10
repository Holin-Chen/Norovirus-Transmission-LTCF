library(EpiEstim)
library(dplyr)

#a function to generate estimated Rt from EpiEstim based on outbreak's name
Rt_estimate <- function(x){
  time <- noro.data_all[which(noro.data_all$outbreak==x),"onset.date"]
  tm <- (time+1) - min(time,na.rm=TRUE)
  tm <- ifelse(is.na(tm), tm[-which(is.na(tm))],tm)
  date_count <- as.data.frame(table(tm))
  
  incid <- NULL
  for (i in (1:max(tm))) {
    incid[i] <- sum(tm==i)
  }
  incid <- c(0,0,incid) 
  
  estimates <- wallinga_teunis(incid, 
                               method="parametric_si",
                               config = list(t_start = seq(3, length(incid)), 
                                             t_end = seq(3, length(incid)),
                                             mean_si = 3.6, 
                                             std_si = 2.0, 
                                             n_sim = 1000))
  
  epicurve <- noro.data_all[which(noro.data_all$outbreak==x),] %>%
    group_by(onset.date.char) %>%
    filter(!is.na(onset.date.char)) %>%
    summarise(incidence=n())
  
  Rt.data <-as.data.frame(cbind(rep(x,length(epicurve$incidence)), epicurve, 
                                estimates$R$`Mean(R)`, estimates$R$`Quantile.0.025(R)`, estimates$R$`Quantile.0.975(R)`, (estimates$R$`Std(R)`)^2))
  names(Rt.data) <- c("outbreak","date","Incidence", "R", "lowerCI", "upperCI", "variation")
  
  return(Rt.data)
  
}

#use the function above to generate all outbreaks' Rts in a combined dataset
Rt.data_all <- NULL
for (i in unique(noro.data_all$outbreak)){
  Rt.data_all <- rbind(Rt.data_all, Rt_estimate(i))
} 

save(Rt.data_all, file="Rt data from all line lists.RDA")


