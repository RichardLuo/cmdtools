cd /usr/include
kernel_inc=/home/richard/software/Kernel/linux-2.6.20/include
usr_inc=/usr/include

sudo rm -f ${usr_inc}/linux
sudo rm -f ${usr_inc}/asm
sudo rm -f ${usr_inc}/asm-generic

sudo ln -fs ${kernel_inc}/linux .
sudo ln -fs ${kernel_inc}/asm .
sudo ln -fs ${kernel_inc}/asm-generic .
