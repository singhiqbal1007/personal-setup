CMD='docker run --name personal-setup -it --privileged'
[[ -z "${LOCAL_VOL}" ]] && VOL='' || VOL=" -v ${LOCAL_VOL}:/root/volume"
CMD+="${VOL} personal-setup:latest /bin/zsh"
$CMD
