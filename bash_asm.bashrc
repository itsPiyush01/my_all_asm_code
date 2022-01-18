arg0=$1

full_filename=$(basename -- "$arg0")

filename="${full_filename%.*}"
extension="${filename##*.}"
nasm -f elf64 ./$full_filename -o ./$filename.o
ld $filename.o -o $filename
./$filename



























#echo "Both Assembler and linker Done thier Job  ;) "
#echo "Just Type:./$filename " 


#echo "EileName:$filename"
#echo "Exenstion:$extension"
