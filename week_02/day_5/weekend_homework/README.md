# Stuart McColl - DE5
## Meteorite Homework, Week 2


### Section 1 - The .R file


#### First Steps
* Start a new project on RStudio
* Open a new R Script or '.R' file
* Load relevant libraries, such as Tidyverse and Janitor


#### __Question 1__ - Read the data into R

````
meteorite_landings <- read_csv("meteorite_landings.csv")

````

#### __Question 2__ - Change the names of the variables to follow our naming standards.

##### For this question, I used the __Janitor__ library and applied the  'clean names' function to the data set. This function converts the column titles to lower case.

````
meteorite_clean_names <- clean_names(meteorite_landings)
````

#### __Question 3__ - Split in column GeoLocation into latitude and longitude, the new latitude and longitude columns should be numeric.

##### For this question, I applied the following steps:
* Step 1 - I used the 'separate' function and applied it the 'geo_location' column.
* Step 2 - Within the 'separate' function, I then created two new columns.
* Step 3 - I asked R to separate the column by looking for the comma.
* Step 4 - I then tidied up the results by removing the parentheses using the 'mutate' function and applying a string removal.
* Step 4 - I then used 'mutate' to change the column class to numeric or 'double' in this instance.

````

`meteorite_lat_long <- meteorite_clean_names %>%
 separate(geo_location, c("latitude", "longitude"),
         sep = ",") %>%
  mutate(latitude = str_remove(
    latitude, pattern = "\\("
  )) %>%
  mutate(longitude = str_remove(
    longitude, pattern = "\\)"
  )) %>% 
  mutate(latitude = as.double(latitude)) %>%
  mutate(longitude = as.double(longitude))
  
````
  
#### __Question 4__ - Replace any missing values in latitude and longitude with zeros.

##### For this question, I used the 'mutate' and 'coalesce' function to apply a zero for any missing values within the latitude and longitude columns.

````

meteorite_missing_values <- meteorite_lat_long %>%
  mutate(latitude = coalesce(latitude, na.rm = 0)) %>%
  mutate(longitude = coalesce(longitude, na.rm = 0))
  
````
  
#### __Question 5__ - Remove meteorites less than 1000g in weight from the data.

##### For this question, I applied a filter to the 'mass_g' column that only showed the values within that column that we equal and greater than 1000g.

````

meteorite_more_than_1000g <- meteorite_missing_values %>%
  filter(mass_g >= 1000)
  
````
  
#### __Question 6__ - Order the data by the year of discovery.

##### For this question, I used the data from the previous question and arranged the results by year in ascending order.

````

meteorite_arranged_by_year <- meteorite_more_than_1000g %>%
  arrange(year)
  
````

  
 ----
 

### Section 2 - The .Rmd file

#### First Steps
* Continue working on the existing project on RStudio
* Open a new R Notebook or '.Rmd' file
* Load relevant libraries, such as Tidyverse and Janitor


#### __Question 1__ - Read the cleaned data into R.

##### For this question, I assigned the cleaned data from the previous section to a new object.

````{r}

meteorite_cleaned_data <- meteorite_arranged_by_year

head(meteorite_cleaned_data)

````

#### __Question 2__ - Find the names and years found for the 10 largest meteorites in the data.

##### For this question, I selected the columns 'year', 'name' and 'mass_g', respectively. I then arranged the column 'mass_g' by descending order and used the 'slice' function and requested the top ten results. Lastly, I creaated a new column using 'mutate' to show the mass of meteorites in tonnes.

```{r}

meteorite_10_largest <- meteorite_arranged_by_year %>%
  select(year, name, mass_g) %>%
  arrange(desc(mass_g)) %>%
  slice(1:10) %>%
  mutate(mass_tonne = (mass_g / 1000000))

meteorite_10_largest

```

#### __Question 3__ - Find the average mass of meteorites that were recorded falling, vs. those which were just found.

##### For this question I grouped the rows by the 'fall' column and used 'summarise' to create a new column that displays the mean mass for each respective group, in this case - 'fell' or 'found'. I then created a new column using 'mutate' that displays the mass in kilograms.

```{r}

meteorite_avg_mass <- meteorite_cleaned_data %>%
  group_by(fall) %>%
  summarise(average_mass_g = mean(mass_g)) %>%
  mutate(average_mass_kg = (average_mass_g / 1000))
  
```

#### __Question 4__ - Find the number of meteorites in each year, for every year since 2000.

##### For this question I followed the following steps:

* Step 1 - I used the 'filter' function on the 'year' column and specified years equal and over 2000.
* Step 2 - I then grouped the 'year' column by its respective year.
* Step 3 - I used the 'summarise' function to create a new column that adds up the sum of the respective year values and then divides it by the year to get a total number of entries for that year.
* Step 4 - Finally, I used the 'distinct' function to show distinct, individual years alongside the number of meteorites discovered that year. 

```{r}

meteorite_since_2000 <- meteorite_cleaned_data %>%
  filter(year >= 2000) %>%
  group_by(year) %>%
  summarise(number_of_meteorites = sum(year)/year) %>%
  distinct(year, number_of_meteorites)
  
```

----

### Extension

##### For the extension work I would like to find out the following:

* Top sites for meteorites discoveries
* The sum of how many meteorites fell compared to how many were found
* Top ten years for meteorite discoveries

#### __Top Meteorite Sites__

##### For this, the first thing I did was to remove any numbers after the location name as I wanted to count how many instances each name comes up. Using the 'mutate' and 'string removal' functions, I specified the pattern I wanted to remove from the column, which was numbers in this case. I then used the 'count' function on the name column to count each name, followed by the sort argument to arrange them in descending order and then I gave the new column a name. Finally, I used 'slice' and within the parentheses I used '1:10', to show 10 results only.

```{r}

meteorite_top_sites <- meteorite_cleaned_data %>%
  mutate(name = str_remove(
    name, pattern = "[0-9]+")) %>%
  count(name, sort = TRUE, name = "number_of_discoveries") %>%
  slice(1:10)


```

#### __Fell vs Found__

##### For this, I grouped the 'fall' column and used the 'count' function to count the individual cases for 'fell' and 'found' respectively.


```{r}

meteorite_fell_and_found <- meteorite_cleaned_data %>%
  group_by(fall) %>%
  count(fall, sort = TRUE, name = "number_of_discoveries") 
  

```

#### __Top Ten Years for Discovering Meteorites__

##### For this, I counted the year column, sorted it by descending order and gave the new column a name. I then used 'slice' to view the top ten results.


```{r}

meteorite_top_10_years <- meteorite_cleaned_data %>%
  count(year, sort = TRUE, name = "number_of_discoveries") %>%
  slice(1:10)

```

----


  

  
  
  






