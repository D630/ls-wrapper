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
        [[ -n $ls_hook_prae && -n $ls_hook_post ]]
then
        ${ls_hook_prae} \
        | LsW::Perform "$ls_command" \
        | ${ls_hook_post};
elif
        [[ -n $ls_hook_prae ]]
then
        ${ls_hook_prae} \
        | LsW::Perform "$ls_command";
elif
        [[ -n $ls_hook_post ]]
then
        LsW::Perform "$ls_command" \
        | ${ls_hook_post};
else
        LsW::Perform "$ls_command"
fi

LsW::Do ()
{
        builtin unset -v \
                ls_flag_1 \
                ls_flag_A \
                ls_flag_C \
                ls_flag_F \
                ls_flag_H \
                ls_flag_L \
                ls_flag_R \
                ls_flag_S \
                ls_flag_a \
                ls_flag_c \
                ls_flag_d \
                ls_flag_f \
                ls_flag_g \
                ls_flag_h \
                ls_flag_i \
                ls_flag_k \
                ls_flag_l \
                ls_flag_m \
                ls_flag_n \
                ls_flag_o \
                ls_flag_p \
                ls_flag_q \
                ls_flag_r \
                ls_flag_s \
                ls_flag_t \
                ls_flag_u \
                ls_flag_x;

        if
                (( $# ))
        then
                if
                        (( $# > 2 ))
                then
                        1>&2 IFS=" " builtin printf "Too many arguments: '%s'\n" "$*"
                        builtin return
                else
                        builtin typeset f ls_file_name
                        for f
                        do
                                if
                                        [[ $f == \-* || ! -d $f ]]
                                then
                                        1>&2 builtin printf "Cannot access '%s': No such directory\n" "$f"
                                        builtin return 1
                                else
                                        ls_file_name=$f
                                fi
                        done
                fi
                builtin typeset \
                        OPTIND=1 \
                        opt;
                while
                        builtin getopts :ACFHLRSacdfghiklmnopqrstux1 opt
                do
                        case $opt in
                        A)
                                ls_flag_A=1
                        ;;
                        C)
                                ls_flag_C=1
                        ;;
                        F)
                                ls_flag_F=1
                        ;;
                        H)
                                ls_flag_H=1
                        ;;
                        L)
                                ls_flag_L=1
                        ;;
                        R)
                                ls_flag_R=1
                        ;;
                        S)
                                ls_flag_S=1
                        ;;
                        a)
                                ls_flag_a=1
                        ;;
                        c)
                                ls_flag_c=1
                        ;;
                        d)
                                ls_flag_d=1
                        ;;
                        f)
                                ls_flag_f=1
                        ;;
                        g)
                                ls_flag_g=1
                        ;;
                        h)
                                ls_flag_h=1
                        ;;
                        i)
                                ls_flag_i=1
                        ;;
                        k)
                                ls_flag_k=1
                        ;;
                        l)
                                ls_flag_l=1
                        ;;
                        m)
                                ls_flag_m=1
                        ;;
                        n)
                                ls_flag_n=1
                        ;;
                        o)
                                ls_flag_o=1
                        ;;
                        p)
                                ls_flag_p=1
                        ;;
                        q)
                                ls_flag_q=1
                        ;;
                        r)
                                ls_flag_r=1
                        ;;
                        s)
                                ls_flag_s=1
                        ;;
                        t)
                                ls_flag_t=1
                        ;;
                        u)
                                ls_flag_u=1
                        ;;
                        x)
                                ls_flag_x=1
                        ;;
                        1)
                                ls_flag_1=1
                        ;;
                        \?)
                                1>&2 builtin printf "Unknown flag: '-%s'\n" "$OPTARG"
                                builtin return 1
                        esac
                done
        fi

        builtin typeset \
                ls_file_name="${LS_FILE_NAME:-${ls_file_name:-${PWD:-.}}}" \
                ls_dir_name="${LS_DIR_NAME:-${TMPDIR:-/tmp}/ls}";

        builtin typeset ls_file_inode="${LS_FILE_INODE:-$(LsW::GetInode : "$ls_file_name")}"

        builtin typeset -i \
                ls_color=${LS_COLOR:-0} \
                ls_flag_A=${LS_FLAG_A:-${ls_flag_A}} \
                ls_flag_C=${LS_FLAG_C:-${ls_flag_C}} \
                ls_flag_F=${LS_FLAG_F:-${ls_flag_F}} \
                ls_flag_H=${LS_FLAG_H:-${ls_flag_H}} \
                ls_flag_L=${LS_FLAG_L:-${ls_flag_L}} \
                ls_flag_R=${LS_FLAG_R:-${ls_flag_R}} \
                ls_flag_S=${LS_FLAG_S:-${ls_flag_S}} \
                ls_flag_a=${LS_FLAG_a:-${ls_flag_a}} \
                ls_flag_c=${LS_FLAG_c:-${ls_flag_c}} \
                ls_flag_d=${LS_FLAG_d:-${ls_flag_d}} \
                ls_flag_f=${LS_FLAG_f:-${ls_flag_f}} \
                ls_flag_g=${LS_FLAG_g:-${ls_flag_g}} \
                ls_flag_h=${LS_FLAG_h:-${ls_flag_h}} \
                ls_flag_i=${LS_FLAG_i:-${ls_flag_i}} \
                ls_flag_k=${LS_FLAG_k:-${ls_flag_k}} \
                ls_flag_l=${LS_FLAG_l:-${ls_flag_l}} \
                ls_flag_m=${LS_FLAG_m:-${ls_flag_m}} \
                ls_flag_n=${LS_FLAG_n:-${ls_flag_n}} \
                ls_flag_o=${LS_FLAG_o:-${ls_flag_o}} \
                ls_flag_p=${LS_FLAG_p:-${ls_flag_p}} \
                ls_flag_q=${LS_FLAG_q:-${ls_flag_q}} \
                ls_flag_r=${LS_FLAG_r:-${ls_flag_r}} \
                ls_flag_s=${LS_FLAG_s:-${ls_flag_s}} \
                ls_flag_t=${LS_FLAG_t:-${ls_flag_t}} \
                ls_flag_u=${LS_FLAG_u:-${ls_flag_u}} \
                ls_flag_x=${LS_FLAG_x:-${ls_flag_x}} \
                ls_flag_1=${LS_FLAG_1:-${ls_flag_1}} \
                ls_hook_tee=${LS_HOOK_TEE:-0} \
                ls_remove=${LS_REMOVE:-0};

        builtin typeset \
                f \
                flags \
                ls_checksum_command="${LS_CHECKSUM_COMMAND:-md5sum}" \
                ls_hook_post="$LS_HOOK_POST" \
                ls_hook_prae="$LS_HOOK_PRAE" \
                ls_mkdir_command="${LS_MKDIR_COMMAND:-mkdir -p}" \
                ls_print_command="${LS_PRINT_COMMAND:-cat}";

        builtin typeset ls_checksum="${LS_CHECKSUM:-$(LsW::GetChecksum :)}"

        for f in ${!ls_flag_*} ${!ls_remove*}
        do
                if
                        (( ${!f} ))
                then
                        builtin eval typeset +i "${f}=\${f##*_}"
                else
                        builtin unset -v "$f"
                fi
        done

        flags=${ls_flag_A}${ls_flag_C}${ls_flag_F}${ls_flag_H}${ls_flag_L}
        flags+=${ls_flag_R}${ls_flag_S}${ls_flag_a}${ls_flag_c}${ls_flag_d}
        flags+=${ls_flag_f}${ls_flag_g}${ls_flag_h}${ls_flag_i}${ls_flag_k}
        flags+=${ls_flag_l}${ls_flag_m}${ls_flag_n}${ls_flag_o}${ls_flag_p}
        flags+=${ls_flag_q}${ls_flag_r}${ls_flag_s}${ls_flag_t}${ls_flag_u}
        flags+=${ls_flag_x}${ls_flag_1}

        if
                [[ -n $flags ]]
        then
                flags=${flags/#/-}
        else
                builtin unset -v flags
        fi

        if
                [[ -f ${ls_dir_name}/${ls_file_inode}/${ls_checksum} ]]
        then
                if
                        [[ -n $ls_remove && $ls_hook_tee -eq 0 ]]
                then
                        command rm "${ls_dir_name}/${ls_file_inode}/${ls_checksum}"
                elif
                        (( ls_hook_tee ))
                then
                        LsW::PrintFile
                fi
        else
                LsW::Mkdir
                LsW::SetAliases
                if
                        (( ls_color ))
                then
                        typeset ls_command=__ls_color
                else
                        typeset ls_command=__ls
                fi
                if
                        (( ls_hook_tee ))
                then
                        LsW::Build \
                        | command tee "${ls_dir_name}/${ls_file_inode}/${ls_checksum}";
                else
                        > "${ls_dir_name}/${ls_file_inode}/${ls_checksum}" \
                        LsW::Build
                fi
        fi
}

LsW::PrintFile ()
{
        ${ls_print_command} "${ls_dir_name}/${ls_file_inode}/${ls_checksum}"
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
        builtin eval "${1}=\$(command find -H "${2}/." ! -name . -prune -inum "$3" -exec basename '{}' \; 2> /dev/null)"
fi

LsW::GetChecksum ()
if
        [[ $1 == \: ]]
then
        builtin typeset +i s="$( ${ls_checksum_command} <<-SUM
${COLUMNS}
${LANG}
${LC_ALL}
${LC_COLLATE}
${LC_CTYPE}
${LC_MESSAGES}
${LC_TIME}
${NLSPATH}
${TZ}
${ls_color}
${ls_file_inode}
${ls_flag_A}
${ls_flag_C}
${ls_flag_F}
${ls_flag_H}
${ls_flag_L}
${ls_flag_R}
${ls_flag_S}
${ls_flag_a}
${ls_flag_c}
${ls_flag_d}
${ls_flag_f}
${ls_flag_g}
${ls_flag_h}
${ls_flag_i}
${ls_flag_k}
${ls_flag_l}
${ls_flag_m}
${ls_flag_n}
${ls_flag_o}
${ls_flag_p}
${ls_flag_q}
${ls_flag_r}
${ls_flag_s}
${ls_flag_t}
${ls_flag_u}
${ls_flag_x}
${ls_flag_1}
SUM
)"
        builtin printf '%s\n' "${s%% *}"
else
        builtin eval "${1}=\$( ${ls_checksum_command} <<-SUM
${COLUMNS}
${LANG}
${LC_ALL}
${LC_COLLATE}
${LC_CTYPE}
${LC_MESSAGES}
${LC_TIME}
${NLSPATH}
${TZ}
${ls_color}
${ls_file_inode}
${ls_flag_A}
${ls_flag_C}
${ls_flag_F}
${ls_flag_H}
${ls_flag_L}
${ls_flag_R}
${ls_flag_S}
${ls_flag_a}
${ls_flag_c}
${ls_flag_d}
${ls_flag_f}
${ls_flag_g}
${ls_flag_h}
${ls_flag_i}
${ls_flag_k}
${ls_flag_l}
${ls_flag_m}
${ls_flag_n}
${ls_flag_o}
${ls_flag_p}
${ls_flag_q}
${ls_flag_r}
${ls_flag_s}
${ls_flag_t}
${ls_flag_u}
${ls_flag_x}
${ls_flag_1}
SUM
)"
        builtin eval "${1}=\${!1%% *}"
fi

LsW::GetInode ()
if
        [[ $1 == \: ]]
then
        builtin typeset +i i="$(ls -1id "$2")"
        builtin printf '%s\n' "${i%% *}"
else
        builtin eval "${1}=\$(ls -1id "$2")"
        builtin eval "${1}=\${!1%% *}"
fi

LsW::Mkdir ()
{
        ${ls_mkdir_command} "${ls_dir_name}/${ls_file_inode}"
}

LsW::Perform ()
{
        ${1} ${flags} "$ls_file_name"
}

LsW::RemoveColor ()
{
        command sed "s,\x1B\[[0-9;]*[a-zA-Z],,g;s/^ *//"
}

LsW::SetAliases ()
if
        ! >/dev/null 2>&1 builtin typeset -f __ls __ls_color
then
        builtin typeset \
                __ls \
                __ls_color;
        case $(command uname -s) in
        Darwin | DragonFly | FreeBSD)
                __ls="() { IFS=' ' ls -G \\\$* ; }"
                __ls_color="() { IFS=' ' CLICOLOR_FORCE=1 ls -G \\\$* ; }"
        ;;
        OpenBSD)
                if
                        >/dev/null command command -v colorls
                then
                        __ls="() { IFS=' ' colorls -G \\\$* ; }"
                        __ls_color="() { IFS=' ' CLICOLOR_FORCE=1 colorls -G \\\$* ; }"
                else
                        if
                                >/dev/null command command -v gls
                        then
                                __ls="() { IFS=' ' gls --color=auto \\\$* ; }"
                                __ls_color="() { IFS=" " gls --color=always \\\$* ; }"
                        else
                                __ls="() { IFS=' ' ls \\\$* ; }"
                                __ls_color="() { IFS=' ' ls \\\$* ; }"
                        fi
                fi
        ;;
        *)
                #__ls="() { IFS=' ' command ls --color=auto \\\$* ; }"
                __ls="() { IFS=\\' \\' eval ls --color=auto \\\${*// /\\\\\\\\\\ \\} ; }"
                __ls_color="() { IFS=\\' \\' eval ls --color=always \\\${*// /\\\\\\\\\\ \\} ; }"
        esac

        if
                [[ -n $2 ]]
        then
                builtin eval "${1}=\${!2}"
        else
                builtin eval __ls="\${__ls:+${__ls}}"
                builtin eval __ls_color="\${__ls_color:+${__ls_color}}"
                builtin eval "__ls ${__ls}"
                builtin eval "__ls_color ${__ls_color}"
        fi
fi

# vim: set ts=8 sw=8 tw=0 et :
