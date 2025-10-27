.data
O: .space 4
v: .space 4194304
f: .space 2097152
operatie: .space 4
N: .space 4
descriptor: .space 4
dimensiune_fisier: .space 4
descriptor_cautat: .space 4
descriptor_sters: .space 4
fs: .asciz "%d"
fp: .asciz "%s"
test: .asciz "%d "
afisare: .asciz "%d "
formatPrint: .asciz "%d: ((%d, %d), (%d, %d))\n"
formatPrintGet: .asciz "((%d, %d), (%d, %d))\n"
.text

.global main


AFISARE:
push %ebp
mov %esp, %ebp		
subl $20,%esp			#facem loc pt st,dr st=-4, dr=-8,aux1=-12,aux2=-16,linie=-20

movl $-1,%eax
movl %eax,-4(%ebp)		#st=-1
movl %eax,-8(%ebp)		#dr=-1
xor %ecx,%ecx
xor %ebx,%ebx
xor %eax,%eax

afisare_for_1:
cmp $1024,%ecx
je final_afis
movl $-1,-4(%ebp)		#st=-1
movl $-1,-8(%ebp)		#dr=-1
movl %ecx,-20(%ebp)

xor %ebx,%ebx			#j=0


afisare_for_2:
cmp $1023,%ebx
je verificare_suplimentara
xor %eax,%eax
xor %edx,%edx
movl %ecx,%eax			#eax=i
movl $1024,%esi
mull %esi			#eax=i*1024
add %ebx,%eax			#eax=i*1024+j
xor %edx,%edx

movb (%edi,%eax,1),%dl
movb %dl,-12(%ebp)		#aux1=v[i][j]

inc %eax			#eax=i*1024+j+1

movb (%edi,%eax,1),%dl		#dl=v[i][j+1]

cmpb -12(%ebp),%dl
jne if_2_afis
cmpl $-1,-4(%ebp)		#st=-1?
jne if_2_afis
movl %ebx,-4(%ebp)		#st=j

if_2_afis:
cmpb -12(%ebp),%dl
jne if_3_afis
cmpl $-1,-4(%ebp)		#st=-1?
je if_3_afis
movl %ebx,-8(%ebp)		#dr=j

if_3_afis:
cmpb -12(%ebp),%dl
je pas_for_2
cmpb $0,-12(%ebp)
je resetare_st_dr


addl $1, -8(%ebp) 		#dr++


movl %ecx,-16(%ebp)		#aux2=i

				#afisare pozitii

xor %eax,%eax
xor %edx,%edx
movl %ecx,%eax			#eax=i
movl $1024,%esi
mull %esi			#eax=i*1024
add %ebx,%eax			#eax=i*1024+j
xor %edx,%edx

movb (%edi,%eax,1),%dl

push %ebx
push %ecx

movl -4(%ebp),%ebx		#ebx=st
movl -8(%ebp),%ecx		#ecx=dr
movl -16(%ebp),%eax		#eax=i

push %ecx
push %eax
push %ebx
push %eax
push %edx
push $formatPrint
call printf
add $24,%esp

pop %ecx
pop %ebx


movl $-1,-4(%ebp)		#st=-1
movl $-1,-8(%ebp)		#dr=-1
jmp pas_for_2


resetare_st_dr:
movl $-1,-4(%ebp)		#st=-1
movl $-1,-8(%ebp)		#dr=-1

pas_for_2:
inc %ebx
jmp afisare_for_2

verificare_suplimentara:
xor %eax,%eax
xor %edx,%edx
movl -20(%ebp),%eax			#eax=linie
movl $1024,%esi
mull %esi			#eax=linie*1024
add $1023,%eax			#eax=linie*1024+1023
xor %edx,%edx

movb (%edi,%eax,1),%dl
cmp $0,%edx
je pas_afisare_for_1
movl -8(%ebp),%ebx
inc %ebx
movl %ebx,-8(%ebp)

push %ecx
movl -4(%ebp),%ebx		#ebx=st
movl -8(%ebp),%ecx		#ecx=dr
movl -20(%ebp),%eax		#eax=i

push %ecx
push %eax
push %ebx
push %eax
push %edx
push $formatPrint
call printf
add $24,%esp
pop %ecx


pas_afisare_for_1:
inc %ecx
jmp afisare_for_1


final_afis:
addl $16, %esp
mov %ebp, %esp        
pop %ebp              
ret



ADD:	
push %ebp
mov %esp, %ebp		
subl $16,%esp			#facem loc pt nr,poz,memorie si linie nr=-4, poz=-8, memorie=-12,linie=-16

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

for_1_add:
cmp $1024,%ecx				#ecx=0=i
je verificare_memorie

xor %ebx,%ebx			#j=0
movl $0,-4(%ebp)		#nr=0
movl $-1,-8(%ebp)		#poz=-1
movl %ecx,-16(%ebp)		#linie=i

for_2_add:
cmp $1024,%ebx	
je verificare2_locuri0

xor %edx,%edx
movl %ecx,%eax			#eax=i
movl $1024,%esi
mull %esi			#eax=i*1204
add %ebx,%eax			#eax=i*1024+j



movb (%edi, %eax, 1), %dl
cmpb $0, %dl				#v[i][j]==0?
jne else_i_add				#v[i][j]!=0

addl $1,-4(%ebp)			#nr++

cmpl $-1,-8(%ebp)
jne verificare1_locuri0			
movl %ebx,-8(%ebp)			#poz=j
jmp verificare1_locuri0

else_i_add:			
movl $0,-4(%ebp)			#nr=0
movl $-1, -8(%ebp) 			#poz=-1

verificare1_locuri0:
movl -4(%ebp),%eax			#eax=nr
cmp %eax,-12(%ebp)			#memorie==nr
je verificare2_locuri0
inc %ebx
jmp for_2_add

verificare2_locuri0:
movl -4(%ebp),%eax			#eax=nr
cmp %eax,-12(%ebp)			#memorie==nr
je verificare_memorie
inc %ecx
jmp for_1_add


verificare_memorie:
movl -4(%ebp),%ebx			#ebx=nr
cmp -12(%ebp),%ebx		#memorie??nr
jl prea_mare

movl -8(%ebp),%ecx		#ecx=j=poz
movl %ecx, %ebx
add -4(%ebp), %ebx		#ebx=poz+nr

for_j_add:
cmp %ecx, %ebx
je afiseaza_pozitiile

xor %edx,%edx
movl -16(%ebp),%eax			#eax=linie
movl $1024,%esi
mull %esi			#eax=linie*1204
add %ecx,%eax			#eax=linie*1024+j

mov 8(%ebp),%dl			#edx=descriptor
movb %dl,(%edi,%eax,1)		#v[linie][j]=descriptor

inc %ecx
jmp for_j_add

afiseaza_pozitiile:
dec %ecx 			#j--
mov -8(%ebp),%ebx		#ebx=poz
movl 8(%ebp),%edx		#edx=descriptor
movl -16(%ebp),%eax		#eax=linie

#afisam pozitia
push %ecx
push %eax
push %ebx
push %eax
push %edx
push $formatPrint
call printf
add $24, %esp

jmp sfarsit_add

prea_mare:
mov 8(%ebp),%edx		#edx=descriptor
mov $0,%eax
push %eax
push %eax
push %eax
push %eax
push %edx
push $formatPrint
call printf
add $24, %esp

sfarsit_add:
addl $16, %esp
mov %ebp, %esp        
pop %ebp              
ret

GET:
push %ebp
mov %esp, %ebp		
subl $12,%esp			#facem loc get_st=-4, get_dr=-8, get_linie=-12

xor %ecx,%ecx
xor %eax,%eax

movl $-1,%eax
movl %eax, -4(%ebp)		#get_st=-1
movl %eax, -8(%ebp)		#get_dr=-1

movl $-1,%ecx			#ecx=-1

for_1_get:
inc %ecx
cmp $1024,%ecx
je afis_get_pozitii

movl $-1,%ebx			#ebx=-1

for_2_get:
inc %ebx
cmp $1024,%ebx
je for_1_get

movl %ecx, %eax			#eax=i
movl $1024,%esi		
mull %esi			#eax=i*1024
add %ebx,%eax			#eax=i*1024+j
xor %edx,%edx

movb (%edi,%eax,1),%dl		#edx=v[i][j]
cmpb %dl,8(%ebp)		#v[i][j]??descriptor_cautat
jne if_get_2
movl $-1,%eax
cmp %eax,-4(%ebp)
jne if_get_2
movl %ebx,-4(%ebp)		#get_st=j
movl %ecx,-12(%ebp)		#get_linie=i

if_get_2:
cmpb %dl,8(%ebp)		#v[i][j]??descriptor_cautat
jne for_2_get
movl $-1,%eax
cmp %eax,-4(%ebp)
je for_2_get
mov %ebx,-8(%ebp)		#get_dr=j

jmp for_2_get


afis_get_pozitii:
movl -4(%ebp),%eax		#eax=get_st
movl -8(%ebp),%ebx		#ebx=get_dr

cmp $-1,%eax
jne else_get_afis
inc %eax			#eax=0
push %eax
push %eax
push %eax
push %eax
push $formatPrintGet
call printf
add $4,%esp
pop %eax
pop %eax
pop %eax
pop %eax
jmp sfarsit_get

else_get_afis:
movl -12(%ebp),%ecx

push %ebx
push %ecx
push %eax
push %ecx
push $formatPrintGet
call printf
add $20,%esp

sfarsit_get:
addl $12, %esp
mov %ebp, %esp        
pop %ebp              
ret



DEL:
push %ebp
mov %esp, %ebp		

movl $-1,%ecx			#ecx=i=-1


for_1_del:
inc %ecx			#ecx=i=0
cmp $1024, %ecx
je sfarsit_del

movl $-1,%ebx			#ebx=j=-1
for_2_del:
inc %ebx			#j++
cmp $1024,%ebx
je for_1_del

xor %edx,%edx
movl %ecx, %eax			#eax=i
movl $1024,%esi		
mull %esi			#eax=i*1024
add %ebx,%eax			#eax=i*1024+j
xor %edx,%edx

movb (%edi,%eax,1), %dl		#dl=v[i][j]
cmpb %dl, 8(%ebp)
jne for_2_del
xor %edx,%edx
movb %dl,(%edi,%eax,1)		#v[i][j]=0
jmp for_2_del

sfarsit_del:
mov %ebp, %esp
pop %ebp
ret


DEF:
push %ebp
mov %esp, %ebp
subl $40,%esp 		#facem loc pt st=-4,dr=-8,cnt=-12,st2=-16,dr2=-20,k=-24,sum=-28,aux_j=-32,aux=-36,aux2=-40

lea f,%ebx
xor %ecx,%ecx
et_for:
cmp $2097152,%ecx
je final_init
movl $0,(%ebx,%ecx,4)

final_init:
movl $-1,-4(%ebp)		#st=-1
movl $-1,-8(%ebp)		#dr=-1
movl $0,-12(%ebp)		#cnt=0
movl $0,-16(%ebp)		#st2=0
movl $0,-20(%ebp)		#dr2=0
movl $0,-24(%ebp)		#k=0
movl $0,-28(%ebp)		#sum=0


xor %ecx,%ecx

for_1_def:
cmp $1024,%ecx
je sarim_la_3_def
movl $-1,-4(%ebp)		#st=-1
movl $-1,-8(%ebp)		#dr=-1

xor %edx,%edx			#j=0

for_2_def:
cmp $1024,%edx
je pas_for_1_def

movl %edx,-32(%ebp)

xor %edx,%edx
movl %ecx, %eax			#eax=i
movl $1024,%esi		
mull %esi			#eax=i*1024
addl -32(%ebp),%eax			#eax=i*1024+j
movb (%edi,%eax,1),%dl
movb %dl,-36(%ebp)			#aux=v[i][j]

inc %eax
movb (%edi,%eax,1),%dl			#dl=v[i][j+1]
movb %dl,-40(%ebp)			#aux2=v[i][j+1]

movl -32(%ebp),%edx

cmpb $0,-36(%ebp)
je else_if_def
movb -36(%ebp),%al
cmpb %al,-40(%ebp)
jne else_if_def

movl %edx,-8(%ebp)			#dr=j
addl $1,-8(%ebp)			#dr=j+1
cmpl $-1,-4(%ebp)
jne pas_for_2_def
movl %edx,-4(%ebp)			#st=j
jmp pas_for_2_def



else_if_def:
cmpb $0,-36(%ebp)  
je pas_for_2_def
movl %edx,-8(%ebp)			#dr=j

movl -12(%ebp),%eax			#eax=cnt

push %edx

movl -8(%ebp),%edx			#edx=dr
subl -4(%ebp),%edx			#edx=dr-st
inc %edx				#edx=dr-st+1

movl %edx,(%ebx,%eax,4)

pop %edx

addl $1,-12(%ebp)			#cnt++

movl $-1,-4(%ebp)			#st=-1
movl $-1,-8(%ebp)			#dr=-1

pas_for_2_def:
inc %edx
jmp for_2_def

pas_for_1_def:
inc %ecx
jmp for_1_def




sarim_la_3_def:
xor %ecx,%ecx
xor %edx,%edx

for_3_def:
xor %edx,%edx			#j=0
cmp $1024,%ecx
je sfarsit_def

for_4_def:
cmp $1024,%edx
je pas_for_3_def
movl -12(%ebp),%eax			#eax=cnt
cmp %eax,-24(%ebp)
je sfarsit_def

movl -24(%ebp),%eax			#eax=k

push %edx
movl (%ebx,%eax,4),%edx			#edx=f[k]
movl %edx,%eax				#eax=f[k]
pop %edx

addl -28(%ebp),%eax			#eax=sum+f[k]

cmp $1024,%eax
jle avem_loc
addl $1,-16(%ebp)			#st2++
movl $0,-20(%ebp)			#dr2=0
movl $0,-28(%ebp)			#sum=0

avem_loc:
movl %edx,-32(%ebp)

xor %edx,%edx
movl %ecx, %eax			#eax=i
movl $1024,%esi		
mull %esi			#eax=i*1024
add -32(%ebp),%eax			#eax=i*1024+j
movb (%edi,%eax,1),%dl
mov %dl,-36(%ebp)			#aux=v[i][j]

inc %eax
xor %edx,%edx
movb (%edi,%eax,1),%dl			#dl=v[i][j+1]
movb %dl,-40(%ebp)			#aux2=v[i][j+1]

movl -32(%ebp),%edx

cmpl $0,-36(%ebp)
je pas_for_4_def
xor %eax,%eax
movb -36(%ebp),%al			#al=v[i][j]
cmpb %al,-40(%ebp)
je actualizam_matr

push %edx
movl -24(%ebp),%eax			#eax=k
movl (%ebx,%eax,4),%edx			#edx=f[k]
addl %edx,-28(%ebp)			#sum=sum+f[k]
addl $1,-24(%ebp)			#k++
pop %edx

actualizam_matr:
movl %edx,-32(%ebp)

xor %edx,%edx
movl %ecx, %eax			#eax=i
movl $1024,%esi		
mull %esi			#eax=i*1024
add -32(%ebp),%eax			#eax=i*1024+j
movb (%edi,%eax,1),%dl
movb %dl,-36(%ebp)			#aux=v[i][j]

movl -32(%ebp),%edx

movb $0,(%edi,%eax,1)		#v[i[]j]=0

movl %edx,-32(%ebp)

xor %edx,%edx
movl -16(%ebp), %eax			#eax=st2
movl $1024,%esi		
mull %esi			#eax=st2*1024
add -20(%ebp),%eax			#eax=st2*1024+dr2

movb -36(%ebp), %dl		#dl=aux2=v[i[]j]
movb %dl,(%edi,%eax,1)		#v[st2][dr2]=aux2


movl -32(%ebp),%edx


addl $1,-20(%ebp)		#dr2++

pas_for_4_def:
inc %edx
jmp for_4_def

pas_for_3_def:
inc %ecx
jmp for_3_def

sfarsit_def:
addl $40,%esp
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
			
push %ecx
call AFISARE
pop %ecx

jmp urmatoarea_op


					#DEFRAGMENTATION

afis_def:
push %ecx
push %ebx
call DEF
pop %ebx
pop %ecx


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
