# Assembly

Serie de mini programmes en assembleur NASM

- Mini programme d'input/output (hello.asm)
- Exemple basique d'un socket qui affiche les headers des requetes des clients (socket.asm)
Pour compiler l'un des deux :

nasm -f elf hello.asm/socket.asm

ld -m elf_i386 hello.o/socket.o -o programme

./programme

Pour le programme socket, lancez ./programme dans un terminal
et lancez la commande curl http://localhost:9001 dans un autre et regardez ce qu'il se passe.
