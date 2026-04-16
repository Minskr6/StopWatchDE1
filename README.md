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
![diagram](diagram4.png)

### Testbench pro Counter_core
![tb_counter_core](imagines/tb_counter_core.png)

### Testbench pro Lap_brain
![tb_lap brain](tb_lap_brain.png)

### Testbench pro Display_driver
![tb_display driver](tb_display_driver.png)
