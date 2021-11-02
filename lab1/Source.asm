; wczytywanie i wy�wietlanie tekstu wielkimi literami
; (inne znaki si� nie zmieniaj�)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
extern __read : PROC ; (dwa znaki podkre�lenia)
public _main
.data
tekst_pocz		db 10, 'Prosz', 169, ' napisa', 134,' jaki', 152,' tekst '
				db 'i nacisn', 165, 134, ' Enter', 10
koniec_t		db ?
magazyn			db 80 dup (?)
nowa_linia		db 10
liczba_znakow	dd ?
.code
_main PROC
; wy�wietlenie tekstu informacyjnego
; liczba znak�w tekstu
	mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
	push ecx
	push OFFSET tekst_pocz ; adres tekstu
	push 1 ; nr urz�dzenia (tu: ekran - nr 1)
	call __write ; wy�wietlenie tekstu pocz�tkowego
	add esp, 12 ; usuniecie parametr�w ze stosu
; czytanie wiersza z klawiatury
	push 80 ; maksymalna liczba znak�w
	push OFFSET magazyn
	push 0 ; nr urz�dzenia (tu: klawiatura - nr 0)
	call __read ; czytanie znak�w z klawiatury
	add esp, 12 ; usuniecie parametr�w ze stosu
; kody ASCII napisanego tekstu zosta�y wprowadzone
; do obszaru 'magazyn'
; funkcja read wpisuje do rejestru EAX liczb�
; wprowadzonych znak�w
	mov liczba_znakow, eax
; rejestr ECX pe�ni rol� licznika obieg�w p�tli
	mov ecx, eax
	mov ebx, 0 ; indeks pocz�tkowy
ptl: mov dl, magazyn[ebx] ; pobranie kolejnego znaku
	cmp dl, 32
	jb dalej ; skok, gdy znak nie wymaga zamiany
	cmp dl, 125 
	ja dalej ; skok, gdy znak nie wymaga zamiany
	cmp dl, 110
	ja przeskok
	add dl, 15 ; zamiana na wielkie litery
; odes�anie znaku do pami�ci
	mov magazyn[ebx], dl
	jmp dalej
przeskok: mov al, 125
	mov ah, 15
	sub al, dl
	sub ah, al
	add ah, 32
	mov magazyn[ebx], ah
	dalej: inc ebx ; inkrementacja indeksu
	loop ptl ; sterowanie p�tl�
; wy�wietlenie przekszta�conego tekstu
	push liczba_znakow
	push OFFSET magazyn
	push 1
	call __write ; wy�wietlenie przekszta�conego  tekstu
	add esp, 12 ; usuniecie parametr�w ze stosu
	push 0
	call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END