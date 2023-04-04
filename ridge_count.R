
#The input of the function is a black and white skeletonized 
#image (using Zhang Suen method of skeletonization).
horizontal_ridge_count<-function(pictures){
  
  #Image is opened as a function "im_orig" and stored as raw data as "image_data".
  graphics.off()
  im_orig<-load.image(as.character(pictures))
  image_data<-as.data.frame(im_orig)
  
  #Graphical interface is opened where the picture is plotted
  x11()
  plot(im_orig)
  
  #Two points are chosen which determines the limits of the horizontal line where ridge
  #intersection will be counted. The first point chosen shall be the core. 
  s<-locator(n=2,type="l")
  y<-s$y
  x<-s$x
  points(round(s$x),round(s$y),col="green")
  
  #A horizontal line is made from the chosen y-limits. Descending from the
  #the first points chosen from previous step. 
  line2<-data.frame(y=seq(round(min(s$y)),round(max(s$y))))
  line2$x<-rep(round(s$x[1]),length(line2$y))
  
  #Raw data frame is created for intersected points determined by the 
  #locations where the horizontal line has a black pixel value. 
  t<-0
  points_of_intersection<-data_frame(x=numeric(length=100),y=numeric(length=100))
  talning<-0
  line_length<-dim(line2)[1]
  for(i2 in seq(1,line_length)){
    if(image_data$value[image_data$x==line2$x[i2]&image_data$y==line2$y[i2]]==0){
      talning<-talning+1
      
      points_of_intersection$x[talning]<-line2$x[i2]
      points_of_intersection$y[talning]<-line2$y[i2] 
    }
    
    
    
    
    
  }
  
  #Points in "points_of_intersection" that are within 2 pixel radius
  #of another another point in "points_of_intersection" are filtered out to 
  #prevent double counting. 
  points_of_intersection<-filter(points_of_intersection,x>0)
  points_of_intersection<-points_of_intersection[order(y)]
  for(j in seq(1,(dim(points_of_intersection)[1]-1))){
    for(k in seq(j+1,(dim(points_of_intersection)[1]))){
      
      if(abs(points_of_intersection$y[k]-points_of_intersection$y[j])<2.1){
        
        points_of_intersection$x[j]<-NA 
        points_of_intersection$y[j]<-NA
        break
      }
    }
  }
  points_of_intersection<-na.omit(points_of_intersection)
  
  #Intersected points are plotted for visual verifcation and the intersected
  #points are counted.
  points(points_of_intersection$x,points_of_intersection$y)
  lines_crossed<-dim(points_of_intersection)[1]
  return(dim(points_of_intersection)[1])
}











#The input of the function is a black and white skeletonized 
#image (using Zhang Suen method of skeletonization).
ridge_count<-function(image){
  
  #Image is opened as a function "im_orig" and stored as raw data as "image_data".
  graphics.off()
  im_orig<-load.image(as.character(pictures))
  image_data<-as.data.frame(im_orig)
  
  #Graphical interface is opened where the picture is plotted
  x11()
  plot(im_orig)
  
  #Two points are chosen which determines the limits of the horizontal line where ridge
  #intersection will be counted. The first point chosen shall be the core. 
  s<-locator(n=2,type="l")
  y<-s$y
  x<-s$x
  points(round(s$x),round(s$y),col="green")
  
  #Line between the two chosen points is stored as "line2" and plotted.  
  slope <- diff(y)/diff(x)
  intercept <- y[1]-slope*x[1]
  line<-data.frame(x=numeric(length = 400),y=numeric(length=400))
  line$x<-1:400
  line$y<-1*slope*line$x+intercept
  line2<-line[(line$x>min(s$x) & line$x<max(s$x))&
                (line$y>min(s$y) & line$y<max(s$y)),]
  lines(line2$x,line2$y)
  
  #Empty space between data points of "line2" are filled in to create
  #ladder-like line between the two endpoints of the line. 
  t<-0
  line_length<-dim(line2)[1]-1
  for(i2 in seq(1,line_length)){
    space_between_line_points<-abs(floor(line2$y[i2+1])-floor(line2$y[i2]))
    if(space_between_line_points>1){
      d<-data.frame()
      d<-data.frame(x=rep(line2$x[i2],space_between_line_points-1),y=(floor(line2$y[i2])+-1*seq(1,(space_between_line_points-1))))
      line2<-rbind(line2,d)
      
    }
    if(i2==line_length){
      space_between_line_points<-abs(floor(line2$y[i2])-floor(line2$y[i2-1]))
      if(space_between_line_points<1.1){
        next
      }
      r<-data.frame(x=rep(line2$x[i2],space_between_line_points-1),y=floor(line2$y[i2]+seq(1,space_between_line_points-1)))
      line2<-rbind(line2,r)
      t<-1
    }
  }
  
  
  #The location of line2 data points are checked for black pixel
  #on the fingerprint image which are added to intersection_points. 
  #Common y value between line2 and the fingerpint image is approximated with 
  #an error value of one pixel .
  intersection_points<-data_frame(x=numeric(length=100),y=numeric(length=100))
  talning<-0
  for(i in 1:dim(line2)[1]){
    vector<-image_data$x==line2[i,1]& abs(image_data$y-line2[i,2])<rep(1.3,dim(image_data)[1])
    if(sum(vector)==0){
      next
    }                                                                 
    if(0 %in% image_data$value[vector]){
      talning<-talning+1
      intersection_points$x[talning]<-line2[i,1]
      intersection_points$y[talning]<-line2[i,2]
      
    }
    
  }
  
  #It is required that the pixel distance between intersected_points 
  #has to be 15 or more on the x-axis and 3 or more on the y-axis. Other points
  #are excluded to prevent false ridge counting.
  intersection_points<-filter(intersection_points,x>0)
  intersection_points<-intersection_points[order(x)]
  for(j in seq(1,(dim(intersection_points)[1]-1))){
    for(k in seq(j+1,(dim(intersection_points)[1]))){
      
      if(abs(intersection_points$x[k]-intersection_points$x[j])<14.1 & abs(intersection_points$y[k]-intersection_points$y[j])<2.1){
        
        intersection_points$x[j]<-NA 
        intersection_points$y[j]<-NA
        break
      }
    }
  }
  
  #Intersected points are plotted for visual verifcation and the intersected
  #points are counted.
  intersection_points<-na.omit(intersection_points)
  points(intersection_points$x,intersection_points$y)
  lines_crossed<-dim(intersection_points)[1]
  return(dim(intersection_points)[1])
}





#Function density. The input is the location of an skeletonized fingerprint picture. 
density<-function(mynd){
  library(imager)
  
#Graphical workspace is cleared
  graphics.off()
  x11()
  im<-load.image(as.character(mynd))
  plot(im)
  #The line of the direction of the fingerprint is choosen
  s<-locator(n=2,type="l")
  y<-s$y
  x<-s$x
  core<-round(c(x[1], y[1]))
  normal_vector<-c(round(x[2]-x[1]),round(y[2]-y[1]))
  
  #Length of vectors is determined
  vector_length<-100
  
  
  #Vector is created with 100 pixel length and +45 degrees to the directional vector.
  spinning1<-c(cos(45)*normal_vector[1]-sin(45)*normal_vector[2], cos(45)*normal_vector[2]+sin(45)*normal_vector[1])
  spinning1<-spinning1*vector_length/(sqrt(sum(spinning1^2)))
  spinning1
  
  #Vector is created with 100 pixel length and -45 degrees to the directional vector.
  spinning2<-c(cos(-45)*normal_vector[1]-sin(-45)*normal_vector[2], cos(-45)*normal_vector[2]+sin(-45)*normal_vector[1])
  spinning2<-spinning2*vector_length/(sqrt(sum(spinning2^2)))
  

  #Core and the end points of the spinned vector when applied to the core are found.
  points<-data.frame(core=rep(NA,2))
  points$core<-core
  points$spinning1<-round(core+spinning1)
  points$spinning2<-round(core+spinning2)
  points(x=points[1,],y=points[2,],pch = 19,col="red")
  
  #End points of two lines with 45 degree angle to the direction vector are found. Start at fingerprint core. 
  x<-rbind(points$core[1],points$spinning1[1])
  y<-rbind(points$core[2],points$spinning1[2])
  points(round(s$x),round(s$y),col="green")
  
  #The lines from the points above are stored as data points.
  slope <- (points$core[2]-points$spinning1[2])/(points$core[1]-points$spinning1[1])
  intercept <- points$core[2]-slope*points$core[1]
  points_line<-data.frame(x=numeric(length = 400),y=numeric(length=400))
  points_line$x<-1:400
  points_line$y<-1*slope*points_line$x+intercept
  points_line2<-points_line[(points_line$x>min(x) & points_line$x<max(x)) & (points_line$y>min(y) & points_line$y<max(y)),]
  lines(points_line2$x,points_line2$y)
  points_line2$y<-round(points_line2$y)
  t<-0
  lengd<-dim(points_line2)[1]-1
  
  #The lines are made to be thicker than one pixel wide
  #Performed to hinder horizontal and vertical gap in the line caused by the line slope
  line_addition<-data.frame(x=numeric(),y=numeric())
  for(i2 in seq(1,lengd)){
    interval<-abs(floor(points_line2$y[i2+1])-floor(points_line2$y[i2]))
    if(interval>1){
      d<-data.frame()
      d<-data.frame(x=rep(points_line2$x[i2],interval-1),y=(floor(points_line2$y[i2])+-1*seq(1,(interval-1))))
      points_line2<-rbind(points_line2,d)
      
    }
    if(interval==1){
      d<-data.frame(x=points_line2$x[i2],y=points_line2$y[i2+1])
      
      line_addition<-rbind(line_addition,d)
    }
    if(i2==lengd){
      interval<-abs(floor(points_line2$y[i2])-floor(points_line2$y[i2-1]))
      if(interval<1.1){
        next
      }
      r<-data.frame(x=rep(points_line2$x[i2],interval-1),y=floor(points_line2$y[i2]+seq(1,interval-1)))
      points_line2<-rbind(points_line2,r)
      t<-1
    }
  }
  points_line2<-rbind(points_line2,line_addition)
  
  
  #Intersected points of one of the tow lines are found.Location of them is stored
  image_data<-as.data.frame(im)
  intersection_points<-data.frame(x=numeric(length=100),y=numeric(length=100))
  counting<-0
  for(i in 1:dim(points_line2)[1]){
    vektor<-image_data$x==points_line2[i,1]& abs(image_data$y-points_line2[i,2])<rep(1.3,dim(image_data)[1])
    if(sum(vektor)==0){
      next
    }                                                                 
    if(0 %in% image_data$value[vektor]){
      counting<-counting+1
      intersection_points$x[counting]<-points_line2[i,1]
      intersection_points$y[counting]<-points_line2[i,2]
      
    }
    
  }
  intersection_points<-intersection_points[intersection_points$x>0,]
  intersection_points<-intersection_points[order(x)]
  
  #Adjent intersected points are removed.
  #Points that lie within 2 pixels from each other are removed. 
  for(j in seq(1,(dim(intersection_points)[1]-1))){
    for(k in seq(j+1,(dim(intersection_points)[1]))){
      
      if(abs(intersection_points$x[k]-intersection_points$x[j])<2.1 & abs(intersection_points$y[k]-intersection_points$y[j])<2.1){
        
        intersection_points$x[j]<-NA 
        intersection_points$y[j]<-NA
        break
      }
    }
  }
  intersection_points<-na.omit(intersection_points)
  points(intersection_points$x,intersection_points$y)
  #The number of intersected points is stored as a variable
  lines_crossed1<-dim(intersection_points)[1]
  
  
#Identical code as above for the other line. 
  x<-rbind(points$core[1],points$spinning2[1])
  y<-rbind(points$core[2],points$spinning2[2])
  
  points(round(s$x),round(s$y),col="green")
  
  slope <- (points$core[2]-points$spinning2[2])/(points$core[1]-points$spinning2[1])
  
  intercept <- points$core[2]-slope*points$core[1]
  points_line<-data.frame(x=numeric(length = 400),y=numeric(length=400))
  points_line$x<-1:400
  points_line$y<-1*slope*points_line$x+intercept
  
  points_line2<-points_line[(points_line$x>min(x) & points_line$x<max(x)) & (points_line$y>min(y) & points_line$y<max(y)),]
  lines(points_line2$x,points_line2$y)
  
  points_line2$y<-round(points_line2$y)
  t<-0
  lengd<-dim(points_line2)[1]-1
  
  line_addition<-data.frame(x=numeric(),y=numeric())
  for(i2 in seq(1,lengd)){
    interval<-abs(floor(points_line2$y[i2+1])-floor(points_line2$y[i2]))
    if(interval>1){
      d<-data.frame()
      d<-data.frame(x=rep(points_line2$x[i2],interval-1),y=(floor(points_line2$y[i2])+-1*seq(1,(interval-1))))
      points_line2<-rbind(points_line2,d)
      
    }
    if(interval==1){
      d<-data.frame(x=points_line2$x[i2],y=points_line2$y[i2+1])
      
      line_addition<-rbind(line_addition,d)
    }
    if(i2==lengd){
      interval<-abs(floor(points_line2$y[i2])-floor(points_line2$y[i2-1]))
      if(interval<1.1){
        next
      }
      r<-data.frame(x=rep(points_line2$x[i2],interval-1),y=floor(points_line2$y[i2]+seq(1,interval-1)))
      points_line2<-rbind(points_line2,r)
      t<-1
    }
  }
  
  points_line2<-rbind(points_line2,line_addition)
  image_data<-as.data.frame(im)
  intersection_points<-data.frame(x=numeric(length=100),y=numeric(length=100))
  counting<-0
  for(i in 1:dim(points_line2)[1]){
    vektor<-image_data$x==points_line2[i,1]& abs(image_data$y-points_line2[i,2])<rep(1.3,dim(image_data)[1])
    if(sum(vektor)==0){
      next
    }                                                                 
    if(0 %in% image_data$value[vektor]){
      counting<-counting+1
      intersection_points$x[counting]<-points_line2[i,1]
      intersection_points$y[counting]<-points_line2[i,2]
      
    }
    
  }
  intersection_points<-intersection_points[intersection_points$x>0,]
  intersection_points<-intersection_points[order(x)]
  for(j in seq(1,(dim(intersection_points)[1]-1))){
    for(k in seq(j+1,(dim(intersection_points)[1]))){
      
      if(abs(intersection_points$x[k]-intersection_points$x[j])<2.1 & abs(intersection_points$y[k]-intersection_points$y[j])<2.1){
        
        intersection_points$x[j]<-NA 
        intersection_points$y[j]<-NA
        break
      }
    }
  }
  intersection_points<-na.omit(intersection_points)
  points(intersection_points$x,intersection_points$y)
  lines_crossed2<-dim(intersection_points)[1]
  
  #The number of the intersection of the two lines to the fingerprint ridges 
  #are stored as the code output.
  summa<-lines_crossed1+lines_crossed2
  return(summa)
  
}



