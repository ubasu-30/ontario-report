#Click Run or Command+Return to run codes

#install and run tidyverse
install.packages("tidyverse")
library(tidyverse)

#assign values to objects
name <- "agar" #string value
name

year<-1881 #numeric value
year
# You can over-write variables

#Bad names for objects
#1. Do not start variable names with numbers (e.g., 1number <- 3)
number1 <- 3
number1
#2. Variables are case-sensitive

# STARTING DATA ANALYSIS
#import file
sample_data <- read_csv("sample_data.csv")

#NOTE: could use <- or =
#NOTE: We can also use read.csv but in this workshop we will use read_csv (for tidyverse)

read_csv(file = 'sample_data.csv')
sample_data

#some handy codes
Sys.Date() #outputs current date
getwd() # current working directory
sum(5,6) # adds numbers
read_csv(file="sample_data.csv") #reads in csv file

#CREATING PLOTS

ggplot(data = sample_data) #gives an empty gray plot

#specifying aes(x=,y=) and labeling axes and adding title name (labs(x=,y=,title=)) 
ggplot(data = sample_data) + 
  aes(x=temperature,y=cells_per_ml) + 
  labs(x="Temperature (in C)",y="Cells per mL",
       title = "Does temperature affect microbial abundance?")

#adding the data points (geom_point()) 
ggplot(data = sample_data) + 
  aes(x=temperature,y=cells_per_ml) + 
  labs(x="Temperature (in C)",y="Cells per mL",
       title = "Does temperature affect microbial abundance?") +
  geom_point()


#assign different colors to different groups aes(color=)
ggplot(data = sample_data) + 
  aes(x=temperature,y=cells_per_ml, color = env_group) + 
  labs(x="Temperature (in C)",y="Cells per mL",
       title = "Does temperature affect microbial abundance?") +
  geom_point()

#vary size using chlorophyll quantity aes(size=) and add labels for
# Size and Color
ggplot(data = sample_data) + 
  aes(x=temperature,y=cells_per_ml, color = env_group, size = chlorophyll) + 
  labs(x="Temperature (in C)",y="Cells per mL",
       title = "Does temperature affect microbial abundance?", 
       size = "Chlorophyll (in ug/mL",
       color = "Enviromental group") +
  geom_point()

#To express cells in millions per mL 
ggplot(data = sample_data) + 
  aes(x=temperature,y=cells_per_ml/1000000, color = env_group, size = chlorophyll) + 
  labs(x="Temperature (in C)",y="Cells (in millions/mL)",
       title = "Does temperature affect microbial abundance?", 
       size = "Chlorophyll (in ug/mL",
       color = "Enviromental group") +
  geom_point()


#change shaples
ggplot(data = sample_data) + 
  aes(x=temperature,
      y=cells_per_ml/1000000, 
      color = env_group, 
      size = chlorophyll,
      shape = env_group) +
  
  geom_point() +
  
  labs(x = "Temperature (in C)",
       y = "Cells (in millions/mL)",
       title = "Does temperature affect microbial abundance?", 
       size = "Chlorophyll (in ug/mL)",
       color = "Enviromental Group",
       shape = "Enviromental Group")
#Post coffee break
#importing datasets  
buoy_data <- read_csv("buoy_data.csv")

#prints some of the dataset
buoy_data  

# stats of dataset
dim(buoy_data)

# beginning or end of dataset
head(buoy_data)
tail(buoy_data)

#plot
ggplot(data = buoy_data) +
  aes( x= day_of_year,
       y = temperature,
       color = depth) +
  geom_point()

#structure of data object
str(buoy_data)

#geom_line
ggplot(data = buoy_data) +
  aes( x= day_of_year,
       y = temperature,
       color = depth) +
  geom_line()

#group by sensor aes(group =)  
ggplot(data = buoy_data) +
  aes( x= day_of_year,
       y = temperature,
       group = sensor,
       color = depth) +
  geom_line()

# split the graph by buoys. Use facet_wrap(~variable)
ggplot(data = buoy_data) +
  aes( x= day_of_year,
       y = temperature,
       group = sensor,
       color = depth) +
  geom_line() + 
  facet_wrap(~buoy)

# make y-axis of all consistent
ggplot(data = buoy_data) +
  aes( x= day_of_year,
       y = temperature,
       group = sensor,
       color = depth) +
  geom_line() + 
  facet_wrap(~buoy,
             scales = "free_y")

#facet grid (same X-axis) but splits graphs by buoys
ggplot(data = buoy_data) +
  aes( x= day_of_year,
       y = temperature,
       group = sensor,
       color = depth) +
  geom_line() + 
  facet_grid(rows = vars(buoy))

#FACET_WRAP Need to use tilda ~ to specify variable
#FACET_GRID Need to use vars(variable) to specify variable
ggplot(data = buoy_data) +
  aes( x= day_of_year,
       y = temperature,
       group = sensor,
       color = depth) +
  geom_line() + 
  facet_grid(vars(buoy))

#Doubt Why does it work when not using rows! ANSWER: Default is
#rows when not specified

#DISCRETE PLOTS
#Boxplot (geom_boxplot()) and add points usig geom_point()
ggplot(data = sample_data)+
  aes(x = env_group,
      y = cells_per_ml)+
  geom_boxplot(aes(fill = env_group)) +
  scale_fill_manual(values = c("pink","tomato","papayawhip"))
  geom_point()
  
  # NOTE: Order of plotting matters. Boxplot should be made
  # before adding the points

#geom_jitter()
ggplot(data = sample_data)+
  aes(x = env_group,
      y = cells_per_ml)+
  geom_boxplot()+
  geom_jitter()
  
#add aes for geom jitter
ggplot(data = sample_data)+
    aes(x = env_group,
        y = cells_per_ml)+
    geom_boxplot()+
    geom_jitter(aes(size = chlorophyll)) 

#COLORS
#all R colors
colors()
#choose 10 colors randomly
sample(colors(), size = 10)


# Adding color to box plot specifying colors manually
ggplot(data = sample_data)+
  aes(x = env_group,
      y = cells_per_ml)+
  geom_boxplot(aes(fill = env_group)) +
  scale_fill_manual(values = c("pink","tomato","papayawhip"))+
  geom_point()

#custom colors scale_fill_brewer by mentioning pre-defined
ggplot(data = sample_data)+
  aes(x = env_group,
      y = cells_per_ml)+
  geom_boxplot(aes(fill = env_group)) +
  scale_fill_brewer(palette = "Set1")+
  geom_point()

#INSTALLING PRE-MADE COLOR PALETTES 
#install.packages("wesanderson")
library(wesanderson)
names(wes_palettes)

ggplot(data = sample_data)+
  aes(x = env_group,
      y = cells_per_ml)+
  geom_boxplot(aes(fill = env_group)) +
  scale_fill_manual(values = wes_palette("Cavalcanti1"))+
  geom_point()

#ADD A NEW COLOR PALETTE
#Google for a palette of your choice 

#Install the color palette set package (e.g, national parks)
#install.packages("NatParksPalettes")
library(NatParksPalettes)

#view the list of color palettes available
names(NatParksPalettes)

#choose a palette
#use scale_fill_manual(values = natparks.pal("palettename"))
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(aes(fill = env_group)) +
  scale_fill_manual(values=natparks.pals("Olympic"))+
  geom_point()

#change transparency geom_boxplot(alpha = 0-1)
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(fill = "tomato", alpha = 0.5)

#remove outliers
ggplot(data = sample_data) +
  aes(x = env_group,
      y = cells_per_ml) +
  geom_boxplot(fill = "tomato", alpha = 0.5, outliers = FALSE)

#UNIVARIATE PLOTS
ggplot(sample_data) +
  aes(x=cells_per_ml)+
  geom_histogram()
#bins separted
ggplot(sample_data) +
  aes(x=cells_per_ml)+
  geom_histogram(bins = 50)
#geom_density
ggplot(sample_data) +
  aes(x=cells_per_ml)+
  geom_density(aes(fill = env_group), alpha = 0.5)

# remove gray BG
ggplot(sample_data) +
  aes(x=cells_per_ml)+
  geom_density(aes(fill = env_group), alpha = 0.5)+
  theme_bw()

#rotate X-axis labels
ggplot(data=sample_data)+
  
  aes(x=env_group,
      y=cells_per_ml)+
  
  geom_boxplot()+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

#SAVING PLOTS
ggsave("example_plot.jpg", width = 6, height = 4, dpi = 500)

#CHANGE THEME
box_plot <- ggplot(data=sample_data)+
  
  aes(x=env_group,
      y=cells_per_ml)+
  
  geom_boxplot()+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

box_plot <- box_plot + theme_bw()
ggsave("boxplot.jpg", plot = box_plot, width=6, height = 10, dpi= 500)


#change name of saved jpg file from terminal (Wohooo!!)
ggsave("YES.jpg", plot = box_plot, width=6, height = 10, dpi= 500) 
