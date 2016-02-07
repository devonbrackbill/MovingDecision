# MOVING DECISION FIGURES
# AUTHOR: Devon Brackbill
# 2015.12.27

####################################################
library(ggplot2)
library(reshape2)
library(readxl)
print(getwd())

files = list.files('data')[grep('csv',list.files('data'))]
print(files)

read.this.csv = function(x){
  x = read.csv(paste0('data/',x))
  names(x)[1] = 'col'
  n = as.character(x$col)
  x <- as.data.frame(t(x[,-1]))
  colnames(x) <- n
  colnames(x)[1] = 'Location'
  return(x)
}

all.data = lapply(files,read.this.csv)
ds = do.call('cbind',c(all.data, deparse.level = 0))
head(ds)

# remove duplicate column names
cols = which(names(ds) == 'Location')[-1]
ds = ds[,-cols]

#covert '%' and '$' and ',' to numeric
Location = ds$Location
ds = ds[,-1]
cleaner = function(x){
  x = as.character(x)
  x = gsub(',', '', x)
  x = gsub('[$]', '', x)
  x = gsub('[%]', '', x)
  x = as.numeric(x)
}
ds2 = data.frame(sapply(ds, cleaner))
ds2$Location = Location

##################################################################
# PLOTTING
##################################################################

for (column in names(ds2)){
  if (class(ds2[,column]) == 'numeric' &
        all(is.na(ds2[,column]) == F)){
    ds2 = ds2[order(ds2[,column]),]
    ds2$Location = factor(ds2$Location, 
                          levels = as.character(ds2$Location))
    ds2$color = 'black'
    ds2$color[ds2$Location == 'Philadelphia, Pennsylvania'] = 'red'
    #png('figs/')
    ggplot(ds2,aes_string(x='Location', y=column))+
      geom_point(stat='identity', aes(color=color, size = 1))+
      theme(axis.text.x = element_text(angle=0),
            legend.position = "none")+
      coord_flip()+
      ggtitle(column)+
      scale_color_manual(values=c("black", "red"))+
      ggsave(paste0('figures/',column, '.png'), width = 6, height = 3, units = 'in',
             dpi = 100)
  }
}

#####################
# TEMPERATURE RANGE
#####################

ds3 = ds2[order(ds2[,'Avg..Jan..Low']),]
ds3$Location = factor(ds3$Location, 
                      levels = as.character(ds3$Location))
#ggplot(melt(ds3, id.vars = "Cat"), aes(value, variable, colour = Cat)) + 
ds3 = melt(ds3[,c('Location', 'Avg..Jan..Low', 'Avg..July.High')],
           id.vars = 'Location')  
ds3$color = 'black'
ds3$color[ds3$Location == 'Philadelphia, Pennsylvania'] = 'red'

ggplot(ds3, aes(x=Location,y=value))+
  geom_point(stat = 'identity', aes(color=color, size = 1))+
  theme(axis.text.x = element_text(angle=0))+
  ggtitle('Range of Avg Jan - July Temps')+
  geom_hline(aes(yintercept = 32), col = 'blue')+
  scale_color_manual(values=c("black", "red"))+
  ylab('Degrees F')+
  coord_flip()+
  theme(legend.position="none")+
  ggsave('figures/TempRange.png', width = 6, height = 3, units = 'in',
         dpi = 100)
