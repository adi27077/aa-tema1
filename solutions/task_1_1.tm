01XABE.

//starea marcheaza prima cifra din numar ca delimitator A pt 1 si B pt 0
start    1    PA,H    start
         0    PB,H    start 
         *    H       go_to_end(take_digit)

//se duce la sfarsitul cuvantului (inainte de X sau #) si aplica starea S
//daca intalneste caracterul E folosit pt marcarea incheierii subrutinei, se accepta
go_to_end(S)    #    L       S
                X    L       S
                E    PX,H    accept
                *    R       go_to_end(S)

//se duce la inceputul cuvantului si aplica S (direct pe pozitia cu # deoarece acolo se va scrie cifra shiftata)
rewind(S)    #    H    S
             *    L    rewind(S)

//ia cifra din cuvant si o shifteaza inainte de cuvant
//in cazul in care cifra este A sau B (adixa 1 sau 0 marcati ca delimitator) se 
//pune E in loc de X pt a marca sfarsitul shiftarii
take_digit    0    PX,H    rewind(put_digit(0))
              1    PX,H    rewind(put_digit(1))
              A    PE,H    rewind(put_digit(1))
              B    PE,H    rewind(put_digit(0))
              X    L       take_digit

//pune cifra c pe casuta
put_digit(c)   *   Pc,H    go_to_end(take_digit)
