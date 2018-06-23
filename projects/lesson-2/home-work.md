1. gas 变化
  
依次增加UE个数从1到10 calculateRunway()函数execution cost依次是 1702    2483   3264  4045   4826   5607   6388  7169  7950   8731
随着employee数的增加，遍历所有UE的次数增加，代码执行消耗增加

2. 针对calculateRunway()这个的优化

可以将totalSalary的计算在addEmployee 和 removeEmployee的过程中计算完成，放入storage中的
每次计算calculateRunway()时，可以直接用this.balance / totalSalary
