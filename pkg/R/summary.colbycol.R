#################################################################
# 
# File:         summary.colbycol.r
# Purpose:      provides a short summary of a colbycol objetct
#
# Created:      20110319
# Author:       Carlos J. Gil Bellosta
#
# Modifications: 
#
#################################################################

summary.colbycol <- function( x )
{
    if( class( x ) != "colbycol" )
        stop("An object of class colbycol is required.")

    cat( paste( "Object of class colbycol with ", nrow( x ), " rows and ", ncol( x ), " columns.\n", sep = "" ) )
    cat( paste( "Data for the object is stored at ", x$tmp.dir, ".\n", sep = "" ) )
}
