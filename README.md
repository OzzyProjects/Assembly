# Assembly

Serie de mini programmes en assembleur NASM (en cours)

- Mini programme d'input/output (hello.asm)

- Exemple minimal d'un server socket qui ecoute sur le port 9001. Il affiche les headers des requetes de connexions des clients (socket.asm)

et envoie un "Hello World" en reponse à la connection.

- Jeu devinez quel nombre je suis (guess number). (6 essais par défaut)

Pour compiler l'un des deux :

nasm -f elf hello.asm ou socket.asm ou guess_number.asm

ld -m elf_i386 hello.o ou socket.o ou guess_number.o -o programme

./programme

Pour le programme socket, lancez ./programme dans un terminal

et lancez la commande sudo curl http://localhost:9001 dans un autre terminal et regardez ce qu'il se passe à la fois du coté client

et à la fois du coté serveur.
