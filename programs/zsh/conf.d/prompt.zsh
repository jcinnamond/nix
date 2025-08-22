function _prompt_git() {
    local branch=$(git branch --show-current 2>/dev/null)
	if test -z "$branch"; then
	  return
	fi
	local fg=$color_git_clean_fg
	if test -n "$(git status --porcelain)"; then
		fg=$color_git_dirty_fg
	fi

	echo -n "  "
	echo -n "%F{$fg}$branch%f"
}

function _prompt_cwd() {
	echo -n "%F{$color_cwd_fg}%~%f"
	local git_prompt=$(_prompt_git)
	if test -n "$git_prompt"; then
		echo -n "$git_prompt"
	else
	fi
}

function _prompt_nix_shell() {
	if test -n "$IN_NIX_SHELL"; then
	  echo -n "  "
	  echo -n "%F{$color_nix_shell_fg}nix shell%f"
	fi
}

function _prompt_direnv() {
	if test -n "$DIRENV_DIR"; then
	  echo -n "  "
	  echo -n "%F{$color_direnv_fg} direnv%f"
	fi
}

function _prompt() {
	local last_status=$?
	if (( $_prompt_compact )); then
	  local fg=$color_prompt_previous
	  if test $last_status -ne 0; then
	    fg=$color_error
	  fi
	  echo -n "%F{$fg}%f %F{$color_prompt_previous}%~%f  "
	  return
	fi

	echo -n "\n$(_prompt_cwd)$(_prompt_nix_shell)$(_prompt_direnv)\n "
}

function() _rprompt() {
	if (( $_prompt_compact )); then
	  echo -n "%F{$color_prompt_previous}%D %t%f"
	fi
}

setopt PROMPT_SUBST
PROMPT='$(_prompt)'
RPROMPT='$(_rprompt)'

# Taken from https://vincent.bernat.ch/en/blog/2021-zsh-transient-prompt, which
# in turn is taken from powerline10k
_zle-line-init() {
    [[ $CONTEXT == start ]] || return 0

    # Start regular line editor
    (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[1]
    zle .recursive-edit
    local -i ret=$?
    (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[2]

    # If we received EOT, we exit the shell
    if [[ $ret == 0 && $KEYS == $'\4' ]]; then
        _prompt_compact=1
        zle .reset-prompt
        exit
    fi

    # Line edition is over. Shorten the current prompt.
    _prompt_compact=1
    zle .reset-prompt
    unset _prompt_compact

    if (( ret )); then
        # Ctrl-C
        zle .send-break
    else
        # Enter
        zle .accept-line
    fi
    return ret
}
zle -N zle-line-init _zle-line-init
