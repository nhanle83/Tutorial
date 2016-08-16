# no more changin

# load beauty data set (Hammermesh & Biddle)
# open the project beauty.Rdata and copy/paste your command to replace the line below
load("C:/Users/LeN/Google Drive/202/StatsData/Wooldridge/R data sets for 5e/beauty.RData")
library(ggplot2)
library(rgl)
# there is one possibly movie star strayed into the data set. get rid of the observation to make the distribution less skewed
data <- data[data$wage<50,]
#for convenience create variable #look based on comparison with avrage
data$look <- data$belavg*(-1) + data$abvavg
data$look <- factor(data$look, labels = c("belavg", "avg", "abvavg"))
data$belavg <- factor(data$belavg, labels = c("Others", "Below Average"))
data$female <- factor(data$female, labels = c("Male", "Female"))
data$married <- factor(data$married, labels = c("Single", "Married"))
data$service <- factor(data$service, labels = c("Other industries", "Service Industries"))
data$bigcity <- factor(data$bigcity, labels = c("Others", "Big Cities"))

# The "productivity" hypothesis as described in the paper makes the following prediction:
  # the better looking the worker, the more he/she earns
  # better-looking workers "sort" themselves into occupations where good look is rewarded
  # the wage gap in favor of good look is larger for look-rewarding occupations

# The alternative "discrimination" hypothesis makes 2 predictions that are distinct from the productivity hypothesis:
  # there are no sorting into occupations
  # the wage gap in favor of good-looking people persists both between and within occupations.

# In the following steps we explore a section of the data from Hammermesh and Biddle to see which prediction comports with the data
  # note that much of we do is descriptive
  # it's important to understand that to make conclusion about the population as a whole, we'd need to conduct formal hypothesis testing


# draw a histogram for the distribution of wages in the sample
ggplot(data, aes(x=wage, fill=factor(look)))+theme_bw() + 
  geom_histogram(alpha=1/3, position="identity")
  
# Replace geom_histogram with geom_density will give us an alternative presentation that could be a bit more useful (try it)
ggplot(data, aes(x=wage, fill=factor(look)))+theme_bw() +  
  geom_density(alpha=1/3)

# Does good-look payoff's vary by gender? We can examine this question by sectioning the wage distribution
  # into a grid of facets based on the variable female
ggplot(data, aes(x=wage, fill=factor(look)))+theme_bw() +  
  geom_density(alpha=1/3) + 
  facet_grid(female~.)
  
# Does good-look payoff's vary by gender? - Boxplot
ggplot(data, aes(y=data$wage, x=factor(data$look)))+theme_bw() +  
  geom_boxplot(alpha=1/2, aes(fill = factor(data$female))) 

# Does good-look payoff's vary by service sector?
ggplot(data, aes(x=wage, fill=factor(look)))+theme_bw() +  
  geom_density(alpha=1/3, position="identity") + 
  facet_grid(service~.)

# Does good-look payoff's vary by service sector, taking into account gender?
ggplot(data, aes(x=wage, fill=factor(look)))+theme_bw() +  
  geom_density(alpha=1/3, position="identity") + 
  facet_grid(service~female)

# do people sort into service sector by look?
#create count variable
with(data, table(belavg, service))
#to show relative frequency
prop.table(with(data, table(belavg, service)), 1)
# we can do a chi-square test on this:
chisq.test(with(data, table(belavg, service)))

# we can do a scatterplot
b <- ggplot(data, aes(x=educ, y=lwage))+theme_bw()
b+geom_point(alpha = 1/5)+geom_smooth(method="lm")
b+geom_point(alpha = 1/5)+geom_smooth(method="lm")+facet_grid(female ~ married) +theme_bw()

# create simple 2-way boxplots for wage and years of eduction
b <- ggplot(data, aes(x=factor(educ), y=wage))+theme_bw()
b+geom_boxplot(aes(fill=factor(data$look)))



# run a simple regression
regression <- with(data, lm(lwage ~ abvavg*female + belavg*female + educ + exper + married + bigcity + service))
summary(regression)
