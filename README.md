# Projekt StopWatch
Jedná se o stopky, které na displeji zobrazují aktuální čas, s možností  uložení času a následného přepnutí na zobrazení tohoto uloženého času.


## Spolupracovali:

* Truong Hong Minh
* Vocilka Jiří
* Tvarůžek Tomáš

### Vstupy
* BTND (Start/Stop) - spuštění nebo zastavení stopek
* BTNC - úplné vynulování 
* BTNU - uložení aktuálního času
* SW[0] - přepínání mezi zobrazením aktuálního času a uloženým časem

### Výstupy
- zobrazení aktuálního času stopek
- zobrazení uloženého času

### Blokový diagram
![diagram](images/diagram4.png)

### 1.Counter [Counter_core](StopWatchDE1.srcs/sources_1/counter_core.vhd)
![tb_counter_core](images/tb_counter_core.png)

### 2.Lap Brain [Lap_brain](StopWatchDE1.srcs/sources_1/lap_brain.vhd)
![tb_lap_brain](images/tb_lap_brain.png)

### 3.Display driver [Display_driver](StopWatchDE1.srcs/sources_1/display_driver.vhd)
![tb_display_driver](images/tb_display_driver.png)
