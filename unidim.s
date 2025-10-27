.data
O: .space 4
v: .space 4096
operatie: .space 4
N: .space 4
descriptor: .space 4
dimensiune_fisier: .space 4
descriptor_cautat: .space 4
descriptor_sters: .space 4
fs: .asciz "%d"
fp: .asciz "%s"
afisare: .asciz "%d "
formatPrint: .asciz "%d: (%d, %d)\n"
formatPrintGet: .asciz "(%d, %d)\n"
fctget: .asciz "GET\n"
fctdel: .asciz "DEL\n"
fctdef: .asciz "DEF\n"
linie: .asciz "\n"
.text

.global main

AFISARE:
push %ebp
mov %esp, %ebp		
subl $8,%esp			#facem loc pt st,dr st=-4, dr=-8

movl $-1,%eax
movl %eax,-4(%ebp)		#st=-1
movl %eax,-8(%ebp)		#dr=-1
xor %ecx,%ecx
xor %ebx,%ebx
xor %eax,%eax

afisare_for:
cmp $1024,%ecx				
je final_afis
movl (%edi,%ecx,4), %eax		#eax=v[i]
cmp $1023,%ecx
jne if_1
cmp $0,%eax
je if_1

mov -8(%ebp),%ebx
inc %ebx
mov %ebx,-8(%ebp)			#dr++


					#afisam pozitia
push %ecx

movl (%edi,%ecx,4),%eax		#eax=v[i]
movl -4(%ebp),%ebx		#ebx=st
movl -8(%ebp),%edx		#edx=dr

push %edx
push %ebx
push %eax
push $formatPrint
call printf
add $16,%esp

pop %ecx
jmp final_afis


if_1:
inc %ecx
movl (%edi,%ecx,4), %ebx		#ebx=v[i+1]
dec %ecx


cmp %ebx,%eax				#veificam daca v[i]==v[i+1]
jne if_2
cmpl $-1,-4(%ebp)
jne if_2
movl %ecx,-4(%ebp)			#st=i

if_2:
cmp %ebx,%eax				#veificam daca v[i]==v[i+1]
jne if_3
cmpl $-1,-4(%ebp)
je if_3
movl %ecx,-8(%ebp)			#dr=i

if_3:
cmp %ebx,%eax				#veificam daca v[i]==v[i+1]
je pas_for
movl -8(%ebp),%ebx
inc %ebx
movl %ebx,-8(%ebp)			#dr++
cmp $0,%eax
je actualizam_st_dr


#afisam pozitiile
push %ecx

movl (%edi,%ecx,4),%eax		#eax=v[i]
movl -4(%ebp),%ebx		#ebx=st
movl -8(%ebp),%edx		#edx=dr

push %edx
push %ebx
push %eax
push $formatPrint
call printf
add $16,%esp

pop %ecx


actualizam_st_dr:
movl $-1,-4(%ebp)			#st=-1
movl $-1,-8(%ebp)			#dr=-1

pas_for:
inc %ecx
jmp afisare_for


final_afis:
addl $8, %esp
mov %ebp, %esp        
pop %ebp              
ret



ADD:	
push %ebp
mov %esp, %ebp		
subl $12,%esp			#facem loc pt nr,poz si memorie nr=-4, poz=-8, memorie=-12

xor %eax,%eax
xor %ebx,%ebx
xor %edx,%edx	
movl %eax, -4(%ebp)		#nr=0
movl $-1,%eax			
movl %eax, -8(%ebp)		#poz=-1
mov 12(%ebp),%eax		#eax=dimensiune_fisier
add $7,%eax
movl $8,%ebx
divl %ebx			#eax=dimensiune_fisier+7/8
movl %eax, -12(%ebp)		#memorie=dimensiune_fisier+7/8

xor %eax,%eax
xor %ebx,%ebx				
xor %ecx,%ecx
xor %edx,%edx

for_i_add:
cmp $1024,%ecx				#ecx=0=i
je verificare_memorie
mov (%edi, %ecx, 4), %eax
cmp $0, %eax				#v[i]==0?
jne else_i_add				#v[i]!=0
inc %ebx			
movl %ebx, -4(%ebp)			#nr++
movl -8(%ebp),%eax			#eax=poz
cmp $-1,%eax
jne verificare_locuri			#(verificare_locuri)nr==memorie
movl %ecx,-8(%ebp)			#poz=i
jmp verificare_locuri

else_i_add:
xor %ebx,%ebx 				
movl %ebx,-4(%ebp)			#nr=ebx=0
movl $-1,%eax				#eax=-1
movl %eax, -8(%ebp) 			#poz=-1

verificare_locuri:
cmp %ebx,-12(%ebp)			#memorie==nr
je verificare_memorie
inc %ecx
jmp for_i_add

verificare_memorie:
cmp -12(%ebp),%ebx		#memorie??nr
jl prea_mare

mov -8(%ebp),%ecx		#ecx=j=poz
mov %ecx, %ebx
add -4(%ebp), %ebx		#ebx=poz+nr

for_j_add:
cmp %ecx, %ebx
je afiseaza_pozitiile
mov 8(%ebp),%eax 		#eax=descriptor
movl %eax, (%edi,%ecx,4) 	#v[j]=descriptor
inc %ecx
jmp for_j_add

afiseaza_pozitiile:
dec %ecx 			#j--
mov -8(%ebp),%ebx		#ebx=poz
movl (%edi,%ebx,4),%edx		#edx=v[poz] 

#afisam pozitia
push %ecx
push %ebx
push %edx
push $formatPrint
call printf
add $16, %esp

jmp sfarsit_add

prea_mare:
mov 8(%ebp),%edx
mov $0,%eax
push %eax
push %eax
push %edx
push $formatPrint
call printf
add $16, %esp

sfarsit_add:
addl $12, %esp
mov %ebp, %esp        
pop %ebp              
ret


GET:
push %ebp
mov %esp, %ebp		
subl $8,%esp			#facem loc pt nr,poz si memorie get_st=-4, get_dr=-8

xor %ecx,%ecx
xor %eax,%eax

movl $-1,%eax
movl %eax, -4(%ebp)		#get_st=-1
movl %eax, -8(%ebp)		#get_dr=-1

movl $-1,%ecx			#ecx=-1

for_get:
inc %ecx			
cmp $1024,%ecx
je afisare_get
movl (%edi,%ecx,4),%eax 	#eax=v[i]
movl -4(%ebp),%ebx		#ebx=get_st

cmp %eax,8(%ebp)		#v[i]??descriptor_cautat
jne for_get
cmp $-1,%ebx			#get_st==-1
jne if_dr_get
movl %ecx,%ebx			#ebx=i
movl %ebx,-4(%ebp)		#get_st=i

if_dr_get:
movl %ecx,%ebx			#ebx=i
movl %ebx,-8(%ebp)		#get_dr=i
jmp for_get

afisare_get:
movl -4(%ebp), %eax		#eax=get_st
cmp $-1,%eax			#get_st??-1
jne afis_get_pozitii
inc %eax			#eax=0
push %eax
push %eax
push $formatPrintGet
call printf
add $4,%esp
pop %eax
pop %eax
jmp sfarsit_get

afis_get_pozitii:
movl -4(%ebp),%eax		#eax=get_st
movl -8(%ebp),%ebx		#ebx=get_dr
push %ebx
push %eax
push $formatPrintGet
call printf
add $4,%esp
pop %eax
pop %ebx

sfarsit_get:
addl $8, %esp
mov %ebp, %esp        
pop %ebp              
ret


DEL:
push %ebp
mov %esp, %ebp		

movl $-1,%ecx		#ecx=-1

for_del:
inc %ecx		#ecx=i=0
cmp $1024, %ecx
je sfarsit_del
movl (%edi,%ecx,4), %eax	#eax=v[i]
cmp %eax, 8(%ebp)
jne for_del
xor %eax,%eax
movl %eax,(%edi,%ecx,4)		#v[i]=0
jmp for_del

sfarsit_del:
mov %ebp, %esp
pop %ebp
ret


DEF:
push %ebp
mov %esp, %ebp
subl $4,%esp 		#facem loc pt n=-4

xor %eax,%eax
xor %ebx,%ebx
movl $-1,%ecx
movl %eax, -4(%ebp)		#n=0

for_def:
inc %ecx		#ecx=i=0
cmp $1024,%ecx
je sfarsit_def
movl (%edi,%ecx,4),%ebx		#ebx=v[i]
cmp $0,%ebx
je for_def
movl -4(%ebp),%edx		#edx=n
movl %ebx,%eax			#eax=v[i]
movl (%edi,%edx,4),%ebx		#ebx=v[n]
movl %ebx,(%edi,%ecx,4)		#v[i]=v[n]
movl %eax,(%edi,%edx,4)		#v[n]=v[i]
inc %edx
movl %edx, -4(%ebp)		#n++
jmp for_def

sfarsit_def:
addl $4,%esp
mov %ebp, %esp
pop %ebp
ret


main:
lea v, %edi
push $O				#citim O
push $fs
call scanf
addl $8, %esp

movl $1,%ecx 			#ecx=h=1
for_citire_operatii:		# citim cele O operatii
cmp %ecx,O  			#h>O
jl et_exit

push %ecx
push $operatie			#citim operatie
push $fs
call scanf
add $8, %esp
pop %ecx

movl operatie,%eax		#eax=operatie
cmp $1,%eax			#operatie=eax=add
je afis_add			#operatie=1
cmp $2,%eax			#operatie=eax=get
je afis_get			#operatie=2
cmp $3,%eax			#operatie=eax=del
je afis_del			#operatie=3
cmp $4,%eax			#operatie=eax=def
je afis_def			#operatie=4

urmatoarea_op:			
inc %ecx			#h++
jmp for_citire_operatii


					#ADD
afis_add:
push %ecx
push $N				#citim N
push $fs
call scanf
add $8,%esp
pop %ecx

movl $1,%edx			#edx=i=1
for_citire_descriptor:
cmp %edx,N
jl urmatoarea_op
inc %edx				#i++

push %ecx
push %edx
push $descriptor		#citim descriptor
push $fs
call scanf
add $8, %esp
pop %edx
pop %ecx

push %ecx
push %edx
push $dimensiune_fisier		#citim dimensiune_fisier
push $fs
call scanf
add $8, %esp
pop %edx
pop %ecx

push %ecx
push %edx		#pastram valoarea din %ecx de dinaintea addului 
push dimensiune_fisier
push descriptor
call ADD
add $8, %esp
pop %edx
pop %ecx
jmp for_citire_descriptor
	


					#GET

afis_get:
push %ecx
push $descriptor_cautat			#citim descriptor_cautat
push $fs
call scanf
add $8, %esp
pop %ecx

push %ecx
push descriptor_cautat
call GET
add $4, %esp
pop %ecx

jmp urmatoarea_op


					#DELETE

afis_del:
push %ecx
push $descriptor_sters			#citim descriptor_sters
push $fs
call scanf
add $8, %esp
pop %ecx

push %ecx
push descriptor_sters
call DEL
add $4, %esp
pop %ecx

afis_pozitii_del:
push %ecx
call AFISARE
pop %ecx	

jmp urmatoarea_op


					#DEFRAGMENTATION

afis_def:
push %ecx
call DEF
pop %ecx

afis_pozitii_def:
push %ecx
call AFISARE
pop %ecx	

jmp urmatoarea_op

et_exit:
pushl $0
call fflush
popl %eax

movl $1,%eax
xorl %ebx,%ebx
int $0x80
