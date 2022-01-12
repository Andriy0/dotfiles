# Bash initialization for interactive non-login shells and
# for remote shells (info "(bash) Bash Startup Files").

# Export 'SHELL' to child processes.  Programs such as 'screen'
# honor it and otherwise use /bin/sh.
export SHELL

if [[ $- != *i* ]]
then
    # We are being invoked from a non-interactive shell.  If this
    # is an SSH session (as in "ssh host command"), source
    # /etc/profile so we get PATH and other essential variables.
    [[ -n "$SSH_CLIENT" ]] && source /etc/profile

    # Don't do anything else.
    return
fi

# Source the system-wide file.
source /etc/bashrc

# Adjust the prompt depending on whether we're in 'guix environment'.
if [ -n "$GUIX_ENVIRONMENT" ]
then
    # PS1='\u@\h \w [env] \$ '
    PS1='[env] \$ '
    # PS1='\e[0;34m\w\e[m \e[0;32m[\e[m\e[0;31menv\e[m\e[0;32m]\e[m \e[0;35m\$\e[m '
else
    PS1='\u@\h \w \$ '
    # eval "$(starship init bash)"
fi

export HISTCONTROL=ignoreboth:erasedups

alias ls='ls -p --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'

fish
