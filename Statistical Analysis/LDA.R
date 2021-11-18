
ds = read.csv("StudentAdmits.csv")
head(ds)

plot(ds, col=ds$admit + 1)  # Not much separation, notice the relationship 
                            # between gre & gpa

s = sample(nrow(ds), nrow(ds) * .8)
dsTrain = ds[s, ]
dsTest = ds[-s, ]

##################################################
# Try logistic regression
##################################################

model = glm(admit ~ .,
            family=binomial(link='logit'), 
            data=dsTrain)

summary(model)  # Note, gre and rank significant, gpa less so

pred = predict(model, newdata=dsTest, type='response')
print(pred)   # We get predicted probabilities

# Let's use the .5 cutoff to classify them
pred = ifelse(pred > 0.5, 1, 0)
table(pred, dsTest$admit)  # Look at false positives and false negatives

misClasificError = mean(pred != dsTest$admit)
print(paste('Accuracy',1-misClasificError))

# Let's look at the ROC curve
library(ROCR)
p = predict(model, newdata=dsTest, type="response")
pr = prediction(p, dsTest$admit)
prf = performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)

# Compute the area under the curve
auc = performance(pr, measure = "auc")
auc = auc@y.values[[1]]
auc

##############################################################
# Now, let's look at linear discriminant analysis
##############################################################

library(MASS)

fit = lda(admit ~ ., data=dsTrain)
print(fit)

pred = predict(fit, dsTest)
pred

# Exactly the same performance!  Won't always be the case
table(dsTest$admit, pred$class)

library(ROCR)
pred = prediction(pred$posterior[,2], dsTest$admit) 
perf = performance(pred,"tpr","fpr")
par(mar=c(4, 4, 4, 4))
plot(perf)  # A perfect ROC curve, area = 1.0

# Compute the area under the curve
auc = performance(pred, measure = "auc")
auc = auc@y.values[[1]]
auc

