012X.

//sterge 0 daca numarul incepe cu 0
//starea de start, merge la sfarsitul cuvantului pentru a scrie un contor,
//similar cu 1.2 si 1.3
start    0    P#,R    start 
         *    H go_to_end(write_counter(X))

//se duce la sfarsitul cuvantului si aplica S
go_to_end(S)    #   L   S 
                *   R   go_to_end(S)

//se duce la ultima cifra din numar (inainte de separatorul X)
rewind(S)    X    L    S 
             *    L    rewind(S)

//scrie contorul la sfarsitului cuvantului (mai intai X ca seprataor si dupa contorul,
//care incepe de la 2, deoarece scadem de 1 de 3 ori)
write_counter(c)    2    H       rewind(sub1)
                    #    Pc,H    write_counter(2)
                    *    R       write_counter(c)

//scade 1 din contor si dupa ce contorul ajunge la 0 (s-a scazut 1 de 3 ori) se opreste
decrease_counter    2    P1,H    rewind(sub1)
                    1    P0,H    rewind(sub1)
                    0    P#,L    stop

//scade 1 din numar binar
//daca am facut o cifra de 1 in 0, verificam daca este prima din cuvant pt a
//o sterge in caz afirmativ
//daca numarul este mai mic ca 3 (se ajunge la # in timpul scaderii) lasam banda goala
sub1    1    P0,H    check_first_digit0(decrease_counter)
        0    P1,L    sub1
        #    R       stop

//sterge cifra 0 de la inceputul cuvantului
delete0(S)    0    P#,R    go_to_end(S)  

//verifica daca o cifra de 0 din numar este la inceputul cuvantului si 
//in caz afirmativ o sterge
check_first_digit0(S)    0    L    check_first_digit0(S)
                         #    R    delete0(S)
                         *    H    go_to_end(S)   

//sterge contorul si accepta
stop    *    P#,H    accept
