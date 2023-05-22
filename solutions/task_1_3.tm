012X.

//starea de start, merge la sfarsitul cuvantului pentru a scrie un contor,
//similar cu 1.2
start    *    H go_to_end(write_counter(X))

//se duce la sfarsitul cuvantului si aplica S
go_to_end(S)    #   L   S 
                *   R   go_to_end(S)

//se duce la ultima cifra din numar (inainte de separatorul X)
rewind(S)    X    L    S 
             *    L    rewind(S)

//scrie contorul la sfarsitului cuvantului (mai intai X ca seprataor si dupa contorul,
//care incepe de la 2, deoarece adunam de 1 de 3 ori)
write_counter(c)    2    H       rewind(add1)
                    #    Pc,H    write_counter(2)
                    *    R       write_counter(c)

//scade 1 din contor si dupa ce contorul ajunge la 0 (s-a adunat 1 de 3 ori) se opreste
decrease_counter    2    P1,H    rewind(add1)
                    1    P0,H    rewind(add1)
                    0    P#,L    stop

//aduna 1 la numar in binar
add1    0    P1,H    go_to_end(decrease_counter)
        #    P1,H    go_to_end(decrease_counter)
        1    P0,L    add1

//sterge contorul si accepta
stop    *    P#,H    accept
