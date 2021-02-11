##Lets train a logistic regression model on the airbnb data to classify whether the nightly price of 
#a listing is affordable or expensive through a logistic regression model made from scartch
#we will then compare the model made from scartch to sk learns model in terms of time to run model and accuracy
import pandas as pd
df = pd.read_csv('milan.csv', sep = ',')

a = df['accommodates']
b = df['bed_type']
c = df['availability_30']
d = df['review_scores_rating']
e = df['Kitchen']
f = df['daily_price']

df1 = pd.concat([a,b,c,d,e,f], axis=1)

df1['daily_price'].max()
df1['daily_price'].min()

df1['daily_price'] = df1['daily_price'].apply(lambda x : 1 if x < 200 else 0)

y = df1['daily_price']
X = df1[['accommodates', 'bed_type']]
X1 = X
X2= X

import numpy as np

#How the logitic regression model works under the hood:
#Let there be features x1, x2,...Xn, such that the linear combination of these features
#is equal to the log of odds, the odds are the likelihood of the event taking place and the
#log just maps the output from 0,1 to -infinity to +infinity
#raising the LHS and RHS to the power of e and manipulating, we derive the sigmoid function
#which is a function of the linear combination of data and coeeficients.
def sigmoid(X, weight):
    z = np.dot(X, weight)
    return 1 / (1 + np.exp(-z))

#The loss function is basically th error, it is teh diffference between the predicted values and actial values
#This is an L2 loss function, so the difference will be squared and then summer across all training osbervations
def loss(h, y):
    return (-y * np.log(h) - (1 - y) * np.log(1 - h)).mean()

#Now that we have the error, the model paarmeters need to be updated at every iteration to minimize
#this loss function, this will be done through Gradient Descent algorithm
def gradient_descent(X, h, y):
    return np.dot(X.T, (h - y)) / y.shape[0]

#The main conecpt behind gradient descent is that the partial deravtive at its minumum is equal to 0
#The partial deravitive of the cost functiom represents the infinitesimal error in the model,
#This error is just taken away from the parameters and updated at every iteration to move towards
#a local minimum for this problem of minimziing the loss function with respect to this model. 
#The loss function approaches 0 as we do this and the accuracy of the model approaches 100%,
#but does not alwways get there 
def update_weight_loss(weight, learning_rate, gradient):
    return weight - learning_rate * gradient

import time

start_time = time.time()

num_iter = 100000

#lets initialize the intercept of the model
intercept = np.ones((X.shape[0], 1)) 
X = np.concatenate((intercept, X), axis=1)
theta = np.zeros(X.shape[1])

for i in range(num_iter):
    h = sigmoid(X, theta)
    gradient = gradient_descent(X, h, y)
    theta = update_weight_loss(theta, 0.1, gradient)
    
print("Training time (Log Reg using Gradient descent):" + str(time.time() - start_time) + " seconds")
print("Learning rate: {}\nIteration: {}".format(0.1, num_iter))

result = sigmoid(X, theta)

f = pd.DataFrame(np.around(result, decimals=6)).join(y)
#Predictions return a probability, we neeed to convert into a binary value 0 or 1
f['pred'] = f[0].apply(lambda x : 0 if x < 0.5 else 1)
print("Accuracy (Loss minimization):")
f.loc[f['pred']==f['daily_price']].shape[0] / f.shape[0] * 100


def log_likelihood(x, y, weights):
    z = np.dot(x, weights)
    ll = np.sum( y*z - np.log(1 + np.exp(z)) )
    return ll

def gradient_ascent(X, h, y):
    return np.dot(X.T, y - h)

def update_weight_mle(weight, learning_rate, gradient):
    return weight + learning_rate * gradient

start_time = time.time()
num_iter = 100000

intercept2 = np.ones((X2.shape[0], 1))
X2 = np.concatenate((intercept2, X2), axis=1)
theta2 = np.zeros(X2.shape[1])

for i in range(num_iter):
    h2 = sigmoid(X2, theta2)
    gradient2 = gradient_ascent(X2, h2, y) #np.dot(X.T, (h - y)) / y.size
    theta2 = update_weight_mle(theta2, 0.1, gradient2)
    
print("Training time (Log Reg using MLE):" + str(time.time() - start_time) + "seconds")
print("Learning rate: {}\nIteration: {}".format(0.1, num_iter))

result2 = sigmoid(X2, theta2)

print("Accuracy (Maximum Likelihood Estimation):")
f2 = pd.DataFrame(result2).join(y)
f2.loc[f2[0]==f2['daily_price']].shape[0] / f2.shape[0] * 100

#The training time with MLE is 142 sceconds and the accuracy drops to 82 from 92

#Lets try sk learns logistic regression model now
from sklearn.linear_model import LogisticRegression

logreg = LogisticRegression(fit_intercept=True, max_iter=100000)
logreg.fit(X1, y)
print("Training time (sklearn's LogisticRegression module):" + str(time.time() - start_time) + " seconds")
print("Learning rate: {}\nIteration: {}".format(0.1, num_iter))

result3 = logreg.predict(X1)

print("Accuracy (sklearn's Logistic Regression):")
f3 = pd.DataFrame(result3).join(y)
f3.loc[f3[0]==f3['daily_price']].shape[0] / f3.shape[0] * 100

#27 seconds to run with gradient descent, 15 seconds with sklearn, accuracy with both is around 92
#In production, you would probably use sklearns algorithm over the one made from scracth because
#it has its own optimizers that would make the model run much faster
#----------------------------------------------------------------------------------------------------------

#Lets train a linear regression model on the airbnb data and predict the nightly price of an airbnb apt
#and lets select the best model that minimizes the mean squared error
import pandas as pd

df = pd.read_csv('milan.csv', sep = ',')

#Subset the data frame to have fewer columns to deal with
X = df[['accommodates', 'bed_type', 'zipcode', 'bathrooms', 'availability_30', 'review_scores_rating', 'TV', 'Kitchen']]
y = df[['daily_price']]

#Lets standardize the data by subtracting mean and dividing by varaiance, there is a function for this:
from sklearn.preprocessing import StandardScaler

scaler = StandardScaler()
scaled_data = scaler.fit_transform(X)

from sklearn.model_selection import train_test_split

X_train,X_test =train_test_split(scaled_data, test_size=0.3)

Y_train,Y_test =train_test_split(y, test_size=0.3)

from sklearn.linear_model import LinearRegression

linreg = LinearRegression()
linreg.fit(X_train, Y_train)

predictions = linreg.predict(X_test)

from sklearn.metrics import mean_squared_error

lin_mse = mean_squared_error(Y_test, predictions)
lin_mse

import numpy as np 
lin_rmse = np.sqrt(lin_mse)
lin_rmse

#THe linear rgression RMSE is 111, this is a good start but this might be due to unerfitting
#Lets try a more powerful model like decision tree regressor(a way to address underfitting), 
#this model is more capable of finding complex non linear relationships in the data 
from sklearn.tree import DecisionTreeRegressor

treereg = DecisionTreeRegressor()

treereg.fit(X_train, Y_train)

predictions2 = treereg.predict(X_test)

tree_mse = mean_squared_error(Y_test, predictions2)
tree_mse

#lets try K folds cross validation, it randomly splits the data into 10 folds or subsets
#then it trains and evlautes the decision tree model 10 times pikcking idfferent folds every time
#The result is an array containing the 10 evaluation scores

from sklearn.model_selection import cross_val_score

scores = cross_val_score(treereg, X_train, Y_train, scoring = 'neg_mean_squared_error', cv = 10)

import numpy as np

tree_rmse_scores = np.sqrt(-scores)

def display_scores(scores):
    print("Scores:", scores)
    print("Mean:", scores.mean())
    print("Standard Deviation:", scores.std())
    
display_scores(tree_rmse_scores)

#With cross validation thee mean RMSE is 231
#The standard deviationn tells you how precise this estimate is, so the RMSE is 231 + - SD

#Lets try an enemble method this time, this will average out the prediction from several trees 
from sklearn.ensemble import RandomForestRegressor

forestreg = RandomForestRegressor()

forestreg.fit(X_train, Y_train)

predictions3 = forestreg.predict(X_test)

scores1 = cross_val_score(forestreg, X_train, Y_train, scoring = 'neg_mean_squared_error', cv = 10)

forest_rmse_scores = np.sqrt(-scores1)

display_scores(forest_rmse_scores)

#mean error is 171 so it is reducing even further with this model, random forest model looks promising

#Now that we have a promosing model, lets fine tune them
#Grid Search will automatically tune the hyperparameters and return you the best model with the best parameters
from sklearn.model_selection import GridSearchCV

param_grid = [
        {'n_estimators': [3,10,30], 'max_features': [2,4,6,8]},
        {'bootstrap': [False], 'n_estimators':[3,10], 'max_features': [2,3,4]},
        ]

forest_reg = RandomForestRegressor()

grid_search = GridSearchCV(forest_reg, param_grid, cv = 5, scoring = 'neg_mean_squared_error')

grid_search.fit(X_train, Y_train)

# These are the best parameters: {'max_features': 2, 'n_estimators': 30}
grid_search.best_params_

#This is the best model with those parameters, so we can select this model for our probelem
grid_search.best_estimator_

feature_importance = grid_search.best_estimator_.feature_importances_
feature_importance

#Looks like the second feature is the least important in this model,
#so this can be removed to improve the selected model further

final_model = grid_search.best_estimator_

final_predictions = final_model.predict(X_test)

final_mse = mean_squared_error(Y_test, final_predictions)

final_rmse = np.sqrt(final_mse)
final_rmse
#Final rmse = 119, this is is the lowest we have got it, so that means the hyper paarmeter tuning worked






