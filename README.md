# Projekt StopWatch
Jedná se o stopky, které na displeji zobrazují aktuální čas s možností uložení a následného zobrazení mezičasů.


## Spolupracovali:

* Truong Hong Minh
* Vocilka Jiří
* Tvarůžek Tomáš

### Vstupy
* BTND - spuštění nebo zastavení stopek (Start/Stop)
* BTNC - úplné vynulování (Reset)
* BTNU - uložení aktuálního času
* SW[0]/SW[5] - přepínání mezi zobrazením aktuálního času a uloženým časem

### Výstupy
- zobrazení aktuálního času stopek
- zobrazení uložených časů

### Blokový diagram
![diagram](images/Diagram.png)
## Popisy bloků:

---

### 1. Counter_core - ([Counter_core](StopWatchDE1.srcs/sources_1/counter_core.vhd))

--- 

Využívá 6 kaskádově zapojených čítačů counter vytvořených v rámci cvičení, které čítají od 0 po 9 s výjimkou desítek minutek, která čítají pouze od 0 do 5. V momentě kdy čítač dosáhne 9 pošle enable signál na další counter v kaskádě, který se zvýší o 1. Výstupní signál tedy tvoří šest 4bitových signálů.



### Counter_core testbench
![tb_counter_core](images/tb_counter_core.png)

---

### 2. Lap Brain - ([Lap_brain](StopWatchDE1.srcs/sources_1/lap_brain.vhd))

---

Tento blok přijímá signál z bloku counter_core a rozhoduje zda do následujícího bloku display_driver poslat aktuální čas nebo některý z uložených časů. Čas se uloží při stisknutí tlačítka do první paměti sw[0] a postupně se zvyšuje až na sw[5]. K dispozici je tedy 6 pamětí a v případě uložení dalšího mezičasu se opět přepíše první paměť sw[0].

### Lap_Brain testbench
![tb_lap_brain](images/tb_lap_brain.png)

---

### 3. Display driver - ([Display_driver](StopWatchDE1.srcs/sources_1/display_driver.vhd))

---

Převádí signály z lap_brain na šest 7segmentových displejů, které se velmi rychle přepínají. Díky vysoké frekvenci to pro oko vypadá, že svití všechny najednou. Na  jednotlivých displejích jsou následně rozsvíceny segmenty, které odpovídají danému číslu.

### Display_driver testbench
![tb_display_driver](images/tb_display_driver.png)
