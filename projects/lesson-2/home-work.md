1. gas 变化
                                      1      2      3     4      5       6     7     8     9     10
                 transaction cost   22974   23755  24536 25317  26098  26879 27660  28441 29222  30003
calculateRunway 
                 execution cost     1702    2483   3264  4045   4826   5607   6388  7169  7950   8731
随着employee数的增加，遍历所有UE的次数增加，代码执行消耗增加

2. 针对calculateRunway()这个的优化，可以将totalSalary的计算在addEmployee 和 removeEmployee的过程中计算完成，放入storage中的
 
 每次计算calculateRunway()时，可以直接用this.balance / totalSalary
