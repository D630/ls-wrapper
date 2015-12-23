#!/usr/bin/env bash

# ls-wrapper
# Copyright (C) 2015 D630, GNU GPLv3
# <https://github.com/D630/ls-wrapper.sh>

# -- DEBUGGING.

#printf '%s (%s)\n' "$BASH_VERSION" "${BASH_VERSINFO[5]}" && exit 0
#set -o xtrace
#exec 2>> ~/ls-wrapper.sh.log
#set -o verbose
#set -o noexec
#set -o errexit
#set -o nounset
#set -o pipefail
#trap '(read -p "[$BASH_SOURCE:$LINENO] $BASH_COMMAND?")' DEBUG

#declare vars_base=$(set -o posix ; set)
#fgrep -v -e "$vars_base" < <(set -o posix ; set) | \
#egrep -v -e "^BASH_REMATCH=" \
#         -e "^OPTIND=" \
#         -e "^REPLY=" \
#         -e "^BASH_LINENO=" \
#         -e "^BASH_SOURCE=" \
#         -e "^FUNCNAME=" | \
#less

# -- FUNCTIONS.

LsW::Build ()
if
        [[ -n $lsw_hook_prae && -n $lsw_hook_post ]]
then
        ${lsw_hook_prae} \
        | LsW::Perform  \
        | ${lsw_hook_post};
elif
        [[ -n $lsw_hook_prae ]]
then
        ${lsw_hook_prae} \
        | LsW::Perform;
elif
        [[ -n $lsw_hook_post ]]
then
        LsW::Perform \
        | ${lsw_hook_post};
else
        LsW::Perform
fi

LsW::Do ()
{
        builtin typeset -i \
                lsw_flag_1= \
                lsw_flag_A= \
                lsw_flag_C= \
                lsw_flag_F= \
                lsw_flag_H= \
                lsw_flag_L= \
                lsw_flag_R= \
                lsw_flag_S= \
                lsw_flag_a= \
                lsw_flag_c= \
                lsw_flag_d= \
                lsw_flag_f= \
                lsw_flag_g= \
                lsw_flag_h= \
                lsw_flag_i= \
                lsw_flag_k= \
                lsw_flag_l= \
                lsw_flag_m= \
                lsw_flag_n= \
                lsw_flag_o= \
                lsw_flag_p= \
                lsw_flag_q= \
                lsw_flag_r= \
                lsw_flag_s= \
                lsw_flag_t= \
                lsw_flag_u= \
                lsw_flag_x=;

        if
                (( $# ))
        then
                if
                        (( $# > 3 ))
                then
                        1>&2 IFS=' ' builtin printf "Too many arguments: '%s'\n" "$*"
                        builtin return
                else
                        builtin typeset -i n=1
                        for (( ; n <= $# ; n++ ))
                        do
                                [[ ${!n} == -- ]] && {
                                        builtin typeset lsw_file_name=${@:n+1:n}
                                        builtin break
                                }
                        done
                fi
                builtin typeset \
                        OPTIND=1 \
                        OPTERR=1 \
                        opt;
                while
                        builtin getopts :ACFHLRSacdfghiklmnopqrstux1 opt
                do
                        case $opt in
                        A)
                                lsw_flag_A=1
                        ;;
                        C)
                                lsw_flag_C=1
                        ;;
                        F)
                                lsw_flag_F=1
                        ;;
                        H)
                                lsw_flag_H=1
                        ;;
                        L)
                                lsw_flag_L=1
                        ;;
                        R)
                                lsw_flag_R=1
                        ;;
                        S)
                                lsw_flag_S=1
                        ;;
                        a)
                                lsw_flag_a=1
                        ;;
                        c)
                                lsw_flag_c=1
                        ;;
                        d)
                                lsw_flag_d=1
                        ;;
                        f)
                                lsw_flag_f=1
                        ;;
                        g)
                                lsw_flag_g=1
                        ;;
                        h)
                                lsw_flag_h=1
                        ;;
                        i)
                                lsw_flag_i=1
                        ;;
                        k)
                                lsw_flag_k=1
                        ;;
                        l)
                                lsw_flag_l=1
                        ;;
                        m)
                                lsw_flag_m=1
                        ;;
                        n)
                                lsw_flag_n=1
                        ;;
                        o)
                                lsw_flag_o=1
                        ;;
                        p)
                                lsw_flag_p=1
                        ;;
                        q)
                                lsw_flag_q=1
                        ;;
                        r)
                                lsw_flag_r=1
                        ;;
                        s)
                                lsw_flag_s=1
                        ;;
                        t)
                                lsw_flag_t=1
                        ;;
                        u)
                                lsw_flag_u=1
                        ;;
                        x)
                                lsw_flag_x=1
                        ;;
                        1)
                                lsw_flag_1=1
                        ;;
                        \?)
                                1>&2 builtin printf "Unknown flag: '-%s'\n" "$OPTARG"
                                builtin return 1
                        esac
                done
        fi

        builtin typeset \
                lsw_file_name="${LSW_FILE_NAME:-${lsw_file_name:-${PWD:-.}}}" \
                lsw_dir_name="${LSW_DIR_NAME:-${TMPDIR:-/tmp}/lsW}";

        builtin typeset lsw_file_inode="${LSW_FILE_INODE:-$(LsW::GetInode : "$lsw_file_name")}"

        builtin typeset -i \
                lsw_color=${LSW_COLOR:-0} \
                lsw_hook_tee=${LSW_HOOK_TEE:-0} \
                lsw_remove=${LSW_REMOVE:-0};

        lsw_flag_A=${LSW_FLAG_A:-${lsw_flag_A}}
        lsw_flag_C=${LSW_FLAG_C:-${lsw_flag_C}}
        lsw_flag_F=${LSW_FLAG_F:-${lsw_flag_F}}
        lsw_flag_H=${LSW_FLAG_H:-${lsw_flag_H}}
        lsw_flag_L=${LSW_FLAG_L:-${lsw_flag_L}}
        lsw_flag_R=${LSW_FLAG_R:-${lsw_flag_R}}
        lsw_flag_S=${LSW_FLAG_S:-${lsw_flag_S}}
        lsw_flag_a=${LSW_FLAG_a:-${lsw_flag_a}}
        lsw_flag_c=${LSW_FLAG_c:-${lsw_flag_c}}
        lsw_flag_d=${LSW_FLAG_d:-${lsw_flag_d}}
        lsw_flag_f=${LSW_FLAG_f:-${lsw_flag_f}}
        lsw_flag_g=${LSW_FLAG_g:-${lsw_flag_g}}
        lsw_flag_h=${LSW_FLAG_h:-${lsw_flag_h}}
        lsw_flag_i=${LSW_FLAG_i:-${lsw_flag_i}}
        lsw_flag_k=${LSW_FLAG_k:-${lsw_flag_k}}
        lsw_flag_l=${LSW_FLAG_l:-${lsw_flag_l}}
        lsw_flag_m=${LSW_FLAG_m:-${lsw_flag_m}}
        lsw_flag_n=${LSW_FLAG_n:-${lsw_flag_n}}
        lsw_flag_o=${LSW_FLAG_o:-${lsw_flag_o}}
        lsw_flag_p=${LSW_FLAG_p:-${lsw_flag_p}}
        lsw_flag_q=${LSW_FLAG_q:-${lsw_flag_q}}
        lsw_flag_r=${LSW_FLAG_r:-${lsw_flag_r}}
        lsw_flag_s=${LSW_FLAG_s:-${lsw_flag_s}}
        lsw_flag_t=${LSW_FLAG_t:-${lsw_flag_t}}
        lsw_flag_u=${LSW_FLAG_u:-${lsw_flag_u}}
        lsw_flag_x=${LSW_FLAG_x:-${lsw_flag_x}}
        lsw_flag_1=${LSW_FLAG_1:-${lsw_flag_1}}

        builtin typeset \
                f \
                flags \
                lsw_checksum_command="${LSW_CHECKSUM_COMMAND:-md5sum}" \
                lsw_hook_post="$LSW_HOOK_POST" \
                lsw_hook_prae="$LSW_HOOK_PRAE" \
                lsw_mkdir_command="${LSW_MKDIR_COMMAND:-mkdir -p}" \
                lsw_print_command="${LSW_PRINT_COMMAND:-cat}";

        builtin typeset lsw_checksum="${LSW_CHECKSUM:-$(LsW::GetChecksum :)}"

        for f in ${!lsw_flag_*} ${!lsw_remove*}
        do
                if
                        (( ${!f} ))
                then
                        builtin eval typeset +i "${f}=\${f##*_}"
                else
                        builtin unset -v "$f"
                fi
        done

        flags=${lsw_flag_A}${lsw_flag_C}${lsw_flag_F}${lsw_flag_H}${lsw_flag_L}
        flags+=${lsw_flag_R}${lsw_flag_S}${lsw_flag_a}${lsw_flag_c}${lsw_flag_d}
        flags+=${lsw_flag_f}${lsw_flag_g}${lsw_flag_h}${lsw_flag_i}${lsw_flag_k}
        flags+=${lsw_flag_l}${lsw_flag_m}${lsw_flag_n}${lsw_flag_o}${lsw_flag_p}
        flags+=${lsw_flag_q}${lsw_flag_r}${lsw_flag_s}${lsw_flag_t}${lsw_flag_u}
        flags+=${lsw_flag_x}${lsw_flag_1}

        if
                [[ -n $flags ]]
        then
                flags=-${flags}
        else
                builtin unset -v flags
        fi

        if
                [[ -f ${lsw_dir_name}/${lsw_file_inode}/${lsw_checksum} ]]
        then
                if
                        [[ -n $lsw_remove && $lsw_hook_tee -eq 0 ]]
                then
                        command rm "${lsw_dir_name}/${lsw_file_inode}/${lsw_checksum}"
                elif
                        (( lsw_hook_tee ))
                then
                        LsW::PrintFile
                fi
        else
                LsW::Mkdir
                LsW::SetLsOs
                if
                        (( lsw_hook_tee ))
                then
                        LsW::Build \
                        | command tee "${lsw_dir_name}/${lsw_file_inode}/${lsw_checksum}";
                else
                        LsW::Build \
                        > "${lsw_dir_name}/${lsw_file_inode}/${lsw_checksum}";
                fi
        fi
}

LsW::PrintFile ()
{
        ${lsw_print_command} "${lsw_dir_name}/${lsw_file_inode}/${lsw_checksum}"
}

LsW::FindInode ()
if
        [[ $1 == \: ]]
then
        2>/dev/null \
        command find -H "${2}/." \
                ! -name . \
                -prune \
                -inum "$3" \
                -exec basename '{}' \;
else
        builtin typeset -n lsw_ref="$1"
        lsw_ref=$(command find -H "${2}/." ! -name . -prune -inum "$3" -exec basename '{}' \; 2>/dev/null)
        builtin unset -n lsw_ref
fi

LsW::GetChecksum ()
if
        [[ $1 == \: ]]
then
        builtin typeset s="$(${lsw_checksum_command} <<-SUM
${COLUMNS}
${LANG}
${LC_ALL}
${LC_COLLATE}
${LC_CTYPE}
${LC_MESSAGES}
${LC_TIME}
${NLSPATH}
${TZ}
${lsw_color}
${lsw_file_inode}
${lsw_flag_A}
${lsw_flag_C}
${lsw_flag_F}
${lsw_flag_H}
${lsw_flag_L}
${lsw_flag_R}
${lsw_flag_S}
${lsw_flag_a}
${lsw_flag_c}
${lsw_flag_d}
${lsw_flag_f}
${lsw_flag_g}
${lsw_flag_h}
${lsw_flag_i}
${lsw_flag_k}
${lsw_flag_l}
${lsw_flag_m}
${lsw_flag_n}
${lsw_flag_o}
${lsw_flag_p}
${lsw_flag_q}
${lsw_flag_r}
${lsw_flag_s}
${lsw_flag_t}
${lsw_flag_u}
${lsw_flag_x}
${lsw_flag_1}
SUM
)"

        builtin printf '%s\n' "${s%% *}"
else
        builtin typeset -n lsw_ref="$1"
        lsw_ref=$(${lsw_checksum_command} <<-SUM
${COLUMNS}
${LANG}
${LC_ALL}
${LC_COLLATE}
${LC_CTYPE}
${LC_MESSAGES}
${LC_TIME}
${NLSPATH}
${TZ}
${lsw_color}
${lsw_file_inode}
${lsw_flag_A}
${lsw_flag_C}
${lsw_flag_F}
${lsw_flag_H}
${lsw_flag_L}
${lsw_flag_R}
${lsw_flag_S}
${lsw_flag_a}
${lsw_flag_c}
${lsw_flag_d}
${lsw_flag_f}
${lsw_flag_g}
${lsw_flag_h}
${lsw_flag_i}
${lsw_flag_k}
${lsw_flag_l}
${lsw_flag_m}
${lsw_flag_n}
${lsw_flag_o}
${lsw_flag_p}
${lsw_flag_q}
${lsw_flag_r}
${lsw_flag_s}
${lsw_flag_t}
${lsw_flag_u}
${lsw_flag_x}
${lsw_flag_1}
SUM
)
        lsw_ref=${lsw_ref%% *}
        builtin unset -n lsw_ref
fi

LsW::GetInode ()
if
        [[ $1 == \: ]]
then
        builtin typeset i="$(ls -1id "$2")"
        builtin printf '%s\n' "${i%% *}"
else
        builtin typeset -n lsw_ref="$1"
        lsw_ref=$(ls -1id "$2")
        lsw_ref=${lsw_ref%% *}
        builtin unset -n lsw_ref
fi

LsW::Mkdir ()
{
        ${lsw_mkdir_command} "${lsw_dir_name}/${lsw_file_inode}"
}

LsW::Perform ()
if
        (( lsw_color ))
then
        __ls_color ${flags} "$lsw_file_name"
else
        __ls ${flags} "$lsw_file_name"
fi

LsW::RemoveColor ()
{
        command sed "s,\x1B\[[0-9;]*[a-zA-Z],,g;s/^ *//"
}

LsW::SetLsOs ()
if
        ! >/dev/null 2>&1 builtin typeset -f __ls __ls_color
then
        case $(command uname -s) in
        Darwin | DragonFly | FreeBSD)
                function __ls { IFS=' ' command ls -G ${*} ; }
                function __ls_color { IFS=' ' CLICOLOR_FORCE=1 command ls -G ${*} ; }
        ;;
        OpenBSD)
                if
                        >/dev/null builtin command -v colorls
                then
                        function __ls { IFS=' ' command colorls -G ${*} ; }
                        function __ls_color { IFS=' ' CLICOLOR_FORCE=1 command colorls -G ${*} ; }
                else
                        if
                                >/dev/null builtin command -v gls
                        then
                                function __ls  { IFS=' ' command gls --color=auto ${*} ; }
                                function __ls_color { IFS=' ' command gls --color=always ${*} ; }
                        else
                                function __ls { IFS=' ' command ls ${*} ; }
                                function __ls_color { IFS=' ' command ls ${*} ; }
                        fi
                fi
        ;;
        *)
                function __ls { IFS=' ' ls --color=auto ${*} ; }
                function __ls_color { IFS=' ' ls --color=always ${*} ; }
        esac
fi

# vim: set ts=8 sw=8 tw=0 et :
