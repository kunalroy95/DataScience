import pickle

import pandas as pd
df = pd.read_csv('milan.csv', sep = ',')

a = df['accommodates']
b = df['bed_type']
c = df['availability_30']
d = df['review_scores_rating']
e = df['Kitchen']
f = df['daily_price']

df1 = pd.concat([a,b,c,d,e,f], axis=1)

y = df1['daily_price']
X = df1[['accommodates', 'bed_type']]

from sklearn.linear_model import LinearRegression

linreg = LinearRegression()
linreg.fit(X, y)

#saving model to disk
pickle.dump(linreg, open('model.pkl', 'wb'))

#loading model to compare results1
model = pickle.load(open('model.pkl','rb'))

#check the prediction
linreg.predict([[1,2]])



