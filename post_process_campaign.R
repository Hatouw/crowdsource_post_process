#library activiation
library(dplyr)
library(DBI)
library(RPostgreSQL)
library(rpostgis)
library(RSQLite)
library(ggplot2)

#postgresql connect
drv <- dbDriver("PostgreSQL")
con <- dbConnect(
  drv, dbname="urun_data", host="149.129.220.108", port="5432", user="urundata", password="Urundata2018!"
)

#read postgresql data
tbl_extradata <- dbReadTable(con, "tbl_extradata_picturepile")
tbl_news <- dbReadTable(con, "tbl_news")
tbl_domisili <- dbReadTable(con, "tbl_domisili")
tbl_campaign_type <- dbReadTable(con, "tbl_campaign_type")
tbl_campaign <- dbReadTable(con, "tbl_campaign")
tbl_campaign_game <- dbReadTable(con, "tbl_campaign_game")
tbl_user_activity <- dbReadTable(con, "tbl_user_activity")
#tbl_institution <- dbRemoveTable(con, "tbl_institution") NoteAE: It gives error message all the time


setwd("D:/1_Restore+/crowdsource_post_process")
pile_ref <- tempfile(fileext = ".csv")
dl <- drive_download(
  as_id("1tMjwHJgSlHqkzSjAenY7bwbSF9rzrlbn"), path = pile_ref, overwrite = TRUE)
pile_ref <- read.table(pile_ref, header=TRUE, sep=",")
pile_ref <- subset(pile_ref, real_answer == "YES")
tbldf_extradata <- tbl_df(tbl_extradata)
tbldf_extradata <- merge(tbldf_extradata,pile_ref, by.x=c("latitude","longitude"), by.y=c("y","x"), all.x = TRUE, all.y = FALSE)
tbldf_extradata$count <- 1
tbldf_extradata_ref <- subset(tbldf_extradata, real_answer == "YES")

pilah_data0 <- tbldf_extradata %>% group_by (userUid) %>% summarize (Total=sum(count))
pilah_data1 <- tbldf_extradata_ref %>% group_by (userUid) %>% summarize (Total_ref=sum(count))
pilah_data2 <- tbldf_extradata_ref %>% filter(userAnswer=="Yes") %>% 
  filter(real_answer=="YES") %>% group_by(userUid) %>% summarise(Ref_true=sum(count))
pilah_data3 <- tbldf_extradata_ref %>% filter(userAnswer=="No") %>% 
  filter(real_answer=="YES") %>% group_by(userUid) %>% summarise(Ref_false=sum(count))
pilah_data <- merge (pilah_data0, pilah_data1, by="userUid", all=TRUE)
pilah_data <- merge (pilah_data, pilah_data2, by="userUid", all=TRUE)
pilah_data <- merge (pilah_data, pilah_data3, by="userUid", all=TRUE)
pilah_data[is.na(pilah_data)] <- 0
pilah_data$correct <- (pilah_data$Ref_true/pilah_data$Total_ref)
pilah_data$correct_norm <- ((pilah_data$Ref_true/pilah_data$Total_ref)*100)*(pilah_data$Total_ref/max(pilah_data$Total_ref))

campaign_sum <- tbldf_extradata %>% group_by (pileId) %>% summarize (Amount=sum(count))

#export data 
write.table(tbl_extradata, file = "D:/Project/Restore+/Crowdsource_campaign/3_Result/post_process/tbl_extradata_picturepile.csv", row.names = FALSE, col.names = TRUE, sep = ",")
write.table(tbl_news, file = "D:/Project/Restore+/Crowdsource_campaign/3_Result/post_process/tbl_news.csv", row.names = FALSE, col.names = TRUE, sep = ",")
write.table(tbl_domisili, file = "D:/Project/Restore+/Crowdsource_campaign/3_Result/post_process/tbl_domisili.csv", row.names = FALSE, col.names = TRUE, sep = ",")
write.table(tbl_campaign_type, file = "D:/Project/Restore+/Crowdsource_campaign/3_Result/post_process/tbl_campaign_type.csv", row.names = FALSE, col.names = TRUE, sep = ",")
write.table(tbl_campaign, file = "D:/Project/Restore+/Crowdsource_campaign/3_Result/post_process/tbl_campaign.csv", row.names = FALSE, col.names = TRUE, sep = ",")
write.table(tbl_campaign_game, file = "D:/Project/Restore+/Crowdsource_campaign/3_Result/post_process/tbl_campaign_game.csv", row.names = FALSE, col.names = TRUE, sep = ",")
write.table(tbl_user_activity, file = "D:/Project/Restore+/Crowdsource_campaign/3_Result/post_process/tbl_user_activity.csv", row.names = FALSE, col.names = TRUE, sep = ",")
write.table(tbl_institution, file = "D:/Project/Restore+/Crowdsource_campaign/3_Result/post_process/tbl_institution.csv", row.names = FALSE, col.names = TRUE, sep = ",")

#build tbl_extradata_extension
tbl_extradata_ext <- data.frame(extdata_id=tbl_extradata$data_id, data_id=tbl_extradata$data_id, userUid=tbl_extradata$userUid, imageId=tbl_extradata$imageId) #,imagetype=tbl_extradata_ext$imagetype)
tbl_extradata_ext$pileAnswer <-  

#build tbl_post_data


#build tbl_user_summary


#build visualization