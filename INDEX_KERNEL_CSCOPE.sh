find . \( \( -path './debian*'  -o -path './helloMe*' \) -prune -type f \) -o \( -type f -name '*.[ch]' \) > cscope.files
cscope -b -i cscope.files -f cscope.out

