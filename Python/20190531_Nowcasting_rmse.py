# -*- coding: utf-8 -*-
"""
Created on Wed May 30 09:30:23 2019

@author: WB531948
"""

import statsmodels.api as sm
import numpy as np
import pandas as pd
import math
import matplotlib.pylab as plt
from collections import OrderedDict

# @param: y: gdp_g, quarterly
#         x: a macro indicator, monthly
# Return: dataframe
def get_reg_df(x, y = "gdp_g"):
    y_q_lag1 = df[y].shift(3) 
    if x == "gdp_g":
        dic_reg = {'y': df[y], 'y_q_lag1': y_q_lag1}        
    else:     
        x_m_lag1 = df[x].shift(0)
        x_m_lag2 = df[x].shift(1)
        x_m_lag3 = df[x].shift(2)    
        dic_reg = {'y': df[y], 'y_q_lag1': y_q_lag1, 'x_m_lag1': x_m_lag1, 
                               'x_m_lag2': x_m_lag2, 'x_m_lag3': x_m_lag3}
    df_reg = pd.DataFrame(dic_reg)
    df_reg.dropna(inplace=True)
    return df_reg

# @param: dataframe for regression
# Return: regression result
def reg(df): 
    y = df['y']
    x_names = df.columns.values.tolist()
    x_names.remove('y')
    X = df[x_names]
    X = sm.add_constant(X) 
    return sm.OLS(y, X).fit() 

# @param: regression result
# Return: float, rmse
def get_rmse(model): 
    return math.sqrt(model.mse_resid)

# @param: regression result
# Return: float, radj
def get_radj(model): 
    return model.rsquared_adj

# @param: dictionary of regression results
# Return: histogram
def plot_attr(dic_attr): 
    dic_attr_ordered = OrderedDict(sorted(dic_attr.items(), 
                                          key = lambda x: x[1], reverse= True))
    plt.bar(dic_attr_ordered.keys(), dic_attr_ordered.values())
    
    
date = "20190503"
projFolder = "R:/Shi/Project_Nowcasting/output/"

path_df = projFolder + date + "/" + date + "_data.xlsx"
df = pd.read_excel(path_df, index_col = 0) 


dic_rmse = {}
dic_radj = {}

df_reg = {}
for colomn in df:
    df_reg = get_reg_df(colomn)
    model = reg(df_reg) 
    rmse = get_rmse(model)
    radj = get_radj(model)
    dic_rmse.update({colomn: rmse})
    dic_radj.update({colomn: radj})

plot_attr(dic_rmse)
plt.show()
plot_attr(dic_radj)
plt.show()


#for attr in dir(model):
#    if not attr.startswith('_'):
#        print(attr)