Some shell subroutines to wrap up the POSIX ls command and to track all directory contents via txt files in a separat file hierarchy.

```
Usage
    [ <evar> ... ] __ls_do [ <ls-opt> ]     Wrap up ls and track directory
                                            content
    __ls_find_inode <ARG1> <path> <inum>    Find file in a directory via inode
                                            number and get its basename
    __ls_get_checksum <ARG1>                Create checksum of the ls-wrapper
                                            environment
    __ls_get_inode <ARG1> <path>            Get the inode number of a file
    __ls_remove_color                       Remove all ANSI color codes from
                                            stdin
    __ls_set_aliases [ <ARG1> <fname> ]     Determine the ls command and create
                                            the wrapper functions '__ls' and
                                            '__ls_color' (depends on the OS)

Arguments
    :                                       Print the result to stdout
    <ARG1>                                  ( : | <name> )
    <evar>                                  Environment variable
    <fname>                                 Function name. May be any declared
                                            name; used to get the definition of
                                            '__ls' and '__ls_color'
    <inum>                                  Inode number
    <ls-opt>                                Any option in the POSIX ls
                                            specification. See evars LS_FLAG_*
    <name>                                  Name of the variable to have the
                                            result in store
    <path>                                  Path name

Environment variables
    LS_CHECKSUM=STR
            Default: '__ls_get_checksum :'
    LS_CHECKSUM_COMMAND=STR
            Default: 'md5sum'
    LS_COLOR=0/1
            Default: 0
    LS_DIR_NAME=STR
            Default: '${TMPDIR:-/tmp}/ls'
    LS_FILE_INODE=STR
            Default: '__ls_get_inode : "$ls_file_name"'
    LS_FILE_NAME=STR
            Default: '${PWD:-.}'
    LS_FLAG_{A,C,F,H,L,R,S,a,c,d,f,g,i,k,l,m,n,o,p,q,r,s,t,u,x,1}=0/1
            Default: 0
    LS_HOOK_POST=FNAME
            Default: null
    LS_HOOK_POST_PIPE=FNAME
            Default: null
    LS_HOOK_POST_TEE=0/1
            Default: 0
    LS_HOOK_PRAE=FNAME
            Default: null
    LS_MKDIR_COMMAND=STR
            Default: 'mkdir -p'
    LS_PRINT_COMMAND=STR
            Default: 'cat'
    LS_REMOVE=0/1
            Default: 0

Hierarchy
    Content will be stored in "${LS_DIR_NAME}/${LS_FILE_INODE}/${LS_CHECKSUM}"

Checksum
    The relevant environment variables and their read order to calculate the
    checksum is:
    'printf "%s\n" COLUMNS LANG LC_{ALLL,COLLATE,CTYPE,MESSAGES,TIME} \
        NLSPATH TZ LS_{COLOR,FILE_INODE} \
        LS_FLAG_{A,C,F,H,L,R,S,a,c,d,f,g,i,k,l,m,n,o,p,q,r,s,t,u,x,1}'

Hook order
    ( LS_HOOK_PRAE && LS_HOOK_POST ) || \
    ( LS_HOOK_PRAE && LS_HOOK_POST_PIPE ) ||
    ( LS_HOOK_PRAE && LS_HOOK_POST_TEE ) || \
    LS_HOOK_PRAE || \
    LS_HOOK_POST || \
    LS_HOOK_POST_PIPE || \
    LS_HOOK_POST_TEE
```
