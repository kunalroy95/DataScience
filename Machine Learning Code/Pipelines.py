#The department wants to build a model that will help them identify the potential customers who have
#a higher probability of purchasing the loan. This will increase the success ratio while at the same
#time reduce the cost of the campaign.

import pandas as pd
from sklearn.compose import ColumnTransformer 
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
from sklearn.ensemble import  RandomForestRegressor
import matplotlib.pyplot as plt
from sklearn.linear_model import LogisticRegression
from sklearn.tree import DecisionTreeClassifier

# read the training data set
df = pd.read_csv('bank_loan.csv')

df.isna().sum()
#no null values

# seperate the independent and target variables
X = df.drop(columns=['ID', 'Personal Loan'])
y = df['Personal Loan']

train_X, test_X, train_y, test_y = train_test_split(X, y,test_size=0.25,random_state=0)

# create an object of the RandomForestRegressor
model_RFR = RandomForestRegressor(max_depth=10)

# fit the model with the training data
model_RFR.fit(train_X, train_y)

# predict the target on train and test data
predict_train = model_RFR.predict(train_X)
predict_test = model_RFR.predict(test_X)

# Root Mean Squared Error on train and test data
print('RMSE on train data: ', mean_squared_error(train_y, predict_train)**(0.5))
print('RMSE on test data: ',  mean_squared_error(test_y, predict_test)**(0.5))
#The errors are very low on both train and test data, indicating this model works well on this data

plt.figure(figsize=(10,7))
feat_importances = pd.Series(model_RFR.feature_importances_, index = train_X.columns)
feat_importances.nlargest(12).plot(kind='barh');
#from the feature importance, Credit Card, Online, Securities Account and mortgage are not a very importnat feature, so I will drop them later

#Pipeline Design:

# pre-processsing steps
# Drop the columns
# Scale the data

numeric_features = ['Age', 'Experience', 'Income', 'ZIP Code', 'Family', 'CCAvg', 'Education', 'CD Account']
numeric_transformer = Pipeline(steps=[('scaler', StandardScaler())])

pre_process = ColumnTransformer(transformers=[('drop_columns','drop', ['CreditCard',
                                                                        'Online',
                                                                        'Securities Account',
                                                                        'Mortgage']),('num', numeric_transformer, numeric_features)])

pipeline_rf = Pipeline(steps=[('pre_processing',pre_process),
                                 ('random_forest', RandomForestRegressor(max_depth=10,random_state=2))])

pipeline_dt = Pipeline(steps=[('pre_processing',pre_process),
                                 ('random_forest', DecisionTreeClassifier())])

pipeline_lr = Pipeline(steps=[('pre_processing',pre_process),
                                 ('random_forest', LogisticRegression(random_state=0))])

# Lets make the list of pipelines
pipelines = [pipeline_rf, pipeline_dt, pipeline_lr]

pipe_dict = {0: 'Logistic Regression', 1: 'Decision Tree', 2: 'RandomForest'}

# Fit the pipelines
for pipe in pipelines:
	pipe.fit(train_X, train_y)

for i,model in enumerate(pipelines):
    print("{} Test Accuracy: {}".format(pipe_dict[i],model.score(test_X,test_y)))

#Decision Tree algorithm has the best accuracy
