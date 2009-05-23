#!/usr/bin/python

import sys
import getopt
import os

def main(argv=None):
    if argv is None:
        argv = sys.argv

    os.chdir( argv[1] )

    conf_data = open( ".delete", "r" ).readlines()

    file_in   = open( conf_data[0].split("|")[1].strip(), "r" )
    sep       = conf_data[1].split(":")[1][2]                       # We cannot "strip" as it would eliminate "white" characters; tricky!!!

    skip      = int( conf_data[2].split(":")[1].strip() )

    files_out = [ open( x.strip(), "w") for x in conf_data[3].split(":")[1].split(";") ]

    cont = 0

    for line in file_in:
        cont += 1
        if cont <= skip:
            continue

        # line = unicode( line, errors = "ignore" )             # It broke compatibility with Python 3.0

        tokens = line.split( sep )

        if len( tokens ) != len( files_out ):
            pass

        for i in range( len( tokens ) ):
            token = tokens[i].strip()
            if token == "":
                token = "NA"
            # files_out[i].write( token.encode("utf8") + "\n" )     # It broke compatibility with Python 3.0
            files_out[i].write( token + "\n" )

    for file_out in files_out:
        file_out.close()

    file_in.close()
            
if __name__ == "__main__":
    sys.exit(main())

