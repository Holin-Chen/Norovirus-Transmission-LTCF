library(ggplot2)

for (i in unique(Rt.data_all$outbreak)) {
  epi.plot <- ggplot(data=Rt.data_all[Rt.data_all$outbreak==i,], aes(x=as.Date(date), y=Incidence, labs=FALSE)) + 
    geom_bar(stat="identity", fill="gray45") +
    scale_x_date(date_breaks = "2 days", date_labels = "%m/%d") +
    scale_y_continuous(breaks = seq(0,30, by = 2)) +
    theme(axis.text.x = element_text(angle = 45)) +
    labs(x = "Symptom Onset Date", 
         y = "Number of Cases",
         title = paste0("Epi Curve and Rt Curve for ",i," Norovirus Outbreak")) +
    geom_hline(aes(yintercept=1), colour="red", linetype="dashed", size=0.5) +
    geom_errorbar(data=Rt.data_all[Rt.data_all$outbreak==i,], aes(ymax=upperCI, ymin=lowerCI, width=0.6),stat="identity", size=0.8, show.legend=FALSE) +
    geom_line(data=Rt.data_all[Rt.data_all$outbreak==i,],aes(x=as.Date(date), y=R), color='blue', size=0.5) +
    geom_point(data = Rt.data_all[Rt.data_all$outbreak==i,], aes(x=as.Date(date), y=R), size=1.2, show.legend=FALSE) 

    ggsave(filename=paste0("./epicurve plots/",i,".pdf"),width=8, height=8)    
}

library(ggplot2)

for (i in unique(Rt.data_all$outbreak)) {
  epi.plot <- ggplot(data=Rt.data_all[Rt.data_all$outbreak==i,], aes(x=as.Date(date), y=Incidence, labs=FALSE)) + 
    geom_bar(stat="identity", fill="gray45") +
    scale_x_date(date_breaks = "2 days", date_labels = "%m/%d") +
    scale_y_continuous(breaks = seq(0,30, by = 2)) +
    theme(axis.text.x = element_text(angle = 45)) +
    labs(x = "Symptom Onset Date", 
         y = "Number of Cases",
         title = paste0("Epi Curve and Rt Curve for ",i," Norovirus Outbreak")) +
    geom_hline(aes(yintercept=1), colour="red", linetype="dashed", size=0.5) +
    geom_errorbar(data=Rt.data_all[Rt.data_all$outbreak==i,], aes(ymax=upperCI, ymin=lowerCI, width=0.6),stat="identity", size=0.8, show.legend=FALSE) +
    geom_line(data=Rt.data_all[Rt.data_all$outbreak==i,],aes(x=as.Date(date), y=R), color='blue', size=0.5) +
    geom_point(data = Rt.data_all[Rt.data_all$outbreak==i,], aes(x=as.Date(date), y=R), size=1.2, show.legend=FALSE) 
  
  ggsave(filename=paste0("./epicurve plots/",i,".png"),width=8, height=8)    
}

length(unique(Rt.data_all[Rt.data_all$outbreak==i,Rt.data]))