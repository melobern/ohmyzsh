
function svn_prompt_info {
    if [ $(in_svn) ]; then
        echo "$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_PREFIX\
$ZSH_THEME_REPO_NAME_COLOR$(svn_get_repo_name)$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_SUFFIX$ZSH_PROMPT_BASE_COLOR$(svn_dirty)$ZSH_PROMPT_BASE_COLOR"
    fi
}


function in_svn() {
    if [[ -d .svn ]]; then
        echo 1
    fi
}

function svn_get_repo_name {
    if [ $(in_svn) ]; then
        svn info | sed -n 's/Repository\ Root:\ .*\///p' | read SVN_ROOT

        svn info | sed -n "s/URL:\ .*$SVN_ROOT\///p"
    fi
}

function svn_get_rev_nr {
    if [ $(in_svn) ]; then
        svn info 2> /dev/null | sed -n s/Revision:\ //p
    fi
}

function svn_dirty_choose {
    if [ $(in_svn) ]; then
        svn status 2> /dev/null | grep -Eq '^\s*[ACDIM!?L]'
        if [ $pipestatus[-1] -eq 0 ]; then
            # Grep exits with 0 when "One or more lines were selected", return "dirty".
            echo $1
        else
            # Otherwise, no lines were found, or an error occurred. Return clean.
            echo $2
        fi
    fi
}

function svn_dirty {
    svn_dirty_choose $ZSH_THEME_SVN_PROMPT_DIRTY $ZSH_THEME_SVN_PROMPT_CLEAN
}
