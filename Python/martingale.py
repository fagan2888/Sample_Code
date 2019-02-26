"""Assess a betting strategy. 			  		 			     			  	   		   	  			  	
 			  		 			     			  	   		   	  			  	
Copyright 2018, Georgia Institute of Technology (Georgia Tech) 			  		 			     			  	   		   	  			  	
Atlanta, Georgia 30332 			  		 			     			  	   		   	  			  	
All Rights Reserved 			  		 			     			  	   		   	  			  	
 			  		 			     			  	   		   	  			  	
Template code for CS 4646/7646 			  		 			     			  	   		   	  			  	
 			  		 			     			  	   		   	  			  	
Georgia Tech asserts copyright ownership of this template and all derivative 			  		 			     			  	   		   	  			  	
works, including solutions to the projects assigned in this course. Students 			  		 			     			  	   		   	  			  	
and other users of this template code are advised not to share it with others 			  		 			     			  	   		   	  			  	
or to make it available on publicly viewable websites including repositories 			  		 			     			  	   		   	  			  	
such as github and gitlab.  This copyright statement should not be removed 			  		 			     			  	   		   	  			  	
or edited. 			  		 			     			  	   		   	  			  	
 			  		 			     			  	   		   	  			  	
We do grant permission to share solutions privately with non-students such 			  		 			     			  	   		   	  			  	
as potential employers. However, sharing with other current or future 			  		 			     			  	   		   	  			  	
students of CS 7646 is prohibited and subject to being investigated as a 			  		 			     			  	   		   	  			  	
GT honor code violation. 			  		 			     			  	   		   	  			  	
 			  		 			     			  	   		   	  			  	
-----do not edit anything above this line--- 			  		 			     			  	   		   	  			  	
 			  		 			     			  	   		   	  			  	
Student Name: Tucker Balch (replace with your name) 			  		 			     			  	   		   	  			  	
GT User ID: sshi48 (replace with your User ID) 			  		 			     			  	   		   	  			  	
GT ID: 902860768 (replace with your GT ID) 			  		 			     			  	   		   	  			  	
""" 			  		 			     			  	   		   	  			  	
 			  		 			     			  	   		   	  			  	
import numpy as np 		  		 			     			  	   		   	  			  	
 			  		 			     			  	   		   	  			  	
def author():
    return 'sshi48' # replace tb34 with your Georgia Tech username. 			  		 			     			  	   		   	  			  	
 			  		 			     			  	   		   	  			  	
def gtid():
    return 902860768 # replace with your GT ID number 			  		 			     			  	   		   	  			  	
 			  		 			     			  	   		   	  			  	
def get_spin_result(win_prob):
    result = False
    if np.random.random() <= win_prob: 			  		 			     			  	   		   	  			  	
		result = True
    return result 			  		 			     			  	   		   	  			  	
 			  		 			     			  	   		   	  			  	
def nolimit(winnings):
    win_prob = 0.47 # set appropriately to the probability of a win
    #np.random.seed(gtid()) # do this only once
    #print get_spin_result(win_prob) # test the roulette spin
    
    #add your code here to implement the experiments
    i = 0 
    winnings.append(0)
    
    while winnings[i] < 80 and i <=1000:      
        won = False
        bet_amount = 1
        while won == False and i <=1000:
            won = get_spin_result(win_prob)
            i = i + 1
            if won == True:
                winnings1.append( winnings[i-1] + bet_amount )
            else:
                winnings1.append( winnings[i-1] - bet_amount )
                bet_amount = bet_amount * 2  
    
    if i < 1000:
        for j in range(i, 1000):
            winnings.append(80)
            j = j + 1


def limit(winnings):
    win_prob = 0.47
    i = 0 
    winnings.append(0)
    
    while winnings[i] < 80 and winnings[i] > -256 and i <=1000:      
        won = False
        bet_amount = 1
        
        while won == False and winnings[i] > -256 and i <=1000:
            won = get_spin_result(win_prob)
            i = i + 1
            if won == True:
                winnings.append( winnings[i-1] + bet_amount )
            else:
                winnings.append( winnings[i-1] - bet_amount )
                bet_amount = min( bet_amount * 2, 256 + winnings[i] )   

    if i < 1000:
        for j in range(i, 1000):
            winnings.append(winnings[i])
            j = j + 1       
    	 			     			  	   		   	  			  		  		 			     			  	   		   	  			  	
if __name__ == "__main__":
    winnings1 = []
    winnings2 = []
    
    nolimit(winnings1)
    limit(winnings2)
    
    print winnings1
    print winnings2

      		 			     			  	   		   	  			  	

