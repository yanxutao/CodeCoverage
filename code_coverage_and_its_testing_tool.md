1\. 代码覆盖率[1]
================

代码覆盖率指的是代码执行时的覆盖程度。主要度量方式包括：语句覆盖率，分支覆盖率，条件覆盖率，路径覆盖率，函数覆盖率和循环覆盖率。

语句覆盖率用来度量程序中每个可执行语句是否被执行到了；

分支覆盖率用来度量程序中每个分支是否被执行到了；

条件覆盖率用来度量判定中每个子表达式的true和false结果是否都被测试到了；

路径覆盖率用来度量程序中所有可能的执行路径是否都被执行到了；

函数覆盖率用来度量程序中的每个函数是否都被调用过；

循环覆盖率用来度量程序中的循环体是否被执行了零次、一次或多次。

2\. C/C++代码覆盖率测试工具
=========================

2.1 gcov和lcov
--------------

gcov是一个C/C++程序覆盖率（语句、分支和函数覆盖率）测试工具[2]，是GCC（GNU
[Compiler
Collection](https://en.wikipedia.org/wiki/GNU_Compiler_Collection)）套件的标准组件[3]。gcov可以统计出源文件中每一行代码被执行的次数[4]。GCC的源码可以从[5]或[6]上获得。

lcov是gcov的图形化前端工具，由Linux Test
Project维护，最初被设计用来测试Linux内核的覆盖率[7]。lcov根据gcov产生的数据，配合genhtml工具生成覆盖率测试结果的HTML文档[8]。lcov的源码可以从[8]或[9]上获得。

2.2 gcov的使用[4]
-----------------

(1) 编译

gcc -fprofile-arcs -ftest-coverage -o test test.c

\-fprofile-arcs -ftest-coverage告诉编译器生成gcov需要的额外信息。该命令在生成可执行文件test的同时生成test.gcno文件（记录程序的行信息和流图信息）。

 (2) 收集信息

./test

执行该程序，生成test.gcda文件（记录程序的执行信息）。

(3) 生成报告

gcov test.c

生成test.c.gcov文件，该文件记录了每行代码被执行的次数。

2.3 lcov的使用 [7]
------------------

(1) 收集覆盖率数据 

lcov --capture --directory . --output-file test.info

收集.gcda文件中的覆盖率数据，写入test.info文件，.表示当前目录。

(2) 生成HTML文档 

genhtml test.info --output-directory output

(3) 网页显示

google-chrome output/index.html

3\. gcov的实现原理
=================

3.1 基本概念[10]
----------------

基本块BB指的是一段程序，这段程序的特点是：如果第一条语句被执行了一次，那么这段程序中所有的语句都被执行了一次。一个BB中所有语句的执行次数是相同的，一般由多条顺序执行语句和一条跳转语句组成。BB的最后一条语句通常是一条跳转语句，跳转的目的地是另外一个BB的第一条语句；如果跳转是有条件的，那么就产生了分支，该BB就有两个BB作为目的地。如果知道了每个BB的执行次数，就可以知道程序中所有语句的执行次数。

从一个BB到另外一个BB的跳转叫做一个ARC。如果把BB作为节点，ARC作为边，那么程序中所有的BB和ARC就构成了一个有向图。因为有向图中所有节点的入度之和等于出度之和，所以根据部分BB或ARC的大小就可以推断出所有BB和ARC的大小。

3.2 实现原理
------------

gcov通过ARC的执行次数来推断BB的执行次数，通过对部分ARC插桩，统计出所有BB的执行次数。gcov只负责数据处理和结果显示。被测程序的预处理、插桩和编译由GCC完成。GCC首先对被测程序进行预处理，然后编译生成汇编文件，在生成汇编文件的同时完成插桩。最后汇编生成目标文件。程序运行过程中桩点负责收集程序的执行信息[10]。

编译时加入–fprofile-arcs和–ftest-coverage选项，GCC会执行下列操作[11]：

1）生成\*.gcno文件，记录程序的行信息和流图信息，供gcov计算覆盖率时使用；

2）在输出的目标文件中留出一段存储区来保存统计数据；

3）在源代码中每行可执行语句生成的代码之后附加一段更新覆盖率统计结果的代码；

编译生成的可执行文件在进入被测程序的main函数之前调用gcov_init内部函数初始化统计数据区，并将gcov_exit内部函数注册为exit
handlers；

被测程序调用exit 正常结束时，gcov_exit函数得到调用，其继续调用 \__gcov_flush
函数将统计数据输出到 \*.gcda 文件中。

4\. 参考资料
===========

1.  <http://www.cnblogs.com/coderzh/archive/2009/03/29/1424344.html>
2.  <http://blog.csdn.net/sysmedia/article/details/53609492>
3.  https://en.wikipedia.org/wiki/Gcov
4.  <http://blog.csdn.net/livelylittlefish/article/details/6321861>
5.  https://gcc.gnu.org/wiki/GitMirror
6.  https://github.com/gcc-mirror/gcc
7.  <http://blog.csdn.net/livelylittlefish/article/details/6321887>
8.  <http://ltp.sourceforge.net/coverage/lcov.php>
9.  https://github.com/linux-test-project/lcov
10. http://blog.csdn.net/kelsel/article/details/52758171
11. http://blog.csdn.net/maray/article/details/40401577
