# Stowed to ~/.bash_aliases, which the stock Debian/Ubuntu ~/.bashrc sources automatically.

eval "$(starship init bash)"

export MAKEFLAGS=-j$(nproc)
alias ll='ls -alF'
alias sudo='sudo '
alias mount_fit='mount.cifs   //drive.fit.cvut.cz/home/staniond   /mnt/fit   -o sec=ntlmv2i,fsc,file_mode=0700,dir_mode=0700,uid=$UID,user=staniond'
alias bat='batcat --paging=never'
