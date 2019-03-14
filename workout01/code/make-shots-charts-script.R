# ---------------
# title: Shot Charts
# description: Create several shot chats using shots-data.csv.
# inputs(s): shots-data.csv; nba-court.jpg
# output(s): andre-iguodala-shot-chart.pdf; draymond-green-shot-chart.pdf; kevin-durant-shot-chart.pdf; klay-thompson-shot-chart.pdf; stephen-curry-shot-chart.pdf
# ---------------


library(ggplot2)
library(jpeg)
library(grid)


# import shots-data.csv
coltypes <- c("character", "character", "integer", "integer", "integer", "integer", "factor", "character", "factor", "integer", "character", "integer", "integer", "factor", "integer")
shots_data <- read.csv("../data/shots-data.csv", stringsAsFactors = FALSE, colClasses = coltypes)


# import nba-court.jpg (to be used as background of plot)
# create raste object
court_image <- rasterGrob(
  readJPEG("../images/nba-court.jpg"),
  width = unit(1, "npc"),
  height = unit(1, "npc"))


# andre-iguodala-shot-chart
iguodala_shot_chart <- ggplot(data = shots_data[shots_data$name == "Andre Iguodala",]) +
  annotation_custom(court_image, -250, 250, -50, 420) +
  geom_point(aes(x = x, y = y, color = shot_made_flag)) +
  ylim(-50, 420) +
  ggtitle('Shot Chart: Andre Iguodala (2016 season)') +
  theme_minimal()

# draymond-green-shot-chart
green_shot_chart <- ggplot(data = shots_data[shots_data$name == "Draymond Green",]) +
  annotation_custom(court_image, -250, 250, -50, 420) +
  geom_point(aes(x = x, y = y, color = shot_made_flag)) +
  ylim(-50, 420) +
  ggtitle('Shot Chart: Draymond Green (2016 season)') +
  theme_minimal()

# kevin-durant-shot-chart
durant_shot_chart <- ggplot(data = shots_data[shots_data$name == "Kevin Durant",]) +
  annotation_custom(court_image, -250, 250, -50, 420) +
  geom_point(aes(x = x, y = y, color = shot_made_flag)) +
  ylim(-50, 420) +
  ggtitle('Shot Chart: Kevin Durant (2016 season)') +
  theme_minimal()

# klay-thompson-shot-chart
thompson_shot_chart <- ggplot(data = shots_data[shots_data$name == "Klay Thompson",]) +
  annotation_custom(court_image, -250, 250, -50, 420) +
  geom_point(aes(x = x, y = y, color = shot_made_flag)) +
  ylim(-50, 420) +
  ggtitle('Shot Chart: Klay Thompson (2016 season)') +
  theme_minimal()

# stephen-curry-shot-chart
curry_shot_chart <- ggplot(data = shots_data[shots_data$name == "Stephen Curry",]) +
  annotation_custom(court_image, -250, 250, -50, 420) +
  geom_point(aes(x = x, y = y, color = shot_made_flag)) +
  ylim(-50, 420) +
  ggtitle('Shot Chart: Stephen Curry (2016 season)') +
  theme_minimal()


# save the shot charts in PDF format
pdf("../images/andre-iguodala-shot-chart.pdf", width = 6.5, height = 5)
iguodala_shot_chart
dev.off()

pdf("../images/draymond-green-shot-chart.pdf", width = 6.5, height = 5)
green_shot_chart
dev.off()

pdf("../images/kevin-durant-shot-chart.pdf", width = 6.5, height = 5)
durant_shot_chart
dev.off()

pdf("../images/klay-thompson-shot-chart.pdf", width = 6.5, height = 5)
thompson_shot_chart
dev.off()

pdf("../images/stephen-curry-shot-chart.pdf", width = 6.5, height = 5)
curry_shot_chart
dev.off()


# Create one graph, using facetting, to show all the shot charts in one image
shot_chart <- ggplot(data = shots_data) +
  annotation_custom(court_image, -250, 250, -50, 420) +
  geom_point(aes(x = x, y = y, color = shot_made_flag)) +
  ylim(-50, 420) +
  ggtitle('Shot Chart: GSW (2016 season)') +
  facet_wrap(~name) +
  theme_minimal()


# output the facetted shot chart
pdf("../images/gsw-shot-charts.pdf", width = 8, height = 7)
shot_chart
dev.off()

png("../images/gsw-shot-charts.png", width = 8, height = 7, units = "in", res = 200)
shot_chart
dev.off()
  


