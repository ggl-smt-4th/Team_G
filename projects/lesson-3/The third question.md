                                                  O
                                              A   B   C
                                                K1  K2
                                                   Z
     
     
     
     L[O] = O
     L[A] = AO
     L[B] = BO
     L[C] = CO
     
     L[K1] = K1 + merge(L[A], L[B], AB)
           = K1 + merge(AO, BO, AB)
           = K1 + A + merge(O, BO, B)
           = K1 + A + B + merge(O, O)
           = K1ABO
          
     L[K2] = k2 + merge(L[A], L[C], AC)
           = K2 + merge(AO, CO, AC)
           = K2 + A + merge(O, CO, C)
           = K2 + A + C + merge(O, O)
           = K2ACO
           
     L[Z]  = Z + merge(L[K1], L[K2], K1K2)
           = Z + merge(K1ABO, K2ACO, K1K2)
           = Z + K1 + merge(ABO, K2ACO, K2)
           = Z + K1 + K2 + merge(ABO, ACO)
           = Z + K1 + K2 + A + merge(BO, CO)
           = Z + K1 + K2 + A + B + merge(O, CO)
           = Z + K1 + K2 + A + B + C + merge(O, O)
           = Z K1 K2 A B C O
     
