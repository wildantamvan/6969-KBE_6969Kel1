	
domains
	CondNum=Integer. /*kita deklarasikan integer*/ 
	RuleNum=Integer.
	mhs=symbol.
	Conditions=CondNum*. /*kita deklarasikan bahwa conditions menggunakan pointer condnum*/
	HistoryTree=RuleNum*.
	Kind=String. /*kind adalah variabel biasa menggunakan string*/
	Pasien,nama=string.
facts
	rule(RuleNum, Kind, Kind, Conditions). /*disini fakta yang disediakan*/
	condition(CondNum, String). /*condnum dipakai  */
	yes(CondNum).
	no(CondNum).
	nama(string).
	
	
predicates
% mesin Inferencenya
	tambahnama.
	nondeterm mulai(HistoryTree, Kind).
	
	priksa(RuleNum, HistoryTree, Conditions).
	noTest(CondNum).
	
	anggota(mhs) % ini adalah predikat dengan aritas hanya 1
anggota(mhs, mhs, mhs,mhs) % sedangkan ini adalah predikat anggota juga dengan aritas mhs berjumlah 4

%	mengambil data dari user, tanyauser adalah cari kata benda, prosesjawab adalah bagian utama 
% 	Getting data from user. tanyauser is a hull, prosesjawab is a core part.
	tanyauser(HistoryTree, RuleNum, CondNum, String).
	prosesjawab(HistoryTree, RuleNum, String, CondNum, Integer).

%	Providing explanatory data for user.
	subCat(Kind, Kind, Kind).
	showConditions(Conditions, String).
	munculaturan(RuleNum, String).
	report(HistoryTree, String).
	reverse(Conditions, Conditions).
	reverse1(Conditions, Conditions, Conditions).

clauses
%	Main predicate. Invokes routine-action perfoming predicates.
	mulai(_, MyGoal) :-
	  not(rule(_, MyGoal, _, _)),
	  !,
	  nl,

	  write("saya rasa anda harus ", MyGoal),
	  !.

	mulai(HistoryTree, MyGoal) :-
	
	  rule(RuleNum, MyGoal, SubGoal, Conditions),
	  priksa(RuleNum, HistoryTree, Conditions),
	  mulai([RuleNum|HistoryTree], SubGoal).
	
%	checking conditions before implementing a rule
	priksa(RuleNum, HistoryTree, [CondListHead|CondListTail]) :-
	  yes(CondListHead), % User answered positively
	  !,
	  priksa(RuleNum, HistoryTree, CondListTail). % Continue 

	priksa(_, _, [CondListHead|_]) :-
	  no(CondListHead), % User answered negatively. Stop further checking.
	  !,
	  fail,write("failkepake").

%	Two predicates dealing with conditions starting with 'not'
	priksa(RuleNum, HistoryTree, [CondListHead|CondListTail]) :-
	  condition(CondListHead, ConditionString),
	  fronttoken(ConditionString, "not", _NewCondString), % Delete not from ConditionString if suitable
	  frontchar(_NewCondString ,_, NextCondString), % Delete one character from _NewCondString
	  condition(NewCondListHead, NextCondString),
	  noTest(NewCondListHead),
	  !,
	  priksa(RuleNum, HistoryTree, CondListTail).
	
%	See above
	priksa(_, _, [CondListHead|_]) :-
	  condition(CondListHead, ConditionString),
	  fronttoken(ConditionString, "not", _NewCondString),
	  frontchar(_NewCondString, _, NextCondString),
	  condition(NewCondListHead, NextCondString),
	  yes(NewCondListHead),
	  !,
	  fail.

%	Call tanyauser predicate if above mentioned don't work
	priksa(RuleNum, History, [CondListHead|CondListTail]) :-
	  condition(CondListHead, Text),
	  !,
	  tanyauser(History, RuleNum, CondListHead, Text),
	  priksa(RuleNum, History, CondListTail).

	priksa(_,_,[]).

%	Helping predicates for negatively formulated conditions
	noTest(Condition) :- /*membantu predikat membentuk kalimat kondisi negatif*/
	  no(Condition),
	  !.
	
	noTest(Condition) :-
	  not(yes(Condition)),
	  !.

	tanyauser(HistoryTree, RuleNum, CondNum, Text) :- /*disini pertanyaan*/
	  write("silahkan jawab pertanyaan dibawah?\n", Text, "\n(Ya/tidak/mengapa): "),
	  readchar(Key), % sperti scanf pada bahasa c, berguna terima inputan
	  upper_lower(Key, Answer), % Convert ke lower /*huruf besar di convert ke kecil*/
	  prosesjawab(HistoryTree, RuleNum, Text, CondNum, Answer).

	prosesjawab(_, _, _, CondNum,'y') :-
	  !,
	  assert(yes(CondNum)), % Add to knowledge base
	  write("Yes\n").
  
	prosesjawab(_, _, _, CondNum, 't') :-
	  !,
	  assert(no(CondNum)),
	  write("No\n"),
	  fail.

%	Answering user 'mengapa' questions and displaying them good formated
	prosesjawab(HistoryTree, RuleNum, Text, CondNum, 'm') :-
	  !,
	  write("mengapa\n"),
	  rule(RuleNum, StartGoal, SubGoal, _), /*anonim artinya tidak peduli syarat karena ini untuk pemformatan output*/
	  !,
	  subCat(StartGoal, Subgoal, String1),
	  concat("kami mencoba menjelaskan kepada anda bahwa ", String1, String2),
	  concat(String2, "\nberdasarkan aturan nomor ", String3),
	  str_int(RuleNumAsString, RuleNum), % ngubah integer ke string
	  concat(String3, RuleNumAsString, Answer1),
	  munculaturan(RuleNum, String4),
	  concat(Answer1, String4, Answer2),
	  report(HistoryTree, Output),
	  concat(Answer2, Output, Answer3),
	  write(Answer3),
	  nl,
	  tanyauser(HistoryTree, RuleNum, CondNum, Text).

%	Otherwise
	prosesjawab(HistoryTree, RuleNum, Text, CondNum, _) :- /*hanya menerima inputan y, t, m jika selain itu maka anonim*/
	  write("\ninput tidak dikenali. masukkan lagi.\n"),
	  tanyauser(HistoryTree, RuleNum, CondNum, Text).
	
	munculaturan(RuleNum, String) :-
	  rule(RuleNum, MyGoal1, MyGoal2, CondList),
	  !,
	  str_int(RuleNumAsString, RuleNum), % merubah rulenum dari angka jadi string
	  concat("\n aturan ", RuleNumAsString, Answer), % Following four lines just to make output nicer
	  concat(Answer, ": ", Answer1),
	  subCat(MyGoal1, MyGoal2, String1),
	  concat(Answer1, String1, Answer2),
	  concat(Answer2, "\n     jika ", Answer3),
	  reverse(CondList, ReversedCondList), % Output to user in better way
	  showConditions(ReversedCondList, Conditions),
	  concat(Answer3, Conditions, String).
 
	showConditions([], ""). % Nothing to show
  
	showConditions([Conditions], Answer) :-
	  condition(Conditions, Answer),
	  !.
  
	showConditions([Head|Tail], Answer) :-
	  %
	  condition(Head, Text),
	  !,
	  concat("\n          dan ", Text, NextString),
	  showConditions(Tail, NextAnswer),
	  concat(NextAnswer, NextString, Answer).

%	Provides good indenting
	subCat(MyGoal1, MyGoal2, String) :-
	  format(String, "jika % maka %", MyGoal1, MyGoal2).

	report([], ""). % Nothing to report

	report([RuleListHead|RuleListTail], String) :-
	rule(RuleListHead, MyGoal1, MyGoal2,_),
	!,
	subCat(MyGoal1, MyGoal2, String1),
	concat("\nsaya telah menunjukan bahwa: ", String1, String2),
	concat(String2,"\nBerdasarkan aturan nomor ", String3),
	str_int(RuleListHeadAsString, RuleListHead),
	concat(String3, RuleListHeadAsString, String4),
	concat(String4, ":\n ", String5),
	munculaturan(RuleListHead, Str),
	concat(String5, Str, String6),
	report(RuleListTail, NextString),
	concat(String6, NextString, String).
	
	reverse(Conditions, NewConditions) :- /*menukar posisi kalimat*/
	  reverse1([], Conditions, NewConditions).

	reverse1(Conditions, [], Conditions).

	reverse1(Conditions, [CondListHead|CondListTail], NewConditions) :-
	  reverse1([CondListHead|Conditions], CondListTail, NewConditions).
	
	tambahnama:- write("nama pengguna ===>"),
	readln(Pasien),
	assert(nama(Pasien)),
	write(Pasien).
	
	anggota(Mhs):-
anggota(Mhs,farid,rizwan,_).
anggota(wildan,farid,rizwan,farhan).
anggota(farid,rizwan,wildan,farhan).
	
	
goal
	
	consult("library.db"),	
	write("          Selamat Datang Diprogram bantuan analisa kerusakan komputer untuk pemula                  "),nl,
	write("*************************************************************************************************************"),nl,

% anggota(Mhs),
	tambahnama,
	nl,nl,
	write("punya masalah komputer? coba saya bantu."),
	nl, nl,	
	mulai([], "ada aliran listrik di area sekitar anda");
	write("\nHmm. Ok, gejala kerusakan tidak ditemukan pada database silahkan konsultasikan ke technical support anda jika anda !"),
	nl, nl.