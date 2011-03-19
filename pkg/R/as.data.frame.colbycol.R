#################################################################
# 
# File:         as.data.frame.colbycol.R
# Purpose:      converts a colbycol object into a data.frame
#
# Created:      20110319
# Author:       Carlos J. Gil Bellosta
#
# Modifications: 
#
#################################################################

as.data.frame.colbycol <- function( data, columns = NULL, rows = NULL ) 
{
    if( ! is.null( rows ) ) {
        if( ! is.numeric( rows ) )
            stop( "A numeric vector of wanted rows is required for the rows argument" )

        rows <- as.integer( rows )
        rows <- rows[ rows > 0 ]
        rows <- rows[ rows < nrow( data ) ]

        if( length( rows ) == 0 ) 
            stop( "No rows were found to be extracted" )
    }

    cols.to.extract <- 1:ncol( data )

    if( ! is.null( columns ) ){
        if( is.character( columns ) )
            columns <- which( colnames( data ) %in% columns )
        if( is.numeric( columns ) )
            columns <- intersect( columns, 1:ncol( data ) )
        if( !is.numeric( columns ) )
            stop( "Either the column indexes or the column names of the colbycol object should be provided in the columns argument" )

        cols.to.extract <- columns
    }

    foo <- function( column.index ){
        tmp <- cbc.get.col( data, column.index )
        if( !is.null( rows ) )
            tmp <- tmp[ rows ]
        gc()
        tmp
    }

    tmp <- do.call( data.frame, sapply( cols.to.extract, foo, simplify = FALSE ) )
    gc()
    colnames( tmp ) <- colnames( data )[ cols.to.extract ]
    tmp
}
