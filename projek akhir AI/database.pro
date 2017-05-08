domains
	CondNum=Integer.
	RuleNum=Integer.
	FactNum=Integer.
	Conditions=CondNum*.
	HistoryTree=RuleNum*.
	Kind=String.
	
facts
	rule(RuleNum, Kind, Kind, Conditions).
	condition(CondNum, String).
	nama(String).
clauses
	condition(1, "perangkat lain nyala jika dicolok di stopkontak ini").
	condition(2, "computer sedang menyala").
	condition(3, "semua kabel sudah tercolok").
	condition(4, "PSU dalam kondisi oke").
	condition(5, "anda tidak mendengar bunyi beep saat nyala").
	condition(6, "terdengar bunyi 1 beep panjang dan 1/beberapa bunyi beep pendek").
	condition(7, "terdengar beberapa beberapa bunyi beep panjang").
	condition(8, "terdengar beberapa beberapa bunyi beep pendek dan layar tidak terlihat apapun").
	condition(9, "anda ada melihat post code dan info info saat boot up").
	condition(10, "everything works as usually but nothing appears on the screen").
	condition(11, "floppy drive dan CDROM dalam kondisi kosong").
	condition(12, "muncul tulisan 'harddisk berhasil dikenali'").	
	condition(13, "muncul pesan 'please insert a system disk' dilayar").
	condition(14, "OS merupakan produk windows").
	condition(15, "registry tidak pernah dirubah oleh orang orang usil").
	condition(16, "anda sudah memeriksa sistem dengan antivirus").
	condition(17, "OS merupakan produk unix").
	condition(18, "anda beberapa lama ini ada menginstall program baru").
	condition(19, "POST error code 2xx or message like 'RAM error' appears on the screen").

%	Complimentaries of above conditions
	condition(20, "not perangkat lain nyala jika dicolok di stopkontak ini").
	condition(21, "not computer sedang menyala").
	condition(22, "not semua kabel sudah tercolok").
	condition(23, "not PSU dalam kondisi oke").
	condition(24, "not anda ada melihat post code dan info info saat boot up").
	condition(25, "not anda tidak mendengar bunyi beep saat nyala").
	condition(26, "not floppy drive dan CDROM dalam kondisi kosong").
	condition(27, "not muncul tulisan 'harddisk berhasil dikenali'").
	condition(28, "not OS merupakan produk windows").
	condition(29, "not registry tidak pernah dirubah oleh orang orang usil").
	condition(30, "not anda sudah memeriksa sistem dengan antivirus").
	condition(31, "not OS merupakan produk windows").
	condition(32, "not anda beberapa lama ini ada menginstall program baru").

	rule(1, "ada aliran listrik di area sekitar anda", "steker dinding masih bagus", [1]).
	rule(2, "ada aliran listrik di area sekitar anda", "coba steker dinding lain", [20]).
	rule(3, "ada aliran listrik di area sekitar anda", "lebih teliti, kalimat anda tidak selaras", [21]). 
	rule(4, "ada aliran listrik di area sekitar anda", "mencolok kabelnya, silahkan dicolok dulu kabelnya", [22]).
	rule(5, "ada aliran listrik di area sekitar anda", "harus berhati-hati,kondisi terlihat bahaya silahkan buka jendela dan beritahu technical support masalah anda", [23]).
	rule(6, "steker dinding masih bagus", "computer sedang menyala" , [2, 3, 4]).
	rule(7, "computer sedang menyala", "mobo processor dan video card baik baik saja", [5]).
	rule(8, "computer sedang menyala", "coba mobo lain", [25, 6]).
	rule(9, "computer sedang menyala", " tahu bahwa ada pada microprocessor masalahnya", [25, 7]).
	rule(10, "computer sedang menyala", "ganti video card anda", [25, 8]).
	rule(11, "mobo processor dan video card baik baik saja", "coba lepas memory chipnya dan beli yang baru", [19, 24]).
	rule(12, "mobo processor dan video card baik baik saja", "monitor dan memory baik baik saja", [9]).
	rule(13, "mobo processor dan video card baik baik saja", "ganti monitormu", [10, 24]).
	rule(14, "monitor dan memory baik baik saja", "system mencoba boot up dari hdd", [11, 12]).
	rule(15,  "monitor dan memory baik baik saja", " keluarkan cdrom atau floppy disk lebih dahulu", [26]).
	rule(16,  "monitor dan memory baik baik saja", "pasang dengan benar", [27]).
	rule(17, "system mencoba boot up dari hdd", "ganti hdd kalau install ulang tidak cukup membantu", [13]).
	rule(18, "system mencoba boot up dari hdd", "coba ganti user", [14, 15, 16]).
	rule(19, "system mencoba boot up dari hdd", "curigai adanya trojan jika perlu restore dari backup  os nya", [18]).
	rule(20, "system mencoba boot up dari hdd", "meminta bantuan spesialis unix atau technical support anda", [17]).
	rule(21, "system mencoba boot up dari hdd", "meminta bantuan OS ini terlalu sulit untuk anda, silahkan hubungi technical support anda", [28, 31]).
	rule(22, "system mencoba boot up dari hdd", "gunakan backup dari file registry (system.dat, user.dat untuk win98)", [29]).
	rule(23, "system mencoba boot up dari hdd", "gunakan DrWeb atau AVP untuk menghadapi masalah ini", [30]).
	rule(24, "system mencoba boot up dari hdd", "hubungi technical support anda yang memahami error pada os anda", [28, 31]).

	
goal
	save("library.db"),
	write("basis library berhasil di simpan di library.db"),
	nl,
	write("silahkan periksa di folder temporary /n windows+r masukkan %temp%"),
	nl.