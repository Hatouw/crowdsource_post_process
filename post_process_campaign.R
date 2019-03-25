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
tbl_institution <- dbRemoveTable(con, "tbl_institution")

#export data from postgresql
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