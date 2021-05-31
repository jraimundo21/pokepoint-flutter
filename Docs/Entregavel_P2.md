# Entregável P2

**André Ribeiro - 200257016**

**Edna Martins - 200257001**

**João Raimundo - 200257008**

**Data:**
Criação *9 Maio 2021*


## Seleção e detalhe das funcionalidades

1. "Check-in" e "check-out" automático no trabalho com base em geofencing
1.1. O utilizador deverá ser notificado da sua entrada no perímetro delimitado
1.2. O utilizador deverá conseguir validar check-in
2. Check-in via QR code quando em modo offline
2.1. Modo check-in off-line ocioso (QR code)
2.2. Modo check-in assistido (NFC)
3. Registo de horas no dispositivo em modo off-line e posterior sincronização em modo on-line
3.1. Em modo off-line deverá registar os vários check-ins/outs calculando e mantendo disponíveis ao utilizador os períodos de trabalho
3.2. Uma vez obtida ligação à internet, deve ocorrer uma sincronização automática.
4. Backoffice para monitorização global dos recursos humanos
4.1. O backoffice deverá apresentar os detalhes históricos dos periodos de trabalho de cada empregado
4.2. O backoffice deverá apresentar em tmepo real o estado de cada trabalhador

---

### 1. "Check-in" automático no trabalho com base em geofencing

#### 1.1. O utilizador deverá ser notificado da sua entrada no perímetro delimitado

Poderá existir mais que uma obra a cada momento, todos os locais das obras devem ser registados com o objetivo de criar um perímetro (*geofence*) em torno do local. O objetivo é que o trabalhador (utilizador da app) seja notificado quando entra num desses perímetros a fim de validar o check-in.

Este *geofence* deve ser o mais apertado possível a fim de evitar incomodar o utilizador caso este esteja perto do perímetro mas não esteja a trabalhar. Pretendemos com isto que a sinalização da entrada no local de trabalho seja o mais rigoroso possível. Este formato rigoroso também a finalidade de impossibilitar que o trabalhador faça check-in quando na verdade não está a trabalhar.

#### 1.2. O utilizador deverá conseguir validar check-in

A iniciativa de fazer check-in e check-out deve ser da parte do trabalhador. Este controla o seu próprio tempo de trabalho. Assim, a aplicação não deverá automaticamente registar o check-in. Como mencionado no ponto anterior, o utilizador deverá ser notificado, e deverá ser apresentada uma forma de o utilizador interagir e confirmar que quer de facto fazer check-in.

De igual forma, o check-out deverá também ser validado. É possível até que, após o check-in, o trabalhador tenha que se afastar do perimetro também em trabalho. Nessa situação seria indesejável que o check-out ocorresse.

### 2. Check-in via QR code quando em modo offline e sincronizar quando retoma ligação

Uma vez que o dispositivo móvel pode estar temporariamente em modo off-line e o utilizador deverá conseguir na mesma realizar o check-in, são disponibiladas duas formas de fazer check-in via QR code.

#### 2.1. Modo check-in off-line ocioso (QR code)

Este modo de check-in é realizado pelo utilizador que deseja fazer check-in, para tal, deve utilizador o seu dispositivo para fazer a leitura um código QR disponível no local de trabalho.

Este QR code, um vez que serve para fazer check-in, deve conter informação da hora e do local de trabalho onde o utilizador está registar. Portanto, deve ser atualizado automaticamente em periódos curtos de tempo

#### 2.2. Modo check-in assistido (NFC)

O modo assistido funciona com recurso aos sensores de NFC. Como este modo, o utilizador off-line pode pedir a um colega para fazer o seu check-in. Isto é, o trabalhador (A) que deseja fazer o check-in e o trabalhador (B) que o assiste usam o NFC para passar o identificador de um para o outro.

```
Passo 1
                 _               via NFC              _
    User A      | |         --- id user A -->        | |       B User
                |A|                                  |B|
                 `                                    `
Passo 2

                 _              via NFC               _
    User A      | |    <-- timestamp + local ---     | |       B User
                |A|                                  |B|
                 `                                    `
Passo 3
                 _        via HTTP              
    User B      | |   --- id do user A -->      Sistema na Web
                |B|
                 `                          
```

Assim, via NFC, o utilizador **A** envia para o utilizador **B** o seu id. E o utilizador **B** envia para o **A** a data e hora e o local de trabalho. Nesta situação fica o dispositivo do utilizador **B** responsável por realizar o check-in e, ao mesmo tempo, o utilizador **A** fica logo com a informação no seu dispositivo (datae hora e local).


### 3. Registo de horas no dispositivo em modo off-line e posterior sincronização em modo on-line

#### 3.1. Em modo off-line deverá registar os vários check-ins/outs calculando e mantendo disponíveis ao utilizador os períodos de trabalho

O utilizador deve ter disponível um mapa com as horas de trabalho já realizado nas semanas em curso a fim de conseguir fazer a sua própria avalização e gestão das horas realizadas.

#### 3.2. Uma vez obtida ligação à internet, deve ocorrer uma sincronização automática.

Uma vez que a ligação web pode ser intermitente, e porque entre cada ligação on-line pode haver zero ou muitos check-in e check-outs, assim que o dispostivo obtenha estado on-line deve proceder à sincronização dos dados. Tanto para enviar os seus registos feitos em modo off-line, como para receber os registos feitos no modo assitido pelos seus colegas.

### 4. Backoffice para monitorização global dos recursos humanos

O backoffice deverá ser uma aplicação web que possibilite aos orgãos de gestão monitorizar os horários de trabalho

#### 4.1. O backoffice deverá apresentar os detalhes históricos dos periodos de trabalho de cada empregado

Para cada trabalhador deverá ser possível consultar o seu histórico de trabalho. Isto é, consultar dos os check-ins e check-outs para cada dia, assim como um somatório das horas trabalhados por dia, por semana, por mês e por ano.


#### 4.2. O backoffice deverá apresentar em tempo real o estado de cada trabalhador

Deverá também permitir que seja possível a qualquer momento consultar quais são os trabalhadores em cada obra, assim como a hora a que fizeram check-in. Claro, só aparecerá informação dos trabalhadores que fizeram check-in online, check-in assistido ou que já tenham feito a sincronização.

___

## Riscos importantes

- A fim de fazer um cálculo de horas fidigno, justo, imparcial e de acordo com a legislação laboral, os algoritmos de cálculo devem ser pensados com cuidado a fim de determinar com exatidão as horas de trabalho tendo em conta as particularidades dos anos bisextos e os feriados nacionais e municipais.
- Para as funcionalidade de detalhes históricos será interessante recorrer a bibliotecas já existentes a fim de renderizar gráficos para vizualizaçãos dos dados. Esta opção será a mais acertada dado que a programação de componentes visuais para este fim tem já alguma complexidade que é incompatível com o tempo disponivél à realização do projeto.