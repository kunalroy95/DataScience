#Customer churn prediction using an Artificial Neural Network with 2 hidden layers

import pandas as pd

df = pd.read_csv('Churn_Modelling.csv')

#check missing values in columns
df.isnull().sum()

df = df.drop(["RowNumber", "CustomerId", "Surname"], axis = 1)

df['Gender'].value_counts()

#encode the categorical variables
countries = {"France": 0, "Germany": 1, "Spain": 2}
data = [df]
for dataset in data:
    dataset['Geography'] = dataset['Geography'].map(countries)
    
gender = {"Male": 0, "Female": 1}
data = [df]
for dataset in data:
    dataset['Gender'] = dataset['Gender'].map(gender)
    
from sklearn.model_selection import train_test_split

train,test =train_test_split(df, test_size=0.3)

X_train = train.drop("Exited", axis=1)
Y_train = train["Exited"]
X_test  = test.drop("Exited", axis=1)
Y_test = test["Exited"]


import torch
import torch.nn as nn
import torch.nn.functional as F

#Crearing tensors

#Have to convert data into tensors for input into NN

X_train = torch.tensor(X_train.values)

X_test = torch.tensor(X_test.values)

Y_train = torch.tensor(Y_train.values)

Y_test = torch.tensor(Y_test.values)

X_train.dtype
#The tensors are of type float, which is what we need our input features to be

# Creating model
#The first function in the class ANN_Module is defining the structure of a artificial
#neural network as it has input layer, multiple hidden layers and output layer.
#within that funnction, it is taking a linear combination of the data points and weights and
#inputing them into a relu activation fucntion which then gets converted into an output
#(This is part of the forward function in the class)

class ANN_Model(nn.Module):
    def __init__(self,input_features=10,hidden1=20,hidden2=20,out_features=2):
        super().__init__()
        self.f_connected1=nn.Linear(input_features,hidden1)
        self.f_connected2=nn.Linear(hidden1,hidden2)
        self.out=nn.Linear(hidden2,out_features)
    def forward(self,x):
        x=F.relu(self.f_connected1(x))
        x=F.relu(self.f_connected2(x))
        x=self.out(x)
        return x
    
#instantiate my ANN_model
torch.manual_seed(20)
model=ANN_Model()

model.parameters

#Backward Propogation-- Define the loss_function,define the optimizer
loss_function=nn.CrossEntropyLoss()
optimizer=torch.optim.Adam(model.parameters(),lr=0.01)

#The back propogation process is basically taking the gradient of the loss function and then subtracting that
#infintesimal loss from the weights to minimzie the overall loss and then updating the weight paramter
#at every iteration
epochs=500
final_losses=[]
for i in range(epochs):
    i=i+1
    y_pred=model.forward(X_train.float())
    loss=loss_function(y_pred,Y_train)
    final_losses.append(loss)
    if i%10==1:
        print("Epoch number: {} and the loss : {}".format(i,loss.item()))
    optimizer.zero_grad()
    loss.backward()
    optimizer.step()
    
# plot the loss function
import matplotlib.pyplot as plt
%matplotlib inline

plt.plot(range(epochs),final_losses)
plt.ylabel('Loss')
plt.xlabel('Epoch')
#We can see that the loss function has a desired shape of it decreasing and then reaching some limit

#Prediction of test data
predictions = []
with torch.no_grad():
    for i, data in enumerate(X_test.double()):
      Y_pred = model.double()(data)
      predictions.append(Y_pred.argmax().item())
      print(Y_pred.argmax().item())
    
#Now we have a list of predictions
predictions

#Lets look at how well the classifier is working
from sklearn.metrics import confusion_matrix
cm=confusion_matrix(Y_test,predictions)
cm

import seaborn as sns
plt.figure(figsize=(10,6))
sns.heatmap(cm,annot=True)
plt.xlabel('Actual Values')
plt.ylabel('Predicted Values')

from sklearn.metrics import accuracy_score
score=accuracy_score(Y_test,predictions)
score
#accuracy is 60%

#I will now save the model
torch.save(model,'churn.pt')

#Lets load the model
model=torch.load('churn.pt')

model.eval()

#Prediction of new data point

#lets slice the data frame and make a list and then convert to tensor
list(df.iloc[0,:-1])

list1 = [619.0, 0.0, 1.0, 42.0, 2.0, 0.0, 1.0, 1.0, 1.0, 101348.88]

new_data = torch.tensor(list1)

with torch.no_grad():
    print(model(new_data))
    print(model.float()(new_data.float()).argmax().item())
    
#For this particular tuple, the customer did not exit. 
    
#Ways to improve accuarcy of this NN:
    #Increase the number of hidden layers
    #Change activation function, for hidden layers, maybe it is better to use non linear activation function
    #The weight initialization is random so maybe that did not work out well, can do a more optimal weight intialization(Change the random seed)
    #Add more data, only 7000 observations in the traininhg set
    #Scale/normalize the data
    #Change learning rate alpha paarmeter, can chnage it from 0.01 to 0.9(if learning rate is too small, it will require too mant epochs to converge)
    #Change the number of epochs
    











    

    





