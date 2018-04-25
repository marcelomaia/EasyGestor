-- bugfix on update db
ALTER TABLE product drop column if exists scale;
ALTER TABLE product ADD COLUMN scale bool;
DROP TABLE IF EXISTS cest_data CASCADE;
CREATE TABLE cest_data
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,

  description varchar,
  code varchar,
  is_active boolean,

-- PK
  CONSTRAINT cest_data_id_pkey PRIMARY KEY (id ),

-- FOREIGN KEYS
  CONSTRAINT cest_data_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT cest_data_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT cest_data_te_created_id_key UNIQUE (te_created_id),
  CONSTRAINT cest_data_te_modified_id_key UNIQUE (te_modified_id)

);

DROP SEQUENCE IF EXISTS cest_data_id_seq CASCADE;

CREATE SEQUENCE cest_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

COPY cest_data(id, code, is_active, description) FROM stdin DELIMITER '|';
1|0100100|1|Catalisadores  em  colmeia  ceramica  ou  metalica  para  conversao catalitica de gases de escape de veiculos e outros catalizadores
2|0100200|1|Tubos  e  seus  acessorios  (por  exemplo,  juntas,  cotovelos,  flanges, unioes), de plasticos
3|0100300|1|Protetores de cacamba
4|0100400|1|Reservatorios de oleo
5|0100500|1|Frisos, decalques, molduras e acabamentos
6|0100600|1|Correias de transmissao de borracha vulcanizada, de materias texteis, mesmo impregnadas,  revestidas ou recobertas, de  plastico, ou estratificadas com plastico ou reforcadas com metal ou com outras materias
7|0100700|1|Juntas, gaxetas e outros elementos com funcao semelhante de vedacao
8|0100800|1|Partes de veiculos automoveis, tratores e maquinas autopropulsadas
9|0100900|1|Tapetes, revestimentos, mesmo confeccionados, batentes, buchas e coxins
10|0101000|1|Tecidos impregnados, revestidos, recobertos ou estratificados, com plastico
11|0101100|1|Mangueiras e tubos semelhantes, de materias texteis, mesmo com reforco ou acessorios de outras materias
12|0101200|1|Encerados e toldos
13|0101300|1|Capacetes e artefatos de uso semelhante, de protecao, para uso em motocicletas, incluidos ciclomotores
14|0101400|1|Guarnicoes de friccao (por exemplo, placas, rolos, tiras, segmentos, discos, aneis, pastilhas), nao montadas, para freios, embreagens ou qualquer outro mecanismo de friccao, a base de amianto, de outras substancias minerais ou de celulose, mesmo combinadas com texteis ou outras materias
15|0101500|1|Vidros de dimensoes e formatos que permitam aplicacao automotiva
16|0101600|1|Espelhos retrovisores
17|0101700|1|Lentes de farois, lanternas e outros utensilios
18|0101800|1|Cilindro de aco para GNV (gas natural veicular)
19|0101900|1|Recipientes para gases comprimidos ou liquefeitos, de ferro fundido, ferro ou aco, exceto o descrito no item 180
20|0102000|1|Molas e folhas de molas, de ferro ou aco
21|0102100|1|Obras moldadas, de ferro fundido, ferro ou aco, exceto as do codigo 73259100
22|0102200|1|Peso de chumbo para balanceamento de roda
23|0102300|1|Peso para balanceamento de roda e outros utensilios de estanho
24|0102400|1|Fechaduras e partes de fechaduras
25|0102500|1|Chaves apresentadas isoladamente
26|0102600|1|Dobradicas, guarnicoes, ferragens e artigos semelhantes de metais comuns
27|0102700|1|Triangulo de seguranca
28|0102800|1|Motores de pistao alternativo dos tipos utilizados para propulsao de veiculos do Capitulo 87
29|0102900|1|Motores dos tipos utilizados para propulsao de veiculos automotores
30|0103000|1|Partes reconheciveis como exclusiva ou principalmente destinadas aos motores das posicoes 8407 ou 8408
31|0103100|1|Motores hidraulicos
32|0103200|1|Bombas para combustiveis, lubrificantes ou liquidos de arrefecimento, proprias para motores de ignicao por centelha ou por compressao
33|0103300|1|Bombas de vacuo
34|0103400|1|Compressores e turbocompressores de ar
35|0103500|1|Partes das bombas, compressores e turbocompressores dos itens 320, 330 e 340
36|0103600|1|Maquinas e aparelhos de ar condicionado
37|0103700|1|Aparelhos  para  filtrar  oleos  minerais  nos  motores  de  ignicao  por centelha ou por compressao
38|0103800|1|Filtros a vacuo
39|0103900|1|Partes dos aparelhos para filtrar ou depurar liquidos ou gases
40|0104000|1|Extintores, mesmo carregados
41|0104100|1|Filtros de entrada de ar para motores de ignicao por centelha ou por compressao
42|0104200|1|Depuradores por conversao catalitica de gases de escape
43|0104300|1|Macacos
44|0104400|1|Partes para macacos do item 430
45|0104500|1|Partes reconheciveis como exclusiva ou principalmente destinadas as maquinas agricolas ou rodoviarias
46|0104600|1|Valvulas redutoras de pressao
47|0104700|1|Valvulas para transmissao oleo-hidraulicas ou pneumaticas
48|0104800|1|Valvulas solenoides
49|0104900|1|Rolamentos
50|0105000|1|"Arvores de transmissao (incluidas as arvores de ""cames""e virabrequins) e manivelas; mancais e ""bronzes""; engrenagens e rodas de friccao; eixos de esferas ou de roletes; redutores, multiplicadores, caixas de transmissao e variadores de velocidade, incluidos os conversores de torque; volantes e polias, incluidas as polias para cadernais; embreagens e dispositivos de acoplamento, incluidas as juntas de articulacao"
51|0105100|1|Juntas metaloplasticas; jogos ou sortidos de juntas de composicoes diferentes, apresentados em bolsas, envelopes ou embalagens semelhantes; juntas de vedacao mecanicas (selos mecanicos)
52|0105200|1|Acoplamentos,   embreagens,   variadores   de   velocidade   e   freios, eletromagneticos
53|0105300|1|Acumuladores eletricos de chumbo, do tipo utilizado para o arranque dos motores de pistao
54|0105400|1|Aparelhos e dispositivos eletricos de ignicao ou de arranque para motores de ignicao por centelha ou por compressao (por exemplo, magnetos, dinamos-magnetos, bobinas de ignicao, velas de ignicao ou de aquecimento, motores de arranque); geradores (dinamos e alternadores, por exemplo) e conjuntores-disjuntores utilizados com estes motores
55|0105500|1|Aparelhos eletricos de iluminacao ou de sinalizacao (exceto os da posicao 8539), limpadores de para-brisas, degeladores e desembacadores (desembaciadores) eletricos
56|0105600|1|Telefones moveis
57|0105700|1|Alto-falantes, amplificadores eletricos de audiofrequencia e partes
58|0105800|1|Aparelhos eletricos de amplificacao de som para veiculos automotores
59|0105900|1|Aparelhos de reproducao de som
60|0106000|1|Aparelhos     transmissores     (emissores)     de     radiotelefonia     ou radiotelegrafia (radio receptor/transmissor)
61|0106100|1|Aparelhos receptores de radiodifusao que so funcionam com fonte externa de energia, exceto os classificados na posicao 85272190
62|0106200|1|Outros aparelhos receptores de radiodifusao que funcionem com fonte externa de energia; outros aparelhos videofonicos de gravacao ou de reproducao, mesmo incorporando um receptor de sinais videofonicos, dos tipos utilizados exclusivamente em veiculos automotores
63|0106300|1|Antenas
64|0106400|1|Circuitos impressos
65|0106500|1|Interruptores e seccionadores e comutadores
66|0106600|1|Fusiveis e corta-circuitos de fusiveis
67|0106700|1|Disjuntores
68|0106800|1|Reles
69|0106900|1|Partes reconheciveis como exclusivas ou principalmente destinados aos aparelhos dos itens 650, 660, 670 e 680
70|0107000|1|Interruptores, seccionadores e comutadores
71|0107100|1|Farois e projetores, em unidades seladas
72|0107200|1|Lampadas e tubos de incandescencia, exceto de raios ultravioleta ou infravermelhos
73|0107300|1|Cabos coaxiais e outros condutores eletricos coaxiais
74|0107400|1|Jogos de fios para velas de ignicao e outros jogos de fios
75|0107500|1|Carrocarias para os veiculos automoveis das posicoes 8701 a 8705, incluidas as cabinas
76|0107600|1|Partes e acessorios dos veiculos automoveis das posicoes 8701 a 8705
77|0107700|1|Parte e acessorios de motocicletas (incluidos os ciclomotores)
78|0107800|1|Engates para reboques e semi-reboques
79|0107900|1|Medidores de nivel; Medidores de vazao
80|0108000|1|Aparelhos para medida ou controle da pressao
81|0108100|1|Contadores, indicadores de velocidade e tacometros, suas partes e acessorios
82|0108200|1|Amperimetros
83|0108300|1|Aparelhos digitais, de uso em veiculos automoveis, para medida e indicacao de multiplas grandezas tais como: velocidade media, consumos instantaneo e medio e autonomia (computador de bordo)
84|0108400|1|Controladores eletronicos
85|0108500|1|Relogios para paineis de instrumentos e relogios semelhantes
86|0108600|1|Assentos e partes de assentos
87|0108700|1|Acendedores
88|0108800|1|Tubos de borracha vulcanizada nao endurecida, mesmo providos de seus acessorios
89|0108900|1|Juntas de vedacao de cortica natural e de amianto
90|0109000|1|Papel-diagrama para tacografo, em disco
91|0109100|1|Fitas, tiras, adesivos, auto-colantes, de plastico, refletores, mesmo em rolos; placas metalicas com pelicula de plastico refletora, proprias para colocacao em carrocerias, para-choques de veiculos de carga, motocicletas, ciclomotores, capacetes, bones de agentes de transito e de condutores de veiculos, atuando como dispositivos refletivos de seguranca rodoviarios
92|0109200|1|Cilindros pneumaticos
93|0109300|1|Bomba eletrica de lavador de para-brisa
94|0109400|1|Bomba de assistencia de direcao hidraulica
95|0109500|1|Motoventiladores
96|0109600|1|Filtros de polen do ar-condicionado
97|0109700|1|"""Maquina"" de vidro eletrico de porta"
98|0109800|1|Motor de limpador de para-brisa
99|0109900|1|Bobinas de reatancia e de auto-inducao
100|0110000|1|Baterias de chumbo e de niquel-cadmio
101|0110100|1|Aparelhos de sinalizacao acustica (buzina)
102|0110200|1|Instrumentos para regulacao de grandezas nao eletricas
103|0110300|1|Analisadores de gases ou de fumaca (sonda lambda)
104|0110400|1|Perfilados de borracha vulcanizada nao endurecida
105|0110500|1|Artefatos de pasta de fibra de uso automotivo
106|0110600|1|Tapetes/carpetes - nailon
107|0110700|1|Tapetes de materias texteis sinteticas
108|0110800|1|Forracao interior capacete
109|0110900|1|Outros para-brisas
110|0111000|1|Moldura com espelho
111|0111100|1|Corrente de transmissao
112|0111200|1|Corrente transmissao
113|0111300|1|Outras correntes de transmissao
114|0111400|1|Condensador tubular metalico
115|0111500|1|Trocadores de calor
116|0111600|1|Partes de aparelhos mecanicos de pulverizar ou dispersar
117|0111700|1|Macacos manuais para veiculos
118|0111800|1|Cacambas, pas, ganchos e tenazes para maquinas rodoviarias
119|0111900|1|Geradores de corrente alternada de potencia nao superior a 75 kva
120|0112000|1|Aparelhos eletricos para alarme de uso automotivo
121|0112100|1|Bussolas
122|0112200|1|Indicadores de temperatura
123|0112300|1|Partes de indicadores de temperatura
124|0112400|1|Partes de aparelhos de medida ou controle
125|0112500|1|Termostatos
126|0112600|1|Instrumentos e aparelhos para regulacao
127|0112700|1|Pressostatos
128|0112800|1|Pecas para reboques e semi-reboques
129|0112900|1|Outras  pecas,  partes  e  acessorios  para  veiculos  automotores  nao relacionados nos demais itens deste anexo
130|0200100|1|Aperitivos, amargos, bitter e similares
131|0200200|1|Batida e similares
132|0200300|1|Bebida ice
133|0200400|1|Cachaca e aguardentes
134|0200500|1|Catuaba e similares
135|0200600|1|Conhaque, brandy e similares
136|0200700|1|Cooler
137|0200800|1|Gim (gin) e genebra
138|0200900|1|Jurubeba e similares
139|0201000|1|Licores e similares
140|0201100|1|Pisco
141|0201200|1|Rum
142|0201300|1|Saque
143|0201400|1|Steinhaeger
144|0201500|1|Tequila
145|0201600|1|Uisque
146|0201700|1|Vermute e similares
147|0201800|1|Vodka
148|0201900|1|Derivados de vodka
149|0202000|1|Arak
150|0202100|1|Aguardente vinica / grappa
151|0202200|1|Sidra e similares
152|0202300|1|Sangrias e coqueteis
153|0202400|1|Vinhos e similares
154|0202500|1|Outras bebidas alcoolicas nao especificadas nos itens anteriores
155|0300100|1|Agua mineral, gasosa ou nao, ou potavel, naturais, em garrafa de vidro, retornavel ou nao, com capacidade de ate 500 ml
156|0300200|1|Agua mineral, gasosa ou nao, ou potavel, naturais, em embalagem com capacidade igual ou superior a 5000 ml
157|0300300|1|Agua mineral, gasosa ou nao, ou potavel, naturais, em embalagem de vidro, nao retornavel, com capacidade de ate 300 ml
158|0300400|1|Agua mineral, gasosa ou nao, ou potavel, naturais, em garrafa plastica de 1500 ml
159|0300500|1|Agua mineral, gasosa ou nao, ou potavel, naturais, em copos plasticos e embalagem plastica com capacidade de ate 500 ml
160|0300600|1|Outras aguas minerais, gasosa ou nao, ou potavel, naturais, inclusive gaseificada ou aromatizada artificialmente
161|0300700|1|Refrigerante em garrafa com capacidade igual ou superior a 600 ml
162|0300800|1|Demais refrigerantes
163|0300900|1|"Xarope ou extrato concentrado destinados ao preparo de refrigerante em maquina ""pre-mix""ou ""post-mix"""
164|0301000|1|Bebidas energeticas
165|0301100|1|Bebidas hidroeletroliticas (isotonicas)
166|0301200|1|Cerveja
167|0301300|1|Cerveja sem alcool
168|0301400|1|Chope
169|0400100|1|Charutos, cigarrilhas e cigarros, de tabaco ou dos seus sucedaneos
170|0400200|1|Tabaco para fumar, mesmo contendo sucedaneos de tabaco em qualquer proporcao
171|0500100|1|Cimento
172|0600100|1|Alcool etilico nao desnaturado, com um teor alcoolico em volume igual ou superior a 80% vol (alcool etilico anidro combustivel e alcool etilico hidratado combustivel)
173|0600200|1|Gasolinas
174|0600300|1|Querosenes
175|0600400|1|Oleos combustiveis
176|0600500|1|Oleos lubrificantes
177|0600600|1|Outros oleos de petroleo ou de minerais betuminosos (exceto oleos brutos) e preparacoes nao especificadas nem compreendidas noutras posicoes, que contenham, como constituintes basicos, 70% ou mais, em peso, de oleos de petroleo ou de inerais betuminosos, exceto os que contenham biodiesel e exceto os residuos de oleos
178|0600700|1|Residuos de oleos
179|0600800|1|Gas de petroleo e outros hidrocarbonetos gasosos
180|0600900|1|Coque de petroleo e outros residuos de oleo de petroleo ou de minerais betuminosos
181|0601000|1|Biodiesel e suas misturas, que nao contenham ou que contenham menos de 70%, em peso, de oleos de petroleo ou de oleos minerais betuminosos
182|0601100|1|Preparacoes lubrificantes, exceto as contendo, como constituintes de base, 70% ou mais, em peso, de oleos de petroleo ou de minerais betuminosos
183|0601200|1|Oleos de petroleo ou de minerais betuminosos (exceto oleos brutos) e preparacoes nao especificadas nem compreendidas noutras posicoes, que contenham, como constituintes basicos, 70% ou mais, em peso, de oleos de petroleo ou de minerais betuminosos, que contenham biodiesel, exceto os residuos de oleos
184|0700100|1|Energia eletrica
185|0800100|1|Ferramentas de borracha vulcanizada nao endurecida
186|0800200|1|Ferramentas, armacoes e cabos de ferramentas, de madeira
187|0800300|1|Mos e artefatos semelhantes, sem armacao, para moer, desfibrar, triturar, amolar, polir, retificar ou cortar; pedras para amolar ou para polir, manualmente, e suas partes, de pedras naturais, de abrasivos naturais ou artificiais aglomerados ou de ceramica, mesmo com partes de outras materias
188|0800400|1|Pas, alvioes, picaretas, enxadas, sachos, forcados  e  forquilhas, ancinhos e raspadeiras; machados, podoes e ferramentas semelhantes com gume; tesouras de podarde todos os tipos; foices e foicinhas, facas para feno ou para palha, tesouras para sebes, cunhas e outras ferramentas manuais para agricultura, horticultura ou silvicultura
189|0800500|1|Folhas de serras de fita
190|0800600|1|Laminas de serras maquinas
191|0800700|1|Serras manuais e outras folhas de serras (incluidas as fresas-serras e as folhas nao dentadas para serrar), exceto as classificadas nas posicoes 82022000 e 82029100
192|0800800|1|Limas, grosas, alicates (mesmo cortantes), tenazes, pincas, cisalhas para metais, corta-tubos, corta-pinos, saca-bocados e ferramentas semelhantes, manuais, exceto as pincas para sobrancelhas classificadas na posicao 82032090
193|0800900|1|Chaves  de  porcas,  manuais  (incluidas  as  chaves  dinamometricas); chaves de caixa intercambiaveis, mesmo com cabos
194|0801000|1|Ferramentas manuais (incluidos os diamantes de vidraceiro) nao especificadas nem compreendidas em outras posicoes, lamparinas ou lampadas de soldar (macaricos) e semelhantes; tornos de apertar, sargentos e semelhantes, exceto os acessorios ou partes de maquinas- ferramentas; bigornas; forjas-portateis; mos com armacao, manuais ou de pedal
195|0801100|1|Ferramentas   de   pelo   menos   duas   das   posicoes   8202   a   8205, acondicionadas em sortidos para venda a retalho
196|0801200|1|Ferramentas de roscar interior ou exteriormente; de mandrilar ou de brochar; e de fresar
197|0801300|1|Outras ferramentas intercambiaveis para ferramentas manuais, mesmo mecanicas, ou para maquinas-ferramentas (por exemplo, de embutir, estampar, puncionar, furar, tornear, aparafusar), incluidas as fieiras de estiragem ou de extrusao, para metais, e as ferramentas de perfuracao ou de sondagem, exceto forma ou gabarito de produtos em epoxy, exceto as classificadas nas posicoes 820740, 820760 e 820770
198|0801400|1|Facas e laminas cortantes, para maquinas ou para aparelhos mecanicos
199|0801500|1|Plaquetas ou pastilhas intercambiaveis
200|0801600|1|"Outras plaquetas, varetas, pontas e objetos semelhantes para ferramentas, nao montados, de ceramais (""cermets""), exceto as classificadas na posicao 82090011"
201|0801700|1|Facas (exceto as da posicao 8208) de lamina cortante ou serrilhada, incluidas as podadeiras de lamina movel, e suas laminas, exceto as de uso domestico
202|0801800|1|Tesouras e suas laminas
203|0801900|1|Ferramentas pneumaticas, hidraulicas ou com motor (eletrico ou nao eletrico) incorporado, de uso manual
204|0802000|1|Instrumentos e aparelhos de geodesia, topografia, agrimensura, nivelamento, fotogrametria, hidrografia, oceanografia, hidrologia, meteorologia ou de geofisica, exceto bussolas; telemetros
205|0802100|1|Instrumentos   de   desenho,   de   tracado   ou   de   calculo;   metros, micrometros, paquimetros, calibres e semelhantes; partes e acessorios
206|0802200|1|Termometros, suas partes e acessorios
207|0802300|1|Pirometros, suas partes e acessorios
208|0900100|1|Lampadas eletricas
209|0900200|1|Lampadas eletronicas
210|0900300|1|Reatores para lampadas ou tubos de descargas
211|0900400|1|Starter
212|0900500|1|Lampadas de LED (Diodos Emissores de Luz)
213|1000100|1|Cal
214|1000200|1|Argamassas
215|1000300|1|Outras argamassas
216|1000400|1|Silicones em formas primarias, para uso na construcao
217|1000500|1|Revestimentos de PVC e outros plasticos; forro, sancas e afins de PVC, para uso na construcao
218|1000600|1|Tubos,  e  seus  acessorios  (por  exemplo,  juntas,  cotovelos,  flanges, unioes), de plasticos, para uso na construcao
219|1000700|1|Revestimento de pavimento de PVC e outros plasticos
220|1000800|1|Chapas, folhas,  tiras, fitas,  peliculas e outras formas planas, auto- adesivas, de plasticos, mesmo em rolos, para uso na construcao
221|1000900|1|Veda rosca, lona plastica para uso na construcao, fitas isolantes e afins
222|1001000|1|Telha de plastico, mesmo reforcada com fibra de vidro
223|1001100|1|Cumeeira de plastico, mesmo reforcada com fibra de vidro
224|1001200|1|Chapas, laminados plasticos em bobina, para uso na construcao, exceto os descritos nos itens 100 e 110
225|1001300|1|Banheiras, boxes para chuveiros, pias, lavatorios, bides, sanitarios e seus assentos e tampas, caixas de descarga e artigos semelhantes para usos sanitarios ou higienicos, de plasticos
226|1001400|1|Artefatos de higiene/toucador de plastico, para uso na construcao
227|1001500|1|"Caixa dagua, inclusive sua tampa, de plastico, mesmo reforcadas com fibra de vidro"
228|1001600|1|"Outras  telhas,  cumeeira  e  caixa  dagua,  inclusive  sua  tampa,  de plastico, mesmo reforcadas com fibra de vidro"
229|1001700|1|Artefatos para apetrechamento de construcoes, de plasticos, nao especificados nem compreendidos em outras posicoes, incluindo persianas, sancas, molduras, apliques e rosetas, caixilhos de polietileno e outros plasticos, exceto os descritos nos itens 150 e 160
230|1001800|1|Portas, janelas e seus caixilhos, alizares e soleiras
231|1001900|1|Postigos, estores (incluidas as venezianas) e artefatos semelhantes e suas partes
232|1002000|1|Outras obras de plastico, para uso na construcao
233|1002100|1|Papel de parede e revestimentos de parede semelhantes; papel para vitrais
234|1002200|1|Telhas de concreto
235|1002300|1|"Telha, cumeeira e caixa dagua, inclusive sua tampa, de fibrocimento,cimento-celulose"
236|1002400|1|Caixas d'agua, tanques e reservatorios e suas tampas, telhas, calhas, cumeeiras e afins, de fibrocimento, cimento-celulose ou semelhantes, contendo ou nao amianto, exceto os descritos no item 230
237|1002500|1|"Tijolos, placas (lajes), ladrilhos e outras pecas ceramicas de farinhas siliciosas fosseis (""kieselghur"", tripolita, diatomita, por exemplo) ou de terras siliciosas semelhantes"
238|1002600|1|Tijolos, placas (lajes), ladrilhos e pecas ceramicas semelhantes, para uso na construcao, refratarios, que nao sejam de farinhas siliciosas fosseis nem de terras siliciosas semelhantes
239|1002700|1|Tijolos para construcao, tijoleiras, tapa-vigas e produtos semelhantes, de ceramica
240|1002800|1|Telhas, elementos de chamines, condutores de fumaca, ornamentos arquitetonicos, de ceramica, e outros produtos ceramicos para uso na construcao
241|1002900|1|Tubos, calhas ou algerozes e acessorios para canalizacoes, de ceramica
242|1003000|1|Ladrilhos e placas de ceramica, exclusivamente para pavimentacao ou revestimento
243|1003001|1|Cubos,  pastilhas  e  artigos  semelhantes  de  ceramica,  mesmo  com suporte
244|1003100|1|Pias, lavatorios, colunas para lavatorios, banheiras, bides, sanitarios, caixas de descarga, mictorios e aparelhos fixos semelhantes para usos sanitarios, de ceramica
245|1003200|1|Artefatos de higiene/toucador de ceramica
246|1003300|1|Vidro vazado ou laminado, em chapas, folhas ou perfis, mesmo com camada absorvente, refletora ou nao, mas sem qualquer outro trabalho
247|1003400|1|Vidro estirado ou soprado, em folhas, mesmo com camada absorvente, refletora ou nao, mas sem qualquer outro trabalho
248|1003500|1|Vidro flotado e vidro desbastado ou polido em uma ou em ambas as faces, em chapas ou em folhas, mesmo com camada absorvente, refletora ou nao, mas sem qualquer outro trabalho
249|1003600|1|Vidros temperados
250|1003700|1|Vidros laminados
251|1003800|1|Vidros isolantes de paredes multiplas
252|1003900|1|Blocos, placas, tijolos, ladrilhos, telhas e outros artefatos, de vidro prensado ou moldado, mesmo armado, para uso na construcao; cubos, pastilhas e outros artigos semelhantes
253|1004000|1|Barras proprias para construcoes, exceto vergalhoes
254|1004100|1|Outras barras proprias para construcoes, exceto vergalhoes
255|1004200|1|Vergalhoes
256|1004300|1|Outros vergalhoes
257|1004400|1|Fios de ferro ou aco nao  ligados, nao revestidos, mesmo polidos; cordas, cabos, trancas (entrancados), lingas e artefatos semelhantes, de ferro ou aco, nao isolados para usos eletricos
258|1004500|1|Outros fios de ferro ou aco, nao ligados, galvanizados
259|1004600|1|Acessorios para tubos (inclusive unioes, cotovelos, luvas ou mangas), de ferro fundido, ferro ou aco
260|1004700|1|Portas e janelas, e seus caixilhos, alizares e soleiras de ferro fundido, ferro ou aco
261|1004800|1|Material para andaimes, para armacoes (cofragens) e para escoramentos, (inclusive armacoes prontas, para estruturas de concreto armado ou argamassa armada), eletrocalhas e perfilados de ferro fundido, ferro ou aco, proprios para construcao, exceto trelicas de aco
262|1004900|1|Trelicas de aco
263|1005000|1|Telhas metalicas
264|1005100|1|Caixas diversas (tais como caixa de correio, de entrada de agua, de energia, de instalacao) de ferro, ferro fundido ou aco; proprias para a construcao
265|1005200|1|Arame farpado, de ferro ou aco arames ou tiras, retorcidos, mesmo farpados, de ferro ou aco, dos tipos utilizados em cercas
266|1005300|1|Telas metalicas, grades e redes, de fios de ferro ou aco
267|1005400|1|Correntes de rolos, de ferro fundido, ferro ou aco
268|1005500|1|Outras correntes de elos articulados, de ferro fundido, ferro ou aco
269|1005600|1|Correntes de elos soldados, de ferro fundido, de ferro ou aco
270|1005700|1|Tachas, pregos, percevejos, escapulas, grampos ondulados ou biselados e artefatos semelhantes, de ferro fundido, ferro ou aco, mesmo com a cabeca de outra materia, exceto cobre
271|1005800|1|Parafusos, pinos ou pernos, roscados, porcas, tira-fundos, ganchos roscados, rebites, chavetas, cavilhas, contrapinos, arruelas (incluidas as de pressao) e artefatos semelhantes, de ferro fundido, ferro ou aco
272|1005900|1|Palha de ferro ou aco; esponjas, esfregoes, luvas e artefatos semelhantes para limpeza, polimento e usos semelhantes, de ferro ou aco, exceto os classificados na posicao 73231000 de uso domestico
273|1006000|1|Artefatos de higiene ou de toucador, e suas partes, de ferro fundido, ferro ou aco, incluidas as pias, banheiras, lavatorios, cubas, mictorios, tanques e afins de ferro fundido, ferro ou aco, para uso na construcao
274|1006100|1|Outras obras moldadas, de ferro fundido, ferro ou aco, para uso na construcao
275|1006200|1|Abracadeiras
276|1006300|1|Barras de cobre
277|1006400|1|Tubos de cobre e suas ligas, para instalacoes de agua quente e gas, para uso na construcao
278|1006500|1|Acessorios  para  tubos  (por  exemplo,  unioes,  cotovelos,  luvas  ou mangas) de cobre e suas ligas, para uso na construcao
279|1006600|1|Tachas, pregos, percevejos, escapulas e artefatos semelhantes, de cobre, ou de ferro ou aco com cabeca de cobre, parafusos, pinos ou pernos, roscados, porcas, ganchos roscados, rebites, chavetas, cavilhas, contrapinos, arruelas (incluidas as de pressao), e artefatos semelhantes, de cobre
280|1006700|1|Artefatos de higiene/toucador de cobre, para uso na construcao
281|1006800|1|Manta de subcobertura aluminizada
282|1006900|1|Tubos de aluminio e suas ligas, para refrigeracao e ar condicionado, para uso na construcao
283|1007000|1|Acessorios  para  tubos  (por  exemplo,  unioes,  cotovelos,  luvas  ou mangas), de aluminio, para uso na construcao
284|1007100|1|Construcoes e suas partes (por exemplo, pontes e elementos de pontes, torres, porticos ou pilones, pilares, colunas, armacoes, estruturas para telhados, portas e janelas, e seus caixilhos, alizares e soleiras, balaustradas), de aluminio, exceto as construcoes pre-fabricadas da posicao 9406; chapas, barras, perfis, tubos e semelhantes, de aluminio, proprios para construcoes
285|1007200|1|Artefatos de higiene/toucador de aluminio, para uso na construcao
286|1007300|1|Outras  obras  de  aluminio,  proprias  para  construcoes,  incluidas  as persianas
287|1007400|1|Outras guarnicoes, ferragens e artigos semelhantes de metais comuns, para construcoes, inclusive puxadores
288|1007500|1|Fechaduras e ferrolhos (de chave, de segredo ou eletricos), de metais comuns, incluidas as suas partes fechos e armacoes com fecho, com fechadura, de metais comuns chaves para estes artigos, de metais comuns, exceto os de uso automotivo
289|1007600|1|Dobradicas de metais comuns, de qualquer tipo
290|1007700|1|Tubos flexiveis de metais comuns, mesmo com acessorios, para uso na construcao
291|1007800|1|Fios, varetas, tubos, chapas, eletrodos e artefatos semelhantes, de metais comuns ou de carbonetos metalicos, revestidos exterior ou interiormente de decapantes ou de fundentes, para soldagem (soldadura) ou deposito de metal ou de carbonetos metalicos fios e varetas de pos de metais comuns aglomerados, para metalizacao por projecao
292|1007900|1|Torneiras, valvulas (incluidas as redutoras de pressao e as termostaticas) e dispositivos semelhantes, para canalizacoes, caldeiras, reservatorios, cubas e outros recipientes
293|1100100|1|Agua sanitaria, branqueador e outros alvejantes
294|1100200|1|Saboes em po, flocos, palhetas, granulos ou outras formas semelhantes, para lavar roupas
295|1100300|1|Saboes liquidos para lavar roupas
296|1100400|1|Detergentes  em  po,  flocos,  palhetas,  granulos  ou  outras  formas semelhantes
297|1100500|1|Detergentes liquidos, exceto para lavar roupa
298|1100600|1|Detergente liquido para lavar roupa
299|1100700|1|Outros agentes organicos de superficie (exceto saboes); preparacoes tensoativas, preparacoes para lavagem (incluidas as preparacoes auxiliares para lavagem) e preparacoes para limpeza (inclusive multiuso e limpadores), mesmo contendo sabao, exceto as da posicao 3401 e os produtos descritos nos itens 3 a 5; em embalagem de conteudo inferior ou igual a 50 litros ou 50 kg
300|1100800|1|Amaciante/suavizante
301|1100900|1|Esponjas para limpeza
302|1101000|1|Alcool etilico para limpeza
303|1101100|1|Palhas de ferro ou aco; esponjas, esfregoes, luvas e artefatos semelhantes para limpeza, polimento ou uso semelhantes; todos de uso domestico
304|1200100|1|Transformadores, bobinas de reatancia e de auto inducao, inclusive os transformadores de potencia superior  a 16 KVA,  classificados nas posicoes 85043300 e 85043400; exceto os demais transformadores da subposicao 85043, os reatores para lampadas eletricas de descarga classificados no codigo 85041000,  os  carregadores  de acumuladores do codigo 85044010, os equipamentos de alimentacao ininterrupta de energia (UPS ou no break), no codigo 85044040 e os de uso automotivo
305|1200200|1|Aquecedores eletricos de agua, incluidos os de imersao, chuveiros ou duchas eletricos, torneiras eletricas, resistencias de aquecimento, inclusive as de duchas e chuveiros eletricos e suas partes; exceto outros fornos, fogareiros (incluidas as chapas de coccao), grelhas e assadeiras, classificados na posicao 85166000
306|1200300|1|Aparelhos para interrupcao, seccionamento, protecao, derivacao, ligacao ou conexao de circuitos eletricos (por exemplo, interruptores, comutadores, corta-circuitos, para-raios, limitadores de tensao, eliminadores de onda, tomadas de corrente e outros conectores, caixas de juncao), para tensao superior a 1000V, exceto os de uso automotivo
307|1200400|1|"Aparelhos para interrupcao, seccionamento, protecao, derivacao, ligacao ou conexao de circuitos eletricos (por exemplo, interruptores, comutadores, reles, corta-circuitos, eliminadores de onda, plugues e tomadas de corrente, suportes para lampadas e outros conectores, caixas de juncao), para uma tensao nao superior a 1000V; conectores para fibras opticas, feixes ou cabos de fibras opticas; exceto ""starter"" classificado na subposicao 853650 e os de uso automotivo"
308|1200500|1|Partes reconheciveis como exclusiva ou principalmente destinadas aos aparelhos das posicoes 8535 e 8536
309|1200600|1|Cabos,  trancas  e  semelhantes,  de  cobre,  nao  isolados  para  usos eletricos, exceto os de uso automotivo
310|1200700|1|Fios, cabos (incluidos os cabos coaxiais) e outros condutores, isolados ou nao, para usos eletricos (incluidos os de cobre ou aluminio, envernizados ou oxidados anodicamente), mesmo com pecas de conexao, inclusive fios e cabos eletricos, para tensao nao superior a 1000V, para uso na construcao; fios e cabos telefonicos e para transmissao de dados; cabos de fibras opticas, constituidos de fibras embainhadas individualmente, mesmo com condutores  eletricos ou munidos de pecas de conexao; cordas, cabos, trancas e semelhantes, de aluminio, nao isolados para uso eletricos; exceto os de uso automotivo
311|1200800|1|Isoladores de qualquer materia, para usos eletricos
312|1200900|1|Pecas isolantes inteiramente de materias isolantes, ou com simples pecas metalicas de montagem (suportes roscados, por exemplo) incorporadas na massa, para maquinas, aparelhos e instalacoes eletricas; tubos isoladores e suas pecas de ligacao, de metais comuns, isolados interiormente
313|1300100|1|Medicamentos de referencia  positiva
314|1300101|1|Medicamentos de referencia  negativa
315|1300102|1|Medicamentos de referencia  neutra
316|1300200|1|Medicamentos generico  positiva
317|1300201|1|Medicamentos generico  negativa
318|1300202|1|Medicamentos generico  neutra
319|1300300|1|Medicamentos similar  positiva
320|1300301|1|Medicamentos similar  negativa
321|1300302|1|Medicamentos similar  neutra
322|1300400|1|Outros tipos de medicamentos  positiva
323|1300401|1|Outros tipos de medicamentos - negativa
324|1300402|1|Outros tipos de medicamentos  neutra
325|1300500|1|Preparacoes quimicas contraceptivas a base de hormonios, de outros produtos da posicao 2937 ou de espermicidas
326|1300600|1|Provitaminas e vitaminas, naturais ou reproduzidas por sintese (incluidos os concentrados naturais), bem como os seus derivados utilizados principalmente como vitaminas, misturados ou nao entre si, mesmo em quaisquer solucoes
327|1300700|1|Preparacoes opacificantes (contrastantes) para exames radiograficos e reagentes de diagnostico concebidos para serem administrados ao paciente
328|1300800|1|Antissoro, outras fracoes do  sangue,  produtos imunologicos modificados, mesmo obtidos por via biotecnologica; vacinas para medicina humana; e produtos semelhantes
329|1300900|1|Algodao, atadura, esparadrapo, haste flexivel ou nao, com uma ou ambas extremidades de algodao, gazes, pensos, sinapismos, e outros, impregnados ou  recobertos de substancias  farmaceuticas  ou acondicionados para venda a retalho para usos medicinais, cirurgicos ou dentarios
330|1301000|1|Luvas cirurgicas e luvas de procedimento
331|1301100|1|Preservativo
332|1301200|1|Seringas, mesmo com agulhas
333|1301300|1|Agulhas para seringas
334|1301400|1|Contraceptivos (dispositivos intra-uterinos - DIU)
335|1400100|1|Filtros descartaveis para coar cafe ou cha
336|1400200|1|Bandejas, travessas, pratos, xicaras ou chavenas, tacas, copos e artigos semelhantes, de papel ou cartao
337|1400300|1|Papel para cigarro
338|1500100|1|Lonas plasticas, exceto as para uso na construcao
339|1500200|1|Artefatos  de  higiene/toucador  de  plastico,  exceto  os  para  uso  na construcao
340|1500300|1|Servicos  de  mesa  e  outros  utensilios  de  mesa  ou  de  cozinha,  de plastico, inclusive os descartaveis
341|1600100|1|Pneus novos, dos tipos utilizados em automoveis de passageiros (incluidos os veiculos de uso misto - camionetas e os automoveis de corrida)
342|1600200|1|Pneus novos, dos tipos utilizados em caminhoes (inclusive para os fora-de-estrada), onibus, avioes, maquinas de terraplenagem, de construcao e conservacao de estradas, maquinas e tratores agricolas, pa-carregadeira
343|1600300|1|Pneus novos para motocicletas
344|1600400|1|Outros tipos de pneus novos, exceto para bicicletas
345|1600500|1|Pneus novos de borracha dos tipos utilizados em bicicletas
346|1600600|1|Pneus recauchutados
347|1600700|1|Protetores de borracha, exceto para bicicletas
348|1600701|1|Protetores de borracha para bicicletas
349|1600800|1|Camaras de ar de borracha, exceto para bicicletas
350|1600900|1|Camaras de ar de borracha dos tipos utilizados em bicicletas
351|1700100|1|Chocolate branco, em embalagens de conteudo inferior ou igual a 1 kg
352|1700200|1|Chocolates contendo cacau, em embalagens de conteudo inferior ou igual a 1 kg
353|1700300|1|Chocolate em barras, tabletes ou blocos ou no estado liquido, em pasta, em po, granulos ou formas semelhantes, em recipientes ou embalagens imediatas de conteudo inferior ou igual a 2 kg
354|1700400|1|Chocolates e outras preparacoes alimenticias contendo cacau, em embalagens de conteudo inferior ou igual a 1 kg, excluidos os achocolatados em po
355|1700500|1|Achocolatados em po, em embalagens de conteudo inferior ou igual a 1 kg
356|1700600|1|Caixas  de  bombons  contendo  cacau,  em  embalagens  de  conteudo inferior ou igual a 1 kg
357|1700700|1|Bombons, inclusive a base de chocolate branco sem cacau
358|1700800|1|Bombons, balas, caramelos, confeitos, pastilhas e outros produtos de confeitaria, contendo cacau
359|1700900|1|Bebidas prontas a base de mate ou cha
360|1701000|1|Refrescos e outras bebidas nao alcoolicas, exceto os refrigerantes e as demais bebidas de que trata o Anexo IV
361|1701100|1|Bebidas prontas a base de cafe
362|1701200|1|Sucos de frutas ou de produtos horticolas; mistura de sucos
363|1701300|1|Agua de coco
364|1701400|1|Nectares de frutas e outras bebidas nao alcoolicas prontas para beber, exceto isotonicos e energeticos
365|1701500|1|Bebidas alimentares prontas a base de soja, leite ou cacau, inclusive os produtos denominados bebidas lacteas
366|1701600|1|Refrescos e outras bebidas prontas para beber a base de cha e mate
367|1701700|1|Leite em po, blocos ou granulos, exceto creme de leite
368|1701800|1|Farinha lactea
369|1701900|1|Leite modificado para alimentacao de criancas
370|1702000|1|Preparacoes  para  alimentacao  infantil  a  base  de  farinhas,  grumos, semolas ou amidos e outros
371|1702100|1|"Leite longa vida (UHT - Ultra High Temperature), em recipiente de conteudo inferior ou igual a 2 litros"
372|1702101|1|"Leite longa vida (UHT - Ultra High Temperature), em recipiente de conteudo superior a 2 litros"
373|1702200|1|Leite em recipiente de conteudo inferior ou igual a 1 litro
374|1702201|1|Leite em recipiente de conteudo superior a 1 litro
375|1702300|1|Leite do tipo pasteurizado em recipiente de conteudo inferior ou igual a 1 litro
376|1702301|1|Leite do tipo pasteurizado em recipiente de conteudo superior a 1 litro
377|1702400|1|Creme de leite, em recipiente de conteudo inferior ou igual a 1 kg
378|1702401|1|Creme de leite, em recipiente de conteudo superior a 1 kg
379|1702402|1|Outros cremes de leite, em recipiente de conteudo inferior ou igual a 1kg
380|1702500|1|Leite condensado, em recipiente de conteudo inferior ou igual a 1 kg
381|1702501|1|Leite condensado, em recipiente de conteudo superior a 1 kg
382|1702600|1|Iogurte e leite fermentado em recipiente de conteudo inferior ou igual a 2 litros
383|1702601|1|Iogurte e leite fermentado em recipiente de conteudo superior a 2 litros
384|1702700|1|Coalhada
385|1702800|1|Requeijao e similares, em recipiente de conteudo inferior ou igual a 1 kg, exceto as embalagens individuais de conteudo inferior ou igual a 10 g
386|1702801|1|Requeijao e similares, em recipiente de conteudo superior a 1 kg
387|1702900|1|Queijos
388|1703000|1|Manteiga, em embalagem de conteudo inferior ou igual a 1 kg, exceto as embalagens individuais de conteudo inferior ou igual a 10 g
389|1703001|1|Manteiga, em embalagem de conteudo superior a 1 kg
390|1703100|1|Margarina em recipiente de conteudo inferior ou igual a 500 g, exceto as embalagens individuais de conteudo inferior ou igual a 10 g
391|1703200|1|Margarina, em recipiente de conteudo superior a 500 g e inferior a 1 kg, creme vegetal em recipiente de conteudo inferior a 1 kg, exceto as embalagens individuais de conteudo inferior ou igual a 10 g
392|1703201|1|Margarina e creme vegetal, em recipiente de conteudo de 1 kg
393|1703202|1|Outras  margarinas  e  cremes  vegetais  em  recipiente  de  conteudo inferior a 1 kg, exceto as embalagens individuais de conteudo inferior ou igual a 10 g
394|1703300|1|Gorduras e oleos vegetais e respectivas fracoes, parcial ou totalmente hidrogenados, interesterificados, reesterificados ou elaidinizados, mesmo refinados, mas nao preparados de outro modo, em recipiente de conteudo inferior ou igual a 1 kg, exceto as embalagens individuais de conteudo inferior ou igual a 10 g
395|1703301|1|Gorduras e oleos vegetais e respectivas fracoes, parcial ou totalmente hidrogenados, interesterificados, reesterificados ou elaidinizados, mesmo refinados, mas nao preparados de outro modo, em recipiente de conteudo superior a 1 kg, exceto as embalagens individuais de conteudo inferior ou igual a 10 g
396|1703400|1|Doces de leite
397|1703500|1|Produtos a base de cereais, obtidos por expansao ou torrefacao
398|1703600|1|Salgadinhos diversos
399|1703700|1|Batata frita, inhame e mandioca fritos
400|1703800|1|Amendoim e castanhas tipo aperitivo, em embalagem de conteudo inferior ou igual a 1 kg
401|1703801|1|Amendoim e castanhas tipo aperitivo, em embalagem de conteudo superior a 1 kg
402|1703900|1|Catchup em embalagens imediatas de conteudo inferior ou igual a 650 g, exceto as embalagens contendo envelopes individualizados (saches) de conteudo inferior ou igual a 10 g
403|1704000|1|Condimentos e temperos compostos, incluindo molho de pimenta e outros molhos, em embalagens imediatas de conteudo inferior ou igual a 1 kg, exceto as embalagens contendo envelopes individualizados (saches) de conteudo inferior ou igual a 3 g
404|1704100|1|Molhos de soja  preparados em embalagens imediatas de  conteudo inferior ou igual a 650 g, exceto as embalagens contendo envelopes individualizados (saches) de conteudo inferior ou igual a 10 g
405|1704200|1|Farinha de mostarda em embalagens de conteudo inferior ou igual a 1 kg
406|1704300|1|Mostarda preparada em embalagens imediatas de conteudo inferior ou igual a 650 g, exceto as embalagens contendo envelopes individualizados (saches) de conteudo inferior ou igual a 10 g
407|1704400|1|Maionese em embalagens imediatas de conteudo inferior ou igual a 650 g, exceto as embalagens contendo envelopes individualizados (saches) de conteudo inferior ou igual a 10 g
408|1704500|1|Tomates preparados ou conservados, exceto em vinagre ou em acido acetico, em embalagens de conteudo inferior ou igual a 1 kg
409|1704600|1|Molhos de tomate em embalagens imediatas de conteudo inferior ou igual a 1 kg
410|1704700|1|Barra de cereais
411|1704800|1|Barra de cereais contendo cacau
412|1704900|1|Farinha de trigo, em embalagem inferior ou igual a 5 kg
413|1704901|1|Farinha de trigo, em embalagem superior a 5 kg
414|1705000|1|Mistura de farinha de trigo
415|1705100|1|Misturas e preparacoes para bolos
416|1705200|1|Massas alimenticias tipo instantanea
417|1705300|1|Massas alimenticias, cozidas ou recheadas (de carne ou de outras substancias) ou preparadas de outro modo, exceto as massas alimenticias tipo instantanea
418|1705301|1|Cuscuz
419|1705400|1|Massas alimenticias nao cozidas, nem recheadas, nem preparadas de outro modo:
420|1705500|1|Paes industrializados, inclusive de especiarias, exceto panetones e bolo de forma
421|1705600|1|Bolo de forma, inclusive de especiarias
422|1705700|1|Panetones
423|1705800|1|"Biscoitos e bolachas derivados de farinha de trigo; exceto dos tipos ""cream cracker"", ""agua e sal"", ""maisena"", ""maria"" e outros de consumo popular, nao adicionados de cacau, nem recheados, cobertos ou amanteigados, independentemente de sua denominacao comercial"
424|1705900|1|"Biscoitos e bolachas nao derivados de farinha de trigo; exceto dos tipos ""cream cracker"", ""agua e sal"", ""maisena"" e ""maria"" e outros de consumo popular, nao adicionados de cacau, nem recheados, cobertos ou amanteigados, independentemente de sua denominacao comercial"
425|1706000|1|"Biscoitos e bolachas dos tipos ""cream cracker"", ""agua e sal"", ""maisena"" e ""maria"" e outros de consumo popular, adicionados de edulcorantes e nao adicionados de cacau, nem recheados, cobertos ou amanteigados, independentemente de sua denominacao comercial"
426|1706100|1|"Biscoitos e bolachas dos tipos ""cream cracker"", ""agua e sal"", ""maisena"" e ""maria"" e outros de consumo popular, nao adicionados de cacau, nem recheados, cobertos ou amanteigados, independentemente de sua denominacao comercial"
427|1706200|1|Waffles e wafers - sem cobertura
428|1706300|1|Waffles e wafers- com cobertura
429|1706400|1|Torradas, pao torrado e produtos semelhantes torrados
430|1706500|1|Outros paes de forma
431|1706600|1|Outras bolachas, exceto casquinhas para sorvete
432|1706700|1|Outros paes e bolos industrializados e produtos de panificacao nao especificados anteriormente; exceto casquinhas para sorvete e pao frances de ate 200 g
433|1706800|1|Pao denominado knackebrot
434|1706900|1|Pao frances de ate 200 g
435|1707000|1|Demais paes industrializados
436|1707100|1|Oleo de soja refinado, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conteudo inferior ou igual a 15 mililitros
437|1707200|1|Oleo de amendoim refinado, em recipientes com capacidade inferior ou igual a 5  litros, exceto as embalagens individuais de conteudo inferior ou igual a 15 mililitros
438|1707300|1|Azeites de oliva, em recipientes com capacidade inferior ou igual a 2 litros, exceto as embalagens individuais de conteudo inferior ou igual a 15 mililitros
439|1707301|1|Azeites de oliva, em recipientes com capacidade superior a 2 litros e inferior ou igual a 5 litros
440|1707302|1|Azeites de oliva, em recipientes com capacidade superior a 5 litros
441|1707400|1|Outros oleos e respectivas fracoes, obtidos exclusivamente a partir de azeitonas, mesmo refinados, mas nao quimicamente modificados, e misturas desses oleos ou fracoes com oleos ou fracoes da posicao 1509, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conteudo inferior ou igual a 15 mililitros
442|1707500|1|Oleo de girassol ou de algodao refinado, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conteudo inferior ou igual a 15 mililitros
443|1707600|1|Oleo de canola, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conteudo inferior ou igual a 15 mililitros
444|1707700|1|Oleo de linhaca refinado, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conteudo inferior ou igual a 15 mililitros
445|1707800|1|Oleo de milho refinado, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conteudo inferior ou igual a 15 mililitros
446|1707900|1|Outros oleos refinados, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conteudo inferior ou igual a 15 mililitros
447|1708000|1|Misturas de oleos refinados, para consumo humano, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conteudo inferior ou igual a 15 mililitros
448|1708100|1|Outros oleos vegetais comestiveis nao especificados anteriormente
449|1708200|1|Enchidos (embutidos) e produtos semelhantes, de carne, miudezas ou sangue; exceto salsicha, linguica e mortadela
450|1708300|1|Salsicha e linguica
451|1708400|1|Mortadela
452|1708500|1|Outras preparacoes e conservas de carne, miudezas ou de sangue
453|1708600|1|Preparacoes   e   conservas   de   peixes;   caviar   e   seus   sucedaneos preparados a partir de ovas de peixe; exceto sardinha em conserva
454|1708700|1|Sardinha em conserva
455|1708800|1|Crustaceos, moluscos e outros invertebrados aquaticos, preparados ou em conservas
456|1708900|1|Carne de gado bovino, ovino e bufalino e produtos comestiveis resultantes da matanca  desse gado submetidos a salga, secagem ou desidratacao
457|1709000|1|Carnes  de  animais  das  especies  caprina,  frescas,  refrigeradas  ou congeladas
458|1709100|1|Carnes e demais produtos comestiveis frescos, resfriados, congelados, salgados, em  salmoura, simplesmente temperados, secos  ou defumados, resultantes do abate de aves e de suinos
459|1709200|1|Produtos  horticolas,  cozidos  em  agua  ou  vapor,  congelados,  em embalagens de conteudo inferior ou igual a 1 kg
460|1709201|1|Produtos  horticolas,  cozidos  em  agua  ou  vapor,  congelados,  em embalagens de conteudo superior a 1 kg
461|1709300|1|Frutas, nao cozidas ou cozidas em agua ou vapor, congeladas, mesmo adicionadas de acucar ou de outros edulcorantes, em embalagens de conteudo inferior ou igual a 1 kg
462|1709301|1|Frutas, nao cozidas ou cozidas em agua ou vapor, congeladas, mesmo adicionadas de acucar ou de outros edulcorantes, em embalagens de conteudo superior a 1 kg
463|1709400|1|Produtos horticolas, frutas e outras partes comestiveis de plantas, preparados ou conservados em vinagre ou em acido acetico, em embalagens de conteudo inferior ou igual a 1 kg
464|1709401|1|Produtos horticolas, frutas e outras partes comestiveis de plantas, preparados ou conservados em vinagre ou em acido acetico, em embalagens de conteudo superior a 1 kg
465|1709500|1|Outros produtos horticolas preparados ou conservados, exceto em vinagre ou em acido acetico, congelados, com excecao dos produtos da posicao 2006, em embalagens de conteudo inferior ou igual a 1 kg
466|1709501|1|Outros produtos horticolas preparados ou conservados, exceto em vinagre ou em acido acetico, congelados, com excecao dos produtos da posicao 2006, em embalagens de conteudo superior a 1 kg
467|1709600|1|Outros produtos horticolas preparados ou conservados, exceto em vinagre ou em acido acetico, nao congelados, com excecao dos produtos da posicao 2006, excluidos batata, inhame e mandioca fritos, em embalagens de conteudo inferior ou igual a 1 kg
468|1709601|1|Outros produtos horticolas preparados ou conservados, exceto em vinagre ou em acido acetico, nao congelados, com excecao dos produtos da posicao 2006, excluidos batata, inhame e mandioca fritos, em embalagens de conteudo superior a 1 kg
469|1709700|1|Produtos horticolas, frutas, cascas de frutas e outras partes de plantas, conservados com acucar (passados por calda, glaceados ou cristalizados), em embalagens de conteudo inferior ou igual a 1 kg
470|1709701|1|Produtos horticolas, frutas, cascas de frutas e outras partes de plantas, conservados com acucar (passados por calda, glaceados ou cristalizados), em embalagens de conteudo superior a 1 kg
471|1709800|1|Doces, geleias, marmelades, pures e pastas de frutas, obtidos por cozimento, com ou sem adicao de acucar ou de outros edulcorantes, em embalagens de conteudo inferior ou igual a 1 kg, exceto as embalagens individuais de conteudo inferior ou igual a 10 g
472|1709801|1|Doces, geleias, marmelades, pures e pastas de frutas, obtidos por cozimento, com ou sem adicao de acucar ou de outros edulcorantes, em embalagens de conteudo superior a 1 kg
473|1709900|1|Frutas   e   outras   partes   comestiveis   de   plantas,   preparadas   ou conservadas de outro modo, com ou sem adicao de acucar ou de outros edulcorantes ou de alcool, nao especificadas nem compreendidas em outras posicoes, excluidos os amendoins e castanhas tipo aperitivo, da posicao 20081, em embalagens de conteudo inferior ou igual a 1 kg
474|1709901|1|Frutas e outras partes comestiveis de plantas, preparadas ou conservadas de outro modo, com ou sem adicao de acucar ou de outros edulcorantes ou de alcool, nao especificadas nem compreendidas em outras posicoes, excluidos os amendoins e castanhas tipo aperitivo, da posicao 20081, em embalagens superior a 1 kg
475|1710000|1|Cafe torrado e moido, em embalagens de conteudo inferior ou igual a 2 kg
476|1710001|1|Cafe torrado e moido, em embalagens de conteudo superior a 2 kg
477|1710100|1|Cha, mesmo aromatizado
478|1710200|1|Mate
479|1710300|1|Acucar refinado, em embalagens de conteudo inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (saches) de conteudo inferior ou igual a 10 g
480|1710301|1|Acucar refinado, em embalagens de conteudo superior a 2 kg e inferior ou igual a 5 kg
481|1710302|1|Acucar refinado, em embalagens de conteudo superior a 5 kg
482|1710400|1|Acucar refinado adicionado de aromatizante ou de corante em embalagens de conteudo inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (saches) de conteudo inferior ou igual a 10 g
483|1710401|1|Acucar  refinado  adicionado  de  aromatizante  ou  de  corante  em embalagens de conteudo superior a 2 kg e inferior ou igual a 5 kg
484|1710402|1|Acucar  refinado  adicionado  de  aromatizante  ou  de  corante  em embalagens de conteudo superior a 5 kg
485|1710500|1|Acucar cristal, em embalagens de conteudo inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (saches) de conteudo inferior ou igual a 10 g
486|1710501|1|Acucar cristal, em embalagens de conteudo superior a 2 kg e inferior ou igual a 5 kg
487|1710502|1|Acucar cristal, em embalagens de conteudo superior a 5 kg
488|1710600|1|Acucar cristal adicionado de aromatizante ou de corante, em embalagens de conteudo inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (saches) de conteudo inferior ou igual a 10 g
489|1710601|1|Acucar   cristal   adicionado   de   aromatizante   ou   de   corante,   em embalagens de conteudo superior a 2 kg e inferior ou igual a 5 kg
490|1710602|1|Acucar   cristal   adicionado   de   aromatizante   ou   de   corante,   em embalagens de conteudo superior a 5 kg
491|1710700|1|"Outros tipos de acucar, em embalagens de conteudo inferior ou igual a 2  kg,  exceto  as  embalagens  contendo  envelopes  individualizados (saches) de conteudo inferior ou igual a 10 g"
492|1710701|1|Outros tipos de acucar, em embalagens de conteudo superior a 2 kg e inferior ou igual a 5 kg
493|1710702|1|Outros tipos de acucar, em embalagens de conteudo superior a 5 kg
494|1710800|1|Outros tipos de acucar adicionado de aromatizante ou de corante, em embalagens de conteudo inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (saches) de conteudo inferior ou igual a 10 g
495|1710801|1|Outros tipos de acucar adicionado de aromatizante ou de corante, em embalagens de conteudo superior a 2 kg e inferior ou igual a 5 kg
496|1710802|1|Outros tipos de acucar adicionado de aromatizante ou de corante, em embalagens de conteudo superior a 5 kg
497|1710900|1|Outros acucares em embalagens de conteudo inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (saches) de conteudo inferior ou igual a 10 g
498|1710901|1|Outros acucares, em embalagens de conteudo superior a 2 kg e inferior ou igual a 5 kg
499|1710902|1|Outros acucares, em embalagens de conteudo superior a 5 kg
500|1711000|1|Milho para pipoca (micro-ondas)
501|1711100|1|Extratos, essencias e concentrados de cafe e preparacoes a base destes extratos, essencias ou concentrados ou a base de cafe, em embalagens de conteudo inferior ou igual a 500 g, exceto as preparacoes indicadas no item 1120
502|1711200|1|Extratos, essencias e concentrados de cha ou de mate e preparacoes a base destes extratos, essencias ou concentrados ou a base de cha ou de mate, em embalagens de conteudo inferior ou igual a 500 g, exceto as bebidas prontas a base de mate ou cha
503|1711300|1|Preparacoes em po para cappuccino e similares, em embalagens de conteudo inferior ou igual a 500 g
504|1800100|1|Artigos para servico de mesa ou de cozinha, de porcelana, inclusive os descartaveis  estojos
505|1800200|1|Artigos para servico de mesa ou de cozinha, de porcelana, inclusive os descartaveis  avulsos
506|1800300|1|Artigos para servico de mesa ou de cozinha, de ceramica
507|1800400|1|Velas para filtros
508|1900100|1|Tinta guache
509|1900200|1|Espiral  -  perfil  para  encadernacao,  de  plastico  e  outros  materiais classificados nas posicoes 3901 a 3914
510|1900300|1|Artigos de escritorio e artigos escolares de plastico e outros materiais classificados nas posicoes 3901 a 3914, exceto estojos
511|1900400|1|Maletas   e   pastas   para   documentos   e   de   estudante,   e   artefatos semelhantes
512|1900500|1|Prancheta de plastico
513|1900600|1|Bobina para fax
514|1900700|1|Papel seda
515|1900800|1|Bobina branca para maquina de calcular ou PDV
516|1900900|1|Cartolina escolar e papel cartao, brancos e coloridos; recados auto adesivos (LP note); papeis de presente, todos cortados em tamanho pronto para uso escolar e domestico
517|1901000|1|"Papel fotografico, exceto: (i) os papeis fotograficos emulsionados com haleto de prata tipo brilhante, matte ou lustre, em rolo e, com largura igual ou superior a 102 mm e comprimento inferior ou igual a 350 m, (ii) os papeis fotograficos emulsionados com haleto de prata tipo brilhante ou fosco, em folha e com largura igual ou superior a 152 mm e comprimento inferior ou igual a 307 mm, (iii) papel de qualidade fotografica com tecnologia Thermo-autochrome, que submetido a um processo de aquecimento seja capaz de formar imagens por reacao quimica e combinacao das camadas cyan, magenta e amarela"
518|1901100|1|Papel almaco
519|1901200|1|Papel hectografico
520|1901300|1|Papel celofane e tipo celofane
521|1901400|1|Papel impermeavel
522|1901500|1|Papel crepon
523|1901600|1|Papel fantasia
524|1901700|1|Papel-carbono, papel autocopiativo (exceto os vendidos em rolos de diametro igual ou superior a 60 cm e os vendidos em folhas de formato igual ou superior a 60 cm de altura e igual ou superior a 90 cm de largura) e outros papeis para copia ou duplicacao (incluidos os papeis para estenceis ou para chapas ofsete), estenceis completos e chapas ofsete, de papel, em folhas, mesmo acondicionados em caixas
525|1901800|1|Envelopes, aerogramas, bilhetes-postais nao ilustrados e cartoes para correspondencia, de papel ou cartao, caixas, sacos e semelhantes, de papel ou cartao, contendo um sortido de artigos para correspondencia
526|1901900|1|Livros de registro e de contabilidade, blocos de notas,de encomendas, de recibos, de apontamentos, de papel para cartas, agendas e artigos semelhantes
527|1902000|1|Cadernos
528|1902100|1|Classificadores, capas para encadernacao (exceto as capas para livros) e capas de processos
529|1902200|1|"Formularios em blocos tipo ""manifold"", mesmo com folhas intercaladas de papel-carbono"
530|1902300|1|Albuns para amostras ou para colecoes
531|1902400|1|Pastas para documentos, outros artigos escolares, de escritorio ou de papelaria, de papel ou cartao e capas para livros, de papel ou cartao
532|1902500|1|"Cartoes postais impressos ou ilustrados, cartoes impressos com votos ou mensagens pessoais, mesmo ilustrados,  com ou sem envelopes, guarnicoes ou aplicacoes (conhecidos como cartoes de expressao social - de epoca/sentimento)"
533|1902600|1|Canetas esferograficas
534|1902700|1|Canetas  e  marcadores,  com  ponta  de  feltro  ou  com  outras  pontas porosas
535|1902800|1|Canetas tinteiro
536|1902900|1|Outras canetas; sortidos de canetas
537|1903000|1|"Papel cortado ""cutsize"" (tipo A3, A4, oficio I e II, carta e outros)"
538|2000100|1|Henna (embalagens de conteudo inferior ou igual a 200 g)
539|2000101|1|Henna (embalagens de conteudo superior a 200 g)
540|2000200|1|Vaselina
541|2000300|1|Amoniaco em solucao aquosa (amonia)
542|2000400|1|Peroxido de hidrogenio, em embalagens de conteudo inferior ou igual a 500 ml
543|2000500|1|Lubrificacao intima
544|2000600|1|"Oleos essenciais (desterpenados ou nao), incluidos os chamados ""concretos"" ou ""absolutos""; resinoides; oleorresinas de extracao; solucoes concentradas de oleos essenciais em gorduras, em oleos fixos, em ceras ou em materias analogas, obtidas portratamento de flores atraves de substancias gordas ou por maceracao; subprodutos terpenicos residuais da desterpenacao dos oleos essenciais; aguas destiladas aromaticas e solucoes aquosas de oleos essenciais, em embalagens de conteudo inferior ou igual a 500 ml"
545|2000700|1|Perfumes (extratos)
546|2000800|1|Aguas-de-colonia
547|2000900|1|Produtos de maquilagem para os labios
548|2001000|1|Sombra, delineador, lapis para sobrancelhas e rimel
549|2001100|1|Outros produtos de maquilagem para os olhos
550|2001200|1|Preparacoes para manicuros e pedicuros, incluindo removedores de esmalte a base de acetona
551|2001300|1|Pos, incluidos os compactos, para maquilagem
552|2001400|1|Cremes de beleza, cremes nutritivos e locoes tonicas
553|2001500|1|Outros produtos de beleza ou de maquilagem preparados e preparacoes para conservacao ou cuidados da pele, exceto as preparacoes solares e antisolares
554|2001600|1|Preparacoes solares e antisolares
555|2001700|1|Xampus para o cabelo
556|2001800|1|Preparacoes para ondulacao ou alisamento, permanentes, dos cabelos
557|2001900|1|Laques para o cabelo
558|2002000|1|Outras preparacoes capilares, incluindo mascaras e finalizadores
559|2002100|1|Condicionadores
560|2002200|1|Tintura para o cabelo
561|2002300|1|Dentifricios
562|2002400|1|Fios utilizados para limpar os espacos interdentais (fios dentais)
563|2002500|1|Outras preparacoes para higiene bucal ou dentaria
564|2002600|1|Preparacoes para barbear (antes, durante ou apos)
565|2002700|1|Desodorantes (desodorizantes) corporais liquidos
566|2002800|1|Antiperspirantes liquidos
567|2002900|1|Outros desodorantes (desodorizantes) corporais
568|2003000|1|Outros antiperspirantes
569|2003100|1|Sais perfumados e outras preparacoes para banhos
570|2003200|1|Outros produtos de perfumaria ou de toucador preparados
571|2003300|1|Solucoes para lentes de contato ou para olhos artificiais
572|2003400|1|Saboes de toucador em barras, pedacos ou figuras moldados
573|2003500|1|Outros saboes, produtos e preparacoes, em barras, pedacos ou figuras moldados, inclusive lencos umedecidos
574|2003600|1|Saboes de toucador sob outras formas
575|2003700|1|Produtos e preparacoes organicos tensoativos para lavagem da pele, na forma de liquido ou de creme, acondicionados para venda a retalho, mesmo contendo sabao
576|2003800|1|Bolsa para gelo ou para agua quente
577|2003900|1|Chupetas e bicos para mamadeiras e para chupetas, de borracha
578|2003901|1|Chupetas e bicos para mamadeiras e para chupetas, de silicone
579|2004000|1|Malas e maletas de toucador
580|2004100|1|Papel higienico - folha simples
581|2004200|1|Papel higienico - folha dupla e tripla
582|2004300|1|Lencos (incluidos os de maquilagem) e toalhas de mao
583|2004400|1|Papel toalha de uso institucional do tipo comercializado em rolos igual ou superior a 80 metros e do tipo comercializado em folhas intercaladas
584|2004500|1|Toalhas e guardanapos de mesa
585|2004600|1|Toalhas de cozinha (papel toalha de uso domestico)
586|2004700|1|Fraldas
587|2004800|1|Tampoes higienicos
588|2004900|1|Absorventes higienicos externos
589|2005000|1|Hastes flexiveis (uso nao medicinal)
590|2005100|1|Sutia descartavel, assemelhados e papel para depilacao
591|2005200|1|Pincas para sobrancelhas
592|2005300|1|Espatulas (artigos de cutelaria)
593|2005400|1|Utensilios  e  sortidos  de  utensilios  de  manicuros  ou  de  pedicuros (incluidas as limas para unhas)
594|2005500|1|Termometros, inclusive o digital
595|2005600|1|Escovas e pinceis de barba, escovas para cabelos, para cilios ou para unhas e outras escovas de toucador de pessoas, incluidas as que sejam partes de aparelhos, exceto escovas de dentes
596|2005700|1|Escovas de dentes, incluidas as escovas para dentaduras
597|2005800|1|Pinceis para aplicacao de produtos cosmeticos
598|2005900|1|Sortidos de viagem, para toucador de pessoas para costura ou para limpeza de calcado ou de roupas
599|2006000|1|Pentes, travessas para cabelo e artigos semelhantes; grampos (alfinetes) para cabelo; pincas (pinceguiches), onduladores, bobes (rolos) e artefatos semelhantes para penteados, e suas partes, exceto os classificados na posicao 8516 e suas partes
600|2006100|1|Borlas ou esponjas para pos ou para aplicacao de outros cosmeticos ou de produtos de toucador
601|2006200|1|Mamadeiras
602|2006300|1|Aparelhos e laminas de barbear
603|2100100|1|Fogoes de cozinha de uso domestico e suas partes
604|2100200|1|"Combinacoes de refrigeradores e congeladores (""freezers""), munidos de portas exteriores separadas"
605|2100300|1|Refrigeradores do tipo domestico, de compressao
606|2100400|1|Outros refrigeradores do tipo domestico
607|2100500|1|"Congeladores (""freezers"") horizontais tipo arca, de capacidade nao superior a 800 litros"
608|2100600|1|"Congeladores (""freezers"") verticais tipo armario, de capacidade nao superior a 900 litros"
609|2100700|1|Outros moveis (arcas, armarios, vitrines, balcoes e moveis semelhantes) para a conservacao e exposicao de produtos, que incorporem um equipamento para a producao de frio
610|2100800|1|Mini adega e similares
611|2100900|1|Maquinas para producao de gelo
612|2101000|1|Partes dos refrigeradores, congeladores, mini adegas e similares, maquinas para producao de gelo e bebedouros descritos nos itens 20, 30, 40, 50, 60, 70, 80, 90 e 130
613|2101100|1|Secadoras de roupa de uso domestico
614|2101200|1|Outras secadoras de roupas e centrifugas de uso domestico
615|2101300|1|Bebedouros refrigerados para agua
616|2101400|1|Partes das secadoras de roupas e centrifugas de uso domestico e dos aparelhos para filtrar ou depurar agua, descritos nos itens 110 e 120
617|2101500|1|Maquinas de lavar louca do tipo domestico e suas partes
618|2101600|1|Maquinas que executem pelo menos duas das seguintes funcoes: impressao, copia ou transmissao de telecopia (fax), capazes de ser conectadas a uma maquina
619|2101700|1|Outras impressoras, maquinas copiadoras e telecopiadores (fax), mesmo combinados entre si, capazes de ser conectados a uma maquina automatica para processamento de dados ou a uma rede
620|2101800|1|Partes e acessorios de maquinas e aparelhos de impressao por meio de blocos, cilindros e outros elementos de impressao da posicao 8442; e de outras impressoras, maquinas copiadoras e telecopiadores (fax), mesmo combinados entre si
621|2101900|1|Maquinas de lavar roupa, mesmo com dispositivos de secagem, de uso domestico, de capacidade nao superior a 10 kg, em peso de roupa seca, inteiramente automaticas
622|2102000|1|Outras maquinas de lavar roupa, mesmo com dispositivos de secagem, de uso domestico, com secador centrifugo incorporado
623|2102100|1|Outras maquinas de lavar roupa, mesmo com dispositivos de secagem, de uso domestico
624|2102200|1|Maquinas de lavar roupa, mesmo com dispositivos de secagem, de uso domestico, de capacidade superior a 10 kg, em peso de roupa seca
625|2102300|1|Partes  de  maquinas  de  lavar  roupa,  mesmo  com  dispositivos  de secagem, de uso domestico
626|2102400|1|Maquinas de secar de uso domestico de capacidade nao superior a 10 kg, em peso de roupa seca
627|2102500|1|Outras maquinas de secar de uso domestico
628|2102600|1|Partes de maquinas de secar de uso domestico
629|2102700|1|Maquinas de costura de uso domestico
630|2102800|1|Maquinas automaticas para processamento de dados, portateis, de peso nao superior a 10 kg, contendo pelo menos uma unidade central de processamento, um teclado e uma tela
631|2102900|1|Outras maquinas automaticas para processamento de dados
632|2103000|1|"Unidades de processamento, de pequena capacidade, exceto as das subposicoes 847141 ou 847149, podendo conter, no mesmo corpo, um ou dois dos seguintes tipos de unidades: unidade de memoria, unidade de entrada e unidade de saida;baseadas em microprocessadores, com capacidade de instalacao, dentro do mesmo gabinete, de unidades de memoria da subposicao 847170, podendo conter multiplos conectores de expansao (""slots""), e valor FOB inferior ou igual a US$ 12500,00, por unidade"
633|2103100|1|Unidades de entrada, exceto as classificadas na posicao 84716054
634|2103200|1|Outras unidades de entrada ou de saida, podendo conter, no mesmo corpo, unidades de memoria
635|2103300|1|Unidades de memoria
636|2103400|1|Outras maquinas automaticas para processamento de  dados e  suas unidades; leitores magneticos ou opticos, maquinas para registrar dados em suporte sob forma codificada, e maquinas para processamento desses dados, nao especificadas nem compreendidas em outras posicoes
637|2103500|1|Partes e acessorios das maquinas da posicao 8471
638|2103600|1|Outros   transformadores,   exceto   os   classificados   nas   posicoes 85043300 e 85043400
639|2103700|1|Carregadores de acumuladores
640|2103800|1|"Equipamentos de alimentacao ininterrupta de energia (UPS ou ""no break"")"
641|2103900|1|Outros acumuladores
642|2104000|1|Aspiradores
643|2104100|1|Aparelhos  eletromecanicos  de  motor  eletrico  incorporado,  de  uso domestico e suas partes
644|2104200|1|Enceradeiras
645|2104300|1|Chaleiras eletricas
646|2104400|1|Ferros eletricos de passar
647|2104500|1|Fornos de microondas
648|2104600|1|Outros fornos; fogareiros (incluidas as chapas de coccao), grelhas e assadeiras, exceto os portateis
649|2104700|1|Outros fornos; fogareiros (incluidas as chapas de coccao), grelhas e assadeiras, portateis
650|2104800|1|Outros aparelhos eletrotermicos de uso domestico  Cafeteiras
651|2104900|1|Outros aparelhos eletrotermicos de uso domestico - Torradeiras
652|2105000|1|Outros aparelhos eletrotermicos de uso domestico
653|2105100|1|"Partes das chaleiras, ferros, fornos e outros aparelhos eletrotermicos da posicao 8516, descritos nos itens 430, 440, 450, 460, 470, 480, 490 e 500"
654|2105200|1|Aparelhos telefonicos por fio com unidade auscultador- microfone sem fio
655|2105300|1|Telefones para redes celulares e para outras redes sem fio, exceto os de uso automotivo
656|2105400|1|Outros aparelhos telefonicos
657|2105500|1|Aparelhos para transmissao ou recepcao de voz, imagem ou outros dados em rede com fio, exceto  os classificados nas posicoes 85176251, 85176252 e 85176253
658|2105600|1|Microfones e seus suportes; altofalantes, mesmo montados nos seus receptaculos, fones de ouvido (auscultadores), mesmo  combinados com microfone e conj untos ou sortidos constituidos por um microfone e um ou mais alto-falantes, amplificadores eletricos de audiofrequencia, aparelhos eletricos de amplificacao de som; suas partes e acessorios; exceto os de uso automotivo
659|2105700|1|Aparelhos de radiodifusao suscetiveis de funcionarem sem fonte externa de energia Aparelhos de gravacao de som; aparelhos de reproducao de som; aparelhos de gravacao e de reproducao de som; partes e acessorios; exceto os de uso automotivo
660|2105800|1|Outros aparelhos de gravacao de som; aparelhos de reproducao de som; aparelhos de gravacao e de reproducao de som; partes e acessorios; exceto os de uso automotivo
661|2105900|1|Gravador-reprodutor e editor de imagem e som, em discos, por meio magnetico, optico ou optomagnetico, exceto de uso automotivo
662|2106000|1|Outros aparelhos videofonicos de gravacao  ou reproducao, mesmo incorporando um receptor de sinais videofonicos, exceto os de uso automotivo
663|2106100|1|"Cartoes de memoria (""memory cards"")"
664|2106200|1|"Cartoes inteligentes (""smart cards"")"
665|2106300|1|Cameras fotograficas digitais e cameras de video e suas partes
666|2106400|1|Outros aparelhos receptores  para radiodifusao, mesmo combinados num involucro, com um aparelho de gravacao ou de reproducao de som, ou com um relogio, inclusive caixa acustica para Home Theaters classificados na posicao 8518
667|2106500|1|Monitores e projetores que nao incorporem aparelhos receptores de televisao, policromaticos
668|2106600|1|Outros monitores dos tipos utilizados exclusiva ou principalmente com uma maquina automatica para processamento de dados da posicao 8471, policromaticos
669|2106700|1|Aparelhos receptores de televisao, mesmo  que  incorporem um aparelho receptor de radiodifusao ou um aparelho de  gravacao ou reproducao de som ou de imagens - Televisores de CRT (tubo de raios catodicos)
670|2106800|1|Aparelhos receptores de televisao, mesmo  que  incorporem um aparelho receptor de radiodifusao ou um aparelho de gravacao ou reproducao de som ou de imagens - Televisores de LCD (Display de Cristal Liquido)
671|2106900|1|Aparelhos receptores de televisao, mesmo  que  incorporem um aparelho receptor de radiodifusao ou um aparelho de  gravacao ou reproducao de som ou de imagens - Televisores de Plasma
672|2107000|1|Outros aparelhos receptores de televisao nao dotados de monitores ou display de video
673|2107100|1|Outros aparelhos receptores de televisao nao relacionados em outros itens deste anexo
674|2107200|1|Cameras fotograficas dos tipos utilizadas para preparacao de cliches ou cilindros de impressao
675|2107300|1|Cameras fotograficas para filmes de revelacao e copiagem instantaneas
676|2107400|1|Aparelhos de diatermia
677|2107500|1|Aparelhos de massagem
678|2107600|1|Reguladores de voltagem eletronicos
679|2107700|1|Consoles e maquinas de jogos de video, exceto os classificados na subposicao 950430
680|2107800|1|Multiplexadores e concentradores
681|2107900|1|Centrais automaticas privadas, de capacidade inferior ou igual a 25 ramais
682|2108000|1|Outros aparelhos para comutacao
683|2108100|1|Roteadores digitais, em redes com ou sem fio
684|2108200|1|"Aparelhos emissores com receptor incorporado de sistema troncalizado (""trunking""), de tecnologia celular"
685|2108300|1|Outros aparelhos de recepcao, conversao e transmissao ou regeneracao de voz, imagens ou outros dados, incluindo os aparelhos de comutacao e roteamento
686|2108400|1|Antenas   proprias   para   telefones   celulares   portateis,   exceto   as telescopicas
687|2108500|1|Aparelhos ou maquinas de barbear, maquinas de cortar o cabelo ou de tosquiar e aparelhos de depilar, e suas partes
688|2108600|1|Ventiladores, exceto os de uso agricola
689|2108700|1|Ventiladores de uso agricola
690|2108800|1|Coifas com dimensao horizontal maxima nao superior a 120 cm
691|2108900|1|Partes de ventiladores ou coifas aspirantes
692|2109000|1|Maquinas e aparelhos de ar condicionado contendo um ventilador motorizado e dispositivos proprios para modificar a temperatura e a umidade, incluidos as maquinas e aparelhos em que a umidade nao seja regulavel separadamente e suas partes e pecas
693|2109100|1|Aparelhos   de   ar-condicionado   tipo   Split   System   (sistema   com elementos separados) com unidade externa e interna
694|2109200|1|"Aparelhos  de  ar-condicionado  com  capacidade  inferior  ou  igual  a 30000 frigorias/hora"
695|2109300|1|Aparelhos  de  ar-condicionado  com  capacidade  acima  de  30000 frigorias/hora
696|2109400|1|Unidades evaporadoras (internas) de aparelho de ar-condicionado do tipo Split System (sistema com elementos separados), com capacidade inferior ou igual a 30000 frigorias/hora
697|2109500|1|Unidades condensadoras (externas) de aparelho de ar-condicionado do tipo Split System (sistema com elementos separados), com capacidade inferior ou igual a 30000 frigorias/hora
698|2109600|1|Aparelhos eletricos para filtrar ou depurar agua (purificadores de agua refrigerados)
699|2109700|1|Lavadora de alta pressao e suas partes
700|2109800|1|Furadeiras eletricas
701|2109900|1|Aparelhos eletricos para aquecimento de ambientes
702|2110000|1|Secadores de cabelo
703|2110100|1|Outros aparelhos para arranjos do cabelo
704|2110200|1|Microfones e seus suportes; alto-falantes, mesmo montados nos seus receptaculos, fones de ouvido (auscultadores), mesmo  combinados com microfone e conjuntos ou sortidos constituidos por um microfone e um ou mais alto-falantes, amplificadores eletricos de audiofrequencia, aparelhos eletricos de amplificacao de som; suas partes e acessorios; exceto os de uso automotivo
705|2110300|1|Aparelhos receptores para radiodifusao, mesmo combinados num mesmo involucro, com um aparelho de gravacao ou de reproducao de som, ou com um relogio, exceto os classificados na posicao 85272 que sejam de uso automotivo
706|2110400|1|Outros aparelhos videofonicos de gravacao ou de reproducao, mesmo incorporando um receptor de sinais videofonicos
707|2110500|1|Climatizadores de ar
708|2110600|1|Outras partes para maquinas e aparelhos de arcondicionado que contenham um ventilador motorizado e dispositivos proprios para modificar a temperatura e a umidade, incluindo as maquinas e aparelhos em que a umidade nao seja regulavel separadamente
709|2110700|1|Cameras de televisao e suas partes
710|2110800|1|Balancas de uso domestico
711|2110900|1|Tubos e valvulas, eletronicos, de catodo quente, catodo frio ou fotocatodo (por exemplo, tubos e valvulas, de vacuo, de vapor ou de gas, ampolas retificadoras de vapor de mercurio, tubos catodicos, tubos e valvulas para cameras de televisao)
712|2111000|1|Aparelhos eletricos para telefonia; outros aparelhos para transmissao ou recepcao de voz, imagens ou outros dados, incluidos os aparelhos para comunicacao em redes por fio ou redes sem fio (tal como uma rede local (LAN) ou uma rede de area estendida (WAN)), incluidas suas partes, exceto os de uso automotivo e os classificados nas posicoes 85176251, 85176252 e 85176253
713|2111100|1|"Interfones, seus acessorios, tomadas e ""plugs"""
714|2111200|1|Partes reconheciveis como exclusiva ou principalmente destinadas aos aparelhos das posicoes 8525 a 8528; exceto as de uso automotivo
715|2111300|1|Aparelhos eletricos de sinalizacao acustica ou visual (por exemplo, campainhas, sirenes, quadros indicadores, aparelhos de alarme para protecao contra roubo ou incendio); exceto os de uso automotivo e os classificados nas posicoes 853110 e 85318000
716|2111400|1|Aparelhos eletricos de alarme, para protecao contra roubo ou incendio e aparelhos semelhantes, exceto os de uso automotivo
717|2111500|1|Outros aparelhos de sinalizacao acustica ou visual, exceto os de uso automotivo
718|2111600|1|Circuitos impressos, exceto os de uso automotivo
719|2111700|1|"Diodos emissores de luz (LED), exceto diodos ""laser"""
720|2111800|1|Eletrificadores de cercas eletronicos
721|2111900|1|Aparelhos e instrumentos para medida ou controle da tensao, intensidade, resistencia ou da potencia, sem dispositivo registrador; exceto os de uso automotivo
722|2112000|1|Analisadores logicos de circuitos digitais, de espectro de frequencia, frequencimetros, fasimetros, e outros instrumentos e aparelhos de controle de grandezas eletricas e deteccao
723|2112100|1|Interruptores horarios e outros aparelhos que permitam acionar um mecanismo em tempo determinado, munidos de maquinismo de aparelhos de relojoaria ou de motor sincrono
724|2112200|1|Aparelhos de iluminacao (incluidos os projetores) e suas partes, nao especificados nem compreendidos em outras posicoes; anuncios, cartazes ou tabuletas e placas indicadoras luminosos, e artigos semelhantes, contendo uma fonte luminosa fixa permanente, e suas partes nao especificadas nem compreendidas em outras posicoes
725|2200100|1|Racao tipo pet para animais domesticos
726|2300100|1|Sorvetes de qualquer especie
727|2300200|1|Preparados para fabricacao de sorvete em maquina
728|2400100|1|Tintas, vernizes
729|2400200|1|Xadrez e pos assemelhados, exceto pigmentos a base de dioxido de titanio classificados na posicao 32061119
730|2500100|1|Veiculos automoveis para transporte de 10 pessoas ou mais, incluindo o motorista, com motor de pistao, de ignicao por compressao (diesel ou semidiesel), com volume interno de habitaculo, destinado a passageiros e motorista, superior a 6 m3, mas inferior a 9 m3
731|2500200|1|Outros veiculos automoveis para transporte de 10 pessoas ou mais, incluindo o motorista, com volume interno de habitaculo, destinado a passageiros e motorista, superior a 6 m3, mas inferior a 9 m
732|2500300|1|Automoveis com motor explosao, de cilindrada nao superior a 1000 cm3
733|2500400|1|Automoveis com motor explosao, de cilindrada superior a 1000 cm3, mas nao superior a 1500 cm3, com capacidade de transporte de pessoas sentadas inferior ou igual a 6, incluido o condutor, exceto carro celular
734|2500500|1|Outros automoveis com motor explosao, de cilindrada superior a 1000 cm3, mas nao superior a 1500 cm3, exceto carro celular
735|2500600|1|Automoveis com motor explosao, de cilindrada superior a 1500 cm3, mas nao superior a 3000 cm3, com capacidade de transporte de pessoas sentadas inferior ou igual a 6, incluido o condutor, exceto carro celular, carro funerario e automoveis de corrida
736|2500700|1|Outros automoveis com motor explosao, de cilindrada superior a 1500 cm3, mas nao superior a 3000 cm3, exceto carro celular, carro funerario e automoveis de corrida
737|2500800|1|Automoveis com motor explosao, de cilindrada superior a 3000 cm3, com capacidade de transporte de pessoas sentadas inferior ou igual a 6, incluido o condutor, exceto carro celular, carro funerario e automoveis de corrida
738|2500900|1|Outros automoveis com motor explosao, de cilindrada superior a 3000 cm3, exceto carro celular, carro funerario e automoveis de corrida
739|2501000|1|Automoveis com motor diesel ou semidiesel, de cilindrada superior a 1500 cm3, mas nao superior a 2500 cm3, com capacidade de transporte de pessoas sentadas inferior ou igual a 6, incluido o condutor, exceto ambulancia, carro celular e carro funerario
740|2501100|1|Outros automoveis com motor diesel ou semidiesel, de cilindrada superior a 1500 cm3, mas nao superior a 2500 cm3, exceto ambulancia, carro celular e carro funerario
741|2501200|1|Automoveis com motor diesel ou semidiesel, de cilindrada superior a 2500 cm3, com capacidade de transporte de pessoas sentadas inferior ou igual a 6, incluido o condutor, exceto carro celular e carro funerario
742|2501300|1|Outros  automoveis  com  motor  diesel  ou  semidiesel,  de  cilindrada superior a 2500 cm3, exceto carro celular e carro funerario
743|2501400|1|Veiculos automoveis para transporte de mercadorias, de peso em carga maxima nao superior a 5 toneladas, chassis com motor diesel ou semidiesel e cabina, exceto caminhao de peso em carga maxima superior a 3,9 toneladas
744|2501500|1|Veiculos automoveis para transporte de mercadorias, de peso em carga maxima nao superior a 5 toneladas, com motor diesel ou semidiesel, com caixa basculante, exceto caminhao de peso em carga maxima superior a 3,9 toneladas
745|2501600|1|Veiculos automoveis para transporte de mercadorias, de peso em carga maxima nao superior a 5 toneladas, frigorificos ou isotermicos, com motor diesel ou semidiesel, exceto caminhao de peso em carga maxima superior a 3,9 toneladas
746|2501700|1|Outros veiculos automoveis para transporte de mercadorias, de peso em carga maxima nao superior a 5 toneladas, com motor diesel ou semidiesel, exceto carro-forte para transporte de valores e caminhao de peso em carga maxima superior a 3,9 toneladas
747|2501800|1|Veiculos automoveis para transporte de mercadorias, de peso em carga maxima nao superior a 5 toneladas, com motor a explosao, chassis e cabina, exceto caminhao de peso em carga maxima superior a 3,9 toneladas
748|2501900|1|Veiculos automoveis para transporte de mercadorias, de peso em carga maxima nao superior a 5, exceto caminhao de peso em carga toneladas, com motor explosao, caixa basculante maxima superior a 3,9 toneladas
749|2502000|1|Veiculos automoveis para transporte de mercadorias, de peso em carga maxima nao superior a 5 toneladas, frigorificos ou isotermicos com motor explosao, exceto caminhao de peso em carga maxima superior a 3,9 toneladas
750|2502100|1|Outros veiculos automoveis para transporte de mercadorias, de peso em carga maxima nao superior a 5 toneladas, com motor a explosao, exceto carro-forte para transporte de valores e caminhao de peso em carga maxima superior a 3,9 toneladas
751|2600100|1|Motocicletas (incluidos os ciclomotores) e outros ciclos equipados com motor auxiliar, mesmo com carro lateral; carros laterais
752|2700100|1|Espelhos de vidro, mesmo emoldurados, exceto os de uso automotivo
753|2700200|1|Objetos de vidro para servico de mesa ou de cozinha
754|2700300|1|Outros copos, exceto de vitroceramica
755|2700400|1|Objetos para servico de mesa (exceto copos) ou de cozinha, exceto de vitroceramica
756|2800100|1|Perfumes (extratos)
757|2800200|1|Aguas-de-colonia
758|2800300|1|Produtos de maquiagem para os labios
759|2800400|1|Sombra, delineador, lapis para sobrancelhas e rimel
760|2800500|1|Outros produtos de maquiagem para os olhos
761|2800600|1|Preparacoes para manicuros e pedicuros
762|2800700|1|Pos para maquiagem, incluindo os compactos
763|2800800|1|Cremes de beleza, cremes nutritivos e locoes tonicas
764|2800900|1|Outros produtos de beleza ou de maquiagem preparados e preparacoes para conservacao ou cuidados da pele, exceto as  preparacoes antisolares e os bronzeadores
765|2801000|1|Preparacoes antisolares e os bronzeadores
766|2801100|1|Xampus para o cabelo
767|2801200|1|Preparacoes para ondulacao ou alisamento, permanentes, dos cabelos
768|2801300|1|Outras preparacoes capilares
769|2801400|1|Tintura para o cabelo
770|2801500|1|Preparacoes para barbear (antes, durante ou apos)
771|2801600|1|Desodorantes corporais e antiperspirantes, liquidos
772|2801700|1|Outros desodorantes corporais e antiperspirantes
773|2801800|1|Outros produtos de perfumaria ou de toucador preparados
774|2801900|1|Outras preparacoes cosmeticas
775|2802000|1|Saboes de toucador, em barras, pedacos ou figuras moldadas
776|2802100|1|Outros saboes, produtos e preparacoes organicos tensoativos, inclusive papel, pastas (ouates), feltros e falsos tecidos, impregnados, revestidos ou recobertos de sabao ou de detergentes
777|2802200|1|Saboes de toucador sob outras formas
778|2802300|1|Produtos e preparacoes organicos tensoativos para lavagem da pele, em forma de liquido ou de creme, acondicionados para venda a retalho, mesmo contendo sabao
779|2802400|1|Lencos de papel, incluindo os de desmaquiar
780|2802500|1|Apontadores de lapis para maquiagem
781|2802600|1|Utensilios  e  sortidos  de  utensilios  de  manicuros  ou  de  pedicuros (incluindo as limas para unhas)
782|2802700|1|Escovas e pinceis de barba, escovas para cabelos, para cilios ou para unhas e outras escovas de toucador de pessoas
783|2802800|1|Pinceis para aplicacao de produtos cosmeticos
784|2802900|1|Vaporizadores de toucador, suas armacoes e cabecas de armacoes
785|2803000|1|Borlas ou esponjas para pos ou para aplicacao de outros cosmeticos ou de produtos de toucador
786|2803100|1|Malas e maletas de toucador
787|2803200|1|Pentes, travessas para cabelo e artigos semelhantes; grampos (alfinetes) para cabelo; pincas (pinceguiches), onduladores, bobs (rolos) e artefatos semelhantes para penteados, e suas partes
788|2803300|1|Mamadeiras
789|2803400|1|Chupetas e bicos para mamadeiras e para chupetas
790|2803500|1|Outros produtos cosmeticos e de higiene pessoal nao relacionados em outros itens deste anexo
791|2803600|1|Outros artigos destinados a cuidados pessoais nao relacionados em outros itens deste anexo
792|2803700|1|Acessorios (por exemplo, bijuterias, relogios, oculos de sol, bolsas, mochilas, frasqueiras, carteiras, porta-cartoes, porta-documentos, porta-celulares e embalagens presenteaveis (por exemplo, caixinhas de papel), entre outros itens assemelhados)
793|2803800|1|Vestuario e seus acessorios; calcados, polainas e artefatos semelhantes, e suas partes
794|2803900|1|Outros artigos de vestuario em geral, exceto os relacionados no item anterior
795|2804000|1|Artigos de casa
796|2804100|1|Produtos das industrias alimentares e bebidas
797|2804200|1|Produtos destinados a higiene bucal
798|2804300|1|Produtos de limpeza e conservacao domestica
799|2804400|1|Outros produtos comercializados pelo sistema de marketing direto porta-a-porta a consumidor  final nao relacionados em outros itens deste anexo