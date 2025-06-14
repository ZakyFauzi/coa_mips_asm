.data
identitas: .asciiz "Kel-2 DS-48-03\nArendra Isa Pratama - 103052400025\nBrama Hartoyo - 103052400030\n
Ghifary Wibisono - 103052400016\nZaky Muhammad Fauzi - 103052400064\n"
petunjuk: .asciiz "Masukkan Panjang dan Lebar (input 2002 untuk keluar)\n"
input_panjang: .asciiz "\nMasukkan Panjang: "
input_lebar: .asciiz "Masukkan Lebar: "
pesan_salah: .asciiz "Input tidak valid! Bilangan harus > 0 dan tidak sama\n"
kecil: .asciiz " Termasuk Kategori PERSEGI PANJANG KECIL\n"
sedang: .asciiz " Termasuk Kategori PERSEGI PANJANG SEDANG\n"
besar: .asciiz " Termasuk Kategori PERSEGI PANJANG BESAR\n"
hasil: .asciiz "Luas Persegi Panjang = "
keluar_msg: .asciiz "\nTerima kasih! Program selesai.\n"

.text
main:
    li $v0, 4			        # Menampilkan identitas kelompok
    la $a0, identitas
    syscall

    li $v0, 4			        # Menampilkan petunjuk program
    la $a0, petunjuk
    syscall

loop:
    jal MASUKAN
    beq $t0, 2002, exit         # Jika panjang = 2002, keluar dari program

    jal HITUNG                  # Hitung luas dan tentukan kategori
    jal KELUARAN                # Tampilkan hasil luas dan kategorinya
    j loop                      # Loop program

exit:
    li $v0, 4                   # Menampilkan pesan keluar
    la $a0, keluar_msg
    syscall

    li $v0, 10                  # Keluar dari program
    syscall

MASUKAN:
inputPanjang:                   # Meminta input panjang yang valid
    li $v0, 4
    la $a0, input_panjang
    syscall

    li $v0, 5
    syscall
    move $t0, $v0               # Simpan panjang ke $t0

    beq $t0, 2002, akhir        # Jika user ingin keluar (masukkan 2002), lompat ke akhir
    blez $t0, invalid

inputLebar:                     # Meminta input lebar yang valid
    li $v0, 4
    la $a0, input_lebar
    syscall

    li $v0, 5
    syscall
    move $t1, $v0               # Simpan lebar ke $t1

    blez $t1, invalid
    beq $t0, $t1, invalid
    j akhir                     # Lompat ke akhir jika input valid

invalid:
    li $v0, 4			 	    # Tampilkan pesan error jika input tidak valid
    la $a0, pesan_salah
    syscall
    j MASUKAN

akhir:
    jr $ra                      # Kembali ke main

HITUNG:						    # Menghitung luas dan menentukan kategori persegi panjang
    li $t2, 0                   # Inisialisasi hasil luas di $t2 = 0
    move $s0, $t0               # Salin panjang dari $t0 ke $s0
    move $s1, $t1               # Salin lebar dari $t1 ke $s1

    slt $t3, $t0, $t1
    bne $t3, $zero, lebar_lebih_besar

panjang_lebih_besar:	        # Jika Lebar < Panjang, ulangi penambahan Panjang sebanyak Lebar kali
    beqz $t1, kategori          # Jika lebar habis, selesai
    add $t2, $t2, $t0           # hasil = hasil + panjang
    addi $t1, $t1, -1           # lebar--
    j panjang_lebih_besar

lebar_lebih_besar:				# Jika Lebar > Panjang, ulangi penambahan Lebar sebanyak Panjang kali
    beqz $t0, kategori          # Jika panjang ($t0) habis, selesai
    add $t2, $t2, $t1           # hasil = hasil + lebar
    addi $t0, $t0, -1           # panjang--
    j lebar_lebih_besar

kategori:
    blt $t2, 100, k_kecil       # Jika Luas < 100, persegi panjang Kecil
    blt $t2, 500, k_sedang      # Jika 100 < luas < 500, persegi panjang Sedang

    la $s7, besar               # Jika luas >= 500, persegi panjang Besar
    j done_kal

k_kecil:
    la $s7, kecil
    j done_kal

k_sedang:
    la $s7, sedang

done_kal:
    jr $ra                      # Kembali ke main

KELUARAN:
    li $v0, 4
    la $a0, hasil
    syscall
    
    li $v0, 1				    # Menampilkan hasil Luas
    move $a0, $t2
    syscall

    li $v0, 4                   # Menampilkan kategori
    move $a0, $s7
    syscall

    jr $ra                      # Kembali ke main