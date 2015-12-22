Some shell subroutines to wrap up the POSIX ls command and to track all directory contents via txt files in a separat file hierarchy.

The only non-POSIX option is `h` (human-readable), which appears in `GNU`, `FreeBSD`, `OpenBSD` and `MacOSX` versions of ls. Color support is also not specified by POSIX, but is available in this wrapper via the environment variable `LSW_COLOR`; it depends on the ls version.

```
Usage
    [ <evar> ... ] LsW::Do [ <ls-opt> ... ]  Wrap up ls and track directory
                                             content
    LsW::FindInode <ARG1> <path> <inum>      Find file in a directory via inode
                                             number and get its basename
    LsW::GetChecksum <ARG1>                  Create checksum of the ls-wrapper
                                             environment
    LsW::GetInode <ARG1> <path>              Get the inode number of a file
    LsW::RemoveColor                         Remove all ANSI color codes from
                                             stdin
    LsW::SetAliases [ <ARG1> <fname> ]       Determine the ls command and create
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
                                            specification. See evars LSW_FLAG_*
    <name>                                  Name of the variable to have the
                                            result in store
    <path>                                  Path name

Environment variables
    LSW_CHECKSUM=STR
            Default: 'LsW::GetChecksum :'
    LSW_CHECKSUM_COMMAND=STR
            Default: 'md5sum'
    LSW_COLOR=0/1
            Default: 0
    LSW_DIR_NAME=STR
            Default: '${TMPDIR:-/tmp}/ls'
    LSW_FILE_INODE=STR
            Default: 'LsW::GetInode : "$lsw_file_name"'
    LSW_FILE_NAME=STR
            Default: '${PWD:-.}'
    LSW_FLAG_{A,C,F,H,L,R,S,a,c,d,f,g,h,i,k,l,m,n,o,p,q,r,s,t,u,x,1}=0/1
            Default: 0
    LSW_HOOK_POST=FNAME
            Default: null
    LSW_HOOK_TEE=0/1
            Default: 0
    LSW_HOOK_PRAE=FNAME
            Default: null
    LSW_MKDIR_COMMAND=STR
            Default: 'mkdir -p'
    LSW_PRINT_COMMAND=STR
            Default: 'cat'
    LSW_REMOVE=0/1
            Default: 0

Hierarchy
    Content will be stored in "${LSW_DIR_NAME}/${LSW_FILE_INODE}/${LSW_CHECKSUM}"

Checksum
    The order of the relevant environment variables to calculate the
    checksum is:
    'printf "%s\n" COLUMNS LANG LC_{ALLL,COLLATE,CTYPE,MESSAGES,TIME} \
        NLSPATH TZ LSW_{COLOR,FILE_INODE} \
        LSW_FLAG_{A,C,F,H,L,R,S,a,c,d,f,g,h,i,k,l,m,n,o,p,q,r,s,t,u,x,1}'

Hook order
    ( LSW_HOOK_PRAE && LSW_HOOK_POST ) || LSW_HOOK_PRAE || LSW_HOOK_POST

    That is:
        LSW_HOOK_PRAE | LsW::Perform | LSW_HOOK_POST
        LSW_HOOK_PRAE | LsW::Perform
        LsW::Perform | LSW_HOOK_POST
Notes
    If LSW_REMOVE is not 0, the file with LSW_CHECKSUM will be removed from the file
    hierarchy.
```
