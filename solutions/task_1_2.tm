012ABX.

//primul pas este scrierea la sfarsitul cuvantului a unui contor
//(folosit pt numararea cifrelor si pt compararea cu 5 cand cuvantul are 3 cifre)
start    *    H go_to_end(write_counter(X))

//se duce la sfarsitul cuvantului si aplica S
go_to_end(S)    #   L   S 
                *   R   go_to_end(S)

//se duce la inceputul cuvantului si aplica S
rewind(S)    #    R    S 
             *    L    rewind(S)

//sterge casuta curenta si aplica S pe cea din dreapta ei
go_right(S)    *    P#,R    S

//sterge toate casutele din stanga si accepta la finalul operatiei
delete    #    H       accept
          *    P#,L    delete

//scrie contorul la sfarsitului cuvantului (mai intai X ca seprataor si dupa contorul,
//care incepe de la 2)
write_counter(c)    2    H       rewind(compare_digit_count)
                    #    Pc,H    write_counter(2)
                    *    R       write_counter(c)

//scade contorul in timpul compararii nr de cifre al cuvantului
//daca s-a scazut contorul de 3 ori inseamna ca avem cuvant de 3 cifre
//care trebuie comparat cu 5 (101 in binar)
decrease_counter    2    P1,H    rewind(compare_digit_count)
                    1    P0,H    rewind(compare_digit_count)
                    0    P2,H    rewind(go_right(compare_with5))

//scade contorul in timpul compararii cu 5
//se scade maxim de 2 ori deoarece comparatia unui cuvant de 3 cifre cu 5 poate
//incepe de la a 2-a cifra, prima fiind mereu 1
decrease_counter_comp    2    P1,H    rewind(go_right(compare_with5))
                         1    P0,L    rewind(go_right(compare_with5))
                         0    P0,L    delete

//compara nr de cifre al cuvantului si inlocuieste pe 0 cu A si pe 1 cu B pt a marca
//faptul ca aceste cifre au fost deja numarate
//daca se intalneste delimitatorul X inseamna ca avem cuvant de maxim 2 cifre, 
//deci automat mai mic ca 5
compare_digit_count    0    PA,H    go_to_end(decrease_counter)
                       1    PB,H    go_to_end(decrease_counter)
                       A    R       compare_digit_count
                       B    R       compare_digit_count
                       X    R       put0

//compara un cucant de 3 cifre cu 5 (101)
//incepe automat de la a 2-a cifra deoarece prima este mereu 1
//daca avem B(1) drept a 2-a cifra inseamna ca avem deja o valoare mai mare ca 5,
//deci se poate finaliza subrutina cu valoarea 1
//daca avem A(0) drept a 2-a cifra, se scade contorul si se merge la a treia cifra
//daca a treia este B(1) avem fix cuvantul 101 (5), deci putem scrie 1
//daca se intalneste 1 sau 0 inseamna ca avem mai multe cifre decat 3, deci
//valoare cuvantului este automat mai mare ca 5 si se scrie 1
//daca se intalneste delimitatorul X inseamna ca avem cuvant de 2 cifre sau mai putin,
//deci automat mai mic ca 5 si se scrie 0 pe banda
compare_with5    B    H    go_to_end(put1)
                 A    H    go_to_end(decrease_counter_comp)
                 X    H    go_to_end(put0)
                 *    H    go_to_end(put1)

//scrie 0 la sfarsitul cuvantului si sterge tot ce este la stanga
put0    *    P0,L    delete

//scrie 1 la sfarsitul cuvantului si sterge tot ce este la stanga
put1    *    P1,L    delete
