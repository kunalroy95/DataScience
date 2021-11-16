#CUSTID : Identification of Credit Card holder (Categorical)
#BALANCEFREQUENCY : How frequently the Balance is updated, score between 0 and 1 (1 = frequently updated, 0 = not frequently updated)
#PURCHASES : Amount of purchases made from account
#ONEOFFPURCHASES : Maximum purchase amount done in one-go
#INSTALLMENTSPURCHASES : Amount of purchase done in installment
#CASHADVANCE : Cash in advance given by the user
#PURCHASESFREQUENCY : How frequently the Purchases are being made, score between 0 and 1 (1 = frequently purchased, 0 = not frequently purchased)
#ONEOFFPURCHASESFREQUENCY : How frequently Purchases are happening in one-go (1 = frequently purchased, 0 = not frequently purchased)
#PURCHASESINSTALLMENTSFREQUENCY : How frequently purchases in installments are being done (1 = frequently done, 0 = not frequently done)
#CASHADVANCEFREQUENCY : How frequently the cash in advance being paid
#CASHADVANCETRX : Number of Transactions made with "Cash in Advanced"
#PURCHASESTRX : Numbe of purchase transactions made
#CREDITLIMIT : Limit of Credit Card for user
#PAYMENTS : Amount of Payment done by user
#MINIMUM_PAYMENTS : Minimum amount of payments made by user
#PRCFULLPAYMENT : Percent of full payment paid by user
#TENURE : Tenure of credit card service for user


#Lets do an anomaly detection:

import pandas as pd
from sklearn.ensemble import IsolationForest
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA

df = pd.read_csv('CC GENERAL.csv')

df.isna().sum()
df['MINIMUM_PAYMENTS'] = df['MINIMUM_PAYMENTS'].fillna((df['MINIMUM_PAYMENTS'].mean()))
df['CREDIT_LIMIT'] = df['CREDIT_LIMIT'].fillna((df['CREDIT_LIMIT'].mean()))

a = df[['ONEOFF_PURCHASES']]

#Lets fit isolation forest model to see whcih customers made some very high one off purchases
#this can be investigated further to see if there were any fraudulent transactions
model = IsolationForest(n_estimators=50, max_samples='auto', contamination=float(0.1),max_features=1.0)
model.fit(a[['ONEOFF_PURCHASES']])


#Lets get the anomoly scores of each purchase and whether they are anaomolous points or not
a['Scores']=model.decision_function(a[['ONEOFF_PURCHASES']])
a['anomaly']=model.predict(a[['ONEOFF_PURCHASES']])


#Lets retrive all the anomolous points
anomaly=a.loc[a['anomaly']==-1]
anomaly_index=list(anomaly.index)
print(anomaly)

#Lets get the most anomlous points that have a secore below -0.3 and save them in a data frame
most_anomalous = anomaly.loc[anomaly['Scores'] < - 0.3]

#Now we have 48 most anaomolous points, their index can be matched with the customer ID
#to identify which customers need to be evaluated for one off fraudulent transactions.
#For example,the first most anomalous point is associated with customer with ID, C10131


#Now lets do a K means clustering 


df1 = df

df1 = df1.drop(columns=['CUST_ID'])

pca = PCA(2)
 
#Transform the data
df2 = pca.fit_transform(df1)
 
df2.shape

scaler = StandardScaler()
scaled_df = scaler.fit_transform(df2)

kmeans = KMeans(
    init="random",
    n_clusters=3,
    n_init=10,
    max_iter=300,
    random_state=42
)

kmeans.fit(scaled_df)

kmeans.labels_[:5]

kmeans_kwargs = {
    "init": "random",
    "n_init": 10,
    "max_iter": 300,
    "random_state": 42,
}

# A list holds the SSE values for each k
sse = []
for k in range(1, 11):
    kmeans = KMeans(n_clusters=k, **kmeans_kwargs)
    kmeans.fit(scaled_df)
    sse.append(kmeans.inertia_)
    
plt.style.use("fivethirtyeight")
plt.plot(range(1, 11), sse)
plt.xticks(range(1, 11))
plt.xlabel("Number of Clusters")
plt.ylabel("SSE")
plt.show()

#Initialize the class object
kmeans = KMeans(n_clusters= 10)
 
#predict the labels of clusters.
label = kmeans.fit_predict(scaled_df)
 
print(label)

#filter rows of original data
filtered_label0 = scaled_df[label == 0]
 
#plotting the results
plt.scatter(filtered_label0[:,0] , filtered_label0[:,1])
plt.show()

#filter rows of original data
filtered_label2 = scaled_df[label == 2]
 
filtered_label8 = scaled_df[label == 8]
 
#Plotting the results
plt.scatter(filtered_label2[:,0] , filtered_label2[:,1] , color = 'red')
plt.scatter(filtered_label8[:,0] , filtered_label8[:,1] , color = 'black')
plt.show()

#Getting unique labels
 
import numpy as np 

u_labels = np.unique(label)
 
#plotting the results:
 
for i in u_labels:
    plt.scatter(scaled_df[label == i , 0] , scaled_df[label == i , 1] , label = i)
plt.legend()
plt.show()


