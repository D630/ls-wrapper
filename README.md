Some shell subroutines to wrap up the POSIX ls command and to track all directory contents via txt files in a separat file hierarchy.

The only non-POSIX option is `h` (human-readable), which appears in `GNU`, `FreeBSD`, `OpenBSD` and `MacOSX` versions of ls. Color support is also not specified by POSIX, but is available in this wrapper via the environment variable `LS_COLOR`; it depends on the ls version.

```
Usage
    [ <evar> ... ] Ls::Do [ <ls-opt> ... ]  Wrap up ls and track directory
                                            content
    Ls::FindInode <ARG1> <path> <inum>      Find file in a directory via inode
                                            number and get its basename
    Ls::GetChecksum <ARG1>                  Create checksum of the ls-wrapper
                                            environment
    Ls::GetInode <ARG1> <path>              Get the inode number of a file
    Ls::RemoveColor                         Remove all ANSI color codes from
                                            stdin
    Ls::SetAliases [ <ARG1> <fname> ]       Determine the ls command and create
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
            Default: 'Ls::GetChecksum :'
    LS_CHECKSUM_COMMAND=STR
            Default: 'md5sum'
    LS_COLOR=0/1
            Default: 0
    LS_DIR_NAME=STR
            Default: '${TMPDIR:-/tmp}/ls'
    LS_FILE_INODE=STR
            Default: 'Ls::GetInode : "$ls_file_name"'
    LS_FILE_NAME=STR
            Default: '${PWD:-.}'
    LS_FLAG_{A,C,F,H,L,R,S,a,c,d,f,g,h,i,k,l,m,n,o,p,q,r,s,t,u,x,1}=0/1
            Default: 0
    LS_HOOK_POST=FNAME
            Default: null
    LS_HOOK_TEE=0/1
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
    The order of the relevant environment variables to calculate the
    checksum is:
    'printf "%s\n" COLUMNS LANG LC_{ALLL,COLLATE,CTYPE,MESSAGES,TIME} \
        NLSPATH TZ LS_{COLOR,FILE_INODE} \
        LS_FLAG_{A,C,F,H,L,R,S,a,c,d,f,g,h,i,k,l,m,n,o,p,q,r,s,t,u,x,1}'

Hook order
    ( LS_HOOK_PRAE && LS_HOOK_POST ) || LS_HOOK_PRAE || LS_HOOK_POST

    That is:
        LS_HOOK_PRAE | Ls::Perform | LS_HOOK_POST
        LS_HOOK_PRAE | Ls::Perform
        Ls::Perform | LS_HOOK_POST
Notes
    If LS_REMOVE is not 0, the file with LS_CHECKSUM will be removed from the file
    hierarchy.
```
