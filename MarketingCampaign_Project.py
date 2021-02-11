##We will be predicting whether customers are likley to repsond to marketing campaigns 
#and will chose the best model to do so via multiple evaluation metrics

import pandas as pd

df = pd.read_csv('marketing_campaign.csv', sep = ';')

# Data Cleaning
#Finding the range of a column
df['Year_Birth'].max() 
df['Year_Birth'].min()

#Drop the ID column
df = df.drop(['ID'], axis=1)

#Lets find out which column has missing values
total = df.isnull().sum().sort_values(ascending=False)
percent_1 = df.isnull().sum()/df.isnull().count()*100
percent_2 = (round(percent_1, 1)).sort_values(ascending=False)
missing_data = pd.concat([total, percent_2], axis=1, keys=['Total', '%'])
missing_data
#Only the Income column has missing values, 24 of them, lets impute these missing values with the mean

#Impute missing values with mean
df['Income']=df['Income'].fillna(df['Income'].mean())

#Lets convert year birth to age of the customer
df['Year_Birth'] = 2020 - df['Year_Birth']

#Rename the column to age
df = df.rename({'Year_Birth':'Age'}, axis='columns')
df.info()

#Change column from object to int
df['Age'] = df['Age'].astype(int)

#Extract the year from the date
df['Dt_Customer'] = df['Dt_Customer'].str.slice(0, 4)

df['Dt_Customer'] = df['Dt_Customer'].astype(int)

#Lets chnage the column to how long has he been a customer = customer_age
df['Dt_Customer'] = 2020 - df['Dt_Customer']

df = df.rename({'Dt_Customer':'Customer_Age'}, axis='columns')

df['Response'].value_counts()

#Keep a copy of this data frame
df1 = df
df.hist(column='Age')
df['Age'].max() 
df['Age'].min()

#Lets break down the ages into some categories that are going to be assigned to integers
data = [df]
for dataset in data:
    dataset.loc[ dataset['Age'] <= 30, 'Age'] = 0
    dataset.loc[(dataset['Age'] > 30) & (dataset['Age'] <= 40), 'Age'] = 1
    dataset.loc[(dataset['Age'] > 40) & (dataset['Age'] <= 60), 'Age'] = 2
    dataset.loc[(dataset['Age'] > 60) & (dataset['Age'] <= 80), 'Age'] = 3
    dataset.loc[(dataset['Age'] > 80) & (dataset['Age'] <= 100), 'Age'] = 4
    dataset.loc[ dataset['Age'] > 100, 'Age'] = 6
    
df['Education'].value_counts()

#Replace certain instances with the new terms as they were not understandabke before
df["Education"].replace({"2n Cycle": "High School", "Basic": "Middle School", "Graduation": "Undergrad"}, inplace=True)

#encode the education varaible
genders = {"Undergrad": 0, "PhD": 1, "Master": 2, "High School":3, "Middle School": 4}
data = [df]
for dataset in data:
    dataset['Education'] = dataset['Education'].map(genders)

df['Marital_Status'].value_counts()

#Remove records with YOLO, absurd and alone in it
df = df[df['Marital_Status'] != 'YOLO']
df = df[df['Marital_Status'] != 'Absurd']
df = df[df['Marital_Status'] != 'Alone']

#encode the education varaible
edlevel = {"Widow": 0, "Divorced": 1, "Single": 2, "Together":3, "Married": 4}
data = [df]
for dataset in data:
    dataset['Marital_Status'] = dataset['Marital_Status'].map(edlevel)
    
#Drop more unneeded variables
df = df.drop(['AcceptedCmp1', 'AcceptedCmp2', 'AcceptedCmp3', 'AcceptedCmp4', 'AcceptedCmp5', 'Z_Revenue', 'Z_CostContact'], axis=1)

#Lets scale the columns so they can give better results in ML model
from sklearn.preprocessing import MinMaxScaler

scaler = MinMaxScaler()

df[['Income', 'Customer_Age', 'Recency', 'MntWines', 'MntFruits']] = scaler.fit_transform(df[['Income', 'Customer_Age', 'Recency', 'MntWines', 'MntFruits']])

df.columns.values

df[['MntMeatProducts', 'MntFishProducts', 'MntSweetProducts', 'MntGoldProds', 'NumDealsPurchases', 'NumWebPurchases', 'NumCatalogPurchases', 'NumStorePurchases', 'NumWebVisitsMonth']] = scaler.fit_transform(df[['MntMeatProducts', 'MntFishProducts', 'MntSweetProducts', 'MntGoldProds', 'NumDealsPurchases', 'NumWebPurchases', 'NumCatalogPurchases', 'NumStorePurchases', 'NumWebVisitsMonth']])

#Data Set is now ready to build model on

#Lets use the hold out method and hold out 40% of the data for the test set
from sklearn.model_selection import train_test_split

train,test =train_test_split(df, test_size=0.4)

X_train = train.drop("Response", axis=1)
Y_train = train["Response"]
X_test  = test.drop("Response", axis=1)

#Logistic regression model
from sklearn.linear_model import LogisticRegression

logreg = LogisticRegression()
logreg.fit(X_train, Y_train)
Y_pred1 = logreg.predict(X_test)
acc_log = round(logreg.score(X_train, Y_train) * 100, 2)

print("The accuracy of logistic regression classifier is:", acc_log)

#These are the predictions made on the test data by logistic regression classifier
print(Y_pred1)

from sklearn.ensemble import RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier


random_forest = RandomForestClassifier(n_estimators=100)
random_forest.fit(X_train, Y_train)
Y_pred2 = random_forest.predict(X_test)
random_forest.score(X_train, Y_train)
acc_random_forest = round(random_forest.score(X_train, Y_train) * 100, 2)


knn = KNeighborsClassifier(n_neighbors = 3) 
knn.fit(X_train, Y_train)  
Y_pred3 = knn.predict(X_test)  
acc_knn = round(knn.score(X_train, Y_train) * 100, 2)

decision_tree = DecisionTreeClassifier() 
decision_tree.fit(X_train, Y_train) 
Y_pred4 = decision_tree.predict(X_test)  
acc_decision_tree = round(decision_tree.score(X_train, Y_train) * 100, 2)

#Lets compare accuarcy of these mdoels

results = pd.DataFrame({
    'Model': ['KNN', 'Logistic Regression','Random Forest','Decision Tree'],
    'Score': [acc_knn, acc_log,acc_random_forest,acc_decision_tree]})
result_df = results.sort_values(by='Score', ascending=False)
result_df = result_df.set_index('Score')
result_df

#Random forsest and decision trees are giving a high accuracy of 99.63 but this
#maybe due to overfitting the data as decsion trees are prone to overfitting
#The random forest maybe getting too large and too complex and this high accuracy
#could be due to overfitting as well.
#So lets decide between the logistic regression model and KNN model.
#Also these 2 are a good choice for selection because KNN is a model that tends to have high varaiance (tends to overfit)
#and logistic regression is a model that tends to have high bias(tends to underfit)
df['Response'].value_counts()

#There are 1902 no's and 331 yes's in the target varaible, response. 
#Hence this is a very imbalanced data set, accuracy is a not a very good performace
#metric for imbalanced data sets and other metrics such as specificity and sensitivity will need a look into.

#Lets look at the specificity and sensitivity of logistic regression model
from sklearn.metrics import confusion_matrix

cm1 = confusion_matrix(test['Response'], Y_pred1)

print('Confusion Matrix 1 : \n', cm1)

total1=sum(sum(cm1))
#from confusion matrix calculate accuracy
accuracy1=(cm1[0,0]+cm1[1,1])/total1
print ('Accuracy : ', accuracy1)

sensitivity1 = cm1[0,0]/(cm1[0,0]+cm1[0,1])
print('Sensitivity : ', sensitivity1 )

specificity1 = cm1[1,1]/(cm1[1,0]+cm1[1,1])
print('Specificity : ', specificity1)

#Sensitivity is also called the true positive rate, the proportion of positive tuples correctly identified
#Specificity is also called the true negative rate, the proportion of neagtive tuples correcly identified
#Hence, this model is giving us a high sensitivity 0.98 but a low specificity of 0.19.
#This means this classifier is classifying the case where there is a response from the customer very well
#BUt not so good at classifier when the response is no
#But for our situation this is not good, as we really want to find the people who will respond no very well
#so we can identify them better and take certain action to increasse their chances of response and 
#hence the business revenue. 
#We need to find a model with higher specificity for our situation

#Lets look at the specificity and sensitivity of  KNN model
cm2 = confusion_matrix(test['Response'], Y_pred3)

print('Confusion Matrix 2 : \n', cm2)

total2=sum(sum(cm2))
#from confusion matrix calculate accuracy
accuracy2=(cm2[0,0]+cm2[1,1])/total2
print ('Accuracy : ', accuracy2)

sensitivity2 = cm2[0,0]/(cm2[0,0]+cm2[0,1])
print('Sensitivity : ', sensitivity2 )

specificity2 = cm2[1,1]/(cm2[1,0]+cm2[1,1])
print('Specificity : ', specificity2)

#Doing the same for the KNN classifier above, we actually get a lower specificity. We need another way to chose our model.

#An ROC curve plots sensitivity and 1-specificity to show how well the classifier is working, in the case of our
#imbalanced data set, this is a good thing to look at:

Y_actual = test['Response']

r_probs = [0 for _ in range(len(Y_actual))]
knn_probs = knn.predict_proba(X_test)
logreg_probs = logreg.predict_proba(X_test)

knn_probs = knn_probs[:, 1]
logreg_probs = logreg_probs[:, 1]

import matplotlib.pyplot as plt
from sklearn.metrics import roc_curve, roc_auc_score

r_auc= roc_auc_score(Y_actual, r_probs)
knn_auc = roc_auc_score(Y_actual, knn_probs)
logreg_auc = roc_auc_score(Y_actual, logreg_probs)

print('Random (chance) Prediction: AUROC = %.3f' % (r_auc))
print('KNN: AUROC = %.3f' % (knn_auc))
print('Logistic Regression: AUROC = %.3f' % (logreg_auc))

r_fpr, r_tpr, _ = roc_curve(Y_actual, r_probs)
knn_fpr, knn_tpr, _ = roc_curve(Y_actual, knn_probs)
logreg_fpr, logreg_tpr, _ = roc_curve(Y_actual, logreg_probs)

plt.plot(r_fpr, r_tpr, linestyle='--', label='Random prediction (AUROC = %0.3f)' % r_auc)
plt.plot(knn_fpr, knn_tpr, marker='.', label='KNN (AUROC = %0.3f)' % knn_auc)
plt.plot(logreg_fpr, logreg_tpr, marker='.', label='Logistic Regression (AUROC = %0.3f)' % logreg_auc)

# Title
plt.title('ROC Plot')
# Axis labels
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
# Show legend
plt.legend() # 
# Show plot
plt.show()

#Random (chance) Prediction: AUROC = 0.500
#KNN: AUROC = 0.638
#Logistic Regression: AUROC = 0.835

#In this case we see that Logistic Regression is the better model to use for our data set as it closer
#to the upper left corner and has a higher AUC of 0.835
#A model with no skill is the dotted diagonal line(AUC = 0.5), hence the the curve that is furthest
#away from this has the higher skilled model and better accuracy

#Initially, we had calculated that KNN had the better accuracy, but accuracy is not a great metric when we have
#class imbalance problem and this is shown through the ROC curve that in fact the better model is Logistic Rregression. 

#Since this is a very imbalanced data set, there could be a lot of error due to that as well.
#Lets try to fix this by oversampling the data set, we will add copies of the under represented class to balamce out the data set.
#We will not undersample and delete tuples of over represented class as there is not much data to begin with, only 2200 or so observations. 

#subset the data frame where the response was yes
df_new = df[(df['Response'] == 1)]

#Copy this data frame to another
df_new1 = df_new

#Randomly shuffle the DataFrame rows 
df_new = df_new.sample(frac = 1)

df_new1 = df_new1.sample(frac = 1)

#Lets combine data sets into one
vertical_stack = pd.concat([df, df_new, df_new1], axis=0)

#Rndomly shyffle this new and larger data frame
vertical_stack = vertical_stack.sample(frac = 1)

vertical_stack['Response'].value_counts()

#The data set is now much less imbalanced as there are 1902 no's and 993 yes's

#Lets check whether this reduction in imbalance results in better performace:
#Also lets change test set size from 0.4 to 0.3

train1,test1 =train_test_split(vertical_stack, test_size=0.3)

X_train1 = train1.drop("Response", axis=1)
Y_train1 = train1["Response"]
X_test1  = test1.drop("Response", axis=1)

Y_actual1 = test1['Response']


logreg1 = LogisticRegression()
logreg1.fit(X_train1, Y_train1)
Y_pred12 = logreg1.predict(X_test1)
acc_log1 = round(logreg1.score(X_train1, Y_train1) * 100, 2)


cm3 = confusion_matrix(Y_actual1, Y_pred12)

print('Confusion Matrix 3 : \n', cm3)

total3=sum(sum(cm3))
#from confusion matrix calculate accuracy
accuracy3=(cm3[0,0]+cm3[1,1])/total3
print ('Accuracy : ', accuracy3)

sensitivity3 = cm3[0,0]/(cm3[0,0]+cm3[0,1])
print('Sensitivity : ', sensitivity3 )

specificity3 = cm3[1,1]/(cm3[1,0]+cm3[1,1])
print('Specificity : ', specificity3)

#The accuracy has decreased, but accuracy doesnt seem to be that great a metric because the data
#set is still imbalanced, hence specificity is the thing to look at and that has gone up to 0.57 from 0.19
# Also since we need a model with higher specificity for our situation, this means
#that correcting the imbalance has worked and increasing the size of the training set has worked
#as the specificity is now higher. This confirms that we should use the logistic regression model
#on our data due to the findngs from the ROC curve and use this model with a more
#balanced data set and a larger training set to get the optimal classification results.

#-------END--------------










