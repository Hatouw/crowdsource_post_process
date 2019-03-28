#Library activation
library(magick)
library(devtools)
source_gist("https://gist.github.com/mrdwab/6424112")

#readtable
allimages_table <- read.csv("E:/R+/Crowdsourcing/crop_image/list_all_images_location_updated_27032019.csv", header = TRUE, sep =",")
selectedImage_table$pilename <- "ordinarypile"

#create stratified random
random <- stratified(selectedImage_table,"pilename",0.2)
random$pilename <- "expertpile"
random_subset <- subset(random, select=c(id_new, imageid, pilename))
selectedImage_table1 <- merge(selectedImage_table,random_subset,by = c("id_new", "imageid"), all=TRUE)
selectedImage_table1 <- within(selectedImage_table1, { pilename.y<-ifelse(is.na(pilename.y), "ordinarypile", pilename.y) })
write.table(selectedImage_table1, file = "E:/R+/Crowdsourcing/crop_image/selected_images.csv", row.names = FALSE, col.names = TRUE, sep = ",")

#create folder (Batch)
dir.create("E:/R+/Crowdsourcing/crop_image/expertpile", mode = '0777')
dir.create("E:/R+/Crowdsourcing/crop_image/ordinarypile", mode = '0777')

for (n in 1:length(unique(allimages_table$lc17id))){
  filtertable1 <- subset(allimages_table,allimages_table$lc17id == n)
  dir.create(paste0("E:/R+/Crowdsourcing/crop_image/expertpile/",unique(filtertable1$lc17class)))
}

for (n in 1:length(unique(allimages_table$lc17id))){
  filtertable1 <- subset(allimages_table,allimages_table$lc17id == n)
  dir.create(paste0("E:/R+/Crowdsourcing/crop_image/ordinarypile/",unique(filtertable1$lc17class)))
}

for (n in 1:length(unique(allimages_table$lc17id))){
  filtertable1 <- subset(allimages_table,allimages_table$lc17id == n)
  dir.create(paste0("E:/R+/Crowdsourcing/crop_image/gpspile/",unique(filtertable1$lc17class)))
}

#Crop image 400x400 pixel (Batch)
for (i in 1:nrow(allimages_table)){
  filtertable3 <- subset(allimages_table,allimages_table$id_new == i)
  image_name <- paste0("E:/R+/Crowdsourcing/crop_image/", filtertable3$filename)
  if(file.exists(image_name)){
    image1 <- image_read(image_name)
    crop1 <- image_crop(image1, geometry_area(width = 400, height = 400, x_off = 824, y_off = 824))
    locimg <- paste(" Lokasi: KEC. ", filtertable3$kecamatan, ", 
 KAB. ", filtertable3$kabupaten, " ")
    imgtext1 <- image_annotate(crop1, locimg, gravity = "South", size = 16, font = "Arial", color = "black", boxcolor = "white")
    export <- image_write(imgtext1, paste0("E:/R+/Crowdsourcing/crop_image/", unique(filtertable3$pilename), "/", unique(filtertable3$lc17class),"/cropped_",filtertable3$filename))
  }
}

#checking the match between the table and list of files
  ##checking the match between table and raw images
listimg <- list.files("E:/R+/Crowdsourcing/crop_image/")
tbl_listimg <- data.frame(filename = listimg)
allimages_table$match <- ifelse(is.na(match(allimages_table$filename, tbl_listimg$filename)), yes = "unmatched", no = "matched")
write.table(allimages_table, file = "E:/R+/Crowdsourcing/crop_image/tbl_allimage.csv", row.names = FALSE, col.names = TRUE, sep = ",")

  ##checking the match between table and cropped image
listimg_exnf <- list.files("E:/R+/Crowdsourcing/crop_image/expertpile/Natural forest")
tbl_listimg_exnf <- data.frame(filename = listimg_exnf, lclev2 = "Natural forest")
listimg_exmtc <- list.files("E:/R+/Crowdsourcing/crop_image/expertpile/Managed tree crop")
tbl_listimg_exmtc <- data.frame(filename = listimg_exmtc, lclev2 = "Managed tree crop")
listimg_exntbs <- list.files("E:/R+/Crowdsourcing/crop_image/expertpile/Non tree based system")
tbl_listimg_exntbs <- data.frame(filename = listimg_exntbs, lclev2 = "Non tree based system")
listimg_exnv <- list.files("E:/R+/Crowdsourcing/crop_image/expertpile/Non vegetation")
tbl_listimg_exnv <- data.frame(filename = listimg_exnv, lclev2 = "Non vegetation")

listimg_ornf <- list.files("E:/R+/Crowdsourcing/crop_image/ordinarypile/Natural forest")
tbl_listimg_ornf <- data.frame(filename = listimg_ornf, lclev2 = "Natural forest")
listimg_ormtc <- list.files("E:/R+/Crowdsourcing/crop_image/ordinarypile/Managed tree crop")
tbl_listimg_ormtc <- data.frame(filename = listimg_ormtc, lclev2 = "Managed tree crop")
listimg_orntbs <- list.files("E:/R+/Crowdsourcing/crop_image/ordinarypile/Non tree based system")
tbl_listimg_orntbs <- data.frame(filename = listimg_orntbs, lclev2 = "Non tree based system")
listimg_ornv <- list.files("E:/R+/Crowdsourcing/crop_image/ordinarypile/Non vegetation")
tbl_listimg_ornv <- data.frame(filename = listimg_ornv, lclev2 = "Non vegetation")

tbl_cropimage <- rbind(tbl_listimg_exnf, tbl_listimg_exmtc,tbl_listimg_exntbs, tbl_listimg_exnv, tbl_listimg_ornf, tbl_listimg_ormtc, tbl_listimg_orntbs, tbl_listimg_ornv)
tbl_cropimage$filename2 <- sub("cropped_", "", tbl_cropimage$filename)

allimages_table$match <- ifelse(is.na(match(allimages_table$filename, tbl_cropimage$filename2)), yes = "unmatched", no = "matched")
allimages_table$cropmatch <- NULL
allimages_table$cropped_filename <- paste0("cropped_",allimages_table$filename)
write.table(allimages_table, file = "E:/R+/Crowdsourcing/crop_image/tbl_allimage.csv", row.names = FALSE, col.names = TRUE, sep = ",")


#Testing
#image1 <- image_read("E:/R+/Crowdsourcing/crop_image/_526_0_20170711_033017_10044325.jpg")
#crop1 <- image_crop(image1, geometry_area(width = 400, height = 400, x_off = 824, y_off = 824))
#locimg <- paste0(" Lokasi: KEC WARKUKRANAU SELATAN, 
# KAB. OGANKOMERINGULU SELATAN ")
#imgtext <- image_annotate(crop1, locimg, gravity = "South", size = 16, font = "Arial", color = "black", boxcolor = "white")
#export <- image_write(imgtext, "E:/R+/Crowdsourcing/test_magick/testext12_400x400.jpg")

