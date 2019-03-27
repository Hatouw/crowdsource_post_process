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



#Testing
#image1 <- image_read("E:/R+/Crowdsourcing/crop_image/_526_0_20170711_033017_10044325.jpg")
#crop1 <- image_crop(image1, geometry_area(width = 400, height = 400, x_off = 824, y_off = 824))
#locimg <- paste0(" Lokasi: KEC WARKUKRANAU SELATAN, 
# KAB. OGANKOMERINGULU SELATAN ")
#imgtext <- image_annotate(crop1, locimg, gravity = "South", size = 16, font = "Arial", color = "black", boxcolor = "white")
#export <- image_write(imgtext, "E:/R+/Crowdsourcing/test_magick/testext12_400x400.jpg")

