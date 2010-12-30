. ~/.droid

if [ -f $1 ]; then
Dcc objdump -C -D $1 |grep -P "^\d+\s+<\w+"
else
echo please specify the input obj file
fi
