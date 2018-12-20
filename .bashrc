#------------------------------------------------------------------------------
#BOP
#
# !MODULE: .bashrc
#
# !DESCRIPTION: A .bashrc file that can be used with Git-bash for Microsoft
#  Windows.  This initializes your Unix environment, starts the ssh-agent
#  for private-key forwarding, and loads personal aliases in your
#  .bash_aliases file.
#\\
#\\
# !CALLING SEQUENCE:
#  source ~/.bashrc
#
# !REMARKS:
#  (1) Add/change/remove settings to customize your Git-bash Unix environment.
#
#  (2) Your root folder (~) will be C:/Users/YOUR-WINDOWS-SCREEN-NAME, where
#      YOUR-WINDOWS-SCREEN-NAME is the name that you log into MS Windows with.
#
#  (3) SSH private keys should be stored in the folder
#      C:/Users/YOUR-WINDOWS-SCREEN_NAME/.ssh (aka ~/.ssh).
#
# !AUTHOR
#  Bob Yantosca (yantosca@seas.harvard.edu), 20 Dec 2018
#
# !REVISION HISTORY: 
#  Use the gitk browser to view the revision history!
#EOP
#------------------------------------------------------------------------------
#BOC

#==============================================================================
# Define personal settings that will be used below (edit these yourself)
#==============================================================================

# Define the user name. This should set to YOUR-WINDOWS-SCREEN-NAME.
export USER=YOUR-WINDOWS-SCREEN-NAME

# Define the path to SSH private keys that you would like to be forwarded
# using ssh-agent.  For example, if you want to connect to the AWS cloud, 
# then add the private key that is stored in your AWS account here.
# Add as many private keys as you like.  Private keys should be stored
# in the ~/.ssh folder.
key_1=~/.ssh/YOUR-PRIVATE-KEY-FILE

#==============================================================================
# Start the ssh agent and add your AWS private key
#==============================================================================
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

# Add a new ssh-add command for all of the private keys
# that you want to be forwarded with ssh-agent!
if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add ${key_1}
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add ${key_1}
fi

#==============================================================================
# Define some important local aliases
#==============================================================================

# Set prompt (optional)
PS1="\[\e[1;93m\][$USER \W]$\[\e[0m\] "

# Change to home directory
cd ~

# Set the default display variable to localhost:0 so that X-windows
# will appear 
export DISPLAY=localhost:0

# SSH with trusted X11 and agent forwarding
alias ssh="ssh -YA"

# SSH with all of the above, plus port forwarding
# (e.g. necessary for using Jupyter Notebooks on the Amazon Web servicee cloud)
alias ssh_pf="ssh -L 8999:localhost:8999 "

# Load more personal bash aliases (in the.bash_aliases file))
test -f ~/.bash_aliases && . ~/.bash_aliases

#==============================================================================
# Free local variables that we have created
#==============================================================================
unset env
unset key_1

#EOC
