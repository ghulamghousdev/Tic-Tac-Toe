COMMENT &
 Some of the features of the game are:
 1-> when we are playing PvC or PvP, the game accept
	the name of the players.
 2-> When some one win the game, it will display three large
    boxs to show how the winner winning line.
 3->All the codes were completely organazed
&



INCLUDE Irvine32.inc


Start_PvC_Game                   PROTO name_:PTR BYTE, name_size:BYTE
Start_PvP_Game                   PROTO name_1:PTR BYTE, name_size1:BYTE,name_2:PTR BYTE, name_size2:BYTE
Start_CvC_Game			         PROTO

Display_Game_statics             PROTO count1:BYTE,count2:BYTE,count3:BYTE
Display_Game_Menu 	             PROTO
Main_menu_selection  		     PROTO userInput_2:DWORD
Print_Instructions_for_PvC_CvC   PROTO
Print_Instructions_for_to_PvP    PROTO
validate_input 		     		 PROTO userInput_:DWORD, instanceType_:BYTE
Display_Game_Board			     PROTO
Update_Game_Board                PROTO player_type_:BYTE, assign_type_:BYTE, location_:DWORD, gameBoard_:PTR BYTE
Display_Game_Moves               PROTO gameBoard_2:PTR BYTE
Screen_xy_coordinet		         PROTO pos_num_:BYTE
Check_Winner_for_PvP		     PROTO gameBoard_3:DWORD, num_moves_:BYTE, name_221:PTR BYTE,name_222:PTR BYTE, P1_param:BYTE, instanceType_param2:BYTE
Check_Winner_for_PvC_CvC	     PROTO gameBoard_3:DWORD, num_moves_:BYTE, name_:PTR BYTE, P1_:BYTE, instanceType_2:BYTE
Test_the_winner		             PROTO param1:BYTE, param2:DWORD, param3:BYTE, param4:DWORD, param5:BYTE, param6:DWORD, gameBoard_3:PTR BYTE
Display_winner_Draw			     PROTO l_1:BYTE, h_2:BYTE, l_3:BYTE, h_4:BYTE, l_5:BYTE, h_6:BYTE, path_type_:BYTE

.code

main proc
	.data
		userInput1     DWORD 0
		select_option  BYTE "                                                Choice: ", 0

	.code
		Menu: invoke Display_Game_Menu

		Choice: mov eax, Cyan
					   call SetTextColor

					   mov edx, OFFSET select_option
					   call WriteString
					   call ReadInt
							mov userInput1, eax
							INVOKE validate_input, userInput1, 1
							cmp dl, 1
								je Choice
							cmp dl, 2
								je exitProgram

			INVOKE Main_menu_selection, userInput1
			jmp Menu

	exitProgram: exit
main endp

Display_Game_Menu proc
	.data

		Print_Menu BYTE "                                                                      ", 0
				   BYTE "                                          1. Player vs. Computer      ", 0
				   BYTE "                                          2. Computer vs. Computer    ", 0
				   BYTE "                                          3. Player vs. Player        ", 0
				   BYTE "                                          4. exit                     ", 0


	.code

		call Crlf
		call Crlf

		mov ecx, 5
		mov bl, 0
		mov eax, lightGreen
		call SetTextColor
		printMenu2: mov edx, OFFSET Print_Menu
				    mov eax, 0
				    mov al, LENGTHOF Print_Menu
				    mul bl

				    add edx, eax
				    call WriteString
				    call Crlf
				    inc bl
		loop printMenu2

		call Crlf
		call Crlf

		ret

Display_Game_Menu endp


Main_menu_selection PROC x2:DWORD
		.data
			user_input2 EQU [x2 + 4]
			counter_PvC BYTE 0
		    counter_CvC BYTE 0
		    counter_PvP BYTE 0
		.code
			push ebp
			mov ebp, esp

			call Randomize

			cmp user_input2, 1
				je Option1_GO
			cmp user_input2, 2
				je Option2_GO
			cmp user_input2, 3
				je Option3_GO
			cmp user_input2, 4
				je Option4_GO


			Option1_GO: INVOKE Print_Instructions_for_PvC_CvC
						call Clrscr
						inc counter_PvC
						jmp leaveProc2
			Option2_GO: INVOKE Start_CvC_Game
						call Clrscr
						inc counter_CvC
						jmp leaveProc2
			Option3_GO: INVOKE Print_Instructions_for_to_PvP
						call Clrscr
						inc counter_CvC
						jmp leaveProc2
			Option4_GO:	INVOKE Display_Game_statics, counter_PvC, counter_CvC, counter_PvP



	leaveProc2:	leave
	ret


Main_menu_selection ENDP
Display_Game_statics   PROC count1_PvC:BYTE,count2_CvC:BYTE,count3_PvP:BYTE
	.data
		statics_msg_PvC BYTE "                        The number of PvC played is : ",0
		statics_msg_CvC BYTE "                        The number of CvC played is : ",0
		statics_msg_PvP BYTE "                        The number of PvP played is : ",0
	.code
	call Clrscr
	call Crlf
	call Crlf
	call Crlf
	mov eax,green
	call SetTextColor
	mov edx,offset statics_msg_PvC
	call WriteString
	mov eax,blue
	call SetTextColor
	mov al, count1_PvC
	call WriteDec
	call Crlf

	mov eax,green
	call SetTextColor
	mov edx,offset statics_msg_CvC
	call WriteString
	mov eax,blue
	call SetTextColor
	mov al, count2_CvC
	call WriteDec
	call Crlf

	mov eax,green
	call SetTextColor
	mov edx,offset statics_msg_PvP
	call WriteString
	mov eax,blue
	call SetTextColor
	mov al, count3_PvP
	call WriteDec

	call Crlf
	call Crlf
	mov eax,red
	call SetTextColor
	call WaitMsg
	exit
Display_Game_statics ENDP

Print_Instructions_for_PvC_CvC PROC
	.data
			instructions    BYTE "                                                    TIC-TAC-TOE                                         ", 0
						    BYTE "                To win the game,you have to get three Xs in a row on the board before the computer.   ", 0
						    BYTE "                  When chosing a move, enter a number corresponding to the position on the board      ", 0
						    BYTE "                                                                                                      ", 0
			board_instruc BYTE "                                                                                                        ", 0
						  BYTE "                                                           - | - | -                                    ", 0
						  BYTE "                                                           - | - | -                                    ", 0
						  BYTE "                                                           - | - | -                                    ", 0


			name_prompt   BYTE "                               Enter your name to begin: ", 0

			name_str      BYTE 50 DUP(0)
			name_size     BYTE ?
	.code
			push ebp
			mov ebp, esp
			call Clrscr

			mov ecx, 4
			mov bl, 0
			mov eax, lightGreen
			call SetTextColor
			printMenu: mov edx, OFFSET instructions
					   mov eax, 0
					   mov al, LENGTHOF instructions
					   mul bl

					   add edx, eax
					   call WriteString

					   mov eax, yellow
			           call SetTextColor
					   call Crlf
					   inc bl
			loop printMenu

			mov ecx, 4
			mov bl, 0
			mov eax, white
			call SetTextColor
			printMenu2: mov edx, OFFSET board_instruc
					    mov eax, 0
					    mov al, LENGTHOF board_instruc
					    mul bl

					    add edx, eax
					    call WriteString

					    call Crlf
					    inc bl
			loop printMenu2

			call Crlf
			call Crlf

			mov edx, OFFSET name_prompt
			call WriteString

			mov edx, OFFSET name_str
			mov ecx, SIZEOF name_str
			call ReadString
			mov name_size, al

			INVOKE Start_PvC_Game, ADDR name_str, name_size

			leave
	ret
Print_Instructions_for_PvC_CvC ENDP
Print_Instructions_for_to_PvP PROC
	.data
			instructions22  BYTE "                                                    TIC-TAC-TOE                                         ", 0
						    BYTE "                To win the game,you have to get three Xs in a row on the board before the computer.     ", 0
						    BYTE "                  When chosing a move, enter a number corresponding to the position on the board        ", 0
						    BYTE "                                                                                                        ", 0
			board_instruc22 BYTE "                                                                                                        ", 0
						    BYTE "                                                           - | - | -                                    ", 0
						    BYTE "                                                           - | - | -                                    ", 0
						    BYTE "                                                           - | - | -                                    ", 0


			name_prompt21   BYTE "                               Enter player 1 name : ", 0
			name_prompt22   BYTE "                               Enter player 2 name : ", 0

			name_str21      BYTE 50 DUP(0)
			name_size21     BYTE ?

			name_str22      BYTE 50 DUP(0)
			name_size22    BYTE ?
	.code
			push ebp
			mov ebp, esp
			call Clrscr

			mov ecx, 4
			mov bl, 0
			mov eax, lightGreen
			call SetTextColor
			printMenu: mov edx, OFFSET instructions22
					   mov eax, 0
					   mov al, LENGTHOF instructions22
					   mul bl

					   add edx, eax
					   call WriteString

					   mov eax, yellow
			           call SetTextColor
					   call Crlf
					   inc bl
			loop printMenu

			mov ecx, 4
			mov bl, 0
			mov eax, white
			call SetTextColor
			printMenu2: mov edx, OFFSET board_instruc22
					    mov eax, 0
					    mov al, LENGTHOF board_instruc22
					    mul bl

					    add edx, eax
					    call WriteString

					    call Crlf
					    inc bl
			loop printMenu2

			call Crlf
			call Crlf

			mov edx, OFFSET name_prompt21
			call WriteString

			mov edx, OFFSET name_str21
			mov ecx, SIZEOF name_str21
			call ReadString
			mov name_size21, al

			mov edx, OFFSET name_prompt22
			call WriteString

			mov edx, OFFSET name_str22
			mov ecx, SIZEOF name_str22
			call ReadString
			mov name_size22, al

			INVOKE Start_PvP_Game, ADDR name_str21, name_size21,ADDR name_str22,  name_size22

			leave
	ret
Print_Instructions_for_to_PvP ENDP
Start_PvP_Game PROC x31:PTR BYTE, y21:BYTE,x32:PTR BYTE, y22:BYTE
		.data
			player_name21 EQU [x31 + 4]
			sizeOfName21  EQU [y21 + 4]
			player_name22 EQU [x32 + 4]
			sizeOfName22  EQU [y22 + 4]

			gameBoard22	       BYTE 9 DUP(0)
			gameTitle22	       BYTE "  vs  ", 0

			movNumber22	       BYTE 0
			user_selection21     DWORD 0
			user_selection22    DWORD 0
			;//computer_selection DWORD 0
			name_offset21		   DWORD ?
			name_offset22		   DWORD ?
			firstGo22		       BYTE ?
			player_user_type2   BYTE ?
			player_user_type3   BYTE ?
			comp_user_type2     BYTE ?
			runOnce22			   BYTE ?

		.code
			push ebp
			mov ebp, esp


			mov ebx, player_name21
			mov name_offset21, ebx
			cmp runOnce2, 1
				je clearTable

			mov ebx, player_name22
			mov name_offset22, ebx
			cmp runOnce2, 1
				je clearTable




			preGame: mov movNumber2, 1

			mov eax, 0
			mov al, 2
			call RandomRange
			mov firstGo22, al

			jmp Game

			clearTable: mov ecx, 9
						mov al, 0
						mov esi, OFFSET gameBoard22
						zeroOut: mov [esi], al
								 inc esi
						loop zeroOut
						jmp preGame

			Game: call Clrscr

				  mov edx, 0
				  call Gotoxy

				  mov ecx, 50
				  mov eax, 0
				  Spce: mov al, ' '
				  	    call WriteChar
				  loop Spce

				  mov eax, white
				  call SetTextColor


				  mov edx, player_name21
				  call WriteString

				  mov edx, offset gameTitle22
				  call WriteString

				  mov edx, player_name22
				  call WriteString

				  call Crlf
				  call Crlf

				  INVOKE Display_Game_Board
				  INVOKE Display_Game_Moves, ADDR gameBoard22

				  cmp movNumber22, 9
					  jg leaveProc4

				  INVOKE Check_Winner_for_PvP, ADDR gameBoard22, movNumber22, name_offset21,name_offset22, firstGo22, 0
				  cmp dl, 0
					  je keepPlaying
				  cmp dl, 1
					  je leaveProc4
				  cmp dl, 2
					  je leaveProc4

				  keepPlaying:
				  mov dl, 55
				  mov dh, 23
				  call Gotoxy

				  mov eax, 0
				  mov al, movNumber22
				  mov bl, 2
				  div bl

				  cmp firstGo22, 0
					  je player_first
				  cmp firstGo22, 1
					  je computer_first

				  player_first: cmp ah, 1
								    je player_prompt
							    cmp ah, 0
								  je computer_prompt

				  computer_first: cmp ah, 1
									  je computer_prompt
								  cmp ah, 0
									  je player_prompt

				  player_prompt: cmp firstGo22, 0
									 je U_P1

				                 mov eax, lightMagenta
							     call SetTextColor
								 mov player_user_type2, 1
								 jmp cont1

								 U_P1: mov eax, lightGreen
									   call SetTextColor

									   mov player_user_type2, 0

							     cont1: mov edx, player_name21
										call WriteString
										mov al, ':'
										call WriteChar
										mov al, ' '
										call WriteChar
										jmp user_selections

				  computer_prompt: cmp firstGo22, 1
									 je C_P1

				                 mov eax, lightMagenta
							     call SetTextColor
								 mov player_user_type3, 1
								 jmp cont2

								 C_P1: mov eax, lightGreen
									   call SetTextColor

									   mov player_user_type3, 0

							     cont2: mov edx, player_name22
										call WriteString
										mov al, ':'
										call WriteChar
										mov al, ' '
										call WriteChar
										jmp user_selection221

				  user_selections: mov eax, white
								   call SetTextColor

								   mov eax, 0
								   call ReadDec
									  mov user_selection21, eax
									  INVOKE validate_input, user_selection21, 3
										  cmp dl, 1
											  je Game

								   INVOKE Update_Game_Board, 0, player_user_type2, user_selection21, ADDR gameBoard22
								   cmp dl, 1
									  je user_selections

								   inc movNumber22
								   jmp Game

				  user_selection221 : mov eax, white
								   call SetTextColor

								   mov eax, 0
								   call ReadDec
								      mov user_selection22, eax
								      INVOKE validate_input, user_selection22, 3
										  cmp dl, 1
											  je Game

								   INVOKE Update_Game_Board, 2, player_user_type3  , user_selection22, ADDR gameBoard22
								   cmp dl, 1
									  je user_selection221



								   inc movNumber22
								   jmp Game

			leaveProc4: cmp movNumber22, 10
							jne justleave
						INVOKE Check_Winner_for_PvP, ADDR gameBoard22, movNumber22, name_offset21,name_offset22, firstGo22, 0
			justleave:	mov runOnce2, 1
			            leave
	ret
Start_PvP_Game ENDP

Start_PvC_Game PROC x3:PTR BYTE, y2:BYTE
		.data
			player_name EQU [x3 + 4]
			sizeOfName  EQU [y2 + 4]

			gameBoard	       BYTE 9 DUP(0)

			gameTitle	       BYTE " vs. Computer", 0
			computerMove       BYTE "Computer: ", 0

			movNumber	       BYTE 0
			user_selection     DWORD 0
			computer_selection DWORD 0
			name_offset		   DWORD ?
			firstGo		       BYTE ?
			player_user_type   BYTE ?
			comp_user_type     BYTE ?
			runOnce			   BYTE ?

		.code
			push ebp
			mov ebp, esp

			mov ebx, player_name
			mov name_offset, ebx
			cmp runOnce, 1
				je clearTable

			preGame: mov movNumber, 1

			mov eax, 0
			mov al, 2
			call RandomRange
			mov firstGo, al

			jmp Game

			clearTable: mov ecx, 9
						mov al, 0
						mov esi, OFFSET gameBoard
						zeroOut: mov [esi], al
								 inc esi
						loop zeroOut
						jmp preGame

			Game: call Clrscr

				  mov edx, 0
				  call Gotoxy

				  mov ecx, 50
				  mov eax, 0
				  Spce: mov al, ' '
				  	    call WriteChar
				  loop Spce

				  mov eax, white
				  call SetTextColor

				  mov edx, player_name
				  call WriteString

				  mov edx, OFFSET gameTitle
				  call WriteString

				  call Crlf
				  call Crlf

				  INVOKE Display_Game_Board
				  INVOKE Display_Game_Moves, ADDR gameBoard

				  cmp movNumber, 9
					  jg leaveProc4

				  INVOKE Check_Winner_for_PvC_CvC, ADDR gameBoard, movNumber, name_offset, firstGo, 0
				  cmp dl, 0
					  je keepPlaying
				  cmp dl, 1
					  je leaveProc4
				  cmp dl, 2
					  je leaveProc4

				  keepPlaying:
				  mov dl, 55
				  mov dh, 23
				  call Gotoxy

				  mov eax, 0
				  mov al, movNumber
				  mov bl, 2
				  div bl

				  cmp firstGo, 0
					  je player_first
				  cmp firstGo, 1
					  je computer_first

				  player_first: cmp ah, 1
								    je player_prompt
							    cmp ah, 0
								  je computer_prompt

				  computer_first: cmp ah, 1
									  je computer_prompt
								  cmp ah, 0
									  je player_prompt

				  player_prompt: cmp firstGo, 0
									 je U_P1

				                 mov eax, lightMagenta
							     call SetTextColor
								 mov player_user_type, 1
								 jmp cont1

								 U_P1: mov eax, lightGreen
									   call SetTextColor

									   mov player_user_type, 0

							     cont1: mov edx, player_name
										call WriteString
										mov al, ':'
										call WriteChar
										mov al, ' '
										call WriteChar
										jmp user_selections

				  computer_prompt: cmp firstGo, 1
									   je C_P1

								   mov eax, lightMagenta
								   call SetTextColor
								   mov comp_user_type, 1
								   jmp cont2

								   C_P1: mov eax, lightGreen
									     call SetTextColor

										 mov comp_user_type, 0

								   cont2: mov edx, OFFSET computerMove
									     call WriteString

								   jmp computer_selections

				  user_selections: mov eax, white
								   call SetTextColor

								   mov eax, 0
								   call ReadDec
									  mov user_selection, eax
									  INVOKE validate_input, user_selection, 3
										  cmp dl, 1
											  je Game

								   INVOKE Update_Game_Board, 0, player_user_type, user_selection, ADDR gameBoard
								   cmp dl, 1
									  je user_selections

								   inc movNumber
								   jmp Game

				  computer_selections: mov eax, 0
									   mov al, 10
									   call RandomRange
									   mov ebx, 0
									   mov bl, al
									   mov computer_selection, ebx

									   cmp computer_selection, 0
										   je computer_selections

									   INVOKE Update_Game_Board, 1, comp_user_type, computer_selection, ADDR gameBoard
										  cmp dl, 1
											  je computer_selections

									   mov ebx, 0
									   mov ebx, computer_selection
									   mov al, bl
									   call WriteDec

									   mov eax, 1000
									   call Delay

									   inc movNumber
									   jmp Game

			leaveProc4: cmp movNumber, 10
							jne justleave
						INVOKE Check_Winner_for_PvC_CvC, ADDR gameBoard, movNumber, name_offset, firstGo, 0
			justleave:	mov runOnce, 1
			            leave
	ret
Start_PvC_Game ENDP

Display_Game_Board PROC
		.data
			gameBoardPrint BYTE "                                                                                                        ", 0
						   BYTE "                                                           - | - | -                                    ", 0
						   BYTE "                                                           - | - | -                                    ", 0
						   BYTE "                                                           - | - | -                                    ", 0

		.code
			push ebp
			mov ebp, esp

			mov ecx, 4
				  mov bl, 0
				  mov eax, white
				  call SetTextColor
				  printMenu: mov edx, OFFSET gameBoardPrint
						     mov eax, 0
						     mov al, LENGTHOF gameBoardPrint
						     mul bl

						     add edx, eax
						     call WriteString

						     call Crlf
						     inc bl
				  loop printMenu

			leave
	ret
Display_Game_Board ENDP

Display_Game_Moves PROC x5:PTR BYTE
		.data
			gameTable EQU [x5 + 4]

			player1Mark  BYTE "X", 0


			player2Mark  BYTE "O", 0


			boardPos     BYTE 1
			player_type2 BYTE 0

		.code
			push ebp
			mov ebp, esp

			mov boardPos, 1
			mov ebx, 0
			mov ebx, gameTable
			mov esi, ebx
			mov ecx, 9
			findMarks: mov al, [esi]
					   cmp al, 0
					       jne markFind
					   returnToLoop: inc esi
								     inc boardPos
			loop findMarks
			jmp leaveProc5

			markFind: cmp al, 1
						   je setPlayer1
					  cmp al, 2
						   je setPlayer2

					  setPlayer1: mov player_type2, 1
								  jmp findBoardPos
					  setPlayer2: mov player_type2, 2
							      jmp findBoardPos


					  findBoardPos: INVOKE Screen_xy_coordinet, boardPos
			push ecx
				mov ecx, 1
				mov bl, 0

				printMark:  push edx
								cmp player_type2, 1
									jne getMark

								pMark: mov eax, black + (yellow * 16)
									   call SetTextColor

								       mov edx, OFFSET player1Mark
									   mov eax, 0
									   mov al, LENGTHOF player1Mark
									   mul bl
									   jmp continuePrint

								getMark: mov eax, black + (blue * 16)
									     call SetTextColor

										 mov edx, OFFSET player2Mark
										 mov eax, 0
										 mov al, LENGTHOF player2Mark
										 mul bl

								continuePrint: add edx, eax
											   call WriteString
							pop edx

							inc dh
							call Gotoxy
							inc bl
				loop printMark
		   pop ecx

		   mov eax, white
		   call SetTextColor

		    jmp returnToLoop

		    leaveProc5: leave
	ret
Display_Game_Moves ENDP
Screen_xy_coordinet PROC x6:BYTE
		.data
			pos EQU [x6 + 4]

		.code
			push ebp
			mov ebp, esp

			cmp pos, 1
				je Print_1
			cmp pos, 2
				je Print_2
			cmp pos, 3
				je Print_3
			cmp pos, 4
				je Print_4
			cmp pos, 5
				je Print_5
			cmp pos, 6
				je Print_6
			cmp pos, 7
				je Print_7
			cmp pos, 8
				je Print_8
			cmp pos, 9
				je Print_9

			jmp leaveProc6

			Print_1: mov dl, 59
					 mov dh, 3
					 call Gotoxy
					 jmp leaveProc6

			Print_2: mov dl, 63
					 mov dh, 3
					 call Gotoxy
					 jmp leaveProc6

			Print_3: mov dl, 67
					 mov dh, 3
					 call Gotoxy
					 jmp leaveProc6

			Print_4: mov dl, 59
					 mov dh, 4
					 call Gotoxy
					 jmp leaveProc6

			Print_5: mov dl, 63
					 mov dh, 4
					 call Gotoxy
					 jmp leaveProc6

			Print_6: mov dl, 67
					 mov dh, 4
					 call Gotoxy
					 jmp leaveProc6

			Print_7: mov dl, 59
					 mov dh, 5
					 call Gotoxy
					 jmp leaveProc6

			Print_8: mov dl, 63
					 mov dh, 5
					 call Gotoxy
					 jmp leaveProc6

			Print_9: mov dl, 67
					 mov dh, 5
					 call Gotoxy
					 jmp leaveProc6

			leaveProc6: leave
	ret
Screen_xy_coordinet ENDP
Update_Game_Board PROC x4:BYTE, y3:BYTE, w1:DWORD, z1:PTR BYTE
		.data
			player_type EQU [x4 + 4]
			assign_type EQU [y3 + 4]
			location    EQU [w1 + 4]
			game_board  EQU [z1 + 4]

			occupied_error     BYTE "That square is already occupied. Please try again: ", 0
			row_size		   BYTE 3
			row_index		   BYTE ?
			column_index	   DWORD ?

		.code
			push ebp
			mov ebp, esp

			cmp location, 1
				je Fill_1
			cmp location, 2
				je Fill_2
			cmp location, 3
				je Fill_3
			cmp location, 4
				je Fill_4
		    cmp location, 5
				je Fill_5
			cmp location, 6
				je Fill_6
			cmp location, 7
				je Fill_7
			cmp location, 8
				je Fill_8
			cmp location, 9
				je Fill_9

			jmp leaveProc3

			Fill_1: mov row_index, 0
					mov column_index, 0
					jmp Fill_Task

			Fill_2: mov row_index, 0
					mov column_index, 1
					jmp Fill_Task

			Fill_3: mov row_index, 0
					mov column_index, 2
					jmp Fill_Task

			Fill_4: mov row_index, 1
					mov column_index, 0
					jmp Fill_Task

			Fill_5: mov row_index, 1
					mov column_index, 1
					jmp Fill_Task

			Fill_6: mov row_index, 1
					mov column_index, 2
					jmp Fill_Task

			Fill_7: mov row_index, 2
					mov column_index, 0
					jmp Fill_Task

			Fill_8: mov row_index, 2
					mov column_index, 1
					jmp Fill_Task

			Fill_9: mov row_index, 2
					mov column_index, 2
					jmp Fill_Task

			Fill_Task: mov ebx, game_board
					   mov eax, 0
					   mov al, row_index
					   mov dl, row_size
					   mul dl
					   add ebx, eax
					   mov esi, column_index

					   mov cl, [ebx + esi]
					   cmp cl, 0
						   jne occupiedError

					   cmp assign_type, 0
						   je setX_
					   cmp assign_type, 1
						   je setO_

					   setX_: mov al, 1
							  jmp addToBoard
					   setO_: mov al, 2
							  jmp addToBoard

					   addToBoard: mov [ebx + esi], al

					   mov dl, 0
					   jmp leaveProc3
			occupiedError: mov dl, 1

						   cmp player_type, 1
							   je leaveProc3

						   call Crlf
						   call Crlf

						   mov eax, lightRed
						   call SetTextColor

						   push edx
						       mov dl, 38
							   mov dh, 25
							   call Gotoxy
							   mov edx, OFFSET occupied_error
							   call WriteString
						   pop edx

						   mov eax, white
						   call SetTextColor

						   jmp leaveProc3


			leaveProc3: leave
	ret
Update_Game_Board ENDP
Check_Winner_for_PvP PROC x7:DWORD, y4:BYTE, w2:PTR BYTE,w3:PTR BYTE, z2:BYTE, in1:BYTE
		.data
			game_board2 EQU [x7 + 4]
			move_number EQU [y4 + 4]
			user_name_1   EQU [w2 + 4]
			user_name_2   EQU [w3 + 4]
			player1     EQU [z2 + 4]
			inst_type   EQU [in1 + 4]

			gameBoard_offset2 DWORD ?
			P1_Win_prompt2    BYTE " WINS!", 0
			P2_Win_prompt2    BYTE " WINS!", 0
			draw_prompt2		 BYTE "IT'S A DRAW!", 0
			test_counter2	 BYTE ?
			path_type2		 BYTE ?

		.code
			push ebp
			mov ebp, esp

			mov ebx, game_board2
			mov gameBoard_offset2, ebx

			cmp move_number, 6
				jl win_false

			mov test_counter, 0


		    Test1: INVOKE Test_the_winner, 0, 0, 0, 1, 0, 2, gameBoard_offset2
				   inc test_counter2
				   cmp dl, 0
					   je Test2
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test2: INVOKE Test_the_winner, 0, 0, 1, 1, 2, 2, gameBoard_offset2
				   inc test_counter2
				   cmp dl, 0
					   je Test3
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test3: INVOKE Test_the_winner, 1, 0, 1, 1, 1, 2, gameBoard_offset2
			       inc test_counter2
				   cmp dl, 0
					   je Test4
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test4: INVOKE Test_the_winner, 2, 0, 2, 1, 2, 2, gameBoard_offset2
				   inc test_counter2
				   cmp dl, 0
					   je Test5
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test5: INVOKE Test_the_winner, 0, 0, 1, 0, 2, 0, gameBoard_offset2
				   inc test_counter2
				   cmp dl, 0
					   je Test6
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test6: INVOKE Test_the_winner, 0, 1, 1, 1, 2, 1, gameBoard_offset2
			       inc test_counter2
				   cmp dl, 0
					   je Test7
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test7: INVOKE Test_the_winner, 0, 2, 1, 2, 2, 2, gameBoard_offset2
			       inc test_counter2
				   cmp dl, 0
					   je Test8
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test8: INVOKE Test_the_winner, 2, 0, 1, 1, 0, 2, gameBoard_offset2
			       inc test_counter2
				   cmp dl, 0
					   je win_false
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			jmp win_false


			P1_Win: push edx
					mov dl, 55
					mov dh, 23
				    call Gotoxy

			        cmp player1, 0
						je user_1
					cmp player1, 1
						je comp_1

					user_1: mov eax, lightGreen
							call SetTextColor

							mov edx, user_name_1
					        call WriteString
							cmp inst_type, 1
								je suffix_add4
							resume4:
							mov edx, OFFSET P1_Win_prompt2
							call WriteString
							call Crlf

							pop edx

							mov path_type2, 0
							jmp fillPath

							suffix_add4: mov al, '1'
										call WriteChar
										jmp resume4

					comp_1: mov eax, lightGreen
							call SetTextColor

							mov edx, user_name_2
					        call WriteString
							cmp inst_type, 1
								je suffix_add3
							resume3:
							mov edx, OFFSET P2_Win_prompt2
							call WriteString
							call Crlf

							pop edx

							mov path_type2, 0
							jmp fillPath

							suffix_add3: mov al, '1'
										call WriteChar
										jmp resume3

			P2_Win: push edx
					mov dl, 55
					mov dh, 23
				    call Gotoxy

			        cmp player1, 1
						je user_2
					cmp player1, 0
						je comp_2

					user_2: mov eax, lightMagenta
							call SetTextColor

							mov edx, user_name_1
					        call WriteString
							cmp inst_type, 1
								je suffix_add2
							resume2:
							mov edx, OFFSET P1_Win_prompt2
							call WriteString
							call Crlf

							pop edx

							mov path_type2, 1
							jmp fillPath

							suffix_add2: mov al, '1'
										 call WriteChar
										 jmp resume2

					comp_2: mov eax, lightGreen
							call SetTextColor

							mov edx, user_name_2
					        call WriteString
							cmp inst_type, 1
								je suffix_add1
							resume1:
							mov edx, OFFSET P2_Win_prompt2
							call WriteString
							call Crlf

							pop edx

							mov path_type2, 0
							jmp fillPath

							suffix_add1: mov al, '1'
										call WriteChar
										jmp resume1

			win_false: cmp move_number, 10
						   je draw
					    jmp leaveskip

			draw: push edx
			      mov dl, 55
				  mov dh, 23
				  call Gotoxy

			      mov eax, yellow
				  call SetTextColor

			      mov edx, OFFSET draw_prompt2
				  call WriteString
				  pop edx
				  call Crlf

				  jmp leaveProc7


			fillPath: cmp test_counter2, 1
						  je DT1
					  cmp test_counter2, 2
						  je DT2
					  cmp test_counter2, 3
						  je DT3
					  cmp test_counter2, 4
						  je DT4
					  cmp test_counter2, 5
						  je DT5
					  cmp test_counter2, 6
						  je DT6
					  cmp test_counter2, 7
						  je DT7
					  cmp test_counter2, 8
						  je DT8


					  DT1: INVOKE Display_winner_Draw, 40, 3, 55, 3, 70, 3, path_type2
						   jmp leaveProc7
					  DT2: INVOKE Display_winner_Draw, 40, 3, 55, 9, 70, 15, path_type2
						   jmp leaveProc7
					  DT3: INVOKE Display_winner_Draw, 40, 9, 55, 9, 70, 9, path_type2
						   jmp leaveProc7
					  DT4: INVOKE Display_winner_Draw, 40, 15, 55, 15, 70, 15, path_type2
						   jmp leaveProc7
					  DT5: INVOKE Display_winner_Draw, 40, 3, 40, 9, 40, 15, path_type2
						   jmp leaveProc7
					  DT6: INVOKE Display_winner_Draw, 55, 3, 55, 9, 55, 15, path_type2
						   jmp leaveProc7
					  DT7: INVOKE Display_winner_Draw, 70, 3, 70, 9, 70, 15, path_type2
						   jmp leaveProc7
					  DT8: INVOKE Display_winner_Draw, 40, 15, 55, 9, 70, 3, path_type2
						   jmp leaveProc7
			leaveProc7: mov eax, white
						call SetTextColor

						push edx
							mov dl, 50
							mov dh, 25
							call Gotoxy
						pop edx

						call WaitMsg
			leaveskip:	leave

	ret
Check_Winner_for_PvP ENDP
Check_Winner_for_PvC_CvC PROC x7:DWORD, y4:BYTE, w2:PTR BYTE, z2:BYTE, in1:BYTE
		.data
			game_board2 EQU [x7 + 4]
			move_number EQU [y4 + 4]
			user_name   EQU [w2 + 4]
			player1     EQU [z2 + 4]
			inst_type   EQU [in1 + 4]

			gameBoard_offset DWORD ?
			P1_Win_prompt    BYTE " WINS!", 0
			P2_Win_prompt    BYTE "COMPUTER WINS", 0
			draw_prompt		 BYTE "IT'S A DRAW!", 0
			test_counter	 BYTE ?
			path_type		 BYTE ?

		.code
			push ebp
			mov ebp, esp

			mov ebx, game_board2
			mov gameBoard_offset, ebx

			cmp move_number, 6
				jl win_false

			mov test_counter, 0


		    Test1: INVOKE Test_the_winner, 0, 0, 0, 1, 0, 2, gameBoard_offset
				   inc test_counter
				   cmp dl, 0
					   je Test2
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test2: INVOKE Test_the_winner, 0, 0, 1, 1, 2, 2, gameBoard_offset
				   inc test_counter
				   cmp dl, 0
					   je Test3
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test3: INVOKE Test_the_winner, 1, 0, 1, 1, 1, 2, gameBoard_offset
			       inc test_counter
				   cmp dl, 0
					   je Test4
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test4: INVOKE Test_the_winner, 2, 0, 2, 1, 2, 2, gameBoard_offset
				   inc test_counter
				   cmp dl, 0
					   je Test5
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test5: INVOKE Test_the_winner, 0, 0, 1, 0, 2, 0, gameBoard_offset
				   inc test_counter
				   cmp dl, 0
					   je Test6
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test6: INVOKE Test_the_winner, 0, 1, 1, 1, 2, 1, gameBoard_offset
			       inc test_counter
				   cmp dl, 0
					   je Test7
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test7: INVOKE Test_the_winner, 0, 2, 1, 2, 2, 2, gameBoard_offset
			       inc test_counter
				   cmp dl, 0
					   je Test8
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test8: INVOKE Test_the_winner, 2, 0, 1, 1, 0, 2, gameBoard_offset
			       inc test_counter
				   cmp dl, 0
					   je win_false
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			jmp win_false


			P1_Win: push edx
					mov dl, 55
					mov dh, 23
				    call Gotoxy

			        cmp player1, 0
						je user_1
					cmp player1, 1
						je comp_1

					user_1: mov eax, lightGreen
							call SetTextColor

							mov edx, user_name
					        call WriteString
							cmp inst_type, 1
								je suffix_add1
							resume1:
							mov edx, OFFSET P1_Win_prompt
							call WriteString
							call Crlf

							pop edx

							mov path_type, 0
							jmp fillPath

							suffix_add1: mov al, '1'
										call WriteChar
										jmp resume1

					comp_1: mov eax, lightGreen
							call SetTextColor

							cmp inst_type, 1
								je suffix_add2
							mov edx, OFFSET P2_Win_prompt
							call WriteString

							resume2:
							call Crlf

							pop edx

							mov path_type, 0
							jmp fillPath

							suffix_add2: mov edx, user_name
										 call WriteString
							             mov al, '2'
										 call WriteChar
										 mov edx, OFFSET P1_Win_prompt
										 call WriteString
										 jmp resume2

			P2_Win: push edx
					mov dl, 55
					mov dh, 23
				    call Gotoxy

			        cmp player1, 1
						je user_2
					cmp player1, 0
						je comp_2

					user_2: mov eax, lightMagenta
							call SetTextColor

							mov edx, user_name
					        call WriteString
							cmp inst_type, 1
								je suffix_add3
							resume3:
							mov edx, OFFSET P1_Win_prompt
							call WriteString
							call Crlf

							pop edx

							mov path_type, 1
							jmp fillPath

							suffix_add3: mov al, '1'
										 call WriteChar
										 jmp resume3

					comp_2: mov eax, lightMagenta
							call SetTextColor

							cmp inst_type, 1
								je suffix_add4
							mov edx, OFFSET P2_Win_prompt
							call WriteString

							resume4:
							call Crlf

							pop edx

							mov path_type, 1
							jmp fillPath

							suffix_add4: mov edx, user_name
										 call WriteString
							             mov al, '2'
										 call WriteChar
										 mov edx, OFFSET P1_Win_prompt
										 call WriteString
										 jmp resume4

			win_false: cmp move_number, 10
						   je draw
					    jmp leaveskip

			draw: push edx
			      mov dl, 55
				  mov dh, 23
				  call Gotoxy

			      mov eax, yellow
				  call SetTextColor

			      mov edx, OFFSET draw_prompt
				  call WriteString
				  pop edx
				  call Crlf

				  jmp leaveProc7


			fillPath: cmp test_counter, 1
						  je DT1
					  cmp test_counter, 2
						  je DT2
					  cmp test_counter, 3
						  je DT3
					  cmp test_counter, 4
						  je DT4
					  cmp test_counter, 5
						  je DT5
					  cmp test_counter, 6
						  je DT6
					  cmp test_counter, 7
						  je DT7
					  cmp test_counter, 8
						  je DT8


					  DT1: INVOKE Display_winner_Draw, 40, 3, 55, 3, 70, 3, path_type
						   jmp leaveProc7
					  DT2: INVOKE Display_winner_Draw, 40, 3, 55, 9, 70, 15, path_type
						   jmp leaveProc7
					  DT3: INVOKE Display_winner_Draw, 40, 9, 55, 9, 70, 9, path_type
						   jmp leaveProc7
					  DT4: INVOKE Display_winner_Draw, 40, 15, 55, 15, 70, 15, path_type
						   jmp leaveProc7
					  DT5: INVOKE Display_winner_Draw, 40, 3, 40, 9, 40, 15, path_type
						   jmp leaveProc7
					  DT6: INVOKE Display_winner_Draw, 55, 3, 55, 9, 55, 15, path_type
						   jmp leaveProc7
					  DT7: INVOKE Display_winner_Draw, 70, 3, 70, 9, 70, 15, path_type
						   jmp leaveProc7
					  DT8: INVOKE Display_winner_Draw, 40, 15, 55, 9, 70, 3, path_type
						   jmp leaveProc7
			leaveProc7: mov eax, white
						call SetTextColor

						push edx
							mov dl, 50
							mov dh, 25
							call Gotoxy
						pop edx

						call WaitMsg
			leaveskip:	leave

	ret
Check_Winner_for_PvC_CvC ENDP
Test_the_winner PROC p1:BYTE, p2:DWORD, p3:BYTE, p4:DWORD, p5:BYTE, p6:DWORD, x8:PTR BYTE
		.data
			r1 			EQU [p1 + 4]
			c1 			EQU [p2 + 4]
			r2 			EQU [p3 + 4]
			c2 			EQU [p4 + 4]
			r3 			EQU [p5 + 4]
			c3 			EQU [p6 + 4]
			game_board3 EQU [x8 + 4]

			test_num1    BYTE ?
			test_num2    BYTE ?
			test_num3    BYTE ?
			instance	 BYTE ?

			row_size2    BYTE 3



	    .code
			push ebp
			mov ebp, esp

			mov ebx, game_board3
			mov dl, row_size2

			T1: mov eax, 0
				mov al, r1
				mov esi, c1
				jmp get_test_num1

			T2: mov eax, 0
				mov al, r2
				mov esi, c2
				jmp get_test_num2

			T3: mov eax, 0
				mov al, r3
				mov esi, c3
				jmp get_test_num3

			getTest: mov edi, ebx
					 mul dl
					 add edi, eax

					cmp instance, 1
						je set_test_num1
					cmp instance, 2
						je set_test_num2
					cmp instance, 3
						je set_test_num3

				   set_test_num1: mov cl, [edi + esi]
								  mov test_num1, cl
								  jmp T2
				   set_test_num2: mov cl, [edi + esi]
								  mov test_num2, cl
								  jmp T3
				   set_test_num3: mov cl, [edi + esi]
								  mov test_num3, cl
								  jmp computeResult

					get_test_num1: mov instance, 1
								   jmp getTest
					get_test_num2: mov instance, 2
								   jmp getTest
					get_test_num3: mov instance, 3
								   jmp getTest

					computeResult: mov al, test_num1
								   cmp al, test_num2
										jne no_win
								   cmp al, test_num3
										jne no_win
								   mov al, test_num2
								   cmp al, test_num3
										jne no_win

								   mov al, test_num1
								   add al, test_num2
								   add al, test_num3

								   cmp al, 3
									   je P1Win
								   cmp al, 6
									   je P2Win
								   jmp no_win

			P1Win: mov dl, 1
				   jmp leaveProc8
			P2Win: mov dl, 2
				   jmp leaveProc8

			no_win: mov dl, 0
					jmp leaveProc8

			leaveProc8: leave
	ret
Test_the_winner ENDP

Display_winner_Draw PROC l_p1:BYTE, h_p2:BYTE, l_p3:BYTE, h_p4:BYTE, l_p5:BYTE, h_p6:BYTE, x9:BYTE
		.data
			dl_1	  EQU [l_p1 + 4]
			dh_1	  EQU [h_p2 + 4]
			dl_2	  EQU [l_p3 + 4]
			dh_2	  EQU [h_p4 + 4]
			dl_3	  EQU [l_p5 + 4]
			dh_3	  EQU [h_p6 + 4]
			X_or_O    EQU [x9 + 4]

			player1Mark_  BYTE " X ", 0


			player2Mark_  BYTE " O ", 0


		.code
			push ebp
			mov ebp, esp

			mov eax, 1000
			call Delay

			push edx

			mov eax, black + (lightGreen * 16)
			call SetTextColor

			; SQUARE 1
			mov dl, dl_1
			mov dh, dh_1
			call Gotoxy
			mov ecx, 5
			square1: push ecx
						mov ecx, 14
						square1a: mov al, ' '
								  call WriteChar
								  inc dl
								  call Gotoxy
						loop square1a
					 pop ecx
					 sub dl, 14
					 inc dh
					 call Gotoxy
			loop square1

			mov dl, dl_1
			add dl, 4
			mov dh, dh_1
			call Gotoxy

			mov bl, 0
			mov ecx, 1
			mov eax, black + (lightGreen * 16)
			call SetTextColor
			printMark: push edx
							cmp X_or_O, 1
								je O_path

							X_path: mov edx, OFFSET player1Mark_
								    mov eax, 0
								    mov al, LENGTHOF player1Mark_
								    mul bl
								    jmp continuePrint

							O_path: mov edx, OFFSET player2Mark_
									mov eax, 0
									mov al, LENGTHOF player2Mark_
									mul bl

							continuePrint: add edx, eax
										   call WriteString
					   pop edx
					   inc dh
				       call Gotoxy
				       inc bl
			loop printMark

			mov eax, black + (lightGreen * 16)
			call SetTextColor

			;SQUARE 2:
			mov dl, dl_2
			mov dh, dh_2
			call Gotoxy
			mov ecx, 5
			square2: push ecx
						mov ecx, 14
						square2a: mov al, ' '
								  call WriteChar
								  inc dl
								  call Gotoxy
						loop square2a
					 pop ecx
					 sub dl, 14
					 inc dh
					 call Gotoxy
			loop square2

			mov dl, dl_2
			add dl, 4
			mov dh, dh_2
			call Gotoxy

			mov bl, 0
			mov ecx, 1
			mov eax, black + (lightGreen * 16)
			call SetTextColor
			printMark2: push edx
							cmp X_or_O, 1
								je O_path2

							X_path2: mov edx, OFFSET player1Mark_
								     mov eax, 0
								     mov al, LENGTHOF player1Mark_
								     mul bl
								     jmp continuePrint2

							O_path2: mov edx, OFFSET player2Mark_
									 mov eax, 0
									 mov al, LENGTHOF player2Mark_
									 mul bl

							continuePrint2: add edx, eax
										    call WriteString
					   pop edx
					   inc dh
				       call Gotoxy
				       inc bl
			loop printMark2

			mov eax, black + (lightGreen * 16)
			call SetTextColor

			; SQUARE 3:
			mov dl, dl_3
			mov dh, dh_3
			call Gotoxy
			mov ecx, 5
			square3: push ecx
						mov ecx, 14
						square3a: mov al, ' '
								  call WriteChar
								  inc dl
								  call Gotoxy
						loop square3a
					 pop ecx
					 sub dl, 14
					 inc dh
					 call Gotoxy
			loop square3

			mov dl, dl_3
			add dl, 4
			mov dh, dh_3
			call Gotoxy

			mov bl, 0
			mov ecx, 1
			mov eax, black + (lightGreen * 16)
			call SetTextColor
			printMark3: push edx
							cmp X_or_O, 1
								je O_path3

							X_path3: mov edx, OFFSET player1Mark_
								     mov eax, 0
								     mov al, LENGTHOF player1Mark_
								     mul bl
								     jmp continuePrint3

							O_path3: mov edx, OFFSET player2Mark_
									 mov eax, 0
									 mov al, LENGTHOF player2Mark_
									 mul bl

							continuePrint3: add edx, eax
										    call WriteString
					   pop edx
					   inc dh
				       call Gotoxy
				       inc bl
			loop printMark3

			pop edx
			leave
	ret
Display_winner_Draw ENDP
Start_CvC_Game PROC
		.data
			gameBoard2	       BYTE 9 DUP(0)

			gameTitle2	       BYTE "Computer 1 vs. Computer 2", 0
			computer1Move      BYTE "Computer 1", 0
			computer2Move      BYTE "Computer 2", 0
			computer_name      BYTE "Computer ", 0

			movNumber2	        BYTE 0
			computer1_selection DWORD 0
			computer2_selection DWORD 0
			comp1_assign_type   BYTE ?
			comp2_assign_type   BYTE ?
			comp_name_offset    DWORD ?
			firstGo2	        BYTE ?
			runOnce2			BYTE ?

		.code
			push ebp
			mov ebp, esp

			mov ebx, OFFSET computer_name
			mov comp_name_offset, ebx
			cmp runOnce2, 1
				je clearTable_

			preGame_: mov movNumber2, 1
			          mov firstGo2, 0

			jmp Game2

			clearTable_: mov ecx, 9
						mov al, 0
						mov esi, OFFSET gameBoard2
						zeroOut_: mov [esi], al
								 inc esi
						loop zeroOut_
						jmp preGame_

			Game2:call Clrscr

				  mov edx, 0
				  call Gotoxy

				  mov ecx, 50
				  mov eax, 0
				  Spce_: mov al, ' '
				  	    call WriteChar
				  loop Spce_

				  mov eax, white
				  call SetTextColor

				  mov edx, OFFSET gameTitle2
				  call WriteString

				  call Crlf
				  call Crlf

				  INVOKE Display_Game_Board
				  INVOKE Display_Game_Moves, ADDR gameBoard2

				  cmp movNumber2, 9
					  jg leaveProc9

				  INVOKE Check_Winner_for_PvC_CvC, ADDR gameBoard2, movNumber2, comp_name_offset, firstGo2, 1
				  cmp dl, 0
					  je keepPlaying_
				  cmp dl, 1
					  je leaveProc9
				  cmp dl, 2
					  je leaveProc9

				  keepPlaying_:
				  mov dl, 55
				  mov dh, 23
				  call Gotoxy

				  mov eax, 0
				  mov al, movNumber2
				  mov bl, 2
				  div bl

				 mov firstGo2, 0
				 jmp computer1_first

				  computer1_first: cmp ah, 1
								       je computer1_prompt
							       cmp ah, 0
								       je computer2_prompt

				  computer1_prompt: cmp firstGo2, 0
									    je C1e

									mov eax, lightMagenta
									call SetTextColor
									mov comp1_assign_type, 1
									jmp cont1_

								    C1e: mov eax, lightGreen
									     call SetTextColor

										 mov comp1_assign_type, 0

							        cont1_: mov edx, OFFSET computer1Move
										    call WriteString
										    mov al, ':'
										    call WriteChar
										    mov al, ' '
										    call WriteChar
										    jmp compouter1_selection

				  computer2_prompt: cmp firstGo2, 1
									    je C2e

								    mov eax, lightMagenta
								    call SetTextColor
									mov comp2_assign_type, 1
								    jmp cont2_

								    C2e: mov eax, lightGreen
									     call SetTextColor

										mov comp1_assign_type, 0

								    cont2_: mov edx, OFFSET computer2Move
									        call WriteString
										    mov al, ':'
										    call WriteChar
										    mov al, ' '
										    call WriteChar
										    jmp compouter2_selection

				  compouter1_selection: mov eax, 0
									mov al, 10
									call RandomRange
									mov ebx, 0
									mov bl, al
									mov computer1_selection, ebx

								    cmp computer1_selection, 0
									    je compouter1_selection

								    INVOKE Update_Game_Board, 1, comp1_assign_type, computer1_selection, ADDR gameBoard2
									   cmp dl, 1
										   je compouter1_selection

								    mov ebx, 0
								    mov ebx, computer1_selection
								    mov al, bl
								    call WriteDec

								    mov eax, 2000
								    call Delay

								    inc movNumber2
								    jmp Game2

				  compouter2_selection: mov eax, 0
									mov al, 10
									call RandomRange
									mov ebx, 0
									mov bl, al
									mov computer2_selection, ebx

								    cmp computer2_selection, 0
									    je compouter2_selection

								    INVOKE Update_Game_Board, 1, comp2_assign_type, computer2_selection, ADDR gameBoard2
									    cmp dl, 1
										    je compouter2_selection

								    mov ebx, 0
								    mov ebx, computer2_selection
								    mov al, bl
								    call WriteDec

								    mov eax, 2000
								    call Delay

								    inc movNumber2
								    jmp Game2

			leaveProc9: cmp movNumber2, 10
							jne justleave_
						INVOKE Check_Winner_for_PvC_CvC, ADDR gameBoard2, movNumber2, comp_name_offset, firstGo2, 1
			justleave_:	mov runOnce2, 1
			            leave
	ret
Start_CvC_Game ENDP

COMMENT $
	PROCEDURE: Validates user input in:
	- menu
	- in gameplay
$
validate_input PROC input_1:DWORD, instance_type:BYTE
		.data

			failCheck			   BYTE ?	;

			overflow_prompt        BYTE        "The number exceeds 32-bits, please try agian. ", 0
			range_prompt		   BYTE        "Out of range. Please enter 1 - 9. "
			menuError_prompt       BYTE        "Input must be a 1, 2, 3, or 4. ", 0
			signed_prompt          BYTE        "Sorry, input must be unsigned. ", 0

		.code
			push ebp
			mov ebp, esp

			jo overflowError
			cmp input_1, 0
				jl rangeCmp

			cmp instance_type, 1
				je menuCmp
			cmp instance_type, 2
				je rangeCmp
			cmp instance_type, 3
				je rangeCmp

			menuCmp: cmp input_1, 4		 ; Checks the range of menu 1-4
						jg menuError
					 cmp input_1, 0
						jle menuError
					 jmp doneChecking

			rangeCmp: cmp input_1, 0	 ; Checks the range of moves in game, 1-9
						jl RangeSignedError
						je RangeError

					  cmp input_1, 9
						jg RangeError
					jmp doneChecking

			overflowError: mov edx, OFFSET overflow_prompt
						   jmp displayError

			MenuError: mov edx, OFFSET menuError_prompt
					   jmp displayError

			RangeSignedError: mov edx, OFFSET signed_prompt
						jmp displayError

			RangeError: mov edx, OFFSET range_prompt
						jmp displayError

			displayError: call Crlf
						  mov eax, lightRed
						  call SetTextColor

						  mov ecx, 38			; Centers the error prompt
						  Spce: mov al, ' '
						        call WriteChar
						  loop Spce
						  call WriteString		; Displays the prompt
						  call Crlf

						  mov ecx, 38			; Centers the prompt
						  Spce2: mov al, ' '
						         call WriteChar
						  loop Spce2
						  call WaitMsg

						  mov eax, white
						  call SetTextColor

						  jo clrOF
						  jmp skip_clrOF		; Adds two \n before prompt

						  clrOF: mov cl, 1
								 neg cl

						  skip_clrOF:			; Adds two \n before prompt
						  call Crlf
						  call Crlf

						  mov failCheck, 1
						  jmp leaveProc1

			doneChecking: cmp input_1, 5
							je setExitCode
						mov failCheck, 0
						jmp leaveProc1

			setExitCode: mov failCheck, 2

			leaveProc1: mov dl, failCheck
						leave

	ret
validate_input ENDP
END main
