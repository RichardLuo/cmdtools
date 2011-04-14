. ~/.droid

function dump_one_files_symbol()
{
    if [ -f $1 ]; then
        # Dcc objdump -C -D $1 |grep -P "^\d+\s*<\w+"
        echo "@@@@@@@@@@@@@@@@ $1 @@@@@@@@@@@@@@@@"
        Dcc objdump -C -D $1 |grep -P "^\d+\s+<\w+"
        return 0
    else
        echo please specify the input obj file
    fi
    exit 100
}

# function dump_all_input_files()
# {
# }

for f in $@; do 
    dump_one_files_symbol $f
done

echo "dump symbols ok"
