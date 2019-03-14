# ---------------
# title: Data Preparation - make "shots-data.csv"
# description: Create a csv data file shots-data.csv that contains the required variables to be used in the visualization phase.
# inputs(s): andre-iguodala.csv; draymond-green.csv; kevin-durant.csv; klay-thompson.csv; stephen-curry.csv
# output(s): andre-iguodala-summary.txt; draymond-green-summary.txt; kevin-durant-summary.txt; klay-thompson-summary.txt; stephen-curry-summary.txt; shots-data.csv; shots-data-summary.txt
# ---------------


# import data
coltypes <- c("character", "character", "integer", "integer", "integer", "integer", "character", "character", "factor", "integer", "character", "integer", "integer")
iguodala <- read.csv("../data/andre-iguodala.csv", colClasses = coltypes, stringsAsFactors = FALSE)
green <- read.csv("../data/draymond-green.csv", colClasses = coltypes, stringsAsFactors = FALSE)
durant <- read.csv("../data/kevin-durant.csv", colClasses = coltypes, stringsAsFactors = FALSE)
thompson <- read.csv("../data/klay-thompson.csv", colClasses = coltypes, stringsAsFactors = FALSE)
curry <- read.csv("../data/stephen-curry.csv", colClasses = coltypes, stringsAsFactors = FALSE)


# Add a column "name" to each imported data frame, that contains the name of the corresponding player
iguodala$name <- c("Andre Iguodala")
green$name <- c("Draymond Green")
durant$name <- c("Kevin Durant")
thompson$name <- c("Klay Thompson")
curry$name <- c("Stephen Curry")


# Change the original values of "shot_made_flag" to more descriptive values: replace "n" with "shot_no", and "y" with "shot_yes"
iguodala$shot_made_flag[iguodala$shot_made_flag == "n"]  <-  "shot_no"
iguodala$shot_made_flag[iguodala$shot_made_flag == "y"]  <-  "shot_yes"
green$shot_made_flag[green$shot_made_flag == "n"]  <-  "shot_no"
green$shot_made_flag[green$shot_made_flag == "y"]  <-  "shot_yes"
durant$shot_made_flag[durant$shot_made_flag == "n"]  <-  "shot_no"
durant$shot_made_flag[durant$shot_made_flag == "y"]  <-  "shot_yes"
thompson$shot_made_flag[thompson$shot_made_flag == "n"]  <-  "shot_no"
thompson$shot_made_flag[thompson$shot_made_flag == "y"]  <-  "shot_yes"
curry$shot_made_flag[curry$shot_made_flag == "n"]  <-  "shot_no"
curry$shot_made_flag[curry$shot_made_flag == "y"]  <-  "shot_yes"


# Add a column "minute" that contains the minute number where a shot occurred.
iguodala$minute <- iguodala$period*12 - iguodala$minutes_remaining
green$minute <- green$period*12 - green$minutes_remaining
durant$minute <- durant$period*12 - durant$minutes_remaining
thompson$minute <- thompson$period*12 - thompson$minutes_remaining
curry$minute <- curry$period*12 - curry$minutes_remaining


# Use sink() to send the summary() output of each imported data frame into individuals text files
sink("../output/andre-iguodala-summary.txt")
summary(iguodala)
sink()

sink("../output/draymond-green-summary.txt")
summary(green)
sink()

sink("../output/kevin-durant-summary.txt")
summary(durant)
sink()

sink("../output/klay-thompson-summary.txt")
summary(thompson)
sink()

sink("../output/stephen-curry-summary.txt")
summary(curry)
sink()


# Use the row binding function rbind() to stack the tables into one single data frame (or tibble object)
shots_data <- rbind(iguodala, green, durant, thompson, curry)
shots_data$shot_made_flag <- as.factor(shots_data$shot_made_flag)
shots_data$name <- as.factor(shots_data$name)

# Export (i.e. write) the assembled table as a CSV file shots-data.csv inside the folder data/
write.csv(
  x = shots_data,
  file = "../data/shots-data.csv",
  row.names = FALSE
)


# Use sink() to send the summary() output of the assembled table. Send this output to a text file named shots-data-summary.txt inside the output/ folder
sink(file = "../output/shots-data-summary.txt")
summary(shots_data)
sink()

