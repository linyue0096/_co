// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/4/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, 
// the screen should be cleared.

//// Replace this comment with your code.
(LOOP)
    // --- 1. 決定填充顏色 (Determine Fill Color) ---
    @KBD        // 讀取鍵盤記憶體位址 24576
    D=M
    
    @SET_BLACK
    D;JGT       // 如果 D > 0 (有按鍵)，跳轉到 SET_BLACK

    // 否則 (沒按鍵)，設定顏色為白色 (0)
    @fill_val
    M=0
    @START_DRAW
    0;JMP       // 跳去開始畫圖

(SET_BLACK)
    // 設定顏色為黑色 (-1，即二進位 1111111111111111)
    @fill_val
    M=-1

(START_DRAW)
    // --- 2. 初始化繪圖變數 (Initialize Drawing) ---
    @8192       // 螢幕大小 (256 rows * 32 words/row = 8192 words)
    D=A
    @R0         // 使用 R0 作為剩餘像素計數器 (counter)
    M=D

    @SCREEN     // 螢幕記憶體起始位址 (16384)
    D=A
    @R1         // 使用 R1 作為當前螢幕位址指標 (current address)
    M=D

(DRAW_LOOP)
    // --- 3. 執行繪圖迴圈 (Drawing Loop) ---
    @R0
    D=M
    @LOOP
    D;JEQ       // 如果計數器 R0 == 0，畫完了，跳回主迴圈 (LOOP) 重新檢查鍵盤

    // 取出剛剛設定的顏色 (fill_val)
    @fill_val
    D=M
    
    // 寫入當前螢幕位址
    @R1
    A=M         // A = 當前螢幕位址
    M=D         // RAM[Address] = 顏色

    // 更新變數
    @R1
    M=M+1       // 指標移到下一個 Word
    @R0
    M=M-1       // 計數器減 1

    @DRAW_LOOP
    0;JMP