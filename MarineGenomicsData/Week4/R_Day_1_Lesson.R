###Day 1 Lesson

## Lines that start with a # will not be executed in R
## So we often start comment lines with a #
## Comments help you to remember what you did and why you did it.
## We recommend you comment profusely!

#################################
##### 1.1 ORIENTATION TO R  #####
#################################

## R can be used for basic arithmetic
2 + 2

## It can also store values in variables
 # assign an object using <-, =
x <- 5

 # see that object
x

 # objects can be numbers, characters
x <- 5
y <- "hello"

x
y

## We can make vectors using c() to concatenate
 # vectors can include numbers
x <- c (1, 2, 3, 4, 5)

x

  # we can use colons to get sequences of numbers
1:10

 # vectors can include characters (in quotes)
y <- c ("dog", "cat", "dolphin")
y

## Manipulating a vector object 
 # We can get summaries of vectors
summary(x)

  # we can see how long a vector is
length(x)

  # use [] to get parts of vectors
x[1]
x[3]

## Operations act on each element of a vector
  # +2
x + 2

  # *2
x * 2

  # mean
mean(x)

  # ^2
x^2

## Operations can also work with two vectors
y <- c(10, 20, 30, 40, 50)

  # x + y
x + y

  # x * y
x * y

## We can keep track of what objects R is using, with the functions ls() and objects()
 # how to get help for a function
?mean

 # you can get rid of objects you don't want
  # rm()
rm(y)

 # and make sure it got rid of them
ls()

## remember annotate your code! For you and so you can share

            # EXERCISE 1.1 # 


########################################
##### 1.2 CHARACTERIZE A DATAFRAME #####
########################################

#useful functions: install.packages(), library(), data(), str(), dim(), colnames(), rownames()
                 # class(), as.factor(), as.numeric(), unique(), t(), max(), min(), mean(), summary()


## Install a package; We're going to use the package ggplot2. This package is for plotting but also contains a few datasets
install.packages("ggplot2")

## Call library(package)
library("ggplot2")

## We're going to use data on msleep
 # load the data (it's called msleep)
data(msleep)

 # See what this data looks like
  # head(), tail()
head(msleep)
tail(msleep)

  # str()
str(msleep)

  # data from packages usually has additional info like a function


  # dim(), ncol(), nrow()
dim(msleep)
ncol(msleep)
nrow(msleep)

  # colnames(), rownames()
colnames(msleep)
rownames(msleep)

  # Rstudio allows us to View() the data
View(msleep)


## Classes of data & subsetting datasets
## How to access parts of the data
 # one element
msleep[1,1]

 # one column
msleep [,1]

 # one row
msleep [1,]

 # we can look at a single column at a time
  # there are three ways to access this $, [,#], [,"a"]
msleep$name
msleep [,1]
msleep [,"Cheetah"]

  # sometimes it is useful to know what class() the column is
class(msleep$name)

 # we can look at a single row at a time
  # there are two ways to access this [#,], ["a",]
msleep [1,]
msleep ["Cheetah",]

## we can select more than one row or column at a time
 # see two columns
msleep[,c("name","sleep_total")]

 # and make a new data frame from these subsets
sleep_data <- msleep[,c("name","sleep_total")]
sleep_data

## But what if we actually care about how many unique things are in a column?
 # unique()
unique(msleep$vore)

 # table()
table(msleep$vore)

 # levels(), if class is factor
levels(msleep$vore)


## If your data is transposed in a way that isn't useful to you, you can switch it.
##  note that this often changes the class of each column!
##  In R, each column must have the same type of data
 # t()
t(msleep[1:5,1:5])

## It's important to know the class of data if you want to manipulate it.
##   for example, you can't add characters!
## msleep is made of many types of data
##   some common classes are: factors, numeric, integers, characters, logical
 # class()
class(msleep$sleep_total)

 # str()
str(msleep)

## Often we want to summarize data
 # calculate mean() of a column
mean(msleep$sleep_total)

 # max()
max(msleep$sleep_total)

 # min()
min(msleep$sleep_total)

 # summary()
summary(msleep$sleep_total)

## Sometimes, the values we care about aren't provided in a data set. When this happens, we can create a new column

# what if what we cared about was our sleep_total/sleep_rem ratio?
# add a sleep_total/sleep_rem ratio column to our msleep dataframe with $
msleep$sleep_ratio <- msleep$sleep_total / msleep$sleep_rem
msleep$sleep_ratio

# look at our dataframe again
head(msleep)

          ## EXERCISE 1.2 ##


##############################################
##### 1.3 SUBSETTING DATASETS & LOGICALS #####
##############################################

# useful commands: "==", "!=", ">", "<", "&", "|", which

# Reminder: assignment operators in R 
 # <-
 # =

## logical conditions vs. assignment operators
 # logical values of TRUE and FALSE are special in R
TRUE
FALSE

 # What class is a logical value?
class(TRUE)

 # Logical values are stored as 0 for FALSE and 1 for TRUE
 #  so you can do math with them
  # sum()
sum(c(TRUE, FALSE, TRUE, TRUE))

## logicals will be the output of various tests
 # equals
5 == 5

 # does not equal
5 != 3

 # greater than
5 > 3

 # less than
5 < 3

 # combining logical conditions with and (&), or(|)
5 > 3 & 5 < 10
5 > 3 | 5 < 2
 
 # we can take the opposite of a logical by using !
!TRUE
!FALSE

### Testing for conditions can be extended to vectors and columns of data frames
 # Which numbers in 1:10 are greater than 3?
(1:10) > 3
(1:10)[(1:10) > 3]

 # How many numbers in 1:10 are greater than 3?
sum((1:10) > 3)

# in our msleep data frame, which species have total sleep greater than 18 hours?
msleep$name[msleep$sleep_total > 18]

# reload the msleep data with library(ggplot2) and data(msleep) if you need to

# Using which() to identify which rows match the logical values (TRUE) and length to count how many species there are
which(msleep$sleep_total > 18)
length(which(msleep$sleep_total >18))

# which four species are these?
msleep$name[which(msleep$sleep_total > 18)]

# what if we only want to see the bats that sleep more than 18 hours per 24 hour period?
msleep$name[msleep$order == "Chiroptera" & msleep$sleep_total > 18]

      ### EXERCISE 1.3 ###


# next week we'll be making plots, doing for loops, and the apply family of functions!

