#################################################################
# 
# File:         cbc.read.table
# Purpose:      Read a large file and process it column by column
#
# Created:      20090506
# Author:       Carlos J. Gil Bellosta
#
# Modifications: 
#
#################################################################

cbc.read.table <- function( file, tmp.dir = tempfile( pattern = "dir" ), sep = "\t", header = TRUE, ... )
{
    if( ! file.exists( file ) )
        stop("Missing input file.")

    if( file.exists( file.path( getwd(), file ) ) )         # It was a relative path
        file <- file.path( getwd(), file )

    if( ! file.exists( tmp.dir ) && ! dir.create( tmp.dir, recursive = TRUE )  )
        stop("The destination directory cannot be either found or created.")

    original.dir <- getwd()
    on.exit( setwd( original.dir ) )

    setwd( tmp.dir )

    if( length( dir() > 0 ) )
        stop("The destination directory is not empty.")

    tmp.data <- read.table( file, nrows = 50, sep = sep, header = header, ... )

    columns <- sapply( 1:ncol( tmp.data ), function( i ) list( filename = formatC( i, width = 4, flag = "0" )), simplify = FALSE )
    names( columns ) <- colnames( tmp.data )

    if( !exists( "skip", mode = "numeric" ) )
        skip <- 0

    skip <- skip + header

    cat( "filename | ", file, "\n", file = ".delete" )
    cat( "sep      : ", sep, "\n",  file = ".delete", append = TRUE )
    cat( "skip     : ", skip, "\n", file = ".delete", append = TRUE )
    cat( "files    : ", paste( lapply( columns, function(x) x$filename ), collapse = ";" ), "\n", file = ".delete", append = TRUE )

    ret.val <- system( paste( "python", system.file("python", "colbycol.py", package = "colbycol"), getwd() ) ) 

    if( ret.val ){
        cat( "\n" )
        cat( "Error in external call to python.\n")
        cat( "The most likely cause is that python is not properly configured in your system. In such case:\n" )
        cat( "  If you are on a UNIX-like platform, make sure that python is installed and on your path.\n" )
        cat( "  If you are on Windows, you may have to:\n" )
        cat( "     Install python, if not on your system.\n" )
        cat( "     Configure the path environment variable to make it directly callable from R. You may want\n" )
        cat( "        to check http://support.microsoft.com/kb/310519\n" )
        cat( "\n" )
    }

    file.remove( ".delete" )

    for( column in names(columns) ){
        tmp <- read.table( columns[[column]]$filename, sep = sep, na.strings = "", comment.char = "", quote = "", header = FALSE, ... )[,1]
        columns[[column]] <- c( columns[[column]], list( class = class( tmp ) ) )
        save( tmp, file = columns[[column]]$filename )
        nrows <- length( tmp )
        rm( tmp )
        gc()
    }

    tmp <- list( filename = file, tmp.dir = tmp.dir, columns = columns, nrows = nrows )
    class( tmp ) <- "colbycol"
    tmp

}
