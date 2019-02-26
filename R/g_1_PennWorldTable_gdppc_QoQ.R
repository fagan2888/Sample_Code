# File name: g_1_PennWorldTable_gdppc_QoQ
# Description: Calculate population growth rate and GDP growth rate using
#              constant samples between two periods.
# Author: Shijie Shi
# Last updated: 08/06/2018

rm(list = ls())
library(xlsx)
library(foreign)
setwd("R:/Shi/Project_AK's book update_CollapseAndRevival/output")

calc_gr <- function( inFile, outFile, gap)  { # need to get qoq, gap = 1
    
    df <- read.csv( inFile )
    df <- df[, -1]
    
    vdf <- !is.na(df)
    v <- vdf
    v [v==1] = 0 
    
    col =  dim(outFile)[2]
    
    nloop <- dim(df)[[2]]
    
    for ( i in 1 : nloop ) {
        if ( i-gap>=1 ) { #make sure i-gap is within the bound of v0
            v[, i] = vdf[,i] * vdf[,i-gap] 
        }
    }
    
    for ( i in 1 : gap) {
        v[, i] = v[, i+gap]
    }   
    
    for ( i in 1 : nloop ) {
        outFile[i, col + 1] = sum(v[, i])
    }
    
    for ( i in 1 : nloop ) {
        
        if ( i-gap>=1 ) {
            gr = sum( df[, i] * v[, i], na.rm = TRUE ) /
                 sum( df[, i-gap] * v[, i], na.rm = TRUE ) - 1

            outFile[i, col + 2] = gr * 100
        }
        
    }
    
    return(outFile)
    
}  


calc_gr_weight <- function( inFile, inFile_weight, outFile, gap)  { # need to get qoq, gap = 1
    
    df1 <- read.csv( inFile )
    df1 <- df1[, -1]
    
    df2 <- read.csv( inFile_weight )
    df2 <- df2[, -1]
    
    v1 <- !is.na(df1)
    v2 <- !is.na(df2)
    
    v <- v1
    v [v==1] = 0

    col =  dim(outFile)[2]
    
    nloop <- dim(df1)[[2]] # equal to dim(df2)[[2]]
    
    for ( i in 1 : nloop ) {
        if ( i-gap>=1 ) { #make sure i-gap is within the bound
            v[, i] = v1[,i]  * v1[,i-gap] * v2[,i] * v2[,i-gap] 
        }
    }
    
    for ( i in 1 : gap) {
        v[, i] = v[, i+gap]
    }  
    
    for ( i in 1 : nloop ) {
        outFile[i, col + 1] = sum(v[, i])
    }
    
    for ( i in 1 : nloop ) {
        
        if ( i-gap>=1 ) {
            value = ( df1[, i] * v[ , i] ) / ( df1[, i-gap] * v[ , i] ) - 1
            weight = df2[, i] *  v[ , i]
            outFile[i, col+2] = weighted.mean(value, weight, na.rm = TRUE) * 100
        }
        
    }
    
    return (outFile)
}




# Construct a data frame to store results

results <- data.frame( matrix( ncol = 1 ) )
names(results) <- c("Date")

row = 1
for ( i in 1960:2018 ) {
    for ( j in 1:4){
        results[row, 1] = paste(i, j, sep = "Q")
        row = row + 1
    }
}

#   World
results <- calc_gr("pop_PWT.csv", results, 1)
results <- calc_gr_weight("gdp.csv", "pppwgt_PWT.csv", results, 1)
names(results) <- c("Date", "pop_count", "pop_gr_a", "gdp_count", "gdp_gr_q")
name <- names(results)

write.dta(results, "g_1_PennWorldTrade_gdppc_QoQ_201902.dta") 
