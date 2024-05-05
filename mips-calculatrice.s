# "$t0" : pour stocker le premier nombre saisi par l'utilisateur
# "$t1" : pour stocker le second nombre saisi par l'utilisateur
# "$t2" : pour stocker le choix d'operationsaisi par l'utilisateur
# "$t3" : pour stocker le résultat du calcul


.data
#Les message pour lire les nombres
msg1: .asciiz "\nEntrez le premier nombre: "
msg2: .asciiz "Entrez la deuxieme nombre: "

#Le menu d'options
menu: .asciiz "\nMenu de la Calculatrice:\n1. Addition\n2. Soustraction\n3. Multiplication\n4. Division\n5. Modulo\n6. Négation\n7. Quitter\n"                       
optionMsg: .asciiz "Choisissez une option: "

#Erreur
Erreur: .asciiz "Division par zéro!\n"

#message d'affichage
res: .asciiz "Resultat: \n"

.text
.globl main
main :
#On Utiliser les psudo-instriction

#les instructions MIPS pour saisir les nombres:

#Lire la 1er nomber
la $a0,msg1     #charger l'adresse du message 1
nop
nop
li $v0,4        #charger 4 pour afficher un chaine
syscall

li $v0,5        #charger 5 pour lire un entier
syscall
move $t0,$v0    #stocker dans $t0

#Lire la 2eme nomber
la $a0,msg2     #charger l'adresse du message 2
nop
nop
li $v0,4        #charger 4 pour afficher un chaine
syscall

li $v0,5        #charger 5 pour lire un entier
syscall
move $t1,$v0    #stocker dans $t1


#Afficher le menu d'options de calcul
la $a0,menu          #charger l'adresse du menu
nop
nop
li $v0,4             #charger 4 pour afficher un chaine
syscall

la $a0,optionMsg     #charger l'adresse du optionMsg
nop
nop
li $v0,4             #charger 4 pour afficher un chaine
syscall

#Lire l'option
li $v0,5             #charger 5 pour lire un entier
syscall
move $t2,$v0         #stocker dans $t2


#les instructions MIPS pour les operations

beq $t2,1,addition          # Si l'utilisateur a choisi l'addition
beq $t2,2,soustraction      # Si l'utilisateur a choisi la soustraction
beq $t2,3,multiplication    # Si l'utilisateur a choisi la multiplication
beq $t2,4,division          # Si l'utilisateur a choisi la division
beq $t2,5,modulo            # Si l'utilisateur a choisi le modulo
beq $t2,6,negation          # Si l'utilisateur a choisi la négation
beq $t2,7,exit              # Si l'utilisateur a choisi de exit



# Revenir au menu si le choix est invalide
j main

#l'operation d'addition
addition: addu $t3,$t0,$t1 # Effectuer l'addition
j afficher

#l'operation de soustraction
soustraction: subu $t3,$t0,$t1 # Effectuer la soustraction
j afficher

#l'operation de multiplication
multiplication: mult $t0,$t1  # Effectuer la multiplication
mflo $t3
j afficher

#l'operation de division
division: beq $t1,$zero,division_par_zero  # Si $t1 est zéro, aller à la gestion de l'erreur
div $t3,$t0,$t1                            # Effectuer la division
j afficher

#l'operation de modulo
modulo: beq $t1,$zero,division_par_zero  # Si $t1 est zéro, aller à la gestion de l'erreur
div $t3,$t0,$t1                          # Effectuer la division
mfhi $t3                                 # charger le rest
j afficher

#l'operation de negation
negation: subu $t3,$zero,$t0
j afficher

# Division par zéro
division_par_zero: li $v0,4
la $a0,Erreur   # Message d'erreur
syscall
j main          # Retour au debu

# Afficher
afficher: li $v0,4
la $a0,res
syscall     #afficher resultat message

li $v0,1
move $a0,$t3  # Transférer le résultat au registre $a0 pour affichage
syscall       # Afficher la resultat

# Retour au debu
j main

exit: addi $v0, $0, 10	# System call 10 - Exit
syscall					# execute