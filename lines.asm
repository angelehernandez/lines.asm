; #########################################################################
;
;   lines.asm - Assembly file for EECS205 Assignment 2
;   Angel Hernandez
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc

.DATA

	;; If you need to, you can place global variables here
	
.CODE
	

;; Don't forget to add the USES the directive here
;;   Place any registers that you modify (either explicitly or implicitly)
;;   into the USES list so that caller's values can be preserved
	
;;   For example, if your procedure uses only the eax and ebx registers
    ;;DrawLine PROC USES eax ebx ecx edx esi edi x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD
DrawLine PROC USES eax ebx ecx edx esi edi x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD
	;; Feel free to use local variables...declare them here
	;; For example:
	;; 	LOCAL foo:DWORD, bar:DWORD
	 	LOCAL curr_x:DWORD, curr_y:DWORD, prev_error:DWORD, inc_x:DWORD, inc_y:DWORD
	
	 			;;initialization
	 			mov esi, x1 ;ESI = X1
	 			mov edi, y1 ;EDI = Y1

				;;delta_x initialization
	 			sub esi, x0 ;DELTA_X = X1 - X0
	 			cmp esi, 0 ;compare delta_x to 0
	 			jge pos_delx ;jump if esi is positive
	 			neg esi ;ESI <- -ESI = -DELTA_X

				;;delta_y initialization
	pos_delx:	sub edi, y0 ;DELTA_Y = Y1 - Y0
				cmp edi, 0 ;compare delta_y to 0
				jge pos_dely ;jump if edi is positive
				neg edi ;EDI <- -EDI = -DELTA_Y

				;;if cond1
	pos_dely:	mov eax, x0 ;EAX = X0
				cmp eax, x1 ;compare x0 to x1
				jge else1 ;jump if x0 is greater than or equal to x1
				mov inc_x, 1 ;INC_X = 1
				jmp skip1 ;skip else1
	
	else1:		mov inc_x, -1 ;INC_X = -1
	skip1:		mov eax, y0 ;EAX = Y0
				cmp eax, y1 ;compare y0 to y1
				jge else2 ;jump if y0 is greater than or equal to y1
				mov inc_y, 1 ;INC_Y = 1
				jmp skip2 ;skip else2

	else2:		mov inc_y, -1 ;INC_Y = -1
	skip2:		mov ebx, 2 ;EBX = 2
				cmp esi, edi ;compare delta_x to delta_y
				jle else3 ;jump if delta_x is less than or equal to delta_y
				mov eax, esi ;EAX = DELTA_X
				mov edx, 0  ;EDX = 0
				div ebx ;ERROR = EAX = EAX/EBX = DELTA_X/2
				jmp skip3 ;skip else3

	else3:		mov eax, edi ;EAX = DELTA_Y
				mov ebx, 2 ;EBX = 2
	 			mov edx, 0  ;EDX = 0
				div ebx ;ERROR = EAX = EAX/EBX = DELTA_Y/2
				neg eax ;ERROR = -EAX 

	skip3:		mov ecx, x0 ;CURR_X = ECX = X0
				mov edx, y0 ;CURR_Y = EDX = Y0

				INVOKE DrawPixel, ecx, edx, color

				jmp main_cond
			
	wil:		;;INSIDE LOOP
				INVOKE DrawPixel, ecx, edx, color
				
				mov prev_error, eax ;PREV_ERROR = ERROR
				
				;;IF COND1
				neg esi ;ESI = -DELTA_X
				cmp prev_error, esi ;compare prev_error to -delta_x
				jle COND2 ;jump if prev_error is less than or equal to -delta_x
				neg esi ;ESI = DELTA_X
				sub eax, edi ;ERROR = ERROR - DELTA_Y
				add ecx, inc_x ;CURR_X = CURR_X + INC_X
				jmp skip4 ;skip COND2

	COND2:		neg esi ;ESI = DELTA_X
	skip4:		cmp prev_error, edi ;compare prev_error to delta_y
				jge main_cond ;jump if prev_error is greater than or equal to delta_y
				add eax, esi ;ERROR = ERROR + DELTA_X
				add edx, inc_y ;CURR_Y = CURR_Y + INC_Y
	
	main_cond:	;;WHILE CONDITIONAL
				cmp ecx, x1 ;compare curr_x to x1
				jne wil ;loop again if curr_x != x1
				cmp edx, y1 ;compare curr_y to y1
				jne wil ;loop again if curr_y != y1

	break_loop:	
				
	ret        	;;  Don't delete this line...you need it
DrawLine ENDP




END
