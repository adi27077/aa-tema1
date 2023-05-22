01BD.

//starea de start, incepe cu adaugarea delimitatorului D inainte de cuvant
start    *    L    put_delim

//se duce la sfarsitul benzii
go_to_end(S)    #   L   S 
                *   R   go_to_end(S)

//se duce spre dreapta la delimitatorul D 
go_to_D(S)    D    R    check(S)
              *    R    go_to_D(S)

//se duce spre dreapta la primul delimitator B intalnit
//aplica starea S daca ajunge la B
//daca nu ajunge la niciun B aplica T cand ajunge la delimitatorul B
go_to_B(S, T)    B    R    S 
                 D    H    T 
                 *    R    go_to_B(S, T)  

//se duce spre dreapta pana la orice delimitator
go_to_delim(S)    D    L    S 
                  B    L    S
                  #    L    S 
                  *    R    go_to_delim(S)

//se duce la inceputul benzii
rewind(S)    #    R    S 
             *    L    rewind(S)

//aplica S pe casuta din stanga
go_left(S)    *    L    S

//aplica S pe casuta din dreapta
go_right(S)    *    R    S

//pune delimitatorul D care va separa sirul initial de cel in BCD
put_delim    *    PD,R    shift1

//shifteaza cifrele la stanga, sarind peste caracterele delimitatoare
//merge la stanga pentru a scire cifra
shift_left(c, S)    D    L       shift_leftD(c, S)
                    B    L       shift_leftD(c, S)
                    *    Pc,R    go_right(S)

//cazul de shiftare in care s-a sarit peste un delimitator si este nevoie
//sa se duca de 2 ori la dreapta
shift_leftD(c, S)    D    L       shift_left(c, S)
                     *    Pc,R    go_right(go_right(S))

//starea care pune cifra care trebuie shiftata, sarind peste delimitatori
put(c, S)    D    L       put(c, S)
             B    L       put(c, S)
             #    L       put(c, S)
             *    Pc,L    S

//pasul de shiftare in care, dupa shiftare, vom avea o singura cifra in cel
//mai din stanga grup de biti din BCD
//la trecerea la urmatorul pas se verifica mai intai daca mai sunt cifre
//ramase in BIN, daca da, se verifica grupurile de cate 4 biti din BCD daca 
//sunt mai mari ca 5, iar apoi se trece la urmatorul pas de shiftare
shift1    D    R    shift1
          B    R    shift1
          0    L    shift_left(0, shift1)
          1    L    shift_left(1, shift1)
          #    L    put(#, rewind(go_to_D(rewind(go_to_B(comp5_4(shift2, shift3), rewind(go_to_D(shift2)))))))

//pasul de shiftare in care, dupa shiftare, vom avea 2 cifre in cel mai din stanga
//grup de biti din BCD
//verificarea pentru trecerea la urmatorul pas de shiftare sa face similar ca mai sus
shift2    D    R    shift2
          B    R    shift2
          0    L    shift_left(0, shift2)
          1    L    shift_left(1, shift2)
          #    L    put(#, rewind(go_to_D(rewind(go_to_B(comp5_4(shift3, shift4), rewind(go_to_D(shift3)))))))

//pasul de shiftare in care, dupa shiftare, vom avea 3 cifre in cel mai din stanga
//grup de biti din BCD
//la acest caz se verifica mai intai daca mai sunt cifre in BIN, dupa care se compara acest
//grup de 3 biti cu 5, iar apoi sa incepe compararile cu 5 ale grpururilor de 4 biti
//din BCD daca exista
shift3    D    R    shift3
          B    R    shift3
          0    L    shift_left(0, shift3)
          1    L    shift_left(1, shift3)
          #    L    put(#, rewind(go_to_D(rewind(comp5_3_1))))

//pasul de shiftare in care, dupa shiftare, vom avea un grup complet de 4 biti din BCD
//din acest motiv se adauga inaintea lui delimitatorul B folosit pt separarea grupurilor
//de 4 biti din BCD
//dupa aceea se fac verificari similare cu shift1 si shift2 si se trece la pasul shift1
//daca este posibil
shift4    D    R    shift4
          B    R    shift4
          0    L    shift_left(0, shift4)
          1    L    shift_left(1, shift4)
          #    L    put(#, rewind(add_bcd_delim(go_to_D(rewind(go_to_B(comp5_4(shift1, shift2), rewind(go_to_D(shift1))))))))

//adauaga delimitatorul B folosit pt separarea grupurilor de 4 biti din BCD
add_bcd_delim(S)    #    PB,R    S
                    *    L       add_bcd_delim(S)

//verifica daca mai exista cifre in BIN, daca nu se trece la operatiile finale,
//altfel se continua cu urmatorul pas de shiftare
check(S)    #    L    deleteD
            *    H    rewind(S)

//compararea cu 5 a unui grup de 3 biti din BCD
//se verifica primul bit, daca este 0 avem nr mai mic ca 5 deci se trece
//la pasul urmator(compararea grupurilor de 4 biti, si dupa urm pas de shiftare)
//daca este 1 mergem mai departe sa verificam al doilea bit
comp5_3_1    0    H    rewind(go_to_B(comp5_4(shift4, shift1), go_to_D(shift4)))
             1    R    comp5_3_2

//verificare al 2-lea bit dintr-un grup de 3 biti
//daca este 0 trecem la al 3-lea
//daca este 1 avem nr mai mare ca 5, deci se trece la adunarea cu 3
comp5_3_2    0    R    comp5_3_3
             1    H    go_to_delim(add3_3)

//verificare al 3-lea bit dintr-un grup de 3 biti
//daca este 0, avem nr mai mic ca 5 deci se trece la pasul urmator
//(compararea grupurilor de 4 biti, si dupa urm pas de shiftare)
//daca este 1, avem nr egal cu 5 si mergem la adunarea cu 3
comp5_3_3    0    H    rewind(go_to_B(comp5_4(shift4, shift1), go_to_D(shift4)))
             1    H    go_to_delim(add3_3)

//incepe adunarea cu 3 la un grup de 3 biti
add3_3    *    H    add3_3_1

//adunarea primului 1
//daca avem carry inseamna ca grupul de 3 biti va deveni grup de 4 biti, deci
//se adauha delimitatorul B inaintea lui
add3_3_1    0    P1,H    go_to_delim(add3_3_2)
            #    P1,L    add_bcd_delim(go_to_delim(add3_3_2))
            1    P0,L    add3_3_1

//adunare al doilea 1
//daca avem carry inseamna ca grupul de 3 biti va deveni grup de 4 biti, deci
//se adauha delimitatorul B inaintea lui
add3_3_2    0    P1,H    go_to_delim(add3_3_3)
            #    P1,L    add_bcd_delim(go_to_delim(add3_3_3))
            1    P0,L    add3_3_2

//adunare al treilea 1
//daca avem carry inseamna ca grupul de 3 biti va deveni grup de 4 biti, deci
//se adauha delimitatorul B inaintea lui
//dupa adunare se trece la urmatorul pas(verificarea grupurilor de 4 biti si dupa
//urmatorul pas de shiftare)
add3_3_3    0    P1,H    go_to_B(comp5_4(shift1, shift2), go_to_D(shift1))
            #    P1,L    add_bcd_delim(go_to_B(comp5_4(shift1, shift2), go_to_D(shift1)))
            1    P0,L    add3_3_3

//incepere comparare grup de 4 biti cu 5
comp5_4(S, T)    *    H    comp5_4_1(S, T)

//verificare primul bit din grup de 4 biti
//daca este 0 mergem la verificare al doilea bit
//daca este 1, numarul este mai mare ca 5 si se trece la adunare cu 3
comp5_4_1(S, T)    0    R    comp5_4_2(S, T)
                   1    H    go_to_delim(add3_4(S, T))

//verificare al doilea bit din grup de 4 biti
//daca este 0 avem nr mai mic ca 5 si se merge la compararea urmatorului grup de 4 biti
//daca este 1 mergem la verificare al 3lea bit
comp5_4_2(S, T)    0    H    go_to_B(comp5_4(S, T), go_to_D(S))
                   1    R    comp5_4_3(S, T)

//verificare al 3-lea bit din grup de 4 biti
//daca este 0 mergem la verificare al 4lea bit
//daca este 1 avem nr mai mare ca 5 si mergem la adunare cu 3
comp5_4_3(S, T)    0    R    comp5_4_4(S, T)
                   1    H    go_to_delim(add3_4(S, T))

//verificare al 4-lea bit din grup de 4 biti
//daca este 0 avem nr mai mic ca 5 si se merge la verificarea urmatorului grup de 4 biti
//daca este 1 avem nr egal cu 5 si se merge la adunare cu 3
comp5_4_4(S, T)    0    H    go_to_B(comp5_4(S, T), go_to_D(S))
                   1    H    go_to_delim(add3_4(S, T))

//incepere adunare cu 3 la grup de 4 biti
add3_4(S, T)    *    H    add3_4_1(S, T)

//adunare primul 1
//se sare peste delimitatorul B daca avem carry
//daca avem carry se va crea un nou grup BCD care va avea un bit
//deci se sare un pas de shiftare
//de ex: S este shift1, atunci T este shift2
add3_4_1(S, T)    0    P1,H    go_to_delim(add3_4_2(S, T))
                  1    P0,L    add3_4_1(S, T)
                  B    L       add3_4_1(S, T)
                  #    H       put1(go_to_delim(add3_4_2(T, T)))

//adunare al doilea 1
add3_4_2(S, T)    0    P1,H    go_to_delim(add3_4_3(S, T))
                  1    P0,L    add3_4_2(S, T)
                  B    L       add3_4_2(S, T)
                  #    H       put1(go_to_delim(add3_4_3(T, T)))

//adunare al treilea 1
//dupa se trece la compararea urmatorului grup de 4 biti
//iar daca avem carry se va sari un pas de shiftare
add3_4_3(S, T)    0    P1,H    go_to_B(comp5_4(S, T), go_to_D(S))
                  1    P0,L    add3_4_3(S, T)
                  B    L       add3_4_3(S, T)
                  #    H       put1(go_to_B(comp5_4(T, T), go_to_D(T)))

//pune 1 si dupa se duce la starea S
//(folosit la adunare 3 la grup de 4 biti cand avem carry)
put1(S)    *    P1,H    S

//urmatoarele starti sunt folosite la shiftarea cifrelor din rezultatul
//final, in urma eliminarii delimitatorilor B si D
shift_final    *    R    put_next

put_next    0    L    put(0)
            1    L    put(1)
            #    L    put_space

put(c)    *    Pc,R    shift_final

put_space    *    P#,L    deleteB

//starea dupa ce se termina algoritmul (nu au mai ramas cifre in cuvantul BIN)
//se sterge delimitatorul D si dupa se merge la inceputul rezultatului in
//BCD pt as verifica daca cel mai din stanga grup BCD are 4 biti
//daca nu se adauga 0-uri inaintea lui
deleteD    *    P#,L    rewind(add_zero)

//starile care adauga 0-uri la inceputul primului grup BCD
add_zero    B    H    go_to_end(deleteB)
            *    H    go_to_delim(add_zero1)
            

add_zero1    1    L       add_zero2
             0    L       add_zero2
             #    P0,L    add_zero2

add_zero2    1    L       add_zero3
             0    L       add_zero3
             #    P0,L    add_zero3

add_zero3    1    L       add_zero4
             0    L       add_zero4
             #    P0,L    add_zero4

add_zero4    1    R       go_to_end(deleteB)
             0    R       go_to_end(deleteB)
             #    P0,R    go_to_end(deleteB)

//dupa adaugarea 0-urilor daca a fost necesara, se merge la starea in care
//se sterg si delimitatorii B (cand se sterge unul se shifteaza la stanga bitii
//din dreapta lui)
//dupa ce s-au sters totii delimitatorii B, rezultatul este finalizat si se accepta
deleteB    B    H    shift_final
           #    H    accept 
           *    L    deleteB
