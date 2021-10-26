
import pandas as pd
from scipy.stats import zscore
from sklearn.preprocessing import minmax_scale
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv('bank_data.csv')
df1 = pd.read_csv('bank_data.csv')

#Q1

#statitical summaries of the numerical attributes
df.describe()

#distribution of values of the categorical attributes
df.gender.value_counts()
df.region.value_counts()
df.married.value_counts()
df.car.value_counts()
df.savings_acct.value_counts()
df.current_acct.value_counts()
df.mortgage.value_counts()
df.pep.value_counts()

#Q2

#lets subset the data into people who bought the PEP and didn't
yes_df = df[(df['pep'] == "YES")]

no_df = df[(df['pep'] == "NO")]

#lets compare their statitical summaries
yes_df.describe()

no_df.describe()

#for the people who bought the plan, their mean age is higher at 45 compared to 40 for those who didnt

#for the people who bought the plan, their mean income is higher at 30,645 as compared to 24901 for those who didn't

#Q3

df['income_zscore'] = zscore(df['income'])


#Q4

def age_grp_if(x): 
    if (x < 30) :
        return 'young'
    elif (30 <= x < 50):
        return 'middle age'
    elif(50 <= x):
        return 'old'

df['age_grp'] = df['age'].apply(age_grp_if)


#Q5



df[['income', 'age', 'children']] = minmax_scale(df[['income', 'age', 'children']]) 


#Q6

df_dummies = pd.get_dummies(df, prefix=['gender', 'region', 'married','car', 'savings_acct', 'current_acct', 'mortgage', 'pep'], columns=['gender', 'region', 'married','car', 'savings_acct', 'current_acct', 'mortgage', 'pep'])


df_dummies = df_dummies.drop(columns=['id', 'income_zscore','age_grp'])

df_dummies.to_csv('bank_numeric.csv')

#Q7

#two different kinds of correwlation matrix plots

corr = df_dummies.corr()
ax = sns.heatmap(
    corr, 
    vmin=-1, vmax=1, center=0,
    cmap=sns.diverging_palette(20, 220, n=200),
    square=True
)
ax.set_xticklabels(
    ax.get_xticklabels(),
    rotation=45,
    horizontalalignment='right'
);



correlation_mat = df_dummies.corr()

sns.heatmap(correlation_mat, annot = True)

plt.show()

#Q8

x = df1[['income', 'age']]


x.plot(kind="scatter", x="age", y="income", s=50)

#yes the vaaribles seem strongly correlated, they have a positive correlation, as age goes up, income goes up

#Q9

fig, axs = plt.subplots(1, 1,
                        figsize =(10, 7), 
                        tight_layout = True)
  
axs.hist(df1.income, bins = 10)
  

axs.set_xlabel('Income')
axs.set_ylabel('Frequency')
plt.show()

fig, axa = plt.subplots(1, 1,
                        figsize =(10, 7), 
                        tight_layout = True)
  
axa.hist(df1.age, bins = 14)
  


axa.set_xlabel('Age')
axa.set_ylabel('Frequency')
plt.show()

#Q10

sns.countplot(df1['region'], color='blue')

#Q11

cross_tab = pd.crosstab(df1.region, df.pep)
cross_tab

colors = ["#006D2C", "#31A354","#74C476"]
cross_tab.plot.bar(stacked=True, color=colors, figsize=(10,7))


