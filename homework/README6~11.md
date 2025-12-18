# 6(二進位組合元)
## add
* [參考教授答案](https://github.com/ccc114a/cpu2os/blob/master/_nand2tetris/06/add.asm)
* 定義:主要是驗證組譯器能否正確翻譯最原始的A-指令(@2)與C-指令(D=A、D=D+A)，而不需經過符號表的處理。
* 運作:
1. 載入常數/數據: 讀取第一個數值(@2或RAM[0])並存入D暫存器
2. 執行加法: 讀取第二個數值 (@3、RAM[1])，並指令ALU執行加法 (D=D+A或D=D+M)
3. 儲存結果:將D暫存器的運算結果寫入指定的記憶體位址 (@0、RAM[0])，組譯器需將這些助記碼精確轉換為對應的16位元二進位碼
* [使用Gemini說明add，並且請AI幫我說明add答案程式碼](https://gemini.google.com/share/26d509a24bce)
* ![Computer電路圖](.jpg)

## sum
* [參考教授答案](https://github.com/ccc114a/cpu2os/blob/master/_nand2tetris/06/sum.asm)
* 定義:這是一個進階的測試檔案，變數符號(@i, @sum)、流程標籤((LOOP), (END)). 目的是驗證組譯器的符號表功能，確認是否能將標籤解析為正確的ROM位址，並將變數自動分配到RAM[16]以後的空間
* 運作:
1. 符號解析與初始化:組譯器首先掃描並記錄(LOOP)等標籤位置，執行時初始化變數@i與@sum(組譯器需將其映射為RAM位址)
2. 條件判斷 (C-指令跳轉):載入計數器@i與邊界值，計算差值，滿足終止條件@END與JMP跳轉至程式尾端。
3. 執行累加:@i的值加至@sum，組譯器需正確翻譯這些涉及變數記憶體操作的指令。
4. 迴圈跳轉:執行@LOOP與0;JMP，組譯器必須將@LOOP替換為該標籤在ROM中的行號，確保程式能正確跳回開頭。
* [使用Gemini去了解sum定義和運作，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/d75c0e36c2b1)

# 7(虛擬機)
## SimpleAdd
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* 定義:這是VM翻譯器最基礎的測試檔案，僅測試堆疊運算中的push constant與add指令，不屬於任何記憶體區段，專注於驗證堆疊指標(SP)的移動與ALU的加法功能。
* 運作:
1. 推入常數7:執行push constant 7，翻譯器生成代碼將數值7寫入當前堆疊指標(SP)指向的記憶體位置，並將SP指標加 1。
2. 推入常數8:執行push constant 8，翻譯器生成代碼將數值8寫入當前SP指向的位置，並將SP指標再加1。
3. 執行加法:執行add指令。翻譯器生成代碼，先從堆疊彈出(Pop)兩個數值(先彈出8，再彈出7)，利用ALU計算兩者之和(15)，最後將結果推回(Push)堆疊頂端覆寫舊值。
* [使用Gemini去了解SimpleAdd定義和運作、堆疊概念，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/c6d8f6b3dfa8)

## StackTest
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* 定義:這是一個堆疊運算測試，涵蓋了算術(add, sub, neg)與邏輯比較(eq, gt, lt, and, or, not)，主要驗證翻譯器能否正確處理布林值
* 運作:
1. 比較運算:推入兩個數值，執行 eq，底層邏輯是兩數相減，若結果為 0，則跳轉至設定為 -1 (True) 的標籤，否則設為 0 (False)。
2. 邏輯運算:執行位元運算，將堆疊頂端兩數取出進行OR運算後推回結果。
3. 結果驗證:最終堆疊內會留下一系列運算後的數值(如 -1, 0, -1...)，供測試腳本比對是否符合預期行計算，確保變數存取邏輯與堆疊指標的運作互不衝突。
* [使用Gemini去了解Computer定義和運作，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/b05f3c5a7e7e)

## BasicTest
* [參考havivha](https://github.com/havivha/Nand2Tetris/blob/master/07/MemoryAccess/BasicTest/BasicTest.vm)
* 定義:這是針對虛擬記憶體區段(local, argument, this, that, temp)的核心測試。它驗證VM是否能正確解析基底位址+索引的存取模式，確保不同區段間的數據不會互相覆蓋
* 運作:
1. 寫入區段(Pop):執行pop local0。翻譯器讀取LCL指標(RAM[1])的值，加上索引0，計算出目標實體位址，將堆疊頂端數值存入該處。
2. 讀取區段 (Push):執行push argument 1。翻譯器讀取ARG指標(RAM[2])的值，加上索引1，從該實體位址讀取數值並推入堆疊。
3. 運算驗證:將從不同區段讀回的數值進行加減運算(add, sub)，確認數據的一致性。
* [使用Gemini去了解BasicTest定義和運作，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/4d6c59371f90)

## PointerTest
* [參考havivha](https://github.com/havivha/Nand2Tetris/blob/master/07/MemoryAccess/PointerTest/PointerTest.vm)
* 定義:這是專門針對pointer區段(pointer 0 與 1)的測試。驗證VM能否允許程式直接修改THIS(RAM[3])與THAT(RAM[4])指標本身
* 運作: 程式操作邏輯如下：
1. 修改THIS指標:執行push constant 3030, pop 
pointer 0。這會將數值 3030直接寫入RAM[3] (而非 RAM[3] 指向的地方)。
2. 修改THAT指標:執行push constant 3040, pop pointer 1。將數值3040寫入 RAM[4]。
3. 間接存取驗證:隨後執行push this 2，VM會使用剛剛寫入RAM[3]的3030作為基底，去存取位址3032(3030+2)的資料。
* [使用Gemini去了解PointerTest定義和運作，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/707ce85875ac)

## StaticTest
* [參考havivha](https://github.com/havivha/Nand2Tetris/blob/master/07/MemoryAccess/StaticTest/StaticTest.vm)
* 定義:針對static(靜態變數)的測試，驗證VM翻譯器如何利用組譯器的符號解析能力，將static i映射到全域的組合語言符號(@FileName.i)，確保變數在函數調用或堆疊操作間能持久保存。
* 運作:
1. 寫入靜態變數:執行push constant 111, pop static 8。翻譯器生成組合語言@StaticTest.8, M=D，將數值存入由組譯器分配的RAM[16+] 空間。
2. 堆疊干擾: 執行其他堆疊操作，改變 SP 的位置。
3. 讀取靜態變數:執行push static 8。翻譯器生成 @StaticTest.8, D=M，將該位置的數值讀回。
4. 結果: 驗證即使堆疊內容改變，靜態變數區的數值 (111) 依然完好無損
* [使用Gemini去了解StaticTest定義和運作，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/695c42a4d55d)

# 8(虛擬機)
## BasicLoop
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* 定義:這是一個基礎的流程控制測試程式，目標是計算1加到N的總和，主要目的是驗證VM翻譯器能否正確處理標籤定義(label)和條件跳轉(if-goto)，實現類似while、for的迴圈結構。
* 運作:
1. 初始化:將輸入參數N推入堆疊，並將總和變數(local 0)初始化為0。
2. 標籤(label):定義迴圈起始點LOOP_START。
3. 運算:將N加到總和中，並將 N 減 1。
4. 條件跳轉(if-goto):將N推入堆疊，N 若不為0(True)，VM 執行跳轉指令回到LOOP_START，若N為0(False)，則忽略跳轉，繼續往下執行並將結果推入堆疊頂端。
* [使用Gemini去了解BasicLoop定義和運作(和if-go)，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/334edc3eb175)

## FibonacciSeries
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* 定義:這是一個結合了無條件跳轉和記憶體指標的測試程式。它在 RAM 中依序生成費氏數列的前N項，為了驗證翻譯器能否處理強制跳轉邏輯，以及利用that指標動態存取陣列。
* 運作:
1. 輸入參數:程式執行前，由外部設定好參數，argument 0：數列總長度
argument 1：指定的記憶體位址
2. 初始化:手動將數列前兩項(0, 1)寫入記憶體，並設定剩餘迴圈次數。
3. 迴圈邏輯:進入MAIN_LOOP_START，讀取前兩個數相加，寫入當前that指向的位置。
4. 指標移動:計算pointer1+1，將THAT指標往後移動一格 (Pointer Arithmetic)。
5. 無條件跳轉:迴圈結束後，執行goto END_PROGRAM跳過中間的程式碼，直接結束執行。
* [使用Gemini去了解FibonacciSeries定義和運作，迭代法說明，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/aa3339165749)

## SimpleFunction
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* 定義:這是一個函式定義(function)和返回(return)的單元測試(不包含 call)。目的是驗證翻譯器在進入函式時，是否能正確初始化區域變數 (Local Variables)，並在返回時正確恢復呼叫者的記憶體狀態 (Restore Caller's State)。
運作:
1. 函式進入:讀取指令function SimpleFunction.test 2，翻譯器生成代碼，將LCL指標指向當前堆疊頂端，並推入2個0以初始化 2 個區域變數。
2. 執行運算:對local 0與local 1執行簡單的堆疊加法與邏輯 not。
3. 函式返回:讀取指令 return。翻譯器生成復原代碼：將結果複製到 ARG[0]，重設 SP = ARG + 1，並依序從堆疊框架(Frame)中恢復THAT,THIS,ARG,LCL與返回位址(RetAddr)，最後跳轉回該位址。
* [使用Gemini去了解SimpleFunction定義和運作，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/63340e6263f4)

## FibonacciElement
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* 定義:這個包含兩個目錄Sys.vm(系統入口)與Main.vm(邏輯核心)，使用遞迴(Recursion)計算費氏數列，驗證call和return、堆疊框架(Stack Frame)的保存、啟動程式碼(Bootstrap Code)。
* 運作:
1. 啟動引導(Bootstrap):翻譯器在ASM開頭寫入啟動碼，設定SP=256，並呼叫Sys.init
2. 多檔案處理:翻譯器必須能處理跨檔案的函數呼叫(Sys呼叫Main)，翻譯器需將返回位址及LCL, ARG, THIS, THAT 壓入堆疊，並重設ARG指標指向參數，LCL指標指向新框架。
3. 遞迴(Recursion):會產生深層的堆疊操作，它驗證了你的call和return指令是否正確地保存與恢復了LCL (Local), ARG(Argument),THIS,THAT以及返回位址
* [使用Gemini去了解FibonacciElement定義和運作和費式數列，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/06fca5f225e7)

## StaticsTest
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* 定義:對static(靜態變數)的測試，驗證VM翻譯器如何利用組譯器的符號解析能力處理[靜態變數的命名空間]，不同檔案裡的static 0，其實是兩個完全不同的變數。
* 運作:
1. 設定變數:Sys.init呼叫Class1.set與Class2.set，分別設定各自的靜態變數。
2. 符號映射:
(1) 在翻譯Class1.vm的pop static 0時，翻譯器生成@Class1.0。
(2) 在翻譯Class2.vm的pop static 0時，翻譯器生成@Class2.0。
3. 讀取驗證: Sys.vm 呼叫 Class1.get 與 Class2.get。翻譯器需確保讀回的數值是各自獨立的，驗證靜態變數的命名空間隔離成功。
* [使用Gemini去了解StaticsTest定義和運作、說明靜態區設，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/e59e6d6beb42)

# 9(高階語言)
## Main
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* 定義:這是Jack應用程式的進入點。主要職責是初始化遊戲物件，啟動遊戲主迴圈，並在遊戲結束後釋放記憶體。
* 運作:
1. 初始化:呼叫SquareGame new()建構子，建立一個遊戲實例存入變數game。
2. 執行:呼叫game.run()方法，將控制權移交給遊戲物件，程式進入遊戲的互動迴圈。
3. 清理:當run()方法結束，釋放該物件佔用的記憶體空間，結束程式。
* [使用Gemini去了解Main定義和運作，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/899db17aae88)

## Square
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* 定義: 這是負責處理遊戲邏輯與使用者輸入的控制器類別。它管理著一個Square物件，並透過一個無窮迴圈監聽鍵盤輸入，根據按鍵觸發對應的移動或變形指令。展示了建構子(Constructor)、解構子與I/O處理。
* 運作:
1. 建構(new):建立一個新的Square物件
2. 繪圖與清除(Drawing):使用 OS 內建的 Screen 類別來繪製實心矩形，draw是畫黑色(顯示)，erase是畫白色(清除/背景色)
3. 改變大小(Resizing)
變大或變小(按鍵為方向鍵254~510，設定移動方向變數)
4. 移動邏輯與優化(Movement Optimization)為了移動看起來更順暢且減少閃爍，作者在移動方法(moveUp, moveDown)使用了局部重繪的技巧，而不是全部擦掉重畫
* [使用Gemini去了解Square定義和運作、說明靜態區設，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/b2b2065f442c)

## SquareGame
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* [使用Gemini去了解SquareGame定義和運作、說明靜態區設，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/1c9067fae058)

# 10 (編譯器)
## ArrayTest
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* 詢問使用者要輸入幾個數字，接收這些數字後存入陣列，最後計算並顯示它們的平均值
* [使用Gemini去了解ArrayTest定義和運作，並且請AI幫我說明巢狀表達式和解答的程式碼](https://gemini.google.com/share/415f82c7663c)

## ExpressionlessSquare
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* 
* [使用Gemini去了解ExpressionlessSquare定義和運作、，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/0fa9426fa9d1)

## Square
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* [使用Gemini去了解ExpressionlessSquare定義和運作、，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/0fa9426fa9d1)


# 11(編譯器)
## Average
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* 計算一組整數的平均值
* [使用Gemini去了解Average定義和運作，了解堆積區，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/4a0241a44089)

## ComplexArrays
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* 測試Jack編譯器處理複雜陣列操作與**記憶體位址**的能力
* [使用Gemini去了解ExpressionlessSquare定義和運作、，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/7d74c0b17c5b)

## ConvertToBin
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* 軟體如何直接操作硬體記憶體
* [使用Gemini去了解ExpressionlessSquare定義和運作、，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/0d93846b9273)

## Pong
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* 小遊戲
* [使用Gemini去了解Seven定義和運作、，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/51e1bc659a71)

## Seven
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* 測試編譯器是否正確
* [使用Gemini去了解Seven定義和運作、，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/036db40dbe73)

## Square
* [參考havivha](https://github.com/havivha/Nand2Tetris)
* [使用Gemini去了解ExpressionlessSquare定義和運作、，並且請AI幫我說明解答的程式碼](https://gemini.google.com/share/0fa9426fa9d1)