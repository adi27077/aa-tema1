01XABE.

//starea initiala se duce la sfarsit si intra in delim
start    *    H    go_to_end(go_left(delim))

//folosit la inceput pt a aplica delim pe ultima casuta din cuvant deoarece go_to_end
//se opreste pe #, nu revine inapoi cu o casuta
go_left(S)    *    L    S

//similar cu 1.1 doar ca marcheaza ca delimitator ultima cifra din cuvant
delim    1    PA,H    delim
         0    PB,H    delim 
         *    H       rewind(take_digit)

//se duce la inceputul cuvantului (dupa # sau X) si aplica starea S
//daca intalneste caracterul E folosit pt marcarea incheierii subrutinei, se accepta
rewind(S)    #    R       S
             X    R       S
             E    PX,H    accept
             *    L       rewind(S)

//se duce la sfarsitul cuvantului si aplica S (direct pe pozitia cu # deoarece acolo se va scrie cifra shiftata)
go_to_end(S)    #    H    S
                *    R    go_to_end(S)

//ia cifra din cuvant si o shifteaza dupa cuvant
//in cazul in care cifra este A sau B (adixa 1 sau 0 marcati ca delimitator) se 
//pune E in loc de X pt a marca sfarsitul shiftarii
take_digit    0    PX,H    go_to_end(put_digit(0))
              1    PX,H    go_to_end(put_digit(1))
              A    PE,H    go_to_end(put_digit(1))
              B    PE,H    go_to_end(put_digit(0))
              X    R       take_digit

//pune cifra c pe casuta
put_digit(c)   *   Pc,H    rewind(take_digit)
