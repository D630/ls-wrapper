Some shell subroutines to wrap up the POSIX ls command and to track all directory contents via txt files in a separat file hierarchy.

The only non-POSIX argument in this wrapper is `h` (human-readable), which appears in `GNU`, `FreeBSD`, `OpenBSD` and `MacOSX` versions of ls. Color support is also not specified by POSIX, but is available via the environment variable `LSW_COLOR`; it depends on the ls version.

```
Usage
    [ <EVAR> ... ] \
    LsW::Do \
    [ <LSOPT> ... ] \
    [ -- <PATH> ]                           Wrap up ls and track directory
                                            content
    LsW::FindInode <ARG1> <PATH> <INUM>     Find file in a directory via inode
                                            number and get its basename
    LsW::GetInode <ARG1> <PATH>             Get the device and inode number of
                                            a file, separated by newline
    LsW::RemoveColor                        Remove all ANSI color codes from
                                            stdin
    LsW::SetLsOs                            Determine the ls command and
                                            declare the wrapper functions
                                            '__ls' and '__ls_color'
                                            (depends on the OS)

Arguments
    :                                       Print the result to stdout
    <ARG1>                                  ( : | <NAME> )
    <EVAR>                                  Environment variable
    <FNAME>                                 Function name. May be any declared
                                            name
    <INUM>                                  Inode number
    <LSOPT>                                 Any option in the POSIX ls
                                            specification. See evars LSW_FLAG_*
    <NAME>                                  Name of the variable to have the
                                            result in store
    <PATH>                                  Path name

Environment variables
    LSW_CHECKSUM=STR
            Default: 'LsW::GetChecksum :'
    LSW_CHECKSUM_COMMAND=STR
            Default: 'md5sum'
    LSW_COLOR=0/1
            Default: 0
    LSW_DIR_DEVICE=STR
            Default: 'LsW::GetInode i "$lsw_file_name" ; builtin printf '%d\n' "${i[0]}")}'
    LSW_DIR_NAME=STR
            Default: '${TMPDIR:-/tmp}/lsW'
    LSW_FILE_INODE=STR
            Default: 'LsW::GetInode i "$lsw_file_name" ; builtin printf '%d\n' "${i[1]}")}'
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
    Content will be stored in "${LSW_DIR_NAME}/${LSW_FILE_DEVICE}/${LSW_FILE_INODE}/${LSW_CHECKSUM}"

Checksum
    The order of the relevant environment variables to calculate the
    checksum is:
    'printf "%s\n" COLUMNS LANG LC_{ALLL,COLLATE,CTYPE,MESSAGES,TIME} \
        NLSPATH TZ LSW_{COLOR,FILE_DEVICE,FILE_INODE} \
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
