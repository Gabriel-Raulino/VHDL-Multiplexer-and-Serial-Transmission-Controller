# 🔌 VHDL — Multiplexer & Serial Transmission Controller

<details>
<summary>🇺🇸 <b>Read in English</b></summary>
<br>

Academic project developed for the **Hardware Description Language** course. Two independent VHDL designs, developed and simulated in **Xilinx ISE 14.7**: a 4-to-1 multiplexer used to study the semantics of the `process` sensitivity list, and a finite-state-machine-based serial transmission controller implementing a custom start-bit/data/stop-bit protocol.

### 📂 Project Structure

```
.
├── PROJ-1-Mux/
│   ├── MUX.vhd            # 4-to-1 multiplexer (combinational)
│   ├── MUX_T1_TB.vhd       # Testbench
│   └── MUX.wcfg             # ISE waveform view configuration
└── PROJ-2-TX/
    ├── TX.vhd              # Serial transmission controller (FSM)
    ├── TX_TB.vhd            # Testbench
    └── TX.wcfg               # ISE waveform view configuration
```

### 🚀 How to Run (Xilinx ISE 14.7)

**1. Prerequisites**
* [Xilinx ISE Design Suite 14.7](https://www.amd.com/en/support/downloads/adaptive-socs-and-fpgas/legacy-ise/14_7-windows.html) (WebPACK edition is free and sufficient — no FPGA board required, simulation only). Since Xilinx was acquired by AMD, use this specific "Windows 10/11 Edition" link, which automatically includes a VM to run on modern systems.

**2. Create a project per folder**
For each of `PROJ-1-Mux/` and `PROJ-2-TX/`:
1. Open ISE → **File → New Project**.
2. Point the project location at the folder and add the existing `.vhd` files (**Project → Add Source**) — both the design file (`MUX.vhd`/`TX.vhd`) and its testbench (`MUX_T1_TB.vhd`/`TX_TB.vhd`).
3. In the **Design** panel, switch the view to **Simulation**.
4. Select the testbench file, then under **ISim Simulator**, double-click **Simulate Behavioral Model** to launch ISim and run the waveform simulation.
5. To reproduce the exact waveform layout shown below, load the provided `.wcfg` file from within ISim (**File → Open** inside the waveform window).



### 📐 Project 1 — 4-to-1 Multiplexer & the Sensitivity List

A combinational multiplexer: 4 one-bit data inputs (`in1`–`in4`), a 2-bit `ctrl` selector, and one output (`sai`).

<img width="647" height="467" alt="image" src="https://github.com/user-attachments/assets/50d829c0-0ee7-4740-b4ad-eb84991e371e" />


The goal was to simulate it and then study what happens when a signal is removed from the `process` sensitivity list — a classic VHDL pitfall — using the same testbench each time (`in1`/`in2`/`in3`/`in4` = 1/0/1/0, with `ctrl` cycling through `00→01→10→11` every 10ns).

**1. Full sensitivity list** (`process(in1, in2, in3, in4, ctrl)`): the circuit behaves as expected, updating the output the instant any relevant input changes.

<img width="937" height="499" alt="image" src="https://github.com/user-attachments/assets/8af6f931-171b-4d2f-895f-8808b78f0ab1" />


**2. Without `ctrl` in the list:** the output stops reacting to selector changes — it only updates when a *data* input happens to change, so the selected input effectively "freezes" at whatever it was at the start.

<img width="885" height="451" alt="image" src="https://github.com/user-attachments/assets/f2e82db8-84a5-4eb2-ae88-bf084f39b69c" />


**3. Without `in1` in the list:** a change on `in1` is silently ignored until some *other* listed signal changes. Here, `in1` transitions at 5ns, but the output only reflects that change once `in2`'s effect (via the `ctrl` change at 10ns) forces the process to re-evaluate — a visible gap between when the input changed and when the output caught up.

<img width="886" height="452" alt="image" src="https://github.com/user-attachments/assets/8b0e16af-28f7-4d9a-a12b-9e4c6e071fe6" />


This illustrates why an incomplete sensitivity list causes a **simulation/synthesis mismatch**: the simulated behavior (stale output) doesn't match what real synthesized combinational hardware would do (which reacts to any input change instantly, sensitivity list or not).

### 📡 Project 2 — Serial Transmission Controller (TX)

A custom protocol controller that serializes an 8-bit word onto a `linha` (line) output, framed with a start bit and a stop bit:

1. The testbench sets `palavra` (the byte) and raises `send`.
2. On the first clock edge after `send` goes high, `busy` rises and `linha` drops to `0` for one cycle (**start bit**).
3. Over the next 8 clock cycles, `palavra` is shifted out bit by bit, **MSB first** (bit 7 → bit 0).
4. On the 10th cycle after `send` was detected, `linha` drops to `0` again (**stop bit**) and `busy` falls at the end of that cycle; `linha` then returns to `1` (idle).

**Implementation:** a 3-state Moore-style FSM —

* **STANDBY** — idle state (or right after reset/`STOP_B`). Keeps `busy` low and `linha` high; on `send`, loads the byte into a register and issues the start bit.
* **SEND_B** — entered right after the start bit. Shifts the 8 register bits onto `linha`, one per clock cycle, via a combinational bit-select (a down-counter selects which register bit is currently active).
* **STOP_B** — issues the stop bit and returns to `STANDBY` on the next clock edge.

Well under the 11-state budget suggested in the assignment.

<img width="978" height="368" alt="image" src="https://github.com/user-attachments/assets/7a9f1643-1d8e-46d1-8155-7818edcf18f1" />


*The waveform above spans 300ns — enough to observe two full transmissions of different bytes (`11010001` and `00100110`), including state transitions (`standby → send_b → stop_b`), the busy/linha timing, and the bit-by-bit shift-out via the internal counter and register.*

<img width="886" height="447" alt="image" src="https://github.com/user-attachments/assets/677ac411-c31a-413c-9a30-7282c896e97b" />


### ⚠️ Note

The assignment asked to keep **both** versions of `MUX.vhd` (with the full sensitivity list, and with one signal removed) as separate deliverable files. Only the final/complete version is included here — the sensitivity-list experiments are documented above with their resulting waveforms, but the intermediate modified source files were not preserved separately.

---
**Developed by:** Gabriel Raulino Dal Pont & João Pedro Moraes Ribeiro

</details>

<details>
<summary>🇧🇷 <b>Ler em Português (BR)</b></summary>
<br>

Trabalho acadêmico desenvolvido para a disciplina de **Linguagem de Descrição de Hardware**. Dois projetos VHDL independentes, desenvolvidos e simulados no **Xilinx ISE 14.7**: um multiplexador 4x1 usado para estudar a semântica da lista de sensitividade do comando `process`, e um controlador de transmissão serial baseado em máquina de estados, implementando um protocolo próprio de start bit/dados/stop bit.

### 📂 Estrutura do Projeto

```
.
├── PROJ-1-Mux/
│   ├── MUX.vhd            # Multiplexador 4x1 (combinacional)
│   ├── MUX_T1_TB.vhd       # Testbench
│   └── MUX.wcfg             # Configuração de visualização de forma de onda do ISE
└── PROJ-2-TX/
    ├── TX.vhd              # Controlador de transmissão serial (máquina de estados)
    ├── TX_TB.vhd            # Testbench
    └── TX.wcfg               # Configuração de visualização de forma de onda do ISE
```

### 🚀 Como Executar (Xilinx ISE 14.7)

**1. Pré-requisitos**
* [Xilinx ISE Design Suite 14.7](https://www.amd.com/en/support/downloads/adaptive-socs-and-fpgas/legacy-ise/14_7-windows.html) (a edição WebPACK é gratuita e suficiente — só simulação, sem precisar de placa FPGA). Como a Xilinx foi adquirida pela AMD, utilize este link da "Windows 10/11 Edition", que já inclui uma VM automaticamente para rodar em sistemas atuais.

**2. Crie um projeto por pasta**
Para cada uma das pastas `PROJ-1-Mux/` e `PROJ-2-TX/`:
1. Abra o ISE → **File → New Project**.
2. Aponte o local do projeto pra pasta e adicione os arquivos `.vhd` existentes (**Project → Add Source**) — tanto o arquivo de design (`MUX.vhd`/`TX.vhd`) quanto o testbench (`MUX_T1_TB.vhd`/`TX_TB.vhd`).
3. No painel **Design**, mude a visualização pra **Simulation**.
4. Selecione o arquivo de testbench, depois em **ISim Simulator**, dê duplo clique em **Simulate Behavioral Model** pra abrir o ISim e rodar a simulação de forma de onda.
5. Pra reproduzir o layout exato das formas de onda mostradas abaixo, carregue o `.wcfg` correspondente de dentro do ISim (**File → Open** dentro da janela de forma de onda).



### 📐 Projeto 1 — Multiplexador 4x1 e a Lista de Sensitividade

Um multiplexador combinacional: 4 entradas de dado de 1 bit (`in1`–`in4`), um seletor `ctrl` de 2 bits, e uma saída (`sai`).

<img width="647" height="467" alt="image" src="https://github.com/user-attachments/assets/50d829c0-0ee7-4740-b4ad-eb84991e371e" />

O objetivo era simulá-lo e depois estudar o que acontece ao remover um sinal da lista de sensitividade do `process` — uma armadilha clássica de VHDL — usando o mesmo testbench em todos os casos (`in1`/`in2`/`in3`/`in4` = 1/0/1/0, com `ctrl` passando por `00→01→10→11` a cada 10ns).

**1. Lista de sensitividade completa** (`process(in1, in2, in3, in4, ctrl)`): o circuito se comporta como esperado, atualizando a saída no instante em que qualquer entrada relevante muda.

<img width="937" height="499" alt="image" src="https://github.com/user-attachments/assets/8af6f931-171b-4d2f-895f-8808b78f0ab1" />

**2. Sem `ctrl` na lista:** a saída para de reagir a mudanças no seletor — só atualiza quando alguma entrada de *dado* muda, então a entrada selecionada efetivamente "congela" no que estava no início.

<img width="885" height="451" alt="image" src="https://github.com/user-attachments/assets/f2e82db8-84a5-4eb2-ae88-bf084f39b69c" />

**3. Sem `in1` na lista:** uma mudança em `in1` é silenciosamente ignorada até que *outro* sinal da lista mude. Aqui, `in1` transiciona em 5ns, mas a saída só reflete essa mudança quando o efeito de `in2` (via a mudança de `ctrl` em 10ns) força o processo a reavaliar — uma defasagem visível entre o momento em que a entrada mudou e o momento em que a saída "alcançou".

<img width="886" height="452" alt="image" src="https://github.com/user-attachments/assets/8b0e16af-28f7-4d9a-a12b-9e4c6e071fe6" />

Isso ilustra por que uma lista de sensitividade incompleta causa uma **divergência entre simulação e síntese**: o comportamento simulado (saída desatualizada) não corresponde ao que o hardware combinacional real sintetizado faria (que reage a qualquer mudança de entrada instantaneamente, tenha ou não lista de sensitividade).

### 📡 Projeto 2 — Controlador de Transmissão Serial (TX)

Um controlador de protocolo próprio que serializa uma palavra de 8 bits na saída `linha`, encapsulada com um start bit e um stop bit:

1. O testbench define `palavra` (o byte) e sobe `send`.
2. Na primeira borda de clock após `send` subir, `busy` sobe e `linha` cai para `0` por um ciclo (**start bit**).
3. Nos 8 ciclos de clock seguintes, `palavra` é enviada bit a bit, **do MSB ao LSB** (bit 7 → bit 0).
4. No 10º ciclo após a detecção de `send`, `linha` cai para `0` novamente (**stop bit**) e `busy` desce no final desse ciclo; `linha` então volta para `1` (repouso).

**Implementação:** uma máquina de estados estilo Moore com 3 estados —

* **STANDBY** — estado de repouso (ou logo após reset/`STOP_B`). Mantém `busy` baixo e `linha` alta; quando `send` sobe, carrega o byte no registrador e emite o start bit.
* **SEND_B** — assumido logo após o start bit. Desloca os 8 bits do registrador para `linha`, um por ciclo de clock, via uma seleção de bit combinacional (um contador decrescente seleciona qual bit do registrador está ativo).
* **STOP_B** — emite o stop bit e retorna a `STANDBY` na próxima borda de clock.

Bem abaixo do limite de 11 estados sugerido no enunciado.

<img width="978" height="368" alt="image" src="https://github.com/user-attachments/assets/7a9f1643-1d8e-46d1-8155-7818edcf18f1" />

*A forma de onda acima cobre 300ns — suficiente pra observar duas transmissões completas de bytes diferentes (`11010001` e `00100110`), incluindo as transições de estado (`standby → send_b → stop_b`), a temporização de busy/linha, e o envio bit a bit via o contador e registrador internos.*

<img width="886" height="447" alt="image" src="https://github.com/user-attachments/assets/677ac411-c31a-413c-9a30-7282c896e97b" />

### ⚠️ Observação

O enunciado pedia pra guardar **ambas** as versões do `MUX.vhd` (com a lista de sensitividade completa, e com um sinal removido) como arquivos separados na entrega. Aqui está incluída apenas a versão final/completa — os experimentos de remoção de sinal estão documentados acima com suas formas de onda resultantes, mas os arquivos-fonte intermediários modificados não foram preservados separadamente.

---
**Desenvolvido por:** Gabriel Raulino Dal Pont & João Pedro Moraes Ribeiro

</details>
