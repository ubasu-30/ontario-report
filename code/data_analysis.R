
#Loading packages
library(tidyverse)

#Reading in data
sample_data <- read_csv("data/sample_data.csv")

summarize(sample_data, average_cells = mean(cells_per_ml))

#pipe function #question: why did average_cells not come up as a value?
sample_data %>% 
  summarize(average_cells = mean(cells_per_ml))

# filtering rows
sample_data %>% 
  filter(env_group == "Deep") %>% 
  summarise(average_cells = mean(cells_per_ml))

# Calculate the average chlorophyll in entire dataset
# Calculate the average chlorophyll in Shallow September

sample_data %>% 
  summarise(average_chlo = mean(chlorophyll))

sample_data %>% 
  filter(env_group == "Shallow_September") %>% 
  summarise(average_chlo_Sep = mean(chlorophyll))

# Calculate the average chlorophyll in all kind of September
#uses wildcard (*) on both sides of 'September'
sample_data %>% 
  filter(str_detect(env_group, "September")) %>% 
  summarise(average_chlo_Sep = mean(chlorophyll))

# group_by
sample_data %>% 
  group_by(env_group) %>% 
  summarize(average_cells = mean(cells_per_ml),
            min_cells = min(cells_per_ml))

# Calculate avg temp per env_group
sample_data %>% 
  group_by(env_group) %>% 
  summarize(avg_temp = mean(temperature))

# Mutate : makes a create, modify, delete columns
sample_data %>% 
  mutate(tn_tp_ration = total_nitrogen / total_phosphorus)

# use %>% view in the end to see the change
sample_data %>% 
  mutate(tn_tp_ration = total_nitrogen / total_phosphorus) %>% 
  view

#NOTE Do not use spaces in column names! Need to rename column names

# Group by multiple columns
sample_data %>% 
  mutate(temp_is_hot = temperature > 8) %>% 
  group_by(env_group, temp_is_hot) %>% 
  summarise(avg_temp = mean(temperature),
            avg_cells = mean(cells_per_ml))

# select function: manipulate columns

# choose selected columns
sample_data %>% 
  select(sample_id, depth)

# get rid of some columns 
sample_data %>% 
  select(-env_group)

# : selects from one column to another
sample_data %>% 
  select(sample_id : temperature)

# starts with, ends with 
sample_data %>% 
  select(starts_with("total"))

# create  a dataframe with only sample_id, env_group,depth
# temperature and cells_per_ml
sample_data %>% 
  select(sample_id : temperature)

sample_data %>% 
  select(-starts_with("total"), -chlorophyll, -diss_org_carbon)

sample_data %>% 
  select(-( total_nitrogen : chlorophyll ))

# CLEANING DATA
# skip as an argument of read_csv skips top 2 columns

# removes top row, remove a column, rename one column
read_csv("data/taxon_abundance.csv" , skip = 2) %>% 
  select(-...10) %>% 
  rename(sequencer = ...9)

# Also remove lot number and sequencer columns and assign this to an object called
# "taxon_clean"

taxon_clean <- read_csv("data/taxon_abundance.csv", skip = 2) %>% 
  select(-...10) %>% 
  rename(sequencer = ...9) %>% 
  select(-Lot_Number, - sequencer) %>%view

# SELECT, RENAME, FILTER , SKIP, REMOVE : to clean data

# change to Long data format: pivot_longer

taxon_long <- taxon_clean %>% 
  pivot_longer(cols = Proteobacteria : Cyanobacteria, 
               names_to = "Phyllum",
               values_to = "Abundance")

# group by Phyllum and find avg_abund
taxon_long %>% 
  group_by(Phyllum) %>% 
  summarise(avg_abund = mean(Abundance))

# make a stacked bar plot

taxon_long %>% 
  ggplot() +
  aes(x = sample_id,
      y = Abundance,
      fill = Phyllum) +
  geom_col()+
  theme(axis.text.x = element_text(angle = 90))

# Making a wide data frame: pivot_wider
# wide data format : ususally all the values have similar units

taxon_wide <- taxon_long %>% 
  pivot_wider(names_from = "Phyllum",
              values_from = "Abundance")

# JOINING DATA FRAMES
head(sample_data)
head(taxon_clean)

# inner_join : skips values for variables that 
# are missing in 1 or another

# full_join : joins all values. skips no data. 
# Will result in NA for missing data

# left_join: table 1, table 2: keep all from 1. skip T2 unique values
# anti_join: keeps keypairs that are unique

#Inner join

# keypairs that match
inner_join(sample_data, taxon_clean, by = "sample_id") %>%  view

# keypairs that did NOT match
anti_join(sample_data, taxon_clean, by = "sample_id") %>%  view

sample_data $ sample_id
taxon_clean $ sample_id
# shows that Sep and September named differently

# overwrite/rename rows
taxon_clean_goodSep <-
  taxon_clean %>% 
  mutate(sample_id = str_replace( sample_id , 
                                 pattern = "Sep",
                                 replacement = "September"))

# join again (will result in same number of rows)

sample_and_taxon <-
  inner_join(sample_data, taxon_clean_goodSep, by = "sample_id")

# write in an csv file
write_csv(sample_and_taxon, file = "data/sample_and_taxon.csv")

# Make a plot
# Ask where does Chloroflexi like to live?

sample_and_taxon %>% 
  ggplot() +
  aes(x = depth,
      y = Chloroflexi) +
  geom_point() +
  labs( x = "Depth (in m)",
        y = "Chloroflexi relative abundance")

#add regression line using linear regression model
sample_and_taxon %>% 
  ggplot() +
  aes(x = depth,
      y = Chloroflexi) +
  geom_point() +
  labs( x = "Depth (in m)",
        y = "Chloroflexi relative abundance")+
  geom_smooth(method = "lm")

# add the equation of the line of best fit
#install.packages("ggpubr")

library(ggpubr)

sample_and_taxon %>% 
  ggplot() +
  aes(x = depth,
      y = Chloroflexi) +
  geom_point() +
  labs( x = "Depth (in m)",
        y = "Chloroflexi relative abundance")+
  geom_smooth(method = "lm") +
  stat_regline_equation()

# correlation
sample_and_taxon %>% 
  ggplot() +
  aes(x = depth,
      y = Chloroflexi) +
  geom_point() +
  labs( x = "Depth (in m)",
        y = "Chloroflexi relative abundance")+
  geom_smooth(method = "lm") +
  stat_cor()
# annotate
sample_and_taxon %>% 
  ggplot() +
  aes(x = depth,
      y = Chloroflexi) +
  geom_point() +
  labs( x = "Depth (in m)",
        y = "Chloroflexi relative abundance")+
  geom_smooth(method = "lm") +
  stat_cor()+
  annotate( geom = "text",
            x = 100, y = 0.3,
            label = "EXAMPLE TEXT")



# what is avg abundance and standard deviation of chloroflexi 
# in 3 env_groups?

sample_and_taxon %>% 
  group_by(env_group) %>% 
  summarise(avg_abun_chlo = mean(Chloroflexi), 
            stan_dev_chlo = sd(Chloroflexi))













