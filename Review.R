################################
##     Review for pre-MLE     ##
################################


# install.packages("survival")
# install.packages("MASS")
library("MASS")
library("survival")
rm(list=ls(all=TRUE))

# 1. Creating objects of random and not so random numbers

# 1.1. Sequential number = use the seq() function.

# The basic arguments for the seq() function are:

## seq(from=1, to=2, by=[the space between one number and the next]); or
## qeq(from=1, to=2, length.out=[how long you want your object to be]).

# e.g.:
seq(-1.75, 3.25, by = 0.5)
seq(-1.75, 3.25, length.out = 21)
# seq(-1.75, 3.25, length.out = 11) is the same as seq(-1.75, 3.25, by = 0.5)

x <- seq(-1.75, 3.25, by = 0.5)

# 1.2. Random numbers = rnorm(); runif(); rmvnorm()

# The basic arguments for the rnorm() function are:
# rnorm(n, mean = , sd = ); where n is the size of the object, mean is the mean and sd is the stand. dev.

y1 <- rnorm(1000, 5, 1)
mean(y1) # Note that the mean is not exactly 5.
hist(y1)

# The basic arguments for the runif() function are:
# runif(n, min = , max = ) generate n uniform random numbers lie in the interval (min, max)

y2 <- runif(1000, 5, 10)
hist(y2)

# For two random correlated variables, the basic arguments for the mvrnorm() function are:
# mvrnorm(n, mu = , Sigma = ) correlates mu, a vector giving the means of the variables,
# in the terms of a covariance matrix Sigma

sigma <- matrix(c(1, 0.5, 0.5, 1), 2) # for .5 corr
z <- mvrnorm(n = 500, mu = c(0, 0), Sigma = sigma)
cor(z[, 1], z[, 2])
colMeans(z)

# You can access any element within an object through brackets:
# z[place of the vector] if its a vector
# z[row,column] if its a matrix-like object

# 7th place of vector y:
y1[7]

# 3rd row from the 2nd column of object z
z[3, 2]

# The whole 3 row from object z
z[3, ]

# You can also use the brackets to include a conditional statement
# (i.e. the if from Stata)

y1[y1 > 5] <- 0 # This will replace all values of y above 5 with 0s.

# 2. Function for logit and probit

# We will be using the glm() base function. glm stands for
# Generalized linear model. GLM uses a link function that allows the errors
# not to be normally distributed.

# Let's create some data first

set.seed(1984)
x1 = rnorm(1000)           # some continuous variables
x2 = rnorm(1000)
z = 1 + 2 * x1 + 3 * x2        # linear combination with a bias
pr = 1 / (1 + exp(-z))         # pass through an inv-logit function
y = rbinom(1000, 1, pr)      # bernoulli response variable

#now feed it to glm:

data = data.frame(y = y, x1 = x1, x2 = x2)

# Logistic Regression
# where y is a binary factor and
# x1-x2 are continuous predictors

fit <- glm(y ~ x1 + x2, data = data, family = binomial(link = "logit"))
summary(fit) # display results
confint(fit) # 95% CI for the coefficients
exp(coef(fit)) # exponentiated coefficients
exp(confint(fit)) # 95% CI for exponentiated coefficients
predict(fit, type = "response") # predicted values
residuals(fit, type = "deviance") # residuals

plot(z,predict(fit, type = "response")) # pretty logit

# 3. Loops (copy-pasted from section 6.2 from 622)

# Let's assume the following:

# the size of a sample
n <- 2000
# set true mean and standard deviation values
m <- 50
s <- 2

# Create an object TheoreticalSE calculating the standard error:
TheoreticalSE <- s / sqrt(n)

# Now generate lots and lots (and lots) of samples with mean m and standard deviation s
# and get the means of those samples. Save them in y.
# Hint: you can use loops, or you can use the function replicate()
y <- NA

for (i in 1:10000) {
  # Translation: let i go from 1 to 10000
  y[i] <-
    mean(rnorm(n, m, s)) # in the place i from object y do sth.
}

y2 <- replicate(10000, mean(rnorm(n, m, s)))

# Calculate the SD of your y and save it in the object BruteForceSE
BruteForceSE <- sd(y)

# We can compare our brute force estimates with our theoretical estimates
BruteForceSE
TheoreticalSE

# We can even see how accurate is the law of large numbers (proved by Jacob Bernoulli way back
# when). In other words, we can see if the sample mean will be an unbiased estimator.

LLN <- mean(y)
LLN

# Let's get fancy. Why don't we do the same thing, but for different n's, just for the sake of it.
# You could do it one by one, but you are better than that. You are a graduate student who decided
# to give up 5 to 7 years of your life to advance the frontiers of knowledge, while not having
# the option of a 401k (in a country with no pension system). But I digress...

# One way to do this is by creating a loop within a loop (or a replicate within a loop)

# We have to first define our new object n, and in that include the values you want for n.

# Create an object n, with the values: 9, 25, 64, 169, 441, 1156, 3025, 7921.

n <- c(9, 25, 64, 169, 441, 1156, 3025, 7921)

# Create an object TheoreticalSEloop calculating the standard error for all:
# Hint 1: use a loop (you can try using the function lapply() but I am not familiar with it
# so you are sort of on your own... but if you do, then you can teach us all.)
# Hint 2: use the function lenght(x) which returns the number of elements in a vector x.
TheoreticalSEloop <- NA

for (i in 1:length(n)) {
  TheoreticalSEloop[i] <- s / sqrt(n[i])
  
}
TheoreticalSEloop

# Create an object BruteForceSEloop with the SE of our samples simulated 10000 times.

y <- NA
BruteForceSEloop <- NA

for (j in 1:length(n)) {
  for (i in 1:10000) {
    y[i] <- mean(rnorm(n[j], m, s))
  }
  BruteForceSEloop[j] <- sd(y)
}

# Compare
BruteForceSEloop
TheoreticalSEloop
