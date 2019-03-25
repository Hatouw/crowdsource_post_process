#Library activation
library(OpenImageR)
library(devtools)
source_gist("https://gist.github.com/mrdwab/6424112")

#readtable
selectedImage_table <- read.csv("E:/R+/Crowdsourcing/crop_image/selected_images.csv", header = TRUE, sep =",")
selectedImage_table$pilename <- "ordinarypile"
random <- stratified(selectedImage_table,"pilename",0.2)
random$pilename <- "expertpile"
random_subset <- subset(random, select=c(id_new, imageid, pilename))
selectedImage_table1 <- merge(selectedImage_table,random_subset,by = c("id_new", "imageid"), all=TRUE)
selectedImage_table1 <- within(selectedImage_table1, { pilename.y<-ifelse(is.na(pilename.y), "ordinarypile", pilename.y) })
write.table(selectedImage_table1, file = "E:/R+/Crowdsourcing/crop_image/selected_images.csv", row.names = FALSE, col.names = TRUE, sep = ",")

#create folder (Batch)
dir.create("E:/R+/Crowdsourcing/crop_image/expertpile", mode = '0777')
dir.create("E:/R+/Crowdsourcing/crop_image/ordinarypile", mode = '0777')

for (n in 1:length(unique(selectedImage_table1$lc2017_lev2id))){
  filtertable1 <- subset(selectedImage_table,selectedImage_table$lc2017_lev2id == n)
  dir.create(paste0("E:/R+/Crowdsourcing/crop_image/expertpile/",unique(filtertable1$lc2017_lev2_class)))
}

for (n in 1:length(unique(selectedImage_table$lc2017_lev2id))){
  filtertable1 <- subset(selectedImage_table,selectedImage_table$lc2017_lev2id == n)
  dir.create(paste0("E:/R+/Crowdsourcing/crop_image/ordinarypile/",unique(filtertable1$lc2017_lev2_class)))
}

for (n in 1:length(unique(selectedImage_table1$LC_Lev2_id))){
  filtertable1 <- subset(selectedImage_table,selectedImage_table$LC_Lev2_id == n)
  dir.create(paste0("E:/R+/Crowdsourcing/crop_image/gpspile/",unique(filtertable1$LC_Lev2)))
}

#Crop image 512x512 pixel (Batch)
for (i in 1:nrow(matched_selected_image1)){
  filtertable2 <- subset(matched_selected_image1,matched_selected_image1$id_new == i)
  image_name <- paste0("E:/R+/Crowdsourcing/crop_image/", filtertable2$filename)
  if(file.exists(image_name)){
    image <- readImage(image_name)
    crop1 <- cropImage(image, new_width = 512, new_height = 512, type = 'equal_spaced')
    export <- writeImage(crop1, paste0("E:/R+/Crowdsourcing/crop_image/", unique(filtertable2$pilename), "/", unique(filtertable2$lc2017_lev2_class),"/cropped_",filtertable2$filename))
  }
}

#image <- readImage("E:/R+/Crowdsourcing/crop_image/ff728ffb-f62c-f568-83d8-5ad74fa6a583_110_0_20180601_034337.jpg")
#crop1 <- cropImage(image, new_width = 600, new_height = 600, type = 'equal_spaced')
#export <- writeImage(crop1, "E:/R+/Crowdsourcing/tes4_600x600.jpg")

